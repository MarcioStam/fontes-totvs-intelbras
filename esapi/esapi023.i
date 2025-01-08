DEFINE TEMP-TABLE ttitem
    FIELD it-codigo  LIKE ordem-compra.it-codigo
    FIELD num-pedido LIKE ordem-compra.num-pedido
    FIELD desc-item  LIKE item.desc-item
    FIELD projeto    LIKE mac-address.projeto
    FIELD just-proj  LIKE mac-address.just-proj
    FIELD qtd-mac    LIKE mac-address.qtd-mac
    FIELD buffer-mac LIKE int-item-fornec.buffer-mac
    FIELD marcado    AS LOGICAL FORMAT "*/ " INITIAL NO    
    FIELD qt-pedido  AS INTEGER
    FIELD gerado-ns  AS INTEGER
    FIELD gerado-mac AS INTEGER   
    INDEX item1 it-codigo
    INDEX marc1 marcado.

DEFINE TEMP-TABLE ttarq
    FIELD it-codigo  LIKE ordem-compra.it-codigo
    FIELD num-serie  AS CHARACTER
    FIELD ns-keycode AS CHARACTER
    INDEX it it-codigo num-serie.

DEFINE TEMP-TABLE tt-mac-address NO-UNDO LIKE mac-address
    FIELD r-Rowid    AS ROWID
    FIELD ref-buffer AS LOGICAL
    FIELD senha-wifi AS CHAR
    FIELD senha-adm  AS CHAR.

DEFINE TEMP-TABLE tt-int-item-fornec NO-UNDO LIKE int-item-fornec
    FIELD r-rowid AS ROWID
    .
