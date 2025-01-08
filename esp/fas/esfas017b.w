&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME wWin
{adecomm/appserv.i}
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWin 
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrwin.w - ADM SmartWindow Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  History: New V9 Version - January 15, 1998
          
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AB.              */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

DEF TEMP-TABLE tt_int_solic_transf NO-UNDO
    LIKE int_solic_transf.

/* Parameters Definitions ---                                           */
DEF INPUT PARAM TABLE FOR tt_int_solic_transf.
DEF INPUT PARAM p_tip_proces AS CHAR  NO-UNDO.

/* Local Variable Definitions ---                                       */
DEF VAR v_remetente                  AS CHAR                  NO-UNDO.
DEF VAR v_destino                    AS CHAR                  NO-UNDO.
DEF VAR v_msg_mail                   AS CHAR                  NO-UNDO.
DEF VAR h-acomp                      AS HANDLE                NO-UNDO.
DEF VAR v_cod_cta_pat                LIKE cta_pat.des_cta_pat NO-UNDO.

def new global shared var v_cod_usuar_corren as CHARACTER format "x(12)":U label "Usu rio Corrente" column-label "Usu rio Corrente" no-undo.
DEF NEW GLOBAL SHARED VAR v_cod_empres_usuar AS CHARACTER FORMAT "x(3)":U  LABEL "Empresa"          COLUMN-LABEL "Empresa"          NO-UNDO.

{cdp/cd0666.i}
{utp/utapi019.i}

