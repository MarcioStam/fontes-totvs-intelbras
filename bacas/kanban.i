DEF TEMP-TABLE tt-param NO-UNDO
    FIELD log-isec     AS  LOG
    FIELD log-inet     AS  LOG
    FIELD log-icom     AS  LOG
    FIELD log-liberado AS  LOG
    FIELD log-estoque  AS  LOG
    FIELD dat-corte    AS DATE.

DEF TEMP-TABLE tt-saldo NO-UNDO
    FIELD cod-estabel   LIKE saldo-estoq.cod-estabel
    FIELD cod-depos     LIKE saldo-estoq.cod-depos
    FIELD it-codigo     LIKE saldo-estoq.it-codigo
    FIELD qtd-transito    AS DEC
    FIELD qtd-saldo       AS DEC
    FIELD qtd-alocada     AS DEC
    INDEX id-saldo
            cod-estabel
            cod-depos  
            it-codigo
    INDEX id-item
            it-codigo.

DEF TEMP-TABLE tt-grupo-kanban NO-UNDO
    FIELD ge-codigo LIKE ITEM.ge-codigo
    INDEX id-codigo
            ge-codigo.

DEF TEMP-TABLE tt-unid-kanban NO-UNDO
    FIELD cod_unid_neg LIKE unid-neg-item.cod_unid_neg
    INDEX id-unidade
            cod_unid_neg.

DEF TEMP-TABLE tt-saldo-kanban NO-UNDO
    FIELD cod-estabel LIKE saldo-estoq.cod-estabel
    FIELD cod-depos   LIKE saldo-estoq.cod-depos
    FIELD cod-localiz LIKE saldo-estoq.cod-localiz
    INDEX id-saldo
            cod-estabel
            cod-depos
            cod-localiz.

DEF TEMP-TABLE tt-emit-kanban NO-UNDO
    FIELD cod-estabel  LIKE estabelec.cod-estabel
    FIELD cod-emitente LIKE emitente.cod-emitente
    INDEX id-emit
            cod-estabel
            cod-emitente.

DEF TEMP-TABLE tt-produzir NO-UNDO
    FIELD it-codigo      LIKE  ITEM.it-codigo
    FIELD desc-item      LIKE  ITEM.desc-item
    FIELD cod_unid_neg   LIKE  unid-neg-item.cod_unid_neg
    FIELD cod-estabel    LIKE  int-kanban-eletronico.cod-estabel
    FIELD num-seq-kanban LIKE  int-kanban-eletronico.num-seq-kanban
    FIELD qtd-produzir     AS  DEC FORMAT "->>>,>>9"   LABEL "Produzir"
    FIELD qtd-cartao       AS  DEC FORMAT "->>>,>>9"   LABEL "Cartäes"
    FIELD qtd-lote-mult    AS  DEC FORMAT "->>>,>>9"   LABEL "Lote"
    FIELD qtd-estoq-max    AS  DEC FORMAT "->>>,>>9"   LABEL "Estoq. Max"
    FIELD qtd-aca-101      AS  DEC FORMAT "->>>,>>9"   LABEL "ACA-101"
    FIELD qtd-aca-104      AS  DEC FORMAT "->>>,>>9"   LABEL "ACA-104"
    FIELD qtd-exp-104      AS  DEC FORMAT "->>>,>>9"   LABEL "EXP-104"
    FIELD qtd-transito     AS  DEC FORMAT "->>>,>>9"   LABEL "Trƒnsito"
    FIELD qtd-blo-104      AS  DEC FORMAT "->>>,>>9"   LABEL "BLO-104"
    FIELD qtd-dispon       AS  DEC FORMAT "->>>,>>9"   LABEL "Dispon¡vel"                                         
    FIELD qtd-alocada      AS  DEC FORMAT "->>>,>>9"   LABEL "Alocada"
    FIELD qtd-sdo-total    AS  DEC FORMAT "->,>>>,>>9" LABEL "Estoque Total"
    FIELD log-liberar      AS CHAR FORMAT "x(01)"      LABEL "X"
    FIELD cod-usuar        AS CHAR FORMAT "x(12)"      LABEL "Usuar Lib"
    FIELD dat-liberac      AS DATE FORMAT "99/99/9999" LABEL "Data Lib"
    FIELD cod-usuar-est    AS CHAR FORMAT "x(12)"      LABEL "Usuar Estorno"
    FIELD dat-estorno      AS DATE FORMAT "99/99/9999" LABEL "Data Estorno"
    INDEX id-item
            it-codigo.

DEF TEMP-TABLE tt-usuar-estorno NO-UNDO
    FIELD cod-usuario AS CHAR
    INDEX id-usuario
            cod-usuario.

