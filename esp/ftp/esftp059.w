&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcad            PROGRESS
          mgesp            PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenance


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttint-natur-est-mapa NO-UNDO LIKE int-natur-est-mapa
       field r-Rowid as rowid.
DEFINE TEMP-TABLE ttit-natureza-ped-fiscal NO-UNDO LIKE it-natureza-ped-fiscal
       field r-rowid as rowid.
DEFINE TEMP-TABLE ttnatur-oper-ped-fiscal NO-UNDO LIKE natur-oper-ped-fiscal
       field r-rowid as rowid.
DEFINE TEMP-TABLE ttnatureza-ped-fiscal NO-UNDO LIKE natureza-ped-fiscal
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMaintenance 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESFTP059 2.12.00.001}

/* Chamada a include do gerenciador de licenáas. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i ESFTP059 MFT}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESFTP059
&GLOBAL-DEFINE Version        2.12.00.001

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1

&GLOBAL-DEFINE FolderLabels   Itens, Mapas, Geral, Narrativa, Nat Oper

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

&GLOBAL-DEFINE ttTable        ttnatureza-ped-fiscal
&GLOBAL-DEFINE hDBOTable      hbnatureza-ped-fiscal
&GLOBAL-DEFINE DBOTable       natureza-ped-fiscal

&GLOBAL-DEFINE page0KeyFields ttnatureza-ped-fiscal.descricao ttnatureza-ped-fiscal.natureza
&GLOBAL-DEFINE page0Fields    ttnatureza-ped-fiscal.lib-auto ttnatureza-ped-fiscal.lib-monitor ttnatureza-ped-fiscal.informa-receptor ttnatureza-ped-fiscal.informa-finalidade
&GLOBAL-DEFINE page1Fields    
&GLOBAL-DEFINE page2Fields    
&GLOBAL-DEFINE page3Fields    ttnatureza-ped-fiscal.Ind-hab-ger-it-ind ttnatureza-ped-fiscal.Ind-hab-ger-it-trans ttnatureza-ped-fiscal.Ind-hab-ger-it  ttnatureza-ped-fiscal.Ind-nat-transf ttnatureza-ped-fiscal.Ind-hab-ger-nf-dev ttnatureza-ped-fiscal.Ind-valida-it-fatur ttnatureza-ped-fiscal.Ind-mail-supervisor
&GLOBAL-DEFINE page4Fields    ttnatureza-ped-fiscal.narrativa
&GLOBAL-DEFINE page1Browse    br-item
&GLOBAL-DEFINE page2Browse    br-mapas
&GLOBAL-DEFINE page5Browse    br-nat-oper


/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable} AS HANDLE NO-UNDO.
DEFINE VARIABLE wh-pesquisa                       AS HANDLE       NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl  AS HANDLE       NO-UNDO.

DEF TEMP-TABLE tt-it-natureza-ped-fiscal
    FIELD it-codigo   LIKE Linha-item.it-codigo.

DEFINE BUTTON    btGoToOK     AUTO-GO LABEL "&OK" SIZE 10 BY 1 BGCOLOR 8.
DEFINE BUTTON    btGoToCancel AUTO-GO LABEL "&Cancela" SIZE 10 BY 1 BGCOLOR 8.

DEFINE RECTANGLE rtGoToFields  EDGE-PIXELS 2 GRAPHIC-EDGE SIZE 65 BY 8.3 BGCOLOR 8.
DEFINE RECTANGLE rtGoToButton  EDGE-PIXELS 2 GRAPHIC-EDGE SIZE 72 BY 1.5 BGCOLOR 7.

DEFINE VARIABLE c-item      LIKE linha-item.it-codigo   LABEL "Item"      VIEW-AS FILL-IN  SIZE 10 BY .88 NO-UNDO.
DEFINE VARIABLE c-descricao LIKE lin-prod.descricao     LABEL ""          VIEW-AS FILL-IN  SIZE 50 BY .88 NO-UNDO.
DEFINE VARIABLE c-sugere AS CHARACTER   NO-UNDO.
DEF VAR l-resp AS LOGICAL INITIAL NO NO-UNDO.

DEFINE VARIABLE c-descMapa AS CHARACTER FORMAT 'x(40)':U NO-UNDO.
DEFINE VARIABLE c-descNat AS CHARACTER FORMAT 'x(40)':U NO-UNDO.
DEFINE VARIABLE l-habilita-desc AS LOG INIT NO NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Maintenance
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-item

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ttit-natureza-ped-fiscal item ~
ttint-natur-est-mapa ttnatur-oper-ped-fiscal

/* Definitions for BROWSE br-item                                       */
&Scoped-define FIELDS-IN-QUERY-br-item ttit-natureza-ped-fiscal.it-codigo item.desc-item fnSugere(ttit-natureza-ped-fiscal.log-sugere-ncm) @ c-sugere   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-item   
&Scoped-define SELF-NAME br-item
&Scoped-define QUERY-STRING-br-item FOR EACH ttit-natureza-ped-fiscal NO-LOCK, ~
             EACH item       WHERE item.it-codigo = ttit-natureza-ped-fiscal.it-codigo NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br-item OPEN QUERY {&SELF-NAME} FOR EACH ttit-natureza-ped-fiscal NO-LOCK, ~
             EACH item       WHERE item.it-codigo = ttit-natureza-ped-fiscal.it-codigo NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br-item ttit-natureza-ped-fiscal item
