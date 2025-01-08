/*-----------------------------------------------------------------------
**  Programa..: esp/ftp/esftp138rp.p
-----------------------------------------------------------------------*/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i esftp138 2.00.00.000}

/*---------------------------  Variaveis    ---------------------------*/

//{include/i-rpvar.i}
{utp/ut-glob.i}

DEFINE VARIABLE h-acomp             AS HANDLE       NO-UNDO.


/*---------------------------  Temp-Tables  ---------------------------*/
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
    FIELD dt-emis-ini      AS DATE
    FIELD dt-emis-fim      AS DATE
    FIELD c-estab-ini      AS CHAR
    FIELD c-estab-fim      AS CHAR
    FIELD c-serie-ini      AS CHAR
    FIELD c-serie-fim      AS CHAR
    FIELD c-nota-ini       AS CHAR
    FIELD c-nota-fim       AS CHAR
    FIELD c-cod-depos      AS CHAR.
    /*Fim alteracao 15/02/2005*/

define temp-table tt-digita no-undo
    field deposito            AS CHAR FORMAT "x(3)"
    index id deposito.

DEFINE TEMP-TABLE tt-raw-digita NO-UNDO
   FIELD raw-digita         AS RAW.

/*---------------------------  Parƒmetros   ---------------------------*/
DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

FOR EACH tt-raw-digita NO-LOCK:
    CREATE tt-digita.
    RAW-TRANSFER tt-raw-digita.raw-digita TO tt-digita.
END.


/*---------------------------  Frames       ---------------------------*/
FIND FIRST param-global NO-LOCK.
FIND FIRST empresa      NO-LOCK WHERE empresa.ep-codigo = param-global.empresa-pri.

/*ASSIGN c-sistema      = "Espec¡ficos Intelbras"
       c-titulo-relat = "Relat¢rio de Embarque"
       c-empresa      = IF AVAILABLE empresa THEN empresa.razao-social ELSE ''
       c-programa     = "esftp138"
       c-versao       = "2.00"
       c-revisao      = "000".*/

//{include/i-rpcab.i}


/*---------------------------  Main Block   ---------------------------*/
RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
RUN pi-inicializar IN h-acomp (INPUT "Imprimindo...").

DEF VAR l-volta AS LOG NO-UNDO.

DEFINE TEMP-TABLE tt-impressao NO-UNDO
    FIELD cod-estabel LIKE nota-fiscal.cod-estabel
    FIELD serie       LIKE nota-fiscal.serie
    FIELD nr-nota-fis LIKE nota-fiscal.nr-nota-fis
    FIELD dt-emis-nota LIKE nota-fiscal.dt-emis-nota
    FIELD cod-depos   AS CHAR
    FIELD dt-saida     LIKE nota-fiscal.dt-saida
    FIELD it-codigo   LIKE it-nota-fisc.it-codigo
    FIELD desc-item   LIKE ITEM.desc-item
    FIELD qt-dif      AS DEC
    FIELD qt-nf       AS DEC
    FIELD qt-vol      AS DEC    
    INDEX id AS PRIMARY cod-estabel serie nr-nota-fis it-codigo.   

{esp/es0018.i}

DEFINE VARIABLE c-arquivo-csv AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-dir-saida   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-arq-excel   AS CHARACTER   NO-UNDO.

DEFINE STREAM str-excel.

DEFINE VARIABLE c-cod-depos AS CHARACTER   NO-UNDO.

DEF TEMP-TABLE tt-prog-ponto-tmp NO-UNDO
   FIELD nome-programa    LIKE ponto-programa.nome-programa
   FIELD ponto            LIKE ponto-programa.ponto
   FIELD sequencia        LIKE conteudo-programa.sequencia 
   FIELD conteudo         LIKE conteudo-programa.conteudo
   INDEX seq-campo nome-programa ponto sequencia.   
   
