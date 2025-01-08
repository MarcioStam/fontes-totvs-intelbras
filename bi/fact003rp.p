/**
 * Extrator para BI
 * Fato: Carteira de Vendas
 *
 * Autor: Felipe Braun Azambuja
 */

create widget-pool.

{include/i-freeac.i}

/** Include com a temp table principal e a temp table de parÉmetros **/
{bi/fact003tt.i}
{bi/esbi000.i}
{esp/pdp/espdp029.i}

define input  parameter table for tt-param.
define output parameter table for ttCarteiraVendas.
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
define variable d-vl-pendente  as decimal no-undo.
define variable de-perc-acordo as decimal no-undo.

define variable c-unid-negoc   as character no-undo.
define variable c-pais         as character no-undo.
define variable c-estado       as character no-undo.
define variable c-cidade       as character no-undo.
define variable c-item         as character no-undo.
define variable i-cd-canal     as integer   no-undo.

DEFINE VARIABLE i-cod-sit-aval LIKE ped-venda.cod-sit-aval NO-UNDO.

/* A data final Ç subtra°da de um, pois no in°cio do màs queremos analisar a carteira do fechamento do màs passado  */
/* N∆o queremos mais. Chamado: 86768 */
assign dt-final = today /*- 1*/
       dt-final = date(month(dt-final), 1, year(dt-final))
       dt-final = add-interval(dt-final, 1, 'months') - 1.

/** Conex∆o com o EMS para a execuá∆o de BO **/
/*//run bi/esbi002.p (tt-param.usuario, tt-param.senha).*/

