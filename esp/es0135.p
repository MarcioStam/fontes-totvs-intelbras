/******************************************************************************
**
** Programa: es0135.p
**
**   Funcao: Calcular digito verificador
**
**    Autor: Eder Carlos Querino - Status Informatica. 
**
**     Data: 17/04/97
**
******************************************************************************/
def input  parameter c-linha     as char.
def output parameter i-it-digito   as integer format "9".

def var i-it-resto  as integer format "999.999999".
def var i-it-soma   as integer.
def var x           as i init 0.
def var y           as i init 2.

assign i-it-soma   = 0.

do x = length(c-linha) to 1 by -1:
      assign i-it-soma = i-it-soma + (int(substring(c-linha,x,1)) * y)
                     y = y + 1.                
end.              

assign i-it-resto  = i-it-soma - (trunc(i-it-soma / 11,0) * 11).
if  i-it-resto = 0 or
    i-it-resto = 1 then
    assign i-it-digito = 0.
else assign i-it-digito = 11 - i-it-resto.







