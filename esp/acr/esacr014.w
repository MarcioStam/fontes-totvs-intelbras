&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/*****************************************************************************
**     Programa.........: esp\acr\esacr014.w
**     Descricao .......: Titulos em Aberto - Convers∆o ES0376
**     Versao...........: 1.00.000
**     Autor............: Anderson Silvano
**     Criado...........: 12/05/2004
**     Desc. Atualizaá∆o: 
**     Autor............: 
*******************************************************************************/
{include/i-prgvrs.i ESACR014 2.06.00.002}

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program          ESACR014
&GLOBAL-DEFINE Version          2.06.00.002

CREATE WIDGET-POOL.

DEF BUFFER b_representante FOR representante.

DEF VAR c-ant                 AS CHAR.
DEF VAR v_num_ped_exec_rpw    AS INTE.
DEF VAR v_log_det             AS logi INIT NO.
DEF VAR v_cod_exessao         AS CHAR.
DEF VAR c-impressora          AS CHAR.
DEF VAR c-layout              AS CHAR.
DEF VAR wh-exessao            as HANDLE.
DEF VAR l-ok                  AS LOG.

DEF VAR cod-mensagem-ini      LIKE mensagem.cod-mensagem.
DEF VAR c-narrativa-ini       AS CHAR FORMAT "x(2000)".
DEF VAR cod-mensagem-fim      LIKE mensagem.cod-mensagem.
DEF VAR c-narrativa-fim       AS CHAR FORMAT "x(2000)".

DEFINE BUFFER b_tit_acr FOR tit_acr.

DEF VAR d-valor               LIKE tit_acr.val_sdo_tit_acr.

{esp\acr\esacr014tt.i}

DEF NEW GLOBAL SHARED VAR i-port LIKE tit_acr.cod_portador  EXTENT 20.
DEF NEW GLOBAL SHARED VAR i-mod  like tit_acr.cod_cart_bcia EXTENT 20.
 
/* Vari†veis utilizadas na integraá∆o com o EMS5 */
def new global shared var v_cod_empres_usuar
    as character
    format "x(3)":U
    label "Empresa"
    column-label "Empresa"
    no-undo.
def new global shared var v_cod_estab_usuar
    as character
    format "x(3)":U
    label "Estabelecimento"
    column-label "Estab"
    no-undo.
def new global shared var v_cod_grp_usuar_lst
    as character
    format "x(3)":U
    label "Grupo Usu†rios"
    column-label "Grupo"
    no-undo.
def new global shared var v_cod_idiom_usuar
    as character
    format "x(8)":U
    label "Idioma"
    column-label "Idioma"
    no-undo.
def new global shared var v_cod_pais_empres_usuar
    as character
    format "x(3)":U
    label "Pa°s Empresa Usu†rio"
    column-label "Pa°s"
    no-undo.
def new global shared var v_cod_usuar_corren
    as character
    format "x(12)":U
    label "Usu†rio Corrente"
    column-label "Usu†rio Corrente"
    no-undo.
def new global shared var v_cod_usuar_corren_criptog
    as character
    format "x(16)":U
    no-undo.

def new global shared var v5_cod_empres_usuar
    as character
    format 'x(3)'
    label 'Empresa'
    column-label 'Empresa'
    no-undo.
def new global shared var v5_cod_estab_usuar
    as character
    format 'x(3)'
    label 'Estabelecimento'
    column-label 'Estab'
    no-undo.
def new global shared var v5_cod_grp_usuar_lst 
    as character 
    label 'Grupo Usu†rios' 
    column-label 'Grupo' 
    no-undo.
def new global shared var v5_cod_idiom_usuar
    as character
    format 'x(8)'
    label 'Idioma'
    column-label 'Idioma'
    no-undo.
def new global shared var v5_cod_pais_empres_usuar
    as character
    format 'x(3)'
    label 'Pa°s Empresa Usu†rio'
    column-label 'Pa°s'
    no-undo.
def new global shared var v5_cod_usuar_corren
    as character
    format 'x(12)'
    label 'Usu†rio Corrente'
    column-label 'Usu†rio Corrente'
    no-undo.
def new global shared var v5_cod_usuar_corren_criptog
    as character
    format 'x(16)'
    no-undo.

def var l-next      as log initial no.
def var i-cont      as INT.
def var diferenca   as int.

DEF VAR v_num_cont_aux AS INT.

DEF NEW GLOBAL SHARED VAR c_cod_estab_selec AS CHAR NO-UNDO.

DEFINE VARIABLE raw-param       AS RAW         NO-UNDO.
DEFINE VARIABLE raw-digita      AS RAW         NO-UNDO.
DEFINE VARIABLE c-programa-mg97 AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-versao-mg97   AS CHARACTER   NO-UNDO.

