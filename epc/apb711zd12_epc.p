/*****************************************************************************
** Programa..............: apb711zd4_epc.p
** Descricao.............: EPC do Evento RowDisplay do browse br_pagto_conjunto 
** do programa fnc_item_lote_pagto_inclui_conjto
** Criado em.............: 03/02/2014
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


FIND FIRST tit_ap 
     WHERE recid(tit_ap) = v_rec_tit_ap NO-LOCK NO-ERROR.

IF  AVAIL tit_ap THEN DO:
    FIND FIRST movto_tit_ap OF tit_ap NO-LOCK NO-ERROR.

    run prgfin/apb/apb222zc.p (buffer tit_ap,
                               buffer movto_tit_ap,
                               Input yes).
END.

RETURN "OK".
