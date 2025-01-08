/********************************************************************************
 ** UPC........: wes741.p - WRITE int-cond-pag-cli-det
 ** Data.......: 29/12/2021
 ** Objetivo...: Integra condi‡oes de pagamento do cliente
 ********************************************************************************/

TRIGGER PROCEDURE FOR WRITE OF int-cond-pag-cli-det.
    
DEF BUFFER b-int-cond-pag-cli-det FOR int-cond-pag-cli-det.
DEF BUFFER b-matriz               FOR emitente.


DEF TEMP-TABLE  tt-cond 
    FIELD externalId  AS CHAR
    FIELD cond-pagto  AS INTEGER
    FIELD dt-ini      AS DATE
    FIELD dt-fim      AS DATE.

{utp/ut-glob.i}

DEFINE VARIABLE i-sequencia   AS INTEGER   NO-UNDO.

IF  AVAIL int-cond-pag-cli-det THEN DO:

    CREATE tt-cond.

    FIND FIRST emitente 
         WHERE emitente.cod-emitente = int-cond-pag-cli-det.cod-emitente NO-LOCK NO-ERROR.
    IF AVAIL emitente THEN DO:
       FIND FIRST mgcad.pais 
            WHERE pais.nome-pais = emitente.pais NO-LOCK NO-ERROR.
         IF AVAIL mgcad.pais 
            THEN ASSIGN tt-cond.externalId = STRING(substr(pais.char-1,23,2),"!!") + emitente.cgc.
            ELSE ASSIGN tt-cond.externalId = "BR" + emitente.cgc.
       
       ASSIGN tt-cond.cond-pagto = int-cond-pag-cli-det.cod-cond-pagto
              tt-cond.dt-ini     = int-cond-pag-cli-det.dt-ini-valid
              tt-cond.dt-fim     = int-cond-pag-cli-det.dt-fim-valid.

       FIND FIRST int-cond-pag-cli NO-LOCK
            WHERE int-cond-pag-cli.cod-emitente = emitente.cod-emitente 
              AND int-cond-pag-cli.grupo-econ NO-ERROR.

       /* Procura pela matriz, se for Grupo EconËmico */
       IF AVAIL int-cond-pag-cli THEN DO:
           FOR EACH b-matriz
              WHERE b-matriz.nome-matriz = emitente.nome-matriz
                AND b-matriz.cod-emitente <> emitente.cod-emitente:
           
              CREATE tt-cond.
              FIND FIRST mgcad.pais 
                   WHERE pais.nome-pais = b-matriz.pais NO-LOCK NO-ERROR.
              IF AVAIL mgcad.pais 
                 THEN ASSIGN tt-cond.externalId = STRING(substr(pais.char-1,23,2),"!!") + b-matriz.cgc.
                 ELSE ASSIGN tt-cond.externalId = "BR" + b-matriz.cgc.

               ASSIGN tt-cond.cond-pagto   = int-cond-pag-cli-det.cod-cond-pagto 
                      tt-cond.dt-ini       = int-cond-pag-cli-det.dt-ini-valid   
                      tt-cond.dt-fim       = int-cond-pag-cli-det.dt-fim-valid.  
           END.
       END.

       run esp/wso/eswso0013.p (INPUT ?,
                                INPUT-OUTPUT TABLE tt-cond,
                                INPUT 'PUT').
    END.
END.
  


RETURN "OK".

