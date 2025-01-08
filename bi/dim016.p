/**
 * Extrator para BI
 * Dimens∆o: Unidade de Neg¢cio
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
define temp-table ttDimUnidadeNegocio no-undo
   field CD_Unidade_Negocio like unid_negoc.cod_unid_negoc
   field TX_Unidade_Negocio like unid_negoc.des_unid_negoc
   index idx_pri is primary unique CD_Unidade_Negocio.

for each unid_negoc no-lock:
   create ttDimUnidadeNegocio.
   assign ttDimUnidadeNegocio.CD_Unidade_Negocio = fn-free-accent(upper(trim(unid_negoc.cod_unid_negoc)))
          ttDimUnidadeNegocio.TX_Unidade_Negocio = fn-free-accent(upper(trim(unid_negoc.des_unid_negoc))).
end.

/** Cria a unidade "inv†lida" **/
create ttDimUnidadeNegocio.
assign ttDimUnidadeNegocio.CD_Unidade_Negocio = 'INV'
       ttDimUnidadeNegocio.TX_Unidade_Negocio = 'INVALIDA'.

run createTxt(input buffer ttDimUnidadeNegocio:handle, "DimUnidadeNegocio").
