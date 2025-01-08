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

&SCOPED-DEFINE banco mgcad              

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

DEFINE TEMP-TABLE tt-notas 
    FIELD cod-estabel LIKE nota-fiscal.cod-estabel
    FIELD serie       LIKE nota-fiscal.serie
    FIELD nr-nota-fis LIKE nota-fiscal.nr-nota-fis
    FIELD cod-emitente LIKE emitente.cod-emitente
    FIELD dt-emis-nota LIKE nota-fiscal.dt-emis-nota
    FIELD nome-emit    LIKE emitente.nome-emit
    FIELD it-codigo   LIKE it-nota-fisc.it-codigo
    FIELD nr-seq-fat  LIKE it-nota-fisc.nr-seq-fat
    FIELD qt-faturada AS DEC LABEL "Qtdade Faturada"
    FIELD nro-docto   LIKE devol-cli.nro-docto
    FIELD serie-docto LIKE devol-cli.serie-docto 
    FIELD qt-devolvida LIKE devol-cli.qt-devolvida
    FIELD qt-saldo     AS DECIMAL.


/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def new Global shared var c-seg-usuario        as char format "x(12)" no-undo.

DEF VAR h-acomp      as handle no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-notas

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-notas

/* Definitions for BROWSE br-notas                                      */
&Scoped-define FIELDS-IN-QUERY-br-notas tt-notas.cod-estabel tt-notas.serie tt-notas.nr-nota-fis tt-notas.dt-emis-nota tt-notas.cod-emitente tt-notas.nome-emit tt-notas.it-codigo tt-notas.nro-docto tt-notas.serie-docto tt-notas.qt-faturada tt-notas.qt-devolvida tt-notas.qt-saldo   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-notas   
&Scoped-define SELF-NAME br-notas
&Scoped-define QUERY-STRING-br-notas FOR EACH tt-notas BY tt-notas.dt-emis-nota                                           BY tt-notas.cod-emitente                                           BY tt-notas.nr-nota-fis
&Scoped-define OPEN-QUERY-br-notas OPEN QUERY {&SELF-NAME} FOR EACH tt-notas BY tt-notas.dt-emis-nota                                           BY tt-notas.cod-emitente                                           BY tt-notas.nr-nota-fis.
&Scoped-define TABLES-IN-QUERY-br-notas tt-notas
&Scoped-define FIRST-TABLE-IN-QUERY-br-notas tt-notas


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-br-notas}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar-2 rtToolBar RECT-7 RECT-9 IMAGE-7 ~
IMAGE-9 btQueryJoins btReportsJoins btExit btHelp c-cod-estabel i-opcoes ~
c-serie c-nr-nota-ini c-nat-operacao c-cliente c-atendente BUTTON-1 ~
dt-data-inicial dt-data-final br-notas btOK btCancel btHelp2 
&Scoped-Define DISPLAYED-OBJECTS c-cod-estabel i-opcoes c-serie ~
c-nr-nota-ini c-nat-operacao c-cliente c-atendente dt-data-inicial ~
dt-data-final 

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
DEFINE BUTTON btCancel 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image\im-hel":U
     IMAGE-INSENSITIVE FILE "image\ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btHelp2 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE BUTTON btQueryJoins 
     IMAGE-UP FILE "image\im-joi":U
     IMAGE-INSENSITIVE FILE "image\ii-joi":U
     LABEL "Query Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btReportsJoins 
     IMAGE-UP FILE "image\im-pri":U
     IMAGE-INSENSITIVE FILE "image\ii-pri":U
     LABEL "Reports Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "adeicon/check.bmp":U
     LABEL "Button 1" 
     SIZE 5 BY 1.13.

DEFINE VARIABLE c-atendente AS CHARACTER FORMAT "X(256)":U 
     LABEL "Atendente" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .79 NO-UNDO.

DEFINE VARIABLE c-cliente AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .79 NO-UNDO.

DEFINE VARIABLE c-cod-estabel AS CHARACTER FORMAT "X(256)":U 
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .79 NO-UNDO.

DEFINE VARIABLE c-nat-operacao AS CHARACTER FORMAT "X(256)":U INITIAL "694945,594945,594935,694935" 
     LABEL "Naturezas de Opera‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 44 BY 1.5 NO-UNDO.

DEFINE VARIABLE c-nr-nota-ini AS CHARACTER FORMAT "X(256)":U INITIAL "0" 
     LABEL "Nota Fiscal" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .79 NO-UNDO.

DEFINE VARIABLE c-serie AS CHARACTER FORMAT "X(256)":U 
     LABEL "Serie" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .79 NO-UNDO.

DEFINE VARIABLE dt-data-final AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 13 BY .79 NO-UNDO.

