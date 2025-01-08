/*--- Defini‡Æo das Vari veis ---*/
def new global shared var v_cod_empres_usuar
    as character
    format "x(3)"
    label "Empresa"
    column-label "Empresa"
    no-undo.

DEFINE VARIABLE i-data      AS DATE        NO-UNDO.


/*--- Defini‡Æo das Tabelas Tempor rias ---*/
DEF TEMP-TABLE tt-dados
    FIELD origem                AS CHAR FORMAT "x(3)"   /**** APB, ACR, FGL ou CEP ***/
    FIELD ind_natur_lancto_ctbl AS CHAR FORMAT "X(3)"   /**** DB ou CR             ***/
    FIELD cod_emitente          AS INT  FORMAT ">>>,>>>,>>9"
    FIELD nome_emitente         AS CHAR FORMAT "X(40)"
    FIELD dt_transacao          AS DATE FORMAT "99/99/9999"
    FIELD cod_espec_docto       AS CHAR FORMAT "x(3)"
    FIELD cod_ser_docto         AS CHAR FORMAT "x(3)"
    FIELD cod_tit_ap            AS CHAR FORMAT "x(10)"
    FIELD cod_parcela           AS CHAR FORMAT "x(2)"
    FIELD val_aprop_ctbl        AS DEC  FORMAT ">>>,>>>,>>9.99".



/*--- Defini‡Æo dos Parƒmetros ---*/
DEF INPUT PARAMETER c_cod_estab            AS CHAR FORMAT "X(3)" NO-UNDO.
DEF INPUT PARAMETER c_cod_plano_cta_ctbl   AS CHAR FORMAT "x(8)" NO-UNDO.
DEF INPUT PARAMETER c_cod_cta_ctbl         AS CHAR FORMAT "x(8)" NO-UNDO.
DEF INPUT PARAMETER c_cod_ccusto           AS CHAR FORMAT "X(8)" NO-UNDO.
DEF INPUT PARAMETER d_dat_transacao_ini    AS DATE               NO-UNDO.
DEF INPUT PARAMETER d_dat_transacao_fim    AS DATE               NO-UNDO.
DEF OUTPUT PARAM TABLE FOR tt-dados.




/*--- Bloco Principal ---*/
FIND FIRST estabelecimento NO-LOCK
    WHERE estabelecimento.cod_estab = c_cod_estab NO-ERROR.
IF  NOT AVAIL estabelecimento THEN
    NEXT.


/* ** Movimentos Contabilidade - FGL ***/
FOR EACH  item_lancto_ctbl NO-LOCK
    WHERE item_lancto_ctbl.cod_empres       = estabelecimento.cod_empresa
      AND item_lancto_ctbl.cod_plano_cta    = 'padrao'
      AND item_lancto_ctbl.cod_cta_ctbl     = c_cod_cta_ctbl
      AND item_lancto_ctbl.cod_plano_ccusto = 'padrao'
      AND item_lancto_ctbl.cod_ccusto       = c_cod_ccusto
      AND item_lancto_ctbl.cod_estab        = c_cod_estab
      AND item_lancto_ctbl.cod_cenar_ctbl  <> "gerenc"
      AND item_lancto_ctbl.dat_lancto_ctbl >= d_dat_transacao_ini
      AND item_lancto_ctbl.dat_lancto_ctbl <= d_dat_transacao_fim,
    EACH  lancto_ctbl OF item_lancto_ctbl
         WHERE lancto_ctbl.cod_modul_dtsul <> "apb"
           AND lancto_ctbl.cod_modul_dtsul <> "cep"
           AND lancto_ctbl.cod_modul_dtsul <> "acr":

    CREATE tt-dados.
    ASSIGN tt-dados.origem                = "FGL"
           tt-dados.ind_natur_lancto_ctbl = item_lancto_ctbl.ind_natur_lancto_ctbl
           tt-dados.dt_transacao          = ITEM_lancto_ctbl.dat_lancto_ctbl
           tt-dados.cod_tit_ap            = string(item_lancto_ctbl.num_lote_ctbl)
           tt-dados.cod_parcela           = string(item_lancto_ctbl.num_seq_lancto_ctbl)
           tt-dados.nome_emitente         = ITEM_lancto_ctbl.des_histor_lancto_ctbl
           tt-dados.val_aprop_ctbl        = item_lancto_ctbl.val_lancto_ctbl.
END.


