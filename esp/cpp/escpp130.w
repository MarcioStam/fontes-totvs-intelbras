&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp            PROGRESS
*/
&Scoped-define WINDOW-NAME wWindow


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-ns-volume-hist NO-UNDO LIKE ns-volume-hist.
DEFINE TEMP-TABLE tt-ns-volume-hist-det NO-UNDO LIKE ns-volume-hist-det.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i escpp130 2.06.00.001}

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i escpp130 mcp}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        escpp130
&GLOBAL-DEFINE Version        1.00.00.001

&GLOBAL-DEFINE WindowType     Master

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btQueryJoins btReportsJoins btExit btHelp ~
                              c-etiqueta br-tt-hist br-tt-hist-det
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE i-id-hist AS INT64       NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-tt-hist

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-ns-volume-hist tt-ns-volume-hist-det

/* Definitions for BROWSE br-tt-hist                                    */
&Scoped-define FIELDS-IN-QUERY-br-tt-hist tt-ns-volume-hist.id-hist ~
tt-ns-volume-hist.data tt-ns-volume-hist.tipo-movto ~
tt-ns-volume-hist.volume-pai tt-ns-volume-hist.sequencia ~
tt-ns-volume-hist.volume-filho tt-ns-volume-hist.cod-usuario ~
tt-ns-volume-hist.cd-programa 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-tt-hist 
&Scoped-define QUERY-STRING-br-tt-hist FOR EACH tt-ns-volume-hist NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br-tt-hist OPEN QUERY br-tt-hist FOR EACH tt-ns-volume-hist NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br-tt-hist tt-ns-volume-hist
&Scoped-define FIRST-TABLE-IN-QUERY-br-tt-hist tt-ns-volume-hist


/* Definitions for BROWSE br-tt-hist-det                                */
&Scoped-define FIELDS-IN-QUERY-br-tt-hist-det tt-ns-volume-hist-det.seq-det ~
tt-ns-volume-hist-det.cod-campo tt-ns-volume-hist-det.valor-antes ~
tt-ns-volume-hist-det.valor-depois 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-tt-hist-det 
&Scoped-define QUERY-STRING-br-tt-hist-det FOR EACH tt-ns-volume-hist-det ~
      WHERE tt-ns-volume-hist-det.id-hist = i-id-hist NO-LOCK
&Scoped-define OPEN-QUERY-br-tt-hist-det OPEN QUERY br-tt-hist-det FOR EACH tt-ns-volume-hist-det ~
      WHERE tt-ns-volume-hist-det.id-hist = i-id-hist NO-LOCK.
&Scoped-define TABLES-IN-QUERY-br-tt-hist-det tt-ns-volume-hist-det
&Scoped-define FIRST-TABLE-IN-QUERY-br-tt-hist-det tt-ns-volume-hist-det


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-br-tt-hist}~
    ~{&OPEN-QUERY-br-tt-hist-det}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar-2 RECT-18 btQueryJoins ~
btReportsJoins btExit btHelp c-etiqueta br-tt-hist br-tt-hist-det 
&Scoped-Define DISPLAYED-OBJECTS c-etiqueta 

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

DEFINE VARIABLE c-etiqueta AS CHARACTER FORMAT "X(18)":U 
     LABEL "Etiqueta" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-18
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 1.25.

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-tt-hist FOR 
      tt-ns-volume-hist SCROLLING.

DEFINE QUERY br-tt-hist-det FOR 
      tt-ns-volume-hist-det SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-tt-hist
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-tt-hist wWindow _STRUCTURED
  QUERY br-tt-hist NO-LOCK DISPLAY
      tt-ns-volume-hist.id-hist COLUMN-LABEL "ID" FORMAT ">>>,>>>,>>>,>>9":U
      tt-ns-volume-hist.data FORMAT "99/99/9999 HH:MM:SS.SSS":U
      tt-ns-volume-hist.tipo-movto FORMAT "x(1)":U
      tt-ns-volume-hist.volume-pai FORMAT "x(18)":U
      tt-ns-volume-hist.sequencia FORMAT ">,>>9":U
      tt-ns-volume-hist.volume-filho FORMAT "x(18)":U
      tt-ns-volume-hist.cod-usuario COLUMN-LABEL "Usuario" FORMAT "x(12)":U
      tt-ns-volume-hist.cd-programa COLUMN-LABEL "Programa" FORMAT "x(30)":U
            WIDTH 25
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 89 BY 6.25
         FONT 1.

