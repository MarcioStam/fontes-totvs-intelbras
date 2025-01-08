/*************************************************************************************
Programa ..: 
Data ......: 20/01/2023
Autor......: Bruno Joaquim
Cliente ...: Intelbras
Objetivo ..: API de integra‡Æo WSO/Totvs e ChatBot area de suprimentos
Versao.....: 1.0.0.000
Revisao....: 000 - 24/07/2023 - Bruno Joaquim - Criacao da API

***************************************************************************************/
/* -- Classes Externas Usadas na manipula‡Æo dos JSON ----------*/
USING Progress.Json.ObjectModel.*.
USING OpenEdge.Core.String.
USING OpenEdge.Net.HTTP.IHttpClientLibrary.
USING OpenEdge.Net.HTTP.ConfigBuilder.
USING OpenEdge.Net.HTTP.ClientBuilder.
USING OpenEdge.Net.HTTP.Credentials.
USING OpenEdge.Net.HTTP.IHttpClient.
USING OpenEdge.Net.HTTP.IHttpRequest.
USING OpenEdge.Net.HTTP.IHttpResponse.
USING OpenEdge.Net.HTTP.RequestBuilder.
USING OpenEdge.Net.HTTP.Lib.ClientLibraryBuilder. 
USING OpenEdge.Net.URI.
USING com.totvs.framework.api.*.


/* -- Includes Usadas na manipula‡Æo dos JSON ----------*/

{utp/ut-api.i}
{utp/ut-glob.i}
{cdp/cdcfgman.i}
{utp/ut-api-action.i pi-current-lang                         GET /current-lang~* }
//{utp/ut-api-action.i pi-lista-telefones-nacionais            POST /lista-telefones-nacionais/~* }
{utp/ut-api-action.i pi-lista-telefones-nacionais            GET /lista-telefones-nacionais/~*}
{utp/ut-api-action.i pi-teste                                GET /teste/~*}
{utp/ut-api-action.i pi-lista-ordens                         GET /lista-ordens/~* }
{utp/ut-api-action.i pi-lista-ordens-internacionais          GET /envia-email/~* }
{utp/ut-api-action.i pi-atualiza-data-entrega                PUT /atualiza-data/~* }
{utp/ut-api-notfound.i}  
{method/dbotterr.i}
//{utp/utapi019.i}
{esp/eslib.i}


DEFINE VAR dt-ini AS DATE NO-UNDO.
DEFINE VAR dt-fim AS DATE NO-UNDO.


/* -- Definicao de funcoes ----------*/

function SomenteNumeros returns character private
    (input string_ as character):

    define variable retorno as character no-undo.
    define variable vaux   as character no-undo.
    define variable contador     as integer   no-undo.

    assign
        retorno = "".

    do contador = 1 to length(string_):
        assign
            vaux = substring(string_, contador, 1).

        if asc(vaux) >= 48
            and asc(vaux) <= 57 then
            assign
                retorno = retorno + vaux.
    end.

    return retorno.
end function.

function DataPorExtenso returns character private
    (INPUT date_ AS DATE):

    DEFINE VAR i_day   AS INT FORMAT 99 NO-UNDO.
    DEFINE VAR i_month AS INT FORMAT 99 NO-UNDO.

    DEFINE VAR c_day   AS CHAR NO-UNDO.
    DEFINE VAR c_month AS CHAR NO-UNDO.
    DEFINE VAR c_year  AS CHAR NO-UNDO.
    DEFINE VAR return_ AS CHAR NO-UNDO.

    ASSIGN i_day   = INT(day(date_)).
    ASSIGN i_month = INT(MONTH(date_)).

    ASSIGN c_year  = string(YEAR(date_)).

    ASSIGN return_ = string(i_day,"99") + "/" + string(i_month,"99") + "/" + c_year . 

    RETURN return_ .

END FUNCTION.


FUNCTION dateConverter RETURNS DATE (inputString AS CHARACTER):

    DEFINE VARIABLE yearPart   AS CHARACTER NO-UNDO.
    DEFINE VARIABLE monthPart  AS CHARACTER NO-UNDO.
    DEFINE VARIABLE dayPart    AS CHARACTER NO-UNDO.
    DEFINE VARIABLE newDate    AS CHARACTER NO-UNDO.
    DEFINE VARIABLE outputDate AS DATE NO-UNDO.

    /* Extrai partes da string */
    ASSIGN
        yearPart  = SUBSTRING(inputString, 1, 4)
        monthPart = SUBSTRING(inputString, 6, 2)
        dayPart   = SUBSTRING(inputString, 9, 2).

    /* Monta a nova string no formato "dd-mm-yyyy" */
    ASSIGN newDate    = STRING(dayPart + monthPart + yearPart).
    ASSIGN outputDate = DATE(newDate).

    RETURN outputDate.

END FUNCTION.

PROCEDURE pi-define-data:
    ASSIGN dt-ini = TODAY + 7 .
    ASSIGN dt-fim = TODAY + 21 .
END PROCEDURE.

/* -- Definicao de temp-tables ------*/ 

DEFINE TEMP-TABLE tt-ordens-pre-sel NO-UNDO
    FIELD numero-ordem LIKE prazo-compra.numero-ordem
    FIELD data-entrega LIKE prazo-compra.data-entrega
    FIELD parcela      LIKE prazo-compra.parcela  .

