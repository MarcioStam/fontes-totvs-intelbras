/*****************************************************************************
** Programa..............: apb206aa_epc_01.p
** Descricao.............: EPC do Evento RowDisplay do browse 
**                         br_compl_movto_pagto_estab_corp do programa 
**                         bas_compl_movto_pagto.
** Criado em.............: 21/08/2018
*****************************************************************************/

def input param p_ind_event  as char          no-undo.
def input param p_ind_object as char          no-undo.
def input param p_wgh_object as handle        no-undo.
def input param p_wgh_frame  as widget-handle no-undo.
def input param p_cod_table  as char          no-undo.
def input param p_rec_table  as recid         no-undo.

def var c-objeto as char no-undo.

assign c-objeto = entry(num-entries(p_wgh_object:private-data, "~/"), p_wgh_object:private-data, "~/").

DEF NEW GLOBAL SHARED VAR h_br_titulos_epc          AS widget-handle no-undo.
DEF NEW GLOBAL SHARED VAR r-tit_ap_global           AS ROWID         no-undo.
DEF NEW GLOBAL SHARED VAR wgh-query-bas-fornec-fin  AS widget-handle no-undo.
DEF NEW GLOBAL SHARED VAR wgh-buffer-bas-fornec-fin AS widget-handle no-undo.
DEF NEW GLOBAL SHARED VAR wgh-bt-titulos_epc        AS widget-handle no-undo.

DEF NEW GLOBAL SHARED TEMP-TABLE ttCol NO-UNDO
    FIELD ColHdl AS WIDGET-HANDLE.

DEF VAR l-desconsidera AS LOGICAL NO-UNDO.
DEF VAR v_log_return   AS LOGICAL NO-UNDO.

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

DEF NEW GLOBAL SHARED temp-table tt_pessoa_jurid_matriz     no-undo
    field tta_num_pessoa_jurid             as integer format ">>>,>>>,>>9" initial 0 label "Pessoa Jur¡dica" column-label "Pessoa Jur¡dica".

DEF NEW GLOBAL SHARED temp-table tt_pessoa_jurid_matriz_aux no-undo
    field tta_num_pessoa_jurid             as integer format ">>>,>>>,>>9" initial 0 label "Pessoa Jur¡dica" column-label "Pessoa Jur¡dica"
    index tt_index                 
        tta_num_pessoa_jurid               ascending.

DEF NEW GLOBAL SHARED VAR h_fornec_bas_fin AS WIDGET-HANDLE NO-UNDO.

DEF NEW GLOBAL SHARED VAR wh_query_tit_ap_fornec AS widget-handle no-undo.
DEF NEW GLOBAL SHARED VAR wh_conhec_master       AS widget-handle no-undo.
DEF NEW GLOBAL SHARED VAR wh_conhec_house        AS widget-handle no-undo.
DEF NEW GLOBAL SHARED VAR wh_hist_impl           AS widget-handle no-undo.

DEF VAR wgh-estab           AS HANDLE NO-UNDO.
DEF VAR wgh-fornecedor      AS HANDLE NO-UNDO.
DEF VAR wgh-especie         AS HANDLE NO-UNDO.
DEF VAR wgh-serie           AS HANDLE NO-UNDO.
DEF VAR wgh-cod-tit-ap      AS HANDLE NO-UNDO.
DEF VAR wgh-parcela         AS HANDLE NO-UNDO.
DEF VAR wgh-cod-forma-pagto AS HANDLE NO-UNDO.

DEF NEW GLOBAL SHARED VAR c-cod-house  LIKE embarque-imp.cod-conhecto-house  NO-UNDO.
DEF NEW GLOBAL SHARED VAR c-cod-master LIKE embarque-imp.cod-conhecto-master NO-UNDO.

DEF BUFFER b_movto_tit_ap   FOR movto_tit_ap.
DEF BUFFER b_movto_tit_ap_2 FOR movto_tit_ap.
DEF BUFFER b_tit_ap         FOR tit_ap.

