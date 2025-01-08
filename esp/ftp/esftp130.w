&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp            PROGRESS
*/
&Scoped-define WINDOW-NAME wMasterDetail


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-int-recorrencia-contratos NO-UNDO LIKE int-recorrencia-contratos
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-int-recorrencia-historico NO-UNDO LIKE int-recorrencia-historico
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-int-recorrencia-notas NO-UNDO LIKE int-recorrencia-notas
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMasterDetail 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESFTP130 2.00.00.000}

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program          ESFTP130
&GLOBAL-DEFINE Version          2.00.00.000

&GLOBAL-DEFINE Folder           YES
&GLOBAL-DEFINE InitialPage      1
&GLOBAL-DEFINE FolderLabels     Notas,Historico

&GLOBAL-DEFINE First            YES
&GLOBAL-DEFINE Prev             YES
&GLOBAL-DEFINE Next             YES
&GLOBAL-DEFINE Last             YES
&GLOBAL-DEFINE GoTo             YES
&GLOBAL-DEFINE Search           YES

&GLOBAL-DEFINE AddParent        NO
&GLOBAL-DEFINE CopyParent       NO
&GLOBAL-DEFINE UpdateParent     NO
&GLOBAL-DEFINE DeleteParent     NO

&GLOBAL-DEFINE AddSon1          NO
&GLOBAL-DEFINE CopySon1         NO
&GLOBAL-DEFINE UpdateSon1       NO
&GLOBAL-DEFINE DeleteSon1       NO

&GLOBAL-DEFINE AddSon2          NO
&GLOBAL-DEFINE CopySon2         NO
&GLOBAL-DEFINE UpdateSon2       NO
&GLOBAL-DEFINE DeleteSon2       NO

&GLOBAL-DEFINE ttParent         tt-int-recorrencia-contratos
&GLOBAL-DEFINE hDBOParent       hint-recorrencia-contratos
&GLOBAL-DEFINE DBOParentTable   int-recorrencia-contratos
&GLOBAL-DEFINE DBOParentDestroy YES

&GLOBAL-DEFINE ttSon1           tt-int-recorrencia-notas
&GLOBAL-DEFINE hDBOSon1         hint-recorrencia-notas
&GLOBAL-DEFINE DBOSon1Table     int-recorrencia-notas
&GLOBAL-DEFINE DBOSon1Destroy   YES

&GLOBAL-DEFINE ttSon2           tt-int-recorrencia-historico
&GLOBAL-DEFINE hDBOSon2         hint-recorrencia-historico
&GLOBAL-DEFINE DBOSon2Table     int-recorrencia-historico
&GLOBAL-DEFINE DBOSon2Destroy   YES

&GLOBAL-DEFINE page0Fields      tt-int-recorrencia-contratos.id-recorrencia ~
tt-int-recorrencia-contratos.nr-contrato ~
tt-int-recorrencia-contratos.nr-parcela ~
tt-int-recorrencia-contratos.nr-transacao ~
tt-int-recorrencia-contratos.cod-emitente ~
tt-int-recorrencia-contratos.valor ~
tt-int-recorrencia-contratos.cod-sit-trans ~
tt-int-recorrencia-contratos.dt-venc 

&GLOBAL-DEFINE page1Browse      brSon1
&GLOBAL-DEFINE page2Browse      brSon2


/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) ---                        */
DEFINE VARIABLE {&hDBOParent} AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOSon1}   AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOSon2}   AS HANDLE NO-UNDO.

{esp/pdp/espdp006.i}
{btb/btb912zb.i}

define temp-table tt-param no-undo
    field destino       as integer
    field arquivo       as char format "x(35)"
    field usuario       as char format "x(12)"
    field data-exec     as date
    field hora-exec     as integer
    field nome-abrev    LIKE ped-venda.nome-abrev
    field nr-pedcli     LIKE ped-venda.nr-pedcli    
    field Cod-depos     LIKE deposito.cod-depos
    field Localizacao   LIKE saldo-estoq.cod-localiz 
    .

