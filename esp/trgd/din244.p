/********************************************************************************
 ** UPC........: din244.p - UPC DELETE grup-maquina
 ** Data.......: 22/07/2022
 ** Objetivo...: 
 ********************************************************************************/

def param buffer bff-grup-maquina for grup-maquina.

for each int-gm-operador exclusive-lock
   where int-gm-operador.gm-codigo = bff-grup-maquina.gm-codigo:
    delete int-gm-operador.
end.
