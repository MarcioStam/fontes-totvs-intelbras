/**
 * Extrator para BI
 * Dimens∆o: Tipo Conhecimento de Transporte (TMS)
 *
 * Autor: Hoepers - Exponencial TI
 */

create widget-pool.

&scoped-define TEMP_TABLE  ttMoeda
&scoped-define ARQUIVO_TXT DimMoeda

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
define temp-table ttMoeda no-undo
   FIELD CD_Moeda  LIKE moeda.mo-codigo
   field TX_Moeda  LIKE moeda.descricao
   index idx_pri is primary unique CD_Moeda.

FOR EACH moeda NO-LOCK:
    CREATE ttMoeda.
    ASSIGN ttMoeda.CD_Moeda = moeda.mo-codigo
           ttMoeda.TX_Moeda = moeda.descricao.
END.

run createTxt(input buffer {&TEMP_TABLE}:handle, "{&ARQUIVO_TXT}").
