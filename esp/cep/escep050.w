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

&GLOBAL-DEFINE Program        escep050
&GLOBAL-DEFINE Version        2.04.000.000
&SCOPED-DEFINE RPC-CALL       esp/cep/escep050rpc.r


/* Local Variable Definitions ---                                       */
def new global shared var v_cod_usuar_corren as char no-undo.
DEF NEW GLOBAL SHARED VAR v_rotina_intelbras AS CHAR NO-UNDO.

DEF VAR hprog AS HANDLE NO-UNDO.
DEF VAR hproc AS HANDLE NO-UNDO.

DEF VAR de-saldo        AS DEC  FORMAT ">>,>>>,>>9".
DEF VAR de-saldo-rec    AS DEC  FORMAT ">>,>>>,>>9".

{esp/es0018.i}
{esp/utp/acesso-rpc.i}
{esp/cep/escep050.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-aes

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-aes tt-saldo

/* Definitions for BROWSE br-aes                                        */
&Scoped-define FIELDS-IN-QUERY-br-aes tt-aes.nr-ae tt-aes.sequencia tt-aes.quantidade tt-aes.data tt-aes.cod-depos tt-aes.localizacao   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-aes   
&Scoped-define SELF-NAME br-aes
&Scoped-define OPEN-QUERY-br-aes  IF INPUT FRAME fPage0 rs-tipo = 1 THEN    OPEN QUERY {&SELF-NAME} FOR EACH tt-aes                                 BY tt-aes.data                                 BY tt-aes.nr-ae                                 BY tt-aes.sequencia. ELSE    OPEN QUERY {&SELF-NAME} FOR EACH tt-aes                                 BY tt-aes.data                                 BY tt-aes.localizacao.
&Scoped-define TABLES-IN-QUERY-br-aes tt-aes
&Scoped-define FIRST-TABLE-IN-QUERY-br-aes tt-aes


/* Definitions for BROWSE br-saldo                                      */
&Scoped-define FIELDS-IN-QUERY-br-saldo tt-saldo.cod-depos tt-saldo.cod-localiz tt-saldo.quantidade   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-saldo   
&Scoped-define SELF-NAME br-saldo
&Scoped-define QUERY-STRING-br-saldo FOR EACH tt-saldo
&Scoped-define OPEN-QUERY-br-saldo OPEN QUERY {&SELF-NAME} FOR EACH tt-saldo.
&Scoped-define TABLES-IN-QUERY-br-saldo tt-saldo
&Scoped-define FIRST-TABLE-IN-QUERY-br-saldo tt-saldo


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-br-aes}~
    ~{&OPEN-QUERY-br-saldo}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS fi-it-codigo fi-cod-estab fi-cod-depos-ini ~
fi-cod-depos-fim rs-tipo btCarrega br-aes br-saldo btReportsJoins btExit ~
rtToolBar-2 rtKeys RECT-1 RECT-37 IMAGE-1 IMAGE-2 
&Scoped-Define DISPLAYED-OBJECTS fi-it-codigo fi-desc-item fi-cod-estab ~
fi-cod-depos-ini fi-cod-depos-fim rs-tipo i-saldo-alm de-quantidade ~
fi-cod-localiz 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miQueryJoins   LABEL "&Consultas"    
       MENU-ITEM miReportsJoins LABEL "&Relat¢rios"   
       RULE
       MENU-ITEM miExit         LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU smHelp 
       MENU-ITEM miContents     LABEL "&Conte£do"     
       MENU-ITEM miAbout        LABEL "&Sobre..."     .

DEFINE MENU mbMain MENUBAR
       SUB-MENU  smFile         LABEL "&Arquivo"      
       SUB-MENU  smHelp         LABEL "&Ajuda"        .


