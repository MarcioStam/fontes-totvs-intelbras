/**
 * Extrator para BI
 * Dimens∆o: Portador
 *
 * Autor: Felipe Braun Azambuja
 */

create widget-pool.

&scoped-define TEMP_TABLE  ttDimPortador
&scoped-define ARQUIVO_TXT DimPortador

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
define temp-table ttDimPortador no-undo
   field CD_Portador       like emscad.portador.cod_portador
   field TX_Portador       like emscad.portador.nom_pessoa
   field CD_Tipo_Portador  like emscad.portador.ind_tip_portad
   index idx_pri is primary unique CD_Portador.

for each emscad.portador no-lock:
   create ttDimPortador.
   assign ttDimPortador.CD_Portador       = emscad.portador.cod_portador
          ttDimPortador.TX_Portador       = emscad.portador.nom_pessoa
          ttDimPortador.CD_Tipo_Portador  = emscad.portador.ind_tip_portad.
end.

run createTxt(input buffer {&TEMP_TABLE}:handle, "{&ARQUIVO_TXT}").