DEF BUFFER b-ponto-programa FOR ponto-programa.
DEF VAR i-sequencia AS INT NO-UNDO.
DEF VAR i-conteudo AS CHAR NO-UNDO.

FOR EACH b-ponto-programa WHERE 
         b-ponto-programa.nome-programa = "esftp004":
    RUN esp/es0018p.p (INPUT b-ponto-programa.nome-programa,
                       INPUT b-ponto-programa.ponto,
                       INPUT i-sequencia,
                       INPUT i-conteudo,
                       OUTPUT TABLE tt-prog-ponto) NO-ERROR.
    FOR EACH TT-PROG-PONTO:
        CREATE tt-prog-ponto-tmp.
        BUFFER-COPY TT-PROG-PONTO TO tt-prog-ponto-tmp.
    END.
END.

FOR EACH  nota-fiscal FIELDS(cod-estabel serie nr-nota-fis                              
                             dt-emis-nota dt-saida nat-operacao) USE-INDEX nfftrm-20 NO-LOCK
    WHERE nota-fiscal.dt-emis-nota >= tt-param.dt-emis-ini
      AND nota-fiscal.dt-emis-nota <= tt-param.dt-emis-fim
      AND nota-fiscal.cod-estabel  >= tt-param.c-estab-ini
      AND nota-fiscal.cod-estabel  <= tt-param.c-estab-fim
      AND nota-fiscal.serie        >= tt-param.c-serie-ini
      AND nota-fiscal.serie        <= tt-param.c-serie-fim
      AND nota-fiscal.nr-nota-fis  >= tt-param.c-nota-ini
      AND nota-fiscal.nr-nota-fis  <= tt-param.c-nota-fim
      AND nota-fiscal.dt-cancela = ?.

    RUN pi-acompanhar in h-acomp (input "Data: " + string(nota-fiscal.dt-emis-nota) + " Estab: " + nota-fiscal.cod-estabel + " Nf: " + nota-fiscal.nr-nota-fis).
    
    FOR EACH it-nota-fisc FIELDS(cod-estabel serie nr-nota-fis
                                 it-codigo qt-faturada nr-seq-fat) OF nota-fiscal NO-LOCK,
        FIRST natur-oper FIELDS(log-oper-triang baixa-estoq) OF it-nota-fisc NO-LOCK
        WHERE natur-oper.tipo = 2
          AND natur-oper.baixa-estoq. /* 2- saida */

        {esinc/es0004.i}        

        ASSIGN c-cod-depos = "".

        
        FOR FIRST fat-ser-lote FIELDS(cod-depos) NO-LOCK
            WHERE fat-ser-lote.cod-estabel = it-nota-fisc.cod-estabel
              AND fat-ser-lote.serie       = it-nota-fisc.serie
              AND fat-ser-lote.nr-nota-fis = it-nota-fisc.nr-nota-fis
              AND fat-ser-lote.nr-seq-fat  = it-nota-fisc.nr-seq-fat
              AND fat-ser-lote.it-codigo   = it-nota-fisc.it-codigo
              AND fat-ser-lote.cod-depos   = tt-param.c-cod-depos.

            ASSIGN c-cod-depos = fat-ser-lote.cod-depos.
        END.        
        IF NOT AVAIL fat-ser-lote THEN NEXT.        
        
        FIND FIRST tt-impressao 
             WHERE tt-impressao.cod-estabel = it-nota-fisc.cod-estabel
               AND tt-impressao.serie       = it-nota-fisc.serie
               AND tt-impressao.nr-nota-fis = it-nota-fisc.nr-nota-fis
               AND tt-impressao.it-codigo   = it-nota-fisc.it-codigo NO-ERROR.
        IF NOT AVAIL tt-impressao THEN DO:            

            CREATE tt-impressao.
            ASSIGN tt-impressao.cod-estabel  = it-nota-fisc.cod-estabel
                   tt-impressao.serie        = it-nota-fisc.serie      
                   tt-impressao.nr-nota-fis  = it-nota-fisc.nr-nota-fis
                   tt-impressao.it-codigo    = it-nota-fisc.it-codigo
                   tt-impressao.dt-emis-nota = nota-fiscal.dt-emis-nota
                   tt-impressao.dt-saida     = nota-fiscal.dt-saida
                    tt-impressao.cod-depos   = c-cod-depos.
           

            FOR FIRST ITEM fields(desc-item) NO-LOCK
                WHERE ITEM.it-codigo = it-nota-fisc.it-codigo.
                
                ASSIGN tt-impressao.desc-item = ITEM.desc-item.
            END.
        END.

        ASSIGN tt-impressao.qt-nf = tt-impressao.qt-nf + it-nota-fisc.qt-faturada[1].       
    END.

    FOR EACH  volume-nf fields(cod-estabel serie nr-nota-fis
                               it-codigo qtde) NO-LOCK
        WHERE volume-nf.cod-estabel = nota-fiscal.cod-estabel
          AND volume-nf.serie       = nota-fiscal.serie
          AND volume-nf.nr-nota-fis = nota-fiscal.nr-nota-fis.
        
        FIND FIRST tt-impressao 
             WHERE tt-impressao.cod-estabel = volume-nf.cod-estabel
               AND tt-impressao.serie       = volume-nf.serie
               AND tt-impressao.nr-nota-fis = volume-nf.nr-nota-fis
               AND tt-impressao.it-codigo   = volume-nf.it-codigo NO-ERROR.
        IF AVAIL tt-impressao THEN DO:
            ASSIGN tt-impressao.qt-vol = tt-impressao.qt-vol + volume-nf.qtde.
        END.        
    END.

    FOR EACH  tt-impressao 
        WHERE tt-impressao.cod-estabel = nota-fiscal.cod-estabel
          AND tt-impressao.serie       = nota-fiscal.serie
          AND tt-impressao.nr-nota-fis = nota-fiscal.nr-nota-fis.

        ASSIGN tt-impressao.qt-dif = tt-impressao.qt-nf - tt-impressao.qt-vol.
    END.
