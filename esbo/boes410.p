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
{include/i-prgvrs.i BOES410 2.00.00.000}                               
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
&GLOBAL-DEFINE DBOName  BOES410
&GLOBAL-DEFINE DBOVersion  2.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName  cc-equipamentos
&GLOBAL-DEFINE TableLabel  Centro Custo Equipamentos     
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
{esbo/boes410.i RowObject}
 
 
/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}
{utp/ut-glob.i} 
{upc/btb910za-upc.i}
 
/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.
/* ************************* Definiá∆o de vari†veis *********************** */
define variable v-cod-estabel as character no-undo.
define variable v-equipamento as character no-undo.
define variable v-cc-codigo as character no-undo.

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
   Other Settings: CODE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW DBOProgram ASSIGN
         HEIGHT             = 11.17
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
        WHEN "cc-codigo":U THEN ASSIGN pFieldValue = RowObject.cc-codigo.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "equipamento":U THEN ASSIGN pFieldValue = RowObject.equipamento.
        WHEN "cod-unidade-negocio":U THEN ASSIGN pFieldValue = RowObject.cod-unid-negoc.
        OTHERWISE RETURN "NOK":U.
    END CASE.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDecField DBOProgram 
PROCEDURE getDecField :
DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DECIMAL NO-UNDO.                                                                         

    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "per-rateio":U THEN ASSIGN pFieldValue = RowObject.per-rateio.
        OTHERWISE RETURN "NOK":U.
    END CASE.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
DEFINE INPUT PARAMETER p-cod-estabel AS character NO-UNDO.                                                                      
    DEFINE INPUT PARAMETER p-equipamento AS character NO-UNDO.                                                                      
    DEFINE INPUT PARAMETER p-cc-codigo AS character NO-UNDO.                                                                        

    FIND bf{&TableName} NO-LOCK
        WHERE bf{&TableName}.cod-estabel = p-cod-estabel              
        AND bf{&TableName}.equipamento = p-equipamento                
        AND bf{&TableName}.cc-codigo = p-cc-codigo                    
        NO-ERROR.
    IF NOT AVAILABLE bf{&TableName} THEN RETURN "NOK":U.
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bf{&TableName})).
    IF RETURN-VALUE = "NOK":U THEN RETURN "NOK":U.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToEquipamentos DBOProgram 
PROCEDURE linkToEquipamentos :
DEFINE INPUT PARAMETER pHandle AS HANDLE NO-UNDO.
   
   RUN getKey IN pHandle (OUTPUT v-cod-estabel,
                          OUTPUT v-equipamento).
   
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
            RUN openQueryStatic ("Ch-chave":U).                       
    END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryCcEquipamentos DBOProgram 
PROCEDURE openQueryCcEquipamentos :
OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
         WHERE {&TableName}.cod-estabel = v-cod-estabel
           AND {&TableName}.equipamento = v-equipamento.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryCh-chave DBOProgram 
