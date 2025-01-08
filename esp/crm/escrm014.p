/*********************************************************************************
** Programa: esp/crm/escrm014.p
** Vers∆o..: 1.00
** Data....: 03/11/2010
** Autor...: Estevan KrÅger - Exponencial TI
** Obs.....: Relat¢rio do Portal B2B.
**           C¢pia da procedure "process-zoom-cota", programa "soap-b2b-cota-rep"
**           Listagem de Cotas do Representante
*********************************************************************************/

CREATE WIDGET-POOL.


/*--- Definiá∆o das Temp-Tables ---*/
DEFINE TEMP-TABLE tt-erro NO-UNDO
    FIELD mensagem      AS CHARACTER FORMAT "x(100)".

DEFINE TEMP-TABLE tt-cota NO-UNDO
    FIELD cod-estabel     LIKE cota-representante.cod-estabel
    FIELD cod-diretoria   LIKE diretoria.cod-diretoria
    FIELD nome-diretoria  LIKE diretoria.nome
    FIELD cod-gerente     LIKE int-repres.cod-gerente
    FIELD nome-gerente    LIKE gerente.nome
    FIELD cod-rep         LIKE cota-representante.cod-rep
    FIELD nome-abrev      LIKE repres.nome-abrev
    FIELD fm-cod-com      LIKE cota-representante.fm-cod-com
    FIELD desc-fm-cod-com LIKE fam-comerc.descricao
    FIELD desc-unid-negoc AS CHARACTER
    FIELD it-codigo       LIKE cota-representante.it-codigo
    FIELD desc-item       LIKE ITEM.desc-item
    FIELD qt-cota         AS INTEGER
    FIELD qt-faturado     AS INTEGER
    FIELD qt-devolvido    AS INTEGER
    FIELD qt-carteira     AS INTEGER
    INDEX ch-cota         AS PRIMARY UNIQUE cod-estabel cod-diretoria cod-gerente nome-abrev fm-cod-com it-codigo.

DEFINE TEMP-TABLE tt-cota-final NO-UNDO LIKE tt-cota
    FIELD qt-fatmenosdev  AS DECIMAL
    FIELD qt-faturar      AS DECIMAL
    FIELD qt-saldo-vender AS DECIMAL
    FIELD perc-realizado  AS DECIMAL.

DEFINE TEMP-TABLE tt-repres NO-UNDO
   FIELD cod-rep        LIKE repres.cod-rep
   FIELD no-ab-reppri   LIKE repres.nome-abrev
   INDEX ch-rep         AS PRIMARY UNIQUE cod-rep.



/*--- ParÉmetros do Programa ---*/
DEFINE INPUT  PARAMETER p-cod-estabel     AS CHARACTER   NO-UNDO.
DEFINE INPUT  PARAMETER p-cod-repres      AS CHARACTER   NO-UNDO.
DEFINE INPUT  PARAMETER p-dt-inicial      AS DATE        NO-UNDO.
DEFINE INPUT  PARAMETER p-diretoria       AS LOGICAL     NO-UNDO.
DEFINE INPUT  PARAMETER p-gerente         AS LOGICAL     NO-UNDO.
DEFINE INPUT  PARAMETER p-repres          AS LOGICAL     NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR tt-cota-final.
DEFINE OUTPUT PARAMETER TABLE FOR tt-erro.



/*--- Definiá∆o das Vari†veis ---*/
DEFINE VARIABLE i                 AS INTEGER     NO-UNDO.
DEFINE VARIABLE j                 AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-cod-rep         AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-cod-gerente     AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-gerente         AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-quantidade      AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-cod-familia     AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-cod-sub-familia AS INTEGER     NO-UNDO.
DEFINE VARIABLE c-diretoria       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-cod-rep         AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-unid-neg        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-cod-familia     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-cod-sub-familia AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-cod-estabel     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-repres          AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-descricao       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-desc-item       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE dt-inicial        AS DATE        NO-UNDO.
DEFINE VARIABLE dt-final          AS DATE        NO-UNDO.
DEFINE VARIABLE dt-data           AS DATE        NO-UNDO.
DEFINE VARIABLE l-diretoria       AS LOGICAL     NO-UNDO INIT YES.
DEFINE VARIABLE l-gerente         AS LOGICAL     NO-UNDO INIT NO.
DEFINE VARIABLE l-repres          AS LOGICAL     NO-UNDO INIT NO.
DEFINE VARIABLE c-cod-unid-negoc  AS CHARACTER   NO-UNDO.



