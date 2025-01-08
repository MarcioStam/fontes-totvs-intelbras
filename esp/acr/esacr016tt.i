/* Temp-table 1:  conter  as informa‡äes dos clientes: */

def temp-table tt_cliente_integr no-undo 
    field tta_cod_empresa                  as character format "x(3)"  label "Empresa" column-label "Empresa" 
    field tta_cdn_cliente                  as Integer format ">>>,>>>,>>9" initial 0 label "Cliente" column-label "Cliente" 
    field tta_num_pessoa                   as integer format ">>>,>>>,>>9" initial ? label "Pessoa" column-label "Pessoa" 
    field tta_nom_abrev                    as character format "x(15)" label "Nome Abreviado" column-label "Nome Abreviado" 
    field tta_cod_grp_clien                as character format "x(4)"  label "Grupo Cliente" column-label "Grupo Cliente" 
    field tta_cod_tip_clien                as character format "x(8)"  label "Tipo Cliente" column-label "Tipo Cliente" 
    field tta_dat_impl_clien               as date format "99/99/9999" initial ? label "Implanta‡Æo Cliente" column-label "Implanta‡Æo Cliente" 
    field tta_cod_pais_ext                 as character format "x(20)" label "Pa¡s Externo" column-label "Pa¡s Externo" 
    field tta_cod_pais                     as character format "x(3)"  label "Pa¡s" column-label "Pa¡s" 
    field tta_cod_id_feder                 as character format "x(20)" initial ? label "ID Federal" column-label "ID Federal" 
    field ttv_ind_pessoa                   as character format "X(08)" initial "Jur¡dica" label "Tipo Pessoa" column-label "Tipo Pessoa" 
    field ttv_num_tip_operac               as integer format ">9" 
    field tta_log_ems_20_atlzdo            as logical format "Sim/NÆo" initial no label "2.0 Atualizado" column-label "2.0 Atualizado" 
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

/* Temp-table 2:  conter  as informa‡äes dos fornecedores: */

def temp-table tt_fornecedor_integr no-undo 
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa" 
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor" 
    field tta_num_pessoa                   as integer format ">>>,>>>,>>9" initial ? label "Pessoa" column-label "Pessoa" 
    field tta_nom_abrev                    as character format "x(15)" label "Nome Abreviado" column-label "Nome Abreviado" 
    field tta_cod_grp_fornec               as character format "x(4)" label "Grupo Fornecedor" column-label "Grp Fornec" 
    field tta_cod_tip_fornec               as character format "x(8)" label "Tipo Fornecedor" column-label "Tipo Fornec" 
    field tta_dat_impl_fornec              as date format "99/99/9999" initial today label "Data Implanta‡Æo" column-label "Data Implanta‡Æo" 
    field tta_cod_pais_ext                 as character format "x(20)" label "Pa¡s Externo" column-label "Pa¡s Externo" 
    field tta_cod_pais                     as character format "x(3)" label "Pa¡s" column-label "Pa¡s" 
    field tta_cod_id_feder                 as character format "x(20)" initial ? label "ID Federal" column-label "ID Federal" 
    field ttv_ind_pessoa                   as character format "X(08)" initial "Jur¡dica" label "Tipo Pessoa" column-label "Tipo Pessoa" 
    field tta_log_ems_20_atlzdo            as logical format "Sim/NÆo" initial no label "2.0 Atualizado" column-label "2.0 Atualizado" 
    field ttv_num_tip_operac               as integer format ">9" 
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

/* Temp-table 3:  conter  as informa‡äes dos clientes financeiros: */