/* ** Movimentos Contas a Pagar - APB ***/
FOR EACH aprop_ctbl_ap NO-LOCK
    WHERE aprop_ctbl_ap.cod_estab          = c_cod_estab
      AND aprop_ctbl_ap.cod_plano_cta_ctbl = c_cod_plano_cta_ctbl
      AND aprop_ctbl_ap.cod_cta_ctbl       = c_cod_cta_ctbl
      AND aprop_ctbl_ap.cod_ccusto         = c_cod_ccusto
      AND aprop_ctbl_ap.dat_transacao     >= d_dat_transacao_ini
      AND aprop_ctbl_ap.dat_transacao     <= d_dat_transacao_fim:

    FIND FIRST movto_tit_ap NO-LOCK
         WHERE movto_tit_ap.cod_estab           = c_cod_estab
           AND movto_tit_ap.num_id_movto_tit_ap = aprop_ctbl_ap.num_id_movto_tit_ap
           AND movto_tit_ap.log_movto_estordo   = NO NO-ERROR.
    IF  NOT AVAIL movto_tit_ap THEN
        NEXT.

    CREATE tt-dados.
    ASSIGN tt-dados.origem                = "APB"
           tt-dados.ind_natur_lancto_ctbl = aprop_ctbl_ap.ind_natur_lancto_ctbl
           tt-dados.dt_transacao          = aprop_ctbl_ap.dat_transacao
           tt-dados.val_aprop_ctbl        = aprop_ctbl_ap.val_aprop_ctbl.
            
    /*Fabiano - Tratamento para t¡tulos implantados em outra moeda*/
    IF aprop_ctbl_ap.cod_indic_econ <> 'real' THEN DO:
         ASSIGN tt-dados.val_aprop_ctbl = 0.
         FOR EACH val_aprop_ctbl_ap OF aprop_ctbl_ap NO-LOCK:
             ASSIGN tt-dados.val_aprop_ctbl = tt-dados.val_aprop_ctbl + val_aprop_ctbl_ap.val_aprop.
         END.
    END.
   
    FIND FIRST emscad.fornecedor NO-LOCK
         WHERE emscad.fornecedor.cod_empresa    = movto_tit_ap.cod_empresa 
           AND emscad.fornecedor.cdn_fornecedor = movto_tit_ap.cdn_fornecedor NO-ERROR.
    IF  AVAIL  emscad.fornecedor THEN
        ASSIGN tt-dados.cod_emitente  = emscad.fornecedor.cdn_fornecedor
               tt-dados.nome_emitente = emscad.fornecedor.nom_pessoa.
 
    IF tt-dados.nome_emitente = "" THEN DO:
         FIND FIRST histor_tit_movto_ap NO-LOCK 
              WHERE histor_tit_movto_ap.cod_estab           = c_cod_estab
                AND histor_tit_movto_ap.num_id_movto_tit_ap = movto_tit_ap.num_id_movto_tit_ap
                AND histor_tit_movto_ap.num_id_tit_ap       = movto_tit_ap.num_id_tit_ap NO-ERROR.
         IF AVAIL histor_tit_movto_ap 
            THEN ASSIGN tt-dados.nome_emitente = histor_tit_movto_ap.des_text_histor.

    END.

    FIND FIRST tit_ap OF movto_tit_ap NO-LOCK NO-ERROR.
    IF AVAIL tit_ap THEN
        ASSIGN tt-dados.cod_espec_docto = tit_ap.cod_espec_docto
               tt-dados.cod_ser_docto   = tit_ap.cod_ser_docto
               tt-dados.cod_tit_ap      = tit_ap.cod_tit_ap
               tt-dados.cod_parcela     = tit_ap.cod_parcela.
END.


/* ** Movimentos Contas a Receber - ACR ***/
FOR EACH aprop_ctbl_acr NO-LOCK
    WHERE aprop_ctbl_acr.cod_estab          = c_cod_estab
      AND aprop_ctbl_acr.cod_plano_cta_ctbl = c_cod_plano_cta_ctbl
      AND aprop_ctbl_acr.cod_cta_ctbl       = c_cod_cta_ctbl
      AND aprop_ctbl_acr.dat_transacao     >= d_dat_transacao_ini
      AND aprop_ctbl_acr.dat_transacao     <= d_dat_transacao_fim
      AND aprop_ctbl_acr.cod_ccusto         = c_cod_ccusto:

    FIND FIRST movto_tit_acr NO-LOCK
         WHERE movto_tit_acr.cod_estab            = c_cod_estab
           AND movto_tit_acr.num_id_movto_tit_acr = aprop_ctbl_acr.num_id_movto_tit_acr
           AND movto_tit_acr.LOG_movto_estordo    = NO NO-ERROR.
    IF  NOT AVAIL movto_tit_acr THEN
        NEXT.

    FIND FIRST tit_acr OF movto_tit_acr NO-LOCK NO-ERROR.
    IF  NOT AVAIL tit_acr THEN
        NEXT.
    
    CREATE tt-dados.
    ASSIGN tt-dados.origem                = "ACR"
           tt-dados.ind_natur_lancto_ctbl = aprop_ctbl_acr.ind_natur_lancto_ctbl
           tt-dados.dt_transacao          = aprop_ctbl_acr.dat_transacao
           tt-dados.cod_espec_docto       = tit_acr.cod_espec_docto
           tt-dados.cod_ser_docto         = tit_acr.cod_ser_docto
           tt-dados.cod_tit_ap            = tit_acr.cod_tit_acr
           tt-dados.cod_parcela           = tit_acr.cod_parcela
           tt-dados.val_aprop_ctbl        = aprop_ctbl_acr.val_aprop_ctbl.

    /*Fabiano - Tratamento para t¡tulos implantados em outra moeda*/
    IF aprop_ctbl_acr.cod_indic_econ <> 'real' THEN DO:
         ASSIGN tt-dados.val_aprop_ctbl = 0.
         FOR EACH val_aprop_ctbl_acr OF aprop_ctbl_acr NO-LOCK:
             ASSIGN tt-dados.val_aprop_ctbl = tt-dados.val_aprop_ctbl + val_aprop_ctbl_acr.val_aprop.
         END.
    END.

    FIND FIRST emscad.cliente NO-LOCK
         WHERE emscad.cliente.cod_empresa = movto_tit_acr.cod_empresa 
           AND emscad.cliente.cdn_cliente = movto_tit_acr.cdn_cliente NO-ERROR.
    IF  AVAIL  emscad.cliente THEN
        ASSIGN tt-dados.cod_emitente  = emscad.cliente.cdn_cliente
               tt-dados.nome_emitente = emscad.cliente.nom_pessoa.
END.

