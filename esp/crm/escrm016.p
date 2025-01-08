/*********************************************************************************
** Programa: esp/crm/escrm016.p
** Vers∆o..: 1.00
** Data....: 04/11/2010
** Autor...: Estevan KrÅger - Exponencial TI
** Obs.....: Relat¢rio do Portal B2B.
**           C¢pia da procedure "process-zoom-curva-abc", programa "soap-b2b-curva-abc"
**           Curva ABC do Representante
*********************************************************************************/

CREATE WIDGET-POOL.

/*--- Definiá∆o das Temp-Tables ---*/
DEFINE TEMP-TABLE tt-repres NO-UNDO
   FIELD cod-rep      LIKE repres.cod-rep
   FIELD no-ab-reppri LIKE repres.nome-abrev
   INDEX ch-pri AS PRIMARY UNIQUE cod-rep.

DEFINE TEMP-TABLE tt-curva NO-UNDO
   FIELD cod-gr-cli     LIKE gr-cli.cod-gr-cli
   FIELD descricao      LIKE gr-cli.descricao
   FIELD cod-emitente   LIKE emitente.cod-emitente
   FIELD cod-unid-negoc AS CHARACTER
   FIELD nome-emit      LIKE emitente.nome-emit
   FIELD des-unid-negoc AS CHARACTER
   FIELD total-periodo  AS DECIMAL
   INDEX ch-tt          AS UNIQUE cod-emitente cod-unid-negoc
   INDEX ch-total       AS PRIMARY total-periodo DESC.

/*--- Definiá∆o das Vari†veis ---*/
DEFINE VARIABLE c-cidade             AS CHARACTER                        NO-UNDO.
DEFINE VARIABLE c-estado             AS CHARACTER                        NO-UNDO.
DEFINE VARIABLE i                    AS INTEGER                          NO-UNDO.
DEFINE VARIABLE j                    AS INTEGER                          NO-UNDO.
DEFINE VARIABLE dt-data              AS DATE                             NO-UNDO.
DEFINE VARIABLE dt-inicial           AS DATE                             NO-UNDO.
DEFINE VARIABLE dt-final             AS DATE                             NO-UNDO.
DEFINE VARIABLE l-todas-un-neg       AS LOGICAL                          NO-UNDO INITIAL YES.
DEFINE VARIABLE v-cod_unid_negoc     LIKE unid_negoc.cod_unid_negoc NO-UNDO.
DEFINE VARIABLE v-cod_unid_negoc-aux LIKE unid_negoc.cod_unid_negoc NO-UNDO.

/*--- ParÉmetros do Programa ---*/
DEFINE INPUT  PARAMETER p-cod-repres     AS INTEGER     NO-UNDO.
DEFINE INPUT  PARAMETER p-des_unid_negoc AS CHARACTER   NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR tt-curva.


/*--- Bloco Principal ---*/

/** Cria as datas com o mes inicial e o mes final para pesquisa no FOR EACH **/
ASSIGN dt-final   = DATE(MONTH(TODAY), 1, YEAR(TODAY))
       dt-inicial = ADD-INTERVAL(dt-final, -6, "MONTHS":U)
       dt-final   = dt-final - 1.

/** Ver quais os representantes que devem ser pesquisados **/
IF p-cod-repres <> 0 AND
   p-cod-repres <> ? THEN DO:
    FIND FIRST repres
        WHERE repres.cod-rep = p-cod-repres NO-LOCK NO-ERROR.

    IF AVAILABLE repres THEN DO:
        CREATE tt-repres.
        ASSIGN tt-repres.cod-rep      = repres.cod-rep
               tt-repres.no-ab-reppri = repres.nome-abrev.
    END.
END.
ELSE DO:
    /** Se o cara nao tem nenhum representante associado, vai todo mundo **/
    FOR EACH repres FIELDS(cod-rep nome-abrev) NO-LOCK:
        CREATE tt-repres.
        ASSIGN tt-repres.cod-rep      = repres.cod-rep
               tt-repres.no-ab-reppri = repres.nome-abrev.
    END.
END.

