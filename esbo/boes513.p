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
/*{include/i-prgvrs.i BOES513 2.00.00.001}                               */
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
&GLOBAL-DEFINE DBOName BOES513
&GLOBAL-DEFINE DBOVersion 2.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName fam-com-item
&GLOBAL-DEFINE TableLabel Familia Comercial Item        
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
{esbo/boes513.i RowObject}
 
 
/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}
 
 
/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.
DEFINE BUFFER bf2{&TableName} FOR {&TableName}.

/* ************************* Definiá∆o de vari†veis *********************** */
DEFINE VARIABLE v-unidade    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v-segmento   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v-familia1   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v-familia2   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v-origem     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v-fm-cod-com AS CHARACTER   NO-UNDO.
 
DEFINE VARIABLE i-tipo-zoom  AS INTEGER     NO-UNDO.
DEFINE VARIABLE v-valor-zoom AS CHARACTER   NO-UNDO.

DEFINE VARIABLE v-fm-cod-com-ini AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v-fm-cod-com-fim AS CHARACTER   NO-UNDO.

DEFINE VARIABLE v-cod-segm-ini AS CHARACTER                NO-UNDO FORMAT "9999":U.
DEFINE VARIABLE v-cod-segm-fin AS CHARACTER                NO-UNDO FORMAT "9999":U.
DEFINE VARIABLE v-des-segm-ini LIKE fam-com-item.descricao NO-UNDO.
DEFINE VARIABLE v-des-segm-fin LIKE fam-com-item.descricao NO-UNDO.

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
         HEIGHT             = 18.96
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterCreateRecord DBOProgram 
PROCEDURE afterCreateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE i-sequencia      LIKE conteudo-programa.sequencia NO-UNDO.
    DEFINE VARIABLE i_cdn_unid_negoc LIKE unid_negoc.cdn_unid_negoc     NO-UNDO.

    IF LENGTH(RowObject.fm-cod-com)  = 8    AND
       RowObject.origem             <> "":U THEN DO:
        FIND FIRST fam-comerc
            WHERE fam-comerc.fm-cod-com = RowObject.fm-cod-com NO-LOCK NO-ERROR.

        IF NOT AVAILABLE fam-comerc THEN DO:
            CREATE fam-comerc.
            ASSIGN fam-comerc.fm-cod-com  = RowObject.fm-cod-com
                   fam-comerc.descricao   = RowObject.descricao
                   fam-comerc.baixa-estoq = 1
                   fam-comerc.un          = "PC":U.

            ASSIGN i-sequencia = INTEGER(SUBSTRING(RowObject.fm-cod-com, 1, 2)) NO-ERROR.

            IF NOT ERROR-STATUS:ERROR THEN DO:
                FOR FIRST ponto-programa NO-LOCK
                    WHERE ponto-programa.nome-programa = "boes513":U
                      AND ponto-programa.ponto         = 1,
                    FIRST conteudo-programa NO-LOCK
                    WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
                      AND conteudo-programa.sequencia    = i-sequencia:
                    ASSIGN i_cdn_unid_negoc = INTEGER(conteudo-programa.conteudo) NO-ERROR.

                    IF NOT ERROR-STATUS:ERROR THEN DO:
                        FIND FIRST unid_negoc
                            WHERE unid_negoc.cdn_unid_negoc = i_cdn_unid_negoc NO-LOCK NO-ERROR.

                        IF AVAILABLE unid_negoc THEN DO:
                            FIND FIRST unid-neg-fam-com
                                WHERE unid-neg-fam-com.fm-codigo      = RowObject.fm-cod-com
                                  AND unid-neg-fam-com.cod_unid_negoc = unid_negoc.cod_unid_negoc NO-LOCK NO-ERROR.

                            IF NOT AVAIL unid-neg-fam-com THEN DO:
                                CREATE unid-neg-fam-com.
                                ASSIGN unid-neg-fam-com.fm-codigo      = RowObject.fm-cod-com
                                       unid-neg-fam-com.cod_unid_negoc = unid_negoc.cod_unid_negoc
                                       unid-neg-fam-com.perc-unid-neg  = 100.
                            END. /* IF NOT AVAIL unid-neg-fam-com THEN DO: */
                        END. /* IF AVAILABLE unid_negoc THEN DO: */
                    END. /* IF NOT ERROR-STATUS:ERROR THEN DO: */
                END. /* FOR FIRST ponto-programa NO-LOCK
                            WHERE ponto-programa.nome-programa = "boes513":U
                              AND ponto-programa.ponto         = 1,
                            FIRST conteudo-programa NO-LOCK
                            WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
                              AND conteudo-programa.sequencia    = i-sequencia: */

                FIND FIRST wm-familia
                    WHERE wm-familia.cod-familia = RowObject.fm-cod-com NO-LOCK NO-ERROR.
                
                IF NOT AVAIL wm-familia THEN DO:
                    CREATE wm-familia.
                    ASSIGN wm-familia.cod-familia  = RowObject.fm-cod-com
                           wm-familia.des-familia  = RowObject.descricao
                           wm-familia.cod-unid-med = "PC".
                END.
            END. /* IF NOT ERROR-STATUS:ERROR THEN DO: */

        END. /* IF NOT AVAILABLE fam-comerc THEN DO: */
    END. /* IF LENGTH(RowObject.fm-cod-com)  = 8    AND
               RowObject.origem             <> "":U THEN DO: */

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterUpdateRecord DBOProgram 
PROCEDURE afterUpdateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE i-sequencia      LIKE conteudo-programa.sequencia NO-UNDO.
    DEFINE VARIABLE i_cdn_unid_negoc LIKE unid_negoc.cdn_unid_negoc     NO-UNDO.

    IF LENGTH(RowObject.fm-cod-com)  = 8 AND RowObject.origem <> "":U THEN DO:
        FIND FIRST fam-comerc
            WHERE fam-comerc.fm-cod-com = RowObject.fm-cod-com EXCLUSIVE-LOCK NO-ERROR.

        IF AVAILABLE fam-comerc AND fam-comerc.descricao <> RowObject.descricao THEN
            ASSIGN fam-comerc.descricao = RowObject.descricao.
        ELSE IF NOT AVAILABLE fam-comerc THEN DO:
            CREATE fam-comerc.
            ASSIGN fam-comerc.fm-cod-com  = RowObject.fm-cod-com
                   fam-comerc.descricao   = RowObject.descricao
                   fam-comerc.baixa-estoq = 1
                   fam-comerc.un          = "PC":U.

            ASSIGN i-sequencia = INTEGER(SUBSTRING(RowObject.fm-cod-com, 1, 2)) NO-ERROR.

            IF NOT ERROR-STATUS:ERROR THEN DO:
                FOR FIRST ponto-programa NO-LOCK
                    WHERE ponto-programa.nome-programa = "boes513":U
                      AND ponto-programa.ponto         = 1,
                    FIRST conteudo-programa NO-LOCK
                    WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
                      AND conteudo-programa.sequencia    = i-sequencia:
                    ASSIGN i_cdn_unid_negoc = INTEGER(conteudo-programa.conteudo) NO-ERROR.

                    IF NOT ERROR-STATUS:ERROR THEN DO:
                        FIND FIRST unid_negoc
                            WHERE unid_negoc.cdn_unid_negoc = i_cdn_unid_negoc NO-LOCK NO-ERROR.

                        IF AVAILABLE unid_negoc THEN DO:
                            FIND FIRST unid-neg-fam-com
                                WHERE unid-neg-fam-com.fm-codigo      = RowObject.fm-cod-com
                                  AND unid-neg-fam-com.cod_unid_negoc = unid_negoc.cod_unid_negoc NO-LOCK NO-ERROR.

                            IF NOT AVAIL unid-neg-fam-com THEN DO:
                                CREATE unid-neg-fam-com.
                                ASSIGN unid-neg-fam-com.fm-codigo      = RowObject.fm-cod-com
                                       unid-neg-fam-com.cod_unid_negoc = unid_negoc.cod_unid_negoc
                                       unid-neg-fam-com.perc-unid-neg  = 100.
                            END. /* IF NOT AVAIL unid-neg-fam-com THEN DO: */
                        END. /* IF AVAILABLE unid_negoc THEN DO: */
                    END. /* IF NOT ERROR-STATUS:ERROR THEN DO: */
                END. /* FOR FIRST ponto-programa NO-LOCK
                            WHERE ponto-programa.nome-programa = "boes513":U
                              AND ponto-programa.ponto         = 1,
                            FIRST conteudo-programa NO-LOCK
                            WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
                              AND conteudo-programa.sequencia    = i-sequencia: */

                FIND FIRST wm-familia
                    WHERE wm-familia.cod-familia = RowObject.fm-cod-com NO-LOCK NO-ERROR.
                IF NOT AVAILABLE wm-familia THEN DO:
                    CREATE wm-familia.
                    ASSIGN wm-familia.cod-familia  = RowObject.fm-cod-com
                           wm-familia.des-familia  = RowObject.descricao
                           wm-familia.cod-unid-med = "PC".
                END.

            END. /* IF NOT ERROR-STATUS:ERROR THEN DO: */
        END. /* ELSE IF NOT AVAILABLE fam-comerc THEN DO: */
    END. /* IF LENGTH(RowObject.fm-cod-com)  = 8    AND
               RowObject.origem             <> "":U THEN DO: */

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getCharField DBOProgram 
PROCEDURE getCharField :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER   NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS CHARACTER   NO-UNDO.

    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "descricao":U THEN ASSIGN pFieldValue = RowObject.descricao.
        WHEN "familia1":U THEN ASSIGN pFieldValue = RowObject.familia1.
        WHEN "familia2":U THEN ASSIGN pFieldValue = RowObject.familia2.
        WHEN "fm-cod-com":U THEN ASSIGN pFieldValue = RowObject.fm-cod-com.
        WHEN "origem":U THEN ASSIGN pFieldValue = RowObject.origem.
        WHEN "segmento":U THEN ASSIGN pFieldValue = RowObject.segmento.
        WHEN "unidade":U THEN ASSIGN pFieldValue = RowObject.unidade.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-fm-cod-com AS CHARACTER   NO-UNDO.

    FIND bf{&TableName}
        WHERE bf{&TableName}.fm-cod-com = p-fm-cod-com NO-LOCK NO-ERROR.

    IF NOT AVAILABLE bf{&TableName} THEN
        RETURN "NOK":U.

    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bf{&TableName})).

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
    DEFINE INPUT  PARAMETER iAbertura AS INTEGER     NO-UNDO.

    CASE iAbertura:
        WHEN 1 THEN
            RUN openQueryStatic (INPUT "Main":U).
        WHEN 2 THEN
            RUN openQueryStatic (INPUT "Ch-chave-2":U).
        WHEN 3 THEN
            RUN openQueryStatic (INPUT "Ch-primario":U).
    END CASE.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryCh-chave-2 DBOProgram 
