/*****************************************************************************
**
**     Objetivo: Criar emitente (parceiro), item (produto) e nota fiscal no GKO. (Um registro por vez)
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

USING com.totvs.framework.api.*.
USING com.totvs.po.*.

{esp/gko/gkapi012.i}
{esp/gko/gkapi001.i}

PROCEDURE integrarParceiro:
    DEF INPUT PARAMETER TABLE FOR tt-parceiro.

    DEFINE VARIABLE oClient                 AS IHttpClient          NO-UNDO. 
    DEFINE VARIABLE oLib                    AS IHttpClientLibrary   NO-UNDO.
    DEFINE VARIABLE oReq                    AS IHttpRequest         NO-UNDO.   
    DEFINE VARIABLE oResp                   AS IHttpResponse        NO-UNDO. 

    /* Erros */
    define variable oJsonObj        as JsonObject         no-undo.
    define variable oArrayErros     as JsonArray          no-undo.
    define variable oPayloadErro    as JsonObject         no-undo.
    DEFINE VARIABLE iContErros      AS INTEGER            NO-UNDO.
    /*********/

    /**/
    DEFINE VARIABLE oUri                AS URI              NO-UNDO.

    DEFINE VARIABLE oParceiroComercial       AS JsonObject NO-UNDO.

    DEFINE VARIABLE c-url-base          AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-diretorio-json    AS CHARACTER   NO-UNDO.

    DEFINE VARIABLE c-erro      AS CHARACTER   NO-UNDO.

    EMPTY TEMP-TABLE tt-log-gko.

    /* Valida cadastro no programa ES0018 para a base URL */
    FOR FIRST ponto-programa
        WHERE ponto-programa.nome-programa = "gk0012"
          AND ponto-programa.ponto         = 1,
         EACH conteudo-programa NO-LOCK
        WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
          AND conteudo-programa.sequencia         = 1:
        ASSIGN c-url-base = conteudo-programa.conteudo.
    END.
    IF TRIM(c-url-base) = "" THEN DO:
        /* RCS - Colocar log de URL n∆o encontrada */
        RETURN "NOK":U.
    END.

    assign oURI = new URI("http", c-url-base). 

    FIND FIRST tt-parceiro NO-ERROR.

    ASSIGN oParceiroComercial = JsonAPIUtils:convertTempTableFirstItemToJsonObject(
        TEMP-TABLE tt-parceiro:HANDLE
    ).

    // text/plain
    // application/json
    oReq  = RequestBuilder:POST(c-url-base, oParceiroComercial)
                  :AddHeader("Content-Type", "application/json")
                  :AcceptJson()
                  :Request.

    oLib    = ClientLibraryBuilder:Build():sslVerifyHost(NO):library.
    oClient = ClientBuilder:Build():UsingLibrary(oLib):Client.
    oResp = oClient:Execute(oReq).

    

    


