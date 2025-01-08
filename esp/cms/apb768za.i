/*Temp-table 1:  conter  as informa‡äes do t¡tulo e informa‡äes gerais.*/
def temp-table tt_cancelamento_estorno_apb no-undo
    field ttv_ind_niv_operac_apb            as character format "X(10)"
    field ttv_ind_tip_operac_apb     	    as character format "X(12)"   
    field tta_cod_estab                    	as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_num_id_tit_ap              	as integer format "9999999999" initial 0 label "Token Tit AP" column-label "Token Tit AP"
    field tta_num_id_movto_tit_ap 	        as integer format "9999999999" initial 0 label "Token Movto Tit AP" column-label "Id Tit AP"
    field tta_cod_refer                    	as character format "x(10)" label "Referˆncia" column-label "Referˆncia"
    field tta_dat_transacao               	as date format "99/99/9999" initial today label "Data Transa‡Æo" column-label "Dat Transac"
    field tta_cod_histor_padr           	as character format "x(8)" label "Hist¢rico PadrÆo" column-label "Hist¢rico PadrÆo"
    field ttv_des_histor                   	as character format "x(40)" label "Cont‚m" column-label "Hist¢rico"
    field ttv_ind_tip_estorn              	as character format "X(10)"
    field tta_cod_portador                	as character format "x(5)" label "Portador" column-label "Portador"
    field ttv_cod_estab_reembol      	    as character format "x(8)"
    field ttv_log_reaber_item           	as logical format "Sim/NÆo" initial yes
    field ttv_log_reembol                	as logical format "Sim/NÆo" initial yes
    field ttv_log_estorn_impto_retid as logical format "Sim/NÆo" initial yes.

/*Temp-table 2: Esta temp-table apenas dever  ser definida, nÆo poder  receber valor, ‚ de uso interno.*/
def temp-table tt_estornar_agrupados no-undo
    field ttv_num_seq                    	as integer format ">>>,>>9" label "Seqˆncia" column-label "Seq"
    field tta_nom_abrev                 	as character format "x(15)" label "Nome Abreviado" column-label "Nome Abreviado"
    field tta_cod_estab_pagto        	    as character format "x(3)" label "Estab Pagto" column-label "Estab Pagto"
    field tta_cod_refer                    	as character format "x(10)" label "Referˆncia" column-label "Referˆncia"
    field tta_dat_pagto                  	as date format "99/99/9999" initial today label "Data Pagamento" column-label "Data Pagto"
    field tta_cod_estab                    	as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_espec_docto         	    as character format "x(3)" label "Esp‚cie Documento" column-label "Esp‚cie"
    field tta_cod_ser_docto            	    as character format "x(3)" label "S‚rie Documento" column-label "S‚rie"
    field tta_cod_tit_ap                   	as character format "x(10)" label "T¡tulo" column-label "T¡tulo"
    field tta_cod_parcela                  	as character format "x(02)" label "Parcela" column-label "Parc"
    field tta_val_movto_ap              	as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor  Movimento" column-label "Valor Movto"
    field tta_ind_modo_pagto          	    as character format "X(10)" label "Modo  Pagamento" column-label "Modo Pagto"
    field tta_cod_empresa              	    as character format "x(3)" label "Empresa" column-label "Empresa"
    field ttv_rec_tit_ap                   	as recid format ">>>>>>9" initial ?
    field ttv_num_seq_abrev           	    as integer format ">>9" label "Sq" column-label "Sq"                        
    field tta_ind_trans_ap_abrev     	    as character format "X(04)" label "Trans Abrev" column-label "Trans Abrev"  
    field ttv_rec_compl_movto_pagto         as recid format ">>>>>>9"                                                   
    field ttv_rec_movto_tit_ap         	    as recid format ">>>>>>9"                                                   
    field ttv_rec_item_cheq_ap       	    as recid format ">>>>>>9"                                                   
    field ttv_rec_item_bord_ap        	    as recid format ">>>>>>9"                                                   
    field ttv_rec_item_lote_pagto    	    as recid format ">>>>>>9"                                                   
    index tt_ind_modo                     
          tta_ind_modo_pagto            	ascending.


/*Temp-table 3: conter  as informa‡äes de erro que poderÆo ocorrer na execu‡Æo do programa.*/
def temp-table tt_log_erros_estorn_cancel_apb no-undo
    field tta_cod_estab                    	as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_refer                    	as character format "x(10)" label "Referˆncia" column-label "Referˆncia"
    field tta_num_mensagem                  as integer format ">>,>>>,>>9" initial 0 label "Mensagem" column-label "Mensagem"
    field ttv_des_msg_erro              	as character format "x(60)" label "Mensagem Erro" column-label "Inconsistˆncia"
    field ttv_des_msg_ajuda            	    as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda".


