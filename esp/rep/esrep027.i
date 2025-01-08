DEF TEMP-TABLE ttitem-doc-est
    FIELD serie-docto   LIKE item-doc-est.serie-docto
    FIELD nro-docto     LIKE item-doc-est.nro-docto
    FIELD cod-emitente  LIKE item-doc-est.cod-emitente
    FIELD nat-operacao  LIKE item-doc-est.nat-operacao
    FIELD sequencia     LIKE item-doc-est.sequencia
    FIELD it-codigo     LIKE item-doc-est.it-codigo
    FIELD desc-item     AS CHAR FORMAT "x(60)"
    FIELD quantidade    LIKE item-doc-est.quantidade
    FIELD qtd-cdb       LIKE item-doc-est.quantidade
    INDEX nota serie-docto nro-docto cod-emitente nat-operacao
    INDEX seq sequencia.
