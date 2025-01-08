/*****************************************************************************
** Programa..............: fgl020za1_epc.p
** Descricao.............: EPC do programa fgl020aa_epc.p
** Criado em.............: 07/11/2008
*****************************************************************************/

DEF VAR v_log_answer AS LOG NO-UNDO.
                   
def new global shared var v_rec_rat_ctbl
    as recid
    format ">>>>>>9"
    initial ?
    no-undo.

assign v_log_answer = no.

FIND rat_ctbl NO-LOCK
    WHERE RECID(rat_ctbl) = v_rec_rat_ctbl NO-ERROR. 
 IF NOT AVAIL rat_ctbl 
THEN DO:
     MESSAGE "Rateio n∆o Localizado !" VIEW-AS ALERT-BOX.
     RETURN "OK".
END.

message "Confirme eliminaá∆o de TODOS os Itens do Rateio Cont†bil ( " rat_ctbl.cod_rat_ctbl " ) ?"
       view-as alert-box question buttons yes-no-cancel update v_log_answer.

if  v_log_answer = yes
then do:
    delete_block:
    do on error undo delete_block, leave delete_block transaction:
        FOR EACH item_rat_ctbl OF rat_ctbl EXCLUSIVE-LOCK:
            DELETE item_rat_ctbl.
        END.
    end.
    MESSAGE "Rateio Eliminado !" VIEW-AS ALERT-BOX.
    RETURN "OK".
end.
ELSE RETURN "OK".
