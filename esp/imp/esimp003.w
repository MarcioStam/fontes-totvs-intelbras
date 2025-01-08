&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenance


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttpagamento NO-UNDO LIKE pagamento
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
{include/i-prgvrs.i ESIMP003 2.04.00.001}

CREATE WIDGET-POOL.




/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESIMP003
&GLOBAL-DEFINE Version        2.04.00.001


&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1

&GLOBAL-DEFINE FolderLabels   CI,Receber,Contrato,Swift,,Impress∆o


&GLOBAL-DEFINE PGCI           YES
&GLOBAL-DEFINE PGREC          YES
&GLOBAL-DEFINE PGFEC          YES
&GLOBAL-DEFINE PGSWI          YES
&GLOBAL-DEFINE PGIMP          YES



&GLOBAL-DEFINE PGLAY          NO
&GLOBAL-DEFINE PGSEL          NO
&GLOBAL-DEFINE PGCLA          NO
&GLOBAL-DEFINE PGPAR          YES
&GLOBAL-DEFINE PGDIG          YES
&GLOBAL-DEFINE PGLOG          NO

&GLOBAL-DEFINE RTF            NO

&GLOBAL-DEFINE First          YES
&GLOBAL-DEFINE Prev           YES
&GLOBAL-DEFINE Next           YES
&GLOBAL-DEFINE Last           YES
&GLOBAL-DEFINE GoTo           YES
&GLOBAL-DEFINE Search         YES

&GLOBAL-DEFINE Add            YES
&GLOBAL-DEFINE Copy           NO
&GLOBAL-DEFINE Update         YES
&GLOBAL-DEFINE Delete         YES
&GLOBAL-DEFINE Undo           YES
&GLOBAL-DEFINE Cancel         YES
&GLOBAL-DEFINE Save           YES

&GLOBAL-DEFINE ttTable        ttpagamento
&GLOBAL-DEFINE hDBOTable      hdbopagamento
&GLOBAL-DEFINE DBOTable       dbopagamento

&GLOBAL-DEFINE page0widgets  
&GLOBAL-DEFINE page6Widgets   rsDestiny ~
                              btConfigImpr ~
                              btFile ~
                              rsExecution 

&GLOBAL-DEFINE page1KeyFields
&GLOBAL-DEFINE page1KeyFields ttpagamento.nr-pagamento 

&GLOBAL-DEFINE page0Fields 
&GLOBAL-DEFINE page1Fields    ttpagamento.nr-pagamento ttpagamento.cod-emitente ttpagamento.recebido-ap ~
                              ttpagamento.nr-di ttpagamento.data-ci ~
                              ttpagamento.tipo-despesa ttpagamento.centro ttpagamento.cod-banco ttpagamento.valor-pag ~
                              ttpagamento.cod-moeda ttpagamento.dt-prev-fecha-cam ttpagamento.historico[1] ttpagamento.historico[2] ~
                              ttpagamento.valor-contrato-me ttpagamento.nr-cont-cambio ttpagamento.tipo-contr-cambio ~
                              ttpagamento.data-emissao ttpagamento.swift ttpagamento.data-swift ttpagamento.instit-cambio ~
                              ttpagamento.praca-cambio ttpagamento.taxa-cambio-pag ttpagamento.valor-contrato ~
                              ttpagamento.cod-moeda-1 ttpagamento.valor-ord-pag ttpagamento.taxa-cambio ttpagamento.valor-fechamento ~
                              ttpagamento.dt-fecha-cam ttpagamento.modalidade ttpagamento.cod-estabel ttpagamento.cod-unid-neg ~
                              ttpagamento.cod-cond-pag ttpagamento.usuar-receb txt-tipo ttpagamento.tipo-ci ttpagamento.dat-fft
&GLOBAL-DEFINE page2Fields    tg-todas
&GLOBAL-DEFINE page6Fields    cFile rsDestiny rsExecution 

                                                                   
&GLOBAL-DEFINE page6Text      



/* Parameters Definitions ---                                           */
{esp\imp\esimp003tt.i}
{upc\btb910za-upc.i}

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */


DEFINE VARIABLE l-permis-alterar AS LOGICAL INITIAL NO NO-UNDO.

DEFINE VARIABLE c-cod-estab AS CHARACTER   NO-UNDO.

&Scoped-define FIELDS-IN-QUERY-br-invoice tt-invoice.nr-invoice tt-invoice.embarque tt-invoice.dt-vencim tt-invoice.parcela tt-invoice.vl-invoice   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-invoice   
&Scoped-define SELF-NAME br-invoice
&Scoped-define QUERY-STRING-br-invoice FOR EACH tt-invoice
&Scoped-define OPEN-QUERY-br-invoice OPEN QUERY {&SELF-NAME} FOR EACH tt-invoice.
&Scoped-define TABLES-IN-QUERY-br-invoice tt-invoice
&Scoped-define FIRST-TABLE-IN-QUERY-br-invoice tt-invoice






DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOTable} AS HANDLE NO-UNDO.
DEFINE VARIABLE wh-pesquisa AS HANDLE NO-UNDO.
DEF VAR l-updating AS LOGICAL NO-UNDO.



DEF TEMP-TABLE tt-invoice
    FIELD nr-invoice        LIKE invoice-emb-imp.nr-invoice
    FIELD dt-vencim         LIKE invoice-emb-imp.dt-vencim
    FIELD embarque          LIKE invoice-emb-imp.embarque
    FIELD parcela           LIKE invoice-emb-imp.parcela
    FIELD vl-invoice        LIKE invoice-emb-imp.vl-invoice.
    

DEF TEMP-TABLE tt-pagamento-invoice
    FIELD nr-pagamento      LIKE mgesp.pagamento-invoice.nr-pagamento
    FIELD embarque          LIKE mgesp.pagamento-invoice.embarque
    FIELD nr-invoice        LIKE mgesp.pagamento-invoice.nr-invoice
    FIELD parcela           LIKE mgesp.pagamento-invoice.parcela
    FIELD cond-pagto        AS CHARACTER
    FIELD dt-vencimento     LIKE invoice-emb-imp.dt-vencim
    FIELD valor             LIKE mgesp.pagamento-invoice.valor.


DEF TEMP-TABLE tt-pagamento-receber 
    FIELD nr-pagamento      LIKE mgesp.pagamento.nr-pagamento
    FIELD data-ci           LIKE mgesp.pagamento.data-ci
    FIELD cod-emitente      LIKE mgesp.pagamento.cod-emitente
    FIELD nome-abrev        LIKE emitente.nome-abrev
    FIELD recebido-ap       LIKE mgesp.pagamento.recebido-ap
    FIELD selecionar        AS CHAR.


DEF TEMP-TABLE tt-pagamento-contrato
    FIELD nr-pagamento      LIKE mgesp.pagamento.nr-pagamento
    FIELD data-ci           LIKE mgesp.pagamento.data-ci
    FIELD cod-emitente      LIKE mgesp.pagamento.cod-emitente
    FIELD nome-abrev        LIKE emitente.nome-abrev
    FIELD recebido-ap       LIKE mgesp.pagamento.recebido-ap
    FIELD nr-cont-cambio    LIKE mgesp.pagamento.nr-cont-cambio
    FIELD selecionar        AS CHAR.


DEF TEMP-TABLE tt-pagamento-swift
    FIELD nr-pagamento      LIKE mgesp.pagamento.nr-pagamento
    FIELD data-ci           LIKE mgesp.pagamento.data-ci
    FIELD cod-emitente      LIKE mgesp.pagamento.cod-emitente
    FIELD nome-abrev        LIKE emitente.nome-abrev
    FIELD recebido-ap       LIKE mgesp.pagamento.recebido-ap
    FIELD nr-cont-cambio    LIKE mgesp.pagamento.nr-cont-cambio
    FIELD swift             LIKE mgesp.pagamento.swift
    FIELD selecionar        AS CHAR.




DEF VAR resp AS LOGICAL INITIAL NO NO-UNDO.


DEF VAR c-imp-old AS CHAR.
DEF VAR c-arq-old AS CHAR.
DEF VAR c-arq-old-batch AS CHAR.



def var l-ok               as logical no-undo.
def var c-arq-digita       as char    no-undo.
def var c-terminal         as char    no-undo.
def var c-rtf              as char    no-undo.
def var c-arq-layout       as char    no-undo.      
def var c-arq-temp         as char    no-undo.
DEF VAR c-modelo-default   AS CHAR    NO-UNDO.

DEFINE VARIABLE de-valor-invoice AS DECIMAL     NO-UNDO.
def stream s-imp.

/*15/02/2005 - tech1007 - Variavel definida para tratar se o programa est† rodando no WebEnabler*/
DEFINE SHARED VARIABLE hWenController AS HANDLE NO-UNDO.



define buffer b-tt-digita for tt-digita.


/* Transfer Definitions */
def var raw-param        as raw no-undo.

DEF VAR t-pag-ini     AS INT.
DEF VAR t-pag-fim     AS INT.
DEF VAR t-linha       AS CHAR.
DEF VAR t-ncm         AS CHAR.
DEF VAR t-comissao    AS CHAR.
DEF VAR t-RefBancaria AS CHAR.

DEF VAR num-pag AS INT.
DEF VAR tot AS DEC.

DEF VAR i-nome-programa AS CHAR.
DEF VAR i-ponto AS INT.
DEF VAR i-sequencia AS INT.
DEF VAR i-conteudo AS CHAR.
{esp/es0018.i}




DEFINE VARIABLE v_titulo_ccusto   AS CHARACTER NO-UNDO.

DEFINE TEMP-TABLE tt-unid-negoc NO-UNDO
    FIELD cod-unid-negoc AS CHARACTER
    FIELD descricao      AS CHARACTER.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Maintenance
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-contrato

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-pagamento-contrato tt-pagamento-invoice ~
tt-pagamento-receber tt-pagamento-swift

/* Definitions for BROWSE br-contrato                                   */
&Scoped-define FIELDS-IN-QUERY-br-contrato tt-pagamento-contrato.nr-pagamento tt-pagamento-contrato.recebido-ap tt-pagamento-contrato.nr-cont-cambio tt-pagamento-contrato.data-ci tt-pagamento-contrato.cod-emitente tt-pagamento-contrato.nome-abrev   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-contrato   
&Scoped-define SELF-NAME br-contrato
&Scoped-define QUERY-STRING-br-contrato FOR EACH tt-pagamento-contrato BY tt-pagamento-contrato.nr-pagamento DESCENDING
&Scoped-define OPEN-QUERY-br-contrato OPEN QUERY {&SELF-NAME} FOR EACH tt-pagamento-contrato BY tt-pagamento-contrato.nr-pagamento DESCENDING.
&Scoped-define TABLES-IN-QUERY-br-contrato tt-pagamento-contrato
&Scoped-define FIRST-TABLE-IN-QUERY-br-contrato tt-pagamento-contrato


/* Definitions for BROWSE br-fatura                                     */
&Scoped-define FIELDS-IN-QUERY-br-fatura tt-pagamento-invoice.embarque tt-pagamento-invoice.cond-pagto tt-pagamento-invoice.nr-invoice tt-pagamento-invoice.parcela tt-pagamento-invoice.dt-vencimento tt-pagamento-invoice.Valor   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-fatura   
&Scoped-define SELF-NAME br-fatura
&Scoped-define QUERY-STRING-br-fatura FOR EACH tt-pagamento-invoice BY tt-pagamento-invoice.nr-pagamento DESCENDING
&Scoped-define OPEN-QUERY-br-fatura OPEN QUERY {&SELF-NAME} FOR EACH tt-pagamento-invoice BY tt-pagamento-invoice.nr-pagamento DESCENDING.
&Scoped-define TABLES-IN-QUERY-br-fatura tt-pagamento-invoice
&Scoped-define FIRST-TABLE-IN-QUERY-br-fatura tt-pagamento-invoice


