/****************************************************************************************
**  Programa: ESFAS020aa.P
**  Objetivo: Atualizaá∆o de bens.
**  Autor...: Andrey M Oliveira
**  Data....: 22/08/2023
****************************************************************************************/

def buffer histor_exec_especial for emscad.histor_exec_especial.
def buffer cliente              for emscad.cliente.
def buffer portador             for emscad.portador.
def buffer banco                for emscad.banco.
def buffer pais                 for emscad.pais.
def buffer ccusto               for emscad.ccusto.
def buffer fornecedor           for emscad.fornecedor.
def buffer empresa              for emscad.empresa.

def var c-versao-prg as char initial " 1.00.00.000":U no-undo.

{include/i_dbinst.i}
{include/i_dbtype.i}

define new global shared variable h_facelift as handle no-undo. 
if not valid-handle(h_facelift) then run prgtec/btb/btb901zo.py persistent set h_facelift no-error.

define new global shared variable h-facelift as handle no-undo. 
if not valid-handle(h-facelift) then run prgtec/btb/btb901zo.py persistent set h-facelift no-error.

{include/i_trddef.i}

/******************************* Private-Data *******************************/
assign this-procedure:private-data = "HLP=2":U.
/*************************************  *************************************/

/********************* Temporary Table Definition Begin *********************/

def temp-table tt_bem_pat_cong no-undo
    field tta_num_id_bem_pat               as integer format ">>,>>>,>>9" initial 0 label "Identificaá∆o Bem" column-label "Identificaá∆o Bem"
    field tta_cod_grp_calc                 as character format "x(6)" label "Grupo C†lculo" column-label "Grupo C†lculo"
    field tta_num_lote_ctbl                as integer format ">>>,>>>,>>9" initial 1 label "Lote Cont†bil" column-label "Lote Cont†bil"
    field tta_cod_cta_pat                  as character format "x(18)" label "Conta Patrimonial" column-label "Conta Patrimonial"
    field ttv_dat_movto                    as date format "99/99/9999" label "Data Movimento" column-label "Data Movimento"
    field tta_cod_cenar_ctbl               as character format "x(8)" label "Cen†rio Cont†bil" column-label "Cen†rio Cont†bil"
    field ttv_ind_tip_param                as character format "X(08)"
    .

def temp-table tt_converter_finalid_econ no-undo
    field tta_cod_finalid_econ             as character format "x(10)" label "Finalidade" column-label "Finalidade"
    field tta_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda"
    field tta_dat_cotac_indic_econ         as date format "99/99/9999" initial ? label "Data Cotaá∆o" column-label "Data Cotaá∆o"
    field tta_val_cotac_indic_econ         as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Cotaá∆o" column-label "Cotaá∆o"
    field tta_val_cotac_tax_juros          as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Cotac Taxa Juros" column-label "Cotac Taxa Juros"
    field tta_val_prev_cotac_fasb          as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Cotac Previs Fasb" column-label "Cotac Previs Fasb"
    field tta_val_cotac_cm_emis            as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Cotac Cm Emiss" column-label "Cotac Cm Emiss"
    field tta_val_cotac_cm_vencto          as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Cotac Cm Vencto" column-label "Cotac Cm Vencto"
    field tta_val_cotac_cm_pagto           as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Cotac Cm Pagto" column-label "Cotac CM Pagto"
    field tta_val_transacao                as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Transaá∆o" column-label "Transaá∆o"
    field tta_val_variac_cambial           as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Varic Cambial" column-label "Variac Cambial"
    field tta_val_acerto_cmcac             as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Acerto CMCAC" column-label "Vl Acerto CMCAC"
    field tta_val_fatorf                   as decimal format "->999.9999999999" decimals 10 initial 0 label "Fator F" column-label "Fator F"
    field tta_val_fatorx                   as decimal format "->999.9999999999" decimals 10 initial 0 label "Fator X" column-label "Fator X"
    field tta_val_fatory                   as decimal format "->999.9999999999" decimals 10 initial 0 label "Fator Y" column-label "Fator Y"
    field tta_val_ganho_perda_cm           as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "G/P CM" column-label "G/P CM"
    field tta_val_ganho_perda_projec       as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "G/P Projeá∆o" column-label "G/P Projeá∆o"
    field tta_ind_forma_conver             as character format "X(10)" initial "Direta" label "Forma Convers∆o" column-label "Forma Convers∆o"
    field ttv_val_multa                    as decimal format "->>>,>>>,>>9.99" decimals 2 label "Vl Multa" column-label "Vl Multa"
    field ttv_val_desc                     as decimal format "->>>,>>>,>>9.99" decimals 2 label "Vl Desc" column-label "Vl Desc"
    field ttv_val_juros                    as decimal format "->>>,>>>,>>9.99" decimals 2 label "Valor Juros" column-label "Valor Juros"
    field ttv_val_abat                     as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Abatimento" column-label "Valor Abatimento"
    field ttv_val_cm                       as decimal format "->>>>>,>>>,>>9.99" decimals 4 initial 0 label "Correá∆o Monet†ria" column-label "Correá∆o Monet†ria"
    field tta_val_despes_bcia              as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Desp Banc" column-label "Vl Desp Banc"
    .

def shared temp-table tt_criacao_bem_pat_api_5 no-undo
    field tta_cod_unid_organ_ext           as character format "x(5)" label "Unid Organ Externa" column-label "Unid Organ Externa"
    field tta_cod_cta_pat                  as character format "x(18)" label "Conta Patrimonial" column-label "Conta Patrimonial"
    field tta_num_bem_pat                  as integer format ">>>>>>>>9" initial 0 label "Bem Patrimonial" column-label "Bem"
    field tta_num_seq_bem_pat              as integer format ">>>>9" initial 0 label "Sequància Bem" column-label "Sequància"
    field tta_des_bem_pat                  as character format "x(40)" label "Descriá∆o Bem Pat" column-label "Descriá∆o Bem Pat"
    field tta_dat_aquis_bem_pat            as date format "99/99/9999" initial today label "Data Aquisiá∆o" column-label "Dat Aquis"
    field tta_cod_plano_ccusto             as character format "x(8)" label "Plano Centros Custo" column-label "Plano Centros Custo"
    field tta_cod_ccusto_ext               as character format "x(8)" label "Centro Custo Externo" column-label "CCusto Externo"
    field tta_cod_estab_ext                as character format "x(8)" label "Estabelecimento Exte" column-label "Estabelecimento Ext"
    field tta_cod_unid_negoc_ext           as character format "x(8)" label "Unid Neg¢cio Externa" column-label "Unid Neg¢cio Externa"
    field tta_cod_finalid_econ_ext         as character format "x(8)" label "Finalid Econ Externa" column-label "Finalidade Externa"
    field ttv_val_aquis_bem_pat            as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Aquisiá∆o Bem" column-label "Aquisiá∆o Bem"
    field ttv_log_erro                     as logical format "Sim/N∆o" initial yes
    field tta_qtd_bem_pat_represen         as decimal format ">>>>>>>>9" initial 1 label "Quantidade Bens Representados" column-label "Bem Represen"
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field tta_cod_docto_entr               as character format "x(8)" label "Docto Entrada" column-label "Docto Entrada"
    field tta_cod_ser_nota                 as character format "x(3)" label "SÇrie Nota" column-label "SÇrie Nota"
    field tta_num_item_docto_entr          as integer format ">>>,>>9" initial 0 label "Numero Item" column-label "Num Item"
    field tta_num_id_bem_pat               as integer format ">>,>>>,>>9" initial 0 label "Identificaá∆o Bem" column-label "Identificaá∆o Bem"
    field tta_des_narrat_bem_pat           as character format "x(2000)" label "Narrativa Bem" column-label "Narrativa Bem"
    field tta_log_bem_imptdo               as logical format "Sim/N∆o" initial no label "Bem Importado" column-label "Bem Importado"
    field tta_log_cr_pis                   as logical format "Sim/N∆o" initial no label "Credita PIS" column-label "Credita PIS"
    field tta_log_cr_cofins                as logical format "Sim/N∆o" initial no label "Credita COFINS" column-label "Credita COFINS"
    field ttv_num_parc_pis_cofins          as integer format "99" initial 0 label "Nro Parcelas" column-label "Nro Parcelas"
    field tta_val_cr_pis                   as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Cred PIS/PASEP" column-label "Vl Cred PIS/PASEP"
    field tta_val_cr_cofins                as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor CrÇdito COFINS" column-label "Credito COFINS"
    field ttv_log_cr_csll                  as logical format "Sim/N∆o" initial no label "Credita CSLL" column-label "Credita CSLL"
    field ttv_num_exerc_cr_csll            as integer format "99" label "Exerc. CrÇdito CSLL" column-label "Exerc. CrÇdito CSLL"
    .

def new shared temp-table tt_criacao_bem_pat_api_6 no-undo
    field tta_cod_unid_organ_ext           as character format "x(5)" label "Unid Organ Externa" column-label "Unid Organ Externa"
    field tta_cod_cta_pat                  as character format "x(18)" label "Conta Patrimonial" column-label "Conta Patrimonial"
    field tta_num_bem_pat                  as integer format ">>>>>>>>9" initial 0 label "Bem Patrimonial" column-label "Bem"
    field tta_num_seq_bem_pat              as integer format ">>>>9" initial 0 label "Sequància Bem" column-label "Sequància"
    field tta_des_bem_pat                  as character format "x(40)" label "Descriá∆o Bem Pat" column-label "Descriá∆o Bem Pat"
    field tta_dat_aquis_bem_pat            as date format "99/99/9999" initial today label "Data Aquisiá∆o" column-label "Dat Aquis"
    field tta_cod_plano_ccusto             as character format "x(8)" label "Plano Centros Custo" column-label "Plano Centros Custo"
    field tta_cod_ccusto_ext               as character format "x(8)" label "Centro Custo Externo" column-label "CCusto Externo"
    field tta_cod_estab_ext                as character format "x(8)" label "Estabelecimento Exte" column-label "Estabelecimento Ext"
    field tta_cod_unid_negoc_ext           as character format "x(8)" label "Unid Neg¢cio Externa" column-label "Unid Neg¢cio Externa"
    field tta_cod_finalid_econ_ext         as character format "x(8)" label "Finalid Econ Externa" column-label "Finalidade Externa"
    field ttv_val_aquis_bem_pat            as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Aquisiá∆o Bem" column-label "Aquisiá∆o Bem"
    field ttv_log_erro                     as logical format "Sim/N∆o" initial yes
    field tta_qtd_bem_pat_represen         as decimal format ">>>>>>>>9" initial 1 label "Quantidade Bens Representados" column-label "Bem Represen"
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field tta_cod_docto_entr               as character format "x(8)" label "Docto Entrada" column-label "Docto Entrada"
    field tta_cod_ser_nota                 as character format "x(3)" label "SÇrie Nota" column-label "SÇrie Nota"
    field tta_num_item_docto_entr          as integer format ">>>,>>9" initial 0 label "Numero Item" column-label "Num Item"
    field tta_num_id_bem_pat               as integer format ">>,>>>,>>9" initial 0 label "Identificaá∆o Bem" column-label "Identificaá∆o Bem"
    field tta_des_narrat_bem_pat           as character format "x(2000)" label "Narrativa Bem" column-label "Narrativa Bem"
    field tta_log_bem_imptdo               as logical format "Sim/N∆o" initial no label "Bem Importado" column-label "Bem Importado"
    field tta_log_cr_pis                   as logical format "Sim/N∆o" initial no label "Credita PIS" column-label "Credita PIS"
    field tta_log_cr_cofins                as logical format "Sim/N∆o" initial no label "Credita COFINS" column-label "Credita COFINS"
    field ttv_num_parc_pis_cofins          as integer format "99" initial 0 label "Nro Parcelas" column-label "Nro Parcelas"
    field tta_val_cr_pis                   as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Cred PIS/PASEP" column-label "Vl Cred PIS/PASEP"
    field tta_val_cr_cofins                as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor CrÇdito COFINS" column-label "Credito COFINS"
    field tta_val_base_pis                 as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Base PIS/PASEP" column-label "Vl Base PIS/PASEP"
    field tta_val_base_cofins              as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Base COFINS" column-label "Base COFINS"
    field ttv_log_cr_csll                  as logical format "Sim/N∆o" initial no label "Credita CSLL" column-label "Credita CSLL"
    field ttv_num_exerc_cr_csll            as integer format "99" label "Exerc. CrÇdito CSLL" column-label "Exerc. CrÇdito CSLL"
    .

def temp-table tt_criacao_bem_pat_item_api no-undo
    field ttv_rec_bem                      as recid format ">>>>>>9"
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field tta_cod_docto_entr               as character format "x(8)" label "Docto Entrada" column-label "Docto Entrada"
    field tta_cod_ser_nota                 as character format "x(3)" label "SÇrie Nota" column-label "SÇrie Nota"
    field tta_num_item_docto_entr          as integer format ">>>,>>9" initial 0 label "Numero Item" column-label "Num Item"
    field tta_qtd_item_docto_entr          as decimal format ">>>>>>>>9" initial 0 label "Qtde Item Docto" column-label "Qtde Item Docto"
    index tt_id                            is primary unique
          ttv_rec_bem                      ascending
          tta_cdn_fornecedor               ascending
          tta_cod_docto_entr               ascending
          tta_cod_ser_nota                 ascending
          tta_num_item_docto_entr          ascending
    .

def temp-table tt_criacao_bem_pat_val_resid no-undo
    field ttv_rec_bem                      as recid format ">>>>>>9"
    field tta_cod_tip_calc                 as character format "x(7)" label "Tipo C†lculo" column-label "Tipo C†lculo"
    field tta_cod_cenar_ctbl               as character format "x(8)" label "Cen†rio Cont†bil" column-label "Cen†rio Cont†bil"
    field tta_cod_finalid_econ             as character format "x(10)" label "Finalidade" column-label "Finalidade"
    field tta_val_resid_min                as decimal format ">>>>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Residual M°nimo" column-label "Residual"
    index tt_id                            is primary unique
          ttv_rec_bem                      ascending
          tta_cod_tip_calc                 ascending
          tta_cod_cenar_ctbl               ascending
          tta_cod_finalid_econ             ascending
    .

def temp-table tt_erros_cenario no-undo
    field tta_cod_modul_dtsul              as character format "x(3)" label "M¢dulo" column-label "M¢dulo"
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cod_cenar_ctbl               as character format "x(8)" label "Cen†rio Cont†bil" column-label "Cen†rio Cont†bil"
    field ttv_dat_refer_sit                as date format "99/99/9999"
    index tt_id1                           is primary unique
          tta_cod_modul_dtsul              ascending
          tta_cod_empresa                  ascending
          tta_cod_cenar_ctbl               ascending
          ttv_dat_refer_sit                ascending
    .

def shared temp-table tt_erros_criacao_bem_pat_api_1 no-undo
    field tta_cod_unid_organ_ext           as character format "x(5)" label "Unid Organ Externa" column-label "Unid Organ Externa"
    field tta_cod_cta_pat                  as character format "x(18)" label "Conta Patrimonial" column-label "Conta Patrimonial"
    field tta_num_bem_pat                  as integer format ">>>>>>>>9" initial 0 label "Bem Patrimonial" column-label "Bem"
    field tta_num_seq_bem_pat              as integer format ">>>>9" initial 0 label "Sequància Bem" column-label "Sequància"
    field tta_des_bem_pat                  as character format "x(40)" label "Descriá∆o Bem Pat" column-label "Descriá∆o Bem Pat"
    field tta_dat_aquis_bem_pat            as date format "99/99/9999" initial today label "Data Aquisiá∆o" column-label "Dat Aquis"
    field tta_cod_finalid_econ_ext         as character format "x(8)" label "Finalid Econ Externa" column-label "Finalidade Externa"
    field ttv_des_mensagem                 as character format "x(50)" label "Mensagem" column-label "Mensagem"
    .

def temp-table tt_log_erro_aux no-undo
    field ttv_num_cod_erro                 as integer format ">>>>,>>9" label "N£mero" column-label "N£mero"
    field ttv_des_msg_ajuda                as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda"
    field ttv_des_msg_erro                 as character format "x(60)" label "Mensagem Erro" column-label "Inconsistància"
    .



/********************** Temporary Table Definition End **********************/

/************************** Buffer Definition Begin *************************/

&if "{&emsfin_version}" >= "1.00" &then
def buffer b_bem_pat_proximo
    for bem_pat.
&endif


/*************************** Buffer Definition End **************************/

/************************* Variable Definition Begin ************************/

def new global shared var v_cod_aplicat_dtsul_corren
    as character
    format "x(3)":U
    no-undo.
&IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.07" &THEN
def var v_cod_ccusto
    as Character
    format "x(11)":U
    label "Centro Custo"
    column-label "Centro Custo"
    no-undo.
&ENDIF
&IF "{&emsfin_version}" >= "5.07" AND "{&emsfin_version}" < "9.99" &THEN
def var v_cod_ccusto
    as character
    format "x(20)":U
    label "Centro de Custo"
    column-label "Centro de Custo"
    no-undo.
&ENDIF
&IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.07" &THEN
def var v_cod_ccusto_000
    as Character
    format "x(11)":U
    label "Centro Custo"
    column-label "Centro Custo"
    no-undo.
&ENDIF
&IF "{&emsfin_version}" >= "5.07" AND "{&emsfin_version}" < "9.99" &THEN
def var v_cod_ccusto_000
    as character
    format "x(20)":U
    label "Centro de Custo"
    column-label "Centro de Custo"
    no-undo.
&ENDIF
def new global shared var v_cod_ccusto_corren
    as character
    format "x(11)":U
    label "Centro Custo"
    column-label "Centro Custo"
    no-undo.
def var v_cod_cta_ctbl
    as character
    format "x(20)":U
    label "Conta Cont†bil"
    column-label "Conta Cont†bil"
    no-undo.
def new global shared var v_cod_dwb_user
    as character
    format "x(21)":U
    label "Usu†rio"
    column-label "Usu†rio"
    no-undo.
def var v_cod_empresa
    as character
    format "x(3)":U
    label "Empresa"
    column-label "Empresa"
    no-undo.
def new global shared var v_cod_empres_usuar
    as character
    format "x(3)":U
    label "Empresa"
    column-label "Empresa"
    no-undo.
&IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.07A" &THEN
def var v_cod_estab
    as character
    format "x(3)":U
    label "Estabelecimento"
    column-label "Estabelecimento"
    no-undo.
&ENDIF
&IF "{&emsfin_version}" >= "5.07A" AND "{&emsfin_version}" < "9.99" &THEN
def var v_cod_estab
    as Character
    format "x(5)":U
    label "Estabelecimento"
    column-label "Estabelecimento"
    no-undo.
&ENDIF
def new global shared var v_cod_estab_usuar
    as character
    format "x(3)":U
    label "Estabelecimento"
    column-label "Estab"
    no-undo.
def var v_cod_finalid_econ
    as character
    format "x(10)":U
    label "Finalidade Econìmica"
    column-label "Finalidade Econìmica"
    no-undo.
def new global shared var v_cod_funcao_negoc_empres
    as character
    format "x(50)":U
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
def var v_cod_indic_econ
    as character
    format "x(8)":U
    label "Moeda"
    column-label "Moeda"
    no-undo.
def var v_cod_matriz_trad_ccusto_ext
    as character
    format "x(8)":U
    label "Matriz Trad CCusto"
    column-label "Matriz Trad CCusto"
    no-undo.
def new global shared var v_cod_modul_dtsul_corren
    as character
    format "x(3)":U
    label "M¢dulo Corrente"
    column-label "M¢dulo Corrente"
    no-undo.
def new global shared var v_cod_modul_dtsul_empres
    as character
    format "x(100)":U
    no-undo.
def new global shared var v_cod_pais_empres_usuar
    as character
    format "x(3)":U
    label "Pa°s Empresa Usu†rio"
    column-label "Pa°s"
    no-undo.
def var v_cod_plano_ccusto
    as character
    format "x(8)":U
    label "Plano CCusto"
    column-label "Plano CCusto"
    no-undo.
def new global shared var v_cod_plano_ccusto_corren
    as character
    format "x(8)":U
    label "Plano CCusto"
    column-label "Plano CCusto"
    no-undo.
def var v_cod_return
    as character
    format "x(40)":U
    no-undo.
def new global shared var v_cod_unid_negoc_usuar
    as character
    format "x(3)":U
    view-as combo-box
    &if "{&FNC_MULTI_IDIOMA}" = "YES" &then
    list-item-pairs "",""
    &else
    list-items ""
    &endif
    inner-lines 5
    bgcolor 15 font 2
    label "Unidade Neg¢cio"
    column-label "Unid Neg¢cio"
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
def var v_hdl_procedure
    as Handle
    format ">>>>>>9":U
    no-undo.
def var v_log_ctbz
    as logical
    format "Sim/N∆o"
    initial yes
    view-as toggle-box
    label "Contabiliza Movto"
    column-label "Contabiliza Movto"
    no-undo.
def var v_log_funcao_congel_cenar_ctbl
    as logical
    format "Sim/N∆o"
    initial yes
    no-undo.
def var v_log_integr_ativ_fix
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_log_localiz_col
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_log_return
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_log_return_epc
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_log_valid_cr_parc_pis_cofins
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_num_bem_pat
    as integer
    format ">>>>>>>>9":U
    initial 1
    label "Bem Patrimonial"
    column-label "Bem Pat"
    no-undo.
def var v_num_mensagem
    as integer
    format ">>>>,>>9":U
    label "N£mero"
    column-label "N£mero Mensagem"
    no-undo.
def new global shared var v_num_ped_exec_corren
    as integer
    format ">>>>9":U
    no-undo.
def var v_num_seq_bem_pat
    as integer
    format ">>>>9":U
    initial 0
    label "Sequància Bem"
    column-label "Sequància"
    no-undo.
def var v_qtd_mes_vida_util
    as decimal
    format ">>>,>>9":U
    decimals 0
    no-undo.
def var v_rec_log
    as recid
    format ">>>>>>9":U
    no-undo.
def var v_val_orig_bem_pat
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_log_erro_validac               as logical         no-undo. /*local*/


/************************** Variable Definition End *************************/


/****************************** Main Code Begin *****************************/


def new global shared var v_cod_arq
    as char  
    format 'x(60)'
    no-undo.
def new global shared var v_cod_tip_prog
    as character
    format 'x(8)'
    no-undo.

def stream s-arq.

if  v_cod_arq <> '' and v_cod_arq <> ?
then do:
    run pi_version_extract ('esfas020aa':U, 'esp/fas/esfas020aa.p':U, '1.00.00.000':U, 'pro':U).
end /* if */.



/* End_Include: i_version_extract */


/* Begin_Include: i_verify_program_epc_custom */
define variable v_nom_prog_upc    as character     no-undo init ''.
define variable v_nom_prog_appc   as character     no-undo init ''.
&if '{&emsbas_version}' > '5.00' &then
define variable v_nom_prog_dpc    as character     no-undo init ''.
&endif

define temp-table tt_epc no-undo
    field cod_event        as character
    field cod_parameter    as character
    field val_parameter    as character
    index id is primary cod_parameter cod_event ascending.

find prog_dtsul
    where prog_dtsul.cod_prog_dtsul = "esfas020aa":U
    no-lock no-error.
if  avail prog_dtsul then do:
    if  prog_dtsul.nom_prog_upc <> ''
    and prog_dtsul.nom_prog_upc <> ? then
        assign v_nom_prog_upc = prog_dtsul.nom_prog_upc.
    if  prog_dtsul.nom_prog_appc <> ''
    and prog_dtsul.nom_prog_appc <> ? then
        assign v_nom_prog_appc = prog_dtsul.nom_prog_appc.
&if '{&emsbas_version}' > '5.00' &then
    if  prog_dtsul.nom_prog_dpc <> ''
    and prog_dtsul.nom_prog_dpc <> ? then
        assign v_nom_prog_dpc = prog_dtsul.nom_prog_dpc.
&endif
end.

/* End_Include: i_verify_program_epc_custom */


/* Begin_Include: i_verify_security */
if  search("prgtec/men/men901za.r") = ? and search("prgtec/men/men901za.py") = ? then do:
    if  v_cod_dwb_user begins 'es_' then
        return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgtec/men/men901za.py".
    else do:
        message getStrTrans("Programa execut†vel n∆o foi encontrado:", "FAS") /*l_programa_nao_encontrado*/  "prgtec/men/men901za.py"
               view-as alert-box error buttons ok.
        return.
    end.
end.
else
    run prgtec/men/men901za.py (Input 'esfas020aa') /*prg_fnc_verify_security*/.
if  return-value = "2014"
then do:
    /* Programa a ser executado n∆o Ç um programa v†lido Datasul ! */
    run pi_messages (input "show",
                     input 2014,
                     input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                       'esfas020aa')) /*msg_2014*/.
    return.
end /* if */.
if  return-value = "2012"
then do:
    /* Usu†rio sem permiss∆o para acessar o programa. */
    run pi_messages (input "show",
                     input 2012,
                     input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                       'esfas020aa')) /*msg_2012*/.
    return.
end /* if */.
/* End_Include: i_verify_security */


/* Begin_Include: i_declara_GetDefinedFunction */
FUNCTION GetDefinedFunction RETURNS LOGICAL (INPUT SPP AS CHARACTER):

    DEF VAR v_log_retorno AS LOGICAL INITIAL NO NO-UNDO.

    IF CAN-FIND (FIRST histor_exec_especial NO-LOCK
         WHERE histor_exec_especial.cod_modul_dtsul = "UFN" /* l_ufn*/ 
           AND histor_exec_especial.cod_prog_dtsul  = SPP) THEN
        ASSIGN v_log_retorno = YES.


    /* Begin_Include: i_funcao_extract */
    if  v_cod_arq <> '' and v_cod_arq <> ?
    then do:

        output stream s-arq to value(v_cod_arq) append.

        put stream s-arq unformatted
            SPP      at 1 
            v_log_retorno  at 43 skip.

        output stream s-arq close.

    end /* if */.
    /* End_Include: i_funcao_extract */
    .

    RETURN v_log_retorno.
END FUNCTION.
/* End_Include: i_declara_GetDefinedFunction */


/* Begin_Include: i_declara_GetEntryField */
FUNCTION GetEntryField RETURNS CHARACTER (input p_num_posicao     AS INTEGER,
                                          INPUT p_cod_campo       AS CHARACTER,
                                          input p_cod_separador   AS CHARACTER):

/* ************* Parametros da FUNÄ«O *******************************
** Funá∆o para tratamento dos Entries dos c¢digos livres
** 
**  p_num_posicao     - N£mero do Entry que ser† atualizado
**  p_cod_campo       - Campo / Vari†vel que ser† atualizada
**  p_cod_separador   - Separador que ser† utilizado
*******************************************************************/

    if  p_num_posicao <= 0  then do:
        assign p_num_posicao  = 1.
    end.
    if num-entries(p_cod_campo,p_cod_separador) >= p_num_posicao  then do:
       return entry(p_num_posicao,p_cod_campo,p_cod_separador).
    end.
    return "" /*l_*/ .

END FUNCTION.

/* End_Include: i_declara_GetEntryField */


/* Begin_Include: i_declara_SetEntryField */
FUNCTION SetEntryField RETURNS CHARACTER (input p_num_posicao     AS INTEGER,
                                          input p_cod_campo       AS CHARACTER,
                                          input p_cod_separador   AS CHARACTER,
                                          input p_cod_valor       AS CHARACTER):

/* ************* Parametros da FUNÄ«O *******************************
** Funá∆o para tratamento dos Entries dos c¢digos livres
** 
**  p_num_posicao     - N£mero do Entry / Posiá∆o que ser† atualizado
**  p_cod_campo       - Campo / Vari†vel que ser† atualizada
**  p_cod_separador   - Separador que ser† utilizado
**  p_cod_valor       - Valor que ser† atualizado no Entry passado 
*******************************************************************/

    def var v_num_cont        as integer initial 0 no-undo.
    def var v_num_entries_ini as integer initial 0 no-undo.

    /* ** No progress a menor Entry Ç 1 ***/
    if p_num_posicao <= 0 then 
       assign p_num_posicao = 1.       

    /* ** Caso o Campo contenha um valor inv†lido, este valor ser† convertido para Branco
         para possibilitar os c†lculo ***/
    if p_cod_campo = ? then do:
       assign p_cod_campo = "" /* l_*/ .
    end.

    assign v_num_entries_ini = num-entries(p_cod_campo,p_cod_separador) + 1 .    
    if p_cod_campo = "" /* l_*/  then do:
       assign v_num_entries_ini = 2.
    end.

    do v_num_cont =  v_num_entries_ini to p_num_posicao :
       assign p_cod_campo = p_cod_campo + p_cod_separador.
    end.

    assign entry(p_num_posicao,p_cod_campo,p_cod_separador) = p_cod_valor.

    RETURN p_cod_campo.

END FUNCTION.


/* End_Include: i_declara_SetEntryField */



/******************************* Main Code End ******************************/

/************************* Internal Procedure Begin *************************/

/*****************************************************************************
** Procedure Interna.....: pi_version_extract
** Descricao.............: pi_version_extract
** Criado por............: jaison
** Criado em.............: 31/07/1998 09:33:22
** Alterado por..........: tech14020
** Alterado em...........: 12/06/2006 09:09:21
*****************************************************************************/
PROCEDURE pi_version_extract:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_program
        as character
        format "x(08)"
        no-undo.
    def Input param p_cod_program_ext
        as character
        format "x(8)"
        no-undo.
    def Input param p_cod_version
        as character
        format "x(8)"
        no-undo.
    def Input param p_cod_program_type
        as character
        format "x(8)"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_cod_event_dic
        as character
        format "x(20)":U
        label "Evento"
        column-label "Evento"
        no-undo.
    def var v_cod_tabela
        as character
        format "x(28)":U
        label "Tabela"
        column-label "Tabela"
        no-undo.


    /************************** Variable Definition End *************************/

    if  can-do(v_cod_tip_prog, p_cod_program_type)
    then do:
        if p_cod_program_type = 'dic' then 
           assign p_cod_program_ext = replace(p_cod_program_ext, 'database/', '').

        output stream s-arq to value(v_cod_arq) append.

        put stream s-arq unformatted
            p_cod_program            at 1 
            p_cod_program_ext        at 43 
            p_cod_version            at 69 
            today                    at 84 format "99/99/99"
            string(time, 'HH:MM:SS') at 94 skip.

        if  p_cod_program_type = 'pro' then do:
            &if '{&emsbas_version}' > '1.00' &then
            find prog_dtsul 
                where prog_dtsul.cod_prog_dtsul = p_cod_program 
                no-lock no-error.
            if  avail prog_dtsul
            then do:
                &if '{&emsbas_version}' > '5.00' &then
                    if  prog_dtsul.nom_prog_dpc <> '' then
                        put stream s-arq 'DPC : ' at 5 prog_dtsul.nom_prog_dpc  at 15 skip.
                &endif
                if  prog_dtsul.nom_prog_appc <> '' then
                    put stream s-arq 'APPC: ' at 5 prog_dtsul.nom_prog_appc at 15 skip.
                if  prog_dtsul.nom_prog_upc <> '' then
                    put stream s-arq 'UPC : ' at 5 prog_dtsul.nom_prog_upc  at 15 skip.
            end /* if */.
            &endif
        end.

        if  p_cod_program_type = 'dic' then do:
            &if '{&emsbas_version}' > '1.00' &then
            assign v_cod_event_dic = ENTRY(1,p_cod_program ,'/':U)
                   v_cod_tabela    = ENTRY(2,p_cod_program ,'/':U). /* FO 1100.980 */
            find tab_dic_dtsul 
                where tab_dic_dtsul.cod_tab_dic_dtsul = v_cod_tabela 
                no-lock no-error.
            if  avail tab_dic_dtsul
            then do:
                &if '{&emsbas_version}' > '5.00' &then
                    if  tab_dic_dtsul.nom_prog_dpc_gat_delete <> '' and v_cod_event_dic = 'Delete':U then
                        put stream s-arq 'DPC-DELETE : ' at 5 tab_dic_dtsul.nom_prog_dpc_gat_delete  at 25 skip.
                &endif
                if  tab_dic_dtsul.nom_prog_appc_gat_delete <> '' and v_cod_event_dic = 'Delete':U then
                    put stream s-arq 'APPC-DELETE: ' at 5 tab_dic_dtsul.nom_prog_appc_gat_delete at 25 skip.
                if  tab_dic_dtsul.nom_prog_upc_gat_delete <> '' and v_cod_event_dic = 'Delete':U then
                    put stream s-arq 'UPC-DELETE : ' at 5 tab_dic_dtsul.nom_prog_upc_gat_delete  at 25 skip.
                &if '{&emsbas_version}' > '5.00' &then
                    if  tab_dic_dtsul.nom_prog_dpc_gat_write <> '' and v_cod_event_dic = 'Write':U then
                        put stream s-arq 'DPC-WRITE : ' at 5 tab_dic_dtsul.nom_prog_dpc_gat_write  at 25 skip.
                &endif
                if  tab_dic_dtsul.nom_prog_appc_gat_write <> '' and v_cod_event_dic = 'Write':U then
                    put stream s-arq 'APPC-WRITE: ' at 5 tab_dic_dtsul.nom_prog_appc_gat_write at 25 skip.
                if  tab_dic_dtsul.nom_prog_upc_gat_write <> '' and v_cod_event_dic = 'Write':U  then
                    put stream s-arq 'UPC-WRITE : ' at 5 tab_dic_dtsul.nom_prog_upc_gat_write  at 25 skip.
            end /* if */.
            &endif
        end.

        output stream s-arq close.
    end /* if */.

