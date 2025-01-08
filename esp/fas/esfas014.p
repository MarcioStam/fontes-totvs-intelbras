/*****************************************************************************
** Programa..............: esp/fas/esafas014.p
** Autor.................: Fabiano Zarpe Henke
** Criado em.............: 30/06/2014
*****************************************************************************/

def new global shared var v_cod_empres_usuar
    as character
    format "x(3)":U
    label "Empresa"
    column-label "Empresa"
    no-undo.

DEFINE VARIABLE v_cod_arq    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v_log_method AS LOGICAL NO-UNDO.

MESSAGE "Confirma gera‡Æo do Cronograma de C lculo?"
        VIEW-AS ALERT-BOX  QUESTION BUTTONS YES-NO TITLE "Cronograma C lculo" UPDATE choice AS LOGICAL.

IF CHOICE = NO 
THEN DO: 
     RETURN.
END.

ASSIGN v_log_method = SESSION:SET-WAIT-STATE("General").

ASSIGN v_cod_arq = session:temp-directory + "esfas014.csv".

OUTPUT TO VALUE(v_cod_arq).

PUT 'Estab;Conta Patrimonial;Bem;Seq;Dt Aquis;Grp Calc' SKIP.
    
FOR EACH estabelecimento NO-LOCK
    WHERE estabelecimento.cod_empresa = v_cod_empres_usuar:

    FOR EACH bem_pat NO-LOCK
        WHERE bem_pat.cod_estab = estabelecimento.cod_estab:

        IF bem_pat.val_perc_bxa >= 100 
           THEN NEXT.

        FIND FIRST cronog_calc OF bem_pat NO-LOCK
             WHERE cronog_calc_pat.cod_cenar_ctbl = 'GERENC' NO-ERROR.
        IF NOT AVAIL cronog_calc 
        THEN DO:

             PUT UNFORMATTED bem_pat.cod_estab ";" bem_pat.cod_cta_pat ";" bem_pat.num_bem_pat ";" bem_pat.num_seq ";" bem_pat.dat_aquis ";" bem_pat.cod_grp_calc SKIP.

             IF bem_pat.cod_grp_calc = 'Deprec' 
             THEN DO:

                  CREATE cronog_calc_pat.
                  ASSIGN cronog_calc_pat.cod_cenar_ctbl          = 'GERENC'
                         cronog_calc_pat.cod_grp_calc            = 'Deprec'
                         cronog_calc_pat.cod_tip_calc            = 'Deprec'                                                    
                         cronog_calc_pat.cod_usuar_ult_atualiz   = 'lu049406'                                              
                         cronog_calc_pat.dat_fim_parada          = 12/31/9999                                              
                         cronog_calc_pat.dat_inic_parada         = 01/01/0001                                              
                         cronog_calc_pat.dat_ult_atualiz         = TODAY                                                   
                         cronog_calc_pat.hra_ult_atualiz         = replace(string(TIME,"hh:mm:ss" /*l_hh:mm:ss*/ ),":","")
                         cronog_calc_pat.num_id_bem_pat          = bem_pat.num_id_bem_pat.                                 

                  CREATE cronog_calc_pat.
                  ASSIGN cronog_calc_pat.cod_cenar_ctbl          = 'GERENC'
                         cronog_calc_pat.cod_grp_calc            = 'Deprec'
                         cronog_calc_pat.cod_tip_calc            = 'CM'                                                    
                         cronog_calc_pat.cod_usuar_ult_atualiz   = 'lu049406'                                              
                         cronog_calc_pat.dat_fim_parada          = 12/31/9999                                              
                         cronog_calc_pat.dat_inic_parada         = 01/01/0001                                              
                         cronog_calc_pat.dat_ult_atualiz         = TODAY                                                   
                         cronog_calc_pat.hra_ult_atualiz         = replace(string(TIME,"hh:mm:ss" /*l_hh:mm:ss*/ ),":","")
                         cronog_calc_pat.num_id_bem_pat          = bem_pat.num_id_bem_pat.                                 

             END.

             IF bem_pat.cod_grp_calc = 'Amort' 
             THEN DO:

                  CREATE cronog_calc_pat.
                  ASSIGN cronog_calc_pat.cod_cenar_ctbl          = 'GERENC'
                         cronog_calc_pat.cod_grp_calc            = 'Amort'
                         cronog_calc_pat.cod_tip_calc            = 'Amortiz'                                                    
                         cronog_calc_pat.cod_usuar_ult_atualiz   = 'lu049406'                                              
                         cronog_calc_pat.dat_fim_parada          = 12/31/9999                                              
                         cronog_calc_pat.dat_inic_parada         = 01/01/0001                                              
                         cronog_calc_pat.dat_ult_atualiz         = TODAY                                                   
                         cronog_calc_pat.hra_ult_atualiz         = replace(string(TIME,"hh:mm:ss" /*l_hh:mm:ss*/ ),":","")
                         cronog_calc_pat.num_id_bem_pat          = bem_pat.num_id_bem_pat.                                 

                  CREATE cronog_calc_pat.
                  ASSIGN cronog_calc_pat.cod_cenar_ctbl          = 'GERENC'
                         cronog_calc_pat.cod_grp_calc            = 'Amort'
                         cronog_calc_pat.cod_tip_calc            = 'CM'                                                    
                         cronog_calc_pat.cod_usuar_ult_atualiz   = 'lu049406'                                              
                         cronog_calc_pat.dat_fim_parada          = 12/31/9999                                              
                         cronog_calc_pat.dat_inic_parada         = 01/01/0001                                              
                         cronog_calc_pat.dat_ult_atualiz         = TODAY                                                   
                         cronog_calc_pat.hra_ult_atualiz         = replace(string(TIME,"hh:mm:ss" /*l_hh:mm:ss*/ ),":","")
                         cronog_calc_pat.num_id_bem_pat          = bem_pat.num_id_bem_pat.                                 

             END.
             
             IF bem_pat.cod_grp_calc = 'NDNA' 
             THEN DO:

                  CREATE cronog_calc_pat.
                  ASSIGN cronog_calc_pat.cod_cenar_ctbl          = 'GERENC'
                         cronog_calc_pat.cod_grp_calc            = ''
                         cronog_calc_pat.cod_tip_calc            = 'CM'                                                    
                         cronog_calc_pat.cod_usuar_ult_atualiz   = 'lu049406'                                              
                         cronog_calc_pat.dat_fim_parada          = 12/31/9999                                              
                         cronog_calc_pat.dat_inic_parada         = 01/01/0001                                              
                         cronog_calc_pat.dat_ult_atualiz         = TODAY                                                   
                         cronog_calc_pat.hra_ult_atualiz         = replace(string(TIME,"hh:mm:ss" /*l_hh:mm:ss*/ ),":","")
                         cronog_calc_pat.num_id_bem_pat          = bem_pat.num_id_bem_pat.                                 

             END.

        END.
  
    END.
        
END.

OUTPUT CLOSE.

ASSIGN v_log_method = SESSION:SET-WAIT-STATE("").

MESSAGE 'Execu‡Æo Finalizada!' SKIP(1) 'Arquivo Gerado: ' v_cod_arq
    VIEW-AS ALERT-BOX INFO BUTTONS OK.