&Scoped-define FIRST-TABLE-IN-QUERY-br-item ttit-natureza-ped-fiscal
&Scoped-define SECOND-TABLE-IN-QUERY-br-item item


/* Definitions for BROWSE br-mapas                                      */
&Scoped-define FIELDS-IN-QUERY-br-mapas ttint-natur-est-mapa.cod-estabel ttint-natur-est-mapa.cod-mapa-distrib-cc fnDescMapa(ttint-natur-est-mapa.cod-estabel, ttint-natur-est-mapa.cod-mapa-distrib-cc) @ c-descMapa   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-mapas   
&Scoped-define SELF-NAME br-mapas
&Scoped-define QUERY-STRING-br-mapas FOR EACH ttint-natur-est-mapa NO-LOCK
&Scoped-define OPEN-QUERY-br-mapas OPEN QUERY {&SELF-NAME} FOR EACH ttint-natur-est-mapa NO-LOCK.
&Scoped-define TABLES-IN-QUERY-br-mapas ttint-natur-est-mapa
&Scoped-define FIRST-TABLE-IN-QUERY-br-mapas ttint-natur-est-mapa


/* Definitions for BROWSE br-nat-oper                                   */
&Scoped-define FIELDS-IN-QUERY-br-nat-oper ttnatur-oper-ped-fiscal.nat-operacao fnDescNat(ttnatur-oper-ped-fiscal.nat-operacao) @ c-descNat   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-nat-oper   
&Scoped-define SELF-NAME br-nat-oper
&Scoped-define QUERY-STRING-br-nat-oper FOR EACH ttnatur-oper-ped-fiscal NO-LOCK
&Scoped-define OPEN-QUERY-br-nat-oper OPEN QUERY {&SELF-NAME} FOR EACH ttnatur-oper-ped-fiscal NO-LOCK.
&Scoped-define TABLES-IN-QUERY-br-nat-oper ttnatur-oper-ped-fiscal
&Scoped-define FIRST-TABLE-IN-QUERY-br-nat-oper ttnatur-oper-ped-fiscal


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-br-item}

