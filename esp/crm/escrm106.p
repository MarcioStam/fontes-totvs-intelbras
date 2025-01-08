/*----------------------------------------------------------------------
**  Programa..: esp/crm/escrm106.p
**  Autor.....: Felipe Braun Azambuja
**  Data......: Outubro/2010 - Desenvolvimento
**  Descricao.: Detalhe de nota fiscal - B2B/CRM
-----------------------------------------------------------------------*/

create widget-pool.

define temp-table tt-nota-fiscal no-undo
   field cod-estabel    like nota-fiscal.cod-estabel
   field serie          like nota-fiscal.serie
   field nr-nota-fis    like nota-fiscal.nr-nota-fis
   field cod-emitente   like nota-fiscal.cod-emitente
   field nome-transp    like nota-fiscal.nome-transp
   field dt-emis-nota   like nota-fiscal.dt-emis-nota
   field dt-confirma    like nota-fiscal.dt-confirma
   field dt-cancel      like nota-fiscal.dt-cancel
   field dt-saida       like nota-fiscal.dt-saida
   field peso-liq-tot   like nota-fiscal.peso-liq-tot
   field peso-bru-tot   like nota-fiscal.peso-bru-tot
   field vl-mercad      like nota-fiscal.vl-mercad
   field vl-tot-ipi     like nota-fiscal.vl-tot-ipi
   field vl-tot-nota    like nota-fiscal.vl-tot-nota
   field nr-volumes     like nota-fiscal.nr-volumes
   field nat-operacao   like nota-fiscal.nat-operacao
   field cgc            like nota-fiscal.cgc
   field ins-estadual   like nota-fiscal.ins-estadual
   field nr-pedcli      like nota-fiscal.nr-pedcli
   field cod-cond-pag   like nota-fiscal.cod-cond-pag
   field des-cond-pag   like cond-pagto.descricao
   field nr-fatura      like nota-fiscal.nr-fatura
   field observ-nota    like nota-fiscal.observ-nota
   field cod-nota       as   character
   FIELD cod-rep        LIKE nota-fiscal.cod-rep
   index idx_nf is primary unique cod-estabel serie nr-nota-fis
   index idx_emi cod-emitente.

define temp-table tt-emitente no-undo
   field cod-emitente   like emitente.cod-emitente
   field nome-emit      like emitente.nome-emit
   field cgc            like emitente.cgc
   field ins-estadual   like emitente.ins-estadual
   field telefone       like emitente.telefone[1]
   field cod-gr-cli     like gr-cli.cod-gr-cli
   field descricao      like gr-cli.descricao
   index idx_emi is primary unique cod-emitente.

define temp-table tt-transporte no-undo
   field cod-transp     like transporte.cod-transp
   field nome           like transporte.nome
   field nome-abrev     like transporte.nome-abrev
   field cgc            like transporte.cgc
   field ins-estadual   like transporte.ins-estadual
   field endereco       like transporte.endereco
   field bairro         like transporte.bairro
   field cep            like transporte.cep
   field cidade         like transporte.cidade
   field estado         like transporte.estado
   field pais           like transporte.pais
   index idx_pri  is unique cod-transp
   index idx_nome is primary unique nome-abrev.

define temp-table tt-it-nota-fisc no-undo
   field cod-estabel    like it-nota-fisc.cod-estabel
   field serie          like it-nota-fisc.serie
   field nr-nota-fis    like it-nota-fisc.nr-nota-fis
   field nr-seq-fat     like it-nota-fisc.nr-seq-fat
   field it-codigo      like it-nota-fisc.it-codigo
   field desc-item      like item.desc-item
   field class-fiscal   like it-nota-fisc.class-fiscal
   field aliquota-icm   like it-nota-fisc.aliquota-icm
   field aliquota-ipi   like it-nota-fisc.aliquota-ipi
   field qt-faturada    like it-nota-fisc.qt-faturada[1]
   field vl-ipi-it      like it-nota-fisc.vl-ipi-it
   field vl-preuni      like it-nota-fisc.vl-preuni
   field vl-merc-liq    like it-nota-fisc.vl-merc-liq
   field vl-total       as   decimal
   index idx_itnf is primary unique cod-estabel serie nr-nota-fis nr-seq-fat it-codigo.

define temp-table tt-totais no-undo
   field cod-estabel    like nota-fiscal.cod-estabel
   field serie          like nota-fiscal.serie
   field nr-nota-fis    like nota-fiscal.nr-nota-fis
   field base-icms      as   decimal
   field vl-icms        as   decimal
   field base-icms-sub  as   decimal
   field vl-icms-sub    as   decimal
   index idx_nf is primary unique cod-estabel serie nr-nota-fis.

DEFINE TEMP-TABLE tt-fat-duplic NO-UNDO
    FIELD cod-estabel    LIKE fat-duplic.cod-estabel
    FIELD serie          LIKE fat-duplic.serie
    FIELD nr-fatura      LIKE fat-duplic.nr-fatura
    FIELD ind-fat-nota   LIKE fat-duplic.ind-fat-nota
    FIELD flag-atualiz   LIKE fat-duplic.flag-atualiz
    FIELD parcela        LIKE fat-duplic.parcela
    FIELD dt-venciment   LIKE fat-duplic.dt-venciment
    FIELD valor-parcela  AS   DECIMAL
    INDEX idx_fat IS PRIMARY UNIQUE cod-estabel serie nr-fatura ind-fat-nota flag-atualiz parcela.



