/**
 * Extrator para BI
 * DimensÆo: Situa‡Æo da Avalia‡Æo de Cr‚dito
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

/** Valida diret¢rio de sa¡da **/
assign c-diretorio = getTag("diretorio").
file-info:file-name = c-diretorio.
if (index(file-info:file-type, 'd') = 0) or (c-diretorio = "") then
   leave.

/**
 * Regra de neg¢cio a partir daqui
 */
define temp-table tt-sit-aval no-undo
   field cod-sit-aval   like ped-venda.cod-sit-aval
   field descricao      as character
   index ch-pri is primary unique cod-sit-aval.

create tt-sit-aval.
assign tt-sit-aval.cod-sit-aval = 1
       tt-sit-aval.descricao    = 'NÆo Avaliado'.

create tt-sit-aval.
assign tt-sit-aval.cod-sit-aval = 2
       tt-sit-aval.descricao    = 'Avaliado'.

create tt-sit-aval.
assign tt-sit-aval.cod-sit-aval = 3
       tt-sit-aval.descricao    = 'Aprovado'.

create tt-sit-aval.
assign tt-sit-aval.cod-sit-aval = 4
       tt-sit-aval.descricao    = 'NÆo Aprovado'.

create tt-sit-aval.
assign tt-sit-aval.cod-sit-aval = 5
       tt-sit-aval.descricao    = 'Pendente Informa‡Æo'.

run createTxt(input buffer tt-sit-aval:handle, "DimSituacaoAvaliacao").
