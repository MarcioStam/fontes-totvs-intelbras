/*
define temp-table tt-emitente like emitente no-undo.

define temp-table ttSupplier               no-undo      serialize-name "supplier"
    field externelId                       as character serialize-name "externelId"
    field supplierType                     as integer   serialize-name "supplierType"
    field corporateName                    as character serialize-name "corporateName"
    field fantasyName                      as character serialize-name "fantasyName"
    field language                         as character serialize-name "language"
    field legalRepresentativeName          as character serialize-name "legalRepresentativeName"
    field cpfLegalRepresentative           as character serialize-name "cpfLegalRepresentative"
    field legalRepresentativeEmail         as character serialize-name "legalRepresentativeEmail"
    field nameContactLogistics             as character serialize-name "nameContactLogistics"
    field logisticsContactEmail            as character serialize-name "logisticsContactEmail"
    field logisticsContactPhone            as character serialize-name "logisticsContactPhone"
    field financialContactEmailName        as character serialize-name "financialContactEmailName"
    field financialContactEmail            as character serialize-name "financialContactEmail"
    field financialContactPhone            as character serialize-name "financialContactPhone"
    field addressCountry                   as character serialize-name "addressCountry"
    field addressStreet                    as character serialize-name "addressStreet"
    field addressNumber                    as character serialize-name "addressNumber"
    field addressComplement                as character serialize-name "addressComplement"
    field addressDistrict                  as character serialize-name "addressDistrict"
    field addressPostalCode                as character serialize-name "addressPostalCode"
    field addressState                     as character serialize-name "addressState"
    field addressCity                      as character serialize-name "addressCity"
    field website                          as character serialize-name "website"
    field bankCode                         as integer   serialize-name "bankCode"
    field bankName                         as character serialize-name "bankName"
    field agency                           as character serialize-name "agency"
    field agencyDigit                      as character serialize-name "agencyDigit"
    field currentAccount                   as character serialize-name "currentAccount"
    field currentAccountDigit              as character serialize-name "currentAccountDigit"
    field bankAddress                      as character serialize-name "bankAddress"
    field currency                         as integer   serialize-name "currency"
    field pixKey                           as character serialize-name "pixKey"
    field keyType                          as character serialize-name "keyType"
    field cnpj                             as character serialize-name "cnpj"
    field municipalRegistration            as character serialize-name "municipalRegistration"
    field stateRegistration                as character serialize-name "stateRegistration"
    field serviceProvider                  as integer   serialize-name "serviceProvider"
    field taxRegime                        as character serialize-name "taxRegime"
    field taxId                            as character serialize-name "taxId"
    field swift                            as character serialize-name "swift"
    field beneficiary	                   as character serialize-name "beneficiary"
    field formOfPayment                    as integer   serialize-name "formOfPayment"
    field supplierGroup                    as integer   serialize-name "supplierGroup"
    field erpSupplierCode                  as integer   serialize-hidden
    .
*/