DEFINE VARIABLE dt-data-inicial AS DATE FORMAT "99/99/9999":U 
     LABEL "Data EmissÆo" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .79 NO-UNDO.

DEFINE IMAGE IMAGE-7
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-9
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE VARIABLE i-opcoes AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Com Retorno", 1,
"Sem Retorno", 2,
"Ambos", 3
     SIZE 16 BY 3 NO-UNDO.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 126.72 BY 10.5.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 32 BY 3.5.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 128 BY 1.42
     BGCOLOR 7 .

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 127 BY 1.5
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-notas FOR 
      tt-notas SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-notas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-notas wWindow _FREEFORM
  QUERY br-notas DISPLAY
      tt-notas.cod-estabel 
      tt-notas.serie       
      tt-notas.nr-nota-fis  FORMAT "x(07)"
      tt-notas.dt-emis-nota
      tt-notas.cod-emitente FORMAT ">>>>>>9"
      tt-notas.nome-emit   
      tt-notas.it-codigo    FORMAT "x(10)"
      tt-notas.nro-docto    FORMAT "x(07)"
      tt-notas.serie-docto 
      tt-notas.qt-faturada  FORMAT ">>>,>>>"
      tt-notas.qt-devolvida COLUMN-LABEL "Qt.Devolvida" FORMAT ">>>,>>>"
      tt-notas.qt-saldo     LABEL "Saldo" FORMAT ">>>,>>>"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 123.14 BY 9.83
         FONT 1
         TITLE "Notas Fiscais:" FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btQueryJoins AT ROW 1.08 COL 111 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.08 COL 115 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.08 COL 119 HELP
          "Sair"
     btHelp AT ROW 1.08 COL 123 HELP
          "Ajuda"
     c-cod-estabel AT ROW 3 COL 38 COLON-ALIGNED WIDGET-ID 104
     i-opcoes AT ROW 3.5 COL 103 NO-LABEL WIDGET-ID 88
     c-serie AT ROW 4 COL 38 COLON-ALIGNED WIDGET-ID 106
     c-nr-nota-ini AT ROW 5 COL 38 COLON-ALIGNED WIDGET-ID 110
     c-nat-operacao AT ROW 6 COL 38 COLON-ALIGNED WIDGET-ID 82
     c-cliente AT ROW 7.75 COL 38 COLON-ALIGNED WIDGET-ID 80
     c-atendente AT ROW 8.75 COL 38 COLON-ALIGNED WIDGET-ID 114
     BUTTON-1 AT ROW 9.5 COL 77 WIDGET-ID 78
     dt-data-inicial AT ROW 9.75 COL 38 COLON-ALIGNED WIDGET-ID 86
     dt-data-final AT ROW 9.75 COL 62 COLON-ALIGNED NO-LABEL WIDGET-ID 84
     br-notas AT ROW 11.25 COL 4 WIDGET-ID 300
     btOK AT ROW 21.71 COL 2
     btCancel AT ROW 21.71 COL 13
     btHelp2 AT ROW 21.75 COL 118
     "Listar Notas" VIEW-AS TEXT
          SIZE 10 BY .75 AT ROW 3 COL 93 WIDGET-ID 94
     rtToolBar-2 AT ROW 1 COL 1
     rtToolBar AT ROW 21.5 COL 1
     RECT-7 AT ROW 10.75 COL 2.29 WIDGET-ID 48
     RECT-9 AT ROW 3.25 COL 92 WIDGET-ID 92
     IMAGE-7 AT ROW 9.75 COL 54 WIDGET-ID 96
     IMAGE-9 AT ROW 9.75 COL 60 WIDGET-ID 100
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 128.57 BY 22.33
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
         TITLE              = "ESFTP064 - Notas sem Retorno - Assistˆncia T‚cnica"
         HEIGHT             = 22.33
         WIDTH              = 128.57
         MAX-HEIGHT         = 28.75
         MAX-WIDTH          = 142.29
         VIRTUAL-HEIGHT     = 28.75
         VIRTUAL-WIDTH      = 142.29
         MAX-BUTTON         = no
         RESIZE             = no
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
   FRAME-NAME                                                           */
