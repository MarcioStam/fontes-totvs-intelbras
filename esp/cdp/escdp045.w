&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wMaintenance


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-cidade NO-UNDO LIKE mgcad.cidade
       FIELD RowNum AS INTEGER INIT 1
       FIELD r-Rowid AS ROWID
       .



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMaintenance 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESCDP045 2.00.00.000}  /*** 010009 ***/
/********************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

CREATE WIDGET-POOL.

{cdp/cdcfgdis.i}

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESCDP045
&GLOBAL-DEFINE Version        2.00.00.000

&GLOBAL-DEFINE Folder         NO

&GLOBAL-DEFINE First          YES
&GLOBAL-DEFINE Prev           YES
&GLOBAL-DEFINE Next           YES
&GLOBAL-DEFINE Last           YES
&GLOBAL-DEFINE GoTo           YES
&GLOBAL-DEFINE Search         YES

&GLOBAL-DEFINE Add            NO
&GLOBAL-DEFINE Copy           NO
&GLOBAL-DEFINE Update         NO
&GLOBAL-DEFINE Delete         NO
&GLOBAL-DEFINE Undo           NO
&GLOBAL-DEFINE Cancel         NO
&GLOBAL-DEFINE Save           NO

&GLOBAL-DEFINE ttTable        tt-cidade
&GLOBAL-DEFINE hDBOTable      bo-cidade
&GLOBAL-DEFINE DBOTable       cidade

&GLOBAL-DEFINE page0KeyFields tt-cidade.cidade ~
                              tt-cidade.estado ~
                              tt-cidade.pais
&GLOBAL-DEFINE page0Fields    tt-cidade.sigla       ~
                              tt-cidade.nome-ab-reg ~
                              tt-cidade.nome-mic-reg ~
                              i-cdn-domic-fisc ~
                              i-cdn-munpio-ibge

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable} AS HANDLE NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
DEFINE VARIABLE wh-pesquisa AS HANDLE NO-UNDO.
def new global shared var l-implanta      as logical init no. 
def new global shared var wh-window       as handle           no-undo.
def new global shared var h-programa      as handle           no-undo.
define new global shared var whEstado       as widget-handle no-undo.
define new global shared var whEndereco     as widget-handle no-undo.
define new global shared var whCep          as widget-handle no-undo.
define new global shared var whBairro       as widget-handle no-undo.
define new global shared var whCidade       as widget-handle no-undo.
define new global shared var whEstadoLocal  as widget-handle no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Maintenance
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-cidade.pais tt-cidade.estado ~
tt-cidade.cidade tt-cidade.sigla tt-cidade.nome-ab-reg ~
tt-cidade.nome-mic-reg 
&Scoped-define ENABLED-TABLES tt-cidade
&Scoped-define FIRST-ENABLED-TABLE tt-cidade
&Scoped-Define ENABLED-OBJECTS RECT-1 rtToolBar btFirst btPrev btNext ~
btLast btGoTo btSearch btCep btQueryJoins btReportsJoins btExit btHelp ~
i-cdn-domic-fisc i-cdn-munpio-ibge 
&Scoped-Define DISPLAYED-FIELDS tt-cidade.pais tt-cidade.estado ~
tt-cidade.cidade tt-cidade.sigla tt-cidade.nome-ab-reg ~
tt-cidade.nome-mic-reg 
&Scoped-define DISPLAYED-TABLES tt-cidade
&Scoped-define FIRST-DISPLAYED-TABLE tt-cidade
&Scoped-Define DISPLAYED-OBJECTS c-desc-estado c-desc-reg c-desc-mic-reg ~
i-cdn-domic-fisc i-cdn-munpio-ibge 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wMaintenance AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miFirst        LABEL "&Primeiro"      ACCELERATOR "CTRL-HOME"
       MENU-ITEM miPrev         LABEL "&Anterior"      ACCELERATOR "CTRL-CURSOR-LEFT"
       MENU-ITEM miNext         LABEL "&Pr¢ximo"       ACCELERATOR "CTRL-CURSOR-RIGHT"
       MENU-ITEM miLast         LABEL "&Èltimo"        ACCELERATOR "CTRL-END"
       RULE
       MENU-ITEM miGoTo         LABEL "&V† Para"       ACCELERATOR "CTRL-T"
       MENU-ITEM miSearch       LABEL "&Pesquisa"      ACCELERATOR "CTRL-F5"
       RULE
       MENU-ITEM miQueryJoins   LABEL "&Consultas"    
       MENU-ITEM miReportsJoins LABEL "&Relat¢rios"   
       RULE
       MENU-ITEM miExit         LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU smHelp 
       MENU-ITEM miContents     LABEL "&Conte£do"     
       RULE
       MENU-ITEM miAbout        LABEL "&Sobre..."     .

DEFINE MENU mbMain MENUBAR
       SUB-MENU  smFile         LABEL "&Arquivo"      
       SUB-MENU  smHelp         LABEL "&Ajuda"        .


/* Definitions of the field level widgets                               */
DEFINE BUTTON btCep 
     IMAGE-UP FILE "image/Intelbras/ico-correio.bmp":U
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "Consulta CEP".

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btFirst 
     IMAGE-UP FILE "image\im-fir":U
     IMAGE-INSENSITIVE FILE "image\ii-fir":U
     LABEL "First":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btGoTo 
     IMAGE-UP FILE "image\im-enter":U
     IMAGE-INSENSITIVE FILE "image\ii-enter":U
     LABEL "Go To" 
     SIZE 4 BY 1.25.

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image\im-hel":U
     IMAGE-INSENSITIVE FILE "image\ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btLast 
     IMAGE-UP FILE "image\im-las":U
     IMAGE-INSENSITIVE FILE "image\ii-las":U
     LABEL "Last":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btNext 
     IMAGE-UP FILE "image\im-nex":U
     IMAGE-INSENSITIVE FILE "image\ii-nex":U
     LABEL "Next":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btPrev 
     IMAGE-UP FILE "image\im-pre":U
     IMAGE-INSENSITIVE FILE "image\ii-pre":U
     LABEL "Prev":L 
     SIZE 4 BY 1.25.

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