/* Definitions for BROWSE br-receber                                    */
&Scoped-define FIELDS-IN-QUERY-br-receber tt-pagamento-receber.selecionar tt-pagamento-receber.nr-pagamento tt-pagamento-receber.recebido-ap tt-pagamento-receber.data-ci tt-pagamento-receber.cod-emitente tt-pagamento-receber.nome-abrev   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-receber   
&Scoped-define SELF-NAME br-receber
&Scoped-define QUERY-STRING-br-receber FOR EACH tt-pagamento-receber BY tt-pagamento-receber.nr-pagamento DESCENDING
&Scoped-define OPEN-QUERY-br-receber OPEN QUERY {&SELF-NAME} FOR EACH tt-pagamento-receber BY tt-pagamento-receber.nr-pagamento DESCENDING.
&Scoped-define TABLES-IN-QUERY-br-receber tt-pagamento-receber
&Scoped-define FIRST-TABLE-IN-QUERY-br-receber tt-pagamento-receber


/* Definitions for BROWSE br-swift                                      */
&Scoped-define FIELDS-IN-QUERY-br-swift tt-pagamento-swift.nr-pagamento tt-pagamento-swift.recebido-ap tt-pagamento-swift.nr-cont-cambio tt-pagamento-swift.swift tt-pagamento-swift.data-ci tt-pagamento-swift.cod-emitente tt-pagamento-swift.nome-abrev   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-swift   
&Scoped-define SELF-NAME br-swift
&Scoped-define QUERY-STRING-br-swift FOR EACH tt-pagamento-swift BY tt-pagamento-swift.nr-pagamento DESCENDING
&Scoped-define OPEN-QUERY-br-swift OPEN QUERY {&SELF-NAME} FOR EACH tt-pagamento-swift BY tt-pagamento-swift.nr-pagamento DESCENDING.
&Scoped-define TABLES-IN-QUERY-br-swift tt-pagamento-swift
&Scoped-define FIRST-TABLE-IN-QUERY-br-swift tt-pagamento-swift


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-br-fatura}

/* Definitions for FRAME fpage2                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage2 ~
    ~{&OPEN-QUERY-br-receber}

/* Definitions for FRAME fpage3                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage3 ~
    ~{&OPEN-QUERY-br-contrato}

/* Definitions for FRAME fpage4                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage4 ~
    ~{&OPEN-QUERY-br-swift}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar btFirst btPrev btNext btLast ~
btGoTo btSearch btAdd btCopy btUpdate btDelete btUndo btCancel btSave ~
btQueryJoins btReportsJoins btExit btHelp 

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

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 120 BY 1.5
     BGCOLOR 7 .

DEFINE BUTTON bt-excluir 
     LABEL "Excluir" 
     SIZE 12 BY 1.

DEFINE BUTTON bt-incluir 
     LABEL "Incluir" 
     SIZE 12 BY 1.

DEFINE VARIABLE c-desc-cond-pagto AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 21 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-abrev AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 47 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-banco AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 21 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-centro AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 15.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-despesa AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 14.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-moeda AS CHARACTER FORMAT "x(12)":U 
     VIEW-AS FILL-IN 
     SIZE 15.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-moeda-1 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 30.72 BY .88 NO-UNDO.

DEFINE VARIABLE txt-tipo AS CHARACTER FORMAT "X(256)":U INITIAL "Tipo de CI:" 
      VIEW-AS TEXT 
     SIZE 8 BY .67 NO-UNDO.

DEFINE RECTANGLE RECT-38
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 65 BY 10.

DEFINE RECTANGLE RECT-39
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 49.57 BY 16.33.

DEFINE RECTANGLE RECT-42
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 65 BY 6.25.

DEFINE BUTTON bt-desmarcar 
     LABEL "Desmarcar" 
     SIZE 13 BY 1.13.

DEFINE BUTTON bt-marcar 
     LABEL "Marcar" 
     SIZE 13 BY 1.13.

DEFINE BUTTON bt-receber 
     LABEL "Receber" 
     SIZE 13 BY 1.13.

DEFINE VARIABLE tg-todas AS LOGICAL INITIAL no 
     LABEL "Marcar / Desmarcar todas" 
     VIEW-AS TOGGLE-BOX
     SIZE 28 BY .83 NO-UNDO.

DEFINE BUTTON bt-selecionar 
     LABEL "Selecionar ..." 
     SIZE 15 BY 1.13.

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
     SIZE 54 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE rsDestiny AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Impressora", 1,
"Arquivo", 2,
"Terminal", 3
     SIZE 69.86 BY 1.08
     FONT 1 NO-UNDO.

DEFINE VARIABLE rsExecution AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "On-Line", 1,
"Batch", 2
     SIZE 42 BY .92
     FONT 1 NO-UNDO.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 103.86 BY 2.92.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 104 BY 2.25.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-contrato FOR 
      tt-pagamento-contrato SCROLLING.

DEFINE QUERY br-fatura FOR 
      tt-pagamento-invoice SCROLLING.

DEFINE QUERY br-receber FOR 
      tt-pagamento-receber SCROLLING.

DEFINE QUERY br-swift FOR 
      tt-pagamento-swift SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-contrato
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-contrato wMaintenance _FREEFORM
  QUERY br-contrato DISPLAY
      tt-pagamento-contrato.nr-pagamento                   COLUMN-LABEL "Pagamento"
    tt-pagamento-contrato.recebido-ap                    COLUMN-LABEL "Recebido"
    tt-pagamento-contrato.nr-cont-cambio                 COLUMN-LABEL "Contrato"
    tt-pagamento-contrato.data-ci                        COLUMN-LABEL "Data CI"
    tt-pagamento-contrato.cod-emitente                   COLUMN-LABEL "Emitente"
    tt-pagamento-contrato.nome-abrev      FORMAT "x(50)" COLUMN-LABEL "Descriá∆o"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 112 BY 13.75 ROW-HEIGHT-CHARS .58.

DEFINE BROWSE br-fatura
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-fatura wMaintenance _FREEFORM
  QUERY br-fatura DISPLAY
      tt-pagamento-invoice.embarque        COLUMN-LABEL "Embarque"
    tt-pagamento-invoice.cond-pagto      COLUMN-LABEL "Cond.Pagto"
    tt-pagamento-invoice.nr-invoice      COLUMN-LABEL "Invoice" FORMAT "x(20)"   
    tt-pagamento-invoice.parcela         COLUMN-LABEL "Parcela"
    tt-pagamento-invoice.dt-vencimento   COLUMN-LABEL "Dt.Vencimento"
    tt-pagamento-invoice.Valor           COLUMN-LABEL "Valor" format ">>>,>>>,>>9.99"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 63 BY 4.5
         FONT 1 ROW-HEIGHT-CHARS .54.

DEFINE BROWSE br-receber
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-receber wMaintenance _FREEFORM
  QUERY br-receber DISPLAY
      tt-pagamento-receber.selecionar      FORMAT "x(5)"  COLUMN-LABEL "Sel."
    tt-pagamento-receber.nr-pagamento                   COLUMN-LABEL "Pagamento"
    tt-pagamento-receber.recebido-ap                    COLUMN-LABEL "Recebido"
    tt-pagamento-receber.data-ci                        COLUMN-LABEL "Data CI"
    tt-pagamento-receber.cod-emitente                   COLUMN-LABEL "Emitente"
    tt-pagamento-receber.nome-abrev      FORMAT "x(50)" COLUMN-LABEL "Descriá∆o"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 113 BY 11.5 ROW-HEIGHT-CHARS .58.

DEFINE BROWSE br-swift
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-swift wMaintenance _FREEFORM
  QUERY br-swift DISPLAY
      tt-pagamento-swift.nr-pagamento                   COLUMN-LABEL "Pagamento"
    tt-pagamento-swift.recebido-ap                    COLUMN-LABEL "Recebido"
    tt-pagamento-swift.nr-cont-cambio                 COLUMN-LABEL "Contrato"
    tt-pagamento-swift.swift                             COLUMN-LABEL "Swift"
    tt-pagamento-swift.data-ci                        COLUMN-LABEL "Data CI"
    tt-pagamento-swift.cod-emitente                   COLUMN-LABEL "Emitente"
    tt-pagamento-swift.nome-abrev      FORMAT "x(50)" COLUMN-LABEL "Descriá∆o"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 111 BY 13.75 ROW-HEIGHT-CHARS .58.


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
     btQueryJoins AT ROW 1.13 COL 104.43 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 108.43 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 112.43 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 116.43 HELP
          "Ajuda"
     rtToolBar AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 120.57 BY 20.92
         FONT 1.

DEFINE FRAME fPage1
     ttpagamento.dat-fft AT ROW 15 COL 79.86 COLON-ALIGNED WIDGET-ID 68
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     ttpagamento.nr-pagamento AT ROW 1.75 COL 9.43 COLON-ALIGNED
          LABEL "Nr."
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     ttpagamento.data-ci AT ROW 1.75 COL 22.14 COLON-ALIGNED
          LABEL "Data CI"
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     ttpagamento.dt-prev-fecha-cam AT ROW 1.75 COL 44 COLON-ALIGNED
          LABEL "Prev Fech Cam"
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     ttpagamento.cod-estabel AT ROW 1.75 COL 59.72 COLON-ALIGNED WIDGET-ID 6
          LABEL "Est"
          VIEW-AS FILL-IN 
          SIZE 4.29 BY .88
     ttpagamento.cod-emitente AT ROW 2.75 COL 9.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     c-nome-abrev AT ROW 2.75 COL 17 COLON-ALIGNED NO-LABEL
     ttpagamento.cod-cond-pag AT ROW 3.75 COL 9.43 COLON-ALIGNED WIDGET-ID 4
          LABEL "Cond.Pagto"
          VIEW-AS FILL-IN 
          SIZE 4 BY .88
     c-desc-cond-pagto AT ROW 3.75 COL 13.72 COLON-ALIGNED NO-LABEL WIDGET-ID 2
     ttpagamento.modalidade AT ROW 3.75 COL 44 COLON-ALIGNED
          LABEL "Modalidade"
          VIEW-AS COMBO-BOX INNER-LINES 10
          LIST-ITEMS "","Remessa Per. Variavel","TT in advance","Free of Charge","D/A at sight","D/A 30 days","D/A 45 days","D/A 60 days","D/A 75 days","D/A 90 days","D/A 120 days","D/A 180 days","D/A 360 days","TT at sight","TT 30 days","TT 45 days","TT 60 days","TT 75 days","TT 90 days","TT 120 days","TT 180 days","TT 360 days","L/C at sight","L/C 30 days","L/C 45 days","L/C 60 days","L/C 75 days","L/C 90 days","D/A at sight","D/P 30 days","D/P 45 days","D/P 60 days","D/P 75 days","D/P 90 days","D/P 120 days","D/P 180 days","D/P 360 days","Conferir" 
          DROP-DOWN-LIST
          SIZE 20 BY 1
     ttpagamento.cod-banco AT ROW 4.75 COL 9.43 COLON-ALIGNED
          LABEL "Banco"
          VIEW-AS FILL-IN 
          SIZE 4 BY .88
     c-nome-banco AT ROW 4.75 COL 13.72 COLON-ALIGNED NO-LABEL
     ttpagamento.cod-moeda AT ROW 4.75 COL 44 COLON-ALIGNED
          LABEL "Moeda"
          VIEW-AS FILL-IN 
          SIZE 4 BY .88
     c-nome-moeda AT ROW 4.75 COL 48.29 COLON-ALIGNED NO-LABEL
     ttpagamento.centro AT ROW 5.75 COL 9.43 COLON-ALIGNED
          LABEL "C.Custo"
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     c-nome-centro AT ROW 5.75 COL 17.57 COLON-ALIGNED NO-LABEL
     ttpagamento.valor-pag AT ROW 6.75 COL 9.43 COLON-ALIGNED
          LABEL "Valor" FORMAT ">>>,>>>,>>9.99"
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     ttpagamento.Tipo-despesa AT ROW 6.75 COL 44 COLON-ALIGNED HELP
          "Tipo Despesa"
          LABEL "Tp Desp"
          VIEW-AS FILL-IN 
          SIZE 3 BY .88
     c-nome-despesa AT ROW 6.75 COL 46.86 COLON-ALIGNED NO-LABEL
     ttpagamento.nr-di AT ROW 7.75 COL 9.43 COLON-ALIGNED
          LABEL "DI"
          VIEW-AS FILL-IN 
          SIZE 22 BY .88
     ttpagamento.usuario AT ROW 7.75 COL 44 COLON-ALIGNED WIDGET-ID 12
          VIEW-AS FILL-IN 
          SIZE 12 BY .79
     ttpagamento.historico[1] AT ROW 8.75 COL 9.43 COLON-ALIGNED
          LABEL "Historico"
          VIEW-AS FILL-IN 
          SIZE 54.57 BY .88
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 4
         SIZE 117 BY 17
         FONT 1.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME fPage1
     ttpagamento.historico[2] AT ROW 9.75 COL 9.43 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 54.57 BY .88
     br-fatura AT ROW 11.83 COL 2.86
     bt-incluir AT ROW 16.42 COL 3.14
     bt-excluir AT ROW 16.42 COL 15.43
     ttpagamento.recebido-ap AT ROW 3 COL 79.86 COLON-ALIGNED
          LABEL "Recebido"
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     ttpagamento.usuar-receb AT ROW 3 COL 103.86 COLON-ALIGNED WIDGET-ID 10
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     ttpagamento.valor-contrato-me AT ROW 4 COL 79.86 COLON-ALIGNED
          LABEL "Valor Contrato ME"
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     ttpagamento.tipo-contr-cambio AT ROW 4 COL 103.86 COLON-ALIGNED
          LABEL "Natureza"
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     ttpagamento.nr-cont-cambio AT ROW 5 COL 79.86 COLON-ALIGNED
          LABEL "Contr. Cambio"
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     ttpagamento.data-emissao AT ROW 5 COL 103.86 COLON-ALIGNED
          LABEL "Dt. Emiss∆o"
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     ttpagamento.swift AT ROW 6 COL 79.86 COLON-ALIGNED
          LABEL "Swift"
          VIEW-AS FILL-IN 
          SIZE 20 BY .88
     ttpagamento.data-swift AT ROW 7 COL 79.86 COLON-ALIGNED
          LABEL "Data Swift"
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     ttpagamento.instit-cambio AT ROW 8 COL 79.86 COLON-ALIGNED
          LABEL "Instituiá∆o CÉmbio"
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     ttpagamento.praca-cambio AT ROW 8 COL 103.86 COLON-ALIGNED
          LABEL "Praáa CÉmbio"
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     ttpagamento.taxa-cambio-pag AT ROW 9 COL 79.86 COLON-ALIGNED
          LABEL "Taxa CÉmbio Pagto"
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     ttpagamento.valor-contrato AT ROW 10 COL 79.86 COLON-ALIGNED
          LABEL "Valor Contrato"
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     ttpagamento.valor-ord-pag AT ROW 10 COL 103.86 COLON-ALIGNED
          LABEL "Valor Ordem"
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     ttpagamento.cod-moeda-1 AT ROW 11 COL 79.86 COLON-ALIGNED
          LABEL "Moeda"
          VIEW-AS FILL-IN 
          SIZE 3 BY .88
     c-nome-moeda-1 AT ROW 11 COL 83.14 COLON-ALIGNED NO-LABEL
     ttpagamento.taxa-cambio AT ROW 12 COL 79.86 COLON-ALIGNED
          LABEL "Taxa Cambio"
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     ttpagamento.valor-fechamento AT ROW 13 COL 79.86 COLON-ALIGNED
          LABEL "Valor Fechamento"
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     ttpagamento.dt-fecha-cam AT ROW 14 COL 79.86 COLON-ALIGNED
          LABEL "Dt. Fech. CÉmbio"
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     ttpagamento.cod-unid-negoc AT ROW 5.75 COL 44 COLON-ALIGNED WIDGET-ID 58
          VIEW-AS COMBO-BOX INNER-LINES 5
          LIST-ITEM-PAIRS "Item 1","Item 1"
          DROP-DOWN-LIST
          SIZE 20 BY 1
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 4
         SIZE 117 BY 17
         FONT 1.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME fPage1
     ttpagamento.tipo-ci AT ROW 1.75 COL 83 NO-LABEL WIDGET-ID 62
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Importaá∆o", 1,
"Serviáo", 2
          SIZE 23 BY 1
     txt-tipo AT ROW 1.88 COL 73 COLON-ALIGNED NO-LABEL WIDGET-ID 66
     RECT-38 AT ROW 1.25 COL 2
     RECT-39 AT ROW 1.25 COL 67.29
     RECT-42 AT ROW 11.33 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 4
         SIZE 117 BY 17
         FONT 1.

DEFINE FRAME fpage3
     br-contrato AT ROW 2 COL 3
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 4
         SIZE 117 BY 17.

DEFINE FRAME fpage4
     br-swift AT ROW 2 COL 3
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 4
         SIZE 117 BY 17.

DEFINE FRAME fpage6
     rsDestiny AT ROW 2.38 COL 3.14 HELP
          "Destino de Impress∆o do Relat¢rio" NO-LABEL
     btFile AT ROW 3.5 COL 57 HELP
          "Escolha do nome do arquivo"
     btConfigImpr AT ROW 3.5 COL 57 HELP
          "Configuraá∆o da impressora"
     cFile AT ROW 3.63 COL 3 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL
     rsExecution AT ROW 7 COL 3 HELP
          "Modo de Execuá∆o" NO-LABEL
     bt-selecionar AT ROW 9 COL 2
     "Destino" VIEW-AS TEXT
          SIZE 8 BY 1 AT ROW 1.5 COL 4
     "Execuá∆o" VIEW-AS TEXT
          SIZE 10 BY .92 AT ROW 5.5 COL 4
     RECT-7 AT ROW 1.92 COL 2.14
     RECT-9 AT ROW 6 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 4
         SIZE 117 BY 17.

DEFINE FRAME fpage5
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 94.86 ROW 8.5
         SIZE 11 BY 2.

DEFINE FRAME fpage2
     br-receber AT ROW 2 COL 3
     tg-todas AT ROW 13.75 COL 3
     bt-marcar AT ROW 15 COL 3
     bt-desmarcar AT ROW 15 COL 17
     bt-receber AT ROW 15 COL 37
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 4
         SIZE 117 BY 17.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Maintenance
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: ttpagamento T "?" NO-UNDO mgesp pagamento
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
         HEIGHT             = 20.92
         WIDTH              = 120.57
         MAX-HEIGHT         = 38.88
         MAX-WIDTH          = 182.86
         VIRTUAL-HEIGHT     = 38.88
         VIRTUAL-WIDTH      = 182.86
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
       FRAME fpage2:FRAME = FRAME fpage0:HANDLE
       FRAME fpage3:FRAME = FRAME fpage0:HANDLE
       FRAME fpage4:FRAME = FRAME fpage0:HANDLE
       FRAME fpage5:FRAME = FRAME fpage6:HANDLE
       FRAME fpage6:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fPage1
   Custom                                                               */