/* Definitions for FRAME fPage2                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage2 ~
    ~{&OPEN-QUERY-br-mapas}

/* Definitions for FRAME fPage5                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage5 ~
    ~{&OPEN-QUERY-br-nat-oper}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ttnatureza-ped-fiscal.natureza ~
ttnatureza-ped-fiscal.descricao ttnatureza-ped-fiscal.lib-auto ~
ttnatureza-ped-fiscal.informa-receptor ~
ttnatureza-ped-fiscal.informa-finalidade ttnatureza-ped-fiscal.lib-monitor 
&Scoped-define ENABLED-TABLES ttnatureza-ped-fiscal
&Scoped-define FIRST-ENABLED-TABLE ttnatureza-ped-fiscal
&Scoped-Define ENABLED-OBJECTS rtToolBar rtKeys rtKeys-3 btFirst btPrev ~
btNext btLast btGoTo btSearch btAdd btCopy btUpdate btDelete btUndo ~
btCancel btSave btQueryJoins btReportsJoins btExit btHelp 
&Scoped-Define DISPLAYED-FIELDS ttnatureza-ped-fiscal.natureza ~
ttnatureza-ped-fiscal.descricao ttnatureza-ped-fiscal.lib-auto ~
ttnatureza-ped-fiscal.informa-receptor ~
ttnatureza-ped-fiscal.informa-finalidade ttnatureza-ped-fiscal.lib-monitor 
&Scoped-define DISPLAYED-TABLES ttnatureza-ped-fiscal
&Scoped-define FIRST-DISPLAYED-TABLE ttnatureza-ped-fiscal


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDescMapa wMaintenance 
FUNCTION fnDescMapa RETURNS CHARACTER
  ( c-estab AS CHARACTER, c-mapa AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDescNat wMaintenance 
FUNCTION fnDescNat RETURNS CHARACTER
  ( c-nat-oper AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnSugere wMaintenance 
FUNCTION fnSugere RETURNS CHARACTER
  ( p-sugere AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
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

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 1.33.

DEFINE RECTANGLE rtKeys-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 1.33.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE BUTTON bt-excluir 
     LABEL "Excluir" 
     SIZE 15 BY 1.

DEFINE BUTTON bt-incluir 
     LABEL "Incluir" 
     SIZE 15 BY 1.

DEFINE BUTTON bt-excluir-mapas 
     LABEL "Excluir" 
     SIZE 15 BY 1.

DEFINE BUTTON bt-incluir-mapas 
     LABEL "Incluir" 
     SIZE 15 BY 1.

DEFINE RECTANGLE RECT-17
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 76 BY 6.25.

DEFINE BUTTON bt-excluir-nat-oper 
     LABEL "Excluir" 
     SIZE 15 BY 1.

DEFINE BUTTON bt-incluir-nat-oper 
     LABEL "Incluir" 
     SIZE 15 BY 1.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-item FOR 
      ttit-natureza-ped-fiscal, 
      item SCROLLING.

DEFINE QUERY br-mapas FOR 
      ttint-natur-est-mapa SCROLLING.

DEFINE QUERY br-nat-oper FOR 
      ttnatur-oper-ped-fiscal SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-item
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-item wMaintenance _FREEFORM
  QUERY br-item NO-LOCK DISPLAY
      ttit-natureza-ped-fiscal.it-codigo FORMAT "x(16)":U
      item.desc-item FORMAT "x(60)":U WIDTH 55
      fnSugere(ttit-natureza-ped-fiscal.log-sugere-ncm) @ c-sugere COLUMN-LABEL "Sugere NCM"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 81 BY 8.71
         FONT 1 FIT-LAST-COLUMN.

DEFINE BROWSE br-mapas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-mapas wMaintenance _FREEFORM
  QUERY br-mapas NO-LOCK DISPLAY
      ttint-natur-est-mapa.cod-estabel
      ttint-natur-est-mapa.cod-mapa-distrib-cc
      fnDescMapa(ttint-natur-est-mapa.cod-estabel, ttint-natur-est-mapa.cod-mapa-distrib-cc) @ c-descMapa COLUMN-LABEL "Descriá∆o":U FORMAT 'x(40)':U WIDTH 40
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 81 BY 8.71
         FONT 1 FIT-LAST-COLUMN.

DEFINE BROWSE br-nat-oper
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-nat-oper wMaintenance _FREEFORM
  QUERY br-nat-oper NO-LOCK DISPLAY
      ttnatur-oper-ped-fiscal.nat-operacao
      fnDescNat(ttnatur-oper-ped-fiscal.nat-operacao) @ c-descNat COLUMN-LABEL "Descriá∆o":U FORMAT 'x(40)':U WIDTH 40
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 81 BY 8.71
         FONT 1 FIT-LAST-COLUMN.


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
     btQueryJoins AT ROW 1.13 COL 74.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda"
     ttnatureza-ped-fiscal.natureza AT ROW 2.88 COL 16.57 COLON-ALIGNED WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 4.72 BY .88
     ttnatureza-ped-fiscal.descricao AT ROW 2.88 COL 21.57 COLON-ALIGNED NO-LABEL WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 60 BY .88
     ttnatureza-ped-fiscal.lib-auto AT ROW 4.42 COL 18.57 WIDGET-ID 6
          VIEW-AS TOGGLE-BOX
          SIZE 18.43 BY .88
     ttnatureza-ped-fiscal.informa-receptor AT ROW 4.42 COL 38.57 WIDGET-ID 10
          VIEW-AS TOGGLE-BOX
          SIZE 16 BY .88
     ttnatureza-ped-fiscal.informa-finalidade AT ROW 4.42 COL 56.57 HELP
          "Indica se habilita ou n∆o a finalidade da mercadoria (ESFTP012)" WIDGET-ID 24
          VIEW-AS TOGGLE-BOX
          SIZE 17 BY .88
     ttnatureza-ped-fiscal.lib-monitor AT ROW 4.42 COL 82.58 RIGHT-ALIGNED WIDGET-ID 8
          VIEW-AS TOGGLE-BOX
          SIZE 7.86 BY .88
     rtToolBar AT ROW 1 COL 1
     rtKeys AT ROW 2.67 COL 1
     rtKeys-3 AT ROW 4.17 COL 1 WIDGET-ID 22
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17.13
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fpage3
     ttnatureza-ped-fiscal.ind-hab-ger-it AT ROW 3.5 COL 11.72 WIDGET-ID 14
          VIEW-AS TOGGLE-BOX
          SIZE 21 BY .83
     ttnatureza-ped-fiscal.ind-hab-ger-it-trans AT ROW 3.5 COL 48 WIDGET-ID 18
          VIEW-AS TOGGLE-BOX
          SIZE 30 BY .83
     ttnatureza-ped-fiscal.ind-hab-ger-it-ind AT ROW 4.75 COL 11.72 WIDGET-ID 16
          VIEW-AS TOGGLE-BOX
          SIZE 27 BY .83
     ttnatureza-ped-fiscal.Ind-valida-it-fatur AT ROW 4.75 COL 48 WIDGET-ID 20
          VIEW-AS TOGGLE-BOX
          SIZE 27 BY .83
     ttnatureza-ped-fiscal.Ind-hab-ger-nf-dev AT ROW 6 COL 11.72 WIDGET-ID 22
          VIEW-AS TOGGLE-BOX
          SIZE 29 BY .83
     ttnatureza-ped-fiscal.ind-nat-transf AT ROW 6 COL 48 WIDGET-ID 24
          VIEW-AS TOGGLE-BOX
          SIZE 27 BY .83
     ttnatureza-ped-fiscal.Ind-mail-supervisor AT ROW 7.25 COL 11.72 WIDGET-ID 28
          LABEL "Enviar e-mail p/ Supervisor?"
          VIEW-AS TOGGLE-BOX
          SIZE 24 BY .83
     RECT-17 AT ROW 2.5 COL 6 WIDGET-ID 26
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 6.83
         SIZE 84.43 BY 10.5
         FONT 1 WIDGET-ID 500.

DEFINE FRAME fPage5
     br-nat-oper AT ROW 1.25 COL 2.57 WIDGET-ID 400
     bt-incluir-nat-oper AT ROW 10.25 COL 2.57 WIDGET-ID 2
     bt-excluir-nat-oper AT ROW 10.25 COL 18 WIDGET-ID 6
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 6.83
         SIZE 84.43 BY 10.5
         FONT 1 WIDGET-ID 700.

DEFINE FRAME fPage2
     br-mapas AT ROW 1.25 COL 2.57 WIDGET-ID 400
     bt-incluir-mapas AT ROW 10.25 COL 2.57 WIDGET-ID 2
     bt-excluir-mapas AT ROW 10.25 COL 18 WIDGET-ID 6
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 6.83
         SIZE 84.43 BY 10.5
         FONT 1 WIDGET-ID 300.

DEFINE FRAME fpage4
     ttnatureza-ped-fiscal.narrativa AT ROW 2 COL 4 NO-LABEL WIDGET-ID 20
          VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
          SIZE 78 BY 8.25
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 6.83
         SIZE 84.43 BY 10.5
         FONT 1 WIDGET-ID 600.

DEFINE FRAME fPage1
     br-item AT ROW 1.25 COL 2.57 WIDGET-ID 200
     bt-incluir AT ROW 10.25 COL 2.57 WIDGET-ID 2
     bt-excluir AT ROW 10.25 COL 18 WIDGET-ID 6
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 6.83
         SIZE 84.43 BY 10.5
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Maintenance
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: ttint-natur-est-mapa T "?" NO-UNDO mgesp int-natur-est-mapa
      ADDITIONAL-FIELDS:
          field r-Rowid as rowid
      END-FIELDS.
      TABLE: ttit-natureza-ped-fiscal T "?" NO-UNDO mgesp it-natureza-ped-fiscal
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: ttnatur-oper-ped-fiscal T "?" NO-UNDO mgesp natur-oper-ped-fiscal
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: ttnatureza-ped-fiscal T "?" NO-UNDO mgesp natureza-ped-fiscal
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
         HEIGHT             = 17.13
         WIDTH              = 90
         MAX-HEIGHT         = 17.13
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 17.13
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
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE
       FRAME fPage2:FRAME = FRAME fpage0:HANDLE
       FRAME fpage3:FRAME = FRAME fpage0:HANDLE
       FRAME fpage4:FRAME = FRAME fpage0:HANDLE
       FRAME fPage5:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR TOGGLE-BOX ttnatureza-ped-fiscal.informa-finalidade IN FRAME fpage0
   EXP-HELP                                                             */
