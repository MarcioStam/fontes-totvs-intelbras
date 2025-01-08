/**
 * Extrator para BI
 * Dimens∆o: Moeda
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
define temp-table tt-moeda no-undo
   field mo-codigo like moeda.mo-codigo
   field descricao like moeda.descricao
   index ch-pri is primary unique mo-codigo.

for each moeda no-lock:
   create tt-moeda.
   buffer-copy moeda to tt-moeda.
end.

run createTxt(input buffer tt-moeda:handle, "DimMoeda").
