&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgcad           PROGRESS
*/
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESCEP0998 2.00.00.014}  /*** 010014 ***/
/*
&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i ce0998 MCE}
&ENDIF
*/
/*------------------------------------------------------------------------

  File: 

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Preprocessadores do Template de Relat¢rio                            */
/* Obs: Retirar o valor do preprocessador para as p ginas que nÆo existirem  */

&GLOBAL-DEFINE PGSEL f-pg-sel
&GLOBAL-DEFINE PGCLA  
&GLOBAL-DEFINE PGPAR f-pg-par
&GLOBAL-DEFINE PGDIG f-pg-dig
&GLOBAL-DEFINE PGIMP f-pg-imp

/* Include Com as Vari veis Globais */
{utp/ut-glob.i}
{cdp/cdcfgmat.i}
{cdp/cdcfgdis.i}

&IF "{&mguni_version}" >= "2.071" &THEN
    DEF VAR c-cod-estabel-usuar AS CHAR FORMAT "x(05)".
&ELSE
    DEF VAR c-cod-estabel-usuar AS CHAR FORMAT "x(03)".
&ENDIF


/* Parameters Definitions ---                                           */

/* Temporary Table Definitions ---                                      */

define temp-table tt-param
    field usuario            as char
    field arquivo            as char
    field destino            as integer
    field data-exec          as date
    field hora-exec          as integer
    field c-ct-atual       like movto-estoq.ct-codigo
    field c-ct-nova        like movto-estoq.ct-codigo
    field c-sc-atual       like movto-estoq.sc-codigo
    field c-sc-nova        like movto-estoq.sc-codigo
    field c-cod-unid-negoc-atual like movto-estoq.cod-unid-negoc
    field c-cod-unid-negoc-nova  like movto-estoq.cod-unid-negoc
    field troca-saldo      like item.loc-unica
    field da-data-ini      like movto-estoq.dt-trans
    field da-data-fim      like movto-estoq.dt-trans
    field i-emi-ini        like movto-estoq.cod-emite
    field i-emi-fim        like movto-estoq.cod-emite
    field c-serie-ini      like movto-estoq.serie-docto
    field c-serie-fim      like movto-estoq.serie-docto
    field c-nro-ini        like movto-estoq.nro-docto
    field c-nro-fim        like movto-estoq.nro-docto
    field c-nat-ini        like movto-estoq.nat-oper
    field c-nat-fim        like movto-estoq.nat-oper
    field i-esp-ini        like movto-estoq.esp-docto
    field i-esp-fim        like movto-estoq.esp-docto
    field c-est-ini        like movto-estoq.cod-estabel
    field c-est-fim        like movto-estoq.cod-estabel
    field c-it-ini         like movto-estoq.it-codigo
    field c-it-fim         like movto-estoq.it-codigo
    field i-ge-ini         like item.ge-codigo
    field i-ge-fim         like item.ge-codigo.

define temp-table tt-digita
    &IF "{&mguni_version}" >= "2.071" &THEN
        field cod-estabel           as character format "x(5)"
    &ELSE
        field cod-estabel           as character format "x(3)"
    &ENDIF
    field nome                  as character format "x(40)"
    field data-ini              as date format "99/99/9999"
    field data-fim              as date format "99/99/9999".

define buffer b-tt-digita for tt-digita.

def var i-empresa like param-global.empresa-prin no-undo.

def var v_cod_cta_ctbl       as char   no-undo.
def var v_titulo_cta_ctbl    as char   no-undo.
def var v_num_tip_cta_ctbl   as int    no-undo.
def var v_num_sit_cta_ctbl   as int    no-undo.
def var v_ind_finalid_cta    as char   no-undo.
/* Vari veis centro de custo */ 
def var v_cod_unid_negoc     as char   no-undo.
def var v_cod_ccusto         as char   no-undo.
def var v_titulo_ccusto      as char   no-undo.
def var v_log_utz_ccusto     as log    no-undo.
def var h_api_cta_ctbl       as handle no-undo.
def var h_api_ccusto         as handle no-undo.

define variable l-flag          as logical init yes                         no-undo.
define var c-formato-conta  as char no-undo.
define var c-formato-ccusto as char no-undo. 

DEFINE VARIABLE p_cod_plano_ccusto   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE p_cod_plano_cta_ctbl AS CHARACTER   NO-UNDO. 

def temp-table tt_log_erro no-undo
         field ttv_num_cod_erro  as integer format ">>>>,>>9" label "N£mero" column-label "N£mero"
         field ttv_des_msg_ajuda as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda"
         field ttv_des_msg_erro  as character format "x(60)" label "Mensagem Erro" column-label "Inconsistˆncia".

/* Transfer Definitions */

def var raw-param        as raw no-undo.

def temp-table tt-raw-digita
   field raw-digita      as raw.

/* Local Variable Definitions ---                                       */

def var l-ok               as logical no-undo.
def var c-arq-digita       as char    no-undo.
def var c-terminal         as char    no-undo.
def var c-ct-codigo        as char format "x(8)" no-undo.
def var c-ct-codigo2       as char format "x(8)" no-undo.
def var c-sc-codigo        as char format "x(8)" no-undo.
def var c-sc-codigo2       as char format "x(8)" no-undo.
def var c-conta-contabil   like conta-contab.conta-contabil no-undo.
def var l-fech-estab       as logical initial no.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-pg-dig
&Scoped-define BROWSE-NAME br-digita

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-digita emitente

/* Definitions for BROWSE br-digita                                     */
&Scoped-define FIELDS-IN-QUERY-br-digita tt-digita.cod-estabel tt-digita.data-ini tt-digita.data-fim tt-digita.nome   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-digita tt-digita.cod-estabel ~
tt-digita.data-ini ~
tt-digita.data-fim   
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

/* Definitions for FRAME f-pg-sel                                       */
&Scoped-define QUERY-STRING-f-pg-sel FOR EACH emitente SHARE-LOCK
&Scoped-define OPEN-QUERY-f-pg-sel OPEN QUERY f-pg-sel FOR EACH emitente SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-f-pg-sel emitente
&Scoped-define FIRST-TABLE-IN-QUERY-f-pg-sel emitente


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br-digita bt-inserir bt-alterar bt-retirar ~
bt-salvar bt-recuperar 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

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
     SIZE 46.29 BY 2.92.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.29 BY 1.71.

DEFINE VARIABLE c-cod-unid-negoc-atual AS CHARACTER FORMAT "x(03)":U 
     LABEL "Unid Negoc DE" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-unid-negoc-nova AS CHARACTER FORMAT "x(03)":U 
     LABEL "PARA" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .92 NO-UNDO.

DEFINE VARIABLE c-ct-atual AS CHARACTER FORMAT "x(08)":U 
     LABEL "Conta DE" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE c-ct-nova AS CHARACTER FORMAT "x(08)":U 
     LABEL "PARA" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .92 NO-UNDO.

