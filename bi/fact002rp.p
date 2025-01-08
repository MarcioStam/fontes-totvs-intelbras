/**
 * Extrator para BI
 * Fato: Devolu‡Æo de Vendas
 *
 * Autor: Felipe Braun Azambuja
 */

create widget-pool.

{include/i-freeac.i}

/** Include com a temp table principal e a temp table de parƒmetros **/
{bi/fact002tt.i }
{bi/esbi000.i}

define input  parameter table for tt-param.
define output parameter table for ttFactDevolucao.
define output parameter table for tt-erro.

find first tt-param.

define variable dt-data    as date   no-undo.
define variable h-boes464  as handle no-undo.

define variable de-perc-acordo as decimal no-undo.

define variable c-unid-negoc as character no-undo.
define variable c-pais       as character no-undo.
define variable c-estado     as character no-undo.
define variable c-cidade     as character no-undo.
define variable c-item       as character no-undo.

define variable c-atendente like ped-venda.tp-pedido no-undo.
define variable c-frete     as character no-undo.
define variable i-transp    as integer   no-undo.

define variable i-unidade       as integer  no-undo.
define variable i-qtd-item-doc  as integer  no-undo.
define variable r-docum-est     as rowid    no-undo.
define variable i-cd-canal      as integer  no-undo.
define variable i-cd-motivo-dev as integer  no-undo.
   
define buffer b-item-doc-est for item-doc-est.

/** ConexÆo com o EMS para a execu‡Æo de BO **/
run bi/esbi002.p (tt-param.usuario, tt-param.senha).

/*if not valid-handle (h-boes464) then
   run esbo/boes464.p persistent set h-boes464.*/

assign r-docum-est = ?.

