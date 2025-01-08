def temp-table tt_espec_docto no-undo
    field tta_cod_espec_docto              as character format "x(3)" label "EspÇcie Documento" column-label "EspÇcie"
    index tt_espec_docto                  
          tta_cod_espec_docto              ascending.

def temp-table tt_titulos_em_aberto_acr no-undo
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_num_id_tit_acr               as integer format "9999999999" initial 0 label "Token Cta Receber" column-label "Token Cta Receber"
    field tta_cod_unid_negoc               as character format "x(3)" label "Unid Neg¢cio" column-label "Un Neg"
    field tta_cod_espec_docto              as character format "x(3)" label "EspÇcie Documento" column-label "EspÇcie"
    field tta_cod_ser_docto                as character format "x(3)" label "SÇrie Documento" column-label "SÇrie"
    field tta_cod_tit_acr                  as character format "x(10)" label "T°tulo" column-label "T°tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field tta_cdn_cliente                  as Integer format ">>>,>>>,>>9" initial 0 label "Cliente" column-label "Cliente"
    field tta_cod_portador                 as character format "x(5)" label "Portador" column-label "Portador"
    field tta_cod_cart_bcia                as character format "x(3)" label "Carteira" column-label "Carteira"
    field tta_cdn_repres                   as Integer format ">>>,>>9" initial 0 label "Representante" column-label "Representante"
    field tta_dat_emis_docto               as date format "99/99/9999" initial today label "Data  Emiss∆o" column-label "Dt Emiss∆o"
    field tta_dat_vencto_tit_acr           as date format "99/99/9999" initial ? label "Vencimento" column-label "Vencimento"
    field ttv_val_sdo_tit_acr_apres        as decimal format "->>>,>>>,>>9.99" decimals 2 label "Saldo Finalid Apres" column-label "Saldo Apres"
    field ttv_num_atraso_dias_acr          as integer format "->>>>>>9" label "Dias" column-label "Dias"
    index tt_id                            is primary unique
          tta_cod_estab                    ascending
          tta_num_id_tit_acr               ascending
          tta_cod_unid_negoc               ascending.


    /************************ Parameter Definition Begin ************************/

    DEF INPUT PARAM p_dat_tit_acr_aber AS DATE FORMAT "99/99/9999" NO-UNDO.
    DEF OUTPUT PARAM TABLE FOR tt_titulos_em_aberto_acr.

    /************************* Parameter Definition End *************************/

    DEF BUFFER b_movto_tit_acr_ult FOR movto_tit_acr.


    RUN pi_verifica_tit_acr_em_aberto.

    FOR EACH tt_titulos_em_aberto_acr:
        IF tt_titulos_em_aberto_acr.ttv_val_sdo_tit_acr_apres = 0 
           THEN DELETE tt_titulos_em_aberto_acr.
    END.

/*****************************************************************************
** Procedure Interna.....: pi_verifica_tit_acr_em_aberto
** Descricao.............: pi_verifica_tit_acr_em_aberto
** Criado por............: Uno
** Criado em.............: 02/01/1997 11:57:21
** Alterado por..........: bre18490
** Alterado em...........: 18/04/2004 19:15:55
*****************************************************************************/
PROCEDURE pi_verifica_tit_acr_em_aberto:

    /************************* Variable Definition Begin ************************/

    DEFINE VARIABLE v_des_estab_select     AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE v_num_cont_aux         AS INTEGER     NO-UNDO.
    DEFINE VARIABLE v_dat_liquidac_tit_acr AS DATE        NO-UNDO.

    def var v_num_seq_ult_movto              as integer         no-undo. /*local*/
    def var v_num_seq_ult_movto_final        as integer         no-undo. /*local*/

    /************************** Variable Definition End *************************/

    assign v_num_seq_ult_movto = current-value(seq_movto_tit_acr).

    assign v_des_estab_select = " ".
    estab_block_esp:
    for each estabelecimento no-lock
        where estabelecimento.cod_empresa = "1":
        if v_des_estab_select = " " then
            assign v_des_estab_select = estabelecimento.cod_estab.
        else
            assign v_des_estab_select = v_des_estab_select + "," + estabelecimento.cod_estab.
    end /* for estab_block_esp */.

    RUN pi_verifica_espec_docto.

    des_estab_block:
    do v_num_cont_aux = 1 to num-entries(v_des_estab_select):
        estab_block:
        for each estabelecimento fields(cod_estab cod_empresa) no-lock
            where estabelecimento.cod_estab  = entry(v_num_cont_aux, v_des_estab_select):

            if  not can-find(first tit_acr where tit_acr.cod_estab = estabelecimento.cod_estab) then
                next estab_block.

            espec_block:
            for each tt_espec_docto no-lock:
                if  not can-find(first tit_acr
                    where tit_acr.cod_estab = estabelecimento.cod_estab
                    and   tit_acr.cod_espec_docto = tt_espec_docto.tta_cod_espec_docto) then 
                    next espec_block.

                dat_block:
                do v_dat_liquidac_tit_acr = (p_dat_tit_acr_aber + 1) to 12/31/9999:
                    find first tit_acr no-lock
                        where tit_acr.cod_estab             = estabelecimento.cod_estab
                        and   tit_acr.dat_liquidac_tit_acr >= v_dat_liquidac_tit_acr no-error.
                    if  avail tit_acr
                        then assign v_dat_liquidac_tit_acr = tit_acr.dat_liquidac_tit_acr.
                        else leave dat_block.

                    tit_block:
                    for each tit_acr use-index titacr_liquidac no-lock
                        where tit_acr.cod_estab            = estabelecimento.cod_estab
                        and   tit_acr.dat_liquidac_tit_acr = v_dat_liquidac_tit_acr
                        and   tit_acr.cod_espec_docto      = tt_espec_docto.tta_cod_espec_docto
                        and   tit_acr.dat_transacao       <= p_dat_tit_acr_aber:

                        FIND emscad.cliente NO-LOCK
                            WHERE emscad.cliente.cod_empresa = "1"
                              AND emscad.cliente.cdn_cliente = tit_acr.cdn_cliente NO-ERROR.

                        run pi_verifica_tit_acr_em_aberto_cria_tt.

                    end.
                end.
            end.
        end.
    end.

    /* ** TRATAMENTO ESPECIAL PARA QUE OS TITULOS LIQUIDADOS DURANTE A EMISSAO DO RELATORIO
         NAO FIQUEM DE FORA DO RELATORIO, DEVIDO AO "DO:" DATAS DE LIQUIDAÄ«O ***/
    assign v_num_seq_ult_movto_final = current-value(seq_movto_tit_acr).

    if  v_num_seq_ult_movto_final > v_num_seq_ult_movto then do:
        estab_block:
        for each estabelecimento fields(cod_estab cod_empresa) no-lock
            where estabelecimento.cod_empresa  = "1",
            each  b_movto_tit_acr_ult no-lock
            where b_movto_tit_acr_ult.cod_estab            = estabelecimento.cod_estab
            and   b_movto_tit_acr_ult.num_id_movto_tit_acr > v_num_seq_ult_movto
            and   b_movto_tit_acr_ult.ind_trans_acr <> "Alteraá∆o Data Emiss∆o" /*l_alteracao_data_emissao*/ 
            and   b_movto_tit_acr_ult.ind_trans_acr <> "Alteraá∆o Data Vencimento" /*l_alteracao_data_vencimento*/ 
            and   b_movto_tit_acr_ult.ind_trans_acr <> "Alteraá∆o n∆o Cont†bil" /*l_alteracao_nao_contabil*/ 
            and   b_movto_tit_acr_ult.ind_trans_acr <> "Correá∆o de Valor" /*l_correcao_de_valor*/ 
            and   b_movto_tit_acr_ult.ind_trans_acr <> "Correá∆o Valor na Liquidac" /*l_correcao_valor_na_liquidac*/ 
            and   b_movto_tit_acr_ult.ind_trans_acr <> "Estorno Correá∆o Valor" /*l_estorno_correcao_valor*/ 
            and   b_movto_tit_acr_ult.ind_trans_acr <> "Estorno Correá∆o Val Liquidac" /*l_estorno_correcao_val_liquidac*/ ,
            tit_acr no-lock
            where tit_acr.cod_estab      = b_movto_tit_acr_ult.cod_estab
            and   tit_acr.num_id_tit_acr = b_movto_tit_acr_ult.num_id_tit_acr,
            first tt_espec_docto
            where tt_espec_docto.tta_cod_espec_docto = tit_acr.cod_espec_docto:

            for each tt_titulos_em_aberto_acr
                where tt_titulos_em_aberto_acr.tta_cod_estab      = tit_acr.cod_estab
                and   tt_titulos_em_aberto_acr.tta_num_id_tit_acr = tit_acr.num_id_tit_acr:
                delete tt_titulos_em_aberto_acr.
            end.

            FIND emscad.cliente NO-LOCK
                WHERE emscad.cliente.cod_empresa = "1"
                  AND emscad.cliente.cdn_cliente = tit_acr.cdn_cliente NO-ERROR.

            RUN pi_verifica_tit_acr_em_aberto_cria_tt.

        end.
    end.





