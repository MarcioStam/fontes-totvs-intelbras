&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenance


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-crm-atendente NO-UNDO LIKE crm-atendente
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
{include/i-prgvrs.i ESCDP037 2.00.00.001}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESCDP037
&GLOBAL-DEFINE Version        2.00.00.001

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    

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

&GLOBAL-DEFINE ttTable        tt-crm-atendente
&GLOBAL-DEFINE hDBOTable      h-boes567
&GLOBAL-DEFINE DBOTable       crm-atendente

&GLOBAL-DEFINE page0KeyFields tt-crm-atendente.cod-estabel tt-crm-atendente.cod-rep ~
                              i-cd-unid-comerc             tt-crm-atendente.cd-categoria ~
                              tt-crm-atendente.cod-gr-cli
&GLOBAL-DEFINE page0Fields    tt-crm-atendente.cd-atend

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable} AS HANDLE NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE      NO-UNDO.
DEFINE                   VARIABLE wh-pesquisa    AS HANDLE      NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE l-implanta     AS LOGICAL.

/* Definicao da Temp-tables usadas no programa ESCRM001B.p */
{esp/crm/escrm001b.i}

DEFINE TEMP-TABLE tt-crm-atendente-aux NO-UNDO
    FIELD cod-estabel   LIKE crm-atendente.cod-estabel
    FIELD cod-rep       LIKE crm-atendente.cod-rep
    FIELD cd-unid-negoc LIKE crm-atendente.cd-unid-negoc
    FIELD cd-categoria  LIKE crm-atendente.cd-categoria
    FIELD cod-gr-cli    LIKE crm-atendente.cod-gr-cli
    FIELD cd-atend      LIKE crm-atendente.cd-atend
    FIELD linha         AS INTEGER.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Maintenance
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fPage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-crm-atendente.cod-estabel ~
tt-crm-atendente.cod-rep tt-crm-atendente.cd-categoria ~
tt-crm-atendente.cod-gr-cli tt-crm-atendente.cd-atend 
&Scoped-define ENABLED-TABLES tt-crm-atendente
&Scoped-define FIRST-ENABLED-TABLE tt-crm-atendente
&Scoped-Define ENABLED-OBJECTS rtToolBar rtKeys rtKeys-2 btFirst btPrev ~
btNext btLast btGoTo btSearch btAdd btCopy btUpdate btDelete btUndo ~
btCancel btSave btQueryJoins btReportsJoins btExit btHelp bt-exportar ~
bt-excluir-faixa btImportar btLayout c-desc-estabel c-nome-rep ~
i-cd-unid-comerc c-desc-unid-comerc c-desc-categoria c-desc-gr-cli ~
c-nome-atend 
&Scoped-Define DISPLAYED-FIELDS tt-crm-atendente.cod-estabel ~
tt-crm-atendente.cod-rep tt-crm-atendente.cd-categoria ~
tt-crm-atendente.cod-gr-cli tt-crm-atendente.cd-atend 
&Scoped-define DISPLAYED-TABLES tt-crm-atendente
&Scoped-define FIRST-DISPLAYED-TABLE tt-crm-atendente
&Scoped-Define DISPLAYED-OBJECTS c-desc-estabel c-nome-rep i-cd-unid-comerc ~
c-desc-unid-comerc c-desc-categoria c-desc-gr-cli c-nome-atend 

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
DEFINE BUTTON bt-excluir-faixa 
     LABEL "Excluir Faixa" 
     SIZE 8.86 BY 1.

DEFINE BUTTON bt-exportar 
     LABEL "Exportar" 
     SIZE 6.43 BY 1.

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

DEFINE BUTTON btImportar 
     LABEL "Importar" 
     SIZE 6.14 BY 1 TOOLTIP "Importar dados do Excel".

DEFINE BUTTON btLast 
     IMAGE-UP FILE "image\im-las":U
     IMAGE-INSENSITIVE FILE "image\ii-las":U
     LABEL "Last":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btLayout 
     LABEL "Layout" 
     SIZE 5.29 BY 1 TOOLTIP "Exemplo de Layout para Importa‡Æo".

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

DEFINE VARIABLE c-desc-categoria AS CHARACTER FORMAT "X(100)":U 
     VIEW-AS FILL-IN 
     SIZE 56.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-estabel AS CHARACTER FORMAT "X(100)":U 
     VIEW-AS FILL-IN 
     SIZE 56.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-gr-cli AS CHARACTER FORMAT "X(100)":U 
     VIEW-AS FILL-IN 
     SIZE 56.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-unid-comerc AS CHARACTER FORMAT "X(100)":U 
     VIEW-AS FILL-IN 
     SIZE 56.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-atend AS CHARACTER FORMAT "X(100)":U 
     VIEW-AS FILL-IN 
     SIZE 56.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-rep AS CHARACTER FORMAT "X(100)":U 
     VIEW-AS FILL-IN 
     SIZE 56.57 BY .88 NO-UNDO.

DEFINE VARIABLE i-cd-unid-comerc AS INTEGER FORMAT ">>9" INITIAL 0 
     LABEL "Unid Comercial" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 5.33.

