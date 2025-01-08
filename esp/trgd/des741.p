
/********************************************************************************/
/** UPC........: des741.p - Elimina condicao de pagaento por cliente                */
/********************************************************************************/
trigger procedure for DELETE of int-cond-pag-cli-det.                                

DEF TEMP-TABLE  tt-cond 
    FIELD externalId  AS CHAR
    FIELD cond-pagto  AS INTEGER
    FIELD dt-ini      AS DATE
    FIELD dt-fim      AS DATE.
    
EMPTY TEMP-TABLE tt-cond. 

IF  AVAIL int-cond-pag-cli-det THEN DO:
   CREATE tt-cond.

   FIND FIRST emitente 
        WHERE emitente.cod-emitente = int-cond-pag-cli-det.cod-emitente NO-LOCK NO-ERROR.
   IF AVAIL emitente THEN
      ASSIGN tt-cond.externalId = 'BR' + emitente.cgc.

   ASSIGN tt-cond.cond-pagto = int-cond-pag-cli-det.cod-cond-pagto
          tt-cond.dt-ini     = int-cond-pag-cli-det.dt-ini-valid
          tt-cond.dt-fim     = int-cond-pag-cli-det.dt-fim-valid.

   run esp/wso/eswso0013.p (INPUT ROWID(int-cond-pag-cli-det),
                            INPUT-OUTPUT TABLE tt-cond,
                            INPUT 'DELETE').


END.
      


RETURN "OK".


