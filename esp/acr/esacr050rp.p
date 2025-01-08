/*********************************************************************************
** Programa: esp/acr/esacr050rp.p
** VersÆo..: 1.00
** Data....: 19/01/2012
** Autor...: Estevan Krger - Exponencial TI
** Obs.....: Programa de relat¢rio para listagem dos Clientes que possuem
**           cartÆo Intelbras Clube
*********************************************************************************/
{include/i-prgvrs.i ESFTP078RP 2.00.00.001}  /*** 010001 ***/
  

/*--- Defini‡Æo das Vari veis Locais ---*/
DEFINE VARIABLE h-acomp             AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-destino           AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-classificacao     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-nome-emit         AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-email             AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-pedidos           AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-atendente         AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-cod-emit          AS INTEGER     NO-UNDO.
DEFINE VARIABLE de-saldo-alocado    AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-val-limite-total AS DECIMAL     NO-UNDO.

{include/i-rpvar.i}



/*--- Defini‡Æo de Temp-Tables e Buffers ---*/
DEFINE BUFFER bf-emitente FOR emitente.

{esp/acr/esacr050.i}




/*--- Defini‡Æo dos Parƒmetros de Entrada ---*/
DEFINE INPUT  PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT  PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

FIND FIRST tt-param NO-ERROR.




/*--- Defini‡Æo das Frames ---*/
/* Include com a defini‡Æo da frame de cabe‡alho e rodap‚ */
{include/i-rpcab.i}



/*--- Inicializa‡Æo das Informa‡äes ---*/
{include/i-rpout.i}

IF  NOT VALID-HANDLE(h-acomp) THEN
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.



/*--- Bloco Principal ---*/
IF  VALID-HANDLE(h-acomp) THEN
    RUN pi-inicializar IN h-acomp (INPUT "Imprimindo Clientes").

PUT UNFORMATTED "C¢d Emit;Nome Emit;Limite Disp;Limite Total;E-mail;Saldo Alocado;Atraso SC;Pedidos" SKIP.

FOR EACH  int-emitente-supcard NO-LOCK
    WHERE int-emitente-supcard.raiz-cnpj    >= tt-param.raiz-cnpj-ini
    AND   int-emitente-supcard.raiz-cnpj    <= tt-param.raiz-cnpj-fim
    AND   int-emitente-supcard.dat-avaliacao = tt-param.dat-avaliacao:

    IF  VALID-HANDLE(h-acomp) THEN
        RUN pi-acompanhar IN h-acomp (INPUT "Raiz CNPJ - " + int-emitente-supcard.raiz-cnpj).


    ASSIGN c-pedidos        = ""
           de-saldo-alocado = 0.
    FOR EACH  int-ped-aloc-supcard NO-LOCK USE-INDEX idx-raiz-cnpj
        WHERE int-ped-aloc-supcard.raiz-cnpj        = int-emitente-supcard.raiz-cnpj
        AND   int-ped-aloc-supcard.val-item-alocado > 0
        BY    int-ped-aloc-supcard.dat-movto:

        FIND FIRST ped-venda NO-LOCK
            WHERE  ped-venda.nr-pedcli  = int-ped-aloc-supcard.nr-pedcli
            AND    ped-venda.nome-abrev = int-ped-aloc-supcard.nome-abrev NO-ERROR.
        IF  AVAIL  ped-venda THEN DO:
            FIND FIRST atendente NO-LOCK
                WHERE  atendente.cd-oper = INT(ped-venda.tp-pedido) NO-ERROR.
            ASSIGN c-atendente = IF AVAIL atendente THEN atendente.nm-oper ELSE "".
        END.
        ELSE
            ASSIGN c-atendente = "".

            
        ASSIGN c-pedidos        = c-pedidos + int-ped-aloc-supcard.nr-pedcli + " - " + STRING(int-ped-aloc-supcard.dat-movto) + " - " + c-atendente + "  /  "
               de-saldo-alocado = de-saldo-alocado + int-ped-aloc-supcard.val-item-alocado.
    END.

    /* Se o parametro estiver marcado, s¢ exibe os clientes que tem Saldo Alocado */
    IF  tt-param.clientes-pend AND
        de-saldo-alocado = 0   THEN
        NEXT.


    ASSIGN de-val-limite-total = int-emitente-supcard.val-limite + int-emitente-supcard.val-limite-utilizado.

    FIND FIRST bf-emitente NO-LOCK
        WHERE  bf-emitente.cgc BEGINS int-emitente-supcard.raiz-cnpj NO-ERROR.
    IF  NOT AVAIL bf-emitente THEN
        NEXT.

    FIND FIRST emitente NO-LOCK
        WHERE  emitente.nome-abrev = bf-emitente.nome-matriz NO-ERROR.

    ASSIGN i-cod-emit  = bf-emitente.cod-emitente
           c-nome-emit = IF AVAIL emitente THEN emitente.nome-emit ELSE ""
           c-email     = IF AVAIL emitente THEN emitente.e-mail    ELSE "".

    PUT UNFORMATTED i-cod-emit                              ";"
                    c-nome-emit                             ";"
                    int-emitente-supcard.val-limite         ";"
                    de-val-limite-total                     ";"
                    c-email                                 ";"
                    de-saldo-alocado                        ";"
                    int-emitente-supcard.qtd-dias-atraso-sc ";"
                    c-pedidos SKIP.
END.



/*--- Finaliza‡Æo das Informa‡äes ---*/
{include/i-rpclo.i}

IF  VALID-HANDLE(h-acomp) THEN
    RUN pi-finalizar IN h-acomp.

RETURN "OK":U.



