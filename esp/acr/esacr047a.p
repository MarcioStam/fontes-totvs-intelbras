/*****************************************************************************
** Programa: esp/acr/esacr047a.p
** Vers∆o..: 1.00
** Data....: 03/11/2011
** Autor...: Estevan KrÅger - Exponencial TI
** Obs.....: Programa para liquidar os t°tulos dos clientes que efetuaram compras
**           pelo cart∆o Intelbras, e gerar um novo T°tulo para a SupplierCard
*****************************************************************************/


/*--- Definiá∆o dos ParÉmetros ---*/
{esp/acr/esacr047.i}
DEFINE INPUT PARAMETER TABLE FOR tt-int-pagtos-supcard-ocor.



/*--- Definiá∆o das Vari†veis ---*/
{esp/acr/acr711zo.i}
{esp/acr/esacr047a.i}
{esp/es0018.i}

DEFINE VARIABLE h-acomp            AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-acr900zi         AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-cod-refer        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-des-dat          AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-cod-cta-tx-adm   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-cod-cta-transit  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-cod-cta-ctbl     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-num-bordero      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-tipo-despesa     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-cod-finalid-econ AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-arquivo          AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-titulo           AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-cont             AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-num-aux          AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-cod-parcela      AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-qtd-dias         AS INTEGER     NO-UNDO.
DEFINE VARIABLE de-val-sdo-tit-acr AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-tot-val-titulo  AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-val-taxa        AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-tot-sldan       AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-taxa-adm        AS DECIMAL     NO-UNDO.
DEFINE VARIABLE l-erro             AS LOGICAL     NO-UNDO.
DEFINE VARIABLE dt-anterior        AS DATE        NO-UNDO.
DEFINE VARIABLE v_cod_tip_fluxo    LIKE val_tit_acr.cod_tip_fluxo_financ NO-UNDO.

DEFINE TEMP-TABLE tt_tit_acr NO-UNDO
    FIELD cod_estab          LIKE tit_acr.cod_estab
    FIELD cod_espec          LIKE tit_acr.cod_espec_docto
    FIELD cod_ser_docto      LIKE tit_acr.cod_ser_docto
    FIELD cod_tit_acr        LIKE tit_acr.cod_tit_acr
    FIELD cod_parcela        LIKE tit_acr.cod_parcela
    FIELD val_origin_tit_acr LIKE tit_acr.val_origin_tit_acr
    INDEX idx_tit_acr        AS PRIMARY UNIQUE
          cod_estab
          cod_espec
          cod_ser_docto
          cod_tit_acr
          cod_parcela.

DEFINE TEMP-TABLE tt_val_tit_acr NO-UNDO
    FIELD cod_unid_negoc       LIKE val_tit_acr.cod_unid_negoc
    FIELD cod_tip_fluxo_financ LIKE val_tit_acr.cod_tip_fluxo_financ
    FIELD val_liq_tit_acr      LIKE val_tit_acr.val_liq_tit_acr
    FIELD val_origin_tit_acr   LIKE val_tit_acr.val_origin_tit_acr
    INDEX idx_unid_negoc       AS PRIMARY UNIQUE
          cod_unid_negoc
          cod_tip_fluxo_financ.

DEFINE TEMP-TABLE tt-taxas-adm NO-UNDO
    FIELD num-bordero   LIKE int-pagtos-supcard-ocor.num-bordero
    FIELD unid-negoc    LIKE val_tit_acr.cod_unid_negoc
    FIELD val-taxa      AS DECIMAL
    INDEX idx-taxas-adm AS PRIMARY UNIQUE
          num-bordero
          unid-negoc.

DEFINE TEMP-TABLE tt-mensagens NO-UNDO
    FIELD num-transac    LIKE int-pagtos-supcard-ocor.num-transac
    FIELD cod-estab      LIKE tit_acr.cod_estab
    FIELD num-id-tit-acr LIKE tit_acr.num_id_tit_acr
    FIELD des-erro       AS CHARACTER FORMAT "x(150)"
    FIELD l-erro         AS LOGICAL.

/* Rateio Original do t°tulo da SC */
DEFINE TEMP-TABLE tt-rat-orig NO-UNDO
    FIELD cod-unid-negoc  LIKE val_tit_acr.cod_unid_negoc
    FIELD val-sdo-tit-acr LIKE val_tit_acr.val_sdo_tit_acr
    FIELD val-perc-rat    LIKE val_tit_acr.val_perc_rat.

/* Rateio Alterado do t°tulo da SC */
DEFINE TEMP-TABLE tt-rat-alter NO-UNDO
    FIELD cod-unid-negoc  LIKE val_tit_acr.cod_unid_negoc
    FIELD val-sdo-tit-acr LIKE val_tit_acr.val_sdo_tit_acr
    FIELD val-perc-rat    LIKE val_tit_acr.val_perc_rat.

DEFINE TEMP-TABLE tt-titulos-ava NO-UNDO
    FIELD cod-estab            LIKE tit_acr.cod_estab
    FIELD num-id-tit-acr       LIKE tit_acr.num_id_tit_acr
    FIELD num-id-movto-tit-acr LIKE movto_tit_acr.num_id_movto_tit_acr
    FIELD val-relacto-tit-acr  LIKE movto_tit_acr.val_movto_tit_acr.

DEFINE BUFFER bf_tit_acr FOR tit_acr.



/*--- Bloco Principal ---*/
ASSIGN l-erro = NO.
IF  NOT VALID-HANDLE(h-acomp) THEN
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

IF  VALID-HANDLE(h-acomp) THEN
    RUN pi-inicializar IN h-acomp (INPUT "Processando Informaá‰es":U).


/* Busca as contas de Taxa Administraá∆o e Transit¢ria */
FIND FIRST int-contas-supcard NO-LOCK
    WHERE  int-contas-supcard.tipo-despesa = "Taxa Administraá∆o" NO-ERROR.
IF  NOT AVAIL int-contas-supcard THEN DO:
    CREATE tt-mensagens.
    ASSIGN tt-mensagens.num-transac = ""
           tt-mensagens.des-erro    = "N∆o foi localizada a Conta Taxa Administraá∆o para o abatimento do t°tulo (ParÉmetros da SupplierCard)."
           tt-mensagens.l-erro      = YES.
    IF  OPSYS = "WIN32":U THEN
        RUN utp/ut-msgs.p(INPUT "show",
                          INPUT 17006,
                          INPUT "N∆o foi localizada a Conta Taxa Administraá∆o para o abatimento do t°tulo (ParÉmetros da SupplierCard).").
    ASSIGN l-erro = YES.
    RUN pi-finaliza.
    RETURN "NOK".

END.
ELSE
    ASSIGN c-cod-cta-tx-adm = int-contas-supcard.cod-conta.

FIND FIRST int-contas-supcard NO-LOCK
    WHERE  int-contas-supcard.tipo-despesa = "Transit¢ria" NO-ERROR.
IF  NOT AVAIL int-contas-supcard THEN DO:
    CREATE tt-mensagens.
    ASSIGN tt-mensagens.num-transac = ""
           tt-mensagens.des-erro    = "N∆o foi localizada a Conta Transit¢ria para o abatimento do t°tulo (ParÉmetros da SupplierCard)."
           tt-mensagens.l-erro      = YES.
    IF  OPSYS = "WIN32":U THEN
        RUN utp/ut-msgs.p(INPUT "show",
                          INPUT 17006,
                          INPUT "N∆o foi localizada a Conta Transit¢ria para o abatimento do t°tulo (ParÉmetros da SupplierCard).").
    ASSIGN l-erro = YES.
    RUN pi-finaliza.
    RETURN "NOK".
END.
ELSE
    ASSIGN c-cod-cta-transit = int-contas-supcard.cod-conta.