/*     MESSAGE oResp:statusCode SKIP                 */
/*             STRING(lc-json)                       */
/*         VIEW-AS ALERT-BOX INFORMATION BUTTONS OK. */

    FIND FIRST tt-parceiro NO-ERROR.

    IF oResp:statusCode = 200 THEN DO:
        CREATE gko-emitente-integrado.                                                                                                                     
        ASSIGN gko-emitente-integrado.cod-emitente      = tt-parceiro.cod-emitente                                                                              
               gko-emitente-integrado.tipo-operacao     = "A"
               gko-emitente-integrado.dat-integracao    = TODAY
               gko-emitente-integrado.hor-integracao    = TIME.

    END.
    ELSE DO:
        RUN buscarDiretorioJSON (INPUT 2,
                                 OUTPUT c-diretorio-json).

        IF c-diretorio-json <> "" THEN DO:
            FIND FIRST tt-parceiro NO-ERROR.
            DEFINE VARIABLE lc-json AS LONGCHAR   NO-UNDO.
            oParceiroComercial:WRITE(lc-json,TRUE).
            oParceiroComercial:WriteFile(c-diretorio-json + "Emitente_" + STRING(tt-parceiro.cod-emitente) + ".txt").
        END.




        IF TYPE-OF(oResp:Entity, JsonObject) THEN DO:
            oJsonObj = cast(oResp:Entity, JsonObject).
           IF oJsonObj:has("Erros":U) THEN DO:
               oArrayErros = oJsonObj:getJsonArray("Erros":U) NO-ERROR.

               CREATE tt-log-gko.
               ASSIGN tt-log-gko.ind-tipo-integracao    = 6
                      tt-log-gko.log-imp-erro           = YES
                      tt-log-gko.des-erro-imp           = "Emitente: " + STRING(tt-parceiro.cod-emitente) + " n∆o integrado." + CHR(13)
                      tt-log-gko.nom-arquivo-integracao = "Emitente: " + STRING(tt-parceiro.cod-emitente).

               DO iContErros = 1 TO oArrayErros:LENGTH:
                    oPayloadErro = oArrayErros:GetJsonObject(iContErros).
                    ASSIGN c-erro = "".

                    ASSIGN c-erro = 'errorCode:........ ' + IF oPayloadErro:getCharacter("errorCode":U) <> ? THEN oPayloadErro:getCharacter("errorCode":U) + CHR(13) ELSE CHR(13).
                    ASSIGN c-erro = c-erro + 'errorDescription:. ' + IF oPayloadErro:getCharacter("errorDescription":U) <> ? THEN STRING(oPayloadErro:getCharacter("errorDescription":U)) + CHR(13) ELSE CHR(13).
                    ASSIGN c-erro = c-erro + 'errorCode:........ ' + IF oPayloadErro:getCharacter("errorInfo":U)  <> ? THEN oPayloadErro:getCharacter("errorInfo":U) + CHR(13) ELSE CHR(13).

                    IF c-erro <> ? THEN
                        ASSIGN tt-log-gko.des-erro-imp = tt-log-gko.des-erro-imp + c-erro.
               END.
           END.
           ELSE DO:
                CREATE tt-log-gko.
                ASSIGN tt-log-gko.ind-tipo-integracao    = 6
                       tt-log-gko.log-imp-erro           = YES
                       tt-log-gko.nom-arquivo-integracao = "Emitente: " + STRING(tt-parceiro.cod-emitente).
                       

                ASSIGN c-erro = "Emitente: " + STRING(tt-parceiro.cod-emitente) + " n∆o integrado."
                                             + CHR(13)
                                             + "Status Erro: " + STRING(oResp:statusCode) + CHR(13)
                                             + "Raz∆o Erro..: " + oResp:StatusReason + CHR(13).

                IF c-erro <> ? THEN DO:
                    tt-log-gko.des-erro-imp           = c-erro.
                END.
           END.
           IF CAN-FIND(FIRST tt-log-gko) THEN
               RUN esp/gko/gkapi001.p (INPUT TABLE tt-log-gko).
        END.
    END.

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE integrarMaterial:
    DEF INPUT PARAMETER TABLE FOR tt-material.
        
    DEFINE VARIABLE oClient                 AS IHttpClient          NO-UNDO. 
    DEFINE VARIABLE oLib                    AS IHttpClientLibrary   NO-UNDO.
    DEFINE VARIABLE oReq                    AS IHttpRequest         NO-UNDO.   
    DEFINE VARIABLE oResp                   AS IHttpResponse        NO-UNDO. 

    DEFINE VARIABLE oJsonArrayMateriais     AS JsonArray    NO-UNDO.

    /* Erros */
    define variable oJsonObj        as JsonObject         no-undo.
    define variable oArrayErros     as JsonArray          no-undo.
    define variable oPayloadErro    as JsonObject         no-undo.
    DEFINE VARIABLE iContErros      AS INTEGER            NO-UNDO.
    /*********/

    define variable aMateriais              as JsonArray        no-undo.
    DEFINE VARIABLE oMaterial               AS JsonObject       NO-UNDO.
    DEFINE VARIABLE oMateriais              AS JsonObject       NO-UNDO.
    
    DEFINE VARIABLE c-url-base          AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-diretorio-json    AS CHARACTER   NO-UNDO.

    DEFINE VARIABLE c-erro      AS CHARACTER   NO-UNDO.

    EMPTY TEMP-TABLE tt-log-gko.

    /* Valida cadastro no programa ES0018 para a base URL */
    FOR FIRST ponto-programa
        WHERE ponto-programa.nome-programa = "gk0012"
          AND ponto-programa.ponto         = 1,
         EACH conteudo-programa NO-LOCK
        WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
          AND conteudo-programa.sequencia         = 2:
        ASSIGN c-url-base = conteudo-programa.conteudo.
    END.
    IF TRIM(c-url-base) = "" THEN DO:
        /* RCS - Colocar log de URL n∆o encontrada */
        RETURN "NOK":U.
    END.

    FIND FIRST tt-material NO-ERROR.

    ASSIGN oMaterial = JsonAPIUtils:convertTempTableFirstItemToJsonObject(
        TEMP-TABLE tt-material:HANDLE
    ).

    aMateriais = NEW JsonArray().
    aMateriais:ADD(oMaterial).
    oMateriais = NEW JsonObject().
    oMateriais:ADD("Materiais",aMateriais).


    
    oReq  = RequestBuilder:POST(c-url-base, oMateriais)
                  :AddHeader("Content-Type", "application/json")
                  :AcceptJson()
                  :Request.

    oLib    = ClientLibraryBuilder:Build():sslVerifyHost(NO):library.
    oClient = ClientBuilder:Build():UsingLibrary(oLib):Client.
    oResp = oClient:Execute(oReq).

    FIND FIRST tt-material NO-ERROR.

   
    IF oResp:statusCode = 200 THEN DO:
        CREATE gko-item-integrado.                                                                                                                     
        ASSIGN gko-item-integrado.it-codigo         = tt-material.it-codigo                                                                              
               gko-item-integrado.tipo-operacao     = "A"
               gko-item-integrado.dat-integracao    = TODAY
               gko-item-integrado.hor-integracao    = TIME.
    END.
    ELSE DO:


