/********************************************************************************
 ** UPC........: wfin829.p - UPC TRIGGER WRITE cta_corren_fornec
 ** Data.......: Setempbro / 2016
 ** Objetivo...: Criaá∆o Hist¢rico de alteraá∆o de conta corrente do fornecedor
 ********************************************************************************/

DEF PARAM BUFFER b_cta_corren_fornec      FOR cta_corren_fornec.
DEF PARAM BUFFER b_old_cta_corren_fornec  FOR cta_corren_fornec.

{utp/ut-glob.i}

FUNCTION fn-monta-origem    RETURNS CHAR FORWARD.
FUNCTION fn-monta-historico RETURNS CHAR FORWARD.

DEF VAR i-ult-seq AS DEC INIT 10 NO-UNDO.

/*Criaá∆i do Registro */
DO TRANS:

    /* INCLUS«O DE REGISTRO / MODIFICAÄ«O */
    FIND LAST int_cta_corren_fornec_audit NO-LOCK
        WHERE int_cta_corren_fornec_audit.cod_empresa = b_cta_corren_fornec.cod_empresa 
          AND int_cta_corren_fornec_audit.cdn_fornec  = b_cta_corren_fornec.cdn_fornec   NO-ERROR.

    IF  AVAIL int_cta_corren_fornec_audit THEN
        ASSIGN i-ult-seq = int_cta_corren_fornec_audit.num_seq + 10.

    RUN pi-cria-historico (INPUT i-ult-seq,
                           INPUT fn-monta-historico()).

END.

PROCEDURE pi-cria-historico:

    DEF INPUT PARAM p-sequencia AS INT NO-UNDO.
    DEF INPUT PARAM p-historico AS CHAR FORMAT "x(1000)" NO-UNDO.
    
    DEF VAR v_tst LIKE int_cta_corren_fornec_audit.orig_alter NO-UNDO.

    ASSIGN v_tst = fn-monta-origem().

    CREATE int_cta_corren_fornec_audit.
    ASSIGN int_cta_corren_fornec_audit.cod_empresa           = b_cta_corren_fornec.cod_empresa
           int_cta_corren_fornec_audit.cdn_fornec            = b_cta_corren_fornec.cdn_fornec
           int_cta_corren_fornec_audit.num_seq               = p-sequencia
           int_cta_corren_fornec_audit.cod_usuar_alter       = c-seg-usuario
           int_cta_corren_fornec_audit.dat_alter             = TODAY
           int_cta_corren_fornec_audit.hr_alter              = string(time, "HH:MM:SS")
           int_cta_corren_fornec_audit.hist_alter            = p-historico
           int_cta_corren_fornec_audit.orig_alter            = fn-monta-origem()
           int_cta_corren_fornec_audit.tp_movto              = 1 /* Inclus∆o */
           int_cta_corren_fornec_audit.cod_banco             = b_cta_corren_fornec.cod_banco
           int_cta_corren_fornec_audit.cod_agenc_bcia        = b_cta_corren_fornec.cod_agenc_bcia                        
           int_cta_corren_fornec_audit.cod_digito_agenc_bcia = b_cta_corren_fornec.cod_digito_agenc_bcia                 
           int_cta_corren_fornec_audit.cod_cta_corren_bco    = b_cta_corren_fornec.cod_cta_corren_bco                    
           int_cta_corren_fornec_audit.cod_digito_cta_corren = b_cta_corren_fornec.cod_digito_cta_corren                 
           int_cta_corren_fornec_audit.log_cta_corren_prefer = b_cta_corren_fornec.log_cta_corren_prefer
           int_cta_corren_fornec_audit.des_cta_corren        = b_cta_corren_fornec.des_cta_corren .
END.

FUNCTION fn-monta-historico RETURNS CHAR:

    DEF VAR c-hist AS CHAR FORMAT "x(1000)" NO-UNDO.

    ASSIGN c-hist = "Banco-" + STRING(b_cta_corren_fornec.cod_banco) + ";".
           c-hist = c-hist + "Agància-"            + STRING(b_cta_corren_fornec.cod_agenc_bcia)                    + ";".
           c-hist = c-hist + "Dig. Agància-"       + STRING(b_cta_corren_fornec.cod_digito_agenc_bcia)             + ";".
           c-hist = c-hist + "Conta Corrente-"     + STRING(b_cta_corren_fornec.cod_cta_corren_bco )               + ";".
           c-hist = c-hist + "Dig Conta Corrente-" + STRING(b_cta_corren_fornec.cod_digito_cta_corren)             + ";".
           c-hist = c-hist + "Conta Preferencial-" + STRING(b_cta_corren_fornec.log_cta_corren_prefer, "SIM/N«O" ) + ";".
           c-hist = c-hist + "Descriá∆o Conta-"    + STRING(b_cta_corren_fornec.des_cta_corren).

    RETURN c-hist.

END FUNCTION.

FUNCTION fn-monta-origem RETURNS CHAR:
    DEF VAR i        AS INT                  NO-UNDO.
    DEF VAR v_origem AS CHAR FORMAT "x(300)" NO-UNDO.

    DO  i = 1 TO 30:
        IF PROGRAM-NAME(i) = ? THEN
            LEAVE.

        ASSIGN v_origem = v_origem + PROGRAM-NAME(i) + CHR(10).
    END.

    RETURN v_origem.
END FUNCTION.




