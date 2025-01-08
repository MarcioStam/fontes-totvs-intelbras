&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
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

define temp-table ttDatabase no-undo
   field db as character
   index ch is primary unique db.

{esp/aud/esaud001tt.i}

define temp-table ttFiltrada no-undo like ttAuditEvent.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fPage0
&Scoped-define BROWSE-NAME brAuditEvent

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ttFiltrada

/* Definitions for BROWSE brAuditEvent                                  */
&Scoped-define FIELDS-IN-QUERY-brAuditEvent ttFiltrada.banco ttFiltrada.tabela ttFiltrada.pk ttFiltrada.campo ttFiltrada.data ttFiltrada.usuario ttFiltrada.evento   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brAuditEvent   
&Scoped-define SELF-NAME brAuditEvent
&Scoped-define QUERY-STRING-brAuditEvent FOR EACH ttFiltrada.  assign fiDetailField:screen-value in frame fDetail = ""        fiDetailOld:screen-value in frame fDetail = ""        fiDetailNew:screen-value in frame fDetail = ""        edPK:screen-value in frame fResult = ""
&Scoped-define OPEN-QUERY-brAuditEvent OPEN QUERY {&SELF-NAME} FOR EACH ttFiltrada.  assign fiDetailField:screen-value in frame fDetail = ""        fiDetailOld:screen-value in frame fDetail = ""        fiDetailNew:screen-value in frame fDetail = ""        edPK:screen-value in frame fResult = "".
&Scoped-define TABLES-IN-QUERY-brAuditEvent ttFiltrada
&Scoped-define FIRST-TABLE-IN-QUERY-brAuditEvent ttFiltrada


/* Definitions for FRAME fResult                                        */

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE VARIABLE cbDatabase AS CHARACTER FORMAT "X(256)":U 
     LABEL "Database" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 28 BY 1
     FONT 1 NO-UNDO.

DEFINE VARIABLE fiDetailField AS CHARACTER FORMAT "X(256)":U 
     LABEL "Campo" 
     VIEW-AS FILL-IN 
     SIZE 30 BY 1
     FONT 1 NO-UNDO.

DEFINE VARIABLE fiDetailNew AS CHARACTER FORMAT "X(256)":U 
     LABEL "Vl. Novo" 
     VIEW-AS FILL-IN 
     SIZE 127 BY 3.08
     FONT 1 NO-UNDO.

DEFINE VARIABLE fiDetailOld AS CHARACTER FORMAT "X(256)":U 
     LABEL "Vl. Antigo" 
     VIEW-AS FILL-IN 
     SIZE 127 BY 2.88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fiDetailType AS CHARACTER FORMAT "X(256)":U 
     LABEL "Tipo" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1
     FONT 1 NO-UNDO.

DEFINE VARIABLE cbFilterDatabase AS CHARACTER FORMAT "X(256)":U 
     LABEL "Database" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE cbFilterEvent AS CHARACTER FORMAT "X(256)":U 
     LABEL "Evento" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 15 BY 1
     FONT 1 NO-UNDO.

DEFINE VARIABLE cbFilterField AS CHARACTER FORMAT "X(256)":U 
     LABEL "Campo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 26.43 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE cbFilterTable AS CHARACTER FORMAT "X(256)":U 
     LABEL "Tabela" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 31 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE cbFilterUser AS CHARACTER FORMAT "X(256)":U 
     LABEL "Usu rio" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 20 BY 1
     FONT 1 NO-UNDO.

DEFINE VARIABLE fiFilterPK AS CHARACTER FORMAT "X(256)":U 
     LABEL "Chave prim ria" 
     VIEW-AS FILL-IN 
     SIZE 22 BY 1
     FONT 1 NO-UNDO.

DEFINE VARIABLE edPK AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 25 BY 8.33
     FONT 1 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brAuditEvent FOR 
      ttFiltrada SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brAuditEvent
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brAuditEvent wWindow _FREEFORM
  QUERY brAuditEvent DISPLAY
      ttFiltrada.banco   
   ttFiltrada.tabela
   ttFiltrada.pk
   ttFiltrada.campo
   ttFiltrada.data
   ttFiltrada.usuario
   ttFiltrada.evento
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 110 BY 8.33
         FONT 1 ROW-HEIGHT-CHARS .57 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fPage0
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 137.57 BY 22.79
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fFilter
     cbFilterDatabase AT ROW 1.25 COL 7 COLON-ALIGNED WIDGET-ID 18
     cbFilterTable AT ROW 1.25 COL 33 COLON-ALIGNED WIDGET-ID 6
     cbFilterUser AT ROW 1.25 COL 71 COLON-ALIGNED WIDGET-ID 10
     cbFilterField AT ROW 2.25 COL 7 COLON-ALIGNED WIDGET-ID 16
     cbFilterEvent AT ROW 2.25 COL 37.28 WIDGET-ID 8
     fiFilterPK AT ROW 2.25 COL 69 COLON-ALIGNED WIDGET-ID 14
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 45 ROW 1.25
         SIZE 93 BY 3.25
         FONT 1
         TITLE "Filtros" WIDGET-ID 600.

