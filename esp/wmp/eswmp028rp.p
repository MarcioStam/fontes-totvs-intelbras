{esp/es0018.i}
{utp/ut-glob.i}
define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field desc-classifica  as char format "x(40)":U
    field modelo           AS char format "x(35)":U
    /*Alterado 15/02/2005 - tech1007 - Criado campo l¢gico para verificar se o RTF foi habilitado*/
    field l-habilitaRtf    as LOG
    /*Fim alteracao 15/02/2005*/
    FIELD cEstab AS CHAR
    FIELD cEstabDepos AS CHAR
    FIELD da-data-ini AS DATE
    FIELD da-data-fim AS DATE
    FIELD c-item-ini AS CHAR
    FIELD c-item-fim AS CHAR. 

define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9":U
    field exemplo          as character format "x(30)":U
    index id ordem.

def temp-table tt-raw-digita
   field raw-digita      as raw.

DEFINE TEMP-TABLE tt-imprime NO-UNDO
    FIELD cod-depos-rem     AS CHAR
    FIELD nr-nota-fis-rem   AS CHAR
    FIELD dt-emis-nota-rem  LIKE nota-fiscal.dt-emis-nota
    FIELD cod-depos-ret     AS CHAR
    FIELD nr-nota-fis-ret   AS CHAR
    FIELD dt-emis-nota-ret  LIKE nota-fiscal.dt-emis-nota
    FIELD cod-depos-receb   AS CHAR
    FIELD dt-receb          AS DATE
    FIELD sla-fiscal        AS INT
    FIELD it-codigo         AS CHAR
    FIELD desc-item         AS CHAR
    FIELD qtde              AS DEC    
    FIELD r-rat-lote        AS ROWID        
    INDEX rat r-rat-lote.

DEFINE TEMP-TABLE tt-box NO-UNDO
    FIELD r-rowid-tt       AS ROWID
    FIELD posicao          AS CHAR
    FIELD ind-status       AS CHAR
    FIELD ind-origem       AS CHAR
    FIELD dt-movimento     AS DATE
    FIELD sla-aq           AS INT
    FIELD dt-armazena      AS DATE
    FIELD cod-local        AS CHAR
    FIELD qtd-item         AS DEC
    FIELD sla-armazenagem  AS INT
    FIELD sla-total        AS INT
    FIELD id-carga         AS DEC FORMAT ">>>>>>>>>>>>>9"
    FIELD dt-carga         AS DATE
    INDEX id AS PRIMARY r-rowid-tt.

DEFINE BUFFER bfwm-box FOR wm-box.

DEFINE BUFFER b-nota-fiscal  FOR nota-fiscal.
DEFINE BUFFER b-it-nota-fisc FOR it-nota-fisc.
DEFINE BUFFER b-fat-ser-lote FOR fat-ser-lote.

DEFINE VARIABLE c-posicao AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-serie AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-emit-depos AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-emit-estab AS INTEGER     NO-UNDO.

 DEF input parameter raw-param as raw no-undo.
 def input parameter table for tt-raw-digita.

DEFINE VARIABLE c-arquivo AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-dir-saida AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-arq-excel AS CHARACTER   NO-UNDO.

DEF VAR h-acomp         AS HANDLE NO-UNDO.

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
RUN pi-inicializar IN h-acomp (INPUT "Acompanhamento").

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

EMPTY TEMP-TABLE tt-prog-ponto.

