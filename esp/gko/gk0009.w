&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
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
{include/i-prgvrs.i GK0009 2.00.06.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        GK0009
&GLOBAL-DEFINE Version        2.00.06.000

&GLOBAL-DEFINE WindowType     Master

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Folder1

&GLOBAL-DEFINE page0Widgets   v-cod-arquivo-gko v-cod-arquivo-ems br-valores bt-fil btExit bt-arq-gko bt-arq-ems 

&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEF NEW GLOBAL SHARED VAR adm-broker-hdl AS HANDLE NO-UNDO.

DEFINE VARIABLE wh-pesquisa   AS HANDLE      NO-UNDO.
DEFINE VARIABLE v-cod-linha   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v-num-linha   AS INTEGER     NO-UNDO.


DEF TEMP-TABLE tt-fecha-gko NO-UNDO
    FIELD cod-lote AS CHAR FORMAT "x(25)"
    FIELD val-cr   AS DEC 
    FIELD val-db   AS DEC
    INDEX id-lote
            cod-lote.

DEF TEMP-TABLE tt-fecha-ems NO-UNDO
    FIELD cod-lote AS CHAR FORMAT "x(25)"
    FIELD val-cr   AS DEC
    FIELD val-db   AS DEC
    INDEX id-lote
            cod-lote.

DEF TEMP-TABLE tt-geral NO-UNDO
    FIELD cod-lote   AS CHAR
    FIELD val-cr-gko AS DEC
    FIELD val-db-gko AS DEC
    FIELD val-cr-ems AS DEC
    FIELD val-db-ems AS DEC
    FIELD val-db-gko-ems AS DEC
    FIELD val-cr-gko-ems AS DEC
    INDEX id-lote
            cod-lote.


/* Temp Table Definitions ---                                          */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-valores

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-geral

/* Definitions for BROWSE br-valores                                    */
&Scoped-define FIELDS-IN-QUERY-br-valores tt-geral.cod-lote tt-geral.val-db-gko tt-geral.val-cr-gko tt-geral.val-db-ems tt-geral.val-cr-ems tt-geral.val-db-gko-ems tt-geral.val-cr-gko-ems   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-valores   
&Scoped-define SELF-NAME br-valores
&Scoped-define QUERY-STRING-br-valores FOR EACH tt-geral
&Scoped-define OPEN-QUERY-br-valores OPEN QUERY {&SELF-NAME} FOR EACH tt-geral.
&Scoped-define TABLES-IN-QUERY-br-valores tt-geral
&Scoped-define FIRST-TABLE-IN-QUERY-br-valores tt-geral


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-br-valores}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS v-cod-arquivo-gko bt-fil br-valores RECT-1 ~
v-cod-arquivo-ems btExit bt-arq-gko bt-arq-ems 
&Scoped-Define DISPLAYED-OBJECTS v-cod-arquivo-gko v-cod-arquivo-ems 

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
DEFINE BUTTON bt-arq-ems 
     IMAGE-UP FILE "image/im-sea1.bmp":U
     LABEL "" 
     SIZE 4 BY 1 TOOLTIP "Localizar arquivo com valores cont beis do EMS".

DEFINE BUTTON bt-arq-gko 
     IMAGE-UP FILE "image/im-sea1.bmp":U
     LABEL "" 
     SIZE 4 BY 1 TOOLTIP "Localizar arquivo com valores cont beis do GKO".

DEFINE BUTTON bt-fil 
     IMAGE-UP FILE "image/im-enter.bmp":U
     LABEL "Filtrar" 
     SIZE 4 BY 1 TOOLTIP "Importar arquivos selecionados"
     FONT 4.

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1 TOOLTIP "Sair"
     FONT 4.

DEFINE VARIABLE v-cod-arquivo-ems AS CHARACTER FORMAT "X(256)":U 
     LABEL "Arquivo EMS" 
     VIEW-AS FILL-IN 
     SIZE 73 BY 1 TOOLTIP "Layout: Lote;Natur (DB/CR);Valor" NO-UNDO.

