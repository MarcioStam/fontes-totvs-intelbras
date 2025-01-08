&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOES564 2.00.00.000}                               
/*--------------------------------------------------------------------------
    File       : 
    Purpose    : O DBO (Datasul Business Objects) Ç um programa PROGRESS
                 que contÇm a l¢gica de neg¢cio e acesso a dados para uma
                 tabela do banco de dados.

    Parameters :

    Notes      :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */
 
/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName  BOES564
&GLOBAL-DEFINE DBOVersion  2.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName  correios-cartao
&GLOBAL-DEFINE TableLabel  Correios Cartao               
&GLOBAL-DEFINE QueryName qr{&TableName} 
 
/* DBO-XML-BEGIN */
/*:T Pre-processadores para ativar XML no DBO */
/*:T Retirar o comentario para ativar 
&GLOBAL-DEFINE XMLProducer YES    /*:T DBO atua como producer de mensagens para o Message Broker */
&GLOBAL-DEFINE XMLTopic           /*:T Topico da Mensagem enviada ao Message Broker, geralmente o nome da tabela */
&GLOBAL-DEFINE XMLTableName       /*:T Nome da tabela que deve ser usado como TAG no XML */ 
&GLOBAL-DEFINE XMLTableNameMult   /*:T Nome da tabela no plural. Usado para multiplos registros */ 
&GLOBAL-DEFINE XMLPublicFields    /*:T Lista dos campos (c1,c2) que podem ser enviados via XML. Ficam fora da listas os campos de especializacao da tabela */ 
&GLOBAL-DEFINE XMLKeyFields       /*:T Lista dos campos chave da tabela (c1,c2) */
&GLOBAL-DEFINE XMLExcludeFields   /*:T Lista de campos a serem excluidos do XML quando PublicFields = "" */
 
&GLOBAL-DEFINE XMLReceiver YES    /*:T DBO atua como receiver de mensagens enviado pelo Message Broker (mÇtodo Receive Message) */
&GLOBAL-DEFINE QueryDefault       /*:T Nome da Query que d† acessos a todos os registros, exceto os exclu°dos pela constraint de seguranáa. Usada para receber uma mensagem XML. */
&GLOBAL-DEFINE KeyField1 cust-num /*:T Informar os campos da chave quando o Progress n∆o conseguir resolver find {&TableName} OF RowObject. */
*/
/* DBO-XML-END */
 
/*:T--- Include com definiá∆o da temptable RowObject ---*/
/*:T--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{esbo/boes564.i RowObject}
 
 
/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}
 
 
/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.
/* ************************* Definiá∆o de vari†veis *********************** */
define variable v-nr-cartao as character no-undo.

define variable v-nr-cartao-ini   as character no-undo.
define variable v-nr-cartao-fim   as character no-undo.
define variable v-ct-codigo-ini   as character no-undo. 
define variable v-ct-codigo-fim   as character no-undo.

{upc/btb910za-upc.i} /* Definiá∆o da vari†vel New Global Shared "v_cod_estab_usuar" */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DBOProgram
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DBOProgram Template
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW DBOProgram ASSIGN
         HEIGHT             = 2
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "DBO 2.0 Wizard" DBOProgram _INLINE
/* Actions: wizard/dbowizard.w ? ? ? ? */
/* DBO 2.0 Wizard */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB DBOProgram 
/* ************************* Included-Libraries *********************** */
 
{method/dbo.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK DBOProgram 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getCharField DBOProgram 
PROCEDURE getCharField :
DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS CHARACTER NO-UNDO.                                                                       

    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "ct-codigo":U THEN ASSIGN pFieldValue = RowObject.ct-codigo.
        WHEN "nr-cartao":U THEN ASSIGN pFieldValue = RowObject.nr-cartao.
        OTHERWISE RETURN "NOK":U.
    END CASE.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GoToKey DBOProgram 
PROCEDURE GoToKey :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice ch-correios
  Parameters:  
               retorna valor do campo nr-cartao
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pnr-cartao LIKE correios-cartao.nr-cartao NO-UNDO.
    
    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
   
    FIND FIRST bfcorreios-cartao WHERE
               bfcorreios-cartao.nr-cartao = pnr-cartao NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfcorreios-cartao THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfcorreios-cartao)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

   
    RETURN "OK":U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQuery DBOProgram 
