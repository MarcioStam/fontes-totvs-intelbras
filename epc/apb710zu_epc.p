/*****************************************************************************
** Programa..............: apb710zu_epc.p
** Descricao.............: EPC do programa fnc_fornec_financ_inc_rpda
** Criado em.............: 08/12/2010
*****************************************************************************/

def input param p_ind_event       as char           no-undo.
def input param p_ind_object      as char           no-undo.
def input param p_wgh_object      as handle         no-undo.
def input param p_wgh_frame       as widget-handle  no-undo.
def input param p_cod_table       as char           no-undo.
def input param p_rec_table       as recid          no-undo.

def temp-table tt_cdn_cliente no-undo
    field tta_cdn_cliente                  as Integer format ">>>,>>>,>>9" initial 0 label "Cliente" column-label "Cliente"
    field tta_num_pessoa                   as integer format ">>>,>>>,>>9" initial ? label "Pessoa" column-label "Pessoa"
    index tt_id                            is primary unique
          tta_cdn_cliente                  ascending.

def temp-table tt_cdn_fornecedor no-undo
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field tta_num_pessoa                   as integer format ">>>,>>>,>>9" initial ? label "Pessoa" column-label "Pessoa"
    index tt_id                            is primary unique
          tta_cdn_fornecedor               ascending.

DEFINE VARIABLE v_nom_arq_temp AS CHARACTER   NO-UNDO.

def new global shared var v_des_contdo_prog_valid_dtsul
    as character
    format "x(40)":U
    no-undo.


IF p_ind_event = "VALIDATE" 
THEN DO:

     ASSIGN v_des_contdo_prog_valid_dtsul = 'apb710zu_epc'.

     FIND fornec_financ NO-LOCK
         WHERE RECID(fornec_financ) = p_rec_table NO-ERROR.

     FIND emscad.fornecedor OF fornec_financ EXCLUSIVE-LOCK.

     IF AVAIL fornec_financ
     THEN DO:
    
          ASSIGN v_nom_arq_temp = SESSION:TEMP-DIRECTORY + "cdapi366.txt".
          IF SEARCH(v_nom_arq_temp) <> "" THEN OS-DELETE VALUE(v_nom_arq_temp).
          RUN prgint/utb/utb704zc.py (INPUT "Fornecedor Financeiro",
                                      INPUT 0,
                                      INPUT 0,
                                      INPUT RECID(fornec_financ),
                                      INPUT 1,
                                      INPUT YES,
                                      INPUT "Arquivo",
                                      INPUT SESSION:TEMP-DIRECTORY + "cdapi366.txt",
                                      INPUT "On-Line",
                                      INPUT TABLE tt_cdn_cliente,
                                      INPUT TABLE tt_cdn_fornecedor,
                                      INPUT fornec_financ.cod_empresa).
    
     END.

     ASSIGN v_des_contdo_prog_valid_dtsul = ''.

END.
