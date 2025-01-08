{esp/acr/esacr083.i}

def new global shared var i-num-ped-exec-rpw as INT                                                                          no-undo.
DEF NEW GLOBAL SHARED VAR v_cod_usuar_corren AS CHAR FORMAT "x(12)" LABEL "Usu†rio Corrente" COLUMN-LABEL "Usu†rio Corrente" NO-UNDO.

define temp-TABLE tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)"
    field usuario          as char format "x(12)"
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field desc-classifica  as char format "x(40)"
    field modelo-rtf       as char format "x(35)"
    FIELD arquivo-import   AS CHAR.

DEFINE TEMP-TABLE tt-nao-econtrados
   FIELD cod_estab        LIKE tit_acr.cod_estab      
   FIELD cod_espec_docto  LIKE tit_acr.cod_espec_docto
   FIELD cod_ser_docto    LIKE tit_acr.cod_ser_docto  
   FIELD cod_tit_acr      LIKE tit_acr.cod_tit_acr    
   FIELD cod_parcela      LIKE tit_acr.cod_parcela.

def temp-TABLE tt-raw-digita NO-UNDO
    field raw-digita   as raw.

DEF VAR v_cod_finalid_econ      AS CHAR FORMAT "x(10)":U LABEL "Finalidade Econìmica" COLUMN-LABEL "Finalidade Econìmica" NO-UNDO.
DEF VAR v_dat_return            AS DATE FORMAT "99/99/9999":U                                                             NO-UNDO.
DEF VAR v_cod_return            AS CHAR FORMAT "x(40)":U                                                                  NO-UNDO.
DEF VAR v_dat_fluxo             AS DATE                                                                                   NO-UNDO.
DEF VAR v_cod_pais_fornec_clien AS CHAR FORMAT "x(8)":U                                                                   NO-UNDO.

DEFINE VARIABLE c-linha         AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-arquivo-saida AS CHARACTER   NO-UNDO.

DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

FIND FIRST tt-param NO-LOCK NO-ERROR.

