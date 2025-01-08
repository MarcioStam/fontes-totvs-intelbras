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
&GLOBAL-DEFINE DBOName BOES607
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName mac-address-param
&GLOBAL-DEFINE TableLabel Parametrizaá∆o de Mac Address
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
{esbo/boes607.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}

DEFINE VARIABLE h-acomp AS HANDLE NO-UNDO.

/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE VARIABLE v-sequencia-ini      LIKE {&TableName}.sequencia      NO-UNDO.
DEFINE VARIABLE v-sequencia-fin      LIKE {&TableName}.sequencia      NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DBOProgram
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD conv-dec-to-hex DBOProgram 
FUNCTION conv-dec-to-hex RETURNS CHARACTER
  ( INPUT p-num-decimal AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD conv-hex-to-dec DBOProgram 
FUNCTION conv-hex-to-dec RETURNS INTEGER
  ( INPUT p-val-hexadecimal AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fator DBOProgram 
FUNCTION fator RETURNS INTEGER
  ( INPUT p-fator AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
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
         HEIGHT             = 17.71
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeCreateRecord DBOProgram 
PROCEDURE beforeCreateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN RowObject.dt-criacao = TODAY.

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
        WHEN "faixa":U THEN ASSIGN pFieldValue = RowObject.faixa.
        WHEN "faixa-fim":U THEN ASSIGN pFieldValue = RowObject.faixa-fim.
        WHEN "faixa-ini":U THEN ASSIGN pFieldValue = RowObject.faixa-ini.
        WHEN "usuario":U THEN ASSIGN pFieldValue = RowObject.usuario.
        WHEN "alerta":U THEN ASSIGN pFieldValue = RowObject.alerta.
        WHEN "email":U THEN ASSIGN pFieldValue = RowObject.email.
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
        WHEN "dt-criacao":U THEN ASSIGN pFieldValue = RowObject.dt-criacao.
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
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "sequencia":U THEN ASSIGN pFieldValue = RowObject.sequencia.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice ch-pri
  Parameters:  
               retorna valor do campo sequencia
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pfaixa LIKE mac-address-param.faixa NO-UNDO.
    DEFINE OUTPUT PARAMETER pfaixa-ini LIKE mac-address-param.faixa-ini NO-UNDO.
    DEFINE OUTPUT PARAMETER pfaixa-fim LIKE mac-address-param.faixa-fim NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pfaixa = RowObject.faixa
           pfaixa-ini = RowObject.faixa-ini
           pfaixa-fim = RowObject.faixa-fim.
        
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
  Purpose:     Reposiciona registro com base no °ndice ch-pri
  Parameters:  
               recebe valor do campo sequencia
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pfaixa LIKE mac-address-param.faixa NO-UNDO.
    DEFINE INPUT PARAMETER pfaixa-ini LIKE mac-address-param.faixa-ini NO-UNDO.
    DEFINE INPUT PARAMETER pfaixa-fim LIKE mac-address-param.faixa-fim NO-UNDO.

    FIND FIRST bfmac-address-param WHERE 
        bfmac-address-param.faixa = pfaixa AND 
        bfmac-address-param.faixa-ini = pfaixa-ini AND
        bfmac-address-param.faixa-fim = pfaixa-fim NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfmac-address-param THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfmac-address-param)).
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
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piRetornaNomeUser DBOProgram 
PROCEDURE piRetornaNomeUser :
/*------------------------------------------------------------------------------
  Purpose:     
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER ca-usuar AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER ca-nome  AS CHARACTER NO-UNDO.

FOR FIRST usuar_mestre
    WHERE usuar_mestre.cod_usuario = ca-usuar NO-LOCK:

    ASSIGN ca-nome = usuar_mestre.nom_usuario.
END.

RETURN "OK".

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
    DEFINE INPUT  PARAMETER pType AS CHARACTER   NO-UNDO.

    DEFINE VARIABLE v-faixa-ini AS CHARACTER NO-UNDO.
    /*:T--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*:T--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as validaá‰es ---*/

    IF pType = "Create":U THEN DO:
        
        FIND LAST bf{&TableName} USE-INDEX seq NO-LOCK NO-ERROR.

        ASSIGN RowObject.sequencia = IF AVAILABLE bf{&TableName} THEN bf{&TableName}.sequencia + 10 ELSE 10.

        FIND FIRST bf{&TableName}
            WHERE bf{&TableName}.faixa = RowObject.faixa
            AND   bf{&TableName}.faixa-ini = RowObject.faixa-ini
            AND   bf{&TableName}.faixa-fim = RowObject.faixa-fim NO-LOCK NO-ERROR.

        IF AVAILABLE bf{&TableName} THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="1"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="'Parametrizaá∆o de Mac Address'"}
        END.
    END.

    IF pType = "Create":U OR
       pType = "Update":U THEN DO:

        IF conv-hex-to-dec(RowObject.alerta) > conv-hex-to-dec(RowObject.faixa-fim) THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="17006"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="'Alerta n∆o pode ser maior que a faixa final'"}
        END.

        IF conv-hex-to-dec(RowObject.alerta) < conv-hex-to-dec(RowObject.faixa-ini) THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="17006"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="'Alerta n∆o pode ser menor que a faixa inicial'"}
        END.

        IF conv-hex-to-dec(RowObject.faixa-fim) < conv-hex-to-dec(RowObject.mac-ult) THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="17006"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="'Faixa final n∆o pode ser menor que £ltimo Mac gerado.'"}
        END.

        FOR EACH bf{&TableName} NO-LOCK
            WHERE bf{&TableName}.faixa = RowObject.faixa:

            IF ROWID(bf{&TableName}) = RowObject.r-Rowid THEN
                NEXT.

            IF conv-hex-to-dec(RowObject.faixa-fim) < conv-hex-to-dec(bf{&TableName}.faixa-ini) OR
               conv-hex-to-dec(RowObject.faixa-ini) > conv-hex-to-dec(bf{&TableName}.faixa-fim) THEN DO:
            END.
            ELSE DO:
                {method/svc/errors/inserr.i &ErrorNumber="17006"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="'Range escolhido conflitante com faixa j† cadastrada. Verificar faixa inicial e final.'"}
            END.
        END.

        IF conv-hex-to-dec(RowObject.faixa-ini) > conv-hex-to-dec(RowObject.faixa-fim) THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="17006"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="'Valor inicial maior que o valor final da faixa'"}
        END.

        IF RowObject.usuario = "":U THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="5793"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="'Usu†rio'"}
        END.

        FIND FIRST usuar_mestre
            WHERE usuar_mestre.cod_usuario = RowObject.usuario NO-LOCK NO-ERROR.

        IF NOT AVAILABLE usuar_mestre THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="2"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="'Usu†rio Mestre'"}
        END.

        IF RowObject.dt-criacao <> TODAY THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="17006"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="'Data de Criaá∆o deve ser igual Ö data de hoje'"}
        END.
    
    END.

    IF RowObject.mac-ult <> "" THEN
        ASSIGN v-faixa-ini = RowObject.mac-ult.
    ELSE
        ASSIGN v-faixa-ini = RowObject.faixa-ini.

    IF  NOT VALID-HANDLE(h-acomp) THEN DO:
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

        RUN pi-inicializar IN h-acomp (INPUT "Validando Faixa Mac").
    END.

    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN DO:
        IF  VALID-HANDLE(h-acomp) THEN
            RUN pi-finalizar IN h-acomp.
        RETURN "NOK":U.
    END.

    validaMac: REPEAT:
        RUN pi-acompanhar IN h-acomp (INPUT "Mac: " + STRING(RowObject.faixa, "X(6)":U) + STRING(v-faixa-ini, "x(6)":U)).
        FOR FIRST mac-address
            WHERE mac-address.mac = STRING(RowObject.faixa, "X(6)":U) + STRING(v-faixa-ini, "x(6)":U) NO-LOCK:

            IF (pType = "Create":U) THEN DO:
                {method/svc/errors/inserr.i &ErrorNumber="17006"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="'J† existe Mac Address cadastrado para a faixa informada'"}
                LEAVE validaMac.
            END.

            IF pType = "Update":U THEN DO:
                IF conv-hex-to-dec(TRIM(SUBSTRING(mac-address.mac, LENGTH(RowObject.faixa) + 1))) > conv-hex-to-dec(RowObject.faixa-fim) THEN DO:
                    {method/svc/errors/inserr.i &ErrorNumber="17006"
                                                &ErrorType="EMS"
                                                &ErrorSubType="ERROR"
                                                &ErrorParameters="'Informar um valor final da faixa maior ou igual ao £ltimo Mac Address gerado'"}
                    LEAVE validaMac.
                END.

                IF conv-hex-to-dec(TRIM(SUBSTRING(mac-address.mac, LENGTH(RowObject.faixa) + 1))) < conv-hex-to-dec(RowObject.faixa-ini) THEN DO:
                    {method/svc/errors/inserr.i &ErrorNumber="17006"
                                                &ErrorType="EMS"
                                                &ErrorSubType="ERROR"
                                                &ErrorParameters="'Informar um valor inicial da faixa menor ou igual ao primeiro Mac Address gerado'"}
                    LEAVE validaMac.
                END.
            END.

            IF pType = "Delete":U THEN DO:
                {method/svc/errors/inserr.i &ErrorNumber="17006"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="'Existe Mac Address gerado para esta faixa. Faixa n∆o pode ser eliminada.'"}
                LEAVE validaMac.
            END.
        END.

        IF v-faixa-ini = RowObject.faixa-fim THEN
            LEAVE.

        ASSIGN v-faixa-ini = conv-dec-to-hex(conv-hex-to-dec(v-faixa-ini) + 1).
    END.

    IF  VALID-HANDLE(h-acomp) THEN
        RUN pi-finalizar IN h-acomp.

    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION conv-dec-to-hex DBOProgram 
