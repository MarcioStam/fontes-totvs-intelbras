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

{esp/es0018.i}

def var c-objeto as char no-undo.

assign c-objeto = entry(num-entries(p_wgh_object:private-data, "~/"), p_wgh_object:private-data, "~/").
DEFINE NEW GLOBAL SHARED VARIABLE h_br_titulos_epc  AS widget-handle no-undo.
DEFINE NEW GLOBAL SHARED VARIABLE r-tit_ap_global AS ROWID no-undo.
DEFINE NEW GLOBAL SHARED VARIABLE wgh-query-bas-fornec-fin       AS widget-handle no-undo.
DEFINE NEW GLOBAL SHARED VARIABLE wgh-buffer-bas-fornec-fin      AS widget-handle no-undo.
DEFINE NEW GLOBAL SHARED VARIABLE wgh-bt-titulos_epc AS widget-handle no-undo.

DEF NEW GLOBAL SHARED TEMP-TABLE ttCol_bas_fornec NO-UNDO
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
    field tta_num_pessoa_jurid             as integer format ">>>,>>>,>>9" initial 0 label "Pessoa Jur°dica" column-label "Pessoa Jur°dica".

DEF NEW GLOBAL SHARED temp-table tt_pessoa_jurid_matriz_aux no-undo
    field tta_num_pessoa_jurid             as integer format ">>>,>>>,>>9" initial 0 label "Pessoa Jur°dica" column-label "Pessoa Jur°dica"
    index tt_index                 
        tta_num_pessoa_jurid               ascending.

DEFINE NEW GLOBAL SHARED VAR h_fornec_bas_fin AS WIDGET-HANDLE NO-UNDO.

DEF NEW GLOBAL SHARED VAR wh_query_tit_ap_fornec    AS widget-handle no-undo.
DEF NEW GLOBAL SHARED VAR wh_conhec_master          AS widget-handle no-undo.
DEF NEW GLOBAL SHARED VAR wh_conhec_house           AS widget-handle no-undo.
DEF NEW GLOBAL SHARED VAR wh_status                 AS widget-handle no-undo.
DEF NEW GLOBAL SHARED VAR wh_pedido                 AS widget-handle no-undo.

DEFINE VARIABLE wgh-estab AS HANDLE       NO-UNDO.
DEFINE VARIABLE wgh-fornecedor AS HANDLE  NO-UNDO.
DEFINE VARIABLE wgh-especie AS HANDLE     NO-UNDO.
DEFINE VARIABLE wgh-serie AS HANDLE       NO-UNDO.
DEFINE VARIABLE wgh-cod-tit-ap AS HANDLE  NO-UNDO.
DEFINE VARIABLE wgh-parcela AS HANDLE     NO-UNDO.
DEFINE VARIABLE wgh-cod-forma-pagto       AS HANDLE NO-UNDO.

DEF NEW GLOBAL SHARED VAR c-cod-house  LIKE embarque-imp.cod-conhecto-house  NO-UNDO.
DEF NEW GLOBAL SHARED VAR c-cod-master LIKE embarque-imp.cod-conhecto-master NO-UNDO.

PROCEDURE pi-armazena-campos:
    DEF VAR i AS INTEGER NO-UNDO.

    IF VALID-HANDLE(wgh-bt-titulos_epc) AND wgh-bt-titulos_epc:SENSITIVE = NO THEN DO:
        ASSIGN wgh-estab      = wgh-buffer-bas-fornec-fin:BUFFER-FIELD("cod_estab") 
               wgh-fornecedor = wgh-buffer-bas-fornec-fin:BUFFER-FIELD("cdn_fornecedor") 
               wgh-especie    = wgh-buffer-bas-fornec-fin:BUFFER-FIELD("cod_espec_docto") 
               wgh-serie      = wgh-buffer-bas-fornec-fin:BUFFER-FIELD("cod_ser_docto") 
               wgh-cod-tit-ap = wgh-buffer-bas-fornec-fin:BUFFER-FIELD("cod_tit_ap") 
               wgh-parcela    = wgh-buffer-bas-fornec-fin:BUFFER-FIELD("cod_parcela").
        
        FIND FIRST tit_ap NO-LOCK
            WHERE tit_ap.cod_estab       = wgh-estab:BUFFER-VALUE 
              AND tit_ap.cod_espec_docto = wgh-especie:BUFFER-VALUE 
              AND tit_ap.cod_ser_docto   = wgh-serie:BUFFER-VALUE 
              AND tit_ap.cdn_fornecedor  = wgh-fornecedor:BUFFER-VALUE 
              AND tit_ap.cod_tit_ap      = wgh-cod-tit-ap:BUFFER-VALUE 
              AND tit_ap.cod_parcela     = wgh-parcela:BUFFER-VALUE 
            NO-ERROR.
    
        IF  AVAIL tit_ap THEN
            ASSIGN r-tit_ap_global = ROWID(tit_ap).
        ELSE
            ASSIGN r-tit_ap_global = ?.
    END.
    ELSE
        r-tit_ap_global = ?.
    
END.

