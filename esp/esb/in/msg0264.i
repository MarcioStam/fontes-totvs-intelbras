{esp/esb/esesb000.i}

/*Dataset Entrada*/
DEFINE TEMP-TABLE MSG0264 NO-UNDO XML-NODE-NAME 'MSG0264'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD CodigoSwift              LIKE pagamento.swift        INITIAL ?
   .

DEFINE TEMP-TABLE SolicitacaoInternaSwift NO-UNDO XML-NODE-NAME 'SolicitacaoInternaSwift'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD CodigoSolicitacaoInterna LIKE pagamento.nr-pagamento  INITIAL ?
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
DEFINE TEMP-TABLE MSG0264R1 NO-UNDO XML-NODE-NAME 'MSG0264R1'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'.

/*Outras temp tables*/
DEFINE TEMP-TABLE tt-erro NO-UNDO
    FIELD mensagem AS CHARACTER FORMAT "x(250)".
