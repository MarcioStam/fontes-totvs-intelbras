/*****************************************************************************
**     Programa.........: esp/acr/esacr019rp.p
**     Descricao .......: Importaá∆o de Representantes
**     Versao...........: 1.00.000
**     Autor............: Anderson Silvano
**     Criado...........: 12/05/2004
**     Desc. Atualizaá∆o: 
**     Autor............: 
*******************************************************************************/

DEF VAR h-handle        AS HANDLE NO-UNDO.
DEF VAR c-linha         AS CHAR.
DEF VAR c-cliente       LIKE emscad.cliente.cdn_cliente.
DEF VAR c-arquivo-imp   AS CHAR.
DEF VAR i-mostra        AS INT.

/********************* Definiá∆o Temp-table  ********************/

DEF TEMP-TABLE tt-cliente-erro
    FIELD cdn_cliente                      as Integer format ">>>,>>>,>>9"
    FIELD des_mensagem                     as character format "x(50)".

def temp-table tt_cliente_integr_j no-undo
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cdn_cliente                  as Integer format ">>>,>>>,>>9" initial 0 label "Cliente" column-label "Cliente"
    field tta_num_pessoa                   as integer format ">>>,>>>,>>9" initial ? label "Pessoa" column-label "Pessoa"
    field tta_nom_abrev                    as character format "x(15)" label "Nome Abreviado" column-label "Nome Abreviado"
    field tta_cod_grp_clien                as character format "x(4)" label "Grupo Cliente" column-label "Grupo Cliente"
    field tta_cod_tip_clien                as character format "x(8)" label "Tipo Cliente" column-label "Tipo Cliente"
    field tta_dat_impl_clien               as date format "99/99/9999" initial ? label "Implantaá∆o Cliente" column-label "Implantaá∆o Cliente"
    field tta_cod_pais_ext                 as character format "x(20)" label "Pa°s Externo" column-label "Pa°s Externo"
    field tta_cod_pais                     as character format "x(3)" label "Pa°s" column-label "Pa°s"
    field tta_cod_id_feder                 as character format "x(20)" initial ? label "ID Federal" column-label "ID Federal"
    field ttv_ind_pessoa                   as character format "X(08)" initial "Jur°dica" label "Tipo Pessoa" column-label "Tipo Pessoa"
    field ttv_num_tip_operac               as integer format ">9"
    field tta_log_ems_20_atlzdo            as logical format "Sim/N∆o" initial no label "2.0 Atualizado" column-label "2.0 Atualizado"
    field ttv_ind_tip_pessoa_ems2          as character format "X(12)"
    index tt_cliente_empr_pessoa          
          tta_cod_empresa                  ascending
          tta_num_pessoa                   ascending
    index tt_cliente_grp_clien            
          tta_cod_grp_clien                ascending
    index tt_cliente_id                    is primary unique
          tta_cod_empresa                  ascending
          tta_cdn_cliente                  ascending
    index tt_cliente_nom_abrev             is unique
          tta_cod_empresa                  ascending
          tta_nom_abrev                    ascending.

def temp-table tt_fornecedor_integr_k no-undo
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field tta_num_pessoa                   as integer format ">>>,>>>,>>9" initial ? label "Pessoa" column-label "Pessoa"
    field tta_nom_abrev                    as character format "x(15)" label "Nome Abreviado" column-label "Nome Abreviado"
    field tta_cod_grp_fornec               as character format "x(4)" label "Grupo Fornecedor" column-label "Grp Fornec"
    field tta_cod_tip_fornec               as character format "x(8)" label "Tipo Fornecedor" column-label "Tipo Fornec"
    field tta_dat_impl_fornec              as date format "99/99/9999" initial today label "Data Implantaá∆o" column-label "Data Implantaá∆o"
    field tta_cod_pais_ext                 as character format "x(20)" label "Pa°s Externo" column-label "Pa°s Externo"
    field tta_cod_pais                     as character format "x(3)" label "Pa°s" column-label "Pa°s"
    field tta_cod_id_feder                 as character format "x(20)" initial ? label "ID Federal" column-label "ID Federal"
    field ttv_ind_pessoa                   as character format "X(08)" initial "Jur°dica" label "Tipo Pessoa" column-label "Tipo Pessoa"
    field tta_log_ems_20_atlzdo            as logical format "Sim/N∆o" initial no label "2.0 Atualizado" column-label "2.0 Atualizado"
    field ttv_num_tip_operac               as integer format ">9"
    field ttv_ind_tip_pessoa_ems2          as character format "X(12)"
    field tta_log_cr_pis                   as logical format "Sim/N∆o" initial no label "Credita PIS" column-label "Credita PIS"
    field tta_log_control_inss             as logical format "Sim/N∆o" initial no label "Controla Limite INSS" column-label "Contr Lim INSS"
    field tta_log_cr_cofins                as logical format "Sim/N∆o" initial no label "Credita COFINS" column-label "Credita COFINS"
    field tta_log_retenc_impto_pagto    as logical format "Sim/N∆o" initial no label "RetÇm no Pagto" column-label "RetÇm no Pagto"
    index tt_frncdr_empr_pessoa           
          tta_cod_empresa                  ascending
          tta_num_pessoa                   ascending
    index tt_frncdr_grp_fornec            
          tta_cod_grp_fornec               ascending
    index tt_frncdr_id                     is primary unique
          tta_cod_empresa                  ascending
          tta_cdn_fornecedor               ascending
    index tt_frncdr_nom_abrev              is unique
          tta_cod_empresa                  ascending
          tta_nom_abrev                    ascending.

def temp-table tt_clien_financ_integr_e no-undo
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cdn_cliente                  as Integer format ">>>,>>>,>>9" initial 0 label "Cliente" column-label "Cliente"
    field tta_cdn_repres                   as Integer format ">>>,>>9" initial 0 label "Representante" column-label "Representante"
    field ttv_cod_portad_prefer_ext        as character format "x(8)" label "Portad Prefer" column-label "Portad Prefer"
    field tta_cod_portad_ext               as character format "x(8)" label "Portador Externo" column-label "Portador Externo"
    field ttv_cod_portad_prefer            as character format "x(5)" label "Portador Preferenc" column-label "Port Preferenc"
    field tta_cod_portador                 as character format "x(5)" label "Portador" column-label "Portador"
    field tta_cod_cta_corren_bco           as character format "x(20)" label "Conta Corrente Banco" column-label "Conta Corrente Banco"
    field tta_cod_digito_cta_corren        as character format "x(2)" label "D°gito Cta Corrente" column-label "D°gito Cta Corrente"
    field tta_cod_agenc_bcia               as character format "x(10)" label "Agància Banc†ria" column-label "Agància Banc†ria"
    field tta_cod_banco                    as character format "x(8)" label "Banco" column-label "Banco"
    field tta_cod_classif_msg_cobr         as character format "x(8)" label "Classif Msg Cobr" column-label "Classif Msg Cobr"
    field tta_cod_instruc_bcia_1_acr       as character format "x(4)" label "Instruá∆o Bcia 1" column-label "Instruá∆o 1"
    field tta_cod_instruc_bcia_2_acr       as character format "x(4)" label "Instruá∆o Bcia 2" column-label "Instruá∆o 2"
    field tta_log_habilit_emis_boleto      as logical format "Sim/N∆o" initial no label "Emitir Boleto" column-label "Emitir Boleto"
    field tta_log_habilit_gera_avdeb       as logical format "Sim/N∆o" initial no label "Gerar AD" column-label "Gerar AD"
    field tta_log_retenc_impto             as logical format "Sim/N∆o" initial no label "RetÇm Imposto" column-label "RetÇm Imposto"
    field tta_log_habilit_db_autom         as logical format "Sim/N∆o" initial no label "DÇbito Auto" column-label "DÇbito Auto"
    field tta_num_tit_acr_aber             as integer format ">>>>,>>9" initial 0 label "Quant Tit  Aberto" column-label "Qtd Tit Abert"
    field tta_dat_ult_impl_tit_acr         as date format "99/99/9999" initial ? label "Èltima Implantaá∆o" column-label "Èltima Implantaá∆o"
    field tta_dat_ult_liquidac_tit_acr     as date format "99/99/9999" initial ? label "Ultima Liquidaá∆o" column-label "Ultima Liquidaá∆o"
    field tta_dat_maior_tit_acr            as date format "99/99/9999" initial ? label "Data Maior T°tulo" column-label "Data Maior T°tulo"
    field tta_dat_maior_acum_tit_acr       as date format "99/99/9999" initial ? label "Data Maior Acum" column-label "Data Maior Acum"
    field tta_val_ult_impl_tit_acr         as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Ultimo Tit" column-label "Valor Ultimo Tit"
    field tta_val_maior_tit_acr            as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Maior T°tulo" column-label "Vl Maior T°tulo"
    field tta_val_maior_acum_tit_acr       as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Maior Ac£mulo" column-label "Vl Maior Ac£mulo"
    field tta_ind_sit_clien_perda_dedut    as character format "X(21)" initial "Normal" label "Situaá∆o Cliente" column-label "Sit Cliente"
    field ttv_num_tip_operac               as integer format ">9"
    field tta_log_neces_acompto_spc        as logical format "Sim/N∆o" initial no label "Neces Acomp SPC" column-label "Neces Acomp SPC"
    field tta_cod_tip_fluxo_financ         as character format "x(12)" label "Tipo Fluxo Financ" column-label "Tipo Fluxo Financ"
    field tta_log_utiliz_verba             as logical format "Sim/N∆o" initial no label "Utiliza Verba de Pub" column-label "Utiliza Verba de Pub"
    field tta_val_perc_verba               as decimal format ">>>9.99" decimals 2 initial 0 label "Percentual Verba de" column-label "Percentual Verba de"
    field tta_val_min_avdeb                as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Valor M°nimo" column-label "Valor M°nimo"
    field tta_log_calc_multa               as logical format "Sim/N∆o" initial no label "Calcula Multa" column-label "Calcula Multa"
    field tta_num_dias_atraso_avdeb        as integer format "999" initial 0 label "Dias Atraso" column-label "Dias Atraso"
    field tta_cod_digito_agenc_bcia        as character format "x(2)" label "D°gito Ag Bcia" column-label "Dig Ag"
    field tta_cod_cart_bcia                as character format "x(3)" label "Carteira" column-label "Carteira"
    field tta_cod_cart_bcia_prefer         as character format "x(3)" label "Carteira Preferencia" column-label "Carteira Preferencia"
    index tt_clnfnnc_classif_msg          
          tta_cod_classif_msg_cobr         ascending
    index tt_clnfnnc_id                    is primary unique
          tta_cod_empresa                  ascending
          tta_cdn_cliente                  ascending
    index tt_clnfnnc_portador             
          tta_cod_portad_ext               ascending
    index tt_clnfnnc_rprsntnt             
          tta_cod_empresa                  ascending
          tta_cdn_repres                   ascending.