DEFINE VARIABLE c-sc-atual AS CHARACTER FORMAT "x(05)":U 
     LABEL "Centro de Custo DE" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE c-sc-nova AS CHARACTER FORMAT "x(05)":U 
     LABEL "PARA" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .92 NO-UNDO.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 75 BY 8.54.

DEFINE VARIABLE l-troca-saldo AS LOGICAL INITIAL no 
     LABEL "Troca Contas de Saldo" 
     VIEW-AS TOGGLE-BOX
     SIZE 28.86 BY .83 NO-UNDO.

DEFINE VARIABLE c-est-ini LIKE estabelec.cod-estabel
     LABEL "Estab":R7 
     VIEW-AS FILL-IN 
     SIZE 7.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-it-fim AS CHARACTER FORMAT "x(16)" INITIAL "ZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE c-it-ini AS CHARACTER FORMAT "x(16)" 
     LABEL "Item":R5 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE c-nat-fim AS CHARACTER FORMAT "9.99-XXX" INITIAL "999XXX" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE c-nat-ini AS CHARACTER FORMAT "9.99-xxx":U INITIAL "000AAA" 
     LABEL "Natureza Opera‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE c-nro-fim AS CHARACTER FORMAT "x(16)" INITIAL "ZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE c-nro-ini AS CHARACTER FORMAT "X(16)":U 
     LABEL "Documento" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE c-serie-fim AS CHARACTER FORMAT "x(5)" INITIAL "ZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE c-serie-ini AS CHARACTER FORMAT "X(5)":U 
     LABEL "S‚rie Documento" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE da-data-fim AS DATE FORMAT "99/99/9999":U INITIAL 12/31/9999 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE da-data-ini AS DATE FORMAT "99/99/9999":U INITIAL 01/01/001 
     LABEL "Data Transa‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE i-emi-fim AS INTEGER FORMAT ">>>>>9" INITIAL 999999 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88 NO-UNDO.

DEFINE VARIABLE i-emi-ini AS INTEGER FORMAT ">>>>>9" INITIAL 0 
     LABEL "Emitente":R8 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88 NO-UNDO.

DEFINE VARIABLE i-esp-fim AS INTEGER FORMAT ">9" INITIAL 99 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE i-esp-ini AS INTEGER FORMAT ">9":U INITIAL 0 
     LABEL "Esp‚cie Documento" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE i-ge-fim AS INTEGER FORMAT ">9" INITIAL 99 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE i-ge-ini AS INTEGER FORMAT ">9" INITIAL 0 
     LABEL "Grupo Estoque":R16 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE BUTTON bt-ajuda 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-cancelar AUTO-END-KEY 
     LABEL "Cancelar" 
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
     SIZE 79 BY 11.38
     FGCOLOR 0 .

DEFINE RECTANGLE rt-folder-left
     EDGE-PIXELS 0    
     SIZE .43 BY 11.21
     BGCOLOR 15 .

DEFINE RECTANGLE rt-folder-right
     EDGE-PIXELS 0    
     SIZE .43 BY 11.17
     BGCOLOR 7 .

DEFINE RECTANGLE rt-folder-top
     EDGE-PIXELS 0    
     SIZE 78.72 BY .13
     BGCOLOR 15 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-digita FOR 
      tt-digita SCROLLING.

DEFINE QUERY f-pg-sel FOR 
      emitente SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-digita
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-digita C-Win _FREEFORM
  QUERY br-digita DISPLAY
      tt-digita.cod-estabel label "Est"
      tt-digita.data-ini    label "Data Inicial"
      tt-digita.data-fim    label "Data Final"
      tt-digita.nome        label "Nome"
ENABLE
      tt-digita.cod-estabel
      tt-digita.data-ini
      tt-digita.data-fim
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS SIZE 76.57 BY 9
         BGCOLOR 15 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-relat
     bt-executar AT ROW 14.54 COL 3 HELP
          "Dispara a execu‡Æo do relat¢rio"
     bt-cancelar AT ROW 14.54 COL 14 HELP
          "Cancelar"
     bt-ajuda AT ROW 14.54 COL 70 HELP
          "Ajuda"
     rt-folder-left AT ROW 2.54 COL 2.14
     rt-folder-top AT ROW 2.54 COL 2.14
     rt-folder AT ROW 2.5 COL 2
     RECT-1 AT ROW 14.29 COL 2
     RECT-6 AT ROW 13.75 COL 2.14
     rt-folder-right AT ROW 2.67 COL 80.43
     im-pg-dig AT ROW 1.5 COL 33.57
     im-pg-imp AT ROW 1.5 COL 49.29
     im-pg-par AT ROW 1.5 COL 17.86
     im-pg-sel AT ROW 1.5 COL 2.14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 81 BY 15
         DEFAULT-BUTTON bt-executar.

DEFINE FRAME f-pg-dig
     br-digita AT ROW 1 COL 1
     bt-inserir AT ROW 10 COL 1
     bt-alterar AT ROW 10 COL 16
     bt-retirar AT ROW 10 COL 31
     bt-salvar AT ROW 10 COL 46
     bt-recuperar AT ROW 10 COL 61
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 3
         SIZE 76.86 BY 10.15.

DEFINE FRAME f-pg-imp
     rs-destino AT ROW 2.38 COL 3.29 HELP
          "Destino de ImpressÆo do Relat¢rio" NO-LABEL
     bt-config-impr AT ROW 3.58 COL 43.29 HELP
          "Configura‡Æo da impressora"
     bt-arquivo AT ROW 3.58 COL 43.29 HELP
          "Escolha do nome do arquivo"
     c-arquivo AT ROW 3.63 COL 3.29 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL
     rs-execucao AT ROW 5.75 COL 3 HELP
          "Modo de Execu‡Æo" NO-LABEL
     text-destino AT ROW 1.63 COL 3.86 NO-LABEL
     text-modo AT ROW 5 COL 1.29 COLON-ALIGNED NO-LABEL
     RECT-7 AT ROW 1.92 COL 2.14
     RECT-9 AT ROW 5.29 COL 2.14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 3
         SIZE 73.72 BY 10.

