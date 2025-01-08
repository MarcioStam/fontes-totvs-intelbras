define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)"
    field usuario          as char format "x(12)"
    field data-exec        as date
    field hora-exec        as integer.

DEFINE TEMP-TABLE tt-digita NO-UNDO
    FIELD it-codigo        LIKE ITEM.it-codigo
    FIELD desc-item        LIKE ITEM.desc-item
    FIELD un               LIKE ITEM.un
    FIELD cod-comprado     LIKE ITEM.cod-comprado
    FIELD nome-comprado    AS CHAR FORMAT "x(30)"
    FIELD nome-abrev       AS CHAR FORMAT "x(30)"
    FIELD saldo-atu        AS DEC  FORMAT ">>,>>>,>>9.99"
    FIELD depos            AS CHAR FORMAT "x(04)"
    FIELD local            AS CHAR FORMAT "x(75)"
    FIELD quantidade       LIKE saldo-estoq.qtidade-atu FORMAT ">>,>>>,>>9.99"
    FIELD soma             AS LOG FORMAT "*/ " .

DEFINE NEW GLOBAL SHARED TEMP-TABLE tt-valor NO-UNDO
    FIELD it-codigo        LIKE ITEM.it-codigo
    FIELD desc-item        LIKE ITEM.desc-item
    FIELD un               LIKE ITEM.un
    FIELD cod-comprado     LIKE ITEM.cod-comprado
    FIELD nome-comprado    AS CHAR FORMAT "x(30)"
    FIELD nome-abrev       AS CHAR FORMAT "x(30)"
    FIELD saldo-atu        AS DEC  FORMAT ">>,>>>,>>9.99"
    FIELD depos            AS CHAR FORMAT "x(04)"
    FIELD local            AS CHAR FORMAT "x(75)"
    FIELD quantidade       LIKE saldo-estoq.qtidade-atu FORMAT ">>,>>>,>>9.99"
    FIELD soma             AS LOG FORMAT "*/ " .

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.

DEF TEMP-TABLE tt-saldos
    FIELD it-codigo      LIKE ITEM.it-codigo
    FIELD desc-item      LIKE ITEM.desc-item
    FIELD un             LIKE ITEM.un
    FIELD cod-comprado   LIKE ITEM.cod-comprado
    FIELD nome-comprado  AS CHAR FORMAT "x(30)"
    FIELD nome-fornec    AS CHAR FORMAT "x(30)"
    FIELD de-saldo-atu   AS DEC  FORMAT ">>,>>>,>>9.99"
    FIELD Depos          AS CHAR FORMAT "x(4)"
    FIELD Local          AS CHAR FORMAT "x(93)"
    FIELD Quantidade     LIKE saldo-estoq.qtidade-atu FORMAT ">>,>>>,>>9.99" LABEL "Quantidade"
    FIELD Soma           AS LOG FORMAT "*/ " LABEL "S"
    FIELD preco          AS DECIMAL FORMAT ">>,>>9.99999"
    FIELD dt-necessidade as date
    FIELD moeda          AS CHARACTER FORMAT "x(04)"
    FIELD des-pto-contr  AS CHAR
    FIELD cod-estabel    LIKE estabelec.cod-estabel
    FIELD aliquota-ipi   LIKE cotacao-item.aliquota-ipi
    FIELD pre-unit-for   LIKE cotacao-item.pre-unit-for.
