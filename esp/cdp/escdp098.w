&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp            PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenance


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-int-logistica-ecommerce NO-UNDO LIKE int-logistica-ecommerce
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
{include/i-prgvrs.i ESCDP098 2.00.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESCDP098
&GLOBAL-DEFINE Version        2.00.00.000

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1

&GLOBAL-DEFINE FolderLabels   

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

&GLOBAL-DEFINE ttTable        tt-int-logistica-ecommerce    
&GLOBAL-DEFINE hDBOTable      hDBODefSigla
&GLOBAL-DEFINE DBOTable       int-logistica-ecommerce

&GLOBAL-DEFINE page0KeyFields tt-int-logistica-ecommerce.cod-estabel tt-int-logistica-ecommerce.estado tt-int-logistica-ecommerce.cep-inicial tt-int-logistica-ecommerce.cep-final tt-int-logistica-ecommerce.cidade tt-int-logistica-ecommerce.cod-transp tt-int-logistica-ecommerce.sigla-transp tt-int-logistica-ecommerce.cod-emitente
&GLOBAL-DEFINE page0Fields  tt-int-logistica-ecommerce.sigla-transp  
&GLOBAL-DEFINE page1Fields    
&GLOBAL-DEFINE page2Fields    

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable} AS HANDLE NO-UNDO.
DEFINE VARIABLE wh-pesquisa AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
DEFINE BUFFER bf-emitente FOR emitente.



DEFINE TEMP-TABLE tt-int-logistica-ecommerce-imp NO-UNDO
       field cod-transp    like int-logistica-ecommerce.cod-transp  
       field cod-estabel   like int-logistica-ecommerce.cod-estab   
       field cep-inicial   like int-logistica-ecommerce.cep-inicial 
       field cep-final     like int-logistica-ecommerce.cep-final   
       field cidade        like int-logistica-ecommerce.cidade      
       field estado        like int-logistica-ecommerce.estado      
       FIELD sigla-transp  LIKE int-logistica-ecommerce.sigla-transp
       field cod-emitente  like int-logistica-ecommerce.cod-emitente
       FIELD linha           AS INTEGER
       INDEX idx-primary linha.

