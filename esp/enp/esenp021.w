&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcad           PROGRESS
*/
&Scoped-define WINDOW-NAME wWindow


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-estrutura NO-UNDO LIKE estrutura
       field desc-item like item.desc-item
       field desc-comp like item.desc-item.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESENP021 2.00.06.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESENP021
&GLOBAL-DEFINE Version        2.00.06.000

&GLOBAL-DEFINE WindowType     Master

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Folder1

&GLOBAL-DEFINE page0Widgets   v-cod-periodo bt-fil br-estrutura btExit tg-controlado 


&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE h-acomp AS HANDLE      NO-UNDO.
DEFINE BUFFER bitem FOR ITEM.
DEF NEW GLOBAL SHARED VAR adm-broker-hdl AS HANDLE NO-UNDO.
DEFINE VARIABLE c-cod-dcr-item AS CHARACTER   NO-UNDO.

/* Temp Table Definitions ---                                          */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-estrutura

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-estrutura

/* Definitions for BROWSE br-estrutura                                  */
&Scoped-define FIELDS-IN-QUERY-br-estrutura tt-estrutura.it-codigo ~
tt-estrutura.desc-item @ tt-estrutura.desc-item tt-estrutura.es-codigo ~
tt-estrutura.desc-comp @ tt-estrutura.desc-comp tt-estrutura.data-inicio ~
tt-estrutura.data-termino 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-estrutura 
&Scoped-define QUERY-STRING-br-estrutura FOR EACH tt-estrutura NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br-estrutura OPEN QUERY br-estrutura FOR EACH tt-estrutura NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br-estrutura tt-estrutura
&Scoped-define FIRST-TABLE-IN-QUERY-br-estrutura tt-estrutura


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-br-estrutura}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br-estrutura tg-controlado v-cod-periodo ~
bt-fil btExit RECT-1 
&Scoped-Define DISPLAYED-OBJECTS tg-controlado v-cod-periodo 

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
DEFINE BUTTON bt-fil 
     IMAGE-UP FILE "image/im-enter.bmp":U
     LABEL "Filtrar" 
     SIZE 4 BY 1.13 TOOLTIP "Filtrar lista de CEP utilizando a faixa informada"
     FONT 4.

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.13 TOOLTIP "Sair"
     FONT 4.

DEFINE VARIABLE v-cod-periodo AS CHARACTER FORMAT "99/9999":U INITIAL "999999" 
     LABEL "Per¡odo" 
     VIEW-AS FILL-IN 
     SIZE 10 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 89 BY 1.33.

