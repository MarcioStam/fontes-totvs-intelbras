&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenance


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttcota-representante NO-UNDO LIKE cota-representante
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMaintenance 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESACP001 2.04.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        esacp001
&GLOBAL-DEFINE Version        2.04.00.000

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1

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

&GLOBAL-DEFINE ttTable        ttcota-representante
&GLOBAL-DEFINE hDBOTable      hbocota-representante
&GLOBAL-DEFINE DBOTable       cota-representante

&GLOBAL-DEFINE page0KeyFields ttcota-representante.cod-estabel ttcota-representante.cod-rep ttcota-representante.fm-cod-com ttcota-representante.it-codigo ttcota-representante.periodo ttcota-representante.cd-uf

&GLOBAL-DEFINE page0Fields    ttcota-representante.qt-orcamento ttcota-representante.qt-representante ttcota-representante.valor
 

/* Global Variable Definitions ---                                     */
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.


/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE wh-pesquisa AS HANDLE NO-UNDO.
DEF VAR op AS INTEGER.

DEFINE STREAM s-erro.

define temp-table tt-erro no-undo
   field descricao as character format 'x(40)'.

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable} AS HANDLE NO-UNDO.


/*
DEF TEMP-TABLE ttcota-representante
    FIELD cod-estabel   LIKE ttcota-representante.cod-estabel
    FIELD cod-rep        LIKE ttcota-representante.cod-rep
    FIELD fm-cod-com     LIKE ttcota-representante.fm-cod-com
    FIELD it-codigo      LIKE ttcota-representante.it-codigo
    FIELD periodo      LIKE ttcota-representante.periodo
    FIELD qt-orcamento      LIKE ttcota-representante.qt-orcamento.
*/


    DEF VAR c-cod-estabel       LIKE ttcota-representante.cod-estabel.
    DEF VAR i-cod-rep           LIKE ttcota-representante.cod-Rep. 
    DEF VAR c-fm-cod-com        LIKE ttcota-representante.fm-cod-com. 
    DEF VAR c-cd-uf             LIKE ttcota-representante.cd-uf.
    DEF VAR c-it-codigo         LIKE ttcota-representante.it-codigo.
    DEF VAR c-periodo           LIKE ttcota-representante.periodo.
    DEF VAR de-qt-orcamento     LIKE ttcota-representante.qt-orcamento.
    DEF VAR de-qt-representante LIKE ttcota-representante.qt-representante.
    DEF VAR de-vlr-unit         LIKE ttcota-representante.valor.

    DEF VAR confirma AS LOGICAL INITIAL NO NO-UNDO.
    
    DEF VAR c-arq-imp AS CHAR FORMAT "x(30)".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Maintenance
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ttcota-representante.cod-estabel ~
ttcota-representante.cod-rep ttcota-representante.fm-cod-com ~
ttcota-representante.cd-uf ttcota-representante.it-codigo ~
ttcota-representante.periodo ttcota-representante.qt-orcamento ~
ttcota-representante.qt-representante ttcota-representante.valor 
&Scoped-define ENABLED-TABLES ttcota-representante
&Scoped-define FIRST-ENABLED-TABLE ttcota-representante
&Scoped-Define ENABLED-OBJECTS rtToolBar rtKeys RECT-14 btFirst btPrev ~
btNext btLast btGoTo btSearch btAdd btCopy btUpdate btDelete btUndo ~
btCancel btSave btQueryJoins btReportsJoins btExit btHelp bt-importar ~
c-desc-estabel c-desc-representante c-desc-familia c-desc-item 
&Scoped-Define DISPLAYED-FIELDS ttcota-representante.cod-estabel ~
ttcota-representante.cod-rep ttcota-representante.fm-cod-com ~
ttcota-representante.cd-uf ttcota-representante.it-codigo ~
ttcota-representante.periodo ttcota-representante.qt-orcamento ~
ttcota-representante.qt-representante ttcota-representante.valor 
&Scoped-define DISPLAYED-TABLES ttcota-representante
&Scoped-define FIRST-DISPLAYED-TABLE ttcota-representante
&Scoped-Define DISPLAYED-OBJECTS c-desc-estabel c-desc-representante ~
c-desc-familia c-desc-item 

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
       MENU-ITEM miLast         LABEL "&éltimo"        ACCELERATOR "CTRL-END"
       RULE
       MENU-ITEM miGoTo         LABEL "&V  Para"       ACCELERATOR "CTRL-T"
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


