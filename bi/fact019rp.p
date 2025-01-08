/**
 * Extrator para BI
 * Fato: Carteira de Vendas Resumo
 *
 * Autor: Cleto May
 */

create widget-pool.

{include/i-freeac.i}

/** Include com a temp table principal e a temp table de parÉmetros **/
{bi/fact019tt.i}
{bi/esbi000.i}

define input  parameter table for tt-param.
define output parameter table for ttCarteiraVendasResumo.
define output parameter table for tt-erro.

find first tt-param.

define variable dt-final       as date      no-undo.
define variable d-cotacao      as decimal   no-undo.
define variable i-tributacao   as integer   no-undo.
define variable c-frete        as character no-undo.
define variable i-transp       as integer   no-undo.
define variable d-quantidade   as decimal no-undo.
define variable d-vl-unitario  as decimal no-undo.
define variable d-vl-tot-merc  as decimal no-undo.
define variable d-vl-total     as decimal no-undo.
define variable d-vl-ipi       as decimal no-undo.
define variable c-unid-negoc   as character no-undo.
define variable c-pais         as character no-undo.
define variable c-estado       as character no-undo.
define variable c-cidade       as character no-undo.
define variable c-item         as character no-undo.
define variable i               as integer no-undo.

define buffer b-matriz for emitente.

/* A data final Ç subtra°da de um, pois no in°cio do màs queremos analisar a carteira do fechamento do màs passado  */
assign dt-final = today - 1
       dt-final = date(month(dt-final), 1, year(dt-final))
       dt-final = add-interval(dt-final, 1, 'months') - 1.

for each ped-venda no-lock
   where ped-venda.cod-sit-ped = 1
      or ped-venda.cod-sit-ped = 2
      or ped-venda.cod-sit-ped = 5,
   each ped-item of ped-venda no-lock
      where (ped-item.cod-sit-item  = 1
        and  ped-item.dt-entrega   <= dt-final
        and  ped-item.ind-componen <> 3)
         or (ped-item.cod-sit-item  = 2
        and  ped-item.dt-entrega   <= dt-final
        and  ped-item.ind-componen <> 3)
         or (ped-item.cod-sit-item  = 5
        and  ped-item.dt-entrega   <= dt-final
        and  ped-item.ind-componen <> 3):

   /** Oráamento **/
   if ped-venda.cod-priori = 44 then
      next.

   find cotacao no-lock
      where cotacao.mo-codigo   = ped-venda.mo-codigo
        and cotacao.ano-periodo = string(year(today), "9999") + string(month(today), "99") no-error.
   if available (cotacao) and (cotacao.cotacao[day(today)] <> 0) then
      assign d-cotacao = cotacao.cotacao[day(today)].
   else
      assign d-cotacao = 1.

   find natur-oper no-lock
      where natur-oper.nat-operacao = ped-item.nat-operacao no-error.

   if not available (natur-oper) then do:
      run createError("Natureza de Operaá∆o " + ped-item.nat-operacao + " n∆o encontrada - " + ped-venda.nome-abrev + ', ' + ped-venda.nr-pedcli + ', ' + ped-item.it-codigo + ', ' + string(ped-item.nr-sequencia)).
      next.
   end.

   find item no-lock
      where item.it-codigo = ped-item.it-codigo no-error.

   if not available (item) then do:
      run createError("Item " + ped-item.it-codigo + " n∆o encontrado - " + ped-venda.nome-abrev + ', ' + ped-venda.nr-pedcli + ', ' + ped-item.it-codigo + ', ' + string(ped-item.nr-sequencia)).
      next.
   end.

   assign i-tributacao = if natur-oper.cd-trib-ipi = 1 then
                            if item.cd-trib-ipi = 1 or item.cd-trib-ipi = 4 then
                               1
                            else
                               item.cd-trib-ipi
                         else
                            if natur-oper.cd-trib-ipi = 2 or natur-oper.cd-trib-ipi = 3 then
                               natur-oper.cd-trib-ipi
                            else
                               item.cd-trib-ipi.

   find repres no-lock
      where repres.nome-abrev = ped-venda.no-ab-reppri no-error.

   if not available (repres) then do:
      run createError("Representante " + ped-venda.no-ab-reppri + " n∆o encontrado - " + ped-venda.nome-abrev + ', ' + ped-venda.nr-pedcli + ', ' + ped-item.it-codigo + ', ' + string(ped-item.nr-sequencia)).
      next.
   end.
   
   find emitente no-lock
      where emitente.nome-abrev = ped-venda.nome-abrev no-error.

   find first b-matriz no-lock
         where b-matriz.nome-abrev = emitente.nome-matriz no-error.

