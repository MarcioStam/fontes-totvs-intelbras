&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wMaintenance


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-ped-venda NO-UNDO LIKE ped-venda
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
{include/i-prgvrs.i ESPDP003 2.04.00.001}
                          
CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESPDP003
&GLOBAL-DEFINE Version        1

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1

&GLOBAL-DEFINE FolderLabels   Folder1,Folder2

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

&GLOBAL-DEFINE ttTable        tt-ped-venda
&GLOBAL-DEFINE hDBOTable      bo-ped-venda
&GLOBAL-DEFINE DBOTable       ped-venda

&GLOBAL-DEFINE page0KeyFields tt-ped-venda.nr-pedcli tt-ped-venda.nome-abrev ~
                              tt-ped-venda.nr-pedido
&GLOBAL-DEFINE page0Fields    
&GLOBAL-DEFINE page1Fields    
&GLOBAL-DEFINE page2Fields    

&GLOBAL-DEFINE page0Widgets   btParameters bt-InformaTransporte
&GLOBAL-DEFINE page1Widgets   brPedItem brDeposItem 
/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE l-erro AS LOGICAL     NO-UNDO.

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable} AS HANDLE NO-UNDO.
{esapi\esapi002tt.i}    /* Definicao da temp-table de origem */
{utp/ut-glob.i}
{cdp\cd0666.i}          /* Definicao da temp-table de erros */
{cdp\cdcfgman.i}        /* Pre-processadores */

/* Vari†veis para execuá∆o de zooms */
def new global shared var adm-broker-hdl as handle no-undo.
def var wh-pesquisa                      as handle no-undo.
def new global shared var gr-simula-item as rowid  no-undo.

DEF VAR h-alocacao   AS   HANDLE                     NO-UNDO.
DEF VAR vQtAlocar    LIKE ped-item.qt-pedida         NO-UNDO.
DEF VAR vQtSaldo     LIKE saldo-estoq.qtidade-atu    NO-UNDO.
DEFINE VARIABLE  pi-qtAlocar  AS DECIMAL     NO-UNDO.
DEF TEMP-TABLE       tt-ped-item
    FIELD nr-sequencia  LIKE ped-item.nr-sequencia
    FIELD it-codigo     LIKE ped-item.it-codigo 
    FIELD desc-item     AS CHAR FORMAT "x(18)" LABEL "Descriá∆o"
    FIELD qt-saldo      LIKE ped-item.qt-pedida.

DEF TEMP-TABLE        tt-depos-item
    FIELD it-codigo   LIKE ped-item.it-codigo 
    FIELD cod-depos   LIKE deposito.cod-depos
    FIELD descricao   AS CHAR FORMAT "x(16)" LABEL "Descriá∆o"
    FIELD qt-saldo    LIKE saldo-estoq.qtidade-atu
    FIELD cod-localiz LIKE saldo-estoq.cod-localiz.
                      /*
DEFINE BUFFER bae-item FOR ae-item.
                        */
DEFINE VARIABLE cListaSituacao AS CHARACTER INIT "1,2,3,5,6" NO-UNDO. 
DEFINE VARIABLE iCodAtendente  AS INTEGER   INIT 99          NO-UNDO.
DEF NEW GLOBAL SHARED VAR gr-ped-venda      AS ROWID         NO-UNDO.
DEF var gr-ped-venda-espdp003               AS ROWID         NO-UNDO.
ASSIGN gr-ped-venda-espdp003 = gr-ped-venda.
DEFINE VARIABLE fiCod-Depos  AS char FORMAT "x(03)" INITIAL "EXP"
    LABEL "Deposito"      
    VIEW-AS FILL-IN  
    SIZE 6 BY .88 
    NO-UNDO.

DEFINE VARIABLE fiCod-Localizacao LIKE saldo-estoq.cod-localiz INITIAL ""
    LABEL "Localizaá∆o"      
    VIEW-AS FILL-IN  
    SIZE 12 BY .88 
    NO-UNDO.
    

    
{upc\btb910za-upc.i}

if v_cod_estab_usuar = "101" then assign fiCod-Depos  = "PDO".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Maintenance
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brDeposItem

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-depos-item tt-ped-item

/* Definitions for BROWSE brDeposItem                                   */
&Scoped-define FIELDS-IN-QUERY-brDeposItem tt-depos-item.cod-depos tt-depos-item.qt-saldo tt-depos-item.cod-localiz tt-depos-item.descricao   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brDeposItem   
&Scoped-define SELF-NAME brDeposItem
&Scoped-define QUERY-STRING-brDeposItem FOR EACH tt-depos-item     WHERE tt-depos-item.it-codigo = tt-ped-item.it-codigo NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-brDeposItem OPEN QUERY {&SELF-NAME} FOR EACH tt-depos-item     WHERE tt-depos-item.it-codigo = tt-ped-item.it-codigo NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-brDeposItem tt-depos-item
&Scoped-define FIRST-TABLE-IN-QUERY-brDeposItem tt-depos-item


/* Definitions for BROWSE brPedItem                                     */
&Scoped-define FIELDS-IN-QUERY-brPedItem tt-ped-item.it-codigo tt-ped-item.desc-item tt-ped-item.qt-saldo   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brPedItem   
&Scoped-define SELF-NAME brPedItem
&Scoped-define QUERY-STRING-brPedItem FOR EACH tt-ped-item NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-brPedItem OPEN QUERY {&SELF-NAME} FOR EACH tt-ped-item NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-brPedItem tt-ped-item
&Scoped-define FIRST-TABLE-IN-QUERY-brPedItem tt-ped-item


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brDeposItem}~
    ~{&OPEN-QUERY-brPedItem}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-ped-venda.nome-abrev ~
tt-ped-venda.nr-pedcli tt-ped-venda.nr-pedido 
&Scoped-define ENABLED-TABLES tt-ped-venda
&Scoped-define FIRST-ENABLED-TABLE tt-ped-venda
&Scoped-Define ENABLED-OBJECTS rtKeys rtToolBar btFirst btPrev btNext ~
btLast btGoTo btSearch btParameters bt-InformaTransporte btQueryJoins ~
btReportsJoins btExit btHelp 
&Scoped-Define DISPLAYED-FIELDS tt-ped-venda.nome-abrev ~
tt-ped-venda.nr-pedcli tt-ped-venda.nr-pedido 
&Scoped-define DISPLAYED-TABLES tt-ped-venda
&Scoped-define FIRST-DISPLAYED-TABLE tt-ped-venda


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
DEFINE BUTTON bt-InformaTransporte 
     IMAGE-UP FILE "adeicon/trans.bmp":U
     LABEL "Button 1" 
     SIZE 4 BY 1.25.

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

