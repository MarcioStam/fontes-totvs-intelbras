/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i esacr075rp 1.00.00.000}
/*****************************************************************************
**       Programa: esp/acr/esacr075rp.p
**       Data....: 06/02/2019
**       Autor...: Andrey M Oliveira
**       Objetivo: Estorno de liquida‡äes por lote.
*******************************************************************************/

{include/i-rpvar.i}    
{utp/utapi019.i}
{esp/acr/acr711zo.i}
{esapi/esapi015tt.i}

DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino     AS INTEGER
    FIELD arquivo     AS CHARACTER FORMAT "x(35)":U
    FIELD usuario     AS CHARACTER FORMAT "x(12)":U
    FIELD data-exec   AS DATE
    FIELD hora-exec   AS INTEGER
    FIELD cod_estab   LIKE movto_tit_acr.cod_estab
    FIELD cod_refer   LIKE movto_tit_acr.cod_refer
    FIELD dat_estorno LIKE movto_tit_acr.dat_transacao
    FIELD historico   LIKE histor_movto_tit_acr.des_text_histor.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.

DEF INPUT PARAM raw-param AS RAW NO-UNDO.
DEF INPUT PARAM TABLE for tt-raw-digita.

DEF NEW GLOBAL SHARED VAR v_cod_empres_usuar AS CHAR NO-UNDO.

DEF VAR h-acomp     AS HANDLE NO-UNDO.
DEF VAR c-arq-anexo AS CHAR   NO-UNDO.
DEF VAR v_cod_refer AS CHAR   NO-UNDO.
DEF VAR c-des-dat   AS CHAR   NO-UNDO.
DEF VAR i-num-aux   AS INT    NO-UNDO.
DEF VAR i-cont      AS INT    NO-UNDO.

def temp-table tt_log_erros_estorn_cancel no-undo
    field tta_cod_estab            as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_num_id_tit_acr       as integer format "9999999999" initial 0 label "Token Cta Receber" column-label "Token Cta Receber"
    field tta_num_id_movto_tit_acr as integer format "9999999999" initial 0 label "Token Movto Tit  ACR" column-label "Token Movto Tit  ACR"
    field ttv_num_mensagem         as integer format ">>>>,>>9" label "N£mero" column-label "N£mero Mensagem"
    field ttv_des_msg_erro         as character format "x(60)" label "Mensagem Erro" column-label "Inconsistˆncia"
    field ttv_des_msg_ajuda        as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda"
    index tt_relac_tit_acr         
          tta_cod_estab            ascending
          tta_num_id_tit_acr       ascending
          tta_num_id_movto_tit_acr ascending
          ttv_num_mensagem         ascending.

def temp-table tt_input_estorno no-undo
    field ttv_cod_label    as character format "x(8)" label "Label" column-label "Label"
    field ttv_des_conteudo as character format "x(40)" label "Texto" column-label "Texto"
    field ttv_num_seq      as integer format ">>>,>>9" label "Sequˆncia" column-label "Seq"
    index tt_primario      is primary
          ttv_num_seq      ascending.

DEF TEMP-TABLE tt_erros NO-UNDO
    field cod_estab         like tit_acr.cod_estab                           
    field cod_espec_docto   like tit_acr.cod_espec_docto                     
    field cod_ser_docto     like tit_acr.cod_ser_docto                       
    field cod_tit_acr       like tit_acr.cod_tit_acr                         
    field cod_parcela       like tit_acr.cod_parcela      
    field cod_refer         like tit_acr.cod_refer
    field ttv_num_mensagem  like tt_log_erros_estorn_cancel.ttv_num_mensagem 
    field ttv_des_msg_erro  like tt_log_erros_estorn_cancel.ttv_des_msg_erro 
    field ttv_des_msg_ajuda like tt_log_erros_estorn_cancel.ttv_des_msg_ajuda.

DEF TEMP-TABLE tt_estornado NO-UNDO
    field cod_estab         like tit_acr.cod_estab                           
    field cod_espec_docto   like tit_acr.cod_espec_docto                     
    field cod_ser_docto     like tit_acr.cod_ser_docto                       
    field cod_tit_acr       like tit_acr.cod_tit_acr                         
    field cod_parcela       like tit_acr.cod_parcela                         
    field cod_refer         like movto_tit_acr.cod_refer           
    field dat_liquidac      like movto_tit_acr.dat_liquidac_tit_acr.


create tt-param.
raw-transfer raw-param to tt-param.

ASSIGN c-arq-anexo = tt-param.arquivo.

{include/i-rpout.i}

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

RUN pi-inicializar IN h-acomp (INPUT "Inicializando...").

