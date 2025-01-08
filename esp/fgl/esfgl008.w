&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          emscad             PROGRESS
          emsmov             PROGRESS
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME w-cadsim


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt_cta_corren_cta_ctbl NO-UNDO LIKE cta_corren_cta_ctbl
       field de_saldo_cta_corren  as dec
       field de_saldo_cta_ctbl    as dec
       field de_saldo_moeda_orig  as dec
       field cod_finalid_econ     as char
       field nom_abrev_cta_corren as char
       field val_cotac_indic_econ as dec decimals 10.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS w-cadsim 
{include/i-prgvrs.i esfgl008 2.00.00.000}

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

DEFINE VARIABLE h-api AS HANDLE NO-UNDO.

/* Local Variable Definitions ---                                       */
define variable wh-imprime as handle no-undo.
DEFINE VARIABLE cTransacao AS CHARACTER FORMAT "X(15)"  NO-UNDO.
DEFINE VARIABLE hprogramzoom AS HANDLE NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE c-seg-usuario     AS CHARACTER NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE l-implanta        AS LOGICAL.
def new global shared var h-facelift as handle no-undo.

DEF VAR i-situacao      AS INTEGER NO-UNDO.
DEFINE VARIABLE wh-pesquisa AS HANDLE NO-UNDO.
DEF VAR h-acomp AS HANDLE NO-UNDO.
DEF VAR i-cor AS INT NO-UNDO.


def temp-table tt-erro-aux no-undo
    field i-sequen as int             
    field cd-erro  as int
    field mensagem as char format "x(255)".

DEF TEMP-TABLE tt-erro NO-UNDO
    FIELD codigo   AS INTEGER
    FIELD mensagem AS CHAR FORMAT "X(200)"
    FIELD ajuda    AS CHAR FORMAT "X(250)".


IF NOT VALID-HANDLE(h-facelift) THEN
    RUN btb/btb901zo.p PERSISTENT SET h-facelift.

{utp/ut-glob.i}
{esp/es0018.i}


DEFINE VARIABLE v_win_original_width  AS DECIMAL     NO-UNDO.
DEFINE VARIABLE v_win_original_height AS DECIMAL     NO-UNDO.

DEFINE VARIABLE v_column AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v_asc    AS LOGICAL     NO-UNDO.

DEF STREAM s-1.

def new global shared var v_cod_empres_usuar
    as character
    format "x(3)":U
    label "Empresa"
    column-label "Empresa"
    no-undo.

DEF NEW SHARED STREAM s_1.

DEFINE VARIABLE i_mes             AS INTEGER     NO-UNDO.
DEFINE VARIABLE i_ano             AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-seq-lancto      AS INTEGER     NO-UNDO.
DEFINE VARIABLE v_dat_sdo_periodo AS DATE        NO-UNDO.
DEFINE VARIABLE v_cod_cta_ctbl_pa AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v_cod_cta_ctbl_at AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v_cod_cta_ctbl_cp AS CHARACTER   NO-UNDO.

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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-cad
&Scoped-define BROWSE-NAME br-contabiliza

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES int_variac_cambial_cta_corren ~
tt_cta_corren_cta_ctbl

/* Definitions for BROWSE br-contabiliza                                */
&Scoped-define FIELDS-IN-QUERY-br-contabiliza ~
int_variac_cambial_cta_corren.num_lote_ctbl ~
int_variac_cambial_cta_corren.val_variacao ~
int_variac_cambial_cta_corren.cod_cta_ctbl_contra_partida ~
int_variac_cambial_cta_corren.cod_usuar_ult_atualiz ~
int_variac_cambial_cta_corren.dat_ult_atualiz ~
int_variac_cambial_cta_corren.hra_ult_atualiz 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-contabiliza 
&Scoped-define QUERY-STRING-br-contabiliza FOR EACH int_variac_cambial_cta_corren ~
      WHERE int_variac_cambial_cta_corren.cod_cta_ctbl = c-cta-ctbl-ini ~
 AND int_variac_cambial_cta_corren.cod_periodo = c-periodo NO-LOCK
&Scoped-define OPEN-QUERY-br-contabiliza OPEN QUERY br-contabiliza FOR EACH int_variac_cambial_cta_corren ~
      WHERE int_variac_cambial_cta_corren.cod_cta_ctbl = c-cta-ctbl-ini ~
 AND int_variac_cambial_cta_corren.cod_periodo = c-periodo NO-LOCK.
&Scoped-define TABLES-IN-QUERY-br-contabiliza int_variac_cambial_cta_corren
&Scoped-define FIRST-TABLE-IN-QUERY-br-contabiliza int_variac_cambial_cta_corren


/* Definitions for BROWSE br-cta                                        */
&Scoped-define FIELDS-IN-QUERY-br-cta tt_cta_corren_cta_ctbl.cod_cta_corren ~
tt_cta_corren_cta_ctbl.cod_finalid_econ @ tt_cta_corren_cta_ctbl.cod_finalid_econ ~
tt_cta_corren_cta_ctbl.de_saldo_moeda_orig @ tt_cta_corren_cta_ctbl.de_saldo_moeda_orig ~
tt_cta_corren_cta_ctbl.de_saldo_cta_corren @ tt_cta_corren_cta_ctbl.de_saldo_cta_corren ~
tt_cta_corren_cta_ctbl.val_cotac_indic_econ @ tt_cta_corren_cta_ctbl.val_cotac_indic_econ 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-cta 
&Scoped-define QUERY-STRING-br-cta FOR EACH tt_cta_corren_cta_ctbl NO-LOCK
&Scoped-define OPEN-QUERY-br-cta OPEN QUERY br-cta FOR EACH tt_cta_corren_cta_ctbl NO-LOCK.
&Scoped-define TABLES-IN-QUERY-br-cta tt_cta_corren_cta_ctbl
&Scoped-define FIRST-TABLE-IN-QUERY-br-cta tt_cta_corren_cta_ctbl


/* Definitions for FRAME f-cad                                          */
&Scoped-define OPEN-BROWSERS-IN-QUERY-f-cad ~
    ~{&OPEN-QUERY-br-contabiliza}~
    ~{&OPEN-QUERY-br-cta}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br-contabiliza c-cta-ctbl-ini c-periodo ~
bt-filtrar bt-ok br-cta RECT-157 RECT-158 RECT-159 
&Scoped-Define DISPLAYED-OBJECTS c-cta-ctbl-ini c-periodo ~
v_val_sdo_cta_ctbl v_val_sdo_cta_corren v_val_diferenca 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR w-cadsim AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-contabiliza 
     IMAGE-UP FILE "image/im-lote.bmp":U
     LABEL "" 
     SIZE 4.29 BY 1.25 TOOLTIP "Contabilizar diferenáa variaá∆o cambial".

DEFINE BUTTON bt-del 
     IMAGE-UP FILE "image/im-era.bmp":U
     LABEL "" 
     SIZE 4.29 BY 1.25 TOOLTIP "Eliminar Contabilizaá∆o".

DEFINE BUTTON bt-filtrar 
     IMAGE-UP FILE "image/im-enter.bmp":U
     LABEL "" 
     SIZE 5 BY 1.13 TOOLTIP "Buscar Saldos".

DEFINE BUTTON bt-lan 
     IMAGE-UP FILE "image/im-conta.bmp":U
     LABEL "" 
     SIZE 4.29 BY 1.25 TOOLTIP "Lanáamentos Cont†beis".

DEFINE BUTTON bt-ok AUTO-GO 
     IMAGE-UP FILE "image/im-exi.bmp":U
     LABEL "&Fechar" 
     SIZE 4 BY 1.13 TOOLTIP "Sair do programa"
     BGCOLOR 8 .

