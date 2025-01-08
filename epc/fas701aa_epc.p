/*****************************************************************************
** Programa..............: fas701aa_epc.p - bas_bem_pat
** Autor.................: Sensus Tecnologia
** Criado em.............: 21/06/2013
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

def new global shared var v_rec_bem_pat     as RECID format ">>>>>>9" initial ? no-undo.
def new global shared var v_rec_bem_pat_epc as RECID format ">>>>>>9" initial ? no-undo.

if  p_ind_event = "INITIALIZE" then do:
    create button wh_button
    assign frame      = p_wgh_frame
           width      = 4
           height     = 1.08
           row        = 1.13
           col        = 65
           sensitive  = yes
           visible    = yes
           tooltip    = "Aloca‡äes"
           triggers:
               on choose persistent run prgfin/fas/fas722aa.r.
           end triggers.

    wh_button:load-image("image/im-aloca.bmp":U).

    create button wh_button
    assign frame      = p_wgh_frame
           width      = 4
           height     = 1.08
           row        = 1.13
           col        = 69
           sensitive  = yes
           visible    = yes
           tooltip    = "Informa‡äes Complementares"
           triggers:
               on choose persistent run epc/fas211aa1_epc.p.
           end triggers.

    wh_button:load-image("image/im-param.bmp":U).

end.

IF p_ind_event = "DISPLAY" 
   THEN ASSIGN v_rec_bem_pat     = p_rec_table
               v_rec_bem_pat_epc = p_rec_table.
