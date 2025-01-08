&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
*/

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttpagamento NO-UNDO LIKE pagamento
       field r-rowid as rowid.


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
&GLOBAL-DEFINE DBOName BOES138
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName pagamento
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qrpagamento 

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
      
{esbo/boes138.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}

def new global shared var v_cod_usuar_corren   like usuar_mestre.cod_usuario no-undo.

/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bfpagamento FOR {&TableName}.

DEF VAR v-ini-nr-pagamento  AS INT NO-UNDO.
DEF VAR v-fim-nr-pagamento  AS INT NO-UNDO.
DEF VAR v-ini-contrato      AS CHAR NO-UNDO.
DEF VAR v-fim-contrato      AS CHAR NO-UNDO.
DEFINE VARIABLE c-erro AS CHARACTER   NO-UNDO.

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
   Temp-Tables and Buffers:
      TABLE: ttpagamento T "?" NO-UNDO pagamento
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW DBOProgram ASSIGN
         HEIGHT             = 2.5
         WIDTH              = 26.86.
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
        WHEN "historico[1]":U THEN ASSIGN pFieldValue = RowObject.historico[1].
        WHEN "historico[2]":U THEN ASSIGN pFieldValue = RowObject.historico[2].
        WHEN "hora-aprovacao":U THEN ASSIGN pFieldValue = RowObject.hora-aprovacao.
        WHEN "modalidade":U THEN ASSIGN pFieldValue = RowObject.modalidade.
        WHEN "nr-cont-cambio":U THEN ASSIGN pFieldValue = RowObject.nr-cont-cambio.
        WHEN "nr-di":U THEN ASSIGN pFieldValue = RowObject.nr-di.
        WHEN "swift":U THEN ASSIGN pFieldValue = RowObject.swift.
        WHEN "usuario":U THEN ASSIGN pFieldValue = RowObject.usuario.
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
        WHEN "data-aprovacao":U THEN ASSIGN pFieldValue = RowObject.data-aprovacao.
        WHEN "data-ci":U THEN ASSIGN pFieldValue = RowObject.data-ci.
        WHEN "data-emissao":U THEN ASSIGN pFieldValue = RowObject.data-emissao.
        WHEN "data-swift":U THEN ASSIGN pFieldValue = RowObject.data-swift.
        WHEN "dt-fecha-cam":U THEN ASSIGN pFieldValue = RowObject.dt-fecha-cam.
        WHEN "dt-prev-fecha-cam":U THEN ASSIGN pFieldValue = RowObject.dt-prev-fecha-cam.
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
        WHEN "taxa-cambio":U THEN ASSIGN pFieldValue = RowObject.taxa-cambio.
        WHEN "taxa-cambio-pag":U THEN ASSIGN pFieldValue = RowObject.taxa-cambio-pag.
        WHEN "valor-contrato":U THEN ASSIGN pFieldValue = RowObject.valor-contrato.
        WHEN "valor-contrato-me":U THEN ASSIGN pFieldValue = RowObject.valor-contrato-me.
        WHEN "valor-fechamento":U THEN ASSIGN pFieldValue = RowObject.valor-fechamento.
        WHEN "valor-ord-pag":U THEN ASSIGN pFieldValue = RowObject.valor-ord-pag.
        WHEN "valor-pag":U THEN ASSIGN pFieldValue = RowObject.valor-pag.
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
        WHEN "centro":U THEN ASSIGN pFieldValue = RowObject.centro.
        WHEN "cod-banco":U THEN ASSIGN pFieldValue = RowObject.cod-banco.
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "cod-moeda":U THEN ASSIGN pFieldValue = RowObject.cod-moeda.
        WHEN "cod-moeda-1":U THEN ASSIGN pFieldValue = RowObject.cod-moeda-1.
        WHEN "instit-cambio":U THEN ASSIGN pFieldValue = RowObject.instit-cambio.
        WHEN "nr-pagamento":U THEN ASSIGN pFieldValue = RowObject.nr-pagamento.
        WHEN "praca-cambio":U THEN ASSIGN pFieldValue = RowObject.praca-cambio.
        WHEN "tipo-contr-cambio":U THEN ASSIGN pFieldValue = RowObject.tipo-contr-cambio.
        WHEN "Tipo-despesa":U THEN ASSIGN pFieldValue = RowObject.Tipo-despesa.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice pagto
  Parameters:  
               retorna valor do campo nr-pagamento
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pnr-pagamento LIKE pagamento.nr-pagamento NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pnr-pagamento = RowObject.nr-pagamento.

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
        WHEN "aprovado":U THEN ASSIGN pFieldValue = RowObject.aprovado.
        WHEN "enviado-banco":U THEN ASSIGN pFieldValue = RowObject.enviado-banco.
        WHEN "integrado":U THEN ASSIGN pFieldValue = RowObject.integrado.
        WHEN "recebido-ap":U THEN ASSIGN pFieldValue = RowObject.recebido-ap.
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
  Purpose:     Reposiciona registro com base no °ndice pagto
  Parameters:  
               recebe valor do campo nr-pagamento
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnr-pagamento LIKE pagamento.nr-pagamento NO-UNDO.

    FIND FIRST bfpagamento WHERE 
        bfpagamento.nr-pagamento = pnr-pagamento NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfpagamento THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfpagamento)).
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
OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK.
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
    OPEN QUERY  {&QueryName} FOR EACH {&TableName} NO-LOCK          WHERE
                {&TableName}.nr-pagamento    >= v-ini-nr-pagamento  AND
                {&TableName}.nr-pagamento    <= v-fim-nr-pagamento  AND
                {&TableName}.nr-cont-cambio  >= v-ini-contrato      AND
                {&TableName}.nr-cont-cambio  <= v-fim-contrato.
    
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE openQueryPortal :
/*------------------------------------------------------------------------------
  Purpose: abrir a query do esimp003 somente para os registros que n∆o foram alterados no portal     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
OPEN QUERY {&QueryName} FOR EACH {&TableName} WHERE NOT {&TableName}.log-origem-portal NO-LOCK.
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

    DEF INPUT PARAM p-ini-nr-pagamento      LIKE pagamento.nr-pagamento     NO-UNDO.
    DEF INPUT PARAM p-fim-nr-pagamento      LIKE pagamento.nr-pagamento     NO-UNDO.
    DEF INPUT PARAM p-ini-contrato          LIKE pagamento.nr-cont-cambio   NO-UNDO.
    DEF INPUT PARAM p-fim-contrato          LIKE pagamento.nr-cont-cambio   NO-UNDO.    

    ASSIGN v-ini-nr-pagamento  = p-ini-nr-pagamento
           v-fim-nr-pagamento  = p-fim-nr-pagamento
           v-ini-contrato      = p-ini-contrato
           v-fim-contrato      = p-fim-contrato.

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

    CASE pType:
         WHEN "Create" THEN DO:
             IF CAN-FIND(FIRST bf{&TableName} NO-LOCK
                 WHERE bf{&TableName}.nr-pagamento = RowObject.nr-pagamento) THEN DO:
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
                 WHERE bf{&TableName}.nr-pagamento = RowObject.nr-pagamento) THEN DO:
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
                 WHERE bf{&TableName}.nr-pagamento = RowObject.nr-pagamento) THEN DO:
                 {method/svc/errors/inserr.i
                     &ErrorNumber="2"
                     &ErrorType="EMS"
                     &ErrorSubType="ERROR"
                     &ErrorParameters="'{&TableLabel}'"
                 }
             END.

             IF RowObject.recebido-ap THEN DO:
                 {method/svc/errors/inserr.i
                     &ErrorNumber="17006"
                     &ErrorType="EMS"
                     &ErrorSubType="ERROR"
                     &ErrorParameters="'SIP recebida, n∆o Ç poss°vel eliminar.'"
                 }
             END.

             IF CAN-FIND (FIRST pagamento-invoice
                          WHERE pagamento-invoice.nr-pagamento = RowObject.nr-pagamento) THEN DO:
                  {method/svc/errors/inserr.i
                     &ErrorNumber="17006"
                     &ErrorType="EMS"
                     &ErrorSubType="ERROR"
                     &ErrorParameters="'SIP possui invoices vinculadas, n∆o Ç poss°vel eliminar.'"
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

        /*IF RowObject.cod-unid-neg = "" THEN DO:
            {method/svc/errors/inserr.i
                &ErrorNumber="17006"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorParameters="'Unidade Neg¢cio inv†lida.~~~~Favor informar Unidade de Neg¢cio.'"}
        END.*/

        IF RowObject.data-ci >= 04/12/2010 AND 
           NOT CAN-FIND(FIRST cond-pagto NO-LOCK
                        WHERE cond-pagto.cod-cond-pag = RowObject.cod-cond-pag) THEN DO:
            {method/svc/errors/inserr.i
                &ErrorNumber="17006"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorParameters="'Condiá∆o Pagamento inv†lida.~~~~Condiá∆o Pagamento n∆o cadastrada.'"}
        END.

        ASSIGN c-erro = "".

        IF NOT CAN-FIND (FIRST emitente
                         WHERE emitente.cod-emitente = RowObject.cod-emitente) THEN DO:
    
            ASSIGN c-erro = "Emitente inv†lido.~~Emitente " + string(RowObject.cod-emitente) + " n∆o cadastrado.".
    
                {method/svc/errors/inserr.i
                    &ErrorNumber="17006"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters=c-erro}
    
        END.
    
        ASSIGN c-erro = "".
    
        IF NOT CAN-FIND (FIRST tipo-rec-desp
                         WHERE tipo-rec-desp.tp-codigo = RowObject.tipo-despesa) THEN DO:   
    
            ASSIGN c-erro = "Tipo de despesa inv†lido.~~Tipo de despesa " + string(RowObject.tipo-despesa) + " n∆o cadastrado.".
    
            {method/svc/errors/inserr.i
                    &ErrorNumber="17006"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters=c-erro}
        END.
    
        ASSIGN c-erro = "".
    
        IF NOT CAN-FIND (FIRST estabelec
                         WHERE estabelec.cod-estabel = RowObject.cod-estabel) THEN DO:   
    
            ASSIGN c-erro = "Estabelecimento inv†lido.~~Estabelecimento " + string(RowObject.cod-estabel) + " n∆o cadastrado.".
    
            {method/svc/errors/inserr.i
                    &ErrorNumber="17006"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters=c-erro}
        END.
    
        ASSIGN c-erro = "".
    
        IF NOT CAN-FIND (FIRST moeda
                         WHERE moeda.mo-codigo = RowObject.cod-moeda) THEN DO:   
    
            ASSIGN c-erro = "Moeda inv†lida.~~Moeda " + string(RowObject.cod-moeda) + " n∆o cadastrada.".
    
            {method/svc/errors/inserr.i
                    &ErrorNumber="17006"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters=c-erro}
        END.
    
        ASSIGN c-erro = "".
    
        IF RowObject.usuario <> "" THEN DO:
        
            IF NOT CAN-FIND (FIRST usuar_mestre
                             WHERE usuar_mestre.cod_usuario = RowObject.usuario) THEN DO:   
        
                ASSIGN c-erro = "Usu†rio inv†lido.~~Usu†rio " + string(RowObject.usuario) + " n∆o cadastrado.".
        
                {method/svc/errors/inserr.i
                        &ErrorNumber="17006"
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR"
                        &ErrorParameters=c-erro}
            END.
        END.
    
        ASSIGN c-erro = "".
    
        IF RowObject.cod-comprador <> "" THEN DO:

            IF NOT CAN-FIND (FIRST usuar_mestre
                             WHERE usuar_mestre.cod_usuario = RowObject.cod-comprador) THEN DO:   
        
                ASSIGN c-erro = "Usu†rio inv†lido.~~Usu†rio " + string(RowObject.cod-comprador) + " n∆o cadastrado.".
        
                {method/svc/errors/inserr.i
                        &ErrorNumber="17006"
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR"
                        &ErrorParameters=c-erro}
            END.
        END.
    END.   
            
    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeCreateRecord DBOProgram 
