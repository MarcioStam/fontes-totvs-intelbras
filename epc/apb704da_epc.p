/*****************************************************************************
** Programa..............: apb704da_epc.p
** Descricao.............: EPC do programa add_item_lote_impl_ap
** Criado em.............: 19/10/2004
*****************************************************************************/

def input param p_ind_event       as char           no-undo.
def input param p_ind_object      as char           no-undo.
def input param p_wgh_object      as handle         no-undo.
def input param p_wgh_frame       as widget-handle  no-undo.
def input param p_cod_table       as char           no-undo.
def input param p_rec_table       as recid          no-undo.
                               
define variable wh_button         as widget-handle  no-undo.
define variable h_object          as widget-handle  no-undo.
define variable h_prev            as widget-handle  no-undo.
define variable h_next            as widget-handle  no-undo.

def new global shared var wh_bt_orig     as widget-handle no-undo.
def new global shared var p_cod_num_bcio as character     no-undo.
def new global shared var p_cod_barra    as character     no-undo.

/* MESSAGE "p_ind_event dentro do apb704da_epc: " p_ind_event SKIP
        "tem initialize, enable, display e assign"
    VIEW-AS ALERT-BOX INFO BUTTONS OK. */
case p_ind_event:
    when "INITIALIZE" then do:
        create button wh_button
        assign frame     = p_wgh_frame
               width     = 12
               height    = 1
               row       = 15.50
               col       = if program-name(2) = "prgfin/apb/apb704da.p" then 75.57 else 76.43
               label     = "Cod Barras"
               sensitive = yes
               visible   = yes
               tooltip   = "Informa C¢digo de Barras"
               triggers:
                   on choose persistent run epc/epc002aa.p.
               end triggers.

        /* Corrigir Tab Order */
        assign h_object = p_wgh_frame:first-child
               h_object = h_object:first-child
               h_prev   = ?
               h_next   = ?.
        do  while valid-handle(h_object):
            if  h_object:type <> "field_group" then do:
                case h_object:name:
                    when "bt_abat_antecip" then
                        assign h_prev = h_object.
                    when "bt_vincul_nota" then
                        assign h_next = h_object.
                    when "bt_cod_barra" then
                        assign wh_bt_orig = h_object.
                end case.
                assign h_object = h_object:next-sibling.
            end.
            else do:
                assign h_object = h_object:first-child.
            end.
            if  valid-handle(h_prev) and valid-handle(h_next) then
                leave.
        end.
        wh_button:move-after-tab-item(h_prev).
        wh_button:move-before-tab-item(h_next).
        /* Corrigir Tab Order */
    end.
    when "ENABLE" then do:
        assign wh_bt_orig:sensitive = no.
    end.
    when "DISPLAY" then do:
        find item_lote_impl_ap where recid(item_lote_impl_ap) = p_rec_table no-lock no-error.
        if  avail item_lote_impl_ap then
            assign p_cod_barra    = item_lote_impl_ap.cb4_tit_ap_bco_cobdor
                   p_cod_num_bcio = item_lote_impl_ap.cod_tit_ap_bco_cobdor.
        else
            assign p_cod_barra    = ""
                   p_cod_num_bcio = "".
    end.
    when "ASSIGN" then do:
        find item_lote_impl_ap where recid(item_lote_impl_ap) = p_rec_table exclusive-lock no-error.
        if  avail item_lote_impl_ap then
            assign item_lote_impl_ap.cb4_tit_ap_bco_cobdor = p_cod_barra
                   item_lote_impl_ap.cod_tit_ap_bco_cobdor = p_cod_num_bcio.
    end.
end case.

/* Fim */
