/*----------------------------------------------------------------------
**  Programa..: esp/crm/escrm101.p
**  Autor.....: Felipe Braun Azambuja
**  Data......: Outubro/2010 - Desenvolvimento
**  Descricao.: Relat¢rio faturamento por estabelecimento - B2B/CRM
-----------------------------------------------------------------------*/

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Local Temp-Table Definitions ---                                     */

DEFINE TEMP-TABLE tt-repres NO-UNDO
    FIELD cod-rep      LIKE repres.cod-rep
    FIELD no-ab-reppri LIKE repres.nome-abrev
    INDEX idx_pri IS PRIMARY UNIQUE
        cod-rep
    INDEX idx_ab_rep
        no-ab-reppri.

DEFINE TEMP-TABLE tt-unid_negoc NO-UNDO
    FIELD cod_unid_negoc LIKE unid_negoc.cod_unid_negoc
    FIELD des_unid_negoc LIKE unid_negoc.des_unid_negoc
    INDEX idx_pri IS PRIMARY UNIQUE
        cod_unid_negoc
    INDEX idx_des_unid_negoc
        des_unid_negoc.

DEFINE TEMP-TABLE tt-faturamento NO-UNDO
    FIELD cod-estabel    LIKE nota-fiscal.cod-estabel
    FIELD cod_unid_negoc LIKE unid_negoc.cod_unid_negoc
    FIELD des_unid_negoc LIKE unid_negoc.des_unid_negoc
    FIELD cod-gerente    LIKE gerente.cod-gerente
    FIELD nome-gerente   LIKE gerente.nome
    FIELD cod-rep        LIKE repres.cod-rep
    FIELD nome-abrev     LIKE repres.nome-abrev
    FIELD vl-cota        LIKE meta-rep.valor
    FIELD vl-faturado    LIKE it-nota-fisc.vl-merc-liq
    FIELD vl-carteira    AS DECIMAL
    FIELD vl-devolvido   AS DECIMAL
    FIELD pc-cota        AS DECIMAL
    FIELD vl-orcamento   LIKE faturamento.vl-fat-orc
    INDEX idx_pri IS PRIMARY UNIQUE
        cod-estabel
        cod_unid_negoc
        cod-gerente
        cod-rep.

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE dt-cont           AS DATE                        NO-UNDO.
DEFINE VARIABLE i-cont            AS INTEGER                     NO-UNDO.
DEFINE VARIABLE i-cod-gerente     LIKE repres-un-ger.cod-gerente NO-UNDO.
DEFINE VARIABLE v-cotacao         AS DECIMAL                     NO-UNDO.
DEFINE VARIABLE de-perc-cota      AS DECIMAL                     NO-UNDO.
DEFINE VARIABLE v-vl-fat-orc      LIKE faturamento.vl-fat-orc    NO-UNDO.
DEFINE VARIABLE dt-inicial-aux    AS DATE                        NO-UNDO.
DEFINE VARIABLE v-cod-estabel-aux LIKE estabelec.cod-estabel     NO-UNDO.
DEFINE VARIABLE l-todas-un        AS LOGICAL                     NO-UNDO INITIAL NO.
DEFINE VARIABLE h-query           AS HANDLE                      NO-UNDO.
DEFINE VARIABLE cWhere            AS CHARACTER                   NO-UNDO.
DEFINE VARIABLE c-cod-unid-negoc  AS CHARACTER                   NO-UNDO.

/* Parameters Definitions ---                                           */

DEFINE INPUT  PARAMETER p-cod-estabel    LIKE estabelec.cod-estabel NO-UNDO.
DEFINE INPUT  PARAMETER p-cod-rep        AS CHARACTER               NO-UNDO. /* Deve ter 1 ou mais c¢digos de representantes para selecionar representante(s) espec°fico(s) ou nenhum para selecionar todos os representantes */
DEFINE INPUT  PARAMETER p-des_unid_negoc AS CHARACTER               NO-UNDO. /* ê utilizada a descriá∆o da Unidade de Neg¢cio pois o CRM trata este valor como chave da tabela */
DEFINE INPUT  PARAMETER p-dt-inicial     AS DATE                    NO-UNDO.
DEFINE INPUT  PARAMETER p-dt-final       AS DATE                    NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR tt-faturamento.


