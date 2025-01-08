{esp/es0018.i}
DEFINE TEMP-TABLE tt-param-271 NO-UNDO
    FIELD DataInicio         AS DATE
    FIELD DataFim            AS DATE
    FIELD StatusSolicitacao  AS CHAR
    FIELD StatusDespesa      AS CHAR
    FIELD TipoData           AS CHAR.

DEFINE TEMP-TABLE tt-param-273 NO-UNDO
    FIELD CodigoARB           AS CHAR
    FIELD DataPagamento       AS DATE
    FIELD TipoPagamento       AS CHAR
    FIELD Moeda               AS CHAR
    FIELD NumeroContaCorrente AS CHAR
    FIELD ProvisaoPagamento   AS DEC
    FIELD Observacao          AS CHAR.

DEFINE TEMP-TABLE tt-param-274 NO-UNDO
    FIELD CodigoARB        AS CHAR
    FIELD NomeSolicitacao  AS CHAR
    FIELD ValorSolicitacao AS DEC.


DEFINE TEMP-TABLE tt-param-272 NO-UNDO
    FIELD CodigoARB LIKE int_solicitacao_alatur.request_number_arb.

{esp/esb/esesb000.i}
{esp/cms/apb900zg.i}
{esp/esb/out/msg0271.i}
{esp/esb/out/msg0272.i}
{cdp/cd0666.i}
{esp/ala/ala0003rp.i}
{utp/utapi019.i}

DEFINE VARIABLE c-arquivo-csv          AS CHARACTER                                     NO-UNDO.
DEFINE VARIABLE c-dir-saida            AS CHARACTER                                     NO-UNDO.
DEFINE VARIABLE c-arq-excel            AS CHARACTER                                     NO-UNDO.
DEFINE VARIABLE h-acomp                AS HANDLE                                        NO-UNDO.
DEFINE VARIABLE v_hdl_aux              AS HANDLE                                        NO-UNDO.
DEFINE VARIABLE c-msg-mail             AS CHARACTER                                     NO-UNDO.
DEFINE VARIABLE i-conta-refer          AS INTEGER                                       NO-UNDO.
DEFINE VARIABLE c-tipo-exec            AS CHARACTER                                     NO-UNDO.
DEFINE VARIABLE i-nr-entry             AS INTEGER                                       NO-UNDO.
DEFINE VARIABLE v_request_company_name LIKE int_solicitacao_alatur.request_company_name NO-UNDO.
DEFINE VARIABLE v_cta_reemb            LIKE Reembolso.CodigoContaContabil               NO-UNDO.

DEFINE BUFFER b_int_solicitacao_alatur FOR int_solicitacao_alatur.

DEFINE STREAM str-excel.

DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino                       AS INTEGER
    FIELD arquivo                       AS CHAR FORMAT "x(35)"
    FIELD usuario                       AS CHAR FORMAT "x(12)"
    FIELD data-exec                     AS DATE
    field hora-exec                     as INTEGER
    FIELD tipo-exec                     AS CHAR
    FIELD l-adiantamento                AS LOG
    FIELD adiantamento-rq               AS CHAR
    FIELD adiantamento-ex               AS CHAR
    FIELD adiantamento-dt               AS CHAR
    FIELD l-adiantamento-viagem         AS LOG
    FIELD adiantamento-viagem-rq        AS CHAR
    FIELD adiantamento-viagem-ex        AS CHAR
    FIELD adiantamento-viagem-dt        AS CHAR
    FIELD l-cartao-credito              AS LOG
    FIELD cartao-credito-rq             AS CHAR
    FIELD cartao-credito-ex             AS CHAR
    FIELD cartao-credito-dt             AS CHAR
    FIELD l-prestacao-contas            AS LOG
    FIELD prestacao-contas-rq           AS CHAR
    FIELD prestacao-contas-ex           AS CHAR
    FIELD prestacao-contas-dt           AS CHAR
    FIELD l-prestacao-contas-ad         AS LOG
    FIELD prestacao-contas-ad-rq        AS CHAR
    FIELD prestacao-contas-ad-ex        AS CHAR
    FIELD prestacao-contas-ad-dt        AS CHAR
    FIELD l-prestacao-contas-ad-viagem  AS LOG
    FIELD prestacao-contas-ad-viagem-rq AS CHAR
    FIELD prestacao-contas-ad-viagem-ex AS CHAR
    FIELD prestacao-contas-ad-viagem-dt AS CHAR
    FIELD l-avulso                      AS LOG
    FIELD avulso-rq                     AS CHAR
    FIELD avulso-ex                     AS CHAR
    FIELD avulso-dt                     AS CHAR
    FIELD data-avulso-ini               AS DATE
    FIELD data-avulso-fim               AS DATE.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.

DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

{utp/ut-glob.i}

FUNCTION trataChars RETURN CHARACTER (INPUT pTexto AS CHAR) FORWARD.
    