DEFINE TEMP-TABLE tt-ordem NO-UNDO
    FIELD numero-ordem LIKE prazo-compra.numero-ordem
    FIELD cod-emitente LIKE ordem-compra.cod-emitente
    FIELD cod-estabel  LIKE ordem-compra.cod-estabel .


DEFINE TEMP-TABLE tt-emitentes-pre-sel NO-UNDO
    FIELD cod-emitente LIKE emitente.cod-emitente
    FIELD nome-abrev   LIKE emitente.nome-abrev .

DEFINE TEMP-TABLE tt-retorno-json NO-UNDO
    FIELD cod-emitente LIKE emitente.cod-emitente
    FIELD nome-abrev   LIKE emitente.nome-abrev
    FIELD telefone     LIKE cont-emit.telefone.

DEFINE TEMP-TABLE tt-retorno-json2 NO-UNDO
    FIELD numero-ordem  LIKE prazo-compra.numero-ordem
    FIELD num-pedido    LIKE ordem-compra.num-pedido
    FIELD parcela       LIKE prazo-compra.parcela
    FIELD it-codigo     LIKE ITEM.it-codigo
    FIELD item-do-forn  LIKE item-fornec.item-do-forn
    FIELD qt-solic      LIKE ordem-compra.qt-solic
    FIELD data-entrega  AS   DATE.

DEFINE TEMP-TABLE tt-embarques-pre-sel NO-UNDO
    FIELD cod-estabel  LIKE historico-embarque.cod-estabel  
    FIELD embarque     LIKE historico-embarque.embarque 
    FIELD data-entrega LIKE historico-embarque.dt-ult-previsao 
    FIELD numero-ordem LIKE prazo-compra.numero-ordem
    FIELD parcela      LIKE ordens-embarque.parcela
    FIELD cod-emitente LIKE emitente.cod-emitente 
    FIELD it-codigo    LIKE ITEM.it-codigo 
    FIELD qt-solic     LIKE ordem-compra.qt-solic
    INDEX id-data data-entrega.

DEFINE TEMP-TABLE tt-email-emitentes NO-UNDO
    FIELD cod-emitente LIKE emitente.cod-emitente 
    FIELD email        LIKE cont-emit.e-mail
    FIELD nome         LIKE cont-emit.nome .

DEFINE TEMP-TABLE tt-emitentes-internacional NO-UNDO
    FIELD cod-emitente LIKE emitente.cod-emitente.

DEFINE TEMP-TABLE tt-ordens-internacionais NO-UNDO LIKE tt-embarques-pre-sel .


/* -- Procedures ---*/

