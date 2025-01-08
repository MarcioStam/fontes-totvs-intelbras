/*----------------------------------------------------------------------
**  Programa..: esp/crm/escrm099.p
**  Autor.....: Felipe Braun Azambuja
**  Data......: Janeiro/2014 - Desenvolvimento
**  Descricao.: Faturamento anual consolidado - Portal
-----------------------------------------------------------------------*/

create widget-pool.

define temp-table tt-segmentos no-undo xml-node-name 'segmentos'
   field cod_unid_negoc as character
   field segmento       as character
   field ordem          as integer xml-node-type 'hidden'
   index idx_pri is unique cod_unid_negoc segmento
   index idx_ord is primary ordem.

define temp-table tt-faturamento no-undo xml-node-name 'faturamento'
   field periodo        as character
   field cod_unid_negoc as character
   field segmento       as character
   field vl_orcado      as decimal
   field vl_faturado    as decimal
   field perc_atingido  as decimal decimals 3
   field ordem          as integer xml-node-type 'hidden'
   index idx_pri is unique periodo cod_unid_negoc segmento
   index idx_ord is primary ordem.

define dataset faturamentoConsolidado
   for tt-faturamento, tt-segmentos
   data-relation for tt-segmentos, tt-faturamento relation-fields (cod_unid_negoc, cod_unid_negoc, segmento, segmento) nested.

define output parameter dataset for faturamentoConsolidado.

define variable l as longchar no-undo.
define variable i as integer no-undo.
define variable d-vl-cart  as decimal no-undo.
define variable d-total    as decimal no-undo.
DEFINE VARIABLE c-Segmento AS CHARACTER   NO-UNDO.
define buffer b-tt-faturamento for tt-faturamento.

for each faturamento-segmento-ordem no-lock
   break by faturamento-segmento-ordem.unid-neg:

   create tt-segmentos.
   assign tt-segmentos.cod_unid_negoc = faturamento-segmento-ordem.unid-neg
          tt-segmentos.segmento       = faturamento-segmento-ordem.Segmento
          tt-segmentos.ordem          = faturamento-segmento-ordem.ordem.

   if first-of(faturamento-segmento-ordem.unid-neg) then do:
      create tt-segmentos.
      assign tt-segmentos.cod_unid_negoc = faturamento-segmento-ordem.unid-neg
             tt-segmentos.segmento       = ''
             tt-segmentos.ordem          = int(truncate(faturamento-segmento-ordem.ordem / 100, 0) * 100).
   end.
end.

/** TOTAL **/
create tt-segmentos.
assign tt-segmentos.cod_unid_negoc = 'TOTAL'
       tt-segmentos.segmento       = ''
       tt-segmentos.ordem          = 9999.

/** GAMBI **/
for each tt-segmentos no-lock:
   create tt-faturamento.
   assign tt-faturamento.periodo        = string(year(add-interval(today, -1, 'years')), '9999')
          tt-faturamento.cod_unid_negoc = tt-segmentos.cod_unid_negoc
          tt-faturamento.segmento       = tt-segmentos.segmento
          tt-faturamento.ordem          = 0.

   do i = 1 to 12:
      create tt-faturamento.
      assign tt-faturamento.periodo        = string(year(today), '9999') + string(i, '99')
             tt-faturamento.cod_unid_negoc = tt-segmentos.cod_unid_negoc
             tt-faturamento.segmento       = tt-segmentos.segmento
             tt-faturamento.ordem          = i.
   end.

   create tt-faturamento.
   assign tt-faturamento.periodo        = string(year(today), '9999')
          tt-faturamento.cod_unid_negoc = tt-segmentos.cod_unid_negoc
          tt-faturamento.segmento       = tt-segmentos.segmento
          tt-faturamento.ordem          = 14.
   create tt-faturamento.
   assign tt-faturamento.periodo        = string(year(today), '9999') + "A"
          tt-faturamento.cod_unid_negoc = tt-segmentos.cod_unid_negoc
          tt-faturamento.segmento       = tt-segmentos.segmento
          tt-faturamento.ordem          = 13.
end.

