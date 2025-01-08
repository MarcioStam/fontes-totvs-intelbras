&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgmov            PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttcond-especif NO-UNDO LIKE cond-especif
       field r-rowid as rowid.
DEFINE TEMP-TABLE ttcotacao-item NO-UNDO LIKE cotacao-item
       field r-rowid as rowid.
DEFINE TEMP-TABLE ttpedido-compr NO-UNDO LIKE pedido-compr
       field r-rowid as rowid
       field rownum as int.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMaintenanceNoNavigation 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)]
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESCCP015B 1.00.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           ESCCP015B
&GLOBAL-DEFINE Version           1.00.00.000

&GLOBAL-DEFINE Folder            YES
&GLOBAL-DEFINE InitialPage       1

&GLOBAL-DEFINE FolderLabels      Dados,Narrativa

&GLOBAL-DEFINE ttTable           ttpedido-compr
&GLOBAL-DEFINE hDBOTable         hboin295
&GLOBAL-DEFINE DBOTable          pedido-compr

&GLOBAL-DEFINE ttParent          
&GLOBAL-DEFINE DBOParentTable    

&GLOBAL-DEFINE page0KeyFields    
&GLOBAL-DEFINE page0Fields       ttpedido-compr.cod-emitente ttpedido-compr.num-pedido ~
                                 ttpedido-compr.impr-pedido ttpedido-compr.data-pedido ~
                                 v-dat-entrega tg-proc-imp tg-gera-emb fi-cod-estab c-desc-estab 
&GLOBAL-DEFINE page0ParentFields 
&GLOBAL-DEFINE page1Fields       cb-frete cb-via-transp ttpedido-compr.cod-cond-pag ~
                                 ttpedido-compr.cod-mensagem ttpedido-compr.cod-transp ~
                                 ttpedido-compr.responsavel fi-cod-comprado ~
                                 fi-requisitante fi-mo-codigo fi-tp-despesa v-cod-itiner-pad v-cod-incoterm v-cod-pto-contr c-dep-almox c-desc-deposito
&GLOBAL-DEFINE page2Fields       ttpedido-compr.comentarios

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
/* DEFINE INPUT PARAMETER prParent        AS ROWID     NO-UNDO. */
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER c-tipo-evento   AS CHARACTER NO-UNDO.
/* DEFINE INPUT PARAMETER piSonPageNumber AS INTEGER   NO-UNDO. */
/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable}  AS HANDLE NO-UNDO.
def var h-acomp      as handle no-undo.
def var hboin295desc as handle no-undo.
def var hboin057 as handle no-undo.
def var hboin274sd as handle no-undo.
def var hboin082sd as handle no-undo.
def var hboin356ca as handle no-undo.
def var hboin082ca as handle no-undo.
DEF VAR h-bocx341  AS HANDLE NO-UNDO.
DEF VAR h-bocx225  AS HANDLE NO-UNDO.
def var i-num-pedido            like pedido-compr.num-pedido no-undo.
/* def var h-bocx155  as handle  no-undo. */
/* DEF VAR hDBOOrdem-compra as handle no-undo. */
/* DEF VAR hDBOParam-imp    AS HANDLE NO-UNDO. */
def var hDBOCotacao-itemi as handle no-undo.
def var c-nom-emit          as char no-undo.
def var c-cgc-emit          as char no-undo.
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
DEFINE VARIABLE wh-pesquisa AS HANDLE NO-UNDO.
def var c-desc-cond-pag     as char no-undo.
def var c-desc-responsavel  as char no-undo.
def var c-desc-mensagem     as char no-undo.
def var c-desc-transp       as char no-undo.
def var i-via-transp        as int  no-undo.
def var i-emit-terc         as int  no-undo.
def var i-cod-transp        as int  no-undo.
def var i-cod-cond-pag      as int  no-undo.
def var c-desp              as char no-undo.
DEF VAR v-log-amostra       AS  LOG NO-UNDO.
DEF VAR v-cod-produto       AS CHAR NO-UNDO.
DEF VAR v-cod-emitente      AS  INT NO-UNDO.
DEF VAR v-log-desfaz        AS  LOG NO-UNDO.
DEF VAR v-qtd-pedido        AS  DEC NO-UNDO.
DEF VAR v-log-ckd           AS  LOG NO-UNDO.
DEF VAR v-log-hml           AS  LOG NO-UNDO.
def var i-informa           as integer no-undo.
DEF VAR  c-cod-estabel      AS CHAR INIT "" NO-UNDO.
DEF VAR c-return            AS CHAR NO-UNDO.
DEF VAR c-return-emit-cex   AS CHAR NO-UNDO.
DEF VAR c-return-incoterm   AS CHAR NO-UNDO.
DEF VAR i-cod-itinerario    AS INT NO-UNDO.
DEFINE VARIABLE c-pedidos-gerados AS CHARACTER   NO-UNDO.

DEF VAR v-cod-incoterm-tmp LIKE emitente-cex.cod-incoterm-imp  NO-UNDO.
DEF VAR v-cod-itiner-tmp   LIKE emitente-cex.cod-itiner-imp    NO-UNDO.

&GLOBAL-DEFINE ExcludeBtSave      YES

{upc/btb910za-upc.i}
def shared var s-it-codigo like item.it-codigo no-undo.
def shared var s-l-ok as logi no-undo.
{esp/ccp/esccp015tt.i}
{cdp/cdcfgmat.i}
{ccp/ccapi202.i}
{ccp/ccapi207.i}   
{cdp/cdapi300.i1}
{cdp/cd4300.i3}

DEFINE TEMP-TABLE ttcotacao-imp NO-UNDO
    FIELD numero-ordem   like cotacao-item.numero-ordem
    FIELD cod-emitente   like cotacao-item.cod-emitente 
    FIELD it-codigo      like cotacao-item.it-codigo
    FIELD seq-cotac      like cotacao-item.seq-cotac
    FIELD mapa-cotacao   like cotacao-item-cex.mapa-cotacao
    FIELD cod-incoterm   like inco-cx.cod-incoterm
    FIELD cod-pto-contr  like pto-contr.cod-pto-contr
    FIELD cod-fabricante like emitente.cod-emitente
    FIELD regime-import  like pais-aliquota.regime-import
    FIELD class-fiscal   like classif-fisc.class-fiscal
    FIELD aliq-ii        as   decimal format ">>9.99"
    FIELD aliq-ipi       as   decimal format ">>9.99"
    FIELD cod-itiner     like itinerario.cod-itiner
    FIELD i-informa      AS   INTEGER
    FIELD da-entrega-embarque AS DATE
    FIELD r-Rowid AS ROWID.

DEFINE TEMP-TABLE tt-processo-imp NO-UNDO LIKE mgcex.processo-imp
    FIELD r-rowid AS ROWID.

DEFINE TEMP-TABLE tt-ordem NO-UNDO
    FIELD num-ordem AS INTEGER.

DEFINE BUFFER b-ordem-compra FOR ordem-compra.
DEFINE BUFFER b-cotacao-item FOR cotacao-item.
DEFINE BUFFER b-pedido-compr FOR pedido-compr.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MaintenanceNoNavigation
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ttpedido-compr.data-pedido ~
ttpedido-compr.cod-emitente ttpedido-compr.impr-pedido 
&Scoped-define ENABLED-TABLES ttpedido-compr
&Scoped-define FIRST-ENABLED-TABLE ttpedido-compr
&Scoped-Define ENABLED-OBJECTS v-dat-entrega c-nome-fornec c-cgc ~
tg-proc-imp tg-gera-emb btOK btCancel btHelp bt-pedido fi-cod-estab rtKeys ~
rtToolBar 
&Scoped-Define DISPLAYED-FIELDS ttpedido-compr.num-pedido ~
ttpedido-compr.data-pedido ttpedido-compr.cod-emitente ~
ttpedido-compr.impr-pedido 
&Scoped-define DISPLAYED-TABLES ttpedido-compr
&Scoped-define FIRST-DISPLAYED-TABLE ttpedido-compr
&Scoped-Define DISPLAYED-OBJECTS v-dat-entrega c-nome-fornec c-cgc ~
tg-proc-imp tg-gera-emb fi-cod-estab c-desc-estab 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wMaintenanceNoNavigation AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE MENU POPUP-MENU-cod-emitente 
       MENU-ITEM m_Zoom_FornecAmbos_com_Ordens LABEL "Zoom Fornec/Ambos com Ordens Cotadas"
       MENU-ITEM m_Zoom_Fornecedor_do_Pedido_d LABEL "Zoom Fornecedor do Pedido de Compra".


/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-pedido 
     IMAGE-UP FILE "image\im-enter.bmp":U
     LABEL "Pedido" 
     SIZE 4 BY .88 TOOLTIP "Localizar pedido conforme n£mero informado".

DEFINE BUTTON btCancel 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE VARIABLE c-cgc AS CHARACTER FORMAT "X(19)":U 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-estab AS CHARACTER FORMAT "X(25)":U 
     VIEW-AS FILL-IN 
     SIZE 39.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-fornec AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 35 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-estab AS CHARACTER FORMAT "X(3)" INITIAL "105" 
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE v-dat-entrega AS DATE FORMAT "99/99/9999":U 
     LABEL "Entrega" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 3.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE tg-gera-emb AS LOGICAL INITIAL yes 
     LABEL "Gera Embarque" 
     VIEW-AS TOGGLE-BOX
     SIZE 15 BY .83 NO-UNDO.

DEFINE VARIABLE tg-proc-imp AS LOGICAL INITIAL yes 
     LABEL "Gera Processo Importa‡Æo" 
     VIEW-AS TOGGLE-BOX
     SIZE 21 BY .83 NO-UNDO.

DEFINE VARIABLE cb-frete AS CHARACTER FORMAT "X(20)" 
     LABEL "Frete":R7 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 19 BY 1 NO-UNDO.

DEFINE VARIABLE cb-via-transp AS CHARACTER FORMAT "X(20)" 
     LABEL "Via Transporte":R17 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE c-cond-pagto AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 37 BY .88 NO-UNDO.

DEFINE VARIABLE c-dep-almox AS CHARACTER FORMAT "X(3)":U 
     LABEL "Deposito" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-deposito AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 39.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-desp AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 39.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-mensagem AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 39.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-responsavel AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 34.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-transp AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 32 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-comprado AS CHARACTER FORMAT "X(12)" 
     LABEL "Comprador":R11 
     VIEW-AS FILL-IN 
     SIZE 16.43 BY .88 NO-UNDO.

DEFINE VARIABLE fi-mo-codigo AS INTEGER FORMAT ">9" INITIAL 0 
     LABEL "Moeda":R7 
     VIEW-AS FILL-IN 
     SIZE 3.72 BY .88 NO-UNDO.

DEFINE VARIABLE fi-moeda AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 20.57 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nome-comprador AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 46.43 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nome-requisitante AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 46.29 BY .88 NO-UNDO.

DEFINE VARIABLE fi-requisitante AS CHARACTER FORMAT "X(12)" 
     LABEL "Requisitante":R15 
     VIEW-AS FILL-IN 
     SIZE 16.43 BY .88 NO-UNDO.

DEFINE VARIABLE fi-tp-despesa AS INTEGER FORMAT ">>9" INITIAL 0 
     LABEL "Tipo Despesa":R15 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE v-cod-incoterm AS CHARACTER FORMAT "X(3)":U 
     LABEL "Incoterm" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE v-cod-itiner-pad AS INTEGER FORMAT ">>,>>9":U INITIAL 0 
     LABEL "Itiner rio" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE v-cod-pto-contr AS INTEGER FORMAT ">>,>>9":U INITIAL 0 
     LABEL "Pto Contr" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     ttpedido-compr.num-pedido AT ROW 1.17 COL 20 COLON-ALIGNED WIDGET-ID 10
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     ttpedido-compr.data-pedido AT ROW 1.17 COL 50 COLON-ALIGNED WIDGET-ID 8
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     v-dat-entrega AT ROW 1.17 COL 71 COLON-ALIGNED WIDGET-ID 28
     ttpedido-compr.cod-emitente AT ROW 2.17 COL 20 COLON-ALIGNED WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     c-nome-fornec AT ROW 2.17 COL 30 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     c-cgc AT ROW 2.17 COL 65 COLON-ALIGNED NO-LABEL WIDGET-ID 2
     ttpedido-compr.impr-pedido AT ROW 4.5 COL 32 WIDGET-ID 12
          VIEW-AS TOGGLE-BOX
          SIZE 13 BY .83
     tg-proc-imp AT ROW 4.5 COL 46 WIDGET-ID 22
     tg-gera-emb AT ROW 4.5 COL 68 WIDGET-ID 24
     btOK AT ROW 17.63 COL 2
     btCancel AT ROW 17.63 COL 12.72
     btHelp AT ROW 17.63 COL 80
     bt-pedido AT ROW 1.17 COL 32 WIDGET-ID 64
     fi-cod-estab AT ROW 3.17 COL 20 COLON-ALIGNED WIDGET-ID 34
     c-desc-estab AT ROW 3.17 COL 27.14 NO-LABEL WIDGET-ID 32
     rtKeys AT ROW 1 COL 1
     rtToolBar AT ROW 17.38 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17.92
         FONT 1.