/* ***************************  Main Block  *************************** */

IF p-cod-estabel = "101":U OR
   p-cod-estabel = "104":U THEN
    ASSIGN v-cod-estabel-aux = IF p-cod-estabel = "101":U THEN "104":U ELSE "101":U.
ELSE
    ASSIGN v-cod-estabel-aux = p-cod-estabel.

/** Ver quais os representantes que devem ser pesquisados **/
IF p-cod-rep <> "0":U AND
   p-cod-rep <> "?":U AND
   p-cod-rep <> ?     AND
   p-cod-rep <> "":U  THEN DO:
    DO i-cont = 1 TO NUM-ENTRIES(p-cod-rep, ";":U):
        FIND FIRST repres
             WHERE repres.cod-rep = INTEGER(ENTRY(i-cont, p-cod-rep, ";":U)) NO-LOCK NO-ERROR.
        IF AVAILABLE repres THEN DO:
            FIND FIRST tt-repres 
                 WHERE tt-repres.cod-rep = repres.cod-rep NO-ERROR.
            IF NOT AVAIL tt-repres THEN DO:
               CREATE tt-repres.
               ASSIGN tt-repres.cod-rep      = repres.cod-rep
                      tt-repres.no-ab-reppri = repres.nome-abrev.
            END.
        END.
    END.
END.
ELSE DO:
    /** Se o cara nao tem nenhum representante associado, vai todo mundo **/
    FOR EACH repres NO-LOCK:
        CREATE tt-repres.
        ASSIGN tt-repres.cod-rep      = repres.cod-rep
               tt-repres.no-ab-reppri = repres.nome-abrev.
    END.
END.

IF p-des_unid_negoc <> "0":U AND
   p-des_unid_negoc <> "?":U AND
   p-des_unid_negoc <> ?     AND
   p-des_unid_negoc <> "":U  THEN DO:
    DO i-cont = 1 TO NUM-ENTRIES(p-des_unid_negoc, ";":U):
        FIND FIRST unid_negoc
            WHERE unid_negoc.des_unid_negoc = TRIM(ENTRY(i-cont, p-des_unid_negoc, ";":U)) NO-LOCK NO-ERROR.

        IF AVAILABLE unid_negoc THEN DO:
            CREATE tt-unid_negoc.
            ASSIGN tt-unid_negoc.cod_unid_negoc = unid_negoc.cod_unid_negoc
                   tt-unid_negoc.des_unid_negoc = unid_negoc.des_unid_negoc.
        END.
    END.

    ASSIGN l-todas-un = NO.
END.
ELSE
    ASSIGN l-todas-un = YES.

EMPTY TEMP-TABLE tt-faturamento.

CREATE QUERY h-query.

ASSIGN cWhere = "FOR ":U.

IF l-todas-un THEN
    h-query:SET-BUFFERS(BUFFER tt-repres:HANDLE, BUFFER meta-rep:HANDLE).
ELSE DO:
    h-query:SET-BUFFERS(BUFFER tt-unid_negoc:HANDLE, BUFFER tt-repres:HANDLE, BUFFER meta-rep:HANDLE).

    ASSIGN cWhere = cWhere + " EACH tt-unid_negoc, ":U.
END.

ASSIGN cWhere = cWhere + " EACH tt-repres, ":U +
                         " EACH meta-rep USE-INDEX ch-cota NO-LOCK ":U.
 
