{include/i-prgvrs.i esftp131rp 2.00.00.001}
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
    FIELD id-conta-ini     AS INT
    FIELD id-conta-fim     AS INT
    FIELD dt-venc-ini      AS DATE
    FIELD dt-venc-fim      AS DATE
    FIELD dias-param       AS LOG. 


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

{utp/ut-glob.i}

RUN esp/ftp/esftp131rpa.p (INPUT TABLE tt-param).

RETURN "OK". 

/*

DO ON STOP UNDO, LEAVE:

    ASSIGN c-arquivo-csv = "esftp131_" + STRING(TIME) + ".csv":U.

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
END.


DO ON STOP UNDO, LEAVE:

    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
    RUN pi-inicializar in h-acomp (input "Integrando ...").

    OUTPUT STREAM str-excel TO value(c-arq-excel) NO-CONVERT.
    
    PUT STREAM str-excel UNFORMATTED "Nota Fiscal" SKIP.
    PUT STREAM str-excel UNFORMATTED "NR PEDIDO;PEDIDO VTEX;ESTAB;SRIE;NR NOTA;EMISSÇO;CHAVE ACESSO;" SKIP.

    IF tt-param.dia-atual THEN
        ASSIGN tt-param.dt-emiss-ini = TODAY
               tt-param.dt-emiss-fim = TODAY.
    
    FOR EACH nota-fiscal NO-LOCK
        WHERE nota-fiscal.idi-sit-nf-eletro = 3 /*Autorizada*/
          AND nota-fiscal.cod-estabel >= tt-param.cod-estab-ini
          AND nota-fiscal.cod-estabel <= tt-param.cod-estab-fim
          AND nota-fiscal.serie >= tt-param.serie-ini
          AND nota-fiscal.serie <= tt-param.serie-fim
          AND nota-fiscal.nr-nota-fis >= tt-param.nr-nota-ini
          AND nota-fiscal.nr-nota-fis <= tt-param.nr-nota-fim
          AND nota-fiscal.dt-emis >= tt-param.dt-emiss-ini
          AND nota-fiscal.dt-emis <= tt-param.dt-emiss-fim,
        FIRST ped-venda NO-LOCK
        WHERE ped-venda.nome-abrev = nota-fiscal.nome-ab-cli
          AND ped-venda.nr-pedcli  = nota-fiscal.nr-pedcli,
         FIRST int-ped-venda  NO-LOCK
         WHERE int-ped-venda.cod-estabel =  ped-venda.cod-estabel
           AND int-ped-venda.nr-pedido = ped-venda.nr-pedido
           AND int-ped-venda.lojacodigo > 0 : 
		   
	RUN pi-acompanhar in h-acomp (input nota-fiscal.cod-estabel + "/" + nota-fiscal.serie + "/" + nota-fiscal.nr-nota-fis).

        EMPTY TEMP-TABLE ttNotaFiscal.
        EMPTY TEMP-TABLE ttItemNota.

        FIND FIRST int-ped-venda2 NO-LOCK
             WHERE int-ped-venda2.cod-estabel = ped-venda.cod-estabel
               AND int-ped-venda2.nr-pedido   = ped-venda.nr-pedido NO-ERROR.

        CREATE ttNotaFiscal.
        ASSIGN ttNotaFiscal.numeroPedido    = string(ped-venda.nr-pedido) 
               ttNotaFiscal.pedidoCliente   = IF AVAIL int-ped-venda2 THEN int-ped-venda2.PedidoeCommerce ELSE ped-venda.nr-pedcli + "-01"
               ttNotaFiscal.estabelecimento = nota-fiscal.cod-estabel
               ttNotaFiscal.serie           = nota-fiscal.serie
               ttNotaFiscal.NumeroNota      = nota-fiscal.nr-nota-fis
               ttNotaFiscal.dataEmissao     = nota-fiscal.dt-emis-nota
               ttNotaFiscal.chaveAcesso     = nota-fiscal.cod-chave-aces-nf-eletro.

        ASSIGN ttNotaFiscal.valorNota = nota-fiscal.vl-tot-nota.

        FIND FIRST int-pedido-vtex NO-LOCK
             WHERE int-pedido-vtex.nr-pedcli = nota-fiscal.nr-pedcli NO-ERROR.

        IF  AVAIL int-pedido-vtex 
        AND int-pedido-vtex.vl-tot-pagto <> ttNotaFiscal.valorNota 
        AND ABS(int-pedido-vtex.vl-tot-pagto - ttNotaFiscal.valorNota) <= 0.2  THEN
            ASSIGN ttNotaFiscal.valorNota = int-pedido-vtex.vl-tot-pagto.

        PUT STREAM str-excel UNFORMATTED ttNotaFiscal.numeroPedido    ";"
                                         ttNotaFiscal.pedidoCliente   ";"
                                         ttNotaFiscal.estabelecimento ";"
                                         ttNotaFiscal.serie           ";"
                                         ttNotaFiscal.NumeroNota      ";"
                                         ttNotaFiscal.dataEmissao     ";"
                                         ttNotaFiscal.valorNota       ";"
                                         ttNotaFiscal.chaveAcesso SKIP.


        FOR EACH it-nota-fisc NO-LOCK
            OF nota-fiscal:
            CREATE ttItemNota.
            ASSIGN ttItemNota.codigoItem = it-nota-fisc.it-codigo
                   ttItemNota.quantidade = it-nota-fisc.qt-faturada[1]
                   ttItemNota.precoItem  = it-nota-fisc.vl-tot-item.
        END.

        IF AVAIL int-pedido-vtex AND int-pedido-vtex.marketplace = "MKT" THEN
            RUN esp/wso/out/wso0006.p (INPUT "pedido/v1/notafiscal-agenciamento",
                                       INPUT TABLE ttNotaFiscal).
        ELSE 
            RUN esp/wso/out/wso0005.p (INPUT "v1/pedido/notafiscal",
                                       INPUT TABLE ttNotaFiscal,
                                       INPUT TABLE ttItemNota).
        
    END.

    RUN pi-finalizar IN h-acomp.

    OUTPUT STREAM str-excel CLOSE.

    /*
    IF NOT OPSYS = "unix" THEN DO:
        DOS SILENT START excel VALUE(c-arq-excel).
    END.
    */

    RETURN "OK".   
END.
*/