def temp-table tt_cliente_integr no-undo
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cdn_cliente                  as Integer format ">>>,>>>,>>9" initial 0 label "Cliente" column-label "Cliente"
    field tta_num_pessoa                   as integer format ">>>,>>>,>>9" initial ? label "Pessoa" column-label "Pessoa"
    field tta_nom_abrev                    as character format "x(15)" label "Nome Abreviado" column-label "Nome Abreviado"
    field tta_cod_grp_clien                as character format "x(4)" label "Grupo Cliente" column-label "Grupo Cliente"
    field tta_cod_tip_clien                as character format "x(8)" label "Tipo Cliente" column-label "Tipo Cliente"
    field tta_dat_impl_clien               as date format "99/99/9999" initial ? label "Implanta‡Æo Cliente" column-label "Implanta‡Æo Cliente"
    field tta_cod_pais_ext                 as character format "x(20)" label "Pa¡s Externo" column-label "Pa¡s Externo"
    field tta_cod_pais                     as character format "x(3)" label "Pa¡s" column-label "Pa¡s"
    field tta_cod_id_feder                 as character format "x(20)" initial ? label "ID Federal" column-label "ID Federal"
    field ttv_ind_pessoa                   as character format "X(08)" initial "Jur¡dica" label "Tipo Pessoa" column-label "Tipo Pessoa"
    field ttv_num_tip_operac               as integer format ">9"
    field tta_log_ems_20_atlzdo            as logical format "Sim/NÆo" initial no label "2.0 Atualizado" column-label "2.0 Atualizado"
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
          tta_nom_abrev                    ASCENDING .
          
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
    field ttv_ind_tip_pessoa_ems2          as character format "X(12)"
    field tta_log_cr_pis                   as logical format "Sim/NÆo" initial no label "Credita PIS"      column-label "Credita PIS"
    field tta_log_control_inss             as logical format "Sim/NÆo" initial no label "Controla Limite M x. INSS" column-label "Contr Lim INSS"
    field tta_log_cr_cofins                as logical format "Sim/NÆo" initial no label "Credita Cofins"   column-label "Credita Cofins"
    field tta_log_retem_pagto              as logical format "Sim/NÆo" initial no label "Ret‚m Pagto"   column-label "Ret‚m Pagto"
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
          tta_nom_abrev                    ASCENDING .

def temp-table tt_clien_financ_integr NO-UNDO
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cdn_cliente                  as Integer format ">>>,>>>,>>9" initial 0 label "Cliente" column-label "Cliente"
    field tta_cdn_repres                   as Integer format ">>>,>>9" initial 0 label "Representante" column-label "Representante"
    field ttv_cod_portad_prefer_ext        as character format "x(8)" label "Portad Prefer" column-label "Portad Prefer"
    field tta_cod_portad_ext               as character format "x(8)" label "Portador Externo" column-label "Portador Externo"
    field ttv_cod_portad_prefer            as character format "x(5)" label "Portador Preferenc" column-label "Port Preferenc"
    field tta_cod_portador                 as character format "x(5)" label "Portador" column-label "Portador"
    field tta_cod_cta_corren_bco           as character format "x(20)" label "Conta Corrente Banco" column-label "Conta Corrente Banco"
    field tta_cod_digito_cta_corren        as character format "x(2)" label "D¡gito Cta Corrente" column-label "D¡gito Cta Corrente"
    field tta_cod_agenc_bcia               as character format "x(10)" label "Agˆncia Banc ria" column-label "Agˆncia Banc ria"
    field tta_cod_banco                    as character format "x(8)" label "Banco" column-label "Banco"
    field tta_cod_classif_msg_cobr         as character format "x(8)" label "Classif Msg Cobr" column-label "Classif Msg Cobr"
    field tta_cod_instruc_bcia_1_acr       as character format "x(4)" label "Instru‡Æo Bcia 1" column-label "Instru‡Æo 1"
    field tta_cod_instruc_bcia_2_acr       as character format "x(4)" label "Instru‡Æo Bcia 2" column-label "Instru‡Æo 2"
    field tta_log_habilit_emis_boleto      as logical format "Sim/NÆo" initial no label "Emitir Boleto" column-label "Emitir Boleto"
    field tta_log_habilit_gera_avdeb       as logical format "Sim/NÆo" initial no label "Gerar AD" column-label "Gerar AD"
    field tta_log_retenc_impto             as logical format "Sim/NÆo" initial no label "Ret‚m Imposto" column-label "Ret‚m Imposto"
    field tta_log_habilit_db_autom         as logical format "Sim/NÆo" initial no label "D‚bito Auto" column-label "D‚bito Auto"
    field tta_num_tit_acr_aber             as integer format ">>>>,>>9" initial 0 label "Quant Tit  Aberto" column-label "Qtd Tit Abert"
    field tta_dat_ult_impl_tit_acr         as date format "99/99/9999" initial ? label "éltima Implanta‡Æo" column-label "éltima Implanta‡Æo"
    field tta_dat_ult_liquidac_tit_acr     as date format "99/99/9999" initial ? label "Ultima Liquida‡Æo" column-label "Ultima Liquida‡Æo"
    field tta_dat_maior_tit_acr            as date format "99/99/9999" initial ? label "Data Maior T¡tulo" column-label "Data Maior T¡tulo"
    field tta_dat_maior_acum_tit_acr       as date format "99/99/9999" initial ? label "Data Maior Acum" column-label "Data Maior Acum"
    field tta_val_ult_impl_tit_acr         as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Ultimo Tit" column-label "Valor Ultimo Tit"
    field tta_val_maior_tit_acr            as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Maior T¡tulo" column-label "Vl Maior T¡tulo"
    field tta_val_maior_acum_tit_acr       as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Maior Ac£mulo" column-label "Vl Maior Ac£mulo"
    field tta_ind_sit_clien_perda_dedut    as character format "X(21)" initial "Normal" label "Situa‡Æo Cliente" column-label "Sit Cliente"
    field ttv_num_tip_operac               as integer format ">9"
    field tta_log_neces_acompto_spc        as logical format "Sim/NÆo" initial no label "Neces Acomp SPC" column-label "Neces Acomp SPC"
    field tta_cod_tip_fluxo_financ         as character format "x(12)" label "Tipo Fluxo Financ" column-label "Tipo Fluxo Financ"
    field tta_log_utiliz_verba             as logical format "Sim/NÆo" initial no label "Utiliza Verba de Pub" column-label "Utiliza Verba de Pub"
    field tta_val_perc_verba               as decimal format ">>>9.99" decimals 2 initial 0 label "Percentual Verba de" column-label "Percentual Verba de"
    field tta_val_min_avdeb                as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Valor M¡nimo" column-label "Valor M¡nimo"
    field tta_log_calc_multa               as logical format "Sim/NÆo" initial no label "Calcula Multa" column-label "Calcula Multa"
    field tta_num_dias_atraso_avdeb        as integer format "999" initial 0 label "Dias Atraso" column-label "Dias Atraso"
    field tta_cod_digito_agenc_bcia        as character format "x(2)" label "D¡gito Agˆncia" column-label "Dig Ag"
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
          tta_cdn_repres                   ASCENDING.

