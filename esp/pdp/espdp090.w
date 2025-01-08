&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME w-relat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS w-relat 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i espdp090 2.00.00.000}

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i <programa> <m¢dulo>}
&ENDIF

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/*:T Preprocessadores do Template de Relat¢rio                            */
/*:T Obs: Retirar o valor do preprocessador para as p ginas que nÆo existirem  */

&GLOBAL-DEFINE PGSEL f-pg-sel
&GLOBAL-DEFINE PGCLA 
&GLOBAL-DEFINE PGPAR f-pg-par
&GLOBAL-DEFINE PGDIG f-pg-dig
&GLOBAL-DEFINE PGIMP f-pg-imp

&GLOBAL-DEFINE RTF   NO
  
/* Parameters Definitions ---                                           */

/* Temporary Table Definitions ---                                      */

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
    FIELD no-ab-reppri-ini LIKE ped-venda.no-ab-reppri
    FIELD no-ab-reppri-fim LIKE ped-venda.no-ab-reppri
    FIELD cod-cond-pag-ini LIKE ped-venda.cod-cond-pag
    FIELD cod-cond-pag-fim LIKE ped-venda.cod-cond-pag
    FIELD grp-canais-ini   LIKE int-ped-venda2.int-1
    FIELD grp-canais-fim   LIKE int-ped-venda2.int-1
    FIELD cod-unid-neg-ini LIKE ped-item.cod-unid-neg
    FIELD cod-unid-neg-fim LIKE ped-item.cod-unid-neg
    FIELD prioridade       AS CHAR
    FIELD atendente-mestre AS CHAR
    FIELD deposito         AS CHAR
    FIELD it-codigo        AS CHAR
    FIELD avaliado         AS LOG
    FIELD aprovado         AS LOG
    FIELD nao-aprovado     AS LOG
    FIELD pend-info        AS LOG
    FIELD nao-avaliado     AS LOG
    FIELD ped-aberto       AS LOG
    FIELD ped-atend-parc   AS LOG
    FIELD it-aberto        AS LOG
    FIELD it-atend-parc    AS LOG
    FIELD acao             AS INT
    FIELD estado-ini       AS CHAR
    FIELD estado-fim       AS CHAR
    FIELD permite          AS LOG
    FIELD origem-mercad    AS INT
    FIELD tg-automatico    AS LOG
    FIELD desaloca-plan    AS LOG.

define temp-table tt-digita no-undo
    FIELD nr-pedido    LIKE ped-venda.nr-pedido
    FIELD nr-sequencia LIKE ped-item.nr-sequencia
    field it-codigo    LIKE ped-item.it-codigo
    index id it-codigo.

define buffer b-tt-digita for tt-digita.

/* Transfer Definitions */

def var raw-param        as raw no-undo.

def temp-table tt-raw-digita
   field raw-digita      as raw.
                    
/* Local Variable Definitions ---                                       */

def var l-ok               as logical no-undo.
def var c-arq-digita       as char    no-undo.
def var c-terminal         as char    no-undo.
def var c-rtf              as char    no-undo.
def var c-modelo-default   as char    no-undo.

/*15/02/2005 - tech1007 - Variavel definida para tratar se o programa est  rodando no WebEnabler*/
DEFINE SHARED VARIABLE hWenController AS HANDLE NO-UNDO.

def var c-nome-abrev as char no-undo.
def var c-pedido     as char no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE w-relat
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-pg-dig
&Scoped-define BROWSE-NAME br-digita

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-digita

/* Definitions for BROWSE br-digita                                     */
&Scoped-define FIELDS-IN-QUERY-br-digita tt-digita.nr-pedido tt-digita.nr-sequencia tt-digita.it-codigo   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-digita tt-digita.nr-pedido tt-digita.nr-sequencia tt-digita.it-codigo   
&Scoped-define ENABLED-TABLES-IN-QUERY-br-digita tt-digita
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br-digita tt-digita
&Scoped-define SELF-NAME br-digita
&Scoped-define QUERY-STRING-br-digita FOR EACH tt-digita
&Scoped-define OPEN-QUERY-br-digita OPEN QUERY br-digita FOR EACH tt-digita.
&Scoped-define TABLES-IN-QUERY-br-digita tt-digita
&Scoped-define FIRST-TABLE-IN-QUERY-br-digita tt-digita


/* Definitions for FRAME f-pg-dig                                       */
&Scoped-define OPEN-BROWSERS-IN-QUERY-f-pg-dig ~
    ~{&OPEN-QUERY-br-digita}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br-digita bt-inserir bt-recuperar 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR w-relat AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-alterar 
     LABEL "Alterar" 
     SIZE 15 BY 1.

DEFINE BUTTON bt-inserir 
     LABEL "Inserir" 
     SIZE 15 BY 1.

DEFINE BUTTON bt-recuperar 
     LABEL "Recuperar" 
     SIZE 15 BY 1.

DEFINE BUTTON bt-retirar 
     LABEL "Retirar" 
     SIZE 15 BY 1.

DEFINE BUTTON bt-salvar 
     LABEL "Salvar" 
     SIZE 15 BY 1.

DEFINE BUTTON bt-arquivo 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON bt-config-impr 
     IMAGE-UP FILE "image\im-cfprt":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE VARIABLE c-arquivo AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 256
     SIZE 40 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE text-destino AS CHARACTER FORMAT "X(256)":U INITIAL " Destino" 
      VIEW-AS TEXT 
     SIZE 8.57 BY .63 NO-UNDO.

DEFINE VARIABLE text-modo AS CHARACTER FORMAT "X(256)":U INITIAL "Execu‡Æo" 
      VIEW-AS TEXT 
     SIZE 10.86 BY .63 NO-UNDO.

DEFINE VARIABLE rs-destino AS INTEGER INITIAL 2 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Impressora", 1,
"Arquivo", 2,
"Terminal", 3
     SIZE 44 BY 1.08 NO-UNDO.

DEFINE VARIABLE rs-execucao AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "On-Line", 1,
"Batch", 2
     SIZE 27.72 BY .92 NO-UNDO.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.29 BY 2.79.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.29 BY 1.71.

DEFINE VARIABLE c-atendente-mestre AS CHARACTER FORMAT "X(256)":U 
     LABEL "Atendente Mestre" 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE VARIABLE c-deposito AS CHARACTER FORMAT "X(256)":U INITIAL "WEX" 
     LABEL "Dep¢sito" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE c-it-codigo AS CHARACTER FORMAT "X(16)":U 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE c-prioridade AS CHARACTER FORMAT "X(256)":U 
     LABEL "Prioridade" 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE VARIABLE rs-acao AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Mant‚m", 1,
"Aloca", 2,
"Desaloca", 3
     SIZE 32 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 21 BY 4.75.

DEFINE RECTANGLE RECT-14
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 21 BY 4.25.

DEFINE RECTANGLE RECT-15
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 35 BY 4.96.