/* SETTINGS FOR TOGGLE-BOX ttnatureza-ped-fiscal.lib-monitor IN FRAME fpage0
   ALIGN-R                                                              */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB br-item 1 fPage1 */
/* SETTINGS FOR FRAME fPage2
                                                                        */
/* BROWSE-TAB br-mapas 1 fPage2 */
/* SETTINGS FOR FRAME fpage3
                                                                        */
/* SETTINGS FOR TOGGLE-BOX natureza-ped-fiscal.Ind-mail-supervisor IN FRAME fpage3
   EXP-LABEL                                                            */
/* SETTINGS FOR FRAME fpage4
                                                                        */
/* SETTINGS FOR FRAME fPage5
                                                                        */
/* BROWSE-TAB br-nat-oper 1 fPage5 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMaintenance)
THEN wMaintenance:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-item
/* Query rebuild information for BROWSE br-item
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH ttit-natureza-ped-fiscal NO-LOCK,
      EACH item
      WHERE item.it-codigo = ttit-natureza-ped-fiscal.it-codigo NO-LOCK INDEXED-REPOSITION.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[2]         = "mgcad.item.it-codigo = ttit-natureza-ped-fiscal.it-codigo"
     _Query            is OPENED
*/  /* BROWSE br-item */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-mapas
/* Query rebuild information for BROWSE br-mapas
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH ttint-natur-est-mapa NO-LOCK
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Query            is OPENED
*/  /* BROWSE br-mapas */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-nat-oper
/* Query rebuild information for BROWSE br-nat-oper
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH ttnatur-oper-ped-fiscal NO-LOCK
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Query            is OPENED
*/  /* BROWSE br-nat-oper */
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

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage2
/* Query rebuild information for FRAME fPage2
     _Query            is NOT OPENED
*/  /* FRAME fPage2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage3
/* Query rebuild information for FRAME fpage3
     _Query            is NOT OPENED
*/  /* FRAME fpage3 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage4
/* Query rebuild information for FRAME fpage4
     _Query            is NOT OPENED
*/  /* FRAME fpage4 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage5
/* Query rebuild information for FRAME fPage5
     _Query            is NOT OPENED
*/  /* FRAME fPage5 */
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
ON ENTRY OF FRAME fpage0
DO:
    /* Itens */
    br-item   :SENSITIVE IN FRAME fpage1 = TRUE.  
    bt-incluir:SENSITIVE IN FRAME fpage1 = TRUE. 
    bt-excluir:SENSITIVE IN FRAME fpage1 = TRUE. 

    RUN PiMonta.
  
    /* Mapas */
    br-mapas  :SENSITIVE       IN FRAME fpage2 = TRUE.  
    bt-incluir-mapas:SENSITIVE IN FRAME fpage2 = TRUE. 
    bt-excluir-mapas:SENSITIVE IN FRAME fpage2 = TRUE. 

    RUN piMonta-mapas.

    /* Nat Oper */
    br-nat-oper  :SENSITIVE       IN FRAME fpage5 = TRUE.  
    bt-incluir-nat-oper:SENSITIVE IN FRAME fpage5 = TRUE. 
    bt-excluir-nat-oper:SENSITIVE IN FRAME fpage5 = TRUE. 

    RUN piMonta-nat-oper.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME bt-excluir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-excluir wMaintenance
