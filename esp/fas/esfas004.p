/*****************************************************************************
** Programa..............: esp/fas/esafas004.p
** Autor.................: Fabiano Zarpe Henke
** Criado em.............: 27/03/2009
*****************************************************************************/

DEF VAR v_cod_plano_cta_ctbl AS CHAR.
DEF VAR v_cod_cta_ctbl       AS CHAR.
DEF VAR v_cod_plano_ccusto   AS CHAR.
DEF VAR v_cod_ccusto         AS CHAR.
DEF VAR v_cod_unid_negoc     AS CHAR.
DEF VAR v_log_val_cta        AS LOG.    
DEF VAR v_log_return         AS LOG.

DEF VAR v_cod_arq AS CHAR NO-UNDO.

DEFINE VARIABLE v_log_method AS LOGICAL NO-UNDO.

MESSAGE "Confirma valida‡Æo do Seguro ?"
        VIEW-AS ALERT-BOX  QUESTION BUTTONS YES-NO TITLE "Pr‚via Seguro" UPDATE choice AS LOGICAL.

IF CHOICE = NO 
THEN DO: 
     RETURN.
END.

ASSIGN v_log_method = SESSION:SET-WAIT-STATE("General").

ASSIGN v_cod_arq = session:temp-directory + "esfas004.txt".

OUTPUT TO VALUE(v_cod_arq).

PUT UNFORMATTED "Bem;Seq;Erro" SKIP.

FOR EACH apol_seguro NO-LOCK:
    IF apol_seguro.ind_tip_apol_seguro = "Por µrea Risco"
    THEN DO:
         FOR EACH area_risco NO-LOCK
            WHERE area_risco.cod_apol_seguro = apol_seguro.cod_apol_seguro
              AND area_risco.cod_seguradora  = apol_seguro.cod_seguradora:
            FOR EACH bem_pat NO-LOCK
               WHERE bem_pat.cod_estab   = area_risco.cod_estab
                 AND bem_pat.cod_localiz = area_risco.cod_localiz:
               RUN pi_valida_aloc.
            END.
         END.
    END.
    ELSE DO:
         FOR EACH apol_seguro_bem_pat NO-LOCK
            WHERE apol_seguro_bem_pat.cod_apol_seguro = apol_seguro.cod_apol_seguro
              AND apol_seguro_bem_pat.cod_seguradora  = apol_seguro.cod_seguradora:
            FIND FIRST bem_pat NO-LOCK 
                 WHERE bem_pat.num_id_bem_pat = apol_seguro_bem_pat.num_id_bem_pat NO-ERROR.
            RUN pi_valida_aloc.
         END.
    END.
END.

OUTPUT CLOSE.

ASSIGN v_log_method = session:SET-WAIT-STATE("").

MESSAGE "Processo Finalizado!"
    VIEW-AS ALERT-BOX INFO BUTTONS OK.

RUN pi_show_report_2 (INPUT v_cod_arq).

