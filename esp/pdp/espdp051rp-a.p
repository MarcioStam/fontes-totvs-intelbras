DEF NEW GLOBAL SHARED VAR v_cod_empres_usuar 
    AS CHARACTER FORMAT "x(03)" 
    LABEL "Empresa"
    COLUMN-LABEL "Empresa"
    NO-UNDO.

DEF INPUT  PARAMETER i-cod-emitente     LIKE emitente.cod-emitente.
DEF OUTPUT PARAMETER de_val_sdo_tit_acr LIKE tit_acr.val_sdo_tit_acr.

ASSIGN de_val_sdo_tit_acr = 0.

FIND FIRST emscad.cliente WHERE
           emscad.cliente.cod_empresa = v_cod_empres_usuar AND
           emscad.cliente.cdn_cliente = i-cod-emitente     NO-LOCK NO-ERROR.
estab_block:
FOR EACH  estabelecimento NO-LOCK
    WHERE estabelecimento.cod_empresa = v_cod_empres_usuar:
    gera_abat:
    FOR EACH  tit_acr NO-LOCK USE-INDEX titacr_espec_pessoa_emis
        WHERE tit_acr.cod_estab           = estabelecimento.cod_estab
          AND tit_acr.ind_tip_espec_docto = "Antecipa‡Æo"
          AND tit_acr.num_pessoa          = emscad.cliente.num_pessoa
          AND tit_acr.val_sdo_tit_acr     > 0
          AND tit_acr.log_tit_acr_estordo = NO:

        ASSIGN de_val_sdo_tit_acr = de_val_sdo_tit_acr + tit_acr.val_sdo_tit_acr.

        calculo_saldo:
        FOR EACH  abat_antecip_acr NO-LOCK
            WHERE abat_antecip_acr.cod_estab       = tit_acr.cod_estab
              AND abat_antecip_acr.cod_espec_docto = tit_acr.cod_espec_docto
              AND abat_antecip_acr.cod_ser_docto   = tit_acr.cod_ser_docto
              AND abat_antecip_acr.cod_tit_acr     = tit_acr.cod_tit_acr
              AND abat_antecip_acr.cod_parcela     = tit_acr.cod_parcela:
            ASSIGN de_val_sdo_tit_acr = de_val_sdo_tit_acr - abat_antecip_acr.val_abtdo_antecip_orig.
        END.
    END.
END.
