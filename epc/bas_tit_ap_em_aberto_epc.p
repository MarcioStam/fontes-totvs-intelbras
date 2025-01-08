/*****************************************************************************
** Programa..............: bas_tit_ap_em_aberto_epc.p
** Descricao.............: EPC browse br_tit_ap_em_aberto 
** do programa bas_tit_ap_em_aberto
** Criado em.............: 18/08/2021
*****************************************************************************/

def input param p_ind_event       as char           no-undo.
def input param p_ind_object      as char           no-undo.
def input param p_wgh_object      as handle         no-undo.
def input param p_wgh_frame       as widget-handle  no-undo.
def input param p_cod_table       as char           no-undo.
def input param p_rec_table       as recid          no-undo.

DEF VAR c-handle-obj                  AS CHAR          NO-UNDO.
DEF VAR hCol                          AS HANDLE        NO-UNDO.
DEF VAR h_bas_tit_ap_em_aberto_epc_01 AS HANDLE        NO-UNDO.

DEF NEW GLOBAL SHARED VAR h_fornec_bas_fin      AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR h_br_tit_ap_em_aberto AS WIDGET-HANDLE NO-UNDO.

DEF NEW GLOBAL SHARED TEMP-TABLE ttCol_bas_tit_aberto NO-UNDO
    FIELD ColHdl AS WIDGET-HANDLE.

DEF NEW GLOBAL SHARED VAR h_br_tit_ap_abert_epc          AS widget-handle no-undo.
DEF NEW GLOBAL SHARED VAR wgh-query-bas-tit-aberto  AS widget-handle no-undo.
DEF NEW GLOBAL SHARED VAR wgh-buffer-bas-tit-aberto AS widget-handle no-undo.
DEF NEW GLOBAL SHARED VAR r-tit_ap_global           AS ROWID         no-undo.
DEF NEW GLOBAL SHARED VAR wh_br_tit_ap_em_aberto    AS widget-handle no-undo.
DEF NEW GLOBAL SHARED VAR wh_tit_ap_abert_status    AS widget-handle no-undo.
DEF NEW GLOBAL SHARED VAR wh_query_tit_ap_aberto    AS widget-handle no-undo.
DEF NEW GLOBAL SHARED VAR wh_buffer_tit_ap_aberto   AS widget-handle no-undo.

def var c-objeto as char no-undo.

assign c-objeto = entry(num-entries(p_wgh_object:private-data, "~/"), p_wgh_object:private-data, "~/").


IF  p_ind_event = "after-destroy-interface" THEN 
    ASSIGN h_bas_tit_ap_em_aberto_epc_01 = ?.

if  p_ind_event = "INITIALIZE" then do:
    RUN epc/bas_tit_ap_em_aberto_epc_01.p PERSISTENT SET h_bas_tit_ap_em_aberto_epc_01(INPUT p_ind_event,
                                                                                       INPUT p_ind_object,
                                                                                       INPUT p_wgh_object,
                                                                                       INPUT p_wgh_frame,
                                                                                       INPUT p_cod_table,
                                                                                       INPUT p_rec_table).

    RUN piFindWidget(INPUT "br_tit_ap_em_aberto", INPUT "BROWSE", INPUT p_wgh_frame, OUTPUT h_br_tit_ap_abert_epc).

    assign wgh-query-bas-tit-aberto  = h_br_tit_ap_abert_epc:QUERY
           wgh-buffer-bas-tit-aberto = wgh-query-bas-tit-aberto:GET-BUFFER-HANDLE(1).

    ON "MOUSE-SELECT-CLICK" OF h_br_tit_ap_abert_epc PERSISTENT RUN pi-armazena-campos IN h_bas_tit_ap_em_aberto_epc_01.

    /* criar coluna de status do t¡tulo */
    RUN piFindWidget(INPUT "br_tit_ap_em_aberto", INPUT "BROWSE", INPUT p_wgh_frame, OUTPUT c-handle-obj).

    ASSIGN wh_br_tit_ap_em_aberto = WIDGET-HANDLE(ENTRY(01,c-handle-obj)).

    IF VALID-HANDLE(wh_br_tit_ap_em_aberto) THEN DO:
        ASSIGN wh_query_tit_ap_aberto           = wh_br_tit_ap_em_aberto:QUERY
               wh_buffer_tit_ap_aberto          = wh_query_tit_ap_aberto:GET-BUFFER-HANDLE()
               wh_tit_ap_abert_status           = wh_br_tit_ap_em_aberto:ADD-CALC-COLUMN ("char", "x(16)", "", "Status T¡tulo", 1)
               wh_tit_ap_abert_status:WIDTH     = 12
               wh_tit_ap_abert_status:READ-ONLY = FALSE.
    END.

    EMPTY TEMP-TABLE ttCol_bas_tit_aberto.

    ASSIGN hCol = h_br_tit_ap_abert_epc:FIRST-COLUMN.
    DO  WHILE VALID-HANDLE(hCol):
        IF  NOT CAN-FIND(FIRST ttCol_bas_tit_aberto 
                           WHERE ttCol_bas_tit_aberto.ColHdl = hCol) THEN  DO:
            CREATE ttCol_bas_tit_aberto.
            ASSIGN ttCol_bas_tit_aberto.ColHdl = hCol.
        END.
        hCol = hCol:NEXT-COLUMN.
    END.

    ON "ROW-DISPLAY" OF h_br_tit_ap_abert_epc PERSISTENT RUN pi-alimenta-conhecimento IN h_bas_tit_ap_em_aberto_epc_01.
    /* criar coluna de status do t¡tulo */

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