{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-pg-imp

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rs-docto bt_selec_estab cdn_repres_ini ~
cdn_repres_fim estado_ini estado_fim cod_gr_cli_ini cod_gr_cli_fim ~
cod_espec_docto_ini cod_espec_docto_fim cod_portador_ini cod_portador_fim ~
cod_cart_bcia_ini cod_cart_bcia_fim i-cod-grp-cob-ini i-cod-grp-cob-fim ~
l-ve-a fx-vea-fim l-ve-b fx-veb-ini fx-veb-fim l-ve-c fx-vec-ini fx-vec-fim ~
l-ve-d fx-ved-ini fx-ved-fim l-ve-e fx-vee-ini fx-vee-fim l-ve-f fx-vef-ini ~
fx-vef-fim l-ve-g fx-veg-ini l-av-a fx-ava-fim l-av-b fx-avb-ini fx-avb-fim ~
l-av-c fx-avc-ini fx-avc-fim l-av-d fx-avd-ini fx-avd-fim l-av-e fx-ave-ini ~
fx-ave-fim l-av-f fx-avf-ini fx-avf-fim l-av-g fx-avg-ini bt-faixa-portador ~
l-email-cliente l-email-repres l-email-gerente l-quebra l-detalhes ~
rs-destino bt-arquivo bt-cfimp c-arquivo bt-imprime bt-salva rs-execucao ~
RECT-10 RECT-2 RECT-7 RECT-8 RECT-9 RECT-11 RECT-12 
&Scoped-Define DISPLAYED-OBJECTS c_cod_estab rs-docto cdn_repres_ini ~
cdn_repres_fim estado_ini estado_fim cod_gr_cli_ini cod_gr_cli_fim ~
cod_espec_docto_ini cod_espec_docto_fim cod_portador_ini cod_portador_fim ~
cod_cart_bcia_ini cod_cart_bcia_fim i-cod-grp-cob-ini i-cod-grp-cob-fim ~
l-ve-a fx-vea-fim l-ve-b fx-veb-ini fx-veb-fim l-ve-c fx-vec-ini fx-vec-fim ~
l-ve-d fx-ved-ini fx-ved-fim l-ve-e fx-vee-ini fx-vee-fim l-ve-f fx-vef-ini ~
fx-vef-fim l-ve-g fx-veg-ini l-av-a fx-ava-fim l-av-b fx-avb-ini fx-avb-fim ~
l-av-c fx-avc-ini fx-avc-fim l-av-d fx-avd-ini fx-avd-fim l-av-e fx-ave-ini ~
fx-ave-fim l-av-f fx-avf-ini fx-avf-fim l-av-g fx-avg-ini l-email-cliente ~
l-email-repres l-email-gerente l-quebra de-valor l-detalhes rs-destino ~
c-arquivo rs-execucao 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD eh-grupo-canais-distribuidores C-Win 
FUNCTION eh-grupo-canais-distribuidores RETURNS LOGICAL
    (p-emitente AS INT ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-arquivo 
     IMAGE-UP FILE "image/im-sea1.bmp":U
     LABEL "" 
     SIZE 3.86 BY 1.08 TOOLTIP "Localiza Arquivo".

DEFINE BUTTON bt-cfimp 
     IMAGE-UP FILE "image/im-pri.bmp":U
     LABEL "" 
     SIZE 3.86 BY 1.08 TOOLTIP "Layout Impress∆o".

DEFINE BUTTON bt-faixa-portador 
     IMAGE-UP FILE "image/im-ran.bmp":U
     LABEL "Faixa de Portadores" 
     SIZE 4 BY 1.13.

DEFINE BUTTON bt-imprime 
     LABEL "Imprimir" 
     SIZE 11.14 BY 1 TOOLTIP "Imprimir"
     FONT 1.

DEFINE BUTTON bt-salva 
     LABEL "Fechar" 
     SIZE 11.14 BY 1 TOOLTIP "Fechar/Salvar"
     FONT 1.

DEFINE BUTTON bt_selec_estab 
     IMAGE-UP FILE "image/im-ran_a.bmp":U
     LABEL "Todos" 
     SIZE 4 BY 1 TOOLTIP "Seleciona Estabelecimento".

DEFINE VARIABLE c-arquivo AS CHARACTER FORMAT "X(40)":U INITIAL "esacr014.lst" 
     VIEW-AS FILL-IN 
     SIZE 64 BY .88 TOOLTIP "Destino"
     BGCOLOR 15 FONT 1 NO-UNDO.

DEFINE VARIABLE cdn_repres_fim AS INTEGER FORMAT ">>>,>>9" INITIAL 999999 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88.

DEFINE VARIABLE cdn_repres_ini AS INTEGER FORMAT ">>>,>>9" INITIAL 0 
     LABEL "Representante" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88.

DEFINE VARIABLE cod_cart_bcia_fim AS CHARACTER FORMAT "x(3)" INITIAL "ZZZ" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88.

DEFINE VARIABLE cod_cart_bcia_ini AS CHARACTER FORMAT "x(3)" 
     LABEL "Carteira" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88.

DEFINE VARIABLE cod_espec_docto_fim AS CHARACTER FORMAT "x(3)" INITIAL "ZZZ" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88.

DEFINE VARIABLE cod_espec_docto_ini AS CHARACTER FORMAT "x(3)" 
     LABEL "EspÇcie" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88.

DEFINE VARIABLE cod_gr_cli_fim AS INTEGER FORMAT ">9" INITIAL 99 
     VIEW-AS FILL-IN 
     SIZE 2.57 BY .88.

DEFINE VARIABLE cod_gr_cli_ini AS INTEGER FORMAT ">9" INITIAL 0 
     LABEL "Grupo Clientes" 
     VIEW-AS FILL-IN 
     SIZE 2.57 BY .88.

DEFINE VARIABLE cod_portador_fim AS CHARACTER FORMAT "x(5)" INITIAL "ZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88.

DEFINE VARIABLE cod_portador_ini AS CHARACTER FORMAT "x(5)" 
     LABEL "Portador" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88.

DEFINE VARIABLE c_cod_estab AS CHARACTER FORMAT "X(40)":U 
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 27 BY .79 NO-UNDO.

DEFINE VARIABLE de-valor AS DECIMAL FORMAT ">>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Valor a partir de" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE estado_fim AS CHARACTER FORMAT "x(4)" INITIAL "ZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88.

DEFINE VARIABLE estado_ini AS CHARACTER FORMAT "x(4)" 
     LABEL "Estado" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88.

DEFINE VARIABLE fx-ava-fim AS INTEGER FORMAT ">>9" INITIAL 30 
     LABEL "A Vencer atÇ" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88.

DEFINE VARIABLE fx-avb-fim AS INTEGER FORMAT ">>9" INITIAL 60 
     LABEL "atÇ" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88.

DEFINE VARIABLE fx-avb-ini AS INTEGER FORMAT ">>9" INITIAL 31 
     LABEL "de" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88.

DEFINE VARIABLE fx-avc-fim AS INTEGER FORMAT ">>9" INITIAL 90 
     LABEL "atÇ" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88.

DEFINE VARIABLE fx-avc-ini AS INTEGER FORMAT ">>9" INITIAL 61 
     LABEL "de" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88.

DEFINE VARIABLE fx-avd-fim AS INTEGER FORMAT ">>9" INITIAL 120 
     LABEL "atÇ" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88.

DEFINE VARIABLE fx-avd-ini AS INTEGER FORMAT ">>9" INITIAL 91 
     LABEL "de" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88.

DEFINE VARIABLE fx-ave-fim AS INTEGER FORMAT ">>9" INITIAL 150 
     LABEL "atÇ" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88.

DEFINE VARIABLE fx-ave-ini AS INTEGER FORMAT ">>9" INITIAL 121 
     LABEL "de" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88.

DEFINE VARIABLE fx-avf-fim AS INTEGER FORMAT ">>9" INITIAL 180 
     LABEL "atÇ" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88.

DEFINE VARIABLE fx-avf-ini AS INTEGER FORMAT ">>9" INITIAL 151 
     LABEL "de" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88.

DEFINE VARIABLE fx-avg-ini AS INTEGER FORMAT ">>9" INITIAL 181 
     LABEL "mais de" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88.

DEFINE VARIABLE fx-vea-fim AS INTEGER FORMAT ">>9" INITIAL 30 
     LABEL "Vencidos atÇ" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88.

DEFINE VARIABLE fx-veb-fim AS INTEGER FORMAT ">>9" INITIAL 60 
     LABEL "atÇ" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88.

DEFINE VARIABLE fx-veb-ini AS INTEGER FORMAT ">>9" INITIAL 31 
     LABEL "de" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88.

DEFINE VARIABLE fx-vec-fim AS INTEGER FORMAT ">>9" INITIAL 90 
     LABEL "atÇ" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88.

DEFINE VARIABLE fx-vec-ini AS INTEGER FORMAT ">>9" INITIAL 61 
     LABEL "de" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88.

DEFINE VARIABLE fx-ved-fim AS INTEGER FORMAT ">>9" INITIAL 120 
     LABEL "atÇ" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88.

DEFINE VARIABLE fx-ved-ini AS INTEGER FORMAT ">>9" INITIAL 91 
     LABEL "de" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88.

DEFINE VARIABLE fx-vee-fim AS INTEGER FORMAT ">>9" INITIAL 150 
     LABEL "atÇ" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88.

DEFINE VARIABLE fx-vee-ini AS INTEGER FORMAT ">>9" INITIAL 121 
     LABEL "de" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88.

DEFINE VARIABLE fx-vef-fim AS INTEGER FORMAT ">>9" INITIAL 180 
     LABEL "atÇ" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88.

DEFINE VARIABLE fx-vef-ini AS INTEGER FORMAT ">>9" INITIAL 151 
     LABEL "de" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88.

DEFINE VARIABLE fx-veg-ini AS INTEGER FORMAT ">>9" INITIAL 181 
     LABEL "mais de" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88.

DEFINE VARIABLE i-cod-grp-cob-fim AS INTEGER FORMAT ">9":U INITIAL 99 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88.

DEFINE VARIABLE i-cod-grp-cob-ini AS INTEGER FORMAT ">9":U INITIAL 0 
     LABEL "Grupo Cobranáa" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88.

DEFINE VARIABLE rs-destino AS INTEGER INITIAL 3 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Impressora", 1,
"Arquivo", 2,
"Terminal", 3
     SIZE 32 BY .83 TOOLTIP "Destino da Impress∆o"
     FONT 1 NO-UNDO.

DEFINE VARIABLE rs-docto AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "NF", 1,
"Fatura", 2,
"NFD", 3
     SIZE 23.72 BY 1 NO-UNDO.

DEFINE VARIABLE rs-execucao AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "On Line", 1,
"Batch", 2
     SIZE 10 BY 2 TOOLTIP "Execuá∆o On Line ou Batch"
     FONT 1 NO-UNDO.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 94.57 BY 3.75.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 18.57 BY 8.5.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 19.57 BY 8.5.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 94.57 BY 1.54
     BGCOLOR 7 .

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 94.57 BY 2.92.

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 50 BY 9.25.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 43.57 BY 9.25.

DEFINE VARIABLE l-av-a AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .88 NO-UNDO.

DEFINE VARIABLE l-av-b AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .88 NO-UNDO.

DEFINE VARIABLE l-av-c AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .88 NO-UNDO.

DEFINE VARIABLE l-av-d AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .88 NO-UNDO.

DEFINE VARIABLE l-av-e AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .88 NO-UNDO.

DEFINE VARIABLE l-av-f AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .88 NO-UNDO.

DEFINE VARIABLE l-av-g AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .88 NO-UNDO.

DEFINE VARIABLE l-detalhes AS LOGICAL INITIAL no 
     LABEL "Imprimir Detalhes do Cliente" 
     VIEW-AS TOGGLE-BOX
     SIZE 22 BY .83 NO-UNDO.

DEFINE VARIABLE l-email-cliente AS LOGICAL INITIAL yes 
     LABEL "Envia E-mail Cliente" 
     VIEW-AS TOGGLE-BOX
     SIZE 23 BY .83 NO-UNDO.

DEFINE VARIABLE l-email-gerente AS LOGICAL INITIAL yes 
     LABEL "Envia E-mail Gerente" 
     VIEW-AS TOGGLE-BOX
     SIZE 23 BY .83 NO-UNDO.

DEFINE VARIABLE l-email-repres AS LOGICAL INITIAL yes 
     LABEL "Envia E-mail Representante" 
     VIEW-AS TOGGLE-BOX
     SIZE 23 BY .83 NO-UNDO.

DEFINE VARIABLE l-quebra AS LOGICAL INITIAL no 
     LABEL "Quebra de Valor" 
     VIEW-AS TOGGLE-BOX
     SIZE 15 BY .83 NO-UNDO.

DEFINE VARIABLE l-ve-a AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .88 NO-UNDO.

DEFINE VARIABLE l-ve-b AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .88 NO-UNDO.

DEFINE VARIABLE l-ve-c AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .88 NO-UNDO.

DEFINE VARIABLE l-ve-d AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .88 NO-UNDO.

DEFINE VARIABLE l-ve-e AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .88 NO-UNDO.

DEFINE VARIABLE l-ve-f AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .88 NO-UNDO.

DEFINE VARIABLE l-ve-g AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .88 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-pg-imp
     c_cod_estab AT ROW 2.25 COL 18 COLON-ALIGNED WIDGET-ID 2
     rs-docto AT ROW 11.25 COL 71.29 NO-LABEL WIDGET-ID 4
     bt_selec_estab AT ROW 2.17 COL 47 HELP
          "Seleciona Estabelecimento"
     cdn_repres_ini AT ROW 3.25 COL 18 COLON-ALIGNED HELP
          "C¢digo Representante"
     cdn_repres_fim AT ROW 3.25 COL 38 HELP
          "C¢digo Representante" NO-LABEL
     estado_ini AT ROW 4.25 COL 18 COLON-ALIGNED HELP
          "Unidade da Federaá∆o"
     estado_fim AT ROW 4.25 COL 38 HELP
          "Unidade da Federaá∆o" NO-LABEL
     cod_gr_cli_ini AT ROW 5.25 COL 18 COLON-ALIGNED HELP
          "C¢digo do grupo de cliente"
     cod_gr_cli_fim AT ROW 5.25 COL 38 HELP
          "C¢digo do grupo de cliente" NO-LABEL
     cod_espec_docto_ini AT ROW 6.25 COL 18 COLON-ALIGNED HELP
          "C¢digo EspÇcie Documento"
     cod_espec_docto_fim AT ROW 6.25 COL 38 HELP
          "C¢digo EspÇcie Documento" NO-LABEL
     cod_portador_ini AT ROW 7.25 COL 18 COLON-ALIGNED HELP
          "C¢digo Portador"
     cod_portador_fim AT ROW 7.25 COL 38 HELP
          "C¢digo Portador" NO-LABEL
     cod_cart_bcia_ini AT ROW 8.25 COL 18 COLON-ALIGNED HELP
          "Carteira Banc†ria"
     cod_cart_bcia_fim AT ROW 8.25 COL 38 HELP
          "Carteira Banc†ria" NO-LABEL
     i-cod-grp-cob-ini AT ROW 9.25 COL 18 COLON-ALIGNED HELP
          "C¢digo do Grupo de Cobranáa"
     i-cod-grp-cob-fim AT ROW 9.25 COL 36 COLON-ALIGNED HELP
          "C¢digo do Grupo de Cobranáa" NO-LABEL
     l-ve-a AT ROW 2.25 COL 56
     fx-vea-fim AT ROW 2.25 COL 66.57 COLON-ALIGNED
     l-ve-b AT ROW 3.25 COL 56
     fx-veb-ini AT ROW 3.25 COL 59 COLON-ALIGNED
     fx-veb-fim AT ROW 3.25 COL 66.57 COLON-ALIGNED
     l-ve-c AT ROW 4.25 COL 56
     fx-vec-ini AT ROW 4.25 COL 59 COLON-ALIGNED
     fx-vec-fim AT ROW 4.25 COL 66.57 COLON-ALIGNED
     l-ve-d AT ROW 5.25 COL 56
     fx-ved-ini AT ROW 5.25 COL 59 COLON-ALIGNED
     fx-ved-fim AT ROW 5.25 COL 66.57 COLON-ALIGNED
     l-ve-e AT ROW 6.25 COL 56
     fx-vee-ini AT ROW 6.25 COL 59 COLON-ALIGNED
     fx-vee-fim AT ROW 6.25 COL 66.57 COLON-ALIGNED
     l-ve-f AT ROW 7.25 COL 56
     fx-vef-ini AT ROW 7.25 COL 59 COLON-ALIGNED
     fx-vef-fim AT ROW 7.25 COL 66.57 COLON-ALIGNED
     l-ve-g AT ROW 8.25 COL 56
     fx-veg-ini AT ROW 8.25 COL 66.57 COLON-ALIGNED
     l-av-a AT ROW 2.25 COL 77.57
     fx-ava-fim AT ROW 2.25 COL 88 COLON-ALIGNED
     l-av-b AT ROW 3.25 COL 77.57
     fx-avb-ini AT ROW 3.25 COL 80.57 COLON-ALIGNED
     fx-avb-fim AT ROW 3.25 COL 88 COLON-ALIGNED
     l-av-c AT ROW 4.25 COL 77.57
     fx-avc-ini AT ROW 4.25 COL 80.57 COLON-ALIGNED
     fx-avc-fim AT ROW 4.25 COL 88 COLON-ALIGNED
     l-av-d AT ROW 5.25 COL 77.57
     fx-avd-ini AT ROW 5.25 COL 80.57 COLON-ALIGNED
     fx-avd-fim AT ROW 5.25 COL 88 COLON-ALIGNED
     l-av-e AT ROW 6.25 COL 77.57
     fx-ave-ini AT ROW 6.25 COL 80.57 COLON-ALIGNED
     fx-ave-fim AT ROW 6.25 COL 88 COLON-ALIGNED
     l-av-f AT ROW 7.25 COL 77.57
     fx-avf-ini AT ROW 7.25 COL 80.57 COLON-ALIGNED
     fx-avf-fim AT ROW 7.25 COL 88 COLON-ALIGNED
     l-av-g AT ROW 8.25 COL 77.57
     fx-avg-ini AT ROW 8.25 COL 88 COLON-ALIGNED
     bt-faixa-portador AT ROW 9.25 COL 55.86
     l-email-cliente AT ROW 11.25 COL 5
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 96.29 BY 18.88
         FONT 1.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME f-pg-imp
     l-email-repres AT ROW 12.25 COL 5
     l-email-gerente AT ROW 13.25 COL 5
     l-quebra AT ROW 12.75 COL 38.29
     de-valor AT ROW 12.75 COL 69.29 COLON-ALIGNED
     l-detalhes AT ROW 11.25 COL 38.29
     rs-destino AT ROW 15.75 COL 12 HELP
          "Destino da Impress∆o" NO-LABEL
     bt-arquivo AT ROW 16.5 COL 76.29 HELP
          "Localiza Arquivo"
     bt-cfimp AT ROW 16.54 COL 76.29 HELP
          "Layout Impress∆o"
     c-arquivo AT ROW 16.67 COL 12 HELP
          "Destino" NO-LABEL
     bt-imprime AT ROW 18.33 COL 3.14
     bt-salva AT ROW 18.33 COL 14.86
     rs-execucao AT ROW 15.5 COL 85 HELP
          "Execuá∆o On Line ou Batch" NO-LABEL
     " Impress∆o" VIEW-AS TEXT
          SIZE 9.14 BY .54 AT ROW 14.75 COL 3.86
          FONT 6
     " Seleá∆o" VIEW-AS TEXT
          SIZE 7.57 BY .54 AT ROW 1.25 COL 3.86
          FONT 6
     " ParÉmetro" VIEW-AS TEXT
          SIZE 9.14 BY .54 AT ROW 1.25 COL 55
          FONT 6
     "Imprimir:" VIEW-AS TEXT
          SIZE 6 BY .75 AT ROW 11.33 COL 65.29 WIDGET-ID 8
     RECT-10 AT ROW 11 COL 2
     RECT-2 AT ROW 18.04 COL 2.14
     RECT-7 AT ROW 14.96 COL 2
     RECT-8 AT ROW 1.5 COL 2
     RECT-9 AT ROW 1.5 COL 53
     RECT-11 AT ROW 2 COL 55
     RECT-12 AT ROW 2 COL 76
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 96.29 BY 18.88
         FONT 1
         DEFAULT-BUTTON bt-imprime.


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
         TITLE              = "Relaá∆o de Clientes Inadimplentes - ESACR014"
         COLUMN             = 19
         ROW                = 7.67
         HEIGHT             = 18.96
         WIDTH              = 96.43
         MAX-HEIGHT         = 34.04
         MAX-WIDTH          = 164.57
         VIRTUAL-HEIGHT     = 34.04
         VIRTUAL-WIDTH      = 164.57
         MAX-BUTTON         = no
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         FONT               = 1
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-pg-imp
   FRAME-NAME Custom                                                    */
/* SETTINGS FOR FILL-IN c-arquivo IN FRAME f-pg-imp
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN cdn_repres_fim IN FRAME f-pg-imp
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN cod_cart_bcia_fim IN FRAME f-pg-imp
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN cod_espec_docto_fim IN FRAME f-pg-imp
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN cod_gr_cli_fim IN FRAME f-pg-imp
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN cod_portador_fim IN FRAME f-pg-imp
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN c_cod_estab IN FRAME f-pg-imp
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-valor IN FRAME f-pg-imp
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN estado_fim IN FRAME f-pg-imp
   ALIGN-L                                                              */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-pg-imp
/* Query rebuild information for FRAME f-pg-imp
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME f-pg-imp */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Relaá∆o de Clientes Inadimplentes - ESACR014 */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Relaá∆o de Clientes Inadimplentes - ESACR014 */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-arquivo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-arquivo C-Win
ON CHOOSE OF bt-arquivo IN FRAME f-pg-imp
DO:
    def var c-arq-conv  as char no-undo.
    def var l-ok        as logical init no.

    assign c-arq-conv = replace(input frame f-pg-imp c-arquivo, "/", "\").
    SYSTEM-DIALOG GET-FILE c-arq-conv
       FILTERS "*.lst" "*.lst",
               "*.*" "*.*"
       ASK-OVERWRITE 
       DEFAULT-EXTENSION "lst"
       INITIAL-DIR "spool" 
       SAVE-AS
       USE-FILENAME
       UPDATE l-ok.

    if  l-ok = yes then do:
        assign c-arq-conv = replace(c-arq-conv, "\", "/"). 
        display c-arq-conv @ c-arquivo with frame f-pg-imp.
    end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-cfimp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cfimp C-Win
ON CHOOSE OF bt-cfimp IN FRAME f-pg-imp
DO:
    assign c-ant = c-arquivo:screen-value in frame f-pg-imp.
  
    run prgtec/btb/btb036nb.p (output c-impressora, output c-layout).
    
    if c-arquivo <> ":" then
      assign c-arquivo = c-impressora + ":" + c-layout.
    else
      assign c-arquivo = c-ant.
      
    disp c-arquivo with frame f-pg-imp.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-faixa-portador
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-faixa-portador C-Win
ON CHOOSE OF bt-faixa-portador IN FRAME f-pg-imp /* Faixa de Portadores */
DO:
  RUN pi-monta-tt.

  RUN esp/acr/esacr014a.w (INPUT-OUTPUT TABLE tt-portador).  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-imprime
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-imprime C-Win
ON CHOOSE OF bt-imprime IN FRAME f-pg-imp /* Imprimir */
DO:
    ASSIGN c-programa-mg97 = "esacr014"
           c-versao-mg97   = "2.06.00.002".
    
    ASSIGN c-arquivo
         rs-docto
         rs-destino
         rs-execucao
         c_cod_estab         
         cdn_repres_ini 
         cdn_repres_fim 
         estado_ini 
         estado_fim 
         cod_gr_cli_ini 
         cod_gr_cli_fim 
         cod_espec_docto_ini
         cod_espec_docto_fim 
         cod_portador_ini 
         cod_portador_fim 
         cod_cart_bcia_ini 
         cod_cart_bcia_fim
         i-cod-grp-cob-ini
         i-cod-grp-cob-fim
         l-email-cliente
         l-email-repres
         l-email-gerente
         l-detalhes
         l-ve-a 
         l-ve-b 
         l-ve-c 
         l-ve-d 
         l-ve-e 
         l-ve-f
         l-ve-g
         l-av-a
         l-av-b
         l-av-c
         l-av-d
         l-av-e
         l-av-f
         l-av-g
         fx-vea-fim
         fx-veb-ini
         fx-veb-fim
         fx-vec-ini
         fx-vec-fim
         fx-ved-ini
         fx-ved-fim
         fx-vee-ini
         fx-vee-fim
         fx-vef-ini
         fx-vef-fim
         fx-veg-ini
         fx-ava-fim
         fx-avb-ini
         fx-avb-fim
         fx-avc-ini
         fx-avc-fim
         fx-avd-ini
         fx-avd-fim
         fx-ave-ini
         fx-ave-fim
         fx-avf-ini
         fx-avf-fim
         fx-avg-ini. 
    
    RUN pi-vld-param.
    IF RETURN-VALUE = "no" THEN RETURN NO-APPLY.
    
    SESSION:SET-WAIT-STATE("general").
    RUN cria-tt-emitente.
    SESSION:SET-WAIT-STATE("").
    
    ASSIGN cod-mensagem-ini = 0
           c-narrativa-ini  = ""
           cod-mensagem-fim = 0
           c-narrativa-fim  = "".
    
    RUN pi_salva_param.
    
    IF  l-email-cliente:CHECKED IN FRAME f-pg-imp OR 
        l-email-repres :CHECKED IN FRAME f-pg-imp OR 
        l-email-gerente:CHECKED IN FRAME f-pg-imp
    THEN DO:
        RUN esp/acr/esacr014b.w (INPUT-OUTPUT TABLE tt-emitente,
                                 OUTPUT l-ok).
    
        IF NOT l-ok THEN RETURN NO-APPLY.
    
        RUN esp/acr/esacr014c.w (OUTPUT cod-mensagem-ini,
                                 OUTPUT c-narrativa-ini,
                                 OUTPUT cod-mensagem-fim,
                                 OUTPUT c-narrativa-fim,
                                 OUTPUT l-ok).
        RUN pi_salva_param.
      
        IF NOT l-ok THEN RETURN NO-APPLY.
    END.
    
    ASSIGN c-narrativa-ini = REPLACE(c-narrativa-ini,CHR(10),"|")
           c-narrativa-fim = REPLACE(c-narrativa-fim,CHR(10),"|").

    EMPTY TEMP-TABLE tt-digita.

    CREATE tt-param.
    ASSIGN tt-param.usuario         = v_cod_usuar_corren
           tt-param.destino         = rs-destino
           tt-param.data-exec       = today
           tt-param.hora-exec       = time.
       
    if tt-param.destino = 1 
    then 
        assign tt-param.arquivo = "":U.
    else if  tt-param.destino = 2 
        then assign tt-param.arquivo = input frame f-pg-imp c-arquivo.
         else assign tt-param.arquivo = session:temp-directory + "esacr014.tmp":U.

    FOR EACH tt-emitente:
        CREATE tt-digita.
        BUFFER-COPY tt-emitente TO tt-digita.
    END.

    FOR EACH   tt-portador
        WHERE  tt-portador.l_ok = "":
        CREATE tt-digita.
        ASSIGN tt-digita.l-portador    = YES
               tt-digita.cod_portador  = tt-portador.cod_portador
               tt-digita.cod_cart_bcia = tt-portador.cod_cart_bcia.
    END.

    EMPTY TEMP-TABLE tt-raw-digita.
    FOR EACH tt-digita:
        CREATE tt-raw-digita.
        RAW-TRANSFER tt-digita to tt-raw-digita.raw-digita.
    END. 

    {include/i-rprun.i esp/acr/esacr014rp.p}
    

/*     if rs-execucao:screen-value in frame f-pg-imp = "2" then do:                          */
/*       run btb/btb911zb.p (input c-programa-mg97,                                          */
/*                           input "esp/acr/esacr014rp.p",                                   */
/*                           input c-versao-mg97,                                            */
/*                           input 97,                                                       */
/*                           input "esacr014.txt",                                           */
/*                           input tt-param.destino,                                         */
/*                           input raw-param,                                                */
/*                           input table tt-raw-digita,                                      */
/*                           output i-num-ped-exec-rpw).                                     */
/*       if i-num-ped-exec-rpw <> 0 then                                                     */
/*         run utp/ut-msgs.p (input "show":U, input 4169, input string(i-num-ped-exec-rpw)). */
/*     end.                                                                                  */
/*     else do:                                                                              */
/*       run esp/acr/esacr014rp.p (input raw-param,                                          */
/*                                 input table tt-raw-digita).                               */
/*     end.                                                                                  */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-salva
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-salva C-Win
ON CHOOSE OF bt-salva IN FRAME f-pg-imp /* Fechar */
DO:
  RUN pi_salva_param.
  APPLY "close" TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt_selec_estab
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt_selec_estab C-Win
ON CHOOSE OF bt_selec_estab IN FRAME f-pg-imp /* Todos */
DO:
    assign input frame f-pg-imp c_cod_estab
           c_cod_estab_selec = c_cod_estab.
    run esp/acr/esacr028a.p.
    ASSIGN c_cod_estab = c_cod_estab_selec.
    display c_cod_estab with frame f-pg-imp.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME l-quebra
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-quebra C-Win
ON VALUE-CHANGED OF l-quebra IN FRAME f-pg-imp /* Quebra de Valor */
DO:
  ASSIGN de-valor:SENSITIVE IN FRAME f-pg-imp = l-quebra:CHECKED IN FRAME f-pg-imp.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs-destino
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-destino C-Win
ON VALUE-CHANGED OF rs-destino IN FRAME f-pg-imp
DO:
  if input frame f-pg-imp rs-destino = 1 then do:
      assign bt-arquivo:visible  in frame f-pg-imp = no
             bt-cfimp:visible    in frame f-pg-imp = yes
             c-arquivo:visible   in frame f-pg-imp = yes
             c-arquivo:sensitive in frame f-pg-imp = no.
      if c-impressora = "" then do:
          find first imprsor_usuar no-lock
              where imprsor_usuar.cod_usuario = v_cod_usuar_corren
              use-index imprsrsr_id no-error.
          if avail imprsor_usuar then do:
              find first layout_impres no-lock
                  where layout_impres.nom_impressora  = imprsor_usuar.nom_impressora no-error.
              if avail layout_impres then
                  assign c-arquivo:screen-value in frame f-pg-imp = imprsor_usuar.nom_impressora 
                                                               + ":" 
                                                               + layout_impres.cod_layout_impres
                         c-impressora                          = imprsor_usuar.nom_impressora
                         c-layout                              = layout_impres.cod_layout_impres.
          end.
      end.
      else
          assign c-arquivo:screen-value in frame f-pg-imp = c-impressora + ":" + c-layout.
          
  end.
             
  if input frame f-pg-imp rs-destino = 2 then do:
      assign bt-arquivo:visible  in frame f-pg-imp = yes
             bt-cfimp:visible    in frame f-pg-imp = no
             c-arquivo:visible   in frame f-pg-imp = yes             
             c-arquivo:sensitive in frame f-pg-imp = yes.
      if input frame f-pg-imp rs-execucao = 1 then
          assign c-arquivo:screen-value in frame f-pg-imp = session:temp-directory + "esacr014.lst"
                 c-impressora                          = ""
                 c-layout                              = "".
      else
          assign c-arquivo:screen-value in frame f-pg-imp = "esacr014.lst"
                 c-impressora                          = ""
                 c-layout                              = "".
          
          
  end.

  if input frame f-pg-imp rs-destino = 3 then
      assign bt-arquivo:visible  in frame f-pg-imp = no
             bt-cfimp:visible    in frame f-pg-imp = no
             c-arquivo:visible   in frame f-pg-imp = no.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs-execucao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-execucao C-Win
ON VALUE-CHANGED OF rs-execucao IN FRAME f-pg-imp
DO:
  if rs-destino:disable("Impressora") in frame f-pg-imp then.

  if input frame f-pg-imp rs-execucao = 2 then do:
     if rs-destino:disable("Terminal") in frame f-pg-imp then.
  end.
  else do:
      if rs-destino:enable("Terminal") in frame f-pg-imp then.
  end.
  
  apply "value-changed" to rs-destino in frame f-pg-imp.
     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

  RUN enable_UI.

  if rs-destino:disable("Impressora") in frame f-pg-imp then.

  run pi-recupera-param.
  
  APPLY "value-changed" TO l-email-cliente IN FRAME f-pg-imp.

  IF NOT THIS-PROCEDURE:PERSISTENT THEN 
     WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cria-tt-emitente C-Win 
PROCEDURE cria-tt-emitente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   EMPTY TEMP-TABLE tt-emitente.

   des_estab_block:
   DO v_num_cont_aux = 1 TO NUM-ENTRIES(c_cod_estab):
       estab_block:
       FOR EACH estabelecimento FIELDS(cod_estab) NO-LOCK
           WHERE estabelecimento.cod_estab = ENTRY(v_num_cont_aux, c_cod_estab),
           EACH tit_acr NO-LOCK
                WHERE tit_acr.cod_estab           = estabelecimento.cod_estab
                AND   tit_acr.cdn_repres          >= INPUT FRAME f-pg-imp cdn_repres_ini
                AND   tit_acr.cdn_repres          <= INPUT FRAME f-pg-imp cdn_repres_fim
                AND   tit_acr.log_sdo_tit_acr     = YES    
                AND   tit_acr.cod_espec_docto     >= INPUT FRAME f-pg-imp cod_espec_docto_ini
                AND   tit_acr.cod_espec_docto     <= INPUT FRAME f-pg-imp cod_espec_docto_fim
                AND   tit_acr.val_sdo_tit_acr      > 0
                AND   tit_acr.cod_portador        >= INPUT FRAME f-pg-imp cod_portador_ini
                AND   tit_acr.cod_portador        <= INPUT FRAME f-pg-imp cod_portador_fim
                AND   tit_acr.cod_cart_bcia       >= INPUT FRAME f-pg-imp cod_cart_bcia_ini
                and   tit_acr.cod_cart_bcia       <= INPUT FRAME f-pg-imp cod_cart_bcia_fim,
           FIRST espec_docto NO-LOCK
                 WHERE  espec_docto.cod_espec_docto = tit_acr.cod_espec_docto
                   AND (IF  rs-docto:SCREEN-VALUE IN FRAME f-pg-imp = "3" THEN 
                            espec_docto.ind_tip_espec_docto = "Antecipaá∆o" 
                        ELSE 
                           (espec_docto.ind_tip_espec_docto = "Normal" OR  espec_docto.ind_tip_espec_docto = "Vendor" )
                        ),
           FIRST emitente NO-LOCK
                 WHERE emitente.cod-emitente       = tit_acr.cdn_cliente
                 AND   emitente.estado            >= INPUT FRAME f-pg-imp estado_ini
                 AND   emitente.estado            <= INPUT FRAME f-pg-imp estado_fim
                 AND   emitente.cod-gr-cli        >= INPUT FRAME f-pg-imp cod_gr_cli_ini 
                 AND   emitente.cod-gr-cli        <= INPUT FRAME f-pg-imp cod_gr_cli_fim,
           FIRST int-emitente NO-LOCK
                 WHERE int-emitente.cod-emitente   = emitente.cod-emitente
                 AND   int-emitente.cod-gr-cob    >= INPUT FRAME f-pg-imp i-cod-grp-cob-ini
                 AND   int-emitente.cod-gr-cob    <= INPUT FRAME f-pg-imp i-cod-grp-cob-fim:

           IF (tit_acr.cod_portador = "999" AND tit_acr.cod_cart_bcia = "6") 
           OR (tit_acr.cod_portador = "955" AND tit_acr.cod_cart_bcia = "5") 
           OR (tit_acr.cod_portador = "977" AND tit_acr.cod_cart_bcia = "5") THEN NEXT.
            
           ASSIGN l-next = NO.
           FIND FIRST tt-portador
                WHERE  tt-portador.cod_portador  = tit_acr.cod_portador
                AND    tt-portador.cod_cart_bcia = tit_acr.cod_cart_bcia
                AND    tt-portador.l_ok          = "*" NO-ERROR.
           IF AVAIL tt-portador THEN ASSIGN l-next = YES.
            
           IF  rs-docto:SCREEN-VALUE IN FRAME f-pg-imp = "3" THEN DO:
               FIND FIRST nota_devol_tit_acr NO-LOCK 
                    WHERE nota_devol_tit_acr.cod_estab       = tit_acr.cod_estab
                      AND nota_devol_tit_acr.cod_espec_docto = tit_acr.cod_espec_docto
                      AND nota_devol_tit_acr.cod_ser_docto   = tit_acr.cod_ser_docto
                      AND nota_devol_tit_acr.cod_tit_acr     = tit_acr.cod_tit_acr
                      AND nota_devol_tit_acr.cod_parcela     = tit_acr.cod_parcela NO-ERROR.
                  
               IF  NOT AVAIL nota_devol_tit_acr THEN DO:
                   FOR FIRST movto_tit_acr FIELDS(cod_estab num_id_movto_tit_acr) NO-LOCK
                       WHERE movto_tit_acr.cod_estab      = tit_acr.cod_estab
                         AND movto_tit_acr.num_id_tit_acr = tit_acr.num_id_tit_acr
                         AND movto_tit_acr.ind_trans_acr  = "Implantaá∆o a CrÇdito":
                       FOR FIRST relacto_tit_acr FIELDS(cod_estab num_id_tit_acr) NO-LOCK
                           WHERE relacto_tit_acr.cod_estab_tit_acr_pai = movto_tit_acr.cod_estab
                             AND relacto_tit_acr.num_id_movto_tit_acr  = movto_tit_acr.num_id_movto_tit_acr:
                           FOR FIRST b_tit_acr NO-LOCK 
                               WHERE b_tit_acr.cod_estab      = relacto_tit_acr.cod_estab
                                 AND b_tit_acr.num_id_tit_acr = relacto_tit_acr.num_id_tit_acr:
                               FIND nota_devol_tit_acr NO-LOCK 
                                   WHERE nota_devol_tit_acr.cod_estab       = b_tit_acr.cod_estab
                                     AND nota_devol_tit_acr.cod_espec_docto = b_tit_acr.cod_espec_docto
                                     AND nota_devol_tit_acr.cod_ser_docto   = b_tit_acr.cod_ser_docto
                                     AND nota_devol_tit_acr.cod_tit_acr     = b_tit_acr.cod_tit_acr
                                     AND nota_devol_tit_acr.cod_parcela     = b_tit_acr.cod_parcela NO-ERROR.
                           END.
                       END.
                   END.
               END.

               IF NOT AVAIL nota_devol_tit_acr THEN 
                   ASSIGN l-next = YES.
           END.

           IF l-next THEN NEXT.
            
           FIND tt-emitente 
                WHERE tt-emitente.cod-emitente = tit_acr.cdn_cliente NO-ERROR.
           IF NOT AVAIL tt-emitente THEN DO:
              CREATE tt-emitente.
              ASSIGN tt-emitente.cod-emitente   = tit_acr.cdn_cliente.
    
              FIND FIRST emscad.cliente NO-LOCK
                   WHERE emscad.cliente.cod_empresa = v_cod_empres_usuar
                     AND emscad.cliente.cdn_cliente = tit_acr.cdn_cliente NO-ERROR.
              IF AVAIL emscad.cliente THEN DO:
                 RUN esp/acr/esacr003b.p (INPUT emscad.cliente.num_pessoa,
                                          OUTPUT tt-emitente.e-mail).
             END.
           END.
    
           ASSIGN tt-emitente.cod-port   = tit_acr.cod_portador
                  tt-emitente.modalidade = tit_acr.cod_cart_bcia
                  tt-emitente.e-mail-rep = ""
                  tt-emitente.mail-rep   = NO
                  tt-emitente.e-mail-ger = ""
                  tt-emitente.mail-ger   = NO.
            
           FIND FIRST emscad.cliente NO-LOCK
                WHERE emscad.cliente.cod_empresa = v_cod_empres_usuar
                  AND emscad.cliente.cdn_cliente = tit_acr.cdn_cliente NO-ERROR.
            
           IF AVAIL emscad.cliente 
           THEN DO:
                FIND clien_financ NO-LOCK
                   WHERE clien_financ.cod_empresa = cliente.cod_empresa
                     AND clien_financ.cdn_cliente = cliente.cdn_cliente NO-ERROR.
                IF AVAIL clien_financ 
                THEN DO:

                     IF int-emitente.ind-participa-canais <> 993520001 /* ** Cliente n∆o participante do PCI ***/
                     AND eh-grupo-canais-distribuidores (int-emitente.cod-emitente)
                     THEN DO:

                         FOR EACH crm-relacionamento-cliente NO-LOCK
                             WHERE crm-relacionamento-cliente.cod-emitente      = clien_financ.cdn_cliente
                               AND crm-relacionamento-cliente.dt-vigencia-ini  <= TODAY
                               AND (crm-relacionamento-cliente.dt-vigencia-fim  = ? OR crm-relacionamento-cliente.dt-vigencia-fim >= TODAY)
                             BREAK BY crm-relacionamento-cliente.cod-rep:
                             IF FIRST-OF (crm-relacionamento-cliente.cod-rep) 
                             THEN DO:
                                  FIND b_representante NO-LOCK
                                      WHERE b_representante.cod_empresa = v_cod_empres_usuar
                                        AND b_representante.cdn_repres  = crm-relacionamento-cliente.cod-rep NO-ERROR.
                                  IF AVAIL b_representante 
                                  THEN DO:
                                       FIND FIRST int-repres
                                             WHERE int-repres.cod-repres = b_representante.cdn_repres NO-LOCK NO-ERROR.
                                       IF  NOT AVAIL int-repres 
                                       OR  SUBSTRING(int-repres.char-1,3,1) <> "s"
                                           THEN NEXT. /*REPRESENTANTE N«O ESTµ ATIVO*/
                                       IF b_representante.num_pessoa MODULO 2 = 0 
                                       THEN DO:
                                            FIND pessoa_fisic NO-LOCK
                                               WHERE pessoa_fisic.num_pessoa_fisic = b_representante.num_pessoa NO-ERROR.
                                            IF  AVAIL pessoa_fisic 
                                            AND pessoa_fisic.cod_e_mail <> "" 
                                            THEN DO:
                                                 IF tt-emitente.e-mail-rep = "" 
                                                    THEN ASSIGN tt-emitente.e-mail-rep = pessoa_fisic.cod_e_mail.
                                                    ELSE ASSIGN tt-emitente.e-mail-rep = tt-emitente.e-mail-rep + "," + pessoa_fisic.cod_e_mail.
                                            END.
                                       END.
                                       ELSE DO:
                                            FIND pessoa_jurid NO-LOCK
                                               WHERE pessoa_jurid.num_pessoa_jurid = b_representante.num_pessoa NO-ERROR.
                                            IF AVAIL pessoa_jurid 
                                            THEN DO:
                                                 IF pessoa_jurid.cod_e_mail_cobr <> "" 
                                                 THEN DO:
                                                      IF tt-emitente.e-mail-rep = "" 
                                                         THEN ASSIGN tt-emitente.e-mail-rep = pessoa_jurid.cod_e_mail_cobr.
                                                         ELSE ASSIGN tt-emitente.e-mail-rep = tt-emitente.e-mail-rep + "," + pessoa_jurid.cod_e_mail_cobr.
                                                 END.
                                                 IF pessoa_jurid.cod_e_mail <> "" 
                                                 THEN DO:
                                                      IF tt-emitente.e-mail-rep = "" 
                                                         THEN ASSIGN tt-emitente.e-mail-rep = pessoa_jurid.cod_e_mail.
                                                         ELSE ASSIGN tt-emitente.e-mail-rep = tt-emitente.e-mail-rep + "," + pessoa_jurid.cod_e_mail.
                                                 END.
                                            END.
                                       END.
                                  END.
                             END.
                         END.
                         FOR EACH crm-relacionamento-cliente NO-LOCK
                             WHERE crm-relacionamento-cliente.cod-emitente      = clien_financ.cdn_cliente
                               AND crm-relacionamento-cliente.dt-vigencia-ini  <= TODAY
                               AND (crm-relacionamento-cliente.dt-vigencia-fim  = ? OR crm-relacionamento-cliente.dt-vigencia-fim >= TODAY)
                             BREAK BY crm-relacionamento-cliente.cod-gerente:
                             IF FIRST-OF (crm-relacionamento-cliente.cod-gerente) 
                             THEN DO:
                                 FIND gerente NO-LOCK 
                                     WHERE gerente.cod-gerente = crm-relacionamento-cliente.cod-gerente
                                     NO-ERROR.
                                 IF AVAIL gerente 
                                 THEN DO:
                                      IF tt-emitente.e-mail-ger = "" 
                                         THEN ASSIGN tt-emitente.e-mail-ger = gerente.e-mail.
                                         ELSE ASSIGN tt-emitente.e-mail-ger = tt-emitente.e-mail-ger + "," + gerente.e-mail.
                                 END.
    
                             END.
                         END.
                     END.
                     ELSE DO:

                         /* ** Verifica relacionamento migrado do CRM ***/
                         FOR EACH int-relacto-canal NO-LOCK
                             WHERE int-relacto-canal.cod-emitente = clien_financ.cdn_cliente
                               AND int-relacto-canal.DataInicial <= TODAY
                               AND (int-relacto-canal.DataFinal   = ? OR int-relacto-canal.DataFinal >= TODAY)
                               AND int-relacto-canal.situacao     = 0 /* ** Ativo ***/
                             BREAK BY int-relacto-canal.CodigoRepresentante:

                             IF FIRST-OF (int-relacto-canal.CodigoRepresentante) 
                             THEN DO:
                                  FIND b_representante NO-LOCK
                                      WHERE b_representante.cod_empresa = v_cod_empres_usuar
                                        AND b_representante.cdn_repres  = int-relacto-canal.CodigoRepresentante NO-ERROR.
                                  IF AVAIL b_representante 
                                  THEN DO:
                                      FIND FIRST int-repres
                                          WHERE int-repres.cod-repres = b_representante.cdn_repres NO-LOCK NO-ERROR.
                                      IF  NOT AVAIL int-repres 
                                      OR  SUBSTRING(int-repres.char-1,3,1) <> "s"
                                           THEN NEXT. /*REPRESENTANTE N«O ESTµ ATIVO*/
                                       IF b_representante.num_pessoa MODULO 2 = 0 
                                       THEN DO:
                                            FIND pessoa_fisic NO-LOCK
                                               WHERE pessoa_fisic.num_pessoa_fisic = b_representante.num_pessoa NO-ERROR.
                                            IF  AVAIL pessoa_fisic 
                                            AND pessoa_fisic.cod_e_mail <> "" 
                                            THEN DO:
                                                 IF tt-emitente.e-mail-rep = "" 
                                                    THEN ASSIGN tt-emitente.e-mail-rep = pessoa_fisic.cod_e_mail.
                                                    ELSE ASSIGN tt-emitente.e-mail-rep = tt-emitente.e-mail-rep + "," + pessoa_fisic.cod_e_mail.
                                            END.
                                       END.
                                       ELSE DO:
                                            FIND pessoa_jurid NO-LOCK
                                               WHERE pessoa_jurid.num_pessoa_jurid = b_representante.num_pessoa NO-ERROR.
                                            IF AVAIL pessoa_jurid 
                                            THEN DO:
                                                 IF pessoa_jurid.cod_e_mail_cobr <> "" 
                                                 THEN DO:
                                                      IF tt-emitente.e-mail-rep = "" 
                                                         THEN ASSIGN tt-emitente.e-mail-rep = pessoa_jurid.cod_e_mail_cobr.
                                                         ELSE ASSIGN tt-emitente.e-mail-rep = tt-emitente.e-mail-rep + "," + pessoa_jurid.cod_e_mail_cobr.
                                                 END.
                                                 IF pessoa_jurid.cod_e_mail <> "" 
                                                 THEN DO:
                                                      IF tt-emitente.e-mail-rep = "" 
                                                         THEN ASSIGN tt-emitente.e-mail-rep = pessoa_jurid.cod_e_mail.
                                                         ELSE ASSIGN tt-emitente.e-mail-rep = tt-emitente.e-mail-rep + "," + pessoa_jurid.cod_e_mail.
                                                 END.
                                            END.
                                       END.
                                  END.
                             END.
                         END.

                         FOR EACH int-relacto-canal NO-LOCK
                             WHERE int-relacto-canal.cod-emitente = clien_financ.cdn_cliente
                               AND int-relacto-canal.DataInicial <= TODAY
                               AND (int-relacto-canal.DataFinal   = ? OR int-relacto-canal.DataFinal >= TODAY)
                               AND int-relacto-canal.situacao     = 0 /* ** Ativo ***/
                             BREAK BY int-relacto-canal.CodigoSupervisorEMS:

                             IF FIRST-OF (int-relacto-canal.CodigoSupervisorEMS) 
                             THEN DO:
                                 FIND usuar_mestre NO-LOCK 
                                     WHERE usuar_mestre.cod_usuar = int-relacto-canal.CodigoSupervisorEMS
                                     NO-ERROR.
                                 IF AVAIL usuar_mestre 
                                 THEN DO:
                                      IF tt-emitente.e-mail-ger = "" 
                                         THEN ASSIGN tt-emitente.e-mail-ger = usuar_mestre.cod_e_mail_local.
                                         ELSE ASSIGN tt-emitente.e-mail-ger = tt-emitente.e-mail-ger + "," + usuar_mestre.cod_e_mail_local.
                                 END.
                             END.
                         END.
                     END.
                END.
           END.
    
           ASSIGN tt-emitente.e-mail-cont = ""
                  tt-emitente.mail-cont   = NO.
    
           FIND contato NO-LOCK
              WHERE contato.num_pessoa_jurid = cliente.num_pessoa
                AND contato.nom_abrev_contat = "Cobranáa" NO-ERROR.
           IF AVAIL contato 
           THEN DO:
                ASSIGN tt-emitente.e-mail-cont = contato.cod_e_mail_contat.

                IF  tt-emitente.e-mail-cont <> ""
                THEN
                    ASSIGN tt-emitente.mail-cont = YES.
           END.
    
           if tit_acr.cod_espec_docto      = "VD" and 
              tit_acr.dat_vencto_tit_acr   = tit_acr.dat_emis_docto then do:
               FIND FIRST relacto_tit_acr OF tit_acr NO-LOCK NO-ERROR.
               FIND FIRST movto_tit_acr NO-LOCK
                    where movto_tit_acr.cod_estab              = relacto_tit_acr.cod_estab
                    AND   movto_tit_acr.num_id_tit_acr         = relacto_tit_acr.num_id_tit_acr_pai
                    and   movto_tit_acr.num_id_movto_tit_acr   = relacto_tit_acr.num_id_movto_tit_acr_pai NO-ERROR.
               IF AVAIL movto_tit_acr THEN
                  ASSIGN diferenca = (today - movto_tit_acr.dat_vencto_tit_acr).
           end.
           ELSE 
              assign diferenca = (today - tit_acr.dat_vencto_tit_acr).
            
            /******************* fim novo ********************************/
    
           RUN esp/acr/esacr003c.p (INPUT  tit_acr.cod_indic_econ,
                                    INPUT  TODAY,
                                    INPUT  tit_acr.val_sdo_tit_acr,
                                    OUTPUT d-valor).        

           IF l-ve-a AND diferenca <= fx-vea-fim AND diferenca > 0           THEN ASSIGN tt-emitente.ve-a = tt-emitente.ve-a + d-valor.
           IF l-ve-b AND diferenca <= fx-veb-fim AND diferenca >= fx-veb-ini THEN ASSIGN tt-emitente.ve-b = tt-emitente.ve-b + d-valor.
           IF l-ve-c AND diferenca <= fx-vec-fim AND diferenca >= fx-vec-ini THEN ASSIGN tt-emitente.ve-c = tt-emitente.ve-c + d-valor.
           IF l-ve-d AND diferenca <= fx-ved-fim AND diferenca >= fx-ved-ini THEN ASSIGN tt-emitente.ve-d = tt-emitente.ve-d + d-valor.
           IF l-ve-e AND diferenca <= fx-vee-fim AND diferenca >= fx-vee-ini THEN ASSIGN tt-emitente.ve-e = tt-emitente.ve-e + d-valor.
           IF l-ve-f AND diferenca <= fx-vef-fim AND diferenca >= fx-vef-ini THEN ASSIGN tt-emitente.ve-f = tt-emitente.ve-f + d-valor.
           IF l-ve-g AND                             diferenca >= fx-veg-ini THEN ASSIGN tt-emitente.ve-g = tt-emitente.ve-g + d-valor.

           IF l-av-a AND diferenca >= (fx-ava-fim * -1) AND diferenca <= 0                 THEN ASSIGN tt-emitente.av-a = tt-emitente.av-a + d-valor.
           IF l-av-b AND diferenca >= (fx-avb-fim * -1) AND diferenca <= (fx-avb-ini * -1) THEN ASSIGN tt-emitente.av-b = tt-emitente.av-b + d-valor.
           IF l-av-c AND diferenca >= (fx-avc-fim * -1) AND diferenca <= (fx-avc-ini * -1) THEN ASSIGN tt-emitente.av-c = tt-emitente.av-c + d-valor.
           IF l-av-d AND diferenca >= (fx-avd-fim * -1) AND diferenca <= (fx-avd-ini * -1) THEN ASSIGN tt-emitente.av-d = tt-emitente.av-d + d-valor.
           IF l-av-e AND diferenca >= (fx-ave-fim * -1) AND diferenca <= (fx-ave-ini * -1) THEN ASSIGN tt-emitente.av-e = tt-emitente.av-e + d-valor.
           IF l-av-f AND diferenca >= (fx-avf-fim * -1) AND diferenca <= (fx-avf-ini * -1) THEN ASSIGN tt-emitente.av-f = tt-emitente.av-f + d-valor.
           IF l-av-g AND                                    diferenca <= (fx-avg-ini * -1) THEN ASSIGN tt-emitente.av-g = tt-emitente.av-g + d-valor.

       END.
   END.

   FOR EACH tt-emitente NO-LOCK:

       ASSIGN l-next = YES.    

       IF l-ve-a AND tt-emitente.ve-a > 0 THEN ASSIGN l-next = NO.
       IF l-ve-b AND tt-emitente.ve-b > 0 THEN ASSIGN l-next = NO. 
       IF l-ve-c AND tt-emitente.ve-c > 0 THEN ASSIGN l-next = NO.
       IF l-ve-d AND tt-emitente.ve-d > 0 THEN ASSIGN l-next = NO.
       IF l-ve-e AND tt-emitente.ve-e > 0 THEN ASSIGN l-next = NO.
       IF l-ve-f AND tt-emitente.ve-f > 0 THEN ASSIGN l-next = NO.
       IF l-ve-g AND tt-emitente.ve-g > 0 THEN ASSIGN l-next = NO.

       IF l-av-a AND tt-emitente.av-a > 0 THEN ASSIGN l-next = NO.
       IF l-av-b AND tt-emitente.av-b > 0 THEN ASSIGN l-next = NO.
       IF l-av-c AND tt-emitente.av-c > 0 THEN ASSIGN l-next = NO.
       IF l-av-d AND tt-emitente.av-d > 0 THEN ASSIGN l-next = NO.
       IF l-av-e AND tt-emitente.av-e > 0 THEN ASSIGN l-next = NO.
       IF l-av-f AND tt-emitente.av-f > 0 THEN ASSIGN l-next = NO.
       IF l-av-g AND tt-emitente.av-g > 0 THEN ASSIGN l-next = NO.

       IF l-next THEN
          DELETE tt-emitente. 
       ELSE DO:


           IF l-ve-a THEN ASSIGN tt-emitente.TOTAL = tt-emitente.TOTAL + tt-emitente.ve-a.
           IF l-ve-b THEN ASSIGN tt-emitente.TOTAL = tt-emitente.TOTAL + tt-emitente.ve-b.
           IF l-ve-c THEN ASSIGN tt-emitente.TOTAL = tt-emitente.TOTAL + tt-emitente.ve-c.
           IF l-ve-d THEN ASSIGN tt-emitente.TOTAL = tt-emitente.TOTAL + tt-emitente.ve-d.
           IF l-ve-e THEN ASSIGN tt-emitente.TOTAL = tt-emitente.TOTAL + tt-emitente.ve-e.
           IF l-ve-f THEN ASSIGN tt-emitente.TOTAL = tt-emitente.TOTAL + tt-emitente.ve-f.
           IF l-ve-g THEN ASSIGN tt-emitente.TOTAL = tt-emitente.TOTAL + tt-emitente.ve-g.

           IF l-av-a THEN ASSIGN tt-emitente.TOTAL = tt-emitente.TOTAL + tt-emitente.av-a.
           IF l-av-b THEN ASSIGN tt-emitente.TOTAL = tt-emitente.TOTAL + tt-emitente.av-b.
           IF l-av-c THEN ASSIGN tt-emitente.TOTAL = tt-emitente.TOTAL + tt-emitente.av-c.
           IF l-av-d THEN ASSIGN tt-emitente.TOTAL = tt-emitente.TOTAL + tt-emitente.av-d.
           IF l-av-e THEN ASSIGN tt-emitente.TOTAL = tt-emitente.TOTAL + tt-emitente.av-e.
           IF l-av-f THEN ASSIGN tt-emitente.TOTAL = tt-emitente.TOTAL + tt-emitente.av-f.
           IF l-av-g THEN ASSIGN tt-emitente.TOTAL = tt-emitente.TOTAL + tt-emitente.av-g.

           IF tt-emitente.TOTAL <= 0 THEN DO: 
               DELETE tt-emitente.
               NEXT.
           END.

           IF INPUT FRAME f-pg-imp l-quebra THEN
               IF tt-emitente.TOTAL < INPUT FRAME f-pg-imp de-valor THEN
                   DELETE tt-emitente.
       END.

       IF  AVAIL tt-emitente
       THEN DO:
           IF  l-email-cliente:CHECKED IN FRAME {&FRAME-NAME} AND
               tt-emitente.e-mail <> ""
           THEN
               ASSIGN tt-emitente.mail = YES.

           IF  l-email-repres :CHECKED IN FRAME {&FRAME-NAME} AND
               tt-emitente.e-mail-rep <> ""
           THEN
               ASSIGN tt-emitente.mail-rep = YES.

           IF  l-email-gerente:CHECKED IN FRAME {&FRAME-NAME} AND
               tt-emitente.e-mail-ger <> ""
           THEN
               ASSIGN tt-emitente.mail-ger = YES.
       END.
   END.

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
  DISPLAY c_cod_estab rs-docto cdn_repres_ini cdn_repres_fim estado_ini 
          estado_fim cod_gr_cli_ini cod_gr_cli_fim cod_espec_docto_ini 
          cod_espec_docto_fim cod_portador_ini cod_portador_fim 
          cod_cart_bcia_ini cod_cart_bcia_fim i-cod-grp-cob-ini 
          i-cod-grp-cob-fim l-ve-a fx-vea-fim l-ve-b fx-veb-ini fx-veb-fim 
          l-ve-c fx-vec-ini fx-vec-fim l-ve-d fx-ved-ini fx-ved-fim l-ve-e 
          fx-vee-ini fx-vee-fim l-ve-f fx-vef-ini fx-vef-fim l-ve-g fx-veg-ini 
          l-av-a fx-ava-fim l-av-b fx-avb-ini fx-avb-fim l-av-c fx-avc-ini 
          fx-avc-fim l-av-d fx-avd-ini fx-avd-fim l-av-e fx-ave-ini fx-ave-fim 
          l-av-f fx-avf-ini fx-avf-fim l-av-g fx-avg-ini l-email-cliente 
          l-email-repres l-email-gerente l-quebra de-valor l-detalhes rs-destino 
          c-arquivo rs-execucao 
      WITH FRAME f-pg-imp IN WINDOW C-Win.
  ENABLE rs-docto bt_selec_estab cdn_repres_ini cdn_repres_fim estado_ini 
         estado_fim cod_gr_cli_ini cod_gr_cli_fim cod_espec_docto_ini 
         cod_espec_docto_fim cod_portador_ini cod_portador_fim 
         cod_cart_bcia_ini cod_cart_bcia_fim i-cod-grp-cob-ini 
         i-cod-grp-cob-fim l-ve-a fx-vea-fim l-ve-b fx-veb-ini fx-veb-fim 
         l-ve-c fx-vec-ini fx-vec-fim l-ve-d fx-ved-ini fx-ved-fim l-ve-e 
         fx-vee-ini fx-vee-fim l-ve-f fx-vef-ini fx-vef-fim l-ve-g fx-veg-ini 
         l-av-a fx-ava-fim l-av-b fx-avb-ini fx-avb-fim l-av-c fx-avc-ini 
         fx-avc-fim l-av-d fx-avd-ini fx-avd-fim l-av-e fx-ave-ini fx-ave-fim 
         l-av-f fx-avf-ini fx-avf-fim l-av-g fx-avg-ini bt-faixa-portador 
         l-email-cliente l-email-repres l-email-gerente l-quebra l-detalhes 
         rs-destino bt-arquivo bt-cfimp c-arquivo bt-imprime bt-salva 
         rs-execucao RECT-10 RECT-2 RECT-7 RECT-8 RECT-9 RECT-11 RECT-12 
      WITH FRAME f-pg-imp IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-imp}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atribui-valores-tela C-Win 
PROCEDURE pi-atribui-valores-tela :
ASSIGN INPUT FRAME f-pg-imp c-arquivo
                             rs-docto
                             rs-destino
                             rs-execucao
                             c_cod_estab                             
                             cdn_repres_ini 
                             cdn_repres_fim 
                             estado_ini 
                             estado_fim 
                             cod_gr_cli_ini 
                             cod_gr_cli_fim 
                             cod_espec_docto_ini
                             cod_espec_docto_fim 
                             cod_portador_ini 
                             cod_portador_fim 
                             cod_cart_bcia_ini 
                             cod_cart_bcia_fim
                             i-cod-grp-cob-ini
                             i-cod-grp-cob-fim
                             l-ve-a 
                             l-ve-b 
                             l-ve-c 
                             l-ve-d 
                             l-ve-e 
                             l-ve-f
                             l-ve-g
                             l-av-a
                             l-av-b
                             l-av-c
                             l-av-d
                             l-av-e
                             l-av-f
                             l-av-g
                             fx-vea-fim
                             fx-veb-ini
                             fx-veb-fim
                             fx-vec-ini
                             fx-vec-fim
                             fx-ved-ini
                             fx-ved-fim
                             fx-vee-ini
                             fx-vee-fim
                             fx-vef-ini
                             fx-vef-fim
                             fx-veg-ini
                             fx-ava-fim
                             fx-avb-ini
                             fx-avb-fim
                             fx-avc-ini
                             fx-avc-fim
                             fx-avd-ini
                             fx-avd-fim
                             fx-ave-ini
                             fx-ave-fim
                             fx-avf-ini
                             fx-avf-fim
                             fx-avg-ini
                             l-email-cliente
                             l-email-repres
                             l-email-gerente
                             l-detalhes.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-monta-tt C-Win 
PROCEDURE pi-monta-tt :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    des_estab_block:
    DO v_num_cont_aux = 1 TO NUM-ENTRIES(c_cod_estab):
        estab_block:

        FOR EACH estabelecimento FIELDS(cod_estab) NO-LOCK
            WHERE estabelecimento.cod_estab = ENTRY(v_num_cont_aux, c_cod_estab):

            FOR EACH portad_finalid_econ 
                WHERE portad_finalid_econ.cod_estab = estabelecimento.cod_estab NO-LOCK:

                IF portad_finalid_econ.cod_cart_bcia = "APB" 
                   THEN NEXT.

                FIND FIRST tt-portador NO-LOCK
                    WHERE tt-portador.cod_portador  = portad_finalid_econ.cod_portador
                    AND   tt-portador.cod_cart_bcia = portad_finalid_econ.cod_cart_bcia NO-ERROR.

                IF NOT AVAIL tt-portador 
                THEN DO:
                     CREATE tt-portador.
                     ASSIGN tt-portador.cod_portador  = portad_finalid_econ.cod_portador
                            tt-portador.cod_cart_bcia = portad_finalid_econ.cod_cart_bcia
                            tt-portador.l_ok          = " ".
                END.

            END.

        END.

    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-recupera-param C-Win 
PROCEDURE pi-recupera-param :
/* */

  FIND dwb_set_list_param EXCLUSIVE-LOCK
       WHERE dwb_set_list_param.cod_dwb_program = "esacr014"
         AND dwb_set_list_param.cod_dwb_user    = v_cod_usuar_corren 
       NO-ERROR.
  
  IF AVAIL dwb_set_list_param THEN 
  DO WITH FRAME f-pg-imp:

    ASSIGN rs-execucao:SCREEN-VALUE         IN FRAME f-pg-imp = entry(1,dwb_set_list_param.cod_dwb_parameters,chr(10))
           cdn_repres_ini:screen-value      in frame f-pg-imp = entry(2,dwb_set_list_param.cod_dwb_parameters,chr(10))
           cdn_repres_fim:screen-value      in frame f-pg-imp = entry(3,dwb_set_list_param.cod_dwb_parameters,chr(10))
           estado_ini:screen-value          in frame f-pg-imp = entry(4,dwb_set_list_param.cod_dwb_parameters,chr(10))
           estado_fim:screen-value          in frame f-pg-imp = entry(5,dwb_set_list_param.cod_dwb_parameters,chr(10))
           cod_gr_cli_ini:screen-value      in frame f-pg-imp = entry(6,dwb_set_list_param.cod_dwb_parameters,chr(10))
           cod_gr_cli_fim:screen-value      in frame f-pg-imp = entry(7,dwb_set_list_param.cod_dwb_parameters,chr(10))
           cod_espec_docto_ini:screen-value in frame f-pg-imp = entry(8,dwb_set_list_param.cod_dwb_parameters,chr(10))
           cod_espec_docto_fim:screen-value in frame f-pg-imp = entry(9,dwb_set_list_param.cod_dwb_parameters,chr(10))
           cod_portador_ini:screen-value    in frame f-pg-imp = entry(10,dwb_set_list_param.cod_dwb_parameters,chr(10))
           cod_portador_fim:screen-value    in frame f-pg-imp = entry(11,dwb_set_list_param.cod_dwb_parameters,chr(10))
           cod_cart_bcia_ini:screen-value   in frame f-pg-imp = entry(12,dwb_set_list_param.cod_dwb_parameters,chr(10))
           cod_cart_bcia_fim:screen-value   in frame f-pg-imp = entry(13,dwb_set_list_param.cod_dwb_parameters,chr(10))
           l-email-cliente:CHECKED          IN FRAME f-pg-imp = LOGICAL(ENTRY(14,dwb_set_list_param.cod_dwb_parameters,chr(10)))
           l-ve-a:CHECKED                   IN FRAME f-pg-imp = LOGICAL(ENTRY(19,dwb_set_list_param.cod_dwb_parameters,chr(10)))
           l-ve-b:CHECKED                   IN FRAME f-pg-imp = LOGICAL(ENTRY(20,dwb_set_list_param.cod_dwb_parameters,chr(10)))          
           l-ve-c:CHECKED                   IN FRAME f-pg-imp = LOGICAL(ENTRY(21,dwb_set_list_param.cod_dwb_parameters,chr(10)))            
           l-ve-d:CHECKED                   IN FRAME f-pg-imp = LOGICAL(ENTRY(22,dwb_set_list_param.cod_dwb_parameters,chr(10)))          
           l-ve-e:CHECKED                   IN FRAME f-pg-imp = LOGICAL(ENTRY(23,dwb_set_list_param.cod_dwb_parameters,chr(10)))          
           l-ve-f:CHECKED                   IN FRAME f-pg-imp = LOGICAL(ENTRY(24,dwb_set_list_param.cod_dwb_parameters,chr(10)))         
           l-av-a:CHECKED                   IN FRAME f-pg-imp = LOGICAL(ENTRY(25,dwb_set_list_param.cod_dwb_parameters,chr(10)))             
           l-av-b:CHECKED                   IN FRAME f-pg-imp = LOGICAL(ENTRY(26,dwb_set_list_param.cod_dwb_parameters,chr(10)))          
           l-av-c:CHECKED                   IN FRAME f-pg-imp = LOGICAL(ENTRY(27,dwb_set_list_param.cod_dwb_parameters,chr(10)))          
           l-av-d:CHECKED                   IN FRAME f-pg-imp = LOGICAL(ENTRY(28,dwb_set_list_param.cod_dwb_parameters,chr(10)))  
           l-detalhes:CHECKED               IN FRAME f-pg-imp = LOGICAL(ENTRY(31,dwb_set_list_param.cod_dwb_parameters,chr(10)))
           rs-destino:SCREEN-VALUE          IN FRAME f-pg-imp = IF dwb_set_list_param.cod_dwb_output = "impressora" 
                                                                     THEN "1"
                                                               ELSE IF dwb_set_list_param.cod_dwb_output = "arquivo" 
                                                                    THEN "2"
                                                                    ELSE "3"
           c_cod_estab:SCREEN-VALUE   IN FRAME f-pg-imp = ENTRY(32,dwb_set_list_param.cod_dwb_parameters,chr(10))
           rs-docto:SCREEN-VALUE            IN FRAME f-pg-imp = ENTRY(34,dwb_set_list_param.cod_dwb_parameters,CHR(10)) 
           i-cod-grp-cob-ini:SCREEN-VALUE   IN FRAME f-pg-imp = ENTRY(36,dwb_set_list_param.cod_dwb_parameters,CHR(10))
           i-cod-grp-cob-fim:SCREEN-VALUE   IN FRAME f-pg-imp = ENTRY(37,dwb_set_list_param.cod_dwb_parameters,CHR(10))
           l-ve-g:CHECKED                   IN FRAME f-pg-imp = LOGICAL(ENTRY(38,dwb_set_list_param.cod_dwb_parameters,CHR(10)))
           l-av-e:CHECKED                   IN FRAME f-pg-imp = LOGICAL(ENTRY(39,dwb_set_list_param.cod_dwb_parameters,CHR(10)))
           l-av-f:CHECKED                   IN FRAME f-pg-imp = LOGICAL(ENTRY(40,dwb_set_list_param.cod_dwb_parameters,CHR(10)))
           l-av-g:CHECKED                   IN FRAME f-pg-imp = LOGICAL(ENTRY(41,dwb_set_list_param.cod_dwb_parameters,CHR(10)))
           fx-vea-fim:SCREEN-VALUE          IN FRAME f-pg-imp = ENTRY(42,dwb_set_list_param.cod_dwb_parameters,CHR(10))
           fx-veb-ini:SCREEN-VALUE          IN FRAME f-pg-imp = ENTRY(43,dwb_set_list_param.cod_dwb_parameters,CHR(10)) 
           fx-veb-fim:SCREEN-VALUE          IN FRAME f-pg-imp = ENTRY(44,dwb_set_list_param.cod_dwb_parameters,CHR(10))
           fx-vec-ini:SCREEN-VALUE          IN FRAME f-pg-imp = ENTRY(45,dwb_set_list_param.cod_dwb_parameters,CHR(10))
           fx-vec-fim:SCREEN-VALUE          IN FRAME f-pg-imp = ENTRY(46,dwb_set_list_param.cod_dwb_parameters,CHR(10))
           fx-ved-ini:SCREEN-VALUE          IN FRAME f-pg-imp = ENTRY(47,dwb_set_list_param.cod_dwb_parameters,CHR(10))
           fx-ved-fim:SCREEN-VALUE          IN FRAME f-pg-imp = ENTRY(48,dwb_set_list_param.cod_dwb_parameters,CHR(10))
           fx-vee-ini:SCREEN-VALUE          IN FRAME f-pg-imp = ENTRY(49,dwb_set_list_param.cod_dwb_parameters,CHR(10))
           fx-vee-fim:SCREEN-VALUE          IN FRAME f-pg-imp = ENTRY(50,dwb_set_list_param.cod_dwb_parameters,CHR(10))
           fx-vef-ini:SCREEN-VALUE          IN FRAME f-pg-imp = ENTRY(51,dwb_set_list_param.cod_dwb_parameters,CHR(10))
           fx-vef-fim:SCREEN-VALUE          IN FRAME f-pg-imp = ENTRY(52,dwb_set_list_param.cod_dwb_parameters,CHR(10))
           fx-veg-ini:SCREEN-VALUE          IN FRAME f-pg-imp = ENTRY(53,dwb_set_list_param.cod_dwb_parameters,CHR(10))
           fx-ava-fim:SCREEN-VALUE          IN FRAME f-pg-imp = ENTRY(54,dwb_set_list_param.cod_dwb_parameters,CHR(10))
           fx-avb-ini:SCREEN-VALUE          IN FRAME f-pg-imp = ENTRY(55,dwb_set_list_param.cod_dwb_parameters,CHR(10))
           fx-avb-fim:SCREEN-VALUE          IN FRAME f-pg-imp = ENTRY(56,dwb_set_list_param.cod_dwb_parameters,CHR(10))
           fx-avc-ini:SCREEN-VALUE          IN FRAME f-pg-imp = ENTRY(57,dwb_set_list_param.cod_dwb_parameters,CHR(10))
           fx-avc-fim:SCREEN-VALUE          IN FRAME f-pg-imp = ENTRY(58,dwb_set_list_param.cod_dwb_parameters,CHR(10))
           fx-avd-ini:SCREEN-VALUE          IN FRAME f-pg-imp = ENTRY(59,dwb_set_list_param.cod_dwb_parameters,CHR(10))
           fx-avd-fim:SCREEN-VALUE          IN FRAME f-pg-imp = ENTRY(60,dwb_set_list_param.cod_dwb_parameters,CHR(10))
           fx-ave-ini:SCREEN-VALUE          IN FRAME f-pg-imp = ENTRY(61,dwb_set_list_param.cod_dwb_parameters,CHR(10))
           fx-ave-fim:SCREEN-VALUE          IN FRAME f-pg-imp = ENTRY(62,dwb_set_list_param.cod_dwb_parameters,CHR(10))
           fx-avf-ini:SCREEN-VALUE          IN FRAME f-pg-imp = ENTRY(63,dwb_set_list_param.cod_dwb_parameters,CHR(10))
           fx-avf-fim:SCREEN-VALUE          IN FRAME f-pg-imp = ENTRY(64,dwb_set_list_param.cod_dwb_parameters,CHR(10))
           fx-avg-ini:SCREEN-VALUE          IN FRAME f-pg-imp = ENTRY(65,dwb_set_list_param.cod_dwb_parameters,CHR(10)) 
           l-email-repres:CHECKED           IN FRAME f-pg-imp = LOGICAL(ENTRY(66,dwb_set_list_param.cod_dwb_parameters,chr(10)))
           l-email-gerente:CHECKED          IN FRAME f-pg-imp = LOGICAL(ENTRY(67,dwb_set_list_param.cod_dwb_parameters,chr(10))) NO-ERROR.
                                                                        
        APPLY "value-changed" TO l-ve-a IN FRAME f-pg-imp.                                                                 
        APPLY "value-changed" TO l-ve-b IN FRAME f-pg-imp.
        APPLY "value-changed" TO l-ve-c IN FRAME f-pg-imp.
        APPLY "value-changed" TO l-ve-d IN FRAME f-pg-imp.
        APPLY "value-changed" TO l-ve-e IN FRAME f-pg-imp.
        APPLY "value-changed" TO l-ve-f IN FRAME f-pg-imp.
        APPLY "value-changed" TO l-ve-g IN FRAME f-pg-imp.
        APPLY "value-changed" TO l-av-a IN FRAME f-pg-imp.
        APPLY "value-changed" TO l-av-b IN FRAME f-pg-imp.
        APPLY "value-changed" TO l-av-c IN FRAME f-pg-imp.
        APPLY "value-changed" TO l-av-d IN FRAME f-pg-imp.
        APPLY "value-changed" TO l-av-e IN FRAME f-pg-imp.
        APPLY "value-changed" TO l-av-f IN FRAME f-pg-imp.
        APPLY "value-changed" TO l-av-g IN FRAME f-pg-imp.
        APPLY "value-changed" TO rs-destino     IN FRAME f-pg-imp.
  END.
     
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-vld-param C-Win 
PROCEDURE pi-vld-param :
IF c_cod_estab = "" THEN DO:
        RUN utp/ut-msgs.p(INPUT "show",
                          INPUT 17006,
                          INPUT "Seleá∆o de Estabelecimento n∆o informada !").
        APPLY "ENTRY" TO bt_selec_estab IN FRAME f-pg-imp.
         RETURN "NO".
    END.

    if rs-destino = 2 then do:
      for each ped_exec no-lock
          where ped_exec.cod_prog_dtsul = "esacr014"
            and ped_exec.ind_sit_ped    = "N∆o executado" :
              
        find ped_exec_param  of ped_exec no-lock no-error.
        if avail ped_exec_param then 
        do:
          if ped_exec_param.cod_dwb_file = input frame f-pg-imp c-arquivo then do:
              RUN utp/ut-msgs.p(INPUT "show",
                                INPUT 17006,
                                INPUT "Nome do Arquivo encontrado em outro pedido!~~"
                                    + "Foi encontrado um pedido com o mesmo nome a ser criado." 
                                    + CHR(10) + "Arquivo....: " + ped_exec_param.cod_dwb_file
                                    + CHR(10) + "Usuario....: " + ped_exec.cod_usuar   
                                    + CHR(10) + "Num Pedido.: " + string(ped_exec_param.num_ped_exec)).
            /*  LEAVE. */
              APPLY "ENTRY" TO rs-destino IN FRAME f-pg-imp.
              RETURN "NO". 
          end.  
        end.
      end.    
    end.

    IF  l-email-cliente OR 
        l-email-repres  OR 
        l-email-gerente 
    THEN DO:
        IF  (l-ve-a OR l-ve-b OR l-ve-c OR l-ve-d OR l-ve-e OR l-ve-f OR l-ve-g)
        AND (l-av-a OR l-av-b OR l-av-c OR l-av-d OR l-av-e OR l-av-f OR l-av-g) THEN DO:
            RUN utp/ut-msgs.p(INPUT "show",
                              INPUT 17006,
                              INPUT "Opá∆o Vencidos e A Vencer inv†lida!~~"
                                  + "Para o envio de e-mail, devem estar selecionados "
                                  + "somente T°tulos Vencidos ou somente T°tulos A Vencer.").
            APPLY "ENTRY" TO l-ve-a IN FRAME f-pg-imp.
            RETURN "NO".

        END.

        IF (l-ve-a OR l-ve-b OR l-ve-c OR l-ve-d OR l-ve-e OR l-ve-f OR l-ve-g)
        AND (l-ve-a = NO OR l-ve-b = NO OR l-ve-c = NO OR l-ve-d = NO OR l-ve-e = NO OR l-ve-f = NO OR l-ve-g = NO) THEN DO:
            RUN utp/ut-msgs.p(INPUT "show",
                              INPUT 17006,
                              INPUT "Opá∆o Vencidos inv†lida!~~"
                                  + "Para o envio de e-mail de T°tulos Vencidos, devem estar selecionadas "
                                  + "todas AS faixas.").
            APPLY "ENTRY" TO l-ve-a IN FRAME f-pg-imp.
            RETURN "NO".            
        END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-vld-usuario C-Win 
PROCEDURE pi-vld-usuario :
/* */
FIND prog_dtsul NO-LOCK
    WHERE prog_dtsul.cod_prog_dtsul = "esacr014" NO-ERROR.

IF AVAIL prog_dtsul THEN 
DO:
  FOR EACH usuar_grp_usuar NO-LOCK
      WHERE usuar_grp_usuar.cod_usuar = v_cod_usuar_corren:
    IF NOT CAN-FIND(FIRST prog_dtsul_segur NO-LOCK
                    WHERE  prog_dtsul_segur.cod_prog_dtsul = "esacr014"
                      AND (prog_dtsul_segur.cod_grp_usuar  = usuar_grp_usuar.cod_grp_usuar
                       OR  prog_dtsul_segur.cod_grp_usuar  = "*")) THEN 
    DO:
      MESSAGE "Usu†rio n∆o tem Permiss∆o" SKIP
              "Verifique com o Administrador as permiss‰es para acessar este programa!" VIEW-AS ALERT-BOX ERROR.
      RETURN 'nok'.
    END.
  END.
END.
ELSE 
DO:
  MESSAGE "Programa n∆o Cadastrado no Menu!" VIEW-AS ALERT-BOX ERROR.
  RETURN 'nok'.
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi_message C-Win 
PROCEDURE pi_message :
/* */
def input param c_action    as char    no-undo.
def input param i_msg       as integer no-undo.
def input param c_param     as char    no-undo.

def var c_prg_msg           as char    no-undo.

assign c_prg_msg = "messages/"
                 + string(trunc(i_msg / 1000,0),"99")
                 + "/msg"
                 + string(i_msg, "99999").

if search(c_prg_msg + ".r") = ? and search(c_prg_msg + ".p") = ? then 
do:
  message "Mensagem nr. " i_msg "!!!" skip
          "Programa Mensagem" c_prg_msg "n∆o encontrado."
          view-as alert-box error.
  return error.
end.
run value(c_prg_msg + ".p") (input c_action, input c_param).
return return-value.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi_salva_param C-Win 
PROCEDURE pi_salva_param :
/* */
  RUN pi-atribui-valores-tela. 

  RUN prgtec/btb/btb906za.p.    
  IF rs-destino  = 2 AND 
     rs-execucao = 2 THEN
  DO.
    DO WHILE INDEX(c-arquivo,"~/") <> 0.
      ASSIGN c-arquivo = SUBSTR(c-arquivo,(INDEX(c-arquivo,"~/" ) + 1)).
    END.
  END.

        /* Recuperar parÉmetros da £ltima execuá∆o */
  FIND dwb_set_list_param EXCLUSIVE-LOCK
       WHERE dwb_set_list_param.Cod_dwb_program = "esacr014"
         AND dwb_set_list_param.Cod_dwb_user    = v_Cod_usuar_corren 
       NO-ERROR.
    
  IF NOT AVAIL dwb_set_list_param 
  THEN CREATE dwb_set_list_param.

  ASSIGN dwb_set_list_param.Cod_dwb_program          = "esacr014"
         dwb_set_list_param.Cod_dwb_user             = v_Cod_usuar_corren
         dwb_set_list_param.Cod_dwb_file             = INPUT FRAME f-pg-imp c-arquivo
         dwb_set_list_param.nom_dwb_printer          = c-impressora
         dwb_set_list_param.Cod_dwb_print_layout     = c-layout
         dwb_set_list_param.qtd_dwb_line             = 60
         dwb_set_list_param.Cod_dwb_parameters       = STRING(rs-execucao)         + chr(10) + 
                                                              STRING(cdn_repres_ini)      + chr(10) + 
                                                              STRING(cdn_repres_fim)      + chr(10) + 
                                                              STRING(estado_ini)          + chr(10) + 
                                                              STRING(estado_fim)          + chr(10) + 
                                                              STRING(cod_gr_cli_ini)      + chr(10) + 
                                                              STRING(cod_gr_cli_fim)      + chr(10) + 
                                                              STRING(cod_espec_docto_ini) + chr(10) +
                                                              STRING(cod_espec_docto_fim) + chr(10) + 
                                                              STRING(cod_portador_ini)    + chr(10) + 
                                                              STRING(cod_portador_fim)    + chr(10) + 
                                                              STRING(cod_cart_bcia_ini)   + chr(10) + 
                                                              STRING(cod_cart_bcia_fim)   + chr(10) +
                                                              STRING(l-email-cliente)     + CHR(10) +  
                                                              STRING(cod-mensagem-ini)    + CHR(10) +
                                                              STRING(c-narrativa-ini)     + CHR(10) +
                                                              STRING(cod-mensagem-fim)    + CHR(10) +
                                                              STRING(c-narrativa-fim)     + CHR(10) +
                                                              STRING(l-ve-a)             + chr(10) + 
                                                              STRING(l-ve-b)          + chr(10) + 
                                                              STRING(l-ve-c)            + chr(10) + 
                                                              STRING(l-ve-d)          + chr(10) + 
                                                              STRING(l-ve-e)          + chr(10) + 
                                                              STRING(l-ve-f)         + chr(10) +
                                                              STRING(l-av-a)             + chr(10) + 
                                                              STRING(l-av-b)          + chr(10) + 
                                                              STRING(l-av-c)          + chr(10) + 
                                                              STRING(l-av-d)             + chr(10) + 
                                                              chr(10) + 
                                                              chr(10) +
                                                              STRING(l-detalhes)          + CHR(10) + 
                                                              STRING(c_cod_estab)   + chr(10) +
                                                              ""                          + CHR(10) +
                                                              STRING(rs-docto)            + CHR(10) +
                                                              CHR(10) +
                                                              STRING(i-cod-grp-cob-ini)   + CHR(10) +
                                                              STRING(i-cod-grp-cob-fim)   + CHR(10) +
                                                              STRING(l-ve-g)              + CHR(10) +
                                                              STRING(l-av-e)              + CHR(10) +
                                                              STRING(l-av-f)              + CHR(10) +
                                                              STRING(l-av-g)              + CHR(10) +
                                                              STRING(fx-vea-fim)          + CHR(10) +
                                                              STRING(fx-veb-ini)          + CHR(10) +
                                                              STRING(fx-veb-fim)          + CHR(10) +
                                                              STRING(fx-vec-ini)          + CHR(10) +
                                                              STRING(fx-vec-fim)          + CHR(10) +
                                                              STRING(fx-ved-ini)          + CHR(10) +
                                                              STRING(fx-ved-fim)          + CHR(10) +
                                                              STRING(fx-vee-ini)          + CHR(10) +
                                                              STRING(fx-vee-fim)          + CHR(10) +
                                                              STRING(fx-vef-ini)          + CHR(10) +
                                                              STRING(fx-vef-fim)          + CHR(10) +
                                                              STRING(fx-veg-ini)          + CHR(10) +
                                                              STRING(fx-ava-fim)          + CHR(10) +
                                                              STRING(fx-avb-ini)          + CHR(10) +
                                                              STRING(fx-avb-fim)          + CHR(10) +
                                                              STRING(fx-avc-ini)          + CHR(10) +
                                                              STRING(fx-avc-fim)          + CHR(10) +
                                                              STRING(fx-avd-ini)          + CHR(10) +
                                                              STRING(fx-avd-fim)          + CHR(10) +
                                                              STRING(fx-ave-ini)          + CHR(10) +
                                                              STRING(fx-ave-fim)          + CHR(10) +
                                                              STRING(fx-avf-ini)          + CHR(10) +
                                                              STRING(fx-avf-fim)          + CHR(10) +
                                                              STRING(fx-avg-ini)          + CHR(10) +
                                                              STRING(l-email-repres)      + CHR(10) +
                                                              STRING(l-email-gerente)

         dwb_set_list_param.Cod_dwb_output           = IF rs-destino = 1 
                                                              THEN "Impressora"
                                                              ELSE IF rs-destino = 2 
                                                                   THEN "Arquivo"
                                                                   ELSE IF rs-destino = 3 
                                                                        THEN "Terminal"
                                                                        ELSE "arquivo".



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION eh-grupo-canais-distribuidores C-Win 
FUNCTION eh-grupo-canais-distribuidores RETURNS LOGICAL
    (p-emitente AS INT ):
    
    FIND emitente NO-LOCK
        WHERE emitente.cod-emitente = p-emitente NO-ERROR.

    FOR FIRST mgesp.ponto-programa NO-LOCK
        WHERE ponto-programa.nome-programa = "pd4000"
          AND ponto-programa.ponto         = 8:
        FOR EACH conteudo-programa NO-LOCK
            WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa :
            IF  emitente.cod-gr-cli = int(conteudo-programa.conteudo) then
                RETURN YES.
        END.
    END.

    RETURN NO.


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

