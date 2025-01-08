DEFINE VARIABLE jsonObjectOutput        AS JsonObject   NO-UNDO.
DEFINE VARIABLE jsonObjectPayload       AS jsonObject   NO-UNDO.
DEFINE VARIABLE objBenef                AS JsonObject   NO-UNDO.
DEFINE VARIABLE arrayBenef              AS jsonArray    NO-UNDO.

DEFINE VARIABLE c-jason                 AS CHAR   NO-UNDO.



DEF TEMP-TABLE tt-benef
    FIELD externalid     AS CHAR FORMAT "x(30)"
    FIELD requestLimit   AS DECIMAL
    FIELD startDate      AS DATE
    FIELD endDate        AS DATE
    FIELD typeBen        AS CHAR
    FIELD vmcName        AS CHAR
    FIELD quarter        AS CHAR
    FIELD registro       AS ROWID.

/****************************************************************************************************/

PROCEDURE pi-gera-json.

    arrayBenef  = NEW JsonArray().
    

    objBenef = NEW JsonObject().

    objBenef:add("accountExternalId",      tt-benef.externalId).
    objBenef:add("requestLimit",    tt-benef.requestLimit).
    objBenef:add("startDate",       tt-benef.startDate).
    objBenef:add("endDate",         tt-benef.enddate).
    objBenef:ADD("type",            tt-benef.typeBen).
    objBenef:ADD("vmcName",         tt-benef.vmcName).
    objBenef:ADD("quarter",         tt-benef.quarter).
    objBenef:ADD("rowId",           STRING(tt-benef.registro)).
    arrayBenef:ADD(objBenef).


     jsonObjectOutput = NEW jsonObject().
     jsonObjectOutput:ADD("beneficio", arrayBenef).

     
END PROCEDURE. 