{include/i-freeac.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Maintenance
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-int-logistica-ecommerce.cod-transp ~
tt-int-logistica-ecommerce.cod-estabel tt-int-logistica-ecommerce.cep-inicial ~
tt-int-logistica-ecommerce.cep-final tt-int-logistica-ecommerce.Estado ~
tt-int-logistica-ecommerce.cidade tt-int-logistica-ecommerce.cod-emitente ~
tt-int-logistica-ecommerce.sigla-transp 
&Scoped-define ENABLED-TABLES tt-int-logistica-ecommerce
&Scoped-define FIRST-ENABLED-TABLE tt-int-logistica-ecommerce
&Scoped-Define ENABLED-OBJECTS rtToolBar IMAGE-1 IMAGE-2 RECT-138 btFirst ~
btPrev btNext btLast btGoTo btSearch btAdd btCopy btUpdate btDelete btUndo ~
btCancel btSave btElimina btQueryJoins btReportsJoins btExit btHelp ~
btImportar btLayout c-desc-transp c-desc-estabel c-desc-uf c-nome-abrev 
&Scoped-Define DISPLAYED-FIELDS tt-int-logistica-ecommerce.cod-transp ~
tt-int-logistica-ecommerce.cod-estabel tt-int-logistica-ecommerce.cep-inicial ~
tt-int-logistica-ecommerce.cep-final tt-int-logistica-ecommerce.Estado ~
tt-int-logistica-ecommerce.cidade tt-int-logistica-ecommerce.cod-emitente ~
tt-int-logistica-ecommerce.sigla-transp 
&Scoped-define DISPLAYED-TABLES tt-int-logistica-ecommerce
&Scoped-define FIRST-DISPLAYED-TABLE tt-int-logistica-ecommerce
&Scoped-Define DISPLAYED-OBJECTS c-desc-transp c-desc-estabel c-desc-uf ~
c-nome-abrev 

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

DEFINE BUTTON btElimina 
     IMAGE-UP FILE "adeicon/remote-u.bmp":U
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "Elimina Faixa".

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

DEFINE BUTTON btImportar 
     LABEL "Importar" 
     SIZE 8 BY 1.

DEFINE BUTTON btLast 
     IMAGE-UP FILE "image\im-las":U
     IMAGE-INSENSITIVE FILE "image\ii-las":U
     LABEL "Last":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btLayout 
     LABEL "Layout" 
     SIZE 8 BY 1.

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

DEFINE VARIABLE c-desc-estabel AS CHARACTER FORMAT "X(35)":U 
     VIEW-AS FILL-IN 
     SIZE 45.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-transp AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 46 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-uf AS CHARACTER FORMAT "X(35)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-abrev AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 47.57 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-2
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE RECTANGLE RECT-138
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88 BY 1.5.

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
     btAdd AT ROW 1.13 COL 31 HELP
          "Inclui nova ocorrància"
     btCopy AT ROW 1.13 COL 35 HELP
          "Cria uma c¢pia da ocorrància corrente"
     btUpdate AT ROW 1.13 COL 39 HELP
          "Altera ocorrància corrente"
     btDelete AT ROW 1.13 COL 43 HELP
          "Elimina ocorrància corrente"
     btUndo AT ROW 1.13 COL 47 HELP
          "Desfaz alteraá‰es"
     btCancel AT ROW 1.13 COL 51 HELP
          "Cancela alteraá‰es"
     btSave AT ROW 1.13 COL 55 HELP
          "Confirma alteraá‰es"
     btElimina AT ROW 1.13 COL 61.14
     btQueryJoins AT ROW 1.13 COL 74.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda"
     btImportar AT ROW 1.25 COL 67.43 WIDGET-ID 10
     btLayout AT ROW 1.25 COL 75.43 WIDGET-ID 12
     tt-int-logistica-ecommerce.cod-transp AT ROW 3.5 COL 23 COLON-ALIGNED WIDGET-ID 28
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     c-desc-transp AT ROW 3.5 COL 33.43 COLON-ALIGNED NO-LABEL WIDGET-ID 56
     tt-int-logistica-ecommerce.cod-estabel AT ROW 4.5 COL 23 COLON-ALIGNED WIDGET-ID 26
          LABEL "Estab Origem"
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     c-desc-estabel AT ROW 4.5 COL 33.43 COLON-ALIGNED NO-LABEL
     tt-int-logistica-ecommerce.cep-inicial AT ROW 5.5 COL 23 COLON-ALIGNED WIDGET-ID 22
          VIEW-AS FILL-IN 
          SIZE 10.72 BY .88
     tt-int-logistica-ecommerce.cep-final AT ROW 5.5 COL 41.57 COLON-ALIGNED NO-LABEL WIDGET-ID 20
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     tt-int-logistica-ecommerce.Estado AT ROW 6.5 COL 23 COLON-ALIGNED WIDGET-ID 30
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     c-desc-uf AT ROW 6.5 COL 29.43 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     tt-int-logistica-ecommerce.cidade AT ROW 7.5 COL 23 COLON-ALIGNED WIDGET-ID 24
          LABEL "Cidade Destino"
          VIEW-AS FILL-IN 
          SIZE 29 BY .88
     tt-int-logistica-ecommerce.cod-emitente AT ROW 8.5 COL 23 COLON-ALIGNED WIDGET-ID 58
          VIEW-AS FILL-IN 
          SIZE 8.86 BY .88
     c-nome-abrev AT ROW 8.5 COL 32.29 COLON-ALIGNED NO-LABEL WIDGET-ID 60
     tt-int-logistica-ecommerce.sigla-transp AT ROW 10.25 COL 23 COLON-ALIGNED WIDGET-ID 32 FORMAT "X(7)"
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     rtToolBar AT ROW 1 COL 1
     IMAGE-1 AT ROW 5.54 COL 36.14 WIDGET-ID 36
     IMAGE-2 AT ROW 5.54 COL 40.29 WIDGET-ID 38
     RECT-138 AT ROW 10 COL 2 WIDGET-ID 54
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 10.75
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Maintenance
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: tt-int-logistica-ecommerce T "?" NO-UNDO mgesp int-logistica-ecommerce
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
         HEIGHT             = 10.92
         WIDTH              = 90
         MAX-HEIGHT         = 27.21
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 27.21
         VIRTUAL-WIDTH      = 146.29
         MAX-BUTTON         = no
         RESIZE             = no
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
ASSIGN 
       c-desc-transp:READ-ONLY IN FRAME fpage0        = TRUE.

/* SETTINGS FOR FILL-IN tt-int-logistica-ecommerce.cep-final IN FRAME fpage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-int-logistica-ecommerce.cidade IN FRAME fpage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-int-logistica-ecommerce.cod-estabel IN FRAME fpage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-int-logistica-ecommerce.sigla-transp IN FRAME fpage0
   EXP-FORMAT                                                           */
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


&Scoped-define SELF-NAME btElimina
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btElimina wMaintenance
ON CHOOSE OF btElimina IN FRAME fpage0
DO:
    ASSIGN CURRENT-WINDOW:SENSITIVE = NO.

    RUN esp/cdp/escdp098a.w.

    RUN displayFields.

    ASSIGN CURRENT-WINDOW:SENSITIVE = YES.
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


&Scoped-define SELF-NAME btImportar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btImportar wMaintenance
ON CHOOSE OF btImportar IN FRAME fpage0 /* Importar */
DO:
    
    DEFINE VARIABLE h-acomp     AS HANDLE      NO-UNDO.
    DEFINE VARIABLE c-arquivo   AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE l-ok        AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE i-cont      AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-sequencia AS INTEGER     NO-UNDO.

    EMPTY TEMP-TABLE tt-int-logistica-ecommerce-imp.
    EMPTY TEMP-TABLE rowErrors.
    ASSIGN i-cont = 0.


    /* Solicita arquivo que ser† importado */
    SYSTEM-DIALOG GET-FILE c-arquivo
            TITLE      "Importar Dados"
            FILTERS    "Arquivos de texto (*.csv)" "*.csv"
            INITIAL-DIR SESSION:TEMP-DIRECTORY
            MUST-EXIST
            USE-FILENAME
            UPDATE l-ok.

    IF  NOT l-ok THEN RETURN "NOK":U.

    IF  NOT VALID-HANDLE(h-acomp) THEN
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

    RUN pi-inicializar IN h-acomp (INPUT "Importando Dados").

    /* Importa as Notas de um arquivo */
    INPUT FROM VALUE(c-arquivo) NO-ECHO.
    REPEAT:
        ASSIGN i-cont = i-cont + 1.

        RUN pi-acompanhar IN h-acomp (INPUT "Importando linha " + STRING(i-cont)).

        CREATE tt-int-logistica-ecommerce-imp.
        ASSIGN tt-int-logistica-ecommerce-imp.linha = i-cont.
        IMPORT DELIMITER ";" tt-int-logistica-ecommerce-imp.

    END.
    INPUT CLOSE.

    RUN pi-atualiza-cep.
    
    RUN pi-inicializar IN h-acomp (INPUT "Efetivando Dados").

    /* N∆o busca o £ltimo registro criado, com as informaá‰es em branco! */
    FOR EACH  tt-int-logistica-ecommerce-imp
        WHERE tt-int-logistica-ecommerce-imp.linha        < i-cont
         AND  tt-int-logistica-ecommerce-imp.cod-estabel <> "":

        RUN pi-acompanhar IN h-acomp (INPUT "Transportadora: " + STRING(tt-int-logistica-ecommerce-imp.cod-transp)).

        RUN pi-validar-imp IN THIS-PROCEDURE.
        IF  RETURN-VALUE = "NOK":U THEN
            NEXT.

        FIND FIRST int-logistica-ecommerce EXCLUSIVE-LOCK
             WHERE int-logistica-ecommerce.cod-transp   = tt-int-logistica-ecommerce-imp.cod-transp
               AND int-logistica-ecommerce.cod-estab    = tt-int-logistica-ecommerce-imp.cod-estab
               AND int-logistica-ecommerce.cep-inicial  = tt-int-logistica-ecommerce-imp.cep-inicial
               AND int-logistica-ecommerce.cep-final    = tt-int-logistica-ecommerce-imp.cep-final
               AND int-logistica-ecommerce.cidade       = tt-int-logistica-ecommerce-imp.cidade 
               AND int-logistica-ecommerce.estado       = tt-int-logistica-ecommerce-imp.estado
               AND int-logistica-ecommerce.cod-emitente = tt-int-logistica-ecommerce-imp.cod-emitente NO-ERROR.
        IF  NOT AVAIL int-logistica-ecommerce THEN DO:
            CREATE int-logistica-ecommerce.
            BUFFER-COPY tt-int-logistica-ecommerce-imp TO int-logistica-ecommerce.
        END.
        ELSE 
            ASSIGN int-logistica-ecommerce.sigla-transp = tt-int-logistica-ecommerce-imp.sigla-transp.
    END.

    IF  VALID-HANDLE(h-acomp) THEN
        RUN pi-finalizar IN h-acomp.

    IF  CAN-FIND(FIRST rowErrors) THEN DO:
        {method/showmessage.i1}
        {method/showmessage.i2 &Modal="YES"}
        {method/showmessage.i3}
    END.
    ELSE DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 15825,
                           INPUT "Importaá∆o conclu°da!":U).
        
    END.

    RUN openQueryStatic IN {&hDBOTable} (INPUT "Main":U) NO-ERROR.

    FIND FIRST int-logistica-ecommerce NO-LOCK.
    IF  AVAIL int-logistica-ecommerce THEN
        RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(int-logistica-ecommerce)).
    RETURN "OK":U.
   
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


