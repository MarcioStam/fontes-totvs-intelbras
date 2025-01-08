/**
 * Extrator para BI
 * Dimens∆o: Estabelecimentos
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
define temp-table ttDimEstabelecimento no-undo
   field CD_Empresa         like estabelec.ep-codigo
   field CD_Estabelecimento like estabelec.cod-estabel
   field TX_Estabelecimento like estabelec.nome
   field CD_Cidade          like estabelec.cidade
   field CD_Estado          like estabelec.estado
   field CD_Pais            like estabelec.pais
   index idx_pri is primary unique CD_Estabelecimento.

define variable c-nome     as character no-undo.
define variable c-pais     as character no-undo.
define variable c-estado   as character no-undo.
define variable c-cidade   as character no-undo.

for each estabelec no-lock:
   assign c-nome   = fn-free-accent(upper(trim(estabelec.nome)))
          c-pais   = fn-free-accent(upper(trim(estabelec.pais)))
          c-estado = fn-free-accent(upper(trim(estabelec.estado)))
          c-cidade = fn-free-accent(upper(trim(estabelec.cidade))).

   create ttDimEstabelecimento.
   assign ttDimEstabelecimento.CD_Empresa         = estabelec.ep-codigo
          ttDimEstabelecimento.CD_Estabelecimento = estabelec.cod-estabel
          ttDimEstabelecimento.TX_Estabelecimento = c-nome
          ttDimEstabelecimento.CD_Cidade          = c-cidade
          ttDimEstabelecimento.CD_Estado          = c-estado
          ttDimEstabelecimento.CD_Pais            = c-pais.
end.

run createTxt(input buffer ttDimEstabelecimento:handle, "DimEstabelecimento").
