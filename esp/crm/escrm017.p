/*********************************************************************************
** Programa: esp/crm/escrm017.p
** Vers∆o..: 1.00
** Data....: 05/11/2010
** Autor...: Estevan KrÅger - Exponencial TI
** Obs.....: Relat¢rio do Portal B2B.
**           C¢pia da procedure "process-find-curva-abc", programa "soap-b2b-curva-abc"
**           Detalhe do Faturamento de um Cliente (£ltimos 6 meses), vindo da Curva ABC
*********************************************************************************/

CREATE WIDGET-POOL.


/*--- Definiá∆o das Temp-Tables ---*/
DEFINE TEMP-TABLE tt-unid NO-UNDO
   FIELD cod_unid_negoc LIKE unid-neg-fat.cod_unid_negoc
   FIELD perc-unid-neg  LIKE unid-neg-fat.perc-unid-neg
   INDEX ch-cod         IS PRIMARY UNIQUE cod_unid_negoc.

DEFINE TEMP-TABLE tt-detalhe  NO-UNDO
   FIELD familia              LIKE fam-com-item.familia1
   FIELD origem               LIKE fam-com-item.origem
   FIELD desc-familia         LIKE fam-com-item.descricao
   FIELD desc-origem          LIKE fam-com-item.descricao
   FIELD unid-neg             LIKE unid-neg-fat.cod_unid_negoc
   FIELD periodo              AS CHARACTER   EXTENT 6
   FIELD quantidade           AS INTEGER     EXTENT 6
   FIELD valor                AS DECIMAL     EXTENT 6
   FIELD valor-total          AS DECIMAL     EXTENT 6
   FIELD registros            AS INTEGER     EXTENT 6
   FIELD carteira-qtde        AS INTEGER
   FIELD carteira-valor       AS DECIMAL
   FIELD carteira-valor-total AS DECIMAL
   FIELD carteira-regs        AS INTEGER
   FIELD faturado-qtde        AS INTEGER
   FIELD faturado-valor       AS DECIMAL
   FIELD faturado-valor-total AS DECIMAL
   FIELD faturado-regs        AS INTEGER
   INDEX ch-pri               AS PRIMARY UNIQUE familia origem.



/*--- ParÉmetros do Programa ---*/
DEFINE INPUT  PARAMETER p-cod-emitente AS INTEGER     NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR tt-detalhe.



/*--- Definiá∆o das Vari†veis ---*/
DEFINE VARIABLE dt-data       AS DATE        NO-UNDO.
DEFINE VARIABLE dt-inicial    AS DATE        NO-UNDO.
DEFINE VARIABLE dt-final      AS DATE        NO-UNDO.
DEFINE VARIABLE c-periodo     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-mes         AS INTEGER     NO-UNDO INIT 0.

DEFINE BUFFER b-fam-com-item FOR fam-com-item.


/** Cria as datas com o mes inicial e o mes final para pesquisa no FOR EACH **/
ASSIGN dt-final   = DATE(MONTH(TODAY), 1, YEAR(TODAY))
       dt-inicial = ADD-INTERVAL(dt-final, -6, 'months')
       dt-final   = ADD-INTERVAL(dt-final, 1, 'months') - 1.


FIND FIRST emitente NO-LOCK
    WHERE  emitente.cod-emitente = p-cod-emitente NO-ERROR.