IF  NOT l-erro THEN DO:
    /**** Gera um AVA no t°tulo do cliente, no valor da Taxa de Administraá∆o ****/
    FOR EACH tt-int-pagtos-supcard-ocor NO-LOCK:
        FIND FIRST int-pagtos-supcard NO-LOCK
            WHERE  int-pagtos-supcard.id-pagto = tt-int-pagtos-supcard-ocor.id-pagto NO-ERROR.
        IF  NOT AVAIL  int-pagtos-supcard THEN
            NEXT.
    
        IF  int-pagtos-supcard.cod-event = "DEBIT" OR
            int-pagtos-supcard.cod-event = "IMPL"  OR
            int-pagtos-supcard.cod-event = "SLDAN" THEN
            NEXT.
    
        FIND FIRST tit_acr NO-LOCK
            WHERE  tit_acr.cod_estab       = STRING(INT(SUBSTRING(tt-int-pagtos-supcard-ocor.num-transac,1,4)))
            AND    tit_acr.cod_espec_docto = "DM"
            AND    tit_acr.cod_ser_docto   = STRING(INT(SUBSTRING(tt-int-pagtos-supcard-ocor.num-transac,5,3)))
            AND    tit_acr.cod_tit_acr     = SUBSTRING(tt-int-pagtos-supcard-ocor.num-transac,8,7)
            AND    tit_acr.cod_parcela     = STRING(tt-int-pagtos-supcard-ocor.num-parcela, "99") NO-ERROR.
        IF  NOT AVAIL tit_acr THEN DO:
            CREATE tt-mensagens.
            ASSIGN tt-mensagens.num-transac = tt-int-pagtos-supcard-ocor.num-transac
                   tt-mensagens.des-erro    = "T°tulo n∆o foi localizado."
                   tt-mensagens.l-erro      = YES.
            NEXT.
        END.
    
        IF  (tit_acr.val_origin_tit_acr + tit_acr.val_transf_estab) <> tit_acr.val_sdo_tit_acr THEN DO:
            CREATE tt-mensagens.
            ASSIGN tt-mensagens.num-transac    = tt-int-pagtos-supcard-ocor.num-transac
                   tt-mensagens.cod-estab      = tit_acr.cod_estab
                   tt-mensagens.num-id-tit-acr = tit_acr.num_id_tit_acr
                   tt-mensagens.des-erro       = "T°tulo contÇm alteraá∆o e n∆o pode ser liquidado."
                   tt-mensagens.l-erro         = YES.
            NEXT.
        END.
    
        IF  VALID-HANDLE(h-acomp) THEN
            RUN pi-acompanhar IN h-acomp (INPUT "AVA Taxas Adm - T°tulo " + tit_acr.cod_tit_acr + "-" + tit_acr.cod_parcela).
    
        EMPTY TEMP-TABLE tt_alter_tit_acr_rateio.
        EMPTY TEMP-TABLE tt_alter_tit_acr_base_2.
    
        RUN pi-gera-referencia IN THIS-PROCEDURE (INPUT  tit_acr.cod_estab,
                                                  INPUT  RECID(tit_acr),
                                                  OUTPUT c-cod-refer).

        ASSIGN de-taxa-adm = tt-int-pagtos-supcard-ocor.val-parcela - tt-int-pagtos-supcard-ocor.val-lancamento.
        
        ASSIGN de-val-sdo-tit-acr = tit_acr.val_sdo_tit_acr - de-taxa-adm.
    
        ASSIGN i-cont = i-cont + 10.
        CREATE tt_alter_tit_acr_rateio.
        ASSIGN tt_alter_tit_acr_rateio.tta_cod_estab                   = tit_acr.cod_estab
               tt_alter_tit_acr_rateio.tta_num_id_tit_acr              = tit_acr.num_id_tit_acr
               tt_alter_tit_acr_rateio.ttv_ind_tip_rat_tit_acr         = "Alteraá∆o"
               tt_alter_tit_acr_rateio.tta_cod_refer                   = c-cod-refer
               tt_alter_tit_acr_rateio.tta_num_seq_refer               = i-cont
               tt_alter_tit_acr_rateio.tta_cod_plano_cta_ctbl          = "padrao"
               tt_alter_tit_acr_rateio.tta_cod_cta_ctbl                = c-cod-cta-tx-adm
               tt_alter_tit_acr_rateio.tta_num_seq_aprop_ctbl_pend_acr = i-cont
               tt_alter_tit_acr_rateio.tta_val_aprop_ctbl              = de-taxa-adm.
    
        RUN pi-gera-ava-titulo IN THIS-PROCEDURE.
        
        IF  RETURN-VALUE = "NOK" THEN DO: 
            RUN pi-finaliza.
            RETURN "NOK".
        END.
    END.
    
    
    /**** Liquida o T°tulo do cliente ****/
    FOR EACH tt-int-pagtos-supcard-ocor EXCLUSIVE-LOCK:
        FIND FIRST int-pagtos-supcard NO-LOCK
            WHERE  int-pagtos-supcard.id-pagto = tt-int-pagtos-supcard-ocor.id-pagto NO-ERROR.
        IF  NOT AVAIL  int-pagtos-supcard THEN
            NEXT.
    
        IF  int-pagtos-supcard.cod-event = "IMPL" THEN
            NEXT.
    
        IF  int-pagtos-supcard.cod-event = "SLDAN" THEN DO:
            ASSIGN de-tot-sldan = de-tot-sldan + (tt-int-pagtos-supcard-ocor.val-lancamento * -1).
            NEXT.
        END.
    
        FIND FIRST tit_acr NO-LOCK
            WHERE  tit_acr.cod_estab       = STRING(INT(SUBSTRING(tt-int-pagtos-supcard-ocor.num-transac,1,4)))
            AND    tit_acr.cod_espec_docto = "DM"
            AND    tit_acr.cod_ser_docto   = STRING(INT(SUBSTRING(tt-int-pagtos-supcard-ocor.num-transac,5,3)))
            AND    tit_acr.cod_tit_acr     = SUBSTRING(tt-int-pagtos-supcard-ocor.num-transac,8,7)
            AND    tit_acr.cod_parcela     = STRING(tt-int-pagtos-supcard-ocor.num-parcela, "99") NO-ERROR.
        IF  NOT AVAIL tit_acr THEN DO:
            CREATE tt-mensagens.
            ASSIGN tt-mensagens.num-transac = tt-int-pagtos-supcard-ocor.num-transac
                   tt-mensagens.des-erro    = "T°tulo n∆o foi localizado."
                   tt-mensagens.l-erro      = YES.
            NEXT.
        END.
    
    
        IF  VALID-HANDLE(h-acomp) THEN
            RUN pi-acompanhar IN h-acomp (INPUT "Liquidando T°tulo - " + tit_acr.cod_tit_acr + "-" + tit_acr.cod_parcela).
    
        EMPTY TEMP-TABLE tt_alter_tit_acr_rateio.
        EMPTY TEMP-TABLE tt_alter_tit_acr_base_2.
    
        RUN pi-gera-referencia IN THIS-PROCEDURE (INPUT  tit_acr.cod_estab,
                                                  INPUT  RECID(tit_acr),
                                                  OUTPUT c-cod-refer).
    
        /* Se for crÇdito, faz o abatimento do saldo total do t°tulo */
        IF  int-pagtos-supcard.cod-event = "CREDI" THEN DO:
            ASSIGN de-val-sdo-tit-acr = 0
                   de-tot-val-titulo  = de-tot-val-titulo + tit_acr.val_sdo_tit_acr.
    
            /* Gera o rateio dos valores por UN */
            ASSIGN i-cont = 0.
            FOR EACH  val_tit_acr NO-LOCK
                WHERE val_tit_acr.cod_estab      = tit_acr.cod_estab
                AND   val_tit_acr.num_id_tit_acr = tit_acr.num_id_tit_acr:
                FIND FIRST tt_val_tit_acr EXCLUSIVE-LOCK
                    WHERE  tt_val_tit_acr.cod_unid_negoc       = val_tit_acr.cod_unid_negoc
                    AND    tt_val_tit_acr.cod_tip_fluxo_financ = val_tit_acr.cod_tip_fluxo_financ NO-ERROR.
                IF  NOT AVAIL tt_val_tit_acr THEN DO:
                    CREATE tt_val_tit_acr.
                    ASSIGN tt_val_tit_acr.cod_unid_negoc       = val_tit_acr.cod_unid_negoc
                           tt_val_tit_acr.cod_tip_fluxo_financ = val_tit_acr.cod_tip_fluxo_financ.
                END.
        
                ASSIGN tt_val_tit_acr.val_origin_tit_acr = tt_val_tit_acr.val_origin_tit_acr + val_tit_acr.val_sdo_tit_acr.
            END.
    
            CREATE tt_alter_tit_acr_rateio.
            ASSIGN tt_alter_tit_acr_rateio.tta_cod_estab                   = tit_acr.cod_estab
                   tt_alter_tit_acr_rateio.tta_num_id_tit_acr              = tit_acr.num_id_tit_acr
                   tt_alter_tit_acr_rateio.ttv_ind_tip_rat_tit_acr         = "Alteraá∆o"
                   tt_alter_tit_acr_rateio.tta_cod_refer                   = c-cod-refer
                   tt_alter_tit_acr_rateio.tta_num_seq_refer               = i-cont
                   tt_alter_tit_acr_rateio.tta_cod_plano_cta_ctbl          = "padrao"
                   tt_alter_tit_acr_rateio.tta_cod_cta_ctbl                = c-cod-cta-transit
                   tt_alter_tit_acr_rateio.tta_num_seq_aprop_ctbl_pend_acr = 10
                   tt_alter_tit_acr_rateio.tta_val_aprop_ctbl              = tit_acr.val_sdo_tit_acr.
    
            RUN pi-gera-ava-titulo IN THIS-PROCEDURE.
            IF  RETURN-VALUE = "NOK" THEN DO: 
                RUN pi-finaliza.
                RETURN "NOK".
            END.
            
            FIND FIRST int-pagtos-supcard-ocor EXCLUSIVE-LOCK
                WHERE  ROWID(int-pagtos-supcard-ocor) = tt-int-pagtos-supcard-ocor.r-rowid NO-ERROR.
            IF  AVAIL  int-pagtos-supcard-ocor THEN
                ASSIGN int-pagtos-supcard-ocor.log-conciliado = YES.

            FIND LAST movto_tit_acr OF tit_acr NO-LOCK NO-ERROR.

            CREATE tt-titulos-ava.
            ASSIGN tt-titulos-ava.cod-estab            = tit_acr.cod_estab
                   tt-titulos-ava.num-id-tit-acr       = tit_acr.num_id_tit_acr
                   tt-titulos-ava.num-id-movto-tit-acr = movto_tit_acr.num_id_movto_tit_acr
                   tt-titulos-ava.val-relacto-tit-acr  = movto_tit_acr.val_movto_tit_acr.
        
            CREATE tt-mensagens.
            ASSIGN tt-mensagens.num-transac    = tt-int-pagtos-supcard-ocor.num-transac
                   tt-mensagens.cod-estab      = tit_acr.cod_estab
                   tt-mensagens.num-id-tit-acr = tit_acr.num_id_tit_acr
                   tt-mensagens.des-erro       = "T°tulo liquidado com sucesso."
                   tt-mensagens.l-erro         = NO.

            DELETE tt-int-pagtos-supcard-ocor.
        
        END.
    END.
    
    
    /**** Gera um t°tulo para a SupplierCard no valor dos t°tulos baixados ****/
    RUN pi-gera-titulo-sc IN THIS-PROCEDURE.
    IF  RETURN-VALUE = "NOK" THEN DO: 
        RUN pi-finaliza.
        RETURN "NOK".
    END.

    /**** Gera AVA das despesas Administrativas sobre o t°tulo da SC ****/
    RUN pi-gera-ava-tit-sc IN THIS-PROCEDURE.
    IF  RETURN-VALUE = "NOK" THEN DO: 
        RUN pi-finaliza.
        RETURN "NOK".
    END.

