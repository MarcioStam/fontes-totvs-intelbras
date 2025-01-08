/*****************************************************************************
** Programa..............: fas702ea_epc_01.p
** Descricao.............: EPC do programa isl_bem_pat_baixa
** Criado em.............: 17/09/2018
*****************************************************************************/

DEF INPUT PARAM p_ind_event  AS CHAR          NO-UNDO.
DEF INPUT PARAM p_ind_object AS CHAR          NO-UNDO.
DEF INPUT PARAM p_wgh_object AS HANDLE        NO-UNDO.
DEF INPUT PARAM p_wgh_frame  AS WIDGET-HANDLE NO-UNDO.
DEF INPUT PARAM p_cod_table  AS CHAR          NO-UNDO.
DEF INPUT PARAM p_rec_table  AS RECID         NO-UNDO.

DEF VAR h_object       AS WIDGET-HANDLE  NO-UNDO.

DEF NEW GLOBAL SHARED VAR h_ind_motiv_bxa           AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR h_ind_tip_bxa_bem_pat     AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR h_dat_movto_bem_pat       AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh_ind_motiv_bxa_fas702ea AS WIDGET-HANDLE NO-UNDO.


PROCEDURE pi_trata_motivo:
    
    IF  VALID-HANDLE(h_ind_motiv_bxa) THEN DO:
        ASSIGN h_ind_motiv_bxa:SENSITIVE = NO.

        IF  wh_ind_motiv_bxa_fas702ea:SCREEN-VALUE = "N∆o Localizado/Doado" THEN
            ASSIGN h_ind_motiv_bxa:SCREEN-VALUE = "Inutilizaá∆o".

        IF  wh_ind_motiv_bxa_fas702ea:SCREEN-VALUE = "Sem Condiá∆o de Uso" THEN
            ASSIGN h_ind_motiv_bxa:SCREEN-VALUE = "Exaust∆o".

        IF  wh_ind_motiv_bxa_fas702ea:SCREEN-VALUE <> "N∆o Localizado/Doado" 
        AND wh_ind_motiv_bxa_fas702ea:SCREEN-VALUE <> "Sem Condiá∆o de Uso" THEN
            ASSIGN h_ind_motiv_bxa:SCREEN-VALUE = wh_ind_motiv_bxa_fas702ea:SCREEN-VALUE.
    END.

END PROCEDURE.

PROCEDURE pi_trata_leave_1:

    IF  VALID-HANDLE(h_dat_movto_bem_pat) THEN DO:
        APPLY "ENTRY" TO h_dat_movto_bem_pat.
        RETURN NO-APPLY.
    END.

END PROCEDURE.

PROCEDURE pi_trata_leave_2:

    IF  VALID-HANDLE(h_ind_motiv_bxa) THEN
        ASSIGN h_ind_motiv_bxa:SENSITIVE = NO.

    IF  VALID-HANDLE(wh_ind_motiv_bxa_fas702ea) THEN DO:        

        IF  wh_ind_motiv_bxa_fas702ea:SCREEN-VALUE = "" 
        OR  wh_ind_motiv_bxa_fas702ea:SCREEN-VALUE = ? THEN
            ASSIGN wh_ind_motiv_bxa_fas702ea:SCREEN-VALUE = "N∆o Localizado/Doado".

        APPLY "ENTRY" TO wh_ind_motiv_bxa_fas702ea.
    END.

    RETURN NO-APPLY.
END PROCEDURE.
