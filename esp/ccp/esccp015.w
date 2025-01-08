&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcad            PROGRESS
          mgmov            PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenance


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttitem NO-UNDO LIKE item
       field r-rowid as rowid.
DEFINE TEMP-TABLE ttpedido-compr NO-UNDO LIKE pedido-compr
       field r-rowid as rowid
       field rownum as int.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMaintenance 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESCCP015 1.00.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESCCP015
&GLOBAL-DEFINE Version        1.00.00.000

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage

&GLOBAL-DEFINE ExcludeBtQueryJoins      YES
&GLOBAL-DEFINE ExcludeBtReportsJoins    YES

&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE First          NO
&GLOBAL-DEFINE Prev           NO
&GLOBAL-DEFINE Next           NO
&GLOBAL-DEFINE Last           NO
&GLOBAL-DEFINE GoTo           NO
&GLOBAL-DEFINE Search         NO

&GLOBAL-DEFINE Add            YES
&GLOBAL-DEFINE Copy           NO
&GLOBAL-DEFINE Update         NO
&GLOBAL-DEFINE Delete         NO
&GLOBAL-DEFINE Undo           NO
&GLOBAL-DEFINE Cancel         NO
&GLOBAL-DEFINE Save           NO

&GLOBAL-DEFINE ttTable        ttitem
&GLOBAL-DEFINE hDBOTable      hboin172
&GLOBAL-DEFINE DBOTable       item

&GLOBAL-DEFINE ttTable2       ttpedido-compr
&GLOBAL-DEFINE hDBOTable2     hboin295
&GLOBAL-DEFINE DBOTable2      pedido-compr

&GLOBAL-DEFINE page0KeyFields ttitem.it-codigo
&GLOBAL-DEFINE page0Fields    ttitem.it-codigo tx-item-incompleto tx-item-inativo
&GLOBAL-DEFINE page1Fields    
&GLOBAL-DEFINE page2Fields    

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable}  AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOTable2} AS HANDLE NO-UNDO.
def var iRowsReturned         as int    no-undo.
def var hProg                 as handle no-undo.
def new shared var s-it-codigo like item.it-codigo no-undo.
def new shared var s-l-ok as logi no-undo.
def var h-acomp               as handle no-undo.

DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
DEFINE VARIABLE wh-pesquisa AS HANDLE NO-UNDO.

DEFINE VARIABLE v-cod-arquivo       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v-cod-linha         AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v-nom-emitente      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v-log-arq-ok        AS LOGICAL     NO-UNDO.
DEFINE VARIABLE v-num-seq           AS INTEGER     NO-UNDO.
DEFINE VARIABLE v-cod-emitente      AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-seq               AS INTEGER     NO-UNDO.
DEFINE VARIABLE de-win-orig-width   AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-win-orig-height  AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-indice           AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-preco-aux        AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-qtde-aux         AS DECIMAL     NO-UNDO.

{esp/ccp/esccp015tt.i}

DEF BUFFER b-item-fornec FOR item-fornec.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brComponentes

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ttcomponente

/* Definitions for BROWSE brComponentes                                 */
&Scoped-define FIELDS-IN-QUERY-brComponentes ttcomponente.sequencia ttcomponente.es-codigo ttcomponente.quant-solic ttcomponente.un ttcomponente.preco-unit ttcomponente.desc-item ttcomponente.cod-emitente ttcomponente.nome-abrev ttcomponente.lote-minimo ttcomponente.lote-mul-for ttcomponente.des-situacao   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brComponentes ttcomponente.quant-solic ttcomponente.preco-unit   
&Scoped-define ENABLED-TABLES-IN-QUERY-brComponentes ttcomponente
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-brComponentes ttcomponente
&Scoped-define SELF-NAME brComponentes
&Scoped-define QUERY-STRING-brComponentes FOR EACH ttcomponente indexed-reposition
&Scoped-define OPEN-QUERY-brComponentes OPEN QUERY {&SELF-NAME} FOR EACH ttcomponente indexed-reposition.
&Scoped-define TABLES-IN-QUERY-brComponentes ttcomponente
&Scoped-define FIRST-TABLE-IN-QUERY-brComponentes ttcomponente