PROCEDURE openQueryCh-chave-2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
                                WHERE {&TableName}.unidade  = v-unidade
                                  AND {&TableName}.segmento = v-segmento
                                  AND {&TableName}.familia1 = v-familia1
                                  AND {&TableName}.familia2 = v-familia2
                                  AND {&TableName}.origem   = v-origem INDEXED-REPOSITION.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryCh-primario DBOProgram 
PROCEDURE openQueryCh-primario :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
                                WHERE {&TableName}.fm-cod-com = v-fm-cod-com INDEXED-REPOSITION.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryCodSegmento DBOProgram 
PROCEDURE openQueryCodSegmento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH {&TableName} USE-INDEX ch-chave-2 NO-LOCK
                                WHERE {&TableName}.unidade    <> "":U
                                  AND {&TableName}.segmento   <> "":U
                                  AND {&TableName}.familia1    = "":U
                                  AND {&TableName}.familia2    = "":U
                                  AND {&TableName}.origem      = "":U
                                  AND {&TableName}.fm-cod-com >= v-cod-segm-ini
                                  AND {&TableName}.fm-cod-com <= v-cod-segm-fin INDEXED-REPOSITION.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryDesSegmento DBOProgram 
PROCEDURE openQueryDesSegmento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH {&TableName} USE-INDEX ch-chave-2 NO-LOCK
                                WHERE {&TableName}.unidade   <> "":U
                                  AND {&TableName}.segmento  <> "":U
                                  AND {&TableName}.familia1   = "":U
                                  AND {&TableName}.familia2   = "":U
                                  AND {&TableName}.origem     = "":U
                                  AND {&TableName}.descricao >= v-des-segm-ini
                                  AND {&TableName}.descricao <= v-des-segm-fin INDEXED-REPOSITION.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryFaixaFamilia DBOProgram 
