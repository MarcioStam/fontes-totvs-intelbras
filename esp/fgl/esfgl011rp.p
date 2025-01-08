{include/i-prgvrs.i esfgl011rp 2.00.00.001}

{esp/es0018.i}

DEFINE VARIABLE c-arquivo-csv AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-dir-saida   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-arq-excel   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE h-acomp       AS HANDLE      NO-UNDO.
DEFINE VARIABLE primeiro-dia  AS DATE        NO-UNDO.
DEFINE VARIABLE ultimo-dia    AS DATE        NO-UNDO.

DEFINE VARIABLE v_val_cotac AS DECIMAL     NO-UNDO.

DEF BUFFER b_movto_tit_ap     FOR movto_tit_ap.
DEF BUFFER b_movto_tit_acr    FOR movto_tit_acr.

DEF NEW GLOBAL SHARED VAR v_cod_empres_usuar
    AS CHARACTER
    FORMAT "x(3)":U
    LABEL "Empresa"
    COLUMN-LABEL "Empresa"
    NO-UNDO.

DEFINE STREAM str-excel.

define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)"
    field usuario          as char format "x(12)"
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field desc-classifica  as char format "x(40)"
    field modelo-rtf       as char format "x(35)"
    field l-habilitaRtf    as LOG
    FIELD periodo          AS CHAR
    FIELD acr              AS LOG
    FIELD apb              AS LOG.
    
DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.

DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

{utp/ut-glob.i}

