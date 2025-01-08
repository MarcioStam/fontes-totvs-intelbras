&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME C-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-pagto-vpc NO-UNDO LIKE pagto-vpc
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-vpc NO-UNDO LIKE vpc
       field r-rowid as rowid.



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
DEFINE INPUT PARAMETER p-nr-vpc AS INTEGER NO-UNDO.
/* Local Variable Definitions ---                                       */

{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-main
&Scoped-define BROWSE-NAME br-pagamento

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-pagto-vpc

/* Definitions for BROWSE br-pagamento                                  */
&Scoped-define FIELDS-IN-QUERY-br-pagamento tt-pagto-vpc.sequencia ~
tt-pagto-vpc.data-pagto tt-pagto-vpc.valor tt-pagto-vpc.cod-estab-nf ~
tt-pagto-vpc.serie tt-pagto-vpc.nr-nota-fis tt-pagto-vpc.nr-pedcli ~
tt-pagto-vpc.refer-docto tt-pagto-vpc.usuario tt-pagto-vpc.data-trans 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-pagamento 
&Scoped-define QUERY-STRING-br-pagamento FOR EACH tt-pagto-vpc NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br-pagamento OPEN QUERY br-pagamento FOR EACH tt-pagto-vpc NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br-pagamento tt-pagto-vpc
&Scoped-define FIRST-TABLE-IN-QUERY-br-pagamento tt-pagto-vpc


/* Definitions for FRAME f-main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-f-main ~
    ~{&OPEN-QUERY-br-pagamento}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-pagto-vpc.observacoes 
&Scoped-define ENABLED-TABLES tt-pagto-vpc
&Scoped-define FIRST-ENABLED-TABLE tt-pagto-vpc
&Scoped-Define ENABLED-OBJECTS rtToolBar rtKeys rtKeys-2 br-pagamento btOK ~
btCancel btHelp2 
&Scoped-Define DISPLAYED-FIELDS tt-vpc.cod-emitente tt-vpc.nr-vpc ~
tt-pagto-vpc.observacoes 
&Scoped-define DISPLAYED-TABLES tt-vpc tt-pagto-vpc
&Scoped-define FIRST-DISPLAYED-TABLE tt-vpc
&Scoped-define SECOND-DISPLAYED-TABLE tt-pagto-vpc
&Scoped-Define DISPLAYED-OBJECTS fi-nome-emit fi-cod-rep 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btAddPagto 
     LABEL "Incluir" 
     SIZE 10 BY 1.

DEFINE BUTTON btCancel 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp2 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE VARIABLE fi-cod-rep AS INTEGER FORMAT ">>>>9" INITIAL 0 
     LABEL "Representante":R16 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88.

DEFINE VARIABLE fi-nome-emit AS CHARACTER FORMAT "X(40)" 
     VIEW-AS FILL-IN 
     SIZE 52.14 BY .88.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 96.43 BY 2.5.

DEFINE RECTANGLE rtKeys-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 96.43 BY 11.08.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 99 BY 1.42
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-pagamento FOR 
      tt-pagto-vpc SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-pagamento
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-pagamento C-Win _STRUCTURED
  QUERY br-pagamento NO-LOCK DISPLAY
      tt-pagto-vpc.sequencia COLUMN-LABEL "Seq" FORMAT ">>>9":U
            WIDTH 5.43
      tt-pagto-vpc.data-pagto FORMAT "99/99/9999":U WIDTH 8.86
      tt-pagto-vpc.valor FORMAT "->>>,>>9.99":U
      tt-pagto-vpc.cod-estab-nf FORMAT "X(3)":U
      tt-pagto-vpc.serie FORMAT "X(2)":U
      tt-pagto-vpc.nr-nota-fis FORMAT "X(12)":U WIDTH 10.29
      tt-pagto-vpc.nr-pedcli FORMAT "x(12)":U WIDTH 10.86
      tt-pagto-vpc.refer-docto FORMAT "x(12)":U
      tt-pagto-vpc.usuario FORMAT "x(12)":U
      tt-pagto-vpc.data-trans FORMAT "99/99/9999":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 94.43 BY 6.75
         TITLE "Pagamentos" FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     tt-vpc.cod-emitente AT ROW 1.75 COL 19 COLON-ALIGNED WIDGET-ID 36
          VIEW-AS FILL-IN 
          SIZE 7.57 BY .88
     fi-nome-emit AT ROW 1.75 COL 26.86 COLON-ALIGNED NO-LABEL WIDGET-ID 38
     fi-cod-rep AT ROW 2.71 COL 73 COLON-ALIGNED WIDGET-ID 40
     tt-vpc.nr-vpc AT ROW 2.75 COL 19 COLON-ALIGNED WIDGET-ID 34
          VIEW-AS FILL-IN 
          SIZE 6.86 BY .88
     br-pagamento AT ROW 4.58 COL 3.57 WIDGET-ID 200
     tt-pagto-vpc.observacoes AT ROW 11.5 COL 3.57 NO-LABEL WIDGET-ID 28
          VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
          SIZE 94.43 BY 2.58
     btAddPagto AT ROW 14.17 COL 3.57 WIDGET-ID 20
     btOK AT ROW 15.79 COL 2 WIDGET-ID 50
     btCancel AT ROW 15.79 COL 13 WIDGET-ID 46
     btHelp2 AT ROW 15.79 COL 89.57 WIDGET-ID 48
     rtToolBar AT ROW 15.58 COL 1 WIDGET-ID 52
     rtKeys AT ROW 1.5 COL 2.57 WIDGET-ID 42
     rtKeys-2 AT ROW 4.25 COL 2.57 WIDGET-ID 44
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 100 BY 16.13 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-pagto-vpc T "?" NO-UNDO mgesp pagto-vpc
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-vpc T "?" NO-UNDO mgesp vpc
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
         TITLE              = "Pagamentos VPC - ESUPT021A1 - 2.04.00.001"
         HEIGHT             = 16.13
         WIDTH              = 100
         MAX-HEIGHT         = 21.29
         MAX-WIDTH          = 109.72
         VIRTUAL-HEIGHT     = 21.29
         VIRTUAL-WIDTH      = 109.72
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
/* SETTINGS FOR FRAME f-main
   FRAME-NAME                                                           */
/* BROWSE-TAB br-pagamento nr-vpc f-main */
/* SETTINGS FOR BUTTON btAddPagto IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN tt-vpc.cod-emitente IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-cod-rep IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-nome-emit IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN tt-vpc.nr-vpc IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       tt-pagto-vpc.observacoes:READ-ONLY IN FRAME f-main        = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-pagamento
/* Query rebuild information for BROWSE br-pagamento
     _TblList          = "Temp-Tables.tt-pagto-vpc"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.tt-pagto-vpc.sequencia
"tt-pagto-vpc.sequencia" "Seq" ? "integer" ? ? ? ? ? ? no ? no no "5.43" yes no no "U" "" ""
     _FldNameList[2]   > Temp-Tables.tt-pagto-vpc.data-pagto
"tt-pagto-vpc.data-pagto" ? ? "date" ? ? ? ? ? ? no ? no no "8.86" yes no no "U" "" ""
     _FldNameList[3]   = Temp-Tables.tt-pagto-vpc.valor
     _FldNameList[4]   = Temp-Tables.tt-pagto-vpc.cod-estab-nf
     _FldNameList[5]   = Temp-Tables.tt-pagto-vpc.serie
     _FldNameList[6]   > Temp-Tables.tt-pagto-vpc.nr-nota-fis
"tt-pagto-vpc.nr-nota-fis" ? ? "character" ? ? ? ? ? ? no ? no no "10.29" yes no no "U" "" ""
     _FldNameList[7]   > Temp-Tables.tt-pagto-vpc.nr-pedcli
"tt-pagto-vpc.nr-pedcli" ? ? "character" ? ? ? ? ? ? no ? no no "10.86" yes no no "U" "" ""
     _FldNameList[8]   = Temp-Tables.tt-pagto-vpc.refer-docto
     _FldNameList[9]   = Temp-Tables.tt-pagto-vpc.usuario
     _FldNameList[10]   = Temp-Tables.tt-pagto-vpc.data-trans
     _Query            is OPENED
*/  /* BROWSE br-pagamento */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* ESUPT021A1 - 2.04.00.001 - Pagamentos VPC */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* ESUPT021A1 - 2.04.00.001 - Pagamentos VPC */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-pagamento
&Scoped-define SELF-NAME br-pagamento
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-pagamento C-Win
ON VALUE-CHANGED OF br-pagamento IN FRAME f-main /* Pagamentos */
DO:
    IF AVAIL tt-pagto-vpc THEN DO:
        ASSIGN tt-pagto-vpc.observacoes:SCREEN-VALUE IN FRAME f-main = tt-pagto-vpc.observacoes.
    END.
    ELSE DO:
        ASSIGN tt-pagto-vpc.observacoes:SCREEN-VALUE IN FRAME f-main = "".
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btAddPagto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddPagto C-Win
ON CHOOSE OF btAddPagto IN FRAME f-main /* Incluir */
DO:
    ASSIGN CURRENT-WINDOW:SENSITIVE = NO.
    RUN esp/utp/esutp022a2.w (INPUT tt-vpc.cod-emitente,
                              INPUT tt-vpc.nr-vpc).
    ASSIGN CURRENT-WINDOW:SENSITIVE = YES.

    RUN pi-carrega-dados.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel C-Win
ON CHOOSE OF btCancel IN FRAME f-main /* Cancelar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp2 C-Win
ON CHOOSE OF btHelp2 IN FRAME f-main /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK C-Win
ON CHOOSE OF btOK IN FRAME f-main /* OK */
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
  
  RUN pi-carrega-dados.
  
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
  DISPLAY fi-nome-emit fi-cod-rep 
      WITH FRAME f-main IN WINDOW C-Win.
  IF AVAILABLE tt-pagto-vpc THEN 
    DISPLAY tt-pagto-vpc.observacoes 
      WITH FRAME f-main IN WINDOW C-Win.
  IF AVAILABLE tt-vpc THEN 
    DISPLAY tt-vpc.cod-emitente tt-vpc.nr-vpc 
      WITH FRAME f-main IN WINDOW C-Win.
  ENABLE rtToolBar rtKeys rtKeys-2 br-pagamento tt-pagto-vpc.observacoes btOK 
         btCancel btHelp2 
      WITH FRAME f-main IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-f-main}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-dados C-Win 