IF p-cod-estabel = v-cod-estabel-aux THEN
    ASSIGN cWhere = cWhere + " WHERE  meta-rep.cod-estabel  = ~"":U + p-cod-estabel + "~" ":U.
ELSE
    ASSIGN cWhere = cWhere + " WHERE (meta-rep.cod-estabel  = ~"":U + p-cod-estabel + "~" ":U +
                             "    OR  meta-rep.cod-estabel  = ~"":U + v-cod-estabel-aux + "~") ":U.

IF NOT l-todas-un THEN
    ASSIGN cWhere = cWhere + "   AND  meta-rep.cod-diretoria      = tt-unid_negoc.cod_unid_negoc ":U.

ASSIGN cWhere = cWhere + "   AND  meta-rep.cod-rep      = tt-repres.cod-rep ":U.

IF YEAR(p-dt-inicial)  = YEAR(p-dt-final)  AND
   MONTH(p-dt-inicial) = MONTH(p-dt-final) THEN
    ASSIGN cWhere = cWhere + "   AND  meta-rep.periodo      = ~"":U + STRING(YEAR(p-dt-inicial), "9999":U) + STRING(MONTH(p-dt-inicial), "99":U) + "~" ":U.
ELSE
    ASSIGN cWhere = cWhere + "   AND  meta-rep.periodo     >= ~"":U + STRING(YEAR(p-dt-inicial), "9999":U) + STRING(MONTH(p-dt-inicial), "99":U) + "~" ":U +
                             "   AND  meta-rep.periodo     <= ~"":U + STRING(YEAR(p-dt-final),   "9999":U) + STRING(MONTH(p-dt-final),   "99":U) + "~" ":U.

h-query:QUERY-PREPARE(cWhere).
h-query:QUERY-OPEN().
h-query:GET-FIRST().

DO WHILE NOT h-query:QUERY-OFF-END:
    FIND FIRST repres-un-ger
        WHERE repres-un-ger.cod-rep       = meta-rep.cod-rep
          AND repres-un-ger.cd-unid-negoc = meta-rep.cod-diretoria NO-LOCK NO-ERROR.

    ASSIGN i-cod-gerente = IF AVAILABLE repres-un-ger THEN repres-un-ger.cod-gerente ELSE 0.

    FIND FIRST tt-faturamento
        WHERE tt-faturamento.cod-estabel    = meta-rep.cod-estabel
          AND tt-faturamento.cod_unid_negoc = meta-rep.cod-diretoria
          AND tt-faturamento.cod-gerente    = i-cod-gerente
          AND tt-faturamento.cod-rep        = meta-rep.cod-rep NO-ERROR.

    IF NOT AVAILABLE tt-faturamento THEN DO:
        FIND FIRST unid_negoc
            WHERE unid_negoc.cod_unid_negoc = meta-rep.cod-diretoria NO-LOCK NO-ERROR.

        CREATE tt-faturamento.
        ASSIGN tt-faturamento.cod-estabel    = meta-rep.cod-estabel
               tt-faturamento.cod_unid_negoc = meta-rep.cod-diretoria
               tt-faturamento.cod-gerente    = i-cod-gerente
               tt-faturamento.cod-rep        = meta-rep.cod-rep
               tt-faturamento.des_unid_negoc = IF AVAILABLE unid_negoc THEN unid_negoc.des_unid_negoc ELSE "":U.

        FIND FIRST gerente
            WHERE gerente.cod-gerente = tt-faturamento.cod-gerente NO-LOCK NO-ERROR.

        ASSIGN tt-faturamento.nome-gerente = IF AVAILABLE gerente THEN gerente.nome ELSE "":U.
    END.

    ASSIGN tt-faturamento.vl-cota = tt-faturamento.vl-cota + meta-rep.valor.

    h-query:GET-NEXT().
END.

h-query:QUERY-CLOSE().

DELETE WIDGET h-query.

ASSIGN h-query = ?.

