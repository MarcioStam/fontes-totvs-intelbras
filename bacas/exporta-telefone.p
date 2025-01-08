DEFINE VARIABLE c-aux AS CHARACTER NO-UNDO.

ASSIGN c-aux = "SAC: 0800-7042767;Suporte: (48) 2106-0006;Suporte: (48) 2106-0071;Suporte: (48) 2106-0072;Suporte: (48) 3281-9673".

OUTPUT TO c:\temp\SAC.csv CONVERT TARGET "iso8859-1".

PUT "Item;Descri‡Æo;Situa‡Æo;Telefone" SKIP.
    
FOR EACH item-ean
    WHERE item-ean.fone <> "" NO-LOCK,
    FIRST item
    WHERE item.it-codigo = item-ean.it-codigo NO-LOCK:

    IF LOOKUP(item-ean.fone,c-aux,";") = 0 THEN
        PUT item-ean.it-codigo ";"
            ITEM.desc-item ";"
            ITEM.cod-obsoleto ";"
            item-ean.fone SKIP.
END.

OUTPUT CLOSE.