def temp-table tt_clien_financ_integr_e no-undo
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cdn_cliente                  as Integer format ">>>,>>>,>>9" initial 0 label "Cliente" column-label "Cliente"
    field tta_cdn_repres                   as Integer format ">>>,>>9" initial 0 label "Representante" column-label "Representante"
    field ttv_cod_portad_prefer_ext        as character format "x(8)" label "Portad Prefer" column-label "Portad Prefer"
    field tta_cod_portad_ext               as character format "x(8)" label "Portador Externo" column-label "Portador Externo"
    field ttv_cod_portad_prefer            as character format "x(5)" label "Portador Preferenc" column-label "Port Preferenc"
    field tta_cod_portador                 as character format "x(5)" label "Portador" column-label "Portador"
    field tta_cod_cta_corren_bco           as character format "x(20)" label "Conta Corrente Banco" column-label "Conta Corrente Banco"
    field tta_cod_digito_cta_corren        as character format "x(2)" label "D¡gito Cta Corrente" column-label "D¡gito Cta Corrente"
    field tta_cod_agenc_bcia               as character format "x(10)" label "Agˆncia Banc ria" column-label "Ag¼ncia Banc ria"
    field tta_cod_banco                    as character format "x(8)" label "Banco" column-label "Banco"
    field tta_cod_classif_msg_cobr         as character format "x(8)" label "Classif Msg Cobr" column-label "Classif Msg Cobr"
    field tta_cod_instruc_bcia_1_acr       as character format "x(4)" label "Instru‡Æo Bcia 1" column-label "Instru‡Æo 1"
    field tta_cod_instruc_bcia_2_acr       as character format "x(4)" label "Instru‡Æo Bcia 2" column-label "Instru‡Æo 2"
    field tta_log_habilit_emis_boleto      as logical format "Sim/N’o" initial no label "Emitir Boleto" column-label "Emitir Boleto"
    field tta_log_habilit_gera_avdeb       as logical format "Sim/N’o" initial no label "Gerar AD" column-label "Gerar AD"
    field tta_log_retenc_impto             as logical format "Sim/N’o" initial no label "Ret²m Imposto" column-label "Ret²m Imposto"
    field tta_log_habilit_db_autom         as logical format "Sim/N’o" initial no label "D²bito Auto" column-label "D²bito Auto"
    field tta_num_tit_acr_aber             as integer format ">>>>,>>9" initial 0 label "Quant Tit  Aberto" column-label "Qtd Tit Abert"
    field tta_dat_ult_impl_tit_acr         as date format "99/99/9999" initial ? label "‚ltima Implanta‡Æo" column-label "‚ltima Implanta‡Æo"
    field tta_dat_ult_liquidac_tit_acr     as date format "99/99/9999" initial ? label "Ultima Liquida‡Æo" column-label "Ultima Liquida‡Æo"
    field tta_dat_maior_tit_acr            as date format "99/99/9999" initial ? label "Data Maior T¡tulo" column-label "Data Maior T¡tulo"
    field tta_dat_maior_acum_tit_acr       as date format "99/99/9999" initial ? label "Data Maior Acum" column-label "Data Maior Acum"
    field tta_val_ult_impl_tit_acr         as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Ultimo Tit" column-label "Valor Ultimo Tit"
    field tta_val_maior_tit_acr            as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Maior T¡tulo" column-label "Vl Maior T¡tulo"
    field tta_val_maior_acum_tit_acr       as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Maior Acœmulo" column-label "Vl Maior Acœmulo"
    field tta_ind_sit_clien_perda_dedut    as character format "X(21)" initial "Normal" label "Situa‡Æo Cliente" column-label "Sit Cliente"
    field ttv_num_tip_operac               as integer format ">9"
    field tta_log_neces_acompto_spc        as logical format "Sim/N’o" initial no label "Neces Acomp SPC" column-label "Neces Acomp SPC"
    field tta_cod_tip_fluxo_financ         as character format "x(12)" label "Tipo Fluxo Financ" column-label "Tipo Fluxo Financ"
    field tta_log_utiliz_verba             as logical format "Sim/N’o" initial no label "Utiliza Verba de Pub" column-label "Utiliza Verba de Pub"
    field tta_val_perc_verba               as decimal format ">>>9.99" decimals 2 initial 0 label "Percentual Verba de" column-label "Percentual Verba de"
    field tta_val_min_avdeb                as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Valor M¡nimo" column-label "Valor M¡nimo"
    field tta_log_calc_multa               as logical format "Sim/N’o" initial no label "Calcula Multa" column-label "Calcula Multa"
    field tta_num_dias_atraso_avdeb        as integer format "999" initial 0 label "Dias Atraso" column-label "Dias Atraso"
    field tta_cod_digito_agenc_bcia        as character format "x(2)" label "D¡gito Ag Bcia" column-label "Dig Ag"
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

/* Temp-table 4:  conter  as informa‡äes dos fornecedores financeiros: */ 

