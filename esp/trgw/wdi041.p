CREATE WIDGET-POOL.

DEF PARAM BUFFER b-embarque      FOR embarque.
DEF PARAM BUFFER b-old-embarque  FOR embarque.

FIND FIRST int-embarque OF b-embarque EXCLUSIVE-LOCK NO-ERROR.

IF NOT AVAIL int-embarque THEN DO:
    CREATE int-embarque.
    ASSIGN int-embarque.cdd-embarq  = b-embarque.cdd-embarq 
           int-embarque.nr-embarque = b-embarque.nr-embarque.
END.

ASSIGN int-embarque.hora-embarque = TIME.

DELETE WIDGET-POOL.
RETURN "OK".