DEFINE FRAME f-pg-sel
     c-est-ini AT ROW 2 COL 21 COLON-ALIGNED HELP
          ""
          LABEL "Estab":R7
     da-data-ini AT ROW 3 COL 21 COLON-ALIGNED HELP
          "Data da Transa‡Æo"
     da-data-fim AT ROW 3 COL 50.43 COLON-ALIGNED HELP
          "Data da Transa‡Æo" NO-LABEL
     i-emi-ini AT ROW 4 COL 21 COLON-ALIGNED HELP
          "C¢digo do Emitente"
     i-emi-fim AT ROW 4 COL 50.43 COLON-ALIGNED NO-LABEL
     c-serie-ini AT ROW 5 COL 21 COLON-ALIGNED HELP
          "S‚rie do Documento"
     c-serie-fim AT ROW 5 COL 50.43 COLON-ALIGNED HELP
          "S‚rie do documento" NO-LABEL
     c-nro-ini AT ROW 6 COL 21 COLON-ALIGNED HELP
          "N£mero do Documento"
     c-nro-fim AT ROW 6 COL 50.43 COLON-ALIGNED HELP
          "N£mero do Documento" NO-LABEL
     c-nat-ini AT ROW 7 COL 21 COLON-ALIGNED HELP
          "Natureza da Opera‡Æo"
     c-nat-fim AT ROW 7 COL 50.43 COLON-ALIGNED HELP
          "Natureza da Opera‡Æo" NO-LABEL
     i-esp-ini AT ROW 8 COL 21 COLON-ALIGNED HELP
          "Esp‚cie do Documento"
     i-esp-fim AT ROW 8 COL 50.43 COLON-ALIGNED HELP
          "Esp‚cie do Documento" NO-LABEL
     c-it-ini AT ROW 9 COL 21 COLON-ALIGNED HELP
          "C¢digo do Item"
     c-it-fim AT ROW 9 COL 50.43 COLON-ALIGNED HELP
          "C¢digo do Item" NO-LABEL
     i-ge-ini AT ROW 10 COL 21 COLON-ALIGNED HELP
          "Grupo de estoque"
     i-ge-fim AT ROW 10 COL 50.43 COLON-ALIGNED HELP
          "Grupo de estoque" NO-LABEL
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 2.85
         SIZE 76.86 BY 10.62.