END PROCEDURE. /* pi_version_extract */
/*****************************************************************************
** Procedure Interna.....: pi_criacao_bem_pat_api
** Descricao.............: pi_criacao_bem_pat_api
** Criado por............: Puccini
** Criado em.............: 20/06/1997 14:48:41
** Alterado por..........: jeanB
** Alterado em...........: 03/01/2014 10:02:22
*****************************************************************************/
PROCEDURE pi_criacao_bem_pat_api:

    /************************* Variable Definition Begin ************************/

    def var v_log_integr_mi
        as logical
        format "Sim/N∆o"
        initial yes
        no-undo.
    def var v_qtd_dias_vida_util
        as decimal
        format ">>>,>>>,>>9":U
        decimals 0
        no-undo.
    def var v_log_connect                    as logical         no-undo. /*local*/
    def var v_log_connect_ems2_ok            as logical         no-undo. /*local*/


    /************************** Variable Definition End *************************/

    if  tt_criacao_bem_pat_api_6.tta_num_bem_pat = 0
    then do:
        run pi_incrementa_bem_pat (Input v_cod_empresa,
                                   Input tt_criacao_bem_pat_api_6.tta_cod_cta_pat,
                                   Input v_cod_estab,
                                   output v_num_bem_pat,
                                   input-output v_num_seq_bem_pat) /*pi_incrementa_bem_pat*/.
        find last b_bem_pat_proximo
            where b_bem_pat_proximo.cod_empresa = v_cod_empresa
            and   b_bem_pat_proximo.cod_cta_pat = tt_criacao_bem_pat_api_6.tta_cod_cta_pat
            and   b_bem_pat_proximo.num_bem_pat = v_num_bem_pat no-lock no-error.
        if  available b_bem_pat_proximo
        then do:
            if  b_bem_pat_proximo.num_seq_bem_pat = 99999 then
                run pi_incrementa_primeiro_num_seq_bem_pat_livre (Input b_bem_pat_proximo.cod_empresa,
                                                                  Input b_bem_pat_proximo.cod_cta_pat,
                                                                  Input b_bem_pat_proximo.cod_estab,
                                                                  input-output v_num_bem_pat,
                                                                  output v_num_seq_bem_pat) /*pi_incrementa_primeiro_num_seq_bem_pat_livre*/.
            else assign v_num_seq_bem_pat = b_bem_pat_proximo.num_seq_bem_pat + 1.
        end.
        else assign v_num_seq_bem_pat = 0.
    end /* if */.
    else
        assign v_num_bem_pat = tt_criacao_bem_pat_api_6.tta_num_bem_pat
               v_num_seq_bem_pat = tt_criacao_bem_pat_api_6.tta_num_seq_bem_pat.

    create bem_pat.
    assign bem_pat.cod_empresa     = v_cod_empresa
           bem_pat.cod_cta_pat     = tt_criacao_bem_pat_api_6.tta_cod_cta_pat
           bem_pat.num_bem_pat     = v_num_bem_pat
           bem_pat.num_seq_bem_pat = v_num_seq_bem_pat
           bem_pat.des_bem_pat     = tt_criacao_bem_pat_api_6.tta_des_bem_pat
           bem_pat.ind_orig_bem    = "Migraá∆o" /*l_migracao*/ 
           bem_pat.qtd_bem_pat_represen = tt_criacao_bem_pat_api_6.tta_qtd_bem_pat_represen
           bem_pat.dat_aquis_bem_pat  = tt_criacao_bem_pat_api_6.tta_dat_aquis_bem_pat
           bem_pat.cod_estab          = v_cod_estab
           bem_pat.cod_grp_calc       = cta_pat.cod_grp_calc
           bem_pat.cb3_ident_visual   = ?
           bem_pat.cdn_fornecedor     = tt_criacao_bem_pat_api_6.tta_cdn_fornecedor
           bem_pat.cod_plano_ccusto   = v_cod_plano_ccusto
           bem_pat.cod_ccusto_respons = v_cod_ccusto
           bem_pat.cod_unid_negoc     = tt_criacao_bem_pat_api_6.tta_cod_unid_negoc
           bem_pat.dat_calc_pat       = tt_criacao_bem_pat_api_6.tta_dat_aquis_bem_pat
           bem_pat.cod_indic_econ     = v_cod_indic_econ 
           bem_pat.val_original       = tt_criacao_bem_pat_api_6.ttv_val_aquis_bem_pat
           bem_pat.cod_indic_econ_avaliac = v_cod_indic_econ
           bem_pat.val_avaliac_apol_seguro = tt_criacao_bem_pat_api_6.ttv_val_aquis_bem_pat
           bem_pat.dat_avaliac_apol_seguro = tt_criacao_bem_pat_api_6.tta_dat_aquis_bem_pat
           bem_pat.des_narrat_bem_pat      = tt_criacao_bem_pat_api_6.tta_des_bem_pat
           bem_pat.des_narrat_bem_pat  = tt_criacao_bem_pat_api_6.tta_des_narrat_bem_pat.

    assign tt_criacao_bem_pat_api_6.tta_num_bem_pat = v_num_bem_pat
           tt_criacao_bem_pat_api_6.tta_num_seq_bem_pat = v_num_seq_bem_pat.

    /* ---------- MP 66 / MP 135 ----------*/
    if v_cod_pais_empres_usuar = "BRA" /*l_bra*/  then do:
       if  tt_criacao_bem_pat_api_6.tta_log_bem_imptdo <> ?
       and tt_criacao_bem_pat_api_6.tta_log_cr_pis     <> ? then do:
           &if '{&emsuni_version}' >= '5.06' &then
               assign bem_pat.log_bem_imptdo = tt_criacao_bem_pat_api_6.tta_log_bem_imptdo
                      bem_pat.log_cr_pis     = tt_criacao_bem_pat_api_6.tta_log_cr_pis.
           &else
               assign bem_pat.cod_livre_1 = string(tt_criacao_bem_pat_api_6.tta_log_bem_imptdo) + ';' +
                                            string(tt_criacao_bem_pat_api_6.tta_log_cr_pis).
           &endif
       end.
       else do:
           &if '{&emsuni_version}' >= '5.06' &then
               assign bem_pat.log_bem_imptdo = no
                      bem_pat.log_cr_pis     = no.
           &else
               assign bem_pat.cod_livre_1 = string(no) + ';' +
                                            string(no).
           &endif
       end.

       &if '{&emsuni_version}' >= '5.06' &then
           assign bem_pat.log_cr_cofins = (tt_criacao_bem_pat_api_6.tta_log_cr_cofins = yes).
       &else
           assign bem_pat.cod_livre_1 = bem_pat.cod_livre_1 + ';' +
                                        string((tt_criacao_bem_pat_api_6.tta_log_cr_cofins = yes)).
       &endif

       /* Credito Parcelado 48x PIS COFINS - para bens adquiridos apos 30/04/2004 */
       if  bem_pat.dat_aquis_bem_pat >= 05/01/2004 then do:
           /* Somente ser† valido o credito parcelado em 48x quando o bem creditar PIS ou COFINS. */
           &if '{&emsuni_version}' >= '5.06' &then
               if  not bem_pat.log_cr_cofins
               and not bem_pat.log_cr_pis then
                   assign bem_pat.num_parc_pis_cofins = 0.
               else
                   assign bem_pat.num_parc_pis_cofins = tt_criacao_bem_pat_api_6.ttv_num_parc_pis_cofins.
           &else
               if  entry(3,bem_pat.cod_livre_1,';') <> 'yes'
               and entry(2,bem_pat.cod_livre_1,';') <> 'yes' then
                   assign bem_pat.cod_livre_1 = bem_pat.cod_livre_1 + ';' + '00'.
               else
                   assign bem_pat.cod_livre_1 = bem_pat.cod_livre_1 + ';' +
                                                string(tt_criacao_bem_pat_api_6.ttv_num_parc_pis_cofins,'99').
           &endif
       end.
       else do:
           &if '{&emsuni_version}' >= '5.06' &then
               assign bem_pat.num_parc_pis_cofins = 0.
           &else
               assign bem_pat.cod_livre_1 = bem_pat.cod_livre_1 + ';' + '00'.
           &endif
       end.

       /* PIS - COFINS 48X - valores de crÇdito PIS/COFINS */
       if tt_criacao_bem_pat_api_6.ttv_num_parc_pis_cofins > 0 then do:

           &if '{&emsfin_version}' >= '5.06' &then
               assign bem_pat.val_cr_pis = tt_criacao_bem_pat_api_6.tta_val_cr_pis
                   bem_pat.val_cr_cofins = tt_criacao_bem_pat_api_6.tta_val_cr_cofins.
           &else
               /* Entry 5 - valor crÇdito PIS, Entry 6 - valor crÇdito COFINS */
               if tt_criacao_bem_pat_api_6.tta_log_cr_pis = yes then
                   assign bem_pat.cod_livre_1 = bem_pat.cod_livre_1 + ';' + string(tt_criacao_bem_pat_api_6.tta_val_cr_pis).
               else
                   assign bem_pat.cod_livre_1 = bem_pat.cod_livre_1 + ';' + string(0).

               if tt_criacao_bem_pat_api_6.tta_log_cr_cofins = yes then
                   assign bem_pat.cod_livre_1 = bem_pat.cod_livre_1 + ';' + string(tt_criacao_bem_pat_api_6.tta_val_cr_cofins).
               else
                   assign bem_pat.cod_livre_1 = bem_pat.cod_livre_1 + ';' + string(0).
           &endif.
       end.
       else do:
           &if '{&emsfin_version}' >= '5.06' &then
               assign bem_pat.val_cr_pis = 0
                   bem_pat.val_cr_cofins = 0.
           &else
               /* Entry 5 - valor crÇdito PIS, Entry 6 - valor crÇdito COFINS */
               assign bem_pat.cod_livre_1 = bem_pat.cod_livre_1 + ';0;0'.
           &endif.   
       end.

       /*A validaá∆o Program-name deve ser evoluida quando houver evoluá∆o do pi_main_api_criacao_bem_pat*/ 
       /*BASE COFINS*/
       if  &if '{&emsuni_version}' >= '5.06' &then bem_pat.log_cr_cofins &else entry(3,bem_pat.cod_livre_1,';') = 'yes' &endif then do:
           &if '{&emsfin_version}' >= '5.09' &then
               if tt_criacao_bem_pat_api_6.tta_val_base_cofins > 0 then
                   assign bem_pat.val_base_cofins = tt_criacao_bem_pat_api_6.tta_val_base_cofins.
               else if PROGRAM-NAME(3) <> 'pi_main_api_criacao_bem_pat_8 esp/fas/esfas020aa.p' then do:
                   /* Begin_Include: i_erros_api_criacao_bem_pat */
                   create tt_erros_criacao_bem_pat_api_1.
                   assign tt_erros_criacao_bem_pat_api_1.tta_cod_unid_organ_ext   = tt_criacao_bem_pat_api_6.tta_cod_unid_organ_ext
                          tt_erros_criacao_bem_pat_api_1.tta_cod_cta_pat          = tt_criacao_bem_pat_api_6.tta_cod_cta_pat
                          tt_erros_criacao_bem_pat_api_1.tta_num_bem_pat          = tt_criacao_bem_pat_api_6.tta_num_bem_pat
                          tt_erros_criacao_bem_pat_api_1.tta_num_seq_bem_pat      = tt_criacao_bem_pat_api_6.tta_num_seq_bem_pat
                          tt_erros_criacao_bem_pat_api_1.tta_des_bem_pat          = tt_criacao_bem_pat_api_6.tta_des_bem_pat
                          tt_erros_criacao_bem_pat_api_1.tta_dat_aquis_bem_pat    = tt_criacao_bem_pat_api_6.tta_dat_aquis_bem_pat
                          tt_erros_criacao_bem_pat_api_1.tta_cod_finalid_econ_ext = tt_criacao_bem_pat_api_6.tta_cod_finalid_econ_ext.

                   /* End_Include: i_erros_api_criacao_bem_pat */
                   assign tt_erros_criacao_bem_pat_api_1.ttv_des_mensagem = getStrTrans("O valor base COFINS deve ser maior que zero !", "FAS") /*21070*/.
                   return "NOK" /*l_nok*/ .                   
               end.               
           &else
               if tt_criacao_bem_pat_api_6.tta_log_cr_cofins = yes 
               and tt_criacao_bem_pat_api_6.tta_val_base_cofins > 0 then
                   assign bem_pat.cod_livre_1 = SetEntryField(11,bem_pat.cod_livre_1,";",string(tt_criacao_bem_pat_api_6.tta_val_base_cofins)).
               else if PROGRAM-NAME(3) <> 'pi_main_api_criacao_bem_pat_8 esp/fas/esfs020aa.p' then do:
                   /* Begin_Include: i_erros_api_criacao_bem_pat */
                   create tt_erros_criacao_bem_pat_api_1.
                   assign tt_erros_criacao_bem_pat_api_1.tta_cod_unid_organ_ext   = tt_criacao_bem_pat_api_6.tta_cod_unid_organ_ext
                          tt_erros_criacao_bem_pat_api_1.tta_cod_cta_pat          = tt_criacao_bem_pat_api_6.tta_cod_cta_pat
                          tt_erros_criacao_bem_pat_api_1.tta_num_bem_pat          = tt_criacao_bem_pat_api_6.tta_num_bem_pat
                          tt_erros_criacao_bem_pat_api_1.tta_num_seq_bem_pat      = tt_criacao_bem_pat_api_6.tta_num_seq_bem_pat
                          tt_erros_criacao_bem_pat_api_1.tta_des_bem_pat          = tt_criacao_bem_pat_api_6.tta_des_bem_pat
                          tt_erros_criacao_bem_pat_api_1.tta_dat_aquis_bem_pat    = tt_criacao_bem_pat_api_6.tta_dat_aquis_bem_pat
                          tt_erros_criacao_bem_pat_api_1.tta_cod_finalid_econ_ext = tt_criacao_bem_pat_api_6.tta_cod_finalid_econ_ext.

                   /* End_Include: i_erros_api_criacao_bem_pat */

                   assign tt_erros_criacao_bem_pat_api_1.ttv_des_mensagem = getStrTrans("O valor base COFINS deve ser maior que zero !", "FAS") /*21070*/.
                   return "NOK" /*l_nok*/ .
               end.               
           &endif.
       end.
       else do:
           &if '{&emsfin_version}' >= '5.09' &then
               assign bem_pat.val_base_cofins = 0.
           &else
               assign bem_pat.cod_livre_1 = SetEntryField(11,bem_pat.cod_livre_1,";","0"). 
           &endif.
       end.

       /* BASE PIS*/
       if &if '{&emsuni_version}' >= '5.06' &then bem_pat.log_cr_pis &else entry(2,bem_pat.cod_livre_1,';') = 'yes' &endif then do:
           &if '{&emsfin_version}' >= '5.09' &then
               if tt_criacao_bem_pat_api_6.tta_val_base_pis > 0 then
                   assign bem_pat.val_base_pis = tt_criacao_bem_pat_api_6.tta_val_base_pis.
               else if PROGRAM-NAME(3) <> 'pi_main_api_criacao_bem_pat_8 esp/fas/esfas020aa.p' then do:
                   /* Begin_Include: i_erros_api_criacao_bem_pat */
                   create tt_erros_criacao_bem_pat_api_1.
                   assign tt_erros_criacao_bem_pat_api_1.tta_cod_unid_organ_ext   = tt_criacao_bem_pat_api_6.tta_cod_unid_organ_ext
                          tt_erros_criacao_bem_pat_api_1.tta_cod_cta_pat          = tt_criacao_bem_pat_api_6.tta_cod_cta_pat
                          tt_erros_criacao_bem_pat_api_1.tta_num_bem_pat          = tt_criacao_bem_pat_api_6.tta_num_bem_pat
                          tt_erros_criacao_bem_pat_api_1.tta_num_seq_bem_pat      = tt_criacao_bem_pat_api_6.tta_num_seq_bem_pat
                          tt_erros_criacao_bem_pat_api_1.tta_des_bem_pat          = tt_criacao_bem_pat_api_6.tta_des_bem_pat
                          tt_erros_criacao_bem_pat_api_1.tta_dat_aquis_bem_pat    = tt_criacao_bem_pat_api_6.tta_dat_aquis_bem_pat
                          tt_erros_criacao_bem_pat_api_1.tta_cod_finalid_econ_ext = tt_criacao_bem_pat_api_6.tta_cod_finalid_econ_ext.

                   /* End_Include: i_erros_api_criacao_bem_pat */
                   assign tt_erros_criacao_bem_pat_api_1.ttv_des_mensagem = getStrTrans("O valor base PIS deve ser maior que zero !", "FAS") /*21069*/.
                   return "NOK" /*l_nok*/ .
               end.
           &else
               if tt_criacao_bem_pat_api_6.tta_log_cr_pis = yes
               and tt_criacao_bem_pat_api_6.tta_val_base_pis > 0 then do:
                   assign bem_pat.cod_livre_1 = SetEntryField(10,bem_pat.cod_livre_1,";",string(tt_criacao_bem_pat_api_6.tta_val_base_pis)).
               end.
               else if PROGRAM-NAME(3) <> 'pi_main_api_criacao_bem_pat_8 esp/fas/esfas020aa.p' then do:
                   /* Begin_Include: i_erros_api_criacao_bem_pat */
                   create tt_erros_criacao_bem_pat_api_1.
                   assign tt_erros_criacao_bem_pat_api_1.tta_cod_unid_organ_ext   = tt_criacao_bem_pat_api_6.tta_cod_unid_organ_ext
                          tt_erros_criacao_bem_pat_api_1.tta_cod_cta_pat          = tt_criacao_bem_pat_api_6.tta_cod_cta_pat
                          tt_erros_criacao_bem_pat_api_1.tta_num_bem_pat          = tt_criacao_bem_pat_api_6.tta_num_bem_pat
                          tt_erros_criacao_bem_pat_api_1.tta_num_seq_bem_pat      = tt_criacao_bem_pat_api_6.tta_num_seq_bem_pat
                          tt_erros_criacao_bem_pat_api_1.tta_des_bem_pat          = tt_criacao_bem_pat_api_6.tta_des_bem_pat
                          tt_erros_criacao_bem_pat_api_1.tta_dat_aquis_bem_pat    = tt_criacao_bem_pat_api_6.tta_dat_aquis_bem_pat
                          tt_erros_criacao_bem_pat_api_1.tta_cod_finalid_econ_ext = tt_criacao_bem_pat_api_6.tta_cod_finalid_econ_ext.

                   /* End_Include: i_erros_api_criacao_bem_pat */
                   assign tt_erros_criacao_bem_pat_api_1.ttv_des_mensagem = getStrTrans("O valor base PIS deve ser maior que zero !", "FAS") /*21069*/.
                   return "NOK" /*l_nok*/ .
               end. 
           &endif.
       end.
       else do:
           &if '{&emsfin_version}' >= '5.09' &then
               assign bem_pat.val_base_pis = 0.
           &else
               assign bem_pat.cod_livre_1 = SetEntryField(10,bem_pat.cod_livre_1,";","0"). 
           &endif.
       end.

       /* MP219 - Credito CSLL */
       &if '{&emsfin_version}' >= '5.06' &then
           if  tt_criacao_bem_pat_api_6.ttv_log_cr_csll then
               assign bem_pat.log_cr_csll = tt_criacao_bem_pat_api_6.ttv_log_cr_csll
                      bem_pat.num_exerc_cr_csll = tt_criacao_bem_pat_api_6.ttv_num_exerc_cr_csll.
       &else
           if  tt_criacao_bem_pat_api_6.ttv_log_cr_csll then
               assign bem_pat.cod_livre_1 = bem_pat.cod_livre_1 + ';' + string(tt_criacao_bem_pat_api_6.ttv_log_cr_csll)
                                          + ';' + string(tt_criacao_bem_pat_api_6.ttv_num_exerc_cr_csll).
           else
               assign bem_pat.cod_livre_1 = bem_pat.cod_livre_1 + ';no;0'.
       &endif
    end.

    create movto_bem_pat.
    assign movto_bem_pat.num_id_bem_pat         = bem_pat.num_id_bem_pat
           movto_bem_pat.num_seq_incorp_bem_pat = 0
           movto_bem_pat.num_seq_movto_bem_pat  = next-value(seq_movto_bem_pat)
           movto_bem_pat.dat_movto_bem_pat      = bem_pat.dat_aquis_bem_pat
           movto_bem_pat.ind_trans_calc_bem_pat = "Implantaá∆o" /*l_implantacao*/ 
           movto_bem_pat.ind_orig_calc_bem_pat  = "Aquisiá∆o" /*l_aquisicao*/ 
           movto_bem_pat.log_calc_pat           = yes
           movto_bem_pat.cod_cta_pat            = bem_pat.cod_cta_pat
           movto_bem_pat.cod_estab              = bem_pat.cod_estab
           movto_bem_pat.cod_empresa            = bem_pat.cod_empresa
           movto_bem_pat.cod_plano_ccusto       = bem_pat.cod_plano_ccusto
           movto_bem_pat.cod_ccusto_respons     = bem_pat.cod_ccusto_respons
           movto_bem_pat.cod_unid_negoc         = bem_pat.cod_unid_negoc
           movto_bem_pat.val_origin_movto_bem_pat = bem_pat.val_original
           movto_bem_pat.cod_indic_econ           = v_cod_indic_econ
           movto_bem_pat.qtd_movto_bem_pat        = bem_pat.qtd_bem_pat_represen.

    blk_param:
    for each param_calc_cta no-lock
        where param_calc_cta.cod_empresa = v_cod_empresa
        and   param_calc_cta.cod_cta_pat = tt_criacao_bem_pat_api_6.tta_cod_cta_pat
        break by param_calc_cta.cod_cenar_ctbl:
        create param_calc_bem_pat.
        assign param_calc_bem_pat.num_id_bem_pat             = bem_pat.num_id_bem_pat
               param_calc_bem_pat.cod_tip_calc               = param_calc_cta.cod_tip_calc
               param_calc_bem_pat.cod_cenar_ctbl             = param_calc_cta.cod_cenar_ctbl
               param_calc_bem_pat.cod_finalid_econ           = param_calc_cta.cod_finalid_econ
               param_calc_bem_pat.cod_grp_calc               = param_calc_cta.cod_grp_calc
               param_calc_bem_pat.dat_inic_calc              = tt_criacao_bem_pat_api_6.tta_dat_aquis_bem_pat
               param_calc_bem_pat.val_perc_anual_dpr         = param_calc_cta.val_perc_anual_dpr
               param_calc_bem_pat.qtd_anos_vida_util         = param_calc_cta.qtd_anos_vida_util
               param_calc_bem_pat.qtd_unid_vida_util         = param_calc_cta.qtd_unid_vida_util
               param_calc_bem_pat.val_resid_min              = param_calc_cta.val_resid_min
               param_calc_bem_pat.val_perc_anual_dpr_incevda = param_calc_cta.val_perc_anual_dpr_incevda.

        if  v_log_localiz_col
        then do:
                run pi_colext_retorna_param_calc_cta 
                      in v_hdl_procedure (INPUT  param_calc_cta.cod_empresa,
                                         INPUT  param_calc_cta.cod_cta_pat,
                                         INPUT  param_calc_cta.cod_tip_calc,
                                         INPUT  param_calc_cta.cod_cenar_ctbl,
                                         INPUT  param_calc_cta.cod_finalid_econ,
                                         OUTPUT v_qtd_dias_vida_util).

                run pi_colext_inclui_param_calc_bem_pat 
                       in v_hdl_procedure (INPUT  param_calc_bem_pat.num_id_bem_pat,
                                           INPUT  param_calc_bem_pat.cod_tip_calc,
                                           INPUT  param_calc_bem_pat.cod_cenar_ctbl,
                                           INPUT  param_calc_bem_pat.cod_finalid_econ,
                                           INPUT  v_qtd_dias_vida_util).
        end /* if */.       

        if  first-of(param_calc_cta.cod_cenar_ctbl)
        then do:
            create movto_cenar_bem_pat.
            assign movto_cenar_bem_pat.num_id_bem_pat         = bem_pat.num_id_bem_pat
                   movto_cenar_bem_pat.num_seq_incorp_bem_pat = 0
                   movto_cenar_bem_pat.num_seq_movto_bem_pat  = movto_bem_pat.num_seq_movto_bem_pat
                   movto_cenar_bem_pat.cod_cenar_ctbl         = param_calc_cta.cod_cenar_ctbl
                   movto_cenar_bem_pat.log_calc_pat           = yes.
        end /* if */.

        if  param_calc_cta.cod_tip_calc = ""
        then do:
            run pi_converter_indic_econ_finalid_cenar (Input v_cod_indic_econ,
                                                       Input v_cod_empresa,
                                                       Input param_calc_cta.cod_cenar_ctbl,
                                                       Input bem_pat.dat_aquis_bem_pat,
                                                       Input bem_pat.val_original,
                                                       Input param_calc_cta.cod_finalid_econ,
                                                       output v_cod_return) /*pi_converter_indic_econ_finalid_cenar*/.
            blk_valor:
            for each tt_converter_finalid_econ:
                create val_origin_bem_pat.
                assign val_origin_bem_pat.num_id_bem_pat         = bem_pat.num_id_bem_pat
                       val_origin_bem_pat.num_seq_incorp_bem_pat = 0
                       val_origin_bem_pat.cod_cenar_ctbl         = param_calc_cta.cod_cenar_ctbl
                       val_origin_bem_pat.cod_finalid_econ       = tt_converter_finalid_econ.tta_cod_finalid_econ
                       val_origin_bem_pat.dat_calc_pat           = bem_pat.dat_calc_pat
                       val_origin_bem_pat.val_original           = tt_converter_finalid_econ.tta_val_transacao
                       val_origin_bem_pat.num_seq_movto_bem_pat  = movto_bem_pat.num_seq_movto_bem_pat
                       val_origin_bem_pat.dat_cotac_indic_econ   = tt_converter_finalid_econ.tta_dat_cotac_indic_econ
                       val_origin_bem_pat.val_cotac_indic_econ   = tt_converter_finalid_econ.tta_val_cotac_indic_econ.
                create reg_calc_bem_pat.
                assign reg_calc_bem_pat.num_id_bem_pat         = val_origin_bem_pat.num_id_bem_pat
                       reg_calc_bem_pat.num_seq_incorp_bem_pat = val_origin_bem_pat.num_seq_incorp_bem_pat
                       reg_calc_bem_pat.cod_tip_calc           = ""
                       reg_calc_bem_pat.cod_cenar_ctbl         = val_origin_bem_pat.cod_cenar_ctbl
                       reg_calc_bem_pat.cod_finalid_econ       = val_origin_bem_pat.cod_finalid_econ
                       reg_calc_bem_pat.dat_calc_pat           = val_origin_bem_pat.dat_calc_pat
                       reg_calc_bem_pat.ind_trans_calc_bem_pat = movto_bem_pat.ind_trans_calc_bem_pat
                       reg_calc_bem_pat.ind_orig_calc_bem_pat  = movto_bem_pat.ind_orig_calc_bem_pat
                       reg_calc_bem_pat.cod_grp_calc           = param_calc_cta.cod_grp_calc
                       reg_calc_bem_pat.val_original           = val_origin_bem_pat.val_original
                       reg_calc_bem_pat.val_origin_corrig      = val_origin_bem_pat.val_original
                       reg_calc_bem_pat.ind_tip_calc           = ""
                       reg_calc_bem_pat.log_ctbz_bem_pat       = no
                       reg_calc_bem_pat.log_aprop_ctbl_pat     = v_log_ctbz
                       reg_calc_bem_pat.cod_empresa            = bem_pat.cod_empresa
                       reg_calc_bem_pat.cod_plano_ccusto       = bem_pat.cod_plano_ccusto
                       reg_calc_bem_pat.cod_ccusto_respons     = bem_pat.cod_ccusto_respons
                       reg_calc_bem_pat.cod_unid_negoc         = bem_pat.cod_unid_negoc
                       reg_calc_bem_pat.cod_estab              = bem_pat.cod_estab.
                if  v_log_ctbz = yes
                then do:
                    if  search("prgfin/fas/fas700za.r") = ? and search("prgfin/fas/fas700za.py") = ? then do:
                        if  v_cod_dwb_user begins 'es_' then
                            return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgfin/fas/fas700za.py".
                        else do:
                            message getStrTrans("Programa execut†vel n∆o foi encontrado:", "FAS") /*l_programa_nao_encontrado*/  "prgfin/fas/fas700za.py"
                                   view-as alert-box error buttons ok.
                            return.
                        end.
                    end.
                    else
                        run prgfin/fas/fas700za.py (buffer bem_pat,
                                                buffer reg_calc_bem_pat,
                                                Input "Em Arquivo" /*l_on_file*/,
                                                output v_cod_return) /*prg_fnc_aprop_ctbl_pat_criar*/.
                    if  return-value = "NOK" /*l_nok*/ 
                    then do:
                        create tt_erros_criacao_bem_pat_api_1.
                        assign tt_erros_criacao_bem_pat_api_1.tta_cod_unid_organ_ext = tt_criacao_bem_pat_api_6.tta_cod_unid_organ_ext
                               tt_erros_criacao_bem_pat_api_1.tta_cod_cta_pat        = tt_criacao_bem_pat_api_6.tta_cod_cta_pat
                               tt_erros_criacao_bem_pat_api_1.tta_num_bem_pat        = tt_criacao_bem_pat_api_6.tta_num_bem_pat
                               tt_erros_criacao_bem_pat_api_1.tta_num_seq_bem_pat    = tt_criacao_bem_pat_api_6.tta_num_seq_bem_pat
                               tt_erros_criacao_bem_pat_api_1.tta_des_bem_pat        = tt_criacao_bem_pat_api_6.tta_des_bem_pat
                               tt_erros_criacao_bem_pat_api_1.tta_dat_aquis_bem_pat  = tt_criacao_bem_pat_api_6.tta_dat_aquis_bem_pat
                               tt_erros_criacao_bem_pat_api_1.tta_cod_finalid_econ_ext = tt_criacao_bem_pat_api_6.tta_cod_finalid_econ_ext.
                        run pi_trata_retorno_fnc_aprop_ctbl_pat_criar (Input v_cod_return,
                                                                       output tt_erros_criacao_bem_pat_api_1.ttv_des_mensagem) /*pi_trata_retorno_fnc_aprop_ctbl_pat_criar*/.
                        return "NOK" /*l_nok*/ .
                    end /* if */.
                end /* if */.
                create sdo_bem_pat.
                assign sdo_bem_pat.num_id_bem_pat         = reg_calc_bem_pat.num_id_bem_pat
                       sdo_bem_pat.num_seq_incorp_bem_pat = reg_calc_bem_pat.num_seq_incorp_bem_pat
                       sdo_bem_pat.cod_cenar_ctbl         = reg_calc_bem_pat.cod_cenar_ctbl
                       sdo_bem_pat.cod_finalid_econ       = reg_calc_bem_pat.cod_finalid_econ
                       sdo_bem_pat.dat_sdo_bem_pat        = reg_calc_bem_pat.dat_calc_pat
                       sdo_bem_pat.val_original           = reg_calc_bem_pat.val_original
                       sdo_bem_pat.val_origin_corrig      = reg_calc_bem_pat.val_origin_corrig
                       sdo_bem_pat.num_seq_movto_bem_pat  = movto_bem_pat.num_seq_movto_bem_pat.
            end /* for blk_valor */.
        end /* if */.
    end /* for blk_param */.
    assign tt_criacao_bem_pat_api_6.tta_num_id_bem_pat = bem_pat.num_id_bem_pat.

    for each tt_criacao_bem_pat_val_resid no-lock
        where tt_criacao_bem_pat_val_resid.ttv_rec_bem = recid(tt_criacao_bem_pat_api_6):
        /* Rodrigo - ATV247694*/
        find first param_calc_bem_pat exclusive-lock
            where param_calc_bem_pat.num_id_bem       = bem_pat.num_id_bem_pat
            and   param_calc_bem_pat.cod_tip_calc     = tt_criacao_bem_pat_val_resid.tta_cod_tip_calc
            and   param_calc_bem_pat.cod_cenar_ctbl   = tt_criacao_bem_pat_val_resid.tta_cod_cenar_ctbl
            and   param_calc_bem_pat.cod_finalid_econ = tt_criacao_bem_pat_val_resid.tta_cod_finalid_econ no-error.
        /* Rodrigo - ATV247694*/
        if not avail param_calc_bem_pat then do:

            /* Begin_Include: i_erros_api_criacao_bem_pat */
            create tt_erros_criacao_bem_pat_api_1.
            assign tt_erros_criacao_bem_pat_api_1.tta_cod_unid_organ_ext   = tt_criacao_bem_pat_api_6.tta_cod_unid_organ_ext
                   tt_erros_criacao_bem_pat_api_1.tta_cod_cta_pat          = tt_criacao_bem_pat_api_6.tta_cod_cta_pat
                   tt_erros_criacao_bem_pat_api_1.tta_num_bem_pat          = tt_criacao_bem_pat_api_6.tta_num_bem_pat
                   tt_erros_criacao_bem_pat_api_1.tta_num_seq_bem_pat      = tt_criacao_bem_pat_api_6.tta_num_seq_bem_pat
                   tt_erros_criacao_bem_pat_api_1.tta_des_bem_pat          = tt_criacao_bem_pat_api_6.tta_des_bem_pat
                   tt_erros_criacao_bem_pat_api_1.tta_dat_aquis_bem_pat    = tt_criacao_bem_pat_api_6.tta_dat_aquis_bem_pat
                   tt_erros_criacao_bem_pat_api_1.tta_cod_finalid_econ_ext = tt_criacao_bem_pat_api_6.tta_cod_finalid_econ_ext.

            /* End_Include: i_erros_api_criacao_bem_pat */

            assign tt_erros_criacao_bem_pat_api_1.ttv_des_mensagem = substitute(getStrTrans("ParÉmetro de C†lculo Inexistente !", "FAS") /*20571*/, tt_criacao_bem_pat_val_resid.tta_cod_tip_calc, tt_criacao_bem_pat_val_resid.tta_cod_cenar_ctbl, tt_criacao_bem_pat_val_resid.tta_cod_finalid_econ).
            return "NOK" /*l_nok*/ .
        end.
        else do:
            find first tip_calc no-lock
                where tip_calc.cod_tip_calc = param_calc_bem_pat.cod_tip_calc no-error.
            if not avail tip_calc then do:

                /* Begin_Include: i_erros_api_criacao_bem_pat */
                create tt_erros_criacao_bem_pat_api_1.
                assign tt_erros_criacao_bem_pat_api_1.tta_cod_unid_organ_ext   = tt_criacao_bem_pat_api_6.tta_cod_unid_organ_ext
                       tt_erros_criacao_bem_pat_api_1.tta_cod_cta_pat          = tt_criacao_bem_pat_api_6.tta_cod_cta_pat
                       tt_erros_criacao_bem_pat_api_1.tta_num_bem_pat          = tt_criacao_bem_pat_api_6.tta_num_bem_pat
                       tt_erros_criacao_bem_pat_api_1.tta_num_seq_bem_pat      = tt_criacao_bem_pat_api_6.tta_num_seq_bem_pat
                       tt_erros_criacao_bem_pat_api_1.tta_des_bem_pat          = tt_criacao_bem_pat_api_6.tta_des_bem_pat
                       tt_erros_criacao_bem_pat_api_1.tta_dat_aquis_bem_pat    = tt_criacao_bem_pat_api_6.tta_dat_aquis_bem_pat
                       tt_erros_criacao_bem_pat_api_1.tta_cod_finalid_econ_ext = tt_criacao_bem_pat_api_6.tta_cod_finalid_econ_ext.

                /* End_Include: i_erros_api_criacao_bem_pat */

                assign tt_erros_criacao_bem_pat_api_1.ttv_des_mensagem = substitute(getStrTrans("Tipo de C†lculo &1 n∆o encontrado !", "FAS") /*4383*/, param_calc_bem_pat.cod_tip_calc).
                return "NOK" /*l_nok*/ .
            end.
            else do:
                if tip_calc.ind_lim_dpr <> "Residual" /*l_residual*/  then do:

                    /* Begin_Include: i_erros_api_criacao_bem_pat */
                    create tt_erros_criacao_bem_pat_api_1.
                    assign tt_erros_criacao_bem_pat_api_1.tta_cod_unid_organ_ext   = tt_criacao_bem_pat_api_6.tta_cod_unid_organ_ext
                           tt_erros_criacao_bem_pat_api_1.tta_cod_cta_pat          = tt_criacao_bem_pat_api_6.tta_cod_cta_pat
                           tt_erros_criacao_bem_pat_api_1.tta_num_bem_pat          = tt_criacao_bem_pat_api_6.tta_num_bem_pat
                           tt_erros_criacao_bem_pat_api_1.tta_num_seq_bem_pat      = tt_criacao_bem_pat_api_6.tta_num_seq_bem_pat
                           tt_erros_criacao_bem_pat_api_1.tta_des_bem_pat          = tt_criacao_bem_pat_api_6.tta_des_bem_pat
                           tt_erros_criacao_bem_pat_api_1.tta_dat_aquis_bem_pat    = tt_criacao_bem_pat_api_6.tta_dat_aquis_bem_pat
                           tt_erros_criacao_bem_pat_api_1.tta_cod_finalid_econ_ext = tt_criacao_bem_pat_api_6.tta_cod_finalid_econ_ext.

                    /* End_Include: i_erros_api_criacao_bem_pat */

                    assign tt_erros_criacao_bem_pat_api_1.ttv_des_mensagem = substitute(getStrTrans("Valor Residual M°nimo n∆o pode ser informado !", "FAS") /*20572*/, tip_calc.cod_tip_calc).
                    return "NOK" /*l_nok*/ .
                end.
            end.
            assign v_val_orig_bem_pat = 0.
            for each val_origin_bem_pat no-lock 
                where val_origin_bem_pat.num_id_bem_pat         = bem_pat.num_id_bem_pat
                  and val_origin_bem_pat.num_seq_incorp_bem_pat = 0
                  and val_origin_bem_pat.cod_cenar_ctbl         = tt_criacao_bem_pat_val_resid.tta_cod_cenar_ctbl
                  and val_origin_bem_pat.cod_finalid_econ       = tt_criacao_bem_pat_val_resid.tta_cod_finalid_econ:

                  assign v_val_orig_bem_pat = v_val_orig_bem_pat + val_origin_bem_pat.val_original.
            end.
            if  tt_criacao_bem_pat_val_resid.tta_val_resid_min <> 0 and tt_criacao_bem_pat_val_resid.tta_val_resid_min > v_val_orig_bem_pat then do:

                /* Begin_Include: i_erros_api_criacao_bem_pat */
                create tt_erros_criacao_bem_pat_api_1.
                assign tt_erros_criacao_bem_pat_api_1.tta_cod_unid_organ_ext   = tt_criacao_bem_pat_api_6.tta_cod_unid_organ_ext
                       tt_erros_criacao_bem_pat_api_1.tta_cod_cta_pat          = tt_criacao_bem_pat_api_6.tta_cod_cta_pat
                       tt_erros_criacao_bem_pat_api_1.tta_num_bem_pat          = tt_criacao_bem_pat_api_6.tta_num_bem_pat
                       tt_erros_criacao_bem_pat_api_1.tta_num_seq_bem_pat      = tt_criacao_bem_pat_api_6.tta_num_seq_bem_pat
                       tt_erros_criacao_bem_pat_api_1.tta_des_bem_pat          = tt_criacao_bem_pat_api_6.tta_des_bem_pat
                       tt_erros_criacao_bem_pat_api_1.tta_dat_aquis_bem_pat    = tt_criacao_bem_pat_api_6.tta_dat_aquis_bem_pat
                       tt_erros_criacao_bem_pat_api_1.tta_cod_finalid_econ_ext = tt_criacao_bem_pat_api_6.tta_cod_finalid_econ_ext.

                /* End_Include: i_erros_api_criacao_bem_pat */

                assign tt_erros_criacao_bem_pat_api_1.ttv_des_mensagem = substitute(getStrTrans("Valor  Residual deve ser menor que Valor Original !", "FAS") /*1323*/, tt_criacao_bem_pat_val_resid.tta_cod_cenar_ctbl, tt_criacao_bem_pat_val_resid.tta_cod_tip_calc).
                return "NOK" /*l_nok*/ .
            end.
            assign param_calc_bem_pat.val_resid_min = tt_criacao_bem_pat_val_resid.tta_val_resid_min.
        end.
    end.

    for each tt_criacao_bem_pat_item_api
       where tt_criacao_bem_pat_item_api.ttv_rec_bem = recid(tt_criacao_bem_pat_api_6):

        for first item_docto_entr no-lock
            where item_docto_entr.cod_estab           = v_cod_estab
              and item_docto_entr.cod_empresa         = v_cod_empresa
              and item_docto_entr.cdn_fornecedor      = tt_criacao_bem_pat_item_api.tta_cdn_fornecedor
              and item_docto_entr.cod_docto_entr      = tt_criacao_bem_pat_item_api.tta_cod_docto_entr
              and item_docto_entr.cod_ser_nota        = tt_criacao_bem_pat_item_api.tta_cod_ser_nota
              and item_docto_entr.num_item_docto_entr = tt_criacao_bem_pat_item_api.tta_num_item_docto_entr:

            create bem_pat_item_docto_entr.
            assign bem_pat_item_docto_entr.num_id_bem_pat          = bem_pat.num_id_bem_pat
                   bem_pat_item_docto_entr.num_seq_incorp_bem_pat  = 0
                   bem_pat_item_docto_entr.cod_estab               = item_docto_entr.cod_estab
                   bem_pat_item_docto_entr.cod_empresa             = item_docto_entr.cod_empresa
                   bem_pat_item_docto_entr.cdn_fornecedor          = item_docto_entr.cdn_fornecedor
                   bem_pat_item_docto_entr.cod_docto_entr          = item_docto_entr.cod_docto_entr
                   bem_pat_item_docto_entr.cod_ser_nota            = item_docto_entr.cod_ser_nota
                   bem_pat_item_docto_entr.num_item_docto_entr     = item_docto_entr.num_item_docto_entr.

            assign bem_pat_item_docto_entr.qtd_item_docto_entr     = tt_criacao_bem_pat_item_api.tta_qtd_item_docto_entr
                   bem_pat_item_docto_entr.des_item_docto_entr     = item_docto_entr.des_item_docto_entr
                   bem_pat_item_docto_entr.cod_indic_econ          = item_docto_entr.cod_indic_econ
                   bem_pat_item_docto_entr.cod_espec_bem           = item_docto_entr.cod_espec_bem
                   bem_pat_item_docto_entr.cod_marca               = item_docto_entr.cod_marca
                   bem_pat_item_docto_entr.cod_modelo              = item_docto_entr.cod_modelo
                   bem_pat_item_docto_entr.num_ord_invest          = item_docto_entr.num_ord_invest
                   bem_pat_item_docto_entr.val_item_docto_entr     = item_docto_entr.val_item_docto_entr     / item_docto_entr.qtd_item_docto_entr
                   bem_pat_item_docto_entr.val_aquis_bem_pat_fasb  = item_docto_entr.val_aquis_bem_pat_fasb  / item_docto_entr.qtd_item_docto_entr
                   bem_pat_item_docto_entr.val_aquis_bem_pat_cmcac = item_docto_entr.val_aquis_bem_pat_cmcac / item_docto_entr.qtd_item_docto_entr
                   bem_pat_item_docto_entr.num_id_ri_bem_pat       = &if '{&emsfin_version}' >= '5.07' &then
                                                                     item_docto_entr.num_id_ri_bem_pat
                                                                     &else
                                                                     int(GetEntryField(6, item_docto_entr.cod_livre_1, chr(10)))
                                                                     &endif
                   bem_pat_item_docto_entr.cod_plano_ccusto        = GetEntryField(1,item_docto_entr.cod_livre_1,chr(10))
                   bem_pat_item_docto_entr.cod_ccusto              = GetEntryField(2,item_docto_entr.cod_livre_1,chr(10))
                   .

            /* Atualiza quantidade dispon°vel do item */
            run pi_atualiza_quant_item_docto_entr(input recid(item_docto_entr),
                                                  input tt_criacao_bem_pat_item_api.tta_qtd_item_docto_entr,
                                                  input "Vincula" /*l_vincula*/ ).
        end.
    end.

    /* fut36887 - atividade 154749 - integraªío FAS x MRI*/
    /* tenta conectar os bancos do ems2*/
    if  v_log_integr_ativ_fix then do:
        if  search("prgint/utb/utb720za.r") = ? and search("prgint/utb/utb720za.py") = ? then do:
            if  v_cod_dwb_user begins 'es_' then
                return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgint/utb/utb720za.py".
            else do:
                message getStrTrans("Programa execut†vel n∆o foi encontrado:", "FAS") /*l_programa_nao_encontrado*/  "prgint/utb/utb720za.py"
                       view-as alert-box error buttons ok.
                return.
            end.
        end.
        else
            run prgint/utb/utb720za.py (Input 1,
                                    Input "On-Line" /*l_online*/,
                                    output v_log_connect_ems2_ok,
                                    output v_log_connect) /*prg_fnc_conecta_bases_externas*/.
        if  v_log_connect = no and v_log_connect_ems2_ok = no
        then do:
            if  search("prgint/utb/utb720za.r") = ? and search("prgint/utb/utb720za.py") = ? then do:
                if  v_cod_dwb_user begins 'es_' then
                    return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgint/utb/utb720za.py".
                else do:
                    message getStrTrans("Programa execut†vel n∆o foi encontrado:", "FAS") /*l_programa_nao_encontrado*/  "prgint/utb/utb720za.py"
                           view-as alert-box error buttons ok.
                    return.
                end.
            end.
            else
                run prgint/utb/utb720za.py (Input 2,
                                        Input "On-Line" /*l_online*/,
                                        output v_log_connect_ems2_ok,
                                        output v_log_connect) /*prg_fnc_conecta_bases_externas*/.
        end /* if */.

        /* EPC*/
        if  v_nom_prog_upc  <> " " or v_nom_prog_appc <> " " or v_nom_prog_dpc  <> " " then do:

            for each tt_epc:
                delete tt_epc.
            end.

            create tt_epc.
            assign tt_epc.cod_event      = 'Controla_Empresa_MRI'
                    tt_epc.cod_parameter = 'Controla_Empresa_MRI'
                    tt_epc.val_parameter = string(recid(bem_pat)).


            /* Begin_Include: i_exec_program_epc_custom */
            if  v_nom_prog_upc <> '' then
            do:
                run value(v_nom_prog_upc) (input 'Controla_Empresa_MRI',
                                           input-output table tt_epc).
            end.

            if  v_nom_prog_appc <> '' then
            do:
                run value(v_nom_prog_appc) (input 'Controla_Empresa_MRI',
                                            input-output table tt_epc).
            end.

            &if '{&emsbas_version}' > '5.00' &then
            if  v_nom_prog_dpc <> '' then
            do:
                run value(v_nom_prog_dpc) (input 'Controla_Empresa_MRI',
                                            input-output table tt_epc).
            end.
            &endif
            /* End_Include: i_exec_program_epc_custom */
            .

            find first tt_epc
                 where tt_epc.cod_event     = 'Controla_Empresa_MRI'
                 and   tt_epc.cod_parameter = 'Empresa_Nao_Utiliza_Modulo_MRI'  no-lock no-error.
            if  not avail tt_epc then do:
                assign v_log_integr_mi = no.
            end.
        end.
        if  v_log_integr_mi = yes then
            run pi_criacao_bem_pat_api_2. /* pi secundaria criada para controlar o tamanho desta pi*/


        if  search("prgint/utb/utb720za.r") = ? and search("prgint/utb/utb720za.py") = ? then do:
            if  v_cod_dwb_user begins 'es_' then
                return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgint/utb/utb720za.py".
            else do:
                message getStrTrans("Programa execut†vel n∆o foi encontrado:", "FAS") /*l_programa_nao_encontrado*/  "prgint/utb/utb720za.py"
                       view-as alert-box error buttons ok.
                return.
            end.
        end.
        else
            run prgint/utb/utb720za.py (Input 2,
                                    Input "On-Line" /*l_online*/,
                                    output v_log_connect_ems2_ok,
                                    output v_log_connect) /*prg_fnc_conecta_bases_externas*/.
    end /* if */.
    return "OK" /*l_ok*/ .
