block-level on error undo, throw.

/** Carrega bibliotecas necessarias **/
USING OpenEdge.Net.HTTP.IHttpClientLibrary.
USING OpenEdge.Net.HTTP.ConfigBuilder.
USING OpenEdge.Net.HTTP.ClientBuilder.
USING OpenEdge.Net.HTTP.Credentials.
USING OpenEdge.Net.HTTP.IHttpClient.
USING OpenEdge.Net.HTTP.IHttpRequest.
USING OpenEdge.Net.HTTP.IHttpResponse.
USING OpenEdge.Net.HTTP.RequestBuilder.
USING OpenEdge.Net.HTTP.ResponseBuilder.
USING OpenEdge.Net.URI.
USING OpenEdge.Core.*.
USING OpenEdge.Core.String.
USING OpenEdge.Core.WidgetHandle.
USING Progress.Json.*.
USING Progress.Json.ObjectModel.*.
USING com.totvs.framework.api.*.
USING Progress.Lang.Object.

{include/i-prgvrs.i esftp124rp 2.00.00.001}
{esp/esb/esesb000.i}
{esp/wso/out/wso0005.i}
{btb/btb912zb.i}
{utp/ut-glob.i}
{esp/es0018.i}

DEFINE VARIABLE oXML                       AS LONGCHAR      NO-UNDO.
DEFINE VARIABLE c-arquivo-csv              AS CHARACTER     NO-UNDO.
DEFINE VARIABLE c-dir-saida                AS CHARACTER     NO-UNDO.
DEFINE VARIABLE c-arq-excel                AS CHARACTER     NO-UNDO.
DEFINE VARIABLE h-acomp                    AS HANDLE        NO-UNDO.
DEFINE VARIABLE i-cont-aux                 AS INTEGER       NO-UNDO.
DEFINE VARIABLE objJson                    AS JsonObject    NO-UNDO.
DEFINE VARIABLE objRegistrar               AS JsonObject    NO-UNDO.
DEFINE VARIABLE objEncomendas              AS JsonObject    NO-UNDO.
DEFINE VARIABLE objDestinatario            AS JsonObject    NO-UNDO.
DEFINE VARIABLE objEndereco                AS JsonObject    NO-UNDO.
DEFINE VARIABLE objCod                     AS JsonObject    NO-UNDO.
DEFINE VARIABLE objAgendamento             AS JsonObject    NO-UNDO.
DEFINE VARIABLE objDocFiscal               AS JsonObject    NO-UNDO.
DEFINE VARIABLE objNfe                     AS JsonObject    NO-UNDO.
DEFINE VARIABLE objNf                      AS JsonObject    NO-UNDO.
DEFINE VARIABLE objOutros                  AS JsonObject    NO-UNDO.
DEFINE VARIABLE objCte                     AS JsonObject    NO-UNDO.
DEFINE VARIABLE c-JASON                    AS CHARACTER     NO-UNDO.
DEFINE VARIABLE arrayJson                  AS jsonArray     NO-UNDO.
DEFINE VARIABLE arrayEncomendas            AS jsonArray     NO-UNDO.
DEFINE VARIABLE arrayNfe                   AS jsonArray     NO-UNDO.
DEFINE VARIABLE arrayNf                    AS jsonArray     NO-UNDO.
DEFINE VARIABLE arrayOutros                AS jsonArray     NO-UNDO.
DEFINE VARIABLE c-rua                      AS CHARACTER     NO-UNDO.
DEFINE VARIABLE c-nro                      AS CHARACTER     NO-UNDO.
DEFINE VARIABLE c-comp                     AS CHARACTER     NO-UNDO.
DEFINE VARIABLE h-cdapi704                 AS HANDLE        NO-UNDO.
DEFINE VARIABLE oRequest                   AS IHttpRequest  NO-UNDO.
DEFINE VARIABLE oResponse                  AS IHttpResponse NO-UNDO.
DEFINE VARIABLE iXml                       AS STRING        NO-UNDO.
DEFINE VARIABLE c-retorno                  AS CHARACTER     NO-UNDO.
DEFINE VARIABLE c-json                     AS CHARACTER     NO-UNDO.
DEFINE VARIABLE oJsonObject                AS JsonObject    NO-UNDO.
DEFINE VARIABLE JsonString                 AS LONGCHAR      NO-UNDO.
DEFINE VARIABLE cString                    AS CHARACTER     NO-UNDO.
DEFINE VARIABLE jsonEncomendas             AS JsonArray     NO-UNDO.
DEFINE VARIABLE JsonObjectEncomendas       AS JsonObject    NO-UNDO.
DEFINE VARIABLE jsonEncomenda              AS JsonArray     NO-UNDO.
DEFINE VARIABLE jsonVolumes                AS JsonArray     NO-UNDO.
DEFINE VARIABLE JsonObjectEncomenda        AS JsonObject    NO-UNDO.
DEFINE VARIABLE JsonObjectRetorno          AS JsonObject    NO-UNDO.
DEFINE VARIABLE JsonObjectVolumes          AS JsonObject    NO-UNDO.
DEFINE VARIABLE i                          AS INTEGER       NO-UNDO.
DEFINE VARIABLE j                          AS INTEGER       NO-UNDO.
DEFINE VARIABLE cUrl                       AS CHARACTER     NO-UNDO.
DEFINE VARIABLE c-remetenteId              AS CHARACTER     NO-UNDO.
DEFINE VARIABLE c-cnpj                     AS CHARACTER     NO-UNDO.

DEFINE STREAM str-excel.

DEFINE BUFFER empresa FOR emscad.empresa.
DEFINE TEMP-TABLE tt-prog-ponto2 LIKE tt-prog-ponto.

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
             
define temp-table tt-param-esftp134 no-undo
    field destino          as integer
    field arquivo          as char format "x(35)"
    field usuario          as char format "x(12)"
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field desc-classifica  as char format "x(40)"
    field modelo-rtf       as char format "x(35)"
    field l-habilitaRtf    as LOG
    FIELD cnr-pedido       AS CHAR
    FIELD c-xml            AS CHAR.

define temp-table tt-param-ft2100 NO-UNDO
    field destino           as integer  
    field arquivo           as char
    field usuario           as char
    field data-exec         as date
    field hora-exec         as integer
    field tipo-atual        as integer   /* 1 - Atualiza, 2 - Desatualiza */
    field c-desc-tipo-atual as char format "x(15)"
    field da-emissao-ini    as date format "99/99/9999"
    field da-emissao-fim    as date format "99/99/9999"
    field da-saida          as date format "99/99/9999"
    field da-vencto-ipi     as date format "99/99/9999"
    field da-vencto-icms    as date format "99/99/9999"
    field da-vencto-iss     as date format "99/99/9999"
    field c-estabel-ini     as char
    field c-estabel-fim     as char
    field c-serie-ini       as char
    field c-serie-fim       as char
    field c-nr-nota-ini     as char
    field c-nr-nota-fim     as char
    field i-embarque-ini    as DEC
    field i-embarque-fim    as DEC
    field c-preparador      as char
    field l-disp-men        as log
    field l-b2b             as log
    FIELD log-1             AS LOG.

