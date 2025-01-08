/*****************************************************************************
** Programa..............: apb710zd_epc.p
** Descricao.............: EPC do programa bas_bord_ap
** Criado em.............: 30/12/2010
*****************************************************************************/

def input param p_ind_event       as char           no-undo.
def input param p_ind_object      as char           no-undo.
def input param p_wgh_object      as handle         no-undo.
def input param p_wgh_frame       as widget-handle  no-undo.
def input param p_cod_table       as char           no-undo.
def input param p_rec_table       as recid          no-undo.

define variable wh_button         as widget-handle  no-undo.
define variable wh_button2        as widget-handle  no-undo.
define variable h_object          as widget-handle  no-undo.
define variable h_prev            as widget-handle  no-undo.
define variable h_next            as widget-handle  no-undo.

/* ** Desabilitado a altera‡Æo das informa‡äes banc rias, pois neste ponto nao replica para o EMS2
      Deve ser alterado pela tela de sele‡Æo em conjunto, a qual possui EPC para esta replica‡Æo ***/
if  p_ind_event = "display" then do:

    /* Corrigir Tab Order bt_manut_esp */
    assign h_object = p_wgh_frame:first-child
           h_object = h_object:first-child
           h_prev   = ?
           h_next   = ?.
    do  while valid-handle(h_object):
        if  h_object:type <> "field_group" then do:
            case h_object:name:
                when "bt_inform_bco" then
                    assign h_prev = h_object.
            end case.
            assign h_object = h_object:next-sibling.
        end.
        else do:
             assign h_object = h_object:first-child.
        end.
        if  valid-handle(h_prev) then
            leave.
    end.

    h_prev:SENSITIVE = NO.

end.