def temp-table tt_fornec_financ_integr_d no-undo
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field tta_cod_portad_ext               as character format "x(8)" label "Portador Externo" column-label "Portador Externo"
    field tta_cod_portador                 as character format "x(5)" label "Portador" column-label "Portador"
    field tta_cod_cta_corren_bco           as character format "x(20)" label "Conta Corrente Banco" column-label "Conta Corrente Banco"
    field tta_cod_digito_cta_corren        as character format "x(2)" label "D°gito Cta Corrente" column-label "D°gito Cta Corrente"
    field tta_cod_agenc_bcia               as character format "x(10)" label "Agància Banc†ria" column-label "Agància Banc†ria"
    field tta_cod_digito_agenc_bcia        as character format "x(2)" label "D°gito Ag Bcia" column-label "Dig Ag"
    field tta_cod_banco                    as character format "x(8)" label "Banco" column-label "Banco"
    field tta_cod_forma_pagto              as character format "x(3)" label "Forma Pagamento" column-label "F Pagto"
    field tta_cod_tip_fluxo_financ         as character format "x(12)" label "Tipo Fluxo Financ" column-label "Tipo Fluxo Financ"
    field tta_ind_tratam_vencto_sab        as character format "X(08)" initial "Prorroga" label "Vencimento Sabado" column-label "Vencto Sab"
    field tta_ind_tratam_vencto_dom        as character format "X(08)" initial "Prorroga" label "Vencimento Domingo" column-label "Vencto Dom"
    field tta_ind_tratam_vencto_fer        as character format "X(08)" initial "Prorroga" label "Vencimento Feriado" column-label "Vencto Feriado"
    field tta_ind_pagto_juros_fornec_ap    as character format "X(08)" label "Juros" column-label "Juros"
    field tta_ind_tip_fornecto             as character format "X(08)" label "Tipo Fornecimento" column-label "Fornecto"
    field tta_ind_armaz_val_pagto          as character format "X(12)" initial "N∆o Armazena" label "Armazena Valor Pagto" column-label "Armazena Valor Pagto"
    field tta_log_fornec_serv_export       as logical format "Sim/N∆o" initial no label "Fornec Exportaá∆o" column-label "Fornec Export"
    field tta_log_pagto_bloqdo             as logical format "Sim/N∆o" initial no label "Bloqueia Pagamento" column-label "Pagto Bloqdo"
    field tta_log_retenc_impto             as logical format "Sim/N∆o" initial no label "RetÇm Imposto" column-label "RetÇm Imposto"
    field tta_dat_ult_impl_tit_ap          as date format "99/99/9999" initial ? label "Data Ultima Impl" column-label "Dt Ult Impl"
    field tta_dat_ult_pagto                as date format "99/99/9999" initial ? label "Data Èltimo Pagto" column-label "Data Èltimo Pagto"
    field tta_dat_impl_maior_tit_ap        as date format "99/99/9999" initial ? label "Dt Impl Maior Tit" column-label "Dt Maior Tit"
    field tta_num_antecip_aber             as integer format ">>>>9" initial 0 label "Quant Antec  Aberto" column-label "Qtd Antec"
    field tta_num_tit_ap_aber              as integer format ">>>>9" initial 0 label "Quant Tit  Aberto" column-label "Qtd Tit Abert"
    field tta_val_tit_ap_maior_val         as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Maior Tit Impl" column-label "Valor Maior T°tulo"
    field tta_val_tit_ap_maior_val_aber    as decimal format "->>>>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Maior Tit  Aberto" column-label "Maior Vl Aberto"
    field tta_val_sdo_antecip_aber         as decimal format ">>>>>,>>>,>>9.99" decimals 2 initial 0 label "Saldo Antec Aberto" column-label "Sdo Antecip Aberto"
    field tta_val_sdo_tit_ap_aber          as decimal format "->>>>>,>>>,>>9.99" decimals 2 initial 0 label "Saldo Tit   Aberto" column-label "Sdo Tit Aberto"
    field ttv_num_tip_operac               as integer format ">9"
    field tta_cod_livre_1                  as character format "x(100)" label "Livre 1" column-label "Livre 1"
    field tta_num_rendto_tribut            as integer format ">>9" initial 0 label "Rendto Tribut†vel" column-label "Rendto Tribut†vel"
    field tta_log_vencto_dia_nao_util      as logical format "Sim/N∆o" initial no label "Vencto Igual Dt Flx" column-label "Vencto Igual Dt Flx"
    field tta_val_percent_bonif            as decimal format ">>9.99" decimals 2 initial 0 label "Perc Bonificaá∆o" column-label "Perc Bonificaá∆o"
    field tta_log_indic_rendto             as logical format "Sim/N∆o" initial no label "Ind Rendimento" column-label "Ind Rendimento"
    field tta_num_dias_compcao             as integer format ">>9" initial 0 label "Dias Compensaá∆o" column-label "Dias Compensaá∆o"
    index tt_frncfnnc_forma_pagto         
          tta_cod_forma_pagto              ascending
    index tt_frncfnnc_id                   is primary unique
          tta_cod_empresa                  ascending
          tta_cdn_fornecedor               ascending
    index tt_frncfnnc_portador            
          tta_cod_portad_ext               ascending.