/* BROWSE-TAB br-fatura historico[2] fPage1 */
/* SETTINGS FOR FILL-IN ttpagamento.centro IN FRAME fPage1
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ttpagamento.cod-banco IN FRAME fPage1
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ttpagamento.cod-cond-pag IN FRAME fPage1
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ttpagamento.cod-estabel IN FRAME fPage1
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ttpagamento.cod-moeda IN FRAME fPage1
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ttpagamento.cod-moeda-1 IN FRAME fPage1
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ttpagamento.data-ci IN FRAME fPage1
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ttpagamento.data-emissao IN FRAME fPage1
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ttpagamento.data-swift IN FRAME fPage1
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ttpagamento.dt-fecha-cam IN FRAME fPage1
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ttpagamento.dt-prev-fecha-cam IN FRAME fPage1
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ttpagamento.historico[1] IN FRAME fPage1
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ttpagamento.historico[2] IN FRAME fPage1
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ttpagamento.instit-cambio IN FRAME fPage1
   EXP-LABEL                                                            */
/* SETTINGS FOR COMBO-BOX ttpagamento.modalidade IN FRAME fPage1
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ttpagamento.nr-cont-cambio IN FRAME fPage1
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ttpagamento.nr-di IN FRAME fPage1
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ttpagamento.nr-pagamento IN FRAME fPage1
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ttpagamento.praca-cambio IN FRAME fPage1
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ttpagamento.recebido-ap IN FRAME fPage1
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ttpagamento.swift IN FRAME fPage1
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ttpagamento.taxa-cambio IN FRAME fPage1
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ttpagamento.taxa-cambio-pag IN FRAME fPage1
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ttpagamento.tipo-contr-cambio IN FRAME fPage1
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ttpagamento.Tipo-despesa IN FRAME fPage1
   EXP-LABEL EXP-HELP                                                   */
/* SETTINGS FOR FILL-IN ttpagamento.valor-contrato IN FRAME fPage1
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ttpagamento.valor-contrato-me IN FRAME fPage1
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ttpagamento.valor-fechamento IN FRAME fPage1
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ttpagamento.valor-ord-pag IN FRAME fPage1
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ttpagamento.valor-pag IN FRAME fPage1
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FRAME fpage2
                                                                        */
/* BROWSE-TAB br-receber 1 fpage2 */
/* SETTINGS FOR FRAME fpage3
                                                                        */
/* BROWSE-TAB br-contrato 1 fpage3 */
/* SETTINGS FOR FRAME fpage4
                                                                        */
/* BROWSE-TAB br-swift 1 fpage4 */
/* SETTINGS FOR FRAME fpage5
                                                                        */
/* SETTINGS FOR FRAME fpage6
                                                                        */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMaintenance)
