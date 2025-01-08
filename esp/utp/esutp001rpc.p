&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : 
    Purpose     :

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

{esp/utp/esutp001.i}

{esp/es0018.i} /*utilizado para parametrizar usuarios mestres no programa es0018*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-atualizaRegistros) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaRegistros Procedure 
PROCEDURE atualizaRegistros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM TABLE FOR tt-tarifador.
    DEF INPUT PARAM p-id AS CHAR NO-UNDO.

    FOR EACH tt-tarifador NO-LOCK WHERE tt-tarifador.avaliado:
        DO WHILE TRUE:
            FIND FIRST tarifador EXCLUSIVE-LOCK 
                WHERE ROWID(tarifador) = tt-tarifador.r-rowid NO-WAIT NO-ERROR.
            IF NOT AVAIL tarifador THEN LEAVE.
            IF NOT LOCKED(tarifador) THEN DO:
                BUFFER-COPY tt-tarifador EXCEPT r-rowid cod_usuario dt-avaliac TO tarifador.
                ASSIGN tarifador.cod_usuario = p-id.
                       tarifador.dt-avaliac  = TODAY.
                LEAVE.
            END.
            PAUSE 1.
        END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-avaliarParaOutros) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE avaliarParaOutros Procedure 
PROCEDURE avaliarParaOutros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAM p-rowid      AS ROWID NO-UNDO.          /*rowid*/                           
    DEF INPUT PARAM p-id-mestre  AS CHAR NO-UNDO.            /*matricula mestre*/                
    DEF INPUT PARAM p-id         AS CHAR NO-UNDO.            /*usuario que solicitou a ligacao*/ 
    DEF INPUT PARAM p-finalidade AS LOGICAL NO-UNDO.        /*finalidade - particular/servico*/ 
    DEF OUTPUT PARAM p-erro      AS CHARACTER NO-UNDO.

    DEFINE VARIABLE c-erro AS CHARACTER   NO-UNDO.

    ASSIGN c-erro = "".
    RUN validaMatricula IN THIS-PROCEDURE (INPUT p-id, OUTPUT c-erro).
    IF c-erro = "" THEN DO:

        FIND FIRST tarifador EXCLUSIVE-LOCK
             WHERE ROWID(tarifador) = p-rowid 
               AND NOT tarifador.avaliado
               AND NOT tarifador.cobrado NO-ERROR.
        IF AVAIL tarifador THEN
            ASSIGN tarifador.avaliado    = YES
                   tarifador.cod_usuario = p-id
                   tarifador.finalidade  = p-finalidade
                   tarifador.dt-avaliac  = TODAY
                   tarifador.matr_mestre = p-id-mestre.
        RELEASE tarifador.
    END.
    ELSE ASSIGN p-erro = c-erro.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-estornarCobrancaOutros) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE estornarCobrancaOutros Procedure 
PROCEDURE estornarCobrancaOutros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-id-mestre AS CHAR NO-UNDO.
    DEF INPUT PARAM p-rowid     AS ROWID NO-UNDO.

    FIND FIRST tarifador EXCLUSIVE-LOCK
         WHERE ROWID(tarifador)      = p-rowid 
           AND tarifador.matr_mestre = p-id-mestre  
           AND tarifador.avaliado
           AND NOT tarifador.cobrado NO-ERROR.
    IF AVAIL tarifador THEN
        ASSIGN tarifador.avaliado    = NO
               tarifador.cod_usuario = ""
               tarifador.finalidade  = NO
               tarifador.matr_mestre = ""
               tarifador.dt-avaliac  = ?.

    RELEASE tarifador.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-estornarCobrancaUsuario) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE estornarCobrancaUsuario Procedure 
PROCEDURE estornarCobrancaUsuario :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-id     AS CHAR NO-UNDO.
    DEF INPUT PARAM p-rowid  AS ROWID NO-UNDO.

    FIND FIRST tarifador EXCLUSIVE-LOCK
         WHERE ROWID(tarifador) = p-rowid 
           AND tarifador.cod_usuario = p-id  
           AND tarifador.matr_mestre = ""
           AND tarifador.avaliado
           AND NOT tarifador.cobrado NO-ERROR.
    IF AVAIL tarifador THEN
        ASSIGN tarifador.avaliado    = NO
               tarifador.cod_usuario = ""
               tarifador.finalidade  = NO
               tarifador.dt-avaliac  = ?.

    RELEASE tarifador.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-excluirAgendaUsuario) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE excluirAgendaUsuario Procedure 
