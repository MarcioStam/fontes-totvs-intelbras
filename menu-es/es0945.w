&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcad           PROGRESS
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define BROWSE-NAME BROWSE-4

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES db-saldo-ato db-movto-ato

/* Definitions for BROWSE BROWSE-4                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-4 db-saldo-ato.ato ~
db-saldo-ato.it-codigo db-saldo-ato.ncm db-saldo-ato.qtd-ini ~
db-saldo-ato.qtd-saldo 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-4 
&Scoped-define QUERY-STRING-BROWSE-4 FOR EACH db-saldo-ato ~
      WHERE db-saldo-ato.it-codigo >= c-it-ini:screen-value in frame {&frame-name} and ~
mgesp.db-saldo-ato.it-codigo <= c-it-fim:screen-value in frame {&frame-name} NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-4 OPEN QUERY BROWSE-4 FOR EACH db-saldo-ato ~
      WHERE db-saldo-ato.it-codigo >= c-it-ini:screen-value in frame {&frame-name} and ~
mgesp.db-saldo-ato.it-codigo <= c-it-fim:screen-value in frame {&frame-name} NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-4 db-saldo-ato
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-4 db-saldo-ato


/* Definitions for BROWSE BROWSE-7                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-7 dt-trans num-pedido numero-ordem parcela quantidade   
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-7   
&Scoped-define SELF-NAME BROWSE-7
&Scoped-define QUERY-STRING-BROWSE-7 FOR EACH db-movto-ato OF db-saldo-ato
&Scoped-define OPEN-QUERY-BROWSE-7 OPEN QUERY {&SELF-NAME} FOR EACH db-movto-ato OF db-saldo-ato.
&Scoped-define TABLES-IN-QUERY-BROWSE-7 db-movto-ato
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-7 db-movto-ato


/* Definitions for FRAME DEFAULT-FRAME                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME ~
    ~{&OPEN-QUERY-BROWSE-4}~
    ~{&OPEN-QUERY-BROWSE-7}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BUTTON-10 BUTTON-12 c-it-ini c-it-fim ~
BROWSE-4 BROWSE-7 de-n-qtd BUTTON-11 l-tipo i-pedido BUTTON-1 RECT-10 ~
RECT-4 RECT-6 RECT-7 RECT-8 RECT-9 
&Scoped-Define DISPLAYED-OBJECTS c-it-ini c-it-fim de-n-qtd l-tipo i-pedido 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "adeicon/prevw-u.bmp":U
     LABEL "Button 1" 
     SIZE 15 BY 1.13.

DEFINE BUTTON BUTTON-10 
     IMAGE-UP FILE "image/intelbras/oofl.ico":U NO-FOCUS FLAT-BUTTON
     LABEL "Button 10" 
     SIZE 7 BY 1.88 TOOLTIP "Clique aqui para sair do programa".

DEFINE BUTTON BUTTON-11 
     IMAGE-UP FILE "adeicon/editor.bmp":U
     LABEL "Button 11" 
     SIZE 7 BY 1.13.

DEFINE BUTTON BUTTON-12 
     IMAGE-UP FILE "adeicon/check.bmp":U
     LABEL "Button 12" 
     SIZE 8 BY 1.25.

DEFINE VARIABLE c-it-fim AS CHARACTER FORMAT "X(256)":U INITIAL "zzzzzzz" 
     LABEL "a" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE c-it-ini AS CHARACTER FORMAT "X(256)":U 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE de-n-qtd AS DECIMAL FORMAT "->,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 18 BY 1 NO-UNDO.

DEFINE VARIABLE i-pedido AS CHARACTER FORMAT "X(256)":U 
     LABEL "Pedido" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE l-tipo AS LOGICAL 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Consulta", no,
"Atualiza", yes
     SIZE 28 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 91 BY 1.75.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 1 BY .75.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 91 BY 5.5.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 91 BY 8.

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 76 BY 3.5.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 15 BY 3.5.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-4 FOR 
      db-saldo-ato SCROLLING.

DEFINE QUERY BROWSE-7 FOR 
      db-movto-ato SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-4 C-Win _STRUCTURED
  QUERY BROWSE-4 NO-LOCK DISPLAY
      db-saldo-ato.ato FORMAT "x(20)":U
      db-saldo-ato.it-codigo FORMAT "x(16)":U
      db-saldo-ato.ncm FORMAT "x(15)":U
      db-saldo-ato.qtd-ini FORMAT "->,>>>,>>9.99":U
      db-saldo-ato.qtd-saldo FORMAT "->,>>>,>>9.99":U WIDTH 22.86
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 89 BY 7.25 EXPANDABLE.

DEFINE BROWSE BROWSE-7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-7 C-Win _FREEFORM
  QUERY BROWSE-7 DISPLAY
      dt-trans
 num-pedido
     numero-ordem
     parcela
     quantidade FORMAT ">,>>>,>>9.99"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 69 BY 4.5 EXPANDABLE.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     BUTTON-10 AT ROW 18 COL 83
     BUTTON-12 AT ROW 1.25 COL 42
     c-it-ini AT ROW 1.5 COL 6 COLON-ALIGNED
     c-it-fim AT ROW 1.5 COL 24 COLON-ALIGNED
     BROWSE-4 AT ROW 3.75 COL 3
     BROWSE-7 AT ROW 11.75 COL 3
     de-n-qtd AT ROW 13 COL 71 COLON-ALIGNED NO-LABEL
     BUTTON-11 AT ROW 14.5 COL 84
     l-tipo AT ROW 17.75 COL 3 NO-LABEL
     i-pedido AT ROW 19 COL 9 COLON-ALIGNED
     BUTTON-1 AT ROW 19 COL 27
     RECT-10 AT ROW 1 COL 2
     RECT-4 AT ROW 4 COL 15
     RECT-6 AT ROW 11.25 COL 2
     RECT-7 AT ROW 3 COL 2
     RECT-8 AT ROW 17 COL 2
     RECT-9 AT ROW 17 COL 78
     "Atualiza QTD" VIEW-AS TEXT
          SIZE 15 BY .67 AT ROW 12.25 COL 76
     "Movimentos" VIEW-AS TEXT
          SIZE 13 BY .67 AT ROW 11 COL 3
     "Saldos" VIEW-AS TEXT
          SIZE 8 BY .67 AT ROW 2.75 COL 3
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 92.43 BY 19.71.


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
         TITLE              = "Controle de Saldos de DrawBack"
         HEIGHT             = 19.71
         WIDTH              = 92.43
         MAX-HEIGHT         = 19.71
         MAX-WIDTH          = 92.43
         VIRTUAL-HEIGHT     = 19.71
         VIRTUAL-WIDTH      = 92.43
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
/* BROWSE-TAB BROWSE-4 c-it-fim DEFAULT-FRAME */
/* BROWSE-TAB BROWSE-7 BROWSE-4 DEFAULT-FRAME */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-4
/* Query rebuild information for BROWSE BROWSE-4
     _TblList          = "mgesp.db-saldo-ato"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "mgesp.db-saldo-ato.it-codigo >= c-it-ini:screen-value in frame {&frame-name} and
mgesp.db-saldo-ato.it-codigo <= c-it-fim:screen-value in frame {&frame-name}"
     _FldNameList[1]   = mgesp.db-saldo-ato.ato
     _FldNameList[2]   = mgesp.db-saldo-ato.it-codigo
     _FldNameList[3]   = mgesp.db-saldo-ato.ncm
     _FldNameList[4]   > mgesp.db-saldo-ato.qtd-ini
"qtd-ini" ? "->,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _FldNameList[5]   > mgesp.db-saldo-ato.qtd-saldo
"qtd-saldo" ? ? "decimal" ? ? ? ? ? ? no ? no no "22.86" yes no no "U" "" ""
     _Query            is OPENED
*/  /* BROWSE BROWSE-4 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-7
/* Query rebuild information for BROWSE BROWSE-7
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH db-movto-ato OF db-saldo-ato.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE BROWSE-7 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME DEFAULT-FRAME
/* Query rebuild information for FRAME DEFAULT-FRAME
     _Query            is NOT OPENED
*/  /* FRAME DEFAULT-FRAME */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Controle de Saldos de DrawBack */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Controle de Saldos de DrawBack */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-4
&Scoped-define SELF-NAME BROWSE-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-4 C-Win
ON ENTRY OF BROWSE-4 IN FRAME DEFAULT-FRAME
DO:
    {&open-query-browse-7}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-4 C-Win
