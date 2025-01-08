/*********************************************************************************
** Programa: esp/acr/esacr053rpa.p
** Vers∆o..: 1.00
** Data....: 26/03/2012
** Autor...: Estevan KrÅger - Exponencial TI
** Obs.....: Programa para buscar os dados que ser∆o impressos
*********************************************************************************/

/*--- Definiá∆o das Vari†veis Locais ---*/
DEFINE VARIABLE h-acomp       AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-nome-matriz AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-cli-antig   AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-cli-corre   AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-ano-antig   AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-ano-corre   AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-ano         AS INTEGER     NO-UNDO.




/*--- Definiá∆o de Temp-Tables e Buffers ---*/
{esp/acr/esacr053.i}




/*--- Definiá∆o dos ParÉmetros de Entrada ---*/
DEFINE INPUT  PARAMETER TABLE FOR tt-param.
DEFINE OUTPUT PARAMETER TABLE FOR tt-cliente.
DEFINE OUTPUT PARAMETER TABLE FOR tt-valores-cli.




/*--- Bloco Principal ---*/
FIND FIRST tt-param NO-LOCK NO-ERROR.


IF  NOT VALID-HANDLE(h-acomp) THEN
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

IF  VALID-HANDLE(h-acomp) THEN
    RUN pi-inicializar IN h-acomp (INPUT "Contas a Receber").


/* Busca as informaá‰es do CONTAS A RECEBER */
FOR EACH  estabelec NO-LOCK
    WHERE estabelec.cod-estabel  >= tt-param.cod-estab-ini
    AND   estabelec.cod-estabel  <= tt-param.cod-estab-fim,
    EACH  tit_acr NO-LOCK
    WHERE tit_acr.cod_estab       = estabelec.cod-estabel
    AND   tit_acr.log_sdo_tit_acr
    AND   tit_acr.cod_portador    = "9943"
    AND   tit_acr.cdn_cliente    >= tt-param.cod-cliente-ini
    AND   tit_acr.cdn_cliente    <= tt-param.cod-cliente-fim
    BY    tit_acr.cdn_cliente
    BY    tit_acr.dat_vencto_tit_acr:

    /* Faixa de Data de Vencimento */
    IF  tit_acr.dat_vencto_tit_acr < tt-param.dt-inicial OR
        tit_acr.dat_vencto_tit_acr > tt-param.dt-final   THEN
        NEXT.

    RUN pi-acompanhar IN h-acomp (INPUT "T°tulo: " + tit_acr.cod_tit_acr).

    /* Somente t°tulos com saldo, e n∆o estornados */
    IF  tit_acr.log_tit_acr_estordo THEN
        NEXT.


    IF  tit_acr.cdn_cliente <> i-cli-antig THEN DO:
        FIND FIRST emitente NO-LOCK
            WHERE  emitente.cod-emitente = tit_acr.cdn_cliente NO-ERROR.
        ASSIGN c-nome-matriz = IF AVAIL emitente THEN emitente.nome-matriz ELSE "".

        FIND FIRST emitente NO-LOCK
            WHERE  emitente.nome-abrev = c-nome-matriz NO-ERROR.

        FIND FIRST tt-cliente EXCLUSIVE-LOCK
            WHERE  tt-cliente.cod-cliente = emitente.cod-emitente NO-ERROR.
        IF  NOT AVAIL tt-cliente THEN DO:
            CREATE tt-cliente.
            ASSIGN tt-cliente.cod-cliente = emitente.cod-emitente
                   tt-cliente.nom-cliente = emitente.nome-emit.

            /* Cria a temp-table de valores com todos os anos da faixa */
            DO  i-ano = YEAR(tt-param.dt-inicial) TO YEAR(tt-param.dt-final):
                CREATE tt-valores-cli.
                ASSIGN tt-valores-cli.cod-cliente = tt-cliente.cod-cliente
                       tt-valores-cli.ano         = i-ano.
            END.
        END.

        ASSIGN i-cli-antig = tit_acr.cdn_cliente
               i-ano-antig = 0.
    END.


    IF  YEAR(tit_acr.dat_vencto_tit_acr) <> i-ano-antig THEN DO:
        /* Busca o registro do cliente para o ano corrente */
        FIND FIRST tt-valores-cli EXCLUSIVE-LOCK
            WHERE  tt-valores-cli.cod-cliente = tt-cliente.cod-cliente
            AND    tt-valores-cli.ano         = YEAR(tit_acr.dat_vencto_tit_acr) NO-ERROR.

        ASSIGN i-ano-antig = YEAR(tit_acr.dat_vencto_tit_acr).
    END.

    FOR EACH  val_tit_acr NO-LOCK
        WHERE val_tit_acr.cod_estab      = tit_acr.cod_estab
        AND   val_tit_acr.num_id_tit_acr = tit_acr.num_id_tit_acr:
        IF  val_tit_acr.cod_unid_negoc < tt-param.cod-unid-negoc-ini OR
            val_tit_acr.cod_unid_negoc > tt-param.cod-unid-negoc-fim THEN
            NEXT.

        ASSIGN tt-valores-cli.tot-ano-acr = tt-valores-cli.tot-ano-acr + val_tit_acr.val_sdo_tit_acr.
    END.