def temp-table tt_fornec_financ_integr no-undo
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field tta_cod_portad_ext               as character format "x(8)" label "Portador Externo" column-label "Portador Externo"
    field tta_cod_portador                 as character format "x(5)" label "Portador" column-label "Portador"
    field tta_cod_cta_corren_bco           as character format "x(20)" label "Conta Corrente Banco" column-label "Conta Corrente Banco"
    field tta_cod_digito_cta_corren        as character format "x(2)" label "D¡gito Cta Corrente" column-label "D¡gito Cta Corrente"
    field tta_cod_agenc_bcia               as character format "x(10)" label "Agˆncia Banc ria" column-label "Agˆncia Banc ria"
    field tta_cod_digito_agenc_bcia        as character format "x(2)" label "D¡gito Ag Bcia" column-label "Dig Ag"
    field tta_cod_banco                    as character format "x(8)" label "Banco" column-label "Banco"
    field tta_cod_forma_pagto              as character format "x(3)" label "Forma Pagamento" column-label "F Pagto"
    field tta_cod_tip_fluxo_financ         as character format "x(12)" label "Tipo Fluxo Financ" column-label "Tipo Fluxo Financ"
    field tta_ind_tratam_vencto_sab        as character format "X(08)" initial "Prorroga" label "Vencimento Sabado" column-label "Vencto Sab"
    field tta_ind_tratam_vencto_dom        as character format "X(08)" initial "Prorroga" label "Vencimento Domingo" column-label "Vencto Dom"
    field tta_ind_tratam_vencto_fer        as character format "X(08)" initial "Prorroga" label "Vencimento Feriado" column-label "Vencto Feriado"
    field tta_ind_pagto_juros_fornec_ap    as character format "X(08)" label "Juros" column-label "Juros"
    field tta_ind_tip_fornecto             as character format "X(08)" label "Tipo Fornecimento" column-label "Fornecto"
    field tta_ind_armaz_val_pagto          as character format "X(12)" initial "NÆo Armazena" label "Armazena Valor Pagto" column-label "Armazena Valor Pagto"
    field tta_log_fornec_serv_export       as logical format "Sim/NÆo" initial no label "Fornec Exporta‡Æo" column-label "Fornec Export"
    field tta_log_pagto_bloqdo             as logical format "Sim/NÆo" initial no label "Bloqueia Pagamento" column-label "Pagto Bloqdo"
    field tta_log_retenc_impto             as logical format "Sim/NÆo" initial no label "Ret‚m Imposto" column-label "Ret‚m Imposto"
    field tta_dat_ult_impl_tit_ap          as date format "99/99/9999" initial ? label "Data Ultima Impl" column-label "Dt Ult Impl"
    field tta_dat_ult_pagto                as date format "99/99/9999" initial ? label "Data éltimo Pagto" column-label "Data éltimo Pagto"
    field tta_dat_impl_maior_tit_ap        as date format "99/99/9999" initial ? label "Dt Impl Maior Tit" column-label "Dt Maior Tit"
    field tta_num_antecip_aber             as integer format ">>>>9" initial 0 label "Quant Antec  Aberto" column-label "Qtd Antec"
    field tta_num_tit_ap_aber              as integer format ">>>>9" initial 0 label "Quant Tit  Aberto" column-label "Qtd Tit Abert"
    field tta_val_tit_ap_maior_val         as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Maior Tit Impl" column-label "Valor Maior T¡tulo"
    field tta_val_tit_ap_maior_val_aber    as decimal format "->>>>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Maior Tit  Aberto" column-label "Maior Vl Aberto"
    field tta_val_sdo_antecip_aber         as decimal format ">>>>>,>>>,>>9.99" decimals 2 initial 0 label "Saldo Antec Aberto" column-label "Sdo Antecip Aberto"
    field tta_val_sdo_tit_ap_aber          as decimal format "->>>>>,>>>,>>9.99" decimals 2 initial 0 label "Saldo Tit   Aberto" column-label "Sdo Tit Aberto"
    field ttv_num_tip_operac               as integer format ">9"
    field tta_cod_livre_1                  as character format "x(100)" label "Livre 1" column-label "Livre 1"
    field tta_num_rendto_tribut            as integer format ">>9" initial 0 label "Rendto Tribut vel" column-label "Rendto Tribut vel"
    field tta_log_vencto_dia_nao_util      as logical format "Sim/NÆo" initial no label "Vencto Igual Dt Flx" column-label "Vencto Igual Dt Flx"
    field tta_val_percent_bonif            as decimal format ">>9.99" decimals 2 initial 0 label "Perc Bonifica‡Æo" column-label "Perc Bonifica‡Æo"
    field tta_log_indic_rendto             as logical format "Sim/NÆo" initial no label "Ind Rendimento" column-label "Ind Rendimento"
    field tta_num_dias_compcao             as integer format ">>9" initial 0 label "Dias Compensa‡Æo" column-label "Dias Compensa‡Æo"
    field tta_cod_tax_ident_number         as character format "x(15)" label "Tax Id Number" column-label "Tax Id Number"
    field tta_ind_tip_trans_1099           as character format "X(50)" initial "Rents" label "Tipo Transacao 1099" column-label "Tipo Transacao 1099"
    field ttv_log_cop_aux                  as logical format "Sim/NÆo" initial no label "Cooperativa" column-label "Cooperativa"
    field ttv_log_assoc_despr              as logical format "Sim/NÆo" initial no label "Assoc. Desportiva" column-label "Assoc. Desportiva"
    index tt_frncfnnc_forma_pagto
          tta_cod_forma_pagto              ascending
    index tt_frncfnnc_id                   is primary unique
          tta_cod_empresa                  ascending
          tta_cdn_fornecedor               ascending
    index tt_frncfnnc_portador
          tta_cod_portad_ext               ASCENDING .

