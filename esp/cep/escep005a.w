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

DEF INPUT PARAM p-nr-ficha LIKE ficha-cq.nr-ficha.

DEF TEMP-TABLE tt-ficha-cq
    FIELD nr-ficha     LIKE ficha-cq.nr-ficha     column-label "Roteiro"
    FIELD qt-original  LIKE ficha-cq.qt-original  column-label "Recebida"  format ">>>,>>>,>>9"
    FIELD qt-aprovada  LIKE ficha-cq.qt-aprovada  column-label "Aprovada"  format ">>>,>>>,>>9"
    FIELD qt-rejeitada LIKE ficha-cq.qt-rejeitada column-label "Rejeitada" format ">>>,>>>,>>9"
    FIELD qt-apr-cond  LIKE ficha-cq.qt-apr-cond  column-label "Apr.Cond." format ">>>,>>>,>>9" 
    FIELD dt-inspecao  LIKE ficha-cq.dt-inspecao  column-label "Inspecao"
    FIELD narrativa    LIKE ficha-cq.narrativa.

DEF VAR i-nr-ficha     LIKE ficha-cq.nr-ficha.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define BROWSE-NAME BROWSE-3

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-ficha-cq

/* Definitions for BROWSE BROWSE-3                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-3 tt-ficha-cq.nr-ficha tt-ficha-cq.qt-original tt-ficha-cq.qt-aprovada tt-ficha-cq.qt-rejeitada tt-ficha-cq.qt-apr-cond tt-ficha-cq.dt-inspecao   
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-3   
&Scoped-define SELF-NAME BROWSE-3
&Scoped-define QUERY-STRING-BROWSE-3 FOR EACH tt-ficha-cq
&Scoped-define OPEN-QUERY-BROWSE-3 OPEN QUERY {&SELF-NAME} FOR EACH tt-ficha-cq.
&Scoped-define TABLES-IN-QUERY-BROWSE-3 tt-ficha-cq
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-3 tt-ficha-cq


/* Definitions for FRAME DEFAULT-FRAME                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME ~
    ~{&OPEN-QUERY-BROWSE-3}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BROWSE-3 bt-ok RECT-34 RECT-35 RECT-36 ~
rtToolBar 
&Scoped-Define DISPLAYED-OBJECTS i-cod-emitente c-nome-emit c-nro-docto ~
c-serie-docto c-nat-operacao d-dt-emissao c-it-codigo c-desc-item i-total ~
c-narrativa 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-ok 
     LABEL "OK" 
     SIZE 12 BY 1.

DEFINE VARIABLE c-narrativa AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 80 BY 3.25 NO-UNDO.

DEFINE VARIABLE c-desc-item AS CHARACTER FORMAT "X(60)" 
     VIEW-AS FILL-IN 
     SIZE 43 BY .88.

DEFINE VARIABLE c-it-codigo AS CHARACTER FORMAT "x(16)" 
     LABEL "Item":R5 
     VIEW-AS FILL-IN 
     SIZE 17.14 BY .88.

DEFINE VARIABLE c-nat-operacao AS CHARACTER FORMAT "x(06)" 
     LABEL "Nat Opera‡Æo":R15 
     VIEW-AS FILL-IN 
     SIZE 10.14 BY .88.

DEFINE VARIABLE c-nome-emit AS CHARACTER FORMAT "X(60)" 
     VIEW-AS FILL-IN 
     SIZE 43 BY .88.

DEFINE VARIABLE c-nro-docto AS CHARACTER FORMAT "x(16)" 
     LABEL "NF":R11 
     VIEW-AS FILL-IN 
     SIZE 17.14 BY .88.

DEFINE VARIABLE c-serie-docto AS CHARACTER FORMAT "x(5)" 
     LABEL "S‚rie":R7 
     VIEW-AS FILL-IN 
     SIZE 9.14 BY .88.

DEFINE VARIABLE d-dt-emissao AS DATE FORMAT "99/99/9999" INITIAL 09/23/05 
     LABEL "Data Entrada":R15 
     VIEW-AS FILL-IN 
     SIZE 12.57 BY .88.

DEFINE VARIABLE i-cod-emitente AS INTEGER FORMAT ">>>>>>>>9" INITIAL 0 
     LABEL "Fornecedor":R10 
     VIEW-AS FILL-IN 
     SIZE 11.43 BY .88.

DEFINE VARIABLE i-total AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "Total" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-34
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 96 BY 3.5.

DEFINE RECTANGLE RECT-35
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 96 BY 4.5.

DEFINE RECTANGLE RECT-36
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 96 BY 1.75.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 96 BY 1.5
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-3 FOR 
      tt-ficha-cq SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-3 C-Win _FREEFORM
  QUERY BROWSE-3 DISPLAY
      tt-ficha-cq.nr-ficha     column-label "Roteiro"          
    tt-ficha-cq.qt-original  column-label "Recebida"   format ">>>,>>>,>>9"                             
    tt-ficha-cq.qt-aprovada  column-label "Aprovada"   format ">>>,>>>,>>9"                             
    tt-ficha-cq.qt-rejeitada column-label "Rejeitada"  format ">>>,>>>,>>9"                             
    tt-ficha-cq.qt-apr-cond  column-label "Apr.Cond."  format ">>>,>>>,>>9"                             
    tt-ficha-cq.dt-inspecao  column-label "Inspecao"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 96 BY 5.5
         FONT 1 EXPANDABLE.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     i-cod-emitente AT ROW 1.25 COL 11 COLON-ALIGNED
     c-nome-emit AT ROW 1.25 COL 22.72 COLON-ALIGNED HELP
          "Nome abreviado do cliente/fornecedor" NO-LABEL
     c-nro-docto AT ROW 2.25 COL 11 COLON-ALIGNED
     c-serie-docto AT ROW 2.25 COL 34 COLON-ALIGNED
     c-nat-operacao AT ROW 2.25 COL 56 COLON-ALIGNED
     d-dt-emissao AT ROW 2.25 COL 78 COLON-ALIGNED HELP
          "Data de cria‡Æo do roteiro de inspe‡Æo"
     c-it-codigo AT ROW 3.25 COL 11 COLON-ALIGNED
     c-desc-item AT ROW 3.25 COL 28.43 COLON-ALIGNED HELP
          "Nome abreviado do cliente/fornecedor" NO-LABEL
     BROWSE-3 AT ROW 4.75 COL 1
     i-total AT ROW 11 COL 84 COLON-ALIGNED
     c-narrativa AT ROW 13.25 COL 11 NO-LABEL
     bt-ok AT ROW 17.5 COL 3
     RECT-34 AT ROW 1 COL 1
     RECT-35 AT ROW 12.5 COL 1
     RECT-36 AT ROW 10.5 COL 1
     rtToolBar AT ROW 17.25 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 96 BY 17.92
         FONT 1.


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
         TITLE              = "Roteiros da AE - ESCEP005A"
         HEIGHT             = 17.92
         WIDTH              = 96
         MAX-HEIGHT         = 30.04
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 30.04
         VIRTUAL-WIDTH      = 146.29
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
/* SETTINGS FOR FRAME DEFAULT-FRAME
                                                                        */
