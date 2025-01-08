&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcad           PROGRESS
          mgcad           PROGRESS
          mgmov           PROGRESS
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
{include/i-prgvrs.i ESREP034 2.00.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESREP034
&GLOBAL-DEFINE Version        2.00.00.000

&GLOBAL-DEFINE WindowType     Master

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Item X Estab

&GLOBAL-DEFINE page0Widgets   btSearch btQueryJoins btReportsJoins btExit btHelp fiCodEmitente fiSerieDocto fiNroDocto fiNatOperacao fiCodEstabelOrigem fiCodEstabelDestino btConfirma
&GLOBAL-DEFINE page1Widgets   brItemUniEstab

/* Parameters Definitions ---                                           */

/* Include Definitions ---                                              */
{cdp/cd9098.i} /* Defini‡Æo das vari veis para zoom "Emitente" */
{cdp/cd0666.i} /* Defini‡Æo da temp-table "tt-erro" */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE wh-pesquisa AS HANDLE      NO-UNDO.

DEFINE VARIABLE cDescItem LIKE item.desc-item NO-UNDO.

/* New Global Shared Variable Definitions ---                           */
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE      NO-UNDO.

/* Local Temp-Table Definitions ---                                     */
DEFINE TEMP-TABLE tt-created-item-uni-estab NO-UNDO
    FIELD it-codigo   LIKE item-uni-estab.it-codigo
    FIELD cod-estabel LIKE item-uni-estab.cod-estabel
    INDEX chPrimario AS PRIMARY UNIQUE
        it-codigo
        cod-estabel.

/* Buffer Definitions ---                                               */
DEFINE BUFFER bf-item-uni-estab FOR item-uni-estab.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brItemUniEstab

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-created-item-uni-estab

/* Definitions for BROWSE brItemUniEstab                                */
&Scoped-define FIELDS-IN-QUERY-brItemUniEstab tt-created-item-uni-estab.it-codigo fnDescItem(tt-created-item-uni-estab.it-codigo) @ cDescItem tt-created-item-uni-estab.cod-estabel   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brItemUniEstab   
&Scoped-define SELF-NAME brItemUniEstab
&Scoped-define QUERY-STRING-brItemUniEstab FOR EACH tt-created-item-uni-estab
&Scoped-define OPEN-QUERY-brItemUniEstab OPEN QUERY {&SELF-NAME} FOR EACH tt-created-item-uni-estab.
&Scoped-define TABLES-IN-QUERY-brItemUniEstab tt-created-item-uni-estab
&Scoped-define FIRST-TABLE-IN-QUERY-brItemUniEstab tt-created-item-uni-estab


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brItemUniEstab}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar-2 btSearch fiCodEmitente rtParent ~
fiSerieDocto fiNroDocto fiNatOperacao fiCodEstabelOrigem ~
fiCodEstabelDestino btConfirma btQueryJoins btReportsJoins btExit btHelp ~
fiNomeEstabOrigem fiNomeEstabDestino fiNomeEmit fiDenominacao 
&Scoped-Define DISPLAYED-OBJECTS fiCodEmitente fiSerieDocto fiNroDocto ~
fiNatOperacao fiCodEstabelOrigem fiCodEstabelDestino fiNomeEstabOrigem ~
fiNomeEstabDestino fiNomeEmit fiDenominacao 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDescItem wWindow 
FUNCTION fnDescItem RETURNS CHARACTER
  ( pItCodigo AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miSearch       LABEL "&Pesquisa"      ACCELERATOR "CTRL-F5"
       RULE
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
DEFINE BUTTON btConfirma 
     LABEL "Confirmar" 
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

DEFINE BUTTON btSearch 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "Search" 
     SIZE 4 BY 1.25.

DEFINE VARIABLE fiCodEmitente LIKE item-doc-est.cod-emitente
     VIEW-AS FILL-IN 
     SIZE 10.57 BY .88 NO-UNDO.

DEFINE VARIABLE fiCodEstabelDestino LIKE item-uni-estab.cod-estabel
     LABEL "Estabel Destino" 
     VIEW-AS FILL-IN 
     SIZE 7.14 BY .88 NO-UNDO.

DEFINE VARIABLE fiCodEstabelOrigem LIKE item-uni-estab.cod-estabel
     LABEL "Estabel Origem" 
     VIEW-AS FILL-IN 
     SIZE 7.14 BY .88 NO-UNDO.

DEFINE VARIABLE fiDenominacao LIKE natur-oper.denominacao
     VIEW-AS FILL-IN 
     SIZE 41.43 BY .88 NO-UNDO.

DEFINE VARIABLE fiNatOperacao LIKE item-doc-est.nat-operacao
     LABEL "Nat Opera‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 10.57 BY .88 NO-UNDO.

DEFINE VARIABLE fiNomeEmit LIKE emitente.nome-emit
     VIEW-AS FILL-IN 
     SIZE 41.43 BY .88 NO-UNDO.

DEFINE VARIABLE fiNomeEstabDestino LIKE estabelec.nome
     VIEW-AS FILL-IN 
     SIZE 44.86 BY .88 NO-UNDO.

DEFINE VARIABLE fiNomeEstabOrigem LIKE estabelec.nome
     VIEW-AS FILL-IN 
     SIZE 44.86 BY .88 NO-UNDO.

DEFINE VARIABLE fiNroDocto LIKE item-doc-est.nro-docto
     LABEL "Documento" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE fiSerieDocto LIKE item-doc-est.serie-docto
     LABEL "S‚rie" 
     VIEW-AS FILL-IN 
     SIZE 7.57 BY .88 NO-UNDO.

DEFINE RECTANGLE rtParent
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 6.25.

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brItemUniEstab FOR 
      tt-created-item-uni-estab SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brItemUniEstab
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brItemUniEstab wWindow _FREEFORM
  QUERY brItemUniEstab DISPLAY
      tt-created-item-uni-estab.it-codigo
        fnDescItem(tt-created-item-uni-estab.it-codigo) @ cDescItem WIDTH 50
        tt-created-item-uni-estab.cod-estabel LABEL "Estab":U WIDTH 8
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 80 BY 6.67
         FONT 2
         TITLE "Item X Estab cadastrado no Estabelecimento Destino".


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btSearch AT ROW 1.13 COL 1.57 HELP
          "Pesquisa"
     fiCodEmitente AT ROW 2.83 COL 19.57 COLON-ALIGNED HELP
          "Emitente"
     fiSerieDocto AT ROW 3.83 COL 19.57 COLON-ALIGNED HELP
          "S‚rie do Documento"
          LABEL "S‚rie"
     fiNroDocto AT ROW 4.83 COL 19.57 COLON-ALIGNED HELP
          "N£mero do Documento"
          LABEL "Documento"
     fiNatOperacao AT ROW 5.83 COL 19.57 COLON-ALIGNED HELP
          "Natureza de Opera‡Æo"
          LABEL "Nat Opera‡Æo"
     fiCodEstabelOrigem AT ROW 6.83 COL 19.57 COLON-ALIGNED HELP
          "C¢digo do Estabelecimento de Origem"
          LABEL "Estabel Origem"
     fiCodEstabelDestino AT ROW 7.83 COL 19.57 COLON-ALIGNED HELP
          "C¢digo do Estabelecimento de Destino"
          LABEL "Estabel Destino"
     btConfirma AT ROW 7.75 COL 75
     btQueryJoins AT ROW 1.13 COL 74.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda"
     fiNomeEstabOrigem AT ROW 6.83 COL 27.14 COLON-ALIGNED HELP
          "Nome Estabelecimento" NO-LABEL NO-TAB-STOP 
     fiNomeEstabDestino AT ROW 7.83 COL 27.14 COLON-ALIGNED HELP
          "Nome Estabelecimento" NO-LABEL NO-TAB-STOP 
     fiNomeEmit AT ROW 2.83 COL 30.57 COLON-ALIGNED HELP
          "Nome Completo do Emitente" NO-LABEL NO-TAB-STOP 
     fiDenominacao AT ROW 5.83 COL 30.57 COLON-ALIGNED HELP
          "" NO-LABEL NO-TAB-STOP 
     rtToolBar-2 AT ROW 1 COL 1
     rtParent AT ROW 2.67 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17
         FONT 1.

DEFINE FRAME fPage1
     brItemUniEstab AT ROW 1.38 COL 3
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 10.21
         SIZE 84.43 BY 7.54
         FONT 1.


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
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME Custom                                                    */
/* SETTINGS FOR FILL-IN fiCodEmitente IN FRAME fpage0
   LIKE = mgmov.item-doc-est.cod-emitente EXP-HELP                     */
/* SETTINGS FOR FILL-IN fiCodEstabelDestino IN FRAME fpage0
   LIKE = mgcad.item-uni-estab.cod-estabel EXP-LABEL EXP-HELP EXP-SIZE */
/* SETTINGS FOR FILL-IN fiCodEstabelOrigem IN FRAME fpage0
   LIKE = mgcad.item-uni-estab.cod-estabel EXP-LABEL EXP-HELP EXP-SIZE */
/* SETTINGS FOR FILL-IN fiDenominacao IN FRAME fpage0
   LIKE = mgcad.natur-oper.denominacao EXP-SIZE                        */
/* SETTINGS FOR FILL-IN fiNatOperacao IN FRAME fpage0
   LIKE = mgmov.item-doc-est.nat-operacao EXP-LABEL EXP-HELP EXP-SIZE  */
/* SETTINGS FOR FILL-IN fiNomeEmit IN FRAME fpage0
   LIKE = mgcad.emitente.nome-emit EXP-SIZE                            */
/* SETTINGS FOR FILL-IN fiNomeEstabDestino IN FRAME fpage0
   LIKE = mgcad.estabelec.nome EXP-SIZE                                */
/* SETTINGS FOR FILL-IN fiNomeEstabOrigem IN FRAME fpage0
   LIKE = mgcad.estabelec.nome EXP-SIZE                                */
/* SETTINGS FOR FILL-IN fiNroDocto IN FRAME fpage0
   LIKE = mgmov.item-doc-est.nro-docto EXP-LABEL EXP-HELP EXP-SIZE     */
/* SETTINGS FOR FILL-IN fiSerieDocto IN FRAME fpage0
   LIKE = mgmov.item-doc-est.serie-docto EXP-LABEL EXP-HELP EXP-SIZE   */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB brItemUniEstab 1 fPage1 */
ASSIGN 
       brItemUniEstab:COLUMN-RESIZABLE IN FRAME fPage1       = TRUE
       brItemUniEstab:COLUMN-MOVABLE IN FRAME fPage1         = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brItemUniEstab
/* Query rebuild information for BROWSE brItemUniEstab
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-created-item-uni-estab.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE brItemUniEstab */
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


&Scoped-define SELF-NAME btConfirma
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btConfirma wWindow
ON CHOOSE OF btConfirma IN FRAME fpage0 /* Confirmar */
DO:
    RUN piCreateItemUniEstab IN THIS-PROCEDURE.
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


&Scoped-define SELF-NAME btSearch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSearch wWindow
ON CHOOSE OF btSearch IN FRAME fpage0 /* Search */
OR CHOOSE OF MENU-ITEM miSearch IN MENU mbMain DO:
    {method/ZoomFields.i &ProgramZoom="inzoom/z13in090.w"
                         &FieldZoom1="cod-emitente"
                         &FieldScreen1="fiCodEmitente"
                         &Frame1="fPage0"
                         &FieldZoom2="serie-docto"
                         &FieldScreen2="fiSerieDocto"
                         &Frame2="fPage0"
                         &FieldZoom3="nro-docto"
                         &FieldScreen3="fiNroDocto"
                         &Frame3="fPage0"
                         &FieldZoom4="nat-operacao"
                         &FieldScreen4="fiNatOperacao"
                         &Frame4="fPage0"
                         &EnableImplant="NO"}
                         
    IF VALID-HANDLE(hProgramZoom) THEN DO:
        WAIT-FOR CLOSE OF hProgramZoom.

        APPLY "LEAVE":U TO fiCodEmitente IN FRAME fPage0.
        APPLY "LEAVE":U TO fiNatOperacao IN FRAME fPage0.
        APPLY "ENTRY":U TO fiCodEstabelOrigem IN FRAME fPage0.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiCodEmitente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiCodEmitente wWindow
ON F5 OF fiCodEmitente IN FRAME fpage0 /* Emitente */
DO:
    ASSIGN i-filtro   = 2
           l-implanta = NO.

    {include/zoomvar.i &prog-zoom="adzoom/z07ad098.w"
                       &campo="fiCodEmitente"
                       &campozoom="cod-emitente"
                       &frame="fPage0"}

    IF VALID-HANDLE(wh-pesquisa) THEN DO:
        WAIT-FOR CLOSE OF wh-pesquisa.

        APPLY "LEAVE":U TO SELF.
        APPLY "ENTRY":U TO SELF.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiCodEmitente wWindow
ON LEAVE OF fiCodEmitente IN FRAME fpage0 /* Emitente */
DO:
    ASSIGN INPUT FRAME fPage0 fiCodEmitente.

    FIND FIRST emitente
        WHERE emitente.cod-emitente = fiCodEmitente NO-LOCK NO-ERROR.

    ASSIGN fiNomeEmit = IF AVAILABLE emitente THEN emitente.nome-emit ELSE "":U.

    DISPLAY fiNomeEmit
        WITH FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiCodEmitente wWindow
ON MOUSE-SELECT-DBLCLICK OF fiCodEmitente IN FRAME fpage0 /* Emitente */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiCodEstabelDestino
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiCodEstabelDestino wWindow
ON F5 OF fiCodEstabelDestino IN FRAME fpage0 /* Estabel Destino */
DO:
    ASSIGN l-implanta = NO.

    {include/zoomvar.i &prog-zoom="adzoom/z01ad107.w"
                       &campo="fiCodEstabelDestino"
                       &campozoom="cod-estabel"
                       &frame="fPage0"
                       &campo2="fiNomeEstabDestino"
                       &campozoom2="nome"
                       &frame2="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiCodEstabelDestino wWindow
ON LEAVE OF fiCodEstabelDestino IN FRAME fpage0 /* Estabel Destino */
DO:
    ASSIGN INPUT FRAME fPage0 fiCodEstabelDestino.

    FIND FIRST estabelec
        WHERE estabelec.cod-estabel = fiCodEstabelDestino NO-LOCK NO-ERROR.

    ASSIGN fiNomeEstabDestino = IF AVAILABLE estabelec THEN estabelec.nome ELSE "":U.

    DISPLAY fiNomeEstabDestino
        WITH FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiCodEstabelDestino wWindow
ON MOUSE-SELECT-DBLCLICK OF fiCodEstabelDestino IN FRAME fpage0 /* Estabel Destino */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiCodEstabelOrigem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiCodEstabelOrigem wWindow
ON F5 OF fiCodEstabelOrigem IN FRAME fpage0 /* Estabel Origem */
DO:
    ASSIGN l-implanta = NO.

    {include/zoomvar.i &prog-zoom="adzoom/z01ad107.w"
                       &campo="fiCodEstabelOrigem"
                       &campozoom="cod-estabel"
                       &frame="fPage0"
                       &campo2="fiNomeEstabOrigem"
                       &campozoom2="nome"
                       &frame2="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiCodEstabelOrigem wWindow
ON LEAVE OF fiCodEstabelOrigem IN FRAME fpage0 /* Estabel Origem */
DO:
    ASSIGN INPUT FRAME fPage0 fiCodEstabelOrigem.

    FIND FIRST estabelec
        WHERE estabelec.cod-estabel = fiCodEstabelOrigem NO-LOCK NO-ERROR.

    ASSIGN fiNomeEstabOrigem = IF AVAILABLE estabelec THEN estabelec.nome ELSE "":U.

    DISPLAY fiNomeEstabOrigem
        WITH FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiCodEstabelOrigem wWindow
ON MOUSE-SELECT-DBLCLICK OF fiCodEstabelOrigem IN FRAME fpage0 /* Estabel Origem */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiNatOperacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiNatOperacao wWindow
ON F5 OF fiNatOperacao IN FRAME fpage0 /* Nat Opera‡Æo */
DO:
    {method/ZoomFields.i &ProgramZoom="inzoom/z04in245.w"
                         &FieldZoom1="nat-operacao"
                         &FieldScreen1="fiNatOperacao"
                         &Frame1="fPage0"
                         &FieldZoom2="denominacao"
                         &FieldScreen2="fiDenominacao"
                         &Frame2="fPage0"
                         &EnableImplant="NO"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiNatOperacao wWindow
ON LEAVE OF fiNatOperacao IN FRAME fpage0 /* Nat Opera‡Æo */
DO:
    ASSIGN INPUT FRAME fPage0 fiNatOperacao.

    FIND FIRST natur-oper
        WHERE natur-oper.nat-operacao = fiNatOperacao NO-LOCK NO-ERROR.

    ASSIGN fiDenominacao = IF AVAILABLE natur-oper THEN natur-oper.denominacao ELSE "":U.

    DISPLAY fiDenominacao
        WITH FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiNatOperacao wWindow
ON MOUSE-SELECT-DBLCLICK OF fiNatOperacao IN FRAME fpage0 /* Nat Opera‡Æo */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiSerieDocto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiSerieDocto wWindow
ON F5 OF fiSerieDocto IN FRAME fpage0 /* S‚rie */
DO:
    {include/zoomvar.i &prog-zoom="inzoom/z01in407.w"
                       &campo="fiSerieDocto"
                       &campozoom="serie"
                       &frame="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiSerieDocto wWindow
ON MOUSE-SELECT-DBLCLICK OF fiSerieDocto IN FRAME fpage0 /* S‚rie */
DO:
    APPLY "F5":U TO SELF.
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


&Scoped-define BROWSE-NAME brItemUniEstab
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{window/mainblock.i}

/*--- Seta cursor do mouse para lupa, quando estiver posicionado sobre o fill-in ---*/
IF fiCodEmitente:LOAD-MOUSE-POINTER("image/lupa.cur":U)       IN FRAME fPage0 THEN.
IF fiSerieDocto:LOAD-MOUSE-POINTER("image/lupa.cur":U)        IN FRAME fPage0 THEN.
IF fiNatOperacao:LOAD-MOUSE-POINTER("image/lupa.cur":U)       IN FRAME fPage0 THEN.
IF fiCodEstabelOrigem:LOAD-MOUSE-POINTER("image/lupa.cur":U)  IN FRAME fPage0 THEN.
IF fiCodEstabelDestino:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0 THEN.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCreateItemUniEstab wWindow 
PROCEDURE piCreateItemUniEstab :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE h-acomp  AS HANDLE      NO-UNDO.
    DEFINE VARIABLE i-seq    AS INTEGER     NO-UNDO INITIAL 0.
    DEFINE VARIABLE l-criado AS LOGICAL     NO-UNDO INITIAL NO.

    IF NOT VALID-HANDLE(h-acomp) THEN
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-inicializar IN h-acomp (INPUT "Criando Item X Estab Destino...":U).

    EMPTY TEMP-TABLE tt-created-item-uni-estab.
    EMPTY TEMP-TABLE tt-erro.

    {&OPEN-QUERY-brItemUniEstab}

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-acompanhar IN h-acomp (INPUT "Validando dados...":U).

    RUN piValidateFields IN THIS-PROCEDURE.

    IF RETURN-VALUE = "NOK":U THEN
        RETURN NO-APPLY.

    ASSIGN INPUT FRAME fPage0
        fiCodEmitente
        fiSerieDocto
        fiNroDocto
        fiNatOperacao
        fiCodEstabelOrigem
        fiCodEstabelDestino.

    FOR EACH item-doc-est NO-LOCK
        WHERE item-doc-est.serie-docto  = fiSerieDocto
          AND item-doc-est.nro-docto    = fiNroDocto
          AND item-doc-est.cod-emitente = fiCodEmitente
          AND item-doc-est.nat-operacao = fiNatOperacao:

        IF VALID-HANDLE(h-acomp) THEN
            RUN pi-acompanhar IN h-acomp (INPUT "Buscando Itens X Docto: ":U + item-doc-est.it-codigo).

        FIND FIRST item-uni-estab
            WHERE item-uni-estab.it-codigo   = item-doc-est.it-codigo
              AND item-uni-estab.cod-estabel = fiCodEstabelOrigem NO-LOCK NO-ERROR.

        IF AVAILABLE item-uni-estab THEN DO:
            FIND FIRST bf-item-uni-estab
                WHERE bf-item-uni-estab.it-codigo   = item-doc-est.it-codigo
                  AND bf-item-uni-estab.cod-estabel = fiCodEstabelDestino NO-LOCK NO-ERROR.

            IF NOT AVAILABLE bf-item-uni-estab THEN DO:
                IF VALID-HANDLE(h-acomp) THEN
                    RUN pi-acompanhar IN h-acomp (INPUT "Criando Item X Estab: ":U + item-uni-estab.it-codigo + "/":U + fiCodEstabelDestino).

                CREATE bf-item-uni-estab.
                BUFFER-COPY item-uni-estab EXCEPT cod-estabel TO bf-item-uni-estab.
                ASSIGN bf-item-uni-estab.cod-estabel = fiCodEstabelDestino.

                ASSIGN l-criado = YES.

                CREATE tt-created-item-uni-estab.
                ASSIGN tt-created-item-uni-estab.it-codigo   = bf-item-uni-estab.it-codigo
                       tt-created-item-uni-estab.cod-estabel = bf-item-uni-estab.cod-estabel.
            END. /* IF NOT AVAILABLE b-item-uni-estab THEN DO: */
        END. /* IF AVAILABLE item-uni-estab THEN DO: */
        ELSE DO:
            CREATE tt-erro.
            ASSIGN i-seq            = i-seq + 1
                   tt-erro.i-sequen = i-seq
                   tt-erro.cd-erro  = 17006
                   tt-erro.mensagem = "NÆo foi encontrado relacionamento Item X Estabelecimento para o Item ~"":U + item-doc-est.it-codigo + "~" no Estabelecimento Origem ~"":U + fiCodEstabelOrigem + "~".":U.
        END. /* ELSE DO: - IF AVAILABLE item-uni-estab THEN DO: */
    END. /* FOR EACH item-doc-est NO-LOCK */

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-finalizar IN h-acomp.

    {&OPEN-QUERY-brItemUniEstab}

    IF CAN-FIND(FIRST tt-erro) THEN
        RUN cdp/cd0666.p (INPUT TABLE tt-erro).

    IF l-criado THEN
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 15825,
                           INPUT "Item X Estabelecimento do Estabelecimento Destino cadastrado com sucesso!":U +
                                 "~~":U +
                                 "Os Itens X Estabelecimento do Estabelecimento Origem encontrados no documento foram cadastrados no Item X Estabelecimento do Estabelecimento Destino com sucesso!":U).
    ELSE IF NOT CAN-FIND(FIRST tt-erro) THEN
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 27979,
                           INPUT "J  existem Item X Estabelecimento do Estabelecimento Destino cadastrado!":U +
                                 "~~":U +
                                 "Os Itens X Estabelecimento do Estabelecimento Origem encontrados no documento j  existem no Item X Estabelecimento do Estabelecimento Destino.":U).

    IF VALID-HANDLE(h-acomp) THEN
        DELETE PROCEDURE h-acomp.

    ASSIGN h-acomp = ?.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValidateFields wWindow 
PROCEDURE piValidateFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN INPUT FRAME fPage0
        fiCodEmitente
        fiSerieDocto
        fiNroDocto
        fiNatOperacao
        fiCodEstabelOrigem
        fiCodEstabelDestino.

    IF NOT CAN-FIND(FIRST emitente
                    WHERE emitente.cod-emitente = fiCodEmitente NO-LOCK) THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 2,
                           INPUT "Emitente":U).

        APPLY "ENTRY":U TO fiCodEmitente IN FRAME fPage0.

        RETURN "NOK":U.
    END.

    IF NOT CAN-FIND(FIRST serie
                    WHERE serie.serie = fiSerieDocto NO-LOCK) THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 2,
                           INPUT "S‚rie":U).

        APPLY "ENTRY":U TO fiSerieDocto IN FRAME fPage0.

        RETURN "NOK":U.
    END.

    IF NOT CAN-FIND(FIRST natur-oper
                    WHERE natur-oper.nat-operacao = fiNatOperacao NO-LOCK) THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 2,
                           INPUT "Natureza Opera‡Æo":U).

        APPLY "ENTRY":U TO fiNatOperacao IN FRAME fPage0.

        RETURN "NOK":U.
    END.

    IF NOT CAN-FIND(FIRST estabelec
                    WHERE estabelec.cod-estabel = fiCodEstabelOrigem NO-LOCK) THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 2,
                           INPUT "Estabelecimento Origem":U).

        APPLY "ENTRY":U TO fiCodEstabelOrigem IN FRAME fPage0.

        RETURN "NOK":U.
    END.

    IF NOT CAN-FIND(FIRST estabelec
                    WHERE estabelec.cod-estabel = fiCodEstabelDestino NO-LOCK) THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 2,
                           INPUT "Estabelecimento Destino":U).

        APPLY "ENTRY":U TO fiCodEstabelDestino IN FRAME fPage0.

        RETURN "NOK":U.
    END.

    IF NOT CAN-FIND(FIRST docum-est
                    WHERE docum-est.serie-docto  = fiSerieDocto
                      AND docum-est.nro-docto    = fiNroDocto
                      AND docum-est.cod-emitente = fiCodEmitente
                      AND docum-est.nat-operacao = fiNatOperacao NO-LOCK) THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 2,
                           INPUT "Docto Movto Estoque":U).

        APPLY "ENTRY":U TO fiNroDocto IN FRAME fPage0.

        RETURN "NOK":U.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDescItem wWindow 
FUNCTION fnDescItem RETURNS CHARACTER
  ( pItCodigo AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    FIND FIRST item
        WHERE item.it-codigo = pItCodigo NO-LOCK NO-ERROR.

    IF AVAILABLE item THEN
        RETURN item.desc-item.
    ELSE
        RETURN "":U.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