ON CHOOSE OF bt-excluir IN FRAME fPage1 /* Excluir */
DO:
    DEFINE VARIABLE c-it-codigo AS CHARACTER INIT ? NO-UNDO.

    IF  can-find(FIRST ttit-natureza-ped-fiscal
                 WHERE ttit-natureza-ped-fiscal.natureza = ttnatureza-ped-fiscal.natureza) THEN DO:
    
        MESSAGE "Deseja excluir o registro selecionado?" 
                 UPDATE l-resp
                 VIEW-AS ALERT-BOX
                 QUESTION BUTTONS YES-NO
                 TITLE "Exclus∆o de dados".
    
        IF  l-resp = YES THEN DO:
            FIND FIRST it-natureza-ped-fiscal EXCLUSIVE-LOCK 
                WHERE  it-natureza-ped-fiscal.natureza  = ttit-natureza-ped-fiscal.natureza
                AND    it-natureza-ped-fiscal.it-codigo = ttit-natureza-ped-fiscal.it-codigo NO-ERROR.
            IF  AVAIL  it-natureza-ped-fiscal THEN DO:
                find last ttit-natureza-ped-fiscal                                                            
                    where ttit-natureza-ped-fiscal.it-codigo < it-natureza-ped-fiscal.it-codigo no-error.     
    
                if  avail ttit-natureza-ped-fiscal then c-it-codigo = ttit-natureza-ped-fiscal.it-codigo.
    
                DELETE it-natureza-ped-fiscal.
    
                RUN PiMonta.    
                
            END. /* IF  AVAIL  it-natureza-ped-fiscal THEN */
        END. /* IF  l-resp = YES THEN DO: */
    END. /* IF  can-find(FIRST ttit-natureza-ped-fiscal */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME bt-excluir-mapas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-excluir-mapas wMaintenance