/* BROWSE-TAB br-notas dt-data-final fpage0 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-notas
/* Query rebuild information for BROWSE br-notas
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-notas BY tt-notas.dt-emis-nota
                                          BY tt-notas.cod-emitente
                                          BY tt-notas.nr-nota-fis.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-notas */
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
ON END-ERROR OF wWindow /* ESFTP064 - Notas sem Retorno - Assistˆncia T‚cnica */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-CLOSE OF wWindow /* ESFTP064 - Notas sem Retorno - Assistˆncia T‚cnica */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wWindow
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancelar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wWindow
ON CHOOSE OF btExit IN FRAME fpage0 /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wWindow
ON CHOOSE OF btHelp IN FRAME fpage0 /* Help */
OR CHOOSE OF MENU-ITEM miContents IN MENU mbMain DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp2 wWindow
ON CHOOSE OF btHelp2 IN FRAME fpage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wWindow
ON CHOOSE OF btOK IN FRAME fpage0 /* OK */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btQueryJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btQueryJoins wWindow
ON CHOOSE OF btQueryJoins IN FRAME fpage0 /* Query Joins */
OR CHOOSE OF MENU-ITEM miQueryJoins IN MENU mbMain DO:
    RUN showQueryJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btReportsJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReportsJoins wWindow
ON CHOOSE OF btReportsJoins IN FRAME fpage0 /* Reports Joins */
OR CHOOSE OF MENU-ITEM miReportsJoins IN MENU mbMain DO:
    RUN showReportsJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 wWindow
ON CHOOSE OF BUTTON-1 IN FRAME fpage0 /* Button 1 */
DO:
    RUN pi-carrega-notas.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-notas
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
  ASSIGN dt-data-inicial:SCREEN-VALUE IN FRAME fpage0 = string(TODAY - 60)
         dt-data-final:SCREEN-VALUE IN FRAME fpage0 = string(TODAY)
         c-nat-operacao:SCREEN-VALUE IN FRAME fpage0 = "694945,594945,594935,694935"
         c-nr-nota-ini:SCREEN-VALUE IN FRAME fpage0 = "0".
  DISPLAY c-nat-operacao 
          dt-data-inicial
          dt-data-final
          c-cliente 
          c-nr-nota-ini WITH FRAME f-page0.

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

  ENABLE ALL WITH FRAME fPage0.

  {&OPEN-BROWSERS-IN-QUERY-fPage0}
  VIEW wWindow.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carga wWindow 
PROCEDURE pi-carga :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
           DEFINE VARIABLE i-cont      AS INTEGER     NO-UNDO.
           DEFINE VARIABLE l-tem-saldo AS LOGICAL     NO-UNDO.
           IF c-atendente:SCREEN-VALUE IN FRAME fpage0 <> "" THEN DO:
               FIND ped-venda
                    WHERE ped-venda.nr-pedcli = nota-fiscal.nr-pedcli
                      AND ped-venda.nome-abrev = nota-fiscal.nome-ab-cli
                    NO-LOCK NO-ERROR.
               IF AVAIL ped-venda THEN DO:
                   IF ped-venda.tp-pedido <> c-atendente:SCREEN-VALUE IN FRAME fpage0 THEN NEXT.
               END.
               ELSE NEXT.
           END.
               
           DO TRANS:
                CREATE tt-notas.
                ASSIGN tt-notas.cod-estabel     = nota-fiscal.cod-estabel
                       tt-notas.serie           = nota-fiscal.serie
                       tt-notas.nr-nota-fis     = nota-fiscal.nr-nota-fis
                       tt-notas.dt-emis-nota    = nota-fiscal.dt-emis-nota
                       tt-notas.cod-emitente    = nota-fiscal.cod-emitente
                       tt-notas.nome-emit       = emitente.nome-emit
                       tt-notas.it-codigo       = it-nota-fisc.it-codigo
                       tt-notas.nr-seq-fat      = it-nota-fisc.nr-seq-fat
                       tt-notas.qt-faturada     = it-nota-fisc.qt-faturada[1].  

                ASSIGN i-cont = 0
                       l-tem-saldo = NO.

                FOR EACH devol-cli NO-LOCK
                    WHERE devol-cli.cod-emitente = nota-fiscal.cod-emitente
                      AND devol-cli.serie        = nota-fiscal.serie
                      AND devol-cli.nr-nota-fis  = nota-fiscal.nr-nota-fis
                      AND devol-cli.it-codigo    = it-nota-fisc.it-codigo
                      AND devol-cli.nr-sequencia = it-nota-fisc.nr-seq-fat:
                    ASSIGN i-cont = i-cont + 1.
                    IF i-cont <> 1 THEN DO:
                        CREATE tt-notas.
                        ASSIGN tt-notas.cod-estabel     = nota-fiscal.cod-estabel
                               tt-notas.serie           = nota-fiscal.serie
                               tt-notas.nr-nota-fis     = nota-fiscal.nr-nota-fis
                               tt-notas.dt-emis-nota    = nota-fiscal.dt-emis-nota
                               tt-notas.cod-emitente    = nota-fiscal.cod-emitente
                               tt-notas.nome-emit       = emitente.nome-emit
                               tt-notas.it-codigo       = it-nota-fisc.it-codigo
                               tt-notas.nr-seq-fat      = it-nota-fisc.nr-seq-fat
                               tt-notas.qt-faturada     = it-nota-fisc.qt-faturada[1].  
                    END.
                    ASSIGN tt-notas.nro-docto    = devol-cli.nro-docto
                           tt-notas.serie-docto  = devol-cli.serie-docto
                           tt-notas.qt-devolvida = devol-cli.qt-devolvida
                           tt-notas.qt-saldo     = tt-notas.qt-faturada - devol-cli.qt-devolvida.
                    IF int(i-opcoes:SCREEN-VALUE IN FRAME fpage0) = 2 AND
                       tt-notas.qt-saldo = 0 THEN DO: 
                       DELETE tt-notas.
                       NEXT.
                    END.

                    IF tt-notas.qt-saldo > 0 THEN 
                       ASSIGN l-tem-saldo = YES.
                END.
                IF AVAIL tt-notas THEN
                    ASSIGN tt-notas.qt-saldo     = tt-notas.qt-faturada - tt-notas.qt-devolvida.
                IF int(i-opcoes:SCREEN-VALUE IN FRAME fpage0) = 1 and
                   i-cont = 0 THEN UNDO,LEAVE.
                IF int(i-opcoes:SCREEN-VALUE IN FRAME fpage0) = 2 AND
                   (i-cont > 0 and
                    NOT l-tem-saldo) THEN UNDO,LEAVE.

           END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-notas wWindow 
