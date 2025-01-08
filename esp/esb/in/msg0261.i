{esp/esb/esesb000.i}

/*Dataset Entrada*/
DEFINE TEMP-TABLE MSG0261 NO-UNDO XML-NODE-NAME 'MSG0261'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD CodigoSwift              LIKE pagamento.swift         INITIAL ?
   FIELD CodigoSolicitacaoInterna LIKE pagamento.nr-pagamento  INITIAL ?
   FIELD CodigoFornecedorEMS      LIKE pagamento.cod-emitente  INITIAL ?
   FIELD CodigoEstabelecimento    LIKE pagamento.cod-estabel   INITIAL ?
   FIELD MatriculaResponsavel     LIKE pagamento.usuar-receb   INITIAL ?
   FIELD CodigoCondicaoPagamento  LIKE pagamento.cod-cond-pag  INITIAL ?
   FIELD DataInicialPeriodo       LIKE pagamento.data-swift    INITIAL ?
   FIELD DataFinalPeriodo         LIKE pagamento.data-swift    INITIAL ?
   .

/*Dataset Retorno*/
DEFINE TEMP-TABLE MSG0261R1 NO-UNDO XML-NODE-NAME 'MSG0261R1'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'.

DEFINE TEMP-TABLE SwiftItem NO-UNDO XML-NODE-NAME 'SwiftItem'
    FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
    FIELD CodigoSwift LIKE pagamento.swift         INITIAL ?
    FIELD DataSwift   LIKE pagamento.data-swift
    .

DEFINE TEMP-TABLE SwiftPagamento NO-UNDO XML-NODE-NAME 'SwiftPagamento'
    FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
    FIELD CodigoSwift              LIKE pagamento.swift         XML-NODE-TYPE 'HIDDEN'
    FIELD CodigoSolicitacaoInterna LIKE pagamento.nr-pagamento  INITIAL ?
    FIELD CodigoFornecedorEMS      LIKE pagamento.cod-emitente  INITIAL ?
    FIELD NomeAbreviadoFornecedor  LIKE emitente.nome-abrev     INITIAL ?
    .

/*Outras temp tables*/
DEFINE TEMP-TABLE tt-erro NO-UNDO
    FIELD mensagem AS CHARACTER FORMAT "x(250)".
