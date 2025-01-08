&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
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
{include/i-prgvrs.i esccp032 2.00.01.021}  /*** 010121 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i esccp032 MCD}
&ENDIF

{cdp/cdcfgman.i}
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
&GLOBAL-DEFINE PGCLA f-pg-cla
&GLOBAL-DEFINE PGPAR f-pg-par
&GLOBAL-DEFINE PGDIG f-pg-dig
&GLOBAL-DEFINE PGIMP f-pg-imp

/* Parameters Definitions ---                                           */

/* Temporary Table Definitions ---                                      */

define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(30)"
    field usuario          as char format "x(12)"
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer 
    field c-estab-ini      as char
    field c-estab-fim      as char
    field i-linha-ini      as integer
    field i-linha-fim      as integer
    field c-item-ini       as char
    field c-item-fim       as char
    field c-fami-ini       as char
    field c-fami-fim       as char
    field c-plan-ini       as char
    field c-plan-fim       as char
    field i-ge-ini         as integer
    field i-ge-fim         as integer
    field c-comp-ini       as char
    field c-comp-fim       as char
    &IF defined(bf_man_206b) &THEN
        field c-cod-unid-negoc-ini      as char
        field c-cod-unid-negoc-fim      as char
    &ENDIF
    field c-ci-estab-ini   as char
    field c-ci-estab-fim   as char
    field i-ci-linha-ini   as integer
    field i-ci-linha-fim   as integer
    field c-ci-item-ini    as char
    field c-ci-item-fim    as char
    field c-ci-fami-ini    as char
    field c-ci-fami-fim    as char
    field c-ci-plan-ini    as char
    field c-ci-plan-fim    as char
    field i-ci-ge-ini      as integer
    field i-ci-ge-fim      as integer
    field c-ci-comp-ini    as char
    field c-ci-comp-fim    as char
    &IF defined(bf_man_206b) &THEN
        field c-ci-cod-unid-negoc-ini      as char
        field c-ci-cod-unid-negoc-fim      as char
    &ENDIF
    FIELD apenas-oem       AS LOGICAL
    field l-comprado       as logical
    field l-fabricado      as logical
    field da-corte         as date
    field da-op-corte      as date
    field l-planejada      as logical
    field l-ord-com        as logical
    field l-ord-prod       as logical
    field l-res-com        as logical
    field l-res-pla        as logical
    field l-sld-est        as logical
    field l-sld-ter        as logical
    field l-ped-crt        as logical
    field l-it-sem-mov     as logical
    field l-componente     as logical
    field l-deposito       as logical
    field i-niveis         as integer
    field l-cred-aprov     as logical
    field l-comp-fabr      as logical
    field l-comp-comp      as logical
    field l-remessa        as logical 
    field l-entrada        as logical
    field l-transfer       as logical
    field l-re-con         as logical
    field l-en-con         as logical
    field i-obsoleto       as integer
    field i-beneficio      as integer
    field i-tipo           as integer
    field i-formato        as integer
    field i-cod-plano      as integer
    field c-obsoleto       as char
    field c-beneficio      as char
    field c-tipo           as char
    field c-formato        as char
    field c-classe         as char
    field c-destino        as char
    field l-impr-parametro as logical.

define temp-table tt-digita NO-UNDO
    field c-it-codigo    like item.it-codigo
    field c-cod-refer    like ref-item.cod-refer
    field c-desc-item    like item.desc-item
    field fm-codigo      like item.fm-codigo
    field cd-planejado   like item.cd-planejado
    field ge-codigo      like item.ge-codigo
    field cod-comprado   like item.cod-comprado
    &IF defined(bf_man_206b) &THEN
        field cod-unid-negoc  as char
    &ENDIF
    field c-un           like item.un
    field l-dep          as logical
    field c-estab        as char
    field c-depos        as char.

def temp-table tt-depositos  NO-UNDO
    field cod-estabel like estabelec.cod-estabel
    field cod-depos like deposito.cod-depos.

define buffer b-tt-digita for tt-digita.

/* Transfer Definitions */

def var raw-param        as raw no-undo.

def temp-table tt-raw-digita NO-UNDO
   field raw-digita      as raw.

/* Local Variable Definitions ---                                       */

def var l-ok             as logical no-undo.
def var c-arq-digita     as char    no-undo.
def var c-terminal       as char    no-undo.
def var l-cancelar       as logical no-undo.
def var i-cont           as integer no-undo.
def var l-mouse          as logical no-undo.
def var l-erro           as logical no-undo.
def var r-tt-digita      as rowid   no-undo.

&IF "{&mguni_version}" >= "2.071" &THEN
def var p-ci-estab-ini   as char    no-undo format "x(5)"  init "104".
def var p-ci-estab-fim   as char    no-undo format "x(5)"  init "104".
&ELSE
def var p-ci-estab-ini   as char    no-undo format "x(3)"  init "104".
def var p-ci-estab-fim   as char    no-undo format "x(3)"  init "104".
&ENDIF

def var p-ci-linha-ini   as int     no-undo format ">>9"   init 0.
def var p-ci-linha-fim   as int     no-undo format ">>9"   init 999.
def var p-ci-item-ini    as char    no-undo format "x(16)" init "4000000".
def var p-ci-item-fim    as char    no-undo format "x(16)" init "4999999".
def var p-ci-fami-ini    as char    no-undo format "x(8)"  init "".
def var p-ci-fami-fim    as char    no-undo format "x(8)"  init "ZZZZZZZZ".
def var p-ci-plan-ini    as char    no-undo format "x(12)" init "".
def var p-ci-plan-fim    as char    no-undo format "x(12)" init "ZZZZZZZZZZZZ".
def var p-ci-ge-ini      as integer no-undo format "99"    init 0.
def var p-ci-ge-fim      as integer no-undo format "99"    init 99.
def var p-ci-comp-ini    as char    no-undo format "x(12)" init "".
def var p-ci-comp-fim    as char    no-undo format "x(12)" init "ZZZZZZZZZZZZ".
&IF defined(bf_man_206b) &THEN
    def var p-ci-cod-unid-negoc-ini     as char     no-undo format "x(3)"   init "".
    def var p-ci-cod-unid-negoc-fim     as char     no-undo format "x(3)"   init "ZZZ".
&ENDIF
def var p-cod-obsoleto   as integer no-undo format "9"     init 4.
def var p-cod-formato    as integer no-undo format "9"     init 1.
def var p-niveis         as integer no-undo format "99"    init 19.
def var p-plano          as integer no-undo format ">>9"   init 0.
def var p-corte          as date    no-undo format "99/99/9999" init 12/31/9999.
def var p-op-corte       as date    no-undo format "99/99/9999" init 12/31/9999.
def var p-obsoleto       as char    no-undo.
def var p-formato        as char    no-undo.
def var p-remessa        as logical no-undo init yes.
def var p-entrada        as logical no-undo .
def var p-transfer       as logical no-undo init yes.
def var p-re-con         as logical no-undo .
def var p-en-con         as logical no-undo init yes.
def var p-saldo          as logical no-undo.

&IF DEFINED(bf_man_206b) &THEN        
    DEF VAR h-cdapi024    AS HANDLE NO-UNDO.

