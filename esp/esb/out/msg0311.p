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

DEF BUFFER b_movto_tit_acr     FOR movto_tit_acr.
DEF BUFFER b_val_movto_tit_acr FOR val_movto_tit_acr.

{esp/esb/out/msg0311.i}
{utp/ut-glob.i}
{include/i-freeac.i}

DEFINE INPUT  PARAM raw-param AS RAW NO-UNDO.
DEFINE OUTPUT PARAM TABLE FOR resultado.

DEF VAR iXml AS LONGCHAR NO-UNDO.
DEF VAR oXML AS LONGCHAR NO-UNDO.

RAW-TRANSFER raw-param TO tt_tit_acr.

DEFINE DATASET mensagem XML-NODE-NAME 'MENSAGEM' for cabecalho, conteudo, msg0311, ListaCategoria
   DATA-RELATION FOR conteudo, msg0311                      RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0311, ListaCategoria                RELATION-FIELDS (idm, idm) NESTED.

DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, msg0311r, resultado
   DATA-RELATION FOR conteudor, msg0311r RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0311r, resultado RELATION-FIELDS (idm, idm) NESTED.


FOR FIRST tt_tit_acr NO-LOCK:

    FIND FIRST tit_acr
        WHERE tit_acr.cod_estab      = tt_tit_acr.cod_estab
        AND   tit_acr.num_id_tit_acr = tt_tit_acr.num_id_tit_acr NO-LOCK NO-ERROR.

    ASSIGN v_val_saldo = 0
           v_val_orig  = 0
           v_val_baixa = 0.

    CREATE cabecalho.
    ASSIGN cabecalho.IdentidadeEmissor = '64546C2E-6DAB-4311-A74A-5ACA96134AFF'
           cabecalho.CodigoMensagem    = 'MSG0311'
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
    
    FOR EACH val_tit_acr
        WHERE val_tit_acr.cod_estab        = tit_acr.cod_estab      
        AND   val_tit_acr.num_id_tit_acr   = tit_acr.num_id_tit_acr 
        AND   val_tit_acr.cod_finalid_econ = "Corrente" NO-LOCK:
    
        ASSIGN v_val_saldo = v_val_saldo + val_tit_acr.val_sdo_tit_acr
               v_val_orig  = v_val_orig  + val_tit_acr.val_origin_tit_acr.
    END.
    
    CREATE msg0311.                          
    ASSIGN msg0311.Codigo                       = tit_acr.num_id_tit_acr
           msg0311.TipoCliente                  = v_tipo_pessoa
           msg0311.CpfCnpjCodEstrangeiro        = v_docto_cliente
           msg0311.DataEmissao                  = string(YEAR(tit_acr.dat_emis_docto),"9999") + "-" + STRING(MONTH(tit_acr.dat_emis_docto),"99") + "-" + STRING(DAY(tit_acr.dat_emis_docto),"99")
           msg0311.NumeroNotaFiscalComplementar = tit_acr.cod_tit_acr + "/" + tit_acr.cod_parcela
           msg0311.TipoNotaFiscalComplementar   = 1
           msg0311.ValorTotal                   = v_val_orig
           msg0311.ValorSaldo                   = v_val_saldo
           msg0311.NumeroNotaFiscal             = "".
    
    CREATE ListaCategoria.
    ASSIGN ListaCategoria.CodigoCategoriaDEPS = tit_acr.cod_estab.
    
    CREATE ListaCategoria.
    ASSIGN ListaCategoria.CodigoCategoriaDEPS = tit_acr.cod_espec_docto.
    
    CREATE ListaCategoria.
    ASSIGN ListaCategoria.CodigoCategoriaDEPS = tit_acr.cod_ser_docto.
    
END.

/* Grava o xml com o registro, conecta com o Barramento e devolve a resposta. */
{esp/esb/esesb003a.i}

RETURN "OK".
