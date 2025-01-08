DEF TEMP-TABLE tt-ean
    FIELD cod-ean13 AS CHAR
    FIELD it-codigo AS CHAR
    FIELD desc-item AS CHAR
    FIELD cont      AS INTEGER.

PROCEDURE checa-ean.

    DEF INPUT PARAMETER c-ean AS CHAR.
    DEF INPUT-OUTPUT PARAMETER TABLE FOR tt-ean.
    DEF VAR vcont AS INTEGER.
    

    FIND FIRST item-mat NO-LOCK
       WHERE item-mat.cod-ean = c-ean NO-ERROR.
    IF NOT AVAIL item-mat THEN DO:
        
        FIND FIRST num-serie WHERE num-serie.n-serie = c-ean NO-LOCK NO-ERROR.
        IF NOT AVAIL num-serie THEN DO:

            FIND FIRST item-mat NO-LOCK
                WHERE item-mat.it-codigo = c-ean NO-ERROR.

            IF AVAIL item-mat THEN
                ASSIGN c-ean = item-mat.cod-ean.
            ELSE DO:

                CREATE tt-ean.
                ASSIGN tt-ean.cod-ean13 = c-ean
                       tt-ean.it-codigo = ""
                       tt-ean.desc-item = "Item Inv lido"
                       tt-ean.cont      = 1.

            END.

        END.
        ELSE DO:
            FIND FIRST item-mat WHERE item-mat.it-codigo = num-serie.it-codigo NO-LOCK NO-ERROR.
            IF AVAIL item-mat THEN
                ASSIGN c-ean = item-mat.cod-ean.
        END.

        IF LENGTH(c-ean) = 14 THEN DO:
            FIND FIRST item-dun WHERE item-dun.cod-dun = c-ean NO-LOCK NO-ERROR.
            IF NOT AVAIL item-dun THEN DO:
                CREATE tt-ean.
                ASSIGN tt-ean.cod-ean13 = c-ean
                       tt-ean.it-codigo = ""
                       tt-ean.desc-item = "Item Inv lido"
                       tt-ean.cont      = 1.
            END.
            ELSE DO:
                FIND FIRST item-mat WHERE item-mat.it-codigo = item-dun.it-codigo NO-LOCK NO-ERROR.
                IF AVAIL item-mat THEN
                    ASSIGN c-ean = item-mat.cod-ean.
            END.
        END.



    END.
                  
    ASSIGN vcont = 0.
    FOR EACH item-mat NO-LOCK
       WHERE item-mat.cod-ean = c-ean:

        FIND FIRST ITEM NO-LOCK
            WHERE ITEM.it-codigo = item-mat.it-codigo NO-ERROR.

        ASSIGN vcont = vcont + 1.

        CREATE tt-ean.
        ASSIGN tt-ean.cod-ean13 = item-mat.cod-ean
               tt-ean.it-codigo = item-mat.it-codigo
               tt-ean.desc-item = IF AVAIL ITEM THEN ITEM.desc-item ELSE ""
               tt-ean.cont      = vcont.
    END.



END.