define temp-table tt-param-esftp128 no-undo
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

DO ON STOP UNDO, LEAVE:

    ASSIGN c-arquivo-csv = "esftp124_" + STRING(TIME) + ".csv":U.

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
       WHERE (IF tt-param.cod-estab-ini = tt-param.cod-estab-fim THEN nota-fiscal.cod-estabel = tt-param.cod-estab-ini
              ELSE nota-fiscal.cod-estabel >= tt-param.cod-estab-ini AND nota-fiscal.cod-estabel <= tt-param.cod-estab-fim)
         AND (IF tt-param.serie-ini = tt-param.serie-fim THEN nota-fiscal.serie = tt-param.serie-ini
              ELSE nota-fiscal.serie >= tt-param.serie-ini AND nota-fiscal.serie <= tt-param.serie-fim)
         AND nota-fiscal.nr-nota-fis >= tt-param.nr-nota-ini
         AND nota-fiscal.nr-nota-fis <= tt-param.nr-nota-fim
         AND nota-fiscal.dt-emis >= tt-param.dt-emiss-ini
         AND nota-fiscal.dt-emis <= tt-param.dt-emiss-fim
         AND (nota-fiscal.idi-sit-nf-eletro = 3 /*Autorizada*/
          OR INTEGER(SUBSTR(nota-fiscal.char-1,143,2)) = 3),
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

        FIND FIRST int-pedido-vtex NO-LOCK
             WHERE int-pedido-vtex.nr-pedcli = nota-fiscal.nr-pedcli NO-ERROR.

        CREATE ttNotaFiscal.
        ASSIGN ttNotaFiscal.numeroPedido    = string(ped-venda.nr-pedido) 
               ttNotaFiscal.pedidoCliente   = IF AVAIL int-pedido-vtex THEN int-pedido-vtex.seq-pedido ELSE ped-venda.nr-pedcli + "-01"
               ttNotaFiscal.estabelecimento = nota-fiscal.cod-estabel
               ttNotaFiscal.serie           = nota-fiscal.serie
               ttNotaFiscal.NumeroNota      = nota-fiscal.nr-nota-fis
               ttNotaFiscal.dataEmissao     = nota-fiscal.dt-emis-nota
               ttNotaFiscal.chaveAcesso     = nota-fiscal.cod-chave-aces-nf-eletro.

        ASSIGN ttNotaFiscal.valorNota = nota-fiscal.vl-tot-nota.

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

        RUN pi-acompanhar in h-acomp (input "Antes enviar VTEX " + nota-fiscal.cod-estabel + "/" + nota-fiscal.serie + "/" + nota-fiscal.nr-nota-fis).
    
        RUN esp/wso/out/wso0005.p (INPUT "v1/pedido/notafiscal",
                                   INPUT TABLE ttNotaFiscal,
                                   INPUT TABLE ttItemNota).

        RUN pi-acompanhar in h-acomp (input "Depois enviar VTEX " + nota-fiscal.cod-estabel + "/" + nota-fiscal.serie + "/" + nota-fiscal.nr-nota-fis).

        IF  nota-fiscal.serie = "90" THEN
            RUN pi-atualiza-estoque.

        IF int-pedido-vtex.marketplace = "MLP" THEN DO:
            RUN pi-acompanhar in h-acomp (input "Antes enviar MLP " + nota-fiscal.cod-estabel + "/" + nota-fiscal.serie + "/" + nota-fiscal.nr-nota-fis).
            RUN pi-integra-xml.
            //RUN pi-atualiza-estoque.
            RUN pi-acompanhar in h-acomp (input "Depois enviar MLP " + nota-fiscal.cod-estabel + "/" + nota-fiscal.serie + "/" + nota-fiscal.nr-nota-fis).
        END.
        /*
        IF int-pedido-vtex.marketplace = "MGZ" THEN DO:
            RUN pi-acompanhar in h-acomp (input "Antes enviar MGZ " + nota-fiscal.cod-estabel + "/" + nota-fiscal.serie + "/" + nota-fiscal.nr-nota-fis).
            RUN pi-atualiza-estoque.
            RUN pi-acompanhar in h-acomp (input "Depois enviar MGZ " + nota-fiscal.cod-estabel + "/" + nota-fiscal.serie + "/" + nota-fiscal.nr-nota-fis).
        END.
        */
        IF int-pedido-vtex.marketplace = "BWW" THEN DO:
            RUN pi-acompanhar in h-acomp (input "Antes enviar BWW " + nota-fiscal.cod-estabel + "/" + nota-fiscal.serie + "/" + nota-fiscal.nr-nota-fis).
            RUN pi-busca-etiqueta.
            RUN pi-acompanhar in h-acomp (input "Depois enviar BWW " + nota-fiscal.cod-estabel + "/" + nota-fiscal.serie + "/" + nota-fiscal.nr-nota-fis).
        END.
        IF nota-fiscal.nome-transp = "TOTAL EXP" THEN DO:
            RUN pi-cria-remessa-transp.
        END.


        RUN pi-acompanhar in h-acomp (input "Antes enviar Mibo " + nota-fiscal.cod-estabel + "/" + nota-fiscal.serie + "/" + nota-fiscal.nr-nota-fis).
        /* CUPOM VIRTUAL MIBO */
        EMPTY TEMP-TABLE tt-prog-ponto.
        RUN esp/es0018p.p (INPUT "WSO0003-VTEX":U, /* Nome do programa */
                           INPUT 1,            /* Ponto do programa */
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-ponto).
        /* CUPOM VIRTUAL MIBO */

        FOR EACH ped-item OF ped-venda NO-LOCK:

            FOR FIRST tt-prog-ponto
                WHERE entry(1,tt-prog-ponto.conteudo,";") = ped-item.it-codigo:

                RUN pi-acompanhar in h-acomp (input "Item Mibo: " + ped-item.it-codigo).

                RUN pi-post-cartao-virtual (INPUT IF AVAIL int-pedido-vtex THEN int-pedido-vtex.seq-pedido ELSE "",
                                            INPUT IF AVAIL int-pedido-vtex THEN int-pedido-vtex.email ELSE "",
                                            INPUT ped-item.it-codigo,
                                            INPUT ped-item.qt-pedida).
                
            END.
        END.
        RUN pi-acompanhar in h-acomp (input "Depois enviar Mibo " + nota-fiscal.cod-estabel + "/" + nota-fiscal.serie + "/" + nota-fiscal.nr-nota-fis).
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

