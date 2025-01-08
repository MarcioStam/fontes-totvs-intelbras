/*----------------------------------------------------------------------
**  Programa..: esp/crm/escrm105.p
**  Autor.....: Felipe Braun Azambuja
**  Data......: Outubro/2010 - Desenvolvimento
**  Descricao.: Ranking por estabelecimento - B2B/CRM
-----------------------------------------------------------------------*/

create widget-pool.

/*
define temp-table tt-unid-neg no-undo
   field cod-estabel    like nota-fiscal.cod-estabel
   field cod_unid_negoc like unid-neg-fat.cod_unid_negoc
   field des_unid_negoc like unid_negoc.des_unid_negoc
   index idx_pri is primary unique cod-estabel cod_unid_negoc.
*/

define temp-table tt-ranking no-undo
   field cod-estabel    like nota-fiscal.cod-estabel
   field cod_unid_negoc like unid-neg-fat.cod_unid_negoc
   field des_unid_negoc like unid_negoc.des_unid_negoc
   field cod-rep        like repres.cod-rep
   field nome-abrev     like repres.nome-abrev
   field perc           as decimal
   field vl-cota        as decimal
   field vl-faturado    as decimal
   field vl-devolvido   as decimal
   index idx_uni is unique cod-estabel cod_unid_negoc cod-rep
   index idx_pri is primary cod-estabel cod_unid_negoc perc desc.


define input  parameter pcod-estabel   as character   no-undo.
define input  parameter pperiodo       as character   no-undo.
/*DEFINE OUTPUT PARAMETER TABLE FOR tt-unid-neg.*/
DEFINE OUTPUT PARAMETER TABLE FOR tt-ranking.

define variable dt-inicial as date     no-undo.
define variable dt-final   as date     no-undo.
define variable dt-data    as date     no-undo.
define variable i-cont     as integer  no-undo.
define variable i-cod-rep  as integer  no-undo.
DEFINE VARIABLE c-cod-unid-negoc AS CHARACTER   NO-UNDO.

assign dt-inicial = date(integer(substring(pperiodo, 5, 2)), 1, integer(substring(pperiodo, 1, 4)))
       dt-final   = add-interval(dt-inicial, 1, 'months') - 1.


/** Leitura dos dados e cria‡Æo da temp-table principal **/
for each meta-rep no-lock
   where meta-rep.cod-estabel = pcod-estabel
     and meta-rep.periodo     = pperiodo,     
   first repres no-lock
      where repres.cod-rep = meta-rep.cod-rep:

    IF meta-rep.valor <= 0 THEN NEXT.

   find tt-ranking
      where tt-ranking.cod-estabel    = meta-rep.cod-estabel
        and tt-ranking.cod_unid_negoc = meta-rep.cod-diretoria
        and tt-ranking.cod-rep        = meta-rep.cod-rep no-error.
 
   if not available (tt-ranking) then do:
      create tt-ranking.
      assign tt-ranking.cod-estabel    = meta-rep.cod-estabel
             tt-ranking.cod_unid_negoc = meta-rep.cod-diretoria
             tt-ranking.cod-rep        = meta-rep.cod-rep
             tt-ranking.nome-abrev     = repres.nome-abrev.

      find unid_negoc no-lock
         where unid_negoc.cod_unid_negoc = tt-ranking.cod_unid_negoc no-error.
      assign tt-ranking.des_unid_negoc = (if avail unid_negoc then unid_negoc.des_unid_negoc else "").
   end.
 
   assign tt-ranking.vl-cota = tt-ranking.vl-cota + meta-rep.valor.
end.



