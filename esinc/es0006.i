DEF TEMP-TABLE tt_unid_negoc
    FIELD cod_unid_negoc   AS CHAR FORMAT "X(3)"
    FIELD perc_unid_negoc  LIKE unid-neg-item.perc-unid-neg
    INDEX tt_unid_negoc IS PRIMARY UNIQUE cod_unid_negoc.

PROCEDURE pi-busca-unid-negoc-item.
    DEF INPUT PARAM c-item          LIKE ITEM.it-codigo.
    DEF INPUT PARAM c-fam-com       LIKE ITEM.fm-cod-com.
    DEF OUTPUT PARAM TABLE FOR tt_unid_negoc.
    
    FOR EACH tt_unid_negoc:
        DELETE tt_unid_negoc.
    END.
    
    IF CAN-find(first unid-neg-item no-lock 
                        where unid-neg-item.it-codigo = c-item) THEN DO:
        FOR EACH unid-neg-item NO-LOCK
            WHERE unid-neg-item.it-codigo = c-item:
            CREATE tt_unid_negoc.
            ASSIGN tt_unid_negoc.cod_unid_negoc  = unid-neg-item.cod_unid_negoc
                   tt_unid_negoc.perc_unid_negoc = unid-neg-item.perc-unid-neg / 100.
         END.
    END.
    ELSE DO:
        FOR EACH unid-neg-fam-com NO-LOCK  
            WHERE unid-neg-fam-com.fm-codigo = c-fam-com:
            CREATE tt_unid_negoc.
            ASSIGN tt_unid_negoc.cod_unid_negoc  = unid-neg-fam-com.cod_unid_negoc
                   tt_unid_negoc.perc_unid_negoc = unid-neg-fam-com.perc-unid-neg / 100.
        END.
    END.

    IF NOT CAN-FIND(FIRST tt_unid_negoc) THEN DO:
       CREATE tt_unid_negoc.
       ASSIGN tt_unid_negoc.cod_unid_negoc = "XXX"
              tt_unid_negoc.perc_unid_negoc = 1.
    END.

END PROCEDURE.
