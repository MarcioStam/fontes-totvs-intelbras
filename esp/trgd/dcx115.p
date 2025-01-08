DEF PARAM BUFFER b-itinerario     FOR itinerario.

FIND FIRST int-itinerario EXCLUSIVE-LOCK
     WHERE int-itinerario.cod-itiner = b-itinerario.cod-itiner NO-ERROR.

IF AVAIL int-itinerario THEN
   DELETE int-itinerario.