&endif

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE w-relat
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-pg-cla
&Scoped-define BROWSE-NAME br-digita

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-digita

/* Definitions for BROWSE br-digita                                     */
&Scoped-define FIELDS-IN-QUERY-br-digita tt-digita.c-it-codigo tt-digita.c-cod-refer tt-digita.c-desc-item tt-digita.c-un   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-digita tt-digita.c-it-codigo ~
  tt-digita.c-cod-refer   
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
&Scoped-Define ENABLED-OBJECTS rs-classif 
&Scoped-Define DISPLAYED-OBJECTS rs-classif 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE VARIABLE rs-classif AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Item", 1,
"Fam¡lia", 2,
"Planejador", 3,
"Grupo de Estoque", 4,
"Comprador", 5,
"Descri‡Æo do Item", 6
     SIZE 40 BY 5.5 NO-UNDO.

DEFINE BUTTON bt-alterar 
     LABEL "&Alterar" 
     SIZE 15 BY 1.

DEFINE BUTTON bt-inserir 
     LABEL "&Inserir" 
     SIZE 15 BY 1.

DEFINE BUTTON bt-recuperar 
     LABEL "Re&cuperar" 
     SIZE 15 BY 1.

DEFINE BUTTON bt-retirar 
     LABEL "&Retirar" 
     SIZE 15 BY 1.

DEFINE BUTTON bt-salvar 
     LABEL "&Salvar" 
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

DEFINE RECTANGLE RECT-43
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.29 BY 1.71.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.29 BY 2.92.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.29 BY 1.71.

DEFINE VARIABLE l-impr-parametro AS LOGICAL INITIAL yes 
     LABEL "Imprime P gina de Parƒmetros" 
     VIEW-AS TOGGLE-BOX
     SIZE 35 BY .83 NO-UNDO.

DEFINE BUTTON bt-parametro 
     IMAGE-UP FILE "image\im-expan":U
     LABEL "" 
     SIZE 9.72 BY 1.08.

DEFINE VARIABLE i-cod-plano AS INTEGER FORMAT ">>9" INITIAL 4 
     LABEL "Plano":R7 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE txt-benef AS CHARACTER FORMAT "X(256)":U INITIAL "Ordem Compra Beneficiamento" 
      VIEW-AS TEXT 
     SIZE 30 BY .67 NO-UNDO.

DEFINE VARIABLE txt-componentes AS CHARACTER FORMAT "X(256)":U INITIAL "Componentes" 
      VIEW-AS TEXT 
     SIZE 14 BY .67 NO-UNDO.

DEFINE VARIABLE txt-lista AS CHARACTER FORMAT "X(256)":U INITIAL "Lista" 
      VIEW-AS TEXT 
     SIZE 7 BY .67 NO-UNDO.

DEFINE VARIABLE rs-beneficio AS INTEGER INITIAL 2 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Considera", 1,
"NÆo Considera", 2,
"Demonstra", 3
     SIZE 30 BY 2.5 NO-UNDO.

DEFINE VARIABLE rs-tipo AS INTEGER INITIAL 2 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Todos", 1,
"Abaixo ou Igual a Zero", 2,
"Abaixo de Seguran‡a", 3,
"Saldo Maior que Zero", 4
     SIZE 30 BY 3.38 NO-UNDO.

DEFINE RECTANGLE RECT-19
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 38.14 BY 1.42.

DEFINE RECTANGLE RECT-42
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 18.29 BY 1.58.

DEFINE RECTANGLE rt-beneficio
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 37.86 BY 3.17.

DEFINE RECTANGLE rt-lista
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 38.14 BY 4.13.

DEFINE VARIABLE l-comp-comp AS LOGICAL INITIAL no 
     LABEL "Comprados" 
     VIEW-AS TOGGLE-BOX
     SIZE 15 BY .75 NO-UNDO.

DEFINE VARIABLE l-comp-fabr AS LOGICAL INITIAL no 
     LABEL "Fabricados" 
     VIEW-AS TOGGLE-BOX
     SIZE 15 BY .75 NO-UNDO.

DEFINE VARIABLE l-componente AS LOGICAL INITIAL no 
     LABEL "Componentes do Item" 
     VIEW-AS TOGGLE-BOX
     SIZE 30 BY .75 NO-UNDO.

DEFINE VARIABLE l-comprado AS LOGICAL INITIAL yes 
     LABEL "Comprados" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .75 NO-UNDO.

DEFINE VARIABLE l-cred-aprov AS LOGICAL INITIAL yes 
     LABEL "Apenas Pedidos com Cr‚ditos Aprovados" 
     VIEW-AS TOGGLE-BOX
     SIZE 41 BY .75 NO-UNDO.

DEFINE VARIABLE l-deposito AS LOGICAL INITIAL no 
     LABEL "Informa Dep¢sitos" 
     VIEW-AS TOGGLE-BOX
     SIZE 30 BY .75 NO-UNDO.

DEFINE VARIABLE l-fabricado AS LOGICAL INITIAL yes 
     LABEL "Fabricados" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .75 NO-UNDO.

DEFINE VARIABLE l-it-sem-mov AS LOGICAL INITIAL no 
     LABEL "Itens sem Reservas/Ordens" 
     VIEW-AS TOGGLE-BOX
     SIZE 32 BY .75 NO-UNDO.

DEFINE VARIABLE l-ord-com AS LOGICAL INITIAL yes 
     LABEL "Ordens de Compra" 
     VIEW-AS TOGGLE-BOX
     SIZE 25 BY .75 NO-UNDO.

DEFINE VARIABLE l-ord-prod AS LOGICAL INITIAL yes 
     LABEL "Ordens de Produ‡Æo" 
     VIEW-AS TOGGLE-BOX
     SIZE 25 BY .75 NO-UNDO.

DEFINE VARIABLE l-ped-crt AS LOGICAL INITIAL yes 
     LABEL "Pedidos em Carteira" 
     VIEW-AS TOGGLE-BOX
     SIZE 25 BY .75 NO-UNDO.

DEFINE VARIABLE l-planejada AS LOGICAL INITIAL no 
     LABEL "Ordens Planejadas" 
     VIEW-AS TOGGLE-BOX
     SIZE 25 BY .75 NO-UNDO.

DEFINE VARIABLE l-res-com AS LOGICAL INITIAL yes 
     LABEL "Reservas Comprometidas" 
     VIEW-AS TOGGLE-BOX
     SIZE 30 BY .75 NO-UNDO.

DEFINE VARIABLE l-res-pla AS LOGICAL INITIAL yes 
     LABEL "Reservas Planejadas" 
     VIEW-AS TOGGLE-BOX
     SIZE 30 BY .75 NO-UNDO.

DEFINE VARIABLE l-sld-est AS LOGICAL INITIAL yes 
     LABEL "Saldos em Estoque" 
     VIEW-AS TOGGLE-BOX
     SIZE 25 BY .75 NO-UNDO.

DEFINE VARIABLE l-sld-ter AS LOGICAL INITIAL YES 
     LABEL "Saldo em Poder de Terceiros" 
     VIEW-AS TOGGLE-BOX
     SIZE 33 BY .75 NO-UNDO.

