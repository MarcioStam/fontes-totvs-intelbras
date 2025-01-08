/**
 * Extrator para BI
 * Dimens∆o: Fam°lia Comercial
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

/** N∆o precisa de l¢gica nenhuma, j† que Ç a tabela toda com todos os campos **/

run createTxt(input buffer fam-com-item:handle, "DimFamiliaComercial").

