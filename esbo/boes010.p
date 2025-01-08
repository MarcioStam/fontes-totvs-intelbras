&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
/*:T--------------------------------------------------------------------------
    File       : dbo.p
    Purpose    : O DBO (Datasul Business Objects) é um programa PROGRESS 
                 que contém a lógica de negócio e acesso a dados para uma 
                 tabela do banco de dados.

    Parameters : 

    Notes      : 
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */
/*:T--- Diretrizes de definição ---*/
&GLOBAL-DEFINE DBOName BOES010
&GLOBAL-DEFINE DBOVersion 1.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName ae-item
&GLOBAL-DEFINE TableLabel Aviso Entrada Item 
&GLOBAL-DEFINE QueryName qrae-item
&GLOBAL-DEFINE NewRecordOffQuery     YES


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

&GLOBAL-DEFINE XMLReceiver YES    /*:T DBO atua como receiver de mensagens enviado pelo Message Broker (método Receive Message) */
&GLOBAL-DEFINE QueryDefault       /*:T Nome da Query que dá acessos a todos os registros, exceto os excluídos pela constraint de segurança. Usada para receber uma mensagem XML. */
&GLOBAL-DEFINE KeyField1 cust-num /*:T Informar os campos da chave quando o Progress não conseguir resolver find {&TableName} OF RowObject. */
*/
/* DBO-XML-END */

/*:T--- Include com definição da temptable RowObject ---*/
/*:T--- Este include deve ser copiado para o diretório do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idêntico ao nome do DBO mas com 
      extensão .i ---*/
{esbo/boes010.i RowObject}


/*:T--- Include com definição da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteração da definição da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definição 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definição de buffer que será utilizado pelo método goToKey ---*/
DEFINE BUFFER bfae-item FOR {&TableName}.

DEF VAR v-nr-ae-ini     LIKE ae-item.nr-ae          NO-UNDO.
DEF VAR v-nr-ae-fim     LIKE ae-item.nr-ae          NO-UNDO.
DEF VAR v-sequencia-ini LIKE ae-item.sequencia      NO-UNDO.
DEF VAR v-sequencia-fim LIKE ae-item.sequencia      NO-UNDO.
DEF VAR v-it-codigo-ini LIKE ae-item.it-codigo      NO-UNDO.
DEF VAR v-it-codigo-fim LIKE ae-item.it-codigo      NO-UNDO.
DEF VAR v-data-ini      LIKE ae-item.data           NO-UNDO.     
DEF VAR v-data-fim      LIKE ae-item.data           NO-UNDO.     
DEF VAR v-impresso      LIKE ae-item.impresso       NO-UNDO.
DEF VAR v-data-validade LIKE ae-item.data-validade  NO-UNDO.
DEF VAR v-situacao      LIKE ae-item.situacao       NO-UNDO. 

DEF VAR v-ini-nr-ae     AS INT NO-UNDO.
DEF VAR v-fim-nr-ae     AS INT NO-UNDO.
DEF VAR v-ini-sequencia AS INT NO-UNDO.
DEF VAR v-fim-sequencia AS INT NO-UNDO.
def var v-cod-estabel as char no-undo.

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
   Type: DBOProgram
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
         HEIGHT             = 1.88
         WIDTH              = 28.86.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "DBO 2.0 Wizard" DBOProgram _INLINE
/* Actions: wizard/dbowizard.w ? ? ? ? */
/* DBO 2.0 Wizard (DELETE)*/
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Atualiza-Data DBOProgram 
PROCEDURE Atualiza-Data :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param p-cod-estabel as char no-undo.
    DEF INPUT PARAM p-nr-ae         LIKE ae-item.nr-ae         NO-UNDO.
    DEF INPUT PARAM p-data          LIKE ae-item.data          NO-UNDO.
    DEF INPUT PARAM p-data-validade LIKE ae-item.data-validade NO-UNDO.

    FOR EACH ae-item WHERE 
             ae-item.cod-estabel = p-cod-estabel and
             ae-item.nr-ae = p-nr-ae:
        ASSIGN ae-item.data          = p-data
               ae-item.data-validade = p-data-validade.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeCreateRecord DBOProgram 
