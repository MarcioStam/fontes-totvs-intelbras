DEF PARAM BUFFER b-desp-imp  FOR desp-imp.

FIND FIRST int-desp-imp EXCLUSIVE-LOCK
     WHERE int-desp-imp.cod-desp = b-desp-imp.cod-desp NO-ERROR.

IF AVAIL int-desp-imp THEN
    DELETE int-desp-imp.



RETURN "OK".