END PROCEDURE. /* pi_criacao_bem_pat_api */
/*****************************************************************************
** Procedure Interna.....: pi_validar_criacao_bem_pat_api
** Descricao.............: pi_validar_criacao_bem_pat_api
** Criado por............: Puccini
** Criado em.............: 20/06/1997 11:41:56
** Alterado por..........: corp45582
** Alterado em...........: 10/08/2015 18:28:20
*****************************************************************************/
PROCEDURE pi_validar_criacao_bem_pat_api:

    find cta_pat
        where cta_pat.cod_empresa = v_cod_empresa
        and   cta_pat.cod_cta_pat = tt_criacao_bem_pat_api_6.tta_cod_cta_pat
        no-lock no-error.
    if  not avail cta_pat
    then do:

        /* Begin_Include: i_erros_api_criacao_bem_pat */
        create tt_erros_criacao_bem_pat_api_1.
        assign tt_erros_criacao_bem_pat_api_1.tta_cod_unid_organ_ext   = tt_criacao_bem_pat_api_6.tta_cod_unid_organ_ext
               tt_erros_criacao_bem_pat_api_1.tta_cod_cta_pat          = tt_criacao_bem_pat_api_6.tta_cod_cta_pat
               tt_erros_criacao_bem_pat_api_1.tta_num_bem_pat          = tt_criacao_bem_pat_api_6.tta_num_bem_pat
               tt_erros_criacao_bem_pat_api_1.tta_num_seq_bem_pat      = tt_criacao_bem_pat_api_6.tta_num_seq_bem_pat
               tt_erros_criacao_bem_pat_api_1.tta_des_bem_pat          = tt_criacao_bem_pat_api_6.tta_des_bem_pat
               tt_erros_criacao_bem_pat_api_1.tta_dat_aquis_bem_pat    = tt_criacao_bem_pat_api_6.tta_dat_aquis_bem_pat
               tt_erros_criacao_bem_pat_api_1.tta_cod_finalid_econ_ext = tt_criacao_bem_pat_api_6.tta_cod_finalid_econ_ext.

        /* End_Include: i_erros_api_criacao_bem_pat */

        assign tt_erros_criacao_bem_pat_api_1.ttv_des_mensagem = substitute(getStrTrans("Conta Patrimonial &1 do Bem Externo &2 n∆o existe.", "FAS") /*4085*/, tt_criacao_bem_pat_api_6.tta_cod_cta_pat).
        return "NOK" /*l_nok*/ .
    end /* if */.
    if  tt_criacao_bem_pat_api_6.tta_des_bem_pat = ""
    then do:

        /* Begin_Include: i_erros_api_criacao_bem_pat */
        create tt_erros_criacao_bem_pat_api_1.
        assign tt_erros_criacao_bem_pat_api_1.tta_cod_unid_organ_ext   = tt_criacao_bem_pat_api_6.tta_cod_unid_organ_ext
               tt_erros_criacao_bem_pat_api_1.tta_cod_cta_pat          = tt_criacao_bem_pat_api_6.tta_cod_cta_pat
               tt_erros_criacao_bem_pat_api_1.tta_num_bem_pat          = tt_criacao_bem_pat_api_6.tta_num_bem_pat
               tt_erros_criacao_bem_pat_api_1.tta_num_seq_bem_pat      = tt_criacao_bem_pat_api_6.tta_num_seq_bem_pat
               tt_erros_criacao_bem_pat_api_1.tta_des_bem_pat          = tt_criacao_bem_pat_api_6.tta_des_bem_pat
               tt_erros_criacao_bem_pat_api_1.tta_dat_aquis_bem_pat    = tt_criacao_bem_pat_api_6.tta_dat_aquis_bem_pat
               tt_erros_criacao_bem_pat_api_1.tta_cod_finalid_econ_ext = tt_criacao_bem_pat_api_6.tta_cod_finalid_econ_ext.

        /* End_Include: i_erros_api_criacao_bem_pat */

        assign tt_erros_criacao_bem_pat_api_1.ttv_des_mensagem = getStrTrans("Descriá∆o do Bem Patrimonial deve ser informada !", "FAS") /*843*/.
        return "NOK" /*l_nok*/ .
    end /* if */.


    find last param_geral_pat no-lock no-error.
    if avail param_geral_pat then do:
          case param_geral_pat.ind_numer_niv:
              when "Global" /*l_global*/    then do:
                  find bem_pat no-lock
                      where bem_pat.num_bem_pat         = tt_criacao_bem_pat_api_6.tta_num_bem_pat
                            and bem_pat.num_seq_bem_pat = tt_criacao_bem_pat_api_6.tta_num_seq_bem_pat
                  no-error.
                  if avail bem_pat then do:
                    create tt_erros_criacao_bem_pat_api_1.
                       assign tt_erros_criacao_bem_pat_api_1.tta_cod_unid_organ_ext   = tt_criacao_bem_pat_api_6.tta_cod_unid_organ_ext
                             tt_erros_criacao_bem_pat_api_1.tta_cod_cta_pat          = tt_criacao_bem_pat_api_6.tta_cod_cta_pat
                             tt_erros_criacao_bem_pat_api_1.tta_num_bem_pat          = tt_criacao_bem_pat_api_6.tta_num_bem_pat
                             tt_erros_criacao_bem_pat_api_1.tta_num_seq_bem_pat      = tt_criacao_bem_pat_api_6.tta_num_seq_bem_pat
                             tt_erros_criacao_bem_pat_api_1.tta_des_bem_pat          = tt_criacao_bem_pat_api_6.tta_des_bem_pat
                             tt_erros_criacao_bem_pat_api_1.tta_dat_aquis_bem_pat    = tt_criacao_bem_pat_api_6.tta_dat_aquis_bem_pat
                             tt_erros_criacao_bem_pat_api_1.tta_cod_finalid_econ_ext = tt_criacao_bem_pat_api_6.tta_cod_finalid_econ_ext                    
                             .
                      assign tt_erros_criacao_bem_pat_api_1.ttv_des_mensagem         =  substitute(getStrTrans("O bem &1 j† existe para &2.", "FAS") /*19685*/, string(tt_criacao_bem_pat_api_6.tta_num_bem_pat),getStrTrans("Global", "FAS") /*l_global*/ ).


                  end.
              end.
              when "Por Empresa" /*l_por_empresa*/    then do:
                  find bem_pat no-lock
                      where bem_pat.cod_empresa         = v_cod_empresa
                            and bem_pat.num_bem_pat     = tt_criacao_bem_pat_api_6.tta_num_bem_pat
                            and bem_pat.num_seq_bem_pat = tt_criacao_bem_pat_api_6.tta_num_seq_bem_pat
                  no-error.
                  if avail bem_pat then do:
                       create tt_erros_criacao_bem_pat_api_1.
                       assign tt_erros_criacao_bem_pat_api_1.tta_cod_unid_organ_ext  = tt_criacao_bem_pat_api_6.tta_cod_unid_organ_ext
                             tt_erros_criacao_bem_pat_api_1.tta_cod_cta_pat          = tt_criacao_bem_pat_api_6.tta_cod_cta_pat
                             tt_erros_criacao_bem_pat_api_1.tta_num_bem_pat          = tt_criacao_bem_pat_api_6.tta_num_bem_pat
                             tt_erros_criacao_bem_pat_api_1.tta_num_seq_bem_pat      = tt_criacao_bem_pat_api_6.tta_num_seq_bem_pat
                             tt_erros_criacao_bem_pat_api_1.tta_des_bem_pat          = tt_criacao_bem_pat_api_6.tta_des_bem_pat
                             tt_erros_criacao_bem_pat_api_1.tta_dat_aquis_bem_pat    = tt_criacao_bem_pat_api_6.tta_dat_aquis_bem_pat
                             tt_erros_criacao_bem_pat_api_1.tta_cod_finalid_econ_ext = tt_criacao_bem_pat_api_6.tta_cod_finalid_econ_ext
                             .
                      assign tt_erros_criacao_bem_pat_api_1.ttv_des_mensagem         = substitute(getStrTrans("O bem &1 j† existe para &2.", "FAS") /*19685*/, string(tt_criacao_bem_pat_api_6.tta_num_bem_pat),getStrTrans("Empresa", "FAS") /*l_empresa*/ ).
                  end.
              end.
              when "Por Estabelecimento" /*l_por_estabelecimento*/   then do:
                  find bem_pat no-lock
                      where bem_pat.cod_estab           = v_cod_estab
                            and bem_pat.num_bem_pat     = tt_criacao_bem_pat_api_6.tta_num_bem_pat
                            and bem_pat.num_seq_bem_pat = tt_criacao_bem_pat_api_6.tta_num_seq_bem_pat no-error.
                  if avail bem_pat then do:
                     create tt_erros_criacao_bem_pat_api_1.
                       assign tt_erros_criacao_bem_pat_api_1.tta_cod_unid_organ_ext  = tt_criacao_bem_pat_api_6.tta_cod_unid_organ_ext
                             tt_erros_criacao_bem_pat_api_1.tta_cod_cta_pat          = tt_criacao_bem_pat_api_6.tta_cod_cta_pat
                             tt_erros_criacao_bem_pat_api_1.tta_num_bem_pat          = tt_criacao_bem_pat_api_6.tta_num_bem_pat
                             tt_erros_criacao_bem_pat_api_1.tta_num_seq_bem_pat      = tt_criacao_bem_pat_api_6.tta_num_seq_bem_pat
                             tt_erros_criacao_bem_pat_api_1.tta_des_bem_pat          = tt_criacao_bem_pat_api_6.tta_des_bem_pat
                             tt_erros_criacao_bem_pat_api_1.tta_dat_aquis_bem_pat    = tt_criacao_bem_pat_api_6.tta_dat_aquis_bem_pat
                             tt_erros_criacao_bem_pat_api_1.tta_cod_finalid_econ_ext = tt_criacao_bem_pat_api_6.tta_cod_finalid_econ_ext
                             .
                      assign tt_erros_criacao_bem_pat_api_1.ttv_des_mensagem         = substitute(getStrTrans("O bem &1 j† existe para &2.", "FAS") /*19685*/, string(tt_criacao_bem_pat_api_6.tta_num_bem_pat),getStrTrans("Estabelecimento", "FAS") /*l_estabelecimento*/ ).
                  end.
              end.
              when "Por Conta" /*l_por_conta*/    then do:
                    find bem_pat no-lock
                         where bem_pat.cod_empresa      = v_cod_empresa
                         and   bem_pat.cod_cta_pat      = tt_criacao_bem_pat_api_6.tta_cod_cta_pat
                         and   bem_pat.num_bem_pat      = tt_criacao_bem_pat_api_6.tta_num_bem_pat
                         and   bem_pat.num_seq_bem_pat  = tt_criacao_bem_pat_api_6.tta_num_seq_bem_pat
                  no-error.
                  if avail bem_pat then do:
                       create tt_erros_criacao_bem_pat_api_1.
                       assign tt_erros_criacao_bem_pat_api_1.tta_cod_unid_organ_ext   = tt_criacao_bem_pat_api_6.tta_cod_unid_organ_ext
                             tt_erros_criacao_bem_pat_api_1.tta_cod_cta_pat          = tt_criacao_bem_pat_api_6.tta_cod_cta_pat
                             tt_erros_criacao_bem_pat_api_1.tta_num_bem_pat          = tt_criacao_bem_pat_api_6.tta_num_bem_pat
                             tt_erros_criacao_bem_pat_api_1.tta_num_seq_bem_pat      = tt_criacao_bem_pat_api_6.tta_num_seq_bem_pat
                             tt_erros_criacao_bem_pat_api_1.tta_des_bem_pat          = tt_criacao_bem_pat_api_6.tta_des_bem_pat
                             tt_erros_criacao_bem_pat_api_1.tta_dat_aquis_bem_pat    = tt_criacao_bem_pat_api_6.tta_dat_aquis_bem_pat
                             tt_erros_criacao_bem_pat_api_1.tta_cod_finalid_econ_ext = tt_criacao_bem_pat_api_6.tta_cod_finalid_econ_ext
                             .
                      assign tt_erros_criacao_bem_pat_api_1.ttv_des_mensagem         = substitute(getStrTrans("O bem &1 j† existe para &2.", "FAS") /*19685*/, string(tt_criacao_bem_pat_api_6.tta_num_bem_pat),getStrTrans("Conta", "FAS") /*l_conta*/ ).
                  end.
              end.
          end.
    end.    


    if  length(tt_criacao_bem_pat_api_6.tta_des_bem_pat) > 40
    then do:

        /* Begin_Include: i_erros_api_criacao_bem_pat */
        create tt_erros_criacao_bem_pat_api_1.
        assign tt_erros_criacao_bem_pat_api_1.tta_cod_unid_organ_ext   = tt_criacao_bem_pat_api_6.tta_cod_unid_organ_ext
               tt_erros_criacao_bem_pat_api_1.tta_cod_cta_pat          = tt_criacao_bem_pat_api_6.tta_cod_cta_pat
               tt_erros_criacao_bem_pat_api_1.tta_num_bem_pat          = tt_criacao_bem_pat_api_6.tta_num_bem_pat
               tt_erros_criacao_bem_pat_api_1.tta_num_seq_bem_pat      = tt_criacao_bem_pat_api_6.tta_num_seq_bem_pat
               tt_erros_criacao_bem_pat_api_1.tta_des_bem_pat          = tt_criacao_bem_pat_api_6.tta_des_bem_pat
               tt_erros_criacao_bem_pat_api_1.tta_dat_aquis_bem_pat    = tt_criacao_bem_pat_api_6.tta_dat_aquis_bem_pat
               tt_erros_criacao_bem_pat_api_1.tta_cod_finalid_econ_ext = tt_criacao_bem_pat_api_6.tta_cod_finalid_econ_ext.

        /* End_Include: i_erros_api_criacao_bem_pat */

        assign tt_erros_criacao_bem_pat_api_1.ttv_des_mensagem = getStrTrans("Descriá∆o do bem n∆o pode ultrapassar 40 posiá‰es.", "FAS") /*18657*/.
        return "NOK" /*l_nok*/ .
    end /* if */.


    /* VALIDA CENARIOS */
    if  v_log_funcao_congel_cenar_ctbl = yes
    then do:

            FOR EACH tt_bem_pat_cong:
                DELETE tt_bem_pat_cong.
            END.

        CREATE tt_bem_pat_cong.
        ASSIGN tt_bem_pat_cong.tta_cod_cta_pat = tt_criacao_bem_pat_api_6.tta_cod_cta_pat
               tt_bem_pat_cong.ttv_dat_movto = tt_criacao_bem_pat_api_6.tta_dat_aquis_bem_pat
               tt_bem_pat_cong.ttv_ind_tip_param = "C" /*l_letra_C*/ .
    end /* if */.

    if  search("prgfin/fgl/fgl721za.r") = ? and search("prgfin/fgl/fgl721za.py") = ? then do:
        if  v_cod_dwb_user begins 'es_' then
            return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgfin/fgl/fgl721za.py".
        else do:
            message getStrTrans("Programa execut†vel n∆o foi encontrado:", "FAS") /*l_programa_nao_encontrado*/  "prgfin/fgl/fgl721za.py"
                   view-as alert-box error buttons ok.
            return.
        end.
    end.
    else
        run prgfin/fgl/fgl721za.py (Input table tt_bem_pat_cong,
                                Input v_cod_empresa,
                                Input "FAS" /*l_fas*/,
                                Input tt_criacao_bem_pat_api_6.tta_dat_aquis_bem_pat,
                                output v_cod_return,
                                output table tt_erros_cenario) /*prg_fnc_consiste_cenar_ctbl*/.
    if v_cod_return <> "" and not can-do(v_cod_return,"Habilitado" /*l_habilitado*/ ) then do:

        /* Begin_Include: i_erros_api_criacao_bem_pat */
        create tt_erros_criacao_bem_pat_api_1.
        assign tt_erros_criacao_bem_pat_api_1.tta_cod_unid_organ_ext   = tt_criacao_bem_pat_api_6.tta_cod_unid_organ_ext
               tt_erros_criacao_bem_pat_api_1.tta_cod_cta_pat          = tt_criacao_bem_pat_api_6.tta_cod_cta_pat
               tt_erros_criacao_bem_pat_api_1.tta_num_bem_pat          = tt_criacao_bem_pat_api_6.tta_num_bem_pat
               tt_erros_criacao_bem_pat_api_1.tta_num_seq_bem_pat      = tt_criacao_bem_pat_api_6.tta_num_seq_bem_pat
               tt_erros_criacao_bem_pat_api_1.tta_des_bem_pat          = tt_criacao_bem_pat_api_6.tta_des_bem_pat
               tt_erros_criacao_bem_pat_api_1.tta_dat_aquis_bem_pat    = tt_criacao_bem_pat_api_6.tta_dat_aquis_bem_pat
               tt_erros_criacao_bem_pat_api_1.tta_cod_finalid_econ_ext = tt_criacao_bem_pat_api_6.tta_cod_finalid_econ_ext.

        /* End_Include: i_erros_api_criacao_bem_pat */

        assign tt_erros_criacao_bem_pat_api_1.ttv_des_mensagem = substitute(getStrTrans("Data &1 est† em um per°odo n∆o habilitado !", "FAS") /*327*/, tt_criacao_bem_pat_api_6.tta_dat_aquis_bem_pat).
        return "NOK" /*l_nok*/ .
    end.
    else do:
        /* Exibe erros em tela */
        if can-find(first tt_erros_cenario) then do:
            find first tt_erros_cenario no-error.

            /* Begin_Include: i_erros_api_criacao_bem_pat */
            create tt_erros_criacao_bem_pat_api_1.
            assign tt_erros_criacao_bem_pat_api_1.tta_cod_unid_organ_ext   = tt_criacao_bem_pat_api_6.tta_cod_unid_organ_ext
                   tt_erros_criacao_bem_pat_api_1.tta_cod_cta_pat          = tt_criacao_bem_pat_api_6.tta_cod_cta_pat
                   tt_erros_criacao_bem_pat_api_1.tta_num_bem_pat          = tt_criacao_bem_pat_api_6.tta_num_bem_pat
                   tt_erros_criacao_bem_pat_api_1.tta_num_seq_bem_pat      = tt_criacao_bem_pat_api_6.tta_num_seq_bem_pat
                   tt_erros_criacao_bem_pat_api_1.tta_des_bem_pat          = tt_criacao_bem_pat_api_6.tta_des_bem_pat
                   tt_erros_criacao_bem_pat_api_1.tta_dat_aquis_bem_pat    = tt_criacao_bem_pat_api_6.tta_dat_aquis_bem_pat
                   tt_erros_criacao_bem_pat_api_1.tta_cod_finalid_econ_ext = tt_criacao_bem_pat_api_6.tta_cod_finalid_econ_ext.

            /* End_Include: i_erros_api_criacao_bem_pat */

            assign tt_erros_criacao_bem_pat_api_1.ttv_des_mensagem = substitute(getStrTrans("Data &1 est† em um per°odo desabilitado para o cen†rio &2 no m¢dulo &3.", "FAS") /*11992*/,
                                                                   tt_erros_cenario.ttv_dat_refer_sit,
                                                                   tt_erros_cenario.tta_cod_cenar_ctbl,
                                                                   tt_erros_cenario.tta_cod_modul_dtsul).
            return "NOK" /*l_nok*/ .
        end.
    end.

    run pi_validar_estab (Input v_cod_empresa,
                          Input v_cod_estab,
                          Input tt_criacao_bem_pat_api_6.tta_dat_aquis_bem_pat,
                          output v_cod_return) /*pi_validar_estab*/.
    /* case_block: */
    case v_cod_return:
        when "Unidade Organizacional" /*l_unid_organ*/ then
            code_block:
            do:

                /* Begin_Include: i_erros_api_criacao_bem_pat */
                create tt_erros_criacao_bem_pat_api_1.
                assign tt_erros_criacao_bem_pat_api_1.tta_cod_unid_organ_ext   = tt_criacao_bem_pat_api_6.tta_cod_unid_organ_ext
                       tt_erros_criacao_bem_pat_api_1.tta_cod_cta_pat          = tt_criacao_bem_pat_api_6.tta_cod_cta_pat
                       tt_erros_criacao_bem_pat_api_1.tta_num_bem_pat          = tt_criacao_bem_pat_api_6.tta_num_bem_pat
                       tt_erros_criacao_bem_pat_api_1.tta_num_seq_bem_pat      = tt_criacao_bem_pat_api_6.tta_num_seq_bem_pat
                       tt_erros_criacao_bem_pat_api_1.tta_des_bem_pat          = tt_criacao_bem_pat_api_6.tta_des_bem_pat
                       tt_erros_criacao_bem_pat_api_1.tta_dat_aquis_bem_pat    = tt_criacao_bem_pat_api_6.tta_dat_aquis_bem_pat
                       tt_erros_criacao_bem_pat_api_1.tta_cod_finalid_econ_ext = tt_criacao_bem_pat_api_6.tta_cod_finalid_econ_ext.

                /* End_Include: i_erros_api_criacao_bem_pat */

                assign tt_erros_criacao_bem_pat_api_1.ttv_des_mensagem = getStrTrans("Estabelecimento n∆o habilitado como Unidade Organizacional !", "FAS") /*347*/.
                return "NOK" /*l_nok*/ .
            end /* do code_block */.
        when "Usu†rio" /*l_usuario*/ then
            code_block:
            do:

                /* Begin_Include: i_erros_api_criacao_bem_pat */
                create tt_erros_criacao_bem_pat_api_1.
                assign tt_erros_criacao_bem_pat_api_1.tta_cod_unid_organ_ext   = tt_criacao_bem_pat_api_6.tta_cod_unid_organ_ext
                       tt_erros_criacao_bem_pat_api_1.tta_cod_cta_pat          = tt_criacao_bem_pat_api_6.tta_cod_cta_pat
                       tt_erros_criacao_bem_pat_api_1.tta_num_bem_pat          = tt_criacao_bem_pat_api_6.tta_num_bem_pat
                       tt_erros_criacao_bem_pat_api_1.tta_num_seq_bem_pat      = tt_criacao_bem_pat_api_6.tta_num_seq_bem_pat
                       tt_erros_criacao_bem_pat_api_1.tta_des_bem_pat          = tt_criacao_bem_pat_api_6.tta_des_bem_pat
                       tt_erros_criacao_bem_pat_api_1.tta_dat_aquis_bem_pat    = tt_criacao_bem_pat_api_6.tta_dat_aquis_bem_pat
                       tt_erros_criacao_bem_pat_api_1.tta_cod_finalid_econ_ext = tt_criacao_bem_pat_api_6.tta_cod_finalid_econ_ext.

                /* End_Include: i_erros_api_criacao_bem_pat */

                assign tt_erros_criacao_bem_pat_api_1.ttv_des_mensagem = getStrTrans("Usu†rio sem permiss∆o para acessar o estabelecimento &1 !", "FAS") /*348*/.
                return "NOK" /*l_nok*/ .
        end /* do code_block */.
        when "Empresa" /*l_empresa*/ then
            code_block:
            do:

                /* Begin_Include: i_erros_api_criacao_bem_pat */
                create tt_erros_criacao_bem_pat_api_1.
                assign tt_erros_criacao_bem_pat_api_1.tta_cod_unid_organ_ext   = tt_criacao_bem_pat_api_6.tta_cod_unid_organ_ext
                       tt_erros_criacao_bem_pat_api_1.tta_cod_cta_pat          = tt_criacao_bem_pat_api_6.tta_cod_cta_pat
                       tt_erros_criacao_bem_pat_api_1.tta_num_bem_pat          = tt_criacao_bem_pat_api_6.tta_num_bem_pat
                       tt_erros_criacao_bem_pat_api_1.tta_num_seq_bem_pat      = tt_criacao_bem_pat_api_6.tta_num_seq_bem_pat
                       tt_erros_criacao_bem_pat_api_1.tta_des_bem_pat          = tt_criacao_bem_pat_api_6.tta_des_bem_pat
                       tt_erros_criacao_bem_pat_api_1.tta_dat_aquis_bem_pat    = tt_criacao_bem_pat_api_6.tta_dat_aquis_bem_pat
                       tt_erros_criacao_bem_pat_api_1.tta_cod_finalid_econ_ext = tt_criacao_bem_pat_api_6.tta_cod_finalid_econ_ext.

                /* End_Include: i_erros_api_criacao_bem_pat */

                assign tt_erros_criacao_bem_pat_api_1.ttv_des_mensagem = getStrTrans("Empresa do Estabelecimento Diferente da Empresa do Usu†rio !", "FAS") /*512*/.
                return "NOK" /*l_nok*/ .
            end /* do code_block */.
    end /* case case_block */.

    run pi_verifica_utiliz_funcao (Input 'BU',
                                   Input v_cod_empresa,
                                   output v_log_return) /*pi_verifica_utiliz_funcao*/.
    if  v_log_return = yes
    then do:
        run pi_validar_unid_negoc (Input v_cod_estab,
                                   Input tt_criacao_bem_pat_api_6.tta_cod_unid_negoc,
                                   Input tt_criacao_bem_pat_api_6.tta_dat_aquis_bem_pat,
                                   output v_cod_return) /*pi_validar_unid_negoc*/.
        /* case_block: */
        case v_cod_return:
            when "Estabelecimento" /*l_estabelecimento*/ then
                code_block:
                do:

                    /* Begin_Include: i_erros_api_criacao_bem_pat */
                    create tt_erros_criacao_bem_pat_api_1.
                    assign tt_erros_criacao_bem_pat_api_1.tta_cod_unid_organ_ext   = tt_criacao_bem_pat_api_6.tta_cod_unid_organ_ext
                           tt_erros_criacao_bem_pat_api_1.tta_cod_cta_pat          = tt_criacao_bem_pat_api_6.tta_cod_cta_pat
                           tt_erros_criacao_bem_pat_api_1.tta_num_bem_pat          = tt_criacao_bem_pat_api_6.tta_num_bem_pat
                           tt_erros_criacao_bem_pat_api_1.tta_num_seq_bem_pat      = tt_criacao_bem_pat_api_6.tta_num_seq_bem_pat
                           tt_erros_criacao_bem_pat_api_1.tta_des_bem_pat          = tt_criacao_bem_pat_api_6.tta_des_bem_pat
                           tt_erros_criacao_bem_pat_api_1.tta_dat_aquis_bem_pat    = tt_criacao_bem_pat_api_6.tta_dat_aquis_bem_pat
                           tt_erros_criacao_bem_pat_api_1.tta_cod_finalid_econ_ext = tt_criacao_bem_pat_api_6.tta_cod_finalid_econ_ext.

                    /* End_Include: i_erros_api_criacao_bem_pat */

                    assign tt_erros_criacao_bem_pat_api_1.ttv_des_mensagem = substitute(getStrTrans("Unidade de Neg¢cio &2 n∆o est† relacionada ao Estab:  &1 !", "FAS") /*684*/, v_cod_estab).
                    return "NOK" /*l_nok*/ .
                end /* do code_block */.
            when "Data" /*l_data*/ then
                code_block:
                do:

                    /* Begin_Include: i_erros_api_criacao_bem_pat */
                    create tt_erros_criacao_bem_pat_api_1.
                    assign tt_erros_criacao_bem_pat_api_1.tta_cod_unid_organ_ext   = tt_criacao_bem_pat_api_6.tta_cod_unid_organ_ext
                           tt_erros_criacao_bem_pat_api_1.tta_cod_cta_pat          = tt_criacao_bem_pat_api_6.tta_cod_cta_pat
                           tt_erros_criacao_bem_pat_api_1.tta_num_bem_pat          = tt_criacao_bem_pat_api_6.tta_num_bem_pat
                           tt_erros_criacao_bem_pat_api_1.tta_num_seq_bem_pat      = tt_criacao_bem_pat_api_6.tta_num_seq_bem_pat
                           tt_erros_criacao_bem_pat_api_1.tta_des_bem_pat          = tt_criacao_bem_pat_api_6.tta_des_bem_pat
                           tt_erros_criacao_bem_pat_api_1.tta_dat_aquis_bem_pat    = tt_criacao_bem_pat_api_6.tta_dat_aquis_bem_pat
                           tt_erros_criacao_bem_pat_api_1.tta_cod_finalid_econ_ext = tt_criacao_bem_pat_api_6.tta_cod_finalid_econ_ext.

                    /* End_Include: i_erros_api_criacao_bem_pat */

                    assign tt_erros_criacao_bem_pat_api_1.ttv_des_mensagem = getStrTrans("Unidade Neg¢cio &1 fora de validade !", "FAS") /*617*/.
                    return "NOK" /*l_nok*/ .
                end /* do code_block */.
            when "Usu†rio" /*l_usuario*/ then
                code_block:
                do:

                    /* Begin_Include: i_erros_api_criacao_bem_pat */
                    create tt_erros_criacao_bem_pat_api_1.
                    assign tt_erros_criacao_bem_pat_api_1.tta_cod_unid_organ_ext   = tt_criacao_bem_pat_api_6.tta_cod_unid_organ_ext
                           tt_erros_criacao_bem_pat_api_1.tta_cod_cta_pat          = tt_criacao_bem_pat_api_6.tta_cod_cta_pat
                           tt_erros_criacao_bem_pat_api_1.tta_num_bem_pat          = tt_criacao_bem_pat_api_6.tta_num_bem_pat
                           tt_erros_criacao_bem_pat_api_1.tta_num_seq_bem_pat      = tt_criacao_bem_pat_api_6.tta_num_seq_bem_pat
                           tt_erros_criacao_bem_pat_api_1.tta_des_bem_pat          = tt_criacao_bem_pat_api_6.tta_des_bem_pat
                           tt_erros_criacao_bem_pat_api_1.tta_dat_aquis_bem_pat    = tt_criacao_bem_pat_api_6.tta_dat_aquis_bem_pat
                           tt_erros_criacao_bem_pat_api_1.tta_cod_finalid_econ_ext = tt_criacao_bem_pat_api_6.tta_cod_finalid_econ_ext.

                    /* End_Include: i_erros_api_criacao_bem_pat */

                    assign tt_erros_criacao_bem_pat_api_1.ttv_des_mensagem = getStrTrans("Usu†rio sem permiss∆o para acessar a Unidade de Neg¢cio &1 !", "FAS") /*683*/.
                    return "NOK" /*l_nok*/ .
                end /* do code_block */.
        end /* case case_block */.
        find unid_negoc
            where unid_negoc.cod_unid_negoc = tt_criacao_bem_pat_api_6.tta_cod_unid_negoc
            no-lock no-error.
        run pi_verifica_segur_unid_negoc (Input unid_negoc.cod_unid_negoc,
                                          output v_log_return) /*pi_verifica_segur_unid_negoc*/.
        if  v_log_return = no
        then do:

            /* Begin_Include: i_erros_api_criacao_bem_pat */
            create tt_erros_criacao_bem_pat_api_1.
            assign tt_erros_criacao_bem_pat_api_1.tta_cod_unid_organ_ext   = tt_criacao_bem_pat_api_6.tta_cod_unid_organ_ext
                   tt_erros_criacao_bem_pat_api_1.tta_cod_cta_pat          = tt_criacao_bem_pat_api_6.tta_cod_cta_pat
                   tt_erros_criacao_bem_pat_api_1.tta_num_bem_pat          = tt_criacao_bem_pat_api_6.tta_num_bem_pat
                   tt_erros_criacao_bem_pat_api_1.tta_num_seq_bem_pat      = tt_criacao_bem_pat_api_6.tta_num_seq_bem_pat
                   tt_erros_criacao_bem_pat_api_1.tta_des_bem_pat          = tt_criacao_bem_pat_api_6.tta_des_bem_pat
                   tt_erros_criacao_bem_pat_api_1.tta_dat_aquis_bem_pat    = tt_criacao_bem_pat_api_6.tta_dat_aquis_bem_pat
                   tt_erros_criacao_bem_pat_api_1.tta_cod_finalid_econ_ext = tt_criacao_bem_pat_api_6.tta_cod_finalid_econ_ext.

            /* End_Include: i_erros_api_criacao_bem_pat */

            assign tt_erros_criacao_bem_pat_api_1.ttv_des_mensagem = substitute(getStrTrans("Usu†rio sem permiss∆o de acesso a Unid Negoc: &1 !", "FAS") /*1966*/, unid_negoc.cod_unid_negoc).
            return "NOK" /*l_nok*/ .
        end /* if */.
    end /* if */.
    run pi_validar_plano_ccusto (Input v_cod_empresa,
                                 Input tt_criacao_bem_pat_api_6.tta_cod_plano_ccusto,
                                 Input tt_criacao_bem_pat_api_6.tta_dat_aquis_bem_pat,
                                 output v_log_return) /*pi_validar_plano_ccusto*/.
    if  v_log_return = no
    then do:

        /* Begin_Include: i_erros_api_criacao_bem_pat */
        create tt_erros_criacao_bem_pat_api_1.
        assign tt_erros_criacao_bem_pat_api_1.tta_cod_unid_organ_ext   = tt_criacao_bem_pat_api_6.tta_cod_unid_organ_ext
               tt_erros_criacao_bem_pat_api_1.tta_cod_cta_pat          = tt_criacao_bem_pat_api_6.tta_cod_cta_pat
               tt_erros_criacao_bem_pat_api_1.tta_num_bem_pat          = tt_criacao_bem_pat_api_6.tta_num_bem_pat
               tt_erros_criacao_bem_pat_api_1.tta_num_seq_bem_pat      = tt_criacao_bem_pat_api_6.tta_num_seq_bem_pat
               tt_erros_criacao_bem_pat_api_1.tta_des_bem_pat          = tt_criacao_bem_pat_api_6.tta_des_bem_pat
               tt_erros_criacao_bem_pat_api_1.tta_dat_aquis_bem_pat    = tt_criacao_bem_pat_api_6.tta_dat_aquis_bem_pat
               tt_erros_criacao_bem_pat_api_1.tta_cod_finalid_econ_ext = tt_criacao_bem_pat_api_6.tta_cod_finalid_econ_ext.

        /* End_Include: i_erros_api_criacao_bem_pat */

        assign tt_erros_criacao_bem_pat_api_1.ttv_des_mensagem = getStrTrans("Plano Centro de Custo inexistente !", "FAS") /*238*/.
        return "NOK" /*l_nok*/ .
    end /* if */.

    run pi_validar_ccusto (Input v_cod_empresa,
                           Input tt_criacao_bem_pat_api_6.tta_cod_plano_ccusto,
                           Input tt_criacao_bem_pat_api_6.tta_cod_ccusto,
                           Input tt_criacao_bem_pat_api_6.tta_dat_aquis_bem_pat,
                           Input tt_criacao_bem_pat_api_6.tta_dat_aquis_bem_pat,
                           output v_log_return) /*pi_validar_ccusto*/.
    if  v_log_return = no
    then do:

        /* Begin_Include: i_erros_api_criacao_bem_pat */
        create tt_erros_criacao_bem_pat_api_1.
        assign tt_erros_criacao_bem_pat_api_1.tta_cod_unid_organ_ext   = tt_criacao_bem_pat_api_6.tta_cod_unid_organ_ext
               tt_erros_criacao_bem_pat_api_1.tta_cod_cta_pat          = tt_criacao_bem_pat_api_6.tta_cod_cta_pat
               tt_erros_criacao_bem_pat_api_1.tta_num_bem_pat          = tt_criacao_bem_pat_api_6.tta_num_bem_pat
               tt_erros_criacao_bem_pat_api_1.tta_num_seq_bem_pat      = tt_criacao_bem_pat_api_6.tta_num_seq_bem_pat
               tt_erros_criacao_bem_pat_api_1.tta_des_bem_pat          = tt_criacao_bem_pat_api_6.tta_des_bem_pat
               tt_erros_criacao_bem_pat_api_1.tta_dat_aquis_bem_pat    = tt_criacao_bem_pat_api_6.tta_dat_aquis_bem_pat
               tt_erros_criacao_bem_pat_api_1.tta_cod_finalid_econ_ext = tt_criacao_bem_pat_api_6.tta_cod_finalid_econ_ext.

        /* End_Include: i_erros_api_criacao_bem_pat */

        assign tt_erros_criacao_bem_pat_api_1.ttv_des_mensagem = getStrTrans("Centro de Custo Respons inv†lido na data do movimento !", "FAS") /*870*/.
        return "NOK" /*l_nok*/ .
    end /* if */.

    run pi_verifica_segur_ccusto (buffer ccusto,
                                  output v_log_return) /*pi_verifica_segur_ccusto*/.
    if  v_log_return = no
    then do:

        /* Begin_Include: i_erros_api_criacao_bem_pat */
        create tt_erros_criacao_bem_pat_api_1.
        assign tt_erros_criacao_bem_pat_api_1.tta_cod_unid_organ_ext   = tt_criacao_bem_pat_api_6.tta_cod_unid_organ_ext
               tt_erros_criacao_bem_pat_api_1.tta_cod_cta_pat          = tt_criacao_bem_pat_api_6.tta_cod_cta_pat
               tt_erros_criacao_bem_pat_api_1.tta_num_bem_pat          = tt_criacao_bem_pat_api_6.tta_num_bem_pat
               tt_erros_criacao_bem_pat_api_1.tta_num_seq_bem_pat      = tt_criacao_bem_pat_api_6.tta_num_seq_bem_pat
               tt_erros_criacao_bem_pat_api_1.tta_des_bem_pat          = tt_criacao_bem_pat_api_6.tta_des_bem_pat
               tt_erros_criacao_bem_pat_api_1.tta_dat_aquis_bem_pat    = tt_criacao_bem_pat_api_6.tta_dat_aquis_bem_pat
               tt_erros_criacao_bem_pat_api_1.tta_cod_finalid_econ_ext = tt_criacao_bem_pat_api_6.tta_cod_finalid_econ_ext.

        /* End_Include: i_erros_api_criacao_bem_pat */

        assign tt_erros_criacao_bem_pat_api_1.ttv_des_mensagem = substitute(getStrTrans("Usu†rio sem permiss∆o para acessar o centro de custo !", "FAS") /*1926*/, tt_criacao_bem_pat_api_6.tta_cod_ccusto).
        return "NOK" /*l_nok*/ .
    end /* if */.

    run pi_validar_ccusto_unid_negoc_estab (Input v_cod_empresa,
                                            Input tt_criacao_bem_pat_api_6.tta_cod_plano_ccusto,
                                            Input tt_criacao_bem_pat_api_6.tta_cod_ccusto,
                                            Input tt_criacao_bem_pat_api_6.tta_cod_unid_negoc,
                                            Input v_cod_estab,
                                            output v_num_mensagem) /*pi_validar_ccusto_unid_negoc_estab*/.
    /* blk_case: */
    case v_num_mensagem:
        when 950 then
            code_block:
            do:

                /* Begin_Include: i_erros_api_criacao_bem_pat */
                create tt_erros_criacao_bem_pat_api_1.
                assign tt_erros_criacao_bem_pat_api_1.tta_cod_unid_organ_ext   = tt_criacao_bem_pat_api_6.tta_cod_unid_organ_ext
                       tt_erros_criacao_bem_pat_api_1.tta_cod_cta_pat          = tt_criacao_bem_pat_api_6.tta_cod_cta_pat
                       tt_erros_criacao_bem_pat_api_1.tta_num_bem_pat          = tt_criacao_bem_pat_api_6.tta_num_bem_pat
                       tt_erros_criacao_bem_pat_api_1.tta_num_seq_bem_pat      = tt_criacao_bem_pat_api_6.tta_num_seq_bem_pat
                       tt_erros_criacao_bem_pat_api_1.tta_des_bem_pat          = tt_criacao_bem_pat_api_6.tta_des_bem_pat
                       tt_erros_criacao_bem_pat_api_1.tta_dat_aquis_bem_pat    = tt_criacao_bem_pat_api_6.tta_dat_aquis_bem_pat
                       tt_erros_criacao_bem_pat_api_1.tta_cod_finalid_econ_ext = tt_criacao_bem_pat_api_6.tta_cod_finalid_econ_ext.

                /* End_Include: i_erros_api_criacao_bem_pat */

                assign tt_erros_criacao_bem_pat_api_1.ttv_des_mensagem = substitute(getStrTrans("Unidade Neg¢cio &1 n∆o encontrada para Estabelecimento &2 !", "FAS") /*950*/,
                                                                       tt_criacao_bem_pat_api_6.tta_cod_unid_negoc,
                                                                       v_cod_estab).
                return "NOK" /*l_nok*/ .
            end /* do code_block */.
        when 1253 then
            code_block:
            do:

                /* Begin_Include: i_erros_api_criacao_bem_pat */
                create tt_erros_criacao_bem_pat_api_1.
                assign tt_erros_criacao_bem_pat_api_1.tta_cod_unid_organ_ext   = tt_criacao_bem_pat_api_6.tta_cod_unid_organ_ext
                       tt_erros_criacao_bem_pat_api_1.tta_cod_cta_pat          = tt_criacao_bem_pat_api_6.tta_cod_cta_pat
                       tt_erros_criacao_bem_pat_api_1.tta_num_bem_pat          = tt_criacao_bem_pat_api_6.tta_num_bem_pat
                       tt_erros_criacao_bem_pat_api_1.tta_num_seq_bem_pat      = tt_criacao_bem_pat_api_6.tta_num_seq_bem_pat
                       tt_erros_criacao_bem_pat_api_1.tta_des_bem_pat          = tt_criacao_bem_pat_api_6.tta_des_bem_pat
                       tt_erros_criacao_bem_pat_api_1.tta_dat_aquis_bem_pat    = tt_criacao_bem_pat_api_6.tta_dat_aquis_bem_pat
                       tt_erros_criacao_bem_pat_api_1.tta_cod_finalid_econ_ext = tt_criacao_bem_pat_api_6.tta_cod_finalid_econ_ext.

                /* End_Include: i_erros_api_criacao_bem_pat */

                assign tt_erros_criacao_bem_pat_api_1.ttv_des_mensagem = getStrTrans("Centro Custo &1 Inv†lido para a Unidade Neg¢cio &2 !", "FAS") /*1253*/.
                return "NOK" /*l_nok*/ .
            end /* do code_block */.
        when 1388 then
            code_block:
            do:

                /* Begin_Include: i_erros_api_criacao_bem_pat */
                create tt_erros_criacao_bem_pat_api_1.
                assign tt_erros_criacao_bem_pat_api_1.tta_cod_unid_organ_ext   = tt_criacao_bem_pat_api_6.tta_cod_unid_organ_ext
                       tt_erros_criacao_bem_pat_api_1.tta_cod_cta_pat          = tt_criacao_bem_pat_api_6.tta_cod_cta_pat
                       tt_erros_criacao_bem_pat_api_1.tta_num_bem_pat          = tt_criacao_bem_pat_api_6.tta_num_bem_pat
                       tt_erros_criacao_bem_pat_api_1.tta_num_seq_bem_pat      = tt_criacao_bem_pat_api_6.tta_num_seq_bem_pat
                       tt_erros_criacao_bem_pat_api_1.tta_des_bem_pat          = tt_criacao_bem_pat_api_6.tta_des_bem_pat
                       tt_erros_criacao_bem_pat_api_1.tta_dat_aquis_bem_pat    = tt_criacao_bem_pat_api_6.tta_dat_aquis_bem_pat
                       tt_erros_criacao_bem_pat_api_1.tta_cod_finalid_econ_ext = tt_criacao_bem_pat_api_6.tta_cod_finalid_econ_ext.

                /* End_Include: i_erros_api_criacao_bem_pat */

                assign tt_erros_criacao_bem_pat_api_1.ttv_des_mensagem = substitute(getStrTrans("Existe restriá∆o deste ccusto no estabelecimento: &1 !", "FAS") /*1388*/, v_cod_estab).
                return "NOK" /*l_nok*/ .
            end /* do code_block */.
    end /* case blk_case */.

    run pi_validar_indic_econ_movto (Input v_cod_indic_econ,
                                     Input tt_criacao_bem_pat_api_6.tta_dat_aquis_bem_pat,
                                     Input v_cod_empresa,
                                     output v_cod_return) /*pi_validar_indic_econ_movto*/.
    /* case_block: */
    case entry(1, v_cod_return):
        when "241" then
            code_block:
            do:

                /* Begin_Include: i_erros_api_criacao_bem_pat */
                create tt_erros_criacao_bem_pat_api_1.
                assign tt_erros_criacao_bem_pat_api_1.tta_cod_unid_organ_ext   = tt_criacao_bem_pat_api_6.tta_cod_unid_organ_ext
                       tt_erros_criacao_bem_pat_api_1.tta_cod_cta_pat          = tt_criacao_bem_pat_api_6.tta_cod_cta_pat
                       tt_erros_criacao_bem_pat_api_1.tta_num_bem_pat          = tt_criacao_bem_pat_api_6.tta_num_bem_pat
                       tt_erros_criacao_bem_pat_api_1.tta_num_seq_bem_pat      = tt_criacao_bem_pat_api_6.tta_num_seq_bem_pat
                       tt_erros_criacao_bem_pat_api_1.tta_des_bem_pat          = tt_criacao_bem_pat_api_6.tta_des_bem_pat
                       tt_erros_criacao_bem_pat_api_1.tta_dat_aquis_bem_pat    = tt_criacao_bem_pat_api_6.tta_dat_aquis_bem_pat
                       tt_erros_criacao_bem_pat_api_1.tta_cod_finalid_econ_ext = tt_criacao_bem_pat_api_6.tta_cod_finalid_econ_ext.

                /* End_Include: i_erros_api_criacao_bem_pat */

                assign tt_erros_criacao_bem_pat_api_1.ttv_des_mensagem = getStrTrans("Indicador Econìmico Inexistente !", "FAS") /*241*/.
                return "NOK" /*l_nok*/ .
            end /* do code_block */.
        when "1199" then
            code_block:
            do:

                /* Begin_Include: i_erros_api_criacao_bem_pat */
                create tt_erros_criacao_bem_pat_api_1.
                assign tt_erros_criacao_bem_pat_api_1.tta_cod_unid_organ_ext   = tt_criacao_bem_pat_api_6.tta_cod_unid_organ_ext
                       tt_erros_criacao_bem_pat_api_1.tta_cod_cta_pat          = tt_criacao_bem_pat_api_6.tta_cod_cta_pat
                       tt_erros_criacao_bem_pat_api_1.tta_num_bem_pat          = tt_criacao_bem_pat_api_6.tta_num_bem_pat
                       tt_erros_criacao_bem_pat_api_1.tta_num_seq_bem_pat      = tt_criacao_bem_pat_api_6.tta_num_seq_bem_pat
                       tt_erros_criacao_bem_pat_api_1.tta_des_bem_pat          = tt_criacao_bem_pat_api_6.tta_des_bem_pat
                       tt_erros_criacao_bem_pat_api_1.tta_dat_aquis_bem_pat    = tt_criacao_bem_pat_api_6.tta_dat_aquis_bem_pat
                       tt_erros_criacao_bem_pat_api_1.tta_cod_finalid_econ_ext = tt_criacao_bem_pat_api_6.tta_cod_finalid_econ_ext.

                /* End_Include: i_erros_api_criacao_bem_pat */

                assign tt_erros_criacao_bem_pat_api_1.ttv_des_mensagem = getStrTrans("Indicador Econìmico n∆o habilitado na Data da Transaá∆o !", "FAS") /*1199*/.
                return "NOK" /*l_nok*/ .
            end /* do code_block */.
        when "336" then
            code_block:
            do:

                /* Begin_Include: i_erros_api_criacao_bem_pat */
                create tt_erros_criacao_bem_pat_api_1.
                assign tt_erros_criacao_bem_pat_api_1.tta_cod_unid_organ_ext   = tt_criacao_bem_pat_api_6.tta_cod_unid_organ_ext
                       tt_erros_criacao_bem_pat_api_1.tta_cod_cta_pat          = tt_criacao_bem_pat_api_6.tta_cod_cta_pat
                       tt_erros_criacao_bem_pat_api_1.tta_num_bem_pat          = tt_criacao_bem_pat_api_6.tta_num_bem_pat
                       tt_erros_criacao_bem_pat_api_1.tta_num_seq_bem_pat      = tt_criacao_bem_pat_api_6.tta_num_seq_bem_pat
                       tt_erros_criacao_bem_pat_api_1.tta_des_bem_pat          = tt_criacao_bem_pat_api_6.tta_des_bem_pat
                       tt_erros_criacao_bem_pat_api_1.tta_dat_aquis_bem_pat    = tt_criacao_bem_pat_api_6.tta_dat_aquis_bem_pat
                       tt_erros_criacao_bem_pat_api_1.tta_cod_finalid_econ_ext = tt_criacao_bem_pat_api_6.tta_cod_finalid_econ_ext.

                /* End_Include: i_erros_api_criacao_bem_pat */

                assign tt_erros_criacao_bem_pat_api_1.ttv_des_mensagem = getStrTrans("Hist¢rico Finalidade inexistente para o indicador economico !", "FAS") /*336*/.
                return "NOK" /*l_nok*/ .
            end /* do code_block */.
        when "337" then
            code_block:
            do:

                /* Begin_Include: i_erros_api_criacao_bem_pat */
                create tt_erros_criacao_bem_pat_api_1.
                assign tt_erros_criacao_bem_pat_api_1.tta_cod_unid_organ_ext   = tt_criacao_bem_pat_api_6.tta_cod_unid_organ_ext
                       tt_erros_criacao_bem_pat_api_1.tta_cod_cta_pat          = tt_criacao_bem_pat_api_6.tta_cod_cta_pat
                       tt_erros_criacao_bem_pat_api_1.tta_num_bem_pat          = tt_criacao_bem_pat_api_6.tta_num_bem_pat
                       tt_erros_criacao_bem_pat_api_1.tta_num_seq_bem_pat      = tt_criacao_bem_pat_api_6.tta_num_seq_bem_pat
                       tt_erros_criacao_bem_pat_api_1.tta_des_bem_pat          = tt_criacao_bem_pat_api_6.tta_des_bem_pat
                       tt_erros_criacao_bem_pat_api_1.tta_dat_aquis_bem_pat    = tt_criacao_bem_pat_api_6.tta_dat_aquis_bem_pat
                       tt_erros_criacao_bem_pat_api_1.tta_cod_finalid_econ_ext = tt_criacao_bem_pat_api_6.tta_cod_finalid_econ_ext.

                /* End_Include: i_erros_api_criacao_bem_pat */

                assign tt_erros_criacao_bem_pat_api_1.ttv_des_mensagem = substitute(getStrTrans("Finalidade econìmica n∆o permite informar valores !", "FAS") /*337*/, entry(2,v_cod_return)).
                return "NOK" /*l_nok*/ .
            end /* do code_block */.
        when "338" then
            code_block:
            do:

                /* Begin_Include: i_erros_api_criacao_bem_pat */
                create tt_erros_criacao_bem_pat_api_1.
                assign tt_erros_criacao_bem_pat_api_1.tta_cod_unid_organ_ext   = tt_criacao_bem_pat_api_6.tta_cod_unid_organ_ext
                       tt_erros_criacao_bem_pat_api_1.tta_cod_cta_pat          = tt_criacao_bem_pat_api_6.tta_cod_cta_pat
                       tt_erros_criacao_bem_pat_api_1.tta_num_bem_pat          = tt_criacao_bem_pat_api_6.tta_num_bem_pat
                       tt_erros_criacao_bem_pat_api_1.tta_num_seq_bem_pat      = tt_criacao_bem_pat_api_6.tta_num_seq_bem_pat
                       tt_erros_criacao_bem_pat_api_1.tta_des_bem_pat          = tt_criacao_bem_pat_api_6.tta_des_bem_pat
                       tt_erros_criacao_bem_pat_api_1.tta_dat_aquis_bem_pat    = tt_criacao_bem_pat_api_6.tta_dat_aquis_bem_pat
                       tt_erros_criacao_bem_pat_api_1.tta_cod_finalid_econ_ext = tt_criacao_bem_pat_api_6.tta_cod_finalid_econ_ext.

                /* End_Include: i_erros_api_criacao_bem_pat */

                assign tt_erros_criacao_bem_pat_api_1.ttv_des_mensagem = getStrTrans("Finalidade n∆o liberada para a Unidade Organizacional !", "FAS") /*338*/.
                return "NOK" /*l_nok*/ .
            end /* do code_block */.
    end /* case case_block */.
    if  tt_criacao_bem_pat_api_6.tta_cdn_fornecedor <> 0
    then do:
        find fornecedor
            where fornecedor.cod_empresa = v_cod_empresa
            and   fornecedor.cdn_fornecedor = tt_criacao_bem_pat_api_6.tta_cdn_fornecedor
            no-lock no-error.
        if  not avail fornecedor
        then do:

            /* Begin_Include: i_erros_api_criacao_bem_pat */
            create tt_erros_criacao_bem_pat_api_1.
            assign tt_erros_criacao_bem_pat_api_1.tta_cod_unid_organ_ext   = tt_criacao_bem_pat_api_6.tta_cod_unid_organ_ext
                   tt_erros_criacao_bem_pat_api_1.tta_cod_cta_pat          = tt_criacao_bem_pat_api_6.tta_cod_cta_pat
                   tt_erros_criacao_bem_pat_api_1.tta_num_bem_pat          = tt_criacao_bem_pat_api_6.tta_num_bem_pat
                   tt_erros_criacao_bem_pat_api_1.tta_num_seq_bem_pat      = tt_criacao_bem_pat_api_6.tta_num_seq_bem_pat
                   tt_erros_criacao_bem_pat_api_1.tta_des_bem_pat          = tt_criacao_bem_pat_api_6.tta_des_bem_pat
                   tt_erros_criacao_bem_pat_api_1.tta_dat_aquis_bem_pat    = tt_criacao_bem_pat_api_6.tta_dat_aquis_bem_pat
                   tt_erros_criacao_bem_pat_api_1.tta_cod_finalid_econ_ext = tt_criacao_bem_pat_api_6.tta_cod_finalid_econ_ext.

            /* End_Include: i_erros_api_criacao_bem_pat */

            assign tt_erros_criacao_bem_pat_api_1.ttv_des_mensagem = substitute(getStrTrans("Fornecedor &1 inexistente !", "FAS") /*1735*/,
                                                                   string(tt_criacao_bem_pat_api_6.tta_cdn_fornecedor)).
            return "NOK" /*l_nok*/ .
        end /* if */.
    end /* if */.

    for each tt_criacao_bem_pat_item_api
       where tt_criacao_bem_pat_item_api.ttv_rec_bem = recid(tt_criacao_bem_pat_api_6):

        find first item_docto_entr no-lock
             where item_docto_entr.cod_estab           = v_cod_estab
               and item_docto_entr.cod_empresa         = v_cod_empresa
               and item_docto_entr.cdn_fornecedor      = tt_criacao_bem_pat_item_api.tta_cdn_fornecedor
               and item_docto_entr.cod_docto_entr      = tt_criacao_bem_pat_item_api.tta_cod_docto_entr
               and item_docto_entr.cod_ser_nota        = tt_criacao_bem_pat_item_api.tta_cod_ser_nota
               and item_docto_entr.num_item_docto_entr = tt_criacao_bem_pat_item_api.tta_num_item_docto_entr
           no-error.

        if not avail item_docto_entr then do:

            /* Begin_Include: i_erros_api_criacao_bem_pat */
            create tt_erros_criacao_bem_pat_api_1.
            assign tt_erros_criacao_bem_pat_api_1.tta_cod_unid_organ_ext   = tt_criacao_bem_pat_api_6.tta_cod_unid_organ_ext
                   tt_erros_criacao_bem_pat_api_1.tta_cod_cta_pat          = tt_criacao_bem_pat_api_6.tta_cod_cta_pat
                   tt_erros_criacao_bem_pat_api_1.tta_num_bem_pat          = tt_criacao_bem_pat_api_6.tta_num_bem_pat
                   tt_erros_criacao_bem_pat_api_1.tta_num_seq_bem_pat      = tt_criacao_bem_pat_api_6.tta_num_seq_bem_pat
                   tt_erros_criacao_bem_pat_api_1.tta_des_bem_pat          = tt_criacao_bem_pat_api_6.tta_des_bem_pat
                   tt_erros_criacao_bem_pat_api_1.tta_dat_aquis_bem_pat    = tt_criacao_bem_pat_api_6.tta_dat_aquis_bem_pat
                   tt_erros_criacao_bem_pat_api_1.tta_cod_finalid_econ_ext = tt_criacao_bem_pat_api_6.tta_cod_finalid_econ_ext.

            /* End_Include: i_erros_api_criacao_bem_pat */

            assign tt_erros_criacao_bem_pat_api_1.ttv_des_mensagem  = substitute(getStrTrans("Item do Documento de Entrada n∆o existe para o estabelecimento &1, empresa &2, fornecedor &3, documento &4, sÇrie &5 e n£mero &6.", "FAS") /*5033*/,
                                                                    v_cod_estab, v_cod_empresa, string(tt_criacao_bem_pat_item_api.tta_cdn_fornecedor),
                                                                    tt_criacao_bem_pat_item_api.tta_cod_docto_entr, tt_criacao_bem_pat_item_api.tta_cod_ser_nota,
                                                                    string(tt_criacao_bem_pat_item_api.tta_num_item_docto_entr)).
            return "NOK" /*l_nok*/ .
        end.
        else do:

            if tt_criacao_bem_pat_item_api.tta_qtd_item_docto_entr <= 0 then do:

                /* Begin_Include: i_erros_api_criacao_bem_pat */
                create tt_erros_criacao_bem_pat_api_1.
                assign tt_erros_criacao_bem_pat_api_1.tta_cod_unid_organ_ext   = tt_criacao_bem_pat_api_6.tta_cod_unid_organ_ext
                       tt_erros_criacao_bem_pat_api_1.tta_cod_cta_pat          = tt_criacao_bem_pat_api_6.tta_cod_cta_pat
                       tt_erros_criacao_bem_pat_api_1.tta_num_bem_pat          = tt_criacao_bem_pat_api_6.tta_num_bem_pat
                       tt_erros_criacao_bem_pat_api_1.tta_num_seq_bem_pat      = tt_criacao_bem_pat_api_6.tta_num_seq_bem_pat
                       tt_erros_criacao_bem_pat_api_1.tta_des_bem_pat          = tt_criacao_bem_pat_api_6.tta_des_bem_pat
                       tt_erros_criacao_bem_pat_api_1.tta_dat_aquis_bem_pat    = tt_criacao_bem_pat_api_6.tta_dat_aquis_bem_pat
                       tt_erros_criacao_bem_pat_api_1.tta_cod_finalid_econ_ext = tt_criacao_bem_pat_api_6.tta_cod_finalid_econ_ext.

                /* End_Include: i_erros_api_criacao_bem_pat */

                assign tt_erros_criacao_bem_pat_api_1.ttv_des_mensagem  = substitute(getStrTrans("A quantidade do item do documento de entrada (Fornecedor &1, Docto &2, SÇrie NF &3, Num Item &4) deve ser maior que 0 (zero).", "FAS") /*20115*/,
                                                                        string(tt_criacao_bem_pat_item_api.tta_cdn_fornecedor),tt_criacao_bem_pat_item_api.tta_cod_docto_entr,
                                                                        tt_criacao_bem_pat_item_api.tta_cod_ser_nota, string(tt_criacao_bem_pat_item_api.tta_num_item_docto_entr)).
                return "NOK" /*l_nok*/ .
            end.
            /* verifica se a quantidade que solicitada est† dispon°vel para vinculaá∆o */
            if tt_criacao_bem_pat_item_api.tta_qtd_item_docto_entr > 
               (item_docto_entr.qtd_item_docto_entr - int(GetEntryField(5,item_docto_entr.cod_livre_1,chr(10))))
            then do:

                /* Begin_Include: i_erros_api_criacao_bem_pat */
                create tt_erros_criacao_bem_pat_api_1.
                assign tt_erros_criacao_bem_pat_api_1.tta_cod_unid_organ_ext   = tt_criacao_bem_pat_api_6.tta_cod_unid_organ_ext
                       tt_erros_criacao_bem_pat_api_1.tta_cod_cta_pat          = tt_criacao_bem_pat_api_6.tta_cod_cta_pat
                       tt_erros_criacao_bem_pat_api_1.tta_num_bem_pat          = tt_criacao_bem_pat_api_6.tta_num_bem_pat
                       tt_erros_criacao_bem_pat_api_1.tta_num_seq_bem_pat      = tt_criacao_bem_pat_api_6.tta_num_seq_bem_pat
                       tt_erros_criacao_bem_pat_api_1.tta_des_bem_pat          = tt_criacao_bem_pat_api_6.tta_des_bem_pat
                       tt_erros_criacao_bem_pat_api_1.tta_dat_aquis_bem_pat    = tt_criacao_bem_pat_api_6.tta_dat_aquis_bem_pat
                       tt_erros_criacao_bem_pat_api_1.tta_cod_finalid_econ_ext = tt_criacao_bem_pat_api_6.tta_cod_finalid_econ_ext.

                /* End_Include: i_erros_api_criacao_bem_pat */

                assign tt_erros_criacao_bem_pat_api_1.ttv_des_mensagem  = substitute(getStrTrans("A quantidade dispon°vel para utilizaá∆o do item do documento de entrada (Fornecedor &1, Docto &2, SÇrie NF &3, Num Item &4) Ç insuficiente para a quantidade solicitada. " + chr(10) +
    "Qtde dispon°vel: &5." + chr(10) +
    "Qtde solicitada: &6.", "FAS") /*20055*/,
                                                                        string(tt_criacao_bem_pat_item_api.tta_cdn_fornecedor),tt_criacao_bem_pat_item_api.tta_cod_docto_entr,
                                                                        tt_criacao_bem_pat_item_api.tta_cod_ser_nota, string(tt_criacao_bem_pat_item_api.tta_num_item_docto_entr),
                                                                        string(item_docto_entr.qtd_item_docto_entr - int(GetEntryField(5,item_docto_entr.cod_livre_1,chr(10)))),
                                                                        string(tt_criacao_bem_pat_item_api.tta_qtd_item_docto_entr)).
                return "NOK" /*l_nok*/ .
            end.
        end.
    end.

    run pi_validar_bem_pat_item_docto_api.
    if return-value = "NOK" /*l_nok*/  then
        return "NOK" /*l_nok*/ .

    find bem_pat
        where bem_pat.cod_empresa     = v_cod_empresa
        and   bem_pat.cod_cta_pat     = tt_criacao_bem_pat_api_6.tta_cod_cta_pat
        and   bem_pat.num_bem_pat     = tt_criacao_bem_pat_api_6.tta_num_bem_pat
        and   bem_pat.num_seq_bem_pat = tt_criacao_bem_pat_api_6.tta_num_seq_bem_pat
        no-lock no-error.
    if  avail bem_pat
    then do:

        /* Begin_Include: i_erros_api_criacao_bem_pat */
        create tt_erros_criacao_bem_pat_api_1.
        assign tt_erros_criacao_bem_pat_api_1.tta_cod_unid_organ_ext   = tt_criacao_bem_pat_api_6.tta_cod_unid_organ_ext
               tt_erros_criacao_bem_pat_api_1.tta_cod_cta_pat          = tt_criacao_bem_pat_api_6.tta_cod_cta_pat
               tt_erros_criacao_bem_pat_api_1.tta_num_bem_pat          = tt_criacao_bem_pat_api_6.tta_num_bem_pat
               tt_erros_criacao_bem_pat_api_1.tta_num_seq_bem_pat      = tt_criacao_bem_pat_api_6.tta_num_seq_bem_pat
               tt_erros_criacao_bem_pat_api_1.tta_des_bem_pat          = tt_criacao_bem_pat_api_6.tta_des_bem_pat
               tt_erros_criacao_bem_pat_api_1.tta_dat_aquis_bem_pat    = tt_criacao_bem_pat_api_6.tta_dat_aquis_bem_pat
               tt_erros_criacao_bem_pat_api_1.tta_cod_finalid_econ_ext = tt_criacao_bem_pat_api_6.tta_cod_finalid_econ_ext.

        /* End_Include: i_erros_api_criacao_bem_pat */

        assign tt_erros_criacao_bem_pat_api_1.ttv_des_mensagem = getStrTrans("Bem Patrimonial externo j† existe !", "FAS") /*1270*/.
        return "NOK" /*l_nok*/ .
    end /* if */.

    /* ------------- MP 66 / MP 135 / MP 164 / MP219 --------*/
    if v_cod_pais_empres_usuar = "BRA" /*l_bra*/  then do:
       /* Credito Parcelado PIS COFINS - para bens adquiridos apos 30/04/2004 */
       if  tt_criacao_bem_pat_api_6.ttv_num_parc_pis_cofins > 0 then do:
           assign v_log_valid_cr_parc_pis_cofins = yes.
           if  tt_criacao_bem_pat_api_6.tta_dat_aquis_bem_pat < 05/01/2004 then
               assign v_log_valid_cr_parc_pis_cofins = no.
           else do:
               if  not tt_criacao_bem_pat_api_6.tta_log_cr_pis
               and not tt_criacao_bem_pat_api_6.tta_log_cr_cofins then
                   assign v_log_valid_cr_parc_pis_cofins = no.
           end.
           if  not v_log_valid_cr_parc_pis_cofins then do:

               /* Begin_Include: i_erros_api_criacao_bem_pat */
               create tt_erros_criacao_bem_pat_api_1.
               assign tt_erros_criacao_bem_pat_api_1.tta_cod_unid_organ_ext   = tt_criacao_bem_pat_api_6.tta_cod_unid_organ_ext
                      tt_erros_criacao_bem_pat_api_1.tta_cod_cta_pat          = tt_criacao_bem_pat_api_6.tta_cod_cta_pat
                      tt_erros_criacao_bem_pat_api_1.tta_num_bem_pat          = tt_criacao_bem_pat_api_6.tta_num_bem_pat
                      tt_erros_criacao_bem_pat_api_1.tta_num_seq_bem_pat      = tt_criacao_bem_pat_api_6.tta_num_seq_bem_pat
                      tt_erros_criacao_bem_pat_api_1.tta_des_bem_pat          = tt_criacao_bem_pat_api_6.tta_des_bem_pat
                      tt_erros_criacao_bem_pat_api_1.tta_dat_aquis_bem_pat    = tt_criacao_bem_pat_api_6.tta_dat_aquis_bem_pat
                      tt_erros_criacao_bem_pat_api_1.tta_cod_finalid_econ_ext = tt_criacao_bem_pat_api_6.tta_cod_finalid_econ_ext.

               /* End_Include: i_erros_api_criacao_bem_pat */

               assign tt_erros_criacao_bem_pat_api_1.ttv_des_mensagem = substitute(getStrTrans("Para que o bem &1 possa ser parametrizado para descontar PIS ou COFINS de forma parcelada, o mesmo tambÇm deve estar parametrizado para creditar PIS ou COFINS, e a data de aquisiá∆o do Bem n∆o poder† ser inferior a 01/05/2004.", "FAS") /*13454*/, string(tt_criacao_bem_pat_api_6.tta_cod_cta_pat + " / " + string(tt_criacao_bem_pat_api_6.tta_num_bem_pat) + " / " + string(tt_criacao_bem_pat_api_6.tta_num_seq_bem_pat))).
               return "NOK" /*l_nok*/ .
           end.
       end.

       if  tt_criacao_bem_pat_api_6.tta_log_bem_imptdo
       and tt_criacao_bem_pat_api_6.tta_dat_aquis_bem_pat < 05/01/2004
       and (tt_criacao_bem_pat_api_6.tta_log_cr_pis or
            tt_criacao_bem_pat_api_6.tta_log_cr_cofins)
       then do:

           /* Begin_Include: i_erros_api_criacao_bem_pat */
           create tt_erros_criacao_bem_pat_api_1.
           assign tt_erros_criacao_bem_pat_api_1.tta_cod_unid_organ_ext   = tt_criacao_bem_pat_api_6.tta_cod_unid_organ_ext
                  tt_erros_criacao_bem_pat_api_1.tta_cod_cta_pat          = tt_criacao_bem_pat_api_6.tta_cod_cta_pat
                  tt_erros_criacao_bem_pat_api_1.tta_num_bem_pat          = tt_criacao_bem_pat_api_6.tta_num_bem_pat
                  tt_erros_criacao_bem_pat_api_1.tta_num_seq_bem_pat      = tt_criacao_bem_pat_api_6.tta_num_seq_bem_pat
                  tt_erros_criacao_bem_pat_api_1.tta_des_bem_pat          = tt_criacao_bem_pat_api_6.tta_des_bem_pat
                  tt_erros_criacao_bem_pat_api_1.tta_dat_aquis_bem_pat    = tt_criacao_bem_pat_api_6.tta_dat_aquis_bem_pat
                  tt_erros_criacao_bem_pat_api_1.tta_cod_finalid_econ_ext = tt_criacao_bem_pat_api_6.tta_cod_finalid_econ_ext.

           /* End_Include: i_erros_api_criacao_bem_pat */

           assign tt_erros_criacao_bem_pat_api_1.ttv_des_mensagem = getStrTrans("N∆o pode ser creditado PIS / COFINS para bem importado.", "FAS") /*12490*/.
           return "NOK" /*l_nok*/ .
       end.

       /* Somente pode atualizar com valor de crÇdito maior que zero */
       if  tt_criacao_bem_pat_api_6.ttv_num_parc_pis_cofins > 0 and ( 
          (tt_criacao_bem_pat_api_6.tta_log_cr_pis and tt_criacao_bem_pat_api_6.tta_val_cr_pis <= 0) OR
          (tt_criacao_bem_pat_api_6.tta_log_cr_cofins and tt_criacao_bem_pat_api_6.tta_val_cr_cofins <= 0))
       then do:

           /* Begin_Include: i_erros_api_criacao_bem_pat */
           create tt_erros_criacao_bem_pat_api_1.
           assign tt_erros_criacao_bem_pat_api_1.tta_cod_unid_organ_ext   = tt_criacao_bem_pat_api_6.tta_cod_unid_organ_ext
                  tt_erros_criacao_bem_pat_api_1.tta_cod_cta_pat          = tt_criacao_bem_pat_api_6.tta_cod_cta_pat
                  tt_erros_criacao_bem_pat_api_1.tta_num_bem_pat          = tt_criacao_bem_pat_api_6.tta_num_bem_pat
                  tt_erros_criacao_bem_pat_api_1.tta_num_seq_bem_pat      = tt_criacao_bem_pat_api_6.tta_num_seq_bem_pat
                  tt_erros_criacao_bem_pat_api_1.tta_des_bem_pat          = tt_criacao_bem_pat_api_6.tta_des_bem_pat
                  tt_erros_criacao_bem_pat_api_1.tta_dat_aquis_bem_pat    = tt_criacao_bem_pat_api_6.tta_dat_aquis_bem_pat
                  tt_erros_criacao_bem_pat_api_1.tta_cod_finalid_econ_ext = tt_criacao_bem_pat_api_6.tta_cod_finalid_econ_ext.

           /* End_Include: i_erros_api_criacao_bem_pat */

           assign tt_erros_criacao_bem_pat_api_1.ttv_des_mensagem = getStrTrans("Deve ser informado valores para o credito de PIS ou COFINS, quando selecionado o n£mero de Parcelas.", "FAS") /*13829*/.
           return "NOK" /*l_nok*/ .
       end.

       if  tt_criacao_bem_pat_api_6.ttv_num_parc_pis_cofins > 99 then do:

           /* Begin_Include: i_erros_api_criacao_bem_pat */
           create tt_erros_criacao_bem_pat_api_1.
           assign tt_erros_criacao_bem_pat_api_1.tta_cod_unid_organ_ext   = tt_criacao_bem_pat_api_6.tta_cod_unid_organ_ext
                  tt_erros_criacao_bem_pat_api_1.tta_cod_cta_pat          = tt_criacao_bem_pat_api_6.tta_cod_cta_pat
                  tt_erros_criacao_bem_pat_api_1.tta_num_bem_pat          = tt_criacao_bem_pat_api_6.tta_num_bem_pat
                  tt_erros_criacao_bem_pat_api_1.tta_num_seq_bem_pat      = tt_criacao_bem_pat_api_6.tta_num_seq_bem_pat
                  tt_erros_criacao_bem_pat_api_1.tta_des_bem_pat          = tt_criacao_bem_pat_api_6.tta_des_bem_pat
                  tt_erros_criacao_bem_pat_api_1.tta_dat_aquis_bem_pat    = tt_criacao_bem_pat_api_6.tta_dat_aquis_bem_pat
                  tt_erros_criacao_bem_pat_api_1.tta_cod_finalid_econ_ext = tt_criacao_bem_pat_api_6.tta_cod_finalid_econ_ext.

           /* End_Include: i_erros_api_criacao_bem_pat */

           assign tt_erros_criacao_bem_pat_api_1.ttv_des_mensagem = getStrTrans("O n£mero de parcelas informado para o Bem &1 creditar parcelado PIS e COFINS Ç inv†lido, informe um valor entre ZERO e 99.", "FAS") /*13455*/.
           return "NOK" /*l_nok*/ .
       end.

       /* Validar valores de PIS/COFINS maior que o valor do Bem */
       if  tt_criacao_bem_pat_api_6.tta_log_cr_cofins = yes and tt_criacao_bem_pat_api_6.tta_val_cr_cofins > tt_criacao_bem_pat_api_6.ttv_val_aquis_bem_pat
       then do:

           /* Begin_Include: i_erros_api_criacao_bem_pat */
           create tt_erros_criacao_bem_pat_api_1.
           assign tt_erros_criacao_bem_pat_api_1.tta_cod_unid_organ_ext   = tt_criacao_bem_pat_api_6.tta_cod_unid_organ_ext
                  tt_erros_criacao_bem_pat_api_1.tta_cod_cta_pat          = tt_criacao_bem_pat_api_6.tta_cod_cta_pat
                  tt_erros_criacao_bem_pat_api_1.tta_num_bem_pat          = tt_criacao_bem_pat_api_6.tta_num_bem_pat
                  tt_erros_criacao_bem_pat_api_1.tta_num_seq_bem_pat      = tt_criacao_bem_pat_api_6.tta_num_seq_bem_pat
                  tt_erros_criacao_bem_pat_api_1.tta_des_bem_pat          = tt_criacao_bem_pat_api_6.tta_des_bem_pat
                  tt_erros_criacao_bem_pat_api_1.tta_dat_aquis_bem_pat    = tt_criacao_bem_pat_api_6.tta_dat_aquis_bem_pat
                  tt_erros_criacao_bem_pat_api_1.tta_cod_finalid_econ_ext = tt_criacao_bem_pat_api_6.tta_cod_finalid_econ_ext.

           /* End_Include: i_erros_api_criacao_bem_pat */

           assign tt_erros_criacao_bem_pat_api_1.ttv_des_mensagem = substitute(getStrTrans("O valor original informado (&1) Ç menor que o valor de crÇdito de COFINS (&2) !", "FAS") /*13771*/,tt_criacao_bem_pat_api_6.ttv_val_aquis_bem_pat,tt_criacao_bem_pat_api_6.tta_val_cr_cofins).
           return "NOK" /*l_nok*/ .
       end /* if */.
       if  tt_criacao_bem_pat_api_6.tta_log_cr_pis = yes and tt_criacao_bem_pat_api_6.tta_val_cr_pis > tt_criacao_bem_pat_api_6.ttv_val_aquis_bem_pat
       then do:

           /* Begin_Include: i_erros_api_criacao_bem_pat */
           create tt_erros_criacao_bem_pat_api_1.
           assign tt_erros_criacao_bem_pat_api_1.tta_cod_unid_organ_ext   = tt_criacao_bem_pat_api_6.tta_cod_unid_organ_ext
                  tt_erros_criacao_bem_pat_api_1.tta_cod_cta_pat          = tt_criacao_bem_pat_api_6.tta_cod_cta_pat
                  tt_erros_criacao_bem_pat_api_1.tta_num_bem_pat          = tt_criacao_bem_pat_api_6.tta_num_bem_pat
                  tt_erros_criacao_bem_pat_api_1.tta_num_seq_bem_pat      = tt_criacao_bem_pat_api_6.tta_num_seq_bem_pat
                  tt_erros_criacao_bem_pat_api_1.tta_des_bem_pat          = tt_criacao_bem_pat_api_6.tta_des_bem_pat
                  tt_erros_criacao_bem_pat_api_1.tta_dat_aquis_bem_pat    = tt_criacao_bem_pat_api_6.tta_dat_aquis_bem_pat
                  tt_erros_criacao_bem_pat_api_1.tta_cod_finalid_econ_ext = tt_criacao_bem_pat_api_6.tta_cod_finalid_econ_ext.

           /* End_Include: i_erros_api_criacao_bem_pat */

           assign tt_erros_criacao_bem_pat_api_1.ttv_des_mensagem = substitute(getStrTrans("O valor original informado (&1) Ç menor que o valor de crÇdito de PIS (&2) !", "FAS") /*13772*/,tt_criacao_bem_pat_api_6.ttv_val_aquis_bem_pat,tt_criacao_bem_pat_api_6.tta_val_cr_pis).
           return "NOK" /*l_nok*/ .
       end /* if */.

       if  tt_criacao_bem_pat_api_6.tta_val_cr_cofins <> 0 and (tt_criacao_bem_pat_api_6.tta_log_cr_cofins = no or tt_criacao_bem_pat_api_6.ttv_num_parc_pis_cofins <= 1)
       then do:

           /* Begin_Include: i_erros_api_criacao_bem_pat */
           create tt_erros_criacao_bem_pat_api_1.
           assign tt_erros_criacao_bem_pat_api_1.tta_cod_unid_organ_ext   = tt_criacao_bem_pat_api_6.tta_cod_unid_organ_ext
                  tt_erros_criacao_bem_pat_api_1.tta_cod_cta_pat          = tt_criacao_bem_pat_api_6.tta_cod_cta_pat
                  tt_erros_criacao_bem_pat_api_1.tta_num_bem_pat          = tt_criacao_bem_pat_api_6.tta_num_bem_pat
                  tt_erros_criacao_bem_pat_api_1.tta_num_seq_bem_pat      = tt_criacao_bem_pat_api_6.tta_num_seq_bem_pat
                  tt_erros_criacao_bem_pat_api_1.tta_des_bem_pat          = tt_criacao_bem_pat_api_6.tta_des_bem_pat
                  tt_erros_criacao_bem_pat_api_1.tta_dat_aquis_bem_pat    = tt_criacao_bem_pat_api_6.tta_dat_aquis_bem_pat
                  tt_erros_criacao_bem_pat_api_1.tta_cod_finalid_econ_ext = tt_criacao_bem_pat_api_6.tta_cod_finalid_econ_ext.

           /* End_Include: i_erros_api_criacao_bem_pat */

           assign tt_erros_criacao_bem_pat_api_1.ttv_des_mensagem = getStrTrans("Valor Inv†lido para CrÇdito Parcelado COFINS !", "FAS") /*13821*/.
           return "NOK" /*l_nok*/ .
       end /* if */.
       if  tt_criacao_bem_pat_api_6.tta_val_cr_pis <> 0 and (tt_criacao_bem_pat_api_6.tta_log_cr_pis = no or tt_criacao_bem_pat_api_6.ttv_num_parc_pis_cofins <= 1)
       then do:

           /* Begin_Include: i_erros_api_criacao_bem_pat */
           create tt_erros_criacao_bem_pat_api_1.
           assign tt_erros_criacao_bem_pat_api_1.tta_cod_unid_organ_ext   = tt_criacao_bem_pat_api_6.tta_cod_unid_organ_ext
                  tt_erros_criacao_bem_pat_api_1.tta_cod_cta_pat          = tt_criacao_bem_pat_api_6.tta_cod_cta_pat
                  tt_erros_criacao_bem_pat_api_1.tta_num_bem_pat          = tt_criacao_bem_pat_api_6.tta_num_bem_pat
                  tt_erros_criacao_bem_pat_api_1.tta_num_seq_bem_pat      = tt_criacao_bem_pat_api_6.tta_num_seq_bem_pat
                  tt_erros_criacao_bem_pat_api_1.tta_des_bem_pat          = tt_criacao_bem_pat_api_6.tta_des_bem_pat
                  tt_erros_criacao_bem_pat_api_1.tta_dat_aquis_bem_pat    = tt_criacao_bem_pat_api_6.tta_dat_aquis_bem_pat
                  tt_erros_criacao_bem_pat_api_1.tta_cod_finalid_econ_ext = tt_criacao_bem_pat_api_6.tta_cod_finalid_econ_ext.

           /* End_Include: i_erros_api_criacao_bem_pat */

           assign tt_erros_criacao_bem_pat_api_1.ttv_des_mensagem = getStrTrans("Valor Inv†lido para CrÇdito Parcelado PIS !", "FAS") /*13820*/.
           return "NOK" /*l_nok*/ .
       end /* if */.

       /* MP219 - Credito CSLL */
       if  tt_criacao_bem_pat_api_6.ttv_log_cr_csll
       then do:
           if  tt_criacao_bem_pat_api_6.ttv_num_exerc_cr_csll = 0
           then do:

               /* Begin_Include: i_erros_api_criacao_bem_pat */
               create tt_erros_criacao_bem_pat_api_1.
               assign tt_erros_criacao_bem_pat_api_1.tta_cod_unid_organ_ext   = tt_criacao_bem_pat_api_6.tta_cod_unid_organ_ext
                      tt_erros_criacao_bem_pat_api_1.tta_cod_cta_pat          = tt_criacao_bem_pat_api_6.tta_cod_cta_pat
                      tt_erros_criacao_bem_pat_api_1.tta_num_bem_pat          = tt_criacao_bem_pat_api_6.tta_num_bem_pat
                      tt_erros_criacao_bem_pat_api_1.tta_num_seq_bem_pat      = tt_criacao_bem_pat_api_6.tta_num_seq_bem_pat
                      tt_erros_criacao_bem_pat_api_1.tta_des_bem_pat          = tt_criacao_bem_pat_api_6.tta_des_bem_pat
                      tt_erros_criacao_bem_pat_api_1.tta_dat_aquis_bem_pat    = tt_criacao_bem_pat_api_6.tta_dat_aquis_bem_pat
                      tt_erros_criacao_bem_pat_api_1.tta_cod_finalid_econ_ext = tt_criacao_bem_pat_api_6.tta_cod_finalid_econ_ext.

               /* End_Include: i_erros_api_criacao_bem_pat */

               assign tt_erros_criacao_bem_pat_api_1.ttv_des_mensagem = getStrTrans("Dever† ser informado um valor maior que zero para o n£mero de exerc°cios a creditar CSLL.", "FAS") /*13946*/.
               return "NOK" /*l_nok*/ .
           end /* if */.

           if  tt_criacao_bem_pat_api_6.tta_dat_aquis_bem_pat < 10/01/2004 or tt_criacao_bem_pat_api_6.tta_dat_aquis_bem_pat > 12/31/2010
           then do:

               /* Begin_Include: i_erros_api_criacao_bem_pat */
               create tt_erros_criacao_bem_pat_api_1.
               assign tt_erros_criacao_bem_pat_api_1.tta_cod_unid_organ_ext   = tt_criacao_bem_pat_api_6.tta_cod_unid_organ_ext
                      tt_erros_criacao_bem_pat_api_1.tta_cod_cta_pat          = tt_criacao_bem_pat_api_6.tta_cod_cta_pat
                      tt_erros_criacao_bem_pat_api_1.tta_num_bem_pat          = tt_criacao_bem_pat_api_6.tta_num_bem_pat
                      tt_erros_criacao_bem_pat_api_1.tta_num_seq_bem_pat      = tt_criacao_bem_pat_api_6.tta_num_seq_bem_pat
                      tt_erros_criacao_bem_pat_api_1.tta_des_bem_pat          = tt_criacao_bem_pat_api_6.tta_des_bem_pat
                      tt_erros_criacao_bem_pat_api_1.tta_dat_aquis_bem_pat    = tt_criacao_bem_pat_api_6.tta_dat_aquis_bem_pat
                      tt_erros_criacao_bem_pat_api_1.tta_cod_finalid_econ_ext = tt_criacao_bem_pat_api_6.tta_cod_finalid_econ_ext.

               /* End_Include: i_erros_api_criacao_bem_pat */

               assign tt_erros_criacao_bem_pat_api_1.ttv_des_mensagem  = getStrTrans("Somente possuem direito ao crÇdito da CSLL, os bens adquiridos entre 1ß de outubro de 2004 e 31 de dezembro de 2010 (conforme Lei Nr. 11.452 de 27/02/2007 Œ art. 14).", "FAS") /*13945*/.
           end /* if */.
       end /* if */.
       else
           assign tt_criacao_bem_pat_api_6.ttv_num_exerc_cr_csll = 0.
    end.

    return "OK" /*l_ok*/ .
