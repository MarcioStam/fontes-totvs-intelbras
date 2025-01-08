&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i cd0303-upcb 1.00.00.000}

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i cd0303-upcb cdp}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        cd0303-upcb
&GLOBAL-DEFINE Version        1.00.00.000

&GLOBAL-DEFINE WindowType     Master/Detail

&GLOBAL-DEFINE Folder         no
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Situa‡Æo

&GLOBAL-DEFINE page0Widgets   btQueryJoins btReportsJoins btExit btHelp ~
                              btOK btCancel btHelp2 
&GLOBAL-DEFINE page1Widgets   fi-cod-estab-ini fi-cod-estab-fim fi-nat-operacao-ini fi-nat-operacao-fim  brSit bt-buscar ~
                              fi-ncm-ini fi-ncm-fim fi-it-codigo-ini fi-it-codigo-fim fi-cod-emitente-ini fi-cod-emitente-fim
&GLOBAL-DEFINE page2Widgets   

/* Local Variable Definitions ---                                       */
define temp-table tt-sit-tribut-relacto LIKE sit-tribut-relacto
      FIELD r-row-table AS ROWID.

DEF NEW GLOBAL SHARED VAR g-h-window-cd0303 AS WIDGET-HANDLE no-undo.
DEF NEW GLOBAL SHARED VAR wh-DBOSon-cd0303  AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-brSon1-cd0303  AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR g-cdn-tirbut-cd0303      AS INTEGER NO-UNDO.
DEF NEW GLOBAL SHARED VAR g-cdn-sit-tirbut-cd0303  AS INTEGER NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brSit

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-sit-tribut-relacto

/* Definitions for BROWSE brSit                                         */
&Scoped-define FIELDS-IN-QUERY-brSit tt-sit-tribut-relacto.cdn-sit-tribut tt-sit-tribut-relacto.cdn-tribut (IF tt-sit-tribut-relacto.idi-tip-docto = 1 THEN "E" ELSE "S") tt-sit-tribut-relacto.cod-estab tt-sit-tribut-relacto.dat-valid-inic tt-sit-tribut-relacto.cod-natur-operac tt-sit-tribut-relacto.cod-ncm tt-sit-tribut-relacto.cod-item tt-sit-tribut-relacto.cdn-emitente   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSit   
&Scoped-define SELF-NAME brSit
&Scoped-define QUERY-STRING-brSit FOR EACH tt-sit-tribut-relacto
&Scoped-define OPEN-QUERY-brSit OPEN QUERY {&SELF-NAME} FOR EACH tt-sit-tribut-relacto.
&Scoped-define TABLES-IN-QUERY-brSit tt-sit-tribut-relacto
&Scoped-define FIRST-TABLE-IN-QUERY-brSit tt-sit-tribut-relacto


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brSit}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar-2 rtToolBar btQueryJoins ~
btReportsJoins btExit btHelp btOK btCancel btHelp2 

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

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE BUTTON bt-buscar 
     LABEL "Buscar" 
     SIZE 11 BY .88.

DEFINE VARIABLE fi-cod-emitente-fim AS INTEGER FORMAT ">>>>>>>>9" INITIAL 999999999 
     VIEW-AS FILL-IN 
     SIZE 13.29 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-emitente-ini AS INTEGER FORMAT ">>>>>>>>9" INITIAL 0 
     LABEL "Emitente" 
     VIEW-AS FILL-IN 
     SIZE 13.29 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-estab-fim AS CHARACTER FORMAT "X(5)":U INITIAL "ZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 5.86 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-estab-ini AS CHARACTER FORMAT "X(5)":U 
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 5.86 BY .88 NO-UNDO.

DEFINE VARIABLE fi-it-codigo-fim AS CHARACTER FORMAT "x(12)" INITIAL "ZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 13.29 BY .88 NO-UNDO.

DEFINE VARIABLE fi-it-codigo-ini AS CHARACTER FORMAT "x(16)" 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 13.29 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nat-operacao-fim AS CHARACTER FORMAT "X(6)":U INITIAL "ZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 7.86 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nat-operacao-ini AS CHARACTER FORMAT "X(6)":U 
     LABEL "Nat Operacao" 
     VIEW-AS FILL-IN 
     SIZE 7.86 BY .88 NO-UNDO.

DEFINE VARIABLE fi-ncm-fim AS CHARACTER FORMAT "x(08)" INITIAL "ZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 13.29 BY .88 NO-UNDO.