def temp-table tt_fornec_financ_integr_d no-undo 
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa" 
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor" 
    field tta_cod_portad_ext               as character format "x(8)" label "Portador Externo" column-label "Portador Externo" 
    field tta_cod_portador                 as character format "x(5)" label "Portador" column-label "Portador" 
    field tta_cod_cta_corren_bco           as character format "x(20)" label "Conta Corrente Banco" column-label "Conta Corrente Banco" 
    field tta_cod_digito_cta_corren        as character format "x(2)" label "D¡gito Cta Corrente" column-label "D¡gito Cta Corrente" 
    field tta_cod_agenc_bcia               as character format "x(10)" label "Ag¼ncia Banc ria" column-label "Ag¼ncia Banc ria" 
    field tta_cod_digito_agenc_bcia        as character format "x(2)" label "D¡gito Ag Bcia" column-label "Dig Ag" 
    field tta_cod_banco                    as character format "x(8)" label "Banco" column-label "Banco" 
    field tta_cod_forma_pagto              as character format "x(3)" label "Forma Pagamento" column-label "F Pagto" 
    field tta_cod_tip_fluxo_financ         as character format "x(12)" label "Tipo Fluxo Financ" column-label "Tipo Fluxo Financ" 
    field tta_ind_tratam_vencto_sab        as character format "X(08)" initial "Prorroga" label "Vencimento Sabado" column-label "Vencto Sab" 
    field tta_ind_tratam_vencto_dom        as character format "X(08)" initial "Prorroga" label "Vencimento Domingo" column-label "Vencto Dom" 
    field tta_ind_tratam_vencto_fer        as character format "X(08)" initial "Prorroga" label "Vencimento Feriado" column-label "Vencto Feriado" 
    field tta_ind_pagto_juros_fornec_ap    as character format "X(08)" label "Juros" column-label "Juros" 
    field tta_ind_tip_fornecto             as character format "X(08)" label "Tipo Fornecimento" column-label "Fornecto" 
    field tta_ind_armaz_val_pagto          as character format "X(12)" initial "N’o Armazena" label "Armazena Valor Pagto" column-label "Armazena Valor Pagto" 
    field tta_log_fornec_serv_export       as logical format "Sim/N’o" initial no label "Fornec Exporta‡Æo" column-label "Fornec Export" 
    field tta_log_pagto_bloqdo             as logical format "Sim/N’o" initial no label "Bloqueia Pagamento" column-label "Pagto Bloqdo" 
    field tta_log_retenc_impto             as logical format "Sim/N’o" initial no label "Ret²m Imposto" column-label "Ret²m Imposto" 
    field tta_dat_ult_impl_tit_ap          as date format "99/99/9999" initial ? label "Data Ultima Impl" column-label "Dt Ult Impl" 
    field tta_dat_ult_pagto                as date format "99/99/9999" initial ? label "Data ‚ltimo Pagto" column-label "Data ‚ltimo Pagto" 
    field tta_dat_impl_maior_tit_ap        as date format "99/99/9999" initial ? label "Dt Impl Maior Tit" column-label "Dt Maior Tit" 
    field tta_num_antecip_aber             as integer format ">>>>9" initial 0 label "Quant Antec  Aberto" column-label "Qtd Antec" 
    field tta_num_tit_ap_aber              as integer format ">>>>9" initial 0 label "Quant Tit  Aberto" column-label "Qtd Tit Abert" 
    field tta_val_tit_ap_maior_val         as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Maior Tit Impl" column-label "Valor Maior T¡tulo" 
    field tta_val_tit_ap_maior_val_aber    as decimal format "->>>>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Maior Tit  Aberto" column-label "Maior Vl Aberto" 
    field tta_val_sdo_antecip_aber         as decimal format ">>>>>,>>>,>>9.99" decimals 2 initial 0 label "Saldo Antec Aberto" column-label "Sdo Antecip Aberto" 
    field tta_val_sdo_tit_ap_aber          as decimal format "->>>>>,>>>,>>9.99" decimals 2 initial 0 label "Saldo Tit   Aberto" column-label "Sdo Tit Aberto" 
    field ttv_num_tip_operac               as integer format ">9" 
    field tta_cod_livre_1                  as character format "x(100)" label "Livre 1" column-label "Livre 1" 
    field tta_num_rendto_tribut            as integer format ">>9" initial 0 label "Rendto Tribut vel" column-label "Rendto Tribut vel" 
    field tta_log_vencto_dia_nao_util      as logical format "Sim/N’o" initial no label "Vencto Igual Dt Flx" column-label "Vencto Igual Dt Flx" 
    field tta_val_percent_bonif            as decimal format ">>9.99" decimals 2 initial 0 label "Perc Bonifica‡Æo" column-label "Perc Bonifica‡Æo" 
    field tta_log_indic_rendto             as logical format "Sim/N’o" initial no label "Ind Rendimento" column-label "Ind Rendimento" 
    field tta_num_dias_compcao             as integer format ">>9" initial 0 label "Dias Compensa‡Æo" column-label "Dias Compensa‡Æo" 
    index tt_frncfnnc_forma_pagto          
          tta_cod_forma_pagto              ascending 
    index tt_frncfnnc_id                   is primary unique 
          tta_cod_empresa                  ascending 
          tta_cdn_fornecedor               ascending 
    index tt_frncfnnc_portador             
          tta_cod_portad_ext               ascending.

/* Temp-table 5:  conter  as informa‡äes das pessoas jur¡dicas: */

