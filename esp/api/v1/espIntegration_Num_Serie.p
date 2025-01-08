
/****************************************************************************************************
** SCOPEL TechSoluction
**
** API Rest Retorno JSON tt-item
**
** 02/02/2021 - VERSÃO INICIAL
**
**  
****************************************************************************************************/
{utp/ut-api.i}
{utp/ut-api-utils.i}        /*
{fwk/utils/fndApiServices.i}  */
{utp/ut-api-action.i piNumSerie POST /~*}
{utp/ut-api-notfound.i} 

DEFINE TEMP-TABLE ProdutoItem NO-UNDO XML-NODE-NAME 'ProdutoItem'
    FIELD CodigoProduto             AS CHAR 
    FIELD NomeProduto               AS CHARACTER.

DEFINE TEMP-TABLE NumeroSerieItem NO-UNDO XML-NODE-NAME 'NumeroSerieItem'
    FIELD CodigoProduto             AS CHAR
    FIELD NumeroSerieProduto        AS CHAR
    FIELD DataGerado                AS DATE.

/****************************************************************************************************/
/****************************************************************************************************/
/****************************************************************************************************/
PROCEDURE piNumSerie:

    DEFINE INPUT  PARAMETER jsonInput   AS JsonObject NO-UNDO.
    DEFINE OUTPUT PARAMETER jsonOutput  AS JsonObject NO-UNDO.    

    DEFINE VARIABLE jsonObjectOutput        AS JsonObject   NO-UNDO.
    DEFINE VARIABLE jsonObjectPayload       AS jsonObject   NO-UNDO.
    DEFINE VARIABLE objNumSerie             AS JsonObject   NO-UNDO.
    DEFINE VARIABLE arrayNumSerie           AS jsonArray    NO-UNDO.


    DEFINE VARIABLE objProduto             AS JsonObject   NO-UNDO.
    DEFINE VARIABLE arrayProduto           AS jsonArray    NO-UNDO.

    
    DEFINE VARIABLE DataInicio         AS DATE        NO-UNDO INIT TODAY. 
    DEFINE VARIABLE DataFinal          AS DATE        NO-UNDO INIT TODAY.
    DEFINE VARIABLE itemCode        AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE logItemCriado   AS LOGICAL     NO-UNDO.

    DEFINE VARIABLE c-data-fabric AS CHARACTER NO-UNDO FORMAT "x(15)"  INIT "".
    DEFINE VARIABLE c-data-emis   AS CHARACTER NO-UNDO FORMAT "x(15)"  INIT "".
    DEF VAR c-mes-fabric AS CHAR NO-UNDO FORMAT 99 INIT "".
    DEF VAR c-dia-fabric AS CHAR NO-UNDO FORMAT 99 INIT "".
    DEF VAR c-mes-emis   AS CHAR NO-UNDO FORMAT 99 INIT "".
    DEF VAR c-dia-emis   AS CHAR NO-UNDO FORMAT 99 INIT "".


    IF jsonInput:has("payload")
    THEN DO:
        ASSIGN jsonObjectPayload    = jsonInput:GetJsonObject("payload").

        ASSIGN  itemCode        =       JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "itemCode").
        ASSIGN  DataInicio      =       date(JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "DataInicio")).
        ASSIGN  DataFinal       =       date(JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "DataFinal")).
    END.

    IF SEARCH("esp/consulta_num_serie.r") <> ?
    OR SEARCH("esp/consulta_num_serie.p") <> ?
    THEN DO:
        run esp/consulta_num_serie.p  (input itemCode,
                                       INPUT DataInicio,
                                       INPUT DataFinal,
                                       INPUT-output table ProdutoItem,
                                       INPUT-output table NumeroSerieItem).
    END.

    ASSIGN arrayNumSerie  = NEW JsonArray()
           arrayProduto   = NEW JsonArray()
           logItemCriado = NO.

    FOR EACH ProdutoItem NO-LOCK /*,
        EACH NumeroSerieItem NO-LOCK WHERE NumeroSerieItem.CodigoProduto = ProdutoItem.CodigoProduto*/ :
        ASSIGN objProduto  = NEW JsonObject() 
               
               logItemCriado = YES
               c-data-fabric = ""
               c-data-emis   = ""
               c-mes-fabric  = ""
               c-mes-emis    = ""
               c-dia-fabric  = ""
               c-dia-emis    = "".                                                         

        objProduto:ADD("CodigoProduto",                   STRING(ProdutoItem.CodigoProduto)).
        objProduto:ADD("nome",                            STRING(ProdutoItem.NomeProduto)).

        FOR EACH NumeroSerieItem NO-LOCK WHERE NumeroSerieItem.CodigoProduto = ProdutoItem.CodigoProduto:

             objNumSerie = NEW JsonObject().

             /** Tratar a data de Fabricacao para retornar no formato yyyy-mm-dd  ***/
            IF  NumeroSerieItem.DataGerado <> ? THEN  DO:
                IF INT(MONTH(NumeroSerieItem.DataGerado)) < 10 THEN ASSIGN c-mes-fabric = "0" + STRING(INT(MONTH(NumeroSerieItem.DataGerado))). ELSE ASSIGN c-mes-fabric = STRING(INT(MONTH(NumeroSerieItem.DataGerado))).
                IF INT(DAY(NumeroSerieItem.DataGerado)) < 10 THEN ASSIGN c-dia-fabric = "0" + STRING(INT(DAY(NumeroSerieItem.DataGerado))). ELSE ASSIGN c-dia-fabric = STRING(INT(DAY(NumeroSerieItem.DataGerado))).
                ASSIGN c-data-fabric = STRING(YEAR(NumeroSerieItem.DataGerado)) + "-" + c-mes-fabric + "-" + c-dia-fabric.
            END.
            
            objNumSerie:ADD("numeroSerie",                     STRING(NumeroSerieItem.NumeroSerieProduto)).
            objNumSerie:ADD("dataFabricacao",                  c-data-fabric).

            arrayNumSerie:ADD(objNumSerie).
        END.

        arrayProduto:ADD(objProduto).
        arrayProduto:ADD(arrayNumSerie).
    END. 

    jsonObjectOutput = NEW jsonObject().
    IF NOT logItemCriado
    THEN DO:
      EMPTY TEMP-TABLE RowErrors.
      CREATE RowErrors.
      ASSIGN RowErrors.ErrorSequence    = 1
             RowErrors.ErrorNumber      = 17006
             RowErrors.ErrorDescription = "NÆo encontrado numero de serie para o item e per¡odo informado."
             RowErrors.ErrorParameters  = ""
             RowErrors.ErrorType        = ""
             RowErrors.ErrorHelp        = "Verificar se as informacoes estÆo corretas."
             RowErrors.ErrorSubType     = "".

      ASSIGN objNumSerie = NEW JsonObject().
             objNumSerie:ADD("CodigoProduto",           STRING(RowErrors.ErrorNumber)).
             objNumSerie:ADD("nome",                    STRING(RowErrors.ErrorDescription)).
             objNumSerie:ADD("numeroSerie",             STRING(RowErrors.ErrorNumber)).
             objNumSerie:ADD("dataFabricacao",          STRING(RowErrors.ErrorDescription)).
             arrayNumSerie:ADD(objNumSerie).
             jsonObjectOutput:ADD("returnItens", arrayProduto /*arrayNumSerie */ ).
    END.
    ELSE DO:
        jsonObjectOutput:ADD("returnItens", arrayProduto /*arrayNumSerie */ ).
    END.
    
    RUN createJsonResponse(INPUT jsonObjectOutput, INPUT TABLE rowErrors, INPUT false, OUTPUT jsonOutput).

END PROCEDURE.


