/*******************************************************************************
**
** CE9997.I - Seleciona o movimento a ser impresso conforme o tipo
**            de custo MÇdio/On-line/Padr∆o.
**             
********************************************************************************/ 

/* ParÉmetros 
{1} Nome da tabela ou buffer
{2} -m = medio 
    -o = online
    -p = padr∆o
{3} Comando para query.
{4} Moeda (1,2 ou 3)
*/

if ({1}.esp-docto = 37 or {1}.esp-docto = 2 ) and 
    {1}.valor-mat{2}[{4}] = 0  and
    {1}.valor-mob{2}[{4}] = 0  and
    {1}.valor-ggf{2}[{4}] = 0  then do:
    {3}. 
    next.
end.

/* Fim Include */
