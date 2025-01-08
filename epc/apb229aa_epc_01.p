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

def var c-objeto       as CHAR                no-undo.
DEF VAR v_cta_corrente AS CHAR FORMAT "x(13)" NO-UNDO.

assign c-objeto = entry(num-entries(p_wgh_object:private-data, "~/"), p_wgh_object:private-data, "~/").

DEF NEW GLOBAL SHARED VAR h_br_titulos_epc          AS widget-handle no-undo.
DEF NEW GLOBAL SHARED VAR r-tit_ap_global           AS ROWID         no-undo.
DEF NEW GLOBAL SHARED VAR wgh-query-bas-fornec-fin  AS widget-handle no-undo.
DEF NEW GLOBAL SHARED VAR wgh-buffer-bas-fornec-fin AS widget-handle no-undo.
DEF NEW GLOBAL SHARED VAR wgh-bt-titulos_epc        AS widget-handle no-undo.

DEF NEW GLOBAL SHARED TEMP-TABLE ttCol_apb229aa NO-UNDO
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

DEF NEW GLOBAL SHARED VAR wh_query_tit_ap_fornec    AS widget-handle no-undo.
DEF NEW GLOBAL SHARED VAR wh_liber_aut              AS widget-handle no-undo.
DEF NEW GLOBAL SHARED VAR wh_forma_pag              AS widget-handle no-undo.
DEF NEW GLOBAL SHARED VAR wh_cod_banco              AS widget-handle no-undo.
DEF NEW GLOBAL SHARED VAR wh_cod_agenc_bcia         AS widget-handle no-undo.
DEF NEW GLOBAL SHARED VAR wh_cod_cta_corren_bco     AS widget-handle no-undo.
DEF NEW GLOBAL SHARED VAR wh_cod_usuario            AS widget-handle no-undo.
DEF NEW GLOBAL SHARED VAR wh_razao_social           AS widget-handle no-undo.
DEF NEW GLOBAL SHARED VAR wh_email                  AS widget-handle no-undo.
DEF NEW GLOBAL SHARED VAR wh_tit_ap_implant_status  AS widget-handle no-undo.

DEF VAR wgh-estab           AS HANDLE NO-UNDO.
DEF VAR wgh-fornecedor      AS HANDLE NO-UNDO.
DEF VAR wgh-especie         AS HANDLE NO-UNDO.
DEF VAR wgh-serie           AS HANDLE NO-UNDO.
DEF VAR wgh-cod-tit-ap      AS HANDLE NO-UNDO.
DEF VAR wgh-parcela         AS HANDLE NO-UNDO.
DEF VAR wgh-cod-forma-pagto AS HANDLE NO-UNDO.

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

    FIND FIRST tit_ap 
        WHERE tit_ap.cod_estab       = wgh-estab:BUFFER-VALUE 
        AND   tit_ap.cdn_fornecedor  = wgh-fornecedor:BUFFER-VALUE 
        AND   tit_ap.cod_espec_docto = wgh-especie:BUFFER-VALUE 
        AND   tit_ap.cod_ser_docto   = wgh-serie:BUFFER-VALUE 
        AND   tit_ap.cod_tit_ap      = wgh-cod-tit-ap:BUFFER-VALUE 
        AND   tit_ap.cod_parcela     = wgh-parcela:BUFFER-VALUE NO-LOCK NO-ERROR.

    IF  AVAIL tit_ap THEN DO:

        ASSIGN wh_liber_aut:SCREEN-VALUE = "NÆo".

        /* Considerar apenas fornecedores cadastrados no es0018 para libera‡Æo autom tica */
        FOR FIRST ponto-programa NO-LOCK USE-INDEX ponto
            WHERE ponto-programa.nome-programa = "apb739za":U
            AND   ponto-programa.ponto         = 1:

            FIND FIRST conteudo-programa
                 WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
                 AND   conteudo-programa.conteudo     = STRING(tit_ap.cdn_fornecedor) NO-LOCK NO-ERROR.

            IF  AVAIL conteudo-programa THEN DO:

                FIND first proces_pagto OF tit_ap NO-LOCK NO-ERROR.

                IF  AVAIL proces_pagto THEN
                    ASSIGN wh_liber_aut:SCREEN-VALUE = "Sim".
                ELSE
                    ASSIGN wh_liber_aut:SCREEN-VALUE = "NÆo".
            END.
        END.

        FIND FIRST fornec_financ
             WHERE fornec_financ.cod_empresa  = tit_ap.cod_empresa
             AND   fornec_financ.cdn_fornec   = tit_ap.cdn_fornecedor NO-LOCK NO-ERROR.

        IF  AVAIL fornec_financ THEN DO:
            IF  fornec_financ.cod_digito_agenc_bcia = "" THEN
                ASSIGN v_cta_corrente = fornec_financ.cod_agenc_bcia.
            ELSE
                ASSIGN v_cta_corrente = fornec_financ.cod_agenc_bcia + "-" + fornec_financ.cod_digito_agenc_bcia.

            ASSIGN wh_forma_pag:SCREEN-VALUE          = fornec_financ.cod_forma_pagto
                   wh_cod_banco:SCREEN-VALUE          = fornec_financ.cod_banco
                   wh_cod_agenc_bcia:SCREEN-VALUE     = v_cta_corrente
                   wh_cod_cta_corren_bco:SCREEN-VALUE = fornec_financ.cod_cta_corren_bco.

           IF tit_ap.num_pessoa MODULO 2 = 0 THEN DO:
               FIND pessoa_fisic NO-LOCK
                   WHERE pessoa_fisic.num_pessoa_fisic = tit_ap.num_pessoa NO-ERROR.
               
               IF  AVAIL pessoa_fisic THEN
                   ASSIGN wh_razao_social:SCREEN-VALUE = pessoa_fisic.nom_pessoa
                          wh_email:SCREEN-VALUE        = pessoa_fisic.cod_e_mail.
           END.
           ELSE DO:
               FIND pessoa_jurid NO-LOCK
                   WHERE pessoa_jurid.num_pessoa_jurid = tit_ap.num_pessoa NO-ERROR.
               
               IF AVAIL pessoa_jurid THEN
                   ASSIGN wh_razao_social:SCREEN-VALUE = pessoa_jurid.nom_pessoa
                          wh_email:SCREEN-VALUE        = pessoa_jurid.cod_e_mail.
           END.
        END.

        FIND FIRST movto_tit_ap OF tit_ap NO-LOCK NO-ERROR.

        IF  AVAIL movto_tit_ap THEN
            ASSIGN wh_cod_usuario:SCREEN-VALUE = movto_tit_ap.cod_usuario.

        FIND LAST proces_pagto OF tit_ap NO-LOCK NO-ERROR.

        IF  AVAIL proces_pagto THEN
            ASSIGN wh_tit_ap_implant_status:SCREEN-VALUE = proces_pagto.ind_sit_proces_pagto.

        IF  tit_ap.log_livre_2 = YES THEN DO:
            ASSIGN wh_tit_ap_implant_status:SCREEN-VALUE = "Em Tratamento".

            FOR FIRST ttCol_apb229aa:
                ASSIGN ttCol_apb229aa.ColHdl:BGCOLOR = 5 /* Roxo */
                       ttCol_apb229aa.ColHdl:FGCOLOR = 0. /* preto */
            END.
        END. 
    END.    
END.