END PROCEDURE. /* pi_validar_criacao_bem_pat_api */
/*****************************************************************************
** Procedure Interna.....: pi_validar_estab
** Descricao.............: pi_validar_estab
** Criado por............: 
** Criado em.............: // 
** Alterado por..........: src12337
** Alterado em...........: 23/03/2001 08:01:00
*****************************************************************************/
PROCEDURE pi_validar_estab:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_empresa
        as character
        format "x(3)"
        no-undo.
    def Input param p_cod_estab
    &IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.07A" &THEN
        as character
        format "x(3)"
    &ENDIF
    &IF "{&emsfin_version}" >= "5.07A" AND "{&emsfin_version}" < "9.99" &THEN
        as Character
        format "x(5)"
    &ENDIF
        no-undo.
    def Input param p_dat_transacao
        as date
        format "99/99/9999"
        no-undo.
    def output param p_cod_return
        as character
        format "x(40)"
        no-undo.


    /************************* Parameter Definition End *************************/

    find unid_organ no-lock
         where unid_organ.cod_unid_organ = p_cod_estab /*cl_estab of unid_organ*/ no-error.
    if  avail unid_organ
    then do:
        if  p_dat_transacao <> ? and
           (p_dat_transacao < unid_organ.dat_inic_valid or
            p_dat_transacao > unid_organ.dat_fim_valid)
        then do:
            assign p_cod_return = "Unidade Organizacional" /*l_unid_organ*/ .
            return.
        end /* if */.
    end /* if */.
    else do:
        assign p_cod_return = "Unidade Organizacional" /*l_unid_organ*/ .
        return.
    end /* else */.
    if  p_cod_empresa <> ?
    then do:
        find estabelecimento no-lock
             where estabelecimento.cod_estab = p_cod_estab /*cl_param_estab of estabelecimento*/ no-error.
        if  avail estabelecimento and
            estabelecimento.cod_empresa <> p_cod_empresa
        then do:
            assign p_cod_return = "Empresa" /*l_empresa*/ .
            return.
        end /* if */.
    end /* if */.
    if  can-find(segur_unid_organ
            where segur_unid_organ.cod_unid_organ = p_cod_estab
              and segur_unid_organ.cod_grp_usuar = '*' /*cl_valid_estab_todos_usuarios of segur_unid_organ*/)
            then do:
        /* todos os usu†rio podem acessar */
       assign p_cod_return = "".
       return.
    end /* if */.
    contr_block:
    for
       each usuar_grp_usuar no-lock
       where usuar_grp_usuar.cod_usuario = v_cod_usuar_corren
    &if "{&emsbas_version}" >= "5.01" &then
       use-index srgrpsr_usuario
    &endif
        /*cl_grupos_do_usuario of usuar_grp_usuar*/:
       find first segur_unid_organ no-lock
            where segur_unid_organ.cod_unid_organ = p_cod_estab
              and segur_unid_organ.cod_grp_usuar = usuar_grp_usuar.cod_grp_usuar /*cl_valida_estab of segur_unid_organ*/ no-error.
       if  avail segur_unid_organ
       then do:
          assign p_cod_return = "".
          return.
       end /* if */.
    end /* for contr_block */.
    assign p_cod_return = "Usu†rio" /*l_usuario*/ .