def temp-table tt_pessoa_jurid_integr_j no-undo
    field tta_num_pessoa_jurid             as integer format ">>>,>>>,>>9" initial 0 label "Pessoa Jur°dica" column-label "Pessoa Jur°dica"
    field tta_nom_pessoa                   as character format "x(40)" label "Nome" column-label "Nome"
    field tta_cod_id_feder                 as character format "x(20)" initial ? label "ID Federal" column-label "ID Federal"
    field tta_cod_id_estad_jurid           as character format "x(20)" initial ? label "ID Estadual" column-label "ID Estadual"
    field tta_cod_id_munic_jurid           as character format "x(20)" initial ? label "ID Municipal" column-label "ID Municipal"
    field tta_cod_id_previd_social         as character format "x(20)" label "Id Previdància" column-label "Id Previdància"
    field tta_log_fins_lucrat              as logical format "Sim/N∆o" initial yes label "Fins Lucrativos" column-label "Fins Lucrativos"
    field tta_num_pessoa_jurid_matriz      as integer format ">>>,>>>,>>9" initial 0 label "Matriz" column-label "Matriz"
    field tta_nom_endereco                 as character format "x(40)" label "Endereáo" column-label "Endereáo"
    field tta_nom_ender_compl              as character format "x(10)" label "Complemento" column-label "Complemento"
    field tta_nom_bairro                   as character format "x(20)" label "Bairro" column-label "Bairro"
    field tta_nom_cidade                   as character format "x(32)" label "Cidade" column-label "Cidade"
    field tta_nom_condado                  as character format "x(32)" label "Condado" column-label "Condado"
    field tta_cod_pais_ext                 as character format "x(20)" label "Pa°s Externo" column-label "Pa°s Externo"
    field tta_cod_pais                     as character format "x(3)" label "Pa°s" column-label "Pa°s"
    field tta_cod_unid_federac             as character format "x(3)" label "Unidade Federaá∆o" column-label "UF"
    field tta_cod_cep                      as character format "x(20)" label "CEP" column-label "CEP"
    field tta_cod_cx_post                  as character format "x(20)" label "Caixa Postal" column-label "Caixa Postal"
    field tta_cod_telefone                 as character format "x(20)" label "Telefone" column-label "Telefone"
    field tta_cod_fax                      as character format "x(20)" label "FAX" column-label "FAX"
    field tta_cod_ramal_fax                as character format "x(07)" label "Ramal Fax" column-label "Ramal Fax"
    field tta_cod_telex                    as character format "x(7)" label "TELEX" column-label "TELEX"
    field tta_cod_modem                    as character format "x(20)" label "Modem" column-label "Modem"
    field tta_cod_ramal_modem              as character format "x(07)" label "Ramal Modem" column-label "Ramal Modem"
    field tta_cod_e_mail                   as character format "x(40)" label "Internet E-Mail" column-label "Internet E-Mail"
    field tta_des_anot_tab                 as character format "x(2000)" label "Anotaá∆o Tabela" column-label "Anotaá∆o Tabela"
    field tta_ind_tip_pessoa_jurid         as character format "X(08)" label "Tipo Pessoa" column-label "Tipo Pessoa"
    field tta_ind_tip_capit_pessoa_jurid   as character format "X(13)" label "Tipo Capital" column-label "Tipo Capital"
    field tta_cod_imagem                   as character format "x(30)" label "Imagem" column-label "Imagem"
    field tta_log_ems_20_atlzdo            as logical format "Sim/N∆o" initial no label "2.0 Atualizado" column-label "2.0 Atualizado"
    field ttv_num_tip_operac               as integer format ">9"
    field tta_num_pessoa_jurid_cobr        as integer format ">>>,>>>,>>9" initial 0 label "Pessoa Jur°dica Cobr" column-label "Pessoa Jur°dica Cobr"
    field tta_nom_ender_cobr               as character format "x(40)" label "Endereáo Cobranáa" column-label "Endereáo Cobranáa"
    field tta_nom_ender_compl_cobr         as character format "x(10)" label "Complemento" column-label "Complemento"
    field tta_nom_bairro_cobr              as character format "x(20)" label "Bairro Cobranáa" column-label "Bairro Cobranáa"
    field tta_nom_cidad_cobr               as character format "x(32)" label "Cidade Cobranáa" column-label "Cidade Cobranáa"
    field tta_nom_condad_cobr              as character format "x(32)" label "Condado Cobranáa" column-label "Condado Cobranáa"
    field tta_cod_unid_federac_cobr        as character format "x(3)" label "Unidade Federaá∆o" column-label "Unidade Federaá∆o"
    field ttv_cod_pais_ext_cob             as character format "x(20)" label "Pa°s Externo" column-label "Pa°s Externo"
    field ttv_cod_pais_cobr                as character format "x(3)" label "Pa°s Cobranáa" column-label "Pa°s Cobranáa"
    field tta_cod_cep_cobr                 as character format "x(20)" label "CEP Cobranáa" column-label "CEP Cobranáa"
    field tta_cod_cx_post_cobr             as character format "x(20)" label "Caixa Postal Cobraná" column-label "Caixa Postal Cobraná"
    field tta_num_pessoa_jurid_pagto       as integer format ">>>,>>>,>>9" initial 0 label "Pessoa Jurid Pagto" column-label "Pessoa Jurid Pagto"
    field tta_nom_ender_pagto              as character format "x(40)" label "Endereáo Pagamento" column-label "Endereáo Pagamento"
    field tta_nom_ender_compl_pagto        as character format "x(10)" label "Complemento" column-label "Complemento"
    field tta_nom_bairro_pagto             as character format "x(20)" label "Bairro Pagamento" column-label "Bairro Pagamento"
    field tta_nom_cidad_pagto              as character format "x(32)" label "Cidade Pagamento" column-label "Cidade Pagamento"
    field tta_nom_condad_pagto             as character format "x(32)" label "Condado Pagamento" column-label "Condado Pagamento"
    field tta_cod_unid_federac_pagto       as character format "x(3)" label "Unidade Federaá∆o" column-label "Unidade Federaá∆o"
    field ttv_cod_pais_ext_pag             as character format "x(20)" label "Pa°s Externo" column-label "Pa°s Externo"
    field ttv_cod_pais_pagto               as character format "x(3)" label "Pa°s Pagamento" column-label "Pa°s Pagamento"
    field tta_cod_cep_pagto                as character format "x(20)" label "CEP Pagamento" column-label "CEP Pagamento"
    field tta_cod_cx_post_pagto            as character format "x(20)" label "Caixa Postal Pagamen" column-label "Caixa Postal Pagamen"
    field ttv_rec_fiador_renegoc           as recid format ">>>>>>9" initial ?
    field ttv_log_altera_razao_social      as logical format "Sim/N∆o" initial no label "Altera Raz∆o Social" column-label "Altera Raz∆o Social"
    field tta_nom_home_page                as character format "x(40)" label "Home Page" column-label "Home Page"
    field tta_nom_ender_text               as character format "x(2000)" label "Endereco Compl." column-label "Endereco Compl."
    field tta_nom_ender_cobr_text          as character format "x(2000)" label "End Cobranca Compl" column-label "End Cobranca Compl"
    field tta_nom_ender_pagto_text         as character format "x(2000)" label "End Pagto Compl." column-label "End Pagto Compl."
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field ttv_ind_tip_pessoa_ems2          as character format "X(12)"
    index tt_pssjrda_cobranca             
          tta_num_pessoa_jurid_cobr        ascending
    index tt_pssjrda_id                    is primary unique
          tta_num_pessoa_jurid             ascending
          tta_cod_id_feder                 ascending
          tta_cod_pais_ext                 ascending
    index tt_pssjrda_id_previd_social     
          tta_cod_pais_ext                 ascending
          tta_cod_id_previd_social         ascending
    index tt_pssjrda_matriz               
          tta_num_pessoa_jurid_matriz      ascending
    index tt_pssjrda_nom_pessoa_word      
          tta_nom_pessoa                   ascending
    index tt_pssjrda_pagto                
          tta_num_pessoa_jurid_pagto       ascending
    index tt_pssjrda_razao_social         
          tta_nom_pessoa                   ascending
    index tt_pssjrda_unid_federac         
          tta_cod_pais_ext                 ascending
          tta_cod_unid_federac             ascending.

def temp-table tt_pessoa_fisic_integr_e no-undo
    field tta_num_pessoa_fisic             as integer   format '>>>,>>>,>>9':U
    field tta_nom_pessoa                   as character format 'x(40)':U
    field tta_cod_id_feder                 as character format 'x(20)':U
    field tta_cod_id_estad_fisic           as character format 'x(20)':U
    field tta_cod_orgao_emis_id_estad      as character format 'x(10)':U
    field tta_cod_unid_federac_emis_estad  as character format 'x(3)':U
    field tta_nom_endereco                 as character format 'x(40)':U
    field tta_nom_ender_compl              as character format 'x(10)':U
    field tta_nom_bairro                   as character format 'x(20)':U
    field tta_nom_cidade                   as character format 'x(32)':U
    field tta_nom_condado                  as character format 'x(32)':U
    field tta_cod_pais_ext                 as character format 'x(20)':U
    field tta_cod_pais                     as character format 'x(3)':U
    field tta_cod_unid_federac             as character format 'x(3)':U
    field tta_cod_cep                      as character format 'x(20)':U
    field tta_cod_cx_post                  as character format 'x(20)':U
    field tta_cod_telefone                 as character format 'x(20)':U
    field tta_cod_ramal                    as character format 'x(7)':U
    field tta_cod_fax                      as character format 'x(20)':U
    field tta_cod_ramal_fax                as character format 'x(07)':U
    field tta_cod_telex                    as character format 'x(7)':U
    field tta_cod_modem                    as character format 'x(20)':U
    field tta_cod_ramal_modem              as character format 'x(07)':U
    field tta_cod_e_mail                   as character format 'x(40)':U
    field tta_dat_nasc_pessoa_fisic        as date      format '99/99/9999':U
    field ttv_cod_pais_ext_nasc            as character format 'x(20)':U
    field ttv_cod_pais_nasc                as character format 'x(3)':U
    field tta_cod_unid_federac_nasc        as character format 'x(3)':U
    field tta_des_anot_tab                 as character format 'x(2000)':U
    field tta_nom_mae_pessoa               as character format 'x(40)':U
    field tta_cod_imagem                   as character format 'x(30)':U
    field tta_log_ems_20_atlzdo            as logical   format 'Sim/N∆o':U
    field ttv_num_tip_operac               as integer   format '>9':U
    field ttv_rec_fiador_renegoc           as recid     format '>>>>>>9':U
    field ttv_log_altera_razao_social      as logical   format 'Sim/N∆o':U
    field tta_nom_nacion_pessoa_fisic      as character format 'x(40)':U
    field tta_nom_profis_pessoa_fisic      as character format 'x(40)':U
    field tta_ind_estado_civil_pessoa      as character format 'X(10)':U
    field tta_nom_home_page                as character format 'x(40)':U
    field tta_nom_ender_text               as character format 'x(2000)':U
    /* In°cio campos novos */
    FIELD tta_cod_id_munic_fisic           AS CHARACTER FORMAT 'x(20)':U
    FIELD tta_cod_id_previd_social         AS CHARACTER FORMAT 'x(20)':U
    FIELD tta_dat_vencto_id_munic          AS DATE      FORMAT '99/99/9999':U
    /* Fim campos novos */
    index tt_pssfsca_id                    is primary unique
          tta_num_pessoa_fisic             ascending
          tta_cod_id_feder                 ascending
          tta_cod_pais_ext                 ascending
    index tt_pssfsca_identpes             
          tta_nom_pessoa                   ascending
          tta_cod_id_estad_fisic           ascending
          tta_cod_unid_federac_emis_estad  ascending
          tta_dat_nasc_pessoa_fisic        ascending
          tta_nom_mae_pessoa               ascending
    index tt_pssfsca_nom_pessoa_word      
          tta_nom_pessoa                   ascending
    index tt_pssfsca_unid_federac         
          tta_cod_pais_ext                 ascending
          tta_cod_unid_federac             ascending.