END PROCEDURE. /* pi_verifica_tit_acr_em_aberto */
/*****************************************************************************
** Procedure Interna.....: pi_verifica_tit_acr_em_aberto_cria_tt
** Descricao.............: pi_verifica_tit_acr_em_aberto_cria_tt
** Criado por............: Barth
** Criado em.............: 22/06/1999 08:29:49
** Alterado por..........: fut12235_2
** Alterado em...........: 01/09/2008 11:24:45
*****************************************************************************/
PROCEDURE pi_verifica_tit_acr_em_aberto_cria_tt:

    /************************* Variable Definition Begin ************************/

    DEFINE VARIABLE v_val_sdo_tit_acr    AS DECIMAL     NO-UNDO.

    /************************** Variable Definition End *************************/

    val_block:
    for each val_tit_acr fields (cod_estab num_id_tit_acr cod_finalid_econ cod_unid_negoc val_origin_tit_acr val_sdo_tit_acr val_entr_transf_estab  val_saida_transf_unid_negoc) no-lock
        where val_tit_acr.cod_estab        = tit_acr.cod_estab
        and   val_tit_acr.num_id_tit_acr   = tit_acr.num_id_tit_acr
        and   val_tit_acr.cod_finalid_econ = "Corrente"
        break by val_tit_acr.cod_unid_negoc:

        assign v_val_sdo_tit_acr = v_val_sdo_tit_acr + val_tit_acr.val_sdo_tit_acr.

        if  last-of(val_tit_acr.cod_unid_negoc) then do:

            create tt_titulos_em_aberto_acr.
            assign tt_titulos_em_aberto_acr.tta_cod_estab             = tit_acr.cod_estab
                   tt_titulos_em_aberto_acr.tta_num_id_tit_acr        = tit_acr.num_id_tit_acr
                   tt_titulos_em_aberto_acr.tta_cod_espec_docto       = tit_acr.cod_espec_docto
                   tt_titulos_em_aberto_acr.tta_cod_ser_docto         = tit_acr.cod_ser_docto
                   tt_titulos_em_aberto_acr.tta_cod_tit_acr           = tit_acr.cod_tit_acr
                   tt_titulos_em_aberto_acr.tta_cod_parcela           = tit_acr.cod_parcela
                   tt_titulos_em_aberto_acr.tta_cod_unid_negoc        = val_tit_acr.cod_unid_negoc
                   tt_titulos_em_aberto_acr.tta_cdn_cliente           = tit_acr.cdn_cliente
                   tt_titulos_em_aberto_acr.tta_cod_portador          = tit_acr.cod_portador
                   tt_titulos_em_aberto_acr.tta_cod_cart_bcia         = tit_acr.cod_cart_bcia               
                   tt_titulos_em_aberto_acr.tta_cdn_repres            = tit_acr.cdn_repres
                   tt_titulos_em_aberto_acr.tta_dat_emis_docto        = tit_acr.dat_emis_docto
                   tt_titulos_em_aberto_acr.tta_dat_vencto_tit_acr    = tit_acr.dat_vencto_tit_acr
                   tt_titulos_em_aberto_acr.ttv_val_sdo_tit_acr_apres = v_val_sdo_tit_acr
                   tt_titulos_em_aberto_acr.ttv_num_atraso_dias_acr   = p_dat_tit_acr_aber - tit_acr.dat_vencto_tit_acr.

            assign v_val_sdo_tit_acr    = 0.

        end.
    end.

    if  not avail tt_titulos_em_aberto_acr then
        return 'NOK'.

    run pi_verifica_movtos_tit_acr_em_aberto.

    return "".