DEFINE BUTTON bt-selecao 
     IMAGE-UP FILE "image\im-expan":U
     LABEL "" 
     SIZE 10 BY 1.

DEFINE VARIABLE c-cod-unid-negoc-fim AS CHARACTER FORMAT "X(3)":U INITIAL "ZZZ" 
     VIEW-AS FILL-IN 
     SIZE 7.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-unid-negoc-ini AS CHARACTER FORMAT "X(3)":U 
     LABEL "Unid. Neg¢cio" 
     VIEW-AS FILL-IN 
     SIZE 7.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-comp-fim AS CHARACTER FORMAT "X(12)":U INITIAL "ZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE c-comp-ini AS CHARACTER FORMAT "X(12)":U 
     LABEL "Comprador" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE c-estab-fim AS CHARACTER FORMAT "X(3)":U INITIAL "104" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE c-estab-ini AS CHARACTER FORMAT "X(3)":U INITIAL "104" 
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE c-fami-fim AS CHARACTER FORMAT "X(8)":U INITIAL "ZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE c-fami-ini AS CHARACTER FORMAT "X(8)":U 
     LABEL "Fam¡lia" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE c-item-fim AS CHARACTER FORMAT "X(16)":U INITIAL "4999999" 
     VIEW-AS FILL-IN 
     SIZE 22 BY .88 NO-UNDO.

DEFINE VARIABLE c-item-ini AS CHARACTER FORMAT "X(16)":U INITIAL "4000000" 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 22 BY .88 NO-UNDO.

DEFINE VARIABLE c-plan-fim AS CHARACTER FORMAT "X(12)":U INITIAL "ZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE c-plan-ini AS CHARACTER FORMAT "X(12)":U 
     LABEL "Planejador" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE i-ge-fim AS INTEGER FORMAT ">9":U INITIAL 99 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE VARIABLE i-ge-ini AS INTEGER FORMAT ">9":U INITIAL 0 
     LABEL "Grupo Estoque" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE VARIABLE i-linha-fim AS INTEGER FORMAT ">>9":U INITIAL 999 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE i-linha-ini AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "Linha Produ‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE txt-item AS CHARACTER FORMAT "X(256)":U INITIAL "Sele‡Æo de Itens" 
      VIEW-AS TEXT 
     SIZE 17 BY .63 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-10
     FILENAME "image\im-las":U
     SIZE 3 BY .96.

DEFINE IMAGE IMAGE-11
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-12
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-13
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-14
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

DEFINE IMAGE IMAGE-3
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-4
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-5
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-6
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-7
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-8
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-9
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE RECTANGLE rt-selecao
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 73 BY 9.

DEFINE VARIABLE tg-pedidos-oem AS LOGICAL INITIAL yes 
     LABEL "Somente Pedidos de Venda OEM" 
     VIEW-AS TOGGLE-BOX
     SIZE 32 BY .83 NO-UNDO.

DEFINE BUTTON bt-ajuda 
     LABEL "&Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-cancelar AUTO-END-KEY 
     LABEL "&Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-executar 
     LABEL "&Executar" 
     SIZE 10 BY 1.

DEFINE IMAGE im-pg-cla
     FILENAME "image\im-fldup":U
     SIZE 15.72 BY 1.21.

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
     SIZE 79 BY 12.75
     FGCOLOR 0 .

DEFINE RECTANGLE rt-folder-left
     EDGE-PIXELS 0    
     SIZE .43 BY 12.63
     BGCOLOR 15 .

DEFINE RECTANGLE rt-folder-right
     EDGE-PIXELS 0    
     SIZE .43 BY 12.63
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
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-digita C-Win _FREEFORM
  QUERY br-digita DISPLAY
      tt-digita.c-it-codigo
      tt-digita.c-cod-refer
      tt-digita.c-desc-item
      tt-digita.c-un      
ENABLE
          tt-digita.c-it-codigo
          tt-digita.c-cod-refer
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS SIZE 75 BY 10
         BGCOLOR 15  ROW-HEIGHT-CHARS .58.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-relat
     bt-executar AT ROW 15.75 COL 3 HELP
          "Dispara a execu‡Æo do relat¢rio"
     bt-cancelar AT ROW 15.75 COL 14 HELP
          "Cancelar"
     bt-ajuda AT ROW 15.75 COL 70 HELP
          "Ajuda"
     RECT-1 AT ROW 15.54 COL 2
     RECT-6 AT ROW 15.21 COL 2.14
     rt-folder-right AT ROW 2.67 COL 80.43
     rt-folder-top AT ROW 2.54 COL 2.14
     rt-folder AT ROW 2.63 COL 2
     im-pg-cla AT ROW 1.5 COL 17.86
     im-pg-dig AT ROW 1.5 COL 49.29
     im-pg-imp AT ROW 1.5 COL 65
     im-pg-par AT ROW 1.5 COL 33.57
     im-pg-sel AT ROW 1.5 COL 2.14
     rt-folder-left AT ROW 2.54 COL 2.14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 81 BY 16.27
         DEFAULT-BUTTON bt-executar.

DEFINE FRAME f-pg-dig
     br-digita AT ROW 1.25 COL 2
     bt-inserir AT ROW 11.5 COL 2
     bt-alterar AT ROW 11.5 COL 17
     bt-retirar AT ROW 11.5 COL 32
     bt-salvar AT ROW 11.5 COL 47
     bt-recuperar AT ROW 11.5 COL 62
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 3
         SIZE 77 BY 12.

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
     l-impr-parametro AT ROW 7.75 COL 3
     text-destino AT ROW 1.63 COL 3.86 NO-LABEL
     text-modo AT ROW 5 COL 1.29 COLON-ALIGNED NO-LABEL
     "Parƒmetros de ImpressÆo" VIEW-AS TEXT
          SIZE 25 BY .67 AT ROW 7.04 COL 3.43
     RECT-43 AT ROW 7.29 COL 2.14
     RECT-7 AT ROW 1.92 COL 2.14
     RECT-9 AT ROW 5.29 COL 2.14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 3
         SIZE 77 BY 12.

DEFINE FRAME f-pg-cla
     rs-classif AT ROW 1.5 COL 2 HELP
          "Classifica‡Æo para emissÆo do relat¢rio" NO-LABEL
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 3
         SIZE 77 BY 11.79.