def temp-table tt_contato_integr_e no-undo
    field tta_num_pessoa_jurid             as integer format ">>>,>>>,>>9" initial 0 label "Pessoa Jur°dica" column-label "Pessoa Jur°dica"
    field tta_nom_abrev_contat             as character format "x(15)" label "Abreviado Contato" column-label "Abreviado Contato"
    field tta_nom_pessoa                   as character format "x(40)" label "Nome" column-label "Nome"
    field tta_cod_telef_contat             as character format "x(20)" label "Telefone" column-label "Telefone"
    field tta_cod_ramal_contat             as character format "x(07)" label "Ramal" column-label "Ramal"
    field tta_cod_fax_contat               as character format "x(20)" label "Fax" column-label "Fax"
    field tta_cod_ramal_fax_contat         as character format "x(07)" label "Ramal Fax" column-label "Ramal Fax"
    field tta_cod_modem_contat             as character format "x(20)" label "Modem" column-label "Modem"
    field tta_cod_ramal_modem_contat       as character format "x(07)" label "Ramal Modem" column-label "Ramal Modem"
    field tta_cod_e_mail_contat            as character format "x(40)" label "Internet E-Mail" column-label "Internet E-Mail"
    field tta_des_anot_tab                 as character format "x(2000)" label "Anotaá∆o Tabela" column-label "Anotaá∆o Tabela"
    field tta_num_pessoa_fisic             as integer format ">>>,>>>,>>9" initial 0 label "Pessoa F°sica" column-label "Pessoa F°sica"
    field tta_ind_priorid_envio_docto      as character format "x(10)" initial "e-Mail/Fax" label "Prioridade Envio" column-label "Prioridade Envio"
    field tta_cdn_cliente                  as Integer format ">>>,>>>,>>9" initial 0 label "Cliente" column-label "Cliente"
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field tta_log_ems_20_atlzdo            as logical format "Sim/N∆o" initial no label "2.0 Atualizado" column-label "2.0 Atualizado"
    field ttv_num_tip_operac               as integer format ">9"
    field tta_nom_endereco                 as character format "x(40)" label "Endereáo" column-label "Endereáo"
    field tta_nom_ender_compl              as character format "x(10)" label "Complemento" column-label "Complemento"
    field tta_nom_bairro                   as character format "x(20)" label "Bairro" column-label "Bairro"
    field tta_nom_cidade                   as character format "x(32)" label "Cidade" column-label "Cidade"
    field tta_nom_condado                  as character format "x(32)" label "Condado" column-label "Condado"
    field tta_cod_pais                     as character format "x(3)" label "Pa°s" column-label "Pa°s"
    field tta_cod_cx_post                  as character format "x(20)" label "Caixa Postal" column-label "Caixa Postal"
    field tta_cod_unid_federac             as character format "x(3)" label "Unidade Federaá∆o" column-label "UF"
    field tta_cod_cep_cobr                 as character format "x(20)" label "CEP Cobranáa" column-label "CEP Cobranáa"
    field tta_nom_ender_text               as character format "x(2000)" label "Endereco Compl." column-label "Endereco Compl."
    index tt_contato_id                    is primary unique
          tta_num_pessoa_jurid             ascending
          tta_nom_abrev_contat             ascending
          tta_cdn_cliente                  ascending
          tta_cdn_fornecedor               ascending
    index tt_contato_pssfsca              
          tta_num_pessoa_fisic             ascending.

def temp-table tt_contat_clas_integr no-undo
    field tta_num_pessoa_jurid             as integer format ">>>,>>>,>>9" initial 0 label "Pessoa Jur°dica" column-label "Pessoa Jur°dica"
    field tta_nom_abrev_contat             as character format "x(15)" label "Abreviado Contato" column-label "Abreviado Contato"
    field tta_cod_clas_contat              as character format "x(8)" label "Classe Contato" column-label "Classe"
    field ttv_num_tip_operac               as integer format ">9"
    index tt_cnttclsa_clas_contat         
          tta_cod_clas_contat              ascending
    index tt_cnttclsa_id                   is primary unique
          tta_num_pessoa_jurid             ascending
          tta_nom_abrev_contat             ascending
          tta_cod_clas_contat              ascending
    index tt_cnttclsa_pessoa_classe       
          tta_num_pessoa_jurid             ascending
          tta_cod_clas_contat              ascending.

def temp-table tt_estrut_clien_integr no-undo
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cdn_clien_pai                as Integer format ">>>,>>>,>>9" initial 0 label "Cliente Pai" column-label "Cliente Pai"
    field tta_cdn_clien_filho              as Integer format ">>>,>>>,>>9" initial 0 label "Cliente Filho" column-label "Cliente Filho"
    field tta_log_dados_financ_tip_pai     as logical format "Sim/N∆o" initial no label "Armazena Valor" column-label "Armazena Valor"
    field tta_num_seq_estrut_clien         as integer format ">>>,>>9" initial 0 label "Sequància" column-label "Sequància"
    field ttv_num_tip_operac               as integer format ">9"
    index tt_estrtcln_clien_filho         
          tta_cod_empresa                  ascending
          tta_cdn_clien_filho              ascending
    index tt_estrtcln_id                   is primary unique
          tta_cod_empresa                  ascending
          tta_cdn_clien_pai                ascending
          tta_cdn_clien_filho              ascending
          tta_num_seq_estrut_clien         ascending.

def temp-table tt_estrut_fornec_integr no-undo
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cdn_fornec_pai               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor Pai" column-label "Fornecedor Pai"
    field tta_cdn_fornec_filho             as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor Filho" column-label "Fornecedor Filho"
    field tta_log_dados_financ_tip_pai     as logical format "Sim/N∆o" initial no label "Armazena Valor" column-label "Armazena Valor"
    field tta_num_seq_estrut_fornec        as integer format ">>>,>>9" initial 0 label "Sequencia" column-label "Sequencia"
    field ttv_num_tip_operac               as integer format ">9"
    index tt_strtfrn_fornec_filho         
          tta_cod_empresa                  ascending
          tta_cdn_fornec_filho             ascending
    index tt_strtfrn_id                    is primary unique
          tta_cod_empresa                  ascending
          tta_cdn_fornec_pai               ascending
          tta_cdn_fornec_filho             ascending
          tta_num_seq_estrut_fornec        ascending.

def temp-table tt_histor_clien_integr no-undo
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cdn_cliente                  as Integer format ">>>,>>>,>>9" initial 0 label "Cliente" column-label "Cliente"
    field tta_num_seq_histor_clien         as integer format ">>>>,>>9" initial 0 label "Sequencia" column-label "Sequencia"
    field tta_des_abrev_histor_clien       as character format "x(40)" label "Abrev Hist¢rico" column-label "Abrev Hist¢rico"
    field tta_des_histor_clien             as character format "x(2000)" label "Hist¢rico" column-label "Hist¢rico"
    field ttv_num_tip_operac               as integer format ">9"
    index tt_hstrcln_id                    is primary unique
          tta_cod_empresa                  ascending
          tta_cdn_cliente                  ascending
          tta_num_seq_histor_clien         ascending.

def temp-table tt_histor_fornec_integr no-undo
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field tta_num_seq_histor_fornec        as integer format ">>>>,>>9" initial 0 label "Sequencia" column-label "Sequencia"
    field tta_des_abrev_histor_fornec      as character format "x(40)" label "Abrev Hist¢rico" column-label "Abrev Hist¢rico"
    field tta_des_histor_fornec            as character format "x(40)" label "Hist¢rico Fornecedor" column-label "Hist¢rico Fornecedor"
    field ttv_num_tip_operac               as integer format ">9"
    index tt_hstrfrna_id                   is primary unique
          tta_cod_empresa                  ascending
          tta_cdn_fornecedor               ascending
          tta_num_seq_histor_fornec        ascending.

def temp-table tt_ender_entreg_integr_e no-undo
    field tta_num_pessoa_jurid             as integer format ">>>,>>>,>>9" initial 0 label "Pessoa Jur°dica" column-label "Pessoa Jur°dica"
    field tta_cod_ender_entreg             as character format "x(15)" label "Endereáo Entrega" column-label "Endereáo Entrega"
    field tta_nom_ender_entreg             as character format "x(40)" label "Nome Endereáo Entreg" column-label "Nome Endereáo Entreg"
    field tta_nom_bairro_entreg            as character format "x(20)" label "Bairro Entrega" column-label "Bairro Entrega"
    field tta_nom_cidad_entreg             as character format "x(32)" label "Cidade Entrega" column-label "Cidade Entrega"
    field tta_nom_condad_entreg            as character format "x(30)" label "Condado Entrega" column-label "Condado Entrega"
    field tta_cod_pais_ext                 as character format "x(20)" label "Pa°s Externo" column-label "Pa°s Externo"
    field tta_cod_pais                     as character format "x(3)" label "Pa°s" column-label "Pa°s"
    field tta_cod_unid_federac_entreg      as character format "x(3)" label "Unidade Federaá∆o" column-label "Unidade Federaá∆o"
    field tta_cod_cep_entreg               as character format "x(20)" label "CEP Entrega" column-label "CEP Entrega"
    field tta_cod_cx_post_entreg           as character format "x(20)" label "Caixa Postal" column-label "Caixa Postal"
    field ttv_num_tip_operac               as integer format ">9"
    field tta_nom_ender_entreg_text        as character format "x(2000)" label "End Entrega Compl." column-label "End Entrega Compl."
    index tt_ndrntrga_id                   is primary unique
          tta_num_pessoa_jurid             ascending
          tta_cod_ender_entreg             ascending
    index tt_ndrntrga_pais                
          tta_cod_pais_ext                 ascending
          tta_cod_unid_federac_entreg      ascending.