RUN pi_estorno.

{include/i-rpclo.i}

IF  VALID-HANDLE(h-acomp) THEN
    RUN pi-finalizar IN h-acomp.

RETURN "OK".


PROCEDURE pi_estorno:
    /*
    block_estorno:
    DO TRANS ON ERROR UNDO block_estorno:
    */
        EMPTY TEMP-TABLE tt_erros.
        EMPTY TEMP-TABLE tt_estornado.

        FOR EACH movto_tit_acr NO-LOCK
            WHERE movto_tit_acr.cod_estab           = tt-param.cod_estab
            AND   movto_tit_acr.cod_refer           = tt-param.cod_refer
            AND   movto_tit_acr.ind_trans_acr_abrev = "LIQ":

            IF  movto_tit_acr.log_movto_estordo THEN 
                NEXT.

            FIND FIRST tit_acr
                WHERE tit_acr.cod_estab      = movto_tit_acr.cod_estab
                AND   tit_acr.num_id_tit_acr = movto_tit_acr.num_id_tit_acr NO-LOCK NO-ERROR.

            IF  AVAIL tit_acr THEN DO:

                EMPTY TEMP-TABLE tt_log_erros_estorn_cancel.
                EMPTY TEMP-TABLE tt_input_estorno.

                IF VALID-HANDLE(h-acomp) THEN
                    RUN pi-acompanhar IN h-acomp(INPUT "Estornando liquida‡Æo: " + tit_acr.cod_tit_acr).

                RUN pi-gera-referencia IN THIS-PROCEDURE (INPUT  "EST",
                                                          INPUT  RECID(tit_acr),
                                                          OUTPUT v_cod_refer).
                create tt_input_estorno. 
                assign tt_input_estorno.ttv_cod_label    = "N¡vel"
                       tt_input_estorno.ttv_des_conteudo = "Movimentos"
                       tt_input_estorno.ttv_num_seq      = 1.

                create tt_input_estorno. 
                assign tt_input_estorno.ttv_cod_label    = "Opera‡Æo"
                       tt_input_estorno.ttv_des_conteudo = "Estorno"
                       tt_input_estorno.ttv_num_seq      = 1.

                create tt_input_estorno. 
                assign tt_input_estorno.ttv_cod_label    = "Estabelecimento"
                       tt_input_estorno.ttv_des_conteudo = tt-param.cod_estab
                       tt_input_estorno.ttv_num_seq      = 1.

                create tt_input_estorno. 
                assign tt_input_estorno.ttv_cod_label    = "Data"
                       tt_input_estorno.ttv_des_conteudo = string(tt-param.dat_estorno)
                       tt_input_estorno.ttv_num_seq      = 1.

                create tt_input_estorno. 
                assign tt_input_estorno.ttv_cod_label    = "Referˆncia"
                       tt_input_estorno.ttv_des_conteudo = v_cod_refer
                       tt_input_estorno.ttv_num_seq      = 1.

                create tt_input_estorno. 
                assign tt_input_estorno.ttv_cod_label    = "Hist¢rico"
                       tt_input_estorno.ttv_des_conteudo = tt-param.historico
                       tt_input_estorno.ttv_num_seq      = 1.

                create tt_input_estorno. 
                assign tt_input_estorno.ttv_cod_label    = "ID Movimento"
                       tt_input_estorno.ttv_des_conteudo = string(movto_tit_acr.num_id_movto_tit_acr)
                       tt_input_estorno.ttv_num_seq      = 1.

                create tt_input_estorno. 
                assign tt_input_estorno.ttv_cod_label    = "ID Titulo"
                       tt_input_estorno.ttv_des_conteudo =  string(movto_tit_acr.num_id_tit_acr)
                       tt_input_estorno.ttv_num_seq      = 1.


                run prgfin/acr/acr715zb.py (Input  1,
                                            Input  table tt_input_estorno,
                                            output table tt_log_erros_estorn_cancel).

                IF  CAN-FIND (FIRST tt_log_erros_estorn_cancel) THEN DO:
                    
                    FOR EACH tt_log_erros_estorn_cancel:

                        IF  tt_log_erros_estorn_cancel.ttv_num_mensagem = 7748 THEN NEXT.

                        CREATE tt_erros.
                        ASSIGN tt_erros.cod_estab         = tit_acr.cod_estab                           
                               tt_erros.cod_espec_docto   = tit_acr.cod_espec_docto                     
                               tt_erros.cod_ser_docto     = tit_acr.cod_ser_docto                       
                               tt_erros.cod_tit_acr       = tit_acr.cod_tit_acr                         
                               tt_erros.cod_parcela       = tit_acr.cod_parcela                         
                               tt_erros.cod_refer         = v_cod_refer
                               tt_erros.ttv_num_mensagem  = tt_log_erros_estorn_cancel.ttv_num_mensagem 
                               tt_erros.ttv_des_msg_erro  = tt_log_erros_estorn_cancel.ttv_des_msg_erro 
                               tt_erros.ttv_des_msg_ajuda = tt_log_erros_estorn_cancel.ttv_des_msg_ajuda.

                    END.
                END.
                ELSE DO:
                    CREATE tt_estornado.
                    ASSIGN tt_estornado.cod_estab       = tit_acr.cod_estab                           
                           tt_estornado.cod_espec_docto = tit_acr.cod_espec_docto                     
                           tt_estornado.cod_ser_docto   = tit_acr.cod_ser_docto                       
                           tt_estornado.cod_tit_acr     = tit_acr.cod_tit_acr                         
                           tt_estornado.cod_parcela     = tit_acr.cod_parcela
                           tt_estornado.cod_refer       = movto_tit_acr.cod_refer
                           tt_estornado.dat_liquidac    = movto_tit_acr.dat_liquidac_tit_acr.
                END.
            END.
        END.

        IF  CAN-FIND (FIRST tt_erros) THEN DO:

            PUT UNFORMATTED SKIP(2).
            PUT UNFORMATTED ";;;;;ERROS ESTORNO LIQUIDA€åES ACR" SKIP.
            PUT UNFORMATTED "Estab;Esp‚cie;S‚rie;T¡tulo;Parcela;Referˆncia;Num Mensagem;Erro;Ajuda" SKIP.

            FOR EACH tt_erros:
                PUT UNFORMATTED tt_erros.cod_estab        ";"
                                tt_erros.cod_espec_docto  ";"
                                tt_erros.cod_ser_docto    ";"
                                tt_erros.cod_tit_acr      ";"
                                tt_erros.cod_parcela      ";"
                                tt_erros.cod_refer        ";"
                                tt_erros.ttv_num_mensagem ";"
                                tt_erros.ttv_des_msg_erro ";"
                                tt_erros.ttv_des_msg_ajuda SKIP.        
            END.
            
            /*
            IF  VALID-HANDLE(h-acomp) THEN
                RUN pi-finalizar IN h-acomp.

            UNDO block_estorno, RETURN ERROR.
            */
        END.
        /*
        ELSE DO:
        */
             IF  CAN-FIND (FIRST tt_estornado) THEN DO:
                 PUT UNFORMATTED SKIP(2).
                 PUT UNFORMATTED ";;;;;LIQUIDA€åES ACR ESTORNADAS COM SUCESSO" SKIP.
                 PUT UNFORMATTED "Estab;Esp‚cie;S‚rie;T¡tulo;Parcela;Referˆncia;Dt Liquida‡Æo" SKIP.
                
                 FOR EACH tt_estornado:
                     PUT UNFORMATTED tt_estornado.cod_estab        ";"
                                     tt_estornado.cod_espec_docto  ";"
                                     tt_estornado.cod_ser_docto    ";"
                                     tt_estornado.cod_tit_acr      ";"
                                     tt_estornado.cod_parcela      ";"
                                     tt_estornado.cod_refer ";"
                                     tt_estornado.dat_liquidac SKIP.        
                 END.
             END.
        /*
        END.
        */
    /*
    END.
    */