/** Faturamento **/
DO dt-cont = p-dt-inicial TO p-dt-final:
    FOR EACH nota-fiscal USE-INDEX nfftrm-20 NO-LOCK
        WHERE  nota-fiscal.dt-emis-nota = dt-cont
          AND (nota-fiscal.cod-estabel  = p-cod-estabel
           OR  nota-fiscal.cod-estabel  = v-cod-estabel-aux)
          AND  nota-fiscal.dt-cancel    = ?
          AND  nota-fiscal.emite-duplic = YES,
        FIRST tt-repres
        WHERE tt-repres.no-ab-reppri = nota-fiscal.no-ab-reppri,
        FIRST natur-oper USE-INDEX natureza NO-LOCK
        WHERE natur-oper.nat-operacao = nota-fiscal.nat-operacao
          AND natur-oper.atual-estat  = YES,
        EACH it-nota-fisc OF nota-fiscal NO-LOCK:

        FIND FIRST item-uni-estab
            WHERE item-uni-estab.it-codigo   = it-nota-fisc.it-codigo
              AND item-uni-estab.cod-estabel = nota-fiscal.cod-estabel NO-LOCK NO-ERROR.

        IF NOT l-todas-un THEN DO:
            IF NOT AVAILABLE item-uni-estab                                                     OR
               NOT CAN-FIND(FIRST tt-unid_negoc
                            WHERE tt-unid_negoc.cod_unid_negoc = item-uni-estab.cod-unid-negoc) THEN NEXT.
        END.

        ASSIGN c-cod-unid-negoc = IF AVAILABLE item-uni-estab THEN item-uni-estab.cod-unid-negoc ELSE "INV":U.

        IF NOT it-nota-fisc.vl-merc-liq > 0 THEN NEXT.

        FIND FIRST repres-un-ger
            WHERE repres-un-ger.cod-rep       = tt-repres.cod-rep
              AND repres-un-ger.cd-unid-negoc = c-cod-unid-negoc NO-LOCK NO-ERROR.

        ASSIGN i-cod-gerente = IF AVAILABLE repres-un-ger THEN repres-un-ger.cod-gerente ELSE 0.

        FIND FIRST tt-faturamento
            WHERE tt-faturamento.cod-estabel    = nota-fiscal.cod-estabel
              AND tt-faturamento.cod_unid_negoc = c-cod-unid-negoc
              AND tt-faturamento.cod-gerente    = i-cod-gerente
              AND tt-faturamento.cod-rep        = tt-repres.cod-rep NO-ERROR.

        IF NOT AVAILABLE tt-faturamento THEN DO:
            FIND FIRST unid_negoc
                WHERE unid_negoc.cod_unid_negoc = c-cod-unid-negoc NO-LOCK NO-ERROR.

            CREATE tt-faturamento.
            ASSIGN tt-faturamento.cod-estabel    = nota-fiscal.cod-estabel
                   tt-faturamento.cod_unid_negoc = c-cod-unid-negoc
                   tt-faturamento.cod-gerente    = i-cod-gerente
                   tt-faturamento.cod-rep        = tt-repres.cod-rep
                   tt-faturamento.des_unid_negoc = IF AVAILABLE unid_negoc THEN unid_negoc.des_unid_negoc ELSE "":U.

            FIND FIRST gerente
                WHERE gerente.cod-gerente = tt-faturamento.cod-gerente NO-LOCK NO-ERROR.

            ASSIGN tt-faturamento.nome-gerente = IF AVAILABLE gerente THEN gerente.nome ELSE "":U.
        END.

        ASSIGN tt-faturamento.vl-faturado = tt-faturamento.vl-faturado + it-nota-fisc.vl-merc-liq.
    END.
END.

/* Se Pesquisar por mes atual ou anterior busca os pedidos anteriores */
IF MONTH(p-dt-final) <= MONTH(TODAY) AND YEAR(p-dt-final) <= YEAR(TODAY) THEN
    ASSIGN dt-inicial-aux = ADD-INTERVAL(TODAY, -7, "MONTH":U).
