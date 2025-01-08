/**
 * Extrator para BI
 * Dimens∆o: Condiá∆o de Pagamento
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
define temp-table tt-cond-pagto no-undo
   field cod-cond-pag like cond-pagto.cod-cond-pag
   field descricao    like cond-pagto.descricao
   index ch-pri is primary unique cod-cond-pag.

for each cond-pagto no-lock:
   create tt-cond-pagto.
   buffer-copy cond-pagto to tt-cond-pagto.
end.

/** Condiá∆o especial **/
create tt-cond-pagto.
assign tt-cond-pagto.cod-cond-pag = 0
       tt-cond-pagto.descricao    = 'NAO ENCONTRADA OU ESPECIAL'.

run createTxt(input buffer tt-cond-pagto:handle, "DimCondicaoPagamento").
