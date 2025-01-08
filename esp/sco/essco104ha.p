/*****************************************************************************
** Programa..............: esp/sco/essco104ha.p
** Criado por............: Fabiano Zarpe Henke
** Criado em.............: 15/10/2008
*****************************************************************************/

/******************************* Private-Data *******************************/
assign this-procedure:private-data = "HLP=15":U.
/*************************************  *************************************/

/************************* Variable Definition Begin ************************/
def new global shared var v_rec_ext_admdra_cartao_cr_comis
    as recid
    format ">>>>>>9"
    no-undo.
def var v_rec_table
    as recid
    format ">>>>>>9"
    initial ?
    no-undo.
def var v_log_answer
    as logical
    format "Sim/N∆o"
    initial yes
    view-as toggle-box
    no-undo.

/************************** Variable Definition End *************************/


/****************************** Main Code Begin *****************************/

assign v_rec_table    = v_rec_ext_admdra_cartao_cr_comis
       v_log_answer   = no.

message substitute("Confirma eliminaá∆o da &1 ?" /*l_conf_erase*/ ,"Faixa de Comiss∆o")
       view-as alert-box question buttons yes-no-cancel title substitute("&1", "1.00.00.000") update v_log_answer.

if  v_log_answer = yes
then do:
    delete_block:
    do on error undo delete_block, leave delete_block transaction:
        find ext_admdra_cartao_cr_comis where recid(ext_admdra_cartao_cr_comis) = v_rec_table exclusive-lock no-error.
        delete ext_admdra_cartao_cr_comis.
        assign v_rec_ext_admdra_cartao_cr_comis = ?.
    end /* do delete_block */.
end /* if */.

/******************************* Main Code End ******************************/