PROCEDURE beforeCreateRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Validaá‰es pertinentes ao DBO
  Parameters:  recebe o tipo de validaá∆o (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    
    FIND LAST bfpagamento NO-LOCK NO-ERROR.
    IF AVAIL bfpagamento THEN
        ASSIGN RowObject.nr-pagamento = bfpagamento.nr-pagamento + 1. 
    ELSE
        ASSIGN RowObject.nr-pagamento = 1.

    IF RowObject.usuario = '' THEN
        ASSIGN RowObject.usuario = v_cod_usuar_corren.
        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/*&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterUpdateRecord DBOProgram 
PROCEDURE afterUpdateRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Validaá‰es pertinentes ao DBO
  Parameters:  recebe o tipo de validaá∆o (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE VARIABLE de-valor-pag AS DECIMAL     NO-UNDO.

    ASSIGN de-valor-pag = 0.
    FOR EACH pagamento-invoice NO-LOCK
       WHERE pagamento-invoice.nr-pagamento = RowObject.nr-pagamento:
        ASSIGN de-valor-pag = de-valor-pag + pagamento-invoice.valor.
    END.

    FIND FIRST bfpagamento EXCLUSIVE-LOCK WHERE bfpagamento.nr-pagamento = RowObject.nr-pagamento NO-ERROR.
    IF AVAIL bfpagamento THEN
        ASSIGN bfpagamento.valor-pag = de-valor-pag.
        
END PROCEDURE.
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