PROCEDURE beforeCreateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def output param p-cod-estabel LIKE ae-item.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER p-nr-ae LIKE ae-item.nr-ae NO-UNDO.
    DEFINE OUTPUT PARAMETER p-seq LIKE ae-item.sequencia NO-UNDO.



    IF RowObject.nr-ae = 0 THEN DO:
        FIND FIRST aviso-entrada EXCLUSIVE-LOCK 
            where aviso-entrada.cod-estabel = RowObject.cod-estabel NO-ERROR.
        IF AVAIL aviso-entrada THEN
            ASSIGN aviso-entrada.ultimo-ae = aviso-entrada.ultimo-ae + 1
                   RowObject.nr-ae = aviso-entrada.ultimo-ae.
        ELSE do:
            CREATE aviso-entrada.
            ASSIGN aviso-entrada.cod-estabel = RowObject.cod-estabel
                   aviso-entrada.ultimo-ae   = 1
                   RowObject.nr-ae = 1.
        END.
        FIND CURRENT aviso-entrada no-lock no-error.
    END.
    IF RowObject.sequencia = 0 THEN DO:
        find last ae-item use-index it-ae-seq
            where ae-item.cod-estabel = RowObject.cod-estabel
            and   ae-item.nr-ae = RowObject.nr-ae
            and  ae-item.it-codigo = RowObject.it-codigo NO-LOCK NO-ERROR.
        IF AVAIL ae-item THEN
            RowObject.sequencia = ae-item.sequencia + 1.
        ELSE RowObject.sequencia = 1.
    END.

    ASSIGN p-nr-ae = RowObject.nr-ae
           p-seq   = RowObject.sequencia. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforedeleteRecord DBOProgram 
PROCEDURE beforedeleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DO WHILE TRUE:
        find FIRST ae-bloqueado EXCLUSIVE-LOCK
            where ae-bloqueado.cod-estabel = {&TableName}.cod-estabel
            and  ae-bloqueado.nr-ae = {&TableName}.nr-ae 
            and ae-bloqueado.sequencia = {&TableName}.sequencia NO-WAIT no-error.
        IF NOT AVAIL ae-bloqueado THEN LEAVE.
        IF NOT LOCKED(ae-bloqueado) THEN DO:
            delete ae-bloqueado.
            LEAVE.
        END.
        PAUSE 1.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE criaLoteAE DBOProgram 