PROCEDURE excluirAgendaUsuario :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAM p-rowid AS ROWID NO-UNDO.

    FIND FIRST agenda-tarifador EXCLUSIVE-LOCK
         WHERE ROWID(agenda-tarifador) = p-rowid NO-ERROR.
    IF AVAIL agenda-tarifador THEN
        DELETE agenda-tarifador.

    RELEASE agenda-tarifador.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-incluirAgendaUsuario) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE incluirAgendaUsuario Procedure 
PROCEDURE incluirAgendaUsuario :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAM p-id         AS CHAR  NO-UNDO.
    DEF INPUT PARAM p-ramal      AS CHAR NO-UNDO.
    DEF INPUT PARAM p-numero     AS CHAR NO-UNDO.
    DEF INPUT PARAM p-finalidade AS LOG  NO-UNDO.
    DEF INPUT PARAM p-descricao  AS CHAR NO-UNDO.
    DEF INPUT PARAM p-observ     AS CHAR NO-UNDO.
    DEF OUTPUT PARAM p-retorno   AS CHAR NO-UNDO.


    IF p-id = "" THEN DO:
        ASSIGN p-retorno = "C¢digo do usu rio inv lido! Favor fazer login novamente.".
    END.
    ELSE IF p-ramal = "" THEN DO:
        ASSIGN p-retorno = "Ramal inv lido! Favor informar o seu ramal.".
    END.
    ELSE IF p-numero = "" THEN DO:
        ASSIGN p-retorno = "N£mero inv lido! Favor informar o n£mero de telefone.".

    END.
    ELSE IF p-finalidade = ? THEN DO:
        ASSIGN p-retorno = "Finalidade inv lida! Favor informar a finalidade.".

    END.
    ELSE IF p-descricao = "" THEN DO:
        ASSIGN p-retorno = "Descri‡Æo inv lida! Favor informar a descri‡Æo".
    END.
    ELSE DO:
        FIND FIRST agenda-tarifador NO-LOCK
             WHERE agenda-tarifador.ramal  = p-ramal 
               AND agenda-tarifador.numero = p-numero NO-ERROR.
        IF AVAIL agenda-tarifador THEN DO:
            IF agenda-tarifador.cod_usuario = p-id THEN
                ASSIGN p-retorno = "J  existe cadastro desse ramal e n£mero para seu usu rio".
            ELSE DO:
                ASSIGN p-retorno = "J  existe cadastro desse ramal e n£mero para usu rio: " + string(agenda-tarifador.cod_usuario).
            END.

        END.

        CREATE agenda-tarifador.
        ASSIGN agenda-tarifador.ramal       = p-ramal 
               agenda-tarifador.numero      = p-numero
               agenda-tarifador.cod_usuario = p-id
               agenda-tarifador.finalidade  = p-finalidade
               agenda-tarifador.descricao   = p-descricao 
               agenda-tarifador.observacoes = p-observ.
    END.

    RELEASE agenda-tarifador.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-isMatriculaMestre) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE isMatriculaMestre Procedure 
PROCEDURE isMatriculaMestre :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAM p-id        AS CHAR NO-UNDO.            
    DEFINE OUTPUT PARAM p-mestre    AS LOGICAL NO-UNDO.

    ASSIGN p-mestre = NO.

    /* Seleciona usuarios de destino do e-mail  */
    RUN esp/es0018p.p (INPUT "esutp001", /* Nome do programa */
                       INPUT 1,        /* Ponto do programa */
                       INPUT 0,
                       INPUT "",
                       OUTPUT TABLE tt-prog-ponto) NO-ERROR.
    
    IF CAN-FIND(FIRST tt-prog-ponto NO-LOCK
                WHERE tt-prog-ponto.conteudo = p-id) THEN
        ASSIGN p-mestre = YES.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-modificarAgendaUsuario) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE modificarAgendaUsuario Procedure 
