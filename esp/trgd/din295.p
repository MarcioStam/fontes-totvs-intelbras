/********************************************************************************
 ** UPC........: din295.p - UPC DELETE pedido-compr
 ** Data.......: Outubro / 2006
 ** Objetivo...: 
 ********************************************************************************/

DEF PARAM BUFFER b-pedido-compr FOR pedido-compr.

FIND FIRST int-pedido-compr 
     WHERE int-pedido-compr.num-pedido = b-pedido-compr.num-pedido NO-ERROR.
IF AVAIL int-pedido-compr THEN
    DELETE int-pedido-compr.

FOR FIRST int-ped-compr
    WHERE int-ped-compr.num-pedido = b-pedido-compr.num-pedido
          EXCLUSIVE-LOCK: END.

IF AVAIL int-ped-compr
THEN DO:
     FOR EACH int-mov-ped-compr EXCLUSIVE-LOCK
        WHERE int-mov-ped-compr.id-ped-compr = int-ped-compr.id-ped-compr:
         DELETE int-mov-ped-compr.
     END.

     DELETE int-ped-compr.
END.

RETURN "ok".
