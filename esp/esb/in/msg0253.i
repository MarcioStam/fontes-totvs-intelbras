{esp/esb/esesb000.i}

/*Dataset Entrada*/
DEFINE TEMP-TABLE MSG0253 NO-UNDO XML-NODE-NAME 'MSG0253'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD CodigoFornecedorEMS         LIKE pagamento.cod-emitente    INITIAL ?
   FIELD CodigoEstabelecimento       LIKE pagamento.cod-estabel     INITIAL ?
   FIELD MatriculaResponsavel        LIKE pagamento.usuario         INITIAL ?
   FIELD CodigoSolicitacaoInterna    LIKE pagamento.nr-pagamento    INITIAL ?
   FIELD CodigoCondicaoPagamento     LIKE pagamento.cod-cond-pag    INITIAL ?
   FIELD SomenteSwift                AS LOGICAL                     INITIAL ?
   FIELD CodigoDespachante           LIKE pagamento.cod-despachante INITIAL ?
   .

DEFINE TEMP-TABLE FiltroStatusSolicitacaoInterna NO-UNDO XML-NODE-NAME 'FiltroStatusSolicitacaoInterna'
    FIELD idm AS INT XML-NODE-TYPE 'hidden'
    FIELD StatusSolicitacaoInterna LIKE ind-status-solicitacao
    .

DEFINE TEMP-TABLE FiltroData NO-UNDO XML-NODE-NAME 'FiltroData'
    FIELD idm AS INT XML-NODE-TYPE 'hidden'
    FIELD DataInicialPeriodo      AS DATE
    FIELD DataFinalPeriodo        AS DATE
    FIELD PesquisaDataSolicitacao AS INT
    .

/*Dataset Retorno*/
DEFINE TEMP-TABLE MSG0253R1 NO-UNDO XML-NODE-NAME 'MSG0253R1'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'.

DEFINE TEMP-TABLE SolicitacaoInternaPagamentoItens NO-UNDO XML-NODE-NAME 'SolicitacaoInternaPagamentoItens'
    FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'.

DEFINE TEMP-TABLE SolicitacaoInternaPagamentoItem NO-UNDO XML-NODE-NAME 'SolicitacaoInternaPagamentoItem'
   FIELD idm                      AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD CodigoSolicitacaoInterna LIKE pagamento.nr-pagamento
   FIELD CodigoFornecedorEMS      LIKE pagamento.cod-emitente
   FIELD NomeAbreviadoFornecedor  LIKE emitente.nome-abrev
   FIELD MatriculaResponsavel     LIKE pagamento.usuario
   FIELD NomeResponsavel          LIKE usuar_mestre.nom_usuar
   FIELD StatusSolicitacaoInterna LIKE pagamento.ind-status-solicitacao
   FIELD CodigoCondicaoPagamento  LIKE pagamento.cod-cond-pag
   FIELD NomeCondicaoPagamento    LIKE cond-pagto.descricao
   FIELD DataEmissao              LIKE pagamento.data-emissao
   FIELD DataInclusao             LIKE pagamento.dat-fft
   FIELD DataFechamentoCambio     LIKE pagamento.dt-fecha-cam
   FIELD ValorTotalSolicitacao    LIKE pagamento.valor-pag
   FIELD CodigoEstabelecimento    LIKE pagamento.cod-estabel
   FIELD DataSwift                LIKE pagamento.data-swift
   FIELD CodigoMoedaEMS           LIKE cotacao-item.mo-codigo
   FIELD NomeMoeda                LIKE moeda.descricao
   FIELD CodigoDespachante        LIKE emitente.cod-emitente
   FIELD NomeDespachante          LIKE emitente.nome-abrev
   FIELD Urgente                  LIKE pagamento.log-urgente     
   FIELD PagamentoAntecipado      LIKE pagamento.log-pag-antecipado     
   FIELD DataAprovacao            LIKE pagamento.data-aprovacao
   FIELD NaturezaFinanceira       LIKE pagamento.ind-natureza
   FIELD MatriculaComprador       LIKE pagamento.cod-comprador
   FIELD NomeComprador            LIKE usuar_mestre.nom_usuar
   FIELD TipoSolicitacaoInterna   LIKE pagamento.tipo-ci
   FIELD PontoControleCondicaoPagamento LIKE pto-contr.descricao
   FIELD DataRecebimentoCIFinanceiro    LIKE int-hist-pagamento.dat-hist
   FIELD Reaprovada               LIKE pagamento.log-reaprovada
   FIELD CodigoUnidadeNegocio     LIKE unid_negoc.cod_unid_negoc
   FIELD DescricaoUnidadeNegocio  LIKE unid_negoc.des_unid_negoc.

DEFINE TEMP-TABLE Fatura NO-UNDO XML-NODE-NAME 'Fatura'
   FIELD CodigoSolicitacaoInterna LIKE pagamento.nr-pagamento XML-NODE-TYPE 'HIDDEN'
   FIELD NumeroEmbarque           LIKE pagamento-invoice.embarque
   FIELD CodigoEstabelecimento    LIKE pagamento.cod-estabel
   FIELD DataEmbarque             AS DATE
   FIELD NumeroInvoice            LIKE pagamento-invoice.nr-invoice
   FIELD ParcelaInvoice           LIKE pagamento-invoice.parcela
   FIELD DataVencimento           AS DATE
   FIELD ValorInvoice             AS DEC
   FIELD DataPrevisaoChegada      AS DATE
   FIELD CodigoItinerario         LIKE cotacao-item.int-1
   FIELD DescricaoItinerario      LIKE itinerario.descricao
   FIELD CodigoViaTransporte      LIKE embarque-imp.cod-via-transp
   FIELD Master                   LIKE embarque-imp.cod-conhecto-master
   FIELD House                    LIKE embarque-imp.cod-conhecto-house
   FIELD DISiscomex               LIKE embarque-imp.declaracao-import  
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
