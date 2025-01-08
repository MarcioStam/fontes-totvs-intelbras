&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcad            PROGRESS
          mgmov            PROGRESS
*/
&Scoped-define WINDOW-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESIMP019 2.04.00.002}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        esimp019
&GLOBAL-DEFINE Version        2.04.00.002

&GLOBAL-DEFINE WindowType     Master/Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   <Folder1 ,Folder 2 ,... , Folder8>

&GLOBAL-DEFINE page0Widgets   btQueryJoins btReportsJoins btExit btHelp ~
                                 bt-vapara-ori i-pedido-ori i-pedido-dest bt-vapara-dest  ~
                                  br-ori br-dest   
                                
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEF BUFFER b-unid-neg-ordem   FOR unid-neg-ordem.
DEF BUFFER b-ordem-compra     FOR ordem-compra .
DEF BUFFER b-prazo-compra     FOR prazo-compra .
DEF BUFFER b-pedido-compr     FOR pedido-compr.
DEF BUFFER b2-pedido-compr    FOR pedido-compr.
DEF BUFFER b-cotacao-item     FOR cotacao-item.
DEF BUFFER bde-ordem-compra   FOR ordem-compra.
DEF BUFFER bde-prazo-compra   FOR prazo-compra.
DEF BUFFER bde-cotacao-item   FOR cotacao-item.
DEF BUFFER b-processo-imp     FOR processo-imp.
DEF BUFFER b-embarque-imp     FOR embarque-imp.
DEF BUFFER b-ordens-embarque  FOR ordens-embarque.
DEF BUFFER bb-ordens-embarque FOR ordens-embarque.

DEFINE VARIABLE c-embarque      LIKE embarque-imp.embarque.
DEFINE VARIABLE da-data-entrega LIKE prazo-compra.data-entrega.
DEFINE VARIABLE c-base          AS CHAR FORMAT "x(20)".
DEFINE VARIABLE c-incoterm      AS CHAR FORMAT "x(20)".
DEFINE VARIABLE i-nr-ordem      LIKE ordem-compra.numero-ordem.
DEFINE VARIABLE i-num-pedido    LIKE pedido-compr.num-pedido.
DEFINE VARIABLE h-boin274       AS HANDLE    NO-UNDO.
DEFINE VARIABLE h-boin356na     AS HANDLE    NO-UNDO.
DEFINE VARIABLE h-boin295desc   AS HANDLE    NO-UNDO.
DEFINE VARIABLE h-boin295       AS HANDLE    NO-UNDO.
DEFINE VARIABLE h-boin356vl     AS HANDLE    NO-UNDO.
DEFINE VARIABLE h-bocx404       AS HANDLE    NO-UNDO.
DEFINE VARIABLE h-bocx225       AS HANDLE    NO-UNDO.
DEFINE VARIABLE h-bocx140       AS HANDLE    NO-UNDO.
DEFINE VARIABLE h-bocx220       AS HANDLE    NO-UNDO.
DEFINE VARIABLE h-boin274vl     AS HANDLE    NO-UNDO.
DEFINE VARIABLE h-boin082       AS HANDLE    NO-UNDO.
DEFINE VARIABLE c-desc-transp   AS CHAR      NO-UNDO.
DEFINE VARIABLE v-des-sit-emb   AS CHAR      NO-UNDO.
DEFINE VARIABLE i-via-transp    AS INT       NO-UNDO.
DEFINE VARIABLE r-rowid         AS ROWID     NO-UNDO.
DEFINE VARIABLE l-integra-di    AS LOGICAL   NO-UNDO.
DEFINE VARIABLE l-erro          AS LOGICAL   NO-UNDO.
DEFINE VARIABLE r-ordem         AS ROWID       NO-UNDO.
DEFINE VARIABLE r-prazo         AS ROWID       NO-UNDO.
DEFINE VARIABLE h-acomp         AS HANDLE      NO-UNDO.

def var i-lote-mult         like item.lote-multipl no-undo.
def var i-lote-min          like item.lote-minimo no-undo.
DEFINE VARIABLE l-item-fornec       AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-item-fornec-estab AS LOGICAL     NO-UNDO.

DEFINE VARIABLE de-nr-lotes  AS DECIMAL     NO-UNDO.

    DEFINE VARIABLE iqtd LIKE prazo-compra.quant-saldo INITIAL 0 
        LABEL "Quantidade a Transferir" 
        VIEW-AS FILL-IN 
        SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE l-conf AS LOGICAL     NO-UNDO.

define variable de-saldo-aux like prazo-compra.quant-saldo  no-undo.
define variable de-preco-aux like ordem-compra.preco-fornec no-undo.

{esp/imp/esimp000.i1}

DEFINE TEMP-TABLE tt-pedido-compr NO-UNDO LIKE pedido-compr
    FIELD r-rowid AS ROWID
    FIELD RowNum AS INTEGER INIT 1
    INDEX iSeq AS PRIMARY RowNum.

DEF TEMP-TABLE tt-processo-imp NO-UNDO LIKE mgcex.processo-imp
    FIELD r-rowid AS ROWID.

DEFINE TEMP-TABLE tt-embarque-imp no-undo like embarque-imp
    field r-rowid  as rowid.

DEFINE TEMP-TABLE tt-ordem-compra NO-UNDO LIKE ordem-compra
    FIELD r-Rowid AS ROWID. 

DEFINE TEMP-TABLE tt-prazo-compra NO-UNDO LIKE prazo-compra
    FIELD r-rowid AS ROWID.

DEFINE TEMP-TABLE tt-cotacao-item NO-UNDO LIKE cotacao-item
    FIELD r-rowid AS ROWID.

DEFINE TEMP-TABLE tt-prazo-compra-old NO-UNDO LIKE tt-prazo-compra.

DEFINE TEMP-TABLE tt-ordens-embarque-old NO-UNDO LIKE ordens-embarque
    FIELD r-rowid AS ROWID.

{utp/ut-glob.i}
{include/boini.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-dest

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES b-ordem-compra b-prazo-compra ~
bb-ordens-embarque ordem-compra prazo-compra ordens-embarque

/* Definitions for BROWSE br-dest                                       */
&Scoped-define FIELDS-IN-QUERY-br-dest b-ordem-compra.numero-ordem b-ordem-compra.it-codigo b-prazo-compra.parcela b-prazo-compra.quant-saldo bb-ordens-embarque.embarque   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-dest   
&Scoped-define SELF-NAME br-dest
&Scoped-define OPEN-QUERY-br-dest IF  INT(i-pedido-dest:SCREEN-VALUE IN FRAME {&FRAME-NAME}) <> 0 THEN     OPEN QUERY {&SELF-NAME}         FOR EACH b-ordem-compra NO-LOCK            WHERE b-ordem-compra.num-pedido = INT(i-pedido-dest:SCREEN-VALUE IN FRAME {&FRAME-NAME})              AND b-ordem-compra.situacao = 2, ~
                   EACH b-prazo-compra NO-LOCK            WHERE b-prazo-compra.numero-ordem = b-ordem-compra.numero-ordem             AND b-prazo-compra.situacao = 2, ~
                   EACH bb-ordens-embarque NO-LOCK          WHERE bb-ordens-embarque.numero-ordem = b-ordem-compra.numero-ordem            AND bb-ordens-embarque.parcela = b-prazo-compra.parcela OUTER-JOIN. ELSE     OPEN QUERY {&SELF-NAME}         FOR EACH b-ordem-compra NO-LOCK            WHERE b-ordem-compra.num-pedido = -1, ~
                   EACH b-prazo-compra NO-LOCK            WHERE b-prazo-compra.numero-ordem = b-ordem-compra.numero-ordem, ~
                   EACH bb-ordens-embarque NO-LOCK          WHERE bb-ordens-embarque.numero-ordem = b-ordem-compra.numero-ordem            AND bb-ordens-embarque.parcela = b-prazo-compra.parcela OUTER-JOIN.
&Scoped-define TABLES-IN-QUERY-br-dest b-ordem-compra b-prazo-compra ~
bb-ordens-embarque
&Scoped-define FIRST-TABLE-IN-QUERY-br-dest b-ordem-compra
&Scoped-define SECOND-TABLE-IN-QUERY-br-dest b-prazo-compra
&Scoped-define THIRD-TABLE-IN-QUERY-br-dest bb-ordens-embarque


/* Definitions for BROWSE br-ori                                        */
&Scoped-define FIELDS-IN-QUERY-br-ori ordem-compra.numero-ordem ordem-compra.it-codigo prazo-compra.parcela prazo-compra.quant-saldo ordens-embarque.embarque fn-des-sit-embarque() @ v-des-sit-emb   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-ori   
&Scoped-define SELF-NAME br-ori
&Scoped-define OPEN-QUERY-br-ori IF  INT(i-pedido-ori:SCREEN-VALUE IN FRAME {&FRAME-NAME}) <> 0 THEN DO:     OPEN QUERY {&SELF-NAME}             FOR EACH ordem-compra NO-LOCK                WHERE ordem-compra.num-pedido = INT(i-pedido-ori:SCREEN-VALUE IN FRAME {&FRAME-NAME})                  AND ordem-compra.situacao = 2, ~
                       EACH prazo-compra NO-LOCK                WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem                  AND prazo-compra.situacao     = 2, ~
                       EACH ordens-embarque NO-LOCK                WHERE ordens-embarque.numero-ordem = ordem-compra.numero-ordem                  AND ordens-embarque.parcela = prazo-compra.parcela OUTER-JOIN. END. ELSE DO:     OPEN QUERY {&SELF-NAME}             FOR EACH ordem-compra NO-LOCK                WHERE ordem-compra.num-pedido = -1, ~
                       EACH prazo-compra NO-LOCK                WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem, ~
                       EACH ordens-embarque NO-LOCK                WHERE ordens-embarque.numero-ordem = ordem-compra.numero-ordem                  AND ordens-embarque.parcela = prazo-compra.parcela OUTER-JOIN. END.
&Scoped-define TABLES-IN-QUERY-br-ori ordem-compra prazo-compra ~
ordens-embarque
&Scoped-define FIRST-TABLE-IN-QUERY-br-ori ordem-compra
&Scoped-define SECOND-TABLE-IN-QUERY-br-ori prazo-compra
&Scoped-define THIRD-TABLE-IN-QUERY-br-ori ordens-embarque


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-br-dest}~
    ~{&OPEN-QUERY-br-ori}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-3 rtToolBar-2 btQueryJoins ~
btReportsJoins btExit btHelp bt-vapara-ori bt-vapara-dest bt-copia ~
i-pedido-ori i-pedido-dest c-fornecedor i-cod-cond-pagto v-des-pagto-1 ~
c-fornecedor-2 i-cod-cond-pagto-2 v-des-pagto-2 c-comprador c-itinerario ~
v-des-itiner-1 c-comprador-2 c-itinerario-2 v-des-itiner-2 c-emb-ori ~
c-ponto-base v-des-pto-1 c-emb c-base-2 v-des-pto-2 c-incoterm-1 ~
v-des-incoterm-1 data-entrega c-incoterm-2 v-des-incoterm-2 br-ori br-dest ~
bt-parcela bt-parcial 
&Scoped-Define DISPLAYED-OBJECTS i-pedido-ori i-pedido-dest c-fornecedor ~
i-cod-cond-pagto v-des-pagto-1 c-fornecedor-2 i-cod-cond-pagto-2 ~
v-des-pagto-2 c-comprador c-itinerario v-des-itiner-1 c-comprador-2 ~
c-itinerario-2 v-des-itiner-2 c-emb-ori c-ponto-base v-des-pto-1 c-emb ~
c-base-2 v-des-pto-2 c-incoterm-1 v-des-incoterm-1 data-entrega ~
c-incoterm-2 v-des-incoterm-2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-des-sit-embarque wWindow 
FUNCTION fn-des-sit-embarque RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miQueryJoins   LABEL "&Consultas"    
       MENU-ITEM miReportsJoins LABEL "&Relat¢rios"  
       RULE
       MENU-ITEM miExit         LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU smHelp 
       MENU-ITEM miContents     LABEL "&Conte£do"    
       MENU-ITEM miAbout        LABEL "&Sobre..."     .

DEFINE MENU mbMain MENUBAR
       SUB-MENU  smFile         LABEL "&Arquivo"      
       SUB-MENU  smHelp         LABEL "&Ajuda"        .


/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-copia 
     IMAGE-UP FILE "image/gr-cop.bmp":U
     LABEL "Button 6" 
     SIZE 4 BY 1 TOOLTIP "BotÆo Faz Tudo (pedido, processo, embarque, historico)".

DEFINE BUTTON bt-parcela 
     LABEL "Toda Parcela" 
     SIZE 11 BY 1.13 TOOLTIP "Transferˆncia Parcial da Ordem".

DEFINE BUTTON bt-parcial 
     LABEL "Parcela Parcial" 
     SIZE 11 BY 1.13.

DEFINE BUTTON bt-vapara-dest 
     IMAGE-UP FILE "image/im-enter.bmp":U
     LABEL "Button 5" 
     SIZE 4 BY 1.

DEFINE BUTTON bt-vapara-ori 
     IMAGE-UP FILE "image/im-enter.bmp":U
     LABEL "Button 4" 
     SIZE 4 BY 1.

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

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

DEFINE VARIABLE c-base-2 AS CHARACTER FORMAT "X(20)":U 
     LABEL "Ponto Base" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .79 NO-UNDO.

DEFINE VARIABLE c-comprador AS CHARACTER FORMAT "X(256)":U 
     LABEL "Comprador" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .79 NO-UNDO.

DEFINE VARIABLE c-comprador-2 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Comprador" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .79 NO-UNDO.