IF tt-param.arquivo-import <> "" THEN DO:
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
    RUN pi-inicializar in h-acomp (INPUT "Executando...").

    RUN prgfin/acr/acr711zv.py persistent set v_hdl_program .
    
    EMPTY TEMP-TABLE tt_file_import NO-ERROR.
    INPUT FROM VALUE(tt-param.arquivo-import) NO-CONVERT.
    
    REPEAT:
        ASSIGN v_num_line = v_num_line + 1.
        IMPORT UNFORMATTED c-linha.
    
        RUN pi-acompanhar IN h-acomp (INPUT "Importando: " + STRING(v_num_line)).
    
        IF  TRIM(ENTRY(1, c-linha, ";")) BEGINS "Est" THEN
            NEXT.

        CREATE tt_file_import.
        ASSIGN tt_file_import.tta_num_line             = v_num_line
               tt_file_import.tta_cod_estab            = TRIM(ENTRY(1, c-linha, ";"))
               tt_file_import.tta_cod_espec_docto      = TRIM(ENTRY(2, c-linha, ";"))
               tt_file_import.tta_cod_ser_docto        = TRIM(ENTRY(3, c-linha, ";"))
               tt_file_import.tta_cod_tit_acr          = TRIM(ENTRY(4, c-linha, ";"))
               tt_file_import.tta_cod_parcela          = TRIM(ENTRY(5, c-linha, ";"))
               tt_file_import.tta_dat_vencto_tit_acr   = date(ENTRY(6, c-linha, ";"))
               tt_file_import.cod_portador             = TRIM(ENTRY(7, c-linha, ";"))
               tt_file_import.cod_cart_bcia            = TRIM(ENTRY(8, c-linha, ";"))
               tt_file_import.cod_cond_cobr            = TRIM(ENTRY(9, c-linha, ";")).

        ASSIGN i_tamanho_doc = 0
               i_tamanho_par = 0.
    
        IF  LENGTH(tt_file_import.tta_cod_tit_acr) < 7 THEN DO:
            ASSIGN i_tamanho_doc = LENGTH(tt_file_import.tta_cod_tit_acr) + 1.
    
            DO  i_cont = i_tamanho_doc TO 7:
                ASSIGN tt_file_import.tta_cod_tit_acr = "0" + tt_file_import.tta_cod_tit_acr.
            END.
        END.
    END.
    
    ASSIGN v_num_line = 0.
    
    FOR EACH tt_file_import NO-LOCK:
    
        ASSIGN v_num_line = v_num_line + 1.
    
        RUN pi-acompanhar IN h-acomp (INPUT "Atualizando: " + STRING(v_num_line)).

        FIND FIRST tit_acr NO-LOCK
             WHERE tit_acr.cod_estab       = tt_file_import.tta_cod_estab      
               AND tit_acr.cod_espec_docto = tt_file_import.tta_cod_espec_docto
               AND tit_acr.cod_ser_docto   = tt_file_import.tta_cod_ser_docto  
               AND tit_acr.cod_tit_acr     = tt_file_import.tta_cod_tit_acr    
               AND tit_acr.cod_parcela     = tt_file_import.tta_cod_parcela NO-ERROR.
    
        IF  NOT AVAIL tit_acr THEN DO:
            CREATE tt-nao-econtrados.
            ASSIGN tt-nao-econtrados.cod_estab        = tt_file_import.tta_cod_estab       
                   tt-nao-econtrados.cod_espec_docto  = tt_file_import.tta_cod_espec_docto 
                   tt-nao-econtrados.cod_ser_docto    = tt_file_import.tta_cod_ser_docto   
                   tt-nao-econtrados.cod_tit_acr      = tt_file_import.tta_cod_tit_acr     
                   tt-nao-econtrados.cod_parcela      = tt_file_import.tta_cod_parcela.    

            NEXT.
        END.

        RUN pi-gera-referencia IN THIS-PROCEDURE (INPUT  tit_acr.cod_estab,
                                                  INPUT  RECID(tit_acr),
                                                  OUTPUT v_cod_refer).

        EMPTY TEMP-TABLE tt_alter_tit_acr_base_5.

        CREATE tt_alter_tit_acr_base_5.
        ASSIGN tt_alter_tit_acr_base_5.tta_cod_estab                   = tit_acr.cod_estab                     
               tt_alter_tit_acr_base_5.tta_num_id_tit_acr              = tit_acr.num_id_tit_acr
               tt_alter_tit_acr_base_5.tta_dat_transacao               = TODAY
               tt_alter_tit_acr_base_5.tta_cod_refer                   = v_cod_refer
               tt_alter_tit_acr_base_5.ttv_cod_motiv_movto_tit_acr_imp = ?
               tt_alter_tit_acr_base_5.tta_val_sdo_tit_acr             = ? 
               tt_alter_tit_acr_base_5.ttv_cod_motiv_movto_tit_acr_alt = ?
               tt_alter_tit_acr_base_5.ttv_ind_motiv_acerto_val        = ?
               tt_alter_tit_acr_base_5.tta_cod_portador                = IF tt_file_import.cod_portador  <> "" THEN tt_file_import.cod_portador  ELSE tit_acr.cod_portador
               tt_alter_tit_acr_base_5.tta_cod_cart_bcia               = IF tt_file_import.cod_cart_bcia <> "" THEN tt_file_import.cod_cart_bcia ELSE tit_acr.cod_cart_bcia /*?*/
               tt_alter_tit_acr_base_5.tta_val_despes_bcia             = ?
               tt_alter_tit_acr_base_5.tta_cod_agenc_cobr_bcia         = ?
               tt_alter_tit_acr_base_5.tta_cod_tit_acr_bco             = ?
               tt_alter_tit_acr_base_5.tta_dat_emis_docto              = ?
               tt_alter_tit_acr_base_5.tta_dat_vencto_tit_acr          = IF tt_file_import.tta_dat_vencto_tit_acr <> ? THEN tt_file_import.tta_dat_vencto_tit_acr ELSE tit_acr.dat_prev_liquidac 
               tt_alter_tit_acr_base_5.tta_dat_prev_liquidac           = tit_acr.dat_prev_liquidac
               tt_alter_tit_acr_base_5.tta_dat_fluxo_tit_acr           = ?
               tt_alter_tit_acr_base_5.tta_ind_sit_tit_acr             = ?
               tt_alter_tit_acr_base_5.tta_cod_cond_cobr               = IF (tt_file_import.cod_cond_cobr <> ? AND tt_file_import.cod_cond_cobr <> "") THEN tt_file_import.cod_cond_cobr ELSE ?
               tt_alter_tit_acr_base_5.tta_log_tip_cr_perda_dedut_tit  = ?
               tt_alter_tit_acr_base_5.tta_dat_abat_tit_acr            = ?
               tt_alter_tit_acr_base_5.tta_val_perc_abat_acr           = ?
               tt_alter_tit_acr_base_5.tta_val_abat_tit_acr            = ?
               tt_alter_tit_acr_base_5.tta_dat_desconto                = ?
               tt_alter_tit_acr_base_5.tta_val_perc_desc               = ?
               tt_alter_tit_acr_base_5.tta_val_desc_tit_acr            = ?
               tt_alter_tit_acr_base_5.tta_qtd_dias_carenc_juros_acr   = ?
               tt_alter_tit_acr_base_5.tta_val_perc_juros_dia_atraso   = ?
               tt_alter_tit_acr_base_5.tta_qtd_dias_carenc_multa_acr   = ?
               tt_alter_tit_acr_base_5.tta_val_perc_multa_atraso       = ?
               tt_alter_tit_acr_base_5.ttv_cod_portador_mov            = ?
               tt_alter_tit_acr_base_5.tta_ind_tip_cobr_acr            = ?
               tt_alter_tit_acr_base_5.tta_ind_ender_cobr              = ?
               tt_alter_tit_acr_base_5.tta_nom_abrev_contat            = ?
               tt_alter_tit_acr_base_5.tta_val_liq_tit_acr             = ?
               tt_alter_tit_acr_base_5.tta_cod_instruc_bcia_1_movto    = ?
               tt_alter_tit_acr_base_5.tta_cod_instruc_bcia_2_movto    = ?
               tt_alter_tit_acr_base_5.tta_log_tit_acr_destndo         = ?
               tt_alter_tit_acr_base_5.tta_cod_histor_padr             = ?
               tt_alter_tit_acr_base_5.ttv_des_text_histor             = ?
               tt_alter_tit_acr_base_5.tta_des_obs_cobr                = ?
               tt_alter_tit_acr_base_5.tta_num_seq_tit_acr             = ?            
               tt_alter_tit_acr_base_5.ttv_cod_estab_planilha          = ?
               tt_alter_tit_acr_base_5.tta_cod_tit_acr_bco             = ?
               tt_alter_tit_acr_base_5.ttv_des_text_histor             = "N∆o Valida"
               tt_alter_tit_acr_base_5.tta_cdn_repres                  = ?.

        IF  tt_file_import.tta_dat_vencto_tit_acr <> ?
        AND tt_file_import.tta_dat_vencto_tit_acr <> tit_acr.dat_vencto_tit_acr THEN DO:
    
            FIND FIRST emscad.cliente
                WHERE emscad.cliente.cod_empresa = tit_acr.cod_empresa 
                AND   emscad.cliente.cdn_cliente = tit_acr.cdn_cliente NO-LOCK NO-ERROR.
            
            IF  AVAIL emscad.cliente THEN
                ASSIGN v_cod_pais_fornec_clien = emscad.cliente.cod_pais.     

            RUN pi_retornar_finalid_indic_econ (INPUT tit_acr.cod_indic_econ,
                                                INPUT tit_acr.dat_transacao,
                                                OUTPUT v_cod_finalid_econ).

            RUN pi_retornar_dia_util (INPUT tit_acr.cod_estab,
                                      INPUT "Respons†vel Financeiro",
                                      INPUT 0,
                                      INPUT tt_file_import.tta_dat_vencto_tit_acr,
                                      OUTPUT v_dat_return,
                                      OUTPUT v_cod_return).
    
            IF  ENTRY(1, v_cod_return) <> "OK" THEN 
                ASSIGN tt_alter_tit_acr_base_5.tta_dat_prev_liquidac = tt_file_import.tta_dat_vencto_tit_acr.
            ELSE
                ASSIGN tt_alter_tit_acr_base_5.tta_dat_prev_liquidac = v_dat_return.
    
            IF  tit_acr.dat_prev_liquidac <> tt_alter_tit_acr_base_5.tta_dat_prev_liquidac THEN DO:
                ASSIGN v_dat_fluxo = tt_alter_tit_acr_base_5.tta_dat_prev_liquidac.

                FIND FIRST portad_bco NO-LOCK
                    WHERE portad_bco.cod_modul_dtsul  = "ACR"
                    AND   portad_bco.cod_estab        = tit_acr.cod_estab
                    AND   portad_bco.cod_portador     = tt_alter_tit_acr_base_5.tta_cod_portador 
                    AND   portad_bco.cod_cart_bcia    = tt_alter_tit_acr_base_5.tta_cod_cart_bcia
                    AND   portad_bco.cod_finalid_econ = v_cod_finalid_econ NO-ERROR.
              
                IF  AVAIL portad_bco THEN DO:
                    IF  portad_bco.qtd_dias_float_cobr > 0 THEN DO:
                        RUN prgfin/acr/acr792za.py (INPUT tit_acr.cod_estab,
                                                    INPUT-OUTPUT v_dat_fluxo,
                                                    INPUT portad_bco.qtd_dias_float_cobr).
                    END.

                    ASSIGN tt_alter_tit_acr_base_5.tta_dat_fluxo_tit_acr = v_dat_fluxo.
                END.
            END.
        END.
    
        DO TRANS:
            RUN pi_main_code_integr_acr_alter_tit_acr_novo_14 IN v_hdl_program (INPUT  14,
                                                                                INPUT TABLE tt_alter_tit_acr_base_5,
                                                                                INPUT TABLE tt_alter_tit_acr_rateio,
                                                                                INPUT TABLE tt_alter_tit_acr_ped_vda,                                                                     
                                                                                INPUT TABLE tt_alter_tit_acr_comis_1,                                                      
                                                                                INPUT TABLE tt_alter_tit_acr_cheq,                                                      
                                                                                INPUT TABLE tt_alter_tit_acr_iva,                                                      
                                                                                INPUT TABLE tt_alter_tit_acr_impto_retid_2,                                                      
                                                                                INPUT TABLE tt_alter_tit_acr_cobr_espec_2,                                                      
                                                                                INPUT TABLE tt_alter_tit_acr_rat_desp_rec,                                                      
                                                                                OUTPUT TABLE tt_log_erros_alter_tit_acr,                                                      
                                                                                INPUT YES,
                                                                                INPUT TABLE  tt_alter_tit_acr_cobr_esp_2_c,
                                                                                INPUT TABLE  tt_params_generic_api).
        END.

        /*Titulos alterados com sucesso*/
        FIND FIRST tt_log_erros_alter_tit_acr NO-LOCK
             WHERE tt_log_erros_alter_tit_acr.tta_cod_estab      = tt_alter_tit_acr_base_5.tta_cod_estab
               AND tt_log_erros_alter_tit_acr.tta_num_id_tit_acr = tt_alter_tit_acr_base_5.tta_num_id_tit_acr NO-ERROR.

        /*Se n∆o deu erro cria tt_sucesso*/
        IF NOT AVAIL tt_log_erros_alter_tit_acr THEN DO:
            CREATE tt_sucesso.
            ASSIGN tt_sucesso.tta_cod_estab      = tt_alter_tit_acr_base_5.tta_cod_estab
                   tt_sucesso.tta_num_id_tit_acr = tt_alter_tit_acr_base_5.tta_num_id_tit_acr.
        END.
    END.
    
    FIND FIRST usuar_mestre NO-LOCK 
             WHERE  usuar_mestre.cod_usuario = v_cod_usuar_corren USE-INDEX srmstr_id NO-ERROR.
        
    IF  NOT OPSYS = "unix" THEN
        assign c-arquivo-saida = usuar_mestre.nom_dir_spool + "~\" + usuar_mestre.nom_subdir_spool + "~\" + STRING(TIME) + "_esacr083_" + string(day(today)) + string(month(today)) + string(YEAR(today)) + ".csv".
    ELSE
        assign c-arquivo-saida = "/mnt/spool/" + usuar_mestre.nom_subdir_spool + "/" + STRING(TIME) + "_esacr083_" + string(day(today)) + string(month(today)) + string(YEAR(today)) + ".csv".

    OUTPUT TO VALUE (c-arquivo-saida) NO-CONVERT.

    PUT UNFORMATTED "Estab;Esp;Ser;Docto;Parc;N£mero Mensagem;Tipo Mensagem;Inconsistància;Mensagem Ajuda" SKIP.

    FOR EACH tt-nao-econtrados:
        PUT UNFORMATTED  tt-nao-econtrados.cod_estab       + ";" +
                         tt-nao-econtrados.cod_espec_docto + ";" +
                         tt-nao-econtrados.cod_ser_docto   + ";" +
                         tt-nao-econtrados.cod_tit_acr     + ";" +
                         tt-nao-econtrados.cod_parcela     + ";;;;T°tulo n∆o econtrado!" SKIP.
    END.

    IF CAN-FIND (FIRST tt_sucesso) THEN DO:

        FOR EACH tt_sucesso:
            FIND FIRST tit_acr NO-LOCK
                 WHERE tit_acr.cod_estab      = tt_sucesso.tta_cod_estab
                   AND tit_acr.num_id_tit_acr = tt_sucesso.tta_num_id_tit_acr NO-ERROR.

            IF AVAIL tit_acr THEN DO:
                PUT UNFORMATTED  STRING(tit_acr.cod_estab       ) + ";" +
                                 STRING(tit_acr.cod_espec_docto ) + ";" +
                                 STRING(tit_acr.cod_ser_docto   ) + ";" +
                                 STRING(tit_acr.cod_tit_acr     ) + ";" +
                                 STRING(tit_acr.cod_parcela     ) + ";" +
                                 ";" +
                                 ";" +
                                 ";" +
                                 "Sucesso" + ";" SKIP.

            END.
        END.
    END.
    
    IF CAN-FIND(FIRST tt_log_erros_alter_tit_acr) THEN DO:
        FOR EACH tt_log_erros_alter_tit_acr:
    
            FIND FIRST tit_acr NO-LOCK
                 WHERE tit_acr.cod_estab      = tt_log_erros_alter_tit_acr.tta_cod_estab
                   AND tit_acr.num_id_tit_acr = tt_log_erros_alter_tit_acr.tta_num_id_tit_acr NO-ERROR.
    
            IF  AVAIL tit_acr THEN DO:
                PUT UNFORMATTED  STRING(tit_acr.cod_estab                             ) + ";" +
                                 STRING(tit_acr.cod_espec_docto                       ) + ";" +
                                 STRING(tit_acr.cod_ser_docto                         ) + ";" +
                                 STRING(tit_acr.cod_tit_acr                           ) + ";" +
                                 STRING(tit_acr.cod_parcela                           ) + ";" +
                                 STRING(tt_log_erros_alter_tit_acr.ttv_num_mensagem   ) + ";" +
                                 STRING(tt_log_erros_alter_tit_acr.ttv_cod_tip_msg_dwb) + ";" +
                                 STRING(tt_log_erros_alter_tit_acr.ttv_des_msg_erro   ) + ";" +
                                 STRING(tt_log_erros_alter_tit_acr.ttv_des_msg_ajuda  ) + ";" SKIP.
            END.
        END.
    END.

    OUTPUT CLOSE.

    IF  NOT OPSYS = "unix"
    AND i-num-ped-exec-rpw = 0 THEN DO:
        DOS SILENT START excel VALUE(c-arquivo-saida).
    END.
    
    DELETE PROCEDURE v_hdl_program.

    INPUT CLOSE.

    RUN pi-finalizar in h-acomp.
