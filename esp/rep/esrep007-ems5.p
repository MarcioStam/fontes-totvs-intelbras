DEF TEMP-TABLE tt-impostos NO-UNDO
    FIELD cod-listar        AS CHAR
    FIELD cod-pais          AS CHAR
    FIELD cod-unid-federac  AS CHAR
    FIELD cod-imposto       AS CHAR
    FIELD des-imposto       AS CHAR
    FIELD cod-classif-impto AS CHAR
    FIELD des-classif-impto AS CHAR
    INDEX id-imposto
            des-imposto      
            des-classif-impto
    INDEX id-litar
            cod-listar.

DEF OUTPUT PARAM TABLE FOR tt-impostos.

EMPTY TEMP-TABLE tt-impostos.

FOR EACH classif_impto NO-LOCK:

    FIND imposto NO-LOCK
        WHERE imposto.cod_pais       = classif_impto.cod_pais
          AND imposto.cod_unid_feder = classif_impto.cod_unid_feder
          AND imposto.cod_imposto    = classif_impto.cod_imposto NO-ERROR.

    IF  AVAIL imposto
    THEN DO:
        CREATE tt-impostos.
        ASSIGN tt-impostos.cod-pais          = classif_impto.cod_pais      
               tt-impostos.cod-unid-feder    = classif_impto.cod_unid_feder
               tt-impostos.cod-imposto       = classif_impto.cod_imposto
               tt-impostos.cod-classif-impto = classif_impto.cod_classif_impto
               tt-impostos.des-classif-impto = classif_impto.des_classif_impto
               tt-impostos.des-imposto       = imposto.des_imposto
               tt-impostos.cod-listar        = "".
    END.
END.