def temp-table tt_pessoa_jurid_integr      NO-UNDO

    field tta_num_pessoa_jurid             as integer format ">>>,>>>,>>9" initial 0 label "Pessoa Jur¡dica" column-label "Pessoa Jur¡dica"
    field tta_nom_pessoa                   as character format "x(40)" label "Nome" column-label "Nome"
    field tta_cod_id_feder                 as character format "x(20)" initial ? label "ID Federal" column-label "ID Federal"
    field tta_cod_id_estad_jurid           as character format "x(20)" initial ? label "ID Estadual" column-label "ID Estadual"
    field tta_cod_id_munic_jurid           as character format "x(20)" initial ? label "ID Municipal" column-label "ID Municipal"
    field tta_cod_id_previd_social         as character format "x(20)" label "Id Previdˆncia" column-label "Id Previdˆncia"
    field tta_log_fins_lucrat              as logical format "Sim/NÆo" initial yes label "Fins Lucrativos" column-label "Fins Lucrativos"
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
    field tta_log_ems_20_atlzdo            as logical format "Sim/NÆo" initial no label "2.0 Atualizado" column-label "2.0 Atualizado"
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
    field ttv_log_altera_razao_social      as logical format "Sim/NÆo" initial no label "Altera RazÆo Social" column-label "Altera RazÆo Social"
    field tta_nom_home_page                as character format "x(40)" label "Home Page" column-label "Home Page"
    field tta_nom_ender_text               as character format "x(2000)" label "Endereco Compl." column-label "Endereco Compl."
    field tta_nom_ender_cobr_text          as character format "x(2000)" label "End Cobranca Compl" column-label "End Cobranca Compl"
    field tta_nom_ender_pagto_text         as character format "x(2000)" label "End Pagto Compl." column-label "End Pagto Compl."
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field ttv_ind_tip_pessoa_ems2          as character format "X(12)"
    field ttv_cod_sub_regiao_vendas        as char format "x(8)" 
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
          tta_cod_unid_federac             ASCENDING .