/*--- Bloco Principal ---*/
ASSIGN c-cod-estabel = p-cod-estabel
       l-diretoria   = p-diretoria
       l-gerente     = p-gerente
       l-repres      = p-repres.


/** Periodo de um mes inteiro **/
ASSIGN dt-inicial = p-dt-inicial
       dt-final   = DATE(IF MONTH(dt-inicial) < 12 THEN MONTH(dt-inicial) + 1 ELSE 1, 1, IF MONTH(dt-inicial) < 12 THEN YEAR(dt-inicial) ELSE YEAR(dt-inicial) + 1) - 1.


/** Ver quais os representantes que devem ser pesquisados **/
IF  p-cod-repres <> "0" AND p-cod-repres <> "?" THEN DO:
    DO j = 1 TO NUM-ENTRIES(p-cod-repres, ";"):
        FIND FIRST repres NO-LOCK
            WHERE  repres.cod-rep = INT(ENTRY(j, p-cod-repres, ";")) NO-ERROR.
        IF  AVAIL  repres THEN DO:
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



/** Popula a tt com as cotas **/
FOR EACH  tt-repres NO-LOCK,
    EACH  cota-representante NO-LOCK
    WHERE cota-representante.cod-estabel = c-cod-estabel
    AND   cota-representante.cod-rep     = tt-repres.cod-rep
    AND   cota-representante.periodo    >= STRING(YEAR(dt-inicial), "9999") + STRING(MONTH(dt-inicial), "99")
    AND   cota-representante.periodo    <= STRING(YEAR(dt-final), "9999")   + STRING(MONTH(dt-final), "99"):

    /* Somente Cotas com valor */
    IF cota-representante.qt-representante <= 0 THEN NEXT.
    FIND FIRST ITEM
        WHERE ITEM.fm-cod-com = cota-representante.fm-cod-com NO-LOCK NO-ERROR.

    ASSIGN c-diretoria = "".
    IF  cota-representante.it-codigo = ? THEN
         FIND item-uni-estab NO-LOCK
            WHERE item-uni-estab.it-codigo   = ITEM.it-codigo
              AND item-uni-estab.cod-estabel = c-cod-estabel NO-ERROR.
    ELSE
        FIND item-uni-estab NO-LOCK
            WHERE item-uni-estab.it-codigo   = cota-representante.it-codigo
              AND item-uni-estab.cod-estabel = c-cod-estabel NO-ERROR.

    IF  AVAIL item-uni-estab 
    THEN
        ASSIGN c-diretoria = item-uni-estab.cod-unid-negoc.

    FIND FIRST int-repres
        WHERE int-repres.cod-rep = cota-representante.cod-rep NO-LOCK NO-ERROR.

    ASSIGN i-cod-gerente = IF AVAILABLE int-repres THEN int-repres.cod-gerente ELSE 0.

    FIND FIRST tt-cota EXCLUSIVE-LOCK
        WHERE  tt-cota.cod-estabel   = cota-representante.cod-estabel
        AND    tt-cota.cod-diretoria = c-diretoria
        AND    tt-cota.cod-gerente   = i-cod-gerente
        AND    tt-cota.cod-rep       = cota-representante.cod-rep
        AND    tt-cota.nome-abrev    = tt-repres.no-ab-reppri
        AND    tt-cota.fm-cod-com    = cota-representante.fm-cod-com
        AND    tt-cota.it-codigo     = cota-representante.it-codigo NO-ERROR.
    IF  NOT AVAIL tt-cota THEN DO:
        CREATE tt-cota.
        ASSIGN tt-cota.cod-estabel   = cota-representante.cod-estabel
               tt-cota.cod-diretoria = c-diretoria
               tt-cota.cod-gerente   = i-cod-gerente
               tt-cota.cod-rep       = cota-representante.cod-rep
               tt-cota.nome-abrev    = tt-repres.no-ab-reppri
               tt-cota.fm-cod-com    = cota-representante.fm-cod-com
               tt-cota.it-codigo     = cota-representante.it-codigo.