DEFINE RECTANGLE rtKeys-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 1.29.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fPage0
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
     btAdd AT ROW 1.13 COL 27.14 HELP
          "Inclui nova ocorrˆncia"
     btCopy AT ROW 1.13 COL 31.14 HELP
          "Cria uma c¢pia da ocorrˆncia corrente"
     btUpdate AT ROW 1.13 COL 35.14 HELP
          "Altera ocorrˆncia corrente"
     btDelete AT ROW 1.13 COL 39.14 HELP
          "Elimina ocorrˆncia corrente"
     btUndo AT ROW 1.13 COL 43.14 HELP
          "Desfaz altera‡äes"
     btCancel AT ROW 1.13 COL 47.14 HELP
          "Cancela altera‡äes"
     btSave AT ROW 1.13 COL 51.14 HELP
          "Confirma altera‡äes"
     btQueryJoins AT ROW 1.13 COL 74.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda"
     bt-exportar AT ROW 1.25 COL 59.57 WIDGET-ID 34
     bt-excluir-faixa AT ROW 1.25 COL 66.14 WIDGET-ID 36
     btImportar AT ROW 1.25 COL 75 HELP
          "Importar os dados de uma Planilha Excel" WIDGET-ID 12
     btLayout AT ROW 1.25 COL 81.29 HELP
          "Exemplo de Layout para Importa‡Æo" WIDGET-ID 32
     tt-crm-atendente.cod-estabel AT ROW 2.92 COL 19 COLON-ALIGNED WIDGET-ID 8
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     c-desc-estabel AT ROW 2.92 COL 25.43 COLON-ALIGNED NO-LABEL WIDGET-ID 16
     tt-crm-atendente.cod-rep AT ROW 3.92 COL 19 COLON-ALIGNED WIDGET-ID 10
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     c-nome-rep AT ROW 3.92 COL 25.43 COLON-ALIGNED NO-LABEL WIDGET-ID 18
     i-cd-unid-comerc AT ROW 4.92 COL 19 COLON-ALIGNED HELP
          "C¢digo da Unidade Comercial" WIDGET-ID 26
     c-desc-unid-comerc AT ROW 4.92 COL 25.43 COLON-ALIGNED NO-LABEL WIDGET-ID 20
     tt-crm-atendente.cd-categoria AT ROW 5.92 COL 19 COLON-ALIGNED WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     c-desc-categoria AT ROW 5.92 COL 25.43 COLON-ALIGNED NO-LABEL WIDGET-ID 22
     tt-crm-atendente.cod-gr-cli AT ROW 6.92 COL 19.14 COLON-ALIGNED WIDGET-ID 28
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     c-desc-gr-cli AT ROW 6.92 COL 25.43 COLON-ALIGNED NO-LABEL WIDGET-ID 30
     tt-crm-atendente.cd-atend AT ROW 8.38 COL 19 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     c-nome-atend AT ROW 8.38 COL 25.43 COLON-ALIGNED NO-LABEL WIDGET-ID 24
     rtToolBar AT ROW 1 COL 1
     rtKeys AT ROW 2.67 COL 1
     rtKeys-2 AT ROW 8.17 COL 1 WIDGET-ID 14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 8.67
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Maintenance
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: tt-crm-atendente T "?" NO-UNDO mgesp crm-atendente
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
         HEIGHT             = 8.54
         WIDTH              = 89.86
         MAX-HEIGHT         = 27.04
         MAX-WIDTH          = 195.14
         VIRTUAL-HEIGHT     = 27.04
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
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME fPage0
   FRAME-NAME                                                           */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMaintenance)
THEN wMaintenance:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage0
/* Query rebuild information for FRAME fPage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage0 */
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


&Scoped-define SELF-NAME bt-excluir-faixa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-excluir-faixa wMaintenance
ON CHOOSE OF bt-excluir-faixa IN FRAME fPage0 /* Excluir Faixa */
DO:
  RUN esp\cdp\escdp037a.w.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-exportar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-exportar wMaintenance
ON CHOOSE OF bt-exportar IN FRAME fPage0 /* Exportar */
/*:T------------------------------------------------------------------------------
  Purpose:     Exibe dialog de V  Para
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
do:
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
    
    DEFINE VARIABLE c-arquivo   AS CHAR FORMAT "x(100)"  LABEL "Arquivo" INITIAL "c:\escdp037.csv" NO-UNDO.
    ASSIGN c-arquivo = "c:\escdp037.csv".
    
    DEFINE FRAME fGoToRecord
        c-arquivo      AT ROW 1.21 COL 12.72 COLON-ALIGNED

        btGoToOK          AT ROW 3.63 COL 2.14
        btGoToCancel      AT ROW 3.63 COL 13
        rtGoToButton      AT ROW 3.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "Exporta Dados" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.

    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN c-arquivo.
        
        OUTPUT TO VALUE(c-arquivo).
        FOR EACH crm-atendente NO-LOCK:
             PUT crm-atendente.cod-estabel ";"
                 crm-atendente.cod-rep     ";"
                 crm-atendente.cd-unid-negoc ";"
                 crm-atendente.cd-categoria  ";"
                 crm-atendente.cod-gr-cli    ";"
                 crm-atendente.cd-atend SKIP.
         END.
         OUTPUT CLOSE.
        DOS SILENT notepad value(c-arquivo).

         APPLY "GO":U TO FRAME fGoToRecord.
     END.

     ENABLE c-arquivo btGoToOK btGoToCancel 
         WITH FRAME fGoToRecord. 
     
     WAIT-FOR "GO":U OF FRAME fGoToRecord.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btAdd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAdd wMaintenance
ON CHOOSE OF btAdd IN FRAME fPage0 /* Add */
OR CHOOSE OF MENU-ITEM miAdd in MENU mbMain DO:
    RUN addRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wMaintenance
