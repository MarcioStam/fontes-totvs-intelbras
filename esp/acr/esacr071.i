/*------------------------------------------------------------------------------
  Retornar o dia £til a partir de uma data     
------------------------------------------------------------------------------*/
PROCEDURE pi_retornar_dia_util :
    DEF  INPUT  PARAM p_cod_pais_fornec_clien AS  CHAR NO-UNDO.
    DEF  INPUT  PARAM p_cod_estab             AS  CHARACTER format "x(5)" NO-UNDO.
    DEF  INPUT  PARAM p_ind_tip_calend        AS  CHARACTER format "X(08)" NO-UNDO.
    DEF  INPUT  PARAM p_num_dias              AS  INTEGER format ">>>>,>>9" NO-UNDO. 
    DEF  INPUT  PARAM p_dat_base              AS  DATE format "99/99/9999"  NO-UNDO. 
    DEF  OUTPUT PARAM p_dat_return            AS  DATE format "99/99/9999" NO-UNDO. 
    DEF  OUTPUT PARAM p_cod_return            AS  CHARACTER format "x(40)" NO-UNDO.
 
    def var v_log_fer as LOGICAL format "Sim/N∆o" initial NO NO-UNDO. 
    def var v_num_seq as INTEGER format ">>>,>>9":U label "SeqÅància" column-label "Seq" NO-UNDO.

    ASSIGN p_cod_return = "OK" .

    FIND estabelecimento
        WHERE estabelecimento.cod_estab = p_cod_estab NO-LOCK NO-ERROR.
    
    CASE p_ind_tip_calend:
        WHEN "Respons†vel Financeiro" then
            FIND calend_glob
                WHERE calend_glob.cod_calend = estabelecimento.cod_calend_financ
                NO-LOCK NO-ERROR.
        WHEN "Materiais"  then
            FIND calend_glob
                WHERE calend_glob.cod_calend = estabelecimento.cod_calend_mater
                NO-LOCK NO-ERROR.
        WHEN "R.H."  then
            FIND calend_glob
                WHERE calend_glob.cod_calend = estabelecimento.cod_calend_rh
                NO-LOCK NO-ERROR.
        WHEN "Manufatura"  then
            FIND calend_glob
                WHERE calend_glob.cod_calend = estabelecimento.cod_calend_manuf
                NO-LOCK NO-ERROR.
        WHEN "Distribuiá∆o"  then
            FIND calend_glob
                WHERE calend_glob.cod_calend = estabelecimento.cod_calend_distrib
                NO-LOCK NO-ERROR.
    END.
    IF NOT AVAIL calend_glob THEN DO:
        ASSIGN p_cod_return = "3896".
        RETURN.
    END.

    ASSIGN p_dat_return = p_dat_base.

    if  p_num_dias = 0 then do:
        acha_dia_util:
        repeat:
            FIND dia_calend_glob
                WHERE dia_calend_glob.cod_calend = calend_glob.cod_calend
                and   dia_calend_glob.dat_calend = p_dat_return
                NO-LOCK NO-ERROR.
            if  not avail dia_calend_glob
            then do:
                ASSIGN p_cod_return = "3897" + "," + string(p_dat_return) + "," + calend_glob.cod_calend.
                return.
            end .

            if  dia_calend_glob.log_dia_util = yes then do:
                ASSIGN v_log_fer = no.
                for each fer_nac NO-LOCK
                    WHERE fer_nac.cod_pais     = p_cod_pais_fornec_clien
                      and fer_nac.dat_fer_nac  = p_dat_return:
                      ASSIGN v_log_fer = yes.
                end.
                if not v_log_fer then
                    leave acha_dia_util.
                else ASSIGN p_dat_return = p_dat_return + 1.
            end.

            else do:
                ASSIGN p_dat_return = p_dat_return + 1.
            END.
        end .
    end .
    else do:
        dias_block:
        do v_num_seq = 1 to p_num_dias:
            ASSIGN p_dat_return = p_dat_return + 1.
            acha_dia_util:
            repeat:
                FIND dia_calend_glob
                    WHERE dia_calend_glob.cod_calend = calend_glob.cod_calend
                    and   dia_calend_glob.dat_calend = p_dat_return
                    NO-LOCK NO-ERROR.
                if  not avail dia_calend_glob
                then do:
                    ASSIGN p_cod_return = "3897" + "," + string(p_dat_return) + "," + calend_glob.cod_calend.
                    return.
                end /* if */.

                if  dia_calend_glob.log_dia_util = yes then do:
                    ASSIGN v_log_fer = no.
                    for each fer_nac NO-LOCK
                        WHERE fer_nac.cod_pais     = p_cod_pais_fornec_clien
                          and fer_nac.dat_fer_nac  = p_dat_return:
                          ASSIGN v_log_fer = yes.
                    end.
                    if not v_log_fer then
                        leave acha_dia_util.
                    else ASSIGN p_dat_return = p_dat_return + 1.
                end.

                else do:
                    ASSIGN p_dat_return = p_dat_return + 1.
                end /* else */.
            end /* repeat acha_dia_util */.
        end /* do dias_block */.
    end /* else */.

END PROCEDURE.