PROCEDURE openQueryFaixaFamilia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
                                WHERE {&TableName}.fm-cod-com >= v-fm-cod-com-ini
                                  AND {&TableName}.fm-cod-com <= v-fm-cod-com-fim INDEXED-REPOSITION.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryZoom DBOProgram 
PROCEDURE openQueryZoom :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    CASE i-tipo-zoom:
        WHEN 0 THEN
            OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
                                        WHERE {&TableName}.fm-cod-com BEGINS v-valor-zoom INDEXED-REPOSITION.
        WHEN 1 THEN
            OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
                                        WHERE {&TableName}.unidade = v-valor-zoom INDEXED-REPOSITION.
        WHEN 2 THEN
            OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
                                        WHERE {&TableName}.segmento = v-valor-zoom INDEXED-REPOSITION.
        WHEN 3 THEN
            OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
                                        WHERE {&TableName}.familia1 = v-valor-zoom INDEXED-REPOSITION.
        WHEN 4 THEN
            OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
                                        WHERE {&TableName}.familia2 = v-valor-zoom INDEXED-REPOSITION.
        WHEN 5 THEN
            OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
                                        WHERE {&TableName}.origem = v-valor-zoom INDEXED-REPOSITION.
        WHEN 6 THEN
            OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
                                        WHERE {&TableName}.descricao MATCHES "*":U + v-valor-zoom  + "*":U INDEXED-REPOSITION.
    END CASE.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryZoom3 DBOProgram 
