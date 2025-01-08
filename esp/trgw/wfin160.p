/*** Historico de altera‡Æo ********
     Trigger tabela item_lancto_ctbl
****/   

DEF PARAM BUFFER b_item_lancto_ctbl     FOR item_lancto_ctbl.
DEF PARAM BUFFER b_old_item_lancto_ctbl FOR item_lancto_ctbl.

DEF BUFFER b_lote_ctbl FOR lote_ctbl.

def new global shared var v_cod_usuar_corren
    as character
    format "x(12)":U
    label "Usu rio Corrente"
    column-label "Usu rio Corrente"
    no-undo.
DEFINE VARIABLE v_des_histor AS CHARACTER   NO-UNDO.

FUNCTION Verifica_Program_Name RETURN LOG (INPUT Programa AS CHAR, INPUT Repeticoes AS INT):
    DEF VAR v_num_cont  AS INTEGER NO-UNDO.
    DEF VAR v_log_achou AS LOGICAL NO-UNDO.

    assign  v_num_cont  = 1
            v_log_achou = no.
    bloco:
    repeat:
        if index(program-name(v_num_cont),Programa) = ? then 
            leave bloco.
        if index(program-name(v_num_cont),Programa) <> 0 then do:
            assign v_log_achou = yes.
            leave bloco.
        end.
        if v_num_cont = Repeticoes then
            leave bloco.
        assign v_num_cont = v_num_cont + 1.
    end.

    RETURN v_log_achou.

END FUNCTION.

IF Verifica_Program_Name('fgl702zl':U, 5) 
OR Verifica_Program_Name('fgl201za':U, 5) 
OR Verifica_Program_Name('fgl201zm':U, 5) 
OR Verifica_Program_Name('fgl201zh':U, 5) 
OR Verifica_Program_Name('twfin161':U, 5) 
OR Verifica_Program_Name('fgl712za':U, 5) 
   THEN RETURN "OK".
 
FIND b_lote_ctbl OF b_item_lancto_ctbl NO-LOCK NO-ERROR.

IF  AVAIL b_lote_ctbl
AND b_lote_ctbl.cod_modul_dtsul = "FGL" 
THEN DO:
     FIND int_item_lancto_ctbl OF b_item_lancto_ctbl EXCLUSIVE-LOCK NO-ERROR.
     IF NOT AVAIL int_item_lancto_ctbl 
     THEN DO:
          CREATE int_item_lancto_ctbl.
          ASSIGN int_item_lancto_ctbl.num_lote_ctbl       = b_item_lancto_ctbl.num_lote_ctbl      
                 int_item_lancto_ctbl.num_lancto_ctbl     = b_item_lancto_ctbl.num_lancto_ctbl    
                 int_item_lancto_ctbl.num_seq_lancto_ctbl = b_item_lancto_ctbl.num_seq_lancto_ctbl.
     END.
     ASSIGN int_item_lancto_ctbl.cod_usuar_ult_atualiz = v_cod_usuar_corren
            int_item_lancto_ctbl.dat_ult_atualiz       = TODAY
            int_item_lancto_ctbl.hra_ult_atualiz       = REPLACE(STRING(TIME,"hh:mm:ss"),":","").
END.

RETURN 'OK'.