DEFINE VARIABLE tg-aprovado AS LOGICAL INITIAL yes 
     LABEL "Aprovado" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83 NO-UNDO.

DEFINE VARIABLE tg-avaliado AS LOGICAL INITIAL yes 
     LABEL "Avaliado" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83 NO-UNDO.

DEFINE VARIABLE tg-desaloca-plan AS LOGICAL INITIAL no 
     LABEL "Desaloca conforme planilha" 
     VIEW-AS TOGGLE-BOX
     SIZE 33 BY .83 NO-UNDO.

DEFINE VARIABLE tg-it-aberto AS LOGICAL INITIAL yes 
     LABEL "Item Aberto" 
     VIEW-AS TOGGLE-BOX
     SIZE 14.14 BY .83 NO-UNDO.

DEFINE VARIABLE tg-it-atend-parc AS LOGICAL INITIAL yes 
     LABEL "Item Atendido Parcial" 
     VIEW-AS TOGGLE-BOX
     SIZE 17.57 BY .83 NO-UNDO.

DEFINE VARIABLE tg-nao-aprovado AS LOGICAL INITIAL yes 
     LABEL "NÆo Aprovado" 
     VIEW-AS TOGGLE-BOX
     SIZE 14.14 BY .83 NO-UNDO.

DEFINE VARIABLE tg-nao-avaliado AS LOGICAL INITIAL yes 
     LABEL "NÆo Avaliado" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83 NO-UNDO.

DEFINE VARIABLE tg-ped-aberto AS LOGICAL INITIAL yes 
     LABEL "Pedido Aberto" 
     VIEW-AS TOGGLE-BOX
     SIZE 13 BY .83 NO-UNDO.

DEFINE VARIABLE tg-ped-atend-parc AS LOGICAL INITIAL yes 
     LABEL "Pedido Atendido Parcial" 
     VIEW-AS TOGGLE-BOX
     SIZE 18.57 BY .83 NO-UNDO.

DEFINE VARIABLE tg-pend-info AS LOGICAL INITIAL yes 
     LABEL "Pendente Inform." 
     VIEW-AS TOGGLE-BOX
     SIZE 16.14 BY .83 NO-UNDO.

DEFINE VARIABLE tg-permite AS LOGICAL INITIAL no 
     LABEL "Permite aloca‡Æo parcial do item" 
     VIEW-AS TOGGLE-BOX
     SIZE 33 BY .83 NO-UNDO.

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

DEFINE VARIABLE c-no-ab-reppri-fim AS CHARACTER FORMAT "X(12)":U INITIAL "ZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-no-ab-reppri-ini AS CHARACTER FORMAT "X(12)":U 
     LABEL "Repres." 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-nr-pedcli-fim AS CHARACTER FORMAT "X(12)":U INITIAL "ZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE c-nr-pedcli-ini AS CHARACTER FORMAT "X(12)":U 
     LABEL "Nr. Pedido" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE c-tp-pedido-fim AS CHARACTER FORMAT "X(2)":U INITIAL "ZZ" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE VARIABLE c-tp-pedido-ini AS CHARACTER FORMAT "X(2)":U 
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

DEFINE IMAGE IMAGE-23
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-24
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-3
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-4
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
          "Estab Intelbras", 1,
"Deposito Entreposto", 2
     SIZE 38 BY .79 NO-UNDO.

DEFINE RECTANGLE RECT-17
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 75.57 BY 1.58.

DEFINE RECTANGLE RECT-18
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 75.57 BY 8.5.

DEFINE VARIABLE tg-automatico AS LOGICAL INITIAL no 
     LABEL "Alocacao Automatica" 
     VIEW-AS TOGGLE-BOX
     SIZE 19 BY .83 NO-UNDO.

DEFINE BUTTON bt-ajuda 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-cancelar AUTO-END-KEY 
     LABEL "Fechar" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-executar 
     LABEL "Executar" 
     SIZE 10 BY 1.

DEFINE IMAGE im-pg-dig
     FILENAME "image\im-fldup":U
     SIZE 15.72 BY 1.21.

DEFINE IMAGE im-pg-imp
     FILENAME "image\im-fldup":U
     SIZE 15.72 BY 1.21.

DEFINE IMAGE im-pg-par
     FILENAME "image\im-fldup":U
     SIZE 15.72 BY 1.21.

DEFINE IMAGE im-pg-sel
     FILENAME "image\im-fldup":U
     SIZE 15.72 BY 1.21.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 79 BY 1.42
     BGCOLOR 7 .

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 0    
     SIZE 78.72 BY .13
     BGCOLOR 7 .

DEFINE RECTANGLE rt-folder
     EDGE-PIXELS 1 GRAPHIC-EDGE  NO-FILL   
     SIZE 79 BY 11
     FGCOLOR 0 .

DEFINE RECTANGLE rt-folder-left
     EDGE-PIXELS 0    
     SIZE .43 BY 11
     BGCOLOR 15 .

DEFINE RECTANGLE rt-folder-right
     EDGE-PIXELS 0    
     SIZE .43 BY 10
     BGCOLOR 7 .

DEFINE RECTANGLE rt-folder-top
     EDGE-PIXELS 0    
     SIZE 78.72 BY .13
     BGCOLOR 15 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-digita FOR 
      tt-digita SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-digita
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-digita w-relat _FREEFORM
  QUERY br-digita DISPLAY
      tt-digita.nr-pedido 
tt-digita.nr-sequencia
tt-digita.it-codigo
ENABLE
tt-digita.nr-pedido
tt-digita.nr-sequencia
tt-digita.it-codigo
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS SIZE 76.57 BY 9
         BGCOLOR 15 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-pg-imp
     rs-destino AT ROW 1.63 COL 3.29 HELP
          "Destino de ImpressÆo do Relat¢rio" NO-LABEL
     bt-arquivo AT ROW 2.71 COL 43.29 HELP
          "Escolha do nome do arquivo"
     bt-config-impr AT ROW 2.71 COL 43.29 HELP
          "Configura‡Æo da impressora"
     c-arquivo AT ROW 2.75 COL 3.29 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL
     rs-execucao AT ROW 8.88 COL 2.86 HELP
          "Modo de Execu‡Æo" NO-LABEL
     text-destino AT ROW 1.04 COL 3.86 NO-LABEL
     text-modo AT ROW 8.13 COL 1.14 COLON-ALIGNED NO-LABEL
     RECT-7 AT ROW 1.33 COL 2.14
     RECT-9 AT ROW 8.33 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 3
         SIZE 73.72 BY 10.5 WIDGET-ID 100.

DEFINE FRAME f-pg-dig
     br-digita AT ROW 1 COL 1
     bt-inserir AT ROW 10 COL 1
     bt-alterar AT ROW 10 COL 16
     bt-retirar AT ROW 10 COL 31
     bt-salvar AT ROW 10 COL 46
     bt-recuperar AT ROW 10 COL 61
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 3.31
         SIZE 76.86 BY 10.15 WIDGET-ID 100.