DEFINE FRAME f-pg-sel
     c-estab-ini AT ROW 2.75 COL 20 COLON-ALIGNED
     c-estab-fim AT ROW 2.75 COL 50 COLON-ALIGNED NO-LABEL
     i-linha-ini AT ROW 3.75 COL 20 COLON-ALIGNED
     i-linha-fim AT ROW 3.75 COL 50 COLON-ALIGNED NO-LABEL
     c-item-ini AT ROW 4.75 COL 20 COLON-ALIGNED
     c-item-fim AT ROW 4.75 COL 50 COLON-ALIGNED NO-LABEL
     c-fami-ini AT ROW 5.75 COL 20 COLON-ALIGNED
     c-fami-fim AT ROW 5.75 COL 50 COLON-ALIGNED NO-LABEL
     c-plan-ini AT ROW 6.75 COL 20 COLON-ALIGNED
     c-plan-fim AT ROW 6.75 COL 50 COLON-ALIGNED NO-LABEL
     i-ge-ini AT ROW 7.75 COL 20 COLON-ALIGNED
     i-ge-fim AT ROW 7.75 COL 50 COLON-ALIGNED NO-LABEL
     c-comp-ini AT ROW 8.75 COL 20 COLON-ALIGNED
     c-comp-fim AT ROW 8.75 COL 50 COLON-ALIGNED NO-LABEL
     c-cod-unid-negoc-ini AT ROW 9.75 COL 20 COLON-ALIGNED
     c-cod-unid-negoc-fim AT ROW 9.75 COL 50 COLON-ALIGNED NO-LABEL
     bt-selecao AT ROW 11.25 COL 3
     tg-pedidos-oem AT ROW 11.5 COL 30 WIDGET-ID 2
     txt-item AT ROW 1.75 COL 2 COLON-ALIGNED NO-LABEL
     IMAGE-1 AT ROW 2.75 COL 44
     IMAGE-10 AT ROW 4.75 COL 49
     IMAGE-11 AT ROW 5.75 COL 49
     IMAGE-12 AT ROW 6.75 COL 49
     IMAGE-13 AT ROW 7.75 COL 49
     IMAGE-14 AT ROW 8.75 COL 49
     IMAGE-2 AT ROW 2.75 COL 49
     IMAGE-3 AT ROW 3.75 COL 44
     IMAGE-4 AT ROW 4.75 COL 44
     IMAGE-5 AT ROW 5.75 COL 44
     IMAGE-6 AT ROW 6.75 COL 44
     IMAGE-7 AT ROW 7.75 COL 44
     IMAGE-8 AT ROW 8.75 COL 44
     IMAGE-9 AT ROW 3.75 COL 49
     rt-selecao AT ROW 2 COL 3
     IMAGE-21 AT ROW 9.75 COL 44
     IMAGE-22 AT ROW 9.75 COL 49
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 3
         SIZE 77 BY 11.75.

DEFINE FRAME f-pg-par
     l-comprado AT ROW 1.5 COL 3
     l-fabricado AT ROW 2.29 COL 3
     l-planejada AT ROW 3.08 COL 3
     l-ord-com AT ROW 3.92 COL 3
     l-ord-prod AT ROW 4.71 COL 3
     l-res-com AT ROW 5.5 COL 3
     l-res-pla AT ROW 6.29 COL 3
     l-sld-est AT ROW 7.08 COL 3
     l-sld-ter AT ROW 7.92 COL 3
     l-ped-crt AT ROW 8.71 COL 3
     l-it-sem-mov AT ROW 9.5 COL 3
     l-componente AT ROW 10.29 COL 3
     l-deposito AT ROW 11.08 COL 3
     l-cred-aprov AT ROW 11.92 COL 3
     rs-beneficio AT ROW 2 COL 41 NO-LABEL
     rs-tipo AT ROW 5.5 COL 41 NO-LABEL
     l-comp-fabr AT ROW 10 COL 40
     l-comp-comp AT ROW 9.96 COL 57.72
     i-cod-plano AT ROW 11.58 COL 53.14 COLON-ALIGNED
     bt-parametro AT ROW 11.5 COL 65.57
     txt-componentes AT ROW 9.21 COL 38.57 COLON-ALIGNED NO-LABEL
     txt-benef AT ROW 1.25 COL 39 COLON-ALIGNED NO-LABEL
     txt-lista AT ROW 4.71 COL 39 COLON-ALIGNED NO-LABEL
     RECT-19 AT ROW 9.46 COL 36.86
     RECT-42 AT ROW 11.17 COL 45.43
     rt-beneficio AT ROW 1.5 COL 37.14
     rt-lista AT ROW 5 COL 36.86
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 3
         SIZE 77 BY 12.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: w-relat
   Allow: Basic,Browse,DB-Fields,Window,Query
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Simula‡Æo de Estoque"
         HEIGHT             = 16.33
         WIDTH              = 81.14
         MAX-HEIGHT         = 27.96
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 27.96
         VIRTUAL-WIDTH      = 146.29
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
/* SETTINGS FOR FRAME f-pg-cla
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME f-pg-dig
                                                                        */
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
   Custom                                                               */
/* SETTINGS FOR FILL-IN txt-benef IN FRAME f-pg-par
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       txt-benef:PRIVATE-DATA IN FRAME f-pg-par     = 
                "Ordem Compra Beneficiamento".

/* SETTINGS FOR FILL-IN txt-componentes IN FRAME f-pg-par
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       txt-componentes:PRIVATE-DATA IN FRAME f-pg-par     = 
                "Componentes".

/* SETTINGS FOR FILL-IN txt-lista IN FRAME f-pg-par
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       txt-lista:PRIVATE-DATA IN FRAME f-pg-par     = 
                "Lista".

/* SETTINGS FOR FRAME f-pg-sel
                                                                        */
/* SETTINGS FOR FILL-IN c-cod-unid-negoc-fim IN FRAME f-pg-sel
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       c-cod-unid-negoc-fim:HIDDEN IN FRAME f-pg-sel           = TRUE.

/* SETTINGS FOR FILL-IN c-cod-unid-negoc-ini IN FRAME f-pg-sel
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       c-cod-unid-negoc-ini:HIDDEN IN FRAME f-pg-sel           = TRUE.

/* SETTINGS FOR IMAGE IMAGE-21 IN FRAME f-pg-sel
   NO-ENABLE                                                            */
ASSIGN 
       IMAGE-21:HIDDEN IN FRAME f-pg-sel           = TRUE.

/* SETTINGS FOR IMAGE IMAGE-22 IN FRAME f-pg-sel
   NO-ENABLE                                                            */
ASSIGN 
       IMAGE-22:HIDDEN IN FRAME f-pg-sel           = TRUE.

/* SETTINGS FOR FILL-IN txt-item IN FRAME f-pg-sel
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       txt-item:PRIVATE-DATA IN FRAME f-pg-sel     = 
                "Sele‡Æo de Itens".

/* SETTINGS FOR FRAME f-relat
                                                                        */
