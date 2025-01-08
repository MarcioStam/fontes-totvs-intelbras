/**
 * Extrator para BI
 * Dimens∆o: Unidade Comercial e Categorias
 *
 * Autor: Felipe Braun Azambuja
 */

create widget-pool.

&scoped-define TEMP_TABLE  ttUnidadeComercial
&scoped-define ARQUIVO_TXT DimUnidadeComercial

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
define temp-table ttUnidadeComercial no-undo
   field CD_Unidade_Comercial like unid-comerc.cd-unid-comerc
   field TX_Unidade_Comercial like unid-comerc.ds-unid-comerc
   index idx_pri is primary unique CD_Unidade_Comercial.

/** Evitando erros **/
create ttUnidadeComercial.
assign ttUnidadeComercial.CD_Unidade_Comercial = 0
       ttUnidadeComercial.TX_Unidade_Comercial = 'NAO ENCONTRADO'.

for each unid-comerc no-lock:
   create ttUnidadeComercial.
   assign ttUnidadeComercial.CD_Unidade_Comercial = unid-comerc.cd-unid-comerc
          ttUnidadeComercial.TX_Unidade_Comercial = unid-comerc.ds-unid-comerc.
end.

run createTxt(input buffer {&TEMP_TABLE}:handle, "{&ARQUIVO_TXT}").