END.
 
ASSIGN c-arquivo-csv = "escdp123_" + REPLACE(STRING(DATE(TODAY),'99/99/9999'),'/','') + '_' + REPLACE(STRING(TIME,'HH:MM:SS'),':','') + ".csv":U.

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
    OS-CREATE-DIR VALUE(c-dir-saida).
    ASSIGN c-arq-excel = c-dir-saida + TRIM(c-arquivo-csv).
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

    ASSIGN c-dir-saida =  c-dir-saida + "/":U + c-seg-usuario + "/":U.
    OS-CREATE-DIR VALUE(c-dir-saida).
    ASSIGN c-arq-excel = c-dir-saida + TRIM(c-arquivo-csv).
END.

OUTPUT STREAM str-excel TO value(c-arq-excel) NO-CONVERT.

EXPORT STREAM str-excel DELIMITER ";"
    "Estab"
    "Serie"
    "Nota"
    "Dt.Emis"
    "Deposito"
    "Dt.Saida"
    "Item"
    "Descri‡Æo"
    "Qt.Diferen‡a"
    "Qt. NF"
    "Qt. Vol".

FOR EACH tt-impressao.

    RUN pi-acompanhar in h-acomp (input "Imprimindo NF: " + tt-impressao.nr-nota-fis).

    EXPORT STREAM str-excel DELIMITER ";" 
        tt-impressao.
END.

OUTPUT STREAM str-excel CLOSE.

RUN pi-finalizar in h-acomp.

IF NOT OPSYS = "unix" THEN DO:
    DOS SILENT START /*excel*/ VALUE(c-arq-excel).
END.

IF VALID-HANDLE(h-acomp) THEN
    DELETE OBJECT h-acomp.

RETURN "OK".