DEFINE VARIABLE c-emb AS CHARACTER FORMAT "X(256)":U 
     LABEL "Embarque" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .79 NO-UNDO.

DEFINE VARIABLE c-emb-ori AS CHARACTER FORMAT "X(256)":U 
     LABEL "Embarque" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .79 NO-UNDO.

DEFINE VARIABLE c-fornecedor AS CHARACTER FORMAT "X(256)":U 
     LABEL "Fornecedor" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .79 NO-UNDO.

DEFINE VARIABLE c-fornecedor-2 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Fornecedor" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .79 NO-UNDO.

DEFINE VARIABLE c-incoterm-1 AS CHARACTER FORMAT "X(3)":U 
     LABEL "Incoterm" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .79 NO-UNDO.

DEFINE VARIABLE c-incoterm-2 AS CHARACTER FORMAT "X(20)":U 
     LABEL "Incoterm" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .79 NO-UNDO.

DEFINE VARIABLE c-itinerario AS INTEGER FORMAT ">,>>9":U INITIAL 0 
     LABEL "Itiner rio" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .79 NO-UNDO.

DEFINE VARIABLE c-itinerario-2 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Itiner rio" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .79 NO-UNDO.

DEFINE VARIABLE c-ponto-base AS CHARACTER FORMAT "X(4)":U 
     LABEL "Ponto Base" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .79 NO-UNDO.

DEFINE VARIABLE data-entrega AS CHARACTER FORMAT "X(256)":U 
     LABEL "Entrega" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .79 NO-UNDO.

DEFINE VARIABLE i-cod-cond-pagto AS INTEGER FORMAT ">>>9":U INITIAL 0 
     LABEL "Cond Pagto" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .79 NO-UNDO.

DEFINE VARIABLE i-cod-cond-pagto-2 AS INTEGER FORMAT ">>>9":U INITIAL 0 
     LABEL "Cond Pagto" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .79 NO-UNDO.

DEFINE VARIABLE i-pedido-dest AS CHARACTER FORMAT "X(256)":U 
     LABEL "Novo Pedido" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .79 NO-UNDO.

DEFINE VARIABLE i-pedido-ori AS CHARACTER FORMAT "X(256)":U 
     LABEL "Pedido Origem" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .79 NO-UNDO.

DEFINE VARIABLE v-des-incoterm-1 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 15 BY .79 NO-UNDO.

DEFINE VARIABLE v-des-incoterm-2 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 15 BY .79 NO-UNDO.

DEFINE VARIABLE v-des-itiner-1 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 15 BY .79 NO-UNDO.

DEFINE VARIABLE v-des-itiner-2 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 15 BY .79 NO-UNDO.

DEFINE VARIABLE v-des-pagto-1 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 15 BY .79 NO-UNDO.

DEFINE VARIABLE v-des-pagto-2 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 15 BY .79 NO-UNDO.

DEFINE VARIABLE v-des-pto-1 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 15 BY .79 NO-UNDO.

DEFINE VARIABLE v-des-pto-2 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 15 BY .79 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 57 BY 19.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 55.14 BY 19.

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 113 BY 1.5
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-dest FOR 
      b-ordem-compra, 
      b-prazo-compra, 
      bb-ordens-embarque SCROLLING.

DEFINE QUERY br-ori FOR 
      ordem-compra, 
      prazo-compra, 
      ordens-embarque SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-dest
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-dest wWindow _FREEFORM
  QUERY br-dest DISPLAY
      b-ordem-compra.numero-ordem
 b-ordem-compra.it-codigo
 b-prazo-compra.parcela
 b-prazo-compra.quant-saldo
bb-ordens-embarque.embarque
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 53 BY 14
         FONT 1 FIT-LAST-COLUMN.

DEFINE BROWSE br-ori
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-ori wWindow _FREEFORM
  QUERY br-ori DISPLAY
      ordem-compra.numero-ordem
 ordem-compra.it-codigo FORMAT "x(09)"
 prazo-compra.parcela
 prazo-compra.quant-saldo
ordens-embarque.embarque FORMAT "x(09)"
fn-des-sit-embarque() @ v-des-sit-emb LABEL "Situa‡Æo" FORMAT "x(05)"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 55 BY 13
         FONT 1 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btQueryJoins AT ROW 1.13 COL 97.43 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 101.43 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 105.43 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 109.43 HELP
          "Ajuda"
     bt-vapara-ori AT ROW 2.75 COL 25
     bt-vapara-dest AT ROW 2.75 COL 84
     bt-copia AT ROW 2.75 COL 88
     i-pedido-ori AT ROW 2.83 COL 2.28
     i-pedido-dest AT ROW 2.83 COL 70 COLON-ALIGNED
     c-fornecedor AT ROW 3.71 COL 11 COLON-ALIGNED
     i-cod-cond-pagto AT ROW 3.71 COL 35.72 COLON-ALIGNED WIDGET-ID 2
     v-des-pagto-1 AT ROW 3.71 COL 40 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     c-fornecedor-2 AT ROW 3.71 COL 70 COLON-ALIGNED
     i-cod-cond-pagto-2 AT ROW 3.71 COL 92.14 COLON-ALIGNED WIDGET-ID 6
     v-des-pagto-2 AT ROW 3.71 COL 96.43 COLON-ALIGNED NO-LABEL WIDGET-ID 22
     c-comprador AT ROW 4.58 COL 11 COLON-ALIGNED
     c-itinerario AT ROW 4.58 COL 35.72 COLON-ALIGNED
     v-des-itiner-1 AT ROW 4.58 COL 40 COLON-ALIGNED NO-LABEL WIDGET-ID 12
     c-comprador-2 AT ROW 4.58 COL 70 COLON-ALIGNED
     c-itinerario-2 AT ROW 4.58 COL 92.14 COLON-ALIGNED
     v-des-itiner-2 AT ROW 4.58 COL 96.43 COLON-ALIGNED NO-LABEL WIDGET-ID 20
     c-emb-ori AT ROW 5.42 COL 11 COLON-ALIGNED WIDGET-ID 8
     c-ponto-base AT ROW 5.42 COL 35.72 COLON-ALIGNED
     v-des-pto-1 AT ROW 5.42 COL 40 COLON-ALIGNED NO-LABEL WIDGET-ID 14
     c-emb AT ROW 5.42 COL 70 COLON-ALIGNED
     c-base-2 AT ROW 5.42 COL 92.14 COLON-ALIGNED
     v-des-pto-2 AT ROW 5.42 COL 96.43 COLON-ALIGNED NO-LABEL WIDGET-ID 24
     c-incoterm-1 AT ROW 6.29 COL 35.72 COLON-ALIGNED WIDGET-ID 4
     v-des-incoterm-1 AT ROW 6.29 COL 40 COLON-ALIGNED NO-LABEL WIDGET-ID 16
     data-entrega AT ROW 6.29 COL 70 COLON-ALIGNED
     c-incoterm-2 AT ROW 6.29 COL 92.14 COLON-ALIGNED
     v-des-incoterm-2 AT ROW 6.29 COL 96.43 COLON-ALIGNED NO-LABEL WIDGET-ID 18
     br-ori AT ROW 7.25 COL 2
     br-dest AT ROW 7.25 COL 60
     bt-parcela AT ROW 20.25 COL 2
     bt-parcial AT ROW 20.25 COL 13
     RECT-1 AT ROW 2.5 COL 1.29
     RECT-3 AT ROW 2.5 COL 58.86
     rtToolBar-2 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 113.14 BY 20.75
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 20.75
         WIDTH              = 113.14
         MAX-HEIGHT         = 20.75
         MAX-WIDTH          = 114.29
         VIRTUAL-HEIGHT     = 20.75
         VIRTUAL-WIDTH      = 114.29
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wWindow 
/* ************************* Included-Libraries *********************** */

