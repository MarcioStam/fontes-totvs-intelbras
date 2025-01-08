{esp/esb/esesb000.i}

/*Dataset Entrada*/
DEFINE TEMP-TABLE MSG0237 NO-UNDO XML-NODE-NAME 'MSG0237'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   .

DEFINE TEMP-TABLE MSG_Acoes NO-UNDO XML-NODE-NAME 'Acoes'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD CodigoEstabelecimento       LIKE int-criticidade-item.cod-estabel
   FIELD CodigoPlano                 LIKE int-criticidade-item.cd-plano
   FIELD CodigoProduto               LIKE int-criticidade-item.it-codigo
   FIELD DataCalculoCriticidade      LIKE int-criticidade-item.data-calculo
   FIELD SequenciaCalculoCriticidade LIKE int-criticidade-item.sequencia
   FIELD MatriculaUsuario            AS CHARACTER
   FIELD NomeUsuario                 AS CHARACTER
   FIELD ComentarioAcao              AS CHARACTER
   .

/*Dataset Retorno*/
DEFINE TEMP-TABLE MSG0237R1 NO-UNDO XML-NODE-NAME 'MSG0237R1'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'.

 

/*Outras temp tables*/
DEFINE TEMP-TABLE tt-erro NO-UNDO
    FIELD mensagem AS CHARACTER FORMAT "x(250)".


