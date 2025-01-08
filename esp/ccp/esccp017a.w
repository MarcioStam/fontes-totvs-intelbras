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
{include/i-prgvrs.i esccp017A 2.04.00.001}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        esccp017A
&GLOBAL-DEFINE Version        1

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Sele‡Æo, Parƒmetros

&GLOBAL-DEFINE page0Widgets   btQueryJoins btReportsJoins btExit btHelp ~
                              btOK btCancel btHelp2 
&GLOBAL-DEFINE page1Widgets   nr-processo-ini nr-processo-fim ~
                              dt-inicio-ini dt-inicio-fim ~
                              dt-termino-ini dt-termino-fim ~
                              it-codigo-ini it-codigo-fim ~
                              fm-codigo-ini fm-codigo-fim ~
                              cod-emitente-ini cod-emitente-fim
&GLOBAL-DEFINE page2Widgets   br-situacao bt-todos bt-nenhum

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def temp-table tt-param2            no-undo
    field nr-processo-ini           like homologacao.nr-processo
    field nr-processo-fim           like homologacao.nr-processo
    field dt-inicio-ini             as date
    field dt-inicio-fim             as date
    field dt-termino-ini            as date
    field dt-termino-fim            as date
    field it-codigo-ini             like item.it-codigo
    field it-codigo-fim             like item.it-codigo
    field fm-codigo-ini             like item.fm-codigo
    field fm-codigo-fim             like item.fm-codigo
    field cod-emitente-ini          like emitente.cod-emitente
    field cod-emitente-fim          like emitente.cod-emitente.
    
def temp-table tt-situacao      no-undo
    like situacao
    field lg-usa        as log. 
    
def input-output parameter table for tt-param2.
DEF INPUT-OUTPUT PARAMETER TABLE FOR tt-situacao.

def output parameter lg-ok      as log          no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-situacao

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-situacao

/* Definitions for BROWSE br-situacao                                   */
&Scoped-define FIELDS-IN-QUERY-br-situacao tt-situacao.lg-usa tt-situacao.descricao   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-situacao   
&Scoped-define SELF-NAME br-situacao
&Scoped-define QUERY-STRING-br-situacao FOR EACH tt-situacao
&Scoped-define OPEN-QUERY-br-situacao OPEN QUERY {&SELF-NAME}     FOR EACH tt-situacao.
&Scoped-define TABLES-IN-QUERY-br-situacao tt-situacao
&Scoped-define FIRST-TABLE-IN-QUERY-br-situacao tt-situacao


