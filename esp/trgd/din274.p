/********************************************************************************
 ** UPC........: din274.p - UPC DELETE ordem-compra
 ** Data.......: 30/09/2022
 ** Objetivo...: Teoricamente, por‚m, o registro da OC nÆo deveria ser eliminado
 ********************************************************************************/

def param buffer bff-ordem-compra for ordem-compra.

for first int-ordem-compra exclusive-lock
    where int-ordem-compra.numero-ordem = bff-ordem-compra.numero-ordem:
    delete int-ordem-compra.
end.

