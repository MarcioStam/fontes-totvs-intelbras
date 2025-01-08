&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
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

&GLOBAL-DEFINE Program        escep050a
&GLOBAL-DEFINE Version        2.04.000.000

&SCOPED-DEFINE RPC-CALL       esp/cep/escep050rpc.r

/* Local Variable Definitions ---                                       */
DEF INPUT PARAM hproc      AS HANDLE              NO-UNDO.
DEF INPUT PARAM p-nr-ficha LIKE ficha-cq.nr-ficha NO-UNDO.

DEF VAR hprog AS HANDLE NO-UNDO.


DEF VAR de-saldo        AS DEC  FORMAT ">>,>>>,>>9".
DEF VAR de-saldo-rec    AS DEC  FORMAT ">>,>>>,>>9".

{esp/cep/escep050.i}
{upc/btb910za-upc.i} /* Defini‡Æo do estabelecimento do usu rio */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
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


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-BROWSE-3}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-34 RECT-35 RECT-36 rtToolBar bt-ok ~
BROWSE-3 
&Scoped-Define DISPLAYED-OBJECTS i-cod-emitente c-nome-emit c-nro-docto ~
c-serie-docto c-nat-operacao d-dt-emissao c-it-codigo c-desc-item i-total ~
c-narrativa 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

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
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-3 wWindow _FREEFORM
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
         FONT 1 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     i-cod-emitente AT ROW 1.33 COL 11.29 COLON-ALIGNED WIDGET-ID 88
     c-nome-emit AT ROW 1.33 COL 23 COLON-ALIGNED HELP
          "Nome abreviado do cliente/fornecedor" NO-LABEL WIDGET-ID 80
     c-nro-docto AT ROW 2.33 COL 11.29 COLON-ALIGNED WIDGET-ID 82
     c-serie-docto AT ROW 2.33 COL 34.29 COLON-ALIGNED WIDGET-ID 84
     c-nat-operacao AT ROW 2.33 COL 56.29 COLON-ALIGNED WIDGET-ID 78
     d-dt-emissao AT ROW 2.33 COL 78.29 COLON-ALIGNED HELP
          "Data de cria‡Æo do roteiro de inspe‡Æo" WIDGET-ID 86
     c-it-codigo AT ROW 3.33 COL 11.29 COLON-ALIGNED WIDGET-ID 74
     c-desc-item AT ROW 3.33 COL 28.72 COLON-ALIGNED HELP
          "Nome abreviado do cliente/fornecedor" NO-LABEL WIDGET-ID 72
     i-total AT ROW 11.08 COL 84.29 COLON-ALIGNED WIDGET-ID 90
     c-narrativa AT ROW 13.33 COL 11.29 NO-LABEL WIDGET-ID 76
     bt-ok AT ROW 17.58 COL 2.14 WIDGET-ID 70
     BROWSE-3 AT ROW 4.83 COL 1.29 WIDGET-ID 200
     RECT-34 AT ROW 1.08 COL 1.29 WIDGET-ID 92
     RECT-35 AT ROW 12.58 COL 1.29 WIDGET-ID 94
     RECT-36 AT ROW 10.58 COL 1.29 WIDGET-ID 96
     rtToolBar AT ROW 17.33 COL 1.29 WIDGET-ID 98
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 96.72 BY 18.13
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 18.13
         WIDTH              = 96.72
         MAX-HEIGHT         = 27.96
         MAX-WIDTH          = 142.29
         VIRTUAL-HEIGHT     = 27.96
         VIRTUAL-WIDTH      = 142.29
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wWindow 
/* ************************* Included-Libraries *********************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWindow
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME Custom                                                    */
/* BROWSE-TAB BROWSE-3 bt-ok fpage0 */
/* SETTINGS FOR FILL-IN c-desc-item IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-it-codigo IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR EDITOR c-narrativa IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-nat-operacao IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-nome-emit IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-nro-docto IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-serie-docto IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN d-dt-emissao IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-cod-emitente IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-total IN FRAME fpage0
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

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

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON END-ERROR OF wWindow
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-CLOSE OF wWindow
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-3
&Scoped-define SELF-NAME BROWSE-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-3 wWindow
ON VALUE-CHANGED OF BROWSE-3 IN FRAME fpage0
DO:
  IF AVAIL tt-ficha-cq THEN
      ASSIGN c-narrativa = tt-ficha-cq.narrativa.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok wWindow
ON CHOOSE OF bt-ok IN FRAME fpage0 /* OK */
DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

  RUN enable_UI.

  IF NOT VALID-HANDLE(hproc) THEN DO:
      RUN ShowMessage (1, "Erro na execu‡Æo", 
                          "Ocorreu um erro durante a execu‡Æo de um procedimento " +
                          "remoto que impede que esta opera‡Æo continue.~n" +
                          "Por favor repita esta opera‡Æo mais tarde").
      APPLY "close" TO THIS-PROCEDURE.
  END.
  
  RUN pi-carrega-dados IN THIS-PROCEDURE.

  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI wWindow 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI wWindow 
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

  ENABLE {&ENABLED-OBJECTS} WITH FRAME fPage0.

  DISP {&DISPLAYED-OBJECTS} WITH FRAME fPage0.

  {&OPEN-BROWSERS-IN-QUERY-fPage0}
  VIEW wWindow.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-dados wWindow 
PROCEDURE pi-carrega-dados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    for each tt-ficha-cq:
        delete tt-ficha-cq.
    end.

    RUN {&RPC-CALL} PERSISTENT SET hprog ON SERVER hproc TRANSACTION DISTINCT NO-ERROR.
    IF VALID-HANDLE(hprog) THEN DO:
        SESSION:SET-WAIT-STATE("GENERAL":U).

        RUN pi-carrega-ficha IN hprog (INPUT p-nr-ficha,
                                       OUTPUT i-cod-emitente,
                                       OUTPUT c-nome-emit,
                                       OUTPUT c-nro-docto,
                                       OUTPUT c-serie-docto,
                                       OUTPUT c-nat-operacao,
                                       OUTPUT d-dt-emissao,
                                       OUTPUT c-it-codigo,
                                       OUTPUT c-desc-item,
                                       OUTPUT c-narrativa,
                                       OUTPUT TABLE tt-ficha-cq).

        SESSION:SET-WAIT-STATE("":U).
        DELETE PROCEDURE hprog.
        hprog = ?.

        IF RETURN-VALUE <> "" THEN DO:
            MESSAGE RETURN-VALUE
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
        END.
    END.
    ELSE DO:
        MESSAGE "NÆo foi poss¡vel conectar ao servidor RPC. Favor fazer login novamente."
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END.

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

