&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME esfgl007-contab
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS esfgl007-contab 
{include/i-prgvrs.i esfgl007-calc 2.00.00.000}


CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
define variable wh-imprime as handle no-undo.


DEF INPUT PARAM p-operacao-sugerida AS CHAR FORMAT "x(15)" NO-UNDO.
DEF INPUT PARAM p-passivo           AS CHAR NO-UNDO.
DEF INPUT PARAM p-vc-ativo          AS CHAR NO-UNDO.
DEF INPUT PARAM p-vc-passivo        AS CHAR NO-UNDO.

DEF NEW SHARED STREAM s_1.

{utp/ut-glob.i}


{esp/fgl/esfgl007.i}

/*----------------------------------------------------------------*/
/*        DEFINIÄÂES ESPEC÷FICAS PARA INTEGRAÄ«O COM O APB        */
/*----------------------------------------------------------------*/
def new shared temp-table tt_integr_aprop_lancto_ctbl_1 no-undo
    field tta_cod_finalid_econ             as character format "x(10)" label "Finalidade" column-label "Finalidade"
    field tta_cod_unid_negoc               as character format "x(3)" label "Unid Neg¢cio" column-label "Un Neg"
    field tta_cod_plano_ccusto             as character format "x(8)" label "Plano Centros Custo" column-label "Plano Centros Custo"
    field tta_qtd_unid_lancto_ctbl         as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Quantidade" column-label "Quantidade"
    field tta_val_lancto_ctbl              as decimal format "->>>>>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Lanáamento" column-label "Valor Lanáamento"
    field tta_num_id_aprop_lancto_ctbl     as integer format "9999999999" initial 0 label "Apropriacao Lanáto" column-label "Apropriacao Lanáto"
    field ttv_rec_integr_item_lancto_ctbl  as recid format ">>>>>>9"
    field tta_dat_cotac_indic_econ         as date format "99/99/9999" initial ? label "Data Cotaá∆o" column-label "Data Cotaá∆o"
    field tta_val_cotac_indic_econ         as decimal format "->>>>>,>>9.9999999999" decimals 10 initial 0 label "Cotaá∆o" column-label "Cotaá∆o"
    field ttv_ind_erro_valid               as character format "X(08)" initial "N∆o"
    field tta_ind_orig_val_lancto_ctbl     as character format "X(10)" initial "Informado" label "Origem Valor" column-label "Origem Valor"
    field tta_cod_ccusto                   as Character format "x(11)" label "Centro Custo" column-label "Centro Custo"
    field ttv_rec_integr_aprop_lancto_ctbl as recid format ">>>>>>9"
    index tt_id                            is primary unique
          ttv_rec_integr_item_lancto_ctbl  ascending
          tta_cod_finalid_econ             ascending
          tta_cod_unid_negoc               ascending
          tta_cod_plano_ccusto             ascending
          tta_cod_ccusto                   ascending
    index tt_recid                        
          ttv_rec_integr_aprop_lancto_ctbl ascending.

def new shared temp-table tt_integr_ctbl_valid_1 no-undo
    field ttv_rec_integr_ctbl              as recid format ">>>>>>9"
    field ttv_num_mensagem                 as integer format ">>>>,>>9" label "N£mero" column-label "N£mero Mensagem"
    field ttv_ind_pos_erro                 as character format "X(08)" label "Posiá∆o"
    index tt_id                            is primary unique
          ttv_rec_integr_ctbl              ascending
          ttv_num_mensagem                 ascending.

def new shared temp-table tt_integr_ctbl_valid_parametros no-undo
    field ttv_rec_aux                      as recid format ">>>>>>9"
    field ttv_cod_parameters               as character format "x(256)"
    field ttv_cod_msg                      as character format "x(8)" label "Mensagem" column-label "Mensagem".

def new shared temp-table tt_integr_item_lancto_ctbl_1 no-undo
    field ttv_rec_integr_lancto_ctbl       as recid format ">>>>>>9"
    field tta_num_seq_lancto_ctbl          as integer format ">>>>9" initial 0 label "Sequància Lanáto" column-label "Sequància Lanáto"
    field tta_ind_natur_lancto_ctbl        as character format "X(02)" initial "DB" label "Natureza" column-label "Natureza"
    field tta_cod_plano_cta_ctbl           as character format "x(8)" label "Plano Contas" column-label "Plano Contas"
    field tta_cod_cta_ctbl                 as character format "x(20)" label "Conta Cont†bil" column-label "Conta Cont†bil"
    field tta_cod_plano_ccusto             as character format "x(8)" label "Plano Centros Custo" column-label "Plano Centros Custo"
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_unid_negoc               as character format "x(3)" label "Unid Neg¢cio" column-label "Un Neg"
    field tta_cod_histor_padr              as character format "x(8)" label "Hist¢rico Padr∆o" column-label "Hist¢rico Padr∆o"
    field tta_des_histor_lancto_ctbl       as character format "x(2000)" label "Hist¢rico Cont†bil" column-label "Hist¢rico Cont†bil"
    field tta_cod_espec_docto              as character format "x(3)" label "EspÇcie Documento" column-label "EspÇcie"
    field tta_dat_docto                    as date format "99/99/9999" initial ? label "Data Documento" column-label "Data Documento"
    field tta_des_docto                    as character format "x(25)" label "N£mero Documento" column-label "N£mero Documento"
    field tta_cod_imagem                   as character format "x(30)" label "Imagem" column-label "Imagem"
    field tta_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda"
    field tta_dat_lancto_ctbl              as date format "99/99/9999" initial ? label "Data Lanáamento" column-label "Data Lanáto"
    field tta_qtd_unid_lancto_ctbl         as decimal format "->>,>>>,>>9.99" decimals 2 initial 0 label "Quantidade" column-label "Quantidade"
    field tta_val_lancto_ctbl              as decimal format "->>>>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Lanáamento" column-label "Valor Lanáamento"
    field tta_num_seq_lancto_ctbl_cpart    as integer format ">>>9" initial 0 label "Sequància CPartida" column-label "Sequància CP"
    field ttv_ind_erro_valid               as character format "X(08)" initial "N∆o"
    field tta_cod_ccusto                   as Character format "x(11)" label "Centro Custo" column-label "Centro Custo"
    field tta_cod_proj_financ              as character format "x(20)" label "Projeto" column-label "Projeto"
    field ttv_rec_integr_item_lancto_ctbl  as recid format ">>>>>>9"
    index tt_id                            is primary unique
          ttv_rec_integr_lancto_ctbl       ascending
          tta_num_seq_lancto_ctbl          ascending
    index tt_recid                        
          ttv_rec_integr_item_lancto_ctbl  ascending.