/* Definitions for FRAME fpage0                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ttitem.it-codigo ttitem.desc-item 
&Scoped-define ENABLED-TABLES ttitem
&Scoped-define FIRST-ENABLED-TABLE ttitem
&Scoped-Define ENABLED-OBJECTS tg-hml tg-ckd btAdd bt-excel btCancel btSave ~
btQueryJoins btReportsJoins btExit btHelp fi-qt-solic v-cod-estabel ~
tg-amostra btGoTo btVaParaItem bt-gerar brComponentes bt-alterar ~
bt-gerar-pedidos rtToolBar rtKeys 
&Scoped-Define DISPLAYED-FIELDS ttitem.it-codigo ttitem.desc-item 
&Scoped-define DISPLAYED-TABLES ttitem
&Scoped-define FIRST-DISPLAYED-TABLE ttitem
&Scoped-Define DISPLAYED-OBJECTS tg-hml tg-ckd tx-item-incompleto ~
fi-qt-solic tg-amostra tx-item-inativo 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wMaintenance AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miAdd          LABEL "&Incluir"       ACCELERATOR "CTRL-INS"
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

DEFINE MENU POPUP-MENU-wMaintenance 
       MENU-ITEM m_Maximizar    LABEL "Maximizar"     
       MENU-ITEM m_Restaurar    LABEL "Restuarar"     .


/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-alterar 
     LABEL "Alterar PO#" 
     SIZE 11 BY 1 TOOLTIP "Alterar Pedido"
     FONT 4.

DEFINE BUTTON bt-excel 
     IMAGE-UP FILE "image\excel.bmp":U
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "Importar arquivo".

DEFINE BUTTON bt-gerar 
     LABEL "Gerar PO#" 
     SIZE 11 BY 1 TOOLTIP "Gerar Pedido"
     FONT 4.

DEFINE BUTTON bt-gerar-pedidos 
     LABEL "Gerar Pedidos" 
     SIZE 11 BY 1 TOOLTIP "Gerar Pedido"
     FONT 4.

DEFINE BUTTON btAdd 
     IMAGE-UP FILE "image\im-add":U
     IMAGE-INSENSITIVE FILE "image\ii-add":U
     LABEL "Add" 
     SIZE 4 BY 1.25 TOOLTIP "Incluir"
     FONT 4.

DEFINE BUTTON btCancel 
     IMAGE-UP FILE "image\im-can":U
     IMAGE-INSENSITIVE FILE "image\im-can":U
     LABEL "Cancel" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btGoTo 
     IMAGE-UP FILE "image\im-enter":U
     IMAGE-INSENSITIVE FILE "image\ii-enter":U
     LABEL "Go To" 
     SIZE 4 BY .88.

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image\im-hel":U
     IMAGE-INSENSITIVE FILE "image\ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

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

DEFINE BUTTON btVaParaItem 
     LABEL "V  Para Item" 
     SIZE 11 BY 1.

DEFINE VARIABLE fi-qt-solic AS DECIMAL FORMAT ">>>,>>>,>>9" INITIAL 1 
     LABEL "Qtde":R5 
     VIEW-AS FILL-IN 
     SIZE 10.43 BY .88 NO-UNDO.

DEFINE VARIABLE tx-item-inativo AS CHARACTER FORMAT "X(256)":U INITIAL "Linhas em amarelo sÆo itens nÆo cadastrados ou inativos." 
      VIEW-AS TEXT 
     SIZE 47 BY .54
     BGCOLOR 14  NO-UNDO.

DEFINE VARIABLE tx-item-incompleto AS CHARACTER FORMAT "X(256)":U INITIAL "Letras em vermelho sÆo cadastros incompletos de Item x Fornecedor." 
      VIEW-AS TEXT 
     SIZE 47 BY .54
     FGCOLOR 12  NO-UNDO.

DEFINE VARIABLE v-cod-estabel AS CHARACTER FORMAT "X(3)":U INITIAL "105" 
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 92 BY 2.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 92 BY 1.5
     BGCOLOR 7 .

DEFINE VARIABLE tg-amostra AS LOGICAL INITIAL no 
     LABEL "Amostra" 
     VIEW-AS TOGGLE-BOX
     SIZE 8.29 BY .83 NO-UNDO.

DEFINE VARIABLE tg-ckd AS LOGICAL INITIAL yes 
     LABEL "CKD" 
     VIEW-AS TOGGLE-BOX
     SIZE 7 BY .83 NO-UNDO.

DEFINE VARIABLE tg-hml AS LOGICAL INITIAL no 
     LABEL "Homologa‡Æo" 
     VIEW-AS TOGGLE-BOX
     SIZE 12.72 BY .83 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brComponentes FOR 
      ttcomponente SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brComponentes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brComponentes wMaintenance _FREEFORM
  QUERY brComponentes DISPLAY
      ttcomponente.sequencia
      ttcomponente.es-codigo width 12.43
      ttcomponente.quant-solic FORMAT ">>>,>>>,>>9.99" width 10
      ttcomponente.un
      ttcomponente.preco-unit format ">>,>>9.99999"
      ttcomponente.desc-item
      ttcomponente.cod-emitente LABEL "Fornec"
      ttcomponente.nome-abrev   LABEL "Nome"
      ttcomponente.lote-minimo
      ttcomponente.lote-mul-for
      ttcomponente.des-situacao LABEL "Situa‡Æo" FORMAT "x(30)"
enable
ttcomponente.quant-solic
ttcomponente.preco-unit
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS NO-VALIDATE SIZE 91 BY 10.5
         FONT 2.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     tg-hml AT ROW 3.88 COL 55.29 WIDGET-ID 36
     tg-ckd AT ROW 3.88 COL 47.57 WIDGET-ID 24
     tx-item-incompleto AT ROW 15.83 COL 45.86 NO-LABEL WIDGET-ID 26
     btAdd AT ROW 1.13 COL 1.57 HELP
          "Inclui nova ocorrˆncia"
     bt-excel AT ROW 1.13 COL 5.57 HELP
          "Gerar Relat¢rio de Embarque no Excel" WIDGET-ID 18
     btCancel AT ROW 1.13 COL 66 HELP
          "Cancela altera‡äes"
     btSave AT ROW 1.13 COL 70 HELP
          "Confirma altera‡äes"
     btQueryJoins AT ROW 1.13 COL 74.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda"
     ttitem.it-codigo AT ROW 2.83 COL 7 COLON-ALIGNED WIDGET-ID 12
          VIEW-AS FILL-IN 
          SIZE 10.43 BY .88
     fi-qt-solic AT ROW 3.83 COL 7 COLON-ALIGNED HELP
          "Quantidade a ser comprada" WIDGET-ID 14
     v-cod-estabel AT ROW 3.83 COL 30.14 COLON-ALIGNED WIDGET-ID 20
     tg-amostra AT ROW 3.88 COL 37.72 WIDGET-ID 22
     btGoTo AT ROW 3.83 COL 69.14 HELP
          "V  Para" WIDGET-ID 16
     btVaParaItem AT ROW 16 COL 1.29 WIDGET-ID 2
     ttitem.desc-item AT ROW 2.83 COL 18 COLON-ALIGNED NO-LABEL WIDGET-ID 10
          VIEW-AS FILL-IN 
          SIZE 69.72 BY .88 NO-TAB-STOP 
     bt-gerar AT ROW 16 COL 12.29 HELP
          "Confirma altera‡äes" WIDGET-ID 4
     brComponentes AT ROW 5.25 COL 2 WIDGET-ID 300
     bt-alterar AT ROW 16 COL 23.29 HELP
          "Confirma altera‡äes" WIDGET-ID 30
     tx-item-inativo AT ROW 16.5 COL 45.86 NO-LABEL WIDGET-ID 28
     bt-gerar-pedidos AT ROW 16 COL 34.29 HELP
          "Confirma altera‡äes" WIDGET-ID 34
     rtToolBar AT ROW 1 COL 1
     rtKeys AT ROW 2.67 COL 1
    WITH 1 DOWN NO-BOX OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 92.29 BY 16.08
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window Template
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: ttitem T "?" NO-UNDO mgcad item
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: ttpedido-compr T "?" NO-UNDO mgmov pedido-compr
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
          field rownum as int
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
         HEIGHT             = 16.08
         WIDTH              = 92.29
         MAX-HEIGHT         = 200
         MAX-WIDTH          = 300
         VIRTUAL-HEIGHT     = 200
         VIRTUAL-WIDTH      = 300
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         POPUP-MENU         = MENU POPUP-MENU-wMaintenance:HANDLE
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU mbMain:HANDLE
       {&WINDOW-NAME}:POPUP-MENU = MENU POPUP-MENU-wMaintenance:HANDLE.
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
   FRAME-NAME Custom                                                    */
/* BROWSE-TAB brComponentes bt-gerar fpage0 */
ASSIGN 
       brComponentes:COLUMN-RESIZABLE IN FRAME fpage0       = TRUE
       brComponentes:COLUMN-MOVABLE IN FRAME fpage0         = TRUE.

/* SETTINGS FOR FILL-IN tx-item-inativo IN FRAME fpage0
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN tx-item-incompleto IN FRAME fpage0
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN v-cod-estabel IN FRAME fpage0
   NO-DISPLAY                                                           */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMaintenance)
THEN wMaintenance:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brComponentes
/* Query rebuild information for BROWSE brComponentes
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH ttcomponente indexed-reposition.
     _END_FREEFORM
     _Query            is NOT OPENED
*/  /* BROWSE brComponentes */
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenance wMaintenance
ON WINDOW-RESIZED OF wMaintenance
DO:
    RUN piWindowResize.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fpage0
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fpage0 wMaintenance
ON MOUSE-SELECT-DBLCLICK OF FRAME fpage0
DO:
    IF  wMaintenance:WINDOW-STATE = 1
    THEN
        wMaintenance:WINDOW-STATE = 3.  
    ELSE
        wMaintenance:WINDOW-STATE = 1.  

    RUN piWindowResize.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brComponentes