DEFINE VARIABLE v-cod-arquivo-gko AS CHARACTER FORMAT "X(256)":U 
     LABEL "Arquivo GKO" 
     VIEW-AS FILL-IN 
     SIZE 73 BY 1 TOOLTIP "Layout: Lote;Credito;Debito" NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 101 BY 2.33.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-valores FOR 
      tt-geral SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-valores
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-valores wWindow _FREEFORM
  QUERY br-valores NO-LOCK DISPLAY
      tt-geral.cod-lote       COLUMN-LABEL "Lote"       FORMAT "x(25)"
tt-geral.val-db-gko     COLUMN-LABEL "DB GKO"     FORMAT ">,>>>,>>9.99"
tt-geral.val-cr-gko     COLUMN-LABEL "CR GKO"     FORMAT ">,>>>,>>9.99"
tt-geral.val-db-ems     COLUMN-LABEL "DB EMS"     FORMAT ">,>>>,>>9.99"
tt-geral.val-cr-ems     COLUMN-LABEL "CR EMS"     FORMAT ">,>>>,>>9.99"
tt-geral.val-db-gko-ems COLUMN-LABEL "DB GKO-EMS" FORMAT ">,>>>,>>9.99"
tt-geral.val-cr-gko-ems COLUMN-LABEL "CR GKO-EMS" FORMAT ">,>>>,>>9.99"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 102 BY 15
         FONT 1
         TITLE "" ROW-HEIGHT-CHARS .68 TOOLTIP "Comparativo Cont bil GKO x EMS".


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     v-cod-arquivo-gko AT ROW 1.5 COL 13 COLON-ALIGNED WIDGET-ID 176
     bt-fil AT ROW 1.5 COL 98 HELP
          "Consultas relacionadas" WIDGET-ID 14
     br-valores AT ROW 4 COL 1 WIDGET-ID 200
     v-cod-arquivo-ems AT ROW 2.58 COL 13 COLON-ALIGNED WIDGET-ID 178
     btExit AT ROW 2.5 COL 98 HELP
          "Sair" WIDGET-ID 182
     bt-arq-gko AT ROW 1.5 COL 88 HELP
          "Localiza Arquivo" WIDGET-ID 6
     bt-arq-ems AT ROW 2.54 COL 88 HELP
          "Localiza Arquivo" WIDGET-ID 186
     RECT-1 AT ROW 1.42 COL 2 WIDGET-ID 62
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 103.14 BY 19.5
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 18.17
         WIDTH              = 102.86
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
/* BROWSE-TAB br-valores bt-fil fpage0 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-valores
/* Query rebuild information for BROWSE br-valores
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-geral.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Query            is OPENED
*/  /* BROWSE br-valores */
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


