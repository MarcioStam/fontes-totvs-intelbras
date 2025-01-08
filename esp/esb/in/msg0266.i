{esp/esb/esesb000.i}

/*Dataset Entrada*/
DEFINE TEMP-TABLE MSG0266 NO-UNDO XML-NODE-NAME 'MSG0266'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'.

DEFINE TEMP-TABLE AvaliacaoSolicitacaoInterna NO-UNDO XML-NODE-NAME 'HistoricoSolicitacaoInterna'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD CodigoSolicitacaoInterna LIKE pagamento.nr-pagamento
   FIELD StatusSolicitacaoInterna LIKE pagamento.ind-status-solicitacao
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
DEFINE TEMP-TABLE MSG0266R1 NO-UNDO XML-NODE-NAME 'MSG0266R1'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   .

/*Outras temp tables*/
DEFINE TEMP-TABLE tt-erro NO-UNDO
    FIELD mensagem AS CHARACTER FORMAT "x(250)".

DEFINE VARIABLE h-boes138 AS HANDLE      NO-UNDO.
{esbo/boes138.i tt-pagamento}
{method/dbotterr.i}