DO ON STOP UNDO, LEAVE:

    ASSIGN c-arquivo-csv = "ALA0003_" + STRING(TIME) + ".csv":U.

    IF  OPSYS = "unix" THEN DO:
        EMPTY TEMP-TABLE tt-prog-ponto.
    
        RUN esp/es0018p.p (INPUT "SPOOL-UNIX":U,
                           INPUT 1,
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-ponto).
    
        FOR FIRST tt-prog-ponto:
            ASSIGN c-dir-saida = REPLACE(tt-prog-ponto.conteudo, "~\":U, "/":U).
        END. 

        ASSIGN c-dir-saida =  c-dir-saida + "/":U + c-seg-usuario + "/":U.
        OS-CREATE-DIR VALUE(c-dir-saida).
        ASSIGN c-arq-excel = c-dir-saida + TRIM(c-arquivo-csv).
    END. 
    ELSE DO:
        EMPTY TEMP-TABLE tt-prog-ponto.
    
        RUN esp/es0018p.p (INPUT "SPOOL-WIN":U,
                           INPUT 1,
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-ponto).
    
        FOR FIRST tt-prog-ponto:
            ASSIGN c-dir-saida = REPLACE(tt-prog-ponto.conteudo, "/":U, "~\":U).
        END. 

        ASSIGN c-dir-saida =  c-dir-saida + "/":U + c-seg-usuario + "/":U.
        OS-CREATE-DIR VALUE(c-dir-saida).
        ASSIGN c-arq-excel = c-dir-saida + TRIM(c-arquivo-csv).
    END.
END.


DO ON STOP UNDO, LEAVE:
    
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
    RUN pi-inicializar in h-acomp (input "Integrando ...").

    OUTPUT STREAM str-excel TO value(c-arq-excel) NO-CONVERT.

    RUN pi-principal.
    RUN pi-envia-email.
    
    RUN pi-finalizar IN h-acomp.

    OUTPUT STREAM str-excel CLOSE.

    IF NOT OPSYS = "unix" THEN DO:
        DOS SILENT START excel VALUE(c-arq-excel).
    END.

    RETURN "OK".   
END.

PROCEDURE pi-principal:
    FIND LAST int_param_alatur NO-LOCK NO-ERROR.

    IF tt-param.l-adiantamento THEN DO:
        RUN pi-acompanhar IN h-acomp (INPUT "Buscando Adiantamentos").

        PUT STREAM str-excel UNFORMATTED "Adiantamentos: " SKIP.

        RUN pi-integracao (INPUT TODAY - int_param_alatur.num_dias_integra_ad,
                           INPUT TODAY,
                           INPUT tt-param.adiantamento-rq,
                           INPUT tt-param.adiantamento-ex,
                           INPUT tt-param.adiantamento-dt,
                           INPUT "AD").

        PUT STREAM str-excel SKIP (2).
    END.

    IF tt-param.l-adiantamento-viagem THEN DO:
        RUN pi-acompanhar IN h-acomp (INPUT "Buscando Adiantamentos Viagem").

        PUT STREAM str-excel UNFORMATTED "Adiantamentos Viagem: " SKIP.

        RUN pi-integracao (INPUT TODAY - int_param_alatur.num_dias_integra_ad,
                           INPUT TODAY,
                           INPUT tt-param.adiantamento-viagem-rq,
                           INPUT tt-param.adiantamento-viagem-ex,
                           INPUT tt-param.adiantamento-viagem-dt,
                           INPUT "AD").

        PUT STREAM str-excel SKIP (2).
    END.

    IF tt-param.l-cartao-credito THEN DO:
        RUN pi-acompanhar IN h-acomp (INPUT "Buscando Cart∆o de CrÇdito").
        PUT STREAM str-excel UNFORMATTED "Cart∆o de CrÇdito: " SKIP.

        RUN pi-integracao (INPUT TODAY - int_param_alatur.num_dias_integra_cr,
                           INPUT TODAY,
                           INPUT tt-param.cartao-credito-rq,
                           INPUT tt-param.cartao-credito-ex,
                           INPUT tt-param.cartao-credito-dt,
                           INPUT "AD").

        PUT STREAM str-excel SKIP (2).
    END.

    IF tt-param.l-prestacao-contas THEN DO:
        RUN pi-acompanhar IN h-acomp (INPUT "Buscando Prestaá∆o de Contas").
        PUT STREAM str-excel UNFORMATTED "Prestaá∆o de Contas: " SKIP.

        RUN pi-integracao (INPUT TODAY - int_param_alatur.num_dias_integra_pc,
                           INPUT TODAY,
                           INPUT tt-param.prestacao-contas-rq,
                           INPUT tt-param.prestacao-contas-ex,
                           INPUT tt-param.prestacao-contas-dt,
                           INPUT "PC").

        PUT STREAM str-excel SKIP (2).
    END.

    IF tt-param.l-prestacao-contas-ad THEN DO:
        RUN pi-acompanhar IN h-acomp (INPUT "Buscando Prestaá∆o de Contas AD").
        PUT STREAM str-excel UNFORMATTED "Prestaá∆o de Contas AD: " SKIP.
        RUN pi-integracao (INPUT TODAY - int_param_alatur.num_dias_integra_pc,
                           INPUT TODAY,
                           INPUT tt-param.prestacao-contas-ad-rq,
                           INPUT tt-param.prestacao-contas-ad-ex,
                           INPUT tt-param.prestacao-contas-ad-dt,
                           INPUT "PC").

        PUT STREAM str-excel SKIP (2).
    END.

    IF tt-param.l-prestacao-contas-ad-viagem THEN DO:
        RUN pi-acompanhar IN h-acomp (INPUT "Buscando Prestaá∆o de Contas AD Viagem").
        PUT STREAM str-excel UNFORMATTED "Prestaá∆o de Contas AD Viagem: " SKIP.
        RUN pi-integracao (INPUT TODAY - int_param_alatur.num_dias_integra_pc,
                           INPUT TODAY,
                           INPUT tt-param.prestacao-contas-ad-viagem-rq,
                           INPUT tt-param.prestacao-contas-ad-viagem-ex,
                           INPUT tt-param.prestacao-contas-ad-viagem-dt,
                           INPUT "PC").

        PUT STREAM str-excel SKIP (2).
    END.

    IF tt-param.l-avulso THEN DO:
        PUT STREAM str-excel UNFORMATTED "Avulsos: " SKIP.

        RUN pi-integracao (INPUT tt-param.data-avulso-ini,
                           INPUT tt-param.data-avulso-fim,
                           INPUT tt-param.avulso-rq,
                           INPUT tt-param.avulso-ex,
                           INPUT tt-param.avulso-dt,
                           INPUT "AV").
    END.
END PROCEDURE.

PROCEDURE pi-integracao:
    DEFINE INPUT PARAM p-data-ini          AS DATE.
    DEFINE INPUT PARAM p-data-fim          AS DATE.
    DEFINE INPUT PARAM p-StatusSolicitacao AS CHAR.
    DEFINE INPUT PARAM p-StatusDespesa     AS CHAR.
    DEFINE INPUT PARAM p-TipoData          AS CHAR.
    DEFINE INPUT PARAM p-TipoExec          AS CHAR.
         
    EMPTY TEMP-TABLE tt_ord_compra_tit_ap_pend_1.
    EMPTY TEMP-TABLE tt_1099.
    EMPTY TEMP-TABLE tt_log_erros_atualiz_an.
    EMPTY TEMP-TABLE tt-erro.
    EMPTY TEMP-TABLE tt-param-271.
    EMPTY TEMP-TABLE ItemSolicitacaoAdiantamento.
    EMPTY TEMP-TABLE tt_integr_apb_antecip_pef_p1.
    EMPTY TEMP-TABLE tt_integr_apb_aprop_ctbl_pend.
    EMPTY TEMP-TABLE tt_integr_apb_item_lote_impl3v.
    EMPTY TEMP-TABLE tt_integr_apb_item_lote_impl_3.
    EMPTY TEMP-TABLE tt_log_erros_comis. 
    EMPTY TEMP-TABLE tt_integr_apb_abat_antecip_vouc. 
    EMPTY TEMP-TABLE tt_integr_apb_abat_prev_provis. 
    EMPTY TEMP-TABLE tt_integr_apb_aprop_relacto. 
    EMPTY TEMP-TABLE tt_integr_apb_impto_impl_pend. 
    EMPTY TEMP-TABLE tt_integr_apb_item_lote_impl. 
    EMPTY TEMP-TABLE tt_integr_apb_lote_impl. 
    EMPTY TEMP-TABLE tt_integr_apb_relacto_pend. 
    EMPTY TEMP-TABLE tt_log_erros_atualiz.
    EMPTY TEMP-TABLE tt-contas.
    EMPTY TEMP-TABLE tt-rateios.

    ASSIGN i-conta-refer   = 0.

    CREATE tt-param-271.
    ASSIGN tt-param-271.DataInicio        = p-data-ini
           tt-param-271.DataFim           = p-data-fim
           tt-param-271.StatusSolicitacao = p-StatusSolicitacao
           tt-param-271.StatusDespesa     = p-StatusDespesa
           tt-param-271.TipoData          = p-TipoData.

    RAW-TRANSFER tt-param-271 TO raw-param.

    /*Lista Solicitaá‰es*/
    RUN esp/esb/out/msg0271.p (INPUT raw-param,
                               OUTPUT TABLE ItemSolicitacaoAdiantamento).

    /*Cabeáalho*/
    IF CAN-FIND (FIRST ItemSolicitacaoAdiantamento) THEN
        PUT STREAM str-excel UNFORMATTED "Nr. Requis.;Empresa Requis.;Nome Conta;CPF Passag.;Banco Passag.;Agenc. Passag.;Cta. Corr. Passag.;Desp.;Dt. Fim;Dt. Inclu.;Dt. Ini.;Preáo;Qtd.;Hist. Rat.;Hist. Reemb.;Dt. Cria. PC; Hr. Cria. PC; Usuar. Cria. PC; Tit. PC;Obs.;" skip.

    FOR EACH ItemSolicitacaoAdiantamento:

        RUN pi-acompanhar IN h-acomp (INPUT "Detalhando: " + ItemSolicitacaoAdiantamento.CodigoARB).

        FIND FIRST int_solicitacao_alatur NO-LOCK
             WHERE int_solicitacao_alatur.request_number_arb = STRING(INT(ItemSolicitacaoAdiantamento.CodigoARB)) NO-ERROR.

        /*Deleta registros com CPF branco para reprocessar*/
        IF  AVAIL int_solicitacao_alatur
        AND int_solicitacao_alatur.request_passenger_CPF = "" THEN DO:
            FIND CURRENT int_solicitacao_alatur EXCLUSIVE-LOCK.
            DELETE int_solicitacao_alatur.
        END.

        IF NOT AVAIL int_solicitacao_alatur THEN DO:
            EMPTY TEMP-TABLE tt-param-272.
    
            CREATE tt-param-272.
            ASSIGN tt-param-272.CodigoARB = ItemSolicitacaoAdiantamento.CodigoARB.
    
            RAW-TRANSFER tt-param-272 TO raw-param.
            /*Detalhar andrey*/
            RUN esp/esb/out/msg0272.p (INPUT  raw-param,
                                       OUTPUT TABLE msg0272r,
                                       OUTPUT TABLE CentroCusto,
                                       OUTPUT TABLE Reembolso,
                                       OUTPUT TABLE Resultado).

            IF  CAN-FIND (FIRST msg0272r) 
            AND CAN-FIND (FIRST Resultado
                          WHERE Resultado.Sucesso = YES) THEN DO:
                
                IF tt-param.tipo-exec = "2" THEN DO:
                    RUN pi-cria-solicitacao.
                    
                    /*Para PC s¢ tipos de despesa "Viagem Nacional" e "" s∆o processadas*/
                    IF (p-TipoExec = "AD" AND int_solicitacao_alatur.advance_expense <> "")
                    OR (p-TipoExec = "PC" AND (int_solicitacao_alatur.advance_expense = "Viagem Nacional" OR int_solicitacao_alatur.advance_expense = "")) THEN
                        RUN pi-imprime-com-registro (INPUT p-TipoExec).

                    IF  p-TipoExec = "AD" THEN DO:

                        IF  int_solicitacao_alatur.advance_expense = "Cart∆o de CrÇdito"
                        AND int_solicitacao_alatur.num_id_tit_ap = 0 THEN DO:
                            
                            IF  int_solicitacao_alatur.request_description MATCHES("*rotativo*") THEN DO:
                                RUN pi-gera-tt-antecip-pef-pend (INPUT int_param_alatur.cod_estab_cr,
                                                                 INPUT int_param_alatur.cod_espec_docto_cr,
                                                                 INPUT int_param_alatur.cod_ser_docto_rot,
                                                                 INPUT "",
                                                                 INPUT "PADRAO",
                                                                 INPUT int_param_alatur.cod_cta_ctbl_cr,
                                                                 INPUT int_param_alatur.num_dias_vencto_cr,
                                                                 INPUT int_param_alatur.cod_unid_negoc_cr,
                                                                 INPUT int_param_alatur.cod_tip_fluxo_financ_cr).
                            END.
                            ELSE DO:
                                RUN pi-gera-tt-antecip-pef-pend (INPUT int_param_alatur.cod_estab_cr,
                                                                 INPUT int_param_alatur.cod_espec_docto_cr,
                                                                 INPUT int_param_alatur.cod_ser_docto_cr,
                                                                 INPUT "",
                                                                 INPUT "PADRAO",
                                                                 INPUT int_param_alatur.cod_cta_ctbl_cr,
                                                                 INPUT int_param_alatur.num_dias_vencto_cr,
                                                                 INPUT int_param_alatur.cod_unid_negoc_cr,
                                                                 INPUT int_param_alatur.cod_tip_fluxo_financ_cr).
                            END.

                        END.
                
                        IF  int_solicitacao_alatur.advance_expense = "Viagem Nacional"
                        AND int_solicitacao_alatur.cod_refer_antecip_pef_pend = ""  THEN DO:
                            
                            IF  int_solicitacao_alatur.request_description MATCHES("*rotativo*") THEN DO:
                                RUN pi-gera-tt-antecip-pef-pend (INPUT int_param_alatur.cod_estab_ad,
                                                                 INPUT int_param_alatur.cod_espec_docto_ad,
                                                                 INPUT int_param_alatur.cod_ser_docto_rot,
                                                                 INPUT int_param_alatur.cod_portador_ad,
                                                                 INPUT "",
                                                                 INPUT "",
                                                                 INPUT int_param_alatur.num_dias_vencto_ad,
                                                                 INPUT int_param_alatur.cod_unid_negoc_ad,
                                                                 INPUT int_param_alatur.cod_tip_fluxo_financ_ad).
                            END.
                            ELSE DO:
                                RUN pi-gera-tt-antecip-pef-pend (INPUT int_param_alatur.cod_estab_ad,
                                                                 INPUT int_param_alatur.cod_espec_docto_ad,
                                                                 INPUT int_param_alatur.cod_ser_docto_ad,
                                                                 INPUT int_param_alatur.cod_portador_ad,
                                                                 INPUT "",
                                                                 INPUT "",
                                                                 INPUT int_param_alatur.num_dias_vencto_ad,
                                                                 INPUT int_param_alatur.cod_unid_negoc_ad,
                                                                 INPUT int_param_alatur.cod_tip_fluxo_financ_ad).
                            END.
                        END.
                    END.

                    IF  int_solicitacao_alatur.num_id_tit_ap = 0
                    AND p-TipoExec = "PC" THEN DO:

                        ASSIGN v_request_company_name = TRIM(int_solicitacao_alatur.request_company_name).

                        ASSIGN i-nr-entry = NUM-ENTRIES(v_request_company_name, " ").

                        RUN pi-gera-tt-prestacao-contas (INPUT entry(i-nr-entry, v_request_company_name, " "),
                                                         INPUT int_param_alatur.cod_espec_docto_pc,
                                                         INPUT int_param_alatur.cod_ser_docto_pc,
                                                         INPUT int_param_alatur.num_dias_vencto_pc,
                                                         INPUT int_param_alatur.cod_portador_pc,
                                                         INPUT int_param_alatur.cod_tip_fluxo_financ_pc).
                        IF  CAN-FIND(FIRST tt_integr_apb_lote_impl) THEN 
                            RUN pi-integra-prestacao-contas.
                        
                    END.
                END.
                ELSE DO:
                    RUN pi-imprime-sem-registro.
                END.
            END.
            ELSE DO:
                FIND FIRST Resultado NO-ERROR.
                CREATE tt-erro.
                ASSIGN tt-erro.cd-erro  = 17006
                       tt-erro.mensagem = "Ocorreu um erro na integraá∆o da solicitaá∆o " + ItemSolicitacaoAdiantamento.CodigoARB + ". Solicitaá∆o n∆o integrada. ".

                IF  AVAIL Resultado
                AND NOT Resultado.Sucesso THEN
                    ASSIGN tt-erro.mensagem = tt-erro.mensagem + Resultado.Mensagem.
            END.
        END.
        ELSE DO:
            IF  AVAIL int_solicitacao_alatur
            AND int_solicitacao_alatur.request_company_name BEGINS "Renovigi" THEN DO: /* considerar apenas solicitacoes da Intelbras */
                CREATE tt-erro.
                ASSIGN tt-erro.cd-erro  = 17007
                       tt-erro.mensagem = "Solicitaá∆o da Renovigi ser† ignorada. C¢digo da solicitaá∆o: " + ItemSolicitacaoAdiantamento.CodigoARB + " .".

                RETURN "NOK".
            END.

            IF tt-param.tipo-exec = "2" THEN DO:
                IF  p-TipoExec = "AD" THEN DO:

                    IF  int_solicitacao_alatur.advance_expense = "Cart∆o de CrÇdito"
                    AND int_solicitacao_alatur.num_id_tit_ap = 0 THEN DO:
                        
                        IF  int_solicitacao_alatur.request_description MATCHES("*rotativo*") THEN DO:
                            RUN pi-gera-tt-antecip-pef-pend (INPUT int_param_alatur.cod_estab_cr,
                                                             INPUT int_param_alatur.cod_espec_docto_cr,
                                                             INPUT int_param_alatur.cod_ser_docto_rot,
                                                             INPUT "",
                                                             INPUT "PADRAO",
                                                             INPUT int_param_alatur.cod_cta_ctbl_cr,
                                                             INPUT int_param_alatur.num_dias_vencto_cr,
                                                             INPUT int_param_alatur.cod_unid_negoc_cr,
                                                             INPUT int_param_alatur.cod_tip_fluxo_financ_cr).
                        END.
                        ELSE DO:
                            RUN pi-gera-tt-antecip-pef-pend (INPUT int_param_alatur.cod_estab_cr,
                                                             INPUT int_param_alatur.cod_espec_docto_cr,
                                                             INPUT int_param_alatur.cod_ser_docto_cr,
                                                             INPUT "",
                                                             INPUT "PADRAO",
                                                             INPUT int_param_alatur.cod_cta_ctbl_cr,
                                                             INPUT int_param_alatur.num_dias_vencto_cr,
                                                             INPUT int_param_alatur.cod_unid_negoc_cr,
                                                             INPUT int_param_alatur.cod_tip_fluxo_financ_cr).
                        END.
                    END.
            
                    IF  int_solicitacao_alatur.advance_expense = "Viagem Nacional"
                    AND int_solicitacao_alatur.cod_refer_antecip_pef_pend = "" THEN DO:
                        IF  int_solicitacao_alatur.request_description MATCHES("*rotativo*") THEN DO:
                            RUN pi-gera-tt-antecip-pef-pend (INPUT int_param_alatur.cod_estab_ad,
                                                             INPUT int_param_alatur.cod_espec_docto_ad,
                                                             INPUT int_param_alatur.cod_ser_docto_rot,
                                                             INPUT int_param_alatur.cod_portador_ad,
                                                             INPUT "",
                                                             INPUT "",
                                                             INPUT int_param_alatur.num_dias_vencto_ad,
                                                             INPUT int_param_alatur.cod_unid_negoc_ad,
                                                             INPUT int_param_alatur.cod_tip_fluxo_financ_ad).
                        END.
                        ELSE DO:
                            RUN pi-gera-tt-antecip-pef-pend (INPUT int_param_alatur.cod_estab_ad,
                                                             INPUT int_param_alatur.cod_espec_docto_ad,
                                                             INPUT int_param_alatur.cod_ser_docto_ad,
                                                             INPUT int_param_alatur.cod_portador_ad,
                                                             INPUT "",
                                                             INPUT "",
                                                             INPUT int_param_alatur.num_dias_vencto_ad,
                                                             INPUT int_param_alatur.cod_unid_negoc_ad,
                                                             INPUT int_param_alatur.cod_tip_fluxo_financ_ad).
                        END.
                    END.
                END.

                IF  int_solicitacao_alatur.num_id_tit_ap = 0
                AND p-TipoExec = "PC" THEN DO:
                    /*Chama o detalhe para preencher o refund_histor_rateio*/
                    IF int_solicitacao_alatur.refund_histor_rateio = "" THEN DO:
                        EMPTY TEMP-TABLE tt-param-272.
    
                        CREATE tt-param-272.
                        ASSIGN tt-param-272.CodigoARB = ItemSolicitacaoAdiantamento.CodigoARB.
                
                        RAW-TRANSFER tt-param-272 TO raw-param.
                        /*Detalhar*/
                        RUN esp/esb/out/msg0272.p (INPUT  raw-param,
                                                   OUTPUT TABLE msg0272r,
                                                   OUTPUT TABLE CentroCusto,
                                                   OUTPUT TABLE Reembolso,
                                                   OUTPUT TABLE Resultado).

                        IF  CAN-FIND (FIRST msg0272r) 
                        AND CAN-FIND (FIRST Resultado
                                      WHERE Resultado.Sucesso = YES) THEN DO:
                            FIND CURRENT int_solicitacao_alatur EXCLUSIVE-LOCK.
                            
                            FOR EACH Reembolso:
                                ASSIGN v_cta_reemb = replace(Reembolso.CodigoContaContabil,"-","|").

                                IF int_solicitacao_alatur.refund_histor_rateio <> "" THEN
                                    ASSIGN int_solicitacao_alatur.refund_histor_rateio = int_solicitacao_alatur.refund_histor_rateio + "|".
                    
                                ASSIGN int_solicitacao_alatur.refund_histor_rateio = int_solicitacao_alatur.refund_histor_rateio +
                                                                                     v_cta_reemb + "|" + 
                                                                                     STRING(Reembolso.ValorDespesa) + "|" + 
                                                                                     STRING(Reembolso.QuantidadeDespesa).
                            END.
                            FIND CURRENT int_solicitacao_alatur NO-LOCK.
                        END.
                    END.
                    
                    ASSIGN v_request_company_name = TRIM(int_solicitacao_alatur.request_company_name).

                    ASSIGN i-nr-entry = NUM-ENTRIES(v_request_company_name, " ").

                    RUN pi-gera-tt-prestacao-contas (INPUT entry(i-nr-entry, v_request_company_name, " "),
                                                     INPUT int_param_alatur.cod_espec_docto_pc,
                                                     INPUT int_param_alatur.cod_ser_docto_pc,
                                                     INPUT int_param_alatur.num_dias_vencto_pc,
                                                     INPUT int_param_alatur.cod_portador_pc,
                                                     INPUT int_param_alatur.cod_tip_fluxo_financ_pc).
                    IF  CAN-FIND(FIRST tt_integr_apb_lote_impl) THEN 
                        RUN pi-integra-prestacao-contas.
                END.
            END.
            /*Para PC s¢ tipos de despesa "Viagem Nacional" e "" s∆o processadas*/
            IF (p-TipoExec = "AD" AND int_solicitacao_alatur.advance_expense <> "")
            OR (p-TipoExec = "PC" AND (int_solicitacao_alatur.advance_expense = "Viagem Nacional" OR int_solicitacao_alatur.advance_expense = "")) THEN
                RUN pi-imprime-com-registro (INPUT p-TipoExec).
        END.
    END. /*FOR EACH ItemSolicitacaoAdiantamento*/

    IF CAN-FIND (FIRST tt_integr_apb_antecip_pef_p1) THEN
        RUN pi-integra-antecip-pef-pend.

    /* 
    IF  CAN-FIND(FIRST tt_integr_apb_lote_impl) THEN 
        RUN pi-integra-prestacao-contas.
      */

    IF CAN-FIND (FIRST tt-erro) THEN DO:
        PUT STREAM str-excel SKIP (2).
        PUT STREAM str-excel UNFORMATTED "Integraá‰es com Erros: " SKIP.
    END.
    
    FOR EACH tt-erro:
        ASSIGN c-msg-mail = c-msg-mail + tt-erro.mensagem + CHR(10).

        PUT STREAM str-excel UNFORMATTED tt-erro.mensagem SKIP.
    END.
END PROCEDURE.

PROCEDURE pi-cria-solicitacao:
    FIND FIRST msg0272r NO-ERROR.

    IF  AVAIL msg0272r THEN DO:
        
        RUN pi-acompanhar IN h-acomp (INPUT "Imprimindo: " + msg0272r.CodigoARB).

        IF  NOT msg0272r.NomeEmpresa BEGINS "Renovigi" THEN DO: /* considerar apenas solicitacoes da Intelbras */
            
            CREATE int_solicitacao_alatur.
            ASSIGN int_solicitacao_alatur.request_number                  = STRING(INT(ItemSolicitacaoAdiantamento.CodigoARB)) 
                   int_solicitacao_alatur.request_company_name            = msg0272r.NomeEmpresa 
                   int_solicitacao_alatur.account_name                    = msg0272r.NomeCentroCusto 
                   int_solicitacao_alatur.request_passenger_CPF           = msg0272r.CPF
                   int_solicitacao_alatur.request_passenger_bank          = msg0272r.NumeroBanco 
                   int_solicitacao_alatur.request_passenger_branch_number = msg0272r.NumeroAgencia 
                   int_solicitacao_alatur.request_passenger_checking_acc  = msg0272r.NumeroContaCorrente 
                   int_solicitacao_alatur.advance_expense                 = msg0272r.DescricaoDespesa 
                   int_solicitacao_alatur.advance_final_date              = msg0272r.DataHoraFinalAdiantamento 
                   int_solicitacao_alatur.advance_include_date            = msg0272r.DataHoraSolicitacaoAdiantamento 
                   int_solicitacao_alatur.advance_initial_date            = msg0272r.DataHoraInicialAdiantamento 
                   int_solicitacao_alatur.advance_price                   = msg0272r.ValorAdiantamento  
                   int_solicitacao_alatur.advance_quantity                = msg0272r.QuantidadeAdiantamento
                   int_solicitacao_alatur.dat_pay_ad                      = 01/01/0001
                   int_solicitacao_alatur.dat_pay_pc                      = 01/01/0001
                   int_solicitacao_alatur.val_total_ad                    = int_solicitacao_alatur.advance_price * int_solicitacao_alatur.advance_quantity
                   int_solicitacao_alatur.request_description             = msg0272r.DescricaoSolicitacao.
    
            ASSIGN int_solicitacao_alatur.request_arb_id = ItemSolicitacaoAdiantamento.IdentificadorARB.
    
            ASSIGN int_solicitacao_alatur.advance_note = trataChars(msg0272r.Observacao).
    
            FOR EACH CentroCusto:
                ASSIGN CentroCusto.CodigoCentroCusto = REPLACE(CentroCusto.CodigoCentroCusto,"|","").
                IF int_solicitacao_alatur.advance_hitor_rateio <> "" THEN
                    ASSIGN int_solicitacao_alatur.advance_hitor_rateio = int_solicitacao_alatur.advance_hitor_rateio + "|".
    
                ASSIGN int_solicitacao_alatur.advance_hitor_rateio = int_solicitacao_alatur.advance_hitor_rateio + 
                                                                     CentroCusto.CodigoCentroCusto + "|" + 
                                                                     CentroCusto.NomeEmpresaRateio + "|" + 
                                                                     STRING(CentroCusto.PorcentagemDebito).
            END.
    
            FOR EACH Reembolso:
                ASSIGN v_cta_reemb = replace(Reembolso.CodigoContaContabil,"-","|").
    
                IF int_solicitacao_alatur.refund_histor_rateio <> "" THEN
                    ASSIGN int_solicitacao_alatur.refund_histor_rateio = int_solicitacao_alatur.refund_histor_rateio + "|".
    
                ASSIGN int_solicitacao_alatur.refund_histor_rateio = int_solicitacao_alatur.refund_histor_rateio +
                                                                     v_cta_reemb + "|" + 
                                                                     STRING(Reembolso.ValorDespesa) + "|" + 
                                                                     STRING(Reembolso.QuantidadeDespesa).
            END.
        END.
        ELSE DO:
            CREATE tt-erro.
            ASSIGN tt-erro.cd-erro  = 17006
                   tt-erro.mensagem = "Solicitaá∆o da Renovigi ser† ignorada. C¢digo da solicitaá∆o: " + ItemSolicitacaoAdiantamento.CodigoARB + " .".
            
            RETURN "NOK".
        END.
    END.
END PROCEDURE.

PROCEDURE pi-imprime-com-registro:
    DEFINE INPUT PARAM p-TipoExec          AS CHAR.

    DEFINE VARIABLE v_advance_final_date   AS CHAR        NO-UNDO.
    DEFINE VARIABLE v_advance_include_date AS CHAR        NO-UNDO.
    DEFINE VARIABLE v_advance_initial_date AS CHAR        NO-UNDO.
    DEFINE VARIABLE v_dat_create_pc        AS CHAR        NO-UNDO.

    IF int_solicitacao_alatur.advance_expense = "Cart∆o Saque" THEN
        RETURN "OK".

    IF  p-TipoExec = "AD" 
    AND int_solicitacao_alatur.advance_expense = "Cart∆o de CrÇdito"
    AND int_solicitacao_alatur.num_id_tit_ap   <> 0 THEN 
        RETURN "OK".

    IF  p-TipoExec = "AD" 
    AND int_solicitacao_alatur.advance_expense = "Viagem Nacional"
    AND int_solicitacao_alatur.cod_refer_antecip_pef_pend <> "" THEN
        RETURN "OK".

    IF  p-TipoExec = "PC" 
    AND int_solicitacao_alatur.num_id_tit_ap <> 0 THEN
        RETURN "OK".

    IF  p-TipoExec = "PC"
    AND int_solicitacao_alatur.advance_expense = "" THEN DO:
        FIND CURRENT int_solicitacao_alatur EXCLUSIVE-LOCK.
        ASSIGN int_solicitacao_alatur.advance_expense = "Viagem Nacional".
        FIND CURRENT int_solicitacao_alatur NO-LOCK.
    END.

    RUN pi-acompanhar IN h-acomp (INPUT "Imprimindo: " + int_solicitacao_alatur.request_number).
    
    ASSIGN v_advance_final_date   = IF int_solicitacao_alatur.advance_final_date   <> ? THEN STRING(int_solicitacao_alatur.advance_final_date  ) ELSE ""
           v_advance_include_date = IF int_solicitacao_alatur.advance_include_date <> ? THEN STRING(int_solicitacao_alatur.advance_include_date) ELSE ""
           v_advance_initial_date = IF int_solicitacao_alatur.advance_initial_date <> ? THEN STRING(int_solicitacao_alatur.advance_initial_date) ELSE ""
           v_advance_initial_date = IF int_solicitacao_alatur.dat_create_pc        <> ? THEN STRING(int_solicitacao_alatur.dat_create_pc) ELSE "".

    PUT STREAM str-excel UNFORMATTED int_solicitacao_alatur.request_number                  + ";" +
                                     int_solicitacao_alatur.request_company_name            + ";" +
                                     int_solicitacao_alatur.account_name                    + ";" +
                                     int_solicitacao_alatur.request_passenger_CPF           + ";" +
                                     int_solicitacao_alatur.request_passenger_bank          + ";" +
                                     int_solicitacao_alatur.request_passenger_branch_number + ";" +
                                     int_solicitacao_alatur.request_passenger_checking_acc  + ";" +
                                     int_solicitacao_alatur.advance_expense                 + ";" +
                                     v_advance_final_date                                   + ";" + 
                                     v_advance_include_date                                 + ";" + 
                                     v_advance_initial_date                                 + ";" + 
                                     STRING(int_solicitacao_alatur.advance_price   )        + ";" +
                                     STRING(int_solicitacao_alatur.advance_quantity)        + ";" +
                                     int_solicitacao_alatur.advance_hitor_rateio            + ";" +
                                     int_solicitacao_alatur.refund_histor_rateio            + ";" +
                                     v_dat_create_pc                                        + ";" +
                                     int_solicitacao_alatur.hra_create_pc                   + ";" +
                                     int_solicitacao_alatur.cod_usuar_create_pc             + ";" +
                                     STRING(int_solicitacao_alatur.num_id_tit_ap)           + ";" +
                                     int_solicitacao_alatur.advance_note                    + ";" SKIP.

END PROCEDURE.

PROCEDURE pi-imprime-sem-registro:
    DEFINE VARIABLE c-advance-histor AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-refund-histor  AS CHARACTER   NO-UNDO.

    ASSIGN c-advance-histor = ""
           c-refund-histor  = "".

    FIND FIRST msg0272r NO-ERROR.

    IF AVAIL msg0272r THEN DO:

        IF msg0272r.DescricaoDespesa  = "Cart∆o Saque"
        OR msg0272r.DescricaoDespesa = "" THEN
            RETURN "OK".
    
        FOR EACH CentroCusto:
            ASSIGN CentroCusto.CodigoCentroCusto = REPLACE(CentroCusto.CodigoCentroCusto,"|","").
            IF c-advance-histor <> "" THEN
                ASSIGN c-advance-histor = c-advance-histor + "|".
    
            ASSIGN c-advance-histor = c-advance-histor + 
                                      CentroCusto.CodigoCentroCusto + "|" + 
                                      CentroCusto.NomeEmpresaRateio + "|" + 
                                      STRING(CentroCusto.PorcentagemDebito).
        END.
    
        FOR EACH Reembolso:
            ASSIGN v_cta_reemb = replace(Reembolso.CodigoContaContabil,"-","|").

            IF c-refund-histor <> "" THEN
                ASSIGN c-refund-histor = c-refund-histor + "|".
    
            ASSIGN c-refund-histor = c-refund-histor +
                                     v_cta_reemb  + "|" + 
                                     STRING(Reembolso.ValorDespesa) + "|" + 
                                     STRING(Reembolso.QuantidadeDespesa).
        END.

        PUT STREAM str-excel UNFORMATTED msg0272r.CodigoARB                               + ";" + 
                                         msg0272r.NomeEmpresa                             + ";" + 
                                         msg0272r.NomeCentroCusto                         + ";" + 
                                         msg0272r.CPF                                     + ";" + 
                                         msg0272r.NumeroBanco                             + ";" + 
                                         msg0272r.NumeroAgencia                           + ";" + 
                                         msg0272r.NumeroContaCorrente                     + ";" + 
                                         msg0272r.DescricaoDespesa                        + ";" + 
                                         STRING(msg0272r.DataHoraFinalAdiantamento      ) + ";" + 
                                         STRING(msg0272r.DataHoraSolicitacaoAdiantamento) + ";" + 
                                         STRING(msg0272r.DataHoraInicialAdiantamento    ) + ";" + 
                                         STRING(msg0272r.ValorAdiantamento)               + ";" + 
                                         STRING(msg0272r.QuantidadeAdiantamento)          + ";" +
                                         c-advance-histor                                 + ";" +
                                         c-refund-histor                                  + ";" +
                                         msg0272r.Observacao                              SKIP.
    END.

    RETURN "OK".
END PROCEDURE.

PROCEDURE pi-gera-tt-antecip-pef-pend:
    DEFINE INPUT PARAM p-cod-estab            LIKE tt_integr_apb_antecip_pef_p1.tta_cod_estab.
    DEFINE INPUT PARAM p-cod-espec-docto      LIKE tt_integr_apb_antecip_pef_p1.tta_cod_espec_docto.
    DEFINE INPUT PARAM p-cod-ser-docto        LIKE tt_integr_apb_antecip_pef_p1.tta_cod_ser_docto.
    DEFINE INPUT PARAM p-cod-portador         LIKE tt_integr_apb_antecip_pef_p1.tta_cod_portador.
    DEFINE INPUT PARAM p-cod-plano-cta-ctbl   LIKE tt_integr_apb_aprop_ctbl_pend.tta_cod_plano_cta_ctbl.
    DEFINE INPUT PARAM p-cod-cta-ctbl         LIKE tt_integr_apb_aprop_ctbl_pend.tta_cod_cta_ctbl.
    DEFINE INPUT PARAM p-num-dias-vencto      AS INT.
    DEFINE INPUT PARAM p-cod-unid-negoc       LIKE tt_integr_apb_aprop_ctbl_pend.tta_cod_unid_negoc.
    DEFINE INPUT PARAM p-cod-tip-fluxo-financ LIKE tt_integr_apb_aprop_ctbl_pend.tta_cod_tip_fluxo_financ.

    DEFINE VARIABLE v_log_refer_uni  AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE v_cod_refer      AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE v_dat_vencto     AS DATE        NO-UNDO.
    DEFINE VARIABLE v_dat_min_vencto AS DATE        NO-UNDO.
    DEFINE VARIABLE v-cod-return     AS CHARACTER   NO-UNDO.

    IF  int_param_alatur.log_integra_an         = YES THEN DO:

        /* l¢gica para popular a v_cod_refer com referància £nica */
        ASSIGN v_log_refer_uni = NO.
      
        REPEAT WHILE v_log_refer_uni = NO:
           RUN pi_retorna_sugestao_referencia (INPUT "P",
                                               INPUT TODAY,
                                               OUTPUT v_cod_refer).

           RUN pi_verifica_refer_unica_apb (INPUT p-cod-estab,
                                            INPUT v_cod_refer,
                                            OUTPUT v_log_refer_uni).
        END.

        FIND FIRST estabelecimento NO-LOCK
             WHERE estabelecimento.cod_estab = p-cod-estab NO-ERROR.
    
        IF NOT AVAIL estabelecimento THEN DO:
             CREATE tt-erro.
             ASSIGN tt-erro.cd-erro  = 17006
                    tt-erro.mensagem = "Erro na integraá∆o com contas a pagar. Estabelecimento n∆o cadastrado. Estabelecimento: " + STRING(p-cod-estab) + " Solicitaá∆o: " + int_solicitacao_alatur.request_number.
             RETURN "NOK".
        END.
         
        IF int_solicitacao_alatur.request_passenger_CPF = "" THEN DO:
            CREATE tt-erro.
            ASSIGN tt-erro.cd-erro  = 17006
                   tt-erro.mensagem = "Erro na integraá∆o com contas a pagar. CPF da solicitaá∆o em branco. Solicitaá∆o: " + int_solicitacao_alatur.request_number.
            RETURN "NOK".
        END.

        FIND FIRST emscad.fornecedor NO-LOCK
             WHERE emscad.fornecedor.cod_empresa  = estabelecimento.cod_empresa
               AND emscad.fornecedor.cod_pais     = "BRA"
               AND emscad.fornecedor.cod_id_feder = int_solicitacao_alatur.request_passenger_CPF NO-ERROR.
    
        IF NOT AVAIL emscad.fornecedor THEN DO:
             CREATE tt-erro.
             ASSIGN tt-erro.cd-erro  = 17006
                    tt-erro.mensagem = "Erro na integraá∆o com contas a pagar. Fornecedor n∆o cadastrado. Empresa: " + STRING(estabelecimento.cod_empresa) + " Id Feder: " + STRING(int_solicitacao_alatur.request_passenger_CPF) + " Solicitaá∆o: " + int_solicitacao_alatur.request_number.
             RETURN "NOK".
        END.
         
        FIND FIRST fornec_financ NO-LOCK
             WHERE fornec_financ.cod_empresa  = emscad.fornecedor.cod_empresa
               AND fornec_financ.cdn_fornec   = emscad.fornecedor.cdn_fornec NO-ERROR.

        IF NOT AVAIL fornec_financ THEN DO:
             CREATE tt-erro.
             ASSIGN tt-erro.cd-erro  = 17006
                    tt-erro.mensagem = "Erro na integraá∆o com contas a pagar. Fornecedor financeiro n∆o cadastrado. Empresa: " + STRING(emscad.fornecedor.cod_empresa) + " Fornecedor: " + STRING(emscad.fornecedor.cod_empresa) + " Solicitaá∆o: " + int_solicitacao_alatur.request_number.
             RETURN "NOK".
        END.

        RUN pi_retornar_vencto (INPUT p-cod-estab,
                                INPUT "Respons†vel Financeiro",
                                INPUT p-num-dias-vencto,
                                INPUT TODAY,
                                INPUT YES,
                                OUTPUT v_dat_min_vencto,
                                OUTPUT v-cod-return).

        /*Atrasado*/
        IF int_solicitacao_alatur.advance_initial_date < TODAY THEN DO:
            /*Calcula v_dat_vencto*/
            RUN pi_retornar_vencto (INPUT p-cod-estab,
                                    INPUT "Respons†vel Financeiro",
                                    INPUT p-num-dias-vencto,
                                    INPUT TODAY,
                                    INPUT YES,
                                    OUTPUT v_dat_vencto,
                                    OUTPUT v-cod-return).
        END.
        ELSE DO:
            /*Calcula v_dat_vencto*/
            RUN pi_retornar_vencto (INPUT p-cod-estab,
                                    INPUT "Respons†vel Financeiro",
                                    INPUT p-num-dias-vencto,
                                    INPUT int_solicitacao_alatur.advance_initial_date,
                                    INPUT NO,
                                    OUTPUT v_dat_vencto,
                                    OUTPUT v-cod-return).
        END.

        IF v_dat_vencto < v_dat_min_vencto THEN
            ASSIGN v_dat_vencto = v_dat_min_vencto.

        IF  v_dat_vencto > int_solicitacao_alatur.advance_final_date
        AND int_solicitacao_alatur.advance_expense <> "Cart∆o de CrÇdito" THEN DO:

            CREATE tt-erro.
            ASSIGN tt-erro.cd-erro  = 17006
                   tt-erro.mensagem = "Erro na integraá∆o com contas a pagar. Data de vencimento calculada " + STRING(v_dat_vencto) + " maior que a data final da solicitaá∆o " + STRING(int_solicitacao_alatur.advance_final_date) + ". Solicitaá∆o: " + int_solicitacao_alatur.request_number.
            RETURN "NOK".
        END.

        CREATE tt_integr_apb_antecip_pef_p1.
        ASSIGN tt_integr_apb_antecip_pef_p1.tta_cod_empresa           = estabelecimento.cod_empresa           
               tt_integr_apb_antecip_pef_p1.tta_cod_estab             = p-cod-estab
               tt_integr_apb_antecip_pef_p1.tta_cod_refer             = v_cod_refer
               tt_integr_apb_antecip_pef_p1.tta_cod_espec_docto       = p-cod-espec-docto
               tt_integr_apb_antecip_pef_p1.tta_cod_ser_docto         = p-cod-ser-docto
               tt_integr_apb_antecip_pef_p1.tta_cdn_fornecedor        = emscad.fornecedor.cdn_fornec
               tt_integr_apb_antecip_pef_p1.tta_cod_tit_ap            = int_solicitacao_alatur.request_number
               tt_integr_apb_antecip_pef_p1.tta_cod_parcela           = "1"
               tt_integr_apb_antecip_pef_p1.tta_cod_portador          = p-cod-portador
               tt_integr_apb_antecip_pef_p1.tta_cod_indic_econ        = "REAL"
               tt_integr_apb_antecip_pef_p1.tta_val_tit_ap            = (int_solicitacao_alatur.advance_price * int_solicitacao_alatur.advance_quantity)
               tt_integr_apb_antecip_pef_p1.tta_val_cotac_indic_econ  = 1.000
               tt_integr_apb_antecip_pef_p1.tta_dat_vencto_tit_ap     = v_dat_vencto
               tt_integr_apb_antecip_pef_p1.tta_ind_tip_refer         = "Antecipaá∆o"
               tt_integr_apb_antecip_pef_p1.tta_des_text_histor       = int_solicitacao_alatur.advance_expense + "," + int_solicitacao_alatur.account_name + "," + int_solicitacao_alatur.advance_note
               tt_integr_apb_antecip_pef_p1.tta_ind_natur_cta_ctbl    = "1"
               tt_integr_apb_antecip_pef_p1.tta_cod_usuar_gerac_movto = v_cod_usuar_corren   
               tt_integr_apb_antecip_pef_p1.ttv_rec_antecip_pef_pend  = RECID(tt_integr_apb_antecip_pef_p1)  
               tt_integr_apb_antecip_pef_p1.tta_ind_origin_tit_ap     = "APB".

        IF int_solicitacao_alatur.advance_expense = "Cart∆o de CrÇdito" THEN
            ASSIGN tt_integr_apb_antecip_pef_p1.tta_dat_emis_docto = int_solicitacao_alatur.advance_include_date.
        ELSE 
            ASSIGN tt_integr_apb_antecip_pef_p1.tta_dat_emis_docto = IF int_solicitacao_alatur.advance_include_date < int_solicitacao_alatur.advance_initial_date THEN int_solicitacao_alatur.advance_include_date ELSE int_solicitacao_alatur.advance_initial_date.
         
        CREATE tt_integr_apb_aprop_ctbl_pend.
        ASSIGN tt_integr_apb_aprop_ctbl_pend.ttv_rec_antecip_pef_pend = tt_integr_apb_antecip_pef_p1.ttv_rec_antecip_pef_pend
               tt_integr_apb_aprop_ctbl_pend.tta_cod_plano_cta_ctbl   = p-cod-plano-cta-ctbl
               tt_integr_apb_aprop_ctbl_pend.tta_cod_cta_ctbl         = p-cod-cta-ctbl
               tt_integr_apb_aprop_ctbl_pend.tta_cod_unid_negoc       = p-cod-unid-negoc
               tt_integr_apb_aprop_ctbl_pend.tta_cod_tip_fluxo_financ = p-cod-tip-fluxo-financ
               tt_integr_apb_aprop_ctbl_pend.tta_val_aprop_ctbl       = tt_integr_apb_antecip_pef_p1.tta_val_tit_ap.
    END.
    /*ELSE DO:
        CREATE tt-erro.
        ASSIGN tt-erro.cd-erro  = 17006
               tt-erro.mensagem = "Solicitaá∆o n∆o integrada. Solicitaá∆o anterior a data de in°cio da integraá∆o ou integraá∆o desativada. Solicitaá∆o: " + int_solicitacao_alatur.request_number.
        RETURN "NOK".
    END.*/
END PROCEDURE.

PROCEDURE pi-integra-antecip-pef-pend:
        RUN prgfin/apb/apb905zd.py PERSISTENT SET v_hdl_aux.

        RUN pi_main_block_antecip_pef_pend_2 IN v_hdl_aux (INPUT 3,
                                                           INPUT  "",
                                                           INPUT-OUTPUT TABLE tt_integr_apb_antecip_pef_p1,
                                                           INPUT TABLE  tt_integr_apb_aprop_ctbl_pend,
                                                           INPUT TABLE  tt_integr_apb_impto_impl_pend,
                                                           INPUT TABLE  tt_integr_apb_abat_prev_provis,
                                                           OUTPUT TABLE tt_log_erros_atualiz_an,
                                                           INPUT TABLE  tt_1099,
                                                           INPUT TABLE  tt_ord_compra_tit_ap_pend_1).
        DELETE PROCEDURE v_hdl_aux.
         
        FOR EACH tt_log_erros_atualiz_an:
            FIND FIRST tt_integr_apb_antecip_pef_p1
                 WHERE tt_integr_apb_antecip_pef_p1.tta_cod_estab = tt_log_erros_atualiz_an.tta_cod_estab 
                   AND tt_integr_apb_antecip_pef_p1.tta_cod_refer = tt_log_erros_atualiz_an.tta_cod_refer  NO-ERROR.

            CREATE tt-erro.
            ASSIGN tt-erro.cd-erro  = 17006
                   tt-erro.mensagem = "Erro API AN/PEF: " + tt_log_erros_atualiz_an.ttv_des_msg_erro + " Solicitaá∆o: " + tt_integr_apb_antecip_pef_p1.tta_cod_tit_ap.
        END.
        
        /*Atualiza os registros gerados*/
        FOR EACH tt_integr_apb_antecip_pef_p1:
            FIND FIRST int_solicitacao_alatur NO-LOCK
                 WHERE int_solicitacao_alatur.request_number = tt_integr_apb_antecip_pef_p1.tta_cod_tit_ap NO-ERROR.

            IF int_solicitacao_alatur.advance_expense = "Viagem Nacional" THEN DO:
                FIND FIRST antecip_pef_pend NO-LOCK
                     WHERE antecip_pef_pend.cod_estab = tt_integr_apb_antecip_pef_p1.tta_cod_estab
                       AND antecip_pef_pend.cod_refer = tt_integr_apb_antecip_pef_p1.tta_cod_refer NO-ERROR.
        
                IF AVAIL antecip_pef_pend THEN DO:

                    /*** Elimina liberacao que Ç feita automatica pela API ***/
                    FIND LAST proces_pagto EXCLUSIVE-LOCK
                        WHERE proces_pagto.cod_estab             = antecip_pef_pend.cod_estab
                          AND proces_pagto.cod_refer_antecip_pef = antecip_pef_pend.cod_refer NO-ERROR.
                    IF AVAIL proces_pagto THEN 
                        DELETE proces_pagto.
                    /******/

                    FIND CURRENT int_solicitacao_alatur EXCLUSIVE-LOCK NO-ERROR.
    
                    IF AVAIL int_solicitacao_alatur THEN DO:
                        ASSIGN int_solicitacao_alatur.dat_create_ad              = TODAY
                               int_solicitacao_alatur.hra_create_ad              = STRING(TIME,"HH:MM:SS")
                               int_solicitacao_alatur.cod_usuar_create_ad        = v_cod_usuar_corren
                               int_solicitacao_alatur.cod_refer_antecip_pef_pend = tt_integr_apb_antecip_pef_p1.tta_cod_refer.
                    END.
        
                    FIND CURRENT int_solicitacao_alatur NO-LOCK.
                END.
            END.
            ELSE IF int_solicitacao_alatur.advance_expense = "Cart∆o de CrÇdito" THEN DO:
                FIND FIRST tit_ap NO-LOCK
                     WHERE tit_ap.cod_estab   = tt_integr_apb_antecip_pef_p1.tta_cod_estab
                       AND tit_ap.cdn_fornec  = tt_integr_apb_antecip_pef_p1.tta_cdn_fornecedor 
                       AND tit_ap.cod_espec   = tt_integr_apb_antecip_pef_p1.tta_cod_espec_docto
                       AND tit_ap.cod_ser     = tt_integr_apb_antecip_pef_p1.tta_cod_ser_docto  
                       AND tit_ap.cod_tit_ap  = tt_integr_apb_antecip_pef_p1.tta_cod_tit_ap 
                       AND tit_ap.cod_parcela = tt_integr_apb_antecip_pef_p1.tta_cod_parcela NO-ERROR.

                IF AVAIL tit_ap THEN DO:
                    FIND CURRENT int_solicitacao_alatur EXCLUSIVE-LOCK NO-ERROR.
    
                    IF AVAIL int_solicitacao_alatur THEN DO:
                        ASSIGN int_solicitacao_alatur.dat_create_ad       = TODAY
                               int_solicitacao_alatur.hra_create_ad       = STRING(TIME,"HH:MM:SS")
                               int_solicitacao_alatur.cod_usuar_create_ad = v_cod_usuar_corren
                               int_solicitacao_alatur.num_id_tit_ap       = tit_ap.num_id_tit_ap.
                    END.
        
                    FIND CURRENT int_solicitacao_alatur NO-LOCK.
                END.                    
            END.
        END.
        
    RETURN "OK".
END PROCEDURE.

PROCEDURE pi_retorna_sugestao_referencia:

    /************************ Parameter Definition Begin ************************/

    def Input param p_ind_tip_atualiz
        as character
        format "X(08)"
        no-undo.
    def Input param p_dat_refer
        as date
        format "99/99/9999"
        no-undo.
    def output param p_cod_refer
        as character
        format "x(10)"
        no-undo.
    
    def var v_des_dat                        as character       no-undo. /*local*/
    def var v_num_aux                        as integer         no-undo. /*local*/
    def var v_num_aux_2                      as integer         no-undo. /*local*/
    def var v_num_cont                       as integer         no-undo. /*local*/

    assign v_des_dat   = string(p_dat_refer,"99999999")
           p_cod_refer = substring(v_des_dat,7,2)
                       + substring(v_des_dat,3,2)
                       + substring(v_des_dat,1,2)
                       + substring(p_ind_tip_atualiz,1,1)
           v_num_aux_2 = integer(this-procedure:handle).

    do  v_num_cont = 1 to 3:
        assign v_num_aux   = (random(0,v_num_aux_2) mod 26) + 97
               p_cod_refer = p_cod_refer + chr(v_num_aux).
    end.
END PROCEDURE.

PROCEDURE pi_verifica_refer_unica_apb:

    def Input param p_cod_estab
        as character
        format "x(3)"
        no-undo.
    def Input param p_cod_refer
        as character
        format "x(10)"
        no-undo.
    def output param p_log_refer_uni
        as logical
        format "Sim/N∆o"
        no-undo.

    DEF BUFFER b_tt_an_pef FOR tt_an_pef.

    assign p_log_refer_uni = yes.

    find first antecip_pef_pend no-lock
         where antecip_pef_pend.cod_estab = p_cod_estab
           and antecip_pef_pend.cod_refer = p_cod_refer no-error.
    if  avail antecip_pef_pend
    then do:
        assign p_log_refer_uni = no.
    end.
    else do:
        find first lote_impl_tit_ap no-lock
             where lote_impl_tit_ap.cod_estab = p_cod_estab
               and lote_impl_tit_ap.cod_refer = p_cod_refer no-error.
        if  avail lote_impl_tit_ap
        then do:
            assign p_log_refer_uni = no.
        end.
        else do:
            find first lote_pagto no-lock
                 where lote_pagto.cod_estab_refer = p_cod_estab
                   and lote_pagto.cod_refer       = p_cod_refer no-error.
            if  avail lote_pagto
            then do:
                assign p_log_refer_uni = no.
            end.
            else do:
                find first movto_tit_ap no-lock
                     where movto_tit_ap.cod_estab = p_cod_estab
                       and movto_tit_ap.cod_refer = p_cod_refer no-error.
                if  avail movto_tit_ap
                then do:
                    assign p_log_refer_uni = no.
                end.
                ELSE DO:
                     FIND FIRST b_tt_an_pef no-lock
                          WHERE b_tt_an_pef.tta_cod_refer = p_cod_refer NO-ERROR.
                     IF AVAIL b_tt_an_pef 
                     THEN DO:
                          ASSIGN p_log_refer_uni = NO.
                     END.
                END.
            end.
        end.
    end.

END PROCEDURE.

FUNCTION trataChars RETURN CHARACTER (INPUT pTexto AS CHAR):
    DEFINE VARIABLE i-cont AS INTEGER     NO-UNDO.

    ASSIGN pTexto = REPLACE(pTexto, ";":U, ",":U)
           pTexto = REPLACE(pTexto, CHR(10), " ")
           pTexto = REPLACE(pTexto, CHR(11), " ")
           pTexto = REPLACE(pTexto, CHR(12), " ")
           pTexto = REPLACE(pTexto, CHR(13), " ").

    DO i-cont = 1 TO 31:
        ASSIGN pTexto = REPLACE(pTexto, CHR(i-cont), CHR(32)).
    END.

    IF INDEX(pTexto, CHR(32) + CHR(32)) <> 0 THEN DO:
        DO i-cont = 12 TO 2 BY -1:
            ASSIGN pTexto = REPLACE(pTexto, FILL(CHR(32), i-cont), CHR(32)).
        END.
    END.

    ASSIGN pTexto = TRIM(pTexto).

    RETURN pTexto.
END.

PROCEDURE pi-envia-email:
    DEFINE VARIABLE h-utapi019  AS HANDLE      NO-UNDO.
    DEFINE VARIABLE c-destino AS CHARACTER   NO-UNDO.

    RUN pi-acompanhar IN h-acomp (INPUT "Enviando Email Cliente.. ").
    RUN utp/utapi019.p PERSISTENT SET h-utapi019.

    EMPTY TEMP-TABLE tt-envio2.   
    EMPTY TEMP-TABLE tt-mensagem.
    EMPTY TEMP-TABLE tt-erros.

    FOR FIRST usuar_mestre NO-LOCK 
        WHERE usuar_mestre.cod_usuario = c-seg-usuario:
    END.

    IF tt-param.l-adiantamento 
    OR tt-param.l-adiantamento-viagem THEN DO:
        ASSIGN c-destino = IF c-destino = "" THEN int_param_alatur.cod_email_integracao_ad ELSE c-destino + ";" + int_param_alatur.cod_email_integracao_ad.
    END.

    IF tt-param.l-cartao-credito THEN DO:
        ASSIGN c-destino = IF c-destino = "" THEN int_param_alatur.cod_email_integracao_cr ELSE c-destino + ";" + int_param_alatur.cod_email_integracao_cr.
    END.

    IF tt-param.l-prestacao-contas 
    OR tt-param.l-prestacao-contas-ad
    OR tt-param.l-prestacao-contas-ad-viagem THEN DO:
        ASSIGN c-destino = IF c-destino = "" THEN int_param_alatur.cod_email_integracao_pc ELSE c-destino + ";" + int_param_alatur.cod_email_integracao_pc.
    END.

    CREATE tt-envio2.
    ASSIGN tt-envio2.versao-integracao = 1
           tt-envio2.destino           = c-destino
           tt-envio2.remetente         = "ems@intelbras.com.br"
           tt-envio2.copia             = ""
           tt-envio2.assunto           = "Integraá∆o Alatur Financeiro"
           tt-envio2.arq-anexo         = c-arq-excel
           tt-envio2.formato           = "TEXTO".

    IF tt-param.tipo-exec = "2" THEN
        ASSIGN c-tipo-exec = "Integraá∆o".
    ELSE 
        ASSIGN c-tipo-exec = "Relat¢rio".

    IF c-msg-mail = "" THEN
        ASSIGN c-msg-mail = "Integraá∆o ocorrida com sucesso!" + CHR(10) + CHR(10).

    ASSIGN c-msg-mail = c-msg-mail + CHR(10) + CHR(10) +
                                     "Adiantamento: "                + STRING(tt-param.l-adiantamento, "Sim/N∆o") + CHR(10) +
                                     "Adiantamento Viagem: "         + STRING(tt-param.l-adiantamento-viagem, "Sim/N∆o") + CHR(10) +
                                     "Cart∆o de CrÇdito: "           + STRING(tt-param.l-cartao-credito, "Sim/N∆o") + CHR(10) +
                                     "Prestaá∆o Contas: "            + STRING(tt-param.l-prestacao-contas, "Sim/N∆o") + CHR(10) +
                                     "Prestaá∆o Contas AD: "         + STRING(tt-param.l-prestacao-contas-ad, "Sim/N∆o") + CHR(10) +
                                     "Prestaá∆o Contas AD Viagem: "  + STRING(tt-param.l-prestacao-contas-ad-viagem, "Sim/N∆o") + CHR(10) + CHR(10) +
                                     "Tipo de execuá∆o: "            + c-tipo-exec.

    CREATE tt-mensagem.
    ASSIGN tt-mensagem.seq-mensagem = 1
           tt-mensagem.mensagem     = c-msg-mail.
   
    RUN pi-execute2 in h-utapi019 (INPUT  TABLE tt-envio2,
                                   INPUT  TABLE tt-mensagem,
                                   OUTPUT TABLE tt-erros).

    FOR EACH tt-erros:
        CREATE tt-erro.
        ASSIGN tt-erro.cd-erro  = 17006
               tt-erro.mensagem = "Erro no envio do e-mail: " + STRING(tt-erros.cod-erro) + " - " + tt-erros.desc-erro.
    END.

    IF  VALID-HANDLE(h-utapi019) THEN 
        DELETE PROCEDURE h-utapi019.

    ASSIGN h-utapi019 = ?.

    RETURN "OK".
END.

PROCEDURE pi_retornar_vencto:

    DEF INPUT PARAM p_cod_estab      AS CHARACTER FORMAT "x(5)"       NO-UNDO.
    DEF INPUT PARAM p_ind_tip_calend AS CHARACTER FORMAT "X(08)"      NO-UNDO.
    DEF INPUT PARAM p_num_dias       AS INTEGER   FORMAT ">>>>,>>9"   NO-UNDO.
    DEF INPUT PARAM p_dat_base       AS DATE      FORMAT "99/99/9999" NO-UNDO.
    DEF INPUT PARAM p_atrasado       AS LOGICAL                       NO-UNDO.
    DEF OUTPUT PARAM p_dat_return    AS DATE      FORMAT "99/99/9999" NO-UNDO.
    DEF OUTPUT PARAM p_cod_return    AS CHARACTER FORMAT "x(40)"      NO-UNDO.
    
    def var v_log_fer
        as logical
        format "Sim/N∆o"
        initial no
        no-undo.
    def var v_num_seq
        as integer
        format ">>>,>>9":U
        label "Sequància"
        column-label "Seq"
        no-undo.

    assign p_cod_return = "OK" /*l_ok*/ .

    find estabelecimento
        where estabelecimento.cod_estab = p_cod_estab no-lock no-error.

    /* case_block: */
    case p_ind_tip_calend:
        when "Respons†vel Financeiro" /*l_financeiro*/ then
            find calend_glob
                where calend_glob.cod_calend = estabelecimento.cod_calend_financ
                no-lock no-error.
        when "Materiais" /*l_materiais*/ then
            find calend_glob
                where calend_glob.cod_calend = estabelecimento.cod_calend_mater
                no-lock no-error.
        when "R.H." /*l_rh*/ then
            find calend_glob
                where calend_glob.cod_calend = estabelecimento.cod_calend_rh
                no-lock no-error.
        when "Manufatura" /*l_manufatura*/ then
            find calend_glob
                where calend_glob.cod_calend = estabelecimento.cod_calend_manuf
                no-lock no-error.
        when "Distribuiá∆o" /*l_distribuicao*/ then
            find calend_glob
                where calend_glob.cod_calend = estabelecimento.cod_calend_distrib
                no-lock no-error.
    end /* case case_block */.
    if  not avail calend_glob
    then do:
        assign p_cod_return = "3896".
    end /* if */.

    assign p_dat_return = p_dat_base.

    if  p_num_dias = 0
    then do:
        acha_dia_util:
        repeat:
            find dia_calend_glob
                where dia_calend_glob.cod_calend = calend_glob.cod_calend
                and   dia_calend_glob.dat_calend = p_dat_return
                no-lock no-error.
            if  not avail dia_calend_glob
            then do:
                assign p_cod_return = "3897" + "," + string(p_dat_return) + "," + calend_glob.cod_calend.
                return.
            end /* if */.

            if  dia_calend_glob.log_dia_util = yes then do:
            assign v_log_fer = no.
                for each fer_nac no-lock
                    where fer_nac.cod_pais     = "BRA"
                      and fer_nac.dat_fer_nac  = p_dat_return:
                      assign v_log_fer = yes.
                end.
                if not v_log_fer then
                   leave acha_dia_util.
                else assign p_dat_return = IF p_atrasado THEN p_dat_return + 1 ELSE p_dat_return - 1.
            end.

            else do:
                assign p_dat_return = IF p_atrasado THEN p_dat_return + 1 ELSE p_dat_return - 1.
            end /* else */.
        end /* repeat acha_dia_util */.
    end /* if */.
    else do:
        dias_block:
        do v_num_seq = 1 to p_num_dias:
            assign p_dat_return = IF p_atrasado THEN p_dat_return + 1 ELSE p_dat_return - 1.
            acha_dia_util:
            repeat:
                find dia_calend_glob
                    where dia_calend_glob.cod_calend = calend_glob.cod_calend
                    and   dia_calend_glob.dat_calend = p_dat_return
                    no-lock no-error.
                if  not avail dia_calend_glob
                then do:
                    assign p_cod_return = "3897" + "," + string(p_dat_return) + "," + calend_glob.cod_calend.
                    return.
                end /* if */.

                if  dia_calend_glob.log_dia_util = yes then do:
                assign v_log_fer = no.
                    for each fer_nac no-lock
                        where fer_nac.cod_pais     = "BRA"
                          and fer_nac.dat_fer_nac  = p_dat_return:
                          assign v_log_fer = yes.
                    end.
                    if not v_log_fer then
                        leave acha_dia_util.
                    else assign p_dat_return = IF p_atrasado THEN p_dat_return + 1 ELSE p_dat_return - 1.
                end.

                else do:
                    assign p_dat_return = IF p_atrasado THEN p_dat_return + 1 ELSE p_dat_return - 1.
                end /* else */.
            end /* repeat acha_dia_util */.
        end /* do dias_block */.
    end /* else */.

END PROCEDURE. /* pi_retornar_vencto */

PROCEDURE pi-gera-tt-prestacao-contas:
    DEFINE INPUT PARAM p-cod-estab            LIKE tt_integr_apb_lote_impl.tta_cod_estab.
    DEFINE INPUT PARAM p-cod-espec-docto      LIKE tt_integr_apb_item_lote_impl_3.tta_cod_espec_docto.
    DEFINE INPUT PARAM p-cod-ser-docto        LIKE tt_integr_apb_item_lote_impl_3.tta_cod_ser_docto.
    DEFINE INPUT PARAM p-num-dias-vencto      AS INT.
    DEFINE INPUT PARAM p-cod-portador         LIKE int_param_alatur.cod_portador_pc.
    DEFINE INPUT PARAM p-cod-tip-fluxo-financ LIKE tt_integr_apb_aprop_ctbl_pend.tta_cod_tip_fluxo_financ.
    
    DEFINE VARIABLE v_log_refer_uni AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE v_cod_refer     AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE v_dat_vencto    AS DATE        NO-UNDO.
    DEFINE VARIABLE v-cod-return    AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE v-tot-solic     AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE v-tot-solic-aux AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE i-cont          AS INTEGER     NO-UNDO.
    DEFINE VARIABLE v-recid         AS RECID       NO-UNDO.
    DEFINE VARIABLE v-maior-vl      AS DECIMAL     NO-UNDO.

    IF  int_param_alatur.log_integra_pc = YES THEN DO:

        /*Quando n houve adiantamento advance_expense = "", n∆o valida data pois n possui*/
/*         IF  int_solicitacao_alatur.advance_expense <> ""                                                                                                                       */
/*         AND int_param_alatur.dat_inicio_integracao <= int_solicitacao_alatur.advance_include_date THEN DO:                                                                     */
/*                                                                                                                                                                                */
/*             CREATE tt-erro.                                                                                                                                                    */
/*             ASSIGN tt-erro.cd-erro  = 17006                                                                                                                                    */
/*                    tt-erro.mensagem = "Solicitaá∆o n∆o integrada. Solicitaá∆o anterior a data de in°cio da integraá∆o. Solicitaá∆o: " + int_solicitacao_alatur.request_number. */
/*             RETURN "NOK".                                                                                                                                                      */
/*         END.                                                                                                                                                                   */

        IF  int_solicitacao_alatur.advance_expense <> "Viagem Nacional" 
        AND int_solicitacao_alatur.advance_expense <> "" THEN 
            RETURN "NOK".

        ASSIGN v_log_refer_uni = NO
               v-tot-solic     = 0
               v-tot-solic-aux = 0
               v-recid         = ?
               v-maior-vl     = 0.
    
        EMPTY TEMP-TABLE tt-contas.
        EMPTY TEMP-TABLE tt-rateios.
         
        REPEAT WHILE v_log_refer_uni = NO:
           RUN pi_retorna_sugestao_referencia (INPUT "APB",
                                               INPUT TODAY,
                                               OUTPUT v_cod_refer).
    
           RUN pi_verifica_refer_unica_apb (INPUT p-cod-estab,
                                            INPUT v_cod_refer,
                                            OUTPUT v_log_refer_uni).
        END.

        IF int_solicitacao_alatur.refund_histor_rateio = "" THEN DO:
            CREATE tt-erro.
            ASSIGN tt-erro.cd-erro  = 17006
                   tt-erro.mensagem = "Ocorreu um erro na integraá∆o com PC. Solicitaá∆o: " + ItemSolicitacaoAdiantamento.CodigoARB + "~~. Solicitaá∆o n∆o possui rateios. ".
            RETURN "NOK".
        END.
    
        FIND FIRST estabelecimento NO-LOCK
             WHERE estabelecimento.cod_estab = p-cod-estab NO-ERROR.
    
        IF NOT AVAIL estabelecimento THEN DO:
             CREATE tt-erro.
             ASSIGN tt-erro.cd-erro  = 17006
                    tt-erro.mensagem = "Erro na integraá∆o com contas a pagar. Estabelecimento n∆o cadastrado. Estabelecimento: " + STRING(p-cod-estab) + " Solicitaá∆o: " + int_solicitacao_alatur.request_number.
             RETURN "NOK".
        END.
    
        IF int_solicitacao_alatur.request_passenger_CPF = "" THEN DO:
             CREATE tt-erro.
             ASSIGN tt-erro.cd-erro  = 17006
                    tt-erro.mensagem = "Erro na integraá∆o com contas a pagar. CPF da solicitaá∆o em branco. Solicitaá∆o: " + int_solicitacao_alatur.request_number.
             RETURN "NOK".
        END.
    
        FIND FIRST emscad.fornecedor NO-LOCK
             WHERE emscad.fornecedor.cod_empresa  = estabelecimento.cod_empresa
               AND emscad.fornecedor.cod_pais     = "BRA"
               AND emscad.fornecedor.cod_id_feder = int_solicitacao_alatur.request_passenger_CPF NO-ERROR.
    
        IF NOT AVAIL emscad.fornecedor THEN DO:
             CREATE tt-erro.
             ASSIGN tt-erro.cd-erro  = 17006
                    tt-erro.mensagem = "Erro na integraá∆o com contas a pagar. Fornecedor n∆o cadastrado. Empresa: " + STRING(estabelecimento.cod_empresa) + " Id Feder: " + STRING(int_solicitacao_alatur.request_passenger_CPF) + " Solicitaá∆o: " + int_solicitacao_alatur.request_number.
             RETURN "NOK".
        END.

        /*Cris temp-table de contas*/
        IF int_solicitacao_alatur.refund_histor_rateio <> "" THEN DO:
            DO  i-cont = 1 TO NUM-ENTRIES(int_solicitacao_alatur.refund_histor_rateio,"|"):
                IF i-cont MOD 4 = 2 THEN DO:
                    FIND FIRST tt-contas
                         WHERE tt-contas.request_number = int_solicitacao_alatur.request_number
                           AND tt-contas.cod-cta-ctbl   = ENTRY(i-cont,int_solicitacao_alatur.refund_histor_rateio,"|") NO-ERROR.
    
                    IF NOT AVAIL tt-contas THEN DO:
                        CREATE tt-contas.
                        ASSIGN tt-contas.request_number = int_solicitacao_alatur.request_number
                               tt-contas.cod-cta-ctbl   = ENTRY(i-cont,int_solicitacao_alatur.refund_histor_rateio,"|").
                    END.
                END.
    
                IF i-cont MOD 4 = 3 THEN DO:
                    ASSIGN tt-contas.val-desl = DEC(ENTRY(i-cont,int_solicitacao_alatur.refund_histor_rateio,"|")).
                END.
    
                IF i-cont MOD 4 = 0 THEN DO:
                    ASSIGN tt-contas.qtd-desp = DEC(ENTRY(i-cont,int_solicitacao_alatur.refund_histor_rateio,"|"))
                           tt-contas.tot-desp = tt-contas.tot-desp + (tt-contas.qtd-desp * tt-contas.val-desl).
                END.
            END.
        END.
        
        /*cria tt de rateio por CC*/
        IF int_solicitacao_alatur.advance_hitor_rateio <> "" THEN DO:
            DO  i-cont = 1 TO NUM-ENTRIES(int_solicitacao_alatur.advance_hitor_rateio,"|"):
                IF i-cont MOD 3 = 1 THEN DO:
                    FIND FIRST tt-rateios
                         WHERE tt-rateios.request_number = int_solicitacao_alatur.request_number
                           AND tt-rateios.centro-custo   = ENTRY(i-cont,int_solicitacao_alatur.advance_hitor_rateio,"|") NO-ERROR.
    
                    IF NOT AVAIL tt-rateios THEN DO:
                        CREATE tt-rateios.
                        ASSIGN tt-rateios.request_number = int_solicitacao_alatur.request_number
                               tt-rateios.centro-custo   = ENTRY(i-cont,int_solicitacao_alatur.advance_hitor_rateio,"|").
                    END.
                END.
                IF i-cont MOD 3 = 2 THEN DO:
                    ASSIGN tt-rateios.empresa = ENTRY(i-cont,int_solicitacao_alatur.advance_hitor_rateio,"|").
                END.
                IF i-cont MOD 3 = 0 THEN DO:
                    ASSIGN tt-rateios.percentual = tt-rateios.percentual + DEC(ENTRY(i-cont,int_solicitacao_alatur.advance_hitor_rateio,"|")).
                END.
            END.
        END.

        FIND FIRST tt_integr_apb_lote_impl
             WHERE tt_integr_apb_lote_impl.tta_cod_estab = p-cod-estab NO-ERROR.
         
        IF NOT AVAIL tt_integr_apb_lote_impl THEN DO:
            CREATE tt_integr_apb_lote_impl.
            ASSIGN tt_integr_apb_lote_impl.tta_cod_estab         = p-cod-estab
                   tt_integr_apb_lote_impl.tta_cod_refer         = v_cod_refer
                   tt_integr_apb_lote_impl.tta_dat_transacao     = TODAY
                   tt_integr_apb_lote_impl.tta_ind_origin_tit_ap = "APB"
                   tt_integr_apb_lote_impl.tta_cod_empresa       = estabelecimento.cod_empresa  /*do estabelecimento informado na planilha*/.
        
            RELEASE tt_integr_apb_lote_impl.
        
            FIND FIRST tt_integr_apb_lote_impl
                 WHERE tt_integr_apb_lote_impl.tta_cod_estab = p-cod-estab NO-ERROR.
        END.

        ASSIGN i-conta-refer = i-conta-refer + 1.
    
        RUN pi_retornar_vencto (INPUT p-cod-estab,
                                INPUT "Respons†vel Financeiro",
                                INPUT p-num-dias-vencto,
                                INPUT TODAY,
                                INPUT YES,
                                OUTPUT v_dat_vencto,
                                OUTPUT v-cod-return).
         
        CREATE tt_integr_apb_item_lote_impl_3.
        ASSIGN tt_integr_apb_item_lote_impl_3.ttv_rec_integr_apb_lote_impl = RECID(tt_integr_apb_lote_impl)
               tt_integr_apb_item_lote_impl_3.ttv_rec_integr_apb_item_lote = RECID(tt_integr_apb_item_lote_impl_3)
               tt_integr_apb_item_lote_impl_3.tta_num_seq_refer            = i-conta-refer
               tt_integr_apb_item_lote_impl_3.tta_cdn_fornecedor           = emscad.fornecedor.cdn_forne
               tt_integr_apb_item_lote_impl_3.tta_cod_espec_docto          = p-cod-espec-docto
               tt_integr_apb_item_lote_impl_3.tta_cod_ser_docto            = p-cod-ser-docto
               tt_integr_apb_item_lote_impl_3.tta_cod_tit_ap               = int_solicitacao_alatur.request_number
               tt_integr_apb_item_lote_impl_3.tta_cod_parcela              = "1"
               tt_integr_apb_item_lote_impl_3.tta_dat_emis_docto           = TODAY
               tt_integr_apb_item_lote_impl_3.tta_dat_vencto_tit_ap        = v_dat_vencto
               tt_integr_apb_item_lote_impl_3.tta_dat_prev_pagto           = v_dat_vencto
               tt_integr_apb_item_lote_impl_3.tta_cod_forma_pagto          = "20":U
               tt_integr_apb_item_lote_impl_3.tta_cod_indic_econ           = "Real":U
               tt_integr_apb_item_lote_impl_3.tta_cod_portador             = p-cod-portador
               tt_integr_apb_item_lote_impl_3.tta_val_cotac_indic_econ     = 1
               tt_integr_apb_item_lote_impl_3.tta_des_text_histor          = "Prestaá∆o de contas: " + int_solicitacao_alatur.request_number.
         
        FOR EACH tt-contas
           WHERE tt-contas.request_number  = int_solicitacao_alatur.request_number,
            EACH tt-rateios
           WHERE tt-rateios.request_number = int_solicitacao_alatur.request_number:
    
            CREATE tt_integr_apb_aprop_ctbl_pend.
            ASSIGN tt_integr_apb_aprop_ctbl_pend.ttv_rec_integr_apb_item_lote  = RECID(tt_integr_apb_item_lote_impl_3)
                   tt_integr_apb_aprop_ctbl_pend.tta_cod_unid_negoc            = SUBSTRING(tt-rateios.centro-custo,1,3)
                   tt_integr_apb_aprop_ctbl_pend.tta_cod_tip_fluxo_financ      = p-cod-tip-fluxo-financ
                   tt_integr_apb_aprop_ctbl_pend.tta_cod_plano_cta_ctbl        = "PADRAO"
                   tt_integr_apb_aprop_ctbl_pend.tta_cod_cta_ctbl              = tt-contas.cod-cta-ctbl
                   tt_integr_apb_aprop_ctbl_pend.tta_cod_plano_ccusto          = "PADRAO"
                   tt_integr_apb_aprop_ctbl_pend.tta_cod_ccusto                = SUBSTRING(tt-rateios.centro-custo,4,5)
                   tt_integr_apb_aprop_ctbl_pend.tta_val_aprop_ctbl            = TRUNCATE((tt-contas.tot-desp * tt-rateios.percentual / 100),2).

            /*Guarda registro com maior valor para jogar o arredondamento*/
            IF v-maior-vl < tt_integr_apb_aprop_ctbl_pend.tta_val_aprop_ctbl THEN DO:
                ASSIGN v-maior-vl = tt_integr_apb_aprop_ctbl_pend.tta_val_aprop_ctbl
                       v-recid    = RECID(tt_integr_apb_aprop_ctbl_pend).
            END.
    
            ASSIGN v-tot-solic     = v-tot-solic + (tt-contas.tot-desp * tt-rateios.percentual / 100)
                   v-tot-solic-aux = v-tot-solic-aux + TRUNCATE((tt-contas.tot-desp * tt-rateios.percentual / 100),2).

            RELEASE tt_integr_apb_aprop_ctbl_pend.
            FIND FIRST tt_integr_apb_aprop_ctbl_pend NO-ERROR.  
        END.

        /*Ajusta arredondamento*/
        IF v-tot-solic-aux <> v-tot-solic THEN DO:
            FIND FIRST tt_integr_apb_aprop_ctbl_pend 
                 WHERE RECID(tt_integr_apb_aprop_ctbl_pend) = v-recid NO-ERROR.

            IF AVAIL tt_integr_apb_aprop_ctbl_pend  THEN DO:
                ASSIGN tt_integr_apb_aprop_ctbl_pend.tta_val_aprop_ctbl = tt_integr_apb_aprop_ctbl_pend.tta_val_aprop_ctbl + (v-tot-solic - v-tot-solic-aux).
            END.
        END.

        ASSIGN tt_integr_apb_item_lote_impl_3.tta_val_tit_ap = v-tot-solic.

        /* *** Caso tenha gerado adiantamento, dados da GV ***/
        FIND FIRST antecip_pef_pend NO-LOCK
             WHERE antecip_pef_pend.cod_estab = p-cod-estab
               AND antecip_pef_pend.cod_refer = int_solicitacao_alatur.cod_refer_antecip_pef_pend NO-ERROR.
        
        IF AVAIL antecip_pef_pend THEN DO:
            CREATE tt_integr_apb_abat_antecip_vouc.
            ASSIGN tt_integr_apb_abat_antecip_vouc.ttv_rec_integr_apb_item_lote = RECID(tt_integr_apb_item_lote_impl_3)
                   tt_integr_apb_abat_antecip_vouc.tta_cod_estab                = antecip_pef_pend.cod_estab
                   tt_integr_apb_abat_antecip_vouc.tta_cod_espec_docto          = antecip_pef_pend.cod_espec_docto
                   tt_integr_apb_abat_antecip_vouc.tta_cod_ser_docto            = antecip_pef_pend.cod_ser_docto  
                   tt_integr_apb_abat_antecip_vouc.tta_cdn_fornecedor           = antecip_pef_pend.cdn_fornecedor 
                   tt_integr_apb_abat_antecip_vouc.tta_cod_tit_ap               = antecip_pef_pend.cod_tit_ap     
                   tt_integr_apb_abat_antecip_vouc.tta_cod_parcela              = antecip_pef_pend.cod_parcela    
                   tt_integr_apb_abat_antecip_vouc.tta_val_abat_tit_ap          = IF v-tot-solic <= antecip_pef_pend.val_tit_ap THEN v-tot-solic ELSE antecip_pef_pend.val_tit_ap.
            
            RELEASE tt_integr_apb_abat_antecip_vouc.
            FIND FIRST tt_integr_apb_abat_antecip_vouc NO-ERROR.
        END.
    END.
END PROCEDURE.
        
PROCEDURE pi-integra-prestacao-contas:
    DEFINE VARIABLE v-val-antecip AS DECIMAL     NO-UNDO.
    cria_docto:
    DO TRANSACTION:
        /* ** Chamada da API ***/ 
        IF NOT VALID-HANDLE(v_hdl_aux) THEN RUN prgfin/apb/apb900zg.py PERSISTENT SET v_hdl_aux.
    
        EMPTY TEMP-TABLE tt_log_erros_atualiz NO-ERROR.
        RUN pi_main_block_api_tit_ap_cria_4 IN v_hdl_aux (INPUT 5,
                                                          INPUT "EMS":U,
                                                          INPUT-OUTPUT TABLE tt_integr_apb_item_lote_impl_3).
        
        IF  VALID-HANDLE(v_hdl_aux) THEN 
            DELETE PROCEDURE v_hdl_aux.

        ASSIGN v_hdl_aux = ?.
        
        FOR EACH tt_log_erros_atualiz:
            FIND FIRST tt_integr_apb_item_lote_impl_3
                 WHERE tt_integr_apb_item_lote_impl_3.tta_num_seq_refer = tt_log_erros_atualiz.tta_num_seq_refer .

            CREATE tt-erro.
            ASSIGN tt-erro.cd-erro  = 17006
                   tt-erro.mensagem = "Erro API PC: " + tt_log_erros_atualiz.ttv_des_msg_erro + " Solicitaá∆o: " + tt_integr_apb_item_lote_impl_3.tta_cod_tit_ap.
        END.
        

        FOR EACH tt_integr_apb_item_lote_impl_3:

            FIND FIRST tt_integr_apb_lote_impl
                 WHERE RECID(tt_integr_apb_lote_impl) = tt_integr_apb_item_lote_impl_3.ttv_rec_integr_apb_lote_impl NO-ERROR.

            FIND FIRST tit_ap NO-LOCK
                 WHERE tit_ap.cod_estab   = tt_integr_apb_lote_impl.tta_cod_estab
                   AND tit_ap.cdn_fornec  = tt_integr_apb_item_lote_impl_3.tta_cdn_fornecedor
                   AND tit_ap.cod_espec   = tt_integr_apb_item_lote_impl_3.tta_cod_espec_docto
                   AND tit_ap.cod_ser     = tt_integr_apb_item_lote_impl_3.tta_cod_ser_docto  
                   AND tit_ap.cod_tit_ap  = tt_integr_apb_item_lote_impl_3.tta_cod_tit_ap 
                   AND tit_ap.cod_parcela = tt_integr_apb_item_lote_impl_3.tta_cod_parcela NO-ERROR.

            IF AVAIL tit_ap THEN DO:

                FIND FIRST int_solicitacao_alatur NO-LOCK
                     WHERE int_solicitacao_alatur.request_number = tt_integr_apb_item_lote_impl_3.tta_cod_tit_ap NO-ERROR.

                FIND FIRST antecip_pef_pend NO-LOCK
                     WHERE antecip_pef_pend.cod_estab = tit_ap.cod_estab
                       AND antecip_pef_pend.cod_refer = int_solicitacao_alatur.cod_refer_antecip_pef_pend NO-ERROR.

                ASSIGN v-val-antecip = 0.
                IF AVAIL antecip_pef_pend THEN
                    ASSIGN v-val-antecip = antecip_pef_pend.val_tit_ap.
                ELSE 
                    ASSIGN v-val-antecip = 0.

                FIND CURRENT int_solicitacao_alatur EXCLUSIVE-LOCK.

                ASSIGN int_solicitacao_alatur.dat_create_pc          = TODAY                      
                       int_solicitacao_alatur.hra_create_pc          = STRING(TIME,"HH:MM:SS")   
                       int_solicitacao_alatur.cod_usuar_create_pc    = v_cod_usuar_corren        
                       int_solicitacao_alatur.num_id_tit_ap          = tit_ap.num_id_tit_ap
                       int_solicitacao_alatur.val_total_pc           = tit_ap.val_origin_tit_ap
                       int_solicitacao_alatur.val_total_reembolso_pc = IF int_solicitacao_alatur.val_total_ad <= int_solicitacao_alatur.val_total_pc THEN int_solicitacao_alatur.val_total_pc - int_solicitacao_alatur.val_total_ad ELSE 0
                       int_solicitacao_alatur.val_total_devolucao_pc = IF int_solicitacao_alatur.val_total_ad >= int_solicitacao_alatur.val_total_pc THEN int_solicitacao_alatur.val_total_ad - int_solicitacao_alatur.val_total_pc ELSE 0.

                FIND CURRENT int_solicitacao_alatur NO-LOCK.
            END.
            ELSE DO:
                CREATE tt-erro.
                ASSIGN tt-erro.cd-erro  = 17006
                       tt-erro.mensagem = "Erro na criaá∆o PC. Solicitaá∆o: " + tt_integr_apb_item_lote_impl_3.tta_cod_tit_ap .
            END.
        END.
    END.

    EMPTY TEMP-TABLE tt_integr_apb_aprop_ctbl_pend.
    EMPTY TEMP-TABLE tt_integr_apb_item_lote_impl3v.
    EMPTY TEMP-TABLE tt_integr_apb_item_lote_impl_3.
    EMPTY TEMP-TABLE tt_log_erros_comis. 
    EMPTY TEMP-TABLE tt_integr_apb_abat_antecip_vouc. 
    EMPTY TEMP-TABLE tt_integr_apb_abat_prev_provis. 
    EMPTY TEMP-TABLE tt_integr_apb_aprop_relacto. 
    EMPTY TEMP-TABLE tt_integr_apb_impto_impl_pend. 
    EMPTY TEMP-TABLE tt_integr_apb_item_lote_impl. 
    EMPTY TEMP-TABLE tt_integr_apb_lote_impl. 
    EMPTY TEMP-TABLE tt_integr_apb_relacto_pend. 
    EMPTY TEMP-TABLE tt_log_erros_atualiz.

END.

PROCEDURE pi-msg0273:
    DEFINE VARIABLE c-estab  AS CHARACTER   NO-UNDO.

    EMPTY TEMP-TABLE tt-param-273.

    FIND LAST int_param_alatur NO-LOCK NO-ERROR.
    
    IF int_solicitacao_alatur.advance_expense = "Cart∆o de CrÇdito" THEN
        ASSIGN c-estab = int_param_alatur.cod_estab_cr.
    ELSE IF int_solicitacao_alatur.advance_expense = "Viagem Nacional" THEN
        ASSIGN c-estab = int_param_alatur.cod_estab_ad.
    ELSE IF int_solicitacao_alatur.advance_expense = "Prestaá∆o de Contas" THEN
        ASSIGN c-estab = int_param_alatur.cod_estab_ad.

    FIND FIRST antecip_pef_pend NO-LOCK
         WHERE antecip_pef_pend.cod_estab = int_param_alatur.cod_estab_ad
           AND antecip_pef_pend.cod_refer = int_solicitacao_alatur.cod_refer_antecip_pef_pend NO-ERROR.

    CREATE tt-param-273.
    ASSIGN tt-param-273.CodigoARB           = int_solicitacao_alatur.request_number_arb
           tt-param-273.DataPagamento       = int_solicitacao_alatur.dat_create_p
           tt-param-273.TipoPagamento       = "R"
           tt-param-273.Moeda               = "BRL"
           tt-param-273.NumeroContaCorrente = int_solicitacao_alatur.request_passenger_checking_acc 
           tt-param-273.ProvisaoPagamento   = IF AVAIL antecip_pef_pend THEN antecip_pef_pend.val_tit_ap ELSE 0
           tt-param-273.Observacao          = int_solicitacao_alatur.advance_note.                          

    RAW-TRANSFER tt-param-273 TO raw-param.

    RUN esp/esb/out/msg0273.p (INPUT raw-param,
                               OUTPUT TABLE Resultado).
        
END PROCEDURE.

PROCEDURE pi-msg0274:

    CREATE tt-param-274.
    ASSIGN tt-param-274.CodigoARB        = int_solicitacao_alatur.request_number_arb
           tt-param-274.NomeSolicitacao  = ""
           tt-param-274.ValorSolicitacao = 0.
   
    RAW-TRANSFER tt-param-274 TO raw-param.

    RUN esp/esb/out/msg0274.p (INPUT raw-param,
                               OUTPUT TABLE Resultado).
END PROCEDURE.