DEFINE FRAME f-pg-par
     l-troca-saldo AT ROW 2.63 COL 23.72
     c-ct-atual AT ROW 4.17 COL 21.43 COLON-ALIGNED
     c-ct-nova AT ROW 4.17 COL 48.86 COLON-ALIGNED HELP
               "F5 para Zoom"
     c-sc-atual AT ROW 6.17 COL 21.43 COLON-ALIGNED
     c-sc-nova AT ROW 6.17 COL 49 COLON-ALIGNED HELP
          "F5 para Zoom"
     c-cod-unid-negoc-atual AT ROW 8.17 COL 21.43 COLON-ALIGNED
     c-cod-unid-negoc-nova AT ROW 8.17 COL 49 COLON-ALIGNED
     RECT-10 AT ROW 2.08 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 3
         SIZE 76.72 BY 10.62.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Troca Conta Cont bil"
         HEIGHT             = 15
         WIDTH              = 81.29
         MAX-HEIGHT         = 22.33
         MAX-WIDTH          = 114.29
         VIRTUAL-HEIGHT     = 22.33
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
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB C-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{include/w-relat.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* REPARENT FRAME */
ASSIGN FRAME f-pg-dig:FRAME = FRAME f-relat:HANDLE.

/* SETTINGS FOR FRAME f-pg-dig
   FRAME-NAME                                                           */
/* BROWSE-TAB br-digita 1 f-pg-dig */
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
/* SETTINGS FOR FILL-IN c-est-ini IN FRAME f-pg-sel
   LIKE = mgadm.estabelec.cod-estabel EXP-LABEL EXP-SIZE                */
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
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

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
     _TblList          = "mgcad.emitente"
     _Query            is NOT OPENED
*/  /* FRAME f-pg-sel */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Troca Conta Cont bil */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Troca Conta Cont bil */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-digita
&Scoped-define SELF-NAME br-digita
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-digita C-Win
ON DEL OF br-digita IN FRAME f-pg-dig
DO:
   apply 'choose' to bt-retirar in frame f-pg-dig.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-digita C-Win
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
        display tt-digita.cod-estabel
                tt-digita.data-ini
                tt-digita.data-fim
                tt-digita.nome with browse br-digita. 
    end.
    return no-apply.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-digita C-Win
ON ENTER OF br-digita IN FRAME f-pg-dig
ANYWHERE
DO:
  apply 'tab' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-digita C-Win
ON INS OF br-digita IN FRAME f-pg-dig
DO:
   apply 'choose' to bt-inserir in frame f-pg-dig.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-digita C-Win
ON OFF-END OF br-digita IN FRAME f-pg-dig
DO:
   apply 'entry' to bt-inserir in frame f-pg-dig.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-digita C-Win
ON OFF-HOME OF br-digita IN FRAME f-pg-dig
DO:
  apply 'entry' to bt-recuperar in frame f-pg-dig.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-digita C-Win
ON ROW-ENTRY OF br-digita IN FRAME f-pg-dig
DO:
   /* trigger para inicializar campos da temp table de digita‡Æo */

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-digita C-Win
ON ROW-LEAVE OF br-digita IN FRAME f-pg-dig
DO:
    /*  aqui que a grava‡Æo da linha da temp-table ‚ efetivada.
       Por‚m as valida‡äes dos registros devem ser feitas na procedure pi-executar,
       no local indicado pelo coment rio */

    if br-digita:NEW-ROW in frame f-pg-dig then 
    do transaction on error undo, return no-apply:
        create tt-digita.
        assign input browse br-digita tt-digita.cod-estabel
               input browse br-digita tt-digita.data-ini
               input browse br-digita tt-digita.data-fim
               input browse br-digita tt-digita.nome.
        br-digita:CREATE-RESULT-LIST-ENTRY() in frame f-pg-dig.

    end.
    else do transaction on error undo, return no-apply:
        assign input browse br-digita tt-digita.cod-estabel
               input browse br-digita tt-digita.data-ini
               input browse br-digita tt-digita.data-fim
               input browse br-digita tt-digita.nome.
    end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-relat
&Scoped-define SELF-NAME bt-ajuda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ajuda C-Win
ON CHOOSE OF bt-ajuda IN FRAME f-relat /* Ajuda */
DO:
   {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-dig
&Scoped-define SELF-NAME bt-alterar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-alterar C-Win
ON CHOOSE OF bt-alterar IN FRAME f-pg-dig /* Alterar */
DO:
   apply 'entry' to tt-digita.cod-estabel in browse br-digita. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-imp
&Scoped-define SELF-NAME bt-arquivo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-arquivo C-Win
ON CHOOSE OF bt-arquivo IN FRAME f-pg-imp
DO:
    {include/i-rparq.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-relat
&Scoped-define SELF-NAME bt-cancelar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cancelar C-Win
ON CHOOSE OF bt-cancelar IN FRAME f-relat /* Cancelar */
DO:
   apply "close" to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-imp
&Scoped-define SELF-NAME bt-config-impr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-config-impr C-Win
ON CHOOSE OF bt-config-impr IN FRAME f-pg-imp
DO:
   {include/i-rpimp.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-relat
&Scoped-define SELF-NAME bt-executar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-executar C-Win
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
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-inserir C-Win
ON CHOOSE OF bt-inserir IN FRAME f-pg-dig /* Inserir */
DO:
    assign bt-alterar:SENSITIVE in frame f-pg-dig = yes
           bt-retirar:SENSITIVE in frame f-pg-dig = yes
           bt-salvar:SENSITIVE in frame f-pg-dig  = yes.

    if num-results("br-digita") > 0 then
        br-digita:INSERT-ROW("after") in frame f-pg-dig.
    else do transaction:
        create tt-digita.

        open query br-digita for each tt-digita.

        apply "entry" to tt-digita.cod-estabel in browse br-digita. 
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-recuperar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-recuperar C-Win
ON CHOOSE OF bt-recuperar IN FRAME f-pg-dig /* Recuperar */
DO:
    {include/i-rprcd.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-retirar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-retirar C-Win
ON CHOOSE OF bt-retirar IN FRAME f-pg-dig /* Retirar */
DO:
    if  br-digita:num-selected-rows > 0 then do on error undo, return no-apply:
        get current br-digita.
        delete tt-digita.
        if  br-digita:delete-current-row() in frame f-pg-dig then.
    end.

    if num-results("br-digita") = 0 then
        assign bt-alterar:SENSITIVE in frame f-pg-dig = no
               bt-retirar:SENSITIVE in frame f-pg-dig = no
               bt-salvar:SENSITIVE in frame f-pg-dig  = no.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-salvar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-salvar C-Win
ON CHOOSE OF bt-salvar IN FRAME f-pg-dig /* Salvar */
DO:
   {include/i-rpsvd.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-par
&Scoped-define SELF-NAME c-ct-nova
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ct-nova C-Win
ON ENTRY OF c-ct-nova IN FRAME f-pg-par /* PARA */
DO:
    ASSIGN SELF:FORMAT = "x(08)".
    /*ENABLE c-sc-nova WITH FRAME {&FRAME-NAME}.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ct-nova C-Win
ON F5 OF c-ct-nova IN FRAME f-pg-par /* PARA */
DO:

   find estabelec where
        estabelec.cod-estabel = c-est-ini:screen-value in frame f-pg-sel no-lock no-error.
   assign i-empresa = estabelec.ep-codigo when avail estabelec.

   run pi_zoom_cta_ctbl_integr in h_api_cta_ctbl (input  i-empresa,           /* EMPRESA EMS2 */
                                                  input  "CEP",               /* MàDULO */
                                                  input  "",                  /* PLANO DE CONTAS */
                                                  input  "(nenhum)",          /* FINALIDADES */
                                                  input  today,               /* DATA TRANSACAO */
                                                  output v_cod_cta_ctbl,      /* CODIGO CONTA */
                                                  output v_titulo_cta_ctbl,   /* DESCRICAO CONTA */
                                                  output v_ind_finalid_cta,   /* FINALIDADE DA CONTA */
                                                  output table tt_log_erro).  /* ERROS */ 

   IF v_titulo_cta_ctbl <> "" THEN DO:
       ASSIGN c-ct-nova:SCREEN-VALUE = v_cod_cta_ctbl.
/*       ASSIGN c-titulo-conta:SCREEN-VALUE = v_titulo_cta_ctbl.*/
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ct-nova C-Win
ON LEAVE OF c-ct-nova IN FRAME f-pg-par /* PARA */
DO:
/*
 if l-flag then do :
    do with frame {&FRAME-NAME}:
        ASSIGN c-ct-nova.

        find estabelec where
                 estabelec.cod-estabel = c-cod-estabel-usuar no-lock no-error.
        assign i-empresa = estabelec.ep-codigo when avail estabelec.

        ASSIGN SELF:FORMAT = "x(20)". 
        ASSIGN v_cod_cta_ctbl = INPUT c-ct-nova.
    
        /* Busca dados da conta cont bil */
        run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (input        i-empresa,          /* EMPRESA EMS2 */
                                                       input        "",                 /* PLANO DE CONTAS */
                                                       input-output v_cod_cta_ctbl,     /* CONTA */
                                                       input        today,              /* DATA TRANSACAO */   
                                                       output       v_titulo_cta_ctbl,  /* DESCRICAO CONTA */
                                                       output       v_num_tip_cta_ctbl, /* TIPO DA CONTA */
                                                       output       v_num_sit_cta_ctbl, /* SITUA›øO DA CONTA */
                                                       output       v_ind_finalid_cta,  /* FINALIDADES DA CONTA */
                                                       output table tt_log_erro).       /* ERROS */

        IF RETURN-VALUE = "OK" THEN DO:
/*            ASSIGN SELF:SCREEN-VALUE = v_cod_cta_ctbl.
            ASSIGN SELF:FORMAT = c-formato-conta.*/

            /* Verifica se a conta utiliza centro de custo */
            run pi_verifica_utilizacao_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS 2 */
                                                               input  c-cod-estabel-usuar,        /* ESTABELECIMENTO EMS2 */
                                                               input  "",                 /* PLANO CONTAS */
                                                               input  v_cod_cta_ctbl,     /* CONTA */
                                                               input  today,              /* DT TRANSACAO */
                                                               output v_log_utz_ccusto,   /* UTILIZA CCUSTO ? */
                                                               output table tt_log_erro). /* ERROS */
            IF v_log_utz_ccusto THEN DO:
                ENABLE c-sc-nova WITH FRAME {&FRAME-NAME}.
            END.
            ELSE DO:
                ASSIGN c-sc-nova:SCREEN-VALUE = "".
/*                DISABLE c-sc-nova WITH FRAME {&FRAME-NAME}.*/
            END.
            /************************************************/
        END.
    end.
 end. 
*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ct-nova C-Win
ON MOUSE-SELECT-DBLCLICK OF c-ct-nova IN FRAME f-pg-par /* PARA */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-sc-nova
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-sc-nova C-Win
ON F5 OF c-sc-nova IN FRAME f-pg-par /* PARA */
DO:
    find estabelec where estabelec.cod-estabel = c-est-ini:screen-value in frame f-pg-sel no-lock no-error.

    assign i-empresa = estabelec.ep-codigo when avail estabelec.

    run pi_zoom_ccusto in h_api_ccusto (input i-empresa,           /* EMPRESA EMS2 */
                                       input "",                  /* CODIGO DO PLANO CCUSTO */
                                       input "",                  /* UNIDADE DE NEGOCIO */
                                       input today,               /* DATA DE TRANSACAO */
                                       output v_cod_ccusto,       /* CODIGO CCUSTO */
                                       output v_titulo_ccusto,    /* DESCRICAO CCUSTO */
                                       output table tt_log_erro). /* ERROS */ 

   ASSIGN c-sc-nova:SCREEN-VALUE = v_cod_ccusto.
/*   ASSIGN c-titulo-ccusto:SCREEN-VALUE = v_titulo_ccusto.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-sc-nova C-Win
ON MOUSE-SELECT-DBLCLICK OF c-sc-nova IN FRAME f-pg-par /* PARA */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-relat
&Scoped-define SELF-NAME im-pg-dig
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL im-pg-dig C-Win
ON MOUSE-SELECT-CLICK OF im-pg-dig IN FRAME f-relat
DO:
    run pi-troca-pagina.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME im-pg-imp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL im-pg-imp C-Win
ON MOUSE-SELECT-CLICK OF im-pg-imp IN FRAME f-relat
DO:
    run pi-troca-pagina.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME im-pg-par
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL im-pg-par C-Win
ON MOUSE-SELECT-CLICK OF im-pg-par IN FRAME f-relat
DO:
    run pi-troca-pagina.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME im-pg-sel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL im-pg-sel C-Win
ON MOUSE-SELECT-CLICK OF im-pg-sel IN FRAME f-relat
DO:
    run pi-troca-pagina.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-imp
&Scoped-define SELF-NAME rs-destino
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-destino C-Win
ON VALUE-CHANGED OF rs-destino IN FRAME f-pg-imp
DO:
do  with frame f-pg-imp:
    case self:screen-value:
        when "1" then do:
            assign c-arquivo:sensitive    = no
                   bt-arquivo:visible     = no
                   bt-config-impr:visible = yes.
        end.
        when "2" then do:
            assign c-arquivo:sensitive     = yes
                   bt-arquivo:visible      = yes
                   bt-config-impr:visible  = no.
        end.
        when "3" then do:
            assign c-arquivo:sensitive     = no
                   bt-arquivo:visible      = no
                   bt-config-impr:visible  = no.
        end.
    end case.
end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs-execucao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-execucao C-Win
ON VALUE-CHANGED OF rs-execucao IN FRAME f-pg-imp
DO:
   {include/i-rprse.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-dig
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */





/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

{utp/ut9000.i "ESCEP0998" "2.00.00.014"}

/* inicializa‡äes do template de relat¢rio */
{include/i-rpini.i}

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.
/*
run utp/ut-msgs.p (input "show", input 17051, input "").
RETURN "NOK".
*/
{include/i-rplbl.i}

if c-ct-nova:load-mouse-pointer ("image~\lupa.cur") in frame f-pg-par then.
if c-sc-nova:load-mouse-pointer ("image~\lupa.cur") in frame f-pg-par then.
/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.



/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO  ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
    ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

    {utp/ut-field.i mgind natur-oper nat-operacao 4}
    assign c-nat-ini:format in frame f-pg-sel = trim(return-value)
           c-nat-fim:format in frame f-pg-sel = trim(return-value).

    RUN enable_UI.

    {include/i-rpmbl.i}

    IF  NOT THIS-PROCEDURE:PERSISTENT THEN
        WAIT-FOR CLOSE OF THIS-PROCEDURE.

    /* Handle da API Conta Contÿbil */
    run prgint\utb\utb743za.py persistent set h_api_cta_ctbl.
    /* Handle da API Centro Custo */
    run prgint\utb\utb742za.py persistent set h_api_ccusto.  

    find first param-estoq no-lock no-error.
    if not avail param-estoq then do:
       run utp/ut-msgs.p (input "show",
                          input 1059,
                          input "").
       RUN dispatch IN THIS-PROCEDURE ('adm-exit':U).
    end.    
    &if defined (bf_mat_fech_estab) &then
        if param-estoq.tp-fech = 2 then
           assign l-fech-estab = yes.
    &endif

    find first param-estoq no-lock no-error.
    if  avail param-estoq then
    ASSIGN c-cod-estabel-usuar = param-estoq.estabel-pad.

    &IF DEFINED(Bf_dis_usuario_estab) &THEN
        IF CAN-FIND(funcao WHERE funcao.cd-funcao = "Fn-estab-usuario"
                           AND funcao.ativo     = YES) THEN DO:

           RUN cdp/cd8702.p (INPUT c-seg-usuario,
                             INPUT-OUTPUT c-cod-estabel-usuar).
        END.
    &ENDIF

    assign c-est-ini:screen-value in frame f-pg-sel = c-cod-estabel-usuar.

    find estabelec where
         estabelec.cod-estabel = c-cod-estabel-usuar no-lock no-error.
    assign i-empresa = estabelec.ep-codigo when avail estabelec.
    run pi_retorna_formato_cta_ctbl in h_api_cta_ctbl (input  i-empresa,          /* EMPRESA EMS2 */
                                                       input  "",                 /* PLANO CONTAS */
                                                       input  TODAY,              /* DATA DE TRANSACAO */
                                                       output c-formato-conta,    /* FORMATO CONTA */
                                                       output table tt_log_erro). /* ERROS */
    /* Retorna formato do centro de custo */
    run pi_retorna_formato_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS2 */
                                                   input  "",                 /* PLANO CCUSTO */
                                                   input  TODAY,              /* DATA DE TRANSACAO */
                                                   output c-formato-ccusto,   /* FORMATO CCUSTO */
                                                   output table tt_log_erro). /* ERROS */
/*
    if c-formato-conta <> "" then
       assign c-ct-atual:format in frame f-pg-par = c-formato-conta
              c-ct-nova:format in frame f-pg-par = c-formato-conta.

    if c-formato-ccusto <> "" then
       assign c-sc-atual:format in frame f-pg-par = c-formato-ccusto
              c-sc-nova:format in frame f-pg-par = c-formato-ccusto.  
*/
    if l-fech-estab then 
       assign da-data-ini:sensitive in frame f-pg-sel = no
              da-data-fim:sensitive in frame f-pg-sel = no
              c-est-ini:sensitive in frame f-pg-sel   = no.
    else
       assign da-data-ini:screen-value in frame f-pg-sel = 
                          string(param-estoq.contab-ate + 1,"99/99/9999")
              da-data-fim:screen-value in frame f-pg-sel = string(today).

    /*{cep/ce9999.i2}*/   /* desabilita folder digita‡Æo */

&if defined(bf_mat_fech_estab) &then
    if param-estoq.tp-fech = 2 then 
        pause 0.
    else do:
        def var wh-label-dig1 as widget-handle no-undo.
        assign im-pg-dig:sensitive in frame f-relat = (param-estoq.tp-fech = 2).
        run utp/ut-liter.p (input "Digita‡Æo",
                            input "*",
                            input "R").
        create text wh-label-dig1
        assign frame        = frame f-relat:handle
               format       = "x(9)"
               font         = 1
               screen-value = return-value
               width        = 10
               row          = 1.8
               col          = im-pg-dig:col in frame f-relat + 1.7
               fgcolor      = 7
               visible      = yes.    
    end.
&else    
    def var wh-label-dig1 as widget-handle no-undo.
    assign im-pg-dig:sensitive in frame f-relat = no.
    run utp/ut-liter.p (input "Digita‡Æo",
                        input "*",
                        input "R").
    create text wh-label-dig1
    assign frame        = frame f-relat:handle
           format       = "x(9)"
           font         = 1
           screen-value = return-value
           width        = 10
           row          = 1.8
           col          = im-pg-dig:col in frame f-relat + 1.7
           fgcolor      = 7
           visible      = yes.
&endif

    &if defined (bf_mat_fech_estab) &then
    ON LEAVE of tt-digita.cod-estabel in browse br-digita do:
       find estabelec 
            where estabelec.cod-estabel = input browse br-digita tt-digita.cod-estabel
            no-lock no-error.
       if avail estabelec then do:
          assign tt-digita.nome:screen-value in browse br-digita = estabelec.nome.
          find estab-mat where estab-mat.cod-estabel = estabelec.cod-estabel
               no-lock no-error.
          if avail estab-mat then
             assign tt-digita.data-ini:screen-value in browse br-digita = 
                                       string(estab-mat.contab-ate + 1)
                    tt-digita.data-fim:screen-value in browse br-digita = 
                                       string(today).
       end.
    END.
    &endif

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects C-Win  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available C-Win  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI C-Win  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
  THEN DELETE WIDGET C-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI C-Win  _DEFAULT-ENABLE
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
  ENABLE im-pg-dig im-pg-imp im-pg-par im-pg-sel bt-executar bt-cancelar 
         bt-ajuda 
      WITH FRAME f-relat IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-f-relat}
  DISPLAY c-est-ini da-data-ini da-data-fim i-emi-ini i-emi-fim c-serie-ini 
          c-serie-fim c-nro-ini c-nro-fim c-nat-ini c-nat-fim i-esp-ini 
          i-esp-fim c-it-ini c-it-fim i-ge-ini i-ge-fim 
      WITH FRAME f-pg-sel IN WINDOW C-Win.
  ENABLE c-est-ini da-data-ini da-data-fim i-emi-ini i-emi-fim c-serie-ini 
         c-serie-fim c-nro-ini c-nro-fim c-nat-ini c-nat-fim i-esp-ini 
         i-esp-fim c-it-ini c-it-fim i-ge-ini i-ge-fim 
      WITH FRAME f-pg-sel IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-sel}
  ENABLE br-digita bt-inserir bt-alterar bt-retirar bt-salvar bt-recuperar 
      WITH FRAME f-pg-dig IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-dig}
  DISPLAY rs-destino c-arquivo rs-execucao 
      WITH FRAME f-pg-imp IN WINDOW C-Win.
  ENABLE RECT-7 RECT-9 rs-destino bt-config-impr bt-arquivo c-arquivo 
         rs-execucao 
      WITH FRAME f-pg-imp IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-imp}
  DISPLAY l-troca-saldo c-ct-atual c-ct-nova c-sc-atual c-sc-nova 
          c-cod-unid-negoc-atual c-cod-unid-negoc-nova 
      WITH FRAME f-pg-par IN WINDOW C-Win.
  ENABLE RECT-10 c-ct-atual c-ct-nova c-sc-atual c-sc-nova 
         c-cod-unid-negoc-atual c-cod-unid-negoc-nova 
      WITH FRAME f-pg-par IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-par}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit C-Win 