define temp-table tt-digita NO-UNDO
    field nome-abrev     LIKE ped-venda.nome-abrev
    field nr-pedcli      LIKE ped-venda.nr-pedcli 
    field c-it-codigo    LIKE ped-item.it-codigo
    field c-cod-refer    LIKE ped-item.cod-refer
    field i-nr-sequencia LIKE ped-item.nr-sequencia
    .

define temp-table tt-raw-digita
    field raw-digita    as raw.

DEFINE VARIABLE i-seq AS INT INITIAL 1 NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MasterDetail
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fPage0
&Scoped-define BROWSE-NAME brSon1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-int-recorrencia-notas ~
tt-int-recorrencia-historico

/* Definitions for BROWSE brSon1                                        */
&Scoped-define FIELDS-IN-QUERY-brSon1 tt-int-recorrencia-notas.nr-pedido ~
tt-int-recorrencia-notas.cod-estabel tt-int-recorrencia-notas.serie ~
tt-int-recorrencia-notas.nr-nota-fis tt-int-recorrencia-notas.valor ~
tt-int-recorrencia-notas.dt-emis-nota 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon1 
&Scoped-define QUERY-STRING-brSon1 FOR EACH tt-int-recorrencia-notas NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-brSon1 OPEN QUERY brSon1 FOR EACH tt-int-recorrencia-notas NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-brSon1 tt-int-recorrencia-notas
&Scoped-define FIRST-TABLE-IN-QUERY-brSon1 tt-int-recorrencia-notas


/* Definitions for BROWSE brSon2                                        */
&Scoped-define FIELDS-IN-QUERY-brSon2 ~
tt-int-recorrencia-historico.nr-sequencia ~
tt-int-recorrencia-historico.dt-evento ~
tt-int-recorrencia-historico.hr-evento ~
tt-int-recorrencia-historico.user-evento ~
tt-int-recorrencia-historico.desc-evento 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon2 
&Scoped-define QUERY-STRING-brSon2 FOR EACH tt-int-recorrencia-historico NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-brSon2 OPEN QUERY brSon2 FOR EACH tt-int-recorrencia-historico NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-brSon2 tt-int-recorrencia-historico
&Scoped-define FIRST-TABLE-IN-QUERY-brSon2 tt-int-recorrencia-historico


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brSon1}

