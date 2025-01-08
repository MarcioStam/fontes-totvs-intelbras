block-level on error undo, throw.

/** Carrega bibliotecas necessarias **/
using OpenEdge.Net.HTTP.IHttpClientLibrary.
using OpenEdge.Net.HTTP.ConfigBuilder.
using OpenEdge.Net.HTTP.ClientBuilder.
using OpenEdge.Net.HTTP.Credentials.
using OpenEdge.Net.HTTP.IHttpClient.
using OpenEdge.Net.HTTP.IHttpRequest.
using OpenEdge.Net.HTTP.RequestBuilder.
using OpenEdge.Net.URI.
using OpenEdge.Net.HTTP.IHttpResponse.
USING OpenEdge.Core.String.

DEFINE VARIABLE httpUrl AS CHARACTER NO-UNDO.

DEFINE VARIABLE cArquivoXML            AS CHARACTER NO-UNDO.
DEFINE VARIABLE cChaveAcesso           AS CHAR      NO-UNDO.
DEFINE VARIABLE cArquivoFinalTC2       AS CHARACTER FORMAT "x(80)" NO-UNDO.
DEFINE VARIABLE c-linha                AS CHAR      NO-UNDO.

{include/i-prgvrs.i esftp134rp 2.00.00.001}
{esp/esb/esesb000.i}
{esp/wso/out/wso0005.i}

{esp/es0018.i}

DEFINE VARIABLE oXML          AS LONGCHAR NO-UNDO.

DEFINE VARIABLE c-arquivo-csv AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-dir-saida   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-arq-excel   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE h-acomp       AS HANDLE      NO-UNDO.
DEF VAR l_var AS LONGCHAR. 

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
    FIELD cnr-pedido       AS CHAR
    FIELD c-xml            AS CHAR.
   
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

{utp/ut-glob.i}

DO ON STOP UNDO, LEAVE:

    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
    RUN pi-inicializar in h-acomp (input "Integrando ...").
    
    FOR FIRST param-gener NO-LOCK 
        WHERE param-gener.cod-chave-1 = "param-geral-tc"
          AND param-gener.cod-param   = "dir-doctos-lidos":
        ASSIGN cArquivoXML = param-gener.cod-valor. /*Pasta Received*/
    END.
    
    IF cArquivoXML = "" THEN NEXT.
    
    ASSIGN cArquivoXML = replace(cArquivoXML,"~/","\").
    
    IF  SUBSTRING(cArquivoXML, LENGTH(cArquivoXML), 1) <> "\" THEN
        ASSIGN cArquivoXML = cArquivoXML + "\".
    ASSIGN cArquivoXML = cArquivoXML + "RECEIVED\".

    RUN pi-acompanhar in h-acomp (input cArquivoXML).

    FOR LAST int-pedido-vtex NO-LOCK
       WHERE int-pedido-vtex.nr-pedido = tt-param.cnr-pedido
         AND int-pedido-vtex.nr-pedcli <> "":
    
        FIND FIRST emitente NO-LOCK WHERE emitente.cgc = int-pedido-vtex.num-docto NO-ERROR.
        FIND LAST nota-fiscal NO-LOCK
            WHERE nota-fiscal.nome-ab-cli = emitente.nome-abrev
              AND nota-fiscal.nr-pedcli   = int-pedido-vtex.nr-pedcli
              AND nota-fiscal.idi-sit-nf-eletro = 3 NO-ERROR.
        IF AVAIL nota-fiscal THEN DO:
            FOR LAST integr-totvs-colab NO-LOCK 
               WHERE integr-totvs-colab.cod-edi = "170"
                 AND integr-totvs-colab.cod-docto = nota-fiscal.cod-chave-aces-nf-eletro
                 AND integr-totvs-colab.cod-origem = 2:
                ASSIGN cArquivoFinalTC2 = cArquivoXML + trim(ENTRY(2, integr-totvs-colab.cod-msg, "|")).
            END.
        END.
        
        COPY-LOB FROM FILE cArquivoFinalTC2 TO l_var.
        RUN pi-integra(INPUT REPLACE(int-pedido-vtex.nr-pedido,"MLP-",""), INPUT string(l_var)).
    END.

    RUN pi-finalizar IN h-acomp.

    OUTPUT STREAM str-excel CLOSE.

    RETURN "OK".   
END.

PROCEDURE pi-integra:

    DEF INPUT PARAM nr-pedido AS CHAR NO-UNDO.
    DEF INPUT PARAM c-xml     AS CHAR NO-UNDO.
    DEFINE VARIABLE oRequest AS IHttpRequest NO-UNDO.
    DEFINE VARIABLE oRequestText AS IHttpRequest NO-UNDO.
    DEFINE VARIABLE oResponse AS IHttpResponse NO-UNDO.
    DEFINE VARIABLE c-retorno AS CHAR NO-UNDO.
    DEFINE VARIABLE iXml      AS STRING        NO-UNDO.
    DEFINE VARIABLE cUrl      AS CHAR          NO-UNDO.

    RUN esp/es0018p.p (INPUT "ESFTP134":U,
                       INPUT 1,
                       INPUT 0,
                       INPUT "":U,
                       OUTPUT TABLE tt-prog-ponto).

    FOR FIRST tt-prog-ponto:
        ASSIGN cUrl = tt-prog-ponto.conteudo.
    END. /* FOR FIRST tt-prog-ponto: */

    SESSION:DEBUG-ALERT = TRUE.
    httpUrl = cUrl + nr-pedido.
   
    ASSIGN iXml = new String(c-xml).
    
    oRequest = RequestBuilder:POST(httpUrl, iXml)
                             :AddHeader("HostName","wso2apim-gateway")
                             :AddHeader("UserName","le052412")
                             :ContentType("application/xml")
                             :AcceptAll()
                             :Request.
    
    oResponse = ClientBuilder:Build():Client:Execute(oRequest).

    /*
    IF  oResponse:StatusCode = 201
    AND oResponse:ContentType = "application/json" THEN DO:
        CAST(oResponse:Entity, JsonObject):Write(c-retorno, true).
    
        MESSAGE oResponse:StatusCode  SKIP
                oResponse:ContentType SKIP
                c-retorno
            VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
       
    END.
    
    IF  oResponse:StatusCode = 400
    AND oResponse:ContentType = "application/json" THEN DO:
        CAST(oResponse:Entity, JsonObject):Write(c-retorno, true).
    
        MESSAGE oResponse:StatusCode  SKIP
                oResponse:ContentType SKIP
                c-retorno
            VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
    
    END.
    */
    
    RETURN "OK".

END.
