/*--------------------------------------------------------------------------------------------------------------------
** Nome Externo .........: esp/fas/esfas011.i
** Data Cria‡Æo .........: 17/06/2013
** Criado por ...........: Sensus Tecnologia
----------------------------------------------------------------------------------------------------------------------*/

DEFINE NEW SHARED VARIABLE v_ind_message_output AS CHARACTER FORMAT "X(10)":U INITIAL "Em Arquivo" view-as radio-set HORIZONTAL radio-buttons "Na Tela", "Na Tela","Em Arquivo", "Em Arquivo" BGCOLOR 8 NO-UNDO.
DEFINE NEW SHARED VARIABLE v_log_view_file      AS LOGICAL   FORMAT "Sim/NÆo" INITIAL YES       view-as TOGGLE-BOX label "Visualiza Arquivo" column-label "Visualiza Arquivo" NO-UNDO.

DEFINE VARIABLE v_hdl_api_bem_pat_bxa_transf AS HANDLE NO-UNDO.

DEFINE NEW SHARED STREAM s_1.

DEFINE TEMP-TABLE tt_movto_bem_pat_api_aux NO-UNDO         
    FIELD tta_cod_empresa                  AS CHARACTER FORMAT "x(3)"  label "Empresa"           column-label "Empresa"
    FIELD tta_cod_cta_pat                  AS CHARACTER FORMAT "x(18)" label "Conta Patrimonial" column-label "Conta Patrimonial"
    FIELD tta_num_bem_pat                  AS INTEGER   FORMAT ">>>>>>>>9"  initial 0     label "Bem Patrimonial" column-label "Bem"
    FIELD tta_num_seq_bem_pat              AS INTEGER   FORMAT ">>>>9"      initial 0     label "Sequˆncia Bem"   column-label "Sequˆncia"
    FIELD tta_dat_movto_bem_pat            AS DATE      FORMAT "99/99/9999" initial today label "Data Movimento"  column-label "Data Movimento"
    FIELD tta_ind_trans_calc_bem_pat       AS CHARACTER FORMAT "X(18)"      initial "Implanta‡Æo" label "Transa‡Æo C lculo" column-label "Transa‡Æo C lculo"
    FIELD tta_ind_orig_calc_bem_pat        AS CHARACTER FORMAT "X(20)"      initial "Aquisi‡Æo"   label "Origem"            column-label "Origem"
    FIELD ttv_ind_tip_movto_bem_pat        AS CHARACTER FORMAT "x(15)" label "Tipo Movimento"
    FIELD tta_cod_motiv_desmob             AS CHARACTER FORMAT "x(3)"  label "Motivo Desmobiliza‡Æo" column-label "Mot Desmob"
    FIELD tta_cod_cenar_ctbl               AS CHARACTER FORMAT "x(8)"  label "Cen rio Cont bil"      column-label "Cen rio Cont bil"
    FIELD tta_cod_indic_econ               AS CHARACTER FORMAT "x(8)"  label "Moeda" column-label "Moeda"
    FIELD tta_val_fatur_desmob             AS DECIMAL   FORMAT ">>>>,>>>,>>>,>>9.99"   decimals 2 initial 0 label "Valor Faturado"       column-label "Val Faturado"
    FIELD tta_val_origin_movto_bem_pat     AS DECIMAL   FORMAT "->>,>>>,>>>,>>9.99"    decimals 2 initial 0 label "Valor Original Movto" column-label "Valor Original Movto"
    FIELD tta_val_perc_movto_bem_pat       AS DECIMAL   FORMAT "->>>>,>>>,>>9.9999999" decimals 7 initial 0 label "Percentual Movimento" column-label "Percentual Movimento"
    FIELD tta_qtd_movto_bem_pat            AS DECIMAL   FORMAT ">>>>>>>>9" initial 0 label "Quantidade Movto" column-label "Quantidade Movto"
    FIELD tta_cod_plano_ccusto             AS CHARACTER FORMAT "x(8)"  label "Plano Centros Custo" column-label "Plano Centros Custo"
    FIELD tta_cod_ccusto_respons           AS CHARACTER FORMAT "x(11)" label "CCusto Responsab"    column-label "CCusto Responsab"
    FIELD tta_cod_unid_negoc               AS CHARACTER FORMAT "x(3)"  label "Unid Neg¢cio"        column-label "Un Neg"
    FIELD tta_cod_estab                    AS CHARACTER FORMAT "x(3)"  label "Estabelecimento"     column-label "Estab"
    FIELD ttv_ind_sit_movto_bem_pat        AS CHARACTER FORMAT "X(08)"
    FIELD ttv_des_erro_api_movto_bem_pat   AS CHARACTER FORMAT "x(60)"
    FIELD tta_num_pessoa_jurid             AS INTEGER   FORMAT ">>>,>>>,>>9" initial 0 label "Pessoa Jur¡dica" column-label "Pessoa Jur¡dica"
    FIELD tta_cod_ender_entreg             AS CHARACTER FORMAT "x(15)" label "Endere‡o Entrega" column-label "Endere‡o Entrega"
    FIELD tta_cod_localiz                  AS CHARACTER FORMAT "x(12)" label "Localiza‡Æo"      column-label "Localiza‡Æo"
    index tt_id                            IS PRIMARY UNIQUE
          tta_cod_empresa                  ASCENDING
          tta_cod_cta_pat                  ASCENDING
          tta_num_bem_pat                  ASCENDING
          tta_num_seq_bem_pat              ASCENDING
          tta_dat_movto_bem_pat            ASCENDING.

DEFINE BUFFER bftt_movto_bem_pat_api_aux FOR tt_movto_bem_pat_api_aux.
