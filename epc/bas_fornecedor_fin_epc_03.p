/*****************************************************************************
** Programa..............: bas_fornecedor_fin_03.p
** Descricao.............: EPC para tratar bot∆o enter da consulta de 
**                         fornecedores.
** Criado em.............: 28/07/2020
*****************************************************************************/

DEF INPUT PARAM p_ind_event  AS CHAR          NO-UNDO.
DEF INPUT PARAM p_ind_object AS CHAR          NO-UNDO.
DEF INPUT PARAM p_wgh_object AS HANDLE        NO-UNDO.
DEF INPUT PARAM p_wgh_frame  AS WIDGET-HANDLE NO-UNDO.
DEF INPUT PARAM p_cod_table  AS CHAR          NO-UNDO.
DEF INPUT PARAM p_rec_table  AS RECID         NO-UNDO.

DEF NEW GLOBAL SHARED VAR wh_fornec_bas_fin     AS widget-handle no-undo.
DEF NEW GLOBAL SHARED VAR wh_new_fornec_bas_fin AS widget-handle no-undo.

DEF VAR v_aux_fornec_bas_fin AS CHAR NO-UNDO.

PROCEDURE pi_leave_fornec:
    IF  VALID-HANDLE(wh_fornec_bas_fin)
    AND VALID-HANDLE(wh_new_fornec_bas_fin) THEN DO:

        ASSIGN v_aux_fornec_bas_fin = REPLACE(wh_new_fornec_bas_fin:SCREEN-VALUE ,"/","").
        ASSIGN v_aux_fornec_bas_fin = REPLACE(v_aux_fornec_bas_fin ,".","").
        ASSIGN v_aux_fornec_bas_fin = REPLACE(v_aux_fornec_bas_fin ,"-","").

        ASSIGN wh_fornec_bas_fin:SCREEN-VALUE     = v_aux_fornec_bas_fin.
        ASSIGN wh_new_fornec_bas_fin:SCREEN-VALUE = v_aux_fornec_bas_fin.
    END.

    RETURN "OK":U.
END PROCEDURE.
