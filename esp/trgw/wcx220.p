/********************************************************************************
 ** UPC........: wcx225.p - UPC WRITE embarque-imp
 ** Data.......: Dezembro / 2020
 ** Objetivo...: 
 ********************************************************************************/


DEF PARAM BUFFER new-embarque-imp  FOR embarque-imp.
DEF PARAM BUFFER old-embarque-imp  FOR embarque-imp.

DEF TEMP-TABLE tt-pedido NO-UNDO
    FIELD num-pedido LIKE pedido-compr.num-pedido.

DEF VAR l-msg     AS l NO-UNDO.
DEF VAR i         AS i NO-UNDO.

{esp/esapi505b.i}  

FIND FIRST ext-embarque-imp EXCLUSIVE-LOCK
     WHERE ext-embarque-imp.cod-estabel = new-embarque-imp.cod-estabel
       AND ext-embarque-imp.embarque    = new-embarque-imp.embarque 
     NO-ERROR.
IF  NOT AVAIL  ext-embarque-imp 
THEN DO:
   CREATE ext-embarque-imp.
   ASSIGN 
      ext-embarque-imp.cod-estabel = new-embarque-imp.cod-estabel 
      ext-embarque-imp.embarque    = new-embarque-imp.embarque.
END.

FIND FIRST historico-embarque NO-LOCK
        OF ext-embarque-imp
     NO-ERROR.
IF AVAIL historico-embarque
THEN DO:
   FIND FIRST int-itinerario NO-LOCK
        WHERE int-itinerario.cod-itiner = historico-embarque.cod-itiner
        NO-ERROR.
   IF AVAIL int-itinerario
   THEN DO:
      IF  ext-embarque-imp.cdn-pto-chegada1   = 0
      AND ext-embarque-imp.cdn-pto-chegada2   = 0
      AND ext-embarque-imp.cdn-pto-embarque2  = 0
      AND ext-embarque-imp.cdn-pto-emissao-nf = 0
      AND ext-embarque-imp.cdn-pto-instrucao  = 0
      AND ext-embarque-imp.cdn-pto-liberacao  = 0
      THEN ASSIGN
         ext-embarque-imp.cdn-pto-chegada1   = int-itinerario.cdn-pto-chegada1 
         ext-embarque-imp.cdn-pto-chegada2   = int-itinerario.cdn-pto-chegada2 
         ext-embarque-imp.cdn-pto-embarque2  = int-itinerario.cdn-pto-embarque2 
         ext-embarque-imp.cdn-pto-emissao-nf = int-itinerario.cdn-pto-emissao-nf 
         ext-embarque-imp.cdn-pto-instrucao  = int-itinerario.cdn-pto-instrucao 
         ext-embarque-imp.cdn-pto-liberacao  = int-itinerario.cdn-pto-liberacao
         .
   END.
END.

RETURN "OK".