&Scoped-define SELF-NAME btLayout
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btLayout wMaintenance
ON CHOOSE OF btLayout IN FRAME fpage0 /* Layout */
DO:
  
  DEFINE BUTTON btLayoutFechar AUTO-END-KEY 
         LABEL "&Fechar" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE RECTANGLE rtGoToButton
         EDGE-PIXELS 2 GRAPHIC-EDGE  
         SIZE 58 BY 1.42
         BGCOLOR 7.
    
    DEFINE VARIABLE c-editor AS CHARACTER   NO-UNDO.

    ASSIGN c-editor = FILL("-",124)                         + CHR(13) +
                      FILL(" ",46) + "Layout de Importaá∆o" + CHR(13) +
                      FILL("-",124)                         + CHR(13) + CHR(13) +
                      "O arquivo com os dados da Transportadora deve seguir o padr∆o abaixo:" + CHR(13) +
                      "Transp Origem;Estabelec Origem;CEP Inicial;CEP Final;Cidade Destino;UF Destino;Sigla;Emitente" + CHR(13) + CHR(13) +
                      "1235;101;89203331;89203390;JOINVILLE;RS;SPAD;147048"  + CHR(13) +
                      "1352;104;20989222;21000000;BAGE;RS;WXYZ;108050"  + CHR(13) +
                      "5235;104;82992992;85999999;BELO HORIZONTE;MG;BELOH;189137" + CHR(13).
    
    DEFINE FRAME fLayout
        c-editor        AT ROW 1.21 COL 1 COLON-ALIGNED VIEW-AS EDITOR SIZE 54 BY 7 NO-LABEL
        btLayoutFechar  AT ROW 8.53 COL 2
        rtGoToButton    AT ROW 8.28 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "Layout de Importaá∆o" FONT 1
              DEFAULT-BUTTON btLayoutFechar.

    DISPLAY c-editor
        WITH FRAME fLayout.

    ENABLE btLayoutFechar
        WITH FRAME fLayout. 
    
    WAIT-FOR "GO":U OF FRAME fLayout.

    RETURN "OK":U.
   
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
     {method/zoomreposition.i &ProgramZoom="eszoom/z01es921.w"}
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


