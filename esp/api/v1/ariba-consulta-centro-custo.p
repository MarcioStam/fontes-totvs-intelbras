{utp/ut-api.i}

{utp/ut-api-action.i pi-get GET    /~* }
{utp/ut-api-notfound.i}
{utp/ut-api-utils.i}

{esp/esapi505a.i}

PROCEDURE pi-get:
  DEF INPUT  PARAM jsonInput  AS JsonObject NO-UNDO. 
  DEF OUTPUT PARAM jsonOutput AS JsonObject NO-UNDO. 
  DEF VAR longAux AS LONGCHAR NO-UNDO.
  DEFINE VARIABLE parser    AS ObjectModelParser NO-UNDO.
  
  RUN pi-input-api-request  ("ARI",
                             "1",
                             "AribaCentroCusto",
                             "API DATI",
                             lcInput
                            ).
  
  FIND es-api-log NO-LOCK WHERE ROWID(es-api-log) = rwRec NO-ERROR.
  
  IF AVAIL es-api-log THEN DO:

    COPY-LOB es-api-log.cl-retorno TO longAux.
    if longAux <> ? then do:
      parser = NEW ObjectModelParser().
      longAux = CODEPAGE-CONVERT(longAux, "UTF-8":U).
      jsonOutput = CAST(parser:Parse(longAux), JsonObject).
    END.
    else 
      RUN pi-input-json-retorno (OUTPUT jsonOutput).
  END.
END.

