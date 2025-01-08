{esp/esb/esesb000.i}

/*Dataset Entrada*/
DEFINE TEMP-TABLE MSG0291 NO-UNDO XML-NODE-NAME 'MSG0291'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD CodigoAgendamento       AS INTEGER
   FIELD NumeroOrdemCompra       LIKE prazo-compra.numero-ordem
   FIELD SequenciaParcela        LIKE prazo-compra.parcela.

/*Dataset Retorno*/
DEFINE TEMP-TABLE MSG0291_R1 NO-UNDO XML-NODE-NAME 'MSG0291R1'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'.

DEFIN TEMP-TABLE InspecaoAgendada NO-UNDO XML-NODE-NAME 'InspecaoAgendada'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD CodigoAgendamento       AS INTEGER
   FIELD NumeroOrdemCompra       LIKE prazo-compra.numero-ordem
   FIELD SequenciaParcela        LIKE prazo-compra.parcela
   FIELD DataAgendamentoInspecao LIKE historico-inspecao.data-prev-inspec      
   FIELD DuracaoAgendamento      LIKE historico-inspecao.duracao-agendamento   
   FIELD DataExecucaoInspecao    LIKE historico-inspecao.data-inspec           
   FIELD DuracaoExecucao         LIKE historico-inspecao.duracao-execucao      
   FIELD StatusInspecao          LIKE historico-inspecao.status-inspec         
   FIELD ObservacoesInspecao     LIKE historico-inspecao.obs-inspec
   FIELD QuantidadeAgendada      LIKE historico-inspecao.qtd-agendada
   FIELD QuantidadeInspecionada  LIKE historico-inspecao.qtd-inspecionada
   FIELD CodigoInspetor          LIKE historico-inspecao.cod-inspetor          
   FIELD NomeInspetor            LIKE historico-inspecao.nome-inspetor         
   FIELD RegiaoInspecao          LIKE historico-inspecao.regiao-inspec
   FIELD RegistroRemovido        AS LOGICAL
   FIELD MotivoAcao              AS INTEGER
   FIELD MatriculaUsuario        AS CHAR 
   FIELD DataHistorico           AS DATE INIT ?
   FIELD HoraHistorico           AS CHAR
   FIELD Sequencia               AS INTEGER.


/*Outras temp tables*/
DEFINE TEMP-TABLE tt-erro NO-UNDO
    FIELD mensagem AS CHARACTER FORMAT "x(250)".
