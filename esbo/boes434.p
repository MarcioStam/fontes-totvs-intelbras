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
{include/i-prgvrs.i BOES434 2.00.00.000}                               
/*--------------------------------------------------------------------------
    File       : 
    Purpose    : O DBO (Datasul Business Objects) ‚ um programa PROGRESS
                 que cont‚m a l¢gica de neg¢cio e acesso a dados para uma
                 tabela do banco de dados.

    Parameters :

    Notes      :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */
 
/*:T--- Diretrizes de defini‡Æo ---*/
&GLOBAL-DEFINE DBOName  BOES434
&GLOBAL-DEFINE DBOVersion  2.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName  int-nota-conhec
&GLOBAL-DEFINE TableLabel  Int Nota Conhec               
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
 
&GLOBAL-DEFINE XMLReceiver YES    /*:T DBO atua como receiver de mensagens enviado pelo Message Broker (m‚todo Receive Message) */
&GLOBAL-DEFINE QueryDefault       /*:T Nome da Query que d  acessos a todos os registros, exceto os exclu¡dos pela constraint de seguran‡a. Usada para receber uma mensagem XML. */
&GLOBAL-DEFINE KeyField1 cust-num /*:T Informar os campos da chave quando o Progress nÆo conseguir resolver find {&TableName} OF RowObject. */
*/
/* DBO-XML-END */
 
/*:T--- Include com defini‡Æo da temptable RowObject ---*/
/*:T--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idˆntico ao nome do DBO mas com 
      extensÆo .i ---*/
/*{esbo/boes434.i RowObject}*/
DEFINE TEMP-TABLE RowObject NO-UNDO LIKE int-nota-conhec
    FIELD r-Rowid AS ROWID.
 
 
/*:T--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo 
      manual da query ---*/
{method/dboqry.i}
 
 
/*:T--- Defini‡Æo de buffer que ser  utilizado pelo m‚todo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.
/* ************************* Defini‡Æo de vari veis *********************** */
define variable v-cod-estabel as character no-undo.
define variable v-serie as character no-undo.
define variable v-nr-nota-fis as character no-undo.
define variable v-nr-conhec as character no-undo.
define variable v-nr-volume as INTEGER  NO-UNDO.
 

define variable v-cod-estabel-ini as character no-undo.
define variable v-cod-estabel-fim as character no-undo.
define variable v-serie-ini       as character no-undo.
define variable v-serie-fim       as character no-undo.
define variable v-nr-nota-fis-ini as character no-undo.
define variable v-nr-nota-fis-fim as character no-undo.
define variable v-nr-conhec-ini   as character no-undo.
define variable v-nr-conhec-fim   as character no-undo.
define variable v-nr-volume-ini   as INTEGER   no-undo.
define variable v-nr-volume-fim   as INTEGER   no-undo.

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
         HEIGHT             = 4.38
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterCreateRecord DBOProgram 
PROCEDURE afterCreateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    RUN pi-atualiza-dados.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDeleteRecord DBOProgram 
PROCEDURE afterDeleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    RUN pi-atualiza-dados.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterUpdateRecord DBOProgram 
PROCEDURE afterUpdateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    RUN pi-atualiza-dados.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getCharField DBOProgram 
PROCEDURE getCharField :
DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS CHARACTER NO-UNDO.                                                                       

    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "nr-conhec":U THEN ASSIGN pFieldValue   = RowObject.nr-conhec.
        WHEN "nr-nota-fis":U THEN ASSIGN pFieldValue = RowObject.nr-nota-fis.
        WHEN "serie":U THEN ASSIGN pFieldValue = RowObject.serie.
        OTHERWISE RETURN "NOK":U.
    END CASE.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
DEFINE INPUT PARAMETER p-cod-estabel AS character NO-UNDO.                                                                      
    DEFINE INPUT PARAMETER p-serie       AS character NO-UNDO.                                                                            
    DEFINE INPUT PARAMETER p-nr-nota-fis AS character NO-UNDO.                                                                      
    DEFINE INPUT PARAMETER p-nr-volume   AS integer   no-undo.
                                                                     

    FIND first bf{&TableName} NO-LOCK
        WHERE bf{&TableName}.cod-estabel = p-cod-estabel              
        AND bf{&TableName}.serie         = p-serie                            
        AND bf{&TableName}.nr-nota-fis   = p-nr-nota-fis      
        and bf{&TableName}.nr-volume     = p-nr-volume
        NO-ERROR.
    IF NOT AVAILABLE bf{&TableName} THEN RETURN "NOK":U.
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bf{&TableName})).
    IF RETURN-VALUE = "NOK":U THEN RETURN "NOK":U.
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
        WHEN 3 THEN           
            RUN openQueryStatic ("Ch-conhecimento":U).                
    END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryCh-chave DBOProgram 
