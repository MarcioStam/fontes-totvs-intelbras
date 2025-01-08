/********************************************************************************
 ** UPC........: din260.p - UPC DELETE oper-ord
 ** Data.......: 29/04/2022
 ** Objetivo...: 
 ********************************************************************************/

def param buffer bff-oper-ord for oper-ord.

for first int-oper-ord exclusive-lock
    where int-oper-ord.nr-ord-produ = bff-oper-ord.nr-ord-produ
      and int-oper-ord.it-codigo    = bff-oper-ord.it-codigo   
      and int-oper-ord.cod-roteiro  = bff-oper-ord.cod-roteiro 
      and int-oper-ord.op-codigo    = bff-oper-ord.op-codigo:
    delete int-oper-ord.
end.

RETURN "OK".


