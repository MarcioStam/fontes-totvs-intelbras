{esp/esapi505.i}         

DEF INPUT  PARAM p-item    AS CHARACTER NO-UNDO.
DEF OUTPUT PARAM p-result  AS CHARACTER NO-UNDO.


DEF BUFFER bf-las-api-log FOR es-api-log.
DEF BUFFER bf-new-api-log FOR es-api-log.

DEFINE VARIABLE objItem                 AS JsonObject   NO-UNDO.
DEFINE VARIABLE arrayItem               AS jsonArray    NO-UNDO.

DEFINE VARIABLE c-JASON         AS CHARACTER  NO-UNDO.

DEFINE VARIABLE c-item      AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-familia   AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-nome-fam  AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-un        AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-descricao AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-narrativa AS CHARACTER NO-UNDO.

DEFINE VARIABLE de-fator-conver LIKE ITEM.fator-conver NO-UNDO.

DEFINE VARIABLE c-data-implanta AS CHARACTER   NO-UNDO. 

/* Inicio */                                            

ASSIGN arrayItem = NEW JsonArray().

ASSIGN c-data-implanta = STRING(YEAR(TODAY),'9999') + '-' + STRING(MONTH(TODAY),'99') + '-' + STRING(DAY(TODAY),'99') + 'T' + 
                         STRING(TIME,'HH:MM:SS') + 'Z'. 


FIND FIRST ITEM 
     WHERE ITEM.it-codigo = p-item //Item Integracao
NO-LOCK NO-ERROR.

FIND FIRST familia WHERE familia.fm-codigo = ITEM.fm-codigo NO-LOCK NO-ERROR.

ASSIGN c-item          = ITEM.it-codigo
       c-familia       = ITEM.fm-codigo
       c-un            = ITEM.un
       c-descricao     = ITEM.desc-item
       c-narrativa     = ITEM.narrativa
       de-fator-conver = ITEM.fator-conver.

ASSIGN c-nome-fam = familia.descricao.


ASSIGN objItem = NEW JsonObject().
    
