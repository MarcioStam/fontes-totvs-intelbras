{esp/esb/esesb000.i}

/*Dataset Entrada*/
DEFINE TEMP-TABLE MSG0257 NO-UNDO XML-NODE-NAME 'MSG0257'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD CodigoSolicitacaoInterna    LIKE pagamento.nr-pagamento INITIAL ?
   .

/*Dataset Retorno*/
DEFINE TEMP-TABLE MSG0257R1 NO-UNDO XML-NODE-NAME 'MSG0257R1'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'.

DEFINE TEMP-TABLE SolicitacaoInterna NO-UNDO XML-NODE-NAME 'SolicitacaoInterna'
    FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
    FIELD CodigoSolicitacaoInterna    LIKE pagamento.nr-pagamento
    FIELD DataEmissao                 LIKE pagamento.data-ci
    FIELD PrevFechaCambio             LIKE pagamento.dt-prev-fecha-cam
    FIELD Urgente                     LIKE pagamento.log-urgente
    FIELD CodigoFornecedorEMS         LIKE pagamento.cod-emitente
    FIELD NomeAbreviadoFornecedor     LIKE emitente.nome-abrev
    FIELD CodigoEstabelecimento       LIKE pagamento.cod-estabel
    FIELD NomeEstabelecimento         LIKE estabelec.nome
    FIELD ValorSolicitacaoInterna     LIKE pagamento.valor-pag
    FIELD CodigoMoedaEMS              LIKE pagamento.cod-moeda
    FIELD NomeMoeda                   LIKE moeda.descricao
    FIELD TipoSolicitacaoInterna      LIKE pagamento.tipo-ci
    FIELD StatusSolicitacaoInterna    LIKE pagamento.ind-status-solicitacao
    FIELD CodigoCondicaoPagamento     LIKE pagamento.cod-cond-pag
    FIELD NomeCondicaoPagamento       LIKE cond-pagto.descricao
    FIELD CodigoTipoDespesa           LIKE pagamento.tipo-despesa
    FIELD DescricaoTipoDespesa        LIKE tipo-rec-desp.descricao
    FIELD MatriculaResponsavel        LIKE pagamento.usuario
    FIELD NomeResponsavel             LIKE usuar_mestre.nom_usuar
    FIELD MatriculaComprador          LIKE pagamento.cod-comprador
    FIELD NomeComprador               LIKE usuar_mestre.nom_usuar
    FIELD PossuiAnexos                AS LOG
    FIELD Observacoes                 LIKE pagamento.txt-observacao
    FIELD PagamentoAntecipado         LIKE pagamento.log-pag-antecipado
    FIELD DataFFT                     LIKE pagamento.dat-fft
    FIELD DISiscomex                  LIKE embarque-imp.declaracao-import
    FIELD CodigoDespachante           LIKE emitente.cod-emitente
    FIELD NomeDespachante             LIKE emitente.nome-abrev
    FIELD CodigoUnidadeNegocio        LIKE unid_negoc.cod_unid_negoc
    FIELD DescricaoUnidadeNegocio     LIKE unid_negoc.des_unid_negoc.

DEFINE TEMP-TABLE HistoricoSolicitacaoInterna NO-UNDO XML-NODE-NAME 'HistoricoSolicitacaoInterna'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD MatriculaUsuario    LIKE int-hist-pagamento.cod-usuario  
   FIELD DataHistorico       LIKE int-hist-pagamento.dat-hist     
   FIELD HoraHistorico       LIKE int-hist-pagamento.hor-hist     
   FIELD AcaoHistorico       LIKE int-hist-pagamento.ind-acao     
   FIELD ObservacaoHistorico LIKE int-hist-pagamento.txt-historico
   .

DEFINE TEMP-TABLE Fatura NO-UNDO XML-NODE-NAME 'Fatura'
    FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
    FIELD NumeroEmbarque        LIKE pagamento-invoice.embarque
    FIELD CodigoEstabelecimento LIKE pagamento.cod-estabel
    FIELD DataEmbarque          AS DATE /*historico-embarque.dt-efetiva*/
    FIELD NumeroInvoice         LIKE pagamento-invoice.nr-invoice
    FIELD ParcelaInvoice        LIKE pagamento-invoice.parcela
    FIELD CodigoMoedaEMS        LIKE invoice-emb-imp.mo-codigo
    FIELD NomeMoeda             LIKE moeda.descricao
    FIELD ValorInvoice          LIKE pagamento-invoice.valor
    FIELD DataInvoice           LIKE invoice-emb-imp.dt-vencim
    .

DEFINE TEMP-TABLE FinanceiroFiscalSolicitacao NO-UNDO XML-NODE-NAME 'FinanceiroFiscalSolicitacao'
    FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
    FIELD Recebida                    LIKE pagamento.recebido-ap
    FIELD MatriculaUsuarioRecebimento LIKE pagamento.usuar-receb
    FIELD NomeColaboradorIntelbras    LIKE usuar_mestre.nom_usuar
    FIELD DataRecebimento             AS DATE
    FIELD ValorContratoME             LIKE pagamento.valor-contrato-me
    FIELD NaturezaCambial             LIKE pagamento.tipo-contr-cambio
    FIELD ContratoCambio              LIKE pagamento.nr-cont-cambio
    FIELD DataContratoCambio          LIKE pagamento.data-emissao
    FIELD CodigoSwift                 LIKE pagamento.swift
    FIELD DataSwift                   LIKE pagamento.data-swift
    FIELD InstituicaoCambio           LIKE pagamento.instit-cambio
    FIELD PracaCambio                 LIKE pagamento.praca-cambio
    FIELD TaxaCambioPagamento         LIKE pagamento.taxa-cambio-pag 
    FIELD TaxaCambio                  LIKE pagamento.taxa-cambio
    FIELD ValorContrato               LIKE pagamento.valor-contrato-me
    FIELD ValorOrdem                  LIKE pagamento.valor-ord-pag
    FIELD CodigoMoedaEMS              LIKE pagamento.cod-moeda
    FIELD NomeMoeda                   LIKE moeda.descricao
    FIELD ValorFechamento             LIKE pagamento.valor-fechamento
    FIELD DataFechamentoCambio        LIKE pagamento.dt-fecha-cam
    FIELD NaturezaFinanceira          LIKE pagamento.ind-natureza
    FIELD CreditNote                  LIKE pagamento.val-credit-note
    FIELD Ptax                        LIKE pagamento.val-taxa-ptax
    FIELD CustoFftLcUsd               LIKE pagamento.val-custo-fft-lc-usd
    FIELD CustoFftLcRs                LIKE pagamento.val-custo-fft-lc-rs
    FIELD DataDebitoCustoFftLc        LIKE pagamento.dat-custo-fft-lc
    .

/*Outras temp tables*/
DEFINE TEMP-TABLE tt-erro NO-UNDO
    FIELD mensagem AS CHARACTER FORMAT "x(250)".

DEF TEMP-TABLE UnidNegocioEmbarque 
    FIELD codEstabel           LIKE estabelec.cod-estabel
    FIELD embarque             LIKE ordens-embarque.embarque
    FIELD CodigoUnidadeNegocio LIKE unid_negoc.cod_unid_negoc
    FIELD valor                LIKE ordem-compra.preco-orig 
    INDEX idx codEstabel embarque CodigoUnidadeNegocio valor.
