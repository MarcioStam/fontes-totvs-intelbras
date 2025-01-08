&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wReport
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wReport 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i esrep007 2.04.00.001}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        esrep007
&GLOBAL-DEFINE Version        2.04.00.001
  

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Sele‡Æo,Parƒmetros,Digita‡Æo,ImpressÆo

&GLOBAL-DEFINE PGLAY          NO
&GLOBAL-DEFINE PGSEL          YES
&GLOBAL-DEFINE PGCLA          NO
&GLOBAL-DEFINE PGPAR          YES
&GLOBAL-DEFINE PGDIG          YES
&GLOBAL-DEFINE PGIMP          YES
&GLOBAL-DEFINE PGLOG          NO

&GLOBAL-DEFINE RTF            NO

&GLOBAL-DEFINE page0Widgets   btOk btCancel btHelp2
  
&GLOBAL-DEFINE page2Widgets   fi-fim-cod-emitente fi-fim-data~
                              fi-fim-nat-operacao fi-fim-uf fi-ini-cod-emitente~
                              fi-ini-data fi-ini-nat-operacao fi-ini-uf~
                              c-est-ini c-est-fim c-depos-ini c-depos-fim fi-it-codigo-ini fi-it-codigo-fim ~
                              fi-conta-ini fi-conta-fim fi-subconta-ini fi-subconta-fim fi-usuario-ini fi-usuario-fim ~
                              fl-class-fiscal-ini fl-class-fiscal-fim fi-cod-msg-devolucao-ini fi-cod-msg-devolucao-fim


&GLOBAL-DEFINE page4Widgets   rs-tipo-relatorio rs-natureza tb-imprime-devol tb-imprime-conta tb-imprime-financeiro tg-imp-rateio tg-filtra-imposto tg-nf-atualizada tg-bc-aliq tg-listar-THC-II tg-listar-chave-acesso
&GLOBAL-DEFINE page5Widgets   brDigita br-impostos bt-todos bt-nenhum btAdd btUpdate btDelete btsave btopen brDigita-emit btAdd-2 btUpdate-2 btDelete-2 btsave-2 btopen-2
&GLOBAL-DEFINE page6Widgets   rsDestiny btConfigImpr btFile rsExecution 
&GLOBAL-DEFINE page0Text      
&GLOBAL-DEFINE page2Text      
&GLOBAL-DEFINE page4Text      
&GLOBAL-DEFINE page5Text      
&GLOBAL-DEFINE page6Text      text-destino text-modo 
 

&GLOBAL-DEFINE page1Fields    
&GLOBAL-DEFINE page2Fields    {&page2Widgets}
&GLOBAL-DEFINE page4Fields    {&page4Widgets}    
&GLOBAL-DEFINE page5Fields    {&page5Widgets}    
&GLOBAL-DEFINE page6Fields    cFile 

{esp/rep/esrep007tt.i}  
{upc\btb910za-upc.i}

/* Parameters Definitions ---                                           */



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
DEF VAR tipo-rel AS INT INIT 1 NO-UNDO.
DEF VAR i-natureza AS INT INIT 3 NO-UNDO.

def stream s-imp.

/*15/02/2005 - tech1007 - Variavel definida para tratar se o programa est  rodando no WebEnabler*/
DEFINE SHARED VARIABLE hWenController AS HANDLE NO-UNDO.

/* handle do programa de procedures */
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.

DEF TEMP-TABLE tt-impostos NO-UNDO
    FIELD cod-listar        AS CHAR
    FIELD cod-pais          AS CHAR
    FIELD cod-unid-federac  AS CHAR
    FIELD cod-imposto       AS CHAR
    FIELD des-imposto       AS CHAR
    FIELD cod-classif-impto AS CHAR
    FIELD des-classif-impto AS CHAR
    INDEX id-imposto
            des-imposto      
            des-classif-impto
    INDEX id-litar
            cod-listar.

DEF TEMP-TABLE tt-emit LIKE tt-digita
    FIELD nome-emit LIKE emitente.nome-emit.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-impostos

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-impostos tt-digita tt-emit

/* Definitions for BROWSE br-impostos                                   */
&Scoped-define FIELDS-IN-QUERY-br-impostos tt-impostos.cod-listar tt-impostos.cod-pais tt-impostos.cod-unid-federac tt-impostos.cod-imposto tt-impostos.des-imposto tt-impostos.cod-classif-impto tt-impostos.des-classif-impto   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-impostos   
&Scoped-define SELF-NAME br-impostos
&Scoped-define QUERY-STRING-br-impostos FOR EACH tt-impostos
&Scoped-define OPEN-QUERY-br-impostos OPEN QUERY {&SELF-NAME} FOR EACH tt-impostos.
&Scoped-define TABLES-IN-QUERY-br-impostos tt-impostos
&Scoped-define FIRST-TABLE-IN-QUERY-br-impostos tt-impostos


/* Definitions for BROWSE brDigita                                      */
&Scoped-define FIELDS-IN-QUERY-brDigita tt-digita.nat-operacao   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brDigita tt-digita.nat-operacao   
&Scoped-define ENABLED-TABLES-IN-QUERY-brDigita tt-digita
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-brDigita tt-digita
&Scoped-define SELF-NAME brDigita
&Scoped-define QUERY-STRING-brDigita FOR EACH tt-digita
&Scoped-define OPEN-QUERY-brDigita OPEN QUERY brDigita FOR EACH tt-digita.
&Scoped-define TABLES-IN-QUERY-brDigita tt-digita
&Scoped-define FIRST-TABLE-IN-QUERY-brDigita tt-digita


/* Definitions for BROWSE brDigita-emit                                 */
&Scoped-define FIELDS-IN-QUERY-brDigita-emit tt-emit.cod-emitente tt-emit.nome-emit   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brDigita-emit tt-emit.cod-emitente   
&Scoped-define ENABLED-TABLES-IN-QUERY-brDigita-emit tt-emit
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-brDigita-emit tt-emit
&Scoped-define SELF-NAME brDigita-emit
&Scoped-define QUERY-STRING-brDigita-emit FOR EACH tt-emit
&Scoped-define OPEN-QUERY-brDigita-emit OPEN QUERY brDigita-emit FOR EACH tt-emit.
&Scoped-define TABLES-IN-QUERY-brDigita-emit tt-emit
&Scoped-define FIRST-TABLE-IN-QUERY-brDigita-emit tt-emit


