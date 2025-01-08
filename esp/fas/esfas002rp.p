{include/i_dbinst.i}
{include/i_dbtype.i}
{include/i_fcldef.i}

def var c-versao-prg as char initial " 1.00.01.001":U no-undo.

def new global shared var v_cod_dwb_user
    as character
    format "x(21)":U
    label "Usu†rio"
    column-label "Usu†rio"
    no-undo.
def new global shared var v_num_ped_exec_corren
    as integer
    format ">>>>9":U
    no-undo.
def new global shared var v_cod_usuar_corren
    as character
    format "x(12)":U
    label "Usu†rio Corrente"
    column-label "Usu†rio Corrente"
    no-undo.
def new global shared var v_cod_empres_usuar
    as character
    format "x(3)":U
    label "Empresa"
    column-label "Empresa"
    no-undo.
def var v_nom_prog_ext
    as character
    format "x(8)":U
    label "Nome Externo"
    no-undo.
def var v_dat_execution
    as date
    format "99/99/9999":U
    no-undo.
def var v_hra_execution
    as Character
    format "99:99":U
    no-undo.
def var v_cod_dwb_file
    as character
    format "x(40)":U
    label "Arquivo"
    column-label "Arquivo"
    no-undo.
def var v_nom_report_title
    as character
    format "x(40)":U
    no-undo.
def var v_ind_dwb_run_mode as character no-undo.
def var v_cod_dwb_order
    as character
    format "x(32)":U
    label "Classificaá∆o"
    column-label "Classificador"
    no-undo.
def var v_log_method
    as logical
    format "Sim/N∆o"
    initial yes
    no-undo.
def var v_nom_enterprise
    as character
    format "x(40)":U
    no-undo.
def var v_cod_release
    as character
    format "x(12)":U
    no-undo.

def var v_des_cta_pat       like cta_pat.des_cta_pat        no-undo.    
def var v_cod_cta_pat       LIKE cta_pat.cod_cta_pat        no-undo.
DEF VAR v_log_lista_sem_nfe AS LOGICAL INITIAL no           NO-UNDO.
def var v_nro_docto         as char                         no-undo.
DEF VAR v_log_gera_csv      AS LOGICAL INITIAL no           NO-UNDO.
DEF VAR c-narrat-aux        LIKE bem_pat.des_narrat_bem_pat NO-UNDO.    
DEF VAR c-sdcv              LIKE bem_pat.des_narrat_bem_pat NO-UNDO.
DEF VAR c-sdcv-aux          LIKE bem_pat.des_narrat_bem_pat NO-UNDO.
DEF VAR i-cont-aux          AS INT                          NO-UNDO.
DEF VAR i-cont              AS INT                          NO-UNDO.
DEF VAR c-pedido            AS CHAR FORMAT "x(50)"          NO-UNDO.
DEF VAR c-aux-pedido        AS CHAR FORMAT "x(50)"          NO-UNDO.

def var v_rpt_s_1_name as character initial "Relat¢rio Entrada de Bens" no-undo.
def var v_rpt_s_1_bottom as integer initial 65 no-undo.
def var v_rpt_s_1_lines as integer initial 66 no-undo.
def var v_rpt_s_1_columns as integer initial 255 no-undo.
def var v_rpt_s_1_page as integer no-undo.
    
def stream s_1.

def frame f_rpt_s_1_header_unique header
    "-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------" at 1
    'P†gina:' at 243
    (page-number (s_1) + v_rpt_s_1_page) at 250 format '>>>>>9' skip
    v_nom_enterprise at 1 format 'x(40)'
    v_nom_report_title at 216 format 'x(40)' skip
    '--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------' at 1
    v_dat_execution at 238 format '99/99/9999' '- '
    v_hra_execution at 251 format "99:99" skip (1)
    with no-box no-labels width 255 page-top stream-io.
    
def frame f_rpt_s_1_footer_last_page header
    "Èltima p†gina " at 1
    "-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------" at 15
    v_nom_prog_ext at 233 format "x(08)" "- "
    v_cod_release at 244 format "x(12)" skip
    with no-box no-labels width 255 page-bottom stream-io.
    
def frame f_rpt_s_1_footer_normal header
    "--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------" at 1
    "- " at 231
    v_nom_prog_ext at 233 format "x(08)" "- "
    v_cod_release at 244 format "x(12)" skip
    with no-box no-labels width 255 page-bottom stream-io.
    
def frame f_rpt_s_1_footer_param_page header
    "P†gina ParÉmetros " at 1
    "---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------" at 19
    v_nom_prog_ext at 233 format "x(08)" "- "
    v_cod_release at 244 format "x(12)" skip
    with no-box no-labels width 255 page-bottom stream-io.

def frame f_rpt_s_1_esfas002 header
    "Bem Pat" to 9
    "Seq" to 15
    "Descriá∆o" at 17
    "Fornecedor" at 58
    "Munic°pio" at 99
    "UF" at 132
    "Documento" at 136
    "SÇrie" at 146
    "Data Aquis" at 152
    "Valor Pago" at 172
    "Origem" at 183
    "Centro Custo" at 193 
    "Fornecedor" at 206
    "Vl Original" at 225
    "Narrativa" at 237
    skip
    "---------" to 9
    "-----" to 15
    "----------------------------------------" at 17
    "----------------------------------------" at 58
    "--------------------------------" at 99
    "---" at 132
    "---------" at 136
    "-----" at 146
    "----------" at 152
    "-------------------" at 163
    "---------" at 183 
    "------------" at 193 
    "----------" AT 206
    "-------------------" at 217
    "-------------------" AT 237 skip 
    with no-box no-labels width 255 page-top stream-io.
    
def frame f_rpt_s_1_cta_pat header    
    "Conta Patrimonial: " at 1
    v_cod_cta_pat at 20 format "x(18)"
    "-" at 39
    v_des_cta_pat at 41 format "x(32)" skip (1)
    with no-box no-labels width 255 page-top stream-io.
    
