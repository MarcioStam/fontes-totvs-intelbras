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
&GLOBAL-DEFINE DBOName BOES671
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName auditoria-geral
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
      
{esbo/boes671.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}

DEFINE VARIABLE c-cod-estabel-ini      AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-cod-estabel-fim      AS CHARACTER NO-UNDO.
DEFINE VARIABLE i-nr-seq-auditoria-ini AS INTEGER   NO-UNDO.
DEFINE VARIABLE i-nr-seq-auditoria-fim AS INTEGER   NO-UNDO.
DEFINE VARIABLE c-it-codigo-ini        AS character NO-UNDO.
DEFINE VARIABLE c-it-codigo-fim        AS character NO-UNDO.


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.
{utp/ut-glob.i}
{esp/es0018.i}

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
         HEIGHT             = 13.42
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterDeleteRecord DBOProgram 
PROCEDURE AfterDeleteRecord :
/*** Elimina filhos auditoria-visual ***/
    for each auditoria-visual exclusive-lock
       where auditoria-visual.nr-seq-auditoria = RowObject.nr-seq-auditoria:
        delete auditoria-visual.
    end.

    /*** Elimina filhos auditoria-adicional ***/
    for each auditoria-adicional exclusive-lock
       where auditoria-adicional.nr-seq-auditoria = RowObject.nr-seq-auditoria:
        delete auditoria-adicional.
    end.
    
    /*** Elimina filhos auditoria-observacao ***/
    for each auditoria-observacao exclusive-lock
       where auditoria-observacao.nr-seq-auditoria = RowObject.nr-seq-auditoria:
        delete auditoria-observacao.
    end.

    /*** Elimina filhos auditoria-anexo ***/
    for each auditoria-anexo exclusive-lock
       where auditoria-anexo.nr-seq-auditoria = RowObject.nr-seq-auditoria:
        delete auditoria-anexo.
    end.

    FOR FIRST auditoria-geral EXCLUSIVE-LOCK
        WHERE auditoria-geral.nr-seq-auditoria = RowObject.cod-audit-origem:

        ASSIGN auditoria-geral.cont-reinspecao = auditoria-geral.cont-reinspecao - 1.

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
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-unid-negoc":U THEN ASSIGN pFieldValue = RowObject.cod-unid-negoc.
        WHEN "des-auditor":U THEN ASSIGN pFieldValue = RowObject.des-auditor.
        WHEN "descricao":U THEN ASSIGN pFieldValue = RowObject.descricao.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
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
        WHEN "dt-amostragem":U THEN ASSIGN pFieldValue = RowObject.dt-amostragem.
        WHEN "dt-revisao":U THEN ASSIGN pFieldValue = RowObject.dt-revisao.
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
        WHEN "dec-1":U          THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U          THEN ASSIGN pFieldValue = RowObject.dec-2.
        WHEN "qt-apar-test":U   THEN ASSIGN pFieldValue = RowObject.qt-apar-test.
        WHEN "qt-prod-lote":U   THEN ASSIGN pFieldValue = RowObject.qt-prod-lote.
        WHEN "qtd-prod-revis":U THEN ASSIGN pFieldValue = RowObject.qtd-prod-revis.
        WHEN "qtd-prod-bloq":U  THEN ASSIGN pFieldValue = RowObject.qtd-prod-bloq.
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
        WHEN "cod-audit-origem":U THEN ASSIGN pFieldValue = RowObject.cod-audit-origem.
        WHEN "cont-reinspecao":U THEN ASSIGN pFieldValue = RowObject.cont-reinspecao.
        WHEN "ind-amostragem":U THEN ASSIGN pFieldValue = RowObject.ind-amostragem.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "nr-seq-auditoria":U THEN ASSIGN pFieldValue = RowObject.nr-seq-auditoria.
        WHEN "nr-seq-tipo-lote":U THEN ASSIGN pFieldValue = RowObject.nr-seq-tipo-lote.
        WHEN "cod-turno":U THEN ASSIGN pFieldValue = RowObject.cod-turno.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice prun
  Parameters:  
               retorna valor do campo nr-seq-auditoria
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pnr-seq-auditoria LIKE auditoria-geral.nr-seq-auditoria NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pnr-seq-auditoria = RowObject.nr-seq-auditoria.

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
        WHEN "log-1":U          THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U          THEN ASSIGN pFieldValue = RowObject.log-2.
        WHEN "log-reinspecao":U THEN ASSIGN pFieldValue = RowObject.log-reinspecao.
        WHEN "log-revisado":U   THEN ASSIGN pFieldValue = RowObject.log-revisado.
        WHEN "log-bloqueio":U   THEN ASSIGN pFieldValue = RowObject.log-bloqueio.
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
  Purpose:     Reposiciona registro com base no °ndice prun
  Parameters:  
               recebe valor do campo nr-seq-auditoria
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnr-seq-auditoria LIKE auditoria-geral.nr-seq-auditoria NO-UNDO.

    FIND FIRST bfauditoria-geral WHERE 
        bfauditoria-geral.nr-seq-auditoria = pnr-seq-auditoria NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfauditoria-geral THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfauditoria-geral)).
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

    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryNC DBOProgram 