/*             DEFINE VARIABLE lc-json AS LONGCHAR   NO-UNDO. */
/*                                                            */
/*             oMateriais:WRITE(lc-json,TRUE).                */
/*                                                            */
/*                                                            */
/*             MESSAGE STRING(lc-json)                        */
/*                 VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.  */

        IF TYPE-OF(oResp:Entity, JsonObject) THEN DO:
            RUN buscarDiretorioJSON (INPUT 1,
                                     OUTPUT c-diretorio-json).
    
            IF c-diretorio-json <> "" THEN DO:
                FIND FIRST tt-material NO-ERROR.
                DEFINE VARIABLE lc-json AS LONGCHAR   NO-UNDO.
                oMateriais:WRITE(lc-json,TRUE).
                oMateriais:WriteFile(c-diretorio-json + "Item_" + tt-material.it-codigo + ".txt").
            END.

            oJsonObj = cast(oResp:Entity, JsonObject).
            IF oJsonObj:has("Erros":U) THEN DO:
                oArrayErros = oJsonObj:getJsonArray("Erros":U) NO-ERROR.
      
                CREATE tt-log-gko.
                ASSIGN tt-log-gko.ind-tipo-integracao    = 5
                       tt-log-gko.log-imp-erro           = YES
                       tt-log-gko.des-erro-imp           = "Item: " + tt-material.it-codigo + " n∆o integrado." + CHR(13)
                       tt-log-gko.nom-arquivo-integracao = "Item: " + tt-material.it-codigo + " n∆o integrado.".
      
                DO iContErros = 1 TO oArrayErros:LENGTH:
                     oPayloadErro = oArrayErros:GetJsonObject(iContErros) NO-ERROR.
                     ASSIGN c-erro = "".

                     ASSIGN c-erro = 'errorCode:........ ' + IF oPayloadErro:getCharacter("errorCode":U) <> ? THEN oPayloadErro:getCharacter("errorCode":U) + CHR(13) ELSE CHR(13).
                     ASSIGN c-erro = c-erro + 'errorDescription:. ' + IF oPayloadErro:getCharacter("errorDescription":U) <> ? THEN STRING(oPayloadErro:getCharacter("errorDescription":U)) + CHR(13) ELSE CHR(13).
                     ASSIGN c-erro = c-erro + 'errorCode:........ ' + IF oPayloadErro:getCharacter("errorInfo":U)  <> ? THEN oPayloadErro:getCharacter("errorInfo":U) + CHR(13) ELSE CHR(13).
                     
                    IF c-erro <> ? THEN
                        ASSIGN tt-log-gko.des-erro-imp = tt-log-gko.des-erro-imp + c-erro.

                    // Erro de quando o item j† est† cadastrado no GKO
                    IF oPayloadErro:getCharacter("errorCode":U) = "0008" THEN DO:

                        CREATE gko-item-integrado.                                                                                                                     
                        ASSIGN gko-item-integrado.it-codigo         = tt-material.it-codigo                                                                              
                               gko-item-integrado.tipo-operacao     = "A"
                               gko-item-integrado.dat-integracao    = TODAY
                               gko-item-integrado.hor-integracao    = TIME.
                        EMPTY TEMP-TABLE tt-log-gko.
                        LEAVE.

                    END.
      
                END.
            END.
            ELSE DO:
                 CREATE tt-log-gko.
                 ASSIGN tt-log-gko.ind-tipo-integracao    = 5
                        tt-log-gko.log-imp-erro           = YES
                        tt-log-gko.nom-arquivo-integracao = "Item: " + tt-material.it-codigo + " n∆o integrado."
                        tt-log-gko.des-erro-imp           = tt-material.it-codigo + "Item: " + tt-material.it-codigo + " n∆o integrado."
                                                          + CHR(13)
                                                          + "Status Erro: " + STRING(oResp:statusCode) + CHR(13)
                                                          + "Raz∆o Erro..: " + oResp:StatusReason + CHR(13) NO-ERROR.

                IF c-erro <> ? THEN DO:
                    tt-log-gko.des-erro-imp           = c-erro.
                END.
            END.

            IF CAN-FIND(FIRST tt-log-gko) THEN
                RUN esp/gko/gkapi001.p (INPUT TABLE tt-log-gko).
        END.
    END.

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE integrarNotaFiscal:
    DEF INPUT PARAMETER TABLE FOR tt-nota-fiscal.
    DEF INPUT PARAMETER TABLE FOR tt-item-nota-fiscal.

    DEFINE VARIABLE oClient                 AS IHttpClient          NO-UNDO. 
    DEFINE VARIABLE oLib                    AS IHttpClientLibrary   NO-UNDO.
    DEFINE VARIABLE oReq                    AS IHttpRequest         NO-UNDO.   
    DEFINE VARIABLE oResp                   AS IHttpResponse        NO-UNDO. 

    DEFINE VARIABLE oJsonArrayMateriais     AS JsonArray    NO-UNDO.
    DEFINE VARIABLE c-erro                  AS CHARACTER   NO-UNDO.

    /* Erros */
    define variable oJsonObj        as JsonObject         no-undo.
    define variable oArrayErros     as JsonArray          no-undo.
    define variable oPayloadErro    as JsonObject         no-undo.
    DEFINE VARIABLE iContErros      AS INTEGER            NO-UNDO.
    /*********/

    define variable aItens                  as JsonArray        no-undo.
    DEFINE VARIABLE oItem                   AS JsonObject       NO-UNDO.
    DEFINE VARIABLE oNota                   AS JsonObject       NO-UNDO.
    
    DEFINE VARIABLE c-url-base              AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-diretorio-json        AS CHARACTER   NO-UNDO.

    FOR FIRST tt-nota-fiscal:
    END.
    EMPTY TEMP-TABLE tt-log-gko.

    /* Valida cadastro no programa ES0018 para a base URL */
    FOR FIRST ponto-programa
        WHERE ponto-programa.nome-programa = "gk0012"
          AND ponto-programa.ponto         = 1,
         EACH conteudo-programa NO-LOCK
        WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
          AND conteudo-programa.sequencia         = 3:
        ASSIGN c-url-base = conteudo-programa.conteudo.
    END.
    IF TRIM(c-url-base) = "" THEN DO:
        /* RCS - Colocar log de URL n∆o encontrada */
        RETURN "NOK":U.
    END.

    FIND FIRST tt-nota-fiscal NO-ERROR.

    ASSIGN oNota = JsonAPIUtils:convertTempTableFirstItemToJsonObject(
        TEMP-TABLE tt-nota-fiscal:HANDLE
    ).
        
    ASSIGN aItens = JsonAPIUtils:convertTempTableToJsonArray(
        TEMP-TABLE tt-item-nota-fiscal:HANDLE
    ).

    oNota:ADD("Itens",aItens).
   
    FIND FIRST tt-nota-fiscal NO-ERROR.

    oReq  = RequestBuilder:POST(c-url-base, oNota)
                  :AddHeader("Content-Type", "application/json")
                  :AcceptJson()
                  :Request.

    oLib    = ClientLibraryBuilder:Build():sslVerifyHost(NO):library.
    oClient = ClientBuilder:Build():UsingLibrary(oLib):Client.
    oResp = oClient:Execute(oReq).

    FIND FIRST tt-nota-fiscal NO-ERROR.

