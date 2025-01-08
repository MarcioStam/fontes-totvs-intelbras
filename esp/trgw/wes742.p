/********************************************************************************/
/** UPC........: wes742.p - Trigger de write da tabela int-cc-benef          */
/********************************************************************************/
trigger procedure for WRITE of int-cc-benef.                                

{esp/esb/esesbapi010-saldo.i1}
{esp/esb/in/msg0152.i3} /*tt-erro*/

DEF TEMP-TABLE tt-benef
    FIELD externalid   AS CHAR FORMAT "x(30)"
    FIELD requestLimit AS DECIMAL
    FIELD startDate    AS DATE
    FIELD endDate      AS DATE
    FIELD typeBen      AS CHAR
    FIELD vmcName      AS CHAR
    FIELD quarter      AS CHAR
    FIELD registro     AS ROWID.

DEF TEMP-TABLE tt-erro-saldo NO-UNDO LIKE tt-erro.

DEF VAR l-ok   AS LOG  NO-UNDO.
DEF VAR dt-aux AS DATE NO-UNDO.

IF  NEW(int-cc-benef)
AND int-cc-benef.tipo-benef = 21 /* VMC */ THEN DO:
    CREATE tt-benef.

    RUN esp/esb/esesbapi013-saldo.p (INPUT int-cc-benef.canal,
                                     INPUT int-cc-benef.tipo-benef,
                                     INPUT int-cc-benef.unid-neg,
                                     INPUT int-cc-benef.dt-periodo-ini,
                                     INPUT int-cc-benef.dt-periodo-fim,
                                     INPUT ?,
                                     INPUT ?,
                                     OUTPUT l-ok,
                                     OUTPUT TABLE tt-saldo,
                                     OUTPUT TABLE tt-erro-saldo).

    FIND FIRST emitente
         WHERE emitente.cod-emitente = int-cc-benef.canal NO-LOCK NO-ERROR.

    IF  AVAIL emitente THEN
        FIND FIRST mgcad.pais
             WHERE pais.nome-pais = emitente.pais NO-LOCK NO-ERROR.

    IF  AVAIL mgcad.pais THEN
        ASSIGN tt-benef.externalId = STRING(substr(pais.char-1,23,2),"!!") + emitente.cgc.
    ELSE
        ASSIGN tt-benef.externalId = "BR" + emitente.cgc.

    ASSIGN tt-benef.startDate = int-cc-benef.dt-periodo-ini
           tt-benef.endDate   = int-cc-benef.dt-periodo-fim
           tt-benef.typeBen   = "VMC"
           tt-benef.vmcName   = "VMC " + string(MONTH(dt-periodo-ini)) + " a " + STRING(MONTH(dt-periodo-fim)) + ' ' + STRING(YEAR(dt-periodo-fim))
           tt-benef.registro  = ROWID(int-cc-benef)
           tt-benef.quarter   = STRING(YEAR(dt-periodo-ini)) + "-T".

    IF  MONTH(dt-periodo-ini) >= 1  AND MONTH(dt-periodo-ini) <= 3  THEN assign tt-benef.quarter = tt-benef.quarter + '1'. ELSE
    IF  MONTH(dt-periodo-ini) >= 4  AND MONTH(dt-periodo-ini) <= 6  THEN assign tt-benef.quarter = tt-benef.quarter + '2'. ELSE
    IF  MONTH(dt-periodo-ini) >= 7  AND MONTH(dt-periodo-ini) <= 9  THEN assign tt-benef.quarter = tt-benef.quarter + '3'. ELSE
    IF  MONTH(dt-periodo-ini) >= 10 AND MONTH(dt-periodo-ini) <= 12 THEN assign tt-benef.quarter = tt-benef.quarter + '4'. ELSE
        ASSIGN tt-benef.quarter = tt-benef.quarter + '?'.
      
    IF  CAN-FIND (FIRST tt-saldo) THEN DO:
        FOR EACH tt-saldo:
            IF  int-cc-benef.id-status = 1 THEN
                ASSIGN tt-benef.requestlimit = tt-benef.requestlimit + tt-saldo.VerbaDisponivel.
            ELSE
                ASSIGN tt-benef.requestlimit = 0.
        END.
    END.

    RUN esp/wso/eswso0018.p (INPUT-OUTPUT TABLE tt-benef, 'PUT').
END.