END.

RUN pi-finaliza.
RETURN "OK".


/*--- Procedures Internas ---*/
PROCEDURE pi-finaliza:

    /* Exporta para arquivo um log das informaá‰es */
    ASSIGN c-arquivo = SESSION:TEMP-DIRECTORY + "ConciliacaoFinanceira" + STRING(DAY(TODAY), "99") + STRING(MONTH(TODAY), "99") + REPLACE(STRING(TIME, "HH:MM"),":","") + ".txt".
    OUTPUT TO VALUE(c-arquivo) NO-CONVERT.

    PUT UNFORMATTED FILL("-", 310) SKIP
                    FILL(" ", 80) + "Conciliaá∆o Financeira" SKIP
                    FILL("-", 310).

    PUT UNFORMATTED SKIP(2) "**** Erros no Processo ****" SKIP(1)
                    "Transaá∆o" + FILL(" ", 12) +
                    "T°tulo"    + FILL(" ", 20) +
                    "Mensagem"  SKIP
                    FILL("-", 20) + " " +
                    FILL("-", 25) + " " +
                    FILL("-", 263) SKIP.

    FOR EACH  tt-mensagens NO-LOCK
        WHERE tt-mensagens.l-erro:
        ASSIGN c-titulo = "".
        IF  tt-mensagens.num-id-tit-acr <> 0 THEN DO:
            FIND FIRST tit_acr NO-LOCK
                WHERE  tit_acr.cod_estab      = tt-mensagens.cod-estab
                AND    tit_acr.num_id_tit_acr = tt-mensagens.num-id-tit-acr NO-ERROR.
            IF  AVAIL  tit_acr THEN
                ASSIGN c-titulo = tit_acr.cod_estab + "/" + tit_acr.cod_espec_docto + "/" + tit_acr.cod_ser_docto + "/" + tit_acr.cod_tit_acr + "/" + tit_acr.cod_parcela.
        END.

        PUT UNFORMATTED STRING(tt-mensagens.num-transac, "x(20)") + " " +
                        STRING(c-titulo, "x(25)")                 + " " +
                        STRING(tt-mensagens.des-erro, "x(263)") SKIP.
    END.

    PUT UNFORMATTED SKIP(2) "**** Mensagens ****" SKIP(1)
                    "Transaá∆o" + FILL(" ", 12) +
                    "T°tulo"    + FILL(" ", 20) +
                    "Mensagem"  SKIP
                    FILL("-", 20) + " " +
                    FILL("-", 25) + " " +
                    FILL("-", 263) SKIP.

    FOR EACH  tt-mensagens NO-LOCK
        WHERE NOT tt-mensagens.l-erro:
        ASSIGN c-titulo = "".
        IF  tt-mensagens.num-id-tit-acr <> 0 THEN DO:
            FIND FIRST tit_acr NO-LOCK
                WHERE  tit_acr.cod_estab      = tt-mensagens.cod-estab
                AND    tit_acr.num_id_tit_acr = tt-mensagens.num-id-tit-acr NO-ERROR.
            IF  AVAIL  tit_acr THEN
                ASSIGN c-titulo = tit_acr.cod_estab + "/" + tit_acr.cod_espec_docto + "/" + tit_acr.cod_ser_docto + "/" + tit_acr.cod_tit_acr + "/" + tit_acr.cod_parcela.
        END.

        PUT UNFORMATTED STRING(tt-mensagens.num-transac, "x(20)") + " " +
                        STRING(c-titulo, "x(25)")                 + " " +
                        STRING(tt-mensagens.des-erro, "x(263)") SKIP.
    END.
    OUTPUT CLOSE.

    IF  OPSYS = "WIN32":U THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 15825,
                           INPUT "Processo de Conciliaá∆o finalizado!":U).

        RUN WinExec (INPUT "Notepad.exe":U + CHR(32) + c-arquivo,
                     INPUT 1).
    END.

    IF VALID-HANDLE(h-acomp) THEN RUN pi-finalizar IN h-acomp.
    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-gera-referencia:
    DEFINE INPUT  PARAMETER p-cod-estab  AS CHARACTER FORMAT "x(3)"    NO-UNDO.
    DEFINE INPUT  PARAMETER p-rec-tabela AS RECID     FORMAT ">>>>>>9" NO-UNDO.
    DEFINE OUTPUT PARAMETER p-referencia AS CHARACTER   NO-UNDO.

    DEFINE VARIABLE l-log-refer-uni AS LOGICAL     NO-UNDO.

    /* Gera o c¢digo da referància */
    ASSIGN c-des-dat    = STRING(TODAY,"99999999")
           p-referencia = SUBSTRING(c-des-dat,7,2) + SUBSTRING(c-des-dat,3,2) + SUBSTRING(c-des-dat,1,2) + "T"
           i-num-aux    = INTEGER(THIS-PROCEDURE:HANDLE).

    DO  i-cont = 1 TO 3:
        ASSIGN p-referencia = p-referencia + CHR((RANDOM(0,i-num-aux) MOD 26) + 97).
    END.


    /* Verifica se a referància Ç £nica */
    RUN pi-verifica-refer-unica-acr IN THIS-PROCEDURE (INPUT  p-cod-estab,
                                                       INPUT  p-referencia,
                                                       INPUT  "",
                                                       INPUT  p-rec-tabela,
                                                       OUTPUT l-log-refer-uni).
    IF  NOT l-log-refer-uni THEN
        RUN pi-gera-referencia IN THIS-PROCEDURE (INPUT  p-cod-estab,
                                                  INPUT  p-rec-tabela,
                                                  OUTPUT p-referencia).


    RETURN "OK":U.
END PROCEDURE.


PROCEDURE pi-verifica-refer-unica-acr:
    /************************ Parameter Definition Begin ************************/
    DEF INPUT  PARAM p_cod_estab     AS CHARACTER FORMAT "x(3)"    NO-UNDO.
    DEF INPUT  PARAM p_cod_refer     AS CHARACTER FORMAT "x(10)"   NO-UNDO.
    DEF INPUT  PARAM p_cod_table     AS CHARACTER FORMAT "x(8)"    NO-UNDO.
    DEF INPUT  PARAM p_rec_tabela    AS RECID     FORMAT ">>>>>>9" NO-UNDO.
    DEF OUTPUT PARAM p_log_refer_uni AS LOGICAL   FORMAT "Sim/N∆o" NO-UNDO.
    /************************* Parameter Definition End *************************/

    /************************** Buffer Definition Begin *************************/
    DEFINE BUFFER b_cobr_especial_acr FOR cobr_especial_acr.
    DEFINE BUFFER b_lote_impl_tit_acr FOR lote_impl_tit_acr.
    DEFINE BUFFER b_lote_liquidac_acr FOR lote_liquidac_acr.
    DEFINE BUFFER b_movto_tit_acr     FOR movto_tit_acr.
    DEFINE BUFFER b_operac_financ_acr FOR operac_financ_acr.
    DEFINE BUFFER b_renegoc_acr       FOR renegoc_acr.
    /*************************** Buffer Definition End **************************/

    ASSIGN p_log_refer_uni = YES.

    IF  p_cod_table <> "lote_impl_tit_acr" /*l_lote_impl_tit_acr*/  THEN DO:
        FIND FIRST b_lote_impl_tit_acr NO-LOCK
             WHERE b_lote_impl_tit_acr.cod_estab = p_cod_estab
               AND b_lote_impl_tit_acr.cod_refer = p_cod_refer
               AND RECID( b_lote_impl_tit_acr ) <> p_rec_tabela
             USE-INDEX ltmplttc_id NO-ERROR.
        IF  AVAIL b_lote_impl_tit_acr THEN
            ASSIGN p_log_refer_uni = NO.
    END.

    IF  p_cod_table <> "lote_liquidac_acr" /*l_lote_liquidac_acr*/  THEN DO:
        FIND FIRST b_lote_liquidac_acr NO-LOCK
             WHERE b_lote_liquidac_acr.cod_estab_refer = p_cod_estab
               AND b_lote_liquidac_acr.cod_refer       = p_cod_refer
               AND RECID( b_lote_liquidac_acr )       <> p_rec_tabela
             USE-INDEX ltlqdccr_id NO-ERROR.
        IF  AVAIL b_lote_liquidac_acr THEN
            ASSIGN p_log_refer_uni = NO.
    END.

    IF  p_cod_table <> "Operaá∆o financeira" /*l_operacao_financ*/  THEN DO:
        FIND FIRST b_operac_financ_acr NO-LOCK
             WHERE b_operac_financ_acr.cod_estab               = p_cod_estab
               AND b_operac_financ_acr.cod_movto_operac_financ = p_cod_refer
               AND RECID( b_operac_financ_acr )               <> p_rec_tabela
             USE-INDEX oprcfnna_id NO-ERROR.
        IF  AVAIL b_operac_financ_acr THEN
            ASSIGN p_log_refer_uni = NO.
    END.

    IF  p_cod_table = 'cobr_especial_acr' THEN DO:
        FIND FIRST b_cobr_especial_acr NO-LOCK
             WHERE b_cobr_especial_acr.cod_estab = p_cod_estab
               AND b_cobr_especial_acr.cod_refer = p_cod_refer
               AND RECID( b_cobr_especial_acr ) <> p_rec_tabela
             USE-INDEX cbrspclc_id NO-ERROR.
        IF  AVAIL b_cobr_especial_acr THEN
            ASSIGN p_log_refer_uni = NO.
    END.

    IF  p_log_refer_uni = YES THEN DO:
        FIND FIRST b_renegoc_acr NO-LOCK
            WHERE b_renegoc_acr.cod_estab = p_cod_estab
            AND   b_renegoc_acr.cod_refer = p_cod_refer
            AND   RECID(b_renegoc_acr)   <> p_rec_tabela
            NO-ERROR.
        IF  AVAIL b_renegoc_acr then
            ASSIGN p_log_refer_uni = no.
        ELSE DO:
            FIND FIRST b_movto_tit_acr NO-LOCK
                 WHERE b_movto_tit_acr.cod_estab = p_cod_estab
                   AND b_movto_tit_acr.cod_refer = p_cod_refer
                   AND RECID(b_movto_tit_acr)   <> p_rec_tabela
                 USE-INDEX mvtttcr_refer
                 NO-ERROR.
            IF  AVAIL b_movto_tit_acr THEN
                ASSIGN p_log_refer_uni = NO.
        END.
    END.

