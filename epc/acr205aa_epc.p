/*****************************************************************************
** Programa..............: acr205aa_epc.p
** Descricao.............: EPC do programa bas_cliente_fin (consulta cliente).
** Criado em.............: 04/02/2019.
*****************************************************************************/

DEF INPUT PARAM p_ind_event       AS CHAR           NO-UNDO.
DEF INPUT PARAM p_ind_object      AS CHAR           NO-UNDO.
DEF INPUT PARAM p_wgh_object      AS HANDLE         NO-UNDO.
DEF INPUT PARAM p_wgh_frame       AS WIDGET-HANDLE  NO-UNDO.
DEF INPUT PARAM p_cod_table       AS CHAR           NO-UNDO.
DEF INPUT PARAM p_rec_table       AS RECID          NO-UNDO.

DEF VAR h_epc_acr205aa    AS WIDGET-HANDLE NO-UNDO.

DEF NEW GLOBAL SHARED VAR wh_bt_historico_padrao     AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh_new_bt_historico_padrao AS WIDGET-HANDLE NO-UNDO.

DEF NEW GLOBAL SHARED VAR h_v_cod_clien_infor AS HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR h_acr205aa          AS HANDLE NO-UNDO.

DEF VAR c-objeto         AS CHAR                          NO-UNDO.

ASSIGN c-objeto = ENTRY(NUM-ENTRIES(p_wgh_object:PRIVATE-DATA, "~/"), p_wgh_object:PRIVATE-DATA, "~/").

/*
message "EVENTO" p_ind_event skip
        "OBJETO" p_ind_object skip
        "NOME OBJ" c-objeto skip
        "FRAME" p_wgh_frame skip
        "TABELA" p_cod_table skip
        "ROWID" string(p_rec_table) view-as alert-box.  
*/

IF  p_ind_event = "INITIALIZE" THEN DO:
    RUN piFindWidget(INPUT "v_cod_clien_infor", 
                     INPUT "FILL-IN", 
                     INPUT p_wgh_frame, 
                     OUTPUT h_v_cod_clien_infor).

    RUN busca-handle(INPUT p_wgh_frame,
                     INPUT "bt_historico_padrao",
                     OUTPUT wh_bt_historico_padrao).

    IF VALID-HANDLE(wh_bt_historico_padrao) THEN DO:

        IF NOT VALID-HANDLE (h_epc_acr205aa) THEN
            RUN epc/acr205aa_epc.p PERSISTENT SET h_epc_acr205aa (INPUT "",
                                                                  INPUT "",
                                                                  INPUT p_wgh_object,
                                                                  INPUT p_wgh_frame,
                                                                  INPUT "",
                                                                  INPUT p_rec_table).

        CREATE BUTTON wh_new_bt_historico_padrao
        ASSIGN FRAME       = wh_bt_historico_padrao:FRAME
               WIDTH       = wh_bt_historico_padrao:WIDTH
               HEIGHT      = wh_bt_historico_padrao:HEIGHT
               LABEL       = "Referˆncias Comerciais"
               ROW         = wh_bt_historico_padrao:ROW
               COL         = wh_bt_historico_padrao:COL + 5
               TOOLTIP     = "Referˆncias Comerciais"
               FLAT-BUTTON = wh_bt_historico_padrao:FLAT-BUTTON
               VISIBLE     = YES
               SENSITIVE   = YES.
        ON "CHOOSE" OF wh_new_bt_historico_padrao PERSISTENT RUN pi_bt_historico_padrao IN h_epc_acr205aa.

        wh_new_bt_historico_padrao:LOAD-IMAGE ( 'image/im-extra.bmp' ).
        wh_new_bt_historico_padrao:MOVE-TO-TOP().
        wh_bt_historico_padrao:VISIBLE = NO.
    END.

END.

PROCEDURE pi_bt_historico_padrao:
    RUN epc/acr205aa1_epc.r .
END PROCEDURE.

PROCEDURE piFindWidget:

    DEFINE INPUT  PARAMETER c-widget-name  AS CHAR   NO-UNDO.
    DEFINE INPUT  PARAMETER c-widget-type  AS CHAR   NO-UNDO.
    DEFINE INPUT  PARAMETER h-start-widget AS HANDLE NO-UNDO.
    DEFINE OUTPUT PARAMETER h-widget       AS HANDLE NO-UNDO.

    DO WHILE VALID-HANDLE(h-start-widget):

        IF h-start-widget:NAME = c-widget-name AND
           h-start-widget:TYPE = c-widget-type THEN DO:
            
            ASSIGN h-widget = h-start-widget:HANDLE.
            LEAVE.
        END.

        IF h-start-widget:TYPE = "field-group":u OR
           h-start-widget:TYPE = "frame":u OR
           h-start-widget:TYPE = "dialog-box":u THEN DO:
            RUN piFindWidget (INPUT  c-widget-name,
                              INPUT  c-widget-type,
                              INPUT  h-start-widget:FIRST-CHILD,
                              OUTPUT h-widget).

            IF VALID-HANDLE(h-widget) THEN
                LEAVE.
        END.
        ASSIGN h-start-widget = h-start-widget:NEXT-SIBLING.
    END.

END PROCEDURE.

PROCEDURE busca-handle:
    DEF INPUT  PARAM p-wgh-frame AS WIDGET-HANDLE NO-UNDO.
    DEF INPUT  PARAM p-nome-obj  AS CHARACTER     NO-UNDO.
    DEF OUTPUT PARAM p-handl-obj AS WIDGET-HANDLE NO-UNDO.
    
    DEF VARI h-aux  AS WIDGET-HANDLE NO-UNDO.
    DEF VARI h-prox AS HANDLE        NO-UNDO.

    ASSIGN h-aux = p-wgh-frame
           h-prox = ?.
    ASSIGN h-aux = h-aux:FIRST-CHILD.
    ASSIGN h-aux = h-aux:FIRST-CHILD.

    REPEAT:
        IF  NOT valid-handle(h-aux) 
        AND NOT VALID-HANDLE(h-prox) THEN DO:
            ASSIGN h-aux = ?.
            LEAVE.
        END.

        IF  NOT valid-handle(h-aux) THEN DO:
            ASSIGN h-aux = h-prox.
            ASSIGN h-prox = ?.
            NEXT.
        END.

        IF  h-aux:NAME = "panel-frame" THEN DO:
            ASSIGN h-prox = h-aux:NEXT-SIBLING.
            ASSIGN h-aux = h-aux:FIRST-CHILD.
            ASSIGN h-aux = h-aux:FIRST-CHILD.

            NEXT.
        END.

        IF  h-aux:NAME <> p-nome-obj THEN DO:
            ASSIGN h-aux = h-aux:NEXT-SIBLING.
            
            IF NOT VALID-HANDLE(h-aux) THEN
                NEXT.
        END.
        ELSE DO:
            ASSIGN p-handl-obj = h-aux.
            LEAVE.
        END.
    END.
END.
