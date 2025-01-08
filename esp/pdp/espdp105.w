&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
/*
DEFINE INPUT PARAMETER  p-nr-pedido   LIKE ped-item.nr-pedcli  . 
DEFINE INPUT PARAMETER  p-nome-abrev  LIKE ped-item.nome-abrev . 
*/
DEFINE INPUT PARAMETER  p-nr-contrato LIKE int-ped-venda.nr-contrato .


//DEFINE VAR  p-nr-contrato LIKE int-ped-venda.nr-contrato .

//ASSIGN p-nr-contrato = "070201" .
 
/* Local Variable Definitions ---                                       */

DEFINE TEMP-TABLE tt-pedidos 
    FIELD nr-pedido    LIKE ped-item.nr-pedcli
    FIELD nr-sequencia LIKE ped-item.nr-sequencia 
    FIELD it-codigo    LIKE ped-item.it-codigo
    FIELD desc-item    LIKE ITEM.descricao-1 
    FIELD dt-entrega   LIKE ped-item.dt-entrega
    FIELD qt-pedida    LIKE ped-item.qt-pedida
    FIELD vl-preuni    LIKE ped-item.vl-preuni 
    FIELD parcela      AS INT .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fPage0
&Scoped-define BROWSE-NAME BROWSE-8

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-pedidos

/* Definitions for BROWSE BROWSE-8                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-8 tt-pedidos.nr-pedido tt-pedidos.nr-sequencia tt-pedidos.it-codigo tt-pedidos.desc-item tt-pedidos.dt-entrega tt-pedidos.qt-pedida tt-pedidos.vl-preuni tt-pedidos.parcela   
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-8   
&Scoped-define SELF-NAME BROWSE-8
&Scoped-define QUERY-STRING-BROWSE-8 FOR EACH tt-pedidos BY tt-pedidos.parcela
&Scoped-define OPEN-QUERY-BROWSE-8 OPEN QUERY {&SELF-NAME} FOR EACH tt-pedidos BY tt-pedidos.parcela.
&Scoped-define TABLES-IN-QUERY-BROWSE-8 tt-pedidos
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-8 tt-pedidos


/* Definitions for FRAME fPage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage0 ~
    ~{&OPEN-QUERY-BROWSE-8}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar BROWSE-8 btOK-2 btOK btReajustar 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btOK 
     LABEL "&Fechar" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK-2 
     LABEL "&Fechar" 
     SIZE 10 BY 1.

DEFINE BUTTON btReajustar 
     LABEL "Reajustar Valores" 
     SIZE 14.29 BY 1.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 94 BY 1.42
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-8 FOR 
      tt-pedidos SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-8
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-8 C-Win _FREEFORM
  QUERY BROWSE-8 DISPLAY
      tt-pedidos.nr-pedido            WIDTH  6  COLUMN-LABEL "Pedido"
      tt-pedidos.nr-sequencia         WIDTH  4  COLUMN-LABEL "Seq"
      tt-pedidos.it-codigo            WIDTH 18  COLUMN-LABEL "Item"
      tt-pedidos.desc-item            WIDTH 18  COLUMN-LABEL "Desc Item"
      tt-pedidos.dt-entrega           WIDTH 10  COLUMN-LABEL "Vencimento"
      tt-pedidos.qt-pedida            WIDTH 10  COLUMN-LABEL "Quantidade"
      tt-pedidos.vl-preuni            WIDTH 10  COLUMN-LABEL "Preco Uni"
      tt-pedidos.parcela              WIDTH 10  COLUMN-LABEL "Parcela"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 93 BY 17.75
         FONT 1 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fPage0
     BROWSE-8 AT ROW 1.5 COL 2 WIDGET-ID 200
     btOK-2 AT ROW 19.75 COL 2 WIDGET-ID 46
     btOK AT ROW 19.75 COL 2 WIDGET-ID 8
     btReajustar AT ROW 19.75 COL 79 WIDGET-ID 48
     rtToolBar AT ROW 19.54 COL 1 WIDGET-ID 10
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 95.57 BY 20.29
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
         HEIGHT             = 20.29
         WIDTH              = 95.57
         MAX-HEIGHT         = 20.71
         MAX-WIDTH          = 95.57
         VIRTUAL-HEIGHT     = 20.71
         VIRTUAL-WIDTH      = 95.57
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
/* BROWSE-TAB BROWSE-8 rtToolBar fPage0 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-8
/* Query rebuild information for BROWSE BROWSE-8
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-pedidos BY tt-pedidos.parcela.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE BROWSE-8 */
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


&Scoped-define SELF-NAME btReajustar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReajustar C-Win
ON CHOOSE OF btReajustar IN FRAME fPage0 /* Reajustar Valores */
DO:
    RUN esp\pdp\espdp105a.w(INPUT p-nr-contrato ) .
    BROWSE-8:REFRESH() IN FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-8
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */

RUN pi-cria-temp-table.

//BROWSE-8:REFRESH() IN FRAME fPage0.

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
   // RUN initializeObject.
    IF  NOT THIS-PROCEDURE:PERSISTENT THEN
        WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.



RUN initializeObject.

//BROWSE-8:REFRESH() IN FRAME fPage0.

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
  ENABLE rtToolBar BROWSE-8 btOK-2 btOK btReajustar 
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
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-temp-table C-Win 
PROCEDURE pi-cria-temp-table :
EMPTY TEMP-TABLE tt-pedidos.
/*
FIND FIRST ped-venda WHERE p-nr-pedido = ped-item.nr-pedcli NO-LOCK NO-ERROR.
    //p-nome-abrev = ped-venda.nome-abrev AND p-nr-pedido = ped-item.nr-pedcli NO-LOCK NO-ERROR.
*/

FOR EACH int-ped-venda WHERE int-ped-venda.nr-contrato = p-nr-contrato USE-INDEX ch-nr-contrato NO-LOCK:
    // USE-INDEX ch-pedseq NO-LOCK: 
                       
    FIND FIRST ped-venda WHERE ped-venda.nr-pedido  = int-ped-venda.nr-pedido NO-ERROR.

    FOR EACH ped-item WHERE ped-item.nome-abrev   = ped-venda.nome-abrev
                        AND ped-item.nr-pedcli    = ped-venda.nr-pedcli NO-LOCK:

        FIND FIRST ITEM WHERE ped-item.it-codigo = ITEM.it-codigo NO-LOCK NO-ERROR.

        FIND FIRST int-ped-item WHERE int-ped-item.nome-abrev   = ped-item.nome-abrev 
                                  AND int-ped-item.nr-pedcli    = ped-item.nr-pedcli
                                  AND int-ped-item.nr-sequencia = ped-item.nr-sequencia 
                                  AND int-ped-item.nr-parcela      <> ? NO-ERROR.
        IF AVAIL int-ped-item THEN DO:
            CREATE tt-pedidos.
            ASSIGN tt-pedidos.nr-pedido    = ped-item.nr-pedcli
                   tt-pedidos.nr-sequencia = ped-item.nr-sequencia
                   tt-pedidos.it-codigo    = ped-item.it-codigo
                   tt-pedidos.desc-item    = ITEM.descricao-1 
                   tt-pedidos.dt-entrega   = ped-item.dt-entrega
                   tt-pedidos.qt-pedida    = ped-item.qt-pedida
                   tt-pedidos.vl-preuni    = ped-item.vl-preuni 
                   tt-pedidos.parcela      = int-ped-item.nr-parcela-recor   .
        END.
    END.
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

