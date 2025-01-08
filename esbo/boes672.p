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
&GLOBAL-DEFINE DBOName BOES672
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName auditoria-visual
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
{esbo/boes672.i RowObject}
{utp/ut-glob.i}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE VARIABLE i-nr-seq-auditoria AS INTEGER     NO-UNDO.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterUpdateRecord DBOProgram 
PROCEDURE afterUpdateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeCreateRecord DBOProgram 
PROCEDURE beforeCreateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo caracter
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE i-nova-seq AS INTEGER     NO-UNDO.

    
    IF AVAIL RowObject THEN DO:

        FOR LAST bf{&TableName} NO-LOCK
            WHERE bf{&TableName}.nr-seq-auditoria = RowObject.nr-seq-auditoria
            BY bf{&TableName}.nr-seq-audit-visual:
        END.

        IF AVAIL bf{&TableName} THEN DO:
            ASSIGN i-nova-seq = bf{&TableName}.nr-seq-audit-visual + 1.
        END.
        ELSE 
            ASSIGN i-nova-seq = 1.

        ASSIGN RowObject.nr-seq-audit-visual = i-nova-seq.

    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "des-serie":U THEN ASSIGN pFieldValue = RowObject.des-serie.
        WHEN "nr-cartao":U THEN ASSIGN pFieldValue = RowObject.nr-cartao.
        WHEN "obs-causa":U THEN ASSIGN pFieldValue = RowObject.obs-causa.
        WHEN "sigla":U THEN ASSIGN pFieldValue = RowObject.sigla.
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
        WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
        WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.
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
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        WHEN "qt-problema":U THEN ASSIGN pFieldValue = RowObject.qt-problema.
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
        WHEN "ind-problema":U THEN ASSIGN pFieldValue = RowObject.ind-problema.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "nr-seq-audit-visual":U THEN ASSIGN pFieldValue = RowObject.nr-seq-audit-visual.
        WHEN "nr-seq-auditoria":U THEN ASSIGN pFieldValue = RowObject.nr-seq-auditoria.
        WHEN "nr-seq-categoria":U THEN ASSIGN pFieldValue = RowObject.nr-seq-categoria.
        WHEN "nr-seq-comp":U THEN ASSIGN pFieldValue = RowObject.nr-seq-comp.
        WHEN "nr-seq-orig-prob":U THEN ASSIGN pFieldValue = RowObject.nr-seq-orig-prob.
        WHEN "nr-seq-problema":U THEN ASSIGN pFieldValue = RowObject.nr-seq-problema.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice id
  Parameters:  
               retorna valor do campo nr-seq-auditoria
               retorna valor do campo nr-seq-audit-visual
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pnr-seq-auditoria LIKE auditoria-visual.nr-seq-auditoria NO-UNDO.
    DEFINE OUTPUT PARAMETER pnr-seq-audit-visual LIKE auditoria-visual.nr-seq-audit-visual NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pnr-seq-auditoria = RowObject.nr-seq-auditoria
           pnr-seq-audit-visual = RowObject.nr-seq-audit-visual.

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
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
        WHEN "log-revisao":U THEN ASSIGN pFieldValue = RowObject.log-revisao.
        WHEN "log-bloqueio":U THEN ASSIGN pFieldValue = RowObject.log-bloqueio.
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
  Purpose:     Reposiciona registro com base no °ndice id
  Parameters:  
               recebe valor do campo nr-seq-auditoria
               recebe valor do campo nr-seq-audit-visual
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnr-seq-auditoria LIKE auditoria-visual.nr-seq-auditoria NO-UNDO.
    DEFINE INPUT PARAMETER pnr-seq-audit-visual LIKE auditoria-visual.nr-seq-audit-visual NO-UNDO.

    FIND FIRST bfauditoria-visual WHERE 
        bfauditoria-visual.nr-seq-auditoria = pnr-seq-auditoria AND 
        bfauditoria-visual.nr-seq-audit-visual = pnr-seq-audit-visual NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfauditoria-visual THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfauditoria-visual)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToAuditoria-geral DBOProgram 
PROCEDURE linkToAuditoria-geral :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER p-handle AS HANDLE      NO-UNDO.

    RUN getKey IN p-handle (OUTPUT i-nr-seq-auditoria).

    RUN setConstraintGeral IN THIS-PROCEDURE (INPUT i-nr-seq-auditoria).

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryGeral DBOProgram 
PROCEDURE openQueryGeral :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
        WHERE {&TableName}.nr-seq-auditoria = i-nr-seq-auditoria.


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

    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK.


    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintGeral DBOProgram 