END.

RETURN "OK":U.

PROCEDURE pi-gera-referencia:
    DEFINE INPUT  PARAMETER p-cod-estab  AS CHARACTER FORMAT "x(3)"    NO-UNDO.
    DEFINE INPUT  PARAMETER p-rec-tabela AS RECID                      NO-UNDO.
    DEFINE OUTPUT PARAMETER p-referencia AS CHARACTER                  NO-UNDO.

    DEFINE VARIABLE l-log-refer-uni AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE i-num-aux       AS INT64       NO-UNDO.
    DEFINE VARIABLE i-cont          AS INTEGER     NO-UNDO.
    DEFINE VARIABLE c_des_dat       AS CHARACTER   NO-UNDO.

    /* Gera o cΩdigo da referºncia */
    ASSIGN c_des_dat    = STRING(TODAY, "99999999":U)
           p-referencia = STRING(TIME)
           i-num-aux    = TIME + INT64(p-rec-tabela) .

    DO i_cont = 1 TO 4:
        ASSIGN p-referencia = p-referencia + CHR((RANDOM(0, i-num-aux) MODULO 26) + 97).
    END.

    /* Verifica se a referºncia ≤ única */
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
    DEF INPUT  PARAM p_cod_TABLE     AS CHARACTER FORMAT "x(8)"    NO-UNDO.
    DEF INPUT  PARAM p_rec_tabela    AS RECID                      NO-UNDO.
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

    IF  p_log_refer_uni = YES THEN DO:
        FIND FIRST b_renegoc_acr NO-LOCK
            WHERE b_renegoc_acr.cod_estab = p_cod_estab
            AND   b_renegoc_acr.cod_refer = p_cod_refer NO-ERROR.
        IF  AVAIL b_renegoc_acr then
            ASSIGN p_log_refer_uni = no.
        ELSE DO:
            FIND FIRST b_movto_tit_acr NO-LOCK
                 WHERE b_movto_tit_acr.cod_estab = p_cod_estab
                   AND b_movto_tit_acr.cod_refer = p_cod_refer
                 USE-INDEX mvtttcr_refer
                 NO-ERROR.
            IF  AVAIL b_movto_tit_acr THEN
                ASSIGN p_log_refer_uni = NO.
        END.

        IF  p_cod_TABLE <> "lote_impl_tit_acr" THEN DO:
            FIND FIRST b_lote_impl_tit_acr NO-LOCK
                 WHERE b_lote_impl_tit_acr.cod_estab = p_cod_estab
                   AND b_lote_impl_tit_acr.cod_refer = p_cod_refer
                   AND RECID( b_lote_impl_tit_acr ) <> p_rec_tabela
                 USE-INDEX ltmplttc_id NO-ERROR.
            IF  AVAIL b_lote_impl_tit_acr THEN
                ASSIGN p_log_refer_uni = NO.
        END.

        IF  p_cod_TABLE <> "lote_liquidac_acr" THEN DO:
            FIND FIRST b_lote_liquidac_acr NO-LOCK
                 WHERE b_lote_liquidac_acr.cod_estab_refer = p_cod_estab
                   AND b_lote_liquidac_acr.cod_refer       = p_cod_refer
                   AND RECID( b_lote_liquidac_acr )       <> p_rec_tabela
                 USE-INDEX ltlqdccr_id NO-ERROR.
            IF  AVAIL b_lote_liquidac_acr THEN
                ASSIGN p_log_refer_uni = NO.
        END.

        IF  p_cod_TABLE <> "Operaá∆o financeira" THEN DO:
            FIND FIRST b_operac_financ_acr NO-LOCK
                 WHERE b_operac_financ_acr.cod_estab               = p_cod_estab
                   AND b_operac_financ_acr.cod_movto_operac_financ = p_cod_refer
                   AND RECID( b_operac_financ_acr )               <> p_rec_tabela
                 USE-INDEX oprcfnna_id NO-ERROR.
            IF  AVAIL b_operac_financ_acr THEN
                ASSIGN p_log_refer_uni = NO.
        END.

        IF  p_cod_TABLE = 'cobr_especial_acr' THEN DO:
            FIND FIRST b_cobr_especial_acr NO-LOCK
                 WHERE b_cobr_especial_acr.cod_estab = p_cod_estab
                   AND b_cobr_especial_acr.cod_refer = p_cod_refer
                   AND RECID( b_cobr_especial_acr ) <> p_rec_tabela
                 USE-INDEX cbrspclc_id NO-ERROR.
            IF  AVAIL b_cobr_especial_acr THEN
                ASSIGN p_log_refer_uni = NO.
        END.

    END.