/* Definitions for FRAME fPage2                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage2 ~
    ~{&OPEN-QUERY-brSon2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-int-recorrencia-contratos.id-recorrencia ~
tt-int-recorrencia-contratos.nr-contrato ~
tt-int-recorrencia-contratos.nr-parcela ~
tt-int-recorrencia-contratos.nr-transacao ~
tt-int-recorrencia-contratos.cod-emitente ~
tt-int-recorrencia-contratos.valor ~
tt-int-recorrencia-contratos.cod-sit-trans ~
tt-int-recorrencia-contratos.dt-venc 
&Scoped-define ENABLED-TABLES tt-int-recorrencia-contratos
&Scoped-define FIRST-ENABLED-TABLE tt-int-recorrencia-contratos
&Scoped-Define ENABLED-OBJECTS rtToolBar rtParent btFirst btPrev btNext ~
btLast btGoTo btSearch btQueryJoins btReportsJoins btExit btHelp ~
c-nome-param c-nome-emit 
&Scoped-Define DISPLAYED-FIELDS tt-int-recorrencia-contratos.id-recorrencia ~
tt-int-recorrencia-contratos.nr-contrato ~
tt-int-recorrencia-contratos.nr-parcela ~
tt-int-recorrencia-contratos.nr-transacao ~
tt-int-recorrencia-contratos.cod-emitente ~
tt-int-recorrencia-contratos.valor ~
tt-int-recorrencia-contratos.cod-sit-trans ~
tt-int-recorrencia-contratos.dt-venc 
&Scoped-define DISPLAYED-TABLES tt-int-recorrencia-contratos
&Scoped-define FIRST-DISPLAYED-TABLE tt-int-recorrencia-contratos
&Scoped-Define DISPLAYED-OBJECTS c-nome-param c-nome-emit 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wMasterDetail AS WIDGET-HANDLE NO-UNDO.

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

DEFINE VARIABLE c-nome-emit AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-param AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 36 BY .88 NO-UNDO.

DEFINE RECTANGLE rtParent
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 4.58.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE BUTTON bt-fatura-ped 
     LABEL "Faturar Ped" 
     SIZE 11 BY 1.13.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brSon1 FOR 
      tt-int-recorrencia-notas SCROLLING.

DEFINE QUERY brSon2 FOR 
      tt-int-recorrencia-historico SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon1 wMasterDetail _STRUCTURED
  QUERY brSon1 NO-LOCK DISPLAY
      tt-int-recorrencia-notas.nr-pedido FORMAT ">>>,>>>,>>9":U
      tt-int-recorrencia-notas.cod-estabel FORMAT "x(5)":U
      tt-int-recorrencia-notas.serie FORMAT "x(5)":U
      tt-int-recorrencia-notas.nr-nota-fis FORMAT "x(16)":U
      tt-int-recorrencia-notas.valor FORMAT "->>>,>>>,>>9.99":U
      tt-int-recorrencia-notas.dt-emis-nota FORMAT "99/99/9999":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 7.83
         FONT 2.

DEFINE BROWSE brSon2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon2 wMasterDetail _STRUCTURED
  QUERY brSon2 NO-LOCK DISPLAY
      tt-int-recorrencia-historico.nr-sequencia COLUMN-LABEL "Seq" FORMAT ">>>9":U
      tt-int-recorrencia-historico.dt-evento FORMAT "99/99/9999":U
      tt-int-recorrencia-historico.hr-evento FORMAT "x(10)":U WIDTH 6
      tt-int-recorrencia-historico.user-evento FORMAT "x(12)":U
            WIDTH 8
      tt-int-recorrencia-historico.desc-evento FORMAT "x(200)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 9.13
         FONT 2.


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
     btQueryJoins AT ROW 1.13 COL 74.86 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.86 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.86 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.86 HELP
          "Ajuda"
     tt-int-recorrencia-contratos.id-recorrencia AT ROW 3 COL 15 COLON-ALIGNED WIDGET-ID 2
          LABEL "Id"
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     c-nome-param AT ROW 3 COL 27.29 COLON-ALIGNED NO-LABEL WIDGET-ID 18
     tt-int-recorrencia-contratos.nr-contrato AT ROW 4 COL 15 COLON-ALIGNED WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     tt-int-recorrencia-contratos.nr-parcela AT ROW 5 COL 15 COLON-ALIGNED WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     tt-int-recorrencia-contratos.nr-transacao AT ROW 6 COL 15 COLON-ALIGNED WIDGET-ID 8
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     tt-int-recorrencia-contratos.cod-emitente AT ROW 7.5 COL 15 COLON-ALIGNED WIDGET-ID 10
          VIEW-AS FILL-IN 
          SIZE 9 BY .88
     c-nome-emit AT ROW 7.5 COL 24.29 COLON-ALIGNED NO-LABEL WIDGET-ID 20
     tt-int-recorrencia-contratos.valor AT ROW 8.5 COL 15 COLON-ALIGNED WIDGET-ID 12
          VIEW-AS FILL-IN 
          SIZE 11.72 BY .88
     tt-int-recorrencia-contratos.cod-sit-trans AT ROW 9.5 COL 15 COLON-ALIGNED WIDGET-ID 14
          VIEW-AS FILL-IN 
          SIZE 20 BY .88
     tt-int-recorrencia-contratos.dt-venc AT ROW 10.5 COL 15 COLON-ALIGNED WIDGET-ID 16
          VIEW-AS FILL-IN 
          SIZE 11.72 BY .88
     rtToolBar AT ROW 1 COL 1
     rtParent AT ROW 2.67 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 22
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage2
     brSon2 AT ROW 1.17 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 13
         SIZE 84.43 BY 9.75
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage1
     brSon1 AT ROW 1.17 COL 2 WIDGET-ID 300
     bt-fatura-ped AT ROW 9.08 COL 2 WIDGET-ID 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 13
         SIZE 84.43 BY 9.75
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MasterDetail
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: tt-int-recorrencia-contratos T "?" NO-UNDO mgesp int-recorrencia-contratos
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-int-recorrencia-historico T "?" NO-UNDO mgesp int-recorrencia-historico
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-int-recorrencia-notas T "?" NO-UNDO mgesp int-recorrencia-notas
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
         MAX-HEIGHT         = 24.54
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 24.54
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
/* SETTINGS FOR FILL-IN tt-int-recorrencia-contratos.id-recorrencia IN FRAME fPage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB brSon1 1 fPage1 */
/* SETTINGS FOR FRAME fPage2
                                                                        */
