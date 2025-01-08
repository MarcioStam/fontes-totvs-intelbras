/*************************************************************************
**
**        cep/ce9998.i - include para calcular a data inicial e final
**                       do mes em curso
**
************************************************************************/

assign da-iniper-x = (param-estoq.ult-fech-dia + 1).
if month(da-iniper-x) = 12 then
    assign da-fimper-x = date(01,01,year(da-iniper-x) + 1) - 1.
else
    assign da-fimper-x = date(month(da-iniper-x) + 1,01,year(da-iniper-x)) - 1.
assign i-per-corrente = month(da-iniper-x)
       i-ano-corrente = year(da-iniper-x).


/* ce9998.i */
