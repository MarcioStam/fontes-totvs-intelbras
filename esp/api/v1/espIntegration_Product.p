/****************************************************************************************************
** Intelbras
**
** API Rest Retorno JSON tt-item
**
** 21/07/2021 - VERSAO INICIAL   // http://10.1.1.71:32080/esp/api/v1/espIntegration_Product/piProduct
**
****************************************************************************************************/
{utp/ut-api.i}
{utp/ut-api-utils.i}        /*
{fwk/utils/fndApiServices.i}  */
{utp/ut-api-action.i piProduct POST /~*}
{utp/ut-api-notfound.i} 

{esp/wso/eswso0007.i} 


    DEF VAR c-arquivo-log1              AS CHAR NO-UNDO.

    // VERIFICA BASE LOGADA 
    def var l-producao   AS LOG NO-UNDO.
    DEF TEMP-TABLE tt-prog-ponto NO-UNDO
        FIELD nome-programa    LIKE ponto-programa.nome-programa
        FIELD ponto            LIKE ponto-programa.ponto
        FIELD sequencia        LIKE conteudo-programa.sequencia 
        FIELD conteudo         LIKE conteudo-programa.conteudo
        INDEX seq-campo nome-programa ponto sequencia.




/****************************************************************************************************/
/****************************************************************************************************/
/****************************************************************************************************/
PROCEDURE piProduct:

    DEFINE INPUT  PARAMETER jsonInput   AS JsonObject NO-UNDO.
    DEFINE OUTPUT PARAMETER jsonOutput  AS JsonObject NO-UNDO.    
    DEFINE VARIABLE c-json          AS LONGCHAR    NO-UNDO.
    DEFINE VARIABLE logItemCriado   AS LOGICAL     NO-UNDO.
    DEF VAR i AS INT.

    EMPTY TEMP-TABLE tt-prog-ponto.

    RUN esp/es0018p.p (INPUT "ambiente":U,
                       INPUT 1,
                       INPUT 0,
                       INPUT "":U,
                       OUTPUT TABLE tt-prog-ponto).

    FIND FIRST tt-prog-ponto NO-ERROR.

    IF AVAILABLE tt-prog-ponto               AND
       tt-prog-ponto.conteudo = "PRODUCAO":U THEN
       ASSIGN l-producao = YES.
    ELSE
       ASSIGN l-producao = NO.



    IF OPSYS = 'UNIX' THEN
       ASSIGN c-arquivo-log1 = '/mnt/spool/totvs/UNIX_Product_'.
    ELSE
       ASSIGN c-arquivo-log1 = '\\erpapp\spool\totvs\WIN_Product_'.

    IF l-producao THEN
       ASSIGN c-arquivo-log1 = c-arquivo-log1 + 'PROD.txt'.
    ELSE 
       ASSIGN c-arquivo-log1 = c-arquivo-log1 + 'HOMOL.txt'.




    IF jsonInput:has("payload")
    THEN DO:
        ASSIGN jsonObjectPayload    = jsonInput:GetJsonObject("payload").
    END.

    IF SEARCH("esp/wso/out/wso0007.r") <> ?
    OR SEARCH("esp/wso/out/wso0007.p") <> ? THEN DO:
        run esp/wso/out/wso0007.p  (input-output table tt-item,
                                    input-output table tt-prod-composto).
    END.

    arrayItem  = NEW JsonArray().
    

    FOR EACH tt-item:

        c-json = ''.
        run pi-json.
           
    END.

    jsonObjectOutput = NEW jsonObject().
    jsonObjectOutput:ADD("product", arrayItem).

    RUN createJsonResponse(INPUT jsonObjectOutput, INPUT TABLE rowErrors, INPUT false, OUTPUT jsonOutput).

END PROCEDURE.


