/*----------------------------------------------------------------------
**  Programa..: esp/crm/escrm102.p
**  Autor.....: Felipe Braun Azambuja
**  Data......: Outubro/2010 - Desenvolvimento
**  Descricao.: Relat¢rio faturamento do representante - B2B/CRM
-----------------------------------------------------------------------*/

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Local Temp-Table Definitions ---                                     */

DEFINE TEMP-TABLE tt-faturamento-repres NO-UNDO
    FIELD cod-gr-cli    LIKE gr-cli.cod-gr-cli
    FIELD cod-emitente  LIKE emitente.cod-emitente
    FIELD nome-emit     LIKE emitente.nome-emit
    FIELD cod-repres    LIKE repres.cod-rep
    FIELD nome-repres   LIKE repres.nome
    FIELD cd-unid-negoc LIKE unid_negoc.cod_unid_negoc
    FIELD cod-gerente   LIKE gerente.cod-gerente
    FIELD nome-gerente  LIKE gerente.nome
    FIELD vl-faturado   AS DECIMAL
    FIELD vl-carteira   AS DECIMAL
    FIELD vl-devolvido  AS DECIMAL
    INDEX idx_pri IS PRIMARY UNIQUE
        cod-gr-cli
        cod-emitente.

DEFINE TEMP-TABLE tt-gr-cli NO-UNDO
    FIELD cod-gr-cli LIKE gr-cli.cod-gr-cli
    FIELD descricao  LIKE gr-cli.descricao
    INDEX idx_pri IS PRIMARY UNIQUE
        cod-gr-cli.

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE dt-aux            AS DATE                    NO-UNDO.
DEFINE VARIABLE dt-fim-mes        AS DATE                    NO-UNDO.
DEFINE VARIABLE d-cotacao         AS DECIMAL                 NO-UNDO.
DEFINE VARIABLE dt-inicial-aux    AS DATE                    NO-UNDO.
DEFINE VARIABLE v-cod-estabel-aux LIKE estabelec.cod-estabel NO-UNDO.

/* Parameters Definitions ---                                           */

DEFINE INPUT  PARAMETER p-cod-estabel    LIKE estabelec.cod-estabel          NO-UNDO.
DEFINE INPUT  PARAMETER p-cod-rep        LIKE repres.cod-rep                 NO-UNDO.
DEFINE INPUT  PARAMETER p-des_unid_negoc LIKE unid_negoc.des_unid_negoc NO-UNDO. /* ê utilizada a descriá∆o da Unidade de Neg¢cio pois o CRM trata este valor como chave da tabela */
DEFINE INPUT  PARAMETER p-dt-inicial     AS DATE                             NO-UNDO.
DEFINE INPUT  PARAMETER p-dt-final       AS DATE                             NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR tt-gr-cli.
DEFINE OUTPUT PARAMETER TABLE FOR tt-faturamento-repres.


/* ***************************  Main Block  *************************** */

FIND FIRST repres
    WHERE repres.cod-rep = p-cod-rep NO-LOCK NO-ERROR.

IF NOT AVAILABLE repres THEN
    RETURN "NOK":U.

FIND FIRST unid_negoc
    WHERE unid_negoc.des_unid_negoc = p-des_unid_negoc NO-LOCK NO-ERROR.

IF NOT AVAILABLE unid_negoc THEN
    RETURN "NOK":U.

IF p-cod-estabel = "101":U OR
   p-cod-estabel = "104":U THEN
    ASSIGN v-cod-estabel-aux = IF p-cod-estabel = "101":U THEN "104":U ELSE "101":U.
ELSE
    ASSIGN v-cod-estabel-aux = p-cod-estabel.

ASSIGN dt-fim-mes = TODAY - 1
       dt-fim-mes = DATE(MONTH(dt-fim-mes), 1, YEAR(dt-fim-mes))
       dt-fim-mes = ADD-INTERVAL(dt-fim-mes, 1, "months":U) - 1.

