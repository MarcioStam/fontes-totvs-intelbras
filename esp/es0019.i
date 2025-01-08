
define temp-table tt-erros no-undo
    field cod-erro  as integer
    field desc-erro as character
    field desc-arq  as character.

def temp-table tt_param_segur no-undo
    field tta_num_vers_integr_api          as integer   format "999"
    field tta_cod_aplicat_dtsul_corren     as character format "x(3)"
    field tta_cod_ccusto_corren            as character format "x(11)"
    field tta_cod_dwb_user                 as character format "x(12)"
    field tta_cod_empres_usuar             as character format "x(3)"
    field tta_cod_estab_usuar              as character format "x(3)"
    field tta_cod_funcao_negoc_empres      as character format "x(50)"
    field tta_cod_grp_usuar_lst            as character format "x(3)"
    field tta_cod_idiom_usuar              as character format "x(8)"
    field tta_cod_modul_dtsul_corren       as character format "x(3)"
    field tta_cod_modul_dtsul_empres       as character format "x(100)"
    field tta_cod_pais_empres_usuar        as character format "x(3)"
    field tta_cod_plano_ccusto_corren      as character format "x(8)"
    field tta_cod_unid_negoc_usuar         as character format "x(3)"
    field tta_cod_usuar_corren             as character format "x(12)"
    field tta_cod_usuar_corren_criptog     as character format "x(16)"
    field tta_num_ped_exec_corren          as integer   format ">>>>>>>>9"
    field tta_rec_ped_exec                 as recid     format ">>>>>>9"
    field ttv_num_msg_erro                 as integer   format ">>>>>>9"
    field ttv_des_msg                      as character format "x(2000)".
  
def temp-table tt_ped_exec NO-UNDO       
    field tta_num_seq                      as integer format ">>>,>>9" initial 0
    field tta_num_ped_exec                 as integer format ">>>>>>>>9" initial 0 
    field tta_cod_usuario                  as character format "x(12)"
    field tta_cod_prog_dtsul               LIKE prog_dtsul.cod_prog_dtsul
    field tta_cod_prog_dtsul_rp            as character format "x(100)"
    field tta_cod_release_prog_dtsul       as character format "x(9)"
    field tta_dat_exec_ped_exec            as date format "99/99/9999" initial ?
    field tta_hra_exec_ped_exec            as Character format "99:99:99"
    field tta_num_ped_exec_pai             as integer format ">>>>>>>>9" initial 0
    field tta_log_exec_prog_depend         as logical format "Sim/N’o" initial no
    field tta_cod_servid_exec              as character format "x(8)"
    field tta_cdn_estil_dwb                as Integer format ">>9" initial 0
    field ttv_num_msg_erro                 as integer format ">>>>>>9"
    field ttv_cod_msg_parameters           as character format "x(2000)"
    field tta_cod_orig_ped_exec            as character format "x(8)"
    index tt_ped_exec_id                   is primary unique
          tta_num_seq                      ascending.

def temp-table tt_ped_exec_param no-undo       
    field tta_num_seq                      as integer   format ">>>,>>9" initial 0
    field tta_cod_dwb_parameters           as character format "x(2000)"
    field tta_cod_dwb_file                 as character format "x(50)"
    field tta_cod_dwb_output               as character format "x(10)"
    field tta_cod_dwb_order                as character format "x(2000)"
    field tta_nom_dwb_printer              as character format "x(12)"
    field tta_cod_dwb_print_layout         as character format "x(20)"
    field tta_log_dwb_print_parameters     as logical   format "Sim/NÆo" initial no
    field tta_raw_param_ped_exec           as raw
    index tt_ped_exec_param                is primary
          tta_num_seq                      ascending.

def temp-table tt_ped_exec_param_aux NO-UNDO       
    field tta_num_seq                      as integer format ">>>,>>9" initial 0
    field tta_num_dwb_order                as integer format ">>>>,>>9" initial 0
    field tta_cod_dwb_parameters           as character format "x(2000)"
    field tta_raw_param_ped_exec           as raw
    index tt_ped_exec_param_aux            is primary unique
          tta_num_seq                      ascending
          tta_num_dwb_order                ascending.

def temp-table tt_ped_exec_sel NO-UNDO       
    field tta_num_seq                      as integer format ">>>,>>9" initial 0
    field tta_num_dwb_order                as integer format ">>>>,>>9" initial 0
    field tta_ind_dwb_set_type             as character format "X(09)" initial "Regra"
    field tta_cod_dwb_set                  as character format "x(25)"
    field tta_cod_dwb_set_initial          as character format "x(50)"
    field tta_cod_dwb_set_final            as character format "x(50)"
    field tta_cod_dwb_set_single           as character format "x(60)"
    field tta_cod_dwb_set_parameters       as character format "x(2000)"
    field tta_log_dwb_rule                 as logical format "Sim/N’o" initial no
    index tt_ped_exec_sel_id               is primary unique
          tta_num_seq                      ascending
          tta_num_dwb_order                ascending.

def new global shared var v_cod_usuar_corren
    as character
    format "x(12)"
    label "Usuÿrio Corrente"
    column-label "Usuÿrio Corrente"
    no-undo.

define temp-table tt-param
    field destino            as integer
    field arquivo            as char
    field usuario            as char
    field data-exec          as date
    field hora-exec          as integer.

DEFINE TEMP-TABLE tt-digita NO-UNDO
    FIELD ordem   AS INTEGER   FORMAT ">>>>9":U
    FIELD exemplo AS CHARACTER FORMAT "x(30)":U
    INDEX id
        ordem
    .

DEFINE TEMP-TABLE tt-raw-digita
    FIELD raw-digita AS RAW
    .

DEF VAR hr-aux AS CHAR NO-UNDO.
