&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESGTP011 2.00.04.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESGTP011
&GLOBAL-DEFINE Version        2.00.04.000

&GLOBAL-DEFINE WindowType     Master

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Folder1

&GLOBAL-DEFINE page0Widgets   v-cod-cep-ini v-cod-cep-fim v-cod-cep-ini-inc v-cod-cep-fim-inc bt-fil bt-sal bt-del br-cep tg-ativo btExit

&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEF NEW GLOBAL SHARED VAR adm-broker-hdl AS HANDLE NO-UNDO.


/* Temp Table Definitions ---                                          */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-cep

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES int-cep-esedex

/* Definitions for BROWSE br-cep                                        */
&Scoped-define FIELDS-IN-QUERY-br-cep int-cep-esedex.cod-cep-inicial ~
int-cep-esedex.cod-cep-final int-cep-esedex.log-ativo 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-cep 
&Scoped-define QUERY-STRING-br-cep FOR EACH int-cep-esedex ~
      WHERE int-cep-esedex.cod-cep-inicial >= v-cod-cep-ini ~
 AND int-cep-esedex.cod-cep-final <= v-cod-cep-fim NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br-cep OPEN QUERY br-cep FOR EACH int-cep-esedex ~
      WHERE int-cep-esedex.cod-cep-inicial >= v-cod-cep-ini ~
 AND int-cep-esedex.cod-cep-final <= v-cod-cep-fim NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br-cep int-cep-esedex
&Scoped-define FIRST-TABLE-IN-QUERY-br-cep int-cep-esedex


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-br-cep}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS v-cod-cep-ini v-cod-cep-fim bt-fil br-cep ~
v-cod-cep-ini-inc v-cod-cep-fim-inc tg-ativo bt-sal bt-del RECT-1 btExit ~
RECT-2 
&Scoped-Define DISPLAYED-OBJECTS v-cod-cep-ini v-cod-cep-fim ~
v-cod-cep-ini-inc v-cod-cep-fim-inc tg-ativo 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miExit         LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU smHelp 
       MENU-ITEM miContents     LABEL "&Conte£do"     
       MENU-ITEM miAbout        LABEL "&Sobre..."     .

DEFINE MENU mbMain MENUBAR
       SUB-MENU  smFile         LABEL "&Arquivo"      
       SUB-MENU  smHelp         LABEL "&Ajuda"        .


/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-del 
     IMAGE-UP FILE "image\im-era":U
     IMAGE-INSENSITIVE FILE "image\ii-era":U
     LABEL "Eliminar" 
     SIZE 4 BY 1.13 TOOLTIP "Eliminar faixa de CEP"
     FONT 4.

DEFINE BUTTON bt-fil 
     IMAGE-UP FILE "image/im-enter.bmp":U
     LABEL "Filtrar" 
     SIZE 4 BY 1.13 TOOLTIP "Filtrar lista de CEP utilizando a faixa informada"
     FONT 4.

DEFINE BUTTON bt-sal 
     IMAGE-UP FILE "image\im-sav":U
     IMAGE-INSENSITIVE FILE "image\ii-sav":U
     LABEL "Salvar" 
     SIZE 4 BY 1.13 TOOLTIP "Salvar faixa de CEP"
     FONT 4.

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.13 TOOLTIP "Sair"
     FONT 4.

DEFINE VARIABLE v-cod-cep-fim AS CHARACTER FORMAT "x(12)":U INITIAL "99999999" 
     LABEL "CEP Final" 
     VIEW-AS FILL-IN 
     SIZE 20 BY 1 NO-UNDO.

DEFINE VARIABLE v-cod-cep-fim-inc AS CHARACTER FORMAT "99999999":U INITIAL "99999999" 
     LABEL "CEP Final" 
     VIEW-AS FILL-IN 
     SIZE 20 BY 1 NO-UNDO.