/* Definitions for FRAME fPage5                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage5 ~
    ~{&OPEN-QUERY-br-impostos}~
    ~{&OPEN-QUERY-brDigita}~
    ~{&OPEN-QUERY-brDigita-emit}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar btOK btCancel btHelp2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wReport AS WIDGET-HANDLE NO-UNDO.

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

DEFINE VARIABLE c-depos-fim AS CHARACTER FORMAT "X(3)":U INITIAL "ZZZ" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE c-depos-ini AS CHARACTER FORMAT "X(3)":U 
     LABEL "Deposito" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE c-est-fim AS CHARACTER FORMAT "X(3)":U INITIAL "ZZZ" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE c-est-ini AS CHARACTER FORMAT "X(3)":U 
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fi-cod-msg-devolucao-fim AS INTEGER FORMAT ">>9":U INITIAL 999 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-msg-devolucao-ini AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "Motivo Devolu‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE fi-conta-fim AS CHARACTER FORMAT "x(9)":U INITIAL "999999999" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE fi-conta-ini AS CHARACTER FORMAT "x(9)":U 
     LABEL "Conta" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE fi-fim-cod-emitente AS INTEGER FORMAT ">>>>>>>>9" INITIAL 999999 
     VIEW-AS FILL-IN 
     SIZE 11.43 BY .88 NO-UNDO.

DEFINE VARIABLE fi-fim-data AS DATE FORMAT "99/99/9999" INITIAL 12/31/9999 
     VIEW-AS FILL-IN 
     SIZE 12.57 BY .88 NO-UNDO.

DEFINE VARIABLE fi-fim-nat-operacao AS CHARACTER FORMAT "x(06)" INITIAL "399999" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE fi-fim-uf AS CHARACTER FORMAT "x(02)" INITIAL "ZZ" 
     VIEW-AS FILL-IN 
     SIZE 5.72 BY .88 NO-UNDO.

DEFINE VARIABLE fi-ini-cod-emitente AS INTEGER FORMAT ">>>>>>>>9" INITIAL 0 
     LABEL "Fornecedor" 
     VIEW-AS FILL-IN 
     SIZE 11.43 BY .88 NO-UNDO.

DEFINE VARIABLE fi-ini-data AS DATE FORMAT "99/99/9999" INITIAL 01/01/1900 
     LABEL "Data" 
     VIEW-AS FILL-IN 
     SIZE 12.57 BY .88 NO-UNDO.

DEFINE VARIABLE fi-ini-nat-operacao AS CHARACTER FORMAT "x(06)" INITIAL "100000" 
     LABEL "Natureza":R15 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE fi-ini-uf AS CHARACTER FORMAT "x(02)" 
     LABEL "Unid Federa‡Æo":R17 
     VIEW-AS FILL-IN 
     SIZE 5.72 BY .88 NO-UNDO.

DEFINE VARIABLE fi-it-codigo-fim AS CHARACTER FORMAT "X(16)":U INITIAL "ZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE fi-it-codigo-ini AS CHARACTER FORMAT "X(16)":U 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE fi-subconta-fim AS CHARACTER FORMAT "x(5)":U INITIAL "99999" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE fi-subconta-ini AS CHARACTER FORMAT "x(5)":U 
     LABEL "Sub-Conta" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE fi-usuario-fim AS CHARACTER FORMAT "X(10)":U INITIAL "ZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE fi-usuario-ini AS CHARACTER FORMAT "X(10)":U 
     LABEL "Usu rio" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE fl-class-fiscal-fim AS CHARACTER FORMAT "X(25)":U INITIAL "ZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE fl-class-fiscal-ini AS CHARACTER FORMAT "X(25)":U 
     LABEL "Classifica‡Æo fiscal" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-10
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-11
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-12
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-13
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-14
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-15
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-16
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-2
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-21
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-22
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-23
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-24
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-25
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-26
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-27
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-28
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-29
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-3
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-30
     FILENAME "image\im-las":U
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

DEFINE IMAGE IMAGE-9
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE VARIABLE rs-natureza AS INTEGER INITIAL 3 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "F¡sica", 1,
"Jur¡dica", 2,
"Ambos", 3
     SIZE 39 BY 2 NO-UNDO.

DEFINE VARIABLE rs-tipo-relatorio AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Sint‚tico", 1,
"Anal¡tico", 2
     SIZE 39 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 82 BY 2.5.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 82 BY 1.5.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 82 BY 5.71.

DEFINE VARIABLE tb-imprime-conta AS LOGICAL INITIAL no 
     LABEL "Imprime Conta/Sub-conta e utiliza faixa de contas/sub-contas na sele‡Æo?" 
     VIEW-AS TOGGLE-BOX
     SIZE 53 BY .83 NO-UNDO.

DEFINE VARIABLE tb-imprime-devol AS LOGICAL INITIAL yes 
     LABEL "Imprime Notas Devolu‡Æo" 
     VIEW-AS TOGGLE-BOX
     SIZE 29 BY .83 NO-UNDO.

DEFINE VARIABLE tb-imprime-financeiro AS LOGICAL INITIAL no 
     LABEL "Imprime Financeiro" 
     VIEW-AS TOGGLE-BOX
     SIZE 17 BY .83 NO-UNDO.

DEFINE VARIABLE tg-bc-aliq AS LOGICAL INITIAL no 
     LABEL "Base de C lculo e Al¡quota PIS e COF?" 
     VIEW-AS TOGGLE-BOX
     SIZE 30 BY .83 NO-UNDO.

DEFINE VARIABLE tg-filtra-imposto AS LOGICAL INITIAL no 
     LABEL "Filtrar Fornecedor por Imposto" 
     VIEW-AS TOGGLE-BOX
     SIZE 29 BY .83 NO-UNDO.

DEFINE VARIABLE tg-imp-rateio AS LOGICAL INITIAL no 
     LABEL "Rateio e Despesas Acess¢rias" 
     VIEW-AS TOGGLE-BOX
     SIZE 28 BY .83 NO-UNDO.

DEFINE VARIABLE tg-listar-chave-acesso AS LOGICAL INITIAL no 
     LABEL "Listar Chave de Acesso?" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .83 NO-UNDO.

DEFINE VARIABLE tg-listar-THC-II AS LOGICAL INITIAL no 
     LABEL "&Listar THC e % II ?" 
     VIEW-AS TOGGLE-BOX
     SIZE 16 BY .83 NO-UNDO.

DEFINE VARIABLE tg-nf-atualizada AS LOGICAL INITIAL yes 
     LABEL "Apenas Notas Atualizadas" 
     VIEW-AS TOGGLE-BOX
     SIZE 26 BY .83 NO-UNDO.

DEFINE BUTTON bt-nenhum 
     LABEL "Nenhum" 
     SIZE 15 BY .83 TOOLTIP "Desmarcar todos"
     FONT 1.

DEFINE BUTTON bt-todos 
     LABEL "Todos" 
     SIZE 15 BY .83 TOOLTIP "Marcar todos"
     FONT 1.

DEFINE BUTTON btAdd 
     LABEL "Inserir" 
     SIZE 10 BY 1
     FONT 1.

DEFINE BUTTON btAdd-2 
     LABEL "Inserir" 
     SIZE 10 BY 1
     FONT 1.

DEFINE BUTTON btDelete 
     LABEL "Retirar" 
     SIZE 10 BY 1
     FONT 1.

DEFINE BUTTON btDelete-2 
     LABEL "Retirar" 
     SIZE 10 BY 1
     FONT 1.

DEFINE BUTTON btOpen 
     LABEL "Recuperar" 
     SIZE 10 BY 1
     FONT 1.

DEFINE BUTTON btOpen-2 
     LABEL "Recuperar" 
     SIZE 10 BY 1
     FONT 1.

DEFINE BUTTON btSave 
     LABEL "Salvar" 
     SIZE 10 BY 1
     FONT 1.

DEFINE BUTTON btSave-2 
     LABEL "Salvar" 
     SIZE 10 BY 1
     FONT 1.

DEFINE BUTTON btUpdate 
     LABEL "Alterar" 
     SIZE 10 BY 1
     FONT 1.

DEFINE BUTTON btUpdate-2 
     LABEL "Alterar" 
     SIZE 10 BY 1
     FONT 1.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 32 BY 12.75.

DEFINE RECTANGLE RECT-14
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 52 BY 6.

DEFINE RECTANGLE RECT-164
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 52.14 BY 6.5.

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

DEFINE VARIABLE text-modo AS CHARACTER FORMAT "X(256)":U INITIAL "Execu‡Æo" 
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
DEFINE QUERY br-impostos FOR 
      tt-impostos SCROLLING.

DEFINE QUERY brDigita FOR 
      tt-digita SCROLLING.

DEFINE QUERY brDigita-emit FOR 
      tt-emit SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-impostos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-impostos wReport _FREEFORM
  QUERY br-impostos DISPLAY
      tt-impostos.cod-listar        COLUMN-LABEL "Ver"       FORMAT "x(01)"
tt-impostos.cod-pais          COLUMN-LABEL "Pais"      FORMAT "x(04)"      
tt-impostos.cod-unid-federac  COLUMN-LABEL "UF"        FORMAT "x(02)"
tt-impostos.cod-imposto       COLUMN-LABEL "Imposto"   FORMAT "x(07)"
tt-impostos.des-imposto       COLUMN-LABEL "Descri‡Æo" FORMAT "x(40)" WIDTH 20
tt-impostos.cod-classif-impto COLUMN-LABEL "Classif"   FORMAT "x(07)"
tt-impostos.des-classif-impto COLUMN-LABEL "Descri‡Æo" FORMAT "x(40)" WIDTH 30
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 50 BY 4.5
         FONT 1
         TITLE "Impostos" TOOLTIP "Aplique um duplo clique sobre a linha desejada para marcar ou desmarcar".

DEFINE BROWSE brDigita
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brDigita wReport _FREEFORM
  QUERY brDigita DISPLAY
      tt-digita.nat-operacao column-label "Natureza"
ENABLE
tt-digita.nat-operacao
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS SIZE 30.14 BY 10
         BGCOLOR 15 FONT 1
         TITLE BGCOLOR 15 "Naturezas".

DEFINE BROWSE brDigita-emit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brDigita-emit wReport _FREEFORM
  QUERY brDigita-emit DISPLAY
      tt-emit.cod-emitente column-label "Cliente"
      tt-emit.nome-emit    column-label "Nome"
ENABLE
tt-emit.cod-emitente
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS SIZE 50 BY 4.79
         BGCOLOR 15 FONT 1
         TITLE BGCOLOR 15 "Clientes".


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btOK AT ROW 16.75 COL 2
     btCancel AT ROW 16.75 COL 13
     btHelp2 AT ROW 16.75 COL 80
     rtToolBar AT ROW 16.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage2
     c-est-ini AT ROW 1.5 COL 12
     c-est-fim AT ROW 1.5 COL 52.43 NO-LABEL
     fi-ini-nat-operacao AT ROW 2.5 COL 22 COLON-ALIGNED HELP
          "Natureza da Opera‡Æo" WIDGET-ID 18
     fi-fim-nat-operacao AT ROW 2.5 COL 50.43 COLON-ALIGNED HELP
          "Natureza da Opera‡Æo" NO-LABEL WIDGET-ID 10
     fi-ini-cod-emitente AT ROW 3.5 COL 22 COLON-ALIGNED WIDGET-ID 14
     fi-fim-cod-emitente AT ROW 3.5 COL 50.43 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     fi-ini-data AT ROW 4.5 COL 22 COLON-ALIGNED WIDGET-ID 16
     fi-fim-data AT ROW 4.5 COL 50.43 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     fi-ini-uf AT ROW 5.5 COL 22 COLON-ALIGNED WIDGET-ID 20
     fi-fim-uf AT ROW 5.5 COL 50.43 COLON-ALIGNED NO-LABEL WIDGET-ID 12
     fi-it-codigo-ini AT ROW 6.5 COL 22 COLON-ALIGNED WIDGET-ID 38
     fi-it-codigo-fim AT ROW 6.5 COL 50.43 COLON-ALIGNED NO-LABEL WIDGET-ID 44
     fi-conta-ini AT ROW 7.5 COL 22 COLON-ALIGNED WIDGET-ID 46
     fi-conta-fim AT ROW 7.5 COL 50.43 COLON-ALIGNED NO-LABEL WIDGET-ID 52
     fi-subconta-ini AT ROW 8.5 COL 22 COLON-ALIGNED WIDGET-ID 68
     fi-subconta-fim AT ROW 8.5 COL 50.43 COLON-ALIGNED NO-LABEL WIDGET-ID 66
     fi-usuario-ini AT ROW 9.5 COL 22 COLON-ALIGNED WIDGET-ID 56
     fi-usuario-fim AT ROW 9.5 COL 50.43 COLON-ALIGNED NO-LABEL WIDGET-ID 54
     fl-class-fiscal-ini AT ROW 10.5 COL 22 COLON-ALIGNED WIDGET-ID 80
     fl-class-fiscal-fim AT ROW 10.5 COL 50.43 COLON-ALIGNED NO-LABEL WIDGET-ID 78
     fi-cod-msg-devolucao-ini AT ROW 11.5 COL 22.14 COLON-ALIGNED WIDGET-ID 72
     fi-cod-msg-devolucao-fim AT ROW 11.5 COL 50.43 COLON-ALIGNED NO-LABEL WIDGET-ID 70
     c-depos-ini AT ROW 12.5 COL 17.14 WIDGET-ID 88
     c-depos-fim AT ROW 12.5 COL 52.43 NO-LABEL WIDGET-ID 86
     IMAGE-1 AT ROW 1.5 COL 43.72
     IMAGE-2 AT ROW 1.5 COL 49.14
     IMAGE-11 AT ROW 2.5 COL 43.72 WIDGET-ID 22
     IMAGE-10 AT ROW 5.5 COL 49.14 WIDGET-ID 24
     IMAGE-12 AT ROW 2.5 COL 49.14 WIDGET-ID 26
     IMAGE-3 AT ROW 3.5 COL 43.72 WIDGET-ID 28
     IMAGE-4 AT ROW 3.5 COL 49.14 WIDGET-ID 30
     IMAGE-5 AT ROW 4.5 COL 43.72 WIDGET-ID 32
     IMAGE-6 AT ROW 4.5 COL 49.14 WIDGET-ID 34
     IMAGE-9 AT ROW 5.5 COL 43.72 WIDGET-ID 36
     IMAGE-13 AT ROW 6.5 COL 43.72 WIDGET-ID 40
     IMAGE-14 AT ROW 6.5 COL 49.14 WIDGET-ID 42
     IMAGE-15 AT ROW 7.5 COL 43.72 WIDGET-ID 48
     IMAGE-16 AT ROW 7.5 COL 49.14 WIDGET-ID 50
     IMAGE-21 AT ROW 8.5 COL 43.72 WIDGET-ID 58
     IMAGE-22 AT ROW 8.5 COL 49.14 WIDGET-ID 60
     IMAGE-23 AT ROW 9.5 COL 43.72 WIDGET-ID 62
     IMAGE-24 AT ROW 9.5 COL 49.14 WIDGET-ID 64
     IMAGE-25 AT ROW 11.5 COL 43.72 WIDGET-ID 74
     IMAGE-26 AT ROW 11.5 COL 49.14 WIDGET-ID 76
     IMAGE-27 AT ROW 10.5 COL 43.72 WIDGET-ID 82
     IMAGE-28 AT ROW 10.5 COL 49.14 WIDGET-ID 84
     IMAGE-29 AT ROW 12.5 COL 43.72 WIDGET-ID 90
     IMAGE-30 AT ROW 12.5 COL 49.14 WIDGET-ID 92
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.75
         SIZE 86 BY 13.21
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage6
     rsDestiny AT ROW 2.38 COL 3.14 HELP
          "Destino de ImpressÆo do Relat¢rio" NO-LABEL
     cFile AT ROW 3.63 COL 3.14 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL
     btFile AT ROW 3.5 COL 43 HELP
          "Escolha do nome do arquivo"
     btConfigImpr AT ROW 3.5 COL 43 HELP
          "Configura‡Æo da impressora"
     rsExecution AT ROW 5.75 COL 2.86 HELP
          "Modo de Execu‡Æo" NO-LABEL
     text-destino AT ROW 1.63 COL 1.86 COLON-ALIGNED NO-LABEL
     text-modo AT ROW 5 COL 1 COLON-ALIGNED NO-LABEL
     RECT-7 AT ROW 1.92 COL 2.14
     RECT-9 AT ROW 5.25 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.75
         SIZE 86 BY 13.21
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage4
     rs-natureza AT ROW 3.54 COL 26 NO-LABEL WIDGET-ID 40
     rs-tipo-relatorio AT ROW 6.46 COL 26 NO-LABEL WIDGET-ID 40
     tb-imprime-devol AT ROW 8.5 COL 4 WIDGET-ID 52
     tg-nf-atualizada AT ROW 8.5 COL 53 WIDGET-ID 60
     tb-imprime-conta AT ROW 9.42 COL 4 WIDGET-ID 4
     tb-imprime-financeiro AT ROW 10.25 COL 4 WIDGET-ID 50
     tg-imp-rateio AT ROW 11.08 COL 4 WIDGET-ID 56
     tg-filtra-imposto AT ROW 11.92 COL 4 WIDGET-ID 58
     tg-listar-chave-acesso AT ROW 11.92 COL 53 WIDGET-ID 64
     tg-bc-aliq AT ROW 12.75 COL 4 WIDGET-ID 62
     tg-listar-THC-II AT ROW 12.75 COL 53 WIDGET-ID 44
     "Natureza" VIEW-AS TEXT
          SIZE 8 BY .54 AT ROW 3.04 COL 8 WIDGET-ID 46
     "Tipo" VIEW-AS TEXT
          SIZE 8 BY .54 AT ROW 5.96 COL 9 WIDGET-ID 48
     RECT-10 AT ROW 3.29 COL 2 WIDGET-ID 38
     RECT-11 AT ROW 6.25 COL 2 WIDGET-ID 38
     RECT-12 AT ROW 8.04 COL 2 WIDGET-ID 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.75
         SIZE 86 BY 13.21
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage5
     brDigita AT ROW 1.5 COL 2
     br-impostos AT ROW 1.5 COL 35 WIDGET-ID 300
     bt-todos AT ROW 6.17 COL 45.57 WIDGET-ID 6
     bt-nenhum AT ROW 6.17 COL 60.57 WIDGET-ID 8
     brDigita-emit AT ROW 7.75 COL 35 WIDGET-ID 400
     btAdd AT ROW 11.75 COL 2
     btUpdate AT ROW 11.75 COL 12
     btDelete AT ROW 11.75 COL 22
     btSave AT ROW 12.75 COL 2 WIDGET-ID 12
     btOpen AT ROW 12.75 COL 12 WIDGET-ID 10
     btAdd-2 AT ROW 12.79 COL 35 WIDGET-ID 14
     btUpdate-2 AT ROW 12.79 COL 45 WIDGET-ID 22
     btDelete-2 AT ROW 12.79 COL 55 WIDGET-ID 16
     btSave-2 AT ROW 12.79 COL 65 WIDGET-ID 20
     btOpen-2 AT ROW 12.79 COL 75 WIDGET-ID 18
     RECT-13 AT ROW 1.25 COL 1 WIDGET-ID 2
     RECT-14 AT ROW 1.25 COL 34 WIDGET-ID 4
     RECT-164 AT ROW 7.5 COL 34 WIDGET-ID 24
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 2.75
         SIZE 86 BY 13.21
         FONT 1 WIDGET-ID 200.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wReport ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 17
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
ASSIGN FRAME fPage2:FRAME = FRAME fpage0:HANDLE
       FRAME fPage4:FRAME = FRAME fpage0:HANDLE
       FRAME fPage5:FRAME = FRAME fpage0:HANDLE
       FRAME fPage6:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   NOT-VISIBLE FRAME-NAME                                               */
