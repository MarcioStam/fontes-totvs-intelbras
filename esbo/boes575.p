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
&GLOBAL-DEFINE DBOName BOES575
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName def-transportes
&GLOBAL-DEFINE TableLabel 
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
{esbo/boes575.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE VARIABLE codTransIni     LIKE {&TableName}.cod-trans.
DEFINE VARIABLE codTransFim     LIKE {&TableName}.cod-trans.
DEFINE VARIABLE codEstabIni     LIKE {&TableName}.cod-estabel.
DEFINE VARIABLE codEstabFim     LIKE {&TableName}.cod-estabel.
DEFINE VARIABLE codClienteIni   LIKE {&TableName}.cod-cliente.
DEFINE VARIABLE codClienteFim   LIKE {&TableName}.cod-cliente.
DEFINE VARIABLE codCidadeIni    LIKE {&TableName}.cod-cidade.
DEFINE VARIABLE codCidadeFim    LIKE {&TableName}.cod-cidade.
DEFINE VARIABLE codEstadoIni    LIKE {&TableName}.cod-uf.
DEFINE VARIABLE codEstadoFim    LIKE {&TableName}.cod-uf.
DEFINE VARIABLE cdUnidComercIni  LIKE {&TableName}.cd-unid-comerc.
DEFINE VARIABLE cdUnidComercFim  LIKE {&TableName}.cd-unid-comerc.

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
         HEIGHT             = 8.71
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
        WHEN "cod-cidade":U THEN ASSIGN pFieldValue = RowObject.cod-cidade.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-cliente":U THEN ASSIGN pFieldValue = RowObject.cod-cliente.
        WHEN "cod-uf":U THEN ASSIGN pFieldValue = RowObject.cod-uf.
        WHEN "sigla-trans":U THEN ASSIGN pFieldValue = RowObject.sigla-trans.
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
        WHEN "cod-trans":U THEN ASSIGN pFieldValue = RowObject.cod-trans.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice codigo
  Parameters:  
               retorna valor do campo cod-trans
               retorna valor do campo cod-estabel
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-estabel    LIKE def-transportes.cod-estabel    NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-uf         LIKE def-transportes.cod-uf         NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-cidade     LIKE def-transportes.cod-cidade     NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-cliente    LIKE def-transportes.cod-cliente    NO-UNDO.
    

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-estabel = RowObject.cod-estabel
           pcod-uf = RowObject.cod-uf
           pcod-cidade = RowObject.cod-cidade
           pcod-cliente = RowObject.cod-cliente.

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
  Purpose:     Reposiciona registro com base no °ndice codigo
  Parameters:  
               recebe valor do campo cod-trans
               recebe valor do campo cod-estabel
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estabel    LIKE def-transportes.cod-estabel    NO-UNDO.
    DEFINE INPUT PARAMETER pcod-uf         LIKE def-transportes.cod-uf         NO-UNDO.
    DEFINE INPUT PARAMETER pcod-cidade     LIKE def-transportes.cod-cidade     NO-UNDO.
    DEFINE INPUT PARAMETER pcod-cliente    LIKE def-transportes.cod-cliente    NO-UNDO.
    DEFINE INPUT PARAMETER pcd-unid-comerc LIKE def-transportes.cd-unid-comerc NO-UNDO.

    FIND FIRST bfdef-transportes WHERE 
        bfdef-transportes.cod-estabel = pcod-estabel AND 
        bfdef-transportes.cod-uf = pcod-uf AND
        bfdef-transportes.cod-cidade = pcod-cidade AND
        bfdef-transportes.cod-cliente = pcod-cliente AND
        bfdef-transportes.cd-unid-comerc = pcd-unid-comerc NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfdef-transportes THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfdef-transportes)).
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
    OPEN QUERY {&QueryName} FOR EACH  {&TableName} NO-LOCK.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryZoom DBOProgram 
PROCEDURE openQueryZoom :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH  {&TableName} WHERE
                    {&TableName}.cod-trans      >= codTransIni     AND
                    {&TableName}.cod-trans      <= codTransFim     AND
                    {&TableName}.cod-estabel    >= codEstabIni     AND
                    {&TableName}.cod-estabel    <= codEstabFim     AND
                    {&TableName}.cod-cliente    >= codClienteIni   AND
                    {&TableName}.cod-cliente    <= codClienteFim   AND
                    {&TableName}.cod-cidade     >= codCidadeIni    AND
                    {&TableName}.cod-cidade     <= codCidadeFim    AND
                    {&TableName}.cod-uf         >= codEstadoIni    AND
                    {&TableName}.cod-uf         <= codEstadoFim    AND
                    {&TableName}.cd-unid-comerc >= cdUnidComercIni AND
                    {&TableName}.cd-unid-comerc <= cdUnidComercFim NO-LOCK.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintZoom DBOProgram 
