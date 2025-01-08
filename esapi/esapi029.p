{esp/esapi505.i}         

DEF INPUT  PARAM p-item    AS CHARACTER NO-UNDO.
DEF OUTPUT PARAM p-result  AS CHARACTER NO-UNDO.


DEF BUFFER bf-las-api-log FOR es-api-log.
DEF BUFFER bf-new-api-log FOR es-api-log.

DEFINE VARIABLE objItem                 AS JsonObject   NO-UNDO.
DEFINE VARIABLE arrayItem               AS jsonArray    NO-UNDO.

DEFINE VARIABLE c-JASON         AS CHARACTER  NO-UNDO.

DEFINE VARIABLE c-item      AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-fabricado AS INT NO-UNDO.
DEFINE VARIABLE c-un        AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-descricao AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-narrativa AS CHARACTER NO-UNDO.

DEFINE VARIABLE c-data-implanta AS CHARACTER   NO-UNDO. 

/* Inicio */                                            

ASSIGN arrayItem = NEW JsonArray().

ASSIGN c-data-implanta = STRING(YEAR(TODAY),'9999') + '-' + STRING(MONTH(TODAY),'99') + '-' + STRING(DAY(TODAY),'99') + 'T' + 
                         STRING(TIME,'HH:MM:SS') + 'Z'. 


FIND FIRST ITEM 
     WHERE ITEM.it-codigo = p-item
     AND ITEM.compr-fabr = 2  //Item Integracao
NO-LOCK NO-ERROR.


ASSIGN c-item          = ITEM.it-codigo
       c-un            = ITEM.un
       c-descricao     = ITEM.desc-item
       c-fabricado     = ITEM.compr-fabr.




ASSIGN objItem = NEW JsonObject().
    
objItem:ADD("@odata.etag"         , STRING('4464008f-7650-3d10-9807-7499bc8ba23e')).     
objItem:ADD("it_codigo"           , c-item).
objItem:ADD("descricao"           , c-descricao).
objItem:ADD("un"           , c-un).
arrayItem:ADD(objItem).

c-JASON = JsonAPIUtils:getJsonArrayChar(arrayItem).

FIND LAST bf-las-api-log NO-LOCK WHERE bf-las-api-log.id-api-log > 0 NO-ERROR.

FIND FIRST es-api-URI WHERE es-api-URI.id-URI = 'ItemINTELMES' NO-LOCK NO-ERROR.

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