DEFINE BUTTON btParameters 
     IMAGE-UP FILE "image\im-param":U
     IMAGE-INSENSITIVE FILE "image\ii-param":U
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "ParÉmetros".

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

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 1.58.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE BUTTON btUpdateTarget 
     LABEL "Efetua Transferància" 
     SIZE 18 BY 1.

DEFINE VARIABLE fiDescDepos AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 39 BY .88 NO-UNDO.

DEFINE VARIABLE fiDescItem AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 48 BY .88 NO-UNDO.

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 39.14 BY 1.5
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brDeposItem FOR 
      tt-depos-item SCROLLING.

DEFINE QUERY brPedItem FOR 
      tt-ped-item SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brDeposItem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brDeposItem wMaintenance _FREEFORM
  QUERY brDeposItem NO-LOCK DISPLAY
      tt-depos-item.cod-depos
      tt-depos-item.qt-saldo    FORMAT '>>>>,>>9.999'
      tt-depos-item.cod-localiz
      tt-depos-item.descricao   FORMAT 'x(14)'
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 39 BY 11
         FONT 2.

DEFINE BROWSE brPedItem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brPedItem wMaintenance _FREEFORM
  QUERY brPedItem NO-LOCK DISPLAY
      tt-ped-item.it-codigo FORMAT 'x(12)'
      tt-ped-item.desc-item FORMAT 'x(14)'
      tt-ped-item.qt-saldo  FORMAT '>>>>,>>9.999'
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 48 BY 12.75
         FONT 2.


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
     btParameters AT ROW 1.13 COL 29.57
     bt-InformaTransporte AT ROW 1.13 COL 40 HELP
          "Informaá‰es Adicionais" WIDGET-ID 2
     btQueryJoins AT ROW 1.13 COL 74.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda"
     tt-ped-venda.nome-abrev AT ROW 3 COL 14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     tt-ped-venda.nr-pedcli AT ROW 3 COL 42.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.72 BY .88
     tt-ped-venda.nr-pedido AT ROW 3 COL 70 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9 BY .88
     rtKeys AT ROW 2.67 COL 1
     rtToolBar AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 18.17
         FONT 1.

DEFINE FRAME fPage1
     brPedItem AT ROW 1.25 COL 2
     brDeposItem AT ROW 1.25 COL 51
     fiDescDepos AT ROW 12.33 COL 50.14
     btUpdateTarget AT ROW 13.75 COL 52
     fiDescItem AT ROW 14.08 COL 1.14
     rtToolBar-2 AT ROW 13.5 COL 51
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 4.5
         SIZE 90 BY 14.25
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Maintenance
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-ped-venda T "?" NO-UNDO movdis ped-venda
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
         HEIGHT             = 18.17
         WIDTH              = 90
         MAX-HEIGHT         = 18.17
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 18.17
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
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB brPedItem rtToolBar-2 fPage1 */
/* BROWSE-TAB brDeposItem brPedItem fPage1 */
/* SETTINGS FOR FILL-IN fiDescDepos IN FRAME fPage1
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN fiDescItem IN FRAME fPage1
   NO-ENABLE ALIGN-L                                                    */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMaintenance)
THEN wMaintenance:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brDeposItem
/* Query rebuild information for BROWSE brDeposItem
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-depos-item
    WHERE tt-depos-item.it-codigo = tt-ped-item.it-codigo NO-LOCK INDEXED-REPOSITION.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Query            is OPENED
*/  /* BROWSE brDeposItem */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brPedItem
/* Query rebuild information for BROWSE brPedItem
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-ped-item NO-LOCK INDEXED-REPOSITION.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Query            is OPENED
*/  /* BROWSE brPedItem */
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


&Scoped-define BROWSE-NAME brDeposItem
&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME brDeposItem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDeposItem wMaintenance
ON CHOOSE OF brDeposItem IN FRAME fPage1
DO:
    APPLY "U1" TO SELF.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDeposItem wMaintenance
ON ROW-DISPLAY OF brDeposItem IN FRAME fPage1
DO:
  APPLY "U1" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDeposItem wMaintenance
ON U1 OF brDeposItem IN FRAME fPage1
DO:
    ASSIGN btUpdateTarget:SENSITIVE IN FRAME fPage1 = AVAIL tt-depos-item
           fiDescDepos:SCREEN-VALUE IN FRAME fPage1  = tt-depos-item.descricao WHEN AVAIL tt-depos-item.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDeposItem wMaintenance
ON VALUE-CHANGED OF brDeposItem IN FRAME fPage1
DO:
    APPLY "U1" TO SELF.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brPedItem
&Scoped-define SELF-NAME brPedItem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brPedItem wMaintenance
ON CHOOSE OF brPedItem IN FRAME fPage1
DO:
  APPLY "U1" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brPedItem wMaintenance
ON U1 OF brPedItem IN FRAME fPage1
DO:
    ASSIGN btUpdateTarget:SENSITIVE IN FRAME fPage1 = NO.
    {&OPEN-QUERY-brDeposItem}
    APPLY "U1" TO brDeposItem.
    ASSIGN fiDescItem:SCREEN-VALUE IN FRAME fPage1 = tt-ped-item.desc-item WHEN AVAIL tt-ped-item.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brPedItem wMaintenance
ON VALUE-CHANGED OF brPedItem IN FRAME fPage1
DO:
  APPLY "U1" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME bt-InformaTransporte
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-InformaTransporte wMaintenance
ON CHOOSE OF bt-InformaTransporte IN FRAME fpage0 /* Button 1 */
DO:
    RUN PiAtualizaTransporte.

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


