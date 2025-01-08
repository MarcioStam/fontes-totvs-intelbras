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
{cdp/cd0666.i}

DEF INPUT PARAM p_cod_usuario AS CHAR NO-UNDO.
def Input param p_cod_senha 
    as character 
    format "x(12)" 
    no-undo. 
DEF INPUT PARAM p_prog_vers AS CHAR NO-UNDO.
DEF INPUT PARAM p_rotina_intelbras AS CHAR FORMAT "x(30)" NO-UNDO.
DEF OUTPUT PARAM p_impres_layout AS CHAR NO-UNDO.
DEF OUTPUT PARAM p_nom_disposit_so AS CHAR NO-UNDO.
DEF OUTPUT PARAM p_tit_prog_dtsul AS CHAR NO-UNDO.
DEF OUTPUT PARAM TABLE FOR tt-erro.

DEF VAR v_cod_prog_dtsul AS CHAR NO-UNDO.
def var i_cod_empres_usuar as CHAR no-undo.
def var c_nom_razao_social as char no-undo.

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
   Other Settings: CODE-ONLY
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

RUN pi_verifica_usuario_senha IN THIS-PROCEDURE
    (INPUT p_cod_usuario,
     INPUT p_cod_senha,
     OUTPUT TABLE tt-erro).
IF RETURN-VALUE NE "NOK" THEN DO:
    FOR first imprsor_usuar NO-LOCK
        where imprsor_usuar.log_imprsor_princ 
        and   imprsor_usuar.cod_usuario = p_cod_usuario,
        FIRST  layout_impres no-lock 
        where layout_impres.nom_impressora = imprsor_usuar.nom_impressora
        AND   layout_impres.log_layout_impres_princ:
            ASSIGN p_impres_layout = imprsor_usuar.nom_impressora + ":" +  
                   layout_impres.cod_layout_impres
                   p_nom_disposit_so = imprsor_usuar.nom_disposit_so.
    END.
    ASSIGN v_cod_prog_dtsul = entry(1, p_prog_vers, "|")
           p_tit_prog_dtsul = CAPS(v_cod_prog_dtsul).

    FOR FIRST prog_dtsul NO-LOCK
        WHERE prog_dtsul.cod_prog_dtsul = v_cod_prog_dtsul:

    FOR FIRST param-global NO-LOCK,
        FIRST mgcad.empresa NO-LOCK
        WHERE mgcad.empresa.ep-codigo = param-global.empresa-prin: 
        ASSIGN i_cod_empres_usuar = mgcad.empresa.ep-codigo
               c_nom_razao_social = mgcad.empresa.razao-social.
    END.

        p_tit_prog_dtsul = SUBSTITUTE("&1 - &2 - &3 - &4 - &5",
                                      TRIM(prog_dtsul.des_prog_dtsul),
                                      CAPS(v_cod_prog_dtsul),
                                      entry(2, p_prog_vers, "|"),
                                      TRIM(string(i_cod_empres_usuar)),
                                      TRIM(c_nom_razao_social)).

    END.