/*         PUT "cota-repres " cota-representante.cod-estabel   " " */
/*                            c-diretoria                      " " */
/*                            i-cod-gerente                    " " */
/*                            cota-representante.cod-rep       " " */
/*                            tt-repres.no-ab-reppri           " " */
/*                            cota-representante.fm-cod-com    " " */
/*                            cota-representante.it-codigo SKIP.   */
/*                                                                 */



        FIND FIRST unid_negoc
             WHERE unid_negoc.cod_unid_negoc =  tt-cota.cod-diretoria NO-LOCK NO-ERROR.

        IF AVAIL unid_negoc THEN
            ASSIGN tt-cota.desc-unid-negoc = unid_negoc.des_unid_negoc.

        RELEASE unid_negoc.
    END.

    ASSIGN tt-cota.qt-cota = tt-cota.qt-cota + cota-representante.qt-representante.
   END.



/** FATURAMENTO **/
DO dt-data = dt-inicial TO dt-final:
    FOR EACH nota-fiscal FIELDS(cod-estabel no-ab-reppri) NO-LOCK USE-INDEX ch-distancia
        WHERE nota-fiscal.dt-emis-nota = dt-data
        AND   nota-fiscal.dt-cancel    = ?
        AND   nota-fiscal.emite-duplic,
        FIRST tt-repres NO-LOCK
        WHERE tt-repres.no-ab-reppri = nota-fiscal.no-ab-reppri,
        FIRST natur-oper FIELDS (atual-estat) NO-LOCK
        WHERE natur-oper.nat-operacao = nota-fiscal.nat-operacao
        AND   natur-oper.atual-estat,
        EACH it-nota-fisc FIELDS (vl-merc-liq cod-estabel serie nr-nota-fis nr-seq-fat it-codigo qt-faturada) OF nota-fiscal NO-LOCK,
        FIRST item FIELDS(it-codigo fm-cod-com) NO-LOCK
        WHERE item.it-codigo = it-nota-fisc.it-codigo:

        /** Ignorar itens que nao tem valor do item **/
        /** IF colocado devido a uma nota de substituicao tributaria **/
        /** Felipe / Claudiney - 03/07/2006 **/
        IF  NOT (it-nota-fisc.vl-merc-liq > 0) THEN
            NEXT.

        FIND FIRST item-uni-estab
            WHERE item-uni-estab.it-codigo   = it-nota-fisc.it-codigo
              AND item-uni-estab.cod-estabel = nota-fiscal.cod-estabel NO-LOCK NO-ERROR.

        ASSIGN c-cod-unid-negoc = IF AVAILABLE item-uni-estab THEN item-uni-estab.cod-unid-negoc ELSE "INV":U.
       
        FIND FIRST tt-cota
            WHERE  tt-cota.cod-estabel    = c-cod-estabel
            AND    tt-cota.cod-diretoria  = c-cod-unid-negoc
            AND    tt-cota.cod-rep        = tt-repres.cod-rep
            AND    tt-cota.nome-abrev     = tt-repres.no-ab-reppri
            AND    tt-cota.fm-cod-com     = item.fm-cod-com
            AND    tt-cota.it-codigo      = item.it-codigo NO-ERROR.
        IF  NOT AVAIL tt-cota THEN DO:
/*             PUT "1 - " c-cod-estabel               " " */
/*                 c-cod-unid-negoc                   " " */
/*                 tt-repres.cod-rep                  " " */
/*                 tt-repres.no-ab-reppri             " " */
/*                 item.fm-cod-com                    " " */
/*                 item.it-codigo SKIP.                   */

            FIND FIRST tt-cota
                WHERE  tt-cota.cod-estabel   = c-cod-estabel
                AND    tt-cota.cod-diretoria = c-cod-unid-negoc
                AND    tt-cota.cod-rep       = tt-repres.cod-rep
                AND    tt-cota.nome-abrev    = tt-repres.no-ab-reppri
                AND    tt-cota.fm-cod-com    = item.fm-cod-com
                AND    tt-cota.it-codigo     = ? NO-ERROR.
            /** Alterado conforme solicitado por Luciano e Alexandre, em 20.09.2006 **/
            IF  NOT AVAIL tt-cota THEN DO:
/*                 PUT "2 - " c-cod-estabel               " "     */
/*                         c-cod-unid-negoc                   " " */
/*                         tt-repres.cod-rep                  " " */
/*                         tt-repres.no-ab-reppri             " " */
/*                         item.fm-cod-com                    " " */
/*                         "?" SKIP.                              */
                
           
                FIND FIRST tt-cota
                    WHERE  tt-cota.cod-estabel   = c-cod-estabel
                    AND    tt-cota.cod-diretoria = c-cod-unid-negoc
                    AND    tt-cota.cod-rep       = tt-repres.cod-rep
                    AND    tt-cota.nome-abrev    = tt-repres.no-ab-reppri
                    AND    tt-cota.fm-cod-com    = item.fm-cod-com
                    AND    tt-cota.it-codigo     = "?" NO-ERROR.
                /** Alterado conforme solicitado por Luciano e Alexandre, em 20.09.2006 **/
                IF  NOT AVAIL tt-cota THEN DO:
/*                     PUT "3 - " c-cod-estabel               " "     */
/*                             c-cod-unid-negoc                   " " */
/*                             tt-repres.cod-rep                  " " */
/*                             tt-repres.no-ab-reppri             " " */
/*                             item.fm-cod-com                    " " */
/*                             "?" SKIP.                              */
                    NEXT.
                END.
            END.                
        END.

        ASSIGN tt-cota.qt-faturado = tt-cota.qt-faturado + it-nota-fisc.qt-faturada[1].
    END.
END.



/** CARTEIRA **/
/** Pesquisa por pedidos apenas se o periodo a ser exibido esta no mes atual **/
IF  ((MONTH(TODAY) = MONTH(dt-final)) AND YEAR(TODAY) = YEAR(dt-final)) THEN DO:
    FOR EACH  ped-venda FIELDS (cod-estabel no-ab-reppri) USE-INDEX ch-tabfin NO-LOCK
        WHERE ped-venda.cod-sit-ped = 1
        OR    ped-venda.cod-sit-ped = 2
        OR    ped-venda.cod-sit-ped = 5,
        FIRST tt-repres NO-LOCK
        WHERE tt-repres.no-ab-reppri = ped-venda.no-ab-reppri,
        EACH  ped-item FIELDS (qt-pedida qt-atendida nome-abrev nr-pedcli nr-sequencia it-codigo cod-refer) USE-INDEX ch-componen NO-LOCK
        WHERE (ped-item.nome-abrev  = ped-venda.nome-abrev
        AND   ped-item.nr-pedcli    = ped-venda.nr-pedcli
        AND   ped-item.ind-componen = 1
        AND   ped-item.cod-sit-item = ped-venda.cod-sit-ped
        AND   ped-item.dt-entrega   <= dt-final),
        FIRST natur-oper FIELDS (atual-estat) NO-LOCK
        WHERE natur-oper.nat-operacao = ped-venda.nat-operacao
        AND   natur-oper.atual-estat,
        FIRST item FIELDS (it-codigo fm-cod-com) NO-LOCK
        WHERE item.it-codigo = ped-item.it-codigo:

        /** IF feio, mas £til pra usar um melhor °ndice **/
       /*
        IF (ped-venda.cod-estabel <> c-cod-estabel) THEN
            NEXT.
         */

        FIND FIRST item-uni-estab
            WHERE item-uni-estab.it-codigo   = ped-item.it-codigo
              AND item-uni-estab.cod-estabel = ped-venda.cod-estabel NO-LOCK NO-ERROR.

        ASSIGN c-cod-unid-negoc = IF AVAILABLE item-uni-estab THEN item-uni-estab.cod-unid-negoc ELSE "INV":U.

        FIND FIRST tt-cota
            WHERE  tt-cota.cod-estabel   = c-cod-estabel
            AND    tt-cota.cod-diretoria = c-cod-unid-negoc
            AND    tt-cota.cod-rep       = tt-repres.cod-rep
            AND    tt-cota.nome-abrev    = tt-repres.no-ab-reppri
            AND    tt-cota.fm-cod-com    = item.fm-cod-com
            AND    tt-cota.it-codigo     = item.it-codigo NO-ERROR.
        IF NOT AVAIL tt-cota THEN DO:
            FIND FIRST tt-cota
                WHERE  tt-cota.cod-estabel   = c-cod-estabel
                AND    tt-cota.cod-diretoria = c-cod-unid-negoc
                AND    tt-cota.cod-rep       = tt-repres.cod-rep
                AND    tt-cota.nome-abrev    = tt-repres.no-ab-reppri
                AND    tt-cota.fm-cod-com    = item.fm-cod-com
                AND    tt-cota.it-codigo     = ? NO-ERROR.
            /** Alterado conforme solicitado por Luciano e Alexandre, em 20.09.2006 **/
            IF NOT AVAIL tt-cota THEN
                NEXT.
        END.


        ASSIGN tt-cota.qt-carteira = tt-cota.qt-carteira + (ped-item.qt-pedida - ped-item.qt-atendida).
    END.
