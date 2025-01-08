/*****************************************************************************
**
**     Objetivo: Importa‡Æo Data Sa¡da Notas no GKO (Embarque)
**
**     Versao..: 2.00.00.000
**     Autor: Ricardo Sutil 
*****************************************************************************/

BLOCK-LEVEL on error undo, throw.

using OpenEdge.Net.HTTP.IHttpClientLibrary.
using OpenEdge.Net.HTTP.ConfigBuilder.
using OpenEdge.Net.HTTP.ClientBuilder.
using OpenEdge.Net.HTTP.Credentials.
using OpenEdge.Net.HTTP.IHttpClient.
USING openEdge.net.http.HTTPHeader.
USING OpenEdge.Net.HTTP.lib.ClientLibraryBuilder.
using OpenEdge.Net.HTTP.IHttpRequest.
using OpenEdge.Net.HTTP.RequestBuilder.
using OpenEdge.Net.HTTP.IHttpResponse.
using OpenEdge.Net.HTTP.HttpClient.

using OpenEdge.Net.URI.

using Progress.Json.ObjectModel.JsonObject.
using Progress.Json.ObjectModel.JsonArray.


USING Progress.Json.ObjectModel.ObjectModelParser.
USING Progress.Lang.Object.
USING OpenEdge.Core.WidgetHandle.
USING OpenEdge.Core.String.
USING OpenEdge.Net.HTTP.IHttpRequest.
USING OpenEdge.Net.HTTP.IHttpResponse.
USING OpenEdge.Net.HTTP.ClientBuilder.
USING OpenEdge.Net.HTTP.RequestBuilder. 

{include/i-prgvrs.i gk0013 2.00.00.000}

{utp/ut-glob.i}
//{esp\es0018.i}

define temp-table tt-param no-undo
    field destino               as integer
    field arquivo               as char format "x(35)":U
    field usuario               as char format "x(12)":U
    field data-exec             as date
    field hora-exec             as integer
    FIELD cod-estabel-ini       LIKE nota-fiscal.cod-estabel
    FIELD cod-estabel-fim       LIKE nota-fiscal.cod-estabel
    FIELD serie-ini             LIKE nota-fiscal.serie
    FIELD serie-fim             LIKE nota-fiscal.serie
    FIELD nr-nota-fis-ini       LIKE nota-fiscal.nr-nota-fis
    FIELD nr-nota-fis-fim       LIKE nota-fiscal.nr-nota-fis    
    FIELD dt-emis-nota-ini      LIKE nota-fiscal.dt-emis-nota
    FIELD dt-emis-nota-fim      LIKE nota-fiscal.dt-emis-nota
    FIELD l-30-dias             AS LOGICAL
    FIELD l-notas-devolucao     AS LOGICAL
    FIELD l-dt-saida            AS LOGICAL
    FIELD l-dt-entrega          AS LOGICAL
    FIELD l-dt-previsao-entrega AS LOGICAL.

define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9":U
    field exemplo          as character format "x(30)":U
    index id ordem.

def temp-table tt-raw-digita
   field raw-digita      as raw.

DEFINE TEMP-TABLE tt-arquivos NO-UNDO
    FIELD nom-arquivo      AS CHAR
    FIELD nom-completo     AS CHAR
    FIELD ind-tipo-arquivo AS CHAR.

DEFINE TEMP-TABLE tt-estabelec NO-UNDO
    FIELD cod-estabel   LIKE estabelec.cod-estabel 
    FIELD cgc           LIKE estabelec.cgc
    INDEX cod-estabel cod-estabel.

DEFINE TEMP-TABLE tt-nota NO-UNDO
    FIELD cod-estabel   LIKE nota-fiscal.cod-estabel
    FIELD serie         LIKE nota-fiscal.serie
    FIELD nr-nota-fis   LIKE nota-fiscal.nr-nota-fis
    FIELD dt-emis-nota  LIKE nota-fiscal.dt-emis-nota.

// {esp/gko/gkapi001.i} /* Defini‡Æo temp-table "tt-log-gko" */

def input param raw-param as raw no-undo.
def input param table for tt-raw-digita.

raw-transfer raw-param to tt-param.

DEFINE VARIABLE h-acomp             AS HANDLE      NO-UNDO.