PROCEDURE pi-cria-remessa-transp:

    EMPTY TEMP-TABLE tt-prog-ponto2.
    RUN esp/es0018p.p (INPUT "ESFTP124":U,
                       INPUT 2,
                       INPUT 0,
                       INPUT "":U,
                       OUTPUT TABLE tt-prog-ponto2).

    FOR EACH tt-prog-ponto2:
        CASE tt-prog-ponto2.sequencia:
            WHEN 1 THEN ASSIGN cUrl           = tt-prog-ponto2.conteudo.
            WHEN 2 THEN ASSIGN c-remetenteId  = tt-prog-ponto2.conteudo.
            WHEN 3 THEN ASSIGN c-cnpj         = tt-prog-ponto2.conteudo.
        END.
    END.

    FIND FIRST emitente NO-LOCK
         WHERE emitente.cod-emitente = nota-fiscal.cod-emitente NO-ERROR.
    IF NOT AVAIL emitente THEN NEXT.

    FIND FIRST loc-entr NO-LOCK
         WHERE loc-entr.nome-abrev   = emitente.nome-abrev
           AND loc-entr.cod-entrega  = nota-fiscal.cod-entrega NO-ERROR.
    IF NOT AVAIL loc-entr THEN NEXT.

    FIND FIRST it-nota-fisc NO-LOCK OF nota-fiscal NO-ERROR.
    IF NOT AVAIL it-nota-fisc THEN NEXT.

    FIND FIRST ITEM NO-LOCK
         WHERE ITEM.it-codigo = it-nota-fisc.it-codigo NO-ERROR.
    IF NOT AVAIL ITEM THEN NEXT.

    FIND FIRST int-pedido-vtex NO-LOCK
         WHERE int-pedido-vtex.nr-pedcli = nota-fiscal.nr-pedcli NO-ERROR.

    run pi-acompanhar in h-acomp (input "Lendo NF: " + nota-fiscal.nr-nota-fis).

    RUN pi-envia-encomenda.
    
END.