{window/window.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWindow
  NOT-VISIBLE,                                                          */
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* BROWSE-TAB br-ori v-des-incoterm-2 fpage0 */
/* BROWSE-TAB br-dest br-ori fpage0 */
/* SETTINGS FOR FILL-IN i-pedido-ori IN FRAME fpage0
   ALIGN-L                                                              */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-dest
/* Query rebuild information for BROWSE br-dest
     _START_FREEFORM
IF  INT(i-pedido-dest:SCREEN-VALUE IN FRAME {&FRAME-NAME}) <> 0
THEN
    OPEN QUERY {&SELF-NAME}
        FOR EACH b-ordem-compra NO-LOCK
           WHERE b-ordem-compra.num-pedido = INT(i-pedido-dest:SCREEN-VALUE IN FRAME {&FRAME-NAME})
             AND b-ordem-compra.situacao = 2,
            EACH b-prazo-compra NO-LOCK
           WHERE b-prazo-compra.numero-ordem = b-ordem-compra.numero-ordem
            AND b-prazo-compra.situacao = 2,
            EACH bb-ordens-embarque NO-LOCK
         WHERE bb-ordens-embarque.numero-ordem = b-ordem-compra.numero-ordem
           AND bb-ordens-embarque.parcela = b-prazo-compra.parcela OUTER-JOIN.
ELSE
    OPEN QUERY {&SELF-NAME}
        FOR EACH b-ordem-compra NO-LOCK
           WHERE b-ordem-compra.num-pedido = -1,
            EACH b-prazo-compra NO-LOCK
           WHERE b-prazo-compra.numero-ordem = b-ordem-compra.numero-ordem,
            EACH bb-ordens-embarque NO-LOCK
         WHERE bb-ordens-embarque.numero-ordem = b-ordem-compra.numero-ordem
           AND bb-ordens-embarque.parcela = b-prazo-compra.parcela OUTER-JOIN.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-dest */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-ori
/* Query rebuild information for BROWSE br-ori
     _START_FREEFORM
IF  INT(i-pedido-ori:SCREEN-VALUE IN FRAME {&FRAME-NAME}) <> 0
THEN DO:
    OPEN QUERY {&SELF-NAME}
            FOR EACH ordem-compra NO-LOCK
               WHERE ordem-compra.num-pedido = INT(i-pedido-ori:SCREEN-VALUE IN FRAME {&FRAME-NAME})
                 AND ordem-compra.situacao = 2,
                EACH prazo-compra NO-LOCK
               WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem
                 AND prazo-compra.situacao     = 2,
                EACH ordens-embarque NO-LOCK
               WHERE ordens-embarque.numero-ordem = ordem-compra.numero-ordem
                 AND ordens-embarque.parcela = prazo-compra.parcela OUTER-JOIN.
END.
ELSE DO:
    OPEN QUERY {&SELF-NAME}
            FOR EACH ordem-compra NO-LOCK
               WHERE ordem-compra.num-pedido = -1,
                EACH prazo-compra NO-LOCK
               WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem,
                EACH ordens-embarque NO-LOCK
               WHERE ordens-embarque.numero-ordem = ordem-compra.numero-ordem
                 AND ordens-embarque.parcela = prazo-compra.parcela OUTER-JOIN.
END.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-ori */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON END-ERROR OF wWindow
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-CLOSE OF wWindow
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-copia
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-copia wWindow
ON CHOOSE OF bt-copia IN FRAME fpage0 /* Button 6 */
DO:    
    DEF VAR da-data AS DATE  NO-UNDO.
    DEF VAR i-dias  AS INT   NO-UNDO.
    DEF VAR r-chave AS ROWID NO-UNDO.

    IF i-pedido-ori:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""  THEN DO:
        MESSAGE "O pedido de origem deve ser informado" VIEW-AS ALERT-BOX INFO BUTTONS OK.
        RETURN NO-APPLY.
    END.

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
        SIZE 78 BY 1.42
        BGCOLOR 7.

    DEFINE VARIABLE icoditiner LIKE processo-imp.cod-itiner INITIAL 0 
        LABEL "Novo Itiner rio" 
        VIEW-AS FILL-IN 
        SIZE 10 BY .88 NO-UNDO.

    DEFINE VARIABLE dadataentrega LIKE prazo-compra.data-entrega INITIAL TODAY 
        LABEL "Data Entrega" 
        VIEW-AS FILL-IN 
        SIZE 10 BY .88 NO-UNDO.

    DEFINE VARIABLE cbase AS CHAR FORMAT "x(5)" 
        LABEL "Ponto Base" 
        VIEW-AS FILL-IN 
        SIZE 10 BY .88 NO-UNDO.

    DEFINE VARIABLE cincoterm AS CHAR FORMAT "x(3)" 
        LABEL "Incoterm" 
        VIEW-AS FILL-IN 
        SIZE 10 BY .88 NO-UNDO.

    DEFINE VARIABLE cb-via-transp AS CHARACTER FORMAT "X(20)" INITIAL "1" 
        LABEL "Via Transporte" 
        VIEW-AS COMBO-BOX INNER-LINES 5
        DROP-DOWN-LIST
        SIZE 15.72 BY 1 NO-UNDO.

    DEFINE VARIABLE ctransp AS INTEGER FORMAT ">>,>>9" 
        LABEL "Transportador" 
        VIEW-AS FILL-IN 
        SIZE 10 BY .88 NO-UNDO.

    DEFINE VARIABLE cdesctransp AS CHAR FORMAT "x(256)" 
        VIEW-AS FILL-IN 
        SIZE 40 BY .88 NO-UNDO.

    DEFINE VARIABLE cdesitinerario AS CHAR FORMAT "x(256)" 
        VIEW-AS FILL-IN 
        SIZE 40 BY .88 NO-UNDO.

    DEFINE VARIABLE cdesponto AS CHAR FORMAT "x(256)" 
        VIEW-AS FILL-IN 
        SIZE 40 BY .88 NO-UNDO.

    DEFINE VARIABLE cdesincoterm AS CHAR FORMAT "x(256)" 
        VIEW-AS FILL-IN 
        SIZE 40 BY .88 NO-UNDO.

    DEFINE VARIABLE cnarrativa AS CHARACTER 
        LABEL "Narrativa Pedido"
        VIEW-AS EDITOR SCROLLBAR-VERTICAL
        SIZE 58 BY 4
        FONT 2.

    DEFINE VARIABLE cnarrativaemb AS CHARACTER 
        LABEL "Narrativa Embarque"
        VIEW-AS EDITOR SCROLLBAR-VERTICAL
        SIZE 58 BY 4
        FONT 2.

    DEFINE FRAME fitinerario
        icoditiner        AT ROW 1.21  COL 15.72 COLON-ALIGNED
        cdesitinerario    AT ROW 1.21  COL 25.82 COLON-ALIGNED NO-LABEL
        cbase             AT ROW 2.21  COL 15.72 COLON-ALIGNED
        cdesponto         AT ROW 2.21  COL 25.82 COLON-ALIGNED NO-LABEL
        cincoterm         AT ROW 3.21  COL 15.72 COLON-ALIGNED
        cdesincoterm      AT ROW 3.21  COL 25.82 COLON-ALIGNED NO-LABEL
        ctransp           AT ROW 4.21  COL 15.72 COLON-ALIGNED
        cdesctransp       AT ROW 4.21  COL 25.82 COLON-ALIGNED NO-LABEL
        dadataentrega     AT ROW 5.21  COL 15.72 COLON-ALIGNED 
        cb-via-transp     AT ROW 6.21  COL 15.72 COLON-ALIGNED
        cnarrativa        AT ROW 7.50  COL 15.72 COLON-ALIGNED 
        cnarrativaemb     AT ROW 12.00 COL 15.72 COLON-ALIGNED 
        btGoToOK          AT ROW 17.63 COL 2.14
        btGoToCancel      AT ROW 17.63 COL 13
        rtGoToButton      AT ROW 17.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
            THREE-D SCROLLABLE TITLE "Itiner rio" FONT 1 
            CANCEL-BUTTON btGoToCancel.                                                                 

    ON "CHOOSE":U OF btGoToOK IN FRAME fitinerario DO:
        ASSIGN icoditiner
               dadataentrega
               cbase
               cincoterm 
               ctransp 
               cdesctransp 
               cnarrativa
               cb-via-transp
               cnarrativaemb.

        IF icoditiner = 0 THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 265, INPUT "Itiner rio").
            APPLY "ENTRY" TO icoditiner IN FRAME fitinerario.
            RETURN NO-APPLY.
        END.
        IF cbase = "" THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 265, INPUT "Ponto Base").
            APPLY "ENTRY" TO cbase IN FRAME fitinerario.
            RETURN NO-APPLY.
        END.
        IF cincoterm = "" THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 265, INPUT "Incoterm").
            APPLY "ENTRY" TO cincoterm IN FRAME fitinerario.
            RETURN NO-APPLY.
        END.
        IF ctransp = 0 THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 265, INPUT "Transportador").
            APPLY "ENTRY" TO ctransp IN FRAME fitinerario.
            RETURN NO-APPLY.
        END.
        IF cb-via-transp = "" THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 265, INPUT "Via Transporte").
            APPLY "ENTRY" TO cb-via-transp IN FRAME fitinerario.
            RETURN NO-APPLY.
        END.
        IF dadataentrega = ? THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 265, INPUT "Data de Entrega").
            APPLY "ENTRY" TO dadataentrega IN FRAME fitinerario.
            RETURN NO-APPLY.
        END.

        FIND itinerario NO-LOCK
            WHERE itinerario.cod-itiner = INPUT FRAME fitinerario icoditiner NO-ERROR.
        IF  NOT AVAIL itinerario
        THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U, 
                               INPUT 2, 
                               INPUT "Itiner rio").
            APPLY "ENTRY" TO icoditiner IN FRAME fitinerario.
            RETURN NO-APPLY.
        END.

        FIND pto-contr NO-LOCK
            WHERE pto-contr.cod-pto-contr = INT(INPUT FRAME fitinerario cbase) NO-ERROR.
        IF  NOT AVAIL pto-contr
        THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U, 
                               INPUT 2, 
                               INPUT "Ponto Controle").
            APPLY "ENTRY" TO cbase IN FRAME fitinerario.
            RETURN NO-APPLY.
        END.

        FIND inco-cx NO-LOCK
            WHERE inco-cx.cod-incoterm = INPUT FRAME fitinerario cincoterm NO-ERROR.
        IF  NOT AVAIL inco-cx
        THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U, 
                               INPUT 2, 
                               INPUT "Incoterm").
            APPLY "ENTRY" TO cincoterm IN FRAME fitinerario.
            RETURN NO-APPLY.
        END.

        FIND transporte NO-LOCK
            WHERE transporte.cod-transp = INPUT FRAME fitinerario ctransp NO-ERROR.
        IF  NOT AVAIL transporte
        THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U, 
                               INPUT 2, 
                               INPUT "Transportadora").
            APPLY "ENTRY" TO ctransp IN FRAME fitinerario.
            RETURN NO-APPLY.
        END.

        FIND pto-itiner NO-LOCK
            WHERE pto-itiner.cod-itiner = INPUT FRAME fitinerario icoditiner
              AND pto-itiner.cod-pto-contr = INT(INPUT FRAME fitinerario cbase) NO-ERROR.
        IF  NOT AVAIL pto-itiner
        THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U, 
                               INPUT 17006, 
                               INPUT "Ponto de controle inv lido.~~O ponto de controle informado nÆo est  relacionado ao itiner rio.").
            APPLY "ENTRY" TO icoditiner IN FRAME fitinerario.
            RETURN NO-APPLY.
        END.

        APPLY "GO":U TO FRAME fitinerario.
    END.

    ON "LEAVE":U OF ctransp IN FRAME fitinerario DO:
        RUN getDescViaTransp IN h-boin295desc (INPUT INPUT FRAME fitinerario ctransp,
                                               OUTPUT c-desc-transp,
                                               OUTPUT i-via-transp).
        ASSIGN cdesctransp:SCREEN-VALUE   IN FRAME fitinerario = c-desc-transp
               cb-via-transp:SCREEN-VALUE IN FRAME fitinerario = {adinc/i01ad268.i 04 i-via-transp} NO-ERROR.        
    END.

    ON "LEAVE":U OF icoditiner IN FRAME fitinerario DO:
        FIND itinerario NO-LOCK
            WHERE itinerario.cod-itiner = INPUT FRAME fitinerario icoditiner NO-ERROR.
        IF  AVAIL itinerario
        THEN
            DISP itinerario.descricao @ cdesitinerario WITH FRAME fitinerario.
        ELSE
            DISP "" @ cdesitinerario WITH FRAME fitinerario.
    END.

    ON "LEAVE":U OF cbase IN FRAME fitinerario DO:
        FIND pto-contr NO-LOCK
            WHERE pto-contr.cod-pto-contr = INT(INPUT FRAME fitinerario cbase) NO-ERROR.
        IF  AVAIL pto-contr
        THEN
            DISP pto-contr.descricao @ cdesponto WITH FRAME fitinerario.
        ELSE
            DISP "" @ cdesponto WITH FRAME fitinerario.
    END.

    ON "LEAVE":U OF cincoterm IN FRAME fitinerario DO:
        FIND inco-cx NO-LOCK
            WHERE inco-cx.cod-incoterm = INPUT FRAME fitinerario cincoterm NO-ERROR.
        IF  AVAIL inco-cx
        THEN
            DISP inco-cx.descricao @ cdesincoterm WITH FRAME fitinerario.
        ELSE
            DISP "" @ cdesincoterm WITH FRAME fitinerario.
    END.

    ASSIGN cb-via-transp:LIST-ITEMS IN FRAME fitinerario = {adinc/i01ad268.i 03}
           cnarrativa = pedido-compr.comentarios.

    DISP cnarrativa WITH FRAME fitinerario.

    ENABLE icoditiner cbase dadataentrega cincoterm btGoToOK btGoToCancel 
           ctransp cnarrativa cb-via-transp cnarrativaemb
        WITH FRAME fitinerario.

    WAIT-FOR "GO":U OF FRAME fitinerario.

    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
    RUN pi-inicializar IN h-acomp ("Copiando Dados").

    run inbo/boin295.p persistent set h-boin295.
    RUN cxbo/bocx140.p PERSISTENT SET h-bocx140.
    RUN cxbo/bocx220.p PERSISTENT SET h-bocx220.

    run openQueryStatic in h-boin295(input "Main":U).
    RUN openQuery       IN  h-bocx140 (INPUT 1).

    run emptyRowErrors in h-boin295.

    RUN geraNumeroPedidoCompra IN h-boin295 (output i-num-pedido).
    EMPTY TEMP-TABLE tt-pedido-compr.
    EMPTY TEMP-TABLE tt-processo-imp.

    DO TRANSACTION:

        //Criar pedido de Compra
        CREATE tt-pedido-compr.
        BUFFER-COPY pedido-compr TO tt-pedido-compr.
            ASSIGN tt-pedido-compr.num-pedido  = i-num-pedido
                   tt-pedido-compr.cod-transp  = ctransp
                   tt-pedido-compr.via-transp  = {adinc/i01ad268.i 06 cb-via-transp}
                   tt-pedido-compr.comentarios = cnarrativa.

        RUN pi-acompanhar IN h-acomp ("Criando Pedido de Compra:" + STRING(i-num-pedido)).

        run setRecord in h-boin295 (input table tt-pedido-compr).

        run createRecord in h-boin295.
        IF RETURN-VALUE = "NOK" THEN DO:
            run getRowErrors in h-boin295(output table RowErrors append).
            {method/showmessage.i1}
            {method/showmessage.i2 &modal="YES"}
            {method/showmessage.i3}
            UNDO,LEAVE.
        END.

        //Cria Processo de Importa‡Æo - Neste Momento NÆo Valida Cota‡Æo
        CREATE tt-processo-imp.
        BUFFER-COPY processo-imp TO tt-processo-imp
            ASSIGN tt-processo-imp.num-pedido        = i-num-pedido
                   tt-processo-imp.nr-proc-imp       = STRING(i-num-pedido)
                   tt-processo-imp.cod-itiner        = INT(icoditiner)
                   tt-processo-imp.cod-transportador = ctransp
                   tt-processo-imp.cod-incoterm      = cincoterm
                   tt-processo-imp.via-transp        = {adinc/i01ad268.i 06 cb-via-transp}.

        RUN pi-acompanhar IN h-acomp ("Criando Processo de Importa‡Æo:" + STRING(i-num-pedido)).

        RUN validateCreate IN h-bocx140 (INPUT  TABLE tt-processo-imp,
                                         OUTPUT TABLE RowErrors,
                                         OUTPUT r-rowid).

        FIND FIRST rowErrors NO-ERROR.
        IF AVAIL rowErrors THEN DO:
            {method/showmessage.i1}
            {method/showmessage.i2 &modal="YES"}
            {method/showmessage.i3}
            UNDO,LEAVE.
        END.

        FIND FIRST ordens-embarque NO-LOCK
             WHERE ordens-embarque.numero-ordem = ordem-compra.numero-ordem NO-ERROR.
        IF NOT AVAIL ordens-embarque THEN RETURN "OK".
        
        FIND FIRST embarque-imp WHERE
                   embarque-imp.cod-estabel = pedido-compr.cod-estabel AND
                   embarque-imp.embarque = ordens-embarque.embarque      NO-LOCK NO-ERROR.
        IF NOT AVAIL embarque-imp THEN RETURN "OK".

        FIND FIRST itinerario WHERE itinerario.cod-itiner = icoditiner NO-LOCK NO-ERROR.

        FIND FIRST int-itinerario WHERE int-itinerario.cod-itiner = icoditiner NO-LOCK NO-ERROR.

        //Cria Embarque

        CREATE tt-embarque-imp.
        BUFFER-COPY embarque-imp TO tt-embarque-imp
            ASSIGN tt-embarque-imp.embarque            = STRING(i-num-pedido)
                   tt-embarque-imp.situacao            = 1
                   tt-embarque-imp.cod-transportador   = ctransp
                   tt-embarque-imp.cod-via-transp      = {adinc/i01ad268.i 06 cb-via-transp}
                   tt-embarque-imp.cod-incoterm        = cincoterm
                   tt-embarque-imp.narrativa           = cnarrativaemb
                   tt-embarque-imp.contabilizado       = NO
                   tt-embarque-imp.cod-conhecto-master = ""
                   tt-embarque-imp.cod-conhecto-house  = ""
                   c-embarque                          = tt-embarque-imp.embarque
                   da-data-entrega                     = dadataentrega
                   c-base                              = cbase
                   c-incoterm                          = cincoterm
                   tt-embarque-imp.cdn-pto-embarq      = itinerario.pto-embarque
                   tt-embarque-imp.cdn-pto-desembar    = itinerario.pto-desembarque
                   tt-embarque-imp.cdn-pto-despch      = itinerario.pto-despacho
                   tt-embarque-imp.cdn-pto-chegad      = itinerario.pto-chegada.

        RUN pi-acompanhar IN h-acomp ("Criando Embarque:" + STRING(i-num-pedido)).

        run validateCreate IN h-bocx220 (input  table tt-embarque-imp,
                                         output table tt-bo-erro APPEND,
                                         output r-chave).

        IF CAN-FIND(FIRST tt-bo-erro) THEN do:
            FIND FIRST tt-bo-erro NO-ERROR.
            run utp/ut-msgs.p (input "show":U,
                               input tt-bo-erro.cd-erro,
                               input tt-bo-erro.parametros).

            UNDO,LEAVE.
        END.

        RUN pi-cria-pontos-especificos.

        
    END. //do transaction

    ASSIGN c-embarque = STRING(i-num-pedido).
    ASSIGN i-pedido-dest:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(i-num-pedido).

    delete procedure h-boin295.
    ASSIGN h-boin295 = ?.
    DELETE PROCEDURE h-bocx140.
    ASSIGN h-bocx140 = ?.
    DELETE PROCEDURE h-bocx220.
    ASSIGN h-bocx220 = ?.
    RUN pi-finalizar IN h-acomp.
    IF VALID-HANDLE(h-acomp) THEN DELETE PROCEDURE h-acomp.
    ASSIGN h-acomp = ?.

    APPLY "choose" TO bt-vapara-dest.

    DISPLAY cbase     @ c-base-2
            cincoterm @ c-incoterm-2
            WITH FRAME {&FRAME-NAME}.

    FIND inco-cx NO-LOCK
        WHERE inco-cx.cod-incoterm = cincoterm  NO-ERROR.
    IF  AVAIL inco-cx
    THEN
        DISP inco-cx.descricao @ v-des-incoterm-2 WITH FRAME {&FRAME-NAME}.
    ELSE
        DISP "" @ v-des-incoterm-2 WITH FRAME {&FRAME-NAME}.

    FIND pto-contr NO-LOCK
        WHERE pto-contr.cod-pto-contr = INT(cbase) NO-ERROR.
    IF  AVAIL pto-contr
    THEN
        DISP pto-contr.descricao @ v-des-pto-2 WITH FRAME {&FRAME-NAME}.
    ELSE
        DISP "" @ v-des-pto-2 WITH FRAME {&FRAME-NAME}.

    /*ASSIGN c-base = "".*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-parcela
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-parcela wWindow
ON CHOOSE OF bt-parcela IN FRAME fpage0 /* Toda Parcela */
DO:
    FIND b-pedido-compr NO-LOCK WHERE 
         b-pedido-compr.num-pedido = INT(i-pedido-dest:SCREEN-VALUE IN FRAME {&FRAME-NAME}) NO-ERROR.
    IF  NOT AVAIL b-pedido-compr THEN DO:
        MESSAGE "Pedido nÆo cadastrado."
           VIEW-AS ALERT-BOX INFO BUTTONS OK.

        RETURN NO-APPLY.
    END.

    FIND FIRST emitente NO-LOCK
         WHERE emitente.cod-emitente = b-pedido-compr.cod-emitente no-error.

    IF c-fornecedor:SCREEN-VALUE IN FRAME {&FRAME-NAME} <>
       emitente.nome-abrev THEN DO:

        MESSAGE "O fornecedor deste pedido ‚ diferente do fornecedor do pedido original"
            VIEW-AS ALERT-BOX ERROR BUTTONS OK.

       RETURN NO-APPLY.
    END.

    FIND embarque-imp NO-LOCK WHERE
         embarque-imp.cod-estabel = b-pedido-compr.cod-estabel AND
         embarque-imp.embarque = ordens-embarque.embarque NO-ERROR.
    IF  NOT AVAIL embarque-imp THEN DO:
        MESSAGE "Embarque nao cadastrado. NÆo ser  poss¡vel efetuar transferˆncia."
            VIEW-AS ALERT-BOX INFO BUTTONS OK.

        RETURN NO-APPLY.
    END.

    FOR EACH invoice-emb-imp OF embarque-imp NO-LOCK:
        FIND FIRST pagamento-invoice NO-LOCK
             WHERE pagamento-invoice.embarque   = embarque-imp.embarque
               AND pagamento-invoice.nr-invoice = invoice-emb-imp.nr-invoice 
               AND pagamento-invoice.parcela    = invoice-emb-imp.parcela NO-ERROR.
    
        IF AVAIL pagamento-invoice THEN DO:
            MESSAGE "Esta parcela nÆo pode ser transferida. J  existe uma CI de pagamento cadastrada."
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
            RETURN NO-APPLY.
        END.
    END.
    
    IF STRING(i-num-pedido) <> INPUT FRAME {&FRAME-NAME} i-pedido-dest THEN DO:
        IF CAN-FIND(FIRST pedido-compr NO-LOCK
                    WHERE pedido-compr.num-pedido = int(INPUT FRAME {&FRAME-NAME} i-pedido-dest)) THEN DO:
            MESSAGE "Esta parcela nÆo pode ser transferida para um pedido j  existente. Favor criar novo Pedido atrav‚s deste programa."
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
            RETURN NO-APPLY.
        END.
    END.

    IF embarque-imp.situacao = 2 THEN DO:
        MESSAGE "Este embarque j  se encontra encerrado. NÆo ser  poss¡vel efetuar transferˆncia."
           VIEW-AS ALERT-BOX INFO BUTTONS OK.

        RETURN NO-APPLY.
    END.

    IF  //v-des-sit-emb:SCREEN-VALUE IN BROWSE br-ori = "EMBA" OR
        v-des-sit-emb:SCREEN-VALUE IN BROWSE br-ori = "Embar" OR
        v-des-sit-emb:SCREEN-VALUE IN BROWSE br-ori = "DI"    OR
        v-des-sit-emb:SCREEN-VALUE IN BROWSE br-ori = "NF"   THEN DO:
        MESSAGE "A‡Æo proibida: Parcela em Embarque com Situa‡Æo de Processo de Importa‡Æo corrente."
            VIEW-AS ALERT-BOX INFO BUTTONS OK.

        RETURN NO-APPLY.
    END.

    /*IF  v-des-sit-emb:SCREEN-VALUE IN BROWSE br-ori = "Embar" OR
        v-des-sit-emb:SCREEN-VALUE IN BROWSE br-ori = "DI"   THEN DO:

        MESSAGE "Este Embarque J  Possui Status Ap¢s Embarcado" SKIP
                "Certifique-se de que Realmente Deseja Alterar" SKIP
                "Confirma ?"
            VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE l-conf.

        IF NOT l-conf THEN RETURN NO-APPLY.
    END.*/

    /*FIND FIRST b-prazo-compra NO-LOCK
        WHERE b-prazo-compra.numero-ordem = ordem-compra.numero-ordem
          AND b-prazo-compra.situacao = 2
          AND b-prazo-compra.parcela <> prazo-compra.parcela NO-ERROR.
    IF NOT AVAIL b-prazo-compra THEN DO:
        MESSAGE "Esta op‡Æo s¢ pode ser utilizada para ordens parceladas"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
        RETURN NO-APPLY.
    END.
    */

    assign de-saldo-aux = 0
           de-preco-aux = 0.

    /* Para o TOTVS 11, busca o n�mero da Ordem pela API */
    RUN ccp/ccapi333.p (INPUT YES,
                        OUTPUT i-nr-ordem).

    EMPTY TEMP-TABLE tt-pedido-compr.
    EMPTY TEMP-TABLE tt-ordem-compra.
    EMPTY TEMP-TABLE tt-prazo-compra.
    EMPTY TEMP-TABLE tt-cotacao-item.
    EMPTY TEMP-TABLE tt-processo-imp.
    EMPTY TEMP-TABLE tt-embarque-imp.
    EMPTY TEMP-TABLE tt-bo-erro.
    EMPTY TEMP-TABLE rowErrors.

    RUN inbo/boin356vl.p PERSISTENT SET h-boin356vl.
    RUN inbo/boin274vl.p PERSISTENT SET h-boin274vl.
    RUN inbo/boin082.p   persistent set h-boin082.
    RUN cxbo/bocx225.p   PERSISTENT SET h-bocx225.
    RUN inbo/boin356na.p PERSISTENT SET h-boin356na.

    RUN cxbo/bocx404.p PERSISTENT SET h-bocx404.
    RUN openQueryStatic IN h-bocx404(INPUT "Main":U).

    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
    RUN pi-inicializar IN h-acomp ("Copiando Dados").

    assign r-prazo = ?.

    blk_trans:
    DO TRANSACTION:

        //Criar Ordem de Compra e Parcela
        CREATE tt-ordem-compra.
        BUFFER-COPY ordem-compra TO tt-ordem-compra
            ASSIGN tt-ordem-compra.numero-ordem = i-nr-ordem
                   tt-ordem-compra.num-pedido   = INT(i-pedido-dest:SCREEN-VALUE IN FRAME {&FRAME-NAME})
                   tt-ordem-compra.qt-acum-nec  = prazo-compra.quant-saldo
                   tt-ordem-compra.qt-solic     = prazo-compra.quant-saldo
                   tt-ordem-compra.usuario      = c-seg-usuario
                   tt-ordem-compra.data-emissao = TODAY
                   tt-ordem-compra.data-atualiz = TODAY
                   tt-ordem-compra.hora-atualiz = string(time,"hh:mm:ss").

        create tt-prazo-compra.
        BUFFER-COPY prazo-compra TO tt-prazo-compra
            assign tt-prazo-compra.numero-ordem = i-nr-ordem
                   tt-prazo-compra.data-entrega = da-data-entrega
                   tt-prazo-compra.parcela      = 1
                   tt-prazo-compra.data-orig    = TODAY.

        assign de-saldo-aux = prazo-compra.quant-saldo
               de-preco-aux = ordem-compra.preco-fornec.

        RUN pi-acompanhar IN h-acomp ("Criando Ordem de Compra: " + STRING(i-nr-ordem)).

        RUN inputTableOrdemCompra IN h-boin356vl (input table tt-ordem-compra).

        RUN emptyRowErrors IN h-boin356vl.
        RUN validateCreateManutOrdCompra in h-boin356vl (input  table tt-prazo-compra,
                                                         input  table tt-prazo-compra-old,
                                                         input  "add":U, 
                                                         input  today,
                                                         input  12/31/9999,
                                                         input  c-seg-usuario,
                                                         input  YES, /* Lote Minimo */
                                                         input  YES, /* Ordens Com Pedidos Pendentes  */
                                                         input  YES, /* Lote Multiplo */
                                                         output table RowErrors APPEND).
    
        IF NOT CAN-FIND(FIRST RowErrors 
                        WHERE RowErrors.ErrorSubType = "ERROR":U) THEN DO:
    
            RUN inputTable IN h-boin274vl (input table tt-ordem-compra).
            RUN executeCreateManutOrdCompra IN h-boin274vl (input yes, output r-ordem).
                                        
            RUN getRowErrors in h-boin274vl (output table RowErrors APPEND).

            RUN pi-acompanhar IN h-acomp ("Criando Parcela: " + STRING(i-nr-ordem)).
    
            RUN setRecord IN h-boin356vl (INPUT TABLE tt-prazo-compra).
            RUN executeCreateManutOrdCompra IN h-boin356vl (input c-seg-usuario, output r-prazo).
    
            RUN getRowErrors in h-boin356vl (output table RowErrors APPEND).           
        END. /* IF NOT CAN-FIND(FIRST RowErrors  */

        FIND FIRST rowErrors WHERE RowErrors.ErrorSubType = "ERROR" AND
                                   rowErrors.errornumber <> 26505 NO-ERROR.
        IF AVAIL rowErrors THEN DO:

            RUN pi-finalizar IN h-acomp.

            {method/showmessage.i1}
            {method/showmessage.i2 &modal="YES"}
            {method/showmessage.i3}
            UNDO,LEAVE.

        END.

        //Criar Cota‡Æo
        FOR EACH cotacao-item NO-LOCK WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem:
            create tt-cotacao-item.
            BUFFER-COPY cotacao-item TO tt-cotacao-item
                ASSIGN tt-cotacao-item.numero-ordem          = i-nr-ordem
                       tt-cotacao-item.usuario               = c-seg-usuario
                       tt-cotacao-item.data-atualiz          = TODAY
                       tt-cotacao-item.hora-atualiz          = string(time,"hh:mm:ss")
                       tt-cotacao-item.int-1                 = INT(c-itinerario-2:SCREEN-VALUE IN FRAME {&FRAME-NAME})
                       tt-cotacao-item.cod-cond-pag          = IF AVAIL b-pedido-compr THEN b-pedido-compr.cod-cond-pag ELSE 0
                       OVERLAY(tt-cotacao-item.char-1,41,20) = string(c-base-2:SCREEN-VALUE IN FRAME {&FRAME-NAME},"x(20)")
                       OVERLAY(tt-cotacao-item.char-1,21,20) = string(c-incoterm-2:SCREEN-VALUE IN FRAME {&FRAME-NAME},"x(20)").
        END. //for each cotacao-item

        RUN pi-acompanhar IN h-acomp ("Criando Cota‡Æo: " + STRING(i-nr-ordem)).
          
        run openQueryStatic in h-boin082 (input "main").
        run setRecord in h-boin082 (input table tt-cotacao-item).
        run createRecord in h-boin082. 
        if return-value = "NOK":U then do:
            run getRowErrors in h-boin082 (output table RowErrors).

            RUN pi-finalizar IN h-acomp.

            {method/showmessage.i1}
            {method/showmessage.i2 &modal="YES"}
            {method/showmessage.i3}

            UNDO,LEAVE.

        END.

        //Asociar a Ordem com o Embarque

        FIND b-embarque-imp NO-LOCK WHERE b-embarque-imp.cod-estabel = tt-ordem-compra.cod-estabel AND
                                          b-embarque-imp.embarque    = c-embarque NO-ERROR.

        RUN pi-acompanhar IN h-acomp ("Associando Ordem a Embarque: " + STRING(i-nr-ordem) + "/" + c-embarque).

        run createOrdensembarque in h-bocx225 (ROWID(b-embarque-imp),
                                               tt-ordem-compra.numero-ordem,
                                               tt-ordem-compra.qt-solic,
                                               output table tt-bo-erro APPEND).

        IF CAN-FIND(FIRST tt-bo-erro WHERE tt-bo-erro.cd-erro <> 26505) THEN do:
            FIND FIRST tt-bo-erro WHERE tt-bo-erro.cd-erro <> 26505 NO-ERROR.

            RUN pi-finalizar IN h-acomp.

            run utp/ut-msgs.p (input "show":U,
                               input tt-bo-erro.cd-erro,
                               input tt-bo-erro.parametros).
            UNDO,LEAVE.
        END.

        //Desassociar Ordem Antiga do Embarque

        RUN pi-acompanhar IN h-acomp ("Tirando Ordem do Embarque Antigo: " + STRING(ordem-compra.numero-ordem)).

        FOR EACH b-ordens-embarque
           WHERE b-ordens-embarque.numero-ordem = ordem-compra.numero-ordem
             AND b-ordens-embarque.parcela      = prazo-compra.parcela exclusive-lock:

            ASSIGN r-rowid = ROWID(b-ordens-embarque).

            RUN validateDelete IN h-bocx225 (INPUT-OUTPUT r-rowid, 
                                             OUTPUT TABLE RowErrors).

            FIND FIRST rowErrors NO-ERROR.
            IF AVAIL rowErrors THEN DO:

                RUN pi-finalizar IN h-acomp.
            
                {method/showmessage.i1}
                {method/showmessage.i2 &modal="YES"}
                {method/showmessage.i3}
                UNDO,LEAVE.
            
            END.
        END.

        RUN verificaIntegraDI IN h-bocx404 (INPUT prazo-compra.numero-ordem, 
                                            INPUT prazo-compra.parcela, 
                                            OUTPUT l-integra-di). 
    
        IF l-integra-di THEN DO:    
            RUN desvinculaOrdem IN h-bocx404 (INPUT prazo-compra.numero-ordem, 
                                              INPUT prazo-compra.parcela).
        END.

        FIND FIRST b2-pedido-compr NO-LOCK
              WHERE b2-pedido-compr.num-pedido = ordem-compra.num-pedido NO-ERROR.

        RUN pi-acompanhar IN h-acomp ("Eliminando Parcela Antiga: " + STRING(ordem-compra.numero-ordem)).             
    
        RUN eliminaParcelaPrazoCompra IN h-boin356na (INPUT c-seg-usuario, /* usuario do sistema */
                                                      INPUT ROWID(b2-pedido-compr),
                                                      INPUT ROWID(ordem-compra),
                                                      INPUT ROWID(prazo-compra),
                                                      INPUT "Troca de itiner rio pelo esimp019.").

        FIND CURRENT ordem-compra NO-LOCK NO-ERROR.
        find current prazo-compra no-lock no-error.

        IF ordem-compra.qt-solic = 0 THEN DO:

            FIND FIRST b2-pedido-compr NO-LOCK
                 WHERE b2-pedido-compr.num-pedido = ordem-compra.num-pedido NO-ERROR.    

            RUN pi-acompanhar IN h-acomp ("Atualizando Pedido Antigo: " + STRING(b2-pedido-compr.num-pedido)).
    
            RUN atualizaSituacaoProcessoImportacao IN h-boin356vl (INPUT b2-pedido-compr.num-pedido,
                                                                   INPUT b2-pedido-compr.cod-emitente,
                                                                   INPUT b2-pedido-compr.cod-estabel).

        END.

        run pi-cria-relacto (input rowid(prazo-compra), /* Origem  */
                             input r-prazo ,            /* Destino */
                             input de-saldo-aux,
                             input de-preco-aux).

    END.

    DELETE PROCEDURE h-boin356vl.
    ASSIGN h-boin356vl = ?.
    DELETE PROCEDURE h-boin274vl.
    ASSIGN h-boin274vl = ?.
    DELETE PROCEDURE h-boin082.
    ASSIGN h-boin082 = ?.
    DELETE PROCEDURE h-bocx225.
    ASSIGN h-bocx225 = ?.
    DELETE PROCEDURE h-bocx404.
    ASSIGN h-bocx404 = ?.
    DELETE PROCEDURE h-boin356na.
    ASSIGN h-boin356na = ?.
    IF VALID-HANDLE(h-acomp) THEN RUN pi-finalizar IN h-acomp.
    IF VALID-HANDLE(h-acomp) THEN DELETE PROCEDURE h-acomp.
    ASSIGN h-acomp = ?.
   
    {&open-query-br-ori}
    {&open-query-br-dest}
    APPLY "choose" TO bt-vapara-dest IN FRAME {&FRAME-NAME}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-parcial
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-parcial wWindow
ON CHOOSE OF bt-parcial IN FRAME fpage0 /* Parcela Parcial */
DO:
    FIND b-pedido-compr NO-LOCK WHERE 
         b-pedido-compr.num-pedido = INT(i-pedido-dest:SCREEN-VALUE IN FRAME {&FRAME-NAME}) NO-ERROR.
    IF  NOT AVAIL b-pedido-compr THEN DO:
        MESSAGE "Pedido nÆo cadastrado."
            VIEW-AS ALERT-BOX INFO BUTTONS OK.

        RETURN NO-APPLY.
    END.

    FIND FIRST emitente NO-LOCK
         WHERE emitente.cod-emitente = b-pedido-compr.cod-emitente no-error.

    IF c-fornecedor:SCREEN-VALUE IN FRAME {&FRAME-NAME} <>
       emitente.nome-abrev THEN DO:

        MESSAGE "O fornecedor deste pedido ‚ diferente do fornecedor do pedido original"
            VIEW-AS ALERT-BOX ERROR BUTTONS OK.

       RETURN NO-APPLY.
    END.

    FIND embarque-imp NO-LOCK WHERE
         embarque-imp.cod-estabel = b-pedido-compr.cod-estabel AND
         embarque-imp.embarque = ordens-embarque.embarque NO-ERROR.
    IF  NOT AVAIL embarque-imp THEN DO:
        MESSAGE "Embarque nao cadastrado. NÆo ser  poss¡vel efetuar transferˆncia."
            VIEW-AS ALERT-BOX INFO BUTTONS OK.

        RETURN NO-APPLY.
    END.

    FOR EACH invoice-emb-imp OF embarque-imp NO-LOCK:
        FIND FIRST pagamento-invoice NO-LOCK
             WHERE pagamento-invoice.embarque   = embarque-imp.embarque
               AND pagamento-invoice.nr-invoice = invoice-emb-imp.nr-invoice 
               AND pagamento-invoice.parcela    = invoice-emb-imp.parcela NO-ERROR.
    
        IF AVAIL pagamento-invoice THEN DO:
            MESSAGE "Esta parcela nÆo pode ser transferida. J  existe uma CI de pagamento cadastrada."
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
            RETURN NO-APPLY.
        END.
    END.

    IF STRING(i-num-pedido) <> INPUT FRAME {&FRAME-NAME} i-pedido-dest THEN DO:
        IF CAN-FIND(FIRST pedido-compr NO-LOCK
                    WHERE pedido-compr.num-pedido = int(INPUT FRAME {&FRAME-NAME} i-pedido-dest)) THEN DO:
            MESSAGE "Esta parcela nÆo pode ser transferida para um pedido j  existente. Favor criar novo Pedido atrav‚s deste programa."
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
            RETURN NO-APPLY.
        END.
    END.

    IF  embarque-imp.situacao = 2 THEN DO:
        MESSAGE "Este embarque j  se encontra encerrado. NÆo ser  poss¡vel efetuar transferˆncia."
            VIEW-AS ALERT-BOX INFO BUTTONS OK.

        RETURN NO-APPLY.
    END.

    IF  //v-des-sit-emb:SCREEN-VALUE IN BROWSE br-ori = "EMBA" OR
        v-des-sit-emb:SCREEN-VALUE IN BROWSE br-ori = "Embar" OR
        v-des-sit-emb:SCREEN-VALUE IN BROWSE br-ori = "DI"    OR
        v-des-sit-emb:SCREEN-VALUE IN BROWSE br-ori = "NF"   THEN DO:
        MESSAGE "A‡Æo proibida: Parcela em Embarque com Situa‡Æo de Processo de Importa‡Æo corrente."
            VIEW-AS ALERT-BOX INFO BUTTONS OK.

        RETURN NO-APPLY.
    END.

    /*IF  v-des-sit-emb:SCREEN-VALUE IN BROWSE br-ori = "Embar" OR
        v-des-sit-emb:SCREEN-VALUE IN BROWSE br-ori = "DI"   THEN DO:

        MESSAGE "Este Embarque J  Possui Status Ap¢s Embarcado" SKIP
                "Certifique-se de que Realmente Deseja Alterar" SKIP
                "Confirma ?"
            VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE l-conf.

        IF NOT l-conf THEN RETURN NO-APPLY.
    END.*/

    /* Para o TOTVS 11, busca o n£mero da Ordem pela API */
    RUN ccp/ccapi333.p (INPUT YES,
                        OUTPUT i-nr-ordem).

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

    DEFINE FRAME fqtd
       iqtd        AT ROW 1.21 COL 17.72 COLON-ALIGNED
       btGoToOK          AT ROW 2.63 COL 2.14
       btGoToCancel      AT ROW 2.63 COL 13
       rtGoToButton      AT ROW 2.38 COL 1
       SPACE(0.28)
       WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
            THREE-D SCROLLABLE TITLE "Quantidade" FONT 1
            DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.

    ON "CHOOSE":U OF btGoToOK IN FRAME fqtd DO:
        ASSIGN iqtd.

        APPLY "GO":U TO FRAME fqtd.
    END.

    ENABLE iqtd btGoToOK btGoToCancel 
         WITH FRAME fqtd.

    WAIT-FOR "GO":U OF FRAME fqtd.

    HIDE FRAME fqtd NO-PAUSE.
    
    IF iqtd >= prazo-compra.quant-saldo THEN DO:
         MESSAGE "A quantidade deve ser menor que a quantidade da parcela"
             VIEW-AS ALERT-BOX INFO BUTTONS OK.
         RETURN NO-APPLY.
    END.

    assign r-prazo = ?.

    FIND item-fornec NO-LOCK WHERE
         ITEM-fornec.it-codigo = ordem-compra.it-codigo and
         item-fornec.cod-emitente = ordem-compra.cod-emitente no-error.

    EMPTY TEMP-TABLE tt-pedido-compr.
    EMPTY TEMP-TABLE tt-ordem-compra.
    EMPTY TEMP-TABLE tt-prazo-compra.
    EMPTY TEMP-TABLE tt-cotacao-item.
    EMPTY TEMP-TABLE tt-processo-imp.
    EMPTY TEMP-TABLE tt-embarque-imp.
    EMPTY TEMP-TABLE tt-bo-erro.
    EMPTY TEMP-TABLE rowErrors.

    FIND ITEM NO-LOCK WHERE ITEM.it-codigo = ordem-compra.it-codigo NO-ERROR.
    FIND item-uni-estab NO-LOCK WHERE item-uni-estab.it-codigo   = ordem-compra.it-codigo   AND
                                      item-uni-estab.cod-estabel = ordem-compra.cod-estabel NO-ERROR.

    ASSIGN i-lote-min          = 0
           i-lote-mult         = 0
           l-item-fornec       = FALSE
           l-item-fornec-estab = FALSE.


    if avail item then
       assign i-lote-mult = item.lote-multipl
              i-lote-min  = item.lote-minimo.             
           
    if avail item-uni-estab then
       assign i-lote-mult = item-uni-estab.lote-multipl
              i-lote-min  = item-uni-estab.lote-minimo.

    if avail item-fornec THEN DO:
      assign i-lote-mult = item-fornec.lote-mul-for
             i-lote-min  = item-fornec.lote-minimo
             l-item-fornec = yes.
    
       for first item-fornec-estab fields(it-codigo cod-emitente cod-estabel ativo lote-minimo lote-mul-for)
           where item-fornec-estab.it-codigo    = item.it-codigo and
                 item-fornec-estab.cod-estabel  = tt-ordem-compra.cod-estabel and
                 item-fornec-estab.cod-emitente = tt-ordem-compra.cod-emitente no-lock: end.    
       if avail item-fornec-estab then          
          assign i-lote-mult = item-fornec-estab.lote-mul-for
                 i-lote-min  = item-fornec-estab.lote-minimo
                 l-item-fornec-estab = yes.
    end.

   //Valida‡Æo Lote Multiplo

   if l-item-fornec-estab or l-item-fornec then do:
        IF  i-lote-mult <> 0 THEN
            assign de-nr-lotes = iqtd / i-lote-mult.

        if  de-nr-lotes - truncate(de-nr-lotes,0) <> 0 THEN DO:
            MESSAGE "Quantidade da parcela " iqtd " deve ser divis¡vel pelo lote m£ltiplo " i-lote-mult SKIP
                    "Confirma Altera‡Æo?"
                VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE l-conf.

            IF NOT l-conf THEN RETURN NO-APPLY.
            
        END.

    END.
    ELSE DO:
        if i-lote-mult <> 0 and ((integer(iqtd / i-lote-mult)) * i-lote-mult) <> iqtd then do:
            MESSAGE "Quantidade da parcela " iqtd " deve ser divis¡vel pelo lote m£ltiplo " i-lote-mult SKIP
                    "Confirma Altera‡Æo?"
                VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE l-conf.

            IF NOT l-conf THEN RETURN NO-APPLY.

        END.
    END.

    //Valida‡Æo Lote Minimo
    if iqtd < i-lote-min then do:
        MESSAGE "Quantidade informada para a ordem de compra " iqtd " ‚ menor que o lote m¡nimo " i-lote-min SKIP
                    "Confirma Altera‡Æo?"
                VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE l-conf.

            IF NOT l-conf THEN RETURN NO-APPLY.

    END.

    assign de-saldo-aux = 0
           de-preco-aux = 0.

    RUN inbo/boin356vl.p PERSISTENT SET h-boin356vl.
    RUN inbo/boin274vl.p PERSISTENT SET h-boin274vl.
    RUN inbo/boin082.p   persistent set h-boin082.
    RUN cxbo/bocx225.p   PERSISTENT SET h-bocx225.
    RUN inbo/boin356na.p PERSISTENT SET h-boin356na.

    RUN cxbo/bocx404.p PERSISTENT SET h-bocx404.
    RUN openQueryStatic IN h-bocx404(INPUT "Main":U).

    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
    RUN pi-inicializar IN h-acomp ("Copiando Dados").

    blk_trans:
    DO TRANSACTION:

        //Criar Ordem de Compra e Parcela
        CREATE tt-ordem-compra.
        BUFFER-COPY ordem-compra TO tt-ordem-compra
            ASSIGN tt-ordem-compra.numero-ordem = i-nr-ordem
                   tt-ordem-compra.num-pedido   = INT(i-pedido-dest:SCREEN-VALUE IN FRAME {&FRAME-NAME})
                   tt-ordem-compra.qt-acum-nec  = iqtd
                   tt-ordem-compra.qt-solic     = iqtd
                   tt-ordem-compra.usuario      = c-seg-usuario
                   tt-ordem-compra.data-emissao = TODAY
                   tt-ordem-compra.data-atualiz = TODAY
                   tt-ordem-compra.hora-atualiz = string(time,"hh:mm:ss").

        create tt-prazo-compra.
        BUFFER-COPY prazo-compra TO tt-prazo-compra
            assign tt-prazo-compra.numero-ordem = i-nr-ordem
                   tt-prazo-compra.data-entrega = da-data-entrega
                   tt-prazo-compra.parcela      = 1
                   tt-prazo-compra.quant-saldo  = iqtd
                   tt-prazo-compra.qtd-sal-forn = iqtd / (item-fornec.fator-conver * EXP(10, item-fornec.num-casa-dec))
                   tt-prazo-compra.qtd-do-forn  = tt-prazo-compra.qtd-sal-forn
                   tt-prazo-compra.quantid-orig = iqtd
                   tt-prazo-compra.quantidade   = iqtd
                   tt-prazo-compra.data-orig    = TODAY.

        assign de-saldo-aux = iqtd
               de-preco-aux = ordem-compra.preco-fornec.

        RUN pi-acompanhar IN h-acomp ("Criando Ordem de Compra: " + STRING(i-nr-ordem)).

        RUN inputTableOrdemCompra IN h-boin356vl (input table tt-ordem-compra).

        RUN emptyRowErrors IN h-boin356vl.
        RUN validateCreateManutOrdCompra in h-boin356vl (input  table tt-prazo-compra,
                                                         input  table tt-prazo-compra-old,
                                                         input  "add":U, 
                                                         input  today,
                                                         input  12/31/9999,
                                                         input  c-seg-usuario,
                                                         input  YES, /* Lote Minimo */
                                                         input  YES, /* Ordens Com Pedidos Pendentes  */
                                                         input  YES, /* Lote Multiplo */
                                                         output table RowErrors APPEND).
    
        IF NOT CAN-FIND(FIRST RowErrors 
                        WHERE RowErrors.ErrorSubType = "ERROR":U) THEN DO:
    
            RUN inputTable IN h-boin274vl (input table tt-ordem-compra).
            RUN executeCreateManutOrdCompra IN h-boin274vl (input yes, output r-ordem).
                                        
            RUN getRowErrors in h-boin274vl (output table RowErrors APPEND).

            RUN pi-acompanhar IN h-acomp ("Criando Parcela: " + STRING(i-nr-ordem)).
    
            RUN setRecord IN h-boin356vl (INPUT TABLE tt-prazo-compra).
            RUN executeCreateManutOrdCompra IN h-boin356vl (input c-seg-usuario, output r-prazo).
    
            RUN getRowErrors in h-boin356vl (output table RowErrors APPEND).           
        END. /* IF NOT CAN-FIND(FIRST RowErrors  */

        FIND FIRST rowErrors WHERE RowErrors.ErrorSubType = "ERROR":U AND 
                                   rowErrors.errornumber <> 26505 NO-ERROR.
        IF AVAIL rowErrors THEN DO:

            RUN pi-finalizar IN h-acomp.

            {method/showmessage.i1}
            {method/showmessage.i2 &modal="YES"}
            {method/showmessage.i3}
            UNDO,LEAVE.

        END.

        //Criar Cota‡Æo
        FOR EACH cotacao-item NO-LOCK WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem:

            create tt-cotacao-item.
            BUFFER-COPY cotacao-item TO tt-cotacao-item
                ASSIGN tt-cotacao-item.numero-ordem          = i-nr-ordem
                       tt-cotacao-item.usuario               = c-seg-usuario
                       tt-cotacao-item.data-atualiz          = TODAY
                       tt-cotacao-item.hora-atualiz          = string(time,"hh:mm:ss")
                       tt-cotacao-item.int-1                 = INT(c-itinerario-2:SCREEN-VALUE IN FRAME {&FRAME-NAME})
                       tt-cotacao-item.cod-cond-pag          = IF AVAIL b-pedido-compr THEN b-pedido-compr.cod-cond-pag ELSE 0
                       OVERLAY(tt-cotacao-item.char-1,41,20) = string(c-base-2:SCREEN-VALUE IN FRAME {&FRAME-NAME},"x(20)")
                       OVERLAY(tt-cotacao-item.char-1,21,20) = string(c-incoterm-2:SCREEN-VALUE IN FRAME {&FRAME-NAME},"x(20)").

        END. //for each cotacao-item

        RUN pi-acompanhar IN h-acomp ("Criando Cota‡Æo: " + STRING(i-nr-ordem)).
          
        run openQueryStatic in h-boin082 (input "main").
        run setRecord in h-boin082 (input table tt-cotacao-item).
        run createRecord in h-boin082. 
        if return-value = "NOK":U then do:
            run getRowErrors in h-boin082 (output table RowErrors APPEND).

            RUN pi-finalizar IN h-acomp.

            {method/showmessage.i1}
            {method/showmessage.i2 &modal="YES"}
            {method/showmessage.i3}

            UNDO,LEAVE.

        END.

        //Asociar a Ordem com o Embarque

        FIND b-embarque-imp NO-LOCK WHERE b-embarque-imp.cod-estabel = tt-ordem-compra.cod-estabel AND
                                          b-embarque-imp.embarque    = c-embarque NO-ERROR.

        RUN pi-acompanhar IN h-acomp ("Associando Ordem a Embarque: " + STRING(i-nr-ordem) + "/" + c-embarque).

        run createOrdensembarque in h-bocx225 (ROWID(b-embarque-imp),
                                               tt-ordem-compra.numero-ordem,
                                               tt-ordem-compra.qt-solic,
                                               output table tt-bo-erro APPEND).

        IF CAN-FIND(FIRST tt-bo-erro WHERE tt-bo-erro.cd-erro <> 26505) THEN do:
            FIND FIRST tt-bo-erro WHERE tt-bo-erro.cd-erro <> 26505 NO-ERROR.

            RUN pi-finalizar IN h-acomp.

            run utp/ut-msgs.p (input "show":U,
                               input tt-bo-erro.cd-erro,
                               input tt-bo-erro.parametros).
            UNDO,LEAVE.
        END.

        //Alterar a Parcela para nova quantidade de saldo

        RUN pi-acompanhar IN h-acomp ("Atualizando Parcela Antiga: " + STRING(ordem-compra.numero-ordem)). 

        EMPTY TEMP-TABLE tt-prazo-compra.
        CREATE tt-prazo-compra.
        BUFFER-COPY prazo-compra TO tt-prazo-compra.

        ASSIGN tt-prazo-compra.quant-saldo  = tt-prazo-compra.quant-saldo - iqtd
               tt-prazo-compra.quantidade   = tt-prazo-compra.quantidade - iqtd
               tt-prazo-compra.quantid-orig = tt-prazo-compra.quantid-orig - iqtd.
        
        IF AVAIL item-fornec THEN
            ASSIGN tt-prazo-compra.qtd-sal-forn = tt-prazo-compra.qtd-sal-forn - (iqtd / (item-fornec.fator-conver * EXP(10, item-fornec.num-casa-dec)))
                   tt-prazo-compra.qtd-do-forn  = tt-prazo-compra.qtd-do-forn - (iqtd / (item-fornec.fator-conver * EXP(10, item-fornec.num-casa-dec))).

        RUN emptyRowErrors IN h-boin356vl.
        RUN ValidateUpdateManutOrdCompra in h-boin356vl (input  table tt-prazo-compra,
                                                         INPUT  TABLE tt-prazo-compra-old,
                                                         INPUT  "Update",
                                                         input  ROWID(prazo-compra),
                                                         input  today,
                                                         input  12/31/9999,
                                                         input  c-seg-usuario,
                                                         input  YES, /* Lote Minimo */
                                                         input  YES, /*Exportar Altera‡äes Para Outras Parcelas*/
                                                         INPUT  NO,  /* Ordens Com Pedidos Pendentes  */
                                                         input  YES, /* Lote Multiplo */
                                                         output table RowErrors APPEND).

        IF NOT CAN-FIND(FIRST RowErrors 
                        WHERE RowErrors.ErrorSubType = "ERROR":U) THEN DO:

            RUN inputTable IN h-boin356vl (input table tt-prazo-compra).
            RUN executeUpdateManutOrdCompra IN h-boin356vl (INPUT ROWID(prazo-compra)).

            RUN getRowErrors in h-boin356vl (output TABLE RowErrors APPEND).           
        END. /* IF NOT CAN-FIND(FIRST RowErrors  */

        FIND FIRST rowErrors WHERE RowErrors.ErrorSubType = "ERROR":U and
                                   rowErrors.errornumber <> 26505 AND 
                                   rowErrors.errornumber <> 28558 NO-ERROR.
        IF AVAIL rowErrors THEN DO:

            RUN pi-finalizar IN h-acomp.

            {method/showmessage.i1}
            {method/showmessage.i2 &modal="YES"}
            {method/showmessage.i3}
            UNDO,LEAVE.

        END.

        FIND CURRENT ordem-compra NO-LOCK NO-ERROR.

        IF ordem-compra.qt-solic = 0 THEN DO:

             //Desassociar Ordem Antiga do Embarque
            RUN pi-acompanhar IN h-acomp ("Tirando Ordem do Embarque Antigo: " + STRING(ordem-compra.numero-ordem)).
    
            FOR EACH b-ordens-embarque
               WHERE b-ordens-embarque.numero-ordem = ordem-compra.numero-ordem
                 AND b-ordens-embarque.parcela      = prazo-compra.parcela exclusive-lock:
    
                ASSIGN r-rowid = ROWID(b-ordens-embarque).
    
                RUN validateDelete IN h-bocx225 (INPUT-OUTPUT r-rowid, 
                                                 OUTPUT TABLE RowErrors APPEND).
    
                FIND FIRST rowErrors NO-ERROR.
                IF AVAIL rowErrors THEN DO:
    
                    RUN pi-finalizar IN h-acomp.
                
                    {method/showmessage.i1}
                    {method/showmessage.i2 &modal="YES"}
                    {method/showmessage.i3}
                    UNDO,LEAVE.
                
                END.
            END.
    
            RUN verificaIntegraDI IN h-bocx404 (INPUT prazo-compra.numero-ordem, 
                                                INPUT prazo-compra.parcela, 
                                                OUTPUT l-integra-di). 
        
            IF l-integra-di THEN DO:    
                RUN desvinculaOrdem IN h-bocx404 (INPUT prazo-compra.numero-ordem, 
                                                  INPUT prazo-compra.parcela).
            END.

            FIND FIRST b2-pedido-compr NO-LOCK
                 WHERE b2-pedido-compr.num-pedido = ordem-compra.num-pedido NO-ERROR.

            RUN pi-acompanhar IN h-acomp ("Atualizando Pedido Antigo: " + STRING(b2-pedido-compr.num-pedido)).
    
            RUN atualizaSituacaoProcessoImportacao IN h-boin356vl (INPUT b2-pedido-compr.num-pedido,
                                                                   INPUT b2-pedido-compr.cod-emitente,
                                                                   INPUT b2-pedido-compr.cod-estabel).

        END.
        ELSE DO:
            //Se a quantidade nÆo zerou, alterar a quantidade do embarque original
            FOR EACH ordens-embarque NO-LOCK WHERE ordens-embarque.numero-ordem = prazo-compra.numero-ordem AND
                                                   ordens-embarque.parcela      = prazo-compra.parcela:

                EMPTY TEMP-TABLE tt-ordens-embarque-old.
                CREATE tt-ordens-embarque-old.
                BUFFER-COPY ordens-embarque TO tt-ordens-embarque-old
                    ASSIGN tt-ordens-embarque-old.r-rowid = ROWID(ordens-embarque).

                ASSIGN tt-ordens-embarque-old.quantidade = tt-ordens-embarque-old.quantidade - iqtd
                       tt-ordens-embarque-old.qt-do-forn = tt-ordens-embarque-old.qt-do-forn - (iqtd / (item-fornec.fator-conver * EXP(10, item-fornec.num-casa-dec))).

                RUN validateUpdate IN h-bocx225 (INPUT TABLE tt-ordens-embarque-old,
                                                 INPUT ROWID(ordens-embarque),
                                                 OUTPUT TABLE tt-bo-erro APPEND).

                IF CAN-FIND(FIRST tt-bo-erro WHERE tt-bo-erro.cd-erro <> 26505) THEN do:
                    FIND FIRST tt-bo-erro WHERE tt-bo-erro.cd-erro <> 26505 NO-ERROR.
        
                    RUN pi-finalizar IN h-acomp.
        
                    run utp/ut-msgs.p (input "show":U,
                                       input tt-bo-erro.cd-erro,
                                       input tt-bo-erro.parametros).
                    UNDO,LEAVE.
                END.
            END.
        END.

        run pi-cria-relacto (input rowid(prazo-compra), /* Origem  */
                             input r-prazo ,            /* Destino */
                             input de-saldo-aux,
                             input de-preco-aux).

    END.

    DELETE PROCEDURE h-boin356vl.
    ASSIGN h-boin356vl = ?.
    DELETE PROCEDURE h-boin274vl.
    ASSIGN h-boin274vl = ?.
    DELETE PROCEDURE h-boin082.
    ASSIGN h-boin082 = ?.
    DELETE PROCEDURE h-bocx225.
    ASSIGN h-bocx225 = ?.
    DELETE PROCEDURE h-bocx404.
    ASSIGN h-bocx404 = ?.
    DELETE PROCEDURE h-boin356na.
    ASSIGN h-boin356na = ?.
    IF VALID-HANDLE(h-acomp) THEN RUN pi-finalizar IN h-acomp.
    IF VALID-HANDLE(h-acomp) THEN DELETE PROCEDURE h-acomp.
    ASSIGN h-acomp = ?.

    /*IF CAN-FIND(FIRST rowErrors WHERE RowErrors.ErrorSubType = "INFORMATION" AND rowErrors.errornumber = 27645) THEN DO:

        {method/showmessage.i1}
        {method/showmessage.i2 &modal="YES"}
        {method/showmessage.i3}

    END.*/
      
    {&open-query-br-ori}
    {&open-query-br-dest}
    APPLY "choose" TO bt-vapara-dest IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-vapara-dest
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-vapara-dest wWindow
ON CHOOSE OF bt-vapara-dest IN FRAME fpage0 /* Button 5 */
DO:   
    ASSIGN c-fornecedor-2:SCREEN-VALUE     IN FRAME {&FRAME-NAME} = ""
           c-comprador-2:SCREEN-VALUE      IN FRAME {&FRAME-NAME} = ""
           c-itinerario-2:SCREEN-VALUE     IN FRAME {&FRAME-NAME} = ""
           c-emb:SCREEN-VALUE              IN FRAME {&FRAME-NAME} = ""
           data-entrega:SCREEN-VALUE       IN FRAME {&FRAME-NAME} = ""
           c-base-2:SCREEN-VALUE           IN FRAME {&FRAME-NAME} = ""
           c-incoterm-2:SCREEN-VALUE       IN FRAME {&FRAME-NAME} = ""
           v-des-pagto-2:SCREEN-VALUE      IN FRAME {&FRAME-NAME} = ""
           v-des-itiner-2:SCREEN-VALUE     IN FRAME {&FRAME-NAME} = ""
           v-des-pto-2:SCREEN-VALUE        IN FRAME {&FRAME-NAME} = ""
           v-des-incoterm-2:SCREEN-VALUE   IN FRAME {&FRAME-NAME} = ""
           i-cod-cond-pagto-2:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "0".

    IF  INT(i-pedido-dest:SCREEN-VALUE IN FRAME {&FRAME-NAME}) <> 0 THEN DO:
        FIND b-pedido-compr NO-LOCK WHERE 
             b-pedido-compr.num-pedido = INT(i-pedido-dest:SCREEN-VALUE IN FRAME {&FRAME-NAME}) NO-ERROR.
        IF NOT AVAIL b-pedido-compr THEN DO:
            MESSAGE "Pedido nÆo cadastrado"
                VIEW-AS ALERT-BOX INFO BUTTONS OK.

           RETURN NO-APPLY.
        END.

        DISP b-pedido-compr.cod-cond-pag @ i-cod-cond-pagto-2 WITH FRAME {&FRAME-NAME}.

        FIND cond-pagto NO-LOCK
            WHERE cond-pagto.cod-cond-pag = b-pedido-compr.cod-cond-pag NO-ERROR.
        IF  AVAIL cond-pagto
        THEN
            DISP cond-pagto.descricao @ v-des-pagto-2 WITH FRAME {&FRAME-NAME}.

        FIND emitente NO-LOCK WHERE emitente.cod-emitente = b-pedido-compr.cod-emitente no-error.
        ASSIGN c-fornecedor-2:SCREEN-VALUE IN FRAME {&FRAME-NAME} = emitente.nome-abrev
               c-comprador-2:SCREEN-VALUE IN FRAME {&FRAME-NAME} = b-pedido-compr.responsavel.