END PROCEDURE. /* pi_validar_estab */
/*****************************************************************************
** Procedure Interna.....: pi_validar_plano_ccusto
** Descricao.............: pi_validar_plano_ccusto
** Criado por............: 
** Criado em.............: // 
** Alterado por..........: corp43356
** Alterado em...........: 28/08/2012 08:33:05
*****************************************************************************/
PROCEDURE pi_validar_plano_ccusto:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_empresa
        as character
        format "x(3)"
        no-undo.
    def Input param p_cod_plano_ccusto
        as character
        format "x(8)"
        no-undo.
    def Input param p_dat_refer_ent
        as date
        format "99/99/9999"
        no-undo.
    def output param p_log_plano_ccusto_val
        as logical
        format "Sim/N∆o"
        no-undo.


    /************************* Parameter Definition End *************************/

    find plano_ccusto no-lock
         where plano_ccusto.cod_empresa = p_cod_empresa
           and plano_ccusto.cod_plano_ccusto = p_cod_plano_ccusto /*cl_valida_plano of plano_ccusto*/ no-error.
    if  avail plano_ccusto
    then do:
        if  p_dat_refer_ent = ? or
           (plano_ccusto.dat_inic_valid <= p_dat_refer_ent and
            plano_ccusto.dat_fim_valid  >= p_dat_refer_ent)
        then do:
               assign p_log_plano_ccusto_val = yes.
        end /* if */.
        else do:
            assign p_log_plano_ccusto_val = no.
        end /* else */.
    end /* if */.
    else do:
        assign p_log_plano_ccusto_val = no.
    end /* else */.

END PROCEDURE. /* pi_validar_plano_ccusto */
/*****************************************************************************
** Procedure Interna.....: pi_validar_ccusto
** Descricao.............: pi_validar_ccusto
** Criado por............: 
** Criado em.............: // 
** Alterado por..........: Puccini
** Alterado em...........: 16/10/1998 10:09:15
*****************************************************************************/
PROCEDURE pi_validar_ccusto:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_empresa
        as character
        format "x(3)"
        no-undo.
    def Input param p_cod_plano_ccusto
        as character
        format "x(8)"
        no-undo.
    def Input param p_cod_ccusto
    &IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.07" &THEN
        as Character
        format "x(11)"
    &ENDIF
    &IF "{&emsfin_version}" >= "5.07" AND "{&emsfin_version}" < "9.99" &THEN
        as character
        format "x(20)"
    &ENDIF
        no-undo.
    def Input param p_dat_inic_valid
        as date
        format "99/99/9999"
        no-undo.
    def Input param p_dat_fim_valid
        as date
        format "99/99/9999"
        no-undo.
    def output param p_log_return
        as logical
        format "Sim/N∆o"
        no-undo.


    /************************* Parameter Definition End *************************/

    p_log_return = no.
    find first ccusto no-lock
         where ccusto.cod_empresa      = p_cod_empresa
           and ccusto.cod_plano_ccusto = p_cod_plano_ccusto
           and ccusto.cod_ccusto       = p_cod_ccusto no-error.
    if  not avail ccusto
    then do:
        return.
    end /* if */.
    find first plano_ccusto no-lock
         where plano_ccusto.cod_empresa = ccusto.cod_empresa
           and plano_ccusto.cod_plano_ccusto = ccusto.cod_plano_ccusto
          no-error.
    if  p_dat_inic_valid <> ? and p_dat_fim_valid <> ?
    then do:
        if  not(ccusto.dat_inic_valid <= p_dat_inic_valid
        and ccusto.dat_fim_valid  >= p_dat_fim_valid)
        then do:
            return.
        end /* if */.
        if  not(plano_ccusto.dat_inic_valid <= p_dat_inic_valid
        and plano_ccusto.dat_fim_valid >= p_dat_fim_valid)
        then do:
            return.
        end /* if */.
    end /* if */.
    if  p_dat_inic_valid <> ? and p_dat_fim_valid = ?
    then do:
        if  not ccusto.dat_inic_valid <= p_dat_inic_valid
        or  not ccusto.dat_fim_valid >= p_dat_inic_valid
        then do:
            return.
        end /* if */.
        if  not plano_ccusto.dat_inic_valid <= p_dat_inic_valid
        then do:
            return.
        end /* if */.
    end /* if */.
    if  p_dat_inic_valid = ? and p_dat_fim_valid <> ?
    then do:
        if  not ccusto.dat_fim_valid >= p_dat_fim_valid
        then do:
            return.
        end /* if */.
        if  not plano_ccusto.dat_fim_valid >= p_dat_fim_valid
        then do:
            return.
        end /* if */.
    end /* if */.
    assign p_log_return = yes.
END PROCEDURE. /* pi_validar_ccusto */
/*****************************************************************************
** Procedure Interna.....: pi_verifica_segur_ccusto
** Descricao.............: pi_verifica_segur_ccusto
** Criado por............: Henke
** Criado em.............: 02/02/1996 16:26:15
** Alterado por..........: corp45591
** Alterado em...........: 14/11/2011 11:50:51
*****************************************************************************/
PROCEDURE pi_verifica_segur_ccusto:

    /************************ Parameter Definition Begin ************************/

    def param buffer p_ccusto
        for emscad.ccusto.
    def output param p_log_return
        as logical
        format "Sim/N∆o"
        no-undo.


    /************************* Parameter Definition End *************************/

    assign p_log_return = no.
    /* default Ç n∆o ter permiss∆o */

    if can-find (first segur_ccusto
       where segur_ccusto.cod_empresa      = p_ccusto.cod_empresa
         and segur_ccusto.cod_plano_ccusto = p_ccusto.cod_plano_ccusto
         and segur_ccusto.cod_ccusto       = p_ccusto.cod_ccusto
         and segur_ccusto.cod_grp_usuar    = "*")
    then
        assign p_log_return = yes.
    else do:
        loop_block:
                FOR EACH segur_ccusto
                where segur_ccusto.cod_empresa             = p_ccusto.cod_empresa
                       and segur_ccusto.cod_plano_ccusto   = p_ccusto.cod_plano_ccusto
                       and segur_ccusto.cod_ccusto         = p_ccusto.cod_ccusto NO-LOCK.
                IF CAN-FIND(FIRST usuar_grp_usuar
                            WHERE usuar_grp_usuar.cod_usuario   = v_cod_usuar_corren
                            AND   usuar_grp_usuar.cod_grp_usuar = segur_ccusto.cod_grp_usuar) THEN DO:
                    assign p_log_return = yes.
                    leave loop_block.

                END.
            END.
    end /* else */.
END PROCEDURE. /* pi_verifica_segur_ccusto */
/*****************************************************************************
** Procedure Interna.....: pi_validar_ccusto_unid_negoc_estab
** Descricao.............: pi_validar_ccusto_unid_negoc_estab
** Criado por............: Henke
** Criado em.............: // 
** Alterado por..........: Rafael
** Alterado em...........: 21/08/1997 15:17:43
*****************************************************************************/
PROCEDURE pi_validar_ccusto_unid_negoc_estab:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_empresa
        as character
        format "x(3)"
        no-undo.
    def Input param p_cod_plano_ccusto
        as character
        format "x(8)"
        no-undo.
    def Input param p_cod_ccusto
    &IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.07" &THEN
        as Character
        format "x(11)"
    &ENDIF
    &IF "{&emsfin_version}" >= "5.07" AND "{&emsfin_version}" < "9.99" &THEN
        as character
        format "x(20)"
    &ENDIF
        no-undo.
    def Input param p_cod_unid_negoc
        as character
        format "x(3)"
        no-undo.
    def Input param p_cod_estab
    &IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.07A" &THEN
        as character
        format "x(3)"
    &ENDIF
    &IF "{&emsfin_version}" >= "5.07A" AND "{&emsfin_version}" < "9.99" &THEN
        as Character
        format "x(5)"
    &ENDIF
        no-undo.
    def output param p_num_mensagem
        as integer
        format ">>>>,>>9"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    &IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.07" &THEN
    def var v_cod_ccusto_000
        as Character
        format "x(11)":U
        label "Centro Custo"
        column-label "Centro Custo"
        no-undo.
    &ENDIF
    &IF "{&emsfin_version}" >= "5.07" AND "{&emsfin_version}" < "9.99" &THEN
    def var v_cod_ccusto_000
        as character
        format "x(20)":U
        label "Centro de Custo"
        column-label "Centro de Custo"
        no-undo.
    &ENDIF


    /************************** Variable Definition End *************************/

    if  p_cod_estab <> "" and
        p_cod_unid_negoc <> ""
    then do:
        find estab_unid_negoc no-lock
             where estab_unid_negoc.cod_estab = p_cod_estab
               and estab_unid_negoc.cod_unid_negoc = p_cod_unid_negoc /*cl_valida_unid_negoc of estab_unid_negoc*/ no-error.
        if  not avail estab_unid_negoc
        then do:
            assign p_num_mensagem = 950.
            return.
        end /* if */.
    end /* if */.
    if  avail plano_ccusto and
        plano_ccusto.cod_plano_ccusto = p_cod_plano_ccusto and
        plano_ccusto.cod_empresa = p_cod_empresa
    then do:
        run pi_retornar_ccusto_inic (Input plano_ccusto.cod_format_ccusto,
                                     output v_cod_ccusto_000) /*pi_retornar_ccusto_inic*/.
    end /* if */.
    else do:
        if  p_cod_plano_ccusto <> ""
        then do:
           find plano_ccusto no-lock
                where plano_ccusto.cod_empresa = p_cod_empresa
                  and plano_ccusto.cod_plano_ccusto = p_cod_plano_ccusto /*cl_valida_plano of plano_ccusto*/ no-error.
           if  avail plano_ccusto
           then do:
              run pi_retornar_ccusto_inic (Input plano_ccusto.cod_format_ccusto,
                                           output v_cod_ccusto_000) /*pi_retornar_ccusto_inic*/.
           end /* if */.
           else do:
              assign v_cod_ccusto_000 = "".
           end /* else */.
        end /* if */.
        else do:
           assign v_cod_ccusto_000 = "".
        end /* else */.
    end /* else */.
    if  p_cod_plano_ccusto <> "" and
        p_cod_ccusto       <> v_cod_ccusto_000 and
        p_cod_unid_negoc   <> ""
    then do:
        find ccusto_unid_negoc no-lock
             where ccusto_unid_negoc.cod_empresa = p_cod_empresa
               and ccusto_unid_negoc.cod_plano_ccusto = p_cod_plano_ccusto
               and ccusto_unid_negoc.cod_ccusto = p_cod_ccusto
               and ccusto_unid_negoc.cod_unid_negoc = p_cod_unid_negoc /*cl_validar_ccusto_unid_negoc_estab of ccusto_unid_negoc*/ no-error.
        if  not avail ccusto_unid_negoc
        then do:
            assign p_num_mensagem = 1253.
            return.
        end /* if */.
    end /* if */.
    if  p_cod_plano_ccusto <> "" and
        p_cod_ccusto       <> v_cod_ccusto_000 and
        p_cod_estab        <> ""
    then do:
        find restric_ccusto no-lock
             where restric_ccusto.cod_empresa = p_cod_empresa
               and restric_ccusto.cod_plano_ccusto = p_cod_plano_ccusto
               and restric_ccusto.cod_ccusto = p_cod_ccusto
               and restric_ccusto.cod_estab = p_cod_estab /*cl_validar_ccusto_unid_negoc_estab of restric_ccusto*/ no-error.
        if  avail restric_ccusto
        then do:
            assign p_num_mensagem = 1388.
            return.
        end /* if */.
    end /* if */.
    assign p_num_mensagem = 0.
END PROCEDURE. /* pi_validar_ccusto_unid_negoc_estab */
/*****************************************************************************
** Procedure Interna.....: pi_retornar_ccusto_inic
** Descricao.............: pi_retornar_ccusto_inic
** Criado por............: pasold
** Criado em.............: 26/08/1996 14:12:15
** Alterado por..........: bre18473
** Alterado em...........: 17/02/2000 09:58:41
*****************************************************************************/
PROCEDURE pi_retornar_ccusto_inic:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_format_ccusto
        as character
        format "x(11)"
        no-undo.
    def output param p_cod_ccusto_000
    &IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.07" &THEN
        as Character
        format "x(11)"
    &ENDIF
    &IF "{&emsfin_version}" >= "5.07" AND "{&emsfin_version}" < "9.99" &THEN
        as character
        format "x(20)"
    &ENDIF
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    &IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.07" &THEN
    def var v_cod_ccusto_000
        as Character
        format "x(11)":U
        label "Centro Custo"
        column-label "Centro Custo"
        no-undo.
    &ENDIF
    &IF "{&emsfin_version}" >= "5.07" AND "{&emsfin_version}" < "9.99" &THEN
    def var v_cod_ccusto_000
        as character
        format "x(20)":U
        label "Centro de Custo"
        column-label "Centro de Custo"
        no-undo.
    &ENDIF
    def var v_num_count
        as integer
        format ">>>>,>>9":U
        no-undo.


    /************************** Variable Definition End *************************/

    assign v_num_count = 1.
           v_cod_ccusto_000 = "".

    contador:
    do while v_num_count <= length(p_cod_format_ccusto):
        if  substring(p_cod_format_ccusto,v_num_count,1) <> "-"
        and substring(p_cod_format_ccusto,v_num_count,1) <> ","
        and substring(p_cod_format_ccusto,v_num_count,1) <> "."
        then do:
            if  substring(p_cod_format_ccusto,v_num_count,1) = "!"
            then do:
                assign v_cod_ccusto_000 = v_cod_ccusto_000 + keylabel(65).
            end /* if */.
            else do:
                if  substring(p_cod_format_ccusto,v_num_count,1) = "9"
                or  substring(p_cod_format_ccusto,v_num_count,1) = "x" /*l_X*/ 
                then do:
                    assign v_cod_ccusto_000 = v_cod_ccusto_000 + "0".
                end /* if */.
                else do:
                    assign v_cod_ccusto_000 = v_cod_ccusto_000 + keylabel(32).
                end /* else */.
            end /* else */.
        end /* if */.
        assign v_num_count = v_num_count + 1.
    end /* do contador */.
    assign p_cod_ccusto_000 = v_cod_ccusto_000.
END PROCEDURE. /* pi_retornar_ccusto_inic */
/*****************************************************************************
** Procedure Interna.....: pi_verifica_utiliz_funcao
** Descricao.............: pi_verifica_utiliz_funcao
** Criado por............: 
** Criado em.............: // 
** Alterado por..........: fut41675_3
** Alterado em...........: 12/04/2011 09:14:39
*****************************************************************************/
PROCEDURE pi_verifica_utiliz_funcao:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_funcao_negoc
        as character
        format "x(3)"
        no-undo.
    def Input param p_cod_empresa
        as character
        format "x(3)"
        no-undo.
    def output param p_log_param_utiliz_produt_val
        as logical
        format "Sim/N∆o"
        no-undo.


    /************************* Parameter Definition End *************************/

    /* funcao: */
    case p_cod_funcao_negoc:
       when "UNID_NEG" /*l_unid_neg*/ then assign p_cod_funcao_negoc = 'BU'.

       when "CMCAC" /*l_cmcac*/ then    assign p_cod_funcao_negoc = 'CCC'.

    end /* case funcao */.

    &IF DEFINED(BF_FIN_VALIDA_FUNCAO) &THEN
        assign p_log_param_utiliz_produt_val = yes.
    &ELSE
        if  p_cod_empresa = ""
        then do:
           assign p_log_param_utiliz_produt_val = can-find(first param_utiliz_produt
                                                          where param_utiliz_produt.cod_funcao_negoc = p_cod_funcao_negoc /*cl_verifica_utiliz_funcao_funcao of param_utiliz_produt*/).
        end /* if */.
        else do:
           if  p_cod_empresa = v_cod_empres_usuar
           then do:
              assign p_log_param_utiliz_produt_val = can-do(v_cod_funcao_negoc_empres,trim(p_cod_funcao_negoc)).
           end /* if */.
           else do:
              assign p_log_param_utiliz_produt_val = can-find(first param_utiliz_produt
                                                             where param_utiliz_produt.cod_empresa = p_cod_empresa
                                                               and param_utiliz_produt.cod_modul_dtsul = ''
                                                               and param_utiliz_produt.cod_funcao_negoc = p_cod_funcao_negoc /*cl_verifica_utiliz_funcao_empresa of param_utiliz_produt*/).
           end /* else */.
        end /* else */.
    &ENDIF
END PROCEDURE. /* pi_verifica_utiliz_funcao */
/*****************************************************************************
** Procedure Interna.....: pi_verifica_segur_unid_negoc
** Descricao.............: pi_verifica_segur_unid_negoc
** Criado por............: Henke
** Criado em.............: 06/02/1996 13:59:16
** Alterado por..........: corp45591
** Alterado em...........: 14/11/2011 11:33:53
*****************************************************************************/
PROCEDURE pi_verifica_segur_unid_negoc:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_unid_negoc
        as character
        format "x(3)"
        no-undo.
    def output param p_log_return
        as logical
        format "Sim/N∆o"
        no-undo.


    /************************* Parameter Definition End *************************/

    assign p_log_return = no.
    /* default Ç n∆o ter permiss∆o */

    if  can-find(segur_unid_negoc
        where segur_unid_negoc.cod_unid_negoc = p_cod_unid_negoc
          and segur_unid_negoc.cod_grp_usuar = "*" /*l_**/ )
    then do:
        assign p_log_return = yes.
        return.
        /* tem permiss∆o*/

    end.
        FOR EACH segur_unid_negoc
            WHERE  segur_unid_negoc.cod_unid_negoc = p_cod_unid_negoc NO-LOCK.
            IF CAN-FIND(FIRST usuar_grp_usuar
                        WHERE usuar_grp_usuar.cod_grp_usuar = segur_unid_negoc.cod_grp_usuar
                        AND   usuar_grp_usuar.cod_usuario   = v_cod_usuar_corren) THEN DO:
                assign p_log_return = yes.
                return.
            END.
        END.

END PROCEDURE. /* pi_verifica_segur_unid_negoc */
/*****************************************************************************
** Procedure Interna.....: pi_retornar_sit_movimen_modul
** Descricao.............: pi_retornar_sit_movimen_modul
** Criado por............: Rovina
** Criado em.............: // 
** Alterado por..........: 
** Alterado em...........: 28/09/1995 13:58:38
*****************************************************************************/
PROCEDURE pi_retornar_sit_movimen_modul:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_modul_dtsul
        as character
        format "x(3)"
        no-undo.
    def Input param p_cod_unid_organ
    &IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.07A" &THEN
        as character
        format "x(3)"
    &ENDIF
    &IF "{&emsfin_version}" >= "5.07A" AND "{&emsfin_version}" < "9.99" &THEN
        as Character
        format "x(5)"
    &ENDIF
        no-undo.
    def Input param p_dat_refer_sit
        as date
        format "99/99/9999"
        no-undo.
    def Input param p_des_sit_movimen_ent
        as character
        format "x(40)"
        no-undo.
    def output param p_des_sit_movimen_mod
        as character
        format "x(40)"
        no-undo.


    /************************* Parameter Definition End *************************/

    assign p_des_sit_movimen_mod = "".
    situacao:
    for each sit_movimen_modul no-lock
     where sit_movimen_modul.cod_modul_dtsul = p_cod_modul_dtsul
       and sit_movimen_modul.cod_unid_organ = p_cod_unid_organ
       and sit_movimen_modul.dat_inic_sit_movimen <= p_dat_refer_sit
       and sit_movimen_modul.dat_fim_sit_movimen >= p_dat_refer_sit /*cl_retornar_sit_movimen_modul of sit_movimen_modul*/:
        if  p_des_sit_movimen_mod = ""
        then do:
            assign p_des_sit_movimen_mod = sit_movimen_modul.ind_sit_movimen.
        end /* if */.
        else do:
            assign p_des_sit_movimen_mod = p_des_sit_movimen_mod + "," + sit_movimen_modul.ind_sit_movimen.
        end /* else */.
    end /* for situacao */.

END PROCEDURE. /* pi_retornar_sit_movimen_modul */
/*****************************************************************************
** Procedure Interna.....: pi_validar_unid_negoc
** Descricao.............: pi_validar_unid_negoc
** Criado por............: 
** Criado em.............: // 
** Alterado por..........: fut41675_3
** Alterado em...........: 27/04/2011 10:01:17
*****************************************************************************/
PROCEDURE pi_validar_unid_negoc:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_estab
    &IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.07A" &THEN
        as character
        format "x(3)"
    &ENDIF
    &IF "{&emsfin_version}" >= "5.07A" AND "{&emsfin_version}" < "9.99" &THEN
        as Character
        format "x(5)"
    &ENDIF
        no-undo.
    def Input param p_cod_unid_negoc
        as character
        format "x(3)"
        no-undo.
    def Input param p_dat_refer_ent
        as date
        format "99/99/9999"
        no-undo.
    def output param p_cod_return
        as character
        format "x(40)"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_log_return                     as logical         no-undo. /*local*/


    /************************** Variable Definition End *************************/

    assign p_cod_return = "".
    &IF DEFINED(BF_FIN_VALIDA_FUNCAO) = 0 &THEN
    find estabelecimento no-lock
         where estabelecimento.cod_estab = p_cod_estab /*cl_param_estab of estabelecimento*/ no-error.

    find first param_utiliz_produt no-lock
         where param_utiliz_produt.cod_empresa = estabelecimento.cod_empresa
           and param_utiliz_produt.cod_modul_dtsul = ''
           and param_utiliz_produt.cod_funcao_negoc = 'BU' /*cl_verifica_unid_negoc of param_utiliz_produt*/ no-error.
    if  avail param_utiliz_produt
    then do:
    &ENDIF
        find estab_unid_negoc no-lock
             where estab_unid_negoc.cod_estab = p_cod_estab
               and estab_unid_negoc.cod_unid_negoc = p_cod_unid_negoc /*cl_valida_unid_negoc of estab_unid_negoc*/ no-error.
        if  avail estab_unid_negoc
        then do:
            if  p_dat_refer_ent <> ? and
               (estab_unid_negoc.dat_inic_valid > p_dat_refer_ent or
                estab_unid_negoc.dat_fim_valid  < p_dat_refer_ent)
            then do:
                 assign p_cod_return = "Data" /*l_data*/ .
                 return.
            end /* if */.
            run pi_verifica_segur_unid_negoc (Input p_cod_unid_negoc,
                                              output v_log_return) /*pi_verifica_segur_unid_negoc*/.
            if v_log_return = yes 
            then do:
               assign p_cod_return = "".
               return.
            end /* if */.

            assign p_cod_return = "Usu†rio" /*l_usuario*/ .
        end /* if */.
        else do:
            assign p_cod_return = "Estabelecimento" /*l_estabelecimento*/ .
        end /* else */.
    &IF DEFINED(BF_FIN_VALIDA_FUNCAO) = 0 &THEN
    end /* if */.
    &ENDIF

END PROCEDURE. /* pi_validar_unid_negoc */
/*****************************************************************************
** Procedure Interna.....: pi_validar_indic_econ_movto
** Descricao.............: pi_validar_indic_econ_movto
** Criado por............: 
** Criado em.............: // 
** Alterado por..........: fut40574
** Alterado em...........: 28/01/2008 09:49:33
*****************************************************************************/
PROCEDURE pi_validar_indic_econ_movto:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_indic_econ
        as character
        format "x(8)"
        no-undo.
    def Input param p_dat_transacao
        as date
        format "99/99/9999"
        no-undo.
    def Input param p_cod_unid_organ
    &IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.07A" &THEN
        as character
        format "x(3)"
    &ENDIF
    &IF "{&emsfin_version}" >= "5.07A" AND "{&emsfin_version}" < "9.99" &THEN
        as Character
        format "x(5)"
    &ENDIF
        no-undo.
    def output param p_cod_return
        as character
        format "x(40)"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_cod_return
        as character
        format "x(40)":U
        no-undo.


    /************************** Variable Definition End *************************/

    run pi_validar_indic_econ_valid (Input p_cod_indic_econ,
                                     Input p_dat_transacao,
                                     output p_cod_return) /*pi_validar_indic_econ_valid*/.
    if  p_cod_return <> "OK" /*l_ok*/ 
    then do:
        return.
    end /* if */.

    find first histor_finalid_econ no-lock
         where histor_finalid_econ.cod_indic_econ = p_cod_indic_econ
           and histor_finalid_econ.dat_inic_valid_finalid <= p_dat_transacao
           and histor_finalid_econ.dat_fim_valid_finalid > p_dat_transacao /*cl_indic_econ_ativo of histor_finalid_econ*/ no-error.
    if  not avail histor_finalid_econ
    then do:
        assign p_cod_return = "336".
        return.
    end /* if */.

    find finalid_econ no-lock
         where finalid_econ.cod_finalid_econ = histor_finalid_econ.cod_finalid_econ

           and finalid_econ.log_infor_val = yes /*cl_log_infor_val of finalid_econ*/ no-error.
    if  not avail finalid_econ
    then do:
        assign p_cod_return = "337" + "," + histor_finalid_econ.cod_finalid_econ.
        return.
    end /* if */.
    run pi_validar_finalid_unid_organ (Input finalid_econ.cod_finalid_econ,
                                       Input p_cod_unid_organ,
                                       Input p_dat_transacao,
                                       output p_cod_return) /*pi_validar_finalid_unid_organ*/.
    if  p_cod_return = "338"
    then do:
       return.
    end /* if */.

    assign p_cod_return =  "OK" /*l_ok*/ .