DEFINE FRAME fDatabase
     cbDatabase AT ROW 1.75 COL 4.57 WIDGET-ID 4
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2 ROW 1.25
         SIZE 42 BY 3.25
         FONT 1
         TITLE "Banco de dados origem" WIDGET-ID 700.

DEFINE FRAME fResult
     brAuditEvent AT ROW 1 COL 1 WIDGET-ID 300
     edPK AT ROW 1 COL 111 NO-LABEL WIDGET-ID 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2 ROW 4.75
         SIZE 136 BY 9.5
         FONT 1
         TITLE "Resultado" WIDGET-ID 800.

DEFINE FRAME fDetail
     fiDetailField AT ROW 1.25 COL 7 COLON-ALIGNED WIDGET-ID 4
     fiDetailType AT ROW 1.25 COL 44 COLON-ALIGNED WIDGET-ID 10
     fiDetailOld AT ROW 2.5 COL 7 COLON-ALIGNED WIDGET-ID 6
     fiDetailNew AT ROW 5.5 COL 7 COLON-ALIGNED WIDGET-ID 8
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2 ROW 14.5
         SIZE 136 BY 9.04
         FONT 1
         TITLE "Detalhes" WIDGET-ID 900.


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
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = "Audit Query"
         HEIGHT             = 22.79
         WIDTH              = 137.57
         MAX-HEIGHT         = 31.5
         MAX-WIDTH          = 170
         VIRTUAL-HEIGHT     = 31.5
         VIRTUAL-WIDTH      = 170
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
/* SETTINGS FOR WINDOW wWindow
  VISIBLE,,RUN-PERSISTENT                                               */
/* REPARENT FRAME */
ASSIGN FRAME fDatabase:FRAME = FRAME fPage0:HANDLE
       FRAME fDetail:FRAME = FRAME fPage0:HANDLE
       FRAME fFilter:FRAME = FRAME fPage0:HANDLE
       FRAME fResult:FRAME = FRAME fPage0:HANDLE.

/* SETTINGS FOR FRAME fDatabase
                                                                        */
/* SETTINGS FOR COMBO-BOX cbDatabase IN FRAME fDatabase
   ALIGN-L                                                              */
/* SETTINGS FOR FRAME fDetail
                                                                        */
/* SETTINGS FOR FRAME fFilter
                                                                        */
/* SETTINGS FOR COMBO-BOX cbFilterEvent IN FRAME fFilter
   ALIGN-L                                                              */
/* SETTINGS FOR FRAME fPage0
   FRAME-NAME                                                           */

DEFINE VARIABLE XXTABVALXX AS LOGICAL NO-UNDO.

ASSIGN XXTABVALXX = FRAME fResult:MOVE-BEFORE-TAB-ITEM (FRAME fDetail:HANDLE)
       XXTABVALXX = FRAME fFilter:MOVE-BEFORE-TAB-ITEM (FRAME fResult:HANDLE)
       XXTABVALXX = FRAME fDatabase:MOVE-BEFORE-TAB-ITEM (FRAME fFilter:HANDLE)
/* END-ASSIGN-TABS */.

/* SETTINGS FOR FRAME fResult
                                                                        */
/* BROWSE-TAB brAuditEvent 1 fResult */
ASSIGN 
       edPK:READ-ONLY IN FRAME fResult        = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brAuditEvent
