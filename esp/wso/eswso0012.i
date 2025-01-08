DEFINE VARIABLE jsonObjectOutput        AS JsonObject   NO-UNDO.
DEFINE VARIABLE jsonObjectPayload       AS jsonObject   NO-UNDO.
DEFINE VARIABLE objItem                 AS JsonObject   NO-UNDO.
DEFINE VARIABLE objKit                  AS JsonObject   NO-UNDO.
DEFINE VARIABLE arrayItem               AS jsonArray    NO-UNDO.
DEFINE VARIABLE arrayKit                AS jsonArray    NO-UNDO.

DEFINE VARIABLE c-jason                 AS CHAR   NO-UNDO.

/*
{
  "clientGroupId": 74,
  "productCode": "9900053",
  "businessUnitCode": "11",
  "segmentCode": "1100"
  "productFamilyCode": "11000000"
}
  */



DEF TEMP-TABLE  tt-item 
    FIELD cod-gr-cli    LIKE int-gr-cli-catalogo.cod-gr-cli 
    FIELD it-codigo     LIKE int-gr-cli-catalogo.it-codigo
    FIELD cod-unid-neg  AS CHAR
    FIELD segmento      AS CHAR
    FIELD familia       AS CHAR
    FIELD rowiditem     AS ROWID.

/****************************************************************************************************/

PROCEDURE pi-gera-json.
    
    arrayItem  = NEW JsonArray().
    objItem = NEW JsonObject().

    objItem:add("clientGroupId",        tt-item.cod-gr-cli).
    objItem:add("productCode",          tt-item.it-codigo).
    objItem:add("businessUnitCode",     tt-item.cod-unid-neg).
    objItem:add("segmentCode",          tt-item.segmento).
    objItem:add("productFamilyCode",    tt-item.familia).
    objItem:ADD("rowId",                tt-item.rowiditem).

    arrayItem:ADD(objItem).

    jsonObjectOutput = NEW jsonObject().
    jsonObjectOutput:ADD("product", arrayItem).

     
END PROCEDURE. 