END PROCEDURE. /* pi_validar_indic_econ_movto */
/*****************************************************************************
** Procedure Interna.....: pi_converter_indic_econ_finalid_cenar
** Descricao.............: pi_converter_indic_econ_finalid_cenar
** Criado por............: Puccini
** Criado em.............: 01/02/1996 13:55:33
** Alterado por..........: fut1228
** Alterado em...........: 28/07/2005 17:34:08
*****************************************************************************/
PROCEDURE pi_converter_indic_econ_finalid_cenar:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_indic_econ
        as character
        format "x(8)"
        no-undo.
    def Input param p_cod_unid_organ
    &IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.07A" &THEN
        as character
        format "x(3)"
    &ENDIF
    &IF "{&emsfin_version}" >= "5.07A" AND "{&emsfin_version}" < "9.99" &THEN
        as Character
        format "x(5)"
    &ENDIF
        no-undo.
    def Input param p_cod_cenar_ctbl
        as character
        format "x(8)"
        no-undo.
    def Input param p_dat_transacao
        as date
        format "99/99/9999"
        no-undo.
    def Input param p_val_transacao
        as decimal
        format "->>,>>>,>>>,>>9.99"
        decimals 2
        no-undo.
    def Input param p_cod_finalid_econ
        as character
        format "x(10)"
        no-undo.
    def output param p_cod_return
        as character
        format "x(40)"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_cod_return
        as character
        format "x(40)":U
        no-undo.
    def var v_dat_cotac_indic_econ
        as date
        format "99/99/9999":U
        initial today
        label "Data Cotaá∆o"
        column-label "Data Cotaá∆o"
        no-undo.
    def var v_val_cotac_indic_econ
        as decimal
        format "->>,>>>,>>>,>>9.9999999999":U
        decimals 10
        label "Cotaá∆o"
        column-label "Cotaá∆o"
        no-undo.


    /************************** Variable Definition End *************************/

    elimina:
    for
       each tt_converter_finalid_econ exclusive-lock:
       delete tt_converter_finalid_econ.
    end /* for elimina */.

    run pi_validar_indic_econ_valid (Input p_cod_indic_econ,
                                     Input p_dat_transacao,
                                     output p_cod_return) /*pi_validar_indic_econ_valid*/.
    if  p_cod_return <> "OK" /*l_ok*/ 
    then do:
       return.
    end /* if */.

    if  p_cod_finalid_econ <> ""
    then do:
       /* OBS: Esta alteraªío deve permanecer no cΩdigo fonte, pois esta sendo feita sob demanda. Conforme acordo com a equipe do Test Center, 
              devido lista de impacto muito extensa. Atividade 138100 */

       find first compos_finalid no-lock
            where compos_finalid.cod_indic_econ_base = p_cod_indic_econ
              and compos_finalid.cod_finalid_econ = p_cod_finalid_econ
              and compos_finalid.dat_inic_valid <= p_dat_transacao
              and compos_finalid.dat_fim_valid > p_dat_transacao
    &if "{&emsuni_version}" >= "5.01" &then
            use-index cmpsfnld_parid_indic_econ
    &endif
             /*cl_indic_econ_base_finalid_exclusiva of compos_finalid*/ no-error.
       if  not avail compos_finalid
       then do:
          assign p_cod_return = "782" + "," + p_cod_finalid_econ + "," + p_cod_indic_econ + "," + string(p_dat_transacao).
          return.
       end /* if */.
       run pi_validar_finalid_utiliz_cenar (Input p_cod_cenar_ctbl,
                                            Input p_cod_unid_organ,
                                            Input compos_finalid.cod_finalid_econ,
                                            Input p_dat_transacao,
                                            output v_cod_return) /*pi_validar_finalid_utiliz_cenar*/.

       if  v_cod_return <> " "
       then do:
          assign p_cod_return = v_cod_return.
          return.
       end /* if */.
       if  compos_finalid.cod_indic_econ_base <> compos_finalid.cod_indic_econ_idx
       then do:
           find finalid_econ no-lock
                where finalid_econ.cod_finalid_econ = compos_Finalid.cod_finalid_econ
                 no-error.
           if  finalid_econ.ind_armaz_val = "Contabilidade" /*l_contabilidade*/  or
               finalid_econ.ind_armaz_val = "N∆o" /*l_nao*/ 
           then do:
               assign p_cod_return = "1389" + "," + finalid_econ.cod_finalid_econ.
               return.
           end /* if */.

       /* Begin_Include: i_criar_tab_conver_finalid */
            find first compos_finalid_cmcmm no-lock
                 where compos_finalid_cmcmm.cod_finalid_econ = compos_finalid.cod_finalid_econ
                   and compos_finalid_cmcmm.cod_indic_econ_base = compos_finalid.cod_indic_econ_base
                   and compos_finalid_cmcmm.cod_indic_econ_idx = compos_finalid.cod_indic_econ_idx
                   and compos_finalid_cmcmm.dat_inic_valid_compos = compos_finalid.dat_inic_valid
                   and compos_finalid_cmcmm.dat_inic_valid_finalid = compos_finalid.dat_inic_valid_finalid

                   and compos_finalid_cmcmm.dat_inic_valid <= p_dat_transacao
                   and compos_finalid_cmcmm.dat_fim_valid > p_dat_transacao /*cl_param_ativo_compos of compos_finalid_cmcmm*/ no-error.

            if  avail compos_finalid_cmcmm
            then do:

                 run pi_achar_cotac_indic_econ (Input compos_finalid.cod_indic_econ_base,
                                                Input compos_finalid.cod_indic_econ_idx,
                                                Input p_dat_transacao,
                                                Input "Real" /*l_real*/,
                                                output v_dat_cotac_indic_econ,
                                                output v_val_cotac_indic_econ,
                                                output v_cod_return) /*pi_achar_cotac_indic_econ*/.
                 if  entry(1,v_cod_return) = "358"
                 then do:
                    elimina:
                    for
                        each tt_converter_finalid_econ exclusive-lock:
                        delete tt_converter_finalid_econ.
                    end /* for elimina */.
                    assign p_cod_return = v_cod_return.
                    return.
                 end /* if */.
                 create tt_converter_finalid_econ.
                 assign tt_converter_finalid_econ.tta_cod_finalid_econ     = compos_finalid.cod_finalid_econ
                        tt_converter_finalid_econ.tta_dat_cotac_indic_econ = v_dat_cotac_indic_econ
                        tt_converter_finalid_econ.tta_val_cotac_indic_econ = v_val_cotac_indic_econ
                        tt_converter_finalid_econ.tta_val_transacao        = p_val_transacao / v_val_cotac_indic_econ.
                 run pi_retornar_indic_econ_finalid (Input compos_finalid.cod_finalid_econ,
                                                     Input p_dat_transacao,
                                                     output tt_converter_finalid_econ.tta_cod_indic_econ) /*pi_retornar_indic_econ_finalid*/.

            end /* if */.
            else do:
               elimina:
               for
                   each tt_converter_finalid_econ exclusive-lock:
                   delete tt_converter_finalid_econ.
               end /* for elimina */.
               /* alteraá∆o por demanda, deve permanecer no fonte, atividade 159924 (fo 1345764) */   
               assign p_cod_return = "1200" + "," +
                                     compos_finalid.cod_indic_econ_base + "," +
                                     compos_finalid.cod_indic_econ_idx + "," +
                                     string(p_dat_transacao) + "," +
                                     compos_finalid.cod_finalid_econ + "," +
                                     string(compos_finalid.dat_inic_valid_finalid) + "," +
                                     string(compos_finalid.dat_inic_valid).
               return.
            end /* else */.
       /* End_Include: i_criar_tab_conver_finalid */

       end /* if */.
       else do:
           create tt_converter_finalid_econ.
           assign tt_converter_finalid_econ.tta_cod_finalid_econ      = compos_finalid.cod_finalid_econ
                  tt_converter_finalid_econ.tta_dat_cotac_indic_econ  = p_dat_transacao
                  tt_converter_finalid_econ.tta_val_cotac_indic_econ  = 1
                  tt_converter_finalid_econ.tta_val_transacao         = p_val_transacao
                  tt_converter_finalid_econ.tta_cod_indic_econ        = compos_finalid.cod_indic_econ_idx.
       end /* else */.
    end /* if */.
    else do:
       composicoes:
       for
          each compos_finalid no-lock
          where compos_finalid.cod_indic_econ_base = p_cod_indic_econ
            and compos_finalid.dat_inic_valid <= p_dat_transacao
            and compos_finalid.dat_fim_valid > p_dat_transacao
    &if "{&emsuni_version}" >= "5.01" &then
          use-index cmpsfnld_parid_indic_econ
    &endif
           /*cl_indic_econ_base_finalid of compos_finalid*/:
          run pi_validar_finalid_utiliz_cenar (Input p_cod_cenar_ctbl,
                                               Input p_cod_unid_organ,
                                               Input compos_finalid.cod_finalid_econ,
                                               Input p_dat_transacao,
                                               output v_cod_return) /*pi_validar_finalid_utiliz_cenar*/.

          if  v_cod_return <> " "
          then do:
            next composicoes.
          end /* if */.
          if  compos_finalid.cod_indic_econ_base <> compos_finalid.cod_indic_econ_idx
          then do:
              find finalid_econ no-lock
                   where finalid_econ.cod_finalid_econ = compos_finalid.cod_finalid_econ
                    no-error.
              if  finalid_econ.ind_armaz_val = "Contabilidade" /*l_contabilidade*/  or
                  finalid_econ.ind_armaz_val = "N∆o" /*l_nao*/ 
              then do:
                  next composicoes.
              end /* if */.


              /* Begin_Include: i_criar_tab_conver_finalid */
                   find first compos_finalid_cmcmm no-lock
                        where compos_finalid_cmcmm.cod_finalid_econ = compos_finalid.cod_finalid_econ
                          and compos_finalid_cmcmm.cod_indic_econ_base = compos_finalid.cod_indic_econ_base
                          and compos_finalid_cmcmm.cod_indic_econ_idx = compos_finalid.cod_indic_econ_idx
                          and compos_finalid_cmcmm.dat_inic_valid_compos = compos_finalid.dat_inic_valid
                          and compos_finalid_cmcmm.dat_inic_valid_finalid = compos_finalid.dat_inic_valid_finalid

                          and compos_finalid_cmcmm.dat_inic_valid <= p_dat_transacao
                          and compos_finalid_cmcmm.dat_fim_valid > p_dat_transacao /*cl_param_ativo_compos of compos_finalid_cmcmm*/ no-error.

                   if  avail compos_finalid_cmcmm
                   then do:

                        run pi_achar_cotac_indic_econ (Input compos_finalid.cod_indic_econ_base,
                                                       Input compos_finalid.cod_indic_econ_idx,
                                                       Input p_dat_transacao,
                                                       Input "Real" /*l_real*/,
                                                       output v_dat_cotac_indic_econ,
                                                       output v_val_cotac_indic_econ,
                                                       output v_cod_return) /*pi_achar_cotac_indic_econ*/.
                        if  entry(1,v_cod_return) = "358"
                        then do:
                           elimina:
                           for
                               each tt_converter_finalid_econ exclusive-lock:
                               delete tt_converter_finalid_econ.
                           end /* for elimina */.
                           assign p_cod_return = v_cod_return.
                           return.
                        end /* if */.
                        create tt_converter_finalid_econ.
                        assign tt_converter_finalid_econ.tta_cod_finalid_econ     = compos_finalid.cod_finalid_econ
                               tt_converter_finalid_econ.tta_dat_cotac_indic_econ = v_dat_cotac_indic_econ
                               tt_converter_finalid_econ.tta_val_cotac_indic_econ = v_val_cotac_indic_econ
                               tt_converter_finalid_econ.tta_val_transacao        = p_val_transacao / v_val_cotac_indic_econ.
                        run pi_retornar_indic_econ_finalid (Input compos_finalid.cod_finalid_econ,
                                                            Input p_dat_transacao,
                                                            output tt_converter_finalid_econ.tta_cod_indic_econ) /*pi_retornar_indic_econ_finalid*/.

                   end /* if */.
                   else do:
                      elimina:
                      for
                          each tt_converter_finalid_econ exclusive-lock:
                          delete tt_converter_finalid_econ.
                      end /* for elimina */.
                      /* alteraá∆o por demanda, deve permanecer no fonte, atividade 159924 (fo 1345764) */   
                      assign p_cod_return = "1200" + "," +
                                            compos_finalid.cod_indic_econ_base + "," +
                                            compos_finalid.cod_indic_econ_idx + "," +
                                            string(p_dat_transacao) + "," +
                                            compos_finalid.cod_finalid_econ + "," +
                                            string(compos_finalid.dat_inic_valid_finalid) + "," +
                                            string(compos_finalid.dat_inic_valid).
                      return.
                   end /* else */.
              /* End_Include: i_criar_tab_conver_finalid */

          end /* if */.
          else do:
               create tt_converter_finalid_econ.
               assign tt_converter_finalid_econ.tta_cod_finalid_econ      = compos_finalid.cod_finalid_econ
                      tt_converter_finalid_econ.tta_dat_cotac_indic_econ  = p_dat_transacao
                      tt_converter_finalid_econ.tta_val_cotac_indic_econ  = 1
                      tt_converter_finalid_econ.tta_val_transacao         = p_val_transacao
                      tt_converter_finalid_econ.tta_cod_indic_econ        = compos_finalid.cod_indic_econ_idx.
           end /* else */.

       end /* for composicoes */.

       find first tt_converter_finalid_econ no-lock no-error.
       if  not avail tt_converter_finalid_econ
       then do:
          assign p_cod_return = "1568".
          return.
       end /* if */.

    end /* else */.

    assign p_cod_return = "OK" /*l_ok*/ .
END PROCEDURE. /* pi_converter_indic_econ_finalid_cenar */
/*****************************************************************************
** Procedure Interna.....: pi_validar_indic_econ_valid
** Descricao.............: pi_validar_indic_econ_valid
** Criado por............: 
** Criado em.............: // 
** Alterado por..........: 
** Alterado em...........: 26/09/1995 10:04:56
*****************************************************************************/
PROCEDURE pi_validar_indic_econ_valid:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_indic_econ
        as character
        format "x(8)"
        no-undo.
    def Input param p_dat_transacao
        as date
        format "99/99/9999"
        no-undo.
    def output param p_cod_return
        as character
        format "x(40)"
        no-undo.


    /************************* Parameter Definition End *************************/

    find indic_econ no-lock
         where indic_econ.cod_indic_econ = p_cod_indic_econ /*cl_indic_econ_valid of indic_econ*/ no-error.
    if  not avail indic_econ
    then do:
       assign p_cod_return = "241".
       return.
    end /* if */.

    if  p_dat_transacao <  indic_econ.dat_inic_valid or
       p_dat_transacao >= indic_econ.dat_fim_valid
    then do:
       assign p_cod_return = "1199".
       return.
    end /* if */.

    assign p_cod_return = "OK" /*l_ok*/ .

END PROCEDURE. /* pi_validar_indic_econ_valid */
/*****************************************************************************
** Procedure Interna.....: pi_achar_cotac_indic_econ
** Descricao.............: pi_achar_cotac_indic_econ
** Criado por............: vladimir
** Criado em.............: // 
** Alterado por..........: fut1309_4
** Alterado em...........: 08/02/2006 16:12:34
*****************************************************************************/
PROCEDURE pi_achar_cotac_indic_econ:

    /************************ Parameter Definition Begin ************************/

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
    &if "{&emsuni_version}" >= "5.01" &then
                     use-index ctcprd_id
    &endif
                      /*cl_acha_cotac of cotac_parid*/ no-error.
                if  not avail cotac_parid
                then do:
                    find parid_indic_econ no-lock
                         where parid_indic_econ.cod_indic_econ_base = p_cod_indic_econ_base
                           and parid_indic_econ.cod_indic_econ_idx = p_cod_indic_econ_idx
    &if "{&emsuni_version}" >= "5.01" &then
                         use-index prdndccn_id
    &endif
                          /*cl_acha_parid_param of parid_indic_econ*/ no-error.
                    /* block: */
                    case parid_indic_econ.ind_criter_busca:
                        when "Anterior" /*l_anterior*/ then find prev cotac_parid no-lock
                              where cotac_parid.cod_indic_econ_base = p_cod_indic_econ_base
                                and cotac_parid.cod_indic_econ_idx = p_cod_indic_econ_idx
                                and cotac_parid.dat_cotac_indic_econ < p_dat_transacao
                                and cotac_parid.ind_tip_cotac_parid = p_ind_tip_cotac_parid
                                and cotac_parid.val_cotac_indic_econ <> 0.0
    &if "{&emsuni_version}" >= "5.01" &then
                              use-index ctcprd_id
    &endif
                               /*cl_acha_cotac_anterior of cotac_parid*/ no-error.
                        when "Pr¢ximo" /*l_proximo*/ then  find next cotac_parid no-lock
                               where cotac_parid.cod_indic_econ_base = p_cod_indic_econ_base
                                 and cotac_parid.cod_indic_econ_idx = p_cod_indic_econ_idx
                                 and cotac_parid.dat_cotac_indic_econ > p_dat_transacao
                                 and cotac_parid.ind_tip_cotac_parid = p_ind_tip_cotac_parid
                                 and cotac_parid.val_cotac_indic_econ <> 0.0
    &if "{&emsuni_version}" >= "5.01" &then
                               use-index ctcprd_id
    &endif
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
                                          &if '{&emsuni_version}' >= '5.01' &then
                                          use-index ctcprd_id
                                          &endif
                                          no-error.
                                when "Pr¢ximo" /*l_proximo*/ then  
                                    find next cotac_parid no-lock
                                        where cotac_parid.cod_indic_econ_base  = p_cod_indic_econ_base
                                          and cotac_parid.cod_indic_econ_idx   = p_cod_indic_econ_idx
                                          and cotac_parid.dat_cotac_indic_econ > p_dat_transacao
                                          and cotac_parid.ind_tip_cotac_parid  = p_ind_tip_cotac_parid
                                          and cotac_parid.val_cotac_indic_econ <> 0.0
                                          &if '{&emsuni_version}' >= '5.01' &then
                                          use-index ctcprd_id
                                          &endif
                                          no-error.
                            end /* case block */.
                        end /* if */.
                    end /* do diaria_block */.
                when "Mensal" /*l_mensal*/ then
                    mensal_block:
                    do:
                        assign v_dat_cotac_mes = date(month(p_dat_transacao), 1, year(p_dat_transacao))
                               &if yes = yes &then 
                               v_log_indic     = yes
                               &endif .
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
END PROCEDURE. /* pi_achar_cotac_indic_econ */
/*****************************************************************************
** Procedure Interna.....: pi_retornar_indic_econ_finalid
** Descricao.............: pi_retornar_indic_econ_finalid
** Criado por............: vladimir
** Criado em.............: // 
** Alterado por..........: Menna
** Alterado em...........: 06/05/1999 10:21:29
*****************************************************************************/
PROCEDURE pi_retornar_indic_econ_finalid:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_finalid_econ
        as character
        format "x(10)"
        no-undo.
    def Input param p_dat_transacao
        as date
        format "99/99/9999"
        no-undo.
    def output param p_cod_indic_econ
        as character
        format "x(8)"
        no-undo.


    /************************* Parameter Definition End *************************/

    find first histor_finalid_econ no-lock
         where histor_finalid_econ.cod_finalid_econ = p_cod_finalid_econ
           and histor_finalid_econ.dat_inic_valid_finalid <= p_dat_transacao
           and histor_finalid_econ.dat_fim_valid_finalid > p_dat_transacao
    &if "{&emsuni_version}" >= "5.01" &then
         use-index hstrfnld_id
    &endif
          /*cl_finalid_ativa of histor_finalid_econ*/ no-error.
    if  avail histor_finalid_econ then
        assign p_cod_indic_econ = histor_finalid_econ.cod_indic_econ.

END PROCEDURE. /* pi_retornar_indic_econ_finalid */
/*****************************************************************************
** Procedure Interna.....: pi_achar_cotac_indic_econ_2
** Descricao.............: pi_achar_cotac_indic_econ_2
** Criado por............: src531
** Criado em.............: 29/07/2003 11:10:10
** Alterado por..........: fut41061
** Alterado em...........: 21/07/2015 13:39:24
*****************************************************************************/
PROCEDURE pi_achar_cotac_indic_econ_2:

    /************************ Parameter Definition Begin ************************/

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
                        when "Anterior" /*l_anterior*/  then
                            find prev cotac_parid no-lock
                                where cotac_parid.cod_indic_econ_base   = p_cod_param_1
                                  and cotac_parid.cod_indic_econ_idx    = p_cod_param_2
                                  and cotac_parid.dat_cotac_indic_econ  < p_dat_transacao
                                  and cotac_parid.ind_tip_cotac_parid   = p_ind_tip_cotac_parid
                                  and cotac_parid.val_cotac_indic_econ <> 0.0 use-index ctcprd_id no-error.
                        when "Pr¢ximo" /*l_proximo*/  then
                            find next cotac_parid no-lock
                                where cotac_parid.cod_indic_econ_base   = p_cod_param_1
                                  and cotac_parid.cod_indic_econ_idx    = p_cod_param_2
                                  and cotac_parid.dat_cotac_indic_econ  > p_dat_transacao
                                  and cotac_parid.ind_tip_cotac_parid   = p_ind_tip_cotac_parid
                                  and cotac_parid.val_cotac_indic_econ <> 0.0 use-index ctcprd_id no-error.
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
END PROCEDURE. /* pi_achar_cotac_indic_econ_2 */
/*****************************************************************************
** Procedure Interna.....: pi_validar_finalid_utiliz_cenar
** Descricao.............: pi_validar_finalid_utiliz_cenar
** Criado por............: Uno
** Criado em.............: 01/02/1996 11:22:01
** Alterado por..........: Uno
** Alterado em...........: 01/02/1996 17:38:45
*****************************************************************************/
PROCEDURE pi_validar_finalid_utiliz_cenar:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_cenar_ctbl
        as character
        format "x(8)"
        no-undo.
    def Input param p_cod_empresa
        as character
        format "x(3)"
        no-undo.
    def Input param p_cod_finalid_econ
        as character
        format "x(10)"
        no-undo.
    def Input param p_dat_transacao
        as date
        format "99/99/9999"
        no-undo.
    def output param p_cod_return
        as character
        format "x(40)"
        no-undo.


    /************************* Parameter Definition End *************************/

    assign p_cod_return = " ".

    find finalid_utiliz_cenar no-lock
         where finalid_utiliz_cenar.cod_cenar_ctbl = p_cod_cenar_ctbl
           and finalid_utiliz_cenar.cod_empresa = p_cod_empresa
           and finalid_utiliz_cenar.cod_finalid_econ = p_cod_finalid_econ
    &if "{&emsuni_version}" >= "5.01" &then
         use-index fnldtlzc_id
    &endif
          /*cl_valida_finalid_utiliz_cenar of finalid_utiliz_cenar*/ no-error.
    if  avail finalid_utiliz_cenar
    then do:
        if  p_dat_transacao <> ?
        and (finalid_utiliz_cenar.dat_inic_valid >  p_dat_transacao
        or   finalid_utiliz_cenar.dat_fim_valid  <= p_dat_transacao)
        then do:
             assign p_cod_return = "1915" + "," + p_cod_finalid_econ + "," + p_cod_cenar_ctbl.
        end /* if */.
    end /* if */.
    else do:
        assign p_cod_return = "1916" + "," + p_cod_finalid_econ + "," + p_cod_cenar_ctbl.
    end /* else */.

END PROCEDURE. /* pi_validar_finalid_utiliz_cenar */
/*****************************************************************************
** Procedure Interna.....: pi_criacao_bem_pat_finalidade
** Descricao.............: pi_criacao_bem_pat_finalidade
** Criado por............: bre18732
** Criado em.............: 05/12/2000 19:12:24
** Alterado por..........: fut41422_1
** Alterado em...........: 11/09/2012 08:18:52
*****************************************************************************/
PROCEDURE pi_criacao_bem_pat_finalidade:

    assign v_cod_indic_econ = "".                                
    if  avail matriz_trad_finalid_ext
    then do:

        find trad_finalid_econ_ext
            where trad_finalid_econ_ext.cod_matriz_trad_finalid_ext = matriz_trad_finalid_ext.cod_matriz_trad_finalid_ext
            and   trad_finalid_econ_ext.cod_finalid_econ_ext = tt_criacao_bem_pat_api_6.tta_cod_finalid_econ_ext
            no-lock no-error.
        if  not avail trad_finalid_econ_ext
        then do:
            create tt_erros_criacao_bem_pat_api_1.
            assign tt_erros_criacao_bem_pat_api_1.tta_cod_unid_organ_ext   = tt_criacao_bem_pat_api_6.tta_cod_unid_organ_ext
                   tt_erros_criacao_bem_pat_api_1.tta_cod_cta_pat          = tt_criacao_bem_pat_api_6.tta_cod_cta_pat
                   tt_erros_criacao_bem_pat_api_1.tta_num_bem_pat          = tt_criacao_bem_pat_api_6.tta_num_bem_pat
                   tt_erros_criacao_bem_pat_api_1.tta_num_seq_bem_pat      = tt_criacao_bem_pat_api_6.tta_num_seq_bem_pat
                   tt_erros_criacao_bem_pat_api_1.tta_des_bem_pat          = tt_criacao_bem_pat_api_6.tta_des_bem_pat
                   tt_erros_criacao_bem_pat_api_1.tta_dat_aquis_bem_pat    = tt_criacao_bem_pat_api_6.tta_dat_aquis_bem_pat
                   tt_erros_criacao_bem_pat_api_1.tta_cod_finalid_econ_ext = tt_criacao_bem_pat_api_6.tta_cod_finalid_econ_ext
                   .
            assign tt_erros_criacao_bem_pat_api_1.ttv_des_mensagem = substitute(getStrTrans("N∆o existe traduá∆o para a Finalidade Econìmica Externa &1 !", "FAS") /*1450*/, tt_criacao_bem_pat_api_6.tta_cod_finalid_econ_ext)
                   tt_criacao_bem_pat_api_6.ttv_log_erro = yes
                   v_log_erro_validac = yes.
            return "NOK" /*l_nok*/ .
        end /* if */.

        if  trad_finalid_econ_ext.ind_tip_cotac = "Percentual" /*l_percentual*/  then
            assign v_cod_indic_econ = trad_finalid_econ_ext.cod_indic_econ
                   tt_criacao_bem_pat_api_6.tta_cod_finalid_econ_ext = trad_finalid_econ_ext.cod_indic_econ.
        else do:
            run pi_retornar_indic_econ_finalid (Input trad_finalid_econ_ext.cod_finalid_econ,
                                                Input tt_criacao_bem_pat_api_6.tta_dat_aquis_bem_pat,
                                                output v_cod_indic_econ) /*pi_retornar_indic_econ_finalid*/.
            assign tt_criacao_bem_pat_api_6.tta_cod_finalid_econ_ext = v_cod_indic_econ.
        end.        
    end /* if */.
    else do:
        find indic_econ
            where indic_econ.cod_indic_econ = tt_criacao_bem_pat_api_6.tta_cod_finalid_econ_ext
            no-lock no-error.
        if  not avail indic_econ
        then do:
            create tt_erros_criacao_bem_pat_api_1.
            assign tt_erros_criacao_bem_pat_api_1.tta_cod_unid_organ_ext = tt_criacao_bem_pat_api_6.tta_cod_unid_organ_ext
                   tt_erros_criacao_bem_pat_api_1.tta_cod_cta_pat        = tt_criacao_bem_pat_api_6.tta_cod_cta_pat
                   tt_erros_criacao_bem_pat_api_1.tta_num_bem_pat        = tt_criacao_bem_pat_api_6.tta_num_bem_pat
                   tt_erros_criacao_bem_pat_api_1.tta_num_seq_bem_pat    = tt_criacao_bem_pat_api_6.tta_num_seq_bem_pat
                   tt_erros_criacao_bem_pat_api_1.tta_des_bem_pat        = tt_criacao_bem_pat_api_6.tta_des_bem_pat
                   tt_erros_criacao_bem_pat_api_1.tta_dat_aquis_bem_pat  = tt_criacao_bem_pat_api_6.tta_dat_aquis_bem_pat
                   tt_erros_criacao_bem_pat_api_1.tta_cod_finalid_econ_ext = tt_criacao_bem_pat_api_6.tta_cod_finalid_econ_ext
                   .
            assign tt_erros_criacao_bem_pat_api_1.ttv_des_mensagem       = getStrTrans("Indicador Econìmico externo inexistente !", "FAS") /*4674*/
                   tt_criacao_bem_pat_api_6.ttv_log_erro = yes
                   v_log_erro_validac = yes.
            return "NOK" /*l_nok*/ .
        end /* if */.
        assign v_cod_indic_econ = tt_criacao_bem_pat_api_6.tta_cod_finalid_econ_ext.
    end /* else */.

    return "OK" /*l_ok*/ .    
END PROCEDURE. /* pi_criacao_bem_pat_finalidade */
/*****************************************************************************
** Procedure Interna.....: pi_criacao_bem_pat_ccusto
** Descricao.............: pi_criacao_bem_pat_ccusto
** Criado por............: bre18732
** Criado em.............: 05/12/2000 19:12:35
** Alterado por..........: fut42929
** Alterado em...........: 05/10/2012 16:17:06
*****************************************************************************/
PROCEDURE pi_criacao_bem_pat_ccusto:

    assign v_cod_plano_ccusto = ""
           v_cod_ccusto = "".
    if  v_cod_matriz_trad_ccusto_ext <> ""
    then do:
        find matriz_trad_ccusto_ext
            where matriz_trad_ccusto_ext.cod_empresa = v_cod_empresa
            and   matriz_trad_ccusto_ext.cod_matriz_trad_ccusto_ext = v_cod_matriz_trad_ccusto_ext
            no-lock no-error.
        if  not avail matriz_trad_ccusto_ext
        then do:
            create tt_erros_criacao_bem_pat_api_1.
            assign tt_erros_criacao_bem_pat_api_1.tta_cod_unid_organ_ext = tt_criacao_bem_pat_api_6.tta_cod_unid_organ_ext
                   tt_erros_criacao_bem_pat_api_1.tta_cod_cta_pat        = tt_criacao_bem_pat_api_6.tta_cod_cta_pat
                   tt_erros_criacao_bem_pat_api_1.tta_num_bem_pat        = tt_criacao_bem_pat_api_6.tta_num_bem_pat
                   tt_erros_criacao_bem_pat_api_1.tta_num_seq_bem_pat    = tt_criacao_bem_pat_api_6.tta_num_seq_bem_pat
                   tt_erros_criacao_bem_pat_api_1.tta_des_bem_pat        = tt_criacao_bem_pat_api_6.tta_des_bem_pat
                   tt_erros_criacao_bem_pat_api_1.tta_dat_aquis_bem_pat  = tt_criacao_bem_pat_api_6.tta_dat_aquis_bem_pat
                   tt_erros_criacao_bem_pat_api_1.tta_cod_finalid_econ_ext = tt_criacao_bem_pat_api_6.tta_cod_finalid_econ_ext
                   .
            assign tt_erros_criacao_bem_pat_api_1.ttv_des_mensagem       = getStrTrans("Matriz de Traduá∆o de Centros de Custo Externos Inv†lida !", "FAS") /*1622*/
                   tt_criacao_bem_pat_api_6.ttv_log_erro = yes
                   v_log_erro_validac = yes.
            return "NOK" /*l_nok*/ .
        end /* if */.
        find trad_ccusto_ext
            where trad_ccusto_ext.cod_empresa = v_cod_empresa
            and   trad_ccusto_ext.cod_matriz_trad_ccusto_ext = matriz_trad_ccusto_ext.cod_matriz_trad_ccusto_ext
            and   trad_ccusto_ext.cod_ccusto_ext = tt_criacao_bem_pat_api_6.tta_cod_ccusto_ext
            no-lock no-error.
        if  not avail trad_ccusto_ext
        then do:
            create tt_erros_criacao_bem_pat_api_1.
            assign tt_erros_criacao_bem_pat_api_1.tta_cod_unid_organ_ext = tt_criacao_bem_pat_api_6.tta_cod_unid_organ_ext
                   tt_erros_criacao_bem_pat_api_1.tta_cod_cta_pat        = tt_criacao_bem_pat_api_6.tta_cod_cta_pat
                   tt_erros_criacao_bem_pat_api_1.tta_num_bem_pat        = tt_criacao_bem_pat_api_6.tta_num_bem_pat
                   tt_erros_criacao_bem_pat_api_1.tta_num_seq_bem_pat    = tt_criacao_bem_pat_api_6.tta_num_seq_bem_pat
                   tt_erros_criacao_bem_pat_api_1.tta_des_bem_pat        = tt_criacao_bem_pat_api_6.tta_des_bem_pat
                   tt_erros_criacao_bem_pat_api_1.tta_dat_aquis_bem_pat  = tt_criacao_bem_pat_api_6.tta_dat_aquis_bem_pat
                   tt_erros_criacao_bem_pat_api_1.tta_cod_finalid_econ_ext = tt_criacao_bem_pat_api_6.tta_cod_finalid_econ_ext
                   .
            assign tt_erros_criacao_bem_pat_api_1.ttv_des_mensagem = substitute(getStrTrans("N∆o existe traduá∆o para o Centro Custo Externo &1 !", "FAS") /*4675*/, tt_criacao_bem_pat_api_6.tta_cod_ccusto_ext)
                   tt_criacao_bem_pat_api_6.ttv_log_erro = yes
                   v_log_erro_validac = yes.
            return "NOK" /*l_nok*/ .
        end /* if */.
        if  tt_criacao_bem_pat_api_6.tta_cod_plano_ccusto <> "" and
             tt_criacao_bem_pat_api_6.tta_cod_plano_ccusto <> trad_ccusto_ext.cod_plano_ccusto
        then do:
             create tt_erros_criacao_bem_pat_api_1.
             assign tt_erros_criacao_bem_pat_api_1.tta_cod_unid_organ_ext = tt_criacao_bem_pat_api_6.tta_cod_unid_organ_ext
                    tt_erros_criacao_bem_pat_api_1.tta_cod_cta_pat        = tt_criacao_bem_pat_api_6.tta_cod_cta_pat
                    tt_erros_criacao_bem_pat_api_1.tta_num_bem_pat        = tt_criacao_bem_pat_api_6.tta_num_bem_pat
                    tt_erros_criacao_bem_pat_api_1.tta_num_seq_bem_pat    = tt_criacao_bem_pat_api_6.tta_num_seq_bem_pat
                    tt_erros_criacao_bem_pat_api_1.tta_des_bem_pat        = tt_criacao_bem_pat_api_6.tta_des_bem_pat
                    tt_erros_criacao_bem_pat_api_1.tta_dat_aquis_bem_pat  = tt_criacao_bem_pat_api_6.tta_dat_aquis_bem_pat
                    tt_erros_criacao_bem_pat_api_1.tta_cod_finalid_econ_ext = tt_criacao_bem_pat_api_6.tta_cod_finalid_econ_ext
                    .
             assign tt_erros_criacao_bem_pat_api_1.ttv_des_mensagem = getStrTrans("Plano CCusto informado Ç diferente da traduá∆o para CCusto !", "FAS") /*4676*/
                    tt_criacao_bem_pat_api_6.ttv_log_erro = yes
                    v_log_erro_validac = yes.
             return "NOK" /*l_nok*/ .
        end /* if */.
        assign v_cod_plano_ccusto = trad_ccusto_ext.cod_plano_ccusto
               v_cod_ccusto       = trad_ccusto_ext.cod_ccusto
               tt_criacao_bem_pat_api_6.tta_cod_plano_ccusto = trad_ccusto_ext.cod_plano_ccusto
               tt_criacao_bem_pat_api_6.tta_cod_ccusto_ext = trad_ccusto_ext.cod_ccusto.
    end /* if */.
    else do:
        &if defined(BF_FIN_AUMENTO_DIGITO_CCUSTO) &then
            if tt_criacao_bem_pat_api_6.tta_cod_plano_ccusto = "" /*l_*/  then do:
                find first plano_ccusto where 
                           plano_ccusto.cod_empresa     = v_cod_empresa and
                           plano_ccusto.dat_inic_valid <= tt_criacao_bem_pat_api_6.tta_dat_aquis_bem_pat and
                           plano_ccusto.dat_fim_valid  >= tt_criacao_bem_pat_api_6.tta_dat_aquis_bem_pat no-lock no-error.
                if avail plano_ccusto then
                    assign tt_criacao_bem_pat_api_6.tta_cod_plano_ccusto =  plano_ccusto.cod_plano_ccusto.
                else do:
                    create tt_erros_criacao_bem_pat_api_1.
                    assign tt_erros_criacao_bem_pat_api_1.tta_cod_unid_organ_ext = tt_criacao_bem_pat_api_6.tta_cod_unid_organ_ext
                           tt_erros_criacao_bem_pat_api_1.tta_cod_cta_pat        = tt_criacao_bem_pat_api_6.tta_cod_cta_pat
                           tt_erros_criacao_bem_pat_api_1.tta_num_bem_pat        = tt_criacao_bem_pat_api_6.tta_num_bem_pat
                           tt_erros_criacao_bem_pat_api_1.tta_num_seq_bem_pat    = tt_criacao_bem_pat_api_6.tta_num_seq_bem_pat
                           tt_erros_criacao_bem_pat_api_1.tta_des_bem_pat        = tt_criacao_bem_pat_api_6.tta_des_bem_pat
                           tt_erros_criacao_bem_pat_api_1.tta_dat_aquis_bem_pat  = tt_criacao_bem_pat_api_6.tta_dat_aquis_bem_pat
                           tt_erros_criacao_bem_pat_api_1.tta_cod_finalid_econ_ext = tt_criacao_bem_pat_api_6.tta_cod_finalid_econ_ext
                           .
                    assign tt_erros_criacao_bem_pat_api_1.ttv_des_mensagem = substitute(getStrTrans("Plano de centro de custo &1 n∆o esta cadastrado para empresa &2, ou a data &3 esta fora da validade.", "FAS") /*14327*/, "" /*l_*/ , v_cod_empresa, tt_criacao_bem_pat_api_6.tta_dat_aquis_bem_pat)
                           tt_criacao_bem_pat_api_6.ttv_log_erro = yes
                           v_log_erro_validac = yes.
                     return "NOK" /*l_nok*/ .
                 end.

            end.     
        &endif
        find ccusto
            where ccusto.cod_empresa = v_cod_empresa
            and   ccusto.cod_plano_ccusto = tt_criacao_bem_pat_api_6.tta_cod_plano_ccusto
            and   ccusto.cod_ccusto = tt_criacao_bem_pat_api_6.tta_cod_ccusto
            no-lock no-error.
        if  not avail ccusto
        then do:
            create tt_erros_criacao_bem_pat_api_1.
            assign tt_erros_criacao_bem_pat_api_1.tta_cod_unid_organ_ext = tt_criacao_bem_pat_api_6.tta_cod_unid_organ_ext
                   tt_erros_criacao_bem_pat_api_1.tta_cod_cta_pat        = tt_criacao_bem_pat_api_6.tta_cod_cta_pat
                   tt_erros_criacao_bem_pat_api_1.tta_num_bem_pat        = tt_criacao_bem_pat_api_6.tta_num_bem_pat
                   tt_erros_criacao_bem_pat_api_1.tta_num_seq_bem_pat    = tt_criacao_bem_pat_api_6.tta_num_seq_bem_pat
                   tt_erros_criacao_bem_pat_api_1.tta_des_bem_pat        = tt_criacao_bem_pat_api_6.tta_des_bem_pat
                   tt_erros_criacao_bem_pat_api_1.tta_dat_aquis_bem_pat  = tt_criacao_bem_pat_api_6.tta_dat_aquis_bem_pat
                   tt_erros_criacao_bem_pat_api_1.tta_cod_finalid_econ_ext = tt_criacao_bem_pat_api_6.tta_cod_finalid_econ_ext
                   .
            assign tt_erros_criacao_bem_pat_api_1.ttv_des_mensagem       = getStrTrans("Centro de Custo inv†lido para Plano Centro de Custo !", "FAS") /*1370*/
                   tt_criacao_bem_pat_api_6.ttv_log_erro = yes
                   v_log_erro_validac = yes.
            return "NOK" /*l_nok*/ .
        end /* if */.
        assign v_cod_plano_ccusto = tt_criacao_bem_pat_api_6.tta_cod_plano_ccusto
               v_cod_ccusto       = tt_criacao_bem_pat_api_6.tta_cod_ccusto.
    end /* else */.

    return "OK" /*l_ok*/ .
