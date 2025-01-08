/*****************************************************************************
** Programa..............: bas_fornecedor_fin_epc.p.p
** Descricao.............: EPC do programa bas_fornecedor_fin
** Criado em.............: 19/10/2004
*****************************************************************************/

def input param p_ind_event       as char           no-undo.
def input param p_ind_object      as char           no-undo.
def input param p_wgh_object      as handle         no-undo.
def input param p_wgh_frame       as widget-handle  no-undo.
def input param p_cod_table       as char           no-undo.
def input param p_rec_table       as recid          no-undo.

def var wh_button                   as widget-handle no-undo.
def var wh_button2                  as widget-handle no-undo.
def var wh_button_consulta          as widget-handle no-undo.
def var wh_button4                  as widget-handle no-undo.
def var h_object                    as widget-handle no-undo.
def var h_prev                      as widget-handle no-undo.
def var h_next                      as widget-handle no-undo.
DEF VAR wgh-BROWSE-pagto            AS WIDGET-HANDLE NO-UNDO.
DEF VAR c-handle-obj                AS CHAR          NO-UNDO.
DEF VAR hCol                        AS HANDLE        NO-UNDO.
DEF VAR h_bas_fornecedor_fin_epc-01 AS HANDLE        NO-UNDO.
DEF VAR h_bas_fornecedor_fin_epc_03 AS HANDLE        NO-UNDO.

DEFINE NEW GLOBAL SHARED VAR h_fornec_bas_fin       AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR h_br_qry_tit_ap_fornec AS WIDGET-HANDLE NO-UNDO.

DEF NEW GLOBAL SHARED TEMP-TABLE ttCol_bas_fornec NO-UNDO
    FIELD ColHdl AS WIDGET-HANDLE.

DEF NEW GLOBAL SHARED VAR h_br_titulos_epc          AS widget-handle no-undo.
DEF NEW GLOBAL SHARED VAR wgh-query-bas-fornec-fin  AS widget-handle no-undo.
DEF NEW GLOBAL SHARED VAR wgh-buffer-bas-fornec-fin AS widget-handle no-undo.
DEF NEW GLOBAL SHARED VAR wgh-bt-titulos_epc        AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wgh-bt-titulos_epc        AS widget-handle no-undo.
DEF NEW GLOBAL SHARED VAR wh_bt_pagtos              AS widget-handle no-undo.
DEF NEW GLOBAL SHARED VAR wh_fornec_bas_fin         AS widget-handle no-undo.
DEF NEW GLOBAL SHARED VAR wh_new_fornec_bas_fin     AS widget-handle no-undo.
DEF NEW GLOBAL SHARED VAR r-tit_ap_global           AS ROWID         no-undo.
DEF NEW GLOBAL SHARED VAR wh_br_qry_tit_ap_fornec   AS widget-handle no-undo.
DEF NEW GLOBAL SHARED VAR wh_status                 AS widget-handle no-undo.
DEF NEW GLOBAL SHARED VAR wh_conhec_master          AS widget-handle no-undo.
DEF NEW GLOBAL SHARED VAR wh_conhec_house           AS widget-handle no-undo.
DEF NEW GLOBAL SHARED VAR wh_pedido                 AS widget-handle no-undo.
DEF NEW GLOBAL SHARED VAR wh_query_tit_ap_fornec    AS widget-handle no-undo.
DEF NEW GLOBAL SHARED VAR wh_buffer_tit_ap_fornec   AS widget-handle no-undo.

def new global shared var v_cod_empres_usuar
    as character
    format "x(3)":U
    label "Empresa"
    column-label "Empresa"
    no-undo.

def var v_cod_return
    as character
    format "x(40)":U
    no-undo.

def var c-objeto as char no-undo.

assign c-objeto = entry(num-entries(p_wgh_object:private-data, "~/"), p_wgh_object:private-data, "~/").


