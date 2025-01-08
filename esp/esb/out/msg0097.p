CREATE WIDGET-POOL.

DEF TEMP-TABLE tt_tit_acr NO-UNDO
    FIELD cod_estab      LIKE tit_acr_deps.cod_estab
    FIELD num_id_tit_acr LIKE tit_acr_deps.num_id_tit_acr.


DEF VAR v_docto_cliente    LIKE pessoa_fisic.cod_id_feder  NO-UNDO.
DEF VAR v_tipo_pessoa      AS CHAR FORMAT "x(1)"           NO-UNDO.
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

DEF BUFFER b_movto_tit_acr     FOR movto_tit_acr.
DEF BUFFER b_val_movto_tit_acr FOR val_movto_tit_acr.

{esp/esb/out/msg0097.i}
{utp/ut-glob.i}
{include/i-freeac.i}

DEFINE INPUT  PARAM raw-param AS RAW NO-UNDO.
DEFINE OUTPUT PARAM TABLE FOR resultado.

DEF VAR iXml AS LONGCHAR NO-UNDO.
DEF VAR oXML AS LONGCHAR NO-UNDO.

RAW-TRANSFER raw-param TO tt_tit_acr.

DEFINE DATASET mensagem XML-NODE-NAME 'MENSAGEM' for cabecalho, conteudo, msg0097, ListaCategoria, MovimentosGerais, MovimentosBaixas, CadastrosComplementares, CategoriaItem
   DATA-RELATION FOR conteudo, msg0097                      RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0097, ListaCategoria                RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0097, MovimentosGerais              RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0097, MovimentosBaixas              RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0097, CadastrosComplementares       RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR CadastrosComplementares, CategoriaItem RELATION-FIELDS (idm, idm) NESTED.

DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, msg0097r, resultado
   DATA-RELATION FOR conteudor, msg0097r RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0097r, resultado RELATION-FIELDS (idm, idm) NESTED.


