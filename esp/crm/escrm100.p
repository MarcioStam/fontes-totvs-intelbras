/*----------------------------------------------------------------------
**  Programa..: esp/crm/escrm100.p
**  Autor.....: Felipe Braun Azambuja
**  Data......: Outubro/2010 - Desenvolvimento
**  Descricao.: Faturamento consolidado - B2B/CRM
-----------------------------------------------------------------------*/

create widget-pool.

define temp-table tt-faturamento-mensal no-undo
   field ordem          as integer
   field mercado        as character
   field unid-neg       like faturamento.unid-neg
   field segmento       like item.fm-cod-com
   field periodo-2      as character
   field vl-fat-orc-2   like faturamento.vl-fat-orc
   field vl-fat-real-2  like faturamento.vl-fat-real
   field periodo-1      as character
   field vl-fat-orc-1   like faturamento.vl-fat-orc
   field vl-fat-real-1  like faturamento.vl-fat-real
   field periodo-0      as character
   field vl-fat-orc-0   like faturamento.vl-fat-orc
   field vl-periodo-ant like faturamento.vl-fat-real
   field vl-fat-real-0  like faturamento.vl-fat-real
   field vl-cart        like faturamento.vl-cart
   field vl-pendente    like faturamento.vl-pendente
   index idx_pri is primary unique ordem mercado unid-neg segmento.

define input  parameter pMercado as character no-undo.
define output parameter table for tt-faturamento-mensal.

define buffer b-tt-faturamento-mensal for tt-faturamento-mensal.
define buffer b-faturamento for faturamento.

define variable dt-inicial    as date        no-undo.
define variable dt-final      as date        no-undo.
define variable dt-anterior   as date        no-undo.
define variable periodo-ini   as character   no-undo.
define variable periodo-fim   as character   no-undo.
define variable periodo-ant   as character   no-undo.
define variable i-ordem       as integer     no-undo.
define variable c-segmento    as character   no-undo.
define variable c-unid-neg    as character   no-undo.

assign dt-final    = date(month(today), 1, year(today))
       dt-inicial  = add-interval(dt-final, -2, 'months')
       dt-anterior = add-interval(dt-final, -1, 'years')
       periodo-ini = string(year(dt-inicial), '9999') + string(month(dt-inicial), '99')
       periodo-fim = string(year(dt-final), '9999') + string(month(dt-final), '99')
       periodo-ant = string(year(dt-anterior), '9999') + string(month(dt-anterior), '99').

for each faturamento no-lock
   where faturamento.periodo >= periodo-ini
     and faturamento.periodo <= periodo-fim
     and faturamento.mercado  = pMercado:

    IF faturamento.cod-gr-canais <> 0 THEN NEXT.

    
   /* Alterado em 31/01/2014 - modificado o bloco do segmento e adicionado 
      IFIRE solicitado pela usu ria Juliana (Controladoria)                */
   assign c-unid-neg = faturamento.unid-neg
          c-segmento = faturamento.segmento.
   
   if faturamento.segmento begins 'Partes e Pecas' then do:
      if faturamento.unid-neg = 'ICORP' then
         assign c-segmento = "Pequenas e Medias centrais".
      else if faturamento.unid-neg = 'ICON' then
         assign c-segmento = "Telefone sem fio".
      else if faturamento.unid-neg = 'ISEC' then
         assign c-segmento = "Gerenciamento de imagem".
      else if faturamento.unid-neg = 'INET' then
         assign c-segmento = "Banda larga sem fio".
      else if faturamento.unid-neg = 'IFIRE' then
         assign c-segmento = "Alarme de Incˆndio".
      else if faturamento.unid-neg = 'ISEC/MG' then
         assign c-segmento = "Alarmes".
      else if faturamento.unid-neg = 'IAUT' then
         assign c-segmento = "Fechadura".
      else if faturamento.unid-neg = 'IACCS' then
         assign c-segmento = "Conversores e Perifericos".
   end.
   /** Chamado 61441 - Voltado o if **/
   if c-segmento = "Redes Wireless Indoor" or c-segmento = "Banda larga sem fio" then do:
      assign c-segmento = "Redes Wireless PRO".
   end.

   find faturamento-segmento-ordem no-lock
      where faturamento-segmento-ordem.unid-neg = c-unid-neg
        and faturamento-segmento-ordem.segmento = c-segmento no-error.
   if not avail faturamento-segmento-ordem then
       assign c-segmento = "NAO CLASSIFICADO".

   run create-faturamento(input faturamento.mercado, input c-unid-neg, input c-segmento, input rowid(faturamento)).
   run create-faturamento(input faturamento.mercado, input faturamento.unid-neg, input '', input rowid(faturamento)).