DEFINE VARIABLE c-desc-estado AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 48 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-mic-reg AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 48 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-reg AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 48 BY .88 NO-UNDO.

DEFINE VARIABLE i-cdn-domic-fisc AS INTEGER FORMAT ">>>>>>9" INITIAL 0 
     LABEL "C¢digo Domic°lio Fiscal" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88.

DEFINE VARIABLE i-cdn-munpio-ibge AS INTEGER FORMAT ">>>>>>9" INITIAL 0 
     LABEL "C¢digo IBGE" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 5.5.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btFirst AT ROW 1.13 COL 1.57 HELP
          "Primeira ocorrància"
     btPrev AT ROW 1.13 COL 5.57 HELP
          "Ocorrància anterior"
     btNext AT ROW 1.13 COL 9.57 HELP
          "Pr¢xima ocorrància"
     btLast AT ROW 1.13 COL 13.57 HELP
          "Èltima ocorrància"
     btGoTo AT ROW 1.13 COL 17.57 HELP
          "V† Para"
     btSearch AT ROW 1.13 COL 21.57 HELP
          "Pesquisa"
     btCep AT ROW 1.13 COL 38
     btQueryJoins AT ROW 1.13 COL 74.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda"
     tt-cidade.pais AT ROW 3 COL 17 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20 BY .88
     tt-cidade.estado AT ROW 4 COL 17 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4 BY .88
     c-desc-estado AT ROW 4 COL 22 COLON-ALIGNED NO-LABEL
     tt-cidade.cidade AT ROW 5 COL 17 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 30 BY .88
     tt-cidade.sigla AT ROW 7 COL 17 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     tt-cidade.nome-ab-reg AT ROW 8 COL 17 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20 BY .88
     c-desc-reg AT ROW 8 COL 38 COLON-ALIGNED NO-LABEL
     tt-cidade.nome-mic-reg AT ROW 9 COL 17 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20 BY .88
     c-desc-mic-reg AT ROW 9 COL 38 COLON-ALIGNED NO-LABEL
     i-cdn-domic-fisc AT ROW 10 COL 17 COLON-ALIGNED
     i-cdn-munpio-ibge AT ROW 11 COL 17 COLON-ALIGNED
     RECT-1 AT ROW 6.5 COL 1
     rtToolBar AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90.14 BY 11.04
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Maintenance
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: tt-cidade T "?" NO-UNDO mgdis cidade
      ADDITIONAL-FIELDS:
          FIELD RowNum AS INTEGER INIT 1
          FIELD r-Rowid AS ROWID
          
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wMaintenance ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 11.04
         WIDTH              = 90.14
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 103
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 103
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wMaintenance 
/* ************************* Included-Libraries *********************** */

