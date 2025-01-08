DEFINE NEW GLOBAL SHARED VARIABLE wgh-nr-protocolo    AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wgh-protocolo-siare AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-cod-estabel      AS WIDGET-HANDLE NO-UNDO.

ASSIGN wgh-nr-protocolo   :HIDDEN = YES
       wgh-protocolo-siare:HIDDEN = YES.

FIND FIRST estabelec NO-LOCK
     WHERE estabelec.cod-estabel = wh-cod-estabel:SCREEN-VALUE NO-ERROR.
IF AVAIL estabelec AND
   estabelec.estado = "MG" THEN
   ASSIGN wgh-nr-protocolo   :HIDDEN = NO
          wgh-protocolo-siare:HIDDEN = NO.


