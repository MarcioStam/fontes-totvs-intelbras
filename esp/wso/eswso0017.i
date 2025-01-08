/* integracao titulos DEPS */

DEFINE VARIABLE jsonObjectOutput    AS JsonObject NO-UNDO.
DEFINE VARIABLE jsonObjectPayload   AS jsonObject NO-UNDO.
DEFINE VARIABLE objTitulo           AS JsonObject NO-UNDO.
DEFINE VARIABLE objCategoria        AS JsonObject NO-UNDO.
DEFINE VARIABLE objGerais           AS JsonObject NO-UNDO.
DEFINE VARIABLE objBaixas           AS JsonObject NO-UNDO.
DEFINE VARIABLE arrayTitulos        AS jsonArray  NO-UNDO.
DEFINE VARIABLE arrayCategoria      AS jsonArray  NO-UNDO.
DEFINE VARIABLE arrayGerais         AS jsonArray  NO-UNDO.
DEFINE VARIABLE arrayBaixas         AS jsonArray  NO-UNDO.
DEFINE VARIABLE jsonArrayPayload    AS jsonArray  NO-UNDO.

DEFINE VARIABLE c-jason             AS LONGCHAR   NO-UNDO.

DEF VAR i_cont AS INT                NO-UNDO.
DEF VAR c-msg  AS CHAR FORMAT "x(7)" NO-UNDO.

DEF TEMP-TABLE tt_categoria NO-UNDO
    FIELD codigoCategoria AS CHAR FORMAT "x(50)".

DEF TEMP-TABLE tt_tit_acr NO-UNDO
    FIELD cod_estab      LIKE tit_acr_deps.cod_estab
    FIELD num_id_tit_acr LIKE tit_acr_deps.num_id_tit_acr.

DEF VAR v_docto_cliente    LIKE pessoa_fisic.cod_id_feder  NO-UNDO.
DEF VAR v_tipo_pessoa      AS CHAR FORMAT "x(20)"          NO-UNDO.
DEF VAR v_val_saldo        LIKE tit_acr.val_sdo_tit_acr    NO-UNDO.
DEF VAR v_val_orig         LIKE tit_acr.val_origin_tit_acr NO-UNDO.
DEF VAR v_val_baixa        LIKE tit_acr.val_origin_tit_acr NO-UNDO.
DEF VAR v_transacao        AS CHAR FORMAT "x(30)"          NO-UNDO.
DEF VAR v_dat_emis         AS DATETIME FORMAT "99/99/9999 HH:MM:SS":U NO-UNDO.
DEF VAR v_dat_venc_prorrog AS DATETIME FORMAT "99/99/9999 HH:MM:SS":U NO-UNDO.
DEF VAR v_dat_venc_orig    AS DATETIME FORMAT "99/99/9999 HH:MM:SS":U NO-UNDO.
DEF VAR v_dat_trans        AS DATETIME FORMAT "99/99/9999 HH:MM:SS":U NO-UNDO.
DEF VAR v_dat_trans_baixa  AS DATETIME FORMAT "99/99/9999 HH:MM:SS":U NO-UNDO.
DEF VAR v_dat_baixa        LIKE movto_tit_acr.dat_transacao           NO-UNDO.
DEF VAR v_cont             AS INT                                     NO-UNDO.
DEF VAR v_parcela          LIKE tit_acr.cod_parcela                   NO-UNDO.

DEF BUFFER b_movto_tit_acr     FOR movto_tit_acr.
DEF BUFFER b_val_movto_tit_acr FOR val_movto_tit_acr.

/****************************************************************************************************/