{maintenance/maintenance.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wMaintenance
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN c-desc-estado IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-mic-reg IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-reg IN FRAME fpage0
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMaintenance)
THEN wMaintenance:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wMaintenance
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenance wMaintenance
ON END-ERROR OF wMaintenance
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenance wMaintenance
ON WINDOW-CLOSE OF wMaintenance
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCep
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCep wMaintenance
ON CHOOSE OF btCep IN FRAME fpage0
DO:
    ASSIGN {&WINDOW-NAME}:SENSITIVE = NO.
    
    IF NOT VALID-HANDLE(wh-pesquisa) THEN
        RUN eszoom/z01es539.w persistent set wh-pesquisa.

    RUN dispatch IN wh-pesquisa ('initialize':U).
  
    IF VALID-HANDLE(wh-pesquisa) and
        wh-pesquisa:TYPE = "PROCEDURE":U and
        wh-pesquisa:FILE-NAME = "{&prog-zoom}":U then do:
        RUN pi-entry IN wh-pesquisa. 
    END.

    WAIT-FOR CLOSE OF wh-pesquisa.

    ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.

    IF VALID-HANDLE(wh-pesquisa) THEN
        DELETE PROCEDURE wh-pesquisa.

    ASSIGN wh-pesquisa = ?.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wMaintenance
ON CHOOSE OF btExit IN FRAME fpage0 /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btFirst
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFirst wMaintenance
ON CHOOSE OF btFirst IN FRAME fpage0 /* First */
OR CHOOSE OF MENU-ITEM miFirst IN MENU mbMain DO:
    RUN getFirst IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btGoTo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btGoTo wMaintenance
ON CHOOSE OF btGoTo IN FRAME fpage0 /* Go To */
OR CHOOSE OF MENU-ITEM miGoTo IN MENU mbMain DO:
    RUN goToRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wMaintenance
ON CHOOSE OF btHelp IN FRAME fpage0 /* Help */
OR CHOOSE OF MENU-ITEM miContents IN MENU mbMain DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btLast
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btLast wMaintenance
ON CHOOSE OF btLast IN FRAME fpage0 /* Last */
OR CHOOSE OF MENU-ITEM miLast IN MENU mbMain DO:
    RUN getLast IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btNext
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btNext wMaintenance
ON CHOOSE OF btNext IN FRAME fpage0 /* Next */
OR CHOOSE OF MENU-ITEM miNext IN MENU mbMain DO:
    RUN getNext IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btPrev
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btPrev wMaintenance
ON CHOOSE OF btPrev IN FRAME fpage0 /* Prev */
OR CHOOSE OF MENU-ITEM miPrev IN MENU mbMain DO:
    RUN getPrev IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btQueryJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btQueryJoins wMaintenance
ON CHOOSE OF btQueryJoins IN FRAME fpage0 /* Query Joins */
OR CHOOSE OF MENU-ITEM miQueryJoins IN MENU mbMain DO:
    RUN showQueryJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btReportsJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReportsJoins wMaintenance
ON CHOOSE OF btReportsJoins IN FRAME fpage0 /* Reports Joins */
OR CHOOSE OF MENU-ITEM miReportsJoins IN MENU mbMain DO:
    RUN showReportsJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSearch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSearch wMaintenance