DEFINE VARIABLE c-url       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-url-base  AS CHARACTER   NO-UNDO.

/********************************************************************/
/* Vari veis ao buscar dados do GKO                                 */
/********************************************************************/
DEFINE VARIABLE l-data-entrega          AS LOGICAL     NO-UNDO.

DEFINE VARIABLE dt-data-devolucao       AS DATETIME   NO-UNDO.
DEFINE VARIABLE dt-data-entrega         AS DATETIME   NO-UNDO.

DEFINE VARIABLE dt-embarque             AS DATE         NO-UNDO.
DEFINE VARIABLE dt-previsao             AS DATE         NO-UNDO.
/******************************************************************/

FIND LAST param-global NO-LOCK NO-ERROR.

// EMPTY TEMP-TABLE tt-log-gko.
EMPTY TEMP-TABLE tt-arquivos.

FOR FIRST tt-param:
END.

IF NOT AVAIL tt-param THEN RETURN.

IF tt-param.l-30-dias THEN
    ASSIGN tt-param.dt-emis-nota-ini  = today - 30
           tt-param.dt-emis-nota-fim  = today.

/* Valida cadastro no programa ES0018 para a base URL */
FOR FIRST ponto-programa
    WHERE ponto-programa.nome-programa = "gk0013"
      AND ponto-programa.ponto         = 1,
     EACH conteudo-programa NO-LOCK
    WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
      AND conteudo-programa.sequencia         = 1:
    ASSIGN c-url-base = conteudo-programa.conteudo.
END.

IF TRIM(c-url-base) = "" THEN DO:
    run utp/ut-msgs.p(input "show",
                      input 17006,
                      input "Base URL nÆo cadastrada" + "~~" +
                            "Base URL nÆo cadastrada no programa ES0018 para o programa GK0013 Ponto 1, Sequencia 1").
    RETURN.
END.

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

RUN pi-inicializar IN h-acomp("Carregando Notas..").

RUN pi-busca-notas-datasul.

RUN pi-finalizar IN h-acomp.

