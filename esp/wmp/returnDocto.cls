/*******************************************************************************************/
/* Autor.........: Carlos da Costa Junior                                                  */
/*                                                                                         */
/* Data..........: 16/11/2022                                                              */
/*                                                                                         */
/* Objetivo......: Classe de envio de Retorno PROTHEUS                                     */
/*******************************************************************************************/
using progress.Json.ObjectModel.*.

class esp.wmp.ReturnDocto
    :

    {esp/wmp/ReturnDoctoEntrada.i}
    {esp/wmp/ReturnDoctoSaida.i}
    {esp/es0018.i}

    def var chHttp                  as com-handle           no-undo.
    def var i-cont                  as int                  no-undo.    
    def var cHostUrl                as char                 no-undo.
    def var cUrl                    as char                 no-undo.
    def var cBaseUrl                as char                 no-undo.
    def var c-etiquetas             as char                 no-undo.
    def var lcData                  as longchar             no-undo.
    def var lcValue                 as longchar             no-undo.
    def var lcStatus                as longchar             no-undo.
    def var lcResult                as longchar             no-undo.
    def var lcResultChar            as char                 no-undo.
    def var lcHttpSend              as longchar             no-undo.
    def var lcHttpReturn            as longchar             no-undo.    
    def var JsonParser              as ObjectModelParser    no-undo.
    def var oJsonObjectResponse     as JsonObject           no-undo.
    def VAR oJsonArrayDocto         as JsonArray            no-undo.
    def VAR oJsonObjectDocto        as JsonObject           no-undo.
    def VAR oJsonObjectDoctoItens   as JsonObject           no-undo.
    def VAR oJsonArrayDoctoItens    as JsonArray            no-undo.
    def var oJsonObject             as JsonObject           no-undo.
    def var ObjectResult            as JsonObject           no-undo.
    def var ObjectResultFull        as JsonObject           no-undo.
    DEF VAR TokenIntelbras          AS CHAR                 NO-UNDO.

    DEF VAR c-url     AS CHAR FORMAT "x(100)" NO-UNDO.
    DEF VAR c-usuario AS CHAR FORMAT "x(100)" NO-UNDO.
    DEF VAR c-senha   AS CHAR FORMAT "x(100)" NO-UNDO.
    
    constructor public ReturnDocto()
        :
        create "WinHttp.WinHttpRequest.5.1" chHttp.
        //assign cBaseUrl = 'https://api.intelbras.com.br/wms/1.0.0/'.
    end constructor.
    
    destructor public ReturnDocto()
        :
        release object chHttp.
        delete object oJsonObject               no-error. 
        delete object ObjectResult              no-error.
        delete object JsonParser                no-error.
        delete object oJsonObjectResponse       no-error.
        DELETE OBJECT oJsonArrayDocto           NO-ERROR.
        DELETE OBJECT oJsonObjectDocto          NO-ERROR.
        DELETE OBJECT oJsonArrayDoctoItens      NO-ERROR.
    
    end destructor. 
    
    method public character removeNull (input p-char as char)
        :
        if p-char = ? then
            return ''.
        else return p-char.
    end method.

    method public void SendData(input inMethod      as char,
                                input inSendData    as longchar,
                                INPUT cToken        AS CHAR):
    
        IF cToken <> "" THEN DO:
            chHttp:open(inMethod, cHostUrl, false) .
            chHttp:open(inMethod, cHostUrl) .
            chHttp:setRequestHeader("Content-Type", 'application/json') .
            chHttp:setRequestHeader("Connection", 'keep-alive') .
            chHttp:setRequestHeader("cache-control" , "no-cache") .
            chHttp:setRequestHeader("Accept-Encoding" , "gzip, deflate, br") .        
            chHttp:setRequestHeader("Authorization" , cToken).
        END.
        ELSE DO: 
            chHttp:open(inMethod, cHostUrl) .
            chHttp:setRequestHeader("grant_type" , "password").
            chHttp:setRequestHeader("username" , c-usuario).
            chHttp:setRequestHeader("password" , c-senha).            
        END.        

        chHttp:send(inSendData).
    end method.

    // Metodo documento de ENTRADA
    method public void ReturnDoctoEntrada(INPUT  table tt-docto-entrada,
                                          INPUT  TABLE tt-docto-entrada-itens,
                                          OUTPUT l-erro as log,
                                          OUTPUT c-msg  as char):

        assign l-erro = no
               c-msg = ''.

        // Busca informa‡äes de URL , usuario e senha
        EMPTY TEMP-TABLE tt-prog-ponto.
        RUN esp/es0018p.p ( INPUT "renovigi":U,
                            INPUT 1,
                            INPUT 0,
                            INPUT "":U,
                            OUTPUT TABLE tt-prog-ponto).
        IF CAN-FIND(FIRST tt-prog-ponto) THEN DO:
            // URL
            FOR FIRST tt-prog-ponto
                WHERE tt-prog-ponto.sequencia = 0:
                ASSIGN c-url = tt-prog-ponto.conteudo.
            END.
        
            // usuar
            FOR FIRST tt-prog-ponto
                WHERE tt-prog-ponto.sequencia = 1:
                ASSIGN c-usuario = tt-prog-ponto.conteudo.
            END.

            // senha
            FOR FIRST tt-prog-ponto
                WHERE tt-prog-ponto.sequencia = 2:
                ASSIGN c-senha = tt-prog-ponto.conteudo.
            END.
        END.

        // Busca TOKEN
        //ASSIGN cHostUrl = "http://renovigienergia132077.protheus.cloudtotvs.com.br:4050/rest/api/oauth2/v1/token?grant_type=password&username=apirestwms&password=Pr0dMPlCzNG3mPyB".
        //ASSIGN cHostUrl = c-url + "=password&username=" + c-usuario + "&password=" + c-senha.
        ASSIGN cHostUrl = c-url.
         
        //Envia o Json para o WS
        SendData("POST", lcData, TokenIntelbras).

        if string(chHttp:status) = '500' then do:
            assign
                l-erro = yes
                c-msg    = '500 - Servidor TOKEN Indispon¡vel (Internal Server Error)'.
            return.
        end.
        
        //Retorno do WS com algum erro
        if string(chHttp:status) < '200' or string(chHttp:status) > '299' then do: //respostas de sucesso 200 ~ 299
            assign
                l-erro = yes
                c-msg    = string(chHttp:status) + ' - ' + string(chHttp:statusText).            
            return.
        end.
        
        //Pega o Response do WS
        fix-codepage(lcResult) = "utf-8":U.

        assign lcResult = chHttp:responseText.

        IF INDEX(lcResult,"access_token") > 0 THEN DO:
            ASSIGN lcResultChar = lcResult.

            ASSIGN TokenIntelbras = entry(4,lcResultChar,'"').
            ASSIGN TokenIntelbras = "Bearer " + TokenIntelbras.
            
        END.

        //Cria o Objeto Principal
        oJsonObject = new JSONObject().
        
        
        EMPTY TEMP-TABLE tt-prog-ponto.
        RUN esp/es0018p.p ( INPUT "renovigi":U,
                            INPUT 1,
                            INPUT 0,
                            INPUT "":U,
                            OUTPUT TABLE tt-prog-ponto).
        IF CAN-FIND(FIRST tt-prog-ponto) THEN DO:
            // URL
            FOR FIRST tt-prog-ponto
                WHERE tt-prog-ponto.sequencia = 3:
                ASSIGN c-url = tt-prog-ponto.conteudo.
            END.
        END.
        ASSIGN cHostUrl = c-url.
        //ASSIGN cHostUrl = "http://renovigienergia132077.protheus.cloudtotvs.com.br:4050/rest/REN99M17/api/fat/v1".

        FOR EACH tt-docto-entrada NO-LOCK:

            oJsonObjectDocto = new JSONObject().

            oJsonObjectDocto:add('filialNotaFiscal'  , tt-docto-entrada.filialNotaFiscal ).
            oJsonObjectDocto:add('numeroNotaFiscal'  , tt-docto-entrada.numeroNotaFiscal ).
            oJsonObjectDocto:add('serieNotaFiscal'   , tt-docto-entrada.serieNotaFiscal  ).
            oJsonObjectDocto:add('codigoFornecedor'  , tt-docto-entrada.codigoFornecedor ).
            oJsonObjectDocto:add('status'            , tt-docto-entrada.statusDocto      ).

            oJsonArrayDoctoItens = new JSONArray().

            FOR EACH tt-docto-entrada-itens  :
                oJsonObjectDoctoItens = new JSONObject().
                oJsonObjectDoctoItens:add('numeroItem',    tt-docto-entrada-itens.numeroItem    ).
                oJsonObjectDoctoItens:add('codigoProduto', tt-docto-entrada-itens.codigoProduto ).
                oJsonObjectDoctoItens:add('quantidade',    tt-docto-entrada-itens.quantidade    ).
                oJsonArrayDoctoItens:add(oJsonObjectDoctoItens).
            END.

            oJsonObjectDocto:add('itens',  oJsonArrayDoctoItens  ).
        end.

        //Joga o arquivo Json na vari vel para envio
        oJsonObjectDocto:Write(lcData, true).

        //Envia o Json para o WS
        SendData("POST", lcData, TokenIntelbras).

        if string(chHttp:status) = '500' then do:
            assign
                l-erro = yes
                c-msg    = '500 - Servidor Indispon¡vel (Internal Server Error)'.
            return.
        end.

        //Retorno do WS com algum erro
        if string(chHttp:status) <> "201" then do:
                
            IF string(chHttp:status) = '200' THEN DO:
                assign c-msg = "Nota j  integrada"
                       l-erro = YES.
                RETURN.
            END.
            ELSE DO:
                assign c-msg = "Erro na integra‡Æo"
                       l-erro = YES.
                RETURN.
            END.

            /*
            assign l-erro  = yes
                   c-msg   = string(chHttp:status) + ' - ' + string(chHttp:statusText).

            //Instancia o Parser
            JsonParser = new ObjectModelParser().

           //Pega o Response do WS
            assign fix-codepage(lcHttpReturn) = "UTF-8".
            assign lcHttpReturn = chHttp:responseText.
            
            //assign lcHttpReturn = codepage-convert(lcHttpReturn,'UTF-8').
    
            message 'string(lcHttpReturn) ' string(lcHttpReturn)
                view-as alert-box info buttons ok.
            
            /*
            //Instancia o Parser
            JsonParser = new ObjectModelParser().
            
            //Faz o cast para um objeto Json
            ObjectResult = cast(JsonParser:Parse(lcHttpReturn), JsonObject).
    
            assign c-msg = ObjectResult:getCharacter('status').
        
            //Faz o cast para um objeto Json
            ObjectResult = cast(JsonParser:Parse(chHttp:responseText), JsonObject).

            //assign oJsonObjectResponse = new JSONObject(chHttp:responseText) no-error.
            assign c-msg = c-msg + ' - ' + removeNull(ObjectResult:getCharacter('message')) no-error.                                                          
            
            */
            */
            
        end.
        ELSE DO:
            assign l-erro = NO
                   c-msg = "Retorno realizado com sucesso".
            RETURN.
        END.

        /*
        //Pega o Response do WS
        FIX-CODEPAGE(lcResult) = "utf-8":U NO-ERROR.
        ASSIGN lcResult = chHttp:responseText.

        JsonParser = NEW ObjectModelParser().
        oJsonObjectResponse = CAST(JsonParser:Parse(lcResult), JsonObject).

        ASSIGN c-msg = removeNull(oJsonObjectResponse:getCharacter("erro")) NO-ERROR.
        */

    END METHOD.

    // Metodo documento de SAIDA
    method public void ReturnDoctoSaida(INPUT  table tt-docto-Saida,
                                        INPUT  TABLE tt-docto-Saida-itens,
                                        OUTPUT l-erro as log,
                                        OUTPUT c-msg  as char):

        assign l-erro = no
               c-msg = ''.

        // Busca informa‡äes de URL , usuario e senha
        EMPTY TEMP-TABLE tt-prog-ponto.
        RUN esp/es0018p.p ( INPUT "renovigi":U,
                            INPUT 1,
                            INPUT 0,
                            INPUT "":U,
                            OUTPUT TABLE tt-prog-ponto).
        IF CAN-FIND(FIRST tt-prog-ponto) THEN DO:
            // URL
            FOR FIRST tt-prog-ponto
                WHERE tt-prog-ponto.sequencia = 0:
                ASSIGN c-url = tt-prog-ponto.conteudo.
            END.
        
            // usuar
            FOR FIRST tt-prog-ponto
                WHERE tt-prog-ponto.sequencia = 1:
                ASSIGN c-usuario = tt-prog-ponto.conteudo.
            END.

            // senha
            FOR FIRST tt-prog-ponto
                WHERE tt-prog-ponto.sequencia = 2:
                ASSIGN c-senha = tt-prog-ponto.conteudo.
            END.
        END.

        // Busca TOKEN
        //ASSIGN cHostUrl = "http://renovigienergia132077.protheus.cloudtotvs.com.br:4050/rest/api/oauth2/v1/token?grant_type=password&username=apirestwms&password=Pr0dMPlCzNG3mPyB".
        //ASSIGN cHostUrl = c-url + "=password&username=" + c-usuario + "&password=" + c-senha.
        ASSIGN cHostUrl = c-url.

         
         //Envia o Json para o WS
        SendData("POST", lcData, TokenIntelbras).

        if string(chHttp:status) = '500' then do:
            assign
                l-erro = yes
                c-msg    = '500 - Servidor TOKEN Indispon¡vel (Internal Server Error)'.
            return.
        end.
        
        //Retorno do WS com algum erro
        if string(chHttp:status) < '200' or string(chHttp:status) > '299' then do: //respostas de sucesso 200 ~ 299
            assign
                l-erro = yes
                c-msg    = string(chHttp:status) + ' - ' + string(chHttp:statusText).            
            return.
        end.
        
        //Pega o Response do WS
        fix-codepage(lcResult) = "utf-8":U.

        assign lcResult = chHttp:responseText.

        IF INDEX(lcResult,"access_token") > 0 THEN DO:
            ASSIGN lcResultChar = lcResult.

            ASSIGN TokenIntelbras = entry(4,lcResultChar,'"').
            ASSIGN TokenIntelbras = "Bearer " + TokenIntelbras.
            
        END.

        //Cria o Objeto Principal
        oJsonObject = new JSONObject().
        
        EMPTY TEMP-TABLE tt-prog-ponto.
        RUN esp/es0018p.p ( INPUT "renovigi":U,
                            INPUT 1,
                            INPUT 0,
                            INPUT "":U,
                            OUTPUT TABLE tt-prog-ponto).
        IF CAN-FIND(FIRST tt-prog-ponto) THEN DO:
            // URL
            FOR FIRST tt-prog-ponto
                WHERE tt-prog-ponto.sequencia = 4:
                ASSIGN c-url = tt-prog-ponto.conteudo.
            END.
        END.
        ASSIGN cHostUrl = c-url.
        //ASSIGN cHostUrl = "http://renovigienergia132077.protheus.cloudtotvs.com.br:4050/rest/REN99M13/api/fat/v1".

        FOR EACH tt-docto-Saida NO-LOCK:

            oJsonObjectDocto = new JSONObject().

            oJsonObjectDocto:add('filialPedido' , tt-docto-Saida.filialPedido).
            oJsonObjectDocto:add('numeroPedido' , tt-docto-Saida.numeroPedido).
            oJsonObjectDocto:add('volume'       , tt-docto-Saida.volume).
            oJsonObjectDocto:add('especie'      , tt-docto-Saida.especie).
            oJsonObjectDocto:add('status'       , tt-docto-Saida.statusDocto).

            oJsonArrayDoctoItens = new JSONArray().

            FOR EACH tt-docto-Saida-itens  :
                oJsonObjectDoctoItens = new JSONObject().
                oJsonObjectDoctoItens:add('numeroItem',    tt-docto-Saida-itens.numeroItem    ).
                oJsonObjectDoctoItens:add('codigoProduto', tt-docto-Saida-itens.codigoProduto ).
                oJsonObjectDoctoItens:add('quantidade',    tt-docto-Saida-itens.quantidade    ).
                oJsonObjectDoctoItens:add('numeroSerie',   tt-docto-Saida-itens.numeroSerie   ).
                oJsonArrayDoctoItens:add(oJsonObjectDoctoItens).
            END.

            oJsonObjectDocto:add('itens',  oJsonArrayDoctoItens  ).
        end.

        //Joga o arquivo Json na vari vel para envio
        oJsonObjectDocto:Write(lcData, true).

        /*
        MESSAGE string(lcData)
            VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
        */

        //Envia o Json para o WS
        SendData("POST", lcData, TokenIntelbras).

        if string(chHttp:status) = '500' then do:
            assign
                l-erro = yes
                c-msg    = '500 - Servidor Indispon¡vel (Internal Server Error)'.
            return.
        end.

        //Retorno do WS com algum erro
        if string(chHttp:status) <> "201" then do:

            IF string(chHttp:status) = '200' THEN DO:
                assign c-msg = "Nota j  integrada"
                       l-erro = YES.
                RETURN.
            END.
            ELSE DO:
                assign c-msg = "Erro na integra‡Æo"
                       l-erro = YES.
                RETURN.
            END.
                
            /*
            assign l-erro  = yes
                   c-msg   = string(chHttp:status) + ' - ' + string(chHttp:statusText).

            //Instancia o Parser
            JsonParser = new ObjectModelParser().

           //Pega o Response do WS
            assign fix-codepage(lcHttpReturn) = "UTF-8".
            assign lcHttpReturn = chHttp:responseText.
            
            //assign lcHttpReturn = codepage-convert(lcHttpReturn,'UTF-8').
    
            message 'string(lcHttpReturn) ' string(lcHttpReturn)
                view-as alert-box info buttons ok.
            
            /*
            //Instancia o Parser
            JsonParser = new ObjectModelParser().
            
            //Faz o cast para um objeto Json
            ObjectResult = cast(JsonParser:Parse(lcHttpReturn), JsonObject).
    
            assign c-msg = ObjectResult:getCharacter('status').
        
            //Faz o cast para um objeto Json
            ObjectResult = cast(JsonParser:Parse(chHttp:responseText), JsonObject).

            //assign oJsonObjectResponse = new JSONObject(chHttp:responseText) no-error.
            assign c-msg = c-msg + ' - ' + removeNull(ObjectResult:getCharacter('message')) no-error.                                                          
            
            */
            */
            
        end.
        ELSE DO:
            assign l-erro = NO
                   c-msg = "Retorno realizado com sucesso".
            RETURN.
        END.

        /*
        //Pega o Response do WS
        FIX-CODEPAGE(lcResult) = "utf-8":U NO-ERROR.
        ASSIGN lcResult = chHttp:responseText.

        JsonParser = NEW ObjectModelParser().
        oJsonObjectResponse = CAST(JsonParser:Parse(lcResult), JsonObject).

        ASSIGN c-msg = removeNull(oJsonObjectResponse:getCharacter("erro")) NO-ERROR.
        */

    END METHOD.

END CLASS.

