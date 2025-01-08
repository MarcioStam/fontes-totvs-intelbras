{esp/esb/esesb000.i}

/*Dataset Entrada*/
DEFINE TEMP-TABLE MSG0256 NO-UNDO XML-NODE-NAME 'MSG0256'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD CodigoSolicitacaoInterna    LIKE pagamento.nr-pagamento
   FIELD Recebida                    LIKE pagamento.recebido-ap
   FIELD MatriculaUsuarioRecebimento AS CHAR 
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
   FIELD ValorContrato               LIKE pagamento.valor-contrato
   FIELD ValorOrdem                  LIKE pagamento.valor-ord-pag
   FIELD CodigoMoedaEMS              LIKE pagamento.cod-moeda
   FIELD ValorFechamento             LIKE pagamento.valor-fechamento
   FIELD DataFechamentoCambio        LIKE pagamento.dt-fecha-cam
   FIELD NaturezaFinanceira          LIKE pagamento.ind-natureza
   FIELD CreditNote                  LIKE pagamento.val-credit-note
   FIELD Ptax                        LIKE pagamento.val-taxa-ptax
   FIELD CustoFftLcUsd               LIKE pagamento.val-custo-fft-lc-usd
   FIELD CustoFftLcRs                LIKE pagamento.val-custo-fft-lc-rs
   FIELD DataDebitoCustoFftLc        LIKE pagamento.dat-custo-fft-lc.

DEFINE TEMP-TABLE HistoricoSolicitacaoInterna NO-UNDO XML-NODE-NAME 'HistoricoSolicitacaoInterna'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD MatriculaUsuario    LIKE int-hist-pagamento.cod-usuario  
   FIELD DataHistorico       LIKE int-hist-pagamento.dat-hist     
   FIELD HoraHistorico       LIKE int-hist-pagamento.hor-hist     
   FIELD AcaoHistorico       LIKE int-hist-pagamento.ind-acao     
   FIELD ObservacaoHistorico LIKE int-hist-pagamento.txt-historico
   .

/*Dataset Retorno*/
DEFINE TEMP-TABLE MSG0256R1 NO-UNDO XML-NODE-NAME 'MSG0256R1'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   .

/*Outras temp tables*/
DEFINE TEMP-TABLE tt-erro NO-UNDO
    FIELD mensagem AS CHARACTER FORMAT "x(250)".

DEFINE VARIABLE h-boes138 AS HANDLE      NO-UNDO.
{esbo/boes138.i tt-pagamento}
{method/dbotterr.i}