/* Definitions of the field level widgets                               */
DEFINE BUTTON btCarrega 
     IMAGE-UP FILE "image\im-enter":U
     IMAGE-INSENSITIVE FILE "image\ii-enter":U
     LABEL "Go To" 
     SIZE 4 BY 1.25.

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btReportsJoins 
     IMAGE-UP FILE "image\im-pri":U
     IMAGE-INSENSITIVE FILE "image\ii-pri":U
     LABEL "Reports Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE VARIABLE de-quantidade AS DECIMAL FORMAT "->>,>>>,>>9.99":U INITIAL 0 
     LABEL "Qtde AE" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-depos-fim AS CHARACTER FORMAT "X(256)":U INITIAL "ZZZ" 
     VIEW-AS FILL-IN 
     SIZE 5.29 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-depos-ini AS CHARACTER FORMAT "X(256)":U 
     LABEL "Dep¢sito" 
     VIEW-AS FILL-IN 
     SIZE 5.29 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-estab AS CHARACTER FORMAT "X(03)":U 
     LABEL "Estabel" 
     VIEW-AS FILL-IN 
     SIZE 5.29 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-localiz AS CHARACTER FORMAT "x(20)" 
     LABEL "Localizaá∆o":R14 
     VIEW-AS FILL-IN 
     SIZE 20.57 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-item AS CHARACTER FORMAT "x(60)" 
     VIEW-AS FILL-IN 
     SIZE 57.72 BY .88.

DEFINE VARIABLE fi-it-codigo AS CHARACTER FORMAT "x(16)" 
     LABEL "Item":R5 
     VIEW-AS FILL-IN 
     SIZE 12.57 BY .88.

DEFINE VARIABLE i-saldo-alm AS DECIMAL FORMAT "->>,>>>,>>9.99":U INITIAL 0 
     LABEL "Total Saldo Sel" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-2
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE VARIABLE rs-tipo AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Total", 1,
"Parcial", 2
     SIZE 19 BY .75 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 33.14 BY 3.71.

DEFINE RECTANGLE RECT-37
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 89.43 BY 15.25.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.72 BY 2.5.

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-aes FOR 
      tt-aes SCROLLING.

DEFINE QUERY br-saldo FOR 
      tt-saldo SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-aes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-aes wWindow _FREEFORM
  QUERY br-aes DISPLAY
      tt-aes.nr-ae         
    tt-aes.sequencia     
    tt-aes.quantidade    
    tt-aes.data          
    tt-aes.cod-depos     COLUMN-LABEL "Dep¢sito"
    tt-aes.localizacao   COLUMN-LABEL "Localizaá∆o"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 54 BY 14.96
         FONT 1 FIT-LAST-COLUMN.

DEFINE BROWSE br-saldo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-saldo wWindow _FREEFORM
  QUERY br-saldo DISPLAY
      tt-saldo.cod-depos    COLUMN-LABEL "Dep¢sito" 
    tt-saldo.cod-localiz  COLUMN-LABEL "Localizaá∆o" FORMAT "X(20)" 
    tt-saldo.quantidade
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 33.14 BY 11
         FONT 1 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     fi-it-codigo AT ROW 3 COL 8.57 COLON-ALIGNED WIDGET-ID 8
     fi-desc-item AT ROW 3 COL 21.29 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     fi-cod-estab AT ROW 4.08 COL 8.57 COLON-ALIGNED HELP
          "Estabelecimento" WIDGET-ID 40
     fi-cod-depos-ini AT ROW 4.08 COL 24.86 COLON-ALIGNED WIDGET-ID 4
     fi-cod-depos-fim AT ROW 4.08 COL 37.29 COLON-ALIGNED NO-LABEL WIDGET-ID 2
     rs-tipo AT ROW 4.13 COL 58.29 NO-LABEL WIDGET-ID 34
     btCarrega AT ROW 3.5 COL 83.57 HELP
          "V† Para" WIDGET-ID 26
     br-aes AT ROW 5.54 COL 2 WIDGET-ID 200
     br-saldo AT ROW 5.54 COL 56.86 WIDGET-ID 300
     i-saldo-alm AT ROW 17.25 COL 74 COLON-ALIGNED WIDGET-ID 20
     de-quantidade AT ROW 18.25 COL 74 COLON-ALIGNED WIDGET-ID 18
     fi-cod-localiz AT ROW 19.21 COL 66 COLON-ALIGNED WIDGET-ID 16
     btReportsJoins AT ROW 1.13 COL 82.57 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 86.72 HELP
          "Sair"
     "Tipo:" VIEW-AS TEXT
          SIZE 4 BY .54 AT ROW 4.21 COL 53.86 WIDGET-ID 38
     rtToolBar-2 AT ROW 1 COL 1
     rtKeys AT ROW 2.75 COL 1.29 WIDGET-ID 12
     RECT-1 AT ROW 16.79 COL 56.86 WIDGET-ID 22
     RECT-37 AT ROW 5.38 COL 1.29 WIDGET-ID 28
     IMAGE-1 AT ROW 4.08 COL 32.57 WIDGET-ID 30
     IMAGE-2 AT ROW 4.08 COL 36 WIDGET-ID 32
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 19.75
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
         TITLE              = "Consulta Saldo AE - ESCEP050 - Sem Bancos"
         HEIGHT             = 19.75
         WIDTH              = 90
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

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU mbMain:HANDLE.
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
/* BROWSE-TAB br-aes btCarrega fpage0 */
/* BROWSE-TAB br-saldo br-aes fpage0 */
ASSIGN 
       br-aes:COLUMN-RESIZABLE IN FRAME fpage0       = TRUE.

