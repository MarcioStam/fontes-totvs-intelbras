&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/*------------------------------------------------------------------------

  File: 

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */


DEFINE NEW GLOBAL SHARED VARIABLE v_rec_fedex AS RECID NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE v_cod_usuar_corren AS CHARACTER NO-UNDO.

DEFINE VARIABLE c-cod-usuario   AS CHARACTER      NO-UNDO.

DEFINE BUFFER bfFedex FOR fedex.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS fedex.numero 
&Scoped-define ENABLED-TABLES fedex
&Scoped-define FIRST-ENABLED-TABLE fedex
&Scoped-Define ENABLED-OBJECTS rtParent rtParent-2 rtToolBar btFirst btPrev ~
btNext btLast btDet btZoom btInc btPrint btExit btHelp btGoTo 
&Scoped-Define DISPLAYED-FIELDS fedex.numero fedex.tipo fedex.empresa ~
fedex.material fedex.conhecimento 
&Scoped-define DISPLAYED-TABLES fedex
&Scoped-define FIRST-DISPLAYED-TABLE fedex


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miFirst        LABEL "&Primeiro"      ACCELERATOR "CTRL-HOME"
       MENU-ITEM miPrev         LABEL "&Anterior"      ACCELERATOR "CTRL-CURSOR-LEFT"
       MENU-ITEM miNext         LABEL "&Pr¢ximo"       ACCELERATOR "CTRL-CURSOR-RIGHT"
       MENU-ITEM miLast         LABEL "&Èltimo"        ACCELERATOR "CTRL-END"
       RULE
       MENU-ITEM miDetalhe      LABEL "Detalhe"        ACCELERATOR "ALT-D"
       MENU-ITEM miPesquisa     LABEL "Pesquisa"       ACCELERATOR "ALT-Z"
       RULE
       MENU-ITEM miIncluir      LABEL "Incluir"       
       RULE
       MENU-ITEM miRelat        LABEL "Relat¢rios"    
       RULE
       MENU-ITEM miExit         LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU smHelp 
       MENU-ITEM miContents     LABEL "&Conte£do"     
       RULE
       MENU-ITEM miAbout        LABEL "&Sobre..."     .

DEFINE MENU mbMain MENUBAR
       SUB-MENU  smFile         LABEL "&Arquivo"      
       SUB-MENU  smHelp         LABEL "&Ajuda"        .


/* Definitions of the field level widgets                               */
DEFINE BUTTON btDet 
     IMAGE-UP FILE "image/im-det.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-det.bmp":U
     LABEL "Det" 
     SIZE 4 BY 1.25 TOOLTIP "Detalhes".

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btFirst 
     IMAGE-UP FILE "image\im-fir":U
     IMAGE-INSENSITIVE FILE "image\ii-fir":U
     LABEL "First":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btGoTo 
     IMAGE-UP FILE "image\im-enter":U
     IMAGE-INSENSITIVE FILE "image\ii-enter":U
     LABEL "Go To" 
     SIZE 4 BY .88.

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image\im-hel":U
     IMAGE-INSENSITIVE FILE "image\ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btInc 
     IMAGE-UP FILE "image/im-add.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-det.bmp":U
     LABEL "Inclui" 
     SIZE 4 BY 1.25 TOOLTIP "Inclus∆o".

DEFINE BUTTON btLast 
     IMAGE-UP FILE "image\im-las":U
     IMAGE-INSENSITIVE FILE "image\ii-las":U
     LABEL "Last":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btNext 
     IMAGE-UP FILE "image/im-nex1.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-nex1.bmp":U
     LABEL "Next":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btPrev 
     IMAGE-UP FILE "image/im-pre1.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-pre1.bmp":U
     LABEL "Prev":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btPrint 
     IMAGE-UP FILE "image\im-pri.bmp":U
     IMAGE-INSENSITIVE FILE "image\ii-pri.bmp":U
     LABEL "Mail" 
     SIZE 4 BY 1.25 TOOLTIP "Relat¢rio".

DEFINE BUTTON btZoom 
     IMAGE-UP FILE "image/im-sea1.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-sea1.bmp":U
     LABEL "Mail" 
     SIZE 4 BY 1.25 TOOLTIP "Pesquisa".

DEFINE RECTANGLE rtParent
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 1.33.