END PROCEDURE. /* pi_verifica_tit_acr_em_aberto_cria_tt */
/*****************************************************************************
** Procedure Interna.....: pi_verifica_espec_docto
** Descricao.............: pi_verifica_espec_docto
** Criado por............: Menna
** Criado em.............: 08/09/1998 09:29:53
** Alterado por..........: bre19062
** Alterado em...........: 30/11/2002 15:56:52
*****************************************************************************/
PROCEDURE pi_verifica_espec_docto:

    del_tt:
    for each tt_espec_docto exclusive-lock:
        delete tt_espec_docto.
    end /* for del_tt */.

    espec_block:
    for each espec_docto fields (cod_espec_docto ind_tip_espec_docto) no-lock:

        if  not can-find( first espec_docto_financ_acr no-lock
            where espec_docto_financ_acr.cod_espec_docto = espec_docto.cod_espec_docto ) then
            next espec_block.

     /*   if  (espec_docto.ind_tip_espec_docto = "Previs∆o" /*l_previsao*/           and v_log_mostra_docto_acr_prev)
           or (espec_docto.ind_tip_espec_docto = "Antecipaá∆o" /*l_antecipacao*/        and v_log_mostra_docto_acr_antecip)
           or (espec_docto.ind_tip_espec_docto = "Normal" /*l_normal*/             and v_log_mostra_docto_acr_normal)
           or (espec_docto.ind_tip_espec_docto = "Aviso DÇbito" /*l_aviso_debito*/       and v_log_mostra_docto_acr_aviso_db)
           or (espec_docto.ind_tip_espec_docto = "Cheques Recebidos" /*l_cheques_recebidos*/  and v_log_mostra_docto_acr_cheq)
           or (espec_docto.ind_tip_espec_docto = "Terceiros" /*l_terceiros*/          and v_log_tip_espec_docto_terc and v_log_control_terc_acr)
           or (espec_docto.ind_tip_espec_docto = "Cheques Terceiros" /*l_cheq_terc*/          and v_log_tip_espec_docto_cheq_terc and v_log_control_terc_acr)
           or (espec_docto.ind_tip_espec_docto = "Vendor" /*l_vendor*/             and v_log_mostra_docto_vendor)       
           or (espec_docto.ind_tip_espec_docto = "Vendor Repactuado" /*l_vendor_repac*/       and v_log_mostra_docto_vendor_repac)
        then do:*/

           create tt_espec_docto.
           assign tt_espec_docto.tta_cod_espec_docto = espec_docto.cod_espec_docto.
        end /* if */.
    /*end /* for espec_block */.*/