/* SETTINGS FOR RECTANGLE RECT-1 IN FRAME f-relat
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE RECT-6 IN FRAME f-relat
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rt-folder IN FRAME f-relat
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
     _Query            is NOT OPENED
*/  /* FRAME f-pg-sel */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Simula‡Æo de Estoque */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Simula‡Æo de Estoque */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-digita
&Scoped-define FRAME-NAME f-pg-dig
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
        if  avail tt-digita then do:
            delete tt-digita.
            end.
        if  br-digita:delete-current-row() in frame f-pg-dig then.
    end.
    else do:
        get current br-digita.
        display tt-digita.c-it-codigo
                tt-digita.c-desc-item
                tt-digita.c-un with browse br-digita.
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
ON ROW-LEAVE OF br-digita IN FRAME f-pg-dig
DO: 
   assign l-mouse = no.
   if not valid-handle (wh-pesquisa) and num-results("br-digita") > 0 then do:
      if  br-digita:new-row in frame f-pg-dig then do on error undo, return no-apply:
          if  can-find(b-tt-digita
                  where b-tt-digita.c-it-codigo = tt-digita.c-it-codigo:screen-value
                                                  in browse br-digita
                    and b-tt-digita.c-cod-refer = tt-digita.c-cod-refer:screen-value
                                                  in browse br-digita) THEN DO:
              run utp/ut-msgs.p (input "show", input 108, input "").
              apply "ENTRY":U to tt-digita.c-it-codigo in browse br-digita.
              return no-apply.
          end.
          else 
             run pi-cria-tt-digita.

  end.
  ELSE
     run pi-verifica-tt-digita.


  if br-digita:new-row then br-digita:create-result-list-entry() in frame f-pg-dig.
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
   apply 'entry' to tt-digita.c-it-codigo in browse br-digita. 
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
           bt-salvar:SENSITIVE in frame f-pg-dig  = YES.


    if num-results("br-digita") > 0 then
        br-digita:INSERT-ROW("after") in frame f-pg-dig.
    else do transaction:
        create tt-digita.

        open query br-digita for each tt-digita NO-LOCK.

        apply 'entry' to tt-digita.c-it-codigo in browse br-digita. 
    end.

/*******************************************************************
    if  num-results('br-digita') > 0 then do:
        if  br-digita:insert-row('after') in frame f-pg-dig then.
    end.
    else do transaction:
        create tt-digita.
        open query br-digita
             for each tt-digita.
        apply 'entry' to tt-digita.c-it-codigo in browse br-digita. 
    end.
*********************************************************************/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-par
&Scoped-define SELF-NAME bt-parametro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-parametro C-Win
ON CHOOSE OF bt-parametro IN FRAME f-pg-par
DO:
  assign p-saldo = input frame {&frame-name} l-sld-ter. 


  IF p-saldo = NO THEN
     assign p-remessa   = NO
            p-entrada   = NO 
            p-transfer  = NO
            p-re-con    = NO
            p-en-con    = NO.

  run esp/ccp/esccp032b1.w (input-output p-cod-obsoleto,
                            input-output p-cod-formato,
                            input-output p-niveis,
                            input-output p-corte,
                            input-output p-op-corte,
                                  output p-obsoleto,
                            INPUT-output p-formato,
                            input-output p-remessa,
                            input-output p-entrada,
                            input-output p-transfer,
                            input-output p-re-con,
                            input-output p-en-con,
                                  input  p-saldo).



END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-dig
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


/*******************************************************************************
    if  br-digita:num-selected-rows > 0 then do on error undo, return no-apply:
        get current br-digita.
        delete tt-digita.
        if  br-digita:delete-current-row() in frame f-pg-dig then.
    end.

    if not available {&first-table-in-query-{&browse-name}} then disable bt-alterar bt-retirar bt-salvar with frame f-pg-dig.

********************************************************************************/
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


&Scoped-define FRAME-NAME f-pg-sel
&Scoped-define SELF-NAME bt-selecao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-selecao C-Win
ON CHOOSE OF bt-selecao IN FRAME f-pg-sel
DO:
  run esp/ccp/esccp032a1.w (input-output p-ci-estab-ini,
                            input-output p-ci-estab-fim, 
                            input-output p-ci-linha-ini, 
                            input-output p-ci-linha-fim,
                            input-output p-ci-item-ini, 
                            input-output p-ci-item-fim, 
                            input-output p-ci-fami-ini, 
                            input-output p-ci-fami-fim, 
                            input-output p-ci-plan-ini, 
                            input-output p-ci-plan-fim, 
                            input-output p-ci-ge-ini,   
                            input-output p-ci-ge-fim, 
                            input-output p-ci-comp-ini,
                            input-output p-ci-comp-fim
                            &IF defined(bf_man_206b) &THEN
                               ,input-output p-ci-cod-unid-negoc-ini,
                                input-output p-ci-cod-unid-negoc-fim
                            &ENDIF
                            ).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-relat
&Scoped-define SELF-NAME im-pg-cla
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL im-pg-cla C-Win
ON MOUSE-SELECT-CLICK OF im-pg-cla IN FRAME f-relat
DO:
    run pi-troca-pagina.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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
    assign l-planejada:sensitive  in frame f-pg-par = param-global.modulo-pl
           l-res-pla:sensitive    in frame f-pg-par = param-global.modulo-pl
           l-comp-fabr:sensitive  in frame f-pg-par = l-componente:checked in frame f-pg-par
           l-comp-comp:sensitive  in frame f-pg-par = l-componente:checked in frame f-pg-par
           l-cred-aprov:sensitive in frame f-pg-par = l-ped-crt:checked    in frame f-pg-par.

    run pi-seta-plano.

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


&Scoped-define FRAME-NAME f-pg-par
&Scoped-define SELF-NAME l-componente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-componente C-Win
ON VALUE-CHANGED OF l-componente IN FRAME f-pg-par /* Componentes do Item */
DO:
  assign l-comp-fabr:sensitive in frame f-pg-par = l-componente:checked in frame f-pg-par
         l-comp-fabr:checked   in frame f-pg-par = l-componente:checked in frame f-pg-par
         l-comp-comp:sensitive in frame f-pg-par = l-componente:checked in frame f-pg-par
         l-comp-comp:checked   in frame f-pg-par = l-componente:checked in frame f-pg-par.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME l-deposito
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-deposito C-Win
ON VALUE-CHANGED OF l-deposito IN FRAME f-pg-par /* Informa Dep¢sitos */
DO:
  assign l-cancelar = no.
  if  input frame f-pg-par l-deposito = yes then do:
      run cdp/cd0284b1.w (input-output table tt-depositos, output l-cancelar).

      if  l-cancelar then
          for each tt-depositos NO-LOCK:
              delete tt-depositos.
          end.
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME l-ord-com
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-ord-com C-Win
ON VALUE-CHANGED OF l-ord-com IN FRAME f-pg-par /* Ordens de Compra */
DO:
  if  l-ord-com:checked in frame f-pg-par = no then
      assign rs-beneficio:screen-value in frame f-pg-par = "2".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME l-ped-crt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-ped-crt C-Win
ON VALUE-CHANGED OF l-ped-crt IN FRAME f-pg-par /* Pedidos em Carteira */
DO:
  assign l-cred-aprov:sensitive in frame f-pg-par = l-ped-crt:checked in frame f-pg-par
         l-cred-aprov:checked   in frame f-pg-par = l-ped-crt:checked in frame f-pg-par.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME l-planejada
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-planejada C-Win
ON VALUE-CHANGED OF l-planejada IN FRAME f-pg-par /* Ordens Planejadas */
DO:
  if input frame f-pg-par l-planejada or 
     input frame f-pg-par l-res-pla   then 
     enable i-cod-plano with frame f-pg-par.
  else 
     disable i-cod-plano with frame f-pg-par.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME l-res-pla
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-res-pla C-Win
ON VALUE-CHANGED OF l-res-pla IN FRAME f-pg-par /* Reservas Planejadas */
DO:
  if input frame f-pg-par l-planejada or 
     input frame f-pg-par l-res-pla   then 
     enable i-cod-plano with frame f-pg-par.
  else 
     disable i-cod-plano with frame f-pg-par.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME l-sld-ter
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-sld-ter C-Win
ON VALUE-CHANGED OF l-sld-ter IN FRAME f-pg-par /* Saldo em Poder de Terceiros */
DO:
  IF l-sld-ter:CHECKED IN FRAME {&FRAME-NAME} = NO THEN
         assign p-remessa   = NO
                p-entrada   = NO 
                p-transfer  = NO
                p-re-con    = NO
                p-en-con    = NO.
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


