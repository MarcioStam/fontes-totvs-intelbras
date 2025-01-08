&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME w-livre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS w-livre 
/*:T *******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESPDP094 1.00.00.000}
{utp/ut-glob.i}
{esp/es0018.i} 

/* Chamada a include do gerenciador de licen»as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m½dulo>:  Informar qual o m½dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i ESPDP094 MFT}
&ENDIF

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
def new global shared var gr-ped-venda as rowid no-undo.

DEF BUFFER b-ped-item FOR ped-item.

define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)"
    field usuario          as char format "x(12)"
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field desc-classifica  as char format "x(40)"
    field modelo-rtf       as char format "x(35)"
    field l-habilitaRtf    as LOG
    FIELD cod-estabel-ini  LIKE ped-venda.cod-estabel
    FIELD cod-estabel-fim  LIKE ped-venda.cod-estabel
    FIELD tp-pedido-ini    LIKE ped-venda.tp-pedido
    FIELD tp-pedido-fim    LIKE ped-venda.tp-pedido
    FIELD dt-implanta-ini  LIKE ped-venda.dt-implant
    FIELD dt-implanta-fim  LIKE ped-venda.dt-implant
    FIELD dt-entrega-ini   LIKE ped-item.dt-entrega
    FIELD dt-entrega-fim   LIKE ped-item.dt-entrega
    FIELD nr-pedcli-ini    LIKE ped-venda.nr-pedcli
    FIELD nr-pedcli-fim    LIKE ped-venda.nr-pedcli
    FIELD cod-emitente-ini LIKE ped-venda.cod-emitente
    FIELD cod-emitente-fim LIKE ped-venda.cod-emitente
    //FIELD no-ab-reppri-ini LIKE ped-venda.no-ab-reppri
    //FIELD no-ab-reppri-fim LIKE ped-venda.no-ab-reppri
    field cod-rep-ini     like repres.cod-rep
    field cod-rep-fim     like repres.cod-rep

    FIELD cod-cond-pag-ini LIKE ped-venda.cod-cond-pag
    FIELD cod-cond-pag-fim LIKE ped-venda.cod-cond-pag
    FIELD grp-canais-ini   AS INT
    FIELD grp-canais-fim   AS INT
    FIELD cod-unid-neg-ini LIKE ped-item.cod-unid-neg
    FIELD cod-unid-neg-fim LIKE ped-item.cod-unid-neg
    FIELD estado-ini       LIKE ped-venda.estado
    FIELD estado-fim       LIKE ped-venda.estado
    FIELD prioridade       AS CHAR
    FIELD atendente-mestre AS CHAR
    FIELD ped-parc         AS LOG
    FIELD item-parc        AS LOG
    FIELD somente-integral AS LOG.

DEF TEMP-TABLE tt-ped-venda NO-UNDO LIKE ped-venda
    FIELD l-selec         AS LOG INIT NO
    FIELD abaixo-parc-min AS LOG 
    FIELD num-parcelas    LIKE cond-pagto.num-parcelas
    FIELD vl-alocado      AS DEC  COLUMN-LABEL 'Vl.Alocado'
    FIELD vl-parcela      AS DEC  COLUMN-LABEL 'Vl.Parcela'
    FIELD vl-falta-alocar AS DEC  COLUMN-LABEL 'Vl.Diferen‡a'
    FIELD des-cond-pag    AS CHAR COLUMN-LABEL 'Cond.Pagto'.

DEF TEMP-TABLE tt-estabel-bloq-fat 
    FIELD cod-estabel  LIKE ped-venda.cod-estabel . 

DEF TEMP-TABLE tt-ped-item NO-UNDO LIKE ped-item.

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEF VAR h-acomp    AS HANDLE NO-UNDO.
DEF VAR iCont      AS INT.
DEF VAR cEstab     AS CHAR FORMAT "x(50)".
DEF VAR p-mensagem AS CHAR FORMAT "x(256)".
DEF VAR c-desc-cond-pagto LIKE cond-pagto.descricao.
DEF VAR c-sit-ped AS CHAR FORMAT "x(30)".

def var i-cont-itens                  as int    no-undo.
DEF VAR qt-alocada LIKE ped-item.qt-aloca.
DEFINE VARIABLE l-item-total AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-pedido-total AS LOGICAL     NO-UNDO.

DEF BUFFER b01-tt-ped-venda FOR tt-ped-venda.

DEFINE VARIABLE i-cont-sel AS INTEGER     NO-UNDO.

DEFINE VARIABLE h-pd4000 AS HANDLE  NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE w-livre
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-cad
&Scoped-define BROWSE-NAME br-pedidos

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-ped-venda

/* Definitions for BROWSE br-pedidos                                    */
&Scoped-define FIELDS-IN-QUERY-br-pedidos tt-ped-venda.l-selec tt-ped-venda.cod-estabel tt-ped-venda.nr-pedido tt-ped-venda.nome-abrev tt-ped-venda.tp-pedido tt-ped-venda.vl-liq-abe tt-ped-venda.vl-alocado tt-ped-venda.vl-falta-alocar tt-ped-venda.des-cond-pag tt-ped-venda.vl-parcela tt-ped-venda.estado tt-ped-venda.nome-transp tt-ped-venda.observ   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-pedidos tt-ped-venda.l-selec   
&Scoped-define ENABLED-TABLES-IN-QUERY-br-pedidos tt-ped-venda
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br-pedidos tt-ped-venda
&Scoped-define SELF-NAME br-pedidos
&Scoped-define QUERY-STRING-br-pedidos FOR EACH tt-ped-venda NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br-pedidos OPEN QUERY {&SELF-NAME} FOR EACH tt-ped-venda NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br-pedidos tt-ped-venda
&Scoped-define FIRST-TABLE-IN-QUERY-br-pedidos tt-ped-venda


/* Definitions for FRAME f-pedidos                                      */
&Scoped-define OPEN-BROWSERS-IN-QUERY-f-pedidos ~
    ~{&OPEN-QUERY-br-pedidos}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-button bt-parametros bt-pedidos fi-color 