THEN wMaintenance:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-contrato
/* Query rebuild information for BROWSE br-contrato
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-pagamento-contrato BY tt-pagamento-contrato.nr-pagamento DESCENDING.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-contrato */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-fatura
/* Query rebuild information for BROWSE br-fatura
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-pagamento-invoice BY tt-pagamento-invoice.nr-pagamento DESCENDING.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-fatura */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-receber
/* Query rebuild information for BROWSE br-receber
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-pagamento-receber BY tt-pagamento-receber.nr-pagamento DESCENDING.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-receber */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-swift
/* Query rebuild information for BROWSE br-swift
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-pagamento-swift BY tt-pagamento-swift.nr-pagamento DESCENDING.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-swift */
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

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage2
/* Query rebuild information for FRAME fpage2
     _Query            is NOT OPENED
*/  /* FRAME fpage2 */
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

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage5
/* Query rebuild information for FRAME fpage5
     _Query            is NOT OPENED
*/  /* FRAME fpage5 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage6
/* Query rebuild information for FRAME fpage6
     _Query            is NOT OPENED
*/  /* FRAME fpage6 */
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
    /*
    bt-incluir:SENSITIVE     IN FRAME fpage1 = TRUE.  
    bt-excluir:SENSITIVE     IN FRAME fpage1 = TRUE.  
    */



    ASSIGN ttpagamento.valor-pag:SENSITIVE  IN FRAME fpage1   = FALSE 
           ttpagamento.usuar-receb:SENSITIVE  IN FRAME fpage1 = FALSE.


    br-fatura:SENSITIVE      IN FRAME fpage1 = TRUE.  

    bt-selecionar:SENSITIVE  IN FRAME fpage6 = TRUE.  
    rsDestiny:SENSITIVE      IN FRAME fpage6 = TRUE.
    rsExecution:SENSITIVE    IN FRAME fpage6 = TRUE.
    btConfigImpr:SENSITIVE   IN FRAME fpage6 = TRUE.
    btFile:SENSITIVE         IN FRAME fpage6 = TRUE.

    RUN pi-verifica-permis.
        
    ASSIGN bt-marcar:SENSITIVE      IN FRAME fpage2 = l-permis-alterar
           bt-receber:SENSITIVE     IN FRAME fpage2 = l-permis-alterar
           bt-desmarcar:SENSITIVE   IN FRAME fpage2 = l-permis-alterar
           br-receber:SENSITIVE     IN FRAME fpage2 = l-permis-alterar
           tg-todas:SENSITIVE       IN FRAME fpage2 = l-permis-alterar.  
    

    br-contrato:SENSITIVE    IN FRAME fpage3 = TRUE.  

    br-swift:SENSITIVE       IN FRAME fpage4 = TRUE. 


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fPage1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fPage1 wMaintenance
ON ENTRY OF FRAME fPage1
DO:
    /*
    DEF VAR c-nr-pagamento AS INT.
    DEFINE VARIABLE rGoTo AS ROWID NO-UNDO.

    IF num-pag <> 0 THEN DO:
/*    
       FIND FIRST mgesp.pagamento 
            WHERE mgesp.pagamento.nr-pagamento = num-pag no-lock NO-ERROR.
       if avail mgesp.pagamento then do:        
           ASSIGN c-nr-pagamento = pagamento.nr-pagamento. 
*/           
       ASSIGN c-nr-pagamento = num-pag. 

       RUN goToKey IN {&hDBOTable} (INPUT c-nr-pagamento).
       IF RETURN-VALUE = "NOK":U THEN DO:
          RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT "Cadastro Pagamento":U).            
          RETURN NO-APPLY.
       END.

       /*:T Retorna rowid do registro corrente do DBO */
       RUN getRowid IN {&hDBOTable} (OUTPUT rGoTo).

       /*:T Reposiciona registro com base em um rowid */
       RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).
    END.

    RUN monta.
    */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fpage2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fpage2 wMaintenance
ON ENTRY OF FRAME fpage2
DO:

    FOR EACH tt-pagamento-receber:
        DELETE tt-pagamento-receber.
    END.
    {&OPEN-QUERY-br-receber}


    IF l-permis-alterar THEN DO:
        FOR EACH mgesp.pagamento 
           WHERE mgesp.pagamento.recebido-ap = NO no-lock:
            FIND emitente NO-LOCK WHERE 
                 emitente.cod-emitente = mgesp.pagamento.cod-emitente NO-ERROR.            

            CREATE tt-pagamento-receber.
            ASSIGN tt-pagamento-receber.nr-pagamento = mgesp.pagamento.nr-pagamento
                   tt-pagamento-receber.data-ci      = mgesp.pagamento.data-ci
                   tt-pagamento-receber.cod-emitente = mgesp.pagamento.cod-emitente
                   tt-pagamento-receber.nome-abrev   = if avail emitente then emitente.nome-abrev else "".
        END.

        {&OPEN-QUERY-br-receber}
    END.
    ELSE DO:
        MESSAGE "Vocà n∆o tem permiss∆o de receber CI. Caso necessite permiss∆o entre em contato com departamento de TI."
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fpage2 wMaintenance
ON LEAVE OF FRAME fpage2
DO:
  /*
    FOR EACH tt-pagamento-receber:
        DELETE tt-pagamento-receber.
    END.
    {&OPEN-QUERY-br-receber}


    FOR EACH pagamento WHERE
             pagamento.recebido-ap = NO:
             FIND emitente NO-LOCK WHERE 
                  emitente.cod-emitente = pagamento.cod-emitente NO-ERROR.
             CREATE tt-pagamento-receber.
                ASSIGN tt-pagamento-receber.nr-pagamento = pagamento.nr-pagamento
                       tt-pagamento-receber.data-ci      = pagamento.data-ci
                       tt-pagamento-receber.cod-emitente = pagamento.cod-emitente
                       tt-pagamento-receber.nome-abrev   = emitente.nome-abrev.
    END.
    {&OPEN-QUERY-br-receber}
*/

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fpage3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fpage3 wMaintenance
ON ENTRY OF FRAME fpage3
DO:

    FOR EACH tt-pagamento-contrato:
        DELETE tt-pagamento-contrato.
    END.
    {&OPEN-QUERY-br-contrato}

    FOR EACH mgesp.pagamento 
       WHERE mgesp.pagamento.recebido-ap    = YES 
         AND mgesp.pagamento.nr-cont-cambio = "" no-lock:
        FIND emitente NO-LOCK WHERE 
             emitente.cod-emitente = mgesp.pagamento.cod-emitente NO-ERROR.
        CREATE tt-pagamento-contrato.
           ASSIGN tt-pagamento-contrato.nr-pagamento   = mgesp.pagamento.nr-pagamento
                  tt-pagamento-contrato.data-ci        = mgesp.pagamento.data-ci
                  tt-pagamento-contrato.cod-emitente   = mgesp.pagamento.cod-emitente
                  tt-pagamento-contrato.nome-abrev     = if avail emitente then emitente.nome-abrev else ""
                  tt-pagamento-contrato.nr-cont-cambio = mgesp.pagamento.nr-cont-cambio
                  tt-pagamento-contrato.recebido-ap    = mgesp.pagamento.recebido-ap.
    END.
    {&OPEN-QUERY-br-contrato}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fpage4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fpage4 wMaintenance
ON ENTRY OF FRAME fpage4
DO:
  
    FOR EACH tt-pagamento-swift:
        DELETE tt-pagamento-swift.
    END.
    {&OPEN-QUERY-br-swift}


    FOR EACH mgesp.pagamento 
       WHERE mgesp.pagamento.recebido-ap = YES 
         AND mgesp.pagamento.swift       = "" no-lock:
        FIND emitente NO-LOCK WHERE 
             emitente.cod-emitente = mgesp.pagamento.cod-emitente NO-ERROR.
        CREATE tt-pagamento-swift.
           ASSIGN tt-pagamento-swift.nr-pagamento   = mgesp.pagamento.nr-pagamento
                  tt-pagamento-swift.data-ci        = mgesp.pagamento.data-ci
                  tt-pagamento-swift.cod-emitente   = mgesp.pagamento.cod-emitente
                  tt-pagamento-swift.nome-abrev     = if avail emitente then emitente.nome-abrev else ""
                  tt-pagamento-swift.nr-cont-cambio = mgesp.pagamento.nr-cont-cambio
                  tt-pagamento-swift.swift          = mgesp.pagamento.swift
                  tt-pagamento-swift.recebido-ap    = mgesp.pagamento.recebido-ap.
    END.
    {&OPEN-QUERY-br-swift}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fpage6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fpage6 wMaintenance
ON ENTRY OF FRAME fpage6
DO:  
    btFile:visible        = no.
    btConfigImpr:visible  = yes.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-contrato
&Scoped-define FRAME-NAME fpage3
&Scoped-define SELF-NAME br-contrato
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-contrato wMaintenance
ON MOUSE-SELECT-CLICK OF br-contrato IN FRAME fpage3
DO:
    ASSIGN num-pag = tt-pagamento-contrato.nr-pagamento.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-receber
&Scoped-define FRAME-NAME fpage2
&Scoped-define SELF-NAME br-receber
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-receber wMaintenance
ON MOUSE-SELECT-CLICK OF br-receber IN FRAME fpage2
DO:
    ASSIGN num-pag = tt-pagamento-receber.nr-pagamento.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-receber wMaintenance
ON MOUSE-SELECT-DBLCLICK OF br-receber IN FRAME fpage2
DO:
    
    IF tt-pagamento-receber.selecionar = "x" THEN DO:
       ASSIGN tt-pagamento-receber.selecionar = "".
    END.
    ELSE DO:
       ASSIGN tt-pagamento-receber.selecionar = "x".
    END.

    BROWSE br-receber:REFRESH().
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-swift
&Scoped-define FRAME-NAME fpage4
&Scoped-define SELF-NAME br-swift
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-swift wMaintenance
ON MOUSE-SELECT-CLICK OF br-swift IN FRAME fpage4
DO:
    ASSIGN num-pag = tt-pagamento-swift.nr-pagamento.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage2
&Scoped-define SELF-NAME bt-desmarcar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-desmarcar wMaintenance
ON CHOOSE OF bt-desmarcar IN FRAME fpage2 /* Desmarcar */
DO:

    IF tg-todas:SCREEN-VALUE = "yes" THEN DO:
       FOR EACH tt-pagamento-receber:
           ASSIGN tt-pagamento-receber.selecionar = "".
       END.
    END.
    ELSE DO:
        ASSIGN tt-pagamento-receber.selecionar = "". 
    END.

    BROWSE br-receber:REFRESH().
    /*

    {&OPEN-QUERY-br-receber}
     */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME bt-excluir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-excluir wMaintenance
