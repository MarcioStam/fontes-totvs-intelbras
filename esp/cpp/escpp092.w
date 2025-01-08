&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wReport
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wReport 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESCPP092 1.00.00.000}

/* Chamada a include do gerenciador de licenáas. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESCPP092
&GLOBAL-DEFINE Version        1.00.00.000
&GLOBAL-DEFINE VersionLayout  

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Pedido,OP,Digitaá∆o,Impress∆o

&GLOBAL-DEFINE PGLAY          NO
&GLOBAL-DEFINE PGSEL          NO
&GLOBAL-DEFINE PGCLA          YES
&GLOBAL-DEFINE PGPAR          YES
&GLOBAL-DEFINE PGDIG          YES
&GLOBAL-DEFINE PGIMP          YES
&GLOBAL-DEFINE PGLOG          NO

&GLOBAL-DEFINE RTF            NO

&GLOBAL-DEFINE page0Widgets   btOk ~
                              btCancel ~
                              btHelp2
&GLOBAL-DEFINE page3Widgets   cb-natureza cb-frete cb-via-transp
&GLOBAL-DEFINE page4Widgets   
&GLOBAL-DEFINE page5Widgets   brDigita ~
                              btAdd ~
                              btUpdate ~
                              btDelete ~
                              btSave ~
                              btOpen
&GLOBAL-DEFINE page6Widgets   rsDestiny ~
                              btConfigImpr ~
                              btFile ~
                              rsExecution
&GLOBAL-DEFINE page0Text      
&GLOBAL-DEFINE page4Text      
&GLOBAL-DEFINE page5Text      
&GLOBAL-DEFINE page6Text      text-destino text-modo

&GLOBAL-DEFINE page3Fields    fi-fornec fi-cod-emitente fi-cod-processo fi-cod-transp fi-cod-estab-entrega ~
                              fi-cod-estab-cobranca fi-cod-cond-pag fi-responsavel fi-mensagem fi-cod-estab-gestor
&GLOBAL-DEFINE page4Fields    fi-nr-lin-prod fi-cod-depos fi-ct-codigo fi-sc-codigo
&GLOBAL-DEFINE page5Fields    
&GLOBAL-DEFINE page6Fields    cFile

&GLOBAL-DEFINE hDBOTable      hboin295


/* Parameters Definitions ---                                           */

{esp/cpp/escpp092.i} /* tt-param / tt-digita */

define buffer b-tt-digita for tt-digita.

/* Transfer Definitions */

def var raw-param        as raw no-undo.

def var l-ok               as logical no-undo.
def var c-arq-digita       as char    no-undo.
def var c-terminal         as char    no-undo.
def var c-rtf              as char    no-undo.
def var c-arq-layout       as char    no-undo.      
def var c-arq-temp         as char    no-undo.
DEF VAR c-modelo-default   AS CHAR    NO-UNDO.

def stream s-imp.

/*15/02/2005 - tech1007 - Variavel definida para tratar se o programa est† rodando no WebEnabler*/
DEFINE SHARED VARIABLE hWenController AS HANDLE NO-UNDO.


DEFINE VARIABLE {&hDBOTable} AS HANDLE NO-UNDO.
DEFINE VARIABLE hboin295desc AS HANDLE      NO-UNDO.
DEFINE VARIABLE hboin057 AS HANDLE      NO-UNDO.
DEFINE VARIABLE hboin274sd AS HANDLE      NO-UNDO.
DEFINE VARIABLE hboin082sd AS HANDLE      NO-UNDO.
DEFINE VARIABLE hboin256ca AS HANDLE      NO-UNDO.
DEFINE VARIABLE hboin082ca AS HANDLE      NO-UNDO.

/**/


{upc/btb910za-upc.i}
def shared var s-it-codigo like item.it-codigo no-undo.
def shared var s-l-ok as logi no-undo.
{cdp/cdcfgmat.i}
{cdp/cdcfgman.i}
{ccp/ccapi202.i}
{ccp/ccapi207.i}   
{cdp/cdapi300.i1}
{cdp/cd4300.i3}

{include/i_dbvers.i}
{include/i_fnctrad.i}

{cdp/cd9731.i6}

{cdp/cdcfgmnt.i} /*Vers‰es EMS MNT */
{cdp/cd9911.i}   /*Unidade de Nerg¢cio*/


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

def var h-acomp      as handle no-undo.
DEF VAR h-bocx341  AS HANDLE NO-UNDO.
DEF VAR h-bocx225  AS HANDLE NO-UNDO.
DEFINE VARIABLE hboin356ca AS HANDLE      NO-UNDO.
def var hDBOCotacao-itemi as handle no-undo.
def var c-nom-emit          as char no-undo.
def var c-cgc-emit          as char no-undo.
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
def var c-desc-cond-pag     as char no-undo.
def var c-desc-responsavel  as char no-undo.
def var c-desc-mensagem     as char no-undo.
def var c-desc-transp       as char no-undo.
DEFINE VARIABLE c-desc-end-cobranca AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-desc-end-entrega AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-desc-gestor AS CHARACTER   NO-UNDO.
def var i-via-transp        as int  no-undo.
def var i-emit-terc         as int  no-undo.
def var i-cod-transp        as int  no-undo.
def var i-cod-cond-pag      as int  no-undo.
DEFINE VARIABLE i-ant-aux-forn AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-ant-forn-zoom AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-natureza AS INTEGER     NO-UNDO.
def var c-desp              as char no-undo.
DEF VAR v-log-amostra       AS  LOG NO-UNDO.
DEF VAR v-cod-produto       AS CHAR NO-UNDO.
DEF VAR v-cod-emitente      AS  INT NO-UNDO.
DEF VAR v-log-desfaz        AS  LOG NO-UNDO.
DEF VAR v-qtd-pedido        AS  DEC NO-UNDO.
DEF VAR v-log-ckd           AS  LOG NO-UNDO.

DEF VAR v-cod-incoterm-tmp LIKE emitente-cex.cod-incoterm-imp  NO-UNDO.
DEF VAR v-cod-itiner-tmp   LIKE emitente-cex.cod-itiner-imp    NO-UNDO.

def var v_cod_cta_ctbl                  as char     no-undo.
def var v_des_cta_ctbl                  as char     no-undo.
def var v_log_utz_ccusto                as logical  no-undo.
def var v_des_ccusto                    as char     no-undo.
DEF VAR c-empresa                       AS CHAR     NO-UNDO.
DEF VAR v_cod_formato                   AS CHAR     NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE gr-estabelec AS ROWID NO-UNDO.

DEFINE VARIABLE c-desc-item AS CHARACTER    FORMAT "X(30)"   NO-UNDO.
DEFINE VARIABLE l-prim AS LOGICAL     NO-UNDO.
DEFINE VARIABLE c-aux AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-linha AS CHARACTER   NO-UNDO.
DEFINE VARIABLE h-boin082sd AS HANDLE      NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brDigita

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-digita

/* Definitions for BROWSE brDigita                                      */
&Scoped-define FIELDS-IN-QUERY-brDigita tt-digita.it-codigo tt-digita.desc-item tt-digita.quantidade tt-digita.preco   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brDigita tt-digita.it-codigo tt-digita.quantidade tt-digita.preco   
&Scoped-define ENABLED-TABLES-IN-QUERY-brDigita tt-digita
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-brDigita tt-digita
&Scoped-define SELF-NAME brDigita
&Scoped-define QUERY-STRING-brDigita FOR EACH tt-digita
&Scoped-define OPEN-QUERY-brDigita OPEN QUERY brDigita FOR EACH tt-digita.
&Scoped-define TABLES-IN-QUERY-brDigita tt-digita
&Scoped-define FIRST-TABLE-IN-QUERY-brDigita tt-digita


