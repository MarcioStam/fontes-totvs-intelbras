&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME C-Win

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttabastecedor NO-UNDO LIKE abastecedor
       field r-rowid as rowid.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
{include/i-prgvrs.i ESCEP007 2.04.00.000}

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
/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESCEP007
&GLOBAL-DEFINE Version        1

&GLOBAL-DEFINE WindowType     Master/Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    0
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btOK btCancel btHelp2
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

&GLOBAL-DEFINE ttTable        ttabastecedor
&GLOBAL-DEFINE hDBOTable      boabastecedor
&GLOBAL-DEFINE DBOTable       abastecedor

/* Parameters Definitions ---                                           */
DEF INPUT PARAM p-main AS HANDLE NO-UNDO.
DEF INPUT PARAM p-bo AS HANDLE NO-UNDO.
/* Local Variable Definitions ---                                       */

DEFINE VARIABLE wh-pesquisa AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
DEF VAR l-implanta AS LOGICAL NO-UNDO.
{method/dbotterr.i}
{upc\btb910za-upc.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ttabastecedor

/* Definitions for FRAME DEFAULT-FRAME                                  */
&Scoped-define FIELDS-IN-QUERY-DEFAULT-FRAME ttabastecedor.nome ~
ttabastecedor.cod-depos 
&Scoped-define ENABLED-FIELDS-IN-QUERY-DEFAULT-FRAME ttabastecedor.nome ~
ttabastecedor.cod-depos 
&Scoped-define ENABLED-TABLES-IN-QUERY-DEFAULT-FRAME ttabastecedor
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-DEFAULT-FRAME ttabastecedor
&Scoped-define QUERY-STRING-DEFAULT-FRAME FOR EACH ttabastecedor SHARE-LOCK
&Scoped-define OPEN-QUERY-DEFAULT-FRAME OPEN QUERY DEFAULT-FRAME FOR EACH ttabastecedor SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-DEFAULT-FRAME ttabastecedor
&Scoped-define FIRST-TABLE-IN-QUERY-DEFAULT-FRAME ttabastecedor


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ttabastecedor.nome ttabastecedor.cod-depos 
&Scoped-define ENABLED-TABLES ttabastecedor
&Scoped-define FIRST-ENABLED-TABLE ttabastecedor
&Scoped-Define ENABLED-OBJECTS btOK btSave btCancel btHelp rtKeys rtToolBar 
&Scoped-Define DISPLAYED-FIELDS ttabastecedor.nome ttabastecedor.cod-depos 
&Scoped-define DISPLAYED-TABLES ttabastecedor
&Scoped-define FIRST-DISPLAYED-TABLE ttabastecedor
&Scoped-Define DISPLAYED-OBJECTS fi-nome 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE BUTTON btSave 
     LABEL "Salvar" 
     SIZE 10 BY 1.

DEFINE VARIABLE fi-nome AS CHARACTER FORMAT "x(40)" 
     VIEW-AS FILL-IN 
     SIZE 41 BY .88 NO-UNDO.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 80 BY 2.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 80 BY 1.42
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY DEFAULT-FRAME FOR 
      ttabastecedor SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     ttabastecedor.nome AT ROW 1.17 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11.86 BY .79
     ttabastecedor.cod-depos AT ROW 2.17 COL 20 COLON-ALIGNED
          LABEL "Dep¢sito"
          VIEW-AS FILL-IN 
          SIZE 4 BY .88
     fi-nome AT ROW 2.17 COL 24.57 COLON-ALIGNED HELP
          "Descri‡Æo do Dep¢sito" NO-LABEL NO-TAB-STOP 
     btOK AT ROW 3.5 COL 2
     btSave AT ROW 3.5 COL 13
     btCancel AT ROW 3.5 COL 24
     btHelp AT ROW 3.5 COL 70.29
     rtKeys AT ROW 1 COL 1
     rtToolBar AT ROW 3.25 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 3.88
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: ttabastecedor T "?" NO-UNDO mgesp abastecedor
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "<insert window title>"
         HEIGHT             = 3.79
         WIDTH              = 80
         MAX-HEIGHT         = 16
         MAX-WIDTH          = 80
         VIRTUAL-HEIGHT     = 16
         VIRTUAL-WIDTH      = 80
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = yes
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
/* SETTINGS FOR FRAME DEFAULT-FRAME
                                                                        */
/* SETTINGS FOR FILL-IN ttabastecedor.cod-depos IN FRAME DEFAULT-FRAME
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN fi-nome IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME DEFAULT-FRAME
/* Query rebuild information for FRAME DEFAULT-FRAME
     _TblList          = "Temp-Tables.ttabastecedor"
     _Query            is OPENED
*/  /* FRAME DEFAULT-FRAME */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* <insert window title> */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* <insert window title> */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel C-Win
ON CHOOSE OF btCancel IN FRAME DEFAULT-FRAME /* Cancelar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp C-Win
ON CHOOSE OF btHelp IN FRAME DEFAULT-FRAME /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK C-Win
ON CHOOSE OF btOK IN FRAME DEFAULT-FRAME /* OK */
DO:
    RUN saveRecord IN THIS-PROCEDURE.
    IF RETURN-VALUE = "OK":U THEN
        APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave C-Win
ON CHOOSE OF btSave IN FRAME DEFAULT-FRAME /* Salvar */
DO:
    RUN saveRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttabastecedor.cod-depos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttabastecedor.cod-depos C-Win
ON LEAVE OF ttabastecedor.cod-depos IN FRAME DEFAULT-FRAME /* Dep¢sito */
DO:
  {include/leave.i &tabela=deposito
                   &atributo-ref=nome
                   &variavel-ref=fi-nome
                   &where="deposito.cod-dep = ttabastecedor.cod-depos:screen-value in frame {&frame-name}"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttabastecedor.cod-depos C-Win
ON MOUSE-SELECT-DBLCLICK OF ttabastecedor.cod-depos IN FRAME DEFAULT-FRAME /* Dep¢sito */
OR F5 OF ttabastecedor.cod-depos IN FRAME {&frame-name} DO:
    {include/zoomvar.i &prog-zoom="inzoom/z02in084"
                       &campo="ttabastecedor.cod-depos"
                       &campozoom="cod-depos"
                       &frame="{&frame-name}"
                       &campo2="fi-nome"
                       &campozoom2="nome"
                       &frame2="{&frame-name}"}

  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */
ttabastecedor.cod-depos:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME {&frame-name}.
FOR FIRST prog_dtsul FIELDS (nom_prog_dtsul_menu) NO-LOCK
    WHERE prog_dtsul.cod_prog_dtsul = "{&Program}":
    ASSIGN C-Win:TITLE = SUBSTITUTE("&1 - &2 - &3",
                                             trim(prog_dtsul.nom_prog_dtsul_menu),
                                             "ESCEP007A", "{&Version}").
END.
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

  {&OPEN-QUERY-DEFAULT-FRAME}
  GET FIRST DEFAULT-FRAME.
  DISPLAY fi-nome 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  IF AVAILABLE ttabastecedor THEN 
    DISPLAY ttabastecedor.nome ttabastecedor.cod-depos 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE ttabastecedor.nome ttabastecedor.cod-depos btOK btSave btCancel btHelp 
         rtKeys rtToolBar 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveRecord C-Win 
PROCEDURE saveRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR hShowMsg AS HANDLE NO-UNDO.
DEF VAR r-rowid AS ROWID NO-UNDO.

EMPTY TEMP-TABLE ttabastecedor.
CREATE ttabastecedor.
ASSIGN ttabastecedor.cod-estabel = v_cod_estab_usuar
       ttabastecedor.nome      = INPUT FRAME {&FRAME-NAME} ttabastecedor.nome     
       ttabastecedor.cod-depos = INPUT FRAME {&FRAME-NAME} ttabastecedor.cod-depos.

RUN emptyRowErrors IN p-bo NO-ERROR.        
RUN setrecord IN p-bo (INPUT TABLE ttabastecedor).  
RUN validaterecord IN p-bo (INPUT "create").     
RUN getrowerrors IN p-bo (OUTPUT TABLE rowerrors).
IF CAN-FIND(FIRST RowErrors WHERE RowErrors.errortype = "error") THEN DO:
    {method/ShowMessage.i1}.
    {method/ShowMessage.i2 &Modal="YES"}.
    {method/ShowMessage.i3}.
    RETURN "NOK".
END.
RUN createrecord IN p-bo.                        

IF VALID-HANDLE(p-main) THEN do:
    RUN goToKey IN p-bo (INPUT ttabastecedor.cod-estabel,
                         INPUT ttabastecedor.nome,
                         INPUT ttabastecedor.cod-depos).
    RUN getRowid IN p-bo (OUTPUT r-rowid).
    RUN insertNewRow IN p-main (INPUT r-rowid).
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