def temp-table tt_pessoa_fisic_integr      no-undo
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
    field tta_log_ems_20_atlzdo            as logical   format 'Sim/NÆo':U
    field ttv_num_tip_operac               as integer   format '>9':U
    field ttv_rec_fiador_renegoc           as recid     format '>>>>>>9':U
    field ttv_log_altera_razao_social      as logical   format 'Sim/NÆo':U
    field ttv_nom_nacion_pessoa_fisic      as character format 'x(40)':U
    field ttv_nom_profis_pessoa_fisic      as character format 'x(40)':U
    field ttv_ind_estado_civil_pessoa      as character format 'X(10)':U
    field tta_nom_home_page                as character format 'x(40)':U
    field tta_nom_ender_text               as character format 'x(2000)':U
    /* In¡cio campos novos */
    FIELD tta_cod_id_munic_fisic           AS CHARACTER FORMAT 'x(20)':U
    FIELD tta_cod_id_previd_social         AS CHARACTER FORMAT 'x(20)':U
    FIELD tta_dat_vencto_id_munic          AS DATE      FORMAT '99/99/9999':U
    /* Fim campos novos */
    field tta_num_pessoa_fisic_cobr        as int format ">>>,>>>,>>9"
    field tta_nom_ender_cobr               as char format "x(40)"
    field tta_nom_ender_compl_cobr         as char format "x(10)"
    field tta_nom_bairro_cobr              as char format "x(20)"
    field tta_nom_cidad_cobr               as char format "x(32)"
    field tta_nom_condad_cobr              as char format "x(32)"
    field tta_cod_unid_federac_cobr        as char format "x(3)" 
    field ttv_cod_pais_ext_cob             as char format "x(20)"
    field ttv_cod_pais_cobr                as char format "x(3)" 
    field tta_cod_cep_cobr                 as char format "x(20)"
    field tta_cod_cx_post_cobr             as char format "x(20)"
    field tta_nom_ender_pagto              as char format "x(40)"
    field tta_cod_e_mail_cobr              as char format "x(40)"
    field ttv_cod_sub_regiao_vendas        as char format "x(8)"
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
          tta_cod_unid_federac             ASCENDING .
   