PROCEDURE criaLoteAE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input-output param table for rowObject.
    def var i-nr-ae like ae-item.nr-ae no-undo.
    def var i-sequencia like ae-item.sequencia no-undo.
    
    find first rowObject no-error.
    
    if rowObject.nr-ae = 0 then do:
        FIND FIRST aviso-entrada EXCLUSIVE-LOCK 
            where aviso-entrada.cod-estabel = RowObject.cod-estabel NO-ERROR.
        IF AVAIL aviso-entrada THEN
            ASSIGN aviso-entrada.ultimo-ae = aviso-entrada.ultimo-ae + 1
                   i-nr-ae = aviso-entrada.ultimo-ae.
        ELSE do:
            CREATE aviso-entrada.
            ASSIGN aviso-entrada.cod-estabel = RowObject.cod-estabel
                   aviso-entrada.ultimo-ae   = 1
                   i-nr-ae = 1.
        END.
        release aviso-entrada.
        FIND CURRENT aviso-entrada no-lock no-error.

        assign i-sequencia = rowObject.sequencia.
    end.
    else do:
        find last ae-item use-index ae-seq no-lock
            where ae-item.cod-estabel = RowObject.cod-estabel 
            and ae-item.nr-ae = rowObject.nr-ae no-error.
            
        if avail ae-item then    
            assign i-sequencia = ae-item.sequencia + 1.    
        else
            assign i-sequencia = 1.    
            
        assign i-nr-ae = rowObject.nr-ae.            
    
    end.
    
    for each rowObject:
        create bfae-item.
        buffer-copy rowObject except r-rowid nr-ae sequencia to bfae-item.
        assign bfae-item.nr-ae = i-nr-ae
               bfae-item.sequencia = i-sequencia
               i-sequencia = i-sequencia + 1  
               rowObject.nr-ae = bfae-item.nr-ae
               rowObject.sequencia = bfae-item.sequencia
               rowObject.r-rowid = rowid(bfae-item).
        release bfae-item.
    end.
    
    return "OK".           
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteRecordBatch DBOProgram 
PROCEDURE deleteRecordBatch :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    GET FIRST {&QueryName}.    
    REPEAT TRANS:
        IF NOT AVAIL {&TableName} THEN LEAVE.
        RUN beforedeleteRecord IN THIS-PROCEDURE.
        IF CAN-FIND(FIRST RowErrors WHERE RowErrors.errortype = "error") THEN
            UNDO, RETURN "NOK".
        FIND CURRENT {&TableName} EXCLUSIVE-LOCK NO-ERROR.
        IF AVAIL {&TableName} THEN DELETE {&TableName}.
        GET NEXT {&QueryName}.    
    END.
    RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findAEBySeq DBOProgram 
PROCEDURE findAEBySeq :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no índice codigo
  Parameters:  
               recebe valor do campo cd-oper
  Notes:       