ON CHOOSE OF bt-excluir IN FRAME fPage1 /* Excluir */
DO:
    IF ttpagamento.recebido-ap THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW",
                                   INPUT 17006,
                                   INPUT "Exclus∆o de invoice n∆o permitida!" + "~~" + 
                                         "CI j† foi recebida no Financeiro. D£vidas entrar em contato com o setor financeiro.").
        RETURN NO-APPLY.
    END.

    IF AVAIL tt-pagamento-invoice THEN DO:
        MESSAGE "Deseja excluir este registro?" UPDATE resp
            VIEW-AS ALERT-BOX  QUESTION BUTTONS YES-NO 
            TITLE "Atualizaá∆o de dados".

        IF resp = YES THEN DO:
            FIND mgesp.pagamento-invoice WHERE
                 mgesp.pagamento-invoice.nr-pagamento = int(tt-pagamento-invoice.nr-pagamento) AND
                 mgesp.pagamento-invoice.embarque     = tt-pagamento-invoice.embarque          AND
                 mgesp.pagamento-invoice.nr-invoice   = tt-pagamento-invoice.nr-invoice        exclusive-lock NO-ERROR.
            IF AVAIL mgesp.pagamento-invoice THEN DO:            
                DELETE mgesp.pagamento-invoice. 
            END.
            ASSIGN de-valor-invoice = 0.
            FOR EACH pagamento-invoice NO-LOCK
               WHERE pagamento-invoice.nr-pagamento = ttpagamento.nr-pagamento:

                ASSIGN de-valor-invoice = de-valor-invoice + pagamento-invoice.valor.
            END.

            FIND FIRST pagamento EXCLUSIVE-LOCK
                 WHERE pagamento.nr-pagamento = ttpagamento.nr-pagamento NO-ERROR.
            IF AVAIL pagamento THEN DO:
                ASSIGN pagamento.valor-pag = de-valor-invoice
                       ttpagamento.valor-pag:SCREEN-VALUE IN FRAME fPage1 = STRING(de-valor-invoice,">>>,>>>,>>9.99").
                RELEASE pagamento.
            END.

        END.

        /*RUN saveRecord IN THIS-PROCEDURE.*/

        RUN monta.

        /*bt-excluir:SENSITIVE     IN FRAME fpage1 = FALSE.*/
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-incluir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-incluir wMaintenance
ON CHOOSE OF bt-incluir IN FRAME fPage1 /* Incluir */
DO:
    IF ttpagamento.recebido-ap THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW",
                                   INPUT 17006,
                                   INPUT "Inclus∆o de invoice n∆o permitida!" + "~~" + 
                                         "CI j† foi recebida no Financeiro. D£vidas entrar em contato com o setor financeiro.").
        RETURN NO-APPLY.
    END.

    /*btsave:SENSITIVE      IN FRAME fpage0 = TRUE.  */


    /************* Bot∆o ************/
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

    DEFINE BUTTON btProcura 
            LABEL "&Consulta" 
            SIZE 10 BY 1
            BGCOLOR 8.
    /*********************************/


    /*********** Campo **************/
    DEFINE VARIABLE c-embarque AS CHAR
            LABEL "Embarque" 
            VIEW-AS FILL-IN 
            SIZE 12 BY .88 NO-UNDO.
    /*********************************/


    /********** Query ***************/
    DEFINE QUERY br-invoice FOR 
          tt-invoice SCROLLING.
    /*********************************/       


    /********** Browse ***************/
    DEFINE BROWSE br-invoicex
           QUERY br-invoice DISPLAY
                 tt-invoice.nr-invoice    FORMAT "x(20)"       COLUMN-LABEL "N£mero"
                 tt-invoice.embarque      COLUMN-LABEL "Embarque"
                 tt-invoice.dt-vencim     COLUMN-LABEL "Vencimento"
                 tt-invoice.parcela       COLUMN-LABEL "Parcela"
                 tt-invoice.vl-invoice    COLUMN-LABEL "Vl. Invoice"
           WITH NO-ROW-MARKERS SEPARATORS SIZE 58 BY 4.00
                FONT 1 ROW-HEIGHT-CHARS .58.
    /*********************************/


    /*********** Frame **************/
    DEFINE FRAME f-invoice
           c-embarque        AT ROW 1.21 COL 17.72 COLON-ALIGNED
           btProcura         AT ROW 1.15 COL 32.00 
           br-invoicex       AT ROW 2.21 COL 2.00
           btGoToOK          AT ROW 6.63 COL 2.14
           btGoToCancel      AT ROW 6.63 COL 13
           rtGoToButton      AT ROW 6.38 COL 1
           SPACE(0.28)
           WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
                THREE-D SCROLLABLE TITLE "Embarque" FONT 1
                DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.
    /*********************************/

    /************ Bot∆o Consulta ***********/
    ON "CHOOSE":U OF btProcura IN FRAME f-invoice DO:
           FOR EACH tt-invoice:
               DELETE tt-invoice.
           END.
           OPEN QUERY br-invoice FOR EACH tt-invoice.
           FOR EACH invoice-emb-imp NO-LOCK 
              WHERE invoice-emb-imp.cod-estabel = c-cod-estab
                AND invoice-emb-imp.embarque = c-embarque:SCREEN-VALUE:
               CREATE tt-invoice.
               ASSIGN tt-invoice.nr-invoice    = invoice-emb-imp.nr-invoice
                      tt-invoice.dt-vencim     = invoice-emb-imp.dt-vencim
                      tt-invoice.embarque      = invoice-emb-imp.embarque
                      tt-invoice.parcela       = invoice-emb-imp.parcela
                      tt-invoice.vl-invoice    = invoice-emb-imp.vl-invoice.
           END.
           OPEN QUERY br-invoice FOR EACH tt-invoice.
    END.
    /*********************************/

    /*/********* Duplo clique no Browse *********/
    ON "MOUSE-SELECT-DBLCLICK":U OF br-invoicex DO:
    END.*/

    ON  "CHOOSE":U OF btGoToOK IN FRAME f-invoice DO:

        IF NOT AVAIL tt-invoice THEN DO:
            MESSAGE "Favor selecione algum embarque!"
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
            RETURN NO-APPLY.
        END.
        ELSE DO:
            FIND mgesp.pagamento-invoice NO-LOCK                            WHERE
                 mgesp.pagamento-invoice.embarque   = tt-invoice.embarque   AND
                 mgesp.pagamento-invoice.nr-invoice = tt-invoice.nr-invoice AND
                 mgesp.pagamento-invoice.parcela    = tt-invoice.parcela    NO-ERROR.
            IF AVAIL mgesp.pagamento-invoice THEN DO:
               MESSAGE "Fatura j† associada a pagamento: " mgesp.pagamento-invoice.nr-pagamento VIEW-AS ALERT-BOX.
               RETURN NO-APPLY.
            END.
            ELSE DO:
                CREATE mgesp.pagamento-invoice.
                ASSIGN mgesp.pagamento-invoice.nr-pagamento = int(ttpagamento.nr-pagamento:SCREEN-VALUE IN FRAME fpage1)
                       mgesp.pagamento-invoice.embarque     = tt-invoice.embarque
                       mgesp.pagamento-invoice.nr-invoice   = tt-invoice.nr-invoice
                       mgesp.pagamento-invoice.parcela      = tt-invoice.parcela
                       mgesp.pagamento-invoice.valor        = tt-invoice.vl-invoice.

                /*ASSIGN ttpagamento.dt-prev-fecha-cam:SCREEN-VALUE IN FRAME fpage1 = STRING(tt-invoice.dt-vencim).*/

                MESSAGE "Pagamento invoice cadastrado com sucesso"
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.

                ASSIGN de-valor-invoice = 0.
                FOR EACH pagamento-invoice NO-LOCK
                   WHERE pagamento-invoice.nr-pagamento = ttpagamento.nr-pagamento:

                    ASSIGN de-valor-invoice = de-valor-invoice + pagamento-invoice.valor.
                END.

                FIND FIRST pagamento EXCLUSIVE-LOCK
                     WHERE pagamento.nr-pagamento = ttpagamento.nr-pagamento NO-ERROR.
                IF AVAIL pagamento THEN DO:
                    ASSIGN pagamento.dt-prev-fecha-cam  = tt-invoice.dt-vencim
                           pagamento.valor-pag          = de-valor-invoice
                           ttpagamento.valor-pag:SCREEN-VALUE IN FRAME fPage1 = STRING(de-valor-invoice,">>>,>>>,>>9.99")
                           ttpagamento.dt-prev-fecha-cam:SCREEN-VALUE IN FRAME fpage1 = STRING(tt-invoice.dt-vencim).
                    MESSAGE de-valor-invoice " - " tt-invoice.dt-vencim
                        VIEW-AS ALERT-BOX INFO BUTTONS OK.
                    RELEASE pagamento.
                END.

                RUN monta. 

                APPLY "GO":U TO FRAME f-invoice.
            END.
        END.
    END.

    /******************************************/

    ENABLE c-embarque btGoToOK btGoToCancel btProcura br-invoicex
           WITH FRAME f-invoice.

    WAIT-FOR "GO":U OF FRAME f-invoice.

    /*RUN saveRecord IN THIS-PROCEDURE.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage2
&Scoped-define SELF-NAME bt-marcar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-marcar wMaintenance
ON CHOOSE OF bt-marcar IN FRAME fpage2 /* Marcar */
DO:

    IF tg-todas:SCREEN-VALUE = "yes" THEN DO:
       FOR EACH tt-pagamento-receber:
           ASSIGN tt-pagamento-receber.selecionar = "x".
       END.
    END.
    ELSE DO:
        ASSIGN tt-pagamento-receber.selecionar = "x". 
    END.

    BROWSE br-receber:REFRESH().

    /*
    {&OPEN-QUERY-br-receber}
     */

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-receber
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-receber wMaintenance
ON CHOOSE OF bt-receber IN FRAME fpage2 /* Receber */
DO:
    FOR EACH tt-pagamento-receber WHERE
             tt-pagamento-receber.selecionar = "x":
        FIND FIRST mgesp.pagamento 
             WHERE mgesp.pagamento.nr-pagamento = tt-pagamento-receber.nr-pagamento exclusive-lock NO-ERROR.
        IF AVAIL mgesp.pagamento THEN DO:
            ASSIGN mgesp.pagamento.recebido-ap = YES
                   mgesp.pagamento.usuar-receb = c-seg-usuario. 
        END.
    END.

    APPLY "entry" TO FRAME fpage2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage6