/* Query rebuild information for BROWSE brAuditEvent
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH ttFiltrada.

assign fiDetailField:screen-value in frame fDetail = ""
       fiDetailOld:screen-value in frame fDetail = ""
       fiDetailNew:screen-value in frame fDetail = ""
       edPK:screen-value in frame fResult = "".
     _END_FREEFORM
     _Query            is NOT OPENED
*/  /* BROWSE brAuditEvent */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON END-ERROR OF wWindow /* Audit Query */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-CLOSE OF wWindow /* Audit Query */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brAuditEvent
&Scoped-define FRAME-NAME fResult
&Scoped-define SELF-NAME brAuditEvent
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brAuditEvent wWindow
ON VALUE-CHANGED OF brAuditEvent IN FRAME fResult
DO:
   define variable i as integer no-undo.
   define variable c as character no-undo.

   assign fiDetailField:screen-value in frame fDetail = ttFiltrada.campo
          fiDetailType:screen-value in frame fDetail = ttFiltrada.tipo
          fiDetailOld:screen-value in frame fDetail = ttFiltrada.antigo
          fiDetailNew:screen-value in frame fDetail = ttFiltrada.novo
          edPK:screen-value in frame fResult = "".

   run esp/aud/esaud001b.p (input ttFiltrada.banco,
                            input ttFiltrada.tabela,
                            input ttFiltrada.pk,
                            output c).

   edPK:screen-value in frame fResult = c.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fDatabase
&Scoped-define SELF-NAME cbDatabase
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cbDatabase wWindow
ON VALUE-CHANGED OF cbDatabase IN FRAME fDatabase /* Database */
DO:
   run loadTtAuditEvent (input self:input-value).
   {&open-query-brAuditEvent}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fFilter
&Scoped-define SELF-NAME cbFilterDatabase
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cbFilterDatabase wWindow
ON VALUE-CHANGED OF cbFilterDatabase IN FRAME fFilter /* Database */
DO:
   cbFilterTable:list-items in frame fFilter = "".
   for each ttTabela no-lock
      where ttTabela.banco = cbFilterDatabase:screen-value in frame fFilter:
      cbFilterTable:add-last(ttTabela.tabela) in frame fFilter.
   end.

   run openQueryAuditEvent.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cbFilterEvent
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cbFilterEvent wWindow
ON VALUE-CHANGED OF cbFilterEvent IN FRAME fFilter /* Evento */
DO:
   run openQueryAuditEvent.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cbFilterField
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cbFilterField wWindow
ON VALUE-CHANGED OF cbFilterField IN FRAME fFilter /* Campo */
DO:
   run openQueryAuditEvent.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cbFilterTable
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cbFilterTable wWindow
ON VALUE-CHANGED OF cbFilterTable IN FRAME fFilter /* Tabela */
DO:
   cbFilterField:list-items in frame fFilter = "".
   for each ttTabelaCampo no-lock
      where ttTabelaCampo.tabela = cbFilterTable:screen-value in frame fFilter:
      cbFilterField:add-last(ttTabelaCampo.campo) in frame fFilter.
   end.
  
   run openQueryAuditEvent.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cbFilterUser
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cbFilterUser wWindow
ON VALUE-CHANGED OF cbFilterUser IN FRAME fFilter /* Usu rio */
DO:
   run openQueryAuditEvent.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiFilterPK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiFilterPK wWindow
ON LEAVE OF fiFilterPK IN FRAME fFilter /* Chave prim ria */
DO:
   run openQueryAuditEvent.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiFilterPK wWindow
ON RETURN OF fiFilterPK IN FRAME fFilter /* Chave prim ria */
DO:
   run openQueryAuditEvent.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


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

run loadTtDatabase in this-procedure.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI wWindow  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
  THEN DELETE WIDGET wWindow.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI wWindow  _DEFAULT-ENABLE
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
  VIEW FRAME fPage0 IN WINDOW wWindow.
  {&OPEN-BROWSERS-IN-QUERY-fPage0}
  DISPLAY cbDatabase 
      WITH FRAME fDatabase IN WINDOW wWindow.
  ENABLE cbDatabase 
      WITH FRAME fDatabase IN WINDOW wWindow.
  {&OPEN-BROWSERS-IN-QUERY-fDatabase}
  DISPLAY cbFilterDatabase cbFilterTable cbFilterUser cbFilterField 
          cbFilterEvent fiFilterPK 
      WITH FRAME fFilter IN WINDOW wWindow.
  ENABLE cbFilterDatabase cbFilterTable cbFilterUser cbFilterField 
         cbFilterEvent fiFilterPK 
      WITH FRAME fFilter IN WINDOW wWindow.
  {&OPEN-BROWSERS-IN-QUERY-fFilter}
  DISPLAY edPK 
      WITH FRAME fResult IN WINDOW wWindow.
  ENABLE brAuditEvent edPK 
      WITH FRAME fResult IN WINDOW wWindow.
  {&OPEN-BROWSERS-IN-QUERY-fResult}
  DISPLAY fiDetailField fiDetailType fiDetailOld fiDetailNew 
      WITH FRAME fDetail IN WINDOW wWindow.
  ENABLE fiDetailField fiDetailType fiDetailOld fiDetailNew 
      WITH FRAME fDetail IN WINDOW wWindow.
  {&OPEN-BROWSERS-IN-QUERY-fDetail}
  VIEW wWindow.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadTtAuditEvent wWindow 
