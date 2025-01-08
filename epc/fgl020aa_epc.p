/*****************************************************************************
** Programa..............: fgl020aa_epc.p
** Descricao.............: EPC do programa bas_rat_ctbl
** Criado em.............: 07/11/2008
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

def new global shared var v_rec_rat_ctbl
    as recid
    format ">>>>>>9"
    initial ?
    no-undo.

if  p_ind_event = "INITIALIZE" then do:
    create button wh_button
    assign frame      = p_wgh_frame
           width      = 4
           height     = 1.13
           row        = 1.08
           col        = 60
           sensitive  = yes
           visible    = yes
           tooltip    = "Elimina Rateio"
           triggers:
               on choose persistent run epc/fgl020aa1_epc.p.
           end triggers.

    wh_button:load-image("image/im-dconc.bmp":U).

    /* Corrigir Tab Order */
    assign h_object = p_wgh_frame:first-child
           h_object = h_object:first-child
           h_prev   = ?
           h_next   = ?.
    do  while valid-handle(h_object):
        if  h_object:type <> "field_group" then do:
            case h_object:name:
                when "bt_cop1" then
                    assign h_prev = h_object.
                when "bt_exi" then
                    assign h_next = h_object.
            end case.
            assign h_object = h_object:next-sibling.
        end.
        else do:
            assign h_object = h_object:first-child.
        end.
        if  valid-handle(h_prev) and valid-handle(h_next) then
            leave.
    end.
    /* Corrigir Tab Order */
end.

if  p_ind_event = "DISPLAY" then
    assign v_rec_rat_ctbl = p_rec_table.

/* Fim */