objItem:ADD("@odata.etag"         , STRING('4464008f-7650-3d10-9807-7499bc8ba23e')).     
objItem:ADD("QtyQC"               , 0). 
objItem:ADD("FlgPrintP02"         , 0).    
objItem:ADD("FlgPrintP03"         , 0).    
objItem:ADD("FlgPrintP00"         , 0).    
objItem:ADD("FlgPrintP01"         , 0). 
objItem:ADD("FlgPrintP06"         , 0). 
objItem:ADD("ValiditPeriod"       , 0).
objItem:ADD("BackFlushTypeOrigin" , 0).
objItem:ADD("FlgPrintP07"         , 0).
objItem:ADD("FlgPrintP04"         , 0).
objItem:ADD("PalletWidth"         , 0).
objItem:ADD("FlgPrintP05"         , 0).
objItem:ADD("QtyCEP"              , 0).
objItem:ADD("FamilyProductCode"   , c-familia).
objItem:ADD("PlantCode"           , "-10").
objItem:ADD("FlgPrintP08"         , 0).
objItem:ADD("AddressBackFlushType", 0).
objItem:ADD("Name"                , c-descricao).
objItem:ADD("FlgPrintP09"         , 0).
objItem:ADD("WOCriteria"          , 0).
objItem:ADD("QueueLeadTime"       , 0).
objItem:ADD("FlgTooling"          , 0).
objItem:ADD("PalletDefaultQty"    , 0).
objItem:ADD("QtyPackage"          , 0).
objItem:ADD("QtyProdReport"       , 0).
objItem:ADD("Integrated"          , 2).
objItem:ADD("Unit2Code"           , "").
objItem:ADD("FamilyProductName"   , c-nome-fam).
objItem:ADD("FlgBackFlush"        , 0).
objItem:ADD("HeightPriority"      , 0).
objItem:ADD("MaterialRestTime"    , 0).
objItem:ADD("ReportByLot"         , 0).
objItem:ADD("DtIntegration"       , c-data-implanta).
objItem:ADD("PickingAddressCode"  , "").
objItem:ADD("ErrDescription"      , "").
objItem:ADD("Code"                , c-item).
objItem:ADD("SecondName"          , "").
objItem:ADD("LogLeadTime"         , 0).
objItem:ADD("Unit1Code"           , c-un).
objItem:ADD("ReferenceCode"       , "").
objItem:ADD("PalletDepth"         , 0).
objItem:ADD("EconomicLot"         , 0).
objItem:ADD("LotBackFlushType"    , 0).
objItem:ADD("LowerLevel"          , 0).
objItem:ADD("Description"         , c-narrativa).
objItem:ADD("QtdBillMatCons"      , 0).
objItem:ADD("ProductImage"        , "").
objItem:ADD("QualityLabelCode"    , "").
objItem:ADD("PalletHeight"        , 0).
objItem:ADD("ValPeriodUnit"       , 0).
objItem:ADD("ProductTypeCode"     , "-10").
objItem:ADD("ProductLabelCode"    , "").
objItem:ADD("DtCreation"          , c-data-implanta).
objItem:ADD("Unit3Factor"         , 0).
objItem:ADD("BackFlushType"       , 0).
objItem:ADD("DefaultAddressCode"  , "").
objItem:ADD("Unit3Code"           , '').
objItem:ADD("Label_ItemCode"      , "-10").
objItem:ADD("ExtCode"             , "").
objItem:ADD("Selected"            , 0).
objItem:ADD("Excluded"            , 0).
objItem:ADD("MinLot"              , 0).
objItem:ADD("FlgPrintP10"         , 0).
objItem:ADD("HigherLevel"         , 0).
objItem:ADD("FlgPrintP11"         , 0).
objItem:ADD("ValueScrap"          , 0).
objItem:ADD("DataOrigin"          , "").
objItem:ADD("ScrapBFlush"         , 0).
objItem:ADD("FlgprintP12"         , 0).
objItem:ADD("ColumnLimit"         , 0).
objItem:ADD("Unit2Factor"         , de-fator-conver). //
objItem:ADD("FlgEnable"           , 1). //
objItem:ADD("DtTimeStampImp"      , c-data-implanta). //
objItem:ADD("BUnitCode"           , "").
objItem:ADD("CostCenterCode"      , "").
objItem:ADD("Yield"               , 0).
objItem:ADD("StorageAddressCode"  , "").

arrayItem:ADD(objItem).

c-JASON = JsonAPIUtils:getJsonArrayChar(arrayItem).

FIND LAST bf-las-api-log NO-LOCK WHERE bf-las-api-log.id-api-log > 0 NO-ERROR.

FIND FIRST es-api-URI WHERE es-api-URI.id-URI = 'integraItemMES' NO-LOCK NO-ERROR.

CREATE es-api-log.
ASSIGN es-api-log.seqexec        = bf-las-api-log.seqexec + 10   
       es-api-log.id-aplicacao   = 'MES'
       es-api-log.id-codigo      = c-item
       es-api-log.id-URI         = es-api-URI.id-URI
       es-api-log.dh-request     = NOW
       //es-api-log.end-envio      = es-api-log.end-envio
       es-api-log.flg-processado = NO
       es-api-log.Origem         = es-api-URI.id-URI
       es-api-log.aux            = c-item
       es-api-log.cJson          = c-JASON
       es-api-log.id-api-log     = NEXT-VALUE(seq_api_log).


ASSIGN lcEnvio = es-api-log.cjson
       lcEnvio = CODEPAGE-CONVERT(lcEnvio, "UTF-8":U).


ASSIGN c-endereco = es-api-URI.ent-PRD.      


COPY-LOB lcEnvio TO es-api-log.cl-envio.

IF STRING(lcEnvio) > "" THEN 
   fc-chamada-2().

ASSIGN p-result = es-api-log.cod-retorno.


//client:STATUS == OK
/*MESSAGE 'Integra Item' SKIP es-api-log.cod-retorno 
    VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.*/