IF p-des_unid_negoc <> "0":U AND
   p-des_unid_negoc <> "":U  AND
   p-des_unid_negoc <> "?":U AND
   p-des_unid_negoc <> ?     THEN DO:
    FIND FIRST unid_negoc
        WHERE unid_negoc.des_unid_negoc = p-des_unid_negoc NO-LOCK NO-ERROR.

    IF NOT AVAILABLE unid_negoc THEN
        RETURN "NOK":U.

    ASSIGN v-cod_unid_negoc = unid_negoc.cod_unid_negoc
           l-todas-un-neg   = NO.
END.
ELSE
    ASSIGN l-todas-un-neg = YES.

/** Le as notas fiscais e guarda os valores necessarios numa tt **/
DO dt-data = dt-inicial TO dt-final:
    FOR EACH nota-fiscal USE-INDEX ch-distancia NO-LOCK
        WHERE nota-fiscal.dt-cancel    = ?
          AND nota-fiscal.emite-duplic = YES
          AND nota-fiscal.dt-emis-nota = dt-data,
        FIRST tt-repres
        WHERE tt-repres.no-ab-reppri = nota-fiscal.no-ab-reppri,
        FIRST natur-oper USE-INDEX natureza NO-LOCK
        WHERE natur-oper.nat-operacao = nota-fiscal.nat-operacao
          AND natur-oper.atual-estat  = YES,
        EACH it-nota-fisc OF nota-fiscal NO-LOCK,
        FIRST item NO-LOCK
        WHERE item.it-codigo = it-nota-fisc.it-codigo:

        /** Ignorar itens que nao tem valor do item **/
        IF NOT (it-nota-fisc.vl-merc-liq > 0) THEN
            NEXT.

        FIND FIRST item-uni-estab
            WHERE item-uni-estab.it-codigo   = item.it-codigo
              AND item-uni-estab.cod-estabel = nota-fiscal.cod-estabel NO-LOCK NO-ERROR.

        IF NOT l-todas-un-neg THEN DO:
            IF NOT AVAILABLE item-uni-estab                      OR
               item-uni-estab.cod-unid-negoc <> v-cod_unid_negoc THEN NEXT.
        END.

        ASSIGN v-cod_unid_negoc-aux = IF AVAILABLE item-uni-estab THEN item-uni-estab.cod-unid-negoc ELSE "INV":U.

        /* Validaá∆o relacionamento cliente */
        IF NOT CAN-FIND(FIRST crm-relacionamento-cliente
                        WHERE  crm-relacionamento-cliente.cod-emitente       = nota-fiscal.cod-emitente
                          AND  crm-relacionamento-cliente.cod-rep            = tt-repres.cod-rep
                          AND  crm-relacionamento-cliente.dt-vigencia-ini   <> ?
                          AND (crm-relacionamento-cliente.dt-vigencia-fim    = ?
                           OR  crm-relacionamento-cliente.dt-vigencia-fim   <= TODAY) NO-LOCK) THEN NEXT.

        FIND FIRST tt-curva
            WHERE tt-curva.cod-emitente   = nota-fiscal.cod-emitente
              AND tt-curva.cod-unid-negoc = v-cod_unid_negoc-aux NO-ERROR.

        IF NOT AVAILABLE tt-curva THEN DO:
            FIND FIRST unid_negoc
                WHERE unid_negoc.cod_unid_negoc = v-cod_unid_negoc-aux NO-LOCK NO-ERROR.

            CREATE tt-curva.
            ASSIGN tt-curva.cod-emitente   = nota-fiscal.cod-emitente
                   tt-curva.cod-unid-negoc = v-cod_unid_negoc-aux
                   tt-curva.des-unid-negoc = IF AVAILABLE unid_negoc THEN unid_negoc.des_unid_negoc ELSE "":U.

            RELEASE unid_negoc.
        END.

        ASSIGN tt-curva.total-periodo = tt-curva.total-periodo + (it-nota-fisc.vl-preuni * it-nota-fisc.qt-faturada[1]).
    END.
END.

