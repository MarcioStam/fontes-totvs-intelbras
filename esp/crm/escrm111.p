/*********************************************************************************
** Programa: esp/crm/escrm111.p
** VersÆo..: 1.00
** Data....: 01/08/2011
** Autor...: Anderson Cenci
** Obs.....: Relat¢rio do Portal B2B.
**           Detalhe do Cliente da Curva ABC do Representante.
*********************************************************************************/

CREATE WIDGET-POOL.

/*--- Defini‡Æo das Temp-Tables ---*/
DEFINE TEMP-TABLE tt-detalhe NO-UNDO
    FIELD familia              LIKE fam-comerc.fm-cod-com
    FIELD produto              LIKE item.it-codigo
    FIELD desc-familia         LIKE fam-comerc.descricao
    FIELD desc-produto         LIKE item.desc-item
    FIELD unid-neg             LIKE unid-neg-fat.cod_unid_negoc
    FIELD periodo              AS CHARACTER EXTENT 6
    FIELD quantidade           AS INTEGER   EXTENT 6
    FIELD valor                AS DECIMAL   EXTENT 6
    FIELD valor-total          AS DECIMAL   EXTENT 6
    FIELD registros            AS INTEGER   EXTENT 6
    FIELD carteira-qtde        AS INTEGER
    FIELD carteira-valor       AS DECIMAL
    FIELD carteira-valor-total AS DECIMAL
    FIELD carteira-regs        AS INTEGER
    FIELD faturado-qtde        AS INTEGER
    FIELD faturado-valor       AS DECIMAL
    FIELD faturado-valor-total AS DECIMAL
    FIELD faturado-regs        AS INTEGER
    INDEX ch-pri IS PRIMARY UNIQUE
        familia
        produto
        unid-neg.

DEFINE TEMP-TABLE tt-repres NO-UNDO
    FIELD cod-rep      LIKE repres.cod-rep
    FIELD no-ab-reppri LIKE repres.nome-abrev
    INDEX ch-pri IS PRIMARY UNIQUE
        cod-rep.

/*--- Defini‡Æo das Vari veis ---*/
DEFINE VARIABLE dt-data              AS DATE                             NO-UNDO.
DEFINE VARIABLE dt-inicial           AS DATE                             NO-UNDO.
DEFINE VARIABLE dt-final             AS DATE                             NO-UNDO.
DEFINE VARIABLE c-periodo            AS CHARACTER                        NO-UNDO.
DEFINE VARIABLE i-mes                AS INTEGER                          NO-UNDO INITIAL 0.
DEFINE VARIABLE l-todas-un-neg       AS LOGICAL                          NO-UNDO INITIAL YES.
DEFINE VARIABLE v-cod_unid_negoc     LIKE unid_negoc.cod_unid_negoc NO-UNDO.
DEFINE VARIABLE v-cod_unid_negoc-aux LIKE unid_negoc.cod_unid_negoc NO-UNDO.

/*--- Parƒmetros do Programa ---*/
DEFINE INPUT  PARAMETER p-cod-rep        LIKE repres.cod-rep                 NO-UNDO.
DEFINE INPUT  PARAMETER p-des_unid_negoc LIKE unid_negoc.des_unid_negoc NO-UNDO.
DEFINE INPUT  PARAMETER p-cod-emitente   LIKE emitente.cod-emitente          NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR tt-detalhe.

MESSAGE "1" 
     p-cod-rep        " "
     p-des_unid_negoc " " 
     p-cod-emitente   " " 
    .
/*--- Bloco Principal ---*/
/** Cria as datas com o mes inicial e o mes final para pesquisa no FOR EACH **/
ASSIGN dt-final   = DATE(MONTH(TODAY), 1, YEAR(TODAY))
       dt-inicial = ADD-INTERVAL(dt-final, -6, "MONTHS":U)
       dt-final   = ADD-INTERVAL(dt-final,  1, "MONTHS":U) - 1.

