/**
 * Extrator para BI
 * DimensÆo: Tipo Ocorrˆncia de Transporte (TMS)
 *
 * Autor: Hoepers - Exponencial TI
 */

create widget-pool.

&scoped-define TEMP_TABLE  ttTipoOcorrencia
&scoped-define ARQUIVO_TXT DimTipoOcorrencia

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
define temp-table ttTipoOcorrencia no-undo
   field CD_Tipo_Ocorrencia  AS INT FORMAT ">>>>9"
   field CD_Penalizar          AS INTEGER
   field TX_Tipo_Ocorrencia  AS CHAR FORMAT "x(40)"
   index idx_pri is primary unique CD_Tipo_Ocorrencia.

/* TMS for each  mgtrp.tipo-ocorrencia no-lock:
   CREATE ttTipoOcorrencia.
   ASSIGN ttTipoOcorrencia.CD_Tipo_Ocorrencia = mgtrp.tipo-ocorrencia.cd-tipo   
          ttTipoOcorrencia.TX_Tipo_Ocorrencia = mgtrp.tipo-ocorrencia.ds-tp-ocor.

   IF  mgtrp.tipo-ocorrencia.ds-tp-ocor BEGINS "Erro" OR
       mgtrp.tipo-ocorrencia.cd-tipo = 14 /* Fiscaliza‡Æo */
   THEN
       ASSIGN ttTipoOcorrencia.CD_Penalizar = 1.
end.*/

run createTxt(input buffer {&TEMP_TABLE}:handle, "{&ARQUIVO_TXT}").