def temp-table tt_contato_integr no-undo
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
    field tta_log_ems_20_atlzdo            as logical format "Sim/NÆo" initial no label "2.0 Atualizado" column-label "2.0 Atualizado"
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
          tta_num_pessoa_fisic             ASCENDING.

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
          tta_cod_clas_contat              ASCENDING.

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
          tta_num_seq_estrut_clien         ASCENDING .
          
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
          tta_num_seq_estrut_fornec        ASCENDING .

def temp-table tt_histor_clien_integr      NO-UNDO
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cdn_cliente                  as Integer format ">>>,>>>,>>9" initial 0 label "Cliente" column-label "Cliente"
    field tta_num_seq_histor_clien         as integer format ">>>>,>>9" initial 0 label "Sequencia" column-label "Sequencia"
    field tta_des_abrev_histor_clien       as character format "x(40)" label "Abrev Hist¢rico" column-label "Abrev Hist¢rico"
    field tta_des_histor_clien             as character format "x(2000)" label "Hist¢rico" column-label "Hist¢rico"
    field ttv_num_tip_operac               as integer format ">9"
    index tt_hstrcln_id                    is primary unique
          tta_cod_empresa                  ascending
          tta_cdn_cliente                  ascending
          tta_num_seq_histor_clien         ASCENDING .

def temp-table tt_histor_fornec_integr     NO-UNDO
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field tta_num_seq_histor_fornec        as integer format ">>>>,>>9" initial 0 label "Sequencia" column-label "Sequencia"
    field tta_des_abrev_histor_fornec      as character format "x(40)" label "Abrev Hist¢rico" column-label "Abrev Hist¢rico"
    field tta_des_histor_fornec            as character format "x(40)" label "Hist¢rico Fornecedor" column-label "Hist¢rico Fornecedor"
    field ttv_num_tip_operac               as integer format ">9"
    index tt_hstrfrna_id                   is primary unique
          tta_cod_empresa                  ascending
          tta_cdn_fornecedor               ascending
          tta_num_seq_histor_fornec        ASCENDING .
          
def temp-table tt_ender_entreg_integr no-undo
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
          tta_cod_unid_federac_entreg      ASCENDING .

def temp-table tt_telef_integr             NO-UNDO
    field tta_cod_telef_sem_edic           as character format "x(20)" label "Telefone" column-label "Telefone"
    field tta_ind_tip_telef_pessoa         as character format "X(08)" label "Tipo Telefone" column-label "Tipo Telefone"
    field ttv_num_tip_operac               as integer format ">9"
    index tt_telef_id                      is primary
          tta_cod_telef_sem_edic           ASCENDING.

def temp-table tt_telef_pessoa_integr      NO-UNDO
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
          tta_cdn_fornecedor               ASCENDING.