ON CHOOSE OF bt-excluir-mapas IN FRAME fPage2 /* Excluir */
DO:
    DEFINE VARIABLE c-cod-estabel AS CHARACTER INIT ? NO-UNDO.
    DEFINE VARIABLE c-cod-mapa    AS CHARACTER INIT ? NO-UNDO.

    IF  can-find(FIRST ttint-natur-est-mapa
                 WHERE ttint-natur-est-mapa.natureza = ttnatureza-ped-fiscal.natureza) THEN DO:  
        
        MESSAGE "Deseja excluir o registro selecionado?" 
                 UPDATE l-resp
                 VIEW-AS ALERT-BOX
                 QUESTION BUTTONS YES-NO
                 TITLE "Exclus∆o de dados".
        
        IF  l-resp = YES THEN DO:
            FIND FIRST int-natur-est-mapa EXCLUSIVE-LOCK 
                WHERE  int-natur-est-mapa.natureza            = ttint-natur-est-mapa.natureza  
                AND    int-natur-est-mapa.cod-estabel         = ttint-natur-est-mapa.cod-estabel
                AND    int-natur-est-mapa.cod-mapa-distrib-cc = ttint-natur-est-mapa.cod-mapa-distrib-cc NO-ERROR.
            IF  AVAIL  int-natur-est-mapa THEN DO:
                find last ttint-natur-est-mapa 
                    where ttint-natur-est-mapa.cod-estabel         < int-natur-est-mapa.cod-estabel 
                    AND   ttint-natur-est-mapa.cod-mapa-distrib-cc < int-natur-est-mapa.cod-mapa-distrib-cc no-error.    
               if  avail  ttint-natur-est-mapa then ASSIGN c-cod-estabel = ttint-natur-est-mapa.cod-estabel
                                                            c-cod-mapa    = ttint-natur-est-mapa.cod-mapa-distrib-cc.
               DELETE int-natur-est-mapa.

               RUN piMonta-mapas.

               if   c-cod-estabel ne ? AND c-cod-mapa ne ? then do:
                    find first ttint-natur-est-mapa
                        where  ttint-natur-est-mapa.cod-estabel         = c-cod-estabel 
                        and    ttint-natur-est-mapa.cod-mapa-distrib-cc = c-cod-mapa no-error.
                    reposition br-mapas to rowid rowid(ttint-natur-est-mapa).
                    browse br-mapas:refresh().
               end.
            END.
        END.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage5
&Scoped-define SELF-NAME bt-excluir-nat-oper
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-excluir-nat-oper wMaintenance
ON CHOOSE OF bt-excluir-nat-oper IN FRAME fPage5 /* Excluir */
DO: 

    IF  can-find(FIRST ttnatur-oper-ped-fiscal
                 WHERE ttnatur-oper-ped-fiscal.natureza = ttnatureza-ped-fiscal.natureza) THEN DO:  
        
        MESSAGE "Deseja excluir o registro selecionado?" 
                 UPDATE l-resp
                 VIEW-AS ALERT-BOX
                 QUESTION BUTTONS YES-NO
                 TITLE "Exclus∆o de dados".
        
        IF  l-resp = YES THEN DO:
            FIND FIRST natur-oper-ped-fiscal EXCLUSIVE-LOCK 
                 WHERE natur-oper-ped-fiscal.natureza     = ttnatur-oper-ped-fiscal.natureza
                   AND natur-oper-ped-fiscal.nat-operacao = ttnatur-oper-ped-fiscal.nat-operacao NO-ERROR.
                                                            
            DELETE natur-oper-ped-fiscal.

            RUN piMonta-nat-oper.
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME bt-incluir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-incluir wMaintenance
ON CHOOSE OF bt-incluir IN FRAME fPage1 /* Incluir */
DO:
    IF  AVAIL ttnatureza-ped-fiscal THEN DO:
        RUN esp/ftp/esftp059a.w (INPUT ttnatureza-ped-fiscal.natureza).
        RUN PiMonta.
    END. /* IF  AVAIL ttnatureza-ped-fiscal */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME bt-incluir-mapas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-incluir-mapas wMaintenance
ON CHOOSE OF bt-incluir-mapas IN FRAME fPage2 /* Incluir */
DO:
    IF  AVAIL ttnatureza-ped-fiscal THEN DO:
        RUN esp/ftp/esftp059b.w (INPUT ttnatureza-ped-fiscal.natureza).
        RUN piMonta-mapas.
    END. /* IF  AVAIL ttnatureza-ped-fiscal */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage5