PROCEDURE openQueryZoom3 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF v-origem <> "":U THEN
        OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
                                    WHERE {&TableName}.unidade  = v-unidade
                                      AND {&TableName}.segmento = v-segmento
                                      AND {&TableName}.familia1 = v-familia1
                                      AND {&TableName}.familia2 = v-familia2
                                      AND {&TableName}.origem   = v-origem.
    ELSE IF v-familia2 <> "":U THEN
        OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
                                    WHERE {&TableName}.unidade   = v-unidade
                                      AND {&TableName}.segmento  = v-segmento
                                      AND {&TableName}.familia1  = v-familia1
                                      AND {&TableName}.familia2  = v-familia2
                                      AND {&TableName}.origem   <> "":U.
    ELSE IF v-familia1 <> "":U THEN
        OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
                                    WHERE {&TableName}.unidade   = v-unidade
                                      AND {&TableName}.segmento  = v-segmento
                                      AND {&TableName}.familia1  = v-familia1
                                      AND {&TableName}.familia2 <> "":U
                                      AND {&TableName}.origem    = "":U.
    ELSE IF v-segmento <> "":U THEN
        OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
                                    WHERE {&TableName}.unidade   = v-unidade
                                      AND {&TableName}.segmento  = v-segmento
                                      AND {&TableName}.familia1 <> "":U
                                      AND {&TableName}.familia2  = "":U.
    ELSE IF v-unidade <> "":U THEN
        OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
                                    WHERE {&TableName}.unidade   = v-unidade
                                      AND {&TableName}.segmento <> "":U
                                      AND {&TableName}.familia1  = "":U.
    ELSE
        OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
                                    WHERE {&TableName}.unidade  <> "":U
                                      AND {&TableName}.segmento  = "":U.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-monta-descricao DBOProgram 