DEFINE VARIABLE c-cta-ctbl-ini AS CHARACTER FORMAT "X(8)":U 
     LABEL "Conta Cont†bil" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 TOOLTIP "Conta Cont†bil" NO-UNDO.

DEFINE VARIABLE c-periodo AS CHARACTER FORMAT "9999/99":U 
     LABEL "Per°odo" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 TOOLTIP "Per°odo" NO-UNDO.

DEFINE VARIABLE v_val_diferenca AS DECIMAL FORMAT "->>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Diferenáa" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE v_val_sdo_cta_corren AS DECIMAL FORMAT "->>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Saldo Contas Correntes" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE v_val_sdo_cta_ctbl AS DECIMAL FORMAT "->>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Saldo Cont†bil" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-157
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 61 BY 12.5.

DEFINE RECTANGLE RECT-158
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 61 BY 4.25.

DEFINE RECTANGLE RECT-159
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 61 BY 2.75.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-contabiliza FOR 
      int_variac_cambial_cta_corren SCROLLING.

DEFINE QUERY br-cta FOR 
      tt_cta_corren_cta_ctbl SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-contabiliza
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-contabiliza w-cadsim _STRUCTURED
  QUERY br-contabiliza NO-LOCK DISPLAY
      int_variac_cambial_cta_corren.num_lote_ctbl COLUMN-LABEL "Lote Cont†bil" FORMAT ">>>,>>>,>>9":U
            WIDTH 17.43
      int_variac_cambial_cta_corren.val_variacao COLUMN-LABEL "Variaá∆o R$" FORMAT "->>>,>>>,>>9.99":U
      int_variac_cambial_cta_corren.cod_cta_ctbl_contra_partida FORMAT "x(10)":U
      int_variac_cambial_cta_corren.cod_usuar_ult_atualiz FORMAT "x(12)":U
      int_variac_cambial_cta_corren.dat_ult_atualiz FORMAT "99/99/9999":U
      int_variac_cambial_cta_corren.hra_ult_atualiz FORMAT "x(8)":U
            WIDTH 10
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 54 BY 3.75
         FONT 1
         TITLE "Contabilizaá∆o Variaá∆o" FIT-LAST-COLUMN.

