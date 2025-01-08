/*****************************************************************************
** Copyright DATASUL S.A. (1994)
** Todos os Direitos Reservados.
** 
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so' podera ser feita mediante
** autorizacao expressa.
**
** Programa..............: rpt_tit_acr_destinac
** Descricao.............: Destinaá∆o de T°tulos Contas a Receber
** Versao................:  1.00.02.097
** Procedimento..........: tar_gerar_destinac_cobr
** Nome Externo..........: prgfin/acr/acr739ab.py
** Data Geracao..........: 29/12/2021 - 13:40:47
** Criado por............: Roberto
** Criado em.............: 22/08/1997 17:26:42
** Alterado por..........: fut12235
** Alterado em...........: 03/11/2021 16:44:50
** Gerado por............: andersoncl
*****************************************************************************/

def buffer empresa for emscad.empresa.
def buffer histor_exec_especial for emscad.histor_exec_especial.
def buffer banco for emscad.banco.
def buffer cliente for emscad.cliente.
def buffer pais for emscad.pais.
def buffer portador for emscad.portador.

/*-- Filtro Multi-idioma Aplicado --*/

def var c-versao-prg as char initial " 1.00.02.097":U no-undo.
def var c-versao-rcode as char initial "[[[1.00.02.097[[[":U no-undo. /* Controle de Versao R-CODE - Nao retirar do Fonte */

{include/i_dbinst.i}
{include/i_dbtype.i}

/*{include/i_fcldef.i}*/

define new global shared variable h_facelift as handle no-undo. 
if not valid-handle(h_facelift) then run prgtec/btb/btb901zo.py persistent set h_facelift no-error.

define new global shared variable h-facelift as handle no-undo. 
if not valid-handle(h-facelift) then run prgtec/btb/btb901zo.py persistent set h-facelift no-error.

{include/i_trddef.i}

/* Alteracao via filtro - Controle de impressao - inicio */
{include/i_prdvers.i}
/* Alteracao via filtro - Controle de impressao - fim    */



&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i rpt_tit_acr_destinac ACR}
&ENDIF



/******************************* Private-Data *******************************/
assign this-procedure:private-data = "HLP=37":U.
/*************************************  *************************************/

&if "{&emsfin_dbinst}" <> "yes" &then
run pi_messages (input "show",
                 input 5884,
                 input substitute ("&1~&2~&3~&4~&5~&6~&7~&8~&9", 
                                    "EMSFIN")) /*msg_5884*/.
&elseif "{&emsfin_version}" < "5.01" &then
run pi_messages (input "show",
                 input 5009,
                 input substitute ("&1~&2~&3~&4~&5~&6~&7~&8~&9", 
                                    "RPT_TIT_ACR_DESTINAC","~~EMSFIN", "~~{~&emsfin_version}", "~~5.01")) /*msg_5009*/.
&else

/********************* Temporary Table Definition Begin *********************/

def temp-table tt_atualiza_destinac_tit_acr no-undo
    field tta_cod_estab_tit_acr            as character format "x(5)" label "Estab T°tulo ACR" column-label "Estab T°tulo ACR"
    field tta_cod_espec_docto              as character format "x(3)" label "EspÇcie Documento" column-label "EspÇcie"
    field tta_cod_ser_docto                as character format "x(5)" label "SÇrie Documento" column-label "SÇrie"
    field tta_cod_tit_acr                  as character format "x(16)" label "T°tulo" column-label "T°tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parcela"
    field ttv_cod_portador_old             as character format "x(5)" label "Portador" column-label "Portador"
    field ttv_cod_cart_bcia_old            as character format "x(3)" label "Carteira" column-label "Carteira"
    field ttv_cod_portador_new             as character format "x(5)" label "Portador" column-label "Portador"
    field ttv_cod_cart_bcia_new            as character format "x(3)" label "Carteira" column-label "Carteira"
    field tta_cod_finalid_econ             as character format "x(10)" label "Finalidade" column-label "Finalidade"
    field tta_val_sdo_cobr                 as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Saldo Cobranáa" column-label "Saldo Cobranáa"
    index tt_id                            is primary
          tta_cod_estab_tit_acr            ascending
    .

def temp-table tt_espec_docto no-undo
    field tta_cod_espec_docto              as character format "x(3)" label "EspÇcie Documento" column-label "EspÇcie"
    index tt_espec_docto                  
          tta_cod_espec_docto              ascending
    .

def new shared temp-table tt_identif_num_processo no-undo
    field tta_cod_portador                 as character format "x(5)" label "Portador" column-label "Portador"
    field ttv_cod_arq_edi                  as character format "x(40)" label "Nome arquivo" column-label "Nome arquivo"
    field tta_cdn_proces_edi               as Integer format ">>>>>>>9" initial 0 label "Processo" column-label "Processo"
    field ttv_num_remes_msg_edi            as integer format "9999999"
    field tta_cod_estab                    as character format "x(5)" label "Estabelecimento" column-label "Estab"
    field tta_cod_conven_bcio              as character format "x(20)" label "Convànio Banc†rio" column-label "Convànio Banc†rio"
    field tta_cod_cta_corren               as character format "x(10)" label "Conta Corrente" column-label "Cta Corrente"
    .

def temp-table tt_item_destinac_cobr_dest no-undo like item_destinac_cobr
    .

def temp-table tt_log_erro_integ no-undo
    field ttv_num_erro                     as integer format ">>>>,>>9"
    field ttv_des_msg_erro                 as character format "x(60)" label "Mensagem Erro" column-label "Inconsistància"
    field ttv_des_msg_ajuda                as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda"
    field ttv_des_param                    as character format "x(2000)" label "Param" column-label "Param"
    field ttv_cod_tip_msg_dwb              as character format "x(12)" label "Tipo Mensagem" column-label "Tipo Mensagem"
    .

def temp-table tt_portad_bco no-undo like portad_bco
    .

def temp-table tt_portad_fe_param_estab no-undo
    field tta_cod_estab                    as character format "x(5)" label "Estabelecimento" column-label "Estab"
    field tta_cod_portador                 as character format "x(5)" label "Portador" column-label "Portador"
    field tta_cod_cart_bcia                as character format "x(3)" label "Carteira" column-label "Carteira"
    field tta_cod_finalid_econ             as character format "x(10)" label "Finalidade" column-label "Finalidade"
    field tta_ind_tip_cart_bcia            as character format "X(15)" initial "Portador" label "Tipo Carteira Bcia" column-label "Tipo Carteira Bcia"
    .

def temp-table tt_portad_finalid_econ no-undo
    field tta_cod_portador                 as character format "x(5)" label "Portador" column-label "Portador"
    field tta_cod_cart_bcia                as character format "x(3)" label "Carteira" column-label "Carteira"
    field tta_cod_finalid_econ             as character format "x(10)" label "Finalidade" column-label "Finalidade"
    field tta_cod_cta_corren               as character format "x(10)" label "Conta Corrente" column-label "Cta Corrente"
    field tta_val_sdo_cobr                 as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Saldo Cobranáa" column-label "Saldo Cobranáa"
    field ttv_val_sdo_cobr_ant             as decimal format ">>>,>>>,>>9.99" decimals 2 label "Saldo Cobr Anter" column-label "Saldo Cobr Anter"
    field ttv_val_meta_destinac            as decimal format ">>>,>>>,>>>,>>9.99" decimals 2 label "Meta Destinaá∆o" column-label "Meta Destinaá∆o"
    field tta_cod_banco                    as character format "x(8)" label "Banco" column-label "Banco"
    field tta_log_validac_cep_destinac     as logical format "Sim/N∆o" initial no label "Validar CEP Destin" column-label "Validar CEP Destin"
    field ttv_val_tot_destndo              as decimal format ">>>>>,>>>,>>9.99" decimals 2 label "Total Destinado"
    index tt_prtdfnld_id                   is primary unique
          tta_cod_portador                 ascending
          tta_cod_cart_bcia                ascending
          tta_cod_finalid_econ             ascending
    .

def temp-table tt_recid no-undo
    field ttv_rec_table                    as recid format ">>>>>>9" initial ?
    index tt_recid_id                      is primary unique
          ttv_rec_table                    ascending
    .

def temp-table tt_rpt_calc_custo_acr no-undo
    field tta_cod_portador                 as character format "x(5)" label "Portador" column-label "Portador"
    field tta_nom_pessoa                   as character format "x(40)" label "Nome" column-label "Nome"
    field tta_cod_cart_bcia                as character format "x(3)" label "Carteira" column-label "Carteira"
    field ttv_qtd_portador                 as decimal format ">>>>>>>>>>9" label "Quantidade" column-label "Quantidade"
    field ttv_val_destinac_portad          as decimal format ">>>,>>>,>>9.99" decimals 2 label "Valor Destinado" column-label "Valor Destinado"
    field ttv_val_cust_acr                 as decimal format "->>,>>>,>>>,>>9.99" decimals 2 label "Custo" column-label "Custo"
    field ttv_val_perc_cust                as decimal format "->>,>>>,>>>,>>9.99" decimals 2 label "Percentual Custo" column-label "Percentual Custo"
    field tta_cod_banco                    as character format "x(8)" label "Banco" column-label "Banco"
    .

def new shared temp-table tt_rpt_tit_acr_destinac        
    field ttv_rec_tit_acr                  as recid format ">>>>>>9"
    field ttv_rec_movto_tit_acr            as recid format ">>>>>>9"
    field tta_cod_estab                    as character format "x(5)" label "Estabelecimento" column-label "Estab"
    field tta_num_id_tit_acr               as integer format "999999999" initial 0 label "Token Cta Receber" column-label "Token Cta Receber"
    field tta_cod_espec_docto              as character format "x(3)" label "EspÇcie Documento" column-label "EspÇcie"
    field tta_cod_ser_docto                as character format "x(5)" label "SÇrie Documento" column-label "SÇrie"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parcela"
    field tta_cdn_cliente                  as Integer format ">>>,>>>,>>9" initial 0 label "Cliente" column-label "Cliente"
    field tta_dat_emis_docto               as date format "99/99/9999" initial today label "Data  Emiss∆o" column-label "Dt Emiss∆o"
    field tta_dat_vencto_tit_acr           as date format "99/99/9999" initial ? label "Vencimento" column-label "Vencimento"
    field tta_val_sdo_tit_acr              as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Saldo T°tulo" column-label "Saldo T°tulo"
    field tta_cod_portador                 as character format "x(5)" label "Portador" column-label "Portador"
    field tta_cod_cart_bcia                as character format "x(3)" label "Carteira" column-label "Carteira"
    field tta_cod_tit_acr                  as character format "x(16)" label "T°tulo" column-label "T°tulo"
    field tta_ind_trans_acr                as character format "X(29)" initial "Implantaá∆o" label "Transaá∆o" column-label "Transaá∆o"
    field ttv_log_selec_tit_acr            as logical format "Sim/N∆o" initial no label "Envia" column-label "Envia"
    field tta_num_dwb_order                as integer format ">>>>,>>9" initial 0 label "Ordem" column-label "Ordem"
    field ttv_des_obs_campo                as character format "x(30)" label "Observaá‰es" column-label "Observaá‰es"
    field ttv_log_elimina                  as logical format "Sim/N∆o" initial no label "Elimina" column-label "Elimina"
    field ttv_cod_cep                      as character format "x(20)" label "CEP" column-label "CEP"
    field tta_cod_portad_prefer            as character format "x(5)" label "Portador Preferenc" column-label "Port Preferenc"
    field ttv_cod_order                    as character format "x(40)"
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_ind_ender_cobr               as character format "X(15)" initial "Cliente" label "Endereáo Cobranáa" column-label "Endereáo Cobranáa"
    field tta_cdn_repres                   as Integer format ">>>,>>9" initial 0 label "Representante" column-label "Representante"
    field tta_nom_abrev_contat             as character format "x(15)" label "Abreviado Contato" column-label "Abreviado Contato"
    field tta_nom_cidade                   as character format "x(32)" label "Cidade" column-label "Cidade"
    index tt_rpt_cliente_vencto_cod        is primary
          tta_cdn_cliente                  ascending
          tta_dat_vencto_tit_acr           ascending
          tta_cod_tit_acr                  ascending
          tta_cod_parcela                  ascending
    index tt_rpt_rec_tit_acr              
          ttv_rec_tit_acr                  ascending
    .

def new shared temp-table tt_tit_acr_selec_cobr no-undo
    field ttv_rec_tit_acr                  as recid format ">>>>>>9"
    field ttv_rec_movto_ocor_bcia          as recid format ">>>>>>9" initial ?
    field ttv_rec_movto_tit_acr            as recid format ">>>>>>9"
    field tta_cod_estab                    as character format "x(5)" label "Estabelecimento" column-label "Estab"
    field tta_cod_espec_docto              as character format "x(3)" label "EspÇcie Documento" column-label "EspÇcie"
    field tta_cod_ser_docto                as character format "x(5)" label "SÇrie Documento" column-label "SÇrie"
    field tta_cod_tit_acr                  as character format "x(16)" label "T°tulo" column-label "T°tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parcela"
    field tta_cod_portador                 as character format "x(5)" label "Portador" column-label "Portador"
    field tta_cod_cart_bcia                as character format "x(3)" label "Carteira" column-label "Carteira"
    field tta_dat_transacao                as date format "99/99/9999" initial today label "Data Transaá∆o" column-label "Dat Transac"
    field tta_dat_vencto_tit_acr           as date format "99/99/9999" initial ? label "Vencimento" column-label "Vencimento"
    field tta_ind_trans_acr                as character format "X(29)" initial "Implantaá∆o" label "Transaá∆o" column-label "Transaá∆o"
    field tta_ind_tip_ocor_bcia            as character format "x(40)" label "Tipo Ocor Bancia" column-label "Tipo Ocor Bancia"
    field ttv_log_selec_tit_acr            as logical format "Sim/N∆o" initial no label "Envia" column-label "Envia"
    field tta_log_envdo_edi                as logical format "Sim/Nao" initial no label "Enviada" column-label "Enviada"
    field ttv_des_mensagem                 as character format "x(50)" label "Mensagem" column-label "Mensagem"
    field tta_num_id_movto_tit_acr         as integer format "999999999" initial 0 label "Token Movto Tit  ACR" column-label "Token Movto Tit  ACR"
    field tta_val_desc_tit_acr             as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Desc" column-label "Vl Desc"
    field tta_val_abat_tit_acr             as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Abatimento" column-label "Vl Abatimento"
    field tta_cod_finalid_econ             as character format "x(10)" label "Finalidade" column-label "Finalidade"
    field ttv_val_sdo_tit_acr              as decimal format "->>>,>>>,>>9.99" decimals 2 label "Valor Saldo" column-label "Valor Saldo"
    field ttv_num_parc_cartcred            as integer format ">9" label "Quantidade Parcelas" column-label "Quantidade Parcelas"
    field tta_cod_conven_bcio              as character format "x(20)" label "Convànio Banc†rio" column-label "Convànio Banc†rio"
    field tta_cod_cta_corren               as character format "x(10)" label "Conta Corrente" column-label "Cta Corrente"
    field tta_cod_tit_acr_bco              as character format "x(20)" label "Num T°tulo Banco" column-label "Num T°tulo Banco"
    index tt_portador                     
          tta_cod_estab                    ascending
          tta_cod_portador                 ascending
          tta_cod_cart_bcia                ascending
    index tt_titulo_id                     is primary unique
          tta_cod_portador                 ascending
          tta_ind_trans_acr                ascending
          tta_cod_estab                    ascending
          tta_cod_espec_docto              ascending
          tta_cod_ser_docto                ascending
          tta_cod_tit_acr                  ascending
          tta_cod_parcela                  ascending
          tta_num_id_movto_tit_acr         ascending
          ttv_rec_movto_ocor_bcia          ascending
    .

def new shared temp-table tt_tit_acr_selec_erro_parceiro no-undo
    field tta_cod_transacao                as character format "x(10)" label "Transaá∆o" column-label "Transaá∆o"
    field tta_cdn_parcei_edi               as Integer format ">>>>>9" initial 0 label "Parceiro" column-label "Parceiro"
    field ttv_des_ajuda                    as character format "x(50)" label "Ajuda" column-label "Ajuda"
    .

def temp-table tt_tit_destinac_percent no-undo
    field tta_cod_estab                    as character format "x(5)" label "Estabelecimento" column-label "Estab"
    field tta_num_id_tit_acr               as integer format "999999999" initial 0 label "Token Cta Receber" column-label "Token Cta Receber"
    index tt_id                            is primary unique
          tta_cod_estab                    ascending
          tta_num_id_tit_acr               ascending
    .



/********************** Temporary Table Definition End **********************/

/************************** Buffer Definition Begin *************************/

&if "{&emsbas_version}" >= "1.00" &then
def buffer b_ped_exec_style
    for ped_exec.
&endif
&if "{&emsbas_version}" >= "1.00" &then
def buffer b_servid_exec_style
    for servid_exec.
&endif


/*************************** Buffer Definition End **************************/

/************************** Stream Definition Begin *************************/

def new shared stream s_1.


/*************************** Stream Definition End **************************/

/************************* Variable Definition Begin ************************/

/* Alteracao via filtro - Controle de impressao - inicio */
DEFINE VARIABLE v_page_number                   AS INTEGER INITIAL -1 NO-UNDO.
DEFINE VARIABLE v_page_number_impr              AS INTEGER INITIAL 0  NO-UNDO.
DEFINE VARIABLE v_cod_usuar_abert               AS CHARACTER          NO-UNDO.

/* Alteracao via filtro - Controle de impressao - fim    */

/* Alteracao via filtro - Impressao grandes volumes - inicio */
DEFINE VARIABLE c-servid_exec_nom_dir_spool     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-cod_dwb_user                  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-num_ped_exec                  AS INTEGER     NO-UNDO.
DEFINE VARIABLE c-usuar_mestre_nom_subdir_spool AS CHARACTER   NO-UNDO.

DEFINE BUFFER b-dwb_rpt_param FOR dwb_rpt_param.
/* Alteracao via filtro - Impressao grandes volumes - fim */


def var v_cdn_cliente_aux
    as Integer
    format ">>>,>>>,>>9":U
    label "Cliente"
    column-label "Cliente"
    no-undo.
def var v_cdn_cliente_fim
    as Integer
    format ">>>,>>>,>>9":U
    initial 999999999
    label "atÇ"
    column-label "Cliente Final"
    no-undo.
def var v_cdn_cliente_ini
    as Integer
    format ">>>,>>>,>>9":U
    initial 0
    label "Cliente"
    column-label "Cliente Inicial"
    no-undo.
def var v_cdn_repres_aux
    as Integer
    format ">>>,>>9":U
    label "Representante"
    column-label "Representante"
    no-undo.
def new global shared var v_cod_aplicat_dtsul_corren
    as character
    format "x(3)":U
    no-undo.
def var v_cod_cart_bcia
    as character
    format "x(3)":U
    label "Carteira"
    column-label "Carteira"
    no-undo.
def var v_cod_cart_bcia_1
    as character
    format "x(3)":U
    label "Carteira"
    column-label "Carteira"
    no-undo.
def var v_cod_cart_bcia_err
    as character
    format "x(3)":U
    label "Carteira"
    column-label "Carteira"
    no-undo.
def var v_cod_cart_bcia_fim
    as character
    format "x(3)":U
    initial "ZZZ"
    label "atÇ"
    column-label "Carteira"
    no-undo.
def var v_cod_cart_bcia_inicial
    as character
    format "x(3)":U
    label "Carteira Bcia"
    column-label "Carteira Bcia"
    no-undo.
def var v_cod_cart_bcia_mais_negoc
    as character
    format "x(8)":U
    no-undo.
def var v_cod_cart_bcia_portad_prefer
    as character
    format "x(3)":U
    no-undo.
def var v_cod_cart_bcia_res
    as character
    format "x(3)":U
    label "Carteira"
    column-label "Carteira"
    no-undo.
def new shared var v_cod_cart_espcif
    as character
    format "x(3)":U
    label "Cod Carteira Esp"
    no-undo.
def new global shared var v_cod_ccusto_corren
    as character
    format "x(20)":U
    label "Centro Custo"
    column-label "Centro Custo"
    no-undo.
def var v_cod_cep
    as character
    format "x(20)":U
    label "CEP"
    column-label "CEP"
    no-undo.
def new shared var v_cod_cep_dest_cobr
    as character
    format "x(20)":U
    label "CEP"
    column-label "CEP"
    no-undo.
def var v_cod_cx_post
    as character
    format "x(20)":U
    label "Cxa Postal"
    no-undo.
def var v_cod_destinac_cobr
    as character
    format "x(8)":U
    label "Destinaá∆o"
    column-label "Destinaá∆o"
    no-undo.
def new shared var v_cod_dwb_file
    as character
    format "x(40)":U
    label "Arquivo"
    column-label "Arquivo"
    no-undo.
def var v_cod_dwb_file_temp
    as character
    format "x(12)":U
    no-undo.
def var v_cod_dwb_parameters
    as character
    format "x(8)":U
    no-undo.
def var v_cod_dwb_print_layout
    as character
    format "x(8)":U
    no-undo.
def var v_cod_dwb_proced
    as character
    format "x(8)":U
    no-undo.
def new shared var v_cod_dwb_program
    as character
    format "x(32)":U
    label "Programa"
    column-label "Programa"
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
def var v_cod_espec_docto_fim
    as character
    format "x(3)":U
    initial "ZZZ"
    label "atÇ"
    column-label "C¢digo Final"
    no-undo.
def var v_cod_espec_docto_ini
    as character
    format "x(3)":U
    label "EspÇcie"
    column-label "C¢digo Inicial"
    no-undo.
def var v_cod_estab
    as character
    format "x(5)":U
    label "Estabelecimento"
    column-label "Estabelecimento"
    no-undo.
def var v_cod_estab_aux
    as character
    format "x(5)":U
    label "Estabelecimento"
    column-label "Estabelecimento"
    no-undo.
def var v_cod_estab_fim
    as character
    format "x(5)":U
    initial "ZZZZZ"
    label "atÇ"
    column-label "Estab Final"
    no-undo.
def var v_cod_estab_ini
    as character
    format "x(5)":U
    label "Estabelecimento"
    column-label "Estab Inicial"
    no-undo.
def new global shared var v_cod_estab_usuar
    as character
    format "x(5)":U
    label "Estabelecimento"
    column-label "Estab"
    no-undo.
def var v_cod_finalid_econ
    as character
    format "x(10)":U
    label "Finalidade Econìmica"
    column-label "Finalidade Econìmica"
    no-undo.
def new shared var v_cod_finalid_econ_espcif
    as character
    format "x(10)":U
    label "Finalidade"
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
def var v_cod_indic_econ_bco
    as character
    format "x(8)":U
    label "Moeda"
    column-label "Moeda"
    no-undo.
def var v_cod_indic_econ_des
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
def new global shared var v_cod_pais_empres_usuar
    as character
    format "x(3)":U
    label "Pa°s Empresa Usu†rio"
    column-label "Pa°s"
    no-undo.
def var v_cod_pais_fornec_clien
    as character
    format "x(8)":U
    no-undo.
def var v_cod_parcela_fim
    as character
    format "x(02)":U
    initial "ZZ" /*l_zz*/
    label "Parcela"
    column-label "Parcela"
    no-undo.
def var v_cod_parcela_ini
    as character
    format "x(02)":U
    label "Parcela"
    column-label "Parcela"
    no-undo.
def new global shared var v_cod_plano_ccusto_corren
    as character
    format "x(8)":U
    label "Plano CCusto"
    column-label "Plano CCusto"
    no-undo.
def var v_cod_portador
    as character
    format "x(5)":U
    label "Portador"
    column-label "Portador"
    no-undo.
def var v_cod_portador_err
    as character
    format "x(5)":U
    label "Portador"
    column-label "Portador"
    no-undo.
def var v_cod_portador_fim
    as character
    format "x(5)":U
    initial "ZZZZZ"
    label "atÇ"
    column-label "Portador Final"
    no-undo.
def var v_cod_portador_ini
    as character
    format "x(5)":U
    label "Portador"
    column-label "Portador Inicial"
    no-undo.
def var v_cod_portador_res
    as character
    format "x(5)":U
    label "Portador"
    column-label "Portador"
    no-undo.
def new shared var v_cod_portad_espcif
    as character
    format "x(5)":U
    label "Portador Esp"
    no-undo.
def var v_cod_portad_mais_negoc
    as character
    format "x(8)":U
    no-undo.
def var v_cod_refer
    as character
    format "x(10)":U
    label "Referància"
    column-label "Referància"
    no-undo.
def var v_cod_refer_fim
    as character
    format "x(10)":U
    initial "ZZZZZZZZZZ"
    label "atÇ"
    column-label "Referància Final"
    no-undo.
def var v_cod_refer_ini
    as character
    format "x(10)":U
    label "Referància"
    column-label "Referància"
    no-undo.
def new shared var v_cod_release
    as character
    format "x(12)":U
    no-undo.
def var v_cod_return
    as character
    format "x(40)":U
    no-undo.
def var v_cod_ser_docto_fim
    as character
    format "x(5)":U
    initial "ZZZZZ"
    label "atÇ"
    column-label "SÇrie"
    no-undo.
def var v_cod_ser_docto_ini
    as character
    format "x(5)":U
    label "SÇrie"
    column-label "SÇrie"
    no-undo.
def var v_cod_tit_acr_fim
    as character
    format "x(16)":U
    initial "ZZZZZZZZZZZZZZZZ"
    label "atÇ"
    column-label "atÇ"
    no-undo.
def var v_cod_tit_acr_ini
    as character
    format "x(16)":U
    label "T°tulo"
    column-label "T°tulo"
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
def var v_dat_destinac
    as date
    format "99/99/9999":U
    initial today
    label "Data Destinaá∆o"
    column-label "Data Destinaá∆o"
    no-undo.
def var v_dat_emis_final
    as date
    format "99/99/9999":U
    label "Data Emiss∆o"
    column-label "Dt Emiss"
    no-undo.
def var v_dat_emis_inic
    as date
    format "99/99/9999":U
    initial today
    label "Data Emiss∆o"
    column-label "Emiss∆o"
    no-undo.
def new shared var v_dat_execution
    as date
    format "99/99/9999":U
    no-undo.
def new shared var v_dat_execution_end
    as date
    format "99/99/9999":U
    no-undo.
def new shared var v_dat_fim_period
    as date
    format "99/99/9999":U
    label "Fim Per°odo"
    no-undo.
def var v_dat_fluxo
    as date
    format "99/99/9999":U
    no-undo.
def new shared var v_dat_inic_period
    as date
    format "99/99/9999":U
    label "In°cio Per°odo"
    column-label "Per°odo"
    no-undo.
def var v_dat_vencto_final
    as date
    format "99/99/9999":U
    initial 12/31/9999
    label "Final"
    column-label "Final"
    no-undo.
def var v_dat_vencto_inicial
    as date
    format "99/99/9999":U
    initial &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF
    label "Data Vencimento"
    column-label "Data Vencimento"
    no-undo.
def var v_des_aux_1
    as character
    format "x(40)":U
    no-undo.
def var v_des_ender_cobr
    as character
    format "x(40)":U
    no-undo.
def var v_des_mensagem
    as character
    format "x(50)":U
    view-as editor max-chars 2000 scrollbar-vertical
    size 50 by 4
    bgcolor 15 font 2
    label "Mensagem"
    column-label "Mensagem"
    no-undo.
def var v_des_obs_destinac
    as character
    format "x(350)":U
    view-as editor max-chars 2000 scrollbar-vertical
    size 70 by 5
    bgcolor 15 font 2
    label "Observaá‰es"
    column-label "Observaá‰es"
    no-undo.
def var v_des_orig_alter_portad
    as character
    format "x(40)":U
    no-undo.
def var v_des_titulo
    as character
    format "x(40)":U
    no-undo.
def new global shared var v_hdl_api_centraliz_acr_vdr
    as Handle
    format ">>>>>>9":U
    no-undo.
def var v_hdl_api_param_mais_negoc
    as Handle
    format ">>>>>>9":U
    no-undo.
def var v_hdl_existe_funcao
    as Handle
    format ">>>>>>9":U
    no-undo.
def var v_hdl_funcao_padr
    as Handle
    format ">>>>>>9":U
    no-undo.
def new shared var v_hra_execution
    as Character
    format "99:99":U
    no-undo.
def new shared var v_hra_execution_end
    as Character
    format "99:99:99":U
    label "Tempo Exec"
    no-undo.
def var v_hra_formatted_time
    as Character
    format "99:99:99":U
    no-undo.
def var v_ind_classif_destinac
    as character
    format "X(100)":U
    view-as radio-set Vertical
    radio-buttons "Estab/Portador/Carteira/Dt Emiss∆o/Dt Vencto/T°tulo/Parcela", "Estab/Portador/Carteira/Dt Emiss∆o/Dt Vencto/T°tulo/Parcela", "Estab/Portador/Carteira/Dt Emiss∆o/T°tulo/Parcela", "Estab/Portador/Carteira/Dt Emiss∆o/T°tulo/Parcela"
     /*l_vencto_tit_parc*/ /*l_vencto_tit_parc*/ /*l_emis_tit_parcela*/ /*l_emis_tit_parcela*/
    bgcolor 8 
    no-undo.
def var v_ind_dwb_run_mode
    as character
    format "X(07)":U
    initial "On-Line" /*l_online*/
    view-as radio-set Horizontal
    radio-buttons "On-Line", "On-Line", "Batch", "Batch"
     /*l_online*/ /*l_online*/ /*l_batch*/ /*l_batch*/
    bgcolor 8 
    label "Run Mode"
    column-label "Run Mode"
    no-undo.
def var v_ind_ender_complet
    as character
    format "X(20)":U
    initial "Endereáo" /*l_endereco*/
    view-as radio-set Vertical
    radio-buttons "Endereáo", "Endereáo", "Endereáo Completo", "Endereáo Completo"
     /*l_endereco*/ /*l_endereco*/ /*l_endereco_completo*/ /*l_endereco_completo*/
    bgcolor 8 
    no-undo.
def new shared var v_ind_obs
    as character
    format "X(40)":U
    view-as editor max-chars 250
    size 35 by 1
    bgcolor 15 font 2
    label "Observaá∆o"
    column-label "Observaá∆o"
    no-undo.
def var v_ind_tip_cart_bcia
    as character
    format "X(15)":U
    view-as combo-box
    &if "{&FNC_MULTI_IDIOMA}" = "YES" &then
    list-item-pairs "Portador","Portador","Desconto","Desconto","Cauá∆o","Cauá∆o","Judicial","Judicial","Representante","Representante","Carteira","Carteira","Cobrador","Cobrador","Contas a Pagar","Contas a Pagar"
    &else
    list-items "Portador","Desconto","Cauá∆o","Judicial","Representante","Carteira","Cobrador","Contas a Pagar"
    &endif
     /*l_portador*/ /*l_desconto*/ /*l_caucao*/ /*l_judicial*/ /*l_representante*/ /*l_carteira*/ /*l_cobrador*/ /*l_contas_a_pagar*/
    inner-lines 5
    bgcolor 15 font 2
    label "Tipo Carteira Bcia"
    column-label "Tipo Carteira Bcia"
    no-undo.
def var v_ind_tip_destinac
    as character
    format "X(12)":U
    initial "Destinaá∆o" /*l_destinacao*/
    view-as radio-set Horizontal
    radio-buttons "Destinaá∆o", "Destinaá∆o", "Simulaá∆o", "Simulaá∆o", "Listagem de T°tulos a Destinar", "Listagem de T°tulos a Destinar"
     /*l_destinacao*/ /*l_destinacao*/ /*l_simulacao*/ /*l_simulacao*/ /*l_listagem_de_titulos_a_destinar*/ /*l_listagem_de_titulos_a_destinar*/
    bgcolor 8 
    label "Tipo Relat¢rio"
    no-undo.
def var v_log_autoriz_cobr_cartao_cr
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_log_cart_bcia_vendor
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_log_cobr_acr_pix
    as logical
    format "Sim/N∆o"
    initial no
    view-as toggle-box
    label "Aceita Cobranáa PIX"
    column-label "Cobranáa PIX"
    no-undo.
def new global shared var v_log_cobr_acr_pix_aux
    as logical
    format "Sim/N∆o"
    initial no
    view-as toggle-box
    label "Cobranáa PIX"
    column-label "Cobranáa PIX"
    no-undo.
def var v_log_control_terc_acr
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_log_destinac
    as logical
    format "Sim/N∆o"
    initial no
    label "Destinaá∆o"
    column-label "Destinaá∆o"
    no-undo.
def var v_log_destinac_manual
    as logical
    format "Sim/N∆o"
    initial no
    view-as toggle-box
    label "Manual"
    column-label "Destinac Man"
    no-undo.
def var v_log_destinac_percent_sdo
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_log_destinac_tit_vencid
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_log_ender_cobr_contat_sco
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def new global shared var v_log_execution
    as logical
    format "Sim/N∆o"
    initial yes
    no-undo.
def var v_log_funcao_tit_nao_dest
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_log_habilit_redestina_cobr
    as logical
    format "Sim/N∆o"
    initial no
    view-as toggle-box
    label "Redestinaá∆o"
    column-label "Redestinaá∆o"
    no-undo.
def var v_log_handle
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_log_integr_mais_negoc
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_log_method
    as logical
    format "Sim/N∆o"
    initial yes
    no-undo.
def var v_log_modul_vendor
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_log_parc_cartcred
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_log_pessoa_fisic_cobr
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_log_planilha
    as logical
    format "Sim/N∆o"
    initial NO
    no-undo.
def var v_log_print
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_log_print_par
    as logical
    format "Sim/N∆o"
    initial yes
    view-as toggle-box
    no-undo.
def var v_log_tit_nao_destndo
    as logical
    format "Sim/N∆o"
    initial yes
    view-as toggle-box
    label "Listar Tit N∆o Dest"
    no-undo.
def var v_log_tit_vendor
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_log_validac_cep
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_log_verifica_praz_auto_emis
    as logical
    format "Sim/N∆o"
    initial yes
    view-as toggle-box
    label "Prazo Auto Emiss∆o"
    column-label "Pr Auto Emis"
    no-undo.
def var v_nom_abrev
    as character
    format "x(15)":U
    label "Nome Abreviado"
    column-label "Nome Abrev"
    no-undo.
def var v_nom_abrev_contat_aux
    as character
    format "x(15)":U
    label "Abreviado Contato"
    column-label "Abreviado Contato"
    no-undo.
def var v_nom_bairro
    as character
    format "x(20)":U
    label "Bairro"
    column-label "Bairro"
    no-undo.
def var v_nom_cidade
    as character
    format "x(32)":U
    label "Cidade"
    column-label "Cidade"
    no-undo.
def var v_nom_condado
    as character
    format "x(32)":U
    label "Condado"
    column-label "Condado"
    no-undo.
def var v_nom_dwb_printer
    as character
    format "x(30)":U
    no-undo.
def var v_nom_dwb_print_file
    as character
    format "x(100)":U
    label "Arquivo Impress∆o"
    column-label "Arq Impr"
    no-undo.
def var v_nom_endereco
    as character
    format "x(40)":U
    label "Endereáo"
    column-label "Endereáo"
    no-undo.
def var v_nom_ender_compl
    as character
    format "x(10)":U
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
def new shared var v_nom_enterprise
    as character
    format "x(40)":U
    no-undo.
def var v_nom_integer
    as character
    format "x(30)":U
    no-undo.
def var v_nom_prog_appc
    as character
    format "x(50)":U
    label "Programa APPC"
    column-label "Programa APPC"
    no-undo.
def var v_nom_prog_dpc
    as character
    format "x(50)":U
    label "Programa Dpc"
    column-label "Programa Dpc"
    no-undo.
def new shared var v_nom_prog_ext
    as character
    format "x(8)":U
    label "Nome Externo"
    no-undo.
def var v_nom_prog_upc
    as character
    format "X(50)":U
    label "Programa UPC"
    column-label "Programa UPC"
    no-undo.
def new shared var v_nom_report_title
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
def var v_num_contador
    as integer
    format ">>>>,>>9":U
    initial 0
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
def new shared var v_num_entry
    as integer
    format ">>>>,>>9":U
    label "Ordem"
    column-label "Ordem"
    no-undo.
def var v_num_nao_destndo
    as integer
    format ">>>>,>>9":U
    initial 0
    label "Nao Destinados"
    column-label "Nao!Destinados"
    no-undo.
def var v_num_ord_destinac_err
    as integer
    format ">>>>,>>9":U
    label "Ordem Destinaá∆o"
    column-label "Ordem Destinaá∆o"
    no-undo.
def new shared var v_num_page_number
    as integer
    format ">>>>>9":U
    label "P†gina"
    column-label "P†gina"
    no-undo.
def var v_num_ped_exec
    as integer
    format ">>>>9":U
    label "Pedido"
    column-label "Pedido"
    no-undo.
def new global shared var v_num_ped_exec_corren
    as integer
    format ">>>>9":U
    no-undo.
def var v_num_pessoa_jurid
    as integer
    format ">>>,>>>,>>9":U
    label "Pessoa Jur°dica"
    column-label "Pessoa Jur°dica"
    no-undo.
def var v_num_tot_geral
    as integer
    format ">>>>,>>9":U
    no-undo.
def var v_qtd_bottom
    as decimal
    format ">>9":U
    decimals 0
    no-undo.
def var v_qtd_column
    as decimal
    format ">>9":U
    decimals 0
    label "Colunas"
    column-label "Colunas"
    no-undo.
def var v_qtd_line
    as decimal
    format ">>9":U
    decimals 0
    label "Linhas"
    column-label "Linhas"
    no-undo.
def var v_qtd_line_ant
    as decimal
    format "->>>>,>>9.9999":U
    decimals 4
    no-undo.
def new global shared var v_rec_cart_bcia
    as recid
    format ">>>>>>9":U
    initial ?
    no-undo.
def new global shared var v_rec_clien_financ
    as recid
    format ">>>>>>9":U
    initial ?
    no-undo.
def new global shared var v_rec_destinac_cobr
    as recid
    format ">>>>>>9":U
    initial ?
    no-undo.
def new global shared var v_rec_estabelecimento
    as recid
    format ">>>>>>9":U
    no-undo.
def var v_rec_log
    as recid
    format ">>>>>>9":U
    no-undo.
def var v_rec_table_epc
    as recid
    format ">>>>>>9":U
    no-undo.
def new global shared var v_rec_tit_acr
    as recid
    format ">>>>>>9":U
    no-undo.
def var v_val_atraso_med_clien
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_val_destinac_portad
    as decimal
    format ">>>,>>>,>>9.99":U
    decimals 2
    label "Valor Destinado"
    column-label "Valor Destinado"
    no-undo.
def var v_val_meta_destinac
    as decimal
    format ">>>,>>>,>>>,>>9.99":U
    decimals 2
    label "Meta Destinaá∆o"
    column-label "Meta Destinaá∆o"
    no-undo.
def new shared var v_val_retenc_impto_esp
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    initial 0
    no-undo.
def var v_val_sdo_cobr
    as decimal
    format ">>>>,>>>,>>9.99":U
    decimals 2
    label "Saldo Cobranáa"
    column-label "Saldo Cobranáa"
    no-undo.
def var v_val_sdo_cobr_ant
    as decimal
    format ">>>,>>>,>>9.99":U
    decimals 2
    label "Saldo Cobr Anter"
    column-label "Saldo Cobr Anter"
    no-undo.
def var v_val_sdo_fim
    as decimal
    format ">>>,>>>,>>9.99":U
    decimals 2
    initial 999999999.99
    label "atÇ"
    no-undo.
def var v_val_sdo_inic
    as decimal
    format ">>>,>>>,>>9.99":U
    decimals 2
    label "Saldo"
    column-label "Saldo"
    no-undo.
def var v_val_tot
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    initial 0
    label "Total Geral"
    column-label "Total Geral"
    no-undo.
def var v_val_tot_cart_bcia
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    label "Total Cart. Banc†ria"
    column-label "Total Cart !Banc†ria"
    no-undo.
def var v_val_tot_cobr
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_val_tot_cust
    as decimal
    format ">>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_val_tot_dest
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    no-undo.
def var v_val_tot_destinac
    as decimal
    format ">>>,>>>,>>9.99":U
    decimals 2
    label "Total Destinado"
    column-label "Total Destinado"
    no-undo.
def var v_val_tot_portad
    as decimal
    format "->>,>>>,>>>,>>9.99":U
    decimals 2
    label "Total do Portador"
    column-label "Total do Portador"
    no-undo.
def var v_wgh_focus
    as widget-handle
    format ">>>>>>9":U
    no-undo.
def var v_wgh_frame_epc
    as widget-handle
    format ">>>>>>9":U
    no-undo.


/************************** Variable Definition End *************************/

/*************************** Menu Definition Begin **************************/

.

def menu      m_help                menubar
    menu-item mi_conteudo           label "&Conte£do"
    menu-item mi_sobre              label "&Sobre".



/**************************** Menu Definition End ***************************/

/************************ Rectangle Definition Begin ************************/

def rectangle rt_003
    size 1 by 1
    edge-pixels 2.
def rectangle rt_004
    size 1 by 1
    edge-pixels 2.
def rectangle rt_005
    size 1 by 1
    edge-pixels 2.
def rectangle rt_006
    size 1 by 1
    edge-pixels 2.
def rectangle rt_007
    size 1 by 1
    edge-pixels 2.
def rectangle rt_008
    size 1 by 1
    edge-pixels 2.
def rectangle rt_009
    size 1 by 1
    edge-pixels 2.
def rectangle rt_010
    size 1 by 1
    edge-pixels 2.
def rectangle rt_cxcf
    size 1 by 1
    fgcolor 1 edge-pixels 2.
def rectangle rt_dimensions
    size 1 by 1
    edge-pixels 2.
def rectangle rt_mold
    size 1 by 1
    edge-pixels 2.
def rectangle rt_run
    size 1 by 1
    edge-pixels 2.
def rectangle rt_target
    size 1 by 1
    edge-pixels 2.


/************************* Rectangle Definition End *************************/

/************************** Button Definition Begin *************************/

def button bt_can
    label "Cancela"
    tooltip "Cancela"
    size 1 by 1
    auto-endkey.
def button bt_close
    label "&Fecha"
    tooltip "Fecha"
    size 1 by 1
    auto-go.
def button bt_get_file
    label "Pesquisa Arquivo"
    tooltip "Pesquisa Arquivo"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-sea1"
    image-insensitive file "image/ii-sea1"
&endif
    size 1 by 1.
def button bt_hel2
    label "Ajuda"
    tooltip "Ajuda"
    size 1 by 1.
def button bt_ok
    label "OK"
    tooltip "OK"
    size 1 by 1
    auto-go.
def button bt_print
    label "&Imprime"
    tooltip "Imprime"
    size 1 by 1
    auto-go.
def button bt_ran2
    label "Faixa"
    tooltip "Faixa"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-ran"
    image-insensitive file "image/ii-ran"
&endif
    size 1 by 1.
def button bt_set_printer
    label "Define Impressora e Layout"
    tooltip "Define Impressora e Layout de Impress∆o"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-setpr.bmp"
    image-insensitive file "image/ii-setpr"
&endif
    size 1 by 1.
/****************************** Function Button *****************************/
def button bt_zoo_221588
    label "Zoom"
    tooltip "Zoom"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-zoo"
    image-insensitive file "image/ii-zoo"
&endif
    size 4 by .88.
def button bt_zoo_221698
    label "Zoom"
    tooltip "Zoom"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-zoo"
    image-insensitive file "image/ii-zoo"
&endif
    size 4 by .88.
def button bt_zoo_221699
    label "Zoom"
    tooltip "Zoom"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-zoo"
    image-insensitive file "image/ii-zoo"
&endif
    size 4 by .88.
def button bt_zoo_282498
    label "Zoom"
    tooltip "Zoom"
&if "{&window-system}" <> "TTY" &then
    image-up file "image/im-zoo"
    image-insensitive file "image/ii-zoo"
&endif
    size 4 by .88.


/*************************** Button Definition End **************************/

/************************** Editor Definition Begin *************************/

def var ed_1x40
    as character
    view-as editor no-word-wrap
    size 40 by 1
    bgcolor 15 font 2
    no-undo.


/*************************** Editor Definition End **************************/

/************************ Radio-Set Definition Begin ************************/

def var rs_cod_dwb_output
    as character
    initial "Terminal"
    view-as radio-set Horizontal
    radio-buttons "Terminal", "Terminal", "Arquivo", "Arquivo", "Impressora", "Impressora"
     /*l_terminal*/ /*l_terminal*/ /*l_file*/ /*l_file*/ /*l_printer*/ /*l_printer*/
    bgcolor 8 
    no-undo.
def var rs_imforma_cart_bcia
    as character
    initial "Carteira"
    view-as radio-set Vertical
    radio-buttons "Carteira", "Carteira", "Tipo Carteira", "Tipo Carteira", "Cliente Financeiro", "Cliente Financeiro"
     /*l_carteira*/ /*l_carteira*/ /*l_tipo_carteira*/ /*l_tipo_carteira*/ /*l_cliente_financeiro*/ /*l_cliente_financeiro*/
    bgcolor 8 
    no-undo.
def var rs_ind_run_mode
    as character
    initial "On-Line"
    view-as radio-set Horizontal
    radio-buttons "On-Line", "On-Line", "Batch", "Batch"
     /*l_online*/ /*l_online*/ /*l_batch*/ /*l_batch*/
    bgcolor 8 
    no-undo.


/************************* Radio-Set Definition End *************************/

/************************** Report Definition Begin *************************/

def new shared var v_rpt_s_1_lines as integer initial 66.
def new shared var v_rpt_s_1_columns as integer initial 215.
def new shared var v_rpt_s_1_bottom as integer initial 65.
def new shared var v_rpt_s_1_page as integer.
def new shared var v_rpt_s_1_name as character initial "Destinaá∆o de Cobranáa".
assign v_rpt_s_1_name = getStrTrans(v_rpt_s_1_name, "ACR").
def frame f_rpt_s_1_header_period header
    "------------------------------------------------------------" at 1
    "------------------------------------------------------------" at 61
    "------------------------------------------------------------" at 121
    "------------------" at 181
    "--" at 199
    "P†gina: " at 202
    (page-number (s_1) + v_rpt_s_1_page) to 215 format ">>>>>9" skip
    v_nom_enterprise at 1 format "x(40)"
    v_nom_report_title at 176 format "x(40)" skip
    "Per°odo: " at 1
    v_dat_inic_period at 10 format "99/99/9999"
    "a" at 21
    v_dat_fim_period at 23 format "99/99/9999"
    "------------------------------------------------------------" at 34
    "------------------------------------------------------------" at 94
    "----------------------------------------" at 154
    "---" at 194
    v_dat_execution at 198 format "99/99/9999"
    "-" at 209
    v_hra_execution at 211 format "99:99" skip (1)
    with no-box no-labels width 215 page-top stream-io.
def frame f_rpt_s_1_header_unique header
    "------------------------------------------------------------" at 1
    "------------------------------------------------------------" at 61
    "------------------------------------------------------------" at 121
    "------------------" at 181
    "--" at 199
    "P†gina: " at 202
    (page-number (s_1) + v_rpt_s_1_page) to 215 format ">>>>>9" skip
    v_nom_enterprise at 1 format "x(40)"
    fill(" ", 40 - length(trim(v_nom_report_title))) + trim(v_nom_report_title) to 215 format "x(40)" skip
    "------------------------------------------------------------" at 1
    "------------------------------------------------------------" at 61
    "------------------------------------------------------------" at 121
    "----------" at 181
    "------" at 191
    v_dat_execution at 198 format "99/99/9999"
    "-" at 209
    v_hra_execution at 211 format "99:99" skip (1)
    with no-box no-labels width 215 page-top stream-io.
def frame f_rpt_s_1_footer_last_page header
    skip (1)
    "Èltima p†gina" at 1
    "------------------------------------------------------------" at 15
    "---------------------------------------------------------" at 75
    "------------------------------------------------------------" at 132
    v_nom_prog_ext at 193 format "x(8)"
    "-" at 202
    v_cod_release at 204 format "x(12)" skip
    with no-box no-labels width 215 page-bottom stream-io.
def frame f_rpt_s_1_footer_normal header
    skip (1)
    "---------------------------------------------------------" at 1
    "------------------------------------------------------------" at 58
    "------------------------------------------------------------" at 118
    "----------" at 178
    "----" at 188
    v_nom_prog_ext at 193 format "x(8)"
    "-" at 202
    v_cod_release at 204 format "x(12)" skip
    with no-box no-labels width 215 page-bottom stream-io.
def frame f_rpt_s_1_footer_param_page header
    skip (1)
    "P†gina ParÉmetros" at 1
    "------------------------------------------------------" at 22
    "------------------------------------------------------------" at 76
    "--------------------------------------------------" at 136
    "------" at 186
    v_nom_prog_ext at 193 format "x(8)"
    "-" at 202
    v_cod_release at 204 format "x(12)" skip
    with no-box no-labels width 215 page-bottom stream-io.
def frame f_rpt_s_1_Grp_classif_Lay_classif header
    "Ordem" to 55
    "Classificador" at 57 skip
    "--------" to 55
    "--------------------------------" at 57 skip
    with no-box no-labels width 215 page-top stream-io.
def frame f_rpt_s_1_Grp_detalhe_Lay_a_dest header
    "Est" at 1
    "Esp" at 7
    "SÇrie" at 11
    "T°tulo" at 17
    "/P" at 34
    "Cliente" to 47
    "Nome Abrev" at 49
    "Cidade" at 65
    "Emiss∆o" at 98
    "Vencto" at 109
    "Saldo" to 133 skip
    "-----" at 1
    "---" at 7
    "-----" at 11
    "----------------" at 17
    "--" at 34
    "-----------" to 47
    "---------------" at 49
    "--------------------------------" at 65
    "----------" at 98
    "----------" at 109
    "--------------" to 133 skip
    with no-box no-labels width 215 page-top stream-io.
def frame f_rpt_s_1_Grp_detalhe_Lay_dest_port header
    "Estab" at 1
    "Esp" at 7
    "SÇrie" at 11
    "T°tulo" at 17
    "/P" at 34
    "Cliente" to 47
    "Nome Abrev" at 49
    "Cidade" at 65
    "Emiss∆o" at 98
    "Vencto" at 109
    "Saldo T°tulo" to 133
    "Ordem" to 142
    "Port" at 144
    "Cart" at 150
    "Observaá‰es" at 155 skip
    "-----" at 1
    "---" at 7
    "-----" at 11
    "----------------" at 17
    "--" at 34
    "-----------" to 47
    "---------------" at 49
    "--------------------------------" at 65
    "----------" at 98
    "----------" at 109
    "--------------" to 133
    "--------" to 142
    "-----" at 144
    "----" at 150
    "-------------------------------------------------------------" at 155 skip
    with no-box no-labels width 215 page-top stream-io.
def frame f_rpt_s_1_Grp_detalhe_Lay_erros header
    "Ordem" to 142
    "Port" at 144
    "Cart" at 150
    "Observaá‰es" at 155 skip
    "--------" to 142
    "-----" at 144
    "----" at 150
    "-------------------------------------------------------------" at 155 skip
    with no-box no-labels width 215 page-top stream-io.
def frame f_rpt_s_1_Grp_detalhe_Lay_resumo_port header
    "Port" at 1
    "Cart" at 7
    "Quantidade" to 21
    "Vl Destinado" to 36
    "Custo" to 51
    "% Custo" to 59
    "Sdo Cobr Ant" to 78
    "Saldo Cobranáa" to 97
    "Meta Dest" to 116
    "Observaá‰es" at 118 skip
    "-----" at 1
    "----" at 7
    "----------" to 21
    "--------------" to 36
    "--------------" to 51
    "-------" to 59
    "------------------" to 78
    "------------------" to 97
    "------------------" to 116
    "---------------------------" at 118 skip
    with no-box no-labels width 215 page-top stream-io.
def frame f_rpt_s_1_Grp_detalhe_Lay_tit_dest header
    "Est" at 1
    "Esp" at 7
    "SÇrie" at 11
    "T°tulo" at 17
    "/P" at 34
    "Cliente" to 47
    "Nome Abrev" at 49
    "Cidade" at 65
    "Emiss∆o" at 98
    "Vencto" at 109
    "Saldo" to 133
    "Observaá‰es" at 135 skip
    "-----" at 1
    "---" at 7
    "-----" at 11
    "----------------" at 17
    "--" at 34
    "-----------" to 47
    "---------------" at 49
    "--------------------------------" at 65
    "----------" at 98
    "----------" at 109
    "--------------" to 133
    "---------------------------------------------------------" at 135 skip
    with no-box no-labels width 215 page-top stream-io.
def frame f_rpt_s_1_Grp_erro_parcei_Lay_erro_parcei header
    /* Atributo tt_tit_acr_selec_erro_parceiro.tta_cod_transacao ignorado */
    /* Atributo tt_tit_acr_selec_erro_parceiro.tta_cdn_parcei_edi ignorado */
    /* Atributo tt_tit_acr_selec_erro_parceiro.ttv_des_ajuda ignorado */ skip (2)
    with no-box no-labels width 215 page-top stream-io.
def frame f_rpt_s_1_Grp_param_Lay_param header
    /* Atributo destinac_cobr.cod_destinac_cobr ignorado */
    /* Atributo destinac_cobr.des_destinac_cobr ignorado */
    skip (1)
    "Data Destinaá∆o: " at 27
    v_dat_destinac at 44 format "99/99/9999" view-as text skip
    "Tipo Relat¢rio: " at 28
    v_ind_tip_destinac at 44 format "X(12)" view-as text skip
    "Redestinaá∆o: " at 30
    v_log_habilit_redestina_cobr at 44 format "Sim/N∆o" view-as text skip
    "Manual: " at 36
    v_log_destinac_manual at 44 format "Sim/N∆o" view-as text skip
    "Observaá∆o: " at 32
    entry(1, return-value, chr(255)) at 44 format "x(35)"
    skip (1)
    "--------------- Faixa Destinaá∆o ---------------" at 34
    skip (1)
    "Estabelecimento: " at 35
    v_cod_estab_ini at 52 format "x(5)" view-as text
    "atÇ: " at 69
    v_cod_estab_fim at 74 format "x(5)" view-as text skip
    "Data Emiss∆o: " at 38
    v_dat_emis_inic at 52 format "99/99/9999" view-as text
    "atÇ: " at 69
    v_dat_emis_final at 74 format "99/99/9999" view-as text skip
    "Data Vencimento: " at 35
    v_dat_vencto_inicial at 52 format "99/99/9999" view-as text
    "atÇ: " at 69
    v_dat_vencto_final at 74 format "99/99/9999" view-as text skip
    "Referància: " at 40
    v_cod_refer_ini at 52 format "x(10)" view-as text
    "atÇ: " at 69
    v_cod_refer_fim at 74 format "x(10)" view-as text skip
    "Portador: " at 42
    v_cod_portador_ini at 52 format "x(5)" view-as text
    "atÇ: " at 69
    v_cod_portador_fim at 74 format "x(5)" view-as text skip
    "Cliente: " at 43
    v_cdn_cliente_ini to 62 format ">>>,>>>,>>9" view-as text
    "atÇ: " at 69
    v_cdn_cliente_fim to 84 format ">>>,>>>,>>9" view-as text skip
    "Carteira Bcia: " at 37
    v_cod_cart_bcia_inicial at 52 format "x(3)" view-as text
    "atÇ: " at 69
    v_cod_cart_bcia_fim at 74 format "x(3)" view-as text skip
    "EspÇcie: " at 43
    v_cod_espec_docto_ini at 52 format "x(3)" view-as text
    "atÇ: " at 69
    v_cod_espec_docto_fim at 74 format "x(3)" view-as text skip
    "SÇrie: " at 45
    v_cod_ser_docto_ini at 52 format "x(5)" view-as text
    "atÇ: " at 69
    v_cod_ser_docto_fim at 74 format "x(5)" view-as text skip
    "T°tulo: " at 44
    v_cod_tit_acr_ini at 52 format "x(16)" view-as text
    "atÇ: " at 69
    v_cod_tit_acr_fim at 74 format "x(16)" view-as text skip
    "Parcela: " at 43
    v_cod_parcela_ini at 52 format "x(02)" view-as text
    "atÇ: " at 69
    v_cod_parcela_fim at 74 format "x(02)" view-as text skip
    with no-box no-labels width 215 page-top stream-io.
def frame f_rpt_s_1_Grp_param_Lay_param_func header
    /* Atributo destinac_cobr.cod_destinac_cobr ignorado */
    /* Atributo destinac_cobr.des_destinac_cobr ignorado */
    skip (1)
    "Data Destinaá∆o: " at 27
    v_dat_destinac at 44 format "99/99/9999" view-as text skip
    "Tipo Relat¢rio: " at 28
    v_ind_tip_destinac at 44 format "X(12)" view-as text skip
    "Redestinaá∆o: " at 30
    v_log_habilit_redestina_cobr at 44 format "Sim/N∆o" view-as text skip
    "Manual: " at 36
    v_log_destinac_manual at 44 format "Sim/N∆o" view-as text skip
    "Listar Tit N∆o Dest: " at 23
    v_log_tit_nao_destndo at 44 format "Sim/N∆o" view-as text skip
    "Observaá∆o: " at 32
    entry(1, return-value, chr(255)) at 44 format "x(35)"
    skip (1)
    "--------------- Faixa Destinaá∆o ---------------" at 34
    skip (1)
    "Estabelecimento: " at 35
    v_cod_estab_ini at 52 format "x(5)" view-as text
    "atÇ: " at 69
    v_cod_estab_fim at 74 format "x(5)" view-as text skip
    "Data Emiss∆o: " at 38
    v_dat_emis_inic at 52 format "99/99/9999" view-as text
    "atÇ: " at 69
    v_dat_emis_final at 74 format "99/99/9999" view-as text skip
    "Data Vencimento: " at 35
    v_dat_vencto_inicial at 52 format "99/99/9999" view-as text
    "atÇ: " at 69
    v_dat_vencto_final at 74 format "99/99/9999" view-as text skip
    "Referància: " at 40
    v_cod_refer_ini at 52 format "x(10)" view-as text
    "atÇ: " at 69
    v_cod_refer_fim at 74 format "x(10)" view-as text skip
    "Portador: " at 42
    v_cod_portador_ini at 52 format "x(5)" view-as text
    "atÇ: " at 69
    v_cod_portador_fim at 74 format "x(5)" view-as text skip
    "Cliente: " at 43
    v_cdn_cliente_ini to 62 format ">>>,>>>,>>9" view-as text
    "atÇ: " at 69
    v_cdn_cliente_fim to 84 format ">>>,>>>,>>9" view-as text skip
    "Carteira Bcia: " at 37
    v_cod_cart_bcia_inicial at 52 format "x(3)" view-as text
    "atÇ: " at 69
    v_cod_cart_bcia_fim at 74 format "x(3)" view-as text skip
    "EspÇcie: " at 43
    v_cod_espec_docto_ini at 52 format "x(3)" view-as text
    "atÇ: " at 69
    v_cod_espec_docto_fim at 74 format "x(3)" view-as text skip
    "SÇrie: " at 45
    v_cod_ser_docto_ini at 52 format "x(5)" view-as text
    "atÇ: " at 69
    v_cod_ser_docto_fim at 74 format "x(5)" view-as text skip
    "T°tulo: " at 44
    v_cod_tit_acr_ini at 52 format "x(16)" view-as text
    "atÇ: " at 69
    v_cod_tit_acr_fim at 74 format "x(16)" view-as text skip
    "Parcela: " at 43
    v_cod_parcela_ini at 52 format "x(02)" view-as text
    "atÇ: " at 69
    v_cod_parcela_fim at 74 format "x(02)" view-as text skip
    with no-box no-labels width 215 page-top stream-io.
def frame f_rpt_s_1_Grp_param_Lay_param_pix header
    /* Atributo destinac_cobr.cod_destinac_cobr ignorado */
    /* Atributo destinac_cobr.des_destinac_cobr ignorado */
    skip (1)
    "Data Destinaá∆o: " at 27
    v_dat_destinac at 44 format "99/99/9999" view-as text skip
    "Tipo Relat¢rio: " at 28
    v_ind_tip_destinac at 44 format "X(12)" view-as text skip
    "Redestinaá∆o: " at 30
    v_log_habilit_redestina_cobr at 44 format "Sim/N∆o" view-as text skip
    "Manual: " at 36
    v_log_destinac_manual at 44 format "Sim/N∆o" view-as text skip
    "Aceita Cobranáa PIX: " at 23
    v_log_cobr_acr_pix at 44 format "Sim/N∆o" view-as text skip
    "Observaá∆o: " at 32
    entry(1, return-value, chr(255)) at 44 format "x(35)"
    skip (1)
    "--------------- Faixa Destinaá∆o ---------------" at 34
    skip (1)
    "Estabelecimento: " at 35
    v_cod_estab_ini at 52 format "x(5)" view-as text
    "atÇ: " at 69
    v_cod_estab_fim at 74 format "x(5)" view-as text skip
    "Data Emiss∆o: " at 38
    v_dat_emis_inic at 52 format "99/99/9999" view-as text
    "atÇ: " at 69
    v_dat_emis_final at 74 format "99/99/9999" view-as text skip
    "Data Vencimento: " at 35
    v_dat_vencto_inicial at 52 format "99/99/9999" view-as text
    "atÇ: " at 69
    v_dat_vencto_final at 74 format "99/99/9999" view-as text skip
    "Referància: " at 40
    v_cod_refer_ini at 52 format "x(10)" view-as text
    "atÇ: " at 69
    v_cod_refer_fim at 74 format "x(10)" view-as text skip
    "Portador: " at 42
    v_cod_portador_ini at 52 format "x(5)" view-as text
    "atÇ: " at 69
    v_cod_portador_fim at 74 format "x(5)" view-as text skip
    "Cliente: " at 43
    v_cdn_cliente_ini to 62 format ">>>,>>>,>>9" view-as text
    "atÇ: " at 69
    v_cdn_cliente_fim to 84 format ">>>,>>>,>>9" view-as text skip
    "Carteira Bcia: " at 37
    v_cod_cart_bcia_inicial at 52 format "x(3)" view-as text
    "atÇ: " at 69
    v_cod_cart_bcia_fim at 74 format "x(3)" view-as text skip
    "EspÇcie: " at 43
    v_cod_espec_docto_ini at 52 format "x(3)" view-as text
    "atÇ: " at 69
    v_cod_espec_docto_fim at 74 format "x(3)" view-as text skip
    "SÇrie: " at 45
    v_cod_ser_docto_ini at 52 format "x(5)" view-as text
    "atÇ: " at 69
    v_cod_ser_docto_fim at 74 format "x(5)" view-as text skip
    "T°tulo: " at 44
    v_cod_tit_acr_ini at 52 format "x(16)" view-as text
    "atÇ: " at 69
    v_cod_tit_acr_fim at 74 format "x(16)" view-as text skip
    "Parcela: " at 43
    v_cod_parcela_ini at 52 format "x(02)" view-as text
    "atÇ: " at 69
    v_cod_parcela_fim at 74 format "x(02)" view-as text skip
    with no-box no-labels width 215 page-top stream-io.
def frame f_rpt_s_1_Grp_param_Lay_param_pix2 header
    /* Atributo destinac_cobr.cod_destinac_cobr ignorado */
    /* Atributo destinac_cobr.des_destinac_cobr ignorado */
    skip (1)
    "Data Destinaá∆o: " at 27
    v_dat_destinac at 44 format "99/99/9999" view-as text skip
    "Tipo Relat¢rio: " at 28
    v_ind_tip_destinac at 44 format "X(12)" view-as text skip
    "Redestinaá∆o: " at 30
    v_log_habilit_redestina_cobr at 44 format "Sim/N∆o" view-as text skip
    "Manual: " at 36
    v_log_destinac_manual at 44 format "Sim/N∆o" view-as text skip
    "Listar Tit N∆o Dest: " at 23
    v_log_tit_nao_destndo at 44 format "Sim/N∆o" view-as text skip
    "Aceita Cobranáa PIX: " at 23
    v_log_cobr_acr_pix at 44 format "Sim/N∆o" view-as text skip
    "Observaá∆o: " at 32
    entry(1, return-value, chr(255)) at 44 format "x(35)"
    skip (1)
    "--------------- Faixa Destinaá∆o ---------------" at 34
    skip (1)
    "Estabelecimento: " at 35
    v_cod_estab_ini at 52 format "x(5)" view-as text
    "atÇ: " at 69
    v_cod_estab_fim at 74 format "x(5)" view-as text skip
    "Data Emiss∆o: " at 38
    v_dat_emis_inic at 52 format "99/99/9999" view-as text
    "atÇ: " at 69
    v_dat_emis_final at 74 format "99/99/9999" view-as text skip
    "Data Vencimento: " at 35
    v_dat_vencto_inicial at 52 format "99/99/9999" view-as text
    "atÇ: " at 69
    v_dat_vencto_final at 74 format "99/99/9999" view-as text skip
    "Referància: " at 40
    v_cod_refer_ini at 52 format "x(10)" view-as text
    "atÇ: " at 69
    v_cod_refer_fim at 74 format "x(10)" view-as text skip
    "Portador: " at 42
    v_cod_portador_ini at 52 format "x(5)" view-as text
    "atÇ: " at 69
    v_cod_portador_fim at 74 format "x(5)" view-as text skip
    "Cliente: " at 43
    v_cdn_cliente_ini to 62 format ">>>,>>>,>>9" view-as text
    "atÇ: " at 69
    v_cdn_cliente_fim to 84 format ">>>,>>>,>>9" view-as text skip
    "Carteira Bcia: " at 37
    v_cod_cart_bcia_inicial at 52 format "x(3)" view-as text
    "atÇ: " at 69
    v_cod_cart_bcia_fim at 74 format "x(3)" view-as text skip
    "EspÇcie: " at 43
    v_cod_espec_docto_ini at 52 format "x(3)" view-as text
    "atÇ: " at 69
    v_cod_espec_docto_fim at 74 format "x(3)" view-as text skip
    "SÇrie: " at 45
    v_cod_ser_docto_ini at 52 format "x(5)" view-as text
    "atÇ: " at 69
    v_cod_ser_docto_fim at 74 format "x(5)" view-as text skip
    "T°tulo: " at 44
    v_cod_tit_acr_ini at 52 format "x(16)" view-as text
    "atÇ: " at 69
    v_cod_tit_acr_fim at 74 format "x(16)" view-as text skip
    "Parcela: " at 43
    v_cod_parcela_ini at 52 format "x(02)" view-as text
    "atÇ: " at 69
    v_cod_parcela_fim at 74 format "x(02)" view-as text skip
    with no-box no-labels width 215 page-top stream-io.
def frame f_rpt_s_1_Grp_quebra_Lay_blank header skip (1)
    with no-box no-labels width 215 page-top stream-io.
def frame f_rpt_s_1_Grp_quebra_Lay_cart_bcia header
    /* Atributo tt_rpt_tit_acr_destinac.tta_cod_cart_bcia ignorado */
    "-" at 25
    /* Atributo cart_bcia.des_cart_bcia ignorado */ skip (1)
    with no-box no-labels width 215 page-top stream-io.
def frame f_rpt_s_1_Grp_quebra_Lay_padrao header
    v_des_titulo at 1 format "x(60)" view-as text
    /* Atributo destinac_cobr.cod_destinac_cobr ignorado */
    skip (1)
    v_des_aux_1 at 33 format "x(40)" view-as text
    /* Atributo destinac_cobr.cod_finalid_econ ignorado */ skip (2)
    with no-box no-labels width 215 page-top stream-io.
def frame f_rpt_s_1_Grp_quebra_Lay_portad header
    /* Atributo tt_rpt_tit_acr_destinac.tta_cod_portador ignorado */
    skip (1)
    "-" at 24
    /* Atributo portador.nom_pessoa ignorado */ skip
    with no-box no-labels width 215 page-top stream-io.
def frame f_rpt_s_1_Grp_quebra_Lay_tot_cart header
    "--------------" at 120 skip
    "Total Cart. Banc†ria: " at 94
    v_val_tot_cart_bcia to 133 format "->>,>>>,>>>,>>9.99" view-as text
    "-" at 135
    v_num_count to 144 format ">>>>,>>9" view-as text
    "T°tulo(s)  " at 146 skip
    with no-box no-labels width 215 page-top stream-io.
def frame f_rpt_s_1_Grp_quebra_Lay_tot_destin header
    "--------------" at 120 skip
    "Total Geral: " at 103
    v_val_tot to 133 format "->>,>>>,>>>,>>9.99" view-as text
    "-" at 135
    v_num_tot_geral to 144 format ">>>>,>>9" view-as text
    "T°tulo(s)  " at 146 skip
    with no-box no-labels width 215 page-top stream-io.
def frame f_rpt_s_1_Grp_quebra_Lay_tot_portad header
    "Total do Portador: " at 97
    v_val_tot_portad to 133 format "->>,>>>,>>>,>>9.99" view-as text
    "-" at 135
    v_num_contador to 144 format ">>>>,>>9" view-as text
    "T°tulo(s)  " at 146 skip
    with no-box no-labels width 215 page-top stream-io.
def frame f_rpt_s_1_Grp_quebra_Lay_tot_resumo header
    "--------------" at 23
    "--------------" at 38
    "------------------" at 61
    "------------------" at 80
    "------------------" at 99 skip
    "Totais:  " at 1
    v_val_tot_destinac to 36 format ">>>,>>>,>>9.99" view-as text
    v_val_tot_cust to 51 format ">>>,>>>,>>9.99" view-as text
    v_val_sdo_cobr_ant to 78 format ">>>,>>>,>>>,>>9.99" view-as text
    v_val_sdo_cobr to 97 format ">>>,>>>,>>>,>>9.99" view-as text
    v_val_meta_destinac to 116 format ">>>,>>>,>>>,>>9.99" view-as text skip
    with no-box no-labels width 215 page-top stream-io.


{include/i_trdfrm.i f_rpt_s_1_footer_last_page f_rpt_s_1_footer_normal f_rpt_s_1_footer_param_page f_rpt_s_1_Grp_classif_Lay_classif f_rpt_s_1_Grp_detalhe_Lay_a_dest f_rpt_s_1_Grp_detalhe_Lay_dest_port f_rpt_s_1_Grp_detalhe_Lay_erros f_rpt_s_1_Grp_detalhe_Lay_resumo_port f_rpt_s_1_Grp_detalhe_Lay_tit_dest f_rpt_s_1_Grp_erro_parcei_Lay_erro_parcei f_rpt_s_1_Grp_param_Lay_param f_rpt_s_1_Grp_param_Lay_param_func f_rpt_s_1_Grp_param_Lay_param_pix f_rpt_s_1_Grp_param_Lay_param_pix2 f_rpt_s_1_Grp_quebra_Lay_blank f_rpt_s_1_Grp_quebra_Lay_cart_bcia f_rpt_s_1_Grp_quebra_Lay_padrao f_rpt_s_1_Grp_quebra_Lay_portad f_rpt_s_1_Grp_quebra_Lay_tot_cart f_rpt_s_1_Grp_quebra_Lay_tot_destin f_rpt_s_1_Grp_quebra_Lay_tot_portad f_rpt_s_1_Grp_quebra_Lay_tot_resumo f_rpt_s_1_header_period f_rpt_s_1_header_unique }
/*************************** Report Definition End **************************/

/************************** Frame Definition Begin **************************/

def frame f_ran_01_tit_acr_destinac
    rt_mold
         at row 01.21 col 02.00
    rt_cxcf
         at row 13.79 col 02.00 bgcolor 7 
    v_cod_estab_ini
         at row 01.38 col 22.43 colon-aligned label "Estabelecimento"
         help "C¢digo Estabelecimento Inicial"
         view-as fill-in
         size-chars 6.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_cod_estab_fim
         at row 01.38 col 43.29 colon-aligned label "atÇ"
         help "C¢digo Estabelecimento Final"
         view-as fill-in
         size-chars 6.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_dat_emis_inic
         at row 02.38 col 22.43 colon-aligned label "Data Emiss∆o"
         help "Data de Emiss∆o Inicial"
         view-as fill-in
         size-chars 11.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_dat_emis_final
         at row 02.38 col 43.29 colon-aligned label "atÇ"
         help "Data de Emiss∆o Final"
         view-as fill-in
         size-chars 11.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_dat_vencto_inicial
         at row 03.38 col 22.43 colon-aligned label "Data Vencimento"
         help "Data de Vencimento Inicial"
         view-as fill-in
         size-chars 11.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_dat_vencto_final
         at row 03.38 col 43.29 colon-aligned label "atÇ"
         help "Data de Vencimento Final"
         view-as fill-in
         size-chars 11.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_cod_refer_ini
         at row 04.38 col 22.43 colon-aligned label "Referància"
         help "C¢digo Referància"
         view-as fill-in
         size-chars 11.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_cod_refer_fim
         at row 04.38 col 43.29 colon-aligned label "atÇ"
         help "C¢digo Referància"
         view-as fill-in
         size-chars 11.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_cdn_cliente_ini
         at row 05.38 col 22.43 colon-aligned label "Cliente"
         help "C¢digo do Cliente Inicial"
         view-as fill-in
         size-chars 12.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_zoo_221699
         at row 05.38 col 36.57
    v_cdn_cliente_fim
         at row 05.38 col 43.29 colon-aligned label "atÇ"
         help "C¢digo do Cliente Final"
         view-as fill-in
         size-chars 12.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_zoo_221698
         at row 05.38 col 57.43
    v_cod_portador_ini
         at row 06.38 col 22.43 colon-aligned label "Portador"
         help "C¢digo Portador Inicial"
         view-as fill-in
         size-chars 6.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_cod_portador_fim
         at row 06.38 col 43.29 colon-aligned label "atÇ"
         help "C¢digo Portador"
         view-as fill-in
         size-chars 6.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_cod_cart_bcia_inicial
         at row 07.38 col 22.43 colon-aligned label "Carteira Bcia"
         help "Carteira Banc†ria Inicial"
         view-as fill-in
         size-chars 4.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_cod_cart_bcia_fim
         at row 07.38 col 43.29 colon-aligned label "atÇ"
         help "Carteira Banc†ria"
         view-as fill-in
         size-chars 4.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_cod_espec_docto_ini
         at row 08.38 col 22.43 colon-aligned label "EspÇcie"
         help "C¢digo Inicial"
         view-as fill-in
         size-chars 4.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_cod_espec_docto_fim
         at row 08.38 col 43.29 colon-aligned label "atÇ"
         help "C¢digo Final"
         view-as fill-in
         size-chars 4.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_cod_ser_docto_ini
         at row 09.38 col 22.43 colon-aligned label "SÇrie"
         help "C¢digo SÇrie Documento"
         view-as fill-in
         size-chars 4.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_cod_ser_docto_fim
         at row 09.38 col 43.29 colon-aligned label "atÇ"
         help "C¢digo SÇrie Documento"
         view-as fill-in
         size-chars 4.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_cod_tit_acr_ini
         at row 10.38 col 22.43 colon-aligned label "T°tulo"
         help "C¢digo T°tulo Contas a Receber"
         view-as fill-in
         size-chars 11.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_cod_tit_acr_fim
         at row 10.38 col 43.29 colon-aligned label "atÇ"
         help "C¢digo T°tulo Contas a Receber"
         view-as fill-in
         size-chars 11.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_cod_parcela_ini
         at row 11.38 col 22.43 colon-aligned label "Parcela"
         help "Parcela"
         view-as fill-in
         size-chars 3.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_cod_parcela_fim
         at row 11.38 col 43.29 colon-aligned label "atÇ"
         help "Parcela"
         view-as fill-in
         size-chars 3.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_val_sdo_inic
         at row 12.38 col 22.43 colon-aligned label "Saldo"
         view-as fill-in
         size-chars 15.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_val_sdo_fim
         at row 12.38 col 43.29 colon-aligned label "atÇ"
         view-as fill-in
         size-chars 15.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_ok
         at row 14.00 col 03.00 font ?
         help "OK"
    bt_can
         at row 14.00 col 14.00 font ?
         help "Cancela"
    bt_hel2
         at row 14.00 col 52.86 font ?
         help "Ajuda"
    with 1 down side-labels no-validate keep-tab-order three-d
         size-char 65.29 by 15.63 default-button bt_ok
         view-as dialog-box
         font 1 fgcolor ? bgcolor 8
         title "Faixa - T°tulos ACR Destinaá∆o".
    /* adjust size of objects in this frame */
    assign bt_can:width-chars   in frame f_ran_01_tit_acr_destinac = 10.00
           bt_can:height-chars  in frame f_ran_01_tit_acr_destinac = 01.00
           bt_hel2:width-chars  in frame f_ran_01_tit_acr_destinac = 10.00
           bt_hel2:height-chars in frame f_ran_01_tit_acr_destinac = 01.00
           bt_ok:width-chars    in frame f_ran_01_tit_acr_destinac = 10.00
           bt_ok:height-chars   in frame f_ran_01_tit_acr_destinac = 01.00
           rt_cxcf:width-chars  in frame f_ran_01_tit_acr_destinac = 61.86
           rt_cxcf:height-chars in frame f_ran_01_tit_acr_destinac = 01.42
           rt_mold:width-chars  in frame f_ran_01_tit_acr_destinac = 61.86
           rt_mold:height-chars in frame f_ran_01_tit_acr_destinac = 12.29.
    /* set private-data for the help system */
    assign v_cod_estab_ini:private-data         in frame f_ran_01_tit_acr_destinac = "HLP=000016633":U
           v_cod_estab_fim:private-data         in frame f_ran_01_tit_acr_destinac = "HLP=000016634":U
           v_dat_emis_inic:private-data         in frame f_ran_01_tit_acr_destinac = "HLP=000022845":U
           v_dat_emis_final:private-data        in frame f_ran_01_tit_acr_destinac = "HLP=000022844":U
           v_dat_vencto_inicial:private-data    in frame f_ran_01_tit_acr_destinac = "HLP=000022406":U
           v_dat_vencto_final:private-data      in frame f_ran_01_tit_acr_destinac = "HLP=000022407":U
           v_cod_refer_ini:private-data         in frame f_ran_01_tit_acr_destinac = "HLP=000022432":U
           v_cod_refer_fim:private-data         in frame f_ran_01_tit_acr_destinac = "HLP=000022435":U
           bt_zoo_221699:private-data           in frame f_ran_01_tit_acr_destinac = "HLP=000009431":U
           v_cdn_cliente_ini:private-data       in frame f_ran_01_tit_acr_destinac = "HLP=000022353":U
           bt_zoo_221698:private-data           in frame f_ran_01_tit_acr_destinac = "HLP=000009431":U
           v_cdn_cliente_fim:private-data       in frame f_ran_01_tit_acr_destinac = "HLP=000022352":U
           v_cod_portador_ini:private-data      in frame f_ran_01_tit_acr_destinac = "HLP=000014638":U
           v_cod_portador_fim:private-data      in frame f_ran_01_tit_acr_destinac = "HLP=000014647":U
           v_cod_cart_bcia_inicial:private-data in frame f_ran_01_tit_acr_destinac = "HLP=000016641":U
           v_cod_cart_bcia_fim:private-data     in frame f_ran_01_tit_acr_destinac = "HLP=000016642":U
           v_cod_espec_docto_ini:private-data   in frame f_ran_01_tit_acr_destinac = "HLP=000016628":U
           v_cod_espec_docto_fim:private-data   in frame f_ran_01_tit_acr_destinac = "HLP=000016629":U
           v_cod_ser_docto_ini:private-data     in frame f_ran_01_tit_acr_destinac = "HLP=000016635":U
           v_cod_ser_docto_fim:private-data     in frame f_ran_01_tit_acr_destinac = "HLP=000016636":U
           v_cod_tit_acr_ini:private-data       in frame f_ran_01_tit_acr_destinac = "HLP=000016637":U
           v_cod_tit_acr_fim:private-data       in frame f_ran_01_tit_acr_destinac = "HLP=000016638":U
           v_cod_parcela_ini:private-data       in frame f_ran_01_tit_acr_destinac = "HLP=000022001":U
           v_cod_parcela_fim:private-data       in frame f_ran_01_tit_acr_destinac = "HLP=000024435":U
           v_val_sdo_inic:private-data          in frame f_ran_01_tit_acr_destinac = "HLP=000024436":U
           v_val_sdo_fim:private-data           in frame f_ran_01_tit_acr_destinac = "HLP=000024438":U
           bt_ok:private-data                   in frame f_ran_01_tit_acr_destinac = "HLP=000010721":U
           bt_can:private-data                  in frame f_ran_01_tit_acr_destinac = "HLP=000011050":U
           bt_hel2:private-data                 in frame f_ran_01_tit_acr_destinac = "HLP=000011326":U
           frame f_ran_01_tit_acr_destinac:private-data                            = "HLP=000020521".
    /* enable function buttons */
    assign bt_zoo_221699:sensitive in frame f_ran_01_tit_acr_destinac = yes
           bt_zoo_221698:sensitive in frame f_ran_01_tit_acr_destinac = yes.
    /* move buttons to top */
    bt_zoo_221699:move-to-top().
    bt_zoo_221698:move-to-top().

def frame f_rpt_41_tit_acr_destinac
    rt_004
         at row 04.33 col 02.00
    " Opá‰es " view-as text
         at row 04.03 col 04.00 bgcolor 8 
    rt_008
         at row 06.21 col 31.86
    " Carteira p/ Port. Preferencial " view-as text
         at row 05.91 col 33.86 bgcolor 8 
    rt_006
         at row 06.21 col 04.57
    " Destinaá∆o/Simulaá∆o " view-as text
         at row 05.91 col 06.57 bgcolor 8 
    rt_target
         at row 14.67 col 02.00
    " Destino " view-as text
         at row 14.37 col 04.00 bgcolor 8 
    rt_run
         at row 14.67 col 48.00
    " Execuá∆o " view-as text
         at row 14.37 col 50.00
    rt_dimensions
         at row 14.67 col 72.72
    " Dimens‰es " view-as text
         at row 14.37 col 74.72
    rt_003
         at row 01.21 col 02.00
    " ParÉmetros " view-as text
         at row 01.00 col 04.00 bgcolor 8 
    rt_010
         at row 12.13 col 02.00
    " Classificaá∆o " view-as text
         at row 11.83 col 04.00 bgcolor 8 
    rt_007
         at row 09.92 col 02.00
    " Observaá∆o " view-as text
         at row 09.62 col 04.00 bgcolor 8 
    rt_005
         at row 09.92 col 69.43
    " Faixa " view-as text
         at row 09.62 col 71.43 bgcolor 8 
    rt_cxcf
         at row 18.17 col 02.00 bgcolor 7 
    rt_009
         at row 04.63 col 04.57 bgcolor 8 
    v_cod_destinac_cobr
         at row 01.83 col 26.00 colon-aligned label "Destinaá∆o"
         help "C¢digo Destinaá∆o"
         view-as fill-in
         size-chars 9.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_zoo_221588
         at row 01.83 col 37.14
    destinac_cobr.des_destinac_cobr
         at row 01.83 col 41.57 no-label
         view-as fill-in
         size-chars 41.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_dat_destinac
         at row 02.83 col 26.00 colon-aligned label "Data Destinaá∆o"
         help "Data Base Destinaá∆o"
         view-as fill-in
         size-chars 11.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_ind_tip_destinac
         at row 04.83 col 05.57 no-label
         view-as radio-set Horizontal
         radio-buttons "Destinaá∆o", "Destinaá∆o", "Simulaá∆o", "Simulaá∆o", "Listagem de T°tulos a Destinar", "Listagem de T°tulos a Destinar"
          /*l_destinacao*/ /*l_destinacao*/ /*l_simulacao*/ /*l_simulacao*/ /*l_listagem_de_titulos_a_destinar*/ /*l_listagem_de_titulos_a_destinar*/
         bgcolor 8 
    v_log_habilit_redestina_cobr
         at row 06.46 col 06.57 label "Redestinaá∆o"
         help "Redestinaá∆o de T°tulos"
         view-as toggle-box
    v_log_destinac_manual
         at row 07.17 col 06.57 label "Manual"
         help "Destinaá∆o Manual ?"
         view-as toggle-box
    v_log_tit_nao_destndo
         at row 07.88 col 06.57 label "Listar T°tulos N∆o Destinados"
         help "Lista T°tulos N∆o Destinados"
         view-as toggle-box
    v_log_cobr_acr_pix
         at row 08.58 col 06.57 label "Aceita Cobranáa PIX"
         help "L¢gico Cobranáa ACR PIX"
         view-as toggle-box
    rs_imforma_cart_bcia
         at row 06.71 col 34.14
         help "" no-label
    v_cod_cart_bcia
         at row 06.58 col 55.00 no-label
         help "Carteira Banc†ria"
         view-as fill-in
         size-chars 4.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_zoo_282498
         at row 06.58 col 59.14
    v_ind_tip_cart_bcia
         at row 07.54 col 55.00 no-label
         help "Indicador Tipo Carteira Banc†ria"
         view-as combo-box
         &if "{&FNC_MULTI_IDIOMA}" = "YES" &then
         list-item-pairs "Portador","Portador","Desconto","Desconto","Cauá∆o","Cauá∆o","Judicial","Judicial","Representante","Representante","Carteira","Carteira","Cobrador","Cobrador","Contas a Pagar","Contas a Pagar"
         &else
         list-items "Portador","Desconto","Cauá∆o","Judicial","Representante","Carteira","Cobrador","Contas a Pagar"
         &endif
          /*l_portador*/ /*l_desconto*/ /*l_caucao*/ /*l_judicial*/ /*l_representante*/ /*l_carteira*/ /*l_cobrador*/ /*l_contas_a_pagar*/
         inner-lines 5
         bgcolor 15 font 2
    v_ind_obs
         at row 10.33 col 05.43 no-label
         help "Observaá∆o"
         view-as editor max-chars 250
         size 35 by 1
         bgcolor 15 font 2
    bt_ran2
         at row 10.33 col 76.57 font ?
         help "Faixa"
    rs_cod_dwb_output
         at row 15.38 col 03.00
         help "" no-label
    ed_1x40
         at row 16.33 col 03.00
         help "" no-label
    rs_ind_run_mode
         at row 15.38 col 49.00
         help "" no-label
    bt_get_file
         at row 16.33 col 42.00 font ?
         help "Pesquisa Arquivo"
    bt_set_printer
         at row 16.33 col 42.00 font ?
         help "Define Impressora e Layout de Impress∆o"
    v_log_print_par
         at row 16.38 col 49.00 label "Imprime ParÉmetros"
         view-as toggle-box
    v_qtd_line
         at row 15.38 col 81.00 colon-aligned
         view-as fill-in
         size-chars 4.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_qtd_column
         at row 16.38 col 81.00 colon-aligned
         view-as fill-in
         size-chars 4.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_close
         at row 18.38 col 03.00 font ?
         help "Fecha"
    bt_print
         at row 18.38 col 14.00 font ?
         help "Imprime"
    bt_can
         at row 18.38 col 25.00 font ?
         help "Cancela"
    bt_hel2
         at row 18.38 col 77.57 font ?
         help "Ajuda"
    v_ind_classif_destinac
         at row 12.42 col 05.29 no-label
         view-as radio-set Vertical
         radio-buttons "Estab/Portador/Carteira/Dt Emiss∆o/Dt Vencto/T°tulo/Parcela", "Estab/Portador/Carteira/Dt Emiss∆o/Dt Vencto/T°tulo/Parcela", "Estab/Portador/Carteira/Dt Emiss∆o/T°tulo/Parcela", "Estab/Portador/Carteira/Dt Emiss∆o/T°tulo/Parcela"
          /*l_vencto_tit_parc*/ /*l_vencto_tit_parc*/ /*l_emis_tit_parcela*/ /*l_emis_tit_parcela*/
         bgcolor 8 
    with 1 down side-labels no-validate keep-tab-order three-d
         size-char 90.00 by 20.00
         view-as dialog-box
         font 1 fgcolor ? bgcolor 8
         title "Destinaá∆o de T°tulos Contas a Receber".
    /* adjust size of objects in this frame */
    assign bt_can:width-chars          in frame f_rpt_41_tit_acr_destinac = 10.00
           bt_can:height-chars         in frame f_rpt_41_tit_acr_destinac = 01.00
           bt_close:width-chars        in frame f_rpt_41_tit_acr_destinac = 10.00
           bt_close:height-chars       in frame f_rpt_41_tit_acr_destinac = 01.00
           bt_get_file:width-chars     in frame f_rpt_41_tit_acr_destinac = 04.00
           bt_get_file:height-chars    in frame f_rpt_41_tit_acr_destinac = 01.08
           bt_hel2:width-chars         in frame f_rpt_41_tit_acr_destinac = 10.00
           bt_hel2:height-chars        in frame f_rpt_41_tit_acr_destinac = 01.00
           bt_print:width-chars        in frame f_rpt_41_tit_acr_destinac = 10.00
           bt_print:height-chars       in frame f_rpt_41_tit_acr_destinac = 01.00
           bt_ran2:width-chars         in frame f_rpt_41_tit_acr_destinac = 04.00
           bt_ran2:height-chars        in frame f_rpt_41_tit_acr_destinac = 01.13
           bt_set_printer:width-chars  in frame f_rpt_41_tit_acr_destinac = 04.00
           bt_set_printer:height-chars in frame f_rpt_41_tit_acr_destinac = 01.08
           ed_1x40:width-chars         in frame f_rpt_41_tit_acr_destinac = 38.00
           ed_1x40:height-chars        in frame f_rpt_41_tit_acr_destinac = 01.00
           rt_003:width-chars          in frame f_rpt_41_tit_acr_destinac = 86.43
           rt_003:height-chars         in frame f_rpt_41_tit_acr_destinac = 02.83
           rt_004:width-chars          in frame f_rpt_41_tit_acr_destinac = 86.43
           rt_004:height-chars         in frame f_rpt_41_tit_acr_destinac = 05.29
           rt_005:width-chars          in frame f_rpt_41_tit_acr_destinac = 19.00
           rt_005:height-chars         in frame f_rpt_41_tit_acr_destinac = 01.88
           rt_006:width-chars          in frame f_rpt_41_tit_acr_destinac = 26.29
           rt_006:height-chars         in frame f_rpt_41_tit_acr_destinac = 03.17
           rt_007:width-chars          in frame f_rpt_41_tit_acr_destinac = 65.72
           rt_007:height-chars         in frame f_rpt_41_tit_acr_destinac = 01.88
           rt_008:width-chars          in frame f_rpt_41_tit_acr_destinac = 55.14
           rt_008:height-chars         in frame f_rpt_41_tit_acr_destinac = 03.17
           rt_009:width-chars          in frame f_rpt_41_tit_acr_destinac = 82.14
           rt_009:height-chars         in frame f_rpt_41_tit_acr_destinac = 01.17
           rt_010:width-chars          in frame f_rpt_41_tit_acr_destinac = 86.43
           rt_010:height-chars         in frame f_rpt_41_tit_acr_destinac = 02.13
           rt_cxcf:width-chars         in frame f_rpt_41_tit_acr_destinac = 86.57
           rt_cxcf:height-chars        in frame f_rpt_41_tit_acr_destinac = 01.42
           rt_dimensions:width-chars   in frame f_rpt_41_tit_acr_destinac = 15.72
           rt_dimensions:height-chars  in frame f_rpt_41_tit_acr_destinac = 03.00
           rt_run:width-chars          in frame f_rpt_41_tit_acr_destinac = 23.86
           rt_run:height-chars         in frame f_rpt_41_tit_acr_destinac = 03.00
           rt_target:width-chars       in frame f_rpt_41_tit_acr_destinac = 45.00
           rt_target:height-chars      in frame f_rpt_41_tit_acr_destinac = 03.00.
    /* set return-inserted = yes for editors */
    assign v_ind_obs:return-inserted in frame f_rpt_41_tit_acr_destinac = yes
           ed_1x40:return-inserted   in frame f_rpt_41_tit_acr_destinac = yes.
    /* set private-data for the help system */
    assign bt_zoo_221588:private-data                   in frame f_rpt_41_tit_acr_destinac = "HLP=000009431":U
           v_cod_destinac_cobr:private-data             in frame f_rpt_41_tit_acr_destinac = "HLP=000021464":U
           destinac_cobr.des_destinac_cobr:private-data in frame f_rpt_41_tit_acr_destinac = "HLP=000026355":U
           v_dat_destinac:private-data                  in frame f_rpt_41_tit_acr_destinac = "HLP=000024638":U
           v_ind_tip_destinac:private-data              in frame f_rpt_41_tit_acr_destinac = "HLP=000024639":U
           v_log_habilit_redestina_cobr:private-data    in frame f_rpt_41_tit_acr_destinac = "HLP=000024640":U
           v_log_destinac_manual:private-data           in frame f_rpt_41_tit_acr_destinac = "HLP=000024641":U
           v_log_tit_nao_destndo:private-data           in frame f_rpt_41_tit_acr_destinac = "HLP=000020522":U
           v_log_cobr_acr_pix:private-data              in frame f_rpt_41_tit_acr_destinac = "HLP=000020522":U
           rs_imforma_cart_bcia:private-data            in frame f_rpt_41_tit_acr_destinac = "HLP=000020522":U
           bt_zoo_282498:private-data                   in frame f_rpt_41_tit_acr_destinac = "HLP=000009431":U
           v_cod_cart_bcia:private-data                 in frame f_rpt_41_tit_acr_destinac = "HLP=000024404":U
           v_ind_tip_cart_bcia:private-data             in frame f_rpt_41_tit_acr_destinac = "HLP=000020522":U
           v_ind_obs:private-data                       in frame f_rpt_41_tit_acr_destinac = "HLP=000024735":U
           bt_ran2:private-data                         in frame f_rpt_41_tit_acr_destinac = "HLP=000008773":U
           rs_cod_dwb_output:private-data               in frame f_rpt_41_tit_acr_destinac = "HLP=000020522":U
           ed_1x40:private-data                         in frame f_rpt_41_tit_acr_destinac = "HLP=000020522":U
           rs_ind_run_mode:private-data                 in frame f_rpt_41_tit_acr_destinac = "HLP=000020522":U
           bt_get_file:private-data                     in frame f_rpt_41_tit_acr_destinac = "HLP=000008782":U
           bt_set_printer:private-data                  in frame f_rpt_41_tit_acr_destinac = "HLP=000008785":U
           v_log_print_par:private-data                 in frame f_rpt_41_tit_acr_destinac = "HLP=000024662":U
           v_qtd_line:private-data                      in frame f_rpt_41_tit_acr_destinac = "HLP=000024737":U
           v_qtd_column:private-data                    in frame f_rpt_41_tit_acr_destinac = "HLP=000024669":U
           bt_close:private-data                        in frame f_rpt_41_tit_acr_destinac = "HLP=000009420":U
           bt_print:private-data                        in frame f_rpt_41_tit_acr_destinac = "HLP=000010815":U
           bt_can:private-data                          in frame f_rpt_41_tit_acr_destinac = "HLP=000011050":U
           bt_hel2:private-data                         in frame f_rpt_41_tit_acr_destinac = "HLP=000011326":U
           v_ind_classif_destinac:private-data          in frame f_rpt_41_tit_acr_destinac = "HLP=000020522":U
           frame f_rpt_41_tit_acr_destinac:private-data                                    = "HLP=000020522".
    /* enable function buttons */
    assign bt_zoo_221588:sensitive in frame f_rpt_41_tit_acr_destinac = yes
           bt_zoo_282498:sensitive in frame f_rpt_41_tit_acr_destinac = yes.
    /* move buttons to top */
    bt_zoo_221588:move-to-top().
    bt_zoo_282498:move-to-top().



{include/i_fclfrm.i f_ran_01_tit_acr_destinac f_rpt_41_tit_acr_destinac }
/*************************** Frame Definition End ***************************/

/* tech38629 - Alteraá∆o efetuada via filtro */
&if '{&emsbas_version}':U >= '5.05':U and not proversion begins '10.1A':U &then
def var v_prog_filtro_pdf as handle no-undo.

function getCodTipoRelat returns character in v_prog_filtro_pdf.

run prgtec/btb/btb920aa.py persistent set v_prog_filtro_pdf.

run pi_define_objetos in v_prog_filtro_pdf (frame f_rpt_41_tit_acr_destinac:handle,
                       rs_cod_dwb_output:handle in frame f_rpt_41_tit_acr_destinac,
                       bt_get_file:row in frame f_rpt_41_tit_acr_destinac,
                       bt_get_file:col in frame f_rpt_41_tit_acr_destinac).

&endif
/* tech38629 - Fim da alteraá∆o */



/* Alteracao via filtro - UPC de impressora - inicio */
{include/i_rptupc.i}
/* Alteracao via filtro - UPC de impressora - fim */

/*********************** User Interface Trigger Begin ***********************/


ON CHOOSE OF bt_hel2 IN FRAME f_ran_01_tit_acr_destinac
DO:


    /* Begin_Include: i_context_help_frame */
    run prgtec/men/men900za.py (Input self:frame,
                                Input this-procedure:handle) /*prg_fnc_chamar_help_context*/.


    /* End_Include: i_context_help_frame */

END. /* ON CHOOSE OF bt_hel2 IN FRAME f_ran_01_tit_acr_destinac */

ON CHOOSE OF bt_ok IN FRAME f_ran_01_tit_acr_destinac
DO:

    if input frame f_ran_01_tit_acr_destinac v_cod_estab_fim < input frame f_ran_01_tit_acr_destinac v_cod_estab_ini then do:
    /* Estabelecimento final dever† ser maior que o inicial. */
    run pi_messages (input "show",
                     input 6249,
                     input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_6249*/.
    return no-apply.
    end.

    if input frame f_ran_01_tit_acr_destinac v_dat_emis_final < input frame f_ran_01_tit_acr_destinac v_dat_emis_inic then do:
    /* A Data de Emiss∆o Final dever† ser maior que a Data Inicial. */
    run pi_messages (input "show",
                     input 6177,
                     input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_6177*/.
    return no-apply.
    end.

    if input frame f_ran_01_tit_acr_destinac v_dat_vencto_final < input frame f_ran_01_tit_acr_destinac v_dat_vencto_inicial then do:
    /* Data de Vencimento Final deve ser maior que a Data Inicial. */
    run pi_messages (input "show",
                     input 6178,
                     input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_6178*/.
    return no-apply.
    end.

    if input frame f_ran_01_tit_acr_destinac v_cod_refer_fim < input frame f_ran_01_tit_acr_destinac v_cod_refer_ini then do:
    /* A Referància final dever† ser maior que a Referància Inicial. */
    run pi_messages (input "show",
                     input 6240,
                     input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_6240*/.
    return no-apply.
    end.

    if input frame f_ran_01_tit_acr_destinac v_cdn_cliente_fim < input frame f_ran_01_tit_acr_destinac v_cdn_cliente_ini then do:
    /* Cliente Final dever† ser maior que Cliente Inicial. */
    run pi_messages (input "show",
                     input 6241,
                     input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_6241*/.
    return no-apply.
    end.

    if input frame f_ran_01_tit_acr_destinac v_cod_portador_fim < input frame f_ran_01_tit_acr_destinac v_cod_portador_ini then do:
    /* O Portador Final dever† ser maior que o Portador Inicial. */
    run pi_messages (input "show",
                     input 6242,
                     input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_6242*/.
    return no-apply.
    end.

    if input frame f_ran_01_tit_acr_destinac v_cod_cart_bcia_fim < input frame f_ran_01_tit_acr_destinac v_cod_cart_bcia_inicial then do:
    /* Carteira Bcia final deve ser maior que Carteira Bcia Inicial. */
    run pi_messages (input "show",
                     input 6243,
                     input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_6243*/.
    return no-apply.
    end.

    if input frame f_ran_01_tit_acr_destinac v_cod_espec_docto_fim < input frame f_ran_01_tit_acr_destinac v_cod_espec_docto_ini then do:
    /* EspÇcie final dever† ser maior que EspÇcie inicial. */
    run pi_messages (input "show",
                     input 6244,
                     input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_6244*/.
    return no-apply.
    end.

    if input frame f_ran_01_tit_acr_destinac v_cod_ser_docto_fim < input frame f_ran_01_tit_acr_destinac v_cod_ser_docto_ini then do:
    /* A SÇrie final dever† ser maior que a SÇrie inicial. */
    run pi_messages (input "show",
                     input 6245,
                     input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_6245*/.
    return no-apply.
    end.

    if input frame f_ran_01_tit_acr_destinac v_cod_tit_acr_fim < input frame f_ran_01_tit_acr_destinac v_cod_tit_acr_ini then do:
    /* O t°tulo final dever† ser maior que t°tulo inicial. */
    run pi_messages (input "show",
                     input 6246,
                     input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_6246*/.
    return no-apply.
    end.

    if input frame f_ran_01_tit_acr_destinac v_cod_parcela_fim < input frame f_ran_01_tit_acr_destinac v_cod_parcela_ini then do:
    /* A Parcela final dever† ser maior que a Parcela inicial. */
    run pi_messages (input "show",
                     input 6247,
                     input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_6247*/.
    return no-apply.
    end.

    if input frame f_ran_01_tit_acr_destinac v_val_sdo_fim < input frame f_ran_01_tit_acr_destinac v_val_sdo_inic then do:
    /* O Saldo final dever† ser maior que o Saldo inicial. */
    run pi_messages (input "show",
                     input 6248,
                     input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_6248*/.
    return no-apply.
    end.





END. /* ON CHOOSE OF bt_ok IN FRAME f_ran_01_tit_acr_destinac */

ON CHOOSE OF bt_get_file IN FRAME f_rpt_41_tit_acr_destinac
DO:

    system-dialog get-file v_cod_dwb_file
        title "Imprimir" /*l_imprimir*/ 
        filters '*.rpt' '*.rpt',
                "*.*"   "*.*"
        save-as
        create-test-file
        ask-overwrite.
        assign dwb_rpt_param.cod_dwb_file             = v_cod_dwb_file
               ed_1x40:screen-value in frame f_rpt_41_tit_acr_destinac = v_cod_dwb_file.

END. /* ON CHOOSE OF bt_get_file IN FRAME f_rpt_41_tit_acr_destinac */

ON CHOOSE OF bt_hel2 IN FRAME f_rpt_41_tit_acr_destinac
DO:


    /* Begin_Include: i_context_help_frame */
    run prgtec/men/men900za.py (Input self:frame,
                                Input this-procedure:handle) /*prg_fnc_chamar_help_context*/.


    /* End_Include: i_context_help_frame */

END. /* ON CHOOSE OF bt_hel2 IN FRAME f_rpt_41_tit_acr_destinac */

ON CHOOSE OF bt_print IN FRAME f_rpt_41_tit_acr_destinac
DO:

    assign input frame f_rpt_41_tit_acr_destinac v_cod_destinac_cobr
           input frame f_rpt_41_tit_acr_destinac v_dat_destinac
           input frame f_rpt_41_tit_acr_destinac v_ind_tip_destinac
           input frame f_rpt_41_tit_acr_destinac v_log_destinac_manual
           input frame f_rpt_41_tit_acr_destinac v_log_habilit_redestina_cobr
           input frame f_rpt_41_tit_acr_destinac v_ind_obs.
    assign rs_imforma_cart_bcia = rs_imforma_cart_bcia:screen-value in frame f_rpt_41_tit_acr_destinac
           v_cod_cart_bcia = v_cod_cart_bcia:screen-value in frame f_rpt_41_tit_acr_destinac
           v_ind_tip_cart_bcia = v_ind_tip_cart_bcia:screen-value in frame f_rpt_41_tit_acr_destinac.
do:
/* tech38629 - Alteraá∆o efetuada via filtro */
&if '{&emsbas_version}':U >= '5.05':U and not proversion begins '10.1A':U &then
    run pi_restricoes in v_prog_filtro_pdf (input rs_cod_dwb_output:screen-value in frame f_rpt_41_tit_acr_destinac).
    if return-value = 'nok' then 
        return no-apply.
&endif
/* tech38629 - Fim da alteraá∆o */

    assign v_log_print = yes.
end.

    /* ---Listar Consistàncias de T°tulos n∆o Destinados---*/
    if v_log_funcao_tit_nao_dest = yes then do:
       assign input frame f_rpt_41_tit_acr_destinac v_log_tit_nao_destndo.
    end.

    &if defined(BF_FIN_PIX_3_FLEXIBILIZA) &then
    if v_cod_pais_empres_usuar = "BRA" /*l_bra*/  then
       assign input frame f_rpt_41_tit_acr_destinac v_log_cobr_acr_pix.
    &endif

END. /* ON CHOOSE OF bt_print IN FRAME f_rpt_41_tit_acr_destinac */

ON CHOOSE OF bt_ran2 IN FRAME f_rpt_41_tit_acr_destinac
DO:


    /* Begin_Include: i_generic_range */
    view frame f_ran_01_tit_acr_destinac.

    range_block:
    do on error undo range_block, retry range_block:
        update v_cod_estab_ini
               v_cod_estab_fim
               v_dat_emis_inic
               v_dat_emis_final
               v_cdn_cliente_fim
               v_cdn_cliente_ini
               v_cod_cart_bcia_fim
               v_cod_cart_bcia_inicial
               v_cod_espec_docto_fim
               v_cod_espec_docto_ini
               v_cod_parcela_fim
               v_cod_parcela_ini
               v_cod_portador_fim
               v_cod_portador_ini
               v_cod_ser_docto_fim
               v_cod_ser_docto_ini
               v_cod_tit_acr_fim
               v_cod_tit_acr_ini
               v_dat_vencto_final
               v_dat_vencto_inicial
               v_cod_refer_ini
               v_cod_refer_fim
               v_val_sdo_inic
               v_val_sdo_fim
               bt_ok
               bt_can
               bt_hel2
               with frame f_ran_01_tit_acr_destinac.
    end /* do range_block */.

    hide frame f_ran_01_tit_acr_destinac.
    /* End_Include: i_generic_range */

END. /* ON CHOOSE OF bt_ran2 IN FRAME f_rpt_41_tit_acr_destinac */

ON CHOOSE OF bt_set_printer IN FRAME f_rpt_41_tit_acr_destinac
DO:

    assign v_nom_dwb_printer      = ""
           v_cod_dwb_print_layout = "".

    &if '{&emsbas_version}' <= '1.00' &then
    if  search("prgtec/btb/btb036nb.r") = ? and search("prgtec/btb/btb036nb.p") = ? then do:
        if  v_cod_dwb_user begins 'es_' then
            return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgtec/btb/btb036nb.p".
        else do:
            message getStrTrans("Programa execut†vel n∆o foi encontrado:", "ACR") /*l_programa_nao_encontrado*/  "prgtec/btb/btb036nb.p"
                   view-as alert-box error buttons ok.
            return.
        end.
    end.
    else
        run prgtec/btb/btb036nb.p (output v_nom_dwb_printer,
                               output v_cod_dwb_print_layout) /*prg_see_layout_impres_imprsor*/.
    &else
    if  search("prgtec/btb/btb036zb.r") = ? and search("prgtec/btb/btb036zb.p") = ? then do:
        if  v_cod_dwb_user begins 'es_' then
            return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgtec/btb/btb036zb.p".
        else do:
            message getStrTrans("Programa execut†vel n∆o foi encontrado:", "ACR") /*l_programa_nao_encontrado*/  "prgtec/btb/btb036zb.p"
                   view-as alert-box error buttons ok.
            return.
        end.
    end.
    else
        run prgtec/btb/btb036zb.p (input-output v_nom_dwb_printer,
                               input-output v_cod_dwb_print_layout,
                               input-output v_nom_dwb_print_file) /*prg_fnc_layout_impres_imprsor*/.
    &endif

    if  v_nom_dwb_printer <> ""
    and  v_cod_dwb_print_layout <> ""
    then do:
        assign dwb_rpt_param.nom_dwb_printer      = v_nom_dwb_printer
               dwb_rpt_param.cod_dwb_print_layout = v_cod_dwb_print_layout
    &if '{&emsbas_version}' > '1.00' &then           
    &if '{&emsbas_version}' >= '5.03' &then           
               dwb_rpt_param.nom_dwb_print_file        = v_nom_dwb_print_file
    &else
               dwb_rpt_param.cod_livre_1               = v_nom_dwb_print_file
    &endif
    &endif
               ed_1x40:screen-value in frame f_rpt_41_tit_acr_destinac = v_nom_dwb_printer
                                                       + ":"
                                                       + v_cod_dwb_print_layout
    &if '{&emsbas_version}' > '1.00' &then
                                                       + (if v_nom_dwb_print_file <> "" then ":" + v_nom_dwb_print_file
                                                          else "")
    &endif
    .
        find layout_impres no-lock
             where layout_impres.nom_impressora = dwb_rpt_param.nom_dwb_printer
               and layout_impres.cod_layout_impres = dwb_rpt_param.cod_dwb_print_layout /*cl_get_layout of layout_impres*/ no-error.
        assign v_qtd_line               = layout_impres.num_lin_pag.
        display v_qtd_line
                with frame f_rpt_41_tit_acr_destinac.
    end /* if */.

END. /* ON CHOOSE OF bt_set_printer IN FRAME f_rpt_41_tit_acr_destinac */

ON LEAVE OF ed_1x40 IN FRAME f_rpt_41_tit_acr_destinac
DO:

    /************************* Variable Definition Begin ************************/

    def var v_cod_filename_final             as character       no-undo. /*local*/
    def var v_cod_filename_initial           as character       no-undo. /*local*/


    /************************** Variable Definition End *************************/

    block:
    do with frame f_rpt_41_tit_acr_destinac:
        if  rs_cod_dwb_output:screen-value = "Arquivo" /*l_file*/ 
        then do:
            if  rs_ind_run_mode:screen-value <> "Batch" /*l_batch*/ 
            then do:
                if  ed_1x40:screen-value <> ""
                then do:
                    assign ed_1x40:screen-value   = replace(ed_1x40:screen-value, '~\', '/')
                           v_cod_filename_initial = entry(num-entries(ed_1x40:screen-value, '/'), ed_1x40:screen-value, '/')
                           v_cod_filename_final   = substring(ed_1x40:screen-value, 1,
                                                              length(ed_1x40:screen-value) - length(v_cod_filename_initial) - 1)
                           file-info:file-name    = v_cod_filename_final.
                    if  file-info:file-type = ?
                    then do:
                         /* O diret¢rio &1 n∆o existe ! */
                         run pi_messages (input "show",
                                          input 4354,
                                          input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                                             v_cod_filename_final)) /*msg_4354*/.
                         return no-apply.
                    end /* if */.
                end /* if */.
            end /* if */.

            find dwb_rpt_param
                where dwb_rpt_param.cod_dwb_user    = v_cod_usuar_corren
                and   dwb_rpt_param.cod_dwb_program = v_cod_dwb_program
                exclusive-lock no-error.
            assign dwb_rpt_param.cod_dwb_file = ed_1x40:screen-value.
        end /* if */.
    end /* do block */.

END. /* ON LEAVE OF ed_1x40 IN FRAME f_rpt_41_tit_acr_destinac */

ON VALUE-CHANGED OF rs_cod_dwb_output IN FRAME f_rpt_41_tit_acr_destinac
DO:

    initout:
    do with frame f_rpt_41_tit_acr_destinac:
        /* block: */
        case self:screen-value:
            when "Terminal" /*l_terminal*/ then ter:
             do:
                if  rs_cod_dwb_output <> "Impressora" /*l_printer*/ 
                then do:
                    assign v_qtd_line_ant = input frame f_rpt_41_tit_acr_destinac v_qtd_line.
                end /* if */.
                if  v_qtd_line_ant > 0
                then do:
                    assign v_qtd_line = v_qtd_line_ant.
                end /* if */.
                else do:
                    assign v_qtd_line = (if  dwb_rpt_param.qtd_dwb_line > 0 then dwb_rpt_param.qtd_dwb_line
                                        else v_rpt_s_1_lines).
                end /* else */.
                display v_qtd_line
                        with frame f_rpt_41_tit_acr_destinac.
                assign ed_1x40:screen-value   = ""
                       ed_1x40:sensitive      = no
                       bt_get_file:visible    = no
                       bt_set_printer:visible = no.
            end /* do ter */.
            when "Arquivo" /*l_file*/ then fil:
             do:
                if  rs_cod_dwb_output <> "Impressora" /*l_printer*/ 
                then do:
                    assign v_qtd_line_ant = input frame f_rpt_41_tit_acr_destinac v_qtd_line.
                end /* if */.
                if  v_qtd_line_ant > 0
                then do:
                    assign v_qtd_line = v_qtd_line_ant.
                end /* if */.
                else do:
                    assign v_qtd_line = (if  dwb_rpt_param.qtd_dwb_line > 0 then dwb_rpt_param.qtd_dwb_line
                                        else v_rpt_s_1_lines).
                end /* else */.
                display v_qtd_line
                        with frame f_rpt_41_tit_acr_destinac.
                assign ed_1x40:screen-value   = ""
                       ed_1x40:sensitive      = yes
                       bt_set_printer:visible = no
                       bt_get_file:visible    = yes.

                /* define arquivo default */
                find usuar_mestre no-lock
                     where usuar_mestre.cod_usuario = v_cod_dwb_user
    &if "{&emsbas_version}" >= "5.01" &then
                     use-index srmstr_id
    &endif
                      /*cl_current_user of usuar_mestre*/ no-error.
                do  transaction:                
                    find dwb_rpt_param
                        where dwb_rpt_param.cod_dwb_user    = v_cod_usuar_corren
                        and   dwb_rpt_param.cod_dwb_program = v_cod_dwb_program
                        exclusive-lock no-error.

                    assign dwb_rpt_param.cod_dwb_file = "".

                    if  rs_ind_run_mode:screen-value in frame f_rpt_41_tit_acr_destinac <> "Batch" /*l_batch*/ 
                    then do:
                        if  usuar_mestre.nom_dir_spool <> ""
                        then do:
                            assign dwb_rpt_param.cod_dwb_file = usuar_mestre.nom_dir_spool
                                                              + "~/".
                        end /* if */.
                        if  usuar_mestre.nom_subdir_spool <> ""
                        then do:
                            assign dwb_rpt_param.cod_dwb_file = dwb_rpt_param.cod_dwb_file
                                                              + usuar_mestre.nom_subdir_spool
                                                              + "~/".
                        end /* if */.
                    end /* if */.
                    else do:
                        assign dwb_rpt_param.cod_dwb_file = dwb_rpt_param.cod_dwb_file.
                    end /* else */.
                    if  v_cod_dwb_file_temp = ""
                    then do:
                        assign dwb_rpt_param.cod_dwb_file = dwb_rpt_param.cod_dwb_file
                                                          + caps("acr739ab":U)
                                                          + '.rpt'.
                    end /* if */.
                    else do:
                        assign dwb_rpt_param.cod_dwb_file = dwb_rpt_param.cod_dwb_file
                                                          + v_cod_dwb_file_temp.
                    end /* else */.
                    assign ed_1x40:screen-value               = dwb_rpt_param.cod_dwb_file
                           dwb_rpt_param.cod_dwb_print_layout = ""
                           v_qtd_line                         = (if v_qtd_line_ant > 0 then v_qtd_line_ant
                                                                 else v_rpt_s_1_lines)
    &if '{&emsbas_version}' > '1.00' &then
                           v_nom_dwb_print_file               = ""
    &endif
    .
                end.     
            end /* do fil */.
            when "Impressora" /*l_printer*/ then prn:
             do:
                if  rs_cod_dwb_output <> "Impressora" /*l_printer*/  /* and rs_ind_run_mode <> "Batch" /*l_batch*/  */
                then do: 
                    assign v_qtd_line_ant = input frame f_rpt_41_tit_acr_destinac v_qtd_line.
                end /* if */.

                assign ed_1x40:sensitive        = no
                       bt_get_file:visible      = no
                       bt_set_printer:visible   = yes
                       bt_set_printer:sensitive = yes.

                /* define layout default */
                if  dwb_rpt_param.nom_dwb_printer = ""
                or  dwb_rpt_param.cod_dwb_print_layout = ""
                then do:
                    run pi_set_print_layout_default /*pi_set_print_layout_default*/.
                end /* if */.
                else do:
                    assign ed_1x40:screen-value = dwb_rpt_param.nom_dwb_printer
                                                + ":"
                                                + dwb_rpt_param.cod_dwb_print_layout.
                end /* else */.
                find layout_impres no-lock
                     where layout_impres.nom_impressora = dwb_rpt_param.nom_dwb_printer
                       and layout_impres.cod_layout_impres = dwb_rpt_param.cod_dwb_print_layout /*cl_get_layout of layout_impres*/ no-error.
                if  avail layout_impres
                then do:
                    assign v_qtd_line               = layout_impres.num_lin_pag.
                end /* if */.
                display v_qtd_line
                        with frame f_rpt_41_tit_acr_destinac.
            end /* do prn */.
        end /* case block */.

        assign v_cod_dwb_file_temp = replace(dwb_rpt_param.cod_dwb_file, "~\", "~/").
        if  index(v_cod_dwb_file_temp, "~/") <> 0
        then do:
            assign v_cod_dwb_file_temp = substring(v_cod_dwb_file_temp, r-index(v_cod_dwb_file_temp, "~/") + 1).
        end /* if */.
        else do:
            assign v_cod_dwb_file_temp = dwb_rpt_param.cod_dwb_file.
        end /* else */.
    end /* do initout */.

    if  self:screen-value = "Impressora" /*l_printer*/ 
    then do:
        disable v_qtd_line
                with frame f_rpt_41_tit_acr_destinac.
    end /* if */.
    else do:
        enable v_qtd_line
               with frame f_rpt_41_tit_acr_destinac.
    end /* else */.
    assign rs_cod_dwb_output.

END. /* ON VALUE-CHANGED OF rs_cod_dwb_output IN FRAME f_rpt_41_tit_acr_destinac */

ON VALUE-CHANGED OF rs_imforma_cart_bcia IN FRAME f_rpt_41_tit_acr_destinac
DO:

    if input frame f_rpt_41_tit_acr_destinac rs_imforma_cart_bcia = "Carteira" /*l_carteira*/  then do:
       disable v_ind_tip_cart_bcia
               with frame f_rpt_41_tit_acr_destinac.
       enable v_cod_cart_bcia
              bt_zoo_282498
              with frame f_rpt_41_tit_acr_destinac.
    end.

    if input frame f_rpt_41_tit_acr_destinac rs_imforma_cart_bcia = "Tipo Carteira" /*l_tipo_carteira*/  then do:
       enable v_ind_tip_cart_bcia
              with frame f_rpt_41_tit_acr_destinac.
       disable v_cod_cart_bcia
               bt_zoo_282498
               with frame f_rpt_41_tit_acr_destinac.
    end.

    &if '{&emsfin_version}' >= '5.04' &then
    if input frame f_rpt_41_tit_acr_destinac rs_imforma_cart_bcia = "Cliente Financeiro" /*l_cliente_financeiro*/  then
       disable v_ind_tip_cart_bcia
               v_cod_cart_bcia
               bt_zoo_282498
               with frame f_rpt_41_tit_acr_destinac.
    &endif
END. /* ON VALUE-CHANGED OF rs_imforma_cart_bcia IN FRAME f_rpt_41_tit_acr_destinac */

ON VALUE-CHANGED OF rs_ind_run_mode IN FRAME f_rpt_41_tit_acr_destinac
DO:

    if  input frame f_rpt_41_tit_acr_destinac rs_ind_run_mode = "Batch" /*l_batch*/ 
    then do:
        assign v_log_destinac_manual = no.
        display v_log_destinac_manual
                with frame f_rpt_41_tit_acr_destinac.
        disable v_log_destinac_manual
                with frame f_rpt_41_tit_acr_destinac.
    end /* if */.
    else
       enable v_log_destinac_manual
              with frame f_rpt_41_tit_acr_destinac.

    do  transaction:
        find dwb_rpt_param
            where dwb_rpt_param.cod_dwb_user    = v_cod_usuar_corren
            and   dwb_rpt_param.cod_dwb_program = v_cod_dwb_program
            exclusive-lock no-error.
        assign dwb_rpt_param.ind_dwb_run_mode = input frame f_rpt_41_tit_acr_destinac rs_ind_run_mode.

        if  dwb_rpt_param.ind_dwb_run_mode = "Batch" /*l_batch*/ 
        then do:
            if  rs_cod_dwb_output:disable(getStrTrans("Terminal", "ACR") /*l_terminal*/ ) in frame f_rpt_41_tit_acr_destinac
            then do:
            end /* if */.
        end /* if */.
        else do:
            if  rs_cod_dwb_output:enable(getStrTrans("Terminal", "ACR") /*l_terminal*/ ) in frame f_rpt_41_tit_acr_destinac
            then do:
            end /* if */.
        end /* else */.
        if  rs_ind_run_mode = "Batch" /*l_batch*/ 
        then do:
           assign v_qtd_line = v_qtd_line_ant.
           display v_qtd_line
                   with frame f_rpt_41_tit_acr_destinac.
        end /* if */.
        assign rs_ind_run_mode.
        apply "value-changed" to rs_cod_dwb_output in frame f_rpt_41_tit_acr_destinac.
    end.    

END. /* ON VALUE-CHANGED OF rs_ind_run_mode IN FRAME f_rpt_41_tit_acr_destinac */

ON LEAVE OF v_cod_destinac_cobr IN FRAME f_rpt_41_tit_acr_destinac
DO:

    if  v_dat_destinac:screen-value in frame f_rpt_41_tit_acr_destinac = "" 
    or  v_dat_destinac:screen-value in frame f_rpt_41_tit_acr_destinac = ? then
        find destinac_cobr no-lock
            where destinac_cobr.cod_empresa       = v_cod_empres_usuar
            and   destinac_cobr.cod_destinac_cobr = v_cod_destinac_cobr:screen-value in frame f_rpt_41_tit_acr_destinac
            and   destinac_cobr.dat_inic_valid   <= today
            and   destinac_cobr.dat_fim_valid    >  today
            no-error.
    else
        find destinac_cobr no-lock
            where destinac_cobr.cod_empresa       = v_cod_empres_usuar
            and   destinac_cobr.cod_destinac_cobr = v_cod_destinac_cobr:screen-value in frame f_rpt_41_tit_acr_destinac
            and   destinac_cobr.dat_inic_valid   <= date(v_dat_destinac:screen-value in frame f_rpt_41_tit_acr_destinac)
            and   destinac_cobr.dat_fim_valid    >  date(v_dat_destinac:screen-value in frame f_rpt_41_tit_acr_destinac) 
            no-error.
    display destinac_cobr.des_destinac_cobr when avail destinac_cobr
            "" when not avail destinac_cobr @ destinac_cobr.des_destinac_cobr
            with frame f_rpt_41_tit_acr_destinac.
END. /* ON LEAVE OF v_cod_destinac_cobr IN FRAME f_rpt_41_tit_acr_destinac */

ON LEAVE OF v_dat_destinac IN FRAME f_rpt_41_tit_acr_destinac
DO:

    apply "leave" to v_cod_destinac_cobr.
END. /* ON LEAVE OF v_dat_destinac IN FRAME f_rpt_41_tit_acr_destinac */

ON VALUE-CHANGED OF v_ind_classif_destinac IN FRAME f_rpt_41_tit_acr_destinac
DO:

    assign input frame f_rpt_41_tit_acr_destinac v_ind_classif_destinac.
END. /* ON VALUE-CHANGED OF v_ind_classif_destinac IN FRAME f_rpt_41_tit_acr_destinac */

ON VALUE-CHANGED OF v_ind_tip_destinac IN FRAME f_rpt_41_tit_acr_destinac
DO:

    if  input frame f_rpt_41_tit_acr_destinac v_ind_tip_destinac = "Listagem de T°tulos a Destinar" /*l_listagem_de_titulos_a_destinar*/  then do:
        disable v_log_destinac_manual
                with frame f_rpt_41_tit_acr_destinac.
    end.
    else do:
        if input frame f_rpt_41_tit_acr_destinac rs_ind_run_mode = "Batch" /*l_batch*/ 
        then
            disable v_log_destinac_manual
                    with frame f_rpt_41_tit_acr_destinac.
        else
            enable v_log_destinac_manual
                   with frame f_rpt_41_tit_acr_destinac.
    end.

    /* ---Listar Consistància de T°tulos N∆o Destinados---*/
    if  v_log_funcao_tit_nao_dest = yes then do:
        if  input frame f_rpt_41_tit_acr_destinac v_ind_tip_destinac = "Listagem de T°tulos a Destinar" /*l_listagem_de_titulos_a_destinar*/  then do:
            disable v_log_tit_nao_destndo
                    with frame f_rpt_41_tit_acr_destinac.
        end.
        else do:
            enable v_log_tit_nao_destndo
                   with frame f_rpt_41_tit_acr_destinac.
        end.
    end.

END. /* ON VALUE-CHANGED OF v_ind_tip_destinac IN FRAME f_rpt_41_tit_acr_destinac */

ON VALUE-CHANGED OF v_log_cobr_acr_pix IN FRAME f_rpt_41_tit_acr_destinac
DO:

    /************************* Variable Definition Begin ************************/

    def var v_cod_destinac_cobr_aux          as character       no-undo. /*local*/


    /************************** Variable Definition End *************************/

    if  v_log_cobr_acr_pix:screen-value in frame f_rpt_41_tit_acr_destinac = "Sim" /*l_sim*/ 
    then do:

        assign v_cod_destinac_cobr_aux = "" /*l_*/ .

        destinac_pix:
        for each destinac_cobr no-lock
           where destinac_cobr.cod_empresa      = v_cod_empres_usuar
             and destinac_cobr.log_cobr_acr_pix = yes
            break by destinac_cobr.cod_empresa:
            if first-of(destinac_cobr.cod_empresa) then
               assign v_cod_destinac_cobr_aux = destinac_cobr.cod_destinac_cobr.
            else do:
               if  v_cod_destinac_cobr_aux <> destinac_cobr.cod_destinac_cobr
               then do:
                  assign v_cod_destinac_cobr_aux = "" /*l_*/ .
                  leave.   
               end /* if */.   
            end /* else */.      
        end.

        assign v_cod_destinac_cobr:screen-value in frame f_rpt_41_tit_acr_destinac = v_cod_destinac_cobr_aux.
        apply 'leave' to v_cod_destinac_cobr.
        assign v_log_cobr_acr_pix_aux = yes.
    end /* if */.
    else do:
        assign v_cod_destinac_cobr:screen-value in frame f_rpt_41_tit_acr_destinac = ''.
        apply 'leave' to v_cod_destinac_cobr.
        assign v_log_cobr_acr_pix_aux = no. 
    end /* else */.
END. /* ON VALUE-CHANGED OF v_log_cobr_acr_pix IN FRAME f_rpt_41_tit_acr_destinac */

ON VALUE-CHANGED OF v_log_destinac_manual IN FRAME f_rpt_41_tit_acr_destinac
DO:

    if input frame f_rpt_41_tit_acr_destinac v_log_destinac_manual = yes then
       assign rs_ind_run_mode:screen-value = "On-Line" /*l_online*/ .

END. /* ON VALUE-CHANGED OF v_log_destinac_manual IN FRAME f_rpt_41_tit_acr_destinac */


/************************ User Interface Trigger End ************************/

/************************** Function Trigger Begin **************************/


ON  CHOOSE OF bt_zoo_221588 IN FRAME f_rpt_41_tit_acr_destinac
OR F5 OF v_cod_destinac_cobr IN FRAME f_rpt_41_tit_acr_destinac DO:

    &if defined(BF_FIN_PIX_3_FLEXIBILIZA) &then
    if  v_cod_pais_empres_usuar = "BRA" /*l_bra*/ 
    then do:
       assign v_log_cobr_acr_pix_aux =  input frame f_rpt_41_tit_acr_destinac v_log_cobr_acr_pix.
    end /* if */.
    &endif

    if  search('prgfin/acr/acr025ka.r') = ? and search('prgfin/acr/acr025ka.p') = ? then do:
        if  v_cod_dwb_user begins 'es_' then
            return 'Programa execut†vel n∆o foi encontrado:' /* l_programa_nao_encontrado*/  + 'prgfin/acr/acr025ka.p'.
        else do:
            message getStrTrans('Programa execut†vel n∆o foi encontrado:', 'ACR') /* l_programa_nao_encontrado*/  'prgfin/acr/acr025ka.p'
                   view-as alert-box error buttons ok.
            return.
        end.
    end.
    else
        run prgfin/acr/acr025ka.p /* prg_sea_destinac_cobr*/.
    if  v_rec_destinac_cobr <> ?
    then do:
        find destinac_cobr where recid(destinac_cobr) = v_rec_destinac_cobr no-lock no-error.
        assign v_cod_destinac_cobr:screen-value in frame f_rpt_41_tit_acr_destinac =
               string(destinac_cobr.cod_destinac_cobr).

        display destinac_cobr.des_destinac_cobr
                with frame f_rpt_41_tit_acr_destinac.

        apply 'entry' to v_cod_destinac_cobr in frame f_rpt_41_tit_acr_destinac.
    end /* if */.
end. /* ON  CHOOSE OF bt_zoo_221588 IN FRAME f_rpt_41_tit_acr_destinac */

ON  CHOOSE OF bt_zoo_221698 IN FRAME f_ran_01_tit_acr_destinac
OR F5 OF v_cdn_cliente_fim IN FRAME f_ran_01_tit_acr_destinac DO:

    /* fn_generic_zoom_variable */
    if  search("prgint/ufn/ufn011ka.r") = ? and search("prgint/ufn/ufn011ka.p") = ? then do:
        if  v_cod_dwb_user begins 'es_' then
            return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgint/ufn/ufn011ka.p".
        else do:
            message getStrTrans("Programa execut†vel n∆o foi encontrado:", "ACR") /*l_programa_nao_encontrado*/  "prgint/ufn/ufn011ka.p"
                   view-as alert-box error buttons ok.
            return.
        end.
    end.
    else
        run prgint/ufn/ufn011ka.p /*prg_sea_clien_financ*/.
    if  v_rec_clien_financ <> ?
    then do:
        find clien_financ where recid(clien_financ) = v_rec_clien_financ no-lock no-error.
        assign v_cdn_cliente_fim:screen-value in frame f_ran_01_tit_acr_destinac =
               string(clien_financ.cdn_cliente).

        apply "entry" to v_cdn_cliente_fim in frame f_ran_01_tit_acr_destinac.
    end /* if */.

end. /* ON  CHOOSE OF bt_zoo_221698 IN FRAME f_ran_01_tit_acr_destinac */

ON  CHOOSE OF bt_zoo_221699 IN FRAME f_ran_01_tit_acr_destinac
OR F5 OF v_cdn_cliente_ini IN FRAME f_ran_01_tit_acr_destinac DO:

    /* fn_generic_zoom_variable */
    if  search("prgint/ufn/ufn011ka.r") = ? and search("prgint/ufn/ufn011ka.p") = ? then do:
        if  v_cod_dwb_user begins 'es_' then
            return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgint/ufn/ufn011ka.p".
        else do:
            message getStrTrans("Programa execut†vel n∆o foi encontrado:", "ACR") /*l_programa_nao_encontrado*/  "prgint/ufn/ufn011ka.p"
                   view-as alert-box error buttons ok.
            return.
        end.
    end.
    else
        run prgint/ufn/ufn011ka.p /*prg_sea_clien_financ*/.
    if  v_rec_clien_financ <> ?
    then do:
        find clien_financ where recid(clien_financ) = v_rec_clien_financ no-lock no-error.
        assign v_cdn_cliente_ini:screen-value in frame f_ran_01_tit_acr_destinac =
               string(clien_financ.cdn_cliente).

        apply "entry" to v_cdn_cliente_ini in frame f_ran_01_tit_acr_destinac.
    end /* if */.

end. /* ON  CHOOSE OF bt_zoo_221699 IN FRAME f_ran_01_tit_acr_destinac */

ON  CHOOSE OF bt_zoo_282498 IN FRAME f_rpt_41_tit_acr_destinac
OR F5 OF v_cod_cart_bcia IN FRAME f_rpt_41_tit_acr_destinac DO:

    /* fn_generic_zoom_variable */
    if  search("prgint/ufn/ufn012ka.r") = ? and search("prgint/ufn/ufn012ka.p") = ? then do:
        if  v_cod_dwb_user begins 'es_' then
            return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgint/ufn/ufn012ka.p".
        else do:
            message getStrTrans("Programa execut†vel n∆o foi encontrado:", "ACR") /*l_programa_nao_encontrado*/  "prgint/ufn/ufn012ka.p"
                   view-as alert-box error buttons ok.
            return.
        end.
    end.
    else
        run prgint/ufn/ufn012ka.p /*prg_sea_cart_bcia*/.
    if  v_rec_cart_bcia <> ?
    then do:
        find cart_bcia where recid(cart_bcia) = v_rec_cart_bcia no-lock no-error.
        assign v_cod_cart_bcia:screen-value in frame f_rpt_41_tit_acr_destinac =
               string(cart_bcia.cod_cart_bcia).

        apply "entry" to v_cod_cart_bcia in frame f_rpt_41_tit_acr_destinac.
    end /* if */.

end. /* ON  CHOOSE OF bt_zoo_282498 IN FRAME f_rpt_41_tit_acr_destinac */


/*************************** Function Trigger End ***************************/

/**************************** Frame Trigger Begin ***************************/


ON HELP OF FRAME f_ran_01_tit_acr_destinac ANYWHERE
DO:


    /* Begin_Include: i_context_help */
    run prgtec/men/men900za.py (Input self:handle,
                                Input this-procedure:handle) /*prg_fnc_chamar_help_context*/.
    /* End_Include: i_context_help */

END. /* ON HELP OF FRAME f_ran_01_tit_acr_destinac */

ON RIGHT-MOUSE-DOWN OF FRAME f_ran_01_tit_acr_destinac ANYWHERE
DO:

    /************************* Variable Definition Begin ************************/

    def var v_wgh_frame
        as widget-handle
        format ">>>>>>9":U
        no-undo.


    /************************** Variable Definition End *************************/


    /* Begin_Include: i_right_mouse_down_dialog_box */
    if  (self:type <> "DIALOG-BOX" /*l_dialog_box*/ )
    and (self:type <> "FRAME" /*l_frame*/      )
    and (self:type <> "text" /*l_text*/       )
    and (self:type <> "IMAGE" /*l_image*/      )
    and (self:type <> "RECTANGLE" /*l_rectangle*/  )
    then do:

        assign v_wgh_frame = self:parent.

        if  self:type        = "fill-in" /*l_fillin*/ 
        and v_wgh_frame:type = "Browse" /*l_browse*/  then
            return no-apply.

        if  valid-handle(self:popup-menu) = yes then
            return no-apply.

        assign v_wgh_frame = self:frame.

        if  (v_wgh_frame:type <> "DIALOG-BOX" /*l_dialog_box*/ ) and (v_wgh_frame:frame <> ?)
        then do:
               assign v_wgh_frame     = v_wgh_frame:frame.
        end /* if */.
        assign v_nom_title_aux    = v_wgh_frame:title
               v_wgh_frame:title  = self:help.
    end /* if */.
    /* End_Include: i_right_mouse_down_dialog_box */

END. /* ON RIGHT-MOUSE-DOWN OF FRAME f_ran_01_tit_acr_destinac */

ON RIGHT-MOUSE-UP OF FRAME f_ran_01_tit_acr_destinac ANYWHERE
DO:

    /************************* Variable Definition Begin ************************/

    def var v_wgh_frame
        as widget-handle
        format ">>>>>>9":U
        no-undo.


    /************************** Variable Definition End *************************/


    /* Begin_Include: i_right_mouse_up_dialog_box */
    if  (self:type <> "DIALOG-BOX" /*l_dialog_box*/ )
    and (self:type <> "FRAME" /*l_frame*/      )
    and (self:type <> "text" /*l_text*/       )
    and (self:type <> "IMAGE" /*l_image*/      )
    and (self:type <> "RECTANGLE" /*l_rectangle*/  )
    then do:

        assign v_wgh_frame = self:parent.

        if  self:type        = "fill-in" /*l_fillin*/ 
        and v_wgh_frame:type = "Browse" /*l_browse*/  then
            return no-apply.

        if  valid-handle(self:popup-menu) = yes then
            return no-apply.

        assign v_wgh_frame        = self:frame.
        if  (v_wgh_frame:type <> "DIALOG-BOX" /*l_dialog_box*/ ) and (v_wgh_frame:frame <> ?)
        then do:
               assign v_wgh_frame     = v_wgh_frame:frame.
        end /* if */.
        assign v_wgh_frame:title  = v_nom_title_aux.
    end /* if */.

    /* End_Include: i_right_mouse_up_dialog_box */

END. /* ON RIGHT-MOUSE-UP OF FRAME f_ran_01_tit_acr_destinac */

ON WINDOW-CLOSE OF FRAME f_ran_01_tit_acr_destinac
DO:

    apply "end-error" to self.
END. /* ON WINDOW-CLOSE OF FRAME f_ran_01_tit_acr_destinac */

ON ENTRY OF FRAME f_rpt_41_tit_acr_destinac
DO:


END. /* ON ENTRY OF FRAME f_rpt_41_tit_acr_destinac */

ON ENDKEY OF FRAME f_rpt_41_tit_acr_destinac
DO:


    /* Begin_Include: i_exec_program_epc */
    &if '{&emsbas_version}' > '1.00' &then
    if  v_nom_prog_upc <> '' then
    do:
        assign v_rec_table_epc = recid(tit_acr).    
        run value(v_nom_prog_upc) (input 'CANCEL',
                                   input 'viewer',
                                   input this-procedure,
                                   input v_wgh_frame_epc,
                                   input v_nom_table_epc,
                                   input v_rec_table_epc).
        if  'no' = 'yes'
        and return-value = 'NOK' then
            undo, retry.
    end.

    if  v_nom_prog_appc <> '' then
    do:
        assign v_rec_table_epc = recid(tit_acr).    
        run value(v_nom_prog_appc) (input 'CANCEL',
                                    input 'viewer',
                                    input this-procedure,
                                    input v_wgh_frame_epc,
                                    input v_nom_table_epc,
                                    input v_rec_table_epc).
        if  'no' = 'yes'
        and return-value = 'NOK' then
            undo, retry.
    end.

    &if '{&emsbas_version}' > '5.00' &then
    if  v_nom_prog_dpc <> '' then
    do:
        assign v_rec_table_epc = recid(tit_acr).    
        run value(v_nom_prog_dpc) (input 'CANCEL',
                                    input 'viewer',
                                    input this-procedure,
                                    input v_wgh_frame_epc,
                                    input v_nom_table_epc,
                                    input v_rec_table_epc).
        if  'no' = 'yes'
        and return-value = 'NOK' then
            undo, retry.
    end.
    &endif
    &endif
    /* End_Include: i_exec_program_epc */

END. /* ON ENDKEY OF FRAME f_rpt_41_tit_acr_destinac */

ON GO OF FRAME f_rpt_41_tit_acr_destinac
DO:

    do transaction:
        find dwb_rpt_param
            where dwb_rpt_param.cod_dwb_user    = v_cod_usuar_corren
            and   dwb_rpt_param.cod_dwb_program = v_cod_dwb_program
            exclusive-lock no-error.
        assign dwb_rpt_param.cod_dwb_output     = rs_cod_dwb_output:screen-value in frame f_rpt_41_tit_acr_destinac
               dwb_rpt_param.qtd_dwb_line       = input frame f_rpt_41_tit_acr_destinac v_qtd_line
    &if '{&emsbas_version}' > '1.00' &then
    &if '{&emsbas_version}' >= '5.03' &then
               dwb_rpt_param.nom_dwb_print_file = v_nom_dwb_print_file
    &else
               dwb_rpt_param.cod_livre_1 = v_nom_dwb_print_file
    &endif
    &endif
    .
        if  dwb_rpt_param.cod_dwb_output = "Arquivo" /*l_file*/ 
        then do:
             run pi_filename_validation (Input dwb_rpt_param.cod_dwb_file) /*pi_filename_validation*/.
             if  dwb_rpt_param.ind_dwb_run_mode <> "Batch" /*l_batch*/ 
             then do:
                 if  index  ( dwb_rpt_param.cod_dwb_file ,'~\') <> 0
                 then do:
                      assign file-info:file-name= substring( dwb_rpt_param.cod_dwb_file ,
                                                             1,
                                                             r-index  ( dwb_rpt_param.cod_dwb_file ,'~\') - 1
                                                            ).
                 end /* if */.
                 else do:
                      assign file-info:file-name= substring( dwb_rpt_param.cod_dwb_file ,
                                                             1,
                                                             r-index  ( dwb_rpt_param.cod_dwb_file ,'/') - 1
                                                            ).
                 end /* else */.
                 if  (  file-info:file-type = ? )
                 and    (  index  ( dwb_rpt_param.cod_dwb_file ,'~\') <> 0
                              or
                           index  ( dwb_rpt_param.cod_dwb_file ,'/')  <> 0
                              or
                           index  ( dwb_rpt_param.cod_dwb_file ,':')  <> 0
                         )
                 then do:
                     /* O diret¢rio &1 n∆o existe ! */
                     run pi_messages (input "show",
                                      input 4354,
                                      input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                                         file-info:file-name)) /*msg_4354*/.
                     return no-apply.
                  end /* if */.
             end /* if */.
             if  return-value = "NOK" /*l_nok*/ 
             then do:
                 /* Nome do arquivo incorreto ! */
                 run pi_messages (input "show",
                                  input 1064,
                                  input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_1064*/.
                 return no-apply.
             end /* if */.
        end /* if */.
        else do:
            if  dwb_rpt_param.cod_dwb_output = "Impressora" /*l_printer*/ 
            then do:
                if  not avail layout_impres
                then do:
                   /* Layout de impress∆o inexistente ! */
                   run pi_messages (input "show",
                                    input 4366,
                                    input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_4366*/.
                   return no-apply.
                end /* if */.
                if  dwb_rpt_param.nom_dwb_printer = ""
                or   dwb_rpt_param.cod_dwb_print_layout = ""
                then do:
                    /* Impressora destino e layout de impress∆o n∆o definidos ! */
                    run pi_messages (input "show",
                                     input 2052,
                                     input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_2052*/.
                    return no-apply.
                end /* if */.
            end /* if */.
        end /* else */.
    end.    

END. /* ON GO OF FRAME f_rpt_41_tit_acr_destinac */

ON HELP OF FRAME f_rpt_41_tit_acr_destinac ANYWHERE
DO:


    /* Begin_Include: i_context_help */
    run prgtec/men/men900za.py (Input self:handle,
                                Input this-procedure:handle) /*prg_fnc_chamar_help_context*/.
    /* End_Include: i_context_help */

END. /* ON HELP OF FRAME f_rpt_41_tit_acr_destinac */

ON RIGHT-MOUSE-DOWN OF FRAME f_rpt_41_tit_acr_destinac ANYWHERE
DO:

    /************************* Variable Definition Begin ************************/

    def var v_wgh_frame
        as widget-handle
        format ">>>>>>9":U
        no-undo.


    /************************** Variable Definition End *************************/


    /* Begin_Include: i_right_mouse_down_dialog_box */
    if  (self:type <> "DIALOG-BOX" /*l_dialog_box*/ )
    and (self:type <> "FRAME" /*l_frame*/      )
    and (self:type <> "text" /*l_text*/       )
    and (self:type <> "IMAGE" /*l_image*/      )
    and (self:type <> "RECTANGLE" /*l_rectangle*/  )
    then do:

        assign v_wgh_frame = self:parent.

        if  self:type        = "fill-in" /*l_fillin*/ 
        and v_wgh_frame:type = "Browse" /*l_browse*/  then
            return no-apply.

        if  valid-handle(self:popup-menu) = yes then
            return no-apply.

        assign v_wgh_frame = self:frame.

        if  (v_wgh_frame:type <> "DIALOG-BOX" /*l_dialog_box*/ ) and (v_wgh_frame:frame <> ?)
        then do:
               assign v_wgh_frame     = v_wgh_frame:frame.
        end /* if */.
        assign v_nom_title_aux    = v_wgh_frame:title
               v_wgh_frame:title  = self:help.
    end /* if */.
    /* End_Include: i_right_mouse_down_dialog_box */

END. /* ON RIGHT-MOUSE-DOWN OF FRAME f_rpt_41_tit_acr_destinac */

ON RIGHT-MOUSE-UP OF FRAME f_rpt_41_tit_acr_destinac ANYWHERE
DO:

    /************************* Variable Definition Begin ************************/

    def var v_wgh_frame
        as widget-handle
        format ">>>>>>9":U
        no-undo.


    /************************** Variable Definition End *************************/


    /* Begin_Include: i_right_mouse_up_dialog_box */
    if  (self:type <> "DIALOG-BOX" /*l_dialog_box*/ )
    and (self:type <> "FRAME" /*l_frame*/      )
    and (self:type <> "text" /*l_text*/       )
    and (self:type <> "IMAGE" /*l_image*/      )
    and (self:type <> "RECTANGLE" /*l_rectangle*/  )
    then do:

        assign v_wgh_frame = self:parent.

        if  self:type        = "fill-in" /*l_fillin*/ 
        and v_wgh_frame:type = "Browse" /*l_browse*/  then
            return no-apply.

        if  valid-handle(self:popup-menu) = yes then
            return no-apply.

        assign v_wgh_frame        = self:frame.
        if  (v_wgh_frame:type <> "DIALOG-BOX" /*l_dialog_box*/ ) and (v_wgh_frame:frame <> ?)
        then do:
               assign v_wgh_frame     = v_wgh_frame:frame.
        end /* if */.
        assign v_wgh_frame:title  = v_nom_title_aux.
    end /* if */.

    /* End_Include: i_right_mouse_up_dialog_box */

END. /* ON RIGHT-MOUSE-UP OF FRAME f_rpt_41_tit_acr_destinac */

ON WINDOW-CLOSE OF FRAME f_rpt_41_tit_acr_destinac
DO:

    apply "end-error" to self.
END. /* ON WINDOW-CLOSE OF FRAME f_rpt_41_tit_acr_destinac */


/***************************** Frame Trigger End ****************************/

/**************************** Menu Trigger Begin ****************************/


ON CHOOSE OF MENU-ITEM mi_conteudo IN MENU m_help
DO:


        apply "choose" to bt_hel2 in frame f_rpt_41_tit_acr_destinac.





END. /* ON CHOOSE OF MENU-ITEM mi_conteudo IN MENU m_help */

ON CHOOSE OF MENU-ITEM mi_sobre IN MENU m_help
DO:

    /************************* Variable Definition Begin ************************/

    def var v_cod_release
        as character
        format "x(12)":U
        no-undo.
    def var v_nom_prog
        as character
        format "x(8)":U
        no-undo.
    def var v_nom_prog_ext
        as character
        format "x(8)":U
        label "Nome Externo"
        no-undo.


    /************************** Variable Definition End *************************/


        assign v_nom_prog     = substring(frame f_rpt_41_tit_acr_destinac:title, 1, max(1, length(frame f_rpt_41_tit_acr_destinac:title) - 10)).
        if  v_nom_prog = ? then
            assign v_nom_prog = "".

        assign v_nom_prog     = v_nom_prog
                              + chr(10)
                              + "rpt_tit_acr_destinac":U.




    assign v_nom_prog_ext = "prgfin/acr/acr739ab.py":U
           v_cod_release  = trim(" 1.00.02.097":U).
/*    run prgtec/btb/btb901zb.p (Input v_nom_prog,
                               Input v_nom_prog_ext,
                               Input v_cod_release) /*prg_fnc_about*/. */
{include/sobre5.i}
END. /* ON CHOOSE OF MENU-ITEM mi_sobre IN MENU m_help */


/***************************** Menu Trigger End *****************************/


/****************************** Main Code Begin *****************************/


/* Begin_Include: i_version_extract */
{include/i-ctrlrp5.i rpt_tit_acr_destinac}


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
    run pi_version_extract ('rpt_tit_acr_destinac':U, 'prgfin/acr/acr739ab.py':U, '1.00.02.097':U, 'pro':U).
end /* if */.



/* End_Include: i_version_extract */

run pi_return_user (output v_cod_dwb_user) /*pi_return_user*/.

if  search("prgtec/btb/btb906za.r") = ? and search("prgtec/btb/btb906za.py") = ? then do:
    if  v_cod_dwb_user begins 'es_' then
        return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgtec/btb/btb906za.py".
    else do:
        message getStrTrans("Programa execut†vel n∆o foi encontrado:", "ACR") /*l_programa_nao_encontrado*/  "prgtec/btb/btb906za.py"
               view-as alert-box error buttons ok.
        stop.
    end.
end.
else
    run prgtec/btb/btb906za.py /*prg_fnc_verify_controls*/.
if (v_cod_dwb_user = "") then
   assign v_cod_dwb_user = v_cod_usuar_corren.


/* Begin_Include: i_verify_security */
if  search("prgtec/men/men901za.r") = ? and search("prgtec/men/men901za.py") = ? then do:
    if  v_cod_dwb_user begins 'es_' then
        return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgtec/men/men901za.py".
    else do:
        message getStrTrans("Programa execut†vel n∆o foi encontrado:", "ACR") /*l_programa_nao_encontrado*/  "prgtec/men/men901za.py"
               view-as alert-box error buttons ok.
        return.
    end.
end.
else
    run prgtec/men/men901za.py (Input 'rpt_tit_acr_destinac') /*prg_fnc_verify_security*/.
if  return-value = "2014"
then do:
    /* Programa a ser executado n∆o Ç um programa v†lido Datasul ! */
    run pi_messages (input "show",
                     input 2014,
                     input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                       'rpt_tit_acr_destinac')) /*msg_2014*/.
    return.
end /* if */.
if  return-value = "2012"
then do:
    /* Usu†rio sem permiss∆o para acessar o programa. */
    run pi_messages (input "show",
                     input 2012,
                     input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                       'rpt_tit_acr_destinac')) /*msg_2012*/.
    return.
end /* if */.
/* End_Include: i_verify_security */



/* Begin_Include: i_log_exec_prog_dtsul_ini */
assign v_rec_log = ?.

if can-find(prog_dtsul
       where prog_dtsul.cod_prog_dtsul = 'rpt_tit_acr_destinac' 
         and prog_dtsul.log_gera_log_exec = yes) then do transaction:
    create log_exec_prog_dtsul.
    assign log_exec_prog_dtsul.cod_prog_dtsul           = 'rpt_tit_acr_destinac'
           log_exec_prog_dtsul.cod_usuario              = v_cod_usuar_corren
           log_exec_prog_dtsul.dat_inic_exec_prog_dtsul = today
           log_exec_prog_dtsul.hra_inic_exec_prog_dtsul = replace(string(time,"hh:mm:ss" /*l_hh:mm:ss*/ ),":":U,"":U).
    assign v_rec_log = recid(log_exec_prog_dtsul).
    release log_exec_prog_dtsul no-error.
end.


/* End_Include: i_log_exec_prog_dtsul_ini */

/* tech38629 - Alteraá∆o efetuada via filtro */
&if '{&emsbas_version}':U >= '5.05':U and not proversion begins '10.1A':U &then
run pi_permissoes in v_prog_filtro_pdf (input 'rpt_tit_acr_destinac':U).
&endif
/* tech38629 - Fim da alteraá∆o */





/* Begin_Include: i_verify_program_epc */
&if '{&emsbas_version}' > '1.00' &then
assign v_rec_table_epc = ?
       v_wgh_frame_epc = ?.

find prog_dtsul
    where prog_dtsul.cod_prog_dtsul = "rpt_tit_acr_destinac":U
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


assign v_wgh_frame_epc = frame f_rpt_41_tit_acr_destinac:handle.



assign v_nom_table_epc = 'tit_acr':U
       v_rec_table_epc = recid(tit_acr).

&endif

/* End_Include: i_verify_program_epc */


/* redefiniá‰es do frame */

/* Begin_Include: i_std_dialog_box */
/* tratamento do titulo e vers∆o */
assign frame f_rpt_41_tit_acr_destinac:title = frame f_rpt_41_tit_acr_destinac:title
                            + chr(32)
                            + chr(40)
                            + trim(" 1.00.02.097":U)
                            + chr(41).
/* menu pop-up de ajuda e sobre */
assign menu m_help:popup-only = yes
       bt_hel2:popup-menu in frame f_rpt_41_tit_acr_destinac = menu m_help:handle.


/* End_Include: i_std_dialog_box */
{include/title5.i f_rpt_41_tit_acr_destinac FRAME}
{include/i_trdmnu.i "menu m_help:handle"}


/* inicializa vari†veis */
find empresa no-lock
     where empresa.cod_empresa = v_cod_empres_usuar /*cl_empres_usuar of empresa*/ no-error.
find dwb_rpt_param
     where dwb_rpt_param.cod_dwb_program = "tar_gerar_destinac_cobr":U
       and dwb_rpt_param.cod_dwb_user    = v_cod_dwb_user
       no-lock no-error.
if  avail dwb_rpt_param then do:
&if '{&emsbas_version}' > '1.00' &then
&if '{&emsbas_version}' >= '5.03' &then
    assign v_nom_dwb_print_file = dwb_rpt_param.nom_dwb_print_file.
&else
    assign v_nom_dwb_print_file = dwb_rpt_param.cod_livre_1.
&endif
&endif
    if  dwb_rpt_param.qtd_dwb_line <> 0 then
        assign v_qtd_line = dwb_rpt_param.qtd_dwb_line.
    else
        assign v_qtd_line = v_rpt_s_1_lines.
end.
assign v_cod_dwb_proced   = "tar_gerar_destinac_cobr":U
       v_cod_dwb_program  = "tar_gerar_destinac_cobr":U
       v_cod_release      = trim(" 1.00.02.097":U)
       v_ind_dwb_run_mode = "On-Line" /*l_online*/ 
       v_qtd_column       = v_rpt_s_1_columns
       v_qtd_bottom       = v_rpt_s_1_bottom.
if (avail empresa) then
    assign v_nom_enterprise   = empresa.nom_razao_social.
else
    assign v_nom_enterprise   = 'DATASUL'.


/* Begin_Include: ix_p00_rpt_tit_acr_destinac */
assign v_cod_ser_docto_ini:width in frame f_ran_01_tit_acr_destinac = 06.00
       v_cod_tit_acr_ini:width    in frame f_ran_01_tit_acr_destinac = 17.00
       v_cod_ser_docto_ini:format in frame f_ran_01_tit_acr_destinac = 'x(5)'
       v_cod_tit_acr_ini:format in frame f_ran_01_tit_acr_destinac = 'x(16)'
       v_cod_ser_docto_fim:width in frame f_ran_01_tit_acr_destinac = 06.00
       v_cod_tit_acr_fim:width    in frame f_ran_01_tit_acr_destinac = 17.00
       v_cod_ser_docto_fim:format in frame f_ran_01_tit_acr_destinac = 'x(5)'
       v_cod_tit_acr_fim:format in frame f_ran_01_tit_acr_destinac = 'x(16)'.
assign v_cod_ser_docto_fim = 'ZZZZZ'
       v_cod_tit_acr_fim = 'ZZZZZZZZZZZZZZZZ'.       

run prgint/utb/utb922za.py persistent set v_hdl_funcao_padr.

FUNCTION GetEntryField RETURNS CHARACTER (input p_num_posicao     AS INTEGER,
                                          INPUT p_cod_campo       AS CHARACTER,
                                          input p_cod_separador   AS CHARACTER) in v_hdl_funcao_padr.
FUNCTION GetDefinedFunction RETURNS LOGICAL (INPUT SPP AS CHARACTER) in v_hdl_funcao_padr.


&if '{&emsfin_version}' < "5.04" &then
  run prgfin/acr/acr856aa.p /*prg_spp_atualiza_prazo_auto_emissao*/.
  if rs_imforma_cart_bcia:delete(getStrTrans("Cliente Financeiro", "ACR") /*l_cliente_financeiro*/ ) then.
&endif
run prgfin/acr/acr864aa.py /*prg_spp_cep_agenc_bcia_faixa*/.
run pi_verifica_destinac_tit_vencid.
run pi_verifica_funcoes_cobr_especial.

/* Begin_Include: i_verifica_controle_terceiros_acr */
assign v_log_control_terc_acr = no.
find histor_exec_especial no-lock
     where histor_exec_especial.cod_modul_dtsul = "UFN" /*l_ufn*/ 
     and   histor_exec_especial.cod_prog_dtsul  = 'SPP_CONTROLE_TERCEIROS_ACR':u
     no-error.
if avail histor_exec_especial then
   assign v_log_control_terc_acr = yes.

/* Begin_Include: i_funcao_extract */
if  v_cod_arq <> '' and v_cod_arq <> ?
then do:

    output stream s-arq to value(v_cod_arq) append.

    put stream s-arq unformatted
        'SPP_CONTROLE_TERCEIROS_ACR':U      at 1 
        v_log_control_terc_acr  at 43 skip.

    output stream s-arq close.

end /* if */.
/* End_Include: i_funcao_extract */
. 

/* End_Include: i_funcao_extract */

run pi_verifica_vendor.

/* Begin_Include: i_vrf_funcao_destinac_percent_sdo_titulos */
assign v_log_destinac_percent_sdo = no.

/*
&if defined(BF_FIN_DESTINAC_PERCENT_SDO_TITULOS) &then
    assign v_log_destinac_percent_sdo = yes.
&else
    if  can-find(first histor_exec_especial
        where histor_exec_especial.cod_prog_dtsul = 'SPP_DESTINAC_PERCENT_SDO_TITULOS') then
        assign v_log_destinac_percent_sdo = yes.

    /* Begin_Include: i_funcao_extract */
    if  v_cod_arq <> '' and v_cod_arq <> ?
    then do:

        output stream s-arq to value(v_cod_arq) append.

        put stream s-arq unformatted
            'spp_destinac_percent_sdo_titulos'      at 1 
            v_log_destinac_percent_sdo  at 43 skip.

        output stream s-arq close.

    end /* if */.
    /* End_Include: i_funcao_extract */

&endif
/* End_Include: i_funcao_extract */
*/

run pi_verifica_tit_nao_destinados.

assign v_log_pessoa_fisic_cobr = &IF DEFINED (BF_FIN_ENDER_COB_PESSOA_FISIC) &THEN YES &ELSE GetDefinedFunction('SPP_ENDER_COB_PESSOA_FISIC':U) &ENDIF.

&if defined(BF_FIN_MAIS_NEGOCIOS_FLEXIBILIZA) &then

   /* Begin_Include: i_verifica_integr_mais_negoc */
   run hbbo/boParamFuncaoProdut.p persistent set v_hdl_existe_funcao.
   run pi_existe_funcao in v_hdl_existe_funcao (input  "TOTVS Mais Negocios" /*l_totvs_mais_negocios*/ ,
                                                output v_log_integr_mais_negoc).                              
   if  valid-handle(v_hdl_existe_funcao) then
       delete procedure v_hdl_existe_funcao.
   /* End_Include: i_verifica_integr_mais_negoc */


   /* Begin_Include: i_retorna_portad_cart_mais_negocio */
   if v_log_integr_mais_negoc then do:
       run prgfin/acr/acr559za.py PERSISTENT SET v_hdl_api_param_mais_negoc.

       run pi_posiciona_dados_integr_mais_negoc in v_hdl_api_param_mais_negoc.
       run pi_retorna_portador_mais_negoc in v_hdl_api_param_mais_negoc (output v_cod_portad_mais_negoc).
       run pi_retorna_carteira_mais_negoc in v_hdl_api_param_mais_negoc (output v_cod_cart_bcia_mais_negoc).

       if  valid-handle(v_hdl_api_param_mais_negoc) then
           delete procedure v_hdl_api_param_mais_negoc no-error.
   end.
   /* End_Include: i_retorna_portad_cart_mais_negocio */

&endif

/* End_Include: i_retorna_portad_cart_mais_negocio */


if  v_cod_dwb_user begins 'es_'
then do:
    find dwb_rpt_param no-lock
         where dwb_rpt_param.cod_dwb_program = v_cod_dwb_program
           and dwb_rpt_param.cod_dwb_user = v_cod_dwb_user /*cl_dwb_rpt_param of dwb_rpt_param*/ no-error.
    if (not avail dwb_rpt_param) then
        return getStrTrans("ParÉmetros para o relat¢rio n∆o encontrado.", "ACR") /*1993*/ + " (" + "1993" + ")" + chr(10) + getStrTrans("N∆o foi poss°vel encontrar os parÉmetros necess†rios para a impress∆o do relat¢rio para o programa e usu†rio corrente.", "ACR") /*1993*/.
    if index( dwb_rpt_param.cod_dwb_file ,'~\') <> 0 then
        assign file-info:file-name = replace(dwb_rpt_param.cod_dwb_file, '~\', '~/').
    else
        assign file-info:file-name = dwb_rpt_param.cod_dwb_file.

    assign file-info:file-name = substring(file-info:file-name, 1,
                                           r-index(file-info:file-name, '~/') - 1).
    if  dwb_rpt_param.cod_dwb_output = "Arquivo" /*l_file*/ 
    then do:
       if file-info:file-type = ? then
          return "Diret¢rio Inexistente:" /*l_directory*/  + dwb_rpt_param.cod_dwb_file.
    end /* if */.

    find ped_exec no-lock
         where ped_exec.num_ped_exec = v_num_ped_exec_corren /*cl_le_ped_exec_global of ped_exec*/ no-error.
    if (ped_exec.cod_release_prog_dtsul <> trim(" 1.00.02.097":U)) then
        return getStrTrans("Vers‰es do programa diferente.", "ACR") /*1994*/ + " (" + "1994" + ")" + chr(10)
                                     + substitute(getStrTrans("A vers∆o do programa (&3) que gerou o pedido de execuá∆o batch (&1) Ç diferente da vers∆o do programa que deveria executar o pedido batch (&2).", "ACR") /*1994*/,ped_exec.cod_release_prog_dtsul,
                                                  trim(" 1.00.02.097":U),
                                                  "prgfin/acr/acr739ab.py":U).
    assign v_nom_prog_ext     = caps("acr739ab":U)
           v_dat_execution    = today
           v_hra_execution    = replace(string(time, "hh:mm:ss" /*l_hh:mm:ss*/ ), ":", "")
           v_cod_dwb_file     = dwb_rpt_param.cod_dwb_file
           v_nom_report_title = fill(" ", 40 - length(v_rpt_s_1_name)) + v_rpt_s_1_name
           v_ind_dwb_run_mode = "Batch" /*l_batch*/ .


    /* Begin_Include: ix_p02_rpt_tit_acr_destinac */
    if num-entries( dwb_rpt_param.cod_dwb_parameters , chr(10) ) >= 34 then do:
       assign v_cod_destinac_cobr = entry(1, dwb_rpt_param.cod_dwb_parameters, chr(10))
              v_dat_destinac = date(entry(2, dwb_rpt_param.cod_dwb_parameters, chr(10)))
              v_ind_tip_destinac = entry(3, dwb_rpt_param.cod_dwb_parameters, chr(10))
              v_log_destinac_manual = (entry(4, dwb_rpt_param.cod_dwb_parameters, chr(10)) = "yes" /*l_yes*/ )
              v_log_habilit_redestina_cobr = (entry(5, dwb_rpt_param.cod_dwb_parameters, chr(10)) = "yes" /*l_yes*/ )
              v_cdn_cliente_fim = integer(entry(6, dwb_rpt_param.cod_dwb_parameters, chr(10)))
              v_cdn_cliente_ini = integer(entry(7, dwb_rpt_param.cod_dwb_parameters, chr(10)))
              v_cod_cart_bcia_fim = entry(8, dwb_rpt_param.cod_dwb_parameters, chr(10))
              v_cod_cart_bcia_inicial = entry(9, dwb_rpt_param.cod_dwb_parameters, chr(10))
              v_cod_espec_docto_fim = entry(10, dwb_rpt_param.cod_dwb_parameters, chr(10))
              v_cod_espec_docto_ini = entry(11, dwb_rpt_param.cod_dwb_parameters, chr(10))
              v_cod_parcela_fim = entry(12, dwb_rpt_param.cod_dwb_parameters, chr(10))
              v_cod_parcela_ini = entry(13, dwb_rpt_param.cod_dwb_parameters, chr(10))
              v_cod_portador_fim = entry(14, dwb_rpt_param.cod_dwb_parameters, chr(10))
              v_cod_portador_ini = entry(15, dwb_rpt_param.cod_dwb_parameters, chr(10))
              v_cod_ser_docto_fim = entry(16, dwb_rpt_param.cod_dwb_parameters, chr(10))
              v_cod_ser_docto_ini = entry(17, dwb_rpt_param.cod_dwb_parameters, chr(10))
              v_cod_tit_acr_fim = entry(18, dwb_rpt_param.cod_dwb_parameters, chr(10))
              v_cod_tit_acr_ini = entry(19, dwb_rpt_param.cod_dwb_parameters, chr(10))
              v_dat_emis_final = date(entry(20, dwb_rpt_param.cod_dwb_parameters, chr(10)))
              v_dat_emis_inic = date(entry(21, dwb_rpt_param.cod_dwb_parameters, chr(10)))
              v_dat_vencto_final = date(entry(22, dwb_rpt_param.cod_dwb_parameters, chr(10)))
              v_dat_vencto_inicial = date(entry(23, dwb_rpt_param.cod_dwb_parameters, chr(10)))
              v_cod_refer_ini = entry(24, dwb_rpt_param.cod_dwb_parameters, chr(10))
              v_cod_refer_fim = entry(25, dwb_rpt_param.cod_dwb_parameters, chr(10))
              v_val_sdo_inic = decimal( entry(26, dwb_rpt_param.cod_dwb_parameters, chr(10)) )
              v_val_sdo_fim = decimal( entry(27, dwb_rpt_param.cod_dwb_parameters, chr(10)) )
              v_cod_estab_ini = entry(28, dwb_rpt_param.cod_dwb_parameters, chr(10))
              v_cod_estab_fim = entry(29, dwb_rpt_param.cod_dwb_parameters, chr(10))
              v_ind_obs = entry(30, dwb_rpt_param.cod_dwb_parameters, chr(10))
              rs_imforma_cart_bcia = entry(31, dwb_rpt_param.cod_dwb_parameters, chr(10))
              v_cod_cart_bcia = entry(32, dwb_rpt_param.cod_dwb_parameters, chr(10))
              v_ind_tip_cart_bcia = entry(33, dwb_rpt_param.cod_dwb_parameters, chr(10))
              v_ind_classif_destinac = entry(34, dwb_rpt_param.cod_dwb_parameters, chr(10)).

       if v_log_funcao_tit_nao_dest = yes then do:
          if num-entries( dwb_rpt_param.cod_dwb_parameters , chr(10) ) >= 35 then
             assign v_log_tit_nao_destndo = (entry(35, dwb_rpt_param.cod_dwb_parameters, chr(10)) = "yes" /*l_yes*/ ).
       end.

       if  num-entries( dwb_rpt_param.cod_dwb_parameters , chr(10) ) >= 36  then
           assign v_log_cobr_acr_pix = (entry(36, dwb_rpt_param.cod_dwb_parameters, chr(10)) = "yes" /*l_yes*/ ).

       if string(v_dat_destinac) = "" or v_dat_destinac = ? then assign v_dat_destinac = today.
    end.
    find destinac_cobr no-lock
        where destinac_cobr.cod_empresa = v_cod_empres_usuar
        and destinac_cobr.cod_destinac_cobr = v_cod_destinac_cobr
        and destinac_cobr.dat_inic_valid <= v_dat_destinac
        and destinac_cobr.dat_fim_valid > v_dat_destinac no-error.

    &if '{&emsfin_version}' < "5.04" &then
        assign v_log_verifica_praz_auto_emis = (entry(1, destinac_cobr.cod_livre_1, chr(10)) = "yes" /*l_yes*/ ).
    &else
        assign v_log_verifica_praz_auto_emis = destinac_cobr.log_verifica_praz_auto_emis.
    &endif
    /* End_Include: ix_p02_rpt_tit_acr_destinac */


    /* configura e define destino de impress∆o */
    if (dwb_rpt_param.cod_dwb_output = "Impressora" /*l_printer*/ ) then
        assign v_qtd_line_ant = v_qtd_line.


/* Alteracao via filtro - Impressao grandes volumes - inicio*/
    IF CAN-FIND(FIRST PARAM_extens_ems
                WHERE PARAM_extens_ems.cod_entid_param_ems = "impressao":U
                  AND PARAM_extens_ems.cod_chave_param_ems = "impress_escala":U
                  AND PARAM_extens_ems.cod_param_ems       = "impress_escala":U
                  AND PARAM_extens_ems.log_param_ems       = YES) THEN DO:

       ASSIGN v_nom_dwb_print_file = dwb_rpt_param.cod_dwb_file
              v_nom_dwb_print_file = REPLACE(v_nom_dwb_print_file,"~\","~/")
              v_nom_dwb_print_file = SUBSTRING(v_nom_dwb_print_file, R-INDEX(v_nom_dwb_print_file,"/") + 1).

       ASSIGN c-cod_dwb_user = v_cod_usuar_corren 
              i-num_ped_exec = INTEGER(ENTRY(NUM-ENTRIES(v_cod_dwb_user, "_"),v_cod_dwb_user,"_")) NO-ERROR. 

       IF v_nom_dwb_print_file <> "" THEN DO:
          IF SUBSTRING(v_nom_dwb_print_file, LENGTH(v_nom_dwb_print_file) - 3, 1) = "." THEN
             ASSIGN v_nom_dwb_print_file = SUBSTRING(v_nom_dwb_print_file,1,INDEX(v_nom_dwb_print_file,"."))
                + STRING(TODAY,"99999999")
                + STRING(TIME,"99999")
                + STRING(i-num_ped_exec)
                + SUBSTRING(v_nom_dwb_print_file, LENGTH(v_nom_dwb_print_file) - 3).
          ELSE
             ASSIGN v_nom_dwb_print_file = SUBSTRING(v_nom_dwb_print_file, 1, R-INDEX(v_nom_dwb_print_file,"."))
                   + STRING(TODAY,"99999999")
                   + STRING(TIME,"99999")
                   + STRING(i-num_ped_exec).

          FIND FIRST ped_exec NO-LOCK
             WHERE ped_exec.num_ped_exec = i-num_ped_exec NO-ERROR.
          IF AVAIL ped_exec THEN DO:
             FIND FIRST servid_exec NO-LOCK
                WHERE servid_exec.cod_servid_exec = ped_exec.cod_servid_exec NO-ERROR.
             IF AVAIL servid_exec THEN
                ASSIGN c-servid_exec_nom_dir_spool = servid_exec.nom_dir_spool.
          END.

          FIND FIRST usuar_mestre NO-LOCK
             WHERE usuar_mestre.cod_usuario = c-cod_dwb_user NO-ERROR.
          IF AVAIL usuar_mestre THEN
             ASSIGN c-usuar_mestre_nom_subdir_spool = usuar_mestre.nom_subdir_spool.

          IF CAN-FIND(FIRST param_extens_ems
               WHERE param_extens_ems.cod_entid_param_ems = "impressao":U
                 AND param_extens_ems.cod_chave_param_ems = "impress_escala":U
                 AND param_extens_ems.cod_param_ems       = "impress_escala":U
                 AND param_extens_ems.log_param_ems       = YES) AND
             CAN-FIND(FIRST impressora
                      WHERE impressora.nom_impressora = dwb_rpt_param.nom_dwb_printer
                        AND impressora.log_impres_escal = YES) THEN
             ASSIGN v_nom_dwb_print_file = c-servid_exec_nom_dir_spool + "/" + v_nom_dwb_print_file.
          ELSE
             ASSIGN v_nom_dwb_print_file = c-servid_exec_nom_dir_spool + "/" + c-usuar_mestre_nom_subdir_spool + "/" + v_nom_dwb_print_file.

       END.

       ASSIGN v_nom_dwb_print_file = REPLACE(v_nom_dwb_print_file,"~\","~/").

       DO TRANSACTION:
          FIND b-dwb_rpt_param EXCLUSIVE-LOCK
             WHERE ROWID(b-dwb_rpt_param) = ROWID(dwb_rpt_param) NO-ERROR.
          IF AVAIL b-dwb_rpt_param THEN
             ASSIGN b-dwb_rpt_param.cod_dwb_file = v_nom_dwb_print_file
                    b-dwb_rpt_param.nom_dwb_print_file = v_nom_dwb_print_file.
          RELEASE b-dwb_rpt_param.
       END.
    END.

/* Alteracao via filtro - Impressao grandes volumes - fim    */

    run pi_output_reports /*pi_output_reports*/.

    if  dwb_rpt_param.log_dwb_print_parameters = yes
    then do:
        if (page-number (s_1) > 0) then
            page stream s_1.

        /* ix_p29_rpt_tit_acr_destinac */

        hide stream s_1 frame f_rpt_s_1_header_period.
        view stream s_1 frame f_rpt_s_1_header_unique.
        hide stream s_1 frame f_rpt_s_1_footer_last_page.
        hide stream s_1 frame f_rpt_s_1_footer_normal.
        view stream s_1 frame f_rpt_s_1_footer_param_page.
        if (line-counter(s_1) + 3) > v_rpt_s_1_bottom then
            page stream s_1.
        put stream s_1 unformatted 
            skip (1)
            getStrTrans("Usu†rio: ", "ACR") at 1
            v_cod_usuar_corren at 10 format "x(12)" skip (1).


        /* Begin_Include: ix_p30_rpt_tit_acr_destinac */
            run pi_ix_p30_rpt_tit_acr_destinac.
        /* End_Include: ix_p30_rpt_tit_acr_destinac */


    end /* if */.


/* Alteracao via filtro - Controle de impressao - inicio */
    ASSIGN v_page_number = PAGE-NUMBER(s_1) NO-ERROR.
/* Alteracao via filtro - Controle de impressao - fim    */

    /* Alteracao via filtro - UPC de impressora - inicio */
    EMPTY TEMP-TABLE tt-configur_layout_impres_fim.

    &if '{&product_version}' >= '12.1.L' &then
    run piBeforeClosePrinterUpc.
    &endif

    /* envia para o arquivo/impressora o resultado do retorno da upc de impressora */
    FOR EACH tt-configur_layout_impres_fim EXCLUSIVE-LOCK
        BY tt-configur_layout_impres_fim.num_ord_funcao_imprsor:
        DO  v_num_count = 1 TO EXTENT(tt-configur_layout_impres_fim.num_carac_configur):
            CASE tt-configur_layout_impres_fim.num_carac_configur[v_num_count]:
                WHEN 0 THEN PUT STREAM s_1 CONTROL null.
                WHEN ? THEN LEAVE.
                OTHERWISE
                    PUT STREAM s_1 CONTROL CHR(tt-configur_layout_impres_fim.num_carac_configur[v_num_count]).
            END CASE.
        END.
        DELETE tt-configur_layout_impres_fim.
    END.
    /* Alteracao via filtro - UPC de impressora - fim */

    output stream s_1 close.

    /* Alteracao via filtro - UPC de impressora - inicio */
    &if '{&product_version}' >= '12.1.L' &then
    run piAfterClosePrinterUpc.
    run piClosePrinterUpc.
    &endif
    /* Alteracao via filtro - UPC de impressora - fim */

    /* ix_p31_rpt_tit_acr_destinac */

/* tech38629 - Alteraá∆o efetuada via filtro */
&if '{&emsbas_version}':U >= '5.05':U and not proversion begins '10.1A':U &then
run pi_call_convert_object in v_prog_filtro_pdf (input yes,
                                                 input dwb_rpt_param.cod_dwb_output,
                                                 input dwb_rpt_param.nom_dwb_print_file,
                                                 input v_cod_dwb_file,
                                                 input v_nom_report_title).
&endif
/* tech38629 - Fim da alteraá∆o */


&if '{&emsbas_version}':U >= '5.05':U and not proversion begins '10.1A':U &then
    if ((dwb_rpt_param.cod_dwb_output = 'Impressora':U or dwb_rpt_param.cod_dwb_output = 'Impresora':U or dwb_rpt_param.cod_dwb_output = 'printer':U) and getCodTipoRelat() = 'PDF':U) then do:
        if dwb_rpt_param.nom_dwb_print_file = '' then
            run pi_print_pdf_file in v_prog_filtro_pdf (input yes).
    end.
&endif

/* Alteracao via filtro - Controle de impressao - inicio */
   IF CAN-FIND(FIRST param_extens_ems
               WHERE PARAM_extens_ems.cod_entid_param_ems = "histor_impres":U
                 AND param_extens_ems.cod_chave_param_ems = "histor_impres":U
                 AND param_extens_ems.cod_param_ems       = "log_histor_impres":U
                 AND param_extens_ems.log_param_ems       = YES) AND
      CAN-FIND(FIRST usuar_mestre
               WHERE usuar_mestre.cod_usuario = c-cod_dwb_user
                 AND usuar_mestre.log_solic_impres = YES) AND
     (dwb_rpt_param.cod_dwb_output = "Impressora":U OR
      dwb_rpt_param.cod_dwb_output = "Impresora":U OR
      dwb_rpt_param.cod_dwb_output = "printer":U) THEN DO:
      ASSIGN v_cod_usuar_abert     = TRIM(dwb_rpt_param.cod_livre_1)
             v_page_number_impr    = v_page_number.
      END.
    ELSE                                                     
        if (dwb_rpt_param.cod_dwb_output = "Impressora":U OR 
            dwb_rpt_param.cod_dwb_output = "Impresora":U  OR 
            dwb_rpt_param.cod_dwb_output = "printer":U)      
        THEN DO:                                             
            v_page_number_impr = v_page_number.              
        END.
        ELSE
            ASSIGN v_page_number_impr  = 0.

   RUN prgtec/btb/btb002.p (INPUT c-cod_dwb_user,
                            INPUT v_cod_usuar_abert,
                            INPUT v_page_number,
                            INPUT v_page_number_impr,
                            INPUT v_dat_execution,
                            INPUT dwb_rpt_param.cod_dwb_program,
                            INPUT v_nom_report_title,
                            INPUT dwb_rpt_param.nom_dwb_printer,
                            INPUT dwb_rpt_param.cod_dwb_file).
/* Alteracao via filtro - Controle de impressao - fim    */

    return "OK" /*l_ok*/ .

end /* if */.

pause 0 before-hide.
view frame f_rpt_41_tit_acr_destinac.

/* Begin_Include: i_exec_program_epc */
&if '{&emsbas_version}' > '1.00' &then
if  v_nom_prog_upc <> '' then
do:
    assign v_rec_table_epc = recid(tit_acr).    
    run value(v_nom_prog_upc) (input 'INITIALIZE',
                               input 'viewer',
                               input this-procedure,
                               input v_wgh_frame_epc,
                               input v_nom_table_epc,
                               input v_rec_table_epc).
    if  'no' = 'yes'
    and return-value = 'NOK' then
        undo, retry.
end.

if  v_nom_prog_appc <> '' then
do:
    assign v_rec_table_epc = recid(tit_acr).    
    run value(v_nom_prog_appc) (input 'INITIALIZE',
                                input 'viewer',
                                input this-procedure,
                                input v_wgh_frame_epc,
                                input v_nom_table_epc,
                                input v_rec_table_epc).
    if  'no' = 'yes'
    and return-value = 'NOK' then
        undo, retry.
end.

&if '{&emsbas_version}' > '5.00' &then
if  v_nom_prog_dpc <> '' then
do:
    assign v_rec_table_epc = recid(tit_acr).    
    run value(v_nom_prog_dpc) (input 'INITIALIZE',
                                input 'viewer',
                                input this-procedure,
                                input v_wgh_frame_epc,
                                input v_nom_table_epc,
                                input v_rec_table_epc).
    if  'no' = 'yes'
    and return-value = 'NOK' then
        undo, retry.
end.
&endif
&endif
/* End_Include: i_exec_program_epc */


super_block:
repeat
    on stop undo super_block, retry super_block:

    if (retry) then
       output stream s_1 close.

    param_block:
    do transaction:

        find dwb_rpt_param exclusive-lock
             where dwb_rpt_param.cod_dwb_program = v_cod_dwb_program
               and dwb_rpt_param.cod_dwb_user = v_cod_dwb_user /*cl_dwb_rpt_param of dwb_rpt_param*/ no-error.
        if  not available dwb_rpt_param
        then do:
            create dwb_rpt_param.
            assign dwb_rpt_param.cod_dwb_program         = v_cod_dwb_program
                   dwb_rpt_param.cod_dwb_user            = v_cod_dwb_user
                   dwb_rpt_param.cod_dwb_parameters      = v_cod_dwb_parameters
                   dwb_rpt_param.cod_dwb_output          = "Terminal" /*l_terminal*/ 
                   dwb_rpt_param.ind_dwb_run_mode        = "On-Line" /*l_online*/ 
                   dwb_rpt_param.cod_dwb_file            = ""
                   dwb_rpt_param.nom_dwb_printer         = ""
                   dwb_rpt_param.cod_dwb_print_layout    = ""
                   v_cod_dwb_file_temp                   = "".
        end /* if */.
        assign v_qtd_line = (if dwb_rpt_param.qtd_dwb_line <> 0 then dwb_rpt_param.qtd_dwb_line else v_rpt_s_1_lines).
    end /* do param_block */.

    init:
    do with frame f_rpt_41_tit_acr_destinac:
        assign rs_cod_dwb_output:screen-value   = dwb_rpt_param.cod_dwb_output
               rs_ind_run_mode:screen-value     = dwb_rpt_param.ind_dwb_run_mode.

        if  dwb_rpt_param.cod_dwb_output = "Arquivo" /*l_file*/ 
        then do:
            assign v_cod_dwb_file_temp = replace(dwb_rpt_param.cod_dwb_file, "~\", "~/").
            if (index(v_cod_dwb_file_temp, "~/") <> 0) then
                assign v_cod_dwb_file_temp = substring(v_cod_dwb_file_temp, r-index(v_cod_dwb_file_temp, "~/") + 1).
            else
                assign v_cod_dwb_file_temp = dwb_rpt_param.cod_dwb_file.
            assign ed_1x40:screen-value = v_cod_dwb_file_temp.
        end /* if */.

        if  dwb_rpt_param.cod_dwb_output = "Impressora" /*l_printer*/ 
        then do:
            if (not can-find(imprsor_usuar
                            where imprsor_usuar.nom_impressora = dwb_rpt_param.nom_dwb_printer
                              and imprsor_usuar.cod_usuario = dwb_rpt_param.cod_dwb_user
&if "{&emsbas_version}" >= "5.01" &then
                            use-index imprsrsr_id
&endif
                             /*cl_get_printer of imprsor_usuar*/)
            or   not can-find(layout_impres
                             where layout_impres.nom_impressora = dwb_rpt_param.nom_dwb_printer
                               and layout_impres.cod_layout_impres = dwb_rpt_param.cod_dwb_print_layout /*cl_get_layout of layout_impres*/)) then
                run pi_set_print_layout_default /*pi_set_print_layout_default*/.
            assign ed_1x40:screen-value = dwb_rpt_param.nom_dwb_printer
                                        + ":"
                                        + dwb_rpt_param.cod_dwb_print_layout.
        end /* if */.
        assign v_log_print_par = dwb_rpt_param.log_dwb_print_parameters.
        display v_log_print_par
                with frame f_rpt_41_tit_acr_destinac.
    end /* do init */.

    display v_qtd_column
            v_qtd_line
            with frame f_rpt_41_tit_acr_destinac.


    /* Begin_Include: i_exec_program_epc */
    &if '{&emsbas_version}' > '1.00' &then
    if  v_nom_prog_upc <> '' then
    do:
        assign v_rec_table_epc = recid(tit_acr).    
        run value(v_nom_prog_upc) (input 'DISPLAY',
                                   input 'viewer',
                                   input this-procedure,
                                   input v_wgh_frame_epc,
                                   input v_nom_table_epc,
                                   input v_rec_table_epc).
        if  'no' = 'yes'
        and return-value = 'NOK' then
            undo, retry.
    end.

    if  v_nom_prog_appc <> '' then
    do:
        assign v_rec_table_epc = recid(tit_acr).    
        run value(v_nom_prog_appc) (input 'DISPLAY',
                                    input 'viewer',
                                    input this-procedure,
                                    input v_wgh_frame_epc,
                                    input v_nom_table_epc,
                                    input v_rec_table_epc).
        if  'no' = 'yes'
        and return-value = 'NOK' then
            undo, retry.
    end.

    &if '{&emsbas_version}' > '5.00' &then
    if  v_nom_prog_dpc <> '' then
    do:
        assign v_rec_table_epc = recid(tit_acr).    
        run value(v_nom_prog_dpc) (input 'DISPLAY',
                                    input 'viewer',
                                    input this-procedure,
                                    input v_wgh_frame_epc,
                                    input v_nom_table_epc,
                                    input v_rec_table_epc).
        if  'no' = 'yes'
        and return-value = 'NOK' then
            undo, retry.
    end.
    &endif
    &endif
    /* End_Include: i_exec_program_epc */


    enable rs_cod_dwb_output
           v_log_print_par
           bt_get_file
           bt_set_printer
           bt_close
           bt_print
           bt_can
           bt_hel2
           bt_ran2
           with frame f_rpt_41_tit_acr_destinac.


    /* Begin_Include: i_exec_program_epc */
    &if '{&emsbas_version}' > '1.00' &then
    if  v_nom_prog_upc <> '' then
    do:
        assign v_rec_table_epc = recid(tit_acr).    
        run value(v_nom_prog_upc) (input 'ENABLE',
                                   input 'viewer',
                                   input this-procedure,
                                   input v_wgh_frame_epc,
                                   input v_nom_table_epc,
                                   input v_rec_table_epc).
        if  'no' = 'yes'
        and return-value = 'NOK' then
            undo, retry.
    end.

    if  v_nom_prog_appc <> '' then
    do:
        assign v_rec_table_epc = recid(tit_acr).    
        run value(v_nom_prog_appc) (input 'ENABLE',
                                    input 'viewer',
                                    input this-procedure,
                                    input v_wgh_frame_epc,
                                    input v_nom_table_epc,
                                    input v_rec_table_epc).
        if  'no' = 'yes'
        and return-value = 'NOK' then
            undo, retry.
    end.

    &if '{&emsbas_version}' > '5.00' &then
    if  v_nom_prog_dpc <> '' then
    do:
        assign v_rec_table_epc = recid(tit_acr).    
        run value(v_nom_prog_dpc) (input 'ENABLE',
                                    input 'viewer',
                                    input this-procedure,
                                    input v_wgh_frame_epc,
                                    input v_nom_table_epc,
                                    input v_rec_table_epc).
        if  'no' = 'yes'
        and return-value = 'NOK' then
            undo, retry.
    end.
    &endif
    &endif
    /* End_Include: i_exec_program_epc */


/* tech38629 - Alteraá∆o efetuada via filtro */
&if '{&emsbas_version}':U >= '5.05':U and not proversion begins '10.1A':U &then
    run pi_posiciona_dwb_rpt_param in v_prog_filtro_pdf (input rowid(dwb_rpt_param)).
    run pi_load_params in v_prog_filtro_pdf.
&endif
/* tech38629 - Fim da alteraá∆o */



    apply "value-changed" to rs_cod_dwb_output in frame f_rpt_41_tit_acr_destinac.


    if  yes = yes
    then do:
       enable rs_ind_run_mode
              with frame f_rpt_41_tit_acr_destinac.
       apply "value-changed" to rs_ind_run_mode in frame f_rpt_41_tit_acr_destinac.
    end /* if */.



    /* Begin_Include: ix_p10_rpt_tit_acr_destinac */
    run pi_ix_p10_rpt_tit_acr_destinac /*pi_ix_p10_rpt_tit_acr_destinac*/.

    apply "value-changed" to rs_imforma_cart_bcia in frame f_rpt_41_tit_acr_destinac.
    apply "leave" to         v_cod_destinac_cobr in frame f_rpt_41_tit_acr_destinac.
    apply "value-changed" to v_ind_tip_destinac  in frame f_rpt_41_tit_acr_destinac.

    /* End_Include: ix_p10_rpt_tit_acr_destinac */


    block1:
    repeat on error undo block1, retry block1:

        main_block:
        repeat on error undo super_block, retry super_block
                        on endkey undo super_block, leave super_block
                        on stop undo super_block, retry super_block
                        with frame f_rpt_41_tit_acr_destinac:

            if (retry) then
                output stream s_1 close.
            assign v_log_print = no.
            if  valid-handle(v_wgh_focus) then
                wait-for go of frame f_rpt_41_tit_acr_destinac focus v_wgh_focus.
            else
                wait-for go of frame f_rpt_41_tit_acr_destinac.

            param_block:
            do transaction:

                /* Begin_Include: ix_p15_rpt_tit_acr_destinac */
                run pi_ix_p15_rpt_tit_acr_destinac.
                if return-value = "NOK" /*l_nok*/  then
                    undo main_block, retry main_block.


                /* End_Include: ix_p15_rpt_tit_acr_destinac */

                assign dwb_rpt_param.log_dwb_print_parameters = input frame f_rpt_41_tit_acr_destinac v_log_print_par
                       dwb_rpt_param.ind_dwb_run_mode         = input frame f_rpt_41_tit_acr_destinac rs_ind_run_mode
                       input frame f_rpt_41_tit_acr_destinac v_qtd_line.

                assign dwb_rpt_param.cod_dwb_parameters = v_cod_destinac_cobr                    + chr(10) +
(if v_dat_destinac = ? then "?"
        else string(v_dat_destinac))   + chr(10) +
v_ind_tip_destinac                     + chr(10) +
string( v_log_destinac_manual )        + chr(10) +
string( v_log_habilit_redestina_cobr ) + chr(10) +
string( v_cdn_cliente_fim )            + chr(10) +
string( v_cdn_cliente_ini )            + chr(10) +
v_cod_cart_bcia_fim                    + chr(10) +
v_cod_cart_bcia_inicial                + chr(10) +
v_cod_espec_docto_fim                  + chr(10) +
v_cod_espec_docto_ini                  + chr(10) +
v_cod_parcela_fim                      + chr(10) +
v_cod_parcela_ini                      + chr(10) +
v_cod_portador_fim                     + chr(10) +
v_cod_portador_ini                     + chr(10) +
v_cod_ser_docto_fim                    + chr(10) +
v_cod_ser_docto_ini                    + chr(10) +
v_cod_tit_acr_fim                      + chr(10) +
v_cod_tit_acr_ini                      + chr(10) +
string( v_dat_emis_final )             + chr(10) +
string( v_dat_emis_inic )              + chr(10) +
string( v_dat_vencto_final )           + chr(10) +
string( v_dat_vencto_inicial )         + chr(10) +
v_cod_refer_ini                        + chr(10) +
v_cod_refer_fim                        + chr(10) +
string( v_val_sdo_inic )               + chr(10) +
string( v_val_sdo_fim )                + chr(10) +
v_cod_estab_ini                        + chr(10) +
v_cod_estab_fim                        + chr(10) +
v_ind_obs                              + chr(10) +
rs_imforma_cart_bcia                   + chr(10) +
v_cod_cart_bcia                        + chr(10) +
v_ind_tip_cart_bcia                    + chr(10) +
v_ind_classif_destinac.


                /* Begin_Include: ix_p20_rpt_tit_acr_destinac */
                if string(v_dat_destinac) = "" or string(v_dat_destinac) = ? then
                   assign v_dat_destinac = today.
                if v_log_funcao_tit_nao_dest = yes then
                   assign dwb_rpt_param.cod_dwb_parameters = dwb_rpt_param.cod_dwb_parameters + chr(10) + string(v_log_tit_nao_destndo).
                else
                   assign dwb_rpt_param.cod_dwb_parameters = dwb_rpt_param.cod_dwb_parameters + chr(10) + "no" /*l_no*/ .

                &if defined(BF_FIN_PIX_3_FLEXIBILIZA) &then
                if v_cod_pais_empres_usuar = "BRA" /*l_bra*/  then
                   assign dwb_rpt_param.cod_dwb_parameters = dwb_rpt_param.cod_dwb_parameters + chr(10) + string(v_log_cobr_acr_pix).
                else
                   assign dwb_rpt_param.cod_dwb_parameters = dwb_rpt_param.cod_dwb_parameters + chr(10) + "no" /*l_no*/ .
                &else
                assign dwb_rpt_param.cod_dwb_parameters = dwb_rpt_param.cod_dwb_parameters + chr(10) + "no" /*l_no*/ .
                &endif

                /* End_Include: ix_p20_rpt_tit_acr_destinac */

            end /* do param_block */.

            /* ix_p25_rpt_tit_acr_destinac */

            if  v_log_print = yes
            then do:
/* Alteracao via filtro - Controle de impressao - inicio */
               IF CAN-FIND(FIRST param_extens_ems
                           WHERE PARAM_extens_ems.cod_entid_param_ems = "histor_impres":U
                             AND param_extens_ems.cod_chave_param_ems = "histor_impres":U
                             AND param_extens_ems.cod_param_ems       = "log_histor_impres":U
                             AND param_extens_ems.log_param_ems       = YES) AND
                  CAN-FIND(FIRST usuar_mestre
                           WHERE usuar_mestre.cod_usuario = v_cod_usuar_corren
                             AND usuar_mestre.log_solic_impres = YES) AND
                 (dwb_rpt_param.cod_dwb_output = "Impressora":U OR
                  dwb_rpt_param.cod_dwb_output = "Impresora":U OR
                  dwb_rpt_param.cod_dwb_output = "printer":U) THEN DO:

                  RUN btb/btb004aa.w (OUTPUT v_cod_usuar_abert).
                  RUN pi-grava-usuar-solic.

               END.
/* Alteracao via filtro - Controle de impressao - fim    */

/* Alteracao via filtro - Impressao grandes volumes - inicio */
               ASSIGN v_nom_dwb_print_file = REPLACE(v_nom_dwb_print_file,"~\","~/").

               IF CAN-FIND(FIRST PARAM_extens_ems
                           WHERE PARAM_extens_ems.cod_entid_param_ems = "impressao":U
                             AND PARAM_extens_ems.cod_chave_param_ems = "impress_escala":U
                             AND PARAM_extens_ems.cod_param_ems       = "impress_escala":U
                             AND PARAM_extens_ems.log_param_ems       = YES) THEN DO:
                  IF v_nom_dwb_print_file <> "" THEN DO:
                     IF SUBSTRING(v_nom_dwb_print_file, LENGTH(v_nom_dwb_print_file) - 3, 1) = "." THEN DO:
                        ASSIGN v_nom_dwb_print_file = SUBSTRING(v_nom_dwb_print_file,1,INDEX(v_nom_dwb_print_file,"."))
                           + STRING(TODAY,"99999999")
                           + STRING(TIME,"99999")
                           + SUBSTRING(v_nom_dwb_print_file, LENGTH(v_nom_dwb_print_file) - 3).
                     END.
                     IF INDEX(v_nom_dwb_print_file, "/") = 0 THEN DO:
                        FIND FIRST usuar_mestre NO-LOCK
                           WHERE usuar_mestre.cod_usuario = v_cod_dwb_user NO-ERROR.
                        IF AVAIL usuar_mestre THEN
                           ASSIGN v_nom_dwb_print_file = usuar_mestre.nom_dir_spool + "/" + usuar_mestre.nom_subdir_spool + "/" + v_nom_dwb_print_file
                                  v_nom_dwb_print_file = REPLACE(v_nom_dwb_print_file,"~\","~/").
                     END.
                  END.
               END.
/* Alteracao via filtro - Impressao grandes volumes - fim    */

                if  dwb_rpt_param.ind_dwb_run_mode = "Batch" /*l_batch*/ 
                then do:
                   if  dwb_rpt_param.cod_dwb_output = "Arquivo" /*l_file*/ 
                   then do:
                       assign v_cod_dwb_file = replace(dwb_rpt_param.cod_dwb_file, "~\", "~/")
                              v_nom_integer = v_cod_dwb_file.
                       if  index(v_cod_dwb_file, ":") <> 0
                       then do:
                           /* Nome de arquivo com problemas. */
                           run pi_messages (input "show",
                                            input 1979,
                                            input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_1979*/.
                           next main_block.
                       end /* if */.

                       file_1:
                       do
                          while index(v_cod_dwb_file,"~/") <> 0:
                          assign v_cod_dwb_file = substring(v_cod_dwb_file,(index(v_cod_dwb_file,"~/" ) + 1)).
                       end /* do file_1 */.

                       /* valname: */
                       case num-entries(v_cod_dwb_file,"."):
                           when 1 then
                               if  length(v_cod_dwb_file) > 8
                               then do:
                                  /* Nome de arquivo com problemas. */
                                  run pi_messages (input "show",
                                                   input 1979,
                                                   input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_1979*/.
                                  next main_block.
                               end /* if */.
                           when 2 then
                               if  length(entry(1, v_cod_dwb_file, ".")) > 8
                               or length(entry(2, v_cod_dwb_file, ".")) > 3
                               then do:
                                  /* Nome de arquivo com problemas. */
                                  run pi_messages (input "show",
                                                   input 1979,
                                                   input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_1979*/.
                                  next main_block.
                               end /* if */.
                           otherwise other:
                                     do:
                               /* Nome de arquivo com problemas. */
                               run pi_messages (input "show",
                                                input 1979,
                                                input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_1979*/.
                               next main_block.
                           end /* do other */.
                       end /* case valname */.
                   end /* if */.
/* tech38629 - Alteraá∆o efetuada via filtro */
&if '{&emsbas_version}':U >= '5.05':U and not proversion begins '10.1A':U &then
                    run pi_filename_batch in v_prog_filtro_pdf.
&endif
/* tech38629 - Fim da alteraá∆o */



                   assign v_cod_dwb_file = v_nom_integer.
                   if  search("prgtec/btb/btb911za.r") = ? and search("prgtec/btb/btb911za.p") = ? then do:
                       if  v_cod_dwb_user begins 'es_' then
                           return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgtec/btb/btb911za.p".
                       else do:
                           message getStrTrans("Programa execut†vel n∆o foi encontrado:", "ACR") /*l_programa_nao_encontrado*/  "prgtec/btb/btb911za.p"
                                  view-as alert-box error buttons ok.
                           return.
                       end.
                   end.
                   else
                       run prgtec/btb/btb911za.p (Input v_cod_dwb_program,
                                              Input v_cod_release,
                                              Input 41,
                                              Input recid(dwb_rpt_param),
                                              output v_num_ped_exec) /*prg_fnc_criac_ped_exec*/.
                   if (v_num_ped_exec <> 0) then
                       leave main_block.
                   else
                       next main_block.
                end /* if */.
                else do:
                    assign v_log_method = session:set-wait-state('general')
                           v_nom_report_title = fill(" ", 40 - length(v_rpt_s_1_name)) + v_rpt_s_1_name.
                    /* out_def: */
&if '{&emsbas_version}':U >= '5.05':U and not proversion begins '10.1A':U &then
/*                    case dwb_rpt_param.cod_dwb_output:*/
&else
                    case dwb_rpt_param.cod_dwb_output:

&endif
&if '{&emsbas_version}':U >= '5.05':U and not proversion begins '10.1A':U &then
/*                        when "Terminal" /*l_terminal*/ then out_term:*/
                        if dwb_rpt_param.cod_dwb_output = 'Terminal' then
&else
                        when "Terminal" /*l_terminal*/ then out_term:
&endif

                         do:
                            assign v_cod_dwb_file   = session:temp-directory + substring ("prgfin/acr/acr739ab.py", 12, 6) + '.tmp'
                                   v_rpt_s_1_bottom = v_qtd_line - (v_rpt_s_1_lines - v_qtd_bottom).
                            output stream s_1 to value(v_cod_dwb_file) paged page-size value(v_qtd_line) convert target 'iso8859-1'.
                        end /* do out_term */.

&if '{&emsbas_version}':U >= '5.05':U and not proversion begins '10.1A':U &then
/*                        when "Impressora" /*l_printer*/ then out_print:*/
                        if dwb_rpt_param.cod_dwb_output = 'Impressora' and getCodTipoRelat() <> 'PDF':U and getCodTipoRelat() <> 'RTF':U then
&else
                        when "Impressora" /*l_printer*/ then out_print:
&endif

                         do:
                            find imprsor_usuar no-lock
                                 where imprsor_usuar.nom_impressora = dwb_rpt_param.nom_dwb_printer
                                   and imprsor_usuar.cod_usuario = dwb_rpt_param.cod_dwb_user
&if "{&emsbas_version}" >= "5.01" &then
                                 use-index imprsrsr_id
&endif
                                  /*cl_get_printer of imprsor_usuar*/ no-error.
                            find impressora no-lock
                                 where impressora.nom_impressora = imprsor_usuar.nom_impressora
                                  no-error.
                            find tip_imprsor no-lock
                                 where tip_imprsor.cod_tip_imprsor = impressora.cod_tip_imprsor
                                  no-error.
                            find layout_impres no-lock
                                 where layout_impres.nom_impressora = dwb_rpt_param.nom_dwb_printer
                                   and layout_impres.cod_layout_impres = dwb_rpt_param.cod_dwb_print_layout /*cl_get_layout of layout_impres*/ no-error.
                            /* Alteracao via filtro - UPC de impressora - inicio */
                            &if '{&product_version}' >= '12.1.L' &then
                            run piVerifPrinterUpc (input v_cod_usuar_corren, input imprsor_usuar.nom_impressora).
                            run piBeforeOutputPrinterUpc.
                            &else
                            ASSIGN cArqControlUpc     = imprsor_usuar.nom_disposit_so
                                   iNumLinPagUpc      = (IF AVAILABLE layout_impres THEN layout_impres.num_lin_pag ELSE 0)
                                   cPagCaracConverUpc = tip_imprsor.cod_pag_carac_conver.
                            &endif

                            assign v_rpt_s_1_bottom = iNumLinPagUpc - (v_rpt_s_1_lines - v_qtd_bottom).
                            /* Alteracao via filtro - UPC de impressora - fim */

&if '{&emsbas_version}' > '1.00' &then
                            if  v_nom_dwb_print_file <> "" then
                                if  iNumLinPagUpc = 0 then
                                    output stream s_1 to value(lc(v_nom_dwb_print_file))
                                           page-size 0 convert target cPagCaracConverUpc.
                                else
                                    output stream s_1 to value(lc(v_nom_dwb_print_file))
                                           paged page-size value(iNumLinPagUpc) convert target  cPagCaracConverUpc.
                            else
&endif
                                if  iNumLinPagUpc = 0 then
                                    output stream s_1 to value(cArqControlUpc)
                                           page-size 0 convert target cPagCaracConverUpc.
                                else
                                    output stream s_1 to value(cArqControlUpc)
                                           paged page-size value(iNumLinPagUpc) convert target  cPagCaracConverUpc.

                            /* Alteracao via filtro - UPC de impressora - inicio */
                            EMPTY TEMP-TABLE tt-configur_layout_impres_inicio.
                            FOR EACH configur_layout_impres NO-LOCK
                                WHERE configur_layout_impres.num_id_layout_impres = layout_impres.num_id_layout_impres
                                BY    configur_layout_impres.num_ord_funcao_imprsor:
                                FIND configur_tip_imprsor USE-INDEX cnfgrtpm_id
                                    WHERE configur_tip_imprsor.cod_tip_imprsor        = layout_impres.cod_tip_imprsor
                                    AND   configur_tip_imprsor.cod_funcao_imprsor     = configur_layout_impres.cod_funcao_imprsor
                                    AND   configur_tip_imprsor.cod_opc_funcao_imprsor = configur_layout_impres.cod_opc_funcao_imprsor
                                    NO-LOCK NO-ERROR.
                                CREATE tt-configur_layout_impres_inicio.
                                BUFFER-COPY configur_tip_imprsor TO tt-configur_layout_impres_inicio
                                    ASSIGN tt-configur_layout_impres_inicio.num_ord_funcao_imprsor = configur_layout_impres.num_ord_funcao_imprsor.
                            END.

                            &if '{&product_version}' >= '12.1.L' &then
                            run piAfterOutputPrinterUpc.
                            &endif

                            setting:
                            FOR EACH tt-configur_layout_impres_inicio EXCLUSIVE-LOCK
                                BY tt-configur_layout_impres_inicio.num_ord_funcao_imprsor:
                                DO  v_num_count = 1 TO EXTENT(tt-configur_layout_impres_inicio.num_carac_configur):
                                    CASE tt-configur_layout_impres_inicio.num_carac_configur[v_num_count]:
                                        WHEN 0 THEN PUT STREAM s_1 CONTROL null.
                                        WHEN ? THEN LEAVE.
                                        OTHERWISE
                                            PUT STREAM s_1 CONTROL CHR(tt-configur_layout_impres_inicio.num_carac_configur[v_num_count]).
                                    END CASE.
                                END.
                            END.
                            /* Alteracao via filtro - UPC de impressora - fim */
                        end /* do out_print */.
&if '{&emsbas_version}':U >= '5.05':U and not proversion begins '10.1A':U &then
/*                        when "Arquivo" /*l_file*/ then out_file:*/
                        if dwb_rpt_param.cod_dwb_output = 'Impressora' and getCodTipoRelat() = 'PDF':U then do:
                            run pi_config_output_print_pdf in v_prog_filtro_pdf (input v_qtd_line, input-output v_cod_dwb_file, input dwb_rpt_param.cod_dwb_user, input no).
                        end.
                        if dwb_rpt_param.cod_dwb_output = 'Arquivo' then
&else
                        when "Arquivo" /*l_file*/ then out_file:
&endif
                         do:
                            assign v_cod_dwb_file   = dwb_rpt_param.cod_dwb_file
                                   v_rpt_s_1_bottom = v_qtd_line - (v_rpt_s_1_lines - v_qtd_bottom).

/* tech38629 - Alteraá∆o efetuada via filtro */
&if '{&emsbas_version}':U >= '5.05':U and not proversion begins '10.1A':U &then
run pi_rename_file in v_prog_filtro_pdf (input-output v_cod_dwb_file).
&endif
/* tech38629 - Fim da alteraá∆o */



                            output stream s_1 to value(v_cod_dwb_file)
                                   paged page-size value(v_qtd_line) convert target 'iso8859-1'.
                        end /* do out_file */.
&if '{&emsbas_version}':U >= '5.05':U and not proversion begins '10.1A':U &then
/*                    end /* case out_def */.*/
&else
                    end /* case out_def */.
&endif
                    assign v_nom_prog_ext  = caps(substring("prgfin/acr/acr739ab.py",12,8))
                           v_cod_release   = trim(" 1.00.02.097":U)
                           v_dat_execution = today
                           v_hra_execution = replace(string(time,"hh:mm:ss" /*l_hh:mm:ss*/ ),":","").
                    run pi_rpt_tit_acr_destinac /*pi_rpt_tit_acr_destinac*/.
                end /* else */.
                if  dwb_rpt_param.log_dwb_print_parameters = yes
                then do:
                    if (page-number (s_1) > 0) then
                        page stream s_1.
                    /* ix_p29_rpt_tit_acr_destinac */    
                    hide stream s_1 frame f_rpt_s_1_header_period.
                    view stream s_1 frame f_rpt_s_1_header_unique.
                    hide stream s_1 frame f_rpt_s_1_footer_last_page.
                    hide stream s_1 frame f_rpt_s_1_footer_normal.
                    view stream s_1 frame f_rpt_s_1_footer_param_page.
                    if (line-counter(s_1) + 3) > v_rpt_s_1_bottom then
                        page stream s_1.
                    put stream s_1 unformatted 
                        skip (1)
                        getStrTrans("Usu†rio: ", "ACR") at 1
                        v_cod_usuar_corren at 10 format "x(12)" skip (1).

                    /* Begin_Include: ix_p30_rpt_tit_acr_destinac */
                    if v_log_funcao_tit_nao_dest = yes then do:
                       if v_cod_return = "OK" /*l_ok*/  then do:
                       &if defined(BF_FIN_PIX_3_FLEXIBILIZA) &then
                          if  v_cod_pais_empres_usuar = "BRA" /*l_bra*/ 
                          then do:
                          run pi_print_editor ("s_1", v_ind_obs, "     035", "", "     ", "", "     ").
                          assign v_des_return_value_editor = return-value.
                          put stream s_1 unformatted 
                              getStrTrans("Destinaá∆o: ", "ACR") at 23
                              destinac_cobr.cod_destinac_cobr at 35 format "x(8)"
                              destinac_cobr.des_destinac_cobr at 53 format "x(40)" skip
                              getStrTrans("Data Destinaá∆o: ", "ACR") at 27
                              v_dat_destinac at 44 format "99/99/9999" skip
                              getStrTrans("Tipo Relat¢rio: ", "ACR") at 28
                              getStrTrans(v_ind_tip_destinac, "ACR") at 44 format "X(12)" skip
                              getStrTrans("Redestinaá∆o: ", "ACR") at 30.
                    put stream s_1 unformatted 
                              getStrTrans(string(v_log_habilit_redestina_cobr, "Sim/N∆o"), "ACR") at 44 skip
                              getStrTrans("Manual: ", "ACR") at 36
                              getStrTrans(string(v_log_destinac_manual, "Sim/N∆o"), "ACR") at 44 skip
                              getStrTrans("Listar Tit N∆o Dest: ", "ACR") at 23
                              getStrTrans(string(v_log_tit_nao_destndo, "Sim/N∆o"), "ACR") at 44 skip
                              getStrTrans("Aceita Cobranáa PIX: ", "ACR") at 23
                              getStrTrans(string(v_log_cobr_acr_pix, "Sim/N∆o"), "ACR") at 44 skip
                              getStrTrans("Observaá∆o: ", "ACR") at 32
                              entry(1, v_des_return_value_editor, chr(255)) at 44 format "x(35)"
                              skip (1).
                    put stream s_1 unformatted 
                              getStrTrans("--------------- Faixa Destinaá∆o ---------------", "ACR") at 34
                              skip (1)
                              getStrTrans("Estabelecimento: ", "ACR") at 35
                              v_cod_estab_ini at 52 format "x(5)"
                              getStrTrans("atÇ: ", "ACR") at 69
                              v_cod_estab_fim at 74 format "x(5)" skip
                              getStrTrans("Data Emiss∆o: ", "ACR") at 38
                              v_dat_emis_inic at 52 format "99/99/9999"
                              getStrTrans("atÇ: ", "ACR") at 69
                              v_dat_emis_final at 74 format "99/99/9999" skip.
                    put stream s_1 unformatted 
                              getStrTrans("Data Vencimento: ", "ACR") at 35
                              v_dat_vencto_inicial at 52 format "99/99/9999"
                              getStrTrans("atÇ: ", "ACR") at 69
                              v_dat_vencto_final at 74 format "99/99/9999" skip
                              getStrTrans("Referància: ", "ACR") at 40
                              v_cod_refer_ini at 52 format "x(10)"
                              getStrTrans("atÇ: ", "ACR") at 69
                              v_cod_refer_fim at 74 format "x(10)" skip
                              getStrTrans("Portador: ", "ACR") at 42
                              v_cod_portador_ini at 52 format "x(5)".
                    put stream s_1 unformatted 
                              getStrTrans("atÇ: ", "ACR") at 69
                              v_cod_portador_fim at 74 format "x(5)" skip
                              getStrTrans("Cliente: ", "ACR") at 43
                              v_cdn_cliente_ini to 62 format ">>>,>>>,>>9"
                              getStrTrans("atÇ: ", "ACR") at 69
                              v_cdn_cliente_fim to 84 format ">>>,>>>,>>9" skip
                              getStrTrans("Carteira Bcia: ", "ACR") at 37
                              v_cod_cart_bcia_inicial at 52 format "x(3)"
                              getStrTrans("atÇ: ", "ACR") at 69
                              v_cod_cart_bcia_fim at 74 format "x(3)" skip.
                    put stream s_1 unformatted 
                              getStrTrans("EspÇcie: ", "ACR") at 43
                              v_cod_espec_docto_ini at 52 format "x(3)"
                              getStrTrans("atÇ: ", "ACR") at 69
                              v_cod_espec_docto_fim at 74 format "x(3)" skip
                              getStrTrans("SÇrie: ", "ACR") at 45
                              v_cod_ser_docto_ini at 52 format "x(5)"
                              getStrTrans("atÇ: ", "ACR") at 69
                              v_cod_ser_docto_fim at 74 format "x(5)" skip
                              getStrTrans("T°tulo: ", "ACR") at 44
                              v_cod_tit_acr_ini at 52 format "x(16)".
                    put stream s_1 unformatted 
                              getStrTrans("atÇ: ", "ACR") at 69
                              v_cod_tit_acr_fim at 74 format "x(16)" skip
                              getStrTrans("Parcela: ", "ACR") at 43
                              v_cod_parcela_ini at 52 format "x(02)"
                              getStrTrans("atÇ: ", "ACR") at 69
                              v_cod_parcela_fim at 74 format "x(02)" skip.
                          run pi_print_editor ("s_1", v_ind_obs, "at044035", "", "", "", "").
                          assign v_des_return_value_editor = return-value.
                          end /* if */.
                          else do:
                          run pi_print_editor ("s_1", v_ind_obs, "     035", "", "     ", "", "     ").
                          assign v_des_return_value_editor = return-value.
                          put stream s_1 unformatted 
                              getStrTrans("Destinaá∆o: ", "ACR") at 23
                              destinac_cobr.cod_destinac_cobr at 35 format "x(8)"
                              destinac_cobr.des_destinac_cobr at 53 format "x(40)" skip
                              getStrTrans("Data Destinaá∆o: ", "ACR") at 27
                              v_dat_destinac at 44 format "99/99/9999" skip
                              getStrTrans("Tipo Relat¢rio: ", "ACR") at 28
                              getStrTrans(v_ind_tip_destinac, "ACR") at 44 format "X(12)" skip
                              getStrTrans("Redestinaá∆o: ", "ACR") at 30.
                    put stream s_1 unformatted 
                              getStrTrans(string(v_log_habilit_redestina_cobr, "Sim/N∆o"), "ACR") at 44 skip
                              getStrTrans("Manual: ", "ACR") at 36
                              getStrTrans(string(v_log_destinac_manual, "Sim/N∆o"), "ACR") at 44 skip
                              getStrTrans("Listar Tit N∆o Dest: ", "ACR") at 23
                              getStrTrans(string(v_log_tit_nao_destndo, "Sim/N∆o"), "ACR") at 44 skip
                              getStrTrans("Observaá∆o: ", "ACR") at 32
                              entry(1, v_des_return_value_editor, chr(255)) at 44 format "x(35)" skip
                              getStrTrans("Classificaá∆o: ", "ACR") at 29
                              getStrTrans(v_ind_classif_destinac, "ACR") at 44 format "X(100)"
                              skip (1).
                    put stream s_1 unformatted 
                              getStrTrans("--------------- Faixa Destinaá∆o ---------------", "ACR") at 34 skip
                              getStrTrans("Estabelecimento: ", "ACR") at 35
                              v_cod_estab_ini at 52 format "x(5)"
                              getStrTrans("atÇ: ", "ACR") at 69
                              v_cod_estab_fim at 74 format "x(5)" skip
                              getStrTrans("Data Emiss∆o: ", "ACR") at 38
                              v_dat_emis_inic at 52 format "99/99/9999"
                              getStrTrans("atÇ: ", "ACR") at 69
                              v_dat_emis_final at 74 format "99/99/9999" skip
                              getStrTrans("Data Vencimento: ", "ACR") at 35.
                    put stream s_1 unformatted 
                              v_dat_vencto_inicial at 52 format "99/99/9999"
                              getStrTrans("atÇ: ", "ACR") at 69
                              v_dat_vencto_final at 74 format "99/99/9999" skip
                              getStrTrans("Referància: ", "ACR") at 40
                              v_cod_refer_ini at 52 format "x(10)"
                              getStrTrans("atÇ: ", "ACR") at 69
                              v_cod_refer_fim at 74 format "x(10)" skip
                              getStrTrans("Portador: ", "ACR") at 42
                              v_cod_portador_ini at 52 format "x(5)"
                              getStrTrans("atÇ: ", "ACR") at 69.
                    put stream s_1 unformatted 
                              v_cod_portador_fim at 74 format "x(5)" skip
                              getStrTrans("Cliente: ", "ACR") at 43
                              v_cdn_cliente_ini to 62 format ">>>,>>>,>>9"
                              getStrTrans("atÇ: ", "ACR") at 69
                              v_cdn_cliente_fim to 84 format ">>>,>>>,>>9" skip
                              getStrTrans("Carteira Bcia: ", "ACR") at 37
                              v_cod_cart_bcia_inicial at 52 format "x(3)"
                              getStrTrans("atÇ: ", "ACR") at 69
                              v_cod_cart_bcia_fim at 74 format "x(3)" skip
                              getStrTrans("EspÇcie: ", "ACR") at 43.
                    put stream s_1 unformatted 
                              v_cod_espec_docto_ini at 52 format "x(3)"
                              getStrTrans("atÇ: ", "ACR") at 69
                              v_cod_espec_docto_fim at 74 format "x(3)" skip
                              getStrTrans("SÇrie: ", "ACR") at 45
                              v_cod_ser_docto_ini at 52 format "x(5)"
                              getStrTrans("atÇ: ", "ACR") at 69
                              v_cod_ser_docto_fim at 74 format "x(5)" skip
                              getStrTrans("T°tulo: ", "ACR") at 44
                              v_cod_tit_acr_ini at 52 format "x(16)"
                              getStrTrans("atÇ: ", "ACR") at 69.
                    put stream s_1 unformatted 
                              v_cod_tit_acr_fim at 74 format "x(16)" skip
                              getStrTrans("Parcela: ", "ACR") at 43
                              v_cod_parcela_ini at 52 format "x(02)"
                              getStrTrans("atÇ: ", "ACR") at 69
                              v_cod_parcela_fim at 74 format "x(02)" skip.
                          run pi_print_editor ("s_1", v_ind_obs, "at044035", "", "", "", "").      
                          assign v_des_return_value_editor = return-value.
                          end /* else */.
                       &else
                          run pi_print_editor ("s_1", v_ind_obs, "     035", "", "     ", "", "     ").
                          assign v_des_return_value_editor = return-value.
                          put stream s_1 unformatted 
                              getStrTrans("Destinaá∆o: ", "ACR") at 23
                              destinac_cobr.cod_destinac_cobr at 35 format "x(8)"
                              destinac_cobr.des_destinac_cobr at 53 format "x(40)" skip
                              getStrTrans("Data Destinaá∆o: ", "ACR") at 27
                              v_dat_destinac at 44 format "99/99/9999" skip
                              getStrTrans("Tipo Relat¢rio: ", "ACR") at 28
                              getStrTrans(v_ind_tip_destinac, "ACR") at 44 format "X(12)" skip
                              getStrTrans("Redestinaá∆o: ", "ACR") at 30.
                    put stream s_1 unformatted 
                              getStrTrans(string(v_log_habilit_redestina_cobr, "Sim/N∆o"), "ACR") at 44 skip
                              getStrTrans("Manual: ", "ACR") at 36
                              getStrTrans(string(v_log_destinac_manual, "Sim/N∆o"), "ACR") at 44 skip
                              getStrTrans("Listar Tit N∆o Dest: ", "ACR") at 23
                              getStrTrans(string(v_log_tit_nao_destndo, "Sim/N∆o"), "ACR") at 44 skip
                              getStrTrans("Observaá∆o: ", "ACR") at 32
                              entry(1, v_des_return_value_editor, chr(255)) at 44 format "x(35)"
                              skip (1)
                              getStrTrans("--------------- Faixa Destinaá∆o ---------------", "ACR") at 34
                              skip (1).
                    put stream s_1 unformatted 
                              getStrTrans("Estabelecimento: ", "ACR") at 35
                              v_cod_estab_ini at 52 format "x(5)"
                              getStrTrans("atÇ: ", "ACR") at 69
                              v_cod_estab_fim at 74 format "x(5)" skip
                              getStrTrans("Data Emiss∆o: ", "ACR") at 38
                              v_dat_emis_inic at 52 format "99/99/9999"
                              getStrTrans("atÇ: ", "ACR") at 69
                              v_dat_emis_final at 74 format "99/99/9999" skip
                              getStrTrans("Data Vencimento: ", "ACR") at 35
                              v_dat_vencto_inicial at 52 format "99/99/9999".
                    put stream s_1 unformatted 
                              getStrTrans("atÇ: ", "ACR") at 69
                              v_dat_vencto_final at 74 format "99/99/9999" skip
                              getStrTrans("Referància: ", "ACR") at 40
                              v_cod_refer_ini at 52 format "x(10)"
                              getStrTrans("atÇ: ", "ACR") at 69
                              v_cod_refer_fim at 74 format "x(10)" skip
                              getStrTrans("Portador: ", "ACR") at 42
                              v_cod_portador_ini at 52 format "x(5)"
                              getStrTrans("atÇ: ", "ACR") at 69
                              v_cod_portador_fim at 74 format "x(5)" skip.
                    put stream s_1 unformatted 
                              getStrTrans("Cliente: ", "ACR") at 43
                              v_cdn_cliente_ini to 62 format ">>>,>>>,>>9"
                              getStrTrans("atÇ: ", "ACR") at 69
                              v_cdn_cliente_fim to 84 format ">>>,>>>,>>9" skip
                              getStrTrans("Carteira Bcia: ", "ACR") at 37
                              v_cod_cart_bcia_inicial at 52 format "x(3)"
                              getStrTrans("atÇ: ", "ACR") at 69
                              v_cod_cart_bcia_fim at 74 format "x(3)" skip
                              getStrTrans("EspÇcie: ", "ACR") at 43
                              v_cod_espec_docto_ini at 52 format "x(3)".
                    put stream s_1 unformatted 
                              getStrTrans("atÇ: ", "ACR") at 69
                              v_cod_espec_docto_fim at 74 format "x(3)" skip
                              getStrTrans("SÇrie: ", "ACR") at 45
                              v_cod_ser_docto_ini at 52 format "x(5)"
                              getStrTrans("atÇ: ", "ACR") at 69
                              v_cod_ser_docto_fim at 74 format "x(5)" skip
                              getStrTrans("T°tulo: ", "ACR") at 44
                              v_cod_tit_acr_ini at 52 format "x(16)"
                              getStrTrans("atÇ: ", "ACR") at 69
                              v_cod_tit_acr_fim at 74 format "x(16)" skip.
                    put stream s_1 unformatted 
                              getStrTrans("Parcela: ", "ACR") at 43
                              v_cod_parcela_ini at 52 format "x(02)"
                              getStrTrans("atÇ: ", "ACR") at 69
                              v_cod_parcela_fim at 74 format "x(02)" skip.
                          run pi_print_editor ("s_1", v_ind_obs, "at044035", "", "", "", "").
                          assign v_des_return_value_editor = return-value.
                       &endif
                       end.
                    end.
                    else do:
                       if v_cod_return = "OK" /*l_ok*/  then do:
                       &if defined(BF_FIN_PIX_3_FLEXIBILIZA) &then
                          if  v_cod_pais_empres_usuar = "BRA" /*l_bra*/ 
                          then do:
                          run pi_print_editor ("s_1", v_ind_obs, "     035", "", "     ", "", "     ").
                          assign v_des_return_value_editor = return-value.
                          put stream s_1 unformatted 
                              getStrTrans("Destinaá∆o: ", "ACR") at 23
                              destinac_cobr.cod_destinac_cobr at 35 format "x(8)"
                              destinac_cobr.des_destinac_cobr at 53 format "x(40)" skip
                              getStrTrans("Data Destinaá∆o: ", "ACR") at 27
                              v_dat_destinac at 44 format "99/99/9999" skip
                              getStrTrans("Tipo Relat¢rio: ", "ACR") at 28
                              getStrTrans(v_ind_tip_destinac, "ACR") at 44 format "X(12)" skip
                              getStrTrans("Redestinaá∆o: ", "ACR") at 30.
                    put stream s_1 unformatted 
                              getStrTrans(string(v_log_habilit_redestina_cobr, "Sim/N∆o"), "ACR") at 44 skip
                              getStrTrans("Manual: ", "ACR") at 36
                              getStrTrans(string(v_log_destinac_manual, "Sim/N∆o"), "ACR") at 44 skip
                              getStrTrans("Aceita Cobranáa PIX: ", "ACR") at 23
                              getStrTrans(string(v_log_cobr_acr_pix, "Sim/N∆o"), "ACR") at 44 skip
                              getStrTrans("Observaá∆o: ", "ACR") at 32
                              entry(1, v_des_return_value_editor, chr(255)) at 44 format "x(35)"
                              skip (1)
                              getStrTrans("--------------- Faixa Destinaá∆o ---------------", "ACR") at 34
                              skip (1).
                    put stream s_1 unformatted 
                              getStrTrans("Estabelecimento: ", "ACR") at 35
                              v_cod_estab_ini at 52 format "x(5)"
                              getStrTrans("atÇ: ", "ACR") at 69
                              v_cod_estab_fim at 74 format "x(5)" skip
                              getStrTrans("Data Emiss∆o: ", "ACR") at 38
                              v_dat_emis_inic at 52 format "99/99/9999"
                              getStrTrans("atÇ: ", "ACR") at 69
                              v_dat_emis_final at 74 format "99/99/9999" skip
                              getStrTrans("Data Vencimento: ", "ACR") at 35
                              v_dat_vencto_inicial at 52 format "99/99/9999".
                    put stream s_1 unformatted 
                              getStrTrans("atÇ: ", "ACR") at 69
                              v_dat_vencto_final at 74 format "99/99/9999" skip
                              getStrTrans("Referància: ", "ACR") at 40
                              v_cod_refer_ini at 52 format "x(10)"
                              getStrTrans("atÇ: ", "ACR") at 69
                              v_cod_refer_fim at 74 format "x(10)" skip
                              getStrTrans("Portador: ", "ACR") at 42
                              v_cod_portador_ini at 52 format "x(5)"
                              getStrTrans("atÇ: ", "ACR") at 69
                              v_cod_portador_fim at 74 format "x(5)" skip.
                    put stream s_1 unformatted 
                              getStrTrans("Cliente: ", "ACR") at 43
                              v_cdn_cliente_ini to 62 format ">>>,>>>,>>9"
                              getStrTrans("atÇ: ", "ACR") at 69
                              v_cdn_cliente_fim to 84 format ">>>,>>>,>>9" skip
                              getStrTrans("Carteira Bcia: ", "ACR") at 37
                              v_cod_cart_bcia_inicial at 52 format "x(3)"
                              getStrTrans("atÇ: ", "ACR") at 69
                              v_cod_cart_bcia_fim at 74 format "x(3)" skip
                              getStrTrans("EspÇcie: ", "ACR") at 43
                              v_cod_espec_docto_ini at 52 format "x(3)".
                    put stream s_1 unformatted 
                              getStrTrans("atÇ: ", "ACR") at 69
                              v_cod_espec_docto_fim at 74 format "x(3)" skip
                              getStrTrans("SÇrie: ", "ACR") at 45
                              v_cod_ser_docto_ini at 52 format "x(5)"
                              getStrTrans("atÇ: ", "ACR") at 69
                              v_cod_ser_docto_fim at 74 format "x(5)" skip
                              getStrTrans("T°tulo: ", "ACR") at 44
                              v_cod_tit_acr_ini at 52 format "x(16)"
                              getStrTrans("atÇ: ", "ACR") at 69
                              v_cod_tit_acr_fim at 74 format "x(16)" skip.
                    put stream s_1 unformatted 
                              getStrTrans("Parcela: ", "ACR") at 43
                              v_cod_parcela_ini at 52 format "x(02)"
                              getStrTrans("atÇ: ", "ACR") at 69
                              v_cod_parcela_fim at 74 format "x(02)" skip.
                          run pi_print_editor ("s_1", v_ind_obs, "at044035", "", "", "", "").
                          assign v_des_return_value_editor = return-value.
                          end /* if */.
                          else do:
                          run pi_print_editor ("s_1", v_ind_obs, "     035", "", "     ", "", "     ").
                          assign v_des_return_value_editor = return-value.
                          put stream s_1 unformatted 
                              getStrTrans("Destinaá∆o: ", "ACR") at 23
                              destinac_cobr.cod_destinac_cobr at 35 format "x(8)"
                              destinac_cobr.des_destinac_cobr at 53 format "x(40)" skip
                              getStrTrans("Data Destinaá∆o: ", "ACR") at 27
                              v_dat_destinac at 44 format "99/99/9999" skip
                              getStrTrans("Tipo Relat¢rio: ", "ACR") at 28
                              getStrTrans(v_ind_tip_destinac, "ACR") at 44 format "X(12)" skip
                              getStrTrans("Redestinaá∆o: ", "ACR") at 30.
                    put stream s_1 unformatted 
                              getStrTrans(string(v_log_habilit_redestina_cobr, "Sim/N∆o"), "ACR") at 44 skip
                              getStrTrans("Manual: ", "ACR") at 36
                              getStrTrans(string(v_log_destinac_manual, "Sim/N∆o"), "ACR") at 44 skip
                              getStrTrans("Observaá∆o: ", "ACR") at 32
                              entry(1, v_des_return_value_editor, chr(255)) at 44 format "x(35)" skip
                              getStrTrans("Classificaá∆o: ", "ACR") at 29
                              getStrTrans(v_ind_classif_destinac, "ACR") at 44 format "X(100)"
                              skip (1)
                              getStrTrans("--------------- Faixa Destinaá∆o ---------------", "ACR") at 34 skip
                              getStrTrans("Estabelecimento: ", "ACR") at 35.
                    put stream s_1 unformatted 
                              v_cod_estab_ini at 52 format "x(5)"
                              getStrTrans("atÇ: ", "ACR") at 69
                              v_cod_estab_fim at 74 format "x(5)" skip
                              getStrTrans("Data Emiss∆o: ", "ACR") at 38
                              v_dat_emis_inic at 52 format "99/99/9999"
                              getStrTrans("atÇ: ", "ACR") at 69
                              v_dat_emis_final at 74 format "99/99/9999" skip
                              getStrTrans("Data Vencimento: ", "ACR") at 35
                              v_dat_vencto_inicial at 52 format "99/99/9999"
                              getStrTrans("atÇ: ", "ACR") at 69.
                    put stream s_1 unformatted 
                              v_dat_vencto_final at 74 format "99/99/9999" skip
                              getStrTrans("Referància: ", "ACR") at 40
                              v_cod_refer_ini at 52 format "x(10)"
                              getStrTrans("atÇ: ", "ACR") at 69
                              v_cod_refer_fim at 74 format "x(10)" skip
                              getStrTrans("Portador: ", "ACR") at 42
                              v_cod_portador_ini at 52 format "x(5)"
                              getStrTrans("atÇ: ", "ACR") at 69
                              v_cod_portador_fim at 74 format "x(5)" skip
                              getStrTrans("Cliente: ", "ACR") at 43.
                    put stream s_1 unformatted 
                              v_cdn_cliente_ini to 62 format ">>>,>>>,>>9"
                              getStrTrans("atÇ: ", "ACR") at 69
                              v_cdn_cliente_fim to 84 format ">>>,>>>,>>9" skip
                              getStrTrans("Carteira Bcia: ", "ACR") at 37
                              v_cod_cart_bcia_inicial at 52 format "x(3)"
                              getStrTrans("atÇ: ", "ACR") at 69
                              v_cod_cart_bcia_fim at 74 format "x(3)" skip
                              getStrTrans("EspÇcie: ", "ACR") at 43
                              v_cod_espec_docto_ini at 52 format "x(3)"
                              getStrTrans("atÇ: ", "ACR") at 69.
                    put stream s_1 unformatted 
                              v_cod_espec_docto_fim at 74 format "x(3)" skip
                              getStrTrans("SÇrie: ", "ACR") at 45
                              v_cod_ser_docto_ini at 52 format "x(5)"
                              getStrTrans("atÇ: ", "ACR") at 69
                              v_cod_ser_docto_fim at 74 format "x(5)" skip
                              getStrTrans("T°tulo: ", "ACR") at 44
                              v_cod_tit_acr_ini at 52 format "x(16)"
                              getStrTrans("atÇ: ", "ACR") at 69
                              v_cod_tit_acr_fim at 74 format "x(16)" skip
                              getStrTrans("Parcela: ", "ACR") at 43.
                    put stream s_1 unformatted 
                              v_cod_parcela_ini at 52 format "x(02)"
                              getStrTrans("atÇ: ", "ACR") at 69
                              v_cod_parcela_fim at 74 format "x(02)" skip.
                          run pi_print_editor ("s_1", v_ind_obs, "at044035", "", "", "", "").      
                          assign v_des_return_value_editor = return-value.
                          end /* else */.
                       &else
                          run pi_print_editor ("s_1", v_ind_obs, "     035", "", "     ", "", "     ").
                          assign v_des_return_value_editor = return-value.
                          put stream s_1 unformatted 
                              getStrTrans("Destinaá∆o: ", "ACR") at 23
                              destinac_cobr.cod_destinac_cobr at 35 format "x(8)"
                              destinac_cobr.des_destinac_cobr at 53 format "x(40)" skip
                              getStrTrans("Data Destinaá∆o: ", "ACR") at 27
                              v_dat_destinac at 44 format "99/99/9999" skip
                              getStrTrans("Tipo Relat¢rio: ", "ACR") at 28
                              getStrTrans(v_ind_tip_destinac, "ACR") at 44 format "X(12)" skip
                              getStrTrans("Redestinaá∆o: ", "ACR") at 30.
                    put stream s_1 unformatted 
                              getStrTrans(string(v_log_habilit_redestina_cobr, "Sim/N∆o"), "ACR") at 44 skip
                              getStrTrans("Manual: ", "ACR") at 36
                              getStrTrans(string(v_log_destinac_manual, "Sim/N∆o"), "ACR") at 44 skip
                              getStrTrans("Observaá∆o: ", "ACR") at 32
                              entry(1, v_des_return_value_editor, chr(255)) at 44 format "x(35)"
                              skip (1)
                              getStrTrans("--------------- Faixa Destinaá∆o ---------------", "ACR") at 34
                              skip (1)
                              getStrTrans("Estabelecimento: ", "ACR") at 35
                              v_cod_estab_ini at 52 format "x(5)".
                    put stream s_1 unformatted 
                              getStrTrans("atÇ: ", "ACR") at 69
                              v_cod_estab_fim at 74 format "x(5)" skip
                              getStrTrans("Data Emiss∆o: ", "ACR") at 38
                              v_dat_emis_inic at 52 format "99/99/9999"
                              getStrTrans("atÇ: ", "ACR") at 69
                              v_dat_emis_final at 74 format "99/99/9999" skip
                              getStrTrans("Data Vencimento: ", "ACR") at 35
                              v_dat_vencto_inicial at 52 format "99/99/9999"
                              getStrTrans("atÇ: ", "ACR") at 69
                              v_dat_vencto_final at 74 format "99/99/9999" skip.
                    put stream s_1 unformatted 
                              getStrTrans("Referància: ", "ACR") at 40
                              v_cod_refer_ini at 52 format "x(10)"
                              getStrTrans("atÇ: ", "ACR") at 69
                              v_cod_refer_fim at 74 format "x(10)" skip
                              getStrTrans("Portador: ", "ACR") at 42
                              v_cod_portador_ini at 52 format "x(5)"
                              getStrTrans("atÇ: ", "ACR") at 69
                              v_cod_portador_fim at 74 format "x(5)" skip
                              getStrTrans("Cliente: ", "ACR") at 43
                              v_cdn_cliente_ini to 62 format ">>>,>>>,>>9".
                    put stream s_1 unformatted 
                              getStrTrans("atÇ: ", "ACR") at 69
                              v_cdn_cliente_fim to 84 format ">>>,>>>,>>9" skip
                              getStrTrans("Carteira Bcia: ", "ACR") at 37
                              v_cod_cart_bcia_inicial at 52 format "x(3)"
                              getStrTrans("atÇ: ", "ACR") at 69
                              v_cod_cart_bcia_fim at 74 format "x(3)" skip
                              getStrTrans("EspÇcie: ", "ACR") at 43
                              v_cod_espec_docto_ini at 52 format "x(3)"
                              getStrTrans("atÇ: ", "ACR") at 69
                              v_cod_espec_docto_fim at 74 format "x(3)" skip.
                    put stream s_1 unformatted 
                              getStrTrans("SÇrie: ", "ACR") at 45
                              v_cod_ser_docto_ini at 52 format "x(5)"
                              getStrTrans("atÇ: ", "ACR") at 69
                              v_cod_ser_docto_fim at 74 format "x(5)" skip
                              getStrTrans("T°tulo: ", "ACR") at 44
                              v_cod_tit_acr_ini at 52 format "x(16)"
                              getStrTrans("atÇ: ", "ACR") at 69
                              v_cod_tit_acr_fim at 74 format "x(16)" skip
                              getStrTrans("Parcela: ", "ACR") at 43
                              v_cod_parcela_ini at 52 format "x(02)".
                    put stream s_1 unformatted 
                              getStrTrans("atÇ: ", "ACR") at 69
                              v_cod_parcela_fim at 74 format "x(02)" skip.
                          run pi_print_editor ("s_1", v_ind_obs, "at044035", "", "", "", "").
                          assign v_des_return_value_editor = return-value.
                       &endif
                       end.
                    end.
                    /* End_Include: ix_p30_rpt_tit_acr_destinac */

                end /* if */.

/* Alteracao via filtro - Controle de impressao - inicio */
                ASSIGN v_page_number = PAGE-NUMBER(s_1) NO-ERROR.
/* Alteracao via filtro - Controle de impressao - fim    */

    /* Alteracao via filtro - UPC de impressora - inicio */
    EMPTY TEMP-TABLE tt-configur_layout_impres_fim.

    &if '{&product_version}' >= '12.1.L' &then
    run piBeforeClosePrinterUpc.
    &endif

    /* envia para o arquivo/impressora o resultado do retorno da upc de impressora */
    FOR EACH tt-configur_layout_impres_fim EXCLUSIVE-LOCK
        BY tt-configur_layout_impres_fim.num_ord_funcao_imprsor:
        DO  v_num_count = 1 TO EXTENT(tt-configur_layout_impres_fim.num_carac_configur):
            CASE tt-configur_layout_impres_fim.num_carac_configur[v_num_count]:
                WHEN 0 THEN PUT STREAM s_1 CONTROL null.
                WHEN ? THEN LEAVE.
                OTHERWISE
                    PUT STREAM s_1 CONTROL CHR(tt-configur_layout_impres_fim.num_carac_configur[v_num_count]).
            END CASE.
        END.
        DELETE tt-configur_layout_impres_fim.
    END.
    /* Alteracao via filtro - UPC de impressora - fim */

                output stream s_1 close.

    /* Alteracao via filtro - UPC de impressora - inicio */
    &if '{&product_version}' >= '12.1.L' &then
    run piAfterClosePrinterUpc.
    run piClosePrinterUpc.
    &endif
    /* Alteracao via filtro - UPC de impressora - fim */

/* tech38629 - Alteraá∆o efetuada via filtro */
&if '{&emsbas_version}':U >= '5.05':U and not proversion begins '10.1A':U &then
run pi_call_convert_object in v_prog_filtro_pdf (input no,
                                                 input rs_cod_dwb_output:screen-value in frame f_rpt_41_tit_acr_destinac,
                                                 input v_nom_dwb_print_file,
                                                 input v_cod_dwb_file,
                                                 input v_nom_report_title).
&endif
/* tech38629 - Fim da alteraá∆o */


&if '{&emsbas_version}':U >= '5.05':U and not proversion begins '10.1A':U &then
    if ((dwb_rpt_param.cod_dwb_output = 'Impressora':U or dwb_rpt_param.cod_dwb_output = 'Impresora':U or dwb_rpt_param.cod_dwb_output = 'printer':U) and getCodTipoRelat() = 'PDF':U) then do:
        if v_nom_dwb_print_file = '' then
            run pi_print_pdf_file in v_prog_filtro_pdf (input no).
    end.
&endif
                assign v_log_method = session:set-wait-state("").

                if (dwb_rpt_param.cod_dwb_output = "Terminal" /*l_terminal*/ ) then do:
                /* tech38629 - Alteraá∆o efetuada via filtro */
                &if '{&emsbas_version}':U >= '5.05':U and not proversion begins '10.1A':U &then
                    if  getCodTipoRelat() = 'PDF':U and OPSYS = 'WIN32':U
                    then do:
                        run pi_open_pdf_file in v_prog_filtro_pdf.
                    end.
                    else if getCodTipoRelat() = 'Texto' then do:
                &endif
                /* tech38629 - Fim da alteraá∆o */
                    run pi_show_report_2 (Input v_cod_dwb_file) /*pi_show_report_2*/.
                /* tech38629 - Alteraá∆o efetuada via filtro */
                &if '{&emsbas_version}':U >= '5.05':U and not proversion begins '10.1A':U &then
                    end.
                &endif
                /* tech38629 - Fim da alteraá∆o */
                end.


/* Alteracao via filtro - Controle de impressao - inicio */
                if (dwb_rpt_param.cod_dwb_output = "Impressora":U
                OR dwb_rpt_param.cod_dwb_output = "Impresora":U
                OR dwb_rpt_param.cod_dwb_output = "printer":U) THEN
                    ASSIGN v_page_number_impr = v_page_number.
                ELSE
                    ASSIGN v_page_number_impr = 0.

                RUN prgtec/btb/btb002.p (INPUT v_cod_usuar_corren,
                                         INPUT v_cod_usuar_abert,
                                         INPUT v_page_number,
                                         INPUT v_page_number_impr,
                                         INPUT v_dat_execution,
                                         INPUT v_cod_dwb_program,
                                         INPUT v_nom_report_title,
                                         INPUT v_nom_dwb_printer,
                                         INPUT v_nom_dwb_print_file).
/* Alteracao via filtro - Controle de impressao - fim    */

                leave main_block.

            end /* if */.
            else do:
                leave super_block.
            end /* else */.

        end /* repeat main_block */.

        /* ix_p32_rpt_tit_acr_destinac */

        if  v_num_ped_exec <> 0
        then do:
            /* Criado pedido &1 para execuá∆o batch. */
            run pi_messages (input "show",
                             input 3556,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                                v_num_ped_exec)) /*msg_3556*/.
            assign v_num_ped_exec = 0.
        end /* if */.

        /* ix_p35_rpt_tit_acr_destinac */

    end /* repeat block1 */.
end /* repeat super_block */.

/* ix_p40_rpt_tit_acr_destinac */

hide frame f_rpt_41_tit_acr_destinac.

/* Begin_Include: i_log_exec_prog_dtsul_fim */
if v_rec_log <> ? then do transaction:
    find log_exec_prog_dtsul where recid(log_exec_prog_dtsul) = v_rec_log exclusive-lock no-error.
    if  avail log_exec_prog_dtsul
    then do:
        assign log_exec_prog_dtsul.dat_fim_exec_prog_dtsul = today
               log_exec_prog_dtsul.hra_fim_exec_prog_dtsul = replace(string(time,"hh:mm:ss" /*l_hh:mm:ss*/ ),":":U,"":U).
    end /* if */.
    release log_exec_prog_dtsul.
end.

/* End_Include: i_log_exec_prog_dtsul_fim */


if  this-procedure:persistent then
    delete procedure this-procedure.

/* Alteracao via filtro - UPC de impressora - inicio */
&if '{&product_version}' >= '12.1.L' &then
run piClosePrinterUpc.
&endif
/* Alteracao via filtro - UPC de impressora - fim */

/* tech38629 - Alteraá∆o efetuada via filtro */
&if '{&emsbas_version}':U >= '5.05':U and not proversion begins '10.1A':U &then
delete procedure v_prog_filtro_pdf.
&endif
/* tech38629 - Fim da alteraá∆o */





/******************************* Main Code End ******************************/

/************************* Internal Procedure Begin *************************/

/* Alteracao via filtro - Controle de impressao - inicio*/
PROCEDURE pi-grava-usuar-solic:
   DO TRANSACTION:
      FIND b-dwb_rpt_param EXCLUSIVE-LOCK
         WHERE ROWID(b-dwb_rpt_param) = ROWID(dwb_rpt_param) NO-ERROR.
      IF AVAIL b-dwb_rpt_param THEN
         ASSIGN b-dwb_rpt_param.cod_livre_1 = TRIM(v_cod_usuar_abert).
      RELEASE b-dwb_rpt_param.
   END.
END PROCEDURE.
/* Alteracao via filtro - Controle de impressao - fim    */


/*****************************************************************************
** Procedure Interna.....: pi_return_user
** Descricao.............: pi_return_user
** Criado por............: 
** Criado em.............: // 
** Alterado por..........: corp340762
** Alterado em...........: 05/02/2014 14:49:10
*****************************************************************************/
PROCEDURE pi_return_user:

    /************************ Parameter Definition Begin ************************/

    def output param p_nom_user
        as character
        format "x(32)"
        no-undo.


    /************************* Parameter Definition End *************************/

    assign p_nom_user = v_cod_usuar_corren.

    if  v_cod_usuar_corren begins 'es_'
    then do:
        ASSIGN ENTRY(1, v_cod_usuar_corren, "_") = ""
               ENTRY(NUM-ENTRIES(v_cod_usuar_corren, "_"), v_cod_usuar_corren, "_") = ""
               v_cod_usuar_corren = SUBSTR(v_cod_usuar_corren, 2, LENGTH(v_cod_usuar_corren) - 2).
    end /* if */.

END PROCEDURE. /* pi_return_user */
/*****************************************************************************
** Procedure Interna.....: pi_filename_validation
** Descricao.............: pi_filename_validation
** Criado por............: 
** Criado em.............: // 
** Alterado por..........: andrew
** Alterado em...........: 30/09/2014 16:12:39
*****************************************************************************/
PROCEDURE pi_filename_validation:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_filename
        as character
        format "x(40)"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_cod_1                          as character       no-undo. /*local*/
    def var v_cod_2                          as character       no-undo. /*local*/
    def var v_num_1                          as integer         no-undo. /*local*/
    def var v_num_2                          as integer         no-undo. /*local*/


    /************************** Variable Definition End *************************/

    if  p_cod_filename = "" or p_cod_filename = "."
    then do:
        return "NOK" /*l_nok*/ .
    end /* if */.

    assign v_cod_1 = replace(p_cod_filename, "~\", "/").

    1_block:
    repeat v_num_1 = 1 to length(v_cod_1):
        if  index('abcdefghijklmnopqrstuvwxyz0123456789-_:/. ', substring(v_cod_1, v_num_1, 1)) = 0
        then do:
            return "NOK" /*l_nok*/ .
        end /* if */.
    end /* repeat 1_block */.

    if  num-entries(v_cod_1, ":") > 2
    then do:
        return "NOK" /*l_nok*/ .
    end /* if */.

    if  num-entries(v_cod_1, ":") = 2 and length(entry(1,v_cod_1,":")) > 1
    then do:
        return "NOK" /*l_nok*/ .
    end /* if */.

    if  num-entries(v_cod_1, ".") > 2
    then do:
        return "NOK" /*l_nok*/ .
    end /* if */.

    if  num-entries(v_cod_1, ".") = 2 and length(entry(2,v_cod_1,".")) > 3
    then do:
        return "NOK" /*l_nok*/ .
    end /* if */.

    if  index(entry(num-entries(v_cod_1, "/"),v_cod_1, "/"),".") = 0
    then do:
        return "NOK" /*l_nok*/ .
    end /* if */.
    else do:
        if  entry(1,entry(num-entries(v_cod_1,"/"),v_cod_1,"/"),".") = ""
        or  entry(2,entry(num-entries(v_cod_1,"/"),v_cod_1,"/"),".") = ""
        then do:
           return "NOK" /*l_nok*/ .
        end /* if */.
    end /* else */.

    assign v_num_1 = 1.
    2_block:
    repeat v_num_2 = 1 to length(v_cod_1):
        if  index(":" + "/" + ".", substring(v_cod_1, v_num_2, 1)) > 0
        then do:
            assign v_cod_2 = substring(v_cod_1, v_num_1, v_num_2 - v_num_1)
                   v_num_1 = v_num_2 + 1.
        end /* if */.
    end /* repeat 2_block */.
    assign v_cod_2 = substring(v_cod_1, v_num_1).

    return "OK" /*l_ok*/ .
END PROCEDURE. /* pi_filename_validation */
/*****************************************************************************
** Procedure Interna.....: pi_set_print_layout_default
** Descricao.............: pi_set_print_layout_default
** Criado por............: Gilsinei
** Criado em.............: 04/03/1996 09:22:54
** Alterado por..........: bre19127
** Alterado em...........: 16/09/2002 08:39:04
*****************************************************************************/
PROCEDURE pi_set_print_layout_default:

    dflt:
    do with frame f_rpt_41_tit_acr_destinac:

        find layout_impres_padr no-lock
             where layout_impres_padr.cod_usuario = v_cod_dwb_user
               and layout_impres_padr.cod_proced = 'rpt_tit_acr_destinac'
    &if "{&emsbas_version}" >= "5.01" &then
             use-index lytmprsp_id
    &endif
              /*cl_default_procedure_user of layout_impres_padr*/ no-error.
        if  not avail layout_impres_padr
        then do:
            find layout_impres_padr no-lock
                 where layout_impres_padr.cod_usuario = "*"
                   and layout_impres_padr.cod_proced = 'rpt_tit_acr_destinac'
    &if "{&emsbas_version}" >= "5.01" &then
                 use-index lytmprsp_id
    &endif
                  /*cl_default_procedure of layout_impres_padr*/ no-error.
            if  avail layout_impres_padr
            then do:
                find imprsor_usuar no-lock
                     where imprsor_usuar.nom_impressora = layout_impres_padr.nom_impressora
                       and imprsor_usuar.cod_usuario = v_cod_dwb_user
    &if "{&emsbas_version}" >= "5.01" &then
                     use-index imprsrsr_id
    &endif
                      /*cl_layout_current_user of imprsor_usuar*/ no-error.
            end /* if */.
            if  not avail imprsor_usuar
            then do:
                find layout_impres_padr no-lock
                     where layout_impres_padr.cod_usuario = v_cod_dwb_user
                       and layout_impres_padr.cod_proced = "*"
    &if "{&emsbas_version}" >= "5.01" &then
                     use-index lytmprsp_id
    &endif
                      /*cl_default_user of layout_impres_padr*/ no-error.
            end /* if */.
        end /* if */.
        do transaction:
            find dwb_rpt_param
                where dwb_rpt_param.cod_dwb_user = v_cod_usuar_corren
                and   dwb_rpt_param.cod_dwb_program = v_cod_dwb_program
                exclusive-lock no-error.
            if  avail layout_impres_padr
            then do:
                assign dwb_rpt_param.nom_dwb_printer      = layout_impres_padr.nom_impressora
                       dwb_rpt_param.cod_dwb_print_layout = layout_impres_padr.cod_layout_impres
                       ed_1x40:screen-value = dwb_rpt_param.nom_dwb_printer
                                            + ":"
                                            + dwb_rpt_param.cod_dwb_print_layout.
            end /* if */.
            else do:
                assign dwb_rpt_param.nom_dwb_printer       = ""
                       dwb_rpt_param.cod_dwb_print_layout  = ""
                       ed_1x40:screen-value = "".
            end /* else */.
        end.
    end /* do dflt */.
END PROCEDURE. /* pi_set_print_layout_default */
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
** Procedure Interna.....: pi_output_reports
** Descricao.............: pi_output_reports
** Criado por............: glauco
** Criado em.............: 21/03/1997 09:26:29
** Alterado por..........: tech38629
** Alterado em...........: 06/10/2006 22:40:15
*****************************************************************************/
PROCEDURE pi_output_reports:

/* tech38629 - Alteraá∆o efetuada via filtro */
&if '{&emsbas_version}':U >= '5.05':U and not proversion begins '10.1A':U &then
    run pi_posiciona_dwb_rpt_param in v_prog_filtro_pdf (input rowid(dwb_rpt_param)).
    run pi_load_params in v_prog_filtro_pdf.
&endif
/* tech38629 - Fim da alteraá∆o */




    assign v_log_method       = session:set-wait-state('general')
           v_nom_report_title = fill(" ",40 - length(v_rpt_s_1_name)) + v_rpt_s_1_name
           v_rpt_s_1_bottom   = v_qtd_line - (v_rpt_s_1_lines - v_qtd_bottom).

    /* block: */

&if '{&emsbas_version}':U >= '5.05':U and not proversion begins '10.1A':U &then
/*    case dwb_rpt_param.cod_dwb_output:*/
&else
    case dwb_rpt_param.cod_dwb_output:
&endif


&if '{&emsbas_version}':U >= '5.05':U and not proversion begins '10.1A':U &then
/*            when "Arquivo" /*l_file*/ then*/
            if dwb_rpt_param.cod_dwb_output = 'Impressora' and getCodTipoRelat() = 'PDF':U then do:
                run pi_config_output_print_pdf in v_prog_filtro_pdf (input v_qtd_line, input-output v_cod_dwb_file, input v_cod_usuar_corren, input yes).
            end.
            if dwb_rpt_param.cod_dwb_output = 'Arquivo' then
&else
            when "Arquivo" /*l_file*/ then
&endif

            block1:
            do:

               /* tech38629 - Relatorio PDF e RTF                 */
               /* Renomear arquivo quando extensao for pdf ou rtf */

/* tech38629 - Alteraá∆o efetuada via filtro */
&if '{&emsbas_version}':U >= '5.05':U and not proversion begins '10.1A':U &then
run pi_rename_file in v_prog_filtro_pdf (input-output v_cod_dwb_file).
&endif
/* tech38629 - Fim da alteraá∆o */



               output stream s_1 to value(v_cod_dwb_file)
               paged page-size value(v_qtd_line) convert target 'iso8859-1'.
            end /* do block1 */.

&if '{&emsbas_version}':U >= '5.05':U and not proversion begins '10.1A':U &then
/*            when "Impressora" /*l_printer*/ then*/
            if dwb_rpt_param.cod_dwb_output = 'Impressora' and getCodTipoRelat() <> 'PDF':U and getCodTipoRelat() <> 'RTF':U then
&else
            when "Impressora" /*l_printer*/ then
&endif

               block2:
               do:
                  find imprsor_usuar use-index imprsrsr_id no-lock
                      where imprsor_usuar.nom_impressora = dwb_rpt_param.nom_dwb_printer
                      and   imprsor_usuar.cod_usuario    = v_cod_usuar_corren no-error.
                  find impressora no-lock
                       where impressora.nom_impressora = imprsor_usuar.nom_impressora
                        no-error.
                  find tip_imprsor no-lock
                       where tip_imprsor.cod_tip_imprsor = impressora.cod_tip_imprsor
                        no-error.
                  find layout_impres no-lock
                       where layout_impres.nom_impressora = dwb_rpt_param.nom_dwb_printer
                         and layout_impres.cod_layout_impres = dwb_rpt_param.cod_dwb_print_layout /*cl_get_layout of layout_impres*/ no-error.
                  find b_ped_exec_style
                      where b_ped_exec_style.num_ped_exec = v_num_ped_exec_corren no-lock no-error.
                  find servid_exec_imprsor no-lock
                       where servid_exec_imprsor.nom_impressora = dwb_rpt_param.nom_dwb_printer
                         and servid_exec_imprsor.cod_servid_exec = b_ped_exec_style.cod_servid_exec no-error.

                  find b_servid_exec_style no-lock
                       where b_servid_exec_style.cod_servid_exec = b_ped_exec_style.cod_servid_exec
                       no-error.

                  /* Alteracao via filtro - UPC de impressora - inicio */
                  &if '{&product_version}' >= '12.1.L' &then
                  run piVerifPrinterUpc (input v_cod_usuar_corren, input imprsor_usuar.nom_impressora).
                  run piBeforeOutputPrinterUpc.
                  &else
                  ASSIGN cArqControlUpc     = servid_exec_imprsor.nom_disposit_so
                         iNumLinPagUpc      = (IF AVAILABLE layout_impres THEN layout_impres.num_lin_pag ELSE 0)
                         cPagCaracConverUpc = tip_imprsor.cod_pag_carac_conver.
                  &endif
                  /* Alteracao via filtro - UPC de impressora - fim */

                  if  avail layout_impres
                  then do:
                     assign v_rpt_s_1_bottom = iNumLinPagUpc - (v_rpt_s_1_lines - v_qtd_bottom).
                  end /* if */.

                  if  available b_servid_exec_style
                  and b_servid_exec_style.ind_tip_fila_exec = 'UNIX'
                  then do:
                      &if '{&emsbas_version}' > '1.00' &then           
                      &if '{&emsbas_version}' >= '5.03' &then           
                          if dwb_rpt_param.nom_dwb_print_file <> "" then do:
                              if  iNumLinPagUpc = 0
                              then do:
                                  output stream s_1 to value(lc(dwb_rpt_param.nom_dwb_print_file))
                                         page-size 0 convert target cPagCaracConverUpc.
                              end /* if */. 
                              else do:
                                  output stream s_1 to value(lc(dwb_rpt_param.nom_dwb_print_file))
                                         paged page-size value(iNumLinPagUpc) convert target cPagCaracConverUpc.
                              end /* else */.
                          end.
                          else do:
                              if  iNumLinPagUpc = 0
                              then do:
                                  output stream s_1 through value(cArqControlUpc)
                                         page-size 0 convert target cPagCaracConverUpc.
                              end /* if */. 
                              else do:
                                  output stream s_1 through value(cArqControlUpc)
                                         paged page-size value(iNumLinPagUpc) convert target cPagCaracConverUpc.
                              end /* else */.
                          end.
                      &else
                          if dwb_rpt_param.cod_livre_1 <> "" then do:
                              if  iNumLinPagUpc = 0
                              then do:
                                  output stream s_1 to value(lc(dwb_rpt_param.cod_livre_1))
                                         page-size 0 convert target cPagCaracConverUpc.
                              end /* if */. 
                              else do:
                                  output stream s_1 to value(lc(dwb_rpt_param.cod_livre_1))
                                         paged page-size value(iNumLinPagUpc) convert target cPagCaracConverUpc.
                              end /* else */.
                          end.
                          else do:
                              if  iNumLinPagUpc = 0
                              then do:
                                  output stream s_1 through value(cArqControlUpc)
                                         page-size 0 convert target cPagCaracConverUpc.
                              end /* if */. 
                              else do:
                                  output stream s_1 through value(cArqControlUpc)
                                         paged page-size value(iNumLinPagUpc) convert target cPagCaracConverUpc.
                              end /* else */.
                          end.
                      &endif
                      &endif
                  end /* if */.
                  else do:
                      &if '{&emsbas_version}' > '1.00' &then           
                      &if '{&emsbas_version}' >= '5.03' &then           
                          if dwb_rpt_param.nom_dwb_print_file <> "" then do:
                              if  iNumLinPagUpc = 0
                              then do:
                                  output stream s_1 to value(lc(dwb_rpt_param.nom_dwb_print_file))
                                         page-size 0 convert target cPagCaracConverUpc.                            
                              end /* if */.
                              else do:
                                  output stream s_1 to value(lc(dwb_rpt_param.nom_dwb_print_file))
                                         paged page-size value(iNumLinPagUpc) convert target cPagCaracConverUpc.                     
                              end /* else */.
                          end.
                          else do:
                              if  iNumLinPagUpc = 0
                              then do:
                                  output stream s_1 to value(cArqControlUpc)
                                         page-size 0 convert target cPagCaracConverUpc.                            
                              end /* if */.
                              else do:
                                  output stream s_1 to value(cArqControlUpc)
                                         paged page-size value(iNumLinPagUpc) convert target cPagCaracConverUpc.                     
                              end /* else */.
                          end.
                      &else
                          if dwb_rpt_param.cod_livre_1 <> "" then do:
                              if  iNumLinPagUpc = 0
                              then do:
                                  output stream s_1 to value(lc(dwb_rpt_param.cod_livre_1))
                                         page-size 0 convert target cPagCaracConverUpc.                            
                              end /* if */.
                              else do:
                                  output stream s_1 to value(lc(dwb_rpt_param.cod_livre_1))
                                         paged page-size value(iNumLinPagUpc) convert target cPagCaracConverUpc.                     
                              end /* else */.
                          end.
                          else do:
                              if  iNumLinPagUpc = 0
                              then do:
                                  output stream s_1 to value(cArqControlUpc)
                                         page-size 0 convert target cPagCaracConverUpc.                            
                              end /* if */.
                              else do:
                                  output stream s_1 to value(cArqControlUpc)
                                         paged page-size value(iNumLinPagUpc) convert target cPagCaracConverUpc.                     
                              end /* else */.
                          end.
                      &endif
                      &endif
                  end /* else */.

                  /* Alteracao via filtro - UPC de impressora - inicio */
                  EMPTY TEMP-TABLE tt-configur_layout_impres_inicio.
                  FOR EACH configur_layout_impres NO-LOCK
                      WHERE configur_layout_impres.num_id_layout_impres = layout_impres.num_id_layout_impres
                      BY    configur_layout_impres.num_ord_funcao_imprsor:
                      FIND configur_tip_imprsor USE-INDEX cnfgrtpm_id
                          WHERE configur_tip_imprsor.cod_tip_imprsor        = layout_impres.cod_tip_imprsor
                          AND   configur_tip_imprsor.cod_funcao_imprsor     = configur_layout_impres.cod_funcao_imprsor
                          AND   configur_tip_imprsor.cod_opc_funcao_imprsor = configur_layout_impres.cod_opc_funcao_imprsor
                          NO-LOCK NO-ERROR.
                      CREATE tt-configur_layout_impres_inicio.
                      BUFFER-COPY configur_tip_imprsor TO tt-configur_layout_impres_inicio
                          ASSIGN tt-configur_layout_impres_inicio.num_ord_funcao_imprsor = configur_layout_impres.num_ord_funcao_imprsor.
                  END.

                  &if '{&product_version}' >= '12.1.L' &then
                  run piAfterOutputPrinterUpc.
                  &endif

                  setting:
                  FOR EACH tt-configur_layout_impres_inicio EXCLUSIVE-LOCK
                      BY tt-configur_layout_impres_inicio.num_ord_funcao_imprsor:
                      DO  v_num_count = 1 TO EXTENT(tt-configur_layout_impres_inicio.num_carac_configur):
                          CASE tt-configur_layout_impres_inicio.num_carac_configur[v_num_count]:
                              WHEN 0 THEN PUT STREAM s_1 CONTROL null.
                              WHEN ? THEN LEAVE.
                              OTHERWISE
                                  PUT STREAM s_1 CONTROL CHR(tt-configur_layout_impres_inicio.num_carac_configur[v_num_count]).
                          END CASE.
                      END.
                  END.
                  /* Alteracao via filtro - UPC de impressora - fim */
            end /* do block2 */.
&if '{&emsbas_version}':U >= '5.05':U and not proversion begins '10.1A':U &then
/*    end /* case block */.*/
&else
    end /* case block */.
&endif


    run pi_rpt_tit_acr_destinac /*pi_rpt_tit_acr_destinac*/.
END PROCEDURE. /* pi_output_reports */
/*****************************************************************************
** Procedure Interna.....: pi_rpt_tit_acr_destinac
** Descricao.............: pi_rpt_tit_acr_destinac
** Criado por............: Roberto
** Criado em.............: 22/08/1997 17:32:21
** Alterado por..........: bre18732
** Alterado em...........: 01/04/2004 15:34:00
*****************************************************************************/
PROCEDURE pi_rpt_tit_acr_destinac:

    /************************** Buffer Definition Begin *************************/

    &if "{&emsfin_version}" >= "5.01" &then
    def buffer b_cart_bcia
        for cart_bcia.
    &endif


    /*************************** Buffer Definition End **************************/

    /************************* Variable Definition Begin ************************/

    def var v_dat_aux
        as date
        format "99/99/9999":U
        no-undo.
    def var v_dat_emis_docto
        as date
        format "99/99/9999":U
        label "Data Emiss∆o"
        column-label "Dt Emiss∆o"
        no-undo.


    /************************** Variable Definition End *************************/

    &IF integer(entry(1,proversion,".")) >= 9 &THEN
        empty temp-table tt_atualiza_destinac_tit_acr no-error.
        empty temp-table tt_rpt_calc_custo_acr        no-error.
        empty temp-table tt_portad_finalid_econ       no-error.
        empty temp-table tt_rpt_tit_acr_destinac      no-error.
        empty temp-table tt_espec_docto               no-error.
        empty temp-table tt_item_destinac_cobr_dest   no-error.
        empty temp-table tt_tit_destinac_percent      no-error.
        empty temp-table tt_portad_bco                no-error.
    &ELSE
        for each tt_atualiza_destinac_tit_acr exclusive-lock: delete tt_atualiza_destinac_tit_acr. end.
        for each tt_rpt_calc_custo_acr exclusive-lock:        delete tt_rpt_calc_custo_acr.        end.
        for each tt_portad_finalid_econ exclusive-lock:       delete tt_portad_finalid_econ.       end.
        for each tt_rpt_tit_acr_destinac exclusive-lock:      delete tt_rpt_tit_acr_destinac.      end.
        for each tt_espec_docto exclusive-lock:               delete tt_espec_docto.               end.
        for each tt_item_destinac_cobr_dest exclusive-lock:   delete tt_item_destinac_cobr_dest.   end.
        for each tt_tit_destinac_percent exclusive-lock:      delete tt_tit_destinac_percent.      end.
        for each tt_portad_bco:                               delete tt_portad_bco.                end.
    &ENDIF
    assign v_val_tot_cobr        = 0
           v_val_tot_dest        = 0
           v_val_tot_cust        = 0
           v_val_sdo_cobr        = 0
           v_val_tot_portad      = 0
           v_val_tot_destinac    = 0
           v_val_sdo_cobr_ant    = 0
           v_val_tot_cart_bcia   = 0
           v_val_meta_destinac   = 0
           v_val_destinac_portad = 0
           v_val_tot             = 0.

    for each  item_destinac_cobr no-lock
        where item_destinac_cobr.cod_empresa           = destinac_cobr.cod_empresa
          and item_destinac_cobr.cod_destinac_cobr     = destinac_cobr.cod_destinac_cobr
          and item_destinac_cobr.num_seq_destinac_cobr = destinac_cobr.num_seq_destinac_cobr:
        create tt_item_destinac_cobr_dest.
        assign tt_item_destinac_cobr_dest.cod_empresa            = item_destinac_cobr.cod_empresa
               tt_item_destinac_cobr_dest.cod_destinac_cobr      = item_destinac_cobr.cod_destinac_cobr
               tt_item_destinac_cobr_dest.num_seq_destinac_cobr  = item_destinac_cobr.num_seq_destinac_cobr
               tt_item_destinac_cobr_dest.cod_portador           = item_destinac_cobr.cod_portador
               tt_item_destinac_cobr_dest.cod_cart_bcia          = item_destinac_cobr.cod_cart_bcia
               tt_item_destinac_cobr_dest.num_ord_destinac       = item_destinac_cobr.num_ord_destinac
               tt_item_destinac_cobr_dest.cod_estab              = item_destinac_cobr.cod_estab
               tt_item_destinac_cobr_dest.val_perc_niv_cobr      = item_destinac_cobr.val_perc_niv_cobr
               tt_item_destinac_cobr_dest.val_niv_cobr           = item_destinac_cobr.val_niv_cobr
               tt_item_destinac_cobr_dest.val_perc_erro_destinac = item_destinac_cobr.val_perc_erro_destinac.
    end.

    for each portad_bco no-lock
        where portad_bco.cod_modul_dtsul = "ACR" /*l_acr*/ :
        create tt_portad_bco.
        buffer-copy portad_bco to tt_portad_bco.
    end.

    block:
    for each estabelecimento no-lock
        where estabelecimento.cod_empresa = v_cod_empres_usuar
        and   estabelecimento.cod_estab  >= v_cod_estab_ini
        and   estabelecimento.cod_estab  <= v_cod_estab_fim:

        run pi_retorna_parametro_acr (Input estabelecimento.cod_estab,
                                      Input v_dat_destinac) /*pi_retorna_parametro_acr*/.
        if  not avail param_estab_acr then
            next block.

        block_1:
        for each portad_finalid_econ no-lock use-index prtdfnld_id
            where portad_finalid_econ.cod_estab        = estabelecimento.cod_estab
            and   portad_finalid_econ.cod_finalid_econ = destinac_cobr.cod_finalid_econ,
            first cart_bcia no-lock use-index cartbcia_id
            where cart_bcia.cod_cart_bcia = portad_finalid_econ.cod_cart_bcia
            and   cart_bcia.ind_tip_cart_bcia <> "Contas a Pagar" /*l_contas_a_pagar*/ :

            find tt_portad_finalid_econ no-lock
                where tt_portad_finalid_econ.tta_cod_portador = portad_finalid_econ.cod_portador
                and   tt_portad_finalid_econ.tta_cod_cart_bcia = portad_finalid_econ.cod_cart_bcia
                and   tt_portad_finalid_econ.tta_cod_finalid_econ = portad_finalid_econ.cod_finalid_econ no-error.
            if  not avail tt_portad_finalid_econ then do:
                create tt_portad_finalid_econ.
                assign tt_portad_finalid_econ.tta_cod_portador     = portad_finalid_econ.cod_portador
                       tt_portad_finalid_econ.tta_cod_cart_bcia    = portad_finalid_econ.cod_cart_bcia
                       tt_portad_finalid_econ.tta_cod_finalid_econ = portad_finalid_econ.cod_finalid_econ
                       tt_portad_finalid_econ.tta_cod_cta_corren   = portad_finalid_econ.cod_cta_corren.
                find cta_corren no-lock
                    where cta_corren.cod_cta_corren = portad_finalid_econ.cod_cta_corren no-error.
                find banco no-lock
                     where banco.cod_banco = cta_corren.cod_banco
                      no-error.
                if avail banco then
                   assign tt_portad_finalid_econ.tta_cod_banco = banco.cod_banco
                          tt_portad_finalid_econ.tta_log_validac_cep_destinac = banco.log_validac_cep_destinac.
            end.
            assign tt_portad_finalid_econ.ttv_val_sdo_cobr_ant = tt_portad_finalid_econ.ttv_val_sdo_cobr_ant + portad_finalid_econ.val_sdo_cobr
                   tt_portad_finalid_econ.tta_val_sdo_cobr = tt_portad_finalid_econ.tta_val_sdo_cobr + portad_finalid_econ.val_sdo_cobr.
            if  destinac_cobr.log_control_perc_destinac then
                assign v_val_tot_cobr = v_val_tot_cobr + portad_finalid_econ.val_sdo_cobr.
            find tt_portad_fe_param_estab no-lock
                where tt_portad_fe_param_estab.tta_cod_estab        = portad_finalid_econ.cod_estab
                and   tt_portad_fe_param_estab.tta_cod_portador     = portad_finalid_econ.cod_portador
                and   tt_portad_fe_param_estab.tta_cod_cart_bcia    = portad_finalid_econ.cod_cart_bcia
                and   tt_portad_fe_param_estab.tta_cod_finalid_econ = portad_finalid_econ.cod_finalid_econ no-error.
            if  not avail tt_portad_fe_param_estab then do:
                create tt_portad_fe_param_estab.
                assign tt_portad_fe_param_estab.tta_cod_portador     = portad_finalid_econ.cod_portador
                       tt_portad_fe_param_estab.tta_cod_cart_bcia    = portad_finalid_econ.cod_cart_bcia
                       tt_portad_fe_param_estab.tta_cod_finalid_econ = portad_finalid_econ.cod_finalid_econ
                       tt_portad_fe_param_estab.tta_cod_estab        = portad_finalid_econ.cod_estab.
                find b_cart_bcia no-lock 
                    where b_cart_bcia.cod_cart_bcia = portad_finalid_econ.cod_cart_bcia no-error.
                if avail b_cart_bcia then
                    assign tt_portad_fe_param_estab.tta_ind_tip_cart_bcia = b_cart_bcia.ind_tip_cart_bcia.
            end.
        end /* for block_1 */.
    end /* for block */.

    run pi_retornar_indic_econ_finalid (Input destinac_cobr.cod_finalid_econ,
                                        Input v_dat_destinac,
                                        output v_cod_indic_econ_des) /*pi_retornar_indic_econ_finalid*/.

    referencia:
    repeat:
        run pi_retorna_sugestao_referencia (Input "D" /*l_D*/,
                                            Input today,
                                            output v_cod_refer) /*pi_retorna_sugestao_referencia*/.
        tit_block:
        for
           each estabelecimento no-lock
             where estabelecimento.cod_empresa  = v_cod_empres_usuar
               and estabelecimento.cod_estab   >= v_cod_estab_ini
               and estabelecimento.cod_estab   <= v_cod_estab_fim:
            find first movto_tit_acr no-lock
                 where movto_tit_acr.cod_estab = estabelecimento.cod_estab
                   and movto_tit_acr.cod_refer = v_cod_refer
                 use-index mvtttcr_refer no-error.
            if avail movto_tit_acr then next referencia.
        end /* for tit_block */.
        leave referencia.    
    end.

    /* ** SE A FAIXA DE PORTADORES INFORMADA FOR UM UNICO PORTADOR,
         NO CASO DE TODOS OS TITULOS NAO-DESTINADOS FICAREM CENTRALIZADOS NELE,
         O PROGRAMA USARµ INDICE POR PORTADOR ***/

    /* ==> MODULO VENDOR <== */
    if  v_log_modul_vendor then do:

        /* Begin_Include: i_instanciar_api_centraliz_integr_acr_vdr */
        /* ==> MODULO VENDOR <== */
        /* CASO O M‡DULO VENDOR ESTEJA ATIVO, SETA COMO PERSIST“NTE SUA EXECUÄ«O */
        if  v_log_modul_vendor
        then do:
           if  not valid-handle( v_hdl_api_centraliz_acr_vdr )
           then do:
              run prgfin/vdr/vdr916zc.py persistent set v_hdl_api_centraliz_acr_vdr (Input 1) /*prg_API_CENTRALIZA_INTEGR_ACR_VDR*/.
              ASSIGN v_log_handle = YES.
           end.
        end.
        /* End_Include: i_instanciar_api_centraliz_integr_acr_vdr */

    end.

    if  v_cod_portador_ini = v_cod_portador_fim
    and v_dat_emis_inic <> v_dat_emis_final then do:

        /* ** MONTA TEMP-TABLE COM ESPECIES ACR ***/
        for each espec_docto no-lock
            where (espec_docto.ind_tip_espec_docto = "Normal" /*l_normal*/ 
            and   espec_docto.cod_espec_docto    >= v_cod_espec_docto_ini
            and   espec_docto.cod_espec_docto    <= v_cod_espec_docto_fim)

            or   (espec_docto.ind_tip_espec_docto = "Terceiros" /*l_terceiros*/  /* controle terceiros */
            and   espec_docto.cod_espec_docto    >= v_cod_espec_docto_ini
            and   espec_docto.cod_espec_docto    <= v_cod_espec_docto_fim)

            or    (espec_docto.ind_tip_espec_docto = "Aviso DÇbito" /*l_aviso_debito*/ 
            and   espec_docto.cod_espec_docto    >= v_cod_espec_docto_ini
            and   espec_docto.cod_espec_docto    <= v_cod_espec_docto_fim)

            or    (espec_docto.ind_tip_espec_docto = "Cheques Recebidos" /*l_cheques_recebidos*/ 
            and   espec_docto.cod_espec_docto    >= v_cod_espec_docto_ini
            and   espec_docto.cod_espec_docto    <= v_cod_espec_docto_fim)

            or (espec_docto.ind_tip_espec_docto = "Cheques Terceiros" /*l_cheq_terc*/   /* controle terceiros */
            and   espec_docto.cod_espec_docto    >= v_cod_espec_docto_ini
            and   espec_docto.cod_espec_docto    <= v_cod_espec_docto_fim):

            if  can-find( first espec_docto_financ_acr no-lock
                where espec_docto_financ_acr.cod_espec_docto = espec_docto.cod_espec_docto) then do:
                create tt_espec_docto.
                assign tt_espec_docto.tta_cod_espec_docto = espec_docto.cod_espec_docto.
            end.
        end.

        /* ** FOR EACH POR ESTAB / ESPEC / PORTADOR ***/
        tit_block:
        for
           each estabelecimento no-lock
             where estabelecimento.cod_empresa  = v_cod_empres_usuar
               and estabelecimento.cod_estab   >= v_cod_estab_ini
               and estabelecimento.cod_estab   <= v_cod_estab_fim,
           last param_estab_acr no-lock
             where param_estab_acr.cod_estab       = estabelecimento.cod_estab
               and param_estab_acr.dat_inic_valid <= v_dat_destinac
               and param_estab_acr.dat_fim_valid  >=  v_dat_destinac,
           each tt_espec_docto,
           each tit_acr no-lock
             where tit_acr.cod_estab             = estabelecimento.cod_estab
               and tit_acr.cod_portador          = v_cod_portador_ini
               and tit_acr.cod_espec_docto       = tt_espec_docto.tta_cod_espec_docto
               and tit_acr.dat_emis_docto       >= v_dat_emis_inic
               and tit_acr.dat_emis_docto       <= v_dat_emis_final
               and tit_acr.ind_sit_tit_acr       = "Normal" /*l_normal*/ 
               and tit_acr.num_bord_acr          = 0
               and tit_acr.log_tit_acr_cobr_bcia = no
               and tit_acr.cod_indic_econ        = v_cod_indic_econ_des
               and tit_acr.log_sdo_tit_acr       = yes
               and tit_acr.log_tit_acr_estordo   = no
               and tit_acr.dat_transacao        <= v_dat_destinac
               and tit_acr.cod_cart_bcia        >= v_cod_cart_bcia_inicial
               and tit_acr.cod_cart_bcia        <= v_cod_cart_bcia_fim
               and tit_acr.dat_vencto_tit_acr   >= v_dat_vencto_inicial
               and tit_acr.dat_vencto_tit_acr   <= v_dat_vencto_final
               and tit_acr.cod_refer            >= v_cod_refer_ini
               and tit_acr.cod_refer            <= v_cod_refer_fim
               and tit_acr.cdn_cliente          >= v_cdn_cliente_ini
               and tit_acr.cdn_cliente          <= v_cdn_cliente_fim
               and tit_acr.cod_ser_docto        >= v_cod_ser_docto_ini
               and tit_acr.cod_ser_docto        <= v_cod_ser_docto_fim
               and tit_acr.cod_tit_acr          >= v_cod_tit_acr_ini
               and tit_acr.cod_tit_acr          <= v_cod_tit_acr_fim
               and tit_acr.cod_parcela          >= v_cod_parcela_ini
               and tit_acr.cod_parcela          <= v_cod_parcela_fim
               and tit_acr.val_sdo_tit_acr      >= v_val_sdo_inic
               and tit_acr.val_sdo_tit_acr      <= v_val_sdo_fim
            use-index titacr_estab_portad_espec
            by tit_acr.dat_vencto_tit_acr:

            run pi_rpt_tit_acr_destinac_aux /*pi_rpt_tit_acr_destinac_aux*/.
            if  return-value <> "OK" /*l_ok*/  then
                next tit_block.
        end.
    end.
    else do:
        tit_block:
        for
           each estabelecimento no-lock
             where estabelecimento.cod_empresa  = v_cod_empres_usuar
             and   estabelecimento.cod_estab   >= v_cod_estab_ini
             and   estabelecimento.cod_estab   <= v_cod_estab_fim,
           last param_estab_acr no-lock
             where param_estab_acr.cod_estab       = estabelecimento.cod_estab
             and   param_estab_acr.dat_inic_valid <= v_dat_destinac
             and   param_estab_acr.dat_fim_valid  >= v_dat_destinac,
           each tit_acr no-lock
             where tit_acr.cod_estab             = estabelecimento.cod_estab
               and tit_acr.dat_emis_docto       >= v_dat_emis_inic
               and tit_acr.dat_emis_docto       <= v_dat_emis_final
               and tit_acr.ind_sit_tit_acr       = "Normal" /*l_normal*/ 
               and tit_acr.num_bord_acr          = 0
               and tit_acr.log_tit_acr_cobr_bcia = no
               and tit_acr.cod_indic_econ        = v_cod_indic_econ_des
               and tit_acr.log_sdo_tit_acr       = yes
               and tit_acr.log_tit_acr_estordo   = no
               and tit_acr.dat_transacao        <= v_dat_destinac
               and tit_acr.cod_portador         >= v_cod_portador_ini
               and tit_acr.cod_portador         <= v_cod_portador_fim
               and tit_acr.cod_cart_bcia        >= v_cod_cart_bcia_inicial
               and tit_acr.cod_cart_bcia        <= v_cod_cart_bcia_fim
               and tit_acr.dat_vencto_tit_acr   >= v_dat_vencto_inicial
               and tit_acr.dat_vencto_tit_acr   <= v_dat_vencto_final
               and tit_acr.cod_refer            >= v_cod_refer_ini
               and tit_acr.cod_refer            <= v_cod_refer_fim
               and tit_acr.cdn_cliente          >= v_cdn_cliente_ini
               and tit_acr.cdn_cliente          <= v_cdn_cliente_fim
               and tit_acr.cod_espec_docto      >= v_cod_espec_docto_ini
               and tit_acr.cod_espec_docto      <= v_cod_espec_docto_fim
               and tit_acr.cod_ser_docto        >= v_cod_ser_docto_ini
               and tit_acr.cod_ser_docto        <= v_cod_ser_docto_fim
               and tit_acr.cod_tit_acr          >= v_cod_tit_acr_ini
               and tit_acr.cod_tit_acr          <= v_cod_tit_acr_fim
               and tit_acr.cod_parcela          >= v_cod_parcela_ini
               and tit_acr.cod_parcela          <= v_cod_parcela_fim
               and tit_acr.val_sdo_tit_acr      >= v_val_sdo_inic
               and tit_acr.val_sdo_tit_acr      <= v_val_sdo_fim
            use-index titacr_emis
            by tit_acr.dat_vencto_tit_acr:

            run pi_rpt_tit_acr_destinac_aux /*pi_rpt_tit_acr_destinac_aux*/.
            if  return-value <> "OK" /*l_ok*/  then
                next tit_block.
        end.
    end.
    assign v_cod_return = 'OK'.

    /* ==> MODULO VENDOR <== */
    if  v_log_modul_vendor then do:

        /* Begin_Include: i_eliminar_api_centraliz_integr_acr_vdr */
        /* ==> MODULO VENDOR <== */
        /* ELIMINA DA MEM‡RIA PROGRAMA VENDOR PERSIST“NTE */
        if  valid-handle( v_hdl_api_centraliz_acr_vdr ) AND v_log_handle
        then do:
            delete procedure v_hdl_api_centraliz_acr_vdr.
            ASSIGN v_hdl_api_centraliz_acr_vdr = ?.
        end.
        /* End_Include: i_eliminar_api_centraliz_integr_acr_vdr */

    end.

    if  v_log_destinac_manual = yes
    and v_ind_tip_destinac <> "Listagem de T°tulos a Destinar" /*l_listagem_de_titulos_a_destinar*/ 
    then do:

        if  search("prgfin/acr/acr739ta.r") = ? and search("prgfin/acr/acr739ta.p") = ? then do:
            if  v_cod_dwb_user begins 'es_' then
                return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgfin/acr/acr739ta.p".
            else do:
                message getStrTrans("Programa execut†vel n∆o foi encontrado:", "ACR") /*l_programa_nao_encontrado*/  "prgfin/acr/acr739ta.p"
                       view-as alert-box error buttons ok.
                return.
            end.
        end.
        else
            run prgfin/acr/acr739ta.p (output v_cod_return,
                                   Input v_ind_classif_destinac) /*prg_dlg_tit_acr_destinac*/.
        if  v_cod_return = 'NOK' then
            return error.

        if  not v_cod_dwb_user begins 'es_' then
            assign v_log_method = session:set-wait-state('general').
        /* ** EXECUTA DESTINAÄ«O ***/
        for each tt_rpt_tit_acr_destinac exclusive-lock
            by tt_rpt_tit_acr_destinac.tta_cod_portador
            by tt_rpt_tit_acr_destinac.tta_cod_cart_bcia
            by tt_rpt_tit_acr_destinac.tta_dat_emis_docto:
            run pi_executar_tit_acr_destinac /*pi_executar_tit_acr_destinac*/.
        end.
    end /* if */.

    if  v_log_destinac_percent_sdo
    and v_ind_tip_destinac <> "Listagem de T°tulos a Destinar" /*l_listagem_de_titulos_a_destinar*/  then
        run pi_executar_destinac_percent /*pi_executar_destinac_percent*/.

    /* ** IMPRIME LISTAGEM DE TITULOS A DESTINAR/DESTINADOS ***/
    run pi_imprimir_tit_acr_destinac /*pi_imprimir_tit_acr_destinac*/.
END PROCEDURE. /* pi_rpt_tit_acr_destinac */
/*****************************************************************************
** Procedure Interna.....: pi_verifica_movto_tit_acr_posterior
** Descricao.............: pi_verifica_movto_tit_acr_posterior
** Criado por............: Roberto
** Criado em.............: 19/06/1998 08:32:34
** Alterado por..........: src12337
** Alterado em...........: 06/11/2002 16:14:12
*****************************************************************************/
PROCEDURE pi_verifica_movto_tit_acr_posterior:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_estab
        as character
        format "x(5)"
        no-undo.
    def Input param p_num_id_tit_acr
        as integer
        format "999999999"
        no-undo.
    def Input param p_num_id_movto_tit_acr
        as integer
        format "999999999"
        no-undo.
    def Input param p_dat_transacao
        as date
        format "99/99/9999"
        no-undo.
    def Input param p_ind_tip_trans
        as character
        format "X(08)"
        no-undo.
    def output param p_log_exist
        as logical
        format "Sim/N∆o"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************** Buffer Definition Begin *************************/

    &if "{&emsfin_version}" >= "5.01" &then
    def buffer b_movto_tit_acr
        for movto_tit_acr.
    &endif


    /*************************** Buffer Definition End **************************/

    assign p_log_exist = no.

    if  p_num_id_movto_tit_acr = ? then do:
        assign p_num_id_movto_tit_acr = 0.
    end.

    /* **
     Se for estorno, dever† ser feito apartir do £ltimo movimento da mesma data devido a
     apenas um dos movimentos gerar correá∆o de valor.
     Caso contr†rio dever† apenas ser considerada a data de transaá∆o.
    ***/
    if  p_ind_tip_trans = "Alteraá∆o" /*l_alteracao*/ 
    or  p_ind_tip_trans = "Liquidaá∆o" /*l_liquidacao*/ 
    or  p_ind_tip_trans = "Transf Unidade Neg¢cio" /*l_transf_unidade_negocio*/  
    or  p_ind_tip_trans = "Destinaá∆o" /*l_destinacao*/  then do:
        assign p_dat_transacao = p_dat_transacao + 1.
    end.

    find first b_movto_tit_acr no-lock
        where b_movto_tit_acr.cod_estab             = p_cod_estab
          and b_movto_tit_acr.num_id_tit_acr        = p_num_id_tit_acr
          and b_movto_tit_acr.num_id_movto_tit_acr >  p_num_id_movto_tit_acr
          and b_movto_tit_acr.dat_transacao        >= p_dat_transacao
          and b_movto_tit_acr.log_ctbz_aprop_ctbl   = yes
          and b_movto_tit_acr.log_movto_estordo     = no 
          and not b_movto_tit_acr.ind_trans_acr     = "Despesa Financeira" /*l_despesa_financeira*/ 
          and not b_movto_tit_acr.ind_trans_acr     = "Desconto Banc†rio" /*l_desconto_Bancario*/ 
          and not b_movto_tit_acr.ind_trans_acr begins "Estorno" /*l_estorno*/ 
        no-error.

    if  avail b_movto_tit_acr then do:
        assign p_log_exist = yes.
    end.
END PROCEDURE. /* pi_verifica_movto_tit_acr_posterior */
/*****************************************************************************
** Procedure Interna.....: pi_sdo_cta_corren_spool_modulos
** Descricao.............: pi_sdo_cta_corren_spool_modulos
** Criado por............: dalpra
** Criado em.............: 20/07/1998 15:15:28
** Alterado por..........: 002565
** Alterado em...........: 15/08/2019 10:42:58
*****************************************************************************/
PROCEDURE pi_sdo_cta_corren_spool_modulos:

    /* --- API para Atualizaá∆o dos Saldos das Contas Correntes SPOOL ---*/
    DO ON ERROR UNDO, RETURN ERROR:
        run prgfin/cmg/cmg709za.py (Input 1) /*prg_api_sdo_cta_corren_spool*/.

        if  return-value = '2782' then do:
            /* Vers∆o de integraá∆o incorreta ! */
            run pi_messages (input "show",
                             input 2782,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_2782*/.
            return error.
        end.

        run pi_sdo_fluxo_cx_spool_modulos /*pi_sdo_fluxo_cx_spool_modulos*/.
    END.
END PROCEDURE. /* pi_sdo_cta_corren_spool_modulos */
/*****************************************************************************
** Procedure Interna.....: pi_tratar_tt_rpt_tit_acr_destinac
** Descricao.............: pi_tratar_tt_rpt_tit_acr_destinac
** Criado por............: Roberto
** Criado em.............: 25/08/1997 15:48:42
** Alterado por..........: fut12199
** Alterado em...........: 02/03/2005 17:34:36
*****************************************************************************/
PROCEDURE pi_tratar_tt_rpt_tit_acr_destinac:

    /************************* Variable Definition Begin ************************/

    def var v_nom_cidade
        as character
        format "x(32)":U
        label "Cidade"
        column-label "Cidade"
        no-undo.


    /************************** Variable Definition End *************************/

    /* chamada espec°fica para func‰es Controle Terceiros */
    if  /*v_log_control_terc_acr = yes 
    and*/ tit_acr.ind_tip_espec_docto <> "Terceiros" /*l_terceiros*/ 
    and tit_acr.ind_tip_espec_docto <> "Cheques Terceiros" /*l_cheq_terc*/  then do:
        if  v_nom_prog_upc <> '' then do:
            assign v_rec_table_epc = recid(tit_acr).
            run value(v_nom_prog_upc) (input 'Valida t°tulo':U,
                                       input 'viewer',
                                       input this-procedure,
                                       input v_wgh_frame_epc,
                                       input v_nom_table_epc,
                                       input v_rec_table_epc).
            if  return-value = 'NOK' then
                return.
       end.
    End.
    if v_log_modul_vendor then do:
        run pi_duplicata_comp_planilha in v_hdl_api_centraliz_acr_vdr (Input tit_acr.cod_estab,
                                        Input tit_acr.num_id_tit_acr,
                                        output v_log_planilha) /*pi_duplicata_comp_planilha*/.
        if v_log_planilha = yes then return "NOK" /*l_nok*/ .
    end.

    if  tit_acr.num_pessoa mod 2 = 0 then do:
        if not avail pessoa_fisic then do:
            find pessoa_fisic no-lock
                where pessoa_fisic.num_pessoa_fisic = tit_acr.num_pessoa no-error.
        end.
        if avail pessoa_fisic then
            assign v_nom_cidade = pessoa_fisic.nom_cidade.
    end.
    else do:
        if not avail pessoa_jurid then do:
            find pessoa_jurid no-lock
                where pessoa_jurid.num_pessoa_jurid = tit_acr.num_pessoa no-error.
        end.
        if avail pessoa_jurid then do:
           if pessoa_jurid.nom_cidad_cobr <> "" then
              assign v_nom_cidade = pessoa_jurid.nom_cidad_cobr.
           else
              assign v_nom_cidade = pessoa_jurid.nom_cidade.
        end.
    end.
    create tt_rpt_tit_acr_destinac.
    assign tt_rpt_tit_acr_destinac.ttv_rec_tit_acr         = v_rec_tit_acr
           tt_rpt_tit_acr_destinac.tta_cod_empresa         = tit_acr.cod_empresa
           tt_rpt_tit_acr_destinac.tta_cod_estab           = tit_acr.cod_estab
           tt_rpt_tit_acr_destinac.tta_num_id_tit_acr      = tit_acr.num_id_tit_acr
           tt_rpt_tit_acr_destinac.tta_cod_espec_docto     = tit_acr.cod_espec_docto
           tt_rpt_tit_acr_destinac.tta_cod_ser_docto       = tit_acr.cod_ser_docto
           tt_rpt_tit_acr_destinac.tta_cod_tit_acr         = tit_acr.cod_tit_acr
           tt_rpt_tit_acr_destinac.tta_cod_parcela         = tit_acr.cod_parcela
           tt_rpt_tit_acr_destinac.tta_cdn_cliente         = tit_acr.cdn_cliente
           tt_rpt_tit_acr_destinac.tta_dat_vencto_tit_acr  = tit_acr.dat_vencto_tit_acr
           tt_rpt_tit_acr_destinac.tta_dat_emis_docto      = tit_acr.dat_emis_docto
           tt_rpt_tit_acr_destinac.tta_val_sdo_tit_acr     = tit_acr.val_sdo_tit_acr
           tt_rpt_tit_acr_destinac.tta_cod_portador        = tit_acr.cod_portador
           tt_rpt_tit_acr_destinac.tta_cod_cart_bcia       = tit_acr.cod_cart_bcia
           tt_rpt_tit_acr_destinac.tta_num_dwb_order       = 99
           .
    assign tt_rpt_tit_acr_destinac.ttv_des_obs_campo       = getStrTrans("N∆o atendeu Ö destinaá∆o de cobranca.", "ACR") /*3380*/
           tt_rpt_tit_acr_destinac.ttv_log_selec_tit_acr   = yes
           tt_rpt_tit_acr_destinac.ttv_log_elimina         = yes
           tt_rpt_tit_acr_destinac.tta_cdn_repres          = tit_acr.cdn_repres
           tt_rpt_tit_acr_destinac.tta_ind_ender_cobr      = tit_acr.ind_ender_cobr
           tt_rpt_tit_acr_destinac.tta_nom_abrev_contat    = tit_acr.nom_abrev_contat
           tt_rpt_tit_acr_destinac.tta_nom_cidade          = v_nom_cidade.

    if  v_ind_tip_destinac = "Listagem de T°tulos a Destinar" /*l_listagem_de_titulos_a_destinar*/  then
        assign tt_rpt_tit_acr_destinac.tta_num_dwb_order = 1.

    /* ==> MODULO VENDOR <== */    
    if  v_log_modul_vendor 
    and tit_acr.ind_tip_espec_docto = "Normal" /*l_normal*/  then do : 
        assign v_log_tit_vendor = no.
        /* ** Verifica se o t°tulo possui relacionamento com o vendor ***/
        run pi_verificar_registro_vendor IN v_hdl_api_centraliz_acr_vdr
                                        (input tit_acr.cod_estab,
                                         input tit_acr.num_id_tit_acr,
                                         input "",
                                         input 0,
                                         output v_log_tit_vendor).
        if  v_log_tit_vendor then do:
            /* ** Ir† armazenar se o t°tulo tem informaá‰es vendor associada ***/
            find tt_recid
                 where tt_recid.ttv_rec_table = v_rec_tit_acr
                 no-error.
            if  not avail tt_recid then do:
                create tt_recid.
                assign tt_recid.ttv_rec_table = v_rec_tit_acr.
            end.
        end.
    end.

    return "OK" /*l_ok*/ .

END PROCEDURE. /* pi_tratar_tt_rpt_tit_acr_destinac */
/*****************************************************************************
** Procedure Interna.....: pi_atualizar_dados_portad_destinac
** Descricao.............: pi_atualizar_dados_portad_destinac
** Criado por............: Alexsandra
** Criado em.............: 23/10/1996 13:34:58
** Alterado por..........: adilsonhaut
** Alterado em...........: 07/04/2020 10:04:37
*****************************************************************************/
PROCEDURE pi_atualizar_dados_portad_destinac:

    /************************* Variable Definition Begin ************************/

    def var v_dat_return
        as date
        format "99/99/9999":U
        no-undo.


    /************************** Variable Definition End *************************/

    if  param_estab_acr.log_consid_float_cobr = yes
    or  (param_estab_acr.log_consid_atraso_med_clien = yes
    and  tit_acr.ind_tip_espec_docto <> "Antecipaá∆o" /*l_antecipacao*/  
    and  tit_acr.ind_tip_espec_docto <> "Nota de CrÇdito" /*l_nota_de_credito*/  
    and  tit_acr.ind_tip_espec_docto <> "Nota de DÇbito" /*l_nota_de_debito*/ )
    then do:
        run pi_retornar_dia_util (Input tit_acr.cod_estab,
                                  Input "Respons†vel Financeiro" /*l_financeiro*/ ,
                                  Input 0,
                                  Input tit_acr.dat_prev_liquidac,
                                  output v_dat_return,
                                  output v_cod_return).
        if entry(1, v_cod_return) <> "OK" /*l_ok*/   then 
           assign v_dat_fluxo = tit_acr.dat_prev_liquidac.
        else
           assign v_dat_fluxo = v_dat_return.

        if  tit_acr.ind_tip_espec_docto <> "Antecipaá∆o" /*l_antecipacao*/  
        and tit_acr.ind_tip_espec_docto <> "Nota de CrÇdito" /*l_nota_de_credito*/  
        and tit_acr.ind_tip_espec_docto <> "Nota de DÇbito" /*l_nota_de_debito*/ 
        and param_estab_acr.log_consid_atraso_med_clien then do:
            run pi_retorna_atraso_med_clien (input tit_acr.cod_empresa,
                                             input tit_acr.cdn_cliente,
                                             output v_val_atraso_med_clien).
            assign v_dat_fluxo = v_dat_fluxo + v_val_atraso_med_clien.

            run pi_retornar_dia_util (Input tit_acr.cod_estab,
                                      Input "Respons†vel Financeiro" /*l_financeiro*/ ,
                                      Input 0,
                                      Input v_dat_fluxo,
                                      output v_dat_return,
                                      output v_cod_return).
            if entry(1, v_cod_return) = "OK" /*l_ok*/  then
                assign v_dat_fluxo = v_dat_return.              
        end.                                          

        if param_estab_acr.log_consid_float_cobr then do:
            find tt_portad_bco no-lock
                where tt_portad_bco.cod_estab = tit_acr.cod_estab
                  and tt_portad_bco.cod_portador = tit_acr.cod_portador
                  and tt_portad_bco.cod_cart_bcia = tit_acr.cod_cart_bcia
                  and tt_portad_bco.cod_finalid_econ = destinac_cobr.cod_finalid_econ
                no-error.
            if  avail tt_portad_bco
            then do:
                if  tt_portad_bco.qtd_dias_float_cobr > 0
                then do:
                    run prgfin/acr/acr792za.py (Input tit_acr.cod_estab,
                                                input-output v_dat_fluxo,
                                                Input tt_portad_bco.qtd_dias_float_cobr) /*prg_fnc_tit_acr_dat_fluxo*/.
                end /* if */.
            end /* if */.
        end.
        assign tit_acr.dat_fluxo_tit_acr = v_dat_fluxo.
    end /* if */.

END PROCEDURE. /* pi_atualizar_dados_portad_destinac */
/*****************************************************************************
** Procedure Interna.....: pi_tratar_endereco_cobr
** Descricao.............: pi_tratar_endereco_cobr
** Criado por............: Alexsandra
** Criado em.............: 16/09/1996 19:18:45
** Alterado por..........: corp45598
** Alterado em...........: 29/05/2013 14:45:07
*****************************************************************************/
PROCEDURE pi_tratar_endereco_cobr:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cdn_cliente
        as Integer
        format ">>>,>>>,>>9"
        no-undo.
    def Input param p_cod_empresa
        as character
        format "x(3)"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_num_pessoa_fisic
        as integer
        format ">>>,>>>,>>9":U
        label "Pessoa F°sica"
        column-label "Pessoa F°sica"
        no-undo.


    /************************** Variable Definition End *************************/

    find cliente no-lock
        where cliente.cod_empresa = p_cod_empresa
          and cliente.cdn_cliente = p_cdn_cliente
          no-error.
    if avail cliente then do:
        if  cliente.num_pessoa mod 2 = 0
        then do:
            find pessoa_fisic no-lock
                where pessoa_fisic.num_pessoa_fisic = cliente.num_pessoa
                no-error.
            if  avail pessoa_fisic
            then do:
                find pais no-lock
                    where pais.cod_pais = pessoa_fisic.cod_pais
                    no-error.
                if  v_log_pessoa_fisic_cobr
                then do:
                    if  v_ind_ender_complet = "Endereáo" /*l_Endereáo*/ 
                    then do:
                      &if '{&emsfin_version}' >= '5.07' &then
                         if  pessoa_fisic.nom_ender_cobr = ""
                         then do:
                      &else
                         find first tab_livre_emsuni no-lock
                              where tab_livre_emsuni.cod_modul_dtsul      = "utb" /*l_utb*/ 
                                and tab_livre_emsuni.cod_tab_dic_dtsul    = 'pessoa_fisic':U
                                and tab_livre_emsuni.cod_compon_1_idx_tab = STRING(0)
                                and tab_livre_emsuni.cod_compon_2_idx_tab = STRING(pessoa_fisic.num_pessoa_fisic) no-error.
                         if not avail tab_livre_emsuni then do:
                              find first tab_livre_emsuni no-lock
                                   where tab_livre_emsuni.cod_modul_dtsul      = "utb" /*l_utb*/ 
                                     and tab_livre_emsuni.cod_tab_dic_dtsul    = 'pessoa_fisic':U
                                     and tab_livre_emsuni.cod_compon_2_idx_tab = STRING(pessoa_fisic.num_pessoa_fisic) no-error.                                                   
                         end.              
                         if  (avail tab_livre_emsuni and (GetEntryField(4, tab_livre_emsuni.cod_livre_1, chr(10))) = "") or
                             not avail tab_livre_emsuni
                         then do:
                      &endif
                            run pi_vrf_nom_ender_cobr_fisic_1. /* nova PI*/
                        end.
                        else do:
                            run pi_vrf_nom_ender_cobr_fisic. /* nova PI*/
                        end.
                    end.
                    else do:
                        &if defined(BF_FIN_4LINHAS_END) &then
                          &if '{&emsfin_version}' >= '5.07' &then
                            if  pessoa_fisic.nom_ender_cobr_text = ""
                            then do:
                          &else
                            find first tab_livre_emsuni no-lock
                                 where tab_livre_emsuni.cod_modul_dtsul      = "utb" /*l_utb*/ 
                                   and tab_livre_emsuni.cod_tab_dic_dtsul    = 'pessoa_fisic':U
                                   and tab_livre_emsuni.cod_compon_1_idx_tab = STRING(0)
                                   and tab_livre_emsuni.cod_compon_2_idx_tab = STRING(pessoa_fisic.num_pessoa_fisic) no-error.
                            if not avail tab_livre_emsuni then do:
                                 find first tab_livre_emsuni no-lock
                                      where tab_livre_emsuni.cod_modul_dtsul      = "utb" /*l_utb*/ 
                                        and tab_livre_emsuni.cod_tab_dic_dtsul    = 'pessoa_fisic':U
                                        and tab_livre_emsuni.cod_compon_2_idx_tab = STRING(pessoa_fisic.num_pessoa_fisic) no-error.                                                   
                            end.        
                            if  avail tab_livre_emsuni and (GetEntryField(4, tab_livre_emsuni.cod_livre_1, chr(10))) = ""
                            then do:
                          &endif                    
                                run pi_vrf_nom_ender_cobr_fisic_1. /* nova PI*/
                            end.
                            else do:
                                run pi_vrf_nom_ender_cobr_fisic. /* nova PI*/
                            end.
                        &endif
                    end.
                end /* if */.
                else do:
                    run pi_vrf_nom_ender_cobr_fisic_1. /* nova PI*/ 
                end.
            end /* if */.
        end /* if */.
        else do:
            find pessoa_jurid no-lock
                where pessoa_jurid.num_pessoa_jurid = cliente.num_pessoa
                no-error.
            if  avail pessoa_jurid
                and pessoa_jurid.num_pessoa_jurid_cobr <> pessoa_jurid.num_pessoa_jurid
                and pessoa_jurid.num_pessoa_jurid_cobr <> ?
                and pessoa_jurid.num_pessoa_jurid_cobr <> 0
            then do:
                assign v_num_pessoa_jurid = pessoa_jurid.num_pessoa_jurid_cobr.
                find pessoa_jurid no-lock
                    where pessoa_jurid.num_pessoa_jurid = v_num_pessoa_jurid
                    no-error.
            end /* if */.
            if  avail pessoa_jurid
            then do:
                find pais no-lock
                    where pais.cod_pais = pessoa_jurid.cod_pais
                    no-error.
                if  v_ind_ender_complet = "Endereáo" /*l_endereco*/  then do:
                    if  pessoa_jurid.nom_ender_cobr = ""
                    then do:
                        run pi_vrf_nom_ender_cobr /*pi_vrf_nom_ender_cobr*/.
                    end /* if */.
                    else do:
                        run pi_vrf_nom_ender_cobr_1 /*pi_vrf_nom_ender_cobr_1*/.
                    end /* else */.
                end.
                else do:
                    &if defined(BF_FIN_4LINHAS_END) &then
                        if  pessoa_jurid.nom_ender_cobr_text = ""
                        then do:
                            run pi_vrf_nom_ender_cobr /*pi_vrf_nom_ender_cobr*/.
                        end /* if */.
                        else do:
                            run pi_vrf_nom_ender_cobr_1 /*pi_vrf_nom_ender_cobr_1*/.
                        end /* else */.
                    &endif
                end.
            end /* if */.
        end /* else */.
    end.
END PROCEDURE. /* pi_tratar_endereco_cobr */
/*****************************************************************************
** Procedure Interna.....: pi_executar_tit_acr_destinac
** Descricao.............: pi_executar_tit_acr_destinac
** Criado por............: Alexsandra
** Criado em.............: 20/09/1996 08:57:56
** Alterado por..........: fut12235
** Alterado em...........: 02/11/2021 13:41:49
*****************************************************************************/
PROCEDURE pi_executar_tit_acr_destinac:

    /************************** Buffer Definition Begin *************************/

    def buffer btt_rpt_tit_acr_destinac
        for tt_rpt_tit_acr_destinac.
    &if "{&emsfin_version}" >= "5.01" &then
    def buffer b_portador
        for emscad.portador.
    &endif


    /*************************** Buffer Definition End **************************/

    /************************* Variable Definition Begin ************************/

    def var v_cod_portad_prefer
        as character
        format "x(5)":U
        label "Portador Preferenc"
        column-label "Port Preferenc"
        no-undo.
    def var v_dsl_msg_rpt                    as character       no-undo. /*local*/
    def var v_log_meta_complet               as logical         no-undo. /*local*/
    def var v_log_validac_bco                as logical         no-undo. /*local*/
    def var v_val_cobr                       as decimal         no-undo. /*local*/


    /************************** Variable Definition End *************************/

    find tit_acr no-lock
        where recid( tit_acr ) = tt_rpt_tit_acr_destinac.ttv_rec_tit_acr no-error.

    assign v_cod_portador    = tit_acr.cod_portador
           v_cod_cart_bcia_1 = tit_acr.cod_cart_bcia.

    /* ==> MODULO VENDOR <== */
    /* ** Verifica se o t°tulo possui informaá‰es vendor ***/
    find tt_recid 
        where tt_recid.ttv_rec_table = recid(tit_acr)
        no-error.
    assign v_log_tit_vendor = no.
    if  avail tt_recid then 
         assign v_log_tit_vendor = yes.

    if  not v_log_destinac_tit_vencid then do:
        /* TITULOS VENCIDOS - NAO PRECISA PROCESSAR */
        /* quando a funá∆o para destinaá∆o de t°tulos vencidos estiver liberada, poder†
           ser informado, no portad_bco, numero m°nimo de dias para envio negativo,
           permitindo desta forma enviar t°tulos vencidos  */

        if  (tit_acr.dat_vencto_tit_acr - v_dat_destinac < 0) then do:
             run pi_atualiza_tabelas_destinac (Input no,
                                               input "",
                                               Input "",
                                               Input getStrTrans("Titulo vencido, n∆o ser† destinado.", "ACR") /*8500*/,
                                               Input 0,
                                               Input 99) /*pi_atualiza_tabelas_destinac*/.
             return.
        end.
    end.

    if  v_log_verifica_praz_auto_emis then do:

        /* ** Caso a Carteira seja vendor o t°tulo deve possuir as Informaá‰es Vendor ***/
        assign v_log_destinac = yes 
               v_log_cart_bcia_vendor = no.

        if  can-find(cart_bcia 
               where cart_bcia.cod_cart_bcia = destinac_cobr.cod_cart_bcia_auto_emis
               and   cart_bcia.ind_tip_cart_bcia = "Vendor" /*l_vendor*/ ) then 
            assign v_log_cart_bcia_vendor = yes.

        if  v_log_tit_vendor = no
        and v_log_cart_bcia_vendor = yes then 
            assign v_log_destinac = no.

        /* ** Caso a Carteira seja Descontada ser† barrada a destinaá∆o ***/
        if can-find(cart_bcia 
              where cart_bcia.cod_cart_bcia = destinac_cobr.cod_cart_bcia_auto_emis
              and   cart_bcia.ind_tip_cart_bcia = "Desconto" /*l_desconto*/ ) then do:
            run pi_atualiza_tabelas_destinac (Input no,
                                              input destinac_cobr.cod_portad_auto_emis,
                                              Input destinac_cobr.cod_cart_bcia_auto_emis,
                                              Input getStrTrans("T°tulo n∆o pode ser destinado para uma carteira Desconto !", "ACR") /*19520*/,
                                              Input 0,
                                              Input 99) /*pi_atualiza_tabelas_destinac*/.
            return.
        end.          

        if  v_log_destinac then do:


           /* Begin_Include: i_valida_portad_auto_emissao_cobr_pix */
           &if defined(BF_FIN_PIX_3_FLEXIBILIZA) &then
           if  v_log_cobr_acr_pix
           then do:

              if  not can-find(first portad_edi
                               where portad_edi.cod_modul_dtsul  = "ACR" /*l_acr*/ 
                                 and portad_edi.cod_estab        = tit_acr.cod_estab
                                 and portad_edi.cod_portador     = destinac_cobr.cod_portad_auto_emis
                                 and portad_edi.cod_cart_bcia    = destinac_cobr.cod_cart_bcia_auto_emis
                                 and portad_edi.log_cobr_acr_pix = yes)
              then do:

                  assign v_dsl_msg_rpt = substitute(getStrTrans("O Portador Auto Emiss∆o &1 relacionado a Regra de Destinaá∆o &2 n∆o Ç v†lido. Esta Regra Ç para Cobranáa &3 e faz-se necess†rio que o Portador EDI tambÇm esteja coerente com esta modalidade de Cobranáa. Informe um Portador Auto Emiss∆o v†lido nos ParÉmetros Destinaá∆o de Cobranáa ou modifique o cadastro Portador EDI e &4 o parÉmetro Cobranáa PIX para o atual Portador Auto Emiss∆o: M¢dulo: ACR / Estab: &5 / Portador: &1 / Carteira: &6", "ACR") /*23393*/,
                                                    destinac_cobr.cod_portad_auto_emis, 
                                                    v_cod_destinac_cobr, 
                                                    getStrTrans("PIX", "ACR") /*l_pix*/ ,
                                                    'marque',
                                                    tit_acr.cod_estab,
                                                    destinac_cobr.cod_cart_bcia_auto_emis).              

                  run pi_atualiza_tabelas_destinac (Input no,
                                                    input destinac_cobr.cod_portad_auto_emis,
                                                    Input destinac_cobr.cod_cart_bcia_auto_emis,
                                                    Input v_dsl_msg_rpt,
                                                    Input 0,
                                                    Input 99) /*pi_atualiza_tabelas_destinac*/.
                  return "NOK" /*l_nok*/ .
               end /* if */.
           end /* if */.
           else do:    
               find first portador no-lock                                                   
                    where portador.cod_portador    = destinac_cobr.cod_portad_auto_emis  
                      and portador.ind_tip_portad <> "Caixa" /*l_caixa*/  no-error.      
               if avail portador then do:        
                   if  v_cod_pais_empres_usuar = "BRA" /*l_bra*/ 
                   and not can-find(first portad_edi
                                    where portad_edi.cod_modul_dtsul  = "ACR" /*l_acr*/ 
                                      and portad_edi.cod_estab        = tit_acr.cod_estab
                                      and portad_edi.cod_portador     = destinac_cobr.cod_portad_auto_emis
                                      and portad_edi.cod_cart_bcia    = destinac_cobr.cod_cart_bcia_auto_emis
                                      and (portad_edi.log_cobr_acr_pix = no
                                       or portad_edi.log_cobr_acr_pix = ?))
                   then do:

                      assign v_dsl_msg_rpt = substitute(getStrTrans("O Portador Auto Emiss∆o &1 relacionado a Regra de Destinaá∆o &2 n∆o Ç v†lido. Esta Regra Ç para Cobranáa &3 e faz-se necess†rio que o Portador EDI tambÇm esteja coerente com esta modalidade de Cobranáa. Informe um Portador Auto Emiss∆o v†lido nos ParÉmetros Destinaá∆o de Cobranáa ou modifique o cadastro Portador EDI e &4 o parÉmetro Cobranáa PIX para o atual Portador Auto Emiss∆o: M¢dulo: ACR / Estab: &5 / Portador: &1 / Carteira: &6", "ACR") /*23393*/,
                                                        destinac_cobr.cod_portad_auto_emis, 
                                                        v_cod_destinac_cobr, 
                                                        getStrTrans("Normal", "ACR") /*l_normal*/ ,
                                                        'desmarque',
                                                        tit_acr.cod_estab,
                                                        destinac_cobr.cod_cart_bcia_auto_emis).               

                      run pi_atualiza_tabelas_destinac (Input no,
                                                        input destinac_cobr.cod_portad_auto_emis,
                                                        Input destinac_cobr.cod_cart_bcia_auto_emis,
                                                        Input v_dsl_msg_rpt,
                                                        Input 0,
                                                        Input 99) /*pi_atualiza_tabelas_destinac*/.
                      return "NOK" /*l_nok*/ .
                   end /* if */.
               end.
           end /* else */.
           &endif
           /* End_Include: i_valida_portad_auto_emissao_cobr_pix */


           if  tit_acr.dat_vencto_tit_acr - v_dat_destinac >= 0
           and tit_acr.dat_vencto_tit_acr - v_dat_destinac <= destinac_cobr.qti_dias_auto_emis
           then do:
               find first tt_portad_fe_param_estab no-lock
                    where tt_portad_fe_param_estab.tta_cod_estab        = tit_acr.cod_estab
                      and tt_portad_fe_param_estab.tta_cod_portador     = destinac_cobr.cod_portad_auto_emis
                      and tt_portad_fe_param_estab.tta_cod_finalid_econ = destinac_cobr.cod_finalid_econ
                      and tt_portad_fe_param_estab.tta_cod_cart_bcia    = destinac_cobr.cod_cart_bcia_auto_emis no-error.
               if avail tt_portad_fe_param_estab then do:
                  assign v_des_mensagem = "".
                  /* ** N∆o Ç possivel enviar t°tulos de carteira vendor via EDI ***/
                  if  destinac_cobr.log_envio_via_edi = yes and v_log_cart_bcia_vendor = no then do:
                      run pi_validar_envio_edi_destinacao (Input tit_acr.cod_estab,
                                                           Input destinac_cobr.cod_portad_auto_emis,
                                                           Input destinac_cobr.cod_cart_bcia_auto_emis,
                                                           Input tit_acr.cod_indic_econ,
                                                           Input tit_acr.dat_emis_docto,
                                                           output v_des_mensagem) /*pi_validar_envio_edi_destinacao*/.
                  end.
                  if  v_des_mensagem = "" then do:
                      run pi_atualiza_tabelas_destinac (Input yes,
                                                        input destinac_cobr.cod_portad_auto_emis,
                                                        Input destinac_cobr.cod_cart_bcia_auto_emis,
                                                        Input getStrTrans("T°tulo no prazo de auto-emiss∆o.", "ACR") /*3287*/,
                                                        Input 0,
                                                        Input 2) /*pi_atualiza_tabelas_destinac*/.
                      return.
                  end.
                  else do:
                      run pi_atualiza_tabelas_destinac (Input no,
                                                        input destinac_cobr.cod_portad_auto_emis,
                                                        Input destinac_cobr.cod_cart_bcia_auto_emis,
                                                        Input v_des_mensagem,
                                                        Input 0,
                                                        Input 99) /*pi_atualiza_tabelas_destinac*/.
                  end. 
               end.
               else do: 
                  run pi_atualiza_tabelas_destinac (Input no,
                                                    input destinac_cobr.cod_portad_auto_emis,
                                                    Input destinac_cobr.cod_cart_bcia_auto_emis,
                                                    Input "Portador de Auto Emiss∆o:" /*l_portad_auto_emis*/  + " " + getStrTrans("N∆o existe Portador Finalidade Econìmica ou ParÉmetros do Estabelecimento ACR!", "ACR") /*7433*/,
                                                    Input 0,
                                                    Input 99) /*pi_atualiza_tabelas_destinac*/.
                  return.
               end.
           end /* if */.
       end /* if */.
    end.   

    assign v_cod_portad_prefer = "".

    find first btt_rpt_tit_acr_destinac no-lock
         where btt_rpt_tit_acr_destinac.tta_cdn_cliente = tit_acr.cdn_cliente no-error.
    if  avail btt_rpt_tit_acr_destinac
    and btt_rpt_tit_acr_destinac.tta_cod_portad_prefer <> ""
    then do:
       assign v_cod_portad_prefer = btt_rpt_tit_acr_destinac.tta_cod_portad_prefer.
    end /* if */.
    else do:
        find clien_financ no-lock
             where clien_financ.cod_empresa = tit_acr.cod_empresa
               and clien_financ.cdn_cliente = tit_acr.cdn_cliente no-error.
        if  clien_financ.cod_portad_prefer = ""
        then do:
           assign v_cod_portad_prefer                            = "inexistente" /*l_inexistente*/ 
                  btt_rpt_tit_acr_destinac.tta_cod_portad_prefer = "inexistente" /*l_inexistente*/ .
        end /* if */.
        else do:
           assign v_cod_portad_prefer                            = clien_financ.cod_portad_prefer
                  btt_rpt_tit_acr_destinac.tta_cod_portad_prefer = clien_financ.cod_portad_prefer.
        end /* else */.
    end /* else */.

    if  v_cod_portad_prefer <> "inexistente" /*l_inexistente*/ 
    then do:
        run pi_buscar_cart_bcia_portad_prefer (input v_cod_portad_prefer).

        /* ** Caso a Carteira seja vendor o t°tulo deve possuir as Informaá‰es Vendor ***/
        assign v_log_destinac = yes 
               v_log_cart_bcia_vendor = no.

        if  can-find(cart_bcia 
               where cart_bcia.cod_cart_bcia = v_cod_cart_bcia_portad_prefer
               and   cart_bcia.ind_tip_cart_bcia = "Vendor" /*l_vendor*/ ) then 
            assign v_log_cart_bcia_vendor = yes.

        if  v_log_tit_vendor = no
        and v_log_cart_bcia_vendor = yes then 
            assign v_log_destinac = no.

        /* ** Caso a Carteira seja Descontada ser† barrada a destinaá∆o ***/
        if can-find(cart_bcia 
              where cart_bcia.cod_cart_bcia = v_cod_cart_bcia_portad_prefer
              and   cart_bcia.ind_tip_cart_bcia = "Desconto" /*l_desconto*/ ) then do:
            run pi_atualiza_tabelas_destinac (Input no,
                                              input v_cod_portad_prefer,
                                              Input v_cod_cart_bcia_portad_prefer,
                                              Input getStrTrans("T°tulo n∆o pode ser destinado para uma carteira Desconto !", "ACR") /*19520*/,
                                              Input 0,
                                              Input 99) /*pi_atualiza_tabelas_destinac*/.
            return.
        end.

        if  v_log_destinac then do:    

            /* Begin_Include: i_valida_portad_preferencial_cobr_pix */
            &if defined(BF_FIN_PIX_3_FLEXIBILIZA) &then
            if  v_log_cobr_acr_pix
            then do:
               if  not can-find(first portad_edi
                                where portad_edi.cod_modul_dtsul  = "ACR" /*l_acr*/ 
                                  and portad_edi.cod_estab        = tit_acr.cod_estab
                                  and portad_edi.cod_portador     = v_cod_portad_prefer
                                  and portad_edi.cod_cart_bcia    = v_cod_cart_bcia_portad_prefer
                                  and portad_edi.log_cobr_acr_pix = yes)
               then do:

                   assign v_dsl_msg_rpt = substitute(getStrTrans("O Portador Preferencial &1 relacionado a Regra de Destinaá∆o &2 n∆o Ç v†lido. Esta Regra Ç para Cobranáa &3 e faz-se necess†rio que o Portador EDI tambÇm esteja coerente com esta modalidade de Cobranáa. Informe um Portador Preferencial v†lido na Manutená∆o Cliente Financeiro ou modifique o cadastro Portador EDI e &4 o parÉmetro Cobranáa PIX para o atual Portador Preferencial: M¢dulo: ACR / Estab: &5 / Portador: &1 / Carteira: &6.", "ACR") /*23394*/,
                                                     v_cod_portad_prefer, 
                                                     v_cod_destinac_cobr, 
                                                     getStrTrans("PIX", "ACR") /*l_pix*/ ,
                                                     'marque',
                                                     tit_acr.cod_estab,
                                                     v_cod_cart_bcia_portad_prefer).               

                   run pi_atualiza_tabelas_destinac (Input no,
                                                     input v_cod_portad_prefer,
                                                     Input v_cod_cart_bcia_portad_prefer,
                                                     Input v_dsl_msg_rpt,
                                                     Input 0,
                                                     Input 99) /*pi_atualiza_tabelas_destinac*/.
                   return "NOK" /*l_nok*/ .
                end /* if */.
            end /* if */.
            else do:
                find first portador no-lock                                             
                     where portador.cod_portador    = v_cod_portad_prefer
                       and portador.ind_tip_portad <> "Caixa" /*l_caixa*/  no-error.    
                if avail portador then do:
                    if  v_cod_pais_empres_usuar = "BRA" /*l_bra*/ 
                    and not can-find(first portad_edi
                                     where portad_edi.cod_modul_dtsul  = "ACR" /*l_acr*/ 
                                       and portad_edi.cod_estab        = tit_acr.cod_estab
                                       and portad_edi.cod_portador     = v_cod_portad_prefer
                                       and portad_edi.cod_cart_bcia    = v_cod_cart_bcia_portad_prefer
                                       and (portad_edi.log_cobr_acr_pix = no
                                        or portad_edi.log_cobr_acr_pix = ?))
                    then do:

                        assign v_dsl_msg_rpt = substitute(getStrTrans("O Portador Preferencial &1 relacionado a Regra de Destinaá∆o &2 n∆o Ç v†lido. Esta Regra Ç para Cobranáa &3 e faz-se necess†rio que o Portador EDI tambÇm esteja coerente com esta modalidade de Cobranáa. Informe um Portador Preferencial v†lido na Manutená∆o Cliente Financeiro ou modifique o cadastro Portador EDI e &4 o parÉmetro Cobranáa PIX para o atual Portador Preferencial: M¢dulo: ACR / Estab: &5 / Portador: &1 / Carteira: &6.", "ACR") /*23394*/,
                                                          v_cod_portad_prefer, 
                                                          v_cod_destinac_cobr, 
                                                          getStrTrans("Normal", "ACR") /*l_normal*/ ,
                                                          'desmarque',
                                                          tit_acr.cod_estab,
                                                          v_cod_cart_bcia_portad_prefer).               

                        run pi_atualiza_tabelas_destinac (Input no,
                                                          input v_cod_portad_prefer,
                                                          Input v_cod_cart_bcia_portad_prefer,
                                                          Input v_dsl_msg_rpt,
                                                          Input 0,
                                                          Input 99) /*pi_atualiza_tabelas_destinac*/.
                        return "NOK" /*l_nok*/ .                              
                    end /* if */.       
                end.    
            end /* else */.    
            &endif
            /* End_Include: i_valida_portad_preferencial_cobr_pix */


            find first tt_portad_fe_param_estab no-lock
                where tt_portad_fe_param_estab.tta_cod_estab        = tit_acr.cod_estab
                  and tt_portad_fe_param_estab.tta_cod_portador     = v_cod_portad_prefer
                  and tt_portad_fe_param_estab.tta_cod_finalid_econ = destinac_cobr.cod_finalid_econ
                  and tt_portad_fe_param_estab.tta_cod_cart_bcia    = v_cod_cart_bcia_portad_prefer no-error.
            if avail tt_portad_fe_param_estab then do:
                assign tt_rpt_tit_acr_destinac.tta_cod_portad_prefer = v_cod_portad_prefer.

                /* **Posiciona tt_portad_finalid_econ para verificaá∆o de validaá∆o de CEP.***/
                find tt_portad_finalid_econ
                    where tt_portad_finalid_econ.tta_cod_portador     = v_cod_portad_prefer
                      and tt_portad_finalid_econ.tta_cod_cart_bcia    = v_cod_cart_bcia_portad_prefer
                      and tt_portad_finalid_econ.tta_cod_finalid_econ = destinac_cobr.cod_finalid_econ
                    no-error.
                /* Ref a FO2210534 Pimp∆o*/
                if not avail tt_portad_finalid_econ then do:
                   assign v_dsl_msg_rpt = substitute(getStrTrans("N∆o encontrado Portador &1 para Carteira &2, Finalidade Econìmica &3 e Estabelecimento &4 na Manutená∆o de Finalidade Econìmica do Portador.", "ACR") /*20387*/,
                                                     v_cod_portad_prefer, 
                                                     v_cod_cart_bcia_portad_prefer, 
                                                     destinac_cobr.cod_finalid_econ,
                                                     tit_acr.cod_estab).

                   run pi_atualiza_tabelas_destinac (Input no,
                                                     input v_cod_portad_prefer,
                                                     Input v_cod_cart_bcia_portad_prefer,
                                                     Input v_dsl_msg_rpt,
                                                     Input 0,
                                                     Input 99) /* pi_atualiza_tabelas_destinac*/.
                   return.           
                end.
                find b_portador no-lock
                    where b_portador.cod_portador = v_cod_portad_prefer no-error.
                if b_portador.cod_banco <> "" then
                    find banco no-lock
                        where banco.cod_banco = b_portador.cod_banco no-error.

                run pi_verificar_portad_bco_tt (Input "ACR" /*l_acr*/,
                                                Input tit_acr.cod_estab,
                                                Input v_cod_portad_prefer,
                                                Input v_cod_cart_bcia_portad_prefer,
                                                Input destinac_cobr.cod_finalid_econ,
                                                Input tit_acr.dat_vencto_tit_acr,
                                                Input tit_acr.val_sdo_tit_acr,
                                                output v_des_mensagem) /*pi_verificar_portad_bco_tt*/.
                if return-value = "NOK" /*l_nok*/ 
                    then assign v_log_validac_bco = no.
                    else assign v_log_validac_bco = yes.

                if  return-value <> "NOK" /*l_nok*/ 
                    or (v_des_mensagem = getStrTrans("Data menor que prazo de envio.", "ACR") /*3266*/
                    and tt_portad_finalid_econ.tta_log_validac_cep_destinac = yes)
                then do:

                    if  tt_portad_finalid_econ.tta_log_validac_cep_destinac = yes then do:
                        run pi_valida_cep_agencia_destinac_cobr (input v_log_validac_bco, input b_portador.cod_banco).
                        if return-value <> "OK" /*l_ok*/  then do:
                            run pi_atualiza_tabelas_destinac (Input no,
                                                              input v_cod_portad_prefer,
                                                              Input v_cod_cart_bcia_portad_prefer,
                                                              Input "Portador Preferencial." /*l_portador_preferencial*/  + " " + v_des_mensagem,
                                                              Input 0,
                                                              Input 99) /*pi_atualiza_tabelas_destinac*/.
                            return.
                        end.
                    end.
                    /* ** N∆o Ç possivel enviar t°tulos de carteira vendor via EDI ***/
                    if  destinac_cobr.log_envio_via_edi = yes and v_log_cart_bcia_vendor = no then do:
                        run pi_validar_envio_edi_destinacao (Input tit_acr.cod_estab,
                                                             Input v_cod_portad_prefer,
                                                             Input v_cod_cart_bcia_portad_prefer,
                                                             Input tit_acr.cod_indic_econ,
                                                             Input tit_acr.dat_emis_docto,
                                                             output v_des_mensagem) /*pi_validar_envio_edi_destinacao*/.
                        if  v_des_mensagem <> "" then do:
                            run pi_atualiza_tabelas_destinac (Input no,
                                                              input v_cod_portad_prefer,
                                                              Input v_cod_cart_bcia_portad_prefer,
                                                              Input "Portador Preferencial." /*l_portador_preferencial*/  + " " + v_des_mensagem,
                                                              Input 0,
                                                              Input 99) /*pi_atualiza_tabelas_destinac*/.
                            return.
                        end.
                    end.
                    run pi_atualiza_tabelas_destinac (Input yes,
                                                      input v_cod_portad_prefer,
                                                      Input v_cod_cart_bcia_portad_prefer,
                                                      Input "Portador Preferencial." /*l_portador_preferencial*/,
                                                      Input 0,
                                                      Input 1) /*pi_atualiza_tabelas_destinac*/.
                end.
                else do:
                    run pi_atualiza_tabelas_destinac (Input no,
                                                      input v_cod_portad_prefer,
                                                      Input v_cod_cart_bcia_portad_prefer,
                                                      Input "Portador Preferencial." /*l_portador_preferencial*/  + " " + v_des_mensagem,
                                                      Input 0,
                                                      Input 99) /*pi_atualiza_tabelas_destinac*/.
                end.
            end.
            else
                run pi_atualiza_tabelas_destinac (Input no,
                                                  input v_cod_portad_prefer,
                                                  Input v_cod_cart_bcia_portad_prefer,
                                                  Input "Portador Preferencial:" /*l_portad_prefer*/  + " " + getStrTrans("N∆o existe Portador Finalidade Econìmica ou ParÉmetros do Estabelecimento ACR!", "ACR") /*7433*/,
                                                  Input 0,
                                                  Input 99) /*pi_atualiza_tabelas_destinac*/.
            return.
        end /* if */.        
    end /* if */.

    table_child:
    for
    each tt_item_destinac_cobr_dest: 


        /* Begin_Include: i_valida_portad_item_destinac_cobr_pix */
        &if defined(BF_FIN_PIX_3_FLEXIBILIZA) &then
        if  v_log_cobr_acr_pix
        then do:

           if  not can-find(first portad_edi
                            where portad_edi.cod_modul_dtsul  = "ACR" /*l_acr*/ 
                              and portad_edi.cod_estab        = tit_acr.cod_estab
                              and portad_edi.cod_portador     = tt_item_destinac_cobr_dest.cod_portador
                              and portad_edi.cod_cart_bcia    = tt_item_destinac_cobr_dest.cod_cart_bcia
                              and portad_edi.log_cobr_acr_pix = yes)
           then do:

               assign v_dsl_msg_rpt = substitute(getStrTrans("O Portador Item Destinaá∆o &1 relacionado a Regra de Destinaá∆o &2 n∆o Ç v†lido. Esta Regra Ç para Cobranáa &3 e faz-se necess†rio que o Portador EDI tambÇm esteja coerente com esta modalidade de Cobranáa. Relacione um Portador Item Destinaá∆o v†lido aos ParÉmetros Destinaá∆o de Cobranáa ou modifique o cadastro Portador EDI e &4 o parÉmetro Cobranáa PIX para o atual Portador da Regra: M¢dulo: ACR / Estab: &5 / Portador: &1 / Carteira: &6 .", "ACR") /*23396*/,
                                                 tt_item_destinac_cobr_dest.cod_portador, 
                                                 v_cod_destinac_cobr, 
                                                 getStrTrans("PIX", "ACR") /*l_pix*/ ,
                                                 'marque',
                                                 tit_acr.cod_estab,
                                                 tt_item_destinac_cobr_dest.cod_cart_bcia).              

               run pi_atualiza_tabelas_destinac (Input no,
                                                 input tt_item_destinac_cobr_dest.cod_portador,
                                                 Input tt_item_destinac_cobr_dest.cod_cart_bcia,
                                                 Input v_dsl_msg_rpt,
                                                 Input 0,
                                                 Input 99) /*pi_atualiza_tabelas_destinac*/.
               return "NOK" /*l_nok*/ .
            end /* if */.
        end /* if */.
        else do:
            find first portador no-lock                                         
                 where portador.cod_portador    = tt_item_destinac_cobr_dest.cod_portador           
                   and portador.ind_tip_portad <> "Caixa" /*l_caixa*/  no-error.
            if avail portador then do:
                if  v_cod_pais_empres_usuar = "BRA" /*l_bra*/ 
                and not can-find(first portad_edi
                                 where portad_edi.cod_modul_dtsul  = "ACR" /*l_acr*/ 
                                   and portad_edi.cod_estab        = tit_acr.cod_estab
                                   and portad_edi.cod_portador     = tt_item_destinac_cobr_dest.cod_portador
                                   and portad_edi.cod_cart_bcia    = tt_item_destinac_cobr_dest.cod_cart_bcia
                                   and (portad_edi.log_cobr_acr_pix = no
                                    or portad_edi.log_cobr_acr_pix = ?))
                then do:

                   assign v_dsl_msg_rpt = substitute(getStrTrans("O Portador Item Destinaá∆o &1 relacionado a Regra de Destinaá∆o &2 n∆o Ç v†lido. Esta Regra Ç para Cobranáa &3 e faz-se necess†rio que o Portador EDI tambÇm esteja coerente com esta modalidade de Cobranáa. Relacione um Portador Item Destinaá∆o v†lido aos ParÉmetros Destinaá∆o de Cobranáa ou modifique o cadastro Portador EDI e &4 o parÉmetro Cobranáa PIX para o atual Portador da Regra: M¢dulo: ACR / Estab: &5 / Portador: &1 / Carteira: &6 .", "ACR") /*23396*/,
                                                     tt_item_destinac_cobr_dest.cod_portador, 
                                                     v_cod_destinac_cobr, 
                                                     getStrTrans("Normal", "ACR") /*l_normal*/ ,
                                                     'desmarque',
                                                     tit_acr.cod_estab,
                                                     tt_item_destinac_cobr_dest.cod_cart_bcia).               

                   run pi_atualiza_tabelas_destinac (Input no,
                                                     input tt_item_destinac_cobr_dest.cod_portador,
                                                     Input tt_item_destinac_cobr_dest.cod_cart_bcia,
                                                     Input v_dsl_msg_rpt,
                                                     Input 0,
                                                     Input 99) /*pi_atualiza_tabelas_destinac*/.
                   return "NOK" /*l_nok*/ .
                end /* if */.
            end.
        end /* else */.
        &endif
        /* End_Include: i_valida_portad_item_destinac_cobr_pix */


        /* ** Caso a Carteira seja vendor o t°tulo deve possuir as Informaá‰es Vendor ***/
        assign v_log_destinac = yes 
               v_log_cart_bcia_vendor = no.

        if  can-find(cart_bcia 
               where cart_bcia.cod_cart_bcia = tt_item_destinac_cobr_dest.cod_cart_bcia
               and   cart_bcia.ind_tip_cart_bcia = "Vendor" /*l_vendor*/ ) then 
            assign v_log_cart_bcia_vendor = yes.

        if  v_log_tit_vendor = no
        and v_log_cart_bcia_vendor = yes then 
            assign v_log_destinac = no.

        /* ** Caso a Carteira seja Descontada ser† barrada a destinaá∆o ***/
        if can-find(cart_bcia 
              where cart_bcia.cod_cart_bcia = tt_item_destinac_cobr_dest.cod_cart_bcia
              and   cart_bcia.ind_tip_cart_bcia = "Desconto" /*l_desconto*/ ) then do:
            run pi_atualiza_tabelas_destinac (Input no,
                                              input tt_item_destinac_cobr_dest.cod_portador,
                                              Input tt_item_destinac_cobr_dest.cod_cart_bcia,
                                              Input getStrTrans("T°tulo n∆o pode ser destinado para uma carteira Desconto !", "ACR") /*19520*/,
                                              Input 0,
                                              Input 99) /*pi_atualiza_tabelas_destinac*/.
            next table_child.
        end.

        if  v_log_destinac then do:

            /* **Posiciona tt_portad_finalid_econ para verificaá∆o de validaá∆o de CEP.***/
            find tt_portad_finalid_econ
                where tt_portad_finalid_econ.tta_cod_portador     = tt_item_destinac_cobr_dest.cod_portador
                  and tt_portad_finalid_econ.tta_cod_cart_bcia    = tt_item_destinac_cobr_dest.cod_cart_bcia
                  and tt_portad_finalid_econ.tta_cod_finalid_econ = destinac_cobr.cod_finalid_econ
                no-error.
            if  avail tt_portad_finalid_econ then do:
                find first portad_finalid_econ use-index prtdfnld_id
                    where portad_finalid_econ.cod_estab        = tit_acr.cod_estab
                    and   portad_finalid_econ.cod_portador     = tt_item_destinac_cobr_dest.cod_portador
                    and   portad_finalid_econ.cod_cart_bcia    = tt_item_destinac_cobr_dest.cod_cart_bcia
                    and   portad_finalid_econ.cod_finalid_econ = destinac_cobr.cod_finalid_econ
                    no-lock no-error.
                /* Ref a FO2210534 Pimp∆o*/
                if not avail portad_finalid_econ then do:
                   assign v_dsl_msg_rpt = substitute(getStrTrans("N∆o encontrado Portador &1 para Carteira &2, Finalidade Econìmica &3 e Estabelecimento &4 na Manutená∆o de Finalidade Econìmica do Portador.", "ACR") /*20387*/,
                                                     tt_item_destinac_cobr_dest.cod_portador, 
                                                     tt_item_destinac_cobr_dest.cod_cart_bcia, 
                                                     destinac_cobr.cod_finalid_econ,
                                                     tit_acr.cod_estab).

                   run pi_atualiza_tabelas_destinac (Input no,
                                                     input tt_item_destinac_cobr_dest.cod_portador,
                                                     Input tt_item_destinac_cobr_dest.cod_cart_bcia,
                                                     Input v_dsl_msg_rpt,
                                                     Input 0,
                                                     Input 99) /* pi_atualiza_tabelas_destinac*/.
                   return.           
                end.    
                find cta_corren
                    where cta_corren.cod_cta_corren = portad_finalid_econ.cod_cta_corren
                    no-lock no-error.
                find banco
                    where banco.cod_banco = cta_corren.cod_banco
                    no-lock no-error.

                find first portador no-lock
                    where portador.cod_portador    = tt_item_destinac_cobr_dest.cod_portador
                      and portador.ind_tip_portad <> "Caixa" /*l_caixa*/  no-error.
                if avail portador then do:    

                    run pi_verificar_portad_bco_tt (Input "ACR" /*l_acr*/,
                                                    Input tit_acr.cod_estab,
                                                    Input tt_item_destinac_cobr_dest.cod_portador,
                                                    Input tt_item_destinac_cobr_dest.cod_cart_bcia,
                                                    Input destinac_cobr.cod_finalid_econ,
                                                    Input tit_acr.dat_vencto_tit_acr,
                                                    Input tit_acr.val_sdo_tit_acr,
                                                    output v_des_mensagem) /*pi_verificar_portad_bco_tt*/.
                    
                    if  return-value = "NOK" /*l_nok*/ then 
                        assign v_log_validac_bco = no.
                    else 
                        assign v_log_validac_bco = yes.

                    if  v_log_validac_bco = yes
                    or (v_des_mensagem = getStrTrans("Data menor que prazo de envio.", "ACR") /*3266*/
                    and tt_portad_finalid_econ.tta_log_validac_cep_destinac = yes) then do:
                        
                        if  tt_portad_finalid_econ.tta_log_validac_cep_destinac = yes then do:
                            run pi_valida_cep_agencia_destinac_cobr (input v_log_validac_bco,input cta_corren.cod_banco).
                            
                            if return-value <> "OK" then do:
                                run pi_atualiza_tabelas_destinac (Input no,
                                                                  input tt_item_destinac_cobr_dest.cod_portador,
                                                                  Input tt_item_destinac_cobr_dest.cod_cart_bcia,
                                                                  Input v_des_mensagem,
                                                                  Input 0,
                                                                  Input 99) /*pi_atualiza_tabelas_destinac*/.
                                next table_child.
                            end.
                        end.
                    end.
                    else do:
                        run pi_atualiza_tabelas_destinac (Input no,
                                                          input tt_item_destinac_cobr_dest.cod_portador,
                                                          Input tt_item_destinac_cobr_dest.cod_cart_bcia,
                                                          Input v_des_mensagem,
                                                          Input tt_item_destinac_cobr_dest.num_ord_destinac,
                                                          Input 99) /*pi_atualiza_tabelas_destinac*/.
                        next table_child.
                    end /* if */.
                end.

                /* ** N∆o Ç possivel enviar t°tulos de carteira vendor via EDI ***/    
                /* ** VALIDA ENVIO E.D.I. ***/
                if  destinac_cobr.log_envio_via_edi = yes and v_log_cart_bcia_vendor = no then do:
                    run pi_validar_envio_edi_destinacao (Input tit_acr.cod_estab,
                                                         Input tt_item_destinac_cobr_dest.cod_portador,
                                                         Input tt_item_destinac_cobr_dest.cod_cart_bcia,
                                                         Input tit_acr.cod_indic_econ,
                                                         Input tit_acr.dat_emis_docto,
                                                         output v_des_mensagem) /*pi_validar_envio_edi_destinacao*/.
                    if  v_des_mensagem <> "" then do:
                        run pi_atualiza_tabelas_destinac (Input no,
                                                          input tt_item_destinac_cobr_dest.cod_portador,
                                                          Input tt_item_destinac_cobr_dest.cod_cart_bcia,
                                                          Input v_des_mensagem,
                                                          Input tt_item_destinac_cobr_dest.num_ord_destinac,
                                                          Input 99) /*pi_atualiza_tabelas_destinac*/.
                        next table_child.
                    end.
                end.

                if  v_log_destinac_percent_sdo
                and destinac_cobr.log_control_perc_destinac
                and not destinac_cobr.log_consid_sdo_cart then do: /* weniton */
                    create tt_tit_destinac_percent.
                    assign tt_tit_destinac_percent.tta_cod_estab      = tit_acr.cod_estab
                           tt_tit_destinac_percent.tta_num_id_tit_acr = tit_acr.num_id_tit_acr
                           v_val_tot_dest                             = v_val_tot_dest + tit_acr.val_sdo_tit_acr.
                    return.
                end.

                /* ** PREPARA VALOR DA META DA DESTINAÄ«O ***/
                if  destinac_cobr.log_control_perc_destinac = no then
                    assign v_val_destinac_portad = tt_item_destinac_cobr_dest.val_niv_cobr.
                else
                    assign v_val_destinac_portad = tt_item_destinac_cobr_dest.val_perc_niv_cobr * v_val_tot_cobr / 100.
                if  tt_portad_finalid_econ.ttv_val_meta_destinac = 0 then
                    assign tt_portad_finalid_econ.ttv_val_meta_destinac = v_val_destinac_portad.

                /* ** CALCULA VALOR DO RESULTADO DA DESTINAÄ«O ***/
                if  destinac_cobr.log_control_perc_destinac = no
                &if '{&emsfin_version}' < "5.04" &then
                  and destinac_cobr.log_livre_1 = yes then do:
                &else
                  and destinac_cobr.log_consid_sdo_cart = no then do:
                &endif
                    /* ** SE A META DA DESTINAÄ«O DEVE IGNORAR O SALDO ATUAL EM COBRANÄA DO PORTADOR ***/
                    assign v_log_meta_complet = (tt_portad_finalid_econ.ttv_val_tot_destndo >= tt_portad_finalid_econ.ttv_val_meta_destinac).
                    assign v_val_cobr = tt_portad_finalid_econ.ttv_val_tot_destndo
                                      + tit_acr.val_sdo_tit_acr.
                end.
                else do:
                    assign v_log_meta_complet = (tt_portad_finalid_econ.tta_val_sdo_cobr >= tt_portad_finalid_econ.ttv_val_meta_destinac).
                    if  tit_acr.cod_portador  <> tt_item_destinac_cobr_dest.cod_portador
                    or  tit_acr.cod_cart_bcia <> tt_item_destinac_cobr_dest.cod_cart_bcia then
                        assign v_val_cobr = tt_portad_finalid_econ.tta_val_sdo_cobr + tit_acr.val_sdo_tit_acr.
                    else
                        assign v_val_cobr = tt_portad_finalid_econ.tta_val_sdo_cobr.
                end.

                assign v_cod_portador    = tt_item_destinac_cobr_dest.cod_portador
                       v_cod_cart_bcia_1 = tt_item_destinac_cobr_dest.cod_cart_bcia.

                /* ** CALCULA PERCENTUAL DE ERRO ***/
                assign v_val_destinac_portad = v_val_destinac_portad + ( v_val_destinac_portad * tt_item_destinac_cobr_dest.val_perc_erro_destinac / 100 ).

                if  v_log_meta_complet
                or  v_val_cobr > v_val_destinac_portad then do:
                    /* ** SE A META Jµ FOI ATINGIDA
                     *** OU N«O FOI ATINGIDA, MAS O T÷TULO ULTRAPASSA O LIMITE ACEITµVEL ***/
                    run pi_atualiza_tabelas_destinac (Input no,
                                                      input tt_item_destinac_cobr_dest.cod_portador,
                                                      Input tt_item_destinac_cobr_dest.cod_cart_bcia,
                                                      Input "Excedeu Meta." /*l_excedeu_meta*/,
                                                      Input tt_item_destinac_cobr_dest.num_ord_destinac,
                                                      Input 99) /*pi_atualiza_tabelas_destinac*/.
                    if  v_cod_portador_res = ""
                    then do:
                         assign v_cod_portador_res  = tt_item_destinac_cobr_dest.cod_portador
                                v_cod_cart_bcia_res = tt_item_destinac_cobr_dest.cod_cart_bcia.
                    end /* if */.
                    next table_child.
                end /* if */.
                else do:
                    run pi_atualiza_tabelas_destinac (Input yes,
                                                      input tt_item_destinac_cobr_dest.cod_portador,
                                                      Input tt_item_destinac_cobr_dest.cod_cart_bcia,
                                                      Input getStrTrans("Portador da destinaá∆o de cobranáa.", "ACR") /*3382*/,
                                                      Input tt_item_destinac_cobr_dest.num_ord_destinac,
                                                      Input 3) /*pi_atualiza_tabelas_destinac*/.
                    return.
                end /* else */.
            end.
            else do:
                run pi_atualiza_tabelas_destinac (Input no,
                                                  input tt_item_destinac_cobr_dest.cod_portador,
                                                  Input tt_item_destinac_cobr_dest.cod_cart_bcia,
                                                  Input getStrTrans("N∆o existe Portador Finalidade Econìmica.", "ACR") /*4986*/,
                                                  Input tt_item_destinac_cobr_dest.num_ord_destinac,
                                                  Input 99) /*pi_atualiza_tabelas_destinac*/.
            end.
        end. /* v_log_destinac */
    end /* for table_child */.

    run pi_executar_tit_acr_destinac_nok_portad /*pi_executar_tit_acr_destinac_nok_portad*/.
    if  return-value <> "OK" /*l_ok*/  then
        return.

    if  v_log_destinac = no then do:
        run pi_atualiza_tabelas_destinac (Input no,
                                          input destinac_cobr.cod_portad_auto_emis,
                                          Input destinac_cobr.cod_cart_bcia_auto_emis,
                                          Input getStrTrans("T°tulo n∆o pode ser destinado para uma carteira Vendor.", "ACR") /*12301*/,
                                          Input 0,
                                          Input 99) /*pi_atualiza_tabelas_destinac*/.
        return.
    end.
END PROCEDURE. /* pi_executar_tit_acr_destinac */
/*****************************************************************************
** Procedure Interna.....: pi_buscar_cart_bcia_portad_prefer
** Descricao.............: pi_buscar_cart_bcia_portad_prefer
** Criado por............: lucas
** Criado em.............: 13/03/1999 12:07:37
** Alterado por..........: fut12235
** Alterado em...........: 28/10/2021 15:17:24
*****************************************************************************/
PROCEDURE pi_buscar_cart_bcia_portad_prefer:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_portador
        as character
        format "x(5)"
        no-undo.


    /************************* Parameter Definition End *************************/

    assign v_cod_cart_bcia_portad_prefer = "".
    if rs_imforma_cart_bcia = "Carteira" /*l_carteira*/ 
    then do:
         find first tt_portad_fe_param_estab no-lock
              where tt_portad_fe_param_estab.tta_cod_estab        = tit_acr.cod_estab
                and tt_portad_fe_param_estab.tta_cod_portador     = p_cod_portador
                and tt_portad_fe_param_estab.tta_cod_finalid_econ = destinac_cobr.cod_finalid_econ
                and tt_portad_fe_param_estab.tta_cod_cart_bcia    = v_cod_cart_bcia no-error.
         if avail tt_portad_fe_param_estab then
            assign tt_rpt_tit_acr_destinac.tta_cod_portad_prefer = p_cod_portador
                   v_cod_cart_bcia_portad_prefer = tt_portad_fe_param_estab.tta_cod_cart_bcia.
         else
            assign v_cod_cart_bcia_portad_prefer = v_cod_cart_bcia.
    end.
    if rs_imforma_cart_bcia = "Tipo Carteira" /*l_tipo_carteira*/ 
    then do:
         find first tt_portad_fe_param_estab no-lock
              where tt_portad_fe_param_estab.tta_cod_estab         = tit_acr.cod_estab
                and tt_portad_fe_param_estab.tta_cod_portador      = p_cod_portador
                and tt_portad_fe_param_estab.tta_cod_finalid_econ  = destinac_cobr.cod_finalid_econ
                and tt_portad_fe_param_estab.tta_ind_tip_cart_bcia = v_ind_tip_cart_bcia no-error.
         if avail tt_portad_fe_param_estab then
            assign tt_rpt_tit_acr_destinac.tta_cod_portad_prefer = p_cod_portador
                   v_cod_cart_bcia_portad_prefer = tt_portad_fe_param_estab.tta_cod_cart_bcia.
    end.

    &if '{&emsfin_version}' >= '5.04' &then
    if rs_imforma_cart_bcia = "Cliente Financeiro" /*l_cliente_financeiro*/ 
    then do:
         find clien_financ no-lock
              where clien_financ.cod_empresa = tit_acr.cod_empresa
                and clien_financ.cdn_cliente = tit_acr.cdn_cliente no-error.
         if avail clien_financ
         then do:
              find first tt_portad_fe_param_estab no-lock
                   where tt_portad_fe_param_estab.tta_cod_estab        = tit_acr.cod_estab
                     and tt_portad_fe_param_estab.tta_cod_portador     = p_cod_portador
                     and tt_portad_fe_param_estab.tta_cod_finalid_econ = destinac_cobr.cod_finalid_econ
                     and tt_portad_fe_param_estab.tta_cod_cart_bcia    = clien_financ.cod_cart_bcia_prefer no-error.
              if avail tt_portad_fe_param_estab then
                 assign tt_rpt_tit_acr_destinac.tta_cod_portad_prefer = p_cod_portador
                        v_cod_cart_bcia_portad_prefer = tt_portad_fe_param_estab.tta_cod_cart_bcia.
         end.
    end.
    &endif
END PROCEDURE. /* pi_buscar_cart_bcia_portad_prefer */
/*****************************************************************************
** Procedure Interna.....: pi_imprimir_tit_acr_destinac
** Descricao.............: pi_imprimir_tit_acr_destinac
** Criado por............: Alexsandra
** Criado em.............: 24/09/1996 08:59:26
** Alterado por..........: brunobecker
** Alterado em...........: 13/10/2021 08:25:39
*****************************************************************************/
PROCEDURE pi_imprimir_tit_acr_destinac:

    /************************* Variable Definition Begin ************************/

    def var v_cod_finalid_econ
        as character
        format "x(10)":U
        label "Finalidade Econìmica"
        column-label "Finalidade Econìmica"
        no-undo.
    def var v_dat_cotac_indic_econ
        as date
        format "99/99/9999":U
        initial today
        label "Data Cotaá∆o"
        column-label "Data Cotaá∆o"
        no-undo.
    def var v_num_erro
        as integer
        format ">>>>,>>9":U
        no-undo.
    def var v_num_seconds
        as integer
        format ">>>,>>9":U
        initial 0
        no-undo.
    def var v_val_cotac_indic_econ
        as decimal
        format "->>,>>>,>>>,>>9.9999999999":U
        decimals 10
        label "Cotaá∆o"
        column-label "Cotaá∆o"
        no-undo.
    def var v_log_auto_emis                  as logical         no-undo. /*local*/


    /************************** Variable Definition End *************************/

    hide stream s_1 frame f_rpt_s_1_header_period.
    view stream s_1 frame f_rpt_s_1_header_unique.
    hide stream s_1 frame f_rpt_s_1_footer_last_page.
    hide stream s_1 frame f_rpt_s_1_footer_param_page.
    view stream s_1 frame f_rpt_s_1_footer_normal.
    assign v_val_tot = 0 v_num_tot_geral = 0 v_num_contador = 0 v_val_tot_destinac = 0 v_val_tot_cust = 0 v_val_sdo_cobr_ant = 0 v_val_sdo_cobr = 0 v_val_meta_destinac = 0.
    find first tt_rpt_tit_acr_destinac no-lock no-error.
    if not avail tt_rpt_tit_acr_destinac then return.
    /* **Limpa tt para envio EDI***/
    for each tt_tit_acr_selec_cobr:
      delete tt_tit_acr_selec_cobr.
    end.
    /* **Trata do arquivo de Movimento de Destinaá∆o de Cobranáa***/
    find first tt_rpt_tit_acr_destinac no-lock where
       tt_rpt_tit_acr_destinac.ttv_log_selec_tit_acr = yes no-error.
    if  avail tt_rpt_tit_acr_destinac
    and v_ind_tip_destinac = "Destinaá∆o" /*l_destinacao*/  
    then do transaction:
       create movto_destinac_cobr.
       assign v_num_seconds = time.
       run pi_sec_to_formatted_time (Input v_num_seconds,
                                     output v_hra_formatted_time) /*pi_sec_to_formatted_time*/.
       assign movto_destinac_cobr.cod_empresa = v_cod_empres_usuar
              movto_destinac_cobr.cod_estab = tt_rpt_tit_acr_destinac.tta_cod_estab
              movto_destinac_cobr.dat_movto_destinac_cobr = v_dat_destinac
              movto_destinac_cobr.hra_movto_destinac_cobr = v_hra_formatted_time
              movto_destinac_cobr.cod_usuario = v_cod_dwb_user
              movto_destinac_cobr.cod_destinac_cobr = destinac_cobr.cod_destinac_cobr
              movto_destinac_cobr.cod_finalid_econ = destinac_cobr.cod_finalid_econ
              movto_destinac_cobr.num_seq_destinac_cobr = destinac_cobr.num_seq_destinac_cobr.
    end /* if */.
    /* **Impress∆o dos T°tulos Destinados***/
    if can-find( first tt_rpt_tit_acr_destinac
                 where tt_rpt_tit_acr_destinac.tta_num_dwb_order < 20 ) then do:
        if  v_ind_tip_destinac <> "Listagem de T°tulos a Destinar" /*l_listagem_de_titulos_a_destinar*/ 
        then do:
            if  v_ind_tip_destinac = "Simulaá∆o" /*l_simulacao*/ 
            then do:
                assign v_des_titulo = "Relaá∆o dos T°tulos Destinados" /*l_relac_tit_destin*/  + " - " + "Simulaá∆o" /*l_simulacao*/ .
            end.
            else assign v_des_titulo = "Relaá∆o dos T°tulos Destinados" /*l_relac_tit_destin*/  + " - " + "Execuá∆o" /*l_execucao*/ .
        end.
        else assign v_des_titulo = "Listagem de T°tulos a Destinar" /*l_listagem_de_titulos_a_destinar*/ .
        if (line-counter(s_1) + 5) > v_rpt_s_1_bottom then
            page stream s_1.
        put stream s_1 unformatted 
            v_des_titulo at 1 format "x(60)"
            skip (1)
            getStrTrans("Destinaá∆o: ", "ACR") at 1
            destinac_cobr.cod_destinac_cobr at 13 format "x(8)"
            v_des_aux_1 at 33 format "x(40)" skip
            getStrTrans("Finalidade: ", "ACR") at 10
            destinac_cobr.cod_finalid_econ at 22 format "x(10)" skip (1).
        if  v_ind_tip_destinac <> "Listagem de T°tulos a Destinar" /*l_listagem_de_titulos_a_destinar*/ 
        then do:
            if (line-counter(s_1) + 3) > v_rpt_s_1_bottom then
                page stream s_1.
            put stream s_1 unformatted 
                getStrTrans("Est", "ACR") at 1
                getStrTrans("Esp", "ACR") at 7
                getStrTrans("SÇrie", "ACR") at 11
                getStrTrans("T°tulo", "ACR") at 17
                getStrTrans("/P", "ACR") at 34
                getStrTrans("Cliente", "ACR") to 47
                getStrTrans("Nome Abrev", "ACR") at 49
                getStrTrans("Cidade", "ACR") at 65
                getStrTrans("Emiss∆o", "ACR") at 98
                getStrTrans("Vencto", "ACR") at 109
                getStrTrans("Saldo", "ACR") to 133
                getStrTrans("Observaá‰es", "ACR") at 135 skip
                "-----" at 1
                "---" at 7
                "-----" at 11
                "----------------" at 17
                "--" at 34
                "-----------" to 47
                "---------------" at 49
                "--------------------------------" at 65
                "----------" at 98
                "----------" at 109
                "--------------" to 133
                "---------------------------------------------------------" at 135 skip.
        end.
        else do:
            if (line-counter(s_1) + 3) > v_rpt_s_1_bottom then
                page stream s_1.
            put stream s_1 unformatted 
                getStrTrans("Est", "ACR") at 1
                getStrTrans("Esp", "ACR") at 7
                getStrTrans("SÇrie", "ACR") at 11
                getStrTrans("T°tulo", "ACR") at 17
                getStrTrans("/P", "ACR") at 34
                getStrTrans("Cliente", "ACR") to 47
                getStrTrans("Nome Abrev", "ACR") at 49
                getStrTrans("Cidade", "ACR") at 65
                getStrTrans("Emiss∆o", "ACR") at 98
                getStrTrans("Vencto", "ACR") at 109
                getStrTrans("Saldo", "ACR") to 133 skip
                "-----" at 1
                "---" at 7
                "-----" at 11
                "----------------" at 17
                "--" at 34
                "-----------" to 47
                "---------------" at 49
                "--------------------------------" at 65
                "----------" at 98
                "----------" at 109
                "--------------" to 133 skip.
        end.
        if  destinac_cobr.log_control_perc_destinac = no
        &if '{&emsfin_version}' < "5.04" &then
          and destinac_cobr.log_livre_1 = yes then
        &else
          and destinac_cobr.log_consid_sdo_cart = no then
        &endif
            assign v_des_aux_1 = "(" + "N∆o" /*l_nao*/  + " " + "Consid Sdo Carteira" + ")".
        else
            assign v_des_aux_1 = "".
        /* Classificaá∆o*/
        if v_ind_classif_destinac = "Estab/Portador/Carteira/Dt Emiss∆o/T°tulo/Parcela" /*l_emis_tit_parcela*/  then do:
           temp_table:
           for each tt_rpt_tit_acr_destinac exclusive-lock
               where tt_rpt_tit_acr_destinac.tta_num_dwb_order < 20
               break by tt_rpt_tit_acr_destinac.tta_cod_estab
                     by tt_rpt_tit_acr_destinac.tta_cod_portador
                     by tt_rpt_tit_acr_destinac.tta_cod_cart_bcia
                     by tt_rpt_tit_acr_destinac.tta_dat_emis_docto
                     by tt_rpt_tit_acr_destinac.tta_cod_tit_acr
                     by tt_rpt_tit_acr_destinac.tta_cod_parcela transaction:

               /* Begin_Include: i_imprimir_tit_destinac */
               if v_ind_tip_destinac = "Destinaá∆o" /*l_destinacao*/ 
                  then run pi_atualiza_destinac_tit_acr.
               if  first-of(tt_rpt_tit_acr_destinac.tta_cod_portador)
               then do:
                   find portador no-lock
                        where portador.cod_portador = tt_rpt_tit_acr_destinac.tta_cod_portador no-error.
                   hide stream s_1 frame f_rpt_s_1_Grp_detalhe_Lay_a_dest.
                   hide stream s_1 frame f_rpt_s_1_Grp_detalhe_Lay_dest_port.
                   hide stream s_1 frame f_rpt_s_1_Grp_detalhe_Lay_erros.
                   hide stream s_1 frame f_rpt_s_1_Grp_detalhe_Lay_resumo_port.
                   view stream s_1 frame f_rpt_s_1_Grp_detalhe_Lay_tit_dest.
                   if (line-counter(s_1) + 2) > v_rpt_s_1_bottom then
                       page stream s_1.
                   put stream s_1 unformatted 
                       skip (1)
                       getStrTrans("Portad: ", "ACR") at 10
                       tt_rpt_tit_acr_destinac.tta_cod_portador at 18 format "x(5)"
                       "-" at 24
                       portador.nom_pessoa at 26 format "x(40)" skip.
                   assign v_num_contador = 0.
               end /* if */.
               if  first-of(tt_rpt_tit_acr_destinac.tta_cod_cart_bcia)
               then do:
                   find cart_bcia no-lock
                        where cart_bcia.cod_cart_bcia = tt_rpt_tit_acr_destinac.tta_cod_cart_bcia no-error.
                   if (line-counter(s_1) + 2) > v_rpt_s_1_bottom then
                       page stream s_1.
                   put stream s_1 unformatted 
                       getStrTrans("Carteira: ", "ACR") at 10
                       tt_rpt_tit_acr_destinac.tta_cod_cart_bcia at 20 format "x(3)"
                       "-" at 25
                       cart_bcia.des_cart_bcia at 28 format "x(40)" skip (1).
               end /* if */.
               /* n∆o permite imprimir o total no fim da p†gina */
               if  (last(tt_rpt_tit_acr_destinac.tta_cod_portador)) and
                   (line-counter(s_1) + 5 > v_rpt_s_1_bottom)
               then do:
                    block:
                    do while (line-counter(s_1) + 1) <= v_rpt_s_1_bottom :
                        put stream s_1 skip (1).
                    end /* do block */.
                    page stream s_1.
               end /* if */.
               else do:
                    if  (last-of(tt_rpt_tit_acr_destinac.tta_cod_portador)) and
                         (line-counter(s_1) + 4 > v_rpt_s_1_bottom)
                    then do:
                          block:
                          do while (line-counter(s_1) + 1) <= v_rpt_s_1_bottom :
                             put stream s_1 skip (1).
                          end /* do block */.
                          page stream s_1.
                    end /* if */.
                    else do:
                          if  line-counter(s_1) + 3 > v_rpt_s_1_bottom and last-of(tt_rpt_tit_acr_destinac.tta_cod_cart_bcia)
                          then do:
                               block:
                               do while (line-counter(s_1) + 1) <= v_rpt_s_1_bottom :
                                  put stream s_1 skip (1).
                               end /* do block */.
                               page stream s_1.
                          end /* if */.
                    end /* else */.
               end /* else */.

               find cliente no-lock where cliente.cod_empresa = tt_rpt_tit_acr_destinac.tta_cod_empresa
                    and cliente.cdn_cliente = tt_rpt_tit_acr_destinac.tta_cdn_cliente no-error.
                    assign v_nom_abrev = if avail cliente then cliente.nom_abrev else "".

               if  v_ind_tip_destinac <> "Listagem de T°tulos a Destinar" /*l_listagem_de_titulos_a_destinar*/ 
               then do:
                   if (line-counter(s_1) + 1) > v_rpt_s_1_bottom then
                       page stream s_1.
                   put stream s_1 unformatted 
                       tt_rpt_tit_acr_destinac.tta_cod_estab at 1 format "x(5)"
                       tt_rpt_tit_acr_destinac.tta_cod_espec_docto at 7 format "x(3)"
                       tt_rpt_tit_acr_destinac.tta_cod_ser_docto at 11 format "x(5)"
                       tt_rpt_tit_acr_destinac.tta_cod_tit_acr at 17 format "x(16)"
                       tt_rpt_tit_acr_destinac.tta_cod_parcela at 34 format "x(02)"
                       tt_rpt_tit_acr_destinac.tta_cdn_cliente to 47 format ">>>,>>>,>>9"
                       v_nom_abrev at 49 format "x(15)"
                       tt_rpt_tit_acr_destinac.tta_nom_cidade at 65 format "x(32)"
                       tt_rpt_tit_acr_destinac.tta_dat_emis_docto at 98 format "99/99/9999"
                       tt_rpt_tit_acr_destinac.tta_dat_vencto_tit_acr at 109 format "99/99/9999"
                       tt_rpt_tit_acr_destinac.tta_val_sdo_tit_acr to 133 format ">>>,>>>,>>9.99"
                       tt_rpt_tit_acr_destinac.ttv_des_obs_campo at 135 format "x(57)" skip.
               end.
               else do:
                   if (line-counter(s_1) + 1) > v_rpt_s_1_bottom then
                       page stream s_1.
                   put stream s_1 unformatted 
                       tt_rpt_tit_acr_destinac.tta_cod_estab at 1 format "x(5)"
                       tt_rpt_tit_acr_destinac.tta_cod_espec_docto at 7 format "x(3)"
                       tt_rpt_tit_acr_destinac.tta_cod_ser_docto at 11 format "x(5)"
                       tt_rpt_tit_acr_destinac.tta_cod_tit_acr at 17 format "x(16)"
                       tt_rpt_tit_acr_destinac.tta_cod_parcela at 34 format "x(02)"
                       tt_rpt_tit_acr_destinac.tta_cdn_cliente to 47 format ">>>,>>>,>>9"
                       v_nom_abrev at 49 format "x(15)"
                       tt_rpt_tit_acr_destinac.tta_nom_cidade at 65 format "x(32)"
                       tt_rpt_tit_acr_destinac.tta_dat_emis_docto at 98 format "99/99/9999"
                       tt_rpt_tit_acr_destinac.tta_dat_vencto_tit_acr at 109 format "99/99/9999"
                       tt_rpt_tit_acr_destinac.tta_val_sdo_tit_acr to 133 format ">>>,>>>,>>9.99" skip.
               end.
               assign v_val_tot_portad = v_val_tot_portad + tt_rpt_tit_acr_destinac.tta_val_sdo_tit_acr
                      v_num_contador = v_num_contador + 1
                      v_val_tot_cart_bcia = v_val_tot_cart_bcia + tt_rpt_tit_acr_destinac.tta_val_sdo_tit_acr
                      v_num_count = v_num_count + 1.
               if  last-of(tt_rpt_tit_acr_destinac.tta_cod_cart_bcia)
               then do:
                   hide stream s_1 frame f_rpt_s_1_Grp_detalhe_Lay_tit_dest.
                   if (line-counter(s_1) + 2) > v_rpt_s_1_bottom then
                       page stream s_1.
                   put stream s_1 unformatted 
                       "--------------" at 120 skip
                       getStrTrans("Total Cart. Banc†ria: ", "ACR") at 94
                       v_val_tot_cart_bcia to 133 format "->>,>>>,>>>,>>9.99"
                       "-" at 135
                       v_num_count to 144 format ">>>>,>>9"
                       getStrTrans("T°tulo(s)  ", "ACR") at 146 skip.
                   if  not (last-of(tt_rpt_tit_acr_destinac.tta_cod_portador))
                   then do:
                       if (line-counter(s_1) + 1) > v_rpt_s_1_bottom then
                           page stream s_1.
                       put stream s_1 unformatted  skip (1).
                   end /* if */.
                   if  v_ind_tip_destinac = "Destinaá∆o" /*l_destinacao*/ 
                   then do:
                       run pi_tratar_item_movto_destinac_cobr (Input v_val_tot_cart_bcia,
                                                               Input v_num_count) /*pi_tratar_item_movto_destinac_cobr*/.
                   end /* if */.
                   assign v_val_tot_cart_bcia = 0 v_num_count = 0.
               end /* if */.
               if  last-of(tt_rpt_tit_acr_destinac.tta_cod_portador)
               then do:
                   hide stream s_1 frame f_rpt_s_1_Grp_detalhe_Lay_tit_dest.
                   if (line-counter(s_1) + 1) > v_rpt_s_1_bottom then
                       page stream s_1.
                   put stream s_1 unformatted 
                       getStrTrans("Total do Portador: ", "ACR") at 97
                       v_val_tot_portad to 133 format "->>,>>>,>>>,>>9.99"
                       "-" at 135
                       v_num_contador to 144 format ">>>>,>>9"
                       getStrTrans("T°tulo(s)  ", "ACR") at 146 skip.
                   assign v_val_tot     = v_val_tot + v_val_tot_portad
                          v_num_tot_geral = v_num_tot_geral + v_num_contador
                          v_val_tot_portad  = 0.
               end /* if */.
               if  v_ind_tip_destinac <> "Listagem de T°tulos a Destinar" /*l_listagem_de_titulos_a_destinar*/  then do:
               /* **Dados para o custo da destinaá∆o***/
                   find tt_portad_finalid_econ no-lock
                        where tt_portad_finalid_econ.tta_cod_portador     = tt_rpt_tit_acr_destinac.tta_cod_portador
                          and tt_portad_finalid_econ.tta_cod_cart_bcia    = tt_rpt_tit_acr_destinac.tta_cod_cart_bcia
                          and tt_portad_finalid_econ.tta_cod_finalid_econ = destinac_cobr.cod_finalid_econ no-error.
                   find cta_corren
                        where cta_corren.cod_cta_corren = tt_portad_finalid_econ.tta_cod_cta_corren
                        no-lock no-error.
                   find first tt_rpt_calc_custo_acr exclusive-lock
                        where tt_rpt_calc_custo_acr.tta_cod_portador = tt_rpt_tit_acr_destinac.tta_cod_portador
                          and tt_rpt_calc_custo_acr.tta_cod_cart_bcia  = tt_rpt_tit_acr_destinac.tta_cod_cart_bcia no-error.
                   if  not avail tt_rpt_calc_custo_acr
                   then do:
                       create tt_rpt_calc_custo_acr.
                       assign tt_rpt_calc_custo_acr.tta_cod_portador        = tt_rpt_tit_acr_destinac.tta_cod_portador
                              tt_rpt_calc_custo_acr.tta_cod_cart_bcia       = tt_rpt_tit_acr_destinac.tta_cod_cart_bcia
                              tt_rpt_calc_custo_acr.tta_nom_pessoa          = if avail portador then portador.nom_pessoa else ""
                              tt_rpt_calc_custo_acr.ttv_qtd_portador        = 0
                              tt_rpt_calc_custo_acr.ttv_val_destinac_portad = 0
                              tt_rpt_calc_custo_acr.tta_cod_banco           = if avail cta_corren then cta_corren.cod_banco else "".
                   end /* if */.
                   assign tt_rpt_calc_custo_acr.ttv_qtd_portador        = tt_rpt_calc_custo_acr.ttv_qtd_portador + 1
                          tt_rpt_calc_custo_acr.ttv_val_destinac_portad = tt_rpt_calc_custo_acr.ttv_val_destinac_portad + tt_rpt_tit_acr_destinac.tta_val_sdo_tit_acr.
               end.
               /* **Gera tt para envio ao banco***/
               if  destinac_cobr.log_envio_via_edi = yes and v_ind_tip_destinac = "Destinaá∆o" /*l_destinacao*/  then do:
                   find tit_acr no-lock where recid(tit_acr) = tt_rpt_tit_acr_destinac.ttv_rec_tit_acr no-error.
                   if  (index(v_nom_prog_upc, 'epc_acr739ab') > 0 or 
                       index(v_nom_prog_dpc, 'epc_acr739ab') > 0 or    
                       index(v_nom_prog_appc, 'epc_acr739ab') > 0)
                   then do:
                       if  tit_acr.val_sdo_tit_acr  = 0
                       then do: 
                           next.    
                       end /* if */.
                   end /* if */.
                   run pi_retornar_finalid_indic_econ (Input tit_acr.cod_indic_econ,
                                                       Input tit_acr.dat_emis_docto,
                                                       output v_cod_finalid_econ) /*pi_retornar_finalid_indic_econ*/.
                   find movto_tit_acr no-lock
                        where movto_tit_acr.cod_estab      = tt_rpt_tit_acr_destinac.tta_cod_estab
                          and movto_tit_acr.num_id_tit_acr = tt_rpt_tit_acr_destinac.tta_num_id_tit_acr
                        and ( movto_tit_acr.ind_trans_acr = "Implantaá∆o" /*l_implantacao*/ 
                           or movto_tit_acr.ind_trans_acr = "Implantaá∆o a CrÇdito" /*l_implantacao_a_credito*/ 
                           or movto_tit_acr.ind_trans_acr = "Implantaá∆o a DÇbito" /*l_implantacao_a_debito*/ 
                           or movto_tit_acr.ind_trans_acr = "Transf Estabelecimento" /*l_transf_estabelecimento*/ 
                           or movto_tit_acr.ind_trans_acr = "Renegociaá∆o" /*l_renegociacao*/ ) no-error.

                   find first espec_docto_financ_acr no-lock
               	 where espec_docto_financ_acr.cod_espec_docto = tit_acr.cod_espec_docto no-error.
                   if  avail espec_docto_financ_acr
                   and espec_docto_financ_acr.log_habilit_cobr_bcia = no
                   then do:
                       /* ------ Se a espÇcia n∆o estiver habilitado para cobranáa banc†ria, n∆o cria a tt ------- */
                       next.
                   end.

                   create tt_tit_acr_selec_cobr.
                   assign tt_tit_acr_selec_cobr.ttv_rec_tit_acr = tt_rpt_tit_acr_destinac.ttv_rec_tit_acr
                          tt_tit_acr_selec_cobr.ttv_rec_movto_ocor_bcia = ?
                          tt_tit_acr_selec_cobr.ttv_rec_movto_tit_acr   = recid( movto_tit_acr )
                          tt_tit_acr_selec_cobr.tta_cod_estab = tt_rpt_tit_acr_destinac.tta_cod_estab
                          tt_tit_acr_selec_cobr.tta_cod_ser_docto = tt_rpt_tit_acr_destinac.tta_cod_ser_docto
                          tt_tit_acr_selec_cobr.tta_cod_espec_docto = tt_rpt_tit_acr_destinac.tta_cod_espec_docto
                          tt_tit_acr_selec_cobr.tta_cod_tit_acr = tt_rpt_tit_acr_destinac.tta_cod_tit_acr
                          tt_tit_acr_selec_cobr.tta_cod_parcela = tt_rpt_tit_acr_destinac.tta_cod_parcela
                          tt_tit_acr_selec_cobr.tta_cod_portador = tt_rpt_tit_acr_destinac.tta_cod_portador
                          tt_tit_acr_selec_cobr.tta_cod_finalid_econ = v_cod_finalid_econ
                          tt_tit_acr_selec_cobr.tta_cod_cart_bcia = tt_rpt_tit_acr_destinac.tta_cod_cart_bcia
                          tt_tit_acr_selec_cobr.tta_dat_transacao = v_dat_destinac
                          tt_tit_acr_selec_cobr.tta_dat_vencto_tit_acr = tt_rpt_tit_acr_destinac.tta_dat_vencto_tit_acr
                          tt_tit_acr_selec_cobr.ttv_log_selec_tit_acr = yes
                          tt_tit_acr_selec_cobr.tta_log_envdo_edi = yes
                          tt_tit_acr_selec_cobr.tta_ind_trans_acr = movto_tit_acr.ind_trans_acr
                          tt_tit_acr_selec_cobr.tta_ind_tip_ocor_bcia = "Implantaá∆o" /*l_implantacao*/ .
                   if v_log_parc_cartcred
                   then do:
                        assign tt_tit_acr_selec_cobr.ttv_val_sdo_tit_acr = tit_acr.val_sdo_tit_acr
                               tt_tit_acr_selec_cobr.ttv_num_parc_cartcred = 1.
                   end.

               end.
               if  tt_rpt_tit_acr_destinac.tta_cod_portador = destinac_cobr.cod_portad_auto_emis
               and tt_rpt_tit_acr_destinac.tta_cod_cart_bcia = destinac_cobr.cod_cart_bcia_auto_emis
               and tt_rpt_tit_acr_destinac.tta_num_dwb_order = 2
               then assign v_log_auto_emis = yes.
               delete tt_rpt_tit_acr_destinac.
               /* End_Include: i_imprimir_tit_destinac */

           end /* for temp_table */.
        end.
        else do:
           temp_table:
           for each tt_rpt_tit_acr_destinac exclusive-lock
               where tt_rpt_tit_acr_destinac.tta_num_dwb_order < 20
               break by tt_rpt_tit_acr_destinac.tta_cod_estab
                     by tt_rpt_tit_acr_destinac.tta_cod_portador
                     by tt_rpt_tit_acr_destinac.tta_cod_cart_bcia
                     by tt_rpt_tit_acr_destinac.tta_dat_emis_docto
                     by tt_rpt_tit_acr_destinac.tta_dat_vencto_tit_acr
                     by tt_rpt_tit_acr_destinac.tta_cod_tit_acr
                     by tt_rpt_tit_acr_destinac.tta_cod_parcela transaction:

               /* Begin_Include: i_imprimir_tit_destinac */
               if v_ind_tip_destinac = "Destinaá∆o" /*l_destinacao*/ 
                  then run pi_atualiza_destinac_tit_acr.
               if  first-of(tt_rpt_tit_acr_destinac.tta_cod_portador)
               then do:
                   find portador no-lock
                        where portador.cod_portador = tt_rpt_tit_acr_destinac.tta_cod_portador no-error.
                   hide stream s_1 frame f_rpt_s_1_Grp_detalhe_Lay_a_dest.
                   hide stream s_1 frame f_rpt_s_1_Grp_detalhe_Lay_dest_port.
                   hide stream s_1 frame f_rpt_s_1_Grp_detalhe_Lay_erros.
                   hide stream s_1 frame f_rpt_s_1_Grp_detalhe_Lay_resumo_port.
                   view stream s_1 frame f_rpt_s_1_Grp_detalhe_Lay_tit_dest.
                   if (line-counter(s_1) + 2) > v_rpt_s_1_bottom then
                       page stream s_1.
                   put stream s_1 unformatted 
                       skip (1)
                       getStrTrans("Portad: ", "ACR") at 10
                       tt_rpt_tit_acr_destinac.tta_cod_portador at 18 format "x(5)"
                       "-" at 24
                       portador.nom_pessoa at 26 format "x(40)" skip.
                   assign v_num_contador = 0.
               end /* if */.
               if  first-of(tt_rpt_tit_acr_destinac.tta_cod_cart_bcia)
               then do:
                   find cart_bcia no-lock
                        where cart_bcia.cod_cart_bcia = tt_rpt_tit_acr_destinac.tta_cod_cart_bcia no-error.
                   if (line-counter(s_1) + 2) > v_rpt_s_1_bottom then
                       page stream s_1.
                   put stream s_1 unformatted 
                       getStrTrans("Carteira: ", "ACR") at 10
                       tt_rpt_tit_acr_destinac.tta_cod_cart_bcia at 20 format "x(3)"
                       "-" at 25
                       cart_bcia.des_cart_bcia at 28 format "x(40)" skip (1).
               end /* if */.
               /* n∆o permite imprimir o total no fim da p†gina */
               if  (last(tt_rpt_tit_acr_destinac.tta_cod_portador)) and
                   (line-counter(s_1) + 5 > v_rpt_s_1_bottom)
               then do:
                    block:
                    do while (line-counter(s_1) + 1) <= v_rpt_s_1_bottom :
                        put stream s_1 skip (1).
                    end /* do block */.
                    page stream s_1.
               end /* if */.
               else do:
                    if  (last-of(tt_rpt_tit_acr_destinac.tta_cod_portador)) and
                         (line-counter(s_1) + 4 > v_rpt_s_1_bottom)
                    then do:
                          block:
                          do while (line-counter(s_1) + 1) <= v_rpt_s_1_bottom :
                             put stream s_1 skip (1).
                          end /* do block */.
                          page stream s_1.
                    end /* if */.
                    else do:
                          if  line-counter(s_1) + 3 > v_rpt_s_1_bottom and last-of(tt_rpt_tit_acr_destinac.tta_cod_cart_bcia)
                          then do:
                               block:
                               do while (line-counter(s_1) + 1) <= v_rpt_s_1_bottom :
                                  put stream s_1 skip (1).
                               end /* do block */.
                               page stream s_1.
                          end /* if */.
                    end /* else */.
               end /* else */.

               find cliente no-lock where cliente.cod_empresa = tt_rpt_tit_acr_destinac.tta_cod_empresa
                    and cliente.cdn_cliente = tt_rpt_tit_acr_destinac.tta_cdn_cliente no-error.
                    assign v_nom_abrev = if avail cliente then cliente.nom_abrev else "".

               if  v_ind_tip_destinac <> "Listagem de T°tulos a Destinar" /*l_listagem_de_titulos_a_destinar*/ 
               then do:
                   if (line-counter(s_1) + 1) > v_rpt_s_1_bottom then
                       page stream s_1.
                   put stream s_1 unformatted 
                       tt_rpt_tit_acr_destinac.tta_cod_estab at 1 format "x(5)"
                       tt_rpt_tit_acr_destinac.tta_cod_espec_docto at 7 format "x(3)"
                       tt_rpt_tit_acr_destinac.tta_cod_ser_docto at 11 format "x(5)"
                       tt_rpt_tit_acr_destinac.tta_cod_tit_acr at 17 format "x(16)"
                       tt_rpt_tit_acr_destinac.tta_cod_parcela at 34 format "x(02)"
                       tt_rpt_tit_acr_destinac.tta_cdn_cliente to 47 format ">>>,>>>,>>9"
                       v_nom_abrev at 49 format "x(15)"
                       tt_rpt_tit_acr_destinac.tta_nom_cidade at 65 format "x(32)"
                       tt_rpt_tit_acr_destinac.tta_dat_emis_docto at 98 format "99/99/9999"
                       tt_rpt_tit_acr_destinac.tta_dat_vencto_tit_acr at 109 format "99/99/9999"
                       tt_rpt_tit_acr_destinac.tta_val_sdo_tit_acr to 133 format ">>>,>>>,>>9.99"
                       tt_rpt_tit_acr_destinac.ttv_des_obs_campo at 135 format "x(57)" skip.
               end.
               else do:
                   if (line-counter(s_1) + 1) > v_rpt_s_1_bottom then
                       page stream s_1.
                   put stream s_1 unformatted 
                       tt_rpt_tit_acr_destinac.tta_cod_estab at 1 format "x(5)"
                       tt_rpt_tit_acr_destinac.tta_cod_espec_docto at 7 format "x(3)"
                       tt_rpt_tit_acr_destinac.tta_cod_ser_docto at 11 format "x(5)"
                       tt_rpt_tit_acr_destinac.tta_cod_tit_acr at 17 format "x(16)"
                       tt_rpt_tit_acr_destinac.tta_cod_parcela at 34 format "x(02)"
                       tt_rpt_tit_acr_destinac.tta_cdn_cliente to 47 format ">>>,>>>,>>9"
                       v_nom_abrev at 49 format "x(15)"
                       tt_rpt_tit_acr_destinac.tta_nom_cidade at 65 format "x(32)"
                       tt_rpt_tit_acr_destinac.tta_dat_emis_docto at 98 format "99/99/9999"
                       tt_rpt_tit_acr_destinac.tta_dat_vencto_tit_acr at 109 format "99/99/9999"
                       tt_rpt_tit_acr_destinac.tta_val_sdo_tit_acr to 133 format ">>>,>>>,>>9.99" skip.
               end.
               assign v_val_tot_portad = v_val_tot_portad + tt_rpt_tit_acr_destinac.tta_val_sdo_tit_acr
                      v_num_contador = v_num_contador + 1
                      v_val_tot_cart_bcia = v_val_tot_cart_bcia + tt_rpt_tit_acr_destinac.tta_val_sdo_tit_acr
                      v_num_count = v_num_count + 1.
               if  last-of(tt_rpt_tit_acr_destinac.tta_cod_cart_bcia)
               then do:
                   hide stream s_1 frame f_rpt_s_1_Grp_detalhe_Lay_tit_dest.
                   if (line-counter(s_1) + 2) > v_rpt_s_1_bottom then
                       page stream s_1.
                   put stream s_1 unformatted 
                       "--------------" at 120 skip
                       getStrTrans("Total Cart. Banc†ria: ", "ACR") at 94
                       v_val_tot_cart_bcia to 133 format "->>,>>>,>>>,>>9.99"
                       "-" at 135
                       v_num_count to 144 format ">>>>,>>9"
                       getStrTrans("T°tulo(s)  ", "ACR") at 146 skip.
                   if  not (last-of(tt_rpt_tit_acr_destinac.tta_cod_portador))
                   then do:
                       if (line-counter(s_1) + 1) > v_rpt_s_1_bottom then
                           page stream s_1.
                       put stream s_1 unformatted  skip (1).
                   end /* if */.
                   if  v_ind_tip_destinac = "Destinaá∆o" /*l_destinacao*/ 
                   then do:
                       run pi_tratar_item_movto_destinac_cobr (Input v_val_tot_cart_bcia,
                                                               Input v_num_count) /*pi_tratar_item_movto_destinac_cobr*/.
                   end /* if */.
                   assign v_val_tot_cart_bcia = 0 v_num_count = 0.
               end /* if */.
               if  last-of(tt_rpt_tit_acr_destinac.tta_cod_portador)
               then do:
                   hide stream s_1 frame f_rpt_s_1_Grp_detalhe_Lay_tit_dest.
                   if (line-counter(s_1) + 1) > v_rpt_s_1_bottom then
                       page stream s_1.
                   put stream s_1 unformatted 
                       getStrTrans("Total do Portador: ", "ACR") at 97
                       v_val_tot_portad to 133 format "->>,>>>,>>>,>>9.99"
                       "-" at 135
                       v_num_contador to 144 format ">>>>,>>9"
                       getStrTrans("T°tulo(s)  ", "ACR") at 146 skip.
                   assign v_val_tot     = v_val_tot + v_val_tot_portad
                          v_num_tot_geral = v_num_tot_geral + v_num_contador
                          v_val_tot_portad  = 0.
               end /* if */.
               if  v_ind_tip_destinac <> "Listagem de T°tulos a Destinar" /*l_listagem_de_titulos_a_destinar*/  then do:
               /* **Dados para o custo da destinaá∆o***/
                   find tt_portad_finalid_econ no-lock
                        where tt_portad_finalid_econ.tta_cod_portador     = tt_rpt_tit_acr_destinac.tta_cod_portador
                          and tt_portad_finalid_econ.tta_cod_cart_bcia    = tt_rpt_tit_acr_destinac.tta_cod_cart_bcia
                          and tt_portad_finalid_econ.tta_cod_finalid_econ = destinac_cobr.cod_finalid_econ no-error.
                   find cta_corren
                        where cta_corren.cod_cta_corren = tt_portad_finalid_econ.tta_cod_cta_corren
                        no-lock no-error.
                   find first tt_rpt_calc_custo_acr exclusive-lock
                        where tt_rpt_calc_custo_acr.tta_cod_portador = tt_rpt_tit_acr_destinac.tta_cod_portador
                          and tt_rpt_calc_custo_acr.tta_cod_cart_bcia  = tt_rpt_tit_acr_destinac.tta_cod_cart_bcia no-error.
                   if  not avail tt_rpt_calc_custo_acr
                   then do:
                       create tt_rpt_calc_custo_acr.
                       assign tt_rpt_calc_custo_acr.tta_cod_portador        = tt_rpt_tit_acr_destinac.tta_cod_portador
                              tt_rpt_calc_custo_acr.tta_cod_cart_bcia       = tt_rpt_tit_acr_destinac.tta_cod_cart_bcia
                              tt_rpt_calc_custo_acr.tta_nom_pessoa          = if avail portador then portador.nom_pessoa else ""
                              tt_rpt_calc_custo_acr.ttv_qtd_portador        = 0
                              tt_rpt_calc_custo_acr.ttv_val_destinac_portad = 0
                              tt_rpt_calc_custo_acr.tta_cod_banco           = if avail cta_corren then cta_corren.cod_banco else "".
                   end /* if */.
                   assign tt_rpt_calc_custo_acr.ttv_qtd_portador        = tt_rpt_calc_custo_acr.ttv_qtd_portador + 1
                          tt_rpt_calc_custo_acr.ttv_val_destinac_portad = tt_rpt_calc_custo_acr.ttv_val_destinac_portad + tt_rpt_tit_acr_destinac.tta_val_sdo_tit_acr.
               end.
               /* **Gera tt para envio ao banco***/
               if  destinac_cobr.log_envio_via_edi = yes and v_ind_tip_destinac = "Destinaá∆o" /*l_destinacao*/  then do:
                   find tit_acr no-lock where recid(tit_acr) = tt_rpt_tit_acr_destinac.ttv_rec_tit_acr no-error.
                   if  (index(v_nom_prog_upc, 'epc_acr739ab') > 0 or 
                       index(v_nom_prog_dpc, 'epc_acr739ab') > 0 or    
                       index(v_nom_prog_appc, 'epc_acr739ab') > 0)
                   then do:
                       if  tit_acr.val_sdo_tit_acr  = 0
                       then do: 
                           next.    
                       end /* if */.
                   end /* if */.
                   run pi_retornar_finalid_indic_econ (Input tit_acr.cod_indic_econ,
                                                       Input tit_acr.dat_emis_docto,
                                                       output v_cod_finalid_econ) /*pi_retornar_finalid_indic_econ*/.
                   find movto_tit_acr no-lock
                        where movto_tit_acr.cod_estab      = tt_rpt_tit_acr_destinac.tta_cod_estab
                          and movto_tit_acr.num_id_tit_acr = tt_rpt_tit_acr_destinac.tta_num_id_tit_acr
                        and ( movto_tit_acr.ind_trans_acr = "Implantaá∆o" /*l_implantacao*/ 
                           or movto_tit_acr.ind_trans_acr = "Implantaá∆o a CrÇdito" /*l_implantacao_a_credito*/ 
                           or movto_tit_acr.ind_trans_acr = "Implantaá∆o a DÇbito" /*l_implantacao_a_debito*/ 
                           or movto_tit_acr.ind_trans_acr = "Transf Estabelecimento" /*l_transf_estabelecimento*/ 
                           or movto_tit_acr.ind_trans_acr = "Renegociaá∆o" /*l_renegociacao*/ ) no-error.

                   find first espec_docto_financ_acr no-lock
               	 where espec_docto_financ_acr.cod_espec_docto = tit_acr.cod_espec_docto no-error.
                   if  avail espec_docto_financ_acr
                   and espec_docto_financ_acr.log_habilit_cobr_bcia = no
                   then do:
                       /* ------ Se a espÇcia n∆o estiver habilitado para cobranáa banc†ria, n∆o cria a tt ------- */
                       next.
                   end.

                   create tt_tit_acr_selec_cobr.
                   assign tt_tit_acr_selec_cobr.ttv_rec_tit_acr = tt_rpt_tit_acr_destinac.ttv_rec_tit_acr
                          tt_tit_acr_selec_cobr.ttv_rec_movto_ocor_bcia = ?
                          tt_tit_acr_selec_cobr.ttv_rec_movto_tit_acr   = recid( movto_tit_acr )
                          tt_tit_acr_selec_cobr.tta_cod_estab = tt_rpt_tit_acr_destinac.tta_cod_estab
                          tt_tit_acr_selec_cobr.tta_cod_ser_docto = tt_rpt_tit_acr_destinac.tta_cod_ser_docto
                          tt_tit_acr_selec_cobr.tta_cod_espec_docto = tt_rpt_tit_acr_destinac.tta_cod_espec_docto
                          tt_tit_acr_selec_cobr.tta_cod_tit_acr = tt_rpt_tit_acr_destinac.tta_cod_tit_acr
                          tt_tit_acr_selec_cobr.tta_cod_parcela = tt_rpt_tit_acr_destinac.tta_cod_parcela
                          tt_tit_acr_selec_cobr.tta_cod_portador = tt_rpt_tit_acr_destinac.tta_cod_portador
                          tt_tit_acr_selec_cobr.tta_cod_finalid_econ = v_cod_finalid_econ
                          tt_tit_acr_selec_cobr.tta_cod_cart_bcia = tt_rpt_tit_acr_destinac.tta_cod_cart_bcia
                          tt_tit_acr_selec_cobr.tta_dat_transacao = v_dat_destinac
                          tt_tit_acr_selec_cobr.tta_dat_vencto_tit_acr = tt_rpt_tit_acr_destinac.tta_dat_vencto_tit_acr
                          tt_tit_acr_selec_cobr.ttv_log_selec_tit_acr = yes
                          tt_tit_acr_selec_cobr.tta_log_envdo_edi = yes
                          tt_tit_acr_selec_cobr.tta_ind_trans_acr = movto_tit_acr.ind_trans_acr
                          tt_tit_acr_selec_cobr.tta_ind_tip_ocor_bcia = "Implantaá∆o" /*l_implantacao*/ .
                   if v_log_parc_cartcred
                   then do:
                        assign tt_tit_acr_selec_cobr.ttv_val_sdo_tit_acr = tit_acr.val_sdo_tit_acr
                               tt_tit_acr_selec_cobr.ttv_num_parc_cartcred = 1.
                   end.

               end.
               if  tt_rpt_tit_acr_destinac.tta_cod_portador = destinac_cobr.cod_portad_auto_emis
               and tt_rpt_tit_acr_destinac.tta_cod_cart_bcia = destinac_cobr.cod_cart_bcia_auto_emis
               and tt_rpt_tit_acr_destinac.tta_num_dwb_order = 2
               then assign v_log_auto_emis = yes.
               delete tt_rpt_tit_acr_destinac.
               /* End_Include: i_imprimir_tit_destinac */

           end /* for temp_table */.
        end.
        /* ** Atualiza o spool das contas correntes do CMG */
        run pi_sdo_cta_corren_spool_modulos /*pi_sdo_cta_corren_spool_modulos*/.
        if (line-counter(s_1) + 2) > v_rpt_s_1_bottom then
            page stream s_1.
        put stream s_1 unformatted 
            "--------------" at 120 skip
            getStrTrans("Total Geral: ", "ACR") at 103
            v_val_tot to 133 format "->>,>>>,>>>,>>9.99"
            "-" at 135
            v_num_tot_geral to 144 format ">>>>,>>9"
            getStrTrans("T°tulo(s)  ", "ACR") at 146 skip.
        if  v_ind_tip_destinac <> "Listagem de T°tulos a Destinar" /*l_listagem_de_titulos_a_destinar*/  then do:
            if  v_ind_tip_destinac = "Destinaá∆o" /*l_destinacao*/  then do transaction:
                 assign movto_destinac_cobr.val_tot_movto_destinac_cobr = v_val_tot
                        movto_destinac_cobr.qtd_tot_movto_destinac_cobr = v_num_tot_geral.
            end.
            page stream s_1.
            assign v_des_titulo = "Resultado da Destinaá∆o" /*l_resultado_da_destinacao*/  + " - ".
            if  v_ind_tip_destinac = "Simulaá∆o" /*l_simulacao*/  then
                assign v_des_titulo = v_des_titulo + "Simulaá∆o" /*l_simulacao*/ .
            else assign v_des_titulo = v_des_titulo + "Execuá∆o" /*l_execucao*/ .
            if (line-counter(s_1) + 5) > v_rpt_s_1_bottom then
                page stream s_1.
            put stream s_1 unformatted 
                v_des_titulo at 1 format "x(60)"
                skip (1)
                getStrTrans("Destinaá∆o: ", "ACR") at 1
                destinac_cobr.cod_destinac_cobr at 13 format "x(8)"
                v_des_aux_1 at 33 format "x(40)" skip
                getStrTrans("Finalidade: ", "ACR") at 10
                destinac_cobr.cod_finalid_econ at 22 format "x(10)" skip (1).
            hide stream s_1 frame f_rpt_s_1_Grp_detalhe_Lay_a_dest.
            hide stream s_1 frame f_rpt_s_1_Grp_detalhe_Lay_dest_port.
            hide stream s_1 frame f_rpt_s_1_Grp_detalhe_Lay_erros.
            hide stream s_1 frame f_rpt_s_1_Grp_detalhe_Lay_tit_dest.
            view stream s_1 frame f_rpt_s_1_Grp_detalhe_Lay_resumo_port.
            if (line-counter(s_1) + 3) > v_rpt_s_1_bottom then
                page stream s_1.
            put stream s_1 unformatted 
                getStrTrans("Port", "ACR") at 1
                getStrTrans("Cart", "ACR") at 7
                getStrTrans("Quantidade", "ACR") to 21
                getStrTrans("Vl Destinado", "ACR") to 36
                getStrTrans("Custo", "ACR") to 51
                getStrTrans("% Custo", "ACR") to 59
                getStrTrans("Sdo Cobr Ant", "ACR") to 78
                getStrTrans("Saldo Cobranáa", "ACR") to 97
                getStrTrans("Meta Dest", "ACR") to 116
                getStrTrans("Observaá‰es", "ACR") at 118 skip
                "-----" at 1
                "----" at 7
                "----------" to 21
                "--------------" to 36
                "--------------" to 51
                "-------" to 59
                "------------------" to 78
                "------------------" to 97
                "------------------" to 116
                "---------------------------" at 118 skip.
            resul_table:
            for each tt_item_destinac_cobr_dest no-lock:
                find first tt_portad_finalid_econ no-lock
                     where tt_portad_finalid_econ.tta_cod_portador = tt_item_destinac_cobr_dest.cod_portador
                     and tt_portad_finalid_econ.tta_cod_cart_bcia = tt_item_destinac_cobr_dest.cod_cart_bcia
                     and tt_portad_finalid_econ.tta_cod_finalid_econ = destinac_cobr.cod_finalid_econ
                     no-error.
                assign v_des_obs_destinac = "".
                if  not avail tt_portad_finalid_econ then do:
                    create tt_portad_finalid_econ.
                    assign tt_portad_finalid_econ.tta_cod_portador = tt_item_destinac_cobr_dest.cod_portador
                         tt_portad_finalid_econ.tta_cod_cart_bcia = tt_item_destinac_cobr_dest.cod_cart_bcia
                         tt_portad_finalid_econ.tta_cod_finalid_econ = destinac_cobr.cod_finalid_econ
                         tt_portad_finalid_econ.tta_cod_cta_corren = ""
                         tt_portad_finalid_econ.tta_val_sdo_cobr = 0
                         tt_portad_finalid_econ.ttv_val_sdo_cobr_ant = 0.
                    assign v_des_obs_destinac = getStrTrans("N∆o existe Portador Finalidade Econìmica.", "ACR") /*4986*/.
                end.
                if  tt_portad_finalid_econ.ttv_val_meta_destinac = 0 then do:
                    if  destinac_cobr.log_control_perc_destinac = no
                    then assign v_val_destinac_portad = tt_item_destinac_cobr_dest.val_niv_cobr.
                    else assign v_val_destinac_portad = tt_item_destinac_cobr_dest.val_perc_niv_cobr * v_val_tot_cobr / 100.
                    assign tt_portad_finalid_econ.ttv_val_meta_destinac = v_val_destinac_portad.
                end.
                find tt_rpt_calc_custo_acr no-lock
                     where tt_rpt_calc_custo_acr.tta_cod_portador  = tt_item_destinac_cobr_dest.cod_portador
                     and tt_rpt_calc_custo_acr.tta_cod_cart_bcia = tt_item_destinac_cobr_dest.cod_cart_bcia no-error.
                if  not avail tt_rpt_calc_custo_acr then do:
                    create tt_rpt_calc_custo_acr.
                    assign tt_rpt_calc_custo_acr.tta_cod_portador = tt_item_destinac_cobr_dest.cod_portador
                         tt_rpt_calc_custo_acr.tta_nom_pessoa = ""
                         tt_rpt_calc_custo_acr.tta_cod_cart_bcia = tt_item_destinac_cobr_dest.cod_cart_bcia
                         tt_rpt_calc_custo_acr.ttv_qtd_portador = 0
                         tt_rpt_calc_custo_acr.ttv_val_destinac_portad = 0
                         tt_rpt_calc_custo_acr.ttv_val_cust_acr = 0
                         tt_rpt_calc_custo_acr.ttv_val_perc_cust = 0
                         tt_rpt_calc_custo_acr.tta_cod_banco = "".
                end.
                find ocor_bcia_bco no-lock
                    where ocor_bcia_bco.cod_banco = tt_rpt_calc_custo_acr.tta_cod_banco
                    and ocor_bcia_bco.cod_modul_dtsul = "ACR" /*l_acr*/ 
                    and ocor_bcia_bco.ind_ocor_bcia_remes_ret = "Remessa" /*l_remessa*/ 
                    and ocor_bcia_bco.ind_tip_ocor_bcia = "Implantaá∆o" /*l_implantacao*/ 
                    and ocor_bcia_bco.dat_inic_valid <= v_dat_destinac
                    and ocor_bcia_bco.dat_fim_valid >  v_dat_destinac
                    no-error.
                if  avail ocor_bcia_bco
                then do:

                     /* Begin_Include: i_acha_cotac_custo_destinac */
                     if  ocor_bcia_bco.cod_finalid_econ = destinac_cobr.cod_finalid_econ then do:
                         assign v_val_cotac_indic_econ = 1.
                     end.
                     else do:
                         run pi_retornar_indic_econ_finalid (Input ocor_bcia_bco.cod_finalid_econ,
                                                             Input v_dat_destinac,
                                                             output v_cod_indic_econ_bco) /*pi_retornar_indic_econ_finalid*/.
                         run pi_achar_cotac_indic_econ (Input v_cod_indic_econ_bco,
                                                        Input v_cod_indic_econ_des,
                                                        Input v_dat_destinac,
                                                        Input "Real" /*l_real*/,
                                                        output v_dat_cotac_indic_econ,
                                                        output v_val_cotac_indic_econ,
                                                        output v_cod_return) /*pi_achar_cotac_indic_econ*/.
                         if  v_cod_return <> "OK" /*l_ok*/  then do:
                             assign v_val_cotac_indic_econ = 0.
                             if  v_des_obs_destinac = "" then do:
                                 assign v_des_obs_destinac = substitute( getStrTrans("Cotaá∆o do tipo Real inexistente entre &1 e &2 em &3 para c†lculo do Custo da Destinaá∆o.", "ACR") /*4996*/, v_cod_indic_econ_bco, v_cod_indic_econ_des, v_dat_destinac ).
                             end.
                         end.
                     end.
                     /* End_Include: i_acha_cotac_custo_destinac */

                     assign tt_rpt_calc_custo_acr.ttv_val_cust_acr  = tt_rpt_calc_custo_acr.ttv_qtd_portador * ( ocor_bcia_bco.val_ocor_bcia_bco / v_val_cotac_indic_econ )
                            tt_rpt_calc_custo_acr.ttv_val_perc_cust = (tt_rpt_calc_custo_acr.ttv_val_cust_acr * 100 / tt_rpt_calc_custo_acr.ttv_val_destinac_portad).
                end /* if */.
                assign v_val_tot_destinac = v_val_tot_destinac + tt_rpt_calc_custo_acr.ttv_val_destinac_portad
                     v_val_tot_cust = v_val_tot_cust + tt_rpt_calc_custo_acr.ttv_val_cust_acr
                     v_val_sdo_cobr_ant = v_val_sdo_cobr_ant + tt_portad_finalid_econ.ttv_val_sdo_cobr_ant
                     v_val_sdo_cobr = v_val_sdo_cobr + tt_portad_finalid_econ.tta_val_sdo_cobr
                     v_val_meta_destinac = v_val_meta_destinac + tt_portad_finalid_econ.ttv_val_meta_destinac.
                 run pi_print_editor ("s_1", v_des_obs_destinac, "     027", "", "     ", "", "     ").
                 assign v_des_return_value_editor = return-value.
                 put stream s_1 unformatted 
                     tt_rpt_calc_custo_acr.tta_cod_portador at 1 format "x(5)"
                     tt_rpt_calc_custo_acr.tta_cod_cart_bcia at 7 format "x(3)"
                     tt_rpt_calc_custo_acr.ttv_qtd_portador to 21 format ">>,>>>,>>9"
                     tt_rpt_calc_custo_acr.ttv_val_destinac_portad to 36 format ">>>,>>>,>>9.99"
                     tt_rpt_calc_custo_acr.ttv_val_cust_acr to 51 format ">>>,>>>,>>9.99"
                     tt_rpt_calc_custo_acr.ttv_val_perc_cust to 59 format ">>9.99"
                     tt_portad_finalid_econ.ttv_val_sdo_cobr_ant to 78 format ">>>,>>>,>>>,>>9.99"
                     tt_portad_finalid_econ.tta_val_sdo_cobr to 97 format ">>>,>>>,>>>,>>9.99".
    put stream s_1 unformatted 
                     tt_portad_finalid_econ.ttv_val_meta_destinac to 116 format ">>>,>>>,>>>,>>9.99"
                     entry(1, v_des_return_value_editor, chr(255)) at 118 format "x(27)" skip.
                 run pi_print_editor ("s_1", v_des_obs_destinac, "at111027", "", "", "", "").
                 assign v_des_return_value_editor = return-value.
                 delete tt_rpt_calc_custo_acr.
            end /* for resul_table */.
    /* **Impress∆o da Situaá∆o Ap¢s e Custos da Destinaá∆o de portadores preferenciais que n∆o estejam na regra.***/
            resul_table:
            for each tt_rpt_calc_custo_acr no-lock:
                find first tt_portad_finalid_econ no-lock
                     where tt_portad_finalid_econ.tta_cod_portador = tt_rpt_calc_custo_acr.tta_cod_portador
                     and tt_portad_finalid_econ.tta_cod_cart_bcia = tt_rpt_calc_custo_acr.tta_cod_cart_bcia
                     and tt_portad_finalid_econ.tta_cod_finalid_econ = destinac_cobr.cod_finalid_econ
                     no-error.
                if  tt_portad_finalid_econ.tta_cod_portador = destinac_cobr.cod_portad_auto_emis
                    and tt_portad_finalid_econ.tta_cod_cart_bcia = destinac_cobr.cod_cart_bcia_auto_emis
                    and v_log_auto_emis = yes 
                    then assign v_des_obs_destinac = "Portador auto-emiss∆o." /*l_portador_auto_emis*/ .
                    else assign v_des_obs_destinac = "Portador Preferencial." /*l_portador_preferencial*/ .
                find ocor_bcia_bco no-lock
                    where ocor_bcia_bco.cod_banco = tt_rpt_calc_custo_acr.tta_cod_banco
                    and ocor_bcia_bco.cod_modul_dtsul = "ACR" /*l_acr*/ 
                    and ocor_bcia_bco.ind_ocor_bcia_remes_ret = "Remessa" /*l_remessa*/ 
                    and ocor_bcia_bco.ind_tip_ocor_bcia = "Remessa" /*l_remessa*/ 
                    and ocor_bcia_bco.dat_inic_valid <= v_dat_destinac
                    and ocor_bcia_bco.dat_fim_valid  >  v_dat_destinac
                    no-error.
                if  avail ocor_bcia_bco
                then do:

                     /* Begin_Include: i_acha_cotac_custo_destinac */
                     if  ocor_bcia_bco.cod_finalid_econ = destinac_cobr.cod_finalid_econ then do:
                         assign v_val_cotac_indic_econ = 1.
                     end.
                     else do:
                         run pi_retornar_indic_econ_finalid (Input ocor_bcia_bco.cod_finalid_econ,
                                                             Input v_dat_destinac,
                                                             output v_cod_indic_econ_bco) /*pi_retornar_indic_econ_finalid*/.
                         run pi_achar_cotac_indic_econ (Input v_cod_indic_econ_bco,
                                                        Input v_cod_indic_econ_des,
                                                        Input v_dat_destinac,
                                                        Input "Real" /*l_real*/,
                                                        output v_dat_cotac_indic_econ,
                                                        output v_val_cotac_indic_econ,
                                                        output v_cod_return) /*pi_achar_cotac_indic_econ*/.
                         if  v_cod_return <> "OK" /*l_ok*/  then do:
                             assign v_val_cotac_indic_econ = 0.
                             if  v_des_obs_destinac = "" then do:
                                 assign v_des_obs_destinac = substitute( getStrTrans("Cotaá∆o do tipo Real inexistente entre &1 e &2 em &3 para c†lculo do Custo da Destinaá∆o.", "ACR") /*4996*/, v_cod_indic_econ_bco, v_cod_indic_econ_des, v_dat_destinac ).
                             end.
                         end.
                     end.
                     /* End_Include: i_acha_cotac_custo_destinac */

                     assign tt_rpt_calc_custo_acr.ttv_val_cust_acr  = tt_rpt_calc_custo_acr.ttv_qtd_portador * ( ocor_bcia_bco.val_ocor_bcia_bco / v_val_cotac_indic_econ )
                            tt_rpt_calc_custo_acr.ttv_val_perc_cust = (tt_rpt_calc_custo_acr.ttv_val_cust_acr * 100 / tt_rpt_calc_custo_acr.ttv_val_destinac_portad).
                end /* if */.
                assign v_val_tot_destinac = v_val_tot_destinac + tt_rpt_calc_custo_acr.ttv_val_destinac_portad
                     v_val_tot_cust = v_val_tot_cust + tt_rpt_calc_custo_acr.ttv_val_cust_acr
                     v_val_sdo_cobr_ant = v_val_sdo_cobr_ant + tt_portad_finalid_econ.ttv_val_sdo_cobr_ant
                     v_val_sdo_cobr = v_val_sdo_cobr + tt_portad_finalid_econ.tta_val_sdo_cobr
                     v_val_meta_destinac = v_val_meta_destinac + tt_portad_finalid_econ.ttv_val_meta_destinac.
                run pi_print_editor ("s_1", v_des_obs_destinac, "     027", "", "     ", "", "     ").
                assign v_des_return_value_editor = return-value.
                put stream s_1 unformatted 
                    tt_rpt_calc_custo_acr.tta_cod_portador at 1 format "x(5)"
                    tt_rpt_calc_custo_acr.tta_cod_cart_bcia at 7 format "x(3)"
                    tt_rpt_calc_custo_acr.ttv_qtd_portador to 21 format ">>,>>>,>>9"
                    tt_rpt_calc_custo_acr.ttv_val_destinac_portad to 36 format ">>>,>>>,>>9.99"
                    tt_rpt_calc_custo_acr.ttv_val_cust_acr to 51 format ">>>,>>>,>>9.99"
                    tt_rpt_calc_custo_acr.ttv_val_perc_cust to 59 format ">>9.99"
                    tt_portad_finalid_econ.ttv_val_sdo_cobr_ant to 78 format ">>>,>>>,>>>,>>9.99"
                    tt_portad_finalid_econ.tta_val_sdo_cobr to 97 format ">>>,>>>,>>>,>>9.99".
    put stream s_1 unformatted 
                    tt_portad_finalid_econ.ttv_val_meta_destinac to 116 format ">>>,>>>,>>>,>>9.99"
                    entry(1, v_des_return_value_editor, chr(255)) at 118 format "x(27)" skip.
                run pi_print_editor ("s_1", v_des_obs_destinac, "at111027", "", "", "", "").
                assign v_des_return_value_editor = return-value.
                delete tt_rpt_calc_custo_acr.

            end /* for resul_table */.

            if (line-counter(s_1) + 2) > v_rpt_s_1_bottom then
                page stream s_1.
            put stream s_1 unformatted 
                "--------------" at 23
                "--------------" at 38
                "------------------" at 61
                "------------------" at 80
                "------------------" at 99 skip
                getStrTrans("Totais:  ", "ACR") at 1
                v_val_tot_destinac to 36 format ">>>,>>>,>>9.99".
    put stream s_1 unformatted 
                v_val_tot_cust to 51 format ">>>,>>>,>>9.99"
                v_val_sdo_cobr_ant to 78 format ">>>,>>>,>>>,>>9.99"
                v_val_sdo_cobr to 97 format ">>>,>>>,>>>,>>9.99"
                v_val_meta_destinac to 116 format ">>>,>>>,>>>,>>9.99" skip.
        end.
        hide stream s_1 frame f_rpt_s_1_Grp_detalhe_Lay_resumo_port.
    end.

    /* ---Listar Consistància de T°tulos N∆o Destinados---*/
    if v_log_funcao_tit_nao_dest = yes and v_ind_tip_destinac <> "Listagem de T°tulos a Destinar" /*l_listagem_de_titulos_a_destinar*/  then do:
       if v_log_tit_nao_destndo = yes then 
          run pi_imprimir_tit_acr_nao_destinados /*pi_imprimir_tit_acr_nao_destinados*/.
    end.
    else do:
       run pi_imprimir_tit_acr_nao_destinados /*pi_imprimir_tit_acr_nao_destinados*/.
    end.

    hide stream s_1 frame f_rpt_s_1_footer_normal.
    hide stream s_1 frame f_rpt_s_1_footer_param_page.
    view stream s_1 frame f_rpt_s_1_footer_last_page.
    /* **Gera envio de t°tulos ao banco***/
    if destinac_cobr.log_envio_via_edi = yes and v_ind_tip_destinac = "Destinaá∆o" /*l_destinacao*/ 
    then do:
       run prgfin/acr/acr757zb.py /*prg_fnc_enviar_msg_cobr_edi*/.

        find first tt_tit_acr_selec_erro_parceiro no-lock no-error.
        if avail tt_tit_acr_selec_erro_parceiro then do:
           page stream s_1.
           assign v_des_titulo = "Log Erros Envio Escritural" /*l_log_erros_envio_escrit*/ 
                  v_des_aux_1  = ''.
        end.

       /* Verifica parceiro que n∆o podem fazer a exportaá∆o por n∆o estarem como completos. */
       erros_ret_edi:
       for each tt_tit_acr_selec_erro_parceiro no-lock
           break by tt_tit_acr_selec_erro_parceiro.tta_cod_transacao
                 by tt_tit_acr_selec_erro_parceiro.tta_cdn_parcei_edi:

           if (line-counter(s_1) + 5) > v_rpt_s_1_bottom then
               page stream s_1.
           put stream s_1 unformatted 
               v_des_titulo at 1 format "x(60)"
               skip (1)
               getStrTrans("Destinaá∆o: ", "ACR") at 1
               destinac_cobr.cod_destinac_cobr at 13 format "x(8)"
               v_des_aux_1 at 33 format "x(40)" skip
               getStrTrans("Finalidade: ", "ACR") at 10
               destinac_cobr.cod_finalid_econ at 22 format "x(10)" skip (1).

           if first-of(tt_tit_acr_selec_erro_parceiro.tta_cod_transacao) then do:
              if (line-counter(s_1) + 5) > v_rpt_s_1_bottom then
                  page stream s_1.
              put stream s_1 unformatted 
                  skip (1)
                  getStrTrans("Transaá∆o", "ACR") at 29
                  getStrTrans("Parceiro", "ACR") to 47 skip
                  "-------------------" at 29 skip. 
           end.
           run pi_print_editor ("s_1", tt_tit_acr_selec_erro_parceiro.ttv_des_ajuda, "     050", "", "     ", "", "     ").
           assign v_des_return_value_editor = return-value.
           put stream s_1 unformatted 
               skip (1)
               tt_tit_acr_selec_erro_parceiro.tta_cod_transacao at 29 format "x(10)"
               tt_tit_acr_selec_erro_parceiro.tta_cdn_parcei_edi to 47 format ">>>>>9"
               entry(1, v_des_return_value_editor, chr(255)) at 49 format "x(50)" skip.
           run pi_print_editor ("s_1", tt_tit_acr_selec_erro_parceiro.ttv_des_ajuda, "at049050", "", "", "", "").
           assign v_des_return_value_editor = return-value.
       end /* for erros_ret_edi */.
    end.

END PROCEDURE. /* pi_imprimir_tit_acr_destinac */
/*****************************************************************************
** Procedure Interna.....: pi_sec_to_formatted_time
** Descricao.............: pi_sec_to_formatted_time
** Criado por............: 
** Criado em.............: // 
** Alterado por..........: 
** Alterado em...........: 01/02/1995 10:47:54
*****************************************************************************/
PROCEDURE pi_sec_to_formatted_time:

    /************************ Parameter Definition Begin ************************/

    def Input param p_num_seconds
        as integer
        format ">>>,>>9"
        no-undo.
    def output param p_hra_formatted_time
        as Character
        format "99:99:99"
        no-undo.


    /************************* Parameter Definition End *************************/

    assign p_hra_formatted_time = replace(string(p_num_seconds,"hh:mm:ss" /*l_hh:mm:ss*/ ),":","").

END PROCEDURE. /* pi_sec_to_formatted_time */
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
** Procedure Interna.....: pi_tratar_item_movto_destinac_cobr
** Descricao.............: pi_tratar_item_movto_destinac_cobr
** Criado por............: Alexsandra
** Criado em.............: 11/10/1996 15:10:31
** Alterado por..........: brv117
** Alterado em...........: 15/07/1998 11:33:10
*****************************************************************************/
PROCEDURE pi_tratar_item_movto_destinac_cobr:

    /************************ Parameter Definition Begin ************************/

    def Input param p_val_tot_cart_bcia
        as decimal
        format "->>,>>>,>>>,>>9.99"
        decimals 2
        no-undo.
    def Input param p_num_count
        as integer
        format ">>>>,>>9"
        no-undo.


    /************************* Parameter Definition End *************************/

    create item_movto_destinac_cobr.
    assign item_movto_destinac_cobr.cod_estab                = tt_rpt_tit_acr_destinac.tta_cod_estab
           item_movto_destinac_cobr.dat_movto_destinac_cobr  = v_dat_destinac
           item_movto_destinac_cobr.hra_movto_destinac_cobr  = v_hra_formatted_time
           item_movto_destinac_cobr.cod_portador             = tt_rpt_tit_acr_destinac.tta_cod_portador
           item_movto_destinac_cobr.cod_cart_bcia            = tt_rpt_tit_acr_destinac.tta_cod_cart_bcia
           item_movto_destinac_cobr.cod_finalid_econ         = destinac_cobr.cod_finalid_econ
           item_movto_destinac_cobr.val_destinac_cobr_portad = p_val_tot_cart_bcia
           item_movto_destinac_cobr.qtd_destinac_cobr_portad = p_num_count.
END PROCEDURE. /* pi_tratar_item_movto_destinac_cobr */
/*****************************************************************************
** Procedure Interna.....: pi_atualiza_tabelas_destinac
** Descricao.............: pi_atualiza_tabelas_destinac
** Criado por............: Roberto
** Criado em.............: 01/09/1997 15:11:51
** Alterado por..........: its338335
** Alterado em...........: 25/05/2007 09:40:36
*****************************************************************************/
PROCEDURE pi_atualiza_tabelas_destinac:

    /************************ Parameter Definition Begin ************************/

    def Input param p_log_prepdo_destinac
        as logical
        format "Sim/N∆o"
        no-undo.
    def input param p_cod_portador
        as character
        format "x(5)"
        no-undo.
    def Input param p_cod_cart_bcia
        as character
        format "x(3)"
        no-undo.
    def Input param p_des_mensagem
        as character
        format "x(50)"
        no-undo.
    def Input param p_num_ord_destinac
        as integer
        format ">>>>,>>9"
        no-undo.
    def Input param p_num_dwb_order
        as integer
        format ">>>>,>>9"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_cod_cart_bcia_antigo           as character       no-undo. /*local*/
    def var v_cod_portad_antigo              as character       no-undo. /*local*/


    /************************** Variable Definition End *************************/

    assign v_cod_portad_antigo    = tit_acr.cod_portador
           v_cod_cart_bcia_antigo = tit_acr.cod_cart_bcia.

    if  p_log_prepdo_destinac = yes
    or  tt_rpt_tit_acr_destinac.ttv_cod_order = "0" then do:
        assign tt_rpt_tit_acr_destinac.tta_cod_portador    = p_cod_portador
               tt_rpt_tit_acr_destinac.tta_cod_cart_bcia   = p_cod_cart_bcia
               tt_rpt_tit_acr_destinac.ttv_cod_order       = string( p_num_ord_destinac )
               tt_rpt_tit_acr_destinac.ttv_des_obs_campo   = p_des_mensagem
               tt_rpt_tit_acr_destinac.tta_num_dwb_order   = p_num_dwb_order.
    end.
    else do:
        assign tt_rpt_tit_acr_destinac.tta_cod_portador    = tt_rpt_tit_acr_destinac.tta_cod_portador  + chr(10) + p_cod_portador
               tt_rpt_tit_acr_destinac.tta_cod_cart_bcia   = tt_rpt_tit_acr_destinac.tta_cod_cart_bcia + chr(10) + p_cod_cart_bcia
               tt_rpt_tit_acr_destinac.ttv_cod_order       = tt_rpt_tit_acr_destinac.ttv_cod_order     + chr(10) + string( p_num_ord_destinac )
               tt_rpt_tit_acr_destinac.ttv_des_obs_campo   = tt_rpt_tit_acr_destinac.ttv_des_obs_campo + chr(10) + p_des_mensagem
               tt_rpt_tit_acr_destinac.tta_num_dwb_order   = p_num_dwb_order.
    end.

    if  p_log_prepdo_destinac = yes then do:

        /* ** ATUALIZA SDO_PORTAD NA TEMP-TABLE ***/
        find tt_portad_finalid_econ exclusive-lock
             where tt_portad_finalid_econ.tta_cod_portador     = p_cod_portador
               and tt_portad_finalid_econ.tta_cod_cart_bcia    = p_cod_cart_bcia
               and tt_portad_finalid_econ.tta_cod_finalid_econ = destinac_cobr.cod_finalid_econ
             no-error.
        if  avail tt_portad_finalid_econ then
            assign tt_portad_finalid_econ.tta_val_sdo_cobr    = tt_portad_finalid_econ.tta_val_sdo_cobr
                                                              + tit_acr.val_sdo_tit_acr
                   tt_portad_finalid_econ.ttv_val_tot_destndo = tt_portad_finalid_econ.ttv_val_tot_destndo
                                                              + tit_acr.val_sdo_tit_acr.
        find tt_portad_finalid_econ exclusive-lock
             where tt_portad_finalid_econ.tta_cod_portador     = tit_acr.cod_portador
               and tt_portad_finalid_econ.tta_cod_cart_bcia    = tit_acr.cod_cart_bcia
               and tt_portad_finalid_econ.tta_cod_finalid_econ = destinac_cobr.cod_finalid_econ
             no-error.
        if  avail tt_portad_finalid_econ then
            assign tt_portad_finalid_econ.tta_val_sdo_cobr = tt_portad_finalid_econ.tta_val_sdo_cobr
                                                           - tit_acr.val_sdo_tit_acr.

        /* ** EFETIVA ATUALIZAÄÂES ***/
        if  v_ind_tip_destinac = "Destinaá∆o" /*l_destinacao*/  then do:
            assign v_cod_portador    = p_cod_portador
                   v_cod_cart_bcia_1 = p_cod_cart_bcia.
            create tt_atualiza_destinac_tit_acr.
            assign tt_atualiza_destinac_tit_acr.tta_cod_estab_tit_acr = tit_acr.cod_estab            
                   tt_atualiza_destinac_tit_acr.tta_cod_espec_docto   = tit_acr.cod_espec_docto
                   tt_atualiza_destinac_tit_acr.tta_cod_ser_docto     = tit_acr.cod_ser_docto
                   tt_atualiza_destinac_tit_acr.tta_cod_tit_acr       = tit_acr.cod_tit_acr
                   tt_atualiza_destinac_tit_acr.tta_cod_parcela       = tit_acr.cod_parcela
                   tt_atualiza_destinac_tit_acr.ttv_cod_portador_old  = tit_acr.cod_portador
                   tt_atualiza_destinac_tit_acr.ttv_cod_cart_bcia_old = tit_acr.cod_cart_bcia
                   tt_atualiza_destinac_tit_acr.ttv_cod_portador_new  = v_cod_portador
                   tt_atualiza_destinac_tit_acr.ttv_cod_cart_bcia_new = v_cod_cart_bcia_1
                   tt_atualiza_destinac_tit_acr.tta_cod_finalid_econ  = destinac_cobr.cod_finalid_econ
                   tt_atualiza_destinac_tit_acr.tta_val_sdo_cobr      = tit_acr.val_sdo_tit_acr.
        end.
        assign v_val_retenc_impto_esp = 0
               v_cod_portad_espcif = v_cod_portador
               v_cod_cart_espcif   = v_cod_cart_bcia_1
               v_cod_finalid_econ_espcif = destinac_cobr.cod_finalid_econ.

        /* Begin_Include: i_exec_program_epc */
        &if '{&emsbas_version}' > '1.00' &then
        if  v_nom_prog_upc <> '' then
        do:
            assign v_rec_table_epc = recid(tit_acr).    
            run value(v_nom_prog_upc) (input 'Atualiza tabelas destinac',
                                       input 'viewer',
                                       input this-procedure,
                                       input v_wgh_frame_epc,
                                       input v_nom_table_epc,
                                       input v_rec_table_epc).
            if  'yes' = 'yes'
            and return-value = 'NOK' then
                undo, retry.
        end.

        if  v_nom_prog_appc <> '' then
        do:
            assign v_rec_table_epc = recid(tit_acr).    
            run value(v_nom_prog_appc) (input 'Atualiza tabelas destinac',
                                        input 'viewer',
                                        input this-procedure,
                                        input v_wgh_frame_epc,
                                        input v_nom_table_epc,
                                        input v_rec_table_epc).
            if  'yes' = 'yes'
            and return-value = 'NOK' then
                undo, retry.
        end.

        &if '{&emsbas_version}' > '5.00' &then
        if  v_nom_prog_dpc <> '' then
        do:
            assign v_rec_table_epc = recid(tit_acr).    
            run value(v_nom_prog_dpc) (input 'Atualiza tabelas destinac',
                                        input 'viewer',
                                        input this-procedure,
                                        input v_wgh_frame_epc,
                                        input v_nom_table_epc,
                                        input v_rec_table_epc).
            if  'yes' = 'yes'
            and return-value = 'NOK' then
                undo, retry.
        end.
        &endif
        &endif
        /* End_Include: i_exec_program_epc */

        /* Alterado conforme FO 1471.907 - IPP Envio da Cobr Escritural - Valor l≠quido - Cliente: AlphaPrint*/
        if avail(tt_atualiza_destinac_tit_acr) and v_val_retenc_impto_esp > 0.00 and tit_acr.val_sdo_tit_acr > 0 then
            assign tt_atualiza_destinac_tit_acr.tta_val_sdo_cobr      = tit_acr.val_sdo_tit_acr - v_val_retenc_impto_esp
                   tt_rpt_tit_acr_destinac.tta_val_sdo_tit_acr = tit_acr.val_sdo_tit_acr - v_val_retenc_impto_esp.
        if avail(tt_atualiza_destinac_tit_acr) and v_val_retenc_impto_esp > 0.00 and tit_acr.val_sdo_tit_acr = 0 then
            assign tt_atualiza_destinac_tit_acr.tta_val_sdo_cobr      = 0
                   tt_rpt_tit_acr_destinac.tta_val_sdo_tit_acr = 0.
    end.
END PROCEDURE. /* pi_atualiza_tabelas_destinac */
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

    def var v_log_indic
        as logical
        format "Sim/N∆o"
        initial no
        no-undo.
    def var v_cod_indic_econ_orig            as character       no-undo. /*local*/
    def var v_dat_cotac_mes                  as date            no-undo. /*local*/
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

            /* period_block: */
            case parid_indic_econ.ind_periodic_cotac:
                when "Di†ria" /*l_diaria*/ then
                    diaria_block:
                    do:
                        find cotac_parid no-lock
                             where cotac_parid.cod_indic_econ_base = p_cod_indic_econ_base
                               and cotac_parid.cod_indic_econ_idx = p_cod_indic_econ_idx
                               and cotac_parid.dat_cotac_indic_econ = p_dat_transacao
                               and cotac_parid.ind_tip_cotac_parid = p_ind_tip_cotac_parid
                             use-index ctcprd_id no-error.
                        if  not avail cotac_parid or cotac_parid.val_cotac_indic_econ = 0
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
                        end /* if */.
                    end /* do diaria_block */.
                when "Mensal" /*l_mensal*/ then
                    mensal_block:
                    do:
                        assign v_dat_cotac_mes = date(month(p_dat_transacao), 1, year(p_dat_transacao))
                               v_log_indic = yes.
                        find cotac_parid no-lock
                             where cotac_parid.cod_indic_econ_base = p_cod_indic_econ_base
                               and cotac_parid.cod_indic_econ_idx = p_cod_indic_econ_idx
                               and cotac_parid.dat_cotac_indic_econ = v_dat_cotac_mes
                               and cotac_parid.ind_tip_cotac_parid = p_ind_tip_cotac_parid
                             use-index ctcprd_id no-error.
                        if  not avail cotac_parid or cotac_parid.val_cotac_indic_econ = 0
                        then do:
                            /* block: */
                            case parid_indic_econ.ind_criter_busca:
                                when "Anterior" /*l_anterior*/ then
                                find prev cotac_parid no-lock
                                                   where cotac_parid.cod_indic_econ_base = p_cod_indic_econ_base
                                                     and cotac_parid.cod_indic_econ_idx = p_cod_indic_econ_idx
                                                     and cotac_parid.dat_cotac_indic_econ < v_dat_cotac_mes
                                                     and cotac_parid.ind_tip_cotac_parid = p_ind_tip_cotac_parid
                                                     and cotac_parid.val_cotac_indic_econ <> 0.0
                                                   use-index ctcprd_id no-error.
                                when "Pr¢ximo" /*l_proximo*/ then
                                find next cotac_parid no-lock
                                                   where cotac_parid.cod_indic_econ_base = p_cod_indic_econ_base
                                                     and cotac_parid.cod_indic_econ_idx = p_cod_indic_econ_idx
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
** Procedure Interna.....: pi_imprimir_tit_acr_nao_destinados
** Descricao.............: pi_imprimir_tit_acr_nao_destinados
** Criado por............: roberto
** Criado em.............: 06/11/1997 09:47:41
** Alterado por..........: bre18732
** Alterado em...........: 01/04/2004 10:56:17
*****************************************************************************/
PROCEDURE pi_imprimir_tit_acr_nao_destinados:

    /************************* Variable Definition Begin ************************/

    def var v_num_erro
        as integer
        format ">>>>,>>9":U
        no-undo.


    /************************** Variable Definition End *************************/

    if  v_ind_tip_destinac <> "Listagem de T°tulos a Destinar" /*l_listagem_de_titulos_a_destinar*/  then do:
        assign v_val_tot       = 0
               v_num_tot_geral = 0.

        /* ** IMPRESSAO DOS NAO-DESTINADOS ***/
        if  can-find(first tt_rpt_tit_acr_destinac)
                then do:
            assign v_num_nao_destndo = 0.

            page stream s_1.

            if  v_ind_tip_destinac = "Simulaá∆o" /*l_simulacao*/  then do:
                assign v_des_titulo = "Relaá∆o dos T°tulos N∆o Destinados" /*l_relac_tit_nao_destin*/  + " - " + "Simulaá∆o" /*l_simulacao*/ .
            end.
            else do:
                assign v_des_titulo = "Relaá∆o dos T°tulos N∆o Destinados" /*l_relac_tit_nao_destin*/  + " - " + "Execuá∆o" /*l_execucao*/ .
            end.
            if (line-counter(s_1) + 5) > v_rpt_s_1_bottom then
                page stream s_1.
            put stream s_1 unformatted 
                v_des_titulo at 1 format "x(60)"
                skip (1)
                getStrTrans("Destinaá∆o: ", "ACR") at 1
                destinac_cobr.cod_destinac_cobr at 13 format "x(8)"
                v_des_aux_1 at 33 format "x(40)" skip
                getStrTrans("Finalidade: ", "ACR") at 10
                destinac_cobr.cod_finalid_econ at 22 format "x(10)" skip (1).

            hide stream s_1 frame f_rpt_s_1_Grp_detalhe_Lay_a_dest.
            hide stream s_1 frame f_rpt_s_1_Grp_detalhe_Lay_erros.
            hide stream s_1 frame f_rpt_s_1_Grp_detalhe_Lay_resumo_port.
            hide stream s_1 frame f_rpt_s_1_Grp_detalhe_Lay_tit_dest.
            view stream s_1 frame f_rpt_s_1_Grp_detalhe_Lay_dest_port.
            if (line-counter(s_1) + 3) > v_rpt_s_1_bottom then
                page stream s_1.
            put stream s_1 unformatted 
                getStrTrans("Estab", "ACR") at 1
                getStrTrans("Esp", "ACR") at 7
                getStrTrans("SÇrie", "ACR") at 11
                getStrTrans("T°tulo", "ACR") at 17
                getStrTrans("/P", "ACR") at 34
                getStrTrans("Cliente", "ACR") to 47
                getStrTrans("Nome Abrev", "ACR") at 49
                getStrTrans("Cidade", "ACR") at 65
                getStrTrans("Emiss∆o", "ACR") at 98
                getStrTrans("Vencto", "ACR") at 109
                getStrTrans("Saldo T°tulo", "ACR") to 133
                getStrTrans("Ordem", "ACR") to 142
                getStrTrans("Port", "ACR") at 144
                getStrTrans("Cart", "ACR") at 150
                getStrTrans("Observaá‰es", "ACR") at 155 skip
                "-----" at 1
                "---" at 7
                "-----" at 11
                "----------------" at 17
                "--" at 34
                "-----------" to 47
                "---------------" at 49
                "--------------------------------" at 65
                "----------" at 98
                "----------" at 109
                "--------------" to 133
                "--------" to 142
                "-----" at 144
                "----" at 150
                "-------------------------------------------------------------" at 155 skip.

            if v_ind_classif_destinac = "Estab/Portador/Carteira/Dt Emiss∆o/T°tulo/Parcela" /*l_emis_tit_parcela*/  then do:
               temp_table:
               for each tt_rpt_tit_acr_destinac no-lock
                   where tt_rpt_tit_acr_destinac.tta_num_dwb_order = 99
                      by tt_rpt_tit_acr_destinac.tta_cod_estab
                      by tt_rpt_tit_acr_destinac.tta_dat_emis_docto
                      by tt_rpt_tit_acr_destinac.tta_cod_tit_acr
                      by tt_rpt_tit_acr_destinac.tta_cod_parcela:

                   /* Begin_Include: i_imprimir_nao_detinados */
                   if (line-counter(s_1) + 3 + num-entries( tt_rpt_tit_acr_destinac.tta_cod_portador ,chr(10))) >= v_rpt_s_1_bottom then
                       page stream s_1.

                   assign v_cod_portador_err = entry( 1, tt_rpt_tit_acr_destinac.tta_cod_portador ,chr(10))
                          v_cod_cart_bcia_err = entry( 1, tt_rpt_tit_acr_destinac.tta_cod_cart_bcia ,chr(10))
                          v_des_obs_destinac = entry( 1, tt_rpt_tit_acr_destinac.ttv_des_obs_campo ,chr(10))
                          v_num_ord_destinac_err = integer( entry( 1, tt_rpt_tit_acr_destinac.ttv_cod_order ,chr(10)) ).

                   find cliente no-lock 
                        where cliente.cod_empresa = tt_rpt_tit_acr_destinac.tta_cod_empresa
                        and cliente.cdn_cliente = tt_rpt_tit_acr_destinac.tta_cdn_cliente no-error.
                   assign v_nom_abrev = if avail cliente then cliente.nom_abrev else "".

                   run pi_print_editor ("s_1", v_des_obs_destinac, "     061", "", "     ", "", "     ").
                   assign v_des_return_value_editor = return-value.
                   put stream s_1 unformatted 
                       tt_rpt_tit_acr_destinac.tta_cod_estab at 1 format "x(5)"
                       tt_rpt_tit_acr_destinac.tta_cod_espec_docto at 7 format "x(3)"
                       tt_rpt_tit_acr_destinac.tta_cod_ser_docto at 11 format "x(5)"
                       tt_rpt_tit_acr_destinac.tta_cod_tit_acr at 17 format "x(16)"
                       tt_rpt_tit_acr_destinac.tta_cod_parcela at 34 format "x(02)"
                       tt_rpt_tit_acr_destinac.tta_cdn_cliente to 47 format ">>>,>>>,>>9"
                       v_nom_abrev at 49 format "x(15)"
                       tt_rpt_tit_acr_destinac.tta_nom_cidade at 65 format "x(32)"
                       tt_rpt_tit_acr_destinac.tta_dat_emis_docto at 98 format "99/99/9999"
                       tt_rpt_tit_acr_destinac.tta_dat_vencto_tit_acr at 109 format "99/99/9999"
                       tt_rpt_tit_acr_destinac.tta_val_sdo_tit_acr to 133 format ">>>,>>>,>>9.99"
                       v_num_ord_destinac_err to 142 format ">>>>,>>9"
                       v_cod_portador_err at 144 format "x(5)"
                       v_cod_cart_bcia_err at 150 format "x(3)"
                       entry(1, v_des_return_value_editor, chr(255)) at 155 format "x(61)" skip.
                   run pi_print_editor ("s_1", v_des_obs_destinac, "at155061", "", "", "", "").
                   assign v_des_return_value_editor = return-value.

                   do v_num_erro = 2 to num-entries( tt_rpt_tit_acr_destinac.tta_cod_portador ,chr(10)):
                      assign v_cod_portador_err = entry( v_num_erro, tt_rpt_tit_acr_destinac.tta_cod_portador ,chr(10))
                             v_cod_cart_bcia_err = entry( v_num_erro, tt_rpt_tit_acr_destinac.tta_cod_cart_bcia ,chr(10))
                             v_des_obs_destinac = entry( v_num_erro, tt_rpt_tit_acr_destinac.ttv_des_obs_campo ,chr(10))
                             v_num_ord_destinac_err = integer( entry( v_num_erro, tt_rpt_tit_acr_destinac.ttv_cod_order ,chr(10)) ).
                      run pi_print_editor ("s_1", v_des_obs_destinac, "     061", "", "     ", "", "     ").
                      assign v_des_return_value_editor = return-value.
                      put stream s_1 unformatted 
                          v_num_ord_destinac_err to 142 format ">>>>,>>9"
                          v_cod_portador_err at 144 format "x(5)"
                          v_cod_cart_bcia_err at 150 format "x(3)"
                          entry(1, v_des_return_value_editor, chr(255)) at 155 format "x(61)" skip.
                      run pi_print_editor ("s_1", v_des_obs_destinac, "at155061", "", "", "", "").
                      assign v_des_return_value_editor = return-value.
                   end.

                   assign v_num_tot_geral = v_num_tot_geral + 1
                          v_val_tot = v_val_tot + tt_rpt_tit_acr_destinac.tta_val_sdo_tit_acr.
                   assign v_num_nao_destndo = v_num_nao_destndo + 1.
                   delete tt_rpt_tit_acr_destinac.
                   /* End_Include: i_imprimir_nao_detinados */
                    .
               end /* for temp_table */.
            end.
            else do:
               temp_table:
               for each tt_rpt_tit_acr_destinac no-lock
                   where tt_rpt_tit_acr_destinac.tta_num_dwb_order = 99
                      by tt_rpt_tit_acr_destinac.tta_cod_estab
                      by tt_rpt_tit_acr_destinac.tta_dat_emis_docto
                      by tt_rpt_tit_acr_destinac.tta_dat_vencto_tit_acr
                      by tt_rpt_tit_acr_destinac.tta_cod_tit_acr
                      by tt_rpt_tit_acr_destinac.tta_cod_parcela:

                   /* Begin_Include: i_imprimir_nao_detinados */
                   if (line-counter(s_1) + 3 + num-entries( tt_rpt_tit_acr_destinac.tta_cod_portador ,chr(10))) >= v_rpt_s_1_bottom then
                       page stream s_1.

                   assign v_cod_portador_err = entry( 1, tt_rpt_tit_acr_destinac.tta_cod_portador ,chr(10))
                          v_cod_cart_bcia_err = entry( 1, tt_rpt_tit_acr_destinac.tta_cod_cart_bcia ,chr(10))
                          v_des_obs_destinac = entry( 1, tt_rpt_tit_acr_destinac.ttv_des_obs_campo ,chr(10))
                          v_num_ord_destinac_err = integer( entry( 1, tt_rpt_tit_acr_destinac.ttv_cod_order ,chr(10)) ).

                   find cliente no-lock 
                        where cliente.cod_empresa = tt_rpt_tit_acr_destinac.tta_cod_empresa
                        and cliente.cdn_cliente = tt_rpt_tit_acr_destinac.tta_cdn_cliente no-error.
                   assign v_nom_abrev = if avail cliente then cliente.nom_abrev else "".

                   run pi_print_editor ("s_1", v_des_obs_destinac, "     061", "", "     ", "", "     ").
                   assign v_des_return_value_editor = return-value.
                   put stream s_1 unformatted 
                       tt_rpt_tit_acr_destinac.tta_cod_estab at 1 format "x(5)"
                       tt_rpt_tit_acr_destinac.tta_cod_espec_docto at 7 format "x(3)"
                       tt_rpt_tit_acr_destinac.tta_cod_ser_docto at 11 format "x(5)"
                       tt_rpt_tit_acr_destinac.tta_cod_tit_acr at 17 format "x(16)"
                       tt_rpt_tit_acr_destinac.tta_cod_parcela at 34 format "x(02)"
                       tt_rpt_tit_acr_destinac.tta_cdn_cliente to 47 format ">>>,>>>,>>9"
                       v_nom_abrev at 49 format "x(15)"
                       tt_rpt_tit_acr_destinac.tta_nom_cidade at 65 format "x(32)"
                       tt_rpt_tit_acr_destinac.tta_dat_emis_docto at 98 format "99/99/9999"
                       tt_rpt_tit_acr_destinac.tta_dat_vencto_tit_acr at 109 format "99/99/9999"
                       tt_rpt_tit_acr_destinac.tta_val_sdo_tit_acr to 133 format ">>>,>>>,>>9.99"
                       v_num_ord_destinac_err to 142 format ">>>>,>>9"
                       v_cod_portador_err at 144 format "x(5)"
                       v_cod_cart_bcia_err at 150 format "x(3)"
                       entry(1, v_des_return_value_editor, chr(255)) at 155 format "x(61)" skip.
                   run pi_print_editor ("s_1", v_des_obs_destinac, "at155061", "", "", "", "").
                   assign v_des_return_value_editor = return-value.

                   do v_num_erro = 2 to num-entries( tt_rpt_tit_acr_destinac.tta_cod_portador ,chr(10)):
                      assign v_cod_portador_err = entry( v_num_erro, tt_rpt_tit_acr_destinac.tta_cod_portador ,chr(10))
                             v_cod_cart_bcia_err = entry( v_num_erro, tt_rpt_tit_acr_destinac.tta_cod_cart_bcia ,chr(10))
                             v_des_obs_destinac = entry( v_num_erro, tt_rpt_tit_acr_destinac.ttv_des_obs_campo ,chr(10))
                             v_num_ord_destinac_err = integer( entry( v_num_erro, tt_rpt_tit_acr_destinac.ttv_cod_order ,chr(10)) ).
                      run pi_print_editor ("s_1", v_des_obs_destinac, "     061", "", "     ", "", "     ").
                      assign v_des_return_value_editor = return-value.
                      put stream s_1 unformatted 
                          v_num_ord_destinac_err to 142 format ">>>>,>>9"
                          v_cod_portador_err at 144 format "x(5)"
                          v_cod_cart_bcia_err at 150 format "x(3)"
                          entry(1, v_des_return_value_editor, chr(255)) at 155 format "x(61)" skip.
                      run pi_print_editor ("s_1", v_des_obs_destinac, "at155061", "", "", "", "").
                      assign v_des_return_value_editor = return-value.
                   end.

                   assign v_num_tot_geral = v_num_tot_geral + 1
                          v_val_tot = v_val_tot + tt_rpt_tit_acr_destinac.tta_val_sdo_tit_acr.
                   assign v_num_nao_destndo = v_num_nao_destndo + 1.
                   delete tt_rpt_tit_acr_destinac.
                   /* End_Include: i_imprimir_nao_detinados */
                    .
               end /* for temp_table */.
            end.
            if  v_num_nao_destndo > 0
            then do:
               hide stream s_1 frame f_rpt_s_1_Grp_detalhe_Lay_dest_port.
               if (line-counter(s_1) + 2) > v_rpt_s_1_bottom then
                   page stream s_1.
               put stream s_1 unformatted 
                   "--------------" at 120 skip
                   getStrTrans("Total Geral: ", "ACR") at 103
                   v_val_tot to 133 format "->>,>>>,>>>,>>9.99"
                   "-" at 135
                   v_num_tot_geral to 144 format ">>>>,>>9"
                   getStrTrans("T°tulo(s)  ", "ACR") at 146 skip.
            end /* if */.
        end /* if */.
    end.
END PROCEDURE. /* pi_imprimir_tit_acr_nao_destinados */
/*****************************************************************************
** Procedure Interna.....: pi_validar_envio_edi_destinacao
** Descricao.............: pi_validar_envio_edi_destinacao
** Criado por............: roberto
** Criado em.............: 06/11/1997 10:47:07
** Alterado por..........: Souza
** Alterado em...........: 05/09/2002 10:59:11
*****************************************************************************/
PROCEDURE pi_validar_envio_edi_destinacao:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_estab
        as character
        format "x(5)"
        no-undo.
    def Input param p_cod_portador
        as character
        format "x(5)"
        no-undo.
    def Input param p_cod_cart_bcia
        as character
        format "x(3)"
        no-undo.
    def Input param p_cod_indic_econ
        as character
        format "x(8)"
        no-undo.
    def Input param p_dat_emis_docto
        as date
        format "99/99/9999"
        no-undo.
    def output param p_des_mensagem
        as character
        format "x(50)"
        no-undo.


    /************************* Parameter Definition End *************************/

    assign p_des_mensagem = "".

    find portador no-lock
         where portador.cod_portador = p_cod_portador no-error.

    run pi_validar_movto_tit_acr_envio_msg_dest (Input portador.cod_banco,
                                                 Input "Implantaá∆o" /*l_implantacao*/,
                                                 Input v_dat_destinac,
                                                 output p_des_mensagem) /*pi_validar_movto_tit_acr_envio_msg_dest*/.
    if  return-value = "NOK" /*l_nok*/ 
    then do:
        return.
    end /* if */.

    run pi_validar_tit_acr_envio_msg_cobr_dest (Input p_cod_estab,
                                                Input p_cod_portador,
                                                Input p_cod_cart_bcia,
                                                Input p_cod_indic_econ,
                                                Input p_dat_emis_docto,
                                                output p_des_mensagem) /*pi_validar_tit_acr_envio_msg_cobr_dest*/.
END PROCEDURE. /* pi_validar_envio_edi_destinacao */
/*****************************************************************************
** Procedure Interna.....: pi_portad_tit_acr
** Descricao.............: pi_portad_tit_acr
** Criado por............: Emerson
** Criado em.............: 23/01/1998 16:11:02
** Alterado por..........: Carlas
** Alterado em...........: 14/08/1998 10:57:57
*****************************************************************************/
PROCEDURE pi_portad_tit_acr:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_estab
        as character
        format "x(5)"
        no-undo.
    def Input param p_num_id_tit_acr
        as integer
        format "999999999"
        no-undo.
    def Input param p_ind_orig_dest
        as character
        format "X(08)"
        no-undo.
    def Input param p_cod_portador
        as character
        format "x(5)"
        no-undo.
    def Input param p_dat_transacao
        as date
        format "99/99/9999"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_num_seq
        as integer
        format ">>>,>>9":U
        label "SeqÅància"
        column-label "Seq"
        no-undo.


    /************************** Variable Definition End *************************/

    find last  portad_tit_acr no-lock
         where portad_tit_acr.cod_estab      = p_cod_estab
           and portad_tit_acr.num_id_tit_acr = p_num_id_tit_acr
               no-error.
    if  avail portad_tit_acr
    then do:
       assign v_num_seq = portad_tit_acr.num_seq + 1.
    end /* if */.
    else do:
       assign v_num_seq = 1.
    end /* else */.

    create portad_tit_acr.
    assign portad_tit_acr.cod_estab             = p_cod_estab
           portad_tit_acr.num_id_tit_acr        = p_num_id_tit_acr
           portad_tit_acr.num_seq               = v_num_seq
           portad_tit_acr.dat_alter_portad      = p_dat_transacao
           portad_tit_acr.hra_alter_portad      = replace(string(time,"hh:mm:ss" /*l_hh:mm:ss*/ ), ":", "")
           portad_tit_acr.cod_usuario           = v_cod_usuar_corren
           portad_tit_acr.ind_orig_alter_portad = p_ind_orig_dest
           portad_tit_acr.cod_portador          = p_cod_portador.

    assign tit_acr.dat_alter_portad = portad_tit_acr.dat_alter_portad.
END PROCEDURE. /* pi_portad_tit_acr */
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
** Procedure Interna.....: pi_tratar_endereco_cobr_representante
** Descricao.............: pi_tratar_endereco_cobr_representante
** Criado por............: bre17230
** Criado em.............: 14/08/1998 10:05:27
** Alterado por..........: src12154
** Alterado em...........: 11/12/2001 13:30:36
*****************************************************************************/
PROCEDURE pi_tratar_endereco_cobr_representante:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cdn_repres
        as Integer
        format ">>>,>>9"
        no-undo.
    def Input param p_cod_empresa
        as character
        format "x(3)"
        no-undo.


    /************************* Parameter Definition End *************************/

    find representante no-lock
        where representante.cod_empresa = p_cod_empresa
          and representante.cdn_repres  = p_cdn_repres
          no-error.
    if avail representante then do:
        if  representante.num_pessoa mod 2 = 0
        then do:
            find pessoa_fisic no-lock
                where pessoa_fisic.num_pessoa_fisic = representante.num_pessoa
                no-error.
            if  avail pessoa_fisic
            then do:
                find pais no-lock
                    where pais.cod_pais = pessoa_fisic.cod_pais
                    no-error.
                if  avail pais
                then do:
                    assign v_nom_endereco      = pessoa_fisic.nom_endereco
                           v_nom_ender_compl   = pessoa_fisic.nom_ender_compl
                           v_nom_bairro        = pessoa_fisic.nom_bairro
                           v_cod_cx_post       = pessoa_fisic.cod_cx_post
                           v_nom_condado       = pessoa_fisic.nom_condado
                           v_nom_cidade        = pessoa_fisic.nom_cidade
                           v_cod_unid_federac  = pessoa_fisic.cod_unid_federac
                           v_cod_cep           = string(pessoa_fisic.cod_cep, pais.cod_format_cep)
                           v_cod_cep_dest_cobr = pessoa_fisic.cod_cep.
                           /* ## A vari†vel v_cod_cep_dest_cobr ser† usada pelo programa Destinaá∆o de Cobranáa,
                           sem o formato do cep. ##*/
                    &if defined(BF_FIN_4LINHAS_END) &then
                        cont_block:
                        REPEAT v_num_cont_entry = 1 TO NUM-ENTRIES(pessoa_fisic.nom_ender_text, chr(10)):
                            if  v_num_cont_entry = 1 then assign v_nom_ender_lin_1 = entry( 1, pessoa_fisic.nom_ender_text, chr(10)).
                            if  v_num_cont_entry = 2 then assign v_nom_ender_lin_2 = entry( 2, pessoa_fisic.nom_ender_text, chr(10)).
                            if  v_num_cont_entry = 3 then assign v_nom_ender_lin_3 = entry( 3, pessoa_fisic.nom_ender_text, chr(10)).
                            if  v_num_cont_entry = 4 then assign v_nom_ender_lin_4 = entry( 4, pessoa_fisic.nom_ender_text, chr(10)).
                            if  v_num_cont_entry = 4 then
                                leave cont_block.
                        end.
                    &endif
                end /* if */.               
            end /* if */.
        end /* if */.
        else do:
            find pessoa_jurid no-lock
                where pessoa_jurid.num_pessoa_jurid = representante.num_pessoa
                no-error.
            if  avail pessoa_jurid
            and pessoa_jurid.num_pessoa_jurid_cobr <> pessoa_jurid.num_pessoa_jurid
            and pessoa_jurid.num_pessoa_jurid_cobr <> ?
            and pessoa_jurid.num_pessoa_jurid_cobr <> 0
            then do:
                assign v_num_pessoa_jurid = pessoa_jurid.num_pessoa_jurid_cobr.
                find pessoa_jurid no-lock
                    where pessoa_jurid.num_pessoa_jurid = v_num_pessoa_jurid
                    no-error.
            end /* if */.

            if  avail pessoa_jurid
            then do:
                find pais no-lock
                    where pais.cod_pais = pessoa_jurid.cod_pais
                    no-error.
                if  avail pais
                then do:
                    if  v_ind_ender_complet = "Endereáo" /*l_endereco*/  then do:
                        if  pessoa_jurid.nom_ender_cobr = ""
                        then do:
                            run pi_vrf_nom_ender_cobr_text /*pi_vrf_nom_ender_cobr_text*/.
                        end /* if */.
                        else do:
                            run pi_vrf_nom_ender_cobr_text_1 /*pi_vrf_nom_ender_cobr_text_1*/.
                        end /* else */.

                    end.
                    else do:
                        &if defined(BF_FIN_4LINHAS_END) &then
                            if  pessoa_jurid.nom_ender_cobr_text = ""
                            then do:
                                run pi_vrf_nom_ender_cobr_text /*pi_vrf_nom_ender_cobr_text*/.
                            end /* if */.
                            else do:
                                run pi_vrf_nom_ender_cobr_text_1 /*pi_vrf_nom_ender_cobr_text_1*/.
                            end /* else */.
                        &endif
                    end.
                end /* if */.
            end /* if */.
        end /* else */.
    end.

END PROCEDURE. /* pi_tratar_endereco_cobr_representante */
/*****************************************************************************
** Procedure Interna.....: pi_tratar_endereco_cobr_contato
** Descricao.............: pi_tratar_endereco_cobr_contato
** Criado por............: bre17230
** Criado em.............: 14/08/1998 09:57:37
** Alterado por..........: src12154
** Alterado em...........: 13/12/2001 09:44:02
*****************************************************************************/
PROCEDURE pi_tratar_endereco_cobr_contato:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cdn_cliente
        as Integer
        format ">>>,>>>,>>9"
        no-undo.
    def Input param p_nom_abrev_contat
        as character
        format "x(15)"
        no-undo.
    def Input param p_cod_empresa
        as character
        format "x(3)"
        no-undo.


    /************************* Parameter Definition End *************************/

    find cliente no-lock
        where cliente.cod_empresa = p_cod_empresa
        and   cliente.cdn_cliente = p_cdn_cliente no-error.
    if  avail cliente
    then do:
       find contato no-lock
           where contato.num_pessoa_jurid = cliente.num_pessoa
           and   contato.nom_abrev_contat = p_nom_abrev_contat no-error.
       if  avail contato
       then do:
           find pais no-lock where pais.cod_pais = contato.cod_pais no-error.
           if  avail pais
           then do:
               &if '{&emsuni_version}' >= '5.02' &then           
                   assign v_nom_endereco      = contato.nom_endereco
                          v_nom_ender_compl   = contato.nom_ender_compl
                          v_nom_bairro        = contato.nom_bairro
                          v_cod_cx_post       = contato.cod_cx_post
                          v_nom_condado       = contato.nom_condado
                          v_nom_cidade        = contato.nom_cidade
                          v_cod_unid_federac  = contato.cod_unid_federac
                          v_cod_cep           = string(contato.cod_cep, pais.cod_format_cep)
                          v_cod_cep_dest_cobr = contato.cod_cep.
                  /* ## A vari†vel v_cod_cep_dest_cobr ser† usada pelo programa 
                          Destinaá∆o de Cobranáa, sem o formato do cep.          ##*/
               &else              
                   if contato.cod_livre_1 <> "" then 
                       assign v_nom_endereco      = (entry(1,contato.cod_livre_1,chr(10)))
                              v_nom_ender_compl   = (entry(2,contato.cod_livre_1,chr(10)))
                              v_nom_bairro        = (entry(3,contato.cod_livre_1,chr(10)))
                              v_cod_cx_post       = (entry(4,contato.cod_livre_1,chr(10)))
                              v_nom_cidade        = (entry(5,contato.cod_livre_1,chr(10)))
                              v_nom_condado       = (entry(6,contato.cod_livre_1,chr(10)))
                              v_cod_unid_federac  = (entry(7,contato.cod_livre_1,chr(10)))
                              v_cod_cep           = string(entry(8,contato.cod_livre_1,chr(10)), pais.cod_format_cep)
                              v_cod_cep_dest_cobr = (entry(8,contato.cod_livre_1,chr(10))).
                 /* ## A vari†vel v_cod_cep_dest_cobr ser† usada pelo programa 
                          Destinaá∆o de Cobranáa,  sem o formato do cep.      ##*/
              &endif

              &if defined(BF_FIN_4LINHAS_END) &then
                  cont_block:
                  REPEAT v_num_cont_entry = 1 TO NUM-ENTRIES(contato.nom_ender_text, chr(10)):
                      if  v_num_cont_entry = 1 then assign v_nom_ender_lin_1 = entry( 1, contato.nom_ender_text, chr(10)).
                      if  v_num_cont_entry = 2 then assign v_nom_ender_lin_2 = entry( 2, contato.nom_ender_text, chr(10)).
                      if  v_num_cont_entry = 3 then assign v_nom_ender_lin_3 = entry( 3, contato.nom_ender_text, chr(10)).
                      if  v_num_cont_entry = 4 then assign v_nom_ender_lin_4 = entry( 4, contato.nom_ender_text, chr(10)).
                      if  v_num_cont_entry = 4 then
                          leave cont_block.
                  end.
              &endif
           end /* if */.
       end /* if */.
    end /* if */.
END PROCEDURE. /* pi_tratar_endereco_cobr_contato */
/*****************************************************************************
** Procedure Interna.....: pi_valida_cep_agencia_destinac_cobr
** Descricao.............: pi_valida_cep_agencia_destinac_cobr
** Criado por............: lucas
** Criado em.............: 17/12/1998 14:31:44
** Alterado por..........: Souza
** Alterado em...........: 02/09/2002 09:13:11
*****************************************************************************/
PROCEDURE pi_valida_cep_agencia_destinac_cobr:

    /************************ Parameter Definition Begin ************************/

    def Input param p_log_validac_bco
        as logical
        format "Sim/N∆o"
        no-undo.
    def Input param p_cod_banco
        as character
        format "x(8)"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************** Buffer Definition Begin *************************/

    def buffer btt_rpt_tit_acr_destinac
        for tt_rpt_tit_acr_destinac.


    /*************************** Buffer Definition End **************************/

    assign v_des_mensagem = "".
    case tit_acr.ind_ender_cobr:
        when "Cliente" /*l_cliente*/  then do:
            find first btt_rpt_tit_acr_destinac no-lock
                 where btt_rpt_tit_acr_destinac.tta_cdn_cliente    = tit_acr.cdn_cliente
                   and btt_rpt_tit_acr_destinac.tta_ind_ender_cobr = tit_acr.ind_ender_cobr
                   and btt_rpt_tit_acr_destinac.ttv_cod_cep       <> ""
                 no-error.
            if not avail btt_rpt_tit_acr_destinac 
            then
                run pi_tratar_endereco_cobr (Input tit_acr.cdn_cliente,
                                             Input tit_acr.cod_empresa) /*pi_tratar_endereco_cobr*/.
            else 
                assign v_cod_cep_dest_cobr = btt_rpt_tit_acr_destinac.ttv_cod_cep.
        end.
        when "Representante" /*l_representante*/  then do:
            find first btt_rpt_tit_acr_destinac no-lock
                 where btt_rpt_tit_acr_destinac.tta_cdn_repres     = tit_acr.cdn_repres
                   and btt_rpt_tit_acr_destinac.tta_ind_ender_cobr = tit_acr.ind_ender_cobr
                   and btt_rpt_tit_acr_destinac.ttv_cod_cep       <> ""
                 no-error.
            if not avail btt_rpt_tit_acr_destinac 
            then
                run pi_tratar_endereco_cobr_representante (Input tit_acr.cdn_repres,
                                                           Input tit_acr.cod_empresa) /*pi_tratar_endereco_cobr_representante*/.
            else 
                assign v_cod_cep_dest_cobr = btt_rpt_tit_acr_destinac.ttv_cod_cep.
        end.
        when "Contato" /*l_contato*/  then do:
            find first btt_rpt_tit_acr_destinac no-lock
                 where btt_rpt_tit_acr_destinac.tta_cdn_cliente      = tit_acr.cdn_cliente
                   and btt_rpt_tit_acr_destinac.tta_nom_abrev_contat = tit_acr.nom_abrev_contat
                   and btt_rpt_tit_acr_destinac.tta_ind_ender_cobr   = tit_acr.ind_ender_cobr
                   and btt_rpt_tit_acr_destinac.ttv_cod_cep         <> ""
                 no-error.
            if not avail btt_rpt_tit_acr_destinac 
            then
                run pi_tratar_endereco_cobr_contato (Input tit_acr.cdn_cliente,
                                                     Input tit_acr.nom_abrev_contat,
                                                     Input tit_acr.cod_empresa) /*pi_tratar_endereco_cobr_contato*/.
            else 
                assign v_cod_cep_dest_cobr = btt_rpt_tit_acr_destinac.ttv_cod_cep.
        end.
    end.
    assign tt_rpt_tit_acr_destinac.ttv_cod_cep = v_cod_cep_dest_cobr.

    /* Alteraá∆o espec°fica Controle Terceiros */
    if   v_log_control_terc_acr = yes
    and (tit_acr.ind_tip_espec_docto = "Terceiros" /*l_terceiros*/ 
    or   tit_acr.ind_tip_espec_docto = "Cheques Terceiros" /*l_cheq_terc*/ )  then do:
        if v_nom_prog_upc <> '' then do:
            assign v_rec_table_epc = recid(tit_acr).
            run value(v_nom_prog_upc) (input 'CEP Terceiro':U,
                                       input 'viewer',
                                       input this-procedure,
                                       input v_wgh_frame_epc,
                                       input v_nom_table_epc,
                                       input v_rec_table_epc).
            if return-value = 'NOK' then
                undo, retry.
       end.
    End.


    if not avail banco then do:
       assign v_des_mensagem = substitute(getStrTrans("Banco &1 inexistente !", "ACR") /*9599*/,p_cod_banco).
       return "NOK" /*l_nok*/ .
    end.
    find first cep_agenc_bcia no-lock
         where cep_agenc_bcia.cod_banco      = banco.cod_banco
           and cep_agenc_bcia.cod_cep_final >= v_cod_cep_dest_cobr
         use-index cpgncbc_cep no-error.
    if  not avail cep_agenc_bcia 
        or cep_agenc_bcia.cod_cep_inicial > v_cod_cep_dest_cobr
    then do:
        assign v_des_mensagem = substitute(getStrTrans("O banco &1 n∆o atende o cep &2.", "ACR") /*8518*/,banco.cod_banco,v_cod_cep_dest_cobr).
        return "NOK" /*l_nok*/ .
    end /* if */.

    if  (cep_agenc_bcia.qtd_dias_carenc_cobr = 0
        or cep_agenc_bcia.qtd_dias_carenc_cobr = ?)
        and p_log_validac_bco = no
    then do:
        v_des_mensagem = getStrTrans("Data menor que prazo de envio.", "ACR") /*3266*/.
        return "NOK" /*l_nok*/ .
    end.

    if  (cep_agenc_bcia.qtd_dias_carenc_cobr <> 0
        and cep_agenc_bcia.qtd_dias_carenc_cobr <> ?)
        and tit_acr.dat_vencto_tit_acr - v_dat_destinac < cep_agenc_bcia.qtd_dias_carenc_cobr
    then do:
        v_des_mensagem = substitute(getStrTrans("Data menor que prazo de envio para agància &1 que atende o CEP &2.", "ACR") /*7451*/, cep_agenc_bcia.cod_agenc_bcia, v_cod_cep_dest_cobr).
        return "NOK" /*l_nok*/ .
    end.
    return "OK" /*l_ok*/ .
END PROCEDURE. /* pi_valida_cep_agencia_destinac_cobr */
/*****************************************************************************
** Procedure Interna.....: pi_retorna_sugestao_referencia
** Descricao.............: pi_retorna_sugestao_referencia
** Criado por............: Barth
** Criado em.............: 21/10/1998 09:14:30
** Alterado por..........: Souza
** Alterado em...........: 18/05/1999 10:12:58
*****************************************************************************/
PROCEDURE pi_retorna_sugestao_referencia:

    /************************ Parameter Definition Begin ************************/

    def Input param p_ind_tip_atualiz
        as character
        format "X(08)"
        no-undo.
    def Input param p_dat_refer
        as date
        format "99/99/9999"
        no-undo.
    def output param p_cod_refer
        as character
        format "x(10)"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_des_dat                        as character       no-undo. /*local*/
    def var v_num_aux                        as integer         no-undo. /*local*/
    def var v_num_aux_2                      as integer         no-undo. /*local*/
    def var v_num_cont                       as integer         no-undo. /*local*/


    /************************** Variable Definition End *************************/

    assign v_des_dat   = string(p_dat_refer,"99999999")
           p_cod_refer = substring(v_des_dat,7,2)
                       + substring(v_des_dat,3,2)
                       + substring(v_des_dat,1,2)
                       + substring(p_ind_tip_atualiz,1,1)
           v_num_aux_2 = integer(this-procedure:handle).

    do  v_num_cont = 1 to 3:
        assign v_num_aux   = (random(0,v_num_aux_2) mod 26) + 97
               p_cod_refer = p_cod_refer + chr(v_num_aux).
    end.
END PROCEDURE. /* pi_retorna_sugestao_referencia */
/*****************************************************************************
** Procedure Interna.....: pi_validar_tit_acr_envio_msg_cobr_dest
** Descricao.............: pi_validar_tit_acr_envio_msg_cobr_dest
** Criado por............: bre17906
** Criado em.............: 31/03/1999 10:13:06
** Alterado por..........: bre17906
** Alterado em...........: 31/03/1999 10:19:08
*****************************************************************************/
PROCEDURE pi_validar_tit_acr_envio_msg_cobr_dest:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_estab
        as character
        format "x(5)"
        no-undo.
    def Input param p_cod_portador
        as character
        format "x(5)"
        no-undo.
    def Input param p_cod_cart_bcia
        as character
        format "x(3)"
        no-undo.
    def Input param p_cod_indic_econ
        as character
        format "x(8)"
        no-undo.
    def Input param p_dat_emis_docto
        as date
        format "99/99/9999"
        no-undo.
    def output param p_des_mensagem
        as character
        format "x(50)"
        no-undo.


    /************************* Parameter Definition End *************************/

    run pi_retornar_finalid_indic_econ (Input p_cod_indic_econ,
                                        Input p_dat_emis_docto,
                                        output v_cod_finalid_econ) /*pi_retornar_finalid_indic_econ*/.
    if  v_cod_finalid_econ = ""
    then do:
        assign p_des_mensagem = substitute(getStrTrans("IE &1 n∆o Ç valido para finalidade &2 na data &3 !", "ACR") /*4579*/, p_cod_indic_econ, string( p_dat_emis_docto )).
        return "NOK" /*l_nok*/ .
    end /* if */.

    find portad_edi no-lock
         where portad_edi.cod_modul_dtsul  = "ACR" /*l_acr*/ 
         and   portad_edi.cod_estab        = p_cod_estab
         and   portad_edi.cod_portador     = p_cod_portador
         and   portad_edi.cod_cart_bcia    = p_cod_cart_bcia
         and   portad_edi.cod_finalid_econ = v_cod_finalid_econ
         use-index prtdd_id no-error.
    if  not avail portad_edi
    then do:
        assign p_des_mensagem = getStrTrans("Portador &1 sem as informaá‰es para EDI !", "ACR") /*4580*/
               p_des_mensagem = substitute( p_des_mensagem, p_cod_portador ).
        return "NOK" /*l_nok*/ .
    end /* if */.
    else do:
        if  portad_edi.cdn_parcei_edi = 0
        then do:
            assign p_des_mensagem = getStrTrans("C¢digo do parceiro zerado, para portador edi !", "ACR") /*7219*/.
            return "NOK" /*l_nok*/ .
        end /* if */.
    end /* else */.
    return "OK" /*l_ok*/ .
END PROCEDURE. /* pi_validar_tit_acr_envio_msg_cobr_dest */
/*****************************************************************************
** Procedure Interna.....: pi_validar_movto_tit_acr_envio_msg_dest
** Descricao.............: pi_validar_movto_tit_acr_envio_msg_dest
** Criado por............: bre17906
** Criado em.............: 31/03/1999 10:13:31
** Alterado por..........: bre17906
** Alterado em...........: 31/03/1999 10:16:18
*****************************************************************************/
PROCEDURE pi_validar_movto_tit_acr_envio_msg_dest:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_banco
        as character
        format "x(8)"
        no-undo.
    def Input param p_ind_tip_ocor_bcia
        as character
        format "x(40)"
        no-undo.
    def Input param p_dat_transacao
        as date
        format "99/99/9999"
        no-undo.
    def output param p_des_mensagem
        as character
        format "x(50)"
        no-undo.


    /************************* Parameter Definition End *************************/

    find first ocor_bcia_bco no-lock
         where ocor_bcia_bco.cod_banco               = p_cod_banco
         and   ocor_bcia_bco.cod_modul_dtsul         = "ACR" /*l_acr*/ 
         and   ocor_bcia_bco.ind_tip_ocor_bcia       = p_ind_tip_ocor_bcia
         and   ocor_bcia_bco.ind_ocor_bcia_remes_ret = "Remessa" /*l_remessa*/ 
         and   ocor_bcia_bco.dat_inic_valid         <= p_dat_transacao
         and   ocor_bcia_bco.dat_fim_valid          >= p_dat_transacao
         no-error.
    if  not avail ocor_bcia_bco
    then do:
        assign p_des_mensagem = getStrTrans("Ocorrància Banc†ria Banco n∆o Cadastrada !", "ACR") /*3687*/.
        return "NOK" /*l_nok*/ .
    end /* if */.
    return "OK" /*l_ok*/ .
END PROCEDURE. /* pi_validar_movto_tit_acr_envio_msg_dest */
/*****************************************************************************
** Procedure Interna.....: pi_atualiza_destinac_tit_acr
** Descricao.............: pi_atualiza_destinac_tit_acr
** Criado por............: lucas
** Criado em.............: 05/04/1999 08:52:24
** Alterado por..........: fut1147
** Alterado em...........: 25/06/2014 15:16:45
*****************************************************************************/
PROCEDURE pi_atualiza_destinac_tit_acr:

    find tt_atualiza_destinac_tit_acr exclusive-lock
         where tt_atualiza_destinac_tit_acr.tta_cod_estab_tit_acr = tt_rpt_tit_acr_destinac.tta_cod_estab
           and tt_atualiza_destinac_tit_acr.tta_cod_espec_docto   = tt_rpt_tit_acr_destinac.tta_cod_espec_docto
           and tt_atualiza_destinac_tit_acr.tta_cod_ser_docto     = tt_rpt_tit_acr_destinac.tta_cod_ser_docto
           and tt_atualiza_destinac_tit_acr.tta_cod_tit_acr       = tt_rpt_tit_acr_destinac.tta_cod_tit_acr
           and tt_atualiza_destinac_tit_acr.tta_cod_parcela       = tt_rpt_tit_acr_destinac.tta_cod_parcela no-error.
    if avail tt_atualiza_destinac_tit_acr
    then do:
         /* ** SOMENTE DAR FIND PARAM_ESTAB UMA VEZ POR ESTABELECIMENTO ***/
         if  not avail param_estab_acr
         or  param_estab_acr.cod_estab <> tt_atualiza_destinac_tit_acr.tta_cod_estab_tit_acr then
             run pi_retorna_parametro_acr (Input tt_atualiza_destinac_tit_acr.tta_cod_estab_tit_acr,
                                           Input v_dat_destinac) /*pi_retorna_parametro_acr*/.
         if  not avail param_estab_acr then leave.

         find tit_acr exclusive-lock 
             where tit_acr.cod_estab       = tt_atualiza_destinac_tit_acr.tta_cod_estab_tit_acr
               and tit_acr.cod_espec_docto = tt_atualiza_destinac_tit_acr.tta_cod_espec_docto   
               and tit_acr.cod_ser_docto   = tt_atualiza_destinac_tit_acr.tta_cod_ser_docto
               and tit_acr.cod_tit_acr     = tt_atualiza_destinac_tit_acr.tta_cod_tit_acr
               and tit_acr.cod_parcela     = tt_atualiza_destinac_tit_acr.tta_cod_parcela no-error.
         if  not avail tit_acr then leave.

         if  tt_atualiza_destinac_tit_acr.ttv_cod_portador_new  <> tt_atualiza_destinac_tit_acr.ttv_cod_portador_old
         or  tt_atualiza_destinac_tit_acr.ttv_cod_cart_bcia_new <> tt_atualiza_destinac_tit_acr.ttv_cod_cart_bcia_old then do:


             /* Begin_Include: i_exec_program_epc */
             &if '{&emsbas_version}' > '1.00' &then
             if  v_nom_prog_upc <> '' then
             do:
                 assign v_rec_table_epc = recid(tit_acr).    
                 run value(v_nom_prog_upc) (input 'valida_portador_ivc':U,
                                            input 'viewer',
                                            input this-procedure,
                                            input v_wgh_frame_epc,
                                            input v_nom_table_epc,
                                            input v_rec_table_epc).
                 if  'yes':U = 'yes'
                 and return-value = 'NOK' then
                     undo, retry.
             end.

             if  v_nom_prog_appc <> '' then
             do:
                 assign v_rec_table_epc = recid(tit_acr).    
                 run value(v_nom_prog_appc) (input 'valida_portador_ivc':U,
                                             input 'viewer',
                                             input this-procedure,
                                             input v_wgh_frame_epc,
                                             input v_nom_table_epc,
                                             input v_rec_table_epc).
                 if  'yes':U = 'yes'
                 and return-value = 'NOK' then
                     undo, retry.
             end.

             &if '{&emsbas_version}' > '5.00' &then
             if  v_nom_prog_dpc <> '' then
             do:
                 assign v_rec_table_epc = recid(tit_acr).    
                 run value(v_nom_prog_dpc) (input 'valida_portador_ivc':U,
                                             input 'viewer',
                                             input this-procedure,
                                             input v_wgh_frame_epc,
                                             input v_nom_table_epc,
                                             input v_rec_table_epc).
                 if  'yes':U = 'yes'
                 and return-value = 'NOK' then
                     undo, retry.
             end.
             &endif
             &endif
             /* End_Include: i_exec_program_epc */


             assign v_des_orig_alter_portad = "Destinaá∆o" /*l_destinacao*/ .
             run pi_portad_tit_acr (Input tit_acr.cod_estab,
                                    Input tit_acr.num_id_tit_acr,
                                    Input v_des_orig_alter_portad,
                                    Input tt_atualiza_destinac_tit_acr.ttv_cod_portador_new,
                                    Input v_dat_destinac) /*pi_portad_tit_acr*/.

             /* ** S‡ PODE ALTERAR O PORTADOR DEPOIS DE ATUALIZAR DADOS DO PORTADOR ***/
             assign tit_acr.cod_portador  = tt_atualiza_destinac_tit_acr.ttv_cod_portador_new
                    tit_acr.cod_cart_bcia = tt_atualiza_destinac_tit_acr.ttv_cod_cart_bcia_new.


             /* Begin_Include: i_exec_program_epc */
             &if '{&emsbas_version}' > '1.00' &then
             if  v_nom_prog_upc <> '' then
             do:
                 assign v_rec_table_epc = recid(tit_acr).    
                 run value(v_nom_prog_upc) (input 'altera_nosso_numero':U,
                                            input 'viewer',
                                            input this-procedure,
                                            input v_wgh_frame_epc,
                                            input v_nom_table_epc,
                                            input v_rec_table_epc).
                 if  'yes':U = 'yes'
                 and return-value = 'NOK' then
                     undo, retry.
             end.

             if  v_nom_prog_appc <> '' then
             do:
                 assign v_rec_table_epc = recid(tit_acr).    
                 run value(v_nom_prog_appc) (input 'altera_nosso_numero':U,
                                             input 'viewer',
                                             input this-procedure,
                                             input v_wgh_frame_epc,
                                             input v_nom_table_epc,
                                             input v_rec_table_epc).
                 if  'yes':U = 'yes'
                 and return-value = 'NOK' then
                     undo, retry.
             end.

             &if '{&emsbas_version}' > '5.00' &then
             if  v_nom_prog_dpc <> '' then
             do:
                 assign v_rec_table_epc = recid(tit_acr).    
                 run value(v_nom_prog_dpc) (input 'altera_nosso_numero':U,
                                             input 'viewer',
                                             input this-procedure,
                                             input v_wgh_frame_epc,
                                             input v_nom_table_epc,
                                             input v_rec_table_epc).
                 if  'yes':U = 'yes'
                 and return-value = 'NOK' then
                     undo, retry.
             end.
             &endif
             &endif
             /* End_Include: i_exec_program_epc */

             run pi_atualizar_dados_portad_destinac /*pi_atualizar_dados_portad_destinac*/.
             create movto_tit_acr.
             assign movto_tit_acr.cod_empresa               = tit_acr.cod_empresa
                    movto_tit_acr.cod_estab                 = tit_acr.cod_estab
                    movto_tit_acr.num_id_tit_acr            = tit_acr.num_id_tit_acr
                    movto_tit_acr.dat_gerac_movto           = today
                    movto_tit_acr.hra_gerac_movto           = replace(string(time,"hh:mm:ss" /*l_hh:mm:ss*/ ), ":", "")
                    movto_tit_acr.cod_usuario               = v_cod_usuar_corren
                    movto_tit_acr.dat_transacao             = v_dat_destinac
                    movto_tit_acr.ind_trans_acr             = "Alteraá∆o n∆o Cont†bil" /*l_alteracao_nao_contabil*/ 
                    movto_tit_acr.ind_trans_acr_abrev       = "ALNC" /*l_alnc*/ 
                    movto_tit_acr.ind_motiv_acerto_val      = ""
                    movto_tit_acr.cod_refer                 = v_cod_refer
                    movto_tit_acr.cod_espec_docto           = tit_acr.cod_espec_docto
                    movto_tit_acr.cdn_cliente               = tit_acr.cdn_cliente
                    movto_tit_acr.val_movto_tit_acr         = 0
                    movto_tit_acr.num_id_movto_tit_acr      = next-value(seq_movto_tit_acr) 
                    movto_tit_acr.log_ctbz_aprop_ctbl       = no
                    movto_tit_acr.log_aprop_ctbl_ctbzda     = no
                    movto_tit_acr.dat_apurac_variac_val_ant = v_dat_destinac
                    movto_tit_acr.cod_portador              = tit_acr.cod_portador
                    movto_tit_acr.cod_cart_bcia             = tit_acr.cod_cart_bcia
                    movto_tit_acr.val_juros                 = 0
                    movto_tit_acr.val_multa_tit_acr         = 0
                    movto_tit_acr.val_despes_bcia           = 0
                    movto_tit_acr.val_cm_tit_acr            = 0.
             validate movto_tit_acr.       

             create histor_movto_tit_acr.
             assign histor_movto_tit_acr.cod_estab            = tit_acr.cod_estab
                    histor_movto_tit_acr.num_id_tit_acr       = tit_acr.num_id_tit_acr
                    histor_movto_tit_acr.num_id_movto_tit_acr = movto_tit_acr.num_id_movto_tit_acr
                    histor_movto_tit_acr.ind_orig_histor_acr  = "Sistema" /*l_sistema*/ 
                    histor_movto_tit_acr.des_text_histor      = "Alteraá∆o n∆o Cont†bil" /*l_alteracao_nao_contabil*/  + "." + chr(10).
             if  tt_atualiza_destinac_tit_acr.ttv_cod_portador_new <> tt_atualiza_destinac_tit_acr.ttv_cod_portador_old then
                 assign histor_movto_tit_acr.des_text_histor = histor_movto_tit_acr.des_text_histor
                                                             + "Alteraá∆o Portador" /*l_alteracao_portador*/   + " "
                                                             + "de:" /*l_de:*/  + " "
                                                             + string(tt_atualiza_destinac_tit_acr.ttv_cod_portador_old) + " "
                                                             + "para:" /*l_para:*/  + " "
                                                             + string(tt_atualiza_destinac_tit_acr.ttv_cod_portador_new) + " " 
                                                             + "Via Programa de Destinaá∆o de T°tulos" /*l_via_prg_destin_tit*/  + "." + chr(10).
             if  tt_atualiza_destinac_tit_acr.ttv_cod_cart_bcia_new <> tt_atualiza_destinac_tit_acr.ttv_cod_cart_bcia_old then
                 assign histor_movto_tit_acr.des_text_histor = histor_movto_tit_acr.des_text_histor
                                                             + "Alteraá∆o Carteira" /*l_alteracao_carteira*/  + " "
                                                             + "de:" /*l_de:*/   + " "
                                                             + string(tt_atualiza_destinac_tit_acr.ttv_cod_cart_bcia_old) + " "
                                                             + "para:" /*l_para:*/   + " "
                                                             + string(tt_atualiza_destinac_tit_acr.ttv_cod_cart_bcia_new) + " " 
                                                             + "Via Programa de Destinaá∆o de T°tulos" /*l_via_prg_destin_tit*/  + "." + chr(10).
             /* chamada de atualizacao do CMG */
             run prgfin/acr/acr776za.py (buffer movto_tit_acr,
                                         output table tt_log_erro_integ,
                                         Input no) /*prg_fnc_movto_tit_acr_integracao_cmg*/.
             run prgfin/cfl/cfl705zd.py (Input 1,
                                         Input movto_tit_acr.ind_trans_acr,
                                         buffer tit_acr,
                                         buffer movto_tit_acr) /*prg_api_integracao_acr_cfl_online*/.         

         end.
         assign tit_acr.log_tit_acr_destndo = yes.
    end.


END PROCEDURE. /* pi_atualiza_destinac_tit_acr */
/*****************************************************************************
** Procedure Interna.....: pi_retorna_parametro_acr
** Descricao.............: pi_retorna_parametro_acr
** Criado por............: bre17906
** Criado em.............: 20/04/1999 08:29:23
** Alterado por..........: bre17906
** Alterado em...........: 09/09/1999 10:32:27
*****************************************************************************/
PROCEDURE pi_retorna_parametro_acr:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_estab
        as character
        format "x(5)"
        no-undo.
    def Input param p_dat_refer
        as date
        format "99/99/9999"
        no-undo.


    /************************* Parameter Definition End *************************/

    find last param_estab_acr no-lock
         where param_estab_acr.cod_estab = p_cod_estab
           and param_estab_acr.dat_inic_valid <= p_dat_refer
           and param_estab_acr.dat_fim_valid >= p_dat_refer
    &if "{&emsfin_version}" >= "5.01" &then
         use-index prmstbcr_data
    &endif
          /*cl_param_estab_acr of param_estab_acr*/ no-error.
    if avail param_estab_acr
       then  return "OK" /*l_ok*/ .
       else  return "NOK" /*l_nok*/ .
END PROCEDURE. /* pi_retorna_parametro_acr */
/*****************************************************************************
** Procedure Interna.....: pi_verificar_portad_bco_tt
** Descricao.............: pi_verificar_portad_bco_tt
** Criado por............: bre17906
** Criado em.............: 02/03/2000 14:32:08
** Alterado por..........: bre17906
** Alterado em...........: 02/03/2000 14:37:44
*****************************************************************************/
PROCEDURE pi_verificar_portad_bco_tt:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_modul_dtsul
        as character
        format "x(3)"
        no-undo.
    def Input param p_cod_estab
        as character
        format "x(5)"
        no-undo.
    def Input param p_cod_portador
        as character
        format "x(5)"
        no-undo.
    def Input param p_cod_cart_bcia
        as character
        format "x(3)"
        no-undo.
    def Input param p_cod_finalid_econ
        as character
        format "x(10)"
        no-undo.
    def Input param p_dat_vencto
        as date
        format "99/99/9999"
        no-undo.
    def Input param p_val_tit_acr
        as decimal
        format ">>>,>>>,>>9.99"
        decimals 2
        no-undo.
    def output param p_des_mensagem
        as character
        format "x(50)"
        no-undo.


    /************************* Parameter Definition End *************************/


    /* ** MANTER ESTA PI EM SINCRONIA COM A PI_VERIFICAR_PORTAD_BCO ***/

    find tt_portad_bco no-lock
        where tt_portad_bco.cod_modul_dtsul  = p_cod_modul_dtsul
          and tt_portad_bco.cod_estab        = p_cod_estab
          and tt_portad_bco.cod_portador     = p_cod_portador
          and tt_portad_bco.cod_cart_bcia    = p_cod_cart_bcia
          and tt_portad_bco.cod_finalid_econ = p_cod_finalid_econ
        no-error.

    if  avail tt_portad_bco
    then do:

        if  p_val_tit_acr < tt_portad_bco.val_min_envio_portad
        then do:

            assign p_des_mensagem = getStrTrans("Valor menor que o m°nimo exigido para envio ao Portador.", "ACR") /*3267*/.
            return "NOK" /*l_nok*/ .
        end /* if */.
        if  p_val_tit_acr > tt_portad_bco.val_max_envio_portad
        then do:

            assign p_des_mensagem = getStrTrans("Valor maior que o m†ximo exigido para envio ao Portador.", "ACR") /*3268*/.
            return "NOK" /*l_nok*/ .
        end /* if */.
        if  p_dat_vencto - v_dat_destinac > tt_portad_bco.qtd_dias_max_envio_portad
        then do:

            assign p_des_mensagem = getStrTrans("Data maior que prazo de envio.", "ACR") /*7442*/.
            return "NOK" /*l_nok*/ .
        end /* if */.    
        if  p_dat_vencto - v_dat_destinac < tt_portad_bco.qtd_dias_min_envio_portad
        then do:

            assign p_des_mensagem = getStrTrans("Data menor que prazo de envio.", "ACR") /*3266*/.
            return "NOK" /*l_nok*/ .
        end /* if */.

        return "OK" /*l_ok*/ .    
    end /* if */.
    else do:

        assign p_des_mensagem = getStrTrans("Portador Banco Inexistente.", "ACR") /*3271*/.
        return "NOK" /*l_nok*/ .
    end /* else */.

END PROCEDURE. /* pi_verificar_portad_bco_tt */
/*****************************************************************************
** Procedure Interna.....: pi_vrf_nom_ender_cobr
** Descricao.............: pi_vrf_nom_ender_cobr
** Criado por............: brf12302
** Criado em.............: 20/03/2001 16:23:22
** Alterado por..........: brf12302
** Alterado em...........: 04/04/2001 11:28:16
*****************************************************************************/
PROCEDURE pi_vrf_nom_ender_cobr:

    /* ## A vari†vel v_cod_cep_dest_cobr ser† usada pelo programa Destinaá∆o de Cobranáa,
          sem o formato do cep. ## */
    assign v_nom_endereco      = pessoa_jurid.nom_endereco
           v_nom_bairro        = pessoa_jurid.nom_bairro
           v_cod_cep           = string(pessoa_jurid.cod_cep, pais.cod_format_cep)
           v_cod_cep_dest_cobr = pessoa_jurid.cod_cep
           v_nom_cidade        = pessoa_jurid.nom_cidade
           v_cod_unid_federac  = pessoa_jurid.cod_unid_federac.

    &if defined(BF_FIN_4LINHAS_END) &then
        cont_block:
        REPEAT v_num_cont_entry = 1 TO NUM-ENTRIES(pessoa_jurid.nom_ender_text, chr(10)):
            if  v_num_cont_entry = 1 then assign v_nom_ender_lin_1 = entry( 1, pessoa_jurid.nom_ender_text, chr(10)).
            if  v_num_cont_entry = 2 then assign v_nom_ender_lin_2 = entry( 2, pessoa_jurid.nom_ender_text, chr(10)).
            if  v_num_cont_entry = 3 then assign v_nom_ender_lin_3 = entry( 3, pessoa_jurid.nom_ender_text, chr(10)).
            if  v_num_cont_entry = 4 then assign v_nom_ender_lin_4 = entry( 4, pessoa_jurid.nom_ender_text, chr(10)).
            if  v_num_cont_entry = 4 then
                leave cont_block.
        end.
    &endif

END PROCEDURE. /* pi_vrf_nom_ender_cobr */
/*****************************************************************************
** Procedure Interna.....: pi_vrf_nom_ender_cobr_1
** Descricao.............: pi_vrf_nom_ender_cobr_1
** Criado por............: brf12302
** Criado em.............: 20/03/2001 16:25:54
** Alterado por..........: brf12302
** Alterado em...........: 20/03/2001 16:27:20
*****************************************************************************/
PROCEDURE pi_vrf_nom_ender_cobr_1:

    /* ## A vari†vel v_cod_cep_dest_cobr ser† usada pelo programa Destinaá∆o de Cobranáa,
         sem o formato do cep. ##*/
    assign v_nom_endereco      = pessoa_jurid.nom_ender_cobr
           v_nom_bairro        = pessoa_jurid.nom_bairro_cobr
           v_cod_cep           = string(pessoa_jurid.cod_cep_cobr, pais.cod_format_cep)
           v_cod_cep_dest_cobr = pessoa_jurid.cod_cep_cobr
           v_nom_cidade        = pessoa_jurid.nom_cidad_cobr
           v_cod_unid_federac  = pessoa_jurid.cod_unid_federac_cobr.

    &if defined(BF_FIN_4LINHAS_END) &then
        cont_block:
        REPEAT v_num_cont_entry = 1 TO NUM-ENTRIES(pessoa_jurid.nom_ender_cobr_text, chr(10)):
            if  v_num_cont_entry = 1 then assign v_nom_ender_lin_1 = entry( 1, pessoa_jurid.nom_ender_cobr_text, chr(10)).
            if  v_num_cont_entry = 2 then assign v_nom_ender_lin_2 = entry( 2, pessoa_jurid.nom_ender_cobr_text, chr(10)).
            if  v_num_cont_entry = 3 then assign v_nom_ender_lin_3 = entry( 3, pessoa_jurid.nom_ender_cobr_text, chr(10)).
            if  v_num_cont_entry = 4 then assign v_nom_ender_lin_4 = entry( 4, pessoa_jurid.nom_ender_cobr_text, chr(10)).
            if  v_num_cont_entry = 4 then
                leave cont_block.
        end.
    &endif

END PROCEDURE. /* pi_vrf_nom_ender_cobr_1 */
/*****************************************************************************
** Procedure Interna.....: pi_vrf_nom_ender_cobr_text
** Descricao.............: pi_vrf_nom_ender_cobr_text
** Criado por............: brf12302
** Criado em.............: 20/03/2001 17:05:38
** Alterado por..........: brf12302
** Alterado em...........: 20/03/2001 17:07:26
*****************************************************************************/
PROCEDURE pi_vrf_nom_ender_cobr_text:

    assign v_nom_endereco      = pessoa_jurid.nom_endereco
           v_cod_cep           = string(pessoa_jurid.cod_cep, pais.cod_format_cep)                
           v_nom_ender_compl   = pessoa_jurid.nom_ender_compl
           v_nom_bairro        = pessoa_jurid.nom_bairro
           v_cod_cx_post       = pessoa_jurid.cod_cx_post
           v_nom_condado       = pessoa_jurid.nom_condado
           v_nom_cidade        = pessoa_jurid.nom_cidade
           v_cod_unid_federac  = pessoa_jurid.cod_unid_federac
           v_cod_cep           = string(pessoa_jurid.cod_cep, pais.cod_format_cep)
           v_cod_cep_dest_cobr = pessoa_jurid.cod_cep.
           /* ## A vari†vel v_cod_cep_dest_cobr ser† usada pelo programa Destinaá∆o de Cobranáa,
           sem o formato do cep. ##*/

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

END PROCEDURE. /* pi_vrf_nom_ender_cobr_text */
/*****************************************************************************
** Procedure Interna.....: pi_vrf_nom_ender_cobr_text_1
** Descricao.............: pi_vrf_nom_ender_cobr_text_1
** Criado por............: brf12302
** Criado em.............: 20/03/2001 17:05:45
** Alterado por..........: brf12302
** Alterado em...........: 20/03/2001 17:07:17
*****************************************************************************/
PROCEDURE pi_vrf_nom_ender_cobr_text_1:

    assign v_nom_endereco      = pessoa_jurid.nom_ender_cobr
           v_cod_cep           = string(pessoa_jurid.cod_cep_cobr, pais.cod_format_cep)                
           v_nom_ender_compl   = pessoa_jurid.nom_ender_compl_cobr
           v_nom_bairro        = pessoa_jurid.nom_bairro_cobr
           v_cod_cx_post       = pessoa_jurid.cod_cx_post_cobr
           v_nom_condado       = pessoa_jurid.nom_condad_cobr
           v_nom_cidade        = pessoa_jurid.nom_cidad_cobr
           v_cod_unid_federac  = pessoa_jurid.cod_unid_federac_cobr
           v_cod_cep           = string(pessoa_jurid.cod_cep_cobr, pais.cod_format_cep)
           v_cod_cep_dest_cobr = pessoa_jurid.cod_cep_cobr.
           /* ## A vari†vel v_cod_cep_dest_cobr ser† usada pelo programa Destinaá∆o de Cobranáa,
           sem o formato do cep. ##*/

    &if defined(BF_FIN_4LINHAS_END) &then
        cont_block:
        REPEAT v_num_cont_entry = 1 TO NUM-ENTRIES(pessoa_jurid.nom_ender_cobr_text, chr(10)):
            if  v_num_cont_entry = 1 then assign v_nom_ender_lin_1 = entry( 1, pessoa_jurid.nom_ender_cobr_text, chr(10)).
            if  v_num_cont_entry = 2 then assign v_nom_ender_lin_2 = entry( 2, pessoa_jurid.nom_ender_cobr_text, chr(10)).
            if  v_num_cont_entry = 3 then assign v_nom_ender_lin_3 = entry( 3, pessoa_jurid.nom_ender_cobr_text, chr(10)).
            if  v_num_cont_entry = 4 then assign v_nom_ender_lin_4 = entry( 4, pessoa_jurid.nom_ender_cobr_text, chr(10)).
            if  v_num_cont_entry = 4 then
                leave cont_block.
        end.
    &endif
END PROCEDURE. /* pi_vrf_nom_ender_cobr_text_1 */
/*****************************************************************************
** Procedure Interna.....: pi_verifica_funcoes_cobr_especial
** Descricao.............: pi_verifica_funcoes_cobr_especial
** Criado por............: bre17205
** Criado em.............: 29/01/2001 18:11:55
** Alterado por..........: src12151
** Alterado em...........: 31/01/2002 14:12:26
*****************************************************************************/
PROCEDURE pi_verifica_funcoes_cobr_especial:

    assign v_log_ender_cobr_contat_sco = no.
    &if defined(BF_FIN_ENDER_COBR_CONTAT_SCO) &then
        assign v_log_ender_cobr_contat_sco = yes.
    &elseif '{&emsfin_version}' >= '5.03'&then
        find histor_exec_especial no-lock
            where histor_exec_especial.cod_modul_dtsul = "UFN" /*l_ufn*/ 
            and   histor_exec_especial.cod_prog_dtsul = 'SPP_ENDER_COBR_CONTAT_SCO':U no-error.
        if avail histor_exec_especial then
            assign v_log_ender_cobr_contat_sco = yes.


        /* Begin_Include: i_funcao_extract */
        if  v_cod_arq <> '' and v_cod_arq <> ?
        then do:

            output stream s-arq to value(v_cod_arq) append.

            put stream s-arq unformatted
                'SPP_ENDER_COBR_CONTAT_SCO'      at 1 
                v_log_ender_cobr_contat_sco  at 43 skip.

            output stream s-arq close.

        end /* if */.
        /* End_Include: i_funcao_extract */

    &endif

    assign v_log_parc_cartcred = no.
    &if defined(BF_FIN_PARC_CARTAO_CREDITO) &then
        assign v_log_parc_cartcred = yes.
    &else
        find histor_exec_especial no-lock
            where histor_exec_especial.cod_modul_dtsul = "UFN" /*l_ufn*/ 
            and   histor_exec_especial.cod_prog_dtsul = 'SPP_PARC_CARTCRED_SCO':U no-error.
        if avail histor_exec_especial then
            assign v_log_parc_cartcred = yes.


        /* Begin_Include: i_funcao_extract */
        if  v_cod_arq <> '' and v_cod_arq <> ?
        then do:

            output stream s-arq to value(v_cod_arq) append.

            put stream s-arq unformatted
                'SPP_PARC_CARTCRED_SCO'      at 1 
                v_log_parc_cartcred  at 43 skip.

            output stream s-arq close.

        end /* if */.
        /* End_Include: i_funcao_extract */

    &endif

    assign v_log_autoriz_cobr_cartao_cr = no.
    &if defined(BF_FIN_AUTORIZ_COBR_CARTAO_CR) &then
        assign v_log_autoriz_cobr_cartao_cr = yes.
    &else
        find histor_exec_especial no-lock
            where histor_exec_especial.cod_modul_dtsul  = 'UFN'
             and    histor_exec_especial.cod_prog_dtsul = 'SPP_LIBER_AUTORIZ_COBR_CARTAO_CR':U no-error.
        if avail histor_exec_especial then
            assign v_log_autoriz_cobr_cartao_cr = yes.


        /* Begin_Include: i_funcao_extract */
        if  v_cod_arq <> '' and v_cod_arq <> ?
        then do:

            output stream s-arq to value(v_cod_arq) append.

            put stream s-arq unformatted
                'SPP_LIBER_AUTORIZ_COBR_CARTAO_CR'      at 1 
                v_log_autoriz_cobr_cartao_cr  at 43 skip.

            output stream s-arq close.

        end /* if */.
        /* End_Include: i_funcao_extract */

    &endif
END PROCEDURE. /* pi_verifica_funcoes_cobr_especial */
/*****************************************************************************
** Procedure Interna.....: pi_verifica_vendor
** Descricao.............: pi_verifica_vendor
** Criado por............: bre19062
** Criado em.............: 15/09/2002 17:37:36
** Alterado por..........: bre19062
** Alterado em...........: 15/09/2002 17:38:53
*****************************************************************************/
PROCEDURE pi_verifica_vendor:


    /* Begin_Include: i_vrf_modul_vendor */
    /* Verifica liberaªá∆o do m¢dulo Vendor*/
    /* Alteraá∆o sob demanda, favor manter a alteraá∆o abaixo*/
    assign v_log_modul_vendor = no.
    &IF '{&emsfin_version}' >= '5.05'  AND '{&emsfin_version}' <= '5.06'   &THEN 
        run prgfin/acr/acr930za.py (output v_log_modul_vendor) /* prg_fnc_verifica_liberacao_vendor*/.
    &ELSE
        assign v_log_modul_vendor = not(GetDefinedFunction('SPP_DESATIVA_VENDOR':U)).
    &ENDIF
    /* End_Include: i_vrf_modul_vendor */

END PROCEDURE. /* pi_verifica_vendor */
/*****************************************************************************
** Procedure Interna.....: pi_executar_destinac_percent
** Descricao.............: pi_executar_destinac_percent
** Criado por............: brf12302
** Criado em.............: 21/03/2003 16:56:16
** Alterado por..........: fut12235
** Alterado em...........: 28/10/2021 17:17:59
*****************************************************************************/
PROCEDURE pi_executar_destinac_percent:

    /************************* Variable Definition Begin ************************/

    def var v_dsl_msg_rpt                    as character       no-undo. /*local*/
    def var v_log_meta_complet               as logical         no-undo. /*local*/
    def var v_log_validac_bco                as logical         no-undo. /*local*/
    def var v_val_cobr                       as decimal         no-undo. /*local*/


    /************************** Variable Definition End *************************/

    titulo:
    for each tt_tit_destinac_percent no-lock:

        find tit_acr no-lock 
            where tit_acr.cod_estab      = tt_tit_destinac_percent.tta_cod_estab
            and   tit_acr.num_id_tit_acr = tt_tit_destinac_percent.tta_num_id_tit_acr no-error.

        find tt_rpt_tit_acr_destinac exclusive-lock
            where tt_rpt_tit_acr_destinac.ttv_rec_tit_acr = recid(tit_acr) no-error.

        table_child:
        for each tt_item_destinac_cobr_dest:


            /* Begin_Include: i_valida_portad_item_destinac_cobr_pix */
            &if defined(BF_FIN_PIX_3_FLEXIBILIZA) &then
            if  v_log_cobr_acr_pix
            then do:

               if  not can-find(first portad_edi
                                where portad_edi.cod_modul_dtsul  = "ACR" /*l_acr*/ 
                                  and portad_edi.cod_estab        = tit_acr.cod_estab
                                  and portad_edi.cod_portador     = tt_item_destinac_cobr_dest.cod_portador
                                  and portad_edi.cod_cart_bcia    = tt_item_destinac_cobr_dest.cod_cart_bcia
                                  and portad_edi.log_cobr_acr_pix = yes)
               then do:

                   assign v_dsl_msg_rpt = substitute(getStrTrans("O Portador Item Destinaá∆o &1 relacionado a Regra de Destinaá∆o &2 n∆o Ç v†lido. Esta Regra Ç para Cobranáa &3 e faz-se necess†rio que o Portador EDI tambÇm esteja coerente com esta modalidade de Cobranáa. Relacione um Portador Item Destinaá∆o v†lido aos ParÉmetros Destinaá∆o de Cobranáa ou modifique o cadastro Portador EDI e &4 o parÉmetro Cobranáa PIX para o atual Portador da Regra: M¢dulo: ACR / Estab: &5 / Portador: &1 / Carteira: &6 .", "ACR") /*23396*/,
                                                     tt_item_destinac_cobr_dest.cod_portador, 
                                                     v_cod_destinac_cobr, 
                                                     getStrTrans("PIX", "ACR") /*l_pix*/ ,
                                                     'marque',
                                                     tit_acr.cod_estab,
                                                     tt_item_destinac_cobr_dest.cod_cart_bcia).              

                   run pi_atualiza_tabelas_destinac (Input no,
                                                     input tt_item_destinac_cobr_dest.cod_portador,
                                                     Input tt_item_destinac_cobr_dest.cod_cart_bcia,
                                                     Input v_dsl_msg_rpt,
                                                     Input 0,
                                                     Input 99) /*pi_atualiza_tabelas_destinac*/.
                   return "NOK" /*l_nok*/ .
                end /* if */.
            end /* if */.
            else do:
                find first portador no-lock                                         
                     where portador.cod_portador    = tt_item_destinac_cobr_dest.cod_portador           
                       and portador.ind_tip_portad <> "Caixa" /*l_caixa*/  no-error.
                if avail portador then do:
                    if  v_cod_pais_empres_usuar = "BRA" /*l_bra*/ 
                    and not can-find(first portad_edi
                                     where portad_edi.cod_modul_dtsul  = "ACR" /*l_acr*/ 
                                       and portad_edi.cod_estab        = tit_acr.cod_estab
                                       and portad_edi.cod_portador     = tt_item_destinac_cobr_dest.cod_portador
                                       and portad_edi.cod_cart_bcia    = tt_item_destinac_cobr_dest.cod_cart_bcia
                                       and (portad_edi.log_cobr_acr_pix = no
                                        or portad_edi.log_cobr_acr_pix = ?))
                    then do:

                       assign v_dsl_msg_rpt = substitute(getStrTrans("O Portador Item Destinaá∆o &1 relacionado a Regra de Destinaá∆o &2 n∆o Ç v†lido. Esta Regra Ç para Cobranáa &3 e faz-se necess†rio que o Portador EDI tambÇm esteja coerente com esta modalidade de Cobranáa. Relacione um Portador Item Destinaá∆o v†lido aos ParÉmetros Destinaá∆o de Cobranáa ou modifique o cadastro Portador EDI e &4 o parÉmetro Cobranáa PIX para o atual Portador da Regra: M¢dulo: ACR / Estab: &5 / Portador: &1 / Carteira: &6 .", "ACR") /*23396*/,
                                                         tt_item_destinac_cobr_dest.cod_portador, 
                                                         v_cod_destinac_cobr, 
                                                         getStrTrans("Normal", "ACR") /*l_normal*/ ,
                                                         'desmarque',
                                                         tit_acr.cod_estab,
                                                         tt_item_destinac_cobr_dest.cod_cart_bcia).               

                       run pi_atualiza_tabelas_destinac (Input no,
                                                         input tt_item_destinac_cobr_dest.cod_portador,
                                                         Input tt_item_destinac_cobr_dest.cod_cart_bcia,
                                                         Input v_dsl_msg_rpt,
                                                         Input 0,
                                                         Input 99) /*pi_atualiza_tabelas_destinac*/.
                       return "NOK" /*l_nok*/ .
                    end /* if */.
                end.
            end /* else */.
            &endif
            /* End_Include: i_valida_portad_item_destinac_cobr_pix */


            /* **Posiciona tt_portad_finalid_econ para verificaØ?o de validaØ?o de CEP.***/                         
            find tt_portad_finalid_econ                                                                             
                 where tt_portad_finalid_econ.tta_cod_portador     = tt_item_destinac_cobr_dest.cod_portador        
                   and tt_portad_finalid_econ.tta_cod_cart_bcia    = tt_item_destinac_cobr_dest.cod_cart_bcia       
                   and tt_portad_finalid_econ.tta_cod_finalid_econ = destinac_cobr.cod_finalid_econ no-error.       

            find cta_corren                                                                                        
                 where cta_corren.cod_cta_corren = tt_portad_finalid_econ.tta_cod_cta_corren                       
                 no-lock no-error.                                                                                 
            find banco                                                                                             
                 where banco.cod_banco = cta_corren.cod_banco                                                      
                 no-lock no-error.                                                                                 

            run pi_verificar_portad_bco_tt (Input "ACR" /*l_acr*/,
                                            Input tit_acr.cod_estab,
                                            Input tt_item_destinac_cobr_dest.cod_portador,
                                            Input tt_item_destinac_cobr_dest.cod_cart_bcia,
                                            Input destinac_cobr.cod_finalid_econ,
                                            Input tit_acr.dat_vencto_tit_acr,
                                            Input tit_acr.val_sdo_tit_acr,
                                            output v_des_mensagem) /*pi_verificar_portad_bco_tt*/.                 

            if  return-value = "NOK" /*l_nok*/  then
                assign v_log_validac_bco = no.                                                                 
            else
                assign v_log_validac_bco = yes.                                                                   

            if  v_log_validac_bco = yes /* indica que regras do portador estao ok */
            and tt_portad_finalid_econ.tta_log_validac_cep_destinac then do:                                                                                               

                run pi_valida_cep_agencia_destinac_cobr (input v_log_validac_bco,input cta_corren.cod_banco).  
                
                if return-value <> "OK" then do:                                                     
                   run pi_atualiza_tabelas_destinac (Input no,                                                 
                                                     input tt_item_destinac_cobr_dest.cod_portador,            
                                                     Input tt_item_destinac_cobr_dest.cod_cart_bcia,           
                                                     Input v_des_mensagem,                                     
                                                     Input 0,                                                  
                                                     Input 99) /* pi_atualiza_tabelas_destinac*/.               

                   /* ** PREPARA VALOR DA META DA DESTINAÄ«O ***/
                   assign v_val_destinac_portad = (v_val_tot_dest * tt_item_destinac_cobr_dest.val_perc_niv_cobr) / 100.

                   if  tt_portad_finalid_econ.ttv_val_meta_destinac = 0 then
                       assign tt_portad_finalid_econ.ttv_val_meta_destinac = v_val_destinac_portad.

                   next table_child.                                                                         
                end.                                                                                           
            end.  
            /*
            else do:
                if  v_log_validac_bco = yes then do:
                    run pi_atualiza_tabelas_destinac (Input yes,
                                                      input tt_item_destinac_cobr_dest.cod_portador,
                                                      Input tt_item_destinac_cobr_dest.cod_cart_bcia,
                                                      Input getStrTrans("Portador da destinaá∆o de cobranáa.", "ACR"),
                                                      Input tt_item_destinac_cobr_dest.num_ord_destinac,
                                                      Input 99) /*pi_atualiza_tabelas_destinac*/.
                    
                    /*next table_child.*/
    
                    /*next titulo.*/
                end.
            end. 
            */

            /* ** PREPARA VALOR DA META DA DESTINAÄ«O ***/
            assign v_val_destinac_portad = (v_val_tot_dest * tt_item_destinac_cobr_dest.val_perc_niv_cobr) / 100.

            if  tt_portad_finalid_econ.ttv_val_meta_destinac = 0 then
                assign tt_portad_finalid_econ.ttv_val_meta_destinac = v_val_destinac_portad.

            /* ** CALCULA VALOR DO RESULTADO DA DESTINAÄ«O ***/
            /* ** SE A META DA DESTINAÄ«O DEVE IGNORAR O SALDO ATUAL EM COBRAN∞A DO PORTADOR ***/
            assign v_log_meta_complet = (tt_portad_finalid_econ.ttv_val_tot_destndo >= tt_portad_finalid_econ.ttv_val_meta_destinac)
                   v_val_cobr         = tt_portad_finalid_econ.ttv_val_tot_destndo + tit_acr.val_sdo_tit_acr
                   v_cod_portador     = tt_item_destinac_cobr_dest.cod_portador
                   v_cod_cart_bcia_1  = tt_item_destinac_cobr_dest.cod_cart_bcia.

            /* ** CALCULA PERCENTUAL DE ERRO ***/
            assign v_val_destinac_portad = v_val_destinac_portad + ( v_val_destinac_portad * tt_item_destinac_cobr_dest.val_perc_erro_destinac / 100 ).

            if  v_log_meta_complet
            or  v_val_cobr > v_val_destinac_portad then do:
                /* ** SE A META Jµ FOI ATINGIDA
                 *** OU N«O FOI ATINGIDA, MAS O T÷TULO ULTRAPASSA O LIMITE ACEITµVEL ***/
                run pi_atualiza_tabelas_destinac (Input no,
                                                  input tt_item_destinac_cobr_dest.cod_portador,
                                                  Input tt_item_destinac_cobr_dest.cod_cart_bcia,
                                                  Input "Excedeu Meta." /*l_excedeu_meta*/,
                                                  Input tt_item_destinac_cobr_dest.num_ord_destinac,
                                                  Input 99) /*pi_atualiza_tabelas_destinac*/.

                assign v_cod_portador_res  = tt_item_destinac_cobr_dest.cod_portador
                       v_cod_cart_bcia_res = tt_item_destinac_cobr_dest.cod_cart_bcia.

                next table_child.
            end /* if */.
            else do:

                run pi_atualiza_tabelas_destinac (Input yes,
                                                  input tt_item_destinac_cobr_dest.cod_portador,
                                                  Input tt_item_destinac_cobr_dest.cod_cart_bcia,
                                                  Input getStrTrans("Portador da destinaá∆o de cobranáa.", "ACR") /*3382*/,
                                                  Input tt_item_destinac_cobr_dest.num_ord_destinac,
                                                  Input 3) /*pi_atualiza_tabelas_destinac*/.
                next titulo.
            end.
        end.

        run pi_executar_tit_acr_destinac_nok_portad /*pi_executar_tit_acr_destinac_nok_portad*/.
        if  return-value <> "OK" /*l_ok*/  then
            next titulo.
    end.
END PROCEDURE. /* pi_executar_destinac_percent */
/*****************************************************************************
** Procedure Interna.....: pi_executar_tit_acr_destinac_nok_portad
** Descricao.............: pi_executar_tit_acr_destinac_nok_portad
** Criado por............: brf12302
** Criado em.............: 25/03/2003 11:12:34
** Alterado por..........: fut12235
** Alterado em...........: 27/10/2021 17:24:09
*****************************************************************************/
PROCEDURE pi_executar_tit_acr_destinac_nok_portad:

    /************************* Variable Definition Begin ************************/

    def var v_dsl_msg_rpt                    as character       no-undo. /*local*/


    /************************** Variable Definition End *************************/

    /* ** SE N«O ACHOU NENHUM PORTADOR, VERIFICA SE PODE UTILIZAR O RESERVA ***/
    if  destinac_cobr.log_destina_todos_tit_acr = yes
    and v_cod_portador_res <> ""
    then do:

        /* ** Caso a Carteira seja vendor o t°tulo deve possuir as Informaá‰es Vendor ***/
        assign v_log_destinac = yes 
               v_log_cart_bcia_vendor = no.

        if  can-find(cart_bcia 
                     where cart_bcia.cod_cart_bcia = v_cod_cart_bcia_res
                     and   cart_bcia.ind_tip_cart_bcia = "Vendor" /*l_vendor*/ ) then 
            assign v_log_cart_bcia_vendor = yes.

        if  not v_log_tit_vendor
        and v_log_cart_bcia_vendor then 
            assign v_log_destinac = no.

        /* ** Caso a Carteira seja Descontada ser† barrada a destinaá∆o ***/
        if can-find(cart_bcia 
              where cart_bcia.cod_cart_bcia = v_cod_cart_bcia_res
              and   cart_bcia.ind_tip_cart_bcia = "Desconto" /*l_desconto*/ ) then do:
            run pi_atualiza_tabelas_destinac (Input no,
                                              input v_cod_portador_res,
                                              Input v_cod_cart_bcia_res,
                                              Input getStrTrans("T°tulo n∆o pode ser destinado para uma carteira Desconto !", "ACR") /*19520*/,
                                              Input 0,
                                              Input 99) /*pi_atualiza_tabelas_destinac*/.
            return "NOK" /*l_nok*/ .
        end.

        if  v_log_destinac then do:
            find first tt_item_destinac_cobr_dest no-lock
                 where tt_item_destinac_cobr_dest.cod_empresa           = destinac_cobr.cod_empresa
                   and tt_item_destinac_cobr_dest.cod_destinac_cobr     = v_cod_destinac_cobr
                   and tt_item_destinac_cobr_dest.num_seq_destinac_cobr = destinac_cobr.num_seq_destinac_cobr
                   and tt_item_destinac_cobr_dest.cod_portador          = v_cod_portador_res
                   and tt_item_destinac_cobr_dest.cod_cart_bcia         = v_cod_cart_bcia_res no-error.
            assign v_cod_portador    = v_cod_portador_res
                   v_cod_cart_bcia_1 = v_cod_cart_bcia_res.
            run pi_atualiza_tabelas_destinac (Input yes,
                                              input tt_item_destinac_cobr_dest.cod_portador,
                                              Input tt_item_destinac_cobr_dest.cod_cart_bcia,
                                              Input getStrTrans("Portador Reserva da destinaá∆o de cobranáa.", "ACR") /*4987*/,
                                              Input tt_item_destinac_cobr_dest.num_ord_destinac,
                                              Input 3) /*pi_atualiza_tabelas_destinac*/.
            return "NOK" /*l_nok*/ .
        end.
    end /* if */.

    /* ** SE N«O ENCONTROU PORTADOR PARA DESTINAÄ«O, VERIFICA PORTADOR AUTO-EMISS«O ***/
    if  tit_acr.dat_vencto_tit_acr - v_dat_destinac >= 0
    and destinac_cobr.log_habilit_auto_emis
    then do:

        /* ** Caso a Carteira seja vendor o t°tulo deve possuir as Informaá‰es Vendor ***/
        assign v_log_destinac = yes 
               v_log_cart_bcia_vendor = no.

        if  can-find(cart_bcia 
                     where cart_bcia.cod_cart_bcia = destinac_cobr.cod_cart_bcia_auto_emis
                     and   cart_bcia.ind_tip_cart_bcia = "Vendor" /*l_vendor*/ ) then 
            assign v_log_cart_bcia_vendor = yes.

        if  not v_log_tit_vendor
        and v_log_cart_bcia_vendor then 
            assign v_log_destinac = no.

        /* ** Caso a Carteira seja Descontada ser† barrada a destinaá∆o ***/
        if can-find(cart_bcia 
              where cart_bcia.cod_cart_bcia = destinac_cobr.cod_cart_bcia_auto_emis
              and   cart_bcia.ind_tip_cart_bcia = "Desconto" /*l_desconto*/ ) then do:
            run pi_atualiza_tabelas_destinac (Input no,
                                              input destinac_cobr.cod_portad_auto_emis,
                                              Input destinac_cobr.cod_cart_bcia_auto_emis,
                                              Input getStrTrans("T°tulo n∆o pode ser destinado para uma carteira Desconto !", "ACR") /*19520*/,
                                              Input 0,
                                              Input 99) /*pi_atualiza_tabelas_destinac*/.
            return "NOK" /*l_nok*/ .
        end.

        if v_log_destinac then do:

            /* Begin_Include: i_valida_portad_auto_emissao_cobr_pix */
            &if defined(BF_FIN_PIX_3_FLEXIBILIZA) &then
            if  v_log_cobr_acr_pix
            then do:

               if  not can-find(first portad_edi
                                where portad_edi.cod_modul_dtsul  = "ACR" /*l_acr*/ 
                                  and portad_edi.cod_estab        = tit_acr.cod_estab
                                  and portad_edi.cod_portador     = destinac_cobr.cod_portad_auto_emis
                                  and portad_edi.cod_cart_bcia    = destinac_cobr.cod_cart_bcia_auto_emis
                                  and portad_edi.log_cobr_acr_pix = yes)
               then do:

                   assign v_dsl_msg_rpt = substitute(getStrTrans("O Portador Auto Emiss∆o &1 relacionado a Regra de Destinaá∆o &2 n∆o Ç v†lido. Esta Regra Ç para Cobranáa &3 e faz-se necess†rio que o Portador EDI tambÇm esteja coerente com esta modalidade de Cobranáa. Informe um Portador Auto Emiss∆o v†lido nos ParÉmetros Destinaá∆o de Cobranáa ou modifique o cadastro Portador EDI e &4 o parÉmetro Cobranáa PIX para o atual Portador Auto Emiss∆o: M¢dulo: ACR / Estab: &5 / Portador: &1 / Carteira: &6", "ACR") /*23393*/,
                                                     destinac_cobr.cod_portad_auto_emis, 
                                                     v_cod_destinac_cobr, 
                                                     getStrTrans("PIX", "ACR") /*l_pix*/ ,
                                                     'marque',
                                                     tit_acr.cod_estab,
                                                     destinac_cobr.cod_cart_bcia_auto_emis).              

                   run pi_atualiza_tabelas_destinac (Input no,
                                                     input destinac_cobr.cod_portad_auto_emis,
                                                     Input destinac_cobr.cod_cart_bcia_auto_emis,
                                                     Input v_dsl_msg_rpt,
                                                     Input 0,
                                                     Input 99) /*pi_atualiza_tabelas_destinac*/.
                   return "NOK" /*l_nok*/ .
                end /* if */.
            end /* if */.
            else do:    
                find first portador no-lock                                                   
                     where portador.cod_portador    = destinac_cobr.cod_portad_auto_emis  
                       and portador.ind_tip_portad <> "Caixa" /*l_caixa*/  no-error.      
                if avail portador then do:        
                    if  v_cod_pais_empres_usuar = "BRA" /*l_bra*/ 
                    and not can-find(first portad_edi
                                     where portad_edi.cod_modul_dtsul  = "ACR" /*l_acr*/ 
                                       and portad_edi.cod_estab        = tit_acr.cod_estab
                                       and portad_edi.cod_portador     = destinac_cobr.cod_portad_auto_emis
                                       and portad_edi.cod_cart_bcia    = destinac_cobr.cod_cart_bcia_auto_emis
                                       and (portad_edi.log_cobr_acr_pix = no
                                        or portad_edi.log_cobr_acr_pix = ?))
                    then do:

                       assign v_dsl_msg_rpt = substitute(getStrTrans("O Portador Auto Emiss∆o &1 relacionado a Regra de Destinaá∆o &2 n∆o Ç v†lido. Esta Regra Ç para Cobranáa &3 e faz-se necess†rio que o Portador EDI tambÇm esteja coerente com esta modalidade de Cobranáa. Informe um Portador Auto Emiss∆o v†lido nos ParÉmetros Destinaá∆o de Cobranáa ou modifique o cadastro Portador EDI e &4 o parÉmetro Cobranáa PIX para o atual Portador Auto Emiss∆o: M¢dulo: ACR / Estab: &5 / Portador: &1 / Carteira: &6", "ACR") /*23393*/,
                                                         destinac_cobr.cod_portad_auto_emis, 
                                                         v_cod_destinac_cobr, 
                                                         getStrTrans("Normal", "ACR") /*l_normal*/ ,
                                                         'desmarque',
                                                         tit_acr.cod_estab,
                                                         destinac_cobr.cod_cart_bcia_auto_emis).               

                       run pi_atualiza_tabelas_destinac (Input no,
                                                         input destinac_cobr.cod_portad_auto_emis,
                                                         Input destinac_cobr.cod_cart_bcia_auto_emis,
                                                         Input v_dsl_msg_rpt,
                                                         Input 0,
                                                         Input 99) /*pi_atualiza_tabelas_destinac*/.
                       return "NOK" /*l_nok*/ .
                    end /* if */.
                end.
            end /* else */.
            &endif
            /* End_Include: i_valida_portad_auto_emissao_cobr_pix */


            assign v_cod_portador    = destinac_cobr.cod_portad_auto_emis
                   v_cod_cart_bcia_1 = destinac_cobr.cod_cart_bcia_auto_emis.
            find first tt_portad_fe_param_estab no-lock
                where tt_portad_fe_param_estab.tta_cod_estab        = tit_acr.cod_estab
                  and tt_portad_fe_param_estab.tta_cod_portador     = destinac_cobr.cod_portad_auto_emis
                  and tt_portad_fe_param_estab.tta_cod_finalid_econ = destinac_cobr.cod_finalid_econ
                  and tt_portad_fe_param_estab.tta_cod_cart_bcia    = destinac_cobr.cod_cart_bcia_auto_emis no-error.
            if avail tt_portad_fe_param_estab then do:
                assign v_des_mensagem = "".
                /* ** N∆o Ç possivel enviar t°tulos de carteira vendor via EDI ***/
                if  destinac_cobr.log_envio_via_edi
                and not v_log_cart_bcia_vendor then do:
                    run pi_validar_envio_edi_destinacao (Input tit_acr.cod_estab,
                                                         Input destinac_cobr.cod_portad_auto_emis,
                                                         Input destinac_cobr.cod_cart_bcia_auto_emis,
                                                         Input tit_acr.cod_indic_econ,
                                                         Input tit_acr.dat_emis_docto,
                                                         output v_des_mensagem) /*pi_validar_envio_edi_destinacao*/.
                end.
                if  v_des_mensagem = "" then do:
                    run pi_atualiza_tabelas_destinac (Input yes,
                                                      input destinac_cobr.cod_portad_auto_emis,
                                                      Input destinac_cobr.cod_cart_bcia_auto_emis,
                                                      Input getStrTrans("Portador de Auto-Emiss∆o.", "ACR") /*3280*/,
                                                      Input 0,
                                                      Input 2) /*pi_atualiza_tabelas_destinac*/.
                end.
                else do:
                    run pi_atualiza_tabelas_destinac (Input no,
                                                      input destinac_cobr.cod_portad_auto_emis,
                                                      Input destinac_cobr.cod_cart_bcia_auto_emis,
                                                      Input getStrTrans("Portador de Auto-Emiss∆o.", "ACR") /*3280*/ + " " + v_des_mensagem,
                                                      Input 0,
                                                      Input 99) /*pi_atualiza_tabelas_destinac*/.
                end.
            end.
            else do: 
                run pi_atualiza_tabelas_destinac (Input no,
                                                  input destinac_cobr.cod_portad_auto_emis,
                                                  Input destinac_cobr.cod_cart_bcia_auto_emis,
                                                  Input "Portador de Auto Emiss∆o:" /*l_portad_auto_emis*/  + " " + getStrTrans("N∆o existe Portador Finalidade Econìmica ou ParÉmetros do Estabelecimento ACR!", "ACR") /*7433*/,
                                                  Input 0,
                                                  Input 99) /*pi_atualiza_tabelas_destinac*/.
                return "NOK" /*l_nok*/ .
            end.              
        end.
    end /* if */.

    return "OK" /*l_ok*/ .
END PROCEDURE. /* pi_executar_tit_acr_destinac_nok_portad */
/*****************************************************************************
** Procedure Interna.....: pi_rpt_tit_acr_destinac_aux
** Descricao.............: pi_rpt_tit_acr_destinac_aux
** Criado por............: brf12302
** Criado em.............: 25/03/2003 11:49:18
** Alterado por..........: fut12235
** Alterado em...........: 01/11/2021 17:48:51
*****************************************************************************/
PROCEDURE pi_rpt_tit_acr_destinac_aux:

    /************************* Variable Definition Begin ************************/

    def var v_log_exist                      as logical         no-undo. /*local*/


    /************************** Variable Definition End *************************/

    if (tit_acr.ind_tip_espec_docto <> "Normal" /*l_normal*/ 
    and tit_acr.ind_tip_espec_docto <> "Terceiros" /*l_terceiros*/  /* controle terceiros */
    and tit_acr.ind_tip_espec_docto <> "Aviso DÇbito" /*l_aviso_debito*/  
    and tit_acr.ind_tip_espec_docto <> "Cheques Recebidos" /*l_cheques_recebidos*/ 
    and tit_acr.ind_tip_espec_docto <> "Cheques Terceiros" /*l_cheq_terc*/  /* controle terceiros */ ) then 
        return "NOK" /*l_nok*/ .

    if (( not v_log_habilit_redestina_cobr and tit_acr.log_tit_acr_destndo) or
        ( v_log_habilit_redestina_cobr and not tit_acr.log_tit_acr_destndo)) then
        return "NOK" /*l_nok*/ .

    run pi_verifica_movto_tit_acr_posterior (Input tit_acr.cod_estab,
                                             Input tit_acr.num_id_tit_acr,
                                             Input 0,
                                             Input v_dat_destinac,
                                             Input "Destinaá∆o" /*l_destinacao*/,
                                             output v_log_exist) /*pi_verifica_movto_tit_acr_posterior*/.
    if  v_log_exist then
        return "NOK" /*l_nok*/ .

    /* Verifica se o pa°s da pessoa do t°tulo Ç diferente do pa°s do usu†rio*/
    if  tit_acr.num_pessoa mod 2 = 0 then do:
        find pessoa_fisic no-lock
            where pessoa_fisic.num_pessoa_fisic = tit_acr.num_pessoa no-error.
        if  avail pessoa_fisic
        and pessoa_fisic.cod_pais <> v_cod_pais_empres_usuar then
            return "NOK" /*l_nok*/ .
    end.
    else do:
        find pessoa_jurid no-lock
            where pessoa_jurid.num_pessoa_jurid = tit_acr.num_pessoa no-error.
        if  avail pessoa_jurid
        and pessoa_jurid.cod_pais <> v_cod_pais_empres_usuar then
                return "NOK" /*l_nok*/ .
    end.

    &if defined(BF_FIN_PIX_3_FLEXIBILIZA) &then
    if  v_cod_pais_empres_usuar = "BRA" /*l_bra*/ 
    and v_log_cobr_acr_pix 
    and not can-find(first clien_financ no-lock
                     where clien_financ.cod_empresa = tit_acr.cod_empresa
                       and clien_financ.cdn_cliente = tit_acr.cdn_cliente
                       and clien_financ.log_cobr_acr_pix = yes) then return "NOK" /*l_nok*/ .
    &endif

    &if defined(BF_FIN_MAIS_NEGOCIOS_FLEXIBILIZA) &then
        if v_log_integr_mais_negoc then do:
           if (tit_acr.cod_portador = v_cod_portad_mais_negoc or tit_acr.cod_cart_bcia = v_cod_cart_bcia_mais_negoc) then return "NOK" /*l_nok*/ .
        end.
    &endif

    assign v_rec_tit_acr = recid(tit_acr)
           v_cod_estab   = tit_acr.cod_estab.
    run pi_tratar_tt_rpt_tit_acr_destinac /*pi_tratar_tt_rpt_tit_acr_destinac*/.
    if return-value = "NOK" /*l_nok*/  then return "NOK" /*l_nok*/ .
    if  v_ind_tip_destinac = "Listagem de T°tulos a Destinar" /*l_listagem_de_titulos_a_destinar*/  then
        return "NOK" /*l_nok*/ .
    if  not v_log_destinac_manual then
        run pi_executar_tit_acr_destinac /*pi_executar_tit_acr_destinac*/.

    return "OK" /*l_ok*/ .
END PROCEDURE. /* pi_rpt_tit_acr_destinac_aux */
/*****************************************************************************
** Procedure Interna.....: pi_verifica_tit_nao_destinados
** Descricao.............: pi_verifica_tit_nao_destinados
** Criado por............: tatiana
** Criado em.............: 11/04/2003 11:08:46
** Alterado por..........: tatiana
** Alterado em...........: 11/04/2003 15:54:36
*****************************************************************************/
PROCEDURE pi_verifica_tit_nao_destinados:

    assign v_log_funcao_tit_nao_dest = no.

    &if defined(BF_FIN_LISTA_TITULO_NAO_DESTINADO) &then
        assign v_log_funcao_tit_nao_dest = yes.
    &else
        if  can-find(first histor_exec_especial 
            where histor_exec_especial.cod_prog_dtsul = 'spp_lista_titulo_nao_destinado') then do:
            assign v_log_funcao_tit_nao_dest = yes.
        end.

        /* Begin_Include: i_funcao_extract */
        if  v_cod_arq <> '' and v_cod_arq <> ?
        then do:

            output stream s-arq to value(v_cod_arq) append.

            put stream s-arq unformatted
                'spp_lista_titulo_nao_destinado'      at 1 
                v_log_funcao_tit_nao_dest  at 43 skip.

            output stream s-arq close.

        end /* if */.
        /* End_Include: i_funcao_extract */

    &endif

END PROCEDURE. /* pi_verifica_tit_nao_destinados */
/*****************************************************************************
** Procedure Interna.....: pi_ix_p10_rpt_tit_acr_destinac
** Descricao.............: pi_ix_p10_rpt_tit_acr_destinac
** Criado por............: tatiana
** Criado em.............: 11/04/2003 15:21:33
** Alterado por..........: fut12235
** Alterado em...........: 25/10/2021 15:04:14
*****************************************************************************/
PROCEDURE pi_ix_p10_rpt_tit_acr_destinac:

    /* ---Listar Consistància de T°tulos N∆o Destinados---*/
    if v_log_funcao_tit_nao_dest = yes then do:
       assign v_log_tit_nao_destndo:visible in frame f_rpt_41_tit_acr_destinac = yes.
    end.
    else do:
       assign v_log_tit_nao_destndo:visible in frame f_rpt_41_tit_acr_destinac = no.
    end.

    &if defined(BF_FIN_PIX_3_FLEXIBILIZA) &then
    if  v_cod_pais_empres_usuar = "BRA" /*l_bra*/ 
    then do:
       assign v_log_cobr_acr_pix:visible in frame f_rpt_41_tit_acr_destinac = yes.
       enable v_log_cobr_acr_pix
              with frame f_rpt_41_tit_acr_destinac.
    end /* if */.
    else
       assign v_log_cobr_acr_pix:visible in frame f_rpt_41_tit_acr_destinac = no.
    &else
       assign v_log_cobr_acr_pix:visible in frame f_rpt_41_tit_acr_destinac = no.
    &endif

    if  num-entries( dwb_rpt_param.cod_dwb_parameters , chr(10) ) >= 34  then do:
        assign v_cod_destinac_cobr          = entry(1, dwb_rpt_param.cod_dwb_parameters, chr(10))
               v_dat_destinac               = date(entry(2, dwb_rpt_param.cod_dwb_parameters, chr(10)))
               v_ind_tip_destinac           = entry(3, dwb_rpt_param.cod_dwb_parameters, chr(10))
               v_log_destinac_manual        = (entry(4, dwb_rpt_param.cod_dwb_parameters, chr(10)) = "yes" /*l_yes*/ )
               v_log_habilit_redestina_cobr = (entry(5, dwb_rpt_param.cod_dwb_parameters, chr(10)) = "yes" /*l_yes*/ )
               v_cdn_cliente_fim            = integer(entry(6, dwb_rpt_param.cod_dwb_parameters, chr(10)))
               v_cdn_cliente_ini            = integer(entry(7, dwb_rpt_param.cod_dwb_parameters, chr(10)))
               v_cod_cart_bcia_fim          = entry(8, dwb_rpt_param.cod_dwb_parameters, chr(10))
               v_cod_cart_bcia_inicial      = entry(9, dwb_rpt_param.cod_dwb_parameters, chr(10))
               v_cod_espec_docto_fim        = entry(10, dwb_rpt_param.cod_dwb_parameters, chr(10))
               v_cod_espec_docto_ini        = entry(11, dwb_rpt_param.cod_dwb_parameters, chr(10))
               v_cod_parcela_fim            = entry(12, dwb_rpt_param.cod_dwb_parameters, chr(10))
               v_cod_parcela_ini            = entry(13, dwb_rpt_param.cod_dwb_parameters, chr(10))
               v_cod_portador_fim           = entry(14, dwb_rpt_param.cod_dwb_parameters, chr(10))
               v_cod_portador_ini           = entry(15, dwb_rpt_param.cod_dwb_parameters, chr(10))
               v_cod_ser_docto_fim          = entry(16, dwb_rpt_param.cod_dwb_parameters, chr(10))
               v_cod_ser_docto_ini          = entry(17, dwb_rpt_param.cod_dwb_parameters, chr(10))
               v_cod_tit_acr_fim            = entry(18, dwb_rpt_param.cod_dwb_parameters, chr(10))
               v_cod_tit_acr_ini            = entry(19, dwb_rpt_param.cod_dwb_parameters, chr(10))
               v_dat_emis_final             = date(entry(20, dwb_rpt_param.cod_dwb_parameters, chr(10)))
               v_dat_emis_inic              = date(entry(21, dwb_rpt_param.cod_dwb_parameters, chr(10)))
               v_dat_vencto_final           = date(entry(22, dwb_rpt_param.cod_dwb_parameters, chr(10)))
               v_dat_vencto_inicial         = date(entry(23, dwb_rpt_param.cod_dwb_parameters, chr(10)))
               v_cod_refer_ini              = entry(24, dwb_rpt_param.cod_dwb_parameters, chr(10))
               v_cod_refer_fim              = entry(25, dwb_rpt_param.cod_dwb_parameters, chr(10))
               v_val_sdo_inic               = decimal( entry(26, dwb_rpt_param.cod_dwb_parameters, chr(10)) )
               v_val_sdo_fim                = decimal( entry(27, dwb_rpt_param.cod_dwb_parameters, chr(10)) )
               v_cod_estab_ini              = entry(28, dwb_rpt_param.cod_dwb_parameters, chr(10))
               v_cod_estab_fim              = entry(29, dwb_rpt_param.cod_dwb_parameters, chr(10))
               v_ind_obs                    = entry(30, dwb_rpt_param.cod_dwb_parameters, chr(10))
               rs_imforma_cart_bcia         = entry(31, dwb_rpt_param.cod_dwb_parameters, chr(10))
               v_cod_cart_bcia              = entry(32, dwb_rpt_param.cod_dwb_parameters, chr(10))
               v_ind_tip_cart_bcia          = entry(33, dwb_rpt_param.cod_dwb_parameters, chr(10))
               v_ind_classif_destinac       = entry(34, dwb_rpt_param.cod_dwb_parameters, chr(10)).

        /* ---Listar Consistància de T°tulos N∆o Destinados---*/
        if v_log_funcao_tit_nao_dest = yes then do:
           if  num-entries( dwb_rpt_param.cod_dwb_parameters , chr(10) ) >= 35  then
               assign v_log_tit_nao_destndo = (entry(35, dwb_rpt_param.cod_dwb_parameters, chr(10)) = "yes" /*l_yes*/ ).
        end.

        if  string(v_dat_destinac) = "" or v_dat_destinac = ?
        then do:
            assign v_dat_destinac = today.
        end /* if */. 

        if  num-entries( dwb_rpt_param.cod_dwb_parameters , chr(10) ) >= 36  then
            assign v_log_cobr_acr_pix = (entry(36, dwb_rpt_param.cod_dwb_parameters, chr(10)) = "yes" /*l_yes*/ ).        

    end.
    else do:
        assign v_cod_destinac_cobr          = ""
               v_dat_destinac               = today
               v_ind_tip_destinac           = "Destinaá∆o" /*l_destinacao*/ 
               v_log_destinac_manual        = no
               v_log_habilit_redestina_cobr = no
               v_cdn_cliente_fim            = 999999999
               v_cdn_cliente_ini            = 0
               v_cod_cart_bcia_fim          = "ZZZ":U
               v_cod_cart_bcia_inicial      = "":U
               v_cod_espec_docto_fim        = "ZZZ":U
               v_cod_espec_docto_ini        = "":U
               v_cod_parcela_fim            = "ZZ":U
               v_cod_parcela_ini            = "":U
               v_cod_portador_fim           = "ZZZZZ":U
               v_cod_portador_ini           = "":U
               v_cod_ser_docto_fim          = 'ZZZZZ'
               v_cod_ser_docto_ini          = "":U
               v_cod_tit_acr_fim            = 'ZZZZZZZZZZZZZZZZ'
               v_cod_tit_acr_ini            = "":U
               v_dat_emis_final             = 12/31/9999
               v_dat_emis_inic              = &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF
               v_dat_vencto_final           = 12/31/9999
               v_dat_vencto_inicial         = &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF
               v_cod_refer_ini              = "":U
               v_cod_refer_fim              = "ZZZZZZZZZZ":U
               v_val_sdo_inic               = 0
               v_val_sdo_fim                = 999999999.99
               v_cod_estab_ini              = "":U
               v_cod_estab_fim              = "ZZZZZ":U.

        /* ---Listar Consistància de T°tulos N∆o Destinados---*/
        if v_log_funcao_tit_nao_dest = yes then
           assign v_log_tit_nao_destndo = yes.

        assign v_log_cobr_acr_pix = no.  

    end.
    if  v_log_modul_vendor then do:
        assign v_ind_tip_cart_bcia:{&UI_LIST_ITEM_PAIRS} = getLstItTrans(yes, getLstItUndoTrans(yes, v_ind_tip_cart_bcia:{&UI_LIST_ITEM_PAIRS}) + ',' + "Vendor" /*l_vendor*/, "ACR").
    end.
    enable v_cod_destinac_cobr
           v_dat_destinac
           v_ind_tip_destinac
           v_log_destinac_manual
           v_log_habilit_redestina_cobr
           v_ind_obs
           rs_imforma_cart_bcia
           v_cod_cart_bcia
           v_ind_tip_cart_bcia
           v_ind_classif_destinac
           with frame f_rpt_41_tit_acr_destinac.
    display v_cod_destinac_cobr
            v_dat_destinac
            v_ind_tip_destinac
            v_log_destinac_manual
            v_log_habilit_redestina_cobr
            v_ind_obs
            rs_imforma_cart_bcia
            v_cod_cart_bcia
            v_ind_tip_cart_bcia
            v_ind_classif_destinac
            with frame f_rpt_41_tit_acr_destinac.

    /* ---Listar Consistància de T°tulos N∆o Destinados---*/
    if v_log_funcao_tit_nao_dest = yes then
       display v_log_tit_nao_destndo
               with frame f_rpt_41_tit_acr_destinac.

    if v_ind_classif_destinac = "" /*l_*/  then
       assign input frame f_rpt_41_tit_acr_destinac v_ind_classif_destinac.

    if  v_cod_pais_empres_usuar = "BRA" /*l_bra*/ 
    then do:   
        &if defined(BF_FIN_PIX_3_FLEXIBILIZA) &then
        display v_log_cobr_acr_pix
                with frame f_rpt_41_tit_acr_destinac.
        &endif
    end /* if */.
END PROCEDURE. /* pi_ix_p10_rpt_tit_acr_destinac */
/*****************************************************************************
** Procedure Interna.....: pi_verifica_destinac_tit_vencid
** Descricao.............: pi_verifica_destinac_tit_vencid
** Criado por............: bre18490
** Criado em.............: 22/12/2000 09:22:55
** Alterado por..........: bre18490
** Alterado em...........: 22/12/2000 09:27:55
*****************************************************************************/
PROCEDURE pi_verifica_destinac_tit_vencid:

    &if defined(bf_fin_destina_titulo_vencido) &then
        assign v_log_destinac_tit_vencid = yes.
    &else
        find histor_exec_especial no-lock
            where histor_exec_especial.cod_modul_dtsul = "UFN" /*l_ufn*/ 
              and histor_exec_especial.cod_prog_dtsul  = "spp_destina_titulo_vencido" /*l_destina_titulo_vencido*/  no-error.
        if  avail histor_exec_especial then
            v_log_destinac_tit_vencid = yes.    
    &endif
END PROCEDURE. /* pi_verifica_destinac_tit_vencid */
/*****************************************************************************
** Procedure Interna.....: pi_retornar_dia_util
** Descricao.............: pi_retornar_dia_util
** Criado por............: rafael
** Criado em.............: 09/12/1996 11:48:46
** Alterado por..........: fut1279
** Alterado em...........: 01/09/2006 08:32:55
*****************************************************************************/
PROCEDURE pi_retornar_dia_util:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_estab
        as character
        format "x(5)"
        no-undo.
    def Input param p_ind_tip_calend
        as character
        format "X(08)"
        no-undo.
    def Input param p_num_dias
        as integer
        format ">>>>,>>9"
        no-undo.
    def Input param p_dat_base
        as date
        format "99/99/9999"
        no-undo.
    def output param p_dat_return
        as date
        format "99/99/9999"
        no-undo.
    def output param p_cod_return
        as character
        format "x(40)"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_log_fer
        as logical
        format "Sim/N∆o"
        initial no
        no-undo.
    def var v_num_seq
        as integer
        format ">>>,>>9":U
        label "SeqÅància"
        column-label "Seq"
        no-undo.


    /************************** Variable Definition End *************************/

    assign p_cod_return = "OK" /*l_ok*/ .

    find estabelecimento
        where estabelecimento.cod_estab = p_cod_estab no-lock no-error.
    /* case_block: */
    case p_ind_tip_calend:
        when "Respons†vel Financeiro" /*l_financeiro*/ then
            find calend_glob
                where calend_glob.cod_calend = estabelecimento.cod_calend_financ
                no-lock no-error.
        when "Materiais" /*l_materiais*/ then
            find calend_glob
                where calend_glob.cod_calend = estabelecimento.cod_calend_mater
                no-lock no-error.
        when "R.H." /*l_rh*/ then
            find calend_glob
                where calend_glob.cod_calend = estabelecimento.cod_calend_rh
                no-lock no-error.
        when "Manufatura" /*l_manufatura*/ then
            find calend_glob
                where calend_glob.cod_calend = estabelecimento.cod_calend_manuf
                no-lock no-error.
        when "Distribuiá∆o" /*l_distribuicao*/ then
            find calend_glob
                where calend_glob.cod_calend = estabelecimento.cod_calend_distrib
                no-lock no-error.
    end /* case case_block */.
    if  not avail calend_glob
    then do:
        assign p_cod_return = "3896".
        return.
    end /* if */.

    assign p_dat_return = p_dat_base.

    if  p_num_dias = 0
    then do:
        acha_dia_util:
        repeat:
            find dia_calend_glob
                where dia_calend_glob.cod_calend = calend_glob.cod_calend
                and   dia_calend_glob.dat_calend = p_dat_return
                no-lock no-error.
            if  not avail dia_calend_glob
            then do:
                assign p_cod_return = "3897" + "," + string(p_dat_return) + "," + calend_glob.cod_calend.
                return.
            end /* if */.

            if  dia_calend_glob.log_dia_util = yes then do:
                assign v_log_fer = no.
                for each fer_nac no-lock
                    where fer_nac.cod_pais     = v_cod_pais_fornec_clien
                      and fer_nac.dat_fer_nac  = p_dat_return:
                      assign v_log_fer = yes.
                end.
                if not v_log_fer then
                    leave acha_dia_util.
                else assign p_dat_return = p_dat_return + 1.
            end.

            else do:
                assign p_dat_return = p_dat_return + 1.
            end /* else */.
        end /* repeat acha_dia_util */.
    end /* if */.
    else do:
        dias_block:
        do v_num_seq = 1 to p_num_dias:
            assign p_dat_return = p_dat_return + 1.
            acha_dia_util:
            repeat:
                find dia_calend_glob
                    where dia_calend_glob.cod_calend = calend_glob.cod_calend
                    and   dia_calend_glob.dat_calend = p_dat_return
                    no-lock no-error.
                if  not avail dia_calend_glob
                then do:
                    assign p_cod_return = "3897" + "," + string(p_dat_return) + "," + calend_glob.cod_calend.
                    return.
                end /* if */.

                if  dia_calend_glob.log_dia_util = yes then do:
                    assign v_log_fer = no.
                    for each fer_nac no-lock
                        where fer_nac.cod_pais     = v_cod_pais_fornec_clien
                          and fer_nac.dat_fer_nac  = p_dat_return:
                          assign v_log_fer = yes.
                    end.
                    if not v_log_fer then
                        leave acha_dia_util.
                    else assign p_dat_return = p_dat_return + 1.
                end.

                else do:
                    assign p_dat_return = p_dat_return + 1.
                end /* else */.
            end /* repeat acha_dia_util */.
        end /* do dias_block */.
    end /* else */.

END PROCEDURE. /* pi_retornar_dia_util */
/*****************************************************************************
** Procedure Interna.....: pi_vrf_nom_ender_cobr_fisic
** Descricao.............: pi_vrf_nom_ender_cobr_fisic
** Criado por............: its35892_3
** Criado em.............: 21/11/2006 13:55:23
** Alterado por..........: corp45598
** Alterado em...........: 21/05/2013 16:53:22
*****************************************************************************/
PROCEDURE pi_vrf_nom_ender_cobr_fisic:

    /* ## A vari†vel v_cod_cep_dest_cobr ser† usada pelo programa Destinaá∆o de Cobranáa,
         sem o formato do cep. ##*/
    &if '{&emsfin_version}' >= '5.07' &then
        assign v_nom_endereco      = pessoa_fisic.nom_ender_cobr
               v_nom_bairro        = pessoa_fisic.nom_bairro_cobr
               v_cod_cep           = string(pessoa_fisic.cod_cep_cobr, pais.cod_format_cep)
               v_cod_cep_dest_cobr = pessoa_fisic.cod_cep_cobr
               v_nom_cidade        = pessoa_fisic.nom_cidad_cobr
               v_cod_unid_federac  = pessoa_fisic.cod_unid_federac_cobr.

        &if defined(BF_FIN_4LINHAS_END) &then
            cont_block:
            REPEAT v_num_cont_entry = 1 TO NUM-ENTRIES(pessoa_fisic.nom_ender_cobr_text, chr(10)):
                if  v_num_cont_entry = 1 then assign v_nom_ender_lin_1 = GetEntryField(1, pessoa_fisic.nom_ender_cobr_text, chr(10)).
                if  v_num_cont_entry = 2 then assign v_nom_ender_lin_2 = GetEntryField(2, pessoa_fisic.nom_ender_cobr_text, chr(10)).
                if  v_num_cont_entry = 3 then assign v_nom_ender_lin_3 = GetEntryField(3, pessoa_fisic.nom_ender_cobr_text, chr(10)).
                if  v_num_cont_entry = 4 then assign v_nom_ender_lin_4 = GetEntryField(4, pessoa_fisic.nom_ender_cobr_text, chr(10)).
                if  v_num_cont_entry = 4 then
                    leave cont_block.
            end.
        &endif
    &else
       if avail tab_livre_emsuni then do:
          assign v_nom_endereco      = GetEntryField(4, tab_livre_emsuni.cod_livre_1, chr(10))
                 v_nom_bairro        = GetEntryField(7, tab_livre_emsuni.cod_livre_1, chr(10))
                 v_cod_cep           = GetEntryField(8, tab_livre_emsuni.cod_livre_1, chr(10)) + "," + GetEntryField(2, tab_livre_emsuni.cod_livre_1, chr(10))
                 v_cod_cep_dest_cobr = GetEntryField(8, tab_livre_emsuni.cod_livre_1, chr(10))
                 v_nom_cidade        = GetEntryField(9, tab_livre_emsuni.cod_livre_1, chr(10))
                 v_cod_unid_federac  = GetEntryField(3, tab_livre_emsuni.cod_livre_1, chr(10)).

          &if defined(BF_FIN_4LINHAS_END) &then
              cont_block:
              REPEAT v_num_cont_entry = 1 TO NUM-ENTRIES(GetEntryField(5, tab_livre_emsuni.cod_livre_1, chr(10)), '&'):
                  if  v_num_cont_entry = 1 then assign v_nom_ender_lin_1 = GetEntryField(1, GetEntryField(5, tab_livre_emsuni.cod_livre_1, chr(10)), '&').
                  if  v_num_cont_entry = 2 then assign v_nom_ender_lin_2 = GetEntryField(2, GetEntryField(5, tab_livre_emsuni.cod_livre_1, chr(10)), '&').
                  if  v_num_cont_entry = 3 then assign v_nom_ender_lin_3 = GetEntryField(3, GetEntryField(5, tab_livre_emsuni.cod_livre_1, chr(10)), '&').
                  if  v_num_cont_entry = 4 then assign v_nom_ender_lin_4 = GetEntryField(4, GetEntryField(5, tab_livre_emsuni.cod_livre_1, chr(10)), '&').
                  if  v_num_cont_entry = 4 then
                      leave cont_block.
              end.
          &endif
       end.
       else do:
          /* Os programas que chamam essa procedure interna j† fazem o find na tab_libre_emsuni e apenas executam caso ela exista. 
             A l¢gica foi inserida para que caso seja feita uma chamada a essa pi e n∆o realizado o find antes da execuá∆o         */   
          find first tab_livre_emsuni no-lock
             where tab_livre_emsuni.cod_modul_dtsul      = "utb" /*l_utb*/ 
               and tab_livre_emsuni.cod_tab_dic_dtsul    = 'pessoa_fisic':U
               and tab_livre_emsuni.cod_compon_1_idx_tab = STRING(0)
               and tab_livre_emsuni.cod_compon_2_idx_tab = STRING(pessoa_fisic.num_pessoa_fisic) no-error.
          if not avail tab_livre_emsuni then do:
              find first tab_livre_emsuni no-lock
                   where tab_livre_emsuni.cod_modul_dtsul      = "utb" /*l_utb*/ 
                     and tab_livre_emsuni.cod_tab_dic_dtsul    = 'pessoa_fisic':U
                     and tab_livre_emsuni.cod_compon_2_idx_tab = STRING(pessoa_fisic.num_pessoa_fisic) no-error.                                                
          end.                        
          if avail tab_livre_emsuni then do:
             assign v_nom_endereco      = GetEntryField(4, tab_livre_emsuni.cod_livre_1, chr(10))
                    v_nom_bairro        = GetEntryField(7, tab_livre_emsuni.cod_livre_1, chr(10))
                    v_cod_cep           = GetEntryField(8, tab_livre_emsuni.cod_livre_1, chr(10)) + "," + GetEntryField(2, tab_livre_emsuni.cod_livre_1, chr(10))
                    v_cod_cep_dest_cobr = GetEntryField(8, tab_livre_emsuni.cod_livre_1, chr(10))
                    v_nom_cidade        = GetEntryField(9, tab_livre_emsuni.cod_livre_1, chr(10))
                    v_cod_unid_federac  = GetEntryField(3, tab_livre_emsuni.cod_livre_1, chr(10)).

             &if defined(BF_FIN_4LINHAS_END) &then
                 cont_block:
                 REPEAT v_num_cont_entry = 1 TO NUM-ENTRIES(GetEntryField(5, tab_livre_emsuni.cod_livre_1, chr(10)), '&'):
                     if  v_num_cont_entry = 1 then assign v_nom_ender_lin_1 = GetEntryField(1, GetEntryField(5, tab_livre_emsuni.cod_livre_1, chr(10)), '&').
                     if  v_num_cont_entry = 2 then assign v_nom_ender_lin_2 = GetEntryField(2, GetEntryField(5, tab_livre_emsuni.cod_livre_1, chr(10)), '&').
                     if  v_num_cont_entry = 3 then assign v_nom_ender_lin_3 = GetEntryField(3, GetEntryField(5, tab_livre_emsuni.cod_livre_1, chr(10)), '&').
                     if  v_num_cont_entry = 4 then assign v_nom_ender_lin_4 = GetEntryField(4, GetEntryField(5, tab_livre_emsuni.cod_livre_1, chr(10)), '&').
                     if  v_num_cont_entry = 4 then
                         leave cont_block.
                 end.
             &endif
          end.
       end.
    &endif
END PROCEDURE. /* pi_vrf_nom_ender_cobr_fisic */
/*****************************************************************************
** Procedure Interna.....: pi_vrf_nom_ender_cobr_fisic_1
** Descricao.............: pi_vrf_nom_ender_cobr_fisic_1
** Criado por............: its35892_3
** Criado em.............: 21/11/2006 13:57:13
** Alterado por..........: its35892_3
** Alterado em...........: 11/12/2006 08:39:20
*****************************************************************************/
PROCEDURE pi_vrf_nom_ender_cobr_fisic_1:

    /* ## A vari†vel v_cod_cep_dest_cobr ser† usada pelo programa Destinaá∆o de Cobranáa,
         sem o formato do cep. ##*/
    assign v_nom_endereco      = pessoa_fisic.nom_endereco
           v_nom_bairro        = pessoa_fisic.nom_bairro
           v_cod_cep           = string(pessoa_fisic.cod_cep, pais.cod_format_cep)
           v_cod_cep_dest_cobr = pessoa_fisic.cod_cep
           v_nom_cidade        = pessoa_fisic.nom_cidade
           v_cod_unid_federac  = pessoa_fisic.cod_unid_federac.

    &if defined(BF_FIN_4LINHAS_END) &then
        cont_block:
        REPEAT v_num_cont_entry = 1 TO NUM-ENTRIES(pessoa_fisic.nom_ender_text, chr(10)):
            if  v_num_cont_entry = 1 then assign v_nom_ender_lin_1 = GetEntryField(1, pessoa_fisic.nom_ender_text, chr(10)).
            if  v_num_cont_entry = 2 then assign v_nom_ender_lin_2 = GetEntryField(2, pessoa_fisic.nom_ender_text, chr(10)).
            if  v_num_cont_entry = 3 then assign v_nom_ender_lin_3 = GetEntryField(3, pessoa_fisic.nom_ender_text, chr(10)).
            if  v_num_cont_entry = 4 then assign v_nom_ender_lin_4 = GetEntryField(4, pessoa_fisic.nom_ender_text, chr(10)).
            if  v_num_cont_entry = 4 then
                leave cont_block.
        end.
    &endif

END PROCEDURE. /* pi_vrf_nom_ender_cobr_fisic_1 */
/*****************************************************************************
** Procedure Interna.....: pi_ix_p30_rpt_tit_acr_destinac
** Descricao.............: pi_ix_p30_rpt_tit_acr_destinac
** Criado por............: its35892_3
** Criado em.............: 05/12/2006 10:53:49
** Alterado por..........: fut41675_3
** Alterado em...........: 30/10/2008 13:51:24
*****************************************************************************/
PROCEDURE pi_ix_p30_rpt_tit_acr_destinac:


    /* Begin_Include: ix_p30_rpt_tit_acr_destinac */
    if v_log_funcao_tit_nao_dest = yes then do:
       if v_cod_return = "OK" /*l_ok*/  then do:
       &if defined(BF_FIN_PIX_3_FLEXIBILIZA) &then
          if  v_cod_pais_empres_usuar = "BRA" /*l_bra*/ 
          then do:
          run pi_print_editor ("s_1", v_ind_obs, "     035", "", "     ", "", "     ").
          assign v_des_return_value_editor = return-value.
          put stream s_1 unformatted 
              getStrTrans("Destinaá∆o: ", "ACR") at 23
              destinac_cobr.cod_destinac_cobr at 35 format "x(8)"
              destinac_cobr.des_destinac_cobr at 53 format "x(40)" skip
              getStrTrans("Data Destinaá∆o: ", "ACR") at 27
              v_dat_destinac at 44 format "99/99/9999" skip
              getStrTrans("Tipo Relat¢rio: ", "ACR") at 28
              getStrTrans(v_ind_tip_destinac, "ACR") at 44 format "X(12)" skip
              getStrTrans("Redestinaá∆o: ", "ACR") at 30.
    put stream s_1 unformatted 
              getStrTrans(string(v_log_habilit_redestina_cobr, "Sim/N∆o"), "ACR") at 44 skip
              getStrTrans("Manual: ", "ACR") at 36
              getStrTrans(string(v_log_destinac_manual, "Sim/N∆o"), "ACR") at 44 skip
              getStrTrans("Listar Tit N∆o Dest: ", "ACR") at 23
              getStrTrans(string(v_log_tit_nao_destndo, "Sim/N∆o"), "ACR") at 44 skip
              getStrTrans("Aceita Cobranáa PIX: ", "ACR") at 23
              getStrTrans(string(v_log_cobr_acr_pix, "Sim/N∆o"), "ACR") at 44 skip
              getStrTrans("Observaá∆o: ", "ACR") at 32
              entry(1, v_des_return_value_editor, chr(255)) at 44 format "x(35)"
              skip (1).
    put stream s_1 unformatted 
              getStrTrans("--------------- Faixa Destinaá∆o ---------------", "ACR") at 34
              skip (1)
              getStrTrans("Estabelecimento: ", "ACR") at 35
              v_cod_estab_ini at 52 format "x(5)"
              getStrTrans("atÇ: ", "ACR") at 69
              v_cod_estab_fim at 74 format "x(5)" skip
              getStrTrans("Data Emiss∆o: ", "ACR") at 38
              v_dat_emis_inic at 52 format "99/99/9999"
              getStrTrans("atÇ: ", "ACR") at 69
              v_dat_emis_final at 74 format "99/99/9999" skip.
    put stream s_1 unformatted 
              getStrTrans("Data Vencimento: ", "ACR") at 35
              v_dat_vencto_inicial at 52 format "99/99/9999"
              getStrTrans("atÇ: ", "ACR") at 69
              v_dat_vencto_final at 74 format "99/99/9999" skip
              getStrTrans("Referància: ", "ACR") at 40
              v_cod_refer_ini at 52 format "x(10)"
              getStrTrans("atÇ: ", "ACR") at 69
              v_cod_refer_fim at 74 format "x(10)" skip
              getStrTrans("Portador: ", "ACR") at 42
              v_cod_portador_ini at 52 format "x(5)".
    put stream s_1 unformatted 
              getStrTrans("atÇ: ", "ACR") at 69
              v_cod_portador_fim at 74 format "x(5)" skip
              getStrTrans("Cliente: ", "ACR") at 43
              v_cdn_cliente_ini to 62 format ">>>,>>>,>>9"
              getStrTrans("atÇ: ", "ACR") at 69
              v_cdn_cliente_fim to 84 format ">>>,>>>,>>9" skip
              getStrTrans("Carteira Bcia: ", "ACR") at 37
              v_cod_cart_bcia_inicial at 52 format "x(3)"
              getStrTrans("atÇ: ", "ACR") at 69
              v_cod_cart_bcia_fim at 74 format "x(3)" skip.
    put stream s_1 unformatted 
              getStrTrans("EspÇcie: ", "ACR") at 43
              v_cod_espec_docto_ini at 52 format "x(3)"
              getStrTrans("atÇ: ", "ACR") at 69
              v_cod_espec_docto_fim at 74 format "x(3)" skip
              getStrTrans("SÇrie: ", "ACR") at 45
              v_cod_ser_docto_ini at 52 format "x(5)"
              getStrTrans("atÇ: ", "ACR") at 69
              v_cod_ser_docto_fim at 74 format "x(5)" skip
              getStrTrans("T°tulo: ", "ACR") at 44
              v_cod_tit_acr_ini at 52 format "x(16)".
    put stream s_1 unformatted 
              getStrTrans("atÇ: ", "ACR") at 69
              v_cod_tit_acr_fim at 74 format "x(16)" skip
              getStrTrans("Parcela: ", "ACR") at 43
              v_cod_parcela_ini at 52 format "x(02)"
              getStrTrans("atÇ: ", "ACR") at 69
              v_cod_parcela_fim at 74 format "x(02)" skip.
          run pi_print_editor ("s_1", v_ind_obs, "at044035", "", "", "", "").
          assign v_des_return_value_editor = return-value.
          end /* if */.
          else do:
          run pi_print_editor ("s_1", v_ind_obs, "     035", "", "     ", "", "     ").
          assign v_des_return_value_editor = return-value.
          put stream s_1 unformatted 
              getStrTrans("Destinaá∆o: ", "ACR") at 23
              destinac_cobr.cod_destinac_cobr at 35 format "x(8)"
              destinac_cobr.des_destinac_cobr at 53 format "x(40)" skip
              getStrTrans("Data Destinaá∆o: ", "ACR") at 27
              v_dat_destinac at 44 format "99/99/9999" skip
              getStrTrans("Tipo Relat¢rio: ", "ACR") at 28
              getStrTrans(v_ind_tip_destinac, "ACR") at 44 format "X(12)" skip
              getStrTrans("Redestinaá∆o: ", "ACR") at 30.
    put stream s_1 unformatted 
              getStrTrans(string(v_log_habilit_redestina_cobr, "Sim/N∆o"), "ACR") at 44 skip
              getStrTrans("Manual: ", "ACR") at 36
              getStrTrans(string(v_log_destinac_manual, "Sim/N∆o"), "ACR") at 44 skip
              getStrTrans("Listar Tit N∆o Dest: ", "ACR") at 23
              getStrTrans(string(v_log_tit_nao_destndo, "Sim/N∆o"), "ACR") at 44 skip
              getStrTrans("Observaá∆o: ", "ACR") at 32
              entry(1, v_des_return_value_editor, chr(255)) at 44 format "x(35)" skip
              getStrTrans("Classificaá∆o: ", "ACR") at 29
              getStrTrans(v_ind_classif_destinac, "ACR") at 44 format "X(100)"
              skip (1).
    put stream s_1 unformatted 
              getStrTrans("--------------- Faixa Destinaá∆o ---------------", "ACR") at 34 skip
              getStrTrans("Estabelecimento: ", "ACR") at 35
              v_cod_estab_ini at 52 format "x(5)"
              getStrTrans("atÇ: ", "ACR") at 69
              v_cod_estab_fim at 74 format "x(5)" skip
              getStrTrans("Data Emiss∆o: ", "ACR") at 38
              v_dat_emis_inic at 52 format "99/99/9999"
              getStrTrans("atÇ: ", "ACR") at 69
              v_dat_emis_final at 74 format "99/99/9999" skip
              getStrTrans("Data Vencimento: ", "ACR") at 35.
    put stream s_1 unformatted 
              v_dat_vencto_inicial at 52 format "99/99/9999"
              getStrTrans("atÇ: ", "ACR") at 69
              v_dat_vencto_final at 74 format "99/99/9999" skip
              getStrTrans("Referància: ", "ACR") at 40
              v_cod_refer_ini at 52 format "x(10)"
              getStrTrans("atÇ: ", "ACR") at 69
              v_cod_refer_fim at 74 format "x(10)" skip
              getStrTrans("Portador: ", "ACR") at 42
              v_cod_portador_ini at 52 format "x(5)"
              getStrTrans("atÇ: ", "ACR") at 69.
    put stream s_1 unformatted 
              v_cod_portador_fim at 74 format "x(5)" skip
              getStrTrans("Cliente: ", "ACR") at 43
              v_cdn_cliente_ini to 62 format ">>>,>>>,>>9"
              getStrTrans("atÇ: ", "ACR") at 69
              v_cdn_cliente_fim to 84 format ">>>,>>>,>>9" skip
              getStrTrans("Carteira Bcia: ", "ACR") at 37
              v_cod_cart_bcia_inicial at 52 format "x(3)"
              getStrTrans("atÇ: ", "ACR") at 69
              v_cod_cart_bcia_fim at 74 format "x(3)" skip
              getStrTrans("EspÇcie: ", "ACR") at 43.
    put stream s_1 unformatted 
              v_cod_espec_docto_ini at 52 format "x(3)"
              getStrTrans("atÇ: ", "ACR") at 69
              v_cod_espec_docto_fim at 74 format "x(3)" skip
              getStrTrans("SÇrie: ", "ACR") at 45
              v_cod_ser_docto_ini at 52 format "x(5)"
              getStrTrans("atÇ: ", "ACR") at 69
              v_cod_ser_docto_fim at 74 format "x(5)" skip
              getStrTrans("T°tulo: ", "ACR") at 44
              v_cod_tit_acr_ini at 52 format "x(16)"
              getStrTrans("atÇ: ", "ACR") at 69.
    put stream s_1 unformatted 
              v_cod_tit_acr_fim at 74 format "x(16)" skip
              getStrTrans("Parcela: ", "ACR") at 43
              v_cod_parcela_ini at 52 format "x(02)"
              getStrTrans("atÇ: ", "ACR") at 69
              v_cod_parcela_fim at 74 format "x(02)" skip.
          run pi_print_editor ("s_1", v_ind_obs, "at044035", "", "", "", "").      
          assign v_des_return_value_editor = return-value.
          end /* else */.
       &else
          run pi_print_editor ("s_1", v_ind_obs, "     035", "", "     ", "", "     ").
          assign v_des_return_value_editor = return-value.
          put stream s_1 unformatted 
              getStrTrans("Destinaá∆o: ", "ACR") at 23
              destinac_cobr.cod_destinac_cobr at 35 format "x(8)"
              destinac_cobr.des_destinac_cobr at 53 format "x(40)" skip
              getStrTrans("Data Destinaá∆o: ", "ACR") at 27
              v_dat_destinac at 44 format "99/99/9999" skip
              getStrTrans("Tipo Relat¢rio: ", "ACR") at 28
              getStrTrans(v_ind_tip_destinac, "ACR") at 44 format "X(12)" skip
              getStrTrans("Redestinaá∆o: ", "ACR") at 30.
    put stream s_1 unformatted 
              getStrTrans(string(v_log_habilit_redestina_cobr, "Sim/N∆o"), "ACR") at 44 skip
              getStrTrans("Manual: ", "ACR") at 36
              getStrTrans(string(v_log_destinac_manual, "Sim/N∆o"), "ACR") at 44 skip
              getStrTrans("Listar Tit N∆o Dest: ", "ACR") at 23
              getStrTrans(string(v_log_tit_nao_destndo, "Sim/N∆o"), "ACR") at 44 skip
              getStrTrans("Observaá∆o: ", "ACR") at 32
              entry(1, v_des_return_value_editor, chr(255)) at 44 format "x(35)"
              skip (1)
              getStrTrans("--------------- Faixa Destinaá∆o ---------------", "ACR") at 34
              skip (1).
    put stream s_1 unformatted 
              getStrTrans("Estabelecimento: ", "ACR") at 35
              v_cod_estab_ini at 52 format "x(5)"
              getStrTrans("atÇ: ", "ACR") at 69
              v_cod_estab_fim at 74 format "x(5)" skip
              getStrTrans("Data Emiss∆o: ", "ACR") at 38
              v_dat_emis_inic at 52 format "99/99/9999"
              getStrTrans("atÇ: ", "ACR") at 69
              v_dat_emis_final at 74 format "99/99/9999" skip
              getStrTrans("Data Vencimento: ", "ACR") at 35
              v_dat_vencto_inicial at 52 format "99/99/9999".
    put stream s_1 unformatted 
              getStrTrans("atÇ: ", "ACR") at 69
              v_dat_vencto_final at 74 format "99/99/9999" skip
              getStrTrans("Referància: ", "ACR") at 40
              v_cod_refer_ini at 52 format "x(10)"
              getStrTrans("atÇ: ", "ACR") at 69
              v_cod_refer_fim at 74 format "x(10)" skip
              getStrTrans("Portador: ", "ACR") at 42
              v_cod_portador_ini at 52 format "x(5)"
              getStrTrans("atÇ: ", "ACR") at 69
              v_cod_portador_fim at 74 format "x(5)" skip.
    put stream s_1 unformatted 
              getStrTrans("Cliente: ", "ACR") at 43
              v_cdn_cliente_ini to 62 format ">>>,>>>,>>9"
              getStrTrans("atÇ: ", "ACR") at 69
              v_cdn_cliente_fim to 84 format ">>>,>>>,>>9" skip
              getStrTrans("Carteira Bcia: ", "ACR") at 37
              v_cod_cart_bcia_inicial at 52 format "x(3)"
              getStrTrans("atÇ: ", "ACR") at 69
              v_cod_cart_bcia_fim at 74 format "x(3)" skip
              getStrTrans("EspÇcie: ", "ACR") at 43
              v_cod_espec_docto_ini at 52 format "x(3)".
    put stream s_1 unformatted 
              getStrTrans("atÇ: ", "ACR") at 69
              v_cod_espec_docto_fim at 74 format "x(3)" skip
              getStrTrans("SÇrie: ", "ACR") at 45
              v_cod_ser_docto_ini at 52 format "x(5)"
              getStrTrans("atÇ: ", "ACR") at 69
              v_cod_ser_docto_fim at 74 format "x(5)" skip
              getStrTrans("T°tulo: ", "ACR") at 44
              v_cod_tit_acr_ini at 52 format "x(16)"
              getStrTrans("atÇ: ", "ACR") at 69
              v_cod_tit_acr_fim at 74 format "x(16)" skip.
    put stream s_1 unformatted 
              getStrTrans("Parcela: ", "ACR") at 43
              v_cod_parcela_ini at 52 format "x(02)"
              getStrTrans("atÇ: ", "ACR") at 69
              v_cod_parcela_fim at 74 format "x(02)" skip.
          run pi_print_editor ("s_1", v_ind_obs, "at044035", "", "", "", "").
          assign v_des_return_value_editor = return-value.
       &endif
       end.
    end.
    else do:
       if v_cod_return = "OK" /*l_ok*/  then do:
       &if defined(BF_FIN_PIX_3_FLEXIBILIZA) &then
          if  v_cod_pais_empres_usuar = "BRA" /*l_bra*/ 
          then do:
          run pi_print_editor ("s_1", v_ind_obs, "     035", "", "     ", "", "     ").
          assign v_des_return_value_editor = return-value.
          put stream s_1 unformatted 
              getStrTrans("Destinaá∆o: ", "ACR") at 23
              destinac_cobr.cod_destinac_cobr at 35 format "x(8)"
              destinac_cobr.des_destinac_cobr at 53 format "x(40)" skip
              getStrTrans("Data Destinaá∆o: ", "ACR") at 27
              v_dat_destinac at 44 format "99/99/9999" skip
              getStrTrans("Tipo Relat¢rio: ", "ACR") at 28
              getStrTrans(v_ind_tip_destinac, "ACR") at 44 format "X(12)" skip
              getStrTrans("Redestinaá∆o: ", "ACR") at 30.
    put stream s_1 unformatted 
              getStrTrans(string(v_log_habilit_redestina_cobr, "Sim/N∆o"), "ACR") at 44 skip
              getStrTrans("Manual: ", "ACR") at 36
              getStrTrans(string(v_log_destinac_manual, "Sim/N∆o"), "ACR") at 44 skip
              getStrTrans("Aceita Cobranáa PIX: ", "ACR") at 23
              getStrTrans(string(v_log_cobr_acr_pix, "Sim/N∆o"), "ACR") at 44 skip
              getStrTrans("Observaá∆o: ", "ACR") at 32
              entry(1, v_des_return_value_editor, chr(255)) at 44 format "x(35)"
              skip (1)
              getStrTrans("--------------- Faixa Destinaá∆o ---------------", "ACR") at 34
              skip (1).
    put stream s_1 unformatted 
              getStrTrans("Estabelecimento: ", "ACR") at 35
              v_cod_estab_ini at 52 format "x(5)"
              getStrTrans("atÇ: ", "ACR") at 69
              v_cod_estab_fim at 74 format "x(5)" skip
              getStrTrans("Data Emiss∆o: ", "ACR") at 38
              v_dat_emis_inic at 52 format "99/99/9999"
              getStrTrans("atÇ: ", "ACR") at 69
              v_dat_emis_final at 74 format "99/99/9999" skip
              getStrTrans("Data Vencimento: ", "ACR") at 35
              v_dat_vencto_inicial at 52 format "99/99/9999".
    put stream s_1 unformatted 
              getStrTrans("atÇ: ", "ACR") at 69
              v_dat_vencto_final at 74 format "99/99/9999" skip
              getStrTrans("Referància: ", "ACR") at 40
              v_cod_refer_ini at 52 format "x(10)"
              getStrTrans("atÇ: ", "ACR") at 69
              v_cod_refer_fim at 74 format "x(10)" skip
              getStrTrans("Portador: ", "ACR") at 42
              v_cod_portador_ini at 52 format "x(5)"
              getStrTrans("atÇ: ", "ACR") at 69
              v_cod_portador_fim at 74 format "x(5)" skip.
    put stream s_1 unformatted 
              getStrTrans("Cliente: ", "ACR") at 43
              v_cdn_cliente_ini to 62 format ">>>,>>>,>>9"
              getStrTrans("atÇ: ", "ACR") at 69
              v_cdn_cliente_fim to 84 format ">>>,>>>,>>9" skip
              getStrTrans("Carteira Bcia: ", "ACR") at 37
              v_cod_cart_bcia_inicial at 52 format "x(3)"
              getStrTrans("atÇ: ", "ACR") at 69
              v_cod_cart_bcia_fim at 74 format "x(3)" skip
              getStrTrans("EspÇcie: ", "ACR") at 43
              v_cod_espec_docto_ini at 52 format "x(3)".
    put stream s_1 unformatted 
              getStrTrans("atÇ: ", "ACR") at 69
              v_cod_espec_docto_fim at 74 format "x(3)" skip
              getStrTrans("SÇrie: ", "ACR") at 45
              v_cod_ser_docto_ini at 52 format "x(5)"
              getStrTrans("atÇ: ", "ACR") at 69
              v_cod_ser_docto_fim at 74 format "x(5)" skip
              getStrTrans("T°tulo: ", "ACR") at 44
              v_cod_tit_acr_ini at 52 format "x(16)"
              getStrTrans("atÇ: ", "ACR") at 69
              v_cod_tit_acr_fim at 74 format "x(16)" skip.
    put stream s_1 unformatted 
              getStrTrans("Parcela: ", "ACR") at 43
              v_cod_parcela_ini at 52 format "x(02)"
              getStrTrans("atÇ: ", "ACR") at 69
              v_cod_parcela_fim at 74 format "x(02)" skip.
          run pi_print_editor ("s_1", v_ind_obs, "at044035", "", "", "", "").
          assign v_des_return_value_editor = return-value.
          end /* if */.
          else do:
          run pi_print_editor ("s_1", v_ind_obs, "     035", "", "     ", "", "     ").
          assign v_des_return_value_editor = return-value.
          put stream s_1 unformatted 
              getStrTrans("Destinaá∆o: ", "ACR") at 23
              destinac_cobr.cod_destinac_cobr at 35 format "x(8)"
              destinac_cobr.des_destinac_cobr at 53 format "x(40)" skip
              getStrTrans("Data Destinaá∆o: ", "ACR") at 27
              v_dat_destinac at 44 format "99/99/9999" skip
              getStrTrans("Tipo Relat¢rio: ", "ACR") at 28
              getStrTrans(v_ind_tip_destinac, "ACR") at 44 format "X(12)" skip
              getStrTrans("Redestinaá∆o: ", "ACR") at 30.
    put stream s_1 unformatted 
              getStrTrans(string(v_log_habilit_redestina_cobr, "Sim/N∆o"), "ACR") at 44 skip
              getStrTrans("Manual: ", "ACR") at 36
              getStrTrans(string(v_log_destinac_manual, "Sim/N∆o"), "ACR") at 44 skip
              getStrTrans("Observaá∆o: ", "ACR") at 32
              entry(1, v_des_return_value_editor, chr(255)) at 44 format "x(35)" skip
              getStrTrans("Classificaá∆o: ", "ACR") at 29
              getStrTrans(v_ind_classif_destinac, "ACR") at 44 format "X(100)"
              skip (1)
              getStrTrans("--------------- Faixa Destinaá∆o ---------------", "ACR") at 34 skip
              getStrTrans("Estabelecimento: ", "ACR") at 35.
    put stream s_1 unformatted 
              v_cod_estab_ini at 52 format "x(5)"
              getStrTrans("atÇ: ", "ACR") at 69
              v_cod_estab_fim at 74 format "x(5)" skip
              getStrTrans("Data Emiss∆o: ", "ACR") at 38
              v_dat_emis_inic at 52 format "99/99/9999"
              getStrTrans("atÇ: ", "ACR") at 69
              v_dat_emis_final at 74 format "99/99/9999" skip
              getStrTrans("Data Vencimento: ", "ACR") at 35
              v_dat_vencto_inicial at 52 format "99/99/9999"
              getStrTrans("atÇ: ", "ACR") at 69.
    put stream s_1 unformatted 
              v_dat_vencto_final at 74 format "99/99/9999" skip
              getStrTrans("Referància: ", "ACR") at 40
              v_cod_refer_ini at 52 format "x(10)"
              getStrTrans("atÇ: ", "ACR") at 69
              v_cod_refer_fim at 74 format "x(10)" skip
              getStrTrans("Portador: ", "ACR") at 42
              v_cod_portador_ini at 52 format "x(5)"
              getStrTrans("atÇ: ", "ACR") at 69
              v_cod_portador_fim at 74 format "x(5)" skip
              getStrTrans("Cliente: ", "ACR") at 43.
    put stream s_1 unformatted 
              v_cdn_cliente_ini to 62 format ">>>,>>>,>>9"
              getStrTrans("atÇ: ", "ACR") at 69
              v_cdn_cliente_fim to 84 format ">>>,>>>,>>9" skip
              getStrTrans("Carteira Bcia: ", "ACR") at 37
              v_cod_cart_bcia_inicial at 52 format "x(3)"
              getStrTrans("atÇ: ", "ACR") at 69
              v_cod_cart_bcia_fim at 74 format "x(3)" skip
              getStrTrans("EspÇcie: ", "ACR") at 43
              v_cod_espec_docto_ini at 52 format "x(3)"
              getStrTrans("atÇ: ", "ACR") at 69.
    put stream s_1 unformatted 
              v_cod_espec_docto_fim at 74 format "x(3)" skip
              getStrTrans("SÇrie: ", "ACR") at 45
              v_cod_ser_docto_ini at 52 format "x(5)"
              getStrTrans("atÇ: ", "ACR") at 69
              v_cod_ser_docto_fim at 74 format "x(5)" skip
              getStrTrans("T°tulo: ", "ACR") at 44
              v_cod_tit_acr_ini at 52 format "x(16)"
              getStrTrans("atÇ: ", "ACR") at 69
              v_cod_tit_acr_fim at 74 format "x(16)" skip
              getStrTrans("Parcela: ", "ACR") at 43.
    put stream s_1 unformatted 
              v_cod_parcela_ini at 52 format "x(02)"
              getStrTrans("atÇ: ", "ACR") at 69
              v_cod_parcela_fim at 74 format "x(02)" skip.
          run pi_print_editor ("s_1", v_ind_obs, "at044035", "", "", "", "").      
          assign v_des_return_value_editor = return-value.
          end /* else */.
       &else
          run pi_print_editor ("s_1", v_ind_obs, "     035", "", "     ", "", "     ").
          assign v_des_return_value_editor = return-value.
          put stream s_1 unformatted 
              getStrTrans("Destinaá∆o: ", "ACR") at 23
              destinac_cobr.cod_destinac_cobr at 35 format "x(8)"
              destinac_cobr.des_destinac_cobr at 53 format "x(40)" skip
              getStrTrans("Data Destinaá∆o: ", "ACR") at 27
              v_dat_destinac at 44 format "99/99/9999" skip
              getStrTrans("Tipo Relat¢rio: ", "ACR") at 28
              getStrTrans(v_ind_tip_destinac, "ACR") at 44 format "X(12)" skip
              getStrTrans("Redestinaá∆o: ", "ACR") at 30.
    put stream s_1 unformatted 
              getStrTrans(string(v_log_habilit_redestina_cobr, "Sim/N∆o"), "ACR") at 44 skip
              getStrTrans("Manual: ", "ACR") at 36
              getStrTrans(string(v_log_destinac_manual, "Sim/N∆o"), "ACR") at 44 skip
              getStrTrans("Observaá∆o: ", "ACR") at 32
              entry(1, v_des_return_value_editor, chr(255)) at 44 format "x(35)"
              skip (1)
              getStrTrans("--------------- Faixa Destinaá∆o ---------------", "ACR") at 34
              skip (1)
              getStrTrans("Estabelecimento: ", "ACR") at 35
              v_cod_estab_ini at 52 format "x(5)".
    put stream s_1 unformatted 
              getStrTrans("atÇ: ", "ACR") at 69
              v_cod_estab_fim at 74 format "x(5)" skip
              getStrTrans("Data Emiss∆o: ", "ACR") at 38
              v_dat_emis_inic at 52 format "99/99/9999"
              getStrTrans("atÇ: ", "ACR") at 69
              v_dat_emis_final at 74 format "99/99/9999" skip
              getStrTrans("Data Vencimento: ", "ACR") at 35
              v_dat_vencto_inicial at 52 format "99/99/9999"
              getStrTrans("atÇ: ", "ACR") at 69
              v_dat_vencto_final at 74 format "99/99/9999" skip.
    put stream s_1 unformatted 
              getStrTrans("Referància: ", "ACR") at 40
              v_cod_refer_ini at 52 format "x(10)"
              getStrTrans("atÇ: ", "ACR") at 69
              v_cod_refer_fim at 74 format "x(10)" skip
              getStrTrans("Portador: ", "ACR") at 42
              v_cod_portador_ini at 52 format "x(5)"
              getStrTrans("atÇ: ", "ACR") at 69
              v_cod_portador_fim at 74 format "x(5)" skip
              getStrTrans("Cliente: ", "ACR") at 43
              v_cdn_cliente_ini to 62 format ">>>,>>>,>>9".
    put stream s_1 unformatted 
              getStrTrans("atÇ: ", "ACR") at 69
              v_cdn_cliente_fim to 84 format ">>>,>>>,>>9" skip
              getStrTrans("Carteira Bcia: ", "ACR") at 37
              v_cod_cart_bcia_inicial at 52 format "x(3)"
              getStrTrans("atÇ: ", "ACR") at 69
              v_cod_cart_bcia_fim at 74 format "x(3)" skip
              getStrTrans("EspÇcie: ", "ACR") at 43
              v_cod_espec_docto_ini at 52 format "x(3)"
              getStrTrans("atÇ: ", "ACR") at 69
              v_cod_espec_docto_fim at 74 format "x(3)" skip.
    put stream s_1 unformatted 
              getStrTrans("SÇrie: ", "ACR") at 45
              v_cod_ser_docto_ini at 52 format "x(5)"
              getStrTrans("atÇ: ", "ACR") at 69
              v_cod_ser_docto_fim at 74 format "x(5)" skip
              getStrTrans("T°tulo: ", "ACR") at 44
              v_cod_tit_acr_ini at 52 format "x(16)"
              getStrTrans("atÇ: ", "ACR") at 69
              v_cod_tit_acr_fim at 74 format "x(16)" skip
              getStrTrans("Parcela: ", "ACR") at 43
              v_cod_parcela_ini at 52 format "x(02)".
    put stream s_1 unformatted 
              getStrTrans("atÇ: ", "ACR") at 69
              v_cod_parcela_fim at 74 format "x(02)" skip.
          run pi_print_editor ("s_1", v_ind_obs, "at044035", "", "", "", "").
          assign v_des_return_value_editor = return-value.
       &endif
       end.
    end.
    /* End_Include: ix_p30_rpt_tit_acr_destinac */

END PROCEDURE. /* pi_ix_p30_rpt_tit_acr_destinac */
/*****************************************************************************
** Procedure Interna.....: pi_ix_p15_rpt_tit_acr_destinac
** Descricao.............: pi_ix_p15_rpt_tit_acr_destinac
** Criado por............: its0123
** Criado em.............: 13/03/2007 09:27:29
** Alterado por..........: fut12235
** Alterado em...........: 02/11/2021 11:08:09
*****************************************************************************/
PROCEDURE pi_ix_p15_rpt_tit_acr_destinac:

    assign input frame f_rpt_41_tit_acr_destinac v_cod_destinac_cobr
           input frame f_rpt_41_tit_acr_destinac v_dat_destinac
           input frame f_rpt_41_tit_acr_destinac v_ind_tip_destinac
           input frame f_rpt_41_tit_acr_destinac v_log_destinac_manual
           input frame f_rpt_41_tit_acr_destinac v_log_habilit_redestina_cobr
           input frame f_rpt_41_tit_acr_destinac v_ind_obs
           input frame f_rpt_41_tit_acr_destinac rs_imforma_cart_bcia
           input frame f_rpt_41_tit_acr_destinac v_cod_cart_bcia
           input frame f_rpt_41_tit_acr_destinac v_ind_tip_cart_bcia.

    /* ---Listar Consistàncias de T°tulos n∆o Destinados---*/
    if v_log_funcao_tit_nao_dest = yes then assign input frame f_rpt_41_tit_acr_destinac v_log_tit_nao_destndo.

    &if defined(BF_FIN_PIX_3_FLEXIBILIZA) &then
    if v_cod_pais_empres_usuar = "BRA" /*l_bra*/  then
       assign input frame f_rpt_41_tit_acr_destinac v_log_cobr_acr_pix.
    &endif

    if string(v_dat_destinac) = "" or string(v_dat_destinac) = ? then
       find destinac_cobr no-lock
            where destinac_cobr.cod_empresa = v_cod_empres_usuar
            and destinac_cobr.cod_destinac_cobr = v_cod_destinac_cobr
            and destinac_cobr.dat_inic_valid <= today
            and destinac_cobr.dat_fim_valid > today no-error.
    else
       find destinac_cobr no-lock
            where destinac_cobr.cod_empresa = v_cod_empres_usuar
            and destinac_cobr.cod_destinac_cobr = v_cod_destinac_cobr
            and destinac_cobr.dat_inic_valid <= v_dat_destinac
            and destinac_cobr.dat_fim_valid > v_dat_destinac no-error.

    if not avail destinac_cobr then do:
       /* &1 inexistente ou inv†lido ! */
       run pi_messages (input "show",
                        input 4938,
                        input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                           getStrTrans("Destinaá∆o Cobranáa", "ACR"), getStrTrans("Destinaá‰es Cobranáa", "ACR"), v_dat_destinac)) /*msg_4938*/.
       return "NOK" /*l_nok*/ .
    end.
    else do:

    /* --------------------------- Validaá∆o da seá∆o 'Portador Distribuiá∆o' ---------------------------*/
        find last param_empres_acr no-lock
            where param_empres_acr.cod_empresa = v_cod_empres_usuar no-error.
        if avail param_empres_acr then do:
            &IF DEFINED(BF_FIN_PORTAD_DISTRIB) &THEN
            if param_empres_acr.log_portad_distrib then do:
                if destinac_cobr.log_integr_distrib = yes then do:
                    /* Destinaá∆o de Cobranáa Inv†lida ! */
                    run pi_messages (input "show",
                                     input 22020,
                                     input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_22020*/.
                    return "NOK" /*l_nok*/ .             
                end.
            end.
            &ENDIF
        end.
    /* --------------------------- FIM Validaá∆o da seá∆o 'Portador Distribuiá∆o' ---------------------------*/    

        assign v_log_verifica_praz_auto_emis = destinac_cobr.log_verifica_praz_auto_emis.

        find first item_destinac_cobr no-lock
            where item_destinac_cobr.cod_empresa = destinac_cobr.cod_empresa
            and item_destinac_cobr.num_seq_destinac_cobr = destinac_cobr.num_seq_destinac_cobr
            and item_destinac_cobr.cod_destinac_cobr = destinac_cobr.cod_destinac_cobr no-error.
        if not avail item_destinac_cobr then do:
            /* Destinaá∆o de Cobranáa n∆o possui relacionamentos ! */
            run pi_messages (input "show",
                             input 5821,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_5821*/.
            return "NOK" /*l_nok*/ .
        end.    
    end.
    return "OK" /*l_ok*/ .
END PROCEDURE. /* pi_ix_p15_rpt_tit_acr_destinac */
/*****************************************************************************
** Procedure Interna.....: pi_retorna_atraso_med_clien
** Descricao.............: pi_retorna_atraso_med_clien
** Criado por............: adilsonhaut
** Criado em.............: 03/04/2020 09:02:54
** Alterado por..........: adilsonhaut
** Alterado em...........: 26/06/2020 07:39:03
*****************************************************************************/
PROCEDURE pi_retorna_atraso_med_clien:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_empresa
        as character
        format "x(3)"
        no-undo.
    def Input param p_cdn_cliente
        as Integer
        format ">>>,>>>,>>9"
        no-undo.
    def output param p_val_atraso_med_clien
        as decimal
        format "->>,>>>,>>>,>>9.99"
        decimals 2
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_cod_period_estatis
        as character
        format "99/9999":U
        label "Per°odo"
        column-label "Per°odo"
        no-undo.
    def var v_num_ano                        as integer         no-undo. /*local*/
    def var v_num_cont                       as integer         no-undo. /*local*/
    def var v_num_mes                        as integer         no-undo. /*local*/
    def var v_val_recebto                    as decimal         no-undo. /*local*/
    def var v_val_tot_recebto                as decimal         no-undo. /*local*/


    /************************** Variable Definition End *************************/

    assign p_val_atraso_med_clien = 0
           v_cod_period_estatis   = string(month(today), "99") + string(year(today), "9999").

    find clien_financ no-lock
       where clien_financ.cod_empresa = p_cod_empresa
       and   clien_financ.cdn_cliente = p_cdn_cliente no-error.
    if  avail clien_financ
    then do:
        find clien_analis_cr no-lock
            where clien_analis_cr.cod_empresa = clien_financ.cod_empresa
            and   clien_analis_cr.cdn_cliente = clien_financ.cdn_cliente no-error.
        if avail clien_analis_cr then do:
            assign v_num_mes = int(substring(v_cod_period_estatis, 1, 2))
                   v_num_ano = int(substring(v_cod_period_estatis, 3, 4)).
            do  v_num_cont = 1 to 12:
                if  v_num_mes = 0 then
                    assign v_num_mes = 12
                           v_num_ano = v_num_ano - 1.

                find estatis_clien no-lock
                    where estatis_clien.cod_empresa       = clien_financ.cod_empresa
                    and   estatis_clien.cdn_cliente       = clien_financ.cdn_cliente
                    and   estatis_clien.dat_estatis_clien = date(v_num_mes, 01, v_num_ano) no-error.
                if  avail estatis_clien then
                    assign v_val_recebto     = v_val_recebto     + estatis_clien.val_recebto
                           v_val_tot_recebto = v_val_tot_recebto + estatis_clien.val_tot_recebto.

                assign v_num_mes = v_num_mes - 1.
            end.
        end.
    end.

    if v_val_tot_recebto <> 0 then 
        assign p_val_atraso_med_clien = v_val_recebto / v_val_tot_recebto.
END PROCEDURE. /* pi_retorna_atraso_med_clien */
/*****************************************************************************
** Procedure Interna.....: pi_sdo_fluxo_cx_spool_modulos
** Descricao.............: pi_sdo_fluxo_cx_spool_modulos
** Criado por............: dalpra
** Criado em.............: 18/01/1999 13:50:37
** Alterado por..........: fut12197_2
** Alterado em...........: 15/06/2005 13:29:29
*****************************************************************************/
PROCEDURE pi_sdo_fluxo_cx_spool_modulos:

    /* --- API para Atualizaá∆o dos Saldos do Fluxo de Caixa SPOOL ---*/

    DO ON ERROR UNDO, RETURN ERROR:
    /* Manter esta alteraá∆o - Lista de Impacto gerada conforme alteraá∆o nos programas 
       ref. FO 1139356 */

    &if '{&emsfin_version}' >= "5.02" &then
        run prgfin/cfl/cfl704za.py (Input 1) /*prg_api_sdo_fluxo_cx_spool*/.
    &else
        run prgfin/cfl/cfl704zb.py (Input 1) /*prg_api_tab_livre_emsfin_spool_fluxo_cx*/.
    &endif

    if  return-value = '2782' then do:
        /* Vers∆o de integraá∆o incorreta ! */
        run pi_messages (input "show",
                         input 2782,
                         input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_2782*/.
        return error.
    end.

    END.
END PROCEDURE. /* pi_sdo_fluxo_cx_spool_modulos */


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
&endif

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
        message getStrTrans("Mensagem nr. ", "ACR") i_msg "!!!":U skip
                getStrTrans("Programa Mensagem", "ACR") c_prg_msg getStrTrans("n∆o encontrado.", "ACR")
                view-as alert-box error.
        return error.
    end.

    run value(c_prg_msg + ".p":U) (input c_action, input c_param).
    return return-value.
END PROCEDURE.  /* pi_messages */
/***********************  End of rpt_tit_acr_destinac ***********************/
