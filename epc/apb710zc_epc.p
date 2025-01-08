/*****************************************************************************
** Programa..............: apb710zc_epc.p
** Descricao.............: EPC do programa fnc_item_bord_ap_inclui_indiv
** Criado em.............: 25/11/2004
*****************************************************************************/

def input param p_ind_event       as char           no-undo.
def input param p_ind_object      as char           no-undo.
def input param p_wgh_object      as handle         no-undo.
def input param p_wgh_frame       as widget-handle  no-undo.
def input param p_cod_table       as char           no-undo.
def input param p_rec_table       as recid          no-undo.
                               
define variable h_object          as widget-handle  no-undo.
define variable h_prev            as widget-handle  no-undo.
define variable h_next            as widget-handle  no-undo.

def new global shared var wh_button1     as widget-handle no-undo.
def new global shared var wh_bt_orig1    as widget-handle no-undo.
def new global shared var p_cod_num_bcio as character     no-undo.
def new global shared var p_cod_barra    as character     no-undo.

case p_ind_event:
    when "INITIALIZE" then do:
        create button wh_button1
        assign frame     = p_wgh_frame
               width     = 13
               height    = 1
               row       = 16.5
               col       = 2
               label     = "Cod Barras"
               sensitive = yes
               visible   = yes
               tooltip   = "Informa C¢digo de Barras"
               triggers:
                   on choose 
                         persistent run epc/epc002aa.p.  
               end triggers.

        /* Corrigir Tab Order */
        assign h_object = p_wgh_frame:first-child
               h_object = h_object:first-child
               h_prev   = ?
               h_next   = ?.
        do  while valid-handle(h_object):
            if  h_object:type <> "field_group" then do:
                case h_object:name:
                    when "bt_taxa_juros" then
                        assign h_prev = h_object.
                    when "bt_val_liquido" then
                        assign h_next = h_object.
                    when "bt_cod_barra" then
                        assign wh_bt_orig1 = h_object.
                end case.
                assign h_object = h_object:next-sibling.
            end.
            else do:
                assign h_object = h_object:first-child.
            end.
            if  valid-handle(h_prev) and valid-handle(h_next) then
                leave.
        end.
        wh_button1:move-after-tab-item(h_prev).
        wh_button1:move-before-tab-item(h_next).
        /* Corrigir Tab Order */
    end.
    when "ENABLE" then do:
        if  wh_bt_orig1:sensitive then
            assign wh_button1:sensitive = yes.
        else
            assign wh_button1:sensitive = no.
/*        assign p_cod_barra    = ""
               p_cod_num_bcio = "". */
    end.
    when "ENABLE_MOD" then do:
        if  wh_bt_orig1:sensitive then
            assign wh_button1:sensitive = yes.
        else
            assign wh_button1:sensitive = no.

        FIND item_bord_ap WHERE RECID(item_bord_ap) = p_rec_table NO-LOCK NO-ERROR.
        IF AVAIL item_bord_ap 
        THEN DO:
             FIND tit_ap NO-LOCK 
                 WHERE tit_ap.cod_estab       = item_bord_ap.cod_estab
                   AND tit_ap.cod_espec_docto = item_bord_ap.cod_espec_docto
                   AND tit_ap.cdn_fornecedor  = item_bord_ap.cdn_fornecedor
                   AND tit_ap.cod_ser_docto   = item_bord_ap.cod_ser_docto
                   AND tit_ap.cod_tit_ap      = item_bord_ap.cod_tit_ap
                   AND tit_ap.cod_parcela     = item_bord_ap.cod_parcela NO-ERROR.
             IF AVAIL tit_ap 
             THEN DO:
                  ASSIGN p_cod_barra    = tit_ap.cb4_tit_ap_bco_cobdor
                         p_cod_num_bcio = tit_ap.cod_tit_ap_bco_cobdor.
             END.
             ELSE DO:
                  FIND antecip_pef_pend NO-LOCK
                       WHERE antecip_pef_pend.cod_estab = item_bord_ap.cod_estab
                         AND antecip_pef_pend.cod_refer = item_bord_ap.cod_refer_antecip_pef NO-ERROR.
                  IF AVAIL antecip_pef_pend
                  THEN DO:
                       ASSIGN p_cod_barra    = antecip_pef_pend.cb4_tit_ap_bco_cobdor
                              p_cod_num_bcio = antecip_pef_pend.cod_tit_ap_bco_cobdor.
                  END.
             END.
        END.
        ELSE DO:
             ASSIGN p_cod_barra    = ""
                    p_cod_num_bcio = "".
        END.

    end.
    when "leave_item_bord_ap.cod_forma_pagto" then do:
        if  wh_bt_orig1:sensitive then
            assign wh_button1:sensitive = yes.
        else
            assign wh_button1:sensitive = no.
    end.
    when "ASSIGN" then do:
        FIND item_bord_ap WHERE RECID(item_bord_ap) = p_rec_table NO-LOCK NO-ERROR.
        IF AVAIL item_bord_ap 
        THEN DO:
             FIND tit_ap EXCLUSIVE-LOCK 
                 WHERE tit_ap.cod_estab       = item_bord_ap.cod_estab
                   AND tit_ap.cod_espec_docto = item_bord_ap.cod_espec_docto
                   AND tit_ap.cdn_fornecedor  = item_bord_ap.cdn_fornecedor
                   AND tit_ap.cod_ser_docto   = item_bord_ap.cod_ser_docto
                   AND tit_ap.cod_tit_ap      = item_bord_ap.cod_tit_ap
                   AND tit_ap.cod_parcela     = item_bord_ap.cod_parcela NO-ERROR.
             IF AVAIL tit_ap 
             THEN DO:
                  ASSIGN tit_ap.cb4_tit_ap_bco_cobdor = p_cod_barra   
                         tit_ap.cod_tit_ap_bco_cobdor = p_cod_num_bcio.
             END.
             ELSE DO:
                  FIND antecip_pef_pend EXCLUSIVE-LOCK
                       WHERE antecip_pef_pend.cod_estab = item_bord_ap.cod_estab
                         AND antecip_pef_pend.cod_refer = item_bord_ap.cod_refer_antecip_pef NO-ERROR.
                  IF AVAIL antecip_pef_pend
                  THEN DO:
                       ASSIGN antecip_pef_pend.cb4_tit_ap_bco_cobdor = p_cod_barra
                              antecip_pef_pend.cod_tit_ap_bco_cobdor = p_cod_num_bcio.
                  END.
             END.
        END.

    end.
end case.

/* Fim */