&Scoped-define SELF-NAME brComponentes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brComponentes wMaintenance
ON ROW-DISPLAY OF brComponentes IN FRAME fpage0
DO:
    IF  AVAIL ttcomponente                   AND
              tg-amostra                = NO AND
             (ttcomponente.cod-emitente = 0   OR
              ttcomponente.preco-unit   = 0)
              
    THEN
        ASSIGN ttcomponente.sequencia:FGCOLOR    IN BROWSE brcomponentes = 12
               ttcomponente.es-codigo:FGCOLOR    IN BROWSE brcomponentes = 12
               ttcomponente.quant-solic:FGCOLOR  IN BROWSE brcomponentes = 12
               ttcomponente.un:FGCOLOR           IN BROWSE brcomponentes = 12
               ttcomponente.preco-unit:FGCOLOR   IN BROWSE brcomponentes = 12
               ttcomponente.desc-item:FGCOLOR    IN BROWSE brcomponentes = 12
               ttcomponente.cod-emitente:FGCOLOR IN BROWSE brcomponentes = 12
               ttcomponente.nome-abrev:FGCOLOR   IN BROWSE brcomponentes = 12
               ttcomponente.lote-minimo:FGCOLOR  IN BROWSE brcomponentes = 12
               ttcomponente.lote-mul-for:FGCOLOR IN BROWSE brcomponentes = 12
               ttcomponente.des-situacao:FGCOLOR IN BROWSE brcomponentes = 12.
    ELSE
        ASSIGN ttcomponente.sequencia:FGCOLOR    IN BROWSE brcomponentes = 0
               ttcomponente.es-codigo:FGCOLOR    IN BROWSE brcomponentes = 0
               ttcomponente.quant-solic:FGCOLOR  IN BROWSE brcomponentes = 0
               ttcomponente.un:FGCOLOR           IN BROWSE brcomponentes = 0
               ttcomponente.preco-unit:FGCOLOR   IN BROWSE brcomponentes = 0
               ttcomponente.desc-item:FGCOLOR    IN BROWSE brcomponentes = 0
               ttcomponente.cod-emitente:FGCOLOR IN BROWSE brcomponentes = 0
               ttcomponente.nome-abrev:FGCOLOR   IN BROWSE brcomponentes = 0
               ttcomponente.lote-minimo:FGCOLOR  IN BROWSE brcomponentes = 0
               ttcomponente.lote-mul-for:FGCOLOR IN BROWSE brcomponentes = 0
               ttcomponente.des-situacao:FGCOLOR IN BROWSE brcomponentes = 0.


    IF  AVAIL ttcomponente AND
              ttcomponente.cod-situacao <> 1 /* Ativo */
    THEN
        ASSIGN ttcomponente.sequencia:BGCOLOR    IN BROWSE brcomponentes = 14
               ttcomponente.es-codigo:BGCOLOR    IN BROWSE brcomponentes = 14
               ttcomponente.quant-solic:BGCOLOR  IN BROWSE brcomponentes = 14
               ttcomponente.un:BGCOLOR           IN BROWSE brcomponentes = 14
               ttcomponente.preco-unit:BGCOLOR   IN BROWSE brcomponentes = 14
               ttcomponente.desc-item:BGCOLOR    IN BROWSE brcomponentes = 14
               ttcomponente.cod-emitente:BGCOLOR IN BROWSE brcomponentes = 14
               ttcomponente.nome-abrev:BGCOLOR   IN BROWSE brcomponentes = 14
               ttcomponente.lote-minimo:BGCOLOR  IN BROWSE brcomponentes = 14
               ttcomponente.lote-mul-for:BGCOLOR IN BROWSE brcomponentes = 14
               ttcomponente.des-situacao:BGCOLOR IN BROWSE brcomponentes = 14.
    ELSE
        ASSIGN ttcomponente.sequencia:BGCOLOR    IN BROWSE brcomponentes = ?
               ttcomponente.es-codigo:BGCOLOR    IN BROWSE brcomponentes = ?
               ttcomponente.quant-solic:BGCOLOR  IN BROWSE brcomponentes = ?
               ttcomponente.un:BGCOLOR           IN BROWSE brcomponentes = ?
               ttcomponente.preco-unit:BGCOLOR   IN BROWSE brcomponentes = ?
               ttcomponente.desc-item:BGCOLOR    IN BROWSE brcomponentes = ?
               ttcomponente.cod-emitente:BGCOLOR IN BROWSE brcomponentes = ?
               ttcomponente.nome-abrev:BGCOLOR   IN BROWSE brcomponentes = ?
               ttcomponente.lote-minimo:BGCOLOR  IN BROWSE brcomponentes = ?
               ttcomponente.lote-mul-for:BGCOLOR IN BROWSE brcomponentes = ?
               ttcomponente.des-situacao:BGCOLOR IN BROWSE brcomponentes = ?.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-alterar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-alterar wMaintenance
ON CHOOSE OF bt-alterar IN FRAME fpage0 /* Alterar PO# */
DO:
    FIND FIRST ttcomponente NO-LOCK
        WHERE  ttcomponente.preco-unit <= 0 NO-ERROR.

    IF  AVAIL ttcomponente
    THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U, 
                           INPUT 17006, 
                           INPUT "Pre‡o unit rio inv lido~~":U +
                                 "NÆo ‚ permitido gerar pedidos onde o pre‡o unit rio do item seja zero.").
        return no-apply.
    END.


    assign s-it-codigo = input frame fPage0 ttitem.it-codigo
           s-l-ok      = no.

    disable ttitem.it-codigo fi-qt-solic tg-amostra tg-ckd tg-hml v-cod-estabel btGoTo btAdd with frame fPage0.

    wMaintenance:SENSITIVE = FALSE.

    RUN esp/ccp/esccp015a.w (input ?,
                             input "Add":u,
                             input this-procedure,
                             INPUT "AlterarPedido").

    wMaintenance:SENSITIVE = TRUE.

    if not s-l-ok then do:
        enable ttitem.it-codigo fi-qt-solic v-cod-estabel tg-amostra tg-ckd tg-hml btGoTo with frame fPage0.
        return no-apply.
    end.
    else do:
        enable btAdd bt-excel with frame fPage0.
    end.

    assign fi-qt-solic:screen-value      = ""
           v-cod-estabel:SCREEN-VALUE    = "105"
           ttitem.desc-item:screen-value = ""
           ttitem.it-codigo:screen-value = "".

    empty temp-table ttcomponente.

    &scop QUERY-NAME brComponentes
    {&OPEN-QUERY-{&QUERY-NAME}}
    &undef QUERY-NAME

    disable btVaParaItem bt-gerar bt-alterar with frame fPage0.
    assign ttcomponente.quant-solic:read-only in browse brComponentes = yes
           ttcomponente.preco-unit:read-only  in browse brComponentes = yes.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-excel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-excel wMaintenance
ON CHOOSE OF bt-excel IN FRAME fpage0
DO:
    assign v-cod-arquivo = "".

    SYSTEM-DIALOG GET-FILE v-cod-arquivo
       FILTERS "*.csv" "*.csv"
       DEFAULT-EXTENSION "csv"
       MUST-EXIST
       USE-FILENAME
       TITLE 'Importar do arquivo'
       UPDATE v-log-arq-ok.

    IF v-log-arq-ok 
    THEN DO:
        EMPTY TEMP-TABLE ttitem.
        EMPTY TEMP-TABLE tt-estrutura.
        EMPTY TEMP-TABLE ttcomponente.

        OPEN QUERY brComponentes FOR EACH ttComponente.

        INPUT FROM value(v-cod-arquivo).
        
        repeat:
           IMPORT UNFORMATTED v-cod-linha.
           
           assign v-num-seq = v-num-seq + 10.
           
           find first item no-lock 
               where  item.it-codigo =  entry(1,v-cod-linha,";") no-error.
                  
           create ttcomponente.
           assign ttcomponente.sequencia    = v-num-seq 
                  ttcomponente.es-codigo    = entry(1,v-cod-linha,";")
                  ttcomponente.desc-item    = IF AVAIL ITEM THEN item.desc-item ELSE ""
                  ttcomponente.quant-est    = dec(entry(2,v-cod-linha,";"))
                  ttcomponente.un           = IF AVAIL ITEM THEN item.un ELSE ""
                  ttcomponente.preco-unit   = dec(entry(3,v-cod-linha,";"))
                  ttcomponente.quant-solic  = dec(entry(2,v-cod-linha,";"))
                  ttcomponente.cod-situacao = 0
                  ttcomponente.des-situacao = "Item NÆo Cadastrado".

            FIND item-uni-estab NO-LOCK
                WHERE item-uni-estab.it-codigo   = ttcomponente.es-codigo
                  AND item-uni-estab.cod-estabel = INPUT FRAME fpage0 v-cod-estabel NO-ERROR.

            IF  AVAIL item-uni-estab
            THEN
                ASSIGN ttcomponente.cod-situacao = item-uni-estab.cod-obsoleto
                       ttcomponente.des-situacao = {ininc/i17in172.i 04 item-uni-estab.cod-obsoleto}.
        end.
        input close.
    
        OPEN QUERY brComponentes FOR EACH ttComponente.
    END.

    FIND FIRST ttcomponente NO-LOCK NO-ERROR.

    IF  AVAIL ttcomponente
    THEN
        enable btVaParaItem bt-gerar bt-gerar-pedidos bt-alterar with frame fPage0.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-gerar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-gerar wMaintenance