ON CHOOSE OF btCancel IN FRAME fPage0 /* Cancel */
OR CHOOSE OF MENU-ITEM miCancel IN MENU mbMain DO:
    RUN cancelRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCopy
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCopy wMaintenance
ON CHOOSE OF btCopy IN FRAME fPage0 /* Copy */
OR CHOOSE OF MENU-ITEM miCopy IN MENU mbMain DO:
    RUN copyRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btDelete
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDelete wMaintenance
ON CHOOSE OF btDelete IN FRAME fPage0 /* Delete */
OR CHOOSE OF MENU-ITEM miDelete IN MENU mbMain DO:
    RUN deleteRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wMaintenance
ON CHOOSE OF btExit IN FRAME fPage0 /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btFirst
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFirst wMaintenance
ON CHOOSE OF btFirst IN FRAME fPage0 /* First */
OR CHOOSE OF MENU-ITEM miFirst IN MENU mbMain DO:
    RUN getFirst IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btGoTo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btGoTo wMaintenance
ON CHOOSE OF btGoTo IN FRAME fPage0 /* Go To */
OR CHOOSE OF MENU-ITEM miGoTo IN MENU mbMain DO:
    RUN goToRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wMaintenance
ON CHOOSE OF btHelp IN FRAME fPage0 /* Help */
OR CHOOSE OF MENU-ITEM miContents IN MENU mbMain DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btImportar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btImportar wMaintenance
ON CHOOSE OF btImportar IN FRAME fPage0 /* Importar */
DO:
    DEFINE VARIABLE h-acomp     AS HANDLE      NO-UNDO.
    DEFINE VARIABLE c-arquivo   AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE l-ok        AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE i-cont      AS INTEGER     NO-UNDO.

    EMPTY TEMP-TABLE tt-crm-atendente-aux.
    EMPTY TEMP-TABLE rowErrors.
    ASSIGN i-cont = 0.


    /* Solicita arquivo que ser  importado */
    SYSTEM-DIALOG GET-FILE c-arquivo
            TITLE      "Importar Dados"
            FILTERS    "Arquivos de texto (*.csv)" "*.csv"
            INITIAL-DIR SESSION:TEMP-DIRECTORY
            MUST-EXIST
            USE-FILENAME
            UPDATE l-ok.

    IF  NOT l-ok THEN
        RETURN "NOK":U.


    IF  NOT VALID-HANDLE(h-acomp) THEN
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

    RUN pi-inicializar IN h-acomp (INPUT "Importando Dados").

    /* Importa as Notas de um arquivo */
    INPUT FROM VALUE(c-arquivo) NO-ECHO.
    REPEAT:
        ASSIGN i-cont = i-cont + 1.

        RUN pi-acompanhar IN h-acomp (INPUT "Importando linha " + STRING(i-cont)).

        CREATE tt-crm-atendente-aux.
        ASSIGN tt-crm-atendente-aux.linha = i-cont.
        IMPORT DELIMITER ";" tt-crm-atendente-aux.
    END.
    INPUT CLOSE.

    IF  VALID-HANDLE(h-acomp) THEN
        RUN pi-finalizar IN h-acomp.


    /* Efetiva‡Æo dos dados */
    /* NÆo busca o £ltimo registro criado, com as informa‡äes em branco! */
    FOR EACH  tt-crm-atendente-aux EXCLUSIVE-LOCK
        WHERE tt-crm-atendente-aux.linha < i-cont:

        IF  tt-crm-atendente-aux.cod-estabel = "0" OR
            tt-crm-atendente-aux.cod-estabel = ""  THEN DO:
            CREATE rowErrors.
            ASSIGN rowErrors.ErrorNumber      = 17006
                   rowErrors.ErrorType        = "EMS":U
                   rowErrors.ErrorSubType     = "Error"
                   rowErrors.ErrorDescription = "Estabelecimento nÆo informado."
                   rowErrors.ErrorHelp        = "C¢digo do Estabelecimento deve ser informado! Linha: " + STRING(tt-crm-atendente-aux.linha).
            NEXT.
        END.
        ELSE DO:
            IF  NOT CAN-FIND(FIRST estabelec NO-LOCK
                             WHERE estabelec.cod-estabel = tt-crm-atendente-aux.cod-estabel) THEN DO:
                CREATE rowErrors.
                ASSIGN rowErrors.ErrorNumber      = 17006
                       rowErrors.ErrorType        = "EMS":U
                       rowErrors.ErrorSubType     = "Error"
                       rowErrors.ErrorDescription = "Estabelecimento inv lido (" + tt-crm-atendente-aux.cod-estabel + ")!"
                       rowErrors.ErrorHelp        = "Estabelecimento informado nÆo est  cadastrado! Linha: " + STRING(tt-crm-atendente-aux.linha).
                NEXT.
            END.
        END.

        IF  tt-crm-atendente-aux.cod-rep = 0 THEN DO:
            CREATE rowErrors.
            ASSIGN rowErrors.ErrorNumber      = 17006
                   rowErrors.ErrorType        = "EMS":U
                   rowErrors.ErrorSubType     = "Error"
                   rowErrors.ErrorDescription = "Representante nÆo informado."
                   rowErrors.ErrorHelp        = "C¢digo do Representante deve ser informado! Linha: " + STRING(tt-crm-atendente-aux.linha).
            NEXT.
        END.
        ELSE DO:
            IF  NOT CAN-FIND(FIRST repres NO-LOCK
                             WHERE repres.cod-rep = tt-crm-atendente-aux.cod-rep) THEN DO:
                CREATE rowErrors.
                ASSIGN rowErrors.ErrorNumber      = 17006
                       rowErrors.ErrorType        = "EMS":U
                       rowErrors.ErrorSubType     = "Error"
                       rowErrors.ErrorDescription = "Representante inv lido (" + STRING(tt-crm-atendente-aux.cod-rep) + ")!"
                       rowErrors.ErrorHelp        = "Representante informado nÆo est  cadastrado! Linha: " + STRING(tt-crm-atendente-aux.linha).
                NEXT.
            END.
        END.

        IF  tt-crm-atendente-aux.cd-unid-negoc = "0" OR
            tt-crm-atendente-aux.cd-unid-negoc = ""  THEN DO:
            CREATE rowErrors.
            ASSIGN rowErrors.ErrorNumber      = 17006
                   rowErrors.ErrorType        = "EMS":U
                   rowErrors.ErrorSubType     = "Error"
                   rowErrors.ErrorDescription = "Unidade Comercial nÆo informada."
                   rowErrors.ErrorHelp        = "Unidade Comercial deve ser informada! Linha: " + STRING(tt-crm-atendente-aux.linha).
            NEXT.
        END.
        ELSE DO:
            IF  NOT CAN-FIND(FIRST unid-comerc NO-LOCK
                             WHERE unid-comerc.cd-unid-comerc = INT(tt-crm-atendente-aux.cd-unid-negoc)) THEN DO:
                CREATE rowErrors.
                ASSIGN rowErrors.ErrorNumber      = 17006
                       rowErrors.ErrorType        = "EMS":U
                       rowErrors.ErrorSubType     = "Error"
                       rowErrors.ErrorDescription = "Unidade Comercial inv lida (" + tt-crm-atendente-aux.cd-unid-negoc + ")!"
                       rowErrors.ErrorHelp        = "Unidade Comercial informada nÆo est  cadastrada! Linha: " + STRING(tt-crm-atendente-aux.linha).
                NEXT.
            END.
        END.

        IF  tt-crm-atendente-aux.cd-categoria = 0 THEN DO:
            CREATE rowErrors.
            ASSIGN rowErrors.ErrorNumber      = 17006
                   rowErrors.ErrorType        = "EMS":U
                   rowErrors.ErrorSubType     = "Error"
                   rowErrors.ErrorDescription = "Categoria nÆo informada."
                   rowErrors.ErrorHelp        = "C¢digo da Categoria deve ser informada! Linha: " + STRING(tt-crm-atendente-aux.linha).
            NEXT.
        END.
        ELSE DO:
            IF  NOT CAN-FIND(FIRST crm-categoria NO-LOCK
                             WHERE crm-categoria.cd-categoria = tt-crm-atendente-aux.cd-categoria) THEN DO:
                CREATE rowErrors.
                ASSIGN rowErrors.ErrorNumber      = 17006
                       rowErrors.ErrorType        = "EMS":U
                       rowErrors.ErrorSubType     = "Error"
                       rowErrors.ErrorDescription = "Categoria inv lida (" + STRING(tt-crm-atendente-aux.cd-categoria) + ")!"
                       rowErrors.ErrorHelp        = "Categoria informada nÆo est  cadastrada! Linha: " + STRING(tt-crm-atendente-aux.linha).
                NEXT.
            END.
        END.

        IF  tt-crm-atendente-aux.cod-gr-cli = 0 THEN DO:
            CREATE rowErrors.
            ASSIGN rowErrors.ErrorNumber      = 17006
                   rowErrors.ErrorType        = "EMS":U
                   rowErrors.ErrorSubType     = "Error"
                   rowErrors.ErrorDescription = "Grupo de Cliente nÆo informado."
                   rowErrors.ErrorHelp        = "C¢digo do Grupo de Cliente deve ser informado! Linha: " + STRING(tt-crm-atendente-aux.linha).
            NEXT.
        END.
        ELSE DO:
            IF  NOT CAN-FIND(FIRST gr-cli NO-LOCK
                             WHERE gr-cli.cod-gr-cli = tt-crm-atendente-aux.cod-gr-cli) THEN DO:
                CREATE rowErrors.
                ASSIGN rowErrors.ErrorNumber      = 17006
                       rowErrors.ErrorType        = "EMS":U
                       rowErrors.ErrorSubType     = "Error"
                       rowErrors.ErrorDescription = "Grupo de Cliente inv lido (" + STRING(tt-crm-atendente-aux.cod-gr-cli) + ")!"
                       rowErrors.ErrorHelp        = "Grupo de Cliente informado nÆo est  cadastrado! Linha: " + STRING(tt-crm-atendente-aux.linha).
                NEXT.
            END.
        END.

        IF  tt-crm-atendente-aux.cd-atend = 0 THEN DO:
            CREATE rowErrors.
            ASSIGN rowErrors.ErrorNumber      = 17006
                   rowErrors.ErrorType        = "EMS":U
                   rowErrors.ErrorSubType     = "Error"
                   rowErrors.ErrorDescription = "Atendente nÆo informado."
                   rowErrors.ErrorHelp        = "C¢digo do Atendente deve ser informado! Linha: " + STRING(tt-crm-atendente-aux.linha).
            NEXT.
        END.
        ELSE DO:
            IF  NOT CAN-FIND(FIRST atendente NO-LOCK
                             WHERE atendente.cd-oper = tt-crm-atendente-aux.cd-atend) THEN DO:
                CREATE rowErrors.
                ASSIGN rowErrors.ErrorNumber      = 17006
                       rowErrors.ErrorType        = "EMS":U
                       rowErrors.ErrorSubType     = "Error"
                       rowErrors.ErrorDescription = "Atendente inv lido (" + STRING(tt-crm-atendente-aux.cd-atend) + ")!"
                       rowErrors.ErrorHelp        = "Atendente informado nÆo est  cadastrado! Linha: " + STRING(tt-crm-atendente-aux.linha).
                NEXT.
            END.
        END.

        FIND FIRST crm-atendente EXCLUSIVE-LOCK
                     WHERE crm-atendente.cod-estabel   = tt-crm-atendente-aux.cod-estabel
                     AND   crm-atendente.cod-rep       = tt-crm-atendente-aux.cod-rep
                     AND   crm-atendente.cd-unid-negoc = tt-crm-atendente-aux.cd-unid-negoc
                     AND   crm-atendente.cd-categoria  = tt-crm-atendente-aux.cd-categoria
                     AND   crm-atendente.cod-gr-cli    = tt-crm-atendente-aux.cod-gr-cli NO-ERROR.
        IF AVAIL crm-atendente THEN
            ASSIGN crm-atendente.cd-atend = tt-crm-atendente-aux.cd-atend.
        ELSE DO:
            CREATE crm-atendente.
            BUFFER-COPY tt-crm-atendente-aux TO crm-atendente.
        END.

        
    END.

    IF  CAN-FIND(FIRST rowErrors) THEN DO:
        {method/showmessage.i1}
        {method/showmessage.i2 &Modal="YES"}
        {method/showmessage.i3}
    END.
    ELSE DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 15825,
                           INPUT "Importa‡Æo conclu¡da!":U).
    END.

    RUN displayFields IN THIS-PROCEDURE.

    RETURN "OK":U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btLast
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btLast wMaintenance
ON CHOOSE OF btLast IN FRAME fPage0 /* Last */
OR CHOOSE OF MENU-ITEM miLast IN MENU mbMain DO:
    RUN getLast IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btLayout
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btLayout wMaintenance
ON CHOOSE OF btLayout IN FRAME fPage0 /* Layout */
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
                      FILL(" ",46) + "Layout de Importa‡Æo" + CHR(13) +
                      FILL("-",124)                         + CHR(13) + CHR(13) +
                      "O arquivo com os dados do relacionamento do Atendente deve seguir o padrÆo abaixo:" + CHR(13) +
                      "C¢d Estabel;C¢d Repres;C¢d Unid Comercial;C¢d Categoria;Grupo Cliente;C¢d Atendente;" + CHR(13) + CHR(13) +
                      "101;1171;30;5;13;30;" + CHR(13) +
                      "104;1171;30;5;13;30;" + CHR(13) +
                      "104;1193;30;15;3;1;"  + CHR(13).
    
    DEFINE FRAME fLayout
        c-editor        AT ROW 1.21 COL 1 COLON-ALIGNED VIEW-AS EDITOR SIZE 54 BY 7 NO-LABEL
        btLayoutFechar  AT ROW 8.53 COL 2
        rtGoToButton    AT ROW 8.28 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "Layout de Importa‡Æo" FONT 1
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
ON CHOOSE OF btNext IN FRAME fPage0 /* Next */
OR CHOOSE OF MENU-ITEM miNext IN MENU mbMain DO:
    RUN getNext IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btPrev
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btPrev wMaintenance
ON CHOOSE OF btPrev IN FRAME fPage0 /* Prev */
OR CHOOSE OF MENU-ITEM miPrev IN MENU mbMain DO:
    RUN getPrev IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btQueryJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btQueryJoins wMaintenance
