/**
 * Extrator para BI
 * Dimens∆o: Mensagem
 *
 * Autor: Roger M. Bruhn - Vertical Ti
 */

create widget-pool.

&scoped-define TEMP_TABLE  ttDimMensagem
&scoped-define ARQUIVO_TXT DimMotivoDev

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
define temp-table ttdimmensagem no-undo
   field CD_Motivo_Dev    like mensagem.cod-mensagem
   field TX_Motivo_Dev    like mensagem.descricao
   index idx_pri is primary unique CD_Motivo_Dev.

for each mensagem NO-LOCK:

   create ttdimmensagem.
   assign ttdimmensagem.CD_Motivo_Dev = mensagem.cod-mensagem
          ttdimmensagem.TX_Motivo_Dev = mensagem.descricao.

end.

run createTxt(input buffer {&TEMP_TABLE}:handle, "{&ARQUIVO_TXT}").