/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-importar 
     LABEL "Importar" 
     SIZE 8 BY 1.13.

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

DEFINE VARIABLE c-desc-estabel AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 62.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-familia AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 56.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-item AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 49.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-representante AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 60.57 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-14
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 3.04.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 6.58.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE BUTTON bt-arquivo-imp 
     IMAGE-UP FILE "adeicon/open.bmp":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON bt-cancelar 
     LABEL "Cancelar" 
     SIZE 11 BY 1.13.

DEFINE BUTTON bt-confirmar 
     LABEL "Confirmar" 
     SIZE 12 BY 1.13.

DEFINE VARIABLE fi-c-arquivo AS CHARACTER FORMAT "X(256)":U 
     LABEL "Arquivo Importa‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 67 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-15
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88 BY 3.5.

DEFINE RECTANGLE RECT-17
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88 BY 5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btFirst AT ROW 1.13 COL 1.57 HELP
          "Primeira ocorrˆncia"
     btPrev AT ROW 1.13 COL 5.57 HELP
          "Ocorrˆncia anterior"
     btNext AT ROW 1.13 COL 9.57 HELP
          "Pr¢xima ocorrˆncia"
     btLast AT ROW 1.13 COL 13.57 HELP
          "éltima ocorrˆncia"
     btGoTo AT ROW 1.13 COL 17.57 HELP
          "V  Para"
     btSearch AT ROW 1.13 COL 21.57 HELP
          "Pesquisa"
     btAdd AT ROW 1.13 COL 31 HELP
          "Inclui nova ocorrˆncia"
     btCopy AT ROW 1.13 COL 35 HELP
          "Cria uma c¢pia da ocorrˆncia corrente"
     btUpdate AT ROW 1.13 COL 39 HELP
          "Altera ocorrˆncia corrente"
     btDelete AT ROW 1.13 COL 43 HELP
          "Elimina ocorrˆncia corrente"
     btUndo AT ROW 1.13 COL 47 HELP
          "Desfaz altera‡äes"
     btCancel AT ROW 1.13 COL 51 HELP
          "Cancela altera‡äes"
     btSave AT ROW 1.13 COL 55 HELP
          "Confirma altera‡äes"
     btQueryJoins AT ROW 1.13 COL 74.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda"
     bt-importar AT ROW 1.25 COL 62
     ttcota-representante.cod-estabel AT ROW 3 COL 14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     c-desc-estabel AT ROW 3 COL 19.43 COLON-ALIGNED NO-LABEL
     ttcota-representante.cod-rep AT ROW 4 COL 14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     c-desc-representante AT ROW 4 COL 21.43 COLON-ALIGNED NO-LABEL
     ttcota-representante.fm-cod-com AT ROW 5 COL 14 COLON-ALIGNED
          LABEL "Familia"
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     c-desc-familia AT ROW 5 COL 25.43 COLON-ALIGNED NO-LABEL
     ttcota-representante.cd-uf AT ROW 6 COL 14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     ttcota-representante.it-codigo AT ROW 7 COL 14 COLON-ALIGNED
          LABEL "Item"
          VIEW-AS FILL-IN 
          SIZE 17.86 BY .88
     c-desc-item AT ROW 7 COL 32.29 COLON-ALIGNED NO-LABEL
     ttcota-representante.periodo AT ROW 8 COL 14 COLON-ALIGNED
          LABEL "Per¡odo"
          VIEW-AS FILL-IN 
          SIZE 10.86 BY .88
     ttcota-representante.qt-orcamento AT ROW 10 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11.86 BY .88
     ttcota-representante.qt-representante AT ROW 10 COL 59 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11.86 BY .88
     ttcota-representante.valor AT ROW 11 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11.86 BY .88
     rtToolBar AT ROW 1 COL 1
     rtKeys AT ROW 2.67 COL 1
     RECT-14 AT ROW 9.67 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 180.72 BY 11.96
         FONT 1.

