/*****************************************************************************
** Programa..............: acr702da_epc_01.p
** Autor.................: Andrey M Oliveira
** Criado em.............: 06/06/2019
*****************************************************************************/

DEF INPUT PARAM p_ind_event       AS CHAR           NO-UNDO.
DEF INPUT PARAM p_ind_object      AS CHAR           NO-UNDO.
DEF INPUT PARAM p_wgh_object      AS HANDLE         NO-UNDO.
DEF INPUT PARAM p_wgh_frame       AS WIDGET-HANDLE  NO-UNDO.
DEF INPUT PARAM p_cod_table       AS CHAR           NO-UNDO.
DEF INPUT PARAM p_rec_table       AS RECID          NO-UNDO.

DEF NEW GLOBAL SHARED VAR h_cod_indic_econ           AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR h_val_cotac_indic_econ_acr AS WIDGET-HANDLE NO-UNDO.

PROCEDURE pi_leave_indic_econ:

    RUN pi_leave_cod_indic_econ_add IN p_wgh_object.

    IF  VALID-HANDLE(h_val_cotac_indic_econ_acr) 
    AND h_cod_indic_econ:SCREEN-VALUE <> "Real" THEN
        ASSIGN h_val_cotac_indic_econ_acr:SENSITIVE = NO.

END PROCEDURE.