PROCEDURE openQueryCh-chave :
OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
        WHERE {&TableName}.cod-estabel = v-cod-estabel                
        AND {&TableName}.serie         = v-serie                              
        AND {&TableName}.nr-nota-fis   = v-nr-nota-fis                  
        AND {&TableName}.nr-volume     = v-nr-volume
    .
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryCh-conhecimento DBOProgram 
PROCEDURE openQueryCh-conhecimento :
OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
        WHERE {&TableName}.nr-conhec = v-nr-conhec                    
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
OPEN QUERY {&QueryName} FOR EACH {&TableName} USE-INDEX ch-principal NO-LOCK
        WHERE {&TableName}.cod-estabel >= v-cod-estabel-ini
          AND {&TableName}.cod-estabel <= v-cod-estabel-fim
          AND {&TableName}.serie       >= v-serie-ini
          AND {&TableName}.serie       <= v-serie-fim
          AND {&TableName}.nr-nota-fis >= v-nr-nota-fis-ini
          AND {&TableName}.nr-nota-fis <= v-nr-nota-fis-fim
          AND {&TableName}.nr-volume   >= v-nr-volume-ini
          AND {&TableName}.nr-volume   <= v-nr-volume-fim
          AND {&TableName}.nr-conhec   >= v-nr-conhec-ini
          AND {&TableName}.nr-conhec   <= v-nr-conhec-fim
       /* BY {&TableName}.cod-estabel
        BY {&TableName}.serie      
        BY {&TableName}.nr-nota-fis
        BY {&TableName}.nr-volume  
        BY {&TableName}.nr-conhec*/  INDEXED-REPOSITION.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryZoom2 DBOProgram 
PROCEDURE openQueryZoom2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


    OPEN QUERY {&QueryName} FOR EACH {&TableName} USE-INDEX ch-principal NO-LOCK
        WHERE {&TableName}.cod-estabel >= v-cod-estabel-ini
          AND {&TableName}.cod-estabel <= v-cod-estabel-fim
          AND {&TableName}.serie       >= v-serie-ini
          AND {&TableName}.serie       <= v-serie-fim
          AND {&TableName}.nr-nota-fis >= v-nr-nota-fis-ini
          AND {&TableName}.nr-nota-fis <= v-nr-nota-fis-fim
          AND {&TableName}.nr-volume   >= v-nr-volume-ini
          AND {&TableName}.nr-volume   <= v-nr-volume-fim
          AND {&TableName}.nr-conhec   >= v-nr-conhec-ini
          AND {&TableName}.nr-conhec   <= v-nr-conhec-fim
          BY {&TableName}.nr-conhec INDEXED-REPOSITION.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-dados DBOProgram 
PROCEDURE pi-atualiza-dados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-conhec AS CHARACTER   NO-UNDO.

    ASSIGN c-conhec = "".

    FIND FIRST nota-fiscal NO-LOCK
         WHERE nota-fiscal.cod-estabel = RowObject.cod-estabel 
           AND nota-fiscal.serie       = RowObject.serie
           AND nota-fiscal.nr-nota-fis = RowObject.nr-nota-fis NO-ERROR.
    IF AVAIL nota-fiscal THEN DO:
        FIND FIRST ped-venda NO-LOCK
             WHERE ped-venda.nr-pedcli = nota-fiscal.nr-pedcli NO-ERROR.
        IF AVAIL ped-venda THEN DO:
            FIND FIRST int-ped-venda EXCLUSIVE-LOCK
                 WHERE int-ped-venda.cod-estabel = ped-venda.cod-estabel
                   AND int-ped-venda.nr-pedido   = ped-venda.nr-pedido NO-ERROR.
            IF AVAIL int-ped-venda THEN DO:
                FOR EACH bf{&TableName} NO-LOCK 
                   WHERE bf{&TableName}.cod-estabel = RowObject.cod-estabel
                     AND bf{&TableName}.serie       = RowObject.serie      
                     AND bf{&TableName}.nr-nota-fis = RowObject.nr-nota-fis:
                    IF c-conhec = "" THEN
                        ASSIGN c-conhec = bf{&TableName}.nr-conhec.
                    ELSE
                        ASSIGN c-conhec = c-conhec + ", " + TRIM(STRING(bf{&TableName}.nr-conhec,"x(16)")).
                END.

                ASSIGN int-ped-venda.Sedex         = c-conhec
                       int-ped-venda.atualizaIkeda = YES.
                RELEASE int-ped-venda.
            END.
        END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintCh-chave DBOProgram 
