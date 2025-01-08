/*****************************************************************************
** Programa..............: fgl702zi_epc
** Descricao.............: EPC do programa fnc_lote_ctbl_cancela e 
**                         fnc_lancto_ctbl_cancela
** Criado em.............: 11/05/2020
*****************************************************************************/

DEF INPUT PARAM p_ind_event  AS CHAR          NO-UNDO.
DEF INPUT PARAM p_ind_object AS CHAR          NO-UNDO.
DEF INPUT PARAM p_wgh_object AS HANDLE        NO-UNDO.
DEF INPUT PARAM p_wgh_frame  AS WIDGET-HANDLE NO-UNDO.
DEF INPUT PARAM p_cod_table  AS CHAR          NO-UNDO.
DEF INPUT PARAM p_rec_table  AS RECID         NO-UNDO.

def new global shared var v_cod_empres_usuar
    as character
    format "x(3)":U
    label "Empresa"
    column-label "Empresa"
    no-undo.

def new global shared var v_cod_usuar_corren
    as character
    format "x(12)":U
    label "Usu rio Corrente"
    column-label "Usu rio Corrente"
    no-undo.

DEF NEW GLOBAL SHARED VAR wh_v_cod_single_conjto           AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh_num_lote_ctbl                 AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh_new_num_lote_ctbl             AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh_rs_tipo_cancelamento_contabil AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh_bt_zoom                       AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh_new_bt_zoom                   AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR h_fgl702zi_epc                   AS WIDGET-HANDLE NO-UNDO.

def new global shared var v_rec_lancto_ctbl
    as recid
    format ">>>>>>9":U
    initial ?
    no-undo.

DEF VAR hquery           AS HANDLE NO-UNDO.
DEF VAR hbuffer          AS HANDLE NO-UNDO.
DEF VAR h_num_lote_ctbl  AS HANDLE NO-UNDO.
DEF VAR i-linha          AS INT    NO-UNDO.

/*
MESSAGE "p_ind_event "  p_ind_event  skip
        "p_ind_object " p_ind_object skip
        "p_wgh_object " p_wgh_object skip
        "p_wgh_frame "  p_wgh_frame  skip
        "p_cod_table "  p_cod_table 
        VIEW-AS ALERT-BOX.
*/


/*
IF  p_ind_event = "INITIALIZE" then do:

    RUN piFindWidget(INPUT "v_cod_single_conjto",
                     INPUT "RADIO-SET",
                     INPUT p_wgh_frame,
                     OUTPUT wh_v_cod_single_conjto).

    IF  VALID-HANDLE(wh_v_cod_single_conjto) THEN DO:
        ASSIGN wh_v_cod_single_conjto:SCREEN-VALUE = "Individual".

        IF wh_v_cod_single_conjto:DISABLE("Conjunto") THEN.
    END.

    RUN epc/fgl702zi_epc.p PERSISTENT SET h_fgl702zi_epc (INPUT "",
                                                          INPUT "",
                                                          INPUT p_wgh_object,
                                                          INPUT p_wgh_frame,
                                                          INPUT "",
                                                          INPUT p_rec_table).

    RUN piFindWidget(INPUT "num_lote_ctbl", /* Nr lote */
                     INPUT "FILL-IN",
                     INPUT p_wgh_frame,
                     OUTPUT wh_num_lote_ctbl).

    IF  VALID-HANDLE(wh_num_lote_ctbl) THEN DO:
        /*ASSIGN wh_num_lote_ctbl:SENSITIVE = NO.*/

        ON "LEAVE" OF wh_num_lote_ctbl PERSISTENT RUN pi_leave_lote IN h_fgl702zi_epc.

        CREATE FILL-IN wh_new_num_lote_ctbl
        ASSIGN FRAME             = p_wgh_frame
               NAME              = "wh_new_num_lote_ctbl":U
               DATA-TYPE         = wh_num_lote_ctbl:DATA-TYPE
               FORMAT            = wh_num_lote_ctbl:FORMAT
               WIDTH             = wh_num_lote_ctbl:WIDTH
               HEIGHT            = wh_num_lote_ctbl:HEIGHT
               ROW               = wh_num_lote_ctbl:ROW
               COL               = wh_num_lote_ctbl:COL
               VISIBLE           = wh_num_lote_ctbl:VISIBLE
               SENSITIVE         = YES.

        ON "LEAVE"         OF wh_new_num_lote_ctbl PERSISTENT RUN pi_leave_lote IN h_fgl702zi_epc.
        ON "VALUE-CHANGED" OF wh_new_num_lote_ctbl PERSISTENT RUN pi_leave_lote IN h_fgl702zi_epc.

    END.

    RUN piFindWidget(INPUT "bt_zoom",
                     INPUT "BUTTON",
                     INPUT p_wgh_frame,
                     OUTPUT wh_bt_zoom).

    IF  VALID-HANDLE(wh_bt_zoom) THEN DO:
        CREATE BUTTON wh_new_bt_zoom
        ASSIGN FRAME       = wh_bt_zoom:FRAME
               WIDTH       = wh_bt_zoom:WIDTH
               HEIGHT      = wh_bt_zoom:HEIGHT
               LABEL       = wh_bt_zoom:LABEL
               ROW         = wh_bt_zoom:ROW
               COL         = wh_bt_zoom:COL 
               TOOLTIP     = wh_bt_zoom:TOOLTIP
               FLAT-BUTTON = wh_bt_zoom:FLAT-BUTTON
               VISIBLE     = wh_bt_zoom:VISIBLE
               SENSITIVE   = YES.
        
        ON "CHOOSE" OF wh_new_bt_zoom PERSISTENT RUN pi_bt_zoom IN h_fgl702zi_epc.

        wh_new_bt_zoom:MOVE-TO-TOP().
        wh_new_bt_zoom:LOAD-IMAGE("image/im-zoo.bmp").
        wh_bt_zoom:VISIBLE = NO.
        
    END.

    RUN piFindWidget(INPUT "rs_tipo_cancelamento_contabil",
                     INPUT "RADIO-SET",
                     INPUT p_wgh_frame,
                     OUTPUT wh_rs_tipo_cancelamento_contabil).

