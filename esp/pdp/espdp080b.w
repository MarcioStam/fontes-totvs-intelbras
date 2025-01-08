&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
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
DEFINE INPUT PARAMETER p-item  AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER p-estab AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER p-depos AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER p-usuar AS CHARACTER NO-UNDO.

/*DEFINE VARIABLE  p-item  AS CHARACTER NO-UNDO.
DEFINE VARIABLE  p-estab AS CHARACTER NO-UNDO.
DEFINE VARIABLE  p-depos AS CHARACTER NO-UNDO.
DEFINE VARIABLE  p-usuar AS CHARACTER NO-UNDO.*/

/* Local Variable Definitions ---                                       */

{esp/pdp/espdp080tt.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fPage0
&Scoped-define BROWSE-NAME brHistoricoReservas

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-hist-reservas-ast

/* Definitions for BROWSE brHistoricoReservas                           */
&Scoped-define FIELDS-IN-QUERY-brHistoricoReservas tt-hist-reservas-ast.cod-estabel tt-hist-reservas-ast.it-codigo tt-hist-reservas-ast.cod-depos tt-hist-reservas-ast.cd-usuario tt-hist-reservas-ast.sequencia tt-hist-reservas-ast.dt-reserva tt-hist-reservas-ast.data-atualiza tt-hist-reservas-ast.cd-usuario-atualiza tt-hist-reservas-ast.qt-reserva-de tt-hist-reservas-ast.qt-reserva-para tt-hist-reservas-ast.data-limite-de tt-hist-reservas-ast.data-limite-para tt-hist-reservas-ast.tipo-acao   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brHistoricoReservas   
&Scoped-define SELF-NAME brHistoricoReservas
&Scoped-define QUERY-STRING-brHistoricoReservas FOR EACH tt-hist-reservas-ast BY tt-hist-reservas-ast.sequencia DESC
&Scoped-define OPEN-QUERY-brHistoricoReservas OPEN QUERY {&SELF-NAME} FOR EACH tt-hist-reservas-ast BY tt-hist-reservas-ast.sequencia DESC.
&Scoped-define TABLES-IN-QUERY-brHistoricoReservas tt-hist-reservas-ast
&Scoped-define FIRST-TABLE-IN-QUERY-brHistoricoReservas tt-hist-reservas-ast


/* Definitions for FRAME fPage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage0 ~
    ~{&OPEN-QUERY-brHistoricoReservas}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar IMAGE-3 IMAGE-4 IMAGE-5 IMAGE-6 ~
IMAGE-7 IMAGE-8 IMAGE-9 IMAGE-10 fi-estab-ini fi-estab-fim fi-item-ini ~
fi-item-fim fi-depos-ini fi-depos-fim fi-usuar-ini fi-usuar-fim btCheck ~
brHistoricoReservas btOK-2 btOK btLimpar 
&Scoped-Define DISPLAYED-OBJECTS fi-estab-ini fi-estab-fim fi-item-ini ~
fi-item-fim fi-depos-ini fi-depos-fim fi-usuar-ini fi-usuar-fim 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCheck 
     IMAGE-UP FILE "image/im-chck1.bmp":U
     LABEL "" 
     SIZE 5 BY 1.

DEFINE BUTTON btLimpar 
     LABEL "&Limpar filtros" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "&Fechar" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK-2 
     LABEL "&Fechar" 
     SIZE 10 BY 1.

DEFINE VARIABLE fi-depos-fim AS CHARACTER FORMAT "x(3)":U 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE fi-depos-ini AS CHARACTER FORMAT "x(3)":U 
     LABEL "Dep¢sito" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE fi-estab-fim AS CHARACTER FORMAT "x(3)":U 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE fi-estab-ini AS CHARACTER FORMAT "x(3)":U 
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE fi-item-fim AS CHARACTER FORMAT "x(7)":U 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE fi-item-ini AS CHARACTER FORMAT "x(7)":U 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE fi-usuar-fim AS CHARACTER FORMAT "x(12)":U 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE fi-usuar-ini AS CHARACTER FORMAT "x(12)":U 
     LABEL "Usu rio" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-10
     FILENAME "image/im-las.bmp":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-3
     FILENAME "image/im-fir.bmp":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-4
     FILENAME "image/im-las.bmp":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-5
     FILENAME "image/im-fir.bmp":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-6
     FILENAME "image/im-las.bmp":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-7
     FILENAME "image/im-fir.bmp":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-8
     FILENAME "image/im-las.bmp":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-9
     FILENAME "image/im-fir.bmp":U
     SIZE 3 BY .88.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brHistoricoReservas FOR 
      tt-hist-reservas-ast SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brHistoricoReservas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brHistoricoReservas C-Win _FREEFORM
  QUERY brHistoricoReservas DISPLAY
      tt-hist-reservas-ast.cod-estabel            WIDTH 6  COLUMN-LABEL "Estab"
      tt-hist-reservas-ast.it-codigo              WIDTH 10 COLUMN-LABEL "Item"
      tt-hist-reservas-ast.cod-depos              WIDTH 6  COLUMN-LABEL "Dep"
      tt-hist-reservas-ast.cd-usuario             WIDTH 12 COLUMN-LABEL "Usu rio" 
      tt-hist-reservas-ast.sequencia              WIDTH 4  COLUMN-LABEL "Seq"
      tt-hist-reservas-ast.dt-reserva             WIDTH 10 COLUMN-LABEL "Dt. Reserva"   FORMAT "99/99/9999"
      tt-hist-reservas-ast.data-atualiza          WIDTH 15 COLUMN-LABEL "Data"          FORMAT "99/99/9999 HH:MM:SS"
      tt-hist-reservas-ast.cd-usuario-atualiza    WIDTH 12 COLUMN-LABEL "Usu rio Alt."
      tt-hist-reservas-ast.qt-reserva-de          WIDTH 12 COLUMN-LABEL "Quantidade De"
      tt-hist-reservas-ast.qt-reserva-para        WIDTH 12 COLUMN-LABEL "Para"
      tt-hist-reservas-ast.data-limite-de         WIDTH 11 COLUMN-LABEL "Dt.Limite De"
      tt-hist-reservas-ast.data-limite-para       WIDTH 11 COLUMN-LABEL "Para"
      tt-hist-reservas-ast.tipo-acao              WIDTH 6  COLUMN-LABEL "A‡Æo"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 88.57 BY 13.54
         FONT 1
         TITLE "Hist¢rico das Reservas AST" FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fPage0
     fi-estab-ini AT ROW 1.25 COL 42.14 RIGHT-ALIGNED HELP
          "Descri‡Æo - Inicial" WIDGET-ID 30
     fi-estab-fim AT ROW 1.25 COL 56.43 HELP
          "Descri‡Æo - Final" NO-LABEL WIDGET-ID 28
     fi-item-ini AT ROW 2.21 COL 42.14 RIGHT-ALIGNED HELP
          "Descri‡Æo - Inicial" WIDGET-ID 34
     fi-item-fim AT ROW 2.21 COL 56.43 HELP
          "Descri‡Æo - Final" NO-LABEL WIDGET-ID 32
     fi-depos-ini AT ROW 3.17 COL 42.14 RIGHT-ALIGNED HELP
          "Descri‡Æo - Inicial" WIDGET-ID 38
     fi-depos-fim AT ROW 3.17 COL 56.43 HELP
          "Descri‡Æo - Final" NO-LABEL WIDGET-ID 36
     fi-usuar-ini AT ROW 4.13 COL 42.14 RIGHT-ALIGNED HELP
          "Descri‡Æo - Inicial" WIDGET-ID 42
     fi-usuar-fim AT ROW 4.13 COL 56.43 HELP
          "Descri‡Æo - Final" NO-LABEL WIDGET-ID 40
     btCheck AT ROW 4.13 COL 76.72 RIGHT-ALIGNED WIDGET-ID 44
     brHistoricoReservas AT ROW 5.5 COL 1.86 WIDGET-ID 200
     btOK-2 AT ROW 19.75 COL 2 WIDGET-ID 46
     btOK AT ROW 19.75 COL 2 WIDGET-ID 8
     btLimpar AT ROW 19.75 COL 80.43 WIDGET-ID 48
     rtToolBar AT ROW 19.54 COL 1 WIDGET-ID 10
     IMAGE-3 AT ROW 1.25 COL 43.57 WIDGET-ID 12
     IMAGE-4 AT ROW 1.25 COL 53.14 WIDGET-ID 14
     IMAGE-5 AT ROW 2.21 COL 43.57 WIDGET-ID 16
     IMAGE-6 AT ROW 2.21 COL 53.14 WIDGET-ID 18
     IMAGE-7 AT ROW 3.17 COL 43.57 WIDGET-ID 20
     IMAGE-8 AT ROW 3.17 COL 53.14 WIDGET-ID 22
     IMAGE-9 AT ROW 4.13 COL 43.57 WIDGET-ID 24
     IMAGE-10 AT ROW 4.13 COL 53.14 WIDGET-ID 26
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 20.29
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Hist¢rico de Altera‡äes"
         HEIGHT             = 20.25
         WIDTH              = 90
         MAX-HEIGHT         = 20.71
         MAX-WIDTH          = 91
         VIRTUAL-HEIGHT     = 20.71
         VIRTUAL-WIDTH      = 91
         MAX-BUTTON         = no
         RESIZE             = no
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
/* SETTINGS FOR FRAME fPage0
   FRAME-NAME                                                           */
/* BROWSE-TAB brHistoricoReservas btCheck fPage0 */
ASSIGN 
       brHistoricoReservas:COLUMN-RESIZABLE IN FRAME fPage0       = TRUE.

/* SETTINGS FOR BUTTON btCheck IN FRAME fPage0
   ALIGN-R                                                              */
/* SETTINGS FOR FILL-IN fi-depos-fim IN FRAME fPage0
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fi-depos-ini IN FRAME fPage0
   ALIGN-R                                                              */
/* SETTINGS FOR FILL-IN fi-estab-fim IN FRAME fPage0
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fi-estab-ini IN FRAME fPage0
   ALIGN-R                                                              */
/* SETTINGS FOR FILL-IN fi-item-fim IN FRAME fPage0
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fi-item-ini IN FRAME fPage0
   ALIGN-R                                                              */
/* SETTINGS FOR FILL-IN fi-usuar-fim IN FRAME fPage0
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fi-usuar-ini IN FRAME fPage0
   ALIGN-R                                                              */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brHistoricoReservas
/* Query rebuild information for BROWSE brHistoricoReservas
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-hist-reservas-ast BY tt-hist-reservas-ast.sequencia DESC.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE brHistoricoReservas */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Hist¢rico de Altera‡äes */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Hist¢rico de Altera‡äes */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCheck
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCheck C-Win
ON CHOOSE OF btCheck IN FRAME fPage0
DO:
    RUN piBuscaHistorico.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btLimpar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btLimpar C-Win
ON CHOOSE OF btLimpar IN FRAME fPage0 /* Limpar filtros */
DO:
    RUN piLimpaFiltros.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK C-Win
ON CHOOSE OF btOK IN FRAME fPage0 /* Fechar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK-2 C-Win
ON CHOOSE OF btOK-2 IN FRAME fPage0 /* Fechar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brHistoricoReservas
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
    RUN initializeObject.
    IF  NOT THIS-PROCEDURE:PERSISTENT THEN
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
  DISPLAY fi-estab-ini fi-estab-fim fi-item-ini fi-item-fim fi-depos-ini 
          fi-depos-fim fi-usuar-ini fi-usuar-fim 
      WITH FRAME fPage0 IN WINDOW C-Win.
  ENABLE rtToolBar IMAGE-3 IMAGE-4 IMAGE-5 IMAGE-6 IMAGE-7 IMAGE-8 IMAGE-9 
         IMAGE-10 fi-estab-ini fi-estab-fim fi-item-ini fi-item-fim 
         fi-depos-ini fi-depos-fim fi-usuar-ini fi-usuar-fim btCheck 
         brHistoricoReservas btOK-2 btOK btLimpar 
      WITH FRAME fPage0 IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-fPage0}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject C-Win 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose: Carlos Daniel - 14/07/2016    
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME fPage0:
    ASSIGN fi-estab-ini:SCREEN-VALUE = p-estab
           fi-estab-fim:SCREEN-VALUE = p-estab
           fi-item-ini :SCREEN-VALUE = p-item
           fi-item-fim :SCREEN-VALUE = p-item
           fi-depos-ini:SCREEN-VALUE = p-depos
           fi-depos-fim:SCREEN-VALUE = p-depos
           fi-usuar-ini:SCREEN-VALUE = p-usuar
           fi-usuar-fim:SCREEN-VALUE = p-usuar.
END.

RUN piBuscaHistorico.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piBuscaHistorico C-Win 
PROCEDURE piBuscaHistorico :
/*------------------------------------------------------------------------------
  Purpose:     
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE h-espdp080api AS HANDLE NO-UNDO.

RUN esp/pdp/espdp080api.p PERSISTENT SET h-espdp080api.
DO WITH FRAME fPage0:
    RUN piBuscaHist¢rico IN h-espdp080api (INPUT fi-item-ini:SCREEN-VALUE,
                                           INPUT fi-item-fim:SCREEN-VALUE,
                                           INPUT fi-estab-ini:SCREEN-VALUE,
                                           INPUT fi-estab-fim:SCREEN-VALUE,
                                           INPUT fi-depos-ini:SCREEN-VALUE,
                                           INPUT fi-depos-fim:SCREEN-VALUE,
                                           INPUT fi-usuar-ini:SCREEN-VALUE,
                                           INPUT fi-usuar-fim:SCREEN-VALUE,
                                           OUTPUT TABLE tt-hist-reservas-ast).
END.

IF VALID-HANDLE(h-espdp080api) THEN
    DELETE PROCEDURE h-espdp080api.

{&OPEN-QUERY-BRHISTORICORESERVAS}

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piLimpaFiltros C-Win 
PROCEDURE piLimpaFiltros :
/*------------------------------------------------------------------------------
  Purpose:     
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME fPage0:
    ASSIGN fi-estab-ini:SCREEN-VALUE = ""
           fi-estab-fim:SCREEN-VALUE = "ZZZ"
           fi-item-ini :SCREEN-VALUE = ""
           fi-item-fim :SCREEN-VALUE = "ZZZZZZZ"
           fi-depos-ini:SCREEN-VALUE = ""
           fi-depos-fim:SCREEN-VALUE = "ZZZ"
           fi-usuar-ini:SCREEN-VALUE = ""
           fi-usuar-fim:SCREEN-VALUE = "ZZZZZZZZZZZZ".
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

