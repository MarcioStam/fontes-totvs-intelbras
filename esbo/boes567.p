&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
/*:T--------------------------------------------------------------------------
    File       : dbo.p
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
&GLOBAL-DEFINE DBOName BOES567
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName crm-atendente
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 


/*:T--- Include com definiá∆o da temptable RowObject ---*/
/*:T--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{esbo/boes567.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE VARIABLE v-cod-estabel-ini  LIKE {&TableName}.cod-estabel   NO-UNDO.
DEFINE VARIABLE v-cod-estabel-fin  LIKE {&TableName}.cod-estabel   NO-UNDO.
DEFINE VARIABLE v-cd-categoria-ini LIKE {&TableName}.cd-categoria  NO-UNDO.
DEFINE VARIABLE v-cd-categoria-fin LIKE {&TableName}.cd-categoria  NO-UNDO.
DEFINE VARIABLE v-unid-negoc-ini   LIKE {&TableName}.cd-unid-negoc NO-UNDO.
DEFINE VARIABLE v-unid-negoc-fin   LIKE {&TableName}.cd-unid-negoc NO-UNDO.
DEFINE VARIABLE v-cd-atend-ini    LIKE {&TableName}.cd-atend     NO-UNDO.
DEFINE VARIABLE v-cd-atend-fin    LIKE {&TableName}.cd-atend     NO-UNDO.
DEFINE VARIABLE v-cod-gr-cli-ini   LIKE {&TableName}.cod-gr-cli    NO-UNDO.
DEFINE VARIABLE v-cod-gr-cli-fin   LIKE {&TableName}.cod-gr-cli    NO-UNDO.
DEFINE VARIABLE v-cod-rep-ini      LIKE {&TableName}.cod-rep       NO-UNDO. 
DEFINE VARIABLE v-cod-rep-fin      LIKE {&TableName}.cod-rep       NO-UNDO.

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
         HEIGHT             = 12.17
         WIDTH              = 40.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getCharField DBOProgram 
PROCEDURE getCharField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo caracter
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS CHARACTER NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cd-unid-negoc":U THEN ASSIGN pFieldValue = RowObject.cd-unid-negoc.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cd-atend":U THEN ASSIGN pFieldValue = RowObject.cd-atend.
        WHEN "cd-categoria":U THEN ASSIGN pFieldValue = RowObject.cd-categoria.
        WHEN "cod-rep":U THEN ASSIGN pFieldValue = RowObject.cod-rep.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice idx-crm-atendente
  Parameters:  
               retorna valor do campo cod-estabel
               retorna valor do campo cod-rep
               retorna valor do campo cd-unid-negoc
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE crm-atendente.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-rep LIKE crm-atendente.cod-rep NO-UNDO.
    DEFINE OUTPUT PARAMETER pcd-unid-negoc LIKE crm-atendente.cd-unid-negoc NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-estabel = RowObject.cod-estabel
           pcod-rep = RowObject.cod-rep
           pcd-unid-negoc = RowObject.cd-unid-negoc.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLogField DBOProgram 
PROCEDURE getLogField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo l¢gico
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS LOGICAL NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
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
  Purpose:     Reposiciona registro com base no °ndice idx-crm-atendente
  Parameters:  
               recebe valor do campo cod-estabel
               recebe valor do campo cod-rep
               recebe valor do campo cd-unid-negoc
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estabel LIKE crm-atendente.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pcod-rep LIKE crm-atendente.cod-rep NO-UNDO.
    DEFINE INPUT PARAMETER pcd-unid-negoc LIKE crm-atendente.cd-unid-negoc NO-UNDO.

    FIND FIRST bfcrm-atendente WHERE 
        bfcrm-atendente.cod-estabel = pcod-estabel AND 
        bfcrm-atendente.cod-rep = pcod-rep AND 
        bfcrm-atendente.cd-unid-negoc = pcd-unid-negoc NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfcrm-atendente THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfcrm-atendente)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKeyCat DBOProgram 
PROCEDURE goToKeyCat :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice idx-crm-atendente
  Parameters:  
               recebe valor do campo cod-estabel
               recebe valor do campo cod-rep
               recebe valor do campo cd-unid-negoc
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estabel LIKE crm-atendente.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pcod-rep LIKE crm-atendente.cod-rep NO-UNDO.
    DEFINE INPUT PARAMETER pcd-unid-negoc LIKE crm-atendente.cd-unid-negoc NO-UNDO.
    DEFINE INPUT PARAMETER pcd-categoria LIKE crm-atendente.cd-categoria NO-UNDO.
    DEFINE INPUT PARAMETER pcod-gr-cli LIKE crm-atendente.cod-gr-cli NO-UNDO.

    FIND FIRST bfcrm-atendente WHERE 
        bfcrm-atendente.cod-estabel = pcod-estabel AND 
        bfcrm-atendente.cod-rep = pcod-rep AND 
        bfcrm-atendente.cd-unid-negoc = pcd-unid-negoc AND
        bfcrm-atendente.cd-categoria = pcd-categoria AND
        bfcrm-atendente.cod-gr-cli   = pcod-gr-cli NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfcrm-atendente THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfcrm-atendente)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

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

    OPEN QUERY {&QueryName} FOR EACH  {&TableName} NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openqueryzoom1 DBOProgram 
PROCEDURE openqueryzoom1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

OPEN QUERY {&queryname} FOR EACH {&tablename} USE-INDEX idx-crm-atendente NO-LOCK
    WHERE {&tablename}.cod-estabel >= v-cod-estabel-ini
      AND {&tablename}.cod-estabel <= v-cod-estabel-fin
      AND {&tablename}.cod-rep >= v-cod-rep-ini
      AND {&tablename}.cod-rep <= v-cod-rep-fin   
      AND {&tablename}.cd-unid-negoc >= v-unid-negoc-ini
      AND {&tablename}.cd-unid-negoc <= v-unid-negoc-fin     
      AND {&tablename}.cd-categoria >= v-cd-categoria-ini
      AND {&tablename}.cd-categoria <= v-cd-categoria-fin 
      AND {&tablename}.cd-atend >= v-cd-atend-ini
      AND {&tablename}.cd-atend <= v-cd-atend-fin
      AND {&tablename}.cod-gr-cli >= v-cod-gr-cli-ini
      AND {&tablename}.cod-gr-cli <= v-cod-gr-cli-fin INDEXED-REPOSITION.

    RETURN "ok".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setconstraintzoom1 DBOProgram 
PROCEDURE setconstraintzoom1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER p-cod-estabel-ini like {&tablename}.cod-estabel NO-UNDO.
DEFINE INPUT  PARAMETER p-cod-estabel-fin like {&tablename}.cod-estabel NO-UNDO.
DEFINE INPUT  PARAMETER p-cod-rep-ini like {&tablename}.cod-rep NO-UNDO.
DEFINE INPUT  PARAMETER p-cod-rep-fin like {&tablename}.cod-rep NO-UNDO.
DEFINE INPUT  PARAMETER p-unid-negoc-ini like {&tablename}.cd-unid-negoc NO-UNDO.
DEFINE INPUT  PARAMETER p-unid-negoc-fin like {&tablename}.cd-unid-negoc NO-UNDO.
DEFINE INPUT  PARAMETER p-cd-categoria-ini like {&tablename}.cd-categoria NO-UNDO.
DEFINE INPUT  PARAMETER p-cd-categoria-fin like {&tablename}.cd-categoria NO-UNDO.
DEFINE INPUT  PARAMETER p-cd-atend-ini like {&tablename}.cd-atend NO-UNDO.
DEFINE INPUT  PARAMETER p-cd-atend-fin like {&tablename}.cd-atend NO-UNDO.
DEFINE INPUT  PARAMETER p-cod-gr-cli-ini like {&tablename}.cod-gr-cli NO-UNDO.
DEFINE INPUT  PARAMETER p-cod-gr-cli-fin like {&tablename}.cod-gr-cli NO-UNDO.

ASSIGN v-cod-estabel-ini  = p-cod-estabel-ini
       v-cod-estabel-fin  = p-cod-estabel-fin
       v-cod-rep-ini      = p-cod-rep-ini
       v-cod-rep-fin      = p-cod-rep-fin
       v-unid-negoc-ini   = p-unid-negoc-ini 
       v-unid-negoc-fin   = p-unid-negoc-fin
       v-cd-categoria-ini = p-cd-categoria-ini
       v-cd-categoria-fin = p-cd-categoria-fin
       v-cd-atend-ini    = p-cd-atend-ini 
       v-cd-atend-fin    = p-cd-atend-fin 
       v-cod-gr-cli-ini   = p-cod-gr-cli-ini
       v-cod-gr-cli-fin   = p-cod-gr-cli-fin.

RETURN "OK".

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
    
    /*:T--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*:T--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as validaá‰es ---*/

    IF  pType = "Create":U THEN DO:
        IF  CAN-FIND(FIRST crm-atendente NO-LOCK
                     WHERE crm-atendente.cod-estabel   = rowObject.cod-estabel
                     AND   crm-atendente.cod-rep       = rowObject.cod-rep
                     AND   crm-atendente.cd-unid-negoc = rowObject.cd-unid-negoc
                     AND   crm-atendente.cd-categoria  = rowObject.cd-categoria
                     AND   crm-atendente.cod-gr-cli    = rowObject.cod-gr-cli) THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber     = 7
                                        &ErrorType       = "EMS"
                                        &ErrorParameters = "'Atendente'"}
        END.

        IF  NOT CAN-FIND(FIRST estabelec NO-LOCK
                         WHERE estabelec.cod-estabel = rowObject.cod-estabel) THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber     = 56
                                        &ErrorType       = "EMS"
                                        &ErrorParameters = "'Estabelecimento'"}
        END.

        IF  NOT CAN-FIND(FIRST repres NO-LOCK
                         WHERE repres.cod-rep = rowObject.cod-rep) THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber     = 56
                                        &ErrorType       = "EMS"
                                        &ErrorParameters = "'Representante'"}
        END.

        IF  NOT CAN-FIND(FIRST unid-comerc NO-LOCK
                         WHERE unid-comerc.cd-unid-comerc = INT(rowObject.cd-unid-negoc)) THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber     = 56
                                        &ErrorType       = "EMS"
                                        &ErrorParameters = "'Unidade Comercial'"}
        END.

        IF  NOT CAN-FIND(FIRST crm-categoria NO-LOCK
                         WHERE crm-categoria.cd-categoria = rowObject.cd-categoria) THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber     = 56
                                        &ErrorType       = "EMS"
                                        &ErrorParameters = "'Categoria'"}
        END.

        IF  NOT CAN-FIND(FIRST gr-cli NO-LOCK
                         WHERE gr-cli.cod-gr-cli = rowObject.cod-gr-cli) THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber     = 56
                                        &ErrorType       = "EMS"
                                        &ErrorParameters = "'Grupo de Cliente'"}
        END.
    END.

    IF  pType = "Create":U OR
        pType = "Update":U THEN DO:
        IF  NOT CAN-FIND(FIRST atendente NO-LOCK
                         WHERE atendente.cd-oper = rowObject.cd-atend) THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber     = 56
                                        &ErrorType       = "EMS"
                                        &ErrorParameters = "'Atendente'"}
        END.
    END.
    
    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