PROCEDURE pi_valida_aloc:

    /* ** Verificar se o bem foi baixado ***/
    find last val_origin_bem_pat NO-LOCK
         where val_origin_bem_pat.num_id_bem_pat         = bem_pat.num_id_bem_pat
           and val_origin_bem_pat.num_seq_incorp_bem_pat = 0
           and val_origin_bem_pat.cod_cenar_ctbl         = "fiscal"
           and val_origin_bem_pat.cod_finalid_econ       = "corrente"
         use-index vlrgbmp_id no-error.
    if not avail val_origin_bem_pat 
       then RETURN.
    if val_origin_bem_pat.val_original = 0 
    then do:
        find movto_bem_pat no-lock
            where movto_bem_pat.num_id_bem_pat         = bem_pat.num_id_bem_pat
            and   movto_bem_pat.num_seq_incorp_bem_pat = 0
            and   movto_bem_pat.num_seq_movto_bem_pat  = val_origin_bem_pat.num_seq_movto_bem_pat
            and   movto_bem_pat.dat_movto_bem_pat      = val_origin_bem_pat.dat_calc_pat no-error.
        if  avail movto_bem_pat 
        and movto_bem_pat.ind_trans_calc_bem_pat = "Baixa" /*l_baixa*/  
        then do:
             if movto_bem_pat.dat_movto_bem_pat < TODAY 
                then RETURN.
             find last val_origin_bem_pat NO-LOCK
                 where val_origin_bem_pat.num_id_bem_pat         = bem_pat.num_id_bem_pat
                   and val_origin_bem_pat.num_seq_incorp_bem_pat = 0
                   and val_origin_bem_pat.cod_cenar_ctbl         = "fiscal"
                   and val_origin_bem_pat.cod_finalid_econ       = "corrente"
                   and val_origin_bem_pat.dat_calc_pat           < movto_bem_pat.dat_movto_bem_pat
                 use-index vlrgbmp_id no-error.
            if not avail val_origin_bem_pat 
               then RETURN.
        end.
    end.
    /* ** Fim verifica‡Æo da Baixa ***/

    FIND cta_pat NO-LOCK 
         WHERE cta_pat.cod_empresa = bem_pat.cod_empresa
           AND cta_pat.cod_cta_pat = bem_pat.cod_cta_pat NO-ERROR.

    FIND FIRST param_ctbz_cta_pat NO-LOCK 
         WHERE param_ctbz_cta_pat.cod_empresa       = bem_pat.cod_empresa
           AND param_ctbz_cta_pat.cod_cta_pat       = cta_pat.cod_cta_pat
           AND param_ctbz_cta_pat.cod_cenar_ctbl    = 'FISCAL'
           AND param_ctbz_cta_pat.cod_finalid_econ  = 'Corrente'
           AND param_ctbz_cta_pat.ind_finalid_ctbl  = 'Seguros'
           AND param_ctbz_cta_pat.dat_inic_valid   <= TODAY
           AND param_ctbz_cta_pat.dat_fim_valid     > TODAY NO-ERROR. 

    FOR EACH aloc_bem NO-LOCK 
       WHERE aloc_bem.num_id_bem_pat  = bem_pat.num_id_bem_pat
         AND aloc_bem.dat_inic_valid <= TODAY
         AND aloc_bem.dat_fim_valid   > TODAY
         AND aloc_bem.val_perc_aprop <> 0:

       ASSIGN v_cod_plano_cta_ctbl  = param_ctbz_cta_pat.cod_plano_cta_ctbl
              v_cod_cta_ctbl        = param_ctbz_cta_pat.cod_cta_ctbl_db
              v_cod_plano_ccusto    = aloc_bem.cod_plano_ccusto
              v_cod_ccusto          = aloc_bem.cod_ccusto
              v_cod_unid_negoc      = aloc_bem.cod_unid_negoc.

       /*PUT UNFORMATTED bem_pat.num_bem_pat ";" bem_pat.num_seq ";" v_cod_plano_cta_ctbl " " v_cod_cta_ctbl " " v_cod_plano_ccusto " " v_cod_ccusto " " v_cod_unid_negoc SKIP.*/

       RUN pi_validar_cta_ctbl_ccusto_aprop_pat.

       RUN pi_valida_cta_ctbl (INPUT v_cod_plano_cta_ctbl,
                               INPUT v_cod_cta_ctbl,
                               INPUT TODAY,
                               OUTPUT v_log_val_cta).
       RUN pi_validar_ccusto(INPUT bem_pat.cod_empresa, 
                             INPUT v_cod_plano_ccusto,
                             INPUT v_cod_ccusto,
                             INPUT TODAY,
                             INPUT TODAY,
                             OUTPUT v_log_return).

    END.
END.