DEFINE RECTANGLE rtParent-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 4.33.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     btFirst AT ROW 1.13 COL 1.57 HELP
          "Primeira ocorrància"
     btPrev AT ROW 1.13 COL 5.57 HELP
          "Ocorrància anterior"
     btNext AT ROW 1.13 COL 9.57 HELP
          "Pr¢xima ocorrància"
     btLast AT ROW 1.13 COL 13.57 HELP
          "Èltima ocorrància"
     btDet AT ROW 1.13 COL 18.57 HELP
          "Pesquisa"
     btZoom AT ROW 1.13 COL 22.72 HELP
          "Pesquisa"
     btInc AT ROW 1.13 COL 29 HELP
          "Pesquisa"
     btPrint AT ROW 1.13 COL 34.72 HELP
          "Pesquisa"
     btExit AT ROW 1.13 COL 82.86 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.86 HELP
          "Ajuda"
     fedex.numero AT ROW 2.88 COL 27 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.43 BY .88
     btGoTo AT ROW 2.88 COL 37 HELP
          "V† Para"
     fedex.tipo AT ROW 4.33 COL 27 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     fedex.empresa AT ROW 5.33 COL 27 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 26.29 BY .88
     fedex.material AT ROW 6.33 COL 27 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 41.72 BY .88
     fedex.conhecimento AT ROW 7.33 COL 27 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 24 BY .88
     rtParent AT ROW 2.67 COL 1
     rtParent-2 AT ROW 4.17 COL 1
     rtToolBar AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 7.71
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Solicitacoes COURIER - ESACR004C"
         HEIGHT             = 7.71
         WIDTH              = 90
         MAX-HEIGHT         = 32.13
         MAX-WIDTH          = 164.57
         VIRTUAL-HEIGHT     = 32.13
         VIRTUAL-WIDTH      = 164.57
         MAX-BUTTON         = no
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU mbMain:HANDLE.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME DEFAULT-FRAME
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN fedex.conhecimento IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fedex.empresa IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fedex.material IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fedex.tipo IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Solicitacoes COURIER - ESACR004C */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Solicitacoes COURIER - ESACR004C */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btDet
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDet C-Win
ON CHOOSE OF btDet IN FRAME DEFAULT-FRAME /* Det */
DO:
  RUN pi-detalhe.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit C-Win
ON CHOOSE OF btExit IN FRAME DEFAULT-FRAME /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btFirst
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFirst C-Win
ON CHOOSE OF btFirst IN FRAME DEFAULT-FRAME /* First */
DO:
  RUN pi-first.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btGoTo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btGoTo C-Win
ON CHOOSE OF btGoTo IN FRAME DEFAULT-FRAME /* Go To */
DO:
    RUN pi-gotorecord.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btInc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btInc C-Win
ON CHOOSE OF btInc IN FRAME DEFAULT-FRAME /* Inclui */
DO:
    RUN pi-inclui IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btLast
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btLast C-Win
ON CHOOSE OF btLast IN FRAME DEFAULT-FRAME /* Last */
DO:
  RUN pi-last.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btNext
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btNext C-Win
ON CHOOSE OF btNext IN FRAME DEFAULT-FRAME /* Next */
DO:
  RUN pi-next.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btPrev
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btPrev C-Win
ON CHOOSE OF btPrev IN FRAME DEFAULT-FRAME /* Prev */
DO:
  RUN pi-prev.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btPrint
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btPrint C-Win
ON CHOOSE OF btPrint IN FRAME DEFAULT-FRAME /* Mail */
DO:
    RUN pi-print.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btZoom
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btZoom C-Win
ON CHOOSE OF btZoom IN FRAME DEFAULT-FRAME /* Mail */
DO:
  RUN pi-zoom.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miDetalhe
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miDetalhe C-Win
ON CHOOSE OF MENU-ITEM miDetalhe /* Detalhe */
DO:
  APPLY "CHOOSE" TO btDet IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miFirst
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miFirst C-Win
ON CHOOSE OF MENU-ITEM miFirst /* Primeiro */
DO:
  APPLY "CHOOSE" TO btFirst IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miLast
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miLast C-Win
ON CHOOSE OF MENU-ITEM miLast /* Èltimo */
DO:
  APPLY "CHOOSE" TO btLast IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miNext
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miNext C-Win
ON CHOOSE OF MENU-ITEM miNext /* Pr¢ximo */
DO:
  APPLY "CHOOSE" TO btNext IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miPesquisa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miPesquisa C-Win
ON CHOOSE OF MENU-ITEM miPesquisa /* Pesquisa */
DO:
  APPLY "CHOOSE" TO btZoom IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miPrev
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miPrev C-Win
ON CHOOSE OF MENU-ITEM miPrev /* Anterior */
DO:
  APPLY "CHOOSE" TO btPrev IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miRelat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miRelat C-Win
