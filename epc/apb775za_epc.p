/*****************************************************************************
** Programa..............: apb775za_epc.p.p
** Descricao.............: EPC do programa de varredura de sacado
** Criado em.............: 30/07/2020
*****************************************************************************/

def input param p_ind_event       as char           no-undo.
def input param p_ind_object      as char           no-undo.
def input param p_wgh_object      as handle         no-undo.
def input param p_wgh_frame       as widget-handle  no-undo.
def input param p_cod_table       as char           no-undo.
def input param p_rec_table       as recid          no-undo.

def new global shared var v_rec_tit_ap
    as recid
    format ">>>>>>9":U
    initial ?
    no-undo.

def var wh_button_consulta as widget-handle no-undo.

/*
MESSAGE "p_ind_event "  p_ind_event  skip 
        "p_ind_object " p_ind_object skip
        "p_wgh_object " p_wgh_object skip
        "p_wgh_frame "  p_wgh_frame  skip
        "p_cod_table "  p_cod_table  skip
        "p_rec_table "  p_rec_table 
        VIEW-AS ALERT-BOX.
*/

IF   p_ind_event = "DISPLAY" THEN
     ASSIGN v_rec_tit_ap = ?.     

if  p_ind_event = "INITIALIZE" then do:

    create button wh_button_consulta
    assign frame      = p_wgh_frame
           NAME       = "bt_consulta_imp_esp"
           width      = 4.0
           height     = 1.08
           row        = 1.33
           col        = 80.2
           sensitive  = yes
           visible    = yes
           LABEL      = "Consulta Imposto lancto Nota"
           tooltip    = "Consulta Imposto lancto Nota"
           triggers:
               on CHOOSE PERSISTENT RUN epc/apb775za_epc_01.w.
           end triggers.

     wh_button_consulta:LOAD-IMAGE("image/intelbras/infopg.ico":U). 
END.