END.

PROCEDURE piFindWidget:
    def input  param c-widget-name  as char   no-undo.
    def input  param c-widget-type  as char   no-undo.
    def input  param h-start-widget as handle no-undo.
    def output param h-widget       as handle no-undo.

    do  while valid-handle(h-start-widget):

        if  h-start-widget:name = c-widget-name
        and h-start-widget:type = c-widget-type then do:
            assign h-widget = h-start-widget:handle.
            leave.
        end.

        if  h-start-widget:type = "field-group":u 
        or  h-start-widget:type = "frame":u 
        or  h-start-widget:type = "dialog-box":u then do:
            run piFindWidget (input  c-widget-name,
                              input  c-widget-type,
                              input  h-start-widget:first-child,
                              output h-widget).

            if  valid-handle(h-widget) then
                leave.
        end.

        assign h-start-widget = h-start-widget:next-sibling.
    end.

END PROCEDURE.

PROCEDURE pi_leave_lote:
    
    FIND FIRST lote_ctbl USE-INDEX ltctbla_id
         WHERE lote_ctbl.cod_empresa   = v_cod_empres_usuar
         AND   lote_ctbl.num_lote_ctbl = int(wh_new_num_lote_ctbl:SCREEN-VALUE) NO-LOCK NO-ERROR.

    IF  AVAIL lote_ctbl THEN DO:
        IF  VALID-HANDLE(wh_num_lote_ctbl) THEN DO:
            ASSIGN wh_num_lote_ctbl:SCREEN-VALUE = wh_new_num_lote_ctbl:SCREEN-VALUE.
            APPLY "LEAVE" TO wh_num_lote_ctbl.
        END.

        IF  lote_ctbl.cod_usuar_ult_atualiz <> v_cod_usuar_corren THEN DO:
            ASSIGN wh_rs_tipo_cancelamento_contabil:SENSITIVE = NO.

            IF wh_rs_tipo_cancelamento_contabil:DISABLE("Eliminar") THEN.

            ASSIGN wh_rs_tipo_cancelamento_contabil:SCREEN-VALUE = "Descontabilizar".
        END.
        ELSE DO:
            ASSIGN wh_rs_tipo_cancelamento_contabil:SENSITIVE = YES.

            IF wh_rs_tipo_cancelamento_contabil:ENABLE("Eliminar") THEN.
        END.
    END.

END PROCEDURE.

PROCEDURE pi_bt_zoom:
    IF  VALID-HANDLE(wh_bt_zoom) THEN DO:
        APPLY "CHOOSE" TO wh_bt_zoom.

        ASSIGN wh_new_num_lote_ctbl:SCREEN-VALUE = wh_num_lote_ctbl:SCREEN-VALUE.

        APPLY "ENTRY" TO wh_new_num_lote_ctbl.
        APPLY "LEAVE" TO wh_new_num_lote_ctbl.
    END.
END PROCEDURE.

*/

RETURN "OK".
