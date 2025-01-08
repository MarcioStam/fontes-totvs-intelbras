&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenance


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttVolume-nf NO-UNDO LIKE volume-nf
       field r-Rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMaintenance 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESFTP008 2.04.00.001}
/********************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESFTP008
&GLOBAL-DEFINE Version        2.04.00.001

&GLOBAL-DEFINE First          YES
&GLOBAL-DEFINE Prev           YES
&GLOBAL-DEFINE Next           YES
&GLOBAL-DEFINE Last           YES
&GLOBAL-DEFINE GoTo           YES
&GLOBAL-DEFINE Search         YES

&GLOBAL-DEFINE Add            YES
&GLOBAL-DEFINE Copy           YES
&GLOBAL-DEFINE Update         YES
&GLOBAL-DEFINE Delete         YES
&GLOBAL-DEFINE Undo           YES
&GLOBAL-DEFINE Cancel         YES
&GLOBAL-DEFINE Save           YES


&GLOBAL-DEFINE ttTable        ttVolume-nf
&GLOBAL-DEFINE hDBOTable      hDBOVolNf
&GLOBAL-DEFINE DBOTable       volume-nf

&GLOBAL-DEFINE page0KeyFields ttVolume-nf.cod-estabel ~
                              ttVolume-nf.nr-nota-fis ~
                              ttVolume-nf.serie ~
                              ttVolume-nf.nr-volume ~
                              ttVolume-nf.it-codigo 
&GLOBAL-DEFINE page0Fields    ttVolume-nf.qtde ttVolume-nf.varios-itens ttVolume-nf.sigla-emb
&GLOBAL-DEFINE page1Fields    
&GLOBAL-DEFINE page2Fields    

/* Global Variable Definitions ---                                     */
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.

/* Parameters Definitions ---                                           */

DEFINE NEW GLOBAL SHARED VARIABLE gr-centro-custo AS rowid NO-UNDO.
DEFINE BUFFER bf1volume-nf FOR mgesp.volume-nf.
DEFINE BUFFER bf2volume-nf FOR mgesp.volume-nf.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE wh-pesquisa AS HANDLE NO-UNDO.

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable}    AS HANDLE NO-UNDO.
DEFINE VARIABLE iQtItemVol      AS INTEGER    NO-UNDO.
DEFINE VARIABLE iNrVolume       AS INTEGER    NO-UNDO.
DEFINE VARIABLE l-varios-itens  AS LOGICAL    NO-UNDO.

DEF VAR i-nr-nota-fis   LIKE nota-fiscal.nr-nota-fis.
DEF VAR c-serie         LIKE nota-fiscal.serie.
DEF VAR c-it-codigo     LIKE it-nota-fisc.it-codigo.
DEF VAR i-vol-ini       AS   INT.
DEF VAR i-vol-fim       AS   INT.
DEFINE VARIABLE i-qt-item   AS INTEGER    NO-UNDO.
DEFINE VARIABLE c-cod-estab AS CHARACTER  NO-UNDO.
DEFINE VARIABLE h-acomp     AS HANDLE     NO-UNDO.

