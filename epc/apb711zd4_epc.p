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

DEFINE NEW GLOBAL SHARED VARIABLE wgh-query      AS widget-handle no-undo.
DEFINE NEW GLOBAL SHARED VARIABLE wgh-buffer     AS widget-handle no-undo.
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

/*message "EVENTO" p_ind_event skip
        "OBJETO" p_ind_object skip
        "NOME OBJ" c-objeto skip
        "FRAME" p_wgh_frame skip
        "TABELA" p_cod_table skip
        "ROWID" string(p_rec_table) view-as alert-box. */

DEFINE VARIABLE wgh-estab                 AS HANDLE NO-UNDO.
DEFINE VARIABLE wgh-fornecedor            AS HANDLE NO-UNDO.
DEFINE VARIABLE wgh-especie               AS HANDLE NO-UNDO.
DEFINE VARIABLE wgh-serie                 AS HANDLE NO-UNDO.
DEFINE VARIABLE wgh-cod-tit-ap            AS HANDLE NO-UNDO.
DEFINE VARIABLE wgh-parcela               AS HANDLE NO-UNDO.
DEFINE VARIABLE wgh-cod-forma-pagto       AS HANDLE NO-UNDO.
DEFINE VARIABLE wgh-cod-refer-antecip-pef AS HANDLE NO-UNDO.

