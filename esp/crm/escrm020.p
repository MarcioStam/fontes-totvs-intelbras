/*********************************************************************************
** Programa: esp/crm/escrm020.p
** Vers∆o..: 1.00
** Data....: 08/11/2010
** Autor...: Estevan KrÅger - Exponencial TI
** Obs.....: Relat¢rio do Portal B2B.
**           C¢pia da procedure "process-zoom-pedidos", programa "soap-b2b-ped-venda"
**           Listagem dos Pedidos de um Cliente
*********************************************************************************/

CREATE WIDGET-POOL.


/*--- Definiá∆o das Temp-Tables ---*/
DEFINE TEMP-TABLE tt-repres NO-UNDO
   FIELD cod-rep        LIKE repres.cod-rep
   FIELD no-ab-reppri   LIKE repres.nome-abrev
   INDEX ch-pri         AS PRIMARY UNIQUE cod-rep.

DEFINE TEMP-TABLE tt-ped-venda NO-UNDO
    FIELD cod-emitente     LIKE emitente.cod-emitente
    FIELD nome-emit        LIKE emitente.nome-emit
    FIELD nome-abrev       LIKE ped-venda.nome-abrev
    FIELD nr-pedcli        LIKE ped-venda.nr-pedcli
    FIELD cod-estabel      LIKE ped-venda.cod-estabel
    FIELD cod-sit-ped      LIKE ped-venda.cod-sit-ped
    FIELD cod-sit-aval     LIKE ped-venda.cod-sit-aval
    FIELD desc-cancela     LIKE ped-venda.desc-cancela
    FIELD dt-entrega       LIKE ped-venda.dt-entrega
    FIELD dt-emissao       LIKE ped-venda.dt-emissao
    FIELD no-ab-reppri     LIKE ped-venda.no-ab-reppri
    FIELD vl-liq-ped       LIKE ped-venda.vl-liq-ped
    FIELD vl-tot-ped       LIKE ped-venda.vl-tot-ped
    FIELD desc-cond-pagto  LIKE cond-pagto.descricao
    INDEX ch-pri           AS PRIMARY nome-abrev nr-pedcli.



/*--- Definiá∆o das Vari†veis ---*/
DEFINE VARIABLE hQuery                 AS HANDLE      NO-UNDO.
DEFINE VARIABLE hBuffer                AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-where                AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-sort                 AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-cond-pagto-descricao AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-busca-por-cliente    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-cod-sit-ped          AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-nr-pedcli            AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i                      AS INTEGER     NO-UNDO.
DEFINE VARIABLE j                      AS INTEGER     NO-UNDO.
DEFINE VARIABLE l-nr-pedcli            AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-emite-duplic         AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-todos-emitentes      AS LOGICAL     NO-UNDO.




/*--- ParÉmetros do Programa ---*/
DEFINE INPUT  PARAMETER p-cod-rep      AS CHARACTER   NO-UNDO.
DEFINE INPUT  PARAMETER p-cod-emitente AS INTEGER     NO-UNDO.
DEFINE INPUT  PARAMETER p-dt-inicial   AS DATE        NO-UNDO.
DEFINE INPUT  PARAMETER p-dt-final     AS DATE        NO-UNDO.
DEFINE INPUT  PARAMETER p-nr-pedcli    AS CHARACTER   NO-UNDO.
DEFINE INPUT  PARAMETER p-cod-sit-ped  AS INTEGER     NO-UNDO.
DEFINE INPUT  PARAMETER p-emite-duplic AS LOGICAL     NO-UNDO.
DEFINE INPUT  PARAMETER p-cod-estabel  AS CHARACTER   NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR tt-ped-venda.



/*--- Bloco Principal ---*/
ASSIGN c-nr-pedcli    = p-nr-pedcli
       c-cod-sit-ped  = STRING(p-cod-sit-ped)
       l-emite-duplic = p-emite-duplic.


/** Ver quais os representantes que devem ser pesquisados **/
IF  p-cod-rep <> "0" AND p-cod-rep <> "?" THEN DO:
    DO j = 1 TO NUM-ENTRIES(p-cod-rep, ";"):
        FIND FIRST repres NO-LOCK
            WHERE repres.cod-rep = INT(ENTRY(j, p-cod-rep, ";")) NO-ERROR.
        IF AVAILABLE (repres) THEN DO:
            CREATE tt-repres.
            ASSIGN tt-repres.cod-rep      = repres.cod-rep
                   tt-repres.no-ab-reppri = repres.nome-abrev.
        END.
    END.
END.
ELSE DO:
    /** Se o cara nao tem nenhum representante associado, vai todo mundo **/
    FOR EACH repres FIELDS (cod-rep nome-abrev) NO-LOCK:
        CREATE tt-repres.
        ASSIGN tt-repres.cod-rep      = repres.cod-rep
               tt-repres.no-ab-reppri = repres.nome-abrev.
    END.