ASSIGN 
       br-saldo:COLUMN-RESIZABLE IN FRAME fpage0       = TRUE.

/* SETTINGS FOR FILL-IN de-quantidade IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-cod-localiz IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-desc-item IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-saldo-alm IN FRAME fpage0
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-aes
/* Query rebuild information for BROWSE br-aes
     _START_FREEFORM

IF INPUT FRAME fPage0 rs-tipo = 1 THEN
   OPEN QUERY {&SELF-NAME} FOR EACH tt-aes
                                BY tt-aes.data
                                BY tt-aes.nr-ae
                                BY tt-aes.sequencia.
ELSE
   OPEN QUERY {&SELF-NAME} FOR EACH tt-aes
                                BY tt-aes.data
                                BY tt-aes.localizacao.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-aes */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-saldo
/* Query rebuild information for BROWSE br-saldo
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-saldo.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-saldo */
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
ON END-ERROR OF wWindow /* Consulta Saldo AE - ESCEP050 - Sem Bancos */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.

  RUN piDesconecta.
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  QUIT.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-CLOSE OF wWindow /* Consulta Saldo AE - ESCEP050 - Sem Bancos */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-aes
&Scoped-define SELF-NAME br-aes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-aes wWindow
ON MOUSE-SELECT-DBLCLICK OF br-aes IN FRAME fpage0
DO:
  APPLY "return" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-aes wWindow
ON RETURN OF br-aes IN FRAME fpage0
DO:
  IF AVAIL tt-aes THEN DO:
      RUN esp/cep/escep050a.w (INPUT hproc, INPUT tt-aes.roteiro).
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCarrega
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCarrega wWindow
ON CHOOSE OF btCarrega IN FRAME fpage0 /* Go To */
DO:
    RUN pi-carrega-dados IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wWindow
ON CHOOSE OF btExit IN FRAME fpage0 /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    RUN piDesconecta.
    APPLY "CLOSE":U TO THIS-PROCEDURE.
    QUIT.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btReportsJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReportsJoins wWindow
ON CHOOSE OF btReportsJoins IN FRAME fpage0 /* Reports Joins */
DO:
    RUN pi-gera-relatorio.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cod-depos-fim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-depos-fim wWindow
ON RETURN OF fi-cod-depos-fim IN FRAME fpage0
DO:
    APPLY "choose" TO btCarrega IN FRAME fPage0.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cod-depos-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-depos-ini wWindow
ON RETURN OF fi-cod-depos-ini IN FRAME fpage0 /* Dep¢sito */
DO:
    APPLY "choose" TO btCarrega IN FRAME fPage0.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cod-estab
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-estab wWindow
ON RETURN OF fi-cod-estab IN FRAME fpage0 /* Estabel */
DO:
    APPLY "choose" TO btCarrega IN FRAME fPage0.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-it-codigo wWindow
