/*****************************************************************************
** Copyright DATASUL S.A. (1994)
** Todos os Direitos Reservados.
** 
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so' podera ser feita mediante
** autorizacao expressa.
**
** Programa..............: fnc_bord_ap_imprimir
** Descricao.............: Funá‰es Bordero do Contas a Paga
** Versao................:  1.00.01.052
** Procedimento..........: tar_emitir_bord_ap
** Nome Externo..........: prgfin/apb/apb742zb.py
** Data Geracao..........: 01/04/2009 - 11:49:23
** Criado por............: Ganzen
** Criado em.............: 16/11/1995 14:28:28
** Alterado por..........: fut41420
** Alterado em...........: 20/03/2009 17:54:07
** Gerado por............: fut41420
*****************************************************************************/

def var c-versao-prg as char initial " 1.00.01.052":U no-undo.

{include/i_dbinst.i}
{include/i_dbtype.i}
{include/i_fcldef.i}


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i fnc_bord_ap_imprimir APB}
&ENDIF

/******************************* Private-Data *******************************/
assign this-procedure:private-data = "HLP=5":U.
/*************************************  *************************************/


/********************* Temporary Table Definition Begin *********************/

def temp-table tt_cabec_bordero no-undo
    field ttv_nom_pessoa_jur               as character format "x(40)" label "Nome" column-label "Nome"
    field ttv_nom_endereco                 as character format "x(40)" label "Endereáo" column-label "Endereáo"
    field ttv_nom_cidade_jur               as character format "x(32)" label "Cidade" column-label "Cidade"
    field ttv_cod_unid_federac             as character format "x(3)" label "Unidade Federaá∆o" column-label "Unidade Federaá∆o"
    field ttv_ind_sit_bord_impr            as character format "X(20)"
    field ttv_des_agenc_bcia_portad        as character format "x(50)"
    field ttv_nom_pais                     as character format "x(32)"
    field ttv_nom_label_id_feder           as character format "x(21)"
    field ttv_cod_id_feder                 as character format "x(20)" label "Fornecedor" column-label "ID Federal"
    field ttv_cod_cep                      as character format "x(20)" label "CEP" column-label "CEP"
    field ttv_nom_banco                    as character format "x(30)" label "Nome Banco" column-label "Nome do Banco"
    field ttv_dat_transacao                as date format "99/99/9999" label "Data Transaá∆o" column-label "Data Transaá∆o"
    field ttv_num_bord_ap                  as integer format ">>>>>9" label "N£mero Borderì" column-label "Borderì"
    field ttv_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda"
    field ttv_nom_razao_social             as character format "x(30)" label "Raz∆o Social" column-label "Raz∆o Social"
    field ttv_cod_pais                     as character format "x(3)" label "Pa°s" column-label "Pa°s"
    field ttv_des_cta_corren_portad        as character format "x(25)"
    field ttv_des_msg_fim_bord_apb         as character format "x(2000)"
    field ttv_des_msg_inic_bord_apb        as character format "x(2000)"
    .

def temp-table tt_cheq_adm_cancel no-undo like cheq_ap
&if "{&emsfin_version}" >= "5.01" &then
    use-index cheqap_id                    as primary
&endif
&if "{&emsfin_version}" >= "5.01" &then
    use-index cheqap_token                
&endif
    .

def new shared temp-table tt_erros_inform_bcia_fornec         like fornec_financ
    field tta_nom_abrev                    as character format "x(15)" label "Nome Abreviado" column-label "Nome Abreviado"
    field tta_cod_digito_agenc_bcia        as character format "x(2)" label "D°gito Ag Bcia" column-label "Dig Ag"
    field tta_ind_tip_forma_pagto          as character format "X(22)" label "Tipo Forma Pagto" column-label "Tipo Forma Pagto"
    field ttv_log_pagto_agrup              as logical format "Sim/N∆o" initial no label "Forma Pagto Agrup"
    .

def temp-table tt_item_bord_ap_imprimir no-undo like item_bord_ap
    field tta_nom_pessoa                   as character format "x(40)" label "Nome" column-label "Nome"
    field tta_des_forma_pagto              as character format "x(40)" label "Descr Forma Pagto" column-label "Descr Forma Pagto"
    field tta_cod_banco                    as character format "x(8)" label "Banco" column-label "Banco"
    field tta_nom_banco                    as character format "x(30)" label "Nome Banco" column-label "Nome Banco"
    field tta_cod_agenc_bcia               as character format "x(10)" label "Agància Banc†ria" column-label "Agància Banc†ria"
    field tta_cod_digito_agenc_bcia        as character format "x(2)" label "D°gito Ag Bcia" column-label "Dig Ag"
    field tta_cod_cta_corren               as character format "x(10)" label "Conta Corrente" column-label "Cta Corrente"
    field tta_cod_digito_cta_corren        as character format "x(2)" label "D°gito Cta Corrente" column-label "D°gito Cta Corrente"
    field ttv_des_documento                as character format "x(25)" label "Documento" column-label "Documento"
    field tta_dat_emis_docto               as date format "99/99/9999" initial today label "Data  Emiss∆o" column-label "Dt Emiss∆o"
    field tta_nom_cidade                   as character format "x(32)" label "Cidade" column-label "Cidade"
    field tta_ind_localiz_cheq_administ    as character format "x(16)" initial "Nenhum" label "Localizaá∆o" column-label "Localizaá∆o"
    field ttv_val_liq_item_bord            as decimal format "->>>,>>>,>>9.99" decimals 2 column-label "Valor L°quido"
    field ttv_val_tot_impto_retid          as decimal format "->>>,>>>,>>9.99" decimals 2 label "Total Imposto Retido" column-label "Total Imposto Retido"
    field tta_cb3_ident_visual             as Character format "x(20)" initial ? label "N£mero Plaqueta" column-label "N£mero Plaqueta"
    field tta_nom_razao_social             as character format "x(40)" label "Raz∆o Social" column-label "Raz∆o Social"
    field ttv_cod_barra                    as character format "x(44)"
    field tta_cod_sist_nac_bcio            as character format "x(8)" label "C¢digo Sist Banc†rio" column-label "C¢digo Sist Banc†rio"
    field ttv_des_histor_pef               as character format "x(101)" label "Hist¢rico" column-label "Hist¢rico"
    .

def shared temp-table tt_log_erros_atualiz no-undo
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_refer                    as character format "x(10)" label "Referància" column-label "Referància"
    field tta_num_seq_refer                as integer format ">>>9" initial 0 label "Sequància" column-label "Seq"
    field ttv_num_mensagem                 as integer format ">>>>,>>9" label "N£mero" column-label "N£mero Mensagem"
    field ttv_des_msg_erro                 as character format "x(60)" label "Mensagem Erro" column-label "Inconsistància"
    field ttv_des_msg_ajuda                as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda"
    field ttv_ind_tip_relacto              as character format "X(15)" label "Tipo Relacionamento" column-label "Tipo Relac"
    field ttv_num_relacto                  as integer format ">>>>,>>9" label "Relacionamento" column-label "Relacionamento"
    .

def new shared temp-table tt_val_extenso        
    field ttv_des_val_extenso              as character format "x(8)"
    .



/********************** Temporary Table Definition End **********************/

/************************ Parameter Definition Begin ************************/

def Input param p_log_impr_histor_pef
    as logical
    format "Sim/N∆o"
    no-undo.


/************************* Parameter Definition End *************************/

/************************** Buffer Definition Begin *************************/

&if "{&emsfin_version}" >= "5.01" &then
def buffer b_forma_pagto
    for forma_pagto.
&endif
&if "{&emsfin_version}" >= "5.01" &then
def buffer b_fornec_financ
    for fornec_financ.
&endif
&if "{&emsuni_version}" >= "1.00" &then
def buffer b_pais
    for emscad.pais.
&endif


/*************************** Buffer Definition End **************************/

/************************** Stream Definition Begin *************************/

def stream s_1.


/*************************** Stream Definition End **************************/

/************************* Variable Definition Begin ************************/

def new global shared var v_cod_aplicat_dtsul_corren
    as character
    format "x(3)":U
    no-undo.
def var v_cod_barra
    as character
    format "x(44)":U
    no-undo.
def new global shared var v_cod_ccusto_corren
    as character
    format "x(11)":U
    label "Centro Custo"
    column-label "Centro Custo"
    no-undo.
def var v_cod_cep
    as character
    format "x(20)":U
    label "CEP"
    column-label "CEP"
    no-undo.
def var v_cod_cgc_cpf
    as character
    format "x(20)":U
    label "CGC/CPF"
    column-label "CGC/CPF"
    no-undo.
def var v_cod_cta_corren_final
    as character
    format "x(20)":U
    label "Cta Corren"
    column-label "Cta Corren"
    no-undo.
def new global shared var v_cod_dwb_file
    as character
    format "x(40)":U
    label "Arquivo"
    column-label "Arquivo"
    no-undo.
def new global shared var v_cod_dwb_print_layout
    as character
    format "x(8)":U
    no-undo.
def new global shared var v_cod_dwb_user
    as character
    format "x(21)":U
    label "Usu†rio"
    column-label "Usu†rio"
    no-undo.
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
def var v_cod_format
    as character
    format "x(8)":U
    label "Formato"
    column-label "Formato"
    no-undo.
def var v_cod_forma_pagto_altern
    as character
    format "x(3)":U
    label "Forma Pagamento"
    column-label "F Pagto Alt"
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
def var v_cod_id_feder
    as character
    format "x(20)":U
    label "Fornecedor"
    column-label "ID Federal"
    no-undo.
def var v_cod_indic_econ
    as character
    format "x(8)":U
    label "Moeda"
    column-label "Moeda"
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
def new global shared var v_cod_plano_ccusto_corren
    as character
    format "x(8)":U
    label "Plano CCusto"
    column-label "Plano CCusto"
    no-undo.
def var v_cod_release
    as character
    format "x(12)":U
    no-undo.
def var v_cod_return
    as character
    format "x(40)":U
    no-undo.
def var v_cod_unid_federac
    as character
    format "x(3)":U
    label "Unidade Federaá∆o"
    column-label "Unidade Federaá∆o"
    no-undo.
def new global shared var v_cod_unid_negoc_usuar
    as character
    format "x(3)":U
    view-as combo-box
    list-items ""
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
def var v_dat_execution
    as date
    format "99/99/9999":U
    no-undo.
def var v_dat_execution_end
    as date
    format "99/99/9999":U
    no-undo.
def var v_dat_fim_period
    as date
    format "99/99/9999":U
    label "Fim Per°odo"
    no-undo.
def var v_dat_inic_period
    as date
    format "99/99/9999":U
    label "In°cio Per°odo"
    column-label "Per°odo"
    no-undo.
def var v_des_agenc_bcia_fornec
    as character
    format "x(14)":U
    label "Agància"
    column-label "Agància"
    no-undo.
def var v_des_agenc_bcia_portad
    as character
    format "x(50)":U
    no-undo.
def var v_des_cta_corren_fornec
    as character
    format "x(25)":U
    label "C.Corrente"
    column-label "C.Corrente"
    no-undo.
def var v_des_cta_corren_portad
    as character
    format "x(25)":U
    no-undo.
def var v_des_documento
    as character
    format "x(25)":U
    label "Documento"
    column-label "Documento"
    no-undo.
def var v_des_erro_item_bord_ap
    as character
    format "x(2000)":U
    view-as editor max-chars 2000 scrollbar-vertical
    size 90 by 10
    bgcolor 15 font 2
    label "Ajuda"
    no-undo.
def var v_des_extenso_bord
    as character
    format "x(80)":U
    extent 2
    label "Total do Borderì.."
    column-label "Total do Borderì.."
    no-undo.
def var v_des_msg_bord
    as character
    format "x(75)":U
    extent 5
    no-undo.
def var v_des_msg_col_1
    as character
    format "x(37)":U
    no-undo.
def var v_des_msg_col_2
    as character
    format "x(75)":U
    no-undo.
def var v_des_msg_fim_bord
    as character
    format "x(80)":U
    extent 5
    no-undo.
def var v_des_msg_fim_bord_apb
    as character
    format "x(2000)":U
    no-undo.
def var v_des_msg_inic_bord_apb
    as character
    format "x(2000)":U
    no-undo.
def var v_des_msg_lin_bord_apb
    as character
    format "x(2000)":U
    no-undo.
def var v_des_msg_lin_bord_apb_aux
    as character
    format "x(80)":U
    no-undo.
def var v_des_msg_lin_compl_bord_apb
    as character
    format "x(94)":U
    no-undo.
def var v_hra_execution
    as Character
    format "99:99":U
    no-undo.
def var v_hra_execution_end
    as Character
    format "99:99:99":U
    label "Tempo Exec"
    no-undo.
def new global shared var v_ind_classif_bord
    as character
    format "x(31)":U
    view-as combo-box
    list-items "Por Fornecedor","Por Data Vencimento","Por Forma de Pagto/Fornecedor","Por Estabelecimento/Fornecedor","Por Estabelecimento/Data Vencto","Por Estabelecimento/Forma Pagto","Por Fornecedor/Documento"
     /*l_por_fornecedor*/ /*l_por_data_vencimento*/ /*l_por_forma_pagto_fornecedor*/ /*l_por_estabelecimentofornecedor*/ /*l_por_estabelecimentodata_vencto*/ /*l_por_estabelecimentoforma_pagto*/ /*l_por_fornecedordocumento*/
    inner-lines 7
    bgcolor 15 font 2
    label "Classificaá∆o"
    column-label "Classificaá∆o"
    no-undo.
def new global shared var v_ind_dest_bord_ap
    as character
    format "x(10)":U
    view-as radio-set Horizontal
    radio-buttons "Terminal", "Terminal","Arquivo", "Arquivo","Impressora", "Impressora"
     /*l_terminal*/ /*l_terminal*/ /*l_file*/ /*l_file*/ /*l_printer*/ /*l_printer*/
    bgcolor 8 
    no-undo.
def new global shared var v_ind_ender_complet
    as character
    format "X(20)":U
    initial "Endereáo" /*l_endereco*/
    view-as radio-set Vertical
    radio-buttons "Endereáo", "Endereáo","Endereáo Completo", "Endereáo Completo"
     /*l_endereco*/ /*l_endereco*/ /*l_endereco_completo*/ /*l_endereco_completo*/
    bgcolor 8 
    no-undo.
def var v_ind_origin_tit_ap
    as character
    format "X(03)":U
    view-as combo-box
    list-items "PED","REC","EXP","APB","ACR","EEC"
     /*l_ped*/ /*l_rec*/ /*l_exp*/ /*l_apb*/ /*l_acr*/ /*l_eec*/
    inner-lines 6
    bgcolor 15 font 2
    label "Origem"
    column-label "Origem"
    no-undo.
def var v_ind_sit_bord_impr
    as character
    format "X(20)":U
    no-undo.
def var v_log_answer
    as logical
    format "Sim/N∆o"
    initial yes
    view-as toggle-box
    no-undo.
def new global shared var v_log_cabec_todas_pag
    as logical
    format "Sim/N∆o"
    initial yes
    view-as toggle-box
    no-undo.
def var v_log_cta_fornec
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_log_dat_pagto_bord
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.    
def var v_log_erro_impr
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_log_favorec_cheq_adm
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def new global shared var v_log_impr_item_estorn
    as logical
    format "Sim/N∆o"
    initial no
    view-as toggle-box
    label "Imprime Itens Estorn"
    no-undo.
def new global shared var v_log_impr_sit
    as logical
    format "Sim/N∆o"
    initial yes
    view-as toggle-box
    no-undo.
def new global shared var v_log_impr_tot_bord_assin
    as logical
    format "Sim/N∆o"
    initial no
    view-as toggle-box
    no-undo.
def var v_log_impto_vincul_refer
    as logical
    format "Sim/N∆o"
    initial yes
    no-undo.
def var v_log_method
    as logical
    format "Sim/N∆o"
    initial yes
    no-undo.
def var v_log_pag
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def new global shared var v_log_salta_lin
    as logical
    format "Sim/N∆o"
    initial yes
    view-as toggle-box
    no-undo.
def new global shared var v_nom_arq_bord_ap
    as character
    format "x(30)":U
    view-as editor max-chars 250 no-word-wrap
    size 40 by 1
    bgcolor 15 font 2
    no-undo.
def var v_nom_cidade
    as character
    format "x(32)":U
    label "Cidade"
    column-label "Cidade"
    no-undo.
def var v_nom_cidade_jur
    as character
    format "x(32)":U
    label "Cidade"
    column-label "Cidade"
    no-undo.
def new global shared var v_nom_dwb_printer
    as character
    format "x(30)":U
    no-undo.
def var v_nom_endereco
    as character
    format "x(40)":U
    label "Endereáo"
    column-label "Endereáo"
    no-undo.
def var v_nom_ender_lin_1
    as character
    format "x(50)":U
    initial """"
    label "Endereáo Completo"
    column-label "Endereáo Completo"
    no-undo.
def var v_nom_ender_lin_2
    as character
    format "x(50)":U
    no-undo.
def var v_nom_ender_lin_3
    as character
    format "x(50)":U
    no-undo.
def var v_nom_ender_lin_4
    as character
    format "x(50)":U
    no-undo.
def var v_nom_enterprise
    as character
    format "x(40)":U
    no-undo.
def var v_nom_label_id_feder
    as character
    format "x(21)":U
    no-undo.
def var v_nom_pessoa_jur
    as character
    format "x(40)":U
    label "Nome"
    column-label "Nome"
    no-undo.
def var v_nom_prog_ext
    as character
    format "x(8)":U
    label "Nome Externo"
    no-undo.
def var v_nom_razao_social
    as character
    format "x(30)":U
    label "Raz∆o Social"
    column-label "Raz∆o Social"
    no-undo.
def var v_nom_report_title
    as character
    format "x(40)":U
    no-undo.
def var v_nom_table_epc
    as character
    format "x(30)":U
    no-undo.
def var v_nom_title_aux
    as character
    format "x(60)":U
    no-undo.
def var v_num_aux
    as integer
    format ">>>>,>>9":U
    no-undo.
def var v_num_cont_entry
    as integer
    format ">>9":U
    initial 0
    no-undo.
def var v_num_count
    as integer
    format ">>>>,>>9":U
    no-undo.
def var v_num_impr
    as integer
    format ">>>>,>>9":U
    no-undo.
def var v_num_pag
    as integer
    format ">99":U
    label "Pagina"
    column-label "Pagina"
    no-undo.
def var v_num_page_number
    as integer
    format ">>>>>9":U
    label "P†gina"
    column-label "P†gina"
    no-undo.
def new global shared var v_num_ped_exec_corren
    as integer
    format ">>>>9":U
    no-undo.
def var v_qtd_tot_tit_bord
    as decimal
    format ">>>9":U
    decimals 0
    label "Total de T°tulos"
    column-label "Total de T°tulos"
    no-undo.
def var v_qtd_tot_tit_pag_bord
    as decimal
    format ">>9":U
    decimals 0
    label "Total de T°tulos"
    column-label "Total de T°tulos"
    no-undo.
def var v_qtd_tot_tit_pag_bord_1
    as decimal
    format ">>>9":U
    decimals 0
    label "Total de T°tulos"
    column-label "Total de T°tulos"
    no-undo.
def var v_qtd_tot_tit_pag_bord_2
    as decimal
    format ">>>9":U
    decimals 0
    label "Total de T°tulos"
    column-label "Total de T°tulos"
    no-undo.
def new global shared var v_rec_bord_ap
    as recid
    format ">>>>>>9":U
    initial ?
    no-undo.
def var v_rec_item_bord_ap_impr
    as recid
    format ">>>>>>9":U
    no-undo.
def var V_REC_LOG
    as recid
    format ">>>>>>9":U
    no-undo.
def var v_rec_table_epc
    as recid
    format ">>>>>>9":U
    no-undo.
def var v_val_abat_bord
    as decimal
    format "->>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_val_abat_pag_bord
    as decimal
    format "->>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_val_abat_pag_bord_1
    as decimal
    format "->>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_val_abat_pag_bord_2
    as decimal
    format "->>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_val_desc_bord
    as decimal
    format "->>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_val_desc_pag_bord
    as decimal
    format "->>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_val_desc_pag_bord_1
    as decimal
    format "->>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_val_desc_pag_bord_2
    as decimal
    format "->>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_val_juros_bord
    as decimal
    format "->>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_val_juros_pag_bord
    as decimal
    format "->>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_val_juros_pag_bord_1
    as decimal
    format "->>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_val_juros_pag_bord_2
    as decimal
    format "->>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_val_liq_bord
    as decimal
    format "->>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_val_liq_item_bord
    as decimal
    format "->>>,>>>,>>9.99":U
    decimals 2
    column-label "Valor L°quido"
    no-undo.
def var v_val_liq_pag_bord
    as decimal
    format "->>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_val_liq_pag_bord_1
    as decimal
    format "->>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_val_liq_pag_bord_2
    as decimal
    format "->>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_val_multa_bord
    as decimal
    format "->>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_val_multa_pag_bord
    as decimal
    format "->>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_val_multa_pag_bord_1
    as decimal
    format "->>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_val_multa_pag_bord_2
    as decimal
    format "->>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_val_pag_bord
    as decimal
    format ">,>>>,>>>,>>9.99":U
    decimals 2
    label "Total da  P†gina"
    column-label "Total da P†gina"
    no-undo.
def var v_val_pag_bord_1
    as decimal
    format "->>>,>>>,>>9.99":U
    decimals 2
    label "Total da  P†gina"
    column-label "Total da P†gina"
    no-undo.
def var v_val_pag_bord_2
    as decimal
    format "->>>,>>>,>>9.99":U
    decimals 2
    label "Total da  P†gina"
    column-label "Total da P†gina"
    no-undo.
def var v_val_pag_tot_impto
    as decimal
    format "->>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_val_pag_tot_impto_1
    as decimal
    format "->>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_val_pag_tot_impto_2
    as decimal
    format "->>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_val_total
    as decimal
    format "->>>,>>>,>>9.99":U
    decimals 2
    label "Total %"
    column-label "Valor Total"
    no-undo.
def var v_val_tot_bord
    as decimal
    format ">>,>>>,>>>,>>9.99":U
    decimals 2
    label "Total do Borderì"
    column-label "Total do Borderì"
    no-undo.
def var v_val_tot_impto
    as decimal
    format "->>>,>>>,>>9.99":U
    decimals 2
    label "Total a Ratear"
    column-label "Valor Total a Ratear"
    no-undo.
def var v_val_tot_impto_tot
    as decimal
    format "->>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_val_var_mon_bord
    as decimal
    format "->>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_val_var_mon_pag_bord
    as decimal
    format "->>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_val_var_mon_pag_bord_1
    as decimal
    format "->>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_val_var_mon_pag_bord_2
    as decimal
    format "->>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_wgh_frame_epc
    as widget-handle
    format ">>>>>>9":U
    no-undo.
def var v_des_histor_pef                 as character       no-undo. /*local*/


/************************** Variable Definition End *************************/

/************************** Report Definition Begin *************************/

def new shared var v_rpt_s_1_lines as integer initial 84.
def new shared var v_rpt_s_1_columns as integer initial 114.
def new shared var v_rpt_s_1_bottom as integer initial 83.
def new shared var v_rpt_s_1_page as integer.
def new shared var v_rpt_s_1_name as character initial "Impressao de Borderì".
def frame f_rpt_s_1_Grp_pag_bord_Lay_pag_bord header
    "Pag: " at 105
    v_num_pag to 113 format ">>>9" skip (1)
    with no-box no-labels width 114 page-bottom stream-io.
def frame f_rpt_s_1_grp_cabec_Lay_cabecalho header
    "EMPRESA.............:" at 1
    v_nom_pessoa_jur at 23 format "x(40)" view-as text skip
    "ENDEREÄO............:" at 1
    v_nom_endereco at 23 format "x(40)" view-as text skip
    "CIDADE..............:" at 1
    v_nom_cidade_jur at 23 format "x(32)" view-as text
    "-" at 56
    v_cod_unid_federac at 58 format "x(3)" view-as text
    "-" at 62
    v_cod_cep at 64 format "x(20)" view-as text skip
    v_nom_label_id_feder at 1 format "x(21)" view-as text
    v_cod_id_feder at 23 format "x(20)" view-as text skip
    "BANCO...............:" at 1
    /* Atributo banco.nom_banco ignorado */ skip
    "AG“NCIA.............:" at 1
    v_des_agenc_bcia_portad at 23 format "x(50)" view-as text skip
    "C. CORRENTE.........:" at 1
    v_des_cta_corren_portad at 23 format "x(25)" view-as text skip
    "BORDER‚.............:" at 1
    /* Atributo bord_ap.num_bord_ap ignorado */
    "SITUAÄ«O............:" at 31
    v_ind_sit_bord_impr at 53 format "X(20)" view-as text skip
    "DATA EMISS«O........:" at 1
    /* Atributo bord_ap.dat_transacao ignorado */
    "MOEDA DO BORDER‚:" at 35
    v_cod_indic_econ at 53 format "x(8)" view-as text skip
    with no-box no-labels width 114 page-top stream-io.
def frame f_rpt_s_1_grp_cabec_Lay_Cabec_1 header
    "EMPRESA.............:" at 1
    v_nom_pessoa_jur at 23 format "x(40)" view-as text skip
    "ENDEREÄO............:" at 1
    v_nom_endereco at 23 format "x(40)" view-as text skip
    "CIDADE..............:" at 1
    v_nom_cidade_jur at 23 format "x(32)" view-as text
    "-" at 56
    v_cod_unid_federac at 58 format "x(3)" view-as text
    "-" at 62
    v_cod_cep at 64 format "x(20)" view-as text skip
    v_nom_label_id_feder at 1 format "x(21)" view-as text
    v_cod_id_feder at 23 format "x(20)" view-as text skip
    "BANCO...............:" at 1
    /* Atributo banco.nom_banco ignorado */ skip
    "AG“NCIA.............:" at 1
    v_des_agenc_bcia_portad at 23 format "x(50)" view-as text skip
    "C. CORRENTE.........:" at 1
    v_des_cta_corren_portad at 23 format "x(25)" view-as text skip
    "BORDER‚.............:" at 1
    /* Atributo bord_ap.num_bord_ap ignorado */
    "SITUAÄ«O............:" at 31
    v_ind_sit_bord_impr at 53 format "X(20)" view-as text skip
    "DATA EMISS«O........:" at 1
    /* Atributo bord_ap.dat_transacao ignorado */ skip
    with no-box no-labels width 114 page-top stream-io.
def frame f_rpt_s_1_grp_cabec_Lay_cabec_end header
    "EMPRESA.............:" at 1
    v_nom_pessoa_jur at 23 format "x(40)" view-as text skip
    "ENDEREÄO............:" at 1
    v_nom_ender_lin_1 at 23 format "x(50)" view-as text skip
    v_nom_ender_lin_2 at 23 format "x(50)" view-as text skip
    v_nom_ender_lin_3 at 23 format "x(50)" view-as text skip
    v_nom_ender_lin_4 at 23 format "x(50)" view-as text skip
    "BANCO...............:" at 1
    /* Atributo banco.nom_banco ignorado */ skip
    "AG“NCIA.............:" at 1
    v_des_agenc_bcia_portad at 23 format "x(50)" view-as text skip
    "C. CORRENTE.........:" at 1
    v_des_cta_corren_portad at 23 format "x(25)" view-as text skip
    "BORDER‚.............:" at 1
    /* Atributo bord_ap.num_bord_ap ignorado */
    "SITUAÄ«O............:" at 31
    v_ind_sit_bord_impr at 53 format "X(20)" view-as text skip
    "DATA EMISS«O........:" at 1
    /* Atributo bord_ap.dat_transacao ignorado */
    "MOEDA DO BORDER‚:" at 35
    v_cod_indic_econ at 53 format "x(8)" view-as text skip
    with no-box no-labels width 114 page-top stream-io.
def frame f_rpt_s_1_grp_cabec_Lay_Cabec_end_1 header
    "EMPRESA.............:" at 1
    v_nom_pessoa_jur at 23 format "x(40)" view-as text skip
    "ENDEREÄO............:" at 1
    v_nom_ender_lin_1 at 23 format "x(50)" view-as text skip
    v_nom_ender_lin_2 at 23 format "x(50)" view-as text skip
    v_nom_ender_lin_3 at 23 format "x(50)" view-as text skip
    v_nom_ender_lin_4 at 23 format "x(50)" view-as text skip
    "BANCO...............:" at 1
    /* Atributo banco.nom_banco ignorado */ skip
    "AG“NCIA.............:" at 1
    v_des_agenc_bcia_portad at 23 format "x(50)" view-as text skip
    "C. CORRENTE.........:" at 1
    v_des_cta_corren_portad at 23 format "x(25)" view-as text skip
    "BORDER‚.............:" at 1
    /* Atributo bord_ap.num_bord_ap ignorado */
    "SITUAÄ«O............:" at 31
    v_ind_sit_bord_impr at 53 format "X(20)" view-as text skip
    "DATA EMISS«O........:" at 1
    /* Atributo bord_ap.dat_transacao ignorado */ skip
    with no-box no-labels width 114 page-top stream-io.
def frame f_rpt_s_1_grp_cabec_Lay_cab_msg1 header
    v_des_msg_col_1 at 1 format "x(37)" view-as text
    v_des_msg_col_2 at 40 format "x(75)" view-as text skip
    with no-box no-labels width 114 page-top stream-io.
def frame f_rpt_s_1_grp_cabec_Lay_linha header
    "---------------------------------------------------------" at 1
    "---------------------------------------------------------" at 58 skip
    with no-box no-labels width 114 page-top stream-io.
def frame f_rpt_s_1_Grp_cabec_escrit_Lay_cabec_ender header
    "EMPRESA.............:" at 1
    v_nom_pessoa_jur at 23 format "x(40)" view-as text skip
    "ENDEREÄO............:" at 1
    v_nom_ender_lin_1 at 23 format "x(50)" view-as text skip
    v_nom_ender_lin_2 at 23 format "x(50)" view-as text skip
    v_nom_ender_lin_3 at 23 format "x(50)" view-as text skip
    v_nom_ender_lin_4 at 23 format "x(50)" view-as text skip
    "BANCO...............:" at 1
    /* Atributo banco.nom_banco ignorado */
    "*********************" at 94 skip
    "AG“NCIA.............:" at 1
    v_des_agenc_bcia_portad at 23 format "x(50)" view-as text
    "*" at 94
    "  BORDER‚  " at 99
    "*" at 114 skip
    "C. CORRENTE.........:" at 1
    v_des_cta_corren_portad at 23 format "x(25)" view-as text
    "*" at 94
    " ESCRITURAL  " at 99
    "*" at 114 skip
    "BORDER‚.............:" at 1
    /* Atributo bord_ap.num_bord_ap ignorado */
    "SITUAÄ«O............:" at 31
    v_ind_sit_bord_impr at 53 format "X(20)" view-as text
    "*********************" at 94 skip
    "DATA EMISS«O........:" at 1
    /* Atributo bord_ap.dat_transacao ignorado */ skip
    with no-box no-labels width 114 page-top stream-io.
def frame f_rpt_s_1_Grp_cabec_escrit_Lay_cabec_escrit header
    "EMPRESA.............:" at 1
    v_nom_pessoa_jur at 23 format "x(40)" view-as text skip
    "ENDEREÄO............:" at 1
    v_nom_endereco at 23 format "x(40)" view-as text skip
    "CIDADE..............:" at 1
    v_nom_cidade_jur at 23 format "x(32)" view-as text
    "-" at 56
    v_cod_unid_federac at 58 format "x(3)" view-as text
    "-" at 62
    v_cod_cep at 64 format "x(20)" view-as text skip
    v_nom_label_id_feder at 1 format "x(21)" view-as text
    v_cod_id_feder at 23 format "x(20)" view-as text skip
    "BANCO...............:" at 1
    /* Atributo banco.nom_banco ignorado */
    "*********************" at 94 skip
    "AG“NCIA.............:" at 1
    v_des_agenc_bcia_portad at 23 format "x(50)" view-as text
    "*" at 94
    "  BORDER‚  " at 99
    "*" at 114 skip
    "C. CORRENTE.........:" at 1
    v_des_cta_corren_portad at 23 format "x(25)" view-as text
    "*" at 94
    " ESCRITURAL  " at 99
    "*" at 114 skip
    "BORDER‚.............:" at 1
    /* Atributo bord_ap.num_bord_ap ignorado */
    "SITUAÄ«O............:" at 31
    v_ind_sit_bord_impr at 53 format "X(20)" view-as text
    "*********************" at 94 skip
    "DATA EMISS«O........:" at 1
    /* Atributo bord_ap.dat_transacao ignorado */ skip
    with no-box no-labels width 114 page-top stream-io.
def frame f_rpt_s_1_Grp_Cheq_Adm_Lay_Cheq_Adm header
    "Localizaá∆o:" at 1
    /* Atributo tt_item_bord_ap_imprimir.tta_ind_localiz_cheq_administ ignorado */ skip
    with no-box no-labels width 114 page-top stream-io.
def frame f_rpt_s_1_Grp_Cheq_Cancel_Lay_Cheq_Cancel header
    "Emis Ch Adm" at 10
    "Favorec" at 29
    "Num Cheque" to 89
    "Vl Cheque" to 110 skip
    "-----------" at 10
    "----------------------------------------" at 29
    "------------" to 89
    "--------------" to 110 skip
    with no-box no-labels width 114 page-top stream-io.
def frame f_rpt_s_1_Grp_cheq_favor_Lay_cheq_favor header
    /* Atributo tt_item_bord_ap_imprimir.nom_favorec_cheq ignorado */ skip (1)
    with no-box no-labels width 114 page-top stream-io.
def frame f_rpt_s_1_Grp_cont_corp_Lay_branco header skip (1)
    with no-box no-labels width 114 page-top stream-io.
def frame f_rpt_s_1_Grp_cont_corp_Lay_cont_bord header
    "Nome Fornec:" at 1
    /* Atributo tt_item_bord_ap_imprimir.tta_nom_pessoa ignorado */
    /* Atributo tt_item_bord_ap_imprimir.tta_nom_cidade ignorado */
    /* Atributo tt_item_bord_ap_imprimir.ind_sit_item_bord_ap ignorado */ skip
    "Forma Pagto:" at 1
    /* Atributo tt_item_bord_ap_imprimir.tta_des_forma_pagto ignorado */
    /* Atributo tt_item_bord_ap_imprimir.tta_cod_sist_nac_bcio ignorado */ skip
    "-" at 26
    /* Atributo tt_item_bord_ap_imprimir.tta_nom_banco ignorado */
    "Ag.: " at 58
    v_des_agenc_bcia_fornec at 63 format "x(14)" view-as text
    "C.Corren: " at 78
    v_des_cta_corren_fornec at 88 format "x(25)" view-as text
    /* Atributo tt_item_bord_ap_imprimir.ttv_des_histor_pef ignorado */ skip (1)
    with no-box no-labels width 114 page-top stream-io.
def frame f_rpt_s_1_Grp_corpo_bord_Lay_corpo_bord header
    "Fornec" to 11
    "Documento" at 13
    "Dt Emiss∆o" at 39
    "Valor Pagto" to 66
    "Vl Multa" to 82
    "Vl Juros" to 98
    "Corr Monet" to 114 skip
    "Vencto" at 39
    "Impto Retido" to 66
    "Vl Descto" to 82
    "Vl Abat" to 98
    "Valor L°quido" to 114 skip
    "------------------------------------------------------------------------------------------------------------------" at 1 skip
    with no-box no-labels width 114 page-top stream-io.
def frame f_rpt_s_1_Grp_erro_bord_Lay_erro_bord header
    "Est" at 1
    "Seq" to 8
    "N£mero" to 17
    "Erro" at 19 skip
    "Ajuda" at 19 skip
    "------------------------------------------------------------------------------------------------------------" at 1 skip
    with no-box no-labels width 114 page-top stream-io.
def frame f_rpt_s_1_Grp_tot_bord_Lay_msg_fim header
    v_des_msg_lin_bord_apb_aux at 17 format "x(80)" view-as text skip
    with no-box no-labels width 114 page-top stream-io.
def frame f_rpt_s_1_Grp_tot_bord_Lay_msg_fim2 header
    v_des_msg_lin_compl_bord_apb at 3 format "x(94)" view-as text skip
    with no-box no-labels width 114 page-top stream-io.
def frame f_rpt_s_1_Grp_tot_bord_Lay_msg_fim3 header
    skip (2)
    "-------------------" at 29
    "-------------------" at 48
    "-------------------" at 67 skip
    with no-box no-labels width 114 page-top stream-io.
def frame f_rpt_s_1_Grp_tot_bord_Lay_Tot_ADM header
    "---------------------------------------------------------" at 1
    "---------------------------------------------------------" at 58 skip
    "Total do Bordero:" at 1
    v_val_tot_bord to 37 format ">>,>>>,>>>,>>9.99" view-as text skip
    "Total Cheq. ADM:" at 2
    v_qtd_tot_tit_bord to 35 format ">>>9" view-as text skip
    "---------------------------------------------------------" at 1
    "---------------------------------------------------------" at 58 skip (1)
    with no-box no-labels width 114 page-top stream-io.
def frame f_rpt_s_1_Grp_tot_bord_Lay_tot_bord header
    "---------------------------------------------------------" at 1
    "---------------------------------------------------------" at 58 skip
    "Total do Bordero:" at 1
    v_val_tot_bord to 37 format ">>,>>>,>>>,>>9.99" view-as text
    v_val_multa_bord to 82 format "->>>,>>>,>>9.99" view-as text
    v_val_juros_bord to 98 format "->>>,>>>,>>9.99" view-as text
    v_val_var_mon_bord to 114 format "->>>,>>>,>>9.99" view-as text skip
    "Total de Titulos:" at 1
    v_qtd_tot_tit_bord to 35 format ">>>9" view-as text
    v_val_tot_impto_tot to 66 format "->>>,>>>,>>9.99" view-as text
    v_val_desc_bord to 82 format "->>>,>>>,>>9.99" view-as text
    v_val_abat_bord to 98 format "->>>,>>>,>>9.99" view-as text
    v_val_liq_bord to 114 format "->>>,>>>,>>9.99" view-as text skip
    "---------------------------------------------------------" at 1
    "---------------------------------------------------------" at 58 skip (1)
    with no-box no-labels width 114 page-top stream-io.
def frame f_rpt_s_1_Grp_tot_bord_Lay_tot_ext_bord header
    "---------------------------------------------------------" at 4
    "-------------------" at 61
    "-------------------" at 80
    "---------" at 99
    "----" at 108 skip
    "|" at 4
    "Total do Borderì..: " at 6
    v_des_extenso_bord[1] at 26 format "x(80)" view-as text
    "|" at 111 skip
    "|" at 4
    v_des_extenso_bord[2] at 26 format "x(80)" view-as text
    "|" at 111 skip
    "---------------------------------------------------------" at 4
    "-------------------" at 61
    "-------------------" at 80
    "---------" at 99
    "----" at 108 skip (1)
    with no-box no-labels width 114 page-top stream-io.
def frame f_rpt_s_1_Grp_tot_bord_Lay_tot_forma header
    "---------------------------------------------------------" at 1
    "---------------------------------------------------------" at 58 skip
    v_val_pag_bord_2 to 66 format "->>>,>>>,>>9.99" view-as text
    v_val_multa_pag_bord_2 to 82 format "->>>,>>>,>>9.99" view-as text
    v_val_juros_pag_bord_2 to 98 format "->>>,>>>,>>9.99" view-as text
    v_val_var_mon_pag_bord_2 to 114 format "->>>,>>>,>>9.99" view-as text skip
    "Total de T°tulos por Forma de Pagamento" at 1
    v_qtd_tot_tit_pag_bord_2 to 44 format ">>>9" view-as text
    v_val_pag_tot_impto_2 to 66 format "->>>,>>>,>>9.99" view-as text
    v_val_desc_pag_bord_2 to 82 format "->>>,>>>,>>9.99" view-as text
    v_val_abat_pag_bord_2 to 98 format "->>>,>>>,>>9.99" view-as text
    v_val_liq_pag_bord_2 to 114 format "->>>,>>>,>>9.99" view-as text skip
    "---------------------------------------------------------" at 1
    "---------------------------------------------------------" at 58 skip
    with no-box no-labels width 114 page-top stream-io.
def frame f_rpt_s_1_Grp_tot_bord_Lay_tot_forneced header
    "---------------------------------------------------------" at 1
    "---------------------------------------------------------" at 58 skip
    v_val_pag_bord_1 to 66 format "->>>,>>>,>>9.99" view-as text
    v_val_multa_pag_bord_1 to 82 format "->>>,>>>,>>9.99" view-as text
    v_val_juros_pag_bord_1 to 98 format "->>>,>>>,>>9.99" view-as text
    v_val_var_mon_pag_bord_1 to 114 format "->>>,>>>,>>9.99" view-as text skip
    "Total de T°tulos por Fornecedor" at 1
    v_qtd_tot_tit_pag_bord_1 to 44 format ">>>9" view-as text
    v_val_pag_tot_impto_1 to 66 format "->>>,>>>,>>9.99" view-as text
    v_val_desc_pag_bord_1 to 82 format "->>>,>>>,>>9.99" view-as text
    v_val_abat_pag_bord_1 to 98 format "->>>,>>>,>>9.99" view-as text
    v_val_liq_pag_bord_1 to 114 format "->>>,>>>,>>9.99" view-as text skip
    "---------------------------------------------------------" at 1
    "---------------------------------------------------------" at 58 skip
    with no-box no-labels width 114 page-top stream-io.
def frame f_rpt_s_1_Grp_tot_pag_Lay_tot_pag header
    "---------------------------------------------------------" at 1
    "---------------------------------------------------------" at 58 skip
    "Total da  Pagina:" at 1
    v_val_pag_bord to 37 format ">,>>>,>>>,>>9.99" view-as text
    v_val_multa_pag_bord to 82 format "->>>,>>>,>>9.99" view-as text
    v_val_juros_pag_bord to 98 format "->>>,>>>,>>9.99" view-as text
    v_val_var_mon_pag_bord to 114 format "->>>,>>>,>>9.99" view-as text skip
    "Total de Titulos:" at 1
    v_qtd_tot_tit_pag_bord to 34 format ">>9" view-as text
    v_val_pag_tot_impto to 66 format "->>>,>>>,>>9.99" view-as text
    v_val_desc_pag_bord to 82 format "->>>,>>>,>>9.99" view-as text
    v_val_abat_pag_bord to 98 format "->>>,>>>,>>9.99" view-as text
    v_val_liq_pag_bord to 114 format "->>>,>>>,>>9.99" view-as text skip
    "---------------------------------------------------------" at 1
    "---------------------------------------------------------" at 58 skip (1)
    with no-box no-labels width 114 page-top stream-io.
def frame f_rpt_s_1_Grp_tot_pag_Lay_Tot_pag_cheq header
    "---------------------------------------------------------" at 1
    "---------------------------------------------------------" at 58 skip
    "Total da  Pagina:" at 1
    v_val_tot_bord to 37 format ">>,>>>,>>>,>>9.99" view-as text skip
    "Total Cheq. ADM:" at 2
    v_qtd_tot_tit_bord to 35 format ">>>9" view-as text skip
    "---------------------------------------------------------" at 1
    "---------------------------------------------------------" at 58 skip (1)
    with no-box no-labels width 114 page-top stream-io.


/*************************** Report Definition End **************************/


/****************************** Main Code Begin *****************************/


/* Begin_Include: i_version_extract */
/*{include/i-ctrlrp5.i fnc_bord_ap_imprimir}*/


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
    run pi_version_extract ('fnc_bord_ap_imprimir':U, 'prgfin/apb/apb742zb.py':U, '1.00.01.052':U, 'pro':U).
end /* if */.



/* End_Include: i_version_extract */


/* Begin_Include: i_verify_security */
if  search("prgtec/men/men901za.r") = ? and search("prgtec/men/men901za.py") = ? then do:
    if  v_cod_dwb_user begins 'es_' then
        return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgtec/men/men901za.py".
    else do:
        message "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  "prgtec/men/men901za.py"
               view-as alert-box error buttons ok.
        return.
    end.
end.
else
    run prgtec/men/men901za.py (Input 'fnc_bord_ap_imprimir') /*prg_fnc_verify_security*/.
if  return-value = "2014"
then do:
    /* Programa a ser executado n∆o Ç um programa v†lido Datasul ! */
    run pi_messages (input "show",
                     input 2014,
                     input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                       'fnc_bord_ap_imprimir')) /*msg_2014*/.
    return.
end /* if */.
if  return-value = "2012"
then do:
    /* Usu†rio sem permiss∆o para acessar o programa. */
    run pi_messages (input "show",
                     input 2012,
                     input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                       'fnc_bord_ap_imprimir')) /*msg_2012*/.
    return.
end /* if */.
/* End_Include: i_verify_security */


if  search("prgtec/btb/btb906za.r") = ? and search("prgtec/btb/btb906za.py") = ? then do:
    if  v_cod_dwb_user begins 'es_' then
        return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgtec/btb/btb906za.py".
    else do:
        message "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  "prgtec/btb/btb906za.py"
               view-as alert-box error buttons ok.
        stop.
    end.
end.
else
    run prgtec/btb/btb906za.py /*prg_fnc_verify_controls*/.


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



/* Begin_Include: i_declara_GetDefinedFunction */
FUNCTION GetDefinedFunction RETURNS LOGICAL (INPUT SPP AS CHARACTER):

    DEF VAR v_log_retorno AS LOGICAL INITIAL NO NO-UNDO.

    IF CAN-FIND (FIRST emscad.histor_exec_especial NO-LOCK
         WHERE emscad.histor_exec_especial.cod_modul_dtsul = "UFN" /* l_ufn*/ 
           AND emscad.histor_exec_especial.cod_prog_dtsul  = SPP) THEN
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


assign v_log_cta_fornec = &if defined(BF_FIN_CONTAS_CORRENTES_FORNEC) &then yes &else GetDefinedFunction('SPP_CONTAS_CORRENTES_FORNEC':U)  &endif
       v_log_favorec_cheq_adm = &if defined(BF_FIN_FAVOR_CH_ADM) &then yes &else GetDefinedFunction('spp_favor_ch_adm':U)  &endif
       v_log_dat_pagto_bord = &if defined(bf_fin_dat_pagto_bord) &then yes &else GetDefinedFunction('spp_dat_pagto_bord':U) &endif.


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
    where prog_dtsul.cod_prog_dtsul = "fnc_bord_ap_imprimir":U
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
 /* fabiano*//* buzzi - 21/01/2003*/

do transaction:
    find bord_ap where recid(bord_ap) = v_rec_bord_ap exclusive-lock no-error.
end.    

main_block:
do on error undo main_block, leave main_block:
    assign v_log_method = session:set-wait-state('general').
    if  bord_ap.ind_tip_bord_ap = "Normal" /*l_normal*/ 
    then do:
        run pi_rpt_bord_ap_imprimir /*pi_rpt_bord_ap_imprimir*/.
    end /* if */.
    else do:
        run pi_rpt_cheq_adm_imprimir_cancel /*pi_rpt_cheq_adm_imprimir_cancel*/.
    end /* else */.
    assign v_log_method = session:set-wait-state("").
    if  v_ind_dest_bord_ap = "Terminal" /*l_terminal*/ 
    then do:
        run pi_show_report_2 (Input v_cod_dwb_file) /*pi_show_report_2*/.
    end /* if */.
end /* do main_block */.

del_tt:
for each tt_item_bord_ap_imprimir no-lock:
    delete tt_item_bord_ap_imprimir.
end /* for del_tt */.


/******************************* Main Code End ******************************/

/************************* Internal Procedure Begin *************************/

/*****************************************************************************
** Procedure Interna.....: pi_rpt_bord_ap_imprimir
** Descricao.............: pi_rpt_bord_ap_imprimir
** Criado por............: Ganzen
** Criado em.............: 17/11/1995 10:58:54
** Alterado por..........: fut43120
** Alterado em...........: 23/09/2008 16:29:48
*****************************************************************************/
PROCEDURE pi_rpt_bord_ap_imprimir:

    /************************* Variable Definition Begin ************************/

    def var v_ind_tip_relat_bord_apb
        as character
        format "X(08)":U
        no-undo.
    def var v_nom_aux                        as character       no-undo. /*local*/
    def var v_num_cont                       as integer         no-undo. /*local*/


    /************************** Variable Definition End *************************/

    assign v_num_pag = 1
           v_val_liq_bord     = 0
           v_val_liq_pag_bord = 0.
    for each tt_log_erros_atualiz:
        delete tt_log_erros_atualiz.
    end.
    do:
        /* seta a saida da impressao */
        case v_ind_dest_bord_ap:
            when "Terminal" /*l_terminal*/  then do:
                assign v_cod_dwb_file   = session:temp-directory + substring ("prgfin/apb/apb742zb.py", 12, 6) + '.tmp'.
                output stream s_1 to value(v_cod_dwb_file) paged page-size value(v_rpt_s_1_lines) convert target 'iso8859-1'.
            end.
            when "Impressora" /*l_printer*/  then do:
                find imprsor_usuar no-lock use-index imprsrsr_id 
                     where imprsor_usuar.nom_impressora = v_nom_dwb_printer
                      and  imprsor_usuar.cod_usuario    = v_cod_dwb_user no-error.
                find impressora no-lock
                     where impressora.nom_impressora = imprsor_usuar.nom_impressora
                     no-error.
                find tip_imprsor no-lock
                     where tip_imprsor.cod_tip_imprsor = impressora.cod_tip_imprsor
                     no-error.
                find layout_impres no-lock
                     where layout_impres.nom_impressora    = v_nom_dwb_printer
                       and layout_impres.cod_layout_impres = v_cod_dwb_print_layout no-error.
                assign v_rpt_s_1_bottom = layout_impres.num_lin_pag /* + v_rpt_s_1_bottom - v_rpt_s_1_lines */
                       v_rpt_s_1_lines = layout_impres.num_lin_pag.
                output stream s_1 to value(imprsor_usuar.nom_disposit_so)
                       paged page-size value(v_rpt_s_1_lines) convert target tip_imprsor.cod_pag_carac_conver.

                for each configur_layout_impres no-lock
                    where configur_layout_impres.num_id_layout_impres = layout_impres.num_id_layout_impres
                    by configur_layout_impres.num_ord_funcao_imprsor:

                    find configur_tip_imprsor no-lock
                        where configur_tip_imprsor.cod_tip_imprsor        = layout_impres.cod_tip_imprsor
                        and   configur_tip_imprsor.cod_funcao_imprsor     = configur_layout_impres.cod_funcao_imprsor
                        and   configur_tip_imprsor.cod_opc_funcao_imprsor = configur_layout_impres.cod_opc_funcao_imprsor no-error.

                    bloco_1:
                    do
                         v_num_count = 1 to extent(configur_tip_imprsor.num_carac_configur):
                         /* configur_tip_imprsor: */
                         case configur_tip_imprsor.num_carac_configur[v_num_count]:
                               when 0 then put  stream s_1 control null.
                               when ? then leave.
                               otherwise 
                                   /* Convers∆o interna do OUTPUT TARGET */
                                   put stream s_1 control codepage-convert ( chr(configur_tip_imprsor.num_carac_configur[v_num_count]),
                                                                           session:cpinternal,
                                                                           tip_imprsor.cod_pag_carac_conver).
                         end /* case configur_tip_imprsor */.
                    end /* do bloco_1 */.
                end.
            end.
            when "Arquivo" /*l_file*/  then do:
                assign v_cod_dwb_file   = v_nom_arq_bord_ap.
                output stream s_1 to value(v_cod_dwb_file)
                       paged page-size value(v_rpt_s_1_lines) convert target 'iso8859-1'.
            end.
        end.

       /* Gera temp-table para impressao */
        assign v_num_count = 0.
        run pi_tratar_tt_item_bord_ap_imprimir /*pi_tratar_tt_item_bord_ap_imprimir*/. 

       /* verifica se existem itens com forma de pagamento = "Ordem de Pagamento" e se
          n∆o foi informada a conta corrente no fornecedor abre tela para informar. */
        find first tt_erros_inform_bcia_fornec no-lock no-error.
        if  avail tt_erros_inform_bcia_fornec
        then do:
           run pi_messages (input "show",
                            input 5237,
                            input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")).
           assign v_log_answer = (if   return-value = "yes" then yes
                                  else if return-value = "no" then no
                                  else ?) /*msg_5237*/.
           if  v_log_answer = yes
           then do:
              inclui:
              do on error undo inclui, return error.
                  run prgfin/apb/apb710zu.p (Input '') /*prg_fnc_fornec_financ_inc_rpda*/.
              end.
           end.
           for each tt_erros_inform_bcia_fornec no-lock
               break by tt_erros_inform_bcia_fornec.cdn_fornecedor:

               if first-of (tt_erros_inform_bcia_fornec.cdn_fornecedor) then do:
                   for each tt_item_bord_ap_imprimir exclusive-lock
                       where tt_item_bord_ap_imprimir.cdn_fornecedor = tt_erros_inform_bcia_fornec.cdn_fornecedor
                       break by tt_item_bord_ap_imprimir.cdn_fornecedor:

                       if first-of (tt_item_bord_ap_imprimir.cdn_fornecedor) then
                           find b_fornec_financ no-lock
                               where b_fornec_financ.cod_empresa    = tt_item_bord_ap_imprimir.cod_empresa
                                 and b_fornec_financ.cdn_fornecedor = tt_item_bord_ap_imprimir.cdn_fornecedor no-error.

                       if avail b_fornec_financ then do:     
                           assign tt_item_bord_ap_imprimir.tta_cod_banco             = b_fornec_financ.cod_banco
                                  tt_item_bord_ap_imprimir.tta_cod_agenc_bcia        = b_fornec_financ.cod_agenc_bcia.

                          &if '{&emsfin_version}' >= "5.02" &then
                              assign tt_item_bord_ap_imprimir.tta_cod_digito_agenc_bcia = b_fornec_financ.cod_digito_agenc_bcia.                       
                          &else    
                              assign tt_item_bord_ap_imprimir.tta_cod_digito_agenc_bcia = b_fornec_financ.cod_livre_1.                                       
                          &endif.
                       end.
                   end.
               end.   
           end.                 
        end.

        assign v_val_multa_pag_bord   = 0
               v_val_juros_pag_bord   = 0
               v_val_var_mon_pag_bord = 0
               v_val_desc_pag_bord    = 0
               v_val_abat_pag_bord    = 0.

        /* Cabecalho do Bordero */

        find emscad.empresa no-lock
            where empresa.cod_empresa = bord_ap.cod_empresa no-error.
        find estabelecimento no-lock
            where estabelecimento.cod_estab = bord_ap.cod_estab_bord no-error.
        find pessoa_jurid no-lock
            where pessoa_jurid.num_pessoa_jurid = estabelecimento.num_pessoa_jurid no-error.
        assign v_nom_pessoa_jur        = pessoa_jurid.nom_pessoa
               v_nom_endereco          = pessoa_jurid.nom_endereco
               v_nom_cidade_jur        = pessoa_jurid.nom_cidade
               v_cod_unid_federac      = pessoa_jurid.cod_unid_federac.

        &if defined(BF_FIN_4LINHAS_END) &then
            cont_block:
            REPEAT v_num_cont_entry = 1 TO NUM-ENTRIES(pessoa_jurid.nom_ender_text, chr(10)):
                if  v_num_cont_entry = 1 then assign v_nom_ender_lin_1 = entry( 1, pessoa_jurid.nom_ender_text, chr(10)).
                if  v_num_cont_entry = 2 then assign v_nom_ender_lin_2 = entry( 2, pessoa_jurid.nom_ender_text, chr(10)).
                if  v_num_cont_entry = 3 then assign v_nom_ender_lin_3 = entry( 3, pessoa_jurid.nom_ender_text, chr(10)).
                if  v_num_cont_entry = 4 then assign v_nom_ender_lin_4 = entry( 4, pessoa_jurid.nom_ender_text, chr(10)).
                if  v_num_cont_entry = 4 then
                    leave cont_block.
            END.
        &endif

        if  bord_ap.ind_sit_bord_ap = "Em Digitaá∆o" /*l_em_digitacao*/ 
        then do:
            if  v_log_erro_impr = no
            then do:
                assign bord_ap.ind_sit_bord_ap  = "Ja Impresso" /*l_ja_impresso*/ 
                       v_ind_sit_bord_impr      = "Ja Impresso" /*l_ja_impresso*/ .
            end /* if */.
            else do:
                assign v_ind_sit_bord_impr     = "Erro" /*l_erro*/  + "Erro" /*l_erro*/  + "Erro" /*l_erro*/  + "Erro" /*l_erro*/  + "Erro" /*l_erro*/ .
            end /* else */.
        end /* if */.
        case bord_ap.ind_sit_bord_ap:
            when "Ja Impresso" /*l_ja_impresso*/  then do:
                if  v_log_erro_impr = no
                 then 
                     assign v_ind_sit_bord_impr = "Ja Impresso" /*l_ja_impresso*/ .
                 else 
                     assign v_ind_sit_bord_impr = "Erro" /*l_erro*/   + "Erro" /*l_erro*/   + "Erro" /*l_erro*/   + "Erro" /*l_erro*/   + "Erro" /*l_erro*/ .   
            end.
            when "Enviado ao Banco" /*l_enviado_ao_banco*/  then do:
                 if  v_log_erro_impr = no
                 then 
                     assign v_ind_sit_bord_impr = "Enviado ao Banco" /*l_enviado_ao_banco*/ .
                 else 
                     assign v_ind_sit_bord_impr = "Erro" /*l_erro*/   + "Erro" /*l_erro*/   + "Erro" /*l_erro*/   + "Erro" /*l_erro*/   + "Erro" /*l_erro*/ .   
            end.
            when "Parcialmente Baixado" /*l_parcialmente_baixado*/  then do:
                 if  v_log_erro_impr = no
                 then 
                     assign v_ind_sit_bord_impr = "Parcialmente Baixado" /*l_parcialmente_baixado*/ .
                 else 
                     assign v_ind_sit_bord_impr = "Erro" /*l_erro*/   + "Erro" /*l_erro*/   + "Erro" /*l_erro*/   + "Erro" /*l_erro*/   + "Erro" /*l_erro*/ .   
            end.
            when "Totalmente Baixado" /*l_totalmente_baixado*/  then do:
                 if  v_log_erro_impr = no
                 then 
                     assign v_ind_sit_bord_impr = "Totalmente Baixado" /*l_totalmente_baixado*/ .
                 else 
                     assign v_ind_sit_bord_impr = "Erro" /*l_erro*/   + "Erro" /*l_erro*/   + "Erro" /*l_erro*/   + "Erro" /*l_erro*/   + "Erro" /*l_erro*/ .   
            end.
            when "Estornado" /*l_estornado*/  then do:
                 if  v_log_erro_impr = no
                 then 
                     assign v_ind_sit_bord_impr = "Estornado" /*l_estornado*/ .
                 else 
                     assign v_ind_sit_bord_impr = "Erro" /*l_erro*/   + "Erro" /*l_erro*/   + "Erro" /*l_erro*/   + "Erro" /*l_erro*/   + "Erro" /*l_erro*/ .   
            end.
            when "Transmitir ao Banco" /*l_transmitir_ao_banco*/  then do:
                 if  v_log_erro_impr = no
                 then 
                     assign v_ind_sit_bord_impr = "Transmitir ao Banco" /*l_transmitir_ao_banco*/ .
                 else 
                     assign v_ind_sit_bord_impr = "Erro" /*l_erro*/   + "Erro" /*l_erro*/  + "Erro" /*l_erro*/   + "Erro" /*l_erro*/   + "Erro" /*l_erro*/ .   
            end.
        end.    

        find emscad.pais no-lock
            where pais.cod_pais = estabelecimento.cod_pais no-error.

         /* Run na pi de traduá∆o  do indicador economico */
            run pi_traducao_economico. /* pi_traducao_economico */    


        /* ** Grava o indicador econìnico que ser† impresso no borderì ***/
        assign v_cod_indic_econ = bord_ap.cod_indic_econ.

        if not can-find (first tt_log_erros_atualiz) then do:
            if avail bord_ap then
                find portad_finalid_econ no-lock
                    where portad_finalid_econ.cod_estab        = bord_ap.cod_estab_bord
                    and   portad_finalid_econ.cod_portador     = bord_ap.cod_portador
                    and   portad_finalid_econ.cod_cart_bcia    = bord_ap.cod_cart_bcia
                    and   portad_finalid_econ.cod_finalid_econ = bord_ap.cod_finalid_econ no-error.
            if avail portad_finalid_econ then 
                find cta_corren no-lock
                    where cta_corren.cod_cta_corren = portad_finalid_econ.cod_cta_corren no-error.
            else if avail bord_ap then do:
                create tt_log_erros_atualiz.
                assign tt_log_erros_atualiz.tta_cod_estab = bord_ap.cod_estab_bord
                       tt_log_erros_atualiz.ttv_num_mensagem  = 14096
                       tt_log_erros_atualiz.tta_num_seq_refer = 1.
                run pi_messages (input "msg",
                                 input 14096,
                                 input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")).
                assign tt_log_erros_atualiz.ttv_des_msg_erro = return-value /*msg_14096*/.
                run pi_messages (input "help",
                                 input 14096,
                                 input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")).
                assign tt_log_erros_atualiz.ttv_des_msg_ajuda = return-value /*msg_14096*/.
                assign tt_log_erros_atualiz.ttv_des_msg_ajuda = substitute( tt_log_erros_atualiz.ttv_des_msg_ajuda, bord_ap.cod_estab_bord, bord_ap.cod_portador, bord_ap.cod_cart_bcia, bord_ap.cod_finalid_econ).        
            end.

            if avail cta_corren then do:
                assign v_des_cta_corren_portad = cta_corren.cod_cta_corren_bco + " - " + cta_corren.cod_digito_cta_corren.
                find agenc_bcia no-lock
                    where agenc_bcia.cod_banco      = cta_corren.cod_banco
                    and   agenc_bcia.cod_agenc_bcia = cta_corren.cod_agenc_bcia no-error.
                find emscad.banco no-lock
                    where banco.cod_banco = cta_corren.cod_banco no-error.
            end.
            else if avail portad_finalid_econ then do:
                create tt_log_erros_atualiz.
                assign tt_log_erros_atualiz.tta_cod_estab = bord_ap.cod_estab_bord
                       tt_log_erros_atualiz.ttv_num_mensagem  = 14097
                       tt_log_erros_atualiz.tta_num_seq_refer = 1.
                run pi_messages (input "msg",
                                 input 14097,
                                 input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")).
                assign tt_log_erros_atualiz.ttv_des_msg_erro = return-value /*msg_14097*/.
                run pi_messages (input "help",
                                 input 14097,
                                 input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")).
                assign tt_log_erros_atualiz.ttv_des_msg_ajuda = return-value /*msg_14097*/.
                assign tt_log_erros_atualiz.ttv_des_msg_ajuda = substitute(tt_log_erros_atualiz.ttv_des_msg_ajuda, portad_finalid_econ.cod_cta_corren).
            end.

            if avail agenc_bcia and avail banco then do:
                assign v_des_agenc_bcia_portad = agenc_bcia.cod_agenc_bcia + " - " + agenc_bcia.cod_digito_agenc_bcia + " - " + banco.nom_banco.
                find msg_financ no-lock
                    where msg_financ.cod_mensagem = bord_ap.cod_msg_inic
                    and   msg_financ.cod_estab    = bord_ap.cod_estab_bord
                    and   msg_financ.cod_empresa  = bord_ap.cod_empresa no-error.

                if  avail msg_financ then
                    assign v_des_msg_inic_bord_apb = replace(msg_financ.des_mensagem, chr(13), chr(10)).
                else
                    assign v_des_msg_inic_bord_apb = "".

                assign v_nom_aux = pais.nom_label_id_feder_jurid.
                repeat v_num_aux = length(pais.nom_label_id_feder_jurid) to 19:
                    assign v_nom_aux = v_nom_aux + ".".
                end.
                assign v_nom_label_id_feder = v_nom_aux + ":"
                       v_cod_id_feder       = string(pessoa_jurid.cod_id_feder, pais.cod_format_id_feder_jurid)
                       v_cod_cep            = string(pessoa_jurid.cod_cep, pais.cod_format_cep).

                if  bord_ap.log_bord_ap_escrit = no then do:
                    assign v_ind_tip_relat_bord_apb = "Normal" /*l_normal*/ .
                    if  v_log_impr_sit = no then do:
                        /* A variavel v_ind_ender_complet Ç utilizada para a funcao "BF_FIN_4LINHAS_END"
                           Sempre que a funá∆o n∆o estiver sendo utilizada, o valor ser† "Endereáo"      */
                        if  v_ind_ender_complet = "Endereáo" /*l_endereco*/ 
                        then do:
                            /* Imprimi cabeáario com o Endereáo Normal */
                            if (line-counter(s_1) + 9) > v_rpt_s_1_bottom then
                                page stream s_1.
                            put stream s_1 unformatted 
                                "EMPRESA.............:" at 1
                                v_nom_pessoa_jur at 23 format "x(40)" skip
                                "ENDEREÄO............:" at 1
                                v_nom_endereco at 23 format "x(40)" skip
                                "CIDADE..............:" at 1
                                v_nom_cidade_jur at 23 format "x(32)"
                                "-" at 56
                                v_cod_unid_federac at 58 format "x(3)"
                                "-" at 62
                                v_cod_cep at 64 format "x(20)" skip
                                v_nom_label_id_feder at 1 format "x(21)"
                                v_cod_id_feder at 23 format "x(20)" skip
                                "BANCO...............:" at 1
                                banco.nom_banco at 23 format "x(30)" skip
                                "AG“NCIA.............:" at 1
                                v_des_agenc_bcia_portad at 23 format "x(50)" skip
                                "C. CORRENTE.........:" at 1
                                v_des_cta_corren_portad at 23 format "x(25)" skip
                                "BORDER‚.............:" at 1
                                bord_ap.num_bord_ap to 28 format ">>>>>9" skip
                                "DATA EMISS«O........:" at 1
                                bord_ap.dat_transacao at 23 format "99/99/9999"
                                "MOEDA DO BORDER‚:" at 35
                                v_cod_indic_econ at 53 format "x(8)" skip.
                        end /* if */.
                        else do:
                            /* BF_FIN_4LINHAS_END */
                            if (line-counter(s_1) + 10) > v_rpt_s_1_bottom then
                                page stream s_1.
                            put stream s_1 unformatted 
                                "EMPRESA.............:" at 1
                                v_nom_pessoa_jur at 23 format "x(40)" skip
                                "ENDEREÄO............:" at 1
                                v_nom_ender_lin_1 at 23 format "x(50)" skip
                                v_nom_ender_lin_2 at 23 format "x(50)" skip
                                v_nom_ender_lin_3 at 23 format "x(50)" skip
                                v_nom_ender_lin_4 at 23 format "x(50)" skip
                                "BANCO...............:" at 1
                                banco.nom_banco at 23 format "x(30)" skip
                                "AG“NCIA.............:" at 1
                                v_des_agenc_bcia_portad at 23 format "x(50)" skip
                                "C. CORRENTE.........:" at 1
                                v_des_cta_corren_portad at 23 format "x(25)" skip
                                "BORDER‚.............:" at 1
                                bord_ap.num_bord_ap to 28 format ">>>>>9" skip
                                "DATA EMISS«O........:" at 1
                                bord_ap.dat_transacao at 23 format "99/99/9999"
                                "MOEDA DO BORDER‚:" at 35
                                v_cod_indic_econ at 53 format "x(8)" skip.
                        end /* else */.
                    end.
                    else do:
                        /* A variavel v_ind_ender_complet Ç utilizada para a funcao "BF_FIN_4LINHAS_END"
                           Sempre que a funá∆o n∆o estiver sendo utilizada, o valor ser† "Endereáo"      */
                        if  v_ind_ender_complet = "Endereáo" /*l_endereco*/ 
                        then do:
                            /* Imprimi cabeáario com o Endereáo Normal */
                            if (line-counter(s_1) + 9) > v_rpt_s_1_bottom then
                                page stream s_1.
                            put stream s_1 unformatted 
                                "EMPRESA.............:" at 1
                                v_nom_pessoa_jur at 23 format "x(40)" skip
                                "ENDEREÄO............:" at 1
                                v_nom_endereco at 23 format "x(40)" skip
                                "CIDADE..............:" at 1
                                v_nom_cidade_jur at 23 format "x(32)"
                                "-" at 56
                                v_cod_unid_federac at 58 format "x(3)"
                                "-" at 62
                                v_cod_cep at 64 format "x(20)" skip
                                v_nom_label_id_feder at 1 format "x(21)"
                                v_cod_id_feder at 23 format "x(20)" skip
                                "BANCO...............:" at 1
                                banco.nom_banco at 23 format "x(30)" skip
                                "AG“NCIA.............:" at 1
                                v_des_agenc_bcia_portad at 23 format "x(50)" skip
                                "C. CORRENTE.........:" at 1
                                v_des_cta_corren_portad at 23 format "x(25)" skip
                                "BORDER‚.............:" at 1
                                bord_ap.num_bord_ap to 28 format ">>>>>9"
                                "SITUAÄ«O............:" at 31
                                v_ind_sit_bord_impr at 53 format "X(20)" skip
                                "DATA EMISS«O........:" at 1
                                bord_ap.dat_transacao at 23 format "99/99/9999"
                                "MOEDA DO BORDER‚:" at 35
                                v_cod_indic_econ at 53 format "x(8)" skip.
                        end /* if */.
                        else do:
                            /* BF_FIN_4LINHAS_END */
                            if (line-counter(s_1) + 10) > v_rpt_s_1_bottom then
                                page stream s_1.
                            put stream s_1 unformatted 
                                "EMPRESA.............:" at 1
                                v_nom_pessoa_jur at 23 format "x(40)" skip
                                "ENDEREÄO............:" at 1
                                v_nom_ender_lin_1 at 23 format "x(50)" skip
                                v_nom_ender_lin_2 at 23 format "x(50)" skip
                                v_nom_ender_lin_3 at 23 format "x(50)" skip
                                v_nom_ender_lin_4 at 23 format "x(50)" skip
                                "BANCO...............:" at 1
                                banco.nom_banco at 23 format "x(30)" skip
                                "AG“NCIA.............:" at 1
                                v_des_agenc_bcia_portad at 23 format "x(50)" skip
                                "C. CORRENTE.........:" at 1
                                v_des_cta_corren_portad at 23 format "x(25)" skip
                                "BORDER‚.............:" at 1
                                bord_ap.num_bord_ap to 28 format ">>>>>9"
                                "SITUAÄ«O............:" at 31
                                v_ind_sit_bord_impr at 53 format "X(20)" skip
                                "DATA EMISS«O........:" at 1
                                bord_ap.dat_transacao at 23 format "99/99/9999"
                                "MOEDA DO BORDER‚:" at 35
                                v_cod_indic_econ at 53 format "x(8)" skip.
                        end /* else */.
                    end.
                end.
                else do:
                    assign v_ind_tip_relat_bord_apb = "Escritural" /*l_escritural*/ .
                    if  v_log_impr_sit = no then do:
                        /* A variavel v_ind_ender_complet Ç utilizada para a funcao "BF_FIN_4LINHAS_END"
                           Sempre que a funá∆o n∆o estiver sendo utilizada, o valor ser† "Endereáo"      */
                        if  v_ind_ender_complet = "Endereáo" /*l_endereco*/ 
                        then do:
                            /* Imprimi cabeáario com o Endereáo Normal */
                            if (line-counter(s_1) + 9) > v_rpt_s_1_bottom then
                                page stream s_1.
                            put stream s_1 unformatted 
                                "EMPRESA.............:" at 1
                                v_nom_pessoa_jur at 23 format "x(40)" skip
                                "ENDEREÄO............:" at 1
                                v_nom_endereco at 23 format "x(40)" skip
                                "CIDADE..............:" at 1
                                v_nom_cidade_jur at 23 format "x(32)"
                                "-" at 56
                                v_cod_unid_federac at 58 format "x(3)"
                                "-" at 62
                                v_cod_cep at 64 format "x(20)" skip
                                v_nom_label_id_feder at 1 format "x(21)"
                                v_cod_id_feder at 23 format "x(20)" skip
                                "BANCO...............:" at 1
                                banco.nom_banco at 23 format "x(30)"
                                "*********************" at 94 skip
                                "AG“NCIA.............:" at 1
                                v_des_agenc_bcia_portad at 23 format "x(50)"
                                "*" at 94
                                "  BORDER‚  " at 99
                                "*" at 114 skip
                                "C. CORRENTE.........:" at 1
                                v_des_cta_corren_portad at 23 format "x(25)"
                                "*" at 94
                                " ESCRITURAL  " at 99
                                "*" at 114 skip
                                "BORDER‚.............:" at 1
                                bord_ap.num_bord_ap to 28 format ">>>>>9"
                                "*********************" at 94 skip
                                "DATA EMISS«O........:" at 1
                                bord_ap.dat_transacao at 23 format "99/99/9999" skip.
                        end /* if */.
                        else do:
                            /* BF_FIN_4LINHAS_END */
                            if (line-counter(s_1) + 10) > v_rpt_s_1_bottom then
                                page stream s_1.
                            put stream s_1 unformatted 
                                "EMPRESA.............:" at 1
                                v_nom_pessoa_jur at 23 format "x(40)" skip
                                "ENDEREÄO............:" at 1
                                v_nom_ender_lin_1 at 23 format "x(50)" skip
                                v_nom_ender_lin_2 at 23 format "x(50)" skip
                                v_nom_ender_lin_3 at 23 format "x(50)" skip
                                v_nom_ender_lin_4 at 23 format "x(50)" skip
                                "BANCO...............:" at 1
                                banco.nom_banco at 23 format "x(30)"
                                "*********************" at 94 skip
                                "AG“NCIA.............:" at 1
                                v_des_agenc_bcia_portad at 23 format "x(50)"
                                "*" at 94
                                "  BORDER‚  " at 99
                                "*" at 114 skip
                                "C. CORRENTE.........:" at 1
                                v_des_cta_corren_portad at 23 format "x(25)"
                                "*" at 94
                                " ESCRITURAL  " at 99
                                "*" at 114 skip
                                "BORDER‚.............:" at 1
                                bord_ap.num_bord_ap to 28 format ">>>>>9"
                                "*********************" at 94 skip
                                "DATA EMISS«O........:" at 1
                                bord_ap.dat_transacao at 23 format "99/99/9999" skip.
                        end /* else */.
                    end.
                    else do:
                        /* A variavel v_ind_ender_complet Ç utilizada para a funcao "BF_FIN_4LINHAS_END"
                           Sempre que a funá∆o n∆o estiver sendo utilizada, o valor ser† "Endereáo"      */
                        if  v_ind_ender_complet = "Endereáo" /*l_endereco*/ 
                        then do:
                            /* Imprimi cabeáario com o Endereáo Normal */
                            if (line-counter(s_1) + 9) > v_rpt_s_1_bottom then
                                page stream s_1.
                            put stream s_1 unformatted 
                                "EMPRESA.............:" at 1
                                v_nom_pessoa_jur at 23 format "x(40)" skip
                                "ENDEREÄO............:" at 1
                                v_nom_endereco at 23 format "x(40)" skip
                                "CIDADE..............:" at 1
                                v_nom_cidade_jur at 23 format "x(32)"
                                "-" at 56
                                v_cod_unid_federac at 58 format "x(3)"
                                "-" at 62
                                v_cod_cep at 64 format "x(20)" skip
                                v_nom_label_id_feder at 1 format "x(21)"
                                v_cod_id_feder at 23 format "x(20)" skip
                                "BANCO...............:" at 1
                                banco.nom_banco at 23 format "x(30)"
                                "*********************" at 94 skip
                                "AG“NCIA.............:" at 1
                                v_des_agenc_bcia_portad at 23 format "x(50)"
                                "*" at 94
                                "  BORDER‚  " at 99
                                "*" at 114 skip
                                "C. CORRENTE.........:" at 1
                                v_des_cta_corren_portad at 23 format "x(25)"
                                "*" at 94
                                " ESCRITURAL  " at 99
                                "*" at 114 skip
                                "BORDER‚.............:" at 1
                                bord_ap.num_bord_ap to 28 format ">>>>>9"
                                "SITUAÄ«O............:" at 31
                                v_ind_sit_bord_impr at 53 format "X(20)"
                                "*********************" at 94 skip
                                "DATA EMISS«O........:" at 1
                                bord_ap.dat_transacao at 23 format "99/99/9999" skip.
                        end /* if */.
                        else do:
                            /* BF_FIN_4LINHAS_END */
                            if (line-counter(s_1) + 10) > v_rpt_s_1_bottom then
                                page stream s_1.
                            put stream s_1 unformatted 
                                "EMPRESA.............:" at 1
                                v_nom_pessoa_jur at 23 format "x(40)" skip
                                "ENDEREÄO............:" at 1
                                v_nom_ender_lin_1 at 23 format "x(50)" skip
                                v_nom_ender_lin_2 at 23 format "x(50)" skip
                                v_nom_ender_lin_3 at 23 format "x(50)" skip
                                v_nom_ender_lin_4 at 23 format "x(50)" skip
                                "BANCO...............:" at 1
                                banco.nom_banco at 23 format "x(30)"
                                "*********************" at 94 skip
                                "AG“NCIA.............:" at 1
                                v_des_agenc_bcia_portad at 23 format "x(50)"
                                "*" at 94
                                "  BORDER‚  " at 99
                                "*" at 114 skip
                                "C. CORRENTE.........:" at 1
                                v_des_cta_corren_portad at 23 format "x(25)"
                                "*" at 94
                                " ESCRITURAL  " at 99
                                "*" at 114 skip
                                "BORDER‚.............:" at 1
                                bord_ap.num_bord_ap to 28 format ">>>>>9"
                                "SITUAÄ«O............:" at 31
                                v_ind_sit_bord_impr at 53 format "X(20)"
                                "*********************" at 94 skip
                                "DATA EMISS«O........:" at 1
                                bord_ap.dat_transacao at 23 format "99/99/9999" skip.
                        end /* else */.
                    end.
                end.

                run pi_imprime_complemento_cabec_bordero (Input v_ind_tip_relat_bord_apb,
                                                          Input v_des_msg_inic_bord_apb) /*pi_imprime_complemento_cabec_bordero*/.

                if (line-counter(s_1) + 1) > v_rpt_s_1_bottom then
                    page stream s_1.
                put stream s_1 unformatted 
                    "---------------------------------------------------------" at 1
                    "---------------------------------------------------------" at 58 skip.
                if (line-counter(s_1) + 5) > v_rpt_s_1_bottom then
                    page stream s_1.
                put stream s_1 unformatted 
                    "Fornec" to 11
                    "Documento" at 13
                    "Dt Emiss∆o" at 39
                    "Valor Pagto" to 66
                    "Vl Multa" to 82
                    "Vl Juros" to 98
                    "Corr Monet" to 114 skip
                    "Vencto" at 39
                    "Impto Retido" to 66
                    "Vl Descto" to 82
                    "Vl Abat" to 98
                    "Valor L°quido" to 114 skip
                    "------------------------------------------------------------------------------------------------------------------" at 1 skip.

                assign v_num_aux = 0.

                /* Imprime itens do Borderì de acordo com classificacao */
                run pi_rpt_bord_ap_msg_financ /*pi_rpt_bord_ap_msg_financ*/.

                /* Verifica se ultima pagina possui titulos e imprime total da pagina */
                if  v_qtd_tot_tit_pag_bord <> 0 then do:
                    assign v_qtd_tot_tit_bord = v_qtd_tot_tit_bord + v_qtd_tot_tit_pag_bord
                           v_val_tot_bord     = v_val_tot_bord     + v_val_pag_bord
                           v_val_multa_bord   = v_val_multa_bord   + v_val_multa_pag_bord
                           v_val_juros_bord   = v_val_juros_bord   + v_val_juros_pag_bord
                           v_val_var_mon_bord = v_val_var_mon_bord + v_val_var_mon_pag_bord
                           v_val_desc_bord    = v_val_desc_bord    + v_val_desc_pag_bord
                           v_val_abat_bord    = v_val_abat_bord    + v_val_abat_pag_bord
                           v_val_liq_bord     = v_val_liq_bord     + v_val_liq_pag_bord.
                    if (line-counter(s_1) + 5) > v_rpt_s_1_bottom then
                        page stream s_1.
                    put stream s_1 unformatted 
                        "---------------------------------------------------------" at 1
                        "---------------------------------------------------------" at 58 skip
                        "Total da  Pagina:" at 1
                        v_val_pag_bord to 37 format ">,>>>,>>>,>>9.99"
                        v_val_multa_pag_bord to 82 format "->>>,>>>,>>9.99"
                        v_val_juros_pag_bord to 98 format "->>>,>>>,>>9.99"
                        v_val_var_mon_pag_bord to 114 format "->>>,>>>,>>9.99" skip
                        "Total de Titulos:" at 1
                        v_qtd_tot_tit_pag_bord to 34 format ">>9"
                        v_val_pag_tot_impto to 66 format "->>>,>>>,>>9.99"
                        v_val_desc_pag_bord to 82 format "->>>,>>>,>>9.99"
                        v_val_abat_pag_bord to 98 format "->>>,>>>,>>9.99"
                        v_val_liq_pag_bord to 114 format "->>>,>>>,>>9.99" skip
                        "---------------------------------------------------------" at 1
                        "---------------------------------------------------------" at 58 skip (1).
                end.

                /* Imprime Total do Bordero */        
                if  v_log_impr_tot_bord_assin
                then do:
                    run pi_retorna_total_lin_msg_encerramento (Input bord_ap.cod_empresa,
                                                               Input bord_ap.cod_estab_bord,
                                                               Input bord_ap.cod_msg_fim,
                                                               output v_num_cont) /*pi_retorna_total_lin_msg_encerramento*/.
                    /* Soma o total de linhas que retornou da pi, com o total de linhas do "Total do BorderÀ" com o "Total Extenso Bordero "*/
                    assign v_num_cont = v_num_cont + 16.
                    if  (line-counter(s_1) + v_num_cont) > v_rpt_s_1_bottom
                    then do:
                        put stream s_1 unformatted 
                            ' Pag: ' at 104
                            v_num_pag to 113 format ">>>9" skip (1).
                        page stream s_1.
                        if  v_log_cabec_todas_pag = yes then
                            run pi_cabec_bord_ap /*pi_cabec_bord_ap*/.
                        assign v_num_pag = v_num_pag + 1.                        
                    end /* if */.
                end /* if */.
                else do:
                    if  (line-counter(s_1) + 6) > v_rpt_s_1_bottom
                    then do:
                        if (line-counter(s_1) + 2) > v_rpt_s_1_bottom then
                            page stream s_1.
                        put stream s_1 unformatted 
                            " Pag: " at 104
                            v_num_pag to 113 format ">>>9" skip (1).
                        page stream s_1.
                        if  v_log_cabec_todas_pag = yes then
                            run pi_cabec_bord_ap /*pi_cabec_bord_ap*/.
                        assign v_num_pag = v_num_pag + 1.
                    end /* if */.
                end /* else */.

                if (line-counter(s_1) + 5) > v_rpt_s_1_bottom then
                    page stream s_1.
                put stream s_1 unformatted 
                    "---------------------------------------------------------" at 1
                    "---------------------------------------------------------" at 58 skip
                    "Total do Bordero:" at 1
                    v_val_tot_bord to 37 format ">>,>>>,>>>,>>9.99"
                    v_val_multa_bord to 82 format "->>>,>>>,>>9.99"
                    v_val_juros_bord to 98 format "->>>,>>>,>>9.99"
                    v_val_var_mon_bord to 114 format "->>>,>>>,>>9.99" skip
                    "Total de Titulos:" at 1
                    v_qtd_tot_tit_bord to 35 format ">>>9"
                    v_val_tot_impto_tot to 66 format "->>>,>>>,>>9.99"
                    v_val_desc_bord to 82 format "->>>,>>>,>>9.99"
                    v_val_abat_bord to 98 format "->>>,>>>,>>9.99"
                    v_val_liq_bord to 114 format "->>>,>>>,>>9.99" skip
                    "---------------------------------------------------------" at 1
                    "---------------------------------------------------------" at 58 skip (1).

                /* Imprime Total Extenso Bordero */
                if  (line-counter(s_1) + 6) > v_rpt_s_1_bottom then do:
                    do  v_num_impr =  line-counter(s_1) to ( v_rpt_s_1_bottom - 2 ):
                        if (line-counter(s_1) + 1) > v_rpt_s_1_bottom then
                            page stream s_1.
                        put stream s_1 unformatted  skip (1).
                    end.
                    if (line-counter(s_1) + 2) > v_rpt_s_1_bottom then
                        page stream s_1.
                    put stream s_1 unformatted 
                        " Pag: " at 104
                        v_num_pag to 113 format ">>>9" skip (1).
                    page stream s_1.
                    if  v_log_cabec_todas_pag = yes then
                        run pi_cabec_bord_ap /*pi_cabec_bord_ap*/.
                    assign v_num_pag = v_num_pag + 1.
                end.

                find first idiom_pais no-lock
                    where idiom_pais.cod_pais        = pais.cod_pais
                    and   idiom_pais.log_idiom_princ = yes no-error.

                assign v_des_extenso_bord [1] = ""
                       v_des_extenso_bord [2] = "".

                if avail idiom_pais then do:
                    run prgint/utb/utb900za.py (Input v_val_liq_bord,
                                                Input 2,
                                                Input 80,
                                                Input idiom_pais.cod_idioma,
                                                Input bord_ap.cod_indic_econ,
                                                output v_cod_return) /*prg_fnc_conv_val_extenso*/.
                    for each tt_val_extenso no-lock:
                        if  v_des_extenso_bord [1] = "" then
                            assign v_des_extenso_bord [1] = tt_val_extenso.ttv_des_val_extenso.
                        else
                            assign v_des_extenso_bord [2] = tt_val_extenso.ttv_des_val_extenso.
                    end.
                    /* ** Tratamento para erro de traduá∆o do valor ***/
                    if not avail tt_val_extenso and  entry(1,v_cod_return) = '1284' then do:
                        assign v_des_extenso_bord [1] = substring(substitute("Verifique se existe uma ocorrància para o(a) &1 informado(a) no cadastro de &2." /*1284*/,entry(2,v_cod_return),entry(3,v_cod_return)),1,74)
                               v_des_extenso_bord [2] = substring(substitute("Verifique se existe uma ocorrància para o(a) &1 informado(a) no cadastro de &2." /*1284*/,entry(2,v_cod_return),entry(3,v_cod_return)),75,70).
                    end.
                end.
                else do:
                    assign v_des_extenso_bord [1] = substring(substitute("Verifique se existe uma ocorrància para o(a) &1 informado(a) no cadastro de &2." /*1284*/,"Idioma Pa°s","Idiomas Pa°s"),1,73)
                           v_des_extenso_bord [2] = substring(substitute("Verifique se existe uma ocorrància para o(a) &1 informado(a) no cadastro de &2." /*1284*/,"Idioma Pa°s","Idiomas Pa°s"),74,70).
                end.
                if (line-counter(s_1) + 5) > v_rpt_s_1_bottom then
                    page stream s_1.
                put stream s_1 unformatted 
                    "---------------------------------------------------------" at 4
                    "-------------------" at 61
                    "-------------------" at 80
                    "---------" at 99
                    "----" at 108 skip
                    "|" at 4
                    "Total do Borderì..: " at 6
                    v_des_extenso_bord[1] at 26 format "x(80)"
                    "|" at 111 skip
                    "|" at 4
                    v_des_extenso_bord[2] at 26 format "x(80)"
                    "|" at 111 skip
                    "---------------------------------------------------------" at 4
                    "-------------------" at 61
                    "-------------------" at 80
                    "---------" at 99
                    "----" at 108 skip (1).

                /* Mensagem de Fim do Bordero */
                if  (line-counter(s_1) + 10) > v_rpt_s_1_bottom then do:
                    if (line-counter(s_1) + 2) > v_rpt_s_1_bottom then
                        page stream s_1.
                    put stream s_1 unformatted 
                        " Pag: " at 104
                        v_num_pag to 113 format ">>>9" skip (1).
                    page stream s_1.
                    if  v_log_cabec_todas_pag = yes then
                        run pi_cabec_bord_ap /*pi_cabec_bord_ap*/.
                    assign v_num_pag = v_num_pag + 1.
                end.

                find msg_financ no-lock
                     where msg_financ.cod_empresa  = bord_ap.cod_empresa
                     and   msg_financ.cod_estab    = bord_ap.cod_estab_bord
                     and   msg_financ.cod_mensagem = bord_ap.cod_msg_fim no-error.
                if  avail msg_financ then
                    assign v_des_msg_fim_bord_apb = replace(msg_financ.des_mensagem, chr(13), chr(10)).
                else
                    assign v_des_msg_fim_bord_apb = "".

                repeat:
                    if v_des_msg_fim_bord_apb = "" then leave.

                    if  index(v_des_msg_fim_bord_apb, chr(10)) > 0
                    then do:
                        assign v_des_msg_lin_bord_apb = substring(v_des_msg_fim_bord_apb, 1, index(v_des_msg_fim_bord_apb,chr(10)) - 1 )
                               v_des_msg_fim_bord_apb     = substring(v_des_msg_fim_bord_apb, index(v_des_msg_fim_bord_apb,chr(10)) + 1).
                    end /* if */.
                    else do:
                        assign v_des_msg_lin_bord_apb = v_des_msg_fim_bord_apb
                               v_des_msg_fim_bord_apb     = "".
                    end /* else */.

                    assign v_des_msg_lin_bord_apb_aux = substring(v_des_msg_lin_bord_apb, 1, 80).
                    if (line-counter(s_1) + 1) > v_rpt_s_1_bottom then
                        page stream s_1.
                    put stream s_1 unformatted 
                        v_des_msg_lin_bord_apb_aux at 17 format "x(80)" skip.                
                    if  length(v_des_msg_lin_bord_apb) > 80
                    then do:
                        assign v_des_msg_lin_bord_apb = substring(v_des_msg_lin_bord_apb, 81).
                        repeat:
                            if v_des_msg_lin_bord_apb = "" then leave.

                            if  length(v_des_msg_lin_bord_apb) > 95
                            then do:
                                assign v_des_msg_lin_compl_bord_apb = trim(substring(v_des_msg_lin_bord_apb, 1, 94))
                                       v_des_msg_lin_bord_apb = substring(v_des_msg_lin_bord_apb, 95).
                            end /* if */.
                            else do:
                                assign v_des_msg_lin_compl_bord_apb = trim(v_des_msg_lin_bord_apb)
                                       v_des_msg_lin_bord_apb = "".
                            end /* else */.
                            if (line-counter(s_1) + 1) > v_rpt_s_1_bottom then
                                page stream s_1.
                            put stream s_1 unformatted 
                                v_des_msg_lin_compl_bord_apb at 3 format "x(94)" skip.
                        end.
                    end /* if */.
                end.
                if (line-counter(s_1) + 3) > v_rpt_s_1_bottom then
                    page stream s_1.
                put stream s_1 unformatted 
                    skip (2)
                    "-------------------" at 29
                    "-------------------" at 48
                    "-------------------" at 67 skip.
                if (line-counter(s_1) + 2) > v_rpt_s_1_bottom then
                    page stream s_1.
                put stream s_1 unformatted 
                    " Pag: " at 104
                    v_num_pag to 113 format ">>>9" skip (1).
                output stream s_1 close.
            end.
            else if avail cta_corren then do:
                if  not avail agenc_bcia
                then do:
                    create tt_log_erros_atualiz.
                    assign tt_log_erros_atualiz.tta_cod_estab = bord_ap.cod_estab_bord
                           tt_log_erros_atualiz.ttv_num_mensagem  = 14099
                           tt_log_erros_atualiz.tta_num_seq_refer = 1.
                    run pi_messages (input "msg",
                                     input 14099,
                                     input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")).
                    assign tt_log_erros_atualiz.ttv_des_msg_erro = return-value /*msg_14099*/.
                    run pi_messages (input "help",
                                     input 14099,
                                     input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")).
                    assign tt_log_erros_atualiz.ttv_des_msg_ajuda = return-value /*msg_14099*/.
                    assign tt_log_erros_atualiz.ttv_des_msg_ajuda = substitute(tt_log_erros_atualiz.ttv_des_msg_ajuda, cta_corren.cod_agenc_bcia, cta_corren.cod_banco ).
                end /* if */.
                else do:
                    create tt_log_erros_atualiz.
                    assign tt_log_erros_atualiz.tta_cod_estab = bord_ap.cod_estab_bord
                           tt_log_erros_atualiz.ttv_num_mensagem  = 14101
                           tt_log_erros_atualiz.tta_num_seq_refer = 1.
                    run pi_messages (input "msg",
                                     input 14101,
                                     input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")).
                    assign tt_log_erros_atualiz.ttv_des_msg_erro = return-value /*msg_14101*/.
                    run pi_messages (input "help",
                                     input 14101,
                                     input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")).
                    assign tt_log_erros_atualiz.ttv_des_msg_ajuda = return-value /*msg_14101*/.
                    assign tt_log_erros_atualiz.ttv_des_msg_ajuda = substitute(tt_log_erros_atualiz.ttv_des_msg_ajuda, cta_corren.cod_banco ).
                end /* else */.
            end.
        end.
        if  can-find(first tt_log_erros_atualiz)
        then do:
            for each tt_log_erros_atualiz no-lock
                break by tt_log_erros_atualiz.tta_num_seq_refer:
                if first-of (tt_log_erros_atualiz.tta_num_seq_refer) then do:
                    if (line-counter(s_1) + 5) > v_rpt_s_1_bottom then
                        page stream s_1.
                    put stream s_1 unformatted 
                        "Est" at 1
                        "Seq" to 8
                        "N£mero" to 17
                        "Erro" at 19 skip
                        "Ajuda" at 19 skip
                        "------------------------------------------------------------------------------------------------------------" at 1 skip.
                end.
                assign v_des_erro_item_bord_ap = tt_log_erros_atualiz.ttv_des_msg_ajuda.
                run pi_print_editor ("s_1", tt_log_erros_atualiz.ttv_des_msg_erro, "     060",v_des_erro_item_bord_ap, "     090", "", "     ").
                put stream s_1 unformatted 
                    tt_log_erros_atualiz.tta_cod_estab at 1 format "x(3)"
                    tt_log_erros_atualiz.tta_num_seq_refer to 8 format ">>>9"
                    tt_log_erros_atualiz.ttv_num_mensagem to 17 format ">>>>,>>9"
                    entry(1, return-value, chr(255)) at 19 format "x(60)" skip
                    entry(2, return-value, chr(255)) at 19 format "x(90)" skip.
                run pi_print_editor ("s_1", tt_log_erros_atualiz.ttv_des_msg_erro, "at019060",v_des_erro_item_bord_ap, "at019090", "", "").
            end.
            output stream s_1 close.
        end /* if */.
    end.

END PROCEDURE. /* pi_rpt_bord_ap_imprimir */
/*****************************************************************************
** Procedure Interna.....: pi_tratar_tt_item_bord_ap_imprimir
** Descricao.............: pi_tratar_tt_item_bord_ap_imprimir
** Criado por............: Ganzen
** Criado em.............: 24/11/1995 08:47:24
** Alterado por..........: fut41420
** Alterado em...........: 01/04/2009 11:44:52
*****************************************************************************/
PROCEDURE pi_tratar_tt_item_bord_ap_imprimir:

    /************************** Buffer Definition Begin *************************/

    &if "{&emsfin_version}" >= "5.01" &then
    def buffer b_item_bord_ap_delete
        for item_bord_ap.
    &endif


    /*************************** Buffer Definition End **************************/

    /************************* Variable Definition Begin ************************/

    def var v_cod_barra
        as character
        format "x(44)":U
        no-undo.
    def var v_log_abat_antecip
        as logical
        format "Sim/N∆o"
        initial yes
        no-undo.
    def var v_nom_pessoa
        as character
        format "x(40)":U
        label "Nome"
        column-label "Nome"
        no-undo.
    def var v_val_tot_abat
        as decimal
        format "->>,>>>,>>>,>>9.99":U
        decimals 2
        label "Tot Abat"
        column-label "Tot Abat"
        no-undo.
    def var v_val_tot_abat_antecip
        as decimal
        format "->>,>>>,>>>,>>9.99":U
        decimals 2
        no-undo.
    def var v_log_funcao                     as logical         no-undo. /*local*/


    /************************** Variable Definition End *************************/

    assign v_log_erro_impr = no  v_val_liq_item_bord = 0.
    for each item_bord_ap exclusive-lock
        where item_bord_ap.cod_estab_bord = bord_ap.cod_estab_bord
        and item_bord_ap.cod_portador = bord_ap.cod_portador
        and item_bord_ap.num_bord_ap = bord_ap.num_bord_ap
        and ((item_bord_ap.ind_sit_item_bord_ap <> "Estornado" /*l_estornado*/ 
             and v_log_impr_item_estorn = no )
        or v_log_impr_item_estorn)
        break by item_bord_ap.cod_forma_pagto
           by item_bord_ap.cdn_fornecedor
           by item_bord_ap.dat_vencto_tit_ap:
        run pi_gravar_datas_item_bord_ap.
        if first-of (item_bord_ap.cod_forma_pagto) then
           find forma_pagto no-lock
                where forma_pagto.cod_forma_pagto = item_bord_ap.cod_forma_pagto no-error.

        assign v_ind_origin_tit_ap = "".
        if  item_bord_ap.cod_refer_antecip_pef = ""
        or  item_bord_ap.cod_refer_antecip_pef = ?
        then do:
           find first tit_ap
                where tit_ap.cod_estab = item_bord_ap.cod_estab
                and tit_ap.cod_espec_docto = item_bord_ap.cod_espec_docto
                and tit_ap.cod_ser_docto = item_bord_ap.cod_ser_docto
                and tit_ap.cdn_fornecedor = item_bord_ap.cdn_fornecedor
                and tit_ap.cod_tit_ap = item_bord_ap.cod_tit_ap
                and tit_ap.cod_parcela = item_bord_ap.cod_parcela no-lock no-error.
           if  avail tit_ap
           then do:
             assign v_ind_origin_tit_ap = tit_ap.ind_origin_tit_ap.
             &if '{&emsfin_version}' >= "5.02" &then
                 if tit_ap.cb4_tit_ap_bco_cobdor <> "" then
                    assign v_cod_barra = tit_ap.cb4_tit_ap_bco_cobdor.
                 else assign v_cod_barra = "".
             &else
                 assign v_cod_barra = "".
             &endif
           end.
        end.
        else do:
          &IF '{&emsfin_version}' >= "5.04" &THEN
             for first antecip_pef_pend
                 FIELDS(antecip_pef_pend.cod_estab 
                        antecip_pef_pend.cod_refer 
                        antecip_pef_pend.ind_origin_tit_ap)
                 where antecip_pef_pend.cod_estab = item_bord_ap.cod_estab
                 and antecip_pef_pend.cod_refer = item_bord_ap.cod_refer_antecip_pef no-lock:
             end.
             if avail antecip_pef_pend then
                assign v_ind_origin_tit_ap = antecip_pef_pend.ind_origin_tit_ap.
          &ENDIF
        end.
        if  avail forma_pagto
        then do:
          if  first-of (item_bord_ap.cdn_fornecedor) or item_bord_ap.cdn_fornecedor = 0 or forma_pagto.log_agrup_tit_fornec = no or v_cod_barra <> ""
          then do:
             run pi_tratar_tt_item_bord_ap_imprimir_001 (output v_nom_pessoa) /*pi_tratar_tt_item_bord_ap_imprimir_001*/.
          end.
        end.
        find b_forma_pagto no-lock
           where b_forma_pagto.cod_forma_pagto = v_cod_forma_pagto_altern no-error.
        if  avail b_forma_pagto and b_forma_pagto.log_agrup_tit_fornec = yes and v_cod_barra = ""
        then do:
           run pi_verificar_abat_antecip_voucher_pagto (Input item_bord_ap.cod_estab_bord,
                                                        Input " ",
                                                        Input item_bord_ap.num_seq_bord,
                                                        Input item_bord_ap.cod_portador,
                                                        Input item_bord_ap.num_bord_ap,
                                                        Input "Antecipaá∆o" /*l_antecipacao*/,
                                                        output v_log_abat_antecip,
                                                        output v_val_tot_abat_antecip,
                                                        output v_val_tot_abat) /*pi_verificar_abat_antecip_voucher_pagto*/.
           if  item_bord_ap.cod_refer_antecip_pef <> ""
           and item_bord_ap.cod_refer_antecip_pef <> ? then
               if  search("prgfin/apb/apb794za.r") = ? and search("prgfin/apb/apb794za.py") = ? then do:
                   if  v_cod_dwb_user begins 'es_' then
                       return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgfin/apb/apb794za.py".
                   else do:
                       message "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  "prgfin/apb/apb794za.py"
                              view-as alert-box error buttons ok.
                       return.
                   end.
               end.
               else
                   run prgfin/apb/apb794za.py (Input item_bord_ap.cod_estab,
                                           Input item_bord_ap.cod_refer_antecip_pef,
                                           Input "",
                                           Input 0,
                                           Input 0,
                                           Input yes,
                                           Input bord_ap.dat_transacao,
                                           Input "Retido" /*l_retido*/,
                                           output v_log_impto_vincul_refer,
                                           output v_val_tot_impto,
                                           Input recid(bord_ap),
                                           Input recid(cheq_ap),
                                           Input recid(item_lote_pagto)) /*prg_fnc_verificar_impto_vincul_refer*/.
           else
               if  search("prgfin/apb/apb794za.r") = ? and search("prgfin/apb/apb794za.py") = ? then do:
                   if  v_cod_dwb_user begins 'es_' then
                       return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgfin/apb/apb794za.py".
                   else do:
                       message "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  "prgfin/apb/apb794za.py"
                              view-as alert-box error buttons ok.
                       return.
                   end.
               end.
               else
                   run prgfin/apb/apb794za.py (Input item_bord_ap.cod_estab_bord,
                                           Input "",
                                           Input bord_ap.cod_portador,
                                           Input bord_ap.num_bord_ap,
                                           Input item_bord_ap.num_seq_bord,
                                           Input yes,
                                           Input bord_ap.dat_transacao,
                                           Input "Retido" /*l_retido*/,
                                           output v_log_impto_vincul_refer,
                                           output v_val_tot_impto,
                                           Input ?,
                                           Input ?,
                                           Input ?) /*prg_fnc_verificar_impto_vincul_refer*/.


           if v_log_dat_pagto_bord = yes then do:

               if item_bord_ap.dat_pagto_tit_ap < bord_ap.dat_transacao then do:
                   assign item_bord_ap.dat_pagto_tit_ap = bord_ap.dat_transacao.
               end.

               find first tt_item_bord_ap_imprimir no-lock
                    where tt_item_bord_ap_imprimir.cod_estab_bord = item_bord_ap.cod_estab_bord
                    and   tt_item_bord_ap_imprimir.cod_portador = item_bord_ap.cod_portador
                    and   tt_item_bord_ap_imprimir.num_bord_ap  = item_bord_ap.num_bord_ap
                    and   tt_item_bord_ap_imprimir.cdn_fornecedor = item_bord_ap.cdn_fornecedor
                    and   tt_item_bord_ap_imprimir.cod_forma_pagto = v_cod_forma_pagto_altern
                    and   tt_item_bord_ap_imprimir.dat_pagto_tit_ap = item_bord_ap.dat_pagto_tit_ap
                    and   tt_item_bord_ap_imprimir.ttv_cod_barra = "" no-error.
           end.     
           else do:                                
               find first tt_item_bord_ap_imprimir no-lock
                    where tt_item_bord_ap_imprimir.cod_estab_bord = item_bord_ap.cod_estab_bord
                    and   tt_item_bord_ap_imprimir.cod_portador = item_bord_ap.cod_portador
                    and   tt_item_bord_ap_imprimir.num_bord_ap  = item_bord_ap.num_bord_ap
                    and   tt_item_bord_ap_imprimir.cdn_fornecedor = item_bord_ap.cdn_fornecedor
                    and   tt_item_bord_ap_imprimir.cod_forma_pagto = v_cod_forma_pagto_altern
                    and   tt_item_bord_ap_imprimir.dat_vencto_tit_ap = item_bord_ap.dat_vencto_tit_ap
                    and   tt_item_bord_ap_imprimir.ttv_cod_barra = "" no-error.
           end.     
           if  not avail tt_item_bord_ap_imprimir
           then do:
              create tt_item_bord_ap_imprimir.
              assign v_num_count = v_num_count + 1.
              assign 
                     tt_item_bord_ap_imprimir.cod_estab_bord = item_bord_ap.cod_estab_bord
                     tt_item_bord_ap_imprimir.cod_portador   = item_bord_ap.cod_portador
                     tt_item_bord_ap_imprimir.num_bord_ap    = item_bord_ap.num_bord_ap
                     tt_item_bord_ap_imprimir.num_seq_bord   = item_bord_ap.num_seq_bord.
              assign 
                     tt_item_bord_ap_imprimir.cod_empresa                 = item_bord_ap.cod_empresa
                     tt_item_bord_ap_imprimir.cod_refer_antecip_pef       = item_bord_ap.cod_refer_antecip_pef
                     tt_item_bord_ap_imprimir.cod_estab                   = item_bord_ap.cod_estab
                     tt_item_bord_ap_imprimir.cod_espec_docto             = item_bord_ap.cod_espec_docto
                     tt_item_bord_ap_imprimir.cod_ser_docto               = item_bord_ap.cod_ser_docto
                     tt_item_bord_ap_imprimir.cdn_fornecedor              = item_bord_ap.cdn_fornecedor
                     tt_item_bord_ap_imprimir.cod_tit_ap                  = item_bord_ap.cod_tit_ap
                     tt_item_bord_ap_imprimir.cod_parcela                 = item_bord_ap.cod_parcela
                     tt_item_bord_ap_imprimir.num_seq_pagto_tit_ap        = item_bord_ap.num_seq_pagto_tit_ap
                     tt_item_bord_ap_imprimir.cod_banco                   = item_bord_ap.cod_banco
                     tt_item_bord_ap_imprimir.cod_forma_pagto             = item_bord_ap.cod_forma_pagto
                     tt_item_bord_ap_imprimir.cod_forma_pagto_altern      = item_bord_ap.cod_forma_pagto_altern
                     tt_item_bord_ap_imprimir.dat_prev_pagto              = item_bord_ap.dat_prev_pagto
                     tt_item_bord_ap_imprimir.dat_desconto                = item_bord_ap.dat_desconto
                     tt_item_bord_ap_imprimir.dat_cotac_indic_econ        = item_bord_ap.dat_cotac_indic_econ
                     tt_item_bord_ap_imprimir.val_cotac_indic_econ        = item_bord_ap.val_cotac_indic_econ
                     tt_item_bord_ap_imprimir.val_pagto                   = item_bord_ap.val_pagto
                     tt_item_bord_ap_imprimir.val_pagto_inic              = item_bord_ap.val_pagto_inic
                     tt_item_bord_ap_imprimir.val_multa_tit_ap            = item_bord_ap.val_multa_tit_ap
                     tt_item_bord_ap_imprimir.val_juros                   = item_bord_ap.val_juros
                     tt_item_bord_ap_imprimir.val_cm_tit_ap               = item_bord_ap.val_cm_tit_ap
                     tt_item_bord_ap_imprimir.val_desc_tit_ap             = item_bord_ap.val_desc_tit_ap
                     tt_item_bord_ap_imprimir.val_desc_tit_ap_inic        = item_bord_ap.val_desc_tit_ap_inic
                     tt_item_bord_ap_imprimir.val_abat_tit_ap             = item_bord_ap.val_abat_tit_ap
                     tt_item_bord_ap_imprimir.val_pagto_orig              = item_bord_ap.val_pagto_orig
                     tt_item_bord_ap_imprimir.val_pagto_orig_inic         = item_bord_ap.val_pagto_orig_inic
                     tt_item_bord_ap_imprimir.val_multa_tit_ap_orig       = item_bord_ap.val_multa_tit_ap_orig
                     tt_item_bord_ap_imprimir.val_juros_tit_ap_orig       = item_bord_ap.val_juros_tit_ap_orig
                     tt_item_bord_ap_imprimir.val_cm_tit_ap_orig          = item_bord_ap.val_cm_tit_ap_orig
                     tt_item_bord_ap_imprimir.val_desc_tit_ap_orig        = item_bord_ap.val_desc_tit_ap_orig
                     tt_item_bord_ap_imprimir.val_desc_tit_ap_orig_inic   = item_bord_ap.val_desc_tit_ap_orig_inic
                     tt_item_bord_ap_imprimir.val_abat_tit_ap_orig        = item_bord_ap.val_abat_tit_ap_orig
                     tt_item_bord_ap_imprimir.des_text_histor             = item_bord_ap.des_text_histor
                     tt_item_bord_ap_imprimir.cod_docto_bco_pagto         = item_bord_ap.cod_docto_bco_pagto
                     tt_item_bord_ap_imprimir.ind_sit_item_bord_ap        = item_bord_ap.ind_sit_item_bord_ap
                     tt_item_bord_ap_imprimir.log_critic_atualiz_ok       = item_bord_ap.log_critic_atualiz_ok
                     tt_item_bord_ap_imprimir.num_id_agrup_item_bord_ap   = item_bord_ap.num_id_agrup_item_bord_ap
                     tt_item_bord_ap_imprimir.cod_estab_cheq              = item_bord_ap.cod_estab_cheq
                     tt_item_bord_ap_imprimir.num_id_cheq_ap              = item_bord_ap.num_id_cheq_ap
                     tt_item_bord_ap_imprimir.num_seq_item_cheq           = item_bord_ap.num_seq_item_cheq
    &if '{&emsfin_version}' >= "5.02" &then
                     tt_item_bord_ap_imprimir.ind_sit_envio_escrit        = item_bord_ap.ind_sit_envio_escrit
    &endif
    &if '{&emsfin_version}' >= "5.02" &then
                     tt_item_bord_ap_imprimir.cdn_proces_edi              = item_bord_ap.cdn_proces_edi
    &endif
    &if '{&emsfin_version}' >= "5.02" &then
                     tt_item_bord_ap_imprimir.cod_bco_pagto               = item_bord_ap.cod_bco_pagto
    &endif
    &if '{&emsfin_version}' >= "5.02" &then
                     tt_item_bord_ap_imprimir.cod_agenc_bcia_pagto        = item_bord_ap.cod_agenc_bcia_pagto
    &endif
    &if '{&emsfin_version}' >= "5.02" &then
                     tt_item_bord_ap_imprimir.cod_digito_agenc_bcia_pagto = item_bord_ap.cod_digito_agenc_bcia_pagto
    &endif
    &if '{&emsfin_version}' >= "5.02" &then
                     tt_item_bord_ap_imprimir.cod_cta_corren_bco_pagto    = item_bord_ap.cod_cta_corren_bco_pagto
    &endif
    &if '{&emsfin_version}' >= "5.02" &then
                     tt_item_bord_ap_imprimir.cod_digito_cta_corren_pagto = item_bord_ap.cod_digito_cta_corren_pagto
    &endif
    &if '{&emsfin_version}' >= "5.03" &then
                     tt_item_bord_ap_imprimir.cod_usuar_pagto             = item_bord_ap.cod_usuar_pagto
    &endif
    &if '{&emsfin_version}' >= "5.04" &then
                     tt_item_bord_ap_imprimir.dat_pagto_tit_ap            = item_bord_ap.dat_pagto_tit_ap
    &endif
    &if '{&emsfin_version}' >= "5.05" &then
                     tt_item_bord_ap_imprimir.ind_favorec_cheq            = item_bord_ap.ind_favorec_cheq
    &endif
    &if '{&emsfin_version}' >= "5.05" &then
                     tt_item_bord_ap_imprimir.nom_favorec_cheq            = item_bord_ap.nom_favorec_cheq
    &endif
    &if '{&emsfin_version}' >= "5.06" &then
                     tt_item_bord_ap_imprimir.cod_contrat_cambio          = item_bord_ap.cod_contrat_cambio
    &endif
    &if '{&emsfin_version}' >= "5.06" &then
                     tt_item_bord_ap_imprimir.dat_contrat_cambio_import   = item_bord_ap.dat_contrat_cambio_import
    &endif
    &if '{&emsfin_version}' >= "5.06" &then
                     tt_item_bord_ap_imprimir.num_contrat_id_cambio       = item_bord_ap.num_contrat_id_cambio
    &endif
    &if '{&emsfin_version}' >= "5.06" &then
                     tt_item_bord_ap_imprimir.cod_estab_contrat_cambio    = item_bord_ap.cod_estab_contrat_cambio
    &endif
    &if '{&emsfin_version}' >= "5.06" &then
                     tt_item_bord_ap_imprimir.cod_refer_contrat_cambio    = item_bord_ap.cod_refer_contrat_cambio
    &endif
    &if '{&emsfin_version}' >= "5.06" &then
                     tt_item_bord_ap_imprimir.dat_refer_contrat_cambio    = item_bord_ap.dat_refer_contrat_cambio
    &endif.
              assign tt_item_bord_ap_imprimir.ttv_cod_barra = ""
                     tt_item_bord_ap_imprimir.cod_espec_docto = ""
                     tt_item_bord_ap_imprimir.cod_ser_docto = ""
                     tt_item_bord_ap_imprimir.cod_tit_ap = ""
                     tt_item_bord_ap_imprimir.cod_parcela = ""
                     tt_item_bord_ap_imprimir.val_pagto = tt_item_bord_ap_imprimir.val_pagto - v_val_tot_abat_antecip
                     tt_item_bord_ap_imprimir.ttv_val_liq_item_bord = item_bord_ap.val_pagto + item_bord_ap.val_multa_tit_ap + item_bord_ap.val_cm_tit_ap + 
                                              item_bord_ap.val_juros - item_bord_ap.val_desc_tit_ap -  item_bord_ap.val_abat_tit_ap - v_val_tot_abat_antecip -  v_val_tot_impto
                     tt_item_bord_ap_imprimir.num_id_item_bord_ap = item_bord_ap.num_id_item_bord_ap
                     tt_item_bord_ap_imprimir.ttv_val_tot_impto_retid = v_val_tot_impto
                     tt_item_bord_ap_imprimir.tta_nom_pessoa = v_nom_pessoa
                     tt_item_bord_ap_imprimir.tta_nom_cidade = v_nom_cidade
                     tt_item_bord_ap_imprimir.cod_forma_pagto = v_cod_forma_pagto_altern
                     tt_item_bord_ap_imprimir.tta_des_forma_pagto = b_forma_pagto.des_forma_pagto
                     tt_item_bord_ap_imprimir.ttv_des_documento = tt_item_bord_ap_imprimir.cod_estab.

              if v_log_dat_pagto_bord = yes then do:       
                  if item_bord_ap.dat_pagto_tit_ap < bord_ap.dat_transacao then do:
                      assign item_bord_ap.dat_pagto_tit_ap = bord_ap.dat_transacao.
                  end.       
                      assign tt_item_bord_ap_imprimir.dat_vencto_tit_ap = item_bord_ap.dat_pagto_tit_ap.
              end. 
              else do:
                  assign tt_item_bord_ap_imprimir.dat_vencto_tit_ap = item_bord_ap.dat_vencto_tit_ap.   
              end.                          


               if  v_ind_origin_tit_ap =  "EEC" /*l_eec*/  then 
                   run pi_eec_informacoes_banc /*pi_eec_informacoes_banc*/.
               if  b_forma_pagto.log_cta_corren_fornec_obrig = yes
               and item_bord_ap.cdn_fornecedor > 0 and avail fornec_financ
               then do:
                   if  v_ind_origin_tit_ap <>  "EEC" /*l_eec*/ 
                   then do:
                       &if '{&emsfin_version}' >= "5.02" &then
                           assign tt_item_bord_ap_imprimir.tta_cod_banco = if item_bord_ap.cod_bco_pagto <> "" then item_bord_ap.cod_bco_pagto
                                                                               else fornec_financ.cod_banco
                                  tt_item_bord_ap_imprimir.tta_cod_agenc_bcia = if item_bord_ap.cod_agenc_bcia_pagto <> "" then item_bord_ap.cod_agenc_bcia_pagto
                                                                               else fornec_financ.cod_agenc_bcia
                                  tt_item_bord_ap_imprimir.tta_cod_cta_corren = if item_bord_ap.cod_cta_corren_bco_pagto <> "" then item_bord_ap.cod_cta_corren_bco_pagto
                                                                               else fornec_financ.cod_cta_corren_bco
                                  tt_item_bord_ap_imprimir.tta_cod_digito_cta_corren = if item_bord_ap.cod_digito_cta_corren_pagto <> "" then item_bord_ap.cod_digito_cta_corren_pagto 
                                                                               else fornec_financ.cod_digito_cta_corren
                                  tt_item_bord_ap_imprimir.tta_cod_digito_agenc_bcia = if item_bord_ap.cod_digito_agenc_bcia_pagto <> "" then item_bord_ap.cod_digito_agenc_bcia_pagto
                                                                               else fornec_financ.cod_digito_agenc_bcia.
                       &else
                           assign tt_item_bord_ap_imprimir.tta_cod_banco = fornec_financ.cod_banco
                                  tt_item_bord_ap_imprimir.tta_cod_agenc_bcia = fornec_financ.cod_agenc_bcia
                                  tt_item_bord_ap_imprimir.tta_cod_cta_corren = fornec_financ.cod_cta_corren_bco
                                  tt_item_bord_ap_imprimir.tta_cod_digito_cta_corren = fornec_financ.cod_digito_cta_corren
                                  tt_item_bord_ap_imprimir.tta_cod_digito_agenc_bcia = fornec_financ.cod_livre_1.
                       &endif
                   end.

                   /* EPC Nitro Qu°mica */
                   run pi_epc_inf_bcia /*pi_epc_inf_bcia*/.

                   find emscad.banco no-lock where banco.cod_banco = tt_item_bord_ap_imprimir.tta_cod_banco no-error.
                   if avail banco then
                       assign tt_item_bord_ap_imprimir.tta_nom_banco = banco.nom_banco
                              tt_item_bord_ap_imprimir.tta_cod_sist_nac_bcio = banco.cod_sist_nac_bcio.
                   find emscad.empresa no-lock where empresa.cod_empresa = fornec_financ.cod_empresa no-error.
                   if avail empresa then
                       assign tt_item_bord_ap_imprimir.tta_nom_razao_social = empresa.nom_razao_social.
                   &if '{&emsfin_version}' >= "5.02" &then
                       if  b_forma_pagto.ind_tip_forma_pagto = "Ordem de Pagamento" /*l_ordem_de_pagamento*/  
                       and bord_ap.log_bord_ap_escrit = no then
                           run pi_verifica_agenc_bcia_fornec_financ.
                   &else
                       if  entry(1,b_forma_pagto.cod_livre_1,chr(24)) = "Ordem de Pagamento" /*l_ordem_de_pagamento*/  
                       and bord_ap.log_bord_ap_escrit = no then
                           run pi_verifica_agenc_bcia_fornec_financ.
                   &endif.
               end.
               find banco no-lock where banco.cod_banco = tt_item_bord_ap_imprimir.tta_cod_banco no-error.
               if avail banco then
                  assign tt_item_bord_ap_imprimir.tta_cod_sist_nac_bcio = banco.cod_sist_nac_bcio.

               if b_forma_pagto.log_cheq_administ = yes then
                   assign tt_item_bord_ap_imprimir.tta_ind_localiz_cheq_administ = b_forma_pagto.ind_localiz_cheq_administ.
           end.
           else do:
             assign tt_item_bord_ap_imprimir.cod_espec_docto = ""
                 tt_item_bord_ap_imprimir.cod_ser_docto = ""
                 tt_item_bord_ap_imprimir.cod_tit_ap = ""
                 tt_item_bord_ap_imprimir.cod_parcela = ""
                 tt_item_bord_ap_imprimir.val_pagto = (tt_item_bord_ap_imprimir.val_pagto + item_bord_ap.val_pagto) - v_val_tot_abat_antecip
                 tt_item_bord_ap_imprimir.ttv_val_liq_item_bord = tt_item_bord_ap_imprimir.ttv_val_liq_item_bord + item_bord_ap.val_pagto + item_bord_ap.val_multa_tit_ap + item_bord_ap.val_cm_tit_ap + item_bord_ap.val_juros - item_bord_ap.val_desc_tit_ap - item_bord_ap.val_abat_tit_ap - v_val_tot_abat_antecip - v_val_tot_impto
                 tt_item_bord_ap_imprimir.num_id_item_bord_ap = item_bord_ap.num_id_item_bord_ap
                 tt_item_bord_ap_imprimir.ttv_val_tot_impto_retid = tt_item_bord_ap_imprimir.ttv_val_tot_impto_retid + v_val_tot_impto
                 tt_item_bord_ap_imprimir.tta_nom_pessoa = v_nom_pessoa
                 tt_item_bord_ap_imprimir.tta_nom_cidade = v_nom_cidade
                 tt_item_bord_ap_imprimir.cod_forma_pagto = v_cod_forma_pagto_altern
                 tt_item_bord_ap_imprimir.tta_des_forma_pagto = b_forma_pagto.des_forma_pagto
                 tt_item_bord_ap_imprimir.ttv_des_documento = tt_item_bord_ap_imprimir.cod_estab
                 tt_item_bord_ap_imprimir.val_multa_tit_ap = tt_item_bord_ap_imprimir.val_multa_tit_ap + item_bord_ap.val_multa_tit_ap
                 tt_item_bord_ap_imprimir.val_juros = tt_item_bord_ap_imprimir.val_juros + item_bord_ap.val_juros
                 tt_item_bord_ap_imprimir.val_cm_tit_ap = tt_item_bord_ap_imprimir.val_cm_tit_ap + item_bord_ap.val_cm_tit_ap
                 tt_item_bord_ap_imprimir.val_desc_tit_ap = tt_item_bord_ap_imprimir.val_desc_tit_ap + item_bord_ap.val_desc_tit_ap
                 tt_item_bord_ap_imprimir.val_abat_tit_ap = tt_item_bord_ap_imprimir.val_abat_tit_ap + item_bord_ap.val_abat_tit_ap.
           end.
        end.
        else do:
           run pi_verificar_abat_antecip_voucher_pagto (Input item_bord_ap.cod_estab_bord,
                                                        Input " ",
                                                        Input item_bord_ap.num_seq_bord,
                                                        Input item_bord_ap.cod_portador,
                                                        Input item_bord_ap.num_bord_ap,
                                                        Input "Antecipaá∆o" /*l_antecipacao*/,
                                                        output v_log_abat_antecip,
                                                        output v_val_tot_abat_antecip,
                                                        output v_val_tot_abat) /*pi_verificar_abat_antecip_voucher_pagto*/.
           if item_bord_ap.cod_refer_antecip_pef <> "" and item_bord_ap.cod_refer_antecip_pef <> ? then
               if  search("prgfin/apb/apb794za.r") = ? and search("prgfin/apb/apb794za.py") = ? then do:
                   if  v_cod_dwb_user begins 'es_' then
                       return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgfin/apb/apb794za.py".
                   else do:
                       message "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  "prgfin/apb/apb794za.py"
                              view-as alert-box error buttons ok.
                       return.
                   end.
               end.
               else
                   run prgfin/apb/apb794za.py (Input item_bord_ap.cod_estab,
                                           Input item_bord_ap.cod_refer_antecip_pef,
                                           Input "",
                                           Input 0,
                                           Input 0,
                                           Input yes,
                                           Input bord_ap.dat_transacao,
                                           Input "Retido" /*l_retido*/,
                                           output v_log_impto_vincul_refer,
                                           output v_val_tot_impto,
                                           Input recid(bord_ap),
                                           Input recid(cheq_ap),
                                           Input recid(item_lote_pagto)) /*prg_fnc_verificar_impto_vincul_refer*/.
           else
               if  search("prgfin/apb/apb794za.r") = ? and search("prgfin/apb/apb794za.py") = ? then do:
                   if  v_cod_dwb_user begins 'es_' then
                       return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgfin/apb/apb794za.py".
                   else do:
                       message "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  "prgfin/apb/apb794za.py"
                              view-as alert-box error buttons ok.
                       return.
                   end.
               end.
               else
                   run prgfin/apb/apb794za.py (Input item_bord_ap.cod_estab_bord,
                                           Input "",
                                           Input bord_ap.cod_portador,
                                           Input bord_ap.num_bord_ap,
                                           Input item_bord_ap.num_seq_bord,
                                           Input yes,
                                           Input bord_ap.dat_transacao,
                                           Input "Retido" /*l_retido*/,
                                           output v_log_impto_vincul_refer,
                                           output v_val_tot_impto,
                                           Input ?,
                                           Input ?,
                                           Input ?) /*prg_fnc_verificar_impto_vincul_refer*/.
           assign v_val_liq_item_bord = item_bord_ap.val_pagto + item_bord_ap.val_multa_tit_ap + item_bord_ap.val_juros + item_bord_ap.val_cm_tit_ap - item_bord_ap.val_desc_tit_ap
                                      - item_bord_ap.val_abat_tit_ap - v_val_tot_abat_antecip - v_val_tot_impto.

           find first b_item_bord_ap_delete exclusive-lock
                where recid(b_item_bord_ap_delete) = recid(item_bord_ap) no-error.

           if v_val_liq_item_bord  = 0 then do: /* jucinei */
               if  avail b_item_bord_ap_delete then do:
                   &if '{&emsbas_version}' >= '5.07' &then
                       assign b_item_bord_ap_delete.log_pagto_sem_desemb = yes.
                   &else
                       assign b_item_bord_ap_delete.cod_livre_1 = setentryfield(7,item_bord_ap.cod_livre_1,chr(10),"yes" /*l_yes*/ ).
                   &endif
               end.
               next.
           end.
           else do:
               if  avail b_item_bord_ap_delete then do:
                    &if '{&emsbas_version}' >= '5.07' &then
                        assign b_item_bord_ap_delete.log_pagto_sem_desemb = no.
                    &else
                        assign b_item_bord_ap_delete.cod_livre_1 = setentryfield(7,item_bord_ap.cod_livre_1,chr(10),"no" /*l_no*/ ).
                    &endif
               end.
           end. /* jucinei */

           create tt_item_bord_ap_imprimir.
           assign v_num_count = v_num_count + 1.
           assign 
                  tt_item_bord_ap_imprimir.cod_estab_bord = item_bord_ap.cod_estab_bord
                  tt_item_bord_ap_imprimir.cod_portador   = item_bord_ap.cod_portador
                  tt_item_bord_ap_imprimir.num_bord_ap    = item_bord_ap.num_bord_ap
                  tt_item_bord_ap_imprimir.num_seq_bord   = item_bord_ap.num_seq_bord.
           assign 
                  tt_item_bord_ap_imprimir.cod_empresa                 = item_bord_ap.cod_empresa
                  tt_item_bord_ap_imprimir.cod_refer_antecip_pef       = item_bord_ap.cod_refer_antecip_pef
                  tt_item_bord_ap_imprimir.cod_estab                   = item_bord_ap.cod_estab
                  tt_item_bord_ap_imprimir.cod_espec_docto             = item_bord_ap.cod_espec_docto
                  tt_item_bord_ap_imprimir.cod_ser_docto               = item_bord_ap.cod_ser_docto
                  tt_item_bord_ap_imprimir.cdn_fornecedor              = item_bord_ap.cdn_fornecedor
                  tt_item_bord_ap_imprimir.cod_tit_ap                  = item_bord_ap.cod_tit_ap
                  tt_item_bord_ap_imprimir.cod_parcela                 = item_bord_ap.cod_parcela
                  tt_item_bord_ap_imprimir.num_seq_pagto_tit_ap        = item_bord_ap.num_seq_pagto_tit_ap
                  tt_item_bord_ap_imprimir.cod_banco                   = item_bord_ap.cod_banco
                  tt_item_bord_ap_imprimir.cod_forma_pagto             = item_bord_ap.cod_forma_pagto
                  tt_item_bord_ap_imprimir.cod_forma_pagto_altern      = item_bord_ap.cod_forma_pagto_altern
                  tt_item_bord_ap_imprimir.dat_vencto_tit_ap           = item_bord_ap.dat_vencto_tit_ap
                  tt_item_bord_ap_imprimir.dat_prev_pagto              = item_bord_ap.dat_prev_pagto
                  tt_item_bord_ap_imprimir.dat_desconto                = item_bord_ap.dat_desconto
                  tt_item_bord_ap_imprimir.dat_cotac_indic_econ        = item_bord_ap.dat_cotac_indic_econ
                  tt_item_bord_ap_imprimir.val_cotac_indic_econ        = item_bord_ap.val_cotac_indic_econ
                  tt_item_bord_ap_imprimir.val_pagto                   = item_bord_ap.val_pagto
                  tt_item_bord_ap_imprimir.val_pagto_inic              = item_bord_ap.val_pagto_inic
                  tt_item_bord_ap_imprimir.val_multa_tit_ap            = item_bord_ap.val_multa_tit_ap
                  tt_item_bord_ap_imprimir.val_juros                   = item_bord_ap.val_juros
                  tt_item_bord_ap_imprimir.val_cm_tit_ap               = item_bord_ap.val_cm_tit_ap
                  tt_item_bord_ap_imprimir.val_desc_tit_ap             = item_bord_ap.val_desc_tit_ap
                  tt_item_bord_ap_imprimir.val_desc_tit_ap_inic        = item_bord_ap.val_desc_tit_ap_inic
                  tt_item_bord_ap_imprimir.val_abat_tit_ap             = item_bord_ap.val_abat_tit_ap
                  tt_item_bord_ap_imprimir.val_pagto_orig              = item_bord_ap.val_pagto_orig
                  tt_item_bord_ap_imprimir.val_pagto_orig_inic         = item_bord_ap.val_pagto_orig_inic
                  tt_item_bord_ap_imprimir.val_multa_tit_ap_orig       = item_bord_ap.val_multa_tit_ap_orig
                  tt_item_bord_ap_imprimir.val_juros_tit_ap_orig       = item_bord_ap.val_juros_tit_ap_orig
                  tt_item_bord_ap_imprimir.val_cm_tit_ap_orig          = item_bord_ap.val_cm_tit_ap_orig
                  tt_item_bord_ap_imprimir.val_desc_tit_ap_orig        = item_bord_ap.val_desc_tit_ap_orig
                  tt_item_bord_ap_imprimir.val_desc_tit_ap_orig_inic   = item_bord_ap.val_desc_tit_ap_orig_inic
                  tt_item_bord_ap_imprimir.val_abat_tit_ap_orig        = item_bord_ap.val_abat_tit_ap_orig
                  tt_item_bord_ap_imprimir.des_text_histor             = item_bord_ap.des_text_histor
                  tt_item_bord_ap_imprimir.cod_docto_bco_pagto         = item_bord_ap.cod_docto_bco_pagto
                  tt_item_bord_ap_imprimir.ind_sit_item_bord_ap        = item_bord_ap.ind_sit_item_bord_ap
                  tt_item_bord_ap_imprimir.log_critic_atualiz_ok       = item_bord_ap.log_critic_atualiz_ok
                  tt_item_bord_ap_imprimir.num_id_agrup_item_bord_ap   = item_bord_ap.num_id_agrup_item_bord_ap
                  tt_item_bord_ap_imprimir.cod_estab_cheq              = item_bord_ap.cod_estab_cheq
                  tt_item_bord_ap_imprimir.num_id_cheq_ap              = item_bord_ap.num_id_cheq_ap
                  tt_item_bord_ap_imprimir.num_seq_item_cheq           = item_bord_ap.num_seq_item_cheq
    &if '{&emsfin_version}' >= "5.02" &then
                  tt_item_bord_ap_imprimir.ind_sit_envio_escrit        = item_bord_ap.ind_sit_envio_escrit
    &endif
    &if '{&emsfin_version}' >= "5.02" &then
                  tt_item_bord_ap_imprimir.cdn_proces_edi              = item_bord_ap.cdn_proces_edi
    &endif
    &if '{&emsfin_version}' >= "5.02" &then
                  tt_item_bord_ap_imprimir.cod_bco_pagto               = item_bord_ap.cod_bco_pagto
    &endif
    &if '{&emsfin_version}' >= "5.02" &then
                  tt_item_bord_ap_imprimir.cod_agenc_bcia_pagto        = item_bord_ap.cod_agenc_bcia_pagto
    &endif
    &if '{&emsfin_version}' >= "5.02" &then
                  tt_item_bord_ap_imprimir.cod_digito_agenc_bcia_pagto = item_bord_ap.cod_digito_agenc_bcia_pagto
    &endif
    &if '{&emsfin_version}' >= "5.02" &then
                  tt_item_bord_ap_imprimir.cod_cta_corren_bco_pagto    = item_bord_ap.cod_cta_corren_bco_pagto
    &endif
    &if '{&emsfin_version}' >= "5.02" &then
                  tt_item_bord_ap_imprimir.cod_digito_cta_corren_pagto = item_bord_ap.cod_digito_cta_corren_pagto
    &endif
    &if '{&emsfin_version}' >= "5.03" &then
                  tt_item_bord_ap_imprimir.cod_usuar_pagto             = item_bord_ap.cod_usuar_pagto
    &endif
    &if '{&emsfin_version}' >= "5.04" &then
                  tt_item_bord_ap_imprimir.dat_pagto_tit_ap            = item_bord_ap.dat_pagto_tit_ap
    &endif
    &if '{&emsfin_version}' >= "5.05" &then
                  tt_item_bord_ap_imprimir.ind_favorec_cheq            = item_bord_ap.ind_favorec_cheq
    &endif
    &if '{&emsfin_version}' >= "5.05" &then
                  tt_item_bord_ap_imprimir.nom_favorec_cheq            = item_bord_ap.nom_favorec_cheq
    &endif
    &if '{&emsfin_version}' >= "5.06" &then
                  tt_item_bord_ap_imprimir.cod_contrat_cambio          = item_bord_ap.cod_contrat_cambio
    &endif
    &if '{&emsfin_version}' >= "5.06" &then
                  tt_item_bord_ap_imprimir.dat_contrat_cambio_import   = item_bord_ap.dat_contrat_cambio_import
    &endif
    &if '{&emsfin_version}' >= "5.06" &then
                  tt_item_bord_ap_imprimir.num_contrat_id_cambio       = item_bord_ap.num_contrat_id_cambio
    &endif
    &if '{&emsfin_version}' >= "5.06" &then
                  tt_item_bord_ap_imprimir.cod_estab_contrat_cambio    = item_bord_ap.cod_estab_contrat_cambio
    &endif
    &if '{&emsfin_version}' >= "5.06" &then
                  tt_item_bord_ap_imprimir.cod_refer_contrat_cambio    = item_bord_ap.cod_refer_contrat_cambio
    &endif
    &if '{&emsfin_version}' >= "5.06" &then
                  tt_item_bord_ap_imprimir.dat_refer_contrat_cambio    = item_bord_ap.dat_refer_contrat_cambio
    &endif.
           assign tt_item_bord_ap_imprimir.ttv_cod_barra = v_cod_barra
               tt_item_bord_ap_imprimir.val_pagto = item_bord_ap.val_pagto
               tt_item_bord_ap_imprimir.ttv_val_liq_item_bord = v_val_liq_item_bord
               tt_item_bord_ap_imprimir.ttv_val_tot_impto_retid = v_val_tot_impto.
               tt_item_bord_ap_imprimir.num_id_item_bord_ap = item_bord_ap.num_id_item_bord_ap.
           if  item_bord_ap.cod_refer_antecip_pef = "" or  item_bord_ap.cod_refer_antecip_pef = ?
           then do:
               find tit_ap no-lock
                    where tit_ap.cdn_fornecedor = item_bord_ap.cdn_fornecedor
                      and tit_ap.cod_espec_docto = item_bord_ap.cod_espec_docto
                      and tit_ap.cod_estab = item_bord_ap.cod_estab
                      and tit_ap.cod_parcela = item_bord_ap.cod_parcela
                      and tit_ap.cod_ser_docto = item_bord_ap.cod_ser_docto
                      and tit_ap.cod_tit_ap = item_bord_ap.cod_tit_ap
                     no-error.
               assign tt_item_bord_ap_imprimir.tta_dat_emis_docto = tit_ap.dat_emis_docto.
           end.
           else do:
               if  not avail b_forma_pagto or v_cod_forma_pagto_altern <> item_bord_ap.cod_forma_pagto
               then do:
                   find antecip_pef_pend no-lock
                        where antecip_pef_pend.cod_estab = item_bord_ap.cod_estab
                          and antecip_pef_pend.cod_refer = item_bord_ap.cod_refer_antecip_pef
                         no-error.
                   if  antecip_pef_pend.cdn_fornecedor > 0
                   then do:
                       find emscad.fornecedor no-lock
                            where fornecedor.cdn_fornecedor = antecip_pef_pend.cdn_fornecedor
                              and fornecedor.cod_empresa = antecip_pef_pend.cod_empresa
                             no-error.
                       assign v_nom_pessoa = fornecedor.nom_pessoa
                              v_nom_cidade = "Sim" /*l_sim*/ .
                   end.
                   else do:
                       if  forma_pagto.log_cta_corren_fornec_obrig = yes or 
                           forma_pagto.log_agrup_tit_fornec = yes or
                          (forma_pagto.log_cheq_administ = yes and
                           antecip_pef_pend.nom_favorec_cheq = "")
                       then do:
                           assign v_nom_pessoa = "Erro" /*l_Erro*/  + "Erro" /*l_Erro*/  + "Erro" /*l_Erro*/  + "Erro" /*l_Erro*/  + "Erro" /*l_Erro*/ 
                                  v_nom_cidade = ""
                                  v_log_erro_impr = yes.
                           create tt_log_erros_atualiz.
                           assign tt_log_erros_atualiz.tta_cod_estab = bord_ap.cod_estab_bord
                                  tt_log_erros_atualiz.ttv_num_mensagem  = 6918
                                  tt_log_erros_atualiz.tta_num_seq_refer = item_bord_ap.num_seq_bord.
                           run pi_messages (input "msg",
                                            input 6918,
                                            input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")).
                           assign tt_log_erros_atualiz.ttv_des_msg_erro = return-value /*msg_6918*/.
                           run pi_messages (input "help",
                                            input 6918,
                                            input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")).
                           assign tt_log_erros_atualiz.ttv_des_msg_ajuda = return-value /*msg_6918*/.
                           assign tt_log_erros_atualiz.ttv_des_msg_ajuda = substitute( tt_log_erros_atualiz.ttv_des_msg_ajuda,"Sequància:" /*l_sequencia:*/  + string(item_bord_ap.num_seq_bord) ).
                       end.
                       else
                           assign v_nom_pessoa = antecip_pef_pend.nom_favorec_cheq
                                  v_nom_cidade = "".
                   end /* else */.
                   find first fornec_financ no-lock
                        where fornec_financ.cod_empresa    = item_bord_ap.cod_empresa
                        and   fornec_financ.cdn_fornecedor = item_bord_ap.cdn_fornecedor no-error.
                   if  avail fornec_financ
                   then do:
                      if  fornec_financ.log_pagto_bloqdo = yes
                      then do:
                         assign v_nom_pessoa = "Erro" /*l_Erro*/  + "Erro" /*l_Erro*/  + "Erro" /*l_Erro*/  + "Erro" /*l_Erro*/  + "Erro" /*l_Erro*/ 
                                v_nom_cidade = ""
                                v_log_erro_impr = yes.
                         create tt_log_erros_atualiz.
                         assign tt_log_erros_atualiz.tta_cod_estab     = bord_ap.cod_estab_bord
                                tt_log_erros_atualiz.ttv_num_mensagem  = 7838
                                tt_log_erros_atualiz.tta_num_seq_refer = item_bord_ap.num_seq_bord.
                         run pi_messages (input "msg",
                                          input 7838,
                                          input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")).
                         assign tt_log_erros_atualiz.ttv_des_msg_erro = return-value /*msg_7838*/.
                         run pi_messages (input "help",
                                          input 7838,
                                          input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")).
                         assign tt_log_erros_atualiz.ttv_des_msg_ajuda = return-value /*msg_7838*/.
                         assign tt_log_erros_atualiz.ttv_des_msg_ajuda = substitute(tt_log_erros_atualiz.ttv_des_msg_ajuda,string(item_bord_ap.cdn_fornecedor)).
                      end.
                   end.
                   if  v_nom_cidade <> ""
                   then do:
                       if  fornecedor.num_pessoa mod 2 = 0
                       then do:
                           find pessoa_fisic no-lock
                                where pessoa_fisic.num_pessoa_fisic = fornecedor.num_pessoa
                                 no-error.
                           assign v_nom_cidade = pessoa_fisic.nom_cidade.
                       end.
                       else do:
                           find pessoa_jurid no-lock
                                where pessoa_jurid.num_pessoa_jurid = fornecedor.num_pessoa
                                 no-error.
                           assign v_nom_cidade = pessoa_jurid.nom_cidade.
                       end /* else */.
                   end.
               end.


               /* Desenvolvimento EP - Atv 82073*/
               if  p_log_impr_histor_pef
               then do:
                   if item_bord_ap.des_text_histor <> "" then
                       assign tt_item_bord_ap_imprimir.ttv_des_histor_pef = replace(item_bord_ap.des_text_histor, chr(10), " ").
                   else do:
                       find antecip_pef_pend no-lock
                            where antecip_pef_pend.cod_estab = item_bord_ap.cod_estab
                              and antecip_pef_pend.cod_refer = item_bord_ap.cod_refer_antecip_pef no-error.
                       if avail antecip_pef_pend then
                           if antecip_pef_pend.des_text_histor <> "" then
                               assign tt_item_bord_ap_imprimir.ttv_des_histor_pef = replace(antecip_pef_pend.des_text_histor, chr(10), " ").
                   end.
               end.


               assign tt_item_bord_ap_imprimir.tta_dat_emis_docto = antecip_pef_pend.dat_emis_docto
                      tt_item_bord_ap_imprimir.cod_espec_docto = antecip_pef_pend.cod_espec_docto
                      tt_item_bord_ap_imprimir.cod_ser_docto = antecip_pef_pend.cod_ser_docto
                      tt_item_bord_ap_imprimir.cod_tit_ap = antecip_pef_pend.cod_tit_ap
                      tt_item_bord_ap_imprimir.cod_parcela = antecip_pef_pend.cod_parcela
                      tt_item_bord_ap_imprimir.cdn_fornecedor = antecip_pef_pend.cdn_fornecedor.
           end /* else */.
           assign tt_item_bord_ap_imprimir.tta_nom_pessoa = v_nom_pessoa
                  tt_item_bord_ap_imprimir.tta_nom_cidade = v_nom_cidade
                  tt_item_bord_ap_imprimir.ttv_des_documento = tt_item_bord_ap_imprimir.cod_estab + " " + tt_item_bord_ap_imprimir.cod_espec_docto + " " +
                                                               tt_item_bord_ap_imprimir.cod_ser_docto + " " + tt_item_bord_ap_imprimir.cod_tit_ap      + "/" +
                                                               tt_item_bord_ap_imprimir.cod_parcela.
           if  v_ind_origin_tit_ap =  "EEC" /*l_eec*/  then 
               run pi_eec_informacoes_banc /*pi_eec_informacoes_banc*/.

           if  avail b_forma_pagto
           then do:
               assign tt_item_bord_ap_imprimir.cod_forma_pagto     = v_cod_forma_pagto_altern
                      tt_item_bord_ap_imprimir.tta_des_forma_pagto = b_forma_pagto.des_forma_pagto.
               if  b_forma_pagto.log_cta_corren_fornec_obrig = yes and item_bord_ap.cdn_fornecedor > 0 and avail fornec_financ
               then do:
                   if  v_ind_origin_tit_ap <> "EEC" /*l_eec*/ 
                   then do:
                       &if '{&emsfin_version}' >= "5.02" &then
                           assign tt_item_bord_ap_imprimir.tta_cod_banco = if item_bord_ap.cod_bco_pagto <> "" then item_bord_ap.cod_bco_pagto
                                                                               else fornec_financ.cod_banco
                                  tt_item_bord_ap_imprimir.tta_cod_agenc_bcia = if item_bord_ap.cod_agenc_bcia_pagto <> "" then item_bord_ap.cod_agenc_bcia_pagto
                                                                               else fornec_financ.cod_agenc_bcia
                                  tt_item_bord_ap_imprimir.tta_cod_cta_corren = if item_bord_ap.cod_cta_corren_bco_pagto <> "" then item_bord_ap.cod_cta_corren_bco_pagto
                                                                               else fornec_financ.cod_cta_corren_bco
                                  tt_item_bord_ap_imprimir.tta_cod_digito_cta_corren = if item_bord_ap.cod_digito_cta_corren_pagto <> "" then item_bord_ap.cod_digito_cta_corren_pagto 
                                                                               else fornec_financ.cod_digito_cta_corren
                                  tt_item_bord_ap_imprimir.tta_cod_digito_agenc_bcia = if item_bord_ap.cod_digito_agenc_bcia_pagto <> "" then item_bord_ap.cod_digito_agenc_bcia_pagto
                                                                               else fornec_financ.cod_digito_agenc_bcia.
                       &else
                           assign tt_item_bord_ap_imprimir.tta_cod_banco = fornec_financ.cod_banco
                                  tt_item_bord_ap_imprimir.tta_cod_agenc_bcia = fornec_financ.cod_agenc_bcia
                                  tt_item_bord_ap_imprimir.tta_cod_cta_corren = fornec_financ.cod_cta_corren_bco
                                  tt_item_bord_ap_imprimir.tta_cod_digito_cta_corren = fornec_financ.cod_digito_cta_corren
                                  tt_item_bord_ap_imprimir.tta_cod_digito_agenc_bcia = fornec_financ.cod_livre_1.
                       &endif
                   end. 

                   /* EPC Nitro Qu°mica */
                   run pi_epc_inf_bcia /*pi_epc_inf_bcia*/.

                   find banco no-lock where banco.cod_banco = tt_item_bord_ap_imprimir.tta_cod_banco no-error.
                   if avail banco then
                       assign tt_item_bord_ap_imprimir.tta_nom_banco = banco.nom_banco
                              tt_item_bord_ap_imprimir.tta_cod_sist_nac_bcio = banco.cod_sist_nac_bcio.
                   find empresa no-lock where empresa.cod_empresa = fornec_financ.cod_empresa no-error.
                   if avail empresa then
                       assign tt_item_bord_ap_imprimir.tta_nom_razao_social = empresa.nom_razao_social.
                   &if '{&emsfin_version}' >= "5.02" &then
                       if  b_forma_pagto.ind_tip_forma_pagto = "Ordem de Pagamento" /*l_ordem_de_pagamento*/  
                       and bord_ap.log_bord_ap_escrit = no then
                           run pi_verifica_agenc_bcia_fornec_financ.
                   &else
                       if  entry(1,b_forma_pagto.cod_livre_1,chr(24)) = "Ordem de Pagamento" /*l_ordem_de_pagamento*/  
                       and bord_ap.log_bord_ap_escrit = no then
                           run pi_verifica_agenc_bcia_fornec_financ.
                  &endif.
               end.
               else do:
                   find banco no-lock where banco.cod_banco = tt_item_bord_ap_imprimir.tta_cod_banco no-error.
                   if avail banco then
                      assign tt_item_bord_ap_imprimir.tta_cod_sist_nac_bcio = banco.cod_sist_nac_bcio.
               end.
           end.
           else do:
               assign tt_item_bord_ap_imprimir.cod_forma_pagto     = ""
                      tt_item_bord_ap_imprimir.tta_des_forma_pagto = "Erro" /*l_erro*/  + "Erro" /*l_erro*/  + "Erro" /*l_erro*/  + "Erro" /*l_erro*/ 
                      v_log_erro_impr = yes.
               create tt_log_erros_atualiz.
               assign tt_log_erros_atualiz.tta_cod_estab     = bord_ap.cod_estab_bord
                      tt_log_erros_atualiz.ttv_num_mensagem  = 6920
                      tt_log_erros_atualiz.tta_num_seq_refer = item_bord_ap.num_seq_bord.
               run pi_messages (input "msg",
                                input 6920,
                                input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")).
               assign tt_log_erros_atualiz.ttv_des_msg_erro = return-value /*msg_6920*/.
               run pi_messages (input "help",
                                input 6920,
                                input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")).
               assign tt_log_erros_atualiz.ttv_des_msg_ajuda = return-value /*msg_6920*/.
               assign tt_log_erros_atualiz.ttv_des_msg_ajuda = substitute( tt_log_erros_atualiz.ttv_des_msg_ajuda,"Sequància:" /*l_sequencia:*/  + string(item_bord_ap.num_seq_bord)).
           end /* else */.
           assign v_val_liq_item_bord = 0.
        end /* else */.
        find first b_item_bord_ap_delete exclusive-lock
                where recid(b_item_bord_ap_delete) = recid(item_bord_ap) no-error.
        if  ((item_bord_ap.val_pagto + item_bord_ap.val_multa_tit_ap + item_bord_ap.val_cm_tit_ap + item_bord_ap.val_juros) -
             (item_bord_ap.val_desc_tit_ap + item_bord_ap.val_abat_tit_ap + v_val_tot_abat_antecip + v_val_tot_impto)) = 0 then do:

            if  v_num_count > 1 then
                delete tt_item_bord_ap_imprimir.
            else
                assign tt_item_bord_ap_imprimir.val_pagto               = tt_item_bord_ap_imprimir.val_pagto - item_bord_ap.val_pagto
                       tt_item_bord_ap_imprimir.ttv_val_tot_impto_retid = tt_item_bord_ap_imprimir.ttv_val_tot_impto_retid - v_val_tot_impto.
            if  avail b_item_bord_ap_delete then do:
            &if '{&emsbas_version}' >= '5.07' &then
                assign b_item_bord_ap_delete.log_pagto_sem_desemb = yes.
            &else
                assign b_item_bord_ap_delete.cod_livre_1 = setentryfield(7,item_bord_ap.cod_livre_1,chr(10),"yes" /*l_yes*/ ).
            &endif
            end.
        end.
        else do:
            if  avail b_item_bord_ap_delete then do:
            &if '{&emsbas_version}' >= '5.07' &then
                assign b_item_bord_ap_delete.log_pagto_sem_desemb = no.
            &else
                assign b_item_bord_ap_delete.cod_livre_1 = setentryfield(7,item_bord_ap.cod_livre_1,chr(10),"no" /*l_no*/ ).
            &endif
            end.
        end.
    end.

END PROCEDURE. /* pi_tratar_tt_item_bord_ap_imprimir */
/*****************************************************************************
** Procedure Interna.....: pi_gravar_datas_item_bord_ap
** Descricao.............: pi_gravar_datas_item_bord_ap
** Criado por............: bre17485
** Criado em.............: 24/11/1998 18:39:05
** Alterado por..........: bre17485
** Alterado em...........: 21/12/1998 17:04:05
*****************************************************************************/
PROCEDURE pi_gravar_datas_item_bord_ap:

    if  item_bord_ap.cod_refer_antecip_pef = "" or  item_bord_ap.cod_refer_antecip_pef = ?
    then do:
        find tit_ap no-lock
          where tit_ap.cod_estab       = item_bord_ap.cod_estab
            and tit_ap.cod_espec_docto = item_bord_ap.cod_espec_docto
            and tit_ap.cod_ser_docto   = item_bord_ap.cod_ser_docto
            and tit_ap.cdn_fornecedor  = item_bord_ap.cdn_fornecedor
            and tit_ap.cod_tit_ap      = item_bord_ap.cod_tit_ap
            and tit_ap.cod_parcela     = item_bord_ap.cod_parcela no-error.
        if  avail tit_ap
        then do:
            assign item_bord_ap.dat_desconto      = tit_ap.dat_desconto
                   item_bord_ap.dat_vencto_tit_ap = tit_ap.dat_vencto_tit_ap
                   item_bord_ap.dat_prev_pagto    = tit_ap.dat_prev_pagto no-error.
        end.
    end.
    else do:
        find antecip_pef_pend no-lock
          where antecip_pef_pend.cod_estab = item_bord_ap.cod_estab
            and antecip_pef_pend.cod_refer = item_bord_ap.cod_refer_antecip_pef  no-error.
        if  avail antecip_pef_pend
        then do:
            assign item_bord_ap.dat_desconto      = antecip_pef_pend.dat_desconto
                   item_bord_ap.dat_vencto_tit_ap = antecip_pef_pend.dat_vencto_tit_ap
                   item_bord_ap.dat_prev_pagto    = antecip_pef_pend.dat_prev_pagto no-error.
        end.
    end.
END PROCEDURE. /* pi_gravar_datas_item_bord_ap */
/*****************************************************************************
** Procedure Interna.....: pi_corpo_bord_ap_imprimir
** Descricao.............: pi_corpo_bord_ap_imprimir
** Criado por............: Ganzen
** Criado em.............: 24/11/1995 14:43:57
** Alterado por..........: fut1236
** Alterado em...........: 09/03/2006 16:06:27
*****************************************************************************/
PROCEDURE pi_corpo_bord_ap_imprimir:

    /************************* Variable Definition Begin ************************/

    def var v_cod_label
        as character
        format "x(8)":U
        label "Label"
        column-label "Label"
        no-undo.
    def var v_num_impr                       as integer         no-undo. /*local*/


    /************************** Variable Definition End *************************/

    /* Imprime item do bordero */
    assign v_num_aux           = v_num_aux + 1
           v_val_liq_item_bord = tt_item_bord_ap_imprimir.val_pagto        +
                                 tt_item_bord_ap_imprimir.val_multa_tit_ap +
                                 tt_item_bord_ap_imprimir.val_juros        +
                                 tt_item_bord_ap_imprimir.val_cm_tit_ap    -
                                 tt_item_bord_ap_imprimir.val_desc_tit_ap  -
                                 tt_item_bord_ap_imprimir.val_abat_tit_ap.

    assign v_val_tot_impto_tot   = v_val_tot_impto_tot + tt_item_bord_ap_imprimir.ttv_val_tot_impto_retid.

    find first emscad.fornecedor no-lock
         where fornecedor.cdn_fornecedor = tt_item_bord_ap_imprimir.cdn_fornecedor 
         and   fornecedor.cod_empresa    = tt_item_bord_ap_imprimir.cod_empresa  no-error.

    assign v_cod_cgc_cpf = ''
           v_cod_format = 'x(20)'.

    if avail fornecedor then do:
       assign v_cod_cgc_cpf = fornecedor.cod_id_feder.
       find first b_pais no-lock
            where b_pais.cod_pais = fornecedor.cod_pais no-error.
        if  fornecedor.num_pessoa modulo 2 <> 0 then do:
            if  avail b_pais then
                assign v_cod_format = b_pais.cod_format_id_feder_jurid
                       v_cod_label  = "C.N.P.J" /*l_cnpj*/  + ':'.
        end.            
        else do:
            if  avail b_pais then
                assign v_cod_format = b_pais.cod_format_id_feder_fisic
                       v_cod_label  = "CPF" /*l_cpf*/  + ':'.
        end /* else */.
    end.   

    /* -------------------------------------- buzzi 16/01/2003 --------------------------------------------*/
        if v_nom_prog_upc <> '' 
        or v_nom_prog_appc <> ''
        or v_nom_prog_dpc <> '' then do:
            create tt_epc.
            assign tt_epc.cod_event     = 'Favorec_bord':u
                   tt_epc.cod_parameter = 'Favorec_bord':u
                   tt_epc.val_parameter = string(recid(item_bord_ap)) + chr(10) + 
                                          string(tt_item_bord_ap_imprimir.cod_estab_bord) + chr(10) +
                                          string(tt_item_bord_ap_imprimir.num_id_item_bord_ap).

            /* Begin_Include: i_exec_program_epc_custom */
            if  v_nom_prog_upc <> '' then
            do:
                run value(v_nom_prog_upc) (input 'Favorec_bord':u,
                                           input-output table tt_epc).
            end.

            if  v_nom_prog_appc <> '' then
            do:
                run value(v_nom_prog_appc) (input 'Favorec_bord':u,
                                            input-output table tt_epc).
            end.

            &if '{&emsbas_version}' > '5.00' &then
            if  v_nom_prog_dpc <> '' then
            do:
                run value(v_nom_prog_dpc) (input 'Favorec_bord':u,
                                            input-output table tt_epc).
            end.
            &endif
            /* End_Include: i_exec_program_epc_custom */


            for each tt_epc
               where tt_epc.cod_event     = 'Favorec_bord':u
               and   tt_epc.cod_parameter = 'bord_favorec':u:

               assign tt_item_bord_ap_imprimir.tta_nom_pessoa = entry(1,tt_epc.val_parameter,chr(10))
                      v_cod_cgc_cpf = entry(2,tt_epc.val_parameter,chr(10))
                      v_cod_format  = entry(3,tt_epc.val_parameter,chr(10))
                      v_cod_label   = entry(4,tt_epc.val_parameter,chr(10)).
            end.
            for each tt_epc:
                delete tt_epc.
            end.
        end.
    /* ---------------------------------- end buzzi 16/01/2003 --------------------------------------------*/

    if (line-counter(s_1) + 2) > v_rpt_s_1_bottom then
        page stream s_1.
    put stream s_1 unformatted 
        tt_item_bord_ap_imprimir.cdn_fornecedor to 11 format ">>>,>>>,>>9"
        tt_item_bord_ap_imprimir.ttv_des_documento at 13 format "x(25)" /*l_x(25)*/ 
        tt_item_bord_ap_imprimir.tta_dat_emis_docto at 39 format "99/99/9999"
        tt_item_bord_ap_imprimir.val_pagto to 66 format "->>>,>>>,>>9.99"
        tt_item_bord_ap_imprimir.val_multa_tit_ap to 82 format "->>>,>>>,>>9.99"
        tt_item_bord_ap_imprimir.val_juros to 98 format ">>>>,>>>,>>9.99"
        tt_item_bord_ap_imprimir.val_cm_tit_ap to 114 format "->>>,>>>,>>9.99" skip
        v_cod_label to 12
        v_cod_cgc_cpf  at 14 format v_cod_format
        tt_item_bord_ap_imprimir.dat_vencto_tit_ap at 39 format "99/99/9999"
        tt_item_bord_ap_imprimir.ttv_val_tot_impto_retid to 66 format "->>>,>>>,>>9.99"
        tt_item_bord_ap_imprimir.val_desc_tit_ap to 82 format "->>>,>>>,>>9.99"
        tt_item_bord_ap_imprimir.val_abat_tit_ap to 98 format "->>>,>>>,>>9.99"
        tt_item_bord_ap_imprimir.ttv_val_liq_item_bord to 114 format "->>>,>>>,>>9.99" skip.

    assign v_cod_cta_corren_final      = tta_cod_cta_corren
           v_des_agenc_bcia_fornec     = tta_cod_agenc_bcia + " - " + tta_cod_digito_agenc_bcia
           v_des_cta_corren_fornec     = tta_cod_cta_corren + " - " + tta_cod_digito_cta_corren.

    find forma_pagto no-lock
         where forma_pagto.cod_forma_pagto = tt_item_bord_ap_imprimir.cod_forma_pagto /* cl_tt_item_bord_ap of forma_pagto*/ no-error.

    if  avail forma_pagto
    then do:     
        if tt_item_bord_ap_imprimir.ttv_des_histor_pef  <> "" 
        and tt_item_bord_ap_imprimir.ttv_des_histor_pef <> ?
        then do:
            if  forma_pagto.log_cta_corren_fornec_obrig = no
            and v_log_impr_sit = no then do:
                if (line-counter(s_1) + 4) > v_rpt_s_1_bottom then
                    page stream s_1.
                put stream s_1 unformatted 
                    "Nome Fornec:" at 1
                    tt_item_bord_ap_imprimir.tta_nom_pessoa at 14 format "x(40)"
                    tt_item_bord_ap_imprimir.tta_nom_cidade at 55 format "x(32)" skip
                    "Forma Pagto:" at 1
                    tt_item_bord_ap_imprimir.tta_des_forma_pagto at 14 format "x(40)"
                    skip (1)
                    "  Hist¢rico: " at 3
                    tt_item_bord_ap_imprimir.ttv_des_histor_pef at 16 format "x(101)" skip.
            end.
            else do:
                if  forma_pagto.log_cta_corren_fornec_obrig = no
                and v_log_impr_sit = yes then do:
                    if (line-counter(s_1) + 4) > v_rpt_s_1_bottom then
                        page stream s_1.
                    put stream s_1 unformatted 
                        "Nome Fornec:" at 1
                        tt_item_bord_ap_imprimir.tta_nom_pessoa at 14 format "x(40)"
                        tt_item_bord_ap_imprimir.tta_nom_cidade at 55 format "x(32)"
                        "Situaá∆o: " at 88
                        tt_item_bord_ap_imprimir.ind_sit_item_bord_ap at 98 format "X(9)" skip
                        "Forma Pagto:" at 1
                        tt_item_bord_ap_imprimir.tta_des_forma_pagto at 14 format "x(40)"
                        skip (1)
                        "  Hist¢rico: " at 3
                        tt_item_bord_ap_imprimir.ttv_des_histor_pef at 16 format "x(101)" skip.
                end.
                else do:
                    if  forma_pagto.log_cta_corren_fornec_obrig = yes
                    and v_log_impr_sit = no then do:
                        &if '{&emsfin_version}' >= "5.02" &then
                            if forma_pagto.ind_tip_forma_pagto <> "Ordem de Pagamento" /*l_ordem_de_pagamento*/  then do:
                                if (line-counter(s_1) + 4) > v_rpt_s_1_bottom then
                                    page stream s_1.
                                put stream s_1 unformatted 
                                    "Nome Fornec:" at 1
                                    tt_item_bord_ap_imprimir.tta_nom_pessoa at 14 format "x(40)"
                                    tt_item_bord_ap_imprimir.tta_nom_cidade at 55 format "x(32)" skip
                                    "Forma Pagto:" at 1
                                    tt_item_bord_ap_imprimir.tta_des_forma_pagto at 14 format "x(40)" skip
                                    "   Cod Banc†rio: " at 1
                                    tt_item_bord_ap_imprimir.tta_cod_sist_nac_bcio at 18 format "x(8)"
                                    "-" at 26
                                    tt_item_bord_ap_imprimir.tta_nom_banco at 27 format "x(30)"
                                    " Ag.: " at 58
                                    v_des_agenc_bcia_fornec at 64 format "x(14)"
                                    "  C.Corren: " at 78
                                    v_des_cta_corren_fornec at 90 format "x(25)" skip
                                    "  Hist¢rico: " at 3
                                    tt_item_bord_ap_imprimir.ttv_des_histor_pef at 16 format "x(101)" skip.
                            end.
                            else do:
                                if (line-counter(s_1) + 4) > v_rpt_s_1_bottom then
                                    page stream s_1.
                                put stream s_1 unformatted 
                                    "Nome Fornec:" at 1
                                    tt_item_bord_ap_imprimir.tta_nom_pessoa at 14 format "x(40)"
                                    tt_item_bord_ap_imprimir.tta_nom_cidade at 55 format "x(32)" skip
                                    "Forma Pagto:" at 1
                                    tt_item_bord_ap_imprimir.tta_des_forma_pagto at 14 format "x(40)" skip
                                    "   Cod Banc†rio: " at 1
                                    tt_item_bord_ap_imprimir.tta_cod_sist_nac_bcio at 18 format "x(8)"
                                    "-" at 26
                                    tt_item_bord_ap_imprimir.tta_nom_banco at 27 format "x(30)"
                                    " Ag.: " at 58
                                    v_des_agenc_bcia_fornec at 64 format "x(14)" skip
                                    "  Hist¢rico: " at 3
                                    tt_item_bord_ap_imprimir.ttv_des_histor_pef at 16 format "x(101)" skip.
                            end.                                
                        &else    
                            if entry(1,forma_pagto.cod_livre_1,chr(24)) <> "Ordem de Pagamento" /*l_ordem_de_pagamento*/  then do:
                                if (line-counter(s_1) + 4) > v_rpt_s_1_bottom then
                                    page stream s_1.
                                put stream s_1 unformatted 
                                    "Nome Fornec:" at 1
                                    tt_item_bord_ap_imprimir.tta_nom_pessoa at 14 format "x(40)"
                                    tt_item_bord_ap_imprimir.tta_nom_cidade at 55 format "x(32)" skip
                                    "Forma Pagto:" at 1
                                    tt_item_bord_ap_imprimir.tta_des_forma_pagto at 14 format "x(40)" skip
                                    "   Cod Banc†rio: " at 1
                                    tt_item_bord_ap_imprimir.tta_cod_sist_nac_bcio at 18 format "x(8)"
                                    "-" at 26
                                    tt_item_bord_ap_imprimir.tta_nom_banco at 27 format "x(30)"
                                    " Ag.: " at 58
                                    v_des_agenc_bcia_fornec at 64 format "x(14)"
                                    "  C.Corren: " at 78
                                    v_des_cta_corren_fornec at 90 format "x(25)" skip
                                    "  Hist¢rico: " at 3
                                    tt_item_bord_ap_imprimir.ttv_des_histor_pef at 16 format "x(101)" skip.
                            end.
                            else do:
                                if (line-counter(s_1) + 4) > v_rpt_s_1_bottom then
                                    page stream s_1.
                                put stream s_1 unformatted 
                                    "Nome Fornec:" at 1
                                    tt_item_bord_ap_imprimir.tta_nom_pessoa at 14 format "x(40)"
                                    tt_item_bord_ap_imprimir.tta_nom_cidade at 55 format "x(32)" skip
                                    "Forma Pagto:" at 1
                                    tt_item_bord_ap_imprimir.tta_des_forma_pagto at 14 format "x(40)" skip
                                    "   Cod Banc†rio: " at 1
                                    tt_item_bord_ap_imprimir.tta_cod_sist_nac_bcio at 18 format "x(8)"
                                    "-" at 26
                                    tt_item_bord_ap_imprimir.tta_nom_banco at 27 format "x(30)"
                                    " Ag.: " at 58
                                    v_des_agenc_bcia_fornec at 64 format "x(14)" skip
                                    "  Hist¢rico: " at 3
                                    tt_item_bord_ap_imprimir.ttv_des_histor_pef at 16 format "x(101)" skip.
                            end.                                
                        &endif.
                    end.
                    else do:
                        &if '{&emsfin_version}' >= "5.02" &then
                           if forma_pagto.ind_tip_forma_pagto <> "Ordem de Pagamento" /*l_ordem_de_pagamento*/  then do: 
                               if (line-counter(s_1) + 4) > v_rpt_s_1_bottom then
                                   page stream s_1.
                               put stream s_1 unformatted 
                                   "Nome Fornec:" at 1
                                   tt_item_bord_ap_imprimir.tta_nom_pessoa at 14 format "x(40)"
                                   tt_item_bord_ap_imprimir.tta_nom_cidade at 55 format "x(32)"
                                   "Situaá∆o: " at 88
                                   tt_item_bord_ap_imprimir.ind_sit_item_bord_ap at 98 format "X(9)" skip
                                   "Forma Pagto:" at 1
                                   tt_item_bord_ap_imprimir.tta_des_forma_pagto at 14 format "x(40)" skip
                                   "   Cod Banc†rio: " at 1
                                   tt_item_bord_ap_imprimir.tta_cod_sist_nac_bcio at 18 format "x(8)"
                                   "-" at 26
                                   tt_item_bord_ap_imprimir.tta_nom_banco at 27 format "x(30)"
                                   " Ag.: " at 58
                                   v_des_agenc_bcia_fornec at 64 format "x(14)"
                                   "  C.Corren: " at 78
                                   v_des_cta_corren_fornec at 90 format "x(25)" skip
                                   "  Hist¢rico: " at 3
                                   tt_item_bord_ap_imprimir.ttv_des_histor_pef at 16 format "x(101)" skip.
                           end.
                           else do:
                               if (line-counter(s_1) + 4) > v_rpt_s_1_bottom then
                                   page stream s_1.
                               put stream s_1 unformatted 
                                   "Nome Fornec:" at 1
                                   tt_item_bord_ap_imprimir.tta_nom_pessoa at 14 format "x(40)"
                                   tt_item_bord_ap_imprimir.tta_nom_cidade at 55 format "x(32)"
                                   "Situaá∆o: " at 88
                                   tt_item_bord_ap_imprimir.ind_sit_item_bord_ap at 98 format "X(9)" skip
                                   "Forma Pagto:" at 1
                                   tt_item_bord_ap_imprimir.tta_des_forma_pagto at 14 format "x(40)" skip
                                   "   Cod Banc†rio: " at 1
                                   tt_item_bord_ap_imprimir.tta_cod_sist_nac_bcio at 18 format "x(8)"
                                   "-" at 26
                                   tt_item_bord_ap_imprimir.tta_nom_banco at 27 format "x(30)"
                                   " Ag.: " at 58
                                   v_des_agenc_bcia_fornec at 64 format "x(14)" skip
                                   "  Hist¢rico: " at 3
                                   tt_item_bord_ap_imprimir.ttv_des_histor_pef at 16 format "x(101)" skip.
                           end.
                       &else    
                           if entry(1,forma_pagto.cod_livre_1,chr(24)) <> "Ordem de Pagamento" /*l_ordem_de_pagamento*/  then do: 
                               if (line-counter(s_1) + 4) > v_rpt_s_1_bottom then
                                   page stream s_1.
                               put stream s_1 unformatted 
                                   "Nome Fornec:" at 1
                                   tt_item_bord_ap_imprimir.tta_nom_pessoa at 14 format "x(40)"
                                   tt_item_bord_ap_imprimir.tta_nom_cidade at 55 format "x(32)"
                                   "Situaá∆o: " at 88
                                   tt_item_bord_ap_imprimir.ind_sit_item_bord_ap at 98 format "X(9)" skip
                                   "Forma Pagto:" at 1
                                   tt_item_bord_ap_imprimir.tta_des_forma_pagto at 14 format "x(40)" skip
                                   "   Cod Banc†rio: " at 1
                                   tt_item_bord_ap_imprimir.tta_cod_sist_nac_bcio at 18 format "x(8)"
                                   "-" at 26
                                   tt_item_bord_ap_imprimir.tta_nom_banco at 27 format "x(30)"
                                   " Ag.: " at 58
                                   v_des_agenc_bcia_fornec at 64 format "x(14)"
                                   "  C.Corren: " at 78
                                   v_des_cta_corren_fornec at 90 format "x(25)" skip
                                   "  Hist¢rico: " at 3
                                   tt_item_bord_ap_imprimir.ttv_des_histor_pef at 16 format "x(101)" skip.
                           end.
                           else do:
                               if (line-counter(s_1) + 4) > v_rpt_s_1_bottom then
                                   page stream s_1.
                               put stream s_1 unformatted 
                                   "Nome Fornec:" at 1
                                   tt_item_bord_ap_imprimir.tta_nom_pessoa at 14 format "x(40)"
                                   tt_item_bord_ap_imprimir.tta_nom_cidade at 55 format "x(32)"
                                   "Situaá∆o: " at 88
                                   tt_item_bord_ap_imprimir.ind_sit_item_bord_ap at 98 format "X(9)" skip
                                   "Forma Pagto:" at 1
                                   tt_item_bord_ap_imprimir.tta_des_forma_pagto at 14 format "x(40)" skip
                                   "   Cod Banc†rio: " at 1
                                   tt_item_bord_ap_imprimir.tta_cod_sist_nac_bcio at 18 format "x(8)"
                                   "-" at 26
                                   tt_item_bord_ap_imprimir.tta_nom_banco at 27 format "x(30)"
                                   " Ag.: " at 58
                                   v_des_agenc_bcia_fornec at 64 format "x(14)" skip
                                   "  Hist¢rico: " at 3
                                   tt_item_bord_ap_imprimir.ttv_des_histor_pef at 16 format "x(101)" skip.
                           end.
                       &endif.
                   end.
                end.
            end.
            if  forma_pagto.log_cheq_administ = yes
            then do:
                /* Emerson */
                &if '{&emsfin_version}' >= '5.05' &then
                    if v_log_favorec_cheq_adm = yes then
                        if (line-counter(s_1) + 1) > v_rpt_s_1_bottom then
                            page stream s_1.
                        put stream s_1 unformatted 
                            "Favorecido: " at 1
                            tt_item_bord_ap_imprimir.nom_favorec_cheq at 13 format "x(40)" skip.
                &endif
                if (line-counter(s_1) + 1) > v_rpt_s_1_bottom then
                    page stream s_1.
                put stream s_1 unformatted 
                    "Localizaá∆o:" at 1
                    tt_item_bord_ap_imprimir.tta_ind_localiz_cheq_administ at 14 format "x(16)" skip.    
            end /* if */.
        end /* if */.
        else do:
            if  forma_pagto.log_cta_corren_fornec_obrig = no
            and v_log_impr_sit = no then do:
                if (line-counter(s_1) + 4) > v_rpt_s_1_bottom then
                    page stream s_1.
                put stream s_1 unformatted 
                    "Nome Fornec:" at 1
                    tt_item_bord_ap_imprimir.tta_nom_pessoa at 14 format "x(40)"
                    tt_item_bord_ap_imprimir.tta_nom_cidade at 55 format "x(32)" skip
                    "Forma Pagto:" at 1
                    tt_item_bord_ap_imprimir.tta_des_forma_pagto at 14 format "x(40)" skip (2).
            end.
            else do:
                if  forma_pagto.log_cta_corren_fornec_obrig = no
                and v_log_impr_sit = yes then do:
                    if (line-counter(s_1) + 4) > v_rpt_s_1_bottom then
                        page stream s_1.
                    put stream s_1 unformatted 
                        "Nome Fornec:" at 1
                        tt_item_bord_ap_imprimir.tta_nom_pessoa at 14 format "x(40)"
                        tt_item_bord_ap_imprimir.tta_nom_cidade at 55 format "x(32)"
                        "Situaá∆o: " at 88
                        tt_item_bord_ap_imprimir.ind_sit_item_bord_ap at 98 format "X(9)" skip
                        "Forma Pagto:" at 1
                        tt_item_bord_ap_imprimir.tta_des_forma_pagto at 14 format "x(40)" skip (2).
                end.
                else do:
                    if  forma_pagto.log_cta_corren_fornec_obrig = yes
                    and v_log_impr_sit = no then do:
                        &if '{&emsfin_version}' >= "5.02" &then
                            if forma_pagto.ind_tip_forma_pagto <> "Ordem de Pagamento" /*l_ordem_de_pagamento*/  then do:
                                if (line-counter(s_1) + 4) > v_rpt_s_1_bottom then
                                    page stream s_1.
                                put stream s_1 unformatted 
                                    "Nome Fornec:" at 1
                                    tt_item_bord_ap_imprimir.tta_nom_pessoa at 14 format "x(40)"
                                    tt_item_bord_ap_imprimir.tta_nom_cidade at 55 format "x(32)" skip
                                    "Forma Pagto:" at 1
                                    tt_item_bord_ap_imprimir.tta_des_forma_pagto at 14 format "x(40)" skip
                                    "   Cod Banc†rio: " at 1
                                    tt_item_bord_ap_imprimir.tta_cod_sist_nac_bcio at 18 format "x(8)"
                                    "-" at 26
                                    tt_item_bord_ap_imprimir.tta_nom_banco at 27 format "x(30)"
                                    " Ag.: " at 58
                                    v_des_agenc_bcia_fornec at 64 format "x(14)"
                                    "  C.Corren: " at 78
                                    v_des_cta_corren_fornec at 90 format "x(25)" skip (1).
                            end.
                            else do:
                                if (line-counter(s_1) + 4) > v_rpt_s_1_bottom then
                                    page stream s_1.
                                put stream s_1 unformatted 
                                    "Nome Fornec:" at 1
                                    tt_item_bord_ap_imprimir.tta_nom_pessoa at 14 format "x(40)"
                                    tt_item_bord_ap_imprimir.tta_nom_cidade at 55 format "x(32)" skip
                                    "Forma Pagto:" at 1
                                    tt_item_bord_ap_imprimir.tta_des_forma_pagto at 14 format "x(40)" skip
                                    "   Cod Banc†rio: " at 1
                                    tt_item_bord_ap_imprimir.tta_cod_sist_nac_bcio at 18 format "x(8)"
                                    "-" at 26
                                    tt_item_bord_ap_imprimir.tta_nom_banco at 27 format "x(30)"
                                    " Ag.: " at 58
                                    v_des_agenc_bcia_fornec at 64 format "x(14)" skip (1).
                            end.                                
                        &else    
                            if entry(1,forma_pagto.cod_livre_1,chr(24)) <> "Ordem de Pagamento" /*l_ordem_de_pagamento*/  then do:
                                if (line-counter(s_1) + 4) > v_rpt_s_1_bottom then
                                    page stream s_1.
                                put stream s_1 unformatted 
                                    "Nome Fornec:" at 1
                                    tt_item_bord_ap_imprimir.tta_nom_pessoa at 14 format "x(40)"
                                    tt_item_bord_ap_imprimir.tta_nom_cidade at 55 format "x(32)" skip
                                    "Forma Pagto:" at 1
                                    tt_item_bord_ap_imprimir.tta_des_forma_pagto at 14 format "x(40)" skip
                                    "   Cod Banc†rio: " at 1
                                    tt_item_bord_ap_imprimir.tta_cod_sist_nac_bcio at 18 format "x(8)"
                                    "-" at 26
                                    tt_item_bord_ap_imprimir.tta_nom_banco at 27 format "x(30)"
                                    " Ag.: " at 58
                                    v_des_agenc_bcia_fornec at 64 format "x(14)"
                                    "  C.Corren: " at 78
                                    v_des_cta_corren_fornec at 90 format "x(25)" skip (1).
                            end.
                            else do:
                                if (line-counter(s_1) + 4) > v_rpt_s_1_bottom then
                                    page stream s_1.
                                put stream s_1 unformatted 
                                    "Nome Fornec:" at 1
                                    tt_item_bord_ap_imprimir.tta_nom_pessoa at 14 format "x(40)"
                                    tt_item_bord_ap_imprimir.tta_nom_cidade at 55 format "x(32)" skip
                                    "Forma Pagto:" at 1
                                    tt_item_bord_ap_imprimir.tta_des_forma_pagto at 14 format "x(40)" skip
                                    "   Cod Banc†rio: " at 1
                                    tt_item_bord_ap_imprimir.tta_cod_sist_nac_bcio at 18 format "x(8)"
                                    "-" at 26
                                    tt_item_bord_ap_imprimir.tta_nom_banco at 27 format "x(30)"
                                    " Ag.: " at 58
                                    v_des_agenc_bcia_fornec at 64 format "x(14)" skip (1).
                            end.                                
                        &endif.
                    end.
                    else do:
                        &if '{&emsfin_version}' >= "5.02" &then
                           if forma_pagto.ind_tip_forma_pagto <> "Ordem de Pagamento" /*l_ordem_de_pagamento*/  then do: 
                               if (line-counter(s_1) + 4) > v_rpt_s_1_bottom then
                                   page stream s_1.
                               put stream s_1 unformatted 
                                   "Nome Fornec:" at 1
                                   tt_item_bord_ap_imprimir.tta_nom_pessoa at 14 format "x(40)"
                                   tt_item_bord_ap_imprimir.tta_nom_cidade at 55 format "x(32)"
                                   "Situaá∆o: " at 88
                                   tt_item_bord_ap_imprimir.ind_sit_item_bord_ap at 98 format "X(9)" skip
                                   "Forma Pagto:" at 1
                                   tt_item_bord_ap_imprimir.tta_des_forma_pagto at 14 format "x(40)" skip
                                   "   Cod Banc†rio: " at 1
                                   tt_item_bord_ap_imprimir.tta_cod_sist_nac_bcio at 18 format "x(8)"
                                   "-" at 26
                                   tt_item_bord_ap_imprimir.tta_nom_banco at 27 format "x(30)"
                                   " Ag.: " at 58
                                   v_des_agenc_bcia_fornec at 64 format "x(14)"
                                   "  C.Corren: " at 78
                                   v_des_cta_corren_fornec at 90 format "x(25)" skip (1).
                           end.
                           else do:
                               if (line-counter(s_1) + 4) > v_rpt_s_1_bottom then
                                   page stream s_1.
                               put stream s_1 unformatted 
                                   "Nome Fornec:" at 1
                                   tt_item_bord_ap_imprimir.tta_nom_pessoa at 14 format "x(40)"
                                   tt_item_bord_ap_imprimir.tta_nom_cidade at 55 format "x(32)"
                                   "Situaá∆o: " at 88
                                   tt_item_bord_ap_imprimir.ind_sit_item_bord_ap at 98 format "X(9)" skip
                                   "Forma Pagto:" at 1
                                   tt_item_bord_ap_imprimir.tta_des_forma_pagto at 14 format "x(40)" skip
                                   "   Cod Banc†rio: " at 1
                                   tt_item_bord_ap_imprimir.tta_cod_sist_nac_bcio at 18 format "x(8)"
                                   "-" at 26
                                   tt_item_bord_ap_imprimir.tta_nom_banco at 27 format "x(30)"
                                   " Ag.: " at 58
                                   v_des_agenc_bcia_fornec at 64 format "x(14)" skip (1).
                           end.
                       &else    
                           if entry(1,forma_pagto.cod_livre_1,chr(24)) <> "Ordem de Pagamento" /*l_ordem_de_pagamento*/  then do: 
                               if (line-counter(s_1) + 4) > v_rpt_s_1_bottom then
                                   page stream s_1.
                               put stream s_1 unformatted 
                                   "Nome Fornec:" at 1
                                   tt_item_bord_ap_imprimir.tta_nom_pessoa at 14 format "x(40)"
                                   tt_item_bord_ap_imprimir.tta_nom_cidade at 55 format "x(32)"
                                   "Situaá∆o: " at 88
                                   tt_item_bord_ap_imprimir.ind_sit_item_bord_ap at 98 format "X(9)" skip
                                   "Forma Pagto:" at 1
                                   tt_item_bord_ap_imprimir.tta_des_forma_pagto at 14 format "x(40)" skip
                                   "   Cod Banc†rio: " at 1
                                   tt_item_bord_ap_imprimir.tta_cod_sist_nac_bcio at 18 format "x(8)"
                                   "-" at 26
                                   tt_item_bord_ap_imprimir.tta_nom_banco at 27 format "x(30)"
                                   " Ag.: " at 58
                                   v_des_agenc_bcia_fornec at 64 format "x(14)"
                                   "  C.Corren: " at 78
                                   v_des_cta_corren_fornec at 90 format "x(25)" skip (1).
                           end.
                           else do:
                               if (line-counter(s_1) + 4) > v_rpt_s_1_bottom then
                                   page stream s_1.
                               put stream s_1 unformatted 
                                   "Nome Fornec:" at 1
                                   tt_item_bord_ap_imprimir.tta_nom_pessoa at 14 format "x(40)"
                                   tt_item_bord_ap_imprimir.tta_nom_cidade at 55 format "x(32)"
                                   "Situaá∆o: " at 88
                                   tt_item_bord_ap_imprimir.ind_sit_item_bord_ap at 98 format "X(9)" skip
                                   "Forma Pagto:" at 1
                                   tt_item_bord_ap_imprimir.tta_des_forma_pagto at 14 format "x(40)" skip
                                   "   Cod Banc†rio: " at 1
                                   tt_item_bord_ap_imprimir.tta_cod_sist_nac_bcio at 18 format "x(8)"
                                   "-" at 26
                                   tt_item_bord_ap_imprimir.tta_nom_banco at 27 format "x(30)"
                                   " Ag.: " at 58
                                   v_des_agenc_bcia_fornec at 64 format "x(14)" skip (1).
                           end.
                       &endif.
                   end.
                end.
            end.
            if  forma_pagto.log_cheq_administ = yes
            then do:
                /* Emerson */
                &if '{&emsfin_version}' >= '5.05' &then
                    if v_log_favorec_cheq_adm = yes then
                        if (line-counter(s_1) + 1) > v_rpt_s_1_bottom then
                            page stream s_1.
                        put stream s_1 unformatted 
                            "Favorecido: " at 1
                            tt_item_bord_ap_imprimir.nom_favorec_cheq at 13 format "x(40)" skip.
                &endif
                if (line-counter(s_1) + 1) > v_rpt_s_1_bottom then
                    page stream s_1.
                put stream s_1 unformatted 
                    "Localizaá∆o:" at 1
                    tt_item_bord_ap_imprimir.tta_ind_localiz_cheq_administ at 14 format "x(16)" skip.    
            end /* if */.
        end /* else */.
    end /* if */.
    else do:
        if tt_item_bord_ap_imprimir.ttv_des_histor_pef <> ""
        then do:
            if (line-counter(s_1) + 4) > v_rpt_s_1_bottom then
                page stream s_1.
            put stream s_1 unformatted 
                "Nome Fornec:" at 1
                tt_item_bord_ap_imprimir.tta_nom_pessoa at 14 format "x(40)"
                tt_item_bord_ap_imprimir.tta_nom_cidade at 55 format "x(32)"
                "Situaá∆o: " at 88
                tt_item_bord_ap_imprimir.ind_sit_item_bord_ap at 98 format "X(9)" skip
                "Forma Pagto:" at 1
                tt_item_bord_ap_imprimir.tta_des_forma_pagto at 14 format "x(40)"
                skip (1)
                "  Hist¢rico: " at 3
                tt_item_bord_ap_imprimir.ttv_des_histor_pef at 16 format "x(101)" skip.
        end.
        else do:
            if (line-counter(s_1) + 4) > v_rpt_s_1_bottom then
                page stream s_1.
            put stream s_1 unformatted 
                "Nome Fornec:" at 1
                tt_item_bord_ap_imprimir.tta_nom_pessoa at 14 format "x(40)"
                tt_item_bord_ap_imprimir.tta_nom_cidade at 55 format "x(32)"
                "Situaá∆o: " at 88
                tt_item_bord_ap_imprimir.ind_sit_item_bord_ap at 98 format "X(9)" skip
                "Forma Pagto:" at 1
                tt_item_bord_ap_imprimir.tta_des_forma_pagto at 14 format "x(40)" skip (2).
        end.
    end /* else */.

    if  v_log_salta_lin = yes  then do:
        if (line-counter(s_1) + 1) > v_rpt_s_1_bottom then
            page stream s_1.
        put stream s_1 unformatted  skip (1).
    end.
    assign v_qtd_tot_tit_pag_bord   = v_qtd_tot_tit_pag_bord   + 1
           v_val_pag_bord           = v_val_pag_bord           + tt_item_bord_ap_imprimir.val_pagto
           v_val_multa_pag_bord     = v_val_multa_pag_bord     + tt_item_bord_ap_imprimir.val_multa_tit_ap
           v_val_juros_pag_bord     = v_val_juros_pag_bord     + tt_item_bord_ap_imprimir.val_juros
           v_val_var_mon_pag_bord   = v_val_var_mon_pag_bord   + tt_item_bord_ap_imprimir.val_cm_tit_ap
           v_val_desc_pag_bord      = v_val_desc_pag_bord      + tt_item_bord_ap_imprimir.val_desc_tit_ap
           v_val_abat_pag_bord      = v_val_abat_pag_bord      + tt_item_bord_ap_imprimir.val_abat_tit_ap
           v_val_liq_pag_bord       = v_val_liq_pag_bord       + tt_item_bord_ap_imprimir.ttv_val_liq_item_bord
           v_val_pag_tot_impto      = v_val_pag_tot_impto      + tt_item_bord_ap_imprimir.ttv_val_tot_impto_retid
           v_qtd_tot_tit_pag_bord_1 = v_qtd_tot_tit_pag_bord_1 + 1
           v_val_pag_bord_1         = v_val_pag_bord_1         + tt_item_bord_ap_imprimir.val_pagto
           v_val_multa_pag_bord_1   = v_val_multa_pag_bord_1   + tt_item_bord_ap_imprimir.val_multa_tit_ap
           v_val_juros_pag_bord_1   = v_val_juros_pag_bord_1   + tt_item_bord_ap_imprimir.val_juros
           v_val_var_mon_pag_bord_1 = v_val_var_mon_pag_bord_1 + tt_item_bord_ap_imprimir.val_cm_tit_ap
           v_val_desc_pag_bord_1    = v_val_desc_pag_bord_1    + tt_item_bord_ap_imprimir.val_desc_tit_ap
           v_val_abat_pag_bord_1    = v_val_abat_pag_bord_1    + tt_item_bord_ap_imprimir.val_abat_tit_ap
           v_val_liq_pag_bord_1     = v_val_liq_pag_bord_1     + tt_item_bord_ap_imprimir.ttv_val_liq_item_bord
           v_val_pag_tot_impto_1    = v_val_pag_tot_impto_1    + tt_item_bord_ap_imprimir.ttv_val_tot_impto_retid
           v_qtd_tot_tit_pag_bord_2 = v_qtd_tot_tit_pag_bord_2 + 1
           v_val_pag_bord_2         = v_val_pag_bord_2         + tt_item_bord_ap_imprimir.val_pagto
           v_val_multa_pag_bord_2   = v_val_multa_pag_bord_2   + tt_item_bord_ap_imprimir.val_multa_tit_ap
           v_val_juros_pag_bord_2   = v_val_juros_pag_bord_2   + tt_item_bord_ap_imprimir.val_juros
           v_val_var_mon_pag_bord_2 = v_val_var_mon_pag_bord_2 + tt_item_bord_ap_imprimir.val_cm_tit_ap
           v_val_desc_pag_bord_2    = v_val_desc_pag_bord_2    + tt_item_bord_ap_imprimir.val_desc_tit_ap
           v_val_abat_pag_bord_2    = v_val_abat_pag_bord_2    + tt_item_bord_ap_imprimir.val_abat_tit_ap
           v_val_liq_pag_bord_2     = v_val_liq_pag_bord_2     + tt_item_bord_ap_imprimir.ttv_val_liq_item_bord
           v_val_pag_tot_impto_2    = v_val_pag_tot_impto_2    + tt_item_bord_ap_imprimir.ttv_val_tot_impto_retid.

    /* Verifica e se necessario salta de p†gina */

    if  (line-counter(s_1) + 15) > v_rpt_s_1_bottom then do:
        assign v_qtd_tot_tit_bord = v_qtd_tot_tit_bord + v_qtd_tot_tit_pag_bord
               v_val_tot_bord     = v_val_tot_bord     + v_val_pag_bord
               v_val_multa_bord   = v_val_multa_bord   + v_val_multa_pag_bord
               v_val_juros_bord   = v_val_juros_bord   + v_val_juros_pag_bord
               v_val_var_mon_bord = v_val_var_mon_bord + v_val_var_mon_pag_bord
               v_val_desc_bord    = v_val_desc_bord    + v_val_desc_pag_bord
               v_val_abat_bord    = v_val_abat_bord    + v_val_abat_pag_bord
               v_val_liq_bord     = v_val_liq_bord     + v_val_liq_pag_bord.

        put stream s_1 unformatted 
            "---------------------------------------------------------" at 1
            "---------------------------------------------------------" at 58 skip
            'Total da  Pagina:' at 1
            v_val_pag_bord to 37 format ">,>>>,>>>,>>9.99"
            v_val_multa_pag_bord to 82 format "->>>,>>>,>>9.99"
            v_val_juros_pag_bord to 98 format "->>>,>>>,>>9.99"
            v_val_var_mon_pag_bord to 114 format "->>>,>>>,>>9.99" skip
            'Total de Titulos:' at 1
            v_qtd_tot_tit_pag_bord to 34 format ">>9"
            v_val_pag_tot_impto to 66 format "->>>,>>>,>>9.99"
            v_val_desc_pag_bord to 82 format "->>>,>>>,>>9.99"
            v_val_abat_pag_bord to 98 format "->>>,>>>,>>9.99"
            v_val_liq_pag_bord to 114 format "->>>,>>>,>>9.99" skip
            "---------------------------------------------------------" at 1
            "---------------------------------------------------------" at 58 skip (1).

        put stream s_1 unformatted 
            ' Pag: ' at 104
            v_num_pag to 113 format ">>>9" skip (1).

        page stream s_1.
        if  v_log_cabec_todas_pag = yes then
            run pi_cabec_bord_ap /*pi_cabec_bord_ap*/.
        assign v_num_pag              = v_num_pag + 1
               v_qtd_tot_tit_pag_bord = 0
               v_val_pag_bord         = 0
               v_val_multa_pag_bord   = 0
               v_val_juros_pag_bord   = 0
               v_val_var_mon_pag_bord = 0
               v_val_desc_pag_bord    = 0
               v_val_abat_pag_bord    = 0
               v_val_liq_pag_bord     = 0
               v_val_pag_tot_impto    = 0.
    end.

END PROCEDURE. /* pi_corpo_bord_ap_imprimir */
/*****************************************************************************
** Procedure Interna.....: pi_cabec_bord_ap
** Descricao.............: pi_cabec_bord_ap
** Criado por............: Ganzen
** Criado em.............: 28/11/1995 15:21:02
** Alterado por..........: fut1309
** Alterado em...........: 04/08/2005 08:59:28
*****************************************************************************/
PROCEDURE pi_cabec_bord_ap:

    /************************* Variable Definition Begin ************************/

    def var v_ind_tip_relat_bord_apb
        as character
        format "X(08)":U
        no-undo.


    /************************** Variable Definition End *************************/

    if  v_log_impr_sit = no and  v_num_aux <> v_num_count
    then do:
        if  bord_ap.log_bord_ap_escrit = no
        then do:
            assign v_ind_tip_relat_bord_apb = "Normal" /*l_normal*/ .
            /* A variavel v_ind_ender_complet Ç utilizada para a funcao "BF_FIN_4LINHAS_END"
               Sempre que a funá∆o n∆o estiver sendo utilizada, o valor ser† "Endereáo"      */
            if  v_ind_ender_complet = "Endereáo" /*l_endereco*/ 
            then do:
                /* Imprimi cabeáario com o Endereáo Normal */
                if (line-counter(s_1) + 9) > v_rpt_s_1_bottom then
                    page stream s_1.
                put stream s_1 unformatted 
                    "EMPRESA.............:" at 1
                    v_nom_pessoa_jur at 23 format "x(40)" skip
                    "ENDEREÄO............:" at 1
                    v_nom_endereco at 23 format "x(40)" skip
                    "CIDADE..............:" at 1
                    v_nom_cidade_jur at 23 format "x(32)"
                    "-" at 56
                    v_cod_unid_federac at 58 format "x(3)"
                    "-" at 62
                    v_cod_cep at 64 format "x(20)" skip
                    v_nom_label_id_feder at 1 format "x(21)"
                    v_cod_id_feder at 23 format "x(20)" skip
                    "BANCO...............:" at 1
                    emscad.banco.nom_banco at 23 format "x(30)" skip
                    "AG“NCIA.............:" at 1
                    v_des_agenc_bcia_portad at 23 format "x(50)" skip
                    "C. CORRENTE.........:" at 1
                    v_des_cta_corren_portad at 23 format "x(25)" skip
                    "BORDER‚.............:" at 1
                    bord_ap.num_bord_ap to 28 format ">>>>>9" skip
                    "DATA EMISS«O........:" at 1
                    bord_ap.dat_transacao at 23 format "99/99/9999"
                    "MOEDA DO BORDER‚:" at 35
                    v_cod_indic_econ at 53 format "x(8)" skip.
            end /* if */.
            else do:
                /* "BF_FIN_4LINHAS_END" */
                if (line-counter(s_1) + 10) > v_rpt_s_1_bottom then
                    page stream s_1.
                put stream s_1 unformatted 
                    "EMPRESA.............:" at 1
                    v_nom_pessoa_jur at 23 format "x(40)" skip
                    "ENDEREÄO............:" at 1
                    v_nom_ender_lin_1 at 23 format "x(50)" skip
                    v_nom_ender_lin_2 at 23 format "x(50)" skip
                    v_nom_ender_lin_3 at 23 format "x(50)" skip
                    v_nom_ender_lin_4 at 23 format "x(50)" skip
                    "BANCO...............:" at 1
                    banco.nom_banco at 23 format "x(30)" skip
                    "AG“NCIA.............:" at 1
                    v_des_agenc_bcia_portad at 23 format "x(50)" skip
                    "C. CORRENTE.........:" at 1
                    v_des_cta_corren_portad at 23 format "x(25)" skip
                    "BORDER‚.............:" at 1
                    bord_ap.num_bord_ap to 28 format ">>>>>9" skip
                    "DATA EMISS«O........:" at 1
                    bord_ap.dat_transacao at 23 format "99/99/9999"
                    "MOEDA DO BORDER‚:" at 35
                    v_cod_indic_econ at 53 format "x(8)" skip.
            end /* else */.
        end /* if */.
        else do:
            assign v_ind_tip_relat_bord_apb = "Escritural" /*l_escritural*/ .
            if  v_ind_ender_complet = "Endereáo" /*l_endereco*/ 
            then do:
                /* Imprimi cabeáario com o Endereáo Normal */
                if (line-counter(s_1) + 9) > v_rpt_s_1_bottom then
                    page stream s_1.
                put stream s_1 unformatted 
                    "EMPRESA.............:" at 1
                    v_nom_pessoa_jur at 23 format "x(40)" skip
                    "ENDEREÄO............:" at 1
                    v_nom_endereco at 23 format "x(40)" skip
                    "CIDADE..............:" at 1
                    v_nom_cidade_jur at 23 format "x(32)"
                    "-" at 56
                    v_cod_unid_federac at 58 format "x(3)"
                    "-" at 62
                    v_cod_cep at 64 format "x(20)" skip
                    v_nom_label_id_feder at 1 format "x(21)"
                    v_cod_id_feder at 23 format "x(20)" skip
                    "BANCO...............:" at 1
                    banco.nom_banco at 23 format "x(30)"
                    "*********************" at 94 skip
                    "AG“NCIA.............:" at 1
                    v_des_agenc_bcia_portad at 23 format "x(50)"
                    "*" at 94
                    "  BORDER‚  " at 99
                    "*" at 114 skip
                    "C. CORRENTE.........:" at 1
                    v_des_cta_corren_portad at 23 format "x(25)"
                    "*" at 94
                    " ESCRITURAL  " at 99
                    "*" at 114 skip
                    "BORDER‚.............:" at 1
                    bord_ap.num_bord_ap to 28 format ">>>>>9"
                    "*********************" at 94 skip
                    "DATA EMISS«O........:" at 1
                    bord_ap.dat_transacao at 23 format "99/99/9999" skip.
            end /* if */.
            else do:
                /* Imprimi cabeáario com o Endereáo Completo, com as 4 Linhas "BF_FIN_4LINHAS_END" */
                if (line-counter(s_1) + 10) > v_rpt_s_1_bottom then
                    page stream s_1.
                put stream s_1 unformatted 
                    "EMPRESA.............:" at 1
                    v_nom_pessoa_jur at 23 format "x(40)" skip
                    "ENDEREÄO............:" at 1
                    v_nom_ender_lin_1 at 23 format "x(50)" skip
                    v_nom_ender_lin_2 at 23 format "x(50)" skip
                    v_nom_ender_lin_3 at 23 format "x(50)" skip
                    v_nom_ender_lin_4 at 23 format "x(50)" skip
                    "BANCO...............:" at 1
                    banco.nom_banco at 23 format "x(30)"
                    "*********************" at 94 skip
                    "AG“NCIA.............:" at 1
                    v_des_agenc_bcia_portad at 23 format "x(50)"
                    "*" at 94
                    "  BORDER‚  " at 99
                    "*" at 114 skip
                    "C. CORRENTE.........:" at 1
                    v_des_cta_corren_portad at 23 format "x(25)"
                    "*" at 94
                    " ESCRITURAL  " at 99
                    "*" at 114 skip
                    "BORDER‚.............:" at 1
                    bord_ap.num_bord_ap to 28 format ">>>>>9"
                    "*********************" at 94 skip
                    "DATA EMISS«O........:" at 1
                    bord_ap.dat_transacao at 23 format "99/99/9999" skip.
            end /* else */.
        end /* else */.
        run pi_imprime_complemento_cabec_bordero (Input v_ind_tip_relat_bord_apb,
                                                  Input v_des_msg_inic_bord_apb) /*pi_imprime_complemento_cabec_bordero*/.

        if (line-counter(s_1) + 1) > v_rpt_s_1_bottom then
            page stream s_1.
        put stream s_1 unformatted 
            "---------------------------------------------------------" at 1
            "---------------------------------------------------------" at 58 skip.
        if (line-counter(s_1) + 5) > v_rpt_s_1_bottom then
            page stream s_1.
        put stream s_1 unformatted 
            "Fornec" to 11
            "Documento" at 13
            "Dt Emiss∆o" at 39
            "Valor Pagto" to 66
            "Vl Multa" to 82
            "Vl Juros" to 98
            "Corr Monet" to 114 skip
            "Vencto" at 39
            "Impto Retido" to 66
            "Vl Descto" to 82
            "Vl Abat" to 98
            "Valor L°quido" to 114 skip
            "------------------------------------------------------------------------------------------------------------------" at 1 skip.
    end /* if */.
    else do:
        if  v_log_impr_sit = no and  v_num_aux = v_num_count
        then do:
            if  bord_ap.log_bord_ap_escrit = no
            then do:
                assign v_ind_tip_relat_bord_apb = "Normal" /*l_normal*/ .
                if  v_ind_ender_complet = "Endereáo" /*l_endereco*/ 
                then do:
                    /* Imprimi cabeáario com o Endereáo Normal */
                    if (line-counter(s_1) + 9) > v_rpt_s_1_bottom then
                        page stream s_1.
                    put stream s_1 unformatted 
                        "EMPRESA.............:" at 1
                        v_nom_pessoa_jur at 23 format "x(40)" skip
                        "ENDEREÄO............:" at 1
                        v_nom_endereco at 23 format "x(40)" skip
                        "CIDADE..............:" at 1
                        v_nom_cidade_jur at 23 format "x(32)"
                        "-" at 56
                        v_cod_unid_federac at 58 format "x(3)"
                        "-" at 62
                        v_cod_cep at 64 format "x(20)" skip
                        v_nom_label_id_feder at 1 format "x(21)"
                        v_cod_id_feder at 23 format "x(20)" skip
                        "BANCO...............:" at 1
                        banco.nom_banco at 23 format "x(30)" skip
                        "AG“NCIA.............:" at 1
                        v_des_agenc_bcia_portad at 23 format "x(50)" skip
                        "C. CORRENTE.........:" at 1
                        v_des_cta_corren_portad at 23 format "x(25)" skip
                        "BORDER‚.............:" at 1
                        bord_ap.num_bord_ap to 28 format ">>>>>9" skip
                        "DATA EMISS«O........:" at 1
                        bord_ap.dat_transacao at 23 format "99/99/9999"
                        "MOEDA DO BORDER‚:" at 35
                        v_cod_indic_econ at 53 format "x(8)" skip.
                end /* if */.
                else do:
                    /* Imprimi cabeáario com o Endereáo Completo, com as 4 Linhas "BF_FIN_4LINHAS_END" */
                    if (line-counter(s_1) + 10) > v_rpt_s_1_bottom then
                        page stream s_1.
                    put stream s_1 unformatted 
                        "EMPRESA.............:" at 1
                        v_nom_pessoa_jur at 23 format "x(40)" skip
                        "ENDEREÄO............:" at 1
                        v_nom_ender_lin_1 at 23 format "x(50)" skip
                        v_nom_ender_lin_2 at 23 format "x(50)" skip
                        v_nom_ender_lin_3 at 23 format "x(50)" skip
                        v_nom_ender_lin_4 at 23 format "x(50)" skip
                        "BANCO...............:" at 1
                        banco.nom_banco at 23 format "x(30)" skip
                        "AG“NCIA.............:" at 1
                        v_des_agenc_bcia_portad at 23 format "x(50)" skip
                        "C. CORRENTE.........:" at 1
                        v_des_cta_corren_portad at 23 format "x(25)" skip
                        "BORDER‚.............:" at 1
                        bord_ap.num_bord_ap to 28 format ">>>>>9" skip
                        "DATA EMISS«O........:" at 1
                        bord_ap.dat_transacao at 23 format "99/99/9999"
                        "MOEDA DO BORDER‚:" at 35
                        v_cod_indic_econ at 53 format "x(8)" skip.
                end /* else */.
            end /* if */.
            else do:
                assign v_ind_tip_relat_bord_apb = "Escritural" /*l_escritural*/ .
                if  v_ind_ender_complet = "Endereáo" /*l_endereco*/ 
                then do:
                    /* Imprimi cabeáario com o Endereáo Normal */
                    if (line-counter(s_1) + 9) > v_rpt_s_1_bottom then
                        page stream s_1.
                    put stream s_1 unformatted 
                        "EMPRESA.............:" at 1
                        v_nom_pessoa_jur at 23 format "x(40)" skip
                        "ENDEREÄO............:" at 1
                        v_nom_endereco at 23 format "x(40)" skip
                        "CIDADE..............:" at 1
                        v_nom_cidade_jur at 23 format "x(32)"
                        "-" at 56
                        v_cod_unid_federac at 58 format "x(3)"
                        "-" at 62
                        v_cod_cep at 64 format "x(20)" skip
                        v_nom_label_id_feder at 1 format "x(21)"
                        v_cod_id_feder at 23 format "x(20)" skip
                        "BANCO...............:" at 1
                        banco.nom_banco at 23 format "x(30)"
                        "*********************" at 94 skip
                        "AG“NCIA.............:" at 1
                        v_des_agenc_bcia_portad at 23 format "x(50)"
                        "*" at 94
                        "  BORDER‚  " at 99
                        "*" at 114 skip
                        "C. CORRENTE.........:" at 1
                        v_des_cta_corren_portad at 23 format "x(25)"
                        "*" at 94
                        " ESCRITURAL  " at 99
                        "*" at 114 skip
                        "BORDER‚.............:" at 1
                        bord_ap.num_bord_ap to 28 format ">>>>>9"
                        "*********************" at 94 skip
                        "DATA EMISS«O........:" at 1
                        bord_ap.dat_transacao at 23 format "99/99/9999" skip.
                end /* if */.
                else do:
                    /* Imprimi cabeáario com o Endereáo Completo, com as 4 Linhas "BF_FIN_4LINHAS_END" */
                    if (line-counter(s_1) + 10) > v_rpt_s_1_bottom then
                        page stream s_1.
                    put stream s_1 unformatted 
                        "EMPRESA.............:" at 1
                        v_nom_pessoa_jur at 23 format "x(40)" skip
                        "ENDEREÄO............:" at 1
                        v_nom_ender_lin_1 at 23 format "x(50)" skip
                        v_nom_ender_lin_2 at 23 format "x(50)" skip
                        v_nom_ender_lin_3 at 23 format "x(50)" skip
                        v_nom_ender_lin_4 at 23 format "x(50)" skip
                        "BANCO...............:" at 1
                        banco.nom_banco at 23 format "x(30)"
                        "*********************" at 94 skip
                        "AG“NCIA.............:" at 1
                        v_des_agenc_bcia_portad at 23 format "x(50)"
                        "*" at 94
                        "  BORDER‚  " at 99
                        "*" at 114 skip
                        "C. CORRENTE.........:" at 1
                        v_des_cta_corren_portad at 23 format "x(25)"
                        "*" at 94
                        " ESCRITURAL  " at 99
                        "*" at 114 skip
                        "BORDER‚.............:" at 1
                        bord_ap.num_bord_ap to 28 format ">>>>>9"
                        "*********************" at 94 skip
                        "DATA EMISS«O........:" at 1
                        bord_ap.dat_transacao at 23 format "99/99/9999" skip.
                end /* else */.
            end /* else */.
            run pi_imprime_complemento_cabec_bordero (Input v_ind_tip_relat_bord_apb,
                                                      Input v_des_msg_inic_bord_apb) /*pi_imprime_complemento_cabec_bordero*/.
        end /* if */.
        else do:
            if  v_log_impr_sit = yes and  v_num_aux = v_num_count
            then do:
                if  bord_ap.log_bord_ap_escrit = no
                then do:
                    assign v_ind_tip_relat_bord_apb = "Normal" /*l_normal*/ .
                    if  v_ind_ender_complet = "Endereáo" /*l_endereco*/ 
                    then do:
                        /* Imprimi cabeáario com o Endereáo Normal */
                        if (line-counter(s_1) + 9) > v_rpt_s_1_bottom then
                            page stream s_1.
                        put stream s_1 unformatted 
                            "EMPRESA.............:" at 1
                            v_nom_pessoa_jur at 23 format "x(40)" skip
                            "ENDEREÄO............:" at 1
                            v_nom_endereco at 23 format "x(40)" skip
                            "CIDADE..............:" at 1
                            v_nom_cidade_jur at 23 format "x(32)"
                            "-" at 56
                            v_cod_unid_federac at 58 format "x(3)"
                            "-" at 62
                            v_cod_cep at 64 format "x(20)" skip
                            v_nom_label_id_feder at 1 format "x(21)"
                            v_cod_id_feder at 23 format "x(20)" skip
                            "BANCO...............:" at 1
                            banco.nom_banco at 23 format "x(30)" skip
                            "AG“NCIA.............:" at 1
                            v_des_agenc_bcia_portad at 23 format "x(50)" skip
                            "C. CORRENTE.........:" at 1
                            v_des_cta_corren_portad at 23 format "x(25)" skip
                            "BORDER‚.............:" at 1
                            bord_ap.num_bord_ap to 28 format ">>>>>9"
                            "SITUAÄ«O............:" at 31
                            v_ind_sit_bord_impr at 53 format "X(20)" skip
                            "DATA EMISS«O........:" at 1
                            bord_ap.dat_transacao at 23 format "99/99/9999"
                            "MOEDA DO BORDER‚:" at 35
                            v_cod_indic_econ at 53 format "x(8)" skip.
                    end /* if */.
                    else do:
                        /* Imprimi cabeáario com o Endereáo Completo, com as 4 Linhas "BF_FIN_4LINHAS_END" */
                        if (line-counter(s_1) + 10) > v_rpt_s_1_bottom then
                            page stream s_1.
                        put stream s_1 unformatted 
                            "EMPRESA.............:" at 1
                            v_nom_pessoa_jur at 23 format "x(40)" skip
                            "ENDEREÄO............:" at 1
                            v_nom_ender_lin_1 at 23 format "x(50)" skip
                            v_nom_ender_lin_2 at 23 format "x(50)" skip
                            v_nom_ender_lin_3 at 23 format "x(50)" skip
                            v_nom_ender_lin_4 at 23 format "x(50)" skip
                            "BANCO...............:" at 1
                            banco.nom_banco at 23 format "x(30)" skip
                            "AG“NCIA.............:" at 1
                            v_des_agenc_bcia_portad at 23 format "x(50)" skip
                            "C. CORRENTE.........:" at 1
                            v_des_cta_corren_portad at 23 format "x(25)" skip
                            "BORDER‚.............:" at 1
                            bord_ap.num_bord_ap to 28 format ">>>>>9"
                            "SITUAÄ«O............:" at 31
                            v_ind_sit_bord_impr at 53 format "X(20)" skip
                            "DATA EMISS«O........:" at 1
                            bord_ap.dat_transacao at 23 format "99/99/9999"
                            "MOEDA DO BORDER‚:" at 35
                            v_cod_indic_econ at 53 format "x(8)" skip.
                    end /* else */.
                end /* if */.
                else do:
                    assign v_ind_tip_relat_bord_apb = "Escritural" /*l_escritural*/ .
                    if  v_ind_ender_complet = "Endereáo" /*l_endereco*/ 
                    then do:
                        /* Imprimi cabeáario com o Endereáo Normal */
                        if (line-counter(s_1) + 9) > v_rpt_s_1_bottom then
                            page stream s_1.
                        put stream s_1 unformatted 
                            "EMPRESA.............:" at 1
                            v_nom_pessoa_jur at 23 format "x(40)" skip
                            "ENDEREÄO............:" at 1
                            v_nom_endereco at 23 format "x(40)" skip
                            "CIDADE..............:" at 1
                            v_nom_cidade_jur at 23 format "x(32)"
                            "-" at 56
                            v_cod_unid_federac at 58 format "x(3)"
                            "-" at 62
                            v_cod_cep at 64 format "x(20)" skip
                            v_nom_label_id_feder at 1 format "x(21)"
                            v_cod_id_feder at 23 format "x(20)" skip
                            "BANCO...............:" at 1
                            banco.nom_banco at 23 format "x(30)"
                            "*********************" at 94 skip
                            "AG“NCIA.............:" at 1
                            v_des_agenc_bcia_portad at 23 format "x(50)"
                            "*" at 94
                            "  BORDER‚  " at 99
                            "*" at 114 skip
                            "C. CORRENTE.........:" at 1
                            v_des_cta_corren_portad at 23 format "x(25)"
                            "*" at 94
                            " ESCRITURAL  " at 99
                            "*" at 114 skip
                            "BORDER‚.............:" at 1
                            bord_ap.num_bord_ap to 28 format ">>>>>9"
                            "SITUAÄ«O............:" at 31
                            v_ind_sit_bord_impr at 53 format "X(20)"
                            "*********************" at 94 skip
                            "DATA EMISS«O........:" at 1
                            bord_ap.dat_transacao at 23 format "99/99/9999" skip.
                    end /* if */.
                    else do:
                        /* Imprimi cabeáario com o Endereáo Completo, com as 4 Linhas "BF_FIN_4LINHAS_END" */
                        if (line-counter(s_1) + 10) > v_rpt_s_1_bottom then
                            page stream s_1.
                        put stream s_1 unformatted 
                            "EMPRESA.............:" at 1
                            v_nom_pessoa_jur at 23 format "x(40)" skip
                            "ENDEREÄO............:" at 1
                            v_nom_ender_lin_1 at 23 format "x(50)" skip
                            v_nom_ender_lin_2 at 23 format "x(50)" skip
                            v_nom_ender_lin_3 at 23 format "x(50)" skip
                            v_nom_ender_lin_4 at 23 format "x(50)" skip
                            "BANCO...............:" at 1
                            banco.nom_banco at 23 format "x(30)"
                            "*********************" at 94 skip
                            "AG“NCIA.............:" at 1
                            v_des_agenc_bcia_portad at 23 format "x(50)"
                            "*" at 94
                            "  BORDER‚  " at 99
                            "*" at 114 skip
                            "C. CORRENTE.........:" at 1
                            v_des_cta_corren_portad at 23 format "x(25)"
                            "*" at 94
                            " ESCRITURAL  " at 99
                            "*" at 114 skip
                            "BORDER‚.............:" at 1
                            bord_ap.num_bord_ap to 28 format ">>>>>9"
                            "SITUAÄ«O............:" at 31
                            v_ind_sit_bord_impr at 53 format "X(20)"
                            "*********************" at 94 skip
                            "DATA EMISS«O........:" at 1
                            bord_ap.dat_transacao at 23 format "99/99/9999" skip.
                    end /* else */.
                end /* else */.
                run pi_imprime_complemento_cabec_bordero (Input v_ind_tip_relat_bord_apb,
                                                          Input v_des_msg_inic_bord_apb) /*pi_imprime_complemento_cabec_bordero*/.
            end /* if */.
            else do:
                if  bord_ap.log_bord_ap_escrit = no
                then do:
                    assign v_ind_tip_relat_bord_apb = "Normal" /*l_normal*/ .
                    if  v_ind_ender_complet = "Endereáo" /*l_endereco*/ 
                    then do:
                        /* Imprimi cabeáario com o Endereáo Normal */
                        if (line-counter(s_1) + 9) > v_rpt_s_1_bottom then
                            page stream s_1.
                        put stream s_1 unformatted 
                            "EMPRESA.............:" at 1
                            v_nom_pessoa_jur at 23 format "x(40)" skip
                            "ENDEREÄO............:" at 1
                            v_nom_endereco at 23 format "x(40)" skip
                            "CIDADE..............:" at 1
                            v_nom_cidade_jur at 23 format "x(32)"
                            "-" at 56
                            v_cod_unid_federac at 58 format "x(3)"
                            "-" at 62
                            v_cod_cep at 64 format "x(20)" skip
                            v_nom_label_id_feder at 1 format "x(21)"
                            v_cod_id_feder at 23 format "x(20)" skip
                            "BANCO...............:" at 1
                            banco.nom_banco at 23 format "x(30)" skip
                            "AG“NCIA.............:" at 1
                            v_des_agenc_bcia_portad at 23 format "x(50)" skip
                            "C. CORRENTE.........:" at 1
                            v_des_cta_corren_portad at 23 format "x(25)" skip
                            "BORDER‚.............:" at 1
                            bord_ap.num_bord_ap to 28 format ">>>>>9"
                            "SITUAÄ«O............:" at 31
                            v_ind_sit_bord_impr at 53 format "X(20)" skip
                            "DATA EMISS«O........:" at 1
                            bord_ap.dat_transacao at 23 format "99/99/9999"
                            "MOEDA DO BORDER‚:" at 35
                            v_cod_indic_econ at 53 format "x(8)" skip.
                    end /* if */.
                    else do:
                        /* Imprimi cabeáario com o Endereáo Completo, com as 4 Linhas "BF_FIN_4LINHAS_END" */
                        if (line-counter(s_1) + 10) > v_rpt_s_1_bottom then
                            page stream s_1.
                        put stream s_1 unformatted 
                            "EMPRESA.............:" at 1
                            v_nom_pessoa_jur at 23 format "x(40)" skip
                            "ENDEREÄO............:" at 1
                            v_nom_ender_lin_1 at 23 format "x(50)" skip
                            v_nom_ender_lin_2 at 23 format "x(50)" skip
                            v_nom_ender_lin_3 at 23 format "x(50)" skip
                            v_nom_ender_lin_4 at 23 format "x(50)" skip
                            "BANCO...............:" at 1
                            banco.nom_banco at 23 format "x(30)" skip
                            "AG“NCIA.............:" at 1
                            v_des_agenc_bcia_portad at 23 format "x(50)" skip
                            "C. CORRENTE.........:" at 1
                            v_des_cta_corren_portad at 23 format "x(25)" skip
                            "BORDER‚.............:" at 1
                            bord_ap.num_bord_ap to 28 format ">>>>>9"
                            "SITUAÄ«O............:" at 31
                            v_ind_sit_bord_impr at 53 format "X(20)" skip
                            "DATA EMISS«O........:" at 1
                            bord_ap.dat_transacao at 23 format "99/99/9999"
                            "MOEDA DO BORDER‚:" at 35
                            v_cod_indic_econ at 53 format "x(8)" skip.
                    end /* else */.
                end /* if */.
                else do:
                    assign v_ind_tip_relat_bord_apb = "Escritural" /*l_escritural*/ .
                    if  v_ind_ender_complet = "Endereáo" /*l_endereco*/ 
                    then do:
                        /* Imprimi cabeáario com o Endereáo Normal */
                        if (line-counter(s_1) + 9) > v_rpt_s_1_bottom then
                            page stream s_1.
                        put stream s_1 unformatted 
                            "EMPRESA.............:" at 1
                            v_nom_pessoa_jur at 23 format "x(40)" skip
                            "ENDEREÄO............:" at 1
                            v_nom_endereco at 23 format "x(40)" skip
                            "CIDADE..............:" at 1
                            v_nom_cidade_jur at 23 format "x(32)"
                            "-" at 56
                            v_cod_unid_federac at 58 format "x(3)"
                            "-" at 62
                            v_cod_cep at 64 format "x(20)" skip
                            v_nom_label_id_feder at 1 format "x(21)"
                            v_cod_id_feder at 23 format "x(20)" skip
                            "BANCO...............:" at 1
                            banco.nom_banco at 23 format "x(30)"
                            "*********************" at 94 skip
                            "AG“NCIA.............:" at 1
                            v_des_agenc_bcia_portad at 23 format "x(50)"
                            "*" at 94
                            "  BORDER‚  " at 99
                            "*" at 114 skip
                            "C. CORRENTE.........:" at 1
                            v_des_cta_corren_portad at 23 format "x(25)"
                            "*" at 94
                            " ESCRITURAL  " at 99
                            "*" at 114 skip
                            "BORDER‚.............:" at 1
                            bord_ap.num_bord_ap to 28 format ">>>>>9"
                            "SITUAÄ«O............:" at 31
                            v_ind_sit_bord_impr at 53 format "X(20)"
                            "*********************" at 94 skip
                            "DATA EMISS«O........:" at 1
                            bord_ap.dat_transacao at 23 format "99/99/9999" skip.
                    end /* if */.
                    else do:
                        /* Imprimi cabeáario com o Endereáo Completo, com as 4 Linhas "BF_FIN_4LINHAS_END" */
                        if (line-counter(s_1) + 10) > v_rpt_s_1_bottom then
                            page stream s_1.
                        put stream s_1 unformatted 
                            "EMPRESA.............:" at 1
                            v_nom_pessoa_jur at 23 format "x(40)" skip
                            "ENDEREÄO............:" at 1
                            v_nom_ender_lin_1 at 23 format "x(50)" skip
                            v_nom_ender_lin_2 at 23 format "x(50)" skip
                            v_nom_ender_lin_3 at 23 format "x(50)" skip
                            v_nom_ender_lin_4 at 23 format "x(50)" skip
                            "BANCO...............:" at 1
                            banco.nom_banco at 23 format "x(30)"
                            "*********************" at 94 skip
                            "AG“NCIA.............:" at 1
                            v_des_agenc_bcia_portad at 23 format "x(50)"
                            "*" at 94
                            "  BORDER‚  " at 99
                            "*" at 114 skip
                            "C. CORRENTE.........:" at 1
                            v_des_cta_corren_portad at 23 format "x(25)"
                            "*" at 94
                            " ESCRITURAL  " at 99
                            "*" at 114 skip
                            "BORDER‚.............:" at 1
                            bord_ap.num_bord_ap to 28 format ">>>>>9"
                            "SITUAÄ«O............:" at 31
                            v_ind_sit_bord_impr at 53 format "X(20)"
                            "*********************" at 94 skip
                            "DATA EMISS«O........:" at 1
                            bord_ap.dat_transacao at 23 format "99/99/9999" skip.
                    end /* else */.
                end /* else */.
                run pi_imprime_complemento_cabec_bordero (Input v_ind_tip_relat_bord_apb,
                                                          Input v_des_msg_inic_bord_apb) /*pi_imprime_complemento_cabec_bordero*/.
                if (line-counter(s_1) + 1) > v_rpt_s_1_bottom then
                    page stream s_1.
                put stream s_1 unformatted 
                    "---------------------------------------------------------" at 1
                    "---------------------------------------------------------" at 58 skip.
                if (line-counter(s_1) + 5) > v_rpt_s_1_bottom then
                    page stream s_1.
                put stream s_1 unformatted 
                    "Fornec" to 11
                    "Documento" at 13
                    "Dt Emiss∆o" at 39
                    "Valor Pagto" to 66
                    "Vl Multa" to 82
                    "Vl Juros" to 98
                    "Corr Monet" to 114 skip
                    "Vencto" at 39
                    "Impto Retido" to 66
                    "Vl Descto" to 82
                    "Vl Abat" to 98
                    "Valor L°quido" to 114 skip
                    "------------------------------------------------------------------------------------------------------------------" at 1 skip.
            end /* else */.
        end /* else */.
    end /* else */.

END PROCEDURE. /* pi_cabec_bord_ap */
/*****************************************************************************
** Procedure Interna.....: pi_show_report_2
** Descricao.............: pi_show_report_2
** Criado por............: Gilsinei
** Criado em.............: 07/03/1996 14:42:50
** Alterado por..........: bre19127
** Alterado em...........: 21/05/2002 10:16:34
*****************************************************************************/
PROCEDURE pi_show_report_2:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_dwb_file
        as character
        format "x(40)"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_cod_key_value
        as character
        format "x(8)":U
        no-undo.


    /************************** Variable Definition End *************************/

    get-key-value section 'EMS' key 'Show-Report-Program' value v_cod_key_value.
    if  v_cod_key_value = ""
    or   v_cod_key_value = ?
    then do:
        assign v_cod_key_value = 'notepad.exe'.
        put-key-value section 'EMS' key 'Show-Report-Program' value v_cod_key_value no-error.
    end /* if */.

    run winexec (input v_cod_key_value + chr(32) + p_cod_dwb_file, input 1).

    END PROCEDURE.

    PROCEDURE WinExec EXTERNAL 'kernel32.dll':
      DEF INPUT  PARAM prg_name                          AS CHARACTER.
      DEF INPUT  PARAM prg_style                         AS SHORT.




END PROCEDURE. /* pi_show_report_2 */
/*****************************************************************************
** Procedure Interna.....: pi_verificar_abat_antecip_voucher_pagto
** Descricao.............: pi_verificar_abat_antecip_voucher_pagto
** Criado por............: alexsandra
** Criado em.............: 06/05/1996 16:57:29
** Alterado por..........: fut35183_4
** Alterado em...........: 12/03/2008 16:47:44
*****************************************************************************/
PROCEDURE pi_verificar_abat_antecip_voucher_pagto:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_estab
        as character
        format "x(3)"
        no-undo.
    def Input param p_cod_refer
        as character
        format "x(10)"
        no-undo.
    def Input param p_num_seq_refer
        as integer
        format ">>>9"
        no-undo.
    def Input param p_cod_portador
        as character
        format "x(5)"
        no-undo.
    def Input param p_num_bord_ap
        as integer
        format ">>>>>9"
        no-undo.
    def Input param p_ind_tip_abat
        as character
        format "X(08)"
        no-undo.
    def output param p_log_abat_antecip
        as logical
        format "Sim/N∆o"
        no-undo.
    def output param p_val_tot_abat_antecip
        as decimal
        format "->>,>>>,>>>,>>9.99"
        decimals 2
        no-undo.
    def output param p_val_tot_abat
        as decimal
        format "->>,>>>,>>>,>>9.99"
        decimals 2
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_cod_refer
        as character
        format "x(10)":U
        label "Referància"
        column-label "Referància"
        no-undo.


    /************************** Variable Definition End *************************/

    assign v_cod_refer = p_cod_refer.
    if  p_num_bord_ap <> 0
    and p_num_bord_ap <> ? then do:
        assign v_cod_refer = "".
    end. 

    antecipacoes:
    for
        each abat_antecip_vouch no-lock use-index abtntcpb_id
        where abat_antecip_vouch.cod_estab_refer = p_cod_estab
        and   abat_antecip_vouch.cod_refer       = v_cod_refer
        and   abat_antecip_vouch.num_seq_refer   = p_num_seq_refer
        and   abat_antecip_vouch.cod_portador    = p_cod_portador
        and   abat_antecip_vouch.num_bord_ap     = p_num_bord_ap:
        /* alteracoes sob demanda - atividade 195864*/
        assign p_log_abat_antecip     = yes
               p_val_tot_abat_antecip = p_val_tot_abat_antecip + abat_antecip_vouch.val_abtdo_antecip
               p_val_tot_abat         = p_val_tot_abat         + abat_antecip_vouch.val_abtdo_antecip_tit_abat.
    end.
END PROCEDURE. /* pi_verificar_abat_antecip_voucher_pagto */
/*****************************************************************************
** Procedure Interna.....: pi_corpo_cheq_ap_imprimir
** Descricao.............: pi_corpo_cheq_ap_imprimir
** Criado por............: Jober
** Criado em.............: 26/05/1998 10:40:05
** Alterado por..........: Jober
** Alterado em...........: 26/05/1998 10:47:59
*****************************************************************************/
PROCEDURE pi_corpo_cheq_ap_imprimir:

    /************************* Variable Definition Begin ************************/

    def var v_num_impr                       as integer         no-undo. /*local*/


    /************************** Variable Definition End *************************/

    /* Imprime item do bordero */
    assign v_num_aux           = v_num_aux + 1.

    if (line-counter(s_1) + 1) > v_rpt_s_1_bottom then
        page stream s_1.
    put stream s_1 unformatted 
        tt_cheq_adm_cancel.dat_emis_cheq_administ at 10 format "99/99/9999"
        tt_cheq_adm_cancel.nom_favorec_cheq at 29 format "x(40)"
        tt_cheq_adm_cancel.num_cheque to 89 format ">>>>,>>>,>>9"
        tt_cheq_adm_cancel.val_cheque to 110 format ">>>,>>>,>>9.99" skip.

    if  v_log_salta_lin = yes  then do:
        if (line-counter(s_1) + 1) > v_rpt_s_1_bottom then
            page stream s_1.
        put stream s_1 unformatted  skip (1).
    end.
    assign v_qtd_tot_tit_pag_bord = v_qtd_tot_tit_pag_bord + 1
           v_val_pag_bord         = v_val_pag_bord         + tt_cheq_adm_cancel.val_cheque
           v_val_liq_pag_bord     = v_val_liq_pag_bord     + tt_cheq_adm_cancel.val_cheque.

    /* Verifica e se necessario salta de p†gina */

    if  (line-counter(s_1) + 11) > v_rpt_s_1_bottom then do:
        assign v_qtd_tot_tit_bord = v_qtd_tot_tit_bord + v_qtd_tot_tit_pag_bord
               v_val_tot_bord     = v_val_tot_bord     + v_val_pag_bord
               v_val_liq_bord     = v_val_liq_bord     + v_val_liq_pag_bord.

        if (line-counter(s_1) + 5) > v_rpt_s_1_bottom then
            page stream s_1.
        put stream s_1 unformatted 
            "---------------------------------------------------------" at 1
            "---------------------------------------------------------" at 58 skip
            "Total da  Pagina:" at 1
            v_val_tot_bord to 37 format ">>,>>>,>>>,>>9.99" skip
            "Total Cheq. ADM:" at 2
            v_qtd_tot_tit_bord to 35 format ">>>9" skip
            "---------------------------------------------------------" at 1
            "---------------------------------------------------------" at 58 skip (1).

        if (line-counter(s_1) + 2) > v_rpt_s_1_bottom then
            page stream s_1.
        put stream s_1 unformatted 
            " Pag: " at 104
            v_num_pag to 113 format ">>>9" skip (1).
        page stream s_1.
        if  v_log_cabec_todas_pag = yes then
            run pi_cabec_bord_ap /*pi_cabec_bord_ap*/.
        assign v_num_pag              = v_num_pag + 1
               v_qtd_tot_tit_pag_bord = 0
               v_val_pag_bord         = 0
               v_val_liq_pag_bord     = 0
               v_val_pag_tot_impto    = 0.
    end.              

END PROCEDURE. /* pi_corpo_cheq_ap_imprimir */
/*****************************************************************************
** Procedure Interna.....: pi_tratar_tt_cheq_adm_cancel
** Descricao.............: pi_tratar_tt_cheq_adm_cancel
** Criado por............: Jober
** Criado em.............: 26/05/1998 09:19:41
** Alterado por..........: Jober
** Alterado em...........: 29/05/1998 16:48:15
*****************************************************************************/
PROCEDURE pi_tratar_tt_cheq_adm_cancel:

    assign v_val_total = 0
           v_val_liq_item_bord = 0
           v_log_erro_impr     = no.
    for each cheq_ap no-lock
     where cheq_ap.cod_estab_cheq = bord_ap.cod_estab_bord
       and cheq_ap.cod_portador   = bord_ap.cod_portador
       and cheq_ap.num_bord_ap    = bord_ap.num_bord_ap:
       create tt_cheq_adm_cancel.
    assign tt_cheq_adm_cancel.cod_estab_cheq            = cheq_ap.cod_estab_cheq
           tt_cheq_adm_cancel.cod_estab_refer           = cheq_ap.cod_estab_refer
           tt_cheq_adm_cancel.cod_portador              = cheq_ap.cod_portador
           tt_cheq_adm_cancel.cod_cart_bcia             = cheq_ap.cod_cart_bcia
           tt_cheq_adm_cancel.cod_finalid_econ          = cheq_ap.cod_finalid_econ
           tt_cheq_adm_cancel.nom_favorec_cheq          = cheq_ap.nom_favorec_cheq
           tt_cheq_adm_cancel.num_seq_cheq              = cheq_ap.num_seq_cheq
           tt_cheq_adm_cancel.dat_emis_cheq             = cheq_ap.dat_emis_cheq
           tt_cheq_adm_cancel.num_id_cheq_ap            = cheq_ap.num_id_cheq_ap.
    assign tt_cheq_adm_cancel.cod_empresa               = cheq_ap.cod_empresa
           tt_cheq_adm_cancel.cod_cta_corren            = cheq_ap.cod_cta_corren
           tt_cheq_adm_cancel.cod_banco                 = cheq_ap.cod_banco
           tt_cheq_adm_cancel.cod_agenc_bcia            = cheq_ap.cod_agenc_bcia
           tt_cheq_adm_cancel.cod_cta_corren_bco        = cheq_ap.cod_cta_corren_bco
           tt_cheq_adm_cancel.cod_estab_bord            = cheq_ap.cod_estab_bord
           tt_cheq_adm_cancel.cod_portad_bord           = cheq_ap.cod_portad_bord
           tt_cheq_adm_cancel.cod_usuar_emis_cheq       = cheq_ap.cod_usuar_emis_cheq
           tt_cheq_adm_cancel.cod_usuar_impres_cheq     = cheq_ap.cod_usuar_impres_cheq
           tt_cheq_adm_cancel.nom_usuar_termo_respde    = cheq_ap.nom_usuar_termo_respde
           tt_cheq_adm_cancel.val_cheque                = cheq_ap.val_cheque
           tt_cheq_adm_cancel.num_talon_cheq            = cheq_ap.num_talon_cheq
           tt_cheq_adm_cancel.num_cheque                = cheq_ap.num_cheque
           tt_cheq_adm_cancel.num_cop_cheq              = cheq_ap.num_cop_cheq
           tt_cheq_adm_cancel.num_bord_ap               = cheq_ap.num_bord_ap
           tt_cheq_adm_cancel.log_cheq_emitid           = cheq_ap.log_cheq_emitid
           tt_cheq_adm_cancel.log_cop_cheq_emitid       = cheq_ap.log_cop_cheq_emitid
           tt_cheq_adm_cancel.log_cheq_cancdo           = cheq_ap.log_cheq_cancdo
           tt_cheq_adm_cancel.log_cheq_confdo           = cheq_ap.log_cheq_confdo
           tt_cheq_adm_cancel.log_impres_cheq_sist      = cheq_ap.log_impres_cheq_sist
           tt_cheq_adm_cancel.log_cheq_administ         = cheq_ap.log_cheq_administ
           tt_cheq_adm_cancel.log_bord_ap_escrit        = cheq_ap.log_bord_ap_escrit
           tt_cheq_adm_cancel.hra_impres_cheq           = cheq_ap.hra_impres_cheq
           tt_cheq_adm_cancel.ind_sit_cheq_administ     = cheq_ap.ind_sit_cheq_administ
           tt_cheq_adm_cancel.ind_localiz_cheq_administ = cheq_ap.ind_localiz_cheq_administ
           tt_cheq_adm_cancel.ind_favorec_cheq          = cheq_ap.ind_favorec_cheq
           tt_cheq_adm_cancel.dat_impres_cheq           = cheq_ap.dat_impres_cheq
           tt_cheq_adm_cancel.dat_confir_cheq_ap        = cheq_ap.dat_confir_cheq_ap
           tt_cheq_adm_cancel.dat_emis_cheq_administ    = cheq_ap.dat_emis_cheq_administ
           tt_cheq_adm_cancel.dat_retir_cheq_administ   = cheq_ap.dat_retir_cheq_administ
           tt_cheq_adm_cancel.dat_cancel_cheq_administ  = cheq_ap.dat_cancel_cheq_administ
           tt_cheq_adm_cancel.dat_termo_respde_cheq     = cheq_ap.dat_termo_respde_cheq.

       assign v_val_liq_item_bord = v_val_liq_item_bord + cheq_ap.val_cheque.
    end.   
END PROCEDURE. /* pi_tratar_tt_cheq_adm_cancel */
/*****************************************************************************
** Procedure Interna.....: pi_rpt_cheq_adm_imprimir_cancel
** Descricao.............: pi_rpt_cheq_adm_imprimir_cancel
** Criado por............: Jober
** Criado em.............: 26/05/1998 08:28:10
** Alterado por..........: fut1228_4
** Alterado em...........: 19/03/2007 16:43:34
*****************************************************************************/
PROCEDURE pi_rpt_cheq_adm_imprimir_cancel:

    /************************* Variable Definition Begin ************************/

    def var v_ind_tip_relat_bord_apb
        as character
        format "X(08)":U
        no-undo.
    def var v_nom_aux                        as character       no-undo. /*local*/
    def var v_num_cont                       as integer         no-undo. /*local*/


    /************************** Variable Definition End *************************/

    assign v_num_pag = 1.
    do:
        /* seta a saida da impressao */
        case v_ind_dest_bord_ap:
            when "Terminal" /*l_terminal*/  then do:
                assign v_cod_dwb_file   = session:temp-directory + substring ("prgfin/apb/apb742zb.py", 12, 6) + '.tmp'.
                output stream s_1 to value(v_cod_dwb_file) paged page-size value(v_rpt_s_1_lines) convert target 'iso8859-1'.
            end.
            when "Impressora" /*l_printer*/  then do:
                find imprsor_usuar no-lock
                     where imprsor_usuar.nom_impressora = v_nom_dwb_printer
                      and  imprsor_usuar.cod_usuario    = v_cod_dwb_user
                     use-index imprsrsr_id no-error.
                find impressora no-lock
                     where impressora.nom_impressora = imprsor_usuar.nom_impressora
                     no-error.
                find tip_imprsor no-lock
                     where tip_imprsor.cod_tip_imprsor = impressora.cod_tip_imprsor
                     no-error.
                find layout_impres no-lock
                     where layout_impres.nom_impressora    = v_nom_dwb_printer
                       and layout_impres.cod_layout_impres = v_cod_dwb_print_layout
                     no-error.
                assign v_rpt_s_1_bottom = layout_impres.num_lin_pag /* + v_rpt_s_1_bottom - v_rpt_s_1_lines */
                       v_rpt_s_1_lines = layout_impres.num_lin_pag.
                output stream s_1 to value(imprsor_usuar.nom_disposit_so)
                       paged page-size value(v_rpt_s_1_lines) convert target tip_imprsor.cod_pag_carac_conver.

                for each configur_layout_impres no-lock
                    where configur_layout_impres.num_id_layout_impres = layout_impres.num_id_layout_impres
                    by configur_layout_impres.num_ord_funcao_imprsor:

                    find configur_tip_imprsor no-lock
                        where configur_tip_imprsor.cod_tip_imprsor        = layout_impres.cod_tip_imprsor
                        and   configur_tip_imprsor.cod_funcao_imprsor     = configur_layout_impres.cod_funcao_imprsor
                        and   configur_tip_imprsor.cod_opc_funcao_imprsor = configur_layout_impres.cod_opc_funcao_imprsor
                        no-error.
                    bloco_1:
                    do
                         v_num_count = 1 to extent(configur_tip_imprsor.num_carac_configur):
                         /* configur_tip_imprsor: */
                         case configur_tip_imprsor.num_carac_configur[v_num_count]:
                               when 0 then put  stream s_1 control null.
                               when ? then leave.
                               otherwise 
                                   /* Convers∆o interna do OUTPUT TARGET */
                                   put stream s_1 control codepage-convert ( chr(configur_tip_imprsor.num_carac_configur[v_num_count]),
                                                                           session:cpinternal,
                                                                           tip_imprsor.cod_pag_carac_conver).
                         end /* case configur_tip_imprsor */.
                    end /* do bloco_1 */.
                end.
            end.
            when "Arquivo" /*l_file*/  then do:
                assign v_cod_dwb_file   = v_nom_arq_bord_ap.
                output stream s_1 to value(v_cod_dwb_file)
                       paged page-size value(v_rpt_s_1_lines) convert target 'iso8859-1'.

            end.
        end.

        find bord_ap where recid(bord_ap) = v_rec_bord_ap exclusive-lock no-error.

        for each tt_cheq_adm_cancel:
            delete tt_cheq_adm_cancel.
        end.

       /* Gera temp-table para impressao */
        run pi_tratar_tt_cheq_adm_cancel /*pi_tratar_tt_cheq_adm_cancel*/.

        /* Cabecalho do Bordero */   
        find estabelecimento no-lock
            where estabelecimento.cod_estab = bord_ap.cod_estab_bord no-error.
        find pessoa_jurid no-lock
            where pessoa_jurid.num_pessoa_jurid = estabelecimento.num_pessoa_jurid no-error.

        assign v_nom_pessoa_jur        = pessoa_jurid.nom_pessoa
               v_nom_endereco          = pessoa_jurid.nom_endereco
               v_nom_cidade_jur        = pessoa_jurid.nom_cidade
               v_cod_unid_federac      = pessoa_jurid.cod_unid_federac.

        &if defined(BF_FIN_4LINHAS_END) &then
            cont_block:
            REPEAT v_num_cont_entry = 1 TO NUM-ENTRIES(pessoa_jurid.nom_ender_text, chr(10)):
                if  v_num_cont_entry = 1 then assign v_nom_ender_lin_1 = entry( 1, pessoa_jurid.nom_ender_text, chr(10)).
                if  v_num_cont_entry = 2 then assign v_nom_ender_lin_2 = entry( 2, pessoa_jurid.nom_ender_text, chr(10)).
                if  v_num_cont_entry = 3 then assign v_nom_ender_lin_3 = entry( 3, pessoa_jurid.nom_ender_text, chr(10)).
                if  v_num_cont_entry = 4 then assign v_nom_ender_lin_4 = entry( 4, pessoa_jurid.nom_ender_text, chr(10)).
                if  v_num_cont_entry = 4 then
                    leave cont_block.
            END.
        &endif

        if  bord_ap.ind_sit_bord_ap = "Em Digitaá∆o" /*l_em_digitacao*/ 
        then do:    
            if  v_log_erro_impr = no
            then do:
                assign bord_ap.ind_sit_bord_ap = "Ja Impresso" /*l_ja_impresso*/ 
                       v_ind_sit_bord_impr     = "Ja Impresso" /*l_ja_impresso*/ .
            end /* if */.
            else do:
                assign v_ind_sit_bord_impr     = "Erro" /*l_erro*/  + "Erro" /*l_erro*/  + "Erro" /*l_erro*/  + "Erro" /*l_erro*/  + "Erro" /*l_erro*/ .        
            end /* else */.
        end /* if */.

        find emscad.pais no-lock
            where pais.cod_pais = estabelecimento.cod_pais no-error.
        find portad_finalid_econ no-lock
            where portad_finalid_econ.cod_estab        = bord_ap.cod_estab_bord
            and   portad_finalid_econ.cod_portador     = bord_ap.cod_portador
            and   portad_finalid_econ.cod_cart_bcia    = bord_ap.cod_cart_bcia
            and   portad_finalid_econ.cod_finalid_econ = bord_ap.cod_finalid_econ no-error.
        find cta_corren no-lock
            where cta_corren.cod_cta_corren = portad_finalid_econ.cod_cta_corren no-error.
        find agenc_bcia no-lock
            where agenc_bcia.cod_banco      = cta_corren.cod_banco
            and   agenc_bcia.cod_agenc_bcia = cta_corren.cod_agenc_bcia no-error.
        find emscad.banco no-lock
            where banco.cod_banco = cta_corren.cod_banco no-error.
        find msg_financ no-lock
            where msg_financ.cod_mensagem = bord_ap.cod_msg_inic
            and   msg_financ.cod_estab    = bord_ap.cod_estab_bord
            and   msg_financ.cod_empresa  = bord_ap.cod_empresa no-error.

        if  avail msg_financ then
            assign v_des_msg_inic_bord_apb = replace(msg_financ.des_mensagem, chr(13), chr(10)).
        else
            assign v_des_msg_inic_bord_apb = "".

        assign v_nom_aux = pais.nom_label_id_feder_jurid.
        repeat v_num_aux = length(pais.nom_label_id_feder_jurid) to 19:
            assign v_nom_aux = v_nom_aux + ".".
        end.
        assign v_nom_label_id_feder = v_nom_aux + ":"
               v_cod_id_feder       = string(pessoa_jurid.cod_id_feder, pais.cod_format_id_feder_jurid)
               v_cod_cep            = string(pessoa_jurid.cod_cep, pais.cod_format_cep).

        find first emscad.empresa no-lock
            where empresa.cod_empresa = bord_ap.cod_empresa 
            no-error. 

        if  bord_ap.log_bord_ap_escrit = no then do:
            assign v_ind_tip_relat_bord_apb = "Cancelamento" /*l_cancelamento*/ .
            if  v_log_impr_sit = no then do:
                /* A variavel v_ind_ender_complet Ç utilizada para a funcao "BF_FIN_4LINHAS_END"
                   Sempre que a funá∆o n∆o estiver sendo utilizada, o valor ser† "Endereáo"      */
                if  v_ind_ender_complet = "Endereáo" /*l_endereco*/ 
                then do:
                    /* Imprimi cabeáario com o Endereáo Normal */
                    if (line-counter(s_1) + 9) > v_rpt_s_1_bottom then
                        page stream s_1.
                    put stream s_1 unformatted 
                        "EMPRESA.............:" at 1
                        v_nom_pessoa_jur at 23 format "x(40)" skip
                        "ENDEREÄO............:" at 1
                        v_nom_endereco at 23 format "x(40)" skip
                        "CIDADE..............:" at 1
                        v_nom_cidade_jur at 23 format "x(32)"
                        "-" at 56
                        v_cod_unid_federac at 58 format "x(3)"
                        "-" at 62
                        v_cod_cep at 64 format "x(20)" skip
                        v_nom_label_id_feder at 1 format "x(21)"
                        v_cod_id_feder at 23 format "x(20)" skip
                        "BANCO...............:" at 1
                        banco.nom_banco at 23 format "x(30)" skip
                        "AG“NCIA.............:" at 1
                        v_des_agenc_bcia_portad at 23 format "x(50)" skip
                        "C. CORRENTE.........:" at 1
                        v_des_cta_corren_portad at 23 format "x(25)" skip
                        "BORDER‚.............:" at 1
                        bord_ap.num_bord_ap to 28 format ">>>>>9" skip
                        "DATA EMISS«O........:" at 1
                        bord_ap.dat_transacao at 23 format "99/99/9999" skip.
                end /* if */.
                else do:
                    /* Imprimi cabeáario com o Endereáo Completo, com as 4 Linhas "BF_FIN_4LINHAS_END" */
                    if (line-counter(s_1) + 9) > v_rpt_s_1_bottom then
                        page stream s_1.
                    put stream s_1 unformatted 
                        "EMPRESA.............:" at 1
                        v_nom_pessoa_jur at 23 format "x(40)" skip
                        "ENDEREÄO............:" at 1
                        v_nom_endereco at 23 format "x(40)" skip
                        "CIDADE..............:" at 1
                        v_nom_cidade_jur at 23 format "x(32)"
                        "-" at 56
                        v_cod_unid_federac at 58 format "x(3)"
                        "-" at 62
                        v_cod_cep at 64 format "x(20)" skip
                        v_nom_label_id_feder at 1 format "x(21)"
                        v_cod_id_feder at 23 format "x(20)" skip
                        "BANCO...............:" at 1
                        banco.nom_banco at 23 format "x(30)" skip
                        "AG“NCIA.............:" at 1
                        v_des_agenc_bcia_portad at 23 format "x(50)" skip
                        "C. CORRENTE.........:" at 1
                        v_des_cta_corren_portad at 23 format "x(25)" skip
                        "BORDER‚.............:" at 1
                        bord_ap.num_bord_ap to 28 format ">>>>>9" skip
                        "DATA EMISS«O........:" at 1
                        bord_ap.dat_transacao at 23 format "99/99/9999" skip.
                end /* else */.
            end.
            else do:
                /* A variavel v_ind_ender_complet Ç utilizada para a funcao "BF_FIN_4LINHAS_END"
                   Sempre que a funá∆o n∆o estiver sendo utilizada, o valor ser† "Endereáo"      */
                if  v_ind_ender_complet = "Endereáo" /*l_endereco*/ 
                then do:
                    /* Imprimi cabeáario com o Endereáo Normal */
                    if (line-counter(s_1) + 9) > v_rpt_s_1_bottom then
                        page stream s_1.
                    put stream s_1 unformatted 
                        "EMPRESA.............:" at 1
                        v_nom_pessoa_jur at 23 format "x(40)" skip
                        "ENDEREÄO............:" at 1
                        v_nom_endereco at 23 format "x(40)" skip
                        "CIDADE..............:" at 1
                        v_nom_cidade_jur at 23 format "x(32)"
                        "-" at 56
                        v_cod_unid_federac at 58 format "x(3)"
                        "-" at 62
                        v_cod_cep at 64 format "x(20)" skip
                        v_nom_label_id_feder at 1 format "x(21)"
                        v_cod_id_feder at 23 format "x(20)" skip
                        "BANCO...............:" at 1
                        banco.nom_banco at 23 format "x(30)" skip
                        "AG“NCIA.............:" at 1
                        v_des_agenc_bcia_portad at 23 format "x(50)" skip
                        "C. CORRENTE.........:" at 1
                        v_des_cta_corren_portad at 23 format "x(25)" skip
                        "BORDER‚.............:" at 1
                        bord_ap.num_bord_ap to 28 format ">>>>>9"
                        "SITUAÄ«O............:" at 31
                        v_ind_sit_bord_impr at 53 format "X(20)" skip
                        "DATA EMISS«O........:" at 1
                        bord_ap.dat_transacao at 23 format "99/99/9999" skip.
                end /* if */.
                else do:
                    /* Imprimi cabeáario com o Endereáo Completo, com as 4 Linhas "BF_FIN_4LINHAS_END" */
                    if (line-counter(s_1) + 9) > v_rpt_s_1_bottom then
                        page stream s_1.
                    put stream s_1 unformatted 
                        "EMPRESA.............:" at 1
                        v_nom_pessoa_jur at 23 format "x(40)" skip
                        "ENDEREÄO............:" at 1
                        v_nom_endereco at 23 format "x(40)" skip
                        "CIDADE..............:" at 1
                        v_nom_cidade_jur at 23 format "x(32)"
                        "-" at 56
                        v_cod_unid_federac at 58 format "x(3)"
                        "-" at 62
                        v_cod_cep at 64 format "x(20)" skip
                        v_nom_label_id_feder at 1 format "x(21)"
                        v_cod_id_feder at 23 format "x(20)" skip
                        "BANCO...............:" at 1
                        banco.nom_banco at 23 format "x(30)" skip
                        "AG“NCIA.............:" at 1
                        v_des_agenc_bcia_portad at 23 format "x(50)" skip
                        "C. CORRENTE.........:" at 1
                        v_des_cta_corren_portad at 23 format "x(25)" skip
                        "BORDER‚.............:" at 1
                        bord_ap.num_bord_ap to 28 format ">>>>>9"
                        "SITUAÄ«O............:" at 31
                        v_ind_sit_bord_impr at 53 format "X(20)" skip
                        "DATA EMISS«O........:" at 1
                        bord_ap.dat_transacao at 23 format "99/99/9999" skip.
                end /* else */.
            end.
        end.
        else do:
            assign v_ind_tip_relat_bord_apb = "Escritural" /*l_escritural*/ .
            if  v_log_impr_sit = no then do:
                /* A variavel v_ind_ender_complet Ç utilizada para a funcao "BF_FIN_4LINHAS_END"
                   Sempre que a funá∆o n∆o estiver sendo utilizada, o valor ser† "Endereáo"      */
                if  v_ind_ender_complet = "Endereáo" /*l_endereco*/ 
                then do:
                    /* Imprimi cabeáario com o Endereáo Normal */
                    if (line-counter(s_1) + 9) > v_rpt_s_1_bottom then
                        page stream s_1.
                    put stream s_1 unformatted 
                        "EMPRESA.............:" at 1
                        v_nom_pessoa_jur at 23 format "x(40)" skip
                        "ENDEREÄO............:" at 1
                        v_nom_endereco at 23 format "x(40)" skip
                        "CIDADE..............:" at 1
                        v_nom_cidade_jur at 23 format "x(32)"
                        "-" at 56
                        v_cod_unid_federac at 58 format "x(3)"
                        "-" at 62
                        v_cod_cep at 64 format "x(20)" skip
                        v_nom_label_id_feder at 1 format "x(21)"
                        v_cod_id_feder at 23 format "x(20)" skip
                        "BANCO...............:" at 1
                        banco.nom_banco at 23 format "x(30)"
                        "*********************" at 94 skip
                        "AG“NCIA.............:" at 1
                        v_des_agenc_bcia_portad at 23 format "x(50)"
                        "*" at 94
                        "  BORDER‚  " at 99
                        "*" at 114 skip
                        "C. CORRENTE.........:" at 1
                        v_des_cta_corren_portad at 23 format "x(25)"
                        "*" at 94
                        " ESCRITURAL  " at 99
                        "*" at 114 skip
                        "BORDER‚.............:" at 1
                        bord_ap.num_bord_ap to 28 format ">>>>>9"
                        "*********************" at 94 skip
                        "DATA EMISS«O........:" at 1
                        bord_ap.dat_transacao at 23 format "99/99/9999" skip.
                end /* if */.
                else do:
                    /* Imprimi cabeáario com o Endereáo Completo, com as 4 Linhas "BF_FIN_4LINHAS_END" */
                    if (line-counter(s_1) + 9) > v_rpt_s_1_bottom then
                        page stream s_1.
                    put stream s_1 unformatted 
                        "EMPRESA.............:" at 1
                        v_nom_pessoa_jur at 23 format "x(40)" skip
                        "ENDEREÄO............:" at 1
                        v_nom_endereco at 23 format "x(40)" skip
                        "CIDADE..............:" at 1
                        v_nom_cidade_jur at 23 format "x(32)"
                        "-" at 56
                        v_cod_unid_federac at 58 format "x(3)"
                        "-" at 62
                        v_cod_cep at 64 format "x(20)" skip
                        v_nom_label_id_feder at 1 format "x(21)"
                        v_cod_id_feder at 23 format "x(20)" skip
                        "BANCO...............:" at 1
                        banco.nom_banco at 23 format "x(30)"
                        "*********************" at 94 skip
                        "AG“NCIA.............:" at 1
                        v_des_agenc_bcia_portad at 23 format "x(50)"
                        "*" at 94
                        "  BORDER‚  " at 99
                        "*" at 114 skip
                        "C. CORRENTE.........:" at 1
                        v_des_cta_corren_portad at 23 format "x(25)"
                        "*" at 94
                        " ESCRITURAL  " at 99
                        "*" at 114 skip
                        "BORDER‚.............:" at 1
                        bord_ap.num_bord_ap to 28 format ">>>>>9"
                        "*********************" at 94 skip
                        "DATA EMISS«O........:" at 1
                        bord_ap.dat_transacao at 23 format "99/99/9999" skip.
                end /* else */.
            end.
            else do:
                /* A variavel v_ind_ender_complet Ç utilizada para a funcao "BF_FIN_4LINHAS_END"
                   Sempre que a funá∆o n∆o estiver sendo utilizada, o valor ser† "Endereáo"      */
                if  v_ind_ender_complet = "Endereáo" /*l_endereco*/ 
                then do:
                    /* Imprimi cabeáario com o Endereáo Normal */
                    if (line-counter(s_1) + 9) > v_rpt_s_1_bottom then
                        page stream s_1.
                    put stream s_1 unformatted 
                        "EMPRESA.............:" at 1
                        v_nom_pessoa_jur at 23 format "x(40)" skip
                        "ENDEREÄO............:" at 1
                        v_nom_endereco at 23 format "x(40)" skip
                        "CIDADE..............:" at 1
                        v_nom_cidade_jur at 23 format "x(32)"
                        "-" at 56
                        v_cod_unid_federac at 58 format "x(3)"
                        "-" at 62
                        v_cod_cep at 64 format "x(20)" skip
                        v_nom_label_id_feder at 1 format "x(21)"
                        v_cod_id_feder at 23 format "x(20)" skip
                        "BANCO...............:" at 1
                        banco.nom_banco at 23 format "x(30)"
                        "*********************" at 94 skip
                        "AG“NCIA.............:" at 1
                        v_des_agenc_bcia_portad at 23 format "x(50)"
                        "*" at 94
                        "  BORDER‚  " at 99
                        "*" at 114 skip
                        "C. CORRENTE.........:" at 1
                        v_des_cta_corren_portad at 23 format "x(25)"
                        "*" at 94
                        " ESCRITURAL  " at 99
                        "*" at 114 skip
                        "BORDER‚.............:" at 1
                        bord_ap.num_bord_ap to 28 format ">>>>>9"
                        "SITUAÄ«O............:" at 31
                        v_ind_sit_bord_impr at 53 format "X(20)"
                        "*********************" at 94 skip
                        "DATA EMISS«O........:" at 1
                        bord_ap.dat_transacao at 23 format "99/99/9999" skip.
                end /* if */.
                else do:
                    /* Imprimi cabeáario com o Endereáo Completo, com as 4 Linhas "BF_FIN_4LINHAS_END" */
                    if (line-counter(s_1) + 9) > v_rpt_s_1_bottom then
                        page stream s_1.
                    put stream s_1 unformatted 
                        "EMPRESA.............:" at 1
                        v_nom_pessoa_jur at 23 format "x(40)" skip
                        "ENDEREÄO............:" at 1
                        v_nom_endereco at 23 format "x(40)" skip
                        "CIDADE..............:" at 1
                        v_nom_cidade_jur at 23 format "x(32)"
                        "-" at 56
                        v_cod_unid_federac at 58 format "x(3)"
                        "-" at 62
                        v_cod_cep at 64 format "x(20)" skip
                        v_nom_label_id_feder at 1 format "x(21)"
                        v_cod_id_feder at 23 format "x(20)" skip
                        "BANCO...............:" at 1
                        banco.nom_banco at 23 format "x(30)"
                        "*********************" at 94 skip
                        "AG“NCIA.............:" at 1
                        v_des_agenc_bcia_portad at 23 format "x(50)"
                        "*" at 94
                        "  BORDER‚  " at 99
                        "*" at 114 skip
                        "C. CORRENTE.........:" at 1
                        v_des_cta_corren_portad at 23 format "x(25)"
                        "*" at 94
                        " ESCRITURAL  " at 99
                        "*" at 114 skip
                        "BORDER‚.............:" at 1
                        bord_ap.num_bord_ap to 28 format ">>>>>9"
                        "SITUAÄ«O............:" at 31
                        v_ind_sit_bord_impr at 53 format "X(20)"
                        "*********************" at 94 skip
                        "DATA EMISS«O........:" at 1
                        bord_ap.dat_transacao at 23 format "99/99/9999" skip.
                end /* else */.
            end.
        end.

        run pi_imprime_complemento_cabec_bordero (Input v_ind_tip_relat_bord_apb,
                                                  Input v_des_msg_inic_bord_apb) /*pi_imprime_complemento_cabec_bordero*/.

        if (line-counter(s_1) + 1) > v_rpt_s_1_bottom then
            page stream s_1.
        put stream s_1 unformatted 
            "---------------------------------------------------------" at 1
            "---------------------------------------------------------" at 58 skip.
        if (line-counter(s_1) + 3) > v_rpt_s_1_bottom then
            page stream s_1.
        put stream s_1 unformatted 
            "Emis Ch Adm" at 10
            "Favorec" at 29
            "Num Cheque" to 89
            "Vl Cheque" to 110 skip
            "-----------" at 10
            "----------------------------------------" at 29
            "------------" to 89
            "--------------" to 110 skip.

        assign v_num_aux = 0.

        /* Imprime itens do Borderì de acordo com classificacao */
        case v_ind_classif_bord :
            when "Por Favorecido" /*l_por_favorecido*/  then
                for each tt_cheq_adm_cancel no-lock
                    by tt_cheq_adm_cancel.nom_favorec_cheq:
                    run pi_corpo_cheq_ap_imprimir /*pi_corpo_cheq_ap_imprimir*/.
                end.
            when "Por Data Emiss∆o" /*l_por_data_emissao*/  then
                for each tt_cheq_adm_cancel no-lock
                    by tt_cheq_adm_cancel.dat_emis_cheq_administ:
                    run pi_corpo_cheq_ap_imprimir /*pi_corpo_cheq_ap_imprimir*/.
                end.
        end.
        /* Verifica se ultima pagina possui titulos e imprime total da pagina */
        if  v_qtd_tot_tit_pag_bord <> 0 then do:
            assign v_qtd_tot_tit_bord = v_qtd_tot_tit_bord + v_qtd_tot_tit_pag_bord
                   v_val_tot_bord     = v_val_tot_bord     + v_val_pag_bord
                   v_val_liq_bord     = v_val_liq_bord     + v_val_liq_pag_bord.
            if (line-counter(s_1) + 5) > v_rpt_s_1_bottom then
                page stream s_1.
            put stream s_1 unformatted 
                "---------------------------------------------------------" at 1
                "---------------------------------------------------------" at 58 skip
                "Total da  Pagina:" at 1
                v_val_tot_bord to 37 format ">>,>>>,>>>,>>9.99" skip
                "Total Cheq. ADM:" at 2
                v_qtd_tot_tit_bord to 35 format ">>>9" skip
                "---------------------------------------------------------" at 1
                "---------------------------------------------------------" at 58 skip (1).
        end.              

        /* Imprime Total do Bordero */  
        if  v_log_impr_tot_bord_assin
        then do:
            run pi_retorna_total_lin_msg_encerramento (Input bord_ap.cod_empresa,
                                                       Input bord_ap.cod_estab_bord,
                                                       Input bord_ap.cod_msg_fim,
                                                       output v_num_cont) /*pi_retorna_total_lin_msg_encerramento*/.
            /* Soma o total de linhas que retornou da pi, com o total de linhas do "Total do BorderÀ" com o "Total Extenso Bordero "*/
            assign v_num_cont = v_num_cont + 16.
            if  (line-counter(s_1) + v_num_cont) > v_rpt_s_1_bottom
            then do:
                put stream s_1 unformatted 
                    ' Pag: ' at 104
                    v_num_pag to 113 format ">>>9" skip (1).
                page stream s_1.
                if  v_log_cabec_todas_pag = yes then
                    run pi_cabec_bord_ap /*pi_cabec_bord_ap*/.
                assign v_num_pag = v_num_pag + 1.                        
            end /* if */.
        end /* if */.
        else do:
            if  (line-counter(s_1) + 6) > v_rpt_s_1_bottom
            then do:
                if (line-counter(s_1) + 2) > v_rpt_s_1_bottom then
                    page stream s_1.
                put stream s_1 unformatted 
                    " Pag: " at 104
                    v_num_pag to 113 format ">>>9" skip (1).
                page stream s_1.
                if  v_log_cabec_todas_pag = yes then
                    run pi_cabec_bord_ap /*pi_cabec_bord_ap*/.
                assign v_num_pag = v_num_pag + 1.
            end /* if */.
        end /* else */.

        if (line-counter(s_1) + 5) > v_rpt_s_1_bottom then
            page stream s_1.
        put stream s_1 unformatted 
            "---------------------------------------------------------" at 1
            "---------------------------------------------------------" at 58 skip
            "Total do Bordero:" at 1
            v_val_tot_bord to 37 format ">>,>>>,>>>,>>9.99" skip
            "Total Cheq. ADM:" at 2
            v_qtd_tot_tit_bord to 35 format ">>>9" skip
            "---------------------------------------------------------" at 1
            "---------------------------------------------------------" at 58 skip (1).

        /* Imprime Total Extenso Bordero */
        if  (line-counter(s_1) + 6) > v_rpt_s_1_bottom then do:
            do  v_num_impr =  line-counter(s_1) to ( v_rpt_s_1_bottom - 2 ):
                if (line-counter(s_1) + 1) > v_rpt_s_1_bottom then
                    page stream s_1.
                put stream s_1 unformatted  skip (1).
            end.
            if (line-counter(s_1) + 2) > v_rpt_s_1_bottom then
                page stream s_1.
            put stream s_1 unformatted 
                " Pag: " at 104
                v_num_pag to 113 format ">>>9" skip (1).
            page stream s_1.
            if  v_log_cabec_todas_pag = yes then
                run pi_cabec_bord_ap /*pi_cabec_bord_ap*/.
            assign v_num_pag = v_num_pag + 1.
        end.

        find first idiom_pais no-lock
            where idiom_pais.cod_pais        = pais.cod_pais
            and   idiom_pais.log_idiom_princ = yes no-error.
        run prgint/utb/utb900za.py (Input v_val_liq_bord,
                                    Input 2,
                                    Input 80,
                                    Input idiom_pais.cod_idioma,
                                    Input bord_ap.cod_indic_econ,
                                    output v_cod_return) /*prg_fnc_conv_val_extenso*/.

        assign v_des_extenso_bord [1] = ""
               v_des_extenso_bord [2] = "".

        for each tt_val_extenso no-lock:
            if  v_des_extenso_bord [1] = "" then
                assign v_des_extenso_bord [1] = tt_val_extenso.ttv_des_val_extenso.
            else
                assign v_des_extenso_bord [2] = tt_val_extenso.ttv_des_val_extenso.
        end.

        if (line-counter(s_1) + 5) > v_rpt_s_1_bottom then
            page stream s_1.
        put stream s_1 unformatted 
            "---------------------------------------------------------" at 4
            "-------------------" at 61
            "-------------------" at 80
            "---------" at 99
            "----" at 108 skip
            "|" at 4
            "Total do Borderì..: " at 6
            v_des_extenso_bord[1] at 26 format "x(80)"
            "|" at 111 skip
            "|" at 4
            v_des_extenso_bord[2] at 26 format "x(80)"
            "|" at 111 skip
            "---------------------------------------------------------" at 4
            "-------------------" at 61
            "-------------------" at 80
            "---------" at 99
            "----" at 108 skip (1).

        /* Mensagem de Fim do Bordero */

        if  (line-counter(s_1) + 10) > v_rpt_s_1_bottom then do:
            if (line-counter(s_1) + 2) > v_rpt_s_1_bottom then
                page stream s_1.
            put stream s_1 unformatted 
                " Pag: " at 104
                v_num_pag to 113 format ">>>9" skip (1).
            page stream s_1.
            if  v_log_cabec_todas_pag = yes then
                run pi_cabec_bord_ap /*pi_cabec_bord_ap*/.
            assign v_num_pag = v_num_pag + 1.
        end.

        find msg_financ no-lock
             where msg_financ.cod_empresa  = bord_ap.cod_empresa
             and   msg_financ.cod_estab    = bord_ap.cod_estab_bord
             and   msg_financ.cod_mensagem = bord_ap.cod_msg_fim no-error.

        if  avail msg_financ then
            assign v_des_msg_fim_bord_apb = replace(msg_financ.des_mensagem, chr(13), chr(10)).
        else
            assign v_des_msg_fim_bord_apb = "".

        repeat:
            if v_des_msg_fim_bord_apb = "" then leave.

            if  index(v_des_msg_fim_bord_apb, chr(10)) > 0
            then do:
                assign v_des_msg_lin_bord_apb = substring(v_des_msg_fim_bord_apb, 1, index(v_des_msg_fim_bord_apb,chr(10)) - 1 )
                       v_des_msg_fim_bord_apb     = substring(v_des_msg_fim_bord_apb, index(v_des_msg_fim_bord_apb,chr(10)) + 1).
            end /* if */.
            else do:
                assign v_des_msg_lin_bord_apb = v_des_msg_fim_bord_apb
                       v_des_msg_fim_bord_apb     = "".
            end /* else */.

            assign v_des_msg_lin_bord_apb_aux = substring(v_des_msg_lin_bord_apb, 1, 80).
            if (line-counter(s_1) + 1) > v_rpt_s_1_bottom then
                page stream s_1.
            put stream s_1 unformatted 
                v_des_msg_lin_bord_apb_aux at 17 format "x(80)" skip.                
            if  length(v_des_msg_lin_bord_apb) > 80
            then do:
                assign v_des_msg_lin_bord_apb = substring(v_des_msg_lin_bord_apb, 81).
                repeat:
                    if v_des_msg_lin_bord_apb = "" then leave.

                    if  length(v_des_msg_lin_bord_apb) > 95
                    then do:
                        assign v_des_msg_lin_compl_bord_apb = trim(substring(v_des_msg_lin_bord_apb, 1, 94))
                               v_des_msg_lin_bord_apb = substring(v_des_msg_lin_bord_apb, 95).
                    end /* if */.
                    else do:
                        assign v_des_msg_lin_compl_bord_apb = trim(v_des_msg_lin_bord_apb)
                               v_des_msg_lin_bord_apb = "".
                    end /* else */.
                    if (line-counter(s_1) + 1) > v_rpt_s_1_bottom then
                        page stream s_1.
                    put stream s_1 unformatted 
                        v_des_msg_lin_compl_bord_apb at 3 format "x(94)" skip.
                end.
            end /* if */.
        end.
        if (line-counter(s_1) + 3) > v_rpt_s_1_bottom then
            page stream s_1.
        put stream s_1 unformatted 
            skip (2)
            "-------------------" at 29
            "-------------------" at 48
            "-------------------" at 67 skip.
        if (line-counter(s_1) + 2) > v_rpt_s_1_bottom then
            page stream s_1.
        put stream s_1 unformatted 
            " Pag: " at 104
            v_num_pag to 113 format ">>>9" skip (1).

        output stream s_1 close.
    end.

END PROCEDURE. /* pi_rpt_cheq_adm_imprimir_cancel */
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
** Procedure Interna.....: pi_gerar_tt_cabec_bordero
** Descricao.............: pi_gerar_tt_cabec_bordero
** Criado por............: jober
** Criado em.............: 14/09/1998 11:14:22
** Alterado por..........: fut1309
** Alterado em...........: 02/08/2005 10:15:44
*****************************************************************************/
PROCEDURE pi_gerar_tt_cabec_bordero:

    /************************* Variable Definition Begin ************************/

    def var v_des_cta_corren_portad
        as character
        format "x(25)":U
        no-undo.
    def var v_nom_aux                        as character       no-undo. /*local*/
    def var v_num_aux                        as integer         no-undo. /*local*/


    /************************** Variable Definition End *************************/

    create tt_cabec_bordero.
    find emscad.empresa
        where empresa.cod_empresa = bord_ap.cod_empresa
        no-lock no-error.
    assign tt_cabec_bordero.ttv_dat_transacao    = bord_ap.dat_transacao
           tt_cabec_bordero.ttv_num_bord_ap      = bord_ap.num_bord_ap       
           tt_cabec_bordero.ttv_cod_indic_econ   = bord_ap.cod_indic_econ
           tt_cabec_bordero.ttv_nom_razao_social = empresa.nom_razao_social. 
    find estabelecimento no-lock
        where estabelecimento.cod_estab = bord_ap.cod_estab_bord no-error.
    find pessoa_jurid no-lock
        where pessoa_jurid.num_pessoa_jurid = estabelecimento.num_pessoa_jurid no-error.
    assign tt_cabec_bordero.ttv_nom_pessoa_jur        = pessoa_jurid.nom_pessoa
           tt_cabec_bordero.ttv_nom_endereco          = pessoa_jurid.nom_endereco
           tt_cabec_bordero.ttv_nom_cidade_jur        = pessoa_jurid.nom_cidade
           tt_cabec_bordero.ttv_cod_unid_federac      = pessoa_jurid.cod_unid_federac.              

    if bord_ap.ind_sit_bord_ap = "Em Digitaá∆o" /*l_em_digitacao*/  then do:
        if v_log_erro_impr = no then
            assign bord_ap.ind_sit_bord_ap                = "Ja Impresso" /*l_ja_impresso*/ 
                   tt_cabec_bordero.ttv_ind_sit_bord_impr = "Ja Impresso" /*l_ja_impresso*/ .
        else
            assign tt_cabec_bordero.ttv_ind_sit_bord_impr = "Erro" /*l_erro*/  + "Erro" /*l_erro*/  + "Erro" /*l_erro*/  + "Erro" /*l_erro*/  + "Erro" /*l_erro*/ . 
    end.

    find emscad.pais no-lock
        where pais.cod_pais = estabelecimento.cod_pais no-error.
    assign tt_cabec_bordero.ttv_cod_pais = pais.cod_pais.    
    find portad_finalid_econ no-lock
        where portad_finalid_econ.cod_estab        = bord_ap.cod_estab_bord
        and   portad_finalid_econ.cod_portador     = bord_ap.cod_portador
        and   portad_finalid_econ.cod_cart_bcia    = bord_ap.cod_cart_bcia
        and   portad_finalid_econ.cod_finalid_econ = bord_ap.cod_finalid_econ no-error.
    find cta_corren no-lock
        where cta_corren.cod_cta_corren = portad_finalid_econ.cod_cta_corren no-error.
    assign tt_cabec_bordero.ttv_des_cta_corren_portad = cta_corren.cod_cta_corren_bco + " - " + cta_corren.cod_digito_cta_corren.
    find agenc_bcia no-lock
        where agenc_bcia.cod_banco      = cta_corren.cod_banco
        and   agenc_bcia.cod_agenc_bcia = cta_corren.cod_agenc_bcia no-error.
    find emscad.banco no-lock
        where banco.cod_banco = cta_corren.cod_banco no-error.
    assign tt_cabec_bordero.ttv_des_agenc_bcia_portad = agenc_bcia.cod_agenc_bcia + " - " + agenc_bcia.cod_digito_agenc_bcia + " - " + banco.nom_banco
           tt_cabec_bordero.ttv_nom_banco             = banco.nom_banco.
    find msg_financ no-lock
        where msg_financ.cod_mensagem = bord_ap.cod_msg_inic
        and   msg_financ.cod_estab    = bord_ap.cod_estab_bord
        and   msg_financ.cod_empresa  = bord_ap.cod_empresa no-error.
    if  avail msg_financ then
        assign tt_cabec_bordero.ttv_des_msg_inic_bord_apb = msg_financ.des_mensagem.
    else
        assign tt_cabec_bordero.ttv_des_msg_inic_bord_apb = "".

    assign v_nom_aux = pais.nom_label_id_feder_jurid.
    repeat v_num_aux = length(pais.nom_label_id_feder_jurid) to 19:
        assign v_nom_aux = v_nom_aux + ".".
    end.
    assign tt_cabec_bordero.ttv_nom_label_id_feder = v_nom_aux + ":"
           tt_cabec_bordero.ttv_cod_id_feder       = string(pessoa_jurid.cod_id_feder, pais.cod_format_id_feder_jurid)
           tt_cabec_bordero.ttv_cod_cep            = string(pessoa_jurid.cod_cep, pais.cod_format_cep).

    find msg_financ no-lock
         where msg_financ.cod_empresa  = bord_ap.cod_empresa
         and   msg_financ.cod_estab    = bord_ap.cod_estab_bord
         and   msg_financ.cod_mensagem = bord_ap.cod_msg_fim no-error.
    if  avail msg_financ then
        assign tt_cabec_bordero.ttv_des_msg_fim_bord_apb = msg_financ.des_mensagem.
    else
        assign tt_cabec_bordero.ttv_des_msg_fim_bord_apb = "".
END PROCEDURE. /* pi_gerar_tt_cabec_bordero */
/*****************************************************************************
** Procedure Interna.....: pi_verifica_agenc_bcia_fornec_financ
** Descricao.............: pi_verifica_agenc_bcia_fornec_financ
** Criado por............: bre18490
** Criado em.............: 11/01/2000 14:27:47
** Alterado por..........: its37043
** Alterado em...........: 24/06/2005 09:22:55
*****************************************************************************/
PROCEDURE pi_verifica_agenc_bcia_fornec_financ:

    if  tt_item_bord_ap_imprimir.tta_cod_agenc_bcia = ""
    or  tt_item_bord_ap_imprimir.tta_cod_banco      = ""
    then do:
        find tt_erros_inform_bcia_fornec no-lock
             where tt_erros_inform_bcia_fornec.cdn_fornecedor = tt_item_bord_ap_imprimir.cdn_fornecedor no-error.
        if not avail tt_erros_inform_bcia_fornec  then do:
           create tt_erros_inform_bcia_fornec.
           assign tt_erros_inform_bcia_fornec.cdn_fornecedor            = tt_item_bord_ap_imprimir.cdn_fornecedor
                  tt_erros_inform_bcia_fornec.tta_nom_abrev             = emscad.fornecedor.nom_abrev
                  tt_erros_inform_bcia_fornec.cod_banco                 = tt_item_bord_ap_imprimir.tta_cod_banco
                  tt_erros_inform_bcia_fornec.cod_Agenc_bcia            = tt_item_bord_ap_imprimir.tta_cod_agenc_bcia
                  tt_erros_inform_bcia_fornec.tta_cod_digito_agenc_bcia = tt_item_bord_ap_imprimir.tta_cod_digito_agenc_bcia
                  tt_erros_inform_bcia_fornec.cod_cta_corren_bco        = fornec_financ.cod_cta_corren_bco
                  tt_erros_inform_bcia_fornec.cod_digito_cta_corren     = fornec_financ.cod_digito_cta_corre.
                  &if '{&emsfin_version}' >= "5.02" &then
                      assign tt_erros_inform_bcia_fornec.tta_ind_tip_forma_pagto   = b_forma_pagto.ind_tip_forma_pagto.
                  &else    
                      assign tt_erros_inform_bcia_fornec.tta_ind_tip_forma_pagto   = entry(1,b_forma_pagto.cod_livre_1,chr(24)).
                  &endif.              
        end.
    end.


END PROCEDURE. /* pi_verifica_agenc_bcia_fornec_financ */
/*****************************************************************************
** Procedure Interna.....: pi_rpt_bord_ap_msg_financ
** Descricao.............: pi_rpt_bord_ap_msg_financ
** Criado por............: brf12302
** Criado em.............: 17/03/2001 19:05:06
** Alterado por..........: brf12302
** Alterado em...........: 18/03/2001 14:43:53
*****************************************************************************/
PROCEDURE pi_rpt_bord_ap_msg_financ:

    case v_ind_classif_bord :
        when "Por Valor" /*l_por_fornecedor*/  then
            for each tt_item_bord_ap_imprimir no-lock
                by tt_item_bord_ap_imprimir.ttv_val_liq_item_bord:
                run pi_corpo_bord_ap_imprimir /*pi_corpo_bord_ap_imprimir*/.
            end.
        when "Por Fornecedor" /*l_por_fornecedor*/  then
            for each tt_item_bord_ap_imprimir no-lock
                by tt_item_bord_ap_imprimir.cdn_fornecedor:
                run pi_corpo_bord_ap_imprimir /*pi_corpo_bord_ap_imprimir*/.
            end.
        when "Por Data Vencimento" /*l_por_data_vencimento*/  then
            for each tt_item_bord_ap_imprimir no-lock
                by tt_item_bord_ap_imprimir.dat_vencto_tit_ap:
                run pi_corpo_bord_ap_imprimir /*pi_corpo_bord_ap_imprimir*/.
            end.
        when "Por Forma de Pagto/Fornecedor" /*l_por_forma_pagto_fornecedor*/  then
            for each tt_item_bord_ap_imprimir no-lock
                break by tt_item_bord_ap_imprimir.cod_forma_pagto
                      by tt_item_bord_ap_imprimir.cdn_fornecedor:
                run pi_corpo_bord_ap_imprimir /*pi_corpo_bord_ap_imprimir*/.
                if last-of(tt_item_bord_ap_imprimir.cdn_fornecedor) then do:
                    if (line-counter(s_1) + 9) > v_rpt_s_1_bottom then
                        page stream s_1.
                    put stream s_1 unformatted  skip skip skip skip skip.                    
                    if (line-counter(s_1) + 4) > v_rpt_s_1_bottom then
                        page stream s_1.
                    put stream s_1 unformatted 
                        "---------------------------------------------------------" at 1
                        "---------------------------------------------------------" at 58 skip
                        v_val_pag_bord_1 to 66 format "->>>,>>>,>>9.99"
                        v_val_multa_pag_bord_1 to 82 format "->>>,>>>,>>9.99"
                        v_val_juros_pag_bord_1 to 98 format "->>>,>>>,>>9.99"
                        v_val_var_mon_pag_bord_1 to 114 format "->>>,>>>,>>9.99" skip
                        "Total de T°tulos por Fornecedor" at 1
                        v_qtd_tot_tit_pag_bord_1 to 44 format ">>>9"
                        v_val_pag_tot_impto_1 to 66 format "->>>,>>>,>>9.99"
                        v_val_desc_pag_bord_1 to 82 format "->>>,>>>,>>9.99"
                        v_val_abat_pag_bord_1 to 98 format "->>>,>>>,>>9.99"
                        v_val_liq_pag_bord_1 to 114 format "->>>,>>>,>>9.99" skip
                        "---------------------------------------------------------" at 1
                        "---------------------------------------------------------" at 58 skip.
                    assign v_qtd_tot_tit_pag_bord_1 = 0
                           v_val_pag_bord_1         = 0
                           v_val_multa_pag_bord_1   = 0 
                           v_val_juros_pag_bord_1   = 0 
                           v_val_var_mon_pag_bord_1 = 0
                           v_val_desc_pag_bord_1    = 0
                           v_val_abat_pag_bord_1    = 0
                           v_val_liq_pag_bord_1     = 0
                           v_val_pag_tot_impto_1    = 0.
                end.
                if last-of(tt_item_bord_ap_imprimir.cod_forma_pagto) then do:
                    if (line-counter(s_1) + 9) > v_rpt_s_1_bottom then
                        page stream s_1.
                    put stream s_1 unformatted  skip skip skip skip skip.                    
                    if (line-counter(s_1) + 4) > v_rpt_s_1_bottom then
                        page stream s_1.
                    put stream s_1 unformatted 
                        "---------------------------------------------------------" at 1
                        "---------------------------------------------------------" at 58 skip
                        v_val_pag_bord_2 to 66 format "->>>,>>>,>>9.99"
                        v_val_multa_pag_bord_2 to 82 format "->>>,>>>,>>9.99"
                        v_val_juros_pag_bord_2 to 98 format "->>>,>>>,>>9.99"
                        v_val_var_mon_pag_bord_2 to 114 format "->>>,>>>,>>9.99" skip
                        "Total de T°tulos por Forma de Pagamento" at 1
                        v_qtd_tot_tit_pag_bord_2 to 44 format ">>>9"
                        v_val_pag_tot_impto_2 to 66 format "->>>,>>>,>>9.99"
                        v_val_desc_pag_bord_2 to 82 format "->>>,>>>,>>9.99"
                        v_val_abat_pag_bord_2 to 98 format "->>>,>>>,>>9.99"
                        v_val_liq_pag_bord_2 to 114 format "->>>,>>>,>>9.99" skip
                        "---------------------------------------------------------" at 1
                        "---------------------------------------------------------" at 58 skip.
                    assign v_qtd_tot_tit_pag_bord_2 = 0
                           v_val_pag_bord_2         = 0
                           v_val_multa_pag_bord_2   = 0 
                           v_val_juros_pag_bord_2   = 0 
                           v_val_var_mon_pag_bord_2 = 0
                           v_val_desc_pag_bord_2    = 0
                           v_val_abat_pag_bord_2    = 0
                           v_val_liq_pag_bord_2     = 0
                           v_val_pag_tot_impto_2    = 0.
                end.
            end.
        when "Por Estabelecimento/Fornecedor" /*l_por_estabelecimentofornecedor*/  then
            for each tt_item_bord_ap_imprimir no-lock
                by tt_item_bord_ap_imprimir.cod_estab_bord
                by tt_item_bord_ap_imprimir.cdn_fornecedor:
                run pi_corpo_bord_ap_imprimir /*pi_corpo_bord_ap_imprimir*/.
            end.
        when "Por Estabelecimento/Data Vencto" /*l_por_estabelecimentodata_vencto*/  then
            for each tt_item_bord_ap_imprimir no-lock
                by tt_item_bord_ap_imprimir.cod_estab_bord
                by tt_item_bord_ap_imprimir.dat_vencto_tit_ap:
                run pi_corpo_bord_ap_imprimir /*pi_corpo_bord_ap_imprimir*/.
            end.
        when "Por Estabelecimento/Forma Pagto" /*l_por_estabelecimentoforma_pagto*/  then
            for each tt_item_bord_ap_imprimir no-lock
                by tt_item_bord_ap_imprimir.cod_estab_bord
                by tt_item_bord_ap_imprimir.cod_forma_pagto.
                run pi_corpo_bord_ap_imprimir /*pi_corpo_bord_ap_imprimir*/.
            end.
        when "Por Fornecedor/Documento" /*l_por_fornecedordocumento*/  then
            for each tt_item_bord_ap_imprimir no-lock
                by tt_item_bord_ap_imprimir.cdn_fornecedor
                by tt_item_bord_ap_imprimir.cod_tit_ap
                by tt_item_bord_ap_imprimir.cod_parcela
                by tt_item_bord_ap_imprimir.cod_refer_antecip_pef.
                run pi_corpo_bord_ap_imprimir /*pi_corpo_bord_ap_imprimir*/.
            end.
    end.

END PROCEDURE. /* pi_rpt_bord_ap_msg_financ */
/*****************************************************************************
** Procedure Interna.....: pi_tratar_tt_item_bord_ap_imprimir_001
** Descricao.............: pi_tratar_tt_item_bord_ap_imprimir_001
** Criado por............: bre19062
** Criado em.............: 16/07/2001 10:55:09
** Alterado por..........: fut35183
** Alterado em...........: 19/05/2008 14:45:29
*****************************************************************************/
PROCEDURE pi_tratar_tt_item_bord_ap_imprimir_001:

    /************************ Parameter Definition Begin ************************/

    def output param p_nom_pessoa
        as character
        format "x(40)"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************** Buffer Definition Begin *************************/

    &if "{&emsfin_version}" >= "5.01" &then
    def buffer b_forma_pagto_subs
        for forma_pagto.
    &endif


    /*************************** Buffer Definition End **************************/

    /************************* Variable Definition Begin ************************/

    def var v_cod_forma_pagto_subst
        as character
        format "x(3)":U
        label "Forma Pagto"
        column-label "Forma Pagto"
        no-undo.
    def var v_val_lim_forma_pagto
        as decimal
        format "->>,>>>,>>>,>>9.99":U
        decimals 2
        label "Limite Pagto"
        column-label "Limite Pagto"
        no-undo.


    /************************** Variable Definition End *************************/

    assign v_cod_forma_pagto_altern = forma_pagto.cod_forma_pagto.

    if  item_bord_ap.cod_refer_antecip_pef = ""
    then do:
        find emscad.fornecedor no-lock
            where fornecedor.cod_empresa = item_bord_ap.cod_empresa
            and   fornecedor.cdn_fornecedor = item_bord_ap.cdn_fornecedor no-error.
        assign p_nom_pessoa = fornecedor.nom_pessoa
               v_nom_cidade = "Sim" /*l_sim*/ .
    end.
    else do:
        find antecip_pef_pend no-lock
             where antecip_pef_pend.cod_estab = item_bord_ap.cod_estab
               and antecip_pef_pend.cod_refer = item_bord_ap.cod_refer_antecip_pef
              no-error.
        if  antecip_pef_pend.cdn_fornecedor > 0
        then do:
            find fornecedor no-lock
                 where fornecedor.cdn_fornecedor = antecip_pef_pend.cdn_fornecedor
                   and fornecedor.cod_empresa = antecip_pef_pend.cod_empresa
                  no-error.
            assign p_nom_pessoa = fornecedor.nom_pessoa
                   v_nom_cidade = "Sim" /*l_sim*/ .
        end.
        else do:
            if  forma_pagto.log_cta_corren_fornec_obrig = yes
            or forma_pagto.log_agrup_tit_fornec = yes
            or (forma_pagto.log_cheq_administ = yes
            and antecip_pef_pend.nom_favorec_cheq = "")
            then do:
                assign p_nom_pessoa = "Erro" /*l_Erro*/  + "Erro" /*l_Erro*/  + "Erro" /*l_Erro*/  + "Erro" /*l_Erro*/  + "Erro" /*l_Erro*/ 
                       v_nom_cidade = "".
                create tt_log_erros_atualiz.
                assign tt_log_erros_atualiz.tta_cod_estab     = bord_ap.cod_estab_bord
                       tt_log_erros_atualiz.ttv_num_mensagem  = 6918
                       tt_log_erros_atualiz.tta_num_seq_refer = item_bord_ap.num_seq_bord.
                run pi_messages (input "msg",
                                 input 6918,
                                 input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")).
                assign tt_log_erros_atualiz.ttv_des_msg_erro = return-value /*msg_6918*/.
                run pi_messages (input "help",
                                 input 6918,
                                 input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")).
                assign tt_log_erros_atualiz.ttv_des_msg_ajuda = return-value /*msg_6918*/.
                assign tt_log_erros_atualiz.ttv_des_msg_ajuda = substitute( tt_log_erros_atualiz.ttv_des_msg_ajuda,"Sequància:" /*l_sequencia:*/  + string(item_bord_ap.num_seq_bord) )
                       v_log_erro_impr = yes.
            end.
            else
                assign p_nom_pessoa = antecip_pef_pend.nom_favorec_cheq
                       v_nom_cidade = "".
        end /* else */.
    end /* else */.
    if  v_nom_cidade <> ""
    then do:
        if  fornecedor.num_pessoa mod 2 = 0
        then do:
            find pessoa_fisic no-lock
                 where pessoa_fisic.num_pessoa_fisic = fornecedor.num_pessoa
                  no-error.
            assign v_nom_cidade = pessoa_fisic.nom_cidade.
        end.
        else do:
            find pessoa_jurid no-lock
                 where pessoa_jurid.num_pessoa_jurid = fornecedor.num_pessoa
                  no-error.
            assign v_nom_cidade = pessoa_jurid.nom_cidade.
        end /* else */.
        find fornec_financ no-lock
            where fornec_financ.cod_empresa = fornecedor.cod_empresa
            and   fornec_financ.cdn_fornecedor = fornecedor.cdn_fornecedor no-error.
        find agenc_bcia no-lock
            where agenc_bcia.cod_banco = fornec_financ.cod_banco
            and   agenc_bcia.cod_agenc_bcia = fornec_financ.cod_agenc_bcia no-error.

        if  v_log_cta_fornec
        and item_bord_ap.cod_bco_pagto <> "" /*l_*/  then do:
            if (forma_pagto.ind_regra_uso_forma_altern = "Banco  = Banco Fornecedor" /*l_banco___banco_fornecedor*/ 
            and item_bord_ap.cod_banco = item_bord_ap.cod_bco_pagto)
            or (forma_pagto.ind_regra_uso_forma_altern = "Banco <> Banco Fornecedor" /*l_banco__banco_fornecedor*/ 
            and item_bord_ap.cod_banco <> item_bord_ap.cod_bco_pagto
            and fornec_financ.cod_banco <> "" /*l_*/ ) then
                assign v_cod_forma_pagto_altern = forma_pagto.cod_forma_pagto_altern.                
        end.
        else do:                
            if (forma_pagto.ind_regra_uso_forma_altern = "Banco  = Banco Fornecedor" /*l_banco___banco_fornecedor*/ 
            and fornec_financ.cod_banco = item_bord_ap.cod_banco)
            or (forma_pagto.ind_regra_uso_forma_altern = "Banco <> Banco Fornecedor" /*l_banco__banco_fornecedor*/ 
            and fornec_financ.cod_banco <> item_bord_ap.cod_banco
            and fornec_financ.cod_banco <> "") then
                assign v_cod_forma_pagto_altern = forma_pagto.cod_forma_pagto_altern.
        end.

        /* Ponto Espec°fico de Chamada EPC - GE-DAKO - FO: 908.354 */
        if  v_nom_prog_upc <> '' then
        do:
            for each tt_epc:
                delete tt_epc.
            end.

            create tt_epc.
            assign tt_epc.cod_event     = 'Forma Pgto Alternativa'
                   tt_epc.cod_parameter = 'Verifica'
                   tt_epc.val_parameter = string(recid(item_bord_ap)).

            run value(v_nom_prog_upc) (input 'Forma Pgto Alternativa',
                                       input-output table tt_epc).
            find first tt_epc no-lock
                 where tt_epc.cod_event     = 'Forma Pgto Alternativa'
                 and   tt_epc.cod_parameter = 'Atualiza' 
                 no-error.
            if  avail tt_epc and
                tt_epc.val_parameter <> '' then
                assign v_cod_forma_pagto_altern = tt_epc.val_parameter.

            for each tt_epc:
                delete tt_epc.
            end.
        end.

        /* ********   190736 - Se a form de pagto tiver altern v†lida, a form de pagto de subst dever† ser referente a form altern...  *********/ 
        /* Alteraá∆o feita para atualizar a forma alternativa com a forma de substituiá∆o, caso exista o limite de pagto parametrizado na forma enviada ao banco */

        if v_cod_forma_pagto_altern <> item_bord_ap.cod_forma_pagto then
            find first b_forma_pagto_subs
                 where b_forma_pagto_subs.cod_forma_pagto = v_cod_forma_pagto_altern 
                 no-lock no-error.
        else
            find first b_forma_pagto_subs
                 where b_forma_pagto_subs.cod_forma_pagto = item_bord_ap.cod_forma_pagto 
                 no-lock no-error.
        if avail b_forma_pagto_subs then do:
           &if '{&emsfin_version}' >= '5.06' &then
               assign v_val_lim_forma_pagto   = b_forma_pagto_subs.val_lim_pagto
                      v_cod_forma_pagto_subst = b_forma_pagto_subs.cod_forma_pagto_subst.
           &else
               assign v_val_lim_forma_pagto   = b_forma_pagto_subs.val_livre_1
                      v_cod_forma_pagto_subst = GetEntryField(2,b_forma_pagto_subs.cod_livre_1,chr(24)).
           &endif
        end.
        /* Alteraªío feita para atualizar a forma alternativa com a forma de substituiªío, caso exista o limite de pagto parametrizado */        
        if avail b_forma_pagto_subs and v_val_lim_forma_pagto <> 0 then do:
            find first item_bord_ap_agrup 
                 where item_bord_ap_agrup.cod_estab_bord            = item_bord_ap.cod_estab_bord 
                   and item_bord_ap_agrup.num_id_agrup_item_bord_ap = item_bord_ap.num_id_agrup_item_bord_ap no-lock no-error.
            if avail item_bord_ap_agrup then do:
                if item_bord_ap_agrup.val_tot_agrup_item_bord_ap >= v_val_lim_forma_pagto then 
                    assign v_cod_forma_pagto_altern = v_cod_forma_pagto_subst.
            end.
            else do:
                if item_bord_ap.val_pagto >= v_val_lim_forma_pagto then
                    assign v_cod_forma_pagto_altern = v_cod_forma_pagto_subst.
            end.
        end.
        /* ************/
    end.
END PROCEDURE. /* pi_tratar_tt_item_bord_ap_imprimir_001 */
/*****************************************************************************
** Procedure Interna.....: pi_eec_informacoes_banc
** Descricao.............: pi_eec_informacoes_banc
** Criado por............: bre19062
** Criado em.............: 13/07/2001 14:27:44
** Alterado por..........: bre19062
** Alterado em...........: 08/08/2001 11:27:48
*****************************************************************************/
PROCEDURE pi_eec_informacoes_banc:


    &IF '{&emsfin_version}' >= '5.04' &then

        /* ** Verifica se Ç Antecipaá∆o ****/
        if  tt_item_bord_ap_imprimir.cod_refer_antecip_pef = ""
        or  tt_item_bord_ap_imprimir.cod_refer_antecip_pef = ?
        then do:

            for first acerto_cta_eec
                FIELDS(acerto_cta_eec.cod_estab
                       acerto_cta_eec.cod_refer
                       acerto_cta_eec.cod_banco
                       acerto_cta_eec.cod_agenc_bcia                  
                       &IF '{&emsfin_version}' >= "5.06" &THEN   
                           acerto_cta_eec.cod_digito_agenc_bcia
                       &ELSE
                           acerto_cta_eec.cod_livre_1
                       &ENDIF
                       acerto_cta_eec.cod_cta_corren_bco
                       acerto_cta_eec.cod_digito_cta_corren                           
                       acerto_cta_eec.cod_estab
                       acerto_cta_eec.num_id_tit_ap)
                where acerto_cta_eec.cod_estab     = tit_ap.cod_estab
                and   acerto_cta_eec.num_id_tit_ap = tit_ap.num_id_tit_ap
                no-lock :
            end.
            if  avail acerto_cta_eec then 
                assign tt_item_bord_ap_imprimir.tta_cod_banco             = acerto_cta_eec.cod_banco
                       tt_item_bord_ap_imprimir.tta_cod_agenc_bcia        = acerto_cta_eec.cod_agenc_bcia
                       &IF '{&emsfin_version}' >= "5.06" &THEN   
                            tt_item_bord_ap_imprimir.tta_cod_digito_agenc_bcia = acerto_cta_eec.cod_digito_agenc_bcia
                       &ELSE
                            tt_item_bord_ap_imprimir.tta_cod_digito_agenc_bcia  = acerto_cta_eec.cod_livre_1
                       &ENDIF
                       tt_item_bord_ap_imprimir.tta_cod_cta_corren        = acerto_cta_eec.cod_cta_corren_bco
                       tt_item_bord_ap_imprimir.tta_cod_digito_cta_corren = acerto_cta_eec.cod_digito_cta_corren.          
        end.
        else do:   
            for first adiant_prestac_cta_eec
                FIELDS(adiant_prestac_cta_eec.cod_estab
                       adiant_prestac_cta_eec.cod_refer
                       adiant_prestac_cta_eec.cod_banco
                       adiant_prestac_cta_eec.cod_agenc_bcia                  
                       &IF '{&emsfin_version}' >= "5.06" &THEN   
                           adiant_prestac_cta_eec.cod_digito_agenc_bcia
                       &ELSE
                           adiant_prestac_cta_eec.cod_livre_1
                       &ENDIF
                       adiant_prestac_cta_eec.cod_cta_corren_bco
                       adiant_prestac_cta_eec.cod_digito_cta_corren
                       adiant_prestac_cta_eec.ind_adiant_depos_espec)
                where  adiant_prestac_cta_eec.cod_estab              = tt_item_bord_ap_imprimir.cod_estab
                and    adiant_prestac_cta_eec.cod_refer              = tt_item_bord_ap_imprimir.cod_refer_antecip_pef
                and    adiant_prestac_cta_eec.ind_adiant_depos_espec = "Dep¢sito" /*l_deposito*/ 
                no-lock:
            end.
            if  avail adiant_prestac_cta_eec then
                assign tt_item_bord_ap_imprimir.tta_cod_banco             = adiant_prestac_cta_eec.cod_banco
                       tt_item_bord_ap_imprimir.tta_cod_agenc_bcia        = adiant_prestac_cta_eec.cod_agenc_bcia
                       &IF '{&emsfin_version}' >= "5.06" &THEN   
                            tt_item_bord_ap_imprimir.tta_cod_digito_agenc_bcia = adiant_prestac_cta_eec.cod_digito_agenc_bcia
                       &ELSE
                            tt_item_bord_ap_imprimir.tta_cod_digito_agenc_bcia = adiant_prestac_cta_eec.cod_livre_1
                       &ENDIF
                       tt_item_bord_ap_imprimir.tta_cod_cta_corren        = adiant_prestac_cta_eec.cod_cta_corren_bco
                       tt_item_bord_ap_imprimir.tta_cod_digito_cta_corren = adiant_prestac_cta_eec.cod_digito_cta_corren.
            else 
                assign  v_ind_origin_tit_ap = "".

        end.
    &ENDIF

    RETURN "OK" /*l_ok*/ .


END PROCEDURE. /* pi_eec_informacoes_banc */
/*****************************************************************************
** Procedure Interna.....: pi_epc_inf_bcia
** Descricao.............: pi_epc_inf_bcia
** Criado por............: src12152
** Criado em.............: 11/03/2003 08:53:45
** Alterado por..........: src12152
** Alterado em...........: 14/04/2003 08:41:58
*****************************************************************************/
PROCEDURE pi_epc_inf_bcia:

    &if '{&frame_aux}' = '' &then
        if  v_nom_prog_upc <> '' or
            v_nom_prog_appc <> '' 
         &if '{&emsbas_version}' > '5.00' &then
            or  v_nom_prog_dpc <> ''
         &endif
        then do:
            for each tt_epc:
                delete tt_epc.
            end.

            create tt_epc. 
            assign tt_epc.cod_event     = "Informaá‰es Banc†rias Item Bord" /*l_inf_bcia_item_bord*/ 
                   tt_epc.cod_parameter = "Atualiza" /*l_atualiza*/ 
                   tt_epc.val_parameter = string(recid(item_bord_ap)).


            /* Begin_Include: i_exec_program_epc_custom */
            if  v_nom_prog_upc <> '' then
            do:
                run value(v_nom_prog_upc) (input "Informaá‰es Banc†rias Item Bord" /* l_inf_bcia_item_bord*/,
                                           input-output table tt_epc).
            end.

            if  v_nom_prog_appc <> '' then
            do:
                run value(v_nom_prog_appc) (input "Informaá‰es Banc†rias Item Bord" /* l_inf_bcia_item_bord*/,
                                            input-output table tt_epc).
            end.

            &if '{&emsbas_version}' > '5.00' &then
            if  v_nom_prog_dpc <> '' then
            do:
                run value(v_nom_prog_dpc) (input "Informaá‰es Banc†rias Item Bord" /* l_inf_bcia_item_bord*/,
                                            input-output table tt_epc).
            end.
            &endif
            /* End_Include: i_exec_program_epc_custom */


            if  return-value = "OK" /*l_ok*/ 
            then do:
                find first tt_epc no-lock
                    where tt_epc.cod_event     = "Informaá‰es Banc†rias Item Bord" /*l_inf_bcia_item_bord*/ 
                    and   tt_epc.cod_parameter = "Atualiza" /*l_atualiza*/ 
                    no-error.
                if avail tt_epc and 
                   tt_epc.val_parameter <> ""  and
                   num-entries(tt_epc.val_parameter,chr(10)) >= 5 then
                   assign tt_item_bord_ap_imprimir.tta_cod_banco             = entry(1,tt_epc.val_parameter, chr(10))   /* item_bord_ap.cod_bco_pagto */
                          tt_item_bord_ap_imprimir.tta_cod_agenc_bcia        = entry(2,tt_epc.val_parameter , chr(10))  /* item_bord_ap.cod_agenc_bcia_pagto */
                          tt_item_bord_ap_imprimir.tta_cod_digito_agenc_bcia = entry(3,tt_epc.val_parameter , chr(10))  /* item_bord_ap.cod_digito_agenc_bcia_pagto */ 
                          tt_item_bord_ap_imprimir.tta_cod_cta_corren        = entry(4,tt_epc.val_parameter , chr(10))  /* item_bord_ap.cod_cta_corren_bco_pagto */
                          tt_item_bord_ap_imprimir.tta_cod_digito_cta_corren = entry(5,tt_epc.val_parameter , chr(10)). /* item_bord_ap.cod_digito_cta_corren_pagto */
            end.
            for each tt_epc:
                delete tt_epc.
            end.
        end.
    &endif
END PROCEDURE. /* pi_epc_inf_bcia */
/*****************************************************************************
** Procedure Interna.....: pi_imprime_complemento_cabec_bordero
** Descricao.............: pi_imprime_complemento_cabec_bordero
** Criado por............: fut1309
** Criado em.............: 04/08/2005 08:04:15
** Alterado por..........: fut1309
** Alterado em...........: 06/02/2006 09:49:35
*****************************************************************************/
PROCEDURE pi_imprime_complemento_cabec_bordero:

    /************************ Parameter Definition Begin ************************/

    def Input param p_ind_tip_relat_bord_apb
        as character
        format "X(08)"
        no-undo.
    def Input param p_des_msg_inic_bord_apb
        as character
        format "x(2000)"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_des_msg_lin_bord_apb
        as character
        format "x(2000)":U
        no-undo.
    def var v_num_count_lin
        as integer
        format ">>>>,>>9":U
        no-undo.
    def var v_num_count_lin_2
        as integer
        format ">>>>,>>9":U
        no-undo.


    /************************** Variable Definition End *************************/

    assign v_num_count_lin        = 1 
           v_num_count_lin_2      = 0
           v_des_msg_lin_bord_apb = "".

    repeat:

        /* * v_des_msg_col_1 **/
        if v_num_count_lin = 1 or v_num_count_lin > 8 then
            assign v_des_msg_col_1 = "".

        else if v_num_count_lin = 2 then
            assign v_des_msg_col_1 = "+-------- Para uso do Banco --------+" /*l_para_uso_bco*/ .

        else if v_num_count_lin > 2 and v_num_count_lin <= 7 then
            assign v_des_msg_col_1 = "|                                   |".

        else if v_num_count_lin = 8 then 
            assign v_des_msg_col_1 = "+-----------------------------------+".

        /* * v_des_msg_col_2 **/
        if v_des_msg_lin_bord_apb = "" then do:
            if index(p_des_msg_inic_bord_apb, chr(10)) > 0 then 
                assign v_des_msg_lin_bord_apb  = substring(p_des_msg_inic_bord_apb, 1, index(p_des_msg_inic_bord_apb, chr(10)) - 1)
                       p_des_msg_inic_bord_apb = substring(p_des_msg_inic_bord_apb, index(p_des_msg_inic_bord_apb, chr(10)) + 1).
            else                       
                assign v_des_msg_lin_bord_apb  = substring(p_des_msg_inic_bord_apb, 1, 75)
                       p_des_msg_inic_bord_apb = substring(p_des_msg_inic_bord_apb, 76).
        end.                       

        if length(v_des_msg_lin_bord_apb) > 75 then 
            assign v_des_msg_col_2        = trim(substring(v_des_msg_lin_bord_apb, 1, 75))
                   v_des_msg_lin_bord_apb = substring(v_des_msg_lin_bord_apb, 76).
        else
            assign v_des_msg_col_2 = trim(v_des_msg_lin_bord_apb)
                   v_des_msg_lin_bord_apb = "".

        if v_num_count_lin > 4 and p_des_msg_inic_bord_apb = "" and v_des_msg_col_2 = "" then do:
            if p_ind_tip_relat_bord_apb = "Normal" /*l_normal*/  then do:
                if v_num_count_lin_2 = 0 then
                    assign v_num_count_lin_2 = 1
                           v_des_msg_col_2 = "".
                else if v_num_count_lin_2 = 1 then
                    assign v_num_count_lin_2 = 2
                           v_des_msg_col_2 = "         ---------------------------------------------------------".
                else if v_num_count_lin_2 = 2 then 
                    assign v_num_count_lin_2 = 4
                           v_des_msg_col_2 = "                 " + if avail empresa then emscad.empresa.nom_razao_social else "".
            end.
            else if p_ind_tip_relat_bord_apb = "Cancelamento" /*l_cancelamento*/  then do:
                if v_num_count_lin_2 = 0 then
                    assign v_num_count_lin_2 = 1
                           v_des_msg_col_2 = "".
                else if v_num_count_lin_2 = 1 then
                    assign v_num_count_lin_2 = 2
                           v_des_msg_col_2 = "                " + "BORDERO  DE  CANCELAMENTO DE CHEQ. ADM." /*l_bord_cancel_adm*/ .  
                else if v_num_count_lin_2 = 2 then 
                    assign v_num_count_lin_2 = 3                                     
                           v_des_msg_col_2 = "         ---------------------------------------------------------".
                else if v_num_count_lin_2 = 3 then 
                    assign v_num_count_lin_2 = 4
                           v_des_msg_col_2 = "                 " + if avail empresa then empresa.nom_razao_social else "".
            end.
            else if p_ind_tip_relat_bord_apb = "Escritural" /*l_escritural*/  then do:
                if  v_num_count_lin >= 7
                then do:
                    if v_num_count_lin_2 = 0 then 
                        assign v_num_count_lin_2  = 1
                               v_des_msg_col_2 = "         ---------------------------------------------------------".
                    else if v_num_count_lin_2 = 1 then
                        assign v_num_count_lin_2 = 4
                               v_des_msg_col_2 = "                 " + if avail empresa then empresa.nom_razao_social else "".
                end /* if */.
            end.
            else 
                assign v_num_count_lin_2  = 4.
        end.                                

        /* * imprime **/
        if (line-counter(s_1) + 1) > v_rpt_s_1_bottom then
            page stream s_1.
        put stream s_1 unformatted 
            v_des_msg_col_1 at 1 format "x(37)"
            v_des_msg_col_2 at 40 format "x(75)" skip.

        if (v_num_count_lin > 7 and p_des_msg_inic_bord_apb = "" and v_num_count_lin_2 >= 4) then leave.
        assign v_num_count_lin = v_num_count_lin + 1.
    end.

    assign v_des_msg_col_1 = ""
           v_des_msg_col_2 = "".
    if (line-counter(s_1) + 1) > v_rpt_s_1_bottom then
        page stream s_1.
    put stream s_1 unformatted 
        v_des_msg_col_1 at 1 format "x(37)"
        v_des_msg_col_2 at 40 format "x(75)" skip.

END PROCEDURE. /* pi_imprime_complemento_cabec_bordero */
/*****************************************************************************
** Procedure Interna.....: pi_retorna_total_lin_msg_encerramento
** Descricao.............: pi_retorna_total_lin_msg_encerramento
** Criado por............: fut1228_4
** Criado em.............: 30/10/2006 16:24:27
** Alterado por..........: fut1228_4
** Alterado em...........: 30/10/2006 16:30:49
*****************************************************************************/
PROCEDURE pi_retorna_total_lin_msg_encerramento:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_empresa
        as character
        format "x(3)"
        no-undo.
    def Input param p_cod_estab
        as character
        format "x(3)"
        no-undo.
    def Input param p_cod_msg_fim
        as character
        format "x(2)"
        no-undo.
    def output param p_num_count
        as integer
        format ">>>>,>>9"
        no-undo.


    /************************* Parameter Definition End *************************/

    find msg_financ no-lock
         where msg_financ.cod_empresa  = p_cod_empresa
         and   msg_financ.cod_estab    = p_cod_estab
         and   msg_financ.cod_mensagem = p_cod_msg_fim no-error.
    if  avail msg_financ
    then do:
        assign v_des_msg_fim_bord_apb = replace(msg_financ.des_mensagem, chr(13), chr(10)).

        repeat:
            if v_des_msg_fim_bord_apb = "" /*l_null*/  then leave.

            if  index(v_des_msg_fim_bord_apb, chr(10)) > 0
            then do:
                assign v_des_msg_lin_bord_apb = substring(v_des_msg_fim_bord_apb, 1, index(v_des_msg_fim_bord_apb,chr(10)) - 1 )
                       v_des_msg_fim_bord_apb     = substring(v_des_msg_fim_bord_apb, index(v_des_msg_fim_bord_apb,chr(10)) + 1).
            end /* if */.
            else do:
                assign v_des_msg_lin_bord_apb = v_des_msg_fim_bord_apb
                       v_des_msg_fim_bord_apb = "" /*l_null*/ .
            end /* else */.

            assign v_des_msg_lin_bord_apb_aux = substring(v_des_msg_lin_bord_apb, 1, 80).
            assign p_num_count = p_num_count + 1.

            if  length(v_des_msg_lin_bord_apb) > 80
            then do:
                assign v_des_msg_lin_bord_apb = substring(v_des_msg_lin_bord_apb, 81).
                repeat:
                    if v_des_msg_lin_bord_apb = "" /*l_null*/  then leave.

                    if  length(v_des_msg_lin_bord_apb) > 95
                    then do:
                        assign v_des_msg_lin_compl_bord_apb = trim(substring(v_des_msg_lin_bord_apb, 1, 94))
                               v_des_msg_lin_bord_apb = substring(v_des_msg_lin_bord_apb, 95).
                    end /* if */.
                    else do:
                        assign v_des_msg_lin_compl_bord_apb = trim(v_des_msg_lin_bord_apb)
                               v_des_msg_lin_bord_apb = "" /*l_null*/ .
                    end /* else */.
                    assign p_num_count = p_num_count + 1.
                end.
            end /* if */.
        end.
    end /* if */.
END PROCEDURE. /* pi_retorna_total_lin_msg_encerramento */
/*****************************************************************************
** Procedure Interna.....: pi_traducao_economico
** Descricao.............: pi_traducao_economico
** Criado por............: fut43120
** Criado em.............: 19/09/2008 14:40:39
** Alterado por..........: fut43120
** Alterado em...........: 03/10/2008 10:38:38
*****************************************************************************/
PROCEDURE pi_traducao_economico:

    /* ** Tratamento para erro na traduá∆o do valor por extenso do borderì ***/
        find first idiom_pais no-lock
            where idiom_pais.cod_pais        = emscad.pais.cod_pais
            and   idiom_pais.log_idiom_princ = yes no-error.
        if avail idiom_pais then do:
            find trad_indic_econ no-lock
                 where trad_indic_econ.cod_indic_econ = bord_ap.cod_indic_econ
                   and trad_indic_econ.cod_idioma = idiom_pais.cod_idioma no-error.
            if  not available trad_indic_econ
            then do:

            assign v_ind_sit_bord_impr = "Erro" /*l_erro*/   + "Erro" /*l_erro*/   + "Erro" /*l_erro*/   + "Erro" /*l_erro*/   + "Erro" /*l_erro*/  .

                create tt_log_erros_atualiz.
                assign tt_log_erros_atualiz.tta_cod_estab = bord_ap.cod_estab_bord   
                       tt_log_erros_atualiz.ttv_num_mensagem  = 19482
                       tt_log_erros_atualiz.tta_num_seq_refer = 1.
                run pi_messages (input "Msg" /*l_msg*/ ,
                                 input 19482,
                                 input substitute ('&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9')).
                assign tt_log_erros_atualiz.ttv_des_msg_erro = return-value /* msg_19482*/.
                assign tt_log_erros_atualiz.ttv_des_msg_erro = substitute( tt_log_erros_atualiz.ttv_des_msg_erro, bord_ap.cod_indic_econ, idiom_pais.cod_idioma).
                run pi_messages (input "Help" /*l_help*/ ,
                                 input 19482,
                                 input substitute ('&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9')).
                assign tt_log_erros_atualiz.ttv_des_msg_ajuda = return-value /* msg_19482*/.
                assign tt_log_erros_atualiz.ttv_des_msg_ajuda = substitute( tt_log_erros_atualiz.ttv_des_msg_ajuda, bord_ap.cod_indic_econ, idiom_pais.cod_idioma).

            end /* if */.
        end.
        else do:

           assign v_ind_sit_bord_impr = "Erro" /*l_erro*/   + "Erro" /*l_erro*/   + "Erro" /*l_erro*/   + "Erro" /*l_erro*/   + "Erro" /*l_erro*/  .                  

           create tt_log_erros_atualiz.
           assign tt_log_erros_atualiz.tta_cod_estab = bord_ap.cod_estab_bord
                  tt_log_erros_atualiz.ttv_num_mensagem  = 7017
                  tt_log_erros_atualiz.tta_num_seq_refer = 1.
           run pi_messages (input "Msg" /*l_msg*/ ,
                            input 7017,
                            input substitute ('&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9',pais.cod_pais)).
           assign tt_log_erros_atualiz.ttv_des_msg_erro = return-value /* msg_7017*/.
           run pi_messages (input "Help" /*l_help*/ ,
                            input 7017,
                            input substitute ('&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9')).
           assign tt_log_erros_atualiz.ttv_des_msg_ajuda = return-value /* msg_7017*/.
           assign tt_log_erros_atualiz.ttv_des_msg_ajuda = substitute( tt_log_erros_atualiz.ttv_des_msg_ajuda, pais.cod_pais).
        end.

     RETURN "OK" /*l_ok*/  /* Ok */.
END PROCEDURE. /* pi_traducao_economico */


/************************** Internal Procedure End **************************/

/************************* External Procedure Begin *************************/



/************************** External Procedure End **************************/

/*************************************  *************************************/
/*****************************************************************************
**  Procedure Interna: pi_print_editor
**  Descricao........: Imprime editores nos relat¢rios
*****************************************************************************/
PROCEDURE pi_print_editor:

    def input param p_stream    as char    no-undo.
    def input param p1_editor   as char    no-undo.
    def input param p1_pos      as char    no-undo.
    def input param p2_editor   as char    no-undo.
    def input param p2_pos      as char    no-undo.
    def input param p3_editor   as char    no-undo.
    def input param p3_pos      as char    no-undo.

    def var c_editor as char    extent 5             no-undo.
    def var l_first  as logical extent 5 initial yes no-undo.
    def var c_at     as char    extent 5             no-undo.
    def var i_pos    as integer extent 5             no-undo.
    def var i_len    as integer extent 5             no-undo.

    def var c_aux    as char               no-undo.
    def var i_aux    as integer            no-undo.
    def var c_ret    as char               no-undo.
    def var i_ind    as integer            no-undo.

    assign c_editor [1] = p1_editor
           c_at  [1]    =         substr(p1_pos,1,2)
           i_pos [1]    = integer(substr(p1_pos,3,3))
           i_len [1]    = integer(substr(p1_pos,6,3)) - 4
           c_editor [2] = p2_editor
           c_at  [2]    =         substr(p2_pos,1,2)
           i_pos [2]    = integer(substr(p2_pos,3,3))
           i_len [2]    = integer(substr(p2_pos,6,3)) - 4
           c_editor [3] = p3_editor
           c_at  [3]    =         substr(p3_pos,1,2)
           i_pos [3]    = integer(substr(p3_pos,3,3))
           i_len [3]    = integer(substr(p3_pos,6,3)) - 4
           c_ret        = chr(255) + chr(255).

    do while c_editor [1] <> "" or c_editor [2] <> "" or c_editor [3] <> "":
        do i_ind = 1 to 3:
            if c_editor[i_ind] <> "" then do:
                assign i_aux = index(c_editor[i_ind], chr(10)).
                if i_aux > i_len[i_ind] or (i_aux = 0 and length(c_editor[i_ind]) > i_len[i_ind]) then
                    assign i_aux = r-index(c_editor[i_ind], " ", i_len[i_ind] + 1).
                if i_aux = 0 then
                    assign c_aux = substr(c_editor[i_ind], 1, i_len[i_ind])
                           c_editor[i_ind] = substr(c_editor[i_ind], i_len[i_ind] + 1).
                else
                    assign c_aux = substr(c_editor[i_ind], 1, i_aux - 1)
                           c_editor[i_ind] = substr(c_editor[i_ind], i_aux + 1).
                if i_pos[1] = 0 then
                    assign entry(i_ind, c_ret, chr(255)) = c_aux.
                else
                    if l_first[i_ind] then
                        assign l_first[i_ind] = no.
                    else
                        case p_stream:
                            when "s_1" then
                                if c_at[i_ind] = "at" then
                                    put stream s_1 unformatted c_aux at i_pos[i_ind].
                                else
                                    put stream s_1 unformatted c_aux to i_pos[i_ind].
                        end.
            end.
        end.
        case p_stream:
        when "s_1" then
            put stream s_1 unformatted skip.
        end.
        if i_pos[1] = 0 then
            return c_ret.
    end.
    return c_ret.
END PROCEDURE.  /* pi_print_editor */

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
        message "Mensagem nr. " i_msg "!!!":U skip
                "Programa Mensagem" c_prg_msg "n∆o encontrado."
                view-as alert-box error.
        return error.
    end.

    run value(c_prg_msg + ".p":U) (input c_action, input c_param).
    return return-value.
END PROCEDURE.  /* pi_messages */
/***********************  End of fnc_bord_ap_imprimir ***********************/