PROCEDURE local-exit :
/* -----------------------------------------------------------
  Purpose:  Starts an "exit" by APPLYing CLOSE event, which starts "destroy".
  Parameters:  <none>
  Notes:    If activated, should APPLY CLOSE, *not* dispatch adm-exit.   
-------------------------------------------------------------*/
   APPLY "CLOSE":U TO THIS-PROCEDURE.

   /* Elimina handle's */
   if valid-handle(h_api_cta_ctbl) then
     delete object h_api_cta_ctbl.
   if valid-handle(h_api_ccusto) then
     delete object h_api_ccusto.

   RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-executar C-Win 
PROCEDURE pi-executar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
define var r-tt-digita as rowid no-undo.

do  on error undo, return error
    on stop  undo, return error:     

    {include/i-rpexa.i}

    if  input frame f-pg-imp rs-destino = 2 then do:
        run utp/ut-vlarq.p (input input frame f-pg-imp c-arquivo).
        if  return-value = "nok" then do:
            run utp/ut-msgs.p (input "show",
                               input 73,
                               input "").
            apply 'mouse-select-click' to im-pg-imp in frame f-relat.
            apply 'entry' to c-arquivo in frame f-pg-imp.
            return error.
        end.
    end.

    /* Coloque aqui as valida‡äes das outras p ginas, lembrando que elas
       devem apresentar uma mensagem de erro cadastrada, posicionar na p gina 
       com problemas e colocar o focus no campo com problemas             */

    assign c-ct-codigo = input frame f-pg-par c-ct-atual.

    find first param-global no-lock no-error.
    find first param-estoq  no-lock no-error.

    assign i-empresa = param-global.empresa-prin.

    &if defined (bf_dis_consiste_conta) &then

        find estabelec where
             estabelec.cod-estabel = c-est-ini:screen-value in frame f-pg-sel no-lock no-error.

        run cdp/cd9970.p (input rowid(estabelec),
                          output i-empresa).
    &endif