PROCEDURE pi-alimenta-conhecimento:

    IF  VALID-HANDLE(wgh-buffer-bas-fornec-fin) THEN DO:
        ASSIGN wgh-estab      = wgh-buffer-bas-fornec-fin:BUFFER-FIELD("cod_estab") 
               wgh-fornecedor = wgh-buffer-bas-fornec-fin:BUFFER-FIELD("cdn_fornecedor") 
               wgh-especie    = wgh-buffer-bas-fornec-fin:BUFFER-FIELD("cod_espec_docto") 
               wgh-serie      = wgh-buffer-bas-fornec-fin:BUFFER-FIELD("cod_ser_docto") 
               wgh-cod-tit-ap = wgh-buffer-bas-fornec-fin:BUFFER-FIELD("cod_tit_ap") 
               wgh-parcela    = wgh-buffer-bas-fornec-fin:BUFFER-FIELD("cod_parcela").
    
        FIND FIRST tit_ap
            WHERE tit_ap.cod_estab       = wgh-estab:BUFFER-VALUE 
            AND   tit_ap.cod_espec_docto = wgh-especie:BUFFER-VALUE 
            AND   tit_ap.cod_ser_docto   = wgh-serie:BUFFER-VALUE 
            AND   tit_ap.cdn_fornecedor  = wgh-fornecedor:BUFFER-VALUE 
            AND   tit_ap.cod_tit_ap      = wgh-cod-tit-ap:BUFFER-VALUE 
            AND   tit_ap.cod_parcela     = wgh-parcela:BUFFER-VALUE NO-LOCK NO-ERROR.
    
        IF  AVAIL tit_ap THEN DO:    
            IF  tit_ap.cod_espec_docto = "DI" THEN DO:
                FIND FIRST embarque-imp
                    WHERE embarque-imp.cod-estabel = tit_ap.cod_estab
                    AND   embarque-imp.embarque    = tit_ap.cod_tit_ap NO-LOCK NO-ERROR.
        
                IF  AVAIL embarque-imp THEN
                    ASSIGN wh_conhec_house:SCREEN-VALUE  = embarque-imp.cod-conhecto-house
                           wh_conhec_master:SCREEN-VALUE = embarque-imp.cod-conhecto-master.
            END.
    
            FIND LAST proces_pagto OF tit_ap NO-LOCK NO-ERROR.
    
            IF  AVAIL proces_pagto THEN
                ASSIGN wh_status:SCREEN-VALUE = proces_pagto.ind_sit_proces_pagto.

            IF  tit_ap.log_livre_2 = YES THEN DO:
                ASSIGN wh_status:SCREEN-VALUE = "Em Tratamento".
    
                FOR FIRST ttCol_bas_fornec:
                    ASSIGN ttCol_bas_fornec.ColHdl:BGCOLOR = 5 /* Roxo */
                           ttCol_bas_fornec.ColHdl:FGCOLOR = 0. /* preto */
                END.
            END.  

            FIND FIRST emscad.fornecedor
                 WHERE emscad.fornecedor.cod_empresa = tit_ap.cod_empresa
                 AND   emscad.fornecedor.cdn_fornec  = tit_ap.cdn_fornecedor NO-LOCK NO-ERROR.

            IF  AVAIL emscad.fornecedor THEN DO:
                RUN esp/es0018p.p (INPUT "bas_fornec",
                                   INPUT 1,
                                   INPUT 0,
                                   INPUT "",
                                   OUTPUT TABLE tt-prog-ponto) NO-ERROR.
            
                IF  CAN-FIND (FIRST tt-prog-ponto
                              WHERE tt-prog-ponto.conteudo = string(emscad.fornecedor.cod_grp_fornec)) THEN
                    RUN pi_alimenta_pedido. /* coluna pedido */
            END.
        END.
    END.
END.

PROCEDURE pi_alimenta_pedido:
    def var v_num_espec_ems2 as integer no-undo.
    def var v_row_nota       as rowid   no-undo.

    find first espec_docto no-lock
        where espec_docto.cod_espec_docto = tit_ap.cod_espec_docto no-error.

    if  avail espec_docto then do:
        case espec_docto.ind_tip_espec_docto:
            when "Previs∆o" then
                assign v_num_espec_ems2 = 1.
            when "Normal" then
                assign v_num_espec_ems2 = 2.
            when "" then
                assign v_num_espec_ems2 = 3.
        end.
    end.

    if search('rep/reapi011.r') <> ? 
    or search('rep/reapi011.p') <> ? then
        run rep/reapi011.p (input 1,  /* 1- Verifica a existencia de NF no Recebimento */
                            input tit_ap.cdn_fornecedor,
                            input tit_ap.cod_tit_ap,
                            input tit_ap.cod_ser_docto,
                            input v_num_espec_ems2,
                            input-output v_row_nota).

    FIND FIRST docum-est
        WHERE ROWID(docum-est) = v_row_nota NO-LOCK NO-ERROR.

    FIND FIRST item-doc-est OF docum-est NO-LOCK NO-ERROR.

    IF  AVAIL item-doc-est THEN DO:
       IF  item-doc-est.num-pedido <> 0 THEN
           ASSIGN wh_pedido:SCREEN-VALUE = string(item-doc-est.num-pedido).
       ELSE DO:
           FIND FIRST rat-ordem
              WHERE rat-ordem.cod-emitente = item-doc-est.cod-emitente
              AND   rat-ordem.serie-docto  = item-doc-est.serie-docto
              AND   rat-ordem.nro-docto    = item-doc-est.nro-docto
              AND   rat-ordem.nat-operacao = item-doc-est.nat-operacao
              AND   rat-ordem.sequencia    = item-doc-est.sequencia NO-LOCK NO-ERROR.

           IF  AVAIL rat-ordem THEN
               ASSIGN wh_pedido:SCREEN-VALUE = string(rat-ordem.num-pedido).
       END.
    END.

END PROCEDURE.
