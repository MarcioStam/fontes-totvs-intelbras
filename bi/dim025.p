/**
 * Extrator para BI
 * Dimens∆o: Tipo Conhecimento de Transporte (TMS)
 *
 * Autor: Hoepers - Exponencial TI
 */

create widget-pool.

&scoped-define TEMP_TABLE  ttTipoConhecimento
&scoped-define ARQUIVO_TXT DimTipoConhecimento

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
define temp-table ttTipoConhecimento no-undo
   FIELD CD_Tipo_Conhec  AS INT
   field TX_Tipo_Conhec    AS CHAR
   index idx_pri is primary unique CD_Tipo_Conhec.

DEF VAR v-qtd-opcoes AS  INT NO-UNDO.
DEF VAR v-des-opcoes AS CHAR NO-UNDO.

/* TMS ASSIGN v-des-opcoes = {trinc/i02tr017.i 03}.*/

/* TMS IF  v-des-opcoes <> "" 
THEN DO:
    DO v-qtd-opcoes = 1 TO NUM-ENTRIES(v-des-opcoes,","):
        CREATE ttTipoConhecimento.
        ASSIGN ttTipoConhecimento.CD_Tipo_Conhec = v-qtd-opcoes   
               ttTipoConhecimento.TX_Tipo_Conhec = {trinc/i02tr017.i 04 v-qtd-opcoes}.
    END.
END.*/

run createTxt(input buffer {&TEMP_TABLE}:handle, "{&ARQUIVO_TXT}").
