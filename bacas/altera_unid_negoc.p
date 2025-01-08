OUTPUT TO VALUE("c:\temp\item_unid_negoc.txt").

FOR EACH item
    WHERE item.cod-unid-negoc = "FIR"
    OR    item.cod-unid-negoc = "AUT"
    OR    item.cod-unid-negoc = "ACE" EXCLUSIVE-LOCK:

    ASSIGN item.cod-unid-negoc = "NOV".
    PUT item.cod-unid-negoc SKIP.

    FOR EACH item-uni-estab 
        WHERE item-uni-estab.it-codigo = item.it-codigo EXCLUSIVE-LOCK:

        ASSIGN item-uni-estab.cod-unid-negoc = "NOV".
        PUT item-uni-estab.it-codigo item-uni-estab.cod-estabel SKIP.
    END.
END.

OUTPUT CLOSE.
