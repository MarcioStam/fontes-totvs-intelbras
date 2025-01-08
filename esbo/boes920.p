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
&GLOBAL-DEFINE DBOName BOES920
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName int-def-sigla-transp
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
{esbo/boes920.i RowObject}


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
DEFINE VARIABLE codCepInicial   LIKE {&TableName}.cep-inicial.
DEFINE VARIABLE codCepFinal     LIKE {&TableName}.cep-final.
DEFINE VARIABLE codCidadeIni    LIKE {&TableName}.cidade.
DEFINE VARIABLE codCidadeFim    LIKE {&TableName}.cidade.
DEFINE VARIABLE codEstadoIni    LIKE {&TableName}.estado.
DEFINE VARIABLE codEstadoFim    LIKE {&TableName}.estado.
DEFINE VARIABLE codEmitenteIni  LIKE {&TableName}.cod-emitente.
DEFINE VARIABLE codEmitentefim  LIKE {&TableName}.cod-emitente.


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
        WHEN "cidade":U   THEN ASSIGN pFieldValue = RowObject.cidade.
        WHEN "cod-inicial":U  THEN ASSIGN pFieldValue = RowObject.cep-inicial.
        WHEN "cod-final":U    THEN ASSIGN pFieldValue = RowObject.cep-final.
        WHEN "cod-estabel":U  THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "estado":U       THEN ASSIGN pFieldValue = RowObject.estado.
        WHEN "sigla-transp":U THEN ASSIGN pFieldValue = RowObject.sigla-trans.
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
        WHEN "cod-transp":U THEN ASSIGN pFieldValue = RowObject.cod-trans.
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
    DEFINE OUTPUT PARAMETER pcod-transp     LIKE int-def-sigla-transp.cod-transp     NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-estabel    LIKE int-def-sigla-transp.cod-estabel    NO-UNDO.
    DEFINE OUTPUT PARAMETER pcep-inicial    LIKE int-def-sigla-transp.cep-inicial    NO-UNDO.
    DEFINE OUTPUT PARAMETER pcep-final      LIKE int-def-sigla-transp.cep-final      NO-UNDO.
    DEFINE OUTPUT PARAMETER p-estado        LIKE int-def-sigla-transp.estado         NO-UNDO.
    DEFINE OUTPUT PARAMETER pcidade         LIKE int-def-sigla-transp.cidade         NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-emitente   LIKE int-def-sigla-transp.cod-emitente   NO-UNDO.
    

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-transp   = RowObject.cod-transp
           pcod-estabel  = RowObject.cod-estabel
           pcep-inicial  = RowObject.cep-inicial
           pcep-final    = RowObject.cep-final
           p-estado      = RowObject.estado
           pcidade       = RowObject.cidade
           pcod-emitente = RowObject.cod-emitente.
           

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
    DEFINE INPUT PARAMETER pcod-transp     LIKE int-def-sigla-transp.cod-transp     NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel    LIKE int-def-sigla-transp.cod-estabel    NO-UNDO.
    DEFINE INPUT PARAMETER pcep-inicial    LIKE int-def-sigla-transp.cep-inicial    NO-UNDO.
    DEFINE INPUT PARAMETER pcep-final      LIKE int-def-sigla-transp.cep-final      NO-UNDO.
    DEFINE INPUT PARAMETER p-estado        LIKE int-def-sigla-transp.estado         NO-UNDO.
    DEFINE INPUT PARAMETER pcidade         LIKE int-def-sigla-transp.cidade         NO-UNDO.
    DEFINE INPUT PARAMETER pcod-emitente   LIKE int-def-sigla-transp.cod-emitente   NO-UNDO.
    

    FIND FIRST bfint-def-sigla-transp 
         WHERE bfint-def-sigla-transp.cod-transp     = pcod-transp
           AND bfint-def-sigla-transp.cod-estabel    = pcod-estabel 
           AND bfint-def-sigla-transp.cep-inicial    = pcep-inicial 
           AND bfint-def-sigla-transp.cep-final      = pcep-final
           AND bfint-def-sigla-transp.estado         = p-estado 
           AND bfint-def-sigla-transp.cidade         = pcidade 
           AND bfint-def-sigla-transp.cod-emitente   = pcod-emitente
            NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfint-def-sigla-transp THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfint-def-sigla-transp)).
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
                    {&TableName}.cep-inicial    >= codCepInicial   AND
                    {&TableName}.cep-final      <= codcepFinal     AND
                    {&TableName}.cidade         >= codCidadeIni    AND
                    {&TableName}.cidade         <= codCidadeFim    AND
                    {&TableName}.estado         >= codEstadoIni    AND
                    {&TableName}.estado         <= codEstadoFim    AND
                    {&TableName}.cod-emitente   >= codEmitenteIni  AND
                    {&TableName}.cod-emitente   <= codEmitenteFim     NO-LOCK.
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
    DEFINE INPUT PARAMETER pCepIni        LIKE {&TableName}.cep-inicial.
    DEFINE INPUT PARAMETER pCepfim        LIKE {&TableName}.cep-final.
    DEFINE INPUT PARAMETER pEstadoIni     LIKE {&TableName}.estado.
    DEFINE INPUT PARAMETER pEstadoFim     LIKE {&TableName}.estado.
    DEFINE INPUT PARAMETER pCidadeIni     LIKE {&TableName}.cidade.
    DEFINE INPUT PARAMETER pCidadeFim     LIKE {&TableName}.cidade.
    DEFINE INPUT PARAMETER pEmitenteIni   LIKE {&TableName}.cod-emitente.
    DEFINE INPUT PARAMETER pEmitenteFim   LIKE {&TableName}.cod-emitente.

    ASSIGN codTransIni     = pTransIni  
           codTransFim     = pTransFim  
           codEstabIni     = pEstabIni  
           codEstabFim     = pEstabFim  
           codCepInicial   = pCepIni
           codCepfinal     = pCepfim
           codCidadeIni    = pCidadeIni 
           codCidadeFim    = pCidadeFim 
           codEstadoIni    = pEstadoIni 
           codEstadoFim    = pEstadoFim
           codEmitenteIni  = pEmitenteIni
           codEmitentefim  = pEmitenteFim.

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
        IF CAN-FIND(FIRST int-def-sigla-transp 
                       WHERE int-def-sigla-transp.cod-transp     = RowObject.cod-transp
                         AND int-def-sigla-transp.cod-estabel    = RowObject.cod-estabel 
                         AND int-def-sigla-transp.cep-inicial    = RowObject.cep-inicial
                         AND int-def-sigla-transp.cep-final      = RowObject.cep-final
                         AND int-def-sigla-transp.estado         = RowObject.estado      
                         AND int-def-sigla-transp.cidade         = RowObject.cidade   
                         AND int-def-sigla-transp.cod-emitente   = RowObject.cod-emitente   ) THEN DO:
            {method/svc/errors/inserr.i
                         &ErrorNumber="1"
                         &ErrorType="EMS" &ErrorSubType="ERROR"
                         &ErrorParameters="'Definiá∆o Sigla Transportes'"}
        END.
    END.
    
    IF pType = "Create" OR pType = "Update" THEN DO:

        IF NOT CAN-FIND(FIRST estabelec WHERE estabelec.cod-estabel = RowObject.cod-estabel) THEN DO:
            {method/svc/errors/inserr.i
                         &ErrorNumber="2"
                         &ErrorType="EMS" &ErrorSubType="ERROR"
                         &ErrorParameters="'Estabelecimento Origem'"}
        END.

        IF NOT CAN-FIND(FIRST emitente WHERE emitente.cod-emitente = RowObject.cod-emitente) THEN DO:
            {method/svc/errors/inserr.i
                         &ErrorNumber="2"
                         &ErrorType="EMS" &ErrorSubType="ERROR"
                         &ErrorParameters="'Emitente'"}
        END.

        IF NOT CAN-FIND(FIRST transporte WHERE transporte.cod-transp = RowObject.cod-transp) THEN DO:
            {method/svc/errors/inserr.i
                         &ErrorNumber="2"
                         &ErrorType="EMS" &ErrorSubType="ERROR"
                         &ErrorParameters="'Transportadora'"}
        END.

        IF RowObject.cidade <> "":U THEN DO:
            IF NOT CAN-FIND(FIRST mgcad.cidade 
                      WHERE cidade.cidade = RowObject.cidade 
                        AND cidade.estado = RowObject.estado) THEN DO:
                {method/svc/errors/inserr.i
                             &ErrorNumber="2"
                             &ErrorType="EMS" &ErrorSubType="ERROR"
                             &ErrorParameters="'Cidade Destino'"}
            END.

            IF NOT CAN-FIND(FIRST unid-feder WHERE unid-feder.estado = RowObject.estado) THEN DO:
                {method/svc/errors/inserr.i
                             &ErrorNumber="2"
                             &ErrorType="EMS" &ErrorSubType="ERROR"
                             &ErrorParameters="'UF Destino'"}
            END.

        END.
        ELSE DO:
        
            IF RowObject.estado <> "":U THEN DO:
                IF NOT CAN-FIND(FIRST unid-feder WHERE unid-feder.estado = RowObject.estado) THEN DO:
                    {method/svc/errors/inserr.i
                                 &ErrorNumber="2"
                                 &ErrorType="EMS" &ErrorSubType="ERROR"
                                 &ErrorParameters="'UF Destino'"}
                END.
            END.

        END.

        IF RowObject.cep-inicial = "" THEN DO:
             {method/svc/errors/inserr.i
                             &ErrorNumber="17006"
                             &ErrorType="EMS" &ErrorSubType="ERROR"
                             &ErrorParameters="'CEP Inicial deve ser informado'"}
        END.
        IF RowObject.cep-final = "" THEN DO:
             {method/svc/errors/inserr.i
                             &ErrorNumber="17006"
                             &ErrorType="EMS" &ErrorSubType="ERROR"
                             &ErrorParameters="'CEP Final deve ser informado'"}
        END.

    END.
   
    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

