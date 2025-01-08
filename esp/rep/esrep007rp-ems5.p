def new global shared var v_cod_empres_usuar
    as character
    format "x(3)":U
    label "Empresa"
    column-label "Empresa"
    no-undo.

define temp-table tt-impostos no-undo
    FIELD tipo              AS INT INIT 0
    field nat-operacao      AS CHAR
    FIELD cod-pais          AS CHAR
    FIELD cod-unid-federac  AS CHAR
    FIELD cod-imposto       AS CHAR
    FIELD cod-classif-impto AS CHAR
    FIELD cod-emitente      AS INT
    index id nat-operacao
    INDEX id_2 tipo cod-emitente.

DEF INPUT  PARAM TABLE FOR tt-impostos.
DEF INPUT  PARAM p-cod-fornec AS INT NO-UNDO.
DEF OUTPUT PARAM p-log-lista  AS LOG NO-UNDO.

ASSIGN p-log-lista = NO.

FIND fornec_financ NO-LOCK
    WHERE fornec_financ.cod_empres = v_cod_empres_usuar
      AND fornec_financ.cdn_fornec = p-cod-fornec NO-ERROR.

IF  NOT AVAIL fornec_financ
THEN
    ASSIGN p-log-lista = NO.
ELSE DO:
    FOR EACH  tt-impostos
        WHERE tt-impostos.nat-operacao = "":
        FIND impto_vincul_fornec NO-LOCK
            WHERE impto_vincul_fornec.cod_empres        = fornec_financ.cod_empres 
              AND impto_vincul_fornec.cdn_fornec        = fornec_financ.cdn_fornec 
              AND impto_vincul_fornec.cod_pais          = tt-impostos.cod-pais         
              AND impto_vincul_fornec.cod_unid_feder    = tt-impostos.cod-unid-feder   
              AND impto_vincul_fornec.cod_imposto       = tt-impostos.cod-imposto      
              AND impto_vincul_fornec.cod_classif_impto = tt-impostos.cod-classif-impto NO-ERROR.

        IF  AVAIL impto_vincul_fornec
        THEN DO:
            ASSIGN p-log-lista = YES.
            LEAVE.
        END.
    END.
END.

RETURN "OK".

