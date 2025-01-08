/*****************************************************************************
** Programa..............: apb229aa_epc.p
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
DEFINE NEW GLOBAL SHARED VAR h_br_bas_tit_ap_impl_period AS WIDGET-HANDLE NO-UNDO.

DEF NEW GLOBAL SHARED TEMP-TABLE ttCol_apb229aa NO-UNDO
    FIELD ColHdl AS WIDGET-HANDLE.

DEF NEW GLOBAL SHARED VAR h_br_titulos_epc             AS widget-handle no-undo.
DEF NEW GLOBAL SHARED VAR wgh-query-bas-fornec-fin     AS widget-handle no-undo.
DEF NEW GLOBAL SHARED VAR wgh-buffer-bas-fornec-fin    AS widget-handle no-undo.
DEF NEW GLOBAL SHARED VAR wgh-bt-titulos_epc           AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wgh-bt-titulos_epc           AS widget-handle no-undo.
DEF NEW GLOBAL SHARED VAR r-tit_ap_global              AS ROWID         no-undo.
DEF NEW GLOBAL SHARED VAR wh_br_bas_tit_ap_impl_period AS widget-handle no-undo.
DEF NEW GLOBAL SHARED VAR wh_liber_aut                 AS widget-handle no-undo.
DEF NEW GLOBAL SHARED VAR wh_forma_pag                 AS widget-handle no-undo.
DEF NEW GLOBAL SHARED VAR wh_cod_banco                 AS widget-handle no-undo.
DEF NEW GLOBAL SHARED VAR wh_cod_agenc_bcia            AS widget-handle no-undo.
DEF NEW GLOBAL SHARED VAR wh_cod_cta_corren_bco        AS widget-handle no-undo.
DEF NEW GLOBAL SHARED VAR wh_cod_usuario               AS widget-handle no-undo.
DEF NEW GLOBAL SHARED VAR wh_hist_impl                 AS widget-handle no-undo.
DEF NEW GLOBAL SHARED VAR wh_query_tit_ap_fornec       AS widget-handle no-undo.
DEF NEW GLOBAL SHARED VAR wh_buffer_tit_ap_fornec      AS widget-handle no-undo.
DEF NEW GLOBAL SHARED VAR wh_razao_social              AS widget-handle no-undo.
DEF NEW GLOBAL SHARED VAR wh_email                     AS widget-handle no-undo.
DEF NEW GLOBAL SHARED VAR wh_tit_ap_implant_status     AS widget-handle no-undo.

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

     RUN epc/apb229aa_epc_01.p PERSISTENT SET h_bas_fornecedor_fin_epc-01(INPUT p_ind_event,
                                                                          INPUT p_ind_object,
                                                                          INPUT p_wgh_object,
                                                                          INPUT p_wgh_frame,
                                                                          INPUT p_cod_table,
                                                                          INPUT p_rec_table).

    RUN piFindWidget(INPUT "br_bas_tit_ap_impl_period", INPUT "BROWSE", INPUT p_wgh_frame, OUTPUT h_br_titulos_epc).

    assign wgh-query-bas-fornec-fin  = h_br_titulos_epc:QUERY
           wgh-buffer-bas-fornec-fin = wgh-query-bas-fornec-fin:GET-BUFFER-HANDLE(1).
         
    /* criar colunas conhecimento Master e House */
    RUN piFindWidget(INPUT "br_bas_tit_ap_impl_period", INPUT "BROWSE", INPUT p_wgh_frame, OUTPUT c-handle-obj).

    ASSIGN wh_br_bas_tit_ap_impl_period = WIDGET-HANDLE(ENTRY(01,c-handle-obj)).

    IF VALID-HANDLE(wh_br_bas_tit_ap_impl_period) THEN DO:
        ASSIGN wh_query_tit_ap_fornec              = wh_br_bas_tit_ap_impl_period:QUERY
               wh_buffer_tit_ap_fornec             = wh_query_tit_ap_fornec:GET-BUFFER-HANDLE()
               wh_tit_ap_implant_status            = wh_br_bas_tit_ap_impl_period:ADD-CALC-COLUMN ("char", "x(16)", "", "Status T°tulo", 1)
               wh_tit_ap_implant_status:WIDTH      = 12
               wh_tit_ap_implant_status:READ-ONLY  = FALSE
               wh_liber_aut                        = wh_br_bas_tit_ap_impl_period:ADD-CALC-COLUMN ("char", "x(10)", "", "Lib.Autom†tica", 14)
               wh_liber_aut:WIDTH                  = 10
               wh_liber_aut:READ-ONLY              = FALSE
               wh_forma_pag                        = wh_br_bas_tit_ap_impl_period:ADD-CALC-COLUMN ("char", "x(8)", "", "Forma Pagto", 15)
               wh_forma_pag:WIDTH                  = 8
               wh_forma_pag:READ-ONLY              = FALSE
               wh_cod_banco                        = wh_br_bas_tit_ap_impl_period:ADD-CALC-COLUMN ("char", "x(5)", "", "Banco", 16)
               wh_cod_banco:WIDTH                  = 5
               wh_cod_banco:READ-ONLY              = FALSE
               wh_cod_agenc_bcia                   = wh_br_bas_tit_ap_impl_period:ADD-CALC-COLUMN ("char", "x(8)", "", "Agància", 17)
               wh_cod_agenc_bcia:WIDTH             = 8
               wh_cod_agenc_bcia:READ-ONLY         = FALSE
               wh_cod_cta_corren_bco               = wh_br_bas_tit_ap_impl_period:ADD-CALC-COLUMN ("char", "x(9)", "", "Cta Corrente", 18)
               wh_cod_cta_corren_bco:WIDTH         = 9
               wh_cod_cta_corren_bco:READ-ONLY     = FALSE
               wh_cod_usuario                      = wh_br_bas_tit_ap_impl_period:ADD-CALC-COLUMN ("char", "x(10)", "", "Usuar Impl", 19)
               wh_cod_usuario:WIDTH                = 10
               wh_cod_usuario:READ-ONLY            = FALSE
               wh_razao_social                     = wh_br_bas_tit_ap_impl_period:ADD-CALC-COLUMN ("char", "x(80)", "", "Raz∆o Social", 20)
               wh_razao_social:WIDTH               = 30
               wh_razao_social:READ-ONLY           = FALSE
               wh_email                            = wh_br_bas_tit_ap_impl_period:ADD-CALC-COLUMN ("char", "x(80)", "", "E-Mail", 21)
               wh_email:WIDTH                      = 30
               wh_email:READ-ONLY                  = FALSE.
    END.

    EMPTY TEMP-TABLE ttCol_apb229aa.

    ASSIGN hCol = h_br_titulos_epc:FIRST-COLUMN.
    DO  WHILE VALID-HANDLE(hCol):
        IF  NOT CAN-FIND(FIRST ttCol_apb229aa 
                           WHERE ttCol_apb229aa.ColHdl = hCol) THEN DO:
            CREATE ttCol_apb229aa.
            ASSIGN ttCol_apb229aa.ColHdl = hCol.
        END.
        hCol = hCol:NEXT-COLUMN.
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

