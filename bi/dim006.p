/**
 * Extrator para BI
 * Dimens∆o: Atendente
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
define temp-table ttDimAtendente no-undo
   field CD_Atendente like atendente.cd-oper
   field TX_Atendente like atendente.nm-oper
   field CD_Considera_Consolidado as integer
   index idx_pri is primary unique CD_Atendente.

for each atendente no-lock:
   create ttDimAtendente.
   assign ttDimAtendente.CD_Atendente             = atendente.cd-oper
          ttDimAtendente.TX_Atendente             = atendente.nm-oper
          ttDimAtendente.CD_Considera_Consolidado = (if atendente.ind-considera-acesso-restrito then 1 else 0).
end.

create ttDimAtendente.
assign ttDimAtendente.CD_Atendente             = 0
       ttDimAtendente.TX_Atendente             = 'NAO INFORMADO'
       ttDimAtendente.CD_Considera_Consolidado = 0.

run createTxt(input buffer ttDimAtendente:handle, "DimAtendente").