/* SETTINGS FOR FRAME fPage2
                                                                        */
/* SETTINGS FOR FILL-IN c-depos-fim IN FRAME fPage2
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN c-depos-ini IN FRAME fPage2
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN c-est-fim IN FRAME fPage2
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN c-est-ini IN FRAME fPage2
   ALIGN-L                                                              */
/* SETTINGS FOR FRAME fPage4
                                                                        */
/* SETTINGS FOR FRAME fPage5
                                                                        */
/* BROWSE-TAB brDigita RECT-164 fPage5 */
/* BROWSE-TAB br-impostos brDigita fPage5 */
/* BROWSE-TAB brDigita-emit bt-nenhum fPage5 */
ASSIGN 
       br-impostos:COLUMN-RESIZABLE IN FRAME fPage5       = TRUE.

/* SETTINGS FOR FRAME fPage6
   Custom                                                               */
ASSIGN 
       text-destino:PRIVATE-DATA IN FRAME fPage6     = 
                "Destino".

ASSIGN 
       text-modo:PRIVATE-DATA IN FRAME fPage6     = 
                "Execu‡Æo".

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wReport)
THEN wReport:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-impostos
/* Query rebuild information for BROWSE br-impostos
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-impostos.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-impostos */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brDigita
/* Query rebuild information for BROWSE brDigita
     _START_FREEFORM
OPEN QUERY brDigita FOR EACH tt-digita.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE brDigita */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brDigita-emit
/* Query rebuild information for BROWSE brDigita-emit
     _START_FREEFORM
OPEN QUERY brDigita-emit FOR EACH tt-emit.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE brDigita-emit */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage2
/* Query rebuild information for FRAME fPage2
     _Query            is NOT OPENED
*/  /* FRAME fPage2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage4
/* Query rebuild information for FRAME fPage4
     _Query            is NOT OPENED
*/  /* FRAME fPage4 */
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