&Scoped-define SELF-NAME btParameters
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btParameters wMaintenance
ON CHOOSE OF btParameters IN FRAME fpage0
DO:
    RUN PiPedeTelaParam.
    run setConstraintByAtendente IN {&hDBOTable} (INPUT iCodAtendente).
    run openQueryStatic in {&hDBOTable} (input "Situacao":U).
    run getRecord  in  {&hDBOTable} (OUTPUT TABLE {&tttable}).
    RUN DISPLayfields IN THIS-PROCEDURE.
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
    {method/ZoomReposition.i &ProgramZoom="dizoom/z07di159.w"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btUpdateTarget
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdateTarget wMaintenance
ON CHOOSE OF btUpdateTarget IN FRAME fPage1 /* Efetua Transferància */
DO:
    DEF VAR vQtTransfere LIKE ped-item.qt-pedida    NO-UNDO.
    DEF VAR cReturn      AS   CHARACTER             NO-UNDO.

    IF NOT AVAIL tt-ped-item OR 
       NOT AVAIL tt-depos-item THEN
    DO:
        RUN utp/ut-msgs.p (INPUT "show":U, 
                           INPUT 17567, 
                           INPUT "N∆o Informado Item ou Dep¢sito. " + 
                                 "Favor selecionar Item e Dep¢sito nos Browsers acima.").
        RETURN NO-APPLY.
    END.

    FIND FIRST emitente WHERE emitente.cod-emitente = tt-ped-venda.cod-emitente NO-LOCK NO-ERROR.
    IF AVAIL emitente THEN DO:
        IF emitente.ind-cre-cli = 4 THEN DO:
            RUN utp/ut-msgs.p (INPUT "show":U, 
                               INPUT 17567, 
                               INPUT "Transferància n∆o pode ser efetuada pois o cliente est† suspenso!").
            RETURN NO-APPLY.
        END.
    END.

    IF tt-ped-venda.cod-sit-aval <> 3 and
       emitente.ind-lib-estoque = NO  THEN DO:
        RUN utp/ut-msgs.p (INPUT "show":U, 
                           INPUT 17567, 
                           INPUT "Transferància n∆o pode ser efetuada pois o pedido n∆o est† aprovado!").
        RETURN NO-APPLY.        
    END.

    RUN utp/ut-msgs.p (INPUT "show":U, 
                       INPUT 27100, 
                       INPUT "Confirma Transferància do item " + tt-ped-item.it-codigo + 
                             " do dep¢sito " + tt-depos-item.cod-depos + " para dep¢sito " + ficod-depos + " Localizacao: " + ficod-localizacao + "?").
    IF RETURN-VALUE = "YES" THEN
    DO:
        EMPTY TEMP-TABLE tt-item.
        BLOCO:
        DO  TRANSACTION ON ERROR UNDO BLOCO, LEAVE BLOCO:
            
            IF   tt-depos-item.qt-saldo >= tt-ped-item.qt-saldo THEN 
                 ASSIGN vQtTransfere = tt-ped-item.qt-saldo.
            ELSE ASSIGN vQtTransfere = tt-depos-item.qt-saldo.

            ASSIGN cReturn = "".

/*             FOR FIRST param-estoq NO-LOCK. */
/*             END. */
            
            /*FOR FIRST ae-item USE-INDEX fifo NO-LOCK
                WHERE ae-item.it-codigo   = tt-depos-item.it-codigo 
                AND   ae-item.cod-depos   = tt-depos-item.cod-depos
                AND   ae-item.localizacao = ""
                AND   ae-item.situacao    = NO:
                FOR FIRST saldo-estoq NO-LOCK
                    WHERE saldo-estoq.it-codigo   = tt-depos-item.it-codigo
                    AND   saldo-estoq.cod-depos   = "EXP"
                    AND   saldo-estoq.cod-localiz = "",
                    FIRST bae-item NO-LOCK 
                    WHERE bae-item.it-codigo   = saldo-estoq.it-codigo 
                    AND   bae-item.cod-depos   = saldo-estoq.cod-depos 
                    AND   bae-item.localizacao = saldo-estoq.cod-localiz
                    AND   bae-item.situacao    = NO:
                    CREATE tt-item.
                    ASSIGN tt-item.TipoTrans    = 1 /* 1 - Entrada*/
                           tt-item.it-codigo    = saldo-estoq.it-codigo
                           tt-item.cod-depos    = saldo-estoq.cod-depos
                           tt-item.cod-localiz  = saldo-estoq.cod-localiz
                           tt-item.quantidade   = vQtTransfere
                           tt-item.serie        = ""
                           tt-item.nro-docto    = string(tt-ped-venda.nr-pedido)
                           tt-item.lote         = saldo-estoq.lote
                           tt-item.dt-vali-lote = saldo-estoq.dt-vali-lote
                           tt-item.cod-refer    = saldo-estoq.cod-refer.
                END.
                IF  NOT CAN-FIND(FIRST tt-item) THEN
                    LEAVE.
            */
            CREATE tt-item.
            ASSIGN tt-item.TipoTrans    = 1 /* 1 - Entrada*/
                   tt-item.cod-estabel  = v_cod_estab_usuar
                   tt-item.it-codigo    = tt-depos-item.it-codigo 
                   tt-item.cod-depos    = fiCod-Depos
                   tt-item.cod-localiz  = fiCod-Localizacao
                   tt-item.quantidade   = vQtTransfere
                   tt-item.serie        = ""
                   tt-item.nro-docto    = string(tt-ped-venda.nr-pedido)
                   tt-item.lote         = ""
                   tt-item.dt-vali-lote = ?
                   tt-item.cod-refer    = "".

            /*
            DO:
                RUN utp/ut-msgs.p (INPUT "show":U, 
                                   INPUT 17567, 
                                   INPUT "N∆o foi poss°vel realizar a transferància. " + 
                                         "N∆o .").
                ASSIGN cReturn = "NOK".
            END.*/

            CREATE tt-item.
            ASSIGN tt-item.TipoTrans    = 2 /* 2 - Saida */
                   tt-item.it-codigo    = tt-depos-item.it-codigo 
                   tt-item.cod-estabel  = v_cod_estab_usuar
                   tt-item.cod-depos    = tt-depos-item.cod-depos
                   tt-item.quantidade   = vQtTransfere
                   tt-item.serie        = ""
                   tt-item.nro-docto    = string(tt-ped-venda.nr-pedido)
                   tt-item.cod-localiz  = tt-depos-item.cod-localiz
                   tt-item.lote         = ""
                   tt-item.dt-vali-lote = ?
                   tt-item.cod-refer    = "".
            /*
            FAZ A EFETIVA TRANSFERENCIA ENTRE DEP‡SITOS
            */

            RUN esapi\esapi002.p (INPUT 1, /* Transferància Entre Dep¢sitos */
                                  INPUT "ESPDP003",
                                  INPUT  TABLE tt-item,
                                  OUTPUT TABLE tt-erro).
            IF  CAN-FIND(FIRST tt-erro) THEN
            DO:
                ASSIGN cReturn = "NOK" .
                UNDO, LEAVE Bloco.
            END.
            ELSE DO: 
                /* 
                EFETUA  A ALOCAÄ«O FISICA DOS ITENS DO PEDIDO SELECIONADO 
                */
               
                FOR FIRST ped-item NO-LOCK
                    WHERE ped-item.nome-abrev  = tt-ped-venda.nome-abrev  
                    AND   ped-item.nr-pedcli   = tt-ped-venda.nr-pedcli
                    AND   ped-item.it-codigo   = tt-ped-item.it-codigo
                    AND   ped-item.nr-sequencia = tt-ped-item.nr-sequencia,
                    FIRST ped-ent NO-LOCK
                    WHERE ped-ent.nome-abrev   = ped-item.nome-abrev  
                    AND   ped-ent.nr-pedcli    = ped-item.nr-pedcli   
                    AND   ped-ent.nr-sequencia = ped-item.nr-sequencia
                    AND   ped-ent.it-codigo    = ped-item.it-codigo   
                    AND   ped-ent.cod-refer    = ped-item.cod-refer:
                    ASSIGN vQtSaldo = 0.
               
                    FOR FIRST saldo-estoq NO-LOCK
                        WHERE saldo-estoq.it-codigo   = tt-depos-item.it-codigo
                        and   saldo-estoq.cod-estabel = v_cod_estab_usuar
                        AND   saldo-estoq.cod-depos   = fiCod-Depos        
                        AND   saldo-estoq.cod-localiz = fiCod-Localizacao  
                        AND  (saldo-estoq.qtidade-atu - (saldo-estoq.qt-alocada   +
                                                         saldo-estoq.qt-aloc-prod +
                                                         saldo-estoq.qt-aloc-ped)) > 0:
                        ASSIGN vQtSaldo = (saldo-estoq.qtidade-atu - (saldo-estoq.qt-alocada   +
                                                                      saldo-estoq.qt-aloc-prod +
                                                                      saldo-estoq.qt-aloc-ped)).
                    END.
                    ASSIGN vQtAlocar = ped-item.qt-pedida - ped-item.qt-atendida - ped-ent.qt-log-aloca.


                    IF  vQtSaldo >= vQtAlocar THEN DO:
                        find first para-ped no-lock.
                        RUN pdp/pdapi002.p PERSISTENT SET h-alocacao.

                        ASSIGN pi-qtAlocar = vQtAlocar.
                        RUN pi-aloca-fisica-man in h-alocacao(INPUT ROWID(ped-ent),
                                                              INPUT-OUTPUT vQtAlocar, 
                                                              INPUT ROWID(saldo-estoq)).
                        IF RETURN-VALUE = "NOK" THEN
                        DO:
                            RUN utp/ut-msgs.p (INPUT "show":U, 
                                               INPUT 17567, 
                                               INPUT "N∆o foi possivel efetuar a alocaá∆o f°sica do material.").
                            ASSIGN cReturn = "NOK".
                        END.
                        ELSE DO: 
                            RUN piAtualizaAstec (INPUT pi-QtAlocar).
                            IF l-erro = YES THEN
                                ASSIGN cReturn = "NOK".
                            ELSE
                                ASSIGN cReturn = "OK".
                        END.
                    END.
                    ELSE cReturn = "NSDO".
                END.

                IF cReturn = "OK" OR NOT AVAIL ped-ent THEN 
                DO:
                    FIND FIRST mgesp.int-ped-item EXCLUSIVE-LOCK
                         WHERE int-ped-item.nome-abrev      = tt-ped-venda.nome-abrev  
                         AND   int-ped-item.nr-pedcli       = tt-ped-venda.nr-pedcli        
                         AND   int-ped-item.nr-sequencia    = tt-ped-item.nr-sequencia     
                         AND   int-ped-item.it-codigo       = ped-item.it-codigo        
                         AND   int-ped-item.cod-refer       = ped-item.cod-refer NO-ERROR.
                    IF NOT AVAIL int-ped-item  THEN
                    DO:
                       CREATE int-ped-item.
                       ASSIGN int-ped-item.nome-abrev      = tt-ped-venda.nome-abrev   
                              int-ped-item.nr-pedcli       = tt-ped-venda.nr-pedcli    
                              int-ped-item.nr-sequencia    = tt-ped-item.nr-sequencia     
                              int-ped-item.it-codigo       = ped-item.it-codigo        
                              int-ped-item.cod-refer       = ped-item.cod-refer NO-ERROR.
                    END.
                    ASSIGN int-ped-item.log-transferido = YES.

                    FIND CURRENT int-ped-item NO-LOCK NO-ERROR.
                    RUN utp/ut-msgs.p (INPUT "show":U, 
                                       INPUT 15825, 
                                       INPUT "Transferància/Alocaá∆o efetuada com sucesso." + "~~Transferància/Alocaá∆o efetuada com sucesso.").
                    ASSIGN cReturn = "OK".
                END.
                ELSE IF cReturn = "NSDO" THEN
                DO:
                    RUN utp/ut-msgs.p (INPUT "show":U, 
                                       INPUT 17567, 
                                       INPUT "N∆o h† saldo suficiente no dep¢sito para atender a alocaá∆o").
                    ASSIGN cReturn = "NOK".
                END.
                ELSE DO:
                    RUN Pi-retorna-erro IN h-alocacao(OUTPUT TABLE tt-erro).
                    IF  CAN-FIND(FIRST tt-erro) THEN DO:
                        ASSIGN cReturn = "NOK".
                        UNDO, LEAVE Bloco.
                    END.
                END.
                IF VALID-HANDLE(h-alocacao) THEN
                   DELETE PROCEDURE h-alocacao.
            END.
                /*
                CREATE tt-erro.
                ASSIGN tt-erro.i-sequen = 1
                       tt-erro.cd-erro  = 17567
                       tt-erro.mensagem = "N∆o foi poss°vel fazer a transferància da AE para o item: " + Saldo-estoq.It-Codigo
                       cReturn          = "NOK".
                */
            /*
            IF  cReturn = "" THEN DO:
                RUN utp/ut-msgs.p (INPUT "show":U, 
                                   INPUT 17567, 
                                   INPUT "N∆o foi poss°vel realizar a transferància. " + 
                                         "Possivelmente n∆o h† registro AE para dep¢sito selecionado.").
                ASSIGN cReturn = "NOK".
            END.
            */
            IF cReturn = "NOK" THEN 
               UNDO, LEAVE Bloco.

            /*
            ELSE IF cReturn = "N-ALOC" THEN
            DO:
                RUN utp/ut-msgs.p (INPUT "show":U, 
                                   INPUT 17567, 
                                   INPUT "N∆o foi poss°vel fazer a Alocaá∆o de Material.").
                UNDO, LEAVE Bloco.
            END.*/
        END. /* DO TRANSA */
        IF cReturn = "NOK" THEN
        DO:
            RUN cdp/cd0666.w (INPUT TABLE tt-erro).
            RETURN NO-APPLY.
        END.
        ELSE DO:
            EMPTY TEMP-TABLE tt-ped-item.
            EMPTY TEMP-TABLE tt-depos-item.
            RUN piAtualizaItens.
            RUN piAtualizaDepositos.
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brDeposItem
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenance 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{maintenance/MainBlock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterdisplayFields wMaintenance 
PROCEDURE AfterdisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    EMPTY TEMP-TABLE tt-ped-item.
    EMPTY TEMP-TABLE tt-depos-item.

    RUN piAtualizaItens.
    RUN piAtualizaDepositos.
    FIND ped-venda
        WHERE ped-venda.nr-pedcli = tt-ped-venda.nr-pedcli:SCREEN-VALUE IN FRAME fpage0
          AND ped-venda.nome-abrev = tt-ped-venda.nome-abrev:SCREEN-VALUE IN FRAME fpage0 NO-LOCK NO-ERROR.
    IF AVAIL ped-venda THEN
        IF ped-venda.tp-pedido = "95" THEN
            ASSIGN bt-InformaTransporte:SENSITIVE = YES.
        ELSE
            ASSIGN bt-InformaTransporte:SENSITIVE = NO.
    ELSE
        ASSIGN bt-InformaTransporte:SENSITIVE = NO.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterInitializeInterface wMaintenance 
PROCEDURE AfterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE rGoTo AS ROWID NO-UNDO.
    DO WITH FRAME fPage0:
        ASSIGN btParameters:SENSITIVE = YES
               bt-InformaTransporte:SENSITIVE = NO.
    END.
    DO WITH FRAME fPage1:
        ASSIGN brPedItem:SENSITIVE    = YES
               brDeposItem:SENSITIVE  = YES.
    END.
    IF gr-ped-venda-espdp003 <> ? THEN DO:
        FIND ped-venda
            WHERE ROWID(ped-venda) = gr-ped-venda-espdp003 NO-LOCK NO-ERROR.
        IF AVAIL ped-venda THEN DO:
            run setConstraintByAtendente IN {&hDBOTable} (INPUT ped-venda.tp-pedido).
            run setConstraintSituacao    IN {&hDBOTable} (INPUT cListaSituacao).

            run openQueryStatic in {&hDBOTable} (input "Situacao":U).

            RUN goToKey IN {&hDBOTable} (INPUT ped-venda.nome-abrev, INPUT ped-venda.nr-pedcli).

            IF RETURN-VALUE = "NOK":U THEN DO:
                RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT "Pedido":U).

                RETURN NO-APPLY.
            END.

            /* Retorna rowid do registro corrente do DBO */
            RUN getRowid IN {&hDBOTable} (OUTPUT rGoTo).

            run getRecord  in  {&hDBOTable} (OUTPUT TABLE {&tttable}).
            RUN DISPLayfields IN THIS-PROCEDURE.
            IF tt-ped-venda.tp-pedido = "95" THEN
               ASSIGN bt-InformaTransporte:SENSITIVE = YES.


        END.


    END.

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

    DEFINE RECTANGLE rtGoToFields
         EDGE-PIXELS 2 GRAPHIC-EDGE
         SIZE 58 BY 2.25
         BGCOLOR 8.

    DEFINE VARIABLE rGoTo AS ROWID NO-UNDO.
    
    DEFINE VARIABLE c-nome-abrev LIKE {&ttTable}.nome-abrev format "x(15)" NO-UNDO.
    DEFINE VARIABLE c-nr-pedcli  LIKE {&ttTable}.nr-pedcli  format "x(15)" NO-UNDO.
    
    DEFINE FRAME fGoToRecord
        rtGoToFields      AT ROW 1    COL 1
        c-nome-abrev      AT ROW 1.31 COL 26 COLON-ALIGNED
        c-nr-pedcli       AT ROW 2.21 COL 26 COLON-ALIGNED
        btGoToOK          AT ROW 3.63 COL 2.14
        btGoToCancel      AT ROW 3.63 COL 13
        rtGoToButton      AT ROW 3.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V† Para Pedido" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.
    
    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN c-nome-abrev c-nr-pedcli.

        /* reabrir a query */
        /*run setConstraintQuotation in {&hDBOTable}(input no).
        
        run setConstraintSituacao in {&hDBOTable} (input c-lista-situacao).
        run openQueryStatic in {&hDBOTable} (INPUT "SituacaoPd4000":U).
        */
        RUN goToKey IN {&hDBOTable} (INPUT c-nome-abrev, INPUT c-nr-pedcli).
        IF RETURN-VALUE = "NOK":U THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT "Pedido":U).
            
            RETURN NO-APPLY.
        END.
        
        /* Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOTable} (OUTPUT rGoTo).
        
        run getRecord  in  {&hDBOTable} (OUTPUT TABLE {&tttable}).
        RUN DISPLayfields IN THIS-PROCEDURE.
       
        /*assign h-Node = "i".*/

        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    ENABLE c-nome-abrev c-nr-pedcli btGoToOK btGoToCancel 
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

    /*--- Verifica se o DBO j† est† inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOTable}) THEN DO:
       if  not valid-handle(bo-ped-venda) or
           bo-ped-venda:type <> "PROCEDURE":U or
           bo-ped-venda:file-name <> "esbo/esbodi159.p" then
           run esbo/esbodi159.p persistent set bo-ped-venda.
    END.

    run setConstraintByAtendente IN {&hDBOTable} (INPUT iCodAtendente).
    run setConstraintSituacao    IN {&hDBOTable} (INPUT cListaSituacao).

    run openQueryStatic in {&hDBOTable} (input "Situacao":U).
    


    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piAtualizaDepositos wMaintenance 
PROCEDURE piAtualizaDepositos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    /*
    FOR FIRST ITEM FIELDS(it-codigo cod-localiz0 NO-LOCK
        WHERE ITEM.it-codigo = pItCodigo:
    END.
    
    */
    FOR EACH  ped-item OF tt-ped-venda NO-LOCK,
        EACH  saldo-estoq NO-LOCK 
        WHERE saldo-estoq.cod-estabel = v_cod_estab_usuar
        and   saldo-estoq.it-codigo   = ped-item.it-codigo
        AND  (saldo-estoq.qtidade-atu - (saldo-estoq.qt-alocada   +
                                         saldo-estoq.qt-aloc-prod +
                                         saldo-estoq.qt-aloc-ped)) > 0
        /*,
        FIRST ae-item NO-LOCK USE-INDEX fifo 
        WHERE ae-item.it-codigo   = saldo-estoq.it-codigo 
        AND   ae-item.cod-depos   = saldo-estoq.cod-depos 
        AND   ae-item.localizacao = saldo-estoq.cod-localiz
        AND   ae-item.situacao    = NO
        */
        :
        /* logica original do MGI devem ser transferidos somente deste dep¢sitos
        case item.nr-linha:
            when 1 then assign tt-itens.cod-depos = "tel".
            when 2 then assign tt-itens.cod-depos = "cnt".
            when 3 then assign tt-itens.cod-depos = "plc".
            when 4 then assign tt-itens.cod-depos = "inj".
            when 5 then assign tt-itens.cod-depos = "smd".
            when 6 then assign tt-itens.cod-depos = "esp".
            when 7 then assign tt-itens.cod-depos = "isf".
            when 8 then assign tt-itens.cod-depos = "pci".
            otherwise   assign tt-itens.cod-depos = "plc".
        end.
        */
        

        CASE saldo-estoq.cod-estabel:
           WHEN "101" THEN
              IF LOOKUP(saldo-estoq.cod-depos,"tel,tec,cnt,plc,inj,win,smd,wsm,esp,pdo,obs,ast,isf,pci,psf,pes,mes,iao,iac,ias,iat,cob,sec") = 0 THEN NEXT.
           WHEN "102" THEN
              IF LOOKUP(saldo-estoq.cod-depos,"alm,lab,rma") = 0 THEN NEXT.
           WHEN "104" THEN
              IF LOOKUP(saldo-estoq.cod-depos,"tel,tec,cnt,plc,inj,win,smd,wsm,esp,pdo,obs,ast,isf,pci,psf,pes,mes,iao,iac,ias,iat,cob,sec") = 0 THEN NEXT.

        END.

        DO:
            FIND FIRST tt-depos-item 
                 WHERE tt-depos-item.it-codigo   = ped-item.It-Codigo
                 AND   tt-depos-item.cod-depos   = saldo-estoq.cod-depos 
                 AND   tt-depos-item.cod-localiz = saldo-estoq.cod-localiz NO-ERROR.
            IF NOT AVAIL tt-depos-item  THEN
            DO:
                CREATE tt-depos-item.
                ASSIGN tt-depos-item.it-codigo   = ped-item.It-Codigo
                       tt-depos-item.cod-depos   = saldo-estoq.cod-depos
                       tt-depos-item.cod-localiz = saldo-estoq.cod-localiz.
            
                ASSIGN tt-depos-item.qt-saldo = tt-depos-item.qt-saldo + (saldo-estoq.qtidade-atu - 
                                                                         (saldo-estoq.qt-alocada   +
                                                                          saldo-estoq.qt-aloc-prod +
                                                                          saldo-estoq.qt-aloc-ped)).
            END.
            FOR FIRST deposito NO-LOCK
                WHERE deposito.cod-depos = tt-depos-item.cod-depos:
                ASSIGN tt-depos-item.descricao = deposito.nome.
            END.
        END.
        /*
        ELSE DO:
            FIND FIRST tt-depos-item 
                 WHERE tt-depos-item.it-codigo = ped-item.It-Codigo
                 AND   tt-depos-item.cod-depos = saldo-estoq.cod-depos NO-ERROR.
            IF NOT AVAIL tt-depos-item  THEN
            DO:
                CREATE tt-depos-item.
                ASSIGN tt-depos-item.it-codigo = ped-item.It-Codigo
                       tt-depos-item.cod-depos = saldo-estoq.cod-depos.
            END.
            ASSIGN tt-depos-item.qt-saldo = tt-depos-item.qt-saldo + (saldo-estoq.qtidade-atu - 
                                                                     (saldo-estoq.qt-alocada   +
                                                                      saldo-estoq.qt-aloc-prod +
                                                                      saldo-estoq.qt-aloc-ped)).

            FOR FIRST deposito NO-LOCK
                WHERE deposito.cod-depos = tt-depos-item.cod-depos:
                ASSIGN tt-depos-item.descricao = deposito.nome.
            END.
        END.
        */
    END.

    FOR EACH  tt-depos-item
        WHERE tt-depos-item.qt-saldo = 0:
        DELETE tt-depos-item.
    END.
    
    {&OPEN-QUERY-brDeposItem}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piAtualizaItens wMaintenance 
