/*****************************************************************************
** Programa..............: apb711zd4_epc.p
** Descricao.............: EPC do Evento RowDisplay do browse br_pagto_conjunto 
** do programa fnc_item_lote_pagto_inclui_conjto
** Criado em.............: 03/02/2014
*****************************************************************************/

def input param p_ind_event       as char           no-undo.
def input param p_ind_object      as char           no-undo.
def input param p_wgh_object      as handle         no-undo.
def input param p_wgh_frame       as widget-handle  no-undo.
def input param p_cod_table       as char           no-undo.
def input param p_rec_table       as recid          no-undo.

def var c-objeto as char no-undo.

assign c-objeto = entry(num-entries(p_wgh_object:private-data, "~/"), p_wgh_object:private-data, "~/").
DEFINE NEW GLOBAL SHARED VARIABLE h_br_pagto_conjunto  AS widget-handle no-undo.
DEFINE NEW GLOBAL SHARED VARIABLE r-tit_ap_global AS ROWID no-undo.
DEFINE NEW GLOBAL SHARED VARIABLE wgh-query       AS widget-handle no-undo.
DEFINE NEW GLOBAL SHARED VARIABLE wgh-buffer      AS widget-handle no-undo.

def new global shared var v_rec_tit_ap
    as recid
    format ">>>>>>9":U
    initial ?
    no-undo.

DEF NEW GLOBAL SHARED TEMP-TABLE ttCol NO-UNDO
    FIELD ColHdl AS WIDGET-HANDLE.
DEFINE VARIABLE l-desconsidera AS LOGICAL     NO-UNDO.
DEFINE VARIABLE v_log_return AS LOGICAL     NO-UNDO.

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

/* message "EVENTO" p_ind_event skip
        "OBJETO" p_ind_object skip
        "NOME OBJ" c-objeto skip
        "FRAME" p_wgh_frame skip
        "TABELA" p_cod_table skip
        "ROWID" string(p_rec_table) view-as alert-box. */

DEFINE VARIABLE wgh-estab AS HANDLE      NO-UNDO.
DEFINE VARIABLE wgh-fornecedor AS HANDLE      NO-UNDO.
DEFINE VARIABLE wgh-especie AS HANDLE      NO-UNDO.
DEFINE VARIABLE wgh-serie AS HANDLE      NO-UNDO.
DEFINE VARIABLE wgh-cod-tit-ap AS HANDLE      NO-UNDO.
DEFINE VARIABLE wgh-parcela AS HANDLE      NO-UNDO.
DEFINE VARIABLE wgh-cod-forma-pagto AS HANDLE      NO-UNDO.

PROCEDURE pi-armazena-campos:

    DEF VAR i AS INTEGER NO-UNDO.

    ASSIGN wgh-estab      = wgh-buffer:BUFFER-FIELD("tta_cod_estab") 
           wgh-fornecedor = wgh-buffer:BUFFER-FIELD("tta_cdn_fornecedor") 
           wgh-especie    = wgh-buffer:BUFFER-FIELD("tta_cod_espec_docto") 
           wgh-serie      = wgh-buffer:BUFFER-FIELD("tta_cod_ser_docto") 
           wgh-cod-tit-ap = wgh-buffer:BUFFER-FIELD("tta_cod_tit_ap") 
           wgh-parcela    = wgh-buffer:BUFFER-FIELD("tta_cod_parcela")
           wgh-cod-forma-pagto = wgh-buffer:BUFFER-FIELD("tta_cod_forma_pagto").

    FIND FIRST tit_ap NO-LOCK
        WHERE tit_ap.cod_estab       = wgh-estab:BUFFER-VALUE 
          AND tit_ap.cod_espec_docto = wgh-especie:BUFFER-VALUE 
          AND tit_ap.cod_ser_docto   = wgh-serie:BUFFER-VALUE 
          AND tit_ap.cdn_fornecedor  = wgh-fornecedor:BUFFER-VALUE 
          AND tit_ap.cod_tit_ap      = wgh-cod-tit-ap:BUFFER-VALUE 
          AND tit_ap.cod_parcela     = wgh-parcela:BUFFER-VALUE 
        NO-ERROR.

    IF  AVAIL tit_ap THEN
        ASSIGN r-tit_ap_global = ROWID(tit_ap)
               v_rec_tit_ap    = RECID(tit_ap).
    ELSE
        ASSIGN r-tit_ap_global = ?
               v_rec_tit_ap    = ?.

    /*
    MESSAGE wgh-estab:BUFFER-VALUE       skip
            wgh-especie:BUFFER-VALUE     skip
            wgh-serie:BUFFER-VALUE       skip
            wgh-fornecedor:BUFFER-VALUE  skip
            wgh-cod-tit-ap:BUFFER-VALUE  skip
            wgh-parcela:BUFFER-VALUE     skip
            string(r-tit_ap_global) 

        VIEW-AS ALERT-BOX INFO BUTTONS OK.
    */

END.