for each ped-venda no-lock
   where ped-venda.cod-sit-ped = 1
      or ped-venda.cod-sit-ped = 2
      or ped-venda.cod-sit-ped = 5,
   each ped-item of ped-venda no-lock
      where (ped-item.cod-sit-item  = 1
        /*and  ped-item.dt-entrega   <= dt-final*/
        and  ped-item.ind-componen <> 3)
         or (ped-item.cod-sit-item  = 2
        /*and  ped-item.dt-entrega   <= dt-final*/
        and  ped-item.ind-componen <> 3)
         or (ped-item.cod-sit-item  = 5
        /*and  ped-item.dt-entrega   <= dt-final*/
        and  ped-item.ind-componen <> 3):

   /** Oráamento **/
   if ped-venda.cod-priori = 44 then
      next.

   assign i-cod-sit-aval = ped-venda.cod-sit-aval.

   /* Pedidos reprovados que deverao ser considerados no acesso restrito */
   /* Ou reprovados pelo sistema e que estejam dentro do mes ou mes inferior */
   if ped-venda.cod-sit-aval = 4 and (ped-venda.quem-aprovou <> "Sistema" or ped-item.dt-entrega > dt-final) then
      assign i-cod-sit-aval = 255.

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

   find transporte no-lock
      where transporte.nome-abrev = ped-venda.nome-transp no-error.

   if not available (transporte) then do:
      run createError("Transportador " + ped-venda.nome-transp + " n∆o encontrado - " + ped-venda.nome-abrev + ', ' + ped-venda.nr-pedcli + ', ' + ped-item.it-codigo + ', ' + string(ped-item.nr-sequencia)).
   end.
   
   find repres no-lock
      where repres.nome-abrev = ped-venda.no-ab-reppri no-error.

   if not available (repres) then do:
      run createError("Representante " + ped-venda.no-ab-reppri + " n∆o encontrado - " + ped-venda.nome-abrev + ', ' + ped-venda.nr-pedcli + ', ' + ped-item.it-codigo + ', ' + string(ped-item.nr-sequencia)).
      next.
   end.
   
   find emitente no-lock
      where emitente.nome-abrev = ped-venda.nome-abrev no-error.

   if not available (emitente) then do:
      run createError("Emitente " + ped-venda.nome-abrev + " n∆o encontrado - " + ped-venda.nome-abrev + ', ' + ped-venda.nr-pedcli + ', ' + ped-item.it-codigo + ', ' + string(ped-item.nr-sequencia)).
      next.
   end.

   find mgcad.cidade no-lock
      where mgcad.cidade.pais   = ped-venda.pais
        and mgcad.cidade.estado = ped-venda.estado
        and mgcad.cidade.cidade = ped-venda.cidade no-error.

   if not available (mgcad.cidade) then do:
      run createError("Pais/estado/cidade " + ped-venda.pais + "/" + ped-venda.estado + "/" + ped-venda.cidade + " n∆o encontrado - " + ped-venda.nome-abrev + ', ' + ped-venda.nr-pedcli + ', ' + ped-item.it-codigo + ', ' + string(ped-item.nr-sequencia)).
      next.
   end.

   assign c-pais   = fn-free-accent(upper(trim(ped-venda.pais)))
          c-estado = fn-free-accent(upper(trim(ped-venda.estado)))
          c-cidade = fn-free-accent(upper(trim(ped-venda.cidade)))
          c-frete  = if ped-venda.cidade-cif <> '' then 'CIF' else 'FOB'
          i-transp = if available transporte then transporte.cod-transp else 0
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

   if i-tributacao = 1 then
      assign d-vl-ipi = ped-item.vl-preuni * d-cotacao * ped-item.aliquota-ipi / 100.
   else
      assign d-vl-ipi = 0.

   assign d-quantidade  = (ped-item.qt-pedida - ped-item.qt-atendida)
          d-vl-unitario = ped-item.vl-preuni * d-cotacao
          d-vl-tot-merc = (d-vl-unitario * d-quantidade)
          d-vl-total    = (d-vl-unitario + d-vl-ipi) * d-quantidade
          d-vl-pendente = 0.

   /** Acordo comercial **/
   assign de-perc-acordo = 0.

   find grupo-canais-clientes no-lock
      where grupo-canais-clientes.cod-gr-cli = emitente.cod-gr-cli no-error.
   
   if available grupo-canais-clientes then
      assign i-cd-canal = grupo-canais-clientes.cod-gr-canais.
   
   find int-ped-venda2 no-lock
      where int-ped-venda2.cod-estabel = ped-venda.cod-estabel
        and int-ped-venda2.nr-pedido   = ped-venda.nr-pedido no-error.
   
   if available int-ped-venda2 and int-ped-venda2.int-1 <> 0 then
      assign i-cd-canal = int-ped-venda2.int-1.
   
   create ttCarteiraVendas.
   assign ttCarteiraVendas.CD_Estabelecimento    = ped-venda.cod-estabel
          ttCarteiraVendas.CD_Emitente           = ped-venda.cod-emitente
          ttCarteiraVendas.CD_Pedido_Cliente     = ped-venda.nr-pedcli
          ttCarteiraVendas.CD_Sequencia          = ped-item.nr-sequencia
          ttCarteiraVendas.CD_Item               = ped-item.it-codigo
          ttCarteiraVendas.DT_Entrega            = ped-item.dt-entrega
          ttCarteiraVendas.CD_Representante      = repres.cod-rep
          ttCarteiraVendas.CD_Unidade_Negocio    = upper(c-unid-negoc)
          ttCarteiraVendas.CD_Natureza_Operacao  = upper(ped-item.nat-operacao)
          ttCarteiraVendas.DT_Carteira           = today
          ttCarteiraVendas.CD_Pais               = c-pais
          ttCarteiraVendas.CD_Estado             = c-estado
          ttCarteiraVendas.CD_Cidade             = c-cidade
          ttCarteiraVendas.CD_Condicao_Pagamento = ped-venda.cod-cond-pag
          ttCarteiraVendas.CD_Transportador      = i-transp
          ttCarteiraVendas.CD_Frete              = c-frete
          ttCarteiraVendas.CD_Atendente          = ped-venda.tp-pedido
          ttCarteiraVendas.CD_Situacao_Avaliacao = i-cod-sit-aval
          ttCarteiraVendas.CD_Canal              = i-cd-canal
          ttCarteiraVendas.NM_Qtde_Saldo         = (ped-item.qt-pedida - ped-item.qt-atendida)
          ttCarteiraVendas.NM_Vl_Unitario        = d-vl-unitario
          ttCarteiraVendas.NM_Vl_Liquido         = d-vl-tot-merc
          ttCarteiraVendas.NM_Vl_Total           = d-vl-total
          ttCarteiraVendas.NM_Vl_Pendente        = d-vl-pendente
          ttCarteiraVendas.NM_Vl_Acordo          = d-vl-total * de-perc-acordo / 100
          ttCarteiraVendas.DT_Implant_Ped        = ped-venda.dt-implant
          ttCarteiraVendas.CD_Prioridade         = ped-venda.cod-priori
          ttCarteiraVendas.NM_Qtde_Saldo_Aloc    = ped-item.qt-log-aloca
          ttCarteiraVendas.TX_Motivo_Reprov      = fn-retira-espec(ped-venda.desc-bloq-cr)
          ttCarteiraVendas.NM_Vl_Taxa_Cambial    = d-cotacao
          ttCarteiraVendas.DT_Entrega_Original   = ped-venda.dt-entorig.
end.