PROCEDURE pi-carrega-notas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF VAR i-cont AS INTEGER.
    DEF VAR i-hora-ini AS INTEGER.
    FOR EACH tt-notas:
        DELETE tt-notas.
    END.                
    IF int(c-nr-nota-ini:SCREEN-VALUE IN FRAME fpage0) <> 0  THEN
        FOR EACH nota-fiscal  NO-LOCK
            WHERE nota-fiscal.cod-estabel  = c-cod-estabel:SCREEN-VALUE IN FRAME fpage0
              AND nota-fiscal.serie        = c-serie:SCREEN-VALUE IN FRAME fpage0
              AND nota-fiscal.nr-nota-fis  = c-nr-nota-ini:SCREEN-VALUE IN FRAME fpage0,
            FIRST emitente NO-LOCK
            WHERE emitente.cod-emitente = nota-fiscal.cod-emitente,
              EACH  it-nota-fisc OF nota-fiscal NO-LOCK:
            RUN pi-carga.
        END.
    ELSE
        IF INT(c-cliente:SCREEN-VALUE IN FRAME fpage0) = 0 THEN DO:
            do i-cont = 1 to num-entries(c-nat-operacao:SCREEN-VALUE IN FRAME fpage0):
                if entry(i-cont, c-nat-operacao:SCREEN-VALUE IN FRAME fpage0) = "" then next.
    
                FOR EACH nota-fiscal USE-INDEX ch-distancia NO-LOCK
                    WHERE nota-fiscal.dt-emis-nota >= date(dt-data-inicial:SCREEN-VALUE IN FRAME fpage0)
                      AND nota-fiscal.dt-emis-nota <= date(dt-data-final:SCREEN-VALUE IN FRAME fpage0)
                      AND nota-fiscal.nat-operacao = entry(i-cont, c-nat-operacao:SCREEN-VALUE IN FRAME fpage0),
                    FIRST emitente NO-LOCK
                    WHERE emitente.cod-emitente = nota-fiscal.cod-emitente,
                      EACH  it-nota-fisc OF nota-fiscal NO-LOCK:
                    RUN pi-carga.
                END.
                
            END.
        END.
        ELSE DO:
            do i-cont = 1 to num-entries(c-nat-operacao:SCREEN-VALUE IN FRAME fpage0):
                if entry(i-cont, c-nat-operacao:SCREEN-VALUE IN FRAME fpage0) = "" then next.
    
                FOR EACH nota-fiscal  NO-LOCK
                    WHERE nota-fiscal.dt-emis-nota >= date(dt-data-inicial:SCREEN-VALUE IN FRAME fpage0)
                      AND nota-fiscal.dt-emis-nota <= date(dt-data-final:SCREEN-VALUE IN FRAME fpage0)
                      AND nota-fiscal.nat-operacao = entry(i-cont, c-nat-operacao:SCREEN-VALUE IN FRAME fpage0)
                      AND nota-fiscal.cod-emitente = INT(c-cliente:SCREEN-VALUE IN FRAME fpage0),
                    FIRST emitente NO-LOCK
                    WHERE emitente.cod-emitente = nota-fiscal.cod-emitente,
                      EACH  it-nota-fisc OF nota-fiscal NO-LOCK:
                    RUN pi-carga.
                END.
                
            END.
    
        END.

        
    {&open-query-br-notas}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

