DEF TEMP-TABLE ttitem
    FIELD marcado   AS LOGICAL FORMAT "*/ " INITIAL NO
    FIELD it-codigo LIKE ordem-compra.it-codigo
    FIELD desc-item LIKE ITEM.desc-item
    FIELD qt-pedido  AS INT
    FIELD gerado-ns AS INT
    FIELD gerado-mac AS INT
    INDEX item1 it-codigo
    INDEX marc1 marcado.

DEF TEMP-TABLE ttarq
        FIELD it-codigo  LIKE ordem-compra.it-codigo
        FIELD num-serie  AS CHAR
        FIELD ns-keycode AS CHAR
        INDEX it it-codigo num-serie.
