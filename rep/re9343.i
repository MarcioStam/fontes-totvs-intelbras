/*****************************************************************************
* Programa: RE9343.I                                                       *
* Data....: 01.07.2005 11:26 - Miranda                                       *
* Autor...: CINGO - Desenvolvimento de Sistemas Sob Encomenda                *
* Objetivo: Definicao temp-table tt-desp-item-doc-est
*****************************************************************************/

{method/dbotterr.i}

def temp-table RowErrorsAux no-undo like RowErrors.

def temp-table tt_impostos       no-undo
    field tta_cod_empresa        as character format "x(3)" 
    field tta_cdn_fornecedor     as integer   format ">>>,>>>,>>9"      initial 0      
    field tta_cod_imposto        as character format "x(5)"             
    field tta_cod_pais           as character format "x(3)"             
    field tta_cod_unid_federac   as character format "x(3)"             
    field tta_cod_retenc_impto   as character format "x(05)"            initial "00000" 
    field tta_log_obrig          as log       format "Sim/NÆo"          initial no
    field tta_val_aliq_impto     as decimal   format ">9.99"            decimals 2 initial 0.00 
    field tta_cod_espec_docto    as character format "x(3)" 
    field tta_cod_ser_docto      as character format "x(3)" 
    field tta_dat_vencto_impto   as date      format '99/99/9999'       initial today 
    field tta_perc_reduz_rendto  as decimal   format ">,>>>,>>>,>>9.99" decimals 2 
    index tt_impto_uniq_primary  is primary   unique
          tta_cod_empresa        ascending
          tta_cdn_fornecedor     ascending
          tta_cod_imposto        ascending
          tta_cod_pais           ascending
          tta_cod_unid_federac   ascending
          tta_cod_retenc_impto   ascending. 

def temp-table tt_log_erros no-undo
    field ttv_num_seq                      as integer format ">>>,>>9" label "Seq±¼ncia" column-label "Seq"
    field ttv_num_cod_erro                 as integer format ">>>>,>>9" label "Nœmero" column-label "Nœmero"
    field ttv_des_erro                     as character format "x(50)" label "Inconsist¼ncia" column-label "Inconsist¼ncia"
    field ttv_des_ajuda                    as character format "x(50)" label "Ajuda" column-label "Ajuda".
   
/* IRRF */	
/*--- Temp-tables utilizadas para traduzir a empresa/estab ---*/
def temp-table tt_xml_input_output no-undo
    field ttv_cod_label                    as character format "x(8)" label "Label" column-label "Label"
    field ttv_des_conteudo                 as character format "x(40)" label "Texto" column-label "Texto"
    field ttv_des_conteudo_aux             as character format "x(40)"
    field ttv_num_seq_1                    as integer format ">>>,>>9".                

/*--- Temp-tables utilizadas para retornar os impostos do fornecedor ---*/
def temp-table tt_param_integr_imptos_apb no-undo
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_val_pagto_tit_ap             as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Pagamentos" column-label "Vl Pagtos"
    field tta_dat_transacao                as date format "99/99/9999" initial today label "Data Transa‡Æo" column-label "Dat Transac"
    field tta_dat_emis_docto               as date format "99/99/9999" initial today label "Data  EmissÆo" column-label "Dt EmissÆo"
    field tta_dat_vencto_tit_ap            as date format "99/99/9999" initial today label "Data Vencimento" column-label "Dt Vencto"
    field ttv_log_impto_obrig              as logical format "Sim/NÆo" initial no label "Imptos Obrigat¢rios"
    field ttv_num_id_tit_ap                as integer format "9999999999" initial 0 label "Token Tit AP" column-label "Token Tit AP".

def temp-table tt_integr_imptos_pgto_apb no-undo
    field ttv_num_id_tit_ap                as integer format "9999999999" initial 0 label "Token Tit AP" column-label "Token Tit AP"
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field tta_nom_abrev_fornec             as character format "x(15)" label "Nome Abreviado" column-label "Nome Abreviado"
    field tta_cod_imposto                  as character format "x(5)" label "Imposto" column-label "Imposto"
    field tta_des_imposto                  as character format "x(40)" label "Descr  Imposto" column-label "Descri‡Æo"
    field tta_cod_classif_impto            as character format "x(05)" initial "00000" label "Class Imposto" column-label "Class Imposto"
    field tta_cod_unid_federac             as character format "x(3)" label "Unidade Federa‡Æo" column-label "UF"
    field tta_val_aliq_impto               as decimal format ">9.99" decimals 2 initial 0.00 label "Al¡quota" column-label "Aliq"
    field tta_val_imposto                  as decimal format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Imposto" column-label "Vl Imposto"
    field tta_val_rendto_tribut            as decimal format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Rendto Tribut vel" column-label "Vl Rendto Tribut"
    field tta_dat_vencto_tit_ap            as date format "99/99/9999" initial today label "Data Vencimento" column-label "Dt Vencto"
    field tta_log_impto_opcnal             as logical format "Sim/NÆo" initial no label "Imposto Opcional" column-label "Opcional".

def temp-table tt_erros_integr_imptos_apb no-undo
    field ttv_num_id_tit_ap                as integer format "9999999999" initial 0 label "Token Tit AP" column-label "Token Tit AP"
    field ttv_num_cod_erro                 as integer format ">>>>,>>9" label "Número" column-label "Numero"
    field ttv_des_msg_erro                 as character format "x(60)" label "Mensagem Erro" column-label "Inconsistˆncia"
    field ttv_des_msg_ajuda                as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda".
	
/*IRRF*/	
	

{inbo/boin092.i tt-dupli-apagar}   