ON CHOOSE OF btQueryJoins IN FRAME fPage0 /* Query Joins */
OR CHOOSE OF MENU-ITEM miQueryJoins IN MENU mbMain DO:
    RUN showQueryJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btReportsJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReportsJoins wMaintenance
ON CHOOSE OF btReportsJoins IN FRAME fPage0 /* Reports Joins */
OR CHOOSE OF MENU-ITEM miReportsJoins IN MENU mbMain DO:
    RUN showReportsJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave wMaintenance
ON CHOOSE OF btSave IN FRAME fPage0 /* Save */
OR CHOOSE OF MENU-ITEM miSave IN MENU mbMain DO:
    RUN saveRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSearch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSearch wMaintenance
ON CHOOSE OF btSearch IN FRAME fPage0 /* Search */
OR CHOOSE OF MENU-ITEM miSearch IN MENU mbMain DO:
    {method/zoomreposition.i &ProgramZoom="eszoom/z01es567.w"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btUndo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUndo wMaintenance
ON CHOOSE OF btUndo IN FRAME fPage0 /* Undo */
OR CHOOSE OF MENU-ITEM miUndo IN MENU mbMain DO:
    RUN undoRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btUpdate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdate wMaintenance
ON CHOOSE OF btUpdate IN FRAME fPage0 /* Update */
OR CHOOSE OF MENU-ITEM miUpdate IN MENU mbMain DO:
    RUN updateRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-crm-atendente.cd-atend
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-crm-atendente.cd-atend wMaintenance
ON F5 OF tt-crm-atendente.cd-atend IN FRAME fPage0 /* Atendente */
DO:
    {method/ZoomFields.i &ProgramZoom="eszoom/z01es013.w"
                         &FieldZoom1="cd-oper"
                         &FieldScreen1="tt-crm-atendente.cd-atend"
                         &Frame1="fPage0"
                         &FieldZoom2="nm-oper"
                         &FieldScreen2="c-nome-atend"
                         &Frame2="fPage0"
                         &EnableImplant="NO"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-crm-atendente.cd-atend wMaintenance
ON LEAVE OF tt-crm-atendente.cd-atend IN FRAME fPage0 /* Atendente */
DO:
    IF  AVAIL tt-crm-atendente THEN DO:
        ASSIGN INPUT FRAME fPage0 tt-crm-atendente.cd-atend.
    
        FIND FIRST atendente NO-LOCK
            WHERE  atendente.cd-oper = tt-crm-atendente.cd-atend NO-ERROR.

        ASSIGN c-nome-atend = IF AVAIL atendente THEN atendente.nm-oper ELSE "".
    END.
    ELSE
        ASSIGN c-nome-atend = "".
    
    DISPLAY c-nome-atend WITH FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-crm-atendente.cd-atend wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-crm-atendente.cd-atend IN FRAME fPage0 /* Atendente */
DO:
    APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-crm-atendente.cd-categoria
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-crm-atendente.cd-categoria wMaintenance
ON F5 OF tt-crm-atendente.cd-categoria IN FRAME fPage0 /* Categoria */
DO:
    {method/zoomfields.i &ProgramZoom="eszoom/z01es547.w"
                         &FieldZoom1="cd-categoria"
                         &FieldScreen1="tt-crm-atendente.cd-categoria"
                         &Frame1="fPage0"
                         &FieldZoom2="ds-categoria"
                         &FieldScreen2="c-desc-categoria"
                         &Frame2="fPage0"
                         &RunMethod="RUN setUnidNegoc IN hProgramZoom (INPUT INPUT FRAME fPage0 i-cd-unid-comerc)."
                         &EnableImplant="YES"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-crm-atendente.cd-categoria wMaintenance
ON LEAVE OF tt-crm-atendente.cd-categoria IN FRAME fPage0 /* Categoria */
DO:
    IF  AVAIL tt-crm-atendente THEN DO:
        ASSIGN INPUT FRAME fPage0 tt-crm-atendente.cd-categoria.

        IF  tt-crm-atendente.cd-categoria = ? THEN DO:
            ASSIGN c-desc-categoria = "Categoria Gen‚rica".
        END.
        ELSE DO:
            FIND FIRST crm-categoria NO-LOCK
                WHERE  crm-categoria.cd-categoria = tt-crm-atendente.cd-categoria NO-ERROR.
        
            ASSIGN c-desc-categoria = IF AVAIL crm-categoria THEN crm-categoria.ds-categoria ELSE "".
        END.
    END.
    ELSE
        ASSIGN c-desc-categoria = "".

    DISPLAY c-desc-categoria WITH FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-crm-atendente.cd-categoria wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-crm-atendente.cd-categoria IN FRAME fPage0 /* Categoria */
DO:
    APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-crm-atendente.cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-crm-atendente.cod-estabel wMaintenance
ON F5 OF tt-crm-atendente.cod-estabel IN FRAME fPage0 /* Estabelecimento */
DO:
    {include/zoomvar.i &prog-zoom=adzoom/z01ad107.w
                       &campo=tt-crm-atendente.cod-estabel
                       &campozoom=cod-estabel
                       &campo2=c-desc-estabel
                       &campozoom2=nome}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-crm-atendente.cod-estabel wMaintenance
ON LEAVE OF tt-crm-atendente.cod-estabel IN FRAME fPage0 /* Estabelecimento */
DO:
    IF  AVAIL tt-crm-atendente THEN DO:
        ASSIGN INPUT FRAME fPage0 tt-crm-atendente.cod-estabel.
    
        FIND FIRST estabelec NO-LOCK
            WHERE  estabelec.cod-estabel = tt-crm-atendente.cod-estabel NO-ERROR.

        ASSIGN c-desc-estabel = IF AVAIL estabelec THEN estabelec.nome ELSE "".
    END.
    ELSE
        ASSIGN c-desc-estabel = "".
    
    DISPLAY c-desc-estabel WITH FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-crm-atendente.cod-estabel wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-crm-atendente.cod-estabel IN FRAME fPage0 /* Estabelecimento */
DO:
    APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-crm-atendente.cod-gr-cli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-crm-atendente.cod-gr-cli wMaintenance
ON F5 OF tt-crm-atendente.cod-gr-cli IN FRAME fPage0 /* Grupo Cliente */
DO:
    {include/zoomvar.i &prog-zoom="adzoom/z01ad129.w"
                       &campo="tt-crm-atendente.cod-gr-cli"
                       &campozoom="cod-gr-cli"
                       &frame="fPage0"
                       &campo2="c-desc-gr-cli"
                       &campozoom2="descricao"
                       &frame2="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-crm-atendente.cod-gr-cli wMaintenance
ON LEAVE OF tt-crm-atendente.cod-gr-cli IN FRAME fPage0 /* Grupo Cliente */
DO:
    IF  AVAIL tt-crm-atendente THEN DO:
        ASSIGN INPUT FRAME fPage0 tt-crm-atendente.cod-gr-cli.
    
        FIND FIRST gr-cli NO-LOCK
            WHERE  gr-cli.cod-gr-cli = tt-crm-atendente.cod-gr-cli NO-ERROR.
    
        ASSIGN c-desc-gr-cli = IF AVAIL gr-cli THEN gr-cli.descricao ELSE "".
    END.
    ELSE
        ASSIGN c-desc-gr-cli = "".

    DISP c-desc-gr-cli WITH FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-crm-atendente.cod-gr-cli wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-crm-atendente.cod-gr-cli IN FRAME fPage0 /* Grupo Cliente */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-crm-atendente.cod-rep
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-crm-atendente.cod-rep wMaintenance
ON F5 OF tt-crm-atendente.cod-rep IN FRAME fPage0 /* Representante */
DO:
    {include/zoomvar.i &prog-zoom="adzoom/z01ad229.w"
                       &campo="tt-crm-atendente.cod-rep"
                       &campozoom="cod-rep"
                       &frame="fPage0"
                       &campo2="c-nome-rep"
                       &campozoom2="nome"
                       &frame2="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-crm-atendente.cod-rep wMaintenance
ON LEAVE OF tt-crm-atendente.cod-rep IN FRAME fPage0 /* Representante */
DO:
    IF  AVAIL tt-crm-atendente THEN DO:
        ASSIGN INPUT FRAME fPage0 tt-crm-atendente.cod-rep.
    
        FIND FIRST repres NO-LOCK
            WHERE  repres.cod-rep = tt-crm-atendente.cod-rep NO-ERROR.

        ASSIGN c-nome-rep = IF AVAIL repres THEN repres.nome-abrev ELSE "".
    END.
    ELSE
        ASSIGN c-nome-rep = "".
    
    DISPLAY c-nome-rep WITH FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-crm-atendente.cod-rep wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-crm-atendente.cod-rep IN FRAME fPage0 /* Representante */
DO:
    APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-cd-unid-comerc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cd-unid-comerc wMaintenance
ON F5 OF i-cd-unid-comerc IN FRAME fPage0 /* Unid Comercial */
DO:
    {method/zoomfields.i &ProgramZoom="eszoom/z01es568.w"
                         &FieldZoom1="cd-unid-comerc"
                         &FieldScreen1="i-cd-unid-comerc"
                         &Frame1="fPage0"
                         &FieldZoom2="ds-unid-comerc"
                         &FieldScreen2="c-desc-unid-comerc"
                         &Frame2="fPage0"
                         &EnableImplant="YES"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cd-unid-comerc wMaintenance
ON LEAVE OF i-cd-unid-comerc IN FRAME fPage0 /* Unid Comercial */
DO:
    ASSIGN INPUT FRAME fPage0 i-cd-unid-comerc.

    FIND FIRST unid-comerc NO-LOCK
        WHERE  unid-comerc.cd-unid-comerc = i-cd-unid-comerc NO-ERROR.

    ASSIGN c-desc-unid-comerc = IF AVAIL unid-comerc THEN unid-comerc.ds-unid-comerc ELSE "".

    DISPLAY c-desc-unid-comerc WITH FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cd-unid-comerc wMaintenance
ON MOUSE-SELECT-DBLCLICK OF i-cd-unid-comerc IN FRAME fPage0 /* Unid Comercial */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenance 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
tt-crm-atendente.cod-estabel:LOAD-MOUSE-POINTER("image/lupa.cur":U)  IN FRAME fPage0.
tt-crm-atendente.cod-rep:LOAD-MOUSE-POINTER("image/lupa.cur":U)      IN FRAME fPage0.
i-cd-unid-comerc:LOAD-MOUSE-POINTER("image/lupa.cur":U)              IN FRAME fPage0.
tt-crm-atendente.cd-categoria:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.
tt-crm-atendente.cod-gr-cli:LOAD-MOUSE-POINTER("image/lupa.cur":U)   IN FRAME fPage0.
tt-crm-atendente.cd-atend:LOAD-MOUSE-POINTER("image/lupa.cur":U)     IN FRAME fPage0.

{maintenance/mainblock.i}

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

    IF  AVAIL tt-crm-atendente THEN
        ASSIGN i-cd-unid-comerc = INT(tt-crm-atendente.cd-unid-negoc).
    ELSE
        ASSIGN i-cd-unid-comerc = 0.

    DISPLAY i-cd-unid-comerc
        WITH FRAME fPage0.

    APPLY "LEAVE":U TO tt-crm-atendente.cod-estabel  IN FRAME fPage0.
    APPLY "LEAVE":U TO tt-crm-atendente.cod-rep      IN FRAME fPage0.
    APPLY "LEAVE":U TO i-cd-unid-comerc              IN FRAME fPage0.
    APPLY "LEAVE":U TO tt-crm-atendente.cd-categoria IN FRAME fPage0.
    APPLY "LEAVE":U TO tt-crm-atendente.cod-gr-cli   IN FRAME fPage0.
    APPLY "LEAVE":U TO tt-crm-atendente.cd-atend     IN FRAME fPage0.

    RETURN "OK":U.
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

    ASSIGN btQueryJoins:VISIBLE   IN FRAME fPage0 = NO
           btReportsJoins:VISIBLE IN FRAME fPage0 = NO
           btHelp:VISIBLE         IN FRAME fPage0 = NO
           btExit:COLUMNS         IN FRAME fPage0 = 86.72.

    ENABLE btImportar
           btLayout
           bt-Exportar
           bt-excluir-faixa
        WITH FRAME fPage0.

    RETURN "OK":U.
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

    ASSIGN INPUT FRAME fPage0 i-cd-unid-comerc.

    IF  AVAIL tt-crm-atendente THEN
        ASSIGN tt-crm-atendente.cd-unid-negoc = STRING(i-cd-unid-comerc).

    RETURN "OK":U.
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
    
    DEFINE VARIABLE c-cod-estabel    LIKE {&ttTable}.cod-estabel      NO-UNDO.
    DEFINE VARIABLE i-cod-rep        LIKE {&ttTable}.cod-rep          NO-UNDO.
    DEFINE VARIABLE c-cd-unid-comerc AS CHARACTER LABEL "Unid Comerc" NO-UNDO.
    DEFINE VARIABLE i-cd-categoria   LIKE {&ttTable}.cd-categoria     NO-UNDO.
    DEFINE VARIABLE i-cod-gr-cli   LIKE {&ttTable}.cod-gr-cli       NO-UNDO.
    
    DEFINE FRAME fGoToRecord
        c-cod-estabel     AT ROW 1.21 COL 17.72 COLON-ALIGNED
        i-cod-rep         AT ROW 2.21 COL 17.72 COLON-ALIGNED
        c-cd-unid-comerc   AT ROW 3.21 COL 17.72 COLON-ALIGNED
        i-cd-categoria    AT ROW 4.21 COL 17.72 COLON-ALIGNED
        i-cod-gr-cli      AT ROW 5.21 COL 17.72 COLON-ALIGNED
        btGoToOK          AT ROW 6.63 COL 2.14
        btGoToCancel      AT ROW 6.63 COL 13
        rtGoToButton      AT ROW 6.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V  Para Atendente" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.

    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN c-cod-estabel i-cod-rep c-cd-unid-comerc i-cd-categoria i-cod-gr-cli.
        
        RUN goToKeyCat IN {&hDBOTable} (INPUT c-cod-estabel, 
                                        INPUT i-cod-rep, 
                                        INPUT c-cd-unid-comerc, 
                                        INPUT i-cd-categoria,
                                        INPUT i-cod-gr-cli).
        IF RETURN-VALUE = "NOK":U THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT "Atendente":U).
            
            RETURN NO-APPLY.
        END.
        
        /*:T Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOTable} (OUTPUT rGoTo).
        
        /*:T Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).

        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    ENABLE c-cod-estabel i-cod-rep c-cd-unid-comerc i-cd-categoria i-cod-gr-cli btGoToOK btGoToCancel 
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
       {&hDBOTable}:FILE-NAME <> "esbo/boes567.p":U THEN DO:
        {btb/btb008za.i1 esbo/boes567.p YES}
        {btb/btb008za.i2 esbo/boes567.p '' {&hDBOTable}}
    END.
    
    RUN openQueryStatic IN {&hDBOTable} (INPUT "Main":U) NO-ERROR.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