/** Devoluá∆o **/
DO dt-data = dt-inicial TO dt-final:
    FOR EACH devol-cli NO-LOCK
        WHERE devol-cli.dt-devol = dt-data,
        FIRST nota-fiscal NO-LOCK
        WHERE nota-fiscal.cod-estabel  = devol-cli.cod-estabel
          AND nota-fiscal.serie        = devol-cli.serie
          AND nota-fiscal.nr-nota-fis  = devol-cli.nr-nota-fis
          AND nota-fiscal.emite-duplic = YES,
        FIRST tt-repres
        WHERE tt-repres.no-ab-reppri = nota-fiscal.no-ab-reppri,
        FIRST natur-oper USE-INDEX natureza NO-LOCK
        WHERE natur-oper.nat-operacao = nota-fiscal.nat-operacao
          AND natur-oper.atual-estat  = YES,
        EACH  item-doc-est OF devol-cli NO-LOCK,
        FIRST it-nota-fisc NO-LOCK
        WHERE it-nota-fisc.cod-estabel = devol-cli.cod-estabel
          AND it-nota-fisc.serie       = devol-cli.serie
          AND it-nota-fisc.nr-nota-fis = devol-cli.nr-nota-fis
          AND it-nota-fisc.it-codigo   = devol-cli.it-codigo
          AND it-nota-fisc.nr-seq-fat  = devol-cli.nr-sequencia:

        /** Ignorar itens que nao tem valor do item **/
        IF NOT (it-nota-fisc.vl-merc-liq > 0) THEN
            NEXT.

        FIND FIRST item-uni-estab
            WHERE item-uni-estab.it-codigo   = item.it-codigo
              AND item-uni-estab.cod-estabel = nota-fiscal.cod-estabel NO-LOCK NO-ERROR.

        IF NOT l-todas-un-neg THEN DO:
            IF NOT AVAILABLE item-uni-estab                      OR
               item-uni-estab.cod-unid-negoc <> v-cod_unid_negoc THEN NEXT.
        END.

        ASSIGN v-cod_unid_negoc-aux = IF AVAILABLE item-uni-estab THEN item-uni-estab.cod-unid-negoc ELSE "INV":U.

         /* Validaá∆o relacionamento cliente */
        IF NOT CAN-FIND(FIRST crm-relacionamento-cliente
                        WHERE  crm-relacionamento-cliente.cod-emitente       = nota-fiscal.cod-emitente
                          AND  crm-relacionamento-cliente.cod-rep            = tt-repres.cod-rep
                          AND  crm-relacionamento-cliente.dt-vigencia-ini   <> ?
                          AND (crm-relacionamento-cliente.dt-vigencia-fim    = ?
                           OR  crm-relacionamento-cliente.dt-vigencia-fim   <= TODAY) NO-LOCK) THEN NEXT.

        FIND FIRST tt-curva
            WHERE tt-curva.cod-emitente   = nota-fiscal.cod-emitente
              AND tt-curva.cod-unid-negoc = v-cod_unid_negoc-aux NO-ERROR.

        IF NOT AVAILABLE tt-curva THEN DO:
            FIND FIRST unid_negoc
                WHERE unid_negoc.cod_unid_negoc = v-cod_unid_negoc-aux NO-LOCK NO-ERROR.

            CREATE tt-curva.
            ASSIGN tt-curva.cod-emitente   = nota-fiscal.cod-emitente
                   tt-curva.cod-unid-negoc = v-cod_unid_negoc-aux
                   tt-curva.des-unid-negoc = IF AVAILABLE unid_negoc THEN unid_negoc.des_unid_negoc ELSE "":U.

            RELEASE unid_negoc.
        END.

        ASSIGN tt-curva.total-periodo = tt-curva.total-periodo - item-doc-est.preco-total[1].
    END.
END.

FOR EACH tt-curva,
    FIRST emitente NO-LOCK
    WHERE emitente.cod-emitente = tt-curva.cod-emitente,
    FIRST gr-cli NO-LOCK
    WHERE gr-cli.cod-gr-cli = emitente.cod-gr-cli:
    ASSIGN tt-curva.nome-emit  = emitente.nome-emit
           tt-curva.cod-gr-cli = gr-cli.cod-gr-cli
           tt-curva.descricao  = gr-cli.descricao.
END.

DELETE WIDGET-POOL.

RETURN "OK":U.

