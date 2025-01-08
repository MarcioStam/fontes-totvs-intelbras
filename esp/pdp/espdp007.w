&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcad           PROGRESS
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define BROWSE-NAME brnotaspedido

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES nota-fiscal

/* Definitions for BROWSE brnotaspedido                                 */
&Scoped-define FIELDS-IN-QUERY-brnotaspedido nota-fiscal.nome-abrev nota-fiscal.serie nota-fiscal.nr-nota-fis nota-fiscal.nat-operacao nota-fiscal.dt-emis-nota    
&Scoped-define ENABLED-FIELDS-IN-QUERY-brnotaspedido   
&Scoped-define SELF-NAME brnotaspedido
&Scoped-define QUERY-STRING-brnotaspedido FOR EACH nota-fiscal NO-LOCK USE-INDEX ch-pedido WHERE nota-fiscal.nome-ab-cli = c-nome-abrev AND nota-fiscal.nr-pedcli = c-pedcli  AND  nota-fiscal.dt-cancela = ?
&Scoped-define OPEN-QUERY-brnotaspedido OPEN QUERY {&SELF-NAME} FOR EACH nota-fiscal NO-LOCK  USE-INDEX ch-pedido  WHERE nota-fiscal.nome-ab-cli = c-nome-abrev AND nota-fiscal.nr-pedcli = c-pedcli  AND  nota-fiscal.dt-cancela = ?.
&Scoped-define TABLES-IN-QUERY-brnotaspedido nota-fiscal
&Scoped-define FIRST-TABLE-IN-QUERY-brnotaspedido nota-fiscal


/* Definitions for FRAME DEFAULT-FRAME                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME ~
    ~{&OPEN-QUERY-brnotaspedido}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS c-pedcli c-nome-abrev brnotaspedido 
&Scoped-Define DISPLAYED-OBJECTS c-pedcli 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Define global share */

DEF NEW GLOBAL SHARED VAR gr-ped-venda      AS ROWID         NO-UNDO.


/* Definitions of the field level widgets                               */
DEFINE VARIABLE c-pedcli AS CHARACTER FORMAT "X(12)":U INITIAL ""
     LABEL "Nr Pedido Cliente" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-abrev AS CHARACTER FORMAT "X(12)":U INITIAL ""
     LABEL "Nome Abrev" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

/* posiciona pedidos */
FIND first ped-venda no-lock
    where rowid(ped-venda) = gr-ped-venda NO-ERROR.

IF AVAIL ped-venda THEN 
    ASSIGN c-pedcli = ped-venda.nr-pedcli
           c-nome-abrev = ped-venda.nome-abrev.


/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brnotaspedido FOR 
      nota-fiscal SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brnotaspedido
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brnotaspedido C-Win _FREEFORM
  QUERY brnotaspedido NO-LOCK DISPLAY   
      nota-fiscal.cod-emitente FORMAT ">>>>>>>>9":U 
      nota-fiscal.nome-ab-cli FORMAT "x(12)":U
      nota-fiscal.serie FORMAT "x(5)":U
      nota-fiscal.nr-nota-fis FORMAT "x(7)":U
      nota-fiscal.nat-operacao FORMAT "x(6)":U
      nota-fiscal.dt-emis-nota FORMAT "99/99/9999"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 73 BY 5.25 EXPANDABLE.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     c-pedcli AT ROW 1.5 COL 31 COLON-ALIGNED 
     c-nome-abrev AT ROW 2.5 COL 31 COLON-ALIGNED
     brnotaspedido AT ROW 3.54 COL 1.29
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 73.57 BY 8.96.


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
         TITLE              = "ESPDP007 - Consulta Nota Fiscai do Pedido"
         HEIGHT             = 8.96
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
/* SETTINGS FOR FRAME DEFAULT-FRAME
                                                                        */
/* BROWSE-TAB brnotaspedido c-nr-nota-fis DEFAULT-FRAME */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brnotaspedido
/* Query rebuild information for BROWSE brnotaspedido
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH nota-fiscal NO-LOCK
    WHERE nota-fiscal.serie-nf    = c-serie
    AND   nota-fiscal.nr-nota-fis = c-nr-nota-fis.
     _END_FREEFORM
     _Options          = "NO-LOCK"
     _Query            is OPENED
*/  /* BROWSE brnotaspedido */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Consulta Conhecimento da Nota */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Consulta Conhecimento da Nota */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-nr-nota-fis
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-pedcli C-Win
ON RETURN OF c-pedcli IN FRAME DEFAULT-FRAME /* Nota Fiscal */
DO:
    ASSIGN INPUT FRAME {&FRAME-NAME} c-pedcli.

    FIND FIRST ped-venda no-lock
         WHERE ped-venda.nr-pedcli = c-pedcli NO-ERROR.

    IF AVAIL ped-venda THEN DO:
        ASSIGN c-pedcli = ped-venda.nr-pedcli
               c-nome-abrev = ped-venda.nome-abrev.
        DISP c-nome-abrev WITH FRAME DEFAULT-FRAME.
    END.

    {&OPEN-QUERY-brnotaspedido}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brnotaspedido
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
  DISPLAY c-pedcli c-nome-abrev
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE c-pedcli brnotaspedido 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