/** Leitura dos dados e criaá∆o da temp-table principal **/
/** Faturamento **/
DO dt-aux = p-dt-inicial TO p-dt-final:
    FOR EACH nota-fiscal USE-INDEX ch-distancia NO-LOCK
        WHERE  nota-fiscal.dt-emis-nota = dt-aux
          AND  nota-fiscal.dt-cancel    = ?
          AND  nota-fiscal.emite-duplic = YES
          AND  nota-fiscal.no-ab-reppri = repres.nome-abrev
          AND (nota-fiscal.cod-estabel  = p-cod-estabel
           OR  nota-fiscal.cod-estabel  = v-cod-estabel-aux),
        FIRST natur-oper NO-LOCK
        WHERE natur-oper.nat-operacao = nota-fiscal.nat-operacao
          AND natur-oper.atual-estat,
        EACH it-nota-fisc of nota-fiscal NO-LOCK:

        FIND FIRST item-uni-estab
            WHERE item-uni-estab.it-codigo   = it-nota-fisc.it-codigo
              AND item-uni-estab.cod-estabel = it-nota-fisc.cod-estabel NO-LOCK NO-ERROR.

        IF NOT AVAILABLE item-uni-estab                                    OR
           item-uni-estab.cod-unid-negoc <> unid_negoc.cod_unid_negoc THEN NEXT.

        IF NOT (it-nota-fisc.vl-merc-liq > 0) THEN NEXT.

        FIND FIRST tt-faturamento-repres
            WHERE tt-faturamento-repres.cod-emitente = nota-fiscal.cod-emitente NO-ERROR.

        IF NOT AVAILABLE tt-faturamento-repres THEN DO:
            CREATE tt-faturamento-repres.
            ASSIGN tt-faturamento-repres.cod-emitente = nota-fiscal.cod-emitente.
        END.

        ASSIGN tt-faturamento-repres.cod-repres    = repres.cod-rep
               tt-faturamento-repres.nome-repres   = repres.nome
               tt-faturamento-repres.cd-unid-negoc = unid_negoc.cod_unid_negoc.

        FIND FIRST repres-un-ger
            WHERE repres-un-ger.cod-rep       = repres.cod-rep
              AND repres-un-ger.cd-unid-negoc = unid_negoc.cod_unid_negoc NO-LOCK NO-ERROR.

        IF AVAILABLE repres-un-ger THEN
            ASSIGN tt-faturamento-repres.cod-gerente = repres-un-ger.cod-gerente.

         ASSIGN tt-faturamento-repres.vl-faturado = tt-faturamento-repres.vl-faturado + it-nota-fisc.vl-merc-liq.
    END.
END.

/* Se Pesquisar por mes atual ou anterior busca os pedidos anteriores */
IF MONTH(p-dt-final) <= MONTH(TODAY) AND
   YEAR(p-dt-final)  <= YEAR(TODAY)  THEN
    ASSIGN dt-inicial-aux = ADD-INTERVAL(TODAY, -7, "MONTH":U).
ELSE
    ASSIGN dt-inicial-aux = p-dt-inicial.

/** Carteira **/
/** Pesquisa por pedidos apenas se o periodo a ser exibido esta no mes atual ou pra frente **/
FOR EACH ped-venda USE-INDEX ch-rep-cli NO-LOCK
    WHERE ped-venda.no-ab-reppri = repres.nome-abrev
      AND ped-venda.cod-sit-ped <= 5,
    FIRST natur-oper NO-LOCK
    WHERE natur-oper.nat-operacao = ped-venda.nat-operacao
      AND natur-oper.atual-estat,
    EACH ped-item OF ped-venda NO-LOCK
    WHERE ped-item.dt-entrega   >= dt-inicial-aux
      AND ped-item.dt-entrega   <= p-dt-final
      AND ped-item.ind-componen <> 3:

    FIND FIRST item-uni-estab
        WHERE item-uni-estab.it-codigo   = ped-item.it-codigo
          AND item-uni-estab.cod-estabel = ped-venda.cod-estabel NO-LOCK NO-ERROR.

    IF NOT AVAILABLE item-uni-estab                                    OR
       item-uni-estab.cod-unid-negoc <> unid_negoc.cod_unid_negoc THEN NEXT.

    IF ped-item.cod-sit-item = 3 OR
       ped-item.cod-sit-item = 6 THEN NEXT.

    IF p-cod-estabel = "101":U OR
       p-cod-estabel = "104":U THEN DO:
        IF ped-venda.cod-estabel <> "101":U AND
           ped-venda.cod-estabel <> "104":U THEN NEXT.
    END.
    ELSE IF p-cod-estabel <> ped-venda.cod-estabel THEN NEXT.

    /** Ignora oráamentos Maxcom **/
    IF ((ped-venda.cod-estabel = "301":U OR ped-venda.cod-estabel = "103":U) AND (ped-venda.cod-priori = 99)) OR (ped-venda.cod-priori = 44) THEN NEXT.

    FIND FIRST cotacao
        WHERE cotacao.mo-codigo   = ped-venda.mo-codigo
          AND cotacao.ano-periodo = STRING(YEAR(TODAY), "9999":U) + STRING(MONTH(TODAY), "99":U) NO-LOCK NO-ERROR.

    IF AVAILABLE cotacao                AND
       cotacao.cotacao[DAY(TODAY)] <> 0 THEN
        ASSIGN d-cotacao = cotacao.cotacao[DAY(TODAY)].
    ELSE
        ASSIGN d-cotacao = 1.

    FIND FIRST tt-faturamento-repres
        WHERE tt-faturamento-repres.cod-emitente = ped-venda.cod-emitente NO-ERROR.

    IF NOT AVAILABLE tt-faturamento-repres THEN DO:
        CREATE tt-faturamento-repres.
        ASSIGN tt-faturamento-repres.cod-emitente = ped-venda.cod-emitente.
    END.

    ASSIGN tt-faturamento-repres.cod-repres    = repres.cod-rep
           tt-faturamento-repres.nome-repres   = repres.nome
           tt-faturamento-repres.cd-unid-negoc = unid_negoc.cod_unid_negoc.

    FIND FIRST repres-un-ger
        WHERE repres-un-ger.cod-rep       = repres.cod-rep
          AND repres-un-ger.cd-unid-negoc = unid_negoc.cod_unid_negoc NO-LOCK NO-ERROR.

    IF AVAILABLE repres-un-ger THEN
        ASSIGN tt-faturamento-repres.cod-gerente = repres-un-ger.cod-gerente.

    ASSIGN tt-faturamento-repres.vl-carteira = tt-faturamento-repres.vl-carteira + ped-item.vl-preuni * (ped-item.qt-pedida - ped-item.qt-atendida) * d-cotacao.
