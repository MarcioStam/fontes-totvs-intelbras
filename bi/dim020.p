/**
 * Extrator para BI
 * DimensÆo: Esp‚cie de Documento
 *
 * Autor: Felipe Braun Azambuja
 */

create widget-pool.

&scoped-define TEMP_TABLE  ttDimEspecieDocumento
&scoped-define ARQUIVO_TXT DimEspecieDocumento

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
define temp-table ttDimEspecieDocumento no-undo
   field CD_Especie_Documento       like espec_docto.cod_espec_docto
   field TX_Especie_Documento       like espec_docto.des_espec_docto
   field CD_Tipo_Especie_Documento  like espec_docto.ind_tip_espec_docto
   index idx_pri is primary unique CD_Especie_Documento.

for each espec_docto no-lock:
   create ttDimEspecieDocumento.
   assign ttDimEspecieDocumento.CD_Especie_Documento      = espec_docto.cod_espec_docto
          ttDimEspecieDocumento.TX_Especie_Documento      = espec_docto.des_espec_docto
          ttDimEspecieDocumento.CD_Tipo_Especie_Documento = espec_docto.ind_tip_espec_docto.
end.

run createTxt(input buffer {&TEMP_TABLE}:handle, "{&ARQUIVO_TXT}").