END PROCEDURE.

PROCEDURE pi-gera-referencia:
    DEF INPUT  PARAM p-cod-estab  AS CHAR  FORMAT "x(3)"    NO-UNDO.
    DEF INPUT  PARAM p-rec-tabela AS RECID FORMAT ">>>>>>9" NO-UNDO.
    DEF OUTPUT PARAM p-referencia AS CHAR                   NO-UNDO.

    DEF VAR l-log-refer-uni AS LOG NO-UNDO.

    ASSIGN c-des-dat    = STRING(TODAY,"99999999")
           p-referencia = SUBSTRING(c-des-dat,7,2) + SUBSTRING(c-des-dat,3,2) + SUBSTRING(c-des-dat,1,2) + "T"
           i-num-aux    = INTEGER(THIS-PROCEDURE:HANDLE).

    DO  i-cont = 1 TO 3:
        ASSIGN p-referencia = p-referencia + CHR((RANDOM(0,i-num-aux) MOD 26) + 97).
    END.

    RUN pi_verifica_refer_unica_acr IN THIS-PROCEDURE (INPUT  p-cod-estab,
                                                       INPUT  p-referencia,
                                                       INPUT  "tit_acr",
                                                       INPUT  p-rec-tabela,
                                                       OUTPUT l-log-refer-uni).
    IF  NOT l-log-refer-uni THEN
        RUN pi-gera-referencia IN THIS-PROCEDURE (INPUT  p-cod-estab,
                                                  INPUT  p-rec-tabela,
                                                  OUTPUT p-referencia).
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi_verifica_refer_unica_acr:

    def Input param p_cod_estab
        as Character
        format "x(5)"
        no-undo.
    def Input param p_cod_refer
        as character
        format "x(10)"
        no-undo.
    def Input param p_cod_table
        as character
        format "x(8)"
        no-undo.
    def Input param p_rec_tabela
        as recid
        format ">>>>>>9"
        no-undo.
    def output param p_log_refer_uni
        as logical
        format "Sim/NÆo"
        no-undo.

    def buffer b_cobr_especial_acr
        for cobr_especial_acr.
    def buffer b_lote_impl_tit_acr
        for lote_impl_tit_acr.
    def buffer b_lote_liquidac_acr
        for lote_liquidac_acr.
    def buffer b_movto_tit_acr
        for movto_tit_acr.
    def buffer b_operac_financ_acr
        for operac_financ_acr.
    def buffer b_renegoc_acr
        for renegoc_acr.
    
    def var v_cod_return
        as character
        format "x(40)":U
        no-undo.

    assign p_log_refer_uni = yes.

    if  p_cod_table <> "lote_impl_tit_acr" /*l_lote_impl_tit_acr*/  then do:
        find first b_lote_impl_tit_acr no-lock
             where b_lote_impl_tit_acr.cod_estab = p_cod_estab
               and b_lote_impl_tit_acr.cod_refer = p_cod_refer
               and recid( b_lote_impl_tit_acr ) <> p_rec_tabela
             use-index ltmplttc_id no-error.
        if  avail b_lote_impl_tit_acr then
            assign p_log_refer_uni = no.
    end.

    if  p_cod_table <> "lote_liquidac_acr" /*l_lote_liquidac_acr*/  then do:
        find first b_lote_liquidac_acr no-lock
             where b_lote_liquidac_acr.cod_estab_refer = p_cod_estab
               and b_lote_liquidac_acr.cod_refer       = p_cod_refer
               and recid( b_lote_liquidac_acr )       <> p_rec_tabela
             use-index ltlqdccr_id no-error.
        if  avail b_lote_liquidac_acr then
            assign p_log_refer_uni = no.
    end.

    if  p_cod_table <> "Opera‡Æo financeira" /*l_operacao_financ*/  then do:
        find first b_operac_financ_acr no-lock
             where b_operac_financ_acr.cod_estab               = p_cod_estab
               and b_operac_financ_acr.cod_movto_operac_financ = p_cod_refer
               and recid( b_operac_financ_acr )               <> p_rec_tabela
             use-index oprcfnna_id no-error.
        if  avail b_operac_financ_acr then
            assign p_log_refer_uni = no.
    end.

    if  p_cod_table = 'cobr_especial_acr' then do:
        find first b_cobr_especial_acr no-lock
             where b_cobr_especial_acr.cod_estab = p_cod_estab
               and b_cobr_especial_acr.cod_refer = p_cod_refer
               and recid( b_cobr_especial_acr ) <> p_rec_tabela
             use-index cbrspclc_id no-error.
        if  avail b_cobr_especial_acr then
            assign p_log_refer_uni = no.
    end.

    if  p_log_refer_uni = yes then do:
        find first b_renegoc_acr no-lock
            where b_renegoc_acr.cod_estab = p_cod_estab
            and   b_renegoc_acr.cod_refer = p_cod_refer
            and   recid(b_renegoc_acr)   <> p_rec_tabela
            no-error.
        if  avail b_renegoc_acr then
            assign p_log_refer_uni = no.
        else do:
            find first b_movto_tit_acr no-lock
                 where b_movto_tit_acr.cod_estab = p_cod_estab
                   and b_movto_tit_acr.cod_refer = p_cod_refer
                   and recid(b_movto_tit_acr)   <> p_rec_tabela
                 use-index mvtttcr_refer
                 no-error.
            if  avail b_movto_tit_acr then
                assign p_log_refer_uni = no.
        end.
    end.

    &if defined (BF_FIN_BCOS_HISTORICOS) &then
        if  v_log_utiliza_mbh
        and can-find (his_movto_tit_acr_histor no-lock
                      where his_movto_tit_acr_histor.cod_estab = p_cod_estab
                      and   his_movto_tit_acr_histor.cod_refer = p_cod_refer)
        then do:

            assign p_log_refer_uni = no.
        end.
    &endif
END PROCEDURE.