&Scoped-Define DISPLAYED-OBJECTS fi-color 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnCondPagto w-livre 
FUNCTION fnCondPagto RETURNS CHARACTER
  ( i-cod-cond-pag AS INT /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnSitPed w-livre 
FUNCTION fnSitPed RETURNS CHARACTER
  ( i-cod-sit-ped AS INT /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR w-livre AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU mi-programa 
       MENU-ITEM mi-consultas   LABEL "Co&nsultas"     ACCELERATOR "CTRL-L"
       MENU-ITEM mi-imprimir    LABEL "&Relat½rios"    ACCELERATOR "CTRL-P"
       RULE
       MENU-ITEM mi-sair        LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU m_Ajuda 
       MENU-ITEM mi-conteudo    LABEL "&Conteudo"     
       MENU-ITEM mi-sobre       LABEL "&Sobre..."     .

DEFINE MENU m-livre MENUBAR
       SUB-MENU  mi-programa    LABEL "&Nome-do-Programa"
       SUB-MENU  m_Ajuda        LABEL "&Ajuda"        .


/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_p-exihel AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-parametros 
     LABEL "Par³ametros" 
     SIZE 15 BY 1.13.

DEFINE BUTTON bt-pedidos 
     LABEL "Pedidos" 
     SIZE 15 BY 1.13.

DEFINE VARIABLE fi-color AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 11.72 BY .67 NO-UNDO.

DEFINE RECTANGLE rt-button
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 167 BY 1.46
     BGCOLOR 7 .

DEFINE BUTTON bt-carrega 
     IMAGE-UP FILE "image\im-sav":U
     IMAGE-INSENSITIVE FILE "image\ii-sav":U
     LABEL "Save" 
     SIZE 6 BY 1.25
     FONT 4.

DEFINE VARIABLE EDITOR-1 AS CHARACTER INITIAL "(OBS:Informe o Nø das prioridades separadas por ~"~;~")" 
     VIEW-AS EDITOR NO-WORD-WRAP MAX-CHARS 500 NO-BOX
     SIZE 88.43 BY .75
     FONT 0 NO-UNDO.

DEFINE VARIABLE c-atendente-mestre AS CHARACTER FORMAT "X(256)":U 
     LABEL "Atendente Mestre" 
     VIEW-AS FILL-IN 
     SIZE 22 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-estabel-fim AS CHARACTER FORMAT "X(5)":U INITIAL "ZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-estabel-ini AS CHARACTER FORMAT "X(5)":U 
     LABEL "Estabelec" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-unid-neg-fim AS CHARACTER FORMAT "X(3)":U INITIAL "ZZZ" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-unid-neg-ini AS CHARACTER FORMAT "X(3)":U 
     LABEL "Unid. Negoc." 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE VARIABLE c-estado-fim AS CHARACTER FORMAT "X(2)":U INITIAL "ZZ" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE VARIABLE c-estado-ini AS CHARACTER FORMAT "X(2)":U 
     LABEL "Estado" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE VARIABLE c-nr-pedcli-fim AS CHARACTER FORMAT "X(12)":U INITIAL "ZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE c-nr-pedcli-ini AS CHARACTER FORMAT "X(12)":U 
     LABEL "Nr. Pedido" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE c-prioridade AS CHARACTER FORMAT "X(256)":U 
     LABEL "Prioridade" 
     VIEW-AS FILL-IN 
     SIZE 22 BY .88 TOOLTIP "Ex:01;02;03;04;" NO-UNDO.

DEFINE VARIABLE c-tp-pedido-fim AS CHARACTER FORMAT "X(2)":U INITIAL "00" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE VARIABLE c-tp-pedido-ini AS CHARACTER FORMAT "X(2)":U INITIAL "00" 
     LABEL "Atendente" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE VARIABLE d-dt-entrega-fim AS DATE FORMAT "99/99/9999":U INITIAL 12/31/9999 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE d-dt-entrega-ini AS DATE FORMAT "99/99/9999":U 
     LABEL "Data Entrega" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE d-dt-implanta-fim AS DATE FORMAT "99/99/9999":U INITIAL 12/31/9999 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE d-dt-implanta-ini AS DATE FORMAT "99/99/9999":U 
     LABEL "Data Implant." 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-item AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 45 BY .88 NO-UNDO.

DEFINE VARIABLE fi-item AS CHARACTER FORMAT "X(16)":U 
     LABEL "Cod.Item" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-cond-pag-fim AS INTEGER FORMAT ">>>9":U INITIAL 9999 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-cond-pag-ini AS INTEGER FORMAT ">>>9":U INITIAL 0 
     LABEL "Cond. Pagto." 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-emitente-fim AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 999999999 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-emitente-ini AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-rep-fim AS INTEGER FORMAT ">>>>9":U INITIAL 99999 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-rep-ini AS INTEGER FORMAT ">>>>9" INITIAL 0 
     LABEL "Cod.Repres" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE i-grp-canais-fim AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 999999999 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE i-grp-canais-ini AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "Grp. Canais" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

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

DEFINE IMAGE IMAGE-17
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-18
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-19
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-2
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-20
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-21
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-22
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-3
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-4
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-43
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-44
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

DEFINE VARIABLE i-orig-mercad AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Estabec Intelbras", 1,
"Deposito Entreposto", 2
     SIZE 50.14 BY .92 NO-UNDO.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 152 BY 7.25.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 152 BY 11.75.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 75.72 BY 2.

DEFINE RECTANGLE RECT-17
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 76.14 BY 2.

DEFINE VARIABLE tg-item-parc AS LOGICAL INITIAL yes 
     LABEL "Fatura itens parciais (Itens Parciais)" 
     VIEW-AS TOGGLE-BOX
     SIZE 27.72 BY .75 NO-UNDO.

DEFINE VARIABLE tg-ped-parc AS LOGICAL INITIAL yes 
     LABEL "Fatura pedidos parciais (Item integral / Pedido Parcial)" 
     VIEW-AS TOGGLE-BOX
     SIZE 41.72 BY .75 NO-UNDO.

DEFINE VARIABLE tg-somente-integral AS LOGICAL INITIAL no 
     LABEL "Somente Pedido Integral" 
     VIEW-AS TOGGLE-BOX
     SIZE 25.72 BY .75 NO-UNDO.

DEFINE BUTTON br-consult-item 
     LABEL "Consultar Item" 
     SIZE 15 BY 1.13.

DEFINE BUTTON bt-consult-pedido 
     LABEL "Consultar Pedido" 
     SIZE 15 BY 1.13.

DEFINE BUTTON bt-desmarcar 
     LABEL "Desmarcar" 
     SIZE 15 BY 1.13.

DEFINE BUTTON bt-desmarcar-todos 
     LABEL "Desmarcar Todos" 
     SIZE 15 BY 1.13.

DEFINE BUTTON bt-faturar 
     LABEL "Faturar" 
     SIZE 15 BY 1.13.

DEFINE BUTTON bt-marcar 
     LABEL "Marcar" 
     SIZE 15 BY 1.13.

DEFINE BUTTON bt-marcar-todos 
     LABEL "Marcar Todos" 
     SIZE 15 BY 1.13.

DEFINE VARIABLE fi-selecao-ped AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "Pedidos Selecionados" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .75
     FGCOLOR 0 FONT 0 NO-UNDO.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 34.14 BY 1.04.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-pedidos FOR 
      tt-ped-venda SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-pedidos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-pedidos w-livre _FREEFORM
  QUERY br-pedidos NO-LOCK DISPLAY
      tt-ped-venda.l-selec COLUMN-LABEL "Sel" WIDTH 3 VIEW-AS TOGGLE-BOX
tt-ped-venda.cod-estabel 
tt-ped-venda.nr-pedido    FORMAT ">>>,>>>,>>9" WIDTH 10
tt-ped-venda.nome-abrev   FORMAT "x(12)" WIDTH 12
tt-ped-venda.tp-pedido    COLUMN-LABEL 'Atendente'
tt-ped-venda.vl-liq-abe   FORMAT ">>>,>>>,>>9.99" COLUMN-LABEL 'Vl.Saldo'                       
tt-ped-venda.vl-alocado   FORMAT ">>>,>>>,>>9.99"
tt-ped-venda.vl-falta-alocar   FORMAT "->>>,>>>,>>9.99"
tt-ped-venda.des-cond-pag FORMAT 'x(60)' WIDTH 20
tt-ped-venda.vl-parcela   FORMAT ">>>,>>>,>>9.99" WIDTH 9
tt-ped-venda.estado       FORMAT "x(04)"  WIDTH 3
tt-ped-venda.nome-transp  FORMAT "x(12)"  WIDTH 12
tt-ped-venda.observ       FORMAT "x(1000)" WIDTH 500 COLUMN-LABEL 'Observ'       
ENABLE
tt-ped-venda.l-selec
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 162.14 BY 20.25
         FONT 4 ROW-HEIGHT-CHARS .58.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-cad
     bt-parametros AT ROW 2.88 COL 1.86 WIDGET-ID 2
     bt-pedidos AT ROW 2.88 COL 16.72 WIDGET-ID 4
     fi-color AT ROW 3.08 COL 116.43 COLON-ALIGNED NO-LABEL WIDGET-ID 6 BLANK  DEBLANK 
     rt-button AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1.17
         SIZE 167.72 BY 25.83
         FONT 4 WIDGET-ID 100.

DEFINE FRAME f-parametros
     i-orig-mercad AT ROW 2 COL 22 NO-LABEL WIDGET-ID 124
     fi-item AT ROW 1.92 COL 87.14 COLON-ALIGNED WIDGET-ID 136
     fi-desc-item AT ROW 1.92 COL 99.29 COLON-ALIGNED NO-LABEL WIDGET-ID 146
     c-cod-estabel-ini AT ROW 4.25 COL 24 COLON-ALIGNED WIDGET-ID 98
     c-cod-estabel-fim AT ROW 4.25 COL 53.57 COLON-ALIGNED NO-LABEL WIDGET-ID 96
     c-tp-pedido-ini AT ROW 5.25 COL 24 COLON-ALIGNED WIDGET-ID 4
     c-tp-pedido-fim AT ROW 5.25 COL 53.57 COLON-ALIGNED NO-LABEL WIDGET-ID 2
     d-dt-implanta-ini AT ROW 6.25 COL 24 COLON-ALIGNED WIDGET-ID 20
     d-dt-implanta-fim AT ROW 6.25 COL 53.57 COLON-ALIGNED NO-LABEL WIDGET-ID 18
     d-dt-entrega-ini AT ROW 7.25 COL 24 COLON-ALIGNED WIDGET-ID 28
     d-dt-entrega-fim AT ROW 7.25 COL 53.57 COLON-ALIGNED NO-LABEL WIDGET-ID 26
     c-nr-pedcli-ini AT ROW 8.25 COL 24 COLON-ALIGNED WIDGET-ID 36
     c-nr-pedcli-fim AT ROW 8.25 COL 53.57 COLON-ALIGNED NO-LABEL WIDGET-ID 34
     i-cod-emitente-ini AT ROW 9.25 COL 24 COLON-ALIGNED WIDGET-ID 44
     i-cod-emitente-fim AT ROW 9.25 COL 53.57 COLON-ALIGNED NO-LABEL WIDGET-ID 42
     i-cod-rep-ini AT ROW 10.25 COL 24 COLON-ALIGNED HELP
          "C½digo do representante direto" WIDGET-ID 52
     i-cod-rep-fim AT ROW 10.25 COL 53.57 COLON-ALIGNED NO-LABEL WIDGET-ID 50
     i-cod-cond-pag-ini AT ROW 11.25 COL 24 COLON-ALIGNED WIDGET-ID 60
     i-cod-cond-pag-fim AT ROW 11.25 COL 53.57 COLON-ALIGNED NO-LABEL WIDGET-ID 58
     i-grp-canais-ini AT ROW 12.25 COL 24 COLON-ALIGNED WIDGET-ID 68
     i-grp-canais-fim AT ROW 12.25 COL 53.57 COLON-ALIGNED NO-LABEL WIDGET-ID 66
     c-cod-unid-neg-ini AT ROW 13.25 COL 24 COLON-ALIGNED WIDGET-ID 76
     c-cod-unid-neg-fim AT ROW 13.25 COL 53.57 COLON-ALIGNED NO-LABEL WIDGET-ID 74
     c-estado-ini AT ROW 14.29 COL 24 COLON-ALIGNED WIDGET-ID 110
     c-estado-fim AT ROW 14.29 COL 53.57 COLON-ALIGNED NO-LABEL WIDGET-ID 108
     c-prioridade AT ROW 16.42 COL 24 COLON-ALIGNED WIDGET-ID 82
     EDITOR-1 AT ROW 16.63 COL 49.29 NO-LABEL WIDGET-ID 134
     c-atendente-mestre AT ROW 17.42 COL 24 COLON-ALIGNED WIDGET-ID 84
     tg-ped-parc AT ROW 18.42 COL 26 WIDGET-ID 90
     tg-item-parc AT ROW 19.29 COL 26 WIDGET-ID 92
     tg-somente-integral AT ROW 20.17 COL 26 WIDGET-ID 94
     bt-carrega AT ROW 4.25 COL 70 HELP
          "Confirma altera»„es" WIDGET-ID 120
     "Filtrar Produto" VIEW-AS TEXT
          SIZE 10 BY .54 AT ROW 1.04 COL 80.14 WIDGET-ID 144
     "Origem de Mercadoria" VIEW-AS TEXT
          SIZE 16 BY .54 AT ROW 1 COL 4 WIDGET-ID 130
     "Sele‡Æo" VIEW-AS TEXT
          SIZE 6 BY .67 AT ROW 3.38 COL 4 WIDGET-ID 118
     "Para³metros" VIEW-AS TEXT
          SIZE 8 BY .58 AT ROW 15.67 COL 4 WIDGET-ID 116
     IMAGE-1 AT ROW 4.25 COL 40.86 WIDGET-ID 100
     IMAGE-2 AT ROW 4.25 COL 52 WIDGET-ID 102
     IMAGE-3 AT ROW 5.25 COL 40.86 WIDGET-ID 6
     IMAGE-4 AT ROW 5.25 COL 52 WIDGET-ID 8
     IMAGE-7 AT ROW 6.25 COL 40.86 WIDGET-ID 22
     IMAGE-8 AT ROW 6.25 COL 52 WIDGET-ID 24
     IMAGE-9 AT ROW 7.25 COL 40.86 WIDGET-ID 30
     IMAGE-10 AT ROW 7.25 COL 52 WIDGET-ID 32
     IMAGE-11 AT ROW 8.25 COL 40.86 WIDGET-ID 40
     IMAGE-12 AT ROW 8.25 COL 52 WIDGET-ID 38
     IMAGE-13 AT ROW 9.25 COL 40.86 WIDGET-ID 46
     IMAGE-14 AT ROW 9.25 COL 52 WIDGET-ID 48
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2 ROW 4
         SIZE 166 BY 22.5
         FONT 4 WIDGET-ID 300.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME f-parametros
     IMAGE-15 AT ROW 10.25 COL 40.86 WIDGET-ID 54
     IMAGE-16 AT ROW 10.25 COL 52 WIDGET-ID 56
     IMAGE-17 AT ROW 11.25 COL 40.86 WIDGET-ID 62
     IMAGE-18 AT ROW 11.25 COL 52 WIDGET-ID 64
     IMAGE-19 AT ROW 12.25 COL 40.86 WIDGET-ID 70
     IMAGE-20 AT ROW 12.25 COL 52 WIDGET-ID 72
     IMAGE-21 AT ROW 13.25 COL 40.86 WIDGET-ID 78
     IMAGE-22 AT ROW 13.21 COL 52 WIDGET-ID 80
     RECT-10 AT ROW 16.04 COL 2 WIDGET-ID 104
     RECT-11 AT ROW 3.75 COL 2 WIDGET-ID 106
     IMAGE-43 AT ROW 14.29 COL 40.86 WIDGET-ID 112
     IMAGE-44 AT ROW 14.25 COL 52 WIDGET-ID 114
     RECT-13 AT ROW 1.25 COL 2 WIDGET-ID 128
     RECT-17 AT ROW 1.25 COL 77.86 WIDGET-ID 142
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2 ROW 4
         SIZE 166 BY 22.5
         FONT 4 WIDGET-ID 300.

DEFINE FRAME f-pedidos
     br-pedidos AT ROW 1.75 COL 2.86 WIDGET-ID 400
     bt-marcar-todos AT ROW 22 COL 2.72 WIDGET-ID 2
     bt-desmarcar-todos AT ROW 22 COL 17.72 WIDGET-ID 4
     bt-marcar AT ROW 22 COL 32.72 WIDGET-ID 6
     bt-desmarcar AT ROW 22 COL 47.72 WIDGET-ID 8
     bt-faturar AT ROW 22 COL 62.72 WIDGET-ID 10
     br-consult-item AT ROW 22 COL 77.72 WIDGET-ID 12
     bt-consult-pedido AT ROW 22 COL 92.72 WIDGET-ID 14
     fi-selecao-ped AT ROW 22.17 COL 148.29 COLON-ALIGNED WIDGET-ID 18
     RECT-12 AT ROW 22.08 COL 131 WIDGET-ID 20
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2 ROW 4
         SIZE 166 BY 22.5
         FONT 4 WIDGET-ID 200.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: w-livre
   Allow: Basic,Browse,DB-Fields,Smart,Window,Query
   Container Links: 
   Add Fields to: Neither
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW w-livre ASSIGN
         HIDDEN             = YES
         TITLE              = "Faturamento Automatico de Pedidos"
         HEIGHT             = 26
         WIDTH              = 167.72
         MAX-HEIGHT         = 26.83
         MAX-WIDTH          = 167.72
         VIRTUAL-HEIGHT     = 26.83
         VIRTUAL-WIDTH      = 167.72
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU m-livre:HANDLE.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB w-livre 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{include/w-livre.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW w-livre
  VISIBLE,,RUN-PERSISTENT                                               */
/* REPARENT FRAME */
ASSIGN FRAME f-parametros:FRAME = FRAME f-cad:HANDLE
       FRAME f-pedidos:FRAME = FRAME f-cad:HANDLE.

/* SETTINGS FOR FRAME f-cad
   FRAME-NAME L-To-R                                                    */
/* SETTINGS FOR FRAME f-parametros
   Custom                                                               */
ASSIGN 
       EDITOR-1:READ-ONLY IN FRAME f-parametros        = TRUE.

/* SETTINGS FOR FILL-IN fi-desc-item IN FRAME f-parametros
   NO-ENABLE                                                            */
/* SETTINGS FOR FRAME f-pedidos
                                                                        */
/* BROWSE-TAB br-pedidos RECT-12 f-pedidos */
ASSIGN 
       br-pedidos:COLUMN-RESIZABLE IN FRAME f-pedidos       = TRUE.

ASSIGN 
       fi-selecao-ped:READ-ONLY IN FRAME f-pedidos        = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-livre)
THEN w-livre:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-pedidos
/* Query rebuild information for BROWSE br-pedidos
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-ped-venda NO-LOCK INDEXED-REPOSITION.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Query            is OPENED
*/  /* BROWSE br-pedidos */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME w-livre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-livre w-livre
ON END-ERROR OF w-livre /* Faturamento Automatico de Pedidos */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-livre w-livre
ON WINDOW-CLOSE OF w-livre /* Faturamento Automatico de Pedidos */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pedidos
&Scoped-define SELF-NAME br-consult-item
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-consult-item w-livre
ON CHOOSE OF br-consult-item IN FRAME f-pedidos /* Consultar Item */
DO:
    IF AVAIL tt-ped-venda THEN DO:

      GET CURRENT br-pedidos.

      ASSIGN {&WINDOW-NAME}:SENSITIVE = FALSE.
      RUN esp/pdp/espdp094b.w (INPUT TABLE tt-ped-item,
                               INPUT tt-ped-venda.cod-estabel,
                               INPUT tt-ped-venda.nr-pedcli,
                               INPUT tt-ped-venda.nome-abrev).
      ASSIGN {&WINDOW-NAME}:SENSITIVE = TRUE.
  END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-pedidos
&Scoped-define SELF-NAME br-pedidos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-pedidos w-livre
ON MOUSE-SELECT-CLICK OF br-pedidos IN FRAME f-pedidos
DO:
    FIND FIRST ped-venda NO-LOCK
          WHERE ped-venda.nr-pedido = int(tt-ped-venda.nr-pedido:SCREEN-VALUE IN BROWSE br-pedidos) NO-ERROR.

    IF AVAIL ped-venda THEN DO:
       ASSIGN gr-ped-venda = ROWID(ped-venda).

       IF tt-ped-venda.observ <> '' THEN
          ASSIGN br-pedidos:TOOLTIP IN FRAME f-pedidos = 'Observ: ' +  REPLACE(REPLACE(tt-ped-venda.observ,CHR(13),' '),CHR(10),' ').
    END.

    

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-pedidos w-livre
ON MOUSE-SELECT-DBLCLICK OF br-pedidos IN FRAME f-pedidos
DO:
  IF AVAIL tt-ped-venda THEN DO:

      GET CURRENT br-pedidos.

      IF tt-ped-venda.l-selec = NO THEN
          ASSIGN tt-ped-venda.l-selec = YES
                 tt-ped-venda.l-selec:SCREEN-VALUE IN BROWSE br-pedidos = "YES".
      ELSE
          ASSIGN tt-ped-venda.l-selec = NO
                 tt-ped-venda.l-selec:SCREEN-VALUE IN BROWSE br-pedidos = "NO".
  END.

  RUN pi-carrega-selecao-ped.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-pedidos w-livre
ON ROW-DISPLAY OF br-pedidos IN FRAME f-pedidos
DO:
    
    IF tt-ped-venda.abaixo-parc-min THEN
        ASSIGN tt-ped-venda.vl-parcela:FGCOLOR IN BROWSE br-pedidos = 12.
    
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-pedidos w-livre
ON START-SEARCH OF br-pedidos IN FRAME f-pedidos
DO:
   DEFINE VARIABLE hSortColumn  AS WIDGET-HANDLE.
  DEFINE VARIABLE hQueryHandle AS HANDLE     NO-UNDO.

  hSortColumn = BROWSE br-pedidos:CURRENT-COLUMN.
  
  IF hSortColumn:NAME = 'c-desc-cond-pagto' THEN LEAVE.

  hQueryHandle = BROWSE br-pedidos:QUERY.
  hQueryHandle:QUERY-CLOSE().
  hQueryHandle:QUERY-PREPARE("FOR EACH tt-ped-venda NO-LOCK BY " + hSortColumn:NAME).
  hQueryHandle:QUERY-OPEN().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-parametros
&Scoped-define SELF-NAME bt-carrega
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-carrega w-livre
ON CHOOSE OF bt-carrega IN FRAME f-parametros /* Save */
DO:

    ASSIGN p-mensagem = "".
    ASSIGN cEstab = "".
    EMPTY TEMP-TABLE tt-estabel-bloq-fat.

   /* cria tt-param. Usada na pi-carrega-pedidos */

   IF INPUT FRAME f-parametros c-prioridade = '' THEN
   DO:
      run utp/ut-msgs.p (input "show":U,
                         input 17006,                                            
                         input 'Prioriade deve ser preenchida').

      APPLY 'entry' TO c-prioridade IN FRAME f-parametros.

      RETURN NO-APPLY.
   END.

   IF SUBSTRING(c-prioridade:SCREEN-VALUE IN FRAME f-parametros,LENGTH(c-prioridade:SCREEN-VALUE IN FRAME f-parametros),1) <> ';' THEN
      ASSIGN c-prioridade:SCREEN-VALUE IN FRAME f-parametros = c-prioridade:SCREEN-VALUE IN FRAME f-parametros + ';'.

   IF fi-item:SCREEN-VALUE IN FRAME f-parametros <> '' THEN DO:

      FIND FIRST ITEM WHERE ITEM.it-codigo = fi-item:SCREEN-VALUE IN FRAME f-parametros NO-LOCK NO-ERROR.

      IF NOT AVAIL ITEM THEN DO:
         MESSAGE 'Cod.Item informado nao cadastrado'
             VIEW-AS ALERT-BOX ERROR BUTTONS OK.  

         APPLY 'entry' TO fi-item IN FRAME f-parametros.

         RETURN NO-APPLY.
      END.
   END.

   RUN pi-carrega-tt-param.

   FIND FIRST tt-param .

   ASSIGN iCont = int(tt-param.cod-estabel-ini) .
   DO WHILE iCont <= int(tt-param.cod-estabel-fim):

        RUN pi-valida-bloqueio-fat( INPUT STRING(iCont),
                                    INPUT c-seg-usuario,
                                    OUTPUT p-mensagem) . 

        IF length(p-mensagem) > 0 THEN DO:
           ASSIGN cEstab = cEstab + string(iCont) + ";" .

           CREATE tt-estabel-bloq-fat.
           ASSIGN tt-estabel-bloq-fat.cod-estabel = STRING(iCont).
        END.

        ASSIGN iCont = iCont + 1.

   END.

   IF length(cEstab) > 0 THEN DO:
       MESSAGE "Faturamento bloqueado para os estabelecimentos: " + cEstab SKIP
               "Os pedidos destes estabelecimentos nÆo serÆo carregados" 
           VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
   END.

   /* carregar pedidos */
   RUN pi-carrega-pedidos. 

   VIEW FRAME f-pedidos.
   HIDE FRAME f-parametros.

   RUN pi-carrega-selecao-ped.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pedidos
&Scoped-define SELF-NAME bt-consult-pedido
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-consult-pedido w-livre
ON CHOOSE OF bt-consult-pedido IN FRAME f-pedidos /* Consultar Pedido */
DO:
   

   IF AVAIL tt-ped-venda THEN DO:
  
       GET CURRENT br-pedidos.
  
       FIND FIRST ped-venda NO-LOCK
            WHERE ped-venda.nr-pedido = tt-ped-venda.nr-pedido NO-ERROR.
  
       ASSIGN gr-ped-venda = rowid(ped-venda).
  
       IF NOT VALID-HANDLE(h-pd4000) THEN DO:
  
           RUN pdp/pd4000.w PERSISTENT SET h-pd4000.
           RUN dispatch IN h-pd4000 ('initialize') no-error.
           RUN repositionRecord IN h-pd4000 (INPUT gr-ped-venda).
       END.
       ELSE
           RUN repositionRecord IN h-pd4000 (INPUT gr-ped-venda).
  
   END.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-desmarcar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-desmarcar w-livre
ON CHOOSE OF bt-desmarcar IN FRAME f-pedidos /* Desmarcar */
DO:
  IF AVAIL tt-ped-venda THEN DO:

      GET CURRENT br-pedidos.

      ASSIGN tt-ped-venda.l-selec = NO
             tt-ped-venda.l-selec:SCREEN-VALUE IN BROWSE br-pedidos = "NO".
  END.

  RUN pi-carrega-selecao-ped.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-desmarcar-todos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-desmarcar-todos w-livre
ON CHOOSE OF bt-desmarcar-todos IN FRAME f-pedidos /* Desmarcar Todos */
DO:
   DEFINE VARIABLE i-lista-ped AS INTEGER     NO-UNDO.

   FIND FIRST tt-ped-venda WHERE tt-ped-venda.l-selec NO-ERROR.

   IF AVAIL tt-ped-venda THEN
   DO:
       RUN esp/pdp/espdp094c.w (OUTPUT i-lista-ped).

       IF i-lista-ped = 0 THEN
       DO:
          MESSAGE 'Nenhuma opcao de marcacao foi selecionada'
              VIEW-AS ALERT-BOX ERROR BUTTONS OK.

          RETURN NO-APPLY.
       END.               
   END.



  FOR EACH tt-ped-venda:
      
      IF i-lista-ped = 1 THEN //Somente pedidos acima da parcela minima
      DO:
         IF NOT tt-ped-venda.abaixo-parc-min THEN
            ASSIGN tt-ped-venda.l-selec = NO.
      END.
      ELSE 
        ASSIGN tt-ped-venda.l-selec = NO.
  END.  

   {&OPEN-QUERY-br-pedidos}

  RUN pi-carrega-selecao-ped.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-faturar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-faturar w-livre
ON CHOOSE OF bt-faturar IN FRAME f-pedidos /* Faturar */
DO:
  ASSIGN {&WINDOW-NAME}:SENSITIVE = FALSE.
  /* faturar */
  RUN esp/pdp/espdp094a.w (INPUT TABLE tt-ped-venda,
                           INPUT TABLE tt-param).

  ASSIGN {&WINDOW-NAME}:SENSITIVE = TRUE.

  RUN pi-limpa-dados.

  RUN pi-carrega-selecao-ped.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-marcar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-marcar w-livre
ON CHOOSE OF bt-marcar IN FRAME f-pedidos /* Marcar */
DO:
  IF AVAIL tt-ped-venda THEN DO:

      GET CURRENT br-pedidos.

      ASSIGN tt-ped-venda.l-selec = YES
             tt-ped-venda.l-selec:SCREEN-VALUE IN BROWSE br-pedidos = "YES".
  END.

  RUN pi-carrega-selecao-ped.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-marcar-todos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-marcar-todos w-livre
ON CHOOSE OF bt-marcar-todos IN FRAME f-pedidos /* Marcar Todos */
DO:
   DEFINE VARIABLE i-lista-ped AS INTEGER     NO-UNDO.

   FIND FIRST tt-ped-venda NO-ERROR.

   IF AVAIL tt-ped-venda THEN
   DO:
       RUN esp/pdp/espdp094c.w (OUTPUT i-lista-ped).

       IF i-lista-ped = 0 THEN
       DO:
          MESSAGE 'Nenhuma opcao de marcacao foi selecionada'
              VIEW-AS ALERT-BOX ERROR BUTTONS OK.

          RETURN NO-APPLY.
       END.               
   END.

   
  FOR EACH tt-ped-venda:
      
      IF i-lista-ped = 1 THEN //Somente pedidos acima da parcela minima
      DO:
         IF NOT tt-ped-venda.abaixo-parc-min THEN
            ASSIGN tt-ped-venda.l-selec = YES.
         ELSE 
            ASSIGN tt-ped-venda.l-selec = NO.
      END.
      ELSE 
        ASSIGN tt-ped-venda.l-selec = YES.
  END.  

  {&OPEN-QUERY-br-pedidos}

  RUN pi-carrega-selecao-ped.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-cad
&Scoped-define SELF-NAME bt-parametros
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-parametros w-livre
ON CHOOSE OF bt-parametros IN FRAME f-cad /* Par³ametros */
DO:
  VIEW FRAME f-parametros.
  HIDE FRAME f-pedidos.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-pedidos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-pedidos w-livre
ON CHOOSE OF bt-pedidos IN FRAME f-cad /* Pedidos */
DO:
  VIEW FRAME f-pedidos.
  HIDE FRAME f-parametros.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-parametros
&Scoped-define SELF-NAME fi-item
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-item w-livre
ON F5 OF fi-item IN FRAME f-parametros /* Cod.Item */
DO:
    {include/zoomvar.i &prog-zoom = inzoom/z02in172.w
                       &campo=fi-item
                       &campozoom=it-codigo
                       &campo2=fi-desc-item
                       &campozoom2=desc-item}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-item w-livre
ON LEAVE OF fi-item IN FRAME f-parametros /* Cod.Item */
DO:
   FIND FIRST ITEM WHERE ITEM.it-codigo = fi-item:SCREEN-VALUE IN FRAME f-parametros NO-LOCK NO-ERROR.

   IF AVAIL ITEM THEN 
      ASSIGN fi-desc-item:SCREEN-VALUE IN FRAME f-parametros = ITEM.desc-item.
   ELSE DO:                                      
      ASSIGN fi-desc-item:SCREEN-VALUE IN FRAME f-parametros = ''.

      MESSAGE 'Cod.Item informado nao cadastrado'
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.    
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-item w-livre
ON MOUSE-SELECT-DBLCLICK OF fi-item IN FRAME f-parametros /* Cod.Item */
DO:
   APPLY 'f5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-consultas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-consultas w-livre
ON CHOOSE OF MENU-ITEM mi-consultas /* Consultas */
DO:
  RUN pi-consulta IN h_p-exihel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-conteudo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-conteudo w-livre
ON CHOOSE OF MENU-ITEM mi-conteudo /* Conteudo */
OR HELP OF FRAME {&FRAME-NAME}
DO:
  RUN pi-ajuda IN h_p-exihel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-imprimir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-imprimir w-livre
ON CHOOSE OF MENU-ITEM mi-imprimir /* Relat½rios */
DO:
  RUN pi-imprimir IN h_p-exihel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-programa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-programa w-livre
ON MENU-DROP OF MENU mi-programa /* Nome-do-Programa */
DO:
  run pi-disable-menu.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-sair
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-sair w-livre
ON CHOOSE OF MENU-ITEM mi-sair /* Sair */
DO:
  RUN pi-sair IN h_p-exihel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-sobre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-sobre w-livre
ON CHOOSE OF MENU-ITEM mi-sobre /* Sobre... */
DO:
  {include/sobre.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-somente-integral
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-somente-integral w-livre
ON VALUE-CHANGED OF tg-somente-integral IN FRAME f-parametros /* Somente Pedido Integral */
DO:
    IF SELF:CHECKED IN FRAME f-parametros THEN
       ASSIGN tg-ped-parc:CHECKED IN FRAME f-parametros = NO
              tg-item-parc:CHECKED IN FRAME f-parametros = NO
              tg-ped-parc:SENSITIVE IN FRAME f-parametros = NO
              tg-item-parc:SENSITIVE IN FRAME f-parametros = NO.
    ELSE
        ASSIGN tg-ped-parc:SENSITIVE IN FRAME f-parametros = YES
               tg-item-parc:SENSITIVE IN FRAME f-parametros = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-cad
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK w-livre 


/* ***************************  Main Block  *************************** */

fi-item:LOAD-MOUSE-POINTER ('image/lupa.cur') IN FRAME f-parametros.


/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

ON 'value-changed':U OF tt-ped-venda.l-selec IN BROWSE br-pedidos
DO: 
    GET CURRENT br-pedidos.

    IF tt-ped-venda.l-selec:SCREEN-VALUE IN BROWSE br-pedidos = "YES" THEN 
        tt-ped-venda.l-selec = YES.   
    ELSE
        ASSIGN tt-ped-venda.l-selec = NO.

    RUN pi-carrega-selecao-ped.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects w-livre  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE adm-current-page  AS INTEGER NO-UNDO.

  RUN get-attribute IN THIS-PROCEDURE ('Current-Page':U).
  ASSIGN adm-current-page = INTEGER(RETURN-VALUE).

  CASE adm-current-page: 

    WHEN 0 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'panel/p-exihel.w':U ,
             INPUT  FRAME f-cad:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = NAV-ICON,
                     Right-to-Left = First-On-Left':U ,
             OUTPUT h_p-exihel ).
       RUN set-position IN h_p-exihel ( 1.13 , 145.29 ) NO-ERROR.
       /* Size in UIB:  ( 1.25 , 16.00 ) */

       /* Links to SmartPanel h_p-exihel. */
       RUN add-link IN adm-broker-hdl ( h_p-exihel , 'State':U , THIS-PROCEDURE ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-exihel ,
             bt-parametros:HANDLE IN FRAME f-cad , 'BEFORE':U ).
    END. /* Page 0 */

  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available w-livre  _ADM-ROW-AVAILABLE
PROCEDURE adm-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Dispatched to this procedure when the Record-
               Source has a new row available.  This procedure
               tries to get the new row (or foriegn keys) from
               the Record-Source and process it.
  Parameters:  <none>
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.             */
  {src/adm/template/row-head.i}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI w-livre  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-livre)
  THEN DELETE WIDGET w-livre.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI w-livre  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  DISPLAY fi-color 
      WITH FRAME f-cad IN WINDOW w-livre.
  ENABLE rt-button bt-parametros bt-pedidos fi-color 
      WITH FRAME f-cad IN WINDOW w-livre.
  {&OPEN-BROWSERS-IN-QUERY-f-cad}
  DISPLAY i-orig-mercad fi-item fi-desc-item c-cod-estabel-ini c-cod-estabel-fim 
          c-tp-pedido-ini c-tp-pedido-fim d-dt-implanta-ini d-dt-implanta-fim 
          d-dt-entrega-ini d-dt-entrega-fim c-nr-pedcli-ini c-nr-pedcli-fim 
          i-cod-emitente-ini i-cod-emitente-fim i-cod-rep-ini i-cod-rep-fim 
          i-cod-cond-pag-ini i-cod-cond-pag-fim i-grp-canais-ini 
          i-grp-canais-fim c-cod-unid-neg-ini c-cod-unid-neg-fim c-estado-ini 
          c-estado-fim c-prioridade EDITOR-1 c-atendente-mestre tg-ped-parc 
          tg-item-parc tg-somente-integral 
      WITH FRAME f-parametros IN WINDOW w-livre.
  ENABLE i-orig-mercad fi-item c-cod-estabel-ini c-cod-estabel-fim 
         c-tp-pedido-ini c-tp-pedido-fim d-dt-implanta-ini d-dt-implanta-fim 
         d-dt-entrega-ini d-dt-entrega-fim c-nr-pedcli-ini c-nr-pedcli-fim 
         i-cod-emitente-ini i-cod-emitente-fim i-cod-rep-ini i-cod-rep-fim 
         i-cod-cond-pag-ini i-cod-cond-pag-fim i-grp-canais-ini 
         i-grp-canais-fim c-cod-unid-neg-ini c-cod-unid-neg-fim c-estado-ini 
         c-estado-fim c-prioridade EDITOR-1 c-atendente-mestre tg-ped-parc 
         tg-item-parc tg-somente-integral bt-carrega IMAGE-1 IMAGE-2 IMAGE-3 
         IMAGE-4 IMAGE-7 IMAGE-8 IMAGE-9 IMAGE-10 IMAGE-11 IMAGE-12 IMAGE-13 
         IMAGE-14 IMAGE-15 IMAGE-16 IMAGE-17 IMAGE-18 IMAGE-19 IMAGE-20 
         IMAGE-21 IMAGE-22 RECT-10 RECT-11 IMAGE-43 IMAGE-44 RECT-13 RECT-17 
      WITH FRAME f-parametros IN WINDOW w-livre.
  {&OPEN-BROWSERS-IN-QUERY-f-parametros}
  DISPLAY fi-selecao-ped 
      WITH FRAME f-pedidos IN WINDOW w-livre.
  ENABLE RECT-12 br-pedidos bt-marcar-todos bt-desmarcar-todos bt-marcar 
         bt-desmarcar bt-faturar br-consult-item bt-consult-pedido 
         fi-selecao-ped 
      WITH FRAME f-pedidos IN WINDOW w-livre.
  {&OPEN-BROWSERS-IN-QUERY-f-pedidos}
  VIEW w-livre.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy w-livre 
PROCEDURE local-destroy :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .
  {include/i-logfin.i}

  IF VALID-HANDLE(h-pd4000) THEN RUN pi-finalizar     IN h-pd4000.
  IF VALID-HANDLE(h-pd4000) THEN RUN destroyInterface IN h-pd4000.
  IF VALID-HANDLE(h-pd4000) THEN DELETE PROCEDURE        h-pd4000.


  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit w-livre 
PROCEDURE local-exit :
/* -----------------------------------------------------------
  Purpose:  Starts an "exit" by APPLYing CLOSE event, which starts "destroy".
  Parameters:  <none>
  Notes:    If activated, should APPLY CLOSE, *not* dispatch adm-exit.   
-------------------------------------------------------------*/
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize w-livre 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  run pi-before-initialize.

  {include/win-size.i}

  {utp/ut9000.i "ESPDP094" "1.00.00.000"}

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  VIEW FRAME f-parametros.
  HIDE FRAME f-pedidos.

  ASSIGN editor-1:SCREEN-VALUE IN FRAME f-parametros = '(OBS:Informe o Nø das prioridades separadas por ";") Ex:01;02;03;04;05;06;07;'.

  ASSIGN d-dt-implanta-ini:SCREEN-VALUE IN FRAME f-parametros = STRING(ADD-INTERVAL(TODAY, -12, "month"))
         d-dt-implanta-fim:SCREEN-VALUE IN FRAME f-parametros = STRING(TODAY)
         d-dt-entrega-ini:SCREEN-VALUE IN FRAME f-parametros  = STRING(ADD-INTERVAL(TODAY, -12, "month"))
         d-dt-entrega-fim:SCREEN-VALUE IN FRAME f-parametros  = STRING(TODAY).

  ASSIGN fi-selecao-ped:BGCOLOR IN FRAME f-pedidos = fi-color:BGCOLOR IN FRAME f-cad.

  /* Code placed here will execute AFTER standard behavior.    */

  run pi-after-initialize.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-pedidos w-livre 
PROCEDURE pi-carrega-pedidos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE de-vl-alocado     AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-vl-ipi-alocado AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-vl-st-alocado  AS DECIMAL     NO-UNDO.

DEF VAR de-vl-ipi-alocado-aux AS DEC NO-UNDO.
DEF VAR de-vl-st-alocado-aux  AS DEC NO-UNDO.

DEFINE VARIABLE c-prioridade AS CHAR EXTENT 1000 NO-UNDO.
DEFINE VARIABLE i-num-priori AS INT              NO-UNDO.
DEFINE VARIABLE l-priori-ped AS LOGICAL          NO-UNDO.

DEFINE VARIABLE l-lista-cli AS LOGICAL     NO-UNDO.
  
DEFINE VARIABLE d-ipi-trib        AS INT         NO-UNDO.

EMPTY TEMP-TABLE tt-ped-venda.
EMPTY TEMP-TABLE tt-ped-item.


RUN esp/es0018p.p (INPUT "espdp090",                       
                   INPUT 1,
                   INPUT 0,
                   INPUT "",
                   OUTPUT TABLE tt-prog-ponto).


DO ON STOP UNDO, LEAVE:
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
    RUN pi-inicializar in h-acomp (input "Buscando...").

    /* Seleciona pedidos e itens do pedido. Criar tt-ped-venda e tt-ped-item */
    //DO i-cont-itens = 1 TO NUM-ENTRIES(tt-param.prioridade,";"):

    DO i-cont-itens = 1 TO NUM-ENTRIES(tt-param.prioridade,';'):
       IF ENTRY(i-cont-itens,tt-param.prioridade,';') <> '' THEN DO:
          ASSIGN c-prioridade[i-cont-itens] = ENTRY(i-cont-itens,tt-param.prioridade,';')
                 i-num-priori = i-cont-itens.
       END.
    END.
    
    /*
    FOR EACH ped-venda NO-LOCK
       WHERE ped-venda.cod-sit-ped  <= 2
         AND ped-venda.completo
         AND ped-venda.cod-priori   <> 44
         AND ped-venda.cod-estabel  >= tt-param.cod-estabel-ini
         AND ped-venda.cod-estabel  <= tt-param.cod-estabel-fim
         AND ped-venda.nr-pedcli    >= tt-param.nr-pedcli-ini
         AND ped-venda.nr-pedcli    <= tt-param.nr-pedcli-fim
         AND ped-venda.cod-emitente >= tt-param.cod-emitente-ini
         AND ped-venda.cod-emitente <= tt-param.cod-emitente-fim
         AND ped-venda.cod-priori    = INT(ENTRY(i-cont-itens,tt-param.prioridade,";"))
         AND ped-venda.tp-pedido    >= tt-param.tp-pedido-ini
         AND ped-venda.tp-pedido    <= tt-param.tp-pedido-fim
         AND ped-venda.dt-implant   >= tt-param.dt-implanta-ini
         AND ped-venda.dt-implant   <= tt-param.dt-implanta-fim
         AND ped-venda.dt-entrega   >= tt-param.dt-entrega-ini
         AND ped-venda.dt-entrega   <= tt-param.dt-entrega-fim
         AND ped-venda.cod-cond-pag >= tt-param.cod-cond-pag-ini
         AND ped-venda.cod-cond-pag <= tt-param.cod-cond-pag-fim
         AND ped-venda.int-1        >= tt-param.grp-canais-ini
         AND ped-venda.int-1        <= tt-param.grp-canais-fim
         AND ped-venda.estado       >= tt-param.estado-ini
         AND ped-venda.estado       <= tt-param.estado-fim,
        FIRST emitente NO-LOCK 
        WHERE emitente.cod-emitente  = ped-venda.cod-emitente
          AND (emitente.ind-lib-estoq = YES 
           OR  ped-venda.cod-sit-aval = 3   
           OR  ped-venda.mo-codigo   <> 0),*/

    FOR EACH ped-venda NO-LOCK 
        WHERE ped-venda.dt-entrega  >= tt-param.dt-entrega-ini  
          AND ped-venda.dt-entrega  <= tt-param.dt-entrega-fim  
          //AND INDEX(tt-param.prioridade,STRING(ped-venda.cod-priori)) > 0
          AND ped-venda.cod-priori  <> 44
          AND ped-venda.cod-sit-ped <= 2
          AND ped-venda.cod-estabel  >= tt-param.cod-estabel-ini
          AND ped-venda.cod-estabel  <= tt-param.cod-estabel-fim
          AND ped-venda.nr-pedcli    >= tt-param.nr-pedcli-ini
          AND ped-venda.nr-pedcli    <= tt-param.nr-pedcli-fim
          AND ped-venda.dt-entrega   >= tt-param.dt-entrega-ini
          AND ped-venda.dt-entrega   <= tt-param.dt-entrega-fim
          AND ped-venda.completo,
        FIRST emitente NO-LOCK 
        WHERE emitente.cod-emitente  = ped-venda.cod-emitente
          /*AND (emitente.ind-lib-estoq = YES 
           OR  ped-venda.cod-sit-aval = 3   
           OR  ped-venda.mo-codigo   <> 0)*/ ,
        FIRST repres NO-LOCK 
        WHERE repres.cod-rep   >= tt-param.cod-rep-ini
          AND repres.cod-rep   <= tt-param.cod-rep-fim
          AND repres.nome-abrev = ped-venda.no-ab-reppri:

        RUN pi-acompanhar in h-acomp (input "Selecionando Pedido: " + string(ped-venda.nr-pedido)).
          
        IF ped-venda.cod-emitente < tt-param.cod-emitente-ini OR 
           ped-venda.cod-emitente > tt-param.cod-emitente-fim  THEN NEXT.

        IF ped-venda.tp-pedido < tt-param.tp-pedido-ini OR       
           ped-venda.tp-pedido > tt-param.tp-pedido-fim THEN NEXT.

        /*
        IF ped-venda.dt-implant < tt-param.dt-implanta-ini OR    
           ped-venda.dt-implant > tt-param.dt-implanta-fim THEN NEXT.  */
        
        IF ped-venda.cod-cond-pag < tt-param.cod-cond-pag-ini OR   
           ped-venda.cod-cond-pag > tt-param.cod-cond-pag-fim THEN NEXT.         

        IF ped-venda.int-1 < tt-param.grp-canais-ini OR 
           ped-venda.int-1 > tt-param.grp-canais-fim THEN NEXT.           

        IF ped-venda.estado < tt-param.estado-ini OR         
           ped-venda.estado > tt-param.estado-fim THEN NEXT. 
        
        //Valida se o estabelecimento est  bloqueado para faturamento
        IF CAN-FIND(tt-estabel-bloq-fat WHERE tt-estabel-bloq-fat.cod-estabel = ped-venda.cod-estabel) THEN NEXT.

        ASSIGN l-lista-cli  = NO
               l-priori-ped = NO.

        
        IF emitente.ind-lib-estoq = YES OR 
           ped-venda.cod-sit-aval = 3   OR 
           ped-venda.mo-codigo   <> 0   THEN 
           ASSIGN l-lista-cli = YES.

        IF NOT l-lista-cli THEN NEXT.

        DO i-cont-itens = 1 TO i-num-priori:
           IF ped-venda.cod-priori = INT(c-prioridade[i-cont-itens]) THEN 
              ASSIGN l-priori-ped = YES.
        END.

        
        IF NOT l-priori-ped THEN NEXT.

        
        //Chamado M2107-033 - Verificar Naturezas do Entreposto 
        FIND FIRST tt-prog-ponto WHERE tt-prog-ponto.conteudo = ped-venda.nat-operacao NO-ERROR.

        IF INT(i-orig-mercad:SCREEN-VALUE IN FRAME f-parametros) = 1 THEN DO: //ESTAB INTELBRAS
           IF AVAIL tt-prog-ponto THEN NEXT.
        END.
        ELSE DO:
           IF NOT AVAIL tt-prog-ponto THEN NEXT.
        END.

        
        FOR EACH ped-item OF ped-venda NO-LOCK
           WHERE ped-item.dt-entrega    >= tt-param.dt-entrega-ini
             AND ped-item.dt-entrega    <= tt-param.dt-entrega-fim
             AND ped-item.cod-sit-item  <> 6
             AND ped-item.cod-sit-item  <> 3,
             /*AND ped-item.cod-unid-neg  >= tt-param.cod-unid-neg-ini
             AND ped-item.cod-unid-neg  <= tt-param.cod-unid-neg-fim
             AND ped-item.cod-sit-item  <= 2*/
             /*AND ped-item.qt-log-aloca <> 0*/
            EACH ped-ent OF ped-item NO-LOCK
            BREAK BY ped-item.nr-pedcli
                  BY ped-item.nome-abrev
                  BY ped-item.nr-sequencia
                  BY ped-item.it-codigo:
            
            IF ped-item.cod-unid-neg < tt-param.cod-unid-neg-ini OR 
               ped-item.cod-unid-neg > tt-param.cod-unid-neg-fim THEN NEXT.

            IF ped-item.cod-sit-item > 2 THEN NEXT.

            IF fi-item:SCREEN-VALUE IN FRAME f-parametros <> '' THEN DO:                     
               IF ped-item.it-codigo <> fi-item:SCREEN-VALUE IN FRAME f-parametros THEN NEXT.
            END.     

            
            FIND FIRST natur-oper NO-LOCK WHERE natur-oper.nat-oper = ped-item.nat-oper NO-ERROR.

            IF AVAIL natur-oper THEN DO:
               IF natur-oper.baixa-estoq THEN DO:

                  IF NOT tt-param.somente-integral THEN DO:

                      IF ped-item.qt-log-aloca = 0 THEN NEXT.
                       
                      FIND ped-saldo WHERE
                           ped-saldo.nome-abrev  = ped-ent.nome-abrev   AND
                           ped-saldo.nr-pedcli   = ped-ent.nr-pedcli    AND
                           ped-saldo.nr-seq-item = ped-ent.nr-sequencia AND
                           ped-saldo.it-codigo   = ped-ent.it-codigo    AND
                           ped-saldo.cod-refer   = ped-ent.cod-refer    AND
                           ped-saldo.nr-entrega  = ped-ent.nr-entrega NO-LOCK NO-ERROR.
                    
                      IF NOT AVAIL ped-saldo THEN NEXT.
                       
                      /*Salva a quantidade alocada pois vai desfazer a alocacao*/
                      ASSIGN qt-alocada = ped-item.qt-log-aloca.
                  END.
               END.
               ELSE
                 ASSIGN qt-alocada = ped-item.qt-pedida - ped-item.qt-atendida.
            END.

                     
            ASSIGN l-item-total = NO.
           
            IF ped-item.qt-pedida - ped-item.qt-atendida = ped-item.qt-log-aloca THEN
                ASSIGN l-item-total = YES.
           
           /* IF NOT CAN-FIND (FIRST b-ped-item OF ped-venda
                             WHERE b-ped-item.qt-pedida - ped-item.qt-atendida <> ped-item.qt-log-aloca
                               AND b-ped-item.cod-sit-item  <= 2) THEN
                ASSIGN l-pedido-total = YES. */

            IF NOT tt-param.somente-integral THEN DO:
                IF  NOT tt-param.ped-parc 
                AND l-item-total THEN
                    NEXT.
           
                IF NOT tt-param.item-parc 
                AND NOT l-item-total THEN
                    NEXT.
            END.
            ELSE DO:
               /* IF  tt-param.somente-integral
                AND NOT l-pedido-total THEN
                    NEXT.  */
                IF tt-param.somente-integral THEN DO:
                    IF FIRST-OF(ped-item.nr-pedcli) THEN DO:
                       ASSIGN l-pedido-total = YES.
                       FOR EACH b-ped-item OF ped-venda
                          WHERE b-ped-item.cod-sit-item <> 6 //nao lista cancelados
                          /*WHERE b-ped-item.qt-log-aloca > 0*/ NO-LOCK:
                     
                           IF b-ped-item.cod-sit-item = 2 OR 
                              b-ped-item.qt-pedida <> b-ped-item.qt-log-aloca THEN //atendido parcial ou alocacao diferente da qtde pedida
                               ASSIGN l-pedido-total = NO.
                       END.
                    END.
                    IF NOT l-pedido-total THEN NEXT.
                END.
            END.
            
            IF NOT CAN-FIND(FIRST tt-ped-venda
                            WHERE tt-ped-venda.nr-pedido = ped-venda.nr-pedido) THEN 
            DO: 
                CREATE tt-ped-venda.
                BUFFER-COPY ped-venda TO tt-ped-venda.
            
                FIND FIRST cond-pagto NO-LOCK
                      WHERE cond-pagto.cod-cond-pag = ped-venda.cod-cond-pag NO-ERROR.
                
                 IF AVAIL cond-pagto THEN
                    ASSIGN tt-ped-venda.des-cond-pag = cond-pagto.descricao
                           tt-ped-venda.num-parcelas = cond-pagto.num-parcelas.
            END.
            
            CREATE tt-ped-item.
            BUFFER-COPY ped-item TO tt-ped-item.
        END.
    END.
    //END.
END.


FOR EACH tt-ped-venda:

    FOR EACH ped-item NO-LOCK 
        WHERE ped-item.nome-abrev = tt-ped-venda.nome-abrev
          AND ped-item.nr-pedcli  = tt-ped-venda.nr-pedcli
          AND ped-item.cod-sit-item  < 3,
        FIRST ITEM OF ped-item NO-LOCK
        BREAK BY ped-item.nome-abrev
              BY ped-item.nr-pedcli
              BY ped-item.nr-sequencia
              BY ped-item.it-codigo:

        RUN pi-acompanhar in h-acomp (input "Calc Vl.Alocado: " + string(tt-ped-venda.nr-pedido) + ' - ' + ped-item.it-codigo).

        IF FIRST-OF(ped-item.nr-pedcli) THEN
           ASSIGN de-vl-alocado         = 0
                  de-vl-ipi-alocado     = 0
                  de-vl-st-alocado      = 0
                  de-vl-ipi-alocado-aux = 0   
                  de-vl-st-alocado-aux  = 0.  

        FIND FIRST natur-oper NO-LOCK WHERE natur-oper.nat-operacao = ped-item.nat-operacao NO-ERROR.

        ASSIGN d-ipi-trib = 0.
        
        IF AVAIL natur-oper THEN DO:
        
           assign d-ipi-trib = if natur-oper.cd-trib-ipi = 1
                                  then if  item.cd-trib-ipi = 1
                                       or  item.cd-trib-ipi = 4
                                       then 1
                                       else item.cd-trib-ipi
                                  else if  natur-oper.cd-trib-ipi = 2
                                       or  natur-oper.cd-trib-ipi = 3
                                       then natur-oper.cd-trib-ipi
                                       else item.cd-trib-ipi.


           IF  ped-item.qt-log-aloc <> 0 THEN DO:

               IF d-ipi-trib = 1 THEN
                  ASSIGN de-vl-ipi-alocado      = de-vl-ipi-alocado + ROUND((ped-item.qt-log-aloc * ped-item.vl-preuni * ped-item.aliquota-ipi / 100),2)
                         de-vl-ipi-alocado-aux  = de-vl-ipi-alocado-aux +  (ped-item.qt-log-aloc * ped-item.vl-preuni * ped-item.aliquota-ipi / 100). 
               
               IF natur-oper.subs-trib THEN
                  ASSIGN de-vl-st-alocado = de-vl-st-alocado + ROUND(((ped-item.vl-tot-it - ped-item.vl-liq-it -
                                           (ped-item.qt-pedida * ped-item.vl-preuni) * (ped-item.aliquota-ipi / 100)) / ped-item.qt-pedida) * ped-item.qt-log-aloc,2)
                         de-vl-st-alocado-aux = de-vl-st-alocado-aux + ((ped-item.vl-tot-it - ped-item.vl-liq-it -
                                           (ped-item.qt-pedida * ped-item.vl-preuni) * (ped-item.aliquota-ipi / 100)) / ped-item.qt-pedida) * ped-item.qt-log-aloc.
                                                                                                    
               ASSIGN de-vl-alocado = de-vl-alocado + (ped-item.qt-log-aloc * ped-item.vl-preuni).
           END.
        END.
    END.
    
    IF (de-vl-alocado + de-vl-ipi-alocado + de-vl-st-alocado) < tt-ped-venda.vl-liq-abe THEN
       ASSIGN de-vl-alocado = de-vl-alocado + de-vl-ipi-alocado-aux + de-vl-st-alocado-aux.
    ELSE
      ASSIGN de-vl-alocado = de-vl-alocado + de-vl-ipi-alocado + de-vl-st-alocado.

    

    ASSIGN tt-ped-venda.vl-alocado = de-vl-alocado
           tt-ped-venda.vl-parcela = tt-ped-venda.vl-alocado / tt-ped-venda.num-parcelas.

    ASSIGN tt-ped-venda.vl-falta-alocar = tt-ped-venda.vl-liq-abe - tt-ped-venda.vl-alocado.

    FIND FIRST atendente WHERE atendente.cd-oper = int(tt-ped-venda.tp-pedido) NO-LOCK NO-ERROR.

    IF AVAIL atendente THEN
    DO:
        FIND FIRST minimos-faturamento WHERE minimos-faturamento.oper-mestre = atendente.oper-mestre NO-LOCK NO-ERROR.
    
        // Valor da parcela abaixo de minimo
        IF AVAIL minimos-faturamento THEN
        DO:
           IF tt-ped-venda.vl-parcela < minimos-faturamento.vl-parc-minima THEN 
              ASSIGN tt-ped-venda.abaixo-parc-min = YES.
        END.
    END.



END.

RUN pi-finalizar IN h-acomp.


{&OPEN-QUERY-br-pedidos}


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-selecao-ped w-livre 
PROCEDURE pi-carrega-selecao-ped :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

ASSIGN i-cont-sel = 0.

FOR EACH b01-tt-ped-venda WHERE b01-tt-ped-venda.l-selec:
    ASSIGN i-cont-sel = i-cont-sel + 1.
END.

ASSIGN fi-selecao-ped:SCREEN-VALUE IN FRAME f-pedidos = STRING(i-cont-sel).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-tt-param w-livre 
PROCEDURE pi-carrega-tt-param :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
EMPTY TEMP-TABLE tt-param.

create tt-param.
assign tt-param.usuario         = c-seg-usuario
       tt-param.data-exec       = today
       tt-param.hora-exec       = time
       tt-param.cod-estabel-ini  = INPUT FRAME f-parametros c-cod-estabel-ini 
       tt-param.cod-estabel-fim  = INPUT FRAME f-parametros c-cod-estabel-fim 
       tt-param.tp-pedido-ini    = INPUT FRAME f-parametros c-tp-pedido-ini   
       tt-param.tp-pedido-fim    = INPUT FRAME f-parametros c-tp-pedido-fim   
       tt-param.dt-implanta-ini  = INPUT FRAME f-parametros d-dt-implanta-ini 
       tt-param.dt-implanta-fim  = INPUT FRAME f-parametros d-dt-implanta-fim 
       tt-param.dt-entrega-ini   = INPUT FRAME f-parametros d-dt-entrega-ini  
       tt-param.dt-entrega-fim   = INPUT FRAME f-parametros d-dt-entrega-fim  
       tt-param.nr-pedcli-ini    = INPUT FRAME f-parametros c-nr-pedcli-ini   
       tt-param.nr-pedcli-fim    = INPUT FRAME f-parametros c-nr-pedcli-fim   
       tt-param.cod-emitente-ini = INPUT FRAME f-parametros i-cod-emitente-ini
       tt-param.cod-emitente-fim = INPUT FRAME f-parametros i-cod-emitente-fim
       //tt-param.no-ab-reppri-ini = INPUT FRAME f-parametros c-no-ab-reppri-ini
       //tt-param.no-ab-reppri-fim = INPUT FRAME f-parametros c-no-ab-reppri-fim
       tt-param.cod-rep-ini     = input frame f-parametros i-cod-rep-ini
       tt-param.cod-rep-fim     = input frame f-parametros i-cod-rep-fim

       tt-param.cod-cond-pag-ini = INPUT FRAME f-parametros i-cod-cond-pag-ini
       tt-param.cod-cond-pag-fim = INPUT FRAME f-parametros i-cod-cond-pag-fim
       tt-param.grp-canais-ini   = INPUT FRAME f-parametros i-grp-canais-ini  
       tt-param.grp-canais-fim   = INPUT FRAME f-parametros i-grp-canais-fim  
       tt-param.cod-unid-neg-ini = INPUT FRAME f-parametros c-cod-unid-neg-ini
       tt-param.cod-unid-neg-fim = INPUT FRAME f-parametros c-cod-unid-neg-fim
       tt-param.estado-ini       = INPUT FRAME f-parametros c-estado-ini
       tt-param.estado-fim       = INPUT FRAME f-parametros c-estado-fim
       tt-param.prioridade       = INPUT FRAME f-parametros c-prioridade      
       tt-param.atendente-mestre = INPUT FRAME f-parametros c-atendente-mestre
       tt-param.ped-parc         = tg-ped-parc        :CHECKED IN FRAME f-parametros
       tt-param.item-parc        = tg-item-parc       :CHECKED IN FRAME f-parametros
       tt-param.somente-integral = tg-somente-integral:CHECKED IN FRAME f-parametros.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-limpa-dados w-livre 
PROCEDURE pi-limpa-dados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FOR EACH tt-ped-venda
   WHERE tt-ped-venda.l-selec = YES:

    FOR EACH tt-ped-item OF tt-ped-venda:
        DELETE tt-ped-item.
    END.

    DELETE tt-ped-venda.
END.

{&OPEN-QUERY-br-pedidos}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-bloqueio-fat w-livre 
PROCEDURE pi-valida-bloqueio-fat :
DEFINE VAR da-data       AS DATETIME.
DEFINE VAR da-data-atual AS DATETIME.
    
DEFINE INPUT  PARAM p-cod-estabel AS CHAR.
DEFINE INPUT  PARAM p-usuario     AS CHAR.
DEFINE OUTPUT PARAM p-mensagem    AS CHAR.


FIND FIRST bloqueio-fat NO-LOCK NO-ERROR.

IF AVAIL bloqueio-fat THEN DO:
    ASSIGN da-data       = DATETIME(bloqueio-fat.dt-bloq-espdp006)
           da-data-atual = DATETIME(TODAY, MTIME).  

    IF da-data-atual > da-data THEN DO:
        IF  LOOKUP(v_cod_usuar_corren,bloqueio-fat.usua-espdp006) = 0 
        AND LOOKUP(p-cod-estabel,bloqueio-fat.estab-espdp006)     = 0 THEN DO:

            ASSIGN p-mensagem = "Bloqueado para Faturamento a partir de " + string(da-data) + " Horas ".
            RETURN "NOK".
        END.
    END.
END. /* IF AVAIL bloqueio-fat THEN DO: */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records w-livre  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "tt-ped-venda"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed w-livre 
PROCEDURE state-changed :
/*:T -----------------------------------------------------------
  Purpose:     Manuseia trocas de estado dos SmartObjects
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.

  run pi-trata-state (p-issuer-hdl, p-state).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnCondPagto w-livre 
FUNCTION fnCondPagto RETURNS CHARACTER
  ( i-cod-cond-pag AS INT /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  FIND FIRST cond-pagto NO-LOCK
       WHERE cond-pagto.cod-cond-pag = i-cod-cond-pag NO-ERROR.

  IF AVAIL cond-pagto THEN
      RETURN cond-pagto.descricao.   /* Function return value. */
  ELSE
      RETURN "".   /* Function return value. */


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnSitPed w-livre 
FUNCTION fnSitPed RETURNS CHARACTER
  ( i-cod-sit-ped AS INT /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  
  RETURN {diinc/i03di149.i 4 i-cod-sit-ped}.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