&Scoped-define FRAME-NAME f-pg-cla
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

{utp/ut9000.i "esccp032" "2.00.01.021"}

/* inicializa‡äes do template de relat¢rio */
{include/i-rpini.i}

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

on f5                    of tt-digita.c-it-codigo in browse br-digita
or mouse-select-dblclick of tt-digita.c-it-codigo in browse br-digita do:
    RUN pi-f5-it-codigo.
               
end.

on f5                    of tt-digita.c-cod-refer in browse br-digita
or mouse-select-dblclick of tt-digita.c-cod-refer in browse br-digita do:
   run pi-f5-refer.
end.

on leave of tt-digita.c-it-codigo in browse br-digita do:
   IF NUM-RESULTS("br-digita") > 0 THEN DO:

       find item where item.it-codigo = 
                 tt-digita.c-it-codigo:screen-value in browse br-digita no-lock no-error.
       if  avail item then do:

           ASSIGN  tt-digita.c-desc-item:SCREEN-VALUE = ITEM.desc-item 
                   tt-digita.c-un:SCREEN-VALUE = ITEM.un 
                   tt-digita.c-desc-item = ITEM.desc-item
                   tt-digita.c-un = ITEM.un NO-ERROR.               
       end.
       else do:
           run utp/ut-msgs.p (input 'show', input 56, input return-value).

           apply "ENTRY" to tt-digita.c-it-codigo in browse br-digita.
           RETURN NO-APPLY.       
       end.
   END.
end.        

on leave of tt-digita.c-cod-refer in browse br-digita do:
    IF NUM-RESULTS("br-digita") > 0 THEN DO:
        run pi-leave-refer.
       IF RETURN-VALUE = "NOK":U THEN
          RETURN NO-APPLY.
    END.
end.   

on mouse-select-click of tt-digita.c-it-codigo in browse br-digita or
   mouse-select-click of tt-digita.c-cod-refer in browse br-digita do:
   assign l-mouse = yes.
end.

{utp/ut-liter.i Ativos * C}
assign p-formato  = "->>>>>>,>>9.9999"
       p-obsoleto = return-value.

/*** Desativa o c¢digo do plano se nÆo setar l-planejada e l-res-pla ***/

  if not l-planejada and not l-res-pla then 
     assign i-cod-plano:sensitive in frame f-pg-par = no.
  else 
     assign i-cod-plano:sensitive in frame f-pg-par = yes.

/****** Fim *****/

{include/i-rplbl.i}

RUN pi-main IN THIS-PROCEDURE.

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
  ENABLE im-pg-cla im-pg-dig im-pg-imp im-pg-par im-pg-sel rt-folder-left 
         bt-executar bt-cancelar bt-ajuda 
      WITH FRAME f-relat IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-f-relat}
  DISPLAY rs-classif 
      WITH FRAME f-pg-cla IN WINDOW C-Win.
  ENABLE rs-classif 
      WITH FRAME f-pg-cla IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-cla}
  ENABLE br-digita bt-inserir bt-recuperar 
      WITH FRAME f-pg-dig IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-dig}
  DISPLAY rs-destino c-arquivo rs-execucao l-impr-parametro 
      WITH FRAME f-pg-imp IN WINDOW C-Win.
  ENABLE RECT-43 RECT-7 RECT-9 rs-destino bt-config-impr bt-arquivo c-arquivo 
         rs-execucao l-impr-parametro 
      WITH FRAME f-pg-imp IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-imp}
  DISPLAY l-comprado l-fabricado l-planejada l-ord-com l-ord-prod l-res-com 
          l-res-pla l-sld-est l-sld-ter l-ped-crt l-it-sem-mov l-componente 
          l-deposito l-cred-aprov rs-beneficio rs-tipo l-comp-fabr l-comp-comp 
          i-cod-plano 
      WITH FRAME f-pg-par IN WINDOW C-Win.
  ENABLE l-comprado l-fabricado l-planejada l-ord-com l-ord-prod l-res-com 
         l-res-pla l-sld-est l-sld-ter l-ped-crt l-it-sem-mov l-componente 
         l-deposito l-cred-aprov rs-beneficio rs-tipo l-comp-fabr l-comp-comp 
         i-cod-plano bt-parametro RECT-19 RECT-42 rt-beneficio rt-lista 
      WITH FRAME f-pg-par IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-par}
  DISPLAY c-estab-ini c-estab-fim i-linha-ini i-linha-fim c-item-ini c-item-fim 
          c-fami-ini c-fami-fim c-plan-ini c-plan-fim i-ge-ini i-ge-fim 
          c-comp-ini c-comp-fim tg-pedidos-oem 
      WITH FRAME f-pg-sel IN WINDOW C-Win.
  ENABLE IMAGE-1 IMAGE-10 IMAGE-11 IMAGE-12 IMAGE-13 IMAGE-14 IMAGE-2 IMAGE-3 
         IMAGE-4 IMAGE-5 IMAGE-6 IMAGE-7 IMAGE-8 IMAGE-9 rt-selecao c-estab-ini 
         c-estab-fim i-linha-ini i-linha-fim c-item-ini c-item-fim c-fami-ini 
         c-fami-fim c-plan-ini c-plan-fim i-ge-ini i-ge-fim c-comp-ini 
         c-comp-fim bt-selecao tg-pedidos-oem 
      WITH FRAME f-pg-sel IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-sel}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy C-Win 
PROCEDURE local-destroy :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  &IF DEFINED(bf_man_206b) &THEN
     
    IF VALID-HANDLE(h-cdapi024) THEN DO:
                run pi-finalizar in h-cdapi024.
                ASSIGN h-cdapi024 = ?.
            END.
  &ENDIF
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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

   RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize C-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  &IF DEFINED(bf_man_206b) &THEN

    IF (CAN-FIND(FIRST funcao WHERE funcao.cd-funcao = "EMS2-UNIDADE-NEGOCIO":U AND
                funcao.ativo     = yes)) THEN DO:

        RUN cdp/cdapi024.p PERSISTENT SET h-cdapi024.

        {utp/ut-field.i mgind unid-negoc cod-unid-negoc 1}
        assign c-cod-unid-negoc-ini:label in frame f-pg-sel = return-value.

        ASSIGN c-cod-unid-negoc-ini:HIDDEN IN FRAME f-pg-sel = FALSE
               c-cod-unid-negoc-fim:HIDDEN IN FRAME f-pg-sel = FALSE
               image-21:HIDDEN             IN FRAME f-pg-sel = FALSE
               image-22:HIDDEN             IN FRAME f-pg-sel = FALSE.
    END.
  
      if(can-find(funcao where funcao.cd-funcao = "ems2-unidade-negocio" and
                  funcao.ativo     = yes)) then do:
          assign c-cod-unid-negoc-ini:sensitive in frame f-pg-sel = yes
                 c-cod-unid-negoc-fim:sensitive in frame f-pg-sel = yes
                 c-cod-unid-negoc-fim:screen-value in frame f-pg-sel = "ZZZ".

      END.

  &ENDIF


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-tt-digita C-Win 
PROCEDURE pi-cria-tt-digita :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  do transaction:
             create tt-digita.
             assign input browse br-digita tt-digita.c-it-codigo
                    input browse br-digita tt-digita.c-cod-refer
                    input BROWSE br-digita tt-digita.c-desc-item 
                    input BROWSE br-digita tt-digita.c-un 
                    tt-digita.l-dep        = no.
  end.

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