def temp-table tt_telef_integr no-undo
    field tta_cod_telef_sem_edic           as character format "x(20)" label "Telefone" column-label "Telefone"
    field tta_ind_tip_telef_pessoa         as character format "X(08)" label "Tipo Telefone" column-label "Tipo Telefone"
    field ttv_num_tip_operac               as integer format ">9"
    index tt_telef_id                      is primary
          tta_cod_telef_sem_edic           ascending.

def temp-table tt_telef_pessoa_integr no-undo
    field tta_cod_telef_sem_edic           as character format "x(20)" label "Telefone" column-label "Telefone"
    field tta_num_pessoa                   as integer format ">>>,>>>,>>9" initial ? label "Pessoa" column-label "Pessoa"
    field tta_des_telefone                 as character format "x(40)" label "Descriá∆o Telefone" column-label "Descriá∆o Telefone"
    field tta_cod_telefone                 as character format "x(20)" label "Telefone" column-label "Telefone"
    field ttv_num_tip_operac               as integer format ">9"
    field tta_cdn_cliente                  as Integer format ">>>,>>>,>>9" initial 0 label "Cliente" column-label "Cliente"
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    index tt_tlfpss_id                     is primary unique
          tta_cod_telef_sem_edic           ascending
          tta_num_pessoa                   ascending
          tta_cdn_cliente                  ascending
          tta_cdn_fornecedor               ascending
    index tt_tlfpss_pessoa                 is unique
          tta_num_pessoa                   ascending
          tta_cod_telef_sem_edic           ascending.

def temp-table tt_pj_ativid_integr_i no-undo
    field tta_num_pessoa_jurid             as integer format ">>>,>>>,>>9" initial 0 label "Pessoa Jur°dica" column-label "Pessoa Jur°dica"
    field tta_cod_ativid_pessoa_jurid      as character format "x(8)" label "Atividade" column-label "Atividade"
    field tta_log_ativid_pessoa_princ      as logical format "Sim/N∆o" initial no label "Atividade Principal" column-label "Principal"
    field ttv_num_tip_operac               as integer format ">9"
    field ttv_cdn_clien_fornec             as Integer format ">>>,>>9" initial 0
    index tt_pssjrdtv_atividade           
          tta_cod_ativid_pessoa_jurid      ascending
    index tt_pssjrdtv_id                   is primary unique
          tta_num_pessoa_jurid             ascending
          tta_cod_ativid_pessoa_jurid      ascending
          ttv_cdn_clien_fornec             ascending.

def temp-table tt_pj_ramo_negoc_integr_j no-undo
    field tta_num_pessoa_jurid             as integer format ">>>,>>>,>>9" initial 0 label "Pessoa Jur°dica" column-label "Pessoa Jur°dica"
    field tta_cod_ramo_negoc               as character format "x(8)" label "Ramo Neg¢cio" column-label "Ramo Neg¢cio"
    field tta_log_ramo_negoc_princ         as logical format "Sim/N∆o" initial no label "Ramo Negoc Principal" column-label "Principal"
    field ttv_num_tip_operac               as integer format ">9"
    field ttv_cdn_clien_fornec             as Integer format ">>>,>>9" initial 0
    index tt_pssjrdm_id                    is primary unique
          tta_num_pessoa_jurid             ascending
          tta_cod_ramo_negoc               ascending
          ttv_cdn_clien_fornec             ascending
    index tt_pssjrdrm_ramo_negoc          
          tta_cod_ramo_negoc               ascending.

def temp-table tt_porte_pj_integr no-undo
    field tta_num_pessoa_jurid             as integer format ">>>,>>>,>>9" initial 0 label "Pessoa Jur°dica" column-label "Pessoa Jur°dica"
    field tta_dat_porte_pessoa_jurid       as date format "99/99/9999" initial ? label "Data Porte" column-label "Data Porte"
    field tta_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda"
    field tta_val_vendas                   as decimal format ">>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Vendas" column-label "Vendas"
    field tta_val_patrim_liq               as decimal format ">>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Patrimìnio L°quido" column-label "Patrimìnio L°quido"
    field tta_val_lucro_liq                as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Lucro L°quido" column-label "Lucro L°quido"
    field tta_val_capit_giro_proprio       as decimal format ">>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Capital Giro Pr¢prio" column-label "Capital Giro Pr¢prio"
    field tta_val_endivto_geral            as decimal format ">>9.99" decimals 2 initial 0 label "Endividamento Geral" column-label "Endividamento Geral"
    field tta_val_endivto_longo_praz       as decimal format ">>9.99" decimals 2 initial 0 label "Endividamento Longo" column-label "Endividamento Longo"
    field tta_val_vendas_func              as decimal format ">>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Vendas Funcion†rio" column-label "Vendas Funcion†rio"
    field tta_qtd_funcionario              as decimal format ">>>,>>9" initial 0 label "Qtd Funcion†rios" column-label "Qtd Funcion†rios"
    field tta_cod_classif_pessoa_jurid     as character format "x(8)" label "Classificaá∆o" column-label "Classificaá∆o"
    field tta_des_anot_tab                 as character format "x(2000)" label "Anotaá∆o Tabela" column-label "Anotaá∆o Tabela"
    field ttv_num_tip_operac               as integer format ">9"
    index tt_prtpssjr_id                   is primary unique
          tta_num_pessoa_jurid             ascending
          tta_dat_porte_pessoa_jurid       ascending
    index tt_prtpssjr_indic_econ          
          tta_cod_indic_econ               ascending.

def temp-table tt_idiom_pf_integr no-undo
    field tta_num_pessoa_fisic             as integer format ">>>,>>>,>>9" initial 0 label "Pessoa F°sica" column-label "Pessoa F°sica"
    field tta_cod_idioma                   as character format "x(8)" label "Idioma" column-label "Idioma"
    field tta_log_idiom_princ              as logical format "Sim/N∆o" initial no label "Principal" column-label "Principal"
    field ttv_num_tip_operac               as integer format ">9"
    index tt_dmpssfs_id                    is primary unique
          tta_num_pessoa_fisic             ascending
          tta_cod_idioma                   ascending
    index tt_dmpssfs_idioma               
          tta_cod_idioma                   ascending.

def temp-table tt_idiom_contat_integr no-undo
    field tta_num_pessoa_jurid             as integer format ">>>,>>>,>>9" initial 0 label "Pessoa Jur°dica" column-label "Pessoa Jur°dica"
    field tta_nom_abrev_contat             as character format "x(15)" label "Abreviado Contato" column-label "Abreviado Contato"
    field tta_cod_idioma                   as character format "x(8)" label "Idioma" column-label "Idioma"
    field tta_log_idiom_princ              as logical format "Sim/N∆o" initial no label "Principal" column-label "Principal"
    field ttv_num_tip_operac               as integer format ">9"
    index tt_dmcntta_id                    is primary unique
          tta_num_pessoa_jurid             ascending
          tta_nom_abrev_contat             ascending
          tta_cod_idioma                   ascending
    index tt_dmcntta_idioma               
          tta_cod_idioma                   ascending.

def temp-table tt_retorno_clien_fornec no-undo
    field ttv_cod_parameters               as character format "x(256)"
    field ttv_num_mensagem                 as integer format ">>>>,>>9" label "N£mero" column-label "N£mero Mensagem"
    field ttv_des_mensagem                 as character format "x(50)" label "Mensagem" column-label "Mensagem"
    field ttv_des_ajuda                    as character format "x(50)" label "Ajuda" column-label "Ajuda"
    field ttv_cod_parameters_clien         as character format "x(2000)"
    field ttv_cod_parameters_fornec        as character format "x(2000)"
    field ttv_log_envdo                    as logical format "Sim/N∆o" initial no
    field ttv_cod_parameters_clien_financ  as character format "x(2000)"
    field ttv_cod_parameters_fornec_financ as character format "x(2000)"
    field ttv_cod_parameters_pessoa_fisic  as character format "x(2000)"
    field ttv_cod_parameters_pessoa_jurid  as character format "x(2000)"
    field ttv_cod_parameters_estrut_clien  as character format "x(2000)"
    field ttv_cod_parameters_estrut_fornec as character format "x(2000)"
    field ttv_cod_parameters_contat        as character format "x(2000)"
    field ttv_cod_parameters_repres        as character format "x(2000)"
    field ttv_cod_parameters_ender_entreg  as character format "x(2000)"
    field ttv_cod_parameters_pessoa_ativid as character format "x(2000)"
    field ttv_cod_parameters_ramo_negoc    as character format "x(2000)"
    field ttv_cod_parameters_porte_pessoa  as character format "x(2000)"
    field ttv_cod_parameters_idiom_pessoa  as character format "x(2000)"
    field ttv_cod_parameters_clas_contat   as character format "x(2000)"
    field ttv_cod_parameters_idiom_contat  as character format "x(2000)"
    field ttv_cod_parameters_telef         as character format "x(2000)"
    field ttv_cod_parameters_telef_pessoa  as character format "x(2000)"
    field ttv_cod_parameters_histor_clien  as character format "x(4000)"
    field ttv_cod_parameters_histor_fornec as character format "x(4000)".

