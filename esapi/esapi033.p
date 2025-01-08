/****************************************************************************
** Programa : ESAPI033
** Descricao: Envia Faturamento Total para APS
**     Autor: Graziely Lima
**      Data: 03/02/2022
*****************************************************************************/
{esp/esapi506.i}         
DEF INPUT  PARAM p-qtd            AS DECIMAL           NO-UNDO.
DEF INPUT  PARAM p-estab          AS INTEGER           NO-UNDO.
DEF INPUT  PARAM p-item           AS CHARACTER         NO-UNDO.
DEF OUTPUT PARAM p-result         AS CHARACTER         NO-UNDO.

DEFINE VARIABLE objFat            AS JsonObject        NO-UNDO.
DEFINE VARIABLE arrayFat          AS jsonArray         NO-UNDO.
DEFINE VARIABLE c-JSON            AS LONGCHAR          NO-UNDO.
DEFINE VARIABLE c-ret             AS CHARACTER         NO-UNDO.
DEFINE VARIABLE DtCreation        AS CHARACTER         NO-UNDO.
DEFINE VARIABLE c-JSON-atual      AS CHARACTER         NO-UNDO.
DEFINE VARIABLE cAux              AS CHARACTER         NO-UNDO.

DEF BUFFER bf-las-api-log         FOR es-api-log.      
DEF BUFFER bf-new-api-log         FOR es-api-log. 

/* Inicio */                
ASSIGN DtCreation  = STRING(YEAR(TODAY),'9999') + '-' + 
                     STRING(MONTH(TODAY),'99')  + '-' + 
                     STRING(DAY(TODAY),'99'). 

ASSIGN DtCreation = DtCreation + "T03:00:00-00:00".

ASSIGN objFat = NEW JsonObject().

objFat:ADD("qtde"            , p-qtd). 
objFat:ADD("data"            , DtCreation).
objFat:ADD("estabelecimento" , p-estab).
objFat:ADD("codigoitem"      , p-item ).
objFat:WRITE(c-JSON, TRUE).

ASSIGN cAux = (p-item + DtCreation).

FIND LAST bf-las-api-log NO-LOCK WHERE bf-las-api-log.id-api-log > 0 NO-ERROR.

FIND FIRST es-api-URI WHERE es-api-URI.id-URI = 'FatAPS' EXCLUSIVE-LOCK NO-ERROR.
IF NOT AVAIL es-api-URI THEN LEAVE.

FIND FIRST es-api-log
     WHERE es-api-log.id-aplicacao = 'APS'
       AND es-api-log.id-URI       = es-api-URI.id-URI 
       AND es-api-log.aux          = cAux EXCLUSIVE-LOCK NO-ERROR.
IF NOT AVAIL es-api-log THEN DO:
   CREATE es-api-log.
   ASSIGN es-api-log.seqexec        = bf-las-api-log.seqexec + 10   
          es-api-log.id-aplicacao   = 'APS'
          es-api-log.id-URI         = es-api-URI.id-URI
          es-api-log.Origem         = es-api-URI.id-URI
          es-api-log.cJson          = c-JSON
          es-api-log.aux            = cAux
          es-api-log.id-api-log     = NEXT-VALUE(seq_api_log).

   ASSIGN es-api-URI.metodo = 'POST'
          c-endereco = es-api-URI.ent-PRD. 

   RUN pi-atualiza.
   IF RETURN-VALUE = 'NOK' THEN
      RETURN 'NOK'. 

END.
ELSE DO:

    ASSIGN c-ret = es-api-log.cl-retorno
           es-api-URI.metodo = 'POST'
           c-endereco = es-api-URI.ent-PRD.
    
    ASSIGN c-JSON-atual     = es-api-log.cjson.
           es-api-log.cjson = c-JSON.

    RUN pi-atualiza.
    IF RETURN-VALUE = 'NOK' THEN DO:
       ASSIGN es-api-log.cjson = c-JSON-atual.
    END.
END.


/**Fim **/

/************************* Procedures *************************/
PROCEDURE pi-atualiza:

   ASSIGN lcEnvio = es-api-log.cjson
          lcEnvio = CODEPAGE-CONVERT(lcEnvio, "UTF-8":U).

   COPY-LOB lcEnvio TO es-api-log.cl-envio.
   IF STRING(lcEnvio) > "" THEN
       fc-integra-aps().
   
   ASSIGN p-result = es-api-log.cod-retorno + ' ' + string(es-api-log.cl-retorno).
   IF SUBSTRING(es-api-log.cod-retorno,1,2) = '20' THEN 
      ASSIGN es-api-log.dh-request     = NOW
             es-api-log.flg-processado = NO.
   ELSE 
      RETURN 'NOK'.
   
   RETURN 'OK'.

END PROCEDURE.