/*     MESSAGE 'oResp:statusCode: ' oResp:statusCode */
/*         VIEW-AS ALERT-BOX INFORMATION BUTTONS OK. */

    IF oResp:statusCode = 200 THEN DO:
        FIND FIRST gko-nfs-integrada NO-LOCK
             WHERE gko-nfs-integrada.cod-estabel               = tt-nota-fiscal.cod-estabel   
               AND gko-nfs-integrada.serie                     = tt-nota-fiscal.serie         
               AND gko-nfs-integrada.nr-nota-fis               = tt-nota-fiscal.nr-nota-fis
               AND gko-nfs-integrada.cod-chave-aces-nf-eletr   = tt-nota-fiscal.cod-chave-aces-nf-eletro
               AND gko-nfs-integrada.cod-emitente              = tt-nota-fiscal.customerCodeSender           
 

            /*   AND gko-nfs-integrada.tipo-operacao = c-TpStatusDNE */ NO-ERROR.
        IF  NOT AVAIL gko-nfs-integrada THEN DO:
            CREATE gko-nfs-integrada.                                                                                                                     
            ASSIGN gko-nfs-integrada.cod-estabel                   = tt-nota-fiscal.cod-estabel                                                                               
                   gko-nfs-integrada.serie                         = tt-nota-fiscal.serie                                                                                     
                   gko-nfs-integrada.nr-nota-fis                   = tt-nota-fiscal.nr-nota-fis
                   gko-nfs-integrada.cod-chave-aces-nf-eletr   = tt-nota-fiscal.cod-chave-aces-nf-eletro 
                   gko-nfs-integrada.cod-emitente              = tt-nota-fiscal.customerCodeSender.   
        END.
        ASSIGN gko-nfs-integrada.dat-integracao = TODAY
               gko-nfs-integrada.hor-integracao = TIME. 
    END.
    ELSE DO:
        RUN buscarDiretorioJSON (INPUT 3,
                                 OUTPUT c-diretorio-json).

        IF c-diretorio-json <> "" THEN DO:
            IF NOT AVAIL tt-nota-fiscal THEN
                FIND FIRST tt-nota-fiscal NO-ERROR.
            DEFINE VARIABLE lc-json AS LONGCHAR   NO-UNDO.
            oNota:WRITE(lc-json,TRUE).
            oNota:WriteFile(c-diretorio-json + "Nota_" + tt-nota-fiscal.cod-estabel + "_" + tt-nota-fiscal.serie + "_" + tt-nota-fiscal.nr-nota-fis + "_" + tt-nota-fiscal.invoiceType + ".txt").
        END.

        IF TYPE-OF(oResp:Entity, JsonObject) THEN DO:
            oJsonObj = cast(oResp:Entity, JsonObject).
            IF oJsonObj:has("Erros":U) THEN DO:
                oArrayErros = oJsonObj:getJsonArray("Erros":U) NO-ERROR.

                FIND FIRST tt-nota-fiscal NO-ERROR.
      
                CREATE tt-log-gko.
                ASSIGN tt-log-gko.ind-tipo-integracao    = 7
                       tt-log-gko.log-imp-erro           = YES
                       tt-log-gko.nom-arquivo-integracao = "Est: " + tt-nota-fiscal.cod-estabel + " Serie: " + tt-nota-fiscal.serie + " Nr Nota: " + tt-nota-fiscal.nr-nota-fis + " " + tt-nota-fiscal.invoiceType + " n∆o integrada."
                       tt-log-gko.des-erro-imp           = "Est: " + tt-nota-fiscal.cod-estabel + " Serie: " + tt-nota-fiscal.serie + " Nr Nota: " + tt-nota-fiscal.nr-nota-fis + " " + tt-nota-fiscal.invoiceType + " n∆o integrada." + CHR(13).
      
                DO iContErros = 1 TO oArrayErros:LENGTH:
                     ASSIGN oPayloadErro = oArrayErros:GetJsonObject(iContErros).

                     ASSIGN c-erro = "".

                     ASSIGN c-erro = 'errorCode:........ ' + IF oPayloadErro:getCharacter("errorCode":U) <> ? THEN STRING(oPayloadErro:getCharacter("errorCode":U)) + CHR(13) ELSE CHR(13).
                     ASSIGN c-erro = c-erro + 'errorDescription:. ' + IF oPayloadErro:getCharacter("errorDescription":U) <> ? THEN STRING(oPayloadErro:getCharacter("errorDescription":U)) + CHR(13) ELSE CHR(13).
                     ASSIGN c-erro = c-erro + 'errorCode:........ ' + IF oPayloadErro:getCharacter("errorInfo":U)  <> ? THEN oPayloadErro:getCharacter("errorInfo":U) + CHR(13) ELSE CHR(13).
                     
                     IF c-erro <> ? THEN
                         ASSIGN tt-log-gko.des-erro-imp = tt-log-gko.des-erro-imp + c-erro.
      
                END.
            END.
            ELSE DO:
                 CREATE tt-log-gko.
                 ASSIGN tt-log-gko.ind-tipo-integracao    = 7
                        tt-log-gko.log-imp-erro           = YES
                        tt-log-gko.nom-arquivo-integracao = "Est: " + tt-nota-fiscal.cod-estabel + " Serie: " + tt-nota-fiscal.serie + " Nr Nota: " + tt-nota-fiscal.nr-nota-fis + " " + tt-nota-fiscal.invoiceType + " n∆o integrada."
                        tt-log-gko.des-erro-imp           = "Est: " + tt-nota-fiscal.cod-estabel + " Serie: " + tt-nota-fiscal.serie + " Nr Nota: " + tt-nota-fiscal.nr-nota-fis + " " + tt-nota-fiscal.invoiceType + " n∆o integrada."
                                                          + CHR(13)
                                                          + "Status Erro: " + STRING(oResp:statusCode) + CHR(13)
                                                          + "Raz∆o Erro..: " + oResp:StatusReason + CHR(13).
                                              
                 IF c-erro <> ? THEN DO:
                     tt-log-gko.des-erro-imp           = c-erro.
                 END.
            END.
            IF CAN-FIND(FIRST tt-log-gko) THEN
                RUN esp/gko/gkapi001.p (INPUT TABLE tt-log-gko).
        END.
    END.

    RETURN "OK":U.
    