/* inicio */
        IF  (input frame f-pg-par c-ct-nova = "" OR
             input frame f-pg-par c-ct-nova = "99999999" OR
             INPUT FRAME f-pg-par c-ct-atual = "" OR 
             INPUT FRAME f-pg-par c-ct-atual = "99999999") THEN DO:
            run utp/ut-msgs.p (input "show",input 3960,input "").
            apply 'entry' to c-ct-nova in frame f-pg-par.
            return 'adm-error'.
        END.

        IF  input frame f-pg-par c-ct-nova <> "" THEN DO:
            assign c-ct-nova:format in frame f-pg-par = "x(20)".
            ASSIGN v_cod_cta_ctbl = input frame f-pg-par c-ct-nova.
    /*        assign c-ct-nova:format in frame f-pg-par = c-formato-conta.*/

            IF valid-handle(h_api_ccusto) THEN RUN pi_busca_plano_ccusto_empresa IN h_api_ccusto (INPUT  i-empresa /*v_cod_empres_usuar*/ ,
                                                                                                  INPUT  TODAY,
                                                                                                  OUTPUT p_cod_plano_ccusto,
                                                                                                  OUTPUT TABLE tt_log_erro).

            IF valid-handle(h_api_cta_ctbl) THEN RUN pi_busca_plano_cta_ctbl_empresa IN h_api_cta_ctbl (INPUT  i-empresa /*v_cod_empres_usuar*/ ,
                                                                                                        INPUT  TODAY,
                                                                                                        OUTPUT p_cod_plano_cta_ctbl,
                                                                                                        OUTPUT TABLE tt_log_erro).

            run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (input        i-empresa,          /* EMPRESA EMS2 */
                                                            input        p_cod_plano_cta_ctbl,                 /* PLANO DE CONTAS */
                                                            input-output v_cod_cta_ctbl,     /* CONTA */
                                                            input        today,       /* DATA TRANSACAO */   
                                                            output       v_titulo_cta_ctbl,  /* DESCRICAO CONTA */
                                                            output       v_num_tip_cta_ctbl, /* TIPO DA CONTA */
                                                            output       v_num_sit_cta_ctbl, /* SITUA°€O DA CONTA */
                                                            output       v_ind_finalid_cta,  /* FINALIDADES DA CONTA */
                                                            output table tt_log_erro).       /* ERROS */
             /* Erros Conta Contÿbil */
             FIND FIRST tt_log_erro NO-LOCK NO-ERROR.
             IF AVAIL tt_log_erro THEN DO:
                run utp/ut-msgs.p (input "show", input 17006, STRING(tt_log_erro.ttv_des_msg_erro) + ' ('  + string(tt_log_erro.ttv_num_cod_erro) + ')' + "~~" + tt_log_erro.ttv_des_msg_ajuda).
                apply 'entry' to c-ct-nova in frame f-pg-par.
                return 'adm-error'.
             END.

             if  v_num_sit_cta_ctbl <> 3 then do:
                 run utp/ut-msgs.p (input "show",input 443,input "").
                 apply 'entry' to c-ct-nova in frame f-pg-par.
                 return 'adm-error'.
             end.              
             if lookup({adinc/i05ad049.i 4 4}, v_ind_finalid_cta) <> 0 or
                lookup({adinc/i05ad049.i 4 7}, v_ind_finalid_cta) <> 0 or
                lookup({adinc/i05ad049.i 4 8}, v_ind_finalid_cta) <> 0 or
                lookup({adinc/i05ad049.i 4 9}, v_ind_finalid_cta) <> 0 then do:
             /*
                conta -contab.estoque = 4 or conta -contab.estoque = 7 or 
                conta -contab.estoque = 8 or conta -contab.estoque = 9 or 
                conta -contab.estoque = 10                  then do: */
                  run utp/ut-msgs.p (input "show",input 1884,input "").
                  apply 'entry' to c-ct-nova in frame f-pg-par.
                  return 'adm-error'.
             end.
             if lookup({adinc/i05ad049.i 4 10}, v_ind_finalid_cta) <> 0 then do:
                 run utp/ut-msgs.p (input "show",input 445,input "").
                 apply 'entry' to c-ct-nova in frame f-pg-par.
                 return 'adm-error'.
             end.      
             if lookup({adinc/i05ad049.i 4 5}, v_ind_finalid_cta) <> 0 then do:
                 run utp/ut-msgs.p (input "show",input 8629,input "").
                 apply 'entry' to c-ct-nova in frame f-pg-par.
                 return 'adm-error'.
             end.
             if  lookup({adinc/i05ad049.i 4 9}, v_ind_finalid_cta) <> 0 and 
                 l-troca-saldo:checked in frame f-pg-par = NO then do:
                 run utp/ut-msgs.p (input "show",
                                    input 1784,
                                    input "").
                apply 'entry' to c-ct-nova in frame f-pg-par.                   
                return error.
             end.
            if  lookup({adinc/i05ad049.i 4 9}, v_ind_finalid_cta) <> 0 and
                 l-troca-saldo:checked in frame f-pg-par = yes then do:
                 run utp/ut-msgs.p (input "show",
                                    input 4048,
                                    input "").
                 apply 'entry' to c-ct-nova in frame f-pg-par.                   
                 return error.
             end.
        END.

        assign v_cod_ccusto = input FRAME f-pg-par c-sc-nova.

        IF  input FRAME f-pg-par c-sc-nova <> "" THEN DO:
            /* Verifica se a conta utiliza centro de custo */
            run pi_verifica_utilizacao_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS 2 */
                                                               input  c-est-ini:screen-value in frame f-pg-sel,        /* ESTABELECIMENTO EMS2 */
                                                               input  p_cod_plano_ccusto,                 /* PLANO CONTAS */
                                                               input  v_cod_cta_ctbl,     /* CONTA */
                                                               input  today,       /* DT TRANSACAO */
                                                               output v_log_utz_ccusto,   /* UTILIZA CCUSTO ? */
                                                               output table tt_log_erro). /* ERROS */           
            IF  NOT v_log_utz_ccusto THEN DO:
                 RUN utp/ut-msgs.p (INPUT "show",
                                    INPUT 17006,
                                    INPUT "Conta nÆo utiliza centro de custo. Mantenha o centro de custo em branco").
                 apply 'entry' to c-sc-nova in frame f-pg-par.
                 return 'adm-error'.
             END.

             run pi_busca_dados_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS2 */
                                                        input  p_cod_plano_ccusto, /* CODIGO DO PLANO CCUSTO */
                                                        input  v_cod_ccusto,       /* CCUSTO */
                                                        input  TODAY,       /* DATA DE TRANSACAO */
                                                        output v_titulo_ccusto,    /* DESCRICAO DO CCUSTO */
                                                        output table tt_log_erro). /* ERROS */
             FIND FIRST tt_log_erro NO-LOCK NO-ERROR.
             IF AVAIL tt_log_erro THEN DO:
                run utp/ut-msgs.p (input "show", input 17006, STRING(tt_log_erro.ttv_des_msg_erro) + ' ('  + string(tt_log_erro.ttv_num_cod_erro) + ')' + "~~" + tt_log_erro.ttv_des_msg_ajuda).
                apply 'entry' to c-sc-nova in frame f-pg-par.
                return 'adm-error'.
             END.                                               
         END.

         if not can-find (first unid-negoc
                          where unid-negoc.cod-unid-negoc = input frame f-pg-par c-cod-unid-negoc-nova) then do:
             {utp/ut-table.i mgind unid-negoc 1}
             run utp/ut-msgs.p (input "show", 
                                input 2, 
                                input return-value + '~~' + c-cod-unid-negoc-nova:screen-value in frame f-pg-par).
             apply 'entry' to c-cod-unid-negoc-nova in frame f-pg-par.
             return 'adm-error'.
         end.
         
         ASSIGN v_cod_unid_negoc = INPUT FRAME f-pg-par c-cod-unid-negoc-nova.

         RUN pi_valida_conta_contabil in h_api_cta_ctbl (INPUT  i-empresa,           /* EMPRESA EMS2 */
                                                         INPUT  c-est-ini:screen-value in frame f-pg-sel,                /* ESTABELECIMENTO EMS2 */
                                                         INPUT  v_cod_unid_negoc,  /* UNIDADE NEG…CIO */
                                                         INPUT  p_cod_plano_cta_ctbl,         /* PLANO CONTAS */ 
                                                         INPUT  v_cod_cta_ctbl,    /* CONTA */
                                                         INPUT  p_cod_plano_ccusto,           /* PLANO CCUSTO */ 
                                                         INPUT  v_cod_ccusto,    /* CCUSTO */
                                                         INPUT  TODAY,                        /* DATA TRANSACAO */
                                                         OUTPUT TABLE tt_log_erro).           /* ERROS */
         FIND FIRST tt_log_erro NO-LOCK NO-ERROR.
         IF AVAIL tt_log_erro THEN DO:
             RUN utp/ut-msgs.p (INPUT "show",
                                INPUT 17006,
                                INPUT tt_log_erro.ttv_des_msg_ajuda  + "~~" + tt_log_erro.ttv_des_msg_erro).
             apply 'entry' to c-ct-nova in frame f-pg-par.
             return 'adm-error'.
         END.