PROCEDURE modificarAgendaUsuario :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAM p-id         AS CHAR  NO-UNDO.
    DEF INPUT PARAM p-ramal      AS CHAR NO-UNDO.
    DEF INPUT PARAM p-numero     AS CHAR NO-UNDO.
    DEF INPUT PARAM p-finalidade AS LOG  NO-UNDO.
    DEF INPUT PARAM p-descricao  AS CHAR NO-UNDO.
    DEF INPUT PARAM p-observ     AS CHAR NO-UNDO.
    DEF OUTPUT PARAM p-retorno   AS CHAR NO-UNDO.


    IF p-id = "" THEN DO:
        ASSIGN p-retorno = "C¢digo do usu rio inv lido! Favor fazer login novamente.".
    END.
    ELSE IF p-ramal = "" THEN DO:
        ASSIGN p-retorno = "Ramal inv lido! Favor informar o seu ramal.".
    END.
    ELSE IF p-numero = "" THEN DO:
        ASSIGN p-retorno = "N£mero inv lido! Favor informar o n£mero de telefone.".

    END.
    ELSE IF p-finalidade = ? THEN DO:
        ASSIGN p-retorno = "Finalidade inv lida! Favor informar a finalidade.".

    END.
    ELSE IF p-descricao = "" THEN DO:
        ASSIGN p-retorno = "Descri‡Æo inv lida! Favor informar a descri‡Æo".
    END.
    ELSE DO:
        FIND FIRST agenda-tarifador EXCLUSIVE-LOCK
             WHERE agenda-tarifador.ramal  = p-ramal 
               AND agenda-tarifador.numero = p-numero 
               AND agenda-tarifador.cod_usuario = p-id NO-ERROR.
        IF NOT AVAIL agenda-tarifador THEN DO:
            ASSIGN p-retorno = "NÆo foi poss¡vel encontrar esse registro. Favor fazer login novamente!".
        END.
        ELSE DO:
            ASSIGN agenda-tarifador.finalidade  = p-finalidade
                   agenda-tarifador.descricao   = p-descricao 
                   agenda-tarifador.observacoes = p-observ.
        END.
    END.

    RELEASE agenda-tarifador.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-obtemAgendaUsuario) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE obtemAgendaUsuario Procedure 
PROCEDURE obtemAgendaUsuario :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAM p-id AS CHAR NO-UNDO.
    DEF OUTPUT PARAM TABLE FOR tt-agenda-tarifador.

    EMPTY TEMP-TABLE tt-agenda-tarifador.

    FOR EACH agenda-tarifador NO-LOCK
       WHERE agenda-tarifador.cod_usuario = p-id:

        CREATE tt-agenda-tarifador.
        BUFFER-COPY agenda-tarifador TO tt-agenda-tarifador.
        ASSIGN tt-agenda-tarifador.r-rowid = ROWID(agenda-tarifador).
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-obtemLigacoesAutomaticas) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE obtemLigacoesAutomaticas Procedure 
PROCEDURE obtemLigacoesAutomaticas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM p-id    AS CHAR NO-UNDO.
    DEF OUTPUT PARAM TABLE FOR tt-tarifador.
    DEF OUTPUT PARAM p-valor AS DECIMAL NO-UNDO.

    EMPTY TEMP-TABLE tt-tarifador.

    FOR EACH agenda-tarifador NO-LOCK
       WHERE agenda-tarifador.cod_usuario = p-id:

        FOR EACH tarifador NO-LOCK
           WHERE tarifador.ramal  = agenda-tarifador.ramal
             AND tarifador.numero = agenda-tarifador.numero
             AND NOT tarifador.cobrado
             AND NOT tarifador.avaliado:

            CREATE tt-tarifador.
            BUFFER-COPY tarifador TO tt-tarifador.
            ASSIGN tt-tarifador.r-rowid     = ROWID(tarifador)
                   tt-tarifador.finalidade  = agenda-tarifador.finalidade
                   tt-tarifador.cod_usuario = agenda-tarifador.cod_usuario
                   tt-tarifador.avaliado    = YES.

            IF tt-tarifador.finalidade THEN
                ASSIGN p-valor = p-valor + tt-tarifador.valor.
        END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-obtemLigacoesAvalOutros) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE obtemLigacoesAvalOutros Procedure 