FUNCTION conv-dec-to-hex RETURNS CHARACTER
  ( INPUT p-num-decimal AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-simbolos        AS CHARACTER   NO-UNDO
        FORMAT "x(1)":U
        EXTENT 16
        INITIAL ["0":U, "1":U, "2":U, "3":U, "4":U, "5":U, "6":U, "7":U, "8":U, "9":U, "A":U, "B":U, "C":U, "D":U, "E":U, "F":U].

    DEFINE VARIABLE c-val-hexadecimal AS CHARACTER   NO-UNDO INITIAL "":U.

    DEFINE VARIABLE i-quociente       AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-resto           AS INTEGER     NO-UNDO INITIAL 0.
    DEFINE VARIABLE c-aux             AS CHARACTER   NO-UNDO.

    ASSIGN i-quociente = p-num-decimal.

    REPEAT:
        ASSIGN i-resto           = i-quociente MODULO 16
               i-quociente       = TRUNCATE((i-quociente / 16), 0)
               c-val-hexadecimal = c-simbolos[(i-resto + 1)] + c-val-hexadecimal.

        IF i-quociente <= 0 THEN
            LEAVE.
    END.

    IF LENGTH(c-val-hexadecimal) < 6 THEN
        ASSIGN c-aux             = FILL("0",6 - LENGTH(c-val-hexadecimal))
               c-val-hexadecimal = c-aux + c-val-hexadecimal.

    RETURN c-val-hexadecimal. /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION conv-hex-to-dec DBOProgram 
FUNCTION conv-hex-to-dec RETURNS INTEGER
  ( INPUT p-val-hexadecimal AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE i-cont        AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-valor       AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-num-decimal AS INTEGER     NO-UNDO.

    DO i-cont = 1 TO LENGTH(p-val-hexadecimal):
        CASE SUBSTRING(p-val-hexadecimal, i-cont, 1):
            WHEN "A":U THEN
                ASSIGN i-valor = 10.
            WHEN "B":U THEN
                ASSIGN i-valor = 11.
            WHEN "C":U THEN
                ASSIGN i-valor = 12.
            WHEN "D":U THEN
                ASSIGN i-valor = 13.
            WHEN "E":U THEN
                ASSIGN i-valor = 14.
            WHEN "F":U THEN
                ASSIGN i-valor = 15.
            OTHERWISE DO:
                ASSIGN i-valor = INTEGER(SUBSTRING(p-val-hexadecimal, i-cont, 1)) NO-ERROR.

                IF ERROR-STATUS:ERROR THEN
                    RETURN 0. /* Function return value. */
            END.
        END CASE.

        ASSIGN i-num-decimal = i-num-decimal + (i-valor * fator(LENGTH(p-val-hexadecimal) - i-cont)).
    END.

    RETURN i-num-decimal. /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fator DBOProgram 
FUNCTION fator RETURNS INTEGER
  ( INPUT p-fator AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE i-cont  AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-valor AS INTEGER     NO-UNDO.

    ASSIGN i-valor = 1.

    IF p-fator > 0 THEN DO:
        DO i-cont = 1 TO p-fator:
            ASSIGN i-valor = i-valor * 16.
        END.
    END.

    RETURN i-valor. /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

