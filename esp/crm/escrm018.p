/*********************************************************************************
** Programa: esp/crm/escrm018.p
** Vers∆o..: 1.00
** Data....: 05/11/2010
** Autor...: Estevan KrÅger - Exponencial TI
** Obs.....: Relat¢rio do Portal B2B.
**           C¢pia da procedure "process-zoom-devol-cli", programa "soap-b2b-devol-cli"
**           Listagem das Devoluá‰es dos Clientes de um Representante
*********************************************************************************/

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Local Temp-Table Definitions ---                                     */

DEFINE TEMP-TABLE tt-unid_negoc NO-UNDO
    FIELD cod_unid_negoc LIKE unid_negoc.cod_unid_negoc
    FIELD des_unid_negoc LIKE unid_negoc.des_unid_negoc
    INDEX idx_pri IS PRIMARY UNIQUE
        cod_unid_negoc
    INDEX idx_des_unid_negoc
        des_unid_negoc.

DEFINE TEMP-TABLE tt-devolucao NO-UNDO
   FIELD cod-rep        LIKE repres.cod-rep
   FIELD nome-abrev     LIKE repres.nome-abrev
   FIELD cod-emitente   LIKE emitente.cod-emitente
   FIELD nome-emit      LIKE emitente.nome-emit
   FIELD nr-nota-fis    LIKE devol-cli.nr-nota-fis
   FIELD serie          LIKE devol-cli.serie
   FIELD it-codigo      LIKE devol-cli.it-codigo
   FIELD desc-item      LIKE item.desc-item
   FIELD cod_unid_negoc LIKE unid_negoc.cod_unid_negoc
   FIELD des_unid_negoc LIKE unid_negoc.des_unid_negoc
   FIELD dt-devol       LIKE devol-cli.dt-devol
   FIELD sequencia      LIKE devol-cli.sequencia
   FIELD preco-total    LIKE item-doc-est.preco-total[1]
   FIELD qt-devolvida   LIKE devol-cli.qt-devolvida
   INDEX rep-emit
        cod-rep
        nome-emit
        cod-emitente
        dt-devol
        nr-nota-fis
        serie
        sequencia.

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE i-cont           AS INTEGER                         NO-UNDO.
DEFINE VARIABLE l-todas-un       AS LOGICAL                         NO-UNDO INITIAL YES.
DEFINE VARIABLE v-cod-unid-negoc LIKE item-uni-estab.cod-unid-negoc NO-UNDO.

/* Parameters Definitions ---                                           */

DEFINE INPUT  PARAMETER p-cod-estabel    AS CHARACTER   NO-UNDO.
DEFINE INPUT  PARAMETER p-cod-rep        AS INTEGER     NO-UNDO.
DEFINE INPUT  PARAMETER p-des_unid_negoc AS CHARACTER   NO-UNDO. /* ê utilizada a descriá∆o da Unidade de Neg¢cio pois o CRM trata este valor como chave da tabela */
DEFINE INPUT  PARAMETER p-dt-inicial     AS DATE        NO-UNDO.
DEFINE INPUT  PARAMETER p-dt-final       AS DATE        NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR tt-devolucao.


/* ***************************  Main Block  *************************** */

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

EMPTY TEMP-TABLE tt-devolucao.

FOR EACH devol-cli USE-INDEX ch-estabel NO-LOCK
    WHERE devol-cli.cod-estabel = p-cod-estabel
      AND devol-cli.dt-devol   >= p-dt-inicial
      AND devol-cli.dt-devol   <= p-dt-final,
    FIRST repres NO-LOCK
    WHERE repres.cod-rep = p-cod-rep,
    FIRST nota-fiscal USE-INDEX ch-nome-repres NO-LOCK
    WHERE nota-fiscal.no-ab-reppri = repres.nome-abrev
      AND nota-fiscal.cod-estabel  = devol-cli.cod-estabel
      AND nota-fiscal.serie        = devol-cli.serie
      AND nota-fiscal.nr-nota-fis  = devol-cli.nr-nota-fis
      AND nota-fiscal.emite-duplic = YES,
    FIRST emitente NO-LOCK
    WHERE emitente.cod-emitente = devol-cli.cod-emitente,
    FIRST item-doc-est OF devol-cli NO-LOCK,
    FIRST item NO-LOCK
    WHERE item.it-codigo = devol-cli.it-codigo:

    FIND FIRST item-uni-estab
        WHERE item-uni-estab.it-codigo   = devol-cli.it-codigo
          AND item-uni-estab.cod-estabel = devol-cli.cod-estabel NO-LOCK NO-ERROR.

    IF NOT l-todas-un THEN DO:
        IF NOT AVAILABLE item-uni-estab                                                     OR
           NOT CAN-FIND(FIRST tt-unid_negoc
                        WHERE tt-unid_negoc.cod_unid_negoc = item-uni-estab.cod-unid-negoc) THEN NEXT.
    END.

    ASSIGN v-cod-unid-negoc = IF AVAILABLE item-uni-estab THEN item-uni-estab.cod-unid-negoc ELSE "INV":U.

    FIND FIRST unid_negoc
        WHERE unid_negoc.cod_unid_negoc = v-cod-unid-negoc NO-LOCK NO-ERROR.

    CREATE tt-devolucao.
    ASSIGN tt-devolucao.cod-rep        = repres.cod-rep
           tt-devolucao.nome-abrev     = repres.nome-abrev
           tt-devolucao.cod-emitente   = emitente.cod-emitente
           tt-devolucao.nome-emit      = emitente.nome-emit
           tt-devolucao.nr-nota-fis    = nota-fiscal.nr-nota-fis
           tt-devolucao.serie          = nota-fiscal.serie
           tt-devolucao.it-codigo      = devol-cli.it-codigo
           tt-devolucao.desc-item      = item.desc-item
           tt-devolucao.cod_unid_negoc = v-cod-unid-negoc
           tt-devolucao.des_unid_negoc = IF AVAILABLE unid_negoc THEN unid_negoc.des_unid_negoc ELSE "":U
           tt-devolucao.dt-devol       = devol-cli.dt-devol
           tt-devolucao.sequencia      = devol-cli.sequencia
           tt-devolucao.preco-total    = item-doc-est.preco-total[1].
           tt-devolucao.qt-devolvida   = devol-cli.qt-devolvida.
END.

DELETE WIDGET-POOL.

RETURN "OK":U.