END PROCEDURE. /* pi_verifica_espec_docto */
/*****************************************************************************
** Procedure Interna.....: pi_verifica_movtos_tit_acr_em_aberto
** Descricao.............: pi_verifica_movtos_tit_acr_em_aberto
** Criado por............: Uno
** Criado em.............: 02/01/1997 16:49:44
** Alterado por..........: fut40552
** Alterado em...........: 08/05/2007 15:18:05
*****************************************************************************/
PROCEDURE pi_verifica_movtos_tit_acr_em_aberto:

    /************************** Buffer Definition Begin *************************/

    def buffer btt_titulos_em_aberto_acr
        for tt_titulos_em_aberto_acr.
    def buffer b_movto_tit_acr_pai
        for movto_tit_acr.

    /*************************** Buffer Definition End **************************/

    /************************* Variable Definition Begin ************************/

    def var v_cod_estab                      as character       no-undo. /*local*/
    def var v_log_liq_perda                  as logical         no-undo. /*local*/
    def var v_num_id_movto_tit_acr           as integer         no-undo. /*local*/
    DEFINE VARIABLE v_num_multiplic  AS INTEGER     NO-UNDO.
    DEFINE VARIABLE v_val_unid_negoc AS DECIMAL     NO-UNDO.

    /************************** Variable Definition End *************************/

    find first b_movto_tit_acr_pai
        where b_movto_tit_acr_pai.cod_estab         = tit_acr.cod_estab
        and   b_movto_tit_acr_pai.num_id_tit_acr    = tit_acr.num_id_tit_acr
        and   b_movto_tit_acr_pai.dat_transacao    <= p_dat_tit_acr_aber
        and   b_movto_tit_acr_pai.log_movto_estordo = no
        and  (b_movto_tit_acr_pai.ind_trans_acr     = "Liquidaá∆o Perda Dedut°vel" /*l_liquidacao_perda_dedutivel*/ 
        or    b_movto_tit_acr_pai.ind_trans_acr     = "Estorno de T°tulo" /*l_estorno_de_titulo*/ )
        use-index mvtttcr_id no-lock no-error.
    if  avail b_movto_tit_acr_pai then do:
        assign v_log_liq_perda = yes.
        for each btt_titulos_em_aberto_acr
            where btt_titulos_em_aberto_acr.tta_cod_estab      = tit_acr.cod_estab
            and   btt_titulos_em_aberto_acr.tta_num_id_tit_acr = tit_acr.num_id_tit_acr:
            assign btt_titulos_em_aberto_acr.ttv_val_sdo_tit_acr_apres = 0.
        end.
    end.


    /* ** VOLTA O SALDO DO T÷TULO, DE ACORDO COM OS MOVTOS POSTERIORES A DATA DE CORTE ***/
    movto_block:
    for each movto_tit_acr no-lock
        where movto_tit_acr.cod_estab      = tit_acr.cod_estab
        and   movto_tit_acr.num_id_tit_acr = tit_acr.num_id_tit_acr
        and   movto_tit_acr.dat_transacao  > p_dat_tit_acr_aber:

        if  movto_tit_acr.ind_trans_acr  = "Alteraá∆o Data Vencimento" /*l_alteracao_data_vencimento*/ 
        or  movto_tit_acr.ind_trans_acr  = "Alteraá∆o n∆o Cont†bil" /*l_alteracao_nao_contabil*/ 
        or  movto_tit_acr.ind_trans_acr  = "Implantaá∆o" /*l_implantacao*/ 
        or  movto_tit_acr.ind_trans_acr  = "Implantaá∆o a CrÇdito" /*l_implantacao_a_credito*/ 
        or  movto_tit_acr.ind_trans_acr  = "Transf Estabelecimento" /*l_transf_estabelecimento*/ 
        or  movto_tit_acr.ind_trans_acr  = "Renegociaá∆o" /*l_renegociacao*/ 
        or  movto_tit_acr.ind_trans_acr  = "Liquidaá∆o Perda Dedut°vel" /*l_liquidacao_perda_dedutivel*/ 
        or  movto_tit_acr.ind_trans_acr  = "Estorno de T°tulo" /*l_estorno_de_titulo*/  then
            next movto_block.

        /* ** LIQUIDAÄ«O AP‡S PERDA DEDUT÷VEL N«O CONTA, N«O DEVE VOLTAR SALDO ***/
        if  v_log_liq_perda = yes
        and movto_tit_acr.log_recuper_perda = yes 
            then next movto_block.

        if  movto_tit_acr.ind_trans_acr begins "Estorno" /*l_estorno*/  then do:
            assign v_num_id_movto_tit_acr = movto_tit_acr.num_id_movto_tit_acr_pai
                   v_cod_estab            = movto_tit_acr.cod_estab_tit_acr_pai
                   v_num_multiplic        = -1. /* O estorno ser† subtra°do do saldo, por esse motivo o 
                                                   v_num_multiplic ser† multiplicado pela cotaá∆o */
        end.
        else do:
            assign v_num_id_movto_tit_acr = movto_tit_acr.num_id_movto_tit_acr
                   v_cod_estab            = movto_tit_acr.cod_estab
                   v_num_multiplic        = 1.
        end.

        /* ** VOLTA ESTORNO DE PERDAS DEDUT÷VEIS (Barth) ***/
        if  movto_tit_acr.ind_trans_acr = "Estorno de Liquidacao" /*l_estorno_de_liquidacao*/  then do:
            find b_movto_tit_acr_pai
                where b_movto_tit_acr_pai.cod_estab            = movto_tit_acr.cod_estab_tit_acr_pai
                and   b_movto_tit_acr_pai.num_id_movto_tit_acr = movto_tit_acr.num_id_movto_tit_acr_pai
                no-lock no-error.
            if  avail b_movto_tit_acr_pai
            and b_movto_tit_acr_pai.ind_trans_acr = "Liquidaá∆o Perda Dedut°vel" /*l_liquidacao_perda_dedutivel*/  then do:
                if  b_movto_tit_acr_pai.dat_transacao <= p_dat_tit_acr_aber then do:
                    for each aprop_ctbl_acr no-lock
                        where aprop_ctbl_acr.cod_estab             = b_movto_tit_acr_pai.cod_estab
                        and   aprop_ctbl_acr.num_id_movto_tit_acr  = b_movto_tit_acr_pai.num_id_movto_tit_acr
                        and   aprop_ctbl_acr.ind_natur_lancto_ctbl = 'CR',
                        each val_aprop_ctbl_acr no-lock
                        where val_aprop_ctbl_acr.cod_estab             = aprop_ctbl_acr.cod_estab
                        and   val_aprop_ctbl_acr.num_id_aprop_ctbl_acr = aprop_ctbl_acr.num_id_aprop_ctbl_acr
                        and   val_aprop_ctbl_acr.cod_finalid_econ      = 'Corrente':
                        find first tt_titulos_em_aberto_acr
                            where tt_titulos_em_aberto_acr.tta_cod_estab      = tit_acr.cod_estab
                            and   tt_titulos_em_aberto_acr.tta_num_id_tit_acr = tit_acr.num_id_tit_acr no-error.
                        assign tt_titulos_em_aberto_acr.ttv_val_sdo_tit_acr_apres = tt_titulos_em_aberto_acr.ttv_val_sdo_tit_acr_apres - val_aprop_ctbl_acr.val_aprop_ctbl.
                    end.
                end.
                next movto_block.
            end.
        end.

        /* GRAVA O VALOR ORIGINAL E SALDO DO T÷TULO NA FINALIDADE ORIGINAL */
        val_block:
        for each val_movto_tit_acr no-lock
            where val_movto_tit_acr.cod_estab            = v_cod_estab
            and   val_movto_tit_acr.num_id_movto_tit_acr = v_num_id_movto_tit_acr
            and   val_movto_tit_acr.cod_finalid_econ     = 'corrente'
            break by val_movto_tit_acr.cod_unid_negoc:

            /* code_block: */
            case movto_tit_acr.ind_trans_acr:
                when "Acerto Valor a DÇbito" /*l_acerto_valor_a_debito*/         or
                when "Acerto Valor a Maior" /*l_acerto_valor_a_maior*/         or
                when "Estorno Acerto Val DÇbito" /*l_estorno_acerto_val_debito*/         or
                when "Estorno Acerto Val Maior" /*l_estorno_acerto_val_maior*/ then
                    assign v_val_unid_negoc = v_val_unid_negoc - ( val_movto_tit_acr.val_ajust_val_tit_acr / (1 * v_num_multiplic) ).

                when "Acerto Valor a CrÇdito" /*l_acerto_valor_a_credito*/         or
                when "Acerto Valor a Menor" /*l_acerto_valor_a_menor*/         or
                when "Estorno Acerto Val CrÇdito" /*l_estorno_acerto_val_credito*/         or
                when "Estorno Acerto Val Menor" /*l_estorno_acerto_val_menor*/ then
                    assign v_val_unid_negoc = v_val_unid_negoc + ( val_movto_tit_acr.val_ajust_val_tit_acr / (1 * v_num_multiplic) ).

                when "Liquidaá∆o" /*l_liquidacao*/         or
                when "Devoluá∆o" /*l_devolucao*/         or
                when "Liquidaá∆o Enctro Ctas" /*l_liquidacao_enctro_ctas*/         or
                when "Estorno de Liquidacao" /*l_estorno_de_liquidacao*/ then
                    assign v_val_unid_negoc = v_val_unid_negoc + ( ( val_movto_tit_acr.val_liquidac_tit_acr 
                                                     + val_movto_tit_acr.val_abat_tit_acr
                                                     + val_movto_tit_acr.val_desconto ) / (1 * v_num_multiplic) ).

                when "Liquidaá∆o Renegociac" /*l_liquidacao_renegociac*/         or
                when "Estorno Liquidacao Subst" /*l_estorno_liquidacao_subst*/         or
                when "Estorno Liquid Renegociac" /*l_estorno_liquid_renegociac*/ then
                    assign v_val_unid_negoc = v_val_unid_negoc + ( val_movto_tit_acr.val_saida_subst_nf_dupl / (1 * v_num_multiplic) ).

                when "Liquidaá∆o Transf Estab" /*l_liquidacao_transf_estab*/         or
                when "Estorno Liquid Transf Estab" /*l_estorno_liquid_transf_estab*/ then
                    assign v_val_unid_negoc = v_val_unid_negoc + ( val_movto_tit_acr.val_transf_estab / (1 * v_num_multiplic) ).

                when "Correá∆o de Valor" /*l_correcao_de_valor*/         or
                when "Correá∆o Valor na Liquidac" /*l_correcao_valor_na_liquidac*/         or
                when "Estorno Correá∆o Valor" /*l_estorno_correcao_valor*/         or
                when "Estorno Correá∆o Val Liquidac" /*l_estorno_correcao_val_liquidac*/ then
                    assign v_val_unid_negoc = v_val_unid_negoc - ( ( val_movto_tit_acr.val_variac_cambial
                                                     + val_movto_tit_acr.val_acerto_cmcac
                                                     + val_movto_tit_acr.val_ganho_perda_cm
                                                     + val_movto_tit_acr.val_ganho_perda_projec ) / (1 * v_num_multiplic) ).

                when "Transf Unidade Neg¢cio" /*l_transf_unidade_negocio*/         or
                when "Estorno Transf Unid Negoc" /*l_estorno_transf_unid_negoc*/ then
                    assign v_val_unid_negoc = v_val_unid_negoc + ( ( val_movto_tit_acr.val_saida_transf_unid_negoc
                                                     - val_movto_tit_acr.val_entr_transf_unid_negoc ) / (1 * v_num_multiplic) ).
            end /* case code_block */.

            if  last-of(val_movto_tit_acr.cod_unid_negoc)
            then do:
                find first tt_titulos_em_aberto_acr
                     where tt_titulos_em_aberto_acr.tta_cod_estab      = tit_acr.cod_estab
                     and   tt_titulos_em_aberto_acr.tta_num_id_tit_acr = tit_acr.num_id_tit_acr 
                     and   tt_titulos_em_aberto_acr.tta_cod_unid_negoc = val_movto_tit_acr.cod_unid_negoc 
                no-error.
                if  avail tt_titulos_em_aberto_acr then do:     
                    assign tt_titulos_em_aberto_acr.ttv_val_sdo_tit_acr_apres = tt_titulos_em_aberto_acr.ttv_val_sdo_tit_acr_apres + v_val_unid_negoc.                                                                      
                    assign v_val_unid_negoc = 0.
                end.
            end.
        end.

    end.

