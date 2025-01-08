/*****************************************************************************
** Programa..............: add_lote_liquidac_acr_epc.p.p
** Descricao.............: EPC do programa de inclus∆o do lote de liquidaá∆o
**                         do ACR.
** Criado em.............: 18/02/2022
*****************************************************************************/

def input param p_ind_event       as char           no-undo.
def input param p_ind_object      as char           no-undo.
def input param p_wgh_object      as handle         no-undo.
def input param p_wgh_frame       as widget-handle  no-undo.
def input param p_cod_table       as char           no-undo.
def input param p_rec_table       as recid          no-undo.

DEF NEW GLOBAL SHARED VAR h_dat_gerac_lote_liquidac AS WIDGET-HANDLE NO-UNDO.

DEF VAR v_dat_ant AS DATE NO-UNDO.

/*
MESSAGE "p_ind_event "  p_ind_event  skip
        "p_ind_object " p_ind_object skip
        "p_wgh_object " p_wgh_object skip
        "p_wgh_frame "  p_wgh_frame  skip
        "p_cod_table "  p_cod_table  skip
        "p_rec_table "  p_rec_table 
        VIEW-AS ALERT-BOX.
*/

if  p_ind_event = "DISPLAY" then do:

    RUN piFindWidget(INPUT "dat_gerac_lote_liquidac", 
                     INPUT "fill-in", 
                     INPUT  p_wgh_frame, 
                     OUTPUT h_dat_gerac_lote_liquidac).

    IF  VALID-HANDLE(h_dat_gerac_lote_liquidac) THEN DO:
        RUN pi_busca_dia_util_ant (INPUT 1, /* dia util anterior */
                                   OUTPUT v_dat_ant).

        ASSIGN h_dat_gerac_lote_liquidac:SCREEN-VALUE = string(date(v_dat_ant)).
    END.
END.

PROCEDURE piFindWidget:
    define input  parameter c-widget-name  as char   no-undo.
    define input  parameter c-widget-type  as char   no-undo.
    define input  parameter h-start-widget as handle no-undo.
    define output parameter h-widget       as handle no-undo.

    do while valid-handle(h-start-widget):
        if  h-start-widget:name = c-widget-name 
        and h-start-widget:type = c-widget-type then do:
            assign h-widget = h-start-widget:handle.
            leave.
        end.

        if  h-start-widget:type = "field-group":u 
        or  h-start-widget:type = "frame":u 
        OR  h-start-widget:type = "dialog-box":u then do:
            run piFindWidget (input  c-widget-name,
                              input  c-widget-type,
                              input  h-start-widget:first-child,
                              output h-widget).

            if valid-handle(h-widget) then
                leave.
        end.
        assign h-start-widget = h-start-widget:next-sibling.
    end.

END PROCEDURE.

PROCEDURE pi_busca_dia_util_ant:
    DEF INPUT  PARAM p_num_dias     AS INT  NO-UNDO.
    DEF OUTPUT PARAM p_dat_util_ant AS DATE NO-UNDO.

    DEF VAR v_cont AS INT  NO-UNDO.

    ASSIGN v_cont         = 0
           p_dat_util_ant = TODAY.

    REPEAT WHILE v_cont < p_num_dias:

        ASSIGN p_dat_util_ant = p_dat_util_ant - 1.

        FIND FIRST dia_calend_glob
            WHERE dia_calend_glob.cod_calend = "Fiscal":U
            AND   dia_calend_glob.dat_calend = p_dat_util_ant NO-LOCK NO-ERROR.

        IF  dia_calend_glob.log_dia_util THEN
            ASSIGN v_cont = v_cont + 1.
        ELSE
            NEXT.
    END.
END PROCEDURE.