def temp-table tt_pessoa_jurid_integr_e no-undo
    field tta_num_pessoa_jurid             as integer format ">>>,>>>,>>9" initial 0 label "Pessoa Jur¡dica" column-label "Pessoa Jur¡dica"
    field tta_nom_pessoa                   as character format "x(40)" label "Nome" column-label "Nome"
    field tta_cod_id_feder                 as character format "x(20)" initial ? label "ID Federal" column-label "ID Federal"
    field tta_cod_id_estad_jurid           as character format "x(20)" initial ? label "ID Estadual" column-label "ID Estadual"
    field tta_cod_id_munic_jurid           as character format "x(20)" initial ? label "ID Municipal" column-label "ID Municipal"
    field tta_cod_id_previd_social         as character format "x(20)" label "Id Previd¼ncia" column-label "Id Previd¼ncia"
    field tta_log_fins_lucrat              as logical format "Sim/N’o" initial yes label "Fins Lucrativos" column-label "Fins Lucrativos"
    field tta_num_pessoa_jurid_matriz      as integer format ">>>,>>>,>>9" initial 0 label "Matriz" column-label "Matriz"
    field tta_nom_endereco                 as character format "x(40)" label "Endere‡o" column-label "Endere‡o"
    field tta_nom_ender_compl              as character format "x(10)" label "Complemento" column-label "Complemento"
    field tta_nom_bairro                   as character format "x(20)" label "Bairro" column-label "Bairro"
    field tta_nom_cidade                   as character format "x(32)" label "Cidade" column-label "Cidade"
    field tta_nom_condado                  as character format "x(32)" label "Condado" column-label "Condado"
    field tta_cod_pais_ext                 as character format "x(20)" label "Pa¡s Externo" column-label "Pa¡s Externo"
    field tta_cod_pais                     as character format "x(3)" label "Pa¡s" column-label "Pa¡s"
    field tta_cod_unid_federac             as character format "x(3)" label "Unidade Federa‡Æo" column-label "UF"
    field tta_cod_cep                      as character format "x(20)" label "CEP" column-label "CEP"
    field tta_cod_cx_post                  as character format "x(20)" label "Caixa Postal" column-label "Caixa Postal"
    field tta_cod_telefone                 as character format "x(20)" label "Telefone" column-label "Telefone"
    field tta_cod_fax                      as character format "x(20)" label "FAX" column-label "FAX"
    field tta_cod_ramal_fax                as character format "x(07)" label "Ramal Fax" column-label "Ramal Fax"
    field tta_cod_telex                    as character format "x(7)" label "TELEX" column-label "TELEX"
    field tta_cod_modem                    as character format "x(20)" label "Modem" column-label "Modem"
    field tta_cod_ramal_modem              as character format "x(07)" label "Ramal Modem" column-label "Ramal Modem"
    field tta_cod_e_mail                   as character format "x(40)" label "Internet E-Mail" column-label "Internet E-Mail"
    field tta_des_anot_tab                 as character format "x(2000)" label "Anota‡Æo Tabela" column-label "Anota‡Æo Tabela"
    field tta_ind_tip_pessoa_jurid         as character format "X(08)" label "Tipo Pessoa" column-label "Tipo Pessoa"
    field tta_ind_tip_capit_pessoa_jurid   as character format "X(13)" label "Tipo Capital" column-label "Tipo Capital"
    field tta_cod_imagem                   as character format "x(30)" label "Imagem" column-label "Imagem"
    field tta_log_ems_20_atlzdo            as logical format "Sim/N’o" initial no label "2.0 Atualizado" column-label "2.0 Atualizado"
    field ttv_num_tip_operac               as integer format ">9"
    field tta_num_pessoa_jurid_cobr        as integer format ">>>,>>>,>>9" initial 0 label "Pessoa Jur¡dica Cobr" column-label "Pessoa Jur¡dica Cobr"
    field tta_nom_ender_cobr               as character format "x(40)" label "Endere‡o Cobran‡a" column-label "Endere‡o Cobran‡a"
    field tta_nom_ender_compl_cobr         as character format "x(10)" label "Complemento" column-label "Complemento"
    field tta_nom_bairro_cobr              as character format "x(20)" label "Bairro Cobran‡a" column-label "Bairro Cobran‡a"
    field tta_nom_cidad_cobr               as character format "x(32)" label "Cidade Cobran‡a" column-label "Cidade Cobran‡a"
    field tta_nom_condad_cobr              as character format "x(32)" label "Condado Cobran‡a" column-label "Condado Cobran‡a"
    field tta_cod_unid_federac_cobr        as character format "x(3)" label "Unidade Federa‡Æo" column-label "Unidade Federa‡Æo"
    field ttv_cod_pais_ext_cob             as character format "x(20)" label "Pa¡s Externo" column-label "Pa¡s Externo"
    field ttv_cod_pais_cobr                as character format "x(3)" label "Pa¡s Cobran‡a" column-label "Pa¡s Cobran‡a"
    field tta_cod_cep_cobr                 as character format "x(20)" label "CEP Cobran‡a" column-label "CEP Cobran‡a"
    field tta_cod_cx_post_cobr             as character format "x(20)" label "Caixa Postal Cobran‡" column-label "Caixa Postal Cobran‡"
    field tta_num_pessoa_jurid_pagto       as integer format ">>>,>>>,>>9" initial 0 label "Pessoa Jurid Pagto" column-label "Pessoa Jurid Pagto"
    field tta_nom_ender_pagto              as character format "x(40)" label "Endere‡o Pagamento" column-label "Endere‡o Pagamento"
    field tta_nom_ender_compl_pagto        as character format "x(10)" label "Complemento" column-label "Complemento"
    field tta_nom_bairro_pagto             as character format "x(20)" label "Bairro Pagamento" column-label "Bairro Pagamento"
    field tta_nom_cidad_pagto              as character format "x(32)" label "Cidade Pagamento" column-label "Cidade Pagamento"
    field tta_nom_condad_pagto             as character format "x(32)" label "Condado Pagamento" column-label "Condado Pagamento"
    field tta_cod_unid_federac_pagto       as character format "x(3)" label "Unidade Federa‡Æo" column-label "Unidade Federa‡Æo"
    field ttv_cod_pais_ext_pag             as character format "x(20)" label "Pa¡s Externo" column-label "Pa¡s Externo"
    field ttv_cod_pais_pagto               as character format "x(3)" label "Pa¡s Pagamento" column-label "Pa¡s Pagamento"
    field tta_cod_cep_pagto                as character format "x(20)" label "CEP Pagamento" column-label "CEP Pagamento"
    field tta_cod_cx_post_pagto            as character format "x(20)" label "Caixa Postal Pagamen" column-label "Caixa Postal Pagamen"
    field ttv_rec_fiador_renegoc           as recid format ">>>>>>9" initial ?
    field ttv_log_altera_razao_social      as logical format "Sim/N’o" initial no label "Altera Raz’o Social" column-label "Altera Raz’o Social"
    field tta_nom_home_page                as character format "x(40)" label "Home Page" column-label "Home Page"
    field tta_nom_ender_text               as character format "x(2000)" label "Endereco Compl." column-label "Endereco Compl."
    field tta_nom_ender_cobr_text          as character format "x(2000)" label "End Cobranca Compl" column-label "End Cobranca Compl"
    field tta_nom_ender_pagto_text         as character format "x(2000)" label "End Pagto Compl." column-label "End Pagto Compl."
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