DEFINE VARIABLE v-cod-cep-ini AS CHARACTER FORMAT "x(12)":U INITIAL "0" 
     LABEL "CEP Inicial" 
     VIEW-AS FILL-IN 
     SIZE 20 BY 1 NO-UNDO.

DEFINE VARIABLE v-cod-cep-ini-inc AS CHARACTER FORMAT "99999999":U INITIAL "00000000" 
     LABEL "CEP Inicial" 
     VIEW-AS FILL-IN 
     SIZE 20 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 38.57 BY 2.88.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 49 BY 2.88.

DEFINE VARIABLE tg-ativo AS LOGICAL INITIAL no 
     LABEL "Ativo" 
     VIEW-AS TOGGLE-BOX
     SIZE 8 BY .83 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-cep FOR 
      int-cep-esedex SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-cep
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-cep wWindow _STRUCTURED
  QUERY br-cep NO-LOCK DISPLAY
      int-cep-esedex.cod-cep-inicial COLUMN-LABEL "Cep Inicial" FORMAT "x(12)":U
            WIDTH 13.43
      int-cep-esedex.cod-cep-final FORMAT "x(12)":U WIDTH 13.43
      int-cep-esedex.log-ativo FORMAT "yes/no":U WIDTH 6.43
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 89 BY 16
         FONT 1 ROW-HEIGHT-CHARS .68.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     v-cod-cep-ini AT ROW 1.79 COL 13.57 COLON-ALIGNED WIDGET-ID 56
     v-cod-cep-fim AT ROW 2.96 COL 13.57 COLON-ALIGNED WIDGET-ID 70
     bt-fil AT ROW 2.92 COL 35.72 HELP
          "Consultas relacionadas" WIDGET-ID 14
     br-cep AT ROW 4.5 COL 2 WIDGET-ID 200
     v-cod-cep-ini-inc AT ROW 1.79 COL 53.14 COLON-ALIGNED WIDGET-ID 78
     v-cod-cep-fim-inc AT ROW 2.96 COL 53.14 COLON-ALIGNED WIDGET-ID 76
     tg-ativo AT ROW 1.92 COL 76.57 WIDGET-ID 80
     bt-sal AT ROW 2.92 COL 75.57 HELP
          "Confirma altera‡äes" WIDGET-ID 68
     bt-del AT ROW 2.92 COL 79.57 HELP
          "Elimina ocorrˆncia corrente" WIDGET-ID 24
     btExit AT ROW 2.92 COL 86 HELP
          "Sair"
     " Filtro" VIEW-AS TEXT
          SIZE 5 BY .67 AT ROW 1.08 COL 2.57 WIDGET-ID 72
     " Manuten‡Æo" VIEW-AS TEXT
          SIZE 12 BY .67 AT ROW 1.08 COL 42.57 WIDGET-ID 82
     RECT-1 AT ROW 1.42 COL 2 WIDGET-ID 62
     RECT-2 AT ROW 1.42 COL 41.57 WIDGET-ID 74
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90.57 BY 19.83
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
         HEIGHT             = 19.83
         WIDTH              = 90.57
         MAX-HEIGHT         = 27.96
         MAX-WIDTH          = 195.14
         VIRTUAL-HEIGHT     = 27.96
         VIRTUAL-WIDTH      = 195.14
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
/* BROWSE-TAB br-cep bt-fil fpage0 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-cep
/* Query rebuild information for BROWSE br-cep
     _TblList          = "mgesp.int-cep-esedex"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "int-cep-esedex.cod-cep-inicial >= v-cod-cep-ini
 AND int-cep-esedex.cod-cep-final <= v-cod-cep-fim"
     _FldNameList[1]   > mgesp.int-cep-esedex.cod-cep-inicial
"cod-cep-inicial" "Cep Inicial" ? "character" ? ? ? ? ? ? no ? no no "13.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > mgesp.int-cep-esedex.cod-cep-final
"cod-cep-final" ? ? "character" ? ? ? ? ? ? no ? no no "13.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > mgesp.int-cep-esedex.log-ativo
"log-ativo" ? ? "logical" ? ? ? ? ? ? no ? no no "6.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE br-cep */
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