/* Definitions for FRAME fPage2                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage2 ~
    ~{&OPEN-QUERY-br-situacao}

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

DEFINE VARIABLE cod-emitente-fim AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 999999999 
     VIEW-AS FILL-IN 
     SIZE 9.86 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE cod-emitente-ini AS INTEGER FORMAT ">>>>>>>>9" INITIAL 0 
     LABEL "Fornecedor" 
     VIEW-AS FILL-IN 
     SIZE 9.86 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE dt-inicio-fim AS DATE FORMAT "99/99/9999":U INITIAL 12/31/9999 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE dt-inicio-ini AS DATE FORMAT "99/99/9999" INITIAL 01/01/001 
     LABEL "Data In¡cio" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE dt-termino-fim AS DATE FORMAT "99/99/9999":U INITIAL 12/31/9999 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE dt-termino-ini AS DATE FORMAT "99/99/9999" INITIAL 01/01/001 
     LABEL "Data Termino" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fm-codigo-fim AS CHARACTER FORMAT "X(8)":U INITIAL "ZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 9.86 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fm-codigo-ini AS CHARACTER FORMAT "X(8)" 
     LABEL "Fam¡lia" 
     VIEW-AS FILL-IN 
     SIZE 9.86 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE it-codigo-fim AS CHARACTER FORMAT "X(16)":U INITIAL "ZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 16.86 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE it-codigo-ini AS CHARACTER FORMAT "X(16)" 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 16.86 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE nr-processo-fim AS INTEGER FORMAT ">>>>>9":U INITIAL 999999 
     VIEW-AS FILL-IN 
     SIZE 6.86 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE nr-processo-ini AS INTEGER FORMAT ">>>>>9" INITIAL 0 
     LABEL "Processo" 
     VIEW-AS FILL-IN 
     SIZE 6.86 BY .88
     FONT 1 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-2
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-29
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-30
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-31
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-32
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-33
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-34
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-35
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-36
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-37
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-38
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE BUTTON bt-nenhum 
     LABEL "Nenhum" 
     SIZE 10 BY 1 TOOLTIP "Desmarcar todos".

DEFINE BUTTON bt-todos 
     LABEL "Todos" 
     SIZE 10 BY 1 TOOLTIP "Marcar todos".

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-situacao FOR 
      tt-situacao SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-situacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-situacao wWindow _FREEFORM
  QUERY br-situacao DISPLAY
      tt-situacao.lg-usa FORMAT "X/ " COLUMN-LABEL "Listar"
tt-situacao.descricao
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 10.25
         FONT 1
         TITLE "Situa‡äes".


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
         SIZE 90 BY 17
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage2
     br-situacao AT ROW 1.25 COL 2 WIDGET-ID 200
     bt-todos AT ROW 11.75 COL 2 WIDGET-ID 28
     bt-nenhum AT ROW 11.75 COL 13 WIDGET-ID 30
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 4
         SIZE 84.43 BY 11.83
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage1
     nr-processo-ini AT ROW 1.5 COL 11.86 WIDGET-ID 4
     nr-processo-fim AT ROW 1.5 COL 54.14 NO-LABEL WIDGET-ID 2
     dt-inicio-ini AT ROW 2.5 COL 10.57 WIDGET-ID 16
     dt-inicio-fim AT ROW 2.5 COL 54.14 NO-LABEL WIDGET-ID 14
     dt-termino-ini AT ROW 3.5 COL 9 WIDGET-ID 20
     dt-termino-fim AT ROW 3.5 COL 54.14 NO-LABEL WIDGET-ID 18
     it-codigo-ini AT ROW 4.5 COL 15.29 WIDGET-ID 28
     it-codigo-fim AT ROW 4.5 COL 54.14 NO-LABEL WIDGET-ID 26
     fm-codigo-ini AT ROW 5.5 COL 13.29 WIDGET-ID 40
     fm-codigo-fim AT ROW 5.5 COL 54.14 NO-LABEL WIDGET-ID 38
     cod-emitente-ini AT ROW 6.5 COL 10.43 WIDGET-ID 48
     cod-emitente-fim AT ROW 6.5 COL 54.14 NO-LABEL WIDGET-ID 46
     IMAGE-1 AT ROW 1.5 COL 35.86 WIDGET-ID 6
     IMAGE-2 AT ROW 1.5 COL 51.14 WIDGET-ID 8
     IMAGE-29 AT ROW 2.5 COL 35.86 WIDGET-ID 10
     IMAGE-30 AT ROW 2.5 COL 51.14 WIDGET-ID 12
     IMAGE-31 AT ROW 3.5 COL 35.86 WIDGET-ID 22
     IMAGE-32 AT ROW 3.5 COL 51.14 WIDGET-ID 24
     IMAGE-33 AT ROW 4.5 COL 35.86 WIDGET-ID 30
     IMAGE-34 AT ROW 4.5 COL 51.14 WIDGET-ID 32
     IMAGE-35 AT ROW 5.5 COL 35.86 WIDGET-ID 34
     IMAGE-36 AT ROW 5.5 COL 51.14 WIDGET-ID 36
     IMAGE-37 AT ROW 6.5 COL 35.86 WIDGET-ID 42
     IMAGE-38 AT ROW 6.5 COL 51.14 WIDGET-ID 44
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 4
         SIZE 84.43 BY 11.83
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
         HEIGHT             = 17
         WIDTH              = 90
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
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE
       FRAME fPage2:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* SETTINGS FOR FILL-IN cod-emitente-fim IN FRAME fPage1
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN cod-emitente-ini IN FRAME fPage1
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN dt-inicio-fim IN FRAME fPage1
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN dt-inicio-ini IN FRAME fPage1
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN dt-termino-fim IN FRAME fPage1
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN dt-termino-ini IN FRAME fPage1
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fm-codigo-fim IN FRAME fPage1
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fm-codigo-ini IN FRAME fPage1
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN it-codigo-fim IN FRAME fPage1
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN it-codigo-ini IN FRAME fPage1
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN nr-processo-fim IN FRAME fPage1
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN nr-processo-ini IN FRAME fPage1
   ALIGN-L                                                              */