/* respons vel por carregar as notas a serem chamadas conforme parƒmetros passados */
PROCEDURE pi-busca-notas-datasul:
    DEFINE VARIABLE dt-emissao  AS   DATE    NO-UNDO.
    
    DO ON ERROR UNDO,THROW:

        EMPTY TEMP-TABLE tt-estabelec.
        FOR EACH estabelec FIELDS(cod-estabel cgc) NO-LOCK
            WHERE estabelec.cod-estabel     >= tt-param.cod-estabel-ini
            AND   estabelec.cod-estabel     <= tt-param.cod-estabel-fim:
            CREATE tt-estabelec.
            ASSIGN tt-estabelec.cod-estabel = estabelec.cod-estabel
                   tt-estabelec.cgc         = estabelec.cgc.      
        END.
        
        FOR EACH tt-estabelec:
            REPEAT dt-emissao = tt-param.dt-emis-nota-ini TO tt-param.dt-emis-nota-fim:
                FOR EACH nota-fiscal FIELDS(cod-estabel nr-nota-fis serie dt-emis-nota dt-saida dt-entr-cli cod-emitente esp-docto)
                    WHERE nota-fiscal.dt-emis-nota  = dt-emissao
                    AND   nota-fiscal.cod-estabel   = tt-estabelec.cod-estabel
                    AND   nota-fiscal.serie        >= tt-param.serie-ini
                    AND   nota-fiscal.serie        <= tt-param.serie-fim
                    AND   nota-fiscal.nr-nota-fis  >= tt-param.nr-nota-fis-ini
                    AND   nota-fiscal.nr-nota-fis  <= tt-param.nr-nota-fis-fim NO-LOCK:
                    
                    IF (int(nota-fiscal.esp-docto) = 20 //devolucao
                    OR  INT(nota-fiscal.esp-docto) = 22 //saida
                    OR  INT(nota-fiscal.esp-docto) = 23) THEN DO: //transferencia

                        IF (nota-fiscal.serie = "R4" OR
                            nota-fiscal.serie = "FT") THEN NEXT.
                                            
                        IF tt-param.l-notas-devolucao AND tt-param.l-dt-entrega THEN DO:
                            IF (tt-param.l-notas-devolucao = NO AND tt-param.l-dt-previsao-entrega = NO) AND
                               (nota-fiscal.dt-saida <> ? AND nota-fiscal.dt-entr-cli <> ?) THEN NEXT.
                        END.
                        
                        IF tt-param.l-notas-devolucao AND (tt-param.l-dt-entrega              = NO AND 
                                                             tt-param.l-dt-saida              = NO AND 
                                                             tt-param.l-dt-previsao-entrega   = NO) THEN
                              IF nota-fiscal.dt-saida <> ? THEN NEXT.
                        
                        IF tt-param.l-dt-entrega AND (tt-param.l-notas-devolucao        = NO AND 
                                                      tt-param.l-dt-saida               = YES AND 
                                                      tt-param.l-dt-previsao-entrega    = YES) THEN
                            IF nota-fiscal.dt-entr-cli <> ? THEN NEXT.

                        CREATE tt-nota.
                        ASSIGN tt-nota.cod-estabel = nota-fiscal.cod-estabel
                               tt-nota.serie       = nota-fiscal.serie
                               tt-nota.nr-nota-fis = nota-fiscal.nr-nota-fis
                               tt-nota.dt-emis-nota = nota-fiscal.dt-emis-nota.

                    END.
                END.
            END.
            FOR EACH tt-nota
                WHERE tt-nota.cod-estabel = tt-estabelec.cod-estabel:

                IF (tt-nota.cod-estabel = "601") OR
                    (tt-nota.cod-estabel = "602") THEN NEXT.

                RUN pi-acompanhar IN h-acomp("antes API " + string(tt-nota.dt-emis-nota) + " " + STRING(tt-nota.nr-nota-fis) + " " + STRING(tt-nota.cod-estabel)).
                        
                RUN pi-conexao-gko.

                RUN pi-acompanhar IN h-acomp("depoisAPI - " + STRING(tt-nota.dt-emis-nota) + " " + STRING(tt-nota.nr-nota-fis) + " " + STRING(tt-nota.cod-estabel)).

                IF (tt-param.l-dt-saida  AND dt-embarque <> ?) OR
                   (dt-data-entrega <> ?) THEN DO: /* Caso apenas a data de entrega tenha sido alimentada em casa de devolu‡Æo, pois a data de entrega ser  foi alimentada tamb‚m com a data de devolu‡Æo */

                   FOR FIRST nota-fiscal 
                        WHERE nota-fiscal.cod-estabel = tt-nota.cod-estabel 
                          AND nota-fiscal.serie       = tt-nota.serie
                          AND nota-fiscal.nr-nota-fis = tt-nota.nr-nota-fis EXCLUSIVE-LOCK:

                        IF tt-param.l-dt-saida AND dt-embarque <> ? THEN DO:
                            ASSIGN nota-fiscal.dt-saida = dt-embarque.
                        END.
                        
                        IF dt-data-entrega <> ? THEN DO:
                            ASSIGN nota-fiscal.dt-entr-cli = DATE(dt-data-entrega).
                        END.
                   END.
                END.

                IF tt-param.l-dt-entrega OR tt-param.l-notas-devolucao THEN DO:
                    FOR FIRST int-nota-fiscal FIELDS(char-1)
                        WHERE int-nota-fiscal.cod-estabel = tt-nota.cod-estabel
                          AND int-nota-fiscal.serie       = tt-nota.serie
                          AND int-nota-fiscal.nr-nota-fis = tt-nota.nr-nota-fis  EXCLUSIVE-LOCK:

                        IF (tt-param.l-notas-devolucao OR tt-param.l-dt-previsao-entrega) AND 
                          (dt-data-devolucao <> ? OR dt-previsao <> ?) THEN DO:

                            IF tt-param.l-dt-previsao-entrega AND dt-previsao <> ? THEN DO:                     
                               ASSIGN OVERLAY(int-nota-fiscal.char-1,50,10) = STRING(dt-previsao,"99/99/9999").
                            END.                                                                                
                      
                            IF tt-param.l-notas-devolucao AND dt-data-devolucao <> ?  THEN DO:                               
                               ASSIGN OVERLAY(int-nota-fiscal.char-1,61,10) = STRING(DATE(dt-data-devolucao),"99/99/9999").   
                            END.
                        END.
                    END.
                END.
            END. //tt-nota
        END. //tt-estabelec            
    END. //DO ON ERROR UNDO,THROW
