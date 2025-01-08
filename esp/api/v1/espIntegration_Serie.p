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
{utp/ut-api-action.i piSerie POST /~*}
{utp/ut-api-notfound.i} 

def temp-table tt-item NO-UNDO XML-NODE-NAME 'ProdutoSerie'
    FIELD CodigoProduto            LIKE ITEM.it-codigo
    FIELD Nome                     LIKE item.desc-item
    FIELD DataFabricacao           LIKE num-serie.data
    FIELD NumeroNotaFiscal         LIKE nota-fiscal.nr-nota-fis   
    FIELD CodigoCliente            LIKE nota-fiscal.cod-emitente        
    FIELD NomeRazaoSocial          LIKE emitente.nome-emit        
    FIELD DataEmissao              LIKE nota-fiscal.dt-emis-nota  
    FIELD NumeroPedido             LIKE nota-fiscal.nr-pedcli     
    FIELD NumeroSerie              LIKE nota-fiscal.serie        
    FIELD CpfCnpjCodEstrangeiro    LIKE nota-fiscal.cgc          
    FIELD PrecoUnitario            LIKE it-nota-fisc.vl-preuni
    FIELD AliquotaIPI              LIKE it-nota-fisc.aliquota-ipi 
    FIELD ValorIPI                 LIKE it-nota-fisc.vl-ipi-it    
    FIELD AliquotaICMS             LIKE it-nota-fisc.aliquota-icm 
    FIELD ValorICMS                LIKE it-nota-fisc.vl-icms-it
    FIELD ID                       AS CHAR
    FIELD Chave                    AS CHAR.