def temp-table tt_pj_ativid_integr         NO-UNDO
    field tta_num_pessoa_jurid             as integer format ">>>,>>>,>>9" initial 0 label "Pessoa Jur¡dica" column-label "Pessoa Jur¡dica"
    field tta_cod_ativid_pessoa_jurid      as character format "x(8)" label "Atividade" column-label "Atividade"
    field tta_log_ativid_pessoa_princ      as logical format "Sim/NÆo" initial no label "Atividade Principal" column-label "Principal"
    field ttv_num_tip_operac               as integer format ">9"
    field ttv_cdn_clien_fornec             as Integer format ">>>,>>9" initial 0
    index tt_pssjrdtv_atividade           
          tta_cod_ativid_pessoa_jurid      ascending
    index tt_pssjrdtv_id                   is primary unique
          tta_num_pessoa_jurid             ascending
          tta_cod_ativid_pessoa_jurid      ascending
          ttv_cdn_clien_fornec             ASCENDING .

def temp-table tt_pj_ramo_negoc_integr     NO-UNDO
    field tta_num_pessoa_jurid             as integer format ">>>,>>>,>>9" initial 0 label "Pessoa Jur¡dica" column-label "Pessoa Jur¡dica"
    field tta_cod_ramo_negoc               as character format "x(8)" label "Ramo Neg¢cio" column-label "Ramo Neg¢cio"
    field tta_log_ramo_negoc_princ         as logical format "Sim/NÆo" initial no label "Ramo Negoc Principal" column-label "Principal"
    field ttv_num_tip_operac               as integer format ">9"
    field ttv_cdn_clien_fornec             as Integer format ">>>,>>9" initial 0
    index tt_pssjrdm_id                    is primary unique
          tta_num_pessoa_jurid             ascending
          tta_cod_ramo_negoc               ascending
          ttv_cdn_clien_fornec             ascending
    index tt_pssjrdrm_ramo_negoc          
          tta_cod_ramo_negoc               ASCENDING .
    .

def temp-table tt_porte_pj_integr          NO-UNDO
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
          tta_cod_indic_econ               ASCENDING.

def temp-table tt_idiom_pf_integr          NO-UNDO
    field tta_num_pessoa_fisic             as integer format ">>>,>>>,>>9" initial 0 label "Pessoa F¡sica" column-label "Pessoa F¡sica"
    field tta_cod_idioma                   as character format "x(8)" label "Idioma" column-label "Idioma"
    field tta_log_idiom_princ              as logical format "Sim/NÆo" initial no label "Principal" column-label "Principal"
    field ttv_num_tip_operac               as integer format ">9"
    index tt_dmpssfs_id                    is primary unique
          tta_num_pessoa_fisic             ascending
          tta_cod_idioma                   ascending
    index tt_dmpssfs_idioma
          tta_cod_idioma                   ASCENDING .

def temp-table tt_idiom_contat_integr      NO-UNDO
    field tta_num_pessoa_jurid             as integer format ">>>,>>>,>>9" initial 0 label "Pessoa Jur¡dica" column-label "Pessoa Jur¡dica"
    field tta_nom_abrev_contat             as character format "x(15)" label "Abreviado Contato" column-label "Abreviado Contato"
    field tta_cod_idioma                   as character format "x(8)" label "Idioma" column-label "Idioma"
    field tta_log_idiom_princ              as logical format "Sim/Nao" initial no label "Principal" column-label "Principal"
    field ttv_num_tip_operac               as integer format ">9"
    index tt_dmcntta_id                    is primary unique
          tta_num_pessoa_jurid             ascending
          tta_nom_abrev_contat             ascending
          tta_cod_idioma                   ascending
    index tt_dmcntta_idioma
          tta_cod_idioma                   ASCENDING .

def temp-table tt_retorno_clien_fornec     no-undo
    field ttv_cod_parameters               as character format "x(256)"
    field ttv_num_mensagem                 as integer format ">>>>,>>9"
    field ttv_des_mensagem                 as character format "x(52)" label "Mensagem" column-label "Mensagem"
    field ttv_des_ajuda                    as character format "x(256)"
                                           view-as editor max-chars 2000 scrollbar-vertical size 40 by 4
                                           label "Ajuda" column-label "Ajuda"
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

