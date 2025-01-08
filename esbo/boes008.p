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
&GLOBAL-DEFINE DBOName BOES615
&GLOBAL-DEFINE DBOVersion 2.0
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName etiq-coletiva
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
{esbo/boes008.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DBOProgram
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnRetornaUsuar DBOProgram 
FUNCTION fnRetornaUsuar RETURNS CHARACTER
  ( INPUT p-cod-usuario AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
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
         HEIGHT             = 14.38
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
        WHEN "char-1":U       THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U       THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "cod-estabel":U  THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "it-codigo":U    THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "cod-etiqueta":U THEN ASSIGN pFieldValue = RowObject.cod-etiqueta.
        WHEN "usuar-desat":U  THEN ASSIGN pFieldValue = RowObject.usuar-desat.
        WHEN "usuar-ult-re":U THEN ASSIGN pFieldValue = RowObject.usuar-ult-re.
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
        WHEN "ano":U        THEN ASSIGN pFieldValue = RowObject.ano.
        WHEN "int-1":U      THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U      THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "tipo":U       THEN ASSIGN pFieldValue = RowObject.tipo.
        WHEN "re-impr":U    THEN ASSIGN pFieldValue = RowObject.re-impr.
        WHEN "semana":U     THEN ASSIGN pFieldValue = RowObject.semana.
        WHEN "sequencia":U  THEN ASSIGN pFieldValue = RowObject.sequencia.
        WHEN "quantidade":U THEN ASSIGN pFieldValue = RowObject.quantidade.
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
               retorna valor do campo n-serie
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER p-cod-etiqueta LIKE etiq-coletiva.cod-etiqueta NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN p-cod-etiqueta = RowObject.cod-etiqueta.

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
        WHEN "log-1":U     THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U     THEN ASSIGN pFieldValue = RowObject.log-2.
        WHEN "status-etiq" THEN ASSIGN pFieldValue = RowObject.status-etiq.
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
               recebe valor do campo n-serie
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-cod-etiqueta LIKE etiq-coletiva.cod-etiqueta NO-UNDO.

    FIND FIRST bfetiq-coletiva WHERE 
        bfetiq-coletiva.cod-etiqueta = p-cod-etiqueta NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfetiq-coletiva THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfetiq-coletiva)).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piBuscaDados DBOProgram 
PROCEDURE piBuscaDados :
/*------------------------------------------------------------------------------
  Purpose: Retorna campos de descriá∆o e relacionamentos da etiqueta    
  Notes:   Carlos Daniel - 24/03/2016
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER TABLE FOR RowObject.
DEFINE OUTPUT PARAMETER c-desc-item     AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER c-tipo          AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER c-nom-usuar     AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER c-nom-usuar-re  AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER c-nom-usuar-des AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR tt-etiqueta.

DEFINE BUFFER bf-ns-volume FOR ns-volume.

DEFINE VARIABLE l-possui-cx AS LOGICAL     NO-UNDO.


EMPTY TEMP-TABLE tt-etiqueta.

FOR FIRST RowObject:
    FOR FIRST item FIELDS(desc-item)
        WHERE item.it-codigo = RowObject.it-codigo NO-LOCK:
        ASSIGN c-desc-item = item.desc-item.
    END.

    CASE RowObject.tipo:
        WHEN 1 THEN ASSIGN c-tipo = "CAIXA".
        WHEN 2 THEN ASSIGN c-tipo = "PALLET".
        OTHERWISE ASSIGN c-tipo = "".
    END CASE.

    ASSIGN c-nom-usuar     = fnRetornaUsuar(RowObject.usuario)
           c-nom-usuar-re  = fnRetornaUsuar(RowObject.usuar-ult-re)
           c-nom-usuar-des = fnRetornaUsuar(RowObject.usuar-desat)
           l-possui-cx     = NO.


    CASE c-tipo:
        WHEN "PALLET" THEN DO:
            /*busca ns vinculadas a etiqueta*/
            FOR EACH ns-volume
                WHERE ns-volume.volume-pai = RowObject.cod-etiqueta NO-LOCK:

                FOR EACH bf-ns-volume
                    WHERE bf-ns-volume.volume-pai = ns-volume.volume-filho NO-LOCK:
    
                    CREATE tt-etiqueta.
                    ASSIGN tt-etiqueta.cod-pallet  = ns-volume.volume-pai
                           tt-etiqueta.cod-caixa   = ns-volume.volume-filho
                           tt-etiqueta.cod-produto = bf-ns-volume.volume-filho
                           tt-etiqueta.usuario     = bf-ns-volume.usuario
                           tt-etiqueta.data        = bf-ns-volume.data
                           l-possui-cx             = YES.
                END.
                                                            
                IF NOT l-possui-cx THEN DO:
                    CREATE tt-etiqueta.
                    ASSIGN tt-etiqueta.cod-pallet  = ns-volume.volume-pai
                           tt-etiqueta.cod-produto = ns-volume.volume-filho
                           tt-etiqueta.usuario     = ns-volume.usuario
                           tt-etiqueta.data        = ns-volume.data.
                END.
            END.
        END.
        WHEN "CAIXA" THEN DO:
            FOR EACH ns-volume
                WHERE ns-volume.volume-pai = RowObject.cod-etiqueta NO-LOCK:
                
                CREATE tt-etiqueta.
                ASSIGN tt-etiqueta.cod-caixa   = ns-volume.volume-pai
                       tt-etiqueta.cod-produto = ns-volume.volume-filho
                       tt-etiqueta.usuario     = ns-volume.usuario
                       tt-etiqueta.data        = ns-volume.data.
    
                FOR FIRST bf-ns-volume
                    WHERE bf-ns-volume.volume-filho = ns-volume.volume-pai NO-LOCK:
    
                    ASSIGN tt-etiqueta.cod-pallet = bf-ns-volume.volume-pai.
                END.
            END.
        END.
        WHEN "NS" THEN DO:
            FOR FIRST ns-volume
                WHERE ns-volume.volume-filho = RowObject.cod-etiqueta NO-LOCK:
    
                CREATE tt-etiqueta.
                ASSIGN tt-etiqueta.cod-caixa   = ns-volume.volume-pai
                       tt-etiqueta.cod-produto = ns-volume.volume-filho
                       tt-etiqueta.usuario     = ns-volume.usuario
                       tt-etiqueta.data        = ns-volume.data.
    
                FOR FIRST bf-ns-volume
                    WHERE bf-ns-volume.volume-filho = ns-volume.volume-pai NO-LOCK:
    
                    ASSIGN tt-etiqueta.cod-pallet = bf-ns-volume.volume-pai.
                END.
            END.
        END.
    END CASE.
END.
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
    
    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnRetornaUsuar DBOProgram 
FUNCTION fnRetornaUsuar RETURNS CHARACTER
  ( INPUT p-cod-usuario AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: Retorna nome do usu†rio informado
    Notes: Carlos Daniel - 24/03/2016
------------------------------------------------------------------------------*/
IF p-cod-usuario <> "" THEN DO:
    FOR FIRST usuar_mestre FIELDS(nom_usuario)
        WHERE usuar_mestre.cod_usuario = p-cod-usuario NO-LOCK:

        RETURN usuar_mestre.nom_usuario.
    END.
END.

RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

