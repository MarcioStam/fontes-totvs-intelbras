&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcad           PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenance


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttdeposito NO-UNDO LIKE deposito
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
{include/i-prgvrs.i ESCEP003 2.04.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESCEP003
&GLOBAL-DEFINE Version        1

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1

&GLOBAL-DEFINE FolderLabels   Saldo Item, Saldo Valor

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

&GLOBAL-DEFINE ttTable        ttdeposito
&GLOBAL-DEFINE hDBOTable      hBOdeposito
&GLOBAL-DEFINE DBOTable       deposito

&GLOBAL-DEFINE page0KeyFields ttdeposito.cod-depos 
&GLOBAL-DEFINE page0Fields    ttdeposito.cod-depos ttdeposito.nome
&GLOBAL-DEFINE page1Fields    
&GLOBAL-DEFINE page2Fields

         

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable} AS HANDLE NO-UNDO.

DEF VAR wh-pesquisa AS HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR adm-broker-hdl AS HANDLE NO-UNDO.

{esp/cep/escep003tt.i}

DEFINE BUFFER b-tt-itens FOR tt-itens.

def var de-valor-item   as dec format ">>>>,>>9.99" label "Valor".

def var de-saldo-alm    like saldo-estoq.qtidade-atu.

def var c-loc-ini       like item.cod-localiz.
def var c-loc-fim       like item.cod-localiz   initial "ZZZZZZZZZZZZZZZZZZZZ".
def var i-ge-ini        like item.ge-codigo     initial 00.
def var i-ge-fim        like item.ge-codigo     initial 99.
def var c-fm-ini        like item.fm-codigo     initial "".
def var c-fm-fim        like item.fm-codigo     initial "ZZZZZZZZ".
def var c-it-ini        like item.it-codigo     initial "".
def var c-it-fim        like item.it-codigo     initial "ZZZZZZZZZZZZZZZZZZZZZZ".
def var c-comprador-ini like item.cod-comprado  initial "".
def var c-comprador-fim like item.cod-comprado  initial "ZZZZZZZZZZZZZ".

DEF VAR l-ativo         AS LOGICAL INIT YES.
DEF VAR l-obsoleto-auto AS LOGICAL INIT YES.
DEF VAR l-obsoleto      AS LOGICAL INIT YES.
DEF VAR l-total         AS LOGICAL INIT YES.

def var i-mat           as INTEGER INIT 2.

def var de-val-unit     as dec.
def var de-val-mat      as dec.
def var de-val-mob      as dec.
def var de-val-ggf      as dec.

DEF NEW GLOBAL SHARED VAR pescep003 LIKE ITEM.it-codigo NO-UNDO.

DEF VAR hproc AS HANDLE NO-UNDO.

DEF VAR l-connect AS LOGICAL NO-UNDO.

{upc\btb910za-upc.i}
{esp/es0018.i}
{esp/utp/acesso-rpc.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Maintenance
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME britem

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-itens

/* Definitions for BROWSE britem                                        */
&Scoped-define FIELDS-IN-QUERY-britem tt-itens.it-codigo tt-itens.descricao tt-itens.quantidade tt-itens.disponivel tt-itens.unit-mat tt-itens.unit-mob tt-itens.unit-ggf tt-itens.valor   
&Scoped-define ENABLED-FIELDS-IN-QUERY-britem   
&Scoped-define SELF-NAME britem
&Scoped-define QUERY-STRING-britem FOR EACH tt-itens BY tt-itens.it-codigo
&Scoped-define OPEN-QUERY-britem OPEN QUERY {&SELF-NAME} FOR EACH tt-itens BY tt-itens.it-codigo.
&Scoped-define TABLES-IN-QUERY-britem tt-itens
&Scoped-define FIRST-TABLE-IN-QUERY-britem tt-itens


/* Definitions for BROWSE brvalor                                       */
&Scoped-define FIELDS-IN-QUERY-brvalor tt-itens.it-codigo tt-itens.descricao tt-itens.quantidade tt-itens.disponivel tt-itens.unit-mat tt-itens.unit-mob tt-itens.unit-ggf tt-itens.valor   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brvalor   
&Scoped-define SELF-NAME brvalor
&Scoped-define QUERY-STRING-brvalor FOR EACH tt-itens BY tt-itens.valor DESC
&Scoped-define OPEN-QUERY-brvalor OPEN QUERY {&SELF-NAME} FOR EACH tt-itens BY tt-itens.valor DESC.
&Scoped-define TABLES-IN-QUERY-brvalor tt-itens
&Scoped-define FIRST-TABLE-IN-QUERY-brvalor tt-itens


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-britem}