/* Definitions for FRAME fPage5                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage5 ~
    ~{&OPEN-QUERY-brDigita}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar btOK btCancel btHelp2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD f-desc-item wReport 
FUNCTION f-desc-item RETURNS CHARACTER
  ( INPUT p-it-codigo AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD f-item-uni-estab wReport 
FUNCTION f-item-uni-estab RETURNS char (input c-it-codigo as char,
              input c-cod-estabel as char,
              input c-campo       as char) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD f-preco-item wReport 
FUNCTION f-preco-item RETURNS DECIMAL
  ( INPUT p-cod-emitente AS INTEGER,
    INPUT p-it-codigo AS CHAR,
    INPUT p-qtd-tot AS DEC,
    INPUT p-cod-cond-pag AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wReport AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE MENU POPUP-MENU-cod-emitente 
       MENU-ITEM m_Zoom_FornecAmbos_com_Ordens LABEL "Zoom Fornec/Ambos com Ordens Cotadas"
       MENU-ITEM m_Zoom_Fornecedor_do_Pedido_d LABEL "Zoom Fornecedor do Pedido de Compra".


/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "&Fechar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp2 
     LABEL "&Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "&Executar" 
     SIZE 10 BY 1.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE cb-frete AS CHARACTER FORMAT "X(256)":U 
     LABEL "Frete" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE cb-natureza AS CHARACTER FORMAT "X(256)":U 
     LABEL "Natureza" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE cb-via-transp AS CHARACTER FORMAT "X(256)":U 
     LABEL "Via Transporte" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE fi-cod-cond-pag AS INTEGER FORMAT ">>>9":U INITIAL 0 
     LABEL "Condiá∆o de Pagamento" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-emitente AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "Emitente Entrega" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-estab-cobranca AS CHARACTER FORMAT "X(5)":U 
     LABEL "Est Cobranáa" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-estab-entrega AS CHARACTER FORMAT "X(5)":U 
     LABEL "Est Entrega" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-estab-gestor AS CHARACTER FORMAT "X(5)":U 
     LABEL "Estabel Gestor" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-processo AS INTEGER FORMAT "999,999":U INITIAL 0 
     LABEL "Processo" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-transp AS INTEGER FORMAT ">>,>>9":U INITIAL 0 
     LABEL "Transportador" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-cond-pag AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 37 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-emitente AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 32 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-est-cobranca AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 34 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-est-entrega AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 34 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-estab-gestor AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 34 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-fornec AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 32 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-mensagem AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 37 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-processo AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 32 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-responsavel AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 34 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-transp AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 32 BY .88 NO-UNDO.

DEFINE VARIABLE fi-fornec AS INTEGER FORMAT ">>>>>>>>9" INITIAL 0 
     LABEL "Fornecedor" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88.

DEFINE VARIABLE fi-mensagem AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "Mensagem" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE fi-responsavel AS CHARACTER FORMAT "X(12)":U 
     LABEL "Respons†vel" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 63 BY 13.5.

DEFINE VARIABLE fi-cod-depos AS CHARACTER FORMAT "X(3)":U INITIAL "REC" 
     LABEL "Dep¢sito" 
     VIEW-AS FILL-IN 
     SIZE 5.86 BY .88 NO-UNDO.

DEFINE VARIABLE fi-ct-codigo AS CHARACTER FORMAT "x(20)" 
     LABEL "Conta" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88.

DEFINE VARIABLE fi-desc-ccusto AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 26.72 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-conta AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 26.72 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nr-lin-prod AS INTEGER FORMAT ">>9":U INITIAL 10 
     LABEL "Linha Produá∆o" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE fi-sc-codigo AS CHARACTER FORMAT "x(20)" 
     LABEL "Sub-Conta" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88.

DEFINE RECTANGLE RECT-16
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 73 BY 13.25.

DEFINE BUTTON btAdd 
     LABEL "Inserir" 
     SIZE 15 BY 1
     FONT 1.

DEFINE BUTTON btDelete 
     LABEL "Retirar" 
     SIZE 15 BY 1
     FONT 1.

DEFINE BUTTON btOpen 
     LABEL "Recuperar" 
     SIZE 15 BY 1
     FONT 1.

DEFINE BUTTON btSave 
     LABEL "Salvar" 
     SIZE 15 BY 1
     FONT 1.

DEFINE BUTTON btUpdate 
     LABEL "Alterar" 
     SIZE 15 BY 1
     FONT 1.

DEFINE VARIABLE ed-modelo AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 82 BY 2.63 NO-UNDO.

DEFINE BUTTON btConfigImpr 
     IMAGE-UP FILE "image\im-cfprt":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON btFile 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE VARIABLE cFile AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 256
     SIZE 40 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE text-destino AS CHARACTER FORMAT "X(256)":U INITIAL " Destino" 
      VIEW-AS TEXT 
     SIZE 8.14 BY .63
     FONT 1 NO-UNDO.

DEFINE VARIABLE text-modo AS CHARACTER FORMAT "X(256)":U INITIAL "Execuá∆o" 
      VIEW-AS TEXT 
     SIZE 10.86 BY .63
     FONT 1 NO-UNDO.

DEFINE VARIABLE rsDestiny AS INTEGER INITIAL 3 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Impressora", 1,
"Arquivo", 2,
"Terminal", 3
     SIZE 44 BY 1.08
     FONT 1 NO-UNDO.

DEFINE VARIABLE rsExecution AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "On-Line", 1,
"Batch", 2
     SIZE 27.86 BY .92
     FONT 1 NO-UNDO.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.14 BY 2.92.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.14 BY 1.71.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brDigita FOR 
      tt-digita SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brDigita
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brDigita wReport _FREEFORM
  QUERY brDigita DISPLAY
      tt-digita.it-codigo   COLUMN-LABEL "Item"     WIDTH 10
tt-digita.desc-item         COLUMN-LABEL "Descriá∆o" WIDTH 35
tt-digita.quantidade        COLUMN-LABEL "Quantidade"   WIDTH 15
tt-digita.preco             COLUMN-LABEL "Preáo"    WIDTH 15
ENABLE
tt-digita.it-codigo
tt-digita.quantidade
tt-digita.preco
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS SIZE 82 BY 12.5
         BGCOLOR 15 FONT 1.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btOK AT ROW 21.5 COL 1.86
     btCancel AT ROW 21.5 COL 13
     btHelp2 AT ROW 21.5 COL 80
     rtToolBar AT ROW 21.25 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 21.88
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage4
     fi-nr-lin-prod AT ROW 1.5 COL 25 COLON-ALIGNED WIDGET-ID 52
     fi-cod-depos AT ROW 2.5 COL 25 COLON-ALIGNED WIDGET-ID 54
     fi-ct-codigo AT ROW 3.5 COL 25 COLON-ALIGNED WIDGET-ID 60
     fi-desc-conta AT ROW 3.5 COL 43 COLON-ALIGNED NO-LABEL WIDGET-ID 66
     fi-sc-codigo AT ROW 4.5 COL 25 COLON-ALIGNED WIDGET-ID 62
     fi-desc-ccusto AT ROW 4.5 COL 43 COLON-ALIGNED NO-LABEL WIDGET-ID 64
     RECT-16 AT ROW 1 COL 6 WIDGET-ID 58
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.79
         SIZE 84.43 BY 14.71
         FONT 1 WIDGET-ID 200.

DEFINE FRAME fPage5
     brDigita AT ROW 1.25 COL 1
     btAdd AT ROW 13.75 COL 1
     btUpdate AT ROW 13.75 COL 16
     btDelete AT ROW 13.75 COL 31
     btSave AT ROW 13.75 COL 46
     btOpen AT ROW 13.75 COL 61
     ed-modelo AT ROW 15.5 COL 2 NO-LABEL WIDGET-ID 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.79
         SIZE 84.43 BY 17.71
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage6
     rsDestiny AT ROW 2.38 COL 3.14 HELP
          "Destino de Impress∆o do Relat¢rio" NO-LABEL
     cFile AT ROW 3.63 COL 3.14 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL
     btFile AT ROW 3.5 COL 43 HELP
          "Escolha do nome do arquivo"
     btConfigImpr AT ROW 3.5 COL 43 HELP
          "Configuraá∆o da impressora"
     rsExecution AT ROW 6.25 COL 2.86 HELP
          "Modo de Execuá∆o" NO-LABEL
     text-destino AT ROW 1.63 COL 1.86 COLON-ALIGNED NO-LABEL
     text-modo AT ROW 5.5 COL 1.14 COLON-ALIGNED NO-LABEL
     RECT-7 AT ROW 1.92 COL 2.14
     RECT-9 AT ROW 5.75 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.79
         SIZE 84.43 BY 14.71
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage3
     fi-fornec AT ROW 1.25 COL 27 COLON-ALIGNED WIDGET-ID 60
     fi-desc-fornec AT ROW 1.25 COL 38 COLON-ALIGNED NO-LABEL WIDGET-ID 32
     fi-cod-emitente AT ROW 2.25 COL 27 COLON-ALIGNED WIDGET-ID 4
     fi-desc-emitente AT ROW 2.25 COL 38 COLON-ALIGNED NO-LABEL WIDGET-ID 34
     cb-natureza AT ROW 3.25 COL 27 COLON-ALIGNED WIDGET-ID 8
     fi-cod-processo AT ROW 4.25 COL 27 COLON-ALIGNED WIDGET-ID 6
     fi-desc-processo AT ROW 4.25 COL 38 COLON-ALIGNED NO-LABEL WIDGET-ID 36
     cb-frete AT ROW 5.25 COL 27 COLON-ALIGNED WIDGET-ID 14
     fi-cod-transp AT ROW 6.25 COL 27 COLON-ALIGNED WIDGET-ID 16
     fi-desc-transp AT ROW 6.25 COL 38 COLON-ALIGNED NO-LABEL WIDGET-ID 38
     cb-via-transp AT ROW 7.25 COL 27 COLON-ALIGNED WIDGET-ID 18
     fi-cod-estab-entrega AT ROW 8.25 COL 27 COLON-ALIGNED WIDGET-ID 20
     fi-desc-est-entrega AT ROW 8.25 COL 36 COLON-ALIGNED NO-LABEL WIDGET-ID 40
     fi-cod-estab-cobranca AT ROW 9.25 COL 27 COLON-ALIGNED WIDGET-ID 22
     fi-desc-est-cobranca AT ROW 9.25 COL 36 COLON-ALIGNED NO-LABEL WIDGET-ID 42
     fi-cod-cond-pag AT ROW 10.25 COL 27 COLON-ALIGNED WIDGET-ID 24
     fi-desc-cond-pag AT ROW 10.25 COL 33 COLON-ALIGNED NO-LABEL WIDGET-ID 44
     fi-responsavel AT ROW 11.25 COL 27 COLON-ALIGNED WIDGET-ID 26
     fi-desc-responsavel AT ROW 11.25 COL 36 COLON-ALIGNED NO-LABEL WIDGET-ID 46
     fi-mensagem AT ROW 12.25 COL 27 COLON-ALIGNED WIDGET-ID 28
     fi-desc-mensagem AT ROW 12.25 COL 33 COLON-ALIGNED NO-LABEL WIDGET-ID 48
     fi-cod-estab-gestor AT ROW 13.25 COL 27 COLON-ALIGNED WIDGET-ID 30
     fi-desc-estab-gestor AT ROW 13.25 COL 36 COLON-ALIGNED NO-LABEL WIDGET-ID 50
     RECT-13 AT ROW 1 COL 10 WIDGET-ID 56
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.79
         SIZE 84.43 BY 14.71
         FONT 1 WIDGET-ID 100.


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
  CREATE WINDOW wReport ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 21.88
         WIDTH              = 90
         MAX-HEIGHT         = 22
         MAX-WIDTH          = 114.14
         VIRTUAL-HEIGHT     = 22
         VIRTUAL-WIDTH      = 114.14
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wReport 
/* ************************* Included-Libraries *********************** */

{report/report.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wReport
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME fPage3:FRAME = FRAME fpage0:HANDLE
       FRAME fPage4:FRAME = FRAME fpage0:HANDLE
       FRAME fPage5:FRAME = FRAME fpage0:HANDLE
       FRAME fPage6:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   NOT-VISIBLE FRAME-NAME                                               */
/* SETTINGS FOR FRAME fPage3
                                                                        */
ASSIGN 
       fi-fornec:POPUP-MENU IN FRAME fPage3       = MENU POPUP-MENU-cod-emitente:HANDLE.

/* SETTINGS FOR FRAME fPage4
                                                                        */
/* SETTINGS FOR FRAME fPage5
                                                                        */
/* BROWSE-TAB brDigita 1 fPage5 */
/* SETTINGS FOR FRAME fPage6
   Custom                                                               */
ASSIGN 
       text-destino:PRIVATE-DATA IN FRAME fPage6     = 
                "Destino".

ASSIGN 
       text-modo:PRIVATE-DATA IN FRAME fPage6     = 
                "Execuá∆o".

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wReport)
THEN wReport:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brDigita
/* Query rebuild information for BROWSE brDigita
     _START_FREEFORM
OPEN QUERY brDigita FOR EACH tt-digita.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE brDigita */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage6
/* Query rebuild information for FRAME fPage6
     _Query            is NOT OPENED
*/  /* FRAME fPage6 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wReport
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wReport wReport
ON END-ERROR OF wReport
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wReport wReport
ON WINDOW-CLOSE OF wReport
DO:
  /* This event will close the window and terminate the procedure.  */
  {report/logfin.i}  
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brDigita
&Scoped-define FRAME-NAME fPage5
&Scoped-define SELF-NAME brDigita
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigita wReport
ON DEL OF brDigita IN FRAME fPage5
DO:
   apply 'choose' to btDelete in frame fPage5.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigita wReport
