&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME wMasterDetail


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-cc-equipamentos NO-UNDO LIKE cc-equipamentos
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-equipamentos NO-UNDO LIKE equipamentos
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMasterDetail 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESUTP002 1.00.00.001}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program          ESUTP002
&GLOBAL-DEFINE Version          1.00.00.001

&GLOBAL-DEFINE Folder           yes
&GLOBAL-DEFINE InitialPage      1
&GLOBAL-DEFINE FolderLabels     Equipamento,Centro Custo

&GLOBAL-DEFINE First            YES
&GLOBAL-DEFINE Prev             YES
&GLOBAL-DEFINE Next             YES
&GLOBAL-DEFINE Last             YES
&GLOBAL-DEFINE GoTo             YES
&GLOBAL-DEFINE Search           YES

&GLOBAL-DEFINE AddParent        YES
&GLOBAL-DEFINE CopyParent       YES
&GLOBAL-DEFINE UpdateParent     YES
&GLOBAL-DEFINE DeleteParent     YES

&GLOBAL-DEFINE AddSon2          YES
&GLOBAL-DEFINE CopySon2         YES
&GLOBAL-DEFINE UpdateSon2       YES
&GLOBAL-DEFINE DeleteSon2       YES

&GLOBAL-DEFINE ttParent         tt-equipamentos
&GLOBAL-DEFINE hDBOParent       h-boes407
&GLOBAL-DEFINE DBOParentTable   equipamentos
&GLOBAL-DEFINE DBOParentDestroy YES

&GLOBAL-DEFINE ttSon2           tt-cc-equipamentos
&GLOBAL-DEFINE hDBOSon2         h-boes410
&GLOBAL-DEFINE DBOSon2Table     cc-equipamentos
&GLOBAL-DEFINE DBOSon2Destroy   YES

&GLOBAL-DEFINE page0Fields      btModEstab tt-equipamentos.cod-estabel tt-equipamentos.equipamento tt-equipamentos.descricao

&GLOBAL-DEFINE page1Fields      tt-equipamentos.tipo tt-equipamentos.ct-codigo tt-equipamentos.fornecedor tt-equipamentos.val-limite ~
                                tt-equipamentos.marca tt-equipamentos.modelo tt-equipamentos.serie-equipamento tt-equipamentos.serie-acessorio ~
                                tt-equipamentos.cod_usuario fi-nome-usuario tt-equipamentos.cargo tt-equipamentos.ind-utiliz tt-equipamentos..ind-situacao~
                                tt-equipamentos.obs-situacao tt-equipamentos.ind-cobranca tt-equipamentos.cod_gestor_cobranca fi-nome-gestor

&GLOBAL-DEFINE page2Browse      brSon2
   

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) ---                        */
DEFINE VARIABLE {&hDBOParent} AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOSon2}   AS HANDLE NO-UNDO.