/* Temp-table 6:  conter  as informa‡äes das pessoas f¡sicas: */

def temp-table tt_pessoa_fisic_integr_e no-undo
    field tta_num_pessoa_fisic             as integer format ">>>,>>>,>>9" initial 0 label "Pessoa F¡sica" column-label "Pessoa F¡sica"
    field tta_nom_pessoa                   as character format "x(40)" label "Nome" column-label "Nome"
    field tta_cod_id_feder                 as character format "x(20)" initial ? label "ID Federal" column-label "ID Federal"
    field tta_cod_id_estad_fisic           as character format "x(20)" initial ? label "ID Estadual F¡sica" column-label "ID Estadual F¡sica"
    field tta_cod_orgao_emis_id_estad      as character format "x(10)" label "…rg’o Emissor" column-label "…rg’o Emissor"
    field tta_cod_unid_federac_emis_estad  as character format "x(3)" label "Estado Emiss’o" column-label "UF Emis"
    field tta_nom_endereco                 as character format "x(40)" label "Endere‡o" column-label "Endere‡o"
    field tta_nom_ender_compl              as character format "x(10)" label "Complemento" column-label "Complemento"
    field tta_nom_bairro                   as character format "x(20)" label "Bairro" column-label "Bairro"
    field tta_nom_cidade                   as character format "x(32)" label "Cidade" column-label "Cidade"
    field tta_nom_condado                  as character format "x(32)" label "Condado" column-label "Condado"
    field tta_cod_pais_ext                 as character format "x(20)" label "Pa¡s Externo" column-label "Pa¡s Externo"
    field tta_cod_pais                     as character format "x(3)" label "Pa¡s" column-label "Pa¡s"
    field tta_cod_unid_federac             as character format "x(3)" label "Unidade Federa‡Æo" column-label "UF"
    field tta_cod_cep                      as character format "x(20)" label "CEP" column-label "CEP"
    field tta_cod_cx_post                  as character format "x(20)" label "Caixa Postal" column-label "Caixa Postal"
    field tta_cod_telefone                 as character format "x(20)" label "Telefone" column-label "Telefone"
    field tta_cod_ramal                    as character format "x(7)" label "Ramal" column-label "Ramal"
    field tta_cod_fax                      as character format "x(20)" label "FAX" column-label "FAX"
    field tta_cod_ramal_fax                as character format "x(07)" label "Ramal Fax" column-label "Ramal Fax"
    field tta_cod_telex                    as character format "x(7)" label "TELEX" column-label "TELEX"
    field tta_cod_modem                    as character format "x(20)" label "Modem" column-label "Modem"
    field tta_cod_ramal_modem              as character format "x(07)" label "Ramal Modem" column-label "Ramal Modem"
    field tta_cod_e_mail                   as character format "x(40)" label "Internet E-Mail" column-label "Internet E-Mail"
    field tta_dat_nasc_pessoa_fisic        as date format "99/99/9999" initial ? label "Nascimento" column-label "Data Nasc"
    field ttv_cod_pais_ext_nasc            as character format "x(20)" label "Pa¡s Ext Nascimento" column-label "Pa¡s Ext Nascimento"
    field ttv_cod_pais_nasc                as character format "x(3)" label "Pa¡s Nascimento" column-label "Pa¡s Nasc"
    field tta_cod_unid_federac_nasc        as character format "x(3)" label "Estado Nascimento" column-label "UF Nasc"
    field tta_des_anot_tab                 as character format "x(2000)" label "Anota‡Æo Tabela" column-label "Anota‡Æo Tabela"
    field tta_nom_mae_pessoa               as character format "x(40)" label "M’e Pessoa" column-label "M’e Pes"
    field tta_cod_imagem                   as character format "x(30)" label "Imagem" column-label "Imagem"
    field tta_log_ems_20_atlzdo            as logical format "Sim/N’o" initial no label "2.0 Atualizado" column-label "2.0 Atualizado"
    field ttv_num_tip_operac               as integer format ">9"
    field ttv_rec_fiador_renegoc           as recid format ">>>>>>9" initial ?
    field ttv_log_altera_razao_social      as logical format "Sim/N’o" initial no label "Altera Raz’o Social" column-label "Altera Raz’o Social"
    field tta_nom_nacion_pessoa_fisic      as character format "x(40)" label "Nacionalidade" column-label "Nacionalidade"
    field tta_nom_profis_pessoa_fisic      as character format "x(40)" label "Profiss’o" column-label "Profiss’o"
    field tta_ind_estado_civil_pessoa      as character format "X(10)" initial "Solteiro" label "Estado Civil" column-label "Estad Civ Pes"
    field tta_nom_home_page                as character format "x(40)" label "Home Page" column-label "Home Page"
    field tta_nom_ender_text               as character format "x(2000)" label "Endereco Compl." column-label "Endereco Compl."
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

