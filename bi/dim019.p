/**
 * Extrator para BI
 * DimensÆo: Indicador do Cr‚dito do Cliente
 *
 * Autor: Felipe Braun Azambuja
 */

create widget-pool.

&scoped-define TEMP_TABLE  ttDimIndicadorCredito
&scoped-define ARQUIVO_TXT DimIndicadorCredito

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
define temp-table ttDimIndicadorCredito no-undo
   field CD_Indicador_Credito like emitente.ind-cre-cli
   field TX_Indicador_Credito as character
   index idx_pri is primary unique CD_Indicador_Credito.

create ttDimIndicadorCredito.
assign ttDimIndicadorCredito.CD_Indicador_Credito = 1
       ttDimIndicadorCredito.TX_Indicador_Credito = 'Normal'.

create ttDimIndicadorCredito.
assign ttDimIndicadorCredito.CD_Indicador_Credito = 2
       ttDimIndicadorCredito.TX_Indicador_Credito = 'Autom tico'.

create ttDimIndicadorCredito.
assign ttDimIndicadorCredito.CD_Indicador_Credito = 3
       ttDimIndicadorCredito.TX_Indicador_Credito = 'S¢ Imp Ped'.

create ttDimIndicadorCredito.
assign ttDimIndicadorCredito.CD_Indicador_Credito = 4
       ttDimIndicadorCredito.TX_Indicador_Credito = 'Suspenso'.

create ttDimIndicadorCredito.
assign ttDimIndicadorCredito.CD_Indicador_Credito = 5
       ttDimIndicadorCredito.TX_Indicador_Credito = 'Pg … Vista'.

run createTxt(input buffer {&TEMP_TABLE}:handle, "{&ARQUIVO_TXT}").