/** FATURAMENTO **/
DO dt-data = dt-inicial TO dt-final:
    /** Ajusta o contador a ser usado no array **/
    IF (c-periodo <> STRING(YEAR(dt-data), "9999") + STRING(MONTH(dt-data), "99")) THEN
        ASSIGN c-periodo = STRING(YEAR(dt-data), "9999") + STRING(MONTH(dt-data), "99")
               i-mes     = i-mes + 1.

    FOR EACH  nota-fiscal FIELDS (no-ab-reppri) NO-LOCK USE-INDEX ch-distancia
        WHERE nota-fiscal.dt-cancel    = ?
        AND   nota-fiscal.dt-emis-nota = dt-data
        AND   nota-fiscal.cod-emitente = emitente.cod-emitente,
        FIRST natur-oper FIELDS (atual-estat) NO-LOCK
        WHERE natur-oper.nat-operacao = nota-fiscal.nat-operacao
        AND   natur-oper.atual-estat,
        EACH  it-nota-fisc OF nota-fiscal NO-LOCK,
        FIRST item FIELDS (fm-cod-com it-codigo) NO-LOCK
        WHERE item.it-codigo = it-nota-fisc.it-codigo:

        /** Ignorar itens que nao tem valor do item **/
        /** IF colocado devido a uma nota de substituicao tributaria **/
        /** Felipe / Claudiney - 03/07/2006 **/
        IF  NOT (it-nota-fisc.vl-merc-liq > 0) THEN
            NEXT.

        FIND FIRST fam-com-item NO-LOCK
            WHERE  fam-com-item.fm-cod-com = SUBSTRING(item.fm-cod-com,1,7) NO-ERROR.

        FIND FIRST b-fam-com-item NO-LOCK
            WHERE  b-fam-com-item.fm-cod-com = item.fm-cod-com NO-ERROR.

        /** Pesquisa para saber a unidade de negocio do item da nota fiscal **/
        EMPTY TEMP-TABLE tt-unid.
        IF  NOT CAN-FIND(FIRST unid-neg-fat OF it-nota-fisc) THEN DO:
            CREATE tt-unid.
            ASSIGN tt-unid.cod_unid_negoc = 'INV'
                   tt-unid.perc-unid-neg  = 100.
        END.
        ELSE DO:
            FOR EACH unid-neg-fat OF it-nota-fisc NO-LOCK:
                CREATE tt-unid.
                ASSIGN tt-unid.cod_unid_negoc = unid-neg-fat.cod_unid_negoc
                       tt-unid.perc-unid-neg  = unid-neg-fat.perc-unid-neg.
            END.
        END.

        FOR EACH tt-unid:
            FIND FIRST tt-detalhe
                WHERE  tt-detalhe.familia = fam-com-item.fm-cod-com
                AND    tt-detalhe.origem  = b-fam-com-item.fm-cod-com NO-ERROR.
            IF  NOT AVAIL tt-detalhe THEN DO:
                CREATE tt-detalhe.
                ASSIGN tt-detalhe.familia  = fam-com-item.fm-cod-com
                       tt-detalhe.origem   = b-fam-com-item.fm-cod-com
                       tt-detalhe.unid-neg = tt-unid.cod_unid_negoc.
            END.

            /** Se mes corrente, incrementa o campo correspondente **/
            IF (MONTH(TODAY) = MONTH(dt-data)) AND (YEAR(TODAY) = YEAR(dt-data)) THEN DO:
                ASSIGN tt-detalhe.faturado-qtde        = tt-detalhe.faturado-qtde        + ((it-nota-fisc.qt-faturada[1] * tt-unid.perc-unid-neg) / 100)
                       tt-detalhe.faturado-valor       = tt-detalhe.faturado-valor       + ((it-nota-fisc.vl-preuni  * tt-unid.perc-unid-neg) / 100)
                       tt-detalhe.faturado-valor-total = tt-detalhe.faturado-valor-total + (((it-nota-fisc.vl-preuni * it-nota-fisc.qt-faturada[1]) * tt-unid.perc-unid-neg) / 100)
                       tt-detalhe.faturado-regs        = tt-detalhe.faturado-regs        + 1.
            END.
            ELSE DO:
                ASSIGN tt-detalhe.quantidade[i-mes]  = tt-detalhe.quantidade[i-mes]  + ((it-nota-fisc.qt-faturada[1] * tt-unid.perc-unid-neg) / 100)
                       tt-detalhe.valor[i-mes]       = tt-detalhe.valor[i-mes]       + ((it-nota-fisc.vl-preuni  * tt-unid.perc-unid-neg) / 100)
                       tt-detalhe.valor-total[i-mes] = tt-detalhe.valor-total[i-mes] + (((it-nota-fisc.vl-preuni * it-nota-fisc.qt-faturada[1]) * tt-unid.perc-unid-neg) / 100)
                       tt-detalhe.registros[i-mes]   = tt-detalhe.registros[i-mes]   + 1
                       tt-detalhe.periodo[i-mes]     = c-periodo.
            END.
        END.
    END.
END.


