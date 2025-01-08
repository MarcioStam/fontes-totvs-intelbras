DEF TEMP-TABLE  tt-cond 
    FIELD cond-pagto  AS INTEGER
    FIELD uf          AS CHAR
    FIELD dt-ini      AS DATE
    FIELD dt-fim      AS DATE.

DEF INPUT PARAM row-table       AS ROWID.
def input-output parameter table for tt-cond.

FIND FIRST int-cond-pagto-uf 
     WHERE rowid(int-cond-pagto-uf) = row-table NO-LOCK NO-ERROR.

IF AVAIL int-cond-pagto-uf THEN DO:
   RUN pi-carrega-dados.
END.
ELSE DO:
   FIND FIRST tt-cond NO-ERROR.
   IF NOT AVAIL tt-cond THEN
   FOR EACH int-cond-pagto-uf 
      WHERE int-cond-pagto-uf.estado <> '' NO-LOCK:
       RUN pi-carrega-dados.
   END.
END.
    
    
PROCEDURE pi-carrega-dados.
    
    CREATE tt-cond.
    FIND FIRST unid_feder 
         WHERE unid_feder.cod_unid_feder = int-cond-pagto-uf.estado NO-LOCK NO-ERROR.
    IF AVAIL unid_feder THEN DO:
       ASSIGN tt-cond.cond-pagto = int-cond-pagto-uf.cod-cond-pag
              tt-cond.uf         = int-cond-pagto-uf.estado
               tt-cond.dt-ini     = int-cond-pagto-uf.dt-ini-valid
               tt-cond.dt-fim     = int-cond-pagto-uf.dt-fim-valid.
    END.
END.