END PROCEDURE.

PROCEDURE buscarDiretorioJSON:
    DEFINE INPUT PARAMETER pSequencia   AS INTEGER NO-UNDO.
    DEFINE OUTPUT PARAMETER pDiretorio  AS CHARACTER NO-UNDO.
    /*
        Sequància para busca de diret¢rio:
        1 - Item
        2 - Parceiro
        3 - Nota Fiscal
    */
   
    IF  OPSYS = "WIN32" THEN DO:
        
        FOR FIRST ponto-programa
            WHERE ponto-programa.nome-programa = "gk0012"
              AND ponto-programa.ponto         = 3,
             EACH conteudo-programa NO-LOCK
            WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
              AND conteudo-programa.sequencia         = pSequencia:
            ASSIGN pDiretorio = REPLACE(conteudo-programa.conteudo,"/","\").
        END.
    
        IF pDiretorio <> "" AND SUBSTRING(pDiretorio,LENGTH(pDiretorio),1) <> "\" THEN
            ASSIGN pDiretorio = pDiretorio + "\".

    END.
    ELSE DO:

        FOR FIRST ponto-programa
            WHERE ponto-programa.nome-programa = "gk0012"
              AND ponto-programa.ponto         = 2,
             EACH conteudo-programa NO-LOCK
            WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
              AND conteudo-programa.sequencia         = pSequencia:
            ASSIGN pDiretorio = REPLACE(conteudo-programa.conteudo,"\","/").
        END.
    
        IF pDiretorio <> "" AND SUBSTRING(pDiretorio,LENGTH(pDiretorio),1) <> "/" THEN
            ASSIGN pDiretorio = pDiretorio + "/".

    END.
    
    

END PROCEDURE.


