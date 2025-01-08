{esp/esapi506.i}
   
FIND FIRST es-api-URI WHERE es-api-URI.id-URI = 'delOrdemSolar' EXCLUSIVE-LOCK NO-ERROR.
IF NOT AVAIL es-api-URI THEN LEAVE.

FIND FIRST es-api-log
     WHERE es-api-log.id-aplicacao = 'ROS'
       AND es-api-log.id-URI       = 'OrdemSolar' EXCLUSIVE-LOCK NO-ERROR.
IF AVAIL es-api-log THEN DO:
    RUN pi-metodo-del.
END.  

PROCEDURE pi-metodo-del:
    DEFINE VARIABLE myParserAux        AS ObjectModelParser   NO-UNDO.
    DEFINE VARIABLE JsonAux            AS JsonObject          NO-UNDO.
    DEFINE VARIABLE oJsonArray         AS jsonArray           NO-UNDO.
    DEFINE VARIABLE oJsonObj           AS jsonObject          NO-UNDO.
    DEFINE VARIABLE cItem              AS CHARACTER           NO-UNDO.
    DEFINE VARIABLE cId                AS CHARACTER           NO-UNDO.
    DEFINE VARIABLE lExiste            AS LOGICAL             NO-UNDO.
    DEFINE VARIABLE i                  AS INTEGER             NO-UNDO.

    ASSIGN es-api-URI.metodo = 'DELETE' 
           c-endereco = es-api-URI.ent-PRD.

    fc-chamada-3().

END PROCEDURE.