------------------------------------------------------------------------------*/
    def input param p-cod-estabel as char no-undo.
    DEF INPUT PARAM p-nr-ae     LIKE ae-item.nr-ae     NO-UNDO.
    DEF INPUT PARAM p-sequencia LIKE ae-item.sequencia NO-UNDO.


    FIND FIRST bfae-item                         WHERE         
               bfae-item.cod-estabel = p-cod-estabel and
               bfae-item.nr-ae     = p-nr-ae     AND
               bfae-item.sequencia = p-sequencia NO-LOCK NO-ERROR.


    /*--- Verifica se registro foi encontrado, em caso de erro será retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfae-item THEN DO:
        RETURN "NOK":U.
    END.


    /*--- Reposiciona query através de rowid e verifica a ocorrência de erros, caso
          existam erros será retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfae-item)).


    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.
  
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getCharField DBOProgram 
PROCEDURE getCharField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo caracter
  Parameters:  
               recebe it-codigo do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS CHARACTER NO-UNDO.

    /*--- Verifica se temptable RowObject está disponível, caso não esteja será
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.
    CASE pFieldName:
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "localizacao":U THEN ASSIGN pFieldValue = RowObject.localizacao.
        WHEN "cod-depos":U THEN ASSIGN pFieldValue = RowObject.cod-depos.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDateField DBOProgram 
PROCEDURE getDateField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo data
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DATE NO-UNDO.

    /*--- Verifica se temptable RowObject está disponível, caso não esteja será
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "data":U THEN ASSIGN pFieldValue = RowObject.data.
        WHEN "data-fabricacao":U THEN ASSIGN pFieldValue = RowObject.data-fabricacao.
        WHEN "data-validade":U THEN ASSIGN pFieldValue = RowObject.data-validade.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDecField DBOProgram 
PROCEDURE getDecField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo decimal
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DECIMAL NO-UNDO.

    /*--- Verifica se temptable RowObject está disponível, caso não esteja será
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getIntField DBOProgram 
PROCEDURE getIntField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo inteiro
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS INTEGER NO-UNDO.

    /*--- Verifica se temptable RowObject está disponível, caso não esteja será
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "quantidade":U THEN ASSIGN pFieldValue = RowObject.quantidade.
        WHEN "nr-ae":U THEN ASSIGN pFieldValue = RowObject.nr-ae.
        WHEN "sequencia":U THEN ASSIGN pFieldValue = RowObject.sequencia.
        WHEN "nf":U THEN ASSIGN pFieldValue = RowObject.nf.
        WHEN "roteiro":U THEN ASSIGN pFieldValue = RowObject.roteiro.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do índice codigo
  Parameters:  
               retorna valor do campo cd-oper
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER p-nr-ae LIKE ae-item.nr-ae NO-UNDO.
    DEF OUTPUT PARAM p-sequencia LIKE ae-item.sequencia NO-UNDO.

    /*--- Verifica se temptable RowObject está disponível, caso não esteja será
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN p-nr-ae = RowObject.nr-ae
           p-sequencia = RowObject.sequencia.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLogField DBOProgram 
PROCEDURE getLogField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo lógico
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS LOGICAL NO-UNDO.

    /*--- Verifica se temptable RowObject está disponível, caso não esteja será
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "situacao":U THEN ASSIGN pFieldValue = RowObject.situacao.
        WHEN "impresso":U THEN ASSIGN pFieldValue = RowObject.impresso.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRawField DBOProgram 
PROCEDURE getRawField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo raw
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS RAW NO-UNDO.

    /*--- Verifica se temptable RowObject está disponível, caso não esteja será
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRecidField DBOProgram 
PROCEDURE getRecidField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo recid
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS RECID NO-UNDO.

    /*--- Verifica se temptable RowObject está disponível, caso não esteja será
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no índice codigo
  Parameters:  
               recebe valor do campo cd-oper
  Notes:       
------------------------------------------------------------------------------*/
    def input param p-cod-estabel as char no-undo.
    DEF INPUT PARAM p-nr-ae     LIKE ae-item.nr-ae     NO-UNDO.
    /* DEF INPUT PARAM p-sequencia LIKE ae-item.sequencia NO-UNDO. */


    FIND FIRST bfae-item                         WHERE         
               bfae-item.cod-estabel = p-cod-estabel and
               bfae-item.nr-ae     = p-nr-ae     AND
               /* bfae-item.sequencia = p-sequencia AND  */
               bfae-item.situacao  = NO          USE-INDEX ae-seq NO-LOCK NO-ERROR.


    /*--- Verifica se registro foi encontrado, em caso de erro será retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfae-item THEN DO:
        RETURN "NOK":U.
    END.


    /*--- Reposiciona query através de rowid e verifica a ocorrência de erros, caso
          existam erros será retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfae-item)).


    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.
  
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey2 DBOProgram 
PROCEDURE goToKey2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param p-cod-estabel as char no-undo.
    DEF INPUT PARAM p-nr-ae     LIKE ae-item.nr-ae     NO-UNDO.
    DEF INPUT PARAM p-sequencia LIKE ae-item.sequencia NO-UNDO.


    FIND FIRST bfae-item                         WHERE         
               bfae-item.cod-estabel = p-cod-estabel and
               bfae-item.nr-ae     = p-nr-ae     AND
               bfae-item.sequencia = p-sequencia NO-LOCK NO-ERROR.


    /*--- Verifica se registro foi encontrado, em caso de erro será retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfae-item THEN DO:
        RETURN "NOK":U.
    END.


    /*--- Reposiciona query através de rowid e verifica a ocorrência de erros, caso
          existam erros será retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfae-item)).


    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.
  
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQuery DBOProgram 
PROCEDURE openQuery :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK where {&TableName}.cod-estabel = v-cod-estabel.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByAE DBOProgram 
PROCEDURE openQueryByAE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK WHERE
           {&TableName}.cod-estabel = v-cod-estabel and
           {&TableName}.nr-ae     >= v-nr-ae-ini      AND
           {&TableName}.nr-ae     <= v-nr-ae-fim      AND
           {&TableName}.sequencia >= v-sequencia-ini  AND
           {&TableName}.sequencia <= v-sequencia-fim  AND
           {&TableName}.situacao   = v-situacao.
RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByAE2 DBOProgram 
PROCEDURE openQueryByAE2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK WHERE
           {&TableName}.cod-estabel = v-cod-estabel and
           {&TableName}.nr-ae     >= v-nr-ae-ini      AND
           {&TableName}.nr-ae     <= v-nr-ae-fim      AND
           {&TableName}.sequencia >= v-sequencia-ini  AND
           {&TableName}.sequencia <= v-sequencia-fim.
RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByCod DBOProgram 
PROCEDURE openQueryByCod :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*
OPEN QUERY  {&QueryName} FOR EACH {&TableName} NO-LOCK     WHERE 
            {&TableName}.nr-ae         >= v-ini-nr-ae      AND
            {&TableName}.nr-ae         <= v-fim-nr-ae      AND
            {&TableName}.sequencia     >= v-ini-sequencia  AND
            {&TableName}.sequencia     <= v-fim-sequencia  AND
            {&TableName}.situacao      =  NO               AND
            {&TableName}.data-validade <= TODAY            BY 
            {&TableName}.nr-ae.    
*/


