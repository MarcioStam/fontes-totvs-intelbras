/**
 * Extrator para BI
 * Dimens∆o: Grupo de Estoque
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
define temp-table tt-grup-estoque no-undo
   field ge-codigo   like grup-estoque.ge-codigo
   field descricao   like grup-estoque.descricao
   index ch-pri is primary unique ge-codigo.

for each grup-estoque no-lock:
   create tt-grup-estoque.
   buffer-copy grup-estoque to tt-grup-estoque.
end.

run createTxt(input buffer tt-grup-estoque:handle, "DimGrupoEstoque").