/* Temp-table 7:  conter  as informa‡äes dos contatos: */

def temp-table tt_contato_integr_e no-undo
    field tta_num_pessoa_jurid             as integer format ">>>,>>>,>>9" initial 0 label "Pessoa Jur¡dica" column-label "Pessoa Jur¡dica"
    field tta_nom_abrev_contat             as character format "x(15)" label "Abreviado Contato" column-label "Abreviado Contato"
    field tta_nom_pessoa                   as character format "x(40)" label "Nome" column-label "Nome"
    field tta_cod_telef_contat             as character format "x(20)" label "Telefone" column-label "Telefone"
    field tta_cod_ramal_contat             as character format "x(07)" label "Ramal" column-label "Ramal"
    field tta_cod_fax_contat               as character format "x(20)" label "Fax" column-label "Fax"
    field tta_cod_ramal_fax_contat         as character format "x(07)" label "Ramal Fax" column-label "Ramal Fax"
    field tta_cod_modem_contat             as character format "x(20)" label "Modem" column-label "Modem"
    field tta_cod_ramal_modem_contat       as character format "x(07)" label "Ramal Modem" column-label "Ramal Modem"
    field tta_cod_e_mail_contat            as character format "x(40)" label "Internet E-Mail" column-label "Internet E-Mail"
    field tta_des_anot_tab                 as character format "x(2000)" label "Anota‡Æo Tabela" column-label "Anota‡Æo Tabela"
    field tta_num_pessoa_fisic             as integer format ">>>,>>>,>>9" initial 0 label "Pessoa F¡sica" column-label "Pessoa F¡sica"
    field tta_ind_priorid_envio_docto      as character format "x(10)" initial "e-Mail/Fax" label "Prioridade Envio" column-label "Prioridade Envio"
    field tta_cdn_cliente                  as Integer format ">>>,>>>,>>9" initial 0 label "Cliente" column-label "Cliente"
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field tta_log_ems_20_atlzdo            as logical format "Sim/N’o" initial no label "2.0 Atualizado" column-label "2.0 Atualizado"
    field ttv_num_tip_operac               as integer format ">9"
    field tta_nom_endereco                 as character format "x(40)" label "Endere‡o" column-label "Endere‡o"
    field tta_nom_ender_compl              as character format "x(10)" label "Complemento" column-label "Complemento"
    field tta_nom_bairro                   as character format "x(20)" label "Bairro" column-label "Bairro"
    field tta_nom_cidade                   as character format "x(32)" label "Cidade" column-label "Cidade"
    field tta_nom_condado                  as character format "x(32)" label "Condado" column-label "Condado"
    field tta_cod_pais                     as character format "x(3)" label "Pa¡s" column-label "Pa¡s"
    field tta_cod_cx_post                  as character format "x(20)" label "Caixa Postal" column-label "Caixa Postal"
    field tta_cod_unid_federac             as character format "x(3)" label "Unidade Federa‡Æo" column-label "UF"
    field tta_cod_cep_cobr                 as character format "x(20)" label "CEP Cobran‡a" column-label "CEP Cobran‡a"
    field tta_nom_ender_text               as character format "x(2000)" label "Endereco Compl." column-label "Endereco Compl."
    index tt_contato_id                    is primary unique
          tta_num_pessoa_jurid             ascending
          tta_nom_abrev_contat             ascending
          tta_cdn_cliente                  ascending
          tta_cdn_fornecedor               ascending
    index tt_contato_pssfsca              
          tta_num_pessoa_fisic             ascending.

/* Temp-table 8:  conter  as informa‡äes das classes de contatos: */

def temp-table tt_contat_clas_integr no-undo 
    field tta_num_pessoa_jurid             as integer format ">>>,>>>,>>9" initial 0 label "Pessoa Jur¡dica" column-label "Pessoa Jur¡dica" 
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

/* Temp-table 9:  conter  as informa‡äes das estruturas de clientes: */

def temp-table tt_estrut_clien_integr no-undo 
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa" 
    field tta_cdn_clien_pai                as Integer format ">>>,>>>,>>9" initial 0 label "Cliente Pai" column-label "Cliente Pai" 
    field tta_cdn_clien_filho              as Integer format ">>>,>>>,>>9" initial 0 label "Cliente Filho" column-label "Cliente Filho" 
    field tta_log_dados_financ_tip_pai     as logical format "Sim/NÆo" initial no label "Armazena Valor" column-label "Armazena Valor" 
    field tta_num_seq_estrut_clien         as integer format ">>>,>>9" initial 0 label "Sequˆncia" column-label "Sequˆncia" 
    field ttv_num_tip_operac               as integer format ">9" 
    index tt_estrtcln_clien_filho          
          tta_cod_empresa                  ascending 
          tta_cdn_clien_filho              ascending 
    index tt_estrtcln_id                   is primary unique 
          tta_cod_empresa                  ascending 
          tta_cdn_clien_pai                ascending 
          tta_cdn_clien_filho              ascending 
          tta_num_seq_estrut_clien         ascending.