PROCEDURE pi-lista-telefones-nacionais:

    RUN pi-define-data.

    /* -- Parametos de entrada da API e Variaveis para manutencao do JSON ---*/
        /* -- Parametos de entrada da API e Variaveis para manutencao do JSON ---*/
    DEFINE INPUT  PARAM jsonInput        AS JsonObject NO-UNDO.
    DEFINE OUTPUT PARAM jsonOutput       AS JsonObject NO-UNDO.

    DEFINE VARIABLE jsonData             AS JsonObject NO-UNDO.
    DEFINE VARIABLE jsonContent          AS JsonObject NO-UNDO.
    DEFINE VARIABLE jsonTemplate         AS JsonObject NO-UNDO.
    DEFINE VARIABLE jsonLanguage         AS JsonObject NO-UNDO.
    DEFINE VARIABLE jsonArrayComponents  AS JsonArray  NO-UNDO.
    DEFINE VARIABLE jsonTypeBody         AS JsonObject NO-UNDO.
    DEFINE VARIABLE jsonParameters       AS JsonArray  NO-UNDO.
    DEFINE VARIABLE jsonParameter        AS JsonObject NO-UNDO.
    DEFINE VARIABLE jsonArray            AS JsonArray  NO-UNDO.


    /* -- Processamento Principal ---------- */
    //Listaremos todas as ordens de compra conforme o prazo pr‚ estiuplado
    FOR EACH prazo-compra
       // EACH ordem-compra OF prazo-compra 
        WHERE prazo-compra.data-entrega >= dt-ini
          AND prazo-compra.data-entrega <= dt-fim NO-LOCK:

        FIND FIRST ordem-compra OF prazo-compra NO-LOCK NO-ERROR.
        IF AVAIL ordem-compra THEN DO:
            IF (ordem-compra.cod-estabel NE "103" AND 
                ordem-compra.cod-estabel NE "104") THEN NEXT.
        END.
        
        //Se j  foi recebido a NF desconsideramos esta Ordem
        IF CAN-FIND(FIRST int-prazo-compra
                    WHERE int-prazo-compra.numero-ordem = prazo-compra.numero-ordem
                      AND int-prazo-compra.parcela      = prazo-compra.parcela
                      AND int-prazo-compra.nro-docto NE "") THEN NEXT.             
        
        CREATE tt-ordens-pre-sel.
        ASSIGN tt-ordens-pre-sel.numero-ordem = prazo-compra.numero-ordem
               tt-ordens-pre-sel.data-entrega = prazo-compra.data-entrega .
    
    END.
    
    //Buscaremos todos os emitentes das ordens pre-selecionadas aonde o pais de origem seja o Brasil
    FOR EACH tt-ordens-pre-sel:
        FIND FIRST ordem-compra WHERE ordem-compra.numero-ordem = tt-ordens-pre-sel.numero-ordem NO-LOCK NO-ERROR.
        IF NOT AVAIL ordem-compra THEN NEXT.
        
        //Verifica se o emitente em questao ainda nao foi criado na lista para evitar duplicidades
        FIND FIRST tt-emitentes-pre-sel WHERE tt-emitentes-pre-sel.cod-emitente = ordem-compra.cod-emitente NO-LOCK NO-ERROR.
        IF NOT AVAIL tt-emitentes-pre-sel THEN DO:
            FIND FIRST emitente WHERE emitente.cod-emitente = ordem-compra.cod-emitente 
                                  AND emitente.pais BEGINS "BR" NO-LOCK NO-ERROR.
            IF AVAIL emitente THEN DO:
                CREATE tt-emitentes-pre-sel.
                ASSIGN tt-emitentes-pre-sel.cod-emitente = ordem-compra.cod-emitente
                       tt-emitentes-pre-sel.nome-abrev   = emitente.nome-abrev.
            END.
        END.
    END.
    
    
    // Criaremos a tt de retorno do JSON fazendo um for each a todos os contatos caso o emitente possua mais de um
    // Os contatos listados sao apenas os que a cont-emit.area for logistica
    FOR EACH tt-emitentes-pre-sel:
        FOR FIRST cont-emit WHERE cont-emit.cod-emitente = tt-emitentes-pre-sel.cod-emitente
                             AND cont-emit.area BEGINS "Chatbot"
                             AND cont-emit.telefone <> "" NO-LOCK:

            CREATE tt-retorno-json.
            ASSIGN tt-retorno-json.cod-emitente = cont-emit.cod-emitente
                   tt-retorno-json.nome-abrev   = tt-emitentes-pre-sel.nome-abrev
                   tt-retorno-json.telefone     = IF substring(cont-emit.telefone,1,2) <> "55" THEN "55" + cont-emit.telefone ELSE  cont-emit.telefone  .
        END.
    END.

    
    JsonArray = NEW JSONArray().
    // Aqui vamos montar o JSON que ser  enviado ao WebService -> https://intelbras.http.msging.net/messages
    FOR EACH tt-retorno-json:

        //Criariamos o registro na tabela int-fornecedor-telefone para posterirmente usarmos a tabela como auxilio no filtro das demais API 
        FIND FIRST int-fornecedor-telefone EXCLUSIVE-LOCK WHERE int-fornecedor-telefone.cod-emitente = tt-retorno-json.cod-emitente NO-ERROR.
                                                   //AND int-fornecedor-telefone.telefone     = SomenteNumeros(tt-retorno-json.telefone) NO-LOCK NO-ERROR.
        IF NOT AVAIL int-fornecedor-telefone THEN DO:
            CREATE int-fornecedor-telefone.
            ASSIGN int-fornecedor-telefone.cod-emitente = tt-retorno-json.cod-emitente            
                   int-fornecedor-telefone.telefone     = SomenteNumeros(tt-retorno-json.telefone) .
        END.
        ELSE DO:
            ASSIGN int-fornecedor-telefone.telefone     = SomenteNumeros(tt-retorno-json.telefone) .
        END.

        RELEASE int-fornecedor-telefone. 

        /* Preenchendo os dados */
        jsonData = NEW JsonObject().
        jsonData:ADD("id", STRING(tt-retorno-json.cod-emitente)).
        jsonData:ADD("to" , SomenteNumeros(tt-retorno-json.telefone) + "@wa.gw.msging.net") .
        jsonData:ADD("type", "application/json").
        
        /* Conte£do */
        jsonContent = NEW JsonObject().
        jsonTemplate = NEW JsonObject().
        jsonLanguage = NEW JsonObject().
        jsonContent:ADD("type", "template").
        jsonLanguage:ADD("code", "pt_BR").
        jsonLanguage:ADD("policy", "deterministic").
        jsonTemplate:ADD("name", "fup_suprimentos").
        jsonTemplate:ADD("language", jsonLanguage).
        
        /* Components */
        jsonArrayComponents = NEW JsonArray().
        jsonTypeBody = NEW JsonObject().
        jsonParameters = NEW JsonArray().
        jsonParameter = NEW JsonObject().
        
        /* Definindo os parƒmetros */
        jsonParameter:ADD("text", STRING(tt-retorno-json.nome-abrev)).
        jsonParameter:ADD("type", "text").
        jsonParameters:ADD(jsonParameter).
        jsonParameter = NEW JsonObject().
        jsonParameter:ADD("text", DataPorExtenso(dt-ini)). 
        jsonParameter:ADD("type", "text").
        jsonParameters:ADD(jsonParameter).
        jsonParameter = NEW JsonObject().
        jsonParameter:ADD("text", DataPorExtenso(dt-fim)). 
        jsonParameter:ADD("type", "text").
        jsonParameters:ADD(jsonParameter).
        
        /* Definindo o tipo de corpo e os parƒmetros */
        jsonTypeBody:ADD("type", "body").
        jsonTypeBody:ADD("parameters", jsonParameters).
        jsonArrayComponents:ADD(jsonTypeBody).
        
        /* Adicionando os componentes ao template */
        jsonTemplate:ADD("components", jsonArrayComponents).
        //jsonContent:ADD("components", jsonArrayComponents).
        jsonContent:ADD("template", jsonTemplate).
        /* Adicionando o conte£do ao JSON principal */
        jsonData:ADD("content", jsonContent).

        
        /* Adicionando do JSON principal ao array de retorno */
        JsonArray:ADD(jsonData).
    END.

    jsonOutput = NEW JSONObject().
    jsonOutput:ADD("Request" , JsonArray).

END PROCEDURE . //pi-lista-telefones-nacionais