END.
RETURN RETURN-VALUE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-pi_verifica_usuario_senha) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi_verifica_usuario_senha Procedure 
PROCEDURE pi_verifica_usuario_senha :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /************************ Parameter Definition Begin ************************/ 
    DEF INPUT PARAM p_cod_usuario AS CHAR NO-UNDO.
    def Input param p_cod_senha 
        as character 
        format "x(12)" 
        no-undo. 
    DEF OUTPUT PARAM TABLE FOR tt-erro.
    /************************* Parameter Definition End *************************/ 

    def buffer b_usuar_mestre for usuar_mestre. 
    def buffer b_usuar_mestre_senha for usuar_mestre.
    /************************* Variable Definition Begin ************************/ 
    def var v_dat_liberd                     as date            no-undo. 
    def var v_num_seconds                    as integer         no-undo. 
    def var v_num_seconds_liberd             as integer         no-undo. 
    def var v_qtd_aux                        as decimal         no-undo. 
    def var v_rec_usuar_mestre               as recid           no-undo. 
    DEFINE VARIABLE l-acesso-permitido       AS LOGICAL         NO-UNDO.
    DEFINE VARIABLE v_num_count              AS INTEGER     NO-UNDO.
    DEFINE VARIABLE v_cod_grp_usuar          AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-msg                    AS CHARACTER   NO-UNDO.
    /************************** Variable Definition End *************************/ 

    IF entry(1, p_prog_vers, "|") MATCHES "*escep013*" AND
       TRIM(p_rotina_intelbras) = "escep013" THEN DO:
        ASSIGN l-acesso-permitido = NO.

        bl-grp-usuar:
        FOR EACH usuar_grp_usuar NO-LOCK USE-INDEX srgrpsr_usuario
            WHERE usuar_grp_usuar.cod_usuario = p_cod_usuario:

            FOR FIRST prog_dtsul_segur NO-LOCK
                WHERE prog_dtsul_segur.cod_prog_dtsul = p_rotina_intelbras
                AND   prog_dtsul_segur.cod_grp_usuar  = usuar_grp_usuar.cod_grp_usuar:

                ASSIGN l-acesso-permitido = TRUE.

                LEAVE bl-grp-usuar.

            END.

        END.
        IF l-acesso-permitido = NO THEN DO:
            
            /*ASSIGN c-msg = "de Baixa Parcial".*/

            FIND FIRST int-procedimento
                 WHERE int-procedimento.cod_proced = p_rotina_intelbras NO-LOCK NO-ERROR.
            IF AVAIL int-procedimento THEN DO:
                FIND usuar_mestre WHERE
                     usuar_mestre.cod_usuario = int-procedimento.cod_usuario NO-LOCK NO-ERROR.
                /*IF AVAIL usuar_mestre THEN
                    ASSIGN c-msg = c-msg + " com o responsavel pelo programa: " + usuar_mestre.nom_usuario.*/
            END.

            /* Usu rio sem permissÊo para acessar o programa. */
            CREATE tt-erro.
            ASSIGN tt-erro.cd-erro = 2858. /* 2858 */

            run utp/ut-msgs.p (input "Msg", 
                             input 2858, 
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9", 
                                               c-msg)) /*2858 */. /*  */ 
            ASSIGN tt-erro.mensagem = RETURN-VALUE.
            run utp/ut-msgs.p (input "help", 
                             input 2858, 
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9", 
                                               c-msg)) /*2858 */. /*  */ 

            ASSIGN tt-erro.mensagem = tt-erro.mensagem + "|" + RETURN-VALUE + "|NOK".
            RETURN "NOK":U.
        END.
    END.

    find b_usuar_mestre no-lock 
         where b_usuar_mestre.cod_usuario = p_cod_usuario 
         use-index srmstr_id /*cl_cod_usuario of usuar_mestre*/ 
          no-error. 
    if  not avail b_usuar_mestre 
    then do: 
        CREATE tt-erro.
        ASSIGN tt-erro.cd-erro = 4753.
        run utp/ut-msgs.p (input "Msg", 
                         input 4753, 
                         input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9", 
                                           p_cod_usuario)) /*msg_1786*/. /* v_cod_usuario nÆo deve ser alterado para usuar_mestre.cod_usuario. */ 
        tt-erro.mensagem = RETURN-VALUE.
        run utp/ut-msgs.p (input "Help", 
                         input 4753, 
                         input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9", 
                                           p_cod_usuario)) /*msg_1786*/. /* v_cod_usuario nÆo deve ser alterado para usuar_mestre.cod_usuario. */ 
        tt-erro.mensagem = tt-erro.mensagem + "|" + RETURN-VALUE + "|NOK".
        RETURN "NOK".
    end /* if */. 

    /* Periodo de validade */ 
    if  today > b_usuar_mestre.dat_fim_valid or 
        today < b_usuar_mestre.dat_inic_valid 
    then do: 
        CREATE tt-erro.
        ASSIGN tt-erro.cd-erro = 4759.
        run utp/ut-msgs.p (input "Msg", 
                         input 4759, 
                         input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9", trim(b_usuar_mestre.cod_usuar))) /*msg_2379*/. 
        tt-erro.mensagem = RETURN-VALUE.
        run utp/ut-msgs.p (input "Help", 
                         input 4759, 
                         input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9", trim(b_usuar_mestre.cod_usuar))) /*msg_2379*/. 
        tt-erro.mensagem = tt-erro.mensagem + "|" + RETURN-VALUE + "|NOK".
        RETURN "NOK".
    end /* if */. 
 
    /* Expira‡Æo da Senha */ 
    if  today > b_usuar_mestre.dat_valid_senha then do:
        CREATE tt-erro.
        ASSIGN tt-erro.cd-erro = 4755.
        run utp/ut-msgs.p (input "Msg", 
                           input 4755, 
                           input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_2381*/. 
        tt-erro.mensagem = RETURN-VALUE.
        run utp/ut-msgs.p (input "Help", 
                           input 4755, 
                           input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_2381*/. 
        tt-erro.mensagem = tt-erro.mensagem + "|" + RETURN-VALUE + "|NOK".
        RETURN "NOK".
    end.
    
 
    if  base64-encode(sha1-digest(lc(p_cod_senha))) <> b_usuar_mestre.cod_senha  then do: 
        CREATE tt-erro.
        ASSIGN tt-erro.cd-erro = 4758.
        run utp/ut-msgs.p (input "Msg", 
                         input 4758, 
                         input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9", 
                                           b_usuar_mestre.cod_usuario)) /*msg_1787*/. 
        tt-erro.mensagem = RETURN-VALUE.
        run utp/ut-msgs.p (input "Help", 
                         input 4758, 
                         input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9", 
                                           b_usuar_mestre.cod_usuario)) /*msg_1787*/. 
        tt-erro.mensagem = tt-erro.mensagem + "|" + RETURN-VALUE + "|NOK".
        RETURN "NOK".
    end /* if */. 
 
    /* At‚ 10 dias antes de Expirar a Senha */
        
    if  b_usuar_mestre.dat_valid_senha - 10 <= today then do: 
        CREATE tt-erro.
        ASSIGN tt-erro.cd-erro = 4754.
        run utp/ut-msgs.p (input "Msg", 
                           input 4754, 
                           input string(b_usuar_mestre.dat_valid_senha,"99/99/9999")). 
        tt-erro.mensagem = RETURN-VALUE.
        run utp/ut-msgs.p (input "Help", 
                           input 4754, 
                           input string(b_usuar_mestre.dat_valid_senha,"99/99/9999")). 
        tt-erro.mensagem = tt-erro.mensagem + "|" + RETURN-VALUE + "|".
    end /* if */. 

    return b_usuar_mestre.cod_usuario. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