DEFINE VARIABLE fi-ncm-ini AS CHARACTER FORMAT "x(08)" 
     LABEL "Classificacao Fiscal" 
     VIEW-AS FILL-IN 
     SIZE 13.29 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-11
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-15
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-16
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-17
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-18
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-19
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-20
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-21
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-22
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-23
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 86 BY 5.54.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 86 BY 7.04.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brSit FOR 
      tt-sit-tribut-relacto SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brSit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSit wWindow _FREEFORM
  QUERY brSit DISPLAY
      tt-sit-tribut-relacto.cdn-sit-tribut LABEL "C¢digo" 
      tt-sit-tribut-relacto.cdn-tribut
      (IF tt-sit-tribut-relacto.idi-tip-docto = 1 THEN "E" ELSE "S") LABEL "E/S"
      tt-sit-tribut-relacto.cod-estab LABEL "Estab"
      tt-sit-tribut-relacto.dat-valid-inic LABEL  "Dt In¡cio"
      tt-sit-tribut-relacto.cod-natur-operac LABEL "Nat Oper"
      tt-sit-tribut-relacto.cod-ncm LABEL "Class Fiscal"
      tt-sit-tribut-relacto.cod-item LABEL "Item"
      tt-sit-tribut-relacto.cdn-emitente LABEL "Emitente"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 84 BY 6.5
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
     btOK AT ROW 16.75 COL 2
     btCancel AT ROW 16.75 COL 13
     btHelp2 AT ROW 16.75 COL 80
     rtToolBar-2 AT ROW 1 COL 1
     rtToolBar AT ROW 16.54 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17.04
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage1
     fi-cod-estab-ini AT ROW 1.5 COL 33.57 COLON-ALIGNED WIDGET-ID 2
     fi-cod-estab-fim AT ROW 1.5 COL 50.43 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     fi-nat-operacao-ini AT ROW 2.5 COL 31.57 COLON-ALIGNED WIDGET-ID 12
     fi-nat-operacao-fim AT ROW 2.5 COL 50.43 COLON-ALIGNED NO-LABEL WIDGET-ID 18
     fi-ncm-ini AT ROW 3.5 COL 26.14 COLON-ALIGNED HELP
          "C¢digo Nomenclatura Comum do Mercosul" WIDGET-ID 20
     fi-ncm-fim AT ROW 3.5 COL 50.43 COLON-ALIGNED HELP
          "C¢digo Nomenclatura Comum do Mercosul" NO-LABEL WIDGET-ID 26
     fi-it-codigo-ini AT ROW 4.5 COL 26.14 COLON-ALIGNED HELP
          "C¢digo Nomenclatura Comum do Mercosul" WIDGET-ID 30
     fi-it-codigo-fim AT ROW 4.5 COL 50.43 COLON-ALIGNED HELP
          "C¢digo Nomenclatura Comum do Mercosul" NO-LABEL WIDGET-ID 28
     fi-cod-emitente-ini AT ROW 5.5 COL 26.14 COLON-ALIGNED HELP
          "C¢digo Nomenclatura Comum do Mercosul" WIDGET-ID 36
     fi-cod-emitente-fim AT ROW 5.5 COL 50.43 COLON-ALIGNED HELP
          "C¢digo Nomenclatura Comum do Mercosul" NO-LABEL WIDGET-ID 42
     bt-buscar AT ROW 5.58 COL 76 WIDGET-ID 50
     brSit AT ROW 7.75 COL 3 WIDGET-ID 200
     "Parƒmetros Cadastrados:" VIEW-AS TEXT
          SIZE 18.14 BY .54 AT ROW 6.88 COL 3.86 WIDGET-ID 56
     IMAGE-11 AT ROW 1.5 COL 42 WIDGET-ID 4
     IMAGE-15 AT ROW 1.5 COL 49 WIDGET-ID 6
     IMAGE-16 AT ROW 2.5 COL 42 WIDGET-ID 14
     IMAGE-17 AT ROW 2.5 COL 49 WIDGET-ID 16
     IMAGE-18 AT ROW 3.5 COL 42 WIDGET-ID 22
     IMAGE-19 AT ROW 3.5 COL 49 WIDGET-ID 24
     IMAGE-20 AT ROW 4.5 COL 42 WIDGET-ID 32
     IMAGE-21 AT ROW 4.5 COL 49 WIDGET-ID 34
     IMAGE-22 AT ROW 5.5 COL 42 WIDGET-ID 38
     IMAGE-23 AT ROW 5.5 COL 49 WIDGET-ID 40
     RECT-10 AT ROW 1.21 COL 2 WIDGET-ID 52
     RECT-11 AT ROW 7.25 COL 2 WIDGET-ID 54
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2 ROW 2.75
         SIZE 88 BY 13.5
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
         HEIGHT             = 17.04
         WIDTH              = 90
         MAX-HEIGHT         = 19.79
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 19.79
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
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
ASSIGN 
       btExit:HIDDEN IN FRAME fpage0           = TRUE.

ASSIGN 
       btHelp:HIDDEN IN FRAME fpage0           = TRUE.

