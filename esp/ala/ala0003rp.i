/*integra‡äes*/
def temp-table tt_integr_apb_antecip_pef_p1 no-undo
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_refer                    as character format "x(10)" label "Refer¼ncia" column-label "Refer¼ncia"
    field tta_cod_espec_docto              as character format "x(3)" label "Esp²cie Documento" column-label "Esp²cie"
    field tta_cod_ser_docto                as character format "x(3)" label "S²rie Documento" column-label "S²rie"
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field tta_cod_tit_ap                   as character format "x(10)" label "T­tulo" column-label "T­tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field tta_cod_portador                 as character format "x(5)" label "Portador" column-label "Portador"
    field tta_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda"
    field tta_num_talon_cheq               as integer format ">>>,>>>,>>9" initial 0 label "Talonÿrio Cheques" column-label "Talonÿrio Cheques"
    field tta_num_cheque                   as integer format ">>>>,>>>,>>9" initial ? label "Num Cheque" column-label "Num Cheque"
    field tta_ind_favorec_cheq             as character format "X(15)" initial "Portador" label "Favorecido" column-label "Favorecido"
    field tta_nom_favorec_cheq             as character format "x(40)" label "Nome Favorecido" column-label "Nome Favorecido"
    field tta_val_tit_ap                   as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor T­tulo" column-label "Valor T­tulo"
    field tta_val_cotac_indic_econ         as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Cota»’o" column-label "Cota»’o"
    field tta_dat_emis_docto               as date format "99/99/9999" initial today label "Data  Emiss’o" column-label "Dt Emiss’o"
    field tta_dat_vencto_tit_ap            as date format "99/99/9999" initial today label "Data Vencimento" column-label "Dt Vencto"
    field tta_ind_tip_refer                as character format "X(22)" label "Tipo Refer¼ncia" column-label "Tipo"
    field tta_cod_seguradora               as character format "x(8)" label "Seguradora" column-label "Seguradora"
    field tta_cod_apol_seguro              as character format "x(12)" label "Ap½lice Seguro" column-label "Apolice Seguro"
    field tta_cod_arrendador               as character format "x(6)" label "Arrendador" column-label "Arrendador"
    field tta_cod_contrat_leas             as character format "x(12)" label "Contrato Leasing" column-label "Contr Leas"
    field tta_cod_histor_padr              as character format "x(8)" label "Hist½rico Padr’o" column-label "Hist½rico Padr’o"
    field tta_des_text_histor              as character format "x(2000)" label "Hist½rico" column-label "Hist½rico"
    field tta_ind_natur_cta_ctbl           as character format "X(08)" initial "DB" label "Natureza Contÿbil" column-label "Natureza Contÿbil"
    field tta_cod_usuar_gerac_movto        as character format "x(12)" label "Usuario Gerac Movto" column-label "Usuario"
    field ttv_cod_empresa_ext              as character format "x(3)" label "C½digo Empresa Ext" column-label "C½d Emp Ext"
    field tta_cod_estab_ext                as character format "x(8)" label "Estabelecimento Exte" column-label "Estabelecimento Ext"
    field tta_cod_portad_ext               as character format "x(8)" label "Portador Externo" column-label "Portador Externo"
    field tta_cod_modalid_ext              as character format "x(8)" label "Modalidade Externa" column-label "Modalidade Externa"
    field ttv_rec_antecip_pef_pend         as recid format ">>>>>>9"
    field tta_ind_origin_tit_ap            as character format "X(03)" initial "APB" label "Origem" column-label "Origem"
    field tta_cod_cart_bcia                as character format "x(3)" label "Carteira" column-label "Carteira"
    field ttv_ind_tip_cod_barra            as character format "X(01)"
    field tta_cb4_tit_ap_bco_cobdor        as Character format "x(50)" label "Titulo Bco Cobrador" column-label "Titulo Bco Cobrador"
    field tta_cod_tit_ap_bco_cobdor        as character format "x(20)" label "T­tulo Banco Cobdor" column-label "T­tulo Banco Cobdor"
    index tt_antcppfp_id                   is primary unique
          tta_cod_estab                    ascending
          tta_cod_refer                    ascending
    index tt_antcppfp_tip_refer           
          tta_cod_empresa                  ascending
          tta_ind_tip_refer                ascending
          tta_cod_estab                    ascending
          tta_cod_refer                    ascending
    index tt_recid                        
          ttv_rec_antecip_pef_pend         ascending.