PROCEDURE pi-carrega-dados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE h-esapi015 AS HANDLE      NO-UNDO.
    DEFINE VARIABLE de-saldo AS DECIMAL     NO-UNDO.

    FOR EACH tt-vpc:
        DELETE tt-vpc.
    END.

    FOR EACH tt-pagto-vpc:
        DELETE tt-pagto-vpc.
    END.

    FIND FIRST vpc NO-LOCK
         WHERE vpc.nr-vpc = p-nr-vpc NO-ERROR.
    IF AVAIL vpc THEN DO:
        CREATE tt-vpc.
        BUFFER-COPY vpc TO tt-vpc.
        ASSIGN tt-vpc.r-rowid = ROWID(vpc).
    END.

    FOR EACH pagto-vpc NO-LOCK
       WHERE pagto-vpc.nr-vpc       = tt-vpc.nr-vpc:

        CREATE tt-pagto-vpc.
        BUFFER-COPY pagto-vpc TO tt-pagto-vpc.
        ASSIGN tt-pagto-vpc.r-rowid = ROWID(pagto-vpc).
    END.

    FIND FIRST emitente NO-LOCK
         WHERE emitente.cod-emitente = tt-vpc.cod-emitente NO-ERROR.
    IF AVAIL emitente THEN
        ASSIGN fi-nome-emit = emitente.nome-emit
               fi-cod-rep   = emitente.cod-rep.
    ELSE
        ASSIGN fi-nome-emit = ""
               fi-cod-rep   = 0.

    {&OPEN-QUERY-br-pagamento}
    ASSIGN br-pagamento:VISIBLE   IN FRAME f-main = YES
           br-pagamento:SENSITIVE IN FRAME f-main = YES
           br-pagamento:TITLE     IN FRAME f-main = "Pagamento / Produto".

    FIND FIRST param-vpc NO-LOCK
         WHERE param-vpc.cod-estabel = tt-vpc.cod-estabel NO-ERROR.

    ASSIGN de-saldo = 0.
    RUN esapi/esapi015.p PERSISTENT SET h-esapi015.
    RUN pi-retorna-saldo-titulo IN h-esapi015 (INPUT tt-vpc.nr-vpc,
                                               OUTPUT de-saldo).
    DELETE PROCEDURE h-esapi015.

    IF tt-vpc.forma-pagto = 2 AND de-saldo > 0 AND AVAIL param-vpc AND LOOKUP(c-seg-usuario,param-vpc.aprovadores) <> 0 THEN /*Somente habilita se vpc estiver liberada*/
        ASSIGN btAddPagto:SENSITIVE     IN FRAME f-main = YES .
    ELSE ASSIGN btAddPagto:SENSITIVE     IN FRAME f-main = NO.

    APPLY "value-changed" TO br-pagamento IN FRAME f-main.

    ASSIGN tt-pagto-vpc.observacoes:SENSITIVE IN FRAME f-main = YES.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