OPEN QUERY  {&QueryName} FOR EACH {&TableName} NO-LOCK     WHERE 
            {&TableName}.cod-estabel = v-cod-estabel and
            {&TableName}.nr-ae         = v-ini-nr-ae      AND
            {&TableName}.nr-ae         = v-fim-nr-ae      AND
            {&TableName}.sequencia     >= v-ini-sequencia  AND
            {&TableName}.sequencia     <= v-fim-sequencia  AND
            {&TableName}.situacao      =  NO               BY 
            {&TableName}.nr-ae                             BY
            {&TableName}.sequencia.    

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByCod2 DBOProgram 
PROCEDURE openQueryByCod2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
OPEN QUERY  {&QueryName} FOR EACH {&TableName} NO-LOCK  use-index ae-seq   WHERE 
            {&TableName}.cod-estabel = v-cod-estabel and
            {&TableName}.nr-ae         >= v-ini-nr-ae      AND
            {&TableName}.nr-ae         <= v-fim-nr-ae      AND
            {&TableName}.sequencia     >= v-ini-sequencia  AND
            {&TableName}.sequencia     <= v-fim-sequencia.  

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByFIFO DBOProgram 
PROCEDURE openQueryByFIFO :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
    WHERE {&TableName}.cod-estabel = v-cod-estabel and
    ({&TableName}.situacao   = v-situacao OR v-situacao = ?)
    AND   ({&TableName}.impresso   = v-impresso OR v-impresso = ?)
    AND   {&TableName}.it-codigo >= v-it-codigo-ini
    AND   {&TableName}.it-codigo <= v-it-codigo-fim
    AND   {&TableName}.data      >= v-data-ini
    AND   {&TableName}.data      <= v-data-fim.
RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByItemSequencia DBOProgram 
PROCEDURE openQueryByItemSequencia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
    WHERE {&TableName}.cod-estabel = v-cod-estabel and
    ({&TableName}.situacao   = v-situacao OR v-situacao = ?)
    AND   ({&TableName}.impresso   = v-impresso OR v-impresso = ?)
    /*
    AND   {&TableName}.it-codigo >= v-it-codigo-ini
    AND   {&TableName}.it-codigo <= v-it-codigo-fim
    */
    AND   {&TableName}.nr-ae      >= v-nr-ae-ini
    AND   {&TableName}.nr-ae      <= v-nr-ae-fim
    AND   {&TableName}.sequencia  >= v-sequencia-ini
    AND   {&TableName}.sequencia  <= v-sequencia-fim.
RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenQueryFirst DBOProgram 
PROCEDURE OpenQueryFirst :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
       WHERE {&TableName}.cod-estabel = v-cod-estabel and
       {&tablename}.nr-ae = 1.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE openQueryMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK where {&TableName}.cod-estabel = v-cod-estabel.
RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryPendentes DBOProgram 
PROCEDURE openQueryPendentes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK WHERE
             {&TableName}.cod-estabel = v-cod-estabel and
             {&TableName}.situacao   = NO.

  RETURN "OK":U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryPendentesByItem DBOProgram 
PROCEDURE openQueryPendentesByItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK WHERE
             {&TableName}.cod-estabel = v-cod-estabel and
             {&TableName}.it-codigo = v-it-codigo-ini AND
             {&TableName}.situacao   = NO.

  RETURN "OK":U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByAE DBOProgram 
PROCEDURE setConstraintByAE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param p-cod-estabel as char no-undo.
    DEFINE input PARAMETER p-nr-ae-ini LIKE ae-item.nr-ae NO-UNDO.
    DEFINE input PARAMETER p-nr-ae-fim LIKE ae-item.nr-ae NO-UNDO.
    DEF input PARAM p-sequencia-ini LIKE ae-item.sequencia NO-UNDO.
    DEF input PARAM p-sequencia-fim LIKE ae-item.sequencia NO-UNDO.

    ASSIGN v-cod-estabel   = p-cod-estabel
           v-nr-ae-ini     = p-nr-ae-ini
           v-nr-ae-fim     = p-nr-ae-fim
           v-sequencia-ini = p-sequencia-ini
           v-sequencia-fim = p-sequencia-fim
           v-situacao      = NO.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByCod DBOProgram 
PROCEDURE setConstraintByCod :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param p-cod-estabel as char no-undo.
    DEF INPUT PARAM p-ini-nr-ae     LIKE ae-item.nr-ae         NO-UNDO.
    DEF INPUT PARAM p-fim-nr-ae     LIKE ae-item.nr-ae         NO-UNDO.
    DEF INPUT PARAM p-ini-sequencia LIKE ae-item.sequencia     NO-UNDO.
    DEF INPUT PARAM p-fim-sequencia LIKE ae-item.sequencia     NO-UNDO.  
    
    DEF VAR         p-situacao      LIKE ae-item.situacao      NO-UNDO.
    DEF VAR         p-data-validade LIKE ae-item.data-validade NO-UNDO.

    ASSIGN v-cod-estabel    = p-cod-estabel
           v-ini-nr-ae      =  p-ini-nr-ae
           v-fim-nr-ae      =  p-fim-nr-ae
           v-ini-sequencia  =  p-ini-sequencia
           v-fim-sequencia  =  p-fim-sequencia. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByFIFO DBOProgram 
