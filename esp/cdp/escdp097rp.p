{include/i-prgvrs.i escdp0903RP 1.00.00.000}
{include/i-rpvar.i}
{esp/es0018.i}
{utp/ut-glob.i}
{method/dbotterr.i}

DEFINE TEMP-TABLE tt-registro NO-UNDO
      FIELD it-codigo    LIKE ITEM.it-codigo
      FIELD cod-estabel  LIKE item-uni-estab.cod-estabel
      FIELD origem       AS CHAR
      FIELD ft-conv      AS CHAR.

DEFINE TEMP-TABLE tt-param
    FIELD destino          AS INTEGER
    FIELD arq-destino      AS CHAR
    FIELD arq-entrada      AS CHAR
    FIELD todos            AS INTEGER
    FIELD usuario          AS CHAR
    FIELD data-exec        AS DATE
    FIELD hora-exec        AS INTEGER
    FIELD rs-considera     AS INT   
    FIELD rs-faturavel     AS INT
    FIELD l-item-origem    AS LOG. 

def temp-table tt-raw-digita
   field raw-digita      as raw.

DEF TEMP-TABLE tt-erro
    FIELD mensagem AS CHAR.

DEF INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEF INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

DEFINE VARIABLE h-acomp     AS HANDLE  NO-UNDO.
DEFINE VARIABLE c-dir-saida AS CHAR    NO-UNDO.
DEFINE VARIABLE h-bodi538   AS HANDLE  NO-UNDO.
DEFINE VARIABLE c-indice    AS CHAR    NO-UNDO.
DEFINE VARIABLE c-arq-temp  AS CHAR    NO-UNDO.
DEFINE VARIABLE l-alterou   AS LOG     NO-UNDO.
DEFINE VARIABLE c-estados   AS CHAR    NO-UNDO.
DEFINE VARIABLE i-cont      AS INT     NO-UNDO.

DEFINE TEMP-TABLE ttItensUF-elim NO-UNDO
    FIELD it-codigo    AS CHAR FORMAT "X(16)"
    FIELD uf-orig      AS CHAR FORMAT "X(02)"
    FIELD uf-dest      AS CHAR FORMAT "X(02)"
    FIELD aliq-icms    AS DEC  FORMAT ">>>>9.99<<<"
    FIELD desc-item    AS CHAR FORMAT "X(100)"
    FIELD r-inf-compl  AS ROWID
    FIELD r-Rowid      AS ROWID
    INDEX ch-ttItensUF IS PRIMARY UNIQUE it-codigo uf-orig uf-dest
    INDEX ch-UF uf-orig uf-dest.

ASSIGN c-programa 	  = "escdp0903RP"
       c-titulo-relat = "Importacao Itens faturaveis".

FIND FIRST tt-param NO-ERROR.

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
RUN pi-inicializar IN h-acomp (INPUT "Importando").