PROCEDURE pi_validar_cta_ctbl_ccusto_aprop_pat:

    /************************* Variable Definition Begin ************************/

    def var v_log_return                     as logical         no-undo. /*local*/
    def var v_num_mensagem                   as integer         no-undo. /*local*/
    DEF VAR v_cod_return                     AS CHAR.

    /************************** Variable Definition End *************************/

    if  v_cod_plano_ccusto <> "" and v_cod_ccusto <> ""
    then do:
        run pi_validar_cta_ctbl_distrib_ccusto_1 (Input bem_pat.cod_empresa,
                                                  Input bem_pat.cod_estab,
                                                  Input v_cod_plano_cta_ctbl,
                                                  Input v_cod_cta_ctbl,
                                                  Input v_cod_plano_ccusto,
                                                  Input v_cod_ccusto,
                                                  Input TODAY,
                                                  output v_log_return,
                                                  output v_cod_return) /*pi_validar_cta_ctbl_distrib_ccusto_1*/.
        if  v_log_return <> yes
        then do:
            PUT UNFORMATTED bem_pat.num_bem_pat ";" bem_pat.num_seq ";" "3347 " v_cod_cta_ctbl " " v_cod_ccusto SKIP.
            return "NOK".
        end /* if */.
        if trim(v_cod_return) = "NÆo Utiliza" /*l_nao_utiliza*/  then 
            assign v_cod_plano_ccusto = ''
                   v_cod_ccusto = ''.

        run pi_validar_ccusto_unid_negoc_estab (Input bem_pat.cod_empresa,
                                                Input v_cod_plano_ccusto,
                                                Input v_cod_ccusto,
                                                Input v_cod_unid_negoc,
                                                Input bem_pat.cod_estab,
                                                output v_num_mensagem) /*pi_validar_ccusto_unid_negoc_estab*/.

        if v_num_mensagem = 950 then
            assign v_num_mensagem = 13431.                                           

        /* error_block: */
        case v_num_mensagem:
           when 950 then
            erro_950:
            do:
                PUT UNFORMATTED bem_pat.num_bem_pat ";" bem_pat.num_seq ";" "950 " v_cod_unid_negoc " " bem_pat.cod_estab SKIP.
                return "NOK" /*l_nok*/ .
            end /* do erro_950 */.
           when 13431 then
            erro_13431:
            do:
                PUT UNFORMATTED bem_pat.num_bem_pat ";" bem_pat.num_seq ";" "13431 " v_cod_unid_negoc " " bem_pat.cod_estab SKIP.
                return "NOK" /*l_nok*/ .
            end /* do erro_13431 */.
           when 1253 then
            erro_1253:
            do:
                PUT UNFORMATTED bem_pat.num_bem_pat ";" bem_pat.num_seq ";" "1253 " v_cod_ccusto " " v_cod_unid_negoc SKIP.
                return "NOK" /*l_nok*/ .
            end /* do erro_1253 */.
           when 1388 then
            erro_1388:
            do:
                PUT UNFORMATTED bem_pat.num_bem_pat ";" bem_pat.num_seq ";" "5729 " v_cod_ccusto " " bem_pat.cod_estab SKIP.
                return "NOK" /*l_nok*/ .
            end /* do erro_1388 */.
       end /* case error_block */.
    end /* if */.

    return "OK" /*l_ok*/ .

END PROCEDURE.