END.

/** Devoluá∆o **/
FOR EACH devol-cli USE-INDEX ch-estabel NO-LOCK
    WHERE devol-cli.cod-estabel = p-cod-estabel
      AND devol-cli.dt-devol   >= p-dt-inicial
      AND devol-cli.dt-devol   <= p-dt-final,
    FIRST nota-fiscal USE-INDEX ch-nota NO-LOCK
    WHERE nota-fiscal.cod-estabel = devol-cli.cod-estabel
      AND nota-fiscal.serie       = devol-cli.serie
      AND nota-fiscal.nr-nota-fis = devol-cli.nr-nota-fis
      AND nota-fiscal.cod-rep     = p-cod-rep,
    FIRST natur-oper NO-LOCK
    WHERE natur-oper.nat-operacao = nota-fiscal.nat-operacao
      AND natur-oper.atual-estat,
    EACH item-doc-est OF devol-cli NO-LOCK,
    FIRST it-nota-fisc NO-LOCK
    WHERE it-nota-fisc.cod-estabel = devol-cli.cod-estabel
      AND it-nota-fisc.serie       = devol-cli.serie
      AND it-nota-fisc.nr-nota-fis = devol-cli.nr-nota-fis
      AND it-nota-fisc.nr-seq-fat  = devol-cli.nr-sequencia
      AND it-nota-fisc.it-codigo   = devol-cli.it-codigo:

    FIND FIRST item-uni-estab
        WHERE item-uni-estab.it-codigo   = it-nota-fisc.it-codigo
          AND item-uni-estab.cod-estabel = it-nota-fisc.cod-estabel NO-LOCK NO-ERROR.

    IF NOT AVAILABLE item-uni-estab                                    OR
       item-uni-estab.cod-unid-negoc <> unid_negoc.cod_unid_negoc THEN NEXT.

    FIND FIRST tt-faturamento-repres
        WHERE tt-faturamento-repres.cod-emitente = nota-fiscal.cod-emitente NO-ERROR.

    IF NOT AVAILABLE tt-faturamento-repres THEN DO:
        CREATE tt-faturamento-repres.
        ASSIGN tt-faturamento-repres.cod-emitente = nota-fiscal.cod-emitente.
    END.

    FIND FIRST repres
        WHERE repres.nome-abrev = nota-fiscal.no-ab-reppri NO-LOCK NO-ERROR.

    ASSIGN tt-faturamento-repres.cod-repres    = repres.cod-rep
           tt-faturamento-repres.nome-repres   = repres.nome
           tt-faturamento-repres.cd-unid-negoc = unid_negoc.cod_unid_negoc.

    FIND FIRST repres-un-ger
        WHERE repres-un-ger.cod-rep       = repres.cod-rep
          AND repres-un-ger.cd-unid-negoc = unid_negoc.cod_unid_negoc NO-LOCK NO-ERROR.

    IF AVAILABLE repres-un-ger THEN
        ASSIGN tt-faturamento-repres.cod-gerente = repres-un-ger.cod-gerente.

    ASSIGN tt-faturamento-repres.vl-devolvido = tt-faturamento-repres.vl-devolvido + item-doc-est.preco-total[1].
END.

/** Acertando as outras temp-tables **/
FOR EACH tt-faturamento-repres,
    FIRST emitente NO-LOCK
    WHERE emitente.cod-emitente = tt-faturamento-repres.cod-emitente:

    IF NOT CAN-FIND(FIRST tt-gr-cli
                    WHERE tt-gr-cli.cod-gr-cli = emitente.cod-gr-cli) THEN DO:
        FIND FIRST gr-cli
            WHERE gr-cli.cod-gr-cli = emitente.cod-gr-cli NO-LOCK NO-ERROR.

        CREATE tt-gr-cli.
        ASSIGN tt-gr-cli.cod-gr-cli = gr-cli.cod-gr-cli
               tt-gr-cli.descricao  = gr-cli.descricao.
    END.

    FIND FIRST gerente
        WHERE gerente.cod-gerente = tt-faturamento-repres.cod-gerente NO-LOCK NO-ERROR.

    IF AVAILABLE gerente THEN
        ASSIGN tt-faturamento-repres.nome-gerente = gerente.nome.

    ASSIGN tt-faturamento-repres.cod-gr-cli = emitente.cod-gr-cli
           tt-faturamento-repres.nome-emit  = emitente.nome-emit.
END.

IF CAN-FIND(FIRST tt-faturamento-repres) THEN
    RETURN "OK":U.
ELSE
    RETURN "NOK":U.