/* BROWSE-TAB brSon2 1 fPage2 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMasterDetail)
THEN wMasterDetail:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon1
/* Query rebuild information for BROWSE brSon1
     _TblList          = "Temp-Tables.tt-int-recorrencia-notas"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   = Temp-Tables.tt-int-recorrencia-notas.nr-pedido
     _FldNameList[2]   = Temp-Tables.tt-int-recorrencia-notas.cod-estabel
     _FldNameList[3]   = Temp-Tables.tt-int-recorrencia-notas.serie
     _FldNameList[4]   = Temp-Tables.tt-int-recorrencia-notas.nr-nota-fis
     _FldNameList[5]   = Temp-Tables.tt-int-recorrencia-notas.valor
     _FldNameList[6]   = Temp-Tables.tt-int-recorrencia-notas.dt-emis-nota
     _Query            is OPENED
*/  /* BROWSE brSon1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon2
/* Query rebuild information for BROWSE brSon2
     _TblList          = "Temp-Tables.tt-int-recorrencia-historico"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.tt-int-recorrencia-historico.nr-sequencia
"tt-int-recorrencia-historico.nr-sequencia" "Seq" ? "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   = Temp-Tables.tt-int-recorrencia-historico.dt-evento
     _FldNameList[3]   > Temp-Tables.tt-int-recorrencia-historico.hr-evento
"tt-int-recorrencia-historico.hr-evento" ? ? "character" ? ? ? ? ? ? no ? no no "6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tt-int-recorrencia-historico.user-evento
"tt-int-recorrencia-historico.user-evento" ? ? "character" ? ? ? ? ? ? no ? no no "8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   = Temp-Tables.tt-int-recorrencia-historico.desc-evento
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
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brSon1
&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME brSon1
&Scoped-define SELF-NAME bt-fatura-ped
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-fatura-ped wMasterDetail
ON CHOOSE OF bt-fatura-ped IN FRAME fPage1 /* Faturar Ped */
DO:
    IF brSon1:NUM-SELECTED-ROWS > 0 THEN
        GET CURRENT brSon1.
    
    IF AVAIL tt-int-recorrencia-notas THEN DO:
        FIND FIRST ped-venda NO-LOCK
             WHERE ped-venda.nr-pedido = tt-int-recorrencia-notas.nr-pedido NO-ERROR.
        IF AVAIL ped-venda AND ped-venda.cod-sit-ped < 3 THEN DO:
            RUN pi-fatura-pedido(INPUT tt-int-recorrencia-notas.nr-pedido).

            FIND LAST int-recorrencia-historico NO-LOCK
                WHERE int-recorrencia-historico.id-recorrencia = tt-int-recorrencia-notas.id-recorrencia
                  AND int-recorrencia-historico.nr-contrato    = tt-int-recorrencia-notas.nr-contrato   
                  AND int-recorrencia-historico.nr-parcela     = tt-int-recorrencia-notas.nr-parcela    
                  AND int-recorrencia-historico.nr-transacao   = "1" NO-ERROR.
           IF AVAIL int-recorrencia-historico THEN
               ASSIGN i-seq = int-recorrencia-historico.nr-sequencia + 1.
        
           CREATE int-recorrencia-historico.                                                                                                                               
           ASSIGN int-recorrencia-historico.id-recorrencia = ENTRY(2,int-pedido-vtex.nr-pedido,"-")                      
                  int-recorrencia-historico.nr-contrato    = STRING(INT(ENTRY(3,int-pedido-vtex.nr-pedido,"-")),"999999") 
                  int-recorrencia-historico.nr-parcela     = STRING(INT(ENTRY(4,int-pedido-vtex.nr-pedido,"-")),"99")     
                  int-recorrencia-historico.nr-transacao   = "1"                             
                  int-recorrencia-historico.nr-sequencia   = i-seq
                  int-recorrencia-historico.dt-evento      = TODAY                                                                                                         
                  int-recorrencia-historico.hr-evento      = STRING(TIME, 'HH:MM:SS')                                                                                      
                  int-recorrencia-historico.user-evento    = c-seg-usuario                                                                                                 
                  int-recorrencia-historico.desc-evento    = "Solicita‡Æo manual de faturamento".

            RUN utp/ut-msgs.p (INPUT "show", INPUT 15825 , INPUT "Pedido enviado para faturamento no RPW.").
        END.
    END.
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
    {method/zoomreposition.i &ProgramZoom="eszoom/z01es158.w"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miAbout
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miAbout wMasterDetail
ON CHOOSE OF MENU-ITEM miAbout /* Sobre... */
DO:
  {include/sobre.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMasterDetail 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
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

    FIND FIRST int-recorrencia-param NO-LOCK
         WHERE int-recorrencia-param.id = tt-int-recorrencia-contratos.id-recorrencia:SCREEN-VALUE IN FRAME fpage0 NO-ERROR.
    IF AVAIL int-recorrencia-param THEN 
        ASSIGN c-nome-param:SCREEN-VALUE IN FRAME fpage0 = int-recorrencia-param.nome.
    ELSE
        ASSIGN c-nome-param:SCREEN-VALUE IN FRAME fpage0 = "".

    FIND FIRST emitente NO-LOCK
         WHERE emitente.cod-emitente = int(tt-int-recorrencia-contratos.cod-emitente:SCREEN-VALUE IN FRAME fpage0) NO-ERROR.
    IF AVAIL emitente THEN 
        ASSIGN c-nome-emit:SCREEN-VALUE IN FRAME fpage0 = emitente.nome-emit.
    ELSE
        ASSIGN c-nome-emit:SCREEN-VALUE IN FRAME fpage0 = "".

    ASSIGN bt-fatura-ped:SENSITIVE IN FRAME fPage1 = YES.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToRecord wMasterDetail 
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
    
    DEFINE VARIABLE c-id-recorrencia LIKE {&ttParent}.id-recorrencia NO-UNDO.
    DEFINE VARIABLE c-nr-contrato    LIKE {&ttParent}.nr-contrato NO-UNDO.
    DEFINE VARIABLE c-nr-parcela     LIKE {&ttParent}.nr-parcela NO-UNDO.
    DEFINE VARIABLE c-nr-transacao   LIKE {&ttParent}.nr-transacao NO-UNDO.
    
    DEFINE FRAME fGoToRecord
        c-id-recorrencia AT ROW 1.21 COL 17.72 COLON-ALIGNED
        c-nr-contrato    AT ROW 2.21 COL 17.72 COLON-ALIGNED
        c-nr-parcela     AT ROW 3.21 COL 17.72 COLON-ALIGNED
        c-nr-transacao   AT ROW 4.21 COL 17.72 COLON-ALIGNED
        btGoToOK          AT ROW 5.63 COL 2.14
        btGoToCancel      AT ROW 5.63 COL 13
        rtGoToButton      AT ROW 5.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V  Para Contrato" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.
    
/*tech1139 - FO 1338.917 - 10/07/2006  */
    RUN utp/ut-trfrrp.p (input Frame fGoToRecord:Handle).
    {utp/ut-liter.i "V _Para_Contrato"}
    ASSIGN FRAME fGoToRecord:TITLE = RETURN-VALUE.
/*tech1139 - FO 1338.917 - 10/07/2006  */
                                         
    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN c-id-recorrencia c-nr-contrato c-nr-parcela c-nr-transacao.
        
        /*:T Posiciona query, do DBO, atrav‚s dos valores do ¡ndice £nico */
        RUN goToKey IN {&hDBOParent} (INPUT c-id-recorrencia , 
                                      INPUT c-nr-contrato ,
                                      INPUT c-nr-parcela ,
                                      INPUT c-nr-transacao ).
        IF RETURN-VALUE = "NOK":U THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT "Contrato":U).
            
            RETURN NO-APPLY.
        END.
        
        /*:T Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOParent} (OUTPUT rGoTo).
        
        /*:T Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).
        
        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    ENABLE c-id-recorrencia c-nr-contrato c-nr-parcela c-nr-transacao  btGoToOK btGoToCancel 
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
    
    /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOParent}) OR
       {&hDBOParent}:TYPE <> "PROCEDURE":U OR
       {&hDBOParent}:FILE-NAME <> "esbo/boes158.p":U THEN DO:
        {btb/btb008za.i1 esbo/boes158.p YES}
        {btb/btb008za.i2 esbo/boes158.p '' {&hDBOParent}} 
    END.

    RUN openQueryStatic IN {&hDBOParent} (INPUT "Main":U) NO-ERROR.
    
    /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOSon1}) OR 
       {&hDBOSon1}:TYPE <> "PROCEDURE":U OR
       {&hDBOSon1}:FILE-NAME <> "esbo/boes159.p":U THEN DO:
        {btb/btb008za.i1 esbo/boes159.p YES}
        {btb/btb008za.i2 esbo/boes159.p '' {&hDBOSon1}} 
    END.
    
    /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOSon2}) OR
       {&hDBOSon2}:TYPE <> "PROCEDURE":U OR
       {&hDBOSon2}:FILE-NAME <> "esbo/boes160.p":U THEN DO:
        {btb/btb008za.i1 esbo/boes160.p YES}
        {btb/btb008za.i2 esbo/boes160.p '' {&hDBOSon2}} 
    END.
    
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
    
    {masterdetail/openqueriesson.i &Parent="int-recorrencia-contratos"
                                   &Query="int-recorrencia-notas"
                                   &PageNumber="1"}
    
    {masterdetail/openqueriesson.i &Parent="int-recorrencia-contratos"
                                   &Query="int-recorrencia-historico"
                                   &PageNumber="2"}
              
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-fatura-pedido wMasterDetail 
PROCEDURE pi-fatura-pedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT        PARAMETER c-nr-pedcli AS CHAR NO-UNDO.

    DEFINE VARIABLE p_cod_prog_dtsul_w                          AS Character format "x(50)"      no-undo.
    DEFINE VARIABLE p_cod_prog_dtsul_rp                         AS Character format "x(50)"      no-undo.
    DEFINE VARIABLE p_cod_release                               AS Character format "x(9)"       no-undo.
    DEFINE VARIABLE p_cdn_estil_dwb                             AS Integer   format ">>9"        no-undo.
    DEFINE VARIABLE p_arquivo                                   AS Character format "x(50)"      no-undo.
    DEFINE VARIABLE p_destino                                   AS integer   format "9"          no-undo.
    DEFINE VARIABLE p_raw_param                                 AS Raw                           no-undo.
    DEFINE VARIABLE c-servidor                                  AS CHARACTER                     NO-UNDO.

    DEFINE VARIABLE i-cont-aux      AS INTEGER                  NO-UNDO.
    DEFINE VARIABLE p_num_ped_exec                              AS integer   FORMAT ">>>>9"      no-undo.

    EMPTY TEMP-TABLE tt-digita.
    EMPTY TEMP-TABLE tt-param.
    EMPTY TEMP-TABLE tt_param_segur.
    EMPTY TEMP-TABLE tt_ped_exec.
    EMPTY TEMP-TABLE tt_ped_exec_param.
    EMPTY TEMP-TABLE tt_ped_exec_param_aux.
    EMPTY TEMP-TABLE tt_ped_exec_sel.
                                    
    FIND FIRST ped-venda NO-LOCK 
         WHERE ped-venda.nr-pedcli = c-nr-pedcli NO-ERROR.
    IF AVAIL ped-venda THEN DO:

        IF ped-venda.cod-priori <> 7 THEN DO:

            FOR EACH mgesp.ponto-programa NO-LOCK
               WHERE ponto-programa.nome-programa = "espdp006"
                 AND ponto-programa.ponto         = 11,  
                EACH mgesp.conteudo-programa NO-LOCK
               WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:
        
               ASSIGN c-servidor = entry(1,conteudo-programa.conteudo, ";").
        
            END. /* FOR EACH mgesp.ponto-programa NO-LOCK */

            /* Presa pelo faturamento comercial */
            DO TRANS:
                FIND CURRENT ped-venda EXCLUSIVE-LOCK NO-ERROR.
                ASSIGN ped-venda.cod-priori = 07 . 
            END.

            FIND CURRENT ped-venda NO-LOCK NO-ERROR.

            FOR EACH ped-item NO-LOCK
               WHERE ped-item.nome-abrev = ped-venda.nome-abrev
                 AND ped-item.nr-pedcli  = ped-venda.nr-pedcli:
                FIND FIRST ITEM NO-LOCK
                     WHERE ITEM.it-codigo = ped-item.it-codigo NO-ERROR.

                IF ped-item.qt-log-aloc <> 0 or
                   ITEM.baixa-estoq = NO THEN DO:

                    CREATE tt-digita.
                    ASSIGN tt-digita.nome-abrev     = ped-venda.nome-abrev  
                           tt-digita.nr-pedcli      = ped-venda.nr-pedcli 
                           tt-digita.c-it-codigo    = ped-item.it-codigo    
                           tt-digita.c-cod-refer    = ped-item.cod-refer    
                           tt-digita.i-nr-sequencia = ped-item.nr-sequencia.
                END.
                ELSE DO:

                    FIND FIRST prod-composto WHERE prod-composto.it-codigo-filho = ped-item.it-codigo NO-LOCK NO-ERROR.
                    IF AVAIL prod-composto THEN DO:

                        FIND FIRST ITEM WHERE ITEM.it-codigo = prod-composto.it-codigo-filho NO-LOCK NO-ERROR.
                        IF AVAIL ITEM THEN DO:

                            IF item.baixa-estoq = NO THEN DO:
                                CREATE tt-digita.
                                ASSIGN tt-digita.nome-abrev     = ped-venda.nome-abrev  
                                       tt-digita.nr-pedcli      = ped-venda.nr-pedcli   
                                       tt-digita.c-it-codigo    = ped-item.it-codigo    
                                       tt-digita.c-cod-refer    = ped-item.cod-refer    
                                       tt-digita.i-nr-sequencia = ped-item.nr-sequencia 
                                       .
                            END. /* IF item.baixa-estoq = NO THEN DO: */
                        END. /* IF AVAIL ITEM THEN DO: */
                    END. /* IF AVAIL prod-composto THEN DO: */
                END.
            END.

            create tt-param.
            assign tt-param.usuario     = c-seg-usuario
                   tt-param.destino     = 2
                   tt-param.data-exec   = today
                   tt-param.hora-exec   = time

                   tt-param.nome-abrev  = ped-venda.nome-abrev 
                   tt-param.nr-pedcli   = ped-venda.nr-pedcli 
                   tt-param.Cod-depos   = "wex"
                   tt-param.Localizacao = "".

            ASSIGN tt-param.arquivo = "esftp016rpFatCom_UNIX.tmp".

            RAW-TRANSFER tt-param TO raw-param.
            FOR each tt-digita NO-LOCK:
                create tt-raw-digita.
                raw-transfer tt-digita to tt-raw-digita.raw-digita.
            END.

            ASSIGN p_cod_prog_dtsul_w    = "esftp016rp"           
                   p_cod_prog_dtsul_rp   = "esp/ftp/esftp016rp.p"
                   p_cod_release         = '2.00.00.000'                    
                   p_cdn_estil_dwb       = 97                   
                   p_arquivo             = "esftp016rpFatCom.tmp" 
                   p_destino             = 2                    
                   p_raw_param           = raw-param.  

            create tt_param_segur.
            assign tt_param_segur.tta_num_vers_integr_api      = 3
                   tt_param_segur.tta_cod_aplicat_dtsul_corren = "MFT"
                   tt_param_segur.tta_cod_empres_usuar         = string(i-ep-codigo-usuario)
                   tt_param_segur.tta_cod_grp_usuar_lst        = v_cod_grp_usuar_lst
                   tt_param_segur.tta_cod_idiom_usuar          = "POR":U
                   tt_param_segur.tta_cod_modul_dtsul_corren   = "MFT"
                   tt_param_segur.tta_cod_pais_empres_usuar    = "BRA"
                   tt_param_segur.tta_cod_usuar_corren         = v_cod_usuar_corren
                   tt_param_segur.tta_cod_usuar_corren_criptog = v_cod_usuar_corren_criptog.

            create tt_ped_exec.
            assign tt_ped_exec.tta_num_seq                = 1
                   tt_ped_exec.tta_cod_usuario            = v_cod_usuar_corren
                   tt_ped_exec.tta_cod_prog_dtsul         = p_cod_prog_dtsul_w 
                   tt_ped_exec.tta_cod_prog_dtsul_rp      = p_cod_prog_dtsul_rp
                   tt_ped_exec.tta_cod_release_prog_dtsul = p_cod_release      
                   tt_ped_exec.tta_dat_exec_ped_exec      = today
                   tt_ped_exec.tta_hra_exec_ped_exec      = replace(string(time,"HH:MM:SS"), ":", "")
                   tt_ped_exec.tta_cod_servid_exec        = c-servidor
                   tt_ped_exec.tta_cdn_estil_dwb          = 97.

            create tt_ped_exec_param.
            assign tt_ped_exec_param.tta_num_seq              = 1
                   tt_ped_exec_param.tta_cod_dwb_file         = "ftp/esftp016rp.p"
                   tt_ped_exec_param.tta_cod_dwb_output       = 'Arquivo'
                   tt_ped_exec_param.tta_nom_dwb_printer      = p_arquivo.

            raw-transfer tt-param       to tt_ped_exec_param.tta_raw_param_ped_exec.

            ASSIGN i-cont-aux = 0.
            FOR EACH tt-raw-digita NO-LOCK: 
                 ASSIGN i-cont-aux = i-cont-aux + 1.
                 CREATE tt_ped_exec_param_aux.
                 ASSIGN tt_ped_exec_param_aux.tta_num_dwb_order      = i-cont-aux
                        tt_ped_exec_param_aux.tta_num_seq            = 1
                        tt_ped_exec_param_aux.tta_raw_param_ped_exec = tt-raw-digita.raw-digita.
            END.

            run btb/btb912zb.p (input-output table tt_param_segur,
                                input-output table tt_ped_exec,
                                input table tt_ped_exec_param,
                                input table tt_ped_exec_param_aux,
                                input table tt_ped_exec_sel).

            FIND FIRST tt_ped_exec NO-LOCK NO-ERROR.
            IF AVAIL tt_ped_exec THEN DO TRANS:

                ASSIGN p_num_ped_exec = tt_ped_exec.tta_num_ped_exec.

                FIND FIRST fat-comercial EXCLUSIVE-LOCK
                     WHERE fat-comercial.num-ped-exec = tt_ped_exec.tta_num_ped_exec
                       AND fat-comercial.nr-pedcli    = c-nr-pedcli  NO-ERROR.

                IF NOT AVAIL fat-comercial THEN DO:
                    CREATE fat-comercial.                          
                    ASSIGN fat-comercial.nr-sequencia    = 10 
                           fat-comercial.dt-fatura       = TODAY
                           fat-comercial.hr-fatura       = TIME 
                           fat-comercial.nome-abrev      = ped-venda.nome-abrev
                           fat-comercial.nr-pedcli       = ped-venda.nr-pedcli 
                           fat-comercial.num-ped-exec    = tt_ped_exec.tta_num_ped_exec
                           fat-comercial.tipo            = 1.
                END. /* IF NOT AVAIL fat-comercial THEN DO: */
                ELSE DO:
                    ASSIGN fat-comercial.dt-fatura       = TODAY
                           fat-comercial.hr-fatura       = TIME.
                END.
                FIND CURRENT fat-comercial   NO-LOCK NO-ERROR.
                RELEASE fat-comercial.

            END. /* IF AVAIL tt_ped_exec THEN DO: */
        END. /* IF ped-venda.cod-priori = 10 THEN DO: */
    END. /* IF AVAIL ped-venda THEN DO: */
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