PROCEDURE pi-monta-descricao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-nivel-inicial AS INTEGER     NO-UNDO.
    DEFINE INPUT  PARAMETER p-fm-cod-com    AS CHARACTER   NO-UNDO.
    DEFINE OUTPUT PARAMETER p-descricao     AS CHARACTER   NO-UNDO.

    DEFINE VARIABLE i-nivel AS INTEGER     NO-UNDO.

    ASSIGN p-descricao = "":U.

    FIND FIRST bf2{&TableName}
        WHERE bf2{&TableName}.fm-cod-com = p-fm-cod-com NO-LOCK NO-ERROR.

    IF NOT AVAIL bf2{&TableName} THEN
        NEXT.

    DO i-nivel = p-nivel-inicial TO 5:
        CASE i-nivel:
            WHEN 1 THEN DO:
                FIND FIRST bf{&TableName}
                    WHERE bf{&TableName}.fm-cod-com = bf2{&TableName}.unidade NO-LOCK NO-ERROR.

                IF AVAILABLE bf{&TableName} THEN
                    ASSIGN p-descricao = bf{&TableName}.descricao.
            END.
            WHEN 2 THEN DO:
                FIND FIRST bf{&TableName}
                    WHERE bf{&TableName}.fm-cod-com = bf2{&TableName}.unidade + bf2{&TableName}.segmento NO-LOCK NO-ERROR.

                IF AVAILABLE bf{&TableName} THEN
                    ASSIGN p-descricao = p-descricao + " ":U + bf{&TableName}.descricao.
            END.
            WHEN 3 THEN DO:
                FIND FIRST bf{&TableName}
                    WHERE bf{&TableName}.fm-cod-com = bf2{&TableName}.unidade + bf2{&TableName}.segmento + bf2{&TableName}.familia1 NO-LOCK NO-ERROR.

                IF AVAILABLE bf{&TableName} THEN
                    ASSIGN p-descricao = p-descricao + " ":U + bf{&TableName}.descricao.
            END.
            WHEN 4 THEN DO:
                FIND FIRST bf{&TableName}
                    WHERE bf{&TableName}.fm-cod-com = bf2{&TableName}.unidade + bf2{&TableName}.segmento + bf2{&TableName}.familia1 + bf2{&TableName}.familia2 NO-LOCK NO-ERROR.

                IF AVAILABLE bf{&TableName} THEN
                    ASSIGN p-descricao = p-descricao + " ":U + bf{&TableName}.descricao.
            END.
            WHEN 5 THEN DO:
                FIND FIRST bf{&TableName}
                    WHERE bf{&TableName}.fm-cod-com = bf2{&TableName}.unidade + bf2{&TableName}.segmento + bf2{&TableName}.familia1 + bf2{&TableName}.familia2 + bf2{&TableName}.origem NO-LOCK NO-ERROR.

                IF AVAILABLE bf{&TableName} THEN
                    ASSIGN p-descricao = p-descricao + " ":U + bf{&TableName}.descricao.
            END.
        END CASE.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintCh-chave-2 DBOProgram 
PROCEDURE setConstraintCh-chave-2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-unidade  AS CHARACTER   NO-UNDO.
    DEFINE INPUT  PARAMETER p-segmento AS CHARACTER   NO-UNDO.
    DEFINE INPUT  PARAMETER p-familia1 AS CHARACTER   NO-UNDO.
    DEFINE INPUT  PARAMETER p-familia2 AS CHARACTER   NO-UNDO.
    DEFINE INPUT  PARAMETER p-origem   AS CHARACTER   NO-UNDO.

    ASSIGN v-unidade  = p-unidade
           v-segmento = p-segmento
           v-familia1 = p-familia1
           v-familia2 = p-familia2
           v-origem   = p-origem.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintCh-primario DBOProgram 
PROCEDURE setConstraintCh-primario :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-fm-cod-com AS CHARACTER   NO-UNDO.

    ASSIGN v-fm-cod-com = p-fm-cod-com.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintCodSegmento DBOProgram 
PROCEDURE setConstraintCodSegmento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-cod-segm-ini AS CHARACTER   NO-UNDO FORMAT "9999":U.
    DEFINE INPUT  PARAMETER p-cod-segm-fin AS CHARACTER   NO-UNDO FORMAT "9999":U.

    ASSIGN v-cod-segm-ini = p-cod-segm-ini
           v-cod-segm-fin = p-cod-segm-fin.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintDesSegmento DBOProgram 
PROCEDURE setConstraintDesSegmento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-des-segm-ini LIKE fam-com-item.descricao NO-UNDO.
    DEFINE INPUT  PARAMETER p-des-segm-fin LIKE fam-com-item.descricao NO-UNDO.

    ASSIGN v-des-segm-ini = p-des-segm-ini
           v-des-segm-fin = p-des-segm-fin.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintFaixaFamilia DBOProgram 
PROCEDURE setConstraintFaixaFamilia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-fm-cod-com-ini AS CHARACTER   NO-UNDO.
    DEFINE INPUT  PARAMETER p-fm-cod-com-fim AS CHARACTER   NO-UNDO.

    ASSIGN v-fm-cod-com-ini = p-fm-cod-com-ini
           v-fm-cod-com-fim = p-fm-cod-com-fim.

    RETURN "OK":U.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintZoom DBOProgram 