END PROCEDURE. /* pi_criacao_bem_pat_ccusto */
/*****************************************************************************
** Procedure Interna.....: pi_incrementa_primeiro_num_seq_bem_pat_livre
** Descricao.............: pi_incrementa_primeiro_num_seq_bem_pat_livre
** Criado por............: fut1228
** Criado em.............: 18/04/2005 14:43:26
** Alterado por..........: fut1228
** Alterado em...........: 29/04/2005 12:44:24
*****************************************************************************/
PROCEDURE pi_incrementa_primeiro_num_seq_bem_pat_livre:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_empresa
        as character
        format "x(3)"
        no-undo.
    def Input param p_cod_cta_pat
        as character
        format "x(18)"
        no-undo.
    def Input param p_cod_estab
    &IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.07A" &THEN
        as character
        format "x(3)"
    &ENDIF
    &IF "{&emsfin_version}" >= "5.07A" AND "{&emsfin_version}" < "9.99" &THEN
        as Character
        format "x(5)"
    &ENDIF
        no-undo.
    def input-output param p_num_bem_pat
        as integer
        format ">>>>>>>>9"
        no-undo.
    def output param p_num_seq_bem_pat
        as integer
        format ">>>>9"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_num_bem_pat_inic
        as integer
        format ">>>>>>>>9":U
        label "Bem Inicial"
        no-undo.
    def var v_num_seq_bem_pat_fim
        as integer
        format ">>>>9":U
        initial 99999
        label "Incorp Pat Final"
        column-label "Sequància"
        no-undo.
    def var v_num_seq_bem_pat_novo
        as integer
        format ">>>>9":U
        label "Nova Sequància Bem"
        column-label "Nova Sequància Bem"
        no-undo.


    /************************** Variable Definition End *************************/

    find last param_geral_pat no-lock no-error.
    assign v_num_bem_pat_inic = p_num_bem_pat.
    do v_num_seq_bem_pat_novo = 0 to v_num_seq_bem_pat_fim:

        if  param_geral_pat.ind_numer_niv = "Global" /*l_global*/  
        then do:
            find first b_bem_pat_proximo no-lock
                where b_bem_pat_proximo.num_bem_pat = v_num_bem_pat_inic
                  and b_bem_pat_proximo.num_seq_bem_pat = v_num_seq_bem_pat_novo

            &if '{&emsfin_version}' >= '5.01' &then
                use-index bempat_bem
            &endif
            no-error.
        end /* if */.
        else do:
            if  param_geral_pat.ind_numer_niv = "Por Empresa" /*l_por_empresa*/ 
            then do: 
                find first b_bem_pat_proximo no-lock
                     where b_bem_pat_proximo.cod_empresa = p_cod_empresa
                       and b_bem_pat_proximo.num_bem_pat = v_num_bem_pat_inic
                       and b_bem_pat_proximo.num_seq_bem_pat = v_num_seq_bem_pat_novo
                &if '{&emsfin_version}' >= '5.01' &then
                     use-index bempat_emp
                &endif
                no-error.
            end /* if */.
            else do:
                if  param_geral_pat.ind_numer_niv = "Por Conta" /*l_por_conta*/ 
                then do: 
                    find first b_bem_pat_proximo no-lock
                         where b_bem_pat_proximo.cod_empresa = p_cod_empresa 
                           and b_bem_pat_proximo.cod_cta_pat = p_cod_cta_pat
                           and b_bem_pat_proximo.num_bem_pat = v_num_bem_pat_inic
                           and b_bem_pat_proximo.num_seq_bem_pat = v_num_seq_bem_pat_novo
                    &if '{&emsfin_version}' >= '5.01' &then
                         use-index bempat_id
                    &endif
                    no-error.
                end /* if */.
                else do:
                    if  param_geral_pat.ind_numer_niv = "Por Estabelecimento" /*l_por_estabelecimento*/ 
                    then do:
                        find first b_bem_pat_proximo no-lock
                             where b_bem_pat_proximo.cod_estab = p_cod_estab
                               and b_bem_pat_proximo.num_bem_pat = v_num_bem_pat_inic
                               and b_bem_pat_proximo.num_seq_bem_pat = v_num_seq_bem_pat_novo
                        &if '{&emsfin_version}' >= '5.01' &then
                             use-index bempat_estab
                        &endif
                        no-error.
                    end /* if */.
                end /* else */.
            end /* else */.
        end /* else */.

        if  not avail b_bem_pat_proximo
        then do:
            assign p_num_seq_bem_pat = v_num_seq_bem_pat_novo
                   p_num_bem_pat = v_num_bem_pat_inic.
            leave.
        end /* if */.

        if  v_num_seq_bem_pat_novo = 99999 then
            assign v_num_seq_bem_pat_novo = 0
                   v_num_bem_pat_inic = v_num_bem_pat_inic + 1.

        if  v_num_bem_pat_inic > 999999999 then 
            assign v_num_bem_pat_inic = 0.
    end.
END PROCEDURE. /* pi_incrementa_primeiro_num_seq_bem_pat_livre */
/*****************************************************************************
** Procedure Interna.....: pi_verifica_bem_existente
** Descricao.............: pi_verifica_bem_existente
** Criado por............: fut40088
** Criado em.............: 09/03/2006 11:40:22
** Alterado por..........: fut40088
** Alterado em...........: 10/03/2006 10:42:53
*****************************************************************************/
PROCEDURE pi_verifica_bem_existente:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_empresa
        as character
        format "x(3)"
        no-undo.
    def Input param p_cod_cta_pat
        as character
        format "x(18)"
        no-undo.
    def Input param p_cod_estab
    &IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.07A" &THEN
        as character
        format "x(3)"
    &ENDIF
    &IF "{&emsfin_version}" >= "5.07A" AND "{&emsfin_version}" < "9.99" &THEN
        as Character
        format "x(5)"
    &ENDIF
        no-undo.
    def input param p_num_bem_pat
        as integer
        format ">>>>>>>>9"
        no-undo.
    def input param p_num_seq_bem_pat
        as integer
        format ">>>>9"
        no-undo.
    def output param p_log_return
        as logical
        format "Sim/N∆o"
        no-undo.


    /************************* Parameter Definition End *************************/

    if  param_geral_pat.ind_numer_niv = "Global" /*l_global*/ 
    then do:  
        find first b_bem_pat_proximo no-lock
            where b_bem_pat_proximo.num_bem_pat = p_num_bem_pat
            and   b_bem_pat_proximo.num_seq_bem_pat = p_num_seq_bem_pat

       &if '{&emsfin_version}' >= '5.01' &then
             use-index bempat_bem
       &endif
            no-error.
    end /* if */.
    else do:
        if  param_geral_pat.ind_numer_niv = "Por Empresa" /*l_por_empresa*/ 
        then do:
            find first b_bem_pat_proximo no-lock
                where b_bem_pat_proximo.cod_empresa = p_cod_empresa
                    and b_bem_pat_proximo.num_bem_pat = p_num_bem_pat
                    and b_bem_pat_proximo.num_seq_bem_pat = p_num_seq_bem_pat
            &if '{&emsfin_version}' >= '5.01' &then
                 use-index bempat_bem
            &endif
            no-error.
        end /* if */.
        else do:
             if  param_geral_pat.ind_numer_niv = "Por Conta" /*l_por_conta*/ 
             then do:
                 find first b_bem_pat_proximo no-lock
                     where b_bem_pat_proximo.cod_empresa = p_cod_empresa 
                         and b_bem_pat_proximo.cod_cta_pat = p_cod_cta_pat
                         and b_bem_pat_proximo.num_bem_pat = p_num_bem_pat
                         and b_bem_pat_proximo.num_seq_bem_pat = p_num_seq_bem_pat
                 &if '{&emsfin_version}' >= '5.01' &then
                     use-index bempat_bem
                 &endif
                 no-error.
             end /* if */.
             else do:
                 if  param_geral_pat.ind_numer_niv = "Por Estabelecimento" /*l_por_estabelecimento*/ 
                 then do: 
                     find first b_bem_pat_proximo no-lock
                          where b_bem_pat_proximo.cod_estab = p_cod_estab
                              and b_bem_pat_proximo.num_bem_pat = p_num_bem_pat
                              and b_bem_pat_proximo.num_seq_bem_pat = p_num_seq_bem_pat
                     &if '{&emsfin_version}' >= '5.01' &then
                         use-index bempat_bem
                     &endif
                     no-error.
                 end /* if */.
             end /* else */.
        end /* else */.
    end /* else */.
    if avail b_bem_pat_proximo then
       assign p_log_return = yes.
    else
       assign p_log_return = no.

END PROCEDURE. /* pi_verifica_bem_existente */
/*****************************************************************************
** Procedure Interna.....: pi_trata_retorno_fnc_aprop_ctbl_pat_criar
** Descricao.............: pi_trata_retorno_fnc_aprop_ctbl_pat_criar
** Criado por............: fut35059
** Criado em.............: 09/05/2006 14:25:48
** Alterado por..........: fut41422
** Alterado em...........: 12/02/2015 08:52:58
*****************************************************************************/
PROCEDURE pi_trata_retorno_fnc_aprop_ctbl_pat_criar:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_return
        as character
        format "x(40)"
        no-undo.
    def output param p_des_mensagem
        as character
        format "x(50)"
        no-undo.


    /************************* Parameter Definition End *************************/

    /* case_block: */
    case entry(1,p_cod_return, chr(10)):
        when "950" then
            code_block:
            do:
                assign p_des_mensagem = substitute(getStrTrans("Unidade Neg¢cio &1 n∆o encontrada para Estabelecimento &2 !", "FAS") /*950*/,
                                         GetEntryField(2, p_cod_return, chr(10)), 
                                         GetEntryField(3, p_cod_return, chr(10))) 
                                        + chr(10) + getStrTrans("Unidade de Neg¢cio n∆o habilitada para o Estabelecimento. Verifique na Manutená∆o de Estabelecimentos, no programa de Formaá∆o de Unidades de Neg¢cio do Estabeleciemnto, se a Unidade de Neg¢cio est† cadastrada para este Estabelecimento.", "FAS") /*950*/.
            end /* do code_block */. 
        when "1111" then
            code_block:
            do:
                assign p_des_mensagem = getStrTrans("ParÉmetro Contabilizaá∆o da Conta Patrimonial n∆o cadastrado !", "FAS") /*1111*/ + chr(10) +
                                        substitute(getStrTrans("N∆o foi encontrado um parÉmetro de contabilizaá∆o para conta patrimonial &1, finalidade cont†bil &2, finalidade econìmica &3 e no cen†rio cont†bil &4." + chr(10) +
    "Consulte os parÉmetros de contabilizaá∆o e cadastre uma conta cont†bil para a finalidade n∆o encontrada.", "FAS") /*1111*/,
                                         GetEntryField(2,p_cod_return, chr(10)), 
                                         GetEntryField(3,p_cod_return, chr(10)), 
                                         GetEntryField(4,p_cod_return, chr(10)), 
                                         GetEntryField(5,p_cod_return, chr(10))).
            end /* do code_block */.
        when "1253" then
            code_block:
            do:
                assign p_des_mensagem = substitute(getStrTrans("Centro Custo &1 Inv†lido para a Unidade Neg¢cio &2 !", "FAS") /*1253*/,
                                         GetEntryField(2, p_cod_return, chr(10)), 
                                         GetEntryField(3, p_cod_return, chr(10))) + chr(10) +
                                        substitute(getStrTrans("O centro de custo n∆o pode ser utilizado com a Unidade de Neg¢cio informada." + chr(10) +
    "Caso sua informaá∆o esteja correta, verifique as Unidades de Neg¢cio e Unidades de Neg¢cio do Centro de Custo, na Manutená∆o de  Centros de Custo." + chr(10) +
    "Verifique o centro de custo &1 e a Unidade de neg¢cio &2" + chr(10) +
    "", "FAS") /*1253*/,
                                         GetEntryField(2, p_cod_return, chr(10)), 
                                         GetEntryField(3, p_cod_return, chr(10))).
            end /* do code_block */.
        when "1388" then
            code_block:
            do:
                assign p_des_mensagem = substitute(getStrTrans("Existe restriá∆o deste ccusto no estabelecimento: &1 !", "FAS") /*1388*/,
                                         GetEntryField(2, p_cod_return, chr(10))) + chr(10) + 
                                        getStrTrans("Existe restriá∆o de utilizaá∆o deste centro de custo, no estabelecimento &1. Verificar na Manutená∆o de Centros de Custo as restriá‰es.", "FAS") /*1388*/.
            end /* do code_block */.        
        when "3347" then
            code_block:
            do:
                assign p_des_mensagem = substitute(getStrTrans("Conta Cont†bil &1 n∆o utiliza o Centro de Custo &2 !", "FAS") /*3347*/,
                                         GetEntryField(2, p_cod_return, chr(10)), 
                                         GetEntryField(3, p_cod_return, chr(10))).
            end /* do code_block */.

        when "5729" then
            code_block:
            do:
                assign p_des_mensagem = substitute(getStrTrans("Existe restriá∆o do ccusto &1 no estabelecimento: &2 !", "FAS") /*5729*/,
                                         GetEntryField(2, p_cod_return, chr(10)), 
                                         GetEntryField(3, p_cod_return, chr(10))) + chr(10) + 
                                        substitute(getStrTrans("Existe restriá∆o de utilizaá∆o do centro de custo &1, no estabelecimento &2. Verificar na Manutená∆o de Centros de Custo as restriá‰es.", "FAS") /*5729*/,
                                         GetEntryField(2, p_cod_return, chr(10)), 
                                         GetEntryField(3, p_cod_return, chr(10))).
            end /* do code_block */.
        when "13431" then
            code_block:
            do:
                assign p_des_mensagem = substitute(getStrTrans("Unidade Neg¢cio &1 n∆o encontrada para Estabelecimento &2 !", "FAS") /*13431*/,
                                         GetEntryField(2, p_cod_return, chr(10)), 
                                         GetEntryField(3, p_cod_return, chr(10))) 
                                         + chr(10) + getStrTrans("A Unidade de Neg¢cio da Alocaá∆o do Bem n∆o est† habilitada para o Estabelecimento. Verifique na Manutená∆o de Estabelecimentos, no programa de Formaá∆o de Unidades de Neg¢cio do Estabeleciemnto, se a Unidade de Neg¢cio est† cadastrada para este Estabelecimento.", "FAS") /*13431*/.
            end /* do code_block */.
        when "13812" then
            code_block:
            do:
                assign p_des_mensagem = getStrTrans("Conta Cont†bil est† fora do per°odo de validade !", "FAS") /*13812*/ + chr(10) +
                                        substitute(getStrTrans("O Bem &1/&2 da Conta Patrimonial &3 est† tentando apropriar na Conta Cont†bil &4 do Plano de Contas &5. PorÇm a mesma est† fora do per°odo de validade.", "FAS") /*13812*/,
                                         GetEntryField(2, p_cod_return, chr(10)), 
                                         GetEntryField(3, p_cod_return, chr(10)), 
                                         GetEntryField(4, p_cod_return, chr(10)), 
                                         GetEntryField(5, p_cod_return, chr(10)), 
                                         GetEntryField(6, p_cod_return, chr(10))).
            end /* do code_block */.
        when "14358" then
            code_block:
            do:
                assign p_des_mensagem = getStrTrans("Soma dos Percentuais Rateados deve ser 100% !", "FAS") /*14358*/ + chr(10) +
                                        getStrTrans("Verifique os valores dos percentuais informados na tela Alocaá‰es Bem Patrimonial, a soma deve ser igual a 100%.", "FAS") /*14358*/.
            end /* do code_block */.  
        when "18734" then
            code_block:
            do:
                assign p_des_mensagem = substitute(getStrTrans("Centro de Custo &1 inv†lido para a data de c†lculo &2.", "FAS") /*18734*/, GetEntryField(2, p_cod_return, chr(10)),
                                         GetEntryField(3, p_cod_return, chr(10)), 
                                         GetEntryField(4, p_cod_return, chr(10))) + chr(10) + 
                                        substitute(getStrTrans("Centro de custo &1 (Plano Centro de Custo &3), inv†lido para a data de c†lculo &2.", "FAS") /*18734*/, GetEntryField(2, p_cod_return, chr(10)),
                                         GetEntryField(3, p_cod_return, chr(10)), 
                                         GetEntryField(4, p_cod_return, chr(10))).
            end /* do code_block */. 
        when "19152" then
            code_block:
            do:
                assign p_des_mensagem = substitute(getStrTrans("Conta transferància &1 n∆o pode ser igual a conta de saldo.", "FAS") /*19152*/,
                                         GetEntryField(2, p_cod_return, chr(10))) + chr(10) + 
                                        substitute(getStrTrans("A conta cont†bil &1 de transferància est† igual a conta cont†bil de saldo imobilizado &2, (Cen†rio Cont†bil &3, Finalidade Cont†bil &4, Conta Patrimonial &5). " + chr(10) +
    "Alterar a conta cont†bil de transferància para uma conta diferente da conta de saldo imobilizado, acessar o programa de ParÉmetros de contabilizaá∆o (prgfin/fas/fas712aa.r) para fazer a alteraá∆o.", "FAS") /*19152*/,
                                         GetEntryField(2, p_cod_return, chr(10)),
                                         GetEntryField(3, p_cod_return, chr(10)),
                                         GetEntryField(4, p_cod_return, chr(10)), 
                                         GetEntryField(5, p_cod_return, chr(10)),
                                         GetEntryField(6, p_cod_return, chr(10))).
            end /* do code_block */.     
        when "19193" then
            code_block:
            do:
                assign p_des_mensagem = substitute(getStrTrans("Conta de saldo &1 n∆o pode ser igual a conta transferància.", "FAS") /*19193*/,
                                         GetEntryField(2, p_cod_return, chr(10))) + chr(10) + 
                                        substitute(getStrTrans("A conta cont†bil &1 de saldo imobilizado est† igual a conta cont†bil de transferància &2, (Cen†rio Cont†bil &3, Finalidade Cont†bil &4, Conta Patrimonial &5). " + chr(10) +
    "Alterar a conta cont†bil de saldo imobilizado  para uma conta diferente da conta de transferància, acessar o programa de ParÉmetros de contabilizaá∆o (prgfin/fas/fas712aa.r) para fazer a alteraá∆o.", "FAS") /*19193*/,
                                         GetEntryField(2, p_cod_return, chr(10)),
                                         GetEntryField(3, p_cod_return, chr(10)),
                                         GetEntryField(4, p_cod_return, chr(10)), 
                                         GetEntryField(5, p_cod_return, chr(10)),
                                         GetEntryField(6, p_cod_return, chr(10))).
            end /* do code_block */. 
        when "21196" then
            code_block:
            do:
                assign p_des_mensagem = substitute(getStrTrans("Conta Cont†bil &1 n∆o utiliza o Centro de Custo &2 !", "FAS") /*21196*/,
                                         GetEntryField(2, p_cod_return, chr(10)), 
                                         GetEntryField(3, p_cod_return, chr(10))) + chr(10) +
                                         substitute(getStrTrans("Verificar na Manutená∆o de CritÇrios de Distribuiá∆o da Conta Cont†bil, se a mesma, no estabelecimento: &4 utiliza  o  Centro de Custo &2 do Plano de CCusto &3, ou  se  CritÇrios  de Distribuiá∆o da  Conta  Cont†bil &1  n∆o  Ç  do  tipo Autom†tica para a data de movimento &5.", "FAS") /*21196*/,
                                         GetEntryField(2, p_cod_return, chr(10)), 
                                         GetEntryField(3, p_cod_return, chr(10)), 
                                         GetEntryField(4, p_cod_return, chr(10)), 
                                         GetEntryField(5, p_cod_return, chr(10)), 
                                         GetEntryField(6, p_cod_return, chr(10))).
            end /* do code_block */.
    end /* case case_block */.
END PROCEDURE. /* pi_trata_retorno_fnc_aprop_ctbl_pat_criar */
/*****************************************************************************
** Procedure Interna.....: pi_incrementa_bem_pat
** Descricao.............: pi_incrementa_bem_pat
** Criado por............: 
** Criado em.............: // 
** Alterado por..........: danielidk
** Alterado em...........: 27/04/2015 14:06:33
*****************************************************************************/
PROCEDURE pi_incrementa_bem_pat:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_empresa
        as character
        format "x(3)"
        no-undo.
    def Input param p_cod_cta_pat
        as character
        format "x(18)"
        no-undo.
    def Input param p_cod_estab
    &IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.07A" &THEN
        as character
        format "x(3)"
    &ENDIF
    &IF "{&emsfin_version}" >= "5.07A" AND "{&emsfin_version}" < "9.99" &THEN
        as Character
        format "x(5)"
    &ENDIF
        no-undo.
    def output param p_num_bem_pat
        as integer
        format ">>>>>>>>9"
        no-undo.
    def input-output param p_num_seq_bem_pat
        as integer
        format ">>>>9"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_log_return
        as logical
        format "Sim/N∆o"
        initial no
        no-undo.


    /************************** Variable Definition End *************************/

    find last param_geral_pat no-lock no-error.
    if  param_geral_pat.ind_numer_niv = "Global" /*l_global*/ 
    then do:
       find last b_bem_pat_proximo no-lock

    &if "{&emsfin_version}" >= "5.01" &then
            use-index bempat_bem
    &endif
             /*cl_ultimo_bem_global of b_bem_pat_proximo*/ no-error.
    end /* if */.
    else do:
       if  param_geral_pat.ind_numer_niv = "Por Empresa" /*l_por_empresa*/ 
       then do:
          find last b_bem_pat_proximo no-lock
               where b_bem_pat_proximo.cod_empresa = p_cod_empresa
    &if "{&emsfin_version}" >= "5.01" &then
               use-index bempat_emp
    &endif
                /*cl_ultimo_bem_empresa of b_bem_pat_proximo*/ no-error.
       end /* if */.
       else do:
          if  param_geral_pat.ind_numer_niv = "Por Conta" /*l_por_conta*/ 
          then do:
             find last b_bem_pat_proximo no-lock
                  where b_bem_pat_proximo.cod_empresa = p_cod_empresa
                    and b_bem_pat_proximo.cod_cta_pat = p_cod_cta_pat
    &if "{&emsfin_version}" >= "5.01" &then
                  use-index bempat_id
    &endif
                   /*cl_ultimo_bem_conta of b_bem_pat_proximo*/ no-error.
          end /* if */.
          else do:
             if  param_geral_pat.ind_numer_niv = "Por Estabelecimento" /*l_por_estabelecimento*/ 
             then do:
                find last b_bem_pat_proximo no-lock
                     where b_bem_pat_proximo.cod_estab = p_cod_estab
    &if "{&emsfin_version}" >= "5.01" &then
                     use-index bempat_estab
    &endif
                      /*cl_ultimo_bem_estab of b_bem_pat_proximo*/ no-error.
             end /* if */.
          end /* else */.
       end /* else */.
    end /* else */.




    if  avail param_geral_pat  and param_geral_pat.log_numer_autom
    then do:
        if  available b_bem_pat_proximo
        then do:
            assign p_num_bem_pat = b_bem_pat_proximo.num_bem_pat + 1
                   p_num_seq_bem_pat = b_bem_pat_proximo.num_seq_bem_pat.
            if  p_num_bem_pat > 999999999 then
                run pi_incrementa_primeiro_num_bem_pat_livre (Input p_cod_empresa,
                                                              Input p_cod_cta_pat,
                                                              Input p_cod_estab,
                                                              output p_num_bem_pat,
                                                              input-output p_num_seq_bem_pat) /*pi_incrementa_primeiro_num_bem_pat_livre*/.
        end /* if */.
        else
           assign p_num_bem_pat = 1.
    end /* if */.
    else do:
          assign p_num_bem_pat = 1.
          run pi_verifica_bem_existente (Input p_cod_empresa,
                                         Input p_cod_cta_pat,
                                         Input p_cod_estab,
                                         input p_num_bem_pat,
                                         input p_num_seq_bem_pat,
                                         output v_log_return) /*pi_verifica_bem_existente*/.
          if  v_log_return
          then do: 
              run pi_incrementa_primeiro_num_bem_pat_livre (Input p_cod_empresa,
                                                            Input p_cod_cta_pat,
                                                            Input p_cod_estab,
                                                            output p_num_bem_pat,
                                                            input-output p_num_seq_bem_pat) /*pi_incrementa_primeiro_num_bem_pat_livre*/.
          end /* if */.
    end /* else */.


END PROCEDURE. /* pi_incrementa_bem_pat */
/*****************************************************************************
** Procedure Interna.....: pi_incrementa_primeiro_num_bem_pat_livre
** Descricao.............: pi_incrementa_primeiro_num_bem_pat_livre
** Criado por............: fut1228
** Criado em.............: 18/04/2005 14:43:09
** Alterado por..........: danielidk
** Alterado em...........: 13/05/2015 17:33:55
*****************************************************************************/
PROCEDURE pi_incrementa_primeiro_num_bem_pat_livre:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_empresa
        as character
        format "x(3)"
        no-undo.
    def Input param p_cod_cta_pat
        as character
        format "x(18)"
        no-undo.
    def Input param p_cod_estab
    &IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.07A" &THEN
        as character
        format "x(3)"
    &ENDIF
    &IF "{&emsfin_version}" >= "5.07A" AND "{&emsfin_version}" < "9.99" &THEN
        as Character
        format "x(5)"
    &ENDIF
        no-undo.
    def output param p_num_bem_pat
        as integer
        format ">>>>>>>>9"
        no-undo.
    def input-output param p_num_seq_bem_pat
        as integer
        format ">>>>9"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_num_bem_pat_fim
        as integer
        format ">>>>>>>>9":U
        initial 999999999
        label "Bem Final"
        column-label "Bem"
        no-undo.
    def var v_num_bem_pat_inic
        as integer
        format ">>>>>>>>9":U
        label "Bem Inicial"
        no-undo.
    def var v_num_bem_pat_novo
        as integer
        format ">>>>>>>>9":U
        label "Novo N£mero Bem"
        column-label "Novo N£mero Bem"
        no-undo.
    def var v_num_seq_bem_pat
        as integer
        format ">>>>9":U
        initial 0
        label "Sequància Bem"
        column-label "Sequància"
        no-undo.


    /************************** Variable Definition End *************************/

    find last param_geral_pat no-lock no-error.
    Assign v_num_seq_bem_pat = p_num_seq_bem_pat
           v_num_bem_pat_inic = 0.
    if avail param_geral_pat and param_geral_pat.log_numer_autom then 
        assign v_num_bem_pat_novo = 0.
    else
        assign v_num_bem_pat_novo = 1.
    do v_num_bem_pat_inic = v_num_bem_pat_novo to v_num_bem_pat_fim:
        if  param_geral_pat.ind_numer_niv = "Global" /*l_global*/ 
        then do:
            find first b_bem_pat_proximo no-lock
                where b_bem_pat_proximo.num_bem_pat = v_num_bem_pat_inic
                and   b_bem_pat_proximo.num_seq_bem_pat = v_num_seq_bem_pat

            &if '{&emsfin_version}' >= '5.01' &then
                use-index bempat_bem
            &endif
            no-error.
        end /* if */.
        else do:
            if  param_geral_pat.ind_numer_niv = "Por Empresa" /*l_por_empresa*/ 
            then do: 
                find first b_bem_pat_proximo no-lock
                     where b_bem_pat_proximo.cod_empresa = p_cod_empresa
                       and b_bem_pat_proximo.num_bem_pat = v_num_bem_pat_inic
                       and b_bem_pat_proximo.num_seq_bem_pat = v_num_seq_bem_pat
                &if '{&emsfin_version}' >= '5.01' &then
                       use-index bempat_emp
                &endif
                no-error.
            end /* if */.
            else do:
                if  param_geral_pat.ind_numer_niv = "Por Conta" /*l_por_conta*/ 
                then do: 
                    find first b_bem_pat_proximo no-lock
                         where b_bem_pat_proximo.cod_empresa = p_cod_empresa 
                           and b_bem_pat_proximo.cod_cta_pat = p_cod_cta_pat
                           and b_bem_pat_proximo.num_bem_pat = v_num_bem_pat_inic
                           and b_bem_pat_proximo.num_seq_bem_pat = v_num_seq_bem_pat
                    &if '{&emsfin_version}' >= '5.01' &then
                           use-index bempat_id
                    &endif
                    no-error.
                end /* if */.
                else do:
                    if  param_geral_pat.ind_numer_niv = "Por Estabelecimento" /*l_por_estabelecimento*/ 
                    then do:
                        find first b_bem_pat_proximo no-lock
                             where b_bem_pat_proximo.cod_estab = p_cod_estab
                               and b_bem_pat_proximo.num_bem_pat = v_num_bem_pat_inic
                               and b_bem_pat_proximo.num_seq_bem_pat = v_num_seq_bem_pat
                        &if '{&emsfin_version}' >= '5.01' &then
                             use-index bempat_estab
                        &endif
                        no-error.
                    end /* if */.
                end /* else */.
            end /* else */.
        end /* else */.

        if not avail b_bem_pat_proximo
        then do:
          assign p_num_bem_pat = v_num_bem_pat_inic
                 p_num_seq_bem_pat = v_num_seq_bem_pat. 
          leave. 
        end /* if */.

        if  v_num_bem_pat_inic = 999999999 then
            assign v_num_bem_pat_inic = 0
                   v_num_seq_bem_pat = v_num_seq_bem_pat + 1.

        if  v_num_seq_bem_pat > 99999 then
            assign v_num_seq_bem_pat = 0.      
    End.
END PROCEDURE. /* pi_incrementa_primeiro_num_bem_pat_livre */
/*****************************************************************************
** Procedure Interna.....: pi_main_api_criacao_bem_pat_7
** Descricao.............: pi_main_api_criacao_bem_pat_7
** Criado por............: fut38629
** Criado em.............: 12/08/2009 11:19:37
** Alterado por..........: fut41675_3
** Alterado em...........: 21/07/2010 16:18:15
*****************************************************************************/
PROCEDURE pi_main_api_criacao_bem_pat_7:

    /************************ Parameter Definition Begin ************************/

    def Input param p_num_vers_integr_api
        as integer
        format ">>>>,>>9"
        no-undo.
    def Input param p_cod_matriz_trad_org_ext
        as character
        format "x(8)"
        no-undo.
    def Input param p_cod_matriz_trad_ccusto_ext
        as character
        format "x(8)"
        no-undo.
    def Input param p_cod_matriz_trad_finalid_ext
        as character
        format "x(8)"
        no-undo.
    def Input param p_log_ctbz
        as logical
        format "Sim/N∆o"
        no-undo.
    def Input param table 
        for tt_criacao_bem_pat_item_api.
    def output param p_cod_return
        as character
        format "x(40)"
        no-undo.
    def output param p_des_mensagem
        as character
        format "x(50)"
        no-undo.


    /************************* Parameter Definition End *************************/

    run pi_main_api_criacao_bem_pat_8 (input p_num_vers_integr_api, 
                                       input p_cod_matriz_trad_org_ext /* matriz traducao*/, 
                                       input p_cod_matriz_trad_ccusto_ext /* matriz ccusto*/,
                                       input p_cod_matriz_trad_finalid_ext /* matriz finalidade econ.*/,
                                       input p_log_ctbz /* contabiliza*/,
                                       input table tt_criacao_bem_pat_item_api,
                                       input table tt_criacao_bem_pat_val_resid,
                                       output p_cod_return,
                                       output p_des_mensagem).
END PROCEDURE. /* pi_main_api_criacao_bem_pat_7 */
/*****************************************************************************
** Procedure Interna.....: pi_validar_finalid_unid_organ
** Descricao.............: pi_validar_finalid_unid_organ
** Criado por............: 
** Criado em.............: // 
** Alterado por..........: fut1228
** Alterado em...........: 21/01/2004 19:31:53
*****************************************************************************/
PROCEDURE pi_validar_finalid_unid_organ:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_finalid_econ
        as character
        format "x(10)"
        no-undo.
    def Input param p_cod_unid_organ
    &IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.07A" &THEN
        as character
        format "x(3)"
    &ENDIF
    &IF "{&emsfin_version}" >= "5.07A" AND "{&emsfin_version}" < "9.99" &THEN
        as Character
        format "x(5)"
    &ENDIF
        no-undo.
    def Input param p_dat_transacao
        as date
        format "99/99/9999"
        no-undo.
    def output param p_cod_return
        as character
        format "x(40)"
        no-undo.


    /************************* Parameter Definition End *************************/

    /* Alterado para validar "finalid_unid_organ.dat_fim_valid >= p_dat_transacao", conforme Atividade 107753.
      Devido a lista de impacto desta PI ser muito extenáa, foi acordado que os demais 
      programas deveram ser alterados sobre demanda.*/

    find first finalid_unid_organ no-lock
         where finalid_unid_organ.cod_unid_organ = p_cod_unid_organ
           and finalid_unid_organ.cod_finalid_econ = p_cod_finalid_econ
           and finalid_unid_organ.dat_inic_valid <= p_dat_transacao
           and finalid_unid_organ.dat_fim_valid >= p_dat_transacao no-error.

    if  not avail finalid_unid_organ
    then do:
        assign p_cod_return = "338".
    end /* if */.
    else do:
        assign p_cod_return = "OK" /*l_ok*/ .
    end /* else */.