if not available (emitente) then do:
      run createError("Emitente " + ped-venda.nome-abrev + " n∆o encontrado - " + ped-venda.nome-abrev + ', ' + ped-venda.nr-pedcli + ', ' + ped-item.it-codigo + ', ' + string(ped-item.nr-sequencia)).
      next.
   end.

   assign c-pais   = fn-free-accent(upper(trim(ped-venda.pais)))
          c-estado = fn-free-accent(upper(trim(ped-venda.estado)))
          c-cidade = fn-free-accent(upper(trim(ped-venda.cidade)))
          c-item   = fn-free-accent(upper(trim(ped-item.it-codigo))).
   
   if c-estado = 'DF' then
      assign c-cidade = 'BRASILIA'.

   /** Atribui e corrige unidade de neg¢cio **/
   if ped-item.cod-unid-negoc = ? then
      assign c-unid-negoc = 'INV'.
   else if (ped-venda.cod-estabel = '102' and ped-item.cod-unid-negoc = 'ADM') then
      assign c-unid-negoc = 'COM'.
   else if (ped-venda.cod-estabel = '301' and ped-item.cod-unid-negoc = 'ADM') then
      assign c-unid-negoc = 'MAX'.
   else 
      assign c-unid-negoc = ped-item.cod-unid-neg.

   find unid_negoc no-lock
      where unid_negoc.cod_unid_negoc = c-unid-negoc no-error.
   
   if i-tributacao = 1 then
      assign d-vl-ipi = ped-item.vl-preuni * d-cotacao * ped-item.aliquota-ipi / 100.
   else
      assign d-vl-ipi = 0.

   assign d-quantidade  = (ped-item.qt-pedida - ped-item.qt-atendida)
          d-vl-unitario = ped-item.vl-preuni * d-cotacao
          d-vl-tot-merc = (d-vl-unitario * d-quantidade)
          d-vl-total    = (d-vl-unitario + d-vl-ipi) * d-quantidade.

   create ttCarteiraVendasResumo.
   assign ttCarteiraVendasResumo.CD_Estabelecimento              = ped-venda.cod-estabel
          ttCarteiraVendasResumo.CD_Emitente                     = ped-venda.cod-emitente
          ttCarteiraVendasResumo.CD_Grupo_Cliente                = emitente.cod-gr-cli
          ttCarteiraVendasResumo.CD_Pedido_Cliente               = ped-venda.nr-pedcli
          ttCarteiraVendasResumo.CD_Sequencia                    = ped-item.nr-sequencia
          ttCarteiraVendasResumo.CD_Item                         = ped-item.it-codigo
          ttCarteiraVendasResumo.CD_Unidade_Negocio              = upper(c-unid-negoc)
          ttCarteiraVendasResumo.CD_Representante                = repres.cod-rep     
          ttCarteiraVendasResumo.CD_Pais                         = c-pais
          ttCarteiraVendasResumo.CD_Estado                       = c-estado
          ttCarteiraVendasResumo.CD_Cidade                       = c-cidade
          ttCarteiraVendasResumo.TX_Emitente_Nome_Abreviado      = fn-free-accent(upper(trim(emitente.nome-abrev)))                          
          ttCarteiraVendasResumo.TX_Emitente_Nome_Abrev_Matriz   = (if available b-matriz then b-matriz.nome-abrev else emitente.nome-abrev) 
          ttCarteiraVendasResumo.TX_Representante_Nome_Abreviado = repres.nome-abrev                                                         
          ttCarteiraVendasResumo.TX_Unidade_Negocio              = unid_negoc.des_unid_negoc
          ttCarteiraVendasResumo.TX_Item                         = item.desc-item
          ttCarteiraVendasResumo.DT_Carteira                     = today
          ttCarteiraVendasResumo.NM_Qtde_Saldo                   = (ped-item.qt-pedida - ped-item.qt-atendida)
          ttCarteiraVendasResumo.NM_Vl_Unitario                  = d-vl-unitario
          ttCarteiraVendasResumo.NM_Vl_Liquido                   = d-vl-tot-merc
          ttCarteiraVendasResumo.NM_Vl_Total                     = d-vl-total.

   if (item.fm-cod-com <> '') and can-find (first fam-com-item
                                            where fam-com-item.fm-cod-com = item.fm-cod-com) then do:
      repeat i = 1 to 8:
         if (i = 1) or
            (i = 2) or
            (i = 3) or
            (i = 6) then
            next.

         find fam-com-item no-lock
            where fam-com-item.fm-cod-com = substring(item.fm-cod-com, 1, i) no-error.

         if not available (fam-com-item) then
            next.

         case i:
            when 4 then
               assign ttCarteiraVendasResumo.TX_Segmento = fam-com-item.descricao.
            when 5 then
               assign ttCarteiraVendasResumo.TX_Familia = fam-com-item.descricao.
            when 7 then
               assign ttCarteiraVendasResumo.TX_Subfamilia = fam-com-item.descricao.
            when 8 then
               assign ttCarteiraVendasResumo.TX_Origem = fam-com-item.descricao.
         end case.
      end.
   end.

end.
