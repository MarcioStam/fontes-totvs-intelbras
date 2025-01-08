DEF PARAM BUFFER b-pto-contr     FOR pto-contr.
DEF PARAM BUFFER b-old-pto-contr FOR pto-contr.

FIND FIRST int-pto-contr NO-LOCK
     WHERE int-pto-contr.cod-pto-contr = b-pto-contr.cod-pto-contr NO-ERROR.

IF NOT AVAIL int-pto-contr THEN DO:
    CREATE int-pto-contr.
    ASSIGN int-pto-contr.cod-pto-contr = b-pto-contr.cod-pto-contr.
END.
