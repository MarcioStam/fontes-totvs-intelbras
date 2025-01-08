/**************************************************** Initialize **********************************************************/
def temp-table tt_erros_conexao no-undo
    field ttv_cdn_erro                     as Integer format ">>>,>>9"
    field ttv_des_erro                     as character format "x(50)" label "Inconsistˆncia" column-label "Inconsistˆncia".

def var v_hdl_btb_connect as handle no-undo.
def var v_log_sucesso     as log    no-undo.
def new global shared var v_cod_empres_usuar
    as character
    format "x(3)":U
    label "Empresa"
    column-label "Empresa"
    no-undo.
def new global shared var v_cod_produt_corren
    as character
    format 'x(50)'
    no-undo.

DEF INPUT PARAM rmovto_repres_tit_acr   AS RECID.  /*Recid do movto_tit_acr ou do repres_tit_acr*/
DEF INPUT PARAM p-cta-aprop-acr         LIKE aprop_ctbl_acr.cod_cta_ctbl. /*Conta da apropria‡Æo contabil*/
DEF INPUT PARAM c_ind_trans_acr_abrev   LIKE movto_tit_acr.ind_trans_acr_abrev. /* Indica o ponto de onde ‚ chamado a rotina*/

/* ** Chamada Programa ******/
run esp/cms/escms005-1.p (input rmovto_repres_tit_acr,
                          input p-cta-aprop-acr,
                          input c_ind_trans_acr_abrev).