&Scoped-define BROWSE-NAME br-impostos
&Scoped-define FRAME-NAME fPage5
&Scoped-define SELF-NAME br-impostos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-impostos wReport
ON MOUSE-SELECT-DBLCLICK OF br-impostos IN FRAME fPage5 /* Impostos */
DO:
    IF  AVAIL tt-impostos
    THEN DO:
        IF  tt-impostos.cod-listar = ""
        THEN
            ASSIGN tt-impostos.cod-listar = "X".
        ELSE
            ASSIGN tt-impostos.cod-listar = "".
        br-impostos:REFRESH().
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brDigita
&Scoped-define SELF-NAME brDigita
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigita wReport
ON DEL OF brDigita IN FRAME fPage5 /* Naturezas */
DO:
   apply 'choose' to btDelete in frame fPage5.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigita wReport
ON END-ERROR OF brDigita IN FRAME fPage5 /* Naturezas */
ANYWHERE 
DO:
    if  brDigita:new-row in frame fPage5 then do:
        if  avail tt-digita then
            delete tt-digita.
        if  brDigita:delete-current-row() in frame fPage5 then. 
    end.                                                               
    else do:
        get current brDigita.
        display tt-digita.nat-operacao with browse brDigita. 
    end.
    return no-apply.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigita wReport