ON RETURN OF fi-it-codigo IN FRAME fpage0 /* Item */
DO:
    APPLY "choose" TO btCarrega IN FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs-tipo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-tipo wWindow
ON VALUE-CHANGED OF rs-tipo IN FRAME fpage0
DO:
    APPLY "choose" TO btCarrega IN FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/* ***************************  Main Block  *************************** */

RUN conecta-rpc IN THIS-PROCEDURE (output hproc).
IF RETURN-VALUE = "NOK" THEN DO:
  RUN pi-message(1, "Erro na conex∆o com o servidor RPC",
                 "N∆o foi poss°vel conectar o servidor RPC. Entre em contato com o respons†vel em TI").
  APPLY "CLOSE":U TO THIS-PROCEDURE.
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

  IF NOT VALID-HANDLE(hproc) THEN DO:
      RUN conecta-rpc IN THIS-PROCEDURE (output hproc).
      IF RETURN-VALUE = "NOK" THEN DO:
          RUN ShowMessage (1, "Erro na conex∆o com o servidor RPC", 
                              "N∆o foi poss°vel conectar o servidor RPC. Entre em contato com o respons†vel em TI").
          APPLY "CLOSE":U TO THIS-PROCEDURE.
          QUIT.
      END.
  END.

  ASSIGN v_rotina_intelbras = "escep050".

  RUN esp/utp/esbtb910zz.w (INPUT hproc, INPUT "{&Program}|{&Version}").
  IF RETURN-VALUE = "NOK" THEN DO:
      RUN piDesconecta.
      APPLY "CLOSE":U TO THIS-PROCEDURE.
      QUIT.
  END.

  RUN pi-inicia.
  IF VALID-HANDLE(hprog) THEN DO:
      SESSION:SET-WAIT-STATE("GENERAL":U).
      ASSIGN fi-cod-estab = "".
      RUN pi-retorna-estab-usuario IN hprog (INPUT v_cod_usuar_corren,
                                             OUTPUT fi-cod-estab).
      SESSION:SET-WAIT-STATE("":U).
      DELETE PROCEDURE hprog.
      hprog = ?.
  END.
  ELSE DO:
      MESSAGE "N∆o foi poss°vel conectar ao servidor RPC. Favor fazer login novamente."
          VIEW-AS ALERT-BOX INFO BUTTONS OK.
  END.

  DISP fi-cod-estab WITH FRAME fPage0.

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
    ASSIGN INPUT FRAME fPage0 fi-it-codigo
           INPUT FRAME fPage0 fi-cod-estab
           INPUT FRAME fPage0 fi-cod-depos-ini
           INPUT FRAME fPage0 fi-cod-depos-fim
           INPUT FRAME fPage0 rs-tipo.

   for each tt-aes:
       delete tt-aes.
   end.
   for each tt-saldo:
       delete tt-saldo.
   end.

    {&OPEN-QUERY-br-aes}
    {&OPEN-QUERY-br-saldo}

    RUN pi-inicia.
    IF VALID-HANDLE(hprog) THEN DO:
        SESSION:SET-WAIT-STATE("GENERAL":U).
        RUN pi-carrega-dados IN hprog (INPUT fi-cod-estab,
                                       INPUT fi-it-codigo,     
                                       INPUT fi-cod-depos-ini, 
                                       INPUT fi-cod-depos-fim, 
                                       INPUT rs-tipo,        
                                       OUTPUT fi-desc-item,
                                       OUTPUT fi-cod-localiz,
                                       OUTPUT de-quantidade,  
                                       OUTPUT de-saldo,       
                                       OUTPUT de-saldo-rec, 
                                       OUTPUT i-saldo-alm,  
                                       OUTPUT TABLE tt-aes,
                                       OUTPUT TABLE tt-saldo).
        SESSION:SET-WAIT-STATE("":U).
        DELETE PROCEDURE hprog.
        hprog = ?.

        IF RETURN-VALUE <> "" THEN DO:
            MESSAGE RETURN-VALUE
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
        END.
    END.
    ELSE DO:
        MESSAGE "N∆o foi poss°vel conectar ao servidor RPC. Favor fazer login novamente."
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END.

    {&OPEN-QUERY-br-aes}
    {&OPEN-QUERY-br-saldo}

    DISP de-quantidade
         i-saldo-alm 
         fi-cod-localiz
         fi-desc-item
         WITH FRAME fPage0.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-relatorio wWindow 