DO ON STOP UNDO, LEAVE:

    IF  OPSYS = "unix" THEN DO:
        EMPTY TEMP-TABLE tt-prog-ponto.
    
        RUN esp/es0018p.p (INPUT "SPOOL-UNIX":U,
                           INPUT 1,
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-ponto).
    
        FOR FIRST tt-prog-ponto:
            ASSIGN c-dir-saida = REPLACE(tt-prog-ponto.conteudo, "~\":U, "/":U).
        END. /* FOR FIRST tt-prog-ponto: */

        ASSIGN c-dir-saida =  c-dir-saida + "/":U + c-seg-usuario + "/":U.
    END. /* IF  OPSYS = "unix" THEN DO: */
    ELSE DO:
        EMPTY TEMP-TABLE tt-prog-ponto.
    
        RUN esp/es0018p.p (INPUT "SPOOL-WIN":U,
                           INPUT 1,
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-ponto).
    
        FOR FIRST tt-prog-ponto:
            ASSIGN c-dir-saida = REPLACE(tt-prog-ponto.conteudo, "/":U, "~\":U).
        END. /* FOR FIRST tt-prog-ponto: */

        ASSIGN c-dir-saida = c-dir-saida + "\":U + c-seg-usuario + "\":U.
    END.
    ASSIGN c-dir-saida = c-dir-saida + "escdp097_" + STRING(TIME) + ".lst":U.
END.

/*Importar*/

//INPUT STREAM s-imp FROM VALUE(tt-param.arq-entrada).

RUN esp/es0018p.p (INPUT "CD0903":U,
                   INPUT 1,
                   INPUT 0,
                   INPUT "":U,
                   OUTPUT TABLE tt-prog-ponto).

ASSIGN c-estados = ''.

FOR EACH tt-prog-ponto:
    ASSIGN c-estados = IF c-estados = '' THEN tt-prog-ponto.conteudo ELSE c-estados + ',' + tt-prog-ponto.conteudo.
END.         

blk_import:
DO ON ERROR UNDO, RETURN ERROR
   ON STOP  UNDO, RETURN ERROR:

    EMPTY TEMP-TABLE tt-registro.     

    /*
    IF OPSYS = 'UNIX' THEN 
       ASSIGN tt-param.arq-destino = c-dir-saida.*/

    {include/i-rpout.i &STREAM="stream str-rp" &TOFILE=tt-param.arq-destino}
    {include/i-rpcab.i &STREAM="str-rp"}

    VIEW STREAM str-rp FRAME f-cabec.
    VIEW STREAM str-rp FRAME f-rodape.

    IF OPSYS = 'UNIX' THEN DO:
       ASSIGN tt-param.arq-entrada = REPLACE(tt-param.arq-entrada,"\","/")
              tt-param.arq-entrada = REPLACE(tt-param.arq-entrada,"//erpapp/spool/","/mnt/spool/").
    END.

    //Importacao do arquivo
    INPUT FROM VALUE(tt-param.arq-entrada) CONVERT SOURCE "iso8859-1".

    REPEAT:
        CREATE tt-registro.
        IMPORT DELIMITER ";" tt-registro.
    END.
    INPUT CLOSE.

    
    FOR EACH tt-registro:
    
          IF tt-registro.it-codigo = "" THEN NEXT.

          RUN pi-acompanhar in h-acomp (input "Item: "  + tt-registro.it-codigo ).

          
         IF tt-param.rs-considera = 1 THEN DO: /* Considera Valida‡äes */
         
             FIND FIRST ITEM NO-LOCK 
                  WHERE ITEM.it-codigo =  tt-registro.it-codigo NO-ERROR.
             IF NOT AVAIL ITEM THEN DO:
                  PUT stream str-rp "Item NÆo Encontrado "   tt-registro.it-codigo SKIP.
         
                 NEXT.
             END.
         
             FIND FIRST item-mat EXCLUSIVE-LOCK 
                  WHERE item-mat.it-codigo = item.it-codigo NO-ERROR.
         
             IF ITEM.peso-bruto   = 0
             OR ITEM.peso-liquido = 0 THEN DO:
                 PUT stream str-rp "Item Com Peso NÆo Cadastrado "   tt-registro.it-codigo SKIP.
                 NEXT.
             END.
         
             IF ITEM.altura       = 0
             OR ITEM.largura      = 0
             OR ITEM.comprim      = 0 THEN DO:
                 PUT stream str-rp "Item Com Medidas NÆo Cadastradas "   tt-registro.it-codigo SKIP.
                 NEXT.
             END.
         
             IF ITEM.class-fiscal = "" THEN DO:
                 PUT stream str-rp "Item Com Classifica‡Æo Fiscal NÆo Cadastrada "   tt-registro.it-codigo SKIP.
                 NEXT.
             END.
         
             IF ITEM.fm-cod-com = "" THEN DO:
                 PUT stream str-rp "Item Com Fam¡lia Comercial NÆo Cadastrada "   tt-registro.it-codigo SKIP.
                 NEXT.
             END.
         
             IF  ITEM.it-codigo BEGINS "4"
             AND item-mat.cod-ean = "" THEN DO:
                 PUT stream str-rp "Item Com - C¢digo EAN ou C¢d GTIN (Trib.) NÆo Cadastrado "   tt-registro.it-codigo SKIP.
                 NEXT.
             END.
         
             IF  ITEM.cod-dcr-item = "" 
             AND ITEM.codigo-orig  = 4
             AND tt-registro.cod-estabel = "105" THEN DO:
                 PUT stream str-rp "Item Com DCR  NÆo Cadastrado "   tt-registro.it-codigo SKIP.
                 NEXT.
             END.               
         
         END. /* IF INPUT FRAME fPage2 rsTipo = 1 THEN DO: */
         
         FIND ITEM EXCLUSIVE-LOCK 
             WHERE ITEM.it-codigo =  tt-registro.it-codigo NO-ERROR.
         IF AVAIL ITEM THEN DO:
         
             IF tt-registro.cod-estabel = ""  THEN DO:
                 IF tt-param.rs-faturavel = 1 THEN
                     ASSIGN ITEM.ind-item-fat = YES.
                 ELSE
                     ASSIGN ITEM.ind-item-fat = NO.
         

                 IF tt-param.l-item-origem AND tt-registro.origem <> "" THEN
                    ASSIGN ITEM.codigo-orig  = int(tt-registro.origem).

                 OVERLAY(item.char-1,321,20) = tt-registro.ft-conv.
         
                 PUT stream str-rp "Item Alterado " ITEM.it-codigo " Faturavel " ITEM.ind-item-fat SKIP.
                 for each item-uni-estab
                     where item-uni-estab.it-codigo   = item.it-codigo exclusive-lock:
                       IF tt-param.rs-faturavel = 1 THEN
                           assign item-uni-estab.ind-item-fat         = YES.
                       ELSE
                           assign item-uni-estab.ind-item-fat         = NO.
                       PUT stream str-rp "Item do Estabelecimento Alterado " item-uni-estab.it-codigo " Estab : " item-uni-estab.cod-estabel " Faturavel " ITEM-uni-estab.ind-item-fat SKIP.
                 end.
             END.
             ELSE DO:
                 IF tt-registro.cod-estabel <> "" THEN DO:
                    IF tt-param.rs-faturavel = 1 THEN DO:
                         ASSIGN ITEM.ind-item-fat = YES.
                         PUT stream str-rp "Item Alterado " ITEM.it-codigo " Faturavel " ITEM.ind-item-fat SKIP.
                    END.
         
                    IF tt-param.l-item-origem AND tt-registro.origem <> "" THEN 
                       ASSIGN ITEM.codigo-orig = int(tt-registro.origem). 

                    OVERLAY(item.char-1,321,20) = tt-registro.ft-conv.
         
                    FOR each item-uni-estab
                       where item-uni-estab.it-codigo   = item.it-codigo 
                         AND item-uni-estab.cod-estabel = tt-registro.cod-estabel exclusive-lock:
         
                          IF tt-param.rs-faturavel = 1 THEN
                              assign item-uni-estab.ind-item-fat = YES.
                          ELSE
                              assign item-uni-estab.ind-item-fat = NO.

                          IF tt-registro.origem <> "" THEN 
                             ASSIGN OVERLAY(item-uni-estab.char-2,18,3) = tt-registro.origem. 


                          PUT stream str-rp "Item do Estabelecimento Alterado " item-uni-estab.it-codigo " Estab : " item-uni-estab.cod-estabel " Faturavel " ITEM-uni-estab.ind-item-fat SKIP.
                     end.
                  END.
             END.
         
             /*Atualiza cd0908*/
             IF NOT VALID-HANDLE(h-bodi538) THEN
                 RUN dibo/bodi538.p PERSISTENT SET h-bodi538.
          
             IF ITEM.codigo-orig = 1 
             OR ITEM.codigo-orig = 2 
             OR ITEM.codigo-orig = 3 
             OR ITEM.codigo-orig = 8 THEN DO:
         
                    ASSIGN l-alterou = NO.
                
                    FOR EACH unid-feder
                        WHERE unid-feder.estado <> "EX"
                          AND unid-feder.estado <> "FL"
                          AND unid-feder.estado <> "KY" NO-LOCK:
                
                        DO i-cont = 1 TO NUM-ENTRIES(c-estados):
                           IF unid-feder.estado <> ENTRY(i-cont,c-estados) THEN DO:
                              ASSIGN c-indice = "":U
                                     c-indice = (TRIM(ITEM.it-codigo) + CHR(2) +
                                                 TRIM(ENTRY(i-cont,c-estados)) + CHR(2) +
                                                 TRIM(unid-feder.estado)) NO-ERROR.
                        
                              FIND FIRST inf-compl NO-LOCK
                                   WHERE inf-compl.cdn-identif = 5
                                     AND inf-compl.cod-indice  = c-indice NO-ERROR. /*Item + UF Orig + UF Dest*/
                             
                              IF NOT AVAIL inf-compl THEN DO:
                                  ASSIGN l-alterou = YES.
                                  RUN pi-Inclui-Altera-ItensUF IN h-bodi538 (INPUT ITEM.it-codigo,
                                                                             INPUT ENTRY(i-cont,c-estados),
                                                                             INPUT unid-feder.estado,
                                                                             INPUT 4).        
                              END. 
                           END.    
                        END.
                    END.
                    /*IF l-alterou THEN
                        RUN utp/ut-msgs.p (INPUT "show",
                                           INPUT 15825,
                                           INPUT "Gerado cadastro de ICMS Diferenciado em Opera‡äes Interestaduais para " + c-estados). */
               
             END.
             ELSE IF ITEM.codigo-orig = 0 
                  OR ITEM.codigo-orig = 4 
                  OR ITEM.codigo-orig = 5 
                  OR ITEM.codigo-orig = 6 
                  OR ITEM.codigo-orig = 7 THEN DO:
          
                 RUN pi-Elimina-ItensUF IN h-bodi538 (INPUT ITEM.it-codigo,
                                                      INPUT ITEM.it-codigo,
                                                      INPUT "",
                                                      INPUT "ZZZZ",
                                                      INPUT "",
                                                      INPUT "ZZZZ",
                                                      OUTPUT TABLE ttItensUF-elim).
             END.
          
             IF VALID-HANDLE(h-bodi538) THEN
                 DELETE PROCEDURE h-bodi538.
         
         END. /* IF AVAIL ITEM THEN DO: */
    END.
    RUN pi-finalizar in h-acomp.

    OUTPUT STREAM str-rp CLOSE.

    IF c-dir-saida <> '' THEN
       OS-COPY VALUE(tt-param.arq-destino) VALUE(c-dir-saida).
        
    
END. //on error
RETURN "OK":U.