&Scoped-define BROWSE-NAME br-valores
&Scoped-define SELF-NAME br-valores
&Scoped-define SELF-NAME bt-arq-ems
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-arq-ems wWindow
ON CHOOSE OF bt-arq-ems IN FRAME fpage0
DO:
    def var c-arq-conv  as char no-undo.
    def var l-ok        as logical init no.

    assign c-arq-conv ="".

    SYSTEM-DIALOG GET-FILE c-arq-conv
       FILTERS "*.csv" "*.csv"
       DEFAULT-EXTENSION "csv"
       MUST-EXIST
       USE-FILENAME
       TITLE 'Importar do arquivo'
       UPDATE l-ok.

    IF l-ok THEN DO:
        assign v-cod-arquivo-ems = c-arq-conv.
        display v-cod-arquivo-ems with frame {&FRAME-NAME}.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-arq-gko
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-arq-gko wWindow
ON CHOOSE OF bt-arq-gko IN FRAME fpage0
DO:
    def var c-arq-conv  as char no-undo.
    def var l-ok        as logical init no.

    assign c-arq-conv ="".

    SYSTEM-DIALOG GET-FILE c-arq-conv
       FILTERS "*.csv" "*.csv"
       DEFAULT-EXTENSION "csv"
       MUST-EXIST
       USE-FILENAME
       TITLE 'Importar do arquivo'
       UPDATE l-ok.

    IF l-ok THEN DO:
        assign v-cod-arquivo-gko = c-arq-conv.
        display v-cod-arquivo-gko with frame {&FRAME-NAME}.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-fil
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-fil wWindow
ON CHOOSE OF bt-fil IN FRAME fpage0 /* Filtrar */
DO:
  IF  SESSION:SET-WAIT-STATE("general") THEN.

   ASSIGN v-cod-arquivo-gko  = INPUT FRAME {&FRAME-NAME} v-cod-arquivo-gko
          v-cod-arquivo-ems  = INPUT FRAME {&FRAME-NAME} v-cod-arquivo-ems.

   EMPTY TEMP-TABLE tt-fecha-gko.
   EMPTY TEMP-TABLE tt-fecha-ems.
   EMPTY TEMP-TABLE tt-geral.

   ASSIGN v-num-linha = 0.
   INPUT FROM VALUE (v-cod-arquivo-gko).

   REPEAT:
       IMPORT UNFORMATTED v-cod-linha.

       ASSIGN v-num-linha = v-num-linha + 1.

       IF  v-num-linha <> 1
       THEN DO:
           FIND tt-fecha-gko EXCLUSIVE-LOCK
               WHERE tt-fecha-gko.cod-lote = TRIM(ENTRY(1,v-cod-linha,";")) NO-ERROR.

           IF  NOT AVAIL tt-fecha-gko
           THEN DO:
               CREATE tt-fecha-gko.
               ASSIGN tt-fecha-gko.cod-lote = TRIM(ENTRY(1,v-cod-linha,";")).
           END.

           ASSIGN tt-fecha-gko.val-db = tt-fecha-gko.val-db + DEC(TRIM(ENTRY(2,v-cod-linha,";")))
                  tt-fecha-gko.val-cr = tt-fecha-gko.val-cr + DEC(TRIM(ENTRY(3,v-cod-linha,";"))).
       END.
   END.

   INPUT CLOSE.



   ASSIGN v-num-linha = 0.
   INPUT FROM VALUE (v-cod-arquivo-ems).

   REPEAT:
       IMPORT UNFORMATTED v-cod-linha.

       ASSIGN v-num-linha = v-num-linha + 1.

       IF  v-num-linha <> 1
       THEN DO:
           FIND tt-fecha-ems EXCLUSIVE-LOCK
               WHERE tt-fecha-ems.cod-lote = TRIM(ENTRY(1,v-cod-linha,";")) NO-ERROR.

           IF  NOT AVAIL tt-fecha-ems
           THEN DO:
               CREATE tt-fecha-ems.
               ASSIGN tt-fecha-ems.cod-lote = TRIM(ENTRY(1,v-cod-linha,";")).
           END.

           IF  TRIM(ENTRY(2,v-cod-linha,";")) = "DB"
           THEN
               ASSIGN tt-fecha-ems.val-db = tt-fecha-ems.val-db + DEC(TRIM(ENTRY(3,v-cod-linha,";"))).
           ELSE
               ASSIGN tt-fecha-ems.val-cr = tt-fecha-ems.val-cr + DEC(TRIM(ENTRY(3,v-cod-linha,";"))).
       END.
   END.

   INPUT CLOSE.


   FOR EACH tt-fecha-gko NO-LOCK:
       FIND FIRST tt-fecha-ems NO-LOCK
           WHERE  tt-fecha-ems.cod-lote = tt-fecha-gko.cod-lote NO-ERROR.

       CREATE tt-geral.
       ASSIGN tt-geral.cod-lote   = tt-fecha-gko.cod-lote
              tt-geral.val-db-gko = tt-fecha-gko.val-db
              tt-geral.val-cr-gko = tt-fecha-gko.val-cr.

       IF  AVAIL tt-fecha-ems
       THEN
           ASSIGN tt-geral.val-db-ems     = tt-fecha-ems.val-db
                  tt-geral.val-cr-ems     = tt-fecha-ems.val-cr
                  tt-geral.val-db-gko-ems = tt-geral.val-db-gko-ems + (tt-geral.val-db-gko - tt-fecha-ems.val-db)
                  tt-geral.val-cr-gko-ems = tt-geral.val-cr-gko-ems + (tt-geral.val-cr-gko - tt-fecha-ems.val-cr).
       ELSE
           ASSIGN tt-geral.val-db-ems = 0
                  tt-geral.val-cr-ems = 0.
   END.

    {&OPEN-QUERY-br-valores}

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


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/

{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