/** Ver quais os representantes que devem ser pesquisados **/
IF p-cod-rep <> 0 AND p-cod-rep <> ? THEN DO:
    FIND FIRST repres
        WHERE repres.cod-rep = p-cod-rep NO-LOCK NO-ERROR.

    IF AVAILABLE repres THEN DO:
        CREATE tt-repres.
        ASSIGN tt-repres.cod-rep      = repres.cod-rep
               tt-repres.no-ab-reppri = repres.nome-abrev.
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
MESSAGE "2".
IF p-des_unid_negoc <> "0":U AND
   p-des_unid_negoc <> "":U  AND
   p-des_unid_negoc <> "?":U AND
   p-des_unid_negoc <> ?     THEN DO:
    FIND FIRST unid_negoc
        WHERE unid_negoc.cod_unid_negoc = p-des_unid_negoc NO-LOCK NO-ERROR.

    IF NOT AVAILABLE unid_negoc THEN
        RETURN "NOK":U.

    ASSIGN v-cod_unid_negoc = unid_negoc.cod_unid_negoc
           l-todas-un-neg   = NO.
END.
ELSE
    ASSIGN l-todas-un-neg = YES.
MESSAGE "3".
FIND FIRST emitente
    WHERE emitente.cod-emitente = p-cod-emitente NO-LOCK NO-ERROR.

MESSAGE "4".
IF NOT AVAILABLE emitente THEN
    RETURN "NOK":U.
          MESSAGE "5".

