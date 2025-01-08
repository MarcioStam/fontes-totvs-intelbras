/**
 * Extrator para BI
 * Dimens∆o: Calend†rio
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

define variable dt-inicial as date no-undo.
define variable dt-final   as date no-undo.

if integer(getTag("tipoPeriodo")) = 1 then
   assign dt-inicial = date(getTag("dataInicio"))
          dt-final   = date(getTag("dataTermino")).
else
   assign dt-inicial = today + integer(getTag("intervaloInicio"))
          dt-final   = today + integer(getTag("intervaloTermino")).

/**
 * Regra de neg¢cio a partir daqui
 */
define variable dt-data        as date      no-undo.
define variable c-util         as integer   no-undo.
define variable c-semestre     as character no-undo.
define variable c-trimestre    as character no-undo.
define variable i-trimestre    as integer   no-undo.
define variable c-quadrimestre as character no-undo.
define variable c-tipo         as character no-undo.
define variable c-mes          as character no-undo extent 12 initial
   ['Janeiro','Fevereiro','Maráo','Abril','Maio','Junho',
    'Julho','Agosto','Setembro','Outubro','Novembro','Dezembro'].

define temp-table ttDimPeriodo no-undo
   field DT_Periodo      like dia_calend_glob.dat_calend
   field TX_Ano          as integer
   field TX_Semestre     as character
   field TX_Trimestre    as character
   field CD_Mes          as integer
   field TX_Mes          as character
   field TX_Dia          as integer
   field TX_Tipo_Dia     as character
   field TX_Quadrimestre as character
   field TX_Dia_Util     as integer
   field CD_Trimestre    as integer
   index idx_pri is primary unique DT_Periodo.

/* ê necess†rio extrair sempre comeáando do primeiro dia do màs */
do dt-data = dt-inicial to dt-final:
   find dia_calend_glob no-lock
      where dia_calend_glob.cod_calend = 'FISCAL'
        and dia_calend_glob.dat_calend = dt-data no-error.

   if day(dt-data) = 1 then
       assign c-util = 0.

   if available (dia_calend_glob) then do:
      if (dia_calend_glob.cod_clas_dia_calend = 'Feriado') then
         assign c-tipo = 'Feriado'.
      else if (dia_calend_glob.log_dia_util) then
         assign c-tipo = 'Dia Ètil'.
      else
         assign c-tipo = 'Dia N∆o Ètil'.
   end.
   else do:
      if (weekday(dt-data) = 1) or (weekday(dt-data) = 7) then
         assign c-tipo = 'Dia N∆o Ètil'.
      else
         assign c-tipo = 'Dia Ètil'.
   end.
                                  
   if (month(dt-data) < 4) then
      assign c-semestre  = '1o Semestre'
             i-trimestre = 1
             c-trimestre = '1o Trimestre'.
   else if (month(dt-data) < 7) then
      assign c-semestre  = '1o Semestre'
             i-trimestre = 2
             c-trimestre = '2o Trimestre'.
   else if (month(dt-data) < 10) then
      assign c-semestre  = '2o Semestre'
             i-trimestre = 3
             c-trimestre = '3o Trimestre'.
   else
      assign c-semestre  = '2o Semestre'
             i-trimestre = 4
             c-trimestre = '4o Trimestre'.

   if (month(dt-data) < 5) then
      assign c-quadrimestre = '1o Quadrimestre'.
   else if (month(dt-data) < 9) then
      assign c-quadrimestre = '2o Quadrimestre'.
   else 
      assign c-quadrimestre = '3o Quadrimestre'.

   if c-tipo = 'Dia Ètil' then
      assign c-util = c-util + 1.

   create ttDimPeriodo.
   assign ttDimPeriodo.DT_Periodo      = dt-data
          ttDimPeriodo.TX_Ano          = year(dt-data)
          ttDimPeriodo.TX_Semestre     = c-semestre
          ttDimPeriodo.TX_Trimestre    = c-trimestre
          ttDimPeriodo.CD_Mes          = month(dt-data)
          ttDimPeriodo.TX_Mes          = c-mes[month(dt-data)]
          ttDimPeriodo.TX_Dia          = day(dt-data)
          ttDimPeriodo.TX_Tipo_Dia     = c-tipo
          ttDimPeriodo.TX_Quadrimestre = c-quadrimestre
          ttDimPeriodo.TX_Dia_Util     = c-util
          ttDimPeriodo.CD_Trimestre    = i-trimestre.
end.

run createTxt(input buffer ttDimPeriodo:handle, "DimPeriodo").
