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
{utp/ut-api-action.i piItem POST /~*}
{utp/ut-api-notfound.i} 

def temp-table tt-item NO-UNDO XML-NODE-NAME 'ProdutoItem'
    field it-codigo            LIKE ITEM.it-codigo
    field descricao            LIKE item.desc-item.

/****************************************************************************************************/
/****************************************************************************************************/
/****************************************************************************************************/
PROCEDURE piItem:

    DEFINE INPUT  PARAMETER jsonInput   AS JsonObject NO-UNDO.
    DEFINE OUTPUT PARAMETER jsonOutput  AS JsonObject NO-UNDO.    

    DEFINE VARIABLE jsonObjectOutput        AS JsonObject   NO-UNDO.
    DEFINE VARIABLE jsonObjectPayload       AS jsonObject   NO-UNDO.
    DEFINE VARIABLE objItem                 AS JsonObject   NO-UNDO.
    DEFINE VARIABLE arrayItem               AS jsonArray    NO-UNDO.

    DEFINE VARIABLE unitCode        AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE logItemCriado   AS LOGICAL     NO-UNDO.

    IF jsonInput:has("payload")
    THEN DO:
        ASSIGN jsonObjectPayload    = jsonInput:GetJsonObject("payload").

        ASSIGN  unitCode        =       JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "unitCode").
    END.
    
    /*
    IF SEARCH("esp/consulta_item.r") <> ?
    OR SEARCH("esp/consulta_item.p") <> ?
    THEN DO:
        run esp/consulta_item.p  (INPUT unitCode,
                                  input-output table tt-item).
    END.*/

    RUN pi-consulta-item (INPUT unitCode,
                          input-output table tt-item).


    ASSIGN arrayItem  = NEW JsonArray()
           logItemCriado = NO.
    FOR EACH tt-item NO-LOCK:
        ASSIGN objItem = NEW JsonObject()
               logItemCriado = YES.

        objItem:ADD("codigo",     STRING(tt-item.it-codigo)).
        objItem:ADD("descricao",  STRING(tt-item.descricao)).
        arrayItem:ADD(objItem).
    END. 
    
    jsonObjectOutput = NEW jsonObject().
    IF NOT logItemCriado
    THEN DO:
      EMPTY TEMP-TABLE RowErrors.
      CREATE RowErrors.
      ASSIGN RowErrors.ErrorSequence    = 1
             RowErrors.ErrorNumber      = 17006
             RowErrors.ErrorDescription = "NÆo encontrado item para familia/unidade solicitada."
             RowErrors.ErrorParameters  = ""
             RowErrors.ErrorType        = ""
             RowErrors.ErrorHelp        = "Verificar se a familia/unidade informada esta correta."
             RowErrors.ErrorSubType     = "".

      ASSIGN objItem = NEW JsonObject().
             objItem:ADD("codigo",                   STRING(RowErrors.ErrorNumber)).
             objItem:ADD("descricao",                STRING(RowErrors.ErrorDescription)).
             arrayItem:ADD(objItem).
             jsonObjectOutput:ADD("returnItens", arrayItem).
    END.
    ELSE DO:
        jsonObjectOutput:ADD("returnItens", arrayItem).
    END.

    RUN createJsonResponse(INPUT jsonObjectOutput, INPUT TABLE rowErrors, INPUT false, OUTPUT jsonOutput).

END PROCEDURE.


PROCEDURE pi-consulta-item:

    DEF INPUT PARAM p_cod-unit  AS CHAR NO-UNDO.
    def input-output parameter table for tt-item.
    
    FOR EACH ITEM NO-LOCK WHERE ITEM.cod-unid-negoc = STRING(p_cod-unit)
                            AND ITEM.cod-obsoleto = 1
                            AND (ITEM.ge-codigo = 40
                             OR ITEM.ge-codigo = 42 
                             OR ITEM.GE-codigo = 45):
    
        IF ITEM.fm-cod-com = '' THEN NEXT.
    
        FIND item-mat OF ITEM NO-LOCK NO-ERROR. 
        IF ITEM.it-codigo BEGINS "9" AND ITEM.fm-codigo   <> "99400004"   THEN NEXT. /*
        IF ITEM.it-codigo BEGINS "583" AND ITEM.fm-codigo <> "58300000" THEN NEXT. 
        IF ITEM.it-codigo BEGINS "584" AND ITEM.fm-codigo = "199999999" THEN NEXT.  */
        IF AVAIL item-mat THEN DO:
              create tt-item.
              assign tt-item.it-codigo  = ITEM.it-codigo
                     tt-item.descricao = ITEM.desc-item.
        END.
    END.

END PROCEDURE.

