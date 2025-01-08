{esp/esapi505.i}         

DEF INPUT  PARAM p-ordem    AS INTEGER   NO-UNDO.
DEF INPUT  PARAM p-acao     AS CHARACTER NO-UNDO.

DEF OUTPUT PARAM p-operacao     AS CHARACTER NO-UNDO.
DEF OUTPUT PARAM p-result-ordem AS CHARACTER NO-UNDO.
DEF OUTPUT PARAM p-result-oper  AS CHARACTER NO-UNDO.

DEF BUFFER bf-las-api-log FOR es-api-log.
DEF BUFFER bf-new-api-log FOR es-api-log.

DEFINE VARIABLE objOP           AS JsonObject   NO-UNDO.
DEFINE VARIABLE arrayOP         AS jsonArray    NO-UNDO.
                               
DEFINE VARIABLE c-JASON         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-oper          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-result        AS CHARACTER  NO-UNDO.

DEFINE VARIABLE de-total-qty    AS DEC        NO-UNDO.
DEFINE VARIABLE i-situacao      AS INT        NO-UNDO.
DEFINE VARIABLE c-item          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-num-op        AS CHARACTER  NO-UNDO.

DEFINE VARIABLE c-data-implanta AS CHARACTER   NO-UNDO.       

/* Inicio */

ASSIGN arrayOP = NEW JsonArray().                             

ASSIGN c-data-implanta = STRING(YEAR(TODAY),'9999') + '-' + STRING(MONTH(TODAY),'99') + '-' + STRING(DAY(TODAY),'99') + 'T' + 
                         STRING(TIME,'HH:MM:SS') + 'Z'.

FIND FIRST ord-prod 
     WHERE ord-prod.nr-ord-prod = p-ordem //Informa OP 
NO-LOCK NO-ERROR.

IF AVAIL ord-prod THEN DO:
   IF ord-prod.nr-linha <> 4 AND ord-prod.nr-linha  <> 5 THEN
      RETURN 'NOK'.

   ASSIGN de-total-qty = ord-prod.qt-ordem
          i-situacao   = ord-prod.estado
          c-item       = ord-prod.it-codigo
          c-num-op     = string(ord-prod.nr-ord-prod).
END.

IF p-acao = 'delete' THEN DO:
   FIND FIRST int-ord-prod-mes 
        WHERE int-ord-prod-mes.nr-ord-prod = p-ordem //Informa OP 
   NO-LOCK NO-ERROR.
   
   IF AVAIL int-ord-prod-mes THEN
      ASSIGN de-total-qty = int-ord-prod-mes.qt-ordem
             i-situacao   = int-ord-prod-mes.estado
             c-item       = ''
             c-num-op     = string(int-ord-prod-mes.nr-ord-prod).
END.


ASSIGN objOP = NEW JsonObject().

objOP:ADD("@odata.etag"      ,   STRING('4464008f-7650-3d10-9807-7499bc8ba23e')).    
objOP:ADD("TotalQty"         ,   INT(de-total-qty)).
objOP:ADD("DtPlanStart"      ,   c-data-implanta).   
objOP:ADD("FlgPrinted"       ,   0).   
objOP:ADD("FlgEng"           ,   0).
objOP:ADD("FlgDefaultVersion",   0).
objOP:ADD("DtCreation"       ,   c-data-implanta).
objOP:ADD("DtDue"            ,   c-data-implanta).
objOP:ADD("WOSituationCode"  ,   string(i-situacao)). //7
objOP:ADD("Selected"         ,   0).
objOP:ADD("DtIssue"          ,   c-data-implanta).
objOP:ADD("Integrated"       ,   0).
objOP:ADD("DtPlanEnd"        ,   c-data-implanta).
objOP:ADD("Status"           ,   -10).
objOP:ADD("ProductCode"      ,   c-item).
objOP:ADD("DtIntegration"    ,   c-data-implanta).
objOP:ADD("WOTypeCode"       ,   "1").
objOP:ADD("DataOrigin"       ,   c-data-implanta).
objOP:ADD("Code"             ,   c-num-op).
objOP:ADD("DtTimeStampImp"   ,   c-data-implanta).