ON CHOOSE OF bt-gerar IN FRAME fpage0 /* Gerar PO# */
DO:
    FIND FIRST ttcomponente NO-LOCK
        WHERE  ttcomponente.preco-unit <= 0 NO-ERROR.

    IF  AVAIL ttcomponente
    THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U, 
                           INPUT 17006, 
                           INPUT "Pre‡o unit rio inv lido~~":U +
                                 "NÆo ‚ permitido gerar pedidos onde o pre‡o unit rio do item seja zero.").
        return no-apply.
    END.


    assign s-it-codigo = input frame fPage0 ttitem.it-codigo
           s-l-ok      = no.

    disable ttitem.it-codigo fi-qt-solic tg-amostra tg-ckd tg-hml v-cod-estabel btGoTo btAdd with frame fPage0.

    wMaintenance:SENSITIVE = FALSE.

    RUN esp/ccp/esccp015a.w (input ?,
                             input "Add":u,
                             input this-procedure,
                             INPUT "GerarPedido").

    wMaintenance:SENSITIVE = TRUE.

    if not s-l-ok then do:
        enable ttitem.it-codigo fi-qt-solic v-cod-estabel tg-amostra tg-ckd tg-hml btGoTo with frame fPage0.
        return no-apply.
    end.
    else do:
        enable btAdd bt-excel with frame fPage0.
    end.

    assign fi-qt-solic:screen-value      = ""
           v-cod-estabel:SCREEN-VALUE    = "105"
           ttitem.desc-item:screen-value = ""
           ttitem.it-codigo:screen-value = "".

    empty temp-table ttcomponente.

    &scop QUERY-NAME brComponentes
    {&OPEN-QUERY-{&QUERY-NAME}}
    &undef QUERY-NAME

    disable btVaParaItem bt-gerar bt-alterar with frame fPage0.
    assign ttcomponente.quant-solic:read-only in browse brComponentes = yes
           ttcomponente.preco-unit:read-only  in browse brComponentes = yes.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-gerar-pedidos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-gerar-pedidos wMaintenance
ON CHOOSE OF bt-gerar-pedidos IN FRAME fpage0 /* Gerar Pedidos */
DO:
    FIND FIRST ttcomponente NO-LOCK
        WHERE  ttcomponente.preco-unit <= 0 NO-ERROR.

    IF  AVAIL ttcomponente
    THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U, 
                           INPUT 17006, 
                           INPUT "Pre‡o unit rio inv lido~~":U +
                                 "NÆo ‚ permitido gerar pedidos onde o pre‡o unit rio do item seja zero.").
        return no-apply.
    END.


    assign s-it-codigo = input frame fPage0 ttitem.it-codigo
           s-l-ok      = no.

    disable ttitem.it-codigo fi-qt-solic tg-amostra tg-ckd tg-hml v-cod-estabel btGoTo btAdd with frame fPage0.

    wMaintenance:SENSITIVE = FALSE.

    RUN esp/ccp/esccp015b.w (input ?,
                             input "Add":u,
                             input this-procedure,
                             INPUT "GerarPedido").

    wMaintenance:SENSITIVE = TRUE.

    if not s-l-ok then do:
        enable ttitem.it-codigo fi-qt-solic v-cod-estabel tg-amostra tg-ckd tg-hml btGoTo with frame fPage0.
        return no-apply.
    end.
    else do:
        enable btAdd bt-excel with frame fPage0.
    end.

    assign fi-qt-solic:screen-value      = ""
           v-cod-estabel:SCREEN-VALUE    = "105"
           ttitem.desc-item:screen-value = ""
           ttitem.it-codigo:screen-value = "".

    empty temp-table ttcomponente.

    &scop QUERY-NAME brComponentes
    {&OPEN-QUERY-{&QUERY-NAME}}
    &undef QUERY-NAME

    disable btVaParaItem bt-gerar bt-alterar with frame fPage0.
    assign ttcomponente.quant-solic:read-only in browse brComponentes = yes
           ttcomponente.preco-unit:read-only  in browse brComponentes = yes.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btAdd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAdd wMaintenance
ON CHOOSE OF btAdd IN FRAME fpage0 /* Add */
OR CHOOSE OF MENU-ITEM miAdd in MENU mbMain DO:

    enable ttitem.it-codigo fi-qt-solic v-cod-estabel tg-amostra tg-hml tg-ckd btGoTo with frame fPage0.
    assign ttcomponente.quant-solic:read-only in browse brComponentes = no
           ttcomponente.preco-unit:read-only in browse brComponentes  = no
           bt-excel:SENSITIVE                                         = YES
           fi-qt-solic                                                = 1
           v-cod-estabel                                              = "105"
           ttitem.desc-item:screen-value                              = ""
           ttitem.it-codigo:screen-value                              = ""
           tg-ckd                                                     = YES
           tg-hml                                                     = NO.

    EMPTY TEMP-TABLE ttitem.
    EMPTY TEMP-TABLE tt-estrutura.
    EMPTY TEMP-TABLE ttcomponente.

    {&OPEN-QUERY-{&QUERY-NAME}} 

    disp fi-qt-solic v-cod-estabel tg-ckd tg-hml with frame fPage0.
    apply "ENTRY":U to ttitem.it-codigo in frame fPage0.

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


