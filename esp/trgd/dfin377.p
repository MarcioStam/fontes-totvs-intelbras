/********************************************************************************
 ** UPC........: upcd-ad129.p - UPC Delete Grupo de Cliente
 ** Data.......: Outubro / 2004
 ** Objetivo...: Repassa inclusäes e modifica‡äes dos grupos de clientes para a Base Oracle
 ********************************************************************************/

DEF PARAM BUFFER b_cta_corren_fornec FOR cta_corren_fornec.

DEF VAR c-hist AS CHAR NO-UNDO.   

FUNCTION fn-monta-origem    RETURNS CHAR FORWARD.

{utp/ut-glob.i}

DEF VAR i-ult-seq AS DEC NO-UNDO.

DEF BUFFER b_int_cta_corren_fornec_audit FOR int_cta_corren_fornec_audit.

FIND LAST b_int_cta_corren_fornec_audit NO-LOCK
    WHERE b_int_cta_corren_fornec_audit.cod_empresa = b_cta_corren_fornec.cod_empresa
      AND b_int_cta_corren_fornec_audit.cdn_fornec  = b_cta_corren_fornec.cdn_fornec NO-ERROR.

IF  AVAIL  b_int_cta_corren_fornec_audit THEN
    ASSIGN i-ult-seq = b_int_cta_corren_fornec_audit.num_seq + 10
           c-hist    = b_int_cta_corren_fornec_audit.hist_alter.
ELSE DO:
    ASSIGN i-ult-seq = 10.
    ASSIGN c-hist =          "Banco-"              + STRING(b_cta_corren_fornec.cod_banco) + ";".
           c-hist = c-hist + "Agˆncia-"            + STRING(b_cta_corren_fornec.cod_agenc_bcia)                    + ";".
           c-hist = c-hist + "Dig. Agˆncia-"       + STRING(b_cta_corren_fornec.cod_digito_agenc_bcia)             + ";".
           c-hist = c-hist + "Conta Corrente-"     + STRING(b_cta_corren_fornec.cod_cta_corren_bco )               + ";".
           c-hist = c-hist + "Dig Conta Corrente-" + STRING(b_cta_corren_fornec.cod_digito_cta_corren)             + ";".
           c-hist = c-hist + "Conta Preferencial-" + STRING(b_cta_corren_fornec.log_cta_corren_prefer, "SIM/NÇO" ) + ";".
           c-hist = c-hist + "Descri‡Æo Conta-"    + STRING(b_cta_corren_fornec.des_cta_corren).
END.

DO TRANS:
    CREATE int_cta_corren_fornec_audit.
    ASSIGN int_cta_corren_fornec_audit.cod_empresa           = b_cta_corren_fornec.cod_empresa
           int_cta_corren_fornec_audit.cdn_fornec            = b_cta_corren_fornec.cdn_fornec
           int_cta_corren_fornec_audit.num_seq               = i-ult-seq
           int_cta_corren_fornec_audit.cod_usuar_alter       = c-seg-usuario
           int_cta_corren_fornec_audit.dat_alter             = TODAY
           int_cta_corren_fornec_audit.hr_alter              = string(time, "HH:MM:SS")
           int_cta_corren_fornec_audit.hist_alter            = c-hist
           int_cta_corren_fornec_audit.orig_alter            = fn-monta-origem()
           int_cta_corren_fornec_audit.tp_movto              = 2 /* Elimina‡Æo */
           int_cta_corren_fornec_audit.cod_banco             = b_cta_corren_fornec.cod_banco
           int_cta_corren_fornec_audit.cod_agenc_bcia        = b_cta_corren_fornec.cod_agenc_bcia                        
           int_cta_corren_fornec_audit.cod_digito_agenc_bcia = b_cta_corren_fornec.cod_digito_agenc_bcia                 
           int_cta_corren_fornec_audit.cod_cta_corren_bco    = b_cta_corren_fornec.cod_cta_corren_bco                    
           int_cta_corren_fornec_audit.cod_digito_cta_corren = b_cta_corren_fornec.cod_digito_cta_corren                 
           int_cta_corren_fornec_audit.log_cta_corren_prefer = b_cta_corren_fornec.log_cta_corren_prefer
           int_cta_corren_fornec_audit.des_cta_corren        = b_cta_corren_fornec.des_cta_corren .

END.

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