DEFINE BROWSE br-cta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-cta w-cadsim _STRUCTURED
  QUERY br-cta NO-LOCK DISPLAY
      tt_cta_corren_cta_ctbl.cod_cta_corren FORMAT "x(10)":U WIDTH 10.43
      tt_cta_corren_cta_ctbl.cod_finalid_econ @ tt_cta_corren_cta_ctbl.cod_finalid_econ COLUMN-LABEL "Moeda" FORMAT "x(20)":U
            WIDTH 9.43
      tt_cta_corren_cta_ctbl.de_saldo_moeda_orig @ tt_cta_corren_cta_ctbl.de_saldo_moeda_orig COLUMN-LABEL "Saldo Orig" FORMAT "->>>,>>>,>>9.99":U
      tt_cta_corren_cta_ctbl.de_saldo_cta_corren @ tt_cta_corren_cta_ctbl.de_saldo_cta_corren COLUMN-LABEL "Saldo R$" FORMAT "->>>,>>>,>>9.99":U
      tt_cta_corren_cta_ctbl.val_cotac_indic_econ @ tt_cta_corren_cta_ctbl.val_cotac_indic_econ COLUMN-LABEL "Cotaá∆o" FORMAT "->9.9999999999":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 59 BY 8.25
         FONT 1
         TITLE "Contas Correntes".


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-cad
     br-contabiliza AT ROW 17.25 COL 2 WIDGET-ID 1000
     c-cta-ctbl-ini AT ROW 1.5 COL 23 COLON-ALIGNED WIDGET-ID 248
     c-periodo AT ROW 2.75 COL 23 COLON-ALIGNED WIDGET-ID 266
     bt-filtrar AT ROW 2.54 COL 36 WIDGET-ID 132
     bt-ok AT ROW 1.5 COL 57 WIDGET-ID 242
     br-cta AT ROW 4.5 COL 2 WIDGET-ID 900
     v_val_sdo_cta_ctbl AT ROW 13 COL 20 COLON-ALIGNED WIDGET-ID 304
     v_val_sdo_cta_corren AT ROW 14 COL 20 COLON-ALIGNED WIDGET-ID 306
     v_val_diferenca AT ROW 15.5 COL 20 COLON-ALIGNED WIDGET-ID 308
     bt-contabiliza AT ROW 15.25 COL 57 WIDGET-ID 244
     bt-del AT ROW 17.25 COL 57 WIDGET-ID 298
     bt-lan AT ROW 18.75 COL 57 WIDGET-ID 310
     RECT-157 AT ROW 4.25 COL 1 WIDGET-ID 270
     RECT-158 AT ROW 17 COL 1 WIDGET-ID 300
     RECT-159 AT ROW 1.25 COL 1 WIDGET-ID 302
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 134 BY 24.5
         BGCOLOR 15 FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Design Page: 1
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt_cta_corren_cta_ctbl T "?" NO-UNDO ems5 cta_corren_cta_ctbl
      ADDITIONAL-FIELDS:
          field de_saldo_cta_corren  as dec
          field de_saldo_cta_ctbl    as dec
          field de_saldo_moeda_orig  as dec
          field cod_finalid_econ     as char
          field nom_abrev_cta_corren as char
          field val_cotac_indic_econ as dec decimals 10
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW w-cadsim ASSIGN
         HIDDEN             = YES
         TITLE              = "Variaá∆o Cambial Conta Corrente"
         HEIGHT             = 20.38
         WIDTH              = 61.43
         MAX-HEIGHT         = 28.67
         MAX-WIDTH          = 195.14
         VIRTUAL-HEIGHT     = 28.67
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB w-cadsim 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{include/w-incsim.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW w-cadsim
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-cad
   FRAME-NAME Custom                                                    */
/* BROWSE-TAB br-contabiliza 1 f-cad */
/* BROWSE-TAB br-cta bt-ok f-cad */
/* SETTINGS FOR BUTTON bt-contabiliza IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON bt-del IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON bt-lan IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v_val_diferenca IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v_val_sdo_cta_corren IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v_val_sdo_cta_ctbl IN FRAME f-cad
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-cadsim)
THEN w-cadsim:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-contabiliza
/* Query rebuild information for BROWSE br-contabiliza
     _TblList          = "mgesp.int_variac_cambial_cta_corren"
     _Options          = "NO-LOCK"
     _Where[1]         = "int_variac_cambial_cta_corren.cod_cta_ctbl = c-cta-ctbl-ini
 AND int_variac_cambial_cta_corren.cod_periodo = c-periodo"
     _FldNameList[1]   > mgesp.int_variac_cambial_cta_corren.num_lote_ctbl
"num_lote_ctbl" "Lote Cont†bil" ? "integer" ? ? ? ? ? ? no "Lote Cont†bil" no no "17.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > mgesp.int_variac_cambial_cta_corren.val_variacao
"val_variacao" "Variaá∆o R$" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   = mgesp.int_variac_cambial_cta_corren.cod_cta_ctbl_contra_partida
     _FldNameList[4]   = mgesp.int_variac_cambial_cta_corren.cod_usuar_ult_atualiz
     _FldNameList[5]   = mgesp.int_variac_cambial_cta_corren.dat_ult_atualiz
     _FldNameList[6]   > mgesp.int_variac_cambial_cta_corren.hra_ult_atualiz
"hra_ult_atualiz" ? ? "character" ? ? ? ? ? ? no ? no no "10" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE br-contabiliza */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-cta
/* Query rebuild information for BROWSE br-cta
     _TblList          = "Temp-Tables.tt_cta_corren_cta_ctbl"
     _Options          = "NO-LOCK"
     _FldNameList[1]   > Temp-Tables.tt_cta_corren_cta_ctbl.cod_cta_corren
"cod_cta_corren" ? ? "character" ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"tt_cta_corren_cta_ctbl.cod_finalid_econ @ tt_cta_corren_cta_ctbl.cod_finalid_econ" "Moeda" "x(20)" ? ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > "_<CALC>"
"tt_cta_corren_cta_ctbl.de_saldo_moeda_orig @ tt_cta_corren_cta_ctbl.de_saldo_moeda_orig" "Saldo Orig" "->>>,>>>,>>9.99" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > "_<CALC>"
"tt_cta_corren_cta_ctbl.de_saldo_cta_corren @ tt_cta_corren_cta_ctbl.de_saldo_cta_corren" "Saldo R$" "->>>,>>>,>>9.99" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"tt_cta_corren_cta_ctbl.val_cotac_indic_econ @ tt_cta_corren_cta_ctbl.val_cotac_indic_econ" "Cotaá∆o" "->9.9999999999" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE br-cta */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME w-cadsim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-cadsim w-cadsim
ON END-ERROR OF w-cadsim /* Variaá∆o Cambial Conta Corrente */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-cadsim w-cadsim
ON WINDOW-CLOSE OF w-cadsim /* Variaá∆o Cambial Conta Corrente */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-contabiliza
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-contabiliza w-cadsim
ON CHOOSE OF bt-contabiliza IN FRAME f-cad
DO:
    IF  v_cod_cta_ctbl_at = "" OR  
        v_cod_cta_ctbl_pa = "" 
    THEN DO:
        RUN utp/ut-msgs.p(INPUT "show",
                          INPUT 17006,
                          INPUT "Contas n∆o parametrizadas.~~As contas cont†beis de variaá∆o cambial n∆o est∆o cadastradas corretamente no ES0018. Entre em contato com a TIC").
        RETURN NO-APPLY.
    END.

    RUN utp/ut-msgs.p(INPUT "show",
                      INPUT 27100,
                      INPUT "Confirma Contabilizaá∆o?").

    IF  RETURN-VALUE = "no" 
    THEN 
        RETURN NO-APPLY.

    RUN pi-contabiliza.

    APPLY "choose" TO bt-filtrar IN FRAME {&FRAME-NAME}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-del
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-del w-cadsim
ON CHOOSE OF bt-del IN FRAME f-cad
DO:
    FIND lote_ctbl NO-LOCK
       WHERE lote_ctbl.num_lote_ctbl = int_variac_cambial_cta_corren.num_lote_ctbl NO-ERROR.

    IF  AVAIL lote_ctbl 
    THEN DO:
        RUN utp/ut-msgs.p (INPUT "show":U,
                           INPUT 17006,
                           INPUT "Lote cont†bil deve primeiro ser eliminado na contabilidade.").
        RETURN NO-APPLY.
    END.

    RUN utp/ut-msgs.p (INPUT "show":U,
                       INPUT 27100,
                       INPUT "Confirma Eliminaá∆o da contabilizaá∆o?").

    IF  RETURN-VALUE = "no" 
    THEN 
        RETURN NO-APPLY.

    FIND CURRENT int_variac_cambial_cta_corren EXCLUSIVE-LOCK NO-ERROR.
    DELETE int_variac_cambial_cta_corren.

    APPLY "choose" TO bt-filtrar IN FRAME {&FRAME-NAME}.
           
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-filtrar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-filtrar w-cadsim
ON CHOOSE OF bt-filtrar IN FRAME f-cad
DO:
    IF SESSION:SET-WAIT-STATE("general") THEN.

    ASSIGN c-cta-ctbl-ini       = INPUT FRAME {&FRAME-NAME} c-cta-ctbl-ini
           c-periodo            = INPUT FRAME {&FRAME-NAME} c-periodo
           v_val_sdo_cta_ctbl   = 0
           v_val_sdo_cta_corren = 0
           v_val_diferenca      = 0.

    DISP v_val_sdo_cta_ctbl v_val_sdo_cta_corren v_val_diferenca WITH FRAME {&FRAME-NAME}.

    DISABLE bt-contabiliza bt-del bt-lan WITH FRAME {&FRAME-NAME}.

    EMPTY TEMP-TABLE tt_cta_corren_cta_ctbl.
    {&open-query-br-cta}

    ASSIGN i_mes             = INT(SUBSTR(c-periodo,5,2))
           i_ano             = INT(SUBSTR(c-periodo,1,4))
           v_dat_sdo_periodo = DATE("01/" + string(i_mes, "99") + "/" + string(i_ano, "9999"))
           v_dat_sdo_periodo = ADD-INTERVAL(v_dat_sdo_periodo,1 ,"MONTH") - DAY(v_dat_sdo_periodo).

    RUN pi-sdo-cta-ctbl (INPUT v_cod_empres_usuar,
                         INPUT c-cta-ctbl-ini,
                         INPUT c-cta-ctbl-ini,
                         INPUT v_dat_sdo_periodo).
    
    FOR EACH  cta_corren_cta_ctbl NO-LOCK
        WHERE cta_corren_cta_ctbl.ind_finalid_ctbl_cta_corren  = "Principal Ativo"
          AND cta_corren_cta_ctbl.dat_inic_valid              <= v_dat_sdo_periodo
          AND cta_corren_cta_ctbl.dat_fim_valid               >= v_dat_sdo_periodo
          AND cta_corren_cta_ctbl.cod_cta_ctbl                 = c-cta-ctbl-ini,
        FIRST cta_corren OF cta_corren_cta_ctbl
        BREAK BY cta_corren_cta_ctbl.cod_cta_ctbl:

        CREATE tt_cta_corren_cta_ctbl.
        ASSIGN tt_cta_corren_cta_ctbl.cod_cta_ctbl         = cta_corren_cta_ctbl.cod_cta_ctbl
               tt_cta_corren_cta_ctbl.cod_cta_corren       = cta_corren.cod_cta_corren
               tt_cta_corren_cta_ctbl.cod_finalid_econ     = cta_corren.cod_finalid_econ
               tt_cta_corren_cta_ctbl.nom_abrev_cta_corren = cta_corren.nom_abrev.

        RUN pi-sdo-cta-corren.
    END.

    {&open-query-br-cta}

    ASSIGN v_val_diferenca = v_val_sdo_cta_ctbl - v_val_sdo_cta_corren.

    DISP v_val_sdo_cta_ctbl v_val_sdo_cta_corren v_val_diferenca WITH FRAME {&FRAME-NAME}.

    FOR FIRST tt_cta_corren_cta_ctbl NO-LOCK:
        IF  v_val_diferenca <> 0
        THEN DO:
            DISABLE bt-del bt-lan  WITH FRAME {&FRAME-NAME}.
            ENABLE  bt-contabiliza WITH FRAME {&FRAME-NAME}.
        END.
    END.

    FOR FIRST int_variac_cambial_cta_corren NO-LOCK
        WHERE int_variac_cambial_cta_corren.cod_cta_ctbl = c-cta-ctbl-ini
          AND int_variac_cambial_cta_corren.cod_periodo  = c-periodo:

        ENABLE  bt-del bt-lan  WITH FRAME {&FRAME-NAME}.
        DISABLE bt-contabiliza WITH FRAME {&FRAME-NAME}.
    END.

    {&open-query-br-contabiliza}

    IF SESSION:SET-WAIT-STATE("") THEN.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-lan
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-lan w-cadsim
ON CHOOSE OF bt-lan IN FRAME f-cad
DO:
    RUN prgfin/fgl/fgl702aa.p.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok w-cadsim
ON CHOOSE OF bt-ok IN FRAME f-cad /* Fechar */
DO:
  RUN notify ('update-record':U).
  if return-value <> "adm-error":U then
     apply "close":U to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-contabiliza
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK w-cadsim 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects w-cadsim  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available w-cadsim  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI w-cadsim  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-cadsim)
  THEN DELETE WIDGET w-cadsim.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI w-cadsim  _DEFAULT-ENABLE
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
  DISPLAY c-cta-ctbl-ini c-periodo v_val_sdo_cta_ctbl v_val_sdo_cta_corren 
          v_val_diferenca 
      WITH FRAME f-cad IN WINDOW w-cadsim.
  ENABLE br-contabiliza c-cta-ctbl-ini c-periodo bt-filtrar bt-ok br-cta 
         RECT-157 RECT-158 RECT-159 
      WITH FRAME f-cad IN WINDOW w-cadsim.
  {&OPEN-BROWSERS-IN-QUERY-f-cad}
  VIEW w-cadsim.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy w-cadsim 