def new shared temp-table tt_integr_lancto_ctbl_1 no-undo
    field tta_cod_cenar_ctbl               as character format "x(8)" label "Cen†rio Cont†bil" column-label "Cen†rio Cont†bil"
    field tta_log_lancto_conver            as logical format "Sim/N∆o" initial no label "Lanáamento Convers∆o" column-label "Lanáto Conv"
    field tta_log_lancto_apurac_restdo     as logical format "Sim/N∆o" initial no label "Lanáamento Apuraá∆o" column-label "Lancto Apuraá∆o"
    field tta_cod_rat_ctbl                 as character format "x(8)" label "Rateio Cont†bil" column-label "Rateio"
    field ttv_rec_integr_lote_ctbl         as recid format ">>>>>>9"
    field tta_num_lancto_ctbl              as integer format ">>,>>>,>>9" initial 10 label "Lanáamento Cont†bil" column-label "Lanáamento Cont†bil"
    field ttv_ind_erro_valid               as character format "X(08)" initial "N∆o"
    field tta_dat_lancto_ctbl              as date format "99/99/9999" initial ? label "Data Lanáamento" column-label "Data Lanáto"
    field ttv_rec_integr_lancto_ctbl       as recid format ">>>>>>9"
    index tt_id                            is primary unique
          ttv_rec_integr_lote_ctbl         ascending
          tta_num_lancto_ctbl              ascending
    index tt_recid                        
          ttv_rec_integr_lancto_ctbl       ascending.

def temp-table tt_integr_lancto_ctbl_aux no-undo
    field tta_cod_cenar_ctbl               as character format "x(8)" label "Cen†rio Cont†bil" column-label "Cen†rio Cont†bil"
    field tta_log_lancto_conver            as logical format "Sim/N∆o" initial no label "Lanáamento Convers∆o" column-label "Lanáto Conv"
    field tta_log_lancto_apurac_restdo     as logical format "Sim/N∆o" initial no label "Lanáamento Apuraá∆o" column-label "Lancto Apuraá∆o"
    field tta_cod_rat_ctbl                 as character format "x(8)" label "Rateio Cont†bil" column-label "Rateio"
    field ttv_rec_integr_lote_ctbl         as recid format ">>>>>>9"
    field tta_num_lancto_ctbl              as integer format ">>,>>>,>>9" initial 10 label "Lanáamento Cont†bil" column-label "Lanáamento Cont†bil"
    field ttv_ind_erro_valid               as character format "X(08)" initial "N∆o"
    field tta_dat_lancto_ctbl              as date format "99/99/9999" initial ? label "Data Lanáamento" column-label "Data Lanáto"
    field ttv_rec_integr_lancto_ctbl       as recid format ">>>>>>9"
    index tt_id                            is primary unique
          ttv_rec_integr_lote_ctbl         ascending
          tta_num_lancto_ctbl              ascending.

def new shared temp-table tt_integr_lote_ctbl_1 no-undo
    field tta_cod_modul_dtsul              as character format "x(3)" label "M¢dulo" column-label "M¢dulo"
    field tta_num_lote_ctbl                as integer format ">>>,>>>,>>9" initial 1 label "Lote Cont†bil" column-label "Lote Cont†bil"
    field tta_des_lote_ctbl                as character format "x(40)" label "Descriá∆o Lote" column-label "Descriá∆o Lote"
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_dat_lote_ctbl                as date format "99/99/9999" initial today label "Data Lote Cont†bil" column-label "Data Lote Cont†bil"
    field ttv_ind_erro_valid               as character format "X(08)" initial "N∆o"
    field tta_log_integr_ctbl_online       as logical format "Sim/N∆o" initial no label "Integraá∆o Online" column-label "Integr Online"
    field ttv_rec_integr_lote_ctbl         as recid format ">>>>>>9"
    index tt_recid                        
          ttv_rec_integr_lote_ctbl         ascending.

def temp-table tt_input_leitura_sdo no-undo
    field ttv_cod_label                    as character format "x(8)" label "Label" column-label "Label"
    field ttv_des_conteudo                 as character format "x(40)" label "Texto" column-label "Texto"
    field ttv_num_seq_1                    as integer format ">>>,>>9"
    field ttv_num_seq_2                    as integer format ">>>>,>>9"
    index tt_ID                            is primary
          ttv_num_seq_1                    ascending.