ELSE 
    ASSIGN dt-inicial-aux = p-dt-inicial.

/** Carteira **/
/** Pesquisa por pedidos apenas se o periodo a ser exibido esta no mes atual ou pra frente **/
DO dt-cont = dt-inicial-aux TO p-dt-final:
    FOR EACH ped-item USE-INDEX peditem-09 NO-LOCK
        WHERE ped-item.dt-entrega    = dt-cont
          AND ped-item.cod-sit-item <> 3
          AND ped-item.cod-sit-item <> 6,
        FIRST ped-venda OF ped-item USE-INDEX ch-pedido NO-LOCK
        WHERE ped-venda.cod-sit-ped <= 5,
        FIRST tt-repres
        WHERE tt-repres.no-ab-reppri = ped-venda.no-ab-reppri,
        FIRST natur-oper USE-INDEX natureza NO-LOCK
        WHERE natur-oper.nat-operacao = ped-venda.nat-operacao
          AND natur-oper.atual-estat  = YES:

        IF ped-item.ind-componen = 3 THEN NEXT.

        FIND FIRST item-uni-estab
            WHERE item-uni-estab.it-codigo   = ped-item.it-codigo
              AND item-uni-estab.cod-estabel = ped-venda.cod-estabel NO-LOCK NO-ERROR.

        IF NOT l-todas-un THEN DO:
            IF NOT AVAILABLE item-uni-estab                                                     OR
               NOT CAN-FIND(FIRST tt-unid_negoc
                            WHERE tt-unid_negoc.cod_unid_negoc = item-uni-estab.cod-unid-negoc) THEN NEXT.
        END.

        ASSIGN c-cod-unid-negoc = IF AVAILABLE item-uni-estab THEN item-uni-estab.cod-unid-negoc ELSE "INV":U.

        IF p-cod-estabel = "101":U OR
           p-cod-estabel = "104":U THEN DO:
            IF ped-venda.cod-estabel <> "101":U AND
               ped-venda.cod-estabel <> "104":U THEN NEXT.
        END.
        ELSE
            IF p-cod-estabel <> ped-venda.cod-estabel THEN NEXT.

        /** Ignora oráamentos Maxcom **/
        IF ((ped-venda.cod-estabel = "301":U  OR
             ped-venda.cod-estabel = "103":U) AND
             ped-venda.cod-priori  = 99)      OR
             ped-venda.cod-priori  = 44       THEN NEXT.

        FIND FIRST cotacao
            WHERE cotacao.mo-codigo   = ped-venda.mo-codigo
              AND cotacao.ano-periodo = STRING(YEAR(TODAY), "9999":U) + STRING(MONTH(TODAY), "99":U) NO-LOCK NO-ERROR.

        IF AVAILABLE cotacao                AND
           cotacao.cotacao[DAY(TODAY)] <> 0 THEN
            ASSIGN v-cotacao = cotacao.cotacao[DAY(TODAY)].
        ELSE
            ASSIGN v-cotacao = 1.

        FIND FIRST repres-un-ger
            WHERE repres-un-ger.cod-rep       = tt-repres.cod-rep
              AND repres-un-ger.cd-unid-negoc = c-cod-unid-negoc NO-LOCK NO-ERROR.

        ASSIGN i-cod-gerente = IF AVAIL repres-un-ger THEN repres-un-ger.cod-gerente ELSE 0.

        FIND FIRST tt-faturamento
            WHERE tt-faturamento.cod-estabel    = ped-venda.cod-estabel
              AND tt-faturamento.cod_unid_negoc = c-cod-unid-negoc
              AND tt-faturamento.cod-gerente    = i-cod-gerente
              AND tt-faturamento.cod-rep        = tt-repres.cod-rep NO-ERROR.

        IF NOT AVAILABLE tt-faturamento THEN DO:
            FIND FIRST unid_negoc
                WHERE unid_negoc.cod_unid_negoc = c-cod-unid-negoc NO-LOCK NO-ERROR.

            CREATE tt-faturamento.
            ASSIGN tt-faturamento.cod-estabel    = ped-venda.cod-estabel
                   tt-faturamento.cod_unid_negoc = c-cod-unid-negoc
                   tt-faturamento.cod-gerente    = i-cod-gerente
                   tt-faturamento.cod-rep        = tt-repres.cod-rep
                   tt-faturamento.des_unid_negoc = IF AVAILABLE unid_negoc THEN unid_negoc.des_unid_negoc ELSE "":U.

            FIND FIRST gerente
                WHERE gerente.cod-gerente = tt-faturamento.cod-gerente NO-LOCK NO-ERROR.

            ASSIGN tt-faturamento.nome-gerente = IF AVAILABLE gerente THEN gerente.nome ELSE "":U.
        END.

        ASSIGN tt-faturamento.vl-carteira = tt-faturamento.vl-carteira + ped-item.vl-preuni * (ped-item.qt-pedida - ped-item.qt-atendida) * v-cotacao.
    END.