PROCEDURE pi-gera-json.
    
    arrayTitulos = NEW JsonArray().

    ASSIGN v_cont = 0.

    FOR EACH tt_tit_acr_deps EXCLUSIVE-LOCK:

        ASSIGN v_cont = v_cont + 1.

        FIND FIRST tit_acr NO-LOCK
            WHERE tit_acr.cod_estab      = tt_tit_acr_deps.cod_estab
            AND   tit_acr.num_id_tit_acr = tt_tit_acr_deps.num_id_tit_acr NO-ERROR.

        /* titulo existe, envio de atualizacao do titulo */
        IF  AVAIL tit_acr
        AND tit_acr.ind_tip_espec_docto = "Normal" THEN DO:
            ASSIGN v_val_saldo = 0
                   v_val_orig  = 0
                   v_val_baixa = 0.
    
            /* categorias enviadas junto aos titulos */
            EMPTY TEMP-TABLE tt_categoria.
    
            CREATE tt_categoria.
            ASSIGN tt_categoria.codigoCategoria = tit_acr.cod_estab.
    
            CREATE tt_categoria.
            ASSIGN tt_categoria.codigoCategoria = tit_acr.cod_espec_docto.
    
            CREATE tt_categoria.
            ASSIGN tt_categoria.codigoCategoria = tit_acr.cod_ser_docto.
    
            CREATE tt_categoria.
            ASSIGN tt_categoria.codigoCategoria = tit_acr.cod_portador.
    
            CREATE tt_categoria.
            ASSIGN tt_categoria.codigoCategoria = tit_acr.cod_cart_bcia.
            /* categorias enviadas junto aos titulos */
    
            FIND FIRST emscad.cliente
                WHERE emscad.cliente.cdn_cliente = tit_acr.cdn_cliente NO-LOCK NO-ERROR.
    
            IF  AVAIL emscad.cliente THEN DO:
                IF  (emscad.cliente.num_pessoa MOD 2) = 0 THEN DO:
                    FIND FIRST pessoa_fisic
                        WHERE pessoa_fisic.num_pessoa_fisic = emscad.cliente.num_pessoa NO-LOCK NO-ERROR.
    
                    IF  AVAIL pessoa_fisic THEN
                        ASSIGN v_docto_cliente = trim(pessoa_fisic.cod_id_feder)
                               v_tipo_pessoa   = "Pessoa Fisica".
                END.
                ELSE DO:
                    FIND FIRST pessoa_jurid
                        WHERE pessoa_jurid.num_pessoa_jurid = emscad.cliente.num_pessoa NO-LOCK NO-ERROR.
    
                    IF  AVAIL pessoa_jurid THEN
                        ASSIGN v_docto_cliente = trim(pessoa_jurid.cod_id_feder)
                               v_tipo_pessoa   = "Pessoa Juridica".
                END.
            END.
    
            IF  PROGRAM-NAME(1) MATCHES "*acr715zb.py" 
            OR  PROGRAM-NAME(2) MATCHES "*acr715zb.py" 
            OR  PROGRAM-NAME(3) MATCHES "*acr715zb.py" 
            OR  PROGRAM-NAME(4) MATCHES "*acr715zb.py" 
            OR  PROGRAM-NAME(5) MATCHES "*acr715zb.py" 
            OR  PROGRAM-NAME(6) MATCHES "*acr715zb.py" 
            OR  tit_acr.log_tit_acr_estordo = YES THEN
                ASSIGN v_val_saldo = 0.
            ELSE DO:
                FOR EACH val_tit_acr
                    WHERE val_tit_acr.cod_estab        = tit_acr.cod_estab      
                    AND   val_tit_acr.num_id_tit_acr   = tit_acr.num_id_tit_acr 
                    AND   val_tit_acr.cod_finalid_econ = "Corrente" NO-LOCK:
    
                    ASSIGN v_val_saldo = v_val_saldo + val_tit_acr.val_sdo_tit_acr
                           v_val_orig  = v_val_orig  + val_tit_acr.val_origin_tit_acr.
                END.
            END.
    
            ASSIGN v_parcela = IF tit_acr.cod_parcela = "" THEN "in" ELSE tit_acr.cod_parcela.

            objTitulo = NEW JsonObject().
    
            objTitulo:ADD("codigoTitulo",             STRING(tit_acr.num_id_tit_acr)).
            objTitulo:ADD("natureza",                 STRING(v_tipo_pessoa)).
            objTitulo:ADD("numeroDocumento",          v_docto_cliente).
            objTitulo:ADD("numeroTitulo",             tit_acr.cod_tit_acr).
            objTitulo:ADD("dataEmissao",              string(YEAR(tit_acr.dat_emis_docto),"9999")            + "-" + STRING(MONTH(tit_acr.dat_emis_docto),"99")            + "-" + STRING(DAY(tit_acr.dat_emis_docto),"99")            + 'T' + STRING(TIME,"HH:MM:SS":U)).
            objTitulo:ADD("dataVencimentoProrrogado", string(YEAR(tit_acr.dat_vencto_tit_acr),"9999")        + "-" + STRING(MONTH(tit_acr.dat_vencto_tit_acr),"99")        + "-" + STRING(DAY(tit_acr.dat_vencto_tit_acr),"99")        + 'T' + STRING(TIME,"HH:MM:SS":U)).
            objTitulo:ADD("dataVencimentoOriginal",   string(YEAR(tit_acr.dat_vencto_origin_tit_acr),"9999") + "-" + STRING(MONTH(tit_acr.dat_vencto_origin_tit_acr),"99") + "-" + STRING(DAY(tit_acr.dat_vencto_origin_tit_acr),"99") + 'T' + STRING(TIME,"HH:MM:SS":U)).
            objTitulo:ADD("numeroParcela",            v_parcela).
            objTitulo:ADD("valor",                    DEC(v_val_orig)).
    
            arrayCategoria = NEW JsonArray().
    
            FOR EACH tt_categoria NO-LOCK:
                objCategoria = NEW JsonObject().
    
                objCategoria:ADD("codigo", STRING(tt_categoria.codigoCategoria)).
    
                arrayCategoria:ADD(objCategoria).
            END.
    
            objTitulo:ADD("Categorias", (arrayCategoria)).
    
            FIND FIRST movto_tit_acr OF tit_acr NO-LOCK NO-ERROR.
    
            IF  AVAIL movto_tit_acr
            AND (movto_tit_acr.log_ctbz_aprop_ctbl = YES 
            OR   tit_acr.log_tit_acr_estordo) THEN DO:
                arrayGerais = NEW JsonArray().
        
                objGerais = NEW JsonObject().
        
                objGerais:ADD("codigo", "SALDO").
                objGerais:ADD("nome",   string(tit_acr.num_id_tit_acr)).
                objGerais:ADD("data",   string(YEAR(tit_acr.dat_transacao),"9999") + "-" + STRING(MONTH(tit_acr.dat_transacao),"99") + "-" + STRING(DAY(tit_acr.dat_transacao),"99") + 'T' + STRING(TIME,"HH:MM:SS":U)).
                objGerais:ADD("valor",  dec(v_val_saldo)).
                 
                arrayGerais:ADD(objGerais).
        
                objTitulo:ADD("MovimentosGerais", (arrayGerais)).
            END.
    
            arrayBaixas = NEW JsonArray().
    
            FOR EACH movto_tit_acr OF tit_acr NO-LOCK:
    
                ASSIGN v_val_baixa = 0
                       v_transacao = movto_tit_acr.ind_trans_acr.
    
                IF  movto_tit_acr.ind_trans_acr = "Acerto Valor a Cr‚dito"
                OR  movto_tit_acr.ind_trans_acr = "Acerto Valor a Menor"
                OR  movto_tit_acr.ind_trans_acr = "Estorno de T¡tulo"
                OR  movto_tit_acr.ind_trans_acr = "Estorno Renegocia‡Æo"
                OR  movto_tit_acr.ind_trans_acr = "Liquida‡Æo"
                OR  movto_tit_acr.ind_trans_acr = "Liquida‡Æo Subst"
                OR  movto_tit_acr.ind_trans_acr = "Liquida‡Æo Transf Estab"
                OR  movto_tit_acr.ind_trans_acr = "Liquida‡Æo Renegociac"
                OR  movto_tit_acr.ind_trans_acr = "Liquida‡Æo Enctro Ctas" 
                OR  movto_tit_acr.ind_trans_acr = "Corre‡Æo de Valor"
                OR  movto_tit_acr.ind_trans_acr = "Corre‡Æo Valor na Liquidac"
                OR  movto_tit_acr.ind_trans_acr = "Estorno Corre‡Æo Val Liquidac"
                OR  movto_tit_acr.ind_trans_acr = "Estorno Corre‡Æo Valor"
                OR  movto_tit_acr.ind_trans_acr = "Acerto Valor a Maior"
                OR  movto_tit_acr.ind_trans_acr = "Estorno Liquidacao Subst"
                OR  movto_tit_acr.ind_trans_acr = "Estorno Liquid Transf Estab"
                OR  movto_tit_acr.ind_trans_acr = "Estorno de T¡tulo"
                OR  movto_tit_acr.ind_trans_acr = "Estorno de Liquidacao"
                OR  movto_tit_acr.ind_trans_acr = "Estorno Subst Nota Dupl"
                OR  movto_tit_acr.ind_trans_acr = "Estorno Transf Estab"
                OR  movto_tit_acr.ind_trans_acr = "Estorno Renegocia‡Æo"
                OR  movto_tit_acr.ind_trans_acr = "Estorno Liquid Renegociac"
                OR  movto_tit_acr.ind_trans_acr = "Estorno Acerto Val Maior"
                OR  movto_tit_acr.ind_trans_acr = "Estorno Acerto Val Menor"
                OR  movto_tit_acr.ind_trans_acr = "Transf Estabelecimento" THEN DO:
    
                    IF  movto_tit_acr.dat_liquidac_tit_acr <> ? THEN
                        ASSIGN v_dat_baixa = movto_tit_acr.dat_liquidac_tit_acr .
                    ELSE
                        ASSIGN v_dat_baixa = movto_tit_acr.dat_transacao .
    
                    IF  tit_acr.cod_indic_econ <> "Real" THEN DO:
    
                        IF  NOT movto_tit_acr.ind_trans_acr BEGINS "Estorno" THEN DO:
    
                            FOR EACH val_movto_tit_acr
                                WHERE val_movto_tit_acr.cod_estab            = movto_tit_acr.cod_estab
                                AND   val_movto_tit_acr.num_id_movto_tit_acr = movto_tit_acr.num_id_movto_tit_acr
                                AND   val_movto_tit_acr.cod_finalid_econ     = "Corrente" NO-LOCK:
    
                                ASSIGN v_val_baixa = v_val_baixa 
                                                     + val_movto_tit_acr.val_ajust_val_tit_acr 
                                                     + val_movto_tit_acr.val_liquidac_tit_acr 
                                                     + val_movto_tit_acr.val_saida_subst_nf_dupl
                                                     + val_movto_tit_acr.val_transf_estab
                                                     + val_movto_tit_acr.val_variac_cambial.
    
                                IF  movto_tit_acr.ind_trans_acr BEGINS "Corre‡Æo"
                                AND v_val_baixa < 0 THEN
                                    ASSIGN v_transacao = v_transacao + " … Menor".
    
                            END.    
                        END.
                        ELSE DO:
                            FIND FIRST b_movto_tit_acr
                                WHERE b_movto_tit_acr.cod_estab            = movto_tit_acr.cod_estab_tit_acr_pai
                                AND   b_movto_tit_acr.num_id_movto_tit_acr = movto_tit_acr.num_id_movto_tit_acr_pai NO-LOCK NO-ERROR.
    
                            IF  AVAIL b_movto_tit_acr THEN DO:
                                FOR EACH b_val_movto_tit_acr
                                    WHERE b_val_movto_tit_acr.cod_estab            = b_movto_tit_acr.cod_estab
                                    AND   b_val_movto_tit_acr.num_id_movto_tit_acr = b_movto_tit_acr.num_id_movto_tit_acr
                                    AND   b_val_movto_tit_acr.cod_finalid_econ     = "Corrente" NO-LOCK:
    
                                    ASSIGN v_val_baixa = v_val_baixa 
                                                         + b_val_movto_tit_acr.val_ajust_val_tit_acr 
                                                         + b_val_movto_tit_acr.val_liquidac_tit_acr 
                                                         + b_val_movto_tit_acr.val_saida_subst_nf_dupl
                                                         + b_val_movto_tit_acr.val_transf_estab
                                                         + b_val_movto_tit_acr.val_variac_cambial.
    
                                    IF  b_movto_tit_acr.ind_trans_acr BEGINS "Corre‡Æo"
                                    AND v_val_baixa < 0 THEN
                                        ASSIGN v_transacao = v_transacao + " … Menor".
    
                                END.    
                            END.
                        END.
                    END.
                    ELSE DO:
                        ASSIGN v_val_baixa = movto_tit_acr.val_movto_tit_acr.
                    END.
    
                    CASE movto_tit_acr.ind_trans_acr:
                        WHEN "Liquida‡Æo" THEN
                            ASSIGN v_transacao = "Liquidacao".
                        WHEN "Acerto Valor a Cr‚dito" THEN
                            ASSIGN v_transacao = "Acerto Valor a Credito".
                        WHEN "Estorno de T¡tulo" THEN
                            ASSIGN v_transacao = "Estorno de Titulo".
                        WHEN "Estorno Renegocia‡Æo" THEN
                            ASSIGN v_transacao = "Estorno Renegociacao".
                        WHEN "Liquida‡Æo Subst" THEN
                            ASSIGN v_transacao = "Liquidacao Subst".
                        WHEN "Liquida‡Æo Transf Estab" THEN
                            ASSIGN v_transacao = "Liquidacao Transf Estab".
                        WHEN "Liquida‡Æo Renegociac" THEN
                            ASSIGN v_transacao = "Liquidacao Renegociac".
                        WHEN "Liquida‡Æo Enctro Ctas" THEN
                            ASSIGN v_transacao = "Liquidacao Enctro Ctas".
                        WHEN "Corre‡Æo de Valor" THEN
                            ASSIGN v_transacao = "Correcao de Valor".
                        WHEN "Corre‡Æo Valor na Liquidac" THEN
                            ASSIGN v_transacao = "Correcao Valor na Liquidac".
                        WHEN "Estorno Corre‡Æo Val Liquidac" THEN
                            ASSIGN v_transacao = "Estorno Correcao Val Liquidac".
                        WHEN "Estorno Corre‡Æo Valor" THEN
                            ASSIGN v_transacao = "Estorno Correcao Valor".
                    END CASE.
    
                    IF  v_val_baixa < 0 THEN
                        ASSIGN v_val_baixa = v_val_baixa * (-1).
    
                    objBaixas = NEW JsonObject().
            
                    objBaixas:ADD("codigo", v_transacao).
                    objBaixas:ADD("nome",   string(movto_tit_acr.num_id_movto_tit_acr)).
                    objBaixas:ADD("data",   STRING(YEAR(v_dat_baixa),"9999") + "-" + STRING(MONTH(v_dat_baixa),"99") + "-" + STRING(DAY(v_dat_baixa),"99") + "T" + STRING(TIME,"HH:MM:SS":U)).
                    objBaixas:ADD("valor",  DEC(v_val_baixa)).
    
                    arrayBaixas:ADD(objBaixas).
                END.
            END.
    
            objTitulo:ADD("MovimentosBaixas", (arrayBaixas)).
    
            arrayTitulos:ADD(objTitulo).

        END.

        /* titulo nao existe, envio do cancelamento */
        IF  NOT AVAIL tit_acr THEN DO:
            
            FIND FIRST tit_acr_deps NO-LOCK
                WHERE tit_acr_deps.cod_estab      = tt_tit_acr_deps.cod_estab      
                AND   tit_acr_deps.num_id_tit_acr = tt_tit_acr_deps.num_id_tit_acr NO-ERROR.

            IF  AVAIL tit_acr_deps
            AND tit_acr_deps.dados_cancel <> ""
            AND NUM-ENTRIES(tit_acr_deps.dados_cancel,";") = 14 THEN DO:

                ASSIGN v_val_saldo = 0
                       v_val_orig  = 0
                       v_val_baixa = 0.

                /* categorias enviadas junto aos titulos */
                EMPTY TEMP-TABLE tt_categoria.

                CREATE tt_categoria.
                ASSIGN tt_categoria.codigoCategoria = ENTRY(9,tit_acr_deps.dados_cancel,";").

                CREATE tt_categoria.
                ASSIGN tt_categoria.codigoCategoria = ENTRY(10,tit_acr_deps.dados_cancel,";").

                CREATE tt_categoria.
                ASSIGN tt_categoria.codigoCategoria = ENTRY(11,tit_acr_deps.dados_cancel,";").

                CREATE tt_categoria.
                ASSIGN tt_categoria.codigoCategoria = ENTRY(12,tit_acr_deps.dados_cancel,";").

                CREATE tt_categoria.
                ASSIGN tt_categoria.codigoCategoria = ENTRY(13,tit_acr_deps.dados_cancel,";").
                /* categorias enviadas junto aos titulos */

                FIND FIRST emscad.cliente
                    WHERE emscad.cliente.cdn_cliente = int(entry(1,tit_acr_deps.dados_cancel,";")) NO-LOCK NO-ERROR.

                IF  AVAIL emscad.cliente THEN DO:
                    IF  (emscad.cliente.num_pessoa MOD 2) = 0 THEN DO:
                        FIND FIRST pessoa_fisic
                            WHERE pessoa_fisic.num_pessoa_fisic = emscad.cliente.num_pessoa NO-LOCK NO-ERROR.

                        IF  AVAIL pessoa_fisic THEN
                            ASSIGN v_docto_cliente = trim(pessoa_fisic.cod_id_feder)
                                   v_tipo_pessoa   = "Pessoa Fisica".
                    END.
                    ELSE DO:
                        FIND FIRST pessoa_jurid
                            WHERE pessoa_jurid.num_pessoa_jurid = emscad.cliente.num_pessoa NO-LOCK NO-ERROR.

                        IF  AVAIL pessoa_jurid THEN
                            ASSIGN v_docto_cliente = trim(pessoa_jurid.cod_id_feder)
                                   v_tipo_pessoa   = "Pessoa Juridica".
                    END.
                END.

                ASSIGN v_val_saldo = 0
                       v_val_orig  = dec(entry(7,tit_acr_deps.dados_cancel,";"))
                       v_parcela   = IF entry(6,tit_acr_deps.dados_cancel,";") = "" THEN "in" ELSE entry(6,tit_acr_deps.dados_cancel,";").

                objTitulo = NEW JsonObject().

                objTitulo:ADD("codigoTitulo",             STRING(tit_acr_deps.num_id_tit_acr)).
                objTitulo:ADD("natureza",                 STRING(v_tipo_pessoa)).
                objTitulo:ADD("numeroDocumento",          v_docto_cliente).
                objTitulo:ADD("numeroTitulo",             entry(2,tit_acr_deps.dados_cancel,";")).
                objTitulo:ADD("dataEmissao",              STRING(YEAR(date(entry(3,tit_acr_deps.dados_cancel,";"))),"9999") + "-" + 
                                                          STRING(MONTH(date(entry(3,tit_acr_deps.dados_cancel,";"))),"99")  + "-" + 
                                                          STRING(DAY(date(entry(3,tit_acr_deps.dados_cancel,";"))),"99") + 'T' + 
                                                          STRING(TIME,"HH:MM:SS":U)).
                objTitulo:ADD("dataVencimentoProrrogado", STRING(YEAR(date(entry(4,tit_acr_deps.dados_cancel,";"))),"9999") + "-" + 
                                                          STRING(MONTH(date(entry(4,tit_acr_deps.dados_cancel,";"))),"99")  + "-" + 
                                                          STRING(DAY(date(entry(4,tit_acr_deps.dados_cancel,";"))),"99") + 'T' + 
                                                          STRING(TIME,"HH:MM:SS":U)).
                objTitulo:ADD("dataVencimentoOriginal",   STRING(YEAR(date(entry(5,tit_acr_deps.dados_cancel,";"))),"9999") + "-" + 
                                                          STRING(MONTH(date(entry(5,tit_acr_deps.dados_cancel,";"))),"99")  + "-" + 
                                                          STRING(DAY(date(entry(5,tit_acr_deps.dados_cancel,";"))),"99") + 'T' + 
                                                          STRING(TIME,"HH:MM:SS":U)).
                objTitulo:ADD("numeroParcela",            v_parcela).
                objTitulo:ADD("valor",                    DEC(v_val_orig)).

                arrayCategoria = NEW JsonArray().

                FOR EACH tt_categoria NO-LOCK:
                    objCategoria = NEW JsonObject().

                    objCategoria:ADD("codigo", STRING(tt_categoria.codigoCategoria)).

                    arrayCategoria:ADD(objCategoria).
                END.

                objTitulo:ADD("Categorias", (arrayCategoria)).

                arrayGerais = NEW JsonArray().

                objGerais = NEW JsonObject().

                objGerais:ADD("codigo", "SALDO").
                objGerais:ADD("nome",   string(tit_acr_deps.num_id_tit_acr)).
                objGerais:ADD("data",   STRING(YEAR(date(entry(14,tit_acr_deps.dados_cancel,";"))),"9999") + "-" + 
                                        STRING(MONTH(date(entry(14,tit_acr_deps.dados_cancel,";"))),"99")  + "-" + 
                                        STRING(DAY(date(entry(14,tit_acr_deps.dados_cancel,";"))),"99") + 'T' + 
                                        STRING(TIME,"HH:MM:SS":U)).
                objGerais:ADD("valor",  dec(v_val_saldo)).

                arrayGerais:ADD(objGerais).

                objTitulo:ADD("MovimentosGerais", (arrayGerais)).

                arrayBaixas = NEW JsonArray().

                objTitulo:ADD("MovimentosBaixas", (arrayBaixas)).

                arrayTitulos:ADD(objTitulo).

            END.
        END.
    END.

    JsonObjectOutput = NEW JsonObject().
    jsonObjectOutput:ADD("Titulos", arrayTitulos).

    ASSIGN c-jason = jsonObjectOutput:getjsontext().

END PROCEDURE. 