END PROCEDURE. /* pi_verifica_movtos_tit_acr_em_aberto */
/*****************************************************************************
** Procedure Interna.....: pi_retornar_finalid_indic_econ
** Descricao.............: pi_retornar_finalid_indic_econ
** Criado por............: 
** Criado em.............: // 
** Alterado por..........: fut35183_4
** Alterado em...........: 12/03/2008 16:45:35
*****************************************************************************/
PROCEDURE pi_retornar_finalid_indic_econ:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_indic_econ
        as character
        format "x(8)"
        no-undo.
    def Input param p_dat_transacao
        as date
        format "99/99/9999"
        no-undo.
    def output param p_cod_finalid_econ
        as character
        format "x(10)"
        no-undo.


    /************************* Parameter Definition End *************************/

    /* alteracao sob demanda - atividade 195864*/
    for first histor_finalid_econ fields (cod_finalid_econ) no-lock
        where histor_finalid_econ.cod_indic_econ          = p_cod_indic_econ
        and   histor_finalid_econ.dat_inic_valid_finalid <= p_dat_transacao
        and   histor_finalid_econ.dat_fim_valid_finalid  > p_dat_transacao.

        if avail histor_finalid_econ then
           assign p_cod_finalid_econ = histor_finalid_econ.cod_finalid_econ.
    end.

END PROCEDURE. /* pi_retornar_finalid_indic_econ */
/*****************************************************************************
** Procedure Interna.....: pi_retornar_indic_econ_finalid
** Descricao.............: pi_retornar_indic_econ_finalid
** Criado por............: vladimir
** Criado em.............: // 
** Alterado por..........: Menna
** Alterado em...........: 06/05/1999 10:21:29
*****************************************************************************/
PROCEDURE pi_retornar_indic_econ_finalid:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_finalid_econ
        as character
        format "x(10)"
        no-undo.
    def Input param p_dat_transacao
        as date
        format "99/99/9999"
        no-undo.
    def output param p_cod_indic_econ
        as character
        format "x(8)"
        no-undo.


    /************************* Parameter Definition End *************************/

    find first histor_finalid_econ no-lock
         where histor_finalid_econ.cod_finalid_econ = p_cod_finalid_econ
           and histor_finalid_econ.dat_inic_valid_finalid <= p_dat_transacao
           and histor_finalid_econ.dat_fim_valid_finalid > p_dat_transacao
    &if "{&emsuni_version}" >= "5.01" &then
         use-index hstrfnld_id
    &endif
          /*cl_finalid_ativa of histor_finalid_econ*/ no-error.
    if  avail histor_finalid_econ then
        assign p_cod_indic_econ = histor_finalid_econ.cod_indic_econ.