ON CHOOSE OF btSearch IN FRAME fpage0 /* Search */
OR CHOOSE OF MENU-ITEM miSearch IN MENU mbMain DO:
    {method/zoomreposition.i &ProgramZoom="dizoom/z01di341.w"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-cidade.estado
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-cidade.estado wMaintenance
ON F5 OF tt-cidade.estado IN FRAME fpage0 /* UF */
DO:
    {method/zoomfields.i &ProgramZoom="unzoom/z02un007.w"
                         &FieldZoom1=estado
                         &FieldScreen1=tt-cidade.estado
                         &Frame1=fPage0
                         &FieldZoom2=pais
                         &FieldScreen2=tt-cidade.pais
                         &Frame2=fPage0
                         &FieldZoom3=no-estado
                         &FieldScreen3=c-desc-estado
                         &Frame3=fPage0}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-cidade.estado wMaintenance
ON LEAVE OF tt-cidade.estado IN FRAME fpage0 /* UF */
DO:
    RUN retornaDescricao IN bo-cidade (INPUT  'unid-feder':U,
                                       INPUT  tt-cidade.pais:SCREEN-VALUE,
                                       INPUT  SELF:SCREEN-VALUE,
                                       OUTPUT c-desc-estado).

    DISPLAY c-desc-estado WITH FRAME fPage0.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-cidade.estado wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-cidade.estado IN FRAME fpage0 /* UF */
DO:
    APPLY 'F5':U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-cidade.nome-ab-reg
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-cidade.nome-ab-reg wMaintenance
ON F5 OF tt-cidade.nome-ab-reg IN FRAME fpage0 /* Regi∆o */
DO:
    {method/zoomfields.i &ProgramZoom="adzoom/z02ad218.w"
                         &FieldZoom1=nome-ab-reg
                         &FieldScreen1=tt-cidade.nome-ab-reg
                         &Frame1=fPage0
                         &FieldZoom2=nome-regiao
                         &FieldScreen2=c-desc-reg
                         &Frame2=fPage0}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-cidade.nome-ab-reg wMaintenance
ON LEAVE OF tt-cidade.nome-ab-reg IN FRAME fpage0 /* Regi∆o */
DO:
    RUN retornaDescricao IN bo-cidade (INPUT  'regiao':U,
                                       INPUT  SELF:SCREEN-VALUE,
                                       INPUT  ?,
                                       OUTPUT c-desc-reg).

    DISPLAY c-desc-reg WITH FRAME fPage0.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-cidade.nome-ab-reg wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-cidade.nome-ab-reg IN FRAME fpage0 /* Regi∆o */
DO:
    APPLY 'F5':U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-cidade.nome-mic-reg
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-cidade.nome-mic-reg wMaintenance
ON F5 OF tt-cidade.nome-mic-reg IN FRAME fpage0 /* Microrregi∆o */
DO:
    ASSIGN l-implanta = YES.

    {include/zoomvar.i &prog-zoom="dizoom/z01di107.w"
                       &campo="tt-cidade.nome-mic-reg"
                       &campozoom="nome-mic-reg"
                       &frame="fPage0"
                       &campo2="c-desc-mic-reg"
                       &campozoom2="desc-mic-reg"
                       &frame2="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-cidade.nome-mic-reg wMaintenance
ON LEAVE OF tt-cidade.nome-mic-reg IN FRAME fpage0 /* Microrregi∆o */
DO:
    RUN retornaDescricao IN bo-cidade (INPUT  'micro-reg':U,
                                       INPUT  tt-cidade.nome-ab-reg:SCREEN-VALUE,
                                       INPUT  SELF:SCREEN-VALUE,
                                       OUTPUT c-desc-mic-reg).

    DISPLAY c-desc-mic-reg WITH FRAME fPage0.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-cidade.nome-mic-reg wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-cidade.nome-mic-reg IN FRAME fpage0 /* Microrregi∆o */
DO:
    APPLY 'F5':U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-cidade.pais
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-cidade.pais wMaintenance
ON F5 OF tt-cidade.pais IN FRAME fpage0 /* Pa°s */
DO:
    /*
    {method/zoomfields.i &ProgramZoom="unzoom/z01un006.w"
                         &FieldZoom1=nome-pais
                         &FieldScreen1=tt-cidade.pais
                         &Frame1=fPage0}
                         */
  ASSIGN l-implanta = YES.
  {include/zoomvar.i &prog-zoom="unzoom/z01un006.w"
                     &campo= tt-cidade.pais
                     &campozoom=nome-pais}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-cidade.pais wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-cidade.pais IN FRAME fpage0 /* Pa°s */
DO:
    APPLY 'F5':U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenance 


/*--- L¢gica para inicializaá∆o do programam ---*/
{maintenance/mainblock.i}

ASSIGN btCep:SENSITIVE IN FRAME fPage0 = YES.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wMaintenance 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DO WITH FRAME fPage0:
        RUN retornaDescricao IN bo-cidade (INPUT  'unid-feder':U,
                                           INPUT  tt-cidade.pais:SCREEN-VALUE,
                                           INPUT  tt-cidade.estado:SCREEN-VALUE,
                                           OUTPUT c-desc-estado).

        RUN retornaDescricao IN bo-cidade (INPUT  'regiao':U,
                                           INPUT  tt-cidade.nome-ab-reg:SCREEN-VALUE,
                                           INPUT  ?,
                                           OUTPUT c-desc-reg).

        RUN retornaDescricao IN bo-cidade (INPUT  'micro-reg':U,
                                           INPUT  tt-cidade.nome-ab-reg:SCREEN-VALUE,
                                           INPUT  tt-cidade.nome-mic-reg:SCREEN-VALUE,
                                           OUTPUT c-desc-mic-reg).

        &IF '{&bf_dis_versao_ems}' >= '2.07':U &THEN      
           IF AVAIL tt-cidade THEN
              ASSIGN i-cdn-domic-fisc = tt-cidade.cdn-domic-fisc
                     i-cdn-munpio-ibge       = tt-cidade.cdn-munpio-ibge.
        &ELSE
           IF AVAIL tt-cidade THEN
              ASSIGN i-cdn-domic-fisc = tt-cidade.cdn-domic-fisc
                     i-cdn-munpio-ibge       = tt-cidade.cdn-munpio-ibge.
        &ENDIF

    END.

    DISPLAY c-desc-estado
            c-desc-reg
            c-desc-mic-reg 
            i-cdn-domic-fisc
            i-cdn-munpio-ibge      
            WITH FRAME fPage0.

    RETURN 'OK':U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wMaintenance 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DO WITH FRAME fPage0:
        tt-cidade.estado:LOAD-MOUSE-POINTER('image/lupa.cur':U).
        tt-cidade.pais:LOAD-MOUSE-POINTER('image/lupa.cur':U).
        tt-cidade.nome-ab-reg:LOAD-MOUSE-POINTER('image/lupa.cur':U).
        tt-cidade.nome-mic-reg:LOAD-MOUSE-POINTER('image/lupa.cur':U).
    END.

    RETURN 'OK':U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeSaveFields wMaintenance 
PROCEDURE beforeSaveFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
&IF '{&bf_dis_versao_ems}' >= '2.07':U &THEN      
   IF AVAIL tt-cidade THEN
      ASSIGN tt-cidade.cdn-domic-fisc = INPUT FRAME fpage0 i-cdn-domic-fisc
             tt-cidade.cdn-munpio-ibge       = INPUT FRAME fpage0 i-cdn-munpio-ibge.
&ELSE
   IF AVAIL tt-cidade THEN
      ASSIGN tt-cidade.cdn-domic-fisc = INPUT FRAME fpage0 i-cdn-domic-fisc
             tt-cidade.cdn-munpio-ibge = INPUT FRAME fpage0 i-cdn-munpio-ibge.
&ENDIF

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToRecord wMaintenance 
PROCEDURE goToRecord :
/*------------------------------------------------------------------------------
  Purpose:     Exibe dialog de V† Para
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE BUTTON btGoToCancel AUTO-END-KEY 
         LABEL "&Cancelar" 
         SIZE 10 BY 1
         BGCOLOR 8.

    DEFINE BUTTON btGoToOK AUTO-GO 
         LABEL "&OK" 
         SIZE 10 BY 1
         BGCOLOR 8.

    DEFINE RECTANGLE rtGoToButton
         EDGE-PIXELS 2 GRAPHIC-EDGE  
         SIZE 58 BY 1.42
         BGCOLOR 7.

    DEFINE VARIABLE rGoTo AS ROWID NO-UNDO.

    DEFINE VARIABLE c-cidade LIKE {&ttTable}.cidade NO-UNDO.
    DEFINE VARIABLE c-estado LIKE {&ttTable}.estado NO-UNDO.
    DEFINE VARIABLE c-pais   LIKE {&ttTable}.pais   NO-UNDO.

    DEFINE FRAME fGoToRecord
        c-cidade          AT ROW 1.21 COL 17.72 COLON-ALIGNED
        c-estado          AT ROW 2.21 COL 17.72 COLON-ALIGNED
        c-pais            AT ROW 3.21 COL 17.72 COLON-ALIGNED
        btGoToOK          AT ROW 4.63 COL 2.14
        btGoToCancel      AT ROW 4.63 COL 13
        rtGoToButton      AT ROW 4.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V† Para Cidade" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.

    RUN utp/ut-trfrrp.p (input Frame fGoToRecord:Handle).
    {utp/ut-liter.i "V†_Para_Cidade"}
    ASSIGN FRAME fGoToRecord:TITLE = RETURN-VALUE.

    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN c-cidade c-estado c-pais.

        RUN goToKey IN {&hDBOTable} (INPUT c-cidade, INPUT c-estado, INPUT c-pais).
        IF RETURN-VALUE = "NOK":U THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT "Cidade":U).

            RETURN NO-APPLY.
        END.

        /* Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOTable} (OUTPUT rGoTo).

        /* Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).

        APPLY "GO":U TO FRAME fGoToRecord.
    END.

    ENABLE c-cidade c-estado c-pais btGoToOK btGoToCancel 
        WITH FRAME fGoToRecord. 

    WAIT-FOR "GO":U OF FRAME fGoToRecord.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wMaintenance 
PROCEDURE initializeDBOs :
/*------------------------------------------------------------------------------
  Purpose:     Inicializa DBOs
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

    /*--- Verifica se o DBO j† est† inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOTable}) THEN DO:
        {btb/btb008za.i1 dibo/bodi341.p YES}
        {btb/btb008za.i2 dibo/bodi341.p '' {&hDBOTable}}
    END.

    RUN setConstraintDefault IN {&hDBOTable} NO-ERROR.
    RUN openQueryStatic IN {&hDBOTable} (INPUT "Default":U) NO-ERROR.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