END.



/** DEVOLUCAO **/
FOR EACH  devol-cli FIELDS (cod-estabel dt-devol serie nr-nota-fis cod-emitente it-codigo qt-devolvida nr-sequencia) USE-INDEX ch-dt-item NO-LOCK
    WHERE devol-cli.dt-devol   >= dt-inicial
    AND   devol-cli.dt-devol   <= dt-final,
    FIRST nota-fiscal FIELDS (cod-estabel serie nr-nota-fis no-ab-reppri) USE-INDEX ch-nota NO-LOCK
    WHERE nota-fiscal.cod-estabel   = devol-cli.cod-estabel
    AND   nota-fiscal.serie         = devol-cli.serie
    AND   nota-fiscal.nr-nota-fis   = devol-cli.nr-nota-fis
    AND   nota-fiscal.emite-duplic,
    FIRST tt-repres NO-LOCK
    WHERE tt-repres.no-ab-reppri = nota-fiscal.no-ab-reppri,
    FIRST natur-oper FIELDS (atual-estat) NO-LOCK
    WHERE natur-oper.nat-operacao = nota-fiscal.nat-operacao
    AND   natur-oper.atual-estat,
    EACH  item-doc-est FIELDS (preco-total) OF devol-cli NO-LOCK,
    FIRST item FIELDS (it-codigo fm-cod-com) NO-LOCK
    WHERE item.it-codigo = devol-cli.it-codigo:

    FIND FIRST item-uni-estab
        WHERE item-uni-estab.it-codigo   = devol-cli.it-codigo
          AND item-uni-estab.cod-estabel = nota-fiscal.cod-estabel NO-LOCK NO-ERROR.

    ASSIGN c-cod-unid-negoc = IF AVAILABLE item-uni-estab THEN item-uni-estab.cod-unid-negoc ELSE "INV":U.

    FIND FIRST tt-cota EXCLUSIVE-LOCK
        WHERE  tt-cota.cod-estabel   = c-cod-estabel
        AND    tt-cota.cod-diretoria = c-cod-unid-negoc
        AND    tt-cota.cod-rep       = tt-repres.cod-rep
        AND    tt-cota.nome-abrev    = tt-repres.no-ab-reppri
        AND    tt-cota.fm-cod-com    = item.fm-cod-com 
        AND    tt-cota.it-codigo     = item.it-codigo NO-ERROR.
    IF NOT AVAIL tt-cota THEN DO:
        FIND FIRST tt-cota
            WHERE  tt-cota.cod-estabel   = c-cod-estabel
            AND    tt-cota.cod-diretoria = c-cod-unid-negoc
            AND    tt-cota.cod-rep       = tt-repres.cod-rep
            AND    tt-cota.nome-abrev    = tt-repres.no-ab-reppri
            AND    tt-cota.fm-cod-com    = item.fm-cod-com 
            AND    tt-cota.it-codigo     = ? NO-ERROR.
        /** Alterado conforme solicitado por Luciano e Alexandre, em 20.09.2006 **/
        IF  NOT AVAIL tt-cota THEN
            NEXT.
    END.

    
    ASSIGN tt-cota.qt-devolvido = tt-cota.qt-devolvido + devol-cli.qt-devolvida.
END.



