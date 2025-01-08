/*----------------------------------------------------------------------
**  Programa..: esp/crm/escrm103.p
**  Autor.....: Felipe Braun Azambuja
**  Data......: Outubro/2010 - Desenvolvimento
**  Descricao.: Relat¢rio carteira do cliente - B2B/CRM
-----------------------------------------------------------------------*/

create widget-pool.

define temp-table tt-saldo-carteira no-undo
   field nr-pedcli      like ped-venda.nr-pedcli
   field nr-sequencia   like ped-item.nr-sequencia
   field it-codigo      like item.it-codigo
   field desc-item      like item.desc-item
   field qt-saldo       as decimal
   field vl-carteira    as decimal
   index idx_pri is primary unique nr-pedcli nr-sequencia.

/* define temp-table tt-unid no-undo                           */
/*        field cod_unid_negoc LIKE unid_negoc.cod_unid_negoc  */
/*        field des_unid_negoc  like unid_negoc.des_unid_negoc */
/*        index ch-cod is primary unique cod_unid_negoc.       */

/** Parƒmetros **/
define input  parameter pcod-estabel    as character   no-undo.
define input  parameter pcod-rep        as integer     no-undo.
define input  parameter pcod-emitente   as integer     no-undo.
DEFINE INPUT  PARAMETER pdes-unid-negoc AS CHAR       NO-UNDO.
define input  parameter pdt-inicial     as date        no-undo.
define input  parameter pdt-final       as date        no-undo.

define output parameter table for tt-saldo-carteira.

define variable i-cont     as integer  no-undo.
define variable dt-fim-mes as date     no-undo.
define variable d-cotacao  as decimal  no-undo.
DEFINE VARIABLE dt-inicial-aux  AS DATE        NO-UNDO.

FIND FIRST unid_negoc
    WHERE unid_negoc.des_unid_negoc = pdes-unid-negoc NO-LOCK NO-ERROR.

IF NOT AVAILABLE unid_negoc THEN
    RETURN "NOK":U.

assign dt-fim-mes = today - 1
       dt-fim-mes = date(month(dt-fim-mes), 1, year(dt-fim-mes))
       dt-fim-mes = add-interval(dt-fim-mes, 1, 'months') - 1.

/* Se Pesquisar por mes atual ou anterior busca os pedidos anteriores */
IF MONTH(pdt-final) <= MONTH(TODAY) AND YEAR(pdt-final) <= YEAR(TODAY) THEN
    ASSIGN dt-inicial-aux = 01/01/1900.
ELSE 
    ASSIGN dt-inicial-aux = pdt-inicial.

/** Leitura dos dados e cria‡Æo da temp-table principal **/
/** Carteira **/
for each ped-venda no-lock
    WHERE ped-venda.cod-emitente = pcod-emitente
      AND ped-venda.cod-sit-ped <= 5
      AND ped-venda.cod-priori  <> 44,
   first repres no-lock
      where repres.nome-abrev = ped-venda.no-ab-reppri
        and repres.cod-rep    = pcod-rep,
   first natur-oper no-lock
      where natur-oper.nat-operacao = ped-venda.nat-operacao
        and natur-oper.atual-estat,
   each ped-item of ped-venda no-lock
      where ped-item.dt-entrega   >= dt-inicial-aux
        and ped-item.dt-entrega   <= pdt-final
        and ped-item.ind-componen <> 3,
   first item of ped-item no-lock:

   IF  ped-item.cod-sit-item = 3 OR
       ped-item.cod-sit-item = 6 THEN NEXT.

   /*EMPTY TEMP-TABLE tt-unid.

   FOR EACH unid-neg-ped 
       WHERE unid-neg-ped.nome-abrev   = ped-item.nome-abrev   
         AND unid-neg-ped.nr-pedcli    = ped-item.nr-pedcli    
         AND unid-neg-ped.nr-sequencia = ped-item.nr-sequencia 
         AND unid-neg-ped.it-codigo    = ped-item.it-codigo
         AND unid-neg-ped.cod-refer    = ped-item.cod-refer NO-LOCK:

        FIND FIRST unid_negoc NO-LOCK
             WHERE unid_negoc.cod_unid_negoc = unid-neg-ped.cod_unid_negoc NO-ERROR.

        IF NOT AVAIL unid_negoc THEN NEXT.

        CREATE tt-unid.
        ASSIGN tt-unid.cod_unid_negoc  = unid-neg-ped.cod_unid_negoc
               tt-unid.des_unid_negoc  = unid_negoc.des_unid_negoc.
   END.

   IF NOT CAN-FIND(FIRST tt-unid WHERE
                   tt-unid.des_unid_negoc = pdes-unid-negoc NO-LOCK) THEN NEXT.*/

   FIND FIRST item-uni-estab
       WHERE item-uni-estab.it-codigo   = ped-item.it-codigo
         AND item-uni-estab.cod-estabel = ped-venda.cod-estabel NO-LOCK NO-ERROR.

   IF NOT AVAILABLE item-uni-estab                                    OR
      item-uni-estab.cod-unid-negoc <> unid_negoc.cod_unid_negoc THEN NEXT.

   IF pcod-estabel = "101" OR pcod-estabel = "104" THEN DO:
        IF (ped-venda.cod-estabel <> "101") AND (ped-venda.cod-estabel <> "104") THEN NEXT.
   END.
   ELSE IF (ped-venda.cod-estabel <> pcod-estabel) THEN NEXT.

   /** Ignora or‡amentos Maxcom **/
   if ((ped-venda.cod-estabel = "301" or ped-venda.cod-estabel = '103') and (ped-venda.cod-priori = 99)) or (ped-venda.cod-priori = 44) then
      next.

   find cotacao no-lock
      where cotacao.mo-codigo   = ped-venda.mo-codigo
        and cotacao.ano-periodo = string(year(today), "9999") + string(month(today), "99") no-error.
   if available (cotacao) and (cotacao.cotacao[day(today)] <> 0) then
      assign d-cotacao = cotacao.cotacao[day(today)].
   else
      assign d-cotacao = 1.

   create tt-saldo-carteira.
   assign tt-saldo-carteira.nr-pedcli    = ped-venda.nr-pedcli
          tt-saldo-carteira.nr-sequencia = ped-item.nr-sequencia
          tt-saldo-carteira.it-codigo    = item.it-codigo
          tt-saldo-carteira.desc-item    = item.desc-item
          tt-saldo-carteira.qt-saldo     = ped-item.qt-pedida - ped-item.qt-atendida
          tt-saldo-carteira.vl-carteira  = ped-item.vl-preuni * (ped-item.qt-pedida - ped-item.qt-atendida) * d-cotacao.
end.

/*temp-table tt-saldo-carteira:write-xml('file', 'C:/temp/dsetescrm103.xml', no, 'utf-8', ?, no, no).*/

if can-find (first tt-saldo-carteira) then
   return 'ok'.
else
   return 'nok'.
