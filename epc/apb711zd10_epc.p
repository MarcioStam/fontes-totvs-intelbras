/*****************************************************************************
**
** Programa..............: apb711zd10_epc.p
**
** Descricao.............: EPC para tratamento da cota‡Æo £nica.
**
** Criado em.............: 16/10/2018
**
*****************************************************************************/

DEF NEW GLOBAL SHARED temp-table tt_item_cotacao no-undo
    FIELD num_id_reg AS INT.

DEFINE NEW GLOBAL SHARED VARIABLE h_br_dlg_item_bord_ap_cjto  AS widget-handle no-undo.

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

def var v_cotacao like item_bord_ap.val_cotac_indic_econ.

def frame f_cotacao
    v_cotacao
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
         title "Cota‡Æo énica".

assign bt_can:width-chars   in frame f_cotacao = 10.00
       bt_can:height-chars  in frame f_cotacao = 01.00
       bt_ok:width-chars    in frame f_cotacao = 10.00
       bt_ok:height-chars   in frame f_cotacao = 01.00.

do  on error undo, retry on endkey undo, leave:
    view frame f_cotacao.
    
    display v_cotacao
            bt_can
            bt_ok
            with frame f_cotacao.
    
    enable all with frame f_cotacao.
    wait-for go of frame f_cotacao.
    
    assign v_cotacao.
    
    FOR EACH tt_item_cotacao:
        FIND FIRST item_bord_ap
            WHERE item_bord_ap.num_id_item_bord_ap = tt_item_cotacao.num_id_reg EXCLUSIVE-LOCK NO-ERROR.
    
        IF  AVAIL item_bord_ap THEN DO:
            find first bord_ap 
                 where bord_ap.cod_estab_bord  = item_bord_ap.cod_estab_bord
                 and   bord_ap.cod_portador    = item_bord_ap.cod_portador  
                 and   bord_ap.num_bord_ap     = item_bord_ap.num_bord_ap no-lock no-error.

            IF  bord_ap.cod_indic_econ = "Real" THEN
                ASSIGN item_bord_ap.val_cotac_indic_econ = round(1 / v_cotacao,10)
                       item_bord_ap.val_pagto            = item_bord_ap.val_pagto_orig / item_bord_ap.val_cotac_indic_econ.
            ELSE
                ASSIGN item_bord_ap.val_cotac_indic_econ = v_cotacao.
        END.
    END.

    EMPTY TEMP-TABLE tt_item_cotacao.

    h_br_dlg_item_bord_ap_cjto:REFRESH().
end.
