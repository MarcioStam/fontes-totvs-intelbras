{esp/esb/esesb000.i}

/*Dataset Entrada*/
DEFINE TEMP-TABLE MSG0238 NO-UNDO XML-NODE-NAME 'MSG0238'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD CodigoEstabelecimento       LIKE int-criticidade-item.cod-estabel
   FIELD CodigoPlano                 LIKE int-criticidade-item.cd-plano
   FIELD CodigoProduto               LIKE int-criticidade-item.it-codigo
   FIELD DataInicialPeriodo          LIKE int-criticidade-item.data-calculo
   FIELD DataFinalPeriodo            LIKE int-criticidade-item.data-calculo
   .

/*Dataset Retorno*/
DEFINE TEMP-TABLE MSG0238R1 NO-UNDO XML-NODE-NAME 'MSG0238R1'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'.

DEFINE TEMP-TABLE MSG_Acao_R1 NO-UNDO XML-NODE-NAME 'Acoes'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD CodigoEstabelecimento       LIKE int-criticidade-item.cod-estabel
   FIELD CodigoPlano                 LIKE int-criticidade-item.cd-plano   
   FIELD CodigoProduto               LIKE int-criticidade-item.it-codigo  
   FIELD DataCalculoCriticidade      LIKE int-criticidade-item.data-calculo
   FIELD SequenciaCalculoCriticidade LIKE int-criticidade-item.sequencia
   FIELD MatriculaUsuario            LIKE int-acao-criticidade-item.autor-acao
   FIELD NomeUsuario                 LIKE int-acao-criticidade-item.nome-autor-acao
   FIELD ComentarioAcao              LIKE int-acao-criticidade-item.comentario-acao
   FIELD DataComentario              LIKE int-acao-criticidade-item.data-acao
   FIELD HoraComentario              LIKE int-acao-criticidade-item.hora-acao
   FIELD NivelCriticidade            LIKE int-criticidade-item.nivel-criticidade
   FIELD QuantidadeFalta             LIKE int-falta-criticidade-item.quantidade-falta
   .



/*Outras temp tables*/
DEFINE TEMP-TABLE tt-erro NO-UNDO
    FIELD mensagem AS CHARACTER FORMAT "x(250)".


define variable c-cod-estab-ini  as character no-undo.
define variable c-cod-estab-fim  as character no-undo.
define variable i-cd-plano-ini   as INTEGER   no-undo.
define variable i-cd-plano-fim   as INTEGER   no-undo.
define variable c-cd-produto-ini as character no-undo.
define variable c-cd-produto-fim as character no-undo.
define variable d-data-ini       as DATE      no-undo.
define variable d-data-fim       as DATE      no-undo.