PROCEDURE pi-cria-int-etiqueta-ecommerce:
    
    FIND FIRST int-etiqueta-ecommerce EXCLUSIVE-LOCK
         WHERE int-etiqueta-ecommerce.nr-pedido   = int-pedido-vtex.nr-pedido
           AND int-etiqueta-ecommerce.nr-pedcli   = nota-fiscal.nr-pedcli
           AND int-etiqueta-ecommerce.nr-nota-fis = nota-fiscal.nr-nota-fis NO-ERROR.
    IF NOT AVAIL int-etiqueta-ecommerce THEN DO:
        CREATE int-etiqueta-ecommerce.
        ASSIGN int-etiqueta-ecommerce.nr-pedido   = int-pedido-vtex.nr-pedido
               int-etiqueta-ecommerce.nr-pedcli   = nota-fiscal.nr-pedcli    
               int-etiqueta-ecommerce.nr-nota-fis = nota-fiscal.nr-nota-fis
               int-etiqueta-ecommerce.serie       = nota-fiscal.serie
               int-etiqueta-ecommerce.cod-estabel = nota-fiscal.cod-estabel
               int-etiqueta-ecommerce.nr-pedcli   = nota-fiscal.nr-pedcli
               int-etiqueta-ecommerce.nr-pedido   = int-pedido-vtex.nr-pedido
               int-etiqueta-ecommerce.marketplace = int-pedido-vtex.marketplace
               int-etiqueta-ecommerce.nome-transp = nota-fiscal.nome-transp.
    END.
    IF JsonObjectVolumes:Has("awb")  THEN ASSIGN int-etiqueta-ecommerce.awb          = JsonObjectVolumes:GetCharacter("awb").
    IF JsonObjectVolumes:Has("rota") THEN ASSIGN int-etiqueta-ecommerce.rota         = JsonObjectVolumes:GetCharacter("rota").
    IF JsonObjectVolumes:Has("rota") THEN ASSIGN int-etiqueta-ecommerce.codigoBarras = JsonObjectVolumes:GetCharacter("codigoBarras").

    ASSIGN int-etiqueta-ecommerce.impressora        = "zebra29"
           int-etiqueta-ecommerce.tp-etiqueta       = "ZPL"
           int-etiqueta-ecommerce.conteudo-xml      = ""
           int-etiqueta-ecommerce.endereco-etiqueta = ""
           int-etiqueta-ecommerce.endereco-xml      = ""
           int-etiqueta-ecommerce.log-impressa      = 0.

    ASSIGN int-etiqueta-ecommerce.conteudo-etiqueta = "^XA^MMT^PW717^LL1199^LS0".

    //QR CODE
    //ASSIGN int-etiqueta-ecommerce.conteudo-etiqueta = int-etiqueta-ecommerce.conteudo-etiqueta +
    //"^FT503,556^BXN,5,200,0,0,1,_,1^FH\^FDQE970401963BR29550000000008812200100000951QE970401963BR000640000072922621032980000038Clinicampo          45862028999276604-00.000000-00.000000|^FS"

    ASSIGN int-etiqueta-ecommerce.conteudo-etiqueta = int-etiqueta-ecommerce.conteudo-etiqueta +
           "^FT27,48^A0N,23,23^FH\^CI28^FDREMETENTE:^FS^CI27^BY4,3,171^FT27,556^BCN,,N,N".

    //CEP BAR
    ASSIGN int-etiqueta-ecommerce.conteudo-etiqueta = int-etiqueta-ecommerce.conteudo-etiqueta +
           "^FH\^FD>;" + SUBSTRING(loc-entr.cep,1,5) + "-" + SUBSTRING(loc-entr.cep,6,3)  + "^FS^FT27,84^A0N,23,23^FH\^CI28^FDINTELBRAS LOJA OFICIAL^FS^CI27^FT27,110^A0N,23,23^FH\^CI28^FDRODOVIA SC-281, S/N - KM 4,5^FS^CI27^FT27,136^A0N,23,23^FH\^CI28^FDSERTÇO DO MARUIM - SÇO JOS/SC^FS^CI27^FT27,162^A0N,23,23^FH\^CI28^FD88122-001^FS^CI27^FT483,69^A0N,34,33^FH\^CI28^FDTOTAL EXPRESS^FS^CI27^FO483,75^GB223,60,4^FS^FT562,120^A0N,39,38^FH\^CI28^FDSTD^FS^CI27^FO483,158^GB223,133,4^FS".

    //DATA
    //ASSIGN int-etiqueta-ecommerce.conteudo-etiqueta = int-etiqueta-ecommerce.conteudo-etiqueta +
    //       "^FT557,192^A0N,34,33^FH\^CI28^FD08/04^FS^CI27".

    //HORA1
    //ASSIGN int-etiqueta-ecommerce.conteudo-etiqueta = int-etiqueta-ecommerce.conteudo-etiqueta +
    //       "^FT557,235^A0N,34,33^FH\^CI28^FD03:59^FS^CI27".

    //HORA2
    //ASSIGN int-etiqueta-ecommerce.conteudo-etiqueta = int-etiqueta-ecommerce.conteudo-etiqueta +
    //       "^FT557,278^A0N,34,33^FH\^CI28^FD04:59^FS

    //DESTINATARIO
    ASSIGN int-etiqueta-ecommerce.conteudo-etiqueta = int-etiqueta-ecommerce.conteudo-etiqueta +
           "^CI27^FT27,207^A0N,23,23^FH\^CI28^FDDESTINATµRIO:^FS^CI27".

    //#NOME
    ASSIGN int-etiqueta-ecommerce.conteudo-etiqueta = int-etiqueta-ecommerce.conteudo-etiqueta +
           "^FT27,241^A0N,23,23^FH\^CI28^FD" + emitente.nome-emit + "^FS^CI27".

   //ENDERECO
   ASSIGN int-etiqueta-ecommerce.conteudo-etiqueta = int-etiqueta-ecommerce.conteudo-etiqueta +
          "^FT27,270^A0N,23,23^FH\^CI28^FD" + c-rua + ", " + c-nro + "^FS^CI27".

   //BAIRRO
   ASSIGN int-etiqueta-ecommerce.conteudo-etiqueta = int-etiqueta-ecommerce.conteudo-etiqueta +
          "^FT27,299^A0N,23,23^FH\^CI28^FD" + loc-entr.bairro + "^FS^CI27".

  //COMPLEMENTO
  ASSIGN int-etiqueta-ecommerce.conteudo-etiqueta = int-etiqueta-ecommerce.conteudo-etiqueta +
         "^FT27,327^A0N,23,23^FH\^CI28^FD" + c-comp + "^FS^CI27".

  //CIDADE
  ASSIGN int-etiqueta-ecommerce.conteudo-etiqueta = int-etiqueta-ecommerce.conteudo-etiqueta +
         "^FT27,356^A0N,23,23^FH\^CI28^FD" + SUBSTRING(loc-entr.cep,1,5) + "-" + SUBSTRING(loc-entr.cep,6,3) + " " + loc-entr.cidade + "/" + loc-entr.estado + "^FS^CI27^FO3,364^GB799,0,3^FS^FO21,575^GB331,87,79^FS^FO21,575^GB326,85,83^FS".

  //CEP
  ASSIGN int-etiqueta-ecommerce.conteudo-etiqueta = int-etiqueta-ecommerce.conteudo-etiqueta +
         "^LRY^FT21,643^A0N,68,68^FH\^CI28^FD" + SUBSTRING(loc-entr.cep,1,5) + "-" + SUBSTRING(loc-entr.cep,6,3) + "^FS^CI27^LRN^FO352,575^GB359,87,4^FS".

  //ROTA
  ASSIGN int-etiqueta-ecommerce.conteudo-etiqueta = int-etiqueta-ecommerce.conteudo-etiqueta +
         "^FPH,2^FT357,627^A0N,25,25^FH\^CI28^FD" + int-etiqueta-ecommerce.rota + "^FS^CI27^FO3,703^GB799,0,3^FS^BY3,3,145^FT40,871^BCN,,Y,N".

  //CODIGO DE BARRAS
  ASSIGN int-etiqueta-ecommerce.conteudo-etiqueta = int-etiqueta-ecommerce.conteudo-etiqueta +
         "^FH\^FD>:" + int-etiqueta-ecommerce.awb + "^FS^BY3,3,145^FT40,1110^BCN,,Y,N".

  //CODIGO DE BARRAS2
  ASSIGN int-etiqueta-ecommerce.conteudo-etiqueta = int-etiqueta-ecommerce.conteudo-etiqueta +
         "^FH\^FD>:" + int-etiqueta-ecommerce.codigoBarras + "^FS^FO3,925^GB799,0,3^FS".

  //NF
  ASSIGN int-etiqueta-ecommerce.conteudo-etiqueta = int-etiqueta-ecommerce.conteudo-etiqueta +
         "^FT494,341^A0N,39,38^FH\^CI28^FDNF: " + int-etiqueta-ecommerce.nr-nota-fis + "^FS^CI27^PQ1,0,1,Y^XZ".
  
END PROCEDURE.

PROCEDURE pi-recebe-encomenda:

    CASE TRUE:
        WHEN TYPE-OF(oResponse:Entity, JsonObject) THEN DO:
           oJsonObject = CAST(oResponse:Entity, JsonObject). 
           JsonString = STRING(oJsonObject:getJsonText()).
        END.
    END CASE.

    //ASSIGN cString = SUBSTRING(JsonString, 1, 30000).

    IF oJsonObject:Has("retorno") THEN DO:
        ASSIGN JsonObjectRetorno = oJsonObject:GetJsonObject("retorno":U). 
        ASSIGN jsonEncomendas = JsonObjectRetorno:GetJsonArray("encomendas").
        DO i = 1 TO jsonEncomendas:LENGTH:
            ASSIGN JsonObjectEncomendas = jsonEncomendas:GetJsonObject(i).
            ASSIGN jsonVolumes = JsonObjectEncomendas:GetJsonArray("volumes").
            DO j = 1 TO jsonVolumes:LENGTH:
                ASSIGN JsonObjectVolumes = jsonVolumes:GetJsonObject(j).

                RUN pi-cria-int-etiqueta-ecommerce.

            END.
        END.
    END.

END PROCEDURE.

