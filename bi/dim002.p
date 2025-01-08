/**
 * Extrator para BI
 * Dimens∆o: Representante
 *
 * Autor: Felipe Braun Azambuja
 */

create widget-pool.

&scoped-define TEMP_TABLE  ttDimRepresentante
&scoped-define ARQUIVO_TXT DimRepresentante

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
define temp-table ttDimRepresentante no-undo
   field CD_Representante  like repres.cod-rep
   field TX_Representante  like repres.nome
   field TX_Nome_Abreviado like repres.nome-abrev
   field CD_CGC            like repres.cgc
   field CD_Ativo          as integer
   field CD_Gerente        like int-repres.cod-gerente
   field TX_Gerente        like gerente.nome
   field TX_Nome_Revisado  like repres.nome-abrev
   index idx_pri is primary unique CD_Representante.

define buffer b-repres for repres.

for each repres no-lock:
   find int-repres no-lock
      where int-repres.cod-rep = repres.cod-rep no-error.
   find gerente no-lock
      where gerente.cod-gerente = int-repres.cod-gerente no-error.
   find first b-repres no-lock
      where b-repres.cgc = repres.cgc no-error.

   if not available gerente then
      find gerente no-lock
         where gerente.cod-gerente = 999 no-error.

   create ttDimRepresentante.
   assign ttDimRepresentante.CD_Representante  = repres.cod-rep
          ttDimRepresentante.TX_Representante  = repres.nome
          ttDimRepresentante.TX_Nome_Abreviado = repres.nome-abrev
          ttDimRepresentante.CD_CGC            = repres.cgc
          ttDimRepresentante.CD_Ativo          = (if repres.dt-deslig = ? then 1 else 0)
          ttDimRepresentante.CD_Gerente        = gerente.cod-gerente
          ttDimRepresentante.TX_Gerente        = gerente.nome
          ttDimRepresentante.TX_Nome_Revisado  = (if repres.cgc = '82901000000127' then repres.nome-abrev else b-repres.nome-abrev).
end.

/** Consertar problema/feature do SQL Server **/
find gerente no-lock
   where gerente.cod-gerente = 999 no-error.

create ttDimRepresentante.
assign ttDimRepresentante.CD_Representante  = 0
       ttDimRepresentante.TX_Representante  = 'NAO INFORMADO'
       ttDimRepresentante.TX_Nome_Abreviado = 'NAO INFORMAD'
       ttDimRepresentante.CD_CGC            = ''
       ttDimRepresentante.CD_Ativo          = 1
       ttDimRepresentante.CD_Gerente        = gerente.cod-gerente
       ttDimRepresentante.TX_Gerente        = gerente.nome
       ttDimRepresentante.TX_Nome_Revisado  = 'NAO INFORMAD'.

run createTxt(input buffer {&TEMP_TABLE}:handle, "{&ARQUIVO_TXT}").
