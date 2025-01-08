/******************************************************************************
** Programa: escms001.i
** Data....: Mar‡o/2005
** Autor...: Maria Ester - Gestech.
** Objetivo: Defini‡Æo de vari veis utilizadas nos prog. escms001, escms002, escms005, escms004 e escms006
** Versao..: 1.00
******************************************************************************/

/* Temporary Tables Definitions */
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
    label "Grupo Usu rios"
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
    label "Pa¡s Empresa Usu rio"
    column-label "Pa¡s"
    no-undo.
def new global shared var v_cod_usuar_corren
    as character
    format "x(12)":U
    label "Usu rio Corrente"
    column-label "Usu rio Corrente"
    no-undo.
def new global shared var v_cod_usuar_corren_criptog
    as character
    format "x(16)":U
    no-undo.

/* variables Definitions */
DEF VAR c_lista_trans              AS CHAR INIT "AVMA,DEV,EVMA,EVMN,REN,EREN,ESTT,LQPD,ELIQ,LQRN,ELQR,AVCR,LQEC"  NO-UNDO.
DEF VAR v_cod_refer                AS CHAR                                                          NO-UNDO.
DEF VAR v_num_aux_2                AS INTEGER                                                       NO-UNDO.
DEF VAR v_num_aux                  AS INTEGER                                                       NO-UNDO.
DEF VAR i-num-seq-refer            AS INT                                                           NO-UNDO.
DEF VAR v_cod_refer_antec          LIKE movto_tit_ap.cod_refer                                      NO-UNDO.
DEF VAR v_cod_refer_impl           AS CHAR FORMAT "x(1)"                                            NO-UNDO.
DEF VAR v-vlr-comissao             LIKE movto_tit_acr.val_movto_tit_acr                             NO-UNDO. 
DEF VAR v-vlr-comis-jur            LIKE movto_tit_acr.val_movto_tit_acr                             NO-UNDO. 
DEF VAR v-vlr-movto                LIKE movto_tit_acr.val_movto_tit_acr                             NO-UNDO. 
DEF VAR v-vlr-pagto                LIKE movto_tit_acr.val_movto_tit_acr                             NO-UNDO. 
DEF VAR v-fator-comis              AS DEC                                                           NO-UNDO.
DEF VAR v_val_sdo_tit_ap           LIKE tit_ap.val_sdo_tit_ap                                        NO-UNDO.
DEF VAR v_val_dif_comis            LIKE movto_tit_acr.val_movto_tit_acr                              NO-UNDO. 
DEF VAR v_num_cont                 AS INT                                                           NO-UNDO.
DEF VAR l_erro                     AS LOG                                                           NO-UNDO.
DEF VAR l_imprime_erro             AS LOG                                                           NO-UNDO.
DEF VAR l_vendor                   AS LOG  INIT NO                                                  NO-UNDO.
DEF VAR l_parcela_reduz            AS LOG                                                            NO-UNDO.
DEF VAR v_cod_tit_cpo              AS CHAR FORMAT "x(12)"                                           NO-UNDO.
DEF VAR v_seq_tit_cpo              AS INT  FORMAT "99"                                              NO-UNDO.
DEF VAR v_vendor                   AS LOG  INIT NO                                                  NO-UNDO.
DEF VAR i                          AS INTEGER                                                       NO-UNDO.
DEF VAR v_log_livre_1              AS CHAR                                                          NO-UNDO.
DEF VAR c_desc_erro                AS CHAR FORMAT "x(60)"                                           NO-UNDO.
DEF VAR v_cod_tit_acr              LIKE tit_acr.cod_tit_acr                                         NO-UNDO.
DEF VAR v_num_seq                  AS INTEGER                                                       NO-UNDO.
DEF VAR v_log_ped_repre            AS LOGICAL                                                       NO-UNDO.
DEF VAR v_cod_parcela              AS CHAR                                                          NO-UNDO.
DEF VAR v_cod_plano_cta_ctbl       LIKE param_estab_comis.cod_plano_cta_ctbl                        NO-UNDO.
DEF VAR v_cod_cta_ctbl             LIKE param_estab_comis.cod_cta_ctbl                              NO-UNDO.
DEF VAR v_cod_tip_fluxo_financ     LIKE param_estab_comis.cod_tip_fluxo_financ_ap                   NO-UNDO.
DEF VAR v-acordo-com-perc          AS DECIMAL                                                       NO-UNDO.
DEF VAR v_cont_cpo                 AS INTEGER                                                       NO-UNDO.
DEF VAR v_log_gera_cpo             AS LOGICAL                                                       NO-UNDO.
DEF VAR v_num_refer                AS INTEGER                                                       NO-UNDO.
DEF VAR v_vlr_liq_extra            LIKE movto_tit_acr.val_juros                                     NO-UNDO.
DEF VAR v_vlr_jur_multa            LIKE movto_tit_acr.val_juros                                     NO-UNDO.
DEF VAR v_vlr_descto_abat          LIKE movto_tit_acr.val_juros                                     NO-UNDO.
DEF VAR v_orig_an_devol            AS LOGICAL INITIAL NO                                            NO-UNDO.
                                                          
DEF TEMP-TABLE tt_erro
     FIELD cod_estab               LIKE tit_acr.cod_estab                        
     FIELD cod_especie             LIKE tit_acr.cod_espec_docto                        
     FIELD serie                   LIKE tit_acr.cod_ser_docto                              
     FIELD cod_tit_acr             LIKE tit_acr.cod_tit_acr                              
     FIELD cod_parcela             LIKE tit_acr.cod_parcela                              
     FIELD cdn_repres              LIKE tit_acr.cdn_repres                               
     FIELD nom_repres              LIKE representante.nom_abrev                          
     FIELD dat_transacao           LIKE movto_tit_acr.dat_transacao                      
     FIELD trans_abrev             LIKE movto_tit_acr.ind_trans_acr_abrev                
     FIELD cod_refer               LIKE movto_tit_acr.num_id_movto_tit_acr 
     FIELD vlr_trans               LIKE movto_tit_acr.val_movto_tit_acr                  
     FIELD mensagem                AS CHAR FORMAT "x(145)".

FOR EACH tt_erro:
  DELETE tt_erro.
END.