PROCEDURE piAtualizaItens :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FOR EACH  ped-item OF tt-ped-venda NO-LOCK
         WHERE ped-item.cod-sit-item < 3: 
        FIND FIRST int-ped-item NO-LOCK
             WHERE int-ped-item.nome-abrev      = ped-item.nome-abrev       
             AND   int-ped-item.nr-pedcli       = ped-item.nr-pedcli        
             AND   int-ped-item.nr-sequencia    = ped-item.nr-sequencia     
             AND   int-ped-item.it-codigo       = ped-item.it-codigo        
             AND   int-ped-item.cod-refer       = ped-item.cod-refer NO-ERROR.
        IF AVAIL int-ped-item AND int-ped-item.log-transferido THEN NEXT.

        FIND FIRST tt-ped-item
             WHERE tt-ped-item.it-codigo = ped-item.it-codigo NO-ERROR.
        IF NOT AVAIL tt-ped-item THEN
        DO:
            CREATE tt-ped-item.
            ASSIGN tt-ped-item.it-codigo    = ped-item.it-codigo 
                   tt-ped-item.nr-sequencia = ped-item.nr-sequencia     
                   tt-ped-item.qt-saldo     = ped-item.qt-pedida - ped-item.qt-atendida NO-ERROR.
        END.
        FOR FIRST ITEM FIELDS(it-codigo desc-item) NO-LOCK
            WHERE ITEM.it-codigo = ped-item.it-codigo:
            ASSIGN tt-ped-item.desc-item = ITEM.desc-item.
        END.
        IF tt-ped-item.qt-saldo > 0 THEN
            FOR EACH  ped-ent  NO-LOCK
                WHERE ped-ent.nome-abrev   = ped-item.nome-abrev   
                AND   ped-ent.nr-pedcli    = ped-item.nr-pedcli    
                AND   ped-ent.nr-sequencia = ped-item.nr-sequencia 
                AND   ped-ent.it-codigo    = ped-item.it-codigo.
                ASSIGN tt-ped-item.qt-saldo = tt-ped-item.qt-saldo - ped-ent.qt-log-aloca .
            END.
    END.
    FOR EACH  tt-ped-item
        WHERE tt-ped-item.qt-saldo = 0:
        DELETE tt-ped-item.
    END.
    
    {&OPEN-QUERY-brPedItem}
    APPLY 'U1' TO brPedItem IN FRAME fPage1.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PiAtualizaTransporte wMaintenance 
