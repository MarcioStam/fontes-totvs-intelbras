USING System.Text.*.
USING System.Net.*.
USING Progress.Lang.*.
USING OpenEdge.Core.*.
USING OpenEdge.Core.Collections.List.
USING Progress.Json.ObjectModel.ObjectModelParser.
USING Progress.Json.ObjectModel.JsonObject.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS prmapi.PrmDownloadMercLivre:
        
    {prmapi/PrmDownloadIntegrador.i}

    DEFINE VARIABLE httpClient      AS CLASS System.Net.WebClient       NO-UNDO.
    DEFINE VARIABLE httpWebResponse AS CLASS System.Net.HttpWebResponse NO-UNDO.
    DEFINE VARIABLE cAccessToken    AS CHARACTER                        NO-UNDO.
    DEFINE VARIABLE cUserId         AS CHARACTER                        NO-UNDO.
    
    CONSTRUCTOR PUBLIC PrmDownloadMercLivre(INPUT c-cod-proj-int AS CHARACTER):
        
        EMPTY TEMP-TABLE tt-log.

        FIND FIRST prm-projeto-integrador NO-LOCK
             WHERE prm-projeto-integrador.cod-proj-int = c-cod-proj-int NO-ERROR.
        IF NOT AVAIL prm-projeto-integrador THEN
            UNDO, THROW NEW Progress.Lang.AppError("Projeto Integraá∆o do Mercado Livre n∆o cadastrado. Verifique o programa PRM4103", 0).
        
        IF prm-projeto-integrador.url-token = ? OR TRIM(prm-projeto-integrador.url-token) = "" THEN
            UNDO, THROW NEW Progress.Lang.AppError("URL Token n∆o cadastrada", 0).
        
        IF prm-projeto-integrador.dir-nfe-canc = ? OR TRIM(prm-projeto-integrador.dir-nfe-canc) = "" THEN
            UNDO, THROW NEW Progress.Lang.AppError("Diret¢rio Notas Canceladas n∆o cadastrado", 0).
        
        CATCH erro AS Progress.Lang.Error:
            UNDO, THROW NEW Progress.Lang.AppError(INPUT erro:GetMessage(1), erro:GetMessageNum(1)).
        END CATCH.
    END CONSTRUCTOR.

    METHOD PUBLIC VOID getToken():
        
        DEFINE VARIABLE oJsonResponse   AS JsonObject           NO-UNDO.
        DEFINE VARIABLE oJsonParser     AS ObjectModelParser    NO-UNDO.
        DEFINE VARIABLE webResponse     AS LONGCHAR             NO-UNDO.

        httpClient = NEW System.Net.WebClient().
        //httpClient:PROXY:Credentials = System.Net.CredentialCache:DefaultNetworkCredentials.
        httpClient:Headers:ADD("accept", "application/json").
        httpClient:Headers:ADD("content-type", "application/x-www-form-urlencoded").
        httpClient:ENCODING = Encoding:UTF8.
        //ServicePointManager:SecurityProtocol = CAST(Progress.Util.EnumHelper:Or(SecurityProtocolType:Tls12,SecurityProtocolType:Tls11),SecurityProtocolType).
        
        ASSIGN webResponse = "".
        FIX-CODEPAGE(webResponse) = "UTF-8".

        webResponse = httpClient:UploadString(prm-projeto-integrador.url-token, "POST", SUBSTITUTE("grant_type=&1&&client_id=&2&&client_secret=&3",
                                                                                                   "client_credentials",
                                                                                                   prm-projeto-integrador.app-id,
                                                                                                   prm-projeto-integrador.client-secret)).
        
        ASSIGN oJsonParser   = NEW ObjectModelParser()
               oJsonResponse = CAST(oJsonParser:Parse(webResponse), JsonObject)
               cAccessToken  = STRING(oJsonResponse:GetJsonText("access_token"))
               cUserId       = STRING(oJsonResponse:GetJsonText("user_id")).
        
        CATCH erroNet AS System.Net.WebException:
            UNDO, THROW NEW Progress.Lang.AppError(INPUT erroNet:MESSAGE, 0).
        END CATCH.
        CATCH erro AS Progress.Lang.Error:
            UNDO, THROW NEW Progress.Lang.AppError(INPUT erro:GetMessage(1), erro:GetMessageNum(1)).
        END CATCH.
        FINALLY:
            IF VALID-OBJECT(httpClient) THEN DO:
                httpClient:Dispose().
                DELETE OBJECT httpClient. 
            END.
        END FINALLY.
    END METHOD.

    METHOD PUBLIC VOID getNotasVenda():

        DEFINE VARIABLE c-url       AS CHARACTER    NO-UNDO.
        DEFINE VARIABLE c-dest      AS CHARACTER    NO-UNDO.
        DEFINE VARIABLE c-file-name AS CHARACTER    NO-UNDO.
        DEFINE VARIABLE d-start     AS DATE         NO-UNDO.
        DEFINE VARIABLE d-end       AS DATE         NO-UNDO.
        
        IF prm-projeto-integrador.url-nfe-venda = ? OR TRIM(prm-projeto-integrador.url-nfe-venda) = "" THEN
            UNDO, THROW NEW Progress.Lang.AppError("URL Notas de Venda n∆o cadastrada", 0).
        IF prm-projeto-integrador.dir-nfe-venda = ? OR TRIM(prm-projeto-integrador.url-nfe-venda) = "" THEN
            UNDO, THROW NEW Progress.Lang.AppError("Diret¢rio Notas de Venda n∆o cadastrado", 0).

        httpClient = NEW System.Net.WebClient().
        //httpClient:PROXY:Credentials = System.Net.CredentialCache:DefaultNetworkCredentials.
        httpClient:Headers:ADD("Authorization", SUBSTITUTE("Bearer &1", cAccessToken)).
        httpClient:ENCODING = Encoding:UTF8.
        //ServicePointManager:SecurityProtocol = CAST(Progress.Util.EnumHelper:Or(SecurityProtocolType:Tls12,SecurityProtocolType:Tls11),SecurityProtocolType).
        
        ASSIGN d-start     = TODAY - prm-projeto-integrador.qt-dias
               d-end       = TODAY
               c-url       = REPLACE(prm-projeto-integrador.url-nfe-venda, "USER_ID", cUserId)
               c-url       = c-url + "&start=" + STRING(YEAR(d-start), "9999") + STRING(MONTH(d-start), "99") + STRING(DAY(d-start), "99") + "&"
               c-url       = c-url + "end=" + STRING(YEAR(d-end), "9999") + STRING(MONTH(d-end), "99") + STRING(DAY(d-end), "99")
               c-dest      = SESSION:TEMP-DIR + "NF-VENDA-ML-" + STRING(INTEGER(TODAY))
               c-file-name = c-dest + ".zip".
        
        OS-DELETE NO-CONSOLE VALUE(c-dest) RECURSIVE.

        httpClient:DownloadFile(c-url, c-file-name).
        unzip(INPUT c-file-name, INPUT c-dest).
        
        FILE-INFO:FILE-NAME = c-dest + "/Emitidas_Mercado_Livre".
        IF FILE-INFO:FULL-PATHNAME = ? THEN
            UNDO, THROW NEW Progress.Lang.AppError("Nenhuma nota emitida pelo Mercado Livre encontrada no per°odo", 0).
        
        processarDownload(INPUT c-dest + "/Emitidas_Mercado_Livre/NF-e de venda/XML/Autorizadas",            INPUT prm-projeto-integrador.dir-nfe-venda, INPUT c-url, INPUT "VENDA").
        processarDownload(INPUT c-dest + "/Emitidas_Mercado_Livre/NF-e de venda/XML/Canceladas",             INPUT prm-projeto-integrador.dir-nfe-canc,  INPUT c-url, INPUT "VENDA-CANC").
        processarDownload(INPUT c-dest + "/Emitidas_Mercado_Livre/NF-e de venda/XML/Denegadas_Inutilizadas", INPUT prm-projeto-integrador.dir-nfe-canc,  INPUT c-url, INPUT "VENDA-INUT").

        CATCH erroNet AS System.Net.WebException:
            httpWebResponse = CAST(erroNet:Response, System.Net.HttpWebResponse).
            geraLog(INPUT "",
                    INPUT "VENDA",
                    INPUT IF httpWebResponse:StatusCode = HttpStatusCode:NotFound THEN "Nenhuma nota encontrada no per°odo" ELSE erroNet:MESSAGE).
        END CATCH.
        CATCH erro AS Progress.Lang.Error:
            geraLog(INPUT "",
                    INPUT "VENDA",
                    INPUT SUBSTITUTE("(&1) &2", erro:GetMessageNum(1), erro:GetMessage(1))).
        END CATCH.
        FINALLY:
            
            OS-DELETE NO-CONSOLE VALUE(c-dest) RECURSIVE.
            
            IF VALID-OBJECT(httpClient) THEN DO:
                httpClient:Dispose().
                DELETE OBJECT httpClient.
            END.

            IF VALID-OBJECT(httpWebResponse) THEN DO:
                httpWebResponse:Dispose().
                DELETE OBJECT httpWebResponse.
            END.
        END FINALLY.
    END METHOD.

    METHOD PUBLIC VOID getNotasRemessa():

        DEFINE VARIABLE c-url       AS CHARACTER    NO-UNDO.
        DEFINE VARIABLE c-dest      AS CHARACTER    NO-UNDO.
        DEFINE VARIABLE c-file-name AS CHARACTER    NO-UNDO.
        DEFINE VARIABLE d-start     AS DATE         NO-UNDO.
        DEFINE VARIABLE d-end       AS DATE         NO-UNDO.
        
        IF prm-projeto-integrador.url-nfe-rem = ? OR TRIM(prm-projeto-integrador.url-nfe-rem) = "" THEN
            UNDO, THROW NEW Progress.Lang.AppError("URL Notas de Remessa n∆o cadastrada", 0).
        IF prm-projeto-integrador.dir-nfe-rem = ? OR TRIM(prm-projeto-integrador.dir-nfe-rem) = "" THEN
            UNDO, THROW NEW Progress.Lang.AppError("Diret¢rio Notas de Remessa n∆o cadastrado", 0).

        httpClient = NEW System.Net.WebClient().
        //httpClient:PROXY:Credentials = System.Net.CredentialCache:DefaultNetworkCredentials.
        httpClient:Headers:ADD("Authorization", SUBSTITUTE("Bearer &1", cAccessToken)).
        httpClient:ENCODING = Encoding:UTF8.
        //ServicePointManager:SecurityProtocol = CAST(Progress.Util.EnumHelper:Or(SecurityProtocolType:Tls12,SecurityProtocolType:Tls11),SecurityProtocolType).
        
        ASSIGN d-start     = TODAY - prm-projeto-integrador.qt-dias
               d-end       = TODAY
               c-url       = REPLACE(prm-projeto-integrador.url-nfe-rem, "USER_ID", cUserId)
               c-url       = c-url + "&start=" + STRING(YEAR(d-start), "9999") + STRING(MONTH(d-start), "99") + STRING(DAY(d-start), "99") + "&"
               c-url       = c-url + "end=" + STRING(YEAR(d-end), "9999") + STRING(MONTH(d-end), "99") + STRING(DAY(d-end), "99")
               c-dest      = SESSION:TEMP-DIR + "NF-REMESSA-ML-" + STRING(INTEGER(TODAY))
               c-file-name = c-dest + ".zip".
        
        OS-DELETE NO-CONSOLE VALUE(c-dest) RECURSIVE.

        httpClient:DownloadFile(c-url, c-file-name).
        unzip(INPUT c-file-name, INPUT c-dest).
        
        FILE-INFO:FILE-NAME = c-dest + "/Emitidas_Mercado_Livre".
        IF FILE-INFO:FULL-PATHNAME = ? THEN 
            UNDO, THROW NEW Progress.Lang.AppError("Nenhuma nota emitida pelo Mercado Livre encontrada no per°odo", 0).
        
        processarDownload(INPUT c-dest + "/Emitidas_Mercado_Livre/Outros documentos/Notas de transferància", INPUT prm-projeto-integrador.dir-nfe-rem, INPUT c-url, INPUT "REMESSA").

        CATCH erroNet AS System.Net.WebException:
            httpWebResponse = CAST(erroNet:Response, System.Net.HttpWebResponse).
            geraLog(INPUT "",
                    INPUT "REMESSA",
                    INPUT IF httpWebResponse:StatusCode = HttpStatusCode:NotFound THEN "Nenhuma nota encontrada no per°odo" ELSE erroNet:MESSAGE).
        END CATCH.
        CATCH erro AS Progress.Lang.Error:
            geraLog(INPUT "",
                    INPUT "REMESSA",
                    INPUT SUBSTITUTE("(&1) &2", erro:GetMessageNum(1), erro:GetMessage(1))).
        END CATCH.
        FINALLY:
            
            OS-DELETE NO-CONSOLE VALUE(c-dest) RECURSIVE.
            
            IF VALID-OBJECT(httpClient) THEN DO:
                httpClient:Dispose().
                DELETE OBJECT httpClient.
            END.

            IF VALID-OBJECT(httpWebResponse) THEN DO:
                httpWebResponse:Dispose().
                DELETE OBJECT httpWebResponse.
            END.
        END FINALLY.
    END METHOD.

    METHOD PUBLIC VOID getNotasRetorno():

        DEFINE VARIABLE c-url       AS CHARACTER    NO-UNDO.
        DEFINE VARIABLE c-dest      AS CHARACTER    NO-UNDO.
        DEFINE VARIABLE c-file-name AS CHARACTER    NO-UNDO.
        DEFINE VARIABLE d-start     AS DATE         NO-UNDO.
        DEFINE VARIABLE d-end       AS DATE         NO-UNDO.
        
        IF prm-projeto-integrador.url-nfe-ret = ? OR TRIM(prm-projeto-integrador.url-nfe-ret) = "" THEN
            UNDO, THROW NEW Progress.Lang.AppError("URL Notas de Retorno n∆o cadastrada", 0).
        IF prm-projeto-integrador.dir-nfe-ret = ? OR TRIM(prm-projeto-integrador.dir-nfe-ret) = "" THEN
            UNDO, THROW NEW Progress.Lang.AppError("Diret¢rio Notas de Retorno n∆o cadastrado", 0).

        httpClient = NEW System.Net.WebClient().
        //httpClient:PROXY:Credentials = System.Net.CredentialCache:DefaultNetworkCredentials.
        httpClient:Headers:ADD("Authorization", SUBSTITUTE("Bearer &1", cAccessToken)).
        httpClient:ENCODING = Encoding:UTF8.
        //ServicePointManager:SecurityProtocol = CAST(Progress.Util.EnumHelper:Or(SecurityProtocolType:Tls12,SecurityProtocolType:Tls11),SecurityProtocolType).
        
        ASSIGN d-start     = TODAY - prm-projeto-integrador.qt-dias
               d-end       = TODAY
               c-url       = REPLACE(prm-projeto-integrador.url-nfe-ret, "USER_ID", cUserId)
               c-url       = c-url + "&start=" + STRING(YEAR(d-start), "9999") + STRING(MONTH(d-start), "99") + STRING(DAY(d-start), "99") + "&"
               c-url       = c-url + "end=" + STRING(YEAR(d-end), "9999") + STRING(MONTH(d-end), "99") + STRING(DAY(d-end), "99")
               c-dest      = SESSION:TEMP-DIR + "NF-RETORNO-ML-" + STRING(INTEGER(TODAY))
               c-file-name = c-dest + ".zip".
        
        OS-DELETE NO-CONSOLE VALUE(c-dest) RECURSIVE.

        httpClient:DownloadFile(c-url, c-file-name).
        unzip(INPUT c-file-name, INPUT c-dest).
        
        FILE-INFO:FILE-NAME = c-dest + "/Emitidas_Mercado_Livre".
        IF FILE-INFO:FULL-PATHNAME = ? THEN 
            UNDO, THROW NEW Progress.Lang.AppError("Nenhuma nota emitida pelo Mercado Livre encontrada no per°odo", 0).
            
        processarDownload(INPUT c-dest + "/Emitidas_Mercado_Livre/Outros documentos/Notas de retiro simb¢lica", INPUT prm-projeto-integrador.dir-nfe-ret, INPUT c-url, INPUT "RETORNO").

        CATCH erroNet AS System.Net.WebException:
            httpWebResponse = CAST(erroNet:Response, System.Net.HttpWebResponse).
            geraLog(INPUT "",
                    INPUT "RETORNO",
                    INPUT IF httpWebResponse:StatusCode = HttpStatusCode:NotFound THEN "Nenhuma nota encontrada no per°odo" ELSE erroNet:MESSAGE).
        END CATCH.
        CATCH erro AS Progress.Lang.Error:
            geraLog(INPUT "",
                    INPUT "RETORNO",
                    INPUT SUBSTITUTE("(&1) &2", erro:GetMessageNum(1), erro:GetMessage(1))).
        END CATCH.
        FINALLY:
            
            OS-DELETE NO-CONSOLE VALUE(c-dest) RECURSIVE.
            
            IF VALID-OBJECT(httpClient) THEN DO:
                httpClient:Dispose().
                DELETE OBJECT httpClient.
            END.

            IF VALID-OBJECT(httpWebResponse) THEN DO:
                httpWebResponse:Dispose().
                DELETE OBJECT httpWebResponse.
            END.
        END FINALLY.
    END METHOD.

    METHOD PUBLIC VOID getNotasDevolucao():

        DEFINE VARIABLE c-url       AS CHARACTER    NO-UNDO.
        DEFINE VARIABLE c-dest      AS CHARACTER    NO-UNDO.
        DEFINE VARIABLE c-file-name AS CHARACTER    NO-UNDO.
        DEFINE VARIABLE d-start     AS DATE         NO-UNDO.
        DEFINE VARIABLE d-end       AS DATE         NO-UNDO.
        
        IF prm-projeto-integrador.url-nfe-devol = ? OR TRIM(prm-projeto-integrador.url-nfe-devol) = "" THEN
            UNDO, THROW NEW Progress.Lang.AppError("URL Notas de Devoluá∆o n∆o cadastrada", 0).
        IF prm-projeto-integrador.dir-nfe-devol = ? OR TRIM(prm-projeto-integrador.dir-nfe-devol) = "" THEN
            UNDO, THROW NEW Progress.Lang.AppError("Diret¢rio Notas de Devoluá∆o n∆o cadastrado", 0).

        httpClient = NEW System.Net.WebClient().
        //httpClient:PROXY:Credentials = System.Net.CredentialCache:DefaultNetworkCredentials.
        httpClient:Headers:ADD("Authorization", SUBSTITUTE("Bearer &1", cAccessToken)).
        httpClient:ENCODING = Encoding:UTF8.
        //ServicePointManager:SecurityProtocol = CAST(Progress.Util.EnumHelper:Or(SecurityProtocolType:Tls12,SecurityProtocolType:Tls11),SecurityProtocolType).

        ASSIGN d-start     = TODAY - prm-projeto-integrador.qt-dias
               d-end       = TODAY
               c-url       = REPLACE(prm-projeto-integrador.url-nfe-devol, "USER_ID", cUserId)
               c-url       = c-url + "&start=" + STRING(YEAR(d-start), "9999") + STRING(MONTH(d-start), "99") + STRING(DAY(d-start), "99") + "&"
               c-url       = c-url + "end=" + STRING(YEAR(d-end), "9999") + STRING(MONTH(d-end), "99") + STRING(DAY(d-end), "99")
               c-dest      = SESSION:TEMP-DIR + "NF-DEVOLUCAO-ML-" + STRING(INTEGER(TODAY))
               c-file-name = c-dest + ".zip".
        
        OS-DELETE NO-CONSOLE VALUE(c-dest) RECURSIVE.

        httpClient:DownloadFile(c-url, c-file-name).
        unzip(INPUT c-file-name, INPUT c-dest).
        
        FILE-INFO:FILE-NAME = c-dest + "/Emitidas_Mercado_Livre".
        IF FILE-INFO:FULL-PATHNAME = ? THEN 
            UNDO, THROW NEW Progress.Lang.AppError("Nenhuma nota emitida pelo Mercado Livre encontrada no per°odo", 0).
        
        processarDownload(INPUT c-dest + "/Emitidas_Mercado_Livre/NF-e de devoluá∆o/XML/Autorizadas", INPUT prm-projeto-integrador.dir-nfe-devol, INPUT c-url, INPUT "DEVOLUÄ«O").

        CATCH erroNet AS System.Net.WebException:
            httpWebResponse = CAST(erroNet:Response, System.Net.HttpWebResponse).
            geraLog(INPUT "",
                    INPUT "DEVOLUÄ«O",
                    INPUT IF httpWebResponse:StatusCode = HttpStatusCode:NotFound THEN "Nenhuma nota encontrada no per°odo" ELSE erroNet:MESSAGE).
        END CATCH.
        CATCH erro AS Progress.Lang.Error:
            geraLog(INPUT "",
                    INPUT "DEVOLUÄ«O",
                    INPUT SUBSTITUTE("(&1) &2", erro:GetMessageNum(1), erro:GetMessage(1))).
        END CATCH.
        FINALLY:
            
            OS-DELETE NO-CONSOLE VALUE(c-dest) RECURSIVE.
            
            IF VALID-OBJECT(httpClient) THEN DO:
                httpClient:Dispose().
                DELETE OBJECT httpClient.
            END.

            IF VALID-OBJECT(httpWebResponse) THEN DO:
                httpWebResponse:Dispose().
                DELETE OBJECT httpWebResponse.
            END.
        END FINALLY.
    END METHOD.

    METHOD PUBLIC VOID getCte():

        DEFINE VARIABLE c-url       AS CHARACTER    NO-UNDO.
        DEFINE VARIABLE c-dest      AS CHARACTER    NO-UNDO.
        DEFINE VARIABLE c-file-name AS CHARACTER    NO-UNDO.
        DEFINE VARIABLE d-start     AS DATE         NO-UNDO.
        DEFINE VARIABLE d-end       AS DATE         NO-UNDO.
        
        IF prm-projeto-integrador.url-cte = ? OR TRIM(prm-projeto-integrador.url-cte) = "" THEN
            UNDO, THROW NEW Progress.Lang.AppError("URL CT-e n∆o cadastrada", 0).
        IF prm-projeto-integrador.dir-cte = ? OR TRIM(prm-projeto-integrador.dir-cte) = "" THEN
            UNDO, THROW NEW Progress.Lang.AppError("Diret¢rio CT-e n∆o cadastrado", 0).

        httpClient = NEW System.Net.WebClient().
        //httpClient:PROXY:Credentials = System.Net.CredentialCache:DefaultNetworkCredentials.
        httpClient:Headers:ADD("Authorization", SUBSTITUTE("Bearer &1", cAccessToken)).
        httpClient:ENCODING = Encoding:UTF8.
        //ServicePointManager:SecurityProtocol = CAST(Progress.Util.EnumHelper:Or(SecurityProtocolType:Tls12,SecurityProtocolType:Tls11),SecurityProtocolType).

        ASSIGN d-start     = TODAY - prm-projeto-integrador.qt-dias
               d-end       = TODAY
               c-url       = REPLACE(prm-projeto-integrador.url-cte, "USER_ID", cUserId)
               c-url       = c-url + "&start=" + STRING(YEAR(d-start), "9999") + STRING(MONTH(d-start), "99") + STRING(DAY(d-start), "99") + "&"
               c-url       = c-url + "end=" + STRING(YEAR(d-end), "9999") + STRING(MONTH(d-end), "99") + STRING(DAY(d-end), "99")
               c-dest      = SESSION:TEMP-DIR + "CTE-ML-" + STRING(INTEGER(TODAY))
               c-file-name = c-dest + ".zip".
        
        OS-DELETE NO-CONSOLE VALUE(c-dest) RECURSIVE.

        httpClient:DownloadFile(c-url, c-file-name).
        unzip(INPUT c-file-name, INPUT c-dest).
        
        FILE-INFO:FILE-NAME = c-dest + "/Emitidas_Mercado_Livre".
        IF FILE-INFO:FULL-PATHNAME = ? THEN 
            UNDO, THROW NEW Progress.Lang.AppError("Nenhuma nota emitida pelo Mercado Livre encontrada no per°odo", 0).
        
        processarDownload(INPUT c-dest + "/Emitidas_Mercado_Livre/Outros documentos/CT-e", INPUT prm-projeto-integrador.dir-cte, INPUT c-url, INPUT "CT-e").

        CATCH erroNet AS System.Net.WebException:
            httpWebResponse = CAST(erroNet:Response, System.Net.HttpWebResponse).
            geraLog(INPUT "",
                    INPUT "CT-e",
                    INPUT IF httpWebResponse:StatusCode = HttpStatusCode:NotFound THEN "Nenhuma nota encontrada no per°odo" ELSE erroNet:MESSAGE).
        END CATCH.
        CATCH erro AS Progress.Lang.Error:
            geraLog(INPUT "",
                    INPUT "CT-e",
                    INPUT SUBSTITUTE("(&1) &2", erro:GetMessageNum(1), erro:GetMessage(1))).
        END CATCH.
        FINALLY:
            
            OS-DELETE NO-CONSOLE VALUE(c-dest) RECURSIVE.
            
            IF VALID-OBJECT(httpClient) THEN DO:
                httpClient:Dispose().
                DELETE OBJECT httpClient.
            END.

            IF VALID-OBJECT(httpWebResponse) THEN DO:
                httpWebResponse:Dispose().
                DELETE OBJECT httpWebResponse.
            END.
        END FINALLY.
    END METHOD.

    METHOD PRIVATE VOID unzip(INPUT c-file-name AS CHARACTER, INPUT c-dest AS CHARACTER):
 
        DEFINE VARIABLE c-exe AS CHARACTER NO-UNDO.
        DEFINE VARIABLE c-com AS CHARACTER NO-UNDO.

        ASSIGN c-exe = SEARCH('zip/7za.exe')
               c-com = SUBSTITUTE('"&1" x "&2" -o"&3"', c-exe, c-file-name, c-dest).
        
        OS-COMMAND NO-CONSOLE VALUE(c-com).
        OS-DELETE  NO-CONSOLE VALUE(c-file-name) RECURSIVE.

        CATCH erro AS Progress.Lang.Error:
            UNDO, THROW NEW Progress.Lang.AppError(INPUT erro:GetMessage(1), erro:GetMessageNum(1)).
        END CATCH.
    END METHOD.
    
    METHOD PRIVATE VOID processarDownload(INPUT c-orig AS CHARACTER, INPUT c-dest AS CHARACTER, INPUT c-url AS CHARACTER, INPUT c-desc-tipo AS CHARACTER):
        
        DEFINE VARIABLE c-nome-arquivo  AS CHARACTER NO-UNDO.
        DEFINE VARIABLE c-caminho       AS CHARACTER NO-UNDO.
        DEFINE VARIABLE c-atributos     AS CHARACTER NO-UNDO.

        FILE-INFO:FILE-NAME = c-orig.
        IF FILE-INFO:FULL-PATHNAME <> ? THEN DO:

            INPUT FROM OS-DIR(FILE-INFO:FILE-NAME).

            REPEAT:
                IMPORT c-nome-arquivo
                       c-caminho
                       c-atributos.
    
                IF c-nome-arquivo = "." OR c-nome-arquivo = ".." THEN
                    NEXT.
                
                IF c-atributos = "F" THEN DO:

                    IF ENTRY(NUM-ENTRIES(c-nome-arquivo, "."), c-nome-arquivo, ".") = "xml" THEN DO:
                        
                        FIND FIRST prm-download-integrador NO-LOCK
                             WHERE prm-download-integrador.cod-proj-int = prm-projeto-integrador.cod-proj-int
                               AND prm-download-integrador.arquivo      = c-nome-arquivo NO-ERROR.
                        IF AVAIL prm-download-integrador THEN DO:
                            
                            geraLog(INPUT c-nome-arquivo,
                                    INPUT c-desc-tipo,
                                    INPUT "Download n∆o realizado. XML j† foi baixado anteriormente").
                        END.
                        ELSE DO:
                            OS-COPY VALUE(c-caminho) VALUE(c-dest).
                            CREATE prm-download-integrador.
                            ASSIGN prm-download-integrador.cod-proj-int = prm-projeto-integrador.cod-proj-int
                                   prm-download-integrador.arquivo      = c-nome-arquivo
                                   prm-download-integrador.dt-download  = NOW
                                   prm-download-integrador.url-download = c-url
                                   prm-download-integrador.dir-download = c-orig.

                            geraLog(INPUT c-nome-arquivo,
                                    INPUT c-desc-tipo,
                                    INPUT "Download do XML realizado com sucesso").
                        END.
                    END.
                END.
            END.

            INPUT CLOSE.
        END.

        CATCH erro AS Progress.Lang.Error:
            UNDO, THROW NEW Progress.Lang.AppError(INPUT erro:GetMessage(1), erro:GetMessageNum(1)).
        END CATCH.
    END METHOD.

    METHOD PRIVATE VOID geraLog(INPUT c-arquivo AS CHARACTER, INPUT c-desc-tipo AS CHARACTER, INPUT c-msg AS CHARACTER):
        
        CREATE tt-log.
        ASSIGN tt-log.cod-proj-int = prm-projeto-integrador.cod-proj-int
               tt-log.arquivo      = c-arquivo
               tt-log.tipo         = c-desc-tipo
               tt-log.msg          = c-msg.
    END METHOD.

    METHOD PUBLIC HANDLE getTTLog():
        RETURN TEMP-TABLE tt-log:HANDLE.
    END METHOD.

    DESTRUCTOR PUBLIC PrmDownloadMercLivre():
    END DESTRUCTOR.
END CLASS.