def temp-table tt_clien_analis_cr_integr   no-undo
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cdn_cliente                  as Integer format ">>>,>>>,>>9" initial 0 label "Cliente" column-label "Cliente"
    field tta_cod_tip_clien                as character format "x(8)" label "Tipo Cliente" column-label "Tipo Cliente"
    field tta_cod_clas_risco_clien         as character format "x(8)" label "Classe Risco" column-label "Classe Risco"
    field tta_log_neces_acompto_spc        as logical format "Sim/NÆo" initial no label "Neces Acomp SPC" column-label "Neces Acomp SPC"
    field tta_ind_sit_cr                   as character format "X(15)" label "Situa‡Æo" column-label "Situa‡Æo"
    field ttv_num_tip_operac               as integer format ">9"
    index tt_clien_unico                   is primary unique
          tta_cod_empresa                  ascending
          tta_cdn_cliente                  ASCENDING.

def temp-table tt_cta_corren_fornec_1 no-undo
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field tta_cod_banco                    as character format "x(8)" label "Banco" column-label "Banco"
    field tta_cod_agenc_bcia               as character format "x(10)" label "Agˆncia Banc ria" column-label "Agˆncia Banc ria"
    field tta_cod_digito_agenc_bcia        as character format "x(2)" label "D¡gito Ag Bcia" column-label "Dig Ag"
    field tta_cod_cta_corren_bco           as character format "x(20)" label "Conta Corrente Banco" column-label "Conta Corrente Banco"
    field tta_cod_digito_cta_corren        as character format "x(2)" label "D¡gito Cta Corrente" column-label "D¡gito Cta Corrente"
    field ttv_cod_desc_cta_fornec          as character format "x(30)" label "Descri‡Æo Cta Corren" column-label "Descri‡Æo Cta Corren"
    field ttv_log_cta_prefer               as logical format "Sim/NÆo" initial no label "Preferencial" column-label "Preferencial"
    field ttv_num_tip_operac               as integer format ">9" column-label "Tipo  Opera‡Æo"
    field ttv_rec_cta_fornec               as recid format ">>>>>>9"
    field ttv_log_cta_poupan               as logical format "Sim/NÆo" initial no label "Conta Poupan‡a"
    index tt_conta_corrente                is primary unique
          tta_cod_empresa                  ascending
          tta_cdn_fornecedor               ascending
          tta_cod_banco                    ascending
          tta_cod_agenc_bcia               ascending
          tta_cod_digito_agenc_bcia        ascending
          tta_cod_cta_corren_bco           ascending
          tta_cod_digito_cta_corren        ascending
    .

def temp-table tt_chave_pix_fornec no-undo
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field tta_cod_chave_pix                as character format "x(77)" label "Chave PIX" column-label "Chave PIX"
    field tta_ind_tip_chave_pix            as character format "X(20)" label "Tipo Chave PIX" column-label "Tipo Chave PIX"
    field tta_des_obs                      as character format "x(255)" label "ObservaÎ’o" column-label "ObservaÎ’o"
    field tta_log_chave_prefer             as logical format "Sim/N’o" initial no label "Preferencial" column-label "Preferencial"
    field ttv_rec_chave_pix_fornec         as recid format ">>>>>>9"
    index tt_chvpxfrn_ix2                  is primary unique
          tta_cod_empresa                  ascending
          tta_cdn_fornecedor               ascending
          tta_cod_chave_pix                ascending
    .

def temp-table tt_params_generic_api_id no-undo
    field ttv_cod_id_tab                   as character format "x(200)" label "Codigo id Tabela"
    field ttv_cod_tabela                   as character format "x(28)" label "Tabela" column-label "Tabela"
    field ttv_cod_campo                    as character format "x(35)" label "Campo" column-label "Campo"
    field ttv_cod_valor                    as character format "x(8)" label "Valor" column-label "Valor"
    index tt_idx_param_generic             is primary unique
          ttv_cod_tabela                   ascending
          ttv_cod_id_tab                   ascending
          ttv_cod_campo                    ascending
    .		  