ON VALUE-CHANGED OF BROWSE-4 IN FRAME DEFAULT-FRAME
DO:
  {&open-query-browse-7}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 C-Win
ON CHOOSE OF BUTTON-1 IN FRAME DEFAULT-FRAME /* Button 1 */
DO:

  DEF VAR de-qtd AS DEC.
  ASSIGN l-tipo.

  OUTPUT TO c:\temp\consulta-db.txt CONVERT TARGET "iso8859-1".

  PUT "Relat¢rio de Avalia‡Æo de Uso de DrawBack para Pedido." SKIP(1).

  PUT "Pedido " i-pedido:SCREEN-VALUE IN FRAME {&FRAME-NAME} SKIP (1).


  PUT  "    Ordem    Pa    Item             QTD Pedido        NCM          Saldo DB     QTD DB Saldo Pedido Ato" SKIP(1).

  FOR EACH ordem-compra NO-LOCK
     WHERE ordem-compra.num-pedido = INT(i-pedido:SCREEN-VALUE IN FRAME {&FRAME-NAME})
       AND ordem-compra.situacao = 2,
      EACH prazo-compra NO-LOCK
     WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem.

      PUT ordem-compra.numero-ordem " "
          prazo-compra.parcela     " "
          ordem-compra.it-codigo " " 
          prazo-compra.quant-saldo " ".


      FIND FIRST db-saldo-ato NO-LOCK
           WHERE db-saldo-ato.it-codigo = ordem-compra.it-codigo
             AND db-saldo-ato.qtd-saldo > 0
             /* AND db-saldo-ato.ncm       = ordem.ncm */
             
          NO-ERROR .

      IF AVAIL db-saldo-ato  THEN
          PUT db-saldo-ato.ncm 
              db-saldo-ato.qtd-saldo " " .
      ELSE 
          PUT "               " "             "  " ".

      IF NOT AVAIL db-saldo-ato THEN 
          ASSIGN de-qtd = 0.
      ELSE DO:
          IF db-saldo-ato.qtd-saldo = 0 THEN 
              ASSIGN de-qtd = 0.
          ELSE 
              IF prazo-compra.quant-saldo <= db-saldo-ato.qtd-saldo THEN
                  ASSIGN de-qtd = prazo-compra.quant-saldo.
              ELSE ASSIGN de-qtd = db-saldo-ato.qtd-saldo.
      END.
             

      PUT de-qtd " " 
          prazo-compra.quant-saldo - de-qtd FORMAT "->>>>,>>9.99".

      IF AVAIL db-saldo-ato THEN
          PUT " " db-saldo-ato.ato FORMAT "x(50)".


      PUT SKIP.


      IF de-qtd > 0 AND l-tipo  THEN DO:
          CREATE db-movto-ato.
          ASSIGN db-movto-ato.ato = db-saldo-ato.ato
                 db-movto-ato.dt-trans = TODAY
                 db-movto-ato.it-codigo = db-saldo-ato.it-codigo
                 db-movto-ato.ncm = db-saldo-ato.ncm
                 db-movto-ato.num-pedido = ordem-compra.num-pedido
                 db-movto-ato.numero-ordem = ordem-compra.numero-ordem
                 db-movto-ato.parcela = prazo-compra.parcela
                 db-movto-ato.quantidade = de-qtd.
          
          FIND CURRENT db-saldo-ato EXCLUSIVE-LOCK.

          ASSIGN db-saldo-ato.qtd-saldo = db-saldo-ato.qtd-saldo - de-qtd.


          FIND CURRENT db-saldo-ato NO-LOCK.

          {&open-query-&browse-7}

      END.


  END.


  OUTPUT CLOSE.

  OS-COMMAND SILENT notepad c:\temp\consulta-db.txt.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-10
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-10 C-Win
ON CHOOSE OF BUTTON-10 IN FRAME DEFAULT-FRAME /* Button 10 */
DO:

  APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-11
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-11 C-Win
ON CHOOSE OF BUTTON-11 IN FRAME DEFAULT-FRAME /* Button 11 */
DO:
  IF NOT AVAIL db-movto-ato THEN RETURN NO-APPLY.
  FIND CURRENT db-saldo-ato EXCLUSIVE-LOCK.
  FIND CURRENT db-movto-ato EXCLUSIVE-LOCK.
  ASSIGN db-saldo-ato.qtd-saldo = db-saldo-ato.qtd-saldo + db-movto-ato.quantidade - DEC(de-n-qtd:SCREEN-VALUE IN FRAME {&FRAME-NAME}).
  ASSIGN db-movto-ato.quantidade = DEC(de-n-qtd:SCREEN-VALUE IN FRAME {&FRAME-NAME}).

  IF db-movto-ato.quantidade = 0 THEN
      DELETE db-movto-ato.

  DEF VAR l-refresh AS LOG.
  ASSIGN l-refresh = browse-7:REFRESH().
  ASSIGN l-refresh = browse-4:REFRESH().

  FIND CURRENT db-saldo-ato NO-LOCK.
  IF AVAIL db-movto-ato THEN FIND CURRENT db-movto-ato NO-LOCK.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-12
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-12 C-Win
ON CHOOSE OF BUTTON-12 IN FRAME DEFAULT-FRAME /* Button 12 */
DO:
  {&open-query-browse-4}
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
  DISPLAY c-it-ini c-it-fim de-n-qtd l-tipo i-pedido 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE BUTTON-10 BUTTON-12 c-it-ini c-it-fim BROWSE-4 BROWSE-7 de-n-qtd 
         BUTTON-11 l-tipo i-pedido BUTTON-1 RECT-10 RECT-4 RECT-6 RECT-7 RECT-8 
         RECT-9 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