&Scoped-define SELF-NAME btGoTo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btGoTo wMaintenance
ON CHOOSE OF btGoTo IN FRAME fpage0 /* Go To */
DO:
    ASSIGN v-cod-estabel  = INPUT FRAME {&FRAME-NAME} v-cod-estabel
           fi-qt-solic    = INPUT FRAME {&FRAME-NAME} fi-qt-solic
           tg-amostra     = INPUT FRAME {&FRAME-NAME} tg-amostra
           tg-ckd         = INPUT FRAME {&FRAME-NAME} tg-ckd
           tg-hml         = INPUT FRAME {&FRAME-NAME} tg-hml
           v-cod-emitente = 0
           v-nom-emitente = "".

    FIND estabelec NO-LOCK
        WHERE estabelec.cod-estabel = v-cod-estabel NO-ERROR.

    IF  NOT AVAIL estabelec
    THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U, 
                           INPUT 17006, 
                           INPUT "Estabelecimento inv lido~~":U +
                                 "O estabelecimento informado nÆo existe.").
    
        apply "entry" to v-cod-estabel in frame fPage0.
        return no-apply.
    END.

    EMPTY TEMP-TABLE ttitem.
    EMPTY TEMP-TABLE tt-estrutura.
    EMPTY TEMP-TABLE ttcomponente.

    run setConstraintFiltroItCodigo in {&hDBOTable} (input ttitem.it-codigo:screen-value,
                                                     input ttitem.it-codigo:screen-value).
    run openQueryStatic in {&hDBOTable} (input "ByItCodigo":u).
    run getRecord in {&hDBOTable} (output table ttitem).
    find first ttitem no-error.
    
    if not avail ttitem then do:
        RUN utp/ut-msgs.p (input "show",
                           input 2,
                           input "Item").
        apply "entry" to ttitem.it-codigo in frame fPage0.
        return no-apply.
    
    end.

    if fi-qt-solic = 0 then do:
        RUN utp/ut-msgs.p (INPUT "SHOW":U, 
                           INPUT 17006, 
                           INPUT "Quantidade nÆo pode ser zero~~":U +
                                 "Informe ao menos a quantidade de 1 (um) item").
    
        apply "entry" to fi-qt-solic in frame fPage0.
        return no-apply.
    
    end.
    
    assign input frame fPage0 fi-qt-solic.
    
    run utp/ut-acomp.p persistent set h-acomp.
    run pi-inicializar in h-acomp (input "Lendo Estrutura").
    run pi-acompanhar  in h-acomp (input "Item " + ttitem.it-codigo).

    EMPTY TEMP-TABLE tt-estrutura.

    RUN pi-carrega-estrutura (INPUT ttitem.it-codigo,
                              INPUT fi-qt-solic).

    RUN pi-finalizar IN h-acomp.
                                          
    ASSIGN i-seq = 0.

   IF  tg-amostra = NO
    THEN DO:
        FIND FIRST item-fornec-estab NO-LOCK
            WHERE  item-fornec-estab.it-codigo   = ttitem.it-codigo:screen-value
              AND  item-fornec-estab.cod-estabel = v-cod-estabel
              AND  item-fornec-estab.ativo       = YES NO-ERROR.

        IF  AVAIL item-fornec-estab
        THEN DO:
            FIND emitente NO-LOCK
                WHERE emitente.cod-emitente = item-fornec-estab.cod-emitente NO-ERROR.

            ASSIGN v-cod-emitente = item-fornec-estab.cod-emitente
                   v-nom-emitente = emitente.nome-abrev.
        END.
    END.

    for each tt-estrutura BY tt-estrutura.es-codigo:

        FIND item-uni-estab NO-LOCK
            WHERE item-uni-estab.it-codigo   = tt-estrutura.es-codigo
              AND item-uni-estab.cod-estabel = v-cod-estabel NO-ERROR.

        IF  AVAIL item-uni-estab AND
                  item-uni-estab.tp-desp-padrao = 2 /* Importa‡Æo */
        THEN DO:
            FIND ITEM NO-LOCK 
                WHERE item.it-codigo = tt-estrutura.es-codigo NO-ERROR.

            find first ttcomponente
                where  ttcomponente.es-codigo = tt-estrutura.es-codigo no-error.
            if not avail ttcomponente 
            then do:    
                create ttcomponente.
                assign i-seq                     = i-seq + 10
                       ttcomponente.sequencia    = i-seq 
                       ttcomponente.es-codigo    = tt-estrutura.es-codigo
                       ttcomponente.desc-item    = item.desc-item
                       ttcomponente.quant-solic  = tt-estrutura.quant-usada
                       ttcomponente.un           = item.un
                       ttcomponente.preco-unit   = 0
                       ttcomponente.cod-situacao = item-uni-estab.cod-obsoleto
                       ttcomponente.des-situacao = {ininc/i17in172.i 04 item-uni-estab.cod-obsoleto}
                       ttcomponente.cod-emitente = v-cod-emitente
                       ttcomponente.nome-abrev   = v-nom-emitente.

               IF  tg-amostra = NO
               THEN
                   FIND FIRST item-fornec-estab NO-LOCK
                       WHERE  item-fornec-estab.it-codigo    = tt-estrutura.es-codigo
                         AND  item-fornec-estab.cod-emitente = v-cod-emitente
                         AND  item-fornec-estab.cod-estabel  = v-cod-estabel
                         AND  item-fornec-estab.ativo        = YES NO-ERROR.

                IF  AVAIL item-fornec-estab
                THEN DO:
                    ASSIGN ttcomponente.lote-minimo  = item-fornec-estab.lote-minimo    
                           ttcomponente.lote-mul-for = item-fornec-estab.lote-mul-for.  

                    FIND LAST tb-pr-cc NO-LOCK
                        WHERE tb-pr-cc.cod-emitente = item-fornec-estab.cod-emitente
                          AND tb-pr-cc.situacao     = 1 /* Ativo */
                          AND tb-pr-cc.dt-termino  >= TODAY NO-ERROR.
    
                    IF  AVAIL tb-pr-cc
                    THEN DO:
                        
                        ASSIGN de-preco-aux = 0
                               de-qtde-aux  = tt-estrutura.quant-usada.
                        FOR EACH item-tab NO-LOCK 
                            WHERE  item-tab.it-codigo    = tt-estrutura.es-codigo        
                              AND  item-tab.cod-emitente = tb-pr-cc.cod-emitente
                              AND  item-tab.cod-cond-pag = tb-pr-cc.cod-cond-pag
                              AND  item-tab.nr-tab       = tb-pr-cc.nr-tab :
                              
                            IF item-tab.quant-min <= de-qtde-aux THEN
                                ASSIGN de-preco-aux  = item-tab.pr-item.
                            ELSE 
                                LEAVE.
                        END.
                        ASSIGN ttcomponente.preco-unit = de-preco-aux.
                    END.
                END. /* IF  AVAIL item-fornec-estab */
            END. /* if not avail ttcomponente */
            ELSE
                ASSIGN ttcomponente.quant-solic  = ttcomponente.quant-solic + tt-estrutura.quant-usada.

            FIND FIRST item-fornec-estab NO-LOCK
                 WHERE  item-fornec-estab.it-codigo    = ttcomponente.es-codigo
                   AND  item-fornec-estab.cod-emitente = v-cod-emitente
                   AND  item-fornec-estab.cod-estabel  = v-cod-estabel
                   AND  item-fornec-estab.ativo        = YES NO-ERROR.
            FIND LAST tb-pr-cc NO-LOCK
                WHERE tb-pr-cc.cod-emitente = item-fornec-estab.cod-emitente
                  AND tb-pr-cc.situacao     = 1 /* Ativo */
                  AND tb-pr-cc.dt-termino  >= TODAY NO-ERROR.
    
            IF  AVAIL tb-pr-cc THEN DO:
                
                ASSIGN de-preco-aux = 0
                       de-qtde-aux  = ttcomponente.quant-solic.
                FOR EACH item-tab NO-LOCK 
                    WHERE  item-tab.it-codigo    = ttcomponente.es-codigo        
                      AND  item-tab.cod-emitente = tb-pr-cc.cod-emitente
                      AND  item-tab.cod-cond-pag = tb-pr-cc.cod-cond-pag
                      AND  item-tab.nr-tab       = tb-pr-cc.nr-tab :
                      
                    IF item-tab.quant-min <= de-qtde-aux THEN
                        ASSIGN de-preco-aux  = item-tab.pr-item.
                    ELSE 
                        LEAVE.
                END.
                ASSIGN ttcomponente.preco-unit = de-preco-aux.
            END.

        END. /* IF  AVAIL item-uni-estab AND */
    end. /* for each tt-estrutura BY tt-estrutura.es-codigo: */ 

    FIND FIRST param-compra NO-LOCK NO-ERROR.