&Scoped-define SELF-NAME bt-incluir-nat-oper
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-incluir-nat-oper wMaintenance
ON CHOOSE OF bt-incluir-nat-oper IN FRAME fPage5 /* Incluir */
DO:
    IF  AVAIL ttnatureza-ped-fiscal THEN DO:
        RUN esp/ftp/esftp059c.w (INPUT ttnatureza-ped-fiscal.natureza).
        RUN piMonta-nat-oper.
    END. /* IF  AVAIL ttnatureza-ped-fiscal */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
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
    ASSIGN ttnatureza-ped-fiscal.descricao:SENSITIVE IN FRAME fpage0 = NO.
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
    ASSIGN ttnatureza-ped-fiscal.descricao:SENSITIVE IN FRAME fpage0 = NO.
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
    RUN PiMonta.
    ASSIGN ttnatureza-ped-fiscal.descricao:SENSITIVE IN FRAME fpage0 = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btGoTo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btGoTo wMaintenance
ON CHOOSE OF btGoTo IN FRAME fpage0 /* Go To */
OR CHOOSE OF MENU-ITEM miGoTo IN MENU mbMain DO:
    RUN goToRecord IN THIS-PROCEDURE.
    RUN PiMonta.
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
    RUN PiMonta.
    ASSIGN ttnatureza-ped-fiscal.descricao:SENSITIVE IN FRAME fpage0 = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btNext
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btNext wMaintenance
ON CHOOSE OF btNext IN FRAME fpage0 /* Next */
OR CHOOSE OF MENU-ITEM miNext IN MENU mbMain DO:
    RUN getNext IN THIS-PROCEDURE.
    RUN PiMonta.
    ASSIGN ttnatureza-ped-fiscal.descricao:SENSITIVE IN FRAME fpage0 = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btPrev
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btPrev wMaintenance
ON CHOOSE OF btPrev IN FRAME fpage0 /* Prev */
OR CHOOSE OF MENU-ITEM miPrev IN MENU mbMain DO:
    RUN getPrev IN THIS-PROCEDURE.
    RUN PiMonta.
    ASSIGN ttnatureza-ped-fiscal.descricao:SENSITIVE IN FRAME fpage0 = NO.
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
    ASSIGN ttnatureza-ped-fiscal.descricao:SENSITIVE IN FRAME fpage0 = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSearch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSearch wMaintenance