FOR FIRST tt_tit_acr NO-LOCK:

    FIND FIRST tit_acr
        WHERE tit_acr.cod_estab      = tt_tit_acr.cod_estab
        AND   tit_acr.num_id_tit_acr = tt_tit_acr.num_id_tit_acr NO-LOCK NO-ERROR.

    ASSIGN v_val_saldo = 0
           v_val_orig  = 0
           v_val_baixa = 0.

    CREATE cabecalho.
    ASSIGN cabecalho.IdentidadeEmissor = '64546C2E-6DAB-4311-A74A-5ACA96134AFF'
           cabecalho.CodigoMensagem    = 'MSG0097'
           cabecalho.LoginUsuario      = c-seg-usuario.

    CREATE conteudo.
    CREATE resultado.

    ASSIGN cabecalho.NumeroOperacao = tit_acr.cod_estab       + "/" +
                                      tit_acr.cod_espec_docto + "/" +
                                      tit_acr.cod_ser_docto   + "/" +
                                      tit_acr.cod_tit_acr     + "/" +
                                      tit_acr.cod_parcela.
    
    FIND FIRST emscad.cliente
        WHERE emscad.cliente.cdn_cliente = tit_acr.cdn_cliente NO-LOCK NO-ERROR.
    
    IF  AVAIL emscad.cliente THEN DO:
        IF  (emscad.cliente.num_pessoa MOD 2) = 0 THEN DO:
            FIND FIRST pessoa_fisic
                WHERE pessoa_fisic.num_pessoa_fisic = emscad.cliente.num_pessoa NO-LOCK NO-ERROR.
    
            IF  AVAIL pessoa_fisic THEN
                ASSIGN v_docto_cliente = trim(pessoa_fisic.cod_id_feder)
                       v_tipo_pessoa   = "F".
        END.
        ELSE DO:
            FIND FIRST pessoa_jurid
                WHERE pessoa_jurid.num_pessoa_jurid = emscad.cliente.num_pessoa NO-LOCK NO-ERROR.
            
            IF  AVAIL pessoa_jurid THEN
                ASSIGN v_docto_cliente = trim(pessoa_jurid.cod_id_feder)
                       v_tipo_pessoa   = "J".
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

    CREATE msg0097.                          
    ASSIGN msg0097.CodigoTitulo             = tit_acr.num_id_tit_acr
           msg0097.TipoCliente              = v_tipo_pessoa
           msg0097.CpfCnpjCodEstrangeiro    = v_docto_cliente
           msg0097.NumeroTitulo             = tit_acr.cod_tit_acr
           msg0097.DataEmissao              = string(YEAR(tit_acr.dat_emis_docto),"9999")            + "-" + STRING(MONTH(tit_acr.dat_emis_docto),"99")            + "-" + STRING(DAY(tit_acr.dat_emis_docto),"99")            + 'T' + STRING(TIME,"HH:MM:SS":U)
           msg0097.DataVencimentoProrrogado = string(YEAR(tit_acr.dat_vencto_tit_acr),"9999")        + "-" + STRING(MONTH(tit_acr.dat_vencto_tit_acr),"99")        + "-" + STRING(DAY(tit_acr.dat_vencto_tit_acr),"99")        + 'T' + STRING(TIME,"HH:MM:SS":U)
           msg0097.DataVencimentoOriginal   = string(YEAR(tit_acr.dat_vencto_origin_tit_acr),"9999") + "-" + STRING(MONTH(tit_acr.dat_vencto_origin_tit_acr),"99") + "-" + STRING(DAY(tit_acr.dat_vencto_origin_tit_acr),"99") + 'T' + STRING(TIME,"HH:MM:SS":U)
           msg0097.NumeroParcela            = tit_acr.cod_parcela
           msg0097.ValorOriginal            = v_val_orig
           msg0097.NumeroBoleto             = tit_acr.cod_tit_acr_bco
           msg0097.NumeroNotaFiscal         = "".
    
    CREATE CadastrosComplementares.

    CREATE CategoriaItem.
    ASSIGN CategoriaItem.NomeCategoria       = "Estabelecimento"
           CategoriaItem.CodigoCategoriaDEPS = tit_acr.cod_estab
           CategoriaItem.NomeParametrizacao  = tit_acr.cod_estab
           CategoriaItem.TipoRelacionamento  = 1
           CategoriaItem.ContaInadimplencia  = 1
           CategoriaItem.ContaPagamento      = 1.

    CREATE CategoriaItem.
    ASSIGN CategoriaItem.NomeCategoria       = "Esp‚cie"
           CategoriaItem.CodigoCategoriaDEPS = tit_acr.cod_espec_docto
           CategoriaItem.NomeParametrizacao  = tit_acr.cod_espec_docto
           CategoriaItem.TipoRelacionamento  = 1
           CategoriaItem.ContaInadimplencia  = 1
           CategoriaItem.ContaPagamento      = 1.

    CREATE CategoriaItem.
    ASSIGN CategoriaItem.NomeCategoria       = "S‚rie"
           CategoriaItem.CodigoCategoriaDEPS = tit_acr.cod_ser_docto
           CategoriaItem.NomeParametrizacao  = tit_acr.cod_ser_docto
           CategoriaItem.TipoRelacionamento  = 1
           CategoriaItem.ContaInadimplencia  = 1
           CategoriaItem.ContaPagamento      = 1.

    CREATE CategoriaItem.
    ASSIGN CategoriaItem.NomeCategoria       = "Portador"
           CategoriaItem.CodigoCategoriaDEPS = tit_acr.cod_portador
           CategoriaItem.NomeParametrizacao  = tit_acr.cod_portador
           CategoriaItem.TipoRelacionamento  = 1
           CategoriaItem.ContaInadimplencia  = 1
           CategoriaItem.ContaPagamento      = 1.

    CREATE CategoriaItem.
    ASSIGN CategoriaItem.NomeCategoria       = "Carteira"
           CategoriaItem.CodigoCategoriaDEPS = tit_acr.cod_cart_bcia
           CategoriaItem.NomeParametrizacao  = tit_acr.cod_cart_bcia
           CategoriaItem.TipoRelacionamento  = 1
           CategoriaItem.ContaInadimplencia  = 1
           CategoriaItem.ContaPagamento      = 1.

    CREATE ListaCategoria.
    ASSIGN ListaCategoria.CodigoCategoriaDEPS = tit_acr.cod_estab.
    
    CREATE ListaCategoria.
    ASSIGN ListaCategoria.CodigoCategoriaDEPS = tit_acr.cod_espec_docto.
    
    CREATE ListaCategoria.
    ASSIGN ListaCategoria.CodigoCategoriaDEPS = tit_acr.cod_ser_docto.
    
    CREATE ListaCategoria.
    ASSIGN ListaCategoria.CodigoCategoriaDEPS = tit_acr.cod_portador.
    
    CREATE ListaCategoria.
    ASSIGN ListaCategoria.CodigoCategoriaDEPS = tit_acr.cod_cart_bcia.

    FIND FIRST movto_tit_acr OF tit_acr NO-LOCK NO-ERROR.

    IF  AVAIL movto_tit_acr
    AND (movto_tit_acr.log_ctbz_aprop_ctbl = YES 
    OR   tit_acr.log_tit_acr_estordo) THEN DO:
        CREATE MovimentosGerais.
        ASSIGN MovimentosGerais.CodigoTipoMovimento = "SALDO"
               MovimentosGerais.NomeDocumento       = string(tit_acr.num_id_tit_acr)
               MovimentosGerais.DataMovimento       = string(YEAR(tit_acr.dat_transacao),"9999") + "-" + STRING(MONTH(tit_acr.dat_transacao),"99") + "-" + STRING(DAY(tit_acr.dat_transacao),"99") + 'T' + STRING(TIME,"HH:MM:SS":U)
               MovimentosGerais.ValorMovimento      = v_val_saldo.

    END.

    FOR EACH movto_tit_acr OF tit_acr NO-LOCK:

        ASSIGN v_val_baixa = 0
               v_transacao = movto_tit_acr.ind_trans_acr.

        /* IF  movto_tit_acr.log_ctbz_aprop_ctbl = NO THEN 
            NEXT. */
    
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
    
            IF  v_val_baixa < 0 THEN
                ASSIGN v_val_baixa = v_val_baixa * (-1).
    
            CREATE MovimentosBaixas.
            ASSIGN MovimentosBaixas.CodigoTipoMovimento = v_transacao
                   MovimentosBaixas.NomeDocumento       = string(movto_tit_acr.num_id_movto_tit_acr)
                   MovimentosBaixas.DataMovimento       = STRING(YEAR(v_dat_baixa),"9999") + "-" + STRING(MONTH(v_dat_baixa),"99") + "-" + STRING(DAY(v_dat_baixa),"99") + "T" + STRING(TIME,"HH:MM:SS":U)
                   MovimentosBaixas.ValorMovimento      = v_val_baixa.
        END.
    END.
END.

/* Grava o xml com o registro, conecta com o Barramento e devolve a resposta. */
{esp/esb/esesb003a.i}

FIND FIRST resultado NO-ERROR.

IF  AVAIL resultado
AND resultado.sucesso THEN DO:

END.

RETURN "OK".