/* --------------------------------------------------------**/


PROCEDURE pi-lista-ordens:

    RUN pi-define-data.


    def input  param jsonInput  as JsonObject no-undo.
    def output param jsonOutput as JsonObject no-undo.

    def var oResponse           as JsonAPIResponse      no-undo.
    def var oRequestParser      as JsonAPIRequestParser no-undo.
    def var oJsonObject         as JsonObject           no-undo.
    def var jArrayPrincipal     as JsonArray            no-undo.
    
    DEF VAR c-cod-emitente      LIKE emitente.cod-emitente NO-UNDO.
    DEF VAR inputCode           AS CHAR                    NO-UNDO.
    DEF VAR inputType           AS INT                     NO-UNDO. //1 -> Cod-Emitente 2 -> Telefone



    assign oRequestParser = new JsonAPIRequestParser(jsonInput) no-error.

    assign jArrayPrincipal = new JsonArray().
    jArrayPrincipal = oRequestParser:getPathParams() no-error.

    //assign i-num-param = jArrayPrincipal:length no-error.


    ASSIGN inputCode = STRING(JsonAPIUtils:getPropertyJsonArray(jArrayPrincipal, 2)).
    ASSIGN inputType = INT(JsonAPIUtils:getPropertyJsonArray(jArrayPrincipal, 3)).

    IF inputType = 1  THEN DO:
       FIND FIRST emitente NO-LOCK WHERE emitente.cod-emitente = int(inputCode) NO-ERROR.
       IF NOT AVAIL emitente THEN DO:
           jsonOutput = NEW JSONObject().
           jsonOutput:ADD("Status" , "Erro").
           jsonOutput:ADD("Mensagem" , "Emitente nao encontrado").
           RETURN.
       END.
       ASSIGN c-cod-emitente = emitente.cod-emitente.
    END.

    IF inputType = 2  THEN DO:
       FIND FIRST mgesp.int-fornecedor-telefone WHERE int-fornecedor-telefone.telefone = inputCode NO-LOCK NO-ERROR. 
       IF NOT AVAIL mgesp.int-fornecedor-telefone THEN DO:
           jsonOutput = NEW JSONObject().
           jsonOutput:ADD("Status" , "Erro").
           jsonOutput:ADD("Mensagem" , "Telefone nao encontrado").
           RETURN.
       END.
       ASSIGN c-cod-emitente = mgesp.int-fornecedor-telefone.cod-emitente.
    END.

    /* -- Processamento Principal ---------- */
    //Listaremos todas as ordens de compra conforme o prazo pr‚ estiuplado
    IF inputType = 2 THEN DO:
        FOR EACH prazo-compra
           // EACH ordem-compra OF prazo-compra 
            WHERE prazo-compra.data-entrega >= dt-ini  
              AND prazo-compra.data-entrega <= dt-fim  NO-LOCK:

            FIND FIRST ordem-compra OF prazo-compra NO-LOCK NO-ERROR.
            IF AVAIL ordem-compra THEN DO:
                IF (ordem-compra.cod-estabel NE "103" AND 
                    ordem-compra.cod-estabel NE "104") THEN NEXT.
            END.
        
            //Se j  foi recebido a NF desconsideramos esta Ordem
            IF CAN-FIND(FIRST int-prazo-compra
                        WHERE int-prazo-compra.numero-ordem = prazo-compra.numero-ordem
                          AND int-prazo-compra.parcela      = prazo-compra.parcela
                          AND int-prazo-compra.nro-docto NE "") THEN NEXT.             
            
            CREATE tt-ordens-pre-sel.
            ASSIGN tt-ordens-pre-sel.numero-ordem = prazo-compra.numero-ordem
                   tt-ordens-pre-sel.data-entrega = prazo-compra.data-entrega 
                   tt-ordens-pre-sel.parcela      = prazo-compra.parcela .
        
        END.

        //Montagem da temp-table de retorno
        FOR EACH tt-ordens-pre-sel:
            FIND FIRST ordem-compra WHERE ordem-compra.numero-ordem = tt-ordens-pre-sel.numero-ordem
                                      AND ordem-compra.cod-emitente = c-cod-emitente NO-LOCK NO-ERROR.
            IF NOT AVAIL ordem-compra THEN NEXT.
        
            FIND FIRST item-fornec WHERE item-fornec.it-codigo = ordem-compra.it-codigo 
                                     AND item-fornec.cod-emitente = ordem-compra.cod-emitente NO-LOCK NO-ERROR.
            
        
            CREATE tt-retorno-json2.
            ASSIGN tt-retorno-json2.numero-ordem = ordem-compra.numero-ordem
                   tt-retorno-json2.parcela      = tt-ordens-pre-sel.parcela
                   tt-retorno-json2.num-pedido   = ordem-compra.num-pedido
                   tt-retorno-json2.it-codigo    = ordem-compra.it-codigo
                   tt-retorno-json2.item-do-forn = item-fornec.item-do-forn
                   tt-retorno-json2.qt-solic     = ordem-compra.qt-solic
                   tt-retorno-json2.data-entrega = tt-ordens-pre-sel.data-entrega.
            
        END.
    END.
    ELSE IF inputType = 1 THEN DO:

        RUN pi-ordens-internacionais (INPUT c-cod-emitente).

        FOR EACH  tt-embarques-pre-sel 
            WHERE tt-embarques-pre-sel.data-entrega >= dt-ini 
              AND tt-embarques-pre-sel.data-entrega <= dt-fim:
                
             FIND FIRST ordem-compra WHERE ordem-compra.numero-ordem = tt-embarques-pre-sel.numero-ordem NO-LOCK NO-ERROR.
             IF NOT AVAIL ordem-compra THEN NEXT.

             FIND FIRST item-fornec WHERE item-fornec.it-codigo = ordem-compra.it-codigo 
                                     AND item-fornec.cod-emitente = ordem-compra.cod-emitente NO-LOCK NO-ERROR.

             CREATE tt-retorno-json2.
             ASSIGN tt-retorno-json2.numero-ordem = tt-embarques-pre-sel.numero-ordem
                    tt-retorno-json2.parcela      = tt-embarques-pre-sel.parcela
                    tt-retorno-json2.num-pedido   = ordem-compra.num-pedido
                    tt-retorno-json2.it-codigo    = ordem-compra.it-codigo
                    tt-retorno-json2.item-do-forn = item-fornec.item-do-forn
                    tt-retorno-json2.qt-solic     = ordem-compra.qt-solic
                    tt-retorno-json2.data-entrega = tt-embarques-pre-sel.data-entrega.
        END.
    END.       
    
    DEFINE VAR arrayOrdem    AS JSONArray  NO-UNDO.
    DEFINE VAR aOrderItens   AS JSONArray  NO-UNDO.
    DEFINE VAR objOrders     AS JSONObject NO-UNDO.
    DEFINE VAR objOrder      AS JSONObject NO-UNDO.
    DEFINE VAR objOrder2     AS JSONObject NO-UNDO.
    DEFINE VAR oOrderItems   AS JSONObject NO-UNDO.

    DEFINE VAR objParcelas   AS JSONObject NO-UNDO.

    arrayOrdem = NEW JSONArray().
    
    
    FOR EACH tt-retorno-json2 BREAK BY  tt-retorno-json2.num-pedido  :

        IF FIRST-OF(tt-retorno-json2.num-pedido)  THEN DO:
            objOrder = NEW JSONObject().
            objOrder:ADD("num_order" , tt-retorno-json2.num-pedido).

            aOrderItens = NEW JSONArray().
        END.

        oOrderItems = new JSONObject().
        oOrderItems:ADD("item_code",      STRING(tt-retorno-json2.it-codigo)).
        oOrderItems:ADD("manufacturer_pn",STRING(tt-retorno-json2.item-do-forn)).
        oOrderItems:ADD("quantity" ,      STRING(tt-retorno-json2.qt-solic)).
        oOrderItems:ADD("delivery_date",  DataPorExtenso(tt-retorno-json2.data-entrega)). 
        oOrderItems:ADD("buy_order",  STRING(tt-retorno-json2.numero-ordem)).
        oOrderItems:ADD("payment" , STRING(tt-retorno-json2.parcela)).
       

        aOrderItens:ADD(oOrderItems) . 
        
        
        objOrder:ADD("OrderItems",aOrderItens).

        arrayOrdem:ADD(objOrder).

    END.
    


    jsonOutput = NEW JSONObject().
    jsonOutput:ADD("order" , arrayOrdem).