END.


ASSIGN l-todos-emitentes = ((p-cod-emitente = 0) OR (p-cod-emitente = ?)).

IF (c-nr-pedcli <> ?) AND (c-nr-pedcli <> "") AND (c-nr-pedcli <> "?") THEN
    ASSIGN l-nr-pedcli = YES.
ELSE
    ASSIGN l-nr-pedcli = NO.


CREATE QUERY hQuery.

/* Quando informar um cliente, busca somente essa informaá∆o.
   Caso contr†rio, faz a busca pelos representantes (melhora de performance) */
IF  NOT l-todos-emitentes THEN DO:
    hQuery:SET-BUFFERS(BUFFER emitente:HANDLE, BUFFER ped-venda:HANDLE, BUFFER natur-oper:HANDLE, BUFFER moeda:HANDLE, BUFFER tt-repres:HANDLE).

    ASSIGN c-where = "EACH  emitente FIELDS (cod-emitente nome-abrev nome-emit) NO-LOCK " +
                     "WHERE emitente.cod-emitente = " + STRING(p-cod-emitente).
END.
ELSE DO:
    ASSIGN c-where = "EACH tt-repres NO-LOCK ".

    IF  l-nr-pedcli THEN DO:
        hQuery:SET-BUFFERS(BUFFER tt-repres:HANDLE,BUFFER ped-venda:HANDLE, BUFFER emitente:HANDLE, BUFFER natur-oper:HANDLE, BUFFER moeda:HANDLE).

/*         ASSIGN c-where = c-where + ", EACH emitente FIELDS (cod-emitente nome-abrev nome-emit) NO-LOCK WHERE emitente.cod-rep = tt-repres.cod-rep". */
    END.
    ELSE
        hQuery:SET-BUFFERS(BUFFER tt-repres:HANDLE,BUFFER ped-venda:HANDLE, BUFFER emitente:HANDLE, BUFFER natur-oper:HANDLE, BUFFER moeda:HANDLE).
END.


ASSIGN c-where = c-where + ",EACH ped-venda FIELDS (cod-priori cod-estabel nat-operacao nr-pedcli dt-emissao desc-cancela no-ab-reppri cod-sit-ped nome-abrev cod-sit-aval cod-cond-pag dt-entrega vl-liq-ped vl-tot-ped mo-codigo) NO-LOCK ".


IF (l-nr-pedcli) THEN DO:

    ASSIGN c-where = c-where + "WHERE ped-venda.nr-pedcli = ~"" + c-nr-pedcli + "~" ".
    
    IF  l-todos-emitentes THEN
        ASSIGN c-where = c-where + "AND ped-venda.no-ab-reppri = tt-repres.no-ab-reppri ".
    ELSE
        ASSIGN c-where = c-where + "AND ped-venda.nome-abrev = emitente.nome-abrev ".
END.
ELSE DO:
    ASSIGN c-where = c-where + "USE-INDEX ch-pre-fat ".


/* IF (l-nr-pedcli) THEN                                                                                                                 */
/*     ASSIGN c-where = c-where + "WHERE ped-venda.nome-abrev = emitente.nome-abrev AND ped-venda.nr-pedcli = ~"" + c-nr-pedcli + "~" ". */
/* ELSE DO:                                                                                                                              */
/*     ASSIGN c-where = c-where + "USE-INDEX ch-pre-fat ".                                                                               */

/*     ASSIGN c-where = c-where + "USE-INDEX ch-pre-fat " +                                   */
/*                                "WHERE ped-venda.cod-estabel = ~"" + p-cod-estabel + "~" ". */

/*     IF  l-todos-emitentes THEN                                                             */
/*         ASSIGN c-where = c-where + "AND ped-venda.no-ab-reppri = tt-repres.no-ab-reppri ". */
/*     ELSE                                                                                   */
/*         ASSIGN c-where = c-where + "AND ped-venda.nome-abrev = emitente.nome-abrev ".      */

    IF  l-todos-emitentes THEN
        ASSIGN c-where = c-where + "WHERE ped-venda.no-ab-reppri = tt-repres.no-ab-reppri ".
    ELSE
        ASSIGN c-where = c-where + "WHERE ped-venda.nome-abrev = emitente.nome-abrev ".

    ASSIGN c-where = c-where + "AND ped-venda.dt-entrega >= " + STRING(p-dt-inicial) + " " +
                               "AND ped-venda.dt-entrega <= " + STRING(p-dt-final) + " ".

    IF  NOT (l-emite-duplic) THEN
        ASSIGN c-where = c-where + "AND ped-venda.tp-pedido < '50' ".

    IF (c-cod-sit-ped <> ? AND c-cod-sit-ped <> "0") THEN
        ASSIGN c-where = c-where + "AND ped-venda.cod-sit-ped = " + c-cod-sit-ped + " ".