PROCEDURE setConstraintGeral :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER p-nr-seq-auditoria   AS INTEGER NO-UNDO.


    ASSIGN i-nr-seq-auditoria = p-nr-seq-auditoria.


    RETURN "OK":u.

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

    /*:T--- Utilixze o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*:T--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as validaá‰es ---*/
    CASE pType:
        WHEN "Create" THEN DO:

            /*
            IF CAN-FIND(FIRST auditoria-visual NO-LOCK
                        WHERE auditoria-visual.nr-seq-auditoria = RowObject.nr-seq-auditoria
                          and auditoria-visual.nr-seq-audit-visual = RowObject.nr-seq-audit-visual) THEN DO:
                  {method/svc/errors/inserr.i
                         &ErrorNumber="1"
                         &ErrorType="Outros" &ErrorSubType="ERROR"
                         &ErrorDescription="Chave incorreta."
                         &ErrorHelp="Auditoria Visual j† cadastrada com chave informada."}

            END.
            */

            IF RowObject.nr-seq-orig-prob <= 0 THEN DO:
                {method/svc/errors/inserr.i
                             &ErrorNumber="17006"
                             &ErrorType="Outros" &ErrorSubType="ERROR"
                             &ErrorDescription="Origem Problema incorreto."
                             &ErrorHelp="Origem Problema deve ser informado."}
            END.

            if not can-find(first aq-origem-prob
                            where aq-origem-prob.nr-seq-orig-prob = RowObject.nr-seq-orig-prob) then do:
                {method/svc/errors/inserr.i
                             &ErrorNumber="17006"
                             &ErrorType="Outros" &ErrorSubType="ERROR"
                             &ErrorDescription="Origem Problema inexistente."
                             &ErrorHelp="Origem Problema informada n∆o existe no cadastro de Origens Problemas."}

            end.

            if can-find(first aq-origem-prob
                        where aq-origem-prob.nr-seq-orig-prob = RowObject.nr-seq-orig-prob
                          AND aq-origem-prob.log-inativo) then do:
                {method/svc/errors/inserr.i
                             &ErrorNumber="17006"
                             &ErrorType="Outros" &ErrorSubType="ERROR"
                             &ErrorDescription="Origem Problema Inativo."
                             &ErrorHelp="Origem Problema informado est† inativo no cadastro de Origens Problemas."}

            end.                        

            IF RowObject.nr-seq-problema <= 0 THEN DO:
                {method/svc/errors/inserr.i
                             &ErrorNumber="17006"
                             &ErrorType="Outros" &ErrorSubType="ERROR"
                             &ErrorDescription="Problema incorreto."
                             &ErrorHelp="Problema deve ser informado."}
            END.

            if not can-find(first aq-problema
                            where aq-problema.nr-seq-problema = RowObject.nr-seq-problema) then do:
                {method/svc/errors/inserr.i
                             &ErrorNumber="17006"
                             &ErrorType="Outros" &ErrorSubType="ERROR"
                             &ErrorDescription="Problema inexistente."
                             &ErrorHelp="Problema informada n∆o existe no cadastro de Problemas."}

            end.

            if can-find(first aq-problema
                        where aq-problema.nr-seq-problema = RowObject.nr-seq-problema
                          AND aq-problema.log-inativo) then do:
                {method/svc/errors/inserr.i
                             &ErrorNumber="17006"
                             &ErrorType="Outros" &ErrorSubType="ERROR"
                             &ErrorDescription="Problema inativo."
                             &ErrorHelp="Problema informado est† inativo no cadastro de Problemas."}

            end.

            IF RowObject.des-serie = "" THEN DO:
                {method/svc/errors/inserr.i
                             &ErrorNumber="17006"
                             &ErrorType="Outros" &ErrorSubType="ERROR"
                             &ErrorDescription="SÇrie/Roteiro incorreto."
                             &ErrorHelp="SÇrie/Roteiro deve ser informado."}
            END.

            IF RowObject.qt-problema <= 0 THEN DO:
                {method/svc/errors/inserr.i
                             &ErrorNumber="17006"
                             &ErrorType="Outros" &ErrorSubType="ERROR"
                             &ErrorDescription="Quantidade incorreta."
                             &ErrorHelp="Quantidade Problema deve ser informado."}
            END.

            IF RowObject.nr-seq-comp <= 0 THEN DO:
                {method/svc/errors/inserr.i
                             &ErrorNumber="17006"
                             &ErrorType="Outros" &ErrorSubType="ERROR"
                             &ErrorDescription="Componente incorreto."
                             &ErrorHelp="Componente deve ser informado."}
            END.

            if not can-find(first aq-comp-prod
                            where aq-comp-prod.nr-seq-comp = RowObject.nr-seq-comp) then do:
                {method/svc/errors/inserr.i
                             &ErrorNumber="17006"
                             &ErrorType="Outros" &ErrorSubType="ERROR"
                             &ErrorDescription="Componente inexistente."
                             &ErrorHelp="Componente informada n∆o existe no cadastro de Componentes."}

            end.

            if can-find(first aq-comp-prod
                        where aq-comp-prod.nr-seq-comp = RowObject.nr-seq-comp
                          AND NOT aq-comp-prod.log-ativo) then do:
                {method/svc/errors/inserr.i
                             &ErrorNumber="17006"
                             &ErrorType="Outros" &ErrorSubType="ERROR"
                             &ErrorDescription="Componente inativo."
                             &ErrorHelp="Componente informada est† inativo no cadastro de Componentes."}

            end.

            IF RowObject.nr-seq-categoria <= 0 THEN DO:
                {method/svc/errors/inserr.i
                             &ErrorNumber="17006"
                             &ErrorType="Outros" &ErrorSubType="ERROR"
                             &ErrorDescription="Categoria incorreta."
                             &ErrorHelp="Categoria deve ser informado."}
            END.

            if not can-find(first aq-categoria
                            where aq-categoria.nr-seq-categoria = RowObject.nr-seq-categoria) then do:
                {method/svc/errors/inserr.i
                             &ErrorNumber="17006"
                             &ErrorType="Outros" &ErrorSubType="ERROR"
                             &ErrorDescription="Categoria inexistente."
                             &ErrorHelp="Categoria informada n∆o existe no cadastro de Categorias."}

            end.

            IF RowObject.obs-causa = "" THEN DO:
                {method/svc/errors/inserr.i
                             &ErrorNumber="17006"
                             &ErrorType="Outros" &ErrorSubType="ERROR"
                             &ErrorDescription="Informar a Causa."
                             &ErrorHelp="N∆o foi poss°vel salvar o problema."}
            END.
            
        END.
        WHEN "UPDATE" THEN DO:
            IF RowObject.nr-seq-orig-prob <= 0 THEN DO:
                {method/svc/errors/inserr.i
                             &ErrorNumber="17006"
                             &ErrorType="Outros" &ErrorSubType="ERROR"
                             &ErrorDescription="Origem Problema incorreto."
                             &ErrorHelp="Origem Problema deve ser informado."}
            END.

            IF RowObject.des-serie = "" THEN DO:
                {method/svc/errors/inserr.i
                             &ErrorNumber="17006"
                             &ErrorType="Outros" &ErrorSubType="ERROR"
                             &ErrorDescription="SÇrie/Roteiro incorreto."
                             &ErrorHelp="SÇrie/Roteiro deve ser informado."}
            END.

            IF RowObject.qt-problema <= 0 THEN DO:
                {method/svc/errors/inserr.i
                             &ErrorNumber="17006"
                             &ErrorType="Outros" &ErrorSubType="ERROR"
                             &ErrorDescription="Quantidade incorreta."
                             &ErrorHelp="Quantidade Problema deve ser informado."}
            END.

            IF RowObject.nr-seq-comp <= 0 THEN DO:
                {method/svc/errors/inserr.i
                             &ErrorNumber="17006"
                             &ErrorType="Outros" &ErrorSubType="ERROR"
                             &ErrorDescription="Componente incorreto."
                             &ErrorHelp="Componente deve ser informado."}
            END.

            if not can-find(first aq-comp-prod
                            where aq-comp-prod.nr-seq-comp = RowObject.nr-seq-comp) then do:
                {method/svc/errors/inserr.i
                             &ErrorNumber="17006"
                             &ErrorType="Outros" &ErrorSubType="ERROR"
                             &ErrorDescription="Componente inexistente."
                             &ErrorHelp="Componente informada n∆o existe no cadastro de Componentes."}

            end.

            IF RowObject.nr-seq-categoria <= 0 THEN DO:
                {method/svc/errors/inserr.i
                             &ErrorNumber="17006"
                             &ErrorType="Outros" &ErrorSubType="ERROR"
                             &ErrorDescription="Categoria incorreta."
                             &ErrorHelp="Categoria deve ser informado."}
            END.

            IF RowObject.obs-causa = "" THEN DO:
                {method/svc/errors/inserr.i
                             &ErrorNumber="17006"
                             &ErrorType="Outros" &ErrorSubType="ERROR"
                             &ErrorDescription="Informar a Causa."
                             &ErrorHelp="N∆o foi poss°vel salvar o problema."}
            END.

            if not can-find(first aq-categoria
                            where aq-categoria.nr-seq-categoria = RowObject.nr-seq-categoria) then do:
                {method/svc/errors/inserr.i
                             &ErrorNumber="17006"
                             &ErrorType="Outros" &ErrorSubType="ERROR"
                             &ErrorDescription="Categoria inexistente."
                             &ErrorHelp="Categoria informada n∆o existe no cadastro de Categorias."}

            end.
        END.
    END CASE.

    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    FIND FIRST auditoria-geral EXCLUSIVE-LOCK
         WHERE auditoria-geral.nr-seq-auditoria = RowObject.nr-seq-auditoria  NO-ERROR.
    
    IF AVAIL auditoria-geral THEN DO:
        ASSIGN auditoria-geral.des-auditor = c-seg-usuario.
    
        FIND CURRENT auditoria-geral NO-LOCK.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