PROCEDURE setConstraintCh-chave :
DEFINE INPUT PARAMETER p-cod-estabel AS character NO-UNDO.                                                                      
    DEFINE INPUT PARAMETER p-serie       AS character NO-UNDO.                                                                            
    DEFINE INPUT PARAMETER p-nr-nota-fis AS character NO-UNDO.                                                                      
    DEFINE INPUT PARAMETER p-nr-volume AS INTEGER  NO-UNDO.                                                                        

    ASSIGN 
    v-cod-estabel = p-cod-estabel                                     
    v-serie       = p-serie                                                 
    v-nr-nota-fis = p-nr-nota-fis                                     
    v-nr-volume = p-nr-volume                                         
    .
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintCh-conhecimento DBOProgram 
PROCEDURE setConstraintCh-conhecimento :
DEFINE INPUT PARAMETER p-nr-conhec AS character NO-UNDO.                                                                        

    ASSIGN 
    v-nr-conhec = p-nr-conhec                                         
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
DEFINE INPUT PARAMETER p-cod-estabel-ini AS character NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-estabel-fim AS character NO-UNDO.
    DEFINE INPUT PARAMETER p-serie-ini       AS character NO-UNDO.
    DEFINE INPUT PARAMETER p-serie-fim       AS character NO-UNDO.
    DEFINE INPUT PARAMETER p-nr-nota-fis-ini AS character NO-UNDO.
    DEFINE INPUT PARAMETER p-nr-nota-fis-fim AS character NO-UNDO.
    DEFINE INPUT PARAMETER p-nr-volume-ini   AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER p-nr-volume-fim   AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER p-nr-conhec-ini   AS character NO-UNDO.
    DEFINE INPUT PARAMETER p-nr-conhec-fim   AS character NO-UNDO.

    ASSIGN 
    v-cod-estabel-ini = p-cod-estabel-ini
    v-cod-estabel-fim = p-cod-estabel-fim
    v-serie-ini       = p-serie-ini
    v-serie-fim       = p-serie-fim
    v-nr-nota-fis-ini = p-nr-nota-fis-ini
    v-nr-nota-fis-fim = p-nr-nota-fis-fim
    v-nr-volume-ini   = p-nr-volume-ini
    v-nr-volume-fim   = p-nr-volume-fim
    v-nr-conhec-ini   = p-nr-conhec-ini
    v-nr-conhec-fim   = p-nr-conhec-fim.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Valida‡äes pertinentes ao DBO
  Parameters:  recebe o tipo de valida‡Æo (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.

    CASE pType:
         WHEN "Create" THEN DO:
             IF CAN-FIND(FIRST bf{&TableName} NO-LOCK
                 WHERE bf{&TableName}.cod-estabel = RowObject.cod-estabel
                 AND bf{&TableName}.serie = RowObject.serie
                 AND bf{&TableName}.nr-nota-fis = RowObject.nr-nota-fis
                 AND bf{&TableName}.nr-volume = RowObject.nr-volume
                 AND bf{&TableName}.nr-conhec = RowObject.nr-conhec) THEN DO:
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
                 AND bf{&TableName}.serie = RowObject.serie
                 AND bf{&TableName}.nr-nota-fis = RowObject.nr-nota-fis
                 AND bf{&TableName}.nr-volume = RowObject.nr-volume
                 AND bf{&TableName}.nr-conhec = RowObject.nr-conhec) THEN DO:
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
                 AND bf{&TableName}.serie = RowObject.serie
                 AND bf{&TableName}.nr-nota-fis = RowObject.nr-nota-fis
                 AND bf{&TableName}.nr-volume = RowObject.nr-volume
                 AND bf{&TableName}.nr-conhec = RowObject.nr-conhec) THEN DO:
                 {method/svc/errors/inserr.i
                     &ErrorNumber="2"
                     &ErrorType="EMS"
                     &ErrorSubType="ERROR"
                     &ErrorParameters="'{&TableLabel}'"
                 }
             END.

         END.
    END CASE.

    
    /*:T--- Utilize o parƒmetro pType para identificar quais as valida‡äes a serem
          executadas ---*/
    /*:T--- Os valores poss¡veis para o parƒmetro sÆo: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atrav‚s do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as valida‡äes ---*/
    IF pType = "Create" THEN DO:
        /*Valida‡äes de Campos*/
        IF NOT CAN-FIND(FIRST estabelec NO-LOCK
                        WHERE estabelec.cod-estabel = RowObject.cod-estabel) THEN DO:
            {method/svc/errors/inserr.i
                &ErrorNumber="17006"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorParameters="'Estabelecimento inv lido.~~~~Estabelecimento nÆo cadastrado.'"}
        END.

        IF NOT CAN-FIND(FIRST nota-fiscal NO-LOCK
                        WHERE nota-fiscal.cod-estabel = RowObject.cod-estabel
                          AND nota-fiscal.serie       = RowObject.serie
                          AND nota-fiscal.nr-nota-fis = RowObject.nr-nota-fis) THEN DO:
            {method/svc/errors/inserr.i
                &ErrorNumber="17006"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorParameters="'Nota Fiscal inv lida.~~~~Nota Fiscal nÆo encontrada.'"}
        END.

        IF RowObject.nr-conhec = "" THEN DO:
            {method/svc/errors/inserr.i
                &ErrorNumber="17006"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorParameters="'N£mero do Conhecimento inv lido.~~~~N£mero do conhecimento deve ser informado.'"}
        END.
    END.

    
    /*:T--- Verifica ocorrˆncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