END PROCEDURE.



PROCEDURE pi-gera-ava-titulo:

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-acompanhar IN h-acomp(INPUT "Gerando AVA...." + STRING(c-cod-refer)).

    CREATE tt_alter_tit_acr_base_2.
    ASSIGN tt_alter_tit_acr_base_2.tta_cod_estab                   = tit_acr.cod_estab
           tt_alter_tit_acr_base_2.tta_num_id_tit_acr              = tit_acr.num_id_tit_acr
           tt_alter_tit_acr_base_2.tta_dat_transacao               = TODAY
           tt_alter_tit_acr_base_2.tta_cod_refer                   = c-cod-refer
           tt_alter_tit_acr_base_2.ttv_cod_motiv_movto_tit_acr_imp = ?
           tt_alter_tit_acr_base_2.tta_val_sdo_tit_acr             = de-val-sdo-tit-acr
           tt_alter_tit_acr_base_2.ttv_cod_motiv_movto_tit_acr_alt = ""
           tt_alter_tit_acr_base_2.ttv_ind_motiv_acerto_val        = "Liquidaá∆o"
           tt_alter_tit_acr_base_2.tta_cod_portador                = ?
           tt_alter_tit_acr_base_2.tta_cod_cart_bcia               = ?
           tt_alter_tit_acr_base_2.tta_val_despes_bcia             = ?
           tt_alter_tit_acr_base_2.tta_cod_agenc_cobr_bcia         = ?
           tt_alter_tit_acr_base_2.tta_cod_tit_acr_bco             = ?
           tt_alter_tit_acr_base_2.tta_dat_emis_docto              = 01/01/0001
           tt_alter_tit_acr_base_2.tta_dat_vencto_tit_acr          = 01/01/0001
           tt_alter_tit_acr_base_2.tta_dat_prev_liquidac           = 01/01/0001
           tt_alter_tit_acr_base_2.tta_dat_fluxo_tit_acr           = 01/01/0001
           tt_alter_tit_acr_base_2.tta_ind_sit_tit_acr             = ?
           tt_alter_tit_acr_base_2.tta_cod_cond_cobr               = ?
           tt_alter_tit_acr_base_2.tta_log_tip_cr_perda_dedut_tit  = ?  
           tt_alter_tit_acr_base_2.tta_dat_abat_tit_acr            = 01/01/0001
           tt_alter_tit_acr_base_2.tta_val_abat_tit_acr            = ?
           tt_alter_tit_acr_base_2.tta_dat_desconto                = 01/01/0001
           tt_alter_tit_acr_base_2.tta_val_perc_desc               = ?
           tt_alter_tit_acr_base_2.tta_val_desc_tit_acr            = ?
           tt_alter_tit_acr_base_2.tta_qtd_dias_carenc_juros_acr   = ?
           tt_alter_tit_acr_base_2.tta_val_perc_juros_dia_atraso   = ?
           tt_alter_tit_acr_base_2.tta_val_perc_multa_atraso       = ?
           tt_alter_tit_acr_base_2.tta_qtd_dias_carenc_multa_acr   = ?
           tt_alter_tit_acr_base_2.tta_ind_ender_cobr              = ?
           tt_alter_tit_acr_base_2.tta_nom_abrev_contat            = ?
           tt_alter_tit_acr_base_2.tta_val_liq_tit_acr             = ?
           tt_alter_tit_acr_base_2.tta_cod_instruc_bcia_1_movto    = ?
           tt_alter_tit_acr_base_2.tta_cod_instruc_bcia_2_movto    = ?
           tt_alter_tit_acr_base_2.ttv_des_text_histor             = "Hist¢rico"
           tt_alter_tit_acr_base_2.tta_ind_tip_cobr_acr            = "NORMAL"
           tt_alter_tit_acr_base_2.tta_log_tit_acr_destndo         = ?
           tt_alter_tit_acr_base_2.tta_des_obs_cobr                = ?
           tt_alter_tit_acr_base_2.tta_val_perc_abat_acr           = ?.

    
    RUN prgfin/acr/acr711zo.py (INPUT  4,
                                INPUT  TABLE tt_alter_tit_acr_base_2,
                                INPUT  TABLE tt_alter_tit_acr_rateio,
                                INPUT  TABLE tt_alter_tit_acr_ped_vda,
                                INPUT  TABLE tt_alter_tit_acr_comis,
                                INPUT  TABLE tt_alter_tit_acr_cheq,
                                INPUT  TABLE tt_alter_tit_acr_iva,
                                INPUT  TABLE tt_alter_tit_acr_impto_retid_2,
                                INPUT  TABLE tt_alter_tit_acr_cobr_espec_2,
                                INPUT  TABLE tt_alter_tit_acr_rat_desp_rec,
                                OUTPUT TABLE tt_log_erros_alter_tit_acr,
                                INPUT  NO).

    ASSIGN l-erro = NO.
    FOR EACH tt_log_erros_alter_tit_acr:
        CREATE tt-mensagens.
        ASSIGN tt-mensagens.num-transac    = ""
               tt-mensagens.cod-estab      = tt_log_erros_alter_tit_acr.tta_cod_estab
               tt-mensagens.num-id-tit-acr = tt_log_erros_alter_tit_acr.tta_num_id_tit_acr
               tt-mensagens.des-erro       = tt_log_erros_alter_tit_acr.ttv_des_msg_erro + " -> " + tt_log_erros_alter_tit_acr.ttv_des_msg_ajuda
               tt-mensagens.l-erro         = YES
               l-erro                      = YES.
    END.

    IF  l-erro THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.



PROCEDURE pi-gera-titulo-sc:


    RUN pi-gera-referencia IN THIS-PROCEDURE (INPUT  "104",
                                              INPUT  ?,
                                              OUTPUT c-cod-refer).
    IF  VALID-HANDLE(h-acomp) THEN
        RUN pi-acompanhar IN h-acomp (INPUT "Gerando t°tulo para SupplierCard..." + STRING(c-cod-refer)).

    CREATE tt_integr_acr_lote_impl. 
    ASSIGN tt_integr_acr_lote_impl.tta_cod_empresa          = "1"
           tt_integr_acr_lote_impl.tta_cod_estab            = "104"
           tt_integr_acr_lote_impl.tta_cod_refer            = c-cod-refer
           tt_integr_acr_lote_impl.tta_dat_transacao        = TODAY
           tt_integr_acr_lote_impl.tta_ind_tip_cobr_acr     = "Normal"
           tt_integr_acr_lote_impl.tta_ind_orig_tit_acr     = "ACREMS50"
           tt_integr_acr_lote_impl.ttv_cod_empresa_ext      = ""
           tt_integr_acr_lote_impl.tta_cod_estab_ext        = ""
           tt_integr_acr_lote_impl.tta_cod_finalid_econ_ext = "".


    /* Por solicitaá∆o de AndrÇ (Financeiro), o t°tulo da SupplierCard Ç gerado com o c¢digo correspondente a D-1 (data £til anterior a de hoje) */
    ASSIGN i-qtd-dias  = 1
           dt-anterior = TODAY.

    /* Funá∆o para buscar o dia anterior. */
    DO WHILE i-qtd-dias > 0:
        ASSIGN dt-anterior = dt-anterior - 1.

        FIND FIRST dia_calend_glob
            WHERE dia_calend_glob.cod_calend = "Fiscal":U
              AND dia_calend_glob.dat_calend = dt-anterior NO-LOCK NO-ERROR.

        IF dia_calend_glob.log_dia_util THEN /* Veirifica se Ç dia £til */
            ASSIGN i-qtd-dias = i-qtd-dias - 1.
    
