
&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wMaintenance


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttWm-saldo-estoque NO-UNDO LIKE wm-saldo-estoque
       field RowNum as integer
       field r-RowId as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMaintenance 
/********************************************************************************
** Copyright SCM (2016)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da SCM, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
********************************************************************************/
{include/i-prgvrs.i ESWMP011 2.00.01.001 } /*** 010001 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ESWMP011 MWM}
&ENDIF

/********************************************************************************
** Copyright SCM (2016)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da SCM, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
********************************************************************************/
CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESWMP011
&GLOBAL-DEFINE Version        2.00.01.001

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1

&GLOBAL-DEFINE FolderLabels   

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

&GLOBAL-DEFINE ttTable        ttWm-saldo-estoque
&GLOBAL-DEFINE hDBOTable      hBOWm-saldo-estoque
&GLOBAL-DEFINE DBOTable       Wm-saldo-estoque

&GLOBAL-DEFINE page0KeyFields 

&GLOBAL-DEFINE page0Fields    ttWm-saldo-estoque.cod-estabel      ~
                              ttWm-saldo-estoque.cod-local        ~
                              ttWm-saldo-estoque.cod-item         ~
                              ttWm-saldo-estoque.cod-cliente      ~
                              fi-nom-estabel                      ~
                              fi-nom-local                        ~
                              fi-des-item                         ~
                              fi-des-cliente

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable}        AS HANDLE                                             NO-UNDO.
DEFINE VARIABLE hDBOSon1            AS HANDLE                                             NO-UNDO.
DEFINE VARIABLE h-bosc030           AS HANDLE                                             NO-UNDO.

DEFINE VARIABLE c-ind-status-ender  AS CHARACTER LABEL "Status Endere‡o"  FORMAT "X(20)"  NO-UNDO.
DEFINE VARIABLE c-ind-status-box    AS CHARACTER LABEL "Status Box"       FORMAT "X(20)"  NO-UNDO.

DEFINE VARIABLE c-cod-estabel       AS CHARACTER                                          NO-UNDO.
DEFINE VARIABLE c-cod-local         AS CHARACTER                                          NO-UNDO.
DEFINE VARIABLE i-cod-cliente       AS INTEGER                                            NO-UNDO.
                                                                    
DEFINE VARIABLE c-situacao          AS CHARACTER LABEL "Status Embalagem"                 NO-UNDO.
DEFINE VARIABLE c-cod-bloco         AS CHARACTER LABEL "Bloco"                            NO-UNDO.
DEFINE VARIABLE c-cod-rua           AS CHARACTER LABEL "Rua"                              NO-UNDO.
DEFINE VARIABLE c-cod-nivel         AS CHARACTER LABEL "Nivel"                            NO-UNDO.
DEFINE VARIABLE c-cod-coluna        AS CHARACTER LABEL "Coluna"                           NO-UNDO.
DEFINE VARIABLE c-ind-posicao-box   AS CHARACTER LABEL "Posi‡Æo End"                      NO-UNDO.
DEFINE VARIABLE l-armazena          AS LOGICAL   LABEL "Bloq.Arm."                        NO-UNDO.
DEFINE VARIABLE l-retira            AS LOGICAL   LABEL "Bloq.Ret."                        NO-UNDO.

DEFINE VARIABLE l-lote-avancado     AS LOGICAL                                            NO-UNDO.
DEFINE VARIABLE c-lote-estado       AS CHARACTER LABEL "Estado Lote CQ"  FORMAT "x(40)"   NO-UNDO.
DEFINE VARIABLE l-bloq-movto-cq     AS LOGICAL   LABEL "Bloq Movto CQ"   FORMAT "Sim/NÆo" NO-UNDO.
DEFINE VARIABLE qtd-bloq-total      LIKE wm-box-saldo.qtd-item-bloq                       NO-UNDO.
DEFINE VARIABLE i-cont-qtd-liberada AS DECIMAL                                            NO-UNDO.
DEFINE VARIABLE i-cont              AS INTEGER                                            NO-UNDO.
DEFINE VARIABLE i-bloq-armazenagem  AS INT INIT 0 NO-UNDO. /* 0. NÆo alterado, 1. Bloqueado, 2. Liberado */
DEFINE VARIABLE i-bloq-retirada     AS INT INIT 0 NO-UNDO. /* 0. NÆo alterado, 1. Bloqueado, 2. Liberado */

DEFINE VARIABLE c-motivo            LIKE wms-histor-bloq-box.dsl-motiv-bloq-box           NO-UNDO.

DEF BUFFER bfwm-box FOR wm-box.

/***************************************************************************
** Include que define a variavel global gr-wm-box (rowid). Esta variavel  **
** sera utilizada no programa wmp/wm0402c.w para posicionar no registro   **
** selecionado no browse. Programa wm0402c e chamado pelo botao Etiquetas **
***************************************************************************/
{include/i-vrtab.i wm-box}
{cdp/cdcfgmat.i}

/*FLUIG
{utp/ut-indicador-tabela.i}*/

DEF TEMP-TABLE ttResumoItem NO-UNDO
         FIELD id-box            LIKE  wm-box-saldo.id-box
         FIELD ind-status-box    LIKE  wm-box-saldo.ind-status-box
         FIELD ind-status-saldo  LIKE  wm-box-saldo.ind-status-saldo
         FIELD cod-embalagem     LIKE  wm-box-saldo.cod-embalagem
         FIELD qtd-item          LIKE  wm-box-saldo.qtd-item
         FIELD qtd-item-alocad   LIKE  wm-box-saldo.qtd-item-bloq
         FIELD qtd-item-liberado LIKE  wm-box-saldo.qtd-item-bloq
         FIELD RowNum           AS INTEGER
         FIELD r-RowId          AS ROWID
         INDEX w-res01 id-box   
                       cod-embalagem
                       ind-status-saldo.