/** FATURAMENTO **/
DO dt-data = dt-inicial TO dt-final:
    /** Ajusta o contador a ser usado no array **/
    IF c-periodo <> (STRING(YEAR(dt-data), "9999":U) + STRING(MONTH(dt-data), "99":U)) THEN DO:
        ASSIGN c-periodo = STRING(YEAR(dt-data), "9999":U) + STRING(MONTH(dt-data), "99":U)
               i-mes     = i-mes + 1.

        FIND FIRST tt-detalhe
            WHERE tt-detalhe.familia  = "0":U
              AND tt-detalhe.produto  = "0":U
              AND tt-detalhe.unid-neg = "":U NO-ERROR.

        IF NOT AVAILABLE tt-detalhe THEN DO:
            CREATE tt-detalhe.
            ASSIGN tt-detalhe.familia  = "0":U
                   tt-detalhe.produto  = "0":U
                   tt-detalhe.unid-neg = "":U.
        END.

        IF i-mes < 7 THEN
            ASSIGN tt-detalhe.periodo[i-mes] = c-periodo.
    END.

    FOR EACH nota-fiscal USE-INDEX ch-distancia NO-LOCK
        WHERE nota-fiscal.dt-cancel    = ?
          AND nota-fiscal.dt-emis-nota = dt-data
          AND nota-fiscal.cod-emitente = emitente.cod-emitente,
        FIRST tt-repres
        WHERE tt-repres.no-ab-reppri = nota-fiscal.no-ab-reppri,
        FIRST natur-oper NO-LOCK
        WHERE natur-oper.nat-operacao = nota-fiscal.nat-operacao
          AND natur-oper.atual-estat,
        EACH it-nota-fisc OF nota-fiscal NO-LOCK,
        FIRST item NO-LOCK
        WHERE item.it-codigo = it-nota-fisc.it-codigo:

        /** Ignorar itens que nao tem valor do item **/
        /** IF colocado devido a uma nota de substituicao tributaria **/
        /** Felipe / Claudiney - 03/07/2006 **/
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

        FIND FIRST fam-comerc
            WHERE fam-comerc.fm-cod-com = item.fm-cod-com NO-LOCK NO-ERROR.
            
        FIND FIRST tt-detalhe
            WHERE tt-detalhe.familia  = item.fm-cod-com
              AND tt-detalhe.produto  = item.it-codigo
              AND tt-detalhe.unid-neg = v-cod_unid_negoc-aux NO-ERROR.

        IF NOT AVAILABLE tt-detalhe THEN DO:
            CREATE tt-detalhe.
            ASSIGN tt-detalhe.familia      = item.fm-cod-com
                   tt-detalhe.produto      = item.it-codigo
                   tt-detalhe.unid-neg     = v-cod_unid_negoc-aux
                   tt-detalhe.desc-familia = IF AVAILABLE fam-comerc THEN fam-comerc.descricao ELSE "":U
                   tt-detalhe.desc-produto = item.desc-item.
        END.

        /** Se mes corrente, incrementa o campo correspondente **/
        IF MONTH(TODAY) = MONTH(dt-data) AND
           YEAR(TODAY)  = YEAR(dt-data)  THEN DO:
            ASSIGN tt-detalhe.faturado-qtde        = tt-detalhe.faturado-qtde + it-nota-fisc.qt-faturada[1]
                   tt-detalhe.faturado-valor       = it-nota-fisc.vl-preuni
                   tt-detalhe.faturado-valor-total = tt-detalhe.faturado-valor-total + (it-nota-fisc.vl-preuni * it-nota-fisc.qt-faturada[1])
                   tt-detalhe.faturado-regs        = tt-detalhe.faturado-regs + 1.
        END.
        ELSE DO:
            ASSIGN tt-detalhe.quantidade[i-mes]  = tt-detalhe.quantidade[i-mes] + it-nota-fisc.qt-faturada[1]
                   tt-detalhe.valor[i-mes]       = it-nota-fisc.vl-preuni
                   tt-detalhe.valor-total[i-mes] = tt-detalhe.valor-total[i-mes] + (it-nota-fisc.vl-preuni * it-nota-fisc.qt-faturada[1])
                   tt-detalhe.registros[i-mes]   = tt-detalhe.registros[i-mes] + 1
                   tt-detalhe.periodo[i-mes]     = c-periodo.
        END.
    END.

    FOR EACH devol-cli NO-LOCK
        WHERE devol-cli.dt-devol = dt-data,
        FIRST nota-fiscal NO-LOCK
        WHERE nota-fiscal.cod-estabel  = devol-cli.cod-estabel
          AND nota-fiscal.serie        = devol-cli.serie
          AND nota-fiscal.nr-nota-fis  = devol-cli.nr-nota-fis
          AND nota-fiscal.cod-emitente = emitente.cod-emitente
          AND nota-fiscal.emite-duplic,
        FIRST tt-repres
        WHERE tt-repres.no-ab-reppri = nota-fiscal.no-ab-reppri,
        FIRST natur-oper NO-LOCK
        WHERE natur-oper.nat-operacao = nota-fiscal.nat-operacao
          AND natur-oper.atual-estat,
        EACH item-doc-est OF devol-cli NO-LOCK,
        FIRST it-nota-fisc NO-LOCK
        WHERE it-nota-fisc.cod-estabel = devol-cli.cod-estabel
          AND it-nota-fisc.serie       = devol-cli.serie
          AND it-nota-fisc.nr-nota-fis = devol-cli.nr-nota-fis
          AND it-nota-fisc.it-codigo   = devol-cli.it-codigo
          AND it-nota-fisc.nr-seq-fat  = devol-cli.nr-sequencia,
        FIRST item NO-LOCK
        WHERE item.it-codigo = it-nota-fisc.it-codigo:

        /** Ignorar itens que nao tem valor do item **/
        /** IF colocado devido a uma nota de substituicao tributaria **/
        /** Felipe / Claudiney - 03/07/2006 **/
        IF NOT (it-nota-fisc.vl-merc-liq > 0) THEN
            NEXT.

        FIND FIRST item-uni-estab
            WHERE item-uni-estab.it-codigo   = item.it-codigo
              AND item-uni-estab.cod-estabel = devol-cli.cod-estabel NO-LOCK NO-ERROR.

        IF NOT l-todas-un-neg THEN DO:
            IF NOT AVAILABLE item-uni-estab                      OR
               item-uni-estab.cod-unid-negoc <> v-cod_unid_negoc THEN NEXT.
        END.

        ASSIGN v-cod_unid_negoc-aux = IF AVAILABLE item-uni-estab THEN item-uni-estab.cod-unid-negoc ELSE "INV":U.

        FIND FIRST fam-comerc
            WHERE fam-comerc.fm-cod-com = item.fm-cod-com NO-LOCK NO-ERROR.

        FIND FIRST tt-detalhe
            WHERE tt-detalhe.familia  = item.fm-cod-com
              AND tt-detalhe.produto  = item.it-codigo
              AND tt-detalhe.unid-neg = v-cod_unid_negoc-aux NO-ERROR.

        IF NOT AVAILABLE tt-detalhe THEN DO:
            CREATE tt-detalhe.
            ASSIGN tt-detalhe.familia      = item.fm-cod-com
                   tt-detalhe.produto      = item.it-codigo
                   tt-detalhe.unid-neg     = v-cod_unid_negoc-aux
                   tt-detalhe.desc-familia = IF AVAILABLE fam-comerc THEN fam-comerc.descricao ELSE "":U
                   tt-detalhe.desc-produto = item.desc-item.
        END.

        /** Se mes corrente, incrementa o campo correspondente **/
        IF MONTH(TODAY) = MONTH(dt-data) AND
           YEAR(TODAY)  = YEAR(dt-data)  THEN DO:
            ASSIGN tt-detalhe.faturado-qtde        = tt-detalhe.faturado-qtde - item-doc-est.quantidade
                   tt-detalhe.faturado-valor       = item-doc-est.preco-total[1] / item-doc-est.quantidade
                   tt-detalhe.faturado-valor-total = tt-detalhe.faturado-valor-total - item-doc-est.preco-total[1]
                   tt-detalhe.faturado-regs        = tt-detalhe.faturado-regs + 1.
        END.
        ELSE DO:
            ASSIGN tt-detalhe.quantidade[i-mes]  = tt-detalhe.quantidade[i-mes] - item-doc-est.quantidade
                   tt-detalhe.valor[i-mes]       = item-doc-est.preco-total[1] / item-doc-est.quantidade
                   tt-detalhe.valor-total[i-mes] = tt-detalhe.valor-total[i-mes] - item-doc-est.preco-total[1]
                   tt-detalhe.registros[i-mes]   = tt-detalhe.registros[i-mes] + 1
                   tt-detalhe.periodo[i-mes]     = c-periodo.
        END.
    END.
