/**
 * Extrator para BI
 * Fato: Faturamento
 *
 * Autor: Felipe Braun Azambuja
 * 12/07/2011 - Hoepers: buscar valor do frete do item da nota, modal e transportador da nota.
 */
create widget-pool.

{include/i-freeac.i}

/** Include com a temp table principal e a temp table de parƒmetros **/
{bi/fact001tt.i}
{bi/esbi000.i}

define input  parameter table for tt-param.
define output parameter table for ttFactFaturamento.
define output parameter table for tt-erro.

find first tt-param.

define variable dt-data          as date   no-undo.
define variable h-boes464        as handle no-undo.
define variable de-perc-acordo   as decimal no-undo.
define variable c-unid-negoc     as character no-undo.
define variable c-pais           as character no-undo.
define variable c-estado         as character no-undo.
define variable c-cidade         as character no-undo.
define variable c-item           as character no-undo.
define variable v-cod-modal      as integer   no-undo.
define variable c-atendente      like ped-venda.tp-pedido no-undo.
define variable c-frete          as character no-undo.
define variable i-transp         as integer   no-undo.
define variable i-unidade        as integer   no-undo.
define variable i-cd-canal       as integer   no-undo.
define variable de-desconto-mais-verde  as decimal no-undo.

/** ConexÆo com o EMS para a execu‡Æo de BO **/
run bi/esbi002.p (tt-param.usuario, tt-param.senha).

/*if not valid-handle (h-boes464) then
   run esbo/boes464.p persistent set h-boes464.*/