PROCEDURE obtemLigacoesAvalOutros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-id AS CHAR NO-UNDO.
    DEF OUTPUT PARAM TABLE FOR tt-tarifador.

    EMPTY TEMP-TABLE tt-tarifador.

    for each tarifador NO-LOCK
        where tarifador.matr_mestre = p-id
        and not tarifador.cobrado
        and tarifador.avaliado:
        CREATE tt-tarifador.
        BUFFER-COPY tarifador TO tt-tarifador.
        ASSIGN tt-tarifador.r-rowid = ROWID(tarifador).
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-obtemLigacoesAvalUsuario) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE obtemLigacoesAvalUsuario Procedure 
PROCEDURE obtemLigacoesAvalUsuario :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-id AS CHAR NO-UNDO.
    DEF OUTPUT PARAM TABLE FOR tt-tarifador.

    EMPTY TEMP-TABLE tt-tarifador.

    for each tarifador NO-LOCK USE-INDEX usuario
        where tarifador.cod_usuario = p-id
        AND   tarifador.avaliado    = TRUE
        and   tarifador.cobrado     = FALSE:

        IF tarifador.matr_mestre <> "" THEN
            NEXT.

        CREATE tt-tarifador.
        BUFFER-COPY tarifador TO tt-tarifador.
        ASSIGN tt-tarifador.r-rowid = ROWID(tarifador).
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-obtemLigacoesParaListagem) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE obtemLigacoesParaListagem Procedure 
PROCEDURE obtemLigacoesParaListagem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAM p-id AS CHAR NO-UNDO.
    DEF OUTPUT PARAM TABLE FOR tt-tarifador.

    EMPTY TEMP-TABLE tt-tarifador.

    for each tarifador NO-LOCK
        where tarifador.cod_usuario = p-id
        /*and not tarifador.cobrado*/
        and tarifador.finalidade :
        CREATE tt-tarifador.
        BUFFER-COPY tarifador TO tt-tarifador.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-obtemLigacoesPorNumero) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE obtemLigacoesPorNumero Procedure 
PROCEDURE obtemLigacoesPorNumero :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-numero AS CHAR NO-UNDO.
    DEF OUTPUT PARAM TABLE FOR tt-tarifador.

    p-numero = "*" + p-numero + "*".

    EMPTY TEMP-TABLE tt-tarifador.

    for each tarifador NO-LOCK
        where not tarifador.cobrado
        AND   NOT tarifador.avaliado
        AND   tarifador.tipo <> "TIM":
        IF tarifador.numero MATCHES p-numero THEN DO:
            CREATE tt-tarifador.
            BUFFER-COPY tarifador TO tt-tarifador.
            tt-tarifador.r-rowid = ROWID(tarifador).
        END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-obtemLigacoesPorRamal) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE obtemLigacoesPorRamal Procedure 
PROCEDURE obtemLigacoesPorRamal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-ramal AS CHAR NO-UNDO.
    DEF OUTPUT PARAM TABLE FOR tt-tarifador.

    EMPTY TEMP-TABLE tt-tarifador.

    for each tarifador NO-LOCK
        where tarifador.ramal = p-ramal
        and not tarifador.cobrado
        AND NOT tarifador.avaliado:
        CREATE tt-tarifador.
        BUFFER-COPY tarifador TO tt-tarifador.
        tt-tarifador.r-rowid = ROWID(tarifador).
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-obtemRamal) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE obtemRamal Procedure 
PROCEDURE obtemRamal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM p-id AS CHAR NO-UNDO.
DEF INPUT PARAM p-senha AS CHAR NO-UNDO.
DEF OUTPUT PARAM p-ramal AS CHAR NO-UNDO INIT ?.

FOR FIRST int_usuar_mestre NO-LOCK
    WHERE int_usuar_mestre.cod_usuario = p-id
    AND   INT_usuar_mestre.cpf         = p-senha:

    ASSIGN p-ramal = INT_usuar_mestre.ramal.

END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-obtemValorTotal) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE obtemValorTotal Procedure 
PROCEDURE obtemValorTotal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-id AS CHAR NO-UNDO.
    DEF OUTPUT PARAM p-valor-atual AS DECIMAL NO-UNDO.

    for each tarifador NO-LOCK
        where tarifador.cod_usuario = p-id
        and not tarifador.cobrado
        AND tarifador.avaliado
        AND tarifador.finalidade:
        p-valor-atual = p-valor-atual + tarifador.valor.
    END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-validaMatricula) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaMatricula Procedure 
PROCEDURE validaMatricula :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAM p-id AS CHAR NO-UNDO.
    DEF OUTPUT PARAM p-erro AS CHARACTER NO-UNDO.

    ASSIGN p-erro = "".
    IF p-id = "" THEN DO:
        ASSIGN p-erro = "Matr¡cula do colaborador deve ser informada!".
    END.
    ELSE DO:
        FIND FIRST int_usuar_mestre NO-LOCK
             WHERE int_usuar_mestre.cod_usuario = p-id NO-ERROR.
        IF NOT AVAIL int_usuar_mestre THEN DO:
            ASSIGN p-erro = "Matr¡cula do colaborador inv lida, favor verificar!".
        END.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

