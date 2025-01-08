&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME wWindow


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-int-emitente-historico NO-UNDO LIKE int-emitente-historico.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESCDP006 2.04.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESCDP006
&GLOBAL-DEFINE Version        2.04.00.000

&GLOBAL-DEFINE WindowType     master

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    0
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   br-int-emitente-historico ed-motivo btExit btHelp btFechar
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER p-tipo         AS INTEGER NO-UNDO.
DEFINE INPUT PARAMETER p-cod-emitente AS INTEGER NO-UNDO.

DEFINE VARIABLE c-sit-fornec AS CHARACTER FORMAT 'X(40)'  NO-UNDO.
/* Local Variable Definitions ---                                       */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-int-emitente-historico

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-int-emitente-historico

/* Definitions for BROWSE br-int-emitente-historico                     */
&Scoped-define FIELDS-IN-QUERY-br-int-emitente-historico ~
tt-int-emitente-historico.sequencia ~
fnSitFornec (tt-int-emitente-historico.ind-sit-emitente) @  c-sit-fornec ~
tt-int-emitente-historico.dt-movto tt-int-emitente-historico.hr-movto ~
tt-int-emitente-historico.usuario 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-int-emitente-historico 
&Scoped-define QUERY-STRING-br-int-emitente-historico FOR EACH tt-int-emitente-historico NO-LOCK ~
    BY tt-int-emitente-historico.sequencia DESCENDING INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br-int-emitente-historico OPEN QUERY br-int-emitente-historico FOR EACH tt-int-emitente-historico NO-LOCK ~
    BY tt-int-emitente-historico.sequencia DESCENDING INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br-int-emitente-historico ~
tt-int-emitente-historico
&Scoped-define FIRST-TABLE-IN-QUERY-br-int-emitente-historico tt-int-emitente-historico


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-br-int-emitente-historico}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br-int-emitente-historico ed-motivo btFechar ~
btExit btHelp fi-cod-emitente fi-nome-emit rtToolBar-2 rtToolBar RECT-1 ~
RECT-2 
&Scoped-Define DISPLAYED-OBJECTS ed-motivo fi-cod-emitente fi-nome-emit 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnSitFornec wWindow 
FUNCTION fnSitFornec RETURNS CHARACTER
  ( p-sit AS INT)  FORWARD.

/* _UIB-CODE-BLOCK-END */
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

DEFINE BUTTON btFechar 
     LABEL "Fechar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image\im-hel":U
     IMAGE-INSENSITIVE FILE "image\ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE VARIABLE ed-motivo AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
     SIZE 75.72 BY 2.63 NO-UNDO.

DEFINE VARIABLE fi-cod-emitente AS INTEGER FORMAT ">>>>>>>>9" INITIAL 0 
     LABEL "C¢digo":R8 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nome-emit AS CHARACTER FORMAT "X(40)" 
     VIEW-AS FILL-IN 
     SIZE 52.57 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 78 BY 1.5.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 78 BY 10.38.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 80 BY 1.42
     BGCOLOR 7 .

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 80 BY 1.5
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-int-emitente-historico FOR 
      tt-int-emitente-historico SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-int-emitente-historico
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-int-emitente-historico wWindow _STRUCTURED
  QUERY br-int-emitente-historico NO-LOCK DISPLAY
      tt-int-emitente-historico.sequencia FORMAT "->,>>>,>>9":U
            WIDTH 7
      fnSitFornec (tt-int-emitente-historico.ind-sit-emitente) @  c-sit-fornec COLUMN-LABEL "Situaá∆o Fornec" FORMAT "x(35)":U
            WIDTH 25
      tt-int-emitente-historico.dt-movto FORMAT "99/99/9999":U
            WIDTH 10.57
      tt-int-emitente-historico.hr-movto FORMAT "x(8)":U WIDTH 13.43
      tt-int-emitente-historico.usuario FORMAT "x(8)":U WIDTH 19.86
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 75.72 BY 6.63
         FONT 1
         TITLE "Hist¢rico Ativaá∆o/Desativaá∆o" FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     br-int-emitente-historico AT ROW 4.63 COL 3.29 WIDGET-ID 200
     ed-motivo AT ROW 11.92 COL 3.29 NO-LABEL WIDGET-ID 10
     btFechar AT ROW 15.17 COL 2
     btExit AT ROW 1.13 COL 72.57 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 76.57 HELP
          "Ajuda"
     fi-cod-emitente AT ROW 3.08 COL 10.43 COLON-ALIGNED WIDGET-ID 2
     fi-nome-emit AT ROW 3.08 COL 19.72 COLON-ALIGNED HELP
          "Nome Completo do Emitente" NO-LABEL WIDGET-ID 4
     "Motivo:" VIEW-AS TEXT
          SIZE 8 BY .54 AT ROW 11.29 COL 3.29 WIDGET-ID 12
     rtToolBar-2 AT ROW 1 COL 1
     rtToolBar AT ROW 14.96 COL 1
     RECT-1 AT ROW 2.75 COL 2.14 WIDGET-ID 6
     RECT-2 AT ROW 4.38 COL 2.14 WIDGET-ID 8
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80.14 BY 15.42
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: tt-int-emitente-historico T "?" NO-UNDO mgesp int-emitente-historico
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 15.42
         WIDTH              = 80.14
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 90
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
   FRAME-NAME Custom                                                    */