for each devol-cli no-lock
   where devol-cli.dt-devol >= tt-param.dt-inicial
     and devol-cli.dt-devol <= tt-param.dt-final,
   each item-doc-est of devol-cli no-lock,
   first docum-est of item-doc-est no-lock:

   if docum-est.valor-frete > 0 and r-docum-est <> rowid(docum-est) then do:
      assign r-docum-est    = rowid(docum-est)
             i-qtd-item-doc = 0.

      for each b-item-doc-est of docum-est no-lock:
         assign i-qtd-item-doc = i-qtd-item-doc + 1.
      end.
   end.

   if i-qtd-item-doc = 0 then
      assign i-qtd-item-doc = 1.

   find it-nota-fisc no-lock
      where it-nota-fisc.cod-estabel = devol-cli.cod-estabel
        and it-nota-fisc.serie       = devol-cli.serie
        and it-nota-fisc.nr-nota-fis = devol-cli.nr-nota-fis
        and it-nota-fisc.nr-seq-fat  = devol-cli.nr-sequencia
        and it-nota-fisc.it-codigo   = devol-cli.it-codigo no-error.

   find first int-it-nota-fisc
       where int-it-nota-fisc.cod-estabel = it-nota-fisc.cod-estabel
         and int-it-nota-fisc.serie       = it-nota-fisc.serie
         and int-it-nota-fisc.nr-nota-fis = it-nota-fisc.nr-nota-fis
         and int-it-nota-fisc.nr-seq-fat  = it-nota-fisc.nr-seq-fat
         and int-it-nota-fisc.it-codigo   = it-nota-fisc.it-codigo no-lock no-error.

   find nota-fiscal of it-nota-fisc no-lock no-error.

   find ped-venda no-lock
      where ped-venda.nome-abrev = nota-fiscal.nome-ab-cli
        and ped-venda.nr-pedcli  = nota-fiscal.nr-pedcli no-error.

   find emitente no-lock
      where emitente.cod-emitente = devol-cli.cod-emitente no-error.

   find grupo-canais-clientes no-lock
      where grupo-canais-clientes.cod-gr-cli = emitente.cod-gr-cli no-error.

   if available grupo-canais-clientes then
      assign i-cd-canal = grupo-canais-clientes.cod-gr-canais.

   if available ped-venda then do:
      find int-ped-venda2 no-lock
         where int-ped-venda2.cod-estabel = ped-venda.cod-estabel
           and int-ped-venda2.nr-pedido   = ped-venda.nr-pedido no-error.

      if available int-ped-venda2 and int-ped-venda2.int-1 <> 0 then
         assign i-cd-canal = int-ped-venda2.int-1.
   end.

   assign c-atendente = if available ped-venda then ped-venda.tp-pedido else ''
          c-pais      = fn-free-accent(upper(trim(nota-fiscal.pais)))
          c-estado    = fn-free-accent(upper(trim(nota-fiscal.estado)))
          c-cidade    = fn-free-accent(upper(trim(nota-fiscal.cidade)))
          c-item      = fn-free-accent(upper(trim(devol-cli.it-codigo))).

   if c-estado = 'DF' then
      assign c-cidade = 'BRASILIA'.

   find emitente no-lock
      where emitente.cod-emitente = nota-fiscal.cod-emitente no-error.

   find item no-lock
      where item.it-codigo = it-nota-fisc.it-codigo no-error.

   /** Atribui e corrige unidade de neg¢cio **/
   if it-nota-fisc.cod-unid-negoc = ? then
     assign c-unid-negoc = 'INV'.
   else if (nota-fiscal.cod-estabel = '102' and it-nota-fisc.cod-unid-negoc = 'ADM') then
     assign c-unid-negoc = 'COM'.
   else if (nota-fiscal.cod-estabel = '301' and it-nota-fisc.cod-unid-negoc = 'ADM') then
     assign c-unid-negoc = 'MAX'.
   else
     assign c-unid-negoc = it-nota-fisc.cod-unid-negoc.

   /*if available item then
     run getAcordoComercial in h-boes464 (input emitente.cgc,
                                          input nota-fiscal.cod-estabel,
                                          input (if c-unid-negoc = 'INV' then ? else c-unid-negoc),
                                          input item.fm-cod-com,
                                          input nota-fiscal.dt-emis-nota,
                                          output de-perc-acordo) no-error.
   else*/
     assign de-perc-acordo = 0.

   
   ASSIGN i-cd-motivo-dev = 0.
   FIND int-docum-est OF docum-est NO-LOCK NO-ERROR.  
   IF  AVAIL int-docum-est then
       ASSIGN i-cd-motivo-dev = int-docum-est.cod-msg-devolucao.
   
       

   /** Unidade Comercial **/
   assign i-unidade = if available int-it-nota-fisc then int-it-nota-fisc.cd-unid-comerc else 0.

   create ttFactDevolucao.
   assign ttFactDevolucao.CD_Estabelecimento    = devol-cli.cod-estabel
          ttFactDevolucao.CD_Serie_Devolucao    = devol-cli.serie-docto
          ttFactDevolucao.CD_Nro_Devolucao      = devol-cli.nro-docto
          ttFactDevolucao.CD_Seq_Devolucao      = devol-cli.sequencia
          ttFactDevolucao.DT_Devolucao          = devol-cli.dt-devol
          ttFactDevolucao.CD_Deposito           = fn-free-accent(upper(trim(item-doc-est.cod-depos)))
          ttFactDevolucao.CD_Emitente           = devol-cli.cod-emitente
          ttFactDevolucao.CD_Representante      = nota-fiscal.cod-rep
          ttFactDevolucao.CD_Natureza_Operacao  = upper(it-nota-fisc.nat-operacao)
          ttFactDevolucao.CD_Serie              = devol-cli.serie
          ttFactDevolucao.CD_Nota_Fiscal        = devol-cli.nr-nota-fis
          ttFactDevolucao.CD_Sequencia          = devol-cli.nr-sequencia
          ttFactDevolucao.CD_Item               = c-item
          ttFactDevolucao.CD_Unidade_Negocio    = upper(c-unid-negoc)
          ttFactDevolucao.CD_Pais               = c-pais
          ttFactDevolucao.CD_Estado             = c-estado
          ttFactDevolucao.CD_Cidade             = c-cidade
          ttFactDevolucao.CD_Atendente          = c-atendente
          ttFactDevolucao.CD_Unidade_Comercial  = i-unidade
          ttFactDevolucao.CD_Canal              = i-cd-canal
          ttFactDevolucao.NM_Quantidade         = (item-doc-est.quantidade * -1)
          ttFactDevolucao.NM_Vl_Unitario        = (item-doc-est.preco-unit[1] * -1)
          ttFactDevolucao.NM_Vl_Liquido         = ((item-doc-est.preco-total[1] - item-doc-est.desconto[1]) * -1)
          ttFactDevolucao.NM_Vl_Total           = ((item-doc-est.preco-total[1] + item-doc-est.valor-ipi[1] + (docum-est.valor-frete / i-qtd-item-doc)) * -1)
          ttFactDevolucao.NM_Vl_Taxa_Cambial    = nota-fiscal.vl-taxa-exp
          ttFactDevolucao.NM_Vl_Acordo          = ((item-doc-est.preco-total[1] + item-doc-est.valor-ipi[1] + (docum-est.valor-frete / i-qtd-item-doc)) * -1) * de-perc-acordo / 100
          ttFactDevolucao.CD_Motivo_Dev         = i-cd-motivo-dev.
end.

