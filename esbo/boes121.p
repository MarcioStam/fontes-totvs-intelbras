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
&GLOBAL-DEFINE DBOName BOES121
&GLOBAL-DEFINE DBOVersion 1.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName local
&GLOBAL-DEFINE TableLabel local 
&GLOBAL-DEFINE QueryName qrlocal 

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
{esbo/boes121.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bflocal FOR {&TableName}.

DEF VAR v-ini-cod-tipo AS INT NO-UNDO.
DEF VAR v-fim-cod-tipo AS INT NO-UNDO.
DEF VAR v-ini-cod-estabel AS CHAR NO-UNDO.
DEF VAR v-fim-cod-estabel AS CHAR NO-UNDO.
DEF VAR v-ini-cod-depos AS CHAR NO-UNDO.
DEF VAR v-fim-cod-depos AS CHAR NO-UNDO.
DEF VAR v-ini-localizacao AS CHAR NO-UNDO.
DEF VAR v-fim-localizacao AS CHAR NO-UNDO.

def temp-table ttItensEntrepostoNivelCritico no-undo
   field it-codigo like item.it-codigo
 /*  field cod-estabel like local.cod-estabel */
   field cod-depos like local.cod-depos
   field localizacao like local.localizacao
   field saldo like saldo-estoq.qtidade-atu
   FIELD qtd-max  LIKE item-tipo-loc.qt-max-entreposto
   index codigo it-codigo cod-depos localizacao.

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
         HEIGHT             = 9.58
         WIDTH              = 26.
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
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-depos":U THEN ASSIGN pFieldValue = RowObject.cod-depos.
        WHEN "formato":U THEN ASSIGN pFieldValue = RowObject.formato.
        WHEN "localizacao":U THEN ASSIGN pFieldValue = RowObject.localizacao.
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
        WHEN "cod-tipo":U THEN ASSIGN pFieldValue = RowObject.cod-tipo.
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
               retorna valor do campo cod-tipo
               retorna valor do campo cod-estabel               
               retorna valor do campo cod-depos
               retorna valor do campo localizacao
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-tipo    LIKE local.cod-tipo    NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE local.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-depos   LIKE local.cod-depos   NO-UNDO.
    DEFINE OUTPUT PARAMETER plocalizacao LIKE local.localizacao NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-tipo    = RowObject.cod-tipo
           pcod-estabel = RowObject.cod-estabel
           pcod-depos   = RowObject.cod-depos
           plocalizacao = RowObject.localizacao.

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
        WHEN "loc-unica":U THEN ASSIGN pFieldValue = RowObject.loc-unica.
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
               recebe valor do campo cod-tipo
               recebe valor do campo cod-estabel
               recebe valor do campo cod-depos
               recebe valor do campo localizacao
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-tipo LIKE local.cod-tipo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel LIKE local.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pcod-depos LIKE local.cod-depos NO-UNDO.
    DEFINE INPUT PARAMETER plocalizacao LIKE local.localizacao NO-UNDO.

    FIND FIRST bflocal WHERE 
        bflocal.cod-tipo    = pcod-tipo AND 
        bflocal.cod-estabel = pcod-estabel AND        
        bflocal.cod-depos   = pcod-depos AND 
        bflocal.localizacao = plocalizacao NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bflocal THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bflocal)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE obtemItensEntrepostoNivelCritico DBOProgram 
