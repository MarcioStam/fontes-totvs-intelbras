{esp/esapi505.i}    

DEF INPUT  PARAM  p-ordem    AS CHARACTER NO-UNDO.
DEF OUTPUT PARAM  p-operacao AS CHARACTER NO-UNDO.
DEF OUTPUT PARAM  p-result   AS CHARACTER NO-UNDO.

DEF BUFFER bf-las-api-log FOR es-api-log.
DEF BUFFER bf-new-api-log FOR es-api-log.

DEFINE VARIABLE objOperProd   AS JsonObject NO-UNDO.
DEFINE VARIABLE arrayOperProd AS jsonArray  NO-UNDO.

DEFINE VARIABLE c-JASON         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-num-op        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-operacoes     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-data-implanta AS CHARACTER  NO-UNDO.
DEFINE VARIABLE de-StdSpeed     AS DECIMAL    NO-UNDO.
DEFINE VARIABLE i-tempo-prepar  AS INTEGER    NO-UNDO.

/* Inicio */ 

ASSIGN c-data-implanta = STRING(YEAR(TODAY),'9999') + '-' + STRING(MONTH(TODAY),'99') + '-' + STRING(DAY(TODAY),'99') + 'T' + 
                         STRING(TIME,'HH:MM:SS') + 'Z'.

IF NOT CAN-FIND(FIRST oper-ord 
    WHERE oper-ord.nr-ord-prod = INT(p-ordem)
      AND oper-ord.revisao = 'MES') THEN DO:

    ASSIGN p-operacao = ''
           p-result   = 'Nao encontrada Operacao com MES'.
    RETURN 'ok'.
END.            