/* Definitions for FRAME fPage2                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage2 ~
    ~{&OPEN-QUERY-brvalor}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ttdeposito.cod-depos ttdeposito.nome 
&Scoped-define ENABLED-TABLES ttdeposito
&Scoped-define FIRST-ENABLED-TABLE ttdeposito
&Scoped-Define ENABLED-OBJECTS rtKeys rtToolBar btFirst btPrev btNext ~
btLast btGoTo btSearch btfiltro btselecao btExcel btQueryJoins ~
btReportsJoins btExit btHelp bt-estabel fi-cod-estabel de-total-dep 
&Scoped-Define DISPLAYED-FIELDS ttdeposito.cod-depos ttdeposito.nome 
&Scoped-define DISPLAYED-TABLES ttdeposito
&Scoped-define FIRST-DISPLAYED-TABLE ttdeposito
&Scoped-Define DISPLAYED-OBJECTS fi-cod-estabel de-total-dep 

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
       MENU-ITEM miFiltro       LABEL "&Filtro"        ACCELERATOR "CTRL-F6"
       MENU-ITEM miSeleo        LABEL "&Sele‡Æo"       ACCELERATOR "CTRL-F7"
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
       MENU-ITEM m_Export_Excel LABEL "E&xportar p/ Excel" ACCELERATOR "CTRL-E"
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
DEFINE BUTTON bt-estabel 
     IMAGE-UP FILE "image/im-chck1.bmp":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON btExcel 
     IMAGE-UP FILE "image/excel.bmp":U
     LABEL "Excel" 
     SIZE 4 BY 1.25 TOOLTIP "Exportar para Excel".

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btfiltro 
     IMAGE-UP FILE "image\im-fil.bmp":U
     IMAGE-INSENSITIVE FILE "image\ii-fil.bmp":U
     LABEL "Filtro" 
     SIZE 4 BY 1.25.

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

DEFINE BUTTON btselecao 
     IMAGE-UP FILE "image\im-ran.bmp":U
     IMAGE-INSENSITIVE FILE "image\ii-ran.bmp":U
     LABEL "Selecao" 
     SIZE 4 BY 1.25.

DEFINE VARIABLE de-total-dep AS DECIMAL FORMAT "->>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Valor Total" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-estabel AS CHARACTER FORMAT "X(3)":U 
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 114 BY 3.5.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 114 BY 1.5
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY britem FOR 
      tt-itens SCROLLING.

DEFINE QUERY brvalor FOR 
      tt-itens SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE britem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS britem wMaintenance _FREEFORM
  QUERY britem DISPLAY
      tt-itens.it-codigo    FORMAT "x(20)"  LABEL "Item" 
      tt-itens.descricao    FORMAT "x(85)" LABEL "Descri‡Æo"
      tt-itens.quantidade   LABEL "Quantidade"
      tt-itens.disponivel   LABEL "Dispon¡vel"
      tt-itens.unit-mat     LABEL "Valor Unit Mat Mensal"
      tt-itens.unit-mob     LABEL "Valor Unit Mob Mensal"
      tt-itens.unit-ggf     LABEL "Valor Unit GGF Mensal"
      tt-itens.valor        LABEL "Valor"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 105 BY 15
         FONT 1 FIT-LAST-COLUMN TOOLTIP "Duplo click para Consulta de Saldo do Item".

DEFINE BROWSE brvalor
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brvalor wMaintenance _FREEFORM
  QUERY brvalor DISPLAY
      tt-itens.it-codigo    FORMAT "x(20)"  LABEL "Item" 
      tt-itens.descricao    FORMAT "x(85)" LABEL "Descri‡Æo"
      tt-itens.quantidade   LABEL "Quantidade"
      tt-itens.disponivel   LABEL "Dispon¡vel"
      tt-itens.unit-mat     LABEL "Valor Unit Mat Mensal"
      tt-itens.unit-mob     LABEL "Valor Unit Mob Mensal"
      tt-itens.unit-ggf     LABEL "Valor Unit GGF Mensal"
      tt-itens.valor        LABEL "Valor"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 106 BY 15
         FONT 1 FIT-LAST-COLUMN TOOLTIP "Duplo click para Consulta de Saldo do Item".


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
     btfiltro AT ROW 1.13 COL 31 HELP
          "Pesquisa"
     btselecao AT ROW 1.13 COL 35 HELP
          "Pesquisa"
     btExcel AT ROW 1.13 COL 94.57 HELP
          "Exportar para Excel"
     btQueryJoins AT ROW 1.13 COL 98.57 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 102.57 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 106.57 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 110.57 HELP
          "Ajuda"
     bt-estabel AT ROW 2.92 COL 49.29 WIDGET-ID 4
     fi-cod-estabel AT ROW 3 COL 41 COLON-ALIGNED WIDGET-ID 2
     ttdeposito.cod-depos AT ROW 4 COL 41 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.14 BY .88
     ttdeposito.nome AT ROW 4 COL 45 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 29.72 BY .88
     de-total-dep AT ROW 5 COL 41 COLON-ALIGNED
     rtKeys AT ROW 2.75 COL 1
     rtToolBar AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 114 BY 23.42
         FONT 1.

DEFINE FRAME fPage2
     brvalor AT ROW 1.5 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 7.67
         SIZE 108.43 BY 15.88
         FONT 1.

DEFINE FRAME fPage1
     britem AT ROW 1.5 COL 3
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 7.67
         SIZE 108.43 BY 15.88
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Maintenance
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: ttdeposito T "?" NO-UNDO mgcad deposito
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
         HEIGHT             = 23.42
         WIDTH              = 114.29
         MAX-HEIGHT         = 32.71
         MAX-WIDTH          = 205.72
         VIRTUAL-HEIGHT     = 32.71
         VIRTUAL-WIDTH      = 205.72
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
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE
       FRAME fPage2:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB britem 1 fPage1 */
/* SETTINGS FOR FRAME fPage2
                                                                        */
/* BROWSE-TAB brvalor 1 fPage2 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMaintenance)
THEN wMaintenance:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE britem
/* Query rebuild information for BROWSE britem
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-itens BY tt-itens.it-codigo.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE britem */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brvalor
/* Query rebuild information for BROWSE brvalor
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-itens BY tt-itens.valor DESC.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE brvalor */
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
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage2 */
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

  RUN desconecta-rpc IN THIS-PROCEDURE (INPUT hproc).
  hproc = ?.

  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME britem
&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME britem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL britem wMaintenance
ON MOUSE-SELECT-DBLCLICK OF britem IN FRAME fPage1
DO:
    ASSIGN pescep003 = tt-itens.it-codigo.

    RUN esp/cep/escep002.w.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brvalor
&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME brvalor
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brvalor wMaintenance
ON MOUSE-SELECT-DBLCLICK OF brvalor IN FRAME fPage2
DO:
    ASSIGN pescep003 = tt-itens.it-codigo.

    RUN esp/cep/escep002.w.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME bt-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-estabel wMaintenance