/** Faturamento **/
do dt-data = dt-inicial to dt-final:
   for each nota-fiscal FIELDS(dt-emis-nota dt-cancel cod-estabel nat-operacao cod-rep) NO-LOCK USE-INDEX ch-distancia
      where nota-fiscal.dt-emis-nota = dt-data
        and nota-fiscal.dt-cancel    = ?
        and nota-fiscal.cod-estabel  = pcod-estabel,
      first natur-oper no-lock
         where natur-oper.nat-operacao = nota-fiscal.nat-operacao
           and natur-oper.atual-estat,
      each it-nota-fisc of nota-fiscal no-lock:

      FIND FIRST item-uni-estab
          WHERE item-uni-estab.it-codigo   = it-nota-fisc.it-codigo
            AND item-uni-estab.cod-estabel = nota-fiscal.cod-estabel NO-LOCK NO-ERROR.

      ASSIGN c-cod-unid-negoc = IF AVAILABLE item-uni-estab THEN item-uni-estab.cod-unid-negoc ELSE "INV":U.

      find tt-ranking
          where tt-ranking.cod-estabel    = nota-fiscal.cod-estabel
            and tt-ranking.cod_unid_negoc = c-cod-unid-negoc
            and tt-ranking.cod-rep        = nota-fiscal.cod-rep no-error.
      if not available (tt-ranking) then do:
          create tt-ranking.
          assign tt-ranking.cod-estabel    = nota-fiscal.cod-estabel
                 tt-ranking.cod_unid_negoc = c-cod-unid-negoc
                 tt-ranking.cod-rep        = nota-fiscal.cod-rep.
      end.

      assign tt-ranking.vl-faturado = tt-ranking.vl-faturado + it-nota-fisc.vl-merc-liq.
   end.
end.



/** Devolu‡Æo **/
for each devol-cli no-lock
   where devol-cli.cod-estabel = pcod-estabel
     and devol-cli.dt-devol   >= dt-inicial
     and devol-cli.dt-devol   <= dt-final,
   first nota-fiscal FIELDS(cod-estabel serie nr-nota-fis cod-rep) no-lock
      where nota-fiscal.cod-estabel = devol-cli.cod-estabel
        and nota-fiscal.serie       = devol-cli.serie
        and nota-fiscal.nr-nota-fis = devol-cli.nr-nota-fis,
   each item-doc-est of devol-cli no-lock,
   first it-nota-fisc no-lock
      where it-nota-fisc.cod-estabel = devol-cli.cod-estabel
        and it-nota-fisc.serie       = devol-cli.serie
        and it-nota-fisc.nr-nota-fis = devol-cli.nr-nota-fis
        and it-nota-fisc.it-codigo   = devol-cli.it-codigo
        and it-nota-fisc.nr-seq-fat  = devol-cli.nr-sequencia,
   first natur-oper no-lock
      where natur-oper.nat-operacao = it-nota-fisc.nat-operacao
        and natur-oper.atual-estat:

   FIND FIRST item-uni-estab
       WHERE item-uni-estab.it-codigo   = devol-cli.it-codigo
         AND item-uni-estab.cod-estabel = devol-cli.cod-estabel NO-LOCK NO-ERROR.

   ASSIGN c-cod-unid-negoc = IF AVAILABLE item-uni-estab THEN item-uni-estab.cod-unid-negoc ELSE "INV":U.

    find tt-ranking
        where tt-ranking.cod-estabel    = nota-fiscal.cod-estabel
          and tt-ranking.cod_unid_negoc = c-cod-unid-negoc
          and tt-ranking.cod-rep        = nota-fiscal.cod-rep no-error.
    if not available (tt-ranking) then do:
        create tt-ranking.
        assign tt-ranking.cod-estabel    = nota-fiscal.cod-estabel
               tt-ranking.cod_unid_negoc = c-cod-unid-negoc
               tt-ranking.cod-rep        = nota-fiscal.cod-rep.
    end.

    assign tt-ranking.vl-devolvido = tt-ranking.vl-devolvido + item-doc-est.preco-total[1].
end.



/** Acertando as outras temp-tables **/
for each tt-ranking:

    /* Somente Representante com Metas */
    IF tt-ranking.vl-cota <= 0 THEN DO:
        DELETE tt-ranking.
        NEXT.
    END.

    find unid_negoc no-lock
        where unid_negoc.cod_unid_negoc = tt-ranking.cod_unid_negoc no-error.
    assign tt-ranking.des_unid_negoc = (if avail unid_negoc then unid_negoc.des_unid_negoc else "").

    find first repres no-lock
        where  repres.cod-rep = tt-ranking.cod-rep no-error.
    assign tt-ranking.nome-abrev = if avail repres then repres.nome-abrev else "".
   
   if  tt-ranking.vl-cota > 0 then
       assign tt-ranking.perc = ((tt-ranking.vl-faturado - tt-ranking.vl-devolvido) / tt-ranking.vl-cota) * 100.
end.


if can-find (first tt-ranking) then
   return 'ok'.
else
   return 'nok'.