ON ENTER OF brDigita IN FRAME fPage5 /* Naturezas */
ANYWHERE
DO:
  apply 'tab' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigita wReport
ON INS OF brDigita IN FRAME fPage5 /* Naturezas */
DO:
   apply 'choose' to btAdd in frame fPage5.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigita wReport
ON OFF-END OF brDigita IN FRAME fPage5 /* Naturezas */
DO:
   apply 'entry' to btAdd in frame fPage5.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigita wReport
ON ROW-LEAVE OF brDigita IN FRAME fPage5 /* Naturezas */
DO:
    /*:T  aqui que a grava‡Æo da linha da temp-table ‚ efetivada.
       Por‚m as valida‡äes dos registros devem ser feitas na procedure pi-executar,
       no local indicado pelo coment rio */
    
    if brDigita:NEW-ROW in frame fPage5 then 
    do transaction on error undo, return no-apply:
        create tt-digita.
        assign input browse brDigita tt-digita.nat-operacao.

        brDigita:CREATE-RESULT-LIST-ENTRY() in frame fPage5.
    end.
    else do transaction on error undo, return no-apply:
        if avail tt-digita then
            assign input browse brDigita tt-digita.nat-operacao.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brDigita-emit
&Scoped-define SELF-NAME brDigita-emit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigita-emit wReport
ON DEL OF brDigita-emit IN FRAME fPage5 /* Clientes */
DO:
   apply 'choose' to btDelete-2 in frame fPage5.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigita-emit wReport
ON END-ERROR OF brDigita-emit IN FRAME fPage5 /* Clientes */
ANYWHERE 
DO:
    if  brDigita-emit:new-row in frame fPage5 then do:
        if  avail tt-emit then
            delete tt-emit.
        if  brDigita-emit:delete-current-row() in frame fPage5 then. 
    end.                                                               
    else do:
        get current brDigita-emit.
        display tt-emit.cod-emitente with browse brDigita-emit. 
    end.
    return no-apply.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigita-emit wReport