PROCEDURE loadTtAuditEvent :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   define input parameter pDatabase as character no-undo.

   define variable i as integer no-undo.
   define variable j as integer no-undo.
   define variable c as character no-undo.

   run esp/aud/esaud001a.p (input pDatabase,
                            output table ttAuditEvent,
                            output table ttBanco,
                            output table ttTabela,
                            output table ttTabelaCampo,
                            output table ttEvento,
                            output table ttUsuario).

   cbFilterDatabase:list-items in frame fFilter = "".
   cbFilterDatabase:add-last("") in frame fFilter.
   for each ttBanco no-lock:
      cbFilterDatabase:add-last(ttBanco.banco) in frame fFilter.
   end.

   cbFilterTable:list-items in frame fFilter = "".

   cbFilterField:list-items in frame fFilter = "".

   cbFilterEvent:list-items in frame fFilter = "".
   cbFilterEvent:add-last("") in frame fFilter.
   for each ttEvento no-lock:
      cbFilterEvent:add-last(ttEvento.evento) in frame fFilter.
   end.

   cbFilterUser:list-items in frame fFilter = "".
   cbFilterUser:add-last("") in frame fFilter.
   for each ttUsuario no-lock:
      cbFilterUser:add-last(ttUsuario.usuario) in frame fFilter.
   end.

   assign fiDetailField:screen-value in frame fDetail = ""
          fiDetailType:screen-value in frame fDetail = ""
          fiDetailOld:screen-value in frame fDetail = ""
          fiDetailNew:screen-value in frame fDetail = ""

          edPK:screen-value in frame fResult = "".

   for each ttAuditEvent:
      create ttFiltrada.
      buffer-copy ttAuditEvent to ttFiltrada.
   end.

   {&open-query-brAuditEvent}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadTtDatabase wWindow 
PROCEDURE loadTtDatabase :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   define variable i as integer no-undo.
   define variable h as handle  no-undo.

   do i = 1 to num-dbs:
      create buffer h for table ldbname(i) + '._aud-audit-data' no-error.
      if valid-handle(h) and h:can-read then do:
         create ttDatabase.
         assign ttDatabase.db = ldbname(i).
      end.
      if valid-handle(h) then
         delete object h.
   end.

   cbDatabase:list-items in frame fDatabase = "".
   for each ttDatabase no-lock:
      cbDatabase:add-last(ttDatabase.db) in frame fDatabase.
   end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryAuditEvent wWindow 
PROCEDURE openQueryAuditEvent :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   define variable q as handle no-undo.
   define variable c as character no-undo init ''.
   
   create query q.
   
   q:set-buffers(buffer ttAuditEvent:handle).
   
   if cbFilterDatabase:screen-value in frame fFilter <> ? then
      assign c = c + "and ttAuditEvent.banco = '" + cbFilterDatabase:screen-value in frame fFilter + "' ".
   if cbFilterTable:screen-value in frame fFilter <> ? then
      assign c = c + "and ttAuditEvent.tabela = '" + cbFilterTable:screen-value in frame fFilter + "' ".
   if cbFilterField:screen-value in frame fFilter <> ? then
      assign c = c + "and ttAuditEvent.campo = '" + cbFilterField:screen-value in frame fFilter + "' ".
   if cbFilterUser:screen-value in frame fFilter <> ? then
      assign c = c + "and ttAuditEvent.usuario = '" + cbFilterUser:screen-value in frame fFilter + "' ".
   if cbFilterEvent:screen-value in frame fFilter <> ? then
      assign c = c + "and ttAuditEvent.evento = '" + cbFilterEvent:screen-value in frame fFilter + "' ".
   if fiFilterPK:screen-value in frame fFilter <> '' then
      assign c = c + "and ttAuditEvent.pk matches '" + fiFilterPK:screen-value in frame fFilter + "' ".

   if (q:query-prepare("preselect each ttAuditEvent no-lock where 1 = 1 " + c) = false) then
      message 1 view-as alert-box.
   else
      q:query-open.

   empty temp-table ttFiltrada.

   if q:num-results <> 0 then do:
      repeat:
         q:get-next().
         if q:query-off-end then
            leave.

         create ttFiltrada.
         buffer-copy ttAuditEvent to ttFiltrada.
      end.
   end.

   {&open-query-brAuditEvent}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