/****************************************************************************************************/
/****************************************************************************************************/
/****************************************************************************************************/
PROCEDURE piSerie:

    DEFINE INPUT  PARAMETER jsonInput   AS JsonObject NO-UNDO.
    DEFINE OUTPUT PARAMETER jsonOutput  AS JsonObject NO-UNDO.    

    DEFINE VARIABLE jsonObjectOutput        AS JsonObject   NO-UNDO.
    DEFINE VARIABLE jsonObjectPayload       AS jsonObject   NO-UNDO.
    DEFINE VARIABLE objSerie                AS JsonObject   NO-UNDO.
    DEFINE VARIABLE arraySerie              AS jsonArray    NO-UNDO.

    DEFINE VARIABLE serieCode        AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE logItemCriado   AS LOGICAL     NO-UNDO.

    DEF VAR c-data-fabric AS CHAR NO-UNDO FORMAT "x(15)"  INIT "".
    DEF VAR c-data-emis   AS CHAR NO-UNDO FORMAT "x(15)"  INIT "".
    DEF VAR c-mes-fabric  AS CHAR NO-UNDO FORMAT 99       INIT "".
    DEF VAR c-dia-fabric  AS CHAR NO-UNDO FORMAT 99       INIT "".
    DEF VAR c-mes-emis    AS CHAR NO-UNDO FORMAT 99       INIT "".
    DEF VAR c-dia-emis    AS CHAR NO-UNDO FORMAT 99       INIT "".


    IF jsonInput:has("payload")
    THEN DO:
        ASSIGN jsonObjectPayload = jsonInput:GetJsonObject("payload").
        ASSIGN  serieCode        = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "serieCode").
    END.

    IF SEARCH("esp/consulta_serie.r") <> ?
    OR SEARCH("esp/consulta_serie.p") <> ?
    THEN DO:
        run esp/consulta_serie.p  (input serieCode,
                                   input-output table tt-item).
    END.

    ASSIGN arraySerie    = NEW JsonArray()
           logItemCriado = NO.

    FOR EACH tt-item NO-LOCK:
        ASSIGN objSerie = NEW JsonObject()
               logItemCriado = YES
               c-data-fabric = ""
               c-data-emis   = ""
               c-mes-fabric  = ""
               c-mes-emis    = ""
               c-dia-fabric  = ""
               c-dia-emis    = "". 
        
        /** Tratar a data de Fabricacao para retornar no formato yyyy-mm-dd  ***/
        IF  tt-item.DataFabricacao <> ? THEN  DO:
            IF INT(MONTH(tt-item.DataFabricacao)) < 10 THEN ASSIGN c-mes-fabric = "0" + STRING(INT(MONTH(tt-item.DataFabricacao))). ELSE ASSIGN c-mes-fabric = STRING(INT(MONTH(tt-item.DataFabricacao))).
            IF INT(DAY(tt-item.DataFabricacao)) < 10 THEN ASSIGN c-dia-fabric = "0" + STRING(INT(DAY(tt-item.DataFabricacao))). ELSE ASSIGN c-dia-fabric = STRING(INT(DAY(tt-item.DataFabricacao))).
            ASSIGN c-data-fabric = STRING(YEAR(tt-item.DataFabricacao)) + "-" + c-mes-fabric + "-" + c-dia-fabric.
        END.

        /** Tratar a data de Emissao para retornar no formato yyyy-mm-dd  ***/
        IF  tt-item.DataEmissao <> ? THEN  DO:
            IF INT(MONTH(tt-item.DataEmissao)) < 10 THEN ASSIGN c-mes-emis = "0" + STRING(INT(MONTH(tt-item.DataEmissao))). ELSE ASSIGN c-mes-emis = STRING(INT(MONTH(tt-item.DataEmissao))).
            IF INT(DAY(tt-item.DataEmissao)) < 10 THEN ASSIGN c-dia-emis = "0" + STRING(INT(DAY(tt-item.DataEmissao))). ELSE ASSIGN c-dia-emis = STRING(INT(DAY(tt-item.DataEmissao))).
            ASSIGN c-data-emis = STRING(YEAR(tt-item.DataEmissao)) + "-" + c-mes-emis + "-" + c-dia-emis.
        END.

        objSerie:ADD("CodigoProduto",         STRING(tt-item.CodigoProduto)).
        objSerie:ADD("Nome",                  STRING(tt-item.Nome)).
        objSerie:ADD("DataFabricacao",        c-data-fabric).
        objSerie:ADD("NumeroNotaFiscal",      STRING(tt-item.NumeroNotaFiscal)).
        objSerie:ADD("CodigoCliente",         STRING(tt-item.CodigoCliente)).
        objSerie:ADD("NomeRazaoSocial",       STRING(tt-item.NomeRazaoSocial)).
        objSerie:ADD("DataEmissao",           c-data-emis).
        objSerie:ADD("NumeroPedido",          STRING(tt-item.NumeroPedido)).
        objSerie:ADD("NumeroSerie",           STRING(tt-item.NumeroSerie)).
        objSerie:ADD("CpfCnpjCodEstrangeiro", STRING(tt-item.CpfCnpjCodEstrangeiro)).          
        objSerie:ADD("PrecoUnitario",         STRING(tt-item.PrecoUnitario)).
        objSerie:ADD("AliquotaIPI",           STRING(tt-item.AliquotaIPI)). 
        objSerie:ADD("ValorIPI",              STRING(tt-item.ValorIPI)).    
        objSerie:ADD("AliquotaICMS",          STRING(tt-item.AliquotaICMS)). 
        objSerie:ADD("ValorICMS",             STRING(tt-item.ValorICMS)).
        objSerie:ADD("MiboID",                STRING(tt-item.ID)).
        objSerie:ADD("Chave",                 STRING(tt-item.Chave)).
        arraySerie:ADD(objSerie).
    END. 

    jsonObjectOutput = NEW jsonObject().
    IF NOT logItemCriado
    THEN DO:
      EMPTY TEMP-TABLE RowErrors.
      CREATE RowErrors.
      ASSIGN RowErrors.ErrorSequence    = 1
             RowErrors.ErrorNumber      = 17006
             RowErrors.ErrorDescription = "NÆo encontrado numero de serie informada."
             RowErrors.ErrorParameters  = ""
             RowErrors.ErrorType        = ""
             RowErrors.ErrorHelp        = "Verificar se o numero de serie informado esta correta."
             RowErrors.ErrorSubType     = "".

      ASSIGN objSerie = NEW JsonObject().
             objSerie:ADD("NumeroSerie",             STRING(RowErrors.ErrorNumber)).
             objSerie:ADD("Nome",                    STRING(RowErrors.ErrorDescription)).
             arraySerie:ADD(objSerie).
             jsonObjectOutput:ADD("returnItens", arraySerie).
    END.
    ELSE DO:
        jsonObjectOutput:ADD("returnItens", arraySerie).
    END.
    
    RUN createJsonResponse(INPUT jsonObjectOutput, INPUT TABLE rowErrors, INPUT false, OUTPUT jsonOutput).

END PROCEDURE.

