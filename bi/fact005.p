/**
 * Extrator para BI
 * Fato: Redutor Carteira
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
define temp-table tt-redutor-carteira no-undo
   field cod_unid_negoc like unid-neg-ped.cod_unid_negoc
   field vlr-redutor    like redutor-carteira.vlr-redutor
   index ch-pri is primary unique cod_unid_negoc.

for each redutor-carteira no-lock
   by redutor-carteira.da-data-validade desc:
   
   find tt-redutor-carteira
      where tt-redutor-carteira.cod_unid_negoc = redutor-carteira.unid-neg no-error.

   if available tt-redutor-carteira then
      next.

   create tt-redutor-carteira.
   assign tt-redutor-carteira.cod_unid_negoc = redutor-carteira.unid-neg
          tt-redutor-carteira.vlr-redutor    = redutor-carteira.vlr-redutor.
end.

/** Elimina os registros que n∆o tàm valor **/
for each tt-redutor-carteira
   where tt-redutor-carteira.vlr-redutor = 0:
   delete tt-redutor-carteira.
end.

run createTxt(input buffer tt-redutor-carteira:handle, "FactRedutorCarteira").