/*     IF  l-todos-emitentes THEN                                                                             */
/*         ASSIGN c-where = c-where + ",FIRST emitente FIELDS (cod-emitente nome-abrev nome-emit) NO-LOCK " + */
/*                                    " WHERE emitente.nome-abrev = ped-venda.nome-abrev ".                   */
END.

IF  l-todos-emitentes THEN
    ASSIGN c-where = c-where + ",FIRST emitente FIELDS (cod-emitente nome-abrev nome-emit) NO-LOCK " +
                                " WHERE emitente.nome-abrev = ped-venda.nome-abrev ".

ASSIGN c-where = c-where + ", FIRST natur-oper FIELDS (emite-duplic) NO-LOCK WHERE natur-oper.nat-operacao = ped-venda.nat-operacao ".

/** Considera apenas quando o numero do pedido nao for informado **/
IF  NOT (l-nr-pedcli) THEN
    IF  (l-emite-duplic) THEN
        ASSIGN c-where = c-where + " AND natur-oper.emite-duplic ".
    ELSE
        ASSIGN c-where = c-where + " AND NOT natur-oper.emite-duplic ".


ASSIGN c-where = c-where + ", FIRST moeda NO-LOCK WHERE moeda.mo-codigo = ped-venda.mo-codigo ".

IF  NOT l-todos-emitentes THEN
    ASSIGN c-where = c-where + ", FIRST tt-repres NO-LOCK WHERE tt-repres.no-ab-reppri = ped-venda.no-ab-reppri ".

ASSIGN c-sort = " BY tt-repres.no-ab-reppri BY ped-venda.dt-emissao BY ped-venda.dt-entrega BY ped-venda.nr-pedcli BY ped-venda.cod-sit-ped BY ped-venda.cod-sit-aval ".


IF (hQuery:QUERY-PREPARE("PRESELECT " + c-where + c-sort) = FALSE) THEN
    RETURN "NOK":U.

hQuery:QUERY-OPEN.


IF (hQuery:NUM-RESULTS <> 0) THEN DO:
    REPEAT:
        hQuery:GET-NEXT.
        IF (hQuery:QUERY-OFF-END) THEN
            LEAVE.

        IF p-cod-estabel = "101" OR p-cod-estabel = "104" THEN DO:
            IF (ped-venda.cod-estabel <> "101") AND (ped-venda.cod-estabel <> "104") THEN NEXT.
        END.
        ELSE IF (ped-venda.cod-estabel <> p-cod-estabel) THEN NEXT.

        IF ped-venda.cod-priori = 44 THEN NEXT.

/*         /** Retirado da query para usar outro °ndice **/ */
/*         IF (ped-venda.cod-estabel <> p-cod-estabel) THEN */
/*             NEXT.                                        */

        /** Pega a descricao da condicao de pagamento **/
        FIND FIRST cond-pagto NO-LOCK
            WHERE  cond-pagto.cod-cond-pag = ped-venda.cod-cond-pag NO-ERROR.
        IF  AVAIL  cond-pagto THEN
            ASSIGN c-cond-pagto-descricao = cond-pagto.descricao.
        ELSE
            ASSIGN c-cond-pagto-descricao = "Especial".

        CREATE tt-ped-venda.
        ASSIGN tt-ped-venda.cod-emitente    = emitente.cod-emitente
               tt-ped-venda.nome-emit       = emitente.nome-emit
               tt-ped-venda.nome-abrev      = ped-venda.nome-abrev
               tt-ped-venda.nr-pedcli       = ped-venda.nr-pedcli
               tt-ped-venda.cod-estabel     = ped-venda.cod-estabel
               tt-ped-venda.cod-sit-ped     = ped-venda.cod-sit-ped
               tt-ped-venda.cod-sit-aval    = ped-venda.cod-sit-aval
               tt-ped-venda.desc-cancela    = ped-venda.desc-cancela
               tt-ped-venda.dt-entrega      = ped-venda.dt-entrega
               tt-ped-venda.dt-emissao      = ped-venda.dt-emissao
               tt-ped-venda.no-ab-reppri    = ped-venda.no-ab-reppri
               tt-ped-venda.vl-liq-ped      = ped-venda.vl-liq-ped
               tt-ped-venda.vl-tot-ped      = ped-venda.vl-tot-ped
               tt-ped-venda.desc-cond-pagto = c-cond-pagto-descricao.
    END.
END.

DELETE OBJECT hQuery.


DELETE WIDGET-POOL.
RETURN "OK":U.