DEFINE FRAME f-pg-sel
     i-orig-mercad AT ROW 1.88 COL 13.86 NO-LABEL WIDGET-ID 124
     c-cod-estabel-ini AT ROW 3.25 COL 15 COLON-ALIGNED
     c-cod-estabel-fim AT ROW 3.25 COL 29.29 COLON-ALIGNED NO-LABEL
     i-grp-canais-ini AT ROW 3.25 COL 47 COLON-ALIGNED WIDGET-ID 68
     i-grp-canais-fim AT ROW 3.25 COL 64.29 COLON-ALIGNED NO-LABEL WIDGET-ID 66
     c-cod-unid-neg-fim AT ROW 4.21 COL 64.29 COLON-ALIGNED NO-LABEL WIDGET-ID 74
     c-tp-pedido-ini AT ROW 4.25 COL 18 COLON-ALIGNED WIDGET-ID 4
     c-tp-pedido-fim AT ROW 4.25 COL 29.29 COLON-ALIGNED NO-LABEL WIDGET-ID 2
     c-cod-unid-neg-ini AT ROW 4.25 COL 53 COLON-ALIGNED WIDGET-ID 76
     c-estado-ini AT ROW 5.21 COL 53 COLON-ALIGNED WIDGET-ID 84
     c-estado-fim AT ROW 5.21 COL 64.29 COLON-ALIGNED NO-LABEL WIDGET-ID 82
     d-dt-implanta-ini AT ROW 5.25 COL 11 COLON-ALIGNED WIDGET-ID 20
     d-dt-implanta-fim AT ROW 5.25 COL 29.29 COLON-ALIGNED NO-LABEL WIDGET-ID 18
     d-dt-entrega-ini AT ROW 6.25 COL 11 COLON-ALIGNED WIDGET-ID 28
     d-dt-entrega-fim AT ROW 6.25 COL 29.29 COLON-ALIGNED NO-LABEL WIDGET-ID 26
     tg-automatico AT ROW 6.71 COL 55 WIDGET-ID 136
     c-nr-pedcli-ini AT ROW 7.25 COL 9 COLON-ALIGNED WIDGET-ID 36
     c-nr-pedcli-fim AT ROW 7.25 COL 29.29 COLON-ALIGNED NO-LABEL WIDGET-ID 34
     i-cod-emitente-ini AT ROW 8.25 COL 12 COLON-ALIGNED WIDGET-ID 44
     i-cod-emitente-fim AT ROW 8.25 COL 29.29 COLON-ALIGNED NO-LABEL WIDGET-ID 42
     c-no-ab-reppri-ini AT ROW 9.25 COL 8 COLON-ALIGNED WIDGET-ID 52
     c-no-ab-reppri-fim AT ROW 9.25 COL 29.29 COLON-ALIGNED NO-LABEL WIDGET-ID 50
     i-cod-cond-pag-ini AT ROW 10.25 COL 17 COLON-ALIGNED WIDGET-ID 60
     i-cod-cond-pag-fim AT ROW 10.25 COL 29.29 COLON-ALIGNED NO-LABEL WIDGET-ID 58
     "Origem de Mercadoria" VIEW-AS TEXT
          SIZE 16 BY .54 AT ROW 1.08 COL 3.72 WIDGET-ID 134
     IMAGE-1 AT ROW 3.25 COL 23.86
     IMAGE-2 AT ROW 3.25 COL 28.43
     IMAGE-3 AT ROW 4.25 COL 23.86 WIDGET-ID 6
     IMAGE-4 AT ROW 4.25 COL 28.43 WIDGET-ID 8
     IMAGE-7 AT ROW 5.25 COL 23.86 WIDGET-ID 22
     IMAGE-8 AT ROW 5.25 COL 28.43 WIDGET-ID 24
     IMAGE-9 AT ROW 6.25 COL 23.86 WIDGET-ID 30
     IMAGE-10 AT ROW 6.25 COL 28.43 WIDGET-ID 32
     IMAGE-11 AT ROW 7.25 COL 23.86 WIDGET-ID 40
     IMAGE-12 AT ROW 7.25 COL 28.43 WIDGET-ID 38
     IMAGE-13 AT ROW 8.25 COL 23.86 WIDGET-ID 46
     IMAGE-14 AT ROW 8.25 COL 28.43 WIDGET-ID 48
     IMAGE-15 AT ROW 9.25 COL 23.86 WIDGET-ID 54
     IMAGE-16 AT ROW 9.25 COL 28.43 WIDGET-ID 56
     IMAGE-17 AT ROW 10.25 COL 23.86 WIDGET-ID 62
     IMAGE-18 AT ROW 10.25 COL 28.43 WIDGET-ID 64
     IMAGE-19 AT ROW 3.25 COL 58.86 WIDGET-ID 70
     IMAGE-20 AT ROW 3.25 COL 63.43 WIDGET-ID 72
     IMAGE-21 AT ROW 4.25 COL 58.86 WIDGET-ID 78
     IMAGE-22 AT ROW 4.21 COL 63.43 WIDGET-ID 80
     IMAGE-23 AT ROW 5.21 COL 58.86 WIDGET-ID 86
     IMAGE-24 AT ROW 5.21 COL 63.43 WIDGET-ID 88
     RECT-17 AT ROW 1.33 COL 1.43 WIDGET-ID 130
     RECT-18 AT ROW 3 COL 1.43 WIDGET-ID 132
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 2.83
         SIZE 76.86 BY 10.54
         FONT 7 WIDGET-ID 100.

DEFINE FRAME f-relat
     bt-executar AT ROW 14.92 COL 3 HELP
          "Dispara a execu‡Æo do relat¢rio"
     bt-cancelar AT ROW 14.92 COL 14 HELP
          "Fechar"
     bt-ajuda AT ROW 14.92 COL 70 HELP
          "Ajuda"
     RECT-1 AT ROW 14.67 COL 2
     RECT-6 AT ROW 13.75 COL 2
     rt-folder-top AT ROW 2.54 COL 2.14
     rt-folder-right AT ROW 2.67 COL 80.43
     rt-folder-left AT ROW 2.54 COL 2.14
     rt-folder AT ROW 2.5 COL 2
     im-pg-dig AT ROW 1.5 COL 33.57
     im-pg-imp AT ROW 1.5 COL 49.29
     im-pg-sel AT ROW 1.5 COL 2.14
     im-pg-par AT ROW 1.5 COL 17.86 WIDGET-ID 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 81 BY 15.25
         DEFAULT-BUTTON bt-executar WIDGET-ID 100.