END. /** DO **/

/** CARTEIRA **/
FOR EACH ped-venda NO-LOCK
    WHERE (ped-venda.nome-abrev  = emitente.nome-abrev
      AND  ped-venda.cod-sit-ped = 1)
       OR (ped-venda.nome-abrev  = emitente.nome-abrev
      AND  ped-venda.cod-sit-ped = 2)
       OR (ped-venda.nome-abrev  = emitente.nome-abrev
      AND  ped-venda.cod-sit-ped = 5),
    FIRST tt-repres
    WHERE tt-repres.no-ab-reppri = ped-venda.no-ab-reppri,
    EACH ped-item NO-LOCK
    WHERE (ped-item.nome-abrev    = ped-venda.nome-abrev
      AND  ped-item.nr-pedcli     = ped-venda.nr-pedcli
      AND  ped-item.ind-componen  = 1
      AND  ped-item.cod-sit-item  = 1
      AND  ped-item.dt-entrega   <= dt-final)
       OR (ped-item.nome-abrev    = ped-venda.nome-abrev
      AND  ped-item.nr-pedcli     = ped-venda.nr-pedcli
      AND  ped-item.ind-componen  = 1
      AND  ped-item.cod-sit-item  = 2
      AND  ped-item.dt-entrega   <= dt-final)
       OR (ped-item.nome-abrev    = ped-venda.nome-abrev
      AND  ped-item.nr-pedcli     = ped-venda.nr-pedcli
      AND  ped-item.ind-componen  = 1
      AND  ped-item.cod-sit-item  = 5
      AND  ped-item.dt-entrega   <= dt-final),
    FIRST natur-oper USE-INDEX natureza NO-LOCK
    WHERE natur-oper.nat-operacao = ped-venda.nat-operacao
      AND (NOT ped-venda.nat-operacao BEGINS "59":U
       OR  ped-venda.nat-operacao     BEGINS "59499":U)
      AND  NOT ped-venda.nat-operacao BEGINS "69":U
      AND  natur-oper.atual-estat,
    FIRST moeda NO-LOCK
    WHERE moeda.mo-codigo = ped-venda.mo-codigo,
    FIRST item NO-LOCK
    WHERE item.it-codigo = ped-item.it-codigo:

    FIND FIRST item-uni-estab
        WHERE item-uni-estab.it-codigo   = item.it-codigo
          AND item-uni-estab.cod-estabel = ped-venda.cod-estabel NO-LOCK NO-ERROR.

    IF NOT l-todas-un-neg THEN DO:
        IF NOT AVAILABLE item-uni-estab                      OR
           item-uni-estab.cod-unid-negoc <> v-cod_unid_negoc THEN NEXT.
    END.

    ASSIGN v-cod_unid_negoc-aux = IF AVAILABLE item-uni-estab THEN item-uni-estab.cod-unid-negoc ELSE "INV":U.

    FIND FIRST fam-comerc
        WHERE fam-comerc.fm-cod-com = item.fm-cod-com NO-LOCK NO-ERROR.

    FIND FIRST tt-detalhe
        WHERE tt-detalhe.familia  = item.fm-cod-com
          AND tt-detalhe.produto  = item.it-codigo
          AND tt-detalhe.unid-neg = v-cod_unid_negoc-aux NO-ERROR.

    IF NOT AVAILABLE tt-detalhe THEN DO:
        CREATE tt-detalhe.
        ASSIGN tt-detalhe.familia      = item.fm-cod-com
               tt-detalhe.produto      = item.it-codigo
               tt-detalhe.unid-neg     = v-cod_unid_negoc-aux
               tt-detalhe.desc-familia = IF AVAILABLE fam-comerc THEN fam-comerc.descricao ELSE "":U
               tt-detalhe.desc-produto = item.desc-item.
    END.

    FIND FIRST cotacao
        WHERE cotacao.mo-codigo   = moeda.mo-codigo
          AND cotacao.ano-periodo = STRING(YEAR(TODAY), "9999":U) + STRING(MONTH(TODAY), "99":U) NO-LOCK NO-ERROR.

    ASSIGN tt-detalhe.carteira-qtde        = tt-detalhe.carteira-qtde + ped-item.qt-pedida - ped-item.qt-atendida
           tt-detalhe.carteira-valor       = (ped-item.vl-preuni * (IF AVAILABLE cotacao AND (cotacao.cotacao[DAY(TODAY)] <> 0) THEN cotacao.cotacao[DAY(TODAY)] ELSE 1))
           tt-detalhe.carteira-valor-total = tt-detalhe.carteira-valor-total + ((ped-item.vl-preuni * (IF AVAILABLE cotacao AND (cotacao.cotacao[DAY(TODAY)] <> 0) THEN cotacao.cotacao[DAY(TODAY)] ELSE 1)) * (ped-item.qt-pedida - ped-item.qt-atendida))
           tt-detalhe.carteira-regs        = tt-detalhe.carteira-regs + 1.
END.

DELETE WIDGET-POOL.

RETURN "OK":U.

