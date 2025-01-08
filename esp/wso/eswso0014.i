DEFINE VARIABLE jsonObjectOutput        AS JsonObject   NO-UNDO.
DEFINE VARIABLE jsonObjectPayload       AS jsonObject   NO-UNDO.
DEFINE VARIABLE objCond                 AS JsonObject   NO-UNDO.
DEFINE VARIABLE arrayCond               AS jsonArray    NO-UNDO.

DEFINE VARIABLE c-jason                 AS CHAR   NO-UNDO.

DEF TEMP-TABLE  tt-cond 
    FIELD cond-pagto  AS INTEGER
    FIELD uf          AS CHAR
    FIELD dt-ini      AS DATE
    FIELD dt-fim      AS DATE.

/****************************************************************************************************/

PROCEDURE pi-gera-json.

    arrayCond  = NEW JsonArray().
    

    objCond = NEW JsonObject().

    objCond:add("paymentCondition", tt-cond.cond-pagto).
    objCond:add("uf", tt-cond.uf).
    IF tt-cond.dt-ini < 01/01/1700 THEN
        ASSIGN tt-cond.dt-ini = 01/01/1700.
    
    objCond:add("startDate", tt-cond.dt-ini).
    IF tt-cond.dt-fim < TODAY + 720 THEN
    objCond:add("endDate", tt-cond.dt-fim).
    ELSE 
    objCond:add("endDate", 'null').
    arrayCond:ADD(objCond).


     jsonObjectOutput = NEW jsonObject().
     jsonObjectOutput:ADD("condPagto", arrayCond).

     
END PROCEDURE. 