def temp-table tt_relat no-undo
    field classificador      as char extent 4
    field cod_cta_pat        like bem_pat.cod_cta_pat
    field num_bem_pat        like bem_pat.num_bem_pat
    field num_seq_bem_pat    like bem_pat.num_seq_bem_pat
    field des_bem_pat        like bem_pat.des_bem_pat
    field nom_pessoa         like emscad.fornecedor.nom_pessoa
    field cod_unid_federac   like pessoa_jurid.cod_unid_federac 
    field nom_cidade         like pessoa_jurid.nom_cidade
    field cod_docto_entr     like bem_pat.cod_docto_entr
    field cod_ser_nota       like bem_pat.cod_ser_nota
    field dat_aquis_bem_pat  like bem_pat.dat_aquis_bem_pat
    field tot-valor          as decimal 
    field origem             as char format "x(9)"
    field cod_ccusto_respons like bem_pat.cod_ccusto_respons
    field cdn_fornecedor     like bem_pat.cdn_fornecedor
    field des_narrat_bem_pat like bem_pat.des_narrat_bem_pat
    field val_original       like bem_pat.val_original
    field num_pedido         AS CHAR FORMAT "x(50)"
    field cod_unid_negoc     LIKE bem_pat.cod_unid_negoc
    index codigo cod_cta_pat num_bem_pat num_seq_bem_pat.
    
procedure pi_rpt_format_nro_docto:

    v_nro_docto = trim(bem_pat.cod_docto_entr).
    
    if length(v_nro_docto) < 7 then
        v_nro_docto = fill("0", 7 - length(v_nro_docto)) + v_nro_docto.

end procedure.    

procedure pi_rpt_esfas002:
    def var v_num_count as int no-undo.
    
    if not v_log_gera_csv then do:
        view stream s_1 frame f_rpt_s_1_header_unique.
        hide stream s_1 frame f_rpt_s_1_footer_last_page.
        view stream s_1 frame f_rpt_s_1_footer_normal.
        view stream s_1 frame f_rpt_s_1_cta_pat.
        view stream s_1 frame f_rpt_s_1_esfas002.
    end.
    else put stream s_1 unformatted
             "Cta Patrimonial" ";"
             "Bem Pat" ";"
             "Seq" ";"
             "Descriá∆o" ";"
             "Cod Fornecedor" ";"
             "Fornecedor" ";"
             "Munic°pio" ";"
             "UF" ";"
             "Documento" ";"
             "SÇrie" ";"
             "Data Aquis" ";"
             "Vl Tot Item" ";"
             "Vl Original" ";"
             "Origem" ";"
             "Centro Custo" ";" 
             "unid Negoc" ";"
             "Narrativa" ";"
             "Pedido" skip.
    
    selecao:
    for each dwb_rpt_select no-lock
     where dwb_rpt_select.cod_dwb_program = "esfas002":U
       and dwb_rpt_select.cod_dwb_user = v_cod_dwb_user /*cl_dwb_rpt_select of dwb_rpt_select*/ use-index dwbrptsl_id:
        if  dwb_rpt_select.log_dwb_rule = yes
        then do:
            run pi_ler_tt_rpt_bem_pat_regra.
        end /* if */.
        else do:
            run pi_ler_tt_rpt_bem_pat_excec.
        end /* else */.
    end /* for selecao */.
    
    classificador:
    for each tt_relat:
        do v_num_count = 1 to 4:
            case entry(v_num_count, dwb_rpt_param.cod_dwb_order):
                when "Conta Patrimonial" then
                    tt_relat.classificador[v_num_count] = tt_relat.cod_cta_pat.
                when "Bem Patrimonial" then
                    tt_relat.classificador[v_num_count] = string(tt_relat.num_bem_pat).
                when "Descriá∆o Bem Pat" then
                    tt_relat.classificador[v_num_count] = tt_relat.des_bem_pat.
                when "Data Aquisiá∆o" then
                    tt_relat.classificador[v_num_count] = string(tt_relat.des_bem_pat).
            end case.        
        end.
    end.             
    
    for each tt_relat
        break by tt_relat.cod_cta_pat
              by tt_relat.classificador[1]
              by tt_relat.classificador[2]           
              by tt_relat.classificador[3]
              by tt_relat.classificador[4]
              by tt_relat.num_seq_bem_pat:
              
        if first-of(tt_relat.cod_cta_pat) then do:
            find cta_pat no-lock
                 where cta_pat.cod_cta_pat = tt_relat.cod_cta_pat
                   and cta_pat.cod_empresa = v_cod_empres_usuar
                  no-error.
                  
            if avail cta_pat then
                assign v_cod_cta_pat = cta_pat.cod_cta_pat
                       v_des_cta_pat = cta_pat.des_cta_pat.
            else           
                assign v_cod_cta_pat = ""
                       v_des_cta_pat = "".
        END.

        /*
        if first-of(tt_relat.cod_cta_pat) then do:
            find cta_pat no-lock
                 where cta_pat.cod_cta_pat = tt_relat.cod_cta_pat
                   and cta_pat.cod_empresa = v_cod_empres_usuar
                  no-error.
                  
            if avail cta_pat then
                assign v_cod_cta_pat = cta_pat.cod_cta_pat
                       v_des_cta_pat = cta_pat.des_cta_pat.
            else           
                assign v_cod_cta_pat = ""
                       v_des_cta_pat = "".
                       
            if not first(tt_relat.cod_cta_pat) then 
                if not v_log_gera_csv then page stream s_1.          
                else put stream s_1 skip(1).
            
            if v_log_gera_csv then 
                put stream s_1 unformatted
                    "Conta Patrimonial: " ";"
                    v_cod_cta_pat format "x(18)" ";"
                    "-" ";"
                    v_des_cta_pat format "x(32)" ";" skip (1).
        
        end.     */         
    
        if not v_log_gera_csv then   
            put stream s_1 unformatted
                tt_relat.num_bem_pat to 9
                tt_relat.num_seq_bem_pat to 15
                tt_relat.des_bem_pat at 17
                tt_relat.nom_pessoa at 58
                tt_relat.nom_cidade at 99
                tt_relat.cod_unid_federac at 132 
                tt_relat.cod_docto_entr at 136
                tt_relat.cod_ser_nota at 146
                tt_relat.dat_aquis_bem_pat at 152
                tt_relat.tot-valor format ">>>>,>>>,>>>,>>9.99" to 181
                tt_relat.origem at 183 
                tt_relat.cod_ccusto_respons at 193 
                tt_relat.cdn_fornecedor at 206
                tt_relat.val_original format ">>>>,>>>,>>>,>>9.99" to 235 
                tt_relat.des_narrat_bem_pat FORMAT "x(19)" AT 237 skip.

        else        
            put stream s_1 unformatted
                v_des_cta_pat ";"
                tt_relat.num_bem_pat ";"
                tt_relat.num_seq_bem_pat ";"
                tt_relat.des_bem_pat ";"
                tt_relat.cdn_fornecedor ";" 
                tt_relat.nom_pessoa ";"
                tt_relat.nom_cidade ";"
                tt_relat.cod_unid_federac ";" 
                tt_relat.cod_docto_entr ";"
                tt_relat.cod_ser_nota ";"
                tt_relat.dat_aquis_bem_pat ";"
                tt_relat.tot-valor ";"
                tt_relat.val_original format ">>>>,>>>,>>>,>>9.99" ";"
                tt_relat.origem ";" 
                tt_relat.cod_ccusto_respons ";" 
                tt_relat.cod_unid_negoc ";"
                tt_relat.des_narrat_bem_pat ";"
                tt_relat.num_pedido skip.
    end.    

