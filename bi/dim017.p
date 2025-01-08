/**
 * Extrator para BI
 * Dimens∆o: Dep¢sito
 *
 * Autor: Felipe Braun Azambuja
 */

create widget-pool.

{bi/esbi000.i}
{include/i-freeac.i}

/**
 * Leitura do XML
 */
define variable c-xml as character no-undo.
assign c-xml = entry(2,session:parameter).
file-info:file-name = c-xml.
if (index(file-info:file-type, 'f') = 0) then
   leave.
{bi/esbi001.i c-xml}

/** Valida diret¢rio de sa°da **/
assign c-diretorio = getTag("diretorio").
file-info:file-name = c-diretorio.
if (index(file-info:file-type, 'd') = 0) or (c-diretorio = "") then
   leave.

/**
 * Regra de neg¢cio a partir daqui
 */
define temp-table ttDimDeposito no-undo
   field CD_Deposito like deposito.cod-depos
   field TX_Deposito like deposito.nome
   index idx_pri is primary unique CD_Deposito.

define variable c-cod-depos   as character   no-undo.

for each deposito no-lock:
   assign c-cod-depos = fn-free-accent(upper(trim(deposito.cod-depos))).

   create ttDimDeposito.
   assign ttDimDeposito.CD_Deposito = c-cod-depos
          ttDimDeposito.TX_Deposito = deposito.nome.
end.

run createTxt(input buffer ttDimDeposito:handle, "DimDeposito").