PROCEDURE openQueryNC :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QueryName} FOR EACH {&TableName} 
        WHERE {&TableName}.cod-estabel >= c-cod-estabel-ini
        AND   {&TableName}.cod-estabel <= c-cod-estabel-fim
        AND   {&TableName}.nr-seq-auditoria >= i-nr-seq-auditoria-ini
        AND   {&TableName}.nr-seq-auditoria <= i-nr-seq-auditoria-fim
        and   {&TableName}.it-codigo        >= c-it-codigo-ini
        and   {&TableName}.it-codigo        <= c-it-codigo-fim
        NO-LOCK.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintNC DBOProgram 
PROCEDURE setConstraintNC :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER p-cod-estabel-ini       AS char  NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-estabel-fim       AS char  NO-UNDO.
    DEFINE INPUT PARAMETER p-nr-seq-auditoria-ini  AS int   NO-UNDO.
    DEFINE INPUT PARAMETER p-nr-seq-auditoria-fim  AS int   NO-UNDO.
    DEFINE INPUT PARAMETER p-it-codigo-ini         AS char  NO-UNDO.
    DEFINE INPUT PARAMETER p-it-codigo-fim         AS char  NO-UNDO.

    ASSIGN c-cod-estabel-ini       = p-cod-estabel-ini     
           c-cod-estabel-fim       = p-cod-estabel-fim     
           i-nr-seq-auditoria-ini  = p-nr-seq-auditoria-ini 
           i-nr-seq-auditoria-fim  = p-nr-seq-auditoria-fim
           c-it-codigo-ini         = p-it-codigo-ini       
           c-it-codigo-fim         = p-it-codigo-fim.

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
    DEFINE VARIABLE d-dt-limite AS DATE        NO-UNDO.
    
    /*:T--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*:T--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as validaá‰es ---*/

    
    IF DAY(TODAY) < 8 THEN
       ASSIGN d-dt-limite = TODAY - DAY(TODAY)
              d-dt-limite = d-dt-limite - DAY(d-dt-limite).
    ELSE
       ASSIGN d-dt-limite = TODAY - DAY(TODAY).

    IF RowObject.dt-amostragem <= d-dt-limite THEN DO:
       EMPTY TEMP-TABLE tt-prog-ponto.
       RUN esp/es0018p.p (INPUT "esaqp010":U,
                          INPUT 1,
                          INPUT 0,
                          INPUT "":U,
                          OUTPUT TABLE tt-prog-ponto).
       FIND FIRST tt-prog-ponto 
            WHERE tt-prog-ponto.conteudo = c-seg-usuario NO-ERROR.
       IF NOT AVAIL tt-prog-ponto THEN DO:
         {method/svc/errors/inserr.i &ErrorNumber="17006"
                                     &ErrorType="Outros" &ErrorSubType="ERROR"
                                     &ErrorDescription="Criaá∆o de amostragem ultrapassa data limite."
                                     &ErrorHelp="N∆o Ç permitido criaá∆o de amostragem com data retroativa."}
       END.
    END.
    
    IF NOT CAN-FIND (FIRST estabelec 
                     WHERE estabelec.cod-estabel = RowObject.cod-estabel) THEN DO:
        
        {method/svc/errors/inserr.i &ErrorNumber="56"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="'Estabelecimento'"}

    END.

    IF RowObject.sigla <> "" THEN DO:
        IF NOT CAN-FIND (FIRST ns-sigla 
                         WHERE ns-sigla.sigla = RowObject.sigla) THEN DO:
            
            {method/svc/errors/inserr.i &ErrorNumber="56"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="'Sigla'"}
    
        END.
    END.

    IF NOT CAN-FIND (FIRST item
                     WHERE item.it-codigo = RowObject.it-codigo) THEN DO:
        
        {method/svc/errors/inserr.i &ErrorNumber="56"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="'Produto'"}

    END.

    IF NOT CAN-FIND (FIRST item-uni-estab
                     WHERE item-uni-estab.cod-estabel = RowObject.cod-estabel
                       and item-uni-estab.it-codigo   = RowObject.it-codigo) THEN DO:
        
        {method/svc/errors/inserr.i &ErrorNumber="56"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="'Relacionamento Item x Estabelecimento'"}

    END.

    IF NOT CAN-FIND (FIRST lin-prod
                     WHERE lin-prod.nr-linha = RowObject.nr-linha) THEN DO:
        {method/svc/errors/inserr.i &ErrorNumber="56"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="'Linha de produá∆o'"}
    END.

    IF RowObject.qt-apar-test <= 0 THEN DO:
        {method/svc/errors/inserr.i &ErrorNumber="17006"
                                    &ErrorType="Outros" &ErrorSubType="ERROR"
                                    &ErrorDescription="Quantidade incorreta."
                                    &ErrorHelp="Quantidade Aparelhos Testados deve ser informado."}
    END.


    IF NOT CAN-FIND(FIRST aq-tipo-lote
                    WHERE aq-tipo-lote.nr-seq-tipo-lote = RowObject.nr-seq-tipo-lote) THEN DO:

        {method/svc/errors/inserr.i &ErrorNumber="56"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="'Lote'"}

    END.

    IF RowObject.qt-prod-lote <= 0 THEN DO:
        {method/svc/errors/inserr.i &ErrorNumber="17006"
                                    &ErrorType="Outros" &ErrorSubType="ERROR"
                                    &ErrorDescription="Quantidade incorreta."
                                    &ErrorHelp="Quantidade Lote deve ser informado."}
    END.
    
    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