PROCEDURE PiAtualizaTransporte :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-lista AS CHARACTER   NO-UNDO.
    DEFINE BUTTON    btGoToOK      
        AUTO-GO LABEL "&OK" 
        SIZE 10 BY 1 BGCOLOR 8.

    DEFINE BUTTON    btGoToCancel  
        AUTO-GO LABEL "&Cancela" 
        SIZE 10 BY 1 BGCOLOR 8.

    DEFINE RECTANGLE rtGoToFields  
        EDGE-PIXELS 2 GRAPHIC-EDGE 
        SIZE 65 BY 3.3 BGCOLOR 8.

    DEFINE RECTANGLE rtGoToButton  
        EDGE-PIXELS 2 GRAPHIC-EDGE 
        SIZE 65 BY 1.5 BGCOLOR 7.

    DEFINE VARIABLE fiTipoTransporte  AS char FORMAT "x(16)" 
        LABEL "Transportador"      
        VIEW-AS COMBO-BOX SORT INNER-LINES 16
        LIST-ITEM-PAIRS "Item 1,Item 1,Item 2,Item 2" 
        DROP-DOWN-LIST 
        SIZE 18 BY .88 
        NO-UNDO.       

    DEFINE VARIABLE fiQtdVolumes  AS INT FORMAT ">>>>9" 
        LABEL "Qtd. de Volumes"      
        VIEW-AS FILL-IN  
        SIZE 6 BY .88 
        NO-UNDO.

    ASSIGN c-lista = " , ,RETIRA,RETIRA,".
    
    
    FOR EACH transporte NO-LOCK
        BREAK BY transporte.nome-abrev:
    
         ASSIGN c-lista = c-lista + transporte.nome-abrev + "," + transporte.nome-abrev + ",".
    
    END.


    DEFINE FRAME fParam
           fiTipoTransporte    AT ROW 1.17 COL 18 COLON-ALIGN 
           fiQtdVolumes        AT ROW 2.17 COL 18 COLON-ALIGN 

           rtGoToFields      AT ROW 1    COL 1
           btGoToOK          AT ROW 3.7  COL 2.14
           btGoToCancel      AT ROW 3.7  COL 13.14
           rtGoToButton      AT ROW 3.5  COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "Informaá‰es Adicionais" FONT 1
             DEFAULT-BUTTON btGoToOK.

    ASSIGN c-lista = SUBSTRING(c-lista,1,LENGTH(c-lista) - 1)
           fiTipoTransporte:LIST-ITEMS IN FRAME fParam = c-lista.  
    IF tt-Ped-venda.nome-transp <> "" THEN
       ASSIGN fiTipoTransporte:SCREEN-VALUE IN FRAME fParam = tt-Ped-venda.nome-transp.

    FIND FIRST int-ped-venda NO-LOCK 
         WHERE int-ped-venda.nr-pedido   = tt-ped-venda.nr-pedido 
           AND int-ped-venda.cod-estabel = tt-ped-venda.cod-estabel NO-ERROR.
    
    IF  AVAIL int-ped-venda THEN DO:
       ASSIGN fiQtdVolumes = int(int-ped-venda.nr-volumes).  
    END.
    ON  "CHOOSE":U OF btGoToOK IN FRAME fParam DO:
        ASSIGN fiTipoTransporte
               fiQtdVolumes.
        FIND ped-venda
                WHERE ped-venda.nr-pedido = tt-ped-venda.nr-pedido EXCLUSIVE-LOCK NO-ERROR.
        IF AVAIL ped-venda THEN DO:
            FIND FIRST int-ped-venda EXCLUSIVE-LOCK 
                 WHERE int-ped-venda.nr-pedido = ped-venda.nr-pedido NO-ERROR.
            IF NOT AVAIL int-ped-venda THEN
            DO:
               CREATE int-ped-venda.
               ASSIGN int-ped-venda.nr-pedido = ped-venda.nr-pedido.
                      
            END.

            ASSIGN int-ped-venda.cod-estabel = ped-venda.cod-estabel
                   int-ped-venda.nr-volumes   = INPUT fiQtdVolumes 
                   ped-venda.nome-transp      = fiTipoTransporte:SCREEN-VALUE IN FRAME fParam. 

            RELEASE int-ped-venda.

        END.
        APPLY "GO":U TO FRAME fParam.
    END.
    ON  "CHOOSE":U OF btGoToCancel IN FRAME fParam DO:
        APPLY "GO":U TO FRAME fParam.
    END.
    DISP fiTipoTransporte
         fiQtdVolumes
         WITH FRAME fParam.

    ENABLE fiTipoTransporte
           fiQtdVolumes
           btGoToOK 
           btGoToCancel
           WITH FRAME fParam.
    
    WAIT-FOR "GO":U OF FRAME fParam.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PiPedeTelaParam wMaintenance 
