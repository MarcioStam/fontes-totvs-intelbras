DEF TEMP-TABLE  tt-cond 
    FIELD cond-pagto  AS INTEGER
    FIELD it-codigo   AS CHAR
    FIELD dt-ini      AS DATE
    FIELD dt-fim      AS DATE.

DEF INPUT PARAM row-table       AS ROWID.
def input-output parameter table for tt-cond.

FIND FIRST int-cond-pagto-produto 
     WHERE rowid(int-cond-pagto-produto) = row-table NO-LOCK NO-ERROR.

IF AVAIL int-cond-pagto-produto THEN DO:
   RUN pi-carrega-dados.
END.
ELSE DO:
   FIND FIRST tt-cond NO-ERROR.
   IF NOT AVAIL tt-cond THEN
   FOR EACH int-cond-pagto-produto 
      WHERE int-cond-pagto-produto.it-codigo <> '' NO-LOCK:
       RUN pi-carrega-dados.
   END.
END.
    
    
PROCEDURE pi-carrega-dados.
    
    CREATE tt-cond.
    FIND FIRST ITEM
         WHERE ITEM.it-codigo = int-cond-pagto-produto.it-codigo NO-LOCK NO-ERROR.
    IF AVAIL ITEM THEN DO:
       ASSIGN tt-cond.cond-pagto = int-cond-pagto-produto.cod-cond-pag
              tt-cond.it-codigo   = int-cond-pagto-produto.it-codigo
               tt-cond.dt-ini     = int-cond-pagto-produto.dt-ini-valid
               tt-cond.dt-fim     = int-cond-pagto-produto.dt-fim-valid.
    END.
END.