PROCEDURE openQueryCh-chave :
OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
        WHERE {&TableName}.cod-estabel = v-cod-estabel                
        AND {&TableName}.equipamento = v-equipamento                  
        AND {&TableName}.cc-codigo = v-cc-codigo                      
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintCh-chave DBOProgram 
PROCEDURE setConstraintCh-chave :
DEFINE INPUT PARAMETER p-cod-estabel AS character NO-UNDO.                                                                      
    DEFINE INPUT PARAMETER p-equipamento AS character NO-UNDO.                                                                      
    DEFINE INPUT PARAMETER p-cc-codigo AS character NO-UNDO.                                                                        

    ASSIGN 
    v-cod-estabel = p-cod-estabel                                     
    v-equipamento = p-equipamento                                     
    v-cc-codigo = p-cc-codigo                                         
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Validaá‰es pertinentes ao DBO
  Parameters:  recebe o tipo de validaá∆o (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.

    DEFINE VARIABLE dePercRateioTotal LIKE {&TableName}.per-rateio NO-UNDO.

    CASE pType:
         WHEN "Create" THEN DO:
             IF CAN-FIND(FIRST bf{&TableName} NO-LOCK
                 WHERE bf{&TableName}.cod-estabel = RowObject.cod-estabel
                   AND bf{&TableName}.cod-estabel-rateio = RowObject.cod-estabel-rateio
                   AND bf{&TableName}.equipamento = RowObject.equipamento
                   AND bf{&TableName}.cc-codigo = RowObject.cc-codigo) THEN DO:
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
                 WHERE bf{&TableName}.cod-estabel = RowObject.cod-estabel
                   AND bf{&TableName}.cod-estabel-rateio = RowObject.cod-estabel-rateio
                   AND bf{&TableName}.equipamento = RowObject.equipamento
                   AND bf{&TableName}.cc-codigo = RowObject.cc-codigo) THEN DO:
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
                 WHERE bf{&TableName}.cod-estabel = RowObject.cod-estabel
                   AND bf{&TableName}.cod-estabel-rateio = RowObject.cod-estabel-rateio
                   AND bf{&TableName}.equipamento = RowObject.equipamento
                   AND bf{&TableName}.cc-codigo = RowObject.cc-codigo) THEN DO:
                 {method/svc/errors/inserr.i
                     &ErrorNumber="2"
                     &ErrorType="EMS"
                     &ErrorSubType="ERROR"
                     &ErrorParameters="'{&TableLabel}'"
                 }
             END.

         END.
    END CASE.

    
    /*:T--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*:T--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as validaá‰es ---*/
    IF pType = "Create" OR pType = "Update" THEN DO:
        /*Validaá‰es de Campos*/
        IF NOT CAN-FIND(FIRST estabelec NO-LOCK
                        WHERE estabelec.cod-estabel = RowObject.cod-estabel) THEN DO:
            {method/svc/errors/inserr.i
                &ErrorNumber="17006"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorParameters="'Estabelecimento inv†lido.~~~~Estabelecimento n∆o cadastrado.'"}
        END.

        IF NOT CAN-FIND(FIRST equipamentos NO-LOCK
                        WHERE equipamentos.equipamento = RowObject.equipamento) THEN DO:
            {method/svc/errors/inserr.i
                &ErrorNumber="17006"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorParameters="'Equipamento inv†lido.~~~~Equipamento n∆o cadastrado.'"}
        END.

        IF NOT CAN-FIND(FIRST unid_negoc NO-LOCK
                        WHERE unid_negoc.cod_unid_negoc = RowObject.cod-unid-negoc) THEN DO:
            {method/svc/errors/inserr.i
                &ErrorNumber="17006"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorParameters="'Equipamento inv†lido.~~~~Equipamento n∆o cadastrado.'"}
        END.

        EMPTY TEMP-TABLE tt_log_erro.
        run prgint\utb\utb742za.py persistent set h_api_ccusto.
            
        run pi_busca_dados_ccusto in h_api_ccusto (input  i-ep-codigo-usuario,    /* EMPRESA EMS2 */
                                                   input  "",                     /* CODIGO DO PLANO CCUSTO */
                                                   input  RowObject.cc-codigo,    /* CCUSTO */
                                                   input  today,                  /* DATA DE TRANSACAO */
                                                   output v_des_titulo_ccusto,    /* DESCRICAO DO CCUSTO */
                                                   output table tt_log_erro).     /* ERROS */
        
        for each tt_log_erro no-lock:
            RUN _insertErrorManual IN THIS-PROCEDURE (INPUT 17006,
                                       				  INPUT "EMS":U,
                                                      INPUT "ERROR":U,
                                                      INPUT tt_log_erro.ttv_des_msg_erro + ' ('  + string(tt_log_erro.ttv_num_cod_erro) + ')',
                                                      INPUT tt_log_erro.ttv_des_msg_ajuda,
                                                      INPUT "":U).
        end.	


        EMPTY TEMP-TABLE tt_log_erro.
        EMPTY TEMP-TABLE tt_ccusto_integr.
        run pi_busca_ccustos_integr in h_api_ccusto (input  i-ep-codigo-usuario,      /* EMPRESA EMS2 */
                                                     input  "",                       /* CODIGO DO PLANO CCUSTO */
                                                     input  RowObject.cod-unid-negoc, /* Unidade Neg¢cio */
                                                     input  today,                    /* DATA DE TRANSACAO */
                                                     output TABLE tt_ccusto_integr,   /* Temp-table com c-CCUSTO */
                                                     output table tt_log_erro).       /* ERROS */
        
        for each tt_log_erro no-lock:
            RUN _insertErrorManual IN THIS-PROCEDURE (INPUT 17006,
                                       				  INPUT "EMS":U,
                                                      INPUT "ERROR":U,
                                                      INPUT tt_log_erro.ttv_des_msg_erro + ' ('  + string(tt_log_erro.ttv_num_cod_erro) + ')',
                                                      INPUT tt_log_erro.ttv_des_msg_ajuda,
                                                      INPUT "":U).
        end.

        IF NOT CAN-FIND(FIRST tt_ccusto_integr NO-LOCK
                        WHERE tt_ccusto_integr.ttv_cod_ccusto = RowObject.cc-codigo) 
        THEN DO:
            {method/svc/errors/inserr.i
                &ErrorNumber="17006"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorParameters="'Unidade de neg¢cios inv†lida..~~~~O centro de custos e unidade de neg¢cio informados n∆o est∆o relacionados.'"}
        END.

        delete object h_api_ccusto.

        ASSIGN dePercRateioTotal = RowObject.per-rateio.

        FOR EACH bf{&TableName} NO-LOCK
            WHERE bf{&TableName}.cod-estabel = RowObject.cod-estabel
              AND bf{&TableName}.equipamento = RowObject.equipamento:
            IF ROWID(bf{&TableName}) <> RowObject.r-rowid THEN
                ASSIGN dePercRateioTotal = dePercRateioTotal + bf{&TableName}.per-rateio.
        END.

        IF dePercRateioTotal > 100 THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="17006"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="'Total do Percentual de Rateio maior que 100%~~~~Percentual de Rateio Total do Equipamento ' + TRIM(STRING(RowObject.equipamento)) + ', Estabelecimento ' + TRIM(STRING(RowObject.cod-estabel)) + ' ultrapassou o limite de 100%. Favor preencher o valor correto.'"}
        END.
    END.
    
    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

