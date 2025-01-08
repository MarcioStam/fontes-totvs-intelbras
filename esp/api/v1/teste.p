{utp/ut-api.i}
{utp/ut-api-action.i pi-get       GET /~* }
{utp/ut-api-action.i pi-post      POST /~* }
{utp/ut-api-action.i pi-put       PUT /~* }
{utp/ut-api-action.i pi-delete    DELETE /~* }
{utp/ut-api-notfound.i}

PROCEDURE pi-get:
    DEF  INPUT PARAM jsonInput       AS JsonObject           NO-UNDO.
    DEF OUTPUT PARAM jsonOutput      AS JsonObject           NO-UNDO.
    MESSAGE "*** pi-get" .
    jsonOutput = JsonAPIResponseBuilder:ok(jsonInput, 200).
END.

PROCEDURE pi-post:
    DEF  INPUT PARAM jsonInput       AS JsonObject           NO-UNDO.
    DEF OUTPUT PARAM jsonOutput      AS JsonObject           NO-UNDO.
    MESSAGE "*** pi-post" .
    jsonOutput = JsonAPIResponseBuilder:ok(jsonInput, 200).
END.

PROCEDURE pi-put:
    DEF  INPUT PARAM jsonInput       AS JsonObject           NO-UNDO.
    DEF OUTPUT PARAM jsonOutput      AS JsonObject           NO-UNDO.
    MESSAGE "*** pi-put" .
    jsonOutput = JsonAPIResponseBuilder:ok(jsonInput, 200).
END.

PROCEDURE pi-delete:
    DEF  INPUT PARAM jsonInput       AS JsonObject           NO-UNDO.
    DEF OUTPUT PARAM jsonOutput      AS JsonObject           NO-UNDO.
    MESSAGE "*** pi-delete" .
    jsonOutput = JsonAPIResponseBuilder:ok(jsonInput, 200).
END.


