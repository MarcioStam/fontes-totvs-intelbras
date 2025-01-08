DEF PARAMETER BUFFER b-wm-box-saldo-etiqueta FOR wm-box-saldo-etiqueta.

FIND FIRST b-wm-box-saldo-etiqueta NO-LOCK NO-ERROR.
IF AVAIL b-wm-box-saldo-etiqueta THEN DO:

    FIND FIRST in-agrup-etiqueta WHERE in-agrup-etiqueta.id-etiqueta-filho = b-wm-box-saldo-etiqueta.id-etiqueta EXCLUSIVE-LOCK NO-ERROR.
    IF AVAIL in-agrup-etiqueta THEN DO:
        DELETE in-agrup-etiqueta.

    END.

END.

/**** Fim da Trigger de Delete ****/