{upc/btb910za-upc.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MasterDetail
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fPage0
&Scoped-define BROWSE-NAME brSon2

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-cc-equipamentos

/* Definitions for BROWSE brSon2                                        */
&Scoped-define FIELDS-IN-QUERY-brSon2 tt-cc-equipamentos.cod-estabel-rateio ~
tt-cc-equipamentos.cod-unid-negoc tt-cc-equipamentos.cc-codigo ~
fn-desc-ccusto() @ v_des_titulo_ccusto tt-cc-equipamentos.per-rateio 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon2 
&Scoped-define QUERY-STRING-brSon2 FOR EACH tt-cc-equipamentos NO-LOCK
&Scoped-define OPEN-QUERY-brSon2 OPEN QUERY brSon2 FOR EACH tt-cc-equipamentos NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brSon2 tt-cc-equipamentos
&Scoped-define FIRST-TABLE-IN-QUERY-brSon2 tt-cc-equipamentos


/* Definitions for FRAME fPage2                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage2 ~
    ~{&OPEN-QUERY-brSon2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-equipamentos.cod-estabel ~
tt-equipamentos.equipamento tt-equipamentos.descricao 
&Scoped-define ENABLED-TABLES tt-equipamentos
&Scoped-define FIRST-ENABLED-TABLE tt-equipamentos
&Scoped-Define ENABLED-OBJECTS rtToolBar rtParent btFirst btPrev btNext ~
btLast btGoTo btSearch btAdd btCopy btUpdate btDelete btModEstab ~
btQueryJoins btReportsJoins btExit btHelp fi-desc-estabel 
&Scoped-Define DISPLAYED-FIELDS tt-equipamentos.cod-estabel ~
tt-equipamentos.equipamento tt-equipamentos.descricao 
&Scoped-define DISPLAYED-TABLES tt-equipamentos
&Scoped-define FIRST-DISPLAYED-TABLE tt-equipamentos
&Scoped-Define DISPLAYED-OBJECTS fi-desc-estabel 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-desc-ccusto wMasterDetail 
FUNCTION fn-desc-ccusto RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wMasterDetail AS WIDGET-HANDLE NO-UNDO.

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

DEFINE BUTTON btModEstab 
     IMAGE-UP FILE "image/im-modbm.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-modbm.bmp":U
     LABEL "Modifica Estabel" 
     SIZE 4 BY 1.25 TOOLTIP "Modifica Estabelecimento do Equipamento"
     FONT 4.

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

DEFINE BUTTON btUpdate 
     IMAGE-UP FILE "image\im-mod":U
     IMAGE-INSENSITIVE FILE "image\ii-mod":U
     LABEL "Update" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE VARIABLE fi-desc-estabel AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 58.14 BY .88 NO-UNDO.

DEFINE RECTANGLE rtParent
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 2.33.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE VARIABLE fi-desc-conta AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 51 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-tipo AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 56.86 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nome-fornec AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 56.86 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nome-gestor AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 55.43 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nome-usuario AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 55.43 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 81 BY 3.29.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 81 BY 6.54.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 81 BY 2.29.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 81 BY 2.42.

DEFINE VARIABLE tg-desc-integral AS LOGICAL INITIAL no 
     LABEL "Desconta Integral" 
     VIEW-AS TOGGLE-BOX
     SIZE 17 BY .83 TOOLTIP "Descontar o valor integral da conta na folha de pagamento" NO-UNDO.

DEFINE BUTTON btAddSon2 
     LABEL "Incluir" 
     SIZE 10 BY 1.

DEFINE BUTTON btCopySon2 
     LABEL "Copiar" 
     SIZE 10 BY 1.

DEFINE BUTTON btDeleteSon2 
     LABEL "Eliminar" 
     SIZE 10 BY 1.

DEFINE BUTTON btUpdateSon2 
     LABEL "Alterar" 
     SIZE 10 BY 1.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brSon2 FOR 
      tt-cc-equipamentos SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brSon2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon2 wMasterDetail _STRUCTURED
  QUERY brSon2 NO-LOCK DISPLAY
      tt-cc-equipamentos.cod-estabel-rateio FORMAT "x(5)":U
      tt-cc-equipamentos.cod-unid-negoc FORMAT "x(3)":U
      tt-cc-equipamentos.cc-codigo FORMAT "x(8)":U
      fn-desc-ccusto() @ v_des_titulo_ccusto COLUMN-LABEL "Descriá∆o" FORMAT "x(30)":U
            WIDTH 20
      tt-cc-equipamentos.per-rateio FORMAT ">>9.9999":U WIDTH 11.72
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 9.13
         FONT 2.


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
     btModEstab AT ROW 1.13 COL 56.86 HELP
          "Elimina ocorrància corrente" WIDGET-ID 28
     btQueryJoins AT ROW 1.13 COL 74.86 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.86 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.86 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.86 HELP
          "Ajuda"
     tt-equipamentos.cod-estabel AT ROW 2.92 COL 18 COLON-ALIGNED WIDGET-ID 24
          LABEL "Estabelecimento"
          VIEW-AS FILL-IN 
          SIZE 4.72 BY .88
     fi-desc-estabel AT ROW 2.92 COL 22.86 COLON-ALIGNED NO-LABEL WIDGET-ID 22
     tt-equipamentos.equipamento AT ROW 3.92 COL 10.28 WIDGET-ID 26
          VIEW-AS FILL-IN 
          SIZE 22.57 BY .88
     tt-equipamentos.descricao AT ROW 3.92 COL 40.86 COLON-ALIGNED NO-LABEL WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 40.14 BY .88
     rtToolBar AT ROW 1 COL 1
     rtParent AT ROW 2.67 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 22
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage2
     brSon2 AT ROW 1.17 COL 2
     btAddSon2 AT ROW 10.33 COL 2
     btCopySon2 AT ROW 10.33 COL 12
     btUpdateSon2 AT ROW 10.33 COL 22
     btDeleteSon2 AT ROW 10.33 COL 32
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 6.08
         SIZE 84.43 BY 16.42
         FONT 1 WIDGET-ID 200.

DEFINE FRAME fPage1
     fi-nome-gestor AT ROW 15.96 COL 22.57 COLON-ALIGNED NO-LABEL WIDGET-ID 120
     tt-equipamentos.ind-cobranca AT ROW 15.08 COL 17.29 NO-LABEL WIDGET-ID 116
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Nenhum", 0,
"Tarifador", 1,
"Excel", 2
          SIZE 24.72 BY .79
     tt-equipamentos.ind-situacao AT ROW 8.17 COL 17 NO-LABEL WIDGET-ID 108
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Ativo", 0,
"Bloqueado", 1,
"Cancelado", 2
          SIZE 31 BY .71
     tt-equipamentos.ind-utiliz AT ROW 5.33 COL 17 NO-LABEL WIDGET-ID 104
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Ambos", 0,
"Celular", 1,
"Chip", 2
          SIZE 29 BY .79
     tt-equipamentos.obs-situacao AT ROW 8.88 COL 17 NO-LABEL WIDGET-ID 86
          VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
          SIZE 63 BY 2.54
     tt-equipamentos.ct-codigo AT ROW 2.58 COL 14.86 COLON-ALIGNED WIDGET-ID 26
          VIEW-AS FILL-IN 
          SIZE 11.86 BY .88
     fi-desc-conta AT ROW 2.58 COL 27 COLON-ALIGNED NO-LABEL WIDGET-ID 28
     tt-equipamentos.marca AT ROW 6.17 COL 14.86 COLON-ALIGNED WIDGET-ID 38
          VIEW-AS FILL-IN 
          SIZE 23.14 BY .88
     tt-equipamentos.modelo AT ROW 6.13 COL 51 COLON-ALIGNED WIDGET-ID 40
          VIEW-AS FILL-IN 
          SIZE 27 BY .88
     tt-equipamentos.serie-equipamento AT ROW 7.13 COL 16.29 COLON-ALIGNED WIDGET-ID 62
          VIEW-AS FILL-IN 
          SIZE 23 BY .88
     tt-equipamentos.serie-acessorio AT ROW 7.08 COL 51 COLON-ALIGNED WIDGET-ID 60
          VIEW-AS FILL-IN 
          SIZE 27 BY .88
     tt-equipamentos.val-limite AT ROW 14.96 COL 53 COLON-ALIGNED WIDGET-ID 24
          VIEW-AS FILL-IN 
          SIZE 9 BY .88
     tt-equipamentos.cargo AT ROW 13.21 COL 15 COLON-ALIGNED WIDGET-ID 64
          VIEW-AS FILL-IN 
          SIZE 63 BY .88
     fi-nome-usuario AT ROW 12.25 COL 22.57 COLON-ALIGNED NO-LABEL WIDGET-ID 122
     tt-equipamentos.tipo AT ROW 1.63 COL 15 COLON-ALIGNED WIDGET-ID 128
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     fi-nome-fornec AT ROW 3.58 COL 21.14 COLON-ALIGNED NO-LABEL WIDGET-ID 126
     fi-desc-tipo AT ROW 1.63 COL 21.14 COLON-ALIGNED NO-LABEL WIDGET-ID 130
     tt-equipamentos.fornecedor AT ROW 3.58 COL 15 COLON-ALIGNED WIDGET-ID 132
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     tg-desc-integral AT ROW 15 COL 65 WIDGET-ID 158
     tt-equipamentos.cod_usuario AT ROW 12.25 COL 15 COLON-ALIGNED WIDGET-ID 160
          LABEL "Matr°cula"
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     tt-equipamentos.cod_gestor_cobranca AT ROW 15.96 COL 14 COLON-ALIGNED WIDGET-ID 162
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .88
     "Tipo Cobranáa:" VIEW-AS TEXT
          SIZE 10.86 BY .54 AT ROW 15.17 COL 6.43 WIDGET-ID 124
     "Dados:" VIEW-AS TEXT
          SIZE 5 BY .54 AT ROW 1.08 COL 4.43 WIDGET-ID 80
     "Celular:" VIEW-AS TEXT
          SIZE 5 BY .54 AT ROW 4.75 COL 4.43 WIDGET-ID 84
     "Observaá‰es:" VIEW-AS TEXT
          SIZE 10 BY .54 AT ROW 9.5 COL 7 WIDGET-ID 88
     "Usu†rio:" VIEW-AS TEXT
          SIZE 6.29 BY .54 AT ROW 11.71 COL 4.72 WIDGET-ID 94
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 6.08
         SIZE 84.43 BY 16.42
         FONT 1 WIDGET-ID 300.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME fPage1
     "Tarifador:" VIEW-AS TEXT
          SIZE 7.29 BY .54 AT ROW 14.38 COL 4.72 WIDGET-ID 98
     "Utilizaá∆o:" VIEW-AS TEXT
          SIZE 7.29 BY .54 AT ROW 5.42 COL 9.72 WIDGET-ID 112
     "Situaá∆o:" VIEW-AS TEXT
          SIZE 6.86 BY .54 AT ROW 8.21 COL 9.86 WIDGET-ID 114
     RECT-1 AT ROW 1.38 COL 2.43 WIDGET-ID 78
     RECT-2 AT ROW 5.08 COL 2.43 WIDGET-ID 82
     RECT-4 AT ROW 12 COL 2.57 WIDGET-ID 92
     RECT-5 AT ROW 14.71 COL 2.57 WIDGET-ID 96
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 6.08
         SIZE 84.43 BY 16.42
         FONT 1 WIDGET-ID 300.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MasterDetail
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: tt-cc-equipamentos T "?" NO-UNDO mgesp cc-equipamentos
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-equipamentos T "?" NO-UNDO mgesp equipamentos
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wMasterDetail ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 22
         WIDTH              = 90
         MAX-HEIGHT         = 22
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 22
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wMasterDetail 
/* ************************* Included-Libraries *********************** */

{masterdetail/masterdetail.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wMasterDetail
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fPage0:HANDLE
       FRAME fPage2:FRAME = FRAME fPage0:HANDLE.

/* SETTINGS FOR FRAME fPage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN tt-equipamentos.cod-estabel IN FRAME fPage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-equipamentos.equipamento IN FRAME fPage0
   ALIGN-L                                                              */
/* SETTINGS FOR FRAME fPage1
   Custom                                                               */
/* SETTINGS FOR FILL-IN tt-equipamentos.cod_usuario IN FRAME fPage1
   EXP-LABEL                                                            */
ASSIGN 
       tt-equipamentos.obs-situacao:READ-ONLY IN FRAME fPage1        = TRUE.

/* SETTINGS FOR FRAME fPage2
                                                                        */
/* BROWSE-TAB brSon2 1 fPage2 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMasterDetail)
THEN wMasterDetail:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon2
/* Query rebuild information for BROWSE brSon2
     _TblList          = "Temp-Tables.tt-cc-equipamentos"
     _Options          = "NO-LOCK"
     _TblOptList       = ", FIRST OUTER"
     _FldNameList[1]   = Temp-Tables.tt-cc-equipamentos.cod-estabel-rateio
     _FldNameList[2]   = Temp-Tables.tt-cc-equipamentos.cod-unid-negoc
     _FldNameList[3]   = Temp-Tables.tt-cc-equipamentos.cc-codigo
     _FldNameList[4]   > "_<CALC>"
"fn-desc-ccusto() @ v_des_titulo_ccusto" "Descriá∆o" "x(30)" ? ? ? ? ? ? ? no ? no no "20" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.tt-cc-equipamentos.per-rateio
"per-rateio" ? ? "decimal" ? ? ? ? ? ? no ? no no "11.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE brSon2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage0
/* Query rebuild information for FRAME fPage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage0 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage1
/* Query rebuild information for FRAME fPage1
     _Query            is NOT OPENED
*/  /* FRAME fPage1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage2
/* Query rebuild information for FRAME fPage2
     _Query            is NOT OPENED
*/  /* FRAME fPage2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wMasterDetail
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMasterDetail wMasterDetail
ON END-ERROR OF wMasterDetail
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMasterDetail wMasterDetail
ON WINDOW-CLOSE OF wMasterDetail
DO:
  /* This event will close the window and terminate the procedure.  */
  IF  VALID-HANDLE(h_api_ccusto)
  THEN
      delete object h_api_ccusto.

  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btAdd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAdd wMasterDetail
ON CHOOSE OF btAdd IN FRAME fPage0 /* Add */
OR CHOOSE OF MENU-ITEM miAdd IN MENU mbMain DO:
    RUN addRecord IN THIS-PROCEDURE (INPUT "esp/utp/esutp002a.w":U). 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btAddSon2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddSon2 wMasterDetail
ON CHOOSE OF btAddSon2 IN FRAME fPage2 /* Incluir */
DO:
    {masterdetail/addson.i &ProgramSon="esp/utp/esutp002c.w"
                           &PageNumber="2"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME btCopy
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCopy wMasterDetail
ON CHOOSE OF btCopy IN FRAME fPage0 /* Copy */
OR CHOOSE OF MENU-ITEM miCopy IN MENU mbMain DO:
    RUN copyRecord (INPUT "esp/utp/esutp002a.w":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btCopySon2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCopySon2 wMasterDetail
ON CHOOSE OF btCopySon2 IN FRAME fPage2 /* Copiar */
DO:
    {masterdetail/copyson.i &ProgramSon="esp/utp/esutp002c.w"
                            &PageNumber="2"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME btDelete
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDelete wMasterDetail
ON CHOOSE OF btDelete IN FRAME fPage0 /* Delete */
OR CHOOSE OF MENU-ITEM miDelete IN MENU mbMain DO:
    RUN deleteRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btDeleteSon2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDeleteSon2 wMasterDetail
ON CHOOSE OF btDeleteSon2 IN FRAME fPage2 /* Eliminar */
DO:
    {masterdetail/deleteson.i &PageNumber="2"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wMasterDetail
ON CHOOSE OF btExit IN FRAME fPage0 /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btFirst
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFirst wMasterDetail
ON CHOOSE OF btFirst IN FRAME fPage0 /* First */
OR CHOOSE OF MENU-ITEM miFirst IN MENU mbMain DO:
    RUN getFirst IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btGoTo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btGoTo wMasterDetail
ON CHOOSE OF btGoTo IN FRAME fPage0 /* Go To */
OR CHOOSE OF MENU-ITEM miGoTo IN MENU mbMain DO:
    RUN goToRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wMasterDetail
ON CHOOSE OF btHelp IN FRAME fPage0 /* Help */
OR CHOOSE OF MENU-ITEM miContents IN MENU mbMain DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btLast
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btLast wMasterDetail
ON CHOOSE OF btLast IN FRAME fPage0 /* Last */
OR CHOOSE OF MENU-ITEM miLast IN MENU mbMain DO:
    RUN getLast IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btModEstab
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btModEstab wMasterDetail
ON CHOOSE OF btModEstab IN FRAME fPage0 /* Modifica Estabel */
DO:
    IF AVAIL tt-equipamentos THEN
        RUN pi-troca-estab IN THIS-PROCEDURE(tt-equipamentos.r-rowid).
    ELSE 
        MESSAGE "Selecione o equipamento antes de fazer alteraá∆o!"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btNext
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btNext wMasterDetail
ON CHOOSE OF btNext IN FRAME fPage0 /* Next */
OR CHOOSE OF MENU-ITEM miNext IN MENU mbMain DO:
    RUN getNext IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btPrev
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btPrev wMasterDetail
ON CHOOSE OF btPrev IN FRAME fPage0 /* Prev */
OR CHOOSE OF MENU-ITEM miPrev IN MENU mbMain DO:
    RUN getPrev IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btQueryJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btQueryJoins wMasterDetail
ON CHOOSE OF btQueryJoins IN FRAME fPage0 /* Query Joins */
OR CHOOSE OF MENU-ITEM miQueryJoins IN MENU mbMain DO:
    RUN showQueryJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btReportsJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReportsJoins wMasterDetail
ON CHOOSE OF btReportsJoins IN FRAME fPage0 /* Reports Joins */
OR CHOOSE OF MENU-ITEM miReportsJoins IN MENU mbMain DO:
    RUN showReportsJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSearch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSearch wMasterDetail
ON CHOOSE OF btSearch IN FRAME fPage0 /* Search */
OR CHOOSE OF MENU-ITEM miSearch IN MENU mbMain DO:
    {method/zoomreposition.i &ProgramZoom="eszoom/z01es407.w"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btUpdate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdate wMasterDetail
ON CHOOSE OF btUpdate IN FRAME fPage0 /* Update */
OR CHOOSE OF MENU-ITEM miUpdate IN MENU mbMain DO:
    RUN updateRecord IN THIS-PROCEDURE (INPUT "esp/utp/esutp002a.w":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btUpdateSon2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdateSon2 wMasterDetail
ON CHOOSE OF btUpdateSon2 IN FRAME fPage2 /* Alterar */
DO:
    {masterdetail/updateson.i &ProgramSon="esp/utp/esutp002c.w"
                              &PageNumber="2"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME tt-equipamentos.cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-equipamentos.cod-estabel wMasterDetail
ON LEAVE OF tt-equipamentos.cod-estabel IN FRAME fPage0 /* Estabelecimento */
DO:

    assign input frame fPage0 tt-equipamentos.cod-estabel.

    {include/leave.i &tabela=estabelec
                    &atributo-ref=nome
                    &variavel-ref=fi-desc-estabel
                    &where="estabelec.cod-estabel = tt-equipamentos.cod-estabel"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME tt-equipamentos.cod_gestor_cobranca
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-equipamentos.cod_gestor_cobranca wMasterDetail
ON LEAVE OF tt-equipamentos.cod_gestor_cobranca IN FRAME fPage1 /* Gestor Cobranáa */
DO:
    ASSIGN INPUT FRAME fPage1 tt-equipamentos.cod_gestor_cobranca.

    IF tt-equipamentos.cod_gestor_cobranca <> "" THEN DO:
        FIND FIRST usuar_mestre NO-LOCK
             WHERE usuar_mestre.cod_usuario = tt-equipamentos.cod_gestor_cobranca NO-ERROR.
        IF AVAIL usuar_mestre THEN DO:
            ASSIGN fi-nome-gestor:SCREEN-VALUE IN FRAME fPage1= usuar_mestre.nom_usuario.
        END.
        ELSE DO:
            ASSIGN fi-nome-gestor:SCREEN-VALUE IN FRAME fPage1= "".
        END.
    END.
    ELSE ASSIGN fi-nome-gestor:SCREEN-VALUE IN FRAME fPage1= "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-equipamentos.cod_usuario
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-equipamentos.cod_usuario wMasterDetail
ON LEAVE OF tt-equipamentos.cod_usuario IN FRAME fPage1 /* Matr°cula */
DO:
   assign input frame fPage1 tt-equipamentos.cod_usuario.

    IF tt-equipamentos.cod_usuario <> "" THEN DO:
        FIND FIRST usuar_mestre NO-LOCK
             WHERE usuar_mestre.cod_usuario = tt-equipamentos.cod_usuario NO-ERROR.
        IF AVAIL usuar_mestre THEN DO:
            ASSIGN fi-nome-usuario:SCREEN-VALUE IN FRAME fPage1= usuar_mestre.nom_usuario.
        END.
        ELSE DO:
            ASSIGN fi-nome-usuario:SCREEN-VALUE IN FRAME fPage1= "".
        END.
    END.
    ELSE ASSIGN fi-nome-usuario:SCREEN-VALUE IN FRAME fPage1= "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-equipamentos.ct-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-equipamentos.ct-codigo wMasterDetail
ON LEAVE OF tt-equipamentos.ct-codigo IN FRAME fPage1 /* Conta */
DO:
    ASSIGN INPUT FRAME fPage1 tt-equipamentos.ct-codigo.

    run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.
    EMPTY TEMP-TABLE tt_log_erro.

    ASSIGN v_cod_conta = tt-equipamentos.ct-codigo.

    run pi_busca_dados_cta_ctbl in h_api_cta_ctbl
                                            (input        i-ep-codigo-usuario,      /* EMPRESA EMS2 */
                                             input        "",                       /* PLANO DE CONTAS */
                                             input-output v_cod_conta,              /* CONTA */
                                             input        TODAY,                    /* DATA TRANSACAO */   
                                             output       v_des_titulo_conta,       /* DESCRICAO CONTA */
                                             output       v_num_tip_cta_ctbl,       /* TIPO DA CONTA */
                                             output       v_num_sit_cta_ctbl,       /* SITUAÄ«O DA CONTA */
                                             output       v_ind_finalid_cta,        /* FINALIDADES DA CONTA */
                                             output table tt_log_erro). 
    if valid-handle(h_api_cta_ctbl) 
    then
        delete object h_api_cta_ctbl.

    DISP v_des_titulo_conta @ fi-desc-conta WITH FRAME fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-equipamentos.fornecedor
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-equipamentos.fornecedor wMasterDetail
ON LEAVE OF tt-equipamentos.fornecedor IN FRAME fPage1 /* Fornecedor */
DO:
    assign input frame fPage1 tt-equipamentos.fornecedor.

    {include/leave.i &tabela=fornec-equipamentos
                    &atributo-ref=nome
                    &variavel-ref=fi-nome-fornec
                    &where="fornec-equipamentos.fornecedor = tt-equipamentos.fornecedor"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-equipamentos.tipo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-equipamentos.tipo wMasterDetail
ON LEAVE OF tt-equipamentos.tipo IN FRAME fPage1 /* Tipo */
DO:
    assign input frame fPage1 tt-equipamentos.tipo.

    {include/leave.i &tabela=tipo-equipamentos
                    &atributo-ref=descricao
                    &variavel-ref=fi-desc-tipo
                    &where="tipo-equipamentos.codigo = tt-equipamentos.tipo"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define BROWSE-NAME brSon2
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMasterDetail 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{masterdetail/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wMasterDetail 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF AVAIL tt-equipamentos THEN DO:
        ENABLE btModEstab WITH FRAME fPage0.
        ENABLE tt-equipamentos.obs-situacao WITH FRAME fPage1.

        ASSIGN tg-desc-integral = tt-equipamentos.log-desconta-integral.

        DISP tt-equipamentos.tipo
             tt-equipamentos.ct-codigo
             tt-equipamentos.fornecedor
             tt-equipamentos.marca
             tt-equipamentos.modelo
             tt-equipamentos.serie-equipamento
             tt-equipamentos.serie-acessorio
             tt-equipamentos.val-limite
             tt-equipamentos.ind-utiliz 
             tt-equipamentos.ind-situacao
             tt-equipamentos.obs-situacao
             tt-equipamentos.cod_usuario
             tt-equipamentos.cargo
             tt-equipamentos.ind-cobranca
             tt-equipamentos.cod_gestor_cobranca
             tg-desc-integral
             WITH FRAME fPage1.

        apply 'leave' to tt-equipamentos.cod-estabel in frame fPage0.
        APPLY "leave" TO tt-equipamentos.tipo  IN FRAME fPage1.
        APPLY "leave" TO tt-equipamentos.ct-codigo   IN FRAME fPage1.
        APPLY "leave" TO tt-equipamentos.fornecedor  IN FRAME fPage1.
        APPLY "leave" TO tt-equipamentos.cod_usuario  IN FRAME fPage1.
        APPLY "leave" TO tt-equipamentos.cod_gestor_cobranca  IN FRAME fPage1.
    END.
        
    ELSE DO:
         DISABLE btModEstab WITH FRAME fPage0.
         DISABLE tt-equipamentos.obs-situacao WITH FRAME fPage1.

         ASSIGN fi-desc-estabel:SCREEN-VALUE IN FRAME fPage0                   = ""
                tt-equipamentos.tipo:SCREEN-VALUE IN FRAME fPage1              = "0"
                fi-desc-tipo:SCREEN-VALUE IN FRAME fPage1                      = ""
                tt-equipamentos.ct-codigo:SCREEN-VALUE IN FRAME fPage1         = ""
                fi-desc-conta:SCREEN-VALUE IN FRAME fPage1                     = ""
                tt-equipamentos.val-limite:SCREEN-VALUE IN FRAME fPage1        = "0,00"
                tt-equipamentos.fornecedor:SCREEN-VALUE IN FRAME fPage1        = ""
                fi-nome-fornec:SCREEN-VALUE IN FRAME fPage1                    = ""
                tt-equipamentos.marca:SCREEN-VALUE IN FRAME fPage1             = ""
                tt-equipamentos.modelo:SCREEN-VALUE IN FRAME fPage1            = ""
                tt-equipamentos.serie-equipamento:SCREEN-VALUE IN FRAME fPage1 = ""
                tt-equipamentos.serie-acessorio:SCREEN-VALUE IN FRAME fPage1   = ""
                tt-equipamentos.ind-utiliz:SCREEN-VALUE IN FRAME fPage1        = "0" 
                tt-equipamentos.ind-situacao:SCREEN-VALUE IN FRAME fPage1      = "0"
                tt-equipamentos.obs-situacao:SCREEN-VALUE IN FRAME fPage1      = ""
                tt-equipamentos.cod_usuario:SCREEN-VALUE IN FRAME fPage1       = "0"
                fi-nome-usuario:SCREEN-VALUE IN FRAME fPage1                   = ""
                tt-equipamentos.cargo:SCREEN-VALUE IN FRAME fPage1             = ""
                tt-equipamentos.ind-cobranca:SCREEN-VALUE IN FRAME fPage1      = "0"
                tt-equipamentos.cod_gestor_cobranca:SCREEN-VALUE IN FRAME fPage1   = "0"
                fi-nome-gestor:SCREEN-VALUE IN FRAME fPage1                    = "".

         DISABLE btModEstab WITH FRAME fPage0.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToRecord wMasterDetail 
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
    
    DEFINE VARIABLE c-cod-estabel LIKE {&ttParent}.cod-estabel NO-UNDO.
    DEFINE VARIABLE c-equipamento LIKE {&ttParent}.equipamento NO-UNDO.
    
    DEFINE FRAME fGoToRecord
        c-cod-estabel     AT ROW 1.21 COL 17.72 COLON-ALIGNED VIEW-AS FILL-IN SIZE 4  BY .88
        c-equipamento     AT ROW 2.21 COL 17.72 COLON-ALIGNED VIEW-AS FILL-IN SIZE 20 BY .88
        btGoToOK          AT ROW 3.63 COL 2.14
        btGoToCancel      AT ROW 3.63 COL 13
        rtGoToButton      AT ROW 3.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V† Para Equipamentos" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.
    
/*tech1139 - FO 1338.917 - 10/07/2006  */
    RUN utp/ut-trfrrp.p (input Frame fGoToRecord:Handle).
    {utp/ut-liter.i "V†_Para_Equipamentos"}
    ASSIGN FRAME fGoToRecord:TITLE = RETURN-VALUE.
/*tech1139 - FO 1338.917 - 10/07/2006  */

    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN c-cod-estabel c-equipamento.
        
        RUN goToKey IN {&hDBOParent} (INPUT c-cod-estabel , INPUT c-equipamento).
        IF RETURN-VALUE = "NOK":U THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT "equipamentos":U).
            
            RETURN NO-APPLY.
        END.
        
        /*:T Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOParent} (OUTPUT rGoTo).
        
        /*:T Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).

        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    ENABLE c-cod-estabel c-equipamento btGoToOK btGoToCancel 
        WITH FRAME fGoToRecord. 
    
    WAIT-FOR "GO":U OF FRAME fGoToRecord.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wMasterDetail 
PROCEDURE initializeDBOs :
/*:T------------------------------------------------------------------------------
  Purpose:     Inicializa DBOs
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    
    /*:T--- Verifica se o DBO j† est† inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOParent}) OR
       {&hDBOParent}:TYPE <> "PROCEDURE":U OR
       {&hDBOParent}:FILE-NAME <> "esbo/boes407.p":U THEN DO:
        {btb/btb008za.i1 esbo/boes407.p YES}
        {btb/btb008za.i2 esbo/boes407.p '' {&hDBOParent}} 
    END.
    
/*    RUN setConstraintMain IN {&hDBOParent}  NO-ERROR.*/
    RUN openQueryStatic IN {&hDBOParent} (INPUT "Main":U) NO-ERROR.
    
    /*:T--- Verifica se o DBO j† est† inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOSon2}) OR 
       {&hDBOSon2}:TYPE <> "PROCEDURE":U OR
       {&hDBOSon2}:FILE-NAME <> "esbo/boes410.p":U THEN DO:
        {btb/btb008za.i1 esbo/boes410.p YES}
        {btb/btb008za.i2 esbo/boes410.p '' {&hDBOSon2}} 
    END.

    run prgint\utb\utb742za.py persistent set h_api_ccusto.
        
    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueriesSon wMasterDetail 
PROCEDURE openQueriesSon :
/*:T------------------------------------------------------------------------------
  Purpose:     Atualiza browsers filhos
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

    {masterdetail/openqueriesson.i &Parent="Equipamentos"
                                   &Query="CcEquipamentos"
                                   &PageNumber="2"}

    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-troca-estab wMasterDetail 
PROCEDURE pi-troca-estab :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER r-rowid-equip    AS ROWID     NO-UNDO.

    DEFINE BUTTON btAlterCancel AUTO-END-KEY 
         LABEL "&Cancelar" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE BUTTON btAlterOK AUTO-GO 
         LABEL "&OK" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE RECTANGLE rtAlterButton
         EDGE-PIXELS 2 GRAPHIC-EDGE  
         SIZE 58 BY 1.42
         BGCOLOR 7.
    
    DEFINE VARIABLE c-para-estabel LIKE {&ttParent}.cod-estabel NO-UNDO.
    
    DEFINE FRAME fAlterRecord
        c-para-estabel LABEL "Novo Estab"  AT ROW 2.21 COL 17.72 COLON-ALIGNED VIEW-AS FILL-IN SIZE 4  BY .88
        btAlterOK                    AT ROW 3.63 COL 2.14
        btAlterCancel                AT ROW 3.63 COL 13
        rtAlterButton                AT ROW 3.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V† Para Equipamentos" FONT 1
             DEFAULT-BUTTON btAlterOK CANCEL-BUTTON btAlterCancel.
    
/*tech1139 - FO 1338.917 - 10/07/2006  */
    RUN utp/ut-trfrrp.p (input Frame fAlterRecord:Handle).
    {utp/ut-liter.i "Troca Estabelecimento"}
    ASSIGN FRAME fAlterRecord:TITLE = RETURN-VALUE.
/*tech1139 - FO 1338.917 - 10/07/2006  */

    ON "CHOOSE":U OF btAlterOK IN FRAME fAlterRecord DO:
        DEFINE BUFFER b-equipamentos FOR equipamentos.

        ASSIGN c-para-estabel.
    
        FIND FIRST estabelec NO-LOCK
             WHERE estabelec.cod-estabel = c-para-estabel NO-ERROR.
        IF NOT AVAIL estabelec THEN DO:
            MESSAGE "Estabelecimento informado n∆o est† cadastrado!"
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
            RETURN NO-APPLY.
        END.
    
        FIND FIRST b-equipamentos NO-LOCK
             WHERE ROWID(b-equipamentos) = r-rowid-equip NO-ERROR.
        IF NOT AVAIL b-equipamentos THEN DO:
            MESSAGE "Equipamento n∆o pode ser alterado, favor sair do programa e tentar novamente!"
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
            RETURN NO-APPLY.
        END.
    
        FIND FIRST equipamentos NO-LOCK
             WHERE equipamentos.cod-estabel = c-para-estabel
               AND equipamentos.equipamento = b-equipamentos.equipamento NO-ERROR.
        IF AVAIL equipamentos THEN DO:
            MESSAGE "Esse equipamento j† existe com esse estabelecimento informado. Alteraá∆o n∆o permitida!"
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
            RETURN NO-APPLY.
        END.
    
        FIND FIRST cc-equipamentos NO-LOCK
             WHERE cc-equipamentos.cod-estabel = c-para-estabel
               AND cc-equipamentos.equipamento = b-equipamentos.equipamento NO-ERROR.
        IF AVAIL cc-equipamentos THEN DO:
            MESSAGE "J† existe centro de custo cadastrado com esse equipamento e estabelecimento. Alteraá∆o n∆o permitida"
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
            RETURN NO-APPLY.
        END.
    
        FOR EACH cc-equipamentos EXCLUSIVE-LOCK
           WHERE cc-equipamentos.cod-estabel = b-equipamentos.cod-estabel
             AND cc-equipamentos.equipamento = b-equipamentos.equipamento:
            ASSIGN cc-equipamentos.cod-estabel = c-para-estabel.
        END.
    
        FOR FIRST equipamentos EXCLUSIVE-LOCK
            WHERE equipamentos.cod-estabel = b-equipamentos.cod-estabel
              AND equipamentos.equipamento = b-equipamentos.equipamento:
            ASSIGN equipamentos.cod-estabel = c-para-estabel.
        END.       

        /*:T Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT r-rowid-equip).

        APPLY "GO":U TO FRAME fAlterRecord.
    END.
    
    ENABLE c-para-estabel btAlterOK btAlterCancel 
        WITH FRAME fAlterRecord. 
    
    WAIT-FOR "GO":U OF FRAME fAlterRecord.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-desc-ccusto wMasterDetail 
FUNCTION fn-desc-ccusto RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    EMPTY TEMP-TABLE tt_log_erro.
    run pi_busca_dados_ccusto in h_api_ccusto (input  i-ep-codigo-usuario,           /* EMPRESA EMS2 */
                                               input  "",                            /* CODIGO DO PLANO CCUSTO */
                                               input  tt-cc-equipamentos.cc-codigo,  /* CCUSTO */
                                               input  today,                         /* DATA DE TRANSACAO */
                                               output v_des_titulo_ccusto,           /* DESCRICAO DO CCUSTO */
                                               output table tt_log_erro).            /* ERROS */

  RETURN v_des_titulo_ccusto.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