def temp-table tt_clien_analis_cr_integr no-undo
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cdn_cliente                  as Integer format ">>>,>>>,>>9" initial 0 label "Cliente" column-label "Cliente"
    field tta_cod_tip_clien                as character format "x(8)" label "Tipo Cliente" column-label "Tipo Cliente"
    field tta_cod_clas_risco_clien         as character format "x(8)" label "Classe Risco" column-label "Classe Risco"
    field tta_log_neces_acompto_spc        as logical format "Sim/N∆o" initial no label "Neces Acomp SPC" column-label "Neces Acomp SPC"
    field tta_ind_sit_cr                   as character format "X(15)" label "Situaá∆o" column-label "Situaá∆o"
    field ttv_num_tip_operac               as integer format ">9"
    index tt_clien_unico                   is primary unique
          tta_cod_empresa                  ascending
          tta_cdn_cliente                  ascending.

DEF TEMP-TABLE tt-repres
    FIELD cdn_cliente LIKE emscad.cliente.cdn_cliente
    FIELD cdn_repres  LIKE representante.cdn_repres.

/********************** Fim Def Temp-table  *********************/

DEF STREAM s_acom.
DEF STREAM s_erro.

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

/************** Fim de variaveis de selecao *******/

DEF NEW GLOBAL SHARED VAR L-Implanta              AS   LOG    INIT NO.
DEF NEW GLOBAL SHARED VAR C-Seg-Usuario           AS   CHAR   FORM "x(12)" NO-UNDO.
DEF NEW GLOBAL SHARED VAR I-Num-Ped-Exec-Rpw      AS   INTE   NO-UNDO.   
DEF NEW GLOBAL SHARED VAR I-Pais-Impto-Usuario    AS   INTE   FORM ">>9" NO-UNDO.
DEF NEW GLOBAL SHARED VAR L-Rpc                   AS   LOG    NO-UNDO.
DEF NEW GLOBAL SHARED VAR R-Registro-Atual        AS   ROWID  NO-UNDO.
DEF NEW GLOBAL SHARED VAR C-Arquivo-Log           AS   CHAR   FORM "x(60)"NO-UNDO.
DEF NEW GLOBAL SHARED VAR I-Num-Ped               AS   INTE   NO-UNDO.
DEF NEW GLOBAL SHARED VAR H_Prog_Segur_Estab      AS   HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR V_Num_Tip_Aces_Usuar    AS   INTE   NO-UNDO.     
DEF NEW GLOBAL SHARED VAR V_Num_Ped_Exec_Corren   AS   INTE   FORM ">>>>>9" NO-UNDO.
DEF NEW GLOBAL SHARED VAR V_Cod_Dwb_User          AS   CHAR   FORM "x(15)"  NO-UNDO. /* usuario corrente */
DEF NEW GLOBAL SHARED VAR C-Dir-Spool-Servid-Exec AS   CHAR   NO-UNDO.
DEF NEW GLOBAL SHARED VAR I-Num-Ped-Exec-Rpw      AS   INTE   NO-UNDO.

DEF NEW GLOBAL SHARED TEMP-TABLE Tt-Servid-Rpc-Aplicat
    FIELD Tta-Cod-Aplicat-Dtsul LIKE Aplicat_Dtsul.Cod_Aplicat_Dtsul
    FIELD Tta-Hdl-Servid-Rpc    AS HANDLE.

DEF VAR Rw-Log-Exec                             AS ROWID NO-UNDO.
DEF VAR C-Erro-Rpc                              AS CHAR FORM "x(60)" INIT " " NO-UNDO.
DEF VAR C-Erro-Aux                              AS CHAR FORM "x(60)" INIT " " NO-UNDO.

/****************** Definiáao de Vari†veis de Processamento do Relat¢rio *********************/

DEF VAR V_Cod_Empresa           LIKE EmsUni.Empresa.Cod_Empresa NO-UNDO.
DEF VAR I                       AS INTE NO-UNDO.
DEF VAR V_Cod_Dwb_File          LIKE Dwb_Set_List_Param.Cod_Dwb_File     NO-UNDO.
DEF VAR V_Cod_Dwb_Output        LIKE Dwb_Set_List_Param.Cod_Dwb_Output   NO-UNDO.
DEF VAR C-Impressora            LIKE Ped_Exec_Param.Nom_Dwb_Printer      NO-UNDO.
DEF VAR C-Layout                LIKE Ped_Exec_Param.Cod_Dwb_Print_Layout NO-UNDO.
DEF VAR H-Hacr155               AS HANDLE NO-UNDO.
DEF VAR V-Cod-Destino-Impres    AS CHAR   NO-UNDO.
DEF VAR V-Num-Reg-Lidos         AS INTE   NO-UNDO.
DEF VAR V-Num-Point             AS INTE   NO-UNDO.
DEF VAR V-Num-Set               AS INTE   NO-UNDO.
DEF VAR V-Cod-Arquivo           AS CHAR.
DEF VAR V-Num-Tip-Reg           AS INTE FORM "999".
DEF VAR C-Empresa               AS CHAR FORM "x(40)"  NO-UNDO.
DEF VAR C-Titulo-Relat          AS CHAR FORM "x(50)"  NO-UNDO.
DEF VAR C-Sistema               AS CHAR FORM "x(25)"  NO-UNDO.
DEF VAR C-Rodape                AS CHAR               NO-UNDO.
DEF VAR C-Programa              AS CHAR FORM "x(08)"  NO-UNDO.
DEF VAR C-Versao                AS CHAR FORM "x(04)"  NO-UNDO.
DEF VAR C-Revisao               AS CHAR FORM "999"    NO-UNDO.
DEF VAR V_Num_Pag               AS INTE INIT 1        NO-UNDO.
DEF VAR Ch_Linha                AS CHAR FORM "x(215)" NO-UNDO.

DEF VAR v_nom_enterprise        AS CHAR FORM "x(40)"  NO-UNDO.

DEF STREAM Stream_1.

DEF BUFFER B_Ped_Exec_Style     FOR Ped_Exec.
DEF BUFFER B_Servid_Exec_Style  FOR servid_Exec.

DEF NEW SHARED VAR V_Rpt_Stream_1_Lines      AS INTE INIT 60.
DEF NEW SHARED VAR V_Rpt_Stream_1_Columns    AS INTE INIT 132.
DEF NEW SHARED VAR V_Rpt_Stream_1_Bottom     AS INTE INIT 60.
DEF NEW SHARED VAR V_Rpt_Stream_1_Page       AS INTE.
DEF NEW SHARED VAR V_Rpt_Stream_1_Name       AS CHAR INIT "Acerto Previs∆o de Comiss‰es".

DEF FRAME f-erro
    tt-cliente-erro.cdn_cliente    LABEL "Cliente"
    tt-cliente-erro.des_mensagem   LABEL "Desc Erro"
    WITH NO-BOX WIDTH 132 DOWN STREAM-IO.

DEF FRAME f-acerto
    tt-repres.cdn_cliente
    WITH NO-BOX WIDTH 132 DOWN STREAM-IO.

def frame f-cabec header
    FILL('-', 132) FORMAT 'x(132)' AT 1
    v_nom_enterprise at 1 format 'x(40)'
    C-Titulo-Relat at 52 format 'x(40)'
    'P†gina:' at 119
    page-number(Stream_1) format '>>>>>9' skip
    FILL("-", 113) FORMAT 'x(113)' at 1 TODAY format '99/99/9999' '-'
    STRING(TIME, 'HH:MM') format "x(5)" skip (1)
    with no-box no-labels width 132 page-top stream-io.

def frame f-rodape header
    FILL('-', 70) FORMAT 'x(70)' AT 1
    'DATASUL - Espec°ficos Intelbr†s - esacr019 - V:5.00.00.000' SKIP
    with no-box no-labels width 132 page-bottom stream-io.

FIND emscad.empresa NO-LOCK
     WHERE empresa.cod_empresa = v_cod_empres_usuar NO-ERROR.
IF AVAIL empresa THEN
    ASSIGN v_nom_enterprise   = empresa.nom_razao_social.
ELSE
    ASSIGN v_nom_enterprise   = 'DATASUL'.

ASSIGN C-Empresa = "XXXXXXXXXXXXXXX".

IF V_Cod_Dwb_User = "" 
THEN ASSIGN V_Cod_Dwb_User = V_Cod_Usuar_Corren.

IF V_Num_Ped_Exec_Corren > 0 THEN 
DO.
  FIND Ped_Exec_Param NO-LOCK
       WHERE Ped_Exec_Param.num_Ped_Exec = V_Num_Ped_Exec_Corren NO-ERROR.
  IF AVAIL Ped_Exec_Param THEN 
  DO.
    FIND Dwb_Set_List_Param NO-LOCK
         WHERE Dwb_Set_List_Param.Cod_Dwb_Program = "esacr019"
           AND Dwb_Set_List_Param.Cod_Dwb_User    = V_Cod_Dwb_User 
         NO-ERROR.
   ASSIGN V_Cod_Dwb_File    = Ped_Exec_Param.Cod_Dwb_File
          V_Cod_Dwb_Output  = Ped_Exec_Param.Cod_Dwb_Output
          C-Impressora      = Ped_Exec_Param.Nom_Dwb_Printer
          C-Layout          = Ped_Exec_Param.Cod_Dwb_Print_Layout
          i-mostra          = INTEGER(ENTRY(2,dwb_set_list_param.cod_dwb_parameters,chr(10)))
          c-arquivo-imp     = ENTRY(3,dwb_set_list_param.cod_dwb_parameters,chr(10)).

  END. /* End do IF AVAIL Ped_Exec_Param */
