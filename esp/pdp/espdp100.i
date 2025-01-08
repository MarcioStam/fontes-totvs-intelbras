DEFINE VARIABLE jsonObjectOutput        AS JsonObject   NO-UNDO.
DEFINE VARIABLE jsonObjectPayload       AS jsonObject   NO-UNDO.
DEFINE VARIABLE objCondpag                AS JsonObject   NO-UNDO.
DEFINE VARIABLE arrayCondpag              AS jsonArray    NO-UNDO.

DEFINE VARIABLE c-jason                 AS CHAR   NO-UNDO.

DEF VAR c-estado AS LONGCHAR.
DEF VAR c-item   AS LONGCHAR.


/****************************************************************************************************/

PROCEDURE pi-gera-json.

    arrayCondpag  = NEW JsonArray().
    

    objCondpag = NEW JsonObject().

    objCondpag:add("name",                cond-pagto.descricao).
    objCondpag:add("externalId",          cond-pagto.cod-cond-pag).

    IF int-cond-pagto.ativa = YES
       THEN objCondpag:add("isActive",              'true').
       ELSE objCondpag:add("isActive",              'false').
   
    IF SUBSTRING(int-cond-pagto.char-1,7,1) = 'S' 
       THEN objCondpag:add("enabledRetail",        'true').
       ELSE objCondpag:add("enabledRetail",        'false').

    IF SUBSTRING(int-cond-pagto.char-1,10,1) = 'S'
       THEN objCondpag:add("enabledReseller",        'true').
       ELSE  objCondpag:add("enabledReseller",       'false').

    IF SUBSTRING(int-cond-pagto.char-1,6,1) = 'S' 
       THEN objCondpag:add("enabledDistributor",       'true').
       ELSE objCondpag:add("enabledDistributor",       'false').

    IF int-cond-pagto.log-ativo-exportacao         
       THEN objCondpag:ADD("exportEnabled",    'true').
       ELSE objCondpag:ADD("exportEnabled",    'false').

    IF int-cond-pagto.log-ativo-verticais          
       THEN objCondpag:add("solutionsAndProjectsEnabled",      'true').
       ELSE objCondpag:add("solutionsAndProjectsEnabled",      'false').
    
    ASSIGN c-estado = ''.
    FOR EACH int-cond-pagto-uf NO-LOCK
       WHERE int-cond-pagto-uf.cod-cond-pag  = cond-pagto.cod-cond-pag
         AND int-cond-pagto-uf.dt-ini-valid <= TODAY
         AND int-cond-pagto-uf.dt-fim-valid >= TODAY:
       ASSIGN c-estado = c-estado + int-cond-pagto-uf.estado + ';'.

    END.
                 
    objCondpag:ADD("states",            trim(c-estado)).
    
    ASSIGN c-item = ''.
    FOR EACH int-cond-pagto-produto NO-LOCK
       WHERE int-cond-pagto-produto.cod-cond-pag  = cond-pagto.cod-cond-pag
         AND int-cond-pagto-produto.dt-ini-valid <= TODAY
         AND int-cond-pagto-produto.dt-fim-valid >= TODAY:
       ASSIGN c-item = c-item + int-cond-pagto-produto.it-codigo + ';'.

    END.

    objCondpag:ADD("products",            trim(c-item)).
    arrayCondpag:ADD(objCondpag).
    
    jsonObjectOutput = NEW jsonObject().
    jsonObjectOutput:ADD("Condpag", arrayCondpag).

     
END PROCEDURE. 