PROCEDURE local-destroy :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  IF  VALID-HANDLE(h-api) THEN
      RUN pi-destroy IN h-api.


  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .
  {include/i-logfin.i}

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit w-cadsim 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize w-cadsim 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  
  /* Code placed here will execute PRIOR to standard behavior. */
  {include/win-size.i}

  {utp/ut9000.i "ESFGL008" "2.00.00.000"}

  /* Dispatch standard ADM method.                             */
  RUN dispatch  IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
  RUN dispatch  IN this-procedure ('enable-fields':U).

  ASSIGN c-periodo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(YEAR(TODAY),"9999") + STRING(MONTH(TODAY),"99").

  EMPTY TEMP-TABLE tt-prog-ponto.
  
  ASSIGN v_cod_cta_ctbl_pa = ""
         v_cod_cta_ctbl_at = ""
         v_cod_cta_ctbl_cp = "".
  
  RUN esp/es0018p.p (INPUT  "esfgl008",
                     INPUT  1,
                     INPUT  0,
                     INPUT  "",
                     OUTPUT TABLE tt-prog-ponto).
  
  FOR EACH tt-prog-ponto:
  
      IF  NUM-ENTRIES(tt-prog-ponto.conteudo,"#") > 1
      THEN DO:
          IF  tt-prog-ponto.conteudo BEGINS "CVA" /* Conta Variaá∆o Ativo */
          THEN 
              ASSIGN v_cod_cta_ctbl_at = TRIM(ENTRY(2,tt-prog-ponto.conteudo,"#")).
  
          IF  tt-prog-ponto.conteudo BEGINS "CVP" /* Conta Variaá∆o Passivo */
          THEN 
              ASSIGN v_cod_cta_ctbl_pa = TRIM(ENTRY(2,tt-prog-ponto.conteudo,"#")).
      END.
  END.
  
  {include/i-inifld.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-contabiliza w-cadsim 
PROCEDURE pi-contabiliza :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE v-cod-arq-log AS CHARACTER   NO-UNDO.

    EMPTY TEMP-TABLE tt_integr_aprop_lancto_ctbl_1.
    EMPTY TEMP-TABLE tt_integr_ctbl_valid_1.
    EMPTY TEMP-TABLE tt_integr_ctbl_valid_parametros.
    EMPTY TEMP-TABLE tt_integr_item_lancto_ctbl_1.
    EMPTY TEMP-TABLE tt_integr_lancto_ctbl_1.
    EMPTY TEMP-TABLE tt_integr_lancto_ctbl_aux.
    EMPTY TEMP-TABLE tt_integr_lote_ctbl_1.

    ASSIGN i-seq-lancto      = 0
           v_cod_cta_ctbl_cp = "".

    CREATE tt_integr_lote_ctbl_1.
    ASSIGN tt_integr_lote_ctbl_1.tta_cod_modul_dtsul      = "FGL"
           tt_integr_lote_ctbl_1.tta_num_lote_ctbl        = 99999999
           tt_integr_lote_ctbl_1.tta_des_lote_ctbl        = "Variaá∆o Cambial Conta Corrente "  + c-periodo
           tt_integr_lote_ctbl_1.tta_cod_empresa          = "1"
           tt_integr_lote_ctbl_1.tta_dat_lote_ctbl        = v_dat_sdo_periodo
           tt_integr_lote_ctbl_1.ttv_rec_integr_lote_ctbl = RECID(tt_integr_lote_ctbl_1).

    CREATE tt_integr_lancto_ctbl_1.
    ASSIGN tt_integr_lancto_ctbl_1.tta_cod_cenar_ctbl         = ""
           tt_integr_lancto_ctbl_1.ttv_rec_integr_lote_ctbl   = tt_integr_lote_ctbl_1.ttv_rec_integr_lote_ctbl
           tt_integr_lancto_ctbl_1.tta_num_lancto_ctbl        = 1
           tt_integr_lancto_ctbl_1.tta_dat_lancto_ctbl        = v_dat_sdo_periodo
           tt_integr_lancto_ctbl_1.ttv_rec_integr_lancto_ctbl = RECID(tt_integr_lancto_ctbl_1).


    IF  v_val_diferenca > 0 
    THEN DO:
        RUN pi-cria-lancto ( INPUT c-cta-ctbl-ini,    
                             INPUT "CR",     
                             INPUT "Variaá∆o Cambial Conta Corrente "  + c-periodo,
                             INPUT v_dat_sdo_periodo, 
                             INPUT v_val_diferenca).

        RUN pi-cria-lancto ( INPUT v_cod_cta_ctbl_pa,    
                             INPUT "DB",     
                             INPUT "Variaá∆o Cambial Conta Corrente "  + c-periodo,
                             INPUT v_dat_sdo_periodo, 
                             INPUT v_val_diferenca).

        ASSIGN v_cod_cta_ctbl_cp = v_cod_cta_ctbl_pa.
    END.
    ELSE DO:
        RUN pi-cria-lancto ( INPUT c-cta-ctbl-ini,    
                             INPUT "DB",     
                             INPUT "Variaá∆o Cambial Conta Corrente "  + c-periodo,
                             INPUT v_dat_sdo_periodo, 
                             INPUT v_val_diferenca).

        RUN pi-cria-lancto ( INPUT v_cod_cta_ctbl_at,    
                             INPUT "CR",     
                             INPUT "Variaá∆o Cambial Conta Corrente "  + c-periodo,
                             INPUT v_dat_sdo_periodo, 
                             INPUT v_val_diferenca).

        ASSIGN v_cod_cta_ctbl_cp = v_cod_cta_ctbl_at.
    END.

    bloco-contabiliza:
    DO TRANS:

        ASSIGN v-cod-arq-log = SESSION:TEMP-DIRECTORY + "Rel_Contab_Var_Camb_Cta_Corren_Erros_ESFGL008_" + STRING(TIME) + ".txt".
    
        OUTPUT STREAM s_1 TO VALUE(v-cod-arq-log)
        PAGED PAGE-SIZE VALUE(65) CONVERT TARGET 'iso8859-1'.

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

        OUTPUT STREAM S_1 CLOSE.
        DOS SILENT START notepad.exe VALUE(v-cod-arq-log).
    
        FIND FIRST tt_integr_lote_ctbl_1.

        IF  AVAIL tt_integr_lote_ctbl_1 AND 
                  tt_integr_lote_ctbl_1.tta_num_lote_ctbl <> 99999999 
        THEN DO:
            CREATE int_variac_cambial_cta_corren.
            ASSIGN int_variac_cambial_cta_corren.cod_cta_ctbl                = c-cta-ctbl-ini
                   int_variac_cambial_cta_corren.cod_periodo                 = c-periodo
                   int_variac_cambial_cta_corren.num_lote_ctbl               = tt_integr_lote_ctbl_1.tta_num_lote_ctbl
                   int_variac_cambial_cta_corren.val_variacao                = v_val_diferenca
                   int_variac_cambial_cta_corren.cod_cta_ctbl_contra_partida = v_cod_cta_ctbl_cp
                   int_variac_cambial_cta_corren.cod_usuar_ult_atualiz       = c-seg-usuario
                   int_variac_cambial_cta_corren.dat_ult_atualiz             = TODAY
                   int_variac_cambial_cta_corren.hra_ult_atualiz             = STRING(TIME,"hh:mm:ss").

            RUN utp/ut-msgs.p(INPUT "show",
                              INPUT 15825,
                              INPUT "Variaá∆o cambial contabilizada com sucesso").
        END.
        ELSE DO:
            RUN utp/ut-msgs.p(INPUT "show",
                              INPUT 17006,
                              INPUT "N∆o foi poss°vel contabilizar a variaá∆o cambial selecionada.").

            UNDO bloco-contabiliza, LEAVE.
        END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-lancto w-cadsim 
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

    ASSIGN i-seq-lancto = i-seq-lancto + 1.

    IF  p-valor < 0  
    THEN
        ASSIGN p-valor = p-valor * (-1).

    CREATE tt_integr_item_lancto_ctbl_1.
    ASSIGN tt_integr_item_lancto_ctbl_1.ttv_rec_integr_lancto_ctbl      = tt_integr_lancto_ctbl_1.ttv_rec_integr_lancto_ctbl
           tt_integr_item_lancto_ctbl_1.tta_num_seq_lancto_ctbl         = i-seq-lancto
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-sdo-cta-corren w-cadsim 
PROCEDURE pi-sdo-cta-corren :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE v_val_sdo_real_fim     AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE v_val_sdo_nreal_fim    AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE v_val_sdo_bcio_fim     AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE v_val_cotac_indic_econ AS DECIMAL  DECIMALS 10   NO-UNDO.
    DEFINE VARIABLE v_dat_cotac_indic_econ AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE v_cod_return           AS CHARACTER   NO-UNDO.

    run prgfin/cmg/cmg733zs.py (Input v_cod_empres_usuar,
                                Input cta_corren.cod_cta_corren,
                                Input "",
                                Input v_dat_sdo_periodo,
                                Input "Empresa" /*l_empresa*/,
                                output v_val_sdo_real_fim,
                                output v_val_sdo_nreal_fim,
                                output v_val_sdo_bcio_fim) /*prg_api_retornar_sdo_atual_cmg*/.

    ASSIGN v_val_cotac_indic_econ = 1.

    FIND FIRST histor_finalid_econ NO-LOCK 
         WHERE histor_finalid_econ.cod_finalid_econ        = cta_corren.cod_finalid_econ
           AND histor_finalid_econ.dat_inic_valid_finalid <= v_dat_sdo_periodo
           AND histor_finalid_econ.dat_fim_valid_finalid  >= v_dat_sdo_periodo USE-INDEX hstrfnld_id NO-ERROR. 

    IF  AVAIL histor_finalid_econ 
    THEN DO:
        ASSIGN tt_cta_corren_cta_ctbl.cod_finalid_econ = histor_finalid_econ.cod_indic_econ.

        IF cta_corren.cod_finalid_econ <> "Corrente" 
        THEN DO:
            RUN pi_achar_cotac_indic_econ (INPUT histor_finalid_econ.cod_indic_econ,
                                           INPUT "Real",
                                           INPUT v_dat_sdo_periodo,
                                           INPUT "Compra" /*l_real*/,
                                           OUTPUT v_dat_cotac_indic_econ,
                                           OUTPUT v_val_cotac_indic_econ,
                                           OUTPUT v_cod_return).
        END.
    END.

    IF  v_val_sdo_real_fim     <> 0 AND 
        v_val_cotac_indic_econ <> 0
    THEN
        ASSIGN tt_cta_corren_cta_ctbl.de_saldo_moeda_orig   = v_val_sdo_real_fim
               tt_cta_corren_cta_ctbl.de_saldo_cta_corren   = (v_val_sdo_real_fim / v_val_cotac_indic_econ)
               tt_cta_corren_cta_ctbl.val_cotac_indic_econ  = v_val_cotac_indic_econ
               v_val_sdo_cta_corren                         = v_val_sdo_cta_corren + tt_cta_corren_cta_ctbl.de_saldo_cta_corren.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-sdo-cta-ctbl w-cadsim 
PROCEDURE pi-sdo-cta-ctbl :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAMETER p_cod_empresa      AS CHAR.
    DEF INPUT PARAMETER p_cod_cta_ctbl_ini AS CHAR.
    DEF INPUT PARAMETER p_cod_cta_ctbl_fim AS CHAR.
    DEF INPUT PARAMETER p_dat_refer        AS DATE.

    DEFINE VARIABLE de_sdo_cta_ctbl AS DECIMAL     NO-UNDO.

    EMPTY TEMP-TABLE tt_input_leitura_sdo.
    EMPTY TEMP-TABLE tt_retorna_sdo_ctbl.
    EMPTY TEMP-TABLE tt_log_erros.

    CREATE tt_input_leitura_sdo.
    ASSIGN tt_input_leitura_sdo.ttv_cod_label    = "Empresa"
           tt_input_leitura_sdo.ttv_des_conteudo = p_cod_empresa
           tt_input_leitura_sdo.ttv_num_seq_1    = 1
           tt_input_leitura_sdo.ttv_num_seq_2    = 1.
    
    CREATE tt_input_leitura_sdo.
    ASSIGN tt_input_leitura_sdo.ttv_cod_label    = "Finalidade Econìmica"
           tt_input_leitura_sdo.ttv_des_conteudo = 'Corrente'
           tt_input_leitura_sdo.ttv_num_seq_1    = 1
           tt_input_leitura_sdo.ttv_num_seq_2    = 2. 
    
    CREATE tt_input_leitura_sdo. 
    ASSIGN tt_input_leitura_sdo.ttv_cod_label    = "Conta Contabil Inicial"
           tt_input_leitura_sdo.ttv_des_conteudo = p_cod_cta_ctbl_ini
           tt_input_leitura_sdo.ttv_num_seq_1    = 1
           tt_input_leitura_sdo.ttv_num_seq_2    = 3.
    
    CREATE tt_input_leitura_sdo. 
    ASSIGN tt_input_leitura_sdo.ttv_cod_label    = "Conta Contabil Final"
           tt_input_leitura_sdo.ttv_des_conteudo = p_cod_cta_ctbl_fim
           tt_input_leitura_sdo.ttv_num_seq_1    = 1
           tt_input_leitura_sdo.ttv_num_seq_2    = 4.
    
    CREATE tt_input_leitura_sdo.
    ASSIGN tt_input_leitura_sdo.ttv_cod_label    = "Data Final"
           tt_input_leitura_sdo.ttv_des_conteudo = string(p_dat_refer, '99/99/9999')
           tt_input_leitura_sdo.ttv_num_seq_1    = 1
           tt_input_leitura_sdo.ttv_num_seq_2    = 5.

    RUN prgfin/fgl/fgl905zb.py (INPUT        1,
                                INPUT  TABLE tt_input_leitura_sdo,
                                OUTPUT TABLE tt_retorna_sdo_ctbl,
                                OUTPUT TABLE tt_log_erros).
    
    FOR EACH  tt_retorna_sdo_ctbl:
        ASSIGN v_val_sdo_cta_ctbl = v_val_sdo_cta_ctbl + tt_retorna_sdo_ctbl.tta_val_sdo_ctbl_fim.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi_achar_cotac_indic_econ w-cadsim 
PROCEDURE pi_achar_cotac_indic_econ :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def Input param p_cod_indic_econ_base
        as character
        format "x(8)"
        no-undo.
    def Input param p_cod_indic_econ_idx
        as character
        format "x(8)"
        no-undo.
    def Input param p_dat_transacao
        as date
        format "99/99/9999"
        no-undo.
    def Input param p_ind_tip_cotac_parid
        as character
        format "X(09)"
        no-undo.
    def output param p_dat_cotac_indic_econ
        as date
        format "99/99/9999"
        no-undo.
    def output param p_val_cotac_indic_econ
        as decimal
        format ">>>>,>>9.9999999999"
        decimals 10
        no-undo.
    def output param p_cod_return
        as character
        format "x(40)"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_dat_cotac_mes
        as date
        format "99/99/9999":U
        no-undo.
    def var v_log_indic
        as logical
        format "Sim/N∆o"
        initial no
        no-undo.
    def var v_cod_indic_econ_orig            as character       no-undo. /*local*/
    def var v_val_cotac_indic_econ_base      as decimal         no-undo. /*local*/
    def var v_val_cotac_indic_econ_idx       as decimal         no-undo. /*local*/


    /************************** Variable Definition End *************************/

    /* alteraá∆o sob demanda da atividade 148.681*/
    release cotac_parid.

    if  p_cod_indic_econ_base = p_cod_indic_econ_idx
    then do:
        /* **
         Quando a Base e o ÷ndice forem iguais, significa que a cotaá∆o pode ser percentual,
         portanto n∆o basta apenas retornar 1 e deve ser feita toda a pesquisa abaixo para
         encontrar a taxa da moeda no dia informado.
         Exemplo: D¢lar - D¢lar, poder°amos retornar 1
                  ANBID - ANBID, devemos retornar a taxa do dia.
        ***/
        find indic_econ no-lock
             where indic_econ.cod_indic_econ  = p_cod_indic_econ_base
               and indic_econ.dat_inic_valid <= p_dat_transacao
               and indic_econ.dat_fim_valid  >  p_dat_transacao
             no-error.
        if  avail indic_econ then do:
            if  indic_econ.ind_tip_cotac = "Valor" /*l_valor*/  then do:
                assign p_dat_cotac_indic_econ = p_dat_transacao
                       p_val_cotac_indic_econ = 1
                       p_cod_return           = "OK" /*l_ok*/ .
            end.
            else do:
                find cotac_parid no-lock
                     where cotac_parid.cod_indic_econ_base = p_cod_indic_econ_base
                       and cotac_parid.cod_indic_econ_idx = p_cod_indic_econ_idx
                       and cotac_parid.dat_cotac_indic_econ = p_dat_transacao
                       and cotac_parid.ind_tip_cotac_parid = p_ind_tip_cotac_parid
                     use-index ctcprd_id no-error.
                if  not avail cotac_parid
                then do:
                    find parid_indic_econ no-lock
                         where parid_indic_econ.cod_indic_econ_base = p_cod_indic_econ_base
                           and parid_indic_econ.cod_indic_econ_idx = p_cod_indic_econ_idx
                         use-index prdndccn_id no-error.
                    /* block: */
                    case parid_indic_econ.ind_criter_busca:
                        when "Anterior" /*l_anterior*/ then find prev cotac_parid no-lock
                              where cotac_parid.cod_indic_econ_base = p_cod_indic_econ_base
                                and cotac_parid.cod_indic_econ_idx = p_cod_indic_econ_idx
                                and cotac_parid.dat_cotac_indic_econ < p_dat_transacao
                                and cotac_parid.ind_tip_cotac_parid = p_ind_tip_cotac_parid
                                and cotac_parid.val_cotac_indic_econ <> 0.0
                              use-index ctcprd_id
                               /*cl_acha_cotac_anterior of cotac_parid*/ no-error.
                        when "Pr¢ximo" /*l_proximo*/ then  find next cotac_parid no-lock
                               where cotac_parid.cod_indic_econ_base = p_cod_indic_econ_base
                                 and cotac_parid.cod_indic_econ_idx = p_cod_indic_econ_idx
                                 and cotac_parid.dat_cotac_indic_econ > p_dat_transacao
                                 and cotac_parid.ind_tip_cotac_parid = p_ind_tip_cotac_parid
                                 and cotac_parid.val_cotac_indic_econ <> 0.0
                               use-index ctcprd_id
                                /*cl_acha_cotac_posterior of cotac_parid*/ no-error.
                    end /* case block */.
                    if  not avail cotac_parid
                    then do:
                        assign p_cod_return = "358"                   + "," +
                                              p_cod_indic_econ_base   + "," +
                                              p_cod_indic_econ_idx    + "," +
                                              string(p_dat_transacao) + "," +
                                              p_ind_tip_cotac_parid.
                    end /* if */.
                    else do:
                        assign p_dat_cotac_indic_econ = cotac_parid.dat_cotac_indic_econ
                               p_val_cotac_indic_econ = cotac_parid.val_cotac_indic_econ
                               p_cod_return           = "OK" /*l_ok*/ .
                    end /* else */.
                end /* if */.
                else do:
                    assign p_dat_cotac_indic_econ = cotac_parid.dat_cotac_indic_econ
                           p_val_cotac_indic_econ = cotac_parid.val_cotac_indic_econ
                           p_cod_return           = "OK" /*l_ok*/ .
                end /* else */.
            end.
        end.
        else do:
            assign p_cod_return = "335".
        end.
    end /* if */.
    else do:
        find parid_indic_econ no-lock
             where parid_indic_econ.cod_indic_econ_base = p_cod_indic_econ_base
               and parid_indic_econ.cod_indic_econ_idx = p_cod_indic_econ_idx
             use-index prdndccn_id no-error.
        if  avail parid_indic_econ
        then do:


            /* Begin_Include: i_verifica_cotac_parid */
            /* verifica as cotacoes da moeda p_cod_indic_econ_base para p_cod_indic_econ_idx 
              cadastrada na base, de acordo com a periodicidade da cotacao (obtida na 
              parid_indic_econ, que deve estar avail)*/

            /* period_block: */
            case parid_indic_econ.ind_periodic_cotac:
                when "Di†ria" /*l_diaria*/ then
                    diaria_block:
                    do:
                        find cotac_parid no-lock
                            where cotac_parid.cod_indic_econ_base  = p_cod_indic_econ_base
                              and cotac_parid.cod_indic_econ_idx   = p_cod_indic_econ_idx
                              and cotac_parid.dat_cotac_indic_econ = p_dat_transacao
                              and cotac_parid.ind_tip_cotac_parid  = p_ind_tip_cotac_parid
                            use-index ctcprd_id no-error.
                        if  not avail cotac_parid or cotac_parid.val_cotac_indic_econ = 0
                        then do:
                            find parid_indic_econ no-lock
                                where parid_indic_econ.cod_indic_econ_base = p_cod_indic_econ_base
                                  and parid_indic_econ.cod_indic_econ_idx  = p_cod_indic_econ_idx
                                use-index prdndccn_id no-error.
                            /* block: */
                            case parid_indic_econ.ind_criter_busca:
                                when "Anterior" /*l_anterior*/ then 
                                    find prev cotac_parid no-lock
                                        where cotac_parid.cod_indic_econ_base  = p_cod_indic_econ_base
                                          and cotac_parid.cod_indic_econ_idx   = p_cod_indic_econ_idx
                                          and cotac_parid.dat_cotac_indic_econ < p_dat_transacao
                                          and cotac_parid.ind_tip_cotac_parid  = p_ind_tip_cotac_parid
                                          and cotac_parid.val_cotac_indic_econ <> 0.0
                                          use-index ctcprd_id
                                          no-error.
                                when "Pr¢ximo" /*l_proximo*/ then  
                                    find next cotac_parid no-lock
                                        where cotac_parid.cod_indic_econ_base  = p_cod_indic_econ_base
                                          and cotac_parid.cod_indic_econ_idx   = p_cod_indic_econ_idx
                                          and cotac_parid.dat_cotac_indic_econ > p_dat_transacao
                                          and cotac_parid.ind_tip_cotac_parid  = p_ind_tip_cotac_parid
                                          and cotac_parid.val_cotac_indic_econ <> 0.0
                                          use-index ctcprd_id
                                          no-error.
                            end /* case block */.
                        end /* if */.
                    end /* do diaria_block */.
                when "Mensal" /*l_mensal*/ then
                    mensal_block:
                    do:
                        assign v_dat_cotac_mes = date(month(p_dat_transacao), 1, year(p_dat_transacao))
                               v_log_indic     = yes.
                        find cotac_parid no-lock
                            where cotac_parid.cod_indic_econ_base  = p_cod_indic_econ_base
                              and cotac_parid.cod_indic_econ_idx   = p_cod_indic_econ_idx
                              and cotac_parid.dat_cotac_indic_econ = v_dat_cotac_mes
                              and cotac_parid.ind_tip_cotac_parid  = p_ind_tip_cotac_parid
                            use-index ctcprd_id no-error.
                        if  not avail cotac_parid or cotac_parid.val_cotac_indic_econ = 0
                        then do:
                            /* block: */
                            case parid_indic_econ.ind_criter_busca:
                                when "Anterior" /*l_anterior*/ then
                                    find prev cotac_parid no-lock
                                        where cotac_parid.cod_indic_econ_base  = p_cod_indic_econ_base
                                          and cotac_parid.cod_indic_econ_idx   = p_cod_indic_econ_idx
                                          and cotac_parid.dat_cotac_indic_econ < v_dat_cotac_mes
                                          and cotac_parid.ind_tip_cotac_parid  = p_ind_tip_cotac_parid
                                          and cotac_parid.val_cotac_indic_econ <> 0.0
                                        use-index ctcprd_id no-error.
                                when "Pr¢ximo" /*l_proximo*/ then
                                    find next cotac_parid no-lock
                                        where cotac_parid.cod_indic_econ_base  = p_cod_indic_econ_base
                                          and cotac_parid.cod_indic_econ_idx   = p_cod_indic_econ_idx
                                          and cotac_parid.dat_cotac_indic_econ > v_dat_cotac_mes
                                          and cotac_parid.ind_tip_cotac_parid  = p_ind_tip_cotac_parid
                                          and cotac_parid.val_cotac_indic_econ <> 0.0
                                        use-index ctcprd_id no-error.
                            end /* case block */.
                        end /* if */.
                    end /* do mensal_block */.
                when "Bimestral" /*l_bimestral*/ then
                    bimestral_block:
                    do:
                    end /* do bimestral_block */.
                when "Trimestral" /*l_trimestral*/ then
                    trimestral_block:
                    do:
                    end /* do trimestral_block */.
                when "Quadrimestral" /*l_quadrimestral*/ then
                    quadrimestral_block:
                    do:
                    end /* do quadrimestral_block */.
                when "Semestral" /*l_semestral*/ then
                    semestral_block:
                    do:
                    end /* do semestral_block */.
                when "Anual" /*l_anual*/ then
                    anual_block:
                    do:
                    end /* do anual_block */.
            end /* case period_block */.
            /* End_Include: i_verifica_cotac_parid */


            if  parid_indic_econ.ind_orig_cotac_parid = "Outra Moeda" /*l_outra_moeda*/  and
                 parid_indic_econ.cod_finalid_econ_orig_cotac <> "" and
                 (not avail cotac_parid or cotac_parid.val_cotac_indic_econ = 0)
            then do:
                /* Cotaá∆o Ponte */
                run pi_retornar_indic_econ_finalid (Input parid_indic_econ.cod_finalid_econ_orig_cotac,
                                                    Input p_dat_transacao,
                                                    output v_cod_indic_econ_orig) /*pi_retornar_indic_econ_finalid*/.
                find parid_indic_econ no-lock
                    where parid_indic_econ.cod_indic_econ_base = v_cod_indic_econ_orig
                    and parid_indic_econ.cod_indic_econ_idx = p_cod_indic_econ_base
                    use-index prdndccn_id no-error.
                run pi_achar_cotac_indic_econ_2 (Input v_cod_indic_econ_orig,
                                                 Input p_cod_indic_econ_base,
                                                 Input p_dat_transacao,
                                                 Input p_ind_tip_cotac_parid,
                                                 Input p_cod_indic_econ_base,
                                                 Input p_cod_indic_econ_idx) /*pi_achar_cotac_indic_econ_2*/.

                if  avail cotac_parid and cotac_parid.val_cotac_indic_econ <> 0
                then do:
                    assign v_val_cotac_indic_econ_base = cotac_parid.val_cotac_indic_econ.
                    find parid_indic_econ no-lock
                        where parid_indic_econ.cod_indic_econ_base = v_cod_indic_econ_orig
                        and parid_indic_econ.cod_indic_econ_idx = p_cod_indic_econ_idx
                        use-index prdndccn_id no-error.
                    run pi_achar_cotac_indic_econ_2 (Input v_cod_indic_econ_orig,
                                                     Input p_cod_indic_econ_idx,
                                                     Input p_dat_transacao,
                                                     Input p_ind_tip_cotac_parid,
                                                     Input p_cod_indic_econ_base,
                                                     Input p_cod_indic_econ_idx) /*pi_achar_cotac_indic_econ_2*/.

                    if  avail cotac_parid and cotac_parid.val_cotac_indic_econ <> 0
                    then do:
                        assign v_val_cotac_indic_econ_idx = cotac_parid.val_cotac_indic_econ
                               p_val_cotac_indic_econ = v_val_cotac_indic_econ_idx / v_val_cotac_indic_econ_base
                               p_dat_cotac_indic_econ = cotac_parid.dat_cotac_indic_econ
                               p_cod_return = "OK" /*l_ok*/ .
                        return.
                    end /* if */.
                end /* if */.
            end /* if */.
            if  parid_indic_econ.ind_orig_cotac_parid = "Inversa" /*l_inversa*/  and
                 (not avail cotac_parid or cotac_parid.val_cotac_indic_econ = 0)
            then do:
                find parid_indic_econ no-lock
                    where parid_indic_econ.cod_indic_econ_base = p_cod_indic_econ_idx
                    and parid_indic_econ.cod_indic_econ_idx = p_cod_indic_econ_base
                    use-index prdndccn_id no-error.
                run pi_achar_cotac_indic_econ_2 (Input p_cod_indic_econ_idx,
                                                 Input p_cod_indic_econ_base,
                                                 Input p_dat_transacao,
                                                 Input p_ind_tip_cotac_parid,
                                                 Input p_cod_indic_econ_base,
                                                 Input p_cod_indic_econ_idx) /*pi_achar_cotac_indic_econ_2*/.

                if  avail cotac_parid and cotac_parid.val_cotac_indic_econ <> 0
                then do:
                    assign p_dat_cotac_indic_econ = cotac_parid.dat_cotac_indic_econ
                           p_val_cotac_indic_econ = 1 / cotac_parid.val_cotac_indic_econ
                           p_cod_return = "OK" /*l_ok*/ .
                    return.
                end /* if */.
            end /* if */.
        end /* if */.
        if v_log_indic = yes then do:
           if  not avail cotac_parid or cotac_parid.val_cotac_indic_econ = 0
           then do:
               assign p_cod_return = "358"                 + "," +
                      p_cod_indic_econ_base   + "," +
                      p_cod_indic_econ_idx    + "," +
                      string(v_dat_cotac_mes) + "," +
                      p_ind_tip_cotac_parid.
           end /* if */.
           else do:
               assign p_dat_cotac_indic_econ = cotac_parid.dat_cotac_indic_econ
                      p_val_cotac_indic_econ = cotac_parid.val_cotac_indic_econ
                      p_cod_return           = "OK" /*l_ok*/ .
           end /* else */.
        end.
        else do:   
           if  not avail cotac_parid or cotac_parid.val_cotac_indic_econ = 0
           then do:
               assign p_cod_return = "358"                 + "," +
                      p_cod_indic_econ_base   + "," +
                      p_cod_indic_econ_idx    + "," +
                      string(p_dat_transacao) + "," +
                      p_ind_tip_cotac_parid.
           end /* if */.
           else do:
               assign p_dat_cotac_indic_econ = cotac_parid.dat_cotac_indic_econ
                      p_val_cotac_indic_econ = cotac_parid.val_cotac_indic_econ
                      p_cod_return           = "OK" /*l_ok*/ .
           end /* else */.
        end.
        assign v_log_indic = no.
    end /* else */.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi_achar_cotac_indic_econ_2 w-cadsim 
PROCEDURE pi_achar_cotac_indic_econ_2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def Input param p_cod_param_1
        as character
        format "x(8)"
        no-undo.
    def Input param p_cod_param_2
        as character
        format "x(50)"
        no-undo.
    def Input param p_dat_transacao
        as date
        format "99/99/9999"
        no-undo.
    def Input param p_ind_tip_cotac_parid
        as character
        format "X(09)"
        no-undo.
    def Input param p_cod_indic_econ_base
        as character
        format "x(8)"
        no-undo.
    def Input param p_cod_indic_econ_idx
        as character
        format "x(8)"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_dat_cotac_mes                  as date            no-undo. /*local*/


    /************************** Variable Definition End *************************/

    /* period_block: */
    case parid_indic_econ.ind_periodic_cotac:
        when "Di†ria" /*l_diaria*/ then
            diaria_block:
            do:
                find cotac_parid no-lock
                     where cotac_parid.cod_indic_econ_base = p_cod_param_1
                       and cotac_parid.cod_indic_econ_idx = p_cod_param_2
                       and cotac_parid.dat_cotac_indic_econ = p_dat_transacao
                       and cotac_parid.ind_tip_cotac_parid = p_ind_tip_cotac_parid
                     use-index ctcprd_id no-error.
                if  not avail cotac_parid or cotac_parid.val_cotac_indic_econ = 0
                then do:
                    find parid_indic_econ no-lock
                         where parid_indic_econ.cod_indic_econ_base = p_cod_param_1
                           and parid_indic_econ.cod_indic_econ_idx = p_cod_param_2
                         use-index prdndccn_id no-error.
                    /* block: */
                    case parid_indic_econ.ind_criter_busca:
                        when "Anterior" /*l_anterior*/ then find prev cotac_parid no-lock
                              where cotac_parid.cod_indic_econ_base = p_cod_indic_econ_base
                                and cotac_parid.cod_indic_econ_idx = p_cod_indic_econ_idx
                                and cotac_parid.dat_cotac_indic_econ < p_dat_transacao
                                and cotac_parid.ind_tip_cotac_parid = p_ind_tip_cotac_parid
                                and cotac_parid.val_cotac_indic_econ <> 0.0
                              use-index ctcprd_id
                               /*cl_acha_cotac_anterior of cotac_parid*/ no-error.
                        when "Pr¢ximo" /*l_proximo*/ then  find next cotac_parid no-lock
                               where cotac_parid.cod_indic_econ_base = p_cod_indic_econ_base
                                 and cotac_parid.cod_indic_econ_idx = p_cod_indic_econ_idx
                                 and cotac_parid.dat_cotac_indic_econ > p_dat_transacao
                                 and cotac_parid.ind_tip_cotac_parid = p_ind_tip_cotac_parid
                                 and cotac_parid.val_cotac_indic_econ <> 0.0
                               use-index ctcprd_id
                                /*cl_acha_cotac_posterior of cotac_parid*/ no-error.
                    end /* case block */.
                end /* if */.
            end /* do diaria_block */.
        when "Mensal" /*l_mensal*/ then
            mensal_block:
            do:
                assign v_dat_cotac_mes = date(month(p_dat_transacao), 1, year(p_dat_transacao)).
                find cotac_parid no-lock
                     where cotac_parid.cod_indic_econ_base = p_cod_param_1
                       and cotac_parid.cod_indic_econ_idx = p_cod_param_2
                       and cotac_parid.dat_cotac_indic_econ = v_dat_cotac_mes
                       and cotac_parid.ind_tip_cotac_parid = p_ind_tip_cotac_parid
                     use-index ctcprd_id no-error.
                if  not avail cotac_parid or cotac_parid.val_cotac_indic_econ = 0
                then do:
                    /* block: */
                    case parid_indic_econ.ind_criter_busca:
                        when "Anterior" /*l_anterior*/ then
                        find prev cotac_parid no-lock
                                           where cotac_parid.cod_indic_econ_base = p_cod_param_1
                                             and cotac_parid.cod_indic_econ_idx = p_cod_param_2
                                             and cotac_parid.dat_cotac_indic_econ < v_dat_cotac_mes
                                             and cotac_parid.ind_tip_cotac_parid = p_ind_tip_cotac_parid
                                             and cotac_parid.val_cotac_indic_econ <> 0.0
                                           use-index ctcprd_id no-error.
                        when "Pr¢ximo" /*l_proximo*/ then
                        find next cotac_parid no-lock
                                           where cotac_parid.cod_indic_econ_base = p_cod_param_1
                                             and cotac_parid.cod_indic_econ_idx = p_cod_param_2
                                             and cotac_parid.dat_cotac_indic_econ > v_dat_cotac_mes
                                             and cotac_parid.ind_tip_cotac_parid = p_ind_tip_cotac_parid
                                             and cotac_parid.val_cotac_indic_econ <> 0.0
                                           use-index ctcprd_id no-error.
                    end /* case block */.
                end /* if */.
            end /* do mensal_block */.
        when "Bimestral" /*l_bimestral*/ then
            bimestral_block:
            do:
            end /* do bimestral_block */.
        when "Trimestral" /*l_trimestral*/ then
            trimestral_block:
            do:
            end /* do trimestral_block */.
        when "Quadrimestral" /*l_quadrimestral*/ then
            quadrimestral_block:
            do:
            end /* do quadrimestral_block */.
        when "Semestral" /*l_semestral*/ then
            semestral_block:
            do:
            end /* do semestral_block */.
        when "Anual" /*l_anual*/ then
            anual_block:
            do:
            end /* do anual_block */.
    end /* case period_block */.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records w-cadsim  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "tt_cta_corren_cta_ctbl"}
  {src/adm/template/snd-list.i "int_variac_cambial_cta_corren"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed w-cadsim 
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

