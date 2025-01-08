/*****************************************************************************
**
** Programa..............: apb711zd8_epc.p
**
** Descricao.............: EPC do Evento do browse br_dlg_liberados do 
**                         programa fnc_item_lote_pagto_inclui_conjto.
**
** Criado em.............: 15/12/2017
**
*****************************************************************************/

def input param p_ind_event       as char           no-undo.
def input param p_ind_object      as char           no-undo.
def input param p_wgh_object      as handle         no-undo.
def input param p_wgh_frame       as widget-handle  no-undo.
def input param p_cod_table       as char           no-undo.
def input param p_rec_table       as recid          no-undo.

def var c-objeto as char no-undo.

assign c-objeto = entry(num-entries(p_wgh_object:private-data, "~/"), p_wgh_object:private-data, "~/").

DEFINE NEW GLOBAL SHARED VARIABLE h_br_dlg_liberados  AS widget-handle no-undo.
DEFINE NEW GLOBAL SHARED VARIABLE r-tit_ap_global  AS ROWID no-undo.
DEFINE NEW GLOBAL SHARED VARIABLE wgh-query        AS widget-handle no-undo.
DEFINE NEW GLOBAL SHARED VARIABLE hitem_bord_ap    AS widget-handle no-undo.
DEFINE NEW GLOBAL SHARED VARIABLE l-todos-apb711zd AS LOG INIT NO   NO-UNDO.

DEFINE VARIABLE l-desconsidera          AS LOGICAL     NO-UNDO.
DEFINE VARIABLE v_log_return            AS LOGICAL     NO-UNDO.
DEFINE VARIABLE wgh_rec_proces_pagto    AS HANDLE NO-UNDO.

DEF VAR i-linha AS INT NO-UNDO.

def new global shared var v_cod_empres_usuar
    as character
    format "x(3)":U
    label "Empresa"
    column-label "Empresa"
    no-undo.
def var v_cod_return
    as character
    format "x(40)":U
    no-undo.

DEF NEW GLOBAL SHARED temp-table tt_tot_selec no-undo
    FIELD num_id_reg     AS INT
    FIELD rec_reg        AS RECID
    FIELD val_pagto      AS DEC  FORMAT ">>,>>>,>>>,>>9.99" 
    FIELD cod_indic_econ AS CHAR FORMAT "x(8)"
    INDEX indic_econ
          cod_indic_econ ASCENDING.

PROCEDURE pi_cria_reg_unico:
    DEF VAR i AS INTEGER NO-UNDO.
    DEF VAR hquery          AS HANDLE NO-UNDO.

    FOR EACH tt_tot_selec:
        DELETE tt_tot_selec.
    END.

    ASSIGN hquery        = h_br_dlg_liberados:QUERY 
           hitem_bord_ap = hquery:GET-BUFFER-HANDLE(1).

    ASSIGN wgh_rec_proces_pagto = hitem_bord_ap:BUFFER-FIELD("ttv_rec_item_lote_pagto") .

    FIND FIRST proces_pagto
        WHERE recid(proces_pagto) = wgh_rec_proces_pagto:BUFFER-VALUE NO-LOCK NO-ERROR.

    IF  AVAIL proces_pagto THEN DO:
        CREATE tt_tot_selec.
        ASSIGN tt_tot_selec.rec_reg        = recid(proces_pagto)
               tt_tot_selec.val_pagto      = proces_pagto.val_liberd_pagto
               tt_tot_selec.cod_indic_econ = proces_pagto.cod_indic_econ.
    END.
END.

PROCEDURE pi_cria_reg_multiplo:
    DEF VAR i AS INTEGER NO-UNDO.
    DEF VAR hquery          AS HANDLE NO-UNDO.

    ASSIGN hquery        = h_br_dlg_liberados:QUERY 
           hitem_bord_ap = hquery:GET-BUFFER-HANDLE(1).

    ASSIGN wgh_rec_proces_pagto = hitem_bord_ap:BUFFER-FIELD("ttv_rec_item_lote_pagto") .

    FIND FIRST proces_pagto
        WHERE recid(proces_pagto) = wgh_rec_proces_pagto:BUFFER-VALUE NO-LOCK NO-ERROR.

    IF  AVAIL proces_pagto THEN DO:

        FIND FIRST tt_tot_selec
            WHERE tt_tot_selec.rec_reg = recid(proces_pagto) EXCLUSIVE-LOCK NO-ERROR.

        IF  NOT AVAIL tt_tot_selec THEN DO:
            CREATE tt_tot_selec.
            ASSIGN tt_tot_selec.rec_reg        = recid(proces_pagto)
                   tt_tot_selec.val_pagto      = proces_pagto.val_liberd_pagto
                   tt_tot_selec.cod_indic_econ = proces_pagto.cod_indic_econ.
        END.
    END.
END.
