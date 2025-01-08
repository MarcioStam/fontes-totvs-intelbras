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
{include/i-prgvrs.i BOES026 2.00.00.000}                               
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
&GLOBAL-DEFINE DBOName  BOES026
&GLOBAL-DEFINE DBOVersion  2.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName  car-familia-item
&GLOBAL-DEFINE TableLabel  Caracter¡sticas das Sub-fam¡lias   
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
{esbo/boes026.i RowObject}
 
 
/*:T--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo 
      manual da query ---*/
{method/dboqry.i}
 
 
/*:T--- Defini‡Æo de buffer que ser  utilizado pelo m‚todo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.
/* ************************* Defini‡Æo de vari veis *********************** */
define variable v-cod-familia as integer no-undo.
define variable v-cod-sub-familia as integer no-undo.
define variable v-cod-car-familia as integer no-undo.

define variable v-ini-cod-familia as integer no-undo.
define variable v-ini-cod-sub-familia as integer no-undo.
define variable v-ini-cod-car-familia as integer no-undo.

define variable v-fim-cod-familia as integer no-undo.
define variable v-fim-cod-sub-familia as integer no-undo.
define variable v-fim-cod-car-familia as integer no-undo.

define variable v-ini-descricao as character no-undo.
define variable v-fim-descricao as character no-undo.

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
         HEIGHT             = 13.13
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDeleteRecord DBOProgram 
PROCEDURE afterDeleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    for each comp-familia-item exclusive-lock
        where comp-familia-item.cod-familia     = rowObject.cod-familia
        and   comp-familia-item.cod-sub-familia = rowObject.cod-sub-familia
        and   comp-familia-item.cod-car-familia = rowObject.cod-car-familia:
        delete comp-familia-item.
    end.    
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
        WHEN "abreviatura":U THEN ASSIGN pFieldValue = RowObject.abreviatura.
        WHEN "Descricao":U THEN ASSIGN pFieldValue = RowObject.Descricao.
        OTHERWISE RETURN "NOK":U.
    END CASE.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getIntField DBOProgram 
PROCEDURE getIntField :
DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS INTEGER NO-UNDO.                                                                         

    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cod-car-familia":U THEN ASSIGN pFieldValue = RowObject.cod-car-familia.
        WHEN "cod-familia":U THEN ASSIGN pFieldValue = RowObject.cod-familia.
        WHEN "cod-sub-familia":U THEN ASSIGN pFieldValue = RowObject.cod-sub-familia.
        OTHERWISE RETURN "NOK":U.
    END CASE.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
DEFINE INPUT PARAMETER p-cod-familia AS integer NO-UNDO.                                                                        
    DEFINE INPUT PARAMETER p-cod-sub-familia AS integer NO-UNDO.                                                                    
    DEFINE INPUT PARAMETER p-cod-car-familia AS integer NO-UNDO.                                                                    

    FIND bf{&TableName} NO-LOCK
        WHERE bf{&TableName}.cod-familia = p-cod-familia              
        AND bf{&TableName}.cod-sub-familia = p-cod-sub-familia        
        AND bf{&TableName}.cod-car-familia = p-cod-car-familia        
        NO-ERROR.
    IF NOT AVAILABLE bf{&TableName} THEN RETURN "NOK":U.
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bf{&TableName})).
    IF RETURN-VALUE = "NOK":U THEN RETURN "NOK":U.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToFamilia-Item DBOProgram 
PROCEDURE linkToFamilia-Item :
/*---------------------------------------------------------------
  Purpose:     Recebe handle do DBO Item e execute m‚todo getKey
  Parameters:  recebe handle de um DBO
  Notes:       
----------------------------------------------------------------*/
   DEFINE INPUT PARAMETER pHandle AS HANDLE NO-UNDO.
   
   RUN getKey IN pHandle (OUTPUT v-cod-familia).
   
   RETURN "OK":U.
   