PROCEDURE pi-alimenta-conhecimento:

    ASSIGN wgh-estab      = wgh-buffer-bas-fornec-fin:BUFFER-FIELD("tta_cod_estab") 
           wgh-fornecedor = wgh-buffer-bas-fornec-fin:BUFFER-FIELD("tta_cdn_fornecedor") 
           wgh-especie    = wgh-buffer-bas-fornec-fin:BUFFER-FIELD("tta_cod_espec_docto") 
           wgh-serie      = wgh-buffer-bas-fornec-fin:BUFFER-FIELD("tta_cod_ser_docto") 
           wgh-cod-tit-ap = wgh-buffer-bas-fornec-fin:BUFFER-FIELD("tta_cod_tit_ap") 
           wgh-parcela    = wgh-buffer-bas-fornec-fin:BUFFER-FIELD("tta_cod_parcela").

    IF  wgh-especie:BUFFER-VALUE <> "VA"
    AND wgh-especie:BUFFER-VALUE <> "VP"
    AND wgh-especie:BUFFER-VALUE <> "VN"
    AND wgh-especie:BUFFER-VALUE <> "RE"
    AND wgh-especie:BUFFER-VALUE <> "PV"
    AND wgh-especie:BUFFER-VALUE <> "VM"
    AND wgh-especie:BUFFER-VALUE <> "PP"
    AND wgh-especie:BUFFER-VALUE <> "VC"
    AND wgh-especie:BUFFER-VALUE <> "TE"
    AND wgh-especie:BUFFER-VALUE <> "AR" 
    AND wgh-especie:BUFFER-VALUE <> "AR"
    AND wgh-especie:BUFFER-VALUE <> "DI" THEN NEXT.

    FIND FIRST tit_ap 
        WHERE tit_ap.cod_estab       = wgh-estab:BUFFER-VALUE 
        AND   tit_ap.cdn_fornecedor  = wgh-fornecedor:BUFFER-VALUE 
        AND   tit_ap.cod_espec_docto = wgh-especie:BUFFER-VALUE 
        AND   tit_ap.cod_ser_docto   = wgh-serie:BUFFER-VALUE 
        AND   tit_ap.cod_tit_ap      = wgh-cod-tit-ap:BUFFER-VALUE 
        AND   tit_ap.cod_parcela     = wgh-parcela:BUFFER-VALUE NO-LOCK NO-ERROR.

    IF  AVAIL tit_ap THEN DO:

        FIND FIRST movto_tit_ap OF tit_ap
            WHERE movto_tit_ap.ind_trans_ap = "Transf Estabelecimento" NO-LOCK NO-ERROR.

        IF  AVAIL movto_tit_ap THEN DO:

            find first b_movto_tit_ap
                where b_movto_tit_ap.cod_estab           = movto_tit_ap.cod_estab_tit_ap_pai
                and   b_movto_tit_ap.num_id_movto_tit_ap = movto_tit_ap.num_id_movto_tit_ap_pai NO-LOCK NO-ERROR.

            IF  AVAIL b_movto_tit_ap THEN DO:

                FIND FIRST b_tit_ap
                    WHERE b_tit_ap.cod_estab     = b_movto_tit_ap.cod_estab
                    AND   b_tit_ap.num_id_tit_ap = b_movto_tit_ap.num_id_tit_ap NO-LOCK NO-ERROR.

                IF  AVAIL b_tit_ap THEN DO:

                    FIND FIRST b_movto_tit_ap_2 OF b_tit_ap
                        WHERE b_movto_tit_ap_2.ind_trans_ap = "Implanta‡Æo" NO-LOCK NO-ERROR.

                    IF  AVAIL b_movto_tit_ap_2 THEN DO:
                        FIND FIRST histor_tit_movto_ap 
                            WHERE histor_tit_movto_ap.cod_estab           = b_tit_ap.cod_estab
                            AND   histor_tit_movto_ap.num_id_tit_ap       = b_tit_ap.num_id_tit_ap
                            AND   histor_tit_movto_ap.num_id_movto_tit_ap = b_movto_tit_ap_2.num_id_movto_tit_ap
                            AND   histor_tit_movto_ap.ind_orig_histor_ap <> "Erro" NO-LOCK NO-ERROR.

                        IF  AVAIL histor_tit_movto_ap THEN 
                            ASSIGN wh_hist_impl:SCREEN-VALUE = histor_tit_movto_ap.des_text_histor.
                    END.

                    IF  tit_ap.cod_espec_docto = "DI" THEN DO:
                        FIND FIRST embarque-imp
                            WHERE embarque-imp.cod-estabel = b_tit_ap.cod_estab
                            AND   embarque-imp.embarque    = b_tit_ap.cod_tit_ap NO-LOCK NO-ERROR.
                
                        IF  AVAIL embarque-imp THEN
                            ASSIGN wh_conhec_house:SCREEN-VALUE  = embarque-imp.cod-conhecto-house
                                   wh_conhec_master:SCREEN-VALUE = embarque-imp.cod-conhecto-master.
                    END.
                END.
            END.
        END.
        ELSE DO:
            FIND FIRST b_movto_tit_ap_2 OF tit_ap
                WHERE b_movto_tit_ap_2.ind_trans_ap = "Implanta‡Æo" NO-LOCK NO-ERROR.

            IF  AVAIL b_movto_tit_ap_2 THEN DO:
                FIND FIRST histor_tit_movto_ap 
                    WHERE histor_tit_movto_ap.cod_estab           = tit_ap.cod_estab
                    AND   histor_tit_movto_ap.num_id_tit_ap       = tit_ap.num_id_tit_ap
                    AND   histor_tit_movto_ap.num_id_movto_tit_ap = b_movto_tit_ap_2.num_id_movto_tit_ap
                    AND   histor_tit_movto_ap.ind_orig_histor_ap <> "Erro" NO-LOCK NO-ERROR.

                IF  AVAIL histor_tit_movto_ap THEN 
                    ASSIGN wh_hist_impl:SCREEN-VALUE = histor_tit_movto_ap.des_text_histor.
            END.

            IF  tit_ap.cod_espec_docto = "DI" THEN DO:
                FIND FIRST embarque-imp
                    WHERE embarque-imp.cod-estabel = tit_ap.cod_estab
                    AND   embarque-imp.embarque    = tit_ap.cod_tit_ap NO-LOCK NO-ERROR.
        
                IF  AVAIL embarque-imp THEN
                    ASSIGN wh_conhec_house:SCREEN-VALUE  = embarque-imp.cod-conhecto-house
                           wh_conhec_master:SCREEN-VALUE = embarque-imp.cod-conhecto-master.
            END.
        END.
    END.
END.