ON CHOOSE OF btSearch IN FRAME fpage0 /* Search */
OR CHOOSE OF MENU-ITEM miSearch IN MENU mbMain DO:
    {method/zoomreposition.i &ProgramZoom="eszoom/z01es741.w"}
        RUN PiMonta.
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
    ASSIGN ttnatureza-ped-fiscal.descricao:SENSITIVE IN FRAME fpage0 = YES.
    l-habilita-desc = YES.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miAbout
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miAbout wMaintenance
ON CHOOSE OF MENU-ITEM miAbout /* Sobre... */
DO:
  {include/sobre.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-item
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenance 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{maintenance/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wMaintenance 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/
   
    DO WITH FRAME fpage0:
        IF  l-habilita-desc THEN 
            ASSIGN ttnatureza-ped-fiscal.descricao:SENSITIVE = YES.
        ELSE
            ASSIGN ttnatureza-ped-fiscal.descricao:SENSITIVE = NO.
    END.
              
    ASSIGN l-habilita-desc = NO.              

    RUN PiMonta.
    RUN piMonta-mapas.
    RUN piMonta-nat-oper.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeSaveFields wMaintenance 
PROCEDURE beforeSaveFields :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

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

    DEFINE VARIABLE c-natureza    LIKE {&ttTable}.natureza     NO-UNDO.
    
    DEFINE FRAME fGoToRecord
        c-natureza  AT ROW 1.21 COL 17.72 COLON-ALIGNED
        btGoToOK          AT ROW 3.63 COL 2.14
        btGoToCancel      AT ROW 3.63 COL 13
        rtGoToButton      AT ROW 3.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V† Para Natureza" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.
    
/*tech1139 - FO 1338.917 - 10/07/2006  */
    RUN utp/ut-trfrrp.p (input Frame fGoToRecord:Handle).
    {utp/ut-liter.i "V†_Para_natureza-ped-fiscal"}
    ASSIGN FRAME fGoToRecord:TITLE = RETURN-VALUE.
/*tech1139 - FO 1338.917 - 10/07/2006  */

    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN c-natureza.
        
        RUN goToKey IN {&hDBOTable} (INPUT c-natureza ).
        IF RETURN-VALUE = "NOK":U THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT "Natureza Pedido Fiscal":U).
            
            RETURN NO-APPLY.
        END.
        
        /*:T Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOTable} (OUTPUT rGoTo).
        
        /*:T Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).

        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    ENABLE c-natureza btGoToOK btGoToCancel 
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
       {&hDBOTable}:FILE-NAME <> "esbo/boes741.p":U THEN DO:
        {btb/btb008za.i1 esbo/boes741.p YES}
        {btb/btb008za.i2 esbo/boes741.p '' {&hDBOTable}}
    END.
    
    RUN setConstraintmain IN {&hDBOTable} NO-ERROR.
    RUN openQueryStatic   IN {&hDBOTable} (INPUT "main":U) NO-ERROR.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PiMonta wMaintenance 
PROCEDURE PiMonta :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

    IF  AVAIL ttnatureza-ped-fiscal THEN DO:
        EMPTY TEMP-TABLE ttit-natureza-ped-fiscal NO-ERROR.
        
        FOR EACH  it-natureza-ped-fiscal NO-LOCK
            WHERE it-natureza-ped-fiscal.natureza = ttnatureza-ped-fiscal.natureza:

            CREATE ttit-natureza-ped-fiscal.
            ASSIGN ttit-natureza-ped-fiscal.natureza  = it-natureza-ped-fiscal.natureza
                   ttit-natureza-ped-fiscal.it-codigo = it-natureza-ped-fiscal.it-codigo
                   ttit-natureza-ped-fiscal.log-sugere-ncm = it-natureza-ped-fiscal.log-sugere-ncm.

        END. /* FOR EACH  it-natureza-ped-fiscal */
    END. /* IF  AVAIL ttnatureza-ped-fiscal THEN DO: */

    {&OPEN-QUERY-br-item}
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piMonta-mapas wMaintenance 
PROCEDURE piMonta-mapas :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

    IF  AVAIL ttnatureza-ped-fiscal THEN DO:
        EMPTY TEMP-TABLE ttint-natur-est-mapa    NO-ERROR.
        
        FOR EACH  int-natur-est-mapa NO-LOCK
            WHERE int-natur-est-mapa.natureza = ttnatureza-ped-fiscal.natureza:

            CREATE ttint-natur-est-mapa.
            ASSIGN ttint-natur-est-mapa.natureza            = int-natur-est-mapa.natureza
                   ttint-natur-est-mapa.cod-estabel         = int-natur-est-mapa.cod-estabel
                   ttint-natur-est-mapa.cod-mapa-distrib-cc = int-natur-est-mapa.cod-mapa-distrib-cc.

        END. /* FOR EACH  int-natur-est-mapa */

    END. /* IF  AVAIL ttnatureza-ped-fiscal THEN DO: */

    {&OPEN-QUERY-br-mapas}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piMonta-nat-oper wMaintenance 
PROCEDURE piMonta-nat-oper :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

    IF  AVAIL ttnatureza-ped-fiscal THEN DO:
        EMPTY TEMP-TABLE ttnatur-oper-ped-fiscal    NO-ERROR.
        
        FOR EACH  natur-oper-ped-fiscal NO-LOCK
            WHERE natur-oper-ped-fiscal.natureza = ttnatureza-ped-fiscal.natureza:

            CREATE ttnatur-oper-ped-fiscal.
            BUFFER-COPY natur-oper-ped-fiscal TO ttnatur-oper-ped-fiscal.

        END. /* FOR EACH  int-natur-est-mapa */
    END. /* IF  AVAIL ttnatureza-ped-fiscal THEN DO: */

    {&OPEN-QUERY-br-nat-oper}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDescMapa wMaintenance 
FUNCTION fnDescMapa RETURNS CHARACTER
  ( c-estab AS CHARACTER, c-mapa AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    FIND FIRST mapa_distrib_ccusto NO-LOCK 
        WHERE  mapa_distrib_ccusto.cod_estab               = c-estab
        AND    mapa_distrib_ccusto.cod_mapa_distrib_ccusto = c-mapa NO-ERROR.
    IF  AVAIL  mapa_distrib_ccusto 
    THEN RETURN mapa_distrib_ccusto.des_mapa_distrib_ccusto.
    ELSE RETURN "":U.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDescNat wMaintenance 
FUNCTION fnDescNat RETURNS CHARACTER
  ( c-nat-oper AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    FIND FIRST natur-oper NO-LOCK 
         WHERE natur-oper.nat-operacao = c-nat-oper NO-ERROR.

    IF  AVAIL  natur-oper THEN 
        RETURN natur-oper.denominacao.
    ELSE 
        RETURN "":U.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnSugere wMaintenance 
FUNCTION fnSugere RETURNS CHARACTER
  ( p-sugere AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  IF p-sugere THEN
      RETURN "Sim".
  ELSE 
      RETURN "N∆o".

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