ON CHOOSE OF bt-estabel IN FRAME fpage0
DO:

    RUN pi-saldo-dep.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExcel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExcel wMaintenance
ON CHOOSE OF btExcel IN FRAME fpage0 /* Excel */
DO:
    RUN piGeraExcel.
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


&Scoped-define SELF-NAME btfiltro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btfiltro wMaintenance
ON CHOOSE OF btfiltro IN FRAME fpage0 /* Filtro */
OR CHOOSE OF MENU-ITEM miFiltro IN MENU mbMain DO:
  RUN goToFiltro IN THIS-PROCEDURE.  
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
    RUN esp/cep/escep003a.w (INPUT TABLE tt-itens,
                             INPUT c-loc-ini,       
                             INPUT c-loc-fim,       
                             INPUT i-ge-ini,        
                             INPUT i-ge-fim,        
                             INPUT c-fm-ini,        
                             INPUT c-fm-fim,        
                             INPUT c-it-ini,        
                             INPUT c-it-fim,        
                             INPUT c-comprador-ini, 
                             INPUT c-comprador-fim, 
                             INPUT l-ativo,         
                             INPUT l-obsoleto-auto, 
                             INPUT l-obsoleto,      
                             INPUT l-total,         
                             INPUT i-mat,
                             INPUT de-total-dep).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSearch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSearch wMaintenance
ON CHOOSE OF btSearch IN FRAME fpage0 /* Search */
OR CHOOSE OF MENU-ITEM miSearch IN MENU mbMain DO:
    
    DEFINE VARIABLE cStatus AS CHAR NO-UNDO.
    DEFINE VARIABLE rGoTo AS ROWID NO-UNDO.   

    {include/zoomvar.i &prog-zoom="inzoom/z01in084.w"
                       &campo="ttdeposito.cod-depos"    
                       &campo2="ttdeposito.nome"
                       &campozoom="cod-depos"
                       &campozoom2="nome"
                       &frame="fpage0"
                       &frame2="fpage0"}

      
    IF VALID-HANDLE(wh-pesquisa) THEN
        WAIT-FOR CLOSE OF wh-pesquisa.

    RUN goToKey IN {&hDBOTable} (INPUT FRAME fPage0 ttdeposito.cod-depos ).
    IF RETURN-VALUE = "NOK":U THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT "Dep¢sito":U).
        RETURN NO-APPLY.
    END.

    /*:T Retorna rowid do registro corrente do DBO */
    RUN getRowid IN {&hDBOTable} (OUTPUT rGoTo).

    /*:T Reposiciona registro com base em um rowid */
    RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btselecao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btselecao wMaintenance
ON CHOOSE OF btselecao IN FRAME fpage0 /* Selecao */
OR CHOOSE OF MENU-ITEM miSeleo IN MENU mbMain DO:
  RUN goToSelecao IN THIS-PROCEDURE.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Export_Excel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Export_Excel wMaintenance
ON CHOOSE OF MENU-ITEM m_Export_Excel /* Exportar p/ Excel */
DO:
    APPLY "CHOOSE":U TO btExcel IN FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME britem
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenance 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{maintenance/MainBlock.i}

ENABLE btfiltro
       btselecao
       btExcel
       WITH FRAME fPage0.

ENABLE britem  WITH FRAME fPage1.
ENABLE brvalor WITH FRAME fPage2.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterDisplayFields wMaintenance 
PROCEDURE AfterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DO WITH FRAME fPage0:

        ASSIGN fi-cod-estabel:SENSITIVE = TRUE
               bt-estabel:SENSITIVE = TRUE.

    END.

    RUN pi-saldo-dep.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterinitializeInterface wMaintenance 
PROCEDURE AfterinitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    RUN conecta-rpc IN THIS-PROCEDURE (output hproc).
    l-connect = RETURN-VALUE NE "NOK".


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE BeforeInitializeInterface wMaintenance 
PROCEDURE BeforeInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN fi-cod-estabel:SCREEN-VALUE IN FRAME fPage0 = v_cod_estab_usuar.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToFiltro wMaintenance 
PROCEDURE goToFiltro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE BUTTON btGoToFiltroCancel 
     LABEL "&Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btGoToFiltroOK 
     LABEL "&OK" 
     SIZE 10 BY 1.

DEFINE VARIABLE rs-mat AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "S¢ Material", 1,
"MOB + MAT", 2
     SIZE 32 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-14
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 54 BY 1.75.

DEFINE RECTANGLE RECT-15
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 54 BY 4.75.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 54 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE fi-ativo AS LOGICAL INITIAL yes 
     LABEL "Ativo" 
     VIEW-AS TOGGLE-BOX
     SIZE 44 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fi-obsoleto AS LOGICAL INITIAL yes 
     LABEL "Obsoleto Todas as Ordens" 
     VIEW-AS TOGGLE-BOX
     SIZE 44 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fi-obsoleto-auto AS LOGICAL INITIAL yes 
     LABEL "Obsoleto Ordens Autom ticas" 
     VIEW-AS TOGGLE-BOX
     SIZE 44 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fi-total AS LOGICAL INITIAL yes 
     LABEL "Totalmente Obsoleto" 
     VIEW-AS TOGGLE-BOX
     SIZE 44 BY .88
     FONT 1 NO-UNDO.

DEFINE FRAME fgoToFiltro
     rs-mat AT ROW 1.5 COL 6 NO-LABEL
     fi-ativo AT ROW 3.5 COL 7
     fi-obsoleto-auto AT ROW 4.5 COL 7
     fi-obsoleto AT ROW 5.5 COL 7
     fi-total AT ROW 6.5 COL 7
     btGoToFiltroOK AT ROW 8.25 COL 2
     btGoToFiltroCancel AT ROW 8.25 COL 13
     RECT-14 AT ROW 1 COL 1
     RECT-15 AT ROW 3 COL 1
     rtToolBar AT ROW 8 COL 1
     SPACE(0.13) SKIP(0.11)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 1
         TITLE "Filtro"
         DEFAULT-BUTTON btGoToFiltroOK CANCEL-BUTTON btGoToFiltroCancel.