ON CHOOSE OF MENU-ITEM miRelat /* Relat¢rios */
DO:
  APPLY "CHOOSE" TO btPrint IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

    FIND usuar_mestre NO-LOCK 
        WHERE usuar_mestre.cod_usuario = v_cod_usuar_corren NO-ERROR.
    IF AVAILABLE usuar_mestre THEN
        ASSIGN c-cod-usuario = usuar_mestre.cod_usuario.

    RUN enable_UI.
    RUN pi-first.

  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI C-Win  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
  THEN DELETE WIDGET C-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI C-Win  _DEFAULT-ENABLE
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
  IF AVAILABLE fedex THEN 
    DISPLAY fedex.numero fedex.tipo fedex.empresa fedex.material 
          fedex.conhecimento 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE rtParent rtParent-2 rtToolBar btFirst btPrev btNext btLast btDet 
         btZoom btInc btPrint btExit btHelp fedex.numero btGoTo 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-detalhe C-Win 
PROCEDURE pi-detalhe :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* Atribuir a variavel global v_rec_cliente com o recid do cliente corrente e
   executar o programa de detalhe do cliente */
   
    IF AVAILABLE fedex THEN
        RUN esp/acr/esacr004b.w (ROWID(fedex)).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-display C-Win 
PROCEDURE pi-display :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF AVAILABLE fedex THEN
        DISPLAY fedex.conhecimento fedex.empresa fedex.material fedex.numero fedex.tipo
            WITH FRAME {&FRAME-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-email C-Win 
PROCEDURE pi-email :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-first C-Win 
PROCEDURE pi-first :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF v_cod_usuar_corren = 'super' THEN
        FIND FIRST fedex NO-LOCK.
    ELSE
        FIND FIRST fedex NO-LOCK
            WHERE fedex.cod_usuario = c-cod-usuario 
              AND NOT fedex.encerrado NO-ERROR.

    RUN pi-display.
    
    IF AVAILABLE fedex THEN DO:
        DISABLE btFirst
                btPrev
            WITH FRAME {&FRAME-NAME}.
        ASSIGN MENU-ITEM miFirst:SENSITIVE IN MENU smFile = FALSE
               MENU-ITEM miPrev:SENSITIVE IN MENU smFile = FALSE.

        ENABLE btNext
               btLast
            WITH FRAME {&FRAME-NAME}.
        ASSIGN MENU-ITEM miNext:SENSITIVE       IN MENU smFile = TRUE
               MENU-ITEM miLast:SENSITIVE       IN MENU smFile = TRUE
               MENU-ITEM miDetalhe:SENSITIVE    IN MENU smFile = FALSE
               MENU-ITEM miPesquisa:SENSITIVE   IN MENU smFile = FALSE
               MENU-ITEM miLast:SENSITIVE       IN MENU smFile = FALSE
               MENU-ITEM miIncluir:SENSITIVE    IN MENU smFile = FALSE.
    END.
    ELSE DO:
        DISABLE btFirst
                btPrev
                btNext
                btLast
                btDet
                btZoom
            WITH FRAME {&FRAME-NAME}.
    
        ASSIGN MENU-ITEM miFirst:SENSITIVE      IN MENU smFile = FALSE
               MENU-ITEM miPrev:SENSITIVE       IN MENU smFile = FALSE
               MENU-ITEM miNext:SENSITIVE       IN MENU smFile = FALSE
               MENU-ITEM miLast:SENSITIVE       IN MENU smFile = FALSE
               MENU-ITEM miDetalhe:SENSITIVE    IN MENU smFile = FALSE
               MENU-ITEM miPesquisa:SENSITIVE   IN MENU smFile = FALSE
               MENU-ITEM miLast:SENSITIVE       IN MENU smFile = FALSE
               MENU-ITEM miIncluir:SENSITIVE    IN MENU smFile = FALSE.
    END.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gotorecord C-Win 
PROCEDURE pi-gotorecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF v_cod_usuar_corren = 'super' THEN
        FIND FIRST bfFedex NO-LOCK
            WHERE bfFedex.numero = INPUT FRAME {&FRAME-NAME} fedex.numero
            NO-ERROR.
    ELSE
        FIND FIRST bfFedex NO-LOCK
            WHERE bfFedex.numero = INPUT FRAME {&FRAME-NAME} fedex.numero
              AND bfFedex.cod_usuario = c-cod-usuario
            NO-ERROR.

    IF NOT AVAILABLE bfFedex THEN DO:
        MESSAGE "Courrier n∆o existe para a chave informada!" VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    ELSE DO:
        IF bfFedex.encerrado THEN DO:
            MESSAGE "Courrier j† encerrado!" VIEW-AS ALERT-BOX ERROR.
            RETURN NO-APPLY.
        END.
        FIND fedex NO-LOCK WHERE ROWID(fedex) = ROWID(bfFedex).
    END.

    RUN pi-display.        

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-inclui C-Win 
PROCEDURE pi-inclui :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE l-ok AS LOGICAL    NO-UNDO.

    RUN esp/acr/esacr004d.w ('Add', ?, OUTPUT l-ok).
    IF l-ok THEN
        RUN pi-last IN THIS-PROCEDURE.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-last C-Win 
PROCEDURE pi-last :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF v_cod_usuar_corren = 'super' THEN
        FIND LAST fedex NO-LOCK.
    ELSE
        FIND LAST fedex NO-LOCK 
            WHERE fedex.cod_usuario = c-cod-usuario 
              AND NOT fedex.encerrado NO-ERROR.

    RUN pi-display.
    
    IF AVAILABLE fedex THEN DO:
        DISABLE btLast
                btNext
            WITH FRAME {&FRAME-NAME}.
        ASSIGN MENU-ITEM miLast:SENSITIVE IN MENU smFile = FALSE
               MENU-ITEM miNext:SENSITIVE IN MENU smFile = FALSE.

        ENABLE btFirst
               btPrev
            WITH FRAME {&FRAME-NAME}.
        ASSIGN MENU-ITEM miPrev:SENSITIVE       IN MENU smFile = TRUE
               MENU-ITEM miFirst:SENSITIVE       IN MENU smFile = TRUE
               MENU-ITEM miDetalhe:SENSITIVE    IN MENU smFile = FALSE
               MENU-ITEM miPesquisa:SENSITIVE   IN MENU smFile = FALSE
               MENU-ITEM miLast:SENSITIVE       IN MENU smFile = FALSE
               MENU-ITEM miIncluir:SENSITIVE    IN MENU smFile = FALSE.
    END.
    ELSE DO:
        DISABLE btFirst
                btPrev
                btNext
                btLast
                btDet
                btZoom
            WITH FRAME {&FRAME-NAME}.
    
        ASSIGN MENU-ITEM miFirst:SENSITIVE      IN MENU smFile = FALSE
               MENU-ITEM miPrev:SENSITIVE       IN MENU smFile = FALSE
               MENU-ITEM miNext:SENSITIVE       IN MENU smFile = FALSE
               MENU-ITEM miLast:SENSITIVE       IN MENU smFile = FALSE
               MENU-ITEM miDetalhe:SENSITIVE    IN MENU smFile = FALSE
               MENU-ITEM miPesquisa:SENSITIVE   IN MENU smFile = FALSE
               MENU-ITEM miLast:SENSITIVE       IN MENU smFile = FALSE
               MENU-ITEM miIncluir:SENSITIVE    IN MENU smFile = FALSE.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-next C-Win 
PROCEDURE pi-next :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF v_cod_usuar_corren = 'super' THEN
        FIND NEXT fedex NO-LOCK.
    ELSE
        FIND NEXT fedex NO-LOCK 
            WHERE fedex.cod_usuario = c-cod-usuario 
              AND NOT fedex.encerrado NO-ERROR.

    IF AVAIL fedex THEN DO:
        RUN pi-display.

        ENABLE btFirst
               btPrev
            WITH FRAME {&FRAME-NAME}.
        ASSIGN MENU-ITEM miFirst:SENSITIVE IN MENU smFile = TRUE
               MENU-ITEM miPrev:SENSITIVE IN MENU smFile = TRUE.
    END.
    ELSE DO:
        MESSAGE "Èltimo registro!" VIEW-AS ALERT-BOX ERROR.
        RUN pi-last.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-prev C-Win 
PROCEDURE pi-prev :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF v_cod_usuar_corren = 'super' THEN
        FIND PREV fedex NO-LOCK.
    ELSE
        FIND PREV fedex NO-LOCK 
            WHERE fedex.cod_usuario = c-cod-usuario 
              AND NOT fedex.encerrado NO-ERROR.

    IF AVAIL fedex THEN DO:
        RUN pi-display.

        ENABLE btNext
               btLast
            WITH FRAME {&FRAME-NAME}.

        ASSIGN MENU-ITEM miNext:SENSITIVE IN MENU smFile = TRUE
               MENU-ITEM miLast:SENSITIVE IN MENU smFile = TRUE.
    END.
    ELSE DO:
        MESSAGE "Primeiro registro!" VIEW-AS ALERT-BOX ERROR.
        RUN pi-first.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-print C-Win 
PROCEDURE pi-print :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    RUN esp/apb/esapb022.p.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-zoom C-Win 
PROCEDURE pi-zoom :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* Executar o programa de zoom de clientes e posicionar o registro neste programa com
   base na variavel global v_rec_cliente */

/*
RUN prgint/utb/utb107ka.p.

IF v_rec_cliente <> ? THEN DO:
    FIND FIRST customer NO-LOCK
        WHERE RECID(customer) = v_rec_cliente NO-ERROR.
    IF AVAIL customer THEN DO:
        ASSIGN cod-cliente:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(customer.cust-num).
        APPLY "choose" TO btGoTo IN FRAME {&FRAME-NAME}.
    END.
END.
*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