define input  parameter pcod-estabel   as character   no-undo.
define input  parameter pserie         as character   no-undo.
define input  parameter pnr-nota-fis   as character   no-undo.
DEFINE OUTPUT PARAMETER TABLE FOR tt-nota-fiscal.
DEFINE OUTPUT PARAMETER TABLE FOR tt-emitente.
DEFINE OUTPUT PARAMETER TABLE FOR tt-transporte.
DEFINE OUTPUT PARAMETER TABLE FOR tt-it-nota-fisc.
DEFINE OUTPUT PARAMETER TABLE FOR tt-fat-duplic.
DEFINE OUTPUT PARAMETER TABLE FOR tt-totais.


DEFINE VARIABLE de-cotacao AS DECIMAL     NO-UNDO.


for each nota-fiscal no-lock
   where nota-fiscal.cod-estabel = pcod-estabel
     and nota-fiscal.serie       = pserie
     and nota-fiscal.nr-nota-fis = pnr-nota-fis,
   first emitente no-lock
      where emitente.cod-emitente = nota-fiscal.cod-emitente,
   first gr-cli of emitente no-lock,
   first transporte no-lock
      where transporte.nome-abrev = nota-fiscal.nome-transp:

    FIND FIRST cond-pagto NO-LOCK
        WHERE  cond-pagto.cod-cond-pag = nota-fiscal.cod-cond-pag NO-ERROR.

   create tt-nota-fiscal.
   buffer-copy nota-fiscal to tt-nota-fiscal.
   assign tt-nota-fiscal.cod-nota     = nota-fiscal.cod-estabel + "/" + nota-fiscal.nr-nota-fis + "/" + nota-fiscal.serie
          tt-nota-fiscal.des-cond-pag = IF AVAIL cond-pagto THEN cond-pagto.descricao ELSE "".

   create tt-emitente.
   buffer-copy emitente except telefone to tt-emitente.
   assign tt-emitente.descricao = gr-cli.descricao
          tt-emitente.telefone  = emitente.telefone[1].

   create tt-transporte.
   buffer-copy transporte to tt-transporte.

   create tt-totais.
   assign tt-totais.cod-estabel   = nota-fiscal.cod-estabel
          tt-totais.serie         = nota-fiscal.serie
          tt-totais.nr-nota-fis   = nota-fiscal.nr-nota-fis.

   for each it-nota-fisc of nota-fiscal no-lock,
       first item no-lock
       where item.it-codigo = it-nota-fisc.it-codigo:
      create tt-it-nota-fisc.
      buffer-copy it-nota-fisc except qt-faturada to tt-it-nota-fisc.
      assign tt-it-nota-fisc.desc-item   = item.desc-item
             tt-it-nota-fisc.qt-faturada = it-nota-fisc.qt-faturada[1]
             tt-it-nota-fisc.vl-total    = it-nota-fisc.vl-preuni  * it-nota-fisc.qt-faturada[1]
             tt-totais.base-icms         = tt-totais.base-icms     + it-nota-fisc.vl-bicms-it
             tt-totais.vl-icms           = tt-totais.vl-icms       + it-nota-fisc.vl-icms-it
             tt-totais.base-icms-sub     = tt-totais.base-icms-sub + it-nota-fisc.vl-bsubs-it
             tt-totais.vl-icms-sub       = tt-totais.vl-icms-sub   + it-nota-fisc.vl-icmsub-it.
   end.

   FOR EACH  fat-duplic NO-LOCK
       WHERE fat-duplic.cod-estabel = nota-fiscal.cod-estabel
       AND   fat-duplic.serie       = nota-fiscal.serie
       AND   fat-duplic.nr-fatura   = nota-fiscal.nr-fatura
       BY    fat-duplic.parcela:

       IF  fat-duplic.vl-finsocial = 0 THEN
           ASSIGN de-cotacao = 1.
       ELSE DO:
           FIND FIRST cotacao NO-LOCK
               WHERE cotacao.mo-codigo   = INT(fat-duplic.vl-finsocial)
               AND cotacao.ano-periodo = STRING(YEAR(nota-fiscal.dt-emis-nota)) + STRING(MONTH(nota-fiscal.dt-emis-nota), "99") NO-ERROR.
           IF  AVAIL cotacao THEN
               ASSIGN de-cotacao = cotacao.cotacao[DAY(nota-fiscal.dt-emis-nota)].
           ELSE
               ASSIGN de-cotacao = 1.
       END.

       CREATE tt-fat-duplic.
       ASSIGN tt-fat-duplic.cod-estabel   = fat-duplic.cod-estabel
              tt-fat-duplic.serie         = fat-duplic.serie
              tt-fat-duplic.nr-fatura     = fat-duplic.nr-fatura
              tt-fat-duplic.ind-fat-nota  = fat-duplic.ind-fat-nota
              tt-fat-duplic.flag-atualiz  = fat-duplic.flag-atualiz
              tt-fat-duplic.parcela       = fat-duplic.parcela
              tt-fat-duplic.dt-venciment  = fat-duplic.dt-venciment
              tt-fat-duplic.valor-parcela = fat-duplic.vl-parcela / de-cotacao.
   END.
end.


if can-find (first tt-nota-fiscal) then
   return 'ok'.
else
   return 'nok'.