END.


IF  VALID-HANDLE(h-acomp) THEN
    RUN pi-seta-titulo IN h-acomp (INPUT "Contas a Pagar").


/* Busca as informaá‰es do CONTAS A PAGAR */
ASSIGN i-cli-antig = 0
       i-ano       = 0       
       i-ano-antig = 0.

FOR EACH  estabelec NO-LOCK
    WHERE estabelec.cod-estabel >= tt-param.cod-estab-ini
    AND   estabelec.cod-estabel <= tt-param.cod-estab-fim,
    EACH  tit_ap NO-LOCK
    WHERE tit_ap.cod_estab       = estabelec.cod-estabel
    AND   tit_ap.log_sdo_tit_ap
    AND   tit_ap.cdn_fornecedor >= tt-param.cod-cliente-ini
    AND   tit_ap.cdn_fornecedor <= tt-param.cod-cliente-fim
    BY    tit_ap.cdn_fornecedor
    BY    tit_ap.dat_vencto_tit_ap:

    IF  LOOKUP(tit_ap.cod_espec, tt-param.espec) = 0 THEN
        NEXT.

    /* Faixa de Data de Vencimento */
    IF  tit_ap.dat_vencto_tit_ap < tt-param.dt-inicial OR
        tit_ap.dat_vencto_tit_ap > tt-param.dt-final   THEN
        NEXT.


    RUN pi-acompanhar IN h-acomp (INPUT "T°tulo: " + tit_ap.cod_tit_ap).

    /* Somente t°tulos com saldo, e n∆o estornados */
    IF  tit_ap.log_tit_ap_estordo THEN
        NEXT.


    IF  tit_ap.cdn_fornecedor <> i-cli-antig THEN DO:
        FIND FIRST emitente NO-LOCK
            WHERE  emitente.cod-emitente = tit_ap.cdn_fornecedor NO-ERROR.
        ASSIGN c-nome-matriz = IF AVAIL emitente THEN emitente.nome-matriz ELSE "".

        FIND FIRST emitente NO-LOCK
            WHERE  emitente.nome-abrev = c-nome-matriz NO-ERROR.

        FIND FIRST tt-cliente EXCLUSIVE-LOCK
            WHERE  tt-cliente.cod-cliente = emitente.cod-emitente NO-ERROR.
        IF  NOT AVAIL tt-cliente THEN DO:
            CREATE tt-cliente.
            ASSIGN tt-cliente.cod-cliente = emitente.cod-emitente
                   tt-cliente.nom-cliente = emitente.nome-emit.

            /* Cria a temp-table de valores com todos os anos da faixa */
            DO  i-ano = YEAR(tt-param.dt-inicial) TO YEAR(tt-param.dt-final):
                CREATE tt-valores-cli.
                ASSIGN tt-valores-cli.cod-cliente = tt-cliente.cod-cliente
                       tt-valores-cli.ano         = i-ano.
            END.
        END.

        ASSIGN i-cli-antig = tit_ap.cdn_fornecedor
               i-ano-antig = 0.
    END.


    IF  YEAR(tit_ap.dat_vencto_tit_ap) <> i-ano-antig THEN DO:
        /* Busca o registro do cliente para o ano corrente */
        FIND FIRST tt-valores-cli EXCLUSIVE-LOCK
            WHERE  tt-valores-cli.cod-cliente = tt-cliente.cod-cliente
            AND    tt-valores-cli.ano         = YEAR(tit_ap.dat_vencto_tit_ap) NO-ERROR.

        ASSIGN i-ano-antig = YEAR(tit_ap.dat_vencto_tit_ap).
    END.


    FOR EACH  val_tit_ap NO-LOCK
        WHERE val_tit_ap.cod_estab     = tit_ap.cod_estab
        AND   val_tit_ap.num_id_tit_ap = tit_ap.num_id_tit_ap:
        IF  val_tit_ap.cod_unid_negoc < tt-param.cod-unid-negoc-ini OR
            val_tit_ap.cod_unid_negoc > tt-param.cod-unid-negoc-fim THEN
            NEXT.

        ASSIGN tt-valores-cli.tot-ano-ap = tt-valores-cli.tot-ano-ap + val_tit_ap.val_sdo_tit_ap.
    END.
END.


IF  VALID-HANDLE(h-acomp) THEN
    RUN pi-finalizar IN h-acomp.

RETURN "OK":U.
