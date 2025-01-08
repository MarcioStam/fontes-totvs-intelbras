DEF PARAM BUFFER b-desp-imp      FOR desp-imp.
DEF PARAM BUFFER b-old-desp-imp  FOR desp-imp.

IF NOT CAN-FIND (FIRST int-desp-imp
                 WHERE int-desp-imp.cod-desp = b-desp-imp.cod-desp) THEN DO:

    CREATE int-desp-imp.
    ASSIGN int-desp-imp.cod-desp = b-desp-imp.cod-desp.
END.


RETURN "OK".