/*****************************************************************************
** Procedure Interna.....: pi_validar_cta_ctbl_distrib_ccusto_1
** Descricao.............: pi_validar_cta_ctbl_distrib_ccusto_1
** Criado por............: src12337
** Criado em.............: 28/02/2002 14:21:46
** Alterado por..........: src12337
** Alterado em...........: 28/02/2002 14:59:29
*****************************************************************************/
PROCEDURE pi_validar_cta_ctbl_distrib_ccusto_1:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_empresa
        as character
        format "x(3)"
        no-undo.
    def Input param p_cod_estab
        as character
        format "x(3)"
        no-undo.
    def Input param p_cod_plano_cta_ctbl
        as character
        format "x(8)"
        no-undo.
    def Input param p_cod_cta_ctbl
        as character
        format "x(20)"
        no-undo.
    def Input param p_cod_plano_ccusto
        as character
        format "x(8)"
        no-undo.
    def Input param p_cod_ccusto
        as Character
        format "x(11)"
        no-undo.
    def Input param p_dat_refer_ent
        as date
        format "99/99/9999"
        no-undo.
    def output param p_log_return
        as logical
        format "Sim/NÆo"
        no-undo.
    def output param p_cod_return
        as character
        format "x(40)"
        no-undo.


    /************************* Parameter Definition End *************************/

    assign p_log_return = no
           p_cod_return = ''.
    if  p_dat_refer_ent = ?
    then do:
        find last criter_distrib_cta_ctbl no-lock
             where criter_distrib_cta_ctbl.cod_plano_cta_ctbl = p_cod_plano_cta_ctbl
               and criter_distrib_cta_ctbl.cod_cta_ctbl = p_cod_cta_ctbl
               and criter_distrib_cta_ctbl.cod_estab = p_cod_estab /* cl_verificar_cta_ctbl_utiliz_ccusto of criter_distrib_cta_ctbl*/ no-error.
    end /* if */.
    else do:
        find first criter_distrib_cta_ctbl no-lock
             where criter_distrib_cta_ctbl.cod_plano_cta_ctbl = p_cod_plano_cta_ctbl
               and criter_distrib_cta_ctbl.cod_cta_ctbl = p_cod_cta_ctbl
               and criter_distrib_cta_ctbl.cod_estab = p_cod_estab
               and criter_distrib_cta_ctbl.dat_inic_valid <= p_dat_refer_ent
               and criter_distrib_cta_ctbl.dat_fim_valid > p_dat_refer_ent /* cl_verificar_cta_ctbl_utiliz_ccusto_dat of criter_distrib_cta_ctbl*/ no-error.
    end /* else */.

    if  not avail criter_distrib_cta_ctbl
    then do:
       assign p_log_return = yes
              p_cod_return = "NÆo Utiliza" /*l_nao_utiliza*/ .    
       return.
    end /* if */.
    if  (avail plano_ccusto) and
         plano_ccusto.cod_empresa = p_cod_empresa and
         plano_ccusto.cod_plano_ccusto = p_cod_plano_ccusto
    then do:
    end /* if */.
    else do:
      find plano_ccusto no-lock
           where plano_ccusto.cod_empresa = p_cod_empresa
             and plano_ccusto.cod_plano_ccusto = p_cod_plano_ccusto /* cl_valida_plano of plano_ccusto*/ no-error.
      if  avail plano_ccusto
      then do:
      end /* if */.
      else do:
         return.
      end /* else */.
    end /* else */.
    if  criter_distrib_cta_ctbl.ind_criter_distrib_ccusto = "NÆo Utiliza" /*l_nao_utiliza*/ 
    then do:
        assign p_log_return = yes
               p_cod_return = "NÆo Utiliza" /*l_nao_utiliza*/ .
        return.
    end /* if */.
    if  criter_distrib_cta_ctbl.ind_criter_distrib_ccusto = "Utiliza Todos" /*l_utiliza_todos*/ 
    then do:
        if  (p_cod_plano_ccusto <> ?
        and   p_cod_plano_ccusto <> "")
        then do:
            assign p_log_return = yes.
            return.
        end /* if */.
        else do:
            return.
        end /* else */.
    end /* if */.
    if  criter_distrib_cta_ctbl.ind_criter_distrib_ccusto = "Definidos" /*l_definidos*/ 
    then do:
        if  (p_cod_plano_ccusto = ?
        or    p_cod_plano_ccusto = "")
        then do:
            return.
        end /* if */.
        find mapa_distrib_ccusto no-lock
             where mapa_distrib_ccusto.cod_estab = criter_distrib_cta_ctbl.cod_estab
               and mapa_distrib_ccusto.cod_mapa_distrib_ccusto = criter_distrib_cta_ctbl.cod_mapa_distrib_ccusto
              no-error.
        if  p_dat_refer_ent <> ? and
           (p_dat_refer_ent <  mapa_distrib_ccusto.dat_inic_valid   or
            p_dat_refer_ent >= mapa_distrib_ccusto.dat_fim_valid)
        then do:
            return.
        end /* if */.
        find item_lista_ccusto no-lock
             where item_lista_ccusto.cod_estab = p_cod_estab
               and item_lista_ccusto.cod_mapa_distrib_ccusto = mapa_distrib_ccusto.cod_mapa_distrib_ccusto
               and item_lista_ccusto.cod_empresa = p_cod_empresa
               and item_lista_ccusto.cod_plano_ccusto = p_cod_plano_ccusto
               and item_lista_ccusto.cod_ccusto = p_cod_ccusto /* cl_validar_cta_ctbl_distrib_ccusto of item_lista_ccusto*/ no-error.
        if  not avail item_lista_ccusto
        then do:
            return.
        end /* if */.
        else do:
            assign p_log_return = yes.
        end /* else */.
    end /* if */.