ON ENTER OF brDigita-emit IN FRAME fPage5 /* Clientes */
ANYWHERE
DO:
  apply 'tab' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigita-emit wReport
ON INS OF brDigita-emit IN FRAME fPage5 /* Clientes */
DO:
   apply 'choose' to btAdd-2 in frame fPage5.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigita-emit wReport
ON OFF-END OF brDigita-emit IN FRAME fPage5 /* Clientes */
DO:
   apply 'entry' to btAdd-2 in frame fPage5.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigita-emit wReport
ON ROW-LEAVE OF brDigita-emit IN FRAME fPage5 /* Clientes */
DO:
    /*:T  aqui que a grava‡Æo da linha da temp-table ‚ efetivada.
       Por‚m as valida‡äes dos registros devem ser feitas na procedure pi-executar,
       no local indicado pelo coment rio */
    
    if brDigita-emit:NEW-ROW in frame fPage5 then 
    do transaction on error undo, return no-apply:
        create tt-emit.
        assign input browse brDigita-emit tt-emit.cod-emitente.

        brDigita-emit:CREATE-RESULT-LIST-ENTRY() in frame fPage5.
    end.
    else do transaction on error undo, return no-apply:
        if avail tt-emit then
            assign input browse brDigita-emit tt-emit.cod-emitente.
    end.

    IF  AVAIL tt-emit THEN DO:
        FIND emitente NO-LOCK
            WHERE emitente.cod-emitente = tt-emit.cod-emitente NO-ERROR.

        IF  AVAIL emitente THEN
            ASSIGN tt-emit.nome-emit = emitente.nome-emit.
        ELSE
            ASSIGN tt-emit.nome-emit = "Inexistente".

    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-nenhum
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-nenhum wReport
ON CHOOSE OF bt-nenhum IN FRAME fPage5 /* Nenhum */
DO:
    FOR EACH tt-impostos:
        ASSIGN tt-impostos.cod-listar = "".
    END.
    br-impostos:REFRESH().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-todos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-todos wReport
ON CHOOSE OF bt-todos IN FRAME fPage5 /* Todos */
DO:
    FOR EACH tt-impostos:
        ASSIGN tt-impostos.cod-listar = "X".
    END.
    br-impostos:REFRESH().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btAdd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAdd wReport
ON CHOOSE OF btAdd IN FRAME fPage5 /* Inserir */
DO:
    assign btUpdate:SENSITIVE in frame fPage5 = yes
           btDelete:SENSITIVE in frame fPage5 = yes.
    
    if num-results("brDigita":U) > 0 then
        brDigita:INSERT-ROW("after":U) in frame fPage5.
    else do transaction:
        create tt-digita.
        
        open query brDigita for each tt-digita.
        
        apply "entry":U to tt-digita.nat-operacao in browse brDigita. 
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btAdd-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAdd-2 wReport
ON CHOOSE OF btAdd-2 IN FRAME fPage5 /* Inserir */
DO:
    assign btUpdate:SENSITIVE in frame fPage5 = yes
           btDelete:SENSITIVE in frame fPage5 = yes.
    
    if num-results("brDigita-emit":U) > 0 then
        brDigita-emit:INSERT-ROW("after":U) in frame fPage5.
    else do transaction:
        create tt-emit.
        
        open query brDigita-emit for each tt-emit.
        
        apply "entry":U to tt-emit.cod-emitente in browse brDigita-emit. 
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
               btDelete:SENSITIVE in frame fPage5 = no.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btDelete-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDelete-2 wReport