DEF TEMP-TABLE ttResumo NO-UNDO
         FIELD id-box             LIKE  wm-box-saldo.id-box
         FIELD ind-status-box     LIKE  wm-box-saldo.ind-status-box
         FIELD ind-status-saldo   LIKE  wm-box-saldo.ind-status-saldo
         FIELD cod-embalagem      LIKE  wm-box-saldo.cod-embalagem
         FIELD qtd-item           LIKE  wm-box-saldo.qtd-item
         FIELD qtd-item-alocad    LIKE  wm-box-saldo.qtd-item-bloq
         FIELD qtd-item-liberado  LIKE  wm-box-saldo.qtd-item-bloq
         FIELD log-bloq-arm       LIKE  wm-box.log-bloq-arm    
         FIELD log-bloq-retir     LIKE  wm-box.log-bloq-retir
         FIELD dt-trans           AS DATE
         FIELD dsl-motiv-bloq-box LIKE  wms-histor-bloq-box.dsl-motiv-bloq-box
         FIELD RowNum            AS INTEGER
         FIELD r-RowId           AS ROWID
         FIELD tipo-bloq         AS CHAR
         FIELD obs-cartao        AS CHAR
         FIELD obs-solicitante   AS CHAR
         FIELD obs-responsavel   AS CHAR
         FIELD obs-pedido        AS CHAR
         FIELD obs-geral         AS CHAR
         INDEX w-res01 id-box   
                       cod-embalagem
                       ind-status-saldo.

DEF TEMP-TABLE ttBloqueio NO-UNDO
    FIELD cod-estabel      LIKE wm-box.cod-estabel 
    FIELD cod-local        LIKE wm-box.cod-local   
    FIELD id-box           LIKE wm-box.id-box  
    FIELD log-bloq-arm     LIKE wm-box.log-bloq-arm    
    FIELD log-bloq-retir   LIKE wm-box.log-bloq-retir
    FIELD idi-tip-bloq-box LIKE wms-histor-bloq-box.idi-tip-bloq-box.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Maintenance
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brEndereco

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ttResumo

/* Definitions for BROWSE brEndereco                                    */
&Scoped-define FIELDS-IN-QUERY-brEndereco ttResumo.id-box fnEnderecoBox(c-cod-estabel, c-cod-local, ttResumo.id-box) ttResumo.dt-trans ttResumo.cod-embalagem ttResumo.qtd-item ttResumo.log-bloq-arm ttResumo.log-bloq-retir fnGetIndStatus(ttResumo.ind-status-box) @ c-ind-status-box c-lote-estado l-bloq-movto-cq ttResumo.dsl-motiv-bloq-box ttresumo.tipo-bloq ttresumo.obs-cartao ttresumo.obs-solicitante ttresumo.obs-responsavel ttresumo.obs-pedido ttresumo.obs-geral   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brEndereco   
&Scoped-define SELF-NAME brEndereco
&Scoped-define QUERY-STRING-brEndereco FOR EACH ttResumo NO-LOCK BY ttResumo.dt-trans
&Scoped-define OPEN-QUERY-brEndereco OPEN QUERY {&SELF-NAME} FOR EACH ttResumo NO-LOCK BY ttResumo.dt-trans.
&Scoped-define TABLES-IN-QUERY-brEndereco ttResumo
&Scoped-define FIRST-TABLE-IN-QUERY-brEndereco ttResumo


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-brEndereco}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ttWm-saldo-estoque.cod-estabel ~
ttWm-saldo-estoque.cod-cliente ttWm-saldo-estoque.cod-local ~
ttWm-saldo-estoque.cod-item 
&Scoped-define ENABLED-TABLES ttWm-saldo-estoque
&Scoped-define FIRST-ENABLED-TABLE ttWm-saldo-estoque
&Scoped-Define ENABLED-OBJECTS rtParent rtToolBar btFirst btPrev btNext ~
btLast btGoTo btSearch btQueryJoins btReportsJoins btExit btHelp ~
fi-nom-estabel fi-des-cliente fi-nom-local fi-des-item brEndereco btBloqArm ~
btBloqRet btDesbloqArm btDesbloqRet v-qtd-total v-qtd-bloq 
&Scoped-Define DISPLAYED-FIELDS ttWm-saldo-estoque.cod-estabel ~
ttWm-saldo-estoque.cod-cliente ttWm-saldo-estoque.cod-local ~
ttWm-saldo-estoque.cod-item 
&Scoped-define DISPLAYED-TABLES ttWm-saldo-estoque
&Scoped-define FIRST-DISPLAYED-TABLE ttWm-saldo-estoque
&Scoped-Define DISPLAYED-OBJECTS fi-nom-estabel fi-des-cliente fi-nom-local ~
fi-des-item v-qtd-total v-qtd-bloq 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnData wMaintenance 
FUNCTION fnData RETURNS DATE
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnEnderecoBox wMaintenance 
FUNCTION fnEnderecoBox RETURNS CHARACTER
  ( INPUT pCodEstabel AS CHAR,
    INPUT pCodLocal AS CHAR,
    INPUT pIdBox   AS DEC )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnGetIndStatus wMaintenance 