/** CARTEIRA **/
FOR EACH  ped-venda FIELDS (cod-estabel no-ab-reppri) NO-LOCK
    WHERE (ped-venda.nome-abrev  = emitente.nome-abrev
    AND   ped-venda.cod-sit-ped = 1)
    OR   (ped-venda.nome-abrev  = emitente.nome-abrev
    AND   ped-venda.cod-sit-ped = 2)
    OR   (ped-venda.nome-abrev  = emitente.nome-abrev
    AND   ped-venda.cod-sit-ped = 5),
    EACH  ped-item NO-LOCK
    WHERE (ped-item.nome-abrev   = ped-venda.nome-abrev
    AND   ped-item.nr-pedcli    = ped-venda.nr-pedcli
    AND   ped-item.ind-componen = 1
    AND   ped-item.cod-sit-item = 1
    AND   ped-item.dt-entrega   <= dt-final)
    OR   (ped-item.nome-abrev   = ped-venda.nome-abrev
    AND   ped-item.nr-pedcli    = ped-venda.nr-pedcli
    AND   ped-item.ind-componen = 1
    AND   ped-item.cod-sit-item = 2
    AND   ped-item.dt-entrega  <= dt-final)
    OR   (ped-item.nome-abrev   = ped-venda.nome-abrev
    AND   ped-item.nr-pedcli    = ped-venda.nr-pedcli
    AND   ped-item.ind-componen = 1
    AND   ped-item.cod-sit-item = 5
    AND   ped-item.dt-entrega   <= dt-final),
    FIRST natur-oper FIELDS (emite-duplic) NO-LOCK
    WHERE natur-oper.nat-operacao = ped-venda.nat-operacao
    AND  (NOT ped-venda.nat-operacao BEGINS '59' OR
          ped-venda.nat-operacao BEGINS '59499')
    AND   NOT ped-venda.nat-operacao BEGINS '69'
    AND   natur-oper.atual-estat,
    FIRST moeda FIELDS (mo-codigo) NO-LOCK
    WHERE moeda.mo-codigo = ped-venda.mo-codigo,
    FIRST item FIELDS (fm-cod-com it-codigo) NO-LOCK
    WHERE item.it-codigo = ped-item.it-codigo:

    
    FIND FIRST fam-com-item NO-LOCK
        WHERE  fam-com-item.fm-cod-com = SUBSTRING(item.fm-cod-com,1,7) NO-ERROR.

    FIND FIRST b-fam-com-item NO-LOCK
        WHERE  b-fam-com-item.fm-cod-com = item.fm-cod-com NO-ERROR.


    EMPTY TEMP-TABLE tt-unid.
    IF  NOT CAN-FIND(FIRST unid-neg-ped OF ped-item) THEN DO:
        CREATE tt-unid.
        ASSIGN tt-unid.cod_unid_negoc = 'INV'
               tt-unid.perc-unid-neg  = 100.
    END.
    ELSE DO:
        FOR EACH unid-neg-ped OF ped-item NO-LOCK:
            CREATE tt-unid.
            ASSIGN tt-unid.cod_unid_negoc = unid-neg-ped.cod_unid_negoc
                   tt-unid.perc-unid-neg  = unid-neg-ped.perc-unid-neg.
        END.
    END.

    FOR EACH tt-unid:
        FIND FIRST tt-detalhe
            WHERE tt-detalhe.familia = fam-com-item.fm-cod-com
            AND tt-detalhe.origem    = b-fam-com-item.fm-cod-com NO-ERROR.
        IF  NOT AVAILABLE (tt-detalhe) THEN DO:
            CREATE tt-detalhe.
            ASSIGN tt-detalhe.familia  = fam-com-item.fm-cod-com                   
                   tt-detalhe.origem   = b-fam-com-item.fm-cod-com
                   tt-detalhe.unid-neg = tt-unid.cod_unid_negoc.
        END.

        FIND FIRST cotacao NO-LOCK
            WHERE  cotacao.mo-codigo   = moeda.mo-codigo
            AND    cotacao.ano-periodo = STRING(YEAR(TODAY), "9999") + STRING(MONTH(TODAY), "99") NO-ERROR.
            
        ASSIGN tt-detalhe.carteira-qtde        = tt-detalhe.carteira-qtde        + (((ped-item.qt-pedida - ped-item.qt-atendida) * tt-unid.perc-unid-neg) / 100)
               tt-detalhe.carteira-valor       = tt-detalhe.carteira-valor       + (((ped-item.vl-preuni  * (IF AVAILABLE (cotacao) AND (cotacao.cotacao[DAY(TODAY)] <> 0) THEN cotacao.cotacao[DAY(TODAY)] ELSE 1)) * tt-unid.perc-unid-neg) / 100)
               tt-detalhe.carteira-valor-total = tt-detalhe.carteira-valor-total + ((((ped-item.vl-preuni * (IF AVAILABLE (cotacao) AND (cotacao.cotacao[DAY(TODAY)] <> 0) THEN cotacao.cotacao[DAY(TODAY)] ELSE 1)) * (ped-item.qt-pedida - ped-item.qt-atendida)) * tt-unid.perc-unid-neg) / 100)
               tt-detalhe.carteira-regs        = tt-detalhe.carteira-regs        + 1.
    END.
END.



DELETE WIDGET-POOL.
RETURN "OK":U.