end.

for each tt-faturamento-mensal exclusive-lock
   where tt-faturamento-mensal.unid-neg <> 'TOTAL'
     and tt-faturamento-mensal.segmento = '':

   /** Redutor de carteira **/
   if tt-faturamento-mensal.mercado = 'Interno' then do:
      find redutor-carteira no-lock
         where redutor-carteira.da-data-validade = today
           and redutor-carteira.unid-neg         = tt-faturamento-mensal.unid-neg no-error.
   
      if not available redutor-carteira then
         find last redutor-carteira no-lock
            where redutor-carteira.unid-neg = tt-faturamento-mensal.unid-neg no-error.
   
      if available redutor-carteira then
         assign tt-faturamento-mensal.vl-cart     = tt-faturamento-mensal.vl-cart - redutor-carteira.vlr-redutor
                tt-faturamento-mensal.vl-pendente = tt-faturamento-mensal.vl-pendente + redutor-carteira.vlr-redutor.
   end.
   
   find b-tt-faturamento-mensal
      where b-tt-faturamento-mensal.mercado  = tt-faturamento-mensal.mercado
        and b-tt-faturamento-mensal.unid-neg = 'TOTAL'
        and b-tt-faturamento-mensal.segmento = '' no-error.

   if not available b-tt-faturamento-mensal then do:
      create b-tt-faturamento-mensal.
      assign b-tt-faturamento-mensal.mercado  = tt-faturamento-mensal.mercado
             b-tt-faturamento-mensal.unid-neg = 'TOTAL'
             b-tt-faturamento-mensal.segmento = ''
             b-tt-faturamento-mensal.ordem    = 9999.
   end.

   assign b-tt-faturamento-mensal.vl-fat-orc-2 = b-tt-faturamento-mensal.vl-fat-orc-2 + tt-faturamento-mensal.vl-fat-orc-2
          b-tt-faturamento-mensal.vl-fat-orc-1 = b-tt-faturamento-mensal.vl-fat-orc-1 + tt-faturamento-mensal.vl-fat-orc-1
          b-tt-faturamento-mensal.vl-fat-orc-0 = b-tt-faturamento-mensal.vl-fat-orc-0 + tt-faturamento-mensal.vl-fat-orc-0
          b-tt-faturamento-mensal.vl-fat-real-2 = b-tt-faturamento-mensal.vl-fat-real-2 + tt-faturamento-mensal.vl-fat-real-2
          b-tt-faturamento-mensal.vl-fat-real-1 = b-tt-faturamento-mensal.vl-fat-real-1 + tt-faturamento-mensal.vl-fat-real-1
          b-tt-faturamento-mensal.vl-fat-real-0 = b-tt-faturamento-mensal.vl-fat-real-0 + tt-faturamento-mensal.vl-fat-real-0
          b-tt-faturamento-mensal.vl-cart = b-tt-faturamento-mensal.vl-cart + tt-faturamento-mensal.vl-cart
          b-tt-faturamento-mensal.vl-pendente = b-tt-faturamento-mensal.vl-pendente + tt-faturamento-mensal.vl-pendente
          b-tt-faturamento-mensal.vl-periodo-ant = b-tt-faturamento-mensal.vl-periodo-ant + tt-faturamento-mensal.vl-periodo-ant.