END PROCEDURE.

PROCEDURE pi-conexao-gko:
    DEFINE VARIABLE oClient                 AS IHttpClient          NO-UNDO.  
    
    DEFINE VARIABLE oReq                    AS IHttpRequest         NO-UNDO.   
    DEFINE VARIABLE oResp                   AS IHttpResponse        NO-UNDO.   
                                                                   
    DEFINE VARIABLE oLib                    AS IHttpClientLibrary   NO-UNDO.

    DEFINE VARIABLE oArrayRespostas         AS JsonArray   NO-UNDO.
    DEFINE VARIABLE oArrayOcorrencias       AS JsonArray   NO-UNDO.
    
    DEFINE VARIABLE oJsonObj                AS JsonObject  NO-UNDO.
    DEFINE VARIABLE oPayloadResposta        AS JsonObject  NO-UNDO.
    DEFINE VARIABLE oPayloadOcorrencia      AS JsonObject  NO-UNDO.
    DEFINE VARIABLE oPayloadTipoOcorrencia  AS JsonObject  NO-UNDO.
    DEFINE VARIABLE oPayloadEntrega         AS JsonObject  NO-UNDO.

    DEFINE VARIABLE iContRespostas          AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iContOcorrencias        AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-codigo-ocorrencia     AS INTEGER     NO-UNDO.

    ASSIGN dt-embarque          = ?
           dt-previsao          = ?
           dt-data-entrega      = ?
           dt-data-devolucao    = ?.

    DELETE OBJECT oResp     NO-ERROR.
    DELETE OBJECT oLib      NO-ERROR.  
    DELETE OBJECT oClient   NO-ERROR.
    DELETE OBJECT oReq      NO-ERROR.
    
    IF VALID-OBJECT(oJsonObj) THEN
        DELETE OBJECT oJsonObj.

    ASSIGN c-url = c-url-base + "?numero=" + TRIM(STRING(INT(tt-nota.nr-nota-fis),">>>>>>>>>>9")) + "&serie=" + tt-nota.serie + "&cnpj=" + tt-estabelec.cgc.

    oReq  = RequestBuilder:Get(c-url)
                  :AddHeader("Content-Type", "application/json")
                  :AddHeader("cache-control", "no-cache")
                  :AddHeader("Accept-Encoding", "gzip,deflate,br")
                  :AddHeader("Connection","keep-alive")
                  :AcceptJson()
                  // :AddHeader("ApplicationToken",mp-param-integr.ApplicationToken)
                  // :AddHeader("CompanyToken",mp-param-integr.CompanyToken)
                  :Request.

    oLib    = ClientLibraryBuilder:Build():sslVerifyHost(NO):library.
    oClient = ClientBuilder:Build():UsingLibrary(oLib):Client.
    oResp = oClient:Execute(oReq).

    IF oResp:StatusCode = 200 OR oResp:StatusCode = 201 THEN DO:
        if type-of(oResp:Entity, JsonObject) then do:
            DELETE OBJECT oJsonObj NO-ERROR.
            ASSIGN oJsonObj = ?.
           //retorna o objeto com o registro do GKO
           oJsonObj = cast(oResp:Entity, JsonObject).

           IF oJsonObj:has("respostas":U) THEN DO:
               IF oJsonObj:getInteger("totalCount":U) = 0 THEN NEXT.
           END.

           IF VALID-OBJECT(oArrayRespostas) THEN
               DELETE OBJECT oArrayRespostas.
            
           /* Valida Respostas */
           IF oJsonObj:has("respostas":U) THEN DO:
              oArrayRespostas = oJsonObj:getJsonArray("respostas":U).
           END.

           oArrayRespostas = oJsonObj:getJsonArray("respostas":U) NO-ERROR.
           ASSIGN l-data-entrega = NO.

           /* Percorre respostas */
           DO iContRespostas = 1 TO oArrayRespostas:LENGTH:
               IF VALID-OBJECT(oPayloadResposta) THEN
                   DELETE OBJECT oPayloadResposta.

                oPayloadResposta = oArrayRespostas:GetJsonObject(iContRespostas).
                ASSIGN dt-embarque          = ?
                       dt-previsao          = ?
                       dt-data-entrega      = ?
                       dt-data-devolucao    = ?.

                IF oPayloadResposta:has("dataEmbarque":U) THEN DO:
                    ASSIGN dt-embarque = oPayloadResposta:getDate("dataEmbarque").
                END.
                IF oPayloadResposta:has("dataPrevisao":U) THEN DO:
                    ASSIGN dt-previsao = oPayloadResposta:getDate("dataPrevisao").
                END.

                IF oPayloadResposta:has("entrega":U) THEN DO:
                    IF VALID-OBJECT(oPayloadEntrega) THEN
                       DELETE OBJECT oPayloadEntrega.
                    oPayloadEntrega = oPayloadResposta:getJsonObject("entrega":U).
                    IF oPayloadEntrega:has("dataEntrega":U) THEN DO:
                        ASSIGN dt-data-entrega = oPayloadEntrega:getDatetime("dataEntrega") NO-ERROR.
                    END.             
                END.
                
                /* Busca ocorrˆncias somente se for necess rio */
                /*IF tt-param.l-dt-entrega OR tt-param.l-notas-devoluca THEN DO:
                    /* Valida ocorrˆncias */
                    IF oPayloadResposta:has("ocorrencias":U) THEN DO:

                        IF VALID-OBJECT(oArrayOcorrencias) THEN
                            DELETE OBJECT oArrayOcorrencias.

                        oArrayOcorrencias = oPayloadResposta:getJsonArray("ocorrencias":U).
                        /* Percorre ocorrˆncias */
                        DO iContOcorrencias = 1 TO oArrayOcorrencias:LENGTH:

                            IF VALID-OBJECT(oPayloadOcorrencia) THEN
                                DELETE OBJECT oPayloadOcorrencia.

                            IF VALID-OBJECT(oPayloadTipoOcorrencia) THEN
                                DELETE OBJECT oPayloadTipoOcorrencia.

                            oPayloadOcorrencia = oArrayOcorrencias:GetJsonObject(iContOcorrencias).

                            /* Valida o tipo de ocorrˆncia  */
                            IF oPayloadOcorrencia:has("tipoOcorrencia":U) THEN DO:
                                oPayloadTipoOcorrencia = oPayloadOcorrencia:GetJsonObject("tipoOcorrencia").
                                
                                /* Busca o c¢digo da ocorrˆncia */
                                ASSIGN i-codigo-ocorrencia = oPayloadTipoOcorrencia:getInteger("codigo") NO-ERROR.
                                ASSIGN dt-data-devolucao = ?.
                                IF (i-codigo-ocorrencia = 25 OR i-codigo-ocorrencia = 72) THEN DO:
                                    ASSIGN dt-data-devolucao = oPayloadOcorrencia:getDatetime("data")
                                           dt-data-entrega   = oPayloadOcorrencia:getDatetime("data"). /* A data de entrega tem que ser a de devolu‡Æo */
                                END.
                                
                                IF tt-param.l-dt-entrega THEN DO:
                                    /* Se for c¢digo 1, atualiza entrega */
                                    IF i-codigo-ocorrencia = 1 THEN
                                        ASSIGN l-data-entrega = YES.
                                END.
                                    
                            END.
                        END.
                    END.

                    IF tt-param.l-dt-entrega AND l-data-entrega  THEN DO:
                        
                        IF oPayloadResposta:has("entrega":U) THEN DO:

                            IF VALID-OBJECT(oPayloadEntrega) THEN
                                DELETE OBJECT oPayloadEntrega.

                            oPayloadEntrega = oPayloadResposta:getJsonObject("entrega":U).
                            IF oPayloadEntrega:has("dataEntrega":U) THEN DO:
                                ASSIGN dt-data-entrega = oPayloadEntrega:getDatetime("dataEntrega") NO-ERROR.
                            END.
                        END.
                    END.
                END.*/
                
            END.
           // oJsonObj:WriteFile("\\homo-gko-01\Fontes Desenvol\FONTES NOVOS\JSONs\" + string(pcNrNotaFis) + "-" + string(pcSerie) + ".txt").
       END.
    END.
    

    RETURN "OK".


END PROCEDURE.


RETURN "ok".