PROCEDURE pi-envia-encomenda:

    ASSIGN arrayJson       = NEW JsonArray().
    ASSIGN arrayEncomendas = NEW JsonArray().
    ASSIGN arrayNfe        = NEW JsonArray().
    ASSIGN arrayNf         = NEW JsonArray().
    ASSIGN arrayOutros     = NEW JsonArray().
    ASSIGN objJson         = NEW JsonObject().
    ASSIGN objRegistrar    = NEW JsonObject().  
    ASSIGN objEncomendas   = NEW JsonObject().
    ASSIGN objDestinatario = NEW JsonObject(). 
    ASSIGN objEndereco     = NEW JsonObject().
    ASSIGN objCod          = NEW JsonObject(). 
    ASSIGN objAgendamento  = NEW JsonObject().
    ASSIGN objDocFiscal    = NEW JsonObject(). 
    ASSIGN objNfe          = NEW JsonObject().
    ASSIGN objNf           = NEW JsonObject(). 
    ASSIGN objOutros       = NEW JsonObject().
    ASSIGN objCte          = NEW JsonObject().

    objRegistrar:ADD("remetenteId"         , c-remetenteId).     
    objRegistrar:ADD("cnpj"                , c-cnpj).
    objRegistrar:ADD("remessaCodigo"       , "").

    objEncomendas:ADD("servicoTipo"        , 1). /* 6 - STANDART */
    objEncomendas:ADD("servicoTipoInfo"    , "").
    objEncomendas:ADD("entregaTipo"        , 0). /*0 - NORMAL*/
    objEncomendas:ADD("peso"               , 0). /*OPCIONAL*/
    objEncomendas:ADD("volumes"            , nota-fiscal.nr-volumes).
    objEncomendas:ADD("condFrete"          , "CIF").
    objEncomendas:ADD("pedido"             , IF AVAIL int-pedido-vtex THEN int-pedido-vtex.nr-pedido ELSE nota-fiscal.nr-pedcli).
    objEncomendas:ADD("clienteCodigo"      , nota-fiscal.cod-emitente).
    objEncomendas:ADD("natureza"           , SUBSTRING(ITEM.desc-item,1,10)).
    objEncomendas:ADD("volumesTipo"        , "CX").
    objEncomendas:ADD("icmsIsencao"        , 1). /* 1 - NÇO ISENTO - VER VALOR DE ICMS NO ITEM */
    objEncomendas:ADD("coletaInfo"         , "").

    objDestinatario:ADD("nome"                 , emitente.nome-emit). 
    objDestinatario:ADD("cpfCnpj"              , emitente.cgc). 
    objDestinatario:ADD("ie"                   , loc-entr.ins-estadual).
    objDestinatario:ADD("endereco"            , objEndereco).

    objDestinatario:ADD("email"                , emitente.e-mail). 
    objDestinatario:ADD("telefone1"            , emitente.telefone[1]). 
    objDestinatario:ADD("telefone2"            , 0). 
    objDestinatario:ADD("telefone3"            , 0). 
    objEncomendas:ADD("destinatario"       , objDestinatario).
    objEncomendas:ADD("campanha"           , "").

    RUN cdp/cdapi704.p PERSISTENT SET h-cdapi704.
    RUN pi-trata-endereco IN h-cdapi704 (INPUT  loc-entr.endereco,
                                         OUTPUT c-rua, 
                                         OUTPUT c-nro, 
                                         OUTPUT c-comp).
    DELETE PROCEDURE h-cdapi704.

    objEndereco:ADD("logradouro"               , c-rua).
    objEndereco:ADD("numero"                   , c-nro).
    objEndereco:ADD("complemento"              , c-comp).
    objEndereco:ADD("pontoReferencia"          , "").
    objEndereco:ADD("bairro"                   , loc-entr.bairro).
    objEndereco:ADD("cidade"                   , loc-entr.cidade).
    objEndereco:ADD("estado"                   , loc-entr.estado).
    objEndereco:ADD("pais"                     , loc-entr.pais).
    objEndereco:ADD("cep"                      , loc-entr.cep).


    //objCod:ADD("formaPagamento"                , "string").
    //objCod:ADD("parcelas"                      , 0).
    //objCod:ADD("valor"                         , 0).
    //objEncomendas:ADD("cod"                , objCod).

    //objAgendamento:ADD("data"                  , "string").
    //objAgendamento:ADD("periodo1"              , "string").     
    //objAgendamento:ADD("periodo2"              , "string").
    //objEncomendas:ADD("agendamento"        , objAgendamento).

    objEncomendas:ADD("docFiscal"          , objDocFiscal).
    arrayEncomendas:ADD(objEncomendas).
    objRegistrar:ADD("encomendas", arrayEncomendas).


    objNfe:ADD("nfeNumero"                     , nota-fiscal.nr-nota-fis).
    objNfe:ADD("nfeSerie"                      , nota-fiscal.serie).
    objNfe:ADD("nfeData"                       , nota-fiscal.dt-emis-nota).
    objNfe:ADD("nfeValTotal"                   , nota-fiscal.vl-tot-nota).
    objNfe:ADD("nfeValProd"                    , nota-fiscal.vl-mercad).
    objNfe:ADD("nfeCfop"                       , SUBSTRING(nota-fiscal.nat-operacao,1,4)).
    objNfe:ADD("nfeChave"                      , nota-fiscal.cod-chave-aces-nf-eletro).
    arrayNfe:ADD(objNfe).
    objDocFiscal:ADD("nfe", arrayNfe).

    /*
    objNf:ADD("nfNumero"                       , 0).
    objNf:ADD("nfSerie"                        , "string").
    objNf:ADD("nfData"                         , "string").
    objNf:ADD("nfValTotal"                     , 0).
    objNf:ADD("nfValBc"                        , 0).
    objNf:ADD("nfValIcms"                      , 0).
    objNf:ADD("nfValBcSt"                      , 0).
    objNf:ADD("nfValIcmsSt"                    , 0).
    objNf:ADD("nfValProd"                      , 0).
    objNf:ADD("nfCfop"                         , 0).
    arrayNf:ADD(objNf).
    objDocFiscal:ADD("nf", arrayNf).

    objOutros:ADD("nfoTipo"                    , "string").
    objOutros:ADD("nfoDescricao"               , "string").    
    objOutros:ADD("nfoNumero"                  , 0).
    objOutros:ADD("nfoData"                    , "string").
    objOutros:ADD("nfoValTotal"                , 0).
    objOutros:ADD("nfoValProd"                 , 0).
    objOutros:ADD("nfoCfop"                    , 0).
    arrayOutros:ADD(objOutros).
    objDocFiscal:ADD("outros"                  , arrayOutros).
    //objDocFiscal:ADD("cte"                   , objCte).
    */

    arrayJson:ADD(objRegistrar).

    SESSION:DEBUG-ALERT = TRUE.

    oRequest = RequestBuilder:POST(cUrl, objRegistrar)
                                   :ContentType('application/json')
                                   :AcceptJson()
                                   :Request.
    oResponse = ClientBuilder:Build():Client:EXECUTE(oRequest) NO-ERROR.

    IF oResponse:StatusCode = 200 THEN DO:
        RUN pi-recebe-encomenda.
    END.

END.