for each faturamento no-lock
   where faturamento.periodo begins string(year(add-interval(today, -1, 'years')), '9999')
    AND  faturamento.cod-gr-canais = 0:

   run create-faturamento (input substring(faturamento.periodo, 1, 4),
                           input faturamento.unid-neg,
                           input faturamento.segmento,
                           input faturamento.vl-fat-orc,
                           input faturamento.vl-fat-real).

   run create-faturamento (input substring(faturamento.periodo, 1, 4),
                           input faturamento.unid-neg,
                           input '',
                           input faturamento.vl-fat-orc,
                           input faturamento.vl-fat-real).

   run create-faturamento (input substring(faturamento.periodo, 1, 4),
                           input 'TOTAL',
                           input '',
                           input faturamento.vl-fat-orc,
                           input faturamento.vl-fat-real).
end.

for each faturamento no-lock
   where faturamento.periodo begins string(year(today), '9999')
     and faturamento.periodo <= string(year(today), '9999') + string(month(today), '99')
     AND  faturamento.cod-gr-canais = 0 :
   
   if (string(month(today), '99') = substring(faturamento.periodo, 5, 2)) then
      assign d-vl-cart = faturamento.vl-cart.
   else
      assign d-vl-cart = 0.

   /* ACUMULADO ANUAL ATê O MES ANTERIOR */


   if (string(month(today), '99') <> substring(faturamento.periodo, 5, 2)) THEN DO:
       run create-faturamento (input substring(faturamento.periodo, 1, 4) + "A",
                               input faturamento.unid-neg,
                               input faturamento.segmento,
                               input faturamento.vl-fat-orc,
                               input faturamento.vl-fat-real + d-vl-cart).
    
       run create-faturamento (input substring(faturamento.periodo, 1, 4) + "A",
                               input faturamento.unid-neg,
                               input '',
                               input faturamento.vl-fat-orc,
                               input faturamento.vl-fat-real + d-vl-cart).
    
       run create-faturamento (input substring(faturamento.periodo, 1, 4) + "A",
                               input 'TOTAL',
                               input '',
                               input faturamento.vl-fat-orc,
                               input faturamento.vl-fat-real + d-vl-cart).

    END.

   /* ACUMULADO ANO ATUAL */

   run create-faturamento (input substring(faturamento.periodo, 1, 4),
                           input faturamento.unid-neg,
                           input faturamento.segmento,
                           input faturamento.vl-fat-orc,
                           input faturamento.vl-fat-real + d-vl-cart).

   run create-faturamento (input substring(faturamento.periodo, 1, 4),
                           input faturamento.unid-neg,
                           input '',
                           input faturamento.vl-fat-orc,
                           input faturamento.vl-fat-real + d-vl-cart).

   run create-faturamento (input substring(faturamento.periodo, 1, 4),
                           input 'TOTAL',
                           input '',
                           input faturamento.vl-fat-orc,
                           input faturamento.vl-fat-real + d-vl-cart).
   

   /* ACUMULADO MES A MES */

   run create-faturamento (input faturamento.periodo,
                           input faturamento.unid-neg,
                           input faturamento.segmento,
                           input faturamento.vl-fat-orc,
                           input faturamento.vl-fat-real + d-vl-cart).
   
   run create-faturamento (input faturamento.periodo,
                           input faturamento.unid-neg,
                           input '',
                           input faturamento.vl-fat-orc,
                           input faturamento.vl-fat-real + d-vl-cart).
   
   run create-faturamento (input faturamento.periodo,
                           input 'TOTAL',
                           input '',
                           input faturamento.vl-fat-orc,
                           input faturamento.vl-fat-real + d-vl-cart).
end.

/** Eliminar segmentos cuja linha esteja COMPLETAMENTE vazia **/
/** Pra colocar a exportaá∆o separada com segmentos e n∆o ficar uma tabela gigantesca **/
for each tt-segmentos exclusive-lock:
   assign d-total = 0.

   for each tt-faturamento of tt-segmentos no-lock:
      assign d-total = d-total + tt-faturamento.vl_orcado + abs(tt-faturamento.vl_faturado).
   end.

   if d-total = 0 then do:
      for each tt-faturamento of tt-segmentos:
         delete tt-faturamento.
      end.

      delete tt-segmentos.
   end.
