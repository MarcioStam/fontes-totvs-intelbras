{include/i-prgvrs.i esftp128rp 2.00.00.001}
{esp/esb/esesb000.i}
{esp/wso/out/wso0005.i}

{esp/es0018.i}

DEFINE VARIABLE oXML          AS LONGCHAR NO-UNDO.

DEFINE VARIABLE c-arquivo-csv AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-dir-saida   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-arq-excel   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE h-acomp       AS HANDLE      NO-UNDO.

DEFINE STREAM str-excel.

DEFINE BUFFER empresa FOR emscad.empresa.

define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)"
    field usuario          as char format "x(12)"
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field desc-classifica  as char format "x(40)"
    field modelo-rtf       as char format "x(35)"
    field l-habilitaRtf    as LOG
    FIELD cod-estab-ini    AS CHAR
    FIELD cod-estab-fim    AS CHAR
    FIELD serie-ini        AS CHAR
    FIELD serie-fim        AS CHAR
    FIELD nr-nota-ini      AS CHAR
    FIELD nr-nota-fim      AS CHAR
    FIELD dt-emiss-ini     AS DATE
    FIELD dt-emiss-fim     AS DATE
    FIELD dia-atual        AS LOG.
/*
    field fi-tab-ini       AS CHAR
    field fi-tab-fim       AS CHAR
    field fi-item-ini      AS CHAR
    field fi-item-fim      AS CHAR.
*/    
DEFINE TEMP-TABLE tt-digita NO-UNDO
    FIELD ordem            AS INTEGER   FORMAT ">>>>9":U
    FIELD exemplo          AS CHARACTER FORMAT "x(30)":U
    INDEX id ordem.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.

DEFINE input parameter raw-param as raw no-undo.
DEFINE input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

FIND FIRST tt-param.

DEF VAR qtd-dispon LIKE preco-item.quant-min.
DEF VAR l-central-config AS LOG NO-UNDO.
DEF VAR c-chave AS CHAR NO-UNDO.

{utp/ut-glob.i}

DO ON STOP UNDO, LEAVE:

    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
    RUN pi-inicializar in h-acomp (input "Integrando ...").

    IF tt-param.dia-atual THEN
        ASSIGN tt-param.dt-emiss-ini = TODAY
               tt-param.dt-emiss-fim = TODAY.

    FOR EACH nota-fiscal NO-LOCK
       WHERE nota-fiscal.cod-estabel >= tt-param.cod-estab-ini
         AND nota-fiscal.cod-estabel <= tt-param.cod-estab-fim
         AND nota-fiscal.serie >= tt-param.serie-ini
         AND nota-fiscal.serie <= tt-param.serie-fim
         AND nota-fiscal.nr-nota-fis >= tt-param.nr-nota-ini
         AND nota-fiscal.nr-nota-fis <= tt-param.nr-nota-fim
         AND nota-fiscal.dt-emis >= tt-param.dt-emiss-ini
         AND nota-fiscal.dt-emis <= tt-param.dt-emiss-fim
         AND nota-fiscal.idi-sit-nf-eletro = 3, /*Autorizada*/
       FIRST int-pedido-vtex NO-LOCK
       WHERE int-pedido-vtex.nr-pedcli = nota-fiscal.nr-pedcli:

        run pi-acompanhar in h-acomp (input "Lendo NF: " + nota-fiscal.nr-nota-fis).

        ASSIGN c-chave = nota-fiscal.cod-chave-aces-nf-eletro.

        IF int-pedido-vtex.marketplace = "BWW" THEN DO:
            RUN pi-integra-etiqueta.
        END.
    END.
END.

RUN pi-finalizar IN h-acomp.

PROCEDURE pi-integra-etiqueta:

    DEF VAR c-plp AS CHAR NO-UNDO.

    /* AGRUPAR PLP DA ETIQUETA */
    RUN esp/ftp/esftp128rpa.p (INPUT  ENTRY(2,int-pedido-vtex.tid,"-"),
                               OUTPUT c-plp).

    IF AVAIL int-pedido-vtex THEN DO:
        FIND CURRENT int-pedido-vtex EXCLUSIVE-LOCK NO-ERROR.
        ASSIGN int-pedido-vtex.id-autorizacao = c-plp.
        FIND CURRENT int-pedido-vtex NO-LOCK NO-ERROR.
    END.

    IF c-plp <> "" THEN
        RUN esp/ftp/esftp128rpc.p (INPUT c-plp,
                                   INPUT c-chave).

    /*
    /* BUSCAR PDF DA PLP DA ETIQUETA */
    IF c-plp <> "" THEN
        RUN esp/ftp/esftp128rpb.p (INPUT int-pedido-vtex.tid,
                                   INPUT c-plp).
    */                                   
                                 
END.
    
RETURN "OK"