DEFINE BROWSE br-tt-hist-det
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-tt-hist-det wWindow _STRUCTURED
  QUERY br-tt-hist-det NO-LOCK DISPLAY
      tt-ns-volume-hist-det.seq-det COLUMN-LABEL "Seq" FORMAT ">,>>9":U
      tt-ns-volume-hist-det.cod-campo COLUMN-LABEL "Campo" FORMAT "x(100)":U
            WIDTH 30
      tt-ns-volume-hist-det.valor-antes COLUMN-LABEL "Valor Antes" FORMAT "x(100)":U
            WIDTH 20
      tt-ns-volume-hist-det.valor-depois COLUMN-LABEL "Valor Depois" FORMAT "x(100)":U
            WIDTH 30
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 89 BY 7.5
         FONT 1 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btQueryJoins AT ROW 1.13 COL 74.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda"
     c-etiqueta AT ROW 2.67 COL 11 COLON-ALIGNED WIDGET-ID 4
     br-tt-hist AT ROW 4 COL 2 WIDGET-ID 200
     br-tt-hist-det AT ROW 10.5 COL 2 WIDGET-ID 300
     rtToolBar-2 AT ROW 1 COL 1
     RECT-18 AT ROW 2.5 COL 1 WIDGET-ID 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17.33
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-ns-volume-hist T "?" NO-UNDO mgesp ns-volume-hist
      TABLE: tt-ns-volume-hist-det T "?" NO-UNDO mgesp ns-volume-hist-det
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 17.33
         WIDTH              = 90
         MAX-HEIGHT         = 17.33
         MAX-WIDTH          = 96.72
         VIRTUAL-HEIGHT     = 17.33
         VIRTUAL-WIDTH      = 96.72
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