PROCEDURE pi-post-cartao-virtual:

    DEF INPUT PARAM p-nr-pedido AS CHAR NO-UNDO.
    DEF INPUT PARAM p-email     AS CHAR NO-UNDO.
    DEF INPUT PARAM p-it-codigo AS CHAR NO-UNDO.
    DEF INPUT PARAM p-qt-pedida AS DEC  NO-UNDO.

    DEFINE VARIABLE c-json      AS CHAR NO-UNDO.

    DEFINE VARIABLE oRequest     AS IHttpRequest  NO-UNDO.
    DEFINE VARIABLE oResponse    AS IHttpResponse NO-UNDO.
    DEFINE VARIABLE iXml         AS STRING        NO-UNDO.

    ASSIGN c-json = '~{"pedido": "' + p-nr-pedido + '","email": "' + p-email + '","item": "' + p-it-codigo + '","quant": "' + STRING(p-qt-pedida) + '"}'.        

    EMPTY TEMP-TABLE tt-prog-ponto2.
    RUN esp/es0018p.p (INPUT "ESFTP124":U,
                       INPUT 1,
                       INPUT 0,
                       INPUT "":U,
                       OUTPUT TABLE tt-prog-ponto2).

    FOR FIRST tt-prog-ponto2:
        ASSIGN cUrl = tt-prog-ponto2.conteudo.
    END. /* FOR FIRST tt-prog-ponto2: */

    SESSION:DEBUG-ALERT = TRUE.
   
    ASSIGN iXml = new String(c-json).

    oRequest = RequestBuilder:POST(cUrl, iXml)
                             :AddHeader("HostName","wso2apim-gateway")
                             :AddHeader("UserName","le052412")
                             :ContentType("application/json")
                             :AcceptAll()
                             :Request.
    
    oResponse = ClientBuilder:Build():Client:Execute(oRequest) NO-ERROR.

    RUN pi-acompanhar in h-acomp (input "Item: " + ped-item.it-codigo + " Return: " + STRING(oResponse:StatusCode)).

    RETURN "OK".
    
END PROCEDURE.

PROCEDURE pi-integra-xml:

    DEFINE VARIABLE p_cod_prog_dtsul_w                          AS Character format "x(50)"      no-undo.
    DEFINE VARIABLE p_cod_prog_dtsul_rp                         AS Character format "x(50)"      no-undo.
    DEFINE VARIABLE p_cod_release                               AS Character format "x(9)"       no-undo.
    DEFINE VARIABLE p_cdn_estil_dwb                             AS Integer   format ">>9"        no-undo.
    DEFINE VARIABLE p_arquivo                                   AS Character format "x(50)"      no-undo.
    DEFINE VARIABLE p_destino                                   AS integer   format "9"          no-undo.
    DEFINE VARIABLE p_raw_param                                 AS Raw                           no-undo.
    DEFINE VARIABLE c-servidor                                  AS CHARACTER                     NO-UNDO.
    DEFINE VARIABLE p_num_ped_exec                              AS integer   FORMAT ">>>>9"      no-undo.
    DEFINE VARIABLE raw-param                                   AS RAW.

    ASSIGN i-cont-aux = i-cont-aux + 1.

    FOR FIRST mgesp.ponto-programa NO-LOCK
        WHERE ponto-programa.nome-programa = "wso0003"
          AND ponto-programa.ponto         = 7,  
        FIRST mgesp.conteudo-programa NO-LOCK
        WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:

       ASSIGN c-servidor = conteudo-programa.conteudo.

    END. /* FOR EACH mgesp.ponto-programa NO-LOCK */
 
    FOR EACH tt-param-esftp134:
        DELETE tt-param-esftp134.
    END.
    FOR EACH tt_param_segur:
        DELETE tt_param_segur.
    END.
    FOR EACH tt_ped_exec:
        DELETE tt_ped_exec.
    END.
    FOR EACH tt_ped_exec_param:
        DELETE tt_ped_exec_param.
    END.
    FOR EACH tt_ped_exec_param_aux:
        DELETE tt_ped_exec_param_aux.
    END.
    FOR EACH tt_ped_exec_sel:
        DELETE tt_ped_exec_sel.
    END.

    create tt-param-esftp134.
    assign tt-param-esftp134.usuario         = "integra"
           tt-param-esftp134.destino         = 2
           tt-param-esftp134.data-exec       = TODAY 
           tt-param-esftp134.hora-exec       = TIME
           tt-param-esftp134.cnr-pedido      = int-pedido-vtex.nr-pedido.

    ASSIGN tt-param-esftp134.arquivo = "esftp134_UNIX.tmp".

    RAW-TRANSFER tt-param-esftp134 TO raw-param.
    
    ASSIGN p_cod_prog_dtsul_w    = "esftp134"           
           p_cod_prog_dtsul_rp   = "esp/ftp/esftp134rp.p"
           p_cod_release         = '2.00.00.000'                    
           p_cdn_estil_dwb       = 97                   
           p_arquivo             = "esftp134.tmp" 
           p_destino             = 2                    
           p_raw_param           = raw-param.  

    create tt_param_segur.
    assign tt_param_segur.tta_num_vers_integr_api      = 3
           tt_param_segur.tta_cod_aplicat_dtsul_corren = "MFT"
           tt_param_segur.tta_cod_empres_usuar         = "1"
           tt_param_segur.tta_cod_grp_usuar_lst        = v_cod_grp_usuar_lst
           tt_param_segur.tta_cod_idiom_usuar          = "POR":U
           tt_param_segur.tta_cod_modul_dtsul_corren   = "MFT"
           tt_param_segur.tta_cod_pais_empres_usuar    = "BRA"
           tt_param_segur.tta_cod_usuar_corren         = v_cod_usuar_corren
           tt_param_segur.tta_cod_usuar_corren_criptog = v_cod_usuar_corren_criptog.

    create tt_ped_exec.
    assign tt_ped_exec.tta_num_seq                = i-cont-aux
           tt_ped_exec.tta_cod_usuario            = tt-param-esftp134.usuario
           tt_ped_exec.tta_cod_prog_dtsul         = p_cod_prog_dtsul_w 
           tt_ped_exec.tta_cod_prog_dtsul_rp      = p_cod_prog_dtsul_rp
           tt_ped_exec.tta_cod_release_prog_dtsul = p_cod_release      
           tt_ped_exec.tta_dat_exec_ped_exec      = today
           tt_ped_exec.tta_hra_exec_ped_exec      = replace(string(TIME,"HH:MM:SS"), ":", "")
           tt_ped_exec.tta_cod_servid_exec        = c-servidor
           tt_ped_exec.tta_cdn_estil_dwb          = 97.

    create tt_ped_exec_param.
    assign tt_ped_exec_param.tta_num_seq              = i-cont-aux
           tt_ped_exec_param.tta_cod_dwb_file         = "esp/ftp/esftp134rp.p"
           tt_ped_exec_param.tta_cod_dwb_output       = 'Arquivo'
           tt_ped_exec_param.tta_nom_dwb_printer      = p_arquivo.

    raw-transfer tt-param-esftp134       to tt_ped_exec_param.tta_raw_param_ped_exec.

    run btb/btb912zb.p (input-output table tt_param_segur,
                        input-output table tt_ped_exec,
                        input table tt_ped_exec_param,
                        input table tt_ped_exec_param_aux,
                        input table tt_ped_exec_sel).

