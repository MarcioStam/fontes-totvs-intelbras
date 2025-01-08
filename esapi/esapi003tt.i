DEFINE TEMP-TABLE tt-ns-volume NO-UNDO LIKE ns-volume
    FIELD nome-usuar   AS   CHARACTER
    FIELD tipo         AS   CHARACTER
    .

DEFINE TEMP-TABLE tt-etiqueta
    FIELD cod-pallet    LIKE ns-volume.volume-pai    COLUMN-LABEL "Pallet"
    FIELD cod-caixa     LIKE ns-volume.volume-pai    COLUMN-LABEL "Caixa"
    FIELD cod-produto   LIKE ns-volume.volume-pai    COLUMN-LABEL "Item"
    FIELD data          LIKE ns-volume.data          COLUMN-LABEL "Data"
    FIELD nom-usuar     AS CHARACTER FORMAT "X(60)"  COLUMN-LABEL "Usu rio"
    INDEX cd cod-pallet cod-caixa cod-produto.

DEFINE TEMP-TABLE tt-etiq-coletiva NO-UNDO LIKE etiq-coletiva
    FIELD cnm-usuar       AS CHARACTER
    FIELD cnm-usuar-reimp AS CHARACTER
    FIELD cnm-usuar-desat AS CHARACTER
    .