PROCEDURE setConstraintByFIFO :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param p-cod-estabel as char no-undo.
    DEF INPUT PARAM p-it-codigo-ini LIKE ae-item.it-codigo NO-UNDO.
    DEF INPUT PARAM p-it-codigo-fim LIKE ae-item.it-codigo NO-UNDO.
    DEF INPUT PARAM p-data-ini      LIKE ae-item.data NO-UNDO.
    DEF INPUT PARAM p-data-fim      LIKE ae-item.data NO-UNDO.
    DEF INPUT PARAM p-situacao      LIKE ae-item.situacao NO-UNDO.
    DEF INPUT PARAM p-impresso      LIKE ae-item.impresso NO-UNDO.

    ASSIGN v-cod-estabel   = p-cod-estabel
           v-it-codigo-ini = p-it-codigo-ini
           v-data-ini      = p-data-ini     
           v-it-codigo-fim = p-it-codigo-fim
           v-data-fim      = p-data-fim     
           v-situacao      = p-situacao     
           v-impresso      = p-impresso.     


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByItemSequencia DBOProgram 
PROCEDURE setConstraintByItemSequencia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param p-cod-estabel as char no-undo.
    DEF INPUT PARAM p-it-codigo-ini LIKE ae-item.it-codigo NO-UNDO.
    DEF INPUT PARAM p-it-codigo-fim LIKE ae-item.it-codigo NO-UNDO.
    DEF INPUT PARAM p-nr-ae-ini     LIKE ae-item.nr-ae NO-UNDO.
    DEF INPUT PARAM p-nr-ae-fim     LIKE ae-item.nr-ae NO-UNDO.
    DEF input PARAM p-sequencia-ini LIKE ae-item.sequencia NO-UNDO.
    DEF input PARAM p-sequencia-fim LIKE ae-item.sequencia NO-UNDO.
    DEF INPUT PARAM p-situacao      LIKE ae-item.situacao NO-UNDO.
    DEF INPUT PARAM p-impresso      LIKE ae-item.impresso NO-UNDO.

    ASSIGN v-cod-estabel   = p-cod-estabel
           v-it-codigo-ini = p-it-codigo-ini
           v-it-codigo-fim = p-it-codigo-fim
           v-nr-ae-ini     = p-nr-ae-ini     
           v-nr-ae-fim     = p-nr-ae-fim     
           v-sequencia-ini = p-sequencia-ini
           v-sequencia-fim = p-sequencia-fim
           v-situacao      = p-situacao     
           v-impresso      = p-impresso.     

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintMain DBOProgram 
PROCEDURE setConstraintMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param p-cod-estabel as char no-undo.

    v-cod-estabel = p-cod-estabel.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintPendentes DBOProgram 
PROCEDURE setConstraintPendentes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param p-cod-estabel as char no-undo.

    v-cod-estabel = p-cod-estabel.


    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintPendentesByItem DBOProgram 
PROCEDURE setConstraintPendentesByItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param p-cod-estabel as char no-undo.
    DEF INPUT PARAM p-it-codigo-ini LIKE ae-item.it-codigo NO-UNDO.
    
    assign v-cod-estabel = p-cod-estabel
           v-it-codigo-ini = p-it-codigo-ini.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Validações pertinentes ao DBO
  Parameters:  recebe o tipo de validação (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.
    DEF VAR i-sequencia AS INTEGER NO-UNDO.
    
    /*:T--- Utilize o parâmetro pType para identificar quais as validações a serem
          executadas ---*/
    /*:T--- Os valores possíveis para o parâmetro são: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, através do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as validações ---*/
    
    IF pType = "Create" THEN DO:
       IF CAN-FIND(FIRST ae-item NO-LOCK                          WHERE
                         ae-item.cod-estabel = RowObject.cod-estabel and
                         ae-item.nr-ae = RowObject.nr-ae          AND
                         ae-item.sequencia = RowObject.sequencia) THEN DO:
          RUN utp/ut-msgs.p (INPUT "msg",
                             INPUT 1,
                             INPUT 'Aviso Entrada por Item').
          CREATE RowErrors.
          ASSIGN i-sequencia = i-sequencia + 1
                 RowErrors.errorsequence = i-sequencia
                 RowErrors.errornumber   = 1
                 RowErrors.errordescription = RETURN-VALUE
                 RowErrors.errortype = "error"
                 RowErrors.ErrorSubType = "ERROR":U
                 RowErrors.errorhelp = RETURN-VALUE.
       END.
    END.

    IF pType = "Update" THEN DO:
       IF RowObject.data-validade < RowObject.data THEN DO:
          {method/svc/errors/inserr.i
          &ErrorNumber="2"
          &ErrorType="outros"
          &ErrorSubType="ERROR"
          &ErrorDescription="Data validade nÆo pode ser menor que a data de entrada!"}
       END.
       IF RowObject.data = ? THEN DO:
          {method/svc/errors/inserr.i
          &ErrorNumber="2"
          &ErrorType="outros"
          &ErrorSubType="ERROR"
          &ErrorDescription=É obrigat¢rio preencher a data de entrada!"}
       END.
    END.

    /*:T--- Verifica ocorrência de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