END PROCEDURE. /* pi_retornar_indic_econ_finalid */
/*****************************************************************************
** Procedure Interna.....: pi_achar_cotac_indic_econ
** Descricao.............: pi_achar_cotac_indic_econ
** Criado por............: vladimir
** Criado em.............: // 
** Alterado por..........: fut1309_4
** Alterado em...........: 08/02/2006 16:12:34
*****************************************************************************/
PROCEDURE pi_achar_cotac_indic_econ:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_indic_econ_base
        as character
        format "x(8)"
        no-undo.
    def Input param p_cod_indic_econ_idx
        as character
        format "x(8)"
        no-undo.
    def Input param p_dat_transacao
        as date
        format "99/99/9999"
        no-undo.
    def Input param p_ind_tip_cotac_parid
        as character
        format "X(09)"
        no-undo.
    def output param p_dat_cotac_indic_econ
        as date
        format "99/99/9999"
        no-undo.
    def output param p_val_cotac_indic_econ
        as decimal
        format ">>>>,>>9.9999999999"
        decimals 10
        no-undo.
    def output param p_cod_return
        as character
        format "x(40)"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_dat_cotac_mes
        as date
        format "99/99/9999":U
        no-undo.
    def var v_log_indic
        as logical
        format "Sim/N∆o"
        initial no
        no-undo.
    def var v_cod_indic_econ_orig            as character       no-undo. /*local*/
    def var v_val_cotac_indic_econ_base      as decimal         no-undo. /*local*/
    def var v_val_cotac_indic_econ_idx       as decimal         no-undo. /*local*/


    /************************** Variable Definition End *************************/

    /* alteraá∆o sob demanda da atividade 148.681*/
    release cotac_parid.

    if  p_cod_indic_econ_base = p_cod_indic_econ_idx
    then do:
        /* **
         Quando a Base e o ÷ndice forem iguais, significa que a cotaá∆o pode ser percentual,
         portanto n∆o basta apenas retornar 1 e deve ser feita toda a pesquisa abaixo para
         encontrar a taxa da moeda no dia informado.
         Exemplo: D¢lar - D¢lar, poder°amos retornar 1
                  ANBID - ANBID, devemos retornar a taxa do dia.
        ***/
        find indic_econ no-lock
             where indic_econ.cod_indic_econ  = p_cod_indic_econ_base
               and indic_econ.dat_inic_valid <= p_dat_transacao
               and indic_econ.dat_fim_valid  >  p_dat_transacao
             no-error.
        if  avail indic_econ then do:
            if  indic_econ.ind_tip_cotac = "Valor" /*l_valor*/  then do:
                assign p_dat_cotac_indic_econ = p_dat_transacao
                       p_val_cotac_indic_econ = 1
                       p_cod_return           = "OK" /*l_ok*/ .
            end.
            else do:
                find cotac_parid no-lock
                     where cotac_parid.cod_indic_econ_base = p_cod_indic_econ_base
                       and cotac_parid.cod_indic_econ_idx = p_cod_indic_econ_idx
                       and cotac_parid.dat_cotac_indic_econ = p_dat_transacao
                       and cotac_parid.ind_tip_cotac_parid = p_ind_tip_cotac_parid
    &if "{&emsuni_version}" >= "5.01" &then
                     use-index ctcprd_id
    &endif
                      /*cl_acha_cotac of cotac_parid*/ no-error.
                if  not avail cotac_parid
                then do:
                    find parid_indic_econ no-lock
                         where parid_indic_econ.cod_indic_econ_base = p_cod_indic_econ_base
                           and parid_indic_econ.cod_indic_econ_idx = p_cod_indic_econ_idx
    &if "{&emsuni_version}" >= "5.01" &then
                         use-index prdndccn_id
    &endif
                          /*cl_acha_parid_param of parid_indic_econ*/ no-error.
                    /* block: */
                    case parid_indic_econ.ind_criter_busca:
                        when "Anterior" /*l_anterior*/ then find prev cotac_parid no-lock
                              where cotac_parid.cod_indic_econ_base = p_cod_indic_econ_base
                                and cotac_parid.cod_indic_econ_idx = p_cod_indic_econ_idx
                                and cotac_parid.dat_cotac_indic_econ < p_dat_transacao
                                and cotac_parid.ind_tip_cotac_parid = p_ind_tip_cotac_parid
                                and cotac_parid.val_cotac_indic_econ <> 0.0
    &if "{&emsuni_version}" >= "5.01" &then
                              use-index ctcprd_id
    &endif
                               /*cl_acha_cotac_anterior of cotac_parid*/ no-error.
                        when "Pr¢ximo" /*l_proximo*/ then  find next cotac_parid no-lock
                               where cotac_parid.cod_indic_econ_base = p_cod_indic_econ_base
                                 and cotac_parid.cod_indic_econ_idx = p_cod_indic_econ_idx
                                 and cotac_parid.dat_cotac_indic_econ > p_dat_transacao
                                 and cotac_parid.ind_tip_cotac_parid = p_ind_tip_cotac_parid
                                 and cotac_parid.val_cotac_indic_econ <> 0.0
    &if "{&emsuni_version}" >= "5.01" &then
                               use-index ctcprd_id
    &endif
                                /*cl_acha_cotac_posterior of cotac_parid*/ no-error.
                    end /* case block */.
                    if  not avail cotac_parid
                    then do:
                        assign p_cod_return = "358"                   + "," +
                                              p_cod_indic_econ_base   + "," +
                                              p_cod_indic_econ_idx    + "," +
                                              string(p_dat_transacao) + "," +
                                              p_ind_tip_cotac_parid.
                    end /* if */.
                    else do:
                        assign p_dat_cotac_indic_econ = cotac_parid.dat_cotac_indic_econ
                               p_val_cotac_indic_econ = cotac_parid.val_cotac_indic_econ
                               p_cod_return           = "OK" /*l_ok*/ .
                    end /* else */.
                end /* if */.
                else do:
                    assign p_dat_cotac_indic_econ = cotac_parid.dat_cotac_indic_econ
                           p_val_cotac_indic_econ = cotac_parid.val_cotac_indic_econ
                           p_cod_return           = "OK" /*l_ok*/ .
                end /* else */.
            end.
        end.
        else do:
            assign p_cod_return = "335".
        end.
    end /* if */.
    else do:
        find parid_indic_econ no-lock
             where parid_indic_econ.cod_indic_econ_base = p_cod_indic_econ_base
               and parid_indic_econ.cod_indic_econ_idx = p_cod_indic_econ_idx
             use-index prdndccn_id no-error.
        if  avail parid_indic_econ
        then do:


            /* Begin_Include: i_verifica_cotac_parid */
            /* verifica as cotacoes da moeda p_cod_indic_econ_base para p_cod_indic_econ_idx 
              cadastrada na base, de acordo com a periodicidade da cotacao (obtida na 
              parid_indic_econ, que deve estar avail)*/

            /* period_block: */
            case parid_indic_econ.ind_periodic_cotac:
                when "Di†ria" /*l_diaria*/ then
                    diaria_block:
                    do:
                        find cotac_parid no-lock
                            where cotac_parid.cod_indic_econ_base  = p_cod_indic_econ_base
                              and cotac_parid.cod_indic_econ_idx   = p_cod_indic_econ_idx
                              and cotac_parid.dat_cotac_indic_econ = p_dat_transacao
                              and cotac_parid.ind_tip_cotac_parid  = p_ind_tip_cotac_parid
                            use-index ctcprd_id no-error.
                        if  not avail cotac_parid or cotac_parid.val_cotac_indic_econ = 0
                        then do:
                            find parid_indic_econ no-lock
                                where parid_indic_econ.cod_indic_econ_base = p_cod_indic_econ_base
                                  and parid_indic_econ.cod_indic_econ_idx  = p_cod_indic_econ_idx
                                use-index prdndccn_id no-error.
                            /* block: */
                            case parid_indic_econ.ind_criter_busca:
                                when "Anterior" /*l_anterior*/ then 
                                    find prev cotac_parid no-lock
                                        where cotac_parid.cod_indic_econ_base  = p_cod_indic_econ_base
                                          and cotac_parid.cod_indic_econ_idx   = p_cod_indic_econ_idx
                                          and cotac_parid.dat_cotac_indic_econ < p_dat_transacao
                                          and cotac_parid.ind_tip_cotac_parid  = p_ind_tip_cotac_parid
                                          and cotac_parid.val_cotac_indic_econ <> 0.0
                                          &if '{&emsuni_version}' >= '5.01' &then
                                          use-index ctcprd_id
                                          &endif
                                          no-error.
                                when "Pr¢ximo" /*l_proximo*/ then  
                                    find next cotac_parid no-lock
                                        where cotac_parid.cod_indic_econ_base  = p_cod_indic_econ_base
                                          and cotac_parid.cod_indic_econ_idx   = p_cod_indic_econ_idx
                                          and cotac_parid.dat_cotac_indic_econ > p_dat_transacao
                                          and cotac_parid.ind_tip_cotac_parid  = p_ind_tip_cotac_parid
                                          and cotac_parid.val_cotac_indic_econ <> 0.0
                                          &if '{&emsuni_version}' >= '5.01' &then
                                          use-index ctcprd_id
                                          &endif
                                          no-error.
                            end /* case block */.
                        end /* if */.
                    end /* do diaria_block */.
                when "Mensal" /*l_mensal*/ then
                    mensal_block:
                    do:
                        assign v_dat_cotac_mes = date(month(p_dat_transacao), 1, year(p_dat_transacao))
                               &if yes = yes &then 
                               v_log_indic     = yes
                               &endif .
                        find cotac_parid no-lock
                            where cotac_parid.cod_indic_econ_base  = p_cod_indic_econ_base
                              and cotac_parid.cod_indic_econ_idx   = p_cod_indic_econ_idx
                              and cotac_parid.dat_cotac_indic_econ = v_dat_cotac_mes
                              and cotac_parid.ind_tip_cotac_parid  = p_ind_tip_cotac_parid
                            use-index ctcprd_id no-error.
                        if  not avail cotac_parid or cotac_parid.val_cotac_indic_econ = 0
                        then do:
                            /* block: */
                            case parid_indic_econ.ind_criter_busca:
                                when "Anterior" /*l_anterior*/ then
                                    find prev cotac_parid no-lock
                                        where cotac_parid.cod_indic_econ_base  = p_cod_indic_econ_base
                                          and cotac_parid.cod_indic_econ_idx   = p_cod_indic_econ_idx
                                          and cotac_parid.dat_cotac_indic_econ < v_dat_cotac_mes
                                          and cotac_parid.ind_tip_cotac_parid  = p_ind_tip_cotac_parid
                                          and cotac_parid.val_cotac_indic_econ <> 0.0
                                        use-index ctcprd_id no-error.
                                when "Pr¢ximo" /*l_proximo*/ then
                                    find next cotac_parid no-lock
                                        where cotac_parid.cod_indic_econ_base  = p_cod_indic_econ_base
                                          and cotac_parid.cod_indic_econ_idx   = p_cod_indic_econ_idx
                                          and cotac_parid.dat_cotac_indic_econ > v_dat_cotac_mes
                                          and cotac_parid.ind_tip_cotac_parid  = p_ind_tip_cotac_parid
                                          and cotac_parid.val_cotac_indic_econ <> 0.0
                                        use-index ctcprd_id no-error.
                            end /* case block */.
                        end /* if */.
                    end /* do mensal_block */.
                when "Bimestral" /*l_bimestral*/ then
                    bimestral_block:
                    do:
                    end /* do bimestral_block */.
                when "Trimestral" /*l_trimestral*/ then
                    trimestral_block:
                    do:
                    end /* do trimestral_block */.
                when "Quadrimestral" /*l_quadrimestral*/ then
                    quadrimestral_block:
                    do:
                    end /* do quadrimestral_block */.
                when "Semestral" /*l_semestral*/ then
                    semestral_block:
                    do:
                    end /* do semestral_block */.
                when "Anual" /*l_anual*/ then
                    anual_block:
                    do:
                    end /* do anual_block */.
            end /* case period_block */.
            /* End_Include: i_verifica_cotac_parid */


            if  parid_indic_econ.ind_orig_cotac_parid = "Outra Moeda" /*l_outra_moeda*/  and
                 parid_indic_econ.cod_finalid_econ_orig_cotac <> "" and
                 (not avail cotac_parid or cotac_parid.val_cotac_indic_econ = 0)
            then do:
                /* Cotaá∆o Ponte */
                run pi_retornar_indic_econ_finalid (Input parid_indic_econ.cod_finalid_econ_orig_cotac,
                                                    Input p_dat_transacao,
                                                    output v_cod_indic_econ_orig) /*pi_retornar_indic_econ_finalid*/.
                find parid_indic_econ no-lock
                    where parid_indic_econ.cod_indic_econ_base = v_cod_indic_econ_orig
                    and parid_indic_econ.cod_indic_econ_idx = p_cod_indic_econ_base
                    use-index prdndccn_id no-error.
                run pi_achar_cotac_indic_econ_2 (Input v_cod_indic_econ_orig,
                                                 Input p_cod_indic_econ_base,
                                                 Input p_dat_transacao,
                                                 Input p_ind_tip_cotac_parid,
                                                 Input p_cod_indic_econ_base,
                                                 Input p_cod_indic_econ_idx) /*pi_achar_cotac_indic_econ_2*/.

                if  avail cotac_parid and cotac_parid.val_cotac_indic_econ <> 0
                then do:
                    assign v_val_cotac_indic_econ_base = cotac_parid.val_cotac_indic_econ.
                    find parid_indic_econ no-lock
                        where parid_indic_econ.cod_indic_econ_base = v_cod_indic_econ_orig
                        and parid_indic_econ.cod_indic_econ_idx = p_cod_indic_econ_idx
                        use-index prdndccn_id no-error.
                    run pi_achar_cotac_indic_econ_2 (Input v_cod_indic_econ_orig,
                                                     Input p_cod_indic_econ_idx,
                                                     Input p_dat_transacao,
                                                     Input p_ind_tip_cotac_parid,
                                                     Input p_cod_indic_econ_base,
                                                     Input p_cod_indic_econ_idx) /*pi_achar_cotac_indic_econ_2*/.

                    if  avail cotac_parid and cotac_parid.val_cotac_indic_econ <> 0
                    then do:
                        assign v_val_cotac_indic_econ_idx = cotac_parid.val_cotac_indic_econ
                               p_val_cotac_indic_econ = v_val_cotac_indic_econ_idx / v_val_cotac_indic_econ_base
                               p_dat_cotac_indic_econ = cotac_parid.dat_cotac_indic_econ
                               p_cod_return = "OK" /*l_ok*/ .
                        return.
                    end /* if */.
                end /* if */.
            end /* if */.
            if  parid_indic_econ.ind_orig_cotac_parid = "Inversa" /*l_inversa*/  and
                 (not avail cotac_parid or cotac_parid.val_cotac_indic_econ = 0)
            then do:
                find parid_indic_econ no-lock
                    where parid_indic_econ.cod_indic_econ_base = p_cod_indic_econ_idx
                    and parid_indic_econ.cod_indic_econ_idx = p_cod_indic_econ_base
                    use-index prdndccn_id no-error.
                run pi_achar_cotac_indic_econ_2 (Input p_cod_indic_econ_idx,
                                                 Input p_cod_indic_econ_base,
                                                 Input p_dat_transacao,
                                                 Input p_ind_tip_cotac_parid,
                                                 Input p_cod_indic_econ_base,
                                                 Input p_cod_indic_econ_idx) /*pi_achar_cotac_indic_econ_2*/.

                if  avail cotac_parid and cotac_parid.val_cotac_indic_econ <> 0
                then do:
                    assign p_dat_cotac_indic_econ = cotac_parid.dat_cotac_indic_econ
                           p_val_cotac_indic_econ = 1 / cotac_parid.val_cotac_indic_econ
                           p_cod_return = "OK" /*l_ok*/ .
                    return.
                end /* if */.
            end /* if */.
        end /* if */.
        if v_log_indic = yes then do:
           if  not avail cotac_parid or cotac_parid.val_cotac_indic_econ = 0
           then do:
               assign p_cod_return = "358"                 + "," +
                      p_cod_indic_econ_base   + "," +
                      p_cod_indic_econ_idx    + "," +
                      string(v_dat_cotac_mes) + "," +
                      p_ind_tip_cotac_parid.
           end /* if */.
           else do:
               assign p_dat_cotac_indic_econ = cotac_parid.dat_cotac_indic_econ
                      p_val_cotac_indic_econ = cotac_parid.val_cotac_indic_econ
                      p_cod_return           = "OK" /*l_ok*/ .
           end /* else */.
        end.
        else do:   
           if  not avail cotac_parid or cotac_parid.val_cotac_indic_econ = 0
           then do:
               assign p_cod_return = "358"                 + "," +
                      p_cod_indic_econ_base   + "," +
                      p_cod_indic_econ_idx    + "," +
                      string(p_dat_transacao) + "," +
                      p_ind_tip_cotac_parid.
           end /* if */.
           else do:
               assign p_dat_cotac_indic_econ = cotac_parid.dat_cotac_indic_econ
                      p_val_cotac_indic_econ = cotac_parid.val_cotac_indic_econ
                      p_cod_return           = "OK" /*l_ok*/ .
           end /* else */.
        end.
        assign v_log_indic = no.
    end /* else */.