end procedure.

procedure pi_ler_tt_rpt_bem_pat_regra:

    case dwb_rpt_select.cod_dwb_field:
        when "Conta Patrimonial" then do:
            for each bem_pat no-lock
                where bem_pat.cod_empresa = v_cod_empres_usuar
                and   bem_pat.cod_cta_pat >= dwb_rpt_select.cod_dwb_initial
                and   bem_pat.cod_cta_pat <= dwb_rpt_select.cod_dwb_final:
                
                RUN pi_cria_relacto.
               
            end.
        end.

        when "Bem Patrimonial" then do:
            for each bem_pat no-lock
                where bem_pat.cod_empresa = v_cod_empres_usuar
                and   bem_pat.num_bem_pat >= int(dwb_rpt_select.cod_dwb_initial)
                and   bem_pat.num_bem_pat <= int(dwb_rpt_select.cod_dwb_final):
                
                RUN pi_cria_relacto.
               
            end.
    
        end.
        
        when "Descriá∆o Bem Pat" then do:
            for each bem_pat no-lock
                where bem_pat.cod_empresa = v_cod_empres_usuar
                and   bem_pat.des_bem_pat >= dwb_rpt_select.cod_dwb_initial
                and   bem_pat.des_bem_pat <= dwb_rpt_select.cod_dwb_final:
                
                RUN pi_cria_relacto.
               
            end.
    
        end.

        when "Data Aquisiá∆o" then do:
            for each bem_pat no-lock
                where bem_pat.cod_empresa = v_cod_empres_usuar
                and   bem_pat.dat_aquis_bem_pat >= date(dwb_rpt_select.cod_dwb_initial)
                and   bem_pat.dat_aquis_bem_pat <= date(dwb_rpt_select.cod_dwb_final):
                
                RUN pi_cria_relacto.
               
            end.
    
        end.
        
    end case.

end procedure.

procedure pi_ler_tt_rpt_bem_pat_excec:
    case dwb_rpt_select.cod_dwb_field:
        when "Conta Patrimonial" then do:
            for each tt_relat,
                first bem_pat fields () no-lock
                where bem_pat.cod_cta_pat = tt_relat.cod_cta_pat
                and   bem_pat.num_bem_pat = tt_relat.num_bem_pat
                and   bem_pat.num_seq_bem_pat = tt_relat.num_seq_bem_pat
                and   bem_pat.cod_empresa = v_cod_empres_usuar
                and   bem_pat.cod_cta_pat >= dwb_rpt_select.cod_dwb_initial
                and   bem_pat.cod_cta_pat <= dwb_rpt_select.cod_dwb_final:
                
                delete tt_relat.
            end.    
        end.

        when "Bem Patrimonial" then do:
            for each tt_relat,
                first bem_pat fields () no-lock
                where bem_pat.cod_cta_pat = tt_relat.cod_cta_pat
                and   bem_pat.num_bem_pat = tt_relat.num_bem_pat
                and   bem_pat.num_seq_bem_pat = tt_relat.num_seq_bem_pat
                and   bem_pat.cod_empresa = v_cod_empres_usuar
                and   bem_pat.num_bem_pat >= int(dwb_rpt_select.cod_dwb_initial)
                and   bem_pat.num_bem_pat <= int(dwb_rpt_select.cod_dwb_final):
                
                delete tt_relat.
            end.    
        end.

        when "Descriá∆o Bem Pat" then do:
            for each tt_relat,
                first bem_pat fields () no-lock
                where bem_pat.cod_cta_pat = tt_relat.cod_cta_pat
                and   bem_pat.num_bem_pat = tt_relat.num_bem_pat
                and   bem_pat.num_seq_bem_pat = tt_relat.num_seq_bem_pat
                and   bem_pat.cod_empresa = v_cod_empres_usuar
                and   bem_pat.des_bem_pat >= dwb_rpt_select.cod_dwb_initial
                and   bem_pat.des_bem_pat <= dwb_rpt_select.cod_dwb_final:
                
                delete tt_relat.
            end.    
        end.

        when "Data Aquisiá∆o" then do:
            for each tt_relat,
                first bem_pat fields () no-lock
                where bem_pat.cod_cta_pat = tt_relat.cod_cta_pat
                and   bem_pat.num_bem_pat = tt_relat.num_bem_pat
                and   bem_pat.num_seq_bem_pat = tt_relat.num_seq_bem_pat
                and   bem_pat.cod_empresa = v_cod_empres_usuar
                and   bem_pat.dat_aquis_bem_pat >= date(dwb_rpt_select.cod_dwb_initial)
                and   bem_pat.dat_aquis_bem_pat <= date(dwb_rpt_select.cod_dwb_final):
                
                delete tt_relat.
            end.    
        end.
    end case.            
end procedure.

find emscad.empresa no-lock
     where empresa.cod_empresa = v_cod_empres_usuar /*cl_empres_usuar of empresa*/ no-error.

if  avail empresa
then do:
    assign v_nom_enterprise   = empresa.nom_razao_social.
end /* if */.
else do:
    assign v_nom_enterprise   = 'DATASUL'.
end /* else */.

v_cod_release = c-versao-prg.

