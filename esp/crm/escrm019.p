/*********************************************************************************
** Programa: esp/crm/escrm019.p
** Vers∆o..: 1.00
** Data....: 05/11/2010
** Autor...: Estevan KrÅger - Exponencial TI
** Obs.....: Relat¢rio do Portal B2B.
**           C¢pia da procedure "process-find-emitente", programa "soap-b2b-emitente"
*********************************************************************************/

CREATE WIDGET-POOL.


/*--- Definiá∆o das Temp-Tables ---*/
DEFINE TEMP-TABLE tt-emitente  NO-UNDO
    FIELD cod-emitente         LIKE emitente.cod-emitente
    FIELD nome-emit            LIKE emitente.nome-emit
    FIELD cgc                  LIKE emitente.cgc
    FIELD ins-estadual         LIKE emitente.ins-estadual
    FIELD telefone             LIKE emitente.telefone
    FIELD endereco             LIKE emitente.endereco
    FIELD bairro               LIKE emitente.bairro
    FIELD cidade               LIKE emitente.cidade
    FIELD estado               LIKE emitente.estado
    FIELD cep                  LIKE emitente.cep
    FIELD endereco-cob         LIKE emitente.endereco-cob
    FIELD bairro-cob           LIKE emitente.bairro-cob
    FIELD cidade-cob           LIKE emitente.cidade-cob
    FIELD estado-cob           LIKE emitente.estado-cob
    FIELD cep-cob              LIKE emitente.cep-cob
    FIELD lim-credito          LIKE emitente.lim-credito
    FIELD dt-lim-cred          LIKE emitente.dt-lim-cred
    FIELD cod-suframa          LIKE emitente.cod-suframa
    FIELD bonificacao          LIKE emitente.bonificacao
    FIELD ind-cred-cli         LIKE emitente.ind-cre-cli
    FIELD observacoes          LIKE emitente.observacoes
    FIELD categoria            LIKE emitente.categoria
    FIELD ds-gr-cli            LIKE gr-cli.descricao
    FIELD desc-pontual         AS   DECIMAL
    FIELD contrato-vendor      AS   LOGICAL
    FIELD consumidor-final     AS   LOGICAL
    FIELD cod-estabel          AS   CHARACTER
    FIELD indice               AS   INTEGER
    FIELD val-limite-supcard   AS DECIMAL
    FIELD val-limite-intelbras LIKE emitente.lim-credito
    INDEX idx-emitente         AS PRIMARY UNIQUE cod-emitente.

DEFINE TEMP-TABLE tt-cont-emit NO-UNDO
    FIELD cod-emit             LIKE emitente.cod-emitente
    FIELD sequencia            LIKE cont-emit.sequencia
    FIELD nome                 LIKE cont-emit.nome
    FIELD e-mail               LIKE cont-emit.e-mail
    FIELD telefone             LIKE cont-emit.telefone
    FIELD ramal                LIKE cont-emit.ramal
    INDEX idx-cont-emit        AS PRIMARY UNIQUE cod-emit sequencia.



/*--- Definiá∆o das Vari†veis ---*/
DEFINE VARIABLE de-perc-desc     AS DECIMAL     NO-UNDO.
DEFINE VARIABLE l-permite-vendor AS LOGICAL     NO-UNDO.
DEFINE VARIABLE c-arquivo        AS CHARACTER   NO-UNDO.

DEFINE VARIABLE de-vl-lim-tot-supcard AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-val-lim-supcard    AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-val-aloc-pedido    AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-val-comp-nfs       AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-val-lim-disp       AS DECIMAL     NO-UNDO.
DEFINE VARIABLE h-esapi001            AS HANDLE      NO-UNDO.


/*--- ParÉmetros do Programa ---*/
DEFINE INPUT  PARAMETER p-cod-emitente AS INTEGER     NO-UNDO.
DEFINE INPUT  PARAMETER p-cod-estabel  AS CHARACTER   NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR tt-emitente.
DEFINE OUTPUT PARAMETER TABLE FOR tt-cont-emit.


IF NOT VALID-HANDLE(h-esapi001) THEN
    RUN esp/esapi001.p PERSISTENT SET h-esapi001.