ASSIGN rs-mat           = i-mat
       fi-ativo         = l-ativo
       fi-obsoleto-auto = l-obsoleto-auto 
       fi-obsoleto      = l-obsoleto 
       fi-total         = l-total.

ON CHOOSE OF btGoToFiltroOK IN FRAME fgoToFiltro DO:

    ASSIGN i-mat           = INPUT FRAME fgoToFiltro rs-mat
           l-ativo         = INPUT FRAME fgoToFiltro fi-ativo     
           l-obsoleto-auto = INPUT FRAME fgoToFiltro fi-obsoleto-auto     
           l-obsoleto      = INPUT FRAME fgoToFiltro fi-obsoleto     
           l-total         = INPUT FRAME fgoToFiltro fi-total.     

    APPLY "GO":U TO FRAME fGoToFiltro.

    RUN pi-saldo-dep.
END.

ON CHOOSE OF btGoToFiltroCancel IN FRAME fgoToFiltro DO:
    APPLY "GO":U TO FRAME fGoToFiltro.
END.

DISPLAY rs-mat fi-ativo fi-obsoleto-auto fi-obsoleto fi-total 
    WITH FRAME fgoToFiltro.
ENABLE rs-mat fi-ativo fi-obsoleto-auto fi-obsoleto fi-total btGoToFiltroOK 
     btGoToFiltroCancel RECT-14 RECT-15 rtToolBar 
    WITH FRAME fgoToFiltro.

