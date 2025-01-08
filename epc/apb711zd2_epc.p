def new shared temp-table tt_erros_inform_bcia_fornec         like fornec_financ
    field tta_nom_abrev                    as character format "x(15)" label "Nome Abreviado" column-label "Nome Abreviado"
    field tta_cod_digito_agenc_bcia        as character format "x(2)" label "D°gito Ag Bcia" column-label "Dig Ag"
    field tta_ind_tip_forma_pagto          as character format "X(22)" label "Tipo Forma Pagto" column-label "Tipo Forma Pagto"
    field ttv_log_pagto_agrup              as logical format "Sim/N∆o" initial no label "Forma Pagto Agrup".

def new global shared var v_cod_empres_usuar
    as character
    format "x(3)":U
    label "Empresa"
    column-label "Empresa"
    no-undo.

def buffer b_fornecedor    for emscad.fornecedor.
def buffer b_fornec_financ for fornec_financ.


def button bt_ok
    label "OK"
    tooltip "OK"
    size 1 by 1
    auto-go.

def button bt_can
    label "Cancela"
    tooltip "Cancela"
    size 1 by 1
    auto-endkey.

def var v_cdn_fornecedor like fornec_financ.cdn_fornecedor.

def frame f_inf_bancarias
    v_cdn_fornecedor
         at row 1.42 col 02.00 bgcolor 7 
    bt_ok
         at row 02.63 col 02 font ?
         help "OK"
    bt_can
         at row 02.63 col 13 font ?
         help "Cancela"    
    with 1 down side-labels no-validate keep-tab-order three-d
         size-char 25 by 04 default-button bt_ok
         view-as dialog-box
         font 1 fgcolor ? bgcolor 8
         title "Informaá‰es Banc†rias".

assign bt_can:width-chars   in frame f_inf_bancarias = 10.00
       bt_can:height-chars  in frame f_inf_bancarias = 01.00
       bt_ok:width-chars    in frame f_inf_bancarias = 10.00
       bt_ok:height-chars   in frame f_inf_bancarias = 01.00.

do  on error undo, retry on endkey undo, leave:
    view frame f_inf_bancarias.
    display v_cdn_fornecedor
            bt_can
            bt_ok
            with frame f_inf_bancarias.
    enable all with frame f_inf_bancarias.
    wait-for go of frame f_inf_bancarias.
    assign v_cdn_fornecedor.
    
    find first b_fornecedor no-lock
         where b_fornecedor.cod_empresa    = v_cod_empres_usuar
           and b_fornecedor.cdn_fornecedor = v_cdn_fornecedor no-error.
           
    find first b_fornec_financ no-lock
         where b_fornec_financ.cod_empresa    = v_cod_empres_usuar
           and b_fornec_financ.cdn_fornecedor = v_cdn_fornecedor no-error.
    
    if not avail b_fornecedor
    or not avail b_fornec_financ
    then do:
         message 'Fornecedor n∆o localizado !' view-as alert-box.
         return.
    end.
    
    for each tt_erros_inform_bcia_fornec:
        delete tt_erros_inform_bcia_fornec.
    end.
    
    create tt_erros_inform_bcia_fornec.
    assign tt_erros_inform_bcia_fornec.cod_empresa               = v_cod_empres_usuar
           tt_erros_inform_bcia_fornec.cdn_fornecedor            = b_fornecedor.cdn_fornecedor
           tt_erros_inform_bcia_fornec.tta_nom_abrev             = b_fornecedor.nom_abrev
           tt_erros_inform_bcia_fornec.cod_banco                 = b_fornec_financ.cod_banco
           tt_erros_inform_bcia_fornec.cod_agenc_bcia            = b_fornec_financ.cod_Agenc_bcia
           tt_erros_inform_bcia_fornec.cod_cta_corren_bco        = b_fornec_financ.cod_cta_corren_bco
           tt_erros_inform_bcia_Fornec.cod_digito_cta_corren     = b_fornec_financ.cod_digito_cta_corre
           tt_erros_inform_bcia_fornec.tta_cod_digito_agenc_bcia = b_fornec_financ.cod_digito_agenc_bcia.
    
    run prgfin/apb/apb710zu.r (Input '').    
    
end.

hide frame f_dlg_03_item_lote_pagto_classif_02 no-pause.
