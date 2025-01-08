/*****************************************************************************
** Programa..............: fas716ca_epc.p - rpt_bem_pat_pis_cofins
** Autor.................: Andrey M Oliveira
** Criado em.............: 20/08/2018.
*****************************************************************************/

DEF INPUT PARAM p_ind_event       AS CHAR           NO-UNDO.
DEF INPUT PARAM p_ind_object      AS CHAR           NO-UNDO.
DEF INPUT PARAM p_wgh_object      AS HANDLE         NO-UNDO.
DEF INPUT PARAM p_wgh_frame       AS WIDGET-HANDLE  NO-UNDO.
DEF INPUT PARAM p_cod_table       AS CHAR           NO-UNDO.
DEF INPUT PARAM p_rec_table       AS RECID          NO-UNDO.

DEFINE NEW GLOBAL SHARED VAR h_cod_cta_pat                 AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR h_cod_localiz                 AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR h_cod_estab                   AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR h_f_dlg_01_bem_pat_transf_ext AS WIDGET-HANDLE NO-UNDO.

DEF VAR h_fas716ca_epc AS HANDLE NO-UNDO.


MESSAGE "p_ind_event  "   p_ind_event     skip
        "p_ind_object "   p_ind_object    skip
        "p_wgh_object "   p_wgh_object    skip
        "p_wgh_frame  "   p_wgh_frame     skip
        "p_cod_table  "   p_cod_table     skip
        "p_rec_table  "   p_rec_table  
         VIEW-AS ALERT-BOX.


IF  p_ind_event = "INITIALIZE" THEN DO:
    IF  NOT valid-handle(h_fas716ca_epc) THEN
        RUN epc/fas716ca_epc_01.r PERSISTENT SET h_fas716ca_epc (input p_ind_event,
                                                                 input p_ind_object,
                                                                 input p_wgh_object,
                                                                 input p_wgh_frame,
                                                                 input p_cod_table,
                                                                 input p_rec_table).
    RUN piFindWidget(INPUT "cod_cta_pat", 
                     INPUT "fill-in", 
                     INPUT  p_wgh_frame, 
                     OUTPUT h_cod_cta_pat).

    IF  VALID-HANDLE(h_cod_cta_pat) THEN
        ON 'LEAVE':U OF h_cod_cta_pat PERSISTENT RUN pi_leave_bem IN h_fas716ca_epc.


    RUN piFindWidget(INPUT "cod_estab", 
                     INPUT "fill-in", 
                     INPUT  p_wgh_frame, 
                     OUTPUT h_cod_estab).

    IF  VALID-HANDLE(h_cod_estab) THEN
        ON 'LEAVE':U OF h_cod_estab PERSISTENT RUN pi_leave_bem IN h_fas716ca_epc.

    RUN piFindWidget(INPUT "f_dlg_01_bem_pat_transf_ext",
                     INPUT "DIALOG-BOX",
                     INPUT p_wgh_frame,
                     OUTPUT h_f_dlg_01_bem_pat_transf_ext).

    IF  VALID-HANDLE(h_f_dlg_01_bem_pat_transf_ext) THEN DO:
        MESSAGE "achou frame" VIEW-AS ALERT-BOX.
        RUN piFindWidget(INPUT "cod_localiz", 
                         INPUT "fill-in", 
                         INPUT  h_f_dlg_01_bem_pat_transf_ext, 
                         OUTPUT h_cod_localiz).
    
        IF  VALID-HANDLE(h_cod_localiz) THEN
            MESSAGE "achou handle localiz" VIEW-AS ALERT-BOX.
    END.

    RETURN 'OK'.
END.

IF  p_ind_event = "DISPLAY" THEN DO:
    RUN piFindWidget(INPUT "f_dlg_01_bem_pat_transf_ext",
                     INPUT "DIALOG-BOX",
                     INPUT p_wgh_frame,
                     OUTPUT h_f_dlg_01_bem_pat_transf_ext).

    IF  VALID-HANDLE(h_f_dlg_01_bem_pat_transf_ext) THEN DO:
        MESSAGE "2 achou frame" VIEW-AS ALERT-BOX.
        RUN piFindWidget(INPUT "cod_localiz", 
                         INPUT "fill-in", 
                         INPUT  h_f_dlg_01_bem_pat_transf_ext, 
                         OUTPUT h_cod_localiz).
    
        IF  VALID-HANDLE(h_cod_localiz) THEN
            MESSAGE "achou handle localiz" VIEW-AS ALERT-BOX.
    END.

    RETURN 'OK'.

END.

PROCEDURE piFindWidget:
    DEFINE INPUT  PARAMETER c-widget-name  AS CHAR   NO-UNDO.
    DEFINE INPUT  PARAMETER c-widget-type  AS CHAR   NO-UNDO.
    DEFINE INPUT  PARAMETER h-start-widget AS HANDLE NO-UNDO.
    DEFINE OUTPUT PARAMETER h-widget       AS HANDLE NO-UNDO.

    DO WHILE VALID-HANDLE(h-start-widget):

        IF  c-widget-name = "f_dlg_01_bem_pat_transf_ext" 
        AND h-start-widget:NAME = c-widget-name THEN
            MESSAGE "1 - h-start-widget:TYPE " h-start-widget:TYPE VIEW-AS ALERT-BOX.

        IF  c-widget-name = "cod_localiz" 
        AND h-start-widget:NAME = c-widget-name THEN
            MESSAGE "2 - h-start-widget:TYPE " h-start-widget:TYPE VIEW-AS ALERT-BOX.

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
            
            
RETURN 'OK'.