DEFINE FRAME fPage1
     cb-frete AT ROW 1.17 COL 16 COLON-ALIGNED HELP
          "Informe se o Frete ² Pago ou a Pagar" WIDGET-ID 10
     cb-via-transp AT ROW 1.17 COL 83.72 RIGHT-ALIGNED HELP
          "Via Transporte" WIDGET-ID 14
     ttpedido-compr.cod-transp AT ROW 2.17 COL 16 COLON-ALIGNED WIDGET-ID 20
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     c-transp AT ROW 2.17 COL 28.43 NO-LABEL WIDGET-ID 8
     v-cod-itiner-pad AT ROW 2.25 COL 66.86 COLON-ALIGNED WIDGET-ID 44
     fi-mo-codigo AT ROW 3.17 COL 16 COLON-ALIGNED WIDGET-ID 38
     fi-moeda AT ROW 3.17 COL 20.14 COLON-ALIGNED NO-LABEL WIDGET-ID 36
     v-cod-pto-contr AT ROW 3.25 COL 66.86 COLON-ALIGNED WIDGET-ID 46
     ttpedido-compr.cod-cond-pag AT ROW 4.17 COL 16 COLON-ALIGNED WIDGET-ID 16
          LABEL "Condi‡Æo Pagto"
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     c-cond-pagto AT ROW 4.17 COL 23.29 NO-LABEL WIDGET-ID 2
     v-cod-incoterm AT ROW 4.25 COL 66.86 COLON-ALIGNED WIDGET-ID 48
     ttpedido-compr.responsavel AT ROW 5.17 COL 16 COLON-ALIGNED WIDGET-ID 22
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     c-responsavel AT ROW 5.17 COL 28.43 NO-LABEL WIDGET-ID 6
     ttpedido-compr.cod-mensagem AT ROW 6.17 COL 16 COLON-ALIGNED WIDGET-ID 18
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     c-mensagem AT ROW 6.17 COL 23.43 NO-LABEL WIDGET-ID 4
     fi-requisitante AT ROW 7.17 COL 16 COLON-ALIGNED WIDGET-ID 30
     fi-nome-requisitante AT ROW 7.17 COL 34.86 NO-LABEL WIDGET-ID 28
     fi-cod-comprado AT ROW 8.17 COL 16 COLON-ALIGNED WIDGET-ID 24
     fi-nome-comprador AT ROW 8.17 COL 34.86 NO-LABEL WIDGET-ID 26
     fi-tp-despesa AT ROW 9.17 COL 16 COLON-ALIGNED WIDGET-ID 42
     c-desc-desp AT ROW 9.17 COL 23.43 NO-LABEL WIDGET-ID 40
     c-dep-almox AT ROW 10.17 COL 16 COLON-ALIGNED WIDGET-ID 50
     c-desc-deposito AT ROW 10.17 COL 23.43 NO-LABEL WIDGET-ID 52
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 5.71
         SIZE 84.43 BY 10.79
         FONT 1.

DEFINE FRAME fPage2
     ttpedido-compr.comentarios AT ROW 2.08 COL 14.57 NO-LABEL WIDGET-ID 2
          VIEW-AS EDITOR SCROLLBAR-VERTICAL
          SIZE 60.57 BY 8.13
     "Comentÿrios:" VIEW-AS TEXT
          SIZE 9 BY .88 AT ROW 1.79 COL 5.43 WIDGET-ID 4
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 5.71
         SIZE 84.43 BY 11.29
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MaintenanceNoNavigation Template
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: ttcond-especif T "?" NO-UNDO mgmov cond-especif
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: ttcotacao-item T "?" NO-UNDO mgmov cotacao-item
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
  CREATE WINDOW wMaintenanceNoNavigation ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 17.92
         WIDTH              = 90
         MAX-HEIGHT         = 28.75
         MAX-WIDTH          = 195.14
         VIRTUAL-HEIGHT     = 28.75
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
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wMaintenanceNoNavigation 
/* ************************* Included-Libraries *********************** */

{maintenancenonavigation/maintenancenonavigation.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wMaintenanceNoNavigation
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE
       FRAME fPage2:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME Custom                                                    */

DEFINE VARIABLE XXTABVALXX AS LOGICAL NO-UNDO.

ASSIGN XXTABVALXX = FRAME fPage2:MOVE-BEFORE-TAB-ITEM (ttpedido-compr.num-pedido:HANDLE IN FRAME fpage0)
/* END-ASSIGN-TABS */.

/* SETTINGS FOR FILL-IN c-desc-estab IN FRAME fpage0
   NO-ENABLE ALIGN-L                                                    */
ASSIGN 
       ttpedido-compr.cod-emitente:POPUP-MENU IN FRAME fpage0       = MENU POPUP-MENU-cod-emitente:HANDLE.

/* SETTINGS FOR FILL-IN ttpedido-compr.num-pedido IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FRAME fPage1
   Custom                                                               */
/* SETTINGS FOR FILL-IN c-cond-pagto IN FRAME fPage1
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN c-desc-deposito IN FRAME fPage1
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN c-desc-desp IN FRAME fPage1
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN c-mensagem IN FRAME fPage1
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN c-responsavel IN FRAME fPage1
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN c-transp IN FRAME fPage1
   ALIGN-L                                                              */
/* SETTINGS FOR COMBO-BOX cb-via-transp IN FRAME fPage1
   ALIGN-R                                                              */
/* SETTINGS FOR FILL-IN ttpedido-compr.cod-cond-pag IN FRAME fPage1
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN fi-moeda IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-nome-comprador IN FRAME fPage1
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN fi-nome-requisitante IN FRAME fPage1
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FRAME fPage2
                                                                        */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMaintenanceNoNavigation)
THEN wMaintenanceNoNavigation:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

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

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wMaintenanceNoNavigation
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenanceNoNavigation wMaintenanceNoNavigation
ON END-ERROR OF wMaintenanceNoNavigation
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenanceNoNavigation wMaintenanceNoNavigation
ON WINDOW-CLOSE OF wMaintenanceNoNavigation
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  /*RETURN NO-APPLY.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-pedido
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-pedido wMaintenanceNoNavigation
ON CHOOSE OF bt-pedido IN FRAME fpage0 /* Pedido */
DO:

    FIND pedido-compr NO-LOCK
        WHERE pedido-compr.num-pedido = INPUT FRAME fpage0 ttpedido-compr.num-pedido NO-ERROR.

    IF  NOT AVAIL pedido-compr THEN DO:

        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 17006,
                           INPUT "Pedido de compras nÆo encontrado com o n£mero informado.").
        ASSIGN ttpedido-compr.cod-emitente = 0.
        DISPLAY ttpedido-compr.cod-emitente WITH FRAME fpage0.
        APPLY "LEAVE" TO ttpedido-compr.cod-emitente IN FRAME fpage0.
        APPLY "ENTRY" TO ttpedido-compr.num-pedido IN FRAME fpage0.
        RETURN NO-APPLY.
    END.
    ELSE DO:

        IF pedido-compr.situacao = 3 THEN DO: /* 1-impresso , 2-nao impresso , 3-eliminado  */

            RUN utp/ut-msgs.p (INPUT "show",
                               INPUT 17006,
                                INPUT 'Pedido com situacao eliminado.~~Somente e permitido informar pedidos com a situacao impresso e nao impresso.').

        END.
           

        FIND FIRST emitente WHERE
                  emitente.cod-emitente = pedido-compr.cod-emitente NO-LOCK NO-ERROR.
        IF AVAIL   emitente THEN DO:

           IF emitente.natureza <= 2 THEN DO:

                RUN utp/ut-msgs.p (INPUT "show",
                                   INPUT 17006,
                                   INPUT 'Pedido nao permitido ser informado.~~Informe um pedido com fornecedor estrangeiro.').
                RETURN NO-APPLY.
           END.

           /*IF emitente.natureza = 3 OR  emitente.natureza = 4)  Estrangeiro */
        END.
        
        assign fi-cod-estab:screen-value in frame fpage0 = pedido-compr.cod-estabel. 
        apply "LEAVE":U to fi-cod-estab in frame fPage0.


        EMPTY TEMP-TABLE ttpedido-compr.
        CREATE ttpedido-compr.
        ASSIGN ttpedido-compr.num-pedido   = INPUT FRAME fpage0 ttpedido-compr.num-pedido
               ttpedido-compr.cod-emitente = pedido-compr.cod-emitente
               ttpedido-compr.data-pedido  = pedido-compr.data-pedido 
               ttpedido-compr.cod-cond-pag = pedido-compr.cod-cond-pag
               ttpedido-compr.cod-transp   = pedido-compr.cod-transp
               ttpedido-compr.comentarios  = pedido-compr.comentarios + CHR(13) + CHR(13).

        DISPLAY ttpedido-compr.cod-emitente WITH FRAME fpage0.
        
        APPLY "LEAVE" TO ttpedido-compr.cod-emitente IN FRAME fpage0.

 

        FIND ITEM NO-LOCK 
            WHERE ITEM.it-codigo = v-cod-produto NO-ERROR.
    
        /*IF  AVAIL ITEM
        THEN DO:
        
            FIND item-fornec-estab NO-LOCK
                WHERE item-fornec-estab.it-codigo    = v-cod-produto
                  AND item-fornec-estab.cod-emitente = v-cod-emitente
                  AND item-fornec-estab.cod-estabel  = fi-cod-estab NO-ERROR.
    
            IF  AVAIL item-fornec-estab
            THEN DO:
                ASSIGN v-dat-entrega = TODAY + item-fornec-estab.tempo-ressup.
                FIND item-fabric NO-LOCK
                    WHERE item-fabric.it-codigo  = item-fornec-estab.it-codigo
                      AND ITEM-fabric.cod-fabric = INT(item-fornec-estab.item-do-for) NO-ERROR.
    
                IF  AVAIL item-fabric
                THEN
                    ASSIGN ttpedido-compr.comentarios = ttpedido-compr.comentarios  + "Product: " + v-cod-produto + " - " + item.desc-item + CHR(13) + CHR(13) + "P/N.: " + item-fabric.it-fabric  + CHR(13) + CHR(13) + "Quantity: " + STRING(INT(v-qtd-pedido)).
                ELSE
                    ASSIGN ttpedido-compr.comentarios = ttpedido-compr.comentarios  + "Product: " + v-cod-produto + " - " + item.desc-item + CHR(13) + CHR(13) + "Quantity: " + STRING(INT(v-qtd-pedido)).
            END.
            ELSE
                ASSIGN ttpedido-compr.comentarios = ttpedido-compr.comentarios  + "Product: " + v-cod-produto + " - " + item.desc-item + CHR(13) + CHR(13) + "Quantity: " + STRING(INT(v-qtd-pedido)).
        END.*/

        DISPLAY ttpedido-compr.comentarios WITH FRAME fpage2.


    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wMaintenanceNoNavigation
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancelar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wMaintenanceNoNavigation
ON CHOOSE OF btHelp IN FRAME fpage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wMaintenanceNoNavigation
ON LEAVE OF btHelp IN FRAME fpage0 /* Ajuda */
DO:
    APPLY "entry" TO ttpedido-compr.num-pedido IN FRAME fpage0.
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wMaintenanceNoNavigation
ON CHOOSE OF btOK IN FRAME fpage0 /* OK */
DO:

   IF NOT AVAIL ttpedido-compr THEN DO:

      RUN utp/ut-msgs.p (INPUT "show",
                         INPUT 17006,
                         INPUT "Selecione o botao pedido para atualizar as informacoes da tela.~~Esta rotina atualiza as informacoes do pedido.").
      RETURN NO-APPLY.
   END.
   ELSE DO:

      /*IF ttpedido-compr.num-pedido <> INPUT FRAME fpage0 ttpedido-compr.num-pedido THEN DO:

         RUN utp/ut-msgs.p (INPUT "show",
                            INPUT 17006,
                            INPUT "Selecione o botao pedido para atualizar as informacoes da tela.~~Esta rotina atualiza as informacoes do pedido").
         RETURN NO-APPLY.

      END.*/
   END.

   
   IF INPUT FRAME fpage0 ttpedido-compr.num-pedido <> "" THEN DO:
    
      ASSIGN v-dat-entrega     = INPUT FRAME fpage0 v-dat-entrega
             tg-proc-imp       = INPUT FRAME fpage0 tg-proc-imp
             tg-gera-emb       = INPUT FRAME fpage0 tg-gera-emb
             v-cod-itiner-pad  = INPUT FRAME fpage1 v-cod-itiner-pad
             v-cod-pto-contr   = INPUT FRAME fpage1 v-cod-pto-contr
             v-cod-incoterm    = INPUT FRAME fpage1 v-cod-incoterm
             fi-tp-despesa     = INPUT FRAME fpage1 fi-tp-despesa.
    
      IF  c-tipo-evento = "GerarPedido" THEN DO:

          ASSIGN ttpedido-compr.cod-emitente = INPUT FRAME fpage0 ttpedido-compr.cod-emitente.
      
          IF  v-dat-entrega = ? OR 
              v-dat-entrega < TODAY THEN DO:

              RUN utp\ut-msgs.p (INPUT "show",
                                 INPUT 17006,
                                 INPUT "Data de entrega invÿlida.").
      
              APPLY "ENTRY" TO v-dat-entrega IN FRAME fpage0.
              RETURN NO-APPLY.
          END.