/* Validar lotes do item */
    IF  tg-amostra = NO
    THEN DO:
        FOR EACH ttcomponente,
            FIRST ITEM NO-LOCK 
                WHERE item.it-codigo = ttcomponente.es-codigo:

            if  item.it-codigo <> "" and 
                item.it-codigo <> ? 
            then DO:
                FIND FIRST b-item-fornec NO-LOCK
                    WHERE  b-item-fornec.it-codigo = ttitem.it-codigo:SCREEN-VALUE
                      AND  b-item-fornec.ativo     = YES NO-ERROR.

                IF  AVAIL b-item-fornec
                THEN
                    FIND FIRST item-fornec NO-LOCK
                        WHERE  item-fornec.it-codigo    = ttcomponente.es-codigo 
                          AND  item-fornec.cod-emitente = b-item-fornec.cod-emitente            
                          AND  item-fornec.ativo        = YES NO-ERROR.
            END.

            IF  AVAILABLE item-fornec 
            THEN DO:
                ASSIGN de-indice = item-fornec.fator-conver / 
                                   IF  item-fornec.num-casa-dec = 0 THEN 1
                                   ELSE EXP(10,item-fornec.num-casa-dec).   
            END.
            ELSE
                ASSIGN de-indice = 1.

            ASSIGN de-indice                = 1 WHEN (de-indice = 0 OR de-indice = ?)
                   ttcomponente.quant-solic = ttcomponente.quant-solic * de-indice. 

            IF  ttcomponente.quant-solic <= ttcomponente.lote-minimo
            THEN
                ASSIGN ttcomponente.quant-solic = ttcomponente.lote-minimo.
            ELSE DO:
                IF  ttcomponente.quant-solic MOD ttcomponente.lote-mul-for <> 0
                THEN
                    ASSIGN ttcomponente.quant-solic = (TRUNCATE(ttcomponente.quant-solic / ttcomponente.lote-mul-for,0) * ttcomponente.lote-mul-for) + ttcomponente.lote-mul-for.
                ELSE
                    ASSIGN ttcomponente.quant-solic =  TRUNCATE(ttcomponente.quant-solic / ttcomponente.lote-mul-for,0) * ttcomponente.lote-mul-for.
            END.

            ASSIGN ttcomponente.quant-solic = ttcomponente.quant-solic / de-indice.

            FIND FIRST item-fornec-estab NO-LOCK
                 WHERE  item-fornec-estab.it-codigo    = ttcomponente.es-codigo
                   AND  item-fornec-estab.cod-emitente = v-cod-emitente
                   AND  item-fornec-estab.cod-estabel  = v-cod-estabel
                   AND  item-fornec-estab.ativo        = YES NO-ERROR.
            FIND LAST tb-pr-cc NO-LOCK
                WHERE tb-pr-cc.cod-emitente = item-fornec-estab.cod-emitente
                  AND tb-pr-cc.situacao     = 1 /* Ativo */
                  AND tb-pr-cc.dt-termino  >= TODAY NO-ERROR.
    
            IF  AVAIL tb-pr-cc THEN DO:
                
                ASSIGN de-preco-aux = 0
                       de-qtde-aux  = ttcomponente.quant-solic.
                FOR EACH item-tab NO-LOCK 
                    WHERE  item-tab.it-codigo    = ttcomponente.es-codigo        
                      AND  item-tab.cod-emitente = tb-pr-cc.cod-emitente
                      AND  item-tab.cod-cond-pag = tb-pr-cc.cod-cond-pag
                      AND  item-tab.nr-tab       = tb-pr-cc.nr-tab :
                      
                    IF item-tab.quant-min <= de-qtde-aux THEN
                        ASSIGN de-preco-aux  = item-tab.pr-item.
                    ELSE 
                        LEAVE.
                END.
                ASSIGN ttcomponente.preco-unit = de-preco-aux.
            END.

        END.
    END.

    &scop QUERY-NAME brComponentes
    {&OPEN-QUERY-{&QUERY-NAME}}   
    &undef QUERY-NAME  
    
    FIND FIRST ttcomponente NO-LOCK NO-ERROR.

    IF  AVAIL ttcomponente
    THEN
        enable btVaParaItem bt-gerar bt-gerar-pedidos bt-alterar  with frame fPage0.
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


&Scoped-define SELF-NAME btVaParaItem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btVaParaItem wMaintenance
ON CHOOSE OF btVaParaItem IN FRAME fpage0 /* V  Para Item */
DO:
  run vaParaItem in this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttitem.it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttitem.it-codigo wMaintenance
ON F5 OF ttitem.it-codigo IN FRAME fpage0 /* Item */
DO:

  {include/zoomvar.i &prog-zoom="inzoom/z02in172.w"
                      &campo="ttitem.it-codigo"
                      &campozoom="it-codigo"
                      &frame="fPage0"
                      &campo2="ttitem.desc-item"
                      &campozoom2="desc-item"
                      &frame2="fPage0"}

  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttitem.it-codigo wMaintenance
ON LEAVE OF ttitem.it-codigo IN FRAME fpage0 /* Item */
DO:
    FIND ITEM NO-LOCK
        WHERE ITEM.it-codigo = ttitem.it-codigo:SCREEN-VALUE IN FRAME fPage0 NO-ERROR.

    IF  AVAIL ITEM
    THEN
        DISP ITEM.desc-item @ ttitem.desc-item WITH FRAME fpage0.
    ELSE
        DISP "" @ ttitem.desc-item WITH FRAME fpage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttitem.it-codigo wMaintenance
ON MOUSE-SELECT-DBLCLICK OF ttitem.it-codigo IN FRAME fpage0 /* Item */
DO:
  apply "F5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Maximizar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Maximizar wMaintenance
ON CHOOSE OF MENU-ITEM m_Maximizar /* Maximizar */
DO:
    wMaintenance:WINDOW-STATE = 1.  
    RUN piWindowResize.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Restaurar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Restaurar wMaintenance
ON CHOOSE OF MENU-ITEM m_Restaurar /* Restuarar */
DO:
    wMaintenance:WINDOW-STATE = 3.
    RUN piWindowResize.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-ckd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-ckd wMaintenance
ON VALUE-CHANGED OF tg-ckd IN FRAME fpage0 /* CKD */
DO:
   IF SELF:CHECKED THEN
       ASSIGN tg-hml:CHECKED = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-hml
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-hml wMaintenance
ON VALUE-CHANGED OF tg-hml IN FRAME fpage0 /* Homologa‡Æo */
DO:
    IF SELF:CHECKED THEN
       ASSIGN tg-ckd:CHECKED = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME v-cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL v-cod-estabel wMaintenance
ON F5 OF v-cod-estabel IN FRAME fpage0 /* Estabelecimento */
DO:
    {include/zoomvar.i &prog-zoom="adzoom/z01ad107.w"
                       &campo=v-cod-estabel
                       &campozoom=cod-estabel}     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL v-cod-estabel wMaintenance
ON MOUSE-SELECT-DBLCLICK OF v-cod-estabel IN FRAME fpage0 /* Estabelecimento */
DO:
    APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenance 


on "RETURN":U of ttcomponente.quant-solic in browse brComponentes do:
    return no-apply.
end.    
on "RETURN":U of ttcomponente.preco-unit in browse brComponentes do:
    return no-apply.
end.    

/*:T--- L¢gica para inicializa‡Æo do programam ---*/

/* {maintenance/mainblock.i} */

{window/mainblock.i}

