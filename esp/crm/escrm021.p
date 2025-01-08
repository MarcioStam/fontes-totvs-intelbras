/*********************************************************************************
** Programa: esp/crm/escrm021.p
** Vers∆o..: 1.00
** Data....: 08/11/2010
** Autor...: Estevan KrÅger - Exponencial TI
** Obs.....: Relat¢rio do Portal B2B.
**           C¢pia da procedure "process-find-pedido", programa "soap-b2b-ped-venda"
**           Detalhe de um Pedido
*********************************************************************************/

CREATE WIDGET-POOL.


/*--- Definiá∆o das Temp-Tables ---*/
DEFINE TEMP-TABLE tt-ped-venda NO-UNDO
    FIELD nome-abrev           LIKE ped-venda.nome-abrev
    FIELD nr-pedcli            LIKE ped-venda.nr-pedcli
    FIELD cod-emitente         LIKE emitente.cod-emitente
    FIELD nome-emit            LIKE emitente.nome-emit
    FIELD cod-estabel          LIKE ped-venda.cod-estabel
    FIELD observacoes          LIKE ped-venda.observacoes
    FIELD desc-bloq-cr         LIKE ped-venda.desc-bloq-cr
    FIELD cond-espec           LIKE ped-venda.cond-espec
    FIELD vendor               AS LOGICAL
    FIELD vendor-taxa          AS DECIMAL
    FIELD vendor-dias-carencia AS INTEGER
    FIELD desc-cond-pagto      LIKE cond-pagto.descricao
    FIELD tipo-frete           AS CHARACTER
    FIELD dt-entrega           LIKE ped-venda.dt-entrega
    FIELD dt-emissao           LIKE ped-venda.dt-emissao
    FIELD cod-rep              LIKE repres.cod-rep
    FIELD no-ab-reppri         LIKE ped-venda.no-ab-reppri
    FIELD nome-transp          LIKE transporte.nome
    FIELD endereco             AS CHARACTER
    FIELD bairro               AS CHARACTER
    FIELD cep                  AS CHARACTER
    FIELD cidade               AS CHARACTER
    FIELD estado               AS CHARACTER
    FIELD vl-substrib          AS DECIMAL
    INDEX idx-pedido           AS PRIMARY UNIQUE nome-abrev nr-pedcli.

DEFINE TEMP-TABLE tt-ped-item NO-UNDO
    FIELD nome-abrev      LIKE ped-item.nome-abrev
    FIELD nr-pedcli       LIKE ped-item.nr-pedcli
    FIELD it-codigo       LIKE item.it-codigo
    FIELD desc-item       LIKE item.desc-item
    FIELD vl-preuni       LIKE ped-item.vl-preuni
    FIELD qt-pedida       LIKE ped-item.qt-pedida
    FIELD saldo-item      AS DECIMAL
    FIELD aliq-ipi        LIKE item.aliquota-ipi
    FIELD situacao        AS CHARACTER
    FIELD vl-substrib     AS DECIMAL
    INDEX idx-pedido      nome-abrev nr-pedcli.

DEFINE TEMP-TABLE tt-nota-fiscal NO-UNDO
    FIELD cod-estabel     LIKE nota-fiscal.cod-estabel
    FIELD serie           LIKE nota-fiscal.serie
    FIELD nr-nota-fis     LIKE nota-fiscal.nr-nota-fis
    FIELD nome-abrev      LIKE ped-venda.nome-abrev
    FIELD nr-pedcli       LIKE ped-venda.nr-pedcli
    FIELD dt-emis-nota    LIKE nota-fiscal.dt-emis-nota
    FIELD nome-transp     LIKE transporte.nome
    FIELD desc-cond-pagto LIKE cond-pagto.descricao
    FIELD vl-tot-nota     LIKE nota-fiscal.vl-tot-nota
    FIELD cancelada       AS LOGICAL
    FIELD observ-nota     LIKE nota-fiscal.observ-nota
    INDEX idx-nota        cod-estabel serie nr-nota-fis
    INDEX idx-pedido      nome-abrev nr-pedcli.



/*--- ParÉmetros de Entrada ---*/
DEFINE INPUT  PARAMETER p-cod-estabel  AS CHARACTER   NO-UNDO.
DEFINE INPUT  PARAMETER p-cod-emitente AS INTEGER     NO-UNDO.
DEFINE INPUT  PARAMETER p-nr-pedcli    AS CHARACTER   NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR tt-ped-venda.
DEFINE OUTPUT PARAMETER TABLE FOR tt-ped-item.
DEFINE OUTPUT PARAMETER TABLE FOR tt-nota-fiscal.