END PROCEDURE. /* pi_achar_cotac_indic_econ */
/*****************************************************************************
** Procedure Interna.....: pi_achar_cotac_indic_econ_2
** Descricao.............: pi_achar_cotac_indic_econ_2
** Criado por............: src531
** Criado em.............: 29/07/2003 11:10:10
** Alterado por..........: bre17752
** Alterado em...........: 30/07/2003 12:46:24
*****************************************************************************/
PROCEDURE pi_achar_cotac_indic_econ_2:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_param_1
        as character
        format "x(8)"
        no-undo.
    def Input param p_cod_param_2
        as character
        format "x(50)"
        no-undo.
    def Input param p_dat_transacao
        as date
        format "99/99/9999"
        no-undo.
    def Input param p_ind_tip_cotac_parid
        as character
        format "X(09)"
        no-undo.
    def Input param p_cod_indic_econ_base
        as character
        format "x(8)"
        no-undo.
    def Input param p_cod_indic_econ_idx
        as character
        format "x(8)"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_dat_cotac_mes                  as date            no-undo. /*local*/


    /************************** Variable Definition End *************************/

    /* period_block: */
    case parid_indic_econ.ind_periodic_cotac:
        when "Di†ria" /*l_diaria*/ then
            diaria_block:
            do:
                find cotac_parid no-lock
                     where cotac_parid.cod_indic_econ_base = p_cod_param_1
                       and cotac_parid.cod_indic_econ_idx = p_cod_param_2
                       and cotac_parid.dat_cotac_indic_econ = p_dat_transacao
                       and cotac_parid.ind_tip_cotac_parid = p_ind_tip_cotac_parid
                     use-index ctcprd_id no-error.
                if  not avail cotac_parid or cotac_parid.val_cotac_indic_econ = 0
                then do:
                    find parid_indic_econ no-lock
                         where parid_indic_econ.cod_indic_econ_base = p_cod_param_1
                           and parid_indic_econ.cod_indic_econ_idx = p_cod_param_2
                         use-index prdndccn_id no-error.
                    /* block: */
                    case parid_indic_econ.ind_criter_busca:
                        when "Anterior" /*l_anterior*/ then find prev cotac_parid no-lock
                              where cotac_parid.cod_indic_econ_base = p_cod_indic_econ_base
                                and cotac_parid.cod_indic_econ_idx = p_cod_indic_econ_idx
                                and cotac_parid.dat_cotac_indic_econ < p_dat_transacao
                                and cotac_parid.ind_tip_cotac_parid = p_ind_tip_cotac_parid
                                and cotac_parid.val_cotac_indic_econ <> 0.0
    &if "{&emsuni_version}" >= "5.01" &then
                              use-index ctcprd_id
    &endif
                               /*cl_acha_cotac_anterior of cotac_parid*/ no-error.
                        when "Pr¢ximo" /*l_proximo*/ then  find next cotac_parid no-lock
                               where cotac_parid.cod_indic_econ_base = p_cod_indic_econ_base
                                 and cotac_parid.cod_indic_econ_idx = p_cod_indic_econ_idx
                                 and cotac_parid.dat_cotac_indic_econ > p_dat_transacao
                                 and cotac_parid.ind_tip_cotac_parid = p_ind_tip_cotac_parid
                                 and cotac_parid.val_cotac_indic_econ <> 0.0
    &if "{&emsuni_version}" >= "5.01" &then
                               use-index ctcprd_id
    &endif
                                /*cl_acha_cotac_posterior of cotac_parid*/ no-error.
                    end /* case block */.
                end /* if */.
            end /* do diaria_block */.
        when "Mensal" /*l_mensal*/ then
            mensal_block:
            do:
                assign v_dat_cotac_mes = date(month(p_dat_transacao), 1, year(p_dat_transacao)).
                find cotac_parid no-lock
                     where cotac_parid.cod_indic_econ_base = p_cod_param_1
                       and cotac_parid.cod_indic_econ_idx = p_cod_param_2
                       and cotac_parid.dat_cotac_indic_econ = v_dat_cotac_mes
                       and cotac_parid.ind_tip_cotac_parid = p_ind_tip_cotac_parid
                     use-index ctcprd_id no-error.
                if  not avail cotac_parid or cotac_parid.val_cotac_indic_econ = 0
                then do:
                    /* block: */
                    case parid_indic_econ.ind_criter_busca:
                        when "Anterior" /*l_anterior*/ then
                        find prev cotac_parid no-lock
                                           where cotac_parid.cod_indic_econ_base = p_cod_param_1
                                             and cotac_parid.cod_indic_econ_idx = p_cod_param_2
                                             and cotac_parid.dat_cotac_indic_econ < v_dat_cotac_mes
                                             and cotac_parid.ind_tip_cotac_parid = p_ind_tip_cotac_parid
                                             and cotac_parid.val_cotac_indic_econ <> 0.0
                                           use-index ctcprd_id no-error.
                        when "Pr¢ximo" /*l_proximo*/ then
                        find next cotac_parid no-lock
                                           where cotac_parid.cod_indic_econ_base = p_cod_param_1
                                             and cotac_parid.cod_indic_econ_idx = p_cod_param_2
                                             and cotac_parid.dat_cotac_indic_econ > v_dat_cotac_mes
                                             and cotac_parid.ind_tip_cotac_parid = p_ind_tip_cotac_parid
                                             and cotac_parid.val_cotac_indic_econ <> 0.0
                                           use-index ctcprd_id no-error.
                    end /* case block */.
                end /* if */.
            end /* do mensal_block */.
        when "Bimestral" /*l_bimestral*/ then
            bimestral_block:
            do:
            end /* do bimestral_block */.
        when "Trimestral" /*l_trimestral*/ then
            trimestral_block:
            do:
            end /* do trimestral_block */.
        when "Quadrimestral" /*l_quadrimestral*/ then
            quadrimestral_block:
            do:
            end /* do quadrimestral_block */.
        when "Semestral" /*l_semestral*/ then
            semestral_block:
            do:
            end /* do semestral_block */.
        when "Anual" /*l_anual*/ then
            anual_block:
            do:
            end /* do anual_block */.
    end /* case period_block */.
END PROCEDURE. /* pi_achar_cotac_indic_econ_2 */
