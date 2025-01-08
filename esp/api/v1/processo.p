{utp/ut-api.i}

{utp/ut-api-action.i pi-put PUT    /~* }
{utp/ut-api-notfound.i}
{utp/ut-api-utils.i}

{esp/esapi505a.i}

PROCEDURE pi-put:
   DEF INPUT  PARAM jsonInput  AS JsonObject NO-UNDO. 
   DEF OUTPUT PARAM jsonOutput AS JsonObject NO-UNDO. 

   RUN pi-input-api-request  ("CEX",
                              "1",
                              "ProcessoEX-ALT",
                              "API DATI",
                              lcInput
                             ).
   
   RUN pi-input-json-retorno (OUTPUT jsonOutput).
END.

