OUTPUT TO c:\temp\SAC.csv CONVERT TARGET "iso8859-1".

PUT "Item;Descri‡Æo;Situa‡Æo;Telefone" SKIP.

FOR EACH item-ean 
    WHERE item-ean.fone BEGINS "SAC"
       OR item-ean.fone BEGINS "SIAC"
       OR item-ean.fone BEGINS "Rec"
       OR item-ean.fone BEGINS "Suporte: 0800",
    EACH ITEM NO-LOCK
    WHERE ITEM.it-codigo = item-ean.it-codigo:

    PUT item-ean.it-codigo ";"
        ITEM.desc-item ";"
        ITEM.cod-obsoleto ";"
        item-ean.fone SKIP.

    ASSIGN item-ean.fone = "SAC: 0800-7042767".

END.
OUTPUT CLOSE.