end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQuery DBOProgram 
PROCEDURE openQuery :
DEFINE INPUT PARAMETER iAbertura AS INTEGER NO-UNDO.

    CASE iAbertura:
        WHEN 1 THEN
            RUN openQueryStatic ("Main":U).
        WHEN 2 THEN           
            RUN openQueryStatic ("Primario":U).                       
    END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryFamilia DBOProgram 
PROCEDURE openQueryFamilia :
OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
        WHERE {&TableName}.cod-familia = v-cod-familia                
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryPrimario DBOProgram 
PROCEDURE openQueryPrimario :
OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
        WHERE {&TableName}.cod-familia = v-cod-familia                
        AND {&TableName}.cod-sub-familia = v-cod-sub-familia          
        AND {&TableName}.cod-car-familia = v-cod-car-familia          
    .
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryZoom1 DBOProgram 
PROCEDURE openQueryZoom1 :
OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
        WHERE {&TableName}.cod-familia >= v-ini-cod-familia                
        and   {&TableName}.cod-familia <= v-fim-cod-familia                
        AND   {&TableName}.cod-sub-familia >= v-ini-cod-sub-familia          
        and   {&TableName}.cod-sub-familia <= v-fim-cod-sub-familia          
        AND   {&TableName}.cod-car-familia >= v-ini-cod-car-familia          
        AND   {&TableName}.cod-car-familia <= v-fim-cod-car-familia          
    .
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryZoom2 DBOProgram 
PROCEDURE openQueryZoom2 :
OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
        WHERE {&TableName}.cod-familia >= v-ini-cod-familia                
        and   {&TableName}.cod-familia <= v-fim-cod-familia                
        AND   {&TableName}.cod-sub-familia >= v-ini-cod-sub-familia          
        and   {&TableName}.cod-sub-familia <= v-fim-cod-sub-familia          
        AND   {&TableName}.descricao >= v-ini-descricao          
        AND   {&TableName}.descricao <= v-fim-descricao          
    .
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintFamilia DBOProgram 
PROCEDURE setConstraintFamilia :
DEFINE INPUT PARAMETER p-cod-familia AS integer NO-UNDO.                                                                        
    DEFINE INPUT PARAMETER p-cod-sub-familia AS integer NO-UNDO.                                                                    

    ASSIGN 
    v-cod-familia = p-cod-familia                                     
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintPrimario DBOProgram 
PROCEDURE setConstraintPrimario :
DEFINE INPUT PARAMETER p-cod-familia AS integer NO-UNDO.                                                                        
    DEFINE INPUT PARAMETER p-cod-sub-familia AS integer NO-UNDO.                                                                    
    DEFINE INPUT PARAMETER p-cod-car-familia AS integer NO-UNDO.                                                                    

    ASSIGN 
    v-cod-familia = p-cod-familia                                     
    v-cod-sub-familia = p-cod-sub-familia                             
    v-cod-car-familia = p-cod-car-familia                             
    .
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintZoom1 DBOProgram 
PROCEDURE setConstraintZoom1 :
DEFINE INPUT PARAMETER p-ini-cod-familia AS integer NO-UNDO.                                                                        
DEFINE INPUT PARAMETER p-fim-cod-familia AS integer NO-UNDO.                                                                        
    DEFINE INPUT PARAMETER p-ini-cod-sub-familia AS integer NO-UNDO.                                                                    
    DEFINE INPUT PARAMETER p-fim-cod-sub-familia AS integer NO-UNDO.                                                                    
    DEFINE INPUT PARAMETER p-ini-cod-car-familia AS integer NO-UNDO.                                                                    
    DEFINE INPUT PARAMETER p-fim-cod-car-familia AS integer NO-UNDO.                                                                    

    ASSIGN 
    v-ini-cod-familia = p-ini-cod-familia                                     
    v-ini-cod-sub-familia = p-ini-cod-sub-familia                             
    v-ini-cod-car-familia = p-ini-cod-car-familia                             
    v-fim-cod-familia = p-fim-cod-familia                                     
    v-fim-cod-sub-familia = p-fim-cod-sub-familia                             
    v-fim-cod-car-familia = p-fim-cod-car-familia                             
    .
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintZoom2 DBOProgram 
PROCEDURE setConstraintZoom2 :
DEFINE INPUT PARAMETER p-ini-cod-familia AS integer NO-UNDO.                                                                        
DEFINE INPUT PARAMETER p-fim-cod-familia AS integer NO-UNDO.                                                                        
    DEFINE INPUT PARAMETER p-ini-cod-sub-familia AS integer NO-UNDO.                                                                    
    DEFINE INPUT PARAMETER p-fim-cod-sub-familia AS integer NO-UNDO.                                                                    
    DEFINE INPUT PARAMETER p-ini-descricao AS char NO-UNDO.                                                                    
    DEFINE INPUT PARAMETER p-fim-descricao AS char NO-UNDO.                                                                    

    ASSIGN 
    v-ini-cod-familia = p-ini-cod-familia                                     
    v-ini-cod-sub-familia = p-ini-cod-sub-familia                             
    v-ini-descricao = p-ini-descricao                             
    v-fim-cod-familia = p-fim-cod-familia                                     
    v-fim-cod-sub-familia = p-fim-cod-sub-familia                             
    v-fim-descricao = p-fim-descricao                             
    .
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setFamilyDesc DBOProgram 
PROCEDURE setFamilyDesc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER p-desc-nova AS CHAR NO-UNDO. 

    DEFINE VARIABLE c-fam-ini AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-fam-fim AS CHARACTER   NO-UNDO.


    IF AVAIL RowObject THEN DO:
        
        ASSIGN OVERLAY(c-fam-ini,1,3) = string(RowObject.cod-familia,     "999")
               OVERLAY(c-fam-ini,4,2) = string(RowObject.cod-sub-familia, "99")
               OVERLAY(c-fam-ini,6,2) = STRING(RowObject.cod-car-familia, "99").

        ASSIGN c-fam-fim = c-fam-ini + "Z".

        disable triggers for load of familia.

        for each familia EXCLUSIVE-LOCK
            where familia.fm-codigo >= c-fam-ini
            AND   familia.fm-codigo <= c-fam-fim:
            
            /*ASSIGN familia.descricao = REPLACE(familia.descricao, RowObject.descricao, p-desc-nova).*/

            FOR FIRST sub-familia-item no-lock
                where sub-familia-item.cod-familia = RowObject.cod-familia
                and   sub-familia-item.cod-sub-familia = RowObject.cod-sub-familia:

                ASSIGN SUBSTRING(familia.descricao, LENGTH(sub-familia-item.descricao) + 2, LENGTH(RowObject.descricao)) = p-desc-nova.

            END.
           
        end.
            
        release familia.
        
    END.

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
    def var c-familia-id as char no-undo.

    CASE pType:
         WHEN "Create" THEN DO:
             IF CAN-FIND(FIRST bf{&TableName} NO-LOCK
                 WHERE bf{&TableName}.cod-familia = RowObject.cod-familia
                 AND bf{&TableName}.cod-sub-familia = RowObject.cod-sub-familia
                 AND bf{&TableName}.cod-car-familia = RowObject.cod-car-familia) THEN DO:
                 {method/svc/errors/inserr.i
                     &ErrorNumber="1"
                     &ErrorType="EMS"
                     &ErrorSubType="ERROR"
                     &ErrorParameters="'{&TableLabel}'"
                 }
             END.
             IF CAN-FIND(FIRST bf{&TableName} NO-LOCK
                 WHERE bf{&TableName}.cod-familia = RowObject.cod-familia
                 AND bf{&TableName}.cod-sub-familia = RowObject.cod-sub-familia
                 AND bf{&TableName}.abreviatura = RowObject.abreviatura) THEN DO:
                 RUN _insertErrorManual(INPUT 0,
                                        INPUT "EMS",
                                        INPUT "ERROR",
                                        INPUT "Existe caracter¡stica de fam¡lia com esta abreviatura",
                                        INPUT "Existe caracter¡stica de fam¡lia com esta abreviatura",
                                        INPUT "").                    
             END.
             if not can-find(first sub-familia-item no-lock
                where sub-familia-item.cod-familia     = RowObject.cod-familia
                and   sub-familia-item.cod-sub-familia = RowObject.cod-sub-familia) then do:
                 {method/svc/errors/inserr.i
                     &ErrorNumber="2"
                     &ErrorType="EMS"
                     &ErrorSubType="ERROR"
                     &ErrorParameters="'Subfam¡lia'"
                 }
                
             end.   
         END.
         WHEN "Update" THEN DO:
             IF NOT CAN-FIND(FIRST bf{&TableName} NO-LOCK
                 WHERE bf{&TableName}.cod-familia = RowObject.cod-familia
                 AND bf{&TableName}.cod-sub-familia = RowObject.cod-sub-familia
                 AND bf{&TableName}.cod-car-familia = RowObject.cod-car-familia) THEN DO:
                 {method/svc/errors/inserr.i
                     &ErrorNumber="2"
                     &ErrorType="EMS"
                     &ErrorSubType="ERROR"
                     &ErrorParameters="'{&TableLabel}'"
                 }
             END.
             IF CAN-FIND(FIRST bf{&TableName} NO-LOCK
                 WHERE bf{&TableName}.cod-familia = RowObject.cod-familia
                 AND bf{&TableName}.cod-sub-familia = RowObject.cod-sub-familia
                 AND bf{&TableName}.abreviatura = RowObject.abreviatura
                 and rowid(bf{&TableName}) ne RowObject.r-rowid) THEN DO:
                 RUN _insertErrorManual(INPUT 0,
                                        INPUT "EMS",
                                        INPUT "ERROR",
                                        INPUT "Existe caracter¡stica de fam¡lia com esta abreviatura",
                                        INPUT "Existe caracter¡stica de fam¡lia com esta abreviatura",
                                        INPUT "").                    
             END.

         END.
         WHEN "Delete" THEN DO:
             IF NOT CAN-FIND(FIRST bf{&TableName} NO-LOCK
                 WHERE bf{&TableName}.cod-familia = RowObject.cod-familia
                 AND bf{&TableName}.cod-sub-familia = RowObject.cod-sub-familia
                 AND bf{&TableName}.cod-car-familia = RowObject.cod-car-familia) THEN DO:
                 {method/svc/errors/inserr.i
                     &ErrorNumber="2"
                     &ErrorType="EMS"
                     &ErrorSubType="ERROR"
                     &ErrorParameters="'{&TableLabel}'"
                 }
             END.
             
             c-familia-id = string(RowObject.cod-familia,"999") +
                            string(RowObject.cod-sub-familia,"99") +
                            string(RowObject.cod-car-familia,"99"). 
             
             IF CAN-FIND(FIRST comp-familia-item no-lock
                         WHERE comp-familia-item.cod-familia     = RowObject.cod-familia AND
                               comp-familia-item.cod-sub-familia = RowObject.cod-sub-familia AND
                               comp-familia-item.cod-car-familia = RowObject.cod-car-familia)
                         THEN DO:
                
                 RUN _insertErrorManual(INPUT 0,
                                        INPUT "EMS",
                                        INPUT "ERROR",
                                        INPUT "Existe Complemento cadastrado para Caracteristica.",
                                        INPUT "Caracter¡stica nÆo pode ser excluida.",
                                        INPUT "").


             END.
             /*
             if can-find(first item no-lock
                where item.fm-codigo begins c-familia-id) then do:
                 RUN _insertErrorManual(INPUT 0,
                                        INPUT "EMS",
                                        INPUT "ERROR",
                                        INPUT "Existe item nesta fam¡lia",
                                        INPUT "Existe item nesta fam¡lia",
                                        INPUT "").                    
                
             end.   
             */

         END.
    END CASE.

    
    /*:T--- Utilize o parƒmetro pType para identificar quais as valida‡äes a serem
          executadas ---*/
    /*:T--- Os valores poss¡veis para o parƒmetro sÆo: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atrav‚s do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as valida‡äes ---*/
    
    /*:T--- Verifica ocorrˆncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