PROCEDURE pi-row-display:

    ASSIGN wgh-estab                 = wgh-buffer:BUFFER-FIELD("tta_cod_estab") 
           wgh-fornecedor            = wgh-buffer:BUFFER-FIELD("tta_cdn_fornecedor") 
           wgh-especie               = wgh-buffer:BUFFER-FIELD("tta_cod_espec_docto") 
           wgh-serie                 = wgh-buffer:BUFFER-FIELD("tta_cod_ser_docto") 
           wgh-cod-tit-ap            = wgh-buffer:BUFFER-FIELD("tta_cod_tit_ap") 
           wgh-parcela               = wgh-buffer:BUFFER-FIELD("tta_cod_parcela")
           wgh-cod-forma-pagto       = wgh-buffer:BUFFER-FIELD("tta_cod_forma_pagto")
           wgh-cod-refer-antecip-pef = wgh-buffer:BUFFER-FIELD("tta_cod_refer_antecip_pef").

    ASSIGN l-desconsidera = NO.

    FIND FIRST tit_ap NO-LOCK
        WHERE tit_ap.cod_estab       = wgh-estab:BUFFER-VALUE 
        AND   tit_ap.cod_espec_docto = wgh-especie:BUFFER-VALUE 
        AND   tit_ap.cod_ser_docto   = wgh-serie:BUFFER-VALUE 
        AND   tit_ap.cdn_fornecedor  = wgh-fornecedor:BUFFER-VALUE 
        AND   tit_ap.cod_tit_ap      = wgh-cod-tit-ap:BUFFER-VALUE 
        AND   tit_ap.cod_parcela     = wgh-parcela:BUFFER-VALUE NO-ERROR.

    IF  NOT AVAIL tit_ap THEN
        FIND FIRST antecip_pef_pend NO-LOCK
             WHERE antecip_pef_pend.cod_estab = wgh-estab:BUFFER-VALUE
             AND   antecip_pef_pend.cod_refer = wgh-cod-refer-antecip-pef:BUFFER-VALUE NO-ERROR.
        
    FIND FIRST emscad.fornecedor NO-LOCK
        WHERE emscad.fornecedor.cod_empresa    = v_cod_empres_usuar
        AND   emscad.fornecedor.cdn_fornecedor = wgh-fornecedor:BUFFER-VALUE NO-ERROR.
    
    IF  AVAIL emscad.fornecedor THEN DO:
        EMPTY TEMP-TABLE tt_pessoa_jurid_matriz NO-ERROR.

        /* --- Fornecedor Pessoa F¡sica ---*/
        IF  emscad.fornecedor.num_pessoa MOD 2 = 0 THEN DO:
            CREATE tt_pessoa_jurid_matriz.
            ASSIGN tt_pessoa_jurid_matriz.tta_num_pessoa_jurid = emscad.fornecedor.num_pessoa.
            CREATE tt_pessoa_jurid_matriz_aux.
            ASSIGN tt_pessoa_jurid_matriz_aux.tta_num_pessoa_jurid = emscad.fornecedor.num_pessoa.
        END. /* IF  emscad.fornecedor.num_pessoa */
        ELSE DO:
             /* --- Fornecedor Pessoa Jur¡dica ---*/
             RUN pi_retornar_pessoa_jurid_matriz (INPUT emscad.fornecedor.num_pessoa,
                                                  OUTPUT v_cod_return).
             IF  v_cod_return = "107" THEN DO:
                 CREATE tt_pessoa_jurid_matriz.
                 ASSIGN tt_pessoa_jurid_matriz.tta_num_pessoa_jurid = emscad.fornecedor.num_pessoa.
                 CREATE tt_pessoa_jurid_matriz_aux.
                 ASSIGN tt_pessoa_jurid_matriz_aux.tta_num_pessoa_jurid = emscad.fornecedor.num_pessoa.
             END. /* IF  v_cod_return = */
        END. /* ELSE DO: */
    END.

    if  (avail tit_ap 
    and (tit_ap.cb4_tit_ap_bco_cobdor = "" 
    OR   tit_ap.cb4_tit_ap_bco_cobdor = ?))
    OR  (AVAIL antecip_pef_pend
    AND (antecip_pef_pend.cb4_tit_ap_bco_cobdor = ""
    OR   antecip_pef_pend.cb4_tit_ap_bco_cobdor = ?)) THEN DO:
        /* validar se fornecedor possui chave pix cadastrada */
        FIND FIRST fornec_financ
            WHERE fornec_financ.cod_empresa    = v_cod_empres_usuar
            AND   fornec_financ.cdn_fornecedor = wgh-fornecedor:BUFFER-VALUE NO-LOCK NO-ERROR.
    
        IF  AVAIL fornec_financ THEN DO:
            FIND FIRST chave_pix_fornec
                WHERE chave_pix_fornec.cod_empresa    = fornec_financ.cod_empresa    
                AND   chave_pix_fornec.cdn_fornecedor = fornec_financ.cdn_fornecedor NO-LOCK NO-ERROR.
    
            IF  AVAIL chave_pix_fornec THEN DO:
                FOR EACH ttCol:
                    ASSIGN ttCol.ColHdl:BGCOLOR = 10 /* Verde limÆo */
                           ttCol.ColHdl:FGCOLOR = 0  /* Branco */. 

                    ASSIGN l-desconsidera = YES.
                END.
            END.
        END.
    END.

    IF  INDEX(p_wgh_frame:TITLE,"Inclui Item Border“ Pagamento") <> 0 THEN DO:

        FIND FIRST fornec_financ NO-LOCK
            WHERE fornec_financ.cod_empresa    = v_cod_empres_usuar
            AND   fornec_financ.cdn_fornecedor = wgh-fornecedor:BUFFER-VALUE NO-ERROR.
        
        IF  NOT l-desconsidera THEN DO:
            IF  NOT AVAIL fornec_financ THEN DO: 
                FOR EACH ttCol:
                    ASSIGN ttCol.ColHdl:BGCOLOR = 12 /* bgcolor - vermelho */
                           ttCol.ColHdl:FGCOLOR = 15. /* fgcolor - branco     */            
                END.                    
                ASSIGN l-desconsidera = YES. /* ** PEF ou banco diferente de Ita£ ***/
            END.
            ELSE DO:
                IF  fornec_financ.cod_forma_pagto = "60" THEN DO:
                    FOR EACH ttCol:
                        ASSIGN ttCol.ColHdl:BGCOLOR = 13 /* bgcolor - rosa */
                               ttCol.ColHdl:FGCOLOR = 0. /* fgcolor - preto */            
                    END.                    
                    ASSIGN l-desconsidera = YES. /*** Forma de pagamento 60 ***/
                END.
            END.
        END.

        IF  NOT l-desconsidera THEN DO:
            IF  AVAIL fornec_financ THEN DO:
                IF (fornec_financ.cod_forma_pagto = "15"
                OR  fornec_financ.cod_forma_pagto = "25") THEN DO:
                    FOR EACH ttCol:
                        ASSIGN ttCol.ColHdl:BGCOLOR = 14 /* bgcolor - amarelo */.
                    END.
                    ASSIGN l-desconsidera = YES.
                END.
            END. /* IF AVAIL fornec_financ */
        END.

        IF  NOT l-desconsidera THEN DO:
            IF AVAIL fornec_financ THEN DO:
                IF  fornec_financ.cod_banco <> "341" THEN DO:
                    FOR EACH ttCol:                 
                        ASSIGN ttCol.ColHdl:BGCOLOR = 2 /* bgcolor - verde */
                               ttCol.ColHdl:FGCOLOR = 15. /* fgcolor - branco    */
                    END.                    
                    ASSIGN l-desconsidera = YES. /* ** PEF ou banco diferente de Ita£ ***/
                END.
            END.
        END.
    END.
    ELSE DO:
        run pi_verifica_antecip_fornec (output v_log_return).

        if  v_log_return = yes then do:
            FOR EACH ttCol:
                ASSIGN ttCol.ColHdl:BGCOLOR = 11 /* bgcolor - azul claro */.
            END.                    
            ASSIGN l-desconsidera = YES. /* ** PEF ou banco diferente de Ita£ ***/
        end. 
    END.

    /* Repasse da logica existe no produto padrao para fazer as cores azul e vermelha no browse */
    IF  NOT l-desconsidera THEN DO:
        find first forma_pagto no-lock
            where forma_pagto.cod_forma_pagto = wgh-cod-forma-pagto:BUFFER-VALUE no-error.
    
        if avail forma_pagto then do:
            if  forma_pagto.ind_tip_forma_pagto = "Boleto" /*l_boleto*/   then do:

                if  (avail tit_ap 
                and (tit_ap.cb4_tit_ap_bco_cobdor           = "" 
                OR   tit_ap.cb4_tit_ap_bco_cobdor           = ?))
                OR  (AVAIL antecip_pef_pend
                AND (antecip_pef_pend.cb4_tit_ap_bco_cobdor = ""
                OR   antecip_pef_pend.cb4_tit_ap_bco_cobdor = ?)) THEN DO:
                    FOR EACH ttCol:
                        ASSIGN ttCol.ColHdl:BGCOLOR = 9  /* Azul */
                               ttCol.ColHdl:FGCOLOR = 15 /* Branco */. 
                    END.
		            assign l-desconsidera = yes.
                end.
            end.
            ELSE DO:
                IF  INDEX(p_wgh_frame:TITLE,"Libera‡Æo de Pagamento") <> 0 THEN DO:

                    FIND FIRST fornec_financ NO-LOCK
                        WHERE fornec_financ.cod_empresa    = v_cod_empres_usuar
                        AND   fornec_financ.cdn_fornecedor = wgh-fornecedor:BUFFER-VALUE NO-ERROR.

                    if  forma_pagto.ind_tip_forma_pagto = "DOC"
                    OR  forma_pagto.ind_tip_forma_pagto = "TED CIP"
                    OR  forma_pagto.ind_tip_forma_pagto = "TED STR"
                    OR  forma_pagto.ind_tip_forma_pagto = "Cr‚dito Conta Corrente" then do:

                        if (not avail fornec_financ) 
                        OR (fornec_financ.cod_banco          = '' or fornec_financ.cod_banco          = ?) 
                        OR (fornec_financ.cod_agenc_bcia     = '' or fornec_financ.cod_agenc_bcia     = ?) 
                        OR (fornec_financ.cod_cta_corren_bco = '' or fornec_financ.cod_cta_corren_bco = ?) then do:
                            FOR EACH ttCol:
                                ASSIGN ttCol.ColHdl:BGCOLOR = 12 /* Vermelho */
                                       ttCol.ColHdl:FGCOLOR = 15 /* Branco */. 
                            END.
                        end.  
                    END.

                    IF  NOT AVAIL fornec_financ THEN DO: 
                        FOR EACH ttCol:
                            ASSIGN ttCol.ColHdl:BGCOLOR = 12 /* bgcolor - vermelho */
                                   ttCol.ColHdl:FGCOLOR = 15. /* fgcolor - branco     */            
                        END.                    
                    END.
                    ELSE DO:
                        IF  fornec_financ.cod_forma_pagto = "60" THEN DO:
                            FOR EACH ttCol:
                                ASSIGN ttCol.ColHdl:BGCOLOR = 13 /* bgcolor - rosa */
                                       ttCol.ColHdl:FGCOLOR = 0. /* fgcolor - preto */            
                            END.                    
                        END.

                        IF (fornec_financ.cod_forma_pagto = "15"
                        OR  fornec_financ.cod_forma_pagto = "25") THEN DO:
                            FOR EACH ttCol:
                                ASSIGN ttCol.ColHdl:BGCOLOR = 14 /* bgcolor - amarelo */.
                            END.
                        END.
                    END.
                END.
            END.
        end.
    END.

    IF AVAIL tit_ap THEN DO:
        IF  tit_ap.log_concil             = YES 
        OR  tit_ap.cb4_tit_ap_bco_cobdor <> "" THEN DO:
            FOR FIRST ttCol:
                ASSIGN ttCol.ColHdl:BGCOLOR = 2 /* verde */
                       ttCol.ColHdl:FGCOLOR = 0. /* preto */
            END.
        END.
        ELSE DO:
            IF  tit_ap.log_livre_2 = YES THEN DO:
                FOR FIRST ttCol:
                    ASSIGN ttCol.ColHdl:BGCOLOR = 5 /* Roxo */
                           ttCol.ColHdl:FGCOLOR = 0. /* preto */
                END.
            END.
            ELSE DO:
                FOR FIRST ttCol:
                    ASSIGN ttCol.ColHdl:BGCOLOR = 7 /* Cinza */
                           ttCol.ColHdl:FGCOLOR = 0. /* preto */
                END.
            END.
        END.
    END.
    ELSE DO:
        if  AVAIL antecip_pef_pend
        AND antecip_pef_pend.cb4_tit_ap_bco_cobdor <> "" THEN DO:
            FOR FIRST ttCol:
                ASSIGN ttCol.ColHdl:BGCOLOR = 2 /* verde */
                       ttCol.ColHdl:FGCOLOR = 0. /* preto */
            END.
        END.
        ELSE DO:
            FOR FIRST ttCol:
                ASSIGN ttCol.ColHdl:BGCOLOR = 7 /* cinza */
                       ttCol.ColHdl:FGCOLOR = 0. /* Preto */
            END.
        END.
    END. 
    