END PROCEDURE.

PROCEDURE pi-atualiza-estoque:

    DEFINE VARIABLE p_cod_prog_dtsul_w                          AS Character format "x(50)"      no-undo.
    DEFINE VARIABLE p_cod_prog_dtsul_rp                         AS Character format "x(50)"      no-undo.
    DEFINE VARIABLE p_cod_release                               AS Character format "x(9)"       no-undo.
    DEFINE VARIABLE p_cdn_estil_dwb                             AS Integer   format ">>9"        no-undo.
    DEFINE VARIABLE p_arquivo                                   AS Character format "x(50)"      no-undo.
    DEFINE VARIABLE p_destino                                   AS integer   format "9"          no-undo.
    DEFINE VARIABLE p_raw_param                                 AS Raw                           no-undo.
    DEFINE VARIABLE c-servidor                                  AS CHARACTER                     NO-UNDO.
    DEFINE VARIABLE p_num_ped_exec                              AS integer   FORMAT ">>>>9"      no-undo.
    DEFINE VARIABLE raw-param                                   AS RAW.

    IF nota-fiscal.dt-confirm <> ? THEN NEXT.

    ASSIGN i-cont-aux = i-cont-aux + 1.

    FOR FIRST mgesp.ponto-programa NO-LOCK
        WHERE ponto-programa.nome-programa = "wso0003"
          AND ponto-programa.ponto         = 7,  
        FIRST mgesp.conteudo-programa NO-LOCK
        WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:

       ASSIGN c-servidor = conteudo-programa.conteudo.

    END. /* FOR EACH mgesp.ponto-programa NO-LOCK */
 
    FOR EACH tt-param-ft2100:
        DELETE tt-param-ft2100.
    END.
    FOR EACH tt_param_segur:
        DELETE tt_param_segur.
    END.
    FOR EACH tt_ped_exec:
        DELETE tt_ped_exec.
    END.
    FOR EACH tt_ped_exec_param:
        DELETE tt_ped_exec_param.
    END.
    FOR EACH tt_ped_exec_param_aux:
        DELETE tt_ped_exec_param_aux.
    END.
    FOR EACH tt_ped_exec_sel:
        DELETE tt_ped_exec_sel.
    END.

    create tt-param-ft2100.
    assign tt-param-ft2100.destino           = 2
           tt-param-ft2100.arquivo           = "ft2100_UNIX.tmp"
           tt-param-ft2100.usuario           = "integra"
           tt-param-ft2100.data-exec         = today
           tt-param-ft2100.hora-exec         = time
           tt-param-ft2100.tipo-atual        = 1
           tt-param-ft2100.c-desc-tipo-atual = "Atualiza"
           tt-param-ft2100.da-emissao-ini    = nota-fiscal.dt-emis-nota
           tt-param-ft2100.da-emissao-fim    = nota-fiscal.dt-emis-nota
           tt-param-ft2100.da-saida          = ?
           tt-param-ft2100.da-vencto-ipi     = today
           tt-param-ft2100.da-vencto-icms    = today
           tt-param-ft2100.da-vencto-iss     = today
           tt-param-ft2100.c-estabel-ini     = nota-fiscal.cod-estabel
           tt-param-ft2100.c-estabel-fim     = nota-fiscal.cod-estabel
           tt-param-ft2100.c-serie-ini       = nota-fiscal.serie
           tt-param-ft2100.c-serie-fim       = nota-fiscal.serie
           tt-param-ft2100.c-nr-nota-ini     = nota-fiscal.nr-nota-fis
           tt-param-ft2100.c-nr-nota-fim     = nota-fiscal.nr-nota-fis
           tt-param-ft2100.i-embarque-ini    = nota-fiscal.cdd-embarq
           tt-param-ft2100.i-embarque-fim    = nota-fiscal.cdd-embarq
           tt-param-ft2100.c-preparador      = ""
           tt-param-ft2100.l-disp-men        = no
           tt-param-ft2100.l-b2b             = no
           tt-param-ft2100.log-1             = NO.

    RAW-TRANSFER tt-param-ft2100 TO raw-param.
    
    ASSIGN p_cod_prog_dtsul_w    = "ft2100"           
           p_cod_prog_dtsul_rp   = "ftp/ft2100rp.p"
           p_cod_release         = '2.00.00.000'                    
           p_cdn_estil_dwb       = 97                   
           p_arquivo             = "ft2100.tmp" 
           p_destino             = 2                    
           p_raw_param           = raw-param.  

    create tt_param_segur.
    assign tt_param_segur.tta_num_vers_integr_api      = 3
           tt_param_segur.tta_cod_aplicat_dtsul_corren = "MFT"
           tt_param_segur.tta_cod_empres_usuar         = "1"
           tt_param_segur.tta_cod_grp_usuar_lst        = v_cod_grp_usuar_lst
           tt_param_segur.tta_cod_idiom_usuar          = "POR":U
           tt_param_segur.tta_cod_modul_dtsul_corren   = "MFT"
           tt_param_segur.tta_cod_pais_empres_usuar    = "BRA"
           tt_param_segur.tta_cod_usuar_corren         = v_cod_usuar_corren
           tt_param_segur.tta_cod_usuar_corren_criptog = v_cod_usuar_corren_criptog.

    create tt_ped_exec.
    assign tt_ped_exec.tta_num_seq                = i-cont-aux
           tt_ped_exec.tta_cod_usuario            = tt-param-ft2100.usuario
           tt_ped_exec.tta_cod_prog_dtsul         = p_cod_prog_dtsul_w 
           tt_ped_exec.tta_cod_prog_dtsul_rp      = p_cod_prog_dtsul_rp
           tt_ped_exec.tta_cod_release_prog_dtsul = p_cod_release      
           tt_ped_exec.tta_dat_exec_ped_exec      = today
           tt_ped_exec.tta_hra_exec_ped_exec      = replace(string(TIME + 180,"HH:MM:SS"), ":", "")
           tt_ped_exec.tta_cod_servid_exec        = c-servidor
           tt_ped_exec.tta_cdn_estil_dwb          = 97.

    create tt_ped_exec_param.
    assign tt_ped_exec_param.tta_num_seq              = i-cont-aux
           tt_ped_exec_param.tta_cod_dwb_file         = "ftp/ft2100rp.p"
           tt_ped_exec_param.tta_cod_dwb_output       = 'Arquivo'
           tt_ped_exec_param.tta_nom_dwb_printer      = p_arquivo.

    raw-transfer tt-param-ft2100       to tt_ped_exec_param.tta_raw_param_ped_exec.

    run btb/btb912zb.p (input-output table tt_param_segur,
                        input-output table tt_ped_exec,
                        input table tt_ped_exec_param,
                        input table tt_ped_exec_param_aux,
                        input table tt_ped_exec_sel).

