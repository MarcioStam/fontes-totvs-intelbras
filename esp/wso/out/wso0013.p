DEF TEMP-TABLE  tt-cond 
    FIELD externalId  AS CHAR
    FIELD cond-pagto  AS INTEGER
    FIELD dt-ini      AS DATE
    FIELD dt-fim      AS DATE.

DEF INPUT PARAM row-table       AS ROWID.
def input-output parameter table for tt-cond.

FIND FIRST int-cond-pag-cli-det 
     WHERE rowid(int-cond-pag-cli-det) = row-table NO-LOCK NO-ERROR.

IF AVAIL int-cond-pag-cli-det THEN DO:
   RUN pi-carrega-dados.
END.
ELSE DO:
   FIND FIRST tt-cond NO-ERROR.
   IF NOT AVAIL tt-cond THEN
   FOR EACH int-cond-pag-cli-det 
      WHERE int-cond-pag-cli-det.cod-emitente > 0 NO-LOCK:
       RUN pi-carrega-dados.
   END.
END.
    
    
PROCEDURE pi-carrega-dados.
    
    CREATE tt-cond.
    FIND FIRST emitente 
         WHERE emitente.cod-emitente = int-cond-pag-cli-det.cod-emitente NO-LOCK NO-ERROR.
    IF AVAIL emitente THEN DO:
       FIND FIRST mgcad.pais 
            WHERE pais.nome-pais = emitente.pais NO-LOCK NO-ERROR.
       IF AVAIL mgcad.pais THEN
          ASSIGN tt-cond.externalId = STRING(substr(pais.nome-pais,1,2),"!!") + emitente.cgc.
       ELSE 
          ASSIGN tt-cond.externalId = "BR" + emitente.cgc.

        ASSIGN tt-cond.cond-pagto = int-cond-pag-cli-det.cod-cond-pagto
               tt-cond.dt-ini     = int-cond-pag-cli-det.dt-ini-valid
               tt-cond.dt-fim     = int-cond-pag-cli-det.dt-fim-valid.
    END.
END.