END. /* end do IF V_Num_Ped_Exec_Corren > 0 */
ELSE
DO.
  FIND Dwb_Set_List_Param NO-LOCK
       WHERE Dwb_Set_List_Param.Cod_Dwb_Program = "esacr019"
         AND Dwb_Set_List_Param.Cod_Dwb_User    = V_Cod_Dwb_User 
       NO-ERROR.
  IF AVAIL Dwb_Set_List_Param THEN 
  DO.
    ASSIGN V_Cod_Dwb_File   = Dwb_Set_list_Param.Cod_Dwb_File             
           V_Cod_Dwb_Output = Dwb_Set_list_Param.Cod_Dwb_Output           
           C-Impressora     = Dwb_Set_list_Param.nom_Dwb_Printer          
           C-Layout         = Dwb_Set_list_Param.Cod_Dwb_Print_layout
           i-mostra         = INTEGER(ENTRY(2,dwb_set_list_param.cod_dwb_parameters,chr(10)))
           c-arquivo-imp    = ENTRY(3,dwb_set_list_param.cod_dwb_parameters,chr(10)).

  END. /* End do IF AVAIL Ped_Exec_Param */
END. /* End do ELSE Do - IF V_Num_Ped_Exec_Corren > 0 */

DO.   /* seta a saida da impressao */
  CASE V_Cod_Dwb_Output:
    WHEN "Terminal" /*l_Terminal*/  THEN 
    DO.
      ASSIGN V_Cod_Dwb_File   = session:temp-directory + "esacr019.lst".
      OUTPUT STREAM Stream_1 TO VALUE(V_Cod_Dwb_File) PAGED PAGE-SIZE VALUE(V_Rpt_Stream_1_Lines) CONVERT TARGET 'iso8859-1'.
    END.
    WHEN "Impressora" /*l_Printer*/  THEN 
    DO.
      FIND Imprsor_Usuar NO-LOCK
          WHERE Imprsor_Usuar.Nom_Impressora = C-Impressora
            AND Imprsor_Usuar.Cod_Usuario    = V_Cod_Dwb_User
          USE-INDEX imprsrsr_id NO-ERROR.
      FIND layout_impres NO-LOCK
           WHERE Layout_Impres.Nom_Impressora    = C-Impressora
             AND Layout_Impres.Cod_Layout_Impres = C-Layout
           NO-ERROR.
      ASSIGN V_Rpt_Stream_1_Bottom = Layout_Impres.Num_Lin_Pag /* + V_Rpt_Stream_1_Bottom - V_Rpt_Stream_1_Lines */
             V_Rpt_Stream_1_Lines  = Layout_Impres.Num_Lin_Pag.

      IF OPSYS = "UNIX" THEN 
      DO.
        IF V_Num_Ped_Exec_Corren <> 0 THEN 
        DO.
          FIND Ped_Exec NO-LOCK
              WHERE Ped_Exec.num_Ped_Exec = V_Num_Ped_Exec_Corren NO-ERROR.
          IF AVAIL Ped_Exec THEN 
          DO.
            FIND Servid_Exec_Imprsor NO-LOCK
                 WHERE Servid_Exec_Imprsor.Cod_Servid_Exec = Ped_Exec.Cod_Servid_Exec
                   AND Servid_Exec_Imprsor.Nom_Impressora  = C-Impressora 
                 NO-ERROR.
            IF AVAIL Servid_Exec_Imprsor 
            THEN OUTPUT STREAM Stream_1 
                        THROUGH VALUE(Servid_Exec_Imprsor.Nom_Disposit_So)
                                PAGED 
                                PAGE-SIZE 
                                VALUE(V_Rpt_Stream_1_Lines) 
                                CONVERT TARGET 'iso8859-1'.
            ELSE OUTPUT STREAM Stream_1 
                        THROUGH VALUE(Imprsor_Usuar.Nom_Disposit_So)
                                PAGED 
                                PAGE-SIZE 
                                VALUE(V_Rpt_Stream_1_Lines) 
                                CONVERT TARGET 'iso8859-1'.
          END. /* End do - IF AVAIL ped_Exec */
        END. /* end do - IF V_Num_Ped_Exec_Corren <> 0 */
        ELSE OUTPUT STREAM Stream_1 
                    THROUGH VALUE(Imprsor_Usuar.Nom_Disposit_So)
                            PAGED 
                            PAGE-SIZE 
                            VALUE(V_Rpt_Stream_1_Lines) 
                            CONVERT TARGET 'iso8859-1'.
      END. /* End do - IF OPSYS = "UNIX" */
      ELSE OUTPUT STREAM Stream_1 TO VALUE(Imprsor_Usuar.Nom_Disposit_So)
                                           PAGED 
                                           PAGE-SIZE 
                                           VALUE(V_Rpt_Stream_1_Lines) 
                                           CONVERT TARGET 'iso8859-1'.
      FOR EACH Configur_Layout_Impres NO-LOCK
          WHERE Configur_Layout_Impres.Num_Id_Layout_Impres = Layout_Impres.Num_Id_Layout_Impres
             BY Configur_Layout_Impres.num_Ord_Funcao_imprsor.
        FIND Configur_Tip_imprsor NO-LOCK
             WHERE Configur_Tip_Imprsor.Cod_Tip_Imprsor        = Layout_Impres.Cod_Tip_Imprsor
               AND Configur_Tip_Imprsor.Cod_Funcao_Imprsor     = Configur_Layout_Impres.Cod_Funcao_Imprsor
               AND Configur_Tip_Imprsor.Cod_Opc_Funcao_Imprsor = Configur_Layout_Impres.Cod_Opc_Funcao_Imprsor
             NO-ERROR.
        PUT STREAM Stream_1 CONTROL Configur_Tip_Imprsor.Cod_Comando_Configur.
      END. /* End do - FOR EACH Configur_Layout_Impres NO-LOCK */
    END. /* End do - WHEN "Impressora" l_Printer */
    WHEN "Arquivo" /*l_File*/  THEN 
    DO.
      OUTPUT STREAM Stream_1 TO VALUE(V_Cod_Dwb_File)
                                      PAGED 
                                      PAGE-SIZE 
                                      VALUE(V_Rpt_Stream_1_Lines)
                                      CONVERT TARGET 'iso8859-1'.
    END. /* End do - WHEN "Arquivo" - l_File  */
  END. /* End do - CASE V_Cod_Dwb_Output */
END. /* End do - DO. -- Que seta a saida da impressao */
                                     
ASSIGN C-Programa          = "esacr019"
       C-Versao            = "1.00"
       C-Revisao           = "001"
       C-Titulo-Relat      = "Importaá∆o de Representantes"
       V_Rpt_Stream_1_Name = C-Titulo-Relat                        
       C-Sistema           = "ESP"
       Ch_Linha            = FILL("-",132).

ASSIGN V_Num_Pag = 1.

RUN pi-importa.
RUN pi-cria-tt.
RUN pi-roda-api.
RUN piImprimeRelat.  /* Imprime relat¢rio em formato padr∆o EMS 5 */ 

OUTPUT STREAM Stream_1 CLOSE.

IF V_Cod_Dwb_Output = "Terminal" 
THEN RUN pi-abre-edit (INPUT V_Cod_Dwb_File).

RETURN "ok".

/* fim do programa */

PROCEDURE piImprimeRelat:
    VIEW STREAM STREAM_1 FRAME f-cabec.
    VIEW STREAM STREAM_1 FRAME f-rodape.
    
    FOR EACH tt_retorno_clien_fornec:

        /* ** Mensagem de aviso indicando o sucesso da alteraá∆o ***/
        IF ttv_num_mensagem = 6279
        OR ttv_num_mensagem = 35940
           THEN NEXT.

        CREATE tt-cliente-erro.
        ASSIGN tt-cliente-erro.cdn_cliente  = IF NUM-ENTRIES(tt_retorno_clien_fornec.ttv_cod_parameters) > 2 THEN INTEGER(ENTRY(3,tt_retorno_clien_fornec.ttv_cod_parameters)) ELSE ttv_num_mensagem
               tt-cliente-erro.des_mensagem = tt_retorno_clien_fornec.ttv_des_mensagem.

    END.

    FOR EACH tt-cliente-erro:
        DISP STREAM Stream_1
             tt-cliente-erro.cdn_cliente 
             tt-cliente-erro.des_mensagem
             WITH FRAME f-erro.
        DOWN WITH FRAME f-erro.
    END.
    
    IF i-mostra = 2 THEN DO:

        PUT STREAM Stream_1 SKIP(1)
            "************** Alteraá‰es Efetivadas ***********" AT 01
            SKIP(1).

        FOR EACH tt-repres:
            FIND FIRST tt-cliente-erro
                WHERE tt-cliente-erro.cdn_cliente = tt-repres.cdn_cliente NO-ERROR.
            IF NOT AVAIL tt-cliente-erro THEN DO:
                DISP STREAM Stream_1
                     tt-repres.cdn_cliente
                     WITH FRAME f-acerto.
                DOWN WITH FRAME f-acerto.
            END.
        END.
    END.

END PROCEDURE.

