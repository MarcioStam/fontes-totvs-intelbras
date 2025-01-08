/*****************************************************************************
** Programa..............: epc_matriz.p
** Descricao.............: Bloqueio cadastro de PJ pelo EMS5
** Criado em.............: 03/06/2009
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

/* ** EPC relacionada aos programas:
Manuten‡Æo Pessoa Jur¡dica
utb006ca
***/

case p_ind_event:
    when "VALIDATE" 
    then do:
         MESSAGE "Manuten‡Æo dever  ser efetuada pelo EMS2."
           VIEW-AS ALERT-BOX INFO BUTTONS OK.
         RETURN "NOK".
    end.
end case.