{window/window.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWindow
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* BROWSE-TAB br-tt-hist c-etiqueta fpage0 */
/* BROWSE-TAB br-tt-hist-det br-tt-hist fpage0 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-tt-hist
/* Query rebuild information for BROWSE br-tt-hist
     _TblList          = "Temp-Tables.tt-ns-volume-hist"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.tt-ns-volume-hist.id-hist
"id-hist" "ID" ? "int64" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   = Temp-Tables.tt-ns-volume-hist.data
     _FldNameList[3]   = Temp-Tables.tt-ns-volume-hist.tipo-movto
     _FldNameList[4]   = Temp-Tables.tt-ns-volume-hist.volume-pai
     _FldNameList[5]   = Temp-Tables.tt-ns-volume-hist.sequencia
     _FldNameList[6]   = Temp-Tables.tt-ns-volume-hist.volume-filho
     _FldNameList[7]   > Temp-Tables.tt-ns-volume-hist.cod-usuario
"cod-usuario" "Usuario" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.tt-ns-volume-hist.cd-programa
"cd-programa" "Programa" "x(30)" "character" ? ? ? ? ? ? no ? no no "25" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE br-tt-hist */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-tt-hist-det
/* Query rebuild information for BROWSE br-tt-hist-det
     _TblList          = "Temp-Tables.tt-ns-volume-hist-det"
     _Options          = "NO-LOCK"
     _Where[1]         = "Temp-Tables.tt-ns-volume-hist-det.id-hist = i-id-hist"
     _FldNameList[1]   > Temp-Tables.tt-ns-volume-hist-det.seq-det
"tt-ns-volume-hist-det.seq-det" "Seq" ? "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tt-ns-volume-hist-det.cod-campo
"tt-ns-volume-hist-det.cod-campo" "Campo" ? "character" ? ? ? ? ? ? no ? no no "30" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tt-ns-volume-hist-det.valor-antes
"tt-ns-volume-hist-det.valor-antes" "Valor Antes" ? "character" ? ? ? ? ? ? no ? no no "20" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tt-ns-volume-hist-det.valor-depois
"tt-ns-volume-hist-det.valor-depois" "Valor Depois" ? "character" ? ? ? ? ? ? no ? no no "30" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE br-tt-hist-det */
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


&Scoped-define BROWSE-NAME br-tt-hist
&Scoped-define SELF-NAME br-tt-hist
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-tt-hist wWindow
ON VALUE-CHANGED OF br-tt-hist IN FRAME fpage0
DO:
    IF AVAIL tt-ns-volume-hist THEN
        ASSIGN i-id-hist = tt-ns-volume-hist.id-hist.
    ELSE
        ASSIGN i-id-hist = 0.

    {&OPEN-QUERY-br-tt-hist-det}
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


&Scoped-define SELF-NAME c-etiqueta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-etiqueta wWindow
ON RETURN OF c-etiqueta IN FRAME fpage0 /* Etiqueta */
DO:
  
    ASSIGN INPUT FRAME fpage0 c-etiqueta.

    RUN pi-monta-tt.    

    {&OPEN-QUERY-br-tt-hist}

    APPLY 'value-changed' TO br-tt-hist IN FRAME fpage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miAbout
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miAbout wWindow
ON CHOOSE OF MENU-ITEM miAbout /* Sobre... */
DO:
  {include/sobre.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-monta-tt wWindow 
PROCEDURE pi-monta-tt :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE i-id-hist AS INT64       NO-UNDO.

EMPTY TEMP-TABLE tt-ns-volume-hist.
EMPTY TEMP-TABLE tt-ns-volume-hist-det.

FOR EACH  ns-volume-hist-det NO-LOCK
    WHERE ns-volume-hist-det.cod-campo   = "volume-pai"
      AND ns-volume-hist-det.valor-antes = c-etiqueta.
    
    IF NOT CAN-FIND(FIRST tt-ns-volume-hist-det OF ns-volume-hist-det) THEN DO:
        CREATE tt-ns-volume-hist-det.
        BUFFER-COPY ns-volume-hist-det TO tt-ns-volume-hist-det.
    END.    

    ASSIGN i-id-hist = ns-volume-hist-det.id-hist.

    FOR EACH  ns-volume-hist NO-LOCK
        WHERE ns-volume-hist.id-hist = i-id-hist.

        IF NOT CAN-FIND(FIRST tt-ns-volume-hist OF ns-volume-hist) THEN DO:
            CREATE tt-ns-volume-hist.
            BUFFER-COPY ns-volume-hist TO tt-ns-volume-hist.
        END.        
    END.
END.

FOR EACH  ns-volume-hist-det NO-LOCK
    WHERE ns-volume-hist-det.id-hist = i-id-hist.

    IF NOT CAN-FIND(FIRST tt-ns-volume-hist-det OF ns-volume-hist-det) THEN DO:
        CREATE tt-ns-volume-hist-det.
        BUFFER-COPY ns-volume-hist-det TO tt-ns-volume-hist-det.
    END.
END.

ASSIGN i-id-hist = 0.

FOR EACH  ns-volume-hist-det NO-LOCK
    WHERE ns-volume-hist-det.cod-campo    = "volume-pai"
      AND ns-volume-hist-det.valor-depois = c-etiqueta.

    IF NOT CAN-FIND(FIRST tt-ns-volume-hist-det OF ns-volume-hist-det) THEN DO:
   
        CREATE tt-ns-volume-hist-det.
        BUFFER-COPY ns-volume-hist-det TO tt-ns-volume-hist-det.
        
        ASSIGN i-id-hist = ns-volume-hist-det.id-hist.
    END.

    FOR EACH  ns-volume-hist NO-LOCK
        WHERE ns-volume-hist.id-hist = i-id-hist.

        IF NOT CAN-FIND(FIRST tt-ns-volume-hist OF ns-volume-hist) THEN DO:
            CREATE tt-ns-volume-hist.
            BUFFER-COPY ns-volume-hist TO tt-ns-volume-hist.
        END.
    END.
END.

FOR EACH  ns-volume-hist-det NO-LOCK
    WHERE ns-volume-hist-det.id-hist = i-id-hist.

    IF NOT CAN-FIND(FIRST tt-ns-volume-hist-det OF ns-volume-hist-det) THEN DO:
        CREATE tt-ns-volume-hist-det.
        BUFFER-COPY ns-volume-hist-det TO tt-ns-volume-hist-det.
    END.
END.

ASSIGN i-id-hist = 0.

FOR EACH  ns-volume-hist-det NO-LOCK
    WHERE ns-volume-hist-det.cod-campo    = "volume-filho"
      AND ns-volume-hist-det.valor-antes = c-etiqueta.
    
    IF NOT CAN-FIND(FIRST tt-ns-volume-hist-det OF ns-volume-hist-det) THEN DO:
        CREATE tt-ns-volume-hist-det.
        BUFFER-COPY ns-volume-hist-det TO tt-ns-volume-hist-det.    

        ASSIGN i-id-hist = ns-volume-hist-det.id-hist.
    END.

    FOR EACH  ns-volume-hist NO-LOCK
        WHERE ns-volume-hist.id-hist = i-id-hist.

        IF NOT CAN-FIND(FIRST tt-ns-volume-hist OF ns-volume-hist) THEN DO:
            CREATE tt-ns-volume-hist.
            BUFFER-COPY ns-volume-hist TO tt-ns-volume-hist.
        END.
    END.
END.

FOR EACH  ns-volume-hist-det NO-LOCK
    WHERE ns-volume-hist-det.id-hist = i-id-hist.

    IF NOT CAN-FIND(FIRST tt-ns-volume-hist-det OF ns-volume-hist-det) THEN DO:
        CREATE tt-ns-volume-hist-det.
        BUFFER-COPY ns-volume-hist-det TO tt-ns-volume-hist-det.
    END.
END.

ASSIGN i-id-hist = 0.

FOR EACH  ns-volume-hist-det NO-LOCK
    WHERE ns-volume-hist-det.cod-campo    = "volume-filho"
      AND ns-volume-hist-det.valor-depois = c-etiqueta.

    IF NOT CAN-FIND(FIRST tt-ns-volume-hist-det OF ns-volume-hist-det) THEN DO:
    
        CREATE tt-ns-volume-hist-det.
        BUFFER-COPY ns-volume-hist-det TO tt-ns-volume-hist-det.

        ASSIGN i-id-hist = ns-volume-hist-det.id-hist.
    END.

    FOR EACH  ns-volume-hist NO-LOCK
        WHERE ns-volume-hist.id-hist = i-id-hist.

        IF NOT CAN-FIND(FIRST tt-ns-volume-hist OF ns-volume-hist) THEN DO:
            CREATE tt-ns-volume-hist.
            BUFFER-COPY ns-volume-hist TO tt-ns-volume-hist.
        END.
    END.
END.

FOR EACH  ns-volume-hist-det NO-LOCK
    WHERE ns-volume-hist-det.id-hist = i-id-hist.

    IF NOT CAN-FIND(FIRST tt-ns-volume-hist-det OF ns-volume-hist-det) THEN DO:
        CREATE tt-ns-volume-hist-det.
        BUFFER-COPY ns-volume-hist-det TO tt-ns-volume-hist-det.
    END.
END.

FOR EACH  ns-volume-hist NO-LOCK
    WHERE ns-volume-hist.volume-filho = c-etiqueta.
   
    IF NOT CAN-FIND(FIRST tt-ns-volume-hist OF ns-volume-hist) THEN DO:
        CREATE tt-ns-volume-hist.
        BUFFER-COPY ns-volume-hist TO tt-ns-volume-hist.
    END.

    FOR EACH ns-volume-hist-det OF ns-volume-hist NO-LOCK.

        IF NOT CAN-FIND(FIRST tt-ns-volume-hist-det OF ns-volume-hist-det) THEN DO:
            CREATE tt-ns-volume-hist-det.
            BUFFER-COPY ns-volume-hist-det TO tt-ns-volume-hist-det.
        END.
    END.
END.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