END PROCEDURE. /* pi_validar_cta_ctbl_distrib_ccusto_1 */

/*****************************************************************************
** Procedure Interna.....: pi_validar_ccusto_unid_negoc_estab
** Descricao.............: pi_validar_ccusto_unid_negoc_estab
** Criado por............: Henke
** Criado em.............: // 
** Alterado por..........: Rafael
** Alterado em...........: 21/08/1997 15:17:43
*****************************************************************************/
PROCEDURE pi_validar_ccusto_unid_negoc_estab:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_empresa
        as character
        format "x(3)"
        no-undo.
    def Input param p_cod_plano_ccusto
        as character
        format "x(8)"
        no-undo.
    def Input param p_cod_ccusto
        as Character
        format "x(11)"
        no-undo.
    def Input param p_cod_unid_negoc
        as character
        format "x(3)"
        no-undo.
    def Input param p_cod_estab
        as character
        format "x(3)"
        no-undo.
    def output param p_num_mensagem
        as integer
        format ">>>>,>>9"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_cod_ccusto_000
        as Character
        format "x(11)":U
        label "Centro Custo"
        column-label "Centro Custo"
        no-undo.


    /************************** Variable Definition End *************************/

    if  p_cod_estab <> "" and
        p_cod_unid_negoc <> ""
    then do:
        find estab_unid_negoc no-lock
             where estab_unid_negoc.cod_estab = p_cod_estab
               and estab_unid_negoc.cod_unid_negoc = p_cod_unid_negoc /*cl_valida_unid_negoc of estab_unid_negoc*/ no-error.
        if  not avail estab_unid_negoc
        then do:
            assign p_num_mensagem = 950.
            return.
        end /* if */.
    end /* if */.
    if  avail plano_ccusto and
        plano_ccusto.cod_plano_ccusto = p_cod_plano_ccusto and
        plano_ccusto.cod_empresa = p_cod_empresa
    then do:
        run pi_retornar_ccusto_inic (Input plano_ccusto.cod_format_ccusto,
                                     output v_cod_ccusto_000) /*pi_retornar_ccusto_inic*/.
    end /* if */.
    else do:
        if  p_cod_plano_ccusto <> ""
        then do:
           find plano_ccusto no-lock
                where plano_ccusto.cod_empresa = p_cod_empresa
                  and plano_ccusto.cod_plano_ccusto = p_cod_plano_ccusto /*cl_valida_plano of plano_ccusto*/ no-error.
           if  avail plano_ccusto
           then do:
              run pi_retornar_ccusto_inic (Input plano_ccusto.cod_format_ccusto,
                                           output v_cod_ccusto_000) /*pi_retornar_ccusto_inic*/.
           end /* if */.
           else do:
              assign v_cod_ccusto_000 = "".
           end /* else */.
        end /* if */.
        else do:
           assign v_cod_ccusto_000 = "".
        end /* else */.
    end /* else */.
    if  p_cod_plano_ccusto <> "" and
        p_cod_ccusto       <> v_cod_ccusto_000 and
        p_cod_unid_negoc   <> ""
    then do:
        find ccusto_unid_negoc no-lock
             where ccusto_unid_negoc.cod_empresa = p_cod_empresa
               and ccusto_unid_negoc.cod_plano_ccusto = p_cod_plano_ccusto
               and ccusto_unid_negoc.cod_ccusto = p_cod_ccusto
               and ccusto_unid_negoc.cod_unid_negoc = p_cod_unid_negoc /*cl_validar_ccusto_unid_negoc_estab of ccusto_unid_negoc*/ no-error.
        if  not avail ccusto_unid_negoc
        then do:
            assign p_num_mensagem = 1253.
            return.
        end /* if */.
    end /* if */.
    if  p_cod_plano_ccusto <> "" and
        p_cod_ccusto       <> v_cod_ccusto_000 and
        p_cod_estab        <> ""
    then do:
        find restric_ccusto no-lock
             where restric_ccusto.cod_empresa = p_cod_empresa
               and restric_ccusto.cod_plano_ccusto = p_cod_plano_ccusto
               and restric_ccusto.cod_ccusto = p_cod_ccusto
               and restric_ccusto.cod_estab = p_cod_estab /*cl_validar_ccusto_unid_negoc_estab of restric_ccusto*/ no-error.
        if  avail restric_ccusto
        then do:
            assign p_num_mensagem = 1388.
            return.
        end /* if */.
    end /* if */.
    assign p_num_mensagem = 0.