PROCEDURE PiPedeTelaParam :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE BUTTON    btGoToOK      
        AUTO-GO LABEL "&OK" 
        SIZE 10 BY 1 BGCOLOR 8.

    DEFINE BUTTON    btGoToCancel  
        AUTO-GO LABEL "&Cancela" 
        SIZE 10 BY 1 BGCOLOR 8.

    DEFINE RECTANGLE rtGoToFields  
        EDGE-PIXELS 2 GRAPHIC-EDGE 
        SIZE 65 BY 3.3 BGCOLOR 8.

    DEFINE RECTANGLE rtGoToButton  
        EDGE-PIXELS 2 GRAPHIC-EDGE 
        SIZE 65 BY 1.5 BGCOLOR 7.

    DEFINE VARIABLE fiCodAtendente  AS INT FORMAT ">>>9" 
        LABEL "Atendente"      
        VIEW-AS FILL-IN  
        SIZE 6 BY .88 
        NO-UNDO.

    DEFINE FRAME fParam
           fiCodAtendente    AT ROW 1.17 COL 18 COLON-ALIGN 
           fiCod-depos       AT ROW 2.17 COL 18 COLON-ALIGN 
           fiCod-localizacao AT ROW 2.17 COL 35 COLON-ALIGN 
           rtGoToFields      AT ROW 1    COL 1
           btGoToOK          AT ROW 3.7  COL 2.14
           btGoToCancel      AT ROW 3.7  COL 13.14
           rtGoToButton      AT ROW 3.5  COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "ParÉmetros Pedido" FONT 1
             DEFAULT-BUTTON btGoToOK.

    ON  "CHOOSE":U OF btGoToOK IN FRAME fParam DO:
        ASSIGN fiCodAtendente
               iCodAtendente  = fiCodAtendente
               ficod-depos
               ficod-localizacao.
        APPLY "GO":U TO FRAME fParam.
        FIND deposito
             WHERE deposito.cod-depos = ficod-depos NO-LOCK NO-ERROR.
        IF NOT AVAIL deposito THEN DO:
            MESSAGE "Deposito Informado N∆o Cadastrado" 
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
            RETURN "NOK":U.
        END.
        IF deposito.alocado = NO THEN DO:
           MESSAGE "Deposito informado n∆o permite Alocaá∆o, verifique atravÇs do programa cd0601"
               VIEW-AS ALERT-BOX INFO BUTTONS OK.
           RETURN "NOK":U.
        END.
    END.
    ON  "CHOOSE":U OF btGoToCancel IN FRAME fParam DO:
        APPLY "GO":U TO FRAME fParam.
    END.
    DISP iCodAtendente @ fiCodAtendente
         ficod-depos
         ficod-localizacao
         WITH FRAME fParam.

    ENABLE fiCodAtendente
           btGoToOK 
           btGoToCancel
           WITH FRAME fParam.
     ENABLE ficod-depos WITH FRAME fParam.
    IF v_cod_estab_usuar = "102" THEN 
       ENABLE ficod-localizacao WITH FRAME fParam.
    
    WAIT-FOR "GO":U OF FRAME fParam.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