PROCEDURE pi-gera-relatorio :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-arquivo   AS CHARACTER              NO-UNDO.
    DEFINE VARIABLE l-saldos    AS LOGICAL   INITIAL YES  NO-UNDO.

    IF CAN-FIND(FIRST b-tt-aes) THEN DO:
        ASSIGN c-arquivo = "c:\temp\escep050.lst".

        form header 
             "Item.:" fi-it-codigo  "-"
                      fi-desc-item  skip
             "Local: " fi-cod-localiz
             "Saldo: "  de-saldo
             "QTD AE: " de-quantidade  
             "REC:"     de-saldo-rec skip
             fill("-",90) format "x(90)"      SKIP(2)
             WITH PAGE-TOP WIDTH 132 FRAME header-frame NO-LABELS STREAM-IO.

        OUTPUT TO VALUE(c-arquivo).

        view frame header-frame.

        for each b-tt-aes
              by b-tt-aes.data
              by b-tt-aes.nr-ae
              by b-tt-aes.sequencia:


           if l-saldos then DO:
               DISP b-tt-aes 
                    WITH FRAME f-1 DOWN WIDTH 132 NO-BOX STREAM-IO.
               DOWN WITH FRAME f-1.
           END.
           ELSE DO:
               disp b-tt-aes EXCEPT b-tt-aes.quantidade 
                    WITH FRAME f-1 DOWN WIDTH 132 NO-BOX STREAM-IO.
               DOWN WITH FRAME f-1.
           END.
        END.

        if l-saldos then do:
            disp skip(3) "SALDOS" skip
                         "------" WITH STREAM-IO.
        
            for each b-tt-saldo no-lock
                break by b-tt-saldo.cod-depos:
                disp b-tt-saldo.cod-depos
                     b-tt-saldo.cod-localiz
                     b-tt-saldo.quantidade format "->>,>>>,>>9.99" 
                     (total by b-tt-saldo.cod-depos)
                     with NO-LABELS STREAM-IO.
            end.
        end.  

        OUTPUT CLOSE.

        OS-COMMAND NO-WAIT notepad VALUE(c-arquivo).
    END.
    ELSE DO:
        MESSAGE "Relat¢rio s¢ pode ser gerado ap¢s carregar os dados."
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-inicia wWindow 
PROCEDURE pi-inicia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR first-time AS LOGICAL NO-UNDO INIT YES.  

  DO WHILE NOT VALID-HANDLE(hprog):
      RUN {&RPC-CALL} PERSISTENT SET hprog ON SERVER hproc TRANSACTION DISTINCT NO-ERROR.
      IF NOT VALID-HANDLE(hproc) THEN DO:
          IF first-time THEN
              RUN conecta-rpc IN THIS-PROCEDURE (output hproc).
          ELSE DO:
              RUN ShowMessage (1, "Erro na execuá∆o", 
                                  "Ocorreu um erro durante a execuá∆o de um procedimento " +
                                  "remoto que impede que esta operaá∆o continue.~n" +
                                  "Por favor repita esta operaá∆o mais tarde").
              QUIT.
          END.
      END.
      IF VALID-HANDLE(hprog) THEN RETURN.
      PAUSE 1.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piDesconecta wWindow 
PROCEDURE piDesconecta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   IF VALID-HANDLE(hprog) THEN DO:
       DELETE PROCEDURE hprog.
       hprog = ?.
   END.
    
   RUN desconecta-rpc IN THIS-PROCEDURE (INPUT hproc).
   hproc = ?.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