DEF VAR i-nr-nota-fis-del   LIKE nota-fiscal.nr-nota-fis.
DEF VAR c-serie-del         LIKE nota-fiscal.serie.
DEF VAR c-it-codigo-del-ini LIKE it-nota-fisc.it-codigo.
DEF VAR c-it-codigo-del-fim LIKE it-nota-fisc.it-codigo.
DEF VAR i-vol-ini-del       AS   INT.
DEF VAR i-vol-fim-del       AS   INT.
DEF VAR c-cod-estab-del     AS   CHAR  NO-UNDO.
{upc\btb910za-upc.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Maintenance
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ttVolume-nf.cod-estabel ttVolume-nf.serie ~
ttVolume-nf.nr-nota-fis ttVolume-nf.nr-volume ttVolume-nf.it-codigo ~
ttVolume-nf.qtde ttVolume-nf.sigla-emb 
&Scoped-define ENABLED-TABLES ttVolume-nf
&Scoped-define FIRST-ENABLED-TABLE ttVolume-nf
&Scoped-Define ENABLED-OBJECTS RECT-13 RECT-15 RECT-16 rtToolBar btFirst ~
btPrev btNext btLast btGoTo btSearch btAdd fiNome-ab-cli fiNome-transp ~
btCopy cDescItemEmb btUpdate btDelete btUndo btCancel btSave btFaixa ~
btFaixaDel btQueryJoins btReportsJoins btExit btHelp 
&Scoped-Define DISPLAYED-FIELDS ttVolume-nf.cod-estabel ttVolume-nf.serie ~
ttVolume-nf.nr-nota-fis ttVolume-nf.nr-volume ttVolume-nf.it-codigo ~
ttVolume-nf.qtde ttVolume-nf.sigla-emb ttVolume-nf.varios-itens 
&Scoped-define DISPLAYED-TABLES ttVolume-nf
&Scoped-define FIRST-DISPLAYED-TABLE ttVolume-nf
&Scoped-Define DISPLAYED-OBJECTS fiNome-ab-cli fiNome-transp cDescItemEmb ~
cDescItem 

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
       MENU-ITEM miAdd          LABEL "&Incluir"       ACCELERATOR "CTRL-INS"
       MENU-ITEM miCopy         LABEL "&Copiar"        ACCELERATOR "CTRL-C"
       MENU-ITEM miUpdate       LABEL "&Alterar"       ACCELERATOR "CTRL-A"
       MENU-ITEM miDelete       LABEL "&Eliminar"      ACCELERATOR "CTRL-DEL"
       RULE
       MENU-ITEM miUndo         LABEL "&Desfazer"      ACCELERATOR "CTRL-U"
       MENU-ITEM miCancel       LABEL "&Cancelar"      ACCELERATOR "CTRL-F4"
       RULE
       MENU-ITEM miSave         LABEL "&Salvar"        ACCELERATOR "CTRL-S"
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

DEFINE MENU POPUP-MENU-nr-volume 
       MENU-ITEM m_Zoom_Volumes LABEL "Zoom Volumes da Nota Fiscal" ACCELERATOR "F5"
       MENU-ITEM m_Novo_Volume  LABEL "Novo Volume"   .


/* Definitions of the field level widgets                               */
DEFINE BUTTON btAdd 
     IMAGE-UP FILE "image\im-add":U
     IMAGE-INSENSITIVE FILE "image\ii-add":U
     LABEL "Add" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btCancel 
     IMAGE-UP FILE "image\im-can":U
     IMAGE-INSENSITIVE FILE "image\im-can":U
     LABEL "Cancel" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btCopy 
     IMAGE-UP FILE "image\im-copy":U
     IMAGE-INSENSITIVE FILE "image\ii-copy":U
     LABEL "Copy" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btDelete 
     IMAGE-UP FILE "image\im-era":U
     IMAGE-INSENSITIVE FILE "image\ii-era":U
     LABEL "Delete" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btFaixa 
     IMAGE-UP FILE "image/im-autom.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-autom.bmp":U
     LABEL "Faixa" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btFaixaDel 
     IMAGE-UP FILE "image/im-ran.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-ran.bmp":U
     LABEL "Faixa Eliminaá∆o" 
     SIZE 4 BY 1.25 TOOLTIP "Faixa de Eliminaá∆o".

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

DEFINE BUTTON btSave 
     IMAGE-UP FILE "image\im-sav":U
     IMAGE-INSENSITIVE FILE "image\ii-sav":U
     LABEL "Save" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btSearch 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "Search" 
     SIZE 4 BY 1.25.

DEFINE BUTTON btUndo 
     IMAGE-UP FILE "image\im-undo":U
     IMAGE-INSENSITIVE FILE "image\ii-undo":U
     LABEL "Undo" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btUpdate 
     IMAGE-UP FILE "image\im-mod":U
     IMAGE-INSENSITIVE FILE "image\ii-mod":U
     LABEL "Update" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE VARIABLE cDescItem AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 33.57 BY .88 NO-UNDO.

DEFINE VARIABLE cDescItemEmb AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40.57 BY .88 NO-UNDO.

DEFINE VARIABLE fiNome-ab-cli AS CHARACTER FORMAT "X(256)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 50 BY .88 NO-UNDO.

DEFINE VARIABLE fiNome-transp AS CHARACTER FORMAT "X(256)":U 
     LABEL "Transportador" 
     VIEW-AS FILL-IN 
     SIZE 50 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90.29 BY 5.5.

DEFINE RECTANGLE RECT-15
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90.29 BY 2.5.

DEFINE RECTANGLE RECT-16
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90.29 BY 2.5.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90.29 BY 1.5
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btFirst AT ROW 1.17 COL 1.57 HELP
          "Primeira ocorrància"
     btPrev AT ROW 1.17 COL 5.57 HELP
          "Ocorrància anterior"
     btNext AT ROW 1.17 COL 9.57 HELP
          "Pr¢xima ocorrància"
     btLast AT ROW 1.17 COL 13.57 HELP
          "Èltima ocorrància"
     btGoTo AT ROW 1.17 COL 17.57 HELP
          "V† Para"
     btSearch AT ROW 1.17 COL 21.57 HELP
          "Pesquisa"
     btAdd AT ROW 1.17 COL 30.72 HELP
          "Inclui nova ocorrància"
     ttVolume-nf.cod-estabel AT ROW 3 COL 24.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     ttVolume-nf.serie AT ROW 4 COL 24.14 COLON-ALIGNED
          LABEL "SÇrie"
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     ttVolume-nf.nr-nota-fis AT ROW 5 COL 24.14 COLON-ALIGNED
          LABEL "Nota Fiscal"
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     fiNome-ab-cli AT ROW 6 COL 24.14 COLON-ALIGNED
     fiNome-transp AT ROW 7 COL 24.14 COLON-ALIGNED
     ttVolume-nf.nr-volume AT ROW 8.67 COL 24.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     ttVolume-nf.it-codigo AT ROW 9.67 COL 24.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     ttVolume-nf.qtde AT ROW 11.33 COL 24.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9 BY .88
     ttVolume-nf.sigla-emb AT ROW 12.33 COL 24.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9 BY .88
     btCopy AT ROW 1.17 COL 34.72 HELP
          "Cria uma c¢pia da ocorrància corrente"
     cDescItemEmb AT ROW 12.33 COL 33.43 COLON-ALIGNED NO-LABEL
     btUpdate AT ROW 1.17 COL 38.72 HELP
          "Altera ocorrància corrente"
     ttVolume-nf.varios-itens AT ROW 8.67 COL 37.57
          VIEW-AS TOGGLE-BOX
          SIZE 12.43 BY .83
     btDelete AT ROW 1.17 COL 42.72 HELP
          "Elimina ocorrància corrente"
     cDescItem AT ROW 9.67 COL 40.43 COLON-ALIGNED NO-LABEL
     btUndo AT ROW 1.17 COL 46.72 HELP
          "Desfaz alteraá‰es"
     btCancel AT ROW 1.17 COL 50.72 HELP
          "Cancela alteraá‰es"
     btSave AT ROW 1.17 COL 54.72 HELP
          "Confirma alteraá‰es"
     btFaixa AT ROW 1.17 COL 61.86 HELP
          "Confirma alteraá‰es"
     btFaixaDel AT ROW 1.17 COL 65.86 HELP
          "Elimina Volumes por Faixa"
     btQueryJoins AT ROW 1.17 COL 74.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.17 COL 78.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.17 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.17 COL 86.72 HELP
          "Ajuda"
     RECT-13 AT ROW 2.67 COL 1
     RECT-15 AT ROW 11 COL 1
     RECT-16 AT ROW 8.33 COL 1
     rtToolBar AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90.29 BY 12.58
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Maintenance
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: ttVolume-nf T "?" NO-UNDO mgesp volume-nf
      ADDITIONAL-FIELDS:
          field r-Rowid as rowid
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
         HEIGHT             = 12.58
         WIDTH              = 90.29
         MAX-HEIGHT         = 27.17
         MAX-WIDTH          = 195.14
         VIRTUAL-HEIGHT     = 27.17
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wMaintenance 
/* ************************* Included-Libraries *********************** */

{maintenance/maintenance.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wMaintenance
  NOT-VISIBLE,                                                          */
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME L-To-R,COLUMNS                                            */
/* SETTINGS FOR FILL-IN cDescItem IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ttVolume-nf.nr-nota-fis IN FRAME fpage0
   EXP-LABEL                                                            */
ASSIGN 
       ttVolume-nf.nr-volume:POPUP-MENU IN FRAME fpage0       = MENU POPUP-MENU-nr-volume:HANDLE.

/* SETTINGS FOR FILL-IN ttVolume-nf.serie IN FRAME fpage0
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX ttVolume-nf.varios-itens IN FRAME fpage0
   NO-ENABLE                                                            */
ASSIGN 
       ttVolume-nf.varios-itens:HIDDEN IN FRAME fpage0           = TRUE.

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


&Scoped-define SELF-NAME fpage0
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fpage0 wMaintenance
ON GO OF FRAME fpage0
DO:
    btAdd:SENSITIVE = FALSE.  
    btFirst:SENSITIVE = FALSE.
    btPrev:SENSITIVE = FALSE.
    btNext:SENSITIVE = FALSE.
    btLast:SENSITIVE = FALSE.

    RUN goToRecord IN THIS-PROCEDURE.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btAdd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAdd wMaintenance
ON CHOOSE OF btAdd IN FRAME fpage0 /* Add */
OR CHOOSE OF MENU-ITEM miAdd in MENU mbMain DO:
    
     RUN addRecord IN THIS-PROCEDURE.
    /*assign ttTecnMi.cd-tecnico:screen-value in frame fPage0 = "000000".*/
   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wMaintenance
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancel */
OR CHOOSE OF MENU-ITEM miCancel IN MENU mbMain DO:
    cDescItemEmb:SCREEN-VALUE = "".
    RUN cancelRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCopy
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCopy wMaintenance
ON CHOOSE OF btCopy IN FRAME fpage0 /* Copy */
OR CHOOSE OF MENU-ITEM miCopy IN MENU mbMain DO:
    RUN copyRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btDelete
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDelete wMaintenance
ON CHOOSE OF btDelete IN FRAME fpage0 /* Delete */
OR CHOOSE OF MENU-ITEM miDelete IN MENU mbMain DO:
    RUN deleteRecord IN THIS-PROCEDURE.
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


&Scoped-define SELF-NAME btFaixa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFaixa wMaintenance
ON CHOOSE OF btFaixa IN FRAME fpage0 /* Faixa */
DO:
    RUN piPedeTelaFaixa IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btFaixaDel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFaixaDel wMaintenance
ON CHOOSE OF btFaixaDel IN FRAME fpage0 /* Faixa Eliminaá∆o */
DO:
  RUN piPedeTelaFaixaDel IN THIS-PROCEDURE.
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


&Scoped-define SELF-NAME btSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave wMaintenance
ON CHOOSE OF btSave IN FRAME fpage0 /* Save */
OR CHOOSE OF MENU-ITEM miSave IN MENU mbMain DO:



    RUN saveRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSearch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSearch wMaintenance
ON CHOOSE OF btSearch IN FRAME fpage0 /* Search */
OR CHOOSE OF MENU-ITEM miSearch IN MENU mbMain DO:
    {method/ZoomReposition.i &ProgramZoom="eszoom/z01es295.w"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btUndo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUndo wMaintenance
ON CHOOSE OF btUndo IN FRAME fpage0 /* Undo */
OR CHOOSE OF MENU-ITEM miUndo IN MENU mbMain DO:
    RUN undoRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btUpdate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdate wMaintenance
ON CHOOSE OF btUpdate IN FRAME fpage0 /* Update */
OR CHOOSE OF MENU-ITEM miUpdate IN MENU mbMain DO:
    RUN updateRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttVolume-nf.cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttVolume-nf.cod-estabel wMaintenance
ON MOUSE-SELECT-DBLCLICK OF ttVolume-nf.cod-estabel IN FRAME fpage0 /* Estabelecimento */
OR 'F5' OF {&SELF-NAME} IN FRAME {&FRAME-NAME} DO:
    APPLY 'F5' TO ttVolume-nf.nr-nota-fis IN FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttVolume-nf.it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttVolume-nf.it-codigo wMaintenance
ON LEAVE OF ttVolume-nf.it-codigo IN FRAME fpage0 /* Item */
DO:
    FIND ITEM NO-LOCK WHERE ITEM.it-codigo = INPUT FRAME {&FRAME-NAME} {&SELF-NAME} NO-ERROR.
    ASSIGN cDescItem = IF AVAILABLE ITEM THEN ITEM.desc-item ELSE ''.
    DISPLAY cDescItem WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttVolume-nf.it-codigo wMaintenance
ON MOUSE-SELECT-DBLCLICK OF ttVolume-nf.it-codigo IN FRAME fpage0 /* Item */
OR 'F5' OF {&SELF-NAME} IN FRAME {&FRAME-NAME} DO:
    assign l-implanta = yes.
    {include/zoomvar.i &prog-zoom="inzoom/z01in172.w"
                     &campo=ttvolume-nf.it-codigo
                     &campozoom=it-codigo
                     &campo2=cDescItem
                     &campozoom2=desc-item}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Novo_Volume
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Novo_Volume wMaintenance
ON CHOOSE OF MENU-ITEM m_Novo_Volume /* Novo Volume */
DO:
    RUN piNovoVolume IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Zoom_Volumes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Zoom_Volumes wMaintenance
ON CHOOSE OF MENU-ITEM m_Zoom_Volumes /* Zoom Volumes da Nota Fiscal */
DO:
    APPLY 'F5' TO ttVolume-nf.nr-volume IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttVolume-nf.nr-nota-fis
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttVolume-nf.nr-nota-fis wMaintenance
ON LEAVE OF ttVolume-nf.nr-nota-fis IN FRAME fpage0 /* Nota Fiscal */
DO:
    ASSIGN fiNome-ab-cli = ''
           fiNome-transp = ''.

    FIND nota-fiscal NO-LOCK
        WHERE nota-fiscal.cod-estabel = INPUT FRAME {&FRAME-NAME} ttVolume-nf.cod-estabel
          AND nota-fiscal.serie       = INPUT FRAME {&FRAME-NAME} ttVolume-nf.serie
          AND nota-fiscal.nr-nota-fis = INPUT FRAME {&FRAME-NAME} {&SELF-NAME}
        NO-ERROR.
    IF AVAILABLE nota-fiscal THEN DO:
        FIND emitente NO-LOCK WHERE emitente.cod-emitente = nota-fiscal.cod-emitente NO-ERROR.
        ASSIGN fiNome-ab-cli = IF AVAILABLE emitente THEN emitente.nome-emit ELSE ''
               fiNome-transp = nota-fiscal.nome-transp.
    END.

    DISPLAY fiNome-ab-cli fiNome-transp WITH FRAME {&FRAME-NAME}.

    IF INPUT FRAME {&FRAME-NAME} ttVolume-nf.nr-volume = 0  AND
       ttVolume-nf.nr-volume:SENSITIVE IN FRAME {&FRAME-NAME} THEN
        RUN piNovoVolume IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttVolume-nf.nr-nota-fis wMaintenance
ON MOUSE-SELECT-DBLCLICK OF ttVolume-nf.nr-nota-fis IN FRAME fpage0 /* Nota Fiscal */
OR 'F5' OF {&SELF-NAME} IN FRAME {&FRAME-NAME} DO:
    {include/zoomvar.i &prog-zoom="dizoom/z03di135.w"
                     &campo=ttvolume-nf.cod-estabel
                     &campozoom=cod-estabel
                     &campo2=ttvolume-nf.serie
                     &campozoom2=serie
                     &campo3=ttvolume-nf.nr-nota-fis
                     &campozoom3=nr-nota-fis}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttVolume-nf.nr-volume
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttVolume-nf.nr-volume wMaintenance
ON MOUSE-SELECT-DBLCLICK OF ttVolume-nf.nr-volume IN FRAME fpage0 /* Volume */
OR F5 OF {&SELF-NAME} IN FRAME {&FRAME-NAME} DO:
    {method/ZoomFields.i &ProgramZoom="eszoom/z01es295.w"
                         &FieldZoom1="nr-volume"
                         &FieldScreen1="ttVolume-nf.nr-volume"
                         &Frame1="{&FRAME-NAME}"
                         &RunMethod="RUN piRecebeNotaFiscal IN hProgramZoom (INPUT INPUT FRAME {&FRAME-NAME} ttVolume-nf.cod-estabel, ~
                                                                             INPUT INPUT FRAME {&FRAME-NAME}  ttVolume-nf.serie, ~
                                                                             INPUT INPUT FRAME {&FRAME-NAME}  ttVolume-nf.nr-nota-fis)."
                         &EnableImplant="NO"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttVolume-nf.serie
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttVolume-nf.serie wMaintenance
ON MOUSE-SELECT-DBLCLICK OF ttVolume-nf.serie IN FRAME fpage0 /* SÇrie */
OR 'F5' OF {&SELF-NAME} IN FRAME {&FRAME-NAME} DO:
    APPLY 'F5' TO ttVolume-nf.nr-nota-fis IN FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttVolume-nf.sigla-emb
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttVolume-nf.sigla-emb wMaintenance
ON LEAVE OF ttVolume-nf.sigla-emb IN FRAME fpage0 /* Embalagem */
DO:
    FIND embalag NO-LOCK WHERE
       embalag.sigla-emb = INPUT FRAME {&FRAME-NAME} {&SELF-NAME} NO-ERROR.
  ASSIGN cDescItemEmb = IF AVAILABLE embalag THEN embalag.descricao ELSE ''.
  DISPLAY cDescItemEmb WITH FRAME {&FRAME-NAME}.  

    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttVolume-nf.sigla-emb wMaintenance
ON MOUSE-SELECT-DBLCLICK OF ttVolume-nf.sigla-emb IN FRAME fpage0 /* Embalagem */
OR 'F5' OF {&SELF-NAME} IN FRAME {&FRAME-NAME} DO:
        /* assign l-implanta = yes. */
        {include/zoomvar.i &prog-zoom="dizoom/z01di040.w"
                         &campo=ttvolume-nf.sigla-emb
                         &campozoom=sigla-emb
                         &campo2=cDescItemEmb}
                         
    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenance 


/*
ttvolume-nf.cc-codigo:load-mouse-pointer  ("image/lupa.cur") in frame fPage0.
ttvolume-nf.cd-calen:load-mouse-pointer   ("image/lupa.cur") in frame fPage0.
ttvolume-nf.cd-equipe:load-mouse-pointer  ("image/lupa.cur") in frame fPage0.
ttvolume-nf.cd-mob-dir:load-mouse-pointer ("image/lupa.cur") in frame fPage0.
*/
/*--- L¢gica para inicializaá∆o do programam ---*/
{maintenance/MainBlock.i}


    btFirst:SENSITIVE = FALSE.
    btPrev:SENSITIVE = FALSE.
    btNext:SENSITIVE = FALSE.
    btLast:SENSITIVE = FALSE.


    btgoto:SENSITIVE = TRUE.
    btsearch:SENSITIVE = TRUE.
    btadd:SENSITIVE = TRUE.

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

     APPLY 'leave':U TO ttVolume-nf.nr-nota-fis IN FRAME fPage0.
     APPLY 'leave':U TO ttVolume-nf.it-codigo   IN FRAME fPage0.

     RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterEnableFields wMaintenance 
PROCEDURE AfterEnableFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE iNrVolume AS INTEGER    NO-UNDO.

    DO WITH FRAME fPage0:
        DISABLE ttVolume-nf.varios-itens.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeInitializeInterface wMaintenance 
PROCEDURE beforeInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FOR FIRST param-global NO-LOCK,
        FIRST estabelec NO-LOCK
        WHERE estabelec.ep-codigo = param-global.empresa-pri:
    END.
    ASSIGN btFaixa:SENSITIVE IN FRAME fPage0 = YES
           btFaixaDel:SENSITIVE IN FRAME fPage0 = YES.

    ttVolume-nf.cod-estabel:LOAD-MOUSE-POINTER  ("image/lupa.cur") IN FRAME fPage0.
    ttVolume-nf.serie:LOAD-MOUSE-POINTER        ("image/lupa.cur") IN FRAME fPage0.
    ttVolume-nf.nr-nota-fis:LOAD-MOUSE-POINTER  ("image/lupa.cur") IN FRAME fPage0.
    ttVolume-nf.it-codigo:LOAD-MOUSE-POINTER    ("image/lupa.cur") IN FRAME fPage0.
    ttVolume-nf.sigla-emb:LOAD-MOUSE-POINTER    ("image/lupa.cur") IN FRAME fPage0.
    ttVolume-nf.nr-volume:LOAD-MOUSE-POINTER    ("image/rbm.cur")  IN FRAME fPage0.

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
    
    DEFINE VARIABLE vEstabel     LIKE ttvolume-nf.cod-estabel
           VIEW-AS FILL-IN SIZE 05 BY 0.88 NO-UNDO.
    DEFINE VARIABLE vNr-nota-fis LIKE ttvolume-nf.nr-nota-fis 
           VIEW-AS FILL-IN SIZE 16 BY 0.88 NO-UNDO.
    DEFINE VARIABLE vSerie       LIKE ttvolume-nf.serie       
           VIEW-AS FILL-IN SIZE 05 BY 0.88 NO-UNDO.
    DEFINE VARIABLE vNr-volume   LIKE ttvolume-nf.nr-volume   
           VIEW-AS FILL-IN SIZE 06 BY 0.88 NO-UNDO.
    DEFINE VARIABLE vIt-codigo   LIKE ttvolume-nf.it-codigo   
           VIEW-AS FILL-IN SIZE 16 BY 0.88 NO-UNDO.

    DEFINE FRAME fGoToRecord
        vEstabel          AT ROW 1.17 COL 24.72 COLON-ALIGNED
        vSerie            AT ROW 2.17 COL 24.72 COLON-ALIGNED
        vNr-nota-fis      AT ROW 3.17 COL 24.72 COLON-ALIGNED
        vNr-volume        AT ROW 4.17 COL 24.72 COLON-ALIGNED
        vIt-codigo        AT ROW 5.17 COL 24.72 COLON-ALIGNED
        btGoToOK          AT ROW 6.40 COL 2.14
        btGoToCancel      AT ROW 6.40 COL 13
        rtGoToButton      AT ROW 6.17 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V† Para Volume NF" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.

    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN vEstabel
               vNr-nota-fis
               vSerie      
               vNr-volume  
               vIt-codigo.

        RUN goToKey IN {&hDBOTable} (INPUT vEstabel,
                                     INPUT vSerie,      
                                     INPUT vNr-nota-fis,
                                     INPUT vNr-volume,  
                                     INPUT vIt-codigo).

        IF RETURN-VALUE = "NOK":U THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT "Volume Nota").
            RETURN NO-APPLY.
        END.

        /* Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOTable} (OUTPUT rGoTo).

        /* Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).                        

        APPLY "GO":U TO FRAME fGoToRecord.
    END.

    ENABLE vEstabel
           vSerie       
           vNr-nota-fis 
           vNr-volume   
           vIt-codigo   
           btGoToOK 
           btGoToCancel 
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
    IF VALID-HANDLE({&hDBOTable}) THEN DELETE PROCEDURE {&hDBOTable}.
    
    IF NOT VALID-HANDLE({&hDBOTable}) OR
       {&hDBOTable}:TYPE <> "PROCEDURE":U OR
       {&hDBOTable}:FILE-NAME <> "hDBOVolNf":U THEN DO:
        {btb/btb008za.i1 esbo\boes295.p YES}
        {btb/btb008za.i2 esbo\boes295.p '' {&hDBOTable}}
    END.
    
    RUN openQueryStatic   IN {&hDBOTable} (INPUT "Main") NO-ERROR.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piGeraFaixa wMaintenance 
PROCEDURE piGeraFaixa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE i-cont              AS INTEGER   NO-UNDO.
    DEFINE VARIABLE qt-item-volume      AS CHARACTER NO-UNDO.
    
    /*Vari†veis de teste*/
    DEFINE VARIABLE i-qt-vol-total      AS INTEGER   NO-UNDO.
    DEFINE VARIABLE i-qt-vol-total-novo AS INTEGER   NO-UNDO.
    DEFINE VARIABLE i-qt-por-vol        AS INTEGER   NO-UNDO.
    DEFINE VARIABLE i-qt-por-vol-novo   AS INTEGER   NO-UNDO.
    DEFINE VARIABLE i-qt-total          AS INTEGER   NO-UNDO.
    DEFINE VARIABLE cReturn             AS CHARACTER NO-UNDO.
    DEFINE VARIABLE i-nr-volumes-novo   AS INTEGER   NO-UNDO.
    DEFINE VARIABLE i-qt-faturada       AS DECIMAL     NO-UNDO.
    /***********************/

    find first nota-fiscal no-lock 
         where nota-fiscal.cod-estabel = c-cod-estab
           and nota-fiscal.serie       = c-serie
           and nota-fiscal.nr-nota-fis = i-nr-nota-fis no-error.

      if not avail nota-fiscal then do:
         message "Nota fiscal nao cadastrada" 
                 VIEW-AS ALERT-BOX INFO BUTTONS OK.
         RETURN NO-APPLY.
      end.
      ELSE DO:
          FIND FIRST it-nota-fisc NO-LOCK OF nota-fiscal
               WHERE it-nota-fisc.it-codigo = c-it-codigo NO-ERROR.
          IF NOT AVAIL it-nota-fisc THEN
          DO:
              MESSAGE "Item da nota n∆o cadastrado. Confirma Inclus∆o ?"
                  VIEW-AS ALERT-BOX QUESTION BUTTONS  YES-NO-CANCEL UPDATE l-opcao AS LOGICAL.
              IF l-opcao = NO THEN
                 RETURN NO-APPLY.
          END.
          ELSE DO:
              ASSIGN i-qt-faturada = 0.
              FOR EACH it-nota-fisc NO-LOCK OF nota-fiscal
                  WHERE it-nota-fisc.it-codigo = c-it-codigo:
                  ASSIGN i-qt-faturada = i-qt-faturada + it-nota-fisc.qt-faturada[1].
              END.
          END.
      END.
      
      run utp/ut-acomp.p persistent set h-acomp.
      run pi-inicializar in h-acomp ("Gerando..").
      /*IF AVAIL it-nota-fisc THEN DO:*/
          /*for each para contabilizar a quantidade de
          itens e volumes j† gerados.*/
          FOR EACH mgesp.volume-nf
             where volume-nf.cod-estabel = c-cod-estab
               and volume-nf.serie       = c-serie
               and volume-nf.nr-nota-fis = i-nr-nota-fis
               and volume-nf.it-codigo   = c-it-codigo NO-LOCK:
             IF AVAIL volume-nf THEN
                 ASSIGN i-qt-vol-total  = i-qt-vol-total + volume-nf.qtde.
          END.
    
          ASSIGN i-nr-volumes-novo = (i-vol-fim + 1) - i-vol-ini.
          
          ASSIGN i-qt-vol-total-novo = i-qt-item * i-nr-volumes-novo /*Quantidade total novo*/ 
                 i-qt-total = i-qt-vol-total-novo + i-qt-vol-total. /*Quantidade total novo + atual*/ 
          
          FIND FIRST ITEM NO-LOCK 
               WHERE ITEM.it-codigo = c-it-codigo NO-ERROR.
          /*se a quantidade total(valores informados  + quantidade atual)
          for maior que a quantidade faturada na nota.*/
          IF i-qt-total > i-qt-faturada 
          AND ITEM.cod-unid-negoc <> "ENS" THEN DO:
              MESSAGE "ParÉmetros informados ultrapassam quantidade faturada."
                  VIEW-AS ALERT-BOX INFO BUTTONS OK.
          END. /*IF i-qt-total > it-nota-fisc.qt-faturada[1] THEN DO:*/
          ELSE DO: 
              blk:  
              DO ON STOP UNDO blk, LEAVE blk:
                  do i-cont = i-vol-ini to i-vol-fim:
                     RUN pi-acompanhar IN h-acomp (INPUT "Volume: " + STRING(i-cont)).
            
                     find first mgesp.volume-nf use-index volume-nf
                          where volume-nf.cod-estabel = c-cod-estab
                            and volume-nf.serie       = c-serie
                            and volume-nf.nr-nota-fis = i-nr-nota-fis
                            and volume-nf.nr-volume   = i-cont 
                            and volume-nf.it-codigo   = c-it-codigo no-lock no-error.
                     
                     if not avail volume-nf then do:
                        create mgesp.volume-nf.
                        assign volume-nf.cod-estabel = c-cod-estab
                               volume-nf.serie       = c-serie
                               volume-nf.nr-nota-fis = i-nr-nota-fis
                               volume-nf.it-codigo   = c-it-codigo
                               volume-nf.nr-volume   = i-cont
                               volume-nf.qtde        = i-qt-item.
                        
                        RUN setConstraintMain IN {&hDBOTable} (INPUT v_cod_estab_usuar) NO-ERROR.
                        RUN openQueryStatic   IN {&hDBOTable} (INPUT "Main":U) NO-ERROR.
                        RUN atualizaVolumes IN hDBOVolNf (volume-nf.cod-estabel,
                                                          volume-nf.serie,
                                                          volume-nf.nr-nota-fis,
                                                          volume-nf.nr-volume).
                     end.
                  end.
         
                  if valid-handle(h-acomp) then
                    run pi-finalizar in h-acomp.
                
                  RUN getNext IN THIS-PROCEDURE.
         
                  MESSAGE 'Execuá∆o efetuada com sucesso'
                     VIEW-AS ALERT-BOX INFO BUTTONS OK.
         
              end. /* DO TRANS */
              
              if valid-handle(h-acomp) then
                   run pi-finalizar in h-acomp.
          END. /*ELSE DO: */
      /*END.*/ /*IF AVAIL it-nota-fisc THEN DO:*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piGeraFaixaDel wMaintenance 
PROCEDURE piGeraFaixaDel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE i-cont AS INTEGER    NO-UNDO.

    run utp/ut-acomp.p persistent set h-acomp.
    run pi-inicializar in h-acomp ("Eliminando..").

    blk:  
    DO ON STOP UNDO blk, LEAVE blk:
        blk-sec:
        DO i-cont = i-vol-ini-del TO i-vol-fim-del:        
            RUN pi-acompanhar IN h-acomp (INPUT "Volume: " + STRING(i-cont)).
 
            FOR EACH mgesp.volume-nf EXCLUSIVE-LOCK
                WHERE volume-nf.cod-estabel  = c-cod-estab-del
                  AND volume-nf.nr-nota-fis  = i-nr-nota-fis-del
                  AND volume-nf.serie        = c-serie-del
                  AND volume-nf.it-codigo   >= c-it-codigo-del-ini
                  AND volume-nf.it-codigo   <= c-it-codigo-del-fim
                  AND volume-nf.nr-volume    = i-cont:                
                DELETE volume-nf.
            END.

            /** Validaá∆o de performance **/    
            IF i-cont <> i-vol-fim-del AND
                NOT CAN-FIND (FIRST mgesp.volume-nf
                              WHERE volume-nf.cod-estabel = c-cod-estab-del
                                AND volume-nf.nr-nota-fis = i-nr-nota-fis-del
                                AND volume-nf.serie       = c-serie-del
                                AND volume-nf.it-codigo  >= c-it-codigo-del-ini
                                AND volume-nf.it-codigo  <= c-it-codigo-del-fim
                                AND volume-nf.nr-volume  > i-cont) THEN
                LEAVE blk-sec.
        END.

        IF VALID-HANDLE(h-acomp) THEN
            RUN pi-finalizar in h-acomp.

        RUN getNext IN THIS-PROCEDURE.

        MESSAGE 'Exclus∆o efetuada com sucesso'
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END. /* DO TRANS */

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-finalizar IN h-acomp.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piNovoVolume wMaintenance 
PROCEDURE piNovoVolume :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE iNrVolume   AS INTEGER      NO-UNDO.

    RUN GetLastVolume IN hDBOVolNf (INPUT INPUT FRAME {&FRAME-NAME} ttVolume-nf.cod-estabel,
                                    INPUT INPUT FRAME {&FRAME-NAME} ttVolume-nf.serie,
                                    INPUT INPUT FRAME {&FRAME-NAME} ttVolume-nf.nr-nota-fis,
                                    OUTPUT iNrVolume).

    ASSIGN iNrVolume = iNrVolume + 1.

    DISPLAY iNrVolume @ ttVolume-nf.nr-volume WITH FRAME {&FRAME-NAME}.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piPedeTelaFaixa wMaintenance 
PROCEDURE piPedeTelaFaixa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE BUTTON    btGoToOK     AUTO-GO LABEL "&OK" SIZE 10 BY 1 BGCOLOR 8.
    DEFINE BUTTON    btGoToCancel AUTO-GO LABEL "&Cancela" SIZE 10 BY 1 BGCOLOR 8.
    DEFINE RECTANGLE rtGoToFields  EDGE-PIXELS 2 GRAPHIC-EDGE SIZE 65 BY 6.3 BGCOLOR 8.
    DEFINE RECTANGLE rtGoToButton  EDGE-PIXELS 2 GRAPHIC-EDGE SIZE 65 BY 1.5 BGCOLOR 7.
    
    DEFINE VARIABLE fiCodEstab  LIKE nota-fiscal.cod-estabel LABEL "Estabelecimento"       VIEW-AS FILL-IN  SIZE 6 BY .88 NO-UNDO INITIAL '101'.
    DEFINE VARIABLE fiSerie     LIKE nota-fiscal.serie       LABEL "Serie"       VIEW-AS FILL-IN  SIZE 6 BY .88 NO-UNDO INITIAL '3'.
    DEFINE VARIABLE fiNrNotaFis LIKE nota-fiscal.nr-nota-fis LABEL "N£mero Nota" VIEW-AS FILL-IN  SIZE 16 BY .88 NO-UNDO.
    DEFINE VARIABLE fivolIni    AS INT FORMAT '>>>,>>9'      LABEL "Volume Inicial" VIEW-AS FILL-IN  SIZE 8 BY .88 NO-UNDO.
    DEFINE VARIABLE fivolFim    AS INT FORMAT '>>>,>>9'      INIT  999999           VIEW-AS FILL-IN  SIZE 8 BY .88 NO-UNDO.
    DEFINE VARIABLE fiItCodigo  LIKE it-nota-fisc.it-codigo   VIEW-AS FILL-IN  SIZE 16 BY .88 NO-UNDO.
    DEFINE VARIABLE fiQt-item   AS INTEGER NO-UNDO VIEW-AS FILL-IN SIZE 8 BY 0.88 LABEL 'Qtde It p/ volume'.

    DEFINE FRAME fFaixa
           fiCodEstab        AT ROW 1.17 COL 18 COLON-ALIGNED
           fiSerie           AT ROW 2.17 COL 18 COLON-ALIGNED
           fiNrNotaFis       AT ROW 3.17 COL 18 COLON-ALIGNED 
           fiItCodigo        AT ROW 4.17 COL 18 COLON-ALIGNED
           fivolIni          AT ROW 5.17 COL 18 COLON-ALIGNED
           fivolFim          AT ROW 5.17 COL 36 COLON-ALIGNED NO-LABEL
           fiQt-item         AT ROW 6.17 COL 18 COLON-ALIGNED
           rtGoToFields      AT ROW 1    COL 1
           btGoToOK          AT ROW 7.7  COL 2.14
           btGoToCancel      AT ROW 7.7  COL 13.14
           rtGoToButton      AT ROW 7.5  COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "Gera por Faixa" FONT 1
             DEFAULT-BUTTON btGoToOK.

    ON  "CHOOSE":U OF btGoToOK IN FRAME fFaixa DO:
        ASSIGN i-nr-nota-fis = INPUT FRAME fFaixa finrnotafis
               c-serie = INPUT FRAME fFaixa fiserie
               c-cod-estab = INPUT FRAME fFaixa fiCodEstab
               c-it-codigo = INPUT FRAME fFaixa fiitcodigo
               i-vol-ini = INPUT FRAME fFaixa fivolini
               i-vol-fim = INPUT FRAME fFaixa fivolfim
               i-qt-item = INPUT FRAME fFaixa fiQt-item.

        RUN piGeraFaixa IN THIS-PROCEDURE.
        APPLY "GO":U TO FRAME fFaixa.
    END.
    ON  "CHOOSE":U OF btGoToCancel IN FRAME fFaixa DO:
        APPLY "GO":U TO FRAME fFaixa.
        ASSIGN i-nr-nota-fis = "".
    END.

    DISP 
        fiCodEstab
        fiNrNotaFis
        FiSerie
        fiItCodigo
        fivolIni 
        fivolFim 
        fiQt-item
       WITH FRAME fFaixa.

    ENABLE fiNrNotaFis
           FiSerie
           fiCodEstab
           fiItCodigo
           fivolIni 
           fivolFim 
           fiQt-item
           btGoToOK 
           btGoToCancel
           WITH FRAME fFaixa.
    
    WAIT-FOR "GO":U OF FRAME fFaixa.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piPedeTelaFaixaDel wMaintenance 
PROCEDURE piPedeTelaFaixaDel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE BUTTON    btGoToOK     AUTO-GO LABEL "&OK" SIZE 10 BY 1 BGCOLOR 8.
    DEFINE BUTTON    btGoToCancel AUTO-GO LABEL "&Cancela" SIZE 10 BY 1 BGCOLOR 8.
    DEFINE RECTANGLE rtGoToFields  EDGE-PIXELS 2 GRAPHIC-EDGE SIZE 65 BY 6.3 BGCOLOR 8.
    DEFINE RECTANGLE rtGoToButton  EDGE-PIXELS 2 GRAPHIC-EDGE SIZE 65 BY 1.5 BGCOLOR 7.
    
    DEFINE VARIABLE fiCodEstabDel  LIKE nota-fiscal.cod-estabel LABEL "Estabelecimento"       VIEW-AS FILL-IN  SIZE 6 BY .88 NO-UNDO INITIAL '101'.
    DEFINE VARIABLE fiSerieDel     LIKE nota-fiscal.serie       LABEL "Serie"       INIT "3" VIEW-AS FILL-IN  SIZE 6 BY .88 NO-UNDO.
    DEFINE VARIABLE fiNrNotaFisDel LIKE nota-fiscal.nr-nota-fis LABEL "N£mero Nota" VIEW-AS FILL-IN  SIZE 16 BY .88 NO-UNDO.
    DEFINE VARIABLE fivolIniDel    AS INT FORMAT '>>>,>>9'      LABEL "Volume Inicial" VIEW-AS FILL-IN  SIZE 8 BY .88 NO-UNDO.
    DEFINE VARIABLE fivolFimDel    AS INT FORMAT '>>>,>>9'      INIT  999999           VIEW-AS FILL-IN  SIZE 8 BY .88 NO-UNDO.
    DEFINE VARIABLE fiItCodigoDelIni  LIKE it-nota-fisc.it-codigo VIEW-AS FILL-IN  SIZE 16 BY .88 NO-UNDO.
    DEFINE VARIABLE fiItCodigoDelFim  LIKE it-nota-fisc.it-codigo INIT  "ZZZZZZ" VIEW-AS FILL-IN  SIZE 16 BY .88 NO-UNDO.
                                                                    
    DEFINE FRAME fFaixaDel
           fiCodEstabDel        AT ROW 1.17 COL 18 COLON-ALIGNED
           fiSerieDel           AT ROW 2.17 COL 18 COLON-ALIGNED
           fiNrNotaFisDel       AT ROW 3.17 COL 18 COLON-ALIGNED 
           fiItCodigoDelIni     AT ROW 4.17 COL 18 COLON-ALIGNED
           fiItCodigoDelFim     AT ROW 4.17 COL 36 COLON-ALIGNED NO-LABEL  
           fivolIniDel          AT ROW 5.17 COL 18 COLON-ALIGNED
           fivolFimDel          AT ROW 5.17 COL 36 COLON-ALIGNED NO-LABEL
           rtGoToFields      AT ROW 1    COL 1
           btGoToOK          AT ROW 6.7  COL 2.14
           btGoToCancel      AT ROW 6.7  COL 13.14
           rtGoToButton      AT ROW 6.5  COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "Eliminaá∆o por Faixa" FONT 1
             DEFAULT-BUTTON btGoToOK.

    ON  "CHOOSE":U OF btGoToOK IN FRAME fFaixaDel DO:
        ASSIGN i-nr-nota-fis-del = INPUT FRAME fFaixaDel finrnotafisdel
               c-serie-del = INPUT FRAME fFaixaDel fiseriedel
               c-cod-estab-del = INPUT FRAME fFaixaDel fiCodEstabdel
               c-it-codigo-del-ini = INPUT FRAME fFaixaDel fiitcodigodelini
               c-it-codigo-del-fim = INPUT FRAME fFaixaDel fiitcodigodelfim
               i-vol-ini-del = INPUT FRAME fFaixaDel fivolinidel
               i-vol-fim-del = INPUT FRAME fFaixaDel fivolfimdel.

        RUN piGeraFaixaDel IN THIS-PROCEDURE.
        APPLY "GO":U TO FRAME fFaixaDel.
    END.
    ON  "CHOOSE":U OF btGoToCancel IN FRAME fFaixaDel DO:
        APPLY "GO":U TO FRAME fFaixaDel.
        ASSIGN i-nr-nota-fis = "".
    END.

    DISP 
        fiCodEstabDel
        fiNrNotaFisDel
        FiSerieDel
        fiItCodigoDelIni
        fiItCodigoDelFim
        fivolIniDel 
        fivolFimDel 
       WITH FRAME fFaixaDel.

    ENABLE fiNrNotaFisDel
           FiSerieDel
           fiCodEstabDel
           fiItCodigoDelIni
           fiItCodigoDelFim
           fivolIniDel 
           fivolFimDel 
           btGoToOK 
           btGoToCancel
           WITH FRAME fFaixaDel.
    
    WAIT-FOR "GO":U OF FRAME fFaixaDel.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