END PROCEDURE . //pi-lista-telefones-nacionais


/* --------------------------------------------------------**/

DEFINE TEMP-TABLE tt-retorno
    FIELD num_order      AS INTEGER
    FIELD num_parcela    AS INTEGER.

//DATASET QUE retorna A TEMP-TABLE gerada
define dataset retorno          FOR tt-retorno.

PROCEDURE pi-atualiza-data-entrega:

    RUN pi-define-data.

    DEF INPUT PARAM poJsonInput AS JsonObject                NO-UNDO.
    DEF OUTPUT PARAM jsonOutput AS JsonObject                NO-UNDO.

    DEF VAR oResponse           AS JsonAPIResponse           NO-UNDO.
    DEF VAR oRequestParser      AS JsonAPIRequestParser      NO-UNDO.
    DEF VAR oJsonObject         AS JsonObject                NO-UNDO.
    DEF VAR jArrayPrincipal     AS JsonArray                 NO-UNDO.

    DEF VAR inputOrder     LIKE prazo-compra.numero-ordem    NO-UNDO.
    DEF VAR inputParcela   LIKE prazo-compra.parcela         NO-UNDO.
    DEF VAR inputDate      AS CHAR                           NO-UNDO.
    DEF VAR novaData       AS DATE                           NO-UNDO.
    DEF VAR l-erro         AS LOG                            NO-UNDO.
    DEF VAR c-status       AS CHAR FORMAT "x(256)"           NO-UNDO.
    
    DEF VAR aJsonInput AS JsonArray NO-UNDO.


    assign oRequestParser = new JsonAPIRequestParser(jsonInput) no-error.

    assign jArrayPrincipal = new JsonArray().
    jArrayPrincipal = oRequestParser:getPathParams() no-error.

    //assign i-num-param = jArrayPrincipal:length no-error.

    ASSIGN inputOrder   = INT(JsonAPIUtils:getPropertyJsonArray(jArrayPrincipal, 2)).
    ASSIGN inputParcela = INT(JsonAPIUtils:getPropertyJsonArray(jArrayPrincipal, 3)).
    ASSIGN inputDate    = STRING(JsonAPIUtils:getPropertyJsonArray(jArrayPrincipal, 4)).

    ASSIGN novaData      = dateConverter(inputDate).
    

    /*------- Vamos determinar se o fornecedor e nacional ou internacional ---------------------------------*/

    
    FIND FIRST ordem-compra WHERE ordem-compra.numero-ordem = inputOrder NO-LOCK NO-ERROR.
    IF NOT AVAIL ordem-compra THEN DO:
        jsonOutput:ADD("Status" , "Erro").
        jsonOutput:ADD("Mensagem" , "Ordem de compra nao encontrada").
        
        RETURN.
    END.
    ELSE DO:
        FIND FIRST emitente WHERE emitente.cod-emitente = ordem-compra.cod-emitente NO-LOCK NO-ERROR.
        IF emitente.pais BEGINS "BR" THEN DO:
            RUN pi-atualiza-datas-fornecedores-nacionais(INPUT  inputOrder,
                                                         INPUT  inputParcela,
                                                         INPUT  novaData,
                                                         OUTPUT l-erro,
                                                         OUTPUT c-status ) .
    
            jsonOutput = NEW JSONObject().
            jsonOutput:ADD("Status" , IF l-erro THEN "Erro" ELSE "OK").
            jsonOutput:ADD("Mensagem" , c-status). 
        END.
        ELSE DO:
            RUN pi-atualiza-datas-fornecedores-internacionais(INPUT  inputOrder,
                                                              INPUT  inputParcela,
                                                              INPUT  novaData,
                                                              OUTPUT l-erro,
                                                              OUTPUT c-status ) .
    
            jsonOutput = NEW JSONObject().
            jsonOutput:ADD("Status" , IF l-erro THEN "Erro" ELSE "OK").
            jsonOutput:ADD("Mensagem" , c-status).
        END.
    END.
    