END PROCEDURE. /* pi_validar_ccusto_unid_negoc_estab */

/*****************************************************************************
** Procedure Interna.....: pi_retornar_ccusto_inic
** Descricao.............: pi_retornar_ccusto_inic
** Criado por............: pasold
** Criado em.............: 26/08/1996 14:12:15
** Alterado por..........: bre18473
** Alterado em...........: 17/02/2000 09:58:41
*****************************************************************************/
PROCEDURE pi_retornar_ccusto_inic:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_format_ccusto
        as character
        format "x(11)"
        no-undo.
    def output param p_cod_ccusto_000
        as Character
        format "x(11)"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_cod_ccusto_000
        as Character
        format "x(11)":U
        label "Centro Custo"
        column-label "Centro Custo"
        no-undo.
    def var v_num_count
        as integer
        format ">>>>,>>9":U
        no-undo.


    /************************** Variable Definition End *************************/

    assign v_num_count = 1.
           v_cod_ccusto_000 = "".

    contador:
    do while v_num_count <= length(p_cod_format_ccusto):
        if  substring(p_cod_format_ccusto,v_num_count,1) <> "-"
        and substring(p_cod_format_ccusto,v_num_count,1) <> ","
        and substring(p_cod_format_ccusto,v_num_count,1) <> "."
        then do:
            if  substring(p_cod_format_ccusto,v_num_count,1) = "!"
            then do:
                assign v_cod_ccusto_000 = v_cod_ccusto_000 + keylabel(65).
            end /* if */.
            else do:
                if  substring(p_cod_format_ccusto,v_num_count,1) = "9"
                or  substring(p_cod_format_ccusto,v_num_count,1) = "x" /*l_X*/ 
                then do:
                    assign v_cod_ccusto_000 = v_cod_ccusto_000 + "0".
                end /* if */.
                else do:
                    assign v_cod_ccusto_000 = v_cod_ccusto_000 + keylabel(32).
                end /* else */.
            end /* else */.
        end /* if */.
        assign v_num_count = v_num_count + 1.
    end /* do contador */.
    assign p_cod_ccusto_000 = v_cod_ccusto_000.
    return 'OK'.
END PROCEDURE. /* pi_retornar_ccusto_inic */

/*****************************************************************************
** Procedure Interna.....: pi_valida_cta_ctbl
** Descricao.............: pi_valida_cta_ctbl
** Criado por............: 
** Criado em.............: // 
** Alterado por..........: veber
** Alterado em...........: 01/08/1997 14:33:24
*****************************************************************************/
PROCEDURE pi_valida_cta_ctbl:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_plano_cta_ctbl
        as character
        format "x(8)"
        no-undo.
    def Input param p_cod_cta_ctbl
        as character
        format "x(20)"
        no-undo.
    def Input param p_dat_refer
        as date
        format "99/99/9999"
        no-undo.
    def output param p_log_cta_ctbl_val
        as logical
        format "Sim/NÆo"
        no-undo.


    /************************* Parameter Definition End *************************/

    assign p_log_cta_ctbl_val = no.
    find cta_ctbl no-lock
         where cta_ctbl.cod_plano_cta_ctbl = p_cod_plano_cta_ctbl
           and cta_ctbl.cod_cta_ctbl = p_cod_cta_ctbl /*cl_valida_cta_ctbl of cta_ctbl*/ no-error.
    if  avail cta_ctbl
    then do:
        find plano_cta_ctbl no-lock
             where plano_cta_ctbl.cod_plano_cta_ctbl = cta_ctbl.cod_plano_cta_ctbl
              no-error.
        if  avail plano_cta_ctbl
        then do:
            if  p_dat_refer = ? or (plano_cta_ctbl.dat_inic_valid <= p_dat_refer and
                plano_cta_ctbl.dat_fim_valid  > p_dat_refer and
                cta_ctbl.dat_inic_valid <= p_dat_refer and
                cta_ctbl.dat_fim_valid  >  p_dat_refer)
            then do:
                assign p_log_cta_ctbl_val = yes.
            end /* if */.
        end /* if */.
    end /* if */.