/* BROWSE-TAB BROWSE-3 c-desc-item DEFAULT-FRAME */
/* SETTINGS FOR FILL-IN c-desc-item IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-it-codigo IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR EDITOR c-narrativa IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-nat-operacao IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-nome-emit IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-nro-docto IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-serie-docto IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN d-dt-emissao IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-cod-emitente IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-total IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-3
/* Query rebuild information for BROWSE BROWSE-3
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-ficha-cq.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE BROWSE-3 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Roteiros da AE - ESCEP005A */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Roteiros da AE - ESCEP005A */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-3
&Scoped-define SELF-NAME BROWSE-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-3 C-Win
ON VALUE-CHANGED OF BROWSE-3 IN FRAME DEFAULT-FRAME
DO:
  IF AVAIL tt-ficha-cq THEN
      ASSIGN c-narrativa = tt-ficha-cq.narrativa.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok C-Win
ON CHOOSE OF bt-ok IN FRAME DEFAULT-FRAME /* OK */
DO:
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

  RUN pi-mostra-valores.

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
  DISPLAY i-cod-emitente c-nome-emit c-nro-docto c-serie-docto c-nat-operacao 
          d-dt-emissao c-it-codigo c-desc-item i-total c-narrativa 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE BROWSE-3 bt-ok RECT-34 RECT-35 RECT-36 rtToolBar 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mostra-valores C-Win 
PROCEDURE pi-mostra-valores :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   
   find ficha-cq no-lock 
        where ficha-cq.nr-ficha = p-nr-ficha no-error.
    
   find emitente no-lock 
        where emitente.cod-emitente = ficha-cq.cod-emitente no-error.
   
   find item no-lock 
        where item.it-codigo = ficha-cq.it-codigo no-error.

   find docum-est no-lock 
        where docum-est.cod-emitente = ficha-cq.cod-emitente  
        AND   docum-est.serie-docto  = ficha-cq.serie   
        AND   docum-est.nro-docto    = ficha-cq.nro-docto     
        AND   docum-est.nat-operacao = ficha-cq.nat-operacao no-error.
      
   assign  i-cod-emitente   = ficha-cq.cod-emitente
           c-nome-emit      = emitente.nome-emit
           c-nro-docto      = ficha-cq.nro-docto
           c-serie-docto    = ficha-cq.serie
           c-nat-operacao   = ficha-cq.nat-operacao
           d-dt-emissao     = ficha-cq.dt-ficha
           c-it-codigo      = ficha-cq.it-codigo 
           c-desc-item      = item.desc-item.

   assign i-total = 0.

   for each ficha-cq no-lock
      where ficha-cq.serie-docto  = c-serie-docto
      and   ficha-cq.nro-docto    = c-nro-docto
      and   ficha-cq.cod-emitente = i-cod-emitente
      and   ficha-cq.nat-operacao = c-nat-operacao
      and   ficha-cq.it-codigo    = c-it-codigo
      by    ficha-cq.nr-ficha:
   
       ASSIGN i-total = i-total + ficha-cq.qt-original.

       CREATE tt-ficha-cq.
       ASSIGN tt-ficha-cq.nr-ficha     = ficha-cq.nr-ficha
              tt-ficha-cq.qt-original  = ficha-cq.qt-original
              tt-ficha-cq.qt-aprovada  = ficha-cq.qt-aprovada
              tt-ficha-cq.qt-rejeitada = ficha-cq.qt-rejeitada
              tt-ficha-cq.qt-apr-cond  = ficha-cq.qt-apr-cond
              tt-ficha-cq.dt-inspecao  = ficha-cq.dt-inspecao
              tt-ficha-cq.narrativa    = ficha-cq.narrativa.
   end.

   FIND FIRST tt-ficha-cq NO-ERROR.
   ASSIGN c-narrativa = IF AVAIL tt-ficha-cq THEN tt-ficha-cq.narrativa ELSE "".
  
   {&OPEN-QUERY-{&BROWSE-NAME}}

   DISP i-cod-emitente  
        c-nome-emit     
        c-nro-docto     
        c-serie-docto   
        c-nat-operacao  
        d-dt-emissao    
        c-it-codigo     
        c-desc-item     
        i-total
        c-narrativa
        WITH FRAME {&FRAME-NAME}.

   
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