/* Temp-table 10:  conter  as informa‡äes das estruturas de fornecedores: */

def temp-table tt_estrut_fornec_integr no-undo 
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa" 
    field tta_cdn_fornec_pai               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor Pai" column-label "Fornecedor Pai" 
    field tta_cdn_fornec_filho             as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor Filho" column-label "Fornecedor Filho" 
    field tta_log_dados_financ_tip_pai     as logical format "Sim/NÆo" initial no label "Armazena Valor" column-label "Armazena Valor" 
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

/* Temp-table 11:  conter  as informa‡äes dos hist¢ricos de clientes: */

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

/* Temp-table 12:  conter  as informa‡äes dos hist¢ricos de fornecedores: */

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

/* Temp-table 13:  conter  as informa‡äes dos endere‡os de entrega: */

def temp-table tt_ender_entreg_integr_e no-undo
    field tta_num_pessoa_jurid             as integer format ">>>,>>>,>>9" initial 0 label "Pessoa Jur¡dica" column-label "Pessoa Jur¡dica"
    field tta_cod_ender_entreg             as character format "x(15)" label "Endere‡o Entrega" column-label "Endere‡o Entrega"
    field tta_nom_ender_entreg             as character format "x(40)" label "Nome Endere‡o Entreg" column-label "Nome Endere‡o Entreg"
    field tta_nom_bairro_entreg            as character format "x(20)" label "Bairro Entrega" column-label "Bairro Entrega"
    field tta_nom_cidad_entreg             as character format "x(32)" label "Cidade Entrega" column-label "Cidade Entrega"
    field tta_nom_condad_entreg            as character format "x(30)" label "Condado Entrega" column-label "Condado Entrega"
    field tta_cod_pais_ext                 as character format "x(20)" label "Pa¡s Externo" column-label "Pa¡s Externo"
    field tta_cod_pais                     as character format "x(3)" label "Pa¡s" column-label "Pa¡s"
    field tta_cod_unid_federac_entreg      as character format "x(3)" label "Unidade Federa‡Æo" column-label "Unidade Federa‡Æo"
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

/* Temp-table 14:  conter  as informa‡äes dos telefones: */

def temp-table tt_telef_integr no-undo 
    field tta_cod_telef_sem_edic           as character format "x(20)" label "Telefone" column-label "Telefone" 
    field tta_ind_tip_telef_pessoa         as character format "X(08)" label "Tipo Telefone" column-label "Tipo Telefone" 
    field ttv_num_tip_operac               as integer format ">9" 
    index tt_telef_id                      is primary 
          tta_cod_telef_sem_edic           ascending. 


/* Temp-table 15:  conter  as informa‡äes dos telefones das pessoas: */

def temp-table tt_telef_pessoa_integr no-undo 
    field tta_cod_telef_sem_edic           as character format "x(20)" label "Telefone" column-label "Telefone" 
    field tta_num_pessoa                   as integer format ">>>,>>>,>>9" initial ? label "Pessoa" column-label "Pessoa" 
    field tta_des_telefone                 as character format "x(40)" label "Descri‡Æo Telefone" column-label "Descri‡Æo Telefone" 
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

/* Temp-table 16:  conter  as informa‡äes dos atividades das pessoas jur¡dicas: */

def temp-table tt_pj_ativid_integr no-undo 
    field tta_num_pessoa_jurid             as integer format ">>>,>>>,>>9" initial 0 label "Pessoa Jur¡dica" column-label "Pessoa Jur¡dica" 
    field tta_cod_ativid_pessoa_jurid      as character format "x(8)" label "Atividade" column-label "Atividade" 
    field tta_log_ativid_pessoa_princ      as logical format "Sim/NÆo" initial no label "Atividade Principal" column-label "Principal" 
    field ttv_num_tip_operac               as integer format ">9" 
    index tt_pssjrdtv_atividade            
          tta_cod_ativid_pessoa_jurid      ascending 
    index tt_pssjrdtv_id                   is primary unique 
          tta_num_pessoa_jurid             ascending 
          tta_cod_ativid_pessoa_jurid      ascending. 

/* Temp-table 17:  conter  as informa‡äes dos ramos de neg¢cio das pessoa jur¡dicas: */

def temp-table tt_pj_ramo_negoc_integr no-undo 
    field tta_num_pessoa_jurid             as integer format ">>>,>>>,>>9" initial 0 label "Pessoa Jur¡dica" column-label "Pessoa Jur¡dica" 
    field tta_cod_ramo_negoc               as character format "x(8)" label "Ramo Neg¢cio" column-label "Ramo Neg¢cio" 
    field tta_log_ramo_negoc_princ         as logical format "Sim/NÆo" initial no label "Ramo Negoc Principal" column-label "Principal" 
    field ttv_num_tip_operac               as integer format ">9" 
    index tt_pssjrdm_id                    is primary unique 
          tta_num_pessoa_jurid             ascending 
          tta_cod_ramo_negoc               ascending 
    index tt_pssjrdrm_ramo_negoc           
          tta_cod_ramo_negoc               ascending. 