PROCEDURE setConstraintZoom :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-tipo-zoom  AS INTEGER     NO-UNDO.
    DEFINE INPUT  PARAMETER p-valor-zoom AS CHARACTER   NO-UNDO.

    ASSIGN i-tipo-zoom  = p-tipo-zoom
           v-valor-zoom = p-valor-zoom.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintZoom3 DBOProgram 
PROCEDURE setConstraintZoom3 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-unidade  AS CHARACTER   NO-UNDO.
    DEFINE INPUT  PARAMETER p-segmento AS CHARACTER   NO-UNDO.
    DEFINE INPUT  PARAMETER p-familia1 AS CHARACTER   NO-UNDO.
    DEFINE INPUT  PARAMETER p-familia2 AS CHARACTER   NO-UNDO.
    DEFINE INPUT  PARAMETER p-origem   AS CHARACTER   NO-UNDO.

    ASSIGN v-unidade    = p-unidade
           v-segmento   = p-segmento
           v-familia1   = p-familia1
           v-familia2   = p-familia2
           v-origem     = p-origem
           v-fm-cod-com = p-unidade + p-segmento + p-familia1 + p-familia2 + p-origem.

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

    CASE pType:
         WHEN "Create":u THEN DO:
             IF CAN-FIND(FIRST bf{&TableName}
                         WHERE bf{&TableName}.fm-cod-com = RowObject.fm-cod-com NO-LOCK) THEN DO:
                 {method/svc/errors/inserr.i &ErrorNumber="1"
                                             &ErrorType="EMS"
                                             &ErrorSubType="ERROR"
                                             &ErrorParameters="'{&TableLabel}'"}
             END.
         END.
         WHEN "Update":U THEN DO:
             IF NOT CAN-FIND(FIRST bf{&TableName}
                             WHERE bf{&TableName}.fm-cod-com = RowObject.fm-cod-com NO-LOCK) THEN DO:
                 {method/svc/errors/inserr.i &ErrorNumber="2"
                                             &ErrorType="EMS"
                                             &ErrorSubType="ERROR"
                                             &ErrorParameters="'{&TableLabel}'"}
             END.
         END.
         WHEN "Delete":U THEN DO:
             IF NOT CAN-FIND(FIRST bf{&TableName}
                             WHERE bf{&TableName}.fm-cod-com = RowObject.fm-cod-com NO-LOCK) THEN DO:
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

    IF pType = "Create":U OR
       pType = "Update":U THEN DO:
        IF RowObject.unidade = ?    OR
           RowObject.unidade = "":U THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="17006"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="'Unidade inv†lida.~~~~ê obrigat¢rio informar uma unidade.'"}
        END.
        ELSE IF LENGTH(RowObject.unidade) <> 2 THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="17006"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="'Unidade inv†lida.~~~~Formato da unidade obriga informar 2 digitos.'"}
        END.

        IF RowObject.segmento <> "":U THEN DO:
            FIND FIRST bf{&TableName}
                WHERE bf{&TableName}.fm-cod-com = RowObject.unidade NO-LOCK NO-ERROR.

            IF NOT AVAILABLE bf{&TableName} THEN DO:
                {method/svc/errors/inserr.i &ErrorNumber="17006"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="'Nivel n∆o encontrado.~~~~N∆o foi localizado n°vel atÇ Unidade informada.'"}
            END.

            IF LENGTH(RowObject.segmento) <> 2 THEN DO:
                {method/svc/errors/inserr.i &ErrorNumber="17006"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="'Seguimento inv†lido.~~~~Formato do seguimento obriga informar 2 digitos.'"}
            END.
        END.

        IF RowObject.familia1 <> "":U THEN DO:
            IF RowObject.segmento = "":U THEN DO:
                {method/svc/errors/inserr.i &ErrorNumber="17006"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="'Segmento inv†lido.~~~~Segmento deve ser informado.'"}
            END.

            FIND FIRST bf{&TableName}
                WHERE bf{&TableName}.fm-cod-com = RowObject.unidade + RowObject.segmento NO-LOCK NO-ERROR.

            IF NOT AVAILABLE bf{&TableName} THEN DO:
                {method/svc/errors/inserr.i &ErrorNumber="17006"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="'Nivel n∆o encontrado.~~~~N∆o foi localizado n°vel atÇ Segmento informado.'"}
            END.
        END.

        IF RowObject.familia2 <> "":U THEN DO:
            IF RowObject.segmento = "":U THEN DO:
                {method/svc/errors/inserr.i &ErrorNumber="17006"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="'Segmento inv†lido.~~~~Segmento deve ser informado.'"}
            END.
            ELSE IF RowObject.familia1 = "":U THEN DO:
                {method/svc/errors/inserr.i &ErrorNumber="17006"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="'Familia inv†lida.~~~~Familia deve ser informada.'"}
            END.

            FIND FIRST bf{&TableName}
                WHERE bf{&TableName}.fm-cod-com = RowObject.unidade + RowObject.segmento + RowObject.familia1 NO-LOCK NO-ERROR.

            IF NOT AVAILABLE bf{&TableName} THEN DO:
                {method/svc/errors/inserr.i &ErrorNumber="17006"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="'Nivel n∆o encontrado.~~~~N∆o foi localizado n°vel atÇ Familia informada.'"}
            END.

            IF LENGTH(RowObject.familia2) <> 2 THEN DO:
                {method/svc/errors/inserr.i &ErrorNumber="17006"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="'Sub-fam°lia inv†lida.~~~~Formato da sub-fam°lia obriga informar 2 digitos.'"}
            END.
        END.

        IF RowObject.origem <> "":U THEN DO:
            IF RowObject.segmento = "":U THEN DO:
                {method/svc/errors/inserr.i &ErrorNumber="17006"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="'Segmento inv†lido.~~~~Segmento deve ser informado.'"}
            END.
            ELSE IF RowObject.familia1 = "":U THEN DO:
                {method/svc/errors/inserr.i &ErrorNumber="17006"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="'Familia inv†lida.~~~~Familia deve ser informada.'"}
            END.
            ELSE IF RowObject.familia2 = "":U THEN DO:
                {method/svc/errors/inserr.i &ErrorNumber="17006"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="'Sub-fam°lia inv†lida.~~~~Sub-fam°lia deve ser informada.'"}
            END.

            FIND FIRST bf{&TableName}
                WHERE bf{&TableName}.fm-cod-com = RowObject.unidade + RowObject.segmento + RowObject.familia1 + RowObject.familia2 NO-LOCK NO-ERROR.

            IF NOT AVAILABLE bf{&TableName} THEN DO:
                {method/svc/errors/inserr.i &ErrorNumber="17006"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="'Nivel n∆o encontrado.~~~~N∆o foi localizado n°vel atÇ Sub-fam°lia informada.'"}
            END.

            IF RowObject.origem <> "0":U AND
               RowObject.origem <> "1":U AND
               RowObject.origem <> "3":U AND
               RowObject.origem <> "5":U and
               RowObject.origem <> "6":U AND
               RowObject.origem <> "7":U 
                THEN DO:
                {method/svc/errors/inserr.i &ErrorNumber="17006"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="'Origem inv†lida!~~~~A origem deve ser 0, 1, 3, 5, 6 OU 7(0-OEM, 1-SC, 3-MG, 5-AM, 6-BNU, 7-PLH ).'"}
            END.
        END.

        IF RowObject.descricao = "":U THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="17006"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="'Descriá∆o inv†lida.~~~~ê obrigat¢rio informar uma descriá∆o.'"}
        END.
    END.
    ELSE IF pType = "delete":U THEN DO:
        FIND FIRST bf{&TableName}
            WHERE bf{&TableName}.fm-cod-com BEGINS RowObject.unidade + RowObject.segmento + RowObject.familia1 + RowObject.familia2 + RowObject.origem
              AND bf{&TableName}.fm-cod-com <> RowObject.unidade + RowObject.segmento + RowObject.familia1 + RowObject.familia2 + RowObject.origem NO-LOCK NO-ERROR.

        IF AVAILABLE bf{&TableName} THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="17006"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="'Eliminaá∆o n∆o permitida.~~~~Existem registros que dependem desse n°vel.'"}
        END.
    END.

    /*:T--- Verifica ocorrància de erros ---*/

    IF CAN-FIND(FIRST RowErrors
                WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

