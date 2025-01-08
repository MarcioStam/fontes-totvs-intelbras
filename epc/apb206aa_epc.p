/*****************************************************************************
** Programa..............: apb206aa_epc.p
** Descricao.............: EPC do programa bas_compl_movto_pagto_pagto
** Criado em.............: 21/08/2018
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

DEFINE NEW GLOBAL SHARED VAR h_fornec_bas_fin       AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR h_br_compl_movto_pagto_estab_corp AS WIDGET-HANDLE NO-UNDO.

DEF NEW GLOBAL SHARED TEMP-TABLE ttCol NO-UNDO
    FIELD ColHdl AS WIDGET-HANDLE.

DEF NEW GLOBAL SHARED VAR h_br_titulos_epc          AS widget-handle no-undo.
DEF NEW GLOBAL SHARED VAR wgh-query-bas-fornec-fin  AS widget-handle no-undo.
DEF NEW GLOBAL SHARED VAR wgh-buffer-bas-fornec-fin AS widget-handle no-undo.
DEF NEW GLOBAL SHARED VAR wgh-bt-titulos_epc        AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wgh-bt-titulos_epc        AS widget-handle no-undo.
DEF NEW GLOBAL SHARED VAR r-tit_ap_global           AS ROWID         no-undo.
DEF NEW GLOBAL SHARED VAR wh_br_compl_movto_pagto_estab_corp   AS widget-handle no-undo.
DEF NEW GLOBAL SHARED VAR wh_conhec_master          AS widget-handle no-undo.
DEF NEW GLOBAL SHARED VAR wh_conhec_house           AS widget-handle no-undo.
DEF NEW GLOBAL SHARED VAR wh_hist_impl              AS widget-handle no-undo.
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

IF   p_ind_event = "DISPLAY" THEN
     r-tit_ap_global = ?.
     

if  p_ind_event = "INITIALIZE" then do:

     RUN epc/apb206aa_epc_01.p PERSISTENT SET h_bas_fornecedor_fin_epc-01(INPUT p_ind_event,
                                                                          INPUT p_ind_object,
                                                                          INPUT p_wgh_object,
                                                                          INPUT p_wgh_frame,
                                                                          INPUT p_cod_table,
                                                                          INPUT p_rec_table).

    RUN piFindWidget(INPUT "br_compl_movto_pagto_estab_corp", INPUT "BROWSE", INPUT p_wgh_frame, OUTPUT h_br_titulos_epc).

    assign wgh-query-bas-fornec-fin  = h_br_titulos_epc:QUERY
           wgh-buffer-bas-fornec-fin = wgh-query-bas-fornec-fin:GET-BUFFER-HANDLE(1).

    EMPTY TEMP-TABLE ttCol.

    ASSIGN hCol = h_br_titulos_epc:FIRST-COLUMN.
    DO  WHILE VALID-HANDLE(hCol):
        IF  NOT CAN-FIND(FIRST ttCol 
                           WHERE ttCol.ColHdl = hCol) THEN  DO:
            CREATE ttCol.
            ASSIGN ttCol.ColHdl = hCol.
        END.
        hCol = hCol:NEXT-COLUMN.
    END.
         
    /* criar colunas conhecimento Master e House */
    RUN piFindWidget(INPUT "br_compl_movto_pagto_estab_corp", INPUT "BROWSE", INPUT p_wgh_frame, OUTPUT c-handle-obj).

    ASSIGN wh_br_compl_movto_pagto_estab_corp = WIDGET-HANDLE(ENTRY(01,c-handle-obj)).

    IF VALID-HANDLE(wh_br_compl_movto_pagto_estab_corp) THEN DO:
        ASSIGN wh_query_tit_ap_fornec     = wh_br_compl_movto_pagto_estab_corp:QUERY
               wh_buffer_tit_ap_fornec    = wh_query_tit_ap_fornec:GET-BUFFER-HANDLE()
               wh_conhec_master           = wh_br_compl_movto_pagto_estab_corp:ADD-CALC-COLUMN ("char", "x(16)", "", "Conhecimento Master", 28)
               wh_conhec_master:WIDTH     = 20
               wh_conhec_master:READ-ONLY = FALSE
               wh_conhec_house            = wh_br_compl_movto_pagto_estab_corp:ADD-CALC-COLUMN ("char", "x(16)", "", "Conhecimento House", 29)
               wh_conhec_house:WIDTH      = 20
               wh_conhec_house:READ-ONLY  = FALSE
               wh_hist_impl               = wh_br_compl_movto_pagto_estab_corp:ADD-CALC-COLUMN ("char", "x(200)", "", "Hist¢rico Implanta‡Æo", 30)
               wh_hist_impl:WIDTH         = 50
               wh_hist_impl:READ-ONLY     = FALSE.
    END.

    ON "ROW-DISPLAY" OF h_br_titulos_epc PERSISTENT RUN pi-alimenta-conhecimento IN h_bas_fornecedor_fin_epc-01.
    /* criar colunas conhecimento Master e House */

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