if  v_cod_dwb_user begins 'es_'
then do:
    find dwb_rpt_param exclusive-lock
         where dwb_rpt_param.cod_dwb_program = "esfas002":U
           and dwb_rpt_param.cod_dwb_user = v_cod_dwb_user /*cl_dwb_rpt_param of dwb_rpt_param*/ no-error.
    if  not avail dwb_rpt_param
    then do:
        return "ParÉmetros para o relat¢rio n∆o encontrado." /*1993*/ + " (" + "1993" + ")" + chr(10) + "N∆o foi poss°vel encontrar os parÉmetros necess†rios para a impress∆o do relat¢rio para o programa e usu†rio " + v_cod_dwb_user /*1993*/.
    end /* if */.

    FIND FIRST ped_exec WHERE ped_exec.num_ped_exec = V_Num_Ped_Exec_Corren NO-LOCK NO-ERROR.
    IF AVAIL ped_exec THEN DO:
       FIND FIRST servid_exec WHERE servid_exec.cod_servid_exec = ped_exec.cod_servid_exec NO-LOCK NO-ERROR.
       IF AVAIL servid_exec THEN DO:

           find usuar_mestre no-lock
               where usuar_mestre.cod_usuario = ENTRY(2,v_cod_dwb_user,"_") no-error.

           IF  AVAIL usuar_mestre AND 
                     usuar_mestre.nom_dir_spool <> "" 
           THEN
               ASSIGN dwb_rpt_param.cod_dwb_file = servid_exec.nom_dir_spool + "/" + usuar_mestre.nom_subdir_spool + "/" + dwb_rpt_param.cod_dwb_file.
           ELSE
               ASSIGN dwb_rpt_param.cod_dwb_file = servid_exec.nom_dir_spool + "/" + dwb_rpt_param.cod_dwb_file.
       END.
    END.

    find dwb_rpt_param no-lock
         where dwb_rpt_param.cod_dwb_program = "esfas002":U
           and dwb_rpt_param.cod_dwb_user = v_cod_dwb_user /*cl_dwb_rpt_param of dwb_rpt_param*/ no-error.
           
    if index( dwb_rpt_param.cod_dwb_file ,'~\') <> 0 then
        assign file-info:file-name = replace(dwb_rpt_param.cod_dwb_file, '~\', '~/').
    else
        assign file-info:file-name = dwb_rpt_param.cod_dwb_file.

    assign file-info:file-name = substring(file-info:file-name, 1,
                                           r-index(file-info:file-name, '~/') - 1).
    if  dwb_rpt_param.cod_dwb_output = "Arquivo" /*l_file*/ 
    then do:
       if file-info:file-type = ? then
          return "Diret¢rio Inexistente:" /*l_directory*/  + dwb_rpt_param.cod_dwb_file.
    end /* if */.

    find ped_exec no-lock
         where ped_exec.num_ped_exec = v_num_ped_exec_corren /*cl_le_ped_exec_global of ped_exec*/ no-error.
    if  ped_exec.cod_release_prog_dtsul <> trim(c-versao-prg)
    then do:
        return "Vers‰es do programa diferente." /*1994*/ + " (" + "1994" + ")" + chr(10)
                                     + substitute("A vers∆o do programa (&3) que gerou o pedido de execuá∆o batch (&1) Ç diferente da vers∆o do programa que deveria executar o pedido batch (&2)." /*1994*/,ped_exec.cod_release_prog_dtsul,
                                                  trim(c-versao-prg),
                                                  "esp/fas/esfas002rp.p":U).
    end /* if */.
    assign v_nom_prog_ext      = caps("esfas002rp":U)
           v_dat_execution     = today
           v_hra_execution     = replace(string(time, "hh:mm:ss" /*l_hh:mm:ss*/ ), ":", "")
           v_cod_dwb_file      = dwb_rpt_param.cod_dwb_file
           v_nom_report_title  = fill(" ", 40 - length(v_rpt_s_1_name)) + v_rpt_s_1_name
           v_ind_dwb_run_mode  = "Batch" /*l_batch*/ 
           v_cod_dwb_order     = dwb_rpt_param.cod_dwb_order
           v_log_lista_sem_nfe = entry(1, dwb_rpt_param.cod_dwb_parameters, chr(10)) = "yes"
           v_log_gera_csv      = entry(2, dwb_rpt_param.cod_dwb_parameters, chr(10)) = "yes".

    run pi_output_reports /*pi_output_reports*/.

    if  dwb_rpt_param.log_dwb_print_parameters = yes
    and not v_log_gera_csv
    then do:
        run pi_print_parameters /*pi_print_parameters*/.

    end /* if */.

    output stream s_1 close.

    return "OK" /*l_ok*/ .

end /* if */.
else do:
    find dwb_rpt_param no-lock
         where dwb_rpt_param.cod_dwb_program = "esfas002":U
           and dwb_rpt_param.cod_dwb_user = v_cod_dwb_user /*cl_dwb_rpt_param of dwb_rpt_param*/ no-error.
    if  not avail dwb_rpt_param
    then do:
        return "ParÉmetros para o relat¢rio n∆o encontrado." /*1993*/ + " (" + "1993" + ")" + chr(10) + "N∆o foi poss°vel encontrar os parÉmetros necess†rios para a impress∆o do relat¢rio para o programa e usu†rio corrente." /*1993*/.
    end /* if */.

    if index( dwb_rpt_param.cod_dwb_file ,'~\') <> 0 then
        assign file-info:file-name = replace(dwb_rpt_param.cod_dwb_file, '~\', '~/').
    else
        assign file-info:file-name = dwb_rpt_param.cod_dwb_file.

    assign file-info:file-name = substring(file-info:file-name, 1,
                                           r-index(file-info:file-name, '~/') - 1).
    if  dwb_rpt_param.cod_dwb_output = "Arquivo" /*l_file*/ 
    then do:
       if file-info:file-type = ? then
          return "Diret¢rio Inexistente:" /*l_directory*/  + dwb_rpt_param.cod_dwb_file.
    end /* if */.

    assign v_nom_prog_ext      = caps("esfas002rp":U)
           v_dat_execution     = today
           v_hra_execution     = replace(string(time, "hh:mm:ss" /*l_hh:mm:ss*/ ), ":", "")
           v_cod_dwb_file      = dwb_rpt_param.cod_dwb_file
           v_nom_report_title  = fill(" ", 40 - length(v_rpt_s_1_name)) + v_rpt_s_1_name
           v_ind_dwb_run_mode  = "Online" /*l_online*/ 
           v_cod_dwb_order     = dwb_rpt_param.cod_dwb_order
           v_log_lista_sem_nfe = entry(1, dwb_rpt_param.cod_dwb_parameters, chr(10)) = "yes"
           v_log_gera_csv      = entry(2, dwb_rpt_param.cod_dwb_parameters, chr(10)) = "yes".


    run pi_output_reports /*pi_output_reports*/.

    if  dwb_rpt_param.log_dwb_print_parameters = yes
    and not v_log_gera_csv
    then do:
        run pi_print_parameters /*pi_print_parameters*/.

    end /* if */.

    output stream s_1 close.

    return "OK" /*l_ok*/ .


end.

PROCEDURE pi_output_reports:
    def var v_num_count as int no-undo.
    def buffer b_ped_exec_style
        for ped_exec.
    def buffer b_servid_exec_style
        for servid_exec.
    
    assign v_log_method       = session:set-wait-state('general')
           v_nom_report_title = fill(" ",40 - length(v_rpt_s_1_name)) + v_rpt_s_1_name
           v_rpt_s_1_bottom   = dwb_rpt_param.qtd_dwb_line - (v_rpt_s_1_lines - v_rpt_s_1_bottom).

    /* block: */
    case dwb_rpt_param.cod_dwb_output:
            when "Arquivo" or when "Terminal" then
            block1:
            do:

               output stream s_1 to value(v_cod_dwb_file)
               paged page-size value(if not v_log_gera_csv then dwb_rpt_param.qtd_dwb_line else 0) convert target 'iso8859-1'.
            end /* do block1 */.
            when "Impressora" /*l_printer*/ then
               block2:
               do:
                  find imprsor_usuar use-index imprsrsr_id no-lock
                      where imprsor_usuar.nom_impressora = dwb_rpt_param.nom_dwb_printer
                      and   imprsor_usuar.cod_usuario    = v_cod_usuar_corren no-error.
                  find impressora no-lock
                       where impressora.nom_impressora = imprsor_usuar.nom_impressora
                        no-error.
                  find tip_imprsor no-lock
                       where tip_imprsor.cod_tip_imprsor = impressora.cod_tip_imprsor
                        no-error.
                  find layout_impres no-lock
                       where layout_impres.nom_impressora = dwb_rpt_param.nom_dwb_printer
                         and layout_impres.cod_layout_impres = dwb_rpt_param.cod_dwb_print_layout /*cl_get_layout of layout_impres*/ no-error.
                  find b_ped_exec_style
                      where b_ped_exec_style.num_ped_exec = v_num_ped_exec_corren no-lock no-error.
                  find servid_exec_imprsor no-lock
                       where servid_exec_imprsor.nom_impressora = dwb_rpt_param.nom_dwb_printer
                         and servid_exec_imprsor.cod_servid_exec = b_ped_exec_style.cod_servid_exec no-error.

                  find b_servid_exec_style no-lock
                       where b_servid_exec_style.cod_servid_exec = b_ped_exec_style.cod_servid_exec
                       no-error.

                  if  avail layout_impres
                  then do:
                     assign v_rpt_s_1_bottom = layout_impres.num_lin_pag - (v_rpt_s_1_lines - v_rpt_s_1_bottom).
                  end /* if */.

                  if  available b_servid_exec_style
                  and b_servid_exec_style.ind_tip_fila_exec = 'UNIX'
                  then do:
                      &if '{&emsbas_version}' > '1.00' &then           
                      &if '{&emsbas_version}' >= '5.03' &then           
                          if dwb_rpt_param.nom_dwb_print_file <> "" then do:
                              if  layout_impres.num_lin_pag = 0
                              then do:
                                  output stream s_1 to value(lc(dwb_rpt_param.nom_dwb_print_file))
                                         page-size 0 convert target tip_imprsor.cod_pag_carac_conver.
                              end /* if */. 
                              else do:
                                  output stream s_1 to value(lc(dwb_rpt_param.nom_dwb_print_file))
                                         paged page-size value(layout_impres.num_lin_pag) convert target tip_imprsor.cod_pag_carac_conver.
                              end /* else */.
                          end.
                          else do:
                              if  layout_impres.num_lin_pag = 0
                              then do:
                                  output stream s_1 through value(servid_exec_imprsor.nom_disposit_so)
                                         page-size 0 convert target tip_imprsor.cod_pag_carac_conver.
                              end /* if */. 
                              else do:
                                  output stream s_1 through value(servid_exec_imprsor.nom_disposit_so)
                                         paged page-size value(layout_impres.num_lin_pag) convert target tip_imprsor.cod_pag_carac_conver.
                              end /* else */.
                          end.
                      &else
                          if dwb_rpt_param.cod_livre_1 <> "" then do:
                              if  layout_impres.num_lin_pag = 0
                              then do:
                                  output stream s_1 to value(lc(dwb_rpt_param.cod_livre_1))
                                         page-size 0 convert target tip_imprsor.cod_pag_carac_conver.
                              end /* if */. 
                              else do:
                                  output stream s_1 to value(lc(dwb_rpt_param.cod_livre_1))
                                         paged page-size value(layout_impres.num_lin_pag) convert target tip_imprsor.cod_pag_carac_conver.
                              end /* else */.
                          end.
                          else do:
                              if  layout_impres.num_lin_pag = 0
                              then do:
                                  output stream s_1 through value(servid_exec_imprsor.nom_disposit_so)
                                         page-size 0 convert target tip_imprsor.cod_pag_carac_conver.
                              end /* if */. 
                              else do:
                                  output stream s_1 through value(servid_exec_imprsor.nom_disposit_so)
                                         paged page-size value(layout_impres.num_lin_pag) convert target tip_imprsor.cod_pag_carac_conver.
                              end /* else */.
                          end.
                      &endif
                      &endif
                  end /* if */.
                  else do:
                      &if '{&emsbas_version}' > '1.00' &then           
                      &if '{&emsbas_version}' >= '5.03' &then           
                          if dwb_rpt_param.nom_dwb_print_file <> "" then do:
                              if  layout_impres.num_lin_pag = 0
                              then do:
                                  output stream s_1 to value(lc(dwb_rpt_param.nom_dwb_print_file))
                                         page-size 0 convert target tip_imprsor.cod_pag_carac_conver.                            
                              end /* if */.
                              else do:
                                  output stream s_1 to value(lc(dwb_rpt_param.nom_dwb_print_file))
                                         paged page-size value(layout_impres.num_lin_pag) convert target tip_imprsor.cod_pag_carac_conver.                     
                              end /* else */.
                          end.
                          else do:
                              if  layout_impres.num_lin_pag = 0
                              then do:
                                  output stream s_1 to value(servid_exec_imprsor.nom_disposit_so)
                                         page-size 0 convert target tip_imprsor.cod_pag_carac_conver.                            
                              end /* if */.
                              else do:
                                  output stream s_1 to value(servid_exec_imprsor.nom_disposit_so)
                                         paged page-size value(layout_impres.num_lin_pag) convert target tip_imprsor.cod_pag_carac_conver.                     
                              end /* else */.
                          end.
                      &else
                          if dwb_rpt_param.cod_livre_1 <> "" then do:
                              if  layout_impres.num_lin_pag = 0
                              then do:
                                  output stream s_1 to value(lc(dwb_rpt_param.cod_livre_1))
                                         page-size 0 convert target tip_imprsor.cod_pag_carac_conver.                            
                              end /* if */.
                              else do:
                                  output stream s_1 to value(lc(dwb_rpt_param.cod_livre_1))
                                         paged page-size value(layout_impres.num_lin_pag) convert target tip_imprsor.cod_pag_carac_conver.                     
                              end /* else */.
                          end.
                          else do:
                              if  layout_impres.num_lin_pag = 0
                              then do:
                                  output stream s_1 to value(servid_exec_imprsor.nom_disposit_so)
                                         page-size 0 convert target tip_imprsor.cod_pag_carac_conver.                            
                              end /* if */.
                              else do:
                                  output stream s_1 to value(servid_exec_imprsor.nom_disposit_so)
                                         paged page-size value(layout_impres.num_lin_pag) convert target tip_imprsor.cod_pag_carac_conver.                     
                              end /* else */.
                          end.
                      &endif
                      &endif
                  end /* else */.

                  setting:
                  for
                      each configur_layout_impres no-lock
                      where configur_layout_impres.num_id_layout_impres = layout_impres.num_id_layout_impres

                      by configur_layout_impres.num_ord_funcao_imprsor:

                      find configur_tip_imprsor no-lock
                           where configur_tip_imprsor.cod_tip_imprsor = layout_impres.cod_tip_imprsor
                             and configur_tip_imprsor.cod_funcao_imprsor = configur_layout_impres.cod_funcao_imprsor
                             and configur_tip_imprsor.cod_opc_funcao_imprsor = configur_layout_impres.cod_opc_funcao_imprsor
    &if "{&emsbas_version}" >= "5.01" &then
                           use-index cnfgrtpm_id
    &endif
                            /*cl_get_print_command of configur_tip_imprsor*/ no-error.

                      bloco_1:
                      do
                          v_num_count = 1 to extent(configur_tip_imprsor.num_carac_configur):
                          /* configur_tip_imprsor: */
                          case configur_tip_imprsor.num_carac_configur[v_num_count]:
                              when 0 then put  stream s_1 control null.
                              when ? then leave.
                              otherwise 
                                  /* Convers∆o interna do OUTPUT TARGET */
                                  put stream s_1 control codepage-convert ( chr(configur_tip_imprsor.num_carac_configur[v_num_count]),
                                                                            session:cpinternal,
                                                                            tip_imprsor.cod_pag_carac_conver).
                          end /* case configur_tip_imprsor */.
                      end /* do bloco_1 */.
                 end /* for setting */.
            end /* do block2 */.
    end /* case block */.

    run pi_rpt_esfas002 /*pi_rpt_esfas002*/.
END PROCEDURE. /* pi_output_reports */

PROCEDURE pi_print_parameters:
    def var v_num_entry as int no-undo.

    if  page-number (s_1) > 0
    then do:
        page stream s_1.
    end /* if */.

    hide stream s_1 frame f_rpt_s_1_footer_last_page.
    hide stream s_1 frame f_rpt_s_1_footer_normal.
    hide stream s_1 frame f_rpt_s_1_cta_pat.
    hide stream s_1 frame f_rpt_s_1_esfas002.
    view stream s_1 frame f_rpt_s_1_footer_param_page.
    if (line-counter(s_1) + 3) > v_rpt_s_1_bottom then
        page stream s_1.
    put stream s_1 unformatted 
        skip (1)
        "Usu†rio: " at 1
        v_cod_usuar_corren at 10 format "x(12)" skip (1).

    if (line-counter(s_1) + 3) > v_rpt_s_1_bottom then
        page stream s_1.
    put stream s_1 unformatted 
        "Ordem" to 5
        "Classificador" at 7 skip
        "-----" to 5
        "--------------------------------" at 7 skip.
    1_block:
    repeat v_num_entry = 1 to num-entries (v_cod_dwb_order):
        if (line-counter(s_1) + 1) > v_rpt_s_1_bottom then
            page stream s_1.
        put stream s_1 unformatted 
            v_num_entry to 5 format ">>>>9"
            entry(v_num_entry,v_cod_dwb_order) at 7 format "x(32)" skip.
    end /* repeat 1_block */.

    if (line-counter(s_1) + 4) > v_rpt_s_1_bottom then
        page stream s_1.
    put stream s_1 unformatted 
        skip (1)
        "Tipo" at 1
        "Conjunto" at 9
        "Inicial" at 42
        "Final" at 61 skip
        "-------" at 1
        "--------------------------------" at 9
        "------------------" at 42
        "------------------" at 61 skip.
    ler:
    for each dwb_rpt_select no-lock
     where dwb_rpt_select.cod_dwb_program = "esfas002":U
       and dwb_rpt_select.cod_dwb_user = v_cod_dwb_user /*cl_dwb_rpt_select of dwb_rpt_select*/:
        if (line-counter(s_1) + 1) > v_rpt_s_1_bottom then
            page stream s_1.
        put stream s_1 unformatted 
            dwb_rpt_select.log_dwb_rule at 1 format "Regra/Exceá∆o"
            dwb_rpt_select.cod_dwb_field at 9 format "x(32)"
            dwb_rpt_select.cod_dwb_initial at 42 format "x(18)"
            dwb_rpt_select.cod_dwb_final at 61 format "x(18)" skip.
    end /* for ler */.

    /* Begin_Include: ix_p30_rpt_bem_pat_sit_geral_pat */
    if (line-counter(s_1) + 7) > v_rpt_s_1_bottom then
        page stream s_1.
    put stream s_1 unformatted 
        skip (1)
        "Lista bem sem nota fiscal informada: " at 74
        v_log_lista_sem_nfe at 112 format "Sim/N∆o" skip.
    /* End_Include: ix_p30_rpt_bem_pat_sit_geral_pat */


END PROCEDURE. /* pi_print_parameters */

PROCEDURE pi_cria_relacto:
    /*
    find first emscad.fornecedor of bem_pat no-lock no-error.
    find first pessoa_jurid no-lock
         where pessoa_jurid.num_pessoa_jurid = emscad.fornecedor.num_pessoa no-error.
    */

    find first movto_bem_pat no-lock
         where movto_bem_pat.num_id_bem_pat         = bem_pat.num_id_bem_pat
           and movto_bem_pat.ind_trans_calc_bem_pat = "Implantaá∆o"
           and (movto_bem_pat.ind_orig_calc_bem_pat = "Desmembramento"  or 
                movto_bem_pat.ind_orig_calc_bem_pat = "Reclassificaá∆o" ) no-error.
    if  avail movto_bem_pat 
    and movto_bem_pat.num_id_bem_pat_orig <> 0 
    then do:
         for each bem_pat_item_docto_entr no-lock
            where bem_pat_item_docto_entr.num_id_bem_pat = movto_bem_pat.num_id_bem_pat_orig:

            find first emscad.fornecedor of bem_pat_item_docto_entr no-lock no-error.
            find first pessoa_jurid no-lock
                 where pessoa_jurid.num_pessoa_jurid = emscad.fornecedor.num_pessoa no-error.

            ASSIGN c-narrat-aux = REPLACE(bem_pat.des_narrat_bem_pat,CHR(10),"").
            ASSIGN c-narrat-aux = REPLACE(c-narrat-aux,CHR(11),"").
            ASSIGN c-narrat-aux = REPLACE(c-narrat-aux,CHR(12),"").
            ASSIGN c-narrat-aux = REPLACE(c-narrat-aux,CHR(13),"").
            
            RUN pi-busca-string-sdcv.

            ASSIGN c-pedido     = ""
                   c-aux-pedido = "".

            FOR EACH item-doc-est
                WHERE item-doc-est.serie-docto  = bem_pat_item_docto_entr.cod_ser_nota
                AND   item-doc-est.nro-docto    = bem_pat_item_docto_entr.cod_docto_entr
                AND   item-doc-est.cod-emitente = bem_pat_item_docto_entr.cdn_fornecedor NO-LOCK:

                IF  item-doc-est.num-pedido = 0 THEN DO:
                    FOR EACH rat-ordem OF item-doc-est NO-LOCK:
                
                        ASSIGN c-aux-pedido = c-aux-pedido + "," + string(rat-ordem.num-pedido).
                        
                        IF  c-pedido = "" THEN
                            ASSIGN c-pedido = string(rat-ordem.num-pedido).
                        ELSE DO:
                            IF  LOOKUP(string(rat-ordem.num-pedido),c-aux-pedido) = 0 THEN
                                ASSIGN c-pedido = c-pedido + " / " + string(rat-ordem.num-pedido).
                        END.
                    END.
                END.
                ELSE DO:
                    ASSIGN c-aux-pedido = c-aux-pedido + "," + string(item-doc-est.num-pedido).

                    IF  c-pedido = "" THEN
                        ASSIGN c-pedido = string(item-doc-est.num-pedido).
                    ELSE DO:
                        IF  LOOKUP(string(item-doc-est.num-pedido),c-aux-pedido) = 0 THEN
                            ASSIGN c-pedido = c-pedido + " / " + string(item-doc-est.num-pedido).
                    END.
                END.
            END. 

            create tt_relat.
            assign tt_relat.cod_cta_pat        = bem_pat.cod_cta_pat
                   tt_relat.num_bem_pat        = bem_pat.num_bem_pat
                   tt_relat.num_seq_bem_pat    = bem_pat.num_seq_bem_pat
                   tt_relat.des_bem_pat        = bem_pat.des_bem_pat
                   tt_relat.nom_pessoa         = emscad.fornecedor.nom_pessoa when avail emscad.fornecedor
                   tt_relat.cod_unid_federac   = pessoa_jurid.cod_unid_federac when avail pessoa_jurid
                   tt_relat.nom_cidade         = pessoa_jurid.nom_cidade when avail pessoa_jurid
                   tt_relat.cod_docto_entr     = bem_pat_item_docto_entr.cod_docto_entr
                   tt_relat.cod_ser_nota       = bem_pat_item_docto_entr.cod_ser_nota
                   tt_relat.dat_aquis_bem_pat  = bem_pat.dat_aquis_bem_pat 
                   tt_relat.tot-valor          = bem_pat_item_docto_entr.val_item_docto_entr * bem_pat_item_docto_entr.qtd_item_docto_entr
                   tt_relat.origem             = (if emscad.fornecedor.cod_pais = "BRA" then "Nacional" else "Importado") when avail emscad.fornecedor
                   tt_relat.cod_ccusto_respons = bem_pat.cod_ccusto_respons
                   tt_relat.cdn_fornecedor     = bem_pat_item_docto_entr.cdn_fornecedor
                   tt_relat.des_narrat_bem_pat = c-sdcv
                   tt_relat.val_original       = bem_pat.val_original
                   tt_relat.num_pedido         = c-pedido
                   tt_relat.cod_unid_negoc     = bem_pat.cod_unid_negoc.
         end.
    end.
    else do:
         for each bem_pat_item_docto_entr no-lock
            where bem_pat_item_docto_entr.num_id_bem_pat = bem_pat.num_id_bem_pat:    

            find first emscad.fornecedor of bem_pat_item_docto_entr no-lock no-error.
            find first pessoa_jurid no-lock
                 where pessoa_jurid.num_pessoa_jurid = emscad.fornecedor.num_pessoa no-error.

            ASSIGN c-narrat-aux = REPLACE(bem_pat.des_narrat_bem_pat,CHR(10),"").
            ASSIGN c-narrat-aux = REPLACE(c-narrat-aux,CHR(11),"").
            ASSIGN c-narrat-aux = REPLACE(c-narrat-aux,CHR(12),"").
            ASSIGN c-narrat-aux = REPLACE(c-narrat-aux,CHR(13),"").

            RUN pi-busca-string-sdcv.

            ASSIGN c-pedido     = ""
                   c-aux-pedido = "".

            FOR EACH item-doc-est
                WHERE item-doc-est.serie-docto  = bem_pat_item_docto_entr.cod_ser_nota
                AND   item-doc-est.nro-docto    = bem_pat_item_docto_entr.cod_docto_entr
                AND   item-doc-est.cod-emitente = bem_pat_item_docto_entr.cdn_fornecedor NO-LOCK:

                IF  item-doc-est.num-pedido = 0 THEN DO:
                    FOR EACH rat-ordem OF item-doc-est NO-LOCK:
                
                        ASSIGN c-aux-pedido = c-aux-pedido + "," + string(rat-ordem.num-pedido).
                        
                        IF  c-pedido = "" THEN
                            ASSIGN c-pedido = string(rat-ordem.num-pedido).
                        ELSE DO:
                            IF  LOOKUP(string(rat-ordem.num-pedido),c-aux-pedido) = 0 THEN
                                ASSIGN c-pedido = c-pedido + " / " + string(rat-ordem.num-pedido).
                        END.
                    END.
                END.
                ELSE DO:
                    ASSIGN c-aux-pedido = c-aux-pedido + "," + string(item-doc-est.num-pedido).

                    IF  c-pedido = "" THEN
                        ASSIGN c-pedido = string(item-doc-est.num-pedido).
                    ELSE DO:
                        IF  LOOKUP(string(item-doc-est.num-pedido),c-aux-pedido) = 0 THEN
                            ASSIGN c-pedido = c-pedido + " / " + string(item-doc-est.num-pedido).
                    END.
                END.
            END. 

            create tt_relat.
            assign tt_relat.cod_cta_pat        = bem_pat.cod_cta_pat
                   tt_relat.num_bem_pat        = bem_pat.num_bem_pat
                   tt_relat.num_seq_bem_pat    = bem_pat.num_seq_bem_pat
                   tt_relat.des_bem_pat        = bem_pat.des_bem_pat
                   tt_relat.nom_pessoa         = emscad.fornecedor.nom_pessoa when avail emscad.fornecedor
                   tt_relat.cod_unid_federac   = pessoa_jurid.cod_unid_federac when avail pessoa_jurid
                   tt_relat.nom_cidade         = pessoa_jurid.nom_cidade when avail pessoa_jurid
                   tt_relat.cod_docto_entr     = bem_pat_item_docto_entr.cod_docto_entr
                   tt_relat.cod_ser_nota       = bem_pat_item_docto_entr.cod_ser_nota
                   tt_relat.dat_aquis_bem_pat  = bem_pat.dat_aquis_bem_pat 
                   tt_relat.tot-valor          = bem_pat_item_docto_entr.val_item_docto_entr * bem_pat_item_docto_entr.qtd_item_docto_entr
                   tt_relat.origem             = (if emscad.fornecedor.cod_pais = "BRA" then "Nacional" else "Importado") when avail emscad.fornecedor
                   tt_relat.cod_ccusto_respons = bem_pat.cod_ccusto_respons
                   tt_relat.cdn_fornecedor     = bem_pat_item_docto_entr.cdn_fornecedor
                   tt_relat.des_narrat_bem_pat = c-sdcv
                   tt_relat.val_original       = bem_pat.val_original
                   tt_relat.num_pedido         = c-pedido
                   tt_relat.cod_unid_negoc     = bem_pat.cod_unid_negoc.
         end.
    end.
    
    if  not v_log_lista_sem_nfe
    and bem_pat.cod_docto_entr = "" 
        then next.
   
    find first tt_relat
         where tt_relat.cod_cta_pat     = bem_pat.cod_cta_pat
           and tt_relat.num_bem_pat     = bem_pat.num_bem_pat
           and tt_relat.num_seq_bem_pat = bem_pat.num_seq_bem_pat no-error.    
    
    if  not avail tt_relat then do:
         run pi_rpt_format_nro_docto.    
        
         ASSIGN c-narrat-aux = REPLACE(bem_pat.des_narrat_bem_pat,CHR(10),"").
         ASSIGN c-narrat-aux = REPLACE(c-narrat-aux,CHR(11),"").
         ASSIGN c-narrat-aux = REPLACE(c-narrat-aux,CHR(12),"").
         ASSIGN c-narrat-aux = REPLACE(c-narrat-aux,CHR(13),"").

         RUN pi-busca-string-sdcv.

         create tt_relat.
         assign tt_relat.cod_cta_pat        = bem_pat.cod_cta_pat
                tt_relat.num_bem_pat        = bem_pat.num_bem_pat
                tt_relat.num_seq_bem_pat    = bem_pat.num_seq_bem_pat
                tt_relat.des_bem_pat        = bem_pat.des_bem_pat
                tt_relat.nom_pessoa         = emscad.fornecedor.nom_pessoa when avail emscad.fornecedor
                tt_relat.cod_unid_federac   = pessoa_jurid.cod_unid_federac when avail pessoa_jurid
                tt_relat.nom_cidade         = pessoa_jurid.nom_cidade when avail pessoa_jurid
                tt_relat.cod_docto_entr     = v_nro_docto
                tt_relat.cod_ser_nota       = bem_pat.cod_ser_nota
                tt_relat.dat_aquis_bem_pat  = bem_pat.dat_aquis_bem_pat
                tt_relat.tot-valor          = bem_pat.val_original 
                tt_relat.origem             = (if emscad.fornecedor.cod_pais = "BRA" then "Nacional" else "Importado") when avail emscad.fornecedor
                tt_relat.cod_ccusto_respons = bem_pat.cod_ccusto_respons
                tt_relat.cdn_fornecedor     = bem_pat.cdn_fornecedor
                tt_relat.des_narrat_bem_pat = c-sdcv
                tt_relat.val_original       = bem_pat.val_original
                tt_relat.cod_unid_negoc     = bem_pat.cod_unid_negoc.
    end.           

END.

PROCEDURE pi-busca-string-sdcv:
    ASSIGN c-sdcv     = ""
           c-sdcv-aux = "".

    DO  i-cont = 1 TO LENGTH(c-narrat-aux):
    
        IF  SUBSTR(c-narrat-aux, i-cont,1) = "S" THEN DO:
    
            IF  SUBSTR(c-narrat-aux, i-cont, 5) = "SDCV:" THEN DO:
                ASSIGN c-sdcv-aux = SUBSTR(c-narrat-aux, i-cont + 6 ,14).
    
                DO  i-cont-aux = 1 TO LENGTH(c-sdcv-aux):
    
                    IF  i-cont-aux = 1 THEN
                        ASSIGN c-sdcv = c-sdcv + "SDCV: ".
    
                    IF  SUBSTR(c-sdcv-aux,i-cont-aux,1) = "" THEN DO:
                        ASSIGN c-sdcv = c-sdcv + " / ".
                        LEAVE.
                    END.
    
                    ASSIGN c-sdcv = c-sdcv + SUBSTR(c-sdcv-aux,i-cont-aux,1).
                END.
            END.
        END.
    END.

END PROCEDURE.