do  on error undo, return error
    on stop  undo, return error:     

    {include/i-rpexa.i}

    if  input frame f-pg-imp rs-destino = 2 then do:
        run utp/ut-vlarq.p (input input frame f-pg-imp c-arquivo).
        if  return-value = "nok" then do:
            run utp/ut-msgs.p (input "show", input 73, input "").
            apply 'mouse-select-click' to im-pg-imp in frame f-relat.
            apply 'entry' to c-arquivo in frame f-pg-imp.
            return error.
        end.
    end.

    /* Coloque aqui as valida‡äes das outras p ginas, lembrando que elas
       devem apresentar uma mensagem de erro cadastrada, posicionar na p gina 
       com problemas e colocar o focus no campo com problemas             */    

    for each tt-digita no-lock:

        assign r-tt-digita = rowid(tt-digita).

        /* Valida‡Æo de duplicidade de registro na temp-table tt-altera */
        find first b-tt-digita where b-tt-digita.c-it-codigo = tt-digita.c-it-codigo and 
                                     rowid(b-tt-digita) <> rowid(tt-digita) AND 
                                     b-tt-digita.c-cod-refer = tt-digita.c-cod-refer no-lock no-error.
        if avail b-tt-digita then do:
            apply "MOUSE-SELECT-CLICK":U to im-pg-dig in frame f-relat.
            reposition br-digita to rowid rowid(b-tt-digita).

            run utp/ut-msgs.p (input "show", input 108, input "").
            apply "ENTRY":U to tt-digita.c-it-codigo in browse br-digita.

            return error.
        end.

        find item where item.it-codigo = tt-digita.c-it-codigo no-lock no-error.
          if  avail item then do:
          assign tt-digita.fm-codigo    = item.fm-codigo
                 tt-digita.cd-planejado = item.cd-planejado
                 tt-digita.ge-codigo    = item.ge-codigo
                 tt-digita.cod-comprado = item.cod-comprado.
        end.
    end.

    create tt-param.
    assign tt-param.usuario        = c-seg-usuario
           tt-param.destino        = input frame f-pg-imp rs-destino
           tt-param.data-exec      = today
           tt-param.hora-exec      = time
           tt-param.classifica     = input frame f-pg-cla rs-classif
           tt-param.c-estab-ini    = input frame f-pg-sel c-estab-ini
           tt-param.c-estab-fim    = input frame f-pg-sel c-estab-fim
           tt-param.i-linha-ini    = input frame f-pg-sel i-linha-ini
           tt-param.i-linha-fim    = input frame f-pg-sel i-linha-fim
           tt-param.c-item-ini     = input frame f-pg-sel c-item-ini
           tt-param.c-item-fim     = input frame f-pg-sel c-item-fim
           tt-param.c-fami-ini     = input frame f-pg-sel c-fami-ini
           tt-param.c-fami-fim     = input frame f-pg-sel c-fami-fim
           tt-param.c-plan-ini     = input frame f-pg-sel c-plan-ini
           tt-param.c-plan-fim     = input frame f-pg-sel c-plan-fim
           tt-param.i-ge-ini       = input frame f-pg-sel i-ge-ini
           tt-param.i-ge-fim       = input frame f-pg-sel i-ge-fim
           tt-param.c-comp-ini     = input frame f-pg-sel c-comp-ini
           tt-param.c-comp-fim     = input frame f-pg-sel c-comp-fim
           &IF defined(bf_man_206b) &THEN
                tt-param.c-cod-unid-negoc-ini   = input frame f-pg-sel c-cod-unid-negoc-ini
                tt-param.c-cod-unid-negoc-fim   = input frame f-pg-sel c-cod-unid-negoc-fim
           &ENDIF
           tt-param.c-ci-estab-ini = p-ci-estab-ini
           tt-param.c-ci-estab-fim = p-ci-estab-fim
           tt-param.i-ci-linha-ini = p-ci-linha-ini
           tt-param.i-ci-linha-fim = p-ci-linha-fim
           tt-param.c-ci-item-ini  = p-ci-item-ini
           tt-param.c-ci-item-fim  = p-ci-item-fim
           tt-param.c-ci-fami-ini  = p-ci-fami-ini
           tt-param.c-ci-fami-fim  = p-ci-fami-fim
           tt-param.c-ci-plan-ini  = p-ci-plan-ini
           tt-param.c-ci-plan-fim  = p-ci-plan-fim
           tt-param.i-ci-ge-ini    = p-ci-ge-ini
           tt-param.i-ci-ge-fim    = p-ci-ge-fim
           tt-param.c-ci-comp-ini  = p-ci-comp-ini
           tt-param.c-ci-comp-fim  = p-ci-comp-fim
           &IF defined(bf_man_206b) &THEN    
                tt-param.c-ci-cod-unid-negoc-ini  = p-ci-cod-unid-negoc-ini
                tt-param.c-ci-cod-unid-negoc-fim  = p-ci-cod-unid-negoc-fim
           &ENDIF
           tt-param.apenas-oem     = INPUT FRAME f-pg-sel tg-pedidos-oem
           tt-param.l-comprado     = input frame f-pg-par l-comprado
           tt-param.l-fabricado    = input frame f-pg-par l-fabricado
           tt-param.da-corte       = p-corte
           tt-param.da-op-corte    = p-op-corte
           tt-param.l-planejada    = input frame f-pg-par l-planejada
           tt-param.l-ord-com      = input frame f-pg-par l-ord-com
           tt-param.l-ord-prod     = input frame f-pg-par l-ord-prod
           tt-param.l-res-com      = input frame f-pg-par l-res-com
           tt-param.l-res-pla      = input frame f-pg-par l-res-pla
           tt-param.i-cod-plano    = input frame f-pg-par i-cod-plano
           tt-param.l-sld-est      = input frame f-pg-par l-sld-est
           tt-param.l-sld-ter      = input frame f-pg-par l-sld-ter
           tt-param.l-ped-crt      = input frame f-pg-par l-ped-crt
           tt-param.l-it-sem-mov   = input frame f-pg-par l-it-sem-mov
           tt-param.l-componente   = input frame f-pg-par l-componente
           tt-param.l-deposito     = input frame f-pg-par l-deposito
           tt-param.i-niveis       = p-niveis
           tt-param.l-cred-aprov   = input frame f-pg-par l-cred-aprov
           tt-param.l-comp-fabr    = input frame f-pg-par l-comp-fabr
           tt-param.l-comp-comp    = input frame f-pg-par l-comp-comp
           tt-param.l-remessa      = p-remessa
           tt-param.l-entrada      = p-entrada
           tt-param.l-transfer     = p-transfer
           tt-param.l-re-con       = p-re-con
           tt-param.l-en-con       = p-re-con 
           tt-param.i-obsoleto     = p-cod-obsoleto
           tt-param.i-beneficio    = input frame f-pg-par rs-beneficio
           tt-param.i-tipo         = input frame f-pg-par rs-tipo
           tt-param.i-formato      = p-cod-formato
           tt-param.c-obsoleto     = p-obsoleto
           tt-param.c-beneficio    = entry((tt-param.i-beneficio - 1) * 2 + 1, 
                                            rs-beneficio:radio-buttons in frame f-pg-par)
           tt-param.c-tipo         = entry((tt-param.i-tipo - 1) * 2 + 1, 
                                            rs-tipo:radio-buttons in frame f-pg-par)
           tt-param.c-formato      = p-formato
           tt-param.c-classe       = entry((tt-param.classifica - 1) * 2 + 1, 
                                            rs-classif:radio-buttons in frame f-pg-cla)
           tt-param.c-destino      = entry((tt-param.destino - 1) * 2 + 1, 
                                            rs-destino:radio-buttons in frame f-pg-imp)
          tt-param.l-impr-parametro = if l-impr-parametro:checked = yes then yes 
                                      else no.
    run pi-validacao-plano.

    for each tt-depositos NO-LOCK:
        create tt-digita.
        assign i-cont                = i-cont + 1
               tt-digita.l-dep       = yes
               tt-digita.c-it-codigo = string(i-cont)
               tt-digita.c-estab     = tt-depositos.cod-estabel
               tt-digita.c-depos     = tt-depositos.cod-depos.
    end.

    if  tt-param.destino = 1 then
        assign tt-param.arquivo = "".
    else
    if  tt-param.destino = 2 then 
        assign tt-param.arquivo = input frame f-pg-imp c-arquivo.
    else
        assign tt-param.arquivo = session:temp-directory + c-programa-mg97 + ".tmp".

    /* Coloque aqui a l¢gica de grava‡Æo dos parƒmtros e sele‡Æo na temp-table tt-param */ 

    {include/i-rpexb.i}

    if  session:set-wait-state("general") then.

    {include/i-rprun.i esp/ccp/esccp032rp.p}

    for each tt-digita where tt-digita.l-dep = YES NO-LOCK:
        delete tt-digita.
    end.

    {include/i-rpexc.i}

    if  session:set-wait-state("") then.

    {include/i-rptrm.i}