/* SETTINGS FOR FRAME fPage2
                                                                        */
/* BROWSE-TAB br-situacao 1 fPage2 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-situacao
/* Query rebuild information for BROWSE br-situacao
     _START_FREEFORM
OPEN QUERY {&SELF-NAME}
    FOR EACH tt-situacao.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-situacao */
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

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage2
/* Query rebuild information for FRAME fPage2
     _Query            is NOT OPENED
*/  /* FRAME fPage2 */
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


&Scoped-define BROWSE-NAME br-situacao
&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME br-situacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-situacao wWindow
ON MOUSE-SELECT-DBLCLICK OF br-situacao IN FRAME fPage2 /* Situa‡äes */
DO:
    IF  AVAIL tt-situacao
    THEN DO:
        IF  tt-situacao.lg-usa = YES
        THEN
            ASSIGN tt-situacao.lg-usa = NO.
        ELSE
            ASSIGN tt-situacao.lg-usa = YES.

        br-situacao:REFRESH().
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-nenhum
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-nenhum wWindow
ON CHOOSE OF bt-nenhum IN FRAME fPage2 /* Nenhum */
DO:
    FOR EACH tt-situacao:
        ASSIGN tt-situacao.lg-usa = NO.
    END.
    br-situacao:REFRESH() IN FRAME fpage2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-todos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-todos wWindow
ON CHOOSE OF bt-todos IN FRAME fPage2 /* Todos */
DO:
    FOR EACH tt-situacao:
        ASSIGN tt-situacao.lg-usa = YES.
    END.
    br-situacao:REFRESH() IN FRAME fpage2.
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

    find first tt-param2 no-error.

    assign tt-param2.nr-processo-ini      = frame fPage1 nr-processo-ini
           tt-param2.nr-processo-fim      = frame fPage1 nr-processo-fim
           tt-param2.dt-inicio-ini        = frame fPage1 dt-inicio-ini
           tt-param2.dt-inicio-fim        = frame fPage1 dt-inicio-fim
           tt-param2.dt-termino-ini       = frame fPage1 dt-termino-ini
           tt-param2.dt-termino-fim       = frame fPage1 dt-termino-fim
           tt-param2.it-codigo-ini        = frame fPage1 it-codigo-ini
           tt-param2.it-codigo-fim        = frame fPage1 it-codigo-fim
           tt-param2.fm-codigo-ini        = frame fPage1 fm-codigo-ini
           tt-param2.fm-codigo-fim        = frame fPage1 fm-codigo-fim
           tt-param2.cod-emitente-ini     = frame fPage1 cod-emitente-ini
           tt-param2.cod-emitente-fim     = frame fPage1 cod-emitente-fim
           lg-ok                          = yes.                              
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


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/

{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeDisplayWidgets wWindow 
PROCEDURE beforeDisplayWidgets :
find first tt-param2 no-error.

    assign nr-processo-ini            = tt-param2.nr-processo-ini
           nr-processo-fim            = tt-param2.nr-processo-fim
           dt-inicio-ini              = tt-param2.dt-inicio-ini
           dt-inicio-fim              = tt-param2.dt-inicio-fim
           dt-termino-ini             = tt-param2.dt-termino-ini
           dt-termino-fim             = tt-param2.dt-termino-fim
           it-codigo-ini              = tt-param2.it-codigo-ini
           it-codigo-fim              = tt-param2.it-codigo-fim
           fm-codigo-ini              = tt-param2.fm-codigo-ini
           fm-codigo-fim              = tt-param2.fm-codigo-fim
           cod-emitente-ini           = tt-param2.cod-emitente-ini
           cod-emitente-fim           = tt-param2.cod-emitente-fim.
           
    disp   nr-processo-ini
           nr-processo-fim
           dt-inicio-ini
           dt-inicio-fim
           dt-termino-ini
           dt-termino-fim
           it-codigo-ini 
           it-codigo-fim 
           fm-codigo-ini 
           fm-codigo-fim 
           cod-emitente-ini
           cod-emitente-fim
           with frame fPage1.

    OPEN QUERY br-situacao
        FOR EACH tt-situacao.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