WAIT-FOR GO OF FRAME fgoToFiltro.

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
    
    DEFINE VARIABLE ccod-depos LIKE {&ttTable}.cod-depos NO-UNDO.
    
    DEFINE FRAME fGoToRecord
        ccod-depos        AT ROW 1.21 COL 17.72 COLON-ALIGNED
        btGoToOK          AT ROW 2.63 COL 2.14
        btGoToCancel      AT ROW 2.63 COL 13
        rtGoToButton      AT ROW 2.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V  Para Dep¢sito" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.
    
    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN ccod-depos.
        
        RUN goToKey IN {&hDBOTable} (INPUT ccod-depos).
        IF RETURN-VALUE = "NOK":U THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT "Dep¢sito":U).
            
            RETURN NO-APPLY.
        END.
        
        /*:T Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOTable} (OUTPUT rGoTo).
        
        /*:T Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).

        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    ENABLE ccod-depos btGoToOK btGoToCancel 
        WITH FRAME fGoToRecord. 
    
    WAIT-FOR "GO":U OF FRAME fGoToRecord.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToSelecao wMaintenance 
PROCEDURE goToSelecao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE BUTTON btCancel 
         LABEL "&Cancelar" 
         SIZE 10 BY 1.

    DEFINE BUTTON btOK 
         LABEL "&OK" 
         SIZE 10 BY 1.

    DEFINE VARIABLE fi-cod-comprado-fim AS CHARACTER FORMAT "x(12)" INITIAL "ZZZZZZZZZZZZ" 
         VIEW-AS FILL-IN 
         SIZE 9.72 BY .88.

    DEFINE VARIABLE fi-cod-comprado-ini AS CHARACTER FORMAT "x(12)" 
         LABEL "Comprador":R11 
         VIEW-AS FILL-IN 
         SIZE 9.72 BY .88.

    DEFINE VARIABLE fi-cod-localiz-fim AS CHARACTER FORMAT "x(20)" INITIAL "ZZZZZZZZZZZZZZZZZZZZ" 
         VIEW-AS FILL-IN 
         SIZE 25 BY .88.

    DEFINE VARIABLE fi-cod-localiz-ini AS CHARACTER FORMAT "x(20)" 
         LABEL "Localiza‡Æo":R14 
         VIEW-AS FILL-IN 
         SIZE 25 BY .88.

    DEFINE VARIABLE fi-fm-codigo-fim AS CHARACTER FORMAT "x(8)" INITIAL "ZZZZZZZZ" 
         VIEW-AS FILL-IN 
         SIZE 6.86 BY .88.

    DEFINE VARIABLE fi-fm-codigo-ini AS CHARACTER FORMAT "x(8)" 
         LABEL "Fam¡lia":R9 
         VIEW-AS FILL-IN 
         SIZE 6.86 BY .88.

    DEFINE VARIABLE fi-it-codigo-fim AS CHARACTER FORMAT "x(16)" INITIAL "ZZZZZZZZZZZZZZZZ" 
         VIEW-AS FILL-IN 
         SIZE 12.57 BY .88.

    DEFINE VARIABLE fi-it-codigo-ini AS CHARACTER FORMAT "x(16)" 
         LABEL "Item":R5 
         VIEW-AS FILL-IN 
         SIZE 12.57 BY .88.

    DEFINE VARIABLE fi-ge-codigo-fim AS INTEGER FORMAT ">9" INITIAL 99 
         VIEW-AS FILL-IN 
         SIZE 2.57 BY .88.

    DEFINE VARIABLE fi-ge-codigo-ini AS INTEGER FORMAT ">9" INITIAL 0 
         LABEL "Grupo Estoque":R16 
         VIEW-AS FILL-IN 
         SIZE 2.57 BY .88.

    DEFINE IMAGE IMAGE-1
         FILENAME "image\im-fir":U
         SIZE 3 BY .88.

    DEFINE IMAGE IMAGE-10
         FILENAME "image\im-las":U
         SIZE 3 BY .88.

    DEFINE IMAGE IMAGE-2
         FILENAME "image\im-las":U
         SIZE 3 BY .88.

    DEFINE IMAGE IMAGE-3
         FILENAME "image\im-fir":U
         SIZE 3 BY .88.

    DEFINE IMAGE IMAGE-4
         FILENAME "image\im-las":U
         SIZE 3 BY .88.

    DEFINE IMAGE IMAGE-5
         FILENAME "image\im-fir":U
         SIZE 3 BY .88.

    DEFINE IMAGE IMAGE-6
         FILENAME "image\im-las":U
         SIZE 3 BY .88.

    DEFINE IMAGE IMAGE-7
         FILENAME "image\im-fir":U
         SIZE 3 BY .88.

    DEFINE IMAGE IMAGE-8
         FILENAME "image\im-las":U
         SIZE 3 BY .88.

    DEFINE IMAGE IMAGE-9
         FILENAME "image\im-fir":U
         SIZE 3 BY .88.

    DEFINE RECTANGLE rtToolBar
         EDGE-PIXELS 2 GRAPHIC-EDGE  
         SIZE 76 BY 1.42
         BGCOLOR 7 .


    /* ************************  Frame Definitions  *********************** */

    DEFINE FRAME fgoToSelecao
         fi-ge-codigo-ini AT ROW 1.75 COL 12 COLON-ALIGNED HELP
              "Grupo de estoque a que pertence o item"
         fi-ge-codigo-fim AT ROW 1.75 COL 48 COLON-ALIGNED HELP
              "Grupo de estoque a que pertence o item" NO-LABEL
         fi-fm-codigo-ini AT ROW 2.75 COL 12 COLON-ALIGNED HELP
              "Fam¡lia de material a que pertence o item"
         fi-fm-codigo-fim AT ROW 2.75 COL 48 COLON-ALIGNED HELP
              "Fam¡lia de material a que pertence o item" NO-LABEL
         fi-it-codigo-ini AT ROW 3.75 COL 12 COLON-ALIGNED HELP
              "C¢digo do Item"
         fi-it-codigo-fim AT ROW 3.75 COL 48 COLON-ALIGNED HELP
              "C¢digo do Item" NO-LABEL
         fi-cod-comprado-ini AT ROW 4.75 COL 12 COLON-ALIGNED
         fi-cod-comprado-fim AT ROW 4.75 COL 48 COLON-ALIGNED NO-LABEL
         fi-cod-localiz-ini AT ROW 5.75 COL 12 COLON-ALIGNED
         fi-cod-localiz-fim AT ROW 5.75 COL 48 COLON-ALIGNED NO-LABEL
         btOK AT ROW 7.75 COL 2
         btCancel AT ROW 7.75 COL 17
         IMAGE-1  AT ROW 1.75 COL 40
         IMAGE-2  AT ROW 1.75 COL 46
         IMAGE-3  AT ROW 2.75 COL 40
         IMAGE-4  AT ROW 2.75 COL 46
         IMAGE-5  AT ROW 3.75 COL 40
         IMAGE-6  AT ROW 3.75 COL 46
         IMAGE-7  AT ROW 4.75 COL 40
         IMAGE-8  AT ROW 4.75 COL 46
         IMAGE-9  AT ROW 5.75 COL 40
         IMAGE-10 AT ROW 5.75 COL 46
         rtToolBar AT ROW 7.5 COL 1
         /*SPACE(0.28)*/ SKIP(0.15)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
             SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
             FONT 1 TITLE "Sele‡Æo"
             DEFAULT-BUTTON btOK CANCEL-BUTTON btCancel.


    ON CHOOSE OF btOK IN FRAME fgoToSelecao DO:

        ASSIGN c-loc-ini          = INPUT FRAME fgoToSelecao fi-cod-localiz-ini     
               c-loc-fim          = INPUT FRAME fgoToSelecao fi-cod-localiz-fim     
               i-ge-ini           = INPUT FRAME fgoToSelecao fi-ge-codigo-ini     
               i-ge-fim           = INPUT FRAME fgoToSelecao fi-ge-codigo-fim     
               c-fm-ini           = INPUT FRAME fgoToSelecao fi-fm-codigo-ini     
               c-fm-fim           = INPUT FRAME fgoToSelecao fi-fm-codigo-fim     
               c-it-ini           = INPUT FRAME fgoToSelecao fi-it-codigo-ini  
               c-it-fim           = INPUT FRAME fgoToSelecao fi-it-codigo-fim  
               c-comprador-ini    = INPUT FRAME fgoToSelecao fi-cod-comprado-ini   
               c-comprador-fim    = INPUT FRAME fgoToSelecao fi-cod-comprado-fim.   

        APPLY "GO":U TO FRAME fGoToSelecao.

        RUN pi-saldo-dep.
    END.

    ON CHOOSE OF btCancel IN FRAME fgoToSelecao DO:
        APPLY "GO":U TO FRAME fGoToSelecao.
    END.

    ASSIGN fi-cod-localiz-ini    = c-loc-ini        
           fi-cod-localiz-fim    = c-loc-fim        
           fi-ge-codigo-ini      = i-ge-ini         
           fi-ge-codigo-fim      = i-ge-fim         
           fi-fm-codigo-ini      = c-fm-ini         
           fi-fm-codigo-fim      = c-fm-fim         
           fi-it-codigo-ini      = c-it-ini         
           fi-it-codigo-fim      = c-it-fim         
           fi-cod-comprado-ini   = c-comprador-ini  
           fi-cod-comprado-fim   = c-comprador-fim.   

    DISPLAY fi-ge-codigo-ini fi-ge-codigo-fim fi-fm-codigo-ini fi-fm-codigo-fim 
            fi-it-codigo-ini fi-it-codigo-fim fi-cod-comprado-ini fi-cod-comprado-fim 
            fi-cod-localiz-ini fi-cod-localiz-fim 
        WITH FRAME fgoToSelecao.
    ENABLE fi-ge-codigo-ini fi-ge-codigo-fim fi-fm-codigo-ini fi-fm-codigo-fim 
           fi-it-codigo-ini fi-it-codigo-fim fi-cod-comprado-ini fi-cod-comprado-fim 
           fi-cod-localiz-ini fi-cod-localiz-fim btOK btCancel IMAGE-1 IMAGE-10 
           IMAGE-2 IMAGE-3 IMAGE-4 IMAGE-5 IMAGE-6 IMAGE-7 IMAGE-8 IMAGE-9 
           rtToolBar 
        WITH FRAME fgoToSelecao.


    WAIT-FOR "GO":U OF FRAME fGoToSelecao.

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
       {&hDBOTable}:FILE-NAME <> "inbo/boin084.p":U THEN DO:
        {btb/btb008za.i1 inbo/boin084.p YES}
        {btb/btb008za.i2 inbo/boin084.p '' {&hDBOTable}}
    END.
    
    RUN openQueryStatic IN {&hDBOTable} (INPUT "Main":U) NO-ERROR.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-saldo-dep wMaintenance 