/* Determinar o tamanho m¡nimo da tela */
ASSIGN wMaintenance:MIN-WIDTH  = wMaintenance:WIDTH
       wMaintenance:MIN-HEIGHT = wMaintenance:HEIGHT.

/* Guardar valores originais da tela */
ASSIGN de-win-orig-width  = wMaintenance:WIDTH
       de-win-orig-height = wMaintenance:HEIGHT.

ASSIGN tx-item-inativo:BGCOLOR IN FRAME fpage0 = 14.

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

    if  valid-handle({&hDBOTable}) then
        delete procedure {&hDBOTable}.
                         {&hDBOTable} = ?.

    if  valid-handle({&hDBOTable2}) then
        delete procedure {&hDBOTable2}.
                         {&hDBOTable2} = ?.

    if valid-handle(hProg) then
        apply "close" to hProg.

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
    do with frame fPage0:

        assign btAdd:column                             = 1.57
               bt-excel:COLUMN                          = 5.57
               btCancel:VISIBLE                         = NO
               btSave:VISIBLE                           = NO
               btAdd:sensitive                          = yes
               fi-qt-solic                              = 1
               ttitem.desc-item:screen-value            = ""
               ttitem.it-codigo:screen-value            = ""
               v-cod-estabel:SCREEN-VALUE               = "105"
               MENU-ITEM miAdd:SENSITIVE IN MENU mbMain = yes.

        ttitem.it-codigo:LOAD-MOUSE-POINTER("image/lupa.cur":U).
        v-cod-estabel:LOAD-MOUSE-POINTER("image/lupa.cur":U).
    end.

    enable brComponentes with frame fPage0.
    assign ttcomponente.quant-solic:read-only in browse brComponentes = yes
           ttcomponente.preco-unit:read-only  in browse brComponentes = yes.
    
    RETURN "OK":U.
         
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDBOParentHandle wMaintenance 
PROCEDURE getDBOParentHandle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def output param pbohandle as handle no-undo.

    pbohandle = {&hDBOTable2}.
    
    return "OK".
    
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
       {&hDBOTable}:FILE-NAME <> "inbo/boin172.p":U THEN DO:
        {btb/btb008za.i1 inbo/boin172.p YES}
        {btb/btb008za.i2 inbo/boin172.p '' {&hDBOTable}}
    END.
    
    run openQueryStatic in {&hDBOTable} (input "Main":u).
    
    IF NOT VALID-HANDLE({&hDBOTable2}) OR
       {&hDBOTable2}:TYPE <> "PROCEDURE":U OR
       {&hDBOTable2}:FILE-NAME <> "inbo/boin295.p":U THEN DO:
        {btb/btb008za.i1 inbo/boin295.p YES}
        {btb/btb008za.i2 inbo/boin295.p '' {&hDBOTable2}}
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-estrutura wMaintenance 
PROCEDURE pi-carrega-estrutura :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-item-pai  LIKE estrutura.it-codigo NO-UNDO.
    DEF INPUT PARAM p-qtde AS INTE NO-UNDO.

    for each estrutura no-lock
       where estrutura.it-codigo    = p-item-pai
         and estrutura.data-inicio <= today
         and estrutura.data-termino > today:

        run pi-acompanhar  in h-acomp (input "Item " + estrutura.es-codigo).

        FIND ITEM NO-LOCK
            WHERE item.it-codigo = estrutura.es-codigo NO-ERROR.

        IF NOT AVAIL ITEM 
        THEN 
            NEXT.

        FIND FIRST tt-estrutura
             WHERE tt-estrutura.it-codigo = estrutura.it-codigo
               AND tt-estrutura.es-codigo = estrutura.es-codigo NO-ERROR.

        IF NOT AVAIL tt-estrutura 
        THEN DO:
            CREATE tt-estrutura.
            ASSIGN tt-estrutura.it-codigo   = estrutura.it-codigo
                   tt-estrutura.es-codigo   = estrutura.es-codigo
                   tt-estrutura.qtd-compon  = estrutura.qtd-compon
                   tt-estrutura.quant-usada = 0
                   i-seq                    = i-seq + 10
                   tt-estrutura.sequencia   = i-seq.
        END.
        ASSIGN tt-estrutura.quant-usada = tt-estrutura.quant-usada + (estrutura.quant-usada * p-qtde).
        RUN pi-carrega-estrutura (INPUT estrutura.es-codigo, INPUT p-qtde).
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piRetornaDados wMaintenance 
PROCEDURE piRetornaDados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def output param table for ttcomponente.
    DEF OUTPUT PARAM p-log-amostra  AS LOG  NO-UNDO.
    DEF OUTPUT PARAM p-cod-produto  AS CHAR NO-UNDO.
    DEF OUTPUT PARAM p-cod-emitente AS INT  NO-UNDO.
    DEF OUTPUT PARAM p-qtd-pedido   AS DEC  NO-UNDO.
    DEF OUTPUT PARAM p-cod-estabel  AS CHAR NO-UNDO.
    DEF OUTPUT PARAM p-log-ckd      AS LOG  NO-UNDO.
    DEF OUTPUT PARAM p-log-hml      AS LOG  NO-UNDO.

    ASSIGN p-log-amostra  = IF tg-amostra:CHECKED IN FRAME fpage0 THEN YES ELSE NO
           p-log-ckd      = IF tg-ckd:CHECKED IN FRAME fpage0 THEN YES ELSE NO
           p-log-hml      = IF tg-hml:CHECKED IN FRAME fpage0 THEN YES ELSE NO
           p-cod-emitente = v-cod-emitente
           p-qtd-pedido   = INPUT FRAME fpage0 fi-qt-solic
           p-cod-estabel  = INPUT FRAME fpage0 v-cod-estabel
           p-cod-produto  = INPUT FRAME fpage0 ttitem.it-codigo.

    return "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piWindowResize wMaintenance 