/*--- Bloco Principal ---*/
FOR FIRST emitente FIELDS (cod-emitente nome-emit cgc ins-estadual cod-suframa bonificacao
                           ind-cre-cli observacoes lim-credito dt-lim-cred endereco bairro
                           cidade estado cep endereco-cob bairro-cob cidade-cob estado-cob
                           cep-cob telefone categoria) NO-LOCK
    WHERE emitente.cod-emitente = p-cod-emitente:

    FIND FIRST estabelec NO-LOCK WHERE estabelec.cod-estabel = p-cod-estabel NO-ERROR.

    FIND FIRST gr-cli OF emitente NO-LOCK NO-ERROR.
    
    FIND FIRST indice-cgc NO-LOCK
        WHERE  indice-cgc.cgc = SUBSTRING(emitente.cgc,1,8) NO-ERROR.

    ASSIGN de-val-lim-supcard = 0
           de-val-aloc-pedido = 0
           de-val-comp-nfs    = 0
           de-val-lim-disp    = 0.

    IF VALID-HANDLE(h-esapi001) THEN
        RUN pi-saldo-raiz-cnpj IN h-esapi001 (INPUT  SUBSTRING(emitente.cgc,1,8),
                                              OUTPUT de-vl-lim-tot-supcard,
                                              OUTPUT de-val-lim-supcard,
                                              OUTPUT de-val-aloc-pedido,
                                              OUTPUT de-val-comp-nfs,
                                              OUTPUT de-val-lim-disp).

    /** Tratamento do desconto de pontualidade **/
    ASSIGN de-perc-desc = 2.
    
    IF  CAN-FIND(FIRST tit_acr NO-LOCK
                 WHERE (tit_acr.cod_estab           = estabelec.cod-estabel
                 AND   tit_acr.cdn_cliente          = emitente.cod-emitente
                 AND   tit_acr.log_sdo_tit_acr      = YES
                 AND   tit_acr.log_tit_acr_estordo  = NO
                 AND   tit_acr.dat_vencto_tit_acr  <= TODAY - 6
                 AND  (tit_acr.cod_cart_bci        <> "90"
                 AND  (tit_acr.cod_portador        <> "9996"
                 AND   tit_acr.cod_portad          <> "9905"
                 AND   tit_acr.cod_portad          <> "9977"))
                 AND  (tit_acr.ind_tip_espec_docto  = "normal"
                 OR    tit_acr.ind_tip_espec_docto  = "vendor"))) THEN
        ASSIGN de-perc-desc = 0.
    
    IF  CAN-FIND(FIRST tit_acr NO-LOCK
                 WHERE (tit_acr.cod_estab          = estabelec.cod-estabel
                 AND   tit_acr.cdn_cliente         = emitente.cod-emitente
                 AND   tit_acr.log_sdo_tit_acr     = YES
                 AND   tit_acr.log_tit_acr_estordo = NO
                 AND   tit_acr.cod_espec_docto     = "vd")) THEN
        ASSIGN de-perc-desc = 0.
    
    /** Tratamento do vendor **/
    IF  CAN-FIND(FIRST contrat_vendor NO-LOCK
                 WHERE contrat_vendor.cdn_cliente    = emitente.cod-emitente
                 AND   contrat_vendor.dat_fim_valid >= TODAY) THEN
        ASSIGN l-permite-vendor = YES.
    ELSE
        ASSIGN l-permite-vendor = NO.


    CREATE tt-emitente.
    ASSIGN tt-emitente.cod-emitente         = emitente.cod-emitente
           tt-emitente.nome-emit            = emitente.nome-emit
           tt-emitente.cgc                  = emitente.cgc
           tt-emitente.ins-estadual         = emitente.ins-estadual
           tt-emitente.telefone             = emitente.telefone[1]
           tt-emitente.endereco             = emitente.endereco
           tt-emitente.bairro               = emitente.bairro
           tt-emitente.cidade               = emitente.cidade
           tt-emitente.estado               = emitente.estado
           tt-emitente.cep                  = emitente.cep
           tt-emitente.endereco-cob         = emitente.endereco-cob
           tt-emitente.bairro-cob           = emitente.bairro-cob
           tt-emitente.cidade-cob           = emitente.cidade-cob
           tt-emitente.estado-cob           = emitente.estado-cob
           tt-emitente.cep-cob              = emitente.cep-cob
           tt-emitente.lim-credito          = emitente.lim-credito
           tt-emitente.dt-lim-cred          = emitente.dt-lim-cred
           tt-emitente.cod-suframa          = emitente.cod-suframa
           tt-emitente.bonificacao          = emitente.bonificacao
           tt-emitente.ind-cred-cli         = emitente.ind-cre-cli
           tt-emitente.observacoes          = "" /* retirado esta informaá∆o conforme chamado 55071 */
           tt-emitente.categoria            = emitente.categoria
           tt-emitente.desc-pontual         = de-perc-desc
           tt-emitente.contrato-vendor      = l-permite-vendor
           tt-emitente.consumidor-final     = (emitente.ins-estadual BEGINS "Isen" OR emitente.ins-estadual = "")
           tt-emitente.cod-estabel          = IF AVAIL estabelec  THEN estabelec.cod-estabel ELSE ""
           tt-emitente.ds-gr-cli            = IF AVAIL gr-cli     THEN gr-cli.descricao      ELSE ""
           tt-emitente.indice               = IF AVAIL indice-cgc THEN indice-cgc.indice     ELSE 0
           tt-emitente.val-limite-supcard   = de-val-lim-disp
           tt-emitente.val-limite-intelbras = emitente.lim-credito.

 /****  os contatos do totvs s∆o usados somente para nfe portanto n∆o serao enviados aqui */
    
/*     FOR EACH cont-emit FIELDS (sequencia nome e-mail telefone ramal) OF emitente NO-LOCK: */
/*         CREATE tt-cont-emit.                                                              */
/*         ASSIGN tt-cont-emit.cod-emit  = emitente.cod-emitente                             */
/*                tt-cont-emit.sequencia = cont-emit.sequencia                               */
/*                tt-cont-emit.nome      = cont-emit.nome                                    */
/*                tt-cont-emit.e-mail    = cont-emit.e-mail                                  */
/*                tt-cont-emit.telefone  = cont-emit.telefone                                */
/*                tt-cont-emit.ramal     = cont-emit.ramal.                                  */
/*     END.                                                                                  */
END.

IF VALID-HANDLE(h-esapi001) THEN
    DELETE PROCEDURE h-esapi001.

DELETE WIDGET-POOL.
RETURN "OK":U.