def temp-table tt_log_erros_atualiz_an no-undo 
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab" 
    field tta_cod_refer                    as character format "x(10)" label "Refer¬ncia" column-label "Refer¬ncia" 
    field tta_num_seq_refer                as integer format ">>>9" initial 0 label "Sequ¬ncia" column-label "Seq" 
    field ttv_num_mensagem                 as integer format ">>>>,>>9" label "Nßmero" column-label "Nßmero Mensagem" 
    field ttv_des_msg_erro                 as character format "x(60)" label "Mensagem Erro" column-label "Inconsist¬ncia" 
    field ttv_des_msg_ajuda                as character format "x(200)" label "Mensagem Ajuda" column-label "Mensagem Ajuda"
    field ttv_ind_tip_relacto              as character format "X(15)" label "Tipo Relacionamento" column-label "Tipo Relac" 
    field ttv_num_relacto                  as integer format ">>>>,>>9" label "Relacionamento" column-label "Relacionamento". 

def temp-table tt_1099 no-undo
    field ttv_rec_table_parent             as recid format ">>>>>>9"
    field ttv_val_1099                     as decimal format "->>,>>>,>>>,>>9.99" decimals 2
    field tta_cod_tax_ident_number         as character format "x(15)" label "Tax Id Number" column-label "Tax Id Number"
    field tta_ind_tip_trans_1099           as character format "X(50)" initial "Rents" label "Tipo Transacao 1099" column-label "Tipo Transacao 1099"
    index tt_rec_index                     is primary unique
          ttv_rec_table_parent             ascending.

def temp-table tt_ord_compra_tit_ap_pend_1 no-undo
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_refer                    as character format "x(10)" label "Refer¼ncia" column-label "Refer¼ncia"
    field tta_num_seq_refer                as integer format ">>>9" initial 0 label "Sequ¼ncia" column-label "Seq"
    field tta_cod_ord_compra               as character format "x(8)" label "Ordem Compra" column-label "Ordem Compra"
    field tta_val_perc_ord_compra          as decimal format ">>9.99" decimals 2 initial 0 label "Perc Ordem Compra" column-label "Perc Ordem Compra"
    field tta_val_origin_ord_compra        as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Original Ordem Compr" column-label "Original Ordem Compr"
    field tta_val_sdo_ord_compra           as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Saldo Ordem Compra" column-label "Saldo Ordem Compra"
    index tt_codigo                        is primary unique
          tta_cod_estab                    ascending
          tta_cod_refer                    ascending
          tta_num_seq_refer                ascending
          tta_cod_ord_compra               ascending.

DEF TEMP-TABLE tt_an_pef NO-UNDO
    FIELD tta_cod_tip_tit   AS CHAR
    FIELD tta_cod_tit_ap    AS CHAR
    FIELD tta_cod_parcela   AS CHAR
    FIELD tta_cod_refer     AS CHAR
    FIELD tta_val_tit_ap    AS DEC
    FIELD tta_cod_histor    AS CHAR
    INDEX tt_an_pef_id      IS PRIMARY 
          tta_cod_tip_tit   ascending
          tta_cod_tit_ap    ascending
          tta_cod_parcela   ascending.


DEFINE TEMP-TABLE tt-contas NO-UNDO
    FIELD request_number LIKE int_solicitacao_alatur.request_number
    FIELD cod-cta-ctbl   AS CHAR
    FIELD val-desl       AS DEC
    FIELD qtd-desp       AS DEC
    FIELD tot-desp       AS DEC
    INDEX pu             IS PRIMARY request_number
                                    cod-cta-ctbl.

DEFINE TEMP-TABLE tt-rateios NO-UNDO
    FIELD request_number LIKE int_solicitacao_alatur.request_number
    FIELD centro-custo   AS CHAR
    FIELD empresa        AS CHAR
    FIELD percentual     AS DEC
    INDEX pu             IS PRIMARY request_number
                                    centro-custo.
