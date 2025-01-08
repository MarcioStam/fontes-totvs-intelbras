&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
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

DEF INPUT-OUTPUT PARAM pIdEtiqIni        AS DEC    NO-UNDO.
DEF INPUT-OUTPUT PARAM pIdEtiqFin        AS DEC    NO-UNDO.
DEF INPUT-OUTPUT PARAM pDtImplantacaoIni AS DATE    NO-UNDO.
DEF INPUT-OUTPUT PARAM pDtImplantacaoFin AS DATE    NO-UNDO.
DEF INPUT-OUTPUT PARAM pBtOk             AS LOGICAL INITIAL NO NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-45 IMAGE-13 IMAGE-14 rtToolBar IMAGE-15 ~
IMAGE-16 i-id-etiq-ini i-id-etiq-fin dt-implantacao-ini dt-implantacao-fin ~
btOK btCancel 
&Scoped-Define DISPLAYED-OBJECTS i-id-etiq-ini i-id-etiq-fin ~
dt-implantacao-ini dt-implantacao-fin 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "&Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "&OK" 
     SIZE 10 BY 1.

DEFINE VARIABLE dt-implantacao-fin AS DATE FORMAT "99/99/9999" INITIAL 03/01/01 
     VIEW-AS FILL-IN 
     SIZE 12.72 BY .88.

DEFINE VARIABLE dt-implantacao-ini AS DATE FORMAT "99/99/9999" INITIAL 03/01/01 
     LABEL "Dt Implant" 
     VIEW-AS FILL-IN 
     SIZE 12.72 BY .88.

DEFINE VARIABLE i-id-etiq-fin AS DECIMAL FORMAT ">>>>>>>>>>>>>>>9" INITIAL 999999999999999 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88.

DEFINE VARIABLE i-id-etiq-ini AS DECIMAL FORMAT ">>>>>>>>>>>>>>>9" INITIAL 0 
     LABEL "Etiqueta" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88.

DEFINE IMAGE IMAGE-13
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-14
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-15
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-16
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE RECTANGLE RECT-45
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 72 BY 5.17.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 71 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     i-id-etiq-ini AT ROW 2 COL 14 COLON-ALIGNED HELP
          "N£mero do embarque." WIDGET-ID 44
     i-id-etiq-fin AT ROW 2 COL 43.57 COLON-ALIGNED HELP
          "N£mero do embarque." NO-LABEL WIDGET-ID 42
     dt-implantacao-ini AT ROW 3 COL 14 COLON-ALIGNED HELP
          "Data da gera‡Æo da etiqueta" WIDGET-ID 40
     dt-implantacao-fin AT ROW 3 COL 43.57 COLON-ALIGNED HELP
          "Data da gera‡Æo da etiqueta" NO-LABEL WIDGET-ID 38
     btOK AT ROW 5.04 COL 3.86 WIDGET-ID 36
     btCancel AT ROW 5.04 COL 14.86 WIDGET-ID 34
     RECT-45 AT ROW 1.25 COL 2 WIDGET-ID 54
     IMAGE-13 AT ROW 3 COL 36.72 WIDGET-ID 46
     IMAGE-14 AT ROW 3 COL 42 WIDGET-ID 48
     rtToolBar AT ROW 4.79 COL 2.57 WIDGET-ID 56
     IMAGE-15 AT ROW 2 COL 36.72 WIDGET-ID 50
     IMAGE-16 AT ROW 2 COL 42 WIDGET-ID 52
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 8.5
         FONT 1 WIDGET-ID 100.


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
         TITLE              = "Sele‡Æo Etiqueta"
         HEIGHT             = 5.58
         WIDTH              = 73.57
         MAX-HEIGHT         = 16
         MAX-WIDTH          = 80
         VIRTUAL-HEIGHT     = 16
         VIRTUAL-WIDTH      = 80
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Sele‡Æo Etiqueta */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Sele‡Æo Etiqueta */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel C-Win
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancelar */
DO:
    ASSIGN pBtOk = NO.
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK C-Win
ON CHOOSE OF btOK IN FRAME fpage0 /* OK */
DO:
    ASSIGN pDtImplantacaoIni = DATE(dt-implantacao-ini:SCREEN-VALUE IN FRAME fPage0)
           pDtImplantacaoFin = DATE(dt-implantacao-fin:SCREEN-VALUE IN FRAME fPage0)
           pIdEtiqIni        = DEC(i-id-etiq-ini:SCREEN-VALUE   IN FRAME fPage0)
           pIdEtiqFin        = DEC(i-id-etiq-fin:SCREEN-VALUE   IN FRAME fPage0)
           pBtOk             = YES.

    APPLY "CLOSE":U TO THIS-PROCEDURE.
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
    
  RUN enable_UI.

  ASSIGN dt-implantacao-ini:SCREEN-VALUE IN FRAME fPage0 = STRING(pDtImplantacaoIni)
         dt-implantacao-fin:SCREEN-VALUE IN FRAME fPage0 = STRING(pDtImplantacaoFin)
         i-id-etiq-ini:SCREEN-VALUE    IN FRAME fPage0 = STRING(pIdEtiqIni)
         i-id-etiq-fin:SCREEN-VALUE    IN FRAME fPage0 = STRING(pIdEtiqFin).
         

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
  DISPLAY i-id-etiq-ini i-id-etiq-fin dt-implantacao-ini dt-implantacao-fin 
      WITH FRAME fpage0 IN WINDOW C-Win.
  ENABLE RECT-45 IMAGE-13 IMAGE-14 rtToolBar IMAGE-15 IMAGE-16 i-id-etiq-ini 
         i-id-etiq-fin dt-implantacao-ini dt-implantacao-fin btOK btCancel 
      WITH FRAME fpage0 IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-fpage0}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