END.

PROCEDURE pi_retornar_pessoa_jurid_matriz:

    def Input  param p_num_pessoa_jurid as integer   format ">>>,>>>,>>9" no-undo.
    def output param p_cod_return       as character format "x(40)"       no-undo.

    def var v_num_pessoa_jurid_matriz as integer format ">>>,>>>,>>9":U label "Matriz" column-label "Matriz" no-undo.

    FIND pessoa_jurid NO-LOCK 
         WHERE pessoa_jurid.num_pessoa_jurid = p_num_pessoa_jurid NO-ERROR.
    IF  AVAIL pessoa_jurid THEN DO:
        ASSIGN v_num_pessoa_jurid_matriz = pessoa_jurid.num_pessoa_jurid_matriz.

        FIND FIRST tt_pessoa_jurid_matriz NO-LOCK 
             WHERE tt_pessoa_jurid_matriz.tta_num_pessoa_jurid = pessoa_jurid.num_pessoa_jurid NO-ERROR.
        IF  NOT AVAIL tt_pessoa_jurid_matriz THEN DO:
            CREATE tt_pessoa_jurid_matriz.
            ASSIGN tt_pessoa_jurid_matriz.tta_num_pessoa_jurid = pessoa_jurid.num_pessoa_jurid.
            CREATE tt_pessoa_jurid_matriz_aux.
            ASSIGN tt_pessoa_jurid_matriz_aux.tta_num_pessoa_jurid = emscad.fornecedor.num_pessoa.
        END. /* IF  NOT AVAIL tt_pessoa_jurid_matriz THEN DO: */
        IF  pessoa_jurid.num_pessoa_jurid_matriz <> 0 THEN DO:
            FOR EACH pessoa_jurid NO-LOCK 
                WHERE pessoa_jurid.num_pessoa_jurid_matriz = v_num_pessoa_jurid_matriz
                USE-INDEX pssjrda_matriz:
                FIND FIRST tt_pessoa_jurid_matriz NO-LOCK 
                     WHERE tt_pessoa_jurid_matriz.tta_num_pessoa_jurid = pessoa_jurid.num_pessoa_jurid NO-ERROR.
                IF  NOT AVAIL tt_pessoa_jurid_matriz THEN DO:
                    CREATE tt_pessoa_jurid_matriz.
                    ASSIGN tt_pessoa_jurid_matriz.tta_num_pessoa_jurid = pessoa_jurid.num_pessoa_jurid.
                    CREATE tt_pessoa_jurid_matriz_aux.
                    ASSIGN tt_pessoa_jurid_matriz_aux.tta_num_pessoa_jurid = emscad.fornecedor.num_pessoa.
                END. /* IF  NOT AVAIL tt_pessoa_jurid_matriz THEN DO: */
            END. /* FOR EACH pessoa_jurid NO-LOCK */
        END. /* IF  pessoa_jurid.num_pessoa_jurid_matriz <> 0 THEN DO: */
    END. /* IF  AVAIL pessoa_jurid THEN DO: */
    ELSE DO:
         ASSIGN p_cod_return = "107".
    END. /* ELSE DO: */

