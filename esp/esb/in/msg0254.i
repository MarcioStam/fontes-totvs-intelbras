{esp/esb/esesb000.i}

/*Dataset Entrada*/
DEFINE TEMP-TABLE MSG0254 NO-UNDO XML-NODE-NAME 'MSG0254'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD CodigoSolicitacaoInterna    LIKE pagamento.nr-pagamento INITIAL ?
   FIELD DataEmissao                 LIKE pagamento.data-ci
   FIELD PrevFechaCambio             LIKE pagamento.dt-prev-fecha-cam
   FIELD Urgente                     LIKE pagamento.log-urgente
   FIELD CodigoFornecedorEMS         LIKE pagamento.cod-emitente
   FIELD CodigoEstabelecimento       LIKE pagamento.cod-estabel
   FIELD ValorSolicitacaoInterna     LIKE pagamento.valor-pag
   FIELD CodigoMoedaEMS              LIKE pagamento.cod-moeda
   FIELD TipoSolicitacaoInterna      LIKE pagamento.tipo-ci   
   FIELD StatusSolicitacaoInterna    LIKE pagamento.ind-status-solicitacao
   FIELD CodigoCondicaoPagamento     LIKE pagamento.cod-cond-pag
   FIELD CodigoTipoDespesa           LIKE pagamento.tipo-despesa
   FIELD MatriculaResponsavel        LIKE pagamento.usuario
   FIELD MatriculaComprador          LIKE pagamento.cod-comprador
   FIELD PossuiAnexos                AS LOG
   FIELD Observacoes                 LIKE pagamento.txt-observacao
   FIELD PagamentoAntecipado         LIKE pagamento.log-pag-antecipado
   FIELD HistoricoSolicitacaoInterna LIKE pagamento.historico
   FIELD CodigoDespachante           LIKE pagamento.cod-despachante
   .

DEFINE TEMP-TABLE HistoricoSolicitacaoInterna NO-UNDO XML-NODE-NAME 'HistoricoSolicitacaoInterna'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD MatriculaUsuario    LIKE int-hist-pagamento.cod-usuario  
   FIELD DataHistorico       LIKE int-hist-pagamento.dat-hist     
   FIELD HoraHistorico       LIKE int-hist-pagamento.hor-hist     
   FIELD AcaoHistorico       LIKE int-hist-pagamento.ind-acao     
   FIELD ObservacaoHistorico LIKE int-hist-pagamento.txt-historico
   .
/*Dataset Retorno*/
DEFINE TEMP-TABLE MSG0254R1 NO-UNDO XML-NODE-NAME 'MSG0254R1'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD CodigoSolicitacaoInterna     LIKE pagamento.nr-pagamento
   .

/*Outras temp tables*/
DEFINE TEMP-TABLE tt-erro NO-UNDO
    FIELD mensagem AS CHARACTER FORMAT "x(250)".

DEFINE VARIABLE h-boes138 AS HANDLE      NO-UNDO.
{esbo/boes138.i tt-pagamento}
{method/dbotterr.i}