/* Temp-table 18:  conter  as informa‡äes dos portes das pessoas jur¡dicas: */

def temp-table tt_porte_pj_integr no-undo 
    field tta_num_pessoa_jurid             as integer format ">>>,>>>,>>9" initial 0 label "Pessoa Jur¡dica" column-label "Pessoa Jur¡dica" 
    field tta_dat_porte_pessoa_jurid       as date format "99/99/9999" initial ? label "Data Porte" column-label "Data Porte" 
    field tta_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda" 
    field tta_val_vendas                   as decimal format ">>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Vendas" column-label "Vendas" 
    field tta_val_patrim_liq               as decimal format ">>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Patrim“nio L¡quido" column-label "Patrim“nio L¡quido" 
    field tta_val_lucro_liq                as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Lucro L¡quido" column-label "Lucro L¡quido" 
    field tta_val_capit_giro_proprio       as decimal format ">>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Capital Giro Pr¢prio" column-label "Capital Giro Pr¢prio" 
    field tta_val_endivto_geral            as decimal format ">>9.99" decimals 2 initial 0 label "Endividamento Geral" column-label "Endividamento Geral" 
    field tta_val_endivto_longo_praz       as decimal format ">>9.99" decimals 2 initial 0 label "Endividamento Longo" column-label "Endividamento Longo" 
    field tta_val_vendas_func              as decimal format ">>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Vendas Funcion rio" column-label "Vendas Funcion rio" 
    field tta_qtd_funcionario              as decimal format ">>>,>>9" initial 0 label "Qtd Funcion rios" column-label "Qtd Funcion rios" 
    field tta_cod_classif_pessoa_jurid     as character format "x(8)" label "Classifica‡Æo" column-label "Classifica‡Æo" 
    field tta_des_anot_tab                 as character format "x(2000)" label "Anota‡Æo Tabela" column-label "Anota‡Æo Tabela" 
    field ttv_num_tip_operac               as integer format ">9" 
    index tt_prtpssjr_id                   is primary unique 
          tta_num_pessoa_jurid             ascending 
          tta_dat_porte_pessoa_jurid       ascending 
    index tt_prtpssjr_indic_econ           
          tta_cod_indic_econ               ascending. 

/* Temp-table 19:  conter  as informa‡äes dos idiomas das pessoa f¡sicas: */ 

def temp-table tt_idiom_pf_integr no-undo 
    field tta_num_pessoa_fisic             as integer format ">>>,>>>,>>9" initial 0 label "Pessoa F¡sica" column-label "Pessoa F¡sica" 
    field tta_cod_idioma                   as character format "x(8)" label "Idioma" column-label "Idioma" 
    field tta_log_idiom_princ              as logical format "Sim/NÆo" initial no label "Principal" column-label "Principal" 
    field ttv_num_tip_operac               as integer format ">9" 
    index tt_dmpssfs_id                    is primary unique 
          tta_num_pessoa_fisic             ascending 
          tta_cod_idioma                   ascending 
    index tt_dmpssfs_idioma                
          tta_cod_idioma                   ascending. 

/* Temp-table 20:  conter  as informa‡äes dos idiomas dos contatos: */

def temp-table tt_idiom_contat_integr no-undo 
    field tta_num_pessoa_jurid             as integer format ">>>,>>>,>>9" initial 0 label "Pessoa Jur¡dica" column-label "Pessoa Jur¡dica" 
    field tta_nom_abrev_contat             as character format "x(15)" label "Abreviado Contato" column-label "Abreviado Contato" 
    field tta_cod_idioma                   as character format "x(8)" label "Idioma" column-label "Idioma" 
    field tta_log_idiom_princ              as logical format "Sim/NÆo" initial no label "Principal" column-label "Principal" 
    field ttv_num_tip_operac               as integer format ">9" 
    index tt_dmcntta_id                    is primary unique 
          tta_num_pessoa_jurid             ascending 
          tta_nom_abrev_contat             ascending 
          tta_cod_idioma                   ascending 
    index tt_dmcntta_idioma                
          tta_cod_idioma                   ascending. 

/* Temp-table 21:  retornar  um arquivo com as informa‡äes dos erros ocorridos durante a execu‡Æo: */

def temp-table tt_retorno_clien_fornec no-undo 
    field ttv_cod_parameters               as character format "x(256)" 
    field ttv_num_mensagem                 as integer format ">>>>,>>9" label "N£mero" column-label "N£mero Mensagem" 
    field ttv_des_mensagem                 as character format "x(50)" label "Mensagem" column-label "Mensagem" 
    field ttv_des_ajuda                    as character format "x(50)" label "Ajuda" column-label "Ajuda" 
    field ttv_cod_parameters_clien         as character format "x(2000)" 
    field ttv_cod_parameters_fornec        as character format "x(2000)" 
    field ttv_log_envdo                    as logical format "Sim/NÆo" initial no 
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
