/*****************************************************************************
** Programa..............: bas_tit_ap_em_aberto_epc_01.p
** Descricao.............: EPC browse br_tit_ap_em_aberto 
** do programa bas_tit_ap_em_aberto
** Criado em.............: 18/08/2021
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
DEF NEW GLOBAL SHARED VAR wgh-query-bas-tit-aberto  AS widget-handle no-undo.
DEF NEW GLOBAL SHARED VAR wgh-buffer-bas-tit-aberto AS widget-handle no-undo.
DEF NEW GLOBAL SHARED VAR wh_query_tit_ap_fornec    AS widget-handle no-undo.
DEF NEW GLOBAL SHARED VAR wh_tit_ap_abert_status    AS widget-handle no-undo.

DEF NEW GLOBAL SHARED TEMP-TABLE ttCol_bas_tit_aberto NO-UNDO
    FIELD ColHdl AS WIDGET-HANDLE.

DEF VAR wgh-estab           AS HANDLE NO-UNDO.
DEF VAR wgh-fornecedor      AS HANDLE NO-UNDO.
DEF VAR wgh-especie         AS HANDLE NO-UNDO.
DEF VAR wgh-serie           AS HANDLE NO-UNDO.
DEF VAR wgh-cod-tit-ap      AS HANDLE NO-UNDO.
DEF VAR wgh-parcela         AS HANDLE NO-UNDO.
DEF VAR wgh-cod-forma-pagto AS HANDLE NO-UNDO.


PROCEDURE pi-armazena-campos:

    IF  VALID-HANDLE(wgh-buffer-bas-tit-aberto) THEN DO:
        ASSIGN wgh-estab      = wgh-buffer-bas-tit-aberto:BUFFER-FIELD("tta_cod_estab")       
               wgh-fornecedor = wgh-buffer-bas-tit-aberto:BUFFER-FIELD("tta_cdn_fornecedor")  
               wgh-especie    = wgh-buffer-bas-tit-aberto:BUFFER-FIELD("tta_cod_espec_docto")  
               wgh-serie      = wgh-buffer-bas-tit-aberto:BUFFER-FIELD("tta_cod_ser_docto")   
               wgh-cod-tit-ap = wgh-buffer-bas-tit-aberto:BUFFER-FIELD("tta_cod_tit_ap")      
               wgh-parcela    = wgh-buffer-bas-tit-aberto:BUFFER-FIELD("tta_cod_parcela").    
        
        FIND FIRST tit_ap
            WHERE tit_ap.cod_estab       = wgh-estab:BUFFER-VALUE 
            AND   tit_ap.cod_espec_docto = wgh-especie:BUFFER-VALUE 
            AND   tit_ap.cod_ser_docto   = wgh-serie:BUFFER-VALUE 
            AND   tit_ap.cdn_fornecedor  = wgh-fornecedor:BUFFER-VALUE 
            AND   tit_ap.cod_tit_ap      = wgh-cod-tit-ap:BUFFER-VALUE 
            AND   tit_ap.cod_parcela     = wgh-parcela:BUFFER-VALUE NO-LOCK NO-ERROR.
    
        IF  AVAIL tit_ap THEN
            ASSIGN r-tit_ap_global = ROWID(tit_ap).
        ELSE
            ASSIGN r-tit_ap_global = ?.
    END.
    ELSE
        ASSIGN r-tit_ap_global = ?.
END.

PROCEDURE pi-alimenta-conhecimento:

    IF  VALID-HANDLE(wgh-buffer-bas-tit-aberto) THEN DO:
        ASSIGN wgh-estab      = wgh-buffer-bas-tit-aberto:BUFFER-FIELD("tta_cod_estab") 
               wgh-fornecedor = wgh-buffer-bas-tit-aberto:BUFFER-FIELD("tta_cdn_fornecedor") 
               wgh-especie    = wgh-buffer-bas-tit-aberto:BUFFER-FIELD("tta_cod_espec_docto") 
               wgh-serie      = wgh-buffer-bas-tit-aberto:BUFFER-FIELD("tta_cod_ser_docto") 
               wgh-cod-tit-ap = wgh-buffer-bas-tit-aberto:BUFFER-FIELD("tta_cod_tit_ap") 
               wgh-parcela    = wgh-buffer-bas-tit-aberto:BUFFER-FIELD("tta_cod_parcela").
    
        FIND FIRST tit_ap
            WHERE tit_ap.cod_estab       = wgh-estab:BUFFER-VALUE 
            AND   tit_ap.cod_espec_docto = wgh-especie:BUFFER-VALUE 
            AND   tit_ap.cod_ser_docto   = wgh-serie:BUFFER-VALUE 
            AND   tit_ap.cdn_fornecedor  = wgh-fornecedor:BUFFER-VALUE 
            AND   tit_ap.cod_tit_ap      = wgh-cod-tit-ap:BUFFER-VALUE 
            AND   tit_ap.cod_parcela     = wgh-parcela:BUFFER-VALUE NO-LOCK NO-ERROR.
    
        IF  AVAIL tit_ap THEN DO:    
            FIND LAST proces_pagto OF tit_ap NO-LOCK NO-ERROR.
    
            IF  AVAIL proces_pagto THEN
                ASSIGN wh_tit_ap_abert_status:SCREEN-VALUE = proces_pagto.ind_sit_proces_pagto.
    
            IF  tit_ap.log_livre_2 = YES THEN DO:
                ASSIGN wh_tit_ap_abert_status:SCREEN-VALUE = "Em Tratamento".
    
                FOR FIRST ttCol_bas_tit_aberto:
                    ASSIGN ttCol_bas_tit_aberto.ColHdl:BGCOLOR = 5 /* Roxo */
                           ttCol_bas_tit_aberto.ColHdl:FGCOLOR = 0. /* preto */
                END.
            END.    
        END.
    END.
END.