/*         IF c-fornecedor:SCREEN-VALUE IN FRAME {&FRAME-NAME} <>                               */
/*            c-fornecedor-2:SCREEN-VALUE IN FRAME {&FRAME-NAME} THEN DO:                       */
/*                                                                                              */
/*             MESSAGE "O fornecedor deste pedido ‚ diferente do fornecedor do pedido original" */
/*                 VIEW-AS ALERT-BOX INFO BUTTONS OK.                                           */
/*                                                                                              */
/*             ASSIGN c-fornecedor-2:SCREEN-VALUE     IN FRAME {&FRAME-NAME} = ""               */
/*                    c-comprador-2:SCREEN-VALUE      IN FRAME {&FRAME-NAME} = ""               */
/*                    c-itinerario-2:SCREEN-VALUE     IN FRAME {&FRAME-NAME} = ""               */
/*                    c-emb:SCREEN-VALUE              IN FRAME {&FRAME-NAME} = ""               */
/*                    data-entrega:SCREEN-VALUE       IN FRAME {&FRAME-NAME} = ""               */
/*                    c-base-2:SCREEN-VALUE           IN FRAME {&FRAME-NAME} = ""               */
/*                    c-incoterm-2:SCREEN-VALUE       IN FRAME {&FRAME-NAME} = ""               */
/*                    i-cod-cond-pagto-2:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "0".             */
/*                                                                                              */
/*            RETURN NO-APPLY.                                                                  */
/*         END.                                                                                 */

        FIND embarque-imp NO-LOCK
            WHERE embarque-imp.cod-estabel = b-pedido-compr.end-entrega
              AND embarque-imp.embarque    = i-pedido-dest:SCREEN-VALUE IN FRAME {&FRAME-NAME} NO-ERROR.
        
        IF  AVAIL embarque-imp
        THEN DO:
            DISP embarque-imp.cod-incoterm @ c-incoterm-2 WITH FRAME {&FRAME-NAME}.
            ASSIGN c-embarque = embarque-imp.embarque.
        
            FIND inco-cx NO-LOCK
                WHERE inco-cx.cod-incoterm = embarque-imp.cod-incoterm NO-ERROR.
            IF  AVAIL inco-cx
            THEN
                DISP inco-cx.descricao @ v-des-incoterm-2 WITH FRAME {&FRAME-NAME}.

            FIND FIRST processo-imp NO-LOCK
                 WHERE processo-imp.num-pedido = b-pedido-compr.num-pedido NO-ERROR.
            IF  AVAIL  processo-imp THEN DO:
                ASSIGN c-itinerario-2:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(processo-imp.cod-itiner).
           
                FIND itinerario NO-LOCK
                    WHERE itinerario.cod-itiner = processo-imp.cod-itiner NO-ERROR.
                IF  AVAIL itinerario THEN DO:
                    DISP itinerario.descricao @ v-des-itiner-2 WITH FRAME {&FRAME-NAME}.
                    FIND historico-embarque NO-LOCK
                      WHERE historico-embarque.cod-estabel = embarque-imp.cod-estabel
                        AND historico-embarque.embarque    = embarque-imp.embarque   
                        AND historico-embarque.cod-pto-contr = itinerario.pto-chegada no-error.
                    if avail historico-embarque 
                    then
                        ASSIGN da-data-entrega = historico-embarque.dt-ult-prev.
                END.
            END.
        END.

        RUN pi-define-embarque.

        /* Caso nÆo tenha encontrado Ordens para o Embarque, mant‚m o Ponto de Controle informado na cria‡Æo do Embarque */
        IF  c-base-2:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "" THEN DO:
            ASSIGN c-base-2:SCREEN-VALUE IN FRAME {&FRAME-NAME} = c-base.

            FIND FIRST pto-contr NO-LOCK
                WHERE  pto-contr.cod-pto-contr = INT(c-base) NO-ERROR.
            IF  AVAIL pto-contr THEN
                DISP pto-contr.descricao @ v-des-pto-2 WITH FRAME {&FRAME-NAME}.
        END.

        ASSIGN c-emb:SCREEN-VALUE        IN FRAME {&FRAME-NAME} = c-embarque
               data-entrega:SCREEN-VALUE IN FRAME {&FRAME-NAME} = string(da-data-entrega,"99/99/9999").
    END. /* IF  INT(i-pedido-dest:SCREEN-VALUE IN FRAME {&FRAME-NAME}) <> 0 */

    {&open-query-br-dest}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-vapara-ori
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-vapara-ori wWindow
ON CHOOSE OF bt-vapara-ori IN FRAME fpage0 /* Button 4 */
DO:
    ASSIGN c-fornecedor:SCREEN-VALUE     IN FRAME {&FRAME-NAME} = ""
           c-comprador:SCREEN-VALUE      IN FRAME {&FRAME-NAME} = ""
           c-itinerario:SCREEN-VALUE     IN FRAME {&FRAME-NAME} = ""
           c-emb-ori:SCREEN-VALUE        IN FRAME {&FRAME-NAME} = ""
           c-ponto-base:SCREEN-VALUE     IN FRAME {&FRAME-NAME} = ""
           c-incoterm-1:SCREEN-VALUE     IN FRAME {&FRAME-NAME} = ""
           v-des-pagto-1:SCREEN-VALUE    IN FRAME {&FRAME-NAME} = ""
           v-des-itiner-1:SCREEN-VALUE   IN FRAME {&FRAME-NAME} = ""
           v-des-pto-1:SCREEN-VALUE      IN FRAME {&FRAME-NAME} = ""
           v-des-incoterm-1:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
           i-cod-cond-pagto:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "0".

    IF  INT(i-pedido-ori:SCREEN-VALUE IN FRAME {&FRAME-NAME}) <> 0
    THEN DO:
        FIND pedido-compr NO-LOCK WHERE 
             pedido-compr.num-pedido = INT(i-pedido-ori:SCREEN-VALUE IN FRAME {&FRAME-NAME}) NO-ERROR.
        IF NOT AVAIL pedido-compr THEN DO:
            MESSAGE "Pedido nÆo cadastrado"
                VIEW-AS ALERT-BOX INFO BUTTONS OK.

            RETURN NO-APPLY.
        END.

        DISP pedido-compr.cod-cond-pag @ i-cod-cond-pagto WITH FRAME {&FRAME-NAME}.

        FIND cond-pagto NO-LOCK
            WHERE cond-pagto.cod-cond-pag = pedido-compr.cod-cond-pag NO-ERROR.
        IF  AVAIL cond-pagto
        THEN
            DISP cond-pagto.descricao @ v-des-pagto-1 WITH FRAME {&FRAME-NAME}.

        FIND emitente NO-LOCK WHERE emitente.cod-emitente = pedido-compr.cod-emitente NO-ERROR.
        ASSIGN c-fornecedor:SCREEN-VALUE IN FRAME {&FRAME-NAME} = emitente.nome-abrev
               c-comprador:SCREEN-VALUE IN FRAME {&FRAME-NAME} = pedido-compr.responsavel.

        FIND FIRST processo-imp NO-LOCK
             WHERE processo-imp.num-pedido = pedido-compr.num-pedido NO-ERROR.
        IF  AVAIL  processo-imp THEN DO:
            ASSIGN c-itinerario:SCREEN-VALUE IN FRAME {&FRAME-NAME} = string(processo-imp.cod-itiner).

            FIND itinerario NO-LOCK
                WHERE itinerario.cod-itiner = processo-imp.cod-itiner NO-ERROR.
            IF  AVAIL itinerario
            THEN
                DISP itinerario.descricao @ v-des-itiner-1 WITH FRAME {&FRAME-NAME}.
        END.

        bloco:
        FOR EACH bde-ordem-compra
           WHERE bde-ordem-compra.num-pedido = INT(i-pedido-ori:SCREEN-VALUE IN FRAME {&FRAME-NAME}) no-lock:

            FOR EACH ordens-embarque
               WHERE ordens-embarque.numero-ordem = bde-ordem-compra.numero-ordem no-lock:

                FIND FIRST bde-prazo-compra NO-LOCK
                     WHERE bde-prazo-compra.numero-ordem = bde-ordem-compra.numero-ordem
                       AND bde-prazo-compra.situacao = 2 NO-ERROR.
                IF AVAIL bde-prazo-compra THEN DO:
                    ASSIGN c-emb-ori:SCREEN-VALUE IN FRAME {&FRAME-NAME}  = ordens-embarque.embarque.

                    FIND embarque-imp NO-LOCK
                        WHERE embarque-imp.cod-estabel = pedido-compr.end-entrega
                          AND embarque-imp.embarque    = ordens-embarque.embarque NO-ERROR.

                    IF  AVAIL embarque-imp
                    THEN DO:
                        DISP embarque-imp.cod-incoterm @ c-incoterm-1 WITH FRAME {&FRAME-NAME}.
                        FIND inco-cx NO-LOCK
                            WHERE inco-cx.cod-incoterm = embarque-imp.cod-incoterm NO-ERROR.
                        IF  AVAIL inco-cx
                        THEN
                            DISP inco-cx.descricao @ v-des-incoterm-1 WITH FRAME {&FRAME-NAME}.
                    END.

                    FIND FIRST cotacao-item NO-LOCK
                        WHERE  cotacao-item.numero-ordem = bde-ordem-compra.numero-ordem NO-ERROR.

                    IF  AVAIL cotacao-item
                    THEN DO:
                        DISP TRIM(SUBSTR(cotacao-item.char-1,41,20)) @ c-ponto-base WITH FRAME {&FRAME-NAME}.
                        FIND pto-contr NO-LOCK
                            WHERE pto-contr.cod-pto-contr = INT(SUBSTR(cotacao-item.char-1,41,20)) NO-ERROR.
                        IF  AVAIL pto-contr
                        THEN
                            DISP pto-contr.descricao @ v-des-pto-1 WITH FRAME {&FRAME-NAME}.
                    END.


                    LEAVE bloco.       
                END.
            END.
        END.

        IF c-emb-ori:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "" THEN DO:
            ASSIGN bt-parcela:SENSITIVE      = NO
                   bt-parcial:SENSITIVE      = NO
                   bt-copia:SENSITIVE        = NO.
        END.
        ELSE DO:
            ASSIGN bt-parcela:SENSITIVE      = YES
                   bt-parcial:SENSITIVE      = YES
                   bt-copia:SENSITIVE        = YES.
        END.
    END. /* IF  INT(i-pedido-ori:SCREEN-VALUE IN FRAME {&FRAME-NAME}) <> 0 */


    {&open-query-br-ori}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wWindow