PROCEDURE obtemItensEntrepostoNivelCritico :
/*------------------------------------------------------------------------------
  Purpose:     Là todos os itens na localizaá∆o com tipo Entreposto, que estejam
               com quantidade abaixo do n°vel m°nimo 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param p-cod-estabel as char no-undo.
    DEF INPUT PARAM i-ini-it-codigo AS CHAR NO-UNDO.
    DEF INPUT PARAM i-fim-it-codigo AS CHAR NO-UNDO.
    DEF INPUT PARAM i-ini-cod-depos AS CHAR NO-UNDO.
    DEF INPUT PARAM i-fim-cod-depos AS CHAR NO-UNDO.
    DEF INPUT PARAM i-ini-cod-localiz AS CHAR NO-UNDO.
    DEF INPUT PARAM i-fim-cod-localiz AS CHAR NO-UNDO.
    def output param table for ttItensEntrepostoNivelCritico.
    def var de-saldo like saldo-estoq.qtidade-atu no-undo.
    /*
    for each item-tipo-loc no-lock,
        first tipo-local fields () of item-tipo-loc no-lock
        where tipo-local.cod-estabel = p-cod-estabel
            and tipo-local.entreposto,
        each local 
       where local.cod-tipo = tipo-local.cod-tipo
         and local.cod-estabel = tipo-local.cod-estabel
         AND local.localiz >= i-ini-cod-localiz
         AND local.localiz <= i-fim-cod-localiz no-lock
       break by item-tipo-loc.it-codigo
             by item-tipo-loc.cod-estabel
             by local.cod-depos
             by local.localizacao:
             
        if last-of(local.localizacao) then do:
            de-saldo = 0.
            for each saldo-estoq fields (qtidade-atu) no-lock
                where saldo-estoq.cod-estabel = p-cod-estabel
                and   saldo-estoq.it-codigo   = item-tipo-loc.it-codigo
                and   saldo-estoq.cod-depos   = local.cod-depos
                and   saldo-estoq.cod-localiz = local.localizacao
                and   saldo-estoq.qtidade-atu > 0:
                
                de-saldo = de-saldo + saldo-estoq.qtidade-atu.
                
            end.  
             
            if de-saldo < item-tipo-loc.qt-seg-entreposto then do:
                create ttItensEntrepostoNivelCritico.    
                assign ttItensEntrepostoNivelCritico.it-codigo   = item-tipo-loc.it-codigo
                       ttItensEntrepostoNivelCritico.cod-depos   = local.cod-depos
                       ttItensEntrepostoNivelCritico.localizacao = local.localizacao
                       ttItensEntrepostoNivelCritico.saldo       = de-saldo
                       ttItensEntrepostoNivelCritico.qtd-max     = item-tipo-loc.qt-max-entreposto.
            
            end.
            
        end.
        
    end.
 */
 
   FOR EACH ttItensEntrepostoNivelCritico:
       DELETE ttItensEntrepostoNivelCritico.
   END.

   FOR each local NO-LOCK where local.cod-estabel = p-cod-estabel AND
                                local.cod-depos >= i-ini-cod-depos AND
                                local.cod-depos <= i-fim-cod-depos AND
                                local.localiz >= i-ini-cod-localiz AND
                                local.localiz <= i-fim-cod-localiz AND
                                local.entreposto = YES,
       EACH item-tipo-loc NO-LOCK WHERE item-tipo-loc.cod-estabel = local.cod-estabel AND
                                        item-tipo-loc.cod-depos = local.cod-depos AND
                                        item-tipo-loc.local-entreposto = local.localizacao AND
                                        item-tipo-loc.it-codigo >= i-ini-it-codigo AND
                                        item-tipo-loc.it-codigo <= i-fim-it-codigo:
       
       ASSIGN de-saldo = 0.
       FOR each saldo-estoq no-lock
          WHERE saldo-estoq.cod-localiz = local.localiz AND
                saldo-estoq.it-codigo   = item-tipo-loc.it-codigo AND
                saldo-estoq.cod-depos   = local.cod-depos AND
                saldo-estoq.cod-estabel = p-cod-estabel:
            
           IF saldo-estoq.qtidade-atu <= 0 THEN NEXT.

           ASSIGN de-saldo = de-saldo + saldo-estoq.qtidade-atu.
       END.
            
       if de-saldo < item-tipo-loc.qt-seg-entreposto then do:
           create ttItensEntrepostoNivelCritico.    
           assign ttItensEntrepostoNivelCritico.it-codigo   = item-tipo-loc.it-codigo
                  ttItensEntrepostoNivelCritico.cod-depos   = local.cod-depos
                  ttItensEntrepostoNivelCritico.localizacao = local.localizacao
                  ttItensEntrepostoNivelCritico.saldo       = de-saldo
                  ttItensEntrepostoNivelCritico.qtd-max     = item-tipo-loc.qt-max-entreposto.
            
       end.


   END. 
   
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
OPEN QUERY  {&QueryName} FOR EACH {&TableName} NO-LOCK     WHERE
            {&TableName}.cod-tipo    >= v-ini-cod-tipo     AND
            {&TableName}.cod-tipo    <= v-fim-cod-tipo     AND
            {&TableName}.cod-estabel >= v-ini-cod-estabel  AND
            {&TableName}.cod-estabel <= v-fim-cod-estabel  AND            
            {&TableName}.cod-depos   >= v-ini-cod-depos    AND
            {&TableName}.cod-depos   <= v-fim-cod-depos    AND
            {&TableName}.localizacao >= v-ini-localizacao  AND
            {&TableName}.localizacao <= v-fim-localizacao.
RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryEstab DBOProgram 
PROCEDURE openQueryEstab :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
                           where {&TableName}.cod-estabel = v-ini-cod-estabel.
                           
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByCod DBOProgram 
PROCEDURE setConstraintByCod :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAM p-ini-cod-tipo    LIKE local.cod-tipo    NO-UNDO.
    DEF INPUT PARAM p-fim-cod-tipo    LIKE local.cod-tipo    NO-UNDO.
    DEF INPUT PARAM p-ini-cod-estabel LIKE local.cod-estabel NO-UNDO.
    DEF INPUT PARAM p-fim-cod-estabel LIKE local.cod-estabel NO-UNDO.
    DEF INPUT PARAM p-ini-cod-depos   LIKE local.cod-depos   NO-UNDO.
    DEF INPUT PARAM p-fim-cod-depos   LIKE local.cod-depos   NO-UNDO.    
    DEF INPUT PARAM p-ini-localizacao LIKE local.localizacao NO-UNDO.
    DEF INPUT PARAM p-fim-localizacao LIKE local.localizacao NO-UNDO.

    ASSIGN v-ini-cod-tipo    = p-ini-cod-tipo
           v-fim-cod-tipo    = p-fim-cod-tipo
           v-ini-cod-estabel = p-ini-cod-estabel
           v-fim-cod-estabel = p-fim-cod-estabel
           v-ini-cod-depos   = p-ini-cod-depos
           v-fim-cod-depos   = p-fim-cod-depos
           v-ini-localizacao = p-ini-localizacao
           v-fim-localizacao = p-fim-localizacao.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraitEstab DBOProgram 
PROCEDURE setConstraitEstab :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define input parameter p-cod-estabel as char no-undo.
    
    assign v-ini-cod-estabel = p-cod-estabel.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraitMain DBOProgram 
PROCEDURE setConstraitMain :
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
    DEFINE VAR i-sequencia AS INTEGER NO-UNDO.
    
    /*:T--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*:T--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as validaá‰es ---*/
    
    IF pType = "Create" THEN DO:
        IF CAN-FIND(bflocal
            WHERE bflocal.cod-estabel = RowObject.cod-estabel AND
                  bflocal.cod-depos   = RowObject.cod-depos   AND
                  bflocal.localizacao = RowObject.localizacao)  THEN DO:
            {method/svc/errors/inserr.i
            &ErrorNumber="2"
            &ErrorType="outros"
            &ErrorSubType="ERROR"
            &ErrorDescription="Este registro j† foi cadastrado no sistema."}
        END.
        IF RowObject.localizacao = "" AND
           RowObject.cod-tipo    <> 0 THEN DO:
             {method/svc/errors/inserr.i
             &ErrorNumber="2"
             &ErrorType="outros"
             &ErrorSubType="ERROR"
             &ErrorDescription="A localizaá∆o n∆o pode ser branco para este tipo"}
        END.
        IF RowObject.cod-tipo    = 0  OR 
           RowObject.localizacao = "" OR
           RowObject.cod-depos   = "" OR 
           RowObject.cod-estabel = "" THEN DO:
            {method/svc/errors/inserr.i
            &ErrorNumber="2"
            &ErrorType="outros"
            &ErrorSubType="ERROR"
            &ErrorDescription="ê obrigat¢rio preencher os campos C¢digo tipo, Localizaá∆o, Dep¢sito e Estabelecimento."}
        END.
        IF NOT CAN-FIND (Deposito
            WHERE Deposito.cod-depos = RowObject.cod-depos) THEN DO:
            {method/svc/errors/inserr.i
            &ErrorNumber="2"
            &ErrorType="outros"
            &ErrorSubType="ERROR"
            &ErrorDescription="C¢digo de dep¢sito n∆o cadastrado no sistema."}            
        END.
        RUN setRecord IN THIS-PROCEDURE (INPUT TABLE RowObject).
    END.
    
    
    IF pType = "Delete" THEN DO:
        IF rowObject.cod-tipo = 0  OR
           rowObject.cod-tipo = 52 THEN DO:
            {method/svc/errors/inserr.i
                &ErrorNumber="2"
                &ErrorType="outros"
                &ErrorSubType="ERROR"
                &ErrorDescription="Este tipo de Localizaá∆o n∆o pode ser exclu°do"}
        END.
    END.
      

    /*RUN createRecord IN THIS-PROCEDURE.    */    


    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

