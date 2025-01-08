/**
 * Extrator para BI
 * Dimens∆o: Carteira Banc†ria
 *
 * Autor: Felipe Braun Azambuja
 */

create widget-pool.

&scoped-define TEMP_TABLE  ttCarteiraBancaria
&scoped-define ARQUIVO_TXT DimCarteiraBancaria

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
define temp-table ttCarteiraBancaria no-undo
   field CD_Carteira_Bancaria       like cart_bcia.cod_cart_bcia
   field TX_Carteira_Bancaria       like cart_bcia.des_cart_bcia
   field CD_Tipo_Carteira_Bancaria  like cart_bcia.ind_tip_cart_bcia
   index idx_pri is primary unique CD_Carteira_Bancaria.

for each cart_bcia no-lock:
   create ttCarteiraBancaria.
   assign ttCarteiraBancaria.CD_Carteira_Bancaria       = cart_bcia.cod_cart_bcia
          ttCarteiraBancaria.TX_Carteira_Bancaria       = cart_bcia.des_cart_bcia
          ttCarteiraBancaria.CD_Tipo_Carteira_Bancaria  = cart_bcia.ind_tip_cart_bcia.
end.

run createTxt(input buffer {&TEMP_TABLE}:handle, "{&ARQUIVO_TXT}").