ON CHOOSE OF btExit IN FRAME fpage0 /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wWindow
ON CHOOSE OF btHelp IN FRAME fpage0 /* Help */
OR CHOOSE OF MENU-ITEM miContents IN MENU mbMain DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btQueryJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btQueryJoins wWindow
ON CHOOSE OF btQueryJoins IN FRAME fpage0 /* Query Joins */
OR CHOOSE OF MENU-ITEM miQueryJoins IN MENU mbMain DO:
    RUN showQueryJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btReportsJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReportsJoins wWindow
ON CHOOSE OF btReportsJoins IN FRAME fpage0 /* Reports Joins */
OR CHOOSE OF MENU-ITEM miReportsJoins IN MENU mbMain DO:
    RUN showReportsJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-pedido-dest
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-pedido-dest wWindow
ON LEAVE OF i-pedido-dest IN FRAME fpage0 /* Novo Pedido */
DO:
    APPLY "CHOOSE":U TO bt-vapara-dest.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-pedido-dest wWindow
ON RETURN OF i-pedido-dest IN FRAME fpage0 /* Novo Pedido */
DO:
    APPLY "choose" TO bt-vapara-dest IN FRAME {&FRAME-NAME}.   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-pedido-ori
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-pedido-ori wWindow
ON LEAVE OF i-pedido-ori IN FRAME fpage0 /* Pedido Origem */
DO:
    APPLY "choose" TO bt-vapara-ori IN FRAME {&FRAME-NAME}.   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-pedido-ori wWindow
