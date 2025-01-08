&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOES432 2.00.00.000}                               
/*--------------------------------------------------------------------------
    File       : 
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
&GLOBAL-DEFINE DBOName  BOES432
&GLOBAL-DEFINE DBOVersion  2.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName  cota-representante
&GLOBAL-DEFINE TableLabel  Cadastro cota-representante   
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
{esbo/boes432.i RowObject}
 
 
/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}
 
 
/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.
/* ************************* Definiá∆o de vari†veis *********************** */
define variable v-cod-estabel as character no-undo.
define variable v-cod-rep     as integer no-undo.
define variable v-fm-cod-com  as character no-undo.
define variable v-it-codigo   as character no-undo.
define variable v-periodo     as character no-undo.


define variable v-cod-estabel-ini as character no-undo.
define variable v-cod-estabel-fim as character no-undo.
define variable v-cod-rep-ini     as integer no-undo.
define variable v-cod-rep-fim     as integer no-undo.
define variable v-fm-cod-com-ini  as character no-undo.
define variable v-fm-cod-com-fim  as character no-undo.
define variable v-it-codigo-ini   as character no-undo.
define variable v-it-codigo-fim   as character no-undo.
define variable v-periodo-ini     as character no-undo.
define variable v-periodo-fim     as character no-undo.

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
   Type: DBOProgram Template
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
/* DBO 2.0 Wizard */
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
DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS CHARACTER NO-UNDO.                                                                       

    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "fm-cod-com":U THEN ASSIGN pFieldValue = RowObject.fm-cod-com.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "periodo":U THEN ASSIGN pFieldValue = RowObject.periodo.
        OTHERWISE RETURN "NOK":U.
    END CASE.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDateField DBOProgram 
PROCEDURE getDateField :
DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DATE NO-UNDO.                                                                            

    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
        OTHERWISE RETURN "NOK":U.
    END CASE.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDecField DBOProgram 
PROCEDURE getDecField :
DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DECIMAL NO-UNDO.                                                                         

    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "qt-orcamento":U THEN ASSIGN pFieldValue = RowObject.qt-orcamento.
        WHEN "qt-representante":U THEN ASSIGN pFieldValue = RowObject.qt-representante.
        OTHERWISE RETURN "NOK":U.
    END CASE.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getIntField DBOProgram 
PROCEDURE getIntField :
DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS INTEGER NO-UNDO.                                                                         

    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cod-rep":U THEN ASSIGN pFieldValue = RowObject.cod-rep.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        OTHERWISE RETURN "NOK":U.
    END CASE.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLogField DBOProgram 
PROCEDURE getLogField :
DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS LOGICAL NO-UNDO.                                                                         

    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        OTHERWISE RETURN "NOK":U.
    END CASE.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice ch-cota
  Parameters:  
               recebe valor do campo cod-diretoria
               recebe valor do campo cod-gerente
               recebe valor do campo cod-rep
               recebe valor do campo periodo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-cod-estabel LIKE cota-representante.cod-estabel  NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-rep     LIKE cota-representante.cod-rep      NO-UNDO.
    DEFINE INPUT PARAMETER p-fm-cod-com  LIKE cota-representante.fm-cod-com   NO-UNDO.
    DEFINE INPUT PARAMETER p-it-codigo   LIKE cota-representante.it-codigo    NO-UNDO.
    DEFINE INPUT PARAMETER p-periodo     LIKE cota-representante.periodo    NO-UNDO.

    FIND FIRST bf{&TableName} NO-LOCK
         WHERE bf{&TableName}.cod-estabel = p-cod-estabel
           AND bf{&TableName}.cod-rep     = p-cod-rep
           AND bf{&TableName}.fm-cod-com  = p-fm-cod-com
           AND bf{&TableName}.it-codigo   = p-it-codigo
           AND bf{&TableName}.periodo     = p-periodo  NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bf{&TableName} THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bf{&TableName})).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQuery DBOProgram 
PROCEDURE openQuery :
DEFINE INPUT PARAMETER iAbertura AS INTEGER NO-UNDO.

    CASE iAbertura:
        WHEN 1 THEN
            RUN openQueryStatic ("Main":U).
        WHEN 2 THEN           
            RUN openQueryStatic ("Ch-principal":U).                   
    END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryCh-principal DBOProgram 