END.

/** Devoluá∆o **/
FOR EACH devol-cli USE-INDEX ch-estabel NO-LOCK
    WHERE (devol-cli.cod-estabel = p-cod-estabel
       OR  devol-cli.cod-estabel = v-cod-estabel-aux)
      AND  devol-cli.dt-devol   >= p-dt-inicial
      AND  devol-cli.dt-devol   <= p-dt-final,
    FIRST nota-fiscal USE-INDEX ch-nota NO-LOCK
    WHERE nota-fiscal.cod-estabel  = devol-cli.cod-estabel
      AND nota-fiscal.serie        = devol-cli.serie
      AND nota-fiscal.nr-nota-fis  = devol-cli.nr-nota-fis
      AND nota-fiscal.emite-duplic = YES,
    FIRST tt-repres
    WHERE tt-repres.no-ab-reppri = nota-fiscal.no-ab-reppri,
    FIRST natur-oper USE-INDEX natureza NO-LOCK
    WHERE natur-oper.nat-operacao = nota-fiscal.nat-operacao
      AND natur-oper.atual-estat  = YES,
    EACH item-doc-est OF devol-cli NO-LOCK,
    FIRST it-nota-fisc USE-INDEX ch-nota-item NO-LOCK
    WHERE it-nota-fisc.cod-estabel = devol-cli.cod-estabel
      AND it-nota-fisc.serie       = devol-cli.serie
      AND it-nota-fisc.nr-nota-fis = devol-cli.nr-nota-fis
      AND it-nota-fisc.nr-seq-fat  = devol-cli.nr-sequencia
      AND it-nota-fisc.it-codigo   = devol-cli.it-codigo:

    FIND FIRST item-uni-estab
        WHERE item-uni-estab.it-codigo   = it-nota-fisc.it-codigo
          AND item-uni-estab.cod-estabel = nota-fiscal.cod-estabel NO-LOCK NO-ERROR.

    IF NOT l-todas-un THEN DO:
        IF NOT AVAILABLE item-uni-estab                                                     OR
           NOT CAN-FIND(FIRST tt-unid_negoc
                        WHERE tt-unid_negoc.cod_unid_negoc = item-uni-estab.cod-unid-negoc) THEN NEXT.
    END.

    ASSIGN c-cod-unid-negoc = IF AVAILABLE item-uni-estab THEN item-uni-estab.cod-unid-negoc ELSE "INV":U.

    FIND FIRST repres-un-ger
        WHERE repres-un-ger.cod-rep       = tt-repres.cod-rep
          AND repres-un-ger.cd-unid-negoc = c-cod-unid-negoc NO-LOCK NO-ERROR.

    ASSIGN i-cod-gerente = IF AVAILABLE repres-un-ger THEN repres-un-ger.cod-gerente ELSE 0.

    FIND FIRST tt-faturamento
        WHERE tt-faturamento.cod-estabel    = nota-fiscal.cod-estabel
          AND tt-faturamento.cod_unid_negoc = c-cod-unid-negoc
          AND tt-faturamento.cod-gerente    = i-cod-gerente
          AND tt-faturamento.cod-rep        = tt-repres.cod-rep NO-ERROR.

    IF NOT AVAILABLE tt-faturamento THEN DO:
        FIND FIRST unid_negoc
            WHERE unid_negoc.cod_unid_negoc = c-cod-unid-negoc NO-LOCK NO-ERROR.

        CREATE tt-faturamento.
        ASSIGN tt-faturamento.cod-estabel    = nota-fiscal.cod-estabel
               tt-faturamento.cod_unid_negoc = c-cod-unid-negoc
               tt-faturamento.cod-gerente    = i-cod-gerente
               tt-faturamento.cod-rep        = tt-repres.cod-rep
               tt-faturamento.des_unid_negoc = IF AVAILABLE unid_negoc THEN unid_negoc.des_unid_negoc ELSE "":U.

        FIND FIRST gerente NO-LOCK
            WHERE gerente.cod-gerente = tt-faturamento.cod-gerente NO-ERROR.

        ASSIGN tt-faturamento.nome-gerente = IF AVAIL gerente THEN gerente.nome ELSE "":U.
    END.

    ASSIGN tt-faturamento.vl-devolvido = tt-faturamento.vl-devolvido + item-doc-est.preco-total[1].