/*Temp-table 4: conter  as informa‡äes dos t¡tulos que poderÆo Ter impostos vinculados ao fornecedor, resaltando que a mesma ‚ de uso interno, e nÆo poder  conter valor, na passagem de parametro.*/
def temp-table tt_estorna_tit_imptos no-undo
    field ttv_cod_refer_imp                	as character format "x(10)" label "Referˆncia" column-label "Referˆncia"
    field ttv_cod_refer                    	as character format "x(10)" label "Referˆncia" column-label "Referˆncia"
    field ttv_cod_estab_imp             	as character format "x(3)" label "Estabelec. Impto." column-label "Estab. Imp."
    field ttv_cdn_fornecedor_imp            as Integer format ">>>,>>>,>>9" label "Fornecedor" column-label "Fornecedor"
    field ttv_cod_espec_docto_imp       	as character format "x(3)" label "Esp‚cie Documento" column-label "Esp‚cie"
    field ttv_cod_ser_docto_imp      	    as character format "x(3)" label "S‚rie Documento" column-label "S‚rie"
    field ttv_cod_tit_ap_imp              	as character format "x(10)" label "T¡tulo" column-label "T¡tulo"
    field ttv_cod_parcela_imp          	    as character format "x(02)" label "Parcela" column-label "Parc"
    field ttv_val_tit_ap_imp             	as decimal format "->>>,>>>,>>9.99" decimals 2 label "Valor T¡tulo" column-label "Valor T¡tulo"
    field ttv_val_sdo_tit_ap_imp     	    as decimal format "->>>,>>>,>>9.99" decimals 2 label "Valor Saldo" column-label "Valor Saldo"
    field ttv_num_id_tit_ap_imp     	    as integer format "9999999999" label "Token Tit AP" column-label "Token Tit AP"
    field ttv_num_mensagem           	    as integer format ">>>>,>>9" label "N£mero" column-label "N£mero Mensagem"
    field ttv_des_mensagem            	    as character format "x(50)" label "Mensagem" column-label "Mensagem"
    field ttv_des_ajuda                    	as character format "x(50)" label "Ajuda" column-label "Ajuda"
    field ttv_cod_estab_2                 	as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field ttv_cod_estab                    	as character format "x(3)" label "Estabelecimento" column-label "Estabelecimento"
    field ttv_cdn_fornecedor            	as Integer format ">>>,>>>,>>9" label "Fornecedor" column-label "Fornecedor"
    field ttv_cod_espec_docto           	as character format "x(3)" label "Esp‚cie Documento" column-label "Esp‚cie"
    field ttv_cod_ser_docto             	as character format "x(3)" label "S‚rie Docto" column-label "S‚rie"
    field ttv_cod_tit_ap                   	as character format "x(10)" label "T¡tulo Ap" column-label "T¡tulo Ap"
    field ttv_cod_parcela                  	as character format "x(02)" label "Parcela" column-label "Parc"
    field ttv_val_tit_ap                   	as decimal format "->>,>>>,>>>,>>9.99" decimals 2 label "Valor T¡tulo" column-label "Valor T¡tulo"
    field ttv_val_sdo_tit_ap             	as decimal format "->>>,>>>,>>9.99" decimals 2 label "Valor Saldo" column-label "Valor Saldo"
    field ttv_num_id_tit_ap            	    as integer format "9999999999" label "Token Tit AP" column-label "Token Tit AP"
    field ttv_ind_trans_ap_abrev     	    as character format "X(04)" label "Transa‡Æo" column-label "Transa‡Æo"
    field ttv_cod_refer_2                  	as character format "x(10)" label "Referˆncia" column-label "Referˆncia"
    field ttv_num_order                   	as integer format ">>>>,>>9" label "Ordem" column-label "Ordem"
    field ttv_val_tot_comprtdo        	    as decimal format "->>>,>>>,>>9.99" decimals 2
    index tt_idimpto                      
          ttv_cod_estab_imp               	ascending
          ttv_cdn_fornecedor_imp      	    ascending
          ttv_cod_espec_docto_imp   	    ascending
          ttv_cod_ser_docto_imp        	    ascending
          ttv_cod_tit_ap_imp              	ascending
          ttv_cod_parcela_imp            	ascending
    index tt_idimpto_pgef                 
          ttv_cod_estab                    	ascending
          ttv_cod_refer                    	ascending
    index tt_idtit_refer                  
          ttv_cod_estab_2                  	ascending
          ttv_cdn_fornecedor             	ascending
          ttv_cod_espec_docto           	ascending
          ttv_cod_ser_docto                	ascending
          ttv_cod_tit_ap                   	ascending
          ttv_cod_parcela                  	ascending
          ttv_cod_refer_2                  	ascending
    index tt_numsg                        
          ttv_num_mensagem         	        ascending
    index tt_order                        
          ttv_num_order                    	ascending.