FOR EACH oper-ord NO-LOCK 
    WHERE oper-ord.nr-ord-prod = INT(p-ordem)
      AND oper-ord.revisao = 'MES',
    FIRST ITEM WHERE ITEM.it-codigo = oper-ord.it-codigo NO-LOCK,
    FIRST ord-prod WHERE ord-prod.nr-ord-prod = int(p-ordem) NO-LOCK:

    ASSIGN i-tempo-prepar = 0.
    
    ASSIGN arrayOperProd = NEW JsonArray(). 
    ASSIGN objOperProd   = NEW JsonObject().

    ASSIGN de-StdSpeed = ord-prod.qt-ordem / (oper-ord.tempo-homem * 60).

    FIND FIRST operacao WHERE operacao.op-codigo = oper-ord.op-codigo 
                          AND operacao.it-codigo = oper-ord.it-codigo
    NO-LOCK NO-ERROR.

    IF AVAIL operacao THEN
       ASSIGN i-tempo-prepar = INT(operacao.tempo-prepar * 60).
    
    IF de-StdSpeed <= 0 THEN 
       ASSIGN de-StdSpeed = 0.1.

    ASSIGN c-operacoes = c-operacoes + oper-ord.descricao + ';'.

    objOperProd:ADD("@odata.etag"              , "4e11c8f9-3ed9-3549-815b-e859c1b0d496").     
    objOperProd:ADD("CommittedStdSpeed"        , 0).                                  
    objOperProd:ADD("Name"                     , oper-ord.descricao).                    
    objOperProd:ADD("DefaultOrigin"            , 2).                                     
    objOperProd:ADD("Qty"                      , ord-prod.qt-ordem).                                  
    objOperProd:ADD("PlanType"                 , 3).                                     
    objOperProd:ADD("DefaultFactorOrigin"      , 1).                                     
    objOperProd:ADD("Integrated"               , 0).                                     
    objOperProd:ADD("Unit1Factor"              , 1).                                     
    objOperProd:ADD("Status"                   , 20).                                    
    objOperProd:ADD("DefaultType"              , 2).                                     
    objOperProd:ADD("DtIntegration"            , c-data-implanta).                                  
    objOperProd:ADD("Code"                     , TRIM(STRING(oper-ord.num-id-operacao,'>>,>>>,>>9')) ).                           
    objOperProd:ADD("AuxCode2"                 , oper-ord.it-codigo).                             
    objOperProd:ADD("SetUpTimeFormat"          , 2).                                     
    objOperProd:ADD("WoCode"                   , p-ordem).                             
    objOperProd:ADD("Unit1Code"                , ITEM.un).                                  
    objOperProd:ADD("StdSpeed"                 , de-StdSpeed ).                     
    objOperProd:ADD("StdCrew"                  , oper-ord.numero-homem).                                     
    objOperProd:ADD("ReportTrigger"            , 1).                                     
    objOperProd:ADD("DtPlanStart"              , c-data-implanta).                                  
    objOperProd:ADD("FlgEng"                   , 0).                                  
    objOperProd:ADD("DtCreation"               , c-data-implanta).       
    objOperProd:ADD("Unit3Factor"              , 0).                                  
    objOperProd:ADD("BackFlushType"            , 0).                                  
    
    objOperProd:ADD("Unit1FactorReWork"        , 1).                                     
    objOperProd:ADD("Selected"                 , 0).                                     
                                 
    objOperProd:ADD("SetUpTime"                , i-tempo-prepar).                                     

    objOperProd:ADD("DtPlanEnd"                , c-data-implanta).                                  
    objOperProd:ADD("Excluded"                 , 0).                                     
    objOperProd:ADD("BaseQty"                  , 1).                                     
    objOperProd:ADD("StdSpeedFormat"           , 2).                                     
    objOperProd:ADD("DefaultFactorScrapOrigin" , 1).                                     
    objOperProd:ADD("DataOrigin"               , c-data-implanta).                                  
    objOperProd:ADD("DefaultCycleTimeOrigin"   , 0).                                  
    objOperProd:ADD("ManagerGrpCode"           , oper-ord.gm-codigo).                               
    objOperProd:ADD("FlgQCInspection"          , 0).                                     
    objOperProd:ADD("Unit1FactorScrap"         , 1).                                     
    objOperProd:ADD("Unit2Factor"              , 0).                                  
    objOperProd:ADD("DtTimeStampImp"           , c-data-implanta).                                  
    objOperProd:ADD("DisablePrint"             , 0).                                     
    objOperProd:ADD("Yield"                    , 0).                                  
    objOperProd:ADD("DefaultFactorReWorkOrigin", 1). 
    objOperProd:ADD("AuxCode1"                 , oper-ord.ferramenta).

    objOperProd:AddNull("StdCycleTimeFormat").
    objOperProd:AddNull("StdCycleTime").     
    
    arrayOperProd:ADD(objOperProd).           

    ASSIGN c-JASON = JsonAPIUtils:getJsonArrayChar(arrayOperProd).
    ASSIGN c-operacoes = p-ordem + ';' + c-operacoes.

    arrayOperProd = ?.
    
    FIND LAST bf-las-api-log WHERE bf-las-api-log.id-api-log > 0 NO-LOCK NO-ERROR.
    
    FIND FIRST es-api-URI WHERE es-api-URI.id-URI = 'integraOperMES' NO-LOCK.
    
    CREATE es-api-log.
    ASSIGN es-api-log.seqexec        = bf-las-api-log.seqexec  +  10   
           es-api-log.id-aplicacao   = 'MES'
           es-api-log.id-codigo      = c-operacoes
           es-api-log.id-URI         = es-api-URI.id-URI
           es-api-log.dh-request     = NOW
           //es-api-log.end-envio      = bf-las-api-log.end-envio
           es-api-log.flg-processado = NO
           es-api-log.Origem         = es-api-URI.id-URI
           es-api-log.aux            = c-operacoes
           es-api-log.cJson          = c-JASON
           es-api-log.id-api-log     = NEXT-VALUE(seq_api_log).
    
    ASSIGN lcEnvio = es-api-log.cjson
           lcEnvio = CODEPAGE-CONVERT(lcEnvio, "UTF-8":U).
    
    ASSIGN c-endereco = es-api-URI.ent-PRD.
    
    COPY-LOB lcEnvio TO es-api-log.cl-envio.
    
    IF STRING(lcEnvio) > "" THEN 
       fc-chamada-2().
    
    ASSIGN p-operacao  = c-operacoes
           p-result    = es-api-log.cod-retorno.
    
    /*
    MESSAGE 'Integra OPERACAO ' SKIP p-operacao SKIP es-api-log.cod-retorno 
        VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.*/

END.
     