&Scoped-define SELF-NAME tt-int-logistica-ecommerce.cidade
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-int-logistica-ecommerce.cidade wMaintenance
ON F5 OF tt-int-logistica-ecommerce.cidade IN FRAME fpage0 /* Cidade Destino */
DO:
       
      {method/zoomfields.i &ProgramZoom="dizoom/z01di341.w"
                                 &FieldZoom1="cidade"
                                 &FieldScreen1="{&ttTable}.cidade"
                                 &Frame1="fPage0"
                                 &EnableImplant="no"}
                                 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-int-logistica-ecommerce.cidade wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-int-logistica-ecommerce.cidade IN FRAME fpage0 /* Cidade Destino */
DO:
  APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-int-logistica-ecommerce.cod-emitente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-int-logistica-ecommerce.cod-emitente wMaintenance
ON F5 OF tt-int-logistica-ecommerce.cod-emitente IN FRAME fpage0 /* Emitente */
DO:
  {include/zoomvar.i &prog-zoom=adzoom/z01ad098.w
                     &campo={&ttTable}.cod-emitente
                     &campozoom=cod-emitente
                     &frame=fPage0
                     &campo2=c-nome-abrev
                     &campozoom2=nome-abrev
                     &frame2=fPage0}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-int-logistica-ecommerce.cod-emitente wMaintenance