def temp-table tt_retorna_sdo_ctbl no-undo
    field tta_num_seq                      as integer format ">>>,>>9" initial 0 label "Sequància" column-label "NumSeq"
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cod_finalid_econ             as character format "x(10)" label "Finalidade" column-label "Finalidade"
    field tta_cod_plano_cta_ctbl           as character format "x(8)" label "Plano Contas" column-label "Plano Contas"
    field tta_cod_cta_ctbl                 as character format "x(20)" label "Conta Cont†bil" column-label "Conta Cont†bil"
    field tta_cod_plano_ccusto             as character format "x(8)" label "Plano Centros Custo" column-label "Plano Centros Custo"
    field tta_cod_ccusto                   as Character format "x(11)" label "Centro Custo" column-label "Centro Custo"
    field tta_cod_proj_financ              as character format "x(20)" label "Projeto" column-label "Projeto"
    field tta_cod_cenar_ctbl               as character format "x(8)" label "Cen†rio Cont†bil" column-label "Cen†rio Cont†bil"
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_unid_negoc               as character format "x(3)" label "Unid Neg¢cio" column-label "Un Neg"
    field tta_dat_sdo_ctbl                 as date format "99/99/9999" initial ? label "Data Saldo Cont†bil" column-label "Data Saldo Cont†bil"
    field tta_val_sdo_ctbl_db              as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Movto DÇbito" column-label "Movto DÇbito"
    field tta_val_sdo_ctbl_cr              as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Movto CrÇdito" column-label "Movto CrÇdito"
    field tta_val_sdo_ctbl_fim             as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Saldo Cont†bil Final" column-label "Saldo Cont†bil Final"
    field tta_val_apurac_restdo            as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Apuraá∆o Resultado" column-label "Apuraá∆o Resultado"
    field tta_val_apurac_restdo_db         as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Apuraá∆o Restdo DB" column-label "Apuraá∆o Restdo DB"
    field tta_val_apurac_restdo_cr         as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Apuraá∆o Restdo CR" column-label "Apuraá∆o Restdo CR"
    field tta_val_apurac_restdo_acum       as decimal format "->>>>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Apuracao Final" column-label "Apuracao Final"
    field tta_val_sdo_ctbl_db_sint         as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Movto DÇbito Sint" column-label "Movto DÇbito Sint"
    field tta_val_sdo_ctbl_cr_sint         as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Movto CrÇdito Sint" column-label "Movto CrÇdito Sint"
    field tta_val_sdo_ctbl_fim_sint        as decimal format "->>>>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Saldo SintÇtico" column-label "Saldo SintÇtico"
    field tta_val_apurac_restdo_sint       as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Apuracao Resultado" column-label "Apuracao Resultado"
    field tta_val_apurac_restdo_sint_db    as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Apur Restdo Sint DB" column-label "Apur Restdo Sint DB"
    field tta_val_apurac_restdo_sint_cr    as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Apur Restdo Sint CR" column-label "Apur Restdo Sint CR"
    field tta_val_apurac_restdo_sint_acum  as decimal format "->>>>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Apur Result Sint" column-label "Apur Result Sint"
    field tta_val_movto_empenh             as decimal format "->>,>>>,>>>,>>9.99" decimals 9 initial 0 label "Movto Empenhado" column-label "Movto Empenhado"
    field tta_qtd_sdo_ctbl_db              as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Quantidade DB" column-label "Quantidade DB"
    field tta_qtd_sdo_ctbl_cr              as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Quantidade CR" column-label "Quantidade CR"
    field tta_qtd_sdo_ctbl_fim             as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Quantidade Final" column-label "Quantidade Final"
    field ttv_val_movto_ctbl               as decimal format ">>>,>>>,>>>,>>9.99" decimals 2
    field tta_qtd_movto_empenh             as decimal format "->>>>,>>9.9999" decimals 4 initial 0 label "Qtde Movto Empenhado" column-label "Qtde Movto Empenhado"
    index tt_cta                          
          tta_cod_plano_cta_ctbl           ascending
          tta_cod_cta_ctbl                 ascending
    index tt_id                            is primary unique
          tta_cod_empresa                  ascending
          tta_cod_finalid_econ             ascending
          tta_cod_plano_cta_ctbl           ascending
          tta_cod_cta_ctbl                 ascending
          tta_cod_plano_ccusto             ascending
          tta_cod_ccusto                   ascending
          tta_cod_proj_financ              ascending
          tta_cod_cenar_ctbl               ascending
          tta_cod_estab                    ascending
          tta_cod_unid_negoc               ascending
          tta_dat_sdo_ctbl                 ascending
          tta_num_seq                      ascending
    index tt_id2                          
          tta_cod_empresa                  ascending
          tta_cod_finalid_econ             ascending
          tta_cod_plano_cta_ctbl           ascending
          tta_cod_cta_ctbl                 ascending
          tta_cod_proj_financ              ascending
          tta_cod_cenar_ctbl               ascending
          tta_cod_estab                    ascending
          tta_cod_unid_negoc               ascending
          tta_dat_sdo_ctbl                 ascending
    index tt_seq                          
          tta_num_seq                      ascending.

def temp-table tt_log_erros no-undo
    field ttv_num_seq                      as integer format ">>>,>>9" label "SeqÅància" column-label "Seq"
    field ttv_num_cod_erro                 as integer format ">>>>,>>9" label "N£mero" column-label "N£mero"
    field ttv_des_erro                     as character format "x(50)" label "Inconsistància" column-label "Inconsistància"
    field ttv_des_ajuda                    as character format "x(50)" label "Ajuda" column-label "Ajuda".

DEF TEMP-TABLE tt-lancto-result LIKE int-operacao-lancto
         FIELD tta_num_seq_lancto_ctbl AS INTEGER
         FIELD contabilizada AS LOG INIT NO
         FIELD erro AS CHAR FORMAT "x(200)".

DEFINE VARIABLE v_hdl_aux         AS HANDLE     NO-UNDO.
DEFINE VARIABLE v_dat_sdo_periodo AS DATE       NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE v_des_contdo_prog_valid_dtsul AS CHARACTER   NO-UNDO FORMAT "x(40)":U.

v_des_contdo_prog_valid_dtsul = "esfgl006rp".

/*Define variaveis*/
def var p_num_vers_integr_api as integer format ">>>>,>>9" no-undo. 
def var v_cod_matriz_trad_org_ext as character format "x(8)" no-undo. 
def var v_int as i no-undo.