&Scoped-define BROWSE-NAME br-cep
&Scoped-define SELF-NAME br-cep
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-cep wWindow
ON VALUE-CHANGED OF br-cep IN FRAME fpage0 /* Browse 1 */
DO:
    IF  AVAIL int-cep-esedex
    THEN DO:
       DISP int-cep-esedex.cod-cep-inicial @ v-cod-cep-ini-inc
            int-cep-esedex.cod-cep-final   @ v-cod-cep-fim-inc WITH FRAME {&FRAME-NAME}.

       IF  int-cep-esedex.log-ativo = YES
       THEN
           ASSIGN tg-ativo:CHECKED IN FRAME {&FRAME-NAME} = YES.
       ELSE
           ASSIGN tg-ativo:CHECKED IN FRAME {&FRAME-NAME} = NO.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-del
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-del wWindow
ON CHOOSE OF bt-del IN FRAME fpage0 /* Eliminar */
DO:
    IF  AVAIL int-cep-esedex
    THEN DO:
        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 27100,
                           INPUT "Eliminar faixa de CEP?").

        IF  RETURN-VALUE = "yes"
        THEN DO:
            FIND CURRENT int-cep-esedex EXCLUSIVE-LOCK NO-ERROR.

            DELETE int-cep-esedex.
            br-cep:REFRESH().
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-fil
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-fil wWindow
ON CHOOSE OF bt-fil IN FRAME fpage0 /* Filtrar */
DO:
    ASSIGN v-cod-cep-ini = INPUT FRAME {&FRAME-NAME} v-cod-cep-ini
           v-cod-cep-fim = INPUT FRAME {&FRAME-NAME} v-cod-cep-fim.

    {&OPEN-QUERY-br-cep}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-sal
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-sal wWindow
ON CHOOSE OF bt-sal IN FRAME fpage0 /* Salvar */
DO:
    RUN utp/ut-msgs.p (INPUT "show",
                       INPUT 27100,
                       INPUT "Salvar faixa de CEP informada?").

    IF  RETURN-VALUE = "yes"
    THEN DO:
        FIND int-cep-esedex EXCLUSIVE-LOCK
            WHERE int-cep-esedex.cod-cep-inicial = INPUT FRAME {&FRAME-NAME} v-cod-cep-ini-inc
              AND int-cep-esedex.cod-cep-final   = INPUT FRAME {&FRAME-NAME} v-cod-cep-fim-inc NO-ERROR.
    
        IF  NOT AVAIL int-cep-esedex
        THEN DO:
            CREATE int-cep-esedex.
            ASSIGN int-cep-esedex.cod-cep-inicial = INPUT FRAME {&FRAME-NAME} v-cod-cep-ini-inc
                   int-cep-esedex.cod-cep-final   = INPUT FRAME {&FRAME-NAME} v-cod-cep-fim-inc.

            IF  tg-ativo:CHECKED IN FRAME {&FRAME-NAME} = YES
            THEN
                ASSIGN int-cep-esedex.log-ativo = YES.
            ELSE
                ASSIGN int-cep-esedex.log-ativo = NO.

            {&OPEN-QUERY-br-cep}
        END.
        ELSE DO:
            IF  tg-ativo:CHECKED IN FRAME {&FRAME-NAME} = YES
            THEN
                ASSIGN int-cep-esedex.log-ativo = YES.
            ELSE
                ASSIGN int-cep-esedex.log-ativo = NO.
            br-cep:REFRESH().
        END.
    END.
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


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/

{window/mainblock.i}

APPLY "CHOOSE" TO bt-fil IN FRAME {&FRAME-NAME}.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


