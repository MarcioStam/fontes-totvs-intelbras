DEFINE VARIABLE jsonObjectOutput        AS JsonObject   NO-UNDO.
DEFINE VARIABLE jsonObjectPayload       AS jsonObject   NO-UNDO.
DEFINE VARIABLE objCategoria            AS JsonObject   NO-UNDO.
DEFINE VARIABLE arrayCategoria          AS jsonArray    NO-UNDO.
DEFINE VARIABLE jsonArrayPayload        AS jsonArray    NO-UNDO.

DEFINE VARIABLE c-jason                 AS CHAR   NO-UNDO.

DEF TEMP-TABLE tt_categ_cad NO-UNDO
    FIELD cod_categ       AS CHAR FORMAT "x(50)"
    FIELD nome_categoria  AS CHAR FORMAT "x(20)".

/****************************************************************************************************/

PROCEDURE pi-gera-json.

    arrayCategoria = NEW JsonArray().
    
    FOR EACH tt_categ_cad NO-LOCK:

        IF  tt_categ_cad.cod_categ <> "" THEN DO:
            objCategoria = NEW JsonObject().
    
            objCategoria:ADD("nomeCategoria",      STRING(tt_categ_cad.nome_categoria)).
            objCategoria:ADD("codigoCategoria",    STRING(tt_categ_cad.cod_categ)).
            objCategoria:ADD("tipoRelacionamento", 1).
            objCategoria:ADD("contaInadimplencia", 1).
            objCategoria:ADD("contaPagamento",     1).
                 
            arrayCategoria:ADD(objCategoria).
        END.
     END.

/*      jsonArrayPayload = NEW JsonArray().                        */
      JsonObjectOutput = NEW JsonObject().                       
/*                                                                 */
      jsonObjectOutput:ADD("Complementar", arrayCategoria).     
/*      jsonArrayPayload:ADD(arrayCategoria /*jsonObjectOutput*/). */

     ASSIGN c-jason = string(jsonObjectOutput:getjsontext())   /* JsonAPIUtils:getJsonArrayChar(arrayCategoria)*/ .

END PROCEDURE. 