DEFINE FRAME f-pg-par
     c-prioridade AT ROW 1.25 COL 46 COLON-ALIGNED WIDGET-ID 82
     tg-avaliado AT ROW 1.96 COL 7.43 WIDGET-ID 90
     c-atendente-mestre AT ROW 2.25 COL 46 COLON-ALIGNED WIDGET-ID 84
     tg-aprovado AT ROW 2.71 COL 7.43 WIDGET-ID 92
     c-deposito AT ROW 3.25 COL 59 COLON-ALIGNED WIDGET-ID 86
     tg-nao-aprovado AT ROW 3.46 COL 7.43 WIDGET-ID 94
     tg-pend-info AT ROW 4.21 COL 7.43 WIDGET-ID 96
     c-it-codigo AT ROW 4.25 COL 55 COLON-ALIGNED WIDGET-ID 88
     tg-nao-avaliado AT ROW 4.96 COL 7.43 WIDGET-ID 98
     rs-acao AT ROW 6.71 COL 33 NO-LABEL WIDGET-ID 116
     tg-ped-aberto AT ROW 7 COL 7 WIDGET-ID 110
     tg-ped-atend-parc AT ROW 7.75 COL 7 WIDGET-ID 108
     tg-permite AT ROW 7.83 COL 33 WIDGET-ID 124
     tg-it-aberto AT ROW 8.5 COL 7 WIDGET-ID 112
     tg-desaloca-plan AT ROW 9 COL 33 WIDGET-ID 126
     tg-it-atend-parc AT ROW 9.25 COL 7 WIDGET-ID 114
     "A‡Æo:" VIEW-AS TEXT
          SIZE 5 BY .54 AT ROW 6 COL 33 WIDGET-ID 122
     "Situa‡Æo Cr‚dito:" VIEW-AS TEXT
          SIZE 12 BY .54 AT ROW 1.21 COL 8 WIDGET-ID 100
     "Status Pedidos e Itens:" VIEW-AS TEXT
          SIZE 16 BY .54 AT ROW 6.25 COL 6 WIDGET-ID 106
     RECT-13 AT ROW 1.46 COL 5.14 WIDGET-ID 102
     RECT-14 AT ROW 6.5 COL 5 WIDGET-ID 104
     RECT-15 AT ROW 5.75 COL 31.86 WIDGET-ID 120
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 3
         SIZE 75 BY 10
         FONT 7 WIDGET-ID 200.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: w-relat
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW w-relat ASSIGN
         HIDDEN             = YES
         TITLE              = "<Title>"
         HEIGHT             = 15.25
         WIDTH              = 81.72
         MAX-HEIGHT         = 23.71
         MAX-WIDTH          = 156.72
         VIRTUAL-HEIGHT     = 23.71
         VIRTUAL-WIDTH      = 156.72
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB w-relat 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{include/w-relat.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW w-relat
  VISIBLE,,RUN-PERSISTENT                                               */
/* REPARENT FRAME */
ASSIGN FRAME f-pg-par:FRAME = FRAME f-relat:HANDLE.

/* SETTINGS FOR FRAME f-pg-dig
   FRAME-NAME                                                           */
/* BROWSE-TAB br-digita 1 f-pg-dig */
/* SETTINGS FOR BUTTON bt-alterar IN FRAME f-pg-dig
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON bt-retirar IN FRAME f-pg-dig
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON bt-salvar IN FRAME f-pg-dig
   NO-ENABLE                                                            */
/* SETTINGS FOR FRAME f-pg-imp
                                                                        */
/* SETTINGS FOR FILL-IN text-destino IN FRAME f-pg-imp
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
ASSIGN 
       text-destino:PRIVATE-DATA IN FRAME f-pg-imp     = 
                "Destino".

/* SETTINGS FOR FILL-IN text-modo IN FRAME f-pg-imp
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       text-modo:PRIVATE-DATA IN FRAME f-pg-imp     = 
                "Execu‡Æo".

/* SETTINGS FOR FRAME f-pg-par
                                                                        */
/* SETTINGS FOR FRAME f-pg-sel
                                                                        */
/* SETTINGS FOR FRAME f-relat
                                                                        */
/* SETTINGS FOR RECTANGLE RECT-1 IN FRAME f-relat
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE RECT-6 IN FRAME f-relat
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rt-folder IN FRAME f-relat
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rt-folder-left IN FRAME f-relat
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rt-folder-right IN FRAME f-relat
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rt-folder-top IN FRAME f-relat
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-relat)
THEN w-relat:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-digita
/* Query rebuild information for BROWSE br-digita
     _START_FREEFORM
OPEN QUERY br-digita FOR EACH tt-digita.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-digita */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-pg-imp
/* Query rebuild information for FRAME f-pg-imp
     _Query            is NOT OPENED
*/  /* FRAME f-pg-imp */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-pg-sel
/* Query rebuild information for FRAME f-pg-sel
     _Query            is NOT OPENED
*/  /* FRAME f-pg-sel */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME w-relat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-relat w-relat
ON END-ERROR OF w-relat /* <Title> */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-relat w-relat
ON WINDOW-CLOSE OF w-relat /* <Title> */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-digita
&Scoped-define SELF-NAME br-digita
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-digita w-relat
ON DEL OF br-digita IN FRAME f-pg-dig
DO:
   apply 'choose':U to bt-retirar in frame f-pg-dig.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-digita w-relat
ON END-ERROR OF br-digita IN FRAME f-pg-dig
ANYWHERE 
DO:
    if  br-digita:new-row in frame f-pg-dig then do:
        if  avail tt-digita then
            delete tt-digita.
        if  br-digita:delete-current-row() in frame f-pg-dig then. 
    end.                                                               
    else do:
        get current br-digita.
        display tt-digita.nr-pedido
                tt-digita.nr-sequencia
                tt-digita.it-codigo 
                 with browse br-digita. 
    end.
    return no-apply.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-digita w-relat
ON ENTER OF br-digita IN FRAME f-pg-dig
ANYWHERE
DO:
  apply 'tab':U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-digita w-relat
ON INS OF br-digita IN FRAME f-pg-dig
DO:
   apply 'choose':U to bt-inserir in frame f-pg-dig.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-digita w-relat
ON OFF-END OF br-digita IN FRAME f-pg-dig
DO:
   apply 'entry':U to bt-inserir in frame f-pg-dig.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-digita w-relat
ON OFF-HOME OF br-digita IN FRAME f-pg-dig
DO:
  apply 'entry':U to bt-recuperar in frame f-pg-dig.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-digita w-relat
ON ROW-ENTRY OF br-digita IN FRAME f-pg-dig
DO:
   /*:T trigger para inicializar campos da temp table de digita‡Æo */
   if br-digita:new-row in frame f-pg-dig then 
   do:
      assign tt-digita.nr-pedido:screen-value in browse br-digita    = '0'
             tt-digita.nr-sequencia:screen-value in browse br-digita = '0'
             tt-digita.it-codigo:screen-value in browse br-digita    = ''.
   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-digita w-relat
ON ROW-LEAVE OF br-digita IN FRAME f-pg-dig
DO:
    /*:T  aqui que a grava‡Æo da linha da temp-table ‚ efetivada.
       Por‚m as valida‡äes dos registros devem ser feitas na procedure pi-executar,
       no local indicado pelo coment rio */
    
    if br-digita:NEW-ROW in frame f-pg-dig then 
    do transaction on error undo, return no-apply:

        create tt-digita.
        assign input browse br-digita tt-digita.nr-pedido
                                      tt-digita.nr-sequencia
                                      tt-digita.it-codigo
                                       .
    
        br-digita:CREATE-RESULT-LIST-ENTRY() in frame f-pg-dig.
    end.
    else do transaction on error undo, return no-apply:
         
        assign input browse br-digita tt-digita.nr-pedido 
                                      tt-digita.nr-sequencia 
                                      tt-digita.it-codigo.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-relat
&Scoped-define SELF-NAME bt-ajuda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ajuda w-relat
ON CHOOSE OF bt-ajuda IN FRAME f-relat /* Ajuda */
DO:
   {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-dig
&Scoped-define SELF-NAME bt-alterar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-alterar w-relat
ON CHOOSE OF bt-alterar IN FRAME f-pg-dig /* Alterar */
DO:
   apply 'entry':U to tt-digita.nr-pedido in browse br-digita. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-imp
&Scoped-define SELF-NAME bt-arquivo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-arquivo w-relat
ON CHOOSE OF bt-arquivo IN FRAME f-pg-imp
DO:
    {include/i-rparq.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-relat
&Scoped-define SELF-NAME bt-cancelar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cancelar w-relat
ON CHOOSE OF bt-cancelar IN FRAME f-relat /* Fechar */
DO:
   apply "close":U to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-imp
&Scoped-define SELF-NAME bt-config-impr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-config-impr w-relat
ON CHOOSE OF bt-config-impr IN FRAME f-pg-imp
DO:
   {include/i-rpimp.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-relat
&Scoped-define SELF-NAME bt-executar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-executar w-relat
ON CHOOSE OF bt-executar IN FRAME f-relat /* Executar */
DO:
   do  on error undo, return no-apply:
       run pi-executar.
   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-dig
&Scoped-define SELF-NAME bt-inserir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-inserir w-relat
ON CHOOSE OF bt-inserir IN FRAME f-pg-dig /* Inserir */
DO:
    assign bt-alterar:SENSITIVE in frame f-pg-dig = yes
           bt-retirar:SENSITIVE in frame f-pg-dig = yes
           bt-salvar:SENSITIVE  in frame f-pg-dig = yes.
    
    if num-results("br-digita":U) > 0 then
        br-digita:INSERT-ROW("after":U) in frame f-pg-dig.
    else do transaction:
        create tt-digita.
        
        open query br-digita for each tt-digita.
        
        //apply "entry":U to tt-digita.it-codigo in browse br-digita. 
        apply "entry":U to tt-digita.nr-pedido in browse br-digita. 
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-recuperar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-recuperar w-relat
ON CHOOSE OF bt-recuperar IN FRAME f-pg-dig /* Recuperar */
DO:
    {include/i-rprcd.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-retirar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-retirar w-relat
ON CHOOSE OF bt-retirar IN FRAME f-pg-dig /* Retirar */
DO:
    if  br-digita:num-selected-rows > 0 then do on error undo, return no-apply:
        get current br-digita.
        delete tt-digita.
        if  br-digita:delete-current-row() in frame f-pg-dig then.
    end.
    
    if num-results("br-digita":U) = 0 then
        assign bt-alterar:SENSITIVE in frame f-pg-dig = no
               bt-retirar:SENSITIVE in frame f-pg-dig = no
               bt-salvar:SENSITIVE in frame f-pg-dig  = no.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-salvar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-salvar w-relat
ON CHOOSE OF bt-salvar IN FRAME f-pg-dig /* Salvar */
DO:
   {include/i-rpsvd.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-relat
&Scoped-define SELF-NAME im-pg-dig
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL im-pg-dig w-relat
ON MOUSE-SELECT-CLICK OF im-pg-dig IN FRAME f-relat
DO:
    run pi-troca-pagina.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME im-pg-imp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL im-pg-imp w-relat
ON MOUSE-SELECT-CLICK OF im-pg-imp IN FRAME f-relat
DO:
    run pi-troca-pagina.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME im-pg-par
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL im-pg-par w-relat
ON MOUSE-SELECT-CLICK OF im-pg-par IN FRAME f-relat
DO:
    run pi-troca-pagina.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME im-pg-sel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL im-pg-sel w-relat
ON MOUSE-SELECT-CLICK OF im-pg-sel IN FRAME f-relat
DO:
    run pi-troca-pagina.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-par
&Scoped-define SELF-NAME rs-acao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-acao w-relat
ON VALUE-CHANGED OF rs-acao IN FRAME f-pg-par
DO:
  IF INPUT FRAME f-pg-par rs-acao = 3 THEN DO:
      ASSIGN tg-desaloca-plan:SENSITIVE IN FRAME f-pg-par = YES .
  END.
  ELSE DO:
      ASSIGN tg-desaloca-plan:SENSITIVE IN FRAME f-pg-par = NO 
             tg-desaloca-plan:CHECKED IN FRAME f-pg-par   = NO.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-imp
&Scoped-define SELF-NAME rs-destino
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-destino w-relat
ON VALUE-CHANGED OF rs-destino IN FRAME f-pg-imp
DO:
/*Alterado 15/02/2005 - tech1007 - Evento alterado para correto funcionamento dos novos widgets
  utilizados para a funcionalidade de RTF*/
do  with frame f-pg-imp:
    case self:screen-value:
        when "1" then do:
            assign c-arquivo:sensitive    = no
                   bt-arquivo:visible     = no
                   bt-config-impr:visible = YES
                   /*Alterado 17/02/2005 - tech1007 - Realizado teste de preprocessador para
                     verificar se o RTF est  ativo*/
                   &IF "{&RTF}":U = "YES":U &THEN
                   l-habilitaRtf:sensitive  = NO
                   l-habilitaRtf:SCREEN-VALUE IN FRAME f-pg-imp = "No"
                   l-habilitaRtf = NO
                   &endif
                   /*Fim alteracao 17/02/2005*/
                   .
        end.
        when "2" then do:
            assign c-arquivo:sensitive     = yes
                   bt-arquivo:visible      = yes
                   bt-config-impr:visible  = NO
                   /*Alterado 17/02/2005 - tech1007 - Realizado teste de preprocessador para
                     verificar se o RTF est  ativo*/
                   &IF "{&RTF}":U = "YES":U &THEN
                   l-habilitaRtf:sensitive  = YES
                   &endif
                   /*Fim alteracao 17/02/2005*/
                   .
        end.
        when "3" then do:
            assign c-arquivo:sensitive     = no
                   bt-arquivo:visible      = no
                   bt-config-impr:visible  = no
                   /*Alterado 17/02/2005 - tech1007 - Realizado teste de preprocessador para
                     verificar se o RTF est  ativo*/
                   &IF "{&RTF}":U = "YES":U &THEN
                   l-habilitaRtf:sensitive  = YES
                   &endif
                   /*Fim alteracao 17/02/2005*/
                   .
            /*Alterado 15/02/2005 - tech1007 - Teste para funcionar corretamente no WebEnabler*/
            &IF "{&RTF}":U = "YES":U &THEN
            IF VALID-HANDLE(hWenController) THEN DO:
                ASSIGN l-habilitaRtf:sensitive  = NO
                       l-habilitaRtf:SCREEN-VALUE IN FRAME f-pg-imp = "No"
                       l-habilitaRtf = NO.
            END.
            &endif
            /*Fim alteracao 15/02/2005*/
        end.
    end case.
end.
&IF "{&RTF}":U = "YES":U &THEN
RUN pi-habilitaRtf.
&endif
/*Fim alteracao 15/02/2005*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs-execucao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-execucao w-relat
ON VALUE-CHANGED OF rs-execucao IN FRAME f-pg-imp
DO:
   {include/i-rprse.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-dig
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK w-relat 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

{utp/ut9000.i "espdp090" "2.00.00.000"}

tt-digita.nr-sequencia:load-mouse-pointer ('image/lupa.cur') in BROWSE br-digita.
tt-digita.it-codigo   :load-mouse-pointer ('image/lupa.cur') in BROWSE br-digita.

/*:T inicializa‡äes do template de relat¢rio */
{include/i-rpini.i}

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

{include/i-rplbl.i}

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO  ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
    ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

    RUN enable_UI.

    
    ON 'leave' OF tt-digita.nr-pedido IN BROWSE br-digita 
    DO:   
        FIND FIRST ped-venda NO-LOCK 
             WHERE ped-venda.nr-pedido = INT(tt-digita.nr-pedido:SCREEN-VALUE IN BROWSE br-digita) 
        NO-ERROR.

        IF NOT AVAIL ped-venda THEN
        DO:
            MESSAGE 'Pedido informado nao localizado'
                VIEW-AS ALERT-BOX ERROR BUTTONS OK.

            APPLY 'entry' TO tt-digita.nr-pedido IN BROWSE br-digita.
        END.
    END.


    ON 'f5':U OF tt-digita.nr-sequencia IN BROWSE br-digita OR 
       'MOUSE-SELECT-DBLCLICK' OF tt-digita.nr-sequencia IN BROWSE br-digita OR
       'f5':U OF tt-digita.it-codigo IN BROWSE br-digita OR 
       'MOUSE-SELECT-DBLCLICK' OF tt-digita.it-codigo IN BROWSE br-digita  
    DO:   
         FIND FIRST ped-venda NO-LOCK 
              WHERE ped-venda.nr-pedido = INT(tt-digita.nr-pedido:SCREEN-VALUE IN BROWSE br-digita) 
         NO-ERROR.

         ASSIGN c-nome-abrev = ''
                c-pedido     = ''.

         IF AVAIL ped-venda THEN
            ASSIGN c-nome-abrev = ped-venda.nome-abrev
                   c-pedido     = ped-venda.nr-pedcli.
         
         {include/zoomvar.i &prog-zoom = dizoom/z01di154.w
                            &campo=tt-digita.nr-sequencia
                            &campozoom=nr-sequencia
                            &campo2=tt-digita.it-codigo
                            &campozoom2=it-codigo
                            &BROWSE = {&browse-name}
                            &parametros="run pi-seta-inicial in wh-pesquisa 
                            (input c-nome-abrev,INPUT c-pedido)."}.
     END.




     ON 'leave' OF tt-digita.nr-sequencia IN BROWSE br-digita 
     DO: 
         IF tt-digita.nr-sequencia:SCREEN-VALUE IN BROWSE br-digita  = '0' THEN DO:
             MESSAGE 'Nr.Sequencia deve ser preenchida'
                 VIEW-AS ALERT-BOX ERROR BUTTONS OK.
         END.
     END.
     

     ON 'leave'  OF tt-digita.it-codigo IN BROWSE br-digita OR 
        'return' OF tt-digita.it-codigo IN BROWSE br-digita 
     DO: 
         FIND FIRST ped-venda NO-LOCK 
              WHERE ped-venda.nr-pedido = INT(tt-digita.nr-pedido:SCREEN-VALUE IN BROWSE br-digita) 
         NO-ERROR.

         IF AVAIL ped-venda THEN
         DO:
             FIND FIRST ped-item NO-LOCK 
                  WHERE ped-item.nome-abrev   = ped-venda.nome-abrev
                    AND ped-item.nr-pedcli    = ped-venda.nr-pedcli
                    AND ped-item.nr-sequencia = int(tt-digita.nr-sequencia:SCREEN-VALUE IN BROWSE br-digita)
                    AND ped-item.it-codigo    = tt-digita.it-codigo:SCREEN-VALUE IN BROWSE br-digita
             NO-ERROR.

             IF NOT AVAIL ped-item THEN DO:
                 MESSAGE 'Nao localizado Item para o pedido informado'
                         VIEW-AS ALERT-BOX ERROR BUTTONS OK.
             END.  
         END.      
     END.
     

    ASSIGN d-dt-implanta-ini:SCREEN-VALUE IN FRAME f-pg-sel = STRING(ADD-INTERVAL(TODAY, -12, "month"))
           d-dt-implanta-fim:SCREEN-VALUE IN FRAME f-pg-sel = STRING(TODAY)
           d-dt-entrega-ini:SCREEN-VALUE IN FRAME f-pg-sel = STRING(ADD-INTERVAL(TODAY, -12, "month"))
           d-dt-entrega-fim:SCREEN-VALUE IN FRAME f-pg-sel = STRING(TODAY).
    
    {include/i-rpmbl.i}
  
    IF  NOT THIS-PROCEDURE:PERSISTENT THEN
        WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects w-relat  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available w-relat  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI w-relat  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-relat)
  THEN DELETE WIDGET w-relat.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI w-relat  _DEFAULT-ENABLE
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
  ENABLE im-pg-dig im-pg-imp im-pg-sel im-pg-par bt-executar bt-cancelar 
         bt-ajuda 
      WITH FRAME f-relat IN WINDOW w-relat.
  {&OPEN-BROWSERS-IN-QUERY-f-relat}
  DISPLAY i-orig-mercad c-cod-estabel-ini c-cod-estabel-fim i-grp-canais-ini 
          i-grp-canais-fim c-cod-unid-neg-fim c-tp-pedido-ini c-tp-pedido-fim 
          c-cod-unid-neg-ini c-estado-ini c-estado-fim d-dt-implanta-ini 
          d-dt-implanta-fim d-dt-entrega-ini d-dt-entrega-fim tg-automatico 
          c-nr-pedcli-ini c-nr-pedcli-fim i-cod-emitente-ini i-cod-emitente-fim 
          c-no-ab-reppri-ini c-no-ab-reppri-fim i-cod-cond-pag-ini 
          i-cod-cond-pag-fim 
      WITH FRAME f-pg-sel IN WINDOW w-relat.
  ENABLE IMAGE-1 IMAGE-2 IMAGE-3 IMAGE-4 IMAGE-7 IMAGE-8 IMAGE-9 IMAGE-10 
         IMAGE-11 IMAGE-12 IMAGE-13 IMAGE-14 IMAGE-15 IMAGE-16 IMAGE-17 
         IMAGE-18 IMAGE-19 IMAGE-20 IMAGE-21 IMAGE-22 IMAGE-23 IMAGE-24 RECT-17 
         RECT-18 i-orig-mercad c-cod-estabel-ini c-cod-estabel-fim 
         i-grp-canais-ini i-grp-canais-fim c-cod-unid-neg-fim c-tp-pedido-ini 
         c-tp-pedido-fim c-cod-unid-neg-ini c-estado-ini c-estado-fim 
         d-dt-implanta-ini d-dt-implanta-fim d-dt-entrega-ini d-dt-entrega-fim 
         tg-automatico c-nr-pedcli-ini c-nr-pedcli-fim i-cod-emitente-ini 
         i-cod-emitente-fim c-no-ab-reppri-ini c-no-ab-reppri-fim 
         i-cod-cond-pag-ini i-cod-cond-pag-fim 
      WITH FRAME f-pg-sel IN WINDOW w-relat.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-sel}
  DISPLAY rs-destino c-arquivo rs-execucao 
      WITH FRAME f-pg-imp IN WINDOW w-relat.
  ENABLE RECT-7 RECT-9 rs-destino bt-arquivo bt-config-impr c-arquivo 
         rs-execucao 
      WITH FRAME f-pg-imp IN WINDOW w-relat.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-imp}
  DISPLAY c-prioridade tg-avaliado c-atendente-mestre tg-aprovado c-deposito 
          tg-nao-aprovado tg-pend-info c-it-codigo tg-nao-avaliado rs-acao 
          tg-ped-aberto tg-ped-atend-parc tg-permite tg-it-aberto 
          tg-desaloca-plan tg-it-atend-parc 
      WITH FRAME f-pg-par IN WINDOW w-relat.
  ENABLE RECT-13 RECT-14 RECT-15 c-prioridade tg-avaliado c-atendente-mestre 
         tg-aprovado c-deposito tg-nao-aprovado tg-pend-info c-it-codigo 
         tg-nao-avaliado rs-acao tg-ped-aberto tg-ped-atend-parc tg-permite 
         tg-it-aberto tg-desaloca-plan tg-it-atend-parc 
      WITH FRAME f-pg-par IN WINDOW w-relat.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-par}
  ENABLE br-digita bt-inserir bt-recuperar 
      WITH FRAME f-pg-dig IN WINDOW w-relat.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-dig}
  VIEW w-relat.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit w-relat 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-executar w-relat 
PROCEDURE pi-executar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
define var r-tt-digita as rowid no-undo.

do on error undo, return error on stop  undo, return error:
    {include/i-rpexa.i}
    /*14/02/2005 - tech1007 - Alterada condicao para nÆo considerar mai o RTF como destino*/
    if input frame f-pg-imp rs-destino = 2 and
       input frame f-pg-imp rs-execucao = 1 then do:
        run utp/ut-vlarq.p (input input frame f-pg-imp c-arquivo).
        
        if return-value = "NOK":U then do:
            run utp/ut-msgs.p (input "show":U, input 73, input "").
            
            apply "MOUSE-SELECT-CLICK":U to im-pg-imp in frame f-relat.
            apply "ENTRY":U to c-arquivo in frame f-pg-imp.
            return error.
        end.
    end.

    /*14/02/2005 - tech1007 - Teste efetuado para nao permitir modelo em branco*/
    &IF "{&RTF}":U = "YES":U &THEN
    IF ( INPUT FRAME f-pg-imp c-modelo-rtf = "" AND
         INPUT FRAME f-pg-imp l-habilitaRtf = "Yes" ) OR
       ( SEARCH(INPUT FRAME f-pg-imp c-modelo-rtf) = ? AND
         input frame f-pg-imp rs-execucao = 1 AND
         INPUT FRAME f-pg-imp l-habilitaRtf = "Yes" )
         THEN DO:
        run utp/ut-msgs.p (input "show":U, input 73, input "").        
        apply "MOUSE-SELECT-CLICK":U to im-pg-imp in frame f-relat.
        /*30/12/2004 - tech1007 - Evento removido pois causa problemas no WebEnabler*/
        /*apply "CHOOSE":U to bt-modelo-rtf in frame f-pg-imp.*/
        return error.
    END.
    &endif
    /*Fim teste Modelo*/
    
    /*:T Coloque aqui as valida‡äes da p gina de Digita‡Æo, lembrando que elas devem
       apresentar uma mensagem de erro cadastrada, posicionar nesta p gina e colocar
       o focus no campo com problemas */
    /*browse br-digita:SET-REPOSITIONED-ROW (browse br-digita:DOWN, "ALWAYS":U).*/
    

    
    for each tt-digita no-lock:
        assign r-tt-digita = rowid(tt-digita).
        
        /*:T Valida‡Æo de duplicidade de registro na temp-table tt-digita */
        find first b-tt-digita where b-tt-digita.nr-pedido    = tt-digita.nr-pedido
                                 AND b-tt-digita.nr-sequencia = tt-digita.nr-sequencia
                                 AND b-tt-digita.it-codigo    = tt-digita.it-codigo 
                                 AND rowid(b-tt-digita) <> rowid(tt-digita) 
        no-lock no-error.

        if avail b-tt-digita then do:
            apply "MOUSE-SELECT-CLICK":U to im-pg-dig in frame f-relat.
            reposition br-digita to rowid rowid(b-tt-digita).
            
            run utp/ut-msgs.p (input "show":U, input 108, input "").
            apply "ENTRY":U to tt-digita.nr-pedido in browse br-digita.
            
            return error.
        end.
    end. 

    FIND FIRST deposito 
         WHERE deposito.cod-depos = c-deposito:SCREEN-VALUE IN FRAME f-pg-par
    NO-LOCK NO-ERROR.

    IF NOT AVAIL deposito THEN DO:
       APPLY "MOUSE-SELECT-CLICK":U TO im-pg-par IN FRAME f-relat.
       run utp/ut-msgs.p (input "show":U, input 17006, input "Deposito informado nao localizado").

       APPLY "ENTRY":U TO c-deposito IN FRAME f-pg-par.
       RETURN ERROR.
    END.
    ELSE DO:
        IF INT(i-orig-mercad:SCREEN-VALUE IN FRAME f-pg-sel) = 1 THEN DO:
           IF deposito.ind-tipo-dep = 2 THEN DO: //DEPOSITO EXTERNO
              APPLY "MOUSE-SELECT-CLICK":U TO im-pg-par IN FRAME f-relat.
              run utp/ut-msgs.p (input "show":U, input 17006, input "Estabelecimento Intelbras nao permite utilizar deposito externo").
             
              APPLY "ENTRY":U TO c-deposito IN FRAME f-pg-par.
              RETURN ERROR.
           END.
        END.
        ELSE DO:
          IF deposito.ind-tipo-dep = 1 THEN DO: //DEPOSITO INTERNO
              APPLY "MOUSE-SELECT-CLICK":U TO im-pg-par IN FRAME f-relat.
              run utp/ut-msgs.p (input "show":U, input 17006, input "Deposito Entreposto nao permite utilizar deposito interno").
             
              APPLY "ENTRY":U TO c-deposito IN FRAME f-pg-par.
              RETURN ERROR.
           END.
        END.
    END.
    

    
    
    /*:T Coloque aqui as valida‡äes das outras p ginas, lembrando que elas devem 
       apresentar uma mensagem de erro cadastrada, posicionar na p gina com 
       problemas e colocar o focus no campo com problemas */
    
    
    
    /*:T Aqui sÆo gravados os campos da temp-table que ser  passada como parƒmetro
       para o programa RP.P */
    
    create tt-param.
    assign tt-param.usuario         = c-seg-usuario
           tt-param.destino         = input frame f-pg-imp rs-destino
           tt-param.data-exec       = today
           tt-param.hora-exec       = time
           tt-param.cod-estabel-ini  = INPUT FRAME f-pg-sel c-cod-estabel-ini 
           tt-param.cod-estabel-fim  = INPUT FRAME f-pg-sel c-cod-estabel-fim 
           tt-param.tp-pedido-ini    = INPUT FRAME f-pg-sel c-tp-pedido-ini   
           tt-param.tp-pedido-fim    = INPUT FRAME f-pg-sel c-tp-pedido-fim   
           tt-param.dt-implanta-ini  = INPUT FRAME f-pg-sel d-dt-implanta-ini 
           tt-param.dt-implanta-fim  = INPUT FRAME f-pg-sel d-dt-implanta-fim 
           tt-param.dt-entrega-ini   = INPUT FRAME f-pg-sel d-dt-entrega-ini  
           tt-param.dt-entrega-fim   = INPUT FRAME f-pg-sel d-dt-entrega-fim  
           tt-param.nr-pedcli-ini    = INPUT FRAME f-pg-sel c-nr-pedcli-ini   
           tt-param.nr-pedcli-fim    = INPUT FRAME f-pg-sel c-nr-pedcli-fim   
           tt-param.cod-emitente-ini = INPUT FRAME f-pg-sel i-cod-emitente-ini
           tt-param.cod-emitente-fim = INPUT FRAME f-pg-sel i-cod-emitente-fim
           tt-param.no-ab-reppri-ini = INPUT FRAME f-pg-sel c-no-ab-reppri-ini
           tt-param.no-ab-reppri-fim = INPUT FRAME f-pg-sel c-no-ab-reppri-fim
           tt-param.cod-cond-pag-ini = INPUT FRAME f-pg-sel i-cod-cond-pag-ini
           tt-param.cod-cond-pag-fim = INPUT FRAME f-pg-sel i-cod-cond-pag-fim
           tt-param.grp-canais-ini   = INPUT FRAME f-pg-sel i-grp-canais-ini  
           tt-param.grp-canais-fim   = INPUT FRAME f-pg-sel i-grp-canais-fim  
           tt-param.cod-unid-neg-ini = INPUT FRAME f-pg-sel c-cod-unid-neg-ini
           tt-param.cod-unid-neg-fim = INPUT FRAME f-pg-sel c-cod-unid-neg-fim
           tt-param.prioridade       = INPUT FRAME f-pg-par c-prioridade      
           tt-param.atendente-mestre = INPUT FRAME f-pg-par c-atendente-mestre
           tt-param.deposito         = INPUT FRAME f-pg-par c-deposito        
           tt-param.it-codigo        = INPUT FRAME f-pg-par c-it-codigo       
           tt-param.avaliado         = INPUT FRAME f-pg-par tg-avaliado        
           tt-param.aprovado         = INPUT FRAME f-pg-par tg-aprovado        
           tt-param.nao-aprovado     = INPUT FRAME f-pg-par tg-nao-aprovado    
           tt-param.pend-info        = INPUT FRAME f-pg-par tg-pend-info       
           tt-param.nao-avaliado     = INPUT FRAME f-pg-par tg-nao-avaliado    
           tt-param.ped-aberto       = INPUT FRAME f-pg-par tg-ped-aberto      
           tt-param.ped-atend-parc   = INPUT FRAME f-pg-par tg-ped-atend-parc  
           tt-param.it-aberto        = INPUT FRAME f-pg-par tg-it-aberto       
           tt-param.it-atend-parc    = INPUT FRAME f-pg-par tg-it-atend-parc
           tt-param.acao             = INPUT FRAME f-pg-par rs-acao
           tt-param.estado-ini       = INPUT FRAME f-pg-sel c-estado-ini
           tt-param.estado-fim       = INPUT FRAME f-pg-sel c-estado-fim
           tt-param.origem-mercad    = INPUT FRAME f-pg-sel i-orig-mercad
           tt-param.permite          = INPUT FRAME f-pg-par tg-permite
           tt-param.tg-automatico    = INPUT FRAME f-pg-sel tg-automatico
           tt-param.desaloca-plan    = INPUT FRAME f-pg-par tg-desaloca-plan.
           
    
    /*Alterado 14/02/2005 - tech1007 - Alterado o teste para verificar se a op‡Æo de RTF est  selecionada*/
    if tt-param.destino = 1 
    then assign tt-param.arquivo = "".
    else if  tt-param.destino = 2
         then assign tt-param.arquivo = input frame f-pg-imp c-arquivo.
         else assign tt-param.arquivo = session:temp-directory + c-programa-mg97 + ".tmp":U.
    /*Fim alteracao 14/02/2005*/

    /*:T Coloque aqui a/l¢gica de grava‡Æo dos demais campos que devem ser passados
       como parƒmetros para o programa RP.P, atrav‚s da temp-table tt-param */
    
    
    
    /*:T Executar do programa RP.P que ir  criar o relat¢rio */
    {include/i-rpexb.i}
    
    SESSION:SET-WAIT-STATE("general":U).
    
    {include/i-rprun.i esp/pdp/espdp090rp.p}
    
    {include/i-rpexc.i}
    
    SESSION:SET-WAIT-STATE("":U).
    
    /*{include/i-rptrm.i}*/
end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-troca-pagina w-relat 
PROCEDURE pi-troca-pagina :
/*:T------------------------------------------------------------------------------
  Purpose: Gerencia a Troca de P gina (folder)   
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{include/i-rptrp.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records w-relat  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "tt-digita"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed w-relat 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.
  
  run pi-trata-state (p-issuer-hdl, p-state).
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