PROCEDURE setConstraintZoom :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pTransIni      LIKE {&TableName}.cod-trans.
    DEFINE INPUT PARAMETER pTransFim      LIKE {&TableName}.cod-trans.
    DEFINE INPUT PARAMETER pEstabIni      LIKE {&TableName}.cod-estabel.
    DEFINE INPUT PARAMETER pEstabFim      LIKE {&TableName}.cod-estabel.
    DEFINE INPUT PARAMETER pClienteIni    LIKE {&TableName}.cod-cliente.
    DEFINE INPUT PARAMETER pClienteFim    LIKE {&TableName}.cod-cliente.
    DEFINE INPUT PARAMETER pCidadeIni     LIKE {&TableName}.cod-cidade.
    DEFINE INPUT PARAMETER pCidadeFim     LIKE {&TableName}.cod-cidade.
    DEFINE INPUT PARAMETER pEstadoIni     LIKE {&TableName}.cod-uf.
    DEFINE INPUT PARAMETER pEstadoFim     LIKE {&TableName}.cod-uf.
    DEFINE INPUT PARAMETER pUnidComercIni LIKE {&TableName}.cd-unid-comerc.
    DEFINE INPUT PARAMETER pUnidComercFim LIKE {&TableName}.cd-unid-comerc.

    ASSIGN codTransIni     = pTransIni  
           codTransFim     = pTransFim  
           codEstabIni     = pEstabIni  
           codEstabFim     = pEstabFim  
           codClienteIni   = pClienteIni
           codClienteFim   = pClienteFim
           codCidadeIni    = pCidadeIni 
           codCidadeFim    = pCidadeFim 
           codEstadoIni    = pEstadoIni 
           codEstadoFim    = pEstadoFim
           cdUnidComercIni = pUnidComercIni
           cdUnidComercFim = pUnidComercFim.

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

     /*:T--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/

    IF pType = "Create" THEN DO:
        IF CAN-FIND(FIRST def-transportes WHERE 
                    def-transportes.cod-estabel    = RowObject.cod-estabel AND
                    def-transportes.cod-uf         = RowObject.cod-uf      AND
                    def-transportes.cod-cidade     = RowObject.cod-cidade  AND
                    def-transportes.cod-cliente    = RowObject.cod-cliente AND
                    def-transportes.cd-unid-comerc = RowObject.cd-unid-comerc ) THEN DO:
            {method/svc/errors/inserr.i
                         &ErrorNumber="1"
                         &ErrorType="EMS" &ErrorSubType="ERROR"
                         &ErrorParameters="'Definiá∆o Transportes'"}
        END.
    END.
    
    IF pType = "Create" OR pType = "Update" THEN DO:

        IF NOT CAN-FIND(FIRST estabelec WHERE estabelec.cod-estabel = RowObject.cod-estabel) THEN DO:
            {method/svc/errors/inserr.i
                         &ErrorNumber="2"
                         &ErrorType="EMS" &ErrorSubType="ERROR"
                         &ErrorParameters="'Estabelecimento Origem'"}
        END.

        IF NOT CAN-FIND(FIRST transporte WHERE transporte.cod-transp = RowObject.cod-trans) THEN DO:
            {method/svc/errors/inserr.i
                         &ErrorNumber="2"
                         &ErrorType="EMS" &ErrorSubType="ERROR"
                         &ErrorParameters="'Transportadora'"}
        END.

        IF RowObject.cod-cidade <> "":U THEN DO:
            IF NOT CAN-FIND(FIRST mgcad.cidade 
                      WHERE cidade.cidade = RowObject.cod-cidade 
                        AND cidade.estado = RowObject.cod-uf) THEN DO:
                {method/svc/errors/inserr.i
                             &ErrorNumber="2"
                             &ErrorType="EMS" &ErrorSubType="ERROR"
                             &ErrorParameters="'Cidade Destino'"}
            END.

            IF NOT CAN-FIND(FIRST unid-feder WHERE unid-feder.estado = RowObject.cod-uf) THEN DO:
                {method/svc/errors/inserr.i
                             &ErrorNumber="2"
                             &ErrorType="EMS" &ErrorSubType="ERROR"
                             &ErrorParameters="'UF Destino'"}
            END.

        END.
        ELSE DO:
        
            IF RowObject.cod-uf <> "":U THEN DO:
                IF NOT CAN-FIND(FIRST unid-feder WHERE unid-feder.estado = RowObject.cod-uf) THEN DO:
                    {method/svc/errors/inserr.i
                                 &ErrorNumber="2"
                                 &ErrorType="EMS" &ErrorSubType="ERROR"
                                 &ErrorParameters="'UF Destino'"}
                END.
            END.

        END.

        IF  RowObject.cd-unid-comerc <> 0 THEN DO:
            IF NOT CAN-FIND(FIRST unid-comerc WHERE unid-comerc.cd-unid-comerc = RowObject.cd-unid-comerc) THEN DO:
                {method/svc/errors/inserr.i
                             &ErrorNumber="2"
                             &ErrorType="EMS" &ErrorSubType="ERROR"
                             &ErrorParameters="'Unidade Comercial'"}
            END.
        END.

        IF RowObject.cod-cliente <> "" THEN DO:
        
            IF NOT CAN-FIND(FIRST emitente WHERE emitente.cod-emitente = INT(RowObject.cod-cliente)) THEN DO:
                {method/svc/errors/inserr.i
                             &ErrorNumber="2"
                             &ErrorType="EMS" &ErrorSubType="ERROR"
                             &ErrorParameters="'Cliente Destino'"}
            END.

        END.

        IF RowObject.cod-cliente = "":U AND RowObject.cod-uf = "":U AND RowObject.cod-cidade = "":U THEN DO:

             {method/svc/errors/inserr.i
                             &ErrorNumber="17006"
                             &ErrorType="EMS" &ErrorSubType="ERROR"
                             &ErrorParameters="'ê Necess†rio Informar ao menos um dos campos (Cliente Destino, Cidade Destino ou UF Destino)'"}
        END.

    END.
   
    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