END PROCEDURE.

PROCEDURE pi_retornar_finalid_indic_econ:
    
    def Input  param p_cod_indic_econ   as CHAR format "x(8)"       no-undo.
    def Input  param p_dat_transacao    as DATE format "99/99/9999" no-undo.
    def output param p_cod_finalid_econ as CHAR format "x(10)"      no-undo.

    find first histor_finalid_econ no-lock
        where histor_finalid_econ.cod_indic_econ          = p_cod_indic_econ
        and   histor_finalid_econ.dat_inic_valid_finalid <= p_dat_transacao
        and   histor_finalid_econ.dat_fim_valid_finalid  > p_dat_transacao no-error.

    if  avail histor_finalid_econ then 
        assign p_cod_finalid_econ = histor_finalid_econ.cod_finalid_econ.

END PROCEDURE.

PROCEDURE pi_retornar_dia_util:

    DEF INPUT  PARAM p_cod_estab      AS CHAR FORMAT "x(5)"       NO-UNDO.
    DEF INPUT  PARAM p_ind_tip_calend AS CHAR FORMAT "X(08)"      NO-UNDO. 
    DEF INPUT  PARAM p_num_dias       AS INT  FORMAT ">>>>,>>9"   NO-UNDO.
    DEF INPUT  PARAM p_dat_base       AS DATE FORMAT "99/99/9999" NO-UNDO. 
    DEF OUTPUT PARAM p_dat_return     AS DATE FORMAT "99/99/9999" NO-UNDO.
    DEF OUTPUT PARAM p_cod_return     AS CHAR FORMAT "x(40)"      NO-UNDO.

    DEF VAR v_log_fer AS LOG FORMAT "Sim/N∆o" INIT NO                                NO-UNDO.
    DEF VAR v_num_seq AS INT FORMAT ">>>,>>9":U LABEL "SeqÅància" COLUMN-LABEL "Seq" NO-UNDO.

    assign p_cod_return = "OK".

    find estabelecimento
        where estabelecimento.cod_estab = p_cod_estab no-lock no-error.
    
    case p_ind_tip_calend:
        when "Respons†vel Financeiro" then
            find calend_glob
                where calend_glob.cod_calend = estabelecimento.cod_calend_financ
                no-lock no-error.
        when "Materiais" then
            find calend_glob
                where calend_glob.cod_calend = estabelecimento.cod_calend_mater
                no-lock no-error.
        when "R.H." then
            find calend_glob
                where calend_glob.cod_calend = estabelecimento.cod_calend_rh
                no-lock no-error.
        when "Manufatura" then
            find calend_glob
                where calend_glob.cod_calend = estabelecimento.cod_calend_manuf
                no-lock no-error.
        when "Distribuiá∆o" then
            find calend_glob
                where calend_glob.cod_calend = estabelecimento.cod_calend_distrib
                no-lock no-error.
    end.
    if  not avail calend_glob
    then do:
        assign p_cod_return = "3896".
        return.
    end.

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
            end.

            if  dia_calend_glob.log_dia_util = yes then do:
                assign v_log_fer = no.
                for each fer_nac no-lock
                    where fer_nac.cod_pais     = v_cod_pais_fornec_clien
                      and fer_nac.dat_fer_nac  = p_dat_return:
                      assign v_log_fer = yes.
                end.
                if not v_log_fer then
                    leave acha_dia_util.
                else assign p_dat_return = p_dat_return + 1.
            end.

            else do:
                assign p_dat_return = p_dat_return + 1.
            end.
        end.
    end.
    else do:
        dias_block:
        do v_num_seq = 1 to p_num_dias:
            assign p_dat_return = p_dat_return + 1.
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
                end.

                if  dia_calend_glob.log_dia_util = yes then do:
                    assign v_log_fer = no.
                    for each fer_nac no-lock
                        where fer_nac.cod_pais     = v_cod_pais_fornec_clien
                          and fer_nac.dat_fer_nac  = p_dat_return:
                          assign v_log_fer = yes.
                    end.
                    if not v_log_fer then
                        leave acha_dia_util.
                    else assign p_dat_return = p_dat_return + 1.
                end.

                else do:
                    assign p_dat_return = p_dat_return + 1.
                end.
            end.
        end.
    end.

END PROCEDURE.