ON RETURN OF i-pedido-ori IN FRAME fpage0 /* Pedido Origem */
DO:
    APPLY "choose" TO bt-vapara-ori IN FRAME {&FRAME-NAME}. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-dest
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{window/MainBlock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wWindow 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /**** Elimina o handle da bo de descri‡äes ****/
    if  valid-handle(h-boin295desc) then
        delete procedure h-boin295desc.
                         h-boin295desc = ?.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeInitializeInterface wWindow 
PROCEDURE beforeInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    if  not valid-handle(h-boin295desc) then do:
        run inbo/boin295desc.p persistent set h-boin295desc.
        run openQueryStatic in h-boin295desc ( input "Main":U ).
    end. 

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-pontos-especificos wWindow 
PROCEDURE pi-cria-pontos-especificos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
FIND FIRST ext-embarque-imp EXCLUSIVE-LOCK
     WHERE ext-embarque-imp.cod-estabel = tt-embarque-imp.cod-estabel
       AND ext-embarque-imp.embarque    = tt-embarque-imp.embarque 
     NO-ERROR.
IF  NOT AVAIL  ext-embarque-imp 
THEN DO:
   CREATE ext-embarque-imp.
   ASSIGN 
      ext-embarque-imp.cod-estabel = tt-embarque-imp.cod-estabel 
      ext-embarque-imp.embarque    = tt-embarque-imp.embarque.
END.

ASSIGN
   ext-embarque-imp.cdn-pto-chegada1   = int-itinerario.cdn-pto-chegada1 
   ext-embarque-imp.cdn-pto-chegada2   = int-itinerario.cdn-pto-chegada2 
   ext-embarque-imp.cdn-pto-embarque2  = int-itinerario.cdn-pto-embarque2 
   ext-embarque-imp.cdn-pto-emissao-nf = int-itinerario.cdn-pto-emissao-nf 
   ext-embarque-imp.cdn-pto-instrucao  = int-itinerario.cdn-pto-instrucao 
   ext-embarque-imp.cdn-pto-liberacao  = int-itinerario.cdn-pto-liberacao
   .

RELEASE ext-embarque-imp.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-relacto wWindow 
PROCEDURE pi-cria-relacto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param p-parc-orig as rowid                       no-undo.
def input param p-parc-dest as rowid                       no-undo.
def input param p-saldo-aux like prazo-compra.quant-saldo  no-undo.
def input param p-preco-aux like ordem-compra.preco-fornec no-undo.

def buffer bf-parc-orig for prazo-compra.
def buffer bf-parc-dest for prazo-compra.
def buffer bf-ord-orig  for ordem-compra.
def buffer bf-ord-dest  for ordem-compra.
def buffer bf-ped-orig  for pedido-compr.
def buffer bf-ped-dest  for pedido-compr.

for first bf-parc-orig FIELDS(numero-ordem parcela)
    where rowid(bf-parc-orig) = p-parc-orig
          no-lock: end.

for first bf-parc-dest FIELDS(numero-ordem parcela quant-saldo)
    where rowid(bf-parc-dest) = p-parc-dest
          no-lock: end.

for first bf-ord-orig FIELDS(num-pedido cod-cond-pag)
    where bf-ord-orig.numero-ordem = bf-parc-orig.numero-ordem
          no-lock: end.

for first bf-ord-dest FIELDS(num-pedido)
    where bf-ord-dest.numero-ordem = bf-parc-dest.numero-ordem
          no-lock: end.

for first bf-ped-orig FIELDS(via-transp)
    where bf-ped-orig.num-pedido = bf-ord-orig.num-pedido
          no-lock: end.

for first bf-ped-dest FIELDS(via-transp comentarios)
    where bf-ped-dest.num-pedido = bf-ord-dest.num-pedido
          no-lock: end.

if can-find(first int-rel-ped-import where
                  int-rel-ped-import.num-pedido-orig   = bf-ord-orig.num-pedido
              and int-rel-ped-import.numero-ordem-orig = bf-parc-orig.numero-ordem
              and int-rel-ped-import.parcela-orig      = bf-parc-orig.parcela
              and int-rel-ped-import.num-pedido-dest   = bf-ord-dest.num-pedido
              and int-rel-ped-import.numero-ordem-dest = bf-parc-dest.numero-ordem
              and int-rel-ped-import.parcela-dest      = bf-parc-dest.parcela
                  no-lock)
then return "OK".

create int-rel-ped-import.
assign int-rel-ped-import.num-pedido-orig   = bf-ord-orig.num-pedido   
       int-rel-ped-import.numero-ordem-orig = bf-parc-orig.numero-ordem 
       int-rel-ped-import.parcela-orig      = bf-parc-orig.parcela
       int-rel-ped-import.cod-cond-pag-orig = bf-ord-orig.cod-cond-pag
       int-rel-ped-import.via-transp-orig   = bf-ped-orig.via-transp
       int-rel-ped-import.quant-saldo-orig  = p-saldo-aux
       int-rel-ped-import.preco-fornec-orig = p-preco-aux
       int-rel-ped-import.num-pedido-dest   = bf-ord-dest.num-pedido   
       int-rel-ped-import.numero-ordem-dest = bf-parc-dest.numero-ordem 
       int-rel-ped-import.parcela-dest      = bf-parc-dest.parcela
       int-rel-ped-import.via-transp-dest   = bf-ped-dest.via-transp
       int-rel-ped-import.quant-saldo-dest  = bf-parc-dest.quant-saldo
       int-rel-ped-import.comentarios       = bf-ped-dest.comentarios.
find current int-rel-ped-import no-lock no-error.

return "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-define-embarque wWindow 
PROCEDURE pi-define-embarque :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    bloco:
    FOR EACH bde-ordem-compra
         WHERE bde-ordem-compra.num-pedido = INT(i-pedido-dest:SCREEN-VALUE IN FRAME {&FRAME-NAME}) no-lock:
          FIND first bde-cotacao-item
               WHERE bde-cotacao-item.numero-ordem = bde-ordem-compra.numero-ordem
                 AND bde-cotacao-item.cot-aprovada no-lock no-error.
          if avail bde-cotacao-item then        
              ASSIGN c-base = substr(bde-cotacao-item.char-1,41,20).

          FOR EACH ordens-embarque
             WHERE ordens-embarque.numero-ordem = bde-ordem-compra.numero-ordem no-lock:         
              FIND FIRST bde-prazo-compra NO-LOCK
                   WHERE bde-prazo-compra.numero-ordem = bde-ordem-compra.numero-ordem
                     AND bde-prazo-compra.situacao = 2 NO-ERROR.
              IF AVAIL bde-prazo-compra THEN DO:
                  ASSIGN c-embarque = ordens-embarque.embarque.

                  FIND embarque-imp NO-LOCK
                      WHERE embarque-imp.cod-estabel = b-pedido-compr.end-entrega
                        AND embarque-imp.embarque    = ordens-embarque.embarque NO-ERROR.

                  IF  AVAIL embarque-imp
                  THEN DO:
                      DISP embarque-imp.cod-incoterm @ c-incoterm-2 WITH FRAME {&FRAME-NAME}.

                      FIND inco-cx NO-LOCK
                          WHERE inco-cx.cod-incoterm = embarque-imp.cod-incoterm NO-ERROR.
                      IF  AVAIL inco-cx
                      THEN
                          DISP inco-cx.descricao @ v-des-incoterm-2 WITH FRAME {&FRAME-NAME}.
                  END.

                  FIND FIRST cotacao-item NO-LOCK
                      WHERE  cotacao-item.numero-ordem = bde-ordem-compra.numero-ordem NO-ERROR.

                  IF  AVAIL cotacao-item
                  THEN DO:

                      DISP TRIM(SUBSTR(cotacao-item.char-1,41,20)) @ c-base-2 WITH FRAME {&FRAME-NAME}.
                      FIND pto-contr NO-LOCK
                          WHERE pto-contr.cod-pto-contr = INT(SUBSTR(cotacao-item.char-1,41,20)) NO-ERROR.
                      IF  AVAIL pto-contr
                      THEN
                          DISP pto-contr.descricao @ v-des-pto-2 WITH FRAME {&FRAME-NAME}.
                  END.
                  LEAVE bloco.       
              END.
          END.
    END.

    IF c-embarque = "" THEN LEAVE.
   
    FIND itinerario NO-LOCK WHERE 
         itinerario.cod-itiner = int(c-itinerario-2:SCREEN-VALUE IN FRAME {&frame-name}) no-error.   
    if not avail itinerario then return "ok".
    
    FIND historico-embarque NO-LOCK
      WHERE historico-embarque.cod-estabel   = b-pedido-compr.cod-estabel
        AND historico-embarque.embarque      = c-embarque
        AND historico-embarque.cod-pto-contr = itinerario.pto-chegada no-error.
    if not avail historico-embarque then return "ok".
   
    ASSIGN da-data-entrega = historico-embarque.dt-ult-prev.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-des-sit-embarque wWindow 
FUNCTION fn-des-sit-embarque RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    IF  AVAIL ordens-embarque
    THEN DO:
        FIND embarque-imp NO-LOCK
           WHERE embarque-imp.cod-estabel = ordens-embarque.cod-estabel
             AND embarque-imp.embarque    = ordens-embarque.embarque NO-ERROR.

        IF  AVAIL embarque-imp
        THEN DO:
            {esp/imp/esimp000.i}
            FIND FIRST tt-emb NO-ERROR.
            IF NOT AVAIL tt-emb THEN DO:
               ASSIGN v-des-sit-emb = "Ped".
            END.
            ELSE DO:
               CASE tt-emb.situacao:
                   WHEN 99 THEN ASSIGN v-des-sit-emb = "Agt".
                   WHEN 1  THEN ASSIGN v-des-sit-emb = "Prev".
                   WHEN 2  THEN ASSIGN v-des-sit-emb = "Embar".
                   WHEN 98 THEN ASSIGN v-des-sit-emb = "DI".
                   WHEN 3  THEN ASSIGN v-des-sit-emb = "Desp".
                   WHEN 4  THEN ASSIGN v-des-sit-emb = "NF".
                   WHEN 96  THEN ASSIGN v-des-sit-emb = "Inst".
                   WHEN 97  THEN ASSIGN v-des-sit-emb = "Manut".
               END CASE.
            END.
        END. /* IF  AVAIL embarque-imp */
    END. /* IF  AVAIL ordens-embarque */
    ELSE
        ASSIGN v-des-sit-emb = "Ped".

    RETURN v-des-sit-emb.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