{src/adm2/widgetprto.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar RECT-1 v_observacao btOK btCancel ~
btHelp2 
&Scoped-Define DISPLAYED-OBJECTS v_observacao 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "&Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp2 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "&Ok" 
     SIZE 10 BY 1.

DEFINE VARIABLE v_observacao AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 58 BY 5 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 73 BY 7.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 80 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     v_observacao AT ROW 2.75 COL 13 NO-LABEL WIDGET-ID 2
     btOK AT ROW 9.46 COL 2 HELP
          "Executar" WIDGET-ID 8
     btCancel AT ROW 9.46 COL 13 HELP
          "Cancelar" WIDGET-ID 4
     btHelp2 AT ROW 9.5 COL 70 HELP
          "Ajuda" WIDGET-ID 6
     "Observa‡Æo Reprova‡Æo" VIEW-AS TEXT
          SIZE 23 BY .67 AT ROW 1.5 COL 8 WIDGET-ID 14
     rtToolBar AT ROW 9.25 COL 1 WIDGET-ID 10
     RECT-1 AT ROW 1.75 COL 5 WIDGET-ID 12
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80.72 BY 10.13 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source
   Other Settings: APPSERVER
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWin ASSIGN
         HIDDEN             = YES
         TITLE              = "Reprovar Solicita‡Æo Transf Imobilizado"
         HEIGHT             = 9.88
         WIDTH              = 80.14
         MAX-HEIGHT         = 28.79
         MAX-WIDTH          = 146.14
         VIRTUAL-HEIGHT     = 28.79
         VIRTUAL-WIDTH      = 146.14
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wWin 
/* ************************* Included-Libraries *********************** */

{src/adm2/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWin
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME fMain
   FRAME-NAME                                                           */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
THEN wWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON END-ERROR OF wWin /* Reprovar Solicita‡Æo Transf Imobilizado */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* Reprovar Solicita‡Æo Transf Imobilizado */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wWin
ON CHOOSE OF btCancel IN FRAME fMain /* Cancelar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp2 wWin
ON CHOOSE OF btHelp2 IN FRAME fMain /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wWin
ON CHOOSE OF btOK IN FRAME fMain /* Ok */
DO:
    DO ON ERROR UNDO, RETURN NO-APPLY:
        RUN piExecute IN THIS-PROCEDURE.
    END.

    IF RETURN-VALUE = "OK":U THEN
        APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWin 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */

/*
IF  p_tip_proces = "A" THEN 
    ASSIGN v_observacao:LABEL IN FRAME fMain = "Obs Aprova‡Æo".
ELSE
    ASSIGN v_observacao:LABEL IN FRAME fMain = "Obs Reprova‡Æo".
*/

{src/adm2/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects wWin  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI wWin  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
  THEN DELETE WIDGET wWin.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI wWin  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  DISPLAY v_observacao 
      WITH FRAME fMain IN WINDOW wWin.
  ENABLE rtToolBar RECT-1 v_observacao btOK btCancel btHelp2 
      WITH FRAME fMain IN WINDOW wWin.
  {&OPEN-BROWSERS-IN-QUERY-fMain}
  VIEW wWin.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE exitObject wWin 
PROCEDURE exitObject :
/*------------------------------------------------------------------------------
  Purpose:  Window-specific override of this procedure which destroys 
            its contents and itself.
    Notes:  
------------------------------------------------------------------------------*/

  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piExecute wWin 
PROCEDURE piExecute :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DO ON ERROR UNDO, RETURN ERROR
       ON STOP  UNDO, RETURN ERROR:

        IF  INPUT FRAME fMain v_observacao = "" THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 17006,
                               INPUT "Observa‡Æo deve ser informada !").

            APPLY "ENTRY":U TO v_observacao IN FRAME fMain.

            RETURN NO-APPLY.
        END.

        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
        RUN pi-inicializar in h-acomp ("Reprovando").

        FOR EACH tt_int_solic_transf:

            RUN pi-acompanhar IN h-acomp (INPUT "Reprovando Solicita‡Æo: " + STRING(tt_int_solic_transf.num_solicitacao)).

            FIND FIRST int_solic_transf
                WHERE int_solic_transf.num_solicitacao = tt_int_solic_transf.num_solicitacao
                AND   int_solic_transf.cod_cta_pat     = tt_int_solic_transf.cod_cta_pat    
                AND   int_solic_transf.num_bem_pat     = tt_int_solic_transf.num_bem_pat    
                AND   int_solic_transf.num_seq_bem_pat = tt_int_solic_transf.num_seq_bem_pat
                EXCLUSIVE-LOCK NO-ERROR.

            IF  AVAIL int_solic_transf THEN DO:
                ASSIGN int_solic_transf.ind_aprovac   = "Reprovado"
                       int_solic_transf.des_historico = int_solic_transf.des_historico + ";" + INPUT FRAME fMain v_observacao.

                RUN pi_envia_email.
            END.
        END.

        RUN pi-finalizar IN h-acomp.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi_envia_email wWin 
PROCEDURE pi_envia_email :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE h-utapi019  AS HANDLE    NO-UNDO.
    DEFINE VARIABLE c-destino AS CHARACTER   NO-UNDO.

    RUN utp/utapi019.p PERSISTENT SET h-utapi019.

    EMPTY TEMP-TABLE tt-envio2.   
    EMPTY TEMP-TABLE tt-mensagem.
    EMPTY TEMP-TABLE tt-erros.

    FOR FIRST usuar_mestre NO-LOCK 
        WHERE usuar_mestre.cod_usuario = v_cod_usuar_corren:
    END.
    ASSIGN v_remetente = IF usuar_mestre.cod_e_mail_local = "" THEN "ems@intelbras.com.br" ELSE usuar_mestre.cod_e_mail_local.

    FOR FIRST usuar_mestre NO-LOCK 
        WHERE usuar_mestre.cod_usuario = int_solic_transf.cod_usuar_solic:
    END.
    ASSIGN v_destino = usuar_mestre.cod_e_mail_local.

    FIND FIRST cta_pat
        WHERE cta_pat.cod_empresa = v_cod_empres_usuar
        AND   cta_pat.cod_cta_pat = int_solic_transf.cod_cta_pat NO-LOCK NO-ERROR.

    IF  AVAIL cta_pat THEN
        ASSIGN v_cod_cta_pat = cta_pat.des_cta_pat.
    ELSE
        ASSIGN v_cod_cta_pat = int_solic_transf.cod_cta_pat.

    IF  v_destino = "" THEN DO:
        CREATE tt-erro.
        ASSIGN tt-erro.cd-erro  = 17006
               tt-erro.mensagem = "Erro no envio do e-mail: " + STRING(tt-erros.cod-erro) + " - " + tt-erros.desc-erro.
    END.
    ELSE DO:
        CREATE tt-envio2.
        ASSIGN tt-envio2.versao-integracao = 1
               tt-envio2.destino           = v_destino
               tt-envio2.remetente         = v_remetente
               tt-envio2.copia             = ""
               tt-envio2.assunto           = "TRANSFERÒNCIA DE IMOBILIZADO REPROVADA - " + int_solic_transf.cod_cta_pat         + "/" 
                                                                                         + string(int_solic_transf.num_bem_pat) + "/" 
                                                                                         + STRING(int_solic_transf.num_seq_bem_pat)
               tt-envio2.arq-anexo         = ""
               tt-envio2.formato           = "TEXTO".
    
        ASSIGN v_msg_mail = "Prezado(a),"                               + CHR(10) + CHR(10) +
                            "Sua solicita‡Æo de transferˆncia foi reprovada."     + CHR(10) + 
                            "Seguem abaixo informa‡äes da solicita‡Æo." + CHR(10) + CHR(10).
    
        ASSIGN v_msg_mail = v_msg_mail               + 
                            "Num Solicita‡Æo: "      + string(int_solic_transf.num_solicitacao)               + chr(10) +
                            "Conta Patrimonial: "    + v_cod_cta_pat                                          + chr(10) +
                            "Bem Patrimonial: "      + STRING(int_solic_transf.num_bem_pat)                   + chr(10) +
                            "Sequˆncia: "            + STRING(int_solic_transf.num_seq_bem_pat)               + chr(10) +
                            "Dt Transferˆncia: "     + STRING(date(int_solic_transf.dat_transf),"99/99/9999") + chr(10) + 
                            "Observa‡Æo: "           + entry(1,int_solic_transf.des_historico,";")            + chr(10) + chr(10) +
                            /*"Teste - email destino: " + v_destino + chr(10) + chr(10) +*/
                            "Atenciosamente,"                                                                 + chr(10) +
                            "Intelbras S.A.".
    
        CREATE tt-mensagem.
        ASSIGN tt-mensagem.seq-mensagem = 1
               tt-mensagem.mensagem     = v_msg_mail.
       
        RUN pi-execute2 in h-utapi019 (INPUT  TABLE tt-envio2,
                                       INPUT  TABLE tt-mensagem,
                                       OUTPUT TABLE tt-erros).
    
        FOR EACH tt-erros:
            CREATE tt-erro.
            ASSIGN tt-erro.cd-erro  = 17006
                   tt-erro.mensagem = "Erro no envio do e-mail: " + STRING(tt-erros.cod-erro) + " - " + tt-erros.desc-erro.
        END.
    
        IF  VALID-HANDLE(h-utapi019) THEN 
            DELETE PROCEDURE h-utapi019.
    
        ASSIGN h-utapi019 = ?.
    END.

    RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