DO ON STOP UNDO, LEAVE:

    ASSIGN c-arquivo-csv = "esfgl011_" + STRING(TIME) + ".csv":U.

    IF  OPSYS = "unix" THEN DO:
        EMPTY TEMP-TABLE tt-prog-ponto.
    
        RUN esp/es0018p.p (INPUT "SPOOL-UNIX":U,
                           INPUT 1,
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-ponto).
    
        FOR FIRST tt-prog-ponto:
            ASSIGN c-dir-saida = REPLACE(tt-prog-ponto.conteudo, "~\":U, "/":U).
        END. /* FOR FIRST tt-prog-ponto: */

        ASSIGN c-dir-saida =  c-dir-saida + "/":U + c-seg-usuario + "/":U.
        OS-CREATE-DIR VALUE(c-dir-saida).
        ASSIGN c-arq-excel = c-dir-saida + TRIM(c-arquivo-csv).
    END. /* IF  OPSYS = "unix" THEN DO: */
    ELSE DO:
        EMPTY TEMP-TABLE tt-prog-ponto.
    
        RUN esp/es0018p.p (INPUT "SPOOL-WIN":U,
                           INPUT 1,
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-ponto).
    
        FOR FIRST tt-prog-ponto:
            ASSIGN c-dir-saida = REPLACE(tt-prog-ponto.conteudo, "/":U, "~\":U).
        END. /* FOR FIRST tt-prog-ponto: */

        ASSIGN c-dir-saida =  c-dir-saida + "/":U + c-seg-usuario + "/":U.
        OS-CREATE-DIR VALUE(c-dir-saida).
        ASSIGN c-arq-excel = c-dir-saida + TRIM(c-arquivo-csv).
    END.
END.


DO ON STOP UNDO, LEAVE:
    
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
    RUN pi-inicializar in h-acomp (input "Buscando ...").

    OUTPUT STREAM str-excel TO value(c-arq-excel) NO-CONVERT.
    
    PUT STREAM str-excel UNFORMATTED "M¢dulo;Estabelecimento;Emitente; Esp‚cie;S‚rie;T¡tulo;Parcela;Moeda;Saldo;Dt Transacao;Dt Lancamento;Hr Lancamento;Usuario;Cotacao" SKIP.

    ASSIGN primeiro-dia = DATE("01/" + substring(tt-param.periodo,1,2) + "/" + substring(tt-param.periodo,3,4))
           ultimo-dia  = primeiro-dia + 31 - DAY(primeiro-dia + 31).

    /*Main*/
    FOR EACH estabelecimento NO-LOCK
       WHERE estabelecimento.cod_empresa = v_cod_empres_usuar:
        
        IF tt-param.acr THEN DO:
            FOR EACH tit_acr NO-LOCK
               WHERE tit_acr.cod_estab = estabelecimento.cod_estab
                 AND tit_acr.log_sdo
                 AND NOT tit_acr.log_tit_acr_estordo
                 AND tit_acr.cod_indic_econ <> "Real"
                 AND tit_acr.dat_transacao  <= ultimo-dia:

                FIND FIRST movto_tit_acr OF tit_acr NO-LOCK 
                     WHERE movto_tit_acr.ind_trans_acr_abrev = "CVAL" 
                       AND movto_tit_acr.dat_transacao       = ultimo-dia /* £ltimo dia do per¡odo informado em tela */ NO-ERROR.
                IF NOT AVAIL movto_tit_acr THEN  DO:

                    FIND LAST movto_tit_acr OF tit_acr NO-LOCK
                        WHERE movto_tit_acr.log_ctbz_aprop_ctbl
                          AND movto_tit_acr.dat_transacao <= ultimo-dia NO-ERROR.

                    FIND val_movto_acr_correc_val OF movto_tit_acr NO-LOCK
                        WHERE val_movto_acr_correc_val.cod_finalid_econ = "Corrente" NO-ERROR.

                    IF AVAIL val_movto_acr_correc_val 
                    THEN DO:                       
                         ASSIGN v_val_cotac = 1 / val_movto_acr_correc_val.val_cotac_indic_econ.
                    END.
                    ELSE DO:
                         FIND LAST b_movto_tit_acr OF tit_acr NO-LOCK
                             WHERE b_movto_tit_acr.dat_transacao      = movto_tit_acr.dat_transacao
                               AND (b_movto_tit_acr.ind_trans_acr_abrev = "CVLL" OR b_movto_tit_acr.ind_trans_acr_abrev = "CVAL") NO-ERROR.
                         IF AVAIL b_movto_tit_acr
                         THEN DO:
                             FIND val_movto_acr_correc_val OF b_movto_tit_acr NO-LOCK
                                 WHERE val_movto_acr_correc_val.cod_finalid_econ = "Corrente" NO-ERROR.

                             ASSIGN v_val_cotac = 0.

                             IF AVAIL val_movto_acr_correc_val 
                             THEN DO:                       
                                  ASSIGN v_val_cotac = 1 / val_movto_acr_correc_val.val_cotac_indic_econ.
                             END.
                         END.
                    END.

                    RUN pi-acompanhar IN h-acomp (INPUT "Estab: " + estabelecimento.cod_estab + " T¡tulo ACR: " + tit_acr.cod_tit_acr).
                    PUT STREAM str-excel UNFORMATTED "ACR" + ";" +
                                                     STRING(tit_acr.cod_estab      )        + ";" +
                                                     STRING(tit_acr.cdn_cliente    )        + ";" +
                                                     STRING(tit_acr.cod_espec      )        + ";" +
                                                     STRING(tit_acr.cod_ser        )        + ";" +
                                                     STRING(tit_acr.cod_tit_acr    )        + ";" +
                                                     STRING(tit_acr.cod_parcela    )        + ";" +
                                                     STRING(tit_acr.cod_indic_econ )        + ";" +
                                                     STRING(tit_acr.val_sdo_tit_acr)        + ";" + 
                                                     STRING(movto_tit_acr.dat_transacao)    + ";" + 
                                                     STRING(movto_tit_acr.dat_gerac_movto)  + ";" +
                                                     STRING(movto_tit_acr.hra_gerac_movto, "99:99:99")  + ";" +
                                                     STRING(movto_tit_acr.cod_usuario)      + ";" +
                                                     STRING(v_val_cotac) SKIP.
                END.
            END.
        END.

        /* Se flag considera M¢dulo APB */
        IF tt-param.apb THEN DO:
            FOR EACH tit_ap NO-LOCK
                WHERE tit_ap.cod_estab = estabelecimento.cod_estab
                  AND tit_ap.log_sdo
                  AND NOT tit_ap.log_tit_ap_estordo
                  AND tit_ap.cod_indic_econ <> "Real"
                  AND tit_ap.dat_transacao  <= ultimo-dia:

                FIND FIRST movto_tit_ap OF tit_ap NO-LOCK 
                     WHERE movto_tit_ap.ind_trans_ap_abrev = "CVAL" 
                       AND movto_tit_ap.dat_transacao      = ultimo-dia /* £ltimo dia do per¡odo informado em tela */ NO-ERROR.
                IF NOT AVAIL movto_tit_ap THEN DO:

                    FIND LAST movto_tit_ap OF tit_ap NO-LOCK
                        WHERE movto_tit_ap.log_ctbz_aprop_ctbl
                          AND movto_tit_ap.dat_transacao <= ultimo-dia NO-ERROR.

                    FIND val_movto_ap_correc_val OF movto_tit_ap NO-LOCK
                        WHERE val_movto_ap_correc_val.cod_finalid_econ = "Corrente" NO-ERROR.

                    ASSIGN v_val_cotac = 0.

                    IF AVAIL val_movto_ap_correc_val 
                    THEN DO:                       
                         ASSIGN v_val_cotac = 1 / val_movto_ap_correc_val.val_cotac_indic_econ.
                    END.
                    ELSE DO:
                         FIND LAST b_movto_tit_ap OF tit_ap NO-LOCK
                             WHERE b_movto_tit_ap.dat_transacao      = movto_tit_ap.dat_transacao
                               AND (b_movto_tit_ap.ind_trans_ap_abrev = "CVLP" OR b_movto_tit_ap.ind_trans_ap_abrev = "CVAL") NO-ERROR.
                         IF AVAIL b_movto_tit_ap 
                         THEN DO:
                             FIND val_movto_ap_correc_val OF b_movto_tit_ap NO-LOCK
                                 WHERE val_movto_ap_correc_val.cod_finalid_econ = "Corrente" NO-ERROR.

                             ASSIGN v_val_cotac = 0.

                             IF AVAIL val_movto_ap_correc_val 
                             THEN DO:                       
                                  ASSIGN v_val_cotac = 1 / val_movto_ap_correc_val.val_cotac_indic_econ.
                             END.
                         END.
                    END.

                    RUN pi-acompanhar IN h-acomp (INPUT "Estab: " + estabelecimento.cod_estab + " T¡tulo APB: " + tit_ap.cod_tit_ap).
                    PUT STREAM str-excel UNFORMATTED "APB" + ";" + 
                                                     STRING(tit_ap.cod_estab     )          + ";" + 
                                                     STRING(tit_ap.cdn_fornec    )          + ";" + 
                                                     STRING(tit_ap.cod_espec     )          + ";" + 
                                                     STRING(tit_ap.cod_ser       )          + ";" + 
                                                     STRING(tit_ap.cod_tit_ap    )          + ";" + 
                                                     STRING(tit_ap.cod_parcela   )          + ";" + 
                                                     STRING(tit_ap.cod_indic_econ)          + ";" + 
                                                     STRING(tit_ap.val_sdo_tit_ap)          + ";" + 
                                                     STRING(movto_tit_ap.dat_transacao)     + ";" + 
                                                     STRING(movto_tit_ap.dat_gerac_movto)   + ";" + 
                                                     STRING(movto_tit_ap.hra_gerac_movto, "99:99:99")   + ";" +
                                                     STRING(movto_tit_ap.cod_usuario)       + ";" +
                                                     STRING(v_val_cotac) SKIP.
                END.
            END.
        END.
    END.
    
    RUN pi-finalizar IN h-acomp.

    OUTPUT STREAM str-excel CLOSE.

    IF NOT OPSYS = "unix" THEN DO:
        DOS SILENT START excel VALUE(c-arq-excel).
    END.

    RETURN "OK".   
END.