END.
/*
PROCEDURE pi-envia-email:

    RUN pi-define-data.

    DEFINE INPUT  PARAM c-destino    AS CHAR.
    DEFINE INPUT  PARAM nome-fornec  AS CHAR.
    DEFINE INPUT  PARAM cod-emitente AS INT. 
    DEFINE OUTPUT PARAM  l-erro AS LOG.

    DEFINE VARIABLE i-sequencia AS INTEGER     NO-UNDO.
    DEFINE VARIABLE diferenca   AS INTEGER     NO-UNDO.
    DEFINE VARIABLE c-email     AS CHAR        NO-UNDO.
    DEFINE VARIABLE h-utapi019  AS HANDLE      NO-UNDO.

    RUN utp/utapi019.p PERSISTENT SET h-utapi019.

    ASSIGN c-email = "".

    EMPTY TEMP-TABLE tt-envio2.   
    EMPTY TEMP-TABLE tt-mensagem.
    EMPTY TEMP-TABLE tt-erros.

    CREATE tt-envio2.
    ASSIGN tt-envio2.versao-integracao = 1
           tt-envio2.destino           = c-destino 
           tt-envio2.remetente         = "ems@intelbras.com.br"
           //tt-envio2.copia             = ""
           tt-envio2.assunto           = "Shipments Intelbras"
           //tt-envio2.arq-anexo         = c-arquivo-anexo
           tt-envio2.formato           = "TEXTO" . 

    CREATE tt-mensagem.
    ASSIGN tt-mensagem.seq-mensagem = 1
           tt-mensagem.mensagem     = "Dear, " + nome-fornec + " ~r" +
                                      "You have some shipments estimated for the next two weeks, between the: " + STRING(dt-ini) + "and: " + STRING(dt-fim) + " . ~r" .
                                      
    CREATE tt-mensagem.
    ASSIGN tt-mensagem.seq-mensagem = 2
           tt-mensagem.mensagem     = "Would you like to confirm the shipments dates on the following link link-chatbot ? : https://confirm-orders.apps.intelbras.com.br?supplierCode=" + STRING(cod-emitente) + " ~r" +
                                      "Your supplier code is:" + STRING(cod-emitente) + " ~r" + 
                                      "Best regards, " .
   
    RUN pi-execute2 in h-utapi019 (INPUT  TABLE tt-envio2,
                                   INPUT  TABLE tt-mensagem,
                                   OUTPUT TABLE tt-erros).

    /* TRATAMENTO DE ERROS NO ENVIO DO EMAIL */

    FIND FIRST tt-erros NO-ERROR.
    IF AVAIL tt-erros THEN DO:
        ASSIGN l-erro = YES.
    END.
    ELSE DO:
        l-erro = NO.
    END.
    
    IF  VALID-HANDLE(h-utapi019) 
    THEN 
        DELETE PROCEDURE h-utapi019.

    ASSIGN h-utapi019 = ?.