end.

if can-find (first tt-faturamento-mensal) then
   return 'ok'.
else
   return 'nok'.

procedure create-faturamento:
   define input parameter c-mercado  like faturamento.mercado no-undo.
   define input parameter c-unid-neg like faturamento.unid-neg no-undo.
   define input parameter c-segmento like faturamento.segmento no-undo.
   define input parameter r-rowid as rowid no-undo.

   find faturamento no-lock
      where rowid(faturamento) = r-rowid.


   find tt-faturamento-mensal
      where tt-faturamento-mensal.mercado  = c-mercado
        and tt-faturamento-mensal.unid-neg = c-unid-neg
        and tt-faturamento-mensal.segmento = c-segmento no-error.

   if not available tt-faturamento-mensal then do:
      assign i-ordem = 0.

      if (c-segmento <> '') then do:
         find faturamento-segmento-ordem no-lock
            where faturamento-segmento-ordem.unid-neg = c-unid-neg
              and faturamento-segmento-ordem.segmento = c-segmento no-error.
         if available faturamento-segmento-ordem then
            assign i-ordem = faturamento-segmento-ordem.ordem.
         else
            assign i-ordem = 0.
      end.
      else do:
         find first faturamento-segmento-ordem no-lock
            where faturamento-segmento-ordem.unid-neg = c-unid-neg no-error.
         if available faturamento-segmento-ordem then
            assign i-ordem = int(truncate(faturamento-segmento-ordem.ordem / 100, 0) * 100).
      end.

      if i-ordem = 0 then
         next.

      create tt-faturamento-mensal.
      assign tt-faturamento-mensal.mercado  = c-mercado
             tt-faturamento-mensal.unid-neg = c-unid-neg
             tt-faturamento-mensal.segmento = c-segmento
             tt-faturamento-mensal.ordem    = i-ordem.
   end.

   if faturamento.periodo = periodo-ini then
      assign tt-faturamento-mensal.periodo-2     = faturamento.periodo
             tt-faturamento-mensal.vl-fat-orc-2  = tt-faturamento-mensal.vl-fat-orc-2 + faturamento.vl-fat-orc
             tt-faturamento-mensal.vl-fat-real-2 = tt-faturamento-mensal.vl-fat-real-2 + faturamento.vl-fat-real.
   else if faturamento.periodo = periodo-fim then do:
      assign tt-faturamento-mensal.periodo-0     = faturamento.periodo
             tt-faturamento-mensal.vl-fat-orc-0  = tt-faturamento-mensal.vl-fat-orc-0 + faturamento.vl-fat-orc
             tt-faturamento-mensal.vl-fat-real-0 = tt-faturamento-mensal.vl-fat-real-0 + faturamento.vl-fat-real
             tt-faturamento-mensal.vl-cart       = tt-faturamento-mensal.vl-cart + faturamento.vl-cart
             tt-faturamento-mensal.vl-pendente   = tt-faturamento-mensal.vl-pendente + faturamento.vl-pendente.

      find b-faturamento no-lock
         where b-faturamento.periodo = periodo-ant
           and b-faturamento.unid-neg = faturamento.unid-neg
           and b-faturamento.segmento = faturamento.segmento no-error.
   
      if available b-faturamento then
         assign tt-faturamento-mensal.vl-periodo-ant = tt-faturamento-mensal.vl-periodo-ant + b-faturamento.vl-fat-real.
   end.
   else
      assign tt-faturamento-mensal.periodo-1     = faturamento.periodo
             tt-faturamento-mensal.vl-fat-orc-1  = tt-faturamento-mensal.vl-fat-orc-1 + faturamento.vl-fat-orc
             tt-faturamento-mensal.vl-fat-real-1 = tt-faturamento-mensal.vl-fat-real-1 + faturamento.vl-fat-real.

end procedure.