END.

PROCEDURE pi-busca-etiqueta:

    FOR EACH tt-param-esftp128:
        DELETE tt-param-esftp128.
    END.

    DEFINE VARIABLE p_cod_prog_dtsul_w                          AS Character format "x(50)"      no-undo.
    DEFINE VARIABLE p_cod_prog_dtsul_rp                         AS Character format "x(50)"      no-undo.
    DEFINE VARIABLE p_cod_release                               AS Character format "x(9)"       no-undo.
    DEFINE VARIABLE p_cdn_estil_dwb                             AS Integer   format ">>9"        no-undo.
    DEFINE VARIABLE p_arquivo                                   AS Character format "x(50)"      no-undo.
    DEFINE VARIABLE p_destino                                   AS integer   format "9"          no-undo.
    DEFINE VARIABLE p_raw_param                                 AS Raw                           no-undo.
    DEFINE VARIABLE c-servidor                                  AS CHARACTER                     NO-UNDO.
    DEFINE VARIABLE p_num_ped_exec                              AS integer   FORMAT ">>>>9"      no-undo.
    DEFINE VARIABLE raw-param                                   AS RAW.

    ASSIGN i-cont-aux = i-cont-aux + 1.

    FOR FIRST mgesp.ponto-programa NO-LOCK
        WHERE ponto-programa.nome-programa = "wso0003"
          AND ponto-programa.ponto         = 7,  
        FIRST mgesp.conteudo-programa NO-LOCK
        WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:

       ASSIGN c-servidor = conteudo-programa.conteudo.

    END. /* FOR EACH mgesp.ponto-programa NO-LOCK */

    FOR EACH tt-param-esftp128:
        DELETE tt-param-esftp128.
    END.
    FOR EACH tt_param_segur:
        DELETE tt_param_segur.
    END.
    FOR EACH tt_ped_exec:
        DELETE tt_ped_exec.
    END.
    FOR EACH tt_ped_exec_param:
        DELETE tt_ped_exec_param.
    END.
    FOR EACH tt_ped_exec_param_aux:
        DELETE tt_ped_exec_param_aux.
    END.
    FOR EACH tt_ped_exec_sel:
        DELETE tt_ped_exec_sel.
    END.

    create tt-param-esftp128.
    assign tt-param-esftp128.usuario         = "integra"
           tt-param-esftp128.destino         = 2
           tt-param-esftp128.data-exec       = TODAY 
           tt-param-esftp128.hora-exec       = TIME + 600 
           tt-param-esftp128.cod-estab-ini   = nota-fiscal.cod-estabel
           tt-param-esftp128.cod-estab-fim   = nota-fiscal.cod-estabel
           tt-param-esftp128.serie-ini       = nota-fiscal.serie    
           tt-param-esftp128.serie-fim       = nota-fiscal.serie    
           tt-param-esftp128.nr-nota-ini     = nota-fiscal.nr-nota-fis  
           tt-param-esftp128.nr-nota-fim     = nota-fiscal.nr-nota-fis  
           tt-param-esftp128.dt-emiss-ini    = nota-fiscal.dt-emis-nota 
           tt-param-esftp128.dt-emiss-fim    = nota-fiscal.dt-emis-nota 
           tt-param-esftp128.dia-atual       = NO.

    ASSIGN tt-param-esftp128.arquivo = "esftp128_UNIX.tmp".

    RAW-TRANSFER tt-param-esftp128 TO raw-param.
    
    ASSIGN p_cod_prog_dtsul_w    = "esftp128"           
           p_cod_prog_dtsul_rp   = "esp/ftp/esftp128rp.p"
           p_cod_release         = '2.00.00.000'                    
           p_cdn_estil_dwb       = 97                   
           p_arquivo             = "esftp128.tmp" 
           p_destino             = 2                    
           p_raw_param           = raw-param.  

    create tt_param_segur.
    assign tt_param_segur.tta_num_vers_integr_api      = 3
           tt_param_segur.tta_cod_aplicat_dtsul_corren = "MFT"
           tt_param_segur.tta_cod_empres_usuar         = "1"
           tt_param_segur.tta_cod_grp_usuar_lst        = v_cod_grp_usuar_lst
           tt_param_segur.tta_cod_idiom_usuar          = "POR":U
           tt_param_segur.tta_cod_modul_dtsul_corren   = "MFT"
           tt_param_segur.tta_cod_pais_empres_usuar    = "BRA"
           tt_param_segur.tta_cod_usuar_corren         = v_cod_usuar_corren
           tt_param_segur.tta_cod_usuar_corren_criptog = v_cod_usuar_corren_criptog.

    create tt_ped_exec.
    assign tt_ped_exec.tta_num_seq                = i-cont-aux
           tt_ped_exec.tta_cod_usuario            = tt-param-esftp128.usuario
           tt_ped_exec.tta_cod_prog_dtsul         = p_cod_prog_dtsul_w 
           tt_ped_exec.tta_cod_prog_dtsul_rp      = p_cod_prog_dtsul_rp
           tt_ped_exec.tta_cod_release_prog_dtsul = p_cod_release      
           tt_ped_exec.tta_dat_exec_ped_exec      = today
           tt_ped_exec.tta_hra_exec_ped_exec      = replace(string(TIME + 600,"HH:MM:SS"), ":", "")
           tt_ped_exec.tta_cod_servid_exec        = c-servidor
           tt_ped_exec.tta_cdn_estil_dwb          = 97.

    create tt_ped_exec_param.
    assign tt_ped_exec_param.tta_num_seq              = i-cont-aux
           tt_ped_exec_param.tta_cod_dwb_file         = "esp/ftp/esftp128rp.p"
           tt_ped_exec_param.tta_cod_dwb_output       = 'Arquivo'
           tt_ped_exec_param.tta_nom_dwb_printer      = p_arquivo.

    raw-transfer tt-param-esftp128       to tt_ped_exec_param.tta_raw_param_ped_exec.

    run btb/btb912zb.p (input-output table tt_param_segur,
                        input-output table tt_ped_exec,
                        input table tt_ped_exec_param,
                        input table tt_ped_exec_param_aux,
                        input table tt_ped_exec_sel).

END PROCEDURE.