end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-f5-it-codigo C-Win 
PROCEDURE pi-f5-it-codigo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    if  not avail tt-digita 
   and not br-digita:new-row in frame f-pg-dig then
       return no-apply.


   {include/zoomvar.i &prog-zoom=inzoom/z01in172.w
                      &campo=tt-digita.c-it-codigo
                      &campozoom=it-codigo
                      &browse=br-digita}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-f5-refer C-Win 
PROCEDURE pi-f5-refer :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   if  not avail tt-digita
   and not br-digita:new-row in frame f-pg-dig then return no-apply.   

   {include/zoomvar.i &prog-zoom=inzoom/z01in375.w
                      &campo=tt-digita.c-cod-refer
                      &campozoom = cod-refer
                      &parametros= "run pi-seta-inicial in wh-pesquisa
                      (tt-digita.c-it-codigo:screen-value in browse br-digita)."
                      &browse=br-digita}                     


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-leave-refer C-Win 
PROCEDURE pi-leave-refer :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  find item where item.it-codigo = tt-digita.c-it-codigo:SCREEN-VALUE IN BROWSE br-digita 
              AND ITEM.tipo-con-est = 4 no-lock no-error.
  IF AVAIL ITEM THEN DO:
      find ref-ITEM where ref-ITEM.it-codigo = tt-digita.c-it-codigo:SCREEN-VALUE IN BROWSE br-digita 
                    AND ref-item.cod-refer   = tt-digita.c-cod-refer:SCREEN-VALUE IN BROWSE br-digita  no-lock no-error.
            if  not avail ref-ITEM then do:
                    assign browse br-digita:CURRENT-COLUMN = tt-digita.c-cod-refer:HANDLE in browse br-digita. 
                    apply "MOUSE-SELECT-CLICK":U to im-pg-dig in frame f-relat.                                
                    {utp/ut-table.i mgind item 1}                                                              
                    run utp/ut-msgs.p (input 'show', input 1947, input return-value).
                    apply "ENTRY":U to tt-digita.c-it-codigo in browse br-digita.
                    RETURN "NOK":U.

            end.
  END.
  ELSE 
    IF tt-digita.c-cod-refer:SCREEN-VALUE IN BROWSE br-digita <> "" THEN DO:
         assign browse br-digita:CURRENT-COLUMN = tt-digita.c-cod-refer:HANDLE in browse br-digita. 
         apply "MOUSE-SELECT-CLICK":U to im-pg-dig in frame f-relat.                                
         {utp/ut-table.i mgind item 1}                                                              
         run utp/ut-msgs.p (input 'show', input 16540, input return-value).
         apply "ENTRY":U to tt-digita.c-it-codigo in browse br-digita.
         RETURN "NOK":U.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-main C-Win 
PROCEDURE pi-main :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Best default for GUI applications is...                              */
/*PAUSE 0 BEFORE-HIDE.*/

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO  ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
    ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

    RUN enable_UI.

    {include/i-rpmbl.i}

    find first param-global no-lock no-error.

    IF  NOT THIS-PROCEDURE:PERSISTENT THEN
        WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-seta-plano C-Win 
PROCEDURE pi-seta-plano :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  if input frame f-pg-par l-planejada or 
     input frame f-pg-par l-res-pla then
     assign i-cod-plano:sensitive in frame f-pg-par = yes.
  else
     assign i-cod-plano:sensitive in frame f-pg-par = no.


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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validacao-plano C-Win 
PROCEDURE pi-validacao-plano :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


    /*** Valida‡Æo se o plano existe e se est  ativo ****/
    if tt-param.l-planejada or tt-param.l-res-pla then do:
       find first pl-prod where pl-prod.cd-plano = input frame f-pg-par i-cod-plano
            no-lock no-error.

       if not avail pl-prod or 
          (avail pl-prod and pl-prod.pl-estado = 2) then do:
          run utp/ut-msgs.p (input "show":U, 
                             input 19591, 
                             input return-value).                                                                                    
          apply 'mouse-select-click':U to i-cod-plano in frame f-pg-par.
          apply 'entry':U to i-cod-plano in frame f-pg-par.

          assign l-erro = yes.

       end.
    end.

    if not l-erro then
       if l-cancelar then 
          for each tt-depositos NO-LOCK:
              delete tt-depositos.
          end.
    /*** Fim ***/


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-verifica-tt-digita C-Win 
PROCEDURE pi-verifica-tt-digita :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

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

