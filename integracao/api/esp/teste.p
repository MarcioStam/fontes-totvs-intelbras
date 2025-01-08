{utp/ut-api.i}
{utp/ut-api-action.i pi-get       GET /~* }
{utp/ut-api-action.i pi-send      GET /~*/SEND by=email,address=~* }
{utp/ut-api-action.i pi-post      POST /~* oi=1}
{utp/ut-api-action.i pi-put       PUT /~* }
{utp/ut-api-action.i pi-delete    DELETE /~* }
{utp/ut-api-notfound.i}

PROCEDURE pi-get:
    DEF  INPUT PARAM jsonInput       AS JsonObject           NO-UNDO.
    DEF OUTPUT PARAM jsonOutput      AS JsonObject           NO-UNDO.
    MESSAGE "*** pi-get" .
    jsonOutput = jsonInput.
END.

PROCEDURE pi-send:
    DEF  INPUT PARAM jsonInput       AS JsonObject           NO-UNDO.
    DEF OUTPUT PARAM jsonOutput      AS JsonObject           NO-UNDO.
    MESSAGE "*** pi-send" .
    jsonOutput = jsonInput.
END.

PROCEDURE pi-post:
    DEF  INPUT PARAM jsonInput       AS JsonObject           NO-UNDO.
    DEF OUTPUT PARAM jsonOutput      AS JsonObject           NO-UNDO.
    MESSAGE "*** pi-post" .
    jsonOutput = jsonInput.
END.

PROCEDURE pi-put:
    DEF  INPUT PARAM jsonInput       AS JsonObject           NO-UNDO.
    DEF OUTPUT PARAM jsonOutput      AS JsonObject           NO-UNDO.
    MESSAGE "*** pi-put" .
    jsonOutput = jsonInput.
END.

PROCEDURE pi-delete:
    DEF  INPUT PARAM jsonInput       AS JsonObject           NO-UNDO.
    DEF OUTPUT PARAM jsonOutput      AS JsonObject           NO-UNDO.
    MESSAGE "*** pi-delete" .
    jsonOutput = jsonInput.
END.