/*           run piValida. */

/*           s-l-ok = RETURN-VALUE = "OK":U. */

          
          

          run piSave.
  
          if RETURN-VALUE = "OK":U 
          THEN DO:
              IF  ttpedido-compr.impr-pedido = YES AND
                  tg-proc-imp                = NO  AND 
                  tg-gera-emb                = NO 
              THEN
                  RUN utp/ut-msgs.p (INPUT "show",
                                     INPUT 15825,
                                     INPUT "Execu‡Æo Finalizada.~~Foram gerados os pedidos: " + c-pedidos-gerados).
  
              IF  ttpedido-compr.impr-pedido = YES AND
                  tg-proc-imp                = YES AND 
                  tg-gera-emb                = NO 
              THEN
                  RUN utp/ut-msgs.p (INPUT "show",
                                     INPUT 15825,
                                     INPUT "Execu‡Æo Finalizada.~~Foram gerados os pedidos e processos de importa‡Æo " + c-pedidos-gerados).
  
              IF  ttpedido-compr.impr-pedido = YES AND
                  tg-proc-imp                = YES AND 
                  tg-gera-emb                = YES 
              THEN
                  RUN utp/ut-msgs.p (INPUT "show",
                                     INPUT 15825,
                                     INPUT "Execu‡Æo Finalizada.~~Foram gerados os pedidos, processos de importa‡Æo e embarques " + c-pedidos-gerados).
  
              APPLY "CLOSE":U TO THIS-PROCEDURE.
          END.
          ELSE DO:
              RUN utp/ut-msgs.p (INPUT "show",
                                 INPUT 17006,
                                 INPUT "Execu‡Æo Interrompida.~~Os erros ocorridos impediram a gera‡Æo do pedido.").
              ASSIGN s-l-ok = no.
          END.
      END. 
   END.
   ELSE DO:

        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 17006,
                           INPUT "Pedido de compras n’o encontrado com o nœmero informado.").
    
        RETURN NO-APPLY.
   END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME c-dep-almox
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-dep-almox wMaintenanceNoNavigation
ON f5 OF c-dep-almox IN FRAME fPage1 /* Deposito */
DO:
      {include/zoomvar.i &prog-zoom="inzoom/z01in084.w"
                       &campo="c-dep-almox"
                       &campozoom="cod-depos"
                       &frame="fpage1"
                       &campo2="c-desc-deposito"
                       &campozoom2="nome"
                       &frame2="fpage1"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-dep-almox wMaintenanceNoNavigation
ON LEAVE OF c-dep-almox IN FRAME fPage1 /* Deposito */
DO:
    
    FIND FIRST deposito
        WHERE deposito.cod-depos = INPUT FRAME fpage1 c-dep-almox NO-LOCK NO-ERROR.
    IF AVAIL deposito THEN
        ASSIGN c-desc-deposito:SCREEN-VALUE IN FRAME fpage1 = deposito.nome.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-dep-almox wMaintenanceNoNavigation
ON mouse-select-dblclick OF c-dep-almox IN FRAME fPage1 /* Deposito */
DO:
   APPLY 'F5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttpedido-compr.cod-cond-pag
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttpedido-compr.cod-cond-pag wMaintenanceNoNavigation
ON F5 OF ttpedido-compr.cod-cond-pag IN FRAME fPage1 /* Condi‡Æo Pagto */
DO:
    /*--- Zoom Smart Object ---*/
    {include/zoomvar.i &prog-zoom="adzoom/z01ad039.w"
                       &campo=ttpedido-compr.cod-cond-pag
                       &campozoom=cod-cond-pag}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttpedido-compr.cod-cond-pag wMaintenanceNoNavigation
ON LEAVE OF ttpedido-compr.cod-cond-pag IN FRAME fPage1 /* Condi‡Æo Pagto */
DO:
    if  input frame fPage1 ttpedido-compr.cod-cond-pag = 0 then do:
        assign c-cond-pagto:screen-value in frame fPage1 = "Condi‡Æo Pagto Espec¡fica".
        assign input frame fPage0 ttpedido-compr.num-pedido
               input frame fPage0 ttpedido-compr.data-pedido.
        run ccp/cc0300f.w(input table ttpedido-compr,
                          input pcAction,
                          input-output table ttcond-especif).
        find first ttcond-especif no-error.
    end.
    else do:
        run getDescCondPag in hboin295desc ( input frame fPage1 ttpedido-compr.cod-cond-pag,
                                             output c-desc-cond-pag ).
        assign c-cond-pagto:screen-value in frame fPage1 = c-desc-cond-pag.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttpedido-compr.cod-cond-pag wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF ttpedido-compr.cod-cond-pag IN FRAME fPage1 /* Condi‡Æo Pagto */
DO:
  apply "f5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME ttpedido-compr.cod-emitente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttpedido-compr.cod-emitente wMaintenanceNoNavigation
ON F5 OF ttpedido-compr.cod-emitente IN FRAME fpage0 /* Fornecedor */
DO:
    {include/zoomvar.i &prog-zoom=adzoom/z01ad098.w
                       &campo=ttpedido-compr.cod-emitente
                       &campozoom=cod-emitente}.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttpedido-compr.cod-emitente wMaintenanceNoNavigation
ON F7 OF ttpedido-compr.cod-emitente IN FRAME fpage0 /* Fornecedor */
DO:
  {include/zoomvar.i &prog-zoom=inzoom/z16in274.w
                     &campo=ttpedido-compr.cod-emitente
                     &campozoom=cod-emitente
                     &parametros="run pi-seta-inicial in wh-pesquisa (input 1)."}.

  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttpedido-compr.cod-emitente wMaintenanceNoNavigation
ON LEAVE OF ttpedido-compr.cod-emitente IN FRAME fpage0 /* Fornecedor */
DO: 
    run getDescCGCEmitente in hboin295desc ( input frame fPage0 ttpedido-compr.cod-emitente,
                                             output c-nom-emit,
                                             output c-cgc-emit ).
    assign c-nome-fornec:screen-value in frame fPage0 = c-nom-emit
           c-cgc:screen-value         in frame fPage0 = c-cgc-emit.
           
    run getLeaveFornecedor in hboin295desc ( input  frame fPage0 ttpedido-compr.cod-emitente,
                                             output i-emit-terc,
                                             output i-cod-cond-pag ).
    assign ttpedido-compr.cod-cond-pag:screen-value  in frame fPage1 = string(i-cod-cond-pag).

    run getTransp.

    apply "leave":U to ttpedido-compr.cod-transp    in frame fPage1.

    if  i-cod-cond-pag > 0 then
        apply "leave":U to ttpedido-compr.cod-cond-pag in frame fPage1.
    else do:
        find first cond-pagto no-lock
            where cond-pagto.cod-cond-pag > 0 no-error.
        if avail cond-pagto then do:
            assign ttpedido-compr.cod-cond-pag:screen-value  in frame fPage1 = string(cond-pagto.cod-cond-pag).                       
            apply "leave" to ttpedido-compr.cod-cond-pag in frame fPage1.
        end.    
        else assign c-cond-pagto:screen-value in frame fPage1 = "Condi‡Æo Pagto Espec¡fica".
    end.    

    RUN pi-retornaFormatoCgc.
    
    for first emitente fields (tp-desp-padrao) no-lock
        where emitente.cod-emitente = input  frame fPage0 ttpedido-compr.cod-emitente:
        fi-tp-despesa:screen-value in frame fPage1 = string(emitente.tp-desp-padrao).
        apply "leave" to fi-tp-despesa in frame fPage1.
    end.   

    apply "leave":U TO c-dep-almox    in frame fPage1.  

    /*
    ** Habilita c½digo do itinerÿrio quando par³metros estiver para informa Data do Embarque
    */

    FIND FIRST b-ordem-compra NO-LOCK
         WHERE b-ordem-compra.num-pedido =  ttpedido-compr.num-pedido NO-ERROR.
    IF AVAIL   b-ordem-compra THEN DO:
    
       FIND FIRST b-cotacao-item WHERE
                  b-cotacao-item.numero-ordem = b-ordem-compra.numero-ordem AND
                  b-cotacao-item.cod-emitente = b-ordem-compra.cod-emitente AND
                  b-cotacao-item.it-codigo    = b-ordem-compra.it-codigo NO-LOCK NO-ERROR.
       IF AVAIL   b-cotacao-item THEN DO:


            ASSIGN v-cod-itiner-pad:SCREEN-VALUE IN FRAME fpage1 = string(b-cotacao-item.int-1)             
                   v-cod-pto-contr :SCREEN-VALUE IN FRAME fpage1 = substr(b-cotacao-item.char-1,41,5)
                   v-cod-incoterm  :SCREEN-VALUE IN FRAME fpage1 = SUBSTRING(b-cotacao-item.char-1,21,3).      

/* FOI RETIRADO ESTE CODIGO POR SOLICITACAO DA GIZELLE */
/*             IF b-cotacao-item.cod-incoterm = "" THEN DO:                                                               */
/*                                                                                                                        */
/*                FIND FIRST emitente-cex WHERE                                                                           */
/*                           emitente-cex.cod-emitente = input frame fPage0 ttpedido-compr.cod-emitente NO-LOCK NO-ERROR. */
/*                IF AVAIL   emitente-cex THEN DO:                                                                        */
/*                                                                                                                        */
/*                    ASSIGN v-cod-incoterm:SCREEN-VALUE IN FRAME fpage1 =  emitente-cex.cod-incoterm-imp .               */
/*                                                                                                                        */
/*                END.                                                                                                    */
/*             END.                                                                                                       */
       END.
       ELSE 
            ASSIGN v-cod-itiner-pad:SCREEN-VALUE IN FRAME fpage1 = ""             
                   v-cod-pto-contr :SCREEN-VALUE IN FRAME fpage1 = ""    
                   v-cod-incoterm  :SCREEN-VALUE IN FRAME fpage1 = "".      

    END.
       ELSE 
            ASSIGN v-cod-itiner-pad:SCREEN-VALUE IN FRAME fpage1 = ""             
                   v-cod-pto-contr :SCREEN-VALUE IN FRAME fpage1 = ""    
                   v-cod-incoterm  :SCREEN-VALUE IN FRAME fpage1 = "".  


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttpedido-compr.cod-emitente wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF ttpedido-compr.cod-emitente IN FRAME fpage0 /* Fornecedor */
DO:
  apply "f5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME ttpedido-compr.cod-mensagem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttpedido-compr.cod-mensagem wMaintenanceNoNavigation
ON F5 OF ttpedido-compr.cod-mensagem IN FRAME fPage1 /* Mensagem */
DO:
    /* Zoom Smart Object ---*/
    {include/zoomvar.i &prog-zoom="adzoom/z01ad176.w"
                       &campo=ttpedido-compr.cod-mensagem
                       &campozoom=cod-mensagem}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttpedido-compr.cod-mensagem wMaintenanceNoNavigation
ON LEAVE OF ttpedido-compr.cod-mensagem IN FRAME fPage1 /* Mensagem */
DO:
    run getDescMensagem in hboin295desc ( input frame fPage1 ttpedido-compr.cod-mensagem,
                                          output c-desc-mensagem ).
    assign c-mensagem:screen-value in frame fPage1 = c-desc-mensagem.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttpedido-compr.cod-mensagem wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF ttpedido-compr.cod-mensagem IN FRAME fPage1 /* Mensagem */
DO:
  apply "f5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttpedido-compr.cod-transp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttpedido-compr.cod-transp wMaintenanceNoNavigation
ON F5 OF ttpedido-compr.cod-transp IN FRAME fPage1 /* Transportador */
DO:
    {include/zoomvar.i &prog-zoom="adzoom/z01ad268.w"
                       &campo=ttpedido-compr.cod-transp
                       &campozoom=cod-transp}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttpedido-compr.cod-transp wMaintenanceNoNavigation
ON LEAVE OF ttpedido-compr.cod-transp IN FRAME fPage1 /* Transportador */
DO:
    run getDescViaTransp in hboin295desc ( input frame fPage1 ttpedido-compr.cod-transp,
                                           output c-desc-transp,
                                           output i-via-transp ).
    assign c-transp:screen-value in frame fPage1 = c-desc-transp.
    
    assign cb-via-transp:screen-value in frame fPage1 = {adinc/i01ad268.i 04 i-via-transp} no-error.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttpedido-compr.cod-transp wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF ttpedido-compr.cod-transp IN FRAME fPage1 /* Transportador */
DO:
  apply "f5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cod-comprado
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-comprado wMaintenanceNoNavigation
ON F5 OF fi-cod-comprado IN FRAME fPage1 /* Comprador */
DO:
    {include/zoomvar.i &prog-zoom=inzoom/z01in055.w
                       &campo=fi-cod-comprado
                       &campozoom=cod-comprado
                       &frame=fPage1}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-comprado wMaintenanceNoNavigation
ON LEAVE OF fi-cod-comprado IN FRAME fPage1 /* Comprador */
DO:
    {include/leave.i &tabela=comprador
                     &atributo-ref=nome
                     &variavel-ref=fi-nome-comprador
                     &where="comprador.cod-comprado = input frame fPage1
                             fi-cod-comprado"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-comprado wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF fi-cod-comprado IN FRAME fPage1 /* Comprador */
DO:
    apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME fi-cod-estab
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-estab wMaintenanceNoNavigation
ON F5 OF fi-cod-estab IN FRAME fpage0 /* Estabelecimento */
DO:
    /*--- Zoom Smart Object ---*/
    {include/zoomvar.i &prog-zoom="adzoom/z01ad107.w"
                       &campo=fi-cod-estab
                       &campozoom=cod-estabel}   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-estab wMaintenanceNoNavigation
ON LEAVE OF fi-cod-estab IN FRAME fpage0 /* Estabelecimento */
DO:
    run getDescEstabelec in hboin295desc ( input frame fPage0 fi-cod-estab,
                                            output c-desc-estab ).
    assign c-desc-estab:screen-value in frame fPage0 = c-desc-estab.  

    APPLY "entry" TO btok IN FRAME fpage0.
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-estab wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF fi-cod-estab IN FRAME fpage0 /* Estabelecimento */
DO:
    apply "f5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME fi-mo-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-mo-codigo wMaintenanceNoNavigation
ON F5 OF fi-mo-codigo IN FRAME fPage1 /* Moeda */
DO:
    {include/zoomvar.i &prog-zoom=adzoom/z01ad178.w
                       &campo=fi-mo-codigo
                       &campozoom=mo-codigo}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-mo-codigo wMaintenanceNoNavigation
ON LEAVE OF fi-mo-codigo IN FRAME fPage1 /* Moeda */
DO: 
    {include/leave.i &tabela=moeda
                     &atributo-ref=descricao
                     &variavel-ref=fi-moeda
                     &where="moeda.mo-codigo = input frame fPage1
                             fi-mo-codigo"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-mo-codigo wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF fi-mo-codigo IN FRAME fPage1 /* Moeda */
DO:
    apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-requisitante
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-requisitante wMaintenanceNoNavigation
ON F5 OF fi-requisitante IN FRAME fPage1 /* Requisitante */
DO:
    {include/zoomvar.i &prog-zoom=inzoom/z01in386.w
                       &campo=fi-requisitante
                       &campozoom=nome-abrev
                       &frame=fPage1}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-requisitante wMaintenanceNoNavigation
ON LEAVE OF fi-requisitante IN FRAME fPage1 /* Requisitante */
DO:
    {include/leave.i &tabela=requisitante
                     &atributo-ref=nome
                     &variavel-ref=fi-nome-requisitante
                     &where="requisitante.nome-abrev = input frame fPage1
                             fi-requisitante"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-requisitante wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF fi-requisitante IN FRAME fPage1 /* Requisitante */
DO:
    apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-tp-despesa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-tp-despesa wMaintenanceNoNavigation
ON F5 OF fi-tp-despesa IN FRAME fPage1 /* Tipo Despesa */
DO:
    /* Zoom Smart Object */
    {include/zoomvar.i &prog-zoom="adzoom/z01ad259.w"
                       &campo=fi-tp-despesa
                       &campozoom=tp-codigo}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-tp-despesa wMaintenanceNoNavigation
ON LEAVE OF fi-tp-despesa IN FRAME fPage1 /* Tipo Despesa */
DO:
    run getDescTpDesp in hboin295desc (input  frame fPage1 fi-tp-despesa,
                                       output c-desp).
    assign c-desc-desp:screen-value in frame fPage1 = c-desp.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-tp-despesa wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF fi-tp-despesa IN FRAME fPage1 /* Tipo Despesa */
DO:
    apply "f5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Zoom_FornecAmbos_com_Ordens
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Zoom_FornecAmbos_com_Ordens wMaintenanceNoNavigation
ON CHOOSE OF MENU-ITEM m_Zoom_FornecAmbos_com_Ordens /* Zoom Fornec/Ambos com Ordens Cotadas */
DO:
   apply "F7" to ttpedido-compr.cod-emitente in frame fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Zoom_Fornecedor_do_Pedido_d
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Zoom_Fornecedor_do_Pedido_d wMaintenanceNoNavigation
ON CHOOSE OF MENU-ITEM m_Zoom_Fornecedor_do_Pedido_d /* Zoom Fornecedor do Pedido de Compra */
DO:
    apply "F5":U to ttpedido-compr.cod-emitente in frame fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttpedido-compr.responsavel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttpedido-compr.responsavel wMaintenanceNoNavigation
ON F5 OF ttpedido-compr.responsavel IN FRAME fPage1 /* Respons vel */
DO:
    /*--- Zoom Smart Object ---*/
    {include/zoomvar.i &prog-zoom="inzoom/z01in055.w"
                       &campo=ttpedido-compr.responsavel
                       &campozoom=cod-comprado}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttpedido-compr.responsavel wMaintenanceNoNavigation
ON LEAVE OF ttpedido-compr.responsavel IN FRAME fPage1 /* Respons vel */
DO:
    run getDescResponsavel in hboin295desc ( input frame fPage1 ttpedido-compr.responsavel,
                                             output c-desc-responsavel ).
    assign c-responsavel:screen-value in frame fPage1 = c-desc-responsavel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttpedido-compr.responsavel wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF ttpedido-compr.responsavel IN FRAME fPage1 /* Respons vel */
DO:
  apply "f5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME tg-gera-emb
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-gera-emb wMaintenanceNoNavigation
ON LEAVE OF tg-gera-emb IN FRAME fpage0 /* Gera Embarque */
DO:
   APPLY "entry" TO cb-frete IN FRAME fpage1.
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME v-cod-incoterm
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL v-cod-incoterm wMaintenanceNoNavigation
ON F5 OF v-cod-incoterm IN FRAME fPage1 /* Incoterm */
DO:
    {method/zoomfields.i 
       &ProgramZoom="cxzoom/z10cx025.w"
       &FieldZoom1="cod-incoterm"
       &FieldScreen1="v-cod-incoterm"
       &Frame1="fPage1"}   
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL v-cod-incoterm wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF v-cod-incoterm IN FRAME fPage1 /* Incoterm */
DO:
    apply "f5":U to self in frame fpage1.   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME v-cod-itiner-pad
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL v-cod-itiner-pad wMaintenanceNoNavigation
ON F5 OF v-cod-itiner-pad IN FRAME fPage1 /* Itiner rio */
DO:
    {method/zoomfields.i 
     &ProgramZoom="cxzoom/z10cx115.w"
     &FieldZoom1="cod-itiner"
     &FieldScreen1="v-cod-itiner-pad"
     &Frame1="fPage1"}    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL v-cod-itiner-pad wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF v-cod-itiner-pad IN FRAME fPage1 /* Itiner rio */
DO:
    apply "f5":U to self in frame fpage1.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME v-cod-pto-contr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL v-cod-pto-contr wMaintenanceNoNavigation
ON F5 OF v-cod-pto-contr IN FRAME fPage1 /* Pto Contr */
DO:
    {include/zoomvar.i &prog-zoom=cxzoom/z01cx120.w
          &campo=v-cod-pto-contr
          &campozoom=cod-pto-contr
          &frame="fPage1"}   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL v-cod-pto-contr wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF v-cod-pto-contr IN FRAME fPage1 /* Pto Contr */
DO:
    apply "f5":U to self in frame fpage1.   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{maintenancenonavigation/mainblock.i}

v-cod-itiner-pad:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage1.
v-cod-pto-contr:LOAD-MOUSE-POINTER("image/lupa.cur":U)  IN FRAME fPage1.
v-cod-incoterm:LOAD-MOUSE-POINTER("image/lupa.cur":U)   IN FRAME fPage1.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wMaintenanceNoNavigation 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    if  valid-handle(hboin295desc) then
        delete procedure hboin295desc.
                         hboin295desc = ?.

    if  valid-handle(hboin057) then
        delete procedure hboin057.
                         hboin057 = ?.

    if  valid-handle(hboin274sd) then
        delete procedure hboin274sd.
                         hboin274sd = ?.

    if  valid-handle(hboin082sd) then
        delete procedure hboin082sd.
                         hboin082sd = ?.

    if  valid-handle(hboin356ca) then
        delete procedure hboin356ca.
                         hboin356ca = ?.

    if  valid-handle(hboin082ca) then
        delete procedure hboin082ca.
                         hboin082ca = ?.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wMaintenanceNoNavigation 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    assign cb-via-transp:screen-value    in frame fPage1 = {adinc/i01ad268.i 04 1}
           cb-frete:screen-value         in frame fPage1 = {ininc/i03in295.i 04 2}.

    apply "LEAVE":U to ttpedido-compr.cod-emitente in frame fPage0.        
    apply "LEAVE":U to ttpedido-compr.responsavel in frame fPage1.
    apply "LEAVE":U to ttpedido-compr.cod-mensagem in frame fPage1.
    apply "LEAVE":U to fi-requisitante in frame fPage1.
    apply "LEAVE":U to fi-mo-codigo in frame fPage1.
    apply "LEAVE":U to fi-cod-comprado in frame fPage1.
    apply "LEAVE":U to fi-cod-estab in frame fPage0.

    IF  c-tipo-evento = "AlterarPedido"
    THEN
        ENABLE bt-pedido WITH FRAME fpage0.


                 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wMaintenanceNoNavigation 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ttpedido-compr.cod-emitente:LOAD-MOUSE-POINTER("image/rbm.cur":U) in frame fPage0.
    ttpedido-compr.cod-cond-pag:LOAD-MOUSE-POINTER("image/lupa.cur":U) in frame fPage1.
    ttpedido-compr.cod-mensagem:LOAD-MOUSE-POINTER("image/lupa.cur":U) in frame fPage1. 
    ttpedido-compr.cod-transp:LOAD-MOUSE-POINTER("image/lupa.cur":U) in frame fPage1. 
    ttpedido-compr.responsavel:LOAD-MOUSE-POINTER("image/lupa.cur":U) in frame fPage1.
    fi-cod-comprado:LOAD-MOUSE-POINTER("image/lupa.cur":U) in frame fPage1.
    fi-requisitante:LOAD-MOUSE-POINTER("image/lupa.cur":U) in frame fPage1.
    fi-cod-estab:LOAD-MOUSE-POINTER("image/lupa.cur":U) in frame fPage0.
    fi-mo-codigo:LOAD-MOUSE-POINTER("image/lupa.cur":U) in frame fPage1.
    fi-tp-despesa:LOAD-MOUSE-POINTER("image/lupa.cur":U) in frame fPage1.
    c-dep-almox:LOAD-MOUSE-POINTER("image/lupa.cur":U)   IN FRAME fPage1.

    run piRetornaDados in phCaller (OUTPUT TABLE ttcomponente,
                                    OUTPUT v-log-amostra,
                                    OUTPUT v-cod-produto,
                                    OUTPUT v-cod-emitente,
                                    OUTPUT v-qtd-pedido,
                                    OUTPUT fi-cod-estab,
                                    OUTPUT v-log-ckd,
                                    OUTPUT v-log-hml).

    IF v-log-hml THEN DO:
        ASSIGN c-dep-almox:SCREEN-VALUE IN FRAME fPage1 = "HML".
        APPLY "leave" TO c-dep-almox IN FRAME fPage1.
    END.

    FIND ITEM NO-LOCK 
        WHERE ITEM.it-codigo = v-cod-produto NO-ERROR.

    /*IF  AVAIL ITEM
    THEN DO:
        FIND item-fornec-estab NO-LOCK
            WHERE item-fornec-estab.it-codigo    = v-cod-produto
              AND item-fornec-estab.cod-emitente = v-cod-emitente
              AND item-fornec-estab.cod-estabel  = fi-cod-estab NO-ERROR.

        IF  AVAIL item-fornec-estab
        THEN DO:
            ASSIGN v-dat-entrega = TODAY + item-fornec-estab.tempo-ressup.
            FIND item-fabric NO-LOCK
                WHERE item-fabric.it-codigo  = item-fornec-estab.it-codigo
                  AND ITEM-fabric.cod-fabric = INT(item-fornec-estab.item-do-for) NO-ERROR.

            IF  AVAIL item-fabric
            THEN
                ASSIGN ttpedido-compr.comentarios = ttpedido-compr.comentarios  + "Product: " + v-cod-produto + " - " + item.desc-item + CHR(13) + CHR(13) + "P/N.: " + item-fabric.it-fabric  + CHR(13) + CHR(13) + "Quantity: " + STRING(INT(v-qtd-pedido)).
            ELSE
                ASSIGN ttpedido-compr.comentarios = ttpedido-compr.comentarios  + "Product: " + v-cod-produto + " - " + item.desc-item + CHR(13) + CHR(13) + "Quantity: " + STRING(INT(v-qtd-pedido)).
        END.
        ELSE
            ASSIGN ttpedido-compr.comentarios = ttpedido-compr.comentarios  + "Product: " + v-cod-produto + " - " + item.desc-item + CHR(13) + CHR(13) + "Quantity: " + STRING(INT(v-qtd-pedido)).
    END.*/

    DISPLAY v-dat-entrega WITH FRAME fpage0.
    DISPLAY fi-cod-estab  WITH FRAME fpage0.
    DISPLAY ttpedido-compr.comentarios WITH FRAME fpage2.

    APPLY "leave" TO fi-cod-estab IN FRAME fpage0.

    IF  v-cod-emitente <> 0
    THEN DO:
        DISPLAY v-cod-emitente @ ttpedido-compr.cod-emitente WITH frame fPage0.
        DISABLE ttpedido-compr.cod-emitente WITH frame fPage0.
    END.

    DISABLE c-desc-deposito WITH FRAME fpage1.
        
    apply "LEAVE":U to ttpedido-compr.cod-emitente in frame fPage0.    

    IF  c-tipo-evento = "GerarPedido" THEN DO:
    
        ASSIGN ttpedido-compr.num-pedido:READ-ONLY IN FRAME fpage0 = YES.
     
        DISABLE c-desc-estab WITH FRAME fpage0.

        FIND emitente-cex NO-LOCK 
            WHERE emitente-cex.cod-emitente = INPUT FRAME fPage0 ttpedido-compr.cod-emitente NO-ERROR.
        
        IF  AVAIL emitente-cex AND
                  emitente-cex.cod-emitente <> 0
        THEN
            DISP emitente-cex.cod-itiner-imp   @ v-cod-itiner-pad 
                 emitente-cex.cod-pto-contr    @ v-cod-pto-contr
                 emitente-cex.cod-incoterm-imp @ v-cod-incoterm WITH FRAME fpage1.
        ELSE
            DISP 0  @ v-cod-itiner-pad
                 0  @ v-cod-pto-contr
                 "" @ v-cod-incoterm WITH FRAME fpage1.

        
    END.
    ELSE DO:
        DISPLAY 0 @ ttpedido-compr.num-pedido WITH FRAME fpage0.
        ASSIGN ttpedido-compr.cod-emitente:SENSITIVE IN FRAME fpage0 = NO
               ttpedido-compr.data-pedido :SENSITIVE IN FRAME fpage0 = NO  
               ttpedido-compr.impr-pedido :SENSITIVE IN FRAME fpage0 = NO
/*             v-dat-entrega              :SENSITIVE IN FRAME fpage0 = NO */
               tg-proc-imp                :SENSITIVE IN FRAME fpage0 = NO
               tg-gera-emb                :SENSITIVE IN FRAME fpage0 = NO.
    END.

    APPLY "ENTRY" TO ttpedido-compr.num-pedido IN FRAME fpage0.

      IF c-tipo-evento = "AlterarPedido" THEN DO:
      
        DISABLE fi-cod-estab WITH FRAME fpage0 .
        DISABLE c-desc-estab WITH FRAME fpage0 .

        ASSIGN ttpedido-compr.data-pedido :HIDDEN    IN FRAME fpage0 = YES
               ttpedido-compr.impr-pedido :HIDDEN    IN FRAME fpage0 = YES
               tg-proc-imp                :HIDDEN    IN FRAME fpage0 = YES
               tg-gera-emb                :HIDDEN    IN FRAME fpage0 = YES.

        ASSIGN cb-frete                   :HIDDEN    IN FRAME fpage1 = YES  
               ttpedido-compr.cod-transp  :HIDDEN    IN FRAME fpage1 = YES
               c-transp                   :HIDDEN    IN FRAME fpage1 = YES
               cb-via-transp              :HIDDEN    IN FRAME fpage1 = YES
               fi-mo-codigo               :HIDDEN    IN FRAME fpage1 = YES
               fi-moeda                   :HIDDEN    IN FRAME fpage1 = YES
               ttpedido-compr.cod-cond-pag:HIDDEN    IN FRAME fpage1 = YES
               c-cond-pagto               :HIDDEN    IN FRAME fpage1 = YES 
               ttpedido-compr.responsavel :HIDDEN    IN FRAME fpage1 = YES
               c-responsavel              :HIDDEN    IN FRAME fpage1 = YES
               ttpedido-compr.cod-mensagem:HIDDEN    IN FRAME fpage1 = YES
               c-mensagem                 :HIDDEN    IN FRAME fpage1 = YES.
             

    END.

    RETURN NO-APPLY.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeDisplayFields wMaintenanceNoNavigation 
PROCEDURE beforeDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def var c-formato-cgc           as char no-undo.
    def var l-modulo-ge             as log  no-undo.
    def var l-nr-processo-sensitive as log  no-undo.
    def var l-responsavel-sensitive as log  no-undo.
    def var c-end-cobranca-aux      like pedido-compr.end-cobranca no-undo.
    def var c-end-entrega-aux       like pedido-compr.end-entrega  no-undo.
    def var i-cod-mensagem          like pedido-compr.cod-mensagem no-undo.
    def var i-cond-pagto            as int  no-undo.
    
    /*RUN geraNumeroPedidoCompra IN {&hDBOTable} (output i-num-pedido).*/

    RUN preparaPedidoCompra IN {&hDBOTable} (output c-formato-cgc,
                                             output l-modulo-ge,
                                             output c-end-cobranca-aux,
                                             output c-end-entrega-aux,
                                             output i-cod-mensagem,
                                             output c-seg-usuario,
                                             output i-cond-pagto).

    assign /*ttpedido-compr.num-pedido    = i-num-pedido             */
           c-cgc:format in frame fPage0 = c-formato-cgc.

    assign ttpedido-compr.end-cobranca = c-end-cobranca-aux
           ttpedido-compr.end-entrega  = c-end-entrega-aux
           ttpedido-compr.cod-mensagem = 998
           ttpedido-compr.responsavel  = c-seg-usuario
           ttpedido-compr.cod-cond-pag = i-cond-pagto
           ttpedido-compr.emergencial  = YES
           fi-requisitante             = c-seg-usuario
           fi-mo-codigo                = 1.

    IF v_cod_estab_usuar = "101" THEN
        ASSIGN c-dep-almox = "WAL".
    ELSE
        ASSIGN c-dep-almox = "ALM".
           
    assign cb-frete:list-items         in frame fPage1 = {ininc/i03in295.i 03}
           cb-via-transp:list-items    in frame fPage1 = {adinc/i01ad268.i 03}.
           
    find item-uni-estab where 
         item-uni-estab.cod-estabel = v_cod_estab_usuar and
         item-uni-estab.it-codigo   = s-it-codigo   no-lock no-error.
    if  avail item-uni-estab then
        fi-cod-comprado = item-uni-estab.cod-comprado.
    else do:
        find first item no-lock
            where item.it-codigo = s-it-codigo no-error.
        if avail item then
            fi-cod-comprado = item.cod-comprado.
    end.

    IF  fi-cod-comprado = ""
    THEN
        ASSIGN fi-cod-comprado = c-seg-usuario.

 

           
           
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getTransp wMaintenanceNoNavigation 
PROCEDURE getTransp PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def var i-cod-transp like pedido-compr.cod-transp no-undo.

    run getTransp in hboin295desc ( input frame fPage0 ttpedido-compr.cod-emitente,
                                    output i-cod-transp ).
    assign ttpedido-compr.cod-transp:screen-value in frame fPage1 = string(i-cod-transp).

    if  i-cod-transp <> 0 then
        apply "leave":U to ttpedido-compr.cod-transp in frame fPage1.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wMaintenanceNoNavigation 
PROCEDURE initializeDBOs :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    if  not valid-handle(hboin295desc) then do:
        run inbo/boin295desc.p persistent set hboin295desc.
        run openQueryStatic in hboin295desc ( input "Main":U ).
    end.  

    if  not valid-handle(hboin057) then do:
        run inbo/boin057.p persistent set hboin057.
        run openQueryStatic in hboin057 ( input "Main":U ).
    end. 
    
    if  not valid-handle(hboin274sd) then do:
        run inbo/boin274sd.p persistent set hboin274sd.
        run openQueryStatic in hboin274sd ( input "Main":U ).
    end. 
    
    if  not valid-handle(hboin082sd) then do:
        run inbo/boin082sd.p persistent set hboin082sd.
        run openQueryStatic in hboin082sd ( input "Main":U ).
    end. 

    if  not valid-handle(hboin356ca) then do:
        run inbo/boin356ca.p persistent set hboin356ca.
        run openQueryStatic in hboin356ca ( input "Main":U ).
    end. 

    if  not valid-handle(hboin082ca) then do:
        run inbo/boin082ca.p persistent set hboin082ca.
    end. 

 
    
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-embarque wMaintenanceNoNavigation 
PROCEDURE pi-gera-embarque :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
        DEF OUTPUT PARAM p-log-desfaz AS LOG INITIAL NO NO-UNDO.
        
        IF AVAIL ttpedido-compr 
        THEN DO:
            FIND FIRST tt-processo-imp NO-LOCK NO-ERROR.

            IF  AVAIL tt-processo-imp
            THEN DO:
                FIND pedido-compr EXCLUSIVE-LOCK 
                    WHERE pedido-compr.num-pedido = ttpedido-compr.num-pedido NO-ERROR.

                ASSIGN pedido-compr.situacao = 1. /* Impresso */

                FIND CURRENT pedido-compr NO-LOCK NO-ERROR.

                FIND FIRST embarque-imp NO-LOCK 
                    WHERE  embarque-imp.cod-estabel = tt-processo-imp.cod-estabel 
                      AND  embarque-imp.embarque    = tt-processo-imp.nr-proc-imp NO-ERROR.
    
                IF  NOT AVAIL embarque-imp
                THEN DO:
                    CREATE embarque-imp.
                    ASSIGN embarque-imp.cod-estabel         = pedido-compr.cod-estabel
                           embarque-imp.embarque            = tt-processo-imp.nr-proc-imp
                           embarque-imp.situacao            = 1
                           embarque-imp.cod-transportador   = tt-processo-imp.cod-transportador
                           embarque-imp.cod-via-transp      = pedido-compr.via-transp
                           embarque-imp.narrativa           = pedido-compr.comentarios
                           embarque-imp.cod-incoterm        = v-cod-incoterm
                           embarque-imp.contabiliza         = NO.
                END. /* IF  NOT AVAIL embarque-imp AND */

                RUN cxbo/bocx225.p  PERSISTENT SET h-bocx225.
            
                EMPTY TEMP-TABLE RowErrors.
                FOR EACH  ordem-compra NO-LOCK
                    WHERE ordem-compra.num-pedido = pedido-compr.num-pedido,
                    EACH  prazo-compra OF ordem-compra NO-LOCK:

                    FIND FIRST ordens-embarque NO-LOCK
                        WHERE  ordens-embarque.numero-ordem = prazo-compra.numero-ordem 
                          AND  ordens-embarque.parcela      = prazo-compra.parcela NO-ERROR.
            
                    IF  NOT AVAIL ordens-embarque
                    THEN DO:
                        RUN setCreatehist IN h-bocx225.
                        RUN createOrdensEmbarquebyparcela IN h-bocx225 (INPUT ROWID(embarque-imp),
                                                                        INPUT prazo-compra.numero-ordem,
                                                                        INPUT prazo-compra.parcela,
                                                                        INPUT prazo-compra.quant-saldo,
                                                                        OUTPUT TABLE RowErrors).
                    END.
                END. /* FOR EACH  ordem-compra NO-LOCK */
                DELETE PROCEDURE h-bocx225.

                FIND FIRST RowErrors NO-LOCK NO-ERROR.
    
                IF  AVAIL RowErrors
                THEN DO:
                    ASSIGN p-log-desfaz = YES.
                    {METHOD/showmessage.i1}
                    {METHOD/showmessage.i2 &modal="yes"}
                    {METHOD/showmessage.i3}
                    RETURN "NOK".
                END.
            END. /* IF  AVAIL tt-processo-imp */
        END. /* IF AVAIL ttpedido-compr */

        RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-processo-importacao wMaintenanceNoNavigation 
PROCEDURE pi-processo-importacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF OUTPUT PARAM p-log-desfaz AS LOG INITIAL NO NO-UNDO.

    FIND LAST param-global NO-LOCK NO-ERROR.

    FIND emitente NO-LOCK
        WHERE emitente.cod-emitente = ttpedido-compr.cod-emitente NO-ERROR.

    FIND FIRST ordem-compra NO-LOCK
        WHERE  ordem-compra.num-pedido = ttpedido-compr.num-pedido NO-ERROR.

    FIND pedido-compr NO-LOCK
        WHERE pedido-compr.num-pedido = ttpedido-compr.num-pedido NO-ERROR.

    IF  AVAIL param-global AND
        AVAIL emitente     AND 
        AVAIL ordem-compra AND
        AVAIL pedido-compr
    THEN DO:
        IF  param-global.modulo-07 AND      /* M¢dulo de importa‡Æo est  implantado */
            CONNECTED("mgcex":U)   AND 
           (emitente.natureza = 3   OR       /* Estrangeiro */
            emitente.natureza = 4)
        THEN DO:    
            EMPTY TEMP-TABLE RowErrors       NO-ERROR.
            EMPTY TEMP-TABLE tt-processo-imp NO-ERROR.

            FIND emitente-cex EXCLUSIVE-LOCK
                WHERE emitente-cex.cod-emitente = emitente.cod-emitente NO-ERROR.

            IF  AVAIL emitente-cex
            THEN DO:
                ASSIGN v-cod-incoterm-tmp            = emitente-cex.cod-incoterm-imp
                       v-cod-itiner-tmp              = emitente-cex.cod-itiner-imp
                       emitente-cex.cod-incoterm-imp = v-cod-incoterm  
                       emitente-cex.cod-itiner-imp   = v-cod-itiner-pad.
                FIND CURRENT emitente-cex NO-LOCK NO-ERROR.
            END.

            RUN imp/im9045.p(INPUT  pedido-compr.num-pedido,
                             INPUT  ROWID(ordem-compr),
                             OUTPUT TABLE RowErrors,
                             OUTPUT TABLE tt-processo-imp).

            IF  AVAIL emitente-cex
            THEN DO:
                FIND CURRENT emitente-cex EXCLUSIVE-LOCK NO-ERROR.
                ASSIGN emitente-cex.cod-incoterm-imp = v-cod-incoterm-tmp
                       emitente-cex.cod-itiner-imp   = v-cod-itiner-tmp.
                FIND CURRENT emitente-cex NO-LOCK NO-ERROR.
            END.

            FIND FIRST RowErrors NO-LOCK NO-ERROR.
            IF  AVAIL RowErrors
            THEN DO:
                IF  VALID-HANDLE(h-acomp)
                THEN DO:
                    RUN pi-finalizar IN h-acomp.
                    ASSIGN h-acomp = ?.
                END.
                ASSIGN p-log-desfaz = YES.
                {METHOD/showmessage.i1}
                {METHOD/showmessage.i2 &modal="yes"}
                {METHOD/showmessage.i3}
                RETURN "NOK".
            END.
            
            IF  NOT VALID-HANDLE(h-bocx341) 
            THEN DO:
                RUN cxbo/bocx341.p PERSISTENT SET h-bocx341.
                RUN openQueryStatic IN h-bocx341("main":U).
            END.
        
            IF  VALID-HANDLE(h-bocx341) 
            THEN DO:
                EMPTY TEMP-TABLE RowErrors NO-ERROR.
                RUN atualizaDespesasPedido IN h-bocx341 (INPUT 1, /* incluir */
                                                         INPUT ROWID(ordem-compra),
                                                         INPUT pedido-compr.num-pedido).

/*                 RUN getRowErrors IN h-bocx341(OUTPUT TABLE rowErrors). */
/*                                                                        */
/*                 FIND FIRST RowErrors NO-LOCK NO-ERROR.                 */
/*                                                                        */
/*                 IF  AVAIL RowErrors                                    */
/*                 THEN DO:                                               */
/*                     {METHOD/showmessage.i1}                            */
/*                     {METHOD/showmessage.i2 &modal="yes"}               */
/*                     {METHOD/showmessage.i3}                            */
/*                 END.                                                   */

                DELETE PROCEDURE h-bocx341 NO-ERROR.
                ASSIGN h-bocx341 = ?.
            END. /* IF  VALID-HANDLE(h-bocx341)  */
        END. /* IF  param-global.modulo-07 AND */
    END. /* IF  AVAIL param-global AND */

    RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-retornaFormatoCgc wMaintenanceNoNavigation 
PROCEDURE pi-retornaFormatoCgc PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def var c-format-id-pessoal as char no-undo.
    def var c-format-id-federal  as char no-undo.

  FIND emitente WHERE 
       emitente.cod-emitente = integer(ttpedido-compr.cod-emitente:screen-value in frame fPage0) NO-LOCK NO-ERROR.
  if avail emitente then do:    
     if  emitente.natureza = 1 THEN DO:
         run returnFormatParamGlobal in hboin295desc(input "formato-id-pessoal":U,
                                                     output c-format-id-pessoal).
         assign c-cgc:format in frame fPage0 = c-format-id-pessoal
                c-format-id-pessoal = "".

     END.
     else if  emitente.natureza = 2 then DO:
         run returnFormatParamGlobal in hboin295desc(input "formato-id-federal":U,
                                                     output c-format-id-federal).
         assign c-cgc:format in frame fPage0 = c-format-id-federal
                c-format-id-federal = "".

     END.
  end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piImportacao wMaintenanceNoNavigation 
PROCEDURE piImportacao PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def var de-aliq-ii as dec no-undo.
    def var de-aliq-ipi as dec no-undo.
    def var l-regime as logical no-undo.

    find first ttcotacao-item no-error.
    find item no-lock
        where item.it-codigo = ttcotacao-item.it-codigo no-error.

    for each ttcotacao-item:
               
        empty temp-table ttcotacao-imp.               
        create ttcotacao-imp.
        assign ttcotacao-imp.numero-ordem        = ttcotacao-item.numero-ordem
               ttcotacao-imp.cod-emitente        = ttcotacao-item.cod-emitente
               ttcotacao-imp.it-codigo           = ttcotacao-item.it-codigo
               ttcotacao-imp.seq-cotac           = ttcotacao-item.seq-cotac
               ttcotacao-imp.mapa-cotacao        = 0
               ttcotacao-imp.cod-incoterm        = v-cod-incoterm
               ttcotacao-imp.cod-pto-contr       = v-cod-pto-contr
               ttcotacao-imp.cod-fabricante      = ttcotacao-item.cod-emitente
               ttcotacao-imp.regime-import       = 0
               ttcotacao-imp.class-fiscal        = item.class-fiscal.

         ASSIGN ttcotacao-imp.aliq-ii             = ttcotacao-item.aliquota-ii /*0*/
                ttcotacao-imp.aliq-ipi            = 0.

         ASSIGN ttcotacao-imp.cod-itiner          = v-cod-itiner-pad
                ttcotacao-imp.i-informa           = param-imp.int-1
                ttcotacao-imp.da-entrega-embarque = today.
         
        for first cotacao-item exclusive-lock
            where rowid(cotacao-item) = ttcotacao-item.r-rowid:
            
            assign cotacao-item.cod-incoterm           = ttcotacao-imp.cod-incoterm
                   cotacao-item.Cod-pto-contr-base     = ttcotacao-imp.cod-pto-contr
                   cotacao-item.int-1                  = ttcotacao-imp.cod-itiner
                   cotacao-item.mapa-cotacao           = ttcotacao-imp.mapa-cotacao   
                  overlay(cotacao-item.char-1, 1, 2)   = string(ttcotacao-imp.mapa-cotacao, "99")
                  overlay(cotacao-item.char-1,21,20)   = string(ttcotacao-imp.cod-incoterm, "x(20)")
                  overlay(cotacao-item.char-1,41, 5)   = string(ttcotacao-imp.cod-pto-contr, "99999")
                  overlay(cotacao-item.char-1,81,10)   = string(ttcotacao-imp.class-fiscal, "x(10)")
                  cotacao-item.cdn-fabrican            = ttcotacao-imp.cod-fabricante
                  overlay(cotacao-item.char-2, 81, 8)  = string(ttcotacao-imp.da-entrega-embarque)

                  cotacao-item.aliquota-ipi            = /*ttcotacao-imp.aliq-ipi*/ 0
                  cotacao-item.aliquota-ii             = ttcotacao-imp.aliq-ii
                  OVERLAY(cotacao-item.char-1,61,20)   = STRING(ttcotacao-imp.aliq-ii)
                  cotacao-item.regime-impot            = ttcotacao-imp.regime-import.

            
        end.               
    end.

    RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piSave wMaintenanceNoNavigation 
PROCEDURE piSave PRIVATE :
DEF var i-num-ordem as int  no-undo.
    def var c-contato   as char no-undo.
    def var c-discard   as char no-undo.
    def var i-discard   as int  no-undo.
    def var de-indice   as dec  no-undo.
    DEF VAR v-log-erro  AS LOG  NO-UNDO.

    empty temp-table tt-versao-integr.
    create tt-versao-integr.
    assign tt-versao-integr.cod-versao-integracao = 1
           v-log-erro = NO.        
    
    for first cont-emit no-lock
        where cont-emit.cod-emitente = ttpedido-compr.cod-emitente:
        c-contato = cont-emit.nome.
    end.       
    
    for first emitente no-lock
        where emitente.cod-emitente = ttpedido-compr.cod-emitente:
    end.    
    
    for first param-imp no-lock:
    end.
    find first param-mat no-lock no-error.

    run utp/ut-acomp.p persistent set h-acomp.
    run pi-inicializar in h-acomp (input "Criando Pedidos").

    DO TRANS ON ERROR UNDO, LEAVE:

        FOR EACH ttcomponente
           WHERE ttcomponente.quant-solic > 0:

            RUN geraNumeroPedidoCompra IN {&hDBOTable} (output i-num-pedido).
            
            ASSIGN ttpedido-compr.num-pedido = i-num-pedido.

            assign ttpedido-compr.num-pedido:screen-value in frame fPage0 = string(i-num-pedido).

            RUN piValida.
            
            IF RETURN-VALUE <> "OK":U  THEN
                RETURN "nok".
            /* Pedido de Compra */

            ASSIGN ttpedido-compr.frete = IF INPUT FRAME fPage1 cb-frete = "Pago" THEN 1 ELSE 2.
            EMPTY TEMP-TABLE RowErrors.
            run emptyRowErrors in {&hDBOTable}.
            run setConstraintMain in {&hDBOTable}.
            run openQueryStatic in {&hDBOTable} (input "Main").
            run setRecord in {&hDBOTable} (input table ttpedido-compr).
            run createRecord in {&hDBOTable}.
            run getRowErrors in {&hDBOTable} ( output table RowErrors ).
    
            FIND FIRST rowerrors NO-LOCK NO-ERROR.
    
            IF  AVAIL rowerrors 
            THEN DO:
                 RUN pi-finalizar IN h-acomp.
                 ASSIGN h-acomp = ?.
                {METHOD/showmessage.i1}
                {METHOD/showmessage.i2 &modal="yes"}
                {METHOD/showmessage.i3}
                ASSIGN v-log-erro = YES.
                UNDO, LEAVE.  
            END.
                              
            /* Condi‡Æo de Pagamento Especial */                           
            if ttpedido-compr.cod-cond-pag = 0 then do:
                find first ttcond-especif no-error.
                assign ttcond-especif.num-pedido = ttpedido-compr.num-pedido.
                EMPTY TEMP-TABLE RowErrors.
                run emptyRowErrors in hboin057.
                run setConstraintMain in hboin057.
                run openQueryStatic in hboin057 (input "Main").
                run setRecord in hboin057 (input table ttcond-especif).
                run createRecord in hboin057.
                run getRowErrors in hboin057 ( output table RowErrors ).
    
                FIND FIRST rowerrors NO-LOCK NO-ERROR.
    
                IF  AVAIL rowerrors 
                THEN DO:
                    RUN pi-finalizar IN h-acomp.
                    ASSIGN h-acomp = ?.
                    {METHOD/showmessage.i1}
                    {METHOD/showmessage.i2 &modal="yes"}
                    {METHOD/showmessage.i3}
                    ASSIGN v-log-erro = YES.
                    UNDO, LEAVE.  
                END.
            END.
    
            /* Ordens de Compra e Cota‡äes */
            RUN pi-desabilita-cancela IN h-acomp.
    
            for first item no-lock
                where item.it-codigo = ttcomponente.es-codigo:
    
                EMPTY TEMP-TABLE tt-ordem-compra.
                EMPTY TEMP-TABLE tt-prazo-compra.  
                EMPTY TEMP-TABLE tt-cotacao-item.
                EMPTY TEMP-TABLE ttcotacao-item.
                
                EMPTY TEMP-TABLE RowErrors.
                run geraNumeroOrdemPedEmerg in hboin274sd (output i-num-ordem,
                                                           output table RowErrors).
    
                FIND FIRST rowerrors NO-LOCK NO-ERROR.
        
                IF  AVAIL rowerrors 
                THEN DO:
                     RUN pi-finalizar IN h-acomp.
                     ASSIGN h-acomp = ?.
                    {METHOD/showmessage.i1}
                    {METHOD/showmessage.i2 &modal="yes"}
                    {METHOD/showmessage.i3}
                    ASSIGN v-log-erro = YES.
                    UNDO, LEAVE.  
                END.
    
                IF  VALID-HANDLE(h-acomp)
                THEN
                    run pi-acompanhar in h-acomp (input "Item " + ttcomponente.es-codigo). 
    
                FIND FIRST item-uni-estab NO-LOCK
                     WHERE item-uni-estab.it-codigo   = ttcomponente.es-codigo
                       AND item-uni-estab.cod-estabel = fi-cod-estab NO-ERROR.
                                   
                create tt-ordem-compra.
                assign tt-ordem-compra.ind-tipo-movto = 1
                       tt-ordem-compra.numero-ordem   = i-num-ordem
                       tt-ordem-compra.num-pedido     = ttpedido-compr.num-pedido
                       tt-ordem-compra.cod-emitente   = ttpedido-compr.cod-emitente
                       tt-ordem-compra.mo-codigo      = fi-mo-codigo 
                       tt-ordem-compra.it-codigo      = ttcomponente.es-codigo
                       tt-ordem-compra.cod-estabel    = fi-cod-estab 
                       tt-ordem-compra.data-emissao   = ttpedido-compr.data-pedido
                       tt-ordem-compra.requisitante   = fi-requisitante:screen-value in frame fpage1
                       tt-ordem-compra.cod-comprado   = fi-cod-comprado:screen-value in frame fpage1
                       tt-ordem-compra.qt-solic       = ttcomponente.quant-solic
                       tt-ordem-compra.preco-fornec   = ttcomponente.preco-unit 
                       tt-ordem-compra.preco-unit     = ttcomponente.preco-unit
                       tt-ordem-compra.pre-unit-for   = ttcomponente.preco-unit
                       tt-ordem-compra.tp-despesa     = fi-tp-despesa 
                       tt-ordem-compra.l-split        = no
                       tt-ordem-compra.situacao       = 2
                       tt-ordem-compra.cod-cond-pag   = ttpedido-compr.cod-cond-pag
                       tt-ordem-compra.cod-transp     = ttpedido-compr.cod-transp
                       tt-ordem-compra.aliquota-iss   = 0
                       tt-ordem-compra.aliquota-ipi   = 0
                       tt-ordem-compra.aliquota-icm   = 0
                       tt-ordem-compra.contato        = c-contato
                       tt-ordem-compra.data-cotacao   = ttpedido-compr.data-pedido
                       tt-ordem-compra.data-pedido    = ttpedido-compr.data-pedido
                       tt-ordem-compra.ep-codigo      = i-ep-codigo-usuario
                       tt-ordem-compra.nr-dias-taxa   = 0
                       tt-ordem-compra.impr-ficha     = no
                       tt-ordem-compra.taxa-finan     = no
                       tt-ordem-compra.qt-acum-nec    = tt-ordem-compra.qt-solic
                       tt-ordem-compra.cod-unid-negoc = IF AVAIL item-uni-estab THEN item-uni-estab.cod-unid-negoc ELSE "".
                       
                if not avail item-uni-estab or item-uni-estab.cod-unid-negoc = '' then do:
                    
                    RUN _insertError IN {&hDBOTable} (INPUT 17006,
                                                      INPUT "EMS":U,
                                                      INPUT "ERROR":U,
                                                      INPUT 'Unidade de Neg¢cio NÆo informada').    
                end.       
    
                run buscaInfOrdemLeaveItem in hboin274sd (input tt-ordem-compra.it-codigo,
                                                          input tt-ordem-compra.cod-estabel,
                                                          input tt-ordem-compra.num-pedido,
                                                          output c-discard,
                                                          output tt-ordem-compra.ct-codigo,
                                                          output tt-ordem-compra.sc-codigo,
                                                          output tt-ordem-compra.dep-almoxar,
                                                          output i-discard).
                                                          
                assign tt-ordem-compra.dep-almoxar    = c-dep-almox:screen-value in frame fpage1.
    
                FIND item-fornec-estab NO-LOCK
                    WHERE item-fornec-estab.it-codigo    = ttcomponente.es-codigo 
                      AND item-fornec-estab.cod-emitente = ttpedido-compr.cod-emitente 
                      AND item-fornec-estab.cod-estabel  = fi-cod-estab NO-ERROR.
                if NOT available item-fornec-estab 
                THEN DO:
                    CREATE item-fornec-estab.
                    ASSIGN item-fornec-estab.it-codigo    = ttcomponente.es-codigo
                           item-fornec-estab.cod-emitente = ttpedido-compr.cod-emitente 
                           item-fornec-estab.cod-estabel  = fi-cod-estab
                           item-fornec-estab.ativo        = no.
                    RELEASE item-fornec-estab.
                END.
    
                FIND item-fornec NO-LOCK 
                    WHERE item-fornec.it-codigo    = ttcomponente.es-codigo 
                      AND item-fornec.cod-emitente = ttpedido-compr.cod-emitente NO-ERROR.
                if NOT available item-fornec then do:
                    create item-fornec.
                    assign item-fornec.it-codigo           = ttcomponente.es-codigo
                           item-fornec.cod-emitente        = ttpedido-compr.cod-emitente
                           item-fornec.item-do-forn        = ttcomponente.es-codigo 
                           item-fornec.unid-med-for        = item.un
                           item-fornec.fator-conver        = 1
                           item-fornec.num-casa-dec        = 0
                           item-fornec.ativo               = no
                           item-fornec.cod-cond-pag        = ttpedido-compr.cod-cond-pag
                           item-fornec.classe-repro        = 3
                           item-fornec.aval-insp           = 5
                           item-fornec.idi-tributac-pis    = 2  /*Tributacao PIS Isento*/
                           item-fornec.idi-tributac-cofins = 2. /*Tributacao COFINS Isento*/
                end.
    
                FIND int-item-for-PN NO-LOCK 
                    WHERE int-item-for-PN.it-codigo    = ttcomponente.es-codigo 
                      AND int-item-for-PN.cod-emitente = ttpedido-compr.cod-emitente NO-ERROR.
                IF  NOT avail int-item-for-PN THEN DO:
                    CREATE int-item-for-PN.
                    ASSIGN int-item-for-PN.it-codigo    = ttcomponente.es-codigo
                           int-item-for-PN.cod-emitente = ttpedido-compr.cod-emitente
                           int-item-for-PN.item-do-forn = ttcomponente.es-codigo.
                END.

                {cdp/cd9950.i item.un 
                              item-fornec.unid-med-for
                              ttpedido-compr.cod-emitente}
    
                assign de-indice = 1 when (de-indice = 0 or de-indice = ?). 
                                                          
                create tt-prazo-compra.
                assign tt-prazo-compra.ind-tipo-movto = 1
                       tt-prazo-compra.numero-ordem   = i-num-ordem 
                       tt-prazo-compra.parcela        = 1
                       tt-prazo-compra.quantidade     = tt-ordem-compra.qt-solic
                       tt-prazo-compra.un             = ttcomponente.un
                       tt-prazo-compra.data-entrega   = v-dat-entrega
                       tt-prazo-compra.situacao       = tt-ordem-compra.situacao
                       tt-prazo-compra.data-alter     = TODAY
                       tt-prazo-compra.it-codigo      = tt-ordem-compra.it-codigo
                       tt-prazo-compra.qtd-a-ped-forn = tt-prazo-compra.quantidade * de-indice
                       tt-prazo-compra.qtd-do-forn    = tt-prazo-compra.quantidade * de-indice
                       tt-prazo-compra.qtd-sal-forn   = tt-prazo-compra.quantidade * de-indice
                       tt-prazo-compra.quant-saldo    = tt-prazo-compra.quantidade
                       tt-prazo-compra.quantid-orig   = tt-prazo-compra.quantidade.
    
                run calculaProximaParcelaPrazoCompra in hboin356ca (input tt-ordem-compra.numero-ordem,
                                                                    input tt-ordem-compra.it-codigo,
                                                                    input tt-ordem-compra.cod-estabel,
                                                                    INPUT ttpedido-compr.cod-emitente,
                                                                    output tt-prazo-compra.parcela,
                                                                    output tt-prazo-compra.un,
                                                                    output tt-prazo-compra.data-entrega).
    
                ASSIGN tt-prazo-compra.data-entrega = v-dat-entrega.
                create tt-cotacao-item.
    
                run setDefaultsCotacao.
    
                FIND item-fornec NO-LOCK 
                    WHERE item-fornec.it-codigo    = ttcomponente.es-codigo 
                      AND item-fornec.cod-emitente = ttpedido-compr.cod-emitente NO-ERROR.
    
                find first ttcotacao-item no-error.
                assign ttcotacao-item.preco-fornec = tt-ordem-compra.preco-fornec
                       ttcotacao-item.preco-unit   = tt-ordem-compra.preco-fornec
                       ttcotacao-item.codigo-ipi   = ttcomponente.inclui-ipi.
    
                ASSIGN ttcotacao-item.aliquota-ii  = DEC(SUBSTR(ITEM.char-2,22,6))
                       ttcotacao-item.aliquota-ipi = 0.
    
                ASSIGN ttcotacao-item.aliquota-icm = 0
                       ttcotacao-item.taxa-finan   = NO
                       ttcotacao-item.valor-taxa   = 0
                       ttcotacao-item.numero-ordem = i-num-ordem
                       ttcotacao-item.it-codigo    = tt-ordem-compra.it-codigo
                       ttcotacao-item.un           = item-fornec.unid-med-for
                       ttcotacao-item.mo-codigo    = fi-mo-codigo
                       ttcotacao-item.cod-emitente = ttpedido-compr.cod-emitente
                       ttcotacao-item.cod-comprado = tt-ordem-compra.cod-comprado
                       ttcotacao-item.cod-transp   = tt-ordem-compra.cod-transp
                       ttcotacao-item.hora-atualiz = string(time, "hh:mm:ss")
                       ttcotacao-item.cot-aprovada = yes
                       ttcotacao-item.contato      = c-contato
                       ttcotacao-item.usuario      = c-seg-usuario
                       ttcotacao-item.prazo-entreg = 0.
    
                run calculaPrecoUnitFornecedorCotacao in hboin082ca (input no,
                                                                     input i-num-ordem,
                                                                     input-output table ttcotacao-item).
    
                find first ttcotacao-item no-error.
                {cdp/cd9950.i item.un 
                              ttcotacao-item.un
                              ttcotacao-item.cod-emitente}
                assign de-indice = 1 when (de-indice = 0 or de-indice = ?). 
    
                buffer-copy ttcotacao-item to tt-cotacao-item.
                assign tt-cotacao-item.ind-tipo-movto = 1
                       tt-cotacao-item.preco-unit     = tt-cotacao-item.pre-unit-for * de-indice.
                
                EMPTY TEMP-TABLE tt-erros-geral.
                EMPTY TEMP-TABLE RowErrors.
                run ccp/ccapi302.p (input  table tt-versao-integr,
                                    output table tt-erros-geral,
                                    input  table tt-ordem-compra,
                                    input  table tt-prazo-compra,        
                                    input  table tt-cotacao-item,
                                         &if defined(bf_mat_despesa_fase_II) &then
                                         input table tt-desp-cotacao-item,
                                         &endif
                                         &if '{&bf_mat_versao_ems}' >= '2.04' &then
                                         input table tt-matriz-rat-med,
                                        &endif
                                    input "INPUT").
    
                for each tt-erros-geral:
                    IF  INDEX(tt-erros-geral.des-erro,"item") <> 0
                    THEN
                        ASSIGN tt-erros-geral.des-erro = tt-erros-geral.des-erro + " item (" + tt-cotacao-item.it-codigo + ")".
    
                    RUN _insertErrorManual IN {&hDBOTable} (INPUT tt-erros-geral.cod-erro,
                                                            INPUT "EMS":U,
                                                            INPUT "ERROR":U,
                                                            INPUT tt-erros-geral.des-erro,
                                                            input "",
                                                            input "").    
                end.
    
                run getRowErrors in {&hDBOTable} ( output table RowErrors ).
    
                FIND FIRST rowerrors NO-LOCK NO-ERROR.
        
                IF  AVAIL rowerrors 
                THEN DO:
                     RUN pi-finalizar IN h-acomp.
                     ASSIGN h-acomp = ?.
                    {METHOD/showmessage.i1}
                    {METHOD/showmessage.i2 &modal="yes"}
                    {METHOD/showmessage.i3}
                    ASSIGN v-log-erro = YES.
                    UNDO, LEAVE.  
                END.
                else do:
    
                    for first cotacao-item 
                        where cotacao-item.cot-aprovada = yes
                        and   cotacao-item.numero-ordem = tt-ordem-compra.numero-ordem:
                        find first ordem-compra exclusive-lock
                            where ordem-compra.numero-ordem = tt-ordem-compra.numero-ordem no-error.
                        if avail ordem-compra then
                            assign ordem-compra.pre-unit-for = cotacao-item.pre-unit-for
                                   ordem-compra.preco-orig   = cotacao-item.pre-unit-for
                                   ordem-compra.preco-unit   = cotacao-item.preco-unit.
                    end.  
                     
    
                    if emitente.natureza = 3 or emitente.natureza = 4 then do:
                        empty temp-table ttcotacao-item.
                        for each cotacao-item no-lock
                            where cotacao-item.numero-ordem = tt-ordem-compra.numero-ordem:
                            create ttcotacao-item.
                            buffer-copy cotacao-item to ttcotacao-item.
                            ttcotacao-item.r-rowid = rowid(cotacao-item).
                        end.    
                        run piImportacao.
                        CREATE tt-ordem.
                        ASSIGN tt-ordem.num-ordem = i-num-ordem.
                    end.   
                end.
            end. /* Ordens de Compra e Cota»„es */   
    
            /* ATUALIZA TABELA INTEGRACAO PEDIDO COMPRA - TANTO PELA GERACAO QUANTO PELA ALTERACAO DO PEDIDO */
            IF  v-log-ckd = YES THEN DO:
    
                FIND int-pedido-compr EXCLUSIVE-LOCK
                    WHERE int-pedido-compr.num-pedido = ttpedido-compr.num-pedido NO-ERROR.
    
                IF  AVAIL int-pedido-compr
                THEN DO:
                    ASSIGN int-pedido-compr.log-ckd         = YES
                           int-pedido-compr.cod-produto     = v-cod-produto
                           int-pedido-compr.qtd-pedido-ckd  = v-qtd-pedido
                           int-pedido-compr.tp-pedido       = 10  /* CKD Comum */
                           INT-PEDIDO-COMPR.COD-PRODUTO-CKD = v-cod-produto.
    
                    IF  v-log-amostra = YES
                    THEN
                        ASSIGN int-pedido-compr.tp-pedido = 11. /* CKD Amostra */
                END.
            END.

            IF v-log-hml THEN DO:
                FIND FIRST int-pedido-compr EXCLUSIVE-LOCK
                     WHERE int-pedido-compr.num-pedido = ttpedido-compr.num-pedido NO-ERROR.

                IF AVAIL int-pedido-compr THEN
                    ASSIGN int-pedido-compr.tp-pedido = 4. /* HML */
            END.
    
            /* nao apresentou erro gravaremos os comentarios do pedido de compra na alteracao do pedido */
            IF  c-tipo-evento = "AlterarPedido" THEN DO:  
    
                 ASSIGN TTPEDIDO-COMPR.COMENTARIOS = ttpedido-compr.comentarios:SCREEN-VALUE IN FRAME FPAGE2.
                 FIND FIRST b-pedido-compr WHERE
                            b-pedido-compr.num-pedido = ttpedido-compr.num-pedido EXCLUSIVE-LOCK NO-ERROR.
                 IF AVAIL   b-pedido-compr THEN DO:
                    ASSIGN  b-pedido-compr.comentarios = ttpedido-compr.comentarios.
                 END.
        
            END.
    
            IF  c-tipo-evento = "GerarPedido" THEN DO:
    
                /* PROCESSO DE IMPORTACAO */
                IF  tg-proc-imp THEN DO:
    
                    ASSIGN v-log-desfaz = NO.
                    IF  VALID-HANDLE(h-acomp)
                    THEN
                        RUN pi-acompanhar in h-acomp (input "Gerando processo de importa‡Æo").
    
                    RUN pi-processo-importacao (OUTPUT v-log-desfaz).
    
                    if  v-log-desfaz = YES
                    then do:
                        IF  VALID-HANDLE(h-acomp)
                        THEN DO:
                            RUN pi-finalizar IN h-acomp.
                            ASSIGN h-acomp = ?.
                        END.
                        ASSIGN v-log-erro = YES.
                        UNDO, LEAVE.  
                    end.    
                END.
    
                /* GERACAO DE EMBARQUE */
                IF  tg-gera-emb THEN DO:
    
                    IF  VALID-HANDLE(h-acomp)
                    THEN
                        RUN pi-acompanhar in h-acomp (input "Gerando embarque").
                    RUN pi-gera-embarque (OUTPUT v-log-desfaz).
                    if  v-log-desfaz = YES
                    then do:
                        RUN pi-finalizar IN h-acomp.
                        ASSIGN v-log-erro = YES.
                        UNDO, LEAVE.  
                    end.  
                END.
            END. /* IF  c-tipo-evento = "GerarPedido" */
    
            IF  v-log-erro = YES
            THEN
                UNDO, LEAVE.

            ASSIGN c-pedidos-gerados = c-pedidos-gerados + STRING(ttpedido-compr.num-pedido) + CHR(10).
        END. /*for each tt-componete*/
        IF VALID-HANDLE(h-acomp) THEN DO:
             RUN pi-finalizar IN h-acomp.
             ASSIGN h-acomp = ?.
        END.
    END. /* DO TRANS ON ERROR UNDO, LEAVE: */

    IF VALID-HANDLE(h-acomp) 
    THEN DO:
         RUN pi-finalizar IN h-acomp.
         ASSIGN h-acomp = ?.
    END.

    IF  v-log-erro = YES
    THEN
        RETURN "NOK".
    ELSE
        RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValida wMaintenanceNoNavigation 
PROCEDURE piValida PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def var l-inform-cond-especif as logi no-undo.
    def var iNumNewPedido as int no-undo.
    
    assign input frame fPage0 {&page0Fields}.                                        
    assign input frame fPage1 {&page1Fields}.                                        
    assign input frame fPage2 {&page2Fields}.  
    
    assign ttpedido-compr.end-entrega  = fi-cod-estab
           ttpedido-compr.end-cobranca = fi-cod-estab
           ttpedido-compr.emergencial  = YES
           ttpedido-compr.via-transp   = {adinc/i01ad268.i 06 cb-via-transp}.

    run emptyRowErrors  in {&hDBOTable}.
    EMPTY TEMP-TABLE RowErrors.
    if  ttpedido-compr.cod-cond-pag = 0 then do:

        run emptyRowErrors in {&hDBOTable}.
        run validaCondicaoEspecifica in {&hDBOTable} (input  no, /* par³metro usado na WEB */
                                                      input  ttpedido-compr.num-pedido,
                                                      input  ttpedido-compr.cod-cond-pag,
                                                      input  yes, /* carregou cond-especif */
                                                      output l-inform-cond-especif).

        /*--- Mostra os erros ocorridos nas validacoes acima ---*/
        run getRowErrors in {&hDBOTable} ( output table RowErrors ).
        run ShowErrorsDBO.
        
        if  return-value = "NOK":U then
            return "NOK":U.  
    end.

    run emptyRowErrors in {&hDBOTable}.
    run validateCreatePedEmerg in {&hDBOTable} (input table ttpedido-compr, output iNumNewPedido).

    find first moeda no-lock
        where moeda.mo-codigo = fi-mo-codigo no-error.
        
    if not avail moeda then do:
        {utp/ut-table.i mgcad moeda 1}
        RUN _insertError IN {&hDBOTable} (INPUT 2,
                                          INPUT "EMS":U,
                                          INPUT "ERROR":U,
                                          INPUT return-value).    
    
    end.    

    find first deposito no-lock
        WHERE deposito.cod-depos = c-dep-almox:SCREEN-VALUE IN FRAME fpage1 no-error.
        
    if not avail deposito then do:
        {utp/ut-table.i mgcad deposito 1}
        RUN _insertError IN {&hDBOTable} (INPUT 2,
                                          INPUT "EMS":U,
                                          INPUT "ERROR":U,
                                          INPUT return-value).    
    
    end.      

    find first requisitante 
        where requisitante.nome-abrev = input frame fPage1 fi-requisitante
        no-lock no-error.
        
    if not avail requisitante then do:
        {utp/ut-table.i mgind requisitante 1}
        RUN _insertError IN {&hDBOTable} (INPUT 47,
                                          INPUT "EMS":U,
                                          INPUT "ERROR":U,
                                          INPUT return-value).    
    end.   
   
    find first comprador 
        where comprador.cod-comprado = input frame fPage1 fi-cod-comprado
        no-lock no-error.
        
    if not avail comprador then do:
        RUN _insertError IN {&hDBOTable} (INPUT 5936,
                                          INPUT "EMS":U,
                                          INPUT "ERROR":U,
                                          INPUT "").    
    end.   

    find first tipo-rec-desp 
        where tipo-rec-desp.tp-codigo = fi-tp-despesa no-lock no-error.
        
    if  not available tipo-rec-desp then do:
        {utp/ut-table.i mgadm tipo-rec-desp 1}
        RUN _insertError IN {&hDBOTable} (INPUT 2,
                                          INPUT "EMS":U,
                                          INPUT "ERROR":U,
                                          INPUT return-value).    
    end.
    else do:
        if  tipo-rec-desp.tipo = 1 then do:
            RUN _insertError IN {&hDBOTable} (INPUT 4269,
                                              INPUT "EMS":U,
                                              INPUT "ERROR":U,
                                              INPUT "").    
        end.
    end.

    /*--- Mostra os erros ocorridos nas validacoes acima ---*/
    run getRowErrors in {&hDBOTable} ( output table RowErrors ).
    run ShowErrorsDBO.
    
    if  return-value = "NOK":U then do:
        if iNumNewPedido <> 0 then assign ttpedido-compr.num-pedido:screen-value in frame fPage0 = string(iNumNewPedido).
        return "NOK":U.
    end.
    
    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveParentFields wMaintenanceNoNavigation 
PROCEDURE saveParentFields :
/*:T------------------------------------------------------------------------------
  Purpose:     Salva valores dos campos da tabela filho ({&ttTable}) com base 
               nos campos da tabela pai ({&ttParent})
  Parameters:  
  Notes:       Este m²todo somente ² executado quando a variÿvel pcAction 
               possuir os valores ADD ou COPY
------------------------------------------------------------------------------*/
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setDefaultsCotacao wMaintenanceNoNavigation 
PROCEDURE setDefaultsCotacao PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def var l-discard as logi no-undo.
    def var c-cod-comprado as char no-undo.
    
    run emptyRowObject in hboin082sd.
    
    c-cod-comprado = tt-ordem-compra.cod-comprado.

    

    run preparaCotacaoOrdemCompraPedEmerg in hboin082sd (input  tt-ordem-compra.numero-ordem,  
                                                         input  ttpedido-compr.num-pedido, 
                                                         input  tt-ordem-compra.cod-emitente,  
                                                         input  tt-ordem-compra.it-codigo,
                                                         input  tt-ordem-compra.cod-estabel,
                                                         input  tt-ordem-compra.qt-solic,
                                                         input  tt-prazo-compra.data-entrega,  
                                                         input-output c-cod-comprado,
                                                         output l-discard,
                                                         output l-discard,
                                                         output l-discard,
                                                         output l-discard,
                                                         output l-discard,
                                                         output l-discard,  
                                                         output table ttcotacao-item).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ShowErrorsDBO wMaintenanceNoNavigation 
PROCEDURE ShowErrorsDBO PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*    session:set-wait-state("":U).*/

    if  can-find(first RowErrors) then  do:
        IF VALID-HANDLE(h-acomp) 
        THEN DO:
             RUN pi-finalizar IN h-acomp.
             ASSIGN h-acomp = ?.
        END.

        {method/ShowMessage.i1}

        /*--- Seta cursor do mouse para normal ---*/
/*        SESSION:SET-WAIT-STATE("":U).*/

        /*--- Transfere temp-table RowErrors para a tela de mensagens de erros ---*/
        {method/ShowMessage.i2}

/*        wait-for close of hShowMsg.*/
    end.

    return (if can-find(first rowErrors 
                        where RowErrors.errorSubType = "ERROR":U) then "NOK":U
            else "OK":U).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

