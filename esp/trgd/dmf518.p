/********************************************************************************
 ** UPC........: dmf518.p - UPC DELETE operador
 ** Data.......: 22/07/2022
 ** Objetivo...: 
 ********************************************************************************/

def param buffer bff-operador for operador.

for each int-gm-operador use-index ch-operador exclusive-lock
   where int-gm-operador.cod-operador = bff-operador.cod-operador:
    delete int-gm-operador.
end.