DEFINE VARIABLE tg-controlado AS LOGICAL INITIAL no 
     LABEL "Somente item controlado" 
     VIEW-AS TOGGLE-BOX
     SIZE 22 BY .88
     FONT 1 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-estrutura FOR 
      tt-estrutura SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-estrutura
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-estrutura wWindow _STRUCTURED
  QUERY br-estrutura NO-LOCK DISPLAY
      tt-estrutura.it-codigo FORMAT "x(16)":U WIDTH 9.43
      tt-estrutura.desc-item @ tt-estrutura.desc-item COLUMN-LABEL "Descri‡Æo" FORMAT "x(20)":U
            WIDTH 21.43
      tt-estrutura.es-codigo FORMAT "x(16)":U
      tt-estrutura.desc-comp @ tt-estrutura.desc-comp COLUMN-LABEL "Descri‡Æo" FORMAT "x(20)":U
            WIDTH 22.43
      tt-estrutura.data-inicio FORMAT "99/99/9999":U
      tt-estrutura.data-termino FORMAT "99/99/9999":U WIDTH 9.14
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 90 BY 17.75
         FONT 1.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     br-estrutura AT ROW 3.25 COL 1 WIDGET-ID 200
     tg-controlado AT ROW 1.58 COL 38 WIDGET-ID 74
     v-cod-periodo AT ROW 1.58 COL 15 COLON-ALIGNED WIDGET-ID 56
     bt-fil AT ROW 1.5 COL 27 HELP
          "Consultas relacionadas" WIDGET-ID 14
     btExit AT ROW 1.5 COL 86 HELP
          "Sair"
     " Filtro" VIEW-AS TEXT
          SIZE 5 BY .67 AT ROW 1.08 COL 2.57 WIDGET-ID 72
     RECT-1 AT ROW 1.42 COL 2 WIDGET-ID 62
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90.57 BY 21.46
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-estrutura T "?" NO-UNDO mgcad estrutura
      ADDITIONAL-FIELDS:
          field desc-item like item.desc-item
          field desc-comp like item.desc-item
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 21.46
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
/* BROWSE-TAB br-estrutura 1 fpage0 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-estrutura
/* Query rebuild information for BROWSE br-estrutura
     _TblList          = "Temp-Tables.tt-estrutura"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.tt-estrutura.it-codigo
"tt-estrutura.it-codigo" ? ? "character" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"tt-estrutura.desc-item @ tt-estrutura.desc-item" "Descri‡Æo" "x(20)" ? ? ? ? ? ? ? no ? no no "21.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   = Temp-Tables.tt-estrutura.es-codigo
     _FldNameList[4]   > "_<CALC>"
"tt-estrutura.desc-comp @ tt-estrutura.desc-comp" "Descri‡Æo" "x(20)" ? ? ? ? ? ? ? no ? no no "22.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   = Temp-Tables.tt-estrutura.data-inicio
     _FldNameList[6]   > Temp-Tables.tt-estrutura.data-termino
"tt-estrutura.data-termino" ? ? "date" ? ? ? ? ? ? no ? no no "9.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE br-estrutura */
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


&Scoped-define SELF-NAME bt-fil
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-fil wWindow
ON CHOOSE OF bt-fil IN FRAME fpage0 /* Filtrar */
DO:
   RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
   RUN pi-inicializar IN h-acomp (INPUT "Obtendo informa‡äes...").

    ASSIGN v-cod-periodo = INPUT FRAME {&FRAME-NAME} v-cod-periodo.

    EMPTY TEMP-TABLE tt-estrutura.

    FOR EACH  estrutura NO-LOCK:

        RUN pi-acompanhar IN h-acomp (INPUT "Item: " + estrutura.it-codigo).
    
        IF  (MONTH(estrutura.data-inicio)  = INT(SUBSTR(v-cod-periodo,1,2)) AND 
             YEAR(estrutura.data-inicio)   = INT(SUBSTR(v-cod-periodo,3,4))) OR 
            (MONTH(estrutura.data-termino) = INT(SUBSTR(v-cod-periodo,1,2)) AND  
             YEAR(estrutura.data-termino)  = INT(SUBSTR(v-cod-periodo,3,4)))  
        THEN DO:
             
            FIND ITEM NO-LOCK
              WHERE ITEM.it-codigo = tt-estrutura.it-codigo NO-ERROR.

            IF  AVAIL ITEM THEN DO:
                  IF tg-controlado:CHECKED IN FRAME fpage0 = YES 
                  AND item.cod-dcr-item = "" THEN NEXT.  
                      
                  
            END.


            CREATE tt-estrutura.
            BUFFER-COPY estrutura TO tt-estrutura.

          
            IF AVAIL ITEM THEN
                ASSIGN tt-estrutura.desc-item = ITEM.desc-item.

            FIND bITEM NO-LOCK
                WHERE bITEM.it-codigo = tt-estrutura.es-codigo NO-ERROR.

            IF  AVAIL bITEM
            THEN
                ASSIGN tt-estrutura.desc-comp = bITEM.desc-item.
        END.
    END.

    RUN pi-finalizar IN h-acomp.

    IF  SESSION:SET-WAIT-STATE("general") THEN.
    {&OPEN-QUERY-br-estrutura}
    IF  SESSION:SET-WAIT-STATE("") THEN.
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


&Scoped-define BROWSE-NAME br-estrutura
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/

{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