/* BROWSE-TAB br-int-emitente-historico 1 fpage0 */
ASSIGN 
       ed-motivo:READ-ONLY IN FRAME fpage0        = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-int-emitente-historico
/* Query rebuild information for BROWSE br-int-emitente-historico
     _TblList          = "Temp-Tables.tt-int-emitente-historico"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _OrdList          = "Temp-Tables.tt-int-emitente-historico.sequencia|no"
     _FldNameList[1]   > Temp-Tables.tt-int-emitente-historico.sequencia
"sequencia" ? ? "integer" ? ? ? ? ? ? no ? no no "7" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"fnSitFornec (tt-int-emitente-historico.ind-sit-emitente) @  c-sit-fornec" "Situaá∆o Fornec" "x(30)" ? ? ? ? ? ? ? no ? no no "30" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tt-int-emitente-historico.dt-movto
"dt-movto" ? ? "date" ? ? ? ? ? ? no ? no no "10.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tt-int-emitente-historico.hr-movto
"hr-movto" ? ? "character" ? ? ? ? ? ? no ? no no "13.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.tt-int-emitente-historico.usuario
"usuario" ? ? "character" ? ? ? ? ? ? no ? no no "19.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE br-int-emitente-historico */
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


&Scoped-define BROWSE-NAME br-int-emitente-historico
&Scoped-define SELF-NAME br-int-emitente-historico
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-int-emitente-historico wWindow
ON VALUE-CHANGED OF br-int-emitente-historico IN FRAME fpage0 /* Hist¢rico Ativaá∆o/Desativaá∆o */
DO:
    IF AVAIL tt-int-emitente-historico THEN DO:
        ASSIGN ed-motivo:SCREEN-VALUE IN FRAME fPage0 = tt-int-emitente-historico.motivo.
    END.
    ELSE ASSIGN ed-motivo:SCREEN-VALUE IN FRAME fPage0 = "".
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


&Scoped-define SELF-NAME btFechar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFechar wWindow
ON CHOOSE OF btFechar IN FRAME fpage0 /* Fechar */
DO:
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


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


RUN pi-carrega-dados.

/*:T--- L¢gica para inicializaá∆o do programam ---*/
{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wWindow 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    APPLY "VALUE-CHANGED" TO br-int-emitente-historico IN FRAME fPage0.
    br-int-emitente-historico:SELECT-FOCUSED-ROW().

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
    FOR EACH tt-int-emitente-historico NO-LOCK:
        DELETE tt-int-emitente-historico.
    END.
    FIND FIRST emitente NO-LOCK
         WHERE emitente.cod-emitente = p-cod-emitente NO-ERROR.
    IF AVAIL emitente THEN DO:
        FIND FIRST int-emitente NO-LOCK
             WHERE int-emitente.cod-emitente = emitente.cod-emitente NO-ERROR.
        IF AVAIL int-emitente THEN DO:
            ASSIGN fi-cod-emitente:SCREEN-VALUE IN FRAME fPage0 = STRING(emitente.cod-emitente)
                   fi-nome-emit:SCREEN-VALUE IN FRAME fPage0    = emitente.nome-emit.
            IF CAN-FIND(FIRST int-emitente-historico NO-LOCK
                        WHERE int-emitente-historico.cod-emitente = emitente.cod-emitente 
                          AND int-emitente-historico.tipo         = p-tipo) THEN DO:
                FOR EACH int-emitente-historico NO-LOCK
                   WHERE int-emitente-historico.cod-emitente = emitente.cod-emitente
                     AND int-emitente-historico.tipo         = p-tipo:
                    CREATE tt-int-emitente-historico.
                    BUFFER-COPY int-emitente-historico TO tt-int-emitente-historico.
                END.
                {&OPEN-QUERY-br-int-emitente-historico}

            END.
            ELSE DO:
                MESSAGE "N∆o existe hist¢rico de Ativaá∆o/Desativaá∆o para emitente: " emitente.cod-emitente
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.
                APPLY "close" TO THIS-PROCEDURE.
            END.
        END.
        ELSE DO:
            MESSAGE "N∆o existe extens∆o para emitente: " emitente.cod-emitente
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
            APPLY "close" TO THIS-PROCEDURE.
        END.
    END.
    ELSE DO:
        MESSAGE "Emitente: " p-cod-emitente " n∆o cadastrado!"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
        APPLY "close" TO THIS-PROCEDURE.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnSitFornec wWindow 
FUNCTION fnSitFornec RETURNS CHARACTER
  ( p-sit AS INT) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN {diinc/i01di275.i 04 p-sit}.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