PROCEDURE Pi-Abre-Edit:
  DEF INPUT PARAM P_Cod_Dwb_File AS CHAR FORM "x(40)" NO-UNDO.
  DEF VAR V_Cod_Key_Value        AS CHAR FORM "x(08)" NO-UNDO.

  GET-KEY-VALUE SECTION 'EMS' KEY 'Show-Report-Program' VALUE V_Cod_Key_Value.
  if V_Cod_Key_Value = "" OR 
     V_Cod_Key_Value = ?  THEN 
  DO.
    ASSIGN V_Cod_Key_Value = 'start'.
    PUT-KEY-VALUE SECTION 'EMS' KEY 'Show-Report-Program' VALUE V_Cod_Key_Value NO-ERROR.
  END. /* End do - if V_Cod_Key_Value = "" OR V_Cod_Key_Value = ? */

  OS-COMMAND SILENT VALUE(V_Cod_Key_Value + CHR(32) + P_Cod_Dwb_File).
END PROCEDURE.  /* End da Procedure Pi-Abre-Edit */

PROCEDURE pi-importa:

    INPUT FROM VALUE(c-arquivo-imp).
    REPEAT:
        IMPORT UNFORMATTED c-linha.
    
        ASSIGN c-linha   = REPLACE(c-linha,'"',"")
               c-cliente = INT(ENTRY(1,c-linha,';')) NO-ERROR.

        FIND emscad.cliente NO-LOCK
           WHERE cliente.cod_empresa = v_cod_empres_usuar
             AND cliente.cdn_cliente = c-cliente NO-ERROR.
        IF AVAIL cliente THEN DO:
            CREATE tt-repres.
            ASSIGN tt-repres.cdn_cliente = c-cliente
                   tt-repres.cdn_repres  = INT(ENTRY(2,c-linha,';')).
        END.
    END.
END PROCEDURE.

PROCEDURE pi-cria-tt:
    
    FOR EACH tt-repres:

        FIND emscad.cliente NO-LOCK
            WHERE cliente.cod_empresa  = v_cod_empres_usuar
              AND cliente.cdn_cliente  = tt-repres.cdn_cliente NO-ERROR.
        IF NOT AVAIL cliente 
           THEN NEXT.

        FIND clien_financ OF cliente NO-LOCK NO-ERROR.
        IF NOT AVAIL clien_financ 
           THEN NEXT.
        
        CREATE tt_cliente_integr_j. 
        ASSIGN tt_cliente_integr_j.tta_cod_empresa         = cliente.cod_empresa                
               tt_cliente_integr_j.tta_cdn_cliente         = cliente.cdn_cliente                
               tt_cliente_integr_j.tta_num_pessoa          = cliente.num_pessoa                 
               tt_cliente_integr_j.tta_nom_abrev           = cliente.nom_abrev                  
               tt_cliente_integr_j.tta_cod_grp_clien       = cliente.cod_grp_clien              
               tt_cliente_integr_j.tta_cod_tip_clien       = cliente.cod_tip_clien              
               tt_cliente_integr_j.tta_dat_impl_clien      = cliente.dat_impl_clien             
               tt_cliente_integr_j.tta_cod_pais_ext        = ""                                 
               tt_cliente_integr_j.tta_cod_pais            = cliente.cod_pais                   
               tt_cliente_integr_j.tta_cod_id_feder        = cliente.cod_id_feder               
               tt_cliente_integr_j.ttv_num_tip_operac      = 1                                  
               tt_cliente_integr_j.tta_log_ems_20_atlzdo   = NO.

        CREATE tt_clien_financ_integr_e.
        ASSIGN tt_clien_financ_integr_e.tta_cod_empresa                  = clien_financ.cod_empresa                                                   
               tt_clien_financ_integr_e.tta_cdn_cliente                  = clien_financ.cdn_cliente                                 
               tt_clien_financ_integr_e.tta_cdn_repres                   = tt-repres.cdn_repres                                  
               tt_clien_financ_integr_e.ttv_cod_portad_prefer_ext        = ""                                                       
               tt_clien_financ_integr_e.tta_cod_portad_ext               = ""                                                       
               tt_clien_financ_integr_e.ttv_cod_portad_prefer            = clien_financ.cod_portad_prefer                           
               tt_clien_financ_integr_e.tta_cod_portador                 = clien_financ.cod_portador                                
               tt_clien_financ_integr_e.tta_cod_cta_corren_bco           = clien_financ.cod_cta_corren_bco                          
               tt_clien_financ_integr_e.tta_cod_digito_cta_corren        = clien_financ.cod_digito_cta_corren                       
               tt_clien_financ_integr_e.tta_cod_agenc_bcia               = clien_financ.cod_agenc_bcia                              
               tt_clien_financ_integr_e.tta_cod_banco                    = clien_financ.cod_banco                                   
               tt_clien_financ_integr_e.tta_cod_classif_msg_cobr         = clien_financ.cod_classif_msg_cobr                        
               tt_clien_financ_integr_e.tta_cod_instruc_bcia_1_acr       = clien_financ.cod_instruc_bcia_1_acr                      
               tt_clien_financ_integr_e.tta_cod_instruc_bcia_2_acr       = clien_financ.cod_instruc_bcia_2_acr                      
               tt_clien_financ_integr_e.tta_log_habilit_emis_boleto      = clien_financ.log_habilit_emis_boleto                     
               tt_clien_financ_integr_e.tta_log_habilit_gera_avdeb       = clien_financ.log_habilit_gera_avdeb                      
               tt_clien_financ_integr_e.tta_log_retenc_impto             = clien_financ.log_retenc_impto                            
               tt_clien_financ_integr_e.tta_log_habilit_db_autom         = clien_financ.log_habilit_db_autom                        
               tt_clien_financ_integr_e.tta_num_tit_acr_aber             = clien_financ.num_tit_acr_aber                            
               tt_clien_financ_integr_e.tta_dat_ult_impl_tit_acr         = TODAY                                                    
               tt_clien_financ_integr_e.tta_dat_ult_liquidac_tit_acr     = TODAY                                                    
               tt_clien_financ_integr_e.tta_dat_maior_tit_acr            = TODAY                                                    
               tt_clien_financ_integr_e.tta_dat_maior_acum_tit_acr       = TODAY                                                    
               tt_clien_financ_integr_e.tta_val_ult_impl_tit_acr         = 0                                                        
               tt_clien_financ_integr_e.tta_val_maior_tit_acr            = 0                                                        
               tt_clien_financ_integr_e.tta_val_maior_acum_tit_acr       = 0                                                        
               tt_clien_financ_integr_e.tta_ind_sit_clien_perda_dedut    = clien_financ.ind_sit_clien_perda_dedut                   
               tt_clien_financ_integr_e.ttv_num_tip_operac               = 1 /* 1 - inclus∆o/modificaá∆o; 2 - eliminaá∆o */              
               tt_clien_financ_integr_e.tta_log_neces_acompto_spc        = NO                                                       
               tt_clien_financ_integr_e.tta_cod_tip_fluxo_financ         = IF clien_financ.cod_tip_fluxo_financ = "103" THEN "110" ELSE clien_financ.cod_tip_fluxo_financ
               tt_clien_financ_integr_e.tta_log_utiliz_verba             = clien_financ.log_utiliz_verba                            
               tt_clien_financ_integr_e.tta_val_perc_verba               = clien_financ.val_perc_verba                              
               tt_clien_financ_integr_e.tta_val_min_avdeb                = clien_financ.val_min_avdeb                               
               tt_clien_financ_integr_e.tta_log_calc_multa               = clien_financ.log_calc_multa                              
               tt_clien_financ_integr_e.tta_num_dias_atraso_avdeb        = clien_financ.num_dias_atraso_avdeb                       
               tt_clien_financ_integr_e.tta_cod_digito_agenc_bcia        = clien_financ.cod_digito_agenc_bcia                       
               tt_clien_financ_integr_e.tta_cod_cart_bcia                = clien_financ.cod_cart_bcia                               
               tt_clien_financ_integr_e.tta_cod_cart_bcia_prefer         = clien_financ.cod_cart_bcia_prefer.                       
    END.
END PROCEDURE.

PROCEDURE pi-roda-api:

    RUN prgint/utb/utb765zl.r PERSISTENT SET  h-handle (INPUT 1,
    		                                            INPUT "EMS",  /*Matriz de Traduá∆o Organizacional*/
                 		                                INPUT "1").   /*Empresa*/
    
    IF  VALID-HANDLE(h-handle) THEN DO:
        RUN pi_main_block_utb765zl_3 in  h-handle  (Input table tt_cliente_integr_j,
                                                    Input table tt_fornecedor_integr_k,
                                                    Input table tt_clien_financ_integr_e,
                                                    Input table tt_fornec_financ_integr_d,
                                                    Input table tt_pessoa_jurid_integr_j,
                                                    Input table tt_pessoa_fisic_integr_e,
                                                    Input table tt_contato_integr_e,
                                                    Input table tt_contat_clas_integr,
                                                    Input table tt_estrut_clien_integr,
                                                    Input table tt_estrut_fornec_integr,
                                                    Input table tt_histor_clien_integr,
                                                    Input table tt_histor_fornec_integr,
                                                    Input table tt_ender_entreg_integr_e,
                                                    Input table tt_telef_integr,
                                                    Input table tt_telef_pessoa_integr,
                                                    Input table tt_pj_ativid_integr_i,
                                                    Input table tt_pj_ramo_negoc_integr_j,
                                                    Input table tt_porte_pj_integr,
                                                    Input table tt_idiom_pf_integr,
                                                    Input table tt_idiom_contat_integr,
                                                    input-output table tt_retorno_clien_fornec,
                                                    Input table tt_clien_analis_cr_integr).
    
        DELETE PROCEDURE h-handle NO-ERROR.
    END.
END PROCEDURE.

IF I-Num-Ped-Exec-Rpw <> 0 
THEN RETURN "OK".