DEF VAR i-seq AS INTEGER NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-cad

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS cb-mes rs-contab bt-ok bt-cancelar bt-fechar ~
cb-ano fi-operacao rt-button RECT-119 
&Scoped-Define DISPLAYED-OBJECTS cb-mes rs-contab cb-ano fi-operacao 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnBeneficio esfgl007-contab 
FUNCTION fnBeneficio RETURNS CHARACTER
  ( INPUT p-tipo AS INTEGER /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnMovto esfgl007-contab 
FUNCTION fnMovto RETURNS CHARACTER
  (INPUT p-movto AS INT /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnStatus esfgl007-contab 
FUNCTION fnStatus RETURNS CHARACTER
  (INPUT p-status AS INT /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR esfgl007-contab AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-cancelar 
     LABEL "&Cancelar" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON bt-fechar AUTO-END-KEY 
     LABEL "&Fechar" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON bt-ok AUTO-GO 
     LABEL "&Contabiliza" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE VARIABLE cb-ano AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX INNER-LINES 12
     LIST-ITEMS "2015","2016","2017","2018","2019","2020","2021","2022","2023","2024","2025","2026","2027","2028","2029","2030","2031","2032","2033","2034","2035","2036","2037","2038","2039","2040" 
     DROP-DOWN-LIST
     SIZE 8.43 BY 1 NO-UNDO.

DEFINE VARIABLE cb-mes AS CHARACTER FORMAT "X(256)":U 
     LABEL "Per°odo" 
     VIEW-AS COMBO-BOX INNER-LINES 12
     LIST-ITEMS "01","02","03","04","05","06","07","08","09","10","11","12" 
     DROP-DOWN-LIST
     SIZE 6.29 BY 1 NO-UNDO.

DEFINE VARIABLE fi-operacao AS CHARACTER FORMAT "X(15)":U 
     VIEW-AS FILL-IN 
     SIZE 21 BY .88 TOOLTIP "Operaá∆o" NO-UNDO.

DEFINE VARIABLE rs-contab AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Todas", 1,
"Informada", 2
     SIZE 20 BY 1 TOOLTIP "Contabilizar todas ou s¢ a operaá∆o informada" NO-UNDO.

DEFINE RECTANGLE RECT-119
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 59.43 BY 3.63.

DEFINE RECTANGLE rt-button
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 60 BY 1.38
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-cad
     cb-mes AT ROW 1.75 COL 15 COLON-ALIGNED WIDGET-ID 92
     rs-contab AT ROW 3.25 COL 17 NO-LABEL WIDGET-ID 98
     bt-ok AT ROW 5.13 COL 1.86
     bt-cancelar AT ROW 5.13 COL 12.57 WIDGET-ID 58
     bt-fechar AT ROW 5.13 COL 50.43
     cb-ano AT ROW 1.75 COL 23.43 COLON-ALIGNED NO-LABEL WIDGET-ID 96
     fi-operacao AT ROW 3.29 COL 36 COLON-ALIGNED NO-LABEL WIDGET-ID 248
     "/" VIEW-AS TEXT
          SIZE 1.14 BY .54 AT ROW 1.92 COL 23.86 WIDGET-ID 94
          FONT 0
     "Contabilizar:" VIEW-AS TEXT
          SIZE 9 BY .54 AT ROW 3.46 COL 6 WIDGET-ID 102
     rt-button AT ROW 4.92 COL 1
     RECT-119 AT ROW 1.13 COL 1.57 WIDGET-ID 30
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D NO-AUTO-VALIDATE 
         AT COL 1 ROW 1.04
         SIZE 60.72 BY 5.88
         FONT 1
         DEFAULT-BUTTON bt-cancelar.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW esfgl007-contab ASSIGN
         HIDDEN             = YES
         TITLE              = "Contabilizaá∆o"
         HEIGHT             = 5.46
         WIDTH              = 60.43
         MAX-HEIGHT         = 28.33
         MAX-WIDTH          = 195.14
         VIRTUAL-HEIGHT     = 28.33
         VIRTUAL-WIDTH      = 195.14
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB esfgl007-contab 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{include/w-incsim.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW esfgl007-contab
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-cad
   FRAME-NAME Custom                                                    */
ASSIGN 
       bt-cancelar:HIDDEN IN FRAME f-cad           = TRUE.

ASSIGN 
       bt-fechar:HIDDEN IN FRAME f-cad           = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(esfgl007-contab)
THEN esfgl007-contab:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME esfgl007-contab
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL esfgl007-contab esfgl007-contab
ON END-ERROR OF esfgl007-contab /* Contabilizaá∆o */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL esfgl007-contab esfgl007-contab
ON WINDOW-CLOSE OF esfgl007-contab /* Contabilizaá∆o */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-cancelar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cancelar esfgl007-contab
ON CHOOSE OF bt-cancelar IN FRAME f-cad /* Cancelar */
DO:
  
  RUN notify ('cancel-record':U).
  APPLY "close":U to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-fechar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-fechar esfgl007-contab
ON CHOOSE OF bt-fechar IN FRAME f-cad /* Fechar */
DO:
  
  RUN notify ('cancel-record':U).
  APPLY "close":U to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok esfgl007-contab
ON CHOOSE OF bt-ok IN FRAME f-cad /* Contabiliza */
DO:

    /*------------------------------------ VALIDAÄÂES GERAIS ------------------------------------*/

    DEF VAR c-periodo     AS CHAR NO-UNDO.
    DEF VAR c-periodo-ant AS CHAR NO-UNDO.
    DEF VAR i-mes-ant     AS INT  NO-UNDO.
    DEF VAR i-ano-ant     AS INT  NO-UNDO.
    DEF VAR da-data       AS DATE NO-UNDO.
    
    DEF VAR c-arquivo AS CHAR NO-UNDO.

    ASSIGN c-periodo = cb-ano:SCREEN-VALUE IN FRAME f-cad + cb-mes:SCREEN-VALUE IN FRAME f-cad.
    
    IF  cb-mes:SCREEN-VALUE IN FRAME f-cad = "01" THEN 
        ASSIGN i-mes-ant = 12
               i-ano-ant = int(cb-ano:SCREEN-VALUE IN FRAME f-cad) - 1.
    ELSE 
        ASSIGN i-mes-ant = int(cb-mes:SCREEN-VALUE IN FRAME f-cad) - 1
               i-ano-ant = int(cb-ano:SCREEN-VALUE IN FRAME f-cad).

    ASSIGN c-periodo-ant = STRING(i-ano-ant, "9999") + STRING(i-mes-ant, "99").
    
    /***************************************  C R I A Ä « O   C A P A   D O   L O T E   *****************************************/
    DEF VAR da-data-lote AS DATE NO-UNDO.

    ASSIGN da-data-lote = DATE(int(cb-mes:SCREEN-VALUE IN FRAME f-cad), 01, int(cb-ano:SCREEN-VALUE IN FRAME f-cad))
           da-data-lote = da-data-lote + 32.
           da-data-lote = DATE(MONTH(da-data-lote), 01, YEAR(da-data-lote)) - 1. 

    /* Para seleá∆o de operaá‰es */
/*     DO WITH FRAME f-cad:                                                               */
/*         ASSIGN da-data = date(INT(cb-mes:SCREEN-VALUE), 01, int(cb-ano:SCREEN-VALUE)). */
/*                                                                                        */
/*         IF  cb-mes:SCREEN-VALUE = "12" THEN                                            */
/*             da-data = DATE(int(cb-mes:SCREEN-VALUE),31,YEAR(da-data)).                 */
/*         ELSE                                                                           */
/*             da-data = DATE(int(cb-mes:SCREEN-VALUE) + 1, 01,YEAR(da-data)) - 1.        */
/*     END.                                                                               */

    DEF VAR da-data-vencto       AS DATE NO-UNDO.
    DEF VAR da-data-fechamento   AS DATE NO-UNDO.
  
    DO WITH FRAME f-cad:
        ASSIGN da-data-vencto     = date(INT(cb-mes:SCREEN-VALUE), 01, int(cb-ano:SCREEN-VALUE)).
        ASSIGN da-data-fechamento = date(INT(cb-mes:SCREEN-VALUE), 01, int(cb-ano:SCREEN-VALUE)).
  
        IF  cb-mes:SCREEN-VALUE = "12" THEN
            da-data-fechamento = DATE(int(cb-mes:SCREEN-VALUE),31,YEAR(da-data-fechamento)).
        ELSE
            da-data-fechamento = DATE(int(cb-mes:SCREEN-VALUE) + 1, 01,YEAR(da-data-fechamento)) - 1.
    END.

    EMPTY TEMP-TABLE tt-lancto-result.
    EMPTY TEMP-TABLE tt_integr_aprop_lancto_ctbl_1.
    EMPTY TEMP-TABLE tt_integr_ctbl_valid_1.
    EMPTY TEMP-TABLE tt_integr_ctbl_valid_parametros.
    EMPTY TEMP-TABLE tt_integr_item_lancto_ctbl_1.
    EMPTY TEMP-TABLE tt_integr_lancto_ctbl_1.
    EMPTY TEMP-TABLE tt_integr_lancto_ctbl_aux.
    EMPTY TEMP-TABLE tt_integr_lote_ctbl_1.

    CREATE tt_integr_lote_ctbl_1.
    ASSIGN tt_integr_lote_ctbl_1.tta_cod_modul_dtsul      = "FGL"
           tt_integr_lote_ctbl_1.tta_num_lote_ctbl        = 99999999
           tt_integr_lote_ctbl_1.tta_des_lote_ctbl        = "Op_Hedge_ "  +
                                                             string(int(cb-mes:SCREEN-VALUE IN FRAME f-cad),"99") + "/" +
                                                             string(int(cb-ano:SCREEN-VALUE IN FRAME f-cad))
           tt_integr_lote_ctbl_1.tta_cod_empresa          = "1"
           tt_integr_lote_ctbl_1.tta_dat_lote_ctbl        = da-data-lote
           tt_integr_lote_ctbl_1.ttv_rec_integr_lote_ctbl = RECID(tt_integr_lote_ctbl_1).

    CREATE tt_integr_lancto_ctbl_1.
    ASSIGN tt_integr_lancto_ctbl_1.tta_cod_cenar_ctbl         = ""
           tt_integr_lancto_ctbl_1.ttv_rec_integr_lote_ctbl   = tt_integr_lote_ctbl_1.ttv_rec_integr_lote_ctbl
           tt_integr_lancto_ctbl_1.tta_num_lancto_ctbl        = 1
           tt_integr_lancto_ctbl_1.tta_dat_lancto_ctbl        = da-data-lote
           tt_integr_lancto_ctbl_1.ttv_rec_integr_lancto_ctbl = RECID(tt_integr_lancto_ctbl_1).

    /****************************************************************************************************************************/

    DEF VAR c-erro-operacao AS CHAR FORMAT "x(200)" NO-UNDO.
    DEF VAR c-erro          AS CHAR FORMAT "x(200)" NO-UNDO.
    /*----------------------------------------- GRAVAÄ«O-----------------------------------------*/
    IF  rs-contab:SCREEN-VALUE IN FRAME f-cad = "2" THEN DO: /* INFORMADA */
        
        FIND FIRST int-operacao-lancto NO-LOCK
            WHERE int-operacao-lancto.operacao = fi-operacao:SCREEN-VALUE IN FRAME f-cad 
              AND int-operacao-lancto.periodo  = c-periodo NO-ERROR.

        IF  NOT AVAIL  int-operacao-lancto THEN DO:
            RUN utp/ut-msgs.p(INPUT "show",
                              INPUT 17006,
                              INPUT "Operaá∆o inexistente").

            RETURN NO-APPLY.
        END.


        RUN utp/ut-msgs.p(INPUT "show":U,
                          INPUT 27100,
                          INPUT "Confirma C†lculo da operaá∆o < " + int-operacao-lancto.operacao + " > para o per°odo?" + "~~" +
                                "Apenas a operaá∆o informada").
        IF  RETURN-VALUE = "no" THEN 
            RETURN NO-APPLY.

        /* Valida se j† est† contabilizado */
       FOR FIRST int-operacao NO-LOCK
/*             WHERE int-operacao.dt-fechamento <= da-data  */
/*              AND  int-operacao.dt-vencimento >= da-data  */
           WHERE int-operacao.dt-fechamento <= da-data-fechamento
             AND int-operacao.dt-vencimento >= da-data-vencto
             AND int-operacao.operacao       = fi-operacao:SCREEN-VALUE IN FRAME f-cad:
                    
            FOR EACH int-operacao-lancto NO-LOCK 
                WHERE int-operacao-lancto.operacao = int-operacao.operacao
                  AND int-operacao-lancto.periodo  = c-periodo
                    BY int-operacao-lancto.periodo DESC
                    BY int-operacao-lancto.tp-lancto:
    
    
                CREATE tt-lancto-result.
                BUFFER-COPY int-operacao-lancto TO tt-lancto-result.
                
                IF  int-operacao-lancto.num_lote_ctbl > 0 THEN DO:
                    FIND lote_ctbl NO-LOCK
                       WHERE lote_ctbl.num_lote_ctbl = int-operacao-lancto.num_lote_ctbl NO-ERROR.
                    IF  AVAIL lote_ctbl THEN 
                        ASSIGN tt-lancto-result.erro  = "J† existe lanáamento contabilizado para essa per°odo".
        
                END.
    
                IF  tt-lancto-result.erro = "" THEN
                    RUN pi-contabiliza (INPUT p-passivo   ,
                                        INPUT p-vc-ativo  ,
                                        INPUT p-vc-passivo,
                                        INPUT da-data-lote).
            END.

        END.

    END.
    /*********/
    /* TODAS */
    /*********/
    ELSE DO:  
        
        RUN utp/ut-msgs.p(INPUT "show":U,
                          INPUT 27100,
                          INPUT "Confirma Contabilizaá∆o das operaá‰es para o per°odo?" + "~~" +
                                "Ser∆o calculadas todas as operaá‰es com datas iguais ou inferiores ao per°odo informado." ).
        IF  RETURN-VALUE = "no" THEN 
            RETURN NO-APPLY.

        
        /* ------------------------------------------------------------------------ CONTABILIZA AS OPERAÄÂES --------------------------------------------------------------------------*/
        DEF VAR c-contabilizado AS CHAR NO-UNDO.
        DEF VAR i-num-lancto    AS INT  NO-UNDO.
        DEF BUFFER b-lancto FOR int-operacao-lancto.

        EMPTY TEMP-TABLE tt-lancto-result.

        FOR EACH int-operacao NO-LOCK
/*             WHERE int-operacao.dt-fechamento <= da-data  */
/*              AND  int-operacao.dt-vencimento >= da-data  */
           WHERE int-operacao.dt-fechamento <= da-data-fechamento
             AND int-operacao.dt-vencimento >= da-data-vencto:
                    
            FOR EACH int-operacao-lancto NO-LOCK 
                WHERE int-operacao-lancto.operacao = int-operacao.operacao
                  AND int-operacao-lancto.periodo  = c-periodo
                    BY int-operacao-lancto.periodo DESC
                    BY int-operacao-lancto.tp-lancto:
                
                 CREATE tt-lancto-result.
                 BUFFER-COPY int-operacao-lancto TO tt-lancto-result.

                /* Valida se j† est† contabilizado */
                IF  int-operacao-lancto.num_lote_ctbl > 0 THEN DO:
                    FIND lote_ctbl NO-LOCK
                       WHERE lote_ctbl.num_lote_ctbl = int-operacao-lancto.num_lote_ctbl NO-ERROR.
                    IF  AVAIL lote_ctbl THEN 
                        ASSIGN tt-lancto-result.erro  = "J† existe lanáamento contabilizado para essa para esse per°odo".

                    NEXT.
                END.

                /************* C µ L C U L O **************/
                IF  tt-lancto-result.erro = "" THEN
                    RUN pi-contabiliza (INPUT p-passivo   ,
                                        INPUT p-vc-ativo  ,
                                        INPUT p-vc-passivo,
                                        INPUT da-data-lote).
            END.
        END.

    END.

    /********************************* E N V I A R   P A R A   A   C O N T A B I L I D A D E  ************************************************/


    DEF VAR v_cod_arq AS CHAR NO-UNDO.
    DEF VAR l-commit  AS LOG NO-UNDO.
    
    ASSIGN v_cod_arq = SESSION:TEMP-DIRECTORY + "Rel_Contab_Operacao_erros_" + "esfgl007.txt".

    OUTPUT STREAM s_1 TO VALUE(v_cod_arq)
    PAGED PAGE-SIZE VALUE(65) CONVERT TARGET 'iso8859-1'.

    bloco:
    DO TRANS:
    
        RUN prgfin/fgl/fgl900zl.py (INPUT 3,
                                    INPUT "Aborta Tudo",
                                    INPUT YES,
                                    INPUT 66,
                                    INPUT "Apropriaá∆o",
                                    INPUT "Todos",
                                    INPUT YES,
                                    INPUT YES,
                                    INPUT-OUTPUT TABLE tt_integr_lote_ctbl_1,
                                    INPUT-OUTPUT TABLE tt_integr_lancto_ctbl_1,
                                    INPUT-OUTPUT TABLE tt_integr_item_lancto_ctbl_1,
                                    INPUT-OUTPUT TABLE tt_integr_aprop_lancto_ctbl_1,
                                    INPUT-OUTPUT TABLE tt_integr_ctbl_valid_1).
    
        FIND FIRST tt_integr_lote_ctbl_1.
    
        OUTPUT STREAM S_1 CLOSE.
        DOS SILENT START notepad.exe VALUE(v_cod_arq).
    
        DEF VAR l-contabilizou AS LOG NO-UNDO.
    
    
        ASSIGN c-arquivo = SESSION:TEMP-DIRECTORY + "Rel_Contab_Operacao_" + STRING(DAY(TODAY)) + "-" + STRING(MONTH(TODAY)) + "-" + STRING(YEAR(TODAY)) + "_" + STRING(TIME) + ".csv".
        OUTPUT TO VALUE(c-arquivo) CONVERT TARGET "iso8859-1".
    
        PUT "Contabilizada;Operaá∆o;Per°odo;Tipo;Variaá∆o;Cotaá∆o;Lote;Observaá∆o" SKIP.
    
        IF  AVAIL tt_integr_lote_ctbl_1 AND tt_integr_lote_ctbl_1.tta_num_lote_ctbl <> 99999999 THEN DO TRANS:
            FOR EACH tt-lancto-result:
    
                FIND int-operacao-lancto EXCLUSIVE-LOCK
                    WHERE int-operacao-lancto.operacao  = tt-lancto-result.operacao
                      AND int-operacao-lancto.periodo   = tt-lancto-result.periodo
                      AND int-operacao-lancto.tp-lancto = tt-lancto-result.tp-lancto NO-ERROR.

                IF  AVAIL int-operacao-lancto THEN DO:
  
                    IF  tt-lancto-result.erro = ""  THEN DO:
                        ASSIGN int-operacao-lancto.num_lote_ctbl   = tt_integr_lote_ctbl_1.tta_num_lote_ctbl
                               tt-lancto-result.contabilizada      = YES
                               tt-lancto-result.num_lote_ctbl      = tt_integr_lote_ctbl_1.tta_num_lote_ctbl
                               l-commit                            = YES.
                    END.
                END.
            END.
       END.

       IF  NOT l-commit THEN  DO:
           UNDO bloco, LEAVE.
       END.

   END.

   FOR EACH tt-lancto-result:

       PUT (IF  tt-lancto-result.contabilizada THEN "Sim" ELSE "N∆o")                 FORMAT "X(3)"  ";"       
           tt-lancto-result.operacao                                                                 ";"       
           substr(tt-lancto-result.periodo, 5,2) + "/" + substr(tt-lancto-result.periodo, 1, 4)   ";"       
           tt-lancto-result.tp-lancto                                                                ";"       
           tt-lancto-result.variacao                                                                 ";"       
           tt-lancto-result.cotacao                                                                  ";"      
           tt-lancto-result.num_lote_ctbl                                                          ";"   
           (IF tt-lancto-result.erro = "" AND tt-lancto-result.contabilizada THEN "Contabilizado com sucesso" ELSE tt-lancto-result.erro) FORMAT "x(300)" SKIP. 
   END.



    OUTPUT CLOSE.

    DOS SILENT START excel VALUE(c-arquivo).

    apply "close":U to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs-contab
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-contab esfgl007-contab
ON VALUE-CHANGED OF rs-contab IN FRAME f-cad
DO:
  
    IF  rs-contab:SCREEN-VALUE IN FRAME f-cad = "1" THEN
        ASSIGN fi-operacao:VISIBLE IN FRAME f-cad = NO.
               
    ELSE
        ASSIGN fi-operacao:VISIBLE IN FRAME f-cad = YES.
               

    fi-operacao:SCREEN-VALUE IN FRAME f-cad = p-operacao-sugerida.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK esfgl007-contab 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects esfgl007-contab  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available esfgl007-contab  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI esfgl007-contab  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(esfgl007-contab)
  THEN DELETE WIDGET esfgl007-contab.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI esfgl007-contab  _DEFAULT-ENABLE
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
  DISPLAY cb-mes rs-contab cb-ano fi-operacao 
      WITH FRAME f-cad IN WINDOW esfgl007-contab.
  ENABLE cb-mes rs-contab bt-ok bt-cancelar bt-fechar cb-ano fi-operacao 
         rt-button RECT-119 
      WITH FRAME f-cad IN WINDOW esfgl007-contab.
  {&OPEN-BROWSERS-IN-QUERY-f-cad}
  VIEW esfgl007-contab.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy esfgl007-contab 
PROCEDURE local-destroy :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */

  
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .
  {include/i-logfin.i}

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display esfgl007-contab 
PROCEDURE local-display :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
        
     
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit esfgl007-contab 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize esfgl007-contab 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    /* Code placed here will execute PRIOR to standard behavior. */
    {include/win-size.i}
    
    {utp/ut9000.i "esfgl007-contab" "2.00.00.000"}
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

    RUN dispatch  IN this-procedure ('enable-fields':U).
    
    RUN dispatch  IN this-procedure ('display-fields':U).

    DO WITH FRAME f-cad:
    
        ASSIGN  cb-mes:SENSITIVE        = YES
                cb-mes:SCREEN-VALUE     = string(MONTH(TODAY), "99")
                cb-ano:SENSITIVE        = YES
                cb-ano:SCREEN-VALUE     = string(YEAR(TODAY))
                rs-contab:SENSITIVE    = YES
                rs-contab:SCREEN-VALUE = "2"
                fi-operacao:SENSITIVE   = yes.

        APPLY "value-changed" TO rs-contab.
    END.
{include/i-inifld.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-contabiliza esfgl007-contab 
PROCEDURE pi-contabiliza :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


    DEF INPUT PARAM p-passivo    AS CHAR NO-UNDO.
    DEF INPUT PARAM p-vc-ativa   AS CHAR NO-UNDO.
    DEF INPUT PARAM p-vc-passiva AS CHAR NO-UNDO.
    DEF INPUT PARAM p-data-lote  AS DATE NO-UNDO.

    /* Tipo C†lculo */
    IF  int-operacao-lancto.variacao > 0 THEN DO:
        IF  int-operacao-lancto.tp-lancto = "C" THEN DO: /* C†lculo */
        
            RUN pi-cria-lancto ( INPUT p-passivo,    
                                 INPUT "DB",     
                                 INPUT "Referente Operaá∆o Hedge < " + int-operacao-lancto.operacao + " >.",
                                 INPUT p-data-lote, 
                                 INPUT int-operacao-lancto.variacao).
    
            RUN pi-cria-lancto ( INPUT p-VC-Ativa,    
                                 INPUT "CR",     
                                 INPUT "Referente Operaá∆o Hedge < " + int-operacao-lancto.operacao + " >.",
                                 INPUT p-data-lote, 
                                 INPUT int-operacao-lancto.variacao).

        END.
        ELSE DO: /* Revers∆o */
            RUN pi-cria-lancto ( INPUT p-VC-Passiva,    
                                 INPUT "CR",     
                                 INPUT "Referente Operaá∆o Hedge < " + int-operacao-lancto.operacao + " >.",
                                 INPUT p-data-lote, 
                                 INPUT int-operacao-lancto.variacao).
    
            RUN pi-cria-lancto ( INPUT p-passivo,    
                                 INPUT "DB",     
                                 INPUT "Referente Operaá∆o Hedge < " + int-operacao-lancto.operacao + " >.",
                                 INPUT p-data-lote, 
                                 INPUT int-operacao-lancto.variacao).
        END.
    END.

    IF  int-operacao-lancto.variacao < 0 THEN DO:
        IF  int-operacao-lancto.tp-lancto = "C" THEN DO:
        
            RUN pi-cria-lancto ( INPUT p-passivo,    
                                 INPUT "CR" /*"DB"*/ ,     
                                 INPUT "Referente Operaá∆o Hedge < " + int-operacao-lancto.operacao + " >.",
                                 INPUT p-data-lote, 
                                 INPUT int-operacao-lancto.variacao).
    
            RUN pi-cria-lancto ( INPUT p-VC-Passiva,     
                                 INPUT "DB" /*"CR"*/ ,     
                                 INPUT "Referente Operaá∆o Hedge < " + int-operacao-lancto.operacao + " >.",
                                 INPUT p-data-lote, 
                                 INPUT int-operacao-lancto.variacao).
        END.
        ELSE DO:
            RUN pi-cria-lancto ( INPUT p-VC-Ativa,    
                                 INPUT "DB",     
                                 INPUT "Referente Operaá∆o Hedge < " + int-operacao-lancto.operacao + " >.",
                                 INPUT p-data-lote, 
                                 INPUT int-operacao-lancto.variacao).
    
            RUN pi-cria-lancto ( INPUT p-passivo,    
                                 INPUT "CR",     
                                 INPUT "Referente Operaá∆o Hedge < " + int-operacao-lancto.operacao + " >.",
                                 INPUT p-data-lote, 
                                 INPUT int-operacao-lancto.variacao).
        END.
    END.


        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-lancto esfgl007-contab 
PROCEDURE pi-cria-lancto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAM p-conta      AS CHAR    NO-UNDO.
    DEF INPUT PARAM p-tipo       AS CHAR    NO-UNDO.
    DEF INPUT PARAM p-descricao  AS CHAR    FORMAT "X(100)" NO-UNDO.
    DEF INPUT PARAM p-data-fim   AS DATE    NO-UNDO.
    DEF INPUT PARAM p-valor      AS DEC     NO-UNDO.

    ASSIGN i-seq = i-seq + 1.

    IF  p-valor < 0  THEN
        ASSIGN p-valor = p-valor * (-1).

    CREATE tt_integr_item_lancto_ctbl_1.
    ASSIGN tt_integr_item_lancto_ctbl_1.ttv_rec_integr_lancto_ctbl      = tt_integr_lancto_ctbl_1.ttv_rec_integr_lancto_ctbl
           tt_integr_item_lancto_ctbl_1.tta_num_seq_lancto_ctbl         = i-seq
           tt_integr_item_lancto_ctbl_1.tta_ind_natur_lancto_ctbl       = p-tipo
           tt_integr_item_lancto_ctbl_1.tta_cod_plano_cta_ctbl          = "Padrao"
           tt_integr_item_lancto_ctbl_1.tta_cod_cta_ctbl                = p-conta
           tt_integr_item_lancto_ctbl_1.tta_cod_plano_ccusto            = ""
           tt_integr_item_lancto_ctbl_1.tta_cod_ccusto                  = ""
           tt_integr_item_lancto_ctbl_1.tta_cod_estab                   = "101"
           tt_integr_item_lancto_ctbl_1.tta_cod_unid_negoc              = "ADM"
           tt_integr_item_lancto_ctbl_1.tta_des_histor_lancto_ctbl      = p-descricao
           tt_integr_item_lancto_ctbl_1.tta_cod_indic_econ              = "Real"
           tt_integr_item_lancto_ctbl_1.tta_dat_lancto_ctbl             = p-data-fim
           tt_integr_item_lancto_ctbl_1.tta_val_lancto_ctbl             = p-valor
           tt_integr_item_lancto_ctbl_1.tta_cod_proj_financ             = ""
           tt_integr_item_lancto_ctbl_1.ttv_rec_integr_item_lancto_ctbl = RECID(tt_integr_item_lancto_ctbl_1).


    CREATE tt_integr_aprop_lancto_ctbl_1.
    ASSIGN tt_integr_aprop_lancto_ctbl_1.tta_cod_finalid_econ             = "Corrente"
           tt_integr_aprop_lancto_ctbl_1.tta_cod_unid_negoc               = "ADM"
           tt_integr_aprop_lancto_ctbl_1.tta_cod_plano_ccusto             = ""
           tt_integr_aprop_lancto_ctbl_1.tta_cod_ccusto                   = ""
           tt_integr_aprop_lancto_ctbl_1.tta_val_lancto_ctbl              = p-valor
           tt_integr_aprop_lancto_ctbl_1.ttv_rec_integr_item_lancto_ctbl  = tt_integr_item_lancto_ctbl_1.ttv_rec_integr_item_lancto_ctbl
           tt_integr_aprop_lancto_ctbl_1.ttv_rec_integr_aprop_lancto_ctbl = RECID(tt_integr_aprop_lancto_ctbl_1).


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records esfgl007-contab  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartWindow, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed esfgl007-contab 
PROCEDURE state-changed :
/*:T -----------------------------------------------------------
  Purpose:     Manuseia trocas de estado dos SmartObjects
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.

  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnBeneficio esfgl007-contab 
FUNCTION fnBeneficio RETURNS CHARACTER
  ( INPUT p-tipo AS INTEGER /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  CASE p-tipo:
      WHEN 21 THEN RETURN "V M C".
      WHEN 37 THEN RETURN "Rebate".
      WHEN 22 THEN RETURN "Stock Rotation".
      WHEN 66 THEN RETURN "Rebate P¢s-Venda".
  END CASE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnMovto esfgl007-contab 
FUNCTION fnMovto RETURNS CHARACTER
  (INPUT p-movto AS INT /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  CASE p-movto:
      WHEN 1 THEN RETURN "PROV".
      WHEN 2 THEN RETURN "DESP".
  END CASE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnStatus esfgl007-contab 
FUNCTION fnStatus RETURNS CHARACTER
  (INPUT p-status AS INT /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  CASE p-status:
      WHEN 1 THEN RETURN "Ativo".
      WHEN 2 THEN RETURN "Bloqueado".
      WHEN 3 THEN RETURN "Cancelado".
      WHEN 4 THEN RETURN "Finalizado".
  END CASE.


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