END PROCEDURE. /* pi_valida_cta_ctbl */

/*****************************************************************************
** Procedure Interna.....: pi_validar_ccusto
** Descricao.............: pi_validar_ccusto
** Criado por............: 
** Criado em.............: // 
** Alterado por..........: Puccini
** Alterado em...........: 16/10/1998 10:09:15
*****************************************************************************/
PROCEDURE pi_validar_ccusto:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_empresa
        as character
        format "x(3)"
        no-undo.
    def Input param p_cod_plano_ccusto
        as character
        format "x(8)"
        no-undo.
    def Input param p_cod_ccusto
        as Character
        format "x(11)"
        no-undo.
    def Input param p_dat_inic_valid
        as date
        format "99/99/9999"
        no-undo.
    def Input param p_dat_fim_valid
        as date
        format "99/99/9999"
        no-undo.
    def output param p_log_return
        as logical
        format "Sim/NÆo"
        no-undo.


    /************************* Parameter Definition End *************************/

    p_log_return = no.
    find first emscad.ccusto no-lock
         where ccusto.cod_empresa      = p_cod_empresa
           and ccusto.cod_plano_ccusto = p_cod_plano_ccusto
           and ccusto.cod_ccusto       = p_cod_ccusto no-error.
    if  not avail ccusto
    then do:
        return.
    end /* if */.
    find first plano_ccusto no-lock
         where plano_ccusto.cod_empresa = ccusto.cod_empresa
           and plano_ccusto.cod_plano_ccusto = ccusto.cod_plano_ccusto
          no-error.
    if  p_dat_inic_valid <> ? and p_dat_fim_valid <> ?
    then do:
        if  not(ccusto.dat_inic_valid <= p_dat_inic_valid
        and ccusto.dat_fim_valid  >= p_dat_fim_valid)
        then do:
            return.
        end /* if */.
        if  not(plano_ccusto.dat_inic_valid <= p_dat_inic_valid
        and plano_ccusto.dat_fim_valid >= p_dat_fim_valid)
        then do:
            return.
        end /* if */.
    end /* if */.
    if  p_dat_inic_valid <> ? and p_dat_fim_valid = ?
    then do:
        if  not ccusto.dat_inic_valid <= p_dat_inic_valid
        or  not ccusto.dat_fim_valid >= p_dat_inic_valid
        then do:
            return.
        end /* if */.
        if  not plano_ccusto.dat_inic_valid <= p_dat_inic_valid
        then do:
            return.
        end /* if */.
    end /* if */.
    if  p_dat_inic_valid = ? and p_dat_fim_valid <> ?
    then do:
        if  not ccusto.dat_fim_valid >= p_dat_fim_valid
        then do:
            return.
        end /* if */.
        if  not plano_ccusto.dat_fim_valid >= p_dat_fim_valid
        then do:
            return.
        end /* if */.
    end /* if */.
    assign p_log_return = yes.
END PROCEDURE. /* pi_validar_ccusto */

PROCEDURE pi_show_report_2:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_dwb_file
        as character
        format "x(40)"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_cod_key_value
        as character
        format "x(8)":U
        no-undo.


    /************************** Variable Definition End *************************/

    get-key-value section 'EMS' key 'Show-Report-Program' value v_cod_key_value.
    if  v_cod_key_value = ""
    or   v_cod_key_value = ?
    then do:
        assign v_cod_key_value = 'notepad.exe'.
        put-key-value section 'EMS' key 'Show-Report-Program' value v_cod_key_value no-error.
    end /* if */.

    run winexec (input v_cod_key_value + chr(32) + p_cod_dwb_file, input 1).

    END PROCEDURE.

    PROCEDURE WinExec EXTERNAL 'kernel32.dll':
      DEF INPUT  PARAM prg_name                          AS CHARACTER.
      DEF INPUT  PARAM prg_style                         AS SHORT.

END PROCEDURE.
