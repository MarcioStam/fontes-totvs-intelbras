
/*****************************************************************************
** Programa..............: acr702da_epc.p
** Autor.................: Andrey Mauricio de Oliveira
** Criado em.............: 04/06/2019
*****************************************************************************/

def input param p_ind_event       as char           no-undo.
def input param p_ind_object      as char           no-undo.
def input param p_wgh_object      as handle         no-undo.
def input param p_wgh_frame       as widget-handle  no-undo.
def input param p_cod_table       as char           no-undo.
def input param p_rec_table       as recid          no-undo.

define variable wh_button         as widget-handle  no-undo.
define variable h_object          as widget-handle  no-undo.
define variable h_prev            as widget-handle  no-undo.
define variable h_next            as widget-handle  no-undo.

DEF NEW GLOBAL SHARED VAR h_val_cotac_indic_econ_acr AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR h_cod_indic_econ           AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR h_acr702da_epc             AS HANDLE        NO-UNDO.

IF  p_ind_event = "INITIALIZE" THEN DO:
    RUN epc/acr702da_epc_01.p PERSISTENT SET h_acr702da_epc(INPUT p_ind_event,
                                                            INPUT p_ind_object,
                                                            INPUT p_wgh_object,
                                                            INPUT p_wgh_frame,
                                                            INPUT p_cod_table,
                                                            INPUT p_rec_table).

    RUN piFindWidget(INPUT "v_val_cotac_indic_econ_acr", 
                     INPUT "fill-in", 
                     INPUT  p_wgh_frame, 
                     OUTPUT h_val_cotac_indic_econ_acr).

    RUN piFindWidget(INPUT "cod_indic_econ", 
                     INPUT "fill-in", 
                     INPUT  p_wgh_frame, 
                     OUTPUT h_cod_indic_econ).

    ON "LEAVE" OF h_cod_indic_econ PERSISTENT RUN pi_leave_indic_econ IN h_acr702da_epc.
    
END.

PROCEDURE piFindWidget:
    DEFINE INPUT  PARAMETER c-widget-name  AS CHAR   NO-UNDO.
    DEFINE INPUT  PARAMETER c-widget-type  AS CHAR   NO-UNDO.
    DEFINE INPUT  PARAMETER h-start-widget AS HANDLE NO-UNDO.
    DEFINE OUTPUT PARAMETER h-widget       AS HANDLE NO-UNDO.

    DO WHILE VALID-HANDLE(h-start-widget):
        IF  h-start-widget:NAME = c-widget-name 
        AND h-start-widget:TYPE = c-widget-type THEN DO:
            ASSIGN h-widget = h-start-widget:HANDLE.
            LEAVE.
        end.

        IF  h-start-widget:TYPE = "field-group":u 
        OR  h-start-widget:TYPE = "frame":u 
        OR  h-start-widget:TYPE = "dialog-box":u THEN DO:
            RUN piFindWidget (INPUT  c-widget-name,
                              INPUT  c-widget-type,
                              INPUT  h-start-widget:FIRST-CHILD,
                              OUTPUT h-widget).

            IF  VALID-HANDLE(h-widget) THEN
                LEAVE.
        END.

        ASSIGN h-start-widget = h-start-widget:NEXT-SIBLING.
    END.
END PROCEDURE.