IF  p_ind_event = "after-destroy-interface" THEN 
    ASSIGN h_bas_fornecedor_fin_epc-01 = ?.

IF   p_ind_event = "DISPLAY" THEN DO:
     ASSIGN r-tit_ap_global = ?.
     
    IF  VALID-HANDLE(wh_fornec_bas_fin)
    AND VALID-HANDLE(wh_new_fornec_bas_fin) THEN
        ASSIGN wh_new_fornec_bas_fin:SCREEN-VALUE = wh_fornec_bas_fin:SCREEN-VALUE.
END.

if  p_ind_event = "INITIALIZE" then do:

    RUN piFindWidget(INPUT "v_cod_fornec_infor", INPUT "fill-in", INPUT p_wgh_frame, OUTPUT wh_fornec_bas_fin).
    RUN piFindWidget(INPUT "bt_titulos", INPUT "button", INPUT p_wgh_frame, OUTPUT wgh-bt-titulos_epc).

    IF  NOT VALID-HANDLE (h_bas_fornecedor_fin_epc_03) THEN
        RUN epc/bas_fornecedor_fin_epc_03.p PERSISTENT SET h_bas_fornecedor_fin_epc_03 (INPUT "",
                                                                                        INPUT "",
                                                                                        INPUT p_wgh_object,
                                                                                        INPUT p_wgh_frame,
                                                                                        INPUT "",
                                                                                        INPUT p_rec_table).

    IF  VALID-HANDLE(wh_fornec_bas_fin) THEN DO:

        CREATE FILL-IN wh_new_fornec_bas_fin
        ASSIGN FRAME      = p_wgh_frame
               NAME       = "wh_new_fornec_bas_fin":U
               DATA-TYPE  = wh_fornec_bas_fin:DATA-TYPE
               FORMAT     = wh_fornec_bas_fin:FORMAT
               WIDTH      = wh_fornec_bas_fin:WIDTH
               HEIGHT     = wh_fornec_bas_fin:HEIGHT
               ROW        = wh_fornec_bas_fin:ROW
               COL        = wh_fornec_bas_fin:COL
               VISIBLE    = YES
               SENSITIVE  = YES.

        ON "LEAVE" OF wh_new_fornec_bas_fin PERSISTENT RUN pi_leave_fornec IN h_bas_fornecedor_fin_epc_03.
        /*ON "F5"    OF wh_new_fornec_bas_fin PERSISTENT RUN pi_trata_eventos IN h_bas_fornecedor_fin_epc_03 (INPUT "F5").*/

        wh_new_fornec_bas_fin:MOVE-AFTER-TAB-ITEM(wh_fornec_bas_fin).
        ASSIGN wh_fornec_bas_fin:SENSITIVE = NO.
        ASSIGN wh_new_fornec_bas_fin:SCREEN-VALUE = wh_fornec_bas_fin:SCREEN-VALUE.
    END.

    /* bot∆o para consulta £ltimos pagamentos */
    create button wh_bt_pagtos
    assign frame      = p_wgh_frame
           NAME       = "bt_pagtos"
           width      = 4.4
           height     = 1.24
           row        = 1
           col        = 65
           sensitive  = yes
           visible    = yes
           LABEL      = "Consulta Èltimos Pagamentos"
           tooltip    = "Consulta Èltimos Pagamentos"
           triggers:
               on CHOOSE PERSISTENT RUN epc/bas_fornecedor_fin_epc_04.w .
           end triggers.

    wh_bt_pagtos:LOAD-IMAGE("image/dolar.ico"). 

    /* ** Bot∆o para imprimir relat¢rio Encontro de Contas ***/
    create button wh_button_consulta
    assign frame      = p_wgh_frame
           NAME       = "bt_consulta_imp_esp"
           width      = 4.4
           height     = 1.24
           row        = 1
           col        = 60
           sensitive  = yes
           visible    = yes
           LABEL      = "Consulta Imposto lancto Nota"
           tooltip    = "Consulta Imposto lancto Nota"
           triggers:
               on CHOOSE PERSISTENT RUN epc/bas_fornecedor_fin_epc_02.w.
           end triggers.

     wh_button_consulta:LOAD-IMAGE("image/intelbras/infopg.ico":U). 

     RUN epc/bas_fornecedor_fin_epc_01.p PERSISTENT SET h_bas_fornecedor_fin_epc-01(INPUT p_ind_event,
                                                                                    INPUT p_ind_object,
                                                                                    INPUT p_wgh_object,
                                                                                    INPUT p_wgh_frame,
                                                                                    INPUT p_cod_table,
                                                                                    INPUT p_rec_table).

    RUN piFindWidget(INPUT "br_qry_tit_ap_fornec", INPUT "BROWSE", INPUT p_wgh_frame, OUTPUT h_br_titulos_epc).

    assign wgh-query-bas-fornec-fin  = h_br_titulos_epc:QUERY
           wgh-buffer-bas-fornec-fin = wgh-query-bas-fornec-fin:GET-BUFFER-HANDLE(2).

    ON "MOUSE-SELECT-CLICK" OF h_br_titulos_epc PERSISTENT RUN pi-armazena-campos IN h_bas_fornecedor_fin_epc-01.

    /* criar colunas conhecimento Master, conhecimento House e status do t°tulo */
    RUN piFindWidget(INPUT "br_qry_tit_ap_fornec", INPUT "BROWSE", INPUT p_wgh_frame, OUTPUT c-handle-obj).

    ASSIGN wh_br_qry_tit_ap_fornec = WIDGET-HANDLE(ENTRY(01,c-handle-obj)).

    IF VALID-HANDLE(wh_br_qry_tit_ap_fornec) THEN DO:
        ASSIGN wh_query_tit_ap_fornec     = wh_br_qry_tit_ap_fornec:QUERY
               wh_buffer_tit_ap_fornec    = wh_query_tit_ap_fornec:GET-BUFFER-HANDLE()
               wh_status                  = wh_br_qry_tit_ap_fornec:ADD-CALC-COLUMN ("char", "x(16)", "", "Status T°tulo", 1)
               wh_status:WIDTH            = 12
               wh_status:READ-ONLY        = FALSE
               wh_conhec_master           = wh_br_qry_tit_ap_fornec:ADD-CALC-COLUMN ("char", "x(16)", "", "Conhecimento Master", 14)
               wh_conhec_master:WIDTH     = 20
               wh_conhec_master:READ-ONLY = FALSE
               wh_conhec_house            = wh_br_qry_tit_ap_fornec:ADD-CALC-COLUMN ("char", "x(16)", "", "Conhecimento House", 15)
               wh_conhec_house:WIDTH      = 20
               wh_conhec_house:READ-ONLY  = FALSE
               wh_pedido                  = wh_br_qry_tit_ap_fornec:ADD-CALC-COLUMN ("char", "x(16)", "", "Pedido", 16)
               wh_pedido:WIDTH            = 15
               wh_pedido:READ-ONLY        = FALSE.
    END.

    EMPTY TEMP-TABLE ttCol_bas_fornec.

    ASSIGN hCol = h_br_titulos_epc:FIRST-COLUMN.
    DO  WHILE VALID-HANDLE(hCol):
        IF  NOT CAN-FIND(FIRST ttCol_bas_fornec 
                           WHERE ttCol_bas_fornec.ColHdl = hCol) THEN  DO:
            CREATE ttCol_bas_fornec.
            ASSIGN ttCol_bas_fornec.ColHdl = hCol.
        END.
        hCol = hCol:NEXT-COLUMN.
    END.

    ON "ROW-DISPLAY" OF h_br_titulos_epc PERSISTENT RUN pi-alimenta-conhecimento IN h_bas_fornecedor_fin_epc-01.
    /* criar colunas conhecimento Master, conhecimento House e status do t°tulo */

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