do dt-data = tt-param.dt-inicial to tt-param.dt-final:
   for each nota-fiscal no-lock use-index ch-distancia
      where nota-fiscal.dt-emis-nota = dt-data,
      each it-nota-fisc of nota-fiscal no-lock:

      find natur-oper no-lock
         where natur-oper.nat-operacao = it-nota-fisc.nat-operacao no-error.

      /** Ignora notas de entrada **/
      if available natur-oper and natur-oper.tipo = 1 then
         next.

      /** Chamado 95693
        *
        * Ignora NFS com situa‡Æo diferente de Convertida, somente das geradas no Colabora‡Æo
        **/
      if available natur-oper and natur-oper.tipo = 3 and nota-fiscal.dt-emis-nota >= 05/08/2017 and substring(nota-fiscal.char-1,143,2) <> '3' AND substring(nota-fiscal.char-1,143,2) <> '6' then
         next.

      find int-it-nota-fisc no-lock
         where int-it-nota-fisc.cod-estabel = it-nota-fisc.cod-estabel
           and int-it-nota-fisc.serie       = it-nota-fisc.serie
           and int-it-nota-fisc.nr-nota-fis = it-nota-fisc.nr-nota-fis
           and int-it-nota-fisc.nr-seq-fat  = it-nota-fisc.nr-seq-fat
           and int-it-nota-fisc.it-codigo   = it-nota-fisc.it-codigo no-error.

      find estabelec no-lock
         where estabelec.cod-estabel = nota-fiscal.cod-estabel no-error.


      FIND FIRST ped-venda NO-LOCK 
           WHERE ped-venda.nome-abrev = it-nota-fisc.nome-ab-cli 
             AND ped-venda.nr-pedcli  = it-nota-fisc.nr-pedcli   NO-ERROR.

      /*find ped-venda no-lock
         where ped-venda.nome-abrev = nota-fiscal.nome-ab-cli
           and ped-venda.nr-pedcli  = nota-fiscal.nr-pedcli no-error.*/

      find transporte no-lock
         where transporte.nome-abrev = nota-fiscal.nome-transp no-error.

      find int-nota-fiscal of nota-fiscal NO-LOCK NO-ERROR.

      assign c-atendente = if available ped-venda then ped-venda.tp-pedido else ''
             i-transp    = if available transporte then transporte.cod-transp else 0
             c-frete     = if nota-fiscal.cidade-cif <> '' then 'CIF' else 'FOB'
             c-pais      = fn-free-accent(upper(trim(nota-fiscal.pais)))
             c-estado    = fn-free-accent(upper(trim(nota-fiscal.estado)))
             c-cidade    = fn-free-accent(upper(trim(nota-fiscal.cidade)))
             c-item      = fn-free-accent(upper(trim(it-nota-fisc.it-codigo))).

      if c-estado = 'DF' then
         assign c-cidade = 'BRASILIA'.

      find emitente no-lock
         where emitente.cod-emitente = nota-fiscal.cod-emitente no-error.

      find item no-lock
         where item.it-codigo = it-nota-fisc.it-codigo no-error.

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

      /* Busca Frete */
      /** Bloco removido **/

      /** Atribui e corrige unidade de neg¢cio **/
      if it-nota-fisc.cod-unid-negoc = ? then
         assign c-unid-negoc = 'INV'.
      else if (nota-fiscal.cod-estabel = '102' and it-nota-fisc.cod-unid-negoc = 'ADM') then
         assign c-unid-negoc = 'COM'.
      else if (nota-fiscal.cod-estabel = '301' and it-nota-fisc.cod-unid-negoc = 'ADM') then
         assign c-unid-negoc = 'MAX'.
      else
         assign c-unid-negoc = it-nota-fisc.cod-unid-negoc.

      /** Cordo comercial **/
      /*if available item then
          run getAcordoComercial in h-boes464 (input emitente.cgc,
                                                input nota-fiscal.cod-estabel,
                                                input (if c-unid-negoc = 'INV' then ? else c-unid-negoc),
                                                input item.fm-cod-com,
                                                input nota-fiscal.dt-emis-nota,
                                                output de-perc-acordo) no-error.
      else*/
          assign de-perc-acordo = 0.

      /** Unidade Comercial **/
      assign i-unidade = if available int-it-nota-fisc then int-it-nota-fisc.cd-unid-comerc else 0.

      FIND FIRST ped-repre OF ped-venda NO-LOCK
           WHERE ped-repre.nome-ab-rep <> ped-venda.no-ab-reppri NO-ERROR.

      FIND FIRST repres NO-LOCK 
           WHERE repres.nome-abrev = ped-repre.nome-ab-rep NO-ERROR.

      FIND FIRST ped-item OF ped-venda NO-LOCK
           WHERE ped-item.it-codigo    = it-nota-fisc.it-codigo 
             AND ped-item.nr-sequencia = it-nota-fisc.nr-seq-ped NO-ERROR.

      IF  AVAIL ped-item THEN DO:
          /* Buscar Desconto MaisVerde */
          FIND FIRST int-ped-item-rebate
                 WHERE int-ped-item-rebate.nome-abrev   = ped-item.nome-abrev
                   AND int-ped-item-rebate.nr-pedcli    = ped-item.nr-pedcli  
                   AND int-ped-item-rebate.nr-sequencia = ped-item.nr-sequencia
                   AND int-ped-item-rebate.it-codigo    = ped-item.it-codigo  
                   AND int-ped-item-rebate.cod-refer    = ped-item.cod-refer   NO-LOCK NO-ERROR.

            IF  AVAIL int-ped-item-rebate THEN 
                ASSIGN de-desconto-mais-verde = int-ped-item-rebate.perc-descto-verde.
            ELSE
                ASSIGN de-desconto-mais-verde = 0.
      END.
      ELSE 
          ASSIGN de-desconto-mais-verde = 0.

      create ttFactFaturamento.
      assign ttFactFaturamento.CD_Estabelecimento       = nota-fiscal.cod-estabel
             ttFactFaturamento.CD_Serie                 = nota-fiscal.serie
             ttFactFaturamento.CD_Nota_Fiscal           = nota-fiscal.nr-nota-fis
             ttFactFaturamento.DT_Emissao               = nota-fiscal.dt-emis-nota
             ttFactFaturamento.DT_Saida                 = nota-fiscal.dt-saida
             ttFactFaturamento.CD_Representante         = nota-fiscal.cod-rep
             ttFactFaturamento.CD_Representante_2       = IF AVAIL repres THEN string(repres.cod-rep) ELSE ""
             ttFactFaturamento.CD_Emitente              = nota-fiscal.cod-emitente
             ttFactFaturamento.CD_Sequencia             = it-nota-fisc.nr-seq-fat
             ttFactFaturamento.CD_Item                  = c-item
             ttFactFaturamento.CD_Unidade_Negocio       = upper(c-unid-negoc)
             ttFactFaturamento.CD_Natureza_Operacao     = upper(it-nota-fisc.nat-operacao)
             ttFactFaturamento.CD_Pais                  = c-pais
             ttFactFaturamento.CD_Estado                = c-estado
             ttFactFaturamento.CD_Cidade                = c-cidade
             ttFactFaturamento.CD_Transportadora        = i-transp
             ttFactFaturamento.CD_Frete                 = c-frete
             ttFactFaturamento.CD_Atendente             = c-atendente
             ttFactFaturamento.CD_Cancelada             = (if nota-fiscal.dt-cancel = ? then 0 else 1)
             ttFactFaturamento.CD_Unidade_Comercial     = i-unidade
             ttFactFaturamento.CD_Pedido_Cliente        = (IF  AVAIL ped-venda THEN ped-venda.nr-pedcli ELSE "")
             ttFactFaturamento.NM_Quantidade            = it-nota-fisc.qt-faturada[1]
             ttFactFaturamento.NM_Vl_Unitario           = it-nota-fisc.vl-preuni
             ttFactFaturamento.NM_Vl_Liquido            = it-nota-fisc.vl-merc-liq + it-nota-fisc.vl-despes-it
             ttFactFaturamento.NM_Vl_Total              = it-nota-fisc.vl-tot-item
             ttFactFaturamento.NM_Vl_Taxa_Cambial       = nota-fiscal.vl-taxa-exp
             ttFactFaturamento.NM_Vl_Acordo             = it-nota-fisc.vl-tot-item * de-perc-acordo / 100
             ttFactFaturamento.NM_Vl_Frete_Prev         = 0
             ttFactFaturamento.NM_Vl_Frete_Real         = 0
             ttFactFaturamento.NM_Vl_Desconto_MaisVerde = de-desconto-mais-verde
             ttFactFaturamento.CD_Modal                 = 0
             ttFactFaturamento.CD_Canal                 = i-cd-canal
             ttFactFaturamento.DT_Prevista              = (if available int-nota-fiscal then date(substring(int-nota-fiscal.char-1,50,10)) else ?)
             ttFactFaturamento.DT_Entrega               = nota-fiscal.dt-entr-cli
             ttFactFaturamento.DT_Implant_Ped           = IF AVAIL ped-venda THEN ped-venda.dt-implant ELSE ?.
   end.
end.
