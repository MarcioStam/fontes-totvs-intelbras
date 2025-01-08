/*****************************************************************************
** Programa..............: fas722ma_epc.p
** Descricao.............: EPC do programa frm_aloc_bem.
** Criado em.............: 30/01/2019.
*****************************************************************************/

DEF INPUT PARAM p_ind_event  AS CHAR          NO-UNDO.
DEF INPUT PARAM p_ind_object AS CHAR          NO-UNDO.
DEF INPUT PARAM p_wgh_object AS HANDLE        NO-UNDO.
DEF INPUT PARAM p_wgh_frame  AS WIDGET-HANDLE NO-UNDO.
DEF INPUT PARAM p_cod_table  AS CHAR          NO-UNDO.
DEF INPUT PARAM p_rec_table  AS RECID         NO-UNDO.

DEF NEW GLOBAL SHARED VAR wh_bt_ins_frm              AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh_new_bt_ins_frm          AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR h_br_frm_ccusto_unid_negoc AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR h_epc_fas722ma             AS WIDGET-HANDLE NO-UNDO.

def new global shared var v_rec_bem_pat
    as recid
    format ">>>>>>9":U
    initial ?
    no-undo.

DEF VAR hquery           AS HANDLE NO-UNDO.
DEF VAR hbuffer          AS HANDLE NO-UNDO.
DEF VAR h_cod_estab      AS HANDLE NO-UNDO.
DEF VAR h_cod_ccusto     AS HANDLE NO-UNDO.
DEF VAR h_cod_unid_negoc AS HANDLE NO-UNDO.
DEF VAR i-linha          AS INT    NO-UNDO.

/*
MESSAGE "p_ind_event "  p_ind_event  skip
        "p_ind_object " p_ind_object skip
        "p_wgh_object " p_wgh_object skip
        "p_wgh_frame "  p_wgh_frame  skip
        "p_cod_table "  p_cod_table 
        VIEW-AS ALERT-BOX.
*/

IF  p_ind_event = "INITIALIZE" then do:
    
    IF  NOT VALID-HANDLE (h_epc_fas722ma) THEN
        RUN epc/fas722ma_epc.p PERSISTENT SET h_epc_fas722ma (INPUT "",
                                                              INPUT "",
                                                              INPUT p_wgh_object,
                                                              INPUT p_wgh_frame,
                                                              INPUT "",
                                                              INPUT p_rec_table).

    RUN piFindWidget(INPUT "bt_ins_frm",
                     INPUT "BUTTON",
                     INPUT p_wgh_frame,
                     OUTPUT wh_bt_ins_frm).

    RUN piFindWidget(INPUT "br_frm_ccusto_unid_negoc",
                     INPUT "BROWSE",
                     INPUT p_wgh_frame,
                     OUTPUT h_br_frm_ccusto_unid_negoc).

    CREATE BUTTON wh_new_bt_ins_frm
    ASSIGN FRAME       = wh_bt_ins_frm:FRAME
           WIDTH       = wh_bt_ins_frm:WIDTH
           HEIGHT      = wh_bt_ins_frm:HEIGHT
           LABEL       = wh_bt_ins_frm:LABEL
           ROW         = wh_bt_ins_frm:ROW
           COL         = wh_bt_ins_frm:COL 
           TOOLTIP     = wh_bt_ins_frm:TOOLTIP
           FLAT-BUTTON = wh_bt_ins_frm:FLAT-BUTTON
           VISIBLE     = YES
           SENSITIVE   = YES.
    ON "CHOOSE" OF wh_new_bt_ins_frm PERSISTENT RUN pi_bt_ins_frm IN h_epc_fas722ma.

    wh_new_bt_ins_frm:LOAD-IMAGE ( 'image/im-nex1' ).
    wh_new_bt_ins_frm:MOVE-TO-TOP().
    wh_bt_ins_frm:VISIBLE = NO.

END.

PROCEDURE pi_bt_ins_frm:

    FIND FIRST bem_pat 
        WHERE RECID(bem_pat) = v_rec_bem_pat NO-LOCK NO-ERROR.
    
    IF VALID-HANDLE(h_br_frm_ccusto_unid_negoc) THEN DO:

        DO  i-linha = 1 TO h_br_frm_ccusto_unid_negoc:NUM-SELECTED-ROWS:

            h_br_frm_ccusto_unid_negoc:FETCH-SELECTED-ROW(i-linha).
    
            ASSIGN h_cod_estab      = h_br_frm_ccusto_unid_negoc:QUERY:GET-BUFFER-HANDLE("estab_unid_negoc":U):BUFFER-FIELD("cod_estab":U)
                   h_cod_ccusto     = h_br_frm_ccusto_unid_negoc:QUERY:GET-BUFFER-HANDLE("ccusto_unid_negoc":U):BUFFER-FIELD("cod_ccusto":U)
                   h_cod_unid_negoc = h_br_frm_ccusto_unid_negoc:QUERY:GET-BUFFER-HANDLE("ccusto_unid_negoc":U):BUFFER-FIELD("cod_unid_negoc":U).

            IF  (bem_pat.cod_ccusto_respons BEGINS "5"
            OR   bem_pat.cod_ccusto_respons BEGINS "6")
            AND (bem_pat.cod_cta_pat <> "PROJ. ANDAM. INTAN"
            AND  bem_pat.cod_cta_pat <> "PROJETOS EM ANDAME") THEN DO:

                IF (h_cod_ccusto:BUFFER-VALUE BEGINS "44"
                OR  h_cod_ccusto:BUFFER-VALUE BEGINS "45" 
                OR  h_cod_ccusto:BUFFER-VALUE BEGINS "46") THEN DO:
                    MESSAGE "Parƒmetros para Cr‚dito de PIS/COFINS NÇO FORAM marcados. Confirma ?" VIEW-AS ALERT-BOX INFO BUTTONS YES-NO UPDATE l_confirma5 AS LOGICAL.

                    IF  l_confirma5 = NO THEN
                        RETURN "NOK".
                END.                 
            END.

            IF  (h_cod_ccusto:BUFFER-VALUE BEGINS "5"
            OR   h_cod_ccusto:BUFFER-VALUE BEGINS "6")
            AND (bem_pat.cod_cta_pat <> "PROJ. ANDAM. INTAN"
            AND  bem_pat.cod_cta_pat <> "PROJETOS EM ANDAME") THEN DO:
                 MESSAGE "Centro de custo de projeto nÆo pode ser alocado para esta conta patrimonial !" VIEW-AS ALERT-BOX INFO.

                 RETURN "NOK".             
            END.

            IF  NOT CAN-FIND(FIRST cc_uni_estab NO-LOCK
                             WHERE cc_uni_estab.cod_ccusto     = h_cod_ccusto:BUFFER-VALUE
                             AND   cc_uni_estab.cod_unid_negoc = h_cod_unid_negoc:BUFFER-VALUE
                             AND   cc_uni_estab.cod_estab      = h_cod_estab:BUFFER-VALUE) THEN DO:
                 MESSAGE "Relacionamento entre o Estabelecimento x CCusto x Unidade de Neg¢cio Inexistente!" VIEW-AS ALERT-BOX INFO BUTTONS OK.
                 RETURN "NOK".
            END.
        END.
    END.

    IF  VALID-HANDLE(wh_bt_ins_frm) THEN
        APPLY "CHOOSE" TO wh_bt_ins_frm.

END PROCEDURE.

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

RETURN "OK".