PROCEDURE pi-saldo-dep :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  /*
       
    EMPTY TEMP-TABLE tt-itens.

/*     FIND FIRST param-estoq NO-LOCK NO-ERROR. */
/*    */
    for each saldo-estoq no-lock use-index estabel-dep
       where saldo-estoq.cod-estabel  = INPUT FRAME fPage0 fi-cod-estabel
         and saldo-estoq.cod-depos    = INPUT FRAME fPage0 ttdeposito.cod-depos
         and saldo-estoq.cod-localiz >= c-loc-ini
         and saldo-estoq.cod-localiz <= c-loc-fim
         and saldo-estoq.it-codigo   >= c-it-ini
         and saldo-estoq.it-codigo   <= c-it-fim,
        each item no-lock
       where item.it-codigo     = saldo-estoq.it-codigo:
          
         if saldo-estoq.qtidade-atu = 0 then next.
         
         IF ITEM.cod-obsoleto = 1 AND NOT l-ativo         THEN NEXT.
         IF ITEM.cod-obsoleto = 2 AND NOT l-obsoleto-auto THEN NEXT.
         IF ITEM.cod-obsoleto = 3 AND NOT l-obsoleto      THEN NEXT.
         IF ITEM.cod-obsoleto = 4 AND NOT l-total         THEN NEXT.

         IF item.ge-codigo    < i-ge-ini
         OR item.ge-codigo    > i-ge-fim        THEN NEXT.
         IF item.fm-codigo    < c-fm-ini
         OR item.fm-codigo    > c-fm-fim        THEN NEXT.
         IF item.cod-comprado < c-comprador-ini
         OR item.cod-comprado > c-comprador-fim THEN NEXT.

         find tt-itens
              where tt-itens.it-codigo = saldo-estoq.it-codigo no-error.
         if not avail tt-itens then do:
             create tt-itens.
             assign tt-itens.it-codigo = saldo-estoq.it-codigo.
         end.
         assign tt-itens.quantidade = tt-itens.quantidade + saldo-estoq.qtidade-atu.
    end.
    assign de-total-dep = 0.
    for each tt-itens:
        find item no-lock 
            where item.it-codigo = tt-itens.it-codigo.
        
        /*******************   esp/es0012.i   *****************/
        assign de-val-unit = 0
               de-val-mat  = 0
               de-val-mob  = 0
               de-val-ggf  = 0.
                               
        FOR FIRST item-estab no-lock
            where item-estab.cod-estabel = INPUT FRAME fPage0 fi-cod-estabel 
              and item-estab.it-codigo   = item.it-codigo:
           ASSIGN de-val-unit = item-estab.val-unit-mat-m[1]
                              + item-estab.val-unit-mob-m[1]
                              + item-estab.val-unit-ggf-m[1]
                  de-val-mat  = item-estab.val-unit-mat-m[1]
                  de-val-mob  = item-estab.val-unit-mob-m[1]
                  de-val-ggf  = item-estab.val-unit-ggf-m[1].
        END.

        /******************* fim esp/es0012.i ****************/
        assign tt-itens.descricao = item.desc-item
               tt-itens.cod-depos = INPUT FRAME fPage0 ttdeposito.cod-depos 
               tt-itens.nome      = INPUT FRAME fPage0 ttdeposito.nome
               tt-itens.valor     = tt-itens.quantidade * (de-val-mat + if i-mat = 2 then de-val-mob else 0)
               de-total-dep       = de-total-dep + tt-itens.valor.
   
    end.
    
    */
    
 /*   MESSAGE "Status: " l-connect 
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
    ETIME(YES).
   */ 
    IF l-connect and INPUT FRAME fPage0 fi-cod-estabel <> "103" THEN
        RUN esp/cep/escep003rpc.p ON SERVER hproc (INPUT INPUT FRAME fPage0 fi-cod-estabel,
                               INPUT INPUT FRAME fPage0 ttdeposito.cod-depos,
                               INPUT c-loc-ini,       
                               INPUT c-loc-fim,       
                               INPUT i-ge-ini,        
                               INPUT i-ge-fim,        
                               INPUT c-fm-ini,        
                               INPUT c-fm-fim,        
                               INPUT c-it-ini,        
                               INPUT c-it-fim,        
                               INPUT c-comprador-ini, 
                               INPUT c-comprador-fim, 
                               INPUT l-ativo,         
                               INPUT l-obsoleto-auto, 
                               INPUT l-obsoleto,      
                               INPUT l-total,         
                               INPUT i-mat,           
                               OUTPUT de-total-dep, 
                               OUTPUT TABLE tt-itens
                               ) .
    
    ELSE 
        RUN esp/cep/escep003rpc.p (INPUT INPUT FRAME fPage0 fi-cod-estabel,
                           INPUT INPUT FRAME fPage0 ttdeposito.cod-depos,
                           INPUT c-loc-ini,       
                           INPUT c-loc-fim,       
                           INPUT i-ge-ini,        
                           INPUT i-ge-fim,        
                           INPUT c-fm-ini,        
                           INPUT c-fm-fim,        
                           INPUT c-it-ini,        
                           INPUT c-it-fim,        
                           INPUT c-comprador-ini, 
                           INPUT c-comprador-fim, 
                           INPUT l-ativo,         
                           INPUT l-obsoleto-auto, 
                           INPUT l-obsoleto,      
                           INPUT l-total,         
                           INPUT i-mat,           
                           OUTPUT de-total-dep, 
                           OUTPUT TABLE tt-itens
                           ).

    
