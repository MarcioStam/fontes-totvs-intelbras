{include/i-epc200.i1}
{method/dbotterr.i}
{include/boerrtab.i}

DEFINE INPUT PARAMETER p-ind-event  AS CHARACTER    NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-epc.

DEF TEMP-TABLE tt-natur-oper NO-UNDO LIKE natur-oper
    FIELD r-rowid AS ROWID.

/* main block */

case p-ind-event:
    when 'afterCreateRecord' then do:
        FIND tt-epc NO-LOCK WHERE tt-epc.cod-parameter = 'Table-Rowid'.
    
        FIND natur-oper WHERE ROWID(natur-oper) = TO-ROWID(tt-epc.val-parameter) no-LOCK NO-ERROR.
        IF NOT AVAIL natur-oper THEN RETURN "ok".

        FIND int-natur-oper
             WHERE int-natur-oper.nat-operacao = natur-oper.nat-operacao EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAIL int-natur-oper THEN DO:
            CREATE int-natur-oper.
            ASSIGN int-natur-oper.nat-operacao = natur-oper.nat-operacao.
        END.
    end.    
    when 'beforeDeleteRecord' THEN DO:
        FIND tt-epc NO-LOCK WHERE tt-epc.cod-parameter = 'Table-Rowid'.
    
        FIND natur-oper NO-LOCK WHERE ROWID(natur-oper) = TO-ROWID(tt-epc.val-parameter) NO-ERROR.
        IF NOT AVAIL natur-oper THEN RETURN "ok".
    
        FIND int-natur-oper NO-LOCK
            WHERE int-natur-oper.nat-operacao = natur-oper.nat-operacao NO-ERROR.
        IF AVAILABLE int-natur-oper THEN DO:
            FIND CURRENT int-natur-oper EXCLUSIVE-LOCK.
            DELETE int-natur-oper.
        END.
    END.
end case.
RETURN "Ok":U.