/** Cria a tt de saida **/
FOR EACH tt-cota NO-LOCK:
    IF (l-diretoria) THEN
        ASSIGN c-diretoria = tt-cota.cod-diretoria.
    ELSE
        ASSIGN c-diretoria = "".

    IF (l-gerente) THEN
        ASSIGN i-gerente = tt-cota.cod-gerente.
    ELSE
        ASSIGN i-gerente = 0.

    IF (l-repres) THEN
        ASSIGN c-repres  = tt-cota.nome-abrev
               i-cod-rep = tt-cota.cod-rep.
    ELSE
        ASSIGN c-repres  = ""
               i-cod-rep = 0.

    FIND FIRST tt-cota-final
        WHERE  tt-cota-final.cod-estabel   = tt-cota.cod-estabel
        AND    tt-cota-final.cod-diretoria = c-diretoria
        AND    tt-cota-final.cod-gerente   = i-gerente
        AND    tt-cota-final.cod-rep       = i-cod-rep
        AND    tt-cota-final.nome-abrev    = c-repres
        AND    tt-cota-final.fm-cod-com    = tt-cota.fm-cod-com
        AND    tt-cota-final.it-codigo     = tt-cota.it-codigo NO-ERROR.
    IF  NOT AVAIL tt-cota-final THEN DO:
        CREATE tt-cota-final.
        ASSIGN tt-cota-final.cod-estabel     = tt-cota.cod-estabel
               tt-cota-final.cod-diretoria   = c-diretoria
               tt-cota-final.cod-gerente     = i-gerente
               tt-cota-final.cod-rep         = i-cod-rep
               tt-cota-final.nome-abrev      = c-repres
               tt-cota-final.fm-cod-com      = tt-cota.fm-cod-com
               tt-cota-final.it-codigo       = tt-cota.it-codigo
               tt-cota-final.desc-unid-negoc = tt-cota.desc-unid-negoc.

        FIND FIRST fam-comerc NO-LOCK
            WHERE  fam-comerc.fm-cod-com = tt-cota-final.fm-cod-com NO-ERROR.

        FIND FIRST item NO-LOCK
            WHERE  item.it-codigo = tt-cota-final.it-codigo NO-ERROR.

        FIND FIRST diretoria NO-LOCK
            WHERE  diretoria.cod-diretoria = tt-cota-final.cod-diretoria NO-ERROR.

        FIND FIRST gerente NO-LOCK
            WHERE  gerente.cod-gerente = tt-cota-final.cod-gerente NO-ERROR.

        ASSIGN tt-cota-final.desc-fm-cod-com = IF AVAIL fam-comerc THEN fam-comerc.descricao ELSE ""
               tt-cota-final.desc-item       = IF AVAIL item       THEN item.desc-item       ELSE ""
               tt-cota-final.nome-diretoria  = IF AVAIL diretoria  THEN diretoria.nome       ELSE ""
               tt-cota-final.nome-gerente    = IF AVAIL gerente    THEN gerente.nome         ELSE "".
    END.

    ASSIGN tt-cota-final.qt-cota         = tt-cota-final.qt-cota      + tt-cota.qt-cota
           tt-cota-final.qt-faturado     = tt-cota-final.qt-faturado  + tt-cota.qt-faturado
           tt-cota-final.qt-devolvido    = tt-cota-final.qt-devolvido + tt-cota.qt-devolvido
           tt-cota-final.qt-carteira     = tt-cota-final.qt-carteira  + tt-cota.qt-carteira
           tt-cota-final.qt-fatmenosdev  = tt-cota-final.qt-faturado  - tt-cota-final.qt-devolvido
           tt-cota-final.qt-faturar      = tt-cota-final.qt-cota      - tt-cota-final.qt-fatmenosdev
           tt-cota-final.qt-saldo-vender = tt-cota-final.qt-faturar   - tt-cota-final.qt-carteira.

    IF  tt-cota-final.qt-cota > 0 THEN
        ASSIGN tt-cota-final.perc-realizado = (tt-cota-final.qt-fatmenosdev * 100) / tt-cota-final.qt-cota.
    ELSE
        ASSIGN tt-cota-final.perc-realizado = 0.
END.



DELETE WIDGET-POOL.
RETURN "OK":U.