END.
*/
PROCEDURE pi-lista-ordens-internacionais:    

    DEF INPUT PARAM  JsonInput AS JsonObject NO-UNDO.
    DEF OUTPUT PARAM jsonOutput AS JsonObject NO-UNDO.

    DEFINE VAR l-erro AS LOG NO-UNDO.

    RUN pi-define-data.

    RUN pi-ordens-internacionais (INPUT 0).

    FOR EACH tt-embarques-pre-sel WHERE tt-embarques-pre-sel.data-entrega >= dt-ini 
                                    AND tt-embarques-pre-sel.data-entrega <= dt-fim:

        FOR FIRST cont-emit 
            WHERE cont-emit.cod-emitente = tt-embarques-pre-sel.cod-emitente
              AND cont-emit.area BEGINS "Chatbot"  NO-LOCK :

            FIND FIRST tt-email-emitentes 
                 WHERE tt-email-emitentes.cod-emitente = cont-emit.cod-emitente
                   AND tt-email-emitentes.nome         = cont-emit.nome NO-ERROR.
            IF NOT AVAIL tt-email-emitentes THEN DO:
                CREATE tt-email-emitentes.
                ASSIGN tt-email-emitentes.cod-emitente  = cont-emit.cod-emitente
                       tt-email-emitentes.email         = cont-emit.e-mail
                       tt-email-emitentes.nome          = cont-emit.nome .
            END.
        
        END.
    END.
    /*
    FOR EACH tt-ordens-internacionais WHERE tt-email-emitentes.email <> '':
        RUN pi-envia-email(INPUT tt-email-emitentes.email,
                           INPUT tt-email-emitentes.nome,
                           INPUT tt-email-emitentes.cod-emitente,
                           OUTPUT l-erro).
    END.
    */
    
    FOR EACH  tt-email-emitentes
        WHERE tt-email-emitentes.email <> '':

        DEFINE VAR c-mensagem AS CHAR FORMAT "x(256)".

        ASSIGN c-mensagem = "You have some shipments estimated for the next two weeks, between the: " + STRING(dt-ini) + "and: " + STRING(dt-fim) + "  ~r" +
                            "Would you like to confirm the shipments dates on the following link link-chatbot ? : https://confirm-orders.apps.intelbras.com.br?supplierCode=" + STRING(tt-email-emitentes.cod-emitente) + " ~r" +                                                                            
                            "Your supplier code is:" + STRING(tt-email-emitentes.cod-emitente) + " ~r" +                                                                                                                                                                                                     
                             "Best regards, " . 

        RUN enviaMail (INPUT "ems@intelbras.com.br",
                       INPUT tt-email-emitentes.email,
                       INPUT "Shipments Intelbras",
                       INPUT  c-mensagem,                                                                                                                                                                                                                                          
                       INPUT "").
    END.

    
    IF l-erro = FALSE THEN DO:
        jsonOutput = NEW JSONObject().
        jsonOutput:ADD("Status" , "OK").
    END.
    ELSE DO:
        jsonOutput = NEW JSONObject().
        jsonOutput:ADD("Status" , "Erro").
    END.

END PROCEDURE.

PROCEDURE pi-ordens-internacionais: 

    DEFINE INPUT PARAM p-cod-emitente AS INT NO-UNDO.

    IF p-cod-emitente > 0 THEN DO:
        FOR EACH  ordem-compra NO-LOCK
            WHERE ordem-compra.situacao = 2 
              AND ordem-compra.cod-emitente = p-cod-emitente:
            
            IF (ordem-compra.cod-estabel NE "103" AND 
                ordem-compra.cod-estabel NE "104") THEN NEXT.        
        
            FIND FIRST emitente WHERE emitente.cod-emitente = ordem-compra.cod-emitente NO-LOCK NO-ERROR.        
            IF emitente.pais BEGINS "BR" THEN NEXT.
            ELSE DO:
                CREATE tt-ordem.
                ASSIGN tt-ordem.numero-ordem = ordem-compra.numero-ordem
                       tt-ordem.cod-emitente = ordem-compra.cod-emitente
                       tt-ordem.cod-estabel  = ordem-compra.cod-estabel  .
            END.
        END.
    END.
    ELSE DO:
    
        FOR EACH ordem-compra WHERE situacao = 2 NO-LOCK: 

            IF (ordem-compra.cod-estabel NE "103" AND 
                ordem-compra.cod-estabel NE "104") THEN NEXT.
        
            FIND FIRST emitente WHERE emitente.cod-emitente = ordem-compra.cod-emitente NO-LOCK NO-ERROR.
        
            IF emitente.pais BEGINS "BR" THEN NEXT.
            ELSE DO:
                CREATE tt-ordem.
                ASSIGN  tt-ordem.numero-ordem = ordem-compra.numero-ordem
                        tt-ordem.cod-emitente = ordem-compra.cod-emitente
                        tt-ordem.cod-estabel  = ordem-compra.cod-estabel  .
            END.
        END.
    END.


    FOR EACH tt-ordem:

        FOR EACH prazo-compra WHERE prazo-compra.numero-ordem =  tt-ordem.numero-ordem NO-LOCK:
            CREATE tt-embarques-pre-sel.
            ASSIGN tt-embarques-pre-sel.numero-ordem   = prazo-compra.numero-ordem
                   tt-embarques-pre-sel.parcela        = prazo-compra.parcela 
                   tt-embarques-pre-sel.cod-emitente   = tt-ordem.cod-emitente 
                   tt-embarques-pre-sel.cod-estabel    = tt-ordem.cod-estabel . 
        END.

    END.
    /*--------------------------------------------------------------------------------*/


    FOR EACH tt-embarques-pre-sel:

        FIND FIRST cotacao-item NO-LOCK 
             WHERE cotacao-item.numero-ordem = tt-embarques-pre-sel.numero-ordem 
               AND cotacao-item.cod-emitente = tt-embarques-pre-sel.cod-emitente  NO-ERROR.

        FIND FIRST itinerario NO-LOCK WHERE itinerario.cod-itiner = cotacao-item.int-1  NO-ERROR.

        FIND LAST  ordens-embarque NO-LOCK 
             WHERE ordens-embarque.numero-ordem = tt-embarques-pre-sel.numero-ordem 
               AND ordens-embarque.parcela      = tt-embarques-pre-sel.parcela NO-ERROR.

        FIND FIRST historico-embarque NO-LOCK 
             WHERE historico-embarque.cod-estabel   = tt-embarques-pre-sel.cod-estabel
               AND historico-embarque.embarque      = ordens-embarque.embarque 
               AND historico-embarque.cod-itiner    = cotacao-item.int-1       
               AND historico-embarque.cod-pto-contr = itinerario.pto-despacho NO-ERROR.

        IF AVAIL historico-embarque THEN DO:

            if historico-embarque.dt-efetiva NE ? THEN NEXT.
            ELSE
                ASSIGN tt-embarques-pre-sel.data-entrega = historico-embarque.dt-ult-previsao.
        END.
    END.


