FOR FIRST num-serie
    WHERE num-serie.n-serie = tt-lista-ns.num-serie NO-LOCK:

    IF lastec THEN DO:
        FOR FIRST item FIELDS(cod-estabel)
            WHERE item.it-codigo = item-ean.it-codigo NO-LOCK:
                FOR FIRST estabelec
                    WHERE estabelec.cod-estabel = item.cod-estabel NO-LOCK:
                END.
        END.
    END.
    ELSE DO:
        FIND FIRST estabelec 
            WHERE estabelec.cod-estabel = v_cod_estab_usuar /*num-serie.cod-estabel*/ NO-LOCK NO-ERROR.
    END.

    ASSIGN c-cgc  = STRING(estabelec.cgc,"99.999.999/9999-99").
END.