ON END-ERROR OF brDigita IN FRAME fPage5
ANYWHERE 
DO:
    if  brDigita:new-row in frame fPage5 then do:
        if  avail tt-digita then
            delete tt-digita.
        if  brDigita:delete-current-row() in frame fPage5 then. 
    end.                                                               
    else do:
        get current brDigita.
        display tt-digita.it-codigo
                tt-digita.quantidade
                tt-digita.preco
             with browse brDigita. 
    end.
    return no-apply.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigita wReport
ON ENTER OF brDigita IN FRAME fPage5
ANYWHERE
DO:
  apply 'tab' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigita wReport
ON INS OF brDigita IN FRAME fPage5
DO:
   apply 'choose' to btAdd in frame fPage5.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigita wReport
ON OFF-END OF brDigita IN FRAME fPage5
DO:
   apply 'entry' to btAdd in frame fPage5.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigita wReport
ON OFF-HOME OF brDigita IN FRAME fPage5
DO:
  apply 'entry' to btOpen in frame fPage5.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigita wReport
ON ROW-ENTRY OF brDigita IN FRAME fPage5
DO:
   /*:T trigger para inicializar campos da temp table de digitaá∆o */
    /*
   if  brDigita:new-row in frame fPage5 then do:
       assign tt-digita.exemplo:screen-value in browse brDigita = string(today, "99/99/9999":U).
   end.
   */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigita wReport
ON ROW-LEAVE OF brDigita IN FRAME fPage5
DO:
    /*:T ê aqui que a gravaá∆o da linha da temp-table Ç efetivada.
       PorÇm as validaá‰es dos registros devem ser feitas na procedure pi-executar,
       no local indicado pelo coment†rio */
    
    if brDigita:NEW-ROW in frame fPage5 then 
    do transaction on error undo, return no-apply:
        create tt-digita.
        assign input browse brDigita tt-digita.it-codigo
               input browse brDigita tt-digita.quantidade
               INPUT BROWSE brDigita tt-digita.preco.

        brDigita:CREATE-RESULT-LIST-ENTRY() in frame fPage5.
    end.
    else do transaction on error undo, return no-apply:
        if avail tt-digita then
            assign input browse brDigita tt-digita.it-codigo
                   input browse brDigita tt-digita.quantidade
                   input browse brDigita tt-digita.preco.             
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btAdd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAdd wReport
ON CHOOSE OF btAdd IN FRAME fPage5 /* Inserir */
DO:
    assign btUpdate:SENSITIVE in frame fPage5 = yes
           btDelete:SENSITIVE in frame fPage5 = yes
           btSave:SENSITIVE   in frame fPage5 = yes.
    
    if num-results("brDigita":U) > 0 then
        brDigita:INSERT-ROW("after":U) in frame fPage5.
    else do transaction:
        create tt-digita.
        
        open query brDigita for each tt-digita.
        
        apply "entry":U to tt-digita.it-codigo in browse brDigita. 
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wReport
ON CHOOSE OF btCancel IN FRAME fpage0 /* Fechar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage6
&Scoped-define SELF-NAME btConfigImpr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btConfigImpr wReport
ON CHOOSE OF btConfigImpr IN FRAME fPage6
DO:
   {report/rpimp.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage5
&Scoped-define SELF-NAME btDelete
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDelete wReport
ON CHOOSE OF btDelete IN FRAME fPage5 /* Retirar */
DO:
    if  brDigita:num-selected-rows > 0 then do on error undo, return no-apply:
        get current brDigita.
        delete tt-digita.
        if  brDigita:delete-current-row() in frame fPage5 then.
    end.
    
    if num-results("brDigita":U) = 0 then
        assign btUpdate:SENSITIVE in frame fPage5 = no
               btDelete:SENSITIVE in frame fPage5 = no
               btSave:SENSITIVE   in frame fPage5 = no.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage6