DEFINE FRAME fPage1
     bt-arquivo-imp AT ROW 7.58 COL 84.57
     fi-c-arquivo AT ROW 7.63 COL 15.29 COLON-ALIGNED
     bt-confirmar AT ROW 8.83 COL 33.57
     bt-cancelar AT ROW 8.83 COL 46.57
     "EX: 101~; 1111~; 050101~; SC ~; 1010131~; 200908~; 150~; 190 ~; 1" VIEW-AS TEXT
          SIZE 79 BY .54 AT ROW 4.71 COL 3
          FGCOLOR 2 
     "Obs: Todos os valores devem vir separados por ~;. O item pode ser opcional, ident" VIEW-AS TEXT
          SIZE 78.14 BY .54 AT ROW 3.46 COL 2.86
          FGCOLOR 12 
     "Importar sempre utilizando esse layout:" VIEW-AS TEXT
          SIZE 31 BY .54 AT ROW 1.63 COL 2.72
          FGCOLOR 9 
     "Estabelec~;Representante~;Familia Cml~;UF~;Item~;Periodo~;Qtd Or‡amento~;Qtd Rep~;Vl Uni" VIEW-AS TEXT
          SIZE 86.43 BY 1.08 AT ROW 2.33 COL 2.72
     RECT-15 AT ROW 7 COL 2
     RECT-17 AT ROW 1.25 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1.14 ROW 2.67
         SIZE 90 BY 10.04
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Maintenance
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: ttcota-representante T "?" NO-UNDO mgesp cota-representante
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
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
         HEIGHT             = 11.96
         WIDTH              = 90.43
         MAX-HEIGHT         = 38.88
         MAX-WIDTH          = 182.86
         VIRTUAL-HEIGHT     = 38.88
         VIRTUAL-WIDTH      = 182.86
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
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN ttcota-representante.fm-cod-com IN FRAME fpage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ttcota-representante.it-codigo IN FRAME fpage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ttcota-representante.periodo IN FRAME fpage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FRAME fPage1
   NOT-VISIBLE                                                          */
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

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage1
/* Query rebuild information for FRAME fPage1
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage1 */
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


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME bt-arquivo-imp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-arquivo-imp wMaintenance
ON CHOOSE OF bt-arquivo-imp IN FRAME fPage1
DO:
  
    DEF VAR c-arq-imp   AS CHAR no-undo.
    DEF VAR l-ok-imp    AS LOGICAL init no.

    ASSIGN c-arq-imp = REPLACE(INPUT FRAME fpage1 fi-c-arquivo, "/", "\").

    SYSTEM-DIALOG GET-FILE c-arq-imp
       FILTERS "*.lst" "*.lst",
               "*.csv" "*.csv",
               "*.txt" "*.txt", 
               "*.*" "*.*"
       DEFAULT-EXTENSION "csv"
       INITIAL-DIR "spool" 
       MUST-EXIST
       USE-FILENAME
       UPDATE l-ok-imp.

                                                
    IF l-ok-imp = YES THEN DO:
        /* assign c-arq-imp = replace(c-arq-imp, "\", "/"). */
       DISPLAY c-arq-imp @ fi-c-arquivo with frame fpage1.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-cancelar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cancelar wMaintenance
ON CHOOSE OF bt-cancelar IN FRAME fPage1 /* Cancelar */
DO:
    
    HIDE FRAME fpage1.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-confirmar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-confirmar wMaintenance
ON CHOOSE OF bt-confirmar IN FRAME fPage1 /* Confirmar */
DO:
    DEFINE VARIABLE l-inclui   AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE i-linha    AS INTEGER     NO-UNDO.
    DEFINE VARIABLE l-primeiro AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE c-arq-erro AS CHARACTER   NO-UNDO.

    DEF var h-acomp      as handle no-undo.

    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

    RUN pi-inicializar in h-acomp (input "Lendo Arquivo Importa‡Æo...").

    ASSIGN c-arq-erro = SESSION:TEMP-DIRECTORY + "erroImportacao.txt".

    IF fi-c-arquivo:SCREEN-VALUE = "" THEN DO:
       MESSAGE "Selecione o arquivo para importar"
           VIEW-AS ALERT-BOX INFO BUTTONS OK.
       LEAVE.
    END.

    ASSIGN i-linha    = 0
           l-primeiro = YES.

    INPUT FROM VALUE(fi-c-arquivo:SCREEN-VALUE IN FRAME {&FRAME-NAME}).                


    REPEAT: 
        ASSIGN i-linha             = i-linha + 1
               c-cod-estabel       =  ""
               i-cod-rep           = 0 
               c-fm-cod-com        = ""
               c-cd-uf             = ""
               c-it-codigo         = ""
               c-periodo           = ""
               de-qt-orcamento     = 0
               de-qt-representante = 0
               de-vlr-unit         = 0.

        RUN pi-acompanhar IN h-acomp (INPUT "Linha: " + STRING(i-linha)).

        IMPORT DELIMITER ";" c-cod-estabel i-cod-rep c-fm-cod-com c-cd-uf c-it-codigo c-periodo de-qt-orcamento de-qt-representante de-vlr-unit NO-ERROR.

        empty temp-table tt-erro.

        if not can-find (first estabelec
                         where estabelec.cod-estabel = c-cod-estabel) then do:
           create tt-erro.
           assign tt-erro.descricao = 'Estabelecimento ' + c-cod-estabel + ' inexistente'.
        end.

        if (i-cod-rep <> ?) and not can-find (first repres
                         where repres.cod-rep = i-cod-rep) then do:
           create tt-erro.
           assign tt-erro.descricao = 'Representante ' + string(i-cod-rep) + ' inexistente'.
        end.
        
        if not can-find (first fam-comerc
                         where fam-comerc.fm-cod-com = c-fm-cod-com) then do:
           create tt-erro.
           assign tt-erro.descricao = 'Fam¡lia comercial ' + c-fm-cod-com + ' inexistente'.
        end.

        if (c-it-codigo <> ?) and not can-find (first item
                                                where item.it-codigo = c-it-codigo) then do:
           create tt-erro.
           assign tt-erro.descricao = 'Item ' + c-it-codigo + ' inexistente'.
        end.

        if (c-it-codigo <> ? ) and not can-find (first item
                                                 where item.it-codigo = c-it-codigo
                                                   and item.fm-cod-com = c-fm-cod-com) then do:
           create tt-erro.
           assign tt-erro.descricao = 'Item ' + c-it-codigo + ' nÆo pertence … fam¡lia comercial ' + c-fm-cod-com.
        end.

        if not can-find (first tt-erro) then do:
           find first cota-representante exclusive-lock
              where cota-representante.cod-estabel = c-cod-estabel
                and cota-representante.cod-rep     = i-cod-rep
                and cota-representante.fm-cod-com  = c-fm-cod-com
                and cota-representante.it-codigo   = c-it-codigo
                and cota-representante.periodo     = c-periodo 
                AND cota-representante.cd-uf       = c-cd-uf no-error.
   
           if NOT available cota-representante THEN  DO:
               CREATE cota-representante.
               assign cota-representante.cod-estabel      = c-cod-estabel
                     cota-representante.cod-rep          = i-cod-rep
                     cota-representante.fm-cod-com       = c-fm-cod-com
                     cota-representante.it-codigo        = c-it-codigo
                     cota-representante.periodo          = c-periodo
                     cota-representante.cd-uf            = c-cd-uf.
           END.

               ASSIGN cota-representante.qt-orcamento     = de-qt-orcamento    
                      cota-representante.qt-representante = de-qt-representante
                      cota-representante.valor            = de-vlr-unit. 
        END.
        
        else do:
        
           IF l-primeiro THEN DO:
               OUTPUT STREAM s-erro TO VALUE(c-arq-erro) NO-CONVERT.
               PUT STREAM s-erro UNFORMATTED 
                   "Erros encontrados na importacao, essas informacoes abaixo nao foram importadas!" AT 01 SKIP(1)
                   "Linha   Descricao                                                   " AT 01
                   "------- ------------------------------------------------------------" AT 01 SKIP.
   
               ASSIGN l-primeiro = NO.
           END.
           ELSE
              OUTPUT STREAM s-erro TO VALUE(c-arq-erro) NO-CONVERT APPEND.

           FOR EACH tt-erro:
               PUT STREAM s-erro UNFORMATTED 
                   i-linha           FORMAT ">>>>>>9" AT 01
                   tt-erro.descricao FORMAT "x(60)"   AT 09 SKIP.
           END.
           OUTPUT STREAM s-erro CLOSE.
        end.
    END.

    INPUT CLOSE.

    RUN pi-finalizar in h-acomp.

    IF NOT l-primeiro THEN DO:
        MESSAGE "Ocorreu erro durante a importa‡Æo!"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
        OS-COMMAND NO-WAIT notepad VALUE(c-arq-erro).
    END.
    ELSE 
        MESSAGE "Importa‡Æo conclu¡da com sucesso"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    
    RUN setConstraintmain IN {&hDBOTable} NO-ERROR.
    RUN openQueryStatic IN {&hDBOTable} (INPUT "main":U) NO-ERROR.
    
    RUN getFirst IN THIS-PROCEDURE.
        
    ASSIGN btfirst:SENSITIVE IN FRAME fpage0 = YES.
    APPLY "choose" TO btfirst IN FRAME fpage0.

    HIDE FRAME fpage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME bt-importar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-importar wMaintenance
ON CHOOSE OF bt-importar IN FRAME fpage0 /* Importar */
DO:
  
    VIEW FRAME fpage1.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btAdd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAdd wMaintenance
ON CHOOSE OF btAdd IN FRAME fpage0 /* Add */
OR CHOOSE OF MENU-ITEM miAdd in MENU mbMain DO:
    RUN addRecord IN THIS-PROCEDURE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wMaintenance
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancel */
OR CHOOSE OF MENU-ITEM miCancel IN MENU mbMain DO:
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
    {method/ZoomReposition.i &ProgramZoom="eszoom\z01es432.w"}
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


&Scoped-define SELF-NAME ttcota-representante.cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttcota-representante.cod-estabel wMaintenance
ON LEAVE OF ttcota-representante.cod-estabel IN FRAME fpage0 /* Estabelecimento */
DO:
    
    FIND FIRST estabelec NO-LOCK WHERE 
         estabelec.cod-estabel = INPUT FRAME {&FRAME-NAME} {&SELF-NAME} NO-ERROR.
    ASSIGN c-desc-estabel = IF AVAILABLE estabelec THEN estabelec.nome ELSE ''.
    DISPLAY c-desc-estabel WITH FRAME {&FRAME-NAME}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttcota-representante.cod-rep
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttcota-representante.cod-rep wMaintenance
ON LEAVE OF ttcota-representante.cod-rep IN FRAME fpage0 /* Representante */
DO:
  
    FIND FIRST repres NO-LOCK 
         WHERE repres.cod-rep = INPUT FRAME {&FRAME-NAME} {&SELF-NAME} NO-ERROR.
    ASSIGN c-desc-representante = IF AVAILABLE repres THEN repres.nome ELSE ''.
    DISPLAY c-desc-representante WITH FRAME {&FRAME-NAME}.

    /*
    ASSIGN ttcota-representante.no-ab-reppri = IF AVAIL repres then repres.nome-abrev ELSE ''.
    /* DISPLAY ttcota-representante.no-ab-reppri WITH FRAME {&FRAME-NAME}. */*/

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttcota-representante.fm-cod-com
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttcota-representante.fm-cod-com wMaintenance
ON LEAVE OF ttcota-representante.fm-cod-com IN FRAME fpage0 /* Familia */
DO:
    FIND FIRST fam-comerc NO-LOCK 
         WHERE fam-comerc.fm-cod-com = INPUT FRAME {&FRAME-NAME} {&SELF-NAME} NO-ERROR.
    ASSIGN c-desc-familia = IF AVAILABLE fam-comerc THEN fam-comerc.descricao ELSE ''.
    DISPLAY c-desc-familia WITH FRAME {&FRAME-NAME}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttcota-representante.it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttcota-representante.it-codigo wMaintenance
ON LEAVE OF ttcota-representante.it-codigo IN FRAME fpage0 /* Item */
DO:
    FIND FIRST ITEM NO-LOCK 
         WHERE ITEM.it-codigo = INPUT FRAME {&FRAME-NAME} {&SELF-NAME} NO-ERROR.
    ASSIGN c-desc-item = IF AVAILABLE ITEM THEN ITEM.desc-item ELSE ''.
    DISPLAY c-desc-item WITH FRAME {&FRAME-NAME}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenance 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{maintenance/MainBlock.i}

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
     APPLY 'leave':U TO {&ttTable}.cod-estabel   IN FRAME fPage0.
     APPLY 'leave':U TO {&ttTable}.cod-rep         IN FRAME fPage0.
     APPLY 'leave':U TO {&ttTable}.fm-cod-com     IN FRAME fpage0.
     APPLY 'leave':U TO {&ttTable}.it-codigo IN FRAME fpage0.
 
     ENABLE bt-importar WITH FRAME fpage0. 

     bt-importar:SENSITIVE IN FRAME fpage0 = TRUE.
     bt-confirmar:SENSITIVE IN FRAME fpage1 = TRUE.
     bt-cancelar:SENSITIVE IN FRAME fpage1 = TRUE.
     bt-arquivo-imp:SENSITIVE IN FRAME fpage1 = TRUE.

     fi-c-arquivo:SENSITIVE IN FRAME fpage1 = TRUE.

     HIDE FRAME fpage1.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToRecord wMaintenance 
PROCEDURE goToRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Exibe dialog de V  Para
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
    
    DEFINE VARIABLE pcod-estabel  LIKE {&ttTable}.cod-estabel  NO-UNDO.
    DEFINE VARIABLE pcod-rep      LIKE {&ttTable}.cod-rep      NO-UNDO.
    DEFINE VARIABLE pfm-cod-com   LIKE {&ttTable}.fm-cod-com   NO-UNDO.
    DEFINE VARIABLE pit-codigo    LIKE {&ttTable}.it-codigo    NO-UNDO.
    DEFINE VARIABLE pperiodo      LIKE {&ttTable}.periodo    NO-UNDO.

    
    DEFINE FRAME fGoToRecord
        pcod-estabel AT ROW 1.21 COL 17.72 COLON-ALIGNED VIEW-AS FILL-IN SIZE 5  BY .88
        pcod-rep     AT ROW 2.21 COL 17.72 COLON-ALIGNED VIEW-AS FILL-IN SIZE 9  BY .88
        pfm-cod-com  AT ROW 3.21 COL 17.72 COLON-ALIGNED VIEW-AS FILL-IN SIZE 12  BY .88
        pit-codigo   AT ROW 4.21 COL 17.72 COLON-ALIGNED VIEW-AS FILL-IN SIZE 14  BY .88
        pperiodo     AT ROW 5.21 COL 17.72 COLON-ALIGNED VIEW-AS FILL-IN SIZE 10  BY .88

        btGoToOK          AT ROW 6.63 COL 2.14
        btGoToCancel      AT ROW 6.63 COL 13
        rtGoToButton      AT ROW 6.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V  Para cota" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.
    
    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN pcod-estabel
               pcod-rep
               pfm-cod-com
               pit-codigo
               pperiodo.
        
        RUN goToKey IN {&hDBOTable} (INPUT pcod-estabel, INPUT pcod-rep, INPUT pfm-cod-com, INPUT pit-codigo, INPUT pperiodo).
        IF RETURN-VALUE = "NOK":U THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT "cota-representante":U).
            
            RETURN NO-APPLY.
        END.
        
        /*:T Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOTable} (OUTPUT rGoTo).
        
        /*:T Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).

        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    ENABLE pcod-estabel 
           pcod-rep 
           pfm-cod-com
           pit-codigo
           pperiodo
           btGoToOK btGoToCancel 
           WITH FRAME fGoToRecord. 
    
    WAIT-FOR "GO":U OF FRAME fGoToRecord.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wMaintenance 
PROCEDURE initializeDBOs :
/*:T------------------------------------------------------------------------------
  Purpose:     Inicializa DBOs
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    
    /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOTable}) OR
       {&hDBOTable}:TYPE <> "PROCEDURE":U OR
       {&hDBOTable}:FILE-NAME <> "boes432.p":U THEN DO:
        {btb/btb008za.i1 esbo\boes432.p YES}
        {btb/btb008za.i2 esbo\boes432.p '' {&hDBOTable}}
    END.
    
    RUN setConstraintmain IN {&hDBOTable} NO-ERROR.
    RUN openQueryStatic IN {&hDBOTable} (INPUT "main":U) NO-ERROR.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