IF p-acao = 'add' OR p-acao = 'update' THEN DO:
   objOP:ADD("Excluded",0). 
   objOP:ADD("Comments","").     
END.
ELSE DO:
   objOP:ADD("Excluded",1). 
   objOP:ADD("Comments","To delete").     
END.
                   
arrayOP:ADD(objOP).

c-JASON = JsonAPIUtils:getJsonArrayChar(arrayOP).

FIND LAST bf-las-api-log WHERE bf-las-api-log.id-api-log > 0 NO-LOCK NO-ERROR.

FIND FIRST es-api-URI WHERE es-api-URI.id-URI = 'integraOrdemMES' NO-LOCK NO-ERROR.

CREATE es-api-log.
ASSIGN es-api-log.seqexec        = bf-las-api-log.seqexec  +  10   
       es-api-log.id-aplicacao   = 'MES'
       es-api-log.id-codigo      = c-num-op
       es-api-log.id-URI         = es-api-URI.id-URI
       es-api-log.dh-request     = NOW
       //es-api-log.end-envio      = bf-las-api-log.end-envio
       es-api-log.flg-processado = NO
       es-api-log.Origem         = es-api-URI.id-URI
       es-api-log.aux            = c-num-op
       es-api-log.cJson          = c-JASON
       es-api-log.id-api-log     = NEXT-VALUE(seq_api_log).


ASSIGN lcEnvio = es-api-log.cjson
       lcEnvio = CODEPAGE-CONVERT(lcEnvio, "UTF-8":U).

ASSIGN c-endereco = es-api-URI.ent-PRD.


COPY-LOB lcEnvio TO es-api-log.cl-envio.  

IF STRING(lcEnvio) > "" THEN 
   fc-chamada-2().

ASSIGN p-result-ordem = es-api-log.cod-retorno.

//client:STATUS == OK
IF es-api-log.cod-retorno = '201' THEN DO:
   IF p-acao <> 'delete' THEN DO:
      RUN esapi\esapi028.p (INPUT c-num-op,
                            OUTPUT c-oper,
                            OUTPUT c-result).
  
      FIND FIRST ord-prod WHERE ord-prod.nr-ord-prod = int(c-num-op) NO-LOCK NO-ERROR.
     
      IF AVAIL ord-prod THEN DO:
         FIND FIRST int-ord-prod-mes WHERE int-ord-prod-mes.nr-ord-prod  = ord-prod.nr-ord-prod EXCLUSIVE-LOCK NO-ERROR.
     
         IF NOT AVAIL int-ord-prod-mes THEN DO:
            CREATE int-ord-prod-mes.
            ASSIGN int-ord-prod-mes.nr-ord-prod  = ord-prod.nr-ord-prod.
         END.
                
         ASSIGN int-ord-prod-mes.qt-ordem = ord-prod.qt-ordem
                int-ord-prod-mes.estado   = ord-prod.estado.
     
         IF c-result = '201' THEN DO: //Sucesso na Integracao
            ASSIGN int-ord-prod-mes.oper-integrada = YES.
         END.
       
         ASSIGN int-ord-prod-mes.result-oper = c-result.
     
         ASSIGN p-operacao    = c-oper
                p-result-oper = c-result.
      END.
   END.
   ELSE DO:  
      FIND FIRST int-ord-prod-mes 
           WHERE int-ord-prod-mes.nr-ord-prod = p-ordem //Informa OP 
      EXCLUSIVE-LOCK NO-ERROR.

      IF AVAIL int-ord-prod-mes THEN DO:
         ASSIGN int-ord-prod-mes.oper-integrada = YES.

         ASSIGN int-ord-prod-mes.result-oper = 'OP deletada com Sucesso'.

         ASSIGN p-operacao    = '201' 
                p-result-oper =  int-ord-prod-mes.result-oper.
      END.
   END.                                                    
END.

/*
MESSAGE 'Integra OP' SKIP es-api-log.cod-retorno SKIP p-result-oper 
    VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.     */