&Scoped-define SELF-NAME bt-selecionar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-selecionar wMaintenance
ON CHOOSE OF bt-selecionar IN FRAME fpage6 /* Selecionar ... */
DO:

    /************* Bot∆o ************/
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

    DEFINE BUTTON btImprimir 
            LABEL "&Imprimir" 
            SIZE 10 BY 1
            BGCOLOR 8.
    /*********************************/


    /*********** Campo **************/
    DEFINE VARIABLE c-i-pag-ini AS INT FORMAT 999999 INITIAL 0
            LABEL "Pagamento inicial" 
            VIEW-AS FILL-IN 
            SIZE 8 BY .88 NO-UNDO.

    DEFINE VARIABLE c-i-pag-fim AS INT FORMAT 999999 INITIAL 0
        LABEL "Pagamento final" 
        VIEW-AS FILL-IN 
        SIZE 8 BY .88 NO-UNDO.

    DEFINE VARIABLE c-linha AS CHAR FORMAT "X(20)" INITIAL "MatÇria-prima"
        LABEL "Linha" 
        VIEW-AS FILL-IN 
        SIZE 22 BY .88 NO-UNDO.

    DEFINE VARIABLE c-ncm AS CHAR FORMAT "X(60)"
            LABEL "NCM" 
            VIEW-AS FILL-IN 
            SIZE 63 BY .88 NO-UNDO.

    DEFINE VARIABLE c-comissao AS CHAR FORMAT "X(20)" INITIAL "N∆o h†"
            LABEL "Comiss∆o" 
            VIEW-AS FILL-IN 
            SIZE 22 BY .88 NO-UNDO.

    DEFINE VARIABLE c-ref AS CHAR FORMAT "X(30)"
            LABEL "Ref. Banc†ria" 
            VIEW-AS FILL-IN 
            SIZE 33 BY .88 NO-UNDO.
    /*********************************/


    /*********** Frame **************/
    DEFINE FRAME f-imprimir
           c-i-pag-ini       AT ROW 1.21 COL 12.00 COLON-ALIGNED
           c-i-pag-fim       AT ROW 2.21 COL 12.00 COLON-ALIGNED
           c-linha           AT ROW 3.21 COL 12.00 COLON-ALIGNED
           c-ncm             AT ROW 4.21 COL 12.00 COLON-ALIGNED
           c-comissao        AT ROW 5.21 COL 12.00 COLON-ALIGNED
           c-ref             AT ROW 6.21 COL 12.00 COLON-ALIGNED
           btImprimir        AT ROW 7.63 COL 2.14 
           btGoToOK          AT ROW 7.63 COL 2.14
           btGoToCancel      AT ROW 7.63 COL 13
           rtGoToButton      AT ROW 7.38 COL 1
           SPACE(0.28)
           WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
                THREE-D SCROLLABLE TITLE "Selecionar pagamento" FONT 1
                DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.
    /*********************************/



    /************ Bot∆o Imprimir ***********/
    ON "CHOOSE":U OF btImprimir IN FRAME f-imprimir DO:
       IF c-i-pag-ini:SCREEN-VALUE IN FRAME f-imprimir = "" OR
          c-i-pag-fim:SCREEN-VALUE IN FRAME f-imprimir = "" THEN DO:
          MESSAGE "ê necess†rio preencher o n£mero do pagamento inicial e final"
              VIEW-AS ALERT-BOX INFO BUTTONS OK.
          LEAVE.
       END.
       ASSIGN t-pag-ini     = int(c-i-pag-ini:SCREEN-VALUE IN FRAME f-imprimir) 
              t-pag-fim     = int(c-i-pag-fim:SCREEN-VALUE IN FRAME f-imprimir) 
              t-linha       = c-linha:SCREEN-VALUE IN FRAME f-imprimir 
              t-ncm         = c-ncm:SCREEN-VALUE IN FRAME f-imprimir 
              t-comissao    = c-comissao:SCREEN-VALUE IN FRAME f-imprimir 
              t-RefBancaria = c-ref:SCREEN-VALUE IN FRAME f-imprimir.  

        
        RUN piExecute.

        /*
        DO ON error undo, return no-apply:
           run piExecute2.
        END.
        */

    END.
    /*********************************/



    
    ENABLE c-i-pag-ini c-i-pag-fim c-linha c-ncm c-comissao c-ref ~ 
            btGoToCancel btImprimir WITH FRAME f-imprimir.
    btGoToOK:VISIBLE = FALSE.
    c-linha:SCREEN-VALUE = "MatÇria-prima".
    c-comissao:SCREEN-VALUE = "N∆o h†".


    WAIT-FOR "GO":U OF FRAME f-imprimir.
    
        
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btAdd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAdd wMaintenance
ON CHOOSE OF btAdd IN FRAME fpage0 /* Add */
OR CHOOSE OF MENU-ITEM miAdd in MENU mbMain DO:
    
    RUN addRecord IN THIS-PROCEDURE.

    bt-incluir:SENSITIVE     IN FRAME fpage1 = FALSE.  
    bt-excluir:SENSITIVE     IN FRAME fpage1 = FALSE.  

    ASSIGN ttpagamento.nr-pagamento:SENSITIVE IN FRAME fpage1   = FALSE
           ttpagamento.valor-pag:SENSITIVE  IN FRAME fpage1     = FALSE
           ttpagamento.usuar-receb:SENSITIVE  IN FRAME fpage1     = FALSE
           ttpagamento.data-ci:SCREEN-VALUE IN FRAME fPage1     = string(TODAY)
           ttpagamento.modalidade:SENSITIVE    IN FRAME fPage1  = FALSE
           ttpagamento.modalidade:SCREEN-VALUE  IN FRAME fPage1 =  " "
           ttpagamento.modalidade = " ".

    FOR EACH tt-pagamento-invoice:
        DELETE tt-pagamento-invoice.
    END.
    {&OPEN-QUERY-br-fatura}


    RUN pi-verifica-permis.
    ASSIGN ttpagamento.recebido-ap:SENSITIVE  IN FRAME fpage1 = l-permis-alterar.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wMaintenance
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancel */
OR CHOOSE OF MENU-ITEM miCancel IN MENU mbMain DO:

    /*bt-incluir:SENSITIVE     IN FRAME fpage1 = FALSE.  
    bt-excluir:SENSITIVE     IN FRAME fpage1 = FALSE.  */

    RUN cancelRecord IN THIS-PROCEDURE.
    RUN monta.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage6