PROCEDURE piAtualizaAstec:
    DEF INPUT PARAMETER p-de-qt-a-alocar AS DECIMAL.
    DEFINE VARIABLE h-esapi018 AS HANDLE      NO-UNDO.
   
    ASSIGN l-erro = NO.
   IF CAN-FIND(FIRST int-ped-item-astec
               WHERE int-ped-item-astec.nome-abrev   = ped-item.nome-abrev
                 AND int-ped-item-astec.nr-pedcli    = ped-item.nr-pedcli
                 AND int-ped-item-astec.nr-sequencia = ped-item.nr-sequencia
                 AND int-ped-item-astec.it-codigo    = ped-item.it-codigo) THEN DO:
       EMPTY TEMP-TABLE RowErrors.

       IF  NOT VALID-HANDLE(h-esapi018)                  OR
           h-esapi018:TYPE      <> "PROCEDURE":U         OR
          (h-esapi018:FILE-NAME <> "esapi/esapi018.p":U  AND
           h-esapi018:FILE-NAME <> "esapi/esapi018.r":U) THEN
           RUN esapi/esapi018.p PERSISTENT SET h-esapi018.

       IF VALID-HANDLE(h-esapi018) THEN DO:
          
               RUN alocarDesalocarPedItemAstec IN h-esapi018 (INPUT ped-item.nome-abrev,
                                                              INPUT ped-item.nr-pedcli,
                                                              INPUT ped-item.nr-sequencia,
                                                              INPUT ped-item.it-codigo,
                                                              INPUT 1,
                                                              INPUT p-de-qt-a-alocar).
    
               IF RETURN-VALUE = "NOK":U THEN
                   RUN getRowErrors IN h-esapi018 (OUTPUT TABLE RowErrors).
               IF CAN-FIND(FIRST RowErrors) THEN DO:
                   ASSIGN l-erro = YES.

                   FOR EACH RowErrors:
                       RUN utp/ut-msgs.p (INPUT "show":U, 
                                          INPUT 15825, 
                                          INPUT RowErrors.ErrorDescription).
                        
                   END.

                   UNDO, NEXT.
               END.


       END.

       IF VALID-HANDLE(h-esapi018) THEN
           RUN destroy IN h-esapi018.

       IF VALID-HANDLE(h-esapi018) THEN
           DELETE PROCEDURE h-esapi018.

       ASSIGN h-esapi018 = ?.

   END.
END PROCEDURE.