END.

/** Acertando as outras temp-tables **/
FOR EACH tt-faturamento:
    FIND FIRST repres
        WHERE repres.cod-rep = tt-faturamento.cod-rep NO-LOCK NO-ERROR.

    ASSIGN tt-faturamento.nome-abrev = IF AVAILABLE repres THEN repres.nome-abrev ELSE "":U.

    /* Calcula a percentagem apenas se o valor faturado for diferente de zero, para nao gerar erro */
    IF tt-faturamento.vl-faturado > 0 AND
       tt-faturamento.vl-cota     > 0 THEN
        ASSIGN de-perc-cota = ((tt-faturamento.vl-faturado - tt-faturamento.vl-devolvido) / tt-faturamento.vl-cota) * 100.
    ELSE
        ASSIGN de-perc-cota = 0.

    ASSIGN v-vl-fat-orc = 0.

    IF MONTH(p-dt-inicial) = MONTH(p-dt-final) AND
       YEAR(p-dt-inicial)  = YEAR(p-dt-final)  THEN DO:
        IF l-todas-un THEN DO:
            FOR EACH faturamento NO-LOCK
                WHERE faturamento.periodo = STRING(YEAR(p-dt-final), "9999":U) + STRING(MONTH(p-dt-final), "99":U):
                ASSIGN v-vl-fat-orc = v-vl-fat-orc + faturamento.vl-fat-orc.
            END.
        END.
        ELSE DO:
            FOR EACH tt-unid_negoc,
                EACH faturamento NO-LOCK
                WHERE faturamento.periodo  = STRING(YEAR(p-dt-final), "9999":U) + STRING(MONTH(p-dt-final), "99":U)
                  AND faturamento.unid-neg = tt-unid_negoc.des_unid_negoc:
                ASSIGN v-vl-fat-orc = v-vl-fat-orc + faturamento.vl-fat-orc.
            END.
        END.
    END.

    ASSIGN tt-faturamento.pc-cota      = de-perc-cota
           tt-faturamento.vl-orcamento = v-vl-fat-orc.
END.

IF CAN-FIND(FIRST tt-faturamento) THEN
    RETURN "OK":U.
ELSE
    RETURN "NOK":U.