ON CHOOSE OF btDelete-2 IN FRAME fPage5 /* Retirar */
DO:
    if  brDigita-emit:num-selected-rows > 0 then do on error undo, return no-apply:
        get current brDigita-emit.
        delete tt-emit.
        if  brDigita-emit:delete-current-row() in frame fPage5 then.
    end.
    
    if num-results("brDigita-emit":U) = 0 then
        assign btUpdate:SENSITIVE in frame fPage5 = no
               btDelete:SENSITIVE in frame fPage5 = no.
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
    {report/rprcd.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOpen-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOpen-2 wReport
ON CHOOSE OF btOpen-2 IN FRAME fPage5 /* Recuperar */
DO:

    DEF VAR c-arquivo AS CHAR NO-UNDO.

    SYSTEM-DIALOG GET-FILE c-arquivo
       FILTERS "*.dig":U "*.dig":U,
               "*.*":U "*.*":U
       DEFAULT-EXTENSION "*.dig":U
       MUST-EXIST
       USE-FILENAME
       UPDATE l-ok.
    
    IF  NOT l-ok then
        RETURN NO-APPLY.

    EMPTY TEMP-TABLE tt-emit.
    
    INPUT FROM VALUE(c-arquivo) NO-ECHO.
    REPEAT:             
        CREATE tt-emit.
        IMPORT tt-emit.
    END.    
    INPUT CLOSE. 
    
    DELETE tt-emit.
    
    OPEN QUERY brDigita-emit FOR EACH tt-emit.
    
    IF  NUM-RESULTS("brDigita-emit":U) > 0 THEN
        ASSIGN btUpdate-2:SENSITIVE IN FRAME fPage5 = YES 
               btDelete-2:SENSITIVE IN FRAME fPage5 = YES
               btSave-2:SENSITIVE   IN FRAME fPage5 = YES.
    ELSE
        ASSIGN btUpdate-2:SENSITIVE IN FRAME fPage5 = NO 
               btDelete-2:SENSITIVE IN FRAME fPage5 = NO 
               btSave-2:SENSITIVE   IN FRAME fPage5 = NO.
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


&Scoped-define SELF-NAME btSave-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave-2 wReport
ON CHOOSE OF btSave-2 IN FRAME fPage5 /* Salvar */
DO:
    DEF VAR c-arquivo AS CHAR NO-UNDO.
    DEFINE VAR r-tt-emit AS ROWID NO-UNDO.
    
    SYSTEM-DIALOG GET-FILE c-arquivo
       FILTERS "*.dig":U "*.dig":U,
               "*.*":U "*.*":U
       ASK-OVERWRITE 
       DEFAULT-EXTENSION "*.dig":U
       SAVE-AS             
       CREATE-TEST-FILE
       USE-FILENAME
       UPDATE l-ok.
    
    IF  AVAIL tt-emit THEN  
        ASSIGN r-tt-emit = rowid(tt-emit).
    
    IF  l-ok THEN DO:
        OUTPUT TO VALUE(c-arquivo).
        FOR EACH tt-emit:
            EXPORT tt-emit.
        END.
        OUTPUT CLOSE. 
        
        REPOSITION brDigita-emit TO ROWID(r-tt-emit) NO-ERROR.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btUpdate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdate wReport
ON CHOOSE OF btUpdate IN FRAME fPage5 /* Alterar */
DO:
   apply 'entry' to tt-digita.nat-operacao in browse brDigita. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btUpdate-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdate-2 wReport
ON CHOOSE OF btUpdate-2 IN FRAME fPage5 /* Alterar */
DO:
   apply 'entry' to tt-emit.cod-emitente in browse brDigita-emit. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME rs-natureza
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-natureza wReport
ON MOUSE-SELECT-CLICK OF rs-natureza IN FRAME fPage4
DO:    
    IF int(rs-natureza:SCREEN-VALUE) = 1 THEN DO: 
       ASSIGN i-natureza = 1.     
    END.
    ELSE IF int(rs-natureza:SCREEN-VALUE) = 2 THEN DO: 
       ASSIGN i-natureza = 2.     
    END.
    else assign i-natureza = 3.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs-tipo-relatorio
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-tipo-relatorio wReport
ON MOUSE-SELECT-CLICK OF rs-tipo-relatorio IN FRAME fPage4
DO:
    
    IF  int(rs-tipo-relatorio:SCREEN-VALUE) = 1 /* Sint‚tico */ THEN DO: 
        ASSIGN tipo-rel = 1
               tg-bc-aliq:SENSITIVE             IN FRAME fPage4 = FALSE
               tg-listar-THC-II:SENSITIVE       IN FRAME fPage4 = FALSE
               tg-listar-chave-acesso:SENSITIVE IN FRAME fPage4 = TRUE.
    END.
    ELSE DO: /* Anal¡tico */
        ASSIGN tipo-rel = 2
               tg-bc-aliq:SENSITIVE             IN FRAME fPage4 = TRUE
               tg-listar-THC-II:SENSITIVE       IN FRAME fPage4 = TRUE
               tg-listar-chave-acesso:SENSITIVE IN FRAME fPage4 = FALSE.
    END.

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
        /*Alterado 15/02/2005 - tech1007 - Condi‡Æo removida pois RTF nÆo ‚ mais um destino
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


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME tb-imprime-conta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tb-imprime-conta wReport
ON VALUE-CHANGED OF tb-imprime-conta IN FRAME fPage4 /* Imprime Conta/Sub-conta e utiliza faixa de contas/sub-contas na sele‡Æo? */
DO:
    ASSIGN INPUT FRAME fPage4 tb-imprime-conta.

    IF tb-imprime-conta THEN DO:
        ASSIGN tb-imprime-financeiro:SENSITIVE IN FRAME fPage4 = YES.
    END.
    ELSE DO:
        ASSIGN tb-imprime-financeiro:SENSITIVE IN FRAME fPage4 = NO
               tb-imprime-financeiro:SCREEN-VALUE = "no".          
    END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-filtra-imposto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-filtra-imposto wReport
ON VALUE-CHANGED OF tg-filtra-imposto IN FRAME fPage4 /* Filtrar Fornecedor por Imposto */
DO:
    IF  tg-filtra-imposto:CHECKED IN FRAME fpage4 = YES
    THEN DO:
        EMPTY TEMP-TABLE tt-impostos.
        RUN esp/rep/esrep007-p (OUTPUT TABLE tt-impostos).
        OPEN QUERY br-impostos FOR EACH tt-impostos.  
    END.
    ELSE DO:
        EMPTY TEMP-TABLE tt-impostos.
        OPEN QUERY br-impostos FOR EACH tt-impostos.  
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-impostos
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wReport 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{report/mainblock.i}

assign c-est-ini:screen-value in frame fpage2 = v_cod_estab_usuar.

if tt-digita.nat-operacao:load-mouse-pointer ("image/lupa.cur") in BROWSE brDigita then.
if tt-emit.cod-emitente:load-mouse-pointer ("image/lupa.cur") in BROWSE brDigita-emit then.
/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO  ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
    ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

    on f5 of tt-digita.nat-operacao in browse brDigita
    or mouse-select-dblclick of tt-digita.nat-operacao in browse brDigita do:
        {include/zoomvar.i &prog-zoom=inzoom/z01in245.w
                           &campo=tt-digita.nat-operacao
                           &campozoom=nat-operacao
                           &browse=brDigita}
    END.


    on f5 of tt-emit.cod-emitente in browse brDigita-emit
    or mouse-select-dblclick of tt-emit.cod-emitente in browse brDigita-emit do:
    {include/zoomvar.i &prog-zoom=adzoom/z02ad098.w
                       &campo=tt-emit.cod-emitente
                       &campozoom=cod-emitente
                       &BROWSE=brDigita-emit
                       &campo2=tt-emit.nome-emit
                       &campozoom2="nome-emit"
                       &browse2=brDigita-emit}
    END.


    

    IF  NOT THIS-PROCEDURE:PERSISTENT THEN
        WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wReport 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*Alterado 17/02/2005 - tech1007 - Foi criado essa procedure para que seja realizado a inicializa‡Æo
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
DISP TODAY @ fi-fim-data WITH FRAME fpage2.

APPLY "value-changed" TO tb-imprime-conta IN FRAME fPage4.

APPLY "MOUSE-SELECT-CLICK":U TO rs-tipo-relatorio IN FRAME fPage4.

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

    /*15/02/2005 - tech1007 - Teste alterado pois RTF nÆo ‚ mais op‡Æo de Destino*/
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
    
    /*:T Aqui sÆo gravados os campos da temp-table que ser  passada como parƒmetro
       para o programa RP.P */

    DEF VAR c-emitentes-invalidos AS CHAR NO-UNDO.
    FOR EACH tt-emit: 
        FIND emitente NO-LOCK 
            WHERE emitente.cod-emitente = tt-emit.cod-emitente NO-ERROR.
        IF  NOT AVAIL emitente THEN DO:
            IF  c-emitentes-invalidos <> "" THEN
                ASSIGN c-emitentes-invalidos =  c-emitentes-invalidos + " | " + string(tt-emit.cod-emitente).
            ELSE
                ASSIGN c-emitentes-invalidos = string(tt-emit.cod-emitente).
        END.
    END.

    IF  c-emitentes-invalidos <> "" THEN DO:
        run utp/ut-msgs.p (input "show":U, INPUT 17006, input "Cliente(s) inv lido(s)~~":U + c-emitentes-invalidos).
        return error.
    END.

    IF input frame fPage2 fi-ini-data > input frame fPage2 fi-fim-data THEN DO:
        run utp/ut-msgs.p (input "show":U, input 15825, input "Data inicial maior que final":U).
        return error.
    END.
    IF input frame fPage2 fi-conta-ini > input frame fPage2 fi-conta-fim THEN DO:
        run utp/ut-msgs.p (input "show":U, input 15825, input "Conta inicial maior que final":U).
        return error.
    END.

    create tt-param.
    assign tt-param.usuario          = c-seg-usuario
           tt-param.destino          = input frame fPage6 rsDestiny
           tt-param.data-exec        = today
           tt-param.hora-exec        = time
           tt-param.ini-data         = input frame fPage2 fi-ini-data        
           tt-param.fim-data         = input frame fPage2 fi-fim-data        
           tt-param.ini-cod-emitente = input frame fPage2 fi-ini-cod-emitente
           tt-param.fim-cod-emitente = input frame fPage2 fi-fim-cod-emitente
           tt-param.ini-nat-operacao = input frame fPage2 fi-ini-nat-operacao
           tt-param.fim-nat-operacao = input frame fPage2 fi-fim-nat-operacao
           tt-param.ini-uf           = input frame fPage2 fi-ini-uf          
           tt-param.fim-uf           = input frame fPage2 fi-fim-uf
           tt-param.tipo             = tipo-rel
           tt-param.natureza         = i-natureza
           tt-param.imprime-conta    = input frame fPage4 tb-imprime-conta
           tt-param.imprime-devol    = input frame fPage4 tb-imprime-devol
           tt-param.imprime-financeiro = input frame fPage4 tb-imprime-financeiro
           tt-param.cod-estabel-ini  = input frame fPage2 c-est-ini
           tt-param.cod-estabel-fim  = input frame fPage2 c-est-fim
           tt-param.it-codigo-ini    = input frame fPage2 fi-it-codigo-ini
           tt-param.it-codigo-fim    = input frame fPage2 fi-it-codigo-fim
           tt-param.conta-ini        = INPUT FRAME fPage2 fi-conta-ini
           tt-param.conta-fim        = INPUT FRAME fPage2 fi-conta-fim
           tt-param.subconta-ini     = INPUT FRAME fPage2 fi-subconta-ini
           tt-param.subconta-fim     = INPUT FRAME fPage2 fi-subconta-fim
           tt-param.imp-rateio       = INPUT FRAME fpage4 tg-imp-rateio
           tt-param.log-filtra-impto = INPUT FRAME fpage4 tg-filtra-imposto
           tt-param.log-nf-atualiz   = INPUT FRAME fpage4 tg-nf-atualizada
           tt-param.ini-usuario      = INPUT FRAME fpage2 fi-usuario-ini
           tt-param.fim-usuario      = INPUT FRAME fpage2 fi-usuario-fim
           tt-param.ini-usuario      = INPUT FRAME fpage2 fi-usuario-ini
           tt-param.fim-usuario      = INPUT FRAME fpage2 fi-usuario-fim
           tt-param.classific-ini    = INPUT FRAME fpage2 fl-class-fiscal-ini
           tt-param.classific-fim    = INPUT FRAME fpage2 fl-class-fiscal-fim
           tt-param.cod-msg-devolucao-ini = INPUT FRAME fPage2 fi-cod-msg-devolucao-ini
           tt-param.cod-msg-devolucao-fim = INPUT FRAME fPage2 fi-cod-msg-devolucao-fim
           tt-param.cod-depos-ini    = INPUT FRAME fPage2 c-depos-ini
           tt-param.cod-depos-fim    = INPUT FRAME fPage2 c-depos-fim
           tt-param.log-bc-aliq      = tg-bc-aliq:CHECKED       IN FRAME fPage4
           tt-param.l-listar-THC-II  = tg-listar-THC-II:CHECKED IN FRAME fPage4
           tt-param.l-listar-chave   = tg-listar-chave-acesso:CHECKED IN FRAME fPage4.

               
    if tt-param.destino = 1 
    then 
        assign tt-param.arquivo = "":U.
    else if  tt-param.destino = 2 
        then assign tt-param.arquivo = input frame fPage6 cFile.
         else assign tt-param.arquivo = session:temp-directory + c-programa-mg97 + ".tmp":U.
    
    /*:T Coloque aqui a l¢gica de grava‡Æo dos demais campos que devem ser passados
       como parƒmetros para o programa RP.P, atrav‚s da temp-table tt-param */
    
    FOR EACH  tt-digita
        WHERE tt-digita.nat-operacao = "":
        DELETE tt-digita.
    END.

    IF  tt-param.log-filtra-impto = YES
    THEN DO:
        FOR EACH  tt-impostos
            WHERE tt-impostos.cod-listar = "X":
            CREATE tt-digita.
            ASSIGN tt-digita.cod-pais          = tt-impostos.cod-pais         
                   tt-digita.cod-unid-feder    = tt-impostos.cod-unid-feder   
                   tt-digita.cod-imposto       = tt-impostos.cod-imposto      
                   tt-digita.cod-classif-impto = tt-impostos.cod-classif-impto.
        END.
    END.

    FOR EACH tt-emit:
        CREATE tt-digita.
        ASSIGN tt-digita.tipo         = 1 /*emitente*/
               tt-digita.cod-emitente = tt-emit.cod-emitente.
    END.
    
    /*:T Executar do programa RP.P que ir  criar o relat¢rio */
    {report/rpexb.i}
    
    SESSION:SET-WAIT-STATE("GENERAL":U).
    
    {report/rprun.i esp/rep/esrep007rp.p}
    
    {report/rpexc.i}
    
    SESSION:SET-WAIT-STATE("":U).
    
    {report/rptrm.i}
end.
&ENDIF
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