/*    MESSAGE "Tempo: " ETIME
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
  */
        
    disp de-total-dep 
        with frame fPage0.

    {&OPEN-QUERY-britem}
    {&OPEN-QUERY-brvalor}
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piGeraExcel wMaintenance 
PROCEDURE piGeraExcel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cArqConv AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE l-ok     AS LOGICAL     NO-UNDO.

    DEFINE BUTTON btFile
        IMAGE-UP FILE "image/im-sea.bmp":U
        IMAGE-INSENSITIVE FILE "image/ii-sea":U
        SIZE 4 BY 1.
        
    DEFINE VARIABLE cFile AS CHARACTER
        VIEW-AS EDITOR MAX-CHARS 256
        SIZE 40 BY 0.88
        BGCOLOR 15 NO-UNDO.

    DEFINE RECTANGLE rtFile
        EDGE-PIXELS 2 GRAPHIC-EDGE NO-FILL
        SIZE 49 BY 2.33.

    DEFINE BUTTON btExecutar AUTO-GO
         LABEL "&Executar":U
         SIZE 10 BY 1
         BGCOLOR 8.

    DEFINE BUTTON btCancel AUTO-END-KEY
         LABEL "&Cancelar":U
         SIZE 10 BY 1
         BGCOLOR 8.

    /*DEFINE VARIABLE tgAbrir AS LOGICAL INITIAL NO
        LABEL "Abrir arquivo ao finalizar":U
        VIEW-AS TOGGLE-BOX
        SIZE 20 BY 0.83
        BGCOLOR 7 NO-UNDO.*/

    DEFINE RECTANGLE rtButton
        EDGE-PIXELS 2 GRAPHIC-EDGE
        SIZE 49 BY 1.42
        BGCOLOR 7.
    
    DEFINE FRAME fExportExcel
        " Arquivo":U VIEW-AS TEXT
            SIZE 7 BY .54 AT ROW 1.04 COL 3.43
        cFile             AT ROW 2.13 COL 3.86  NO-LABEL
        btFile            AT ROW 2.04 COL 44.14
        rtFile            AT ROW 1.29 COL 1.43
        btExecutar        AT ROW 4    COL 2.43
        btCancel          AT ROW 4    COL 12.93
        /*tgAbrir           AT ROW 4.20 COL 26.93*/
        rtButton          AT ROW 3.79 COL 1.43
        /*SPACE(0.24)*/
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "Exportar para Excel" FONT 1
             DEFAULT-BUTTON btExecutar CANCEL-BUTTON btCancel.
    
    ON "CHOOSE":U OF btExecutar IN FRAME fExportExcel DO:
        RUN piImprimeExcel (INPUT REPLACE(INPUT FRAME fExportExcel cFile, "\":U, "/":U),
                            INPUT NO /*(INPUT FRAME fExportExcel tgAbrir)*/ ).
    END.

    ON "CHOOSE":U OF btFile IN FRAME fExportExcel DO:
        ASSIGN cArqConv = REPLACE(INPUT FRAME fExportExcel cFile, "/":U, "\":U).

        SYSTEM-DIALOG GET-FILE cArqConv
            FILTERS "Arquivos .CSV":U  "*.csv":U,
                    "Todos Arquivos":U "*.*":U
        ASK-OVERWRITE
        DEFAULT-EXTENSION "csv":U
        INITIAL-DIR SESSION:TEMP-DIRECTORY
        SAVE-AS
        USE-FILENAME
        UPDATE l-ok.

        IF l-ok THEN DO:
            ASSIGN cFile = CAPS(REPLACE(cArqConv, "\":U, "/":U)).

            DISPLAY cFile
                WITH FRAME fExportExcel.
        END.
    END.

    ENABLE cFile btFile btExecutar btCancel /*tgAbrir*/
        WITH FRAME fExportExcel.

    FIND FIRST usuar_mestre
        WHERE usuar_mestre.cod_usuario = c-seg-usuario NO-LOCK NO-ERROR.

    IF AVAILABLE usuar_mestre THEN DO:
        ASSIGN cFile = IF LENGTH(usuar_mestre.nom_subdir_spool) <> 0
                            THEN CAPS(REPLACE(usuar_mestre.nom_dir_spool, "\":U, "/":U) + "/":U + REPLACE(usuar_mestre.nom_subdir_spool, "\":U, "/":U) + "/":U + c-programa-mg97 + "-":U + ttdeposito.cod-depos + "-":U + REPLACE(STRING(TODAY, "99/99/99":U), "/":U, "":U) + "-":U + REPLACE(STRING(TIME, "HH:MM:SS":U), ":":U, "":U) + ".csv":U)
                            ELSE CAPS(REPLACE(usuar_mestre.nom_dir_spool, "\":U, "/":U) + "/":U + c-programa-mg97 + "-":U + ttdeposito.cod-depos + "-":U + REPLACE(STRING(TODAY, "99/99/99":U), "/":U, "":U) + "-":U + REPLACE(STRING(TIME, "HH:MM:SS":U), ":":U, "":U) + ".csv":U).

        IF LENGTH(usuar_mestre.nom_subdir_spool) <> 0 THEN DO:
            IF SEARCH(CAPS(REPLACE(usuar_mestre.nom_dir_spool, "\":U, "/":U) + "/":U + REPLACE(usuar_mestre.nom_subdir_spool, "\":U, "/":U))) = ? THEN DO:
                OS-CREATE-DIR VALUE(CAPS(REPLACE(usuar_mestre.nom_dir_spool, "\":U, "/":U) + "/":U + REPLACE(usuar_mestre.nom_subdir_spool, "\":U, "/":U))) NO-ERROR.
            END.
        END.
    END.
    ELSE
        ASSIGN cFile = CAPS(REPLACE(SESSION:TEMP-DIRECTORY, "\":U, "/":U) + c-programa-mg97 + "-":U + ttdeposito.cod-depos + "-":U + REPLACE(STRING(TODAY, "99/99/99":U), "/":U, "":U) + "-":U + REPLACE(STRING(TIME, "HH:MM:SS":U), ":":U, "":U) + ".csv":U).

    DISPLAY cFile
        WITH FRAME fExportExcel.
    
    WAIT-FOR "GO":U OF FRAME fExportExcel.        

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piImprimeExcel wMaintenance 
PROCEDURE piImprimeExcel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER cArquivo AS CHARACTER   NO-UNDO.
    DEFINE INPUT PARAMETER lAbrir   AS LOGICAL     NO-UNDO.

    DEFINE VARIABLE h-acomp AS HANDLE      NO-UNDO.
    DEFINE VARIABLE h-prog  AS HANDLE      NO-UNDO.

    IF NOT VALID-HANDLE(h-acomp) THEN
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-inicializar IN h-acomp (INPUT "Exportando dados para Excel...":U).

    OUTPUT TO VALUE(cArquivo) CONVERT TARGET SESSION:CHARSET.
    PUT UNFORMATTED
        "Item;Descri‡Æo;Quantidade;Valor Unit Mat Mensal;Valor Unit Mob Mensal;Valor Unit GGF Mensal;Valor;Dt Ult Entrada;Dt Ult Sa¡da;":U SKIP.
    DO ON STOP UNDO, LEAVE:
        FOR EACH b-tt-itens
            BY b-tt-itens.it-codigo:
    
            IF VALID-HANDLE(h-acomp) THEN
                RUN pi-acompanhar IN h-acomp (INPUT "Item: ":U + b-tt-itens.it-codigo + " - ":U + STRING(b-tt-itens.descricao, "x(30)":U)).

            PUT UNFORMATTED
                TRIM(b-tt-itens.it-codigo)                             + ";":U
                TRIM(b-tt-itens.descricao)                             + ";":U
                TRIM(STRING(b-tt-itens.quantidade, "->,>>>,>>9.99":U)) + ";":U
                TRIM(STRING(b-tt-itens.unit-mat, "->>,>>>,>>9.99":U))  + ";":U
                TRIM(STRING(b-tt-itens.unit-mob, "->>,>>>,>>9.99":U))  + ";":U
                TRIM(STRING(b-tt-itens.unit-ggf, "->>,>>>,>>9.99":U))  + ";":U
                TRIM(STRING(b-tt-itens.valor, "->>,>>>,>>9.99":U))     + ";":U.

            FIND LAST movto-estoq USE-INDEX item-est-dep
                WHERE movto-estoq.it-codigo   = b-tt-itens.it-codigo
                  AND movto-estoq.cod-estabel = INPUT FRAME fPage0 fi-cod-estabel
                  AND movto-estoq.cod-depos   = b-tt-itens.cod-depos
                  AND movto-estoq.tipo-trans  = 1 NO-LOCK NO-ERROR. /* Entrada */

            IF AVAILABLE movto-estoq THEN
                PUT UNFORMATTED
                    TRIM(STRING(movto-estoq.dt-trans, "99/99/9999":U)) + ";":U.
            ELSE
                PUT UNFORMATTED ";":U.

            FIND LAST movto-estoq USE-INDEX item-est-dep
                WHERE movto-estoq.it-codigo   = b-tt-itens.it-codigo
                  AND movto-estoq.cod-estabel = INPUT FRAME fPage0 fi-cod-estabel
                  AND movto-estoq.cod-depos   = b-tt-itens.cod-depos
                  AND movto-estoq.tipo-trans  = 2 NO-LOCK NO-ERROR. /* Sa¡da */

            IF AVAILABLE movto-estoq THEN
                PUT UNFORMATTED
                    TRIM(STRING(movto-estoq.dt-trans, "99/99/9999":U)) + ";":U.
            ELSE
                PUT UNFORMATTED ";":U.

            PUT UNFORMATTED SKIP.
        END.
    END.
    OUTPUT CLOSE.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-finalizar IN h-acomp.

    IF lAbrir THEN DO:
        IF NOT VALID-HANDLE(h-prog) THEN
            RUN utp/ut-utils.p PERSISTENT SET h-prog.

        IF VALID-HANDLE(h-prog) THEN
            RUN execute IN h-prog(INPUT REPLACE(cArquivo, "/":U, "\":U),
                                  INPUT "":U).

        IF VALID-HANDLE(h-prog) THEN
            DELETE PROCEDURE h-prog.
    END.
    ELSE
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 15825,
                           INPUT "Arquivo gerado com sucesso!":U +
                                 "~~":U +
                                 "Arquivo gerado em: ":U + REPLACE(cArquivo, "/":U, "\":U)).

    IF VALID-HANDLE(h-acomp) THEN
        DELETE PROCEDURE h-acomp.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