end.

procedure create-faturamento:
   define input parameter pPeriodo     as character   no-undo.
   define input parameter pUnidade     as character   no-undo.
   define input parameter pSegmento    as character   no-undo.
   define input parameter pVlOrcado    as decimal     no-undo.
   define input parameter pVlFaturado  as decimal     no-undo.

/*    log-manager:write-message("create faturamento 1 " + pPeriodo   + ' ' + pUnidade  + ' ' + pSegmento + ' ' + STRING(pVlOrcado) + ' ' + STRING(pVlFaturado)).  */

   if pSegmento begins 'Partes e Pecas' then do:
      if pUnidade = 'ICORP' then
         assign pSegmento = "Pequenas e Medias centrais".
      else if pUnidade = 'ICON' then
         assign pSegmento = "Telefone sem fio".
      else if pUnidade = 'ISEC' then
         assign pSegmento = "Gerenciamento de imagem".
      else if pUnidade = 'INET' then
         assign pSegmento = "Banda larga sem fio".
      else if pUnidade = 'IFIRE' then
         assign pSegmento = "Alarme de Incàndio". 
      else if pUnidade = 'ISEC/MG' then
         assign pSegmento = "Alarmes".
      else if pUnidade = 'IAUT' then
         assign pSegmento = "Fechadura".
      else IF pUnidade = 'IACCS' then
         assign pSegmento = "Conversores e Perifericos".
      /* Alterado em 31/01/2014 - adicionado IFIRE solicitado pela usu†ria Juliana (Controladoria) */
   end.
   /** Chamado 61441 **/
   if pSegmento = "Redes Wireless Indoor" or pSegmento = "Banda larga sem fio" then
      assign pSegmento = "Redes Wireless PRO".

/*    log-manager:write-message("create faturamento 2 " + pPeriodo   + ' ' + pUnidade  + ' ' + pSegmento + ' ' + STRING(pVlOrcado) + ' ' + STRING(pVlFaturado)).  */

   /** N∆o estava considerando Partes e Pecas quando o can-find estava nos for each anteriores **/
   if pSegmento <> '' and not can-find (first faturamento-segmento-ordem
                                        where faturamento-segmento-ordem.unid-neg = pUnidade
                                          and faturamento-segmento-ordem.segmento = pSegmento) then
      return.

/*    log-manager:write-message("create faturamento 3 " + pPeriodo   + ' ' + pUnidade  + ' ' + pSegmento + ' ' + STRING(pVlOrcado) + ' ' + STRING(pVlFaturado)).                                                                              */
/*    log-manager:write-message("create faturamento 3a " + pPeriodo   + ' ' + pUnidade  + ' ' + pSegmento + ' ' + STRING(tt-faturamento.vl_orcado) + ' ' + STRING(tt-faturamento.vl_faturado) + ' ' + STRING(tt-faturamento.perc_atingido)).  */

   find tt-faturamento
      where tt-faturamento.periodo        = pPeriodo
        and tt-faturamento.cod_unid_negoc = pUnidade
        and tt-faturamento.segmento       = pSegmento no-error.

   assign tt-faturamento.vl_orcado      = tt-faturamento.vl_orcado + pVlOrcado
          tt-faturamento.vl_faturado    = tt-faturamento.vl_faturado + pVlFaturado
          tt-faturamento.perc_atingido  = (if tt-faturamento.vl_orcado = 0 then 0 else tt-faturamento.vl_faturado / tt-faturamento.vl_orcado).

/*    log-manager:write-message("create faturamento 4 " + pPeriodo   + ' ' + pUnidade  + ' ' + pSegmento + ' ' + STRING(pVlOrcado) + ' ' + STRING(pVlFaturado)).                                                                              */
/*    log-manager:write-message("create faturamento 4a " + pPeriodo   + ' ' + pUnidade  + ' ' + pSegmento + ' ' + STRING(tt-faturamento.vl_orcado) + ' ' + STRING(tt-faturamento.vl_faturado) + ' ' + STRING(tt-faturamento.perc_atingido)).  */

end procedure.