ON LEAVE OF tt-int-logistica-ecommerce.cod-emitente IN FRAME fpage0 /* Emitente */
DO:
    {include/leave.i &tabela=emitente
                     &atributo-ref=nome-abrev
                     &variavel-ref=c-nome-abrev
                     &where="emitente.cod-emitente = input frame fPage0 {&ttTable}.cod-emitente"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-int-logistica-ecommerce.cod-emitente wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-int-logistica-ecommerce.cod-emitente IN FRAME fpage0 /* Emitente */
DO:
  APPLY 'f5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-int-logistica-ecommerce.cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-int-logistica-ecommerce.cod-estabel wMaintenance
ON F5 OF tt-int-logistica-ecommerce.cod-estabel IN FRAME fpage0 /* Estab Origem */
DO:
  {include/zoomvar.i &prog-zoom=adzoom/z01ad107.w
                 &campo={&ttTable}.cod-estabel
                 &campozoom=cod-estabel
                 &frame=fPage0
                 &campo2=c-desc-estabel
                 &campozoom2=nome
                 &frame2=fPage0}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-int-logistica-ecommerce.cod-estabel wMaintenance
ON LEAVE OF tt-int-logistica-ecommerce.cod-estabel IN FRAME fpage0 /* Estab Origem */
DO:
  
    {include/leave.i &tabela=estabelec
                  &atributo-ref=nome
                  &variavel-ref=c-desc-estabel
                   &where="estabelec.cod-estabel = input frame fPage0 {&ttTable}.cod-estabel"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-int-logistica-ecommerce.cod-estabel wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-int-logistica-ecommerce.cod-estabel IN FRAME fpage0 /* Estab Origem */
DO:
    APPLY 'f5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-int-logistica-ecommerce.cod-transp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-int-logistica-ecommerce.cod-transp wMaintenance
ON F5 OF tt-int-logistica-ecommerce.cod-transp IN FRAME fpage0 /* Cod Transp */
DO:
      
     {include/zoomvar.i &prog-zoom=adzoom/z01ad268.w
         &campo=tt-int-logistica-ecommerce.cod-transp
         &campozoom=cod-transp
         &campo2=c-desc-transp
         &campozoom2=nome-abrev}
      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-int-logistica-ecommerce.cod-transp wMaintenance
ON LEAVE OF tt-int-logistica-ecommerce.cod-transp IN FRAME fpage0 /* Cod Transp */
DO:
  
    {include/leave.i &tabela=transporte
                    &atributo-ref=nome-abrev
                    &variavel-ref=c-desc-transp
                    &where="transporte.cod-trans = input frame fPage0 {&ttTable}.cod-transp"}
                    
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-int-logistica-ecommerce.cod-transp wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-int-logistica-ecommerce.cod-transp IN FRAME fpage0 /* Cod Transp */
DO:
   APPLY 'f5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-int-logistica-ecommerce.Estado
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-int-logistica-ecommerce.Estado wMaintenance
ON F5 OF tt-int-logistica-ecommerce.Estado IN FRAME fpage0 /* UF */
DO:
      {include/zoomvar.i &prog-zoom="unzoom/z01un007.w"
                     &campo=tt-int-logistica-ecommerce.estado
                     &campozoom=estado}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-int-logistica-ecommerce.Estado wMaintenance
ON LEAVE OF tt-int-logistica-ecommerce.Estado IN FRAME fpage0 /* UF */
DO:
    {include/leave.i
             &tabela=unid-feder
             &atributo-ref=no-estado
             &variavel-ref=c-desc-uf
             &where="unid-feder.estado = input frame fPage0 tt-int-logistica-ecommerce.estado"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-int-logistica-ecommerce.Estado wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-int-logistica-ecommerce.Estado IN FRAME fpage0 /* UF */
DO:
  APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenance 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{maintenance/mainblock.i}

tt-int-logistica-ecommerce.cod-transp:LOAD-MOUSE-POINTER("image/lupa.cur":U)  in frame fPage0.
tt-int-logistica-ecommerce.cod-estabel:LOAD-MOUSE-POINTER("image/lupa.cur":U)  in frame fPage0.
tt-int-logistica-ecommerce.estado:LOAD-MOUSE-POINTER("image/lupa.cur":U) in frame fPage0.
tt-int-logistica-ecommerce.cidade:LOAD-MOUSE-POINTER("image/lupa.cur":U) in frame fPage0.
tt-int-logistica-ecommerce.cod-emitente:LOAD-MOUSE-POINTER("image/lupa.cur":U) in frame fPage0.


ASSIGN btQueryJoins:VISIBLE   IN FRAME fPage0 = NO
       btReportsJoins:VISIBLE IN FRAME fPage0 = NO
       btHelp:VISIBLE         IN FRAME fPage0 = NO
       btexit:COL             IN FRAME fpage0 = 86.72.

ENABLE btImportar btLayout btElimina WITH FRAME fPage0.

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

    APPLY 'leave' TO {&ttTable}.cod-transp      IN FRAME Fpage0.
    APPLY 'leave' TO {&ttTable}.cod-estabel     IN FRAME Fpage0.
    APPLY 'leave' TO {&ttTable}.cidade          IN FRAME Fpage0.
    APPLY 'leave' TO {&ttTable}.estado          IN FRAME Fpage0.
    APPLY 'leave' TO {&ttTable}.cod-emitente    IN FRAME Fpage0.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToRecord wMaintenance 
PROCEDURE goToRecord :
/*:T------------------------------------------------------------------------------
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
    
    DEFINE VARIABLE pcod-estabel    LIKE {&ttTable}.cod-estabel NO-UNDO.
    DEFINE VARIABLE pcod-transp     LIKE {&ttTable}.cod-transp NO-UNDO. 
    DEFINE VARIABLE p-estado        LIKE {&ttTable}.estado NO-UNDO.
    DEFINE VARIABLE pcod-cidade     LIKE {&ttTable}.cidade NO-UNDO.
    DEFINE VARIABLE pcep-inicial    LIKE {&ttTable}.cep-inicial NO-UNDO.
    DEFINE VARIABLE pcep-final      LIKE {&ttTable}.cep-final NO-UNDO.
    DEFINE VARIABLE pcod-emitente   LIKE {&ttTable}.cod-emitente NO-UNDO.

    DEFINE FRAME fGoToRecord
        pcod-transp     AT ROW 1.21 COL 17.72 COLON-ALIGNED VIEW-AS FILL-IN SIZE 04 BY .88
        pcod-estabel    AT ROW 2.21 COL 17.72 COLON-ALIGNED VIEW-AS FILL-IN SIZE 04 BY .88
        pcep-inicial    AT ROW 3.21 COL 17.72 COLON-ALIGNED VIEW-AS FILL-IN SIZE 04 BY .88
        pcep-final      AT ROW 4.21 COL 17.72 COLON-ALIGNED VIEW-AS FILL-IN SIZE 04 BY .88
        p-estado        AT ROW 5.21 COL 17.72 COLON-ALIGNED VIEW-AS FILL-IN SIZE 04 BY .88
        pcod-cidade     AT ROW 6.21 COL 17.72 COLON-ALIGNED VIEW-AS FILL-IN SIZE 12 BY .88
        pcod-emitente   AT ROW 1.21 COL 35.72 COLON-ALIGNED VIEW-AS FILL-IN SIZE 12 BY .88
        btGoToOK          AT ROW 7.63 COL 2.14
        btGoToCancel      AT ROW 7.63 COL 13
        rtGoToButton      AT ROW 7.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V† Para Definiá∆o Sigla Transportadoras" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.

    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN pcod-transp
               pcod-estabel 
               pcep-inicial
               pcep-final
               p-estado 
               pcod-cidade
               pcod-emitente.
        
        RUN goToKey IN {&hDBOTable} (INPUT pcod-transp,
                                     INPUT pcod-estabel,
                                     INPUT pcep-inicial,
                                     INPUT pcep-final,
                                     INPUT p-estado,
                                     INPUT pcod-cidade,
                                     INPUT pcod-emitente).
        IF RETURN-VALUE = "NOK":U THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT "Definiá∆o Sigla Transportadoras":U).
            
            RETURN NO-APPLY.
        END.
        
        /*:T Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOTable} (OUTPUT rGoTo).
        
        /*:T Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).

        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    ENABLE pcod-transp pcod-estabel pcep-inicial pcep-final p-estado pcod-cidade btGoToOK btGoToCancel pcod-emitente
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
    
    /*:T--- Verifica se o DBO j† est† inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOTable}) OR
       {&hDBOTable}:TYPE <> "PROCEDURE":U OR
       {&hDBOTable}:FILE-NAME <> "esbo/boes175.p":U THEN DO:
        {btb/btb008za.i1 esbo/boes175.p YES}
        {btb/btb008za.i2 esbo/boes175.p '' {&hDBOTable}}
    END.
    
    RUN openQueryStatic IN {&hDBOTable} (INPUT "Main":U) NO-ERROR.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-cep wMaintenance 
PROCEDURE pi-atualiza-cep :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FOR EACH tt-int-logistica-ecommerce-imp:

    IF LENGTH(tt-int-logistica-ecommerce-imp.cep-inicial) = 6 THEN DO:
        ASSIGN tt-int-logistica-ecommerce-imp.cep-inicial = "00" + tt-int-logistica-ecommerce-imp.cep-inicial.
    END.
    ELSE IF LENGTH(tt-int-logistica-ecommerce-imp.cep-inicial) = 7 THEN DO:
            ASSIGN tt-int-logistica-ecommerce-imp.cep-inicial = "0" + tt-int-logistica-ecommerce-imp.cep-inicial.
    END.

    IF LENGTH(tt-int-logistica-ecommerce-imp.cep-final) = 6 THEN DO:
        ASSIGN tt-int-logistica-ecommerce-imp.cep-final = "00" + tt-int-logistica-ecommerce-imp.cep-final.
    END.
    ELSE IF LENGTH(tt-int-logistica-ecommerce-imp.cep-final) = 7 THEN DO:
            ASSIGN tt-int-logistica-ecommerce-imp.cep-final = "0" + tt-int-logistica-ecommerce-imp.cep-final.
    END.

END.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validar-imp wMaintenance 
PROCEDURE pi-validar-imp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/*     IF CAN-FIND(FIRST int-logistica-ecommerce                                                                                                             */
/*                    WHERE int-logistica-ecommerce.cod-transp     = tt-int-logistica-ecommerce-imp.cod-transp                                               */
/*                      AND int-logistica-ecommerce.cod-estabel    = tt-int-logistica-ecommerce-imp.cod-estabel                                              */
/*                      AND int-logistica-ecommerce.cep-inicial    = tt-int-logistica-ecommerce-imp.cep-inicial                                              */
/*                      AND int-logistica-ecommerce.cep-final      = tt-int-logistica-ecommerce-imp.cep-final                                                */
/*                      AND int-logistica-ecommerce.estado         = tt-int-logistica-ecommerce-imp.estado                                                   */
/*                      AND int-logistica-ecommerce.cidade         = tt-int-logistica-ecommerce-imp.cidade) THEN DO:                                         */
/*                                                                                                                                                        */
/*         CREATE rowErrors.                                                                                                                              */
/*         ASSIGN rowErrors.ErrorNumber      = 17006                                                                                                      */
/*                rowErrors.ErrorType        = "EMS":U                                                                                                    */
/*                rowErrors.ErrorSubType     = "Error"                                                                                                    */
/*                rowErrors.ErrorDescription = "Definiá∆o de Sigla de Transportadora j† existente."                                                       */
/*                rowErrors.ErrorHelp        = "Definiá∆o de Sigla Transportadora j† existente! Linha: " + STRING(tt-int-logistica-ecommerce-imp.linha).  */
/*         RETURN "NOK":U.                                                                                                                                */
/*     END.                                                                                                                                               */

    IF  trim(tt-int-logistica-ecommerce-imp.sigla-transp) = "" THEN DO:
        CREATE rowErrors.
        ASSIGN rowErrors.ErrorNumber      = 17006
               rowErrors.ErrorType        = "EMS":U
               rowErrors.ErrorSubType     = "Error"
               rowErrors.ErrorDescription = "Estabelecimento inv†lido."
               rowErrors.ErrorHelp        = "Sigla n∆o informada! Linha: " + STRING(tt-int-logistica-ecommerce-imp.linha).
        RETURN "NOK":U.
    END.

    IF NOT CAN-FIND(FIRST estabelec WHERE estabelec.cod-estabel = tt-int-logistica-ecommerce-imp.cod-estabel) THEN DO:
        CREATE rowErrors.
        ASSIGN rowErrors.ErrorNumber      = 17006
               rowErrors.ErrorType        = "EMS":U
               rowErrors.ErrorSubType     = "Error"
               rowErrors.ErrorDescription = "Estabelecimento inv†lido."
               rowErrors.ErrorHelp        = "C¢digo do Estabelecimento n∆o cadastrado! Linha: " + STRING(tt-int-logistica-ecommerce-imp.linha).
        RETURN "NOK":U.
    END.

    IF NOT CAN-FIND(FIRST transporte WHERE transporte.cod-transp = tt-int-logistica-ecommerce-imp.cod-trans) THEN DO:
        CREATE rowErrors.
        ASSIGN rowErrors.ErrorNumber      = 17006
               rowErrors.ErrorType        = "EMS":U
               rowErrors.ErrorSubType     = "Error"
               rowErrors.ErrorDescription = "Transportadora inv†lida."
               rowErrors.ErrorHelp        = "Transportadora n∆o cadastrada! Linha: " + STRING(tt-int-logistica-ecommerce-imp.linha).
        RETURN "NOK":U.
    END.

    IF tt-int-logistica-ecommerce-imp.cidade <> "":U THEN DO:

        IF NOT CAN-FIND(FIRST mgcad.cidade 
                  WHERE cidade.cidade = tt-int-logistica-ecommerce-imp.cidade 
                    AND cidade.estado = tt-int-logistica-ecommerce-imp.estado) THEN DO:
            CREATE rowErrors.
            ASSIGN rowErrors.ErrorNumber      = 17006
                   rowErrors.ErrorType        = "EMS":U
                   rowErrors.ErrorSubType     = "Error"
                   rowErrors.ErrorDescription = "Cidade Destino inv†lida: " + tt-int-logistica-ecommerce-imp.cidade  + "  - UF: " + tt-int-logistica-ecommerce-imp.estado.
                   rowErrors.ErrorHelp        = "Cidade Destino n∆o cadastrada! Linha: " + STRING(tt-int-logistica-ecommerce-imp.linha).
            RETURN "NOK":U.
        END.

        IF NOT CAN-FIND(FIRST unid-feder WHERE unid-feder.estado = tt-int-logistica-ecommerce-imp.estado) THEN DO:
            CREATE rowErrors.
            ASSIGN rowErrors.ErrorNumber      = 17006
                   rowErrors.ErrorType        = "EMS":U
                   rowErrors.ErrorSubType     = "Error"
                   rowErrors.ErrorDescription = "UF Destino inv†lida."
                   rowErrors.ErrorHelp        = "UF Destino n∆o cadastrada! Linha: " + STRING(tt-int-logistica-ecommerce-imp.linha).
            RETURN "NOK":U.
        END.
    END.
    ELSE DO:

        IF tt-int-logistica-ecommerce-imp.estado <> "":U THEN DO:
            IF NOT CAN-FIND(FIRST unid-feder WHERE unid-feder.estado = tt-int-logistica-ecommerce-imp.estado) THEN DO:
                CREATE rowErrors.
                ASSIGN rowErrors.ErrorNumber      = 17006
                       rowErrors.ErrorType        = "EMS":U
                       rowErrors.ErrorSubType     = "Error"
                       rowErrors.ErrorDescription = "UF Destino inv†lido."
                       rowErrors.ErrorHelp        = "UF Destino n∆o cadastrada! Linha: " + STRING(tt-int-logistica-ecommerce-imp.linha).
                RETURN "NOK":U.
            END.
        END.
    END.

    /*
    IF tt-int-logistica-ecommerce-imp.cod-cliente = "":U AND tt-int-logistica-ecommerce-imp.cod-uf = "":U AND tt-int-logistica-ecommerce-imp.cod-cidade = "":U THEN DO:
        CREATE rowErrors.
        ASSIGN rowErrors.ErrorNumber      = 17006
               rowErrors.ErrorType        = "EMS":U
               rowErrors.ErrorSubType     = "Error"
               rowErrors.ErrorDescription = "Arquivo inv†lido."
               rowErrors.ErrorHelp        = "ê Necess†rio Informar ao menos um dos campos (Cliente Destino, Cidade Destino ou UF Destino).".
        RETURN "NOK":U.
    END.
    */

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