/* Fim */
    for each tt-digita no-lock:
        assign r-tt-digita = rowid(tt-digita).

        /* Valida‡Æo de duplicidade de registro na temp-table tt-digita */
        find first b-tt-digita where b-tt-digita.cod-estabel = tt-digita.cod-estabel and 
                                     rowid(b-tt-digita) <> rowid(tt-digita) no-lock no-error.
        if avail b-tt-digita then do:
            apply "MOUSE-SELECT-CLICK":U to im-pg-dig in frame f-relat.
            reposition br-digita to rowid rowid(b-tt-digita).

            run utp/ut-msgs.p (input "show", input 108, input "").
            apply "ENTRY":U to tt-digita.cod-estabel in browse br-digita.
            return error.
        end.

        /* As demais valida‡äes devem ser feitas aqui */
        if not can-find(estabelec where estabelec.cod-estabel = tt-digita.cod-estabel)
        then do:        
            apply "MOUSE-SELECT-CLICK":U to im-pg-dig in frame f-relat.
            reposition br-digita to rowid r-tt-digita.

            {utp/ut-table.i mgadm estabelec 1}
            run utp/ut-msgs.p (input "show", input 2, input return-value).
            apply "ENTRY":U to tt-digita.cod-estabel in browse br-digita.
            return error.
        end.

       &if defined(bf_mat_fech_estab) &then
        find estab-mat where estab-mat.cod-estabel = tt-digita.cod-estabel 
             no-lock no-error.
        if  avail estab-mat
            and  estab-mat.contab-ate  >= tt-digita.data-ini then 
        do:
            apply "MOUSE-SELECT-CLICK":U to im-pg-dig in frame f-relat.
            reposition br-digita to rowid r-tt-digita.
            run utp/ut-msgs.p (input "show",
                               input 4025,
                               input "").
            apply "ENTRY":U to tt-digita.cod-estabel in browse br-digita.
            return error.
        end.
       &endif
    end.

    if not l-fech-estab then
     if input frame f-pg-sel da-data-ini <= param-estoq.contab-ate then do:
        run utp/ut-msgs.p (input "show",
                           input 4025,
                           input "").
        apply 'mouse-select-click' to im-pg-sel  in frame f-relat.
        apply 'entry' to da-data-ini in frame f-pg-sel.                   
        return error.
     end.

    create tt-param.
    assign tt-param.usuario         = c-seg-usuario
           tt-param.destino         = input frame f-pg-imp rs-destino
           tt-param.data-exec       = today
           tt-param.hora-exec       = time 
           tt-param.c-ct-atual      = input frame f-pg-par c-ct-atual 
           tt-param.c-ct-nova       = input frame f-pg-par c-ct-nova 
           tt-param.c-sc-atual      = INPUT FRAME f-pg-par c-sc-atual
           tt-param.c-sc-nova       = INPUT FRAME f-pg-par c-sc-nova
           tt-param.c-cod-unid-negoc-atual = INPUT FRAME f-pg-par c-cod-unid-negoc-atual
           tt-param.c-cod-unid-negoc-nova  = INPUT FRAME f-pg-par c-cod-unid-negoc-nova
           tt-param.troca-saldo     = input frame f-pg-par l-troca-saldo
           tt-param.da-data-ini     = input frame f-pg-sel da-data-ini    
           tt-param.da-data-fim     = input frame f-pg-sel da-data-fim
           tt-param.i-emi-ini       = input frame f-pg-sel i-emi-ini
           tt-param.i-emi-fim       = input frame f-pg-sel i-emi-fim 
           tt-param.c-serie-ini     = input frame f-pg-sel c-serie-ini
           tt-param.c-serie-fim     = input frame f-pg-sel c-serie-fim
           tt-param.c-nro-ini       = input frame f-pg-sel c-nro-ini
           tt-param.c-nro-fim       = input frame f-pg-sel c-nro-fim
           tt-param.c-nat-ini       = input frame f-pg-sel c-nat-ini
           tt-param.c-nat-fim       = input frame f-pg-sel c-nat-fim 
           tt-param.i-esp-ini       = input frame f-pg-sel i-esp-ini 
           tt-param.i-esp-fim       = input frame f-pg-sel i-esp-fim  
           tt-param.c-est-ini       = input frame f-pg-sel c-est-ini 
           tt-param.c-est-fim       = input frame f-pg-sel c-est-ini
           tt-param.c-it-ini        = input frame f-pg-sel c-it-ini
           tt-param.c-it-fim        = input frame f-pg-sel c-it-fim
           tt-param.i-ge-ini        = input frame f-pg-sel i-ge-ini
           tt-param.i-ge-fim        = input frame f-pg-sel i-ge-fim.

    if  tt-param.destino = 1 then           
        assign tt-param.arquivo = "".
    else
    if  tt-param.destino = 2 then 
        assign tt-param.arquivo = input frame f-pg-imp c-arquivo.
    else
        assign tt-param.arquivo = session:temp-directory + c-programa-mg97 + ".tmp".

    /* Coloque aqui a l¢gica de grava‡Æo dos parƒmtros e sele‡Æo na temp-table
       tt-param */ 
    
    {include/i-rpexb.i}

    if  session:set-wait-state("general") then.

    {include/i-rprun.i esp/cep/escep0998rp.p}

    {include/i-rpexc.i}

    if  session:set-wait-state("") then.

    {include/i-rptrm.i}
end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-troca-pagina C-Win 
PROCEDURE pi-troca-pagina :
/*------------------------------------------------------------------------------
  Purpose: Gerencia a Troca de P gina (folder)   
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{include/i-rptrp.i}



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records C-Win  _ADM-SEND-RECORDS
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
  {src/adm/template/snd-list.i "emitente"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed C-Win 
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

