DEFINE TEMP-TABLE tt-item
    FIELD cod-ean13      AS CHARACTER
    FIELD it-codigo      AS CHARACTER
    FIELD desc-item      AS CHARACTER FORMAT "x(60)"
    FIELD cod-unid-negoc AS CHARACTER
    FIELD des-unid-negoc AS CHARACTER.

DEFINE TEMP-TABLE tt-ean
    FIELD cod-ean13 AS CHARACTER
    FIELD it-codigo AS CHARACTER
    FIELD desc-item AS CHARACTER FORMAT "x(60)"
    FIELD cont      AS INTEGER.