PROCEDURE pi-gerar-dados-extrato:
    def input param p-string as char no-undo.
            
    if  c-arquivo-log1 <> "" and c-arquivo-log1 <> ? then do:
    
        output to value(c-arquivo-log1) append.
             /* Inicio -- Projeto Internacional */
             DEFINE VARIABLE c-lbl-liter-ponto-executado AS CHARACTER FORMAT "X(24)" NO-UNDO.
             {utp/ut-liter.i "Ponto_Executado" *}
             ASSIGN c-lbl-liter-ponto-executado = TRIM(RETURN-VALUE).
             put UNFORMATTED "     " + c-lbl-liter-ponto-executado + ": " p-string " - " + STRING(DATETIME(TODAY, MTIME)) skip.
        output close. 
    
    end.
END.


PROCEDURE pi-json.

    objItem = NEW JsonObject().
   objItem:ADD("product",                      STRING(tt-item.it-codigo)). 
   objItem:ADD("productName",                  STRING(tt-item.descricao-1)). 
   objItem:ADD("description",                  STRING(tt-item.desc-item)).   
   objItem:ADD("internationalDescription",     STRING(tt-item.desc-inter)).    
   objItem:ADD("businessUnitCode",             STRING(tt-item.cod-unid-negoc)). //
   objItem:ADD("businessUnitDescription",      STRING(tt-item.des-unid-negoc)). //
   objItem:ADD("segmentCode",                  STRING(tt-item.segmento)).       //
   objItem:ADD("segmentDescription",           STRING(tt-item.des-segmento)).
   objItem:ADD("productFamilyCode",            STRING(tt-item.familia1)).
   objItem:ADD("productFamilyDescription",     STRING(tt-item.des-familia1)).
   objItem:ADD("subFamilyCode",                STRING(tt-item.familia2)).
   objItem:ADD("subFamilyDescription",         STRING(tt-item.des-familia2)).
   objItem:ADD("originCode",                   STRING(tt-item.origem)).
   objItem:ADD("originDescription",            STRING(tt-item.des-origem)).
   objItem:ADD("comercialFamilyCode",          STRING(tt-item.fm-cod-com)).
   objItem:ADD("comercialFamilyDescription",   STRING(tt-item.des-fam-comerc)).
   objItem:ADD("stockGroupCode",               STRING(tt-item.ge-codigo)).
   objItem:ADD("stockGroupDescription",        STRING(tt-item.ge-descricao)).
   objItem:ADD("percentIPI",                   TRIM(STRING(tt-item.aliquota-ipi * 10000,">>>>>>>>9,9999"))).
   objItem:ADD("productType",                  IF tt-item.compr-fabric = 1 then 'Comprado' else 'Fabricado').
   objItem:ADD("EANcode",                      STRING(tt-item.cod-dun)).
   objItem:ADD("isActive",                     IF tt-item.ind-item-fat THEN TRUE ELSE FALSE).
   objItem:ADD("isService",                    IF tt-item.log-servico = YES THEN TRUE ELSE FALSE).
   objItem:ADD("multipleQuantity",             STRING(tt-item.qtd-multipla)).
   objItem:ADD("NCM",                          STRING(tt-item.ncm)).
   objItem:ADD("nature",                       IF tt-item.compr-fabric = 1 then 'Comprado' else 'Fabricado').
   objItem:ADD("type",                         tt-item.tipo).


   for EACH tt-prod-composto 
      where tt-prod-composto.it-codigo-pai = tt-item.it-codigo
       BREAK BY tt-prod-composto.it-codigo-pai :

      IF FIRST-OF(tt-prod-composto.it-codigo-pai) THEN DO:
          arrayKit   = NEW JsonArray(). 
      END.

      objKit = new JsonObject().

      objKit:ADD("product",                    STRING(tt-prod-composto.it-codigo-filho)).
      objKit:ADD("quantity",                   STRING(tt-prod-composto.quant-usada)).
      objKit:ADD("discount",                   STRING(tt-prod-composto.dec-1)).

      arrayKit:ADD(objKit).

      IF LAST-OF(tt-prod-composto.it-codigo-pai) THEN DO:
         //arrayItem:ADD(arrayKit).
         objItem:ADD("productKit", (arrayKit)).
      END.
   end.
   arrayItem:ADD(objItem).

END.