PROCEDURE piWindowResize :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE de-win-dif-width  AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE de-win-dif-height AS DECIMAL     NO-UNDO.

    ASSIGN de-win-dif-width   = wMaintenance:WIDTH  - de-win-orig-width
           de-win-dif-height  = wMaintenance:HEIGHT - de-win-orig-height
           de-win-orig-width  = wMaintenance:WIDTH
           de-win-orig-height = wMaintenance:HEIGHT.

    IF de-win-dif-width < 0 THEN DO:
        DO WITH FRAME fPage0:
            ASSIGN btQueryJoins:COLUMN                          = btQueryJoins:COLUMN                          +  de-win-dif-width
                   btReportsJoins:COLUMN                        = btReportsJoins:COLUMN                        +  de-win-dif-width
                   btExit:COLUMN                                = btExit:COLUMN                                +  de-win-dif-width
                   btHelp:COLUMN                                = btHelp:COLUMN                                +  de-win-dif-width
                   rtToolBar:WIDTH                              = rtToolBar:WIDTH                              +  de-win-dif-width
                   rtKeys:WIDTH                                 = rtKeys:WIDTH                                 +  de-win-dif-width
                   brcomponentes:WIDTH                          = brcomponentes:WIDTH                          +  de-win-dif-width
                   ttitem.it-codigo:COLUMN                      = ttitem.it-codigo:COLUMN                      + (de-win-dif-width / 2)
                   ttitem.it-codigo:SIDE-LABEL-HANDLE:COLUMN    = ttitem.it-codigo:SIDE-LABEL-HANDLE:COLUMN    + (de-win-dif-width / 2)
                   ttitem.desc-item:COLUMN                      = ttitem.desc-item:COLUMN                      + (de-win-dif-width / 2)
                   fi-qt-solic:COLUMN                           = fi-qt-solic:COLUMN                           + (de-win-dif-width / 2)
                   fi-qt-solic:SIDE-LABEL-HANDLE:COLUMN         = fi-qt-solic:SIDE-LABEL-HANDLE:COLUMN         + (de-win-dif-width / 2)
                   v-cod-estabel:COLUMN                         = v-cod-estabel:COLUMN                         + (de-win-dif-width / 2)
                   tg-amostra:COLUMN                            = tg-amostra:COLUMN                            + (de-win-dif-width / 2)
                   tg-ckd:COLUMN                                = tg-ckd:COLUMN                                + (de-win-dif-width / 2)
                   tg-hml:COLUMN                                = tg-hml:COLUMN                                + (de-win-dif-width / 2)
                   v-cod-estabel:SIDE-LABEL-HANDLE:COLUMN       = v-cod-estabel:SIDE-LABEL-HANDLE:COLUMN       + (de-win-dif-width / 2)
                   btgoto:COLUMN                                = btgoto:COLUMN                                + (de-win-dif-width / 2).
        END.

        ASSIGN FRAME fPage0:WIDTH         = wMaintenance:WIDTH
               FRAME fPage0:WIDTH-CHARS   = wMaintenance:WIDTH-CHARS
               FRAME fPage0:VIRTUAL-WIDTH = FRAME fPage0:WIDTH.
    END.
    ELSE DO:
        ASSIGN FRAME fPage0:WIDTH         = wMaintenance:WIDTH
               FRAME fPage0:WIDTH-CHARS   = wMaintenance:WIDTH-CHARS
               FRAME fPage0:VIRTUAL-WIDTH = FRAME fPage0:WIDTH.

        DO WITH FRAME fPage0:
            ASSIGN btQueryJoins:COLUMN                          = btQueryJoins:COLUMN                          +  de-win-dif-width
                   btReportsJoins:COLUMN                        = btReportsJoins:COLUMN                        +  de-win-dif-width
                   btExit:COLUMN                                = btExit:COLUMN                                +  de-win-dif-width
                   btHelp:COLUMN                                = btHelp:COLUMN                                +  de-win-dif-width
                   rtToolBar:WIDTH                              = rtToolBar:WIDTH                              +  de-win-dif-width
                   rtKeys:WIDTH                                 = rtKeys:WIDTH                                 +  de-win-dif-width
                   brcomponentes:WIDTH                          = brcomponentes:WIDTH                          +  de-win-dif-width
                   ttitem.it-codigo:COLUMN                      = ttitem.it-codigo:COLUMN                      + (de-win-dif-width / 2)
                   ttitem.it-codigo:SIDE-LABEL-HANDLE:COLUMN    = ttitem.it-codigo:SIDE-LABEL-HANDLE:COLUMN    + (de-win-dif-width / 2)
                   ttitem.desc-item:COLUMN                      = ttitem.desc-item:COLUMN                      + (de-win-dif-width / 2)
                   fi-qt-solic:COLUMN                           = fi-qt-solic:COLUMN                           + (de-win-dif-width / 2)
                   fi-qt-solic:SIDE-LABEL-HANDLE:COLUMN         = fi-qt-solic:SIDE-LABEL-HANDLE:COLUMN         + (de-win-dif-width / 2)
                   v-cod-estabel:COLUMN                         = v-cod-estabel:COLUMN                         + (de-win-dif-width / 2)
                   tg-amostra:COLUMN                            = tg-amostra:COLUMN                            + (de-win-dif-width / 2)
                   tg-ckd:COLUMN                                = tg-ckd:COLUMN                                + (de-win-dif-width / 2)
                   tg-hml:COLUMN                                = tg-hml:COLUMN                                + (de-win-dif-width / 2)
                   v-cod-estabel:SIDE-LABEL-HANDLE:COLUMN       = v-cod-estabel:SIDE-LABEL-HANDLE:COLUMN       + (de-win-dif-width / 2)
                   btgoto:COLUMN                                = btgoto:COLUMN                                + (de-win-dif-width / 2).
        END.
    END.

    IF de-win-dif-height < 0 THEN DO:
        DO WITH FRAME fPage0:
            ASSIGN brcomponentes:HEIGHT    = brcomponentes:HEIGHT   + de-win-dif-height
                   btVaParaItem:ROW        = btVaParaItem:ROW       + de-win-dif-height
                   bt-gerar:ROW            = bt-gerar:ROW           + de-win-dif-height
                   bt-alterar:ROW          = bt-alterar:ROW         + de-win-dif-height
                   bt-gerar-pedidos:ROW    = bt-gerar-pedidos:ROW   + de-win-dif-height
                   tx-item-incompleto:ROW  = tx-item-incompleto:ROW + de-win-dif-height
                   tx-item-inativo:ROW     = tx-item-inativo:ROW    + de-win-dif-height.
        END.

        ASSIGN FRAME fPage0:HEIGHT         = wMaintenance:HEIGHT
               FRAME fPage0:HEIGHT-CHARS   = wMaintenance:HEIGHT-CHARS
               FRAME fPage0:VIRTUAL-HEIGHT = FRAME fPage0:HEIGHT.
    END.
    ELSE DO:
        ASSIGN FRAME fPage0:HEIGHT         = wMaintenance:HEIGHT
               FRAME fPage0:HEIGHT-CHARS   = wMaintenance:HEIGHT-CHARS
               FRAME fPage0:VIRTUAL-HEIGHT = FRAME fPage0:HEIGHT.

        DO WITH FRAME fPage0:
            ASSIGN brcomponentes:HEIGHT    = brcomponentes:HEIGHT   + de-win-dif-height
                   btVaParaItem:ROW        = btVaParaItem:ROW       + de-win-dif-height
                   bt-gerar:ROW            = bt-gerar:ROW           + de-win-dif-height
                   bt-alterar:ROW          = bt-alterar:ROW         + de-win-dif-height
                   bt-gerar-pedidos:ROW    = bt-gerar-pedidos:ROW   + de-win-dif-height
                   tx-item-incompleto:ROW  = tx-item-incompleto:ROW + de-win-dif-height
                   tx-item-inativo:ROW     = tx-item-inativo:ROW    + de-win-dif-height.
        END.
    END.

    ASSIGN tx-item-inativo:BGCOLOR IN FRAME fpage0 = 14.

    RETURN "OK":U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE vaParaItem wMaintenance 
PROCEDURE vaParaItem :
/*:T------------------------------------------------------------------------------
  Purpose:     Exibe dialog de V  Para
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    def buffer bttcomponente for ttcomponente.
    
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
    
    DEFINE VARIABLE c-it-codigo LIKE {&ttTable}.it-codigo NO-UNDO.
    
    DEFINE FRAME fGoToRecord
        c-it-codigo AT ROW 1.21 COL 17.72 COLON-ALIGNED
        btGoToOK          AT ROW 2.63 COL 2.14
        btGoToCancel      AT ROW 2.63 COL 13
        rtGoToButton      AT ROW 2.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V  Para Item" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.
    
    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN c-it-codigo  .
        
        find first bttcomponente 
            where bttcomponente.es-codigo = c-it-codigo no-error.
            
        if avail bttcomponente then do:
            reposition brComponentes to rowid rowid(bttcomponente).
            
        end.
                
        
        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    ENABLE c-it-codigo   btGoToOK btGoToCancel 
        WITH FRAME fGoToRecord. 
    
    WAIT-FOR "GO":U OF FRAME fGoToRecord.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