DO ON STOP UNDO, LEAVE:

    ASSIGN c-arquivo = "eswmp028_" + REPLACE(STRING(DATE(TODAY),'99/99/9999'),'/','') + '_' + REPLACE(STRING(TIME,'HH:MM:SS'),':','') + ".csv":U.

    IF  OPSYS = "unix" THEN DO:        
    
        RUN esp/es0018p.p (INPUT "SPOOL-UNIX":U,
                           INPUT 1,
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-ponto).
    
        FOR FIRST tt-prog-ponto:
            ASSIGN c-dir-saida = REPLACE(tt-prog-ponto.conteudo, "~\":U, "/":U).
        END. /* FOR FIRST tt-prog-ponto: */

        ASSIGN c-dir-saida =  c-dir-saida + "/":U + c-seg-usuario + "/":U.
        OS-CREATE-DIR VALUE(c-dir-saida).
        ASSIGN c-arq-excel = c-dir-saida + TRIM(c-arquivo).
    END. /* IF  OPSYS = "unix" THEN DO: */
    ELSE DO:        
    
        RUN esp/es0018p.p (INPUT "SPOOL-WIN":U,
                           INPUT 1,
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-ponto).
    
        FOR FIRST tt-prog-ponto:
            ASSIGN c-dir-saida = REPLACE(tt-prog-ponto.conteudo, "/":U, "~\":U).
        END. /* FOR FIRST tt-prog-ponto: */

        ASSIGN c-dir-saida =  c-dir-saida + "/":U + c-seg-usuario + "/":U.
        OS-CREATE-DIR VALUE(c-dir-saida).
        ASSIGN c-arq-excel = c-dir-saida + TRIM(c-arquivo).
    END.
END.

ASSIGN c-serie = "1".

FOR FIRST estabelec NO-LOCK
    WHERE estabelec.cod-estabel = tt-param.cEstabDepos.

    ASSIGN i-emit-depos = estabelec.cod-emitente.
END.
FOR FIRST estabelec NO-LOCK
    WHERE estabelec.cod-estabel = tt-param.cEstab.

    ASSIGN i-emit-estab = estabelec.cod-emitente.
END.

RELEASE estabelec.

FOR EACH  nota-fiscal NO-LOCK
    WHERE nota-fiscal.cod-estabel    = tt-param.cEstab
      AND nota-fiscal.serie          = c-serie
      AND nota-fiscal.cod-emitente   = i-emit-depos
      AND nota-fiscal.dt-cancela     = ?
      AND nota-fiscal.dt-emis-nota  >= tt-param.da-data-ini
      AND nota-fiscal.dt-emis-nota  <= tt-param.da-data-fim
      AND nota-fiscal.nat-operacao BEGINS "5".      

    RUN pi-acompanhar IN h-acomp(INPUT 'Gerando dados NF Remessa: ' + nota-fiscal.nr-nota-fis ).

    FOR EACH  it-nota-fisc OF nota-fiscal NO-LOCK
        WHERE it-nota-fisc.it-codigo >= tt-param.c-item-ini
          AND it-nota-fisc.it-codigo <= tt-param.c-item-fim,
        EACH  fat-ser-lote OF it-nota-fisc NO-LOCK.

        CREATE tt-imprime.
        ASSIGN tt-imprime.cod-depos-rem    = fat-ser-lote.cod-depos
               tt-imprime.nr-nota-fis-rem  = fat-ser-lote.nr-nota-fis
               tt-imprime.dt-emis-nota-rem = nota-fiscal.dt-emis-nota
               tt-imprime.it-codigo        = fat-ser-lote.it-codigo
               tt-imprime.qtde             = fat-ser-lote.qt-baixada[1].

        FOR FIRST wm-item NO-LOCK
            WHERE wm-item.cod-item = fat-ser-lote.it-codigo.

            ASSIGN tt-imprime.desc-item = wm-item.des-item.
        END.

        FOR FIRST b-nota-fiscal NO-LOCK
            WHERE b-nota-fiscal.cod-estabel = tt-param.cEstabDepos
              AND b-nota-fiscal.serie       = c-serie
              AND b-nota-fiscal.observ-nota MATCHES "*Retorno Ref. a NF: " + nota-fiscal.nr-nota-fis + "/" + nota-fiscal.serie + "*".

            FOR FIRST b-it-nota-fisc OF b-nota-fiscal NO-LOCK
                WHERE b-it-nota-fisc.nr-seq-fat = it-nota-fisc.nr-seq-fat
                  AND b-it-nota-fisc.it-codigo  = it-nota-fisc.it-codigo,
                FIRST b-fat-ser-lote OF b-it-nota-fisc NO-LOCK
                WHERE b-fat-ser-lote.nr-serlote  = fat-ser-lote.nr-serlote
                  AND b-fat-ser-lote.it-codigo   = fat-ser-lote.it-codigo
                  AND b-fat-ser-lote.cod-refer   = fat-ser-lote.cod-refer.

                ASSIGN tt-imprime.cod-depos-ret    = b-fat-ser-lote.cod-depos
                       tt-imprime.nr-nota-fis-ret  = b-nota-fiscal.nr-nota-fis
                       tt-imprime.dt-emis-nota-ret = b-nota-fiscal.dt-emis-nota.

                FOR EACH  docum-est NO-LOCK
                    WHERE docum-est.cod-emitente = i-emit-depos
                      AND docum-est.nro-docto    = b-nota-fiscal.nr-nota-fis
                      AND docum-est.serie-docto  = b-nota-fiscal.serie,
                    EACH  item-doc-est OF docum-est NO-LOCK
                    WHERE item-doc-est.it-codigo = b-it-nota-fisc.it-codigo,
                    EACH  rat-lote OF item-doc-est NO-LOCK
                    WHERE rat-lote.lote       = b-fat-ser-lote.nr-serlote
                      AND rat-lote.cod-refer  = b-fat-ser-lote.cod-refer
                      AND rat-lote.quantidade = b-fat-ser-lote.qt-baixada[1].

                    IF CAN-FIND(FIRST tt-imprime
                                WHERE tt-imprime.r-rat-lote = ROWID(rat-lote)) THEN NEXT.                    
                    
                    ASSIGN tt-imprime.dt-receb        = docum-est.dt-atualiza
                           tt-imprime.cod-depos-receb = rat-lote.cod-depos
                           tt-imprime.r-rat-lote      = ROWID(rat-lote).
                    
                    FOR EACH  wm-docto NO-LOCK
                        WHERE wm-docto.cod-estabel     = docum-est.cod-estabel
                          AND (wm-docto.cod-local      = "WEX" OR
                               wm-docto.cod-local      = "WFT")
                          AND wm-docto.num-docto       = docum-est.nro-docto
                          AND wm-docto.dt-implan-docto = docum-est.dt-atualiza.

                        FOR EACH  wm-box-movto OF wm-docto NO-LOCK
                            WHERE wm-box-movto.cod-item       = item-doc-est.it-codigo
                              AND wm-box-movto.cod-lote       = rat-lote.lote
                              AND wm-box-movto.cod-refer      = rat-lote.cod-refer
                              AND wm-box-movto.ind-tipo-movto = 1.                                    
                        
                            CREATE tt-box.
                            ASSIGN tt-box.r-rowid-tt = ROWID(tt-imprime).
                            
                            RUN retornaEnderecoBox4(INPUT wm-docto.cod-estabel,
                                                    INPUT wm-docto.cod-local,
                                                    INPUT wm-box-movto.id-box,
                                                    OUTPUT c-posicao).
                            
                            ASSIGN tt-box.posicao    = c-posicao
                                   tt-box.cod-local  = wm-docto.cod-local
                                   tt-box.ind-status = {scinc/i02sc032.i 4 wm-box-movto.ind-status-movto} 
                                   tt-box.ind-origem = {scinc/i03sc038.i 4 wm-docto.ind-origem-docto}                                   
                                   tt-box.qtd-item    = wm-box-movto.qtd-item
                                   tt-box.id-carga   = wm-docto.id-carga.

                            FOR FIRST wm-carga NO-LOCK
                                WHERE wm-carga.id-carga = wm-docto.id-carga.

                                ASSIGN tt-box.dt-carga = wm-carga.dt-geracao.
                            END.

                            FOR FIRST wm-tarefa-docto-itens NO-LOCK
                                WHERE wm-tarefa-docto-itens.cod-estabel = wm-box-movto.cod-estabel
                                  AND wm-tarefa-docto-itens.cod-local   = wm-box-movto.cod-local
                                  AND wm-tarefa-docto-itens.id-movto    = wm-box-movto.id-movto.
                                
                                ASSIGN tt-box.dt-armazena = wm-tarefa-docto-itens.dt-fim-tarefa.
                            END.

                            FOR EACH  wm-roteiro-docto-itens NO-LOCK
                                WHERE wm-roteiro-docto-itens.cod-estabel  = wm-box-movto.cod-estabel
                                  AND wm-roteiro-docto-itens.cod-local    = wm-box-movto.cod-local
                                  AND wm-roteiro-docto-itens.id-docto     = wm-box-movto.id-docto
                                  AND wm-roteiro-docto-itens.num-seq-item = wm-box-movto.num-seq-item,
                                FIRST ficha-cq NO-LOCK
                                WHERE ficha-cq.nr-ficha = wm-roteiro-docto-itens.nr-ficha
                                  AND ficha-cq.situacao = 4 /* 4- Terminado */.
                                
                                ASSIGN tt-box.dt-movimento = ficha-cq.dt-analise.

                            END.
                        END.
                    END.
                END.
            END.
        END.       
    END.  
END.

FOR EACH tt-imprime.

    IF tt-imprime.dt-receb NE  ? THEN
        ASSIGN tt-imprime.sla-fiscal = tt-imprime.dt-receb - tt-imprime.dt-emis-nota-rem.
    ELSE IF tt-imprime.dt-emis-nota-ret NE ? THEN
        ASSIGN tt-imprime.sla-fiscal = tt-imprime.dt-emis-nota-ret - tt-imprime.dt-emis-nota-rem.
    ELSE
        ASSIGN tt-imprime.sla-fiscal = TODAY - tt-imprime.dt-emis-nota-rem.
    
    FOR EACH  tt-box
        WHERE tt-box.r-rowid-tt = ROWID(tt-imprime)
        BREAK BY tt-box.r-rowid-tt.
    
        IF (tt-imprime.cod-depos-receb = "WEX" OR tt-imprime.cod-depos-receb = "WFT") THEN DO:
            ASSIGN tt-box.sla-aq = 0.

            IF tt-box.dt-armazena NE ? THEN
                ASSIGN tt-box.sla-armazenagem = tt-box.dt-armazena - tt-imprime.dt-receb.
            ELSE
                ASSIGN tt-box.sla-armazenagem = TODAY - tt-imprime.dt-receb.
        END.            
        ELSE IF tt-imprime.cod-depos-receb = "REC" THEN DO:

            IF tt-box.dt-movimento NE ? THEN
                ASSIGN tt-box.sla-aq = tt-box.dt-movimento - tt-imprime.dt-receb.
            ELSE
                ASSIGN tt-box.sla-aq = TODAY - tt-imprime.dt-receb.

            IF tt-box.dt-armazena NE ? THEN
                ASSIGN tt-box.sla-armazenagem = tt-box.dt-armazena - tt-imprime.dt-receb.
            ELSE
                ASSIGN tt-box.sla-armazenagem = TODAY - tt-imprime.dt-receb.
        END.
        ELSE DO:

            IF tt-box.dt-movimento NE ? THEN
                ASSIGN tt-box.sla-aq = tt-box.dt-movimento - tt-imprime.dt-receb.
            ELSE
                ASSIGN tt-box.sla-aq = TODAY - tt-imprime.dt-receb.

            IF tt-box.dt-armazena NE ? THEN
                ASSIGN tt-box.sla-armazenagem = tt-box.dt-armazena - tt-box.dt-movimento.
            ELSE
                ASSIGN tt-box.sla-armazenagem = TODAY - tt-box.dt-movimento.
        END.        
    
        ASSIGN tt-box.sla-total = tt-box.sla-armazenagem + tt-box.sla-aq + tt-imprime.sla-fiscal.
    END.

END.

output to VALUE(c-arq-excel).

EXPORT DELIMITER ";"
    "Deposito Rem."
    "Nota Remessa"
    "Data Rem."
    "Deposito Ret."
    "Nota Retorno"
    "Data Ret."    
    "Deposito Lanc."
    "Data Lancamento"
    "SLA Fiscal"
    "Deposito Destino"
    "Data movimento"
    "SLA AQ"
    "Item"
    "Descricao"    
    "Qt.NF"
    "Qt.Posicao"    
    "Posicao"
    "Status"    
    "Origem Entrada"
    "Id Carga"
    "Dt.Carga"
    "Data Armazenamento"
    "SLA armazenagem"
    "SLA Total".

FOR EACH tt-imprime.    

    RUN pi-acompanhar IN h-acomp(INPUT 'Imprimindo: ' + tt-imprime.nr-nota-fis-rem ).    

    FOR EACH  tt-box
        WHERE tt-box.r-rowid-tt = ROWID(tt-imprime)
        BREAK BY tt-box.r-rowid-tt.

        PUT UNFORMATTED 
            tt-imprime.cod-depos-rem     ";"
            tt-imprime.nr-nota-fis-rem   ";"
            tt-imprime.dt-emis-nota-rem  ";"
            tt-imprime.cod-depos-ret     ";"
            tt-imprime.nr-nota-fis-ret   ";"
            tt-imprime.dt-emis-nota-ret  ";"            
            tt-imprime.cod-depos-receb   ";"
            tt-imprime.dt-receb          ";"
            tt-imprime.sla-fiscal        ";"
            tt-box.cod-local             ";"
            tt-box.dt-movimento          ";"
            tt-box.sla-aq                ";"           
            tt-imprime.it-codigo         ";"
            tt-imprime.desc-item         ";"
            tt-imprime.qtde              ";"
            tt-box.qtd-item              ";"
            tt-box.posicao               ";"
            tt-box.ind-status            ";"
            tt-box.ind-origem            ";"
            tt-box.id-carga              ";"
            tt-box.dt-carga              ";"
            tt-box.dt-armazena           ";"
            tt-box.sla-armazenagem       ";" 
            tt-box.sla-total             SKIP.        
    END.

    IF NOT CAN-FIND(FIRST tt-box
                    WHERE tt-box.r-rowid-tt = ROWID(tt-imprime)) THEN DO:
        PUT UNFORMATTED SKIP.        
    END.
END.

output close.

RUN pi-finalizar IN h-acomp.

IF NOT OPSYS = "unix" THEN DO:
    DOS SILENT START /*excel*/ VALUE(c-arq-excel).
END.                         

RETURN "OK".

PROCEDURE retornaEnderecoBox4 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pCodEstabel AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER pCodLocal   AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER pIdBox      AS DECIMAL   NO-UNDO.
    DEFINE OUTPUT PARAMETER pEndereco   AS CHARACTER NO-UNDO.
   
    DEFINE VAR c-lado AS CHARACTER FORMAT "X(3)" NO-UNDO.
    ASSIGN pEndereco  = ""
           c-lado     = "".
                     

    FIND FIRST bfWm-box
         WHERE bfWm-box.cod-estabel = pCodEstabel AND
               bfWm-box.cod-local   = pCodLocal   AND
               bfWm-box.id-box      = pIdBox      NO-LOCK NO-ERROR.
    
    FIND FIRST wm-param NO-LOCK NO-ERROR.

   
    IF AVAIL bfWm-box THEN DO:
        ASSIGN pEndereco  = bfWm-box.cod-bloco + '/' + bfWm-box.cod-rua + '/' + bfWm-box.cod-nivel + '/'+ bfWm-box.cod-coluna              
               c-lado = SUBSTRING({scinc/i02sc030.i 04 bfWm-box.ind-posicao-box},1,3).

        IF wm-param.log-controla-posicao = TRUE THEN
            ASSIGN pEndereco  = pEndereco + '/' + c-lado.
    END.

    
    RETURN "OK":U.
END PROCEDURE.
