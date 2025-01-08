&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenance


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttdef-nat-operacao NO-UNDO LIKE def-nat-operacao
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
{include/i-prgvrs.i escdp015 2.00.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        escdp015
&GLOBAL-DEFINE Version        2.00.00.000

&GLOBAL-DEFINE Folder         no
&GLOBAL-DEFINE InitialPage    1

&GLOBAL-DEFINE FolderLabels   <Folder1 ,Folder2 ,... , Folder8>

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

&GLOBAL-DEFINE ttTable        ttdef-nat-operacao
&GLOBAL-DEFINE hDBOTable      h-boes505
&GLOBAL-DEFINE DBOTable       boes505

&GLOBAL-DEFINE page0KeyFields estado-origem ind-cliente-contrib ind-insc-estadual-inf ~
                              ind-subst-tributaria ind-suframa-inf cidade-destino ~
                              class-fiscal estado-destino ind-pais-brasil ind-oem ind-consumidor-final ~
                              ind-forma-tributo ind-origem-item tg-atacado-varejo ind-lei-bem ind-icms-st-antec
&GLOBAL-DEFINE page0Fields    
&GLOBAL-DEFINE page1Fields    nat-oper-venda-de nat-oper-venda-fe ~
                              nat-oper-revenda-de nat-oper-revenda-fe ~
                              nat-oper-serv-de nat-oper-serv-fe

&GLOBAL-DEFINE page2Fields    

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable} AS HANDLE NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl  AS HANDLE       NO-UNDO.
DEFINE VARIABLE wh-pesquisa     AS HANDLE       NO-UNDO.
{cdp/cdcfgdis.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Maintenance
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fPage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ttdef-nat-operacao.ind-suframa-inf ~
ttdef-nat-operacao.estado-origem ttdef-nat-operacao.cidade-destino ~
ttdef-nat-operacao.ind-cliente-contrib ttdef-nat-operacao.estado-destino ~
ttdef-nat-operacao.ind-insc-estadual-inf ttdef-nat-operacao.class-fiscal ~
ttdef-nat-operacao.ind-subst-tributaria ~
ttdef-nat-operacao.ind-consumidor-final ~
ttdef-nat-operacao.ind-forma-tributo ttdef-nat-operacao.ind-pais-brasil ~
ttdef-nat-operacao.ind-oem ttdef-nat-operacao.ind-lei-bem ~
ttdef-nat-operacao.ind-icms-st-antec ttdef-nat-operacao.ind-origem-item 
&Scoped-define ENABLED-TABLES ttdef-nat-operacao
&Scoped-define FIRST-ENABLED-TABLE ttdef-nat-operacao
&Scoped-Define ENABLED-OBJECTS rtToolBar RECT-2 rtKeys btFirst btPrev ~
btNext btLast btGoTo btSearch btAdd btCopy btUpdate btDelete btUndo ~
btCancel btSave btQueryJoins btReportsJoins btExit btHelp tg-atacado-varejo 
&Scoped-Define DISPLAYED-FIELDS ttdef-nat-operacao.ind-suframa-inf ~
ttdef-nat-operacao.estado-origem ttdef-nat-operacao.cidade-destino ~
ttdef-nat-operacao.ind-cliente-contrib ttdef-nat-operacao.estado-destino ~
ttdef-nat-operacao.ind-insc-estadual-inf ttdef-nat-operacao.class-fiscal ~
ttdef-nat-operacao.ind-subst-tributaria ~
ttdef-nat-operacao.ind-consumidor-final ~
ttdef-nat-operacao.ind-forma-tributo ttdef-nat-operacao.ind-pais-brasil ~
ttdef-nat-operacao.ind-oem ttdef-nat-operacao.ind-lei-bem ~
ttdef-nat-operacao.ind-icms-st-antec ttdef-nat-operacao.ind-origem-item 
&Scoped-define DISPLAYED-TABLES ttdef-nat-operacao
&Scoped-define FIRST-DISPLAYED-TABLE ttdef-nat-operacao
&Scoped-Define DISPLAYED-OBJECTS tg-atacado-varejo 

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

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 34 BY 5.13.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 89 BY 12.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE VARIABLE tg-atacado-varejo AS LOGICAL INITIAL no 
     LABEL "Atacado/Varejo" 
     VIEW-AS TOGGLE-BOX
     SIZE 14.14 BY .75 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 72 BY 5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fPage0
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
     btQueryJoins AT ROW 1.13 COL 74.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda"
     ttdef-nat-operacao.ind-suframa-inf AT ROW 3.38 COL 58 WIDGET-ID 16
          VIEW-AS TOGGLE-BOX
          SIZE 17 BY .83
     ttdef-nat-operacao.estado-origem AT ROW 4 COL 15 COLON-ALIGNED WIDGET-ID 8
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     ttdef-nat-operacao.cidade-destino AT ROW 4.29 COL 56 COLON-ALIGNED WIDGET-ID 20 FORMAT "x(25)"
          VIEW-AS FILL-IN 
          SIZE 28 BY .88
     ttdef-nat-operacao.ind-cliente-contrib AT ROW 5 COL 17 WIDGET-ID 6
          VIEW-AS TOGGLE-BOX
          SIZE 21 BY .83
     ttdef-nat-operacao.estado-destino AT ROW 5.29 COL 56 COLON-ALIGNED WIDGET-ID 22
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     ttdef-nat-operacao.ind-insc-estadual-inf AT ROW 6 COL 17 WIDGET-ID 10
          VIEW-AS TOGGLE-BOX
          SIZE 20 BY .83
     ttdef-nat-operacao.class-fiscal AT ROW 6.29 COL 56 COLON-ALIGNED WIDGET-ID 68
          VIEW-AS FILL-IN 
          SIZE 8.86 BY .88
     ttdef-nat-operacao.ind-subst-tributaria AT ROW 7 COL 17 WIDGET-ID 14
          VIEW-AS TOGGLE-BOX
          SIZE 15 BY .83
     ttdef-nat-operacao.ind-consumidor-final AT ROW 8 COL 17 WIDGET-ID 28
          VIEW-AS TOGGLE-BOX
          SIZE 15 BY .83
     ttdef-nat-operacao.ind-forma-tributo AT ROW 8.79 COL 59 NO-LABEL WIDGET-ID 30
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "N∆o Cumulativo", 1,
"Cumulativo todo ou em parte", 2,
"Simples", 3,
"Nenhum", 4,
"Isento", 5
          SIZE 24 BY 4.04
     ttdef-nat-operacao.ind-pais-brasil AT ROW 9 COL 17 WIDGET-ID 18
          VIEW-AS TOGGLE-BOX
          SIZE 11.57 BY .83
     ttdef-nat-operacao.ind-oem AT ROW 10 COL 17 WIDGET-ID 24
          VIEW-AS TOGGLE-BOX
          SIZE 8 BY .83
     tg-atacado-varejo AT ROW 10.96 COL 17 WIDGET-ID 54
     ttdef-nat-operacao.ind-lei-bem AT ROW 11.96 COL 17 WIDGET-ID 56
          VIEW-AS TOGGLE-BOX
          SIZE 11 BY .75
     ttdef-nat-operacao.ind-icms-st-antec AT ROW 13 COL 17 WIDGET-ID 66
          VIEW-AS TOGGLE-BOX
          SIZE 21 BY .83
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90.43 BY 21.5
         FONT 1 WIDGET-ID 100.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME fPage0
     ttdef-nat-operacao.ind-origem-item AT ROW 13.96 COL 17.14 NO-LABEL WIDGET-ID 40
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "N∆o Informado", 1,
"Nacional", 2,
"Importado", 3
          SIZE 36.86 BY .75
     "Origem do Item:" VIEW-AS TEXT
          SIZE 11 BY .75 AT ROW 13.92 COL 6 WIDGET-ID 44
     "Forma Tributaá∆o Vendas a Partir de Manaus" VIEW-AS TEXT
          SIZE 32 BY .75 AT ROW 7.83 COL 56 WIDGET-ID 38
     rtToolBar AT ROW 1 COL 1
     RECT-2 AT ROW 8.33 COL 55 WIDGET-ID 36
     rtKeys AT ROW 3.25 COL 2 WIDGET-ID 46
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90.43 BY 21.5
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage1
     ttdef-nat-operacao.nat-oper-venda-de AT ROW 3.25 COL 23 COLON-ALIGNED NO-LABEL WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 8.86 BY .88
     ttdef-nat-operacao.nat-oper-venda-fe AT ROW 3.25 COL 48 COLON-ALIGNED NO-LABEL WIDGET-ID 36
          VIEW-AS FILL-IN 
          SIZE 8.86 BY .88
     ttdef-nat-operacao.nat-oper-revenda-de AT ROW 4.25 COL 23 COLON-ALIGNED NO-LABEL WIDGET-ID 10
          VIEW-AS FILL-IN 
          SIZE 8.86 BY .88
     ttdef-nat-operacao.nat-oper-revenda-fe AT ROW 4.25 COL 48 COLON-ALIGNED NO-LABEL WIDGET-ID 38
          VIEW-AS FILL-IN 
          SIZE 8.86 BY .88
     ttdef-nat-operacao.nat-oper-serv-de AT ROW 5.25 COL 23 COLON-ALIGNED NO-LABEL WIDGET-ID 12
          VIEW-AS FILL-IN 
          SIZE 8.86 BY .88
     ttdef-nat-operacao.nat-oper-serv-fe AT ROW 5.25 COL 48 COLON-ALIGNED NO-LABEL WIDGET-ID 40
          VIEW-AS FILL-IN 
          SIZE 8.86 BY .88
     "Naturezas de Operaá∆o" VIEW-AS TEXT
          SIZE 17 BY .75 AT ROW 1.25 COL 8 WIDGET-ID 42
     "Dentro do Estado" VIEW-AS TEXT
          SIZE 20 BY .75 AT ROW 2.25 COL 21 WIDGET-ID 16
          FONT 0
     "Serviáo:" VIEW-AS TEXT
          SIZE 6 BY .79 AT ROW 5.25 COL 19 WIDGET-ID 14
     "Revenda:" VIEW-AS TEXT
          SIZE 7 BY .79 AT ROW 4.25 COL 18 WIDGET-ID 8
     "Venda:" VIEW-AS TEXT
          SIZE 5 BY .79 AT ROW 3.25 COL 20 WIDGET-ID 6
     "Fora do Estado" VIEW-AS TEXT
          SIZE 20 BY .75 AT ROW 2.25 COL 48 WIDGET-ID 18
          FONT 0
     RECT-1 AT ROW 1.75 COL 6 WIDGET-ID 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 4.29 ROW 15.54
         SIZE 84.43 BY 6.33
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Maintenance
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: ttdef-nat-operacao T "?" NO-UNDO mgesp def-nat-operacao
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
         HEIGHT             = 22.04
         WIDTH              = 90.72
         MAX-HEIGHT         = 27.5
         MAX-WIDTH          = 195.14
         VIRTUAL-HEIGHT     = 27.5
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
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fPage0:HANDLE.

/* SETTINGS FOR FRAME fPage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN ttdef-nat-operacao.cidade-destino IN FRAME fPage0
   EXP-FORMAT                                                           */
/* SETTINGS FOR FRAME fPage1
                                                                        */
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


&Scoped-define SELF-NAME btLast
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btLast wMaintenance
ON CHOOSE OF btLast IN FRAME fPage0 /* Last */
OR CHOOSE OF MENU-ITEM miLast IN MENU mbMain DO:
    RUN getLast IN THIS-PROCEDURE.
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
   {method/zoomreposition.i &ProgramZoom="eszoom/z01es505.w"}
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


&Scoped-define SELF-NAME ttdef-nat-operacao.cidade-destino
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttdef-nat-operacao.cidade-destino wMaintenance
ON F5 OF ttdef-nat-operacao.cidade-destino IN FRAME fPage0 /* Cidade Destino */
DO:
      {method/zoomfields.i &ProgramZoom="dizoom/Z01DI341.w"
                     &FieldZoom1="cidade"                        
                     &FieldScreen1="ttdef-nat-operacao.cidade-destino"
                     &Frame1="fpage0"                           
                     &EnableImplant="no"} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttdef-nat-operacao.cidade-destino wMaintenance
ON MOUSE-SELECT-DBLCLICK OF ttdef-nat-operacao.cidade-destino IN FRAME fPage0 /* Cidade Destino */
DO:
                       
   APPLY 'F5' TO SELF.
       END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttdef-nat-operacao.class-fiscal
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttdef-nat-operacao.class-fiscal wMaintenance
ON F5 OF ttdef-nat-operacao.class-fiscal IN FRAME fPage0 /* Class Fiscal */
DO:
   {include/zoomvar.i &prog-zoom="inzoom/z01in046.w"
                      &campo=ttdef-nat-operacao.class-fiscal
                      &campozoom=class-fiscal}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttdef-nat-operacao.class-fiscal wMaintenance
ON LEAVE OF ttdef-nat-operacao.class-fiscal IN FRAME fPage0 /* Class Fiscal */
DO:
    IF INPUT FRAME fpage0 ttdef-nat-operacao.class-fiscal <> "" THEN DO:

        FIND FIRST classif-fisc NO-LOCK
             WHERE classif-fisc.class-fiscal = INPUT FRAME fpage0 ttdef-nat-operacao.class-fiscal NO-ERROR.

        IF NOT AVAIL classif-fisc THEN DO:
            RUN utp/ut-msgs.p (INPUT "show",
                               INPUT 17006,
                               INPUT "NCM informada n∆o cadastrada").
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttdef-nat-operacao.class-fiscal wMaintenance
ON MOUSE-SELECT-DBLCLICK OF ttdef-nat-operacao.class-fiscal IN FRAME fPage0 /* Class Fiscal */
DO:
    APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttdef-nat-operacao.estado-destino
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttdef-nat-operacao.estado-destino wMaintenance
ON f5 OF ttdef-nat-operacao.estado-destino IN FRAME fPage0 /* Estado Destino */
DO:
    {include/zoomvar.i &prog-zoom="unzoom/z01un007.w"
                     &campo=ttdef-nat-operacao.estado-destino
                     &campozoom=estado}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttdef-nat-operacao.estado-destino wMaintenance
ON MOUSE-SELECT-DBLCLICK OF ttdef-nat-operacao.estado-destino IN FRAME fPage0 /* Estado Destino */
DO:
     APPLY 'F5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttdef-nat-operacao.estado-origem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttdef-nat-operacao.estado-origem wMaintenance
ON f5 OF ttdef-nat-operacao.estado-origem IN FRAME fPage0 /* Estado Origem */
DO:
      {include/zoomvar.i &prog-zoom="unzoom/z01un007.w"
                     &campo=ttdef-nat-operacao.estado-origem
                     &campozoom=estado}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttdef-nat-operacao.estado-origem wMaintenance
ON MOUSE-SELECT-DBLCLICK OF ttdef-nat-operacao.estado-origem IN FRAME fPage0 /* Estado Origem */
DO:
       APPLY 'F5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME ttdef-nat-operacao.nat-oper-revenda-de
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttdef-nat-operacao.nat-oper-revenda-de wMaintenance
ON f5 OF ttdef-nat-operacao.nat-oper-revenda-de IN FRAME fPage1 /* nat-oper-revenda-de */
DO:
  {method/zoomfields.i &ProgramZoom="inzoom/z04in245.w"
                        &FieldZoom1="nat-operacao"
                        &FieldScreen1="ttdef-nat-operacao.nat-oper-revenda-de"
                        &Frame1="fPage1"                                                  
                        &EnableImplant="NO"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttdef-nat-operacao.nat-oper-revenda-de wMaintenance
ON MOUSE-SELECT-DBLCLICK OF ttdef-nat-operacao.nat-oper-revenda-de IN FRAME fPage1 /* nat-oper-revenda-de */
DO:
     APPLY 'F5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttdef-nat-operacao.nat-oper-revenda-fe
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttdef-nat-operacao.nat-oper-revenda-fe wMaintenance
ON f5 OF ttdef-nat-operacao.nat-oper-revenda-fe IN FRAME fPage1 /* nat-oper-revenda-fe */
DO:
  {method/zoomfields.i &ProgramZoom="inzoom/z04in245.w"
                        &FieldZoom1="nat-operacao"
                        &FieldScreen1="ttdef-nat-operacao.nat-oper-revenda-fe"
                        &Frame1="fPage1"                                                  
                        &EnableImplant="NO"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttdef-nat-operacao.nat-oper-revenda-fe wMaintenance
ON MOUSE-SELECT-DBLCLICK OF ttdef-nat-operacao.nat-oper-revenda-fe IN FRAME fPage1 /* nat-oper-revenda-fe */
DO:
     APPLY 'F5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttdef-nat-operacao.nat-oper-serv-de
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttdef-nat-operacao.nat-oper-serv-de wMaintenance
ON f5 OF ttdef-nat-operacao.nat-oper-serv-de IN FRAME fPage1 /* nat-oper-serv-de */
DO:
  {method/zoomfields.i &ProgramZoom="inzoom/z04in245.w"
                        &FieldZoom1="nat-operacao"
                        &FieldScreen1="ttdef-nat-operacao.nat-oper-serv-de"
                        &Frame1="fPage1"                                                  
                        &EnableImplant="NO"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttdef-nat-operacao.nat-oper-serv-de wMaintenance
ON MOUSE-SELECT-DBLCLICK OF ttdef-nat-operacao.nat-oper-serv-de IN FRAME fPage1 /* nat-oper-serv-de */
DO:
     APPLY 'F5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttdef-nat-operacao.nat-oper-serv-fe
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttdef-nat-operacao.nat-oper-serv-fe wMaintenance
ON f5 OF ttdef-nat-operacao.nat-oper-serv-fe IN FRAME fPage1 /* nat-oper-serv-fe */
DO:
  {method/zoomfields.i &ProgramZoom="inzoom/z04in245.w"
                        &FieldZoom1="nat-operacao"
                        &FieldScreen1="ttdef-nat-operacao.nat-oper-serv-fe"
                        &Frame1="fPage1"                                                  
                        &EnableImplant="NO"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttdef-nat-operacao.nat-oper-serv-fe wMaintenance
ON MOUSE-SELECT-DBLCLICK OF ttdef-nat-operacao.nat-oper-serv-fe IN FRAME fPage1 /* nat-oper-serv-fe */
DO:
     APPLY 'F5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttdef-nat-operacao.nat-oper-venda-de
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttdef-nat-operacao.nat-oper-venda-de wMaintenance
ON f5 OF ttdef-nat-operacao.nat-oper-venda-de IN FRAME fPage1 /* nat-oper-venda-de */
DO:
  
   {method/zoomfields.i &ProgramZoom="inzoom/z04in245.w"
                        &FieldZoom1="nat-operacao"
                        &FieldScreen1="ttdef-nat-operacao.nat-oper-venda-de"
                        &Frame1="fPage1"                                                  
                        &EnableImplant="NO"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttdef-nat-operacao.nat-oper-venda-de wMaintenance
ON MOUSE-SELECT-DBLCLICK OF ttdef-nat-operacao.nat-oper-venda-de IN FRAME fPage1 /* nat-oper-venda-de */
DO:
     APPLY 'F5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttdef-nat-operacao.nat-oper-venda-fe
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttdef-nat-operacao.nat-oper-venda-fe wMaintenance
ON f5 OF ttdef-nat-operacao.nat-oper-venda-fe IN FRAME fPage1 /* nat-oper-venda-fe */
DO:
  {method/zoomfields.i &ProgramZoom="inzoom/z04in245.w"
                        &FieldZoom1="nat-operacao"
                        &FieldScreen1="ttdef-nat-operacao.nat-oper-venda-fe"
                        &Frame1="fPage1"                                                  
                        &EnableImplant="NO"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttdef-nat-operacao.nat-oper-venda-fe wMaintenance
ON MOUSE-SELECT-DBLCLICK OF ttdef-nat-operacao.nat-oper-venda-fe IN FRAME fPage1 /* nat-oper-venda-fe */
DO:
     APPLY 'F5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenance 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
ttdef-nat-operacao.estado-origem:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.
ttdef-nat-operacao.cidade-destino:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.
ttdef-nat-operacao.estado-destino:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.
ttdef-nat-operacao.nat-oper-venda-de:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage1.
ttdef-nat-operacao.nat-oper-revenda-de:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage1.
ttdef-nat-operacao.nat-oper-serv-de:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage1.
ttdef-nat-operacao.class-fiscal:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.
ttdef-nat-operacao.nat-oper-venda-fe:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage1.
ttdef-nat-operacao.nat-oper-revenda-fe:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage1.
ttdef-nat-operacao.nat-oper-serv-fe:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage1.
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

    IF  AVAIL {&ttTable} THEN
        ASSIGN tg-atacado-varejo = IF {&ttTable}.ind-vendas-alc = 1 THEN YES ELSE NO.

    
    DISPLAY tg-atacado-varejo
           
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

    ASSIGN INPUT FRAME fPage0 tg-atacado-varejo.

    IF  AVAIL {&ttTable} THEN
        ASSIGN {&ttTable}.ind-vendas-alc = IF tg-atacado-varejo THEN 1 ELSE 0.

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
    
    DEFINE VARIABLE c-estado-origem         LIKE {&ttTable}.estado-origem         NO-UNDO.
    DEFINE VARIABLE l-ind-cliente-contrib   LIKE {&ttTable}.ind-cliente-contrib   NO-UNDO.
    DEFINE VARIABLE l-ind-insc-estadual-inf LIKE {&ttTable}.ind-insc-estadual-inf NO-UNDO.
    DEFINE VARIABLE l-ind-subst-tributaria  LIKE {&ttTable}.ind-subst-tributaria  NO-UNDO.
    DEFINE VARIABLE l-ind-suframa-inf       LIKE {&ttTable}.ind-suframa-inf       NO-UNDO.
    DEFINE VARIABLE c-cidade-destino        LIKE {&ttTable}.cidade-destino        NO-UNDO.
    DEFINE VARIABLE c-estado-destino        LIKE {&ttTable}.estado-destino        NO-UNDO.
    DEFINE VARIABLE c-class-fiscal          LIKE {&ttTable}.class-fiscal          NO-UNDO.
    DEFINE VARIABLE l-ind-pais-brasil       LIKE {&ttTable}.ind-pais-brasil       NO-UNDO.
    DEFINE VARIABLE l-ind-oem               LIKE {&ttTable}.ind-oem               NO-UNDO.
    DEFINE VARIABLE l-ind-consumidor-final  LIKE {&ttTable}.ind-consumidor-final  NO-UNDO.
    DEFINE VARIABLE i-ind-forma-tributo     LIKE {&ttTable}.ind-forma-tributo     NO-UNDO.
    DEFINE VARIABLE l-ind-origem-item       LIKE {&ttTable}.ind-origem-item       NO-UNDO.
    DEFINE VARIABLE l-atacado-varejo        AS LOGICAL                            NO-UNDO.
    DEFINE VARIABLE l-lei-bem               AS LOGICAL                            NO-UNDO.
    DEFINE VARIABLE l-icms-st-antec         AS LOGICAL                            NO-UNDO.
    
    DEFINE FRAME fGoToRecord
        c-estado-origem         AT ROW 1.21  COL 17.72 COLON-ALIGNED FORMAT "x(3)"
        l-ind-cliente-contrib   AT ROW 2.21  COL 17.72 COLON-ALIGNED VIEW-AS TOGGLE-BOX
        l-ind-insc-estadual-inf AT ROW 3.21  COL 17.72 COLON-ALIGNED VIEW-AS TOGGLE-BOX
        l-ind-subst-tributaria  AT ROW 4.21  COL 17.72 COLON-ALIGNED VIEW-AS TOGGLE-BOX 
        l-ind-consumidor-final  AT ROW 5.21  COL 17.72 COLON-ALIGNED VIEW-AS TOGGLE-BOX 
        l-ind-suframa-inf       AT ROW 6.21  COL 17.72 COLON-ALIGNED VIEW-AS TOGGLE-BOX 
        c-cidade-destino        AT ROW 7.21  COL 17.72 COLON-ALIGNED 
        c-estado-destino        AT ROW 8.21  COL 17.72 COLON-ALIGNED FORMAT "x(3)"
        c-class-fiscal          AT ROW 9.21  COL 17.72 COLON-ALIGNED 
        i-ind-forma-tributo     AT ROW 10.21  COL 17.72 COLON-ALIGNED LABEL "Forma Tributo"
        l-ind-pais-brasil       AT ROW 11.21 COL 17.72 COLON-ALIGNED VIEW-AS TOGGLE-BOX 
        l-ind-oem               AT ROW 12.21 COL 17.72 COLON-ALIGNED VIEW-AS TOGGLE-BOX
        l-ind-origem-item       AT ROW 13.21 COL 17.72 COLON-ALIGNED LABEL "Origem Item"
        l-atacado-varejo        AT ROW 14.21 COL 17.72 COLON-ALIGNED VIEW-AS TOGGLE-BOX LABEL "Atacado/Varejo"
        l-lei-bem               AT ROW 15.21 COL 17.72 COLON-ALIGNED VIEW-AS TOGGLE-BOX LABEL "Lei do Bem"
        l-icms-st-antec         AT ROW 16.21 COL 17.72 COLON-ALIGNED VIEW-AS TOGGLE-BOX LABEL "ICMS ST Antec"
        btGoToOK          AT ROW 17.63 COL 2.14
        btGoToCancel      AT ROW 17.63 COL 13
        rtGoToButton      AT ROW 17.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V† Para def-nat-oper" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.
    
                /*tech1139 - FO 1338.917 - 10/07/2006  */
    RUN utp/ut-trfrrp.p (input Frame fGoToRecord:Handle).
    {utp/ut-liter.i "V†_Para_def-nat-opercao"}
    ASSIGN FRAME fGoToRecord:TITLE = RETURN-VALUE.
/*tech1139 - FO 1338.917 - 10/07/2006  */

    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN c-estado-origem         
               l-ind-cliente-contrib   
               l-ind-insc-estadual-inf 
               l-ind-subst-tributaria  
               l-ind-consumidor-final
               l-ind-suframa-inf       
               i-ind-forma-tributo
               c-cidade-destino        
               c-estado-destino        
               c-class-fiscal
               l-ind-pais-brasil       
               l-ind-oem               
               l-ind-origem-item
               l-atacado-varejo
               l-lei-bem
               l-icms-st-antec.
        
        RUN goToKey IN {&hDBOTable} (INPUT c-estado-origem,         
                                     INPUT l-ind-cliente-contrib,   
                                     INPUT l-ind-insc-estadual-inf, 
                                     INPUT l-ind-subst-tributaria,  
                                     INPUT l-ind-consumidor-final,
                                     INPUT l-ind-suframa-inf,       
                                     INPUT c-cidade-destino,        
                                     INPUT c-estado-destino,      
                                     INPUT i-ind-forma-tributo,
                                     INPUT l-ind-pais-brasil,       
                                     INPUT l-ind-oem,
                                     INPUT l-ind-origem-item,
                                     INPUT IF l-atacado-varejo THEN 1 ELSE 0,
                                     INPUT l-lei-bem,
                                     INPUT l-icms-st-antec,
                                     INPUT c-class-fiscal).
        
        IF RETURN-VALUE = "NOK":U THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT "def-nat-opercao":U).
            RETURN NO-APPLY.
        END.
        
        /*:T Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOTable} (OUTPUT rGoTo).
        
        /*:T Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).

        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    ENABLE c-estado-origem         
           l-ind-cliente-contrib   
           l-ind-insc-estadual-inf 
           l-ind-subst-tributaria  
           l-ind-consumidor-final
           l-ind-suframa-inf       
           c-cidade-destino        
           c-estado-destino        
           l-ind-pais-brasil       
           i-ind-forma-tributo
           l-ind-oem               
           l-ind-origem-item
           l-atacado-varejo
           l-lei-bem
           l-icms-st-antec 
           c-class-fiscal
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
    
    /*:T--- Verifica se o DBO j† est† inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOTable}) OR
       {&hDBOTable}:TYPE <> "PROCEDURE":U OR
       {&hDBOTable}:FILE-NAME <> "esbo/boes505.p":U THEN DO:
        {btb/btb008za.i1 esbo/boes505.p YES}
        {btb/btb008za.i2 esbo/boes505.p '' {&hDBOTable}}
    END.
    
    RUN setConstraintMain IN {&hDBOTable} NO-ERROR.
    RUN openQueryStatic IN {&hDBOTable} (INPUT "Main":U) NO-ERROR.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