PROCEDURE openQuery :
DEFINE INPUT PARAMETER iAbertura AS INTEGER NO-UNDO.

    CASE iAbertura:
        WHEN 1 THEN
            RUN openQueryStatic ("Main":U).
        WHEN 2 THEN           
            RUN openQueryStatic ("Ch-correios-cartao":U).             
    END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryCh-correios-cartao DBOProgram 
PROCEDURE openQueryCh-correios-cartao :
OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
        WHERE {&TableName}.nr-cartao = v-nr-cartao                    
    .
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE openQueryMain :
OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryZoom1 DBOProgram 
PROCEDURE openQueryZoom1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK                 
        WHERE {&TableName}.nr-cartao   >= v-nr-cartao-ini
          AND {&TableName}.nr-cartao   <= v-nr-cartao-fim
          AND {&TableName}.ct-codigo >= v-ct-codigo-ini                           
          AND {&TableName}.ct-codigo <= v-ct-codigo-fim.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintCh-correios-cartao DBOProgram 
PROCEDURE setConstraintCh-correios-cartao :
DEFINE INPUT PARAMETER p-nr-cartao AS character NO-UNDO.                                                                        

    ASSIGN 
    v-nr-cartao = p-nr-cartao                                         
    .
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintMain DBOProgram 
PROCEDURE setConstraintMain :
RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintZoom1 DBOProgram 
PROCEDURE setConstraintZoom1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER p-nr-cartao-ini   AS character NO-UNDO.
DEFINE INPUT PARAMETER p-nr-cartao-fim   AS character NO-UNDO.
DEFINE INPUT PARAMETER p-ct-codigo-ini   AS character NO-UNDO.
DEFINE INPUT PARAMETER p-ct-codigo-fim   AS character NO-UNDO.
    
    ASSIGN  v-nr-cartao-ini  = p-nr-cartao-ini  
            v-nr-cartao-fim  = p-nr-cartao-fim  
            v-ct-codigo-ini  = p-ct-codigo-ini
            v-ct-codigo-fim  = p-ct-codigo-fim.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Validaá‰es pertinentes ao DBO
  Parameters:  recebe o tipo de validaá∆o (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.

    DEFINE VARIABLE i-cont AS INTEGER     NO-UNDO.
    DEFINE VARIABLE c-erro AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE de-tot-perc AS DECIMAL     NO-UNDO.

    CASE pType:
         WHEN "Create" THEN DO:
             IF CAN-FIND(FIRST bf{&TableName} NO-LOCK
                 WHERE bf{&TableName}.nr-cartao = RowObject.nr-cartao) THEN DO:
                 {method/svc/errors/inserr.i
                     &ErrorNumber="1"
                     &ErrorType="EMS"
                     &ErrorSubType="ERROR"
                     &ErrorParameters="'{&TableLabel}'"
                 }
             END.

         END.
         WHEN "Update" THEN DO:
             IF NOT CAN-FIND(FIRST bf{&TableName} NO-LOCK
                 WHERE bf{&TableName}.nr-cartao = RowObject.nr-cartao) THEN DO:
                 {method/svc/errors/inserr.i
                     &ErrorNumber="2"
                     &ErrorType="EMS"
                     &ErrorSubType="ERROR"
                     &ErrorParameters="'{&TableLabel}'"
                 }
             END.

         END.
         WHEN "Delete" THEN DO:
             IF NOT CAN-FIND(FIRST bf{&TableName} NO-LOCK
                 WHERE bf{&TableName}.nr-cartao = RowObject.nr-cartao) THEN DO:
                 {method/svc/errors/inserr.i
                     &ErrorNumber="2"
                     &ErrorType="EMS"
                     &ErrorSubType="ERROR"
                     &ErrorParameters="'{&TableLabel}'"
                 }
             END.

         END.
    END CASE.

    IF pType = "Create" OR
       pType = "Update"   
    THEN DO:
        EMPTY TEMP-TABLE tt_log_erro.

        FIND FIRST estabelec NO-LOCK
              WHERE estabelec.cod-estabel = v_cod_estab_usuar NO-ERROR.
        IF  AVAIL estabelec
        THEN DO:
             run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.
             run pi_valida_conta_contabil in h_api_cta_ctbl (input  estabelec.ep-codigo,         /* EMPRESA EMS2 */
                                                             input  v_cod_estab_usuar, /* ESTABELECIMENTO EMS2 */
                                                             input  "",                          /* UNIDADE NEG‡CIO */
                                                             input  "",                          /* PLANO CONTAS */ 
                                                             input  RowObject.ct-codigo,         /* CONTA */
                                                             input  "",                          /* PLANO CCUSTO */ 
                                                             input  "",                          /* CCUSTO */
                                                             input  today,                       /* DATA TRANSACAO */
                                                             output table tt_log_erro).          /* ERROS */
            for first tt_log_erro:
                {method/svc/errors/inserr.i &ErrorNumber="17006"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters=tt_log_erro.ttv_des_msg_erro}
            end.
    
            if valid-handle(h_api_cta_ctbl) 
            then
                delete object h_api_cta_ctbl.


            ASSIGN de-tot-perc = 0.

            run prgint\utb\utb742za.py persistent set h_api_ccusto.
            DO i-cont = 1 TO 10:
                ASSIGN de-tot-perc = de-tot-perc + RowObject.perc-rateio[i-cont].


                IF  RowObject.cc-codigo[i-cont] <> "" 
                THEN DO:
                    EMPTY TEMP-TABLE tt_log_erro.
                    run pi_busca_dados_ccusto in h_api_ccusto (input  estabelec.ep-codigo,          /* EMPRESA EMS2 */
                                                               input  "",                       /* CODIGO DO PLANO CCUSTO */
                                                               input  RowObject.cc-codigo[i-cont],         /* CCUSTO */
                                                               input  today,       /* DATA DE TRANSACAO */
                                                               output v_des_titulo_ccusto,    /* DESCRICAO DO CCUSTO */
                                                               output table tt_log_erro). /* ERROS */
                    
                    for each tt_log_erro no-lock:
                        {method/svc/errors/inserr.i &ErrorNumber=tt_log_erro.ttv_num_cod_erro
                                                    &ErrorType="EMS"
                                                    &ErrorSubType="ERROR"
                                                    &ErrorParameters=tt_log_erro.ttv_des_msg_erro}
                    End.
    
                    IF RowObject.perc-rateio[i-cont] = 0 THEN DO:
                        ASSIGN c-erro = "Percentual de rateio [" + STRING(i-cont) + "] n∆o informado para centro de custo informado.".
                        {method/svc/errors/inserr.i
                            &ErrorNumber="17006"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR"
                            &ErrorParameters=c-erro}
    
                    END.
                END.
                ELSE DO:
                    IF RowObject.perc-rateio[i-cont] <> 0 THEN DO:
                        ASSIGN c-erro = "Percentual de rateio [" + STRING(i-cont) + "] para centro de custo n∆o informado.".
                        {method/svc/errors/inserr.i
                            &ErrorNumber="17006"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR"
                            &ErrorParameters=c-erro}
                    END.
                END.
            END.
            IF  VALID-HANDLE(h_api_ccusto)
            THEN
                delete object h_api_ccusto.
    
            IF de-tot-perc <> 100  THEN DO:
                {method/svc/errors/inserr.i
                    &ErrorNumber="17006"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters="'Soma dos percentuais de rateio deve ser 100.'"}
    
            END.
        END. /* IF  AVAIL estabelec */
        ELSE DO:
             ASSIGN c-erro = "Estabelecimento (" + v_cod_estab_usuar + ") n∆o cadastrado.".
            {method/svc/errors/inserr.i
                &ErrorNumber="17006"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorParameters=c-erro}
        END.
    END. /* IF pType = "Create" OR */

    /*:T--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*:T--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as validaá‰es ---*/
    
    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