FUNCTION fnGetIndStatus RETURNS CHARACTER
  ( INPUT pIndStatus AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnGetIndStatusSaldo wMaintenance 
FUNCTION fnGetIndStatusSaldo RETURNS CHARACTER
  ( INPUT pIndSituacao AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnGetQuantidadeBloq wMaintenance 
FUNCTION fnGetQuantidadeBloq RETURNS DECIMAL
  ( INPUT p-qtd-item-bloq AS DECIMAL,
    INPUT p-qtd-item-alocad AS DECIMAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnGetStatusArm wMaintenance 
FUNCTION fnGetStatusArm RETURNS LOGICAL
  ( INPUT pCodEstabel AS CHAR,
    INPUT pCodLocal   AS CHAR,
    INPUT pIdBox      AS DEC )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnGetStatusRet wMaintenance 
FUNCTION fnGetStatusRet RETURNS LOGICAL
  ( INPUT pCodEstabel AS CHAR,
    INPUT pCodLocal   AS CHAR,
    INPUT pIdBox      AS DEC )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wMaintenance AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miFirst        LABEL "&Primeiro"      ACCELERATOR "CTRL-HOME"
       MENU-ITEM miPrev         LABEL "&Anterior"      ACCELERATOR "CTRL-CURSOR-LEFT"
       MENU-ITEM miNext         LABEL "&Pr½ximo"       ACCELERATOR "CTRL-CURSOR-RIGHT"
       MENU-ITEM miLast         LABEL "&‚ltimo"        ACCELERATOR "CTRL-END"
       RULE
       MENU-ITEM miGoTo         LABEL "&Vÿ Para"       ACCELERATOR "CTRL-T"
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
       MENU-ITEM miReportsJoins LABEL "&Relat½rios"   
       RULE
       MENU-ITEM miExit         LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU smHelp 
       MENU-ITEM miContents     LABEL "&Conteœdo"     
       RULE
       MENU-ITEM miAbout        LABEL "&Sobre..."     .

DEFINE MENU mbMain MENUBAR
       SUB-MENU  smFile         LABEL "&Arquivo"      
       SUB-MENU  smHelp         LABEL "&Ajuda"        .


/* Definitions of the field level widgets                               */
DEFINE BUTTON btBloqArm 
     LABEL "&Bloq Arm" 
     SIZE 12.86 BY 1.

DEFINE BUTTON btBloqRet 
     LABEL "&Bloq Ret" 
     SIZE 12.86 BY 1.

DEFINE BUTTON btDesbloqArm 
     LABEL "&Desbloq Arm" 
     SIZE 12.86 BY 1.

DEFINE BUTTON btDesbloqRet 
     LABEL "&Desbloq Ret" 
     SIZE 12.86 BY 1.

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

DEFINE VARIABLE fi-des-cliente AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 17.43 BY .88 NO-UNDO.

DEFINE VARIABLE fi-des-item AS CHARACTER FORMAT "X(60)" 
     VIEW-AS FILL-IN 
     SIZE 56.72 BY .88.

DEFINE VARIABLE fi-nom-estabel AS CHARACTER FORMAT "X(40)" 
     VIEW-AS FILL-IN 
     SIZE 67.57 BY .88.

DEFINE VARIABLE fi-nom-local AS CHARACTER FORMAT "X(40)" 
     VIEW-AS FILL-IN 
     SIZE 28.57 BY .88.

DEFINE VARIABLE v-qtd-bloq AS DECIMAL FORMAT "->>,>>9.9999":U INITIAL 0 
     LABEL "Bloq." 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .88 NO-UNDO.

DEFINE VARIABLE v-qtd-total AS DECIMAL FORMAT "->>,>>9.9999":U INITIAL 0 
     LABEL "Total" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .88 NO-UNDO.

DEFINE RECTANGLE rtParent
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 129 BY 2.33.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 129 BY 1.5
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brEndereco FOR 
      ttResumo SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brEndereco
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brEndereco wMaintenance _FREEFORM
  QUERY brEndereco DISPLAY
      ttResumo.id-box         COLUMN-LABEL "Id Endere‡o" FORMAT ">>>>>>>>>9"
      fnEnderecoBox(c-cod-estabel, c-cod-local, ttResumo.id-box) COLUMN-LABEL "Endere‡o" FORMAT "X(15)":U WIDTH 19
      ttResumo.dt-trans       COLUMN-LABEL "Dt Trans"
      ttResumo.cod-embalagem
      ttResumo.qtd-item
      ttResumo.log-bloq-arm   COLUMN-LABEL "Bloq. Armazenamento" FORMAT "Sim/NÆo":U WIDTH 15
      ttResumo.log-bloq-retir COLUMN-LABEL "Bloq. Retirada"      FORMAT "Sim/NÆo":U WIDTH 10
      fnGetIndStatus(ttResumo.ind-status-box)         @ c-ind-status-box WIDTH 10
      c-lote-estado FORMAT "X(40)":U WIDTH 2
      l-bloq-movto-cq 
      ttResumo.dsl-motiv-bloq-box    FORMAT "x(30)"
      ttresumo.tipo-bloq             COLUMN-LABEL "Tipo Bloq"    FORMAT "x(20)"
      ttresumo.obs-cartao            COLUMN-LABEL "Num CartÆo"   FORMAT "x(25)"
      ttresumo.obs-solicitante       COLUMN-LABEL "Solicitante"  FORMAT "x(25)"
      ttresumo.obs-responsavel       COLUMN-LABEL "Responsavel"  FORMAT "x(25)"
      ttresumo.obs-pedido            COLUMN-LABEL "Obs PO"       FORMAT "x(25)"
      ttresumo.obs-geral             COLUMN-LABEL "Observa‡Æo"   FORMAT "x(25)"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 129 BY 11.63
         FONT 1.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btFirst AT ROW 1.13 COL 1.57 HELP
          "Primeira ocorr¼ncia"
     btPrev AT ROW 1.13 COL 5.57 HELP
          "Ocorr¼ncia anterior"
     btNext AT ROW 1.13 COL 9.57 HELP
          "Pr½xima ocorr¼ncia"
     btLast AT ROW 1.13 COL 13.57 HELP
          "‚ltima ocorr¼ncia"
     btGoTo AT ROW 1.13 COL 17.57 HELP
          "Vÿ Para"
     btSearch AT ROW 1.13 COL 21.57 HELP
          "Pesquisa"
     btQueryJoins AT ROW 1.13 COL 113.29 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 117.29 HELP
          "Relat½rios relacionados"
     btExit AT ROW 1.13 COL 121.29 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 125.29 HELP
          "Ajuda"
     ttWm-saldo-estoque.cod-estabel AT ROW 2.83 COL 12 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     fi-nom-estabel AT ROW 2.83 COL 20.43 COLON-ALIGNED HELP
          "Nome do estabelecimento." NO-LABEL
     ttWm-saldo-estoque.cod-cliente AT ROW 2.83 COL 99.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     fi-des-cliente AT ROW 2.83 COL 109.72 COLON-ALIGNED NO-LABEL
     ttWm-saldo-estoque.cod-local AT ROW 3.83 COL 12 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     fi-nom-local AT ROW 3.83 COL 18.43 COLON-ALIGNED HELP
          "Nome do local." NO-LABEL
     ttWm-saldo-estoque.cod-item AT ROW 3.83 COL 54.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 15 BY .88
     fi-des-item AT ROW 3.83 COL 70.29 COLON-ALIGNED HELP
          "Descri»’o do item do WMS." NO-LABEL
     brEndereco AT ROW 5.13 COL 1
     btBloqArm AT ROW 16.96 COL 1.29
     btBloqRet AT ROW 16.96 COL 14.57 WIDGET-ID 2
     btDesbloqArm AT ROW 16.96 COL 103.72 WIDGET-ID 4
     btDesbloqRet AT ROW 16.96 COL 117 WIDGET-ID 6
     v-qtd-total AT ROW 17.04 COL 30.57 COLON-ALIGNED WIDGET-ID 8
     v-qtd-bloq AT ROW 17.04 COL 48.14 COLON-ALIGNED WIDGET-ID 10
     rtParent AT ROW 2.67 COL 1
     rtToolBar AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 161.14 BY 17.25
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Maintenance
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: ttWm-saldo-estoque T "?" NO-UNDO mgscm wm-saldo-estoque
      ADDITIONAL-FIELDS:
          field RowNum as integer
          field r-RowId as rowid
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
         HEIGHT             = 16.92
         WIDTH              = 129.72
         MAX-HEIGHT         = 27.71
         MAX-WIDTH          = 194.86
         VIRTUAL-HEIGHT     = 27.71
         VIRTUAL-WIDTH      = 194.86
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
/* BROWSE-TAB brEndereco fi-des-item fpage0 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMaintenance)
THEN wMaintenance:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brEndereco
/* Query rebuild information for BROWSE brEndereco
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH ttResumo NO-LOCK BY ttResumo.dt-trans.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE brEndereco */
&ANALYZE-RESUME

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


&Scoped-define SELF-NAME btBloqArm
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btBloqArm wMaintenance
ON CHOOSE OF btBloqArm IN FRAME fpage0 /* Bloq Arm */
DO:                        
    RUN piCarregaBloqueio(INPUT 1). 

    SESSION:SET-WAIT-STATE("GENERAL":U).
    /* Grava historico de bloqueios/Liberacao */
    IF CAN-FIND(FIRST ttBloqueio WHERE
                      ttBloqueio.log-bloq-arm = NO) THEN DO:

        RUN esp/wmp/eswmp011a.w (INPUT-OUTPUT TABLE ttBloqueio,
                                 INPUT 1,  /* 0. NÆo alterado, 1. Bloqueado, 2. Liberado */
                                 INPUT 0,   /* 0. NÆo alterado, 1. Bloqueado, 2. Liberado */    
                                 ttwm-saldo-estoque.cod-item).

        IF RETURN-VALUE = "OK" THEN
            RUN piMarcaArm (INPUT YES).
    END.

    SESSION:SET-WAIT-STATE("":U).
    RETURN RETURN-VALUE.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btBloqRet
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btBloqRet wMaintenance
ON CHOOSE OF btBloqRet IN FRAME fpage0 /* Bloq Ret */
DO:
    RUN piCarregaBloqueio(INPUT 2).

    SESSION:SET-WAIT-STATE("GENERAL":U).
    /* Grava historico de bloqueios/Liberacao */
    IF CAN-FIND(FIRST ttBloqueio WHERE
                      ttBloqueio.log-bloq-ret = NO) THEN DO:

        RUN esp/wmp/eswmp011a.w (INPUT-OUTPUT TABLE ttBloqueio,
                                 INPUT 0,   /* 0. NÆo alterado, 1. Bloqueado, 2. Liberado */
                                 INPUT 1,   /* 0. NÆo alterado, 1. Bloqueado, 2. Liberado */
                                 ttwm-saldo-estoque.cod-item).

        IF RETURN-VALUE = "OK" THEN
            RUN piMarcaRetir (INPUT YES).
    END.

    SESSION:SET-WAIT-STATE("":U).
    RETURN RETURN-VALUE.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btDesbloqArm
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDesbloqArm wMaintenance
ON CHOOSE OF btDesbloqArm IN FRAME fpage0 /* Desbloq Arm */
DO:                        
    RUN piCarregaBloqueio(INPUT 1).

    SESSION:SET-WAIT-STATE("GENERAL":U).
    /* Grava historico de bloqueios/Liberacao */
    IF CAN-FIND(FIRST ttBloqueio WHERE
                      ttBloqueio.log-bloq-arm = YES) THEN DO:

        RUN esp/wmp/eswmp011a.w (INPUT-OUTPUT TABLE ttBloqueio,
                                 INPUT 2,  /* 0. NÆo alterado, 1. Bloqueado, 2. Liberado */
                                 INPUT 0,  /* 0. NÆo alterado, 1. Bloqueado, 2. Liberado */    
                                 ttwm-saldo-estoque.cod-item).

        IF RETURN-VALUE = "OK" THEN
            RUN piMarcaArm (INPUT NO).
    END.

    SESSION:SET-WAIT-STATE("":U).
    RETURN RETURN-VALUE.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btDesbloqRet
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDesbloqRet wMaintenance
ON CHOOSE OF btDesbloqRet IN FRAME fpage0 /* Desbloq Ret */
DO:
    RUN piCarregaBloqueio(INPUT 2).

    SESSION:SET-WAIT-STATE("GENERAL":U).

    /* Grava historico de bloqueios/Liberacao */
    IF CAN-FIND(FIRST ttBloqueio WHERE
                      ttBloqueio.log-bloq-ret = YES) THEN DO:

        RUN esp/wmp/eswmp011a.w (INPUT-OUTPUT TABLE ttBloqueio,
                                 INPUT 0,  /* 0. NÆo alterado, 1. Bloqueado, 2. Liberado */
                                 INPUT 2,  /* 0. NÆo alterado, 1. Bloqueado, 2. Liberado */ 
                                 ttwm-saldo-estoque.cod-item).

        IF RETURN-VALUE = "OK" THEN
            RUN piMarcaRetir (INPUT NO).
    END.

    SESSION:SET-WAIT-STATE("":U).
    RETURN RETURN-VALUE.
    
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
    {method/zoomreposition.i &ProgramZoom="sczoom/z01sc058.w"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brEndereco
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenance 


/*--- Logica para inicializacao do programam ---*/
{maintenance/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wMaintenance 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF VALID-HANDLE(hDBOSon1) THEN DO:
        DELETE PROCEDURE hDBOSon1 NO-ERROR.
        ASSIGN hDBOSon1 = ?.
    END.
    IF VALID-HANDLE(h-bosc030) THEN DO:
        DELETE PROCEDURE h-bosc030 NO-ERROR.
        ASSIGN h-bosc030 = ?.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wMaintenance 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE h-proxy124         AS HANDLE   NO-UNDO.
    DEFINE VARIABLE l-aloca-wms        AS LOGICAL  NO-UNDO.
    DEFINE VARIABLE l-saldo-disp       AS LOGICAL  NO-UNDO.
    DEFINE VARIABLE l-existe           AS LOGICAL  NO-UNDO.
    DEFINE VARIABLE d-qtd-bloq         AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE d-qtd-total        AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE d-qtde-atual       LIKE wm-box-saldo.qtd-item  NO-UNDO.

    ASSIGN  c-cod-estabel       = {&ttTable}.cod-estabel:screen-value IN FRAME fpage0
            c-cod-local         = {&ttTable}.cod-local:screen-value   IN FRAME fpage0
            i-cod-cliente       = INT({&ttTable}.cod-cliente:screen-value IN FRAME fpage0).

    RUN getNomEstabel IN {&hDBOTable} (INPUT  c-cod-estabel,
                                       OUTPUT fi-nom-estabel).
    IF  RETURN-VALUE = "OK":U THEN
        DISPLAY fi-nom-estabel WITH FRAME fPage0.
    ELSE
        ASSIGN fi-nom-estabel:SCREEN-VALUE IN FRAME fpage0 = "":U.

    RUN getNomCliente IN {&hDBOTable} (INPUT  i-cod-cliente,
                                       OUTPUT fi-des-cliente).
    IF  RETURN-VALUE = "OK":U THEN
        DISPLAY fi-des-cliente WITH FRAME fPage0.
    ELSE
        ASSIGN fi-des-cliente:SCREEN-VALUE IN FRAME fpage0 = "":U.

    RUN getNomLocal IN {&hDBOTable} (INPUT  c-cod-local,
                                     OUTPUT fi-nom-local).
    IF  RETURN-VALUE = "OK":U THEN
        DISPLAY fi-nom-local WITH FRAME fPage0.
    ELSE
        ASSIGN fi-nom-local:SCREEN-VALUE IN FRAME fpage0 = "":U.

    RUN getDesItem IN {&hDBOTable} (INPUT {&ttTable}.cod-item:SCREEN-VALUE IN FRAME fpage0,
                                    OUTPUT fi-des-item).
    IF  RETURN-VALUE = "OK":U THEN
        DISPLAY fi-des-item WITH FRAME fPage0.
    ELSE
        ASSIGN fi-des-item:SCREEN-VALUE IN FRAME fpage0 = "":U.

    ASSIGN brEndereco:SENSITIVE   IN FRAME fPage0 = YES
           btBloqArm:SENSITIVE    IN FRAME fPage0 = YES
           btBloqRet:SENSITIVE    IN FRAME fPage0 = YES
           btDesBloqArm:SENSITIVE IN FRAME fPage0 = YES
           btDesBloqRet:SENSITIVE IN FRAME fPage0 = YES.

    FOR EACH ttResumo.     DELETE ttResumo.     END.
    FOR EACH ttResumoItem. DELETE ttResumoItem. END.

    RUN getOcupacaoItem IN hDBOSon1 (INPUT c-cod-estabel,
                                     INPUT c-cod-local,
                                     INPUT {&ttTable}.cod-cliente:SCREEN-VALUE IN FRAME fpage0,
                                     INPUT {&ttTable}.cod-item:SCREEN-VALUE    IN FRAME fpage0,
                                     INPUT '',
                                     INPUT '',
                                     OUTPUT d-qtde-atual,
                                     OUTPUT TABLE ttResumoItem).

    FOR EACH ttResumoItem:

        CREATE ttResumo.
        BUFFER-COPY ttResumoItem TO ttResumo.

        FOR FIRST bfwm-box FIELDS(log-bloq-arm log-bloq-retir)
            WHERE bfwm-box.cod-estabel = c-cod-estabel       AND
                  bfwm-box.cod-local   = c-cod-local         AND
                  bfwm-box.id-box      = ttResumoItem.id-box NO-LOCK.
        END.
        ASSIGN ttResumo.log-bloq-arm   = bfwm-box.log-bloq-arm
               ttResumo.log-bloq-retir = bfwm-box.log-bloq-retir
               ttResumo.dt-trans       = fnData().

        FIND LAST wms-histor-bloq-box USE-INDEX wmshstra-id NO-LOCK
            WHERE wms-histor-bloq-box.cod-estabel = c-cod-estabel
              AND wms-histor-bloq-box.cod-local   = c-cod-local
              AND wms-histor-bloq-box.id-box      = ttResumoItem.id-box 
              AND wms-histor-bloq-box.idi-tip-bloq-box = 2
                  NO-ERROR.

        IF AVAIL wms-histor-bloq-box AND 
                 ttResumo.log-bloq-retir = YES
        THEN DO:
            ASSIGN ttResumo.dsl-motiv-bloq-box = wms-histor-bloq-box.dsl-motiv-bloq-box.
        END.

        IF AVAIL wms-histor-bloq-box 
        THEN DO:
            FIND LAST int-wms-histor-bloq-box WHERE
                      int-wms-histor-bloq-box.cod-estabel       = wms-histor-bloq-box.cod-estabel
                  AND int-wms-histor-bloq-box.cod-local         = wms-histor-bloq-box.cod-local
                  AND int-wms-histor-bloq-box.id-box            = wms-histor-bloq-box.id-box
                  AND int-wms-histor-bloq-box.dat-bloq-box      = wms-histor-bloq-box.dat-bloq-box
                  AND int-wms-histor-bloq-box.num-hora-bloq-box = wms-histor-bloq-box.num-hora-bloq-box
                  AND int-wms-histor-bloq-box.idi-tip-bloq-box  = wms-histor-bloq-box.idi-tip-bloq-box
                      NO-LOCK NO-ERROR.

            IF AVAIL int-wms-histor-bloq-box 
                 AND ttResumo.log-bloq-retir = YES
            THEN DO:
                ASSIGN ttResumo.obs-cartao      = int-wms-histor-bloq-box.obs-cartao
                       ttResumo.obs-solicitante = int-wms-histor-bloq-box.obs-solicitante
                       ttResumo.obs-responsavel = int-wms-histor-bloq-box.obs-responsavel
                       ttResumo.obs-pedido      = int-wms-histor-bloq-box.obs-pedido
                       ttResumo.obs-geral       = int-wms-histor-bloq-box.obs-geral.
                       
                CASE int-wms-histor-bloq-box.tipo-bloq:
                    WHEN 1 THEN ASSIGN ttResumo.tipo-bloq = "Preventivo".
                    WHEN 2 THEN ASSIGN ttResumo.tipo-bloq = "Estoque".
                    WHEN 3 THEN ASSIGN ttResumo.tipo-bloq = "Lote Recusado".
                    WHEN 4 THEN ASSIGN ttResumo.tipo-bloq = "Aguardando lan‡amento".
                    WHEN 5 THEN ASSIGN ttResumo.tipo-bloq = "Inspe‡Æo".
                    WHEN 6 THEN ASSIGN ttResumo.tipo-bloq = "Previsto".
                END CASE.
            END.
            ELSE DO:
                ASSIGN ttResumo.obs-cartao      = ""
                       ttResumo.obs-solicitante = ""
                       ttResumo.obs-responsavel = ""
                       ttResumo.obs-pedido      = ""
                       ttResumo.obs-geral       = ""
                       ttResumo.tipo-bloq       = "".
            END.
                      
        END.

        IF ttResumo.log-bloq-arm 
        OR ttResumo.log-bloq-retir THEN
            ASSIGN d-qtd-bloq = d-qtd-bloq + ttResumo.qtd-item.

        ASSIGN d-qtd-total = d-qtd-total + ttResumo.qtd-item.
    END.

    ASSIGN v-qtd-total:SCREEN-VALUE IN FRAME fPage0 = STRING(d-qtd-total)
           v-qtd-bloq :SCREEN-VALUE IN FRAME fPage0 = STRING(d-qtd-bloq).

    OPEN QUERY brEndereco FOR EACH ttResumo NO-LOCK BY ttResumo.dt-trans.

    {utp/ut-liter.i Primeira_ocorrˆncia *}
    ASSIGN btFirst:TOOLTIP IN FRAME fPage0 = TRIM(RETURN-VALUE).
    {utp/ut-liter.i Ocorrˆncia_anterior *}
    ASSIGN btPrev:TOOLTIP IN FRAME fPage0 = TRIM(RETURN-VALUE).
    {utp/ut-liter.i Pr¢xima_ocorrˆncia *}
    ASSIGN btNext:TOOLTIP IN FRAME fPage0 = TRIM(RETURN-VALUE).
    {utp/ut-liter.i éltima_ocorrˆncia *}
    ASSIGN btLast:TOOLTIP IN FRAME fPage0 = TRIM(RETURN-VALUE).
    {utp/ut-liter.i V _para *}
    ASSIGN btGoTo:TOOLTIP IN FRAME fPage0 = TRIM(RETURN-VALUE).
    {utp/ut-liter.i Pesquisa *}
    ASSIGN btSearch:TOOLTIP IN FRAME fPage0 = TRIM(RETURN-VALUE).
    {utp/ut-liter.i Consultas_relacionadas *}
    ASSIGN btQueryJoins:TOOLTIP IN FRAME fPage0 = TRIM(RETURN-VALUE).
    {utp/ut-liter.i Relat¢rios_relacionados *}
    ASSIGN btReportsJoins:TOOLTIP IN FRAME fPage0 = TRIM(RETURN-VALUE).
    {utp/ut-liter.i Sair *}
    ASSIGN btExit:TOOLTIP IN FRAME fPage0 = TRIM(RETURN-VALUE).
    {utp/ut-liter.i Ajuda *}
    ASSIGN btHelp:TOOLTIP IN FRAME fPage0 = TRIM(RETURN-VALUE).

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToRecord wMaintenance 
PROCEDURE goToRecord :
/*------------------------------------------------------------------------------
  Purpose:     Exibe dialog de Va Para
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
    
    DEFINE VARIABLE cCodEstabel LIKE {&ttTable}.cod-estabel VIEW-AS FILL-IN SIZE  8    BY 0.88 NO-UNDO.
    DEFINE VARIABLE cCodLocal   LIKE {&ttTable}.cod-local   VIEW-AS FILL-IN SIZE  6    BY 0.88 NO-UNDO.
    DEFINE VARIABLE cCodCliente LIKE {&ttTable}.cod-cliente VIEW-AS FILL-IN SIZE 12    BY 0.88 NO-UNDO.    
    DEFINE VARIABLE cCodItem    LIKE {&ttTable}.cod-item    VIEW-AS FILL-IN SIZE 26.72 BY 0.88 NO-UNDO.
    DEFINE VARIABLE cCodRefer   LIKE {&ttTable}.cod-refer   VIEW-AS FILL-IN SIZE 14    BY 0.88 NO-UNDO.
    DEFINE VARIABLE cCodLote    LIKE {&ttTable}.cod-lote    VIEW-AS FILL-IN SIZE 38    BY 0.88 NO-UNDO.    
    
    DEFINE FRAME fGoToRecord
        cCodEstabel       AT ROW 1.21 COL 17.72 COLON-ALIGNED
        cCodLocal         AT ROW 2.21 COL 17.72 COLON-ALIGNED
        cCodCliente       AT ROW 3.21 COL 17.72 COLON-ALIGNED
        cCodItem          AT ROW 4.21 COL 17.72 COLON-ALIGNED
        cCodRefer         AT ROW 5.21 COL 17.72 COLON-ALIGNED
        cCodLote          AT ROW 6.21 COL 17.72 COLON-ALIGNED
        btGoToOK          AT ROW 7.63 COL 2.14
        btGoToCancel      AT ROW 7.63 COL 13
        rtGoToButton      AT ROW 7.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V  Para Saldo Estoque" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.

    RUN utp/ut-trfrrp.p (input Frame fGoToRecord:Handle).
    {utp/ut-liter.i "V _Para_Saldo_Estoque"}
    ASSIGN FRAME fGoToRecord:TITLE = RETURN-VALUE.
    
    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN cCodEstabel cCodLocal cCodCliente cCodItem cCodRefer cCodLote.
        
        RUN goToKey IN {&hDBOTable} (INPUT cCodEstabel, 
                                     INPUT cCodLocal,
                                     INPUT cCodCliente,
                                     INPUT cCodItem, 
                                     INPUT cCodRefer,
                                     INPUT cCodLote).
        IF RETURN-VALUE = "NOK":U THEN DO:
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Saldo_Estoque" *}
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT RETURN-VALUE).            
            RETURN NO-APPLY.
        END.
        
        /* Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOTable} (OUTPUT rGoTo).
        
        /* Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).

        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    ENABLE cCodEstabel cCodLocal cCodCliente cCodItem cCodRefer cCodLote btGoToOK btGoToCancel 
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
    /*--- Verifica se o DBO ja esta inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOTable}) THEN DO:
        {btb/btb008za.i1 scbo/bosc058.p YES}
        {btb/btb008za.i2 scbo/bosc058.p '' {&hDBOTable}}
    END.
    
    RUN setConstraintMain IN {&hDBOTable} NO-ERROR.
    RUN openQueryStatic   IN {&hDBOTable} (INPUT "Main":U) NO-ERROR.
    
    IF NOT VALID-HANDLE(hDBOSon1) THEN DO:
        {btb/btb008za.i1 scbo/bosc035.p YES}
        {btb/btb008za.i2 scbo/bosc035.p '' hDBOSon1}
    END.

    IF NOT VALID-HANDLE(h-bosc030) THEN DO:
        {btb/btb008za.i1 scbo/bosc030.p YES}
        {btb/btb008za.i2 scbo/bosc030.p '' h-bosc030}
    END.

    RUN openQueryStatic IN h-bosc030 (INPUT "Main":U) NO-ERROR.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCarregaBloqueio wMaintenance 
PROCEDURE piCarregaBloqueio :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAMETER p-tipo-bloq AS INTEGER NO-UNDO.

    FOR EACH ttBloqueio. DELETE ttBloqueio. END.

    REPEAT i-cont = 1 TO brEndereco:NUM-SELECTED-ROWS IN FRAME fPage0:
        BROWSE brEndereco:FETCH-SELECTED-ROW(i-cont).
        IF AVAIL ttResumo THEN DO:
            CREATE ttBloqueio.
            ASSIGN ttBloqueio.cod-estabel      = c-cod-estabel 
                   ttBloqueio.cod-local        = c-cod-local   
                   ttBloqueio.id-box           = ttResumo.id-box 
                   ttBloqueio.log-bloq-arm     = ttResumo.log-bloq-arm  
                   ttBloqueio.log-bloq-retir   = ttResumo.log-bloq-retir
                   ttBloqueio.idi-tip-bloq-box = p-tipo-bloq. /* 1-Armazenamento  2-Retirada */                
        END.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piMarcaArm wMaintenance 
PROCEDURE piMarcaArm :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAMETER p-log-bloq-arm AS logica NO-UNDO.

    REPEAT i-cont = 1 TO brEndereco:NUM-SELECTED-ROWS IN FRAME fPage0:
        BROWSE brEndereco:FETCH-SELECTED-ROW(i-cont).
        IF AVAIL ttResumo THEN
            ASSIGN ttResumo.log-bloq-arm = p-log-bloq-arm.
    END.
    brEndereco:REFRESH().
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piMarcaRetir wMaintenance 
PROCEDURE piMarcaRetir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAMETER p-log-bloq-retir AS LOGICAL NO-UNDO.

    REPEAT i-cont = 1 TO brEndereco:NUM-SELECTED-ROWS IN FRAME fPage0:
        BROWSE brEndereco:FETCH-SELECTED-ROW(i-cont).
        IF AVAIL ttResumo THEN
            ASSIGN ttResumo.log-bloq-retir = p-log-bloq-retir.
    END.
    brEndereco:REFRESH().
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnData wMaintenance 
FUNCTION fnData RETURNS DATE
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    
    FOR EACH wm-box-saldo
         where wm-box-saldo.cod-estabel       = ttWm-saldo-estoque.cod-estabel
           and wm-box-saldo.cod-local         = ttWm-saldo-estoque.cod-local
           and wm-box-saldo.cod-item          = ttWm-saldo-estoque.cod-item
           and wm-box-saldo.cod-cliente       = ttWm-saldo-estoque.cod-cliente
           and wm-box-saldo.cod-refer         = ""
           and wm-box-saldo.cod-lote          = ""
           AND wm-box-saldo.id-box            = ttResumo.id-box
           and wm-box-saldo.qtd-item          > wm-box-saldo.qtd-item-bloq
           and wm-box-saldo.ind-status-saldo  = 3 /* liberado */ no-lock,
         first wm-box
         where wm-box.cod-estabel       = wm-box-saldo.cod-estabel
           and wm-box.cod-local         = wm-box-saldo.cod-local
         /*  and wm-box.log-bloq-retir    = NO /** Liberado Retirada **/ */
           and wm-box.id-box            = wm-box-saldo.id-box no-lock,
         first wm-tipo-box /* normal */ where 
               (wm-tipo-box.ind-status-box  = 1 or
                wm-tipo-box.ind-status-box  = 2) and 
                wm-tipo-box.cdn-tipo-box    = wm-box.cdn-tipo-box no-lock,                    
         FIRST wm-item-embalagem-local
         WHERE wm-item-embalagem-local.cod-estabel   = wm-box-saldo.cod-estabel
           AND wm-item-embalagem-local.cod-local     = wm-box-saldo.cod-local 
           AND wm-item-embalagem-local.cod-item      = wm-box-saldo.cod-item
           AND wm-item-embalagem-local.cod-embalagem = wm-box-saldo.cod-embalagem NO-LOCK
             by wm-box-saldo.dt-transacao    
             by wm-box-saldo.cod-cliente
             by wm-box-saldo.cod-estabel
             by wm-box-saldo.cod-local
             by wm-box-saldo.cod-item
             by wm-box-saldo.cod-refer
             by wm-box-saldo.cod-lote
             by wm-box-saldo.ind-status-saldo
             by wm-box-saldo.qtd-item - wm-box-saldo.qtd-item-bloq
             by wm-box.cod-bloco            
             by wm-box.cod-rua              
             by wm-box.cod-coluna           
             by wm-box.cod-nivel   
             BY wm-item-embalagem-local.qtd-volume.
        
        RETURN  wm-box-saldo.dt-transacao.
    
    END.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnEnderecoBox wMaintenance 
FUNCTION fnEnderecoBox RETURNS CHARACTER
  ( INPUT pCodEstabel AS CHAR,
    INPUT pCodLocal AS CHAR,
    INPUT pIdBox   AS DEC ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEF VAR c-cod-endereco AS CHAR NO-UNDO.
    

    RUN retornaEnderecoBox4 IN h-bosc030 (INPUT pCodEstabel,
                                         INPUT pCodLocal ,
                                         INPUT pIdBox,
                                         OUTPUT c-cod-endereco).

    RETURN c-cod-endereco.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnGetIndStatus wMaintenance 
FUNCTION fnGetIndStatus RETURNS CHARACTER
  ( INPUT pIndStatus AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-status AS CHARACTER FORMAT "X(20)" NO-UNDO.

    &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
        DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.        
        ASSIGN cAuxTraducao001 = {scinc/i01sc030.i 04 pIndStatus}.
        run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao001)," ","_"),
                            INPUT "",
                            INPUT "").
        ASSIGN  c-status = RETURN-VALUE.
    &else
        ASSIGN c-status = {scinc/i01sc030.i 04 pIndStatus}.
    &endif
    RETURN c-status.   
    
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnGetIndStatusSaldo wMaintenance 
FUNCTION fnGetIndStatusSaldo RETURNS CHARACTER
  ( INPUT pIndSituacao AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-ind-status AS CHARACTER FORMAT "X(20)" NO-UNDO.

    &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
        DEFINE VARIABLE cAuxTraducao002 AS CHARACTER NO-UNDO.
        ASSIGN cAuxTraducao002 = {scinc/i01sc035.i 04 pIndSituacao}.
        run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao002)," ","_"),
                            INPUT "",
                            INPUT "").
        ASSIGN  c-ind-status = RETURN-VALUE.
    &else
        ASSIGN c-ind-status = {scinc/i01sc035.i 04 pIndSituacao}.
    &endif
    RETURN c-ind-status.   
    
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnGetQuantidadeBloq wMaintenance 
FUNCTION fnGetQuantidadeBloq RETURNS DECIMAL
  ( INPUT p-qtd-item-bloq AS DECIMAL,
    INPUT p-qtd-item-alocad AS DECIMAL ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    RETURN p-qtd-item-bloq + p-qtd-item-alocad.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnGetStatusArm wMaintenance 
FUNCTION fnGetStatusArm RETURNS LOGICAL
  ( INPUT pCodEstabel AS CHAR,
    INPUT pCodLocal   AS CHAR,
    INPUT pIdBox      AS DEC ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    FOR FIRST bfwm-box FIELDS(log-bloq-arm)
        WHERE bfwm-box.cod-estabel = pCodEstabel AND
              bfwm-box.cod-local   = pCodLocal   AND
              bfwm-box.id-box      = pIdBox      NO-LOCK.
    END.

    RETURN bfwm-box.log-bloq-arm.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnGetStatusRet wMaintenance 
FUNCTION fnGetStatusRet RETURNS LOGICAL
  ( INPUT pCodEstabel AS CHAR,
    INPUT pCodLocal   AS CHAR,
    INPUT pIdBox      AS DEC ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    FOR FIRST bfwm-box FIELDS(log-bloq-retir)
        WHERE bfwm-box.cod-estabel = pCodEstabel AND
              bfwm-box.cod-local   = pCodLocal   AND
              bfwm-box.id-box      = pIdBox      NO-LOCK.
    END.

    RETURN bfwm-box.log-bloq-retir.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