/*         IF  WEEKDAY(dt-anterior) <> 1 /* Domingo */ AND  */
/*             WEEKDAY(dt-anterior) <> 7 /* S†bado  */ THEN */
/*             ASSIGN i-qtd-dias = i-qtd-dias - 1.          */
    END.

    /* Verifica se j† foi gerada alguma parcela para o t°tulo */
    ASSIGN i-cod-parcela = 0.
    REPEAT:
        ASSIGN i-cod-parcela = i-cod-parcela + 1.
        FIND FIRST tit_acr NO-LOCK
            WHERE  tit_acr.cod_estab       = "104"
            AND    tit_acr.cod_espec_docto = "DM"
            AND    tit_acr.cod_ser_docto   = "7"
            AND    tit_acr.cod_tit_acr     = STRING(dt-anterior, "99999999")
            AND    tit_acr.cod_parcela     = STRING(i-cod-parcela, "99") NO-ERROR.
        IF  NOT AVAIL tit_acr THEN
            LEAVE.
    END.


    CREATE tt_integr_acr_item_lote_impl_8.
    ASSIGN tt_integr_acr_item_lote_impl_8.ttv_rec_lote_impl_tit_acr      = RECID(tt_integr_acr_lote_impl)
           tt_integr_acr_item_lote_impl_8.tta_num_seq_refer              = 1
           tt_integr_acr_item_lote_impl_8.tta_ind_tip_espec_docto        = "normal"
           tt_integr_acr_item_lote_impl_8.tta_cod_portador               = "9915"
           tt_integr_acr_item_lote_impl_8.tta_cod_cart_bcia              = "90"
           tt_integr_acr_item_lote_impl_8.tta_cod_espec_docto            = "DM"
           tt_integr_acr_item_lote_impl_8.tta_cod_parcela                = STRING(i-cod-parcela, "99")
           tt_integr_acr_item_lote_impl_8.tta_cod_tit_acr                = STRING(dt-anterior, "99999999")
           tt_integr_acr_item_lote_impl_8.tta_cdn_cliente                = 171061 
           tt_integr_acr_item_lote_impl_8.tta_cod_ser_docto              = "7"          
           tt_integr_acr_item_lote_impl_8.tta_cod_finalid_econ_ext       = ""
           tt_integr_acr_item_lote_impl_8.tta_cod_finalid_econ           = "corrente"
           tt_integr_acr_item_lote_impl_8.tta_cod_finalid_econ_ext       = ""
           tt_integr_acr_item_lote_impl_8.tta_cod_indic_econ             = "real"
           tt_integr_acr_item_lote_impl_8.tta_cod_portad_ext             = ""
           tt_integr_acr_item_lote_impl_8.tta_cdn_repres                 = 2090
           tt_integr_acr_item_lote_impl_8.tta_dat_vencto_tit_acr         = TODAY + 5
           tt_integr_acr_item_lote_impl_8.tta_dat_prev_liquidac          = ?
           tt_integr_acr_item_lote_impl_8.tta_dat_desconto               = ?
           tt_integr_acr_item_lote_impl_8.tta_dat_emis_docto             = TODAY
           tt_integr_acr_item_lote_impl_8.tta_cod_cond_cobr              = ""
           tt_integr_acr_item_lote_impl_8.tta_val_tit_acr                = de-tot-val-titulo
           tt_integr_acr_item_lote_impl_8.tta_val_desconto               = 0
           tt_integr_acr_item_lote_impl_8.tta_val_perc_desc              = 0
           tt_integr_acr_item_lote_impl_8.tta_val_perc_juros_dia_atraso  = 0
           tt_integr_acr_item_lote_impl_8.tta_val_perc_multa_atraso      = 0
           tt_integr_acr_item_lote_impl_8.tta_des_text_histor            = "" 
           tt_integr_acr_item_lote_impl_8.tta_cod_instruc_bcia_1_movto   = ""
           tt_integr_acr_item_lote_impl_8.tta_cod_instruc_bcia_2_movto   = ""
           tt_integr_acr_item_lote_impl_8.tta_qtd_dias_carenc_juros_acr  = ? 
           tt_integr_acr_item_lote_impl_8.tta_val_liq_tit_acr            = de-tot-val-titulo
           tt_integr_acr_item_lote_impl_8.tta_cod_agenc_cobr_bcia        = ""
           tt_integr_acr_item_lote_impl_8.tta_cod_tit_acr_bco            = ""
           tt_integr_acr_item_lote_impl_8.tta_cod_cartcred               = ""
           tt_integr_acr_item_lote_impl_8.tta_cod_mes_ano_valid_cartao   = ""
           tt_integr_acr_item_lote_impl_8.tta_dat_compra_cartao_cr       = ? 
           tt_integr_acr_item_lote_impl_8.ttv_cod_comprov_vda            = ""
           tt_integr_acr_item_lote_impl_8.ttv_cod_autoriz_bco_emissor    = ""
           tt_integr_acr_item_lote_impl_8.ttv_cod_lote_origin            = ""
           tt_integr_acr_item_lote_impl_8.tta_cod_conces_telef           = ""
           tt_integr_acr_item_lote_impl_8.tta_num_ddd_localid_conces     = 0
           tt_integr_acr_item_lote_impl_8.tta_num_prefix_localid_conces  = 0
           tt_integr_acr_item_lote_impl_8.tta_num_milhar_localid_conces  = 0
           tt_integr_acr_item_lote_impl_8.tta_cod_banco                  = "" 
           tt_integr_acr_item_lote_impl_8.tta_cod_agenc_bcia             = ""
           tt_integr_acr_item_lote_impl_8.tta_cod_cta_corren_bco         = ""
           tt_integr_acr_item_lote_impl_8.tta_cod_digito_cta_corren      = ""
           tt_integr_acr_item_lote_impl_8.tta_val_cotac_indic_econ       = 1
           tt_integr_acr_item_lote_impl_8.tta_ind_tip_calc_juros         = "Simples"
           tt_integr_acr_item_lote_impl_8.ttv_rec_item_lote_impl_tit_acr = RECID(tt_integr_acr_item_lote_impl_8)
           tt_integr_acr_item_lote_impl_8.tta_cod_motiv_movto_tit_acr    = ""
           tt_integr_acr_item_lote_impl_8.tta_log_liquidac_autom         = NO
           tt_integr_acr_item_lote_impl_8.ttv_num_parc_cartcred          = 0
           tt_integr_acr_item_lote_impl_8.tta_cod_proces_export          = "".


    /* Cria o rateio das UNs com base nas UNs dos t°tulos baixados */
    FOR EACH tt_val_tit_acr NO-LOCK
        WHERE tt_val_tit_acr.val_origin_tit_acr > 0:

        ASSIGN v_cod_tip_fluxo = "".

        EMPTY TEMP-TABLE tt-prog-ponto.
        
        RUN esp/es0018p.p (INPUT "esacr047a":U,
                           INPUT 1,
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-ponto).
        
        FOR FIRST tt-prog-ponto:        
            ASSIGN v_cod_tip_fluxo = tt-prog-ponto.conteudo.        
        END.

        CREATE tt_integr_acr_aprop_ctbl_pend.
        ASSIGN tt_integr_acr_aprop_ctbl_pend.ttv_rec_item_lote_impl_tit_acr = RECID(tt_integr_acr_item_lote_impl_8)
               tt_integr_acr_aprop_ctbl_pend.tta_cod_cta_ctbl               = c-cod-cta-transit
               tt_integr_acr_aprop_ctbl_pend.tta_cod_tip_fluxo_financ       = IF  v_cod_tip_fluxo <> "" THEN v_cod_tip_fluxo ELSE tt_val_tit_acr.cod_tip_fluxo_financ
               tt_integr_acr_aprop_ctbl_pend.tta_val_aprop_ctbl             = tt_val_tit_acr.val_origin_tit_acr
               tt_integr_acr_aprop_ctbl_pend.tta_cod_unid_negoc             = tt_val_tit_acr.cod_unid_negoc
               tt_integr_acr_aprop_ctbl_pend.tta_cod_plano_cta_ctbl         = "padrao"
               tt_integr_acr_aprop_ctbl_pend.tta_cod_plano_ccusto           = ""
               tt_integr_acr_aprop_ctbl_pend.tta_cod_ccusto                 = "".
    END.

    RELEASE tt_integr_acr_aprop_ctbl_pend.
    RELEASE tt_integr_acr_item_lote_impl_8.
    FIND FIRST tt_integr_acr_lote_impl NO-LOCK.


    IF  NOT VALID-HANDLE(h-acr900zi) THEN
        RUN prgfin\acr\acr900zi.py PERSISTENT SET h-acr900zi.

    IF  VALID-HANDLE(h-acr900zi) THEN
        RUN pi_main_code_integr_acr_new_9 IN h-acr900zi (INPUT 11,
                                                         INPUT "",  /*Matriz Trad Org Ext*/
                                                         INPUT YES, /*Log Atualiz Refer*/
                                                         INPUT NO,  /*Assume Data Emiss*/
                                                         INPUT TABLE tt_integr_acr_repres_comis_2,
                                                         INPUT-OUTPUT TABLE tt_integr_acr_item_lote_impl_8,
                                                         INPUT TABLE tt_integr_acr_aprop_relacto_2).

    IF  VALID-HANDLE(h-acr900zi) THEN
        DELETE PROCEDURE h-acr900zi.

    ASSIGN l-erro = NO.
    FOR EACH tt_log_erros_atualiz:
        CREATE tt-mensagens.
        ASSIGN tt-mensagens.num-transac    = "T°tulo SupplierCard"
               tt-mensagens.num-id-tit-acr = 0
               tt-mensagens.des-erro       = tt_log_erros_atualiz.ttv_des_msg_erro + " -> " + tt_log_erros_atualiz.ttv_des_msg_ajuda
               tt-mensagens.l-erro         = YES.

        IF  OPSYS = "WIN32":U THEN
            RUN utp/ut-msgs.p(INPUT "show",
                              INPUT 17006,
                              INPUT tt_log_erros_atualiz.ttv_des_msg_erro + "~~" + tt_log_erros_atualiz.ttv_des_msg_ajuda).

        ASSIGN l-erro = YES.
    END.

    IF  l-erro THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.



