DEFINE TEMP-TABLE tt-ordem-compra-ped NO-UNDO
    FIELD numero-ordem LIKE ordem-compra.numero-ordem
    INDEX chPrimario IS PRIMARY UNIQUE
        numero-ordem.