/*--- Definiá∆o das Vari†veis ---*/
DEFINE VARIABLE c-cond-pagto-descricao AS CHAR NO-UNDO.
DEFINE VARIABLE c-endereco     AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-bairro       AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-cep          AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-cidade       AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-estado       AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-tipo-frete   AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-arquivo      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE l-vendor       AS LOGICAL   NO-UNDO.
DEFINE VARIABLE d-taxa-vendor  AS DECIMAL   NO-UNDO.
DEFINE VARIABLE i-carencia     AS INTEGER   NO-UNDO.
DEFINE VARIABLE i-cod-cond-pag AS INTEGER   NO-UNDO.
DEFINE VARIABLE i-saldo-item   AS INTEGER   NO-UNDO.

DEFINE BUFFER b-transporte FOR transporte.

/*--- Bloco Principal ---*/
FOR FIRST emitente FIELDS (cod-emitente nome-emit endereco bairro cep cidade estado) NO-LOCK
    WHERE emitente.cod-emitente = p-cod-emitente,
    FIRST ped-venda FIELDS (cod-estabel nr-pedido nr-pedcli nome-abrev nome-transp cod-cond-pag cod-entrega cidade-cif desc-bloq-cr observacoes cond-espec dt-entrega dt-emissao no-ab-reppri) NO-LOCK
    WHERE ped-venda.nome-abrev  = emitente.nome-abrev
    AND   ped-venda.nr-pedcli   = p-nr-pedcli:

    IF  (p-cod-estabel = "101" OR p-cod-estabel = "104") THEN DO:
        IF  (ped-venda.cod-estabel <> "101" AND ped-venda.cod-estabel <> "104") THEN
            NEXT.
    END.
    ELSE DO:
        IF (p-cod-estabel <> ped-venda.cod-estabel) THEN
            NEXT.
    END.

    FIND FIRST transporte NO-LOCK
        WHERE  transporte.nome-abrev = ped-venda.nome-transp NO-ERROR.

    /** Tratativa pra quando for VENDOR **/
    FIND FIRST pd-vendor NO-LOCK
        WHERE  pd-vendor.nr-pedido = ped-venda.nr-pedido NO-ERROR.
    IF  AVAIL  pd-vendor THEN
        ASSIGN l-vendor       = YES
               d-taxa-vendor  = pd-vendor.taxa-cliente * 100
               i-carencia     = pd-vendor.dias-base
               i-cod-cond-pag = pd-vendor.cod-cond-cli.
    ELSE
        ASSIGN l-vendor       = NO
               i-cod-cond-pag = ped-venda.cod-cond-pag.
    
    /** Pega a descricao da condicao de pagamento **/
    IF (i-cod-cond-pag > 0) THEN DO:
        FIND FIRST cond-pagto WHERE cond-pagto.cod-cond-pag = i-cod-cond-pag NO-LOCK NO-ERROR.
        ASSIGN c-cond-pagto-descricao = IF AVAIL cond-pagto THEN cond-pagto.descricao ELSE "".
    END.
    ELSE
        ASSIGN c-cond-pagto-descricao = "Especial".


    /** Pega o endereco de entrega **/
    IF (ped-venda.cod-entrega <> "Padrao") THEN DO:
        FIND FIRST loc-entr NO-LOCK
            WHERE  loc-entr.cod-entrega = ped-venda.cod-entrega
            AND    loc-entr.nome-abrev  = ped-venda.nome-abrev NO-ERROR.
        IF  AVAIL  loc-entr THEN
            ASSIGN c-endereco = loc-entr.endereco
                   c-bairro   = loc-entr.bairro
                   c-cep      = loc-entr.cep
                   c-cidade   = loc-entr.cidade
                   c-estado   = loc-entr.estado.
    END.
    ELSE
        ASSIGN c-endereco = emitente.endereco
               c-bairro   = emitente.bairro
               c-cep      = emitente.cep
               c-cidade   = emitente.cidade
               c-estado   = emitente.estado.

    /** Tipo do frete **/
    IF (ped-venda.cidade-cif <> "") THEN
        ASSIGN c-tipo-frete = "CIF".
    ELSE
        ASSIGN c-tipo-frete = "FOB".


    CREATE tt-ped-venda.
    ASSIGN tt-ped-venda.nome-abrev           = ped-venda.nome-abrev
           tt-ped-venda.nr-pedcli            = ped-venda.nr-pedcli
           tt-ped-venda.cod-emitente         = emitente.cod-emitente
           tt-ped-venda.nome-emit            = emitente.nome-emit
           tt-ped-venda.cod-estabel          = ped-venda.cod-estabel
           tt-ped-venda.observacoes          = ped-venda.observacoes
           tt-ped-venda.desc-bloq-cr         = ped-venda.desc-bloq-cr
           tt-ped-venda.cond-espec           = ped-venda.cond-espec
           tt-ped-venda.vendor               = l-vendor
           tt-ped-venda.vendor-taxa          = d-taxa-vendor
           tt-ped-venda.vendor-dias-carencia = i-carencia
           tt-ped-venda.desc-cond-pagto      = c-cond-pagto-descricao
           tt-ped-venda.tipo-frete           = c-tipo-frete
           tt-ped-venda.dt-entrega           = ped-venda.dt-entrega
           tt-ped-venda.dt-emissao           = ped-venda.dt-emissao
           tt-ped-venda.no-ab-reppri         = ped-venda.no-ab-reppri
           tt-ped-venda.nome-transp          = IF AVAIL transporte THEN transporte.nome ELSE ""
           tt-ped-venda.endereco             = c-endereco
           tt-ped-venda.bairro               = c-bairro
           tt-ped-venda.cep                  = c-cep
           tt-ped-venda.cidade               = c-cidade
           tt-ped-venda.estado               = c-estado.


    FOR EACH ped-item OF ped-venda NO-LOCK,
        FIRST item FIELDS (it-codigo desc-item aliquota-ipi) NO-LOCK
        WHERE item.it-codigo = ped-item.it-codigo
        BY ped-item.nr-sequencia:

        ASSIGN i-saldo-item = ped-item.qt-pedida - ped-item.qt-atendida.

        IF (i-saldo-item < 0) THEN
            ASSIGN i-saldo-item = 0.

        CREATE tt-ped-item.
        ASSIGN tt-ped-item.nome-abrev = ped-venda.nome-abrev
               tt-ped-item.nr-pedcli  = ped-venda.nr-pedcli
               tt-ped-item.it-codigo  = item.it-codigo
               tt-ped-item.desc-item  = item.desc-item
               tt-ped-item.vl-preuni  = ped-item.vl-preuni
               tt-ped-item.qt-pedida  = ped-item.qt-pedida
               tt-ped-item.saldo-item = i-saldo-item
               tt-ped-item.aliq-ipi   = item.aliquota-ipi
               tt-ped-item.situacao   = {diinc/i03di149.i 04 ped-item.cod-sit-item}.

        FIND FIRST natur-oper
            WHERE natur-oper.nat-operacao = ped-item.nat-operacao NO-LOCK NO-ERROR.

        IF AVAILABLE natur-oper AND
           natur-oper.subs-trib THEN
            ASSIGN tt-ped-venda.vl-substrib = tt-ped-venda.vl-substrib + ROUND(ped-item.vl-tot-it - ped-item.vl-liq-it - (ped-item.qt-pedida * ped-item.vl-preuni) * (ped-item.aliquota-ipi / 100), 2)
                   tt-ped-item.vl-substrib  = tt-ped-item.vl-substrib  + ROUND(ped-item.vl-tot-it - ped-item.vl-liq-it - (ped-item.qt-pedida * ped-item.vl-preuni) * (ped-item.aliquota-ipi / 100), 2).
    END.

    FOR EACH  nota-fiscal NO-LOCK
        WHERE nota-fiscal.nome-ab-cli = emitente.nome-abrev
        AND   nota-fiscal.nr-pedcli   = ped-venda.nr-pedcli,
        FIRST b-transporte FIELDS (nome) NO-LOCK
        WHERE b-transporte.nome-abrev = nota-fiscal.nome-transp
        BY    nota-fiscal.nr-nota-fis
        BY    nota-fiscal.serie:

        FIND FIRST cond-pagto WHERE cond-pagto.cod-cond-pag = i-cod-cond-pag NO-LOCK NO-ERROR.
        IF  AVAIL  cond-pagto THEN
            ASSIGN c-cond-pagto-descricao = cond-pagto.descricao.
        ELSE
            ASSIGN c-cond-pagto-descricao = "Especial".

        CREATE tt-nota-fiscal.
        ASSIGN tt-nota-fiscal.nome-abrev      = ped-venda.nome-abrev
               tt-nota-fiscal.nr-pedcli       = ped-venda.nr-pedcli
               tt-nota-fiscal.cod-estabel     = nota-fiscal.cod-estabel
               tt-nota-fiscal.serie           = nota-fiscal.serie
               tt-nota-fiscal.nr-nota-fis     = nota-fiscal.nr-nota-fis
               tt-nota-fiscal.dt-emis-nota    = nota-fiscal.dt-emis-nota
               tt-nota-fiscal.nome-transp     = b-transporte.nome
               tt-nota-fiscal.desc-cond-pagto = c-cond-pagto-descricao
               tt-nota-fiscal.vl-tot-nota     = nota-fiscal.vl-tot-nota
               tt-nota-fiscal.cancelada       = (nota-fiscal.dt-cancel <> ?)
               tt-nota-fiscal.observ-nota     = nota-fiscal.observ-nota.
    END.
END.



DELETE WIDGET-POOL.
RETURN "OK":U.