PROCEDURE pi-gera-ava-tit-sc:

    /* Localiza o t°tulo da SupplierCard */
    FIND FIRST tit_acr NO-LOCK
        WHERE  tit_acr.cod_estab       = "104"
        AND    tit_acr.cod_espec_docto = "DM"
        AND    tit_acr.cod_ser_docto   = "7"
        AND    tit_acr.cod_tit_acr     = STRING(dt-anterior, "99999999")
        AND    tit_acr.cod_parcela     = STRING(i-cod-parcela, "99") NO-ERROR.
    IF  NOT AVAIL tit_acr THEN DO:
        CREATE tt-mensagens.
        ASSIGN tt-mensagens.num-transac    = ""
               tt-mensagens.num-id-tit-acr = 0
               tt-mensagens.des-erro       = "T°tulo da SupplierCard n∆o localizado para geraá∆o dos AVAs de despesas!"
               tt-mensagens.l-erro         = YES.

        IF  OPSYS = "WIN32":U THEN
            RUN utp/ut-msgs.p(INPUT "show",
                              INPUT 17006,
                              INPUT "T°tulo da SupplierCard n∆o localizado para geraá∆o dos AVAs de despesas!").


        RETURN "NOK":U.
    END.

    IF  VALID-HANDLE(h-acomp) THEN
        RUN pi-acompanhar IN h-acomp (INPUT "Gerando AVA das despesas administrativas..." + STRING(tit_acr.cod_tit_acr) + "/" + STRING(tit_acr.cod_parcela)).

    /* Cria mensagem para informar o t°tulo que foi gerado para a SupplierCard */
    CREATE tt-mensagens.
    ASSIGN tt-mensagens.num-transac    = "T°tulo SupplierCard"
           tt-mensagens.cod-estab      = tit_acr.cod_estab
           tt-mensagens.num-id-tit-acr = tit_acr.num_id_tit_acr
           tt-mensagens.des-erro       = "T°tulo para a SupplierCard gerado com sucesso."
           tt-mensagens.l-erro         = NO.

    /* Gera os relacionamentos dos t°tulos que geraram o titulo da SupplierCard */
    FOR EACH tt-titulos-ava NO-LOCK:
        CREATE relacto_tit_acr.
        ASSIGN relacto_tit_acr.cod_estab                = tit_acr.cod_estab
               relacto_tit_acr.num_id_tit_acr           = tit_acr.num_id_tit_acr
               relacto_tit_acr.cod_estab_tit_acr_pai    = tt-titulos-ava.cod-estab
               relacto_tit_acr.num_id_tit_acr_pai       = tt-titulos-ava.num-id-tit-acr
               relacto_tit_acr.num_id_movto_tit_acr_pai = tt-titulos-ava.num-id-movto-tit-acr
               relacto_tit_acr.val_relacto_tit_acr      = tt-titulos-ava.val-relacto-tit-acr.
    END.

    /* Busca a Finalidade Econìmica */
    FIND FIRST histor_finalid_econ NO-LOCK
        WHERE  histor_finalid_econ.cod_indic_econ          = tit_acr.cod_indic_econ
        AND    histor_finalid_econ.dat_inic_valid_finalid <= TODAY
        AND    histor_finalid_econ.dat_fim_valid_finalid   > TODAY NO-ERROR.
    IF  AVAIL  histor_finalid_econ THEN
        ASSIGN c-cod-finalid-econ = histor_finalid_econ.cod_finalid_econ.


    FOR EACH tt-int-pagtos-supcard-ocor NO-LOCK:
        FIND FIRST int-pagtos-supcard NO-LOCK
            WHERE  int-pagtos-supcard.id-pagto = tt-int-pagtos-supcard-ocor.id-pagto NO-ERROR.
        IF  NOT AVAIL int-pagtos-supcard THEN
            NEXT.

        IF  int-pagtos-supcard.cod-event = "DEBIT" OR
            int-pagtos-supcard.cod-event = "CANCE" THEN DO:
            ASSIGN de-val-sdo-tit-acr = tit_acr.val_sdo_tit_acr + tt-int-pagtos-supcard-ocor.val-lancamento.

            ASSIGN de-val-taxa = 0.
    
            /*ASSIGN de-val-taxa = tt-int-pagtos-supcard-ocor.val-lancamento * -1.*/

            /* Caso o "num-bordero" seja realmente o n£mero do bordero, grava uma informaá∆o padr∆o para o que valor da taxa seja acumulado */
            IF  tt-int-pagtos-supcard-ocor.num-bordero = "RPASSP" OR
                tt-int-pagtos-supcard-ocor.num-bordero = "RPASSC" OR
                tt-int-pagtos-supcard-ocor.num-bordero = "CANCEP" OR
                tt-int-pagtos-supcard-ocor.num-bordero = "BONIFI" THEN
                ASSIGN c-num-bordero = tt-int-pagtos-supcard-ocor.num-bordero
                       de-val-taxa   = tt-int-pagtos-supcard-ocor.val-lancamento * -1.
            ELSE DO:
                ASSIGN c-num-bordero = "Taxa Administraá∆o".

                /* Quando vem gravado o n£mero do bordero, Ç um Cancelamento Total de compra. Deve abater somente o valor da taxa, e n∆o todo o valor da parcela.
                   O valor do lanáamento Ç negativo, por isso soma o valor da parcela para que este valor seja subtraido */
                IF  int-pagtos-supcard.cod-event = "DEBIT" THEN
                    ASSIGN de-val-sdo-tit-acr = tit_acr.val_sdo_tit_acr + (tt-int-pagtos-supcard-ocor.val-parcela + tt-int-pagtos-supcard-ocor.val-lancamento)
                           /*de-val-taxa        = tt-int-pagtos-supcard-ocor.val-parcela + tt-int-pagtos-supcard-ocor.val-lancamento*/.
            END.


            /* Busca o t°tulo original da despesa */
            FIND FIRST bf_tit_acr NO-LOCK
                WHERE  bf_tit_acr.cod_estab       = STRING(INT(SUBSTRING(tt-int-pagtos-supcard-ocor.num-transac,1,4)))
                AND    bf_tit_acr.cod_espec_docto = "DM"
                AND    bf_tit_acr.cod_ser_docto   = STRING(INT(SUBSTRING(tt-int-pagtos-supcard-ocor.num-transac,5,3)))
                AND    bf_tit_acr.cod_tit_acr     = SUBSTRING(tt-int-pagtos-supcard-ocor.num-transac,8,7)
                AND    bf_tit_acr.cod_parcela     = STRING(tt-int-pagtos-supcard-ocor.num-parcela, "99") NO-ERROR.
            IF  AVAIL  bf_tit_acr THEN DO:

                IF  VALID-HANDLE(h-acomp) THEN
                    RUN pi-acompanhar IN h-acomp (INPUT "Gerando AVA das despesas - " + bf_tit_acr.cod_tit_acr + "-" + bf_tit_acr.cod_parcela).

                FOR EACH  val_tit_acr NO-LOCK
                    WHERE val_tit_acr.cod_estab        = bf_tit_acr.cod_estab
                    AND   val_tit_acr.num_id_tit_acr   = bf_tit_acr.num_id_tit_acr
                    AND   val_tit_acr.cod_finalid_econ = c-cod-finalid-econ
                    AND   val_tit_acr.val_perc_rat     > 0:
                    /* A taxa deve ser rateada para cada UN do t°tulo, conforme o % de rateio da UN */
                    FIND FIRST tt-taxas-adm EXCLUSIVE-LOCK
                        WHERE  tt-taxas-adm.num-bordero = c-num-bordero
                        AND    tt-taxas-adm.unid-negoc  = val_tit_acr.cod_unid_negoc NO-ERROR.
                    IF  NOT AVAIL tt-taxas-adm THEN DO:
                        CREATE tt-taxas-adm.
                        ASSIGN tt-taxas-adm.num-bordero = c-num-bordero
                               tt-taxas-adm.unid-negoc  = val_tit_acr.cod_unid_negoc.
                    END.

                    ASSIGN tt-taxas-adm.val-taxa = tt-taxas-adm.val-taxa + ((val_tit_acr.val_perc_rat * de-val-taxa / 100)).
                END.
            END.
            ELSE DO:
                IF  VALID-HANDLE(h-acomp) THEN
                    RUN pi-acompanhar IN h-acomp (INPUT "Gerando AVA das despesas - " + tit_acr.cod_tit_acr + "-" + tit_acr.cod_parcela).

                /* Se n∆o achou o t°tulo original da despesa, faz com base no t°tulo da SupplierCard */
                FOR EACH  val_tit_acr NO-LOCK
                    WHERE val_tit_acr.cod_estab        = tit_acr.cod_estab
                    AND   val_tit_acr.num_id_tit_acr   = tit_acr.num_id_tit_acr
                    AND   val_tit_acr.cod_finalid_econ = c-cod-finalid-econ
                    AND   val_tit_acr.val_perc_rat     > 0:
                    /* A taxa deve ser rateada para cada UN do t°tulo, conforme o % de rateio da UN */
                    FIND FIRST tt-taxas-adm EXCLUSIVE-LOCK
                        WHERE  tt-taxas-adm.num-bordero = c-num-bordero
                        AND    tt-taxas-adm.unid-negoc  = val_tit_acr.cod_unid_negoc NO-ERROR.
                    IF  NOT AVAIL tt-taxas-adm THEN DO:
                        CREATE tt-taxas-adm.
                        ASSIGN tt-taxas-adm.num-bordero = c-num-bordero
                               tt-taxas-adm.unid-negoc  = val_tit_acr.cod_unid_negoc.
                    END.

                    ASSIGN tt-taxas-adm.val-taxa = tt-taxas-adm.val-taxa + ((val_tit_acr.val_perc_rat * de-val-taxa / 100)).
                END.
            END.
        END.

        FIND FIRST int-pagtos-supcard-ocor EXCLUSIVE-LOCK
            WHERE  ROWID(int-pagtos-supcard-ocor) = tt-int-pagtos-supcard-ocor.r-rowid NO-ERROR.
        IF  AVAIL  int-pagtos-supcard-ocor THEN
            ASSIGN int-pagtos-supcard-ocor.log-conciliado = YES.
    END.
    

    /* Grava o rateio original do t°tulo da SupplierCard */
    FOR EACH  val_tit_acr NO-LOCK
        WHERE val_tit_acr.cod_estab        = tit_acr.cod_estab
        AND   val_tit_acr.num_id_tit_acr   = tit_acr.num_id_tit_acr
        AND   val_tit_acr.cod_finalid_econ = c-cod-finalid-econ
        AND   val_tit_acr.val_perc_rat     > 0:
        CREATE tt-rat-orig.
        ASSIGN tt-rat-orig.cod-unid-negoc  = val_tit_acr.cod_unid_negoc
               tt-rat-orig.val-sdo-tit-acr = val_tit_acr.val_sdo_tit_acr
               tt-rat-orig.val-perc-rat    = val_tit_acr.val_perc_rat.
    END.

    blk_taxas:
    FOR EACH tt-taxas-adm NO-LOCK
        BY   tt-taxas-adm.num-bordero:

        IF tt-taxas-adm.val-taxa = 0 
           THEN NEXT.

        IF  VALID-HANDLE(h-acomp) THEN
            RUN pi-acompanhar IN h-acomp (INPUT "Transferindo Unidades - " + tt-taxas-adm.unid-negoc).

        /**** Transferància das UNs do t°tulo para a nova UN ****/
        EMPTY TEMP-TABLE tt_vl_sdo_un_origem.
        EMPTY TEMP-TABLE tt_vl_transfdo_un.

        FOR EACH  val_tit_acr NO-LOCK
            WHERE val_tit_acr.cod_estab        = tit_acr.cod_estab
            AND   val_tit_acr.num_id_tit_acr   = tit_acr.num_id_tit_acr
            AND   val_tit_acr.cod_finalid_econ = c-cod-finalid-econ
            AND   val_tit_acr.val_perc_rat     > 0:
            CREATE tt_vl_sdo_un_origem.
            ASSIGN tt_vl_sdo_un_origem.ttv_cod_unid_negoc_orig = val_tit_acr.cod_unid_negoc
                   tt_vl_sdo_un_origem.ttv_val_sdo_unid_negoc  = val_tit_acr.val_sdo_tit_acr
                   tt_vl_sdo_un_origem.ttv_val_tot_transfdo    = val_tit_acr.val_sdo_tit_acr.

            CREATE tt_vl_transfdo_un.
            ASSIGN tt_vl_transfdo_un.ttv_cod_unid_negoc_orig = val_tit_acr.cod_unid_negoc
                   tt_vl_transfdo_un.ttv_cod_unid_negoc_dest = tt-taxas-adm.unid-negoc
                   tt_vl_transfdo_un.ttv_val_transfdo        = val_tit_acr.val_sdo_tit_acr
                   tt_vl_transfdo_un.ttv_val_perc_transf     = val_tit_acr.val_perc_rat.
        END.

        RUN pi-gera-referencia IN THIS-PROCEDURE (INPUT  tit_acr.cod_estab,
                                                  INPUT  RECID(tit_acr),
                                                  OUTPUT c-cod-refer).

        RUN prgfin/acr/acr702zh.py (INPUT  RECID(tit_acr),
                                    INPUT  c-cod-refer,
                                    INPUT  TODAY, /* Data Transaá∆o */
                                    INPUT  c-cod-finalid-econ,
                                    INPUT  "",    /* Hist¢rico */
                                    OUTPUT l-erro) /*prg_fnc_tit_acr_atualiza_transf_un*/.
        IF  RETURN-VALUE <> "OK" THEN DO:
            CREATE tt-mensagens.
            ASSIGN tt-mensagens.num-transac    = ""
                   tt-mensagens.cod-estab      = tit_acr.cod_estab
                   tt-mensagens.num-id-tit-acr = tit_acr.num_id_tit_acr
                   tt-mensagens.des-erro       = "Erro na transferància entre as UNs do T°tulo da SupplierCard, para as despesas administrativas."
                   tt-mensagens.l-erro         = YES.

            IF  OPSYS = "WIN32":U THEN
                RUN utp/ut-msgs.p(INPUT "show",
                                  INPUT 17006,
                                  INPUT "Erro na transferància entre as UNs do T°tulo da SupplierCard, para as despesas administrativas.~~"
                                      + tit_acr.cod_estab + CHR(10) + STRING(tit_acr.num_id_tit_acr)).

            RETURN "NOK":U.
        END.
        /**** Fim - Transferància ****/

        /**** Gera AVA da despesa no t°tulo ****/
        /* Verifica o tipo de despesa */
        CASE tt-taxas-adm.num-bordero:
            WHEN "RPASSP" THEN
                ASSIGN c-tipo-despesa = "Juros por Prorrogaá∆o de Vencimento".
            WHEN "RPASSC" THEN
                ASSIGN c-tipo-despesa = "Juros por Cancelamento de Contrato".
            WHEN "CANCEP" THEN
                ASSIGN c-tipo-despesa = "DÇbito por Cancelamento Parcial".
            WHEN "BONIFI" THEN
                ASSIGN c-tipo-despesa = "DÇbito por Lanáamento de Bonificaá∆o".
            OTHERWISE
                ASSIGN c-tipo-despesa = "Taxa Administraá∆o".
        END CASE.

        /* Localiza a conta que dever† gerar a despesa */
        FIND FIRST int-contas-supcard NO-LOCK
            WHERE  int-contas-supcard.tipo-despesa = c-tipo-despesa NO-ERROR.
        IF  AVAIL  int-contas-supcard THEN
            ASSIGN c-cod-cta-ctbl = int-contas-supcard.cod-conta.
        ELSE
            ASSIGN c-cod-cta-ctbl = c-cod-cta-tx-adm.

        EMPTY TEMP-TABLE tt_alter_tit_acr_rateio.
        EMPTY TEMP-TABLE tt_alter_tit_acr_base_2.

        /* ** Caso tenhamos mais DEBIT do que saldo no t°tulo da SupplierCard, efetua AVA atÇ o saldo e o restante vai para saldo do dia anterior ***/
        ASSIGN de-val-sdo-tit-acr = tit_acr.val_sdo_tit_acr - tt-taxas-adm.val-taxa.
        IF de-val-sdo-tit-acr < 0 
           THEN ASSIGN de-val-sdo-tit-acr = 0.

        RUN pi-gera-referencia IN THIS-PROCEDURE (INPUT  tit_acr.cod_estab,
                                                  INPUT  RECID(tit_acr),
                                                  OUTPUT c-cod-refer).

        ASSIGN i-cont = i-cont + 10.
        CREATE tt_alter_tit_acr_rateio.
        ASSIGN tt_alter_tit_acr_rateio.tta_cod_estab                   = tit_acr.cod_estab
               tt_alter_tit_acr_rateio.tta_num_id_tit_acr              = tit_acr.num_id_tit_acr
               tt_alter_tit_acr_rateio.ttv_ind_tip_rat_tit_acr         = "Alteraá∆o"
               tt_alter_tit_acr_rateio.tta_cod_refer                   = c-cod-refer
               tt_alter_tit_acr_rateio.tta_num_seq_refer               = i-cont
               tt_alter_tit_acr_rateio.tta_cod_plano_cta_ctbl          = "padrao"
               tt_alter_tit_acr_rateio.tta_cod_cta_ctbl                = c-cod-cta-ctbl
               tt_alter_tit_acr_rateio.tta_num_seq_aprop_ctbl_pend_acr = i-cont
               tt_alter_tit_acr_rateio.tta_val_aprop_ctbl              = IF de-val-sdo-tit-acr = 0 THEN tit_acr.val_sdo_tit_acr ELSE tt-taxas-adm.val-taxa.

        RELEASE tt_alter_tit_acr_rateio.

        RUN pi-gera-ava-titulo IN THIS-PROCEDURE.
        IF  RETURN-VALUE = "OK":U THEN DO:
            CREATE tt-mensagens.
            ASSIGN tt-mensagens.num-transac    = ""
                   tt-mensagens.cod-estab      = tit_acr.cod_estab
                   tt-mensagens.num-id-tit-acr = tit_acr.num_id_tit_acr
                   tt-mensagens.des-erro       = "AVA das despesas administrativas gerado para o t°tulo com sucesso. Unidade: " + tt-taxas-adm.unid-negoc + " Valor: " + STRING(tt-taxas-adm.val-taxa)
                   tt-mensagens.l-erro         = NO.
        END.
        ELSE
            RETURN "NOK":U.
        /**** Fim - AVA ****/

        /* ** Caso n∆o tenha mais saldo no t°tulo para descontar os DEBIT, finaliza os AVAs e o valor fica como saldo do dia anterior  ***/
        IF tit_acr.val_sdo_tit_acr = 0 
           THEN LEAVE blk_taxas.

    END.

    FOR EACH  val_tit_acr NO-LOCK
        WHERE val_tit_acr.cod_estab        = tit_acr.cod_estab
        AND   val_tit_acr.num_id_tit_acr   = tit_acr.num_id_tit_acr
        AND   val_tit_acr.cod_finalid_econ = c-cod-finalid-econ
        AND   val_tit_acr.val_perc_rat     > 0:
        CREATE tt-rat-alter.
        ASSIGN tt-rat-alter.cod-unid-negoc  = val_tit_acr.cod_unid_negoc
               tt-rat-alter.val-sdo-tit-acr = val_tit_acr.val_sdo_tit_acr
               tt-rat-alter.val-perc-rat    = val_tit_acr.val_perc_rat.
    END.


    /**** Transferància para voltar ao rateio original do T°tulo ****/
    IF  CAN-FIND(FIRST tt-taxas-adm) 
    AND tit_acr.val_sdo_tit_acr > 0 
    THEN DO:
        FOR EACH tt-rat-orig NO-LOCK:
            FOR EACH tt-rat-alter NO-LOCK:
                EMPTY TEMP-TABLE tt_vl_sdo_un_origem.
                EMPTY TEMP-TABLE tt_vl_transfdo_un.

                CREATE tt_vl_sdo_un_origem.
                ASSIGN tt_vl_sdo_un_origem.ttv_cod_unid_negoc_orig = tt-rat-alter.cod-unid-negoc
                       tt_vl_sdo_un_origem.ttv_val_sdo_unid_negoc  = tt-rat-alter.val-sdo-tit-acr
                       tt_vl_sdo_un_origem.ttv_val_tot_transfdo    = (tt-rat-alter.val-sdo-tit-acr * tt-rat-orig.val-perc-rat) / 100.
        
                CREATE tt_vl_transfdo_un.
                ASSIGN tt_vl_transfdo_un.ttv_cod_unid_negoc_orig = tt-rat-alter.cod-unid-negoc
                       tt_vl_transfdo_un.ttv_cod_unid_negoc_dest = tt-rat-orig.cod-unid-negoc
                       tt_vl_transfdo_un.ttv_val_transfdo        = (tt-rat-alter.val-sdo-tit-acr * tt-rat-orig.val-perc-rat) / 100.
                       tt_vl_transfdo_un.ttv_val_perc_transf     = (tt_vl_transfdo_un.ttv_val_transfdo * 100) / tt-rat-alter.val-sdo-tit-acr.
        
                RUN pi-gera-referencia IN THIS-PROCEDURE (INPUT  tit_acr.cod_estab,
                                                          INPUT  RECID(tit_acr),
                                                          OUTPUT c-cod-refer).
    
                RUN prgfin/acr/acr702zh.py (INPUT  RECID(tit_acr),
                                            INPUT  c-cod-refer,
                                            INPUT  TODAY, /* Data Transaá∆o */
                                            INPUT  c-cod-finalid-econ,
                                            INPUT  "",    /* Hist¢rico */
                                            OUTPUT l-erro) /*prg_fnc_tit_acr_atualiza_transf_un*/.
                IF  RETURN-VALUE <> "OK" THEN DO:
                    CREATE tt-mensagens.
                    ASSIGN tt-mensagens.num-transac    = ""
                           tt-mensagens.cod-estab      = tit_acr.cod_estab
                           tt-mensagens.num-id-tit-acr = tit_acr.num_id_tit_acr
                           tt-mensagens.des-erro       = "Erro na transferància entre as UNs do T°tulo da SupplierCard, para as despesas administrativas."
                           tt-mensagens.l-erro         = YES.

                IF  OPSYS = "WIN32":U THEN
                    RUN utp/ut-msgs.p(INPUT "show",
                                      INPUT 17006,
                                      INPUT "Erro na transferància entre as UNs do T°tulo da SupplierCard, para as despesas administrativas.~~"
                                          + tit_acr.cod_estab + CHR(10) + STRING(tit_acr.num_id_tit_acr)).
            
                    RETURN "NOK":U.
                END.
            END.
        END.
    END.
    /**** Fim - Transferància ****/


    /**** Gera um AVA do Saldo Negativo do Dia Anterior ****/
    IF  de-tot-sldan > 0 THEN DO:
        EMPTY TEMP-TABLE tt_alter_tit_acr_rateio.
        EMPTY TEMP-TABLE tt_alter_tit_acr_base_2.
    
        RUN pi-gera-referencia IN THIS-PROCEDURE (INPUT  tit_acr.cod_estab,
                                                  INPUT  RECID(tit_acr),
                                                  OUTPUT c-cod-refer).
    
        ASSIGN i-cont = i-cont + 10.
        CREATE tt_alter_tit_acr_rateio.
        ASSIGN tt_alter_tit_acr_rateio.tta_cod_estab                   = tit_acr.cod_estab
               tt_alter_tit_acr_rateio.tta_num_id_tit_acr              = tit_acr.num_id_tit_acr
               tt_alter_tit_acr_rateio.ttv_ind_tip_rat_tit_acr         = "Alteraá∆o"
               tt_alter_tit_acr_rateio.tta_cod_refer                   = c-cod-refer
               tt_alter_tit_acr_rateio.tta_num_seq_refer               = i-cont
               tt_alter_tit_acr_rateio.tta_cod_plano_cta_ctbl          = "padrao"
               tt_alter_tit_acr_rateio.tta_cod_cta_ctbl                = c-cod-cta-tx-adm
               tt_alter_tit_acr_rateio.tta_num_seq_aprop_ctbl_pend_acr = i-cont.

        IF  tit_acr.val_sdo_tit_acr > de-tot-sldan  THEN
            ASSIGN de-val-sdo-tit-acr                         = tit_acr.val_sdo_tit_acr - de-tot-sldan
                   tt_alter_tit_acr_rateio.tta_val_aprop_ctbl = de-tot-sldan.
        ELSE
            ASSIGN de-val-sdo-tit-acr                         = 0
                   tt_alter_tit_acr_rateio.tta_val_aprop_ctbl = tit_acr.val_sdo_tit_acr.
    
        RUN pi-gera-referencia IN THIS-PROCEDURE (INPUT  tit_acr.cod_estab,
                                                  INPUT  RECID(tit_acr),
                                                  OUTPUT c-cod-refer).
        RUN pi-gera-ava-titulo IN THIS-PROCEDURE.
        IF  RETURN-VALUE = "OK":U THEN DO:
            CREATE tt-mensagens.
            ASSIGN tt-mensagens.num-transac    = "T°tulo SupplierCard"
                   tt-mensagens.cod-estab      = tit_acr.cod_estab
                   tt-mensagens.num-id-tit-acr = tit_acr.num_id_tit_acr
                   tt-mensagens.des-erro       = "AVA do Saldo Negativo do Dia Anterior gerado para o t°tulo com sucesso."
                   tt-mensagens.l-erro         = NO.
        END.
        ELSE
            RETURN "NOK":U.
    END.
    /**** Fim - AVA Saldo Negativo Dia Anterior ****/

    RETURN "OK":U.
END PROCEDURE.


PROCEDURE WinExec EXTERNAL "kernel32.dll":U:
    DEF INPUT  PARAM prg_name   AS CHARACTER.
    DEF INPUT  PARAM prg_style  AS SHORT.
END PROCEDURE.