END PROCEDURE. /* pi_validar_finalid_unid_organ */
/*****************************************************************************
** Procedure Interna.....: pi_validar_bem_pat_item_docto_api
** Descricao.............: pi_validar_bem_pat_item_docto_api
** Criado por............: fut38629
** Criado em.............: 13/08/2009 09:48:44
** Alterado por..........: corp45591
** Alterado em...........: 07/10/2011 09:46:43
*****************************************************************************/
PROCEDURE pi_validar_bem_pat_item_docto_api:

    /************************** Buffer Definition Begin *************************/

    def buffer btt_criacao_bem_pat_item_api
        for tt_criacao_bem_pat_item_api.


    /*************************** Buffer Definition End **************************/

    /************************* Variable Definition Begin ************************/

    def var v_cod_indic_econ                 as character       no-undo. /*local*/
    def var v_ind_orig_docto                 as character       no-undo. /*local*/
    def var v_log_error                      as logical         no-undo. /*local*/
    def var v_num_cont                       as integer         no-undo. /*local*/
    def var v_num_ord_invest                 as integer         no-undo. /*local*/


    /************************** Variable Definition End *************************/

    find first tt_criacao_bem_pat_item_api
         where tt_criacao_bem_pat_item_api.ttv_rec_bem = recid(tt_criacao_bem_pat_api_6)
        no-error.

    if not avail tt_criacao_bem_pat_item_api then
        return "OK" /*l_ok*/ .

    for first docto_entr 
        fields(ind_orig_docto) no-lock
         where docto_entr.cod_estab      = v_cod_estab
           and docto_entr.cod_empresa    = v_cod_empresa
           and docto_entr.cdn_fornecedor = tt_criacao_bem_pat_item_api.tta_cdn_fornecedor
           and docto_entr.cod_docto_entr = tt_criacao_bem_pat_item_api.tta_cod_docto_entr
           and docto_entr.cod_ser_nota   = tt_criacao_bem_pat_item_api.tta_cod_ser_nota:
        assign v_ind_orig_docto = docto_entr.ind_orig_docto.
    end.

    if not avail docto_entr then do:

        /* Begin_Include: i_erros_api_criacao_bem_pat */
        create tt_erros_criacao_bem_pat_api_1.
        assign tt_erros_criacao_bem_pat_api_1.tta_cod_unid_organ_ext   = tt_criacao_bem_pat_api_6.tta_cod_unid_organ_ext
               tt_erros_criacao_bem_pat_api_1.tta_cod_cta_pat          = tt_criacao_bem_pat_api_6.tta_cod_cta_pat
               tt_erros_criacao_bem_pat_api_1.tta_num_bem_pat          = tt_criacao_bem_pat_api_6.tta_num_bem_pat
               tt_erros_criacao_bem_pat_api_1.tta_num_seq_bem_pat      = tt_criacao_bem_pat_api_6.tta_num_seq_bem_pat
               tt_erros_criacao_bem_pat_api_1.tta_des_bem_pat          = tt_criacao_bem_pat_api_6.tta_des_bem_pat
               tt_erros_criacao_bem_pat_api_1.tta_dat_aquis_bem_pat    = tt_criacao_bem_pat_api_6.tta_dat_aquis_bem_pat
               tt_erros_criacao_bem_pat_api_1.tta_cod_finalid_econ_ext = tt_criacao_bem_pat_api_6.tta_cod_finalid_econ_ext.

        /* End_Include: i_erros_api_criacao_bem_pat */

        assign tt_erros_criacao_bem_pat_api_1.ttv_des_mensagem  = substitute(getStrTrans("Documento de Entrada n∆o existe para o estabelecimento &1, empresa &2, fornecedor &3, documento &4 e sÇrie &5", "FAS") /*5032*/,
                                                                  v_cod_estab, v_cod_empresa, string(tt_criacao_bem_pat_item_api.tta_cdn_fornecedor),
                                                                  tt_criacao_bem_pat_item_api.tta_cod_docto_entr, tt_criacao_bem_pat_item_api.tta_cod_ser_nota).
        return "NOK" /*l_nok*/ .
    end.       

    for first item_docto_entr 
       fields (cod_indic_econ
               num_ord_invest) no-lock
        where item_docto_entr.cod_estab           = v_cod_estab
          and item_docto_entr.cod_empresa         = v_cod_empresa
          and item_docto_entr.cdn_fornecedor      = tt_criacao_bem_pat_item_api.tta_cdn_fornecedor
          and item_docto_entr.cod_docto_entr      = tt_criacao_bem_pat_item_api.tta_cod_docto_entr
          and item_docto_entr.cod_ser_nota        = tt_criacao_bem_pat_item_api.tta_cod_ser_nota
          and item_docto_entr.num_item_docto_entr = tt_criacao_bem_pat_item_api.tta_num_item_docto_entr:

        assign v_cod_indic_econ = item_docto_entr.cod_indic_econ
               v_num_ord_invest = item_docto_entr.num_ord_invest.

    end.

    /* Validaá∆o: Origem, Moeda e Ordem de Investimento */
    for each btt_criacao_bem_pat_item_api
       where btt_criacao_bem_pat_item_api.ttv_rec_bem = recid(tt_criacao_bem_pat_api_6):

       if recid(btt_criacao_bem_pat_item_api) = recid(tt_criacao_bem_pat_item_api) then
           next.

        for first docto_entr 
            fields(ind_orig_docto) no-lock
            where docto_entr.cod_estab      = v_cod_estab
              and docto_entr.cod_empresa    = v_cod_empresa
              and docto_entr.cdn_fornecedor = btt_criacao_bem_pat_item_api.tta_cdn_fornecedor
              and docto_entr.cod_docto_entr = btt_criacao_bem_pat_item_api.tta_cod_docto_entr
              and docto_entr.cod_ser_nota   = btt_criacao_bem_pat_item_api.tta_cod_ser_nota:

            if v_ind_orig_docto <> docto_entr.ind_orig_docto then do:

                /* Begin_Include: i_erros_api_criacao_bem_pat */
                create tt_erros_criacao_bem_pat_api_1.
                assign tt_erros_criacao_bem_pat_api_1.tta_cod_unid_organ_ext   = tt_criacao_bem_pat_api_6.tta_cod_unid_organ_ext
                       tt_erros_criacao_bem_pat_api_1.tta_cod_cta_pat          = tt_criacao_bem_pat_api_6.tta_cod_cta_pat
                       tt_erros_criacao_bem_pat_api_1.tta_num_bem_pat          = tt_criacao_bem_pat_api_6.tta_num_bem_pat
                       tt_erros_criacao_bem_pat_api_1.tta_num_seq_bem_pat      = tt_criacao_bem_pat_api_6.tta_num_seq_bem_pat
                       tt_erros_criacao_bem_pat_api_1.tta_des_bem_pat          = tt_criacao_bem_pat_api_6.tta_des_bem_pat
                       tt_erros_criacao_bem_pat_api_1.tta_dat_aquis_bem_pat    = tt_criacao_bem_pat_api_6.tta_dat_aquis_bem_pat
                       tt_erros_criacao_bem_pat_api_1.tta_cod_finalid_econ_ext = tt_criacao_bem_pat_api_6.tta_cod_finalid_econ_ext.

                /* End_Include: i_erros_api_criacao_bem_pat */

                assign tt_erros_criacao_bem_pat_api_1.ttv_des_mensagem  = getStrTrans("O conjunto de itens de documentos de entrada que far† a composiá∆o do bem precisa ter a mesma origem, o mesmo c¢digo de moeda e a mesma ordem de investimento.", "FAS") /*20054*/.
                return "NOK" /*l_nok*/ .
            end.         
        end.

        for first item_docto_entr 
           fields (cod_indic_econ
                   num_ord_invest) no-lock
            where item_docto_entr.cod_estab           = v_cod_estab
              and item_docto_entr.cod_empresa         = v_cod_empresa
              and item_docto_entr.cdn_fornecedor      = btt_criacao_bem_pat_item_api.tta_cdn_fornecedor
              and item_docto_entr.cod_docto_entr      = btt_criacao_bem_pat_item_api.tta_cod_docto_entr
              and item_docto_entr.cod_ser_nota        = btt_criacao_bem_pat_item_api.tta_cod_ser_nota
              and item_docto_entr.num_item_docto_entr = btt_criacao_bem_pat_item_api.tta_num_item_docto_entr:

            if v_cod_indic_econ <> item_docto_entr.cod_indic_econ or
               v_num_ord_invest <> item_docto_entr.num_ord_invest then do:

                /* Begin_Include: i_erros_api_criacao_bem_pat */
                create tt_erros_criacao_bem_pat_api_1.
                assign tt_erros_criacao_bem_pat_api_1.tta_cod_unid_organ_ext   = tt_criacao_bem_pat_api_6.tta_cod_unid_organ_ext
                       tt_erros_criacao_bem_pat_api_1.tta_cod_cta_pat          = tt_criacao_bem_pat_api_6.tta_cod_cta_pat
                       tt_erros_criacao_bem_pat_api_1.tta_num_bem_pat          = tt_criacao_bem_pat_api_6.tta_num_bem_pat
                       tt_erros_criacao_bem_pat_api_1.tta_num_seq_bem_pat      = tt_criacao_bem_pat_api_6.tta_num_seq_bem_pat
                       tt_erros_criacao_bem_pat_api_1.tta_des_bem_pat          = tt_criacao_bem_pat_api_6.tta_des_bem_pat
                       tt_erros_criacao_bem_pat_api_1.tta_dat_aquis_bem_pat    = tt_criacao_bem_pat_api_6.tta_dat_aquis_bem_pat
                       tt_erros_criacao_bem_pat_api_1.tta_cod_finalid_econ_ext = tt_criacao_bem_pat_api_6.tta_cod_finalid_econ_ext.

                /* End_Include: i_erros_api_criacao_bem_pat */

                assign tt_erros_criacao_bem_pat_api_1.ttv_des_mensagem  = getStrTrans("O conjunto de itens de documentos de entrada que far† a composiá∆o do bem precisa ter a mesma origem, o mesmo c¢digo de moeda e a mesma ordem de investimento.", "FAS") /*20054*/.
                return "NOK" /*l_nok*/ .
            end.

        end.    
    end.

    return "OK" /*l_ok*/ .
END PROCEDURE. /* pi_validar_bem_pat_item_docto_api */
/*****************************************************************************
** Procedure Interna.....: pi_atualiza_quant_item_docto_entr
** Descricao.............: pi_atualiza_quant_item_docto_entr
** Criado por............: fut38629
** Criado em.............: 04/08/2009 10:49:11
** Alterado por..........: fut38629
** Alterado em...........: 04/08/2009 15:42:08
*****************************************************************************/
PROCEDURE pi_atualiza_quant_item_docto_entr:

    /************************ Parameter Definition Begin ************************/

    def Input param p_rec_table
        as recid
        format ">>>>>>9"
        no-undo.
    def Input param p_num_quant_vincul
        as integer
        format ">>>>,>>9"
        no-undo.
    def Input param p_cod_acao
        as character
        format "x(8)"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************** Buffer Definition Begin *************************/

    &if "{&emsfin_version}" >= "1.00" &then
    def buffer b_item_docto_entr
        for item_docto_entr.
    &endif


    /*************************** Buffer Definition End **************************/

    /************************* Variable Definition Begin ************************/

    def var v_num_quant_aux                  as integer         no-undo. /*local*/


    /************************** Variable Definition End *************************/

    find first b_item_docto_entr exclusive-lock
         where recid(b_item_docto_entr) = p_rec_table
         no-error.

    if avail b_item_docto_entr then do:

        assign v_num_quant_aux = int(GetEntryField(5,b_item_docto_entr.cod_livre_1,chr(10))).

        if p_cod_acao = "Desvincula" /*l_desvincula*/  then do:
            assign v_num_quant_aux = v_num_quant_aux - p_num_quant_vincul.
        end.
        else do: /* Vincula */
            assign v_num_quant_aux = v_num_quant_aux + p_num_quant_vincul.
        end.

        assign b_item_docto_entr.cod_livre_1 = SetEntryField(5,b_item_docto_entr.cod_livre_1,chr(10),string(v_num_quant_aux)).

        /* Verifica se o item n∆o foi totalmente utilizado e atualiza o campo log_classif_item_docto_entr */
        if b_item_docto_entr.qtd_item_docto_entr <> int(GetEntryField(5,b_item_docto_entr.cod_livre_1,chr(10))) then
            assign b_item_docto_entr.log_classif_item_docto_entr = no.
        else 
            assign b_item_docto_entr.log_classif_item_docto_entr = yes.
    end.


END PROCEDURE. /* pi_atualiza_quant_item_docto_entr */
/*****************************************************************************
** Procedure Interna.....: pi_main_api_criacao_bem_pat_8
** Descricao.............: pi_main_api_criacao_bem_pat_8
** Criado por............: fut41675_3
** Criado em.............: 21/07/2010 16:03:26
** Alterado por..........: corp45591
** Alterado em...........: 07/10/2011 09:57:23
*****************************************************************************/
PROCEDURE pi_main_api_criacao_bem_pat_8:

    /************************ Parameter Definition Begin ************************/

    def Input param p_num_vers_integr_api
        as integer
        format ">>>>,>>9"
        no-undo.
    def Input param p_cod_matriz_trad_org_ext
        as character
        format "x(8)"
        no-undo.
    def Input param p_cod_matriz_trad_ccusto_ext
        as character
        format "x(8)"
        no-undo.
    def Input param p_cod_matriz_trad_finalid_ext
        as character
        format "x(8)"
        no-undo.
    def Input param p_log_ctbz
        as logical
        format "Sim/N∆o"
        no-undo.
    def Input param table 
        for tt_criacao_bem_pat_item_api.
    def Input param table 
        for tt_criacao_bem_pat_val_resid.
    def output param p_cod_return
        as character
        format "x(40)"
        no-undo.
    def output param p_des_mensagem
        as character
        format "x(50)"
        no-undo.


    /************************* Parameter Definition End *************************/

    FOR EACH tt_criacao_bem_pat_api_5 NO-LOCK:
      CREATE tt_criacao_bem_pat_api_6.
      BUFFER-COPY tt_criacao_bem_pat_api_5 TO tt_criacao_bem_pat_api_6. 
    END. 

    run pi_main_api_criacao_bem_pat_9 (input p_num_vers_integr_api, 
                                       input p_cod_matriz_trad_org_ext /* matriz traducao*/, 
                                       input p_cod_matriz_trad_ccusto_ext /* matriz ccusto*/,
                                       input p_cod_matriz_trad_finalid_ext /* matriz finalidade econ.*/,
                                       input p_log_ctbz /* contabiliza*/,
                                       input table tt_criacao_bem_pat_item_api,
                                       input table tt_criacao_bem_pat_val_resid,
                                       INPUT TABLE tt_criacao_bem_pat_api_6,
                                       output p_cod_return,
                                       output p_des_mensagem).
END PROCEDURE. /* pi_main_api_criacao_bem_pat_8 */
/*****************************************************************************
** Procedure Interna.....: pi_main_api_criacao_bem_pat_9
** Descricao.............: pi_main_api_criacao_bem_pat_9
** Criado por............: corp45591
** Criado em.............: 06/10/2011 10:42:59
** Alterado por..........: fut41422_1
** Alterado em...........: 11/09/2012 08:24:12
*****************************************************************************/
PROCEDURE pi_main_api_criacao_bem_pat_9:


    /************************ Parameter Definition Begin ************************/

    def Input param p_num_vers_integr_api
        as integer
        format ">>>>,>>9"
        no-undo.
    def Input param p_cod_matriz_trad_org_ext
        as character
        format "x(8)"
        no-undo.
    def Input param p_cod_matriz_trad_ccusto_ext
        as character
        format "x(8)"
        no-undo.
    def Input param p_cod_matriz_trad_finalid_ext
        as character
        format "x(8)"
        no-undo.
    def Input param p_log_ctbz
        as logical
        format "Sim/N∆o"
        no-undo.
    def Input param table 
        for tt_criacao_bem_pat_item_api.
    def Input param table 
        for tt_criacao_bem_pat_val_resid.
    def Input param table 
        for tt_criacao_bem_pat_api_6.
    def output param p_cod_return
        as character
        format "x(40)"
        no-undo.
    def output param p_des_mensagem
        as character
        format "x(50)"
        no-undo.


        /* ************************ Parameter Definition End *************************/

    assign v_cod_matriz_trad_ccusto_ext = p_cod_matriz_trad_ccusto_ext
           v_log_ctbz = p_log_ctbz.


    /* Begin_Include: i_vrf_funcao_cong_cenar_ctbl */
    assign v_log_funcao_congel_cenar_ctbl = no.

    if can-find(histor_exec_especial
          where histor_exec_especial.cod_modul_dtsul = "UFN" /*l_ufn*/ 
            and histor_exec_especial.cod_prog_dtsul  = 'SPP_CONG_CENAR_CTBL':U) then
        assign  v_log_funcao_congel_cenar_ctbl = yes.


    /* Begin_Include: i_funcao_extract */
    if  v_cod_arq <> '' and v_cod_arq <> ?
    then do:

        output stream s-arq to value(v_cod_arq) append.

        put stream s-arq unformatted
            'SPP_CONG_CENAR_CTBL':U      at 1 
            v_log_funcao_congel_cenar_ctbl  at 43 skip.

        output stream s-arq close.

    end /* if */.
    /* End_Include: i_funcao_extract */

    /* End_Include: i_funcao_extract */


    /* fut36887 - atividade 154749 - integraá∆o FAS x MRI*/
    FIND FIRST param_integr_ems 
         where param_integr_ems.ind_param_integr_ems = "MRI 2.00" /*l_mri*/ 
    NO-LOCK NO-ERROR.
    ASSIGN v_log_integr_ativ_fix = &IF DEFINED (BF_FIN_INTEGR_ATIVO_MRI) &THEN (AVAIL param_integr_ems)
                                   &ELSE GetDefinedFunction('SPP_INTEGR_ATIVO_MRI':U) AND (AVAIL param_integr_ems) &ENDIF.
    if  p_cod_matriz_trad_org_ext <> ""
    then do:
        find matriz_trad_org_ext
            where matriz_trad_org_ext.cod_matriz_trad_org_ext = p_cod_matriz_trad_org_ext
            no-lock no-error.
        if  not avail matriz_trad_org_ext
        then do:
            assign p_cod_return = "NOK" /*l_nok*/ 
                   p_des_mensagem = getStrTrans("Matriz da Unidade Organizacional n∆o cadastrada !", "FAS") /*691*/.
            return.
        end /* if */.
    end /* if */.
    if  p_cod_matriz_trad_finalid_ext <> ""
    then do:
        find matriz_trad_finalid_ext
            where matriz_trad_finalid_ext.cod_matriz_trad_finalid_ext = p_cod_matriz_trad_finalid_ext
            no-lock no-error.
        if  not avail matriz_trad_finalid_ext
        then do:
            assign p_cod_return = "NOK" /*l_nok*/ 
                   p_des_mensagem = getStrTrans("Matriz de Traduá∆o da Finalidade Econìmica Externa Inv†lida !", "FAS") /*1621*/.
            return.
        end /* if */.
    end /* if */.

    /* Localizaá∆o Colìmbia */
    assign v_log_localiz_col = GetDefinedFunction('SPP_LOCALIZ_COLOMBIA').

    if  v_log_localiz_col then do:
        /* Programa Persistente para funá‰es da Localizaá∆o Colìmbia */
        if not valid-handle(v_hdl_procedure)
            or v_hdl_procedure:type       <> 'procedure':U
            or v_hdl_procedure:file-name  <> 'prgfin/lco/lco003za.py':U
            then run prgfin/lco/lco003za.py persistent set v_hdl_procedure (INPUT '',
                                                                            INPUT '',
                                                                            INPUT 0,
                                                                            INPUT 0,
                                                                            INPUT '',
                                                                            INPUT 0).
    end.

    blk_bem:
    for each tt_criacao_bem_pat_api_6
        break by tt_criacao_bem_pat_api_6.tta_cod_unid_organ_ext
              by tt_criacao_bem_pat_api_6.tta_cod_estab_ext
              by tt_criacao_bem_pat_api_6.tta_cod_finalid_econ_ext
              by tt_criacao_bem_pat_api_6.tta_cod_plano_ccusto
              by tt_criacao_bem_pat_api_6.tta_cod_ccusto_ext:

        if  first-of(tt_criacao_bem_pat_api_6.tta_cod_unid_organ_ext)
        then do:
            assign v_cod_empresa = ""
                   v_log_erro_validac = no.
            if  avail matriz_trad_org_ext
            then do:
                find first tip_unid_organ no-lock
                    where tip_unid_organ.num_niv_unid_organ = 998 no-error.
                find trad_org_ext
                    where trad_org_ext.cod_matriz_trad_org_ext = matriz_trad_org_ext.cod_matriz_trad_org_ext
                    and   trad_org_ext.cod_tip_unid_organ      = tip_unid_organ.cod_tip_unid_organ
                    and   trad_org_ext.cod_unid_organ_ext      = tt_criacao_bem_pat_api_6.tta_cod_unid_organ_ext
                    no-lock no-error.
                if  not avail trad_org_ext
                then do:
                    create tt_erros_criacao_bem_pat_api_1.
                    assign tt_erros_criacao_bem_pat_api_1.tta_cod_unid_organ_ext = tt_criacao_bem_pat_api_6.tta_cod_unid_organ_ext
                           tt_erros_criacao_bem_pat_api_1.tta_cod_cta_pat        = tt_criacao_bem_pat_api_6.tta_cod_cta_pat
                           tt_erros_criacao_bem_pat_api_1.tta_num_bem_pat        = tt_criacao_bem_pat_api_6.tta_num_bem_pat
                           tt_erros_criacao_bem_pat_api_1.tta_num_seq_bem_pat    = tt_criacao_bem_pat_api_6.tta_num_seq_bem_pat
                           tt_erros_criacao_bem_pat_api_1.tta_des_bem_pat        = tt_criacao_bem_pat_api_6.tta_des_bem_pat
                           tt_erros_criacao_bem_pat_api_1.tta_dat_aquis_bem_pat  = tt_criacao_bem_pat_api_6.tta_dat_aquis_bem_pat
                           tt_erros_criacao_bem_pat_api_1.tta_cod_finalid_econ_ext = tt_criacao_bem_pat_api_6.tta_cod_finalid_econ_ext
                           .
                    assign tt_erros_criacao_bem_pat_api_1.ttv_des_mensagem = substitute(getStrTrans("N∆o existe traduá∆o para a Empresa Externa &1 !", "FAS") /*1733*/, tt_criacao_bem_pat_api_6.tta_cod_unid_organ_ext)
                           tt_criacao_bem_pat_api_6.ttv_log_erro = yes
                           v_log_erro_validac = yes.
                    next blk_bem.
                end /* if */.
                assign v_cod_empresa = trad_org_ext.cod_unid_organ
                       tt_criacao_bem_pat_api_6.tta_cod_unid_organ_ext = trad_org_ext.cod_unid_organ.
            end /* if */.
            else do:
                find empresa
                    where empresa.cod_empresa = tt_criacao_bem_pat_api_6.tta_cod_unid_organ_ext
                    no-lock no-error.
                if  not avail empresa
                then do:
                    create tt_erros_criacao_bem_pat_api_1.
                    assign tt_erros_criacao_bem_pat_api_1.tta_cod_unid_organ_ext = tt_criacao_bem_pat_api_6.tta_cod_unid_organ_ext
                           tt_erros_criacao_bem_pat_api_1.tta_cod_cta_pat        = tt_criacao_bem_pat_api_6.tta_cod_cta_pat
                           tt_erros_criacao_bem_pat_api_1.tta_num_bem_pat        = tt_criacao_bem_pat_api_6.tta_num_bem_pat
                           tt_erros_criacao_bem_pat_api_1.tta_num_seq_bem_pat    = tt_criacao_bem_pat_api_6.tta_num_seq_bem_pat
                           tt_erros_criacao_bem_pat_api_1.tta_des_bem_pat        = tt_criacao_bem_pat_api_6.tta_des_bem_pat
                           tt_erros_criacao_bem_pat_api_1.tta_dat_aquis_bem_pat  = tt_criacao_bem_pat_api_6.tta_dat_aquis_bem_pat
                           tt_erros_criacao_bem_pat_api_1.tta_cod_finalid_econ_ext = tt_criacao_bem_pat_api_6.tta_cod_finalid_econ_ext
                           .
                    assign tt_erros_criacao_bem_pat_api_1.ttv_des_mensagem    = getStrTrans("Empresa externa inexistente !", "FAS") /*2549*/
                           tt_criacao_bem_pat_api_6.ttv_log_erro = yes
                           v_log_erro_validac = yes.
                    next blk_bem.
                end /* if */.
                assign v_cod_empresa = tt_criacao_bem_pat_api_6.tta_cod_unid_organ_ext.
            end /* else */.
        end /* if */.
        if  first-of(tt_criacao_bem_pat_api_6.tta_cod_estab_ext)
        then do:
            assign v_cod_estab = "".
            if  avail matriz_trad_org_ext
            then do:
                find first tip_unid_organ no-lock
                     where tip_unid_organ.num_niv_unid_organ = 999 no-error.
                find trad_org_ext
                    where trad_org_ext.cod_matriz_trad_org_ext = matriz_trad_org_ext.cod_matriz_trad_org_ext
                    and   trad_org_ext.cod_tip_unid_organ      = tip_unid_organ.cod_tip_unid_organ
                    and   trad_org_ext.cod_unid_organ_ext      = tt_criacao_bem_pat_api_6.tta_cod_estab_ext
                    no-lock no-error.
                if  not avail trad_org_ext
                then do:
                    create tt_erros_criacao_bem_pat_api_1.
                    assign tt_erros_criacao_bem_pat_api_1.tta_cod_unid_organ_ext = tt_criacao_bem_pat_api_6.tta_cod_unid_organ_ext
                           tt_erros_criacao_bem_pat_api_1.tta_cod_cta_pat        = tt_criacao_bem_pat_api_6.tta_cod_cta_pat
                           tt_erros_criacao_bem_pat_api_1.tta_num_bem_pat        = tt_criacao_bem_pat_api_6.tta_num_bem_pat
                           tt_erros_criacao_bem_pat_api_1.tta_num_seq_bem_pat    = tt_criacao_bem_pat_api_6.tta_num_seq_bem_pat
                           tt_erros_criacao_bem_pat_api_1.tta_des_bem_pat        = tt_criacao_bem_pat_api_6.tta_des_bem_pat
                           tt_erros_criacao_bem_pat_api_1.tta_dat_aquis_bem_pat  = tt_criacao_bem_pat_api_6.tta_dat_aquis_bem_pat
                           tt_erros_criacao_bem_pat_api_1.tta_cod_finalid_econ_ext = tt_criacao_bem_pat_api_6.tta_cod_finalid_econ_ext
                           .
                    assign tt_erros_criacao_bem_pat_api_1.ttv_des_mensagem = substitute(getStrTrans("O Estabelecimento especificado &1 n∆o possui traduá∆o na matriz de traduá∆o de organizaá‰es externas informada &2.", "FAS") /*1734*/, tt_criacao_bem_pat_api_6.tta_cod_estab_ext,matriz_trad_org_ext.cod_matriz_trad_org_ext)
                           tt_criacao_bem_pat_api_6.ttv_log_erro = yes
                           v_log_erro_validac = yes.
                    next blk_bem.
                end /* if */.
                assign v_cod_estab = trad_org_ext.cod_unid_organ
                       tt_criacao_bem_pat_api_6.tta_cod_estab_ext = trad_org_ext.cod_unid_organ.
            end /* if */.
            else do:
                find estabelecimento
                    where estabelecimento.cod_estab = tt_criacao_bem_pat_api_6.tta_cod_estab_ext
                    no-lock no-error.
                if  not avail estabelecimento
                then do:
                    create tt_erros_criacao_bem_pat_api_1.
                    assign tt_erros_criacao_bem_pat_api_1.tta_cod_unid_organ_ext = tt_criacao_bem_pat_api_6.tta_cod_unid_organ_ext
                           tt_erros_criacao_bem_pat_api_1.tta_cod_cta_pat        = tt_criacao_bem_pat_api_6.tta_cod_cta_pat
                           tt_erros_criacao_bem_pat_api_1.tta_num_bem_pat        = tt_criacao_bem_pat_api_6.tta_num_bem_pat
                           tt_erros_criacao_bem_pat_api_1.tta_num_seq_bem_pat    = tt_criacao_bem_pat_api_6.tta_num_seq_bem_pat
                           tt_erros_criacao_bem_pat_api_1.tta_des_bem_pat        = tt_criacao_bem_pat_api_6.tta_des_bem_pat
                           tt_erros_criacao_bem_pat_api_1.tta_dat_aquis_bem_pat  = tt_criacao_bem_pat_api_6.tta_dat_aquis_bem_pat
                           tt_erros_criacao_bem_pat_api_1.tta_cod_finalid_econ_ext = tt_criacao_bem_pat_api_6.tta_cod_finalid_econ_ext
                           .
                    assign tt_erros_criacao_bem_pat_api_1.ttv_des_mensagem       = getStrTrans("Estabelecimento externo inexistente !", "FAS") /*4672*/
                           tt_criacao_bem_pat_api_6.ttv_log_erro = yes
                           v_log_erro_validac = yes.
                    next blk_bem.
                end /* if */.
                if  estabelecimento.cod_empresa <> v_cod_empresa
                then do:
                    create tt_erros_criacao_bem_pat_api_1.
                    assign tt_erros_criacao_bem_pat_api_1.tta_cod_unid_organ_ext = tt_criacao_bem_pat_api_6.tta_cod_unid_organ_ext
                           tt_erros_criacao_bem_pat_api_1.tta_cod_cta_pat        = tt_criacao_bem_pat_api_6.tta_cod_cta_pat
                           tt_erros_criacao_bem_pat_api_1.tta_num_bem_pat        = tt_criacao_bem_pat_api_6.tta_num_bem_pat
                           tt_erros_criacao_bem_pat_api_1.tta_num_seq_bem_pat    = tt_criacao_bem_pat_api_6.tta_num_seq_bem_pat
                           tt_erros_criacao_bem_pat_api_1.tta_des_bem_pat        = tt_criacao_bem_pat_api_6.tta_des_bem_pat
                           tt_erros_criacao_bem_pat_api_1.tta_dat_aquis_bem_pat  = tt_criacao_bem_pat_api_6.tta_dat_aquis_bem_pat
                           tt_erros_criacao_bem_pat_api_1.tta_cod_finalid_econ_ext = tt_criacao_bem_pat_api_6.tta_cod_finalid_econ_ext
                           .
                    assign tt_erros_criacao_bem_pat_api_1.ttv_des_mensagem       = getStrTrans("Empresa do Estabelecimento Diferente da Empresa Externa !", "FAS") /*4673*/
                           tt_criacao_bem_pat_api_6.ttv_log_erro = yes
                           v_log_erro_validac = yes.
                    next blk_bem.
                end /* if */.
                assign v_cod_estab = tt_criacao_bem_pat_api_6.tta_cod_estab_ext.
            end /* else */.
        end /* if */.

        if  first-of(tt_criacao_bem_pat_api_6.tta_cod_finalid_econ_ext)
        then do:
            run pi_criacao_bem_pat_finalidade.
            if return-value = "NOK" /*l_nok*/  then
               next blk_bem.
        end /* if */.

        if  v_log_erro_validac = yes
        then do:
            next blk_bem.
        end /* if */.

        if  first-of(tt_criacao_bem_pat_api_6.tta_cod_plano_ccusto) or
        first-of(tt_criacao_bem_pat_api_6.tta_cod_ccusto_ext)
        then do:
            run pi_criacao_bem_pat_ccusto.
            if return-value = "NOK" /*l_nok*/  then do:
                assign tt_criacao_bem_pat_api_6.ttv_log_erro = yes
                       p_cod_return = "NOK" /*l_nok*/ .
               next blk_bem.
            end.
        end /* if */.

        if  v_log_erro_validac = yes
        then do:
            next blk_bem.
        end /* if */.
        run pi_validar_criacao_bem_pat_api.
        if  return-value = "NOK" /*l_nok*/ 
        then do:
            assign tt_criacao_bem_pat_api_6.ttv_log_erro = yes
                   p_cod_return = "NOK" /*l_nok*/ .
            next blk_bem.
        end /* if */.
        assign tt_criacao_bem_pat_api_6.ttv_log_erro = yes.
        blk_criar:
        do on error undo blk_criar, leave blk_criar transaction:
            run pi_criacao_bem_pat_api.
            if  return-value = "NOK" /*l_nok*/ 
            then do:
                assign p_cod_return = "NOK" /*l_nok*/ .
                undo blk_criar, leave blk_criar.
            end /* if */.
            else do:
                assign tt_criacao_bem_pat_api_6.ttv_log_erro = no.        
            end /* else */.
        end /* do blk_criar */.
    end /* for blk_bem */.

    if  valid-handle(v_hdl_procedure) then
        delete procedure v_hdl_procedure.

    return.
END PROCEDURE. /* pi_main_api_criacao_bem_pat_9 */
/*****************************************************************************
** Procedure Interna.....: pi_criacao_bem_pat_api_2
** Descricao.............: pi_criacao_bem_pat_api_2
** Criado por............: jeanB
** Criado em.............: 23/12/2013 15:31:09
** Alterado por..........: jeanB
** Alterado em...........: 03/01/2014 10:01:19
*****************************************************************************/
PROCEDURE pi_criacao_bem_pat_api_2:

    for each bem_pat_item_docto_entr no-lock
       where bem_pat_item_docto_entr.num_id_bem_pat          = bem_pat.num_id_bem_pat
       and   bem_pat_item_docto_entr.num_seq_incorp_bem_pat  = 0:

        &IF DEFINED (BF_FIN_INTEG_MRI_BEM_PAT) &THEN

            /* Begin_Include: i_integrar_mri_bem_pat */
            FIND FIRST utiliz_cenar_ctbl NO-LOCK
                 WHERE utiliz_cenar_ctbl.cod_empresa     = bem_pat.cod_empresa
                 AND   utiliz_cenar_ctbl.dat_inic_valid <= bem_pat.dat_aquis_bem_pat
                 AND   utiliz_cenar_ctbl.dat_fim_valid  >= bem_pat.dat_aquis_bem_pat
                 AND   utiliz_cenar_ctbl.log_cenar_fisc  = YES NO-ERROR.

            IF  NOT AVAIL utiliz_cenar_ctbl THEN
                ASSIGN v_cod_cta_ctbl = ''.

            /* encontra finalidade econ?mica do pais do estabelecimento do bem */
            RUN pi_retornar_indic_econ_corren_estab (INPUT bem_pat.cod_estab,
                                                     INPUT bem_pat.dat_aquis_bem_pat,
                                                     OUTPUT v_cod_return).
            IF  v_cod_return = '' THEN
                ASSIGN v_cod_cta_ctbl = ''.
            ELSE
                RUN pi_retornar_finalid_indic_econ (INPUT v_cod_return,
                                                    INPUT bem_pat.dat_aquis_bem_pat,
                                                    OUTPUT v_cod_finalid_econ).     

            /* zera variavel que ira armazenar vida util convertido em meses*/
            ASSIGN v_qtd_mes_vida_util = 0.

            bloco_param_calc:
            FOR EACH param_calc_bem_pat NO-LOCK
               WHERE param_calc_bem_pat.num_id_bem_pat   = bem_pat.num_id_bem_pat
               AND   param_calc_bem_pat.cod_cenar_ctbl   = utiliz_cenar_ctbl.cod_cenar_ctbl
               AND   param_calc_bem_pat.cod_finalid_econ = v_cod_finalid_econ,

                FIRST tip_calc NO-LOCK
                WHERE tip_calc.cod_tip_calc = param_calc_bem_pat.cod_tip_calc
                AND (   tip_calc.ind_tip_calc = "Amortizaá∆o" /*l_amortizacao*/ 
                     OR tip_calc.ind_tip_calc = "Depreciaá∆o" /*l_depreciacao*/ ):

                    ASSIGN v_qtd_mes_vida_util = param_calc_bem_pat.qtd_anos_vida_util * 12.

                    LEAVE bloco_param_calc. /* se achou, sai do bloco bloco_param_calc*/
            END.

            FIND FIRST reg_calc_bem_pat NO-LOCK
                 WHERE reg_calc_bem_pat.num_id_bem_pat         = bem_pat.num_id_bem_pat
                 AND   reg_calc_bem_pat.num_seq_incorp_bem_pat = 0
                 AND   reg_calc_bem_pat.cod_tip_calc           = ''
                 AND   reg_calc_bem_pat.cod_cenar_ctbl         = utiliz_cenar_ctbl.cod_cenar_ctbl
                 AND   reg_calc_bem_pat.cod_finalid_econ       = v_cod_finalid_econ
                 AND   reg_calc_bem_pat.ind_trans_calc         = "Implantaá∆o" /*l_implantacao*/  NO-ERROR.

            IF  NOT AVAIL reg_calc_bem_pat THEN
                ASSIGN v_cod_cta_ctbl = ''.
            ELSE DO:
                FIND FIRST aprop_ctbl_pat NO-LOCK
                     WHERE aprop_ctbl_pat.num_seq_reg_calc_bem_pat = reg_calc_bem_pat.num_seq_reg_calc_bem_pat NO-ERROR.

                IF  AVAIL aprop_ctbl_pat THEN
                    ASSIGN v_cod_cta_ctbl = aprop_ctbl_pat.cod_cta_ctbl_db.
                ELSE DO:

                    FIND FIRST param_ctbz_cta_pat NO-LOCK
                         WHERE param_ctbz_cta_pat.cod_empresa      = bem_pat.cod_empresa
                         AND   param_ctbz_cta_pat.cod_cta_pat      = bem_pat.cod_cta_pat
                         AND   param_ctbz_cta_pat.cod_cenar_ctbl   = utiliz_cenar_ctbl.cod_cenar_ctbl
                         AND   param_ctbz_cta_pat.cod_finalid_econ = v_cod_finalid_econ 
                         AND   param_ctbz_cta_pat.ind_finalid_ctbl = "Saldo Imobilizado" /*l_saldo_imobilizado*/  
                         AND   param_ctbz_cta_pat.dat_inic_valid  <= bem_pat.dat_aquis_bem_pat NO-ERROR.

                    IF  AVAIL param_ctbz_cta_pat THEN
                        ASSIGN v_cod_cta_ctbl = param_ctbz_cta_pat.cod_cta_ctbl_cr.
                    ELSE 
                        ASSIGN v_cod_cta_ctbl = ''.
                END.
            END.
            /* End_Include: i_integrar_mri_bem_pat */

        &ENDIF

        run rip/ri565aa.p (input tt_criacao_bem_pat_api_6.tta_num_id_bem_pat,

                           &IF DEFINED (BF_FIN_INTEG_MRI_BEM_PAT) &THEN

                               input bem_pat.cod_cta_pat,       
                               input v_cod_cta_ctbl,
                               input bem_pat.cod_ccusto_respons,
                               input bem_pat.cod_unid_negoc,            
                               input v_qtd_mes_vida_util,
                               input bem_pat.des_narrat_bem_pat, 

                           &ENDIF

                           input tt_criacao_bem_pat_api_6.tta_num_bem_pat,
                           input tt_criacao_bem_pat_api_6.tta_num_seq_bem_pat,
                           input tt_criacao_bem_pat_api_6.tta_qtd_bem_pat_represen,
                           input tt_criacao_bem_pat_api_6.tta_des_bem_pat,
                           input bem_pat_item_docto_entr.num_item_docto_entr,
                           input bem_pat_item_docto_entr.num_id_ri_bem_pat,
                           input no /* n∆o desfaz = inclus∆o*/,
                           output table tt_log_erro_aux
                           ).
    end.

END PROCEDURE. /* pi_criacao_bem_pat_api_2 */
/*****************************************************************************
** Procedure Interna.....: pi_retornar_indic_econ_corren_estab
** Descricao.............: pi_retornar_indic_econ_corren_estab
** Criado por............: vladimir
** Criado em.............: // 
** Alterado por..........: fut12234_2
** Alterado em...........: 06/09/2006 16:43:16
*****************************************************************************/
PROCEDURE pi_retornar_indic_econ_corren_estab:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_estab
    &IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.07A" &THEN
        as character
        format "x(3)"
    &ENDIF
    &IF "{&emsfin_version}" >= "5.07A" AND "{&emsfin_version}" < "9.99" &THEN
        as Character
        format "x(5)"
    &ENDIF
        no-undo.
    def Input param p_dat_transacao
        as date
        format "99/99/9999"
        no-undo.
    def output param p_cod_indic_econ
        as character
        format "x(8)"
        no-undo.


    /************************* Parameter Definition End *************************/

    find estabelecimento no-lock
         where estabelecimento.cod_estab = p_cod_estab
         use-index stblcmnt_id no-error.
    if  avail estabelecimento
    then do:
       find pais no-lock
            where pais.cod_pais = estabelecimento.cod_pais
             no-error.
       run pi_retornar_indic_econ_finalid 

             (Input pais.cod_finalid_econ_pais,
              Input p_dat_transacao,
              output p_cod_indic_econ) /* pi_retornar_indic_econ_finalid*/.
    end /* if */.

END PROCEDURE. /* pi_retornar_indic_econ_corren_estab */
/*****************************************************************************
** Procedure Interna.....: pi_retornar_finalid_indic_econ
** Descricao.............: pi_retornar_finalid_indic_econ
** Criado por............: 
** Criado em.............: // 
** Alterado por..........: fut43117
** Alterado em...........: 05/12/2011 10:21:41
*****************************************************************************/
PROCEDURE pi_retornar_finalid_indic_econ:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_indic_econ
        as character
        format "x(8)"
        no-undo.
    def Input param p_dat_transacao
        as date
        format "99/99/9999"
        no-undo.
    def output param p_cod_finalid_econ
        as character
        format "x(10)"
        no-undo.


    /************************* Parameter Definition End *************************/

    /* alteracao sob demanda - atividade 195864*/
    find first histor_finalid_econ no-lock
        where histor_finalid_econ.cod_indic_econ          = p_cod_indic_econ
        and   histor_finalid_econ.dat_inic_valid_finalid <= p_dat_transacao
        and   histor_finalid_econ.dat_fim_valid_finalid  > p_dat_transacao no-error.
    if  avail histor_finalid_econ then 
        assign p_cod_finalid_econ = histor_finalid_econ.cod_finalid_econ.




END PROCEDURE. /* pi_retornar_finalid_indic_econ */


/************************** Internal Procedure End **************************/

/************************* External Procedure Begin *************************/



/************************** External Procedure End **************************/

/*************************************  *************************************/
/*****************************************************************************
**  Procedure Interna: pi_messages
**  Descricao........: Mostra Mensagem com Ajuda
*****************************************************************************/
PROCEDURE pi_messages:

    def input param c_action    as char    no-undo.
    def input param i_msg       as integer no-undo.
    def input param c_param     as char    no-undo.

    def var c_prg_msg           as char    no-undo.

    assign c_prg_msg = "messages/":U
                     + string(trunc(i_msg / 1000,0),"99":U)
                     + "/msg":U
                     + string(i_msg, "99999":U).

    if search(c_prg_msg + ".r":U) = ? and search(c_prg_msg + ".p":U) = ? then do:
        message getStrTrans("Mensagem nr. ", "FAS") i_msg "!!!":U skip
                getStrTrans("Programa Mensagem", "FAS") c_prg_msg getStrTrans("n∆o encontrado.", "FAS")
                view-as alert-box error.
        return error.
    end.

    run value(c_prg_msg + ".p":U) (input c_action, input c_param).
    return return-value.
END PROCEDURE.  /* pi_messages */
/***********************  End of api_criacao_bem_pat_7 **********************/