&Scoped-define SELF-NAME btFile
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFile wReport
ON CHOOSE OF btFile IN FRAME fPage6
DO:
    {report/rparq.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btHelp2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp2 wReport
ON CHOOSE OF btHelp2 IN FRAME fpage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wReport
ON CHOOSE OF btOK IN FRAME fpage0 /* Executar */
DO:
   do  on error undo, return no-apply:
       run piExecute.
   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage5
&Scoped-define SELF-NAME btOpen
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOpen wReport
ON CHOOSE OF btOpen IN FRAME fPage5 /* Recuperar */
DO:
    /*{report/rprcd.i}*/
    
    SYSTEM-DIALOG GET-FILE c-arq-digita
       FILTERS "*.csv":U "*.csv":U,
               "*.*":U "*.*":U
       DEFAULT-EXTENSION "*.csv":U
       MUST-EXIST
       USE-FILENAME
       UPDATE l-ok.
    
    if l-ok then do:

        ASSIGN l-prim = TRUE.

        for each tt-digita:
            delete tt-digita.
        end.

        input from value(c-arq-digita) no-echo.

        repeat:             

            IF l-prim THEN DO:
                IMPORT c-aux.
                ASSIGN l-prim = FALSE.
            END.
            ELSE DO:
                create tt-digita.
                /*import DELIMITER ";" tt-digita.*/
                IMPORT c-linha.

                ASSIGN tt-digita.it-codigo  = ENTRY(1, c-linha, ";")
                       tt-digita.quantidade = dec(ENTRY(2, c-linha, ";"))
                       tt-digita.preco      = dec(ENTRY(3, c-linha, ";")) NO-ERROR.

                IF ERROR-STATUS:ERROR THEN DO:

                    INPUT CLOSE.

                    FOR EACH tt-digita:
                        DELETE tt-digita.
                    END.

                    RUN utp/ut-msgs.p (INPUT "show",
                                       INPUT 17006,
                                       INPUT "Erro na importaá∆o doo arquivo. Verifique se os campos numÇricos n∆o est∆o com valores alfabÇticos.").

                    RETURN NO-APPLY.

                END.
            END.

        end.    

        input close. 
        
        delete tt-digita.

        FOR EACH tt-digita:

            FOR FIRST ITEM NO-LOCK
                WHERE ITEM.it-codigo = tt-digita.it-codigo:

                ASSIGN tt-digita.desc-item = ITEM.desc-item.

            END.

            IF tt-digita.preco = 0 THEN DO:

                ASSIGN tt-digita.preco = f-preco-item(INPUT INPUT FRAME fPage3 fi-fornec,         /*int*/
                                                      INPUT tt-digita.it-codigo,                  /*char*/
                                                      INPUT tt-digita.quantidade,                 /*dec*/
                                                      INPUT INPUT FRAME fPage3 fi-cod-cond-pag). /*int*/

            END.

        END.
        
        open query brDigita for each tt-digita.
        
        if num-results("brDigita":U) > 0 then 
            assign btUpdate:SENSITIVE in frame fPage5 = yes
                   btDelete:SENSITIVE in frame fPage5 = yes
                   btSave:SENSITIVE   in frame fPage5 = yes.
        else
            assign btUpdate:SENSITIVE in frame fPage5 = no
                   btDelete:SENSITIVE in frame fPage5 = no
                   btSave:SENSITIVE   in frame fPage5 = no.
    end.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave wReport
ON CHOOSE OF btSave IN FRAME fPage5 /* Salvar */
DO:
   {report/rpsvd.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btUpdate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdate wReport
ON CHOOSE OF btUpdate IN FRAME fPage5 /* Alterar */
DO:
   apply 'entry' to tt-digita.it-codigo in browse brDigita. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME fi-cod-cond-pag
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-cond-pag wReport
ON F5 OF fi-cod-cond-pag IN FRAME fPage3 /* Condiá∆o de Pagamento */
DO:
  /*--- Zoom Smart Object ---*/
    assign l-implanta = yes.  
    {include/zoomvar.i &prog-zoom="adzoom/z01ad039.w"
                       &campo=fi-cod-cond-pag
                       &campozoom=cod-cond-pag}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-cond-pag wReport
ON LEAVE OF fi-cod-cond-pag IN FRAME fPage3 /* Condiá∆o de Pagamento */
DO:

    /*
    if  input frame fPage3 fi-cod-cond-pag = 0 and not l-implanta then do:
        assign fi-desc-cond-pag:screen-value in frame fPage3 = "Condiá∆o Pagto Espec°fica".
        if l-chama-cc0300f then do:
            assign input frame fPage3 tt-pedido-compr.num-pedido
                   input frame fPage3 tt-pedido-compr.data-pedido.
            run ccp/cc0300f.w(input table tt-pedido-compr,
                              input pcAction,
                              input-output table tt-cond-especif).
            find first tt-cond-especif no-error.
            if avail tt-cond-especif THEN DO:
                assign l-carregou = yes.
                FIND CURRENT tt-pedido-compr NO-ERROR.
                IF AVAIL tt-pedido-compr THEN
                    ASSIGN tt-pedido-compr.log-2 = tt-cond-especif.log-2.
            END.
            else 
                assign l-carregou = no.
        end.
    end.
    else do:*/
        run getDescCondPag in hboin295desc ( input frame fPage3 fi-cod-cond-pag,
                                              output c-desc-cond-pag ).
        assign fi-desc-cond-pag:screen-value in frame fPage3 = c-desc-cond-pag.
    /*end.*/
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-cond-pag wReport
ON MOUSE-SELECT-DBLCLICK OF fi-cod-cond-pag IN FRAME fPage3 /* Condiá∆o de Pagamento */
DO:
  apply "f5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME fi-cod-depos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-depos wReport
ON F5 OF fi-cod-depos IN FRAME fPage4 /* Dep¢sito */
DO:
  assign l-implanta = yes.  
  {include/zoomvar.i &prog-zoom="inzoom/z01in084.w"
                     &campo=fi-cod-depos
                     &campozoom=cod-depos}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-depos wReport
ON MOUSE-SELECT-DBLCLICK OF fi-cod-depos IN FRAME fPage4 /* Dep¢sito */
DO:
   apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME fi-cod-emitente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-emitente wReport
ON F5 OF fi-cod-emitente IN FRAME fPage3 /* Emitente Entrega */
DO:

    /*--- Zoom Smart Object ---*/
    assign l-implanta = yes.  
    {include/zoomvar.i &prog-zoom="adzoom/z01ad098.w"
                       &campo=fi-cod-emitente
                       &campozoom=cod-emitente
                       &campo2=fi-desc-emitente
                       &campozoom2=nome-abrev}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-emitente wReport
ON LEAVE OF fi-cod-emitente IN FRAME fPage3 /* Emitente Entrega */
DO:

    run getDescCGCEmitente in hboin295desc ( input frame fPage3 fi-cod-emitente,
                                              output c-nom-emit,
                                              output c-cgc-emit ).

    assign fi-desc-emitente:screen-value in frame fPage3 = c-nom-emit.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-emitente wReport
ON MOUSE-SELECT-DBLCLICK OF fi-cod-emitente IN FRAME fPage3 /* Emitente Entrega */
DO:

    apply "f5":U to self.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cod-estab-cobranca
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-estab-cobranca wReport
ON F5 OF fi-cod-estab-cobranca IN FRAME fPage3 /* Est Cobranáa */
DO:

    /*--- Zoom Smart Object ---*/
    assign l-implanta = yes.  
    {include/zoomvar.i &prog-zoom="adzoom/z13ad107.w"
                       &campo=fi-cod-estab-cobranca
                       &campozoom=cod-estabel}  
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-estab-cobranca wReport
ON LEAVE OF fi-cod-estab-cobranca IN FRAME fPage3 /* Est Cobranáa */
DO:

    /*Desabilita a seguranáa por estabelecimento para esta tabela*/
    /*para que seja possivel buscar a descriá∆o do estabelecimento*/
    ON FIND OF estabelec DO: END.
    
    run getDescEstabelec in hboin295desc ( input frame fPage3 fi-cod-estab-cobranca,
                                            output c-desc-end-cobranca ).
    assign fi-desc-est-cobranca:screen-value in frame fPage3 = c-desc-end-cobranca.
    
    /*FIND param_seg_estab WHERE param_seg_estab.cdn_param = 1 NO-LOCK NO-ERROR.
    IF  AVAIL param_seg_estab
          AND param_seg_estab.des_valor = "SIM":U
          AND NOT VALID-HANDLE(h-onfind) THEN DO:
        RUN cdp/cdapi3000.p PERSISTENT SET h-onfind.
    end.*/
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-estab-cobranca wReport
ON MOUSE-SELECT-DBLCLICK OF fi-cod-estab-cobranca IN FRAME fPage3 /* Est Cobranáa */
DO:
  apply "f5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cod-estab-entrega
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-estab-entrega wReport
ON F5 OF fi-cod-estab-entrega IN FRAME fPage3 /* Est Entrega */
DO:

    /*--- Zoom Smart Object ---*/
    assign l-implanta = yes.  
    {include/zoomvar.i &prog-zoom="adzoom/z01ad107.w"
                       &campo=fi-cod-estab-entrega
                       &campozoom=cod-estabel}  
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-estab-entrega wReport
ON LEAVE OF fi-cod-estab-entrega IN FRAME fPage3 /* Est Entrega */
DO:

    run getDescEstabelec in hboin295desc ( input frame fPage3 fi-cod-estab-entrega,
                                            output c-desc-end-entrega ).
    assign fi-desc-est-entrega:screen-value in frame fPage3 = c-desc-end-entrega.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-estab-entrega wReport
ON MOUSE-SELECT-DBLCLICK OF fi-cod-estab-entrega IN FRAME fPage3 /* Est Entrega */
DO:

    apply "f5":U to self.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cod-estab-gestor
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-estab-gestor wReport
ON F5 OF fi-cod-estab-gestor IN FRAME fPage3 /* Estabel Gestor */
DO:
  /*--- Zoom Smart Object ---*/
    assign l-implanta = yes.  
    {include/zoomvar.i &prog-zoom="adzoom/z13ad107.w"
                       &campo=fi-cod-estab-gestor
                       &campozoom=cod-estabel}   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-estab-gestor wReport
ON LEAVE OF fi-cod-estab-gestor IN FRAME fPage3 /* Estabel Gestor */
DO:
  
    /*Desabilita a seguranáa por estabelecimento para esta tabela*/
    /*para que seja possivel buscar a descriá∆o do estabelecimento*/
    ON FIND OF estabelec DO: END.
    
    run getDescEstabelec in hboin295desc ( input frame fPage3 fi-cod-estab-gestor,
                                            output c-desc-gestor ).
    assign fi-desc-estab-gestor:screen-value in frame fPage3 = c-desc-gestor.  
    
    /*FIND param_seg_estab WHERE param_seg_estab.cdn_param = 1 NO-LOCK NO-ERROR.
    IF  AVAIL param_seg_estab
          AND param_seg_estab.des_valor = "SIM":U
          AND NOT VALID-HANDLE(h-onfind) THEN DO:
        RUN cdp/cdapi3000.p PERSISTENT SET h-onfind.
    end.*/

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-estab-gestor wReport
ON MOUSE-SELECT-DBLCLICK OF fi-cod-estab-gestor IN FRAME fPage3 /* Estabel Gestor */
DO:
  apply "f5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cod-processo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-processo wReport
ON F5 OF fi-cod-processo IN FRAME fPage3 /* Processo */
DO:

    /*--- Zoom Smart Object ---*/
    {include/zoomvar.i &prog-zoom="inzoom/z01in358.w"
                       &campo=fi-cod-processo
                       &campozoom=nr-processo}  
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-processo wReport
ON LEAVE OF fi-cod-processo IN FRAME fPage3 /* Processo */
DO:

    def var c-desc-process-aux as char no-undo.
    run getDescProcesso in hboin295desc ( input frame fPage3 fi-cod-processo,
                                            output c-desc-process-aux ).
    assign fi-desc-processo:screen-value in frame fPage3 = c-desc-process-aux.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-processo wReport
ON MOUSE-SELECT-DBLCLICK OF fi-cod-processo IN FRAME fPage3 /* Processo */
DO:
  apply "f5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cod-transp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-transp wReport
ON F5 OF fi-cod-transp IN FRAME fPage3 /* Transportador */
DO:
    {include/zoomvar.i &prog-zoom="adzoom/z01ad268.w"
                       &campo=fi-cod-transp
                       &campozoom=cod-transp}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-transp wReport
ON LEAVE OF fi-cod-transp IN FRAME fPage3 /* Transportador */
DO:
    run getDescViaTransp in hboin295desc ( input frame fPage3 fi-cod-transp,
                                           output c-desc-transp,
                                           output i-via-transp ).
    assign fi-desc-transp:screen-value in frame fPage3 = c-desc-transp.
    
    assign cb-via-transp:screen-value in frame fPage3 = {adinc/i01ad268.i 04 i-via-transp} no-error.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-transp wReport
ON MOUSE-SELECT-DBLCLICK OF fi-cod-transp IN FRAME fPage3 /* Transportador */
DO:

    apply "f5":U to self.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME fi-ct-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-ct-codigo wReport
ON ENTRY OF fi-ct-codigo IN FRAME fPage4 /* Conta */
DO:
    assign fi-ct-codigo:format in frame fPage4 = "x(20)".
    /* Format conta */
    assign fi-sc-codigo:sensitive in frame fPage4 = yes.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-ct-codigo wReport
ON F5 OF fi-ct-codigo IN FRAME fPage4 /* Conta */
DO:
    assign fi-ct-codigo:format in frame fPage4 = "x(20)".
    assign v_cod_cta_ctbl = fi-ct-codigo:screen-value in frame fPage4.
    /*#### BUSCA #####*/
    run pi_zoom_cta_ctbl_integr in h_api_cta_ctbl (input  c-empresa,          /* EMPRESA EMS2 */
                                                   input  "CEP",              /* M‡DULO */
                                                   input  "",                 /* PLANO DE CONTAS */
                                                   input  "(nenhum)",         /* FINALIDADES */
                                                   input  TODAY,              /* DATA TRANSACAO */
                                                   output v_cod_cta_ctbl,     /* CODIGO CONTA */
                                                   output v_des_cta_ctbl,     /* DESCRICAO CONTA */
                                                   output v_ind_finalid_cta,  /* FINALIDADE DA CONTA */
                                                   output table tt_log_erro). /* ERROS */

     if not can-find(tt_log_erro) and v_cod_cta_ctbl <> "" then
        assign fi-ct-codigo:screen-value in frame fPage4 =  v_cod_cta_ctbl 
               fi-desc-conta:screen-value              in frame fPage4 =  v_des_cta_ctbl.
     else /* Quando clicado no botao cancela do zoom v_cod_cta_ctbl volta com valor branco */
         if v_cod_cta_ctbl = "" then
             assign v_cod_cta_ctbl = fi-ct-codigo:screen-value in frame fPage4.
    
    for first tt_log_erro:
        run utp/ut-msgs.p (input 'show',17006, STRING(tt_log_erro.ttv_des_msg_erro) + ' (' + string(tt_log_erro.ttv_num_cod_erro) + ')' + "~~" + tt_log_erro.ttv_des_msg_ajuda).
        return no-apply.
    end.

    /*#### UTILIZA CENTRO CUSTO #####*/
    run pi_verifica_utilizacao_ccusto in h_api_ccusto (input  c-empresa,            /* EMPRESA EMS 2 */
                                                       input  fi-cod-estab-entrega:SCREEN-VALUE IN FRAME fPage3,        /* ESTABELECIMENTO EMS2 */
                                                       input  "",                   /* PLANO CONTAS */
                                                       input  v_cod_cta_ctbl,       /* CONTA */
                                                       input  TODAY,                /* DT TRANSACAO */
                                                       output v_log_utz_ccusto,     /* UTILIZA CCUSTO ? */
                                                       output table tt_log_erro).   /* ERROS */        
    if not v_log_utz_ccusto then do:
        assign fi-sc-codigo:screen-value in frame fPage4 = "":u
               fi-sc-codigo:sensitive    in frame fPage4 = no.
        disable fi-sc-codigo.
    end.

    /*#### FORMATO #####*/
    if v_cod_cta_ctbl <> "" then do:
        run pi_retorna_formato_cta_ctbl in h_api_cta_ctbl (input  c-empresa,            /* EMPRESA EMS2 */
                                                           input  "",                   /* PLANO CONTAS */
                                                           input  TODAY,           /* DATA DE TRANSACAO */
                                                           output v_cod_formato,        /* FORMATO CONTA */
                                                           output table tt_log_erro).   /* ERROS */
        assign fi-ct-codigo:format in frame fPage4 = if can-find(tt_log_erro) then "" else v_cod_formato.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-ct-codigo wReport
ON LEAVE OF fi-ct-codigo IN FRAME fPage4 /* Conta */
DO:
  run pi-leave-conta.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-ct-codigo wReport
ON MOUSE-SELECT-DBLCLICK OF fi-ct-codigo IN FRAME fPage4 /* Conta */
DO:
    apply "f5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME fi-fornec
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-fornec wReport
ON ENTRY OF fi-fornec IN FRAME fPage3 /* Fornecedor */
DO: 
    assign i-ant-aux-forn = input frame fPage3 fi-fornec.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-fornec wReport
ON F5 OF fi-fornec IN FRAME fPage3 /* Fornecedor */
DO:
     
    /*--- Zoom Smart Object ---*/
    assign l-implanta = yes.
    assign i-ant-forn-zoom = input frame fPage3 fi-fornec.
        /* input frame fpage0 cb-natureza
           i-natureza = {ininc/i01in295.i 06 cb-natureza}*/.

    {include/zoomvar.i &prog-zoom=adzoom/z01ad098.w
                       &campo=fi-fornec
                       &campozoom=cod-emitente
                       &campo2="fi-desc-fornec"
                       &campozoom2="nome-abrev"}.

     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-fornec wReport
ON F7 OF fi-fornec IN FRAME fPage3 /* Fornecedor */
DO:
  assign i-ant-forn-zoom = input frame fPage3 fi-fornec.

  /*--- Zoom Smart Object ---*/
  assign l-implanta = yes  
         input frame fPage3 cb-natureza
         i-natureza = {ininc/i01in295.i 06 cb-natureza}.

  {include/zoomvar.i &prog-zoom=inzoom/z16in274.w
                     &campo=fi-fornec
                     &campozoom=cod-emitente
                     &parametros="run pi-seta-inicial in wh-pesquisa (input i-natureza)."}.
      

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-fornec wReport
ON LEAVE OF fi-fornec IN FRAME fPage3 /* Fornecedor */
DO: 
    
    if i-ant-aux-forn <> int(input frame fPage3 fi-fornec)
    OR i-ant-forn-zoom <> int(input frame fPage3 fi-fornec) then do:

        run getDescCGCEmitente in hboin295desc ( input frame fPage3 fi-fornec,
                                                  output c-nom-emit,
                                                  output c-cgc-emit ).
       
        assign fi-desc-fornec:screen-value in frame fPage3 = c-nom-emit.

        run getLeaveFornecedor in hboin295desc ( input  frame fPage3 fi-fornec,
                                                  output i-emit-terc,
                                                  output i-cod-cond-pag ).

        assign fi-cod-emitente:screen-value in frame fPage3 = string(i-emit-terc).
        assign fi-cod-cond-pag:screen-value  in frame fPage3 = string(i-cod-cond-pag).

        run getTransp.

        apply "leave":U to fi-cod-emitente in frame fPage3.
        apply "leave":U to fi-cod-transp    in frame fPage3.

        if  i-cod-cond-pag > 0 then
            apply "leave":U to fi-cod-cond-pag in frame fPage3.

        

    end.

    ASSIGN i-ant-forn-zoom = int(input frame fPage3 fi-fornec).


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-fornec wReport
ON MOUSE-SELECT-DBLCLICK OF fi-fornec IN FRAME fPage3 /* Fornecedor */
DO:
  apply "f5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-mensagem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-mensagem wReport
ON F5 OF fi-mensagem IN FRAME fPage3 /* Mensagem */
DO:
  /* Zoom Smart Object ---*/
    {include/zoomvar.i &prog-zoom="adzoom/z01ad176.w"
                       &campo=fi-mensagem
                       &campozoom=cod-mensagem}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-mensagem wReport
ON LEAVE OF fi-mensagem IN FRAME fPage3 /* Mensagem */
DO:
  run getDescMensagem in hboin295desc ( input frame fPage3 fi-mensagem,
                                              output c-desc-mensagem ).
    assign fi-desc-mensagem:screen-value in frame fPage3 = c-desc-mensagem.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-mensagem wReport
ON MOUSE-SELECT-DBLCLICK OF fi-mensagem IN FRAME fPage3 /* Mensagem */
DO:
  apply "f5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME fi-nr-lin-prod
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-nr-lin-prod wReport
ON F5 OF fi-nr-lin-prod IN FRAME fPage4 /* Linha Produá∆o */
DO:
  &IF DEFINED (bf_man_linha_estab) &THEN
      find first estabelec
           where estabelec.cod-estabel = fi-cod-estab-entrega:screen-value in frame fPage3 no-lock no-error.
      if avail estabelec then
         assign gr-estabelec = rowid(estabelec).
  &ENDIF

   assign l-implanta = yes.  
   {include/zoomvar.i &prog-zoom="inzoom/z01in186.w"
                      &campo=fi-nr-lin-prod
                      &campozoom=nr-linha}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-nr-lin-prod wReport
ON MOUSE-SELECT-DBLCLICK OF fi-nr-lin-prod IN FRAME fPage4 /* Linha Produá∆o */
DO:
   apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME fi-responsavel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-responsavel wReport
ON F5 OF fi-responsavel IN FRAME fPage3 /* Respons†vel */
DO:
  /*--- Zoom Smart Object ---*/
    {include/zoomvar.i &prog-zoom="inzoom/z01in055.w"
                       &campo=fi-responsavel
                       &campozoom=cod-comprado}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-responsavel wReport
ON LEAVE OF fi-responsavel IN FRAME fPage3 /* Respons†vel */
DO:
  run getDescResponsavel in hboin295desc ( input frame fPage3 fi-responsavel,
                                              output c-desc-responsavel ).
    assign fi-desc-responsavel:screen-value in frame fPage3 = c-desc-responsavel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-responsavel wReport
ON MOUSE-SELECT-DBLCLICK OF fi-responsavel IN FRAME fPage3 /* Respons†vel */
DO:
  apply "f5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME fi-sc-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-sc-codigo wReport
ON ENTRY OF fi-sc-codigo IN FRAME fPage4 /* Sub-Conta */
DO:
    assign fi-sc-codigo:format in frame fPage4 = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-sc-codigo wReport
ON F5 OF fi-sc-codigo IN FRAME fPage4 /* Sub-Conta */
DO:
    assign fi-sc-codigo:format in frame fPage4 = "x(20)".
    run pi_zoom_ccusto in h_api_ccusto (input  c-empresa,           /* EMPRESA EMS2 */
                                        input  "",                  /* CODIGO DO PLANO CCUSTO */
                                        input  "",                  /* UNIDADE DE NEGOCIO */
                                        input  TODAY,          /* DATA DE TRANSACAO */
                                        output v_cod_ccusto,        /* CODIGO CCUSTO */
                                        output v_des_ccusto,        /* DESCRICAO CCUSTO */
                                        output table tt_log_erro).  /* ERROS */ 

    assign fi-sc-codigo:screen-value in frame fPage4 = if not can-find(tt_log_erro) then v_cod_ccusto else "":U
           fi-desc-ccusto:screen-value             in frame fPage4 = if not can-find(tt_log_erro) then v_des_ccusto else "":U.

    for first tt_log_erro:
        run utp/ut-msgs.p (input 'show',17006, STRING(tt_log_erro.ttv_des_msg_erro) + ' ('  + string(tt_log_erro.ttv_num_cod_erro) + ')' + "~~" + tt_log_erro.ttv_des_msg_ajuda).
        return no-apply.
    end.

    if v_cod_ccusto <> "" then do:
        /* Formato Centro Custo */
        run pi_retorna_formato_ccusto in h_api_ccusto (input  c-empresa,            /* EMPRESA EMS2 */
                                                       input  "",                   /* PLANO CCUSTO */
                                                       input  TODAY,           /* DATA DE TRANSACAO */
                                                       output v_cod_formato,        /* FORMATO CCUSTO */
                                                       output table tt_log_erro).   /* ERROS */
        for first tt_log_erro:
            run utp/ut-msgs.p (input 'show',17006, STRING(tt_log_erro.ttv_des_msg_erro) + ' ('  + string(tt_log_erro.ttv_num_cod_erro) + ')' + "~~" + tt_log_erro.ttv_des_msg_ajuda).
            return no-apply.
        end.

        if not can-find(tt_log_erro) then
            assign fi-sc-codigo:format in frame fPage4 = v_cod_formato.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-sc-codigo wReport
ON LEAVE OF fi-sc-codigo IN FRAME fPage4 /* Sub-Conta */
DO:
    assign fi-sc-codigo:format in frame fPage4 = "x(20)".
    assign v_cod_ccusto = fi-sc-codigo:screen-value in frame fPage4.
    if v_cod_ccusto <> "" then do:
        /* BUSCA DADOS */
        run pi_busca_dados_ccusto in h_api_ccusto (input  c-empresa,            /* EMPRESA EMS2 */
                                                   input  "",                   /* CODIGO DO PLANO CCUSTO */
                                                   input  v_cod_ccusto,         /* CCUSTO */
                                                   input  TODAY,           /* DATA DE TRANSACAO */
                                                   output v_des_ccusto,         /* DESCRICAO DO CCUSTO */
                                                   output table tt_log_erro).   /* ERROS */

        assign fi-sc-codigo:screen-value in frame fPage4 = if can-find(tt_log_erro) then "" else v_cod_ccusto
               fi-desc-ccusto:screen-value             in frame fPage4 = if can-find(tt_log_erro) then "" else v_des_ccusto.

        for first tt_log_erro:
            run utp/ut-msgs.p (input 'show',17006, STRING(tt_log_erro.ttv_des_msg_erro) + ' ('  + string(tt_log_erro.ttv_num_cod_erro) + ')' + "~~" + tt_log_erro.ttv_des_msg_ajuda).
            return no-apply.
        end.

        /* FORMATO */
        run pi_retorna_formato_ccusto in h_api_ccusto (input  c-empresa,            /* EMPRESA EMS2 */
                                                       input  "",                   /* PLANO CCUSTO */
                                                       input  TODAY,           /* DATA DE TRANSACAO */
                                                       output v_cod_formato,        /* FORMATO CCUSTO */
                                                       output table tt_log_erro).   /* ERROS */
        for first tt_log_erro:
            run utp/ut-msgs.p (input 'show',17006, STRING(tt_log_erro.ttv_des_msg_erro) + ' ('  + string(tt_log_erro.ttv_num_cod_erro) + ')' + "~~" + tt_log_erro.ttv_des_msg_ajuda).
            return no-apply.
        end.

        if not can-find(tt_log_erro) then
            assign fi-sc-codigo:format in frame fPage4 = v_cod_formato.
    end.
    ELSE ASSIGN fi-desc-ccusto:screen-value in frame fPage4 = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-sc-codigo wReport
ON MOUSE-SELECT-DBLCLICK OF fi-sc-codigo IN FRAME fPage4 /* Sub-Conta */
DO:
    apply "f5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Zoom_FornecAmbos_com_Ordens
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Zoom_FornecAmbos_com_Ordens wReport
ON CHOOSE OF MENU-ITEM m_Zoom_FornecAmbos_com_Ordens /* Zoom Fornec/Ambos com Ordens Cotadas */
DO:
   apply "F7" to fi-fornec in frame fPage3.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Zoom_Fornecedor_do_Pedido_d
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Zoom_Fornecedor_do_Pedido_d wReport
ON CHOOSE OF MENU-ITEM m_Zoom_Fornecedor_do_Pedido_d /* Zoom Fornecedor do Pedido de Compra */
DO:
    apply "F5":U to fi-fornec in frame fPage3.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage6
&Scoped-define SELF-NAME rsDestiny
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rsDestiny wReport
ON VALUE-CHANGED OF rsDestiny IN FRAME fPage6
DO:
do  with frame fPage6:
    case self:screen-value:
        when "1":U then do:
            assign cFile:sensitive       = no
                   cFile:visible         = yes
                   btFile:visible        = no
                   btConfigImpr:visible  = yes
                   /*Alterado 15/02/2005 - tech1007 - Alterado para suportar adequadamente com a 
                     funcionalidade de RTF*/
                   &IF "{&RTF}":U = "YES":U &THEN
                   l-habilitaRtf:sensitive  = NO
                   l-habilitaRtf:SCREEN-VALUE IN FRAME fPage6 = "No"
                   l-habilitaRtf = NO
                   &endif
                   .
                   /*Fim alteracao 15/02/2005*/
        end.
        when "2":U then do:
            assign cFile:sensitive       = yes
                   cFile:visible         = yes
                   btFile:visible        = yes
                   btConfigImpr:visible  = no
                   &IF "{&RTF}":U = "YES":U &THEN
                   l-habilitaRtf:sensitive  = YES
                   &endif
                   .
        end.
        when "3":U then do:
            assign cFile:visible         = no
                   cFile:sensitive       = no
                   btFile:visible        = no
                   btConfigImpr:visible  = no
                   &IF "{&RTF}":U = "YES":U &THEN
                   l-habilitaRtf:sensitive  = YES
                   &endif
                   .
            /*Alterado 15/02/2005 - tech1007 - Teste para funcionar corretamente no WebEnabler*/
            &IF "{&RTF}":U = "YES":U &THEN
            IF VALID-HANDLE(hWenController) THEN DO:
                ASSIGN l-habilitaRtf:sensitive  = NO
                       l-habilitaRtf:SCREEN-VALUE IN FRAME fPage6 = "No"
                       l-habilitaRtf = NO.
            END.
            &endif
            /*Fim alteracao 15/02/2005*/
        END.
        /*Alterado 15/02/2005 - tech1007 - Condiá∆o removida pois RTF n∆o Ç mais um destino
        when "4":U then do:
            assign cFile:sensitive       = no
                   cFile:visible         = yes
                   btFile:visible        = no
                   btConfigImpr:visible  = yes
                   text-ModelRtf:VISIBLE   = YES
                   rect-rtf:VISIBLE       = YES
                   blModelRtf:VISIBLE       = yes.
        end.
        Fim alteracao 15/02/2005*/
    end case.
end.
&IF "{&RTF}":U = "YES":U &THEN
RUN pi-habilitaRtf.  
&endif
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rsExecution
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rsExecution wReport
ON VALUE-CHANGED OF rsExecution IN FRAME fPage6
DO:
   {report/rprse.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wReport 


/*:T--- L¢gica para inicializaá∆o do programam ---*/

ON LEAVE OF tt-digita.it-codigo IN BROWSE brDigita OR 
   LEAVE OF tt-digita.quantidade IN BROWSE brDigita DO:

    ASSIGN tt-digita.desc-item:SCREEN-VALUE IN BROWSE brDigita = f-desc-item(tt-digita.it-codig:SCREEN-VALUE IN BROWSE brDigita).

    IF dec(tt-digita.preco:SCREEN-VALUE) = 0 THEN
        ASSIGN tt-digita.preco:SCREEN-VALUE IN BROWSE brDigita = string(f-preco-item(INPUT INPUT FRAME fPage3 fi-fornec,         /*int*/
                                                                                     INPUT INPUT BROWSE brDigita tt-digita.it-codigo,                  /*char*/
                                                                                     INPUT INPUT BROWSE brDigita tt-digita.quantidade,                 /*dec*/
                                                                                     INPUT INPUT FRAME fPage3 fi-cod-cond-pag)). /*int*/

    /*
    ASSIGN tt-digita.desc-item
           tt-digita.preco.
           */


END.



{report/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wReport 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    if valid-handle(h_api_ccusto) then
        delete object h_api_ccusto.

    if valid-handle(h_api_cta_ctbl) then
        delete object h_api_cta_ctbl.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wReport 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*Alterado 17/02/2005 - tech1007 - Foi criado essa procedure para que seja realizado a inicializaá∆o
  correta dos componentes do RTF quando executado em ambiente local e no WebEnabler.*/
&IF "{&RTF}":U = "YES":U &THEN
IF VALID-HANDLE(hWenController) THEN DO:
    ASSIGN l-habilitaRtf:sensitive IN FRAME fPage6 = NO
           l-habilitaRtf:SCREEN-VALUE IN FRAME fPage6 = "No"
           l-habilitaRtf = NO.
           
END.
RUN pi-habilitaRtf.
&endif
/*Fim alteracao 17/02/2005*/

find first estabelec no-lock
    where estabelec.cod-estabel = tt-ordem-compra.cod-estabel no-error.
assign c-empresa = estabelec.ep-codigo when avail estabelec.

RUN initializeDBOs.

assign cb-natureza:list-items      in frame fPage3 = {ininc/i01in295.i 03}
       cb-frete:list-items         in frame fPage3 = {ininc/i03in295.i 03}
       cb-via-transp:list-items    in frame fPage3 = {adinc/i01ad268.i 03}.

ASSIGN cb-natureza   = {ininc/i01in295.i 04 3}
       cb-frete      = {ininc/i03in295.i 04 1}
       cb-via-transp = {adinc/i01ad268.i 04 1}.

DISP cb-natureza
     cb-frete
     cb-via-transp WITH FRAME fPage3.

fi-fornec:load-mouse-pointer("image/lupa.cur":U) in frame fPage3.
fi-cod-emitente:load-mouse-pointer("image/lupa.cur":U) in frame fPage3.
fi-cod-processo:load-mouse-pointer("image/lupa.cur":U) in frame fPage3.
fi-cod-transp:load-mouse-pointer("image/lupa.cur":U) in frame fPage3.
fi-cod-estab-entrega:load-mouse-pointer("image/lupa.cur":U) in frame fPage3.
fi-cod-estab-cobranca:load-mouse-pointer("image/lupa.cur":U) in frame fPage3.
fi-cod-cond-pag:load-mouse-pointer("image/lupa.cur":U) in frame fPage3.
fi-responsavel:load-mouse-pointer("image/lupa.cur":U) in frame fPage3.
fi-mensagem:load-mouse-pointer("image/lupa.cur":U) in frame fPage3.
fi-cod-estab-gestor:load-mouse-pointer("image/lupa.cur":U) in frame fPage3.

fi-nr-lin-prod:load-mouse-pointer("image/lupa.cur":U) in frame fPage4.
fi-cod-depos:load-mouse-pointer("image/lupa.cur":U) in frame fPage4.
fi-ct-codigo:load-mouse-pointer("image/lupa.cur":U) in frame fPage4.
fi-sc-codigo:load-mouse-pointer("image/lupa.cur":U) in frame fPage4.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getTransp wReport 
PROCEDURE getTransp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def var i-cod-transp like pedido-compr.cod-transp no-undo.

    run getTransp in hboin295desc ( input frame fPage3 fi-fornec,
                                    output i-cod-transp ).
    assign fi-cod-transp:screen-value in frame fPage3 = string(i-cod-transp).

    if  i-cod-transp <> 0 then
        apply "leave":U to fi-cod-transp in frame fPage3.

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wReport 
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

    RUN prgint/utb/utb742za.py PERSISTENT SET h_api_ccusto.
    RUN prgint/utb/utb743za.py PERSISTENT SET h_api_cta_ctbl.

    ASSIGN ed-modelo:SCREEN-VALUE IN FRAME fPage5 = 
        "Layout de Importaá∆o (Recuperar)" + CHR(10) + CHR(10) + 
        "<C¢digo do Item>;<Quantidade>;<Preáo>".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-leave-conta wReport 
PROCEDURE pi-leave-conta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def var c-conta as char no-undo.

    assign fi-ct-codigo:format in frame fPage4 = "x(20)".
    
    find first estabelec no-lock 
         where estabelec.cod-estabel = fi-cod-estab-entrega:screen-value in frame fPage3 no-error.
    assign c-empresa = estabelec.ep-codigo when avail estabelec.

    assign v_cod_cta_ctbl = input frame fPage4 fi-ct-codigo no-error.
    if v_cod_cta_ctbl <> "" then do:
        /*#### BUSCA DADOS #####*/
        run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (input        c-empresa,          /* EMPRESA EMS2 */
                                                       input        "",                 /* PLANO DE CONTAS */
                                                       input-output v_cod_cta_ctbl,     /* CONTA */
                                                       input        TODAY,         /* DATA TRANSACAO */   
                                                       output       v_des_cta_ctbl,     /* DESCRICAO CONTA */
                                                       output       v_num_tip_cta_ctbl, /* TIPO DA CONTA */
                                                       output       v_num_sit_cta_ctbl, /* SITUAÄ«O DA CONTA */
                                                       output       v_ind_finalid_cta,  /* FINALIDADES DA CONTA */
                                                       output table tt_log_erro).       /* ERROS */
        
        assign fi-ct-codigo:screen-value in frame fPage4 = if can-find(tt_log_erro) then "" else v_cod_cta_ctbl
               fi-desc-conta:screen-value              in frame fPage4 = if can-find(tt_log_erro) then "" else v_des_cta_ctbl.

        for first tt_log_erro:
            run utp/ut-msgs.p (input 'show',17006, STRING(tt_log_erro.ttv_des_msg_erro) + ' (' + string(tt_log_erro.ttv_num_cod_erro) + ')' + "~~" + tt_log_erro.ttv_des_msg_ajuda).
            return no-apply.
        end.

        /*#### UTILIZA CENTRO CUSTO #####*/
        run pi_verifica_utilizacao_ccusto in h_api_ccusto (input  c-empresa,            /* EMPRESA EMS 2 */
                                                           input  fi-cod-estab-entrega:SCREEN-VALUE IN FRAME fpage3,        /* ESTABELECIMENTO EMS2 */
                                                           input  "",                   /* PLANO CONTAS */
                                                           input  v_cod_cta_ctbl,       /* CONTA */
                                                           input  TODAY,           /* DT TRANSACAO */
                                                           output v_log_utz_ccusto,     /* UTILIZA CCUSTO ? */
                                                           output table tt_log_erro).   /* ERROS */
        if not v_log_utz_ccusto then do:
            assign fi-sc-codigo:screen-value in frame fPage4 = "":U
                   fi-desc-ccusto:screen-value             in frame fPage4 = "":U
                   fi-sc-codigo:sensitive    in frame fPage4 = NO.
            disable fi-sc-codigo.
        end.

        /*#### FORMATO #####*/
        run pi_retorna_formato_cta_ctbl in h_api_cta_ctbl (input  c-empresa,            /* EMPRESA EMS2 */
                                                           input  "",                   /* PLANO CONTAS */
                                                           input  TODAY,           /* DATA DE TRANSACAO */
                                                           output v_cod_formato,        /* FORMATO CONTA */
                                                           output table tt_log_erro).   /* ERROS */
        for first tt_log_erro:
            run utp/ut-msgs.p (input 'show',17006, STRING(tt_log_erro.ttv_des_msg_erro) + ' (' + string(tt_log_erro.ttv_num_cod_erro) + ')' + "~~" + tt_log_erro.ttv_des_msg_ajuda).
            return no-apply.
        end.
        
        assign fi-ct-codigo:format in frame fPage4 = if can-find(tt_log_erro) then "" else v_cod_formato.
    end.
    ELSE DO:
        ASSIGN fi-desc-conta:screen-value              in frame fPage4 = ""
               fi-sc-codigo:screen-value in frame fPage4 = "":U
               fi-desc-ccusto:screen-value             in frame fPage4 = "":U
               fi-sc-codigo:sensitive    in frame fPage4 = NO.
        DISABLE fi-sc-codigo.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piExecute wReport 
PROCEDURE piExecute :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

define var r-tt-digita as rowid no-undo.

&IF DEFINED(PGIMP) <> 0 AND "{&PGIMP}":U = "YES":U &THEN
/*:T** Relatorio ***/
do on error undo, return error on stop  undo, return error:
    {report/rpexa.i}

    /*15/02/2005 - tech1007 - Teste alterado pois RTF n∆o Ç mais opá∆o de Destino*/
    if input frame fPage6 rsDestiny = 2 and
       input frame fPage6 rsExecution = 1 then do:
        run utp/ut-vlarq.p (input input frame fPage6 cFile).
        
        if return-value = "NOK":U then do:
            run utp/ut-msgs.p (input "show":U, input 73, input "":U).
            apply "ENTRY":U to cFile in frame fPage6.
            return error.
        end.
    end.
    
    /*16/02/2005 - tech1007 - Teste alterado para validar o modelo informado quando for RTF*/
    &IF "{&RTF}":U = "YES":U &THEN
    IF ( input frame fPage6 cModelRTF = "" AND
         input frame fPage6 l-habilitaRtf = YES ) OR
       ( SEARCH(INPUT FRAME fPage6 cModelRTF) = ? AND
         input frame fPage6 rsExecution = 1 AND
         input frame fPage6 l-habilitaRtf = YES )
         THEN DO:
        run utp/ut-msgs.p (input "show":U, input 73, input "":U).
        /*30/12/2004 - tech1007 - Evento removido pois causa problemas no WebEnabler*/
        /*apply "CHOOSE":U to blModelRtf in frame fPage6.*/
        return error.
    END.
    &endif
    
    FOR FIRST lin-prod NO-LOCK
        WHERE lin-prod.nr-linha = int(fi-nr-lin-prod:SCREEN-VALUE IN FRAME fPage4):

        IF lin-prod.sum-requis <> 2 /* Ordem de Serviáo */ THEN DO:

            run utp/ut-msgs.p (input "show":U, input 17006, input "Linha de Produá∆o deve ser do tipo 'Ordem de Serviáo'.":U).
            return error.
            
        END.

    END.

    IF NOT AVAIL lin-prod THEN DO:

        run utp/ut-msgs.p (input "show":U, input 56, input "Linha de Produá∆o":U).
        return error.

    END.

    IF NOT CAN-FIND(FIRST deposito
                    WHERE deposito.cod-depos = fi-cod-depos:SCREEN-VALUE IN FRAME fpage4) THEN DO:

        run utp/ut-msgs.p (input "show":U, input 56, input "Dep¢sito":U).
        return error.


    END.
    
    /*:T Coloque aqui as validaá‰es da p†gina de Digitaá∆o, lembrando que elas devem
       apresentar uma mensagem de erro cadastrada, posicionar nesta p†gina e colocar
       o focus no campo com problemas */
    /*browse brDigita:SET-REPOSITIONED-ROW (browse brDigita:DOWN, "ALWAYS":U).*/

    IF fi-cod-cond-pag:SCREEN-VALUE IN FRAME fPage3 = "0" THEN DO:

        run utp/ut-msgs.p (input "show":U, 
                           INPUT 17006, 
                           input "Condiá∆o de Pagamento deve ser informada.":U).

        APPLY "ENTRY" TO fi-cod-cond-pag IN FRAME fpage3.

        RETURN ERROR.

    END.
    
    for each tt-digita no-lock:
        assign r-tt-digita = rowid(tt-digita).
        
        /*:T Validaá∆o de duplicidade de registro na temp-table tt-digita */
        /*find first b-tt-digita 
            where b-tt-digita.ordem = tt-digita.ordem 
              and rowid(b-tt-digita) <> rowid(tt-digita) 
            no-lock no-error.
        if  avail b-tt-digita then do:
            reposition brDigita to rowid rowid(b-tt-digita).
            
            run utp/ut-msgs.p (input "SHOW":U, input 108, input "":U).
            apply "ENTRY":U to tt-digita.ordem in browse brDigita.
            
            return error.
        end.*/
        
        /*:T As demais validaá‰es devem ser feitas aqui */
        IF NOT can-find(FIRST ITEM NO-LOCK
                        WHERE ITEM.it-codigo = tt-digita.it-codigo) THEN DO:

            assign browse brDigita:CURRENT-COLUMN = tt-digita.it-codigo:HANDLE in browse brDigita.
            
            reposition brDigita to rowid r-tt-digita.
           
            run utp/ut-msgs.p (input "SHOW":U, input 56, input "Item":U).
            apply "ENTRY":U to tt-digita.it-codigo in browse brDigita.
            
            return error.
        end.

        if  tt-digita.quantidade <= 0 then do:

            assign browse brDigita:CURRENT-COLUMN = tt-digita.quantidade:HANDLE in browse brDigita.
            
            reposition brDigita to rowid r-tt-digita.
           
            run utp/ut-msgs.p (input "SHOW":U, input 17006, input "Quantidade deve ser maior que zero.":U).
            apply "ENTRY":U to tt-digita.quantidade in browse brDigita.
            
            return error.
        end.
        
    end.
    
    
    /*:T Coloque aqui as validaá‰es das outras p†ginas, lembrando que elas devem 
       apresentar uma mensagem de erro cadastrada, posicionar na p†gina com 
       problemas e colocar o focus no campo com problemas */
    
    
    
    /*:T Aqui s∆o gravados os campos da temp-table que ser† passada como parÉmetro
       para o programa RP.P */
    
    create tt-param.
    assign tt-param.usuario             = c-seg-usuario
           tt-param.destino             = input frame fPage6 rsDestiny                                    
           tt-param.data-exec           = today
           tt-param.hora-exec           = TIME                                                  
           tt-param.cod-fornec          = INPUT FRAME fPage3 fi-fornec                          
           tt-param.cod-emitente        = INPUT FRAME fPage3 fi-cod-emitente                    
           tt-param.natureza            = {ininc/i01in295.i 06 cb-natureza:SCREEN-VALUE IN FRAME fPage3}                     
           tt-param.ped-emergenc        = TRUE
           tt-param.imprime-ped         = TRUE
           tt-param.processo            = INPUT FRAME fPage3 fi-cod-processo                    
           tt-param.frete               = {ininc/i03in295.i 06 cb-frete:SCREEN-VALUE IN FRAME fPage3}                        
           tt-param.cod-transp          = INPUT FRAME fPage3 fi-cod-transp                      
           tt-param.via-transp          = {adinc/i01ad268.i 06 cb-via-transp:SCREEN-VALUE IN FRAME fPage3}                   
           tt-param.cod-estab-entrega   = INPUT FRAME fPage3 fi-cod-estab-entrega               
           tt-param.cod-estab-cobranca  = INPUT FRAME fPage3 fi-cod-estab-cobranca              
           tt-param.cod-cond-pag        = INPUT FRAME fPage3 fi-cod-cond-pag                    
           tt-param.responsavel         = INPUT FRAME fPage3 fi-responsavel                     
           tt-param.cod-mensagem        = INPUT FRAME fPage3 fi-mensagem                        
           tt-param.cod-estab-gestor    = INPUT FRAME fPage3 fi-cod-estab-gestor                
           tt-param.nr-lin-prod         = INPUT FRAME fPage4 fi-nr-lin-prod                     
           tt-param.cod-depos           = INPUT FRAME fPage4 fi-cod-depos                       
           tt-param.ct-codigo           = INPUT FRAME fpage4 fi-ct-codigo
           tt-param.sc-codigo           = INPUT FRAME fpage4 fi-sc-codigo
           .                                                                                        
    
    if tt-param.destino = 1 
    then 
        assign tt-param.arquivo = "":U.
    else if  tt-param.destino = 2 
        then assign tt-param.arquivo = input frame fPage6 cFile.
         else assign tt-param.arquivo = session:temp-directory + c-programa-mg97 + ".tmp":U.
    
    /*:T Coloque aqui a l¢gica de gravaá∆o dos demais campos que devem ser passados
       como parÉmetros para o programa RP.P, atravÇs da temp-table tt-param */
    
    
    
    /*:T Executar do programa RP.P que ir† criar o relat¢rio */
    {report/rpexb.i}
    
    SESSION:SET-WAIT-STATE("GENERAL":U).
    
    {report/rprun.i esp/cpp/escpp092rp.p}
    
    {report/rpexc.i}
    
    SESSION:SET-WAIT-STATE("":U).
    
    {report/rptrm.i}
end.
&ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION f-desc-item wReport 
FUNCTION f-desc-item RETURNS CHARACTER
  ( INPUT p-it-codigo AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    FOR FIRST ITEM NO-LOCK
        WHERE ITEM.it-codigo = p-it-codigo:

        RETURN ITEM.desc-item.

    END.

    RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION f-item-uni-estab wReport 
FUNCTION f-item-uni-estab RETURNS char (input c-it-codigo as char,
              input c-cod-estabel as char,
              input c-campo       as char):

    def var l-fnc-pr-fiscal as log no-undo.

    def buffer b-item for item.

    &if defined(bf_man_204) &then
    if  can-find(first funcao no-lock
                 where funcao.cd-funcao = 'spp-pr-fiscal-estab':U
                   and funcao.ativo) then
        assign l-fnc-pr-fiscal = yes.
    &endif

    find b-item no-lock
        where b-item.it-codigo = c-it-codigo no-error.

/***  Temporˇrio - os preªos (cs0102) na release 2.04 ou inferior ainda nío estío sendo tratados 
      pela tabela item-uni-estab, dúvidas com Rog≤rio Vieira. ***/

    &IF DEFINED (bf_man_custeio_item) &THEN
        /*** caso release 2.04a ou superior, farˇ o tratamento por item-uni-estab ***/
    &ELSE
        case c-campo:    
            when "data-base":u then
                 return string (b-item.data-base).
            when "preco-base":u then
                 return string (b-item.preco-base).
            when "data-ult-rep":u then
                 return string (b-item.data-ult-rep).
            when "preco-repos":u then
                 return string (b-item.preco-repos).
            when "data-ult-ent":u then
                 return string (b-item.data-ult-ent).
            when "preco-ul-ent":u then
                 return string (b-item.preco-ul-ent).
            when "preco-fiscal":u then do:
                &if defined(bf_man_204) &then
                if  l-fnc-pr-fiscal then do:
                    find first item-uni-estab no-lock
                         where item-uni-estab.it-codigo   = c-it-codigo
                           and item-uni-estab.cod-estabel = c-cod-estabel no-error.

                    if  avail item-uni-estab then
                        return string (item-uni-estab.preco-fiscal).
                    else
                        return ''.
                end.
                else
                    return string (b-item.preco-fiscal).
                &else
                return string (b-item.preco-fiscal).
                &endif
            end.
        end.
    &ENDIF

/*** FIM ***/

    &IF DEFINED (bf_man_203) &THEN

        def buffer b-item-uni-estab for item-uni-estab.

        if  c-cod-estabel = ? then
            assign c-cod-estabel = b-item.cod-estabel.

        find b-item-uni-estab use-index codigo
            where b-item-uni-estab.it-codigo   = c-it-codigo 
              and b-item-uni-estab.cod-estabel = c-cod-estabel no-lock no-error.

        if  avail b-item-uni-estab then do:
            case c-campo:
                 when "altera-conta":u then
                      return string (b-item-uni-estab.altera-conta).

                 when "cd-freq":u then
                      return string (b-item-uni-estab.cd-freq).

                 when "cod-estab-gestor":u then
                      return string (b-item-uni-estab.cod-estab-gestor).

                 when "cod-fat-ponder":u then
                      return string (b-item-uni-estab.cod-fat-ponder).

                 when "cod-grp-compra":u then
                      return string (b-item-uni-estab.cod-grp-compra).

                 when "crit-cc":u then
                      return string (b-item-uni-estab.crit-cc).

                 when "crit-ce":u then
                      return string (b-item-uni-estab.crit-ce).

                 when "data-pr-fisc":u then
                      return string (b-item-uni-estab.data-pr-fisc).

                 when "data-ult-ressup":u then
                      return string (b-item-uni-estab.data-ult-ressup).

                 when "dep-rej-cq":u then
                      return string (b-item-uni-estab.dep-rej-cq).

                 when "deposito-cq":u then
                      return string (b-item-uni-estab.deposito-cq).

                 when "fator-ponder[1]":u then
                      return string (b-item-uni-estab.fator-ponder[1]).

                 when "fator-ponder[2]":u then
                      return string (b-item-uni-estab.fator-ponder[2]).

                 when "fator-ponder[3]":u then
                      return string (b-item-uni-estab.fator-ponder[3]).

                 when "fator-ponder[4]":u then
                      return string (b-item-uni-estab.fator-ponder[4]).

                 when "fator-ponder[5]":u then
                      return string (b-item-uni-estab.fator-ponder[5]).

                 when "fator-ponder[6]":u then
                      return string (b-item-uni-estab.fator-ponder[6]).

                 when "fator-ponder[7]":u then
                      return string (b-item-uni-estab.fator-ponder[7]).

                 when "fator-ponder[8]":u then
                      return string (b-item-uni-estab.fator-ponder[8]).

                 when "fator-ponder[9]":u then
                      return string (b-item-uni-estab.fator-ponder[9]).

                 when "fator-ponder[10]":u then
                      return string (b-item-uni-estab.fator-ponder[10]).

                 when "fator-ponder[11]":u then
                      return string (b-item-uni-estab.fator-ponder[11]).

                 when "fator-ponder[12]":u then
                      return string (b-item-uni-estab.fator-ponder[12]).

                 when "ind-cons-prv":u then
                      return string (b-item-uni-estab.ind-cons-prv).

                 when "ind-lista-csp":u then
                      return string (b-item-uni-estab.ind-lista-csp).

                 when "ind-lista-mrp":u then
                      return string (b-item-uni-estab.ind-lista-mrp).

                 when "ind-refugo":u then
                      return string (b-item-uni-estab.ind-refugo).

                 when "lim-var-qtd":u then
                      return string (b-item-uni-estab.lim-var-qtd).

                 when "lim-var-valor":u then
                      return string (b-item-uni-estab.lim-var-valor).

                 when "log-ad-consumo":u then
                      return string (b-item-uni-estab.log-ad-consumo).

                 when "log-finaliz-op":u then
                      return string (b-item-uni-estab.log-finaliz-op).

                 when "lote-per-max":u then
                      return string (b-item-uni-estab.lote-per-max).

                 when "ponto-encomenda":u then
                      return string (b-item-uni-estab.ponto-encomenda).

                 when "prioridade-aprov":u then
                      return string (b-item-uni-estab.prioridade-aprov).

                 when "qt-min-res-fabr":u then
                      return string (b-item-uni-estab.qt-min-res-fabr).

                 when "res-min-fabri":u then
                      return string (b-item-uni-estab.res-min-fabri).

                 when "tp-codigo":u then
                      return string (b-item-uni-estab.tp-codigo).

                 when "tp-ressup":u then
                      return string (b-item-uni-estab.tp-ressup).

                 when "var-qtd-re":u then
                      return string (b-item-uni-estab.var-qtd-re).

                 when "var-qtd-res-fabr":u then
                      return string (b-item-uni-estab.var-qtd-res-fabr).

                 when "var-tempo-res-fabr":u then
                      return string (b-item-uni-estab.var-tempo-res-fabr).

                 when "var-val-re-maior":u then
                      return string (b-item-uni-estab.var-val-re-maior).

                 when "var-val-re-menor":u then
                      return string (b-item-uni-estab.var-val-re-menor).

                 when "variacao-perm":u then
                      return string (b-item-uni-estab.variacao-perm).

                 when "vl-ggf-ant":u then
                      return string (b-item-uni-estab.vl-ggf-ant).

                 when "vl-mat-ant":u then
                      return string (b-item-uni-estab.vl-mat-ant).

                 when "vl-mob-ant":u then
                      return string (b-item-uni-estab.vl-mob-ant).

                 {esp/cpp/escpp092.i1 b-item-uni-estab}
            end case.
        end.
    &ELSE
        case c-campo:
             {esp/cpp/escpp092.i1 b-item}
        end case.
    &ENDIF

    return "".

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION f-preco-item wReport 
FUNCTION f-preco-item RETURNS DECIMAL
  ( INPUT p-cod-emitente AS INTEGER,
    INPUT p-it-codigo AS CHAR,
    INPUT p-qtd-tot AS DEC,
    INPUT p-cod-cond-pag AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE VARIABLE hBoin082ca AS HANDLE      NO-UNDO.
    def var de-aliquota-icm like cotacao-item.aliquota-icm.
    DEFINE VARIABLE deConver AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE deQtdForn AS DECIMAL     NO-UNDO.

    DEFINE VARIABLE d-preco-fornec AS DECIMAL INIT 0    NO-UNDO.


    /*
    ASSIGN p-cod-emitente = 18963
           p-it-codigo    = "1640220"
           p-qtd-tot      = 10
           p-cod-cond-pag = 6
        .
        */

    for first item-fornec fields(it-codigo cod-emitente ativo num-casa-dec fator-conver unid-med-for) 
        where item-fornec.it-codigo    = p-it-codigo 
        AND   item-fornec.cod-emitente = p-cod-emitente 
        AND   item-fornec.ativo          no-lock: 
    end.

    if avail item-fornec then assign deConver = ( 1 / (exp(10, item-fornec.num-casa-dec))) * item-fornec.fator-conver.
                         else assign deConver = 1.

    assign deQtdForn = p-qtd-tot * deConver.

    if p-it-codigo <> ?  and 
       p-it-codigo <> "" then do:

        for first tb-pr-cc fields(cod-emitente cod-cond-pag dt-inicio  dt-termino  situacao
                                  nr-tab       mo-codigo    frete      taxa-financ nr-dias-taxa
                                  valor-frete  codigo-ipi   valor-taxa perc-descto) where 
             tb-pr-cc.cod-emitente = p-cod-emitente     and
             tb-pr-cc.cod-cond-pag = p-cod-cond-pag and
             tb-pr-cc.dt-inicio   <= TODAY  and
             tb-pr-cc.dt-termino  >= TODAY  and
             tb-pr-cc.situacao     = 1 
             no-lock: end.

        if available tb-pr-cc then 
        repeat:
            for last item-tab fields(it-codigo cod-emitente cod-cond-pag nr-tab quant-min 
                                     pr-item   aliquota-ipi desco-quant aliquota-icm) where 
                item-tab.it-codigo    = p-it-codigo and
                item-tab.cod-emitente = p-cod-emitente and
                item-tab.cod-cond-pag = tb-pr-cc.cod-cond-pag and
                item-tab.nr-tab       = tb-pr-cc.nr-tab       and
                item-tab.quant-min   <= deQtdForn
                no-lock: end.
            if  not available item-tab then
                for first item-tab fields(it-codigo cod-emitente cod-cond-pag nr-tab quant-min 
                                          pr-item   aliquota-ipi desco-quant aliquota-icm) where 
                     item-tab.cod-emitente = p-cod-emitente and
                     item-tab.nr-tab       = tb-pr-cc.nr-tab       and
                     item-tab.cod-cond-pag = tb-pr-cc.cod-cond-pag and
                     item-tab.it-codigo    = p-it-codigo
                     no-lock: end.
            if  available item-tab then  
                leave.
            find next tb-pr-cc  where 
                 tb-pr-cc.cod-emitente = p-cod-emitente     and
                 tb-pr-cc.cod-cond-pag = p-cod-cond-pag and
                 tb-pr-cc.dt-inicio   <= TODAY  and
                 tb-pr-cc.dt-termino  >= TODAY  and
                 tb-pr-cc.situacao     = 1 no-lock no-error.
            if  not avail tb-pr-cc then
                leave.            
        end.

        if  avail item-tab then do:        
            assign d-preco-fornec = item-tab.pr-item.
        end.
        
        /* Se houver cotaá∆o desvinculada, prevalecer∆o os valores da cotaá∆o */
        for first cotacao-item where
                  cotacao-item.it-codigo       = p-it-codigo               and
                  cotacao-item.cod-emitente    = p-cod-emitente            and
                  cotacao-item.numero-ordem    = 0                         and
                  cotacao-item.cod-cond-pag    = p-cod-cond-pag and
                  (cotacao-item.data-cotacao + cotacao-item.prazo-entreg) >= today     no-lock:

            assign d-preco-fornec = cotacao-item.preco-fornec.

        end.

    end.

    RETURN d-preco-fornec.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