&Scoped-define SELF-NAME btConfigImpr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btConfigImpr wMaintenance
ON CHOOSE OF btConfigImpr IN FRAME fpage6
DO:
   {report/rpimp.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btCopy
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCopy wMaintenance
ON CHOOSE OF btCopy IN FRAME fpage0 /* Copy */
OR CHOOSE OF MENU-ITEM miCopy IN MENU mbMain DO:
    RUN copyRecord IN THIS-PROCEDURE.

    RUN pi-verifica-permis.
    ASSIGN ttpagamento.recebido-ap:SENSITIVE  IN FRAME fpage1 = l-permis-alterar.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btDelete
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDelete wMaintenance
ON CHOOSE OF btDelete IN FRAME fpage0 /* Delete */
OR CHOOSE OF MENU-ITEM miDelete IN MENU mbMain DO:

    RUN pi-verifica-permis.

    IF NOT l-permis-alterar AND ttpagamento.recebido-ap THEN DO:
        run utp/ut-msgs.p (input "show":U, input 17006, input "Exclus∆o n∆o permitida.~~CI j† foi recebida no Financeiro. D£vidas entrar em contato com setor Financeiro, caso necessite eliminar CI.":U).
        RETURN NO-APPLY.
    END.

    FOR EACH mgesp.pagamento-invoice 
       WHERE mgesp.pagamento-invoice.nr-pagamento = ttpagamento.nr-pagamento exclusive-lock:
        DELETE mgesp.pagamento-invoice. 
    END.

    RUN deleteRecord IN THIS-PROCEDURE.

    RUN MONTA.
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


&Scoped-define FRAME-NAME fpage6
&Scoped-define SELF-NAME btFile
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFile wMaintenance
ON CHOOSE OF btFile IN FRAME fpage6
DO:
    {report/rparq.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btFirst
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFirst wMaintenance
ON CHOOSE OF btFirst IN FRAME fpage0 /* First */
OR CHOOSE OF MENU-ITEM miFirst IN MENU mbMain DO:
    RUN getFirst IN THIS-PROCEDURE.
    RUN monta.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btGoTo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btGoTo wMaintenance
ON CHOOSE OF btGoTo IN FRAME fpage0 /* Go To */
OR CHOOSE OF MENU-ITEM miGoTo IN MENU mbMain DO:
    RUN goToRecord IN THIS-PROCEDURE.
    RUN monta.
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
    RUN monta.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btNext
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btNext wMaintenance
ON CHOOSE OF btNext IN FRAME fpage0 /* Next */
OR CHOOSE OF MENU-ITEM miNext IN MENU mbMain DO:
    RUN getNext IN THIS-PROCEDURE.
    RUN monta.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btPrev
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btPrev wMaintenance
ON CHOOSE OF btPrev IN FRAME fpage0 /* Prev */
OR CHOOSE OF MENU-ITEM miPrev IN MENU mbMain DO:
    RUN getPrev IN THIS-PROCEDURE.
    RUN monta.
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
    /*bt-incluir:SENSITIVE     IN FRAME fpage1 = FALSE.  
    bt-excluir:SENSITIVE     IN FRAME fpage1 = FALSE.*/

    RUN saveRecord IN THIS-PROCEDURE.
    IF RETURN-VALUE = "OK" THEN DO:
        APPLY "choose" TO btCancel IN FRAME fpage0.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSearch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSearch wMaintenance
ON CHOOSE OF btSearch IN FRAME fpage0 /* Search */
OR CHOOSE OF MENU-ITEM miSearch IN MENU mbMain DO:
    {method/ZoomReposition.i &ProgramZoom="eszoom/z01es138.w"} 
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

    RUN pi-verifica-permis.

    IF NOT l-permis-alterar AND ttpagamento.recebido-ap THEN DO:
        run utp/ut-msgs.p (input "show":U, input 17006, input "Alteraá∆o n∆o permitida..~~CI j† foi recebida no Financeiro. D£vidas entrar em contato com o setor Financeiro.":U).
        RETURN NO-APPLY.
    END.

    RUN updateRecord IN THIS-PROCEDURE.

    ASSIGN ttpagamento.cod-estabel:SENSITIVE    IN FRAME fPage1 = NOT CAN-FIND(FIRST pagamento-invoice NO-LOCK WHERE pagamento-invoice.nr-pagamento = pagamento-invoice.nr-pagamento).

    ASSIGN ttpagamento.nr-pagamento:SENSITIVE     IN FRAME fpage1 = FALSE
           ttpagamento.valor-fechamento:SENSITIVE IN FRAME fpage1 = FALSE
           ttpagamento.valor-pag:SENSITIVE        IN FRAME fpage1 = FALSE  
           ttpagamento.usuar-receb:SENSITIVE      IN FRAME fpage1 = FALSE
           bt-incluir:SENSITIVE                   IN FRAME fpage1 = FALSE  
           bt-excluir:SENSITIVE                   IN FRAME fpage1 = FALSE
           ttpagamento.recebido-ap:SENSITIVE      IN FRAME fpage1 = l-permis-alterar
           ttpagamento.tipo-ci:SENSITIVE          IN FRAME fpage1 = FALSE
           ttpagamento.dat-fft:SENSITIVE          IN FRAME fpage1 = FALSE.

    IF ttpagamento.cod-cond-pag:SCREEN-VALUE IN FRAME fPage1 <> "0" THEN DO:
        ASSIGN ttpagamento.modalidade:SENSITIVE    IN FRAME fPage1 = FALSE
               ttpagamento.modalidade:SCREEN-VALUE IN FRAME fPage1 =  " "
               ttpagamento.modalidade =  " ".
    END.

    /* Esquerda */
    IF ttpagamento.recebido-ap THEN DO:
        DISABLE ALL WITH FRAME fPage1.
    END.

    /* Direita */
    ASSIGN ttpagamento.usuar-receb:SENSITIVE       IN FRAME fpage1 = l-permis-alterar
           ttpagamento.recebido-ap:SENSITIVE       IN FRAME fpage1 = l-permis-alterar
           ttpagamento.valor-contrato-me:SENSITIVE IN FRAME fpage1 = l-permis-alterar
           ttpagamento.tipo-contr-cambio:SENSITIVE IN FRAME fpage1 = l-permis-alterar
           ttpagamento.nr-cont-cambio:SENSITIVE    IN FRAME fpage1 = l-permis-alterar
           ttpagamento.data-emissao:SENSITIVE      IN FRAME fpage1 = l-permis-alterar
           ttpagamento.swift:SENSITIVE             IN FRAME fpage1 = l-permis-alterar
           ttpagamento.data-swift:SENSITIVE        IN FRAME fpage1 = l-permis-alterar
           ttpagamento.instit-cambio:SENSITIVE     IN FRAME fpage1 = l-permis-alterar
           ttpagamento.praca-cambio:SENSITIVE      IN FRAME fpage1 = l-permis-alterar
           ttpagamento.taxa-cambio-pag:SENSITIVE   IN FRAME fpage1 = l-permis-alterar
           ttpagamento.valor-contrato:SENSITIVE    IN FRAME fpage1 = l-permis-alterar
           ttpagamento.valor-ord-pag:SENSITIVE     IN FRAME fpage1 = l-permis-alterar
           ttpagamento.cod-moeda-1:SENSITIVE       IN FRAME fpage1 = l-permis-alterar
           ttpagamento.taxa-cambio:SENSITIVE       IN FRAME fpage1 = l-permis-alterar
           ttpagamento.valor-fechamento:SENSITIVE  IN FRAME fpage1 = l-permis-alterar
           ttpagamento.dt-fecha-cam:SENSITIVE      IN FRAME fpage1 = l-permis-alterar.

    APPLY 'value-changed':U TO ttpagamento.tipo-ci IN FRAME fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME ttpagamento.centro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttpagamento.centro wMaintenance
ON LEAVE OF ttpagamento.centro IN FRAME fPage1 /* C.Custo */
DO:
    IF  trim(INPUT FRAME {&FRAME-NAME} ttpagamento.centro) <> "" 
    THEN DO:
        run prgint\utb\utb742za.py persistent set h_api_ccusto.
    
        FIND FIRST estabelec NO-LOCK
              WHERE estabelec.cod-estabel = v_cod_estab_usuar NO-ERROR.
    
        EMPTY TEMP-TABLE tt_log_erro.
        run pi_busca_dados_ccusto in h_api_ccusto (input  estabelec.ep-codigo,                          /* EMPRESA EMS2 */
                                                   input  "",                                           /* CODIGO DO PLANO CCUSTO */
                                                   input  INPUT FRAME {&FRAME-NAME} ttpagamento.centro, /* CCUSTO */
                                                   input  today,                                        /* DATA DE TRANSACAO */
                                                   output v_titulo_ccusto,                              /* DESCRICAO DO CCUSTO */
                                                   output table tt_log_erro).                           /* ERROS */

        ASSIGN c-nome-centro = v_titulo_ccusto.

        if valid-handle(h_api_ccusto) 
        then
            delete object h_api_ccusto.
        
    END. /* IF  trim(INPUT FRAME {&FRAME-NAME} ttpagamento.centro) <> "" */
    ELSE
        ASSIGN c-nome-centro = "".

    DISPLAY c-nome-centro WITH FRAME {&FRAME-NAME}.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttpagamento.cod-banco
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttpagamento.cod-banco wMaintenance
ON LEAVE OF ttpagamento.cod-banco IN FRAME fPage1 /* Banco */
DO:
  
    FIND mgcad.banco NO-LOCK WHERE 
         mgcad.banco.cod-banco = INPUT FRAME {&FRAME-NAME} {&SELF-NAME} NO-ERROR.
    ASSIGN c-nome-banco = IF AVAILABLE mgcad.banco THEN mgcad.banco.nome-banco ELSE ''.
    DISPLAY c-nome-banco WITH FRAME {&FRAME-NAME}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttpagamento.cod-cond-pag
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttpagamento.cod-cond-pag wMaintenance
ON F5 OF ttpagamento.cod-cond-pag IN FRAME fPage1 /* Cond.Pagto */
DO:
    /*--- Zoom Smart Object ---*/
    {include/zoomvar.i &prog-zoom=adzoom/z01ad039.w
                        &campo=ttpagamento.cod-cond-pag
                        &campozoom=cod-cond-pag
                        &frame=fPage1
                        &campo2=c-desc-cond-pagto
                        &campozoom2=descricao
                        &frame2=fPage1} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttpagamento.cod-cond-pag wMaintenance
ON LEAVE OF ttpagamento.cod-cond-pag IN FRAME fPage1 /* Cond.Pagto */
DO:
    FIND FIRST cond-pagto NO-LOCK 
         WHERE cond-pagto.cod-cond-pag = INPUT FRAME fPage1 ttpagamento.cod-cond-pag no-error.
    
    ASSIGN c-desc-cond-pagto:SCREEN-VALUE IN FRAME fPage1  = IF AVAILABLE cond-pagto THEN cond-pagto.descricao ELSE ''.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttpagamento.cod-cond-pag wMaintenance
ON MOUSE-SELECT-DBLCLICK OF ttpagamento.cod-cond-pag IN FRAME fPage1 /* Cond.Pagto */
DO:
    APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttpagamento.cod-emitente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttpagamento.cod-emitente wMaintenance
ON LEAVE OF ttpagamento.cod-emitente IN FRAME fPage1 /* Emitente */
DO:

    FIND emitente NO-LOCK WHERE 
         emitente.cod-emitente = INPUT FRAME {&FRAME-NAME} {&SELF-NAME} NO-ERROR.
    ASSIGN c-nome-abrev = IF AVAILABLE emitente THEN emitente.nome-abrev ELSE ''.
    DISPLAY c-nome-abrev WITH FRAME {&FRAME-NAME}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttpagamento.cod-moeda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttpagamento.cod-moeda wMaintenance
ON F5 OF ttpagamento.cod-moeda IN FRAME fPage1 /* Moeda */
DO:
    assign l-implanta = FALSE.
    {include/zoomvar.i &prog-zoom=adzoom/z01ad178.w
                       &campo=ttpagamento.cod-moeda
                       &campozoom=mo-codigo}       
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttpagamento.cod-moeda wMaintenance
ON LEAVE OF ttpagamento.cod-moeda IN FRAME fPage1 /* Moeda */
DO:
    FIND FIRST moeda NO-LOCK 
        WHERE  moeda.mo-codigo = INPUT FRAME {&FRAME-NAME} {&SELF-NAME} NO-ERROR.
    
    ASSIGN c-nome-moeda = IF AVAILABLE moeda THEN moeda.descricao ELSE "":U.
    
    DISPLAY c-nome-moeda WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttpagamento.cod-moeda wMaintenance
ON MOUSE-SELECT-DBLCLICK OF ttpagamento.cod-moeda IN FRAME fPage1 /* Moeda */
DO:
    APPLY "F5":U TO SELF.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttpagamento.nr-pagamento
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttpagamento.nr-pagamento wMaintenance
ON GO OF ttpagamento.nr-pagamento IN FRAME fPage1 /* Nr. */
DO:
  RUN monta.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage6
&Scoped-define SELF-NAME rsDestiny
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rsDestiny wMaintenance
ON VALUE-CHANGED OF rsDestiny IN FRAME fpage6
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
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rsExecution wMaintenance
ON VALUE-CHANGED OF rsExecution IN FRAME fpage6
DO:
   {report/rprse.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME ttpagamento.taxa-cambio
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttpagamento.taxa-cambio wMaintenance
ON LEAVE OF ttpagamento.taxa-cambio IN FRAME fPage1 /* Taxa Cambio */
DO:
    tot = DEC(ttpagamento.valor-contrato-me:SCREEN-VALUE) * DEC(ttpagamento.taxa-cambio:SCREEN-VALUE).
    ttpagamento.valor-fechamento:SCREEN-VALUE = STRING(tot). 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttpagamento.tipo-ci
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttpagamento.tipo-ci wMaintenance
ON VALUE-CHANGED OF ttpagamento.tipo-ci IN FRAME fPage1
DO:
    IF  ttpagamento.recebido-ap                          = NO  AND 
        ttpagamento.tipo-ci:SCREEN-VALUE IN FRAME fPage1 = '2' THEN
        ASSIGN ttpagamento.valor-pag:SENSITIVE IN FRAME fPage1 = YES.
    ELSE
        ASSIGN ttpagamento.valor-pag:SENSITIVE IN FRAME fPage1 = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttpagamento.Tipo-despesa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttpagamento.Tipo-despesa wMaintenance
ON LEAVE OF ttpagamento.Tipo-despesa IN FRAME fPage1 /* Tp Desp */
DO:
    FIND tipo-rec-desp NO-LOCK WHERE 
         tipo-rec-desp.tp-codigo = INPUT FRAME {&FRAME-NAME} {&SELF-NAME} NO-ERROR.
    ASSIGN c-nome-despesa = IF AVAILABLE tipo-rec-desp THEN tipo-rec-desp.descricao ELSE ''.
    DISPLAY c-nome-despesa WITH FRAME {&FRAME-NAME}.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttpagamento.valor-contrato-me
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttpagamento.valor-contrato-me wMaintenance
ON LEAVE OF ttpagamento.valor-contrato-me IN FRAME fPage1 /* Valor Contrato ME */
DO:
    tot = DEC(ttpagamento.valor-contrato-me:SCREEN-VALUE) * DEC(ttpagamento.taxa-cambio:SCREEN-VALUE).
    ttpagamento.valor-fechamento:SCREEN-VALUE = STRING(tot).   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-contrato
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenance 


/*:T--- L¢gica para inicializaá∆o do programam ---*/

PROCEDURE WinExec  EXTERNAL  "kernel32.dll":
  DEF INPUT PARAM prg_name      AS CHARACTER.
  DEF INPUT PARAM prg_style     AS SHORT.
END PROCEDURE.

ttpagamento.cod-moeda:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fpage1.

{maintenance/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wMaintenance 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN ttpagamento.usuario:SCREEN-VALUE IN FRAME fPage1 = ttpagamento.usuario.

    IF ttpagamento.cod-unid-neg = "" THEN
        ASSIGN ttpagamento.cod-unid-neg:SCREEN-VALUE IN FRAME fPage1 = " ".

    IF ttpagamento.modalidade = "" THEN
        ASSIGN ttpagamento.modalidade:SCREEN-VALUE IN FRAME fPage1 = " ".

    IF ttpagamento.tipo-ci = 0 THEN
        ASSIGN ttpagamento.tipo-ci:SCREEN-VALUE IN FRAME fPage1 = "1".    

    APPLY 'leave':U TO {&ttTable}.cod-emitente  IN FRAME fPage1.    
    APPLY 'leave':U TO {&ttTable}.centro        IN FRAME fPage1.
    APPLY 'leave':U TO {&ttTable}.tipo-despesa  IN FRAME fPage1.
    APPLY 'leave':U TO {&ttTable}.cod-banco     IN FRAME fPage1.
    APPLY 'leave':U TO {&ttTable}.cod-moeda     IN FRAME fPage1.
    APPLY 'leave':U TO {&ttTable}.cod-cond-pag  IN FRAME fPage1.

    ENABLE bt-incluir bt-excluir WITH FRAME fPage1.

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

    ttpagamento.cod-cond-pag:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fpage1.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeInitializeInterface wMaintenance 
PROCEDURE beforeInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    RUN pi-carrega-unidades.
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
    
    DEFINE VARIABLE c-nr-pagamento LIKE {&ttTable}.nr-pagamento NO-UNDO.
    
    DEFINE FRAME fGoToRecord
        c-nr-pagamento    AT ROW 1.21 COL 17.72 COLON-ALIGNED
        btGoToOK          AT ROW 2.63 COL 2.14
        btGoToCancel      AT ROW 2.63 COL 13
        rtGoToButton      AT ROW 2.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V† Para Cadastro Pagamento" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.
    

    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN c-nr-pagamento.

        RUN goToKey IN {&hDBOTable} (INPUT c-nr-pagamento).
        IF RETURN-VALUE = "NOK":U THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT "Cadastro Pagamento":U).            
            RETURN NO-APPLY.
        END.
        
        /*:T Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOTable} (OUTPUT rGoTo).
        
        /*:T Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).

        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    ENABLE c-nr-pagamento btGoToOK btGoToCancel 
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
       {&hDBOTable}:FILE-NAME <> "boes138.p":U THEN DO:
        {btb/btb008za.i1 esbo\boes138.p YES}
        {btb/btb008za.i2 esbo\boes138.p '' {&hDBOTable}}
    END.

    /*RUN setConstraintmain IN {&hDBOTable} NO-ERROR.   */
        
    RUN openQueryStatic IN {&hDBOTable} (INPUT "Portal":U) NO-ERROR.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE monta wMaintenance 
PROCEDURE monta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF ttpagamento.cod-estabel:SCREEN-VALUE IN FRAME fPage1 <> "" THEN
        ASSIGN c-cod-estab = ttpagamento.cod-estabel.
    ELSE 
        ASSIGN c-cod-estab = v_cod_estab_usuar.

    FOR EACH tt-pagamento-invoice:
        DELETE tt-pagamento-invoice.
    END.
    {&OPEN-QUERY-br-fatura}
    
    FOR EACH mgesp.pagamento-invoice 
       WHERE mgesp.pagamento-invoice.nr-pagamento = ttpagamento.nr-pagamento no-lock:
        FOR EACH invoice-emb-imp 
           WHERE invoice-emb-imp.cod-estabel = c-cod-estab
             AND invoice-emb-imp.embarque    = mgesp.pagamento-invoice.embarque 
             AND invoice-emb-imp.nr-invoice  = mgesp.pagamento-invoice.nr-invoice 
             and invoice-emb-imp.parcela     = mgesp.pagamento-invoice.parcela no-lock:
            CREATE tt-pagamento-invoice.
            ASSIGN tt-pagamento-invoice.nr-pagamento = ttpagamento.nr-pagamento
                   tt-pagamento-invoice.embarque     = mgesp.pagamento-invoice.embarque
                   tt-pagamento-invoice.nr-invoice   = mgesp.pagamento-invoice.nr-invoice
                   tt-pagamento-invoice.parcela      = mgesp.pagamento-invoice.parcela
                   tt-pagamento-invoice.valor        = mgesp.pagamento-invoice.valor
                   tt-pagamento-invoice.dt-vencimento = invoice-emb-imp.dt-vencim.

            FOR FIRST embarque-imp NO-LOCK
                WHERE embarque-imp.cod-estabel = c-cod-estab                      
                  AND embarque-imp.embarque    = mgesp.pagamento-invoice.embarque,
                FIRST ordens-embarque OF embarque-imp NO-LOCK,
                FIRST ordem-compra OF ordens-embarque NO-LOCK:
                 
                ASSIGN tt-pagamento-invoice.cond-pagto = STRING(ordem-compra.cod-cond-pag).
            END.
        END.
    END.

    {&OPEN-QUERY-br-fatura}

   

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-unidades wMaintenance 
PROCEDURE pi-carrega-unidades :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-desc AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE h-esapi015 AS HANDLE      NO-UNDO.

    FOR EACH tt-unid-negoc:
        DELETE tt-unid-negoc.
    END.
    
    RUN esapi/esapi015.p PERSISTENT SET h-esapi015.
    RUN pi-retorna-unidade IN h-esapi015 (OUTPUT TABLE tt-unid-negoc).
    DELETE PROCEDURE h-esapi015.

    ASSIGN ttpagamento.cod-unid-neg:LIST-ITEM-PAIRS IN FRAME fPage1 = ",".

    FOR EACH tt-unid-negoc BY tt-unid-negoc.cod-unid-negoc:
        ASSIGN c-desc = tt-unid-negoc.cod-unid-negoc + "-" + tt-unid-negoc.descricao.

        ttpagamento.cod-unid-neg:add-last(c-desc, tt-unid-negoc.cod-unid-negoc) IN FRAME fPage1 NO-ERROR.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-verifica-permis wMaintenance 
PROCEDURE pi-verifica-permis :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Seleciona usuario com autorizaá∆o de alteraá∆o de periodo congelado */
    RUN esp\es0018p.p (INPUT "esimp003",
                       INPUT 1,
                       INPUT 0,
                       INPUT "",
                       OUTPUT TABLE tt-prog-ponto) NO-ERROR.
/* Fim seleá∆o usu†rio */

    ASSIGN l-permis-alterar = CAN-FIND(FIRST tt-prog-ponto NO-LOCK WHERE tt-prog-ponto.conteudo = c-seg-usuario).
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piExecute wMaintenance 
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
                    
    CREATE tt-param.
    ASSIGN tt-param.usuario         = c-seg-usuario
           tt-param.destino         = INPUT frame fPage6 rsDestiny
           tt-param.data-exec       = TODAY
           tt-param.hora-exec       = TIME.

    DO WITH FRAME f-imprimir: 
       ASSIGN tt-param.pag-ini      = t-pag-ini
              tt-param.pag-fim      = t-pag-fim
              tt-param.linha        = t-linha
              tt-param.ncm          = t-ncm
              tt-param.comissao     = t-comissao
              tt-param.RefBancaria  = t-RefBancaria.
    END.                                                                               
    
    IF tt-param.destino = 1 then 
       ASSIGN tt-param.arquivo = "":U.
    ELSE 
       IF tt-param.destino = 2 THEN
          ASSIGN tt-param.arquivo = input frame fPage6 cFile.
       ELSE
          ASSIGN tt-param.arquivo = session:temp-directory + c-programa-mg97 + ".tmp":U.

    /*:T Executar do programa RP.P que ir† criar o relat¢rio */
    {report/rpexb.i}
    
    SESSION:SET-WAIT-STATE("GENERAL":U).

    {report/rprun.i esp/imp/esimp003rp.p}

    {report/rpexc.i}

    SESSION:SET-WAIT-STATE("":U).

    {report/rptrm.i}
END.
&ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piExecute2 wMaintenance 
PROCEDURE piExecute2 :
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
    
    /*:T Coloque aqui as validaá‰es da p†gina de Digitaá∆o, lembrando que elas devem
       apresentar uma mensagem de erro cadastrada, posicionar nesta p†gina e colocar
       o focus no campo com problemas */
    /*browse brDigita:SET-REPOSITIONED-ROW (browse brDigita:DOWN, "ALWAYS":U).*/
    
    for each tt-digita no-lock:
        assign r-tt-digita = rowid(tt-digita).
        
        /*:T Validaá∆o de duplicidade de registro na temp-table tt-digita */
        find first b-tt-digita 
             where b-tt-digita.ordem = tt-digita.ordem 
               and rowid(b-tt-digita) <> rowid(tt-digita) no-lock no-error.
        if  avail b-tt-digita then do:
            /* reposition brDigita to rowid rowid(b-tt-digita). */
            
            run utp/ut-msgs.p (input "SHOW":U, input 108, input "":U).
            /*  apply "ENTRY":U to tt-digita.ordem in browse brDigita. */
            
            return error.
        end.
        
        /*:T As demais validaá‰es devem ser feitas aqui */
        if  tt-digita.ordem <= 0 then do:
            /* assign browse brDigita:CURRENT-COLUMN = tt-digita.ordem:HANDLE in browse brDigita. */
            
            /* reposition brDigita to rowid r-tt-digita. */
           
            run utp/ut-msgs.p (input "SHOW":U, input 99999, input "":U).
            /* apply "ENTRY":U to tt-digita.ordem in browse brDigita. */
            
            return error.
        end.        
    end.    
    
    /*:T Coloque aqui as validaá‰es das outras p†ginas, lembrando que elas devem 
       apresentar uma mensagem de erro cadastrada, posicionar na p†gina com 
       problemas e colocar o focus no campo com problemas */    
    
    /*:T Aqui s∆o gravados os campos da temp-table que ser† passada como parÉmetro
       para o programa RP.P */
    
    CREATE tt-param.
    ASSIGN tt-param.usuario         = c-seg-usuario
           tt-param.destino         = INPUT frame fPage6 rsDestiny
           tt-param.data-exec       = TODAY
           tt-param.hora-exec       = TIME.

    DO WITH FRAME f-imprimir: 
       ASSIGN tt-param.pag-ini      = t-pag-ini
              tt-param.pag-fim      = t-pag-fim
              tt-param.linha        = t-linha
              tt-param.ncm          = t-ncm
              tt-param.comissao     = t-comissao
              tt-param.RefBancaria  = t-RefBancaria.
    END.
    
    if tt-param.destino = 1 then 
        assign tt-param.arquivo = "":U.
    else if  tt-param.destino = 2 then 
        assign tt-param.arquivo = input frame fPage6 cFile.
    else assign tt-param.arquivo = session:temp-directory + c-programa-mg97 + ".tmp":U.
    
    /*:T Coloque aqui a l¢gica de gravaá∆o dos demais campos que devem ser passados
       como parÉmetros para o programa RP.P, atravÇs da temp-table tt-param */    
    
    /*:T Executar do programa RP.P que ir† criar o relat¢rio */
    {report/rpexb.i}
    
    SESSION:SET-WAIT-STATE("GENERAL":U).
    
    {report/rprun.i esp/imp/esimp003rp.p}
    
    {report/rpexc.i}
    
    SESSION:SET-WAIT-STATE("":U).
    
    {report/rptrm.i}
end.

&ELSE
/*:T** Importacao/Exportacao ***/
do  on error undo, return error
    on stop  undo, return error:     

    {report/rpexa.i}

    if  input frame fPage7 rsDestiny = 2 and
        input frame fPage7 rsExecution = 1 then do:
        run utp/ut-vlarq.p (input input frame fPage7 cDestinyFile).
        if  return-value = "NOK":U then do:
            run utp/ut-msgs.p (input "SHOW":U,
                               input 73,
                               input "":U).
            apply "ENTRY":U to cDestinyFile in frame fPage7.                   
            return error.
        end.
    end.
    
    assign file-info:file-name = input frame fPage4 cInputFile.
    if  file-info:pathname = ? and
        input frame fPage7 rsExecution = 1 then do:
        run utp/ut-msgs.p (input "SHOW":U,
                           input 326,
                           input cInputFile).                               
        apply "ENTRY":U to cInputFile in frame fPage4.                
        return error.
    end. 
            
    /*:T Coloque aqui as validaá‰es das outras p†ginas, lembrando que elas
       devem apresentar uma mensagem de erro cadastrada, posicionar na p†gina 
       com problemas e colocar o focus no campo com problemas             */    
         
    create tt-param.
    assign tt-param.usuario         = c-seg-usuario
           tt-param.destino         = input frame fPage7 rsDestiny
           tt-param.todos           = input frame fPage7 rsAll
           tt-param.arq-entrada     = input frame fPage4 cInputFile
           tt-param.data-exec       = today
           tt-param.hora-exec       = time.

    if  tt-param.destino = 1 then
        assign tt-param.arq-destino = "":U.
    else
    if  tt-param.destino = 2 THEN
        assign tt-param.arq-destino = input frame fPage7 cDestinyFile.
    else
        assign tt-param.arq-destino = session:temp-directory + c-programa-mg97 + ".tmp":U.

    /*:T Coloque aqui a l¢gica de gravaá∆o dos parÉmtros e seleá∆o na temp-table
       tt-param */ 

    {report/imexb.i}

    if  session:set-wait-state("GENERAL":U) then.

    {report/imrun.i xxp/xx9999rp.p}

    {report/imexc.i}

    if  session:set-wait-state("":U) then.
    
    {report/imtrm.i tt-param.arq-destino tt-param.destino}
    
end.
&ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