ASSIGN 
       btQueryJoins:HIDDEN IN FRAME fpage0           = TRUE.

ASSIGN 
       btReportsJoins:HIDDEN IN FRAME fpage0           = TRUE.

ASSIGN 
       rtToolBar-2:HIDDEN IN FRAME fpage0           = TRUE.

/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB brSit bt-buscar fPage1 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSit
/* Query rebuild information for BROWSE brSit
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-sit-tribut-relacto.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE brSit */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage1
/* Query rebuild information for FRAME fPage1
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage1 */
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


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME bt-buscar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-buscar wWindow
ON CHOOSE OF bt-buscar IN FRAME fPage1 /* Buscar */
DO:
   
    
    def var h-acomp          as handle  no-undo.
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
    RUN pi-inicializar IN h-acomp (INPUT "Parƒmetros").

    EMPTY TEMP-TABLE tt-sit-tribut-relacto.
    DO WITH FRAME fpage1:
        FOR EACH sit-tribut-relacto NO-LOCK
            WHERE sit-tribut-relacto.cdn-tribut        = g-cdn-tirbut-cd0303 
              AND sit-tribut-relacto.cdn-sit-tribut   =  g-cdn-sit-tirbut-cd0303
              AND sit-tribut-relacto.cod-estab        >= fi-cod-estab-ini:SCREEN-VALUE
              AND sit-tribut-relacto.cod-estab        <= fi-cod-estab-fim:SCREEN-VALUE
              AND sit-tribut-relacto.cod-natur-operac >= fi-nat-operacao-ini:SCREEN-VALUE
              AND sit-tribut-relacto.cod-natur-operac <= fi-nat-operacao-fim:SCREEN-VALUE
              AND sit-tribut-relacto.cod-ncm          >= fi-ncm-ini:SCREEN-VALUE
              AND sit-tribut-relacto.cod-ncm          <= fi-ncm-fim:SCREEN-VALUE
              AND sit-tribut-relacto.cod-item         >= fi-it-codigo-ini:SCREEN-VALUE
              AND sit-tribut-relacto.cod-item         <= fi-it-codigo-fim:SCREEN-VALUE
              AND sit-tribut-relacto.cdn-emitente     >= int(fi-cod-emitente-ini:SCREEN-VALUE)
              AND sit-tribut-relacto.cdn-emitente     <= int(fi-cod-emitente-fim:SCREEN-VALUE)
            ,FIRST sit-tribut  FIELDS(cdn-sit-tribut)
                WHERE sit-tribut.cdn-sit-tribut = sit-tribut-relacto.cdn-sit-tribut
                 AND sit-tribut.cdn-tribut = g-cdn-tirbut-cd0303  NO-LOCK:
    
            RUN pi-acompanhar IN h-acomp (INPUT "Buscando Parametros item " + sit-tribut-relacto.cod-item).
            CREATE tt-sit-tribut-relacto.
            BUFFER-COPY sit-tribut-relacto TO tt-sit-tribut-relacto.
            ASSIGN tt-sit-tribut-relacto.r-row-table = ROWID(sit-tribut-relacto).
        END.
    END.

    RUN pi-finalizar IN h-acomp.

    /*
    ON 'row-display':U OF brObservacoes IN FRAME fPage1 DO:
        ASSIGN /******************** fonte da linha *************************/
               tt-observacoes.observacao:FGCOLOR IN BROWSE brObservacoes = 12. /*11*/
    END.
    */
    
    {&open-query-brSit}


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
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
    
    IF  AVAIL tt-sit-tribut-relacto THEN DO:
        
        FIND sit-tribut NO-LOCK
            WHERE sit-tribut.cdn-sit-tribut = tt-sit-tribut-relacto.cdn-sit-tribut NO-ERROR.

        IF  AVAIL sit-tribut THEN 
          
            RUN repositionRecord IN g-h-window-cd0303:INSTANTIATING-PROCEDURE(INPUT ROWID(sit-tribut)).
            
            RUN repositionRecordSon IN g-h-window-cd0303:INSTANTIATING-PROCEDURE(INPUT tt-sit-tribut-relacto.r-row-table ,1).  
           
    END.
       
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


&Scoped-define SELF-NAME miAbout
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miAbout wWindow
ON CHOOSE OF MENU-ITEM miAbout /* Sobre... */
DO:
  {include/sobre.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brSit
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterInitializeInterface wWindow 
PROCEDURE AfterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/*
ON 'row-display':U OF brObservacoes IN FRAME fPage1 DO:
    ASSIGN /******************** fonte da linha *************************/
           tt-observacoes.observacao:FGCOLOR IN BROWSE brObservacoes = 12. /*11*/
END.
*/
ENABLE brSit WITH FRAME fpage1.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