END PROCEDURE.
/*
PROCEDURE pi-teste:

    RUN pi-define-data.

    def input  param jsonInput  as JsonObject no-undo.
    def output param jsonOutput as JsonObject no-undo.

    def var oResponse           as JsonAPIResponse      no-undo.
    def var oRequestParser      as JsonAPIRequestParser no-undo.
    def var oJsonObject         as JsonObject           no-undo.
    def var jArrayPrincipal     as JsonArray            no-undo.

    DEF VAR inputA              AS CHAR NO-UNDO.



    assign oRequestParser = new JsonAPIRequestParser(jsonInput) no-error.

    assign jArrayPrincipal = new JsonArray().
    jArrayPrincipal = oRequestParser:getPathParams() no-error.

    //assign i-num-param = jArrayPrincipal:length no-error.


    ASSIGN inputA = STRING(JsonAPIUtils:getPropertyJsonArray(jArrayPrincipal, 2)).

    jsonOutput = NEW JSONObject().
    jsonOutput:ADD("inputA" , inputA).

END PROCEDURE.
*/


/*-------------------------------------------------------------------------------------------*/

PROCEDURE pi-atualiza-datas-fornecedores-nacionais:
    DEF INPUT PARAM inputOrder     LIKE prazo-compra.numero-ordem NO-UNDO.
    DEF INPUT PARAM inputParcela   LIKE prazo-compra.parcela      NO-UNDO.
    DEF INPUT PARAM inputDate      AS DATE                        NO-UNDO.
    DEF OUTPUT PARAM l-erro   AS LOG                              NO-UNDO.
    DEF OUTPUT PARAM c-status AS CHAR FORMAT "x(256)"             NO-UNDO. 

    FIND FIRST prazo-compra EXCLUSIVE-LOCK WHERE prazo-compra.numero-ordem = inputOrder AND prazo-compra.parcela      = inputParcela NO-ERROR .
    IF NOT AVAIL prazo-compra THEN DO:
        ASSIGN l-erro   = YES.
        ASSIGN c-status = "Find ordem-compra falhou".
        RETURN.
    END.

    ASSIGN prazo-compra.data-entrega = inputDate .

    RELEASE prazo-compra.

END.

PROCEDURE pi-atualiza-datas-fornecedores-internacionais:

    DEF INPUT PARAM inputOrder     LIKE prazo-compra.numero-ordem NO-UNDO.
    DEF INPUT PARAM inputParcela   LIKE prazo-compra.parcela      NO-UNDO.
    DEF INPUT PARAM inputDate      AS DATE                        NO-UNDO.

    DEF OUTPUT PARAM l-erro   AS LOG                              NO-UNDO.
    DEF OUTPUT PARAM c-status AS CHAR FORMAT "x(256)"             NO-UNDO. 

    

    FIND FIRST ordem-compra WHERE prazo-compra.numero-ordem = inputOrder NO-LOCK NO-ERROR.
    IF NOT AVAIL prazo-compra THEN DO:
        ASSIGN l-erro   = YES.
        ASSIGN c-status = "Find ordem-compra falhou".
        RETURN.
    END.
    /*----*/
    FIND FIRST prazo-compra WHERE prazo-compra.numero-ordem = inputOrder AND prazo-compra.parcela      = inputParcela NO-LOCK NO-ERROR.
    IF NOT AVAIL prazo-compra THEN DO:
        ASSIGN l-erro   = YES.
        ASSIGN c-status = "Find prazo-compra falhou".
        RETURN.
    END.
    /*----*/
    FIND FIRST cotacao-item NO-LOCK 
         WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem 
           AND cotacao-item.cod-emitente = ordem-compra.cod-emitente NO-ERROR.
    IF NOT AVAIL cotacao-item THEN DO:
        ASSIGN l-erro   = YES.
        ASSIGN c-status = "Find cotacao-item falhou".
        RETURN.
    END.


    FIND FIRST itinerario NO-LOCK WHERE itinerario.cod-itiner = cotacao-item.int-1 NO-ERROR.

    FIND LAST ordens-embarque NO-LOCK 
    WHERE ordens-embarque.numero-ordem = ordem-compra.numero-ordem 
      AND ordens-embarque.parcela      = inputParcela  NO-ERROR.

    FIND FIRST historico-embarque EXCLUSIVE-LOCK  
         WHERE historico-embarque.cod-estabel   = ordem-compra.cod-estabel
           AND historico-embarque.embarque      = ordens-embarque.embarque 
           AND historico-embarque.cod-itiner    = cotacao-item.int-1       
           AND historico-embarque.cod-pto-contr = itinerario.pto-despacho NO-ERROR.

    IF AVAIL historico-embarque THEN DO:

        ASSIGN historico-embarque.dt-ult-previsao = inputDate.

        ASSIGN l-erro   = NO
               c-status = "Data Atualizada".
    END.

    RELEASE historico-embarque . 
END.
