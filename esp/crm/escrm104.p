/*----------------------------------------------------------------------
**  Programa..: esp/crm/escrm104.p
**  Autor.....: Felipe Braun Azambuja
**  Data......: Outubro/2010 - Desenvolvimento
**  Descricao.: Lista notas por emitente - B2B/CRM
-----------------------------------------------------------------------*/

create widget-pool.

define temp-table tt-notas no-undo
   field cod-estabel       like nota-fiscal.cod-estabel
   field serie             like nota-fiscal.serie
   FIELD nr-pedido         LIKE nota-fiscal.nr-pedCli
   field nr-nota-fis       like nota-fiscal.nr-nota-fis
   field dt-emis-nota      like nota-fiscal.dt-emis-nota
   field vl-merc-tot-fat   like nota-fiscal.vl-merc-tot-fat
   field vl-tot-nota       like nota-fiscal.vl-tot-nota
   index idx_pri is primary unique cod-estabel serie nr-nota-fis.

define input  parameter pcod-estabel   as character   no-undo.
define input  parameter pcod-rep       as integer     no-undo.
define input  parameter pcod-emitente  as integer     no-undo.
define input  parameter pdt-inicial    as date        no-undo.
define input  parameter pdt-final      as date        no-undo.

define output parameter table for tt-notas.

define variable dt-data    as date     no-undo.
DEFINE VARIABLE c-cod-estab-aux AS CHARACTER NO-UNDO.

ASSIGN c-cod-estab-aux = pcod-estabel.

IF pcod-estabel = "101" OR pcod-estabel = "104" THEN
    ASSIGN c-cod-estab-aux = IF pcod-estabel = "101" THEN "104" ELSE "101".

/** Faturamento **/
do dt-data = pdt-inicial to pdt-final:
   for each nota-fiscal USE-INDEX nfftrm-20 no-lock
      where nota-fiscal.dt-emis-nota = dt-data
        and (nota-fiscal.cod-estabel  = pcod-estabel OR
             nota-fiscal.cod-estabel  = c-cod-estab-aux)
        and nota-fiscal.dt-cancel    = ?
        and nota-fiscal.cod-rep      = pcod-rep
        and nota-fiscal.cod-emitente = pcod-emitente,
      first natur-oper no-lock
         where natur-oper.nat-operacao = nota-fiscal.nat-operacao
           and natur-oper.atual-estat:

      create tt-notas.
      assign tt-notas.cod-estabel     = nota-fiscal.cod-estabel
             tt-notas.serie           = nota-fiscal.serie
             tt-notas.nr-pedido       = nota-fiscal.nr-pedCli
             tt-notas.nr-nota-fis     = nota-fiscal.nr-nota-fis
             tt-notas.dt-emis-nota    = nota-fiscal.dt-emis-nota
             tt-notas.vl-merc-tot-fat = nota-fiscal.vl-merc-tot-fat
             tt-notas.vl-tot-nota     = nota-fiscal.vl-tot-nota.
   end.
end.


if can-find (first tt-notas) then
   return 'ok'.
else
   return 'nok'.
