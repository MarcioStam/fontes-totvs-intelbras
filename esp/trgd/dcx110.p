DEF PARAM BUFFER b-pto-contr     FOR pto-contr.

FIND FIRST int-pto-contr EXCLUSIVE-LOCK
     WHERE int-pto-contr.cod-pto-contr = b-pto-contr.cod-pto-contr NO-ERROR.

IF AVAIL int-pto-contr THEN
   DELETE int-pto-contr.