END PROCEDURE.

PROCEDURE pi_verifica_antecip_fornec:

    /************************ Parameter Definition Begin ************************/

    def output param p_log_return
        as logical
        format "Sim/NÆo"
        no-undo.
    
    /************************* Parameter Definition End *************************/

    /************************** Buffer Definition Begin *************************/

    def buffer b_tit_ap
        for tit_ap.

    /*************************** Buffer Definition End **************************/

    /************************* Variable Definition Begin ************************/

    def var v_val_sdo_tit_ap
        as decimal
        format "->>>,>>>,>>9.99":U
        decimals 2
        label "Valor Saldo"
        column-label "Valor Saldo"
        no-undo.


    /************************** Variable Definition End *************************/

    assign p_log_return = no.


    estabelecimentos:
    for each estabelecimento no-lock
        where estabelecimento.cod_empresa = v_cod_empres_usuar,
        each tt_pessoa_jurid_matriz no-lock:

        if not can-find (first b_tit_ap no-lock
                where b_tit_ap.cod_estab           = estabelecimento.cod_estab
                and   b_tit_ap.ind_tip_espec_docto = "Antecipa‡Æo"
                and   b_tit_ap.num_pessoa          = tt_pessoa_jurid_matriz.tta_num_pessoa_jurid
                and   b_tit_ap.log_tit_ap_estordo  = NO
                and   b_tit_ap.log_sdo_tit_ap      = YES) THEN
                NEXT estabelecimentos.

        gera_abat:
        for each b_tit_ap no-lock
            where b_tit_ap.cod_estab           = estabelecimento.cod_estab
            and   b_tit_ap.ind_tip_espec_docto = "Antecipa‡Æo"
            and   b_tit_ap.num_pessoa          = tt_pessoa_jurid_matriz.tta_num_pessoa_jurid
            and   b_tit_ap.log_tit_ap_estordo  = NO 
            and   b_tit_ap.log_sdo_tit_ap      = YES
            use-index titap_tip_espec_pessoa_trans:

            assign v_val_sdo_tit_ap = b_tit_ap.val_sdo_tit_ap.

            for each abat_antecip_vouch no-lock
               where abat_antecip_vouch.cdn_fornecedor  = b_tit_ap.cdn_fornecedor
                 and abat_antecip_vouch.cod_espec_docto = b_tit_ap.cod_espec_docto
                 and abat_antecip_vouch.cod_estab       = b_tit_ap.cod_estab
                 and abat_antecip_vouch.cod_parcela     = b_tit_ap.cod_parcela
                 and abat_antecip_vouch.cod_ser_docto   = b_tit_ap.cod_ser_docto
                 and abat_antecip_vouch.cod_tit_ap      = b_tit_ap.cod_tit_ap
                 and abat_antecip_vouch.log_abat_atlzdo = no:
                 assign v_val_sdo_tit_ap = v_val_sdo_tit_ap - abat_antecip_vouch.val_abtdo_antecip_orig.
             end.
    
             if v_val_sdo_tit_ap <= 0 then
                 next gera_abat.
       
             assign p_log_return = yes.

        end.
    end.

END PROCEDURE.

PROCEDURE pi_historico:

END.