PROCEDURE openQueryCh-principal :
OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
        WHERE {&TableName}.cod-estabel = v-cod-estabel                
        AND {&TableName}.cod-rep = v-cod-rep                          
        AND {&TableName}.fm-cod-com = v-fm-cod-com                    
        AND {&TableName}.it-codigo = v-it-codigo                      
        AND {&TableName}.periodo = v-periodo                      
    .
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE openQueryMain :
OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryZoom1 DBOProgram 
PROCEDURE openQueryZoom1 :
OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
        WHERE {&TableName}.cod-estabel >= v-cod-estabel-ini
          AND {&TableName}.cod-estabel <= v-cod-estabel-fim
          AND {&TableName}.cod-rep     >= v-cod-rep-ini
          AND {&TableName}.cod-rep     <= v-cod-rep-fim
          AND {&TableName}.fm-cod-com  >= v-fm-cod-com-ini
          AND {&TableName}.fm-cod-com  <= v-fm-cod-com-fim
          AND (({&TableName}.it-codigo = ?) OR ({&TableName}.it-codigo   >= v-it-codigo-ini AND {&TableName}.it-codigo   <= v-it-codigo-fim))
          AND {&TableName}.periodo   >= v-periodo-ini
          AND {&TableName}.periodo   <= v-periodo-fim
    .
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintCh-principal DBOProgram 
PROCEDURE setConstraintCh-principal :
DEFINE INPUT PARAMETER p-cod-estabel AS character NO-UNDO.                                                                      
    DEFINE INPUT PARAMETER p-cod-rep AS integer NO-UNDO.                                                                            
    DEFINE INPUT PARAMETER p-fm-cod-com AS character NO-UNDO.                                                                       
    DEFINE INPUT PARAMETER p-it-codigo AS character NO-UNDO.                                                                        
    DEFINE INPUT PARAMETER p-periodo AS character NO-UNDO.                                                                             

    ASSIGN 
    v-cod-estabel = p-cod-estabel                                     
    v-cod-rep = p-cod-rep                                             
    v-fm-cod-com = p-fm-cod-com                                       
    v-it-codigo = p-it-codigo                                         
    v-periodo = p-periodo                                         
    .
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintMain DBOProgram 
PROCEDURE setConstraintMain :
RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintZoom1 DBOProgram 
PROCEDURE setConstraintZoom1 :
DEFINE INPUT PARAMETER p-cod-estabel-ini AS CHARACTER NO-UNDO. 
    DEFINE INPUT PARAMETER p-cod-estabel-fim AS CHARACTER NO-UNDO. 
    DEFINE INPUT PARAMETER p-cod-rep-ini     AS INTEGER   NO-UNDO.   
    DEFINE INPUT PARAMETER p-cod-rep-fim     AS INTEGER   NO-UNDO.   
    DEFINE INPUT PARAMETER p-fm-cod-com-ini  AS CHARACTER NO-UNDO. 
    DEFINE INPUT PARAMETER p-fm-cod-com-fim  AS CHARACTER NO-UNDO. 
    DEFINE INPUT PARAMETER p-it-codigo-ini   AS CHARACTER NO-UNDO. 
    DEFINE INPUT PARAMETER p-it-codigo-fim   AS CHARACTER NO-UNDO. 
    DEFINE INPUT PARAMETER p-periodo-ini     AS character NO-UNDO.      
    DEFINE INPUT PARAMETER p-periodo-fim     as character NO-UNDO.      

    ASSIGN v-cod-estabel-ini = p-cod-estabel-ini
           v-cod-estabel-fim = p-cod-estabel-fim
           v-cod-rep-ini     = p-cod-rep-ini
           v-cod-rep-fim     = p-cod-rep-fim
           v-fm-cod-com-ini  = p-fm-cod-com-ini
           v-fm-cod-com-fim  = p-fm-cod-com-fim
           v-it-codigo-ini   = p-it-codigo-ini
           v-it-codigo-fim   = p-it-codigo-fim
           v-periodo-ini     = replace(p-periodo-ini, "/", "")
           v-periodo-fim     = replace(p-periodo-fim, "/", "").

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

    DEFINE VARIABLE dt-data AS DATE        NO-UNDO.
    DEFINE VARIABLE c-erro AS CHARACTER   NO-UNDO.

    CASE pType:
        WHEN "Create" THEN DO:
            IF CAN-FIND(FIRST bf{&TableName} NO-LOCK
                        WHERE bf{&TableName}.cod-estabel = RowObject.cod-estabel
                          AND bf{&TableName}.cod-rep     = RowObject.cod-rep
                          AND bf{&TableName}.fm-cod-com  = RowObject.fm-cod-com
                          AND bf{&TableName}.it-codigo   = RowObject.it-codigo
                          AND bf{&TableName}.periodo     = RowObject.periodo
                          AND bf{&TableName}.cd-uf       = RowObject.cd-uf) THEN DO:
                {method/svc/errors/inserr.i &ErrorNumber="1"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="'{&TableLabel}'"}
             END.
         END.
         WHEN "Update" THEN DO:
             IF NOT CAN-FIND(FIRST bf{&TableName} NO-LOCK
                             WHERE bf{&TableName}.cod-estabel = RowObject.cod-estabel
                               AND bf{&TableName}.cod-rep     = RowObject.cod-rep
                               AND bf{&TableName}.fm-cod-com  = RowObject.fm-cod-com
                               AND bf{&TableName}.it-codigo   = RowObject.it-codigo
                               AND bf{&TableName}.periodo     = RowObject.periodo
                               AND bf{&TableName}.cd-uf       = RowObject.cd-uf)THEN DO:
                 {method/svc/errors/inserr.i &ErrorNumber="2"
                                             &ErrorType="EMS"
                                             &ErrorSubType="ERROR"
                                             &ErrorParameters="'{&TableLabel}'"}
             END.
         END.
         WHEN "Delete" THEN DO:
             IF NOT CAN-FIND(FIRST bf{&TableName} NO-LOCK
                             WHERE bf{&TableName}.cod-estabel = RowObject.cod-estabel
                               AND bf{&TableName}.cod-rep     = RowObject.cod-rep
                               AND bf{&TableName}.fm-cod-com  = RowObject.fm-cod-com
                               AND bf{&TableName}.it-codigo   = RowObject.it-codigo
                               AND bf{&TableName}.periodo     = RowObject.periodo)THEN DO:
                 {method/svc/errors/inserr.i &ErrorNumber="2"
                                             &ErrorType="EMS"
                                             &ErrorSubType="ERROR"
                                             &ErrorParameters="'{&TableLabel}'"}
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
        IF NOT CAN-FIND(FIRST estabelec NO-LOCK
                        WHERE estabelec.cod-estabel = RowObject.cod-estabel) THEN DO:
            ASSIGN c-erro = "Estabelecimento: " + RowObject.cod-estabel + " inv†lido.~~~~Estabelecimento n∆o cadastrado.".
            {method/svc/errors/inserr.i
                &ErrorNumber="17006"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorParameters=c-erro}
        END.

        IF NOT CAN-FIND(FIRST repres NO-LOCK
                        WHERE repres.cod-rep = RowObject.cod-rep) THEN DO:
            ASSIGN c-erro = "Representante: " + string(RowObject.cod-rep) + "  inv†lido.~~~~C¢digo do Representante n∆o cadastrado.".
            {method/svc/errors/inserr.i
                &ErrorNumber="17006"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorParameters=c-erro}
        END.

        IF NOT CAN-FIND(FIRST fam-comerc NO-LOCK
                        WHERE fam-comerc.fm-cod-com = RowObject.fm-cod-com) THEN DO:
            ASSIGN c-erro = "Fam°lia Comercial: " + RowObject.fm-cod-com + " inv†lida.~~~~C¢digo Fam°lia Comercial n∆o cadastrada.".
            {method/svc/errors/inserr.i
                &ErrorNumber="17006"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorParameters=c-erro}
        END.

        IF RowObject.it-codigo <> ? THEN DO:
            IF NOT CAN-FIND(FIRST ITEM NO-LOCK
                            WHERE ITEM.it-codigo = RowObject.it-codigo) THEN DO:
                ASSIGN c-erro = "Item: " + RowObject.it-codigo + " inv†lido.~~~~C¢digo do Item n∆o cadastrado.".
                {method/svc/errors/inserr.i
                    &ErrorNumber="17006"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters=c-erro}
            END.

            IF NOT CAN-FIND(FIRST ITEM NO-LOCK
                            WHERE ITEM.it-codigo  = RowObject.it-codigo 
                              AND ITEM.fm-cod-com = RowObject.fm-cod-com) THEN DO:
                ASSIGN c-erro = "Item: " + RowObject.it-codigo + " n∆o pertence a Fam°lia Comercial: " + RowObject.fm-cod-com + ".~~~~Item informado n∆o pertence a Fam°lia Comercial informada.".
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

