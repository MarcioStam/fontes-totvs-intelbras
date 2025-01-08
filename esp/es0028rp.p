/******************************************************************************
** Programa..............: gera_capital_giro
** Versao................:  1.00.00.000
** Nome Externo..........: esp/es0028rp.p
** Criado por............: Fabiano
** Criado em.............: 11/09/2007
** Objetivo..............: Gerar tabela para ser demonstrada na intranet
******************************************************************************/

{esp/es0028.i} 
{esp/es0043.i} /* <--- c-dir-arquivo-session  */

def input parameter raw-param  as raw no-undo.
def input parameter table     for tt-raw-digita.

def temp-table tt_input_leitura_sdo no-undo
    field ttv_cod_label                    as character format "x(8)" label "Label" column-label "Label"
    field ttv_des_conteudo                 as character format "x(40)" label "Texto" column-label "Texto"
    field ttv_num_seq_1                    as integer format ">>>,>>9"
    field ttv_num_seq_2                    as integer format ">>>>,>>9"
    index tt_ID                            is primary
          ttv_num_seq_1                    ascending.

def temp-table tt_retorna_sdo_ctbl no-undo
    field tta_num_seq                      as integer format ">>>,>>9" initial 0 label "Sequˆncia" column-label "NumSeq"
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cod_finalid_econ             as character format "x(10)" label "Finalidade" column-label "Finalidade"
    field tta_cod_plano_cta_ctbl           as character format "x(8)" label "Plano Contas" column-label "Plano Contas"
    field tta_cod_cta_ctbl                 as character format "x(20)" label "Conta Cont bil" column-label "Conta Cont bil"
    field tta_cod_plano_ccusto             as character format "x(8)" label "Plano Centros Custo" column-label "Plano Centros Custo"
    field tta_cod_ccusto                   as Character format "x(11)" label "Centro Custo" column-label "Centro Custo"
    field tta_cod_proj_financ              as character format "x(20)" label "Projeto" column-label "Projeto"
    field tta_cod_cenar_ctbl               as character format "x(8)" label "Cen rio Cont bil" column-label "Cen rio Cont bil"
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_unid_negoc               as character format "x(3)" label "Unid Neg¢cio" column-label "Un Neg"
    field tta_dat_sdo_ctbl                 as date format "99/99/9999" initial ? label "Data Saldo Cont bil" column-label "Data Saldo Cont bil"
    field tta_val_sdo_ctbl_db              as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Movto D‚bito" column-label "Movto D‚bito"
    field tta_val_sdo_ctbl_cr              as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Movto Cr‚dito" column-label "Movto Cr‚dito"
    field tta_val_sdo_ctbl_fim             as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Saldo Cont bil Final" column-label "Saldo Cont bil Final"
    field tta_val_apurac_restdo            as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Apura‡Æo Resultado" column-label "Apura‡Æo Resultado"
    field tta_val_apurac_restdo_db         as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Apura‡Æo Restdo DB" column-label "Apura‡Æo Restdo DB"
    field tta_val_apurac_restdo_cr         as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Apura‡Æo Restdo CR" column-label "Apura‡Æo Restdo CR"
    field tta_val_apurac_restdo_acum       as decimal format "->>>>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Apuracao Final" column-label "Apuracao Final"
    field tta_val_sdo_ctbl_db_sint         as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Movto D‚bito Sint" column-label "Movto D‚bito Sint"
    field tta_val_sdo_ctbl_cr_sint         as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Movto Cr‚dito Sint" column-label "Movto Cr‚dito Sint"
    field tta_val_sdo_ctbl_fim_sint        as decimal format "->>>>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Saldo Sint‚tico" column-label "Saldo Sint‚tico"
    field tta_val_apurac_restdo_sint       as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Apuracao Resultado" column-label "Apuracao Resultado"
    field tta_val_apurac_restdo_sint_db    as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Apur Restdo Sint DB" column-label "Apur Restdo Sint DB"
    field tta_val_apurac_restdo_sint_cr    as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Apur Restdo Sint CR" column-label "Apur Restdo Sint CR"
    field tta_val_apurac_restdo_sint_acum  as decimal format "->>>>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Apur Result Sint" column-label "Apur Result Sint"
    field tta_val_movto_empenh             as decimal format "->>,>>>,>>>,>>9.99" decimals 9 initial 0 label "Movto Empenhado" column-label "Movto Empenhado"
    field tta_qtd_sdo_ctbl_db              as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Quantidade DB" column-label "Quantidade DB"
    field tta_qtd_sdo_ctbl_cr              as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Quantidade CR" column-label "Quantidade CR"
    field tta_qtd_sdo_ctbl_fim             as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Quantidade Final" column-label "Quantidade Final"
    field ttv_val_movto_ctbl               as decimal format ">>>,>>>,>>>,>>9.99" decimals 2
    field tta_qtd_movto_empenh             as decimal format "->>>>,>>9.9999" decimals 4 initial 0 label "Qtde Movto Empenhado" column-label "Qtde Movto Empenhado"
    index tt_cta                          
          tta_cod_plano_cta_ctbl           ascending
          tta_cod_cta_ctbl                 ascending
    index tt_id                            is primary unique
          tta_cod_empresa                  ascending
          tta_cod_finalid_econ             ascending
          tta_cod_plano_cta_ctbl           ascending
          tta_cod_cta_ctbl                 ascending
          tta_cod_plano_ccusto             ascending
          tta_cod_ccusto                   ascending
          tta_cod_proj_financ              ascending
          tta_cod_cenar_ctbl               ascending
          tta_cod_estab                    ascending
          tta_cod_unid_negoc               ascending
          tta_dat_sdo_ctbl                 ascending
          tta_num_seq                      ascending
    index tt_id2                          
          tta_cod_empresa                  ascending
          tta_cod_finalid_econ             ascending
          tta_cod_plano_cta_ctbl           ascending
          tta_cod_cta_ctbl                 ascending
          tta_cod_proj_financ              ascending
          tta_cod_cenar_ctbl               ascending
          tta_cod_estab                    ascending
          tta_cod_unid_negoc               ascending
          tta_dat_sdo_ctbl                 ascending
    index tt_seq                          
          tta_num_seq                      ascending.

def temp-table tt_log_erros no-undo
    field ttv_num_seq                      as integer format ">>>,>>9" label "Seqˆncia" column-label "Seq"
    field ttv_num_cod_erro                 as integer format ">>>>,>>9" label "N£mero" column-label "N£mero"
    field ttv_des_erro                     as character format "x(50)" label "Inconsistˆncia" column-label "Inconsistˆncia"
    field ttv_des_ajuda                    as character format "x(50)" label "Ajuda" column-label "Ajuda".

def temp-table tt_capital no-undo
    field ttv_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field ttv_val_seq                      as integer format ">>>,>>9"
    field ttv_des_grupo                    as character format "x(50)"
    field ttv_cod_periodo_1                as character format "9999/99"
    field ttv_cod_periodo_2                as character format "9999/99"
    field ttv_cod_periodo_3                as character format "9999/99"
    field ttv_val_period_1                 as decimal format "->,>>>,>>9.99" decimals 2 initial 0
    field ttv_val_period_2                 as decimal format "->,>>>,>>9.99" decimals 2 initial 0
    field ttv_val_period_3                 as decimal format "->,>>>,>>9.99" decimals 2 initial 0
    index tt_emp                           is primary
          ttv_cod_empresa                  ascending
          ttv_des_grupo                    ascending
    index tt_seq                           
          ttv_cod_empresa                  ascending
          ttv_val_seq                      ascending.

/**************************************************************************************************/

def var v_num_seq         as int.
def var v_num_empresa     as int.
def var v_num_mes         as int.
def var v_dat_refer       as date initial today.
def var v_num_ano         as int.
def var v_num_mes_refer   as int.
def var v_des_sit_movimen as char.
def var v_val_movto       as dec.

def var v_cap_giro_1 as dec format "->>>,>>>,>>9.99" decimals 2 initial 0.
def var v_cap_giro_2 as dec format "->>>,>>>,>>9.99" decimals 2 initial 0.
def var v_cap_giro_3 as dec format "->>>,>>>,>>9.99" decimals 2 initial 0.

def var v_sdo_1 as dec format "->>>,>>>,>>9.99" decimals 2 initial 0.
def var v_sdo_2 as dec format "->>>,>>>,>>9.99" decimals 2 initial 0.
def var v_sdo_3 as dec format "->>>,>>>,>>9.99" decimals 2 initial 0.

def var v_cli_1 as dec format "->>>,>>>,>>9.99" decimals 2 initial 0.
def var v_cli_2 as dec format "->>>,>>>,>>9.99" decimals 2 initial 0.
def var v_cli_3 as dec format "->>>,>>>,>>9.99" decimals 2 initial 0.

def var v_pa_1 as dec format "->>>,>>>,>>9.99" decimals 2 initial 0.
def var v_pa_2 as dec format "->>>,>>>,>>9.99" decimals 2 initial 0.
def var v_pa_3 as dec format "->>>,>>>,>>9.99" decimals 2 initial 0.

def var v_mp_1 as dec format "->>>,>>>,>>9.99" decimals 2 initial 0.
def var v_mp_2 as dec format "->>>,>>>,>>9.99" decimals 2 initial 0.
def var v_mp_3 as dec format "->>>,>>>,>>9.99" decimals 2 initial 0.

def var v_for_1 as dec format "->>>,>>>,>>9.99" decimals 2 initial 0.
def var v_for_2 as dec format "->>>,>>>,>>9.99" decimals 2 initial 0.
def var v_for_3 as dec format "->>>,>>>,>>9.99" decimals 2 initial 0.

def buffer b_tt_capital for tt_capital.

/* *********************************************************************************************************
** Forma‡Æo dos valores:
** Saldo de Caixa: contas 111
** Clientes: contas 112
** Estoques PA: contas 115...5 e 115...8
** Estoques MP: demais contas 115
** Fornecedores (MP): contas 21210005 + 21220005 + 21220010 + 21220015 - 11310005 - 11310015 (Adiantamentos)
** ****************************************************************************************************** */

/* ** Efetuar trˆs leituras, empresa 1, 2 e 3 (Intelbras, Nova e Maxcom) ****/
repeat v_num_empresa = 1 to 3:

    /* ** Efetua leitura em trˆs meses ***/
    repeat v_num_mes = 3 to 1 by -1:

      if v_num_mes = 1
      then do:
           /* ** Posiciona um mˆs a frente ***/
           assign v_num_ano       = year(today)
                  v_num_mes_refer = month(today) + 1.
          
           if v_num_mes_refer = 13
              then assign v_num_mes_refer = 1
                          v_num_ano       = v_num_ano + 1.
    
           /* ** Diminui um dia para pegar o £ltimo dia do mˆs anterior ***/
           assign v_dat_refer = date('01' + string(v_num_mes_refer, '99') + string(v_num_ano, '9999'))
                  v_dat_refer = v_dat_refer - 1.
      end.

      if v_num_mes = 2
      then do:
           /* ** Posiciona um mˆs a frente ***/
           assign v_num_ano       = year(today)
                  v_num_mes_refer = month(today).
          
           /* ** Diminui um dia para pegar o £ltimo dia do mˆs anterior ***/
           assign v_dat_refer = date('01' + string(v_num_mes_refer, '99') + string(v_num_ano, '9999'))
                  v_dat_refer = v_dat_refer - 1.
      end.

      if v_num_mes = 3
      then do:
           /* ** Posiciona um mˆs a frente ***/
           assign v_num_ano       = year(today)
                  v_num_mes_refer = month(today) - 1.

           if v_num_mes_refer = 0
              then assign v_num_mes_refer = 12
                          v_num_ano       = v_num_ano - 1.
          
           /* ** Diminui um dia para pegar o £ltimo dia do mˆs anterior ***/
           assign v_dat_refer = date('01' + string(v_num_mes_refer, '99') + string(v_num_ano, '9999'))
                  v_dat_refer = v_dat_refer - 1.
      end.

      /* ** Verificar se o per¡odo da contabilidade est  fechado ou congelado, caso esteja, considera o saldo cont bil ***/
      assign v_des_sit_movimen = "".
      for each sit_movimen_modul no-lock
            where sit_movimen_modul.cod_modul_dtsul       = 'FGL'
              and sit_movimen_modul.cod_unid_organ        = string(v_num_empresa)
              and sit_movimen_modul.dat_inic_sit_movimen <= v_dat_refer
              and sit_movimen_modul.dat_fim_sit_movimen  >= v_dat_refer:
               if v_des_sit_movimen = ""
                  then assign v_des_sit_movimen = sit_movimen_modul.ind_sit_movimen.
                  else assign v_des_sit_movimen = v_des_sit_movimen + "," + sit_movimen_modul.ind_sit_movimen.
      end.

      if can-do(v_des_sit_movimen, "Fechado")
      or can-do(v_des_sit_movimen, "Congelado")
      or v_num_mes = 3
      then do:
         
            /* ** Leitura para o Grupo "Saldo de Caixa" ***/
            find tt_capital
               where tt_capital.ttv_cod_empresa = string(v_num_empresa)
                 and tt_capital.ttv_des_grupo   = 'Saldo de Caixa' no-error.
            if not avail tt_capital
            then do:
                 create tt_capital.
                 assign tt_capital.ttv_cod_empresa = string(v_num_empresa)
                        tt_capital.ttv_des_grupo   = 'Saldo de Caixa'
                        tt_capital.ttv_val_seq     = 1.
            end.
      
            for each tt_input_leitura_sdo:
                delete tt_input_leitura_sdo.
            end.
      
            assign v_num_seq = v_num_seq + 1.
      
            run pi_cria_leitura (input string(v_num_empresa),
                                 input '11100000',
                                 input '11200000',
                                 input v_dat_refer).
      
            run prgfin/fgl/fgl905zb.py (Input 1,
                                        Input table tt_input_leitura_sdo,
                                        output table tt_retorna_sdo_ctbl,
                                        output table tt_log_erros).
                                       
            for each tt_retorna_sdo_ctbl:
                if v_num_mes = 1
                   then assign tt_capital.ttv_val_period_1 = tt_capital.ttv_val_period_1 + tt_retorna_sdo_ctbl.tta_val_sdo_ctbl_fim.
                if v_num_mes = 2
                   then assign tt_capital.ttv_val_period_2 = tt_capital.ttv_val_period_2 + tt_retorna_sdo_ctbl.tta_val_sdo_ctbl_fim.
                if v_num_mes = 3
                   then assign tt_capital.ttv_val_period_3 = tt_capital.ttv_val_period_3 + tt_retorna_sdo_ctbl.tta_val_sdo_ctbl_fim.
            end.

            if v_num_mes = 1
               then assign tt_capital.ttv_cod_periodo_1 = string(year(v_dat_refer)) + string(month(v_dat_refer), '99').
            if v_num_mes = 2
               then assign tt_capital.ttv_cod_periodo_2 = string(year(v_dat_refer)) + string(month(v_dat_refer), '99').
            if v_num_mes = 3
               then assign tt_capital.ttv_cod_periodo_3 = string(year(v_dat_refer)) + string(month(v_dat_refer), '99').
      
            /* ** Leitura para o Grupo "Clientes" ***/
            find tt_capital
               where tt_capital.ttv_cod_empresa = string(v_num_empresa)
                 and tt_capital.ttv_des_grupo   = 'Clientes' no-error.
            if not avail tt_capital
            then do:
                 create tt_capital.
                 assign tt_capital.ttv_cod_empresa = string(v_num_empresa)
                        tt_capital.ttv_des_grupo   = 'Clientes'
                        tt_capital.ttv_val_seq     = 2.
            end.
      
            for each tt_input_leitura_sdo:
                delete tt_input_leitura_sdo.
            end.
      
            assign v_num_seq = v_num_seq + 1.
      
            run pi_cria_leitura (input string(v_num_empresa),
                                 input '11200000',
                                 input '11300000',
                                 input v_dat_refer).
      
            run prgfin/fgl/fgl905zb.py (Input 1,
                                        Input table tt_input_leitura_sdo,
                                        output table tt_retorna_sdo_ctbl,
                                        output table tt_log_erros).
                                       
            for each tt_retorna_sdo_ctbl:
                if v_num_mes = 1
                   then assign tt_capital.ttv_val_period_1 = tt_capital.ttv_val_period_1 + tt_retorna_sdo_ctbl.tta_val_sdo_ctbl_fim.
                if v_num_mes = 2
                   then assign tt_capital.ttv_val_period_2 = tt_capital.ttv_val_period_2 + tt_retorna_sdo_ctbl.tta_val_sdo_ctbl_fim.
                if v_num_mes = 3
                   then assign tt_capital.ttv_val_period_3 = tt_capital.ttv_val_period_3 + tt_retorna_sdo_ctbl.tta_val_sdo_ctbl_fim.
            end.
      
            if v_num_mes = 1
               then assign tt_capital.ttv_cod_periodo_1 = string(year(v_dat_refer)) + string(month(v_dat_refer), '99').
            if v_num_mes = 2
               then assign tt_capital.ttv_cod_periodo_2 = string(year(v_dat_refer)) + string(month(v_dat_refer), '99').
            if v_num_mes = 3
               then assign tt_capital.ttv_cod_periodo_3 = string(year(v_dat_refer)) + string(month(v_dat_refer), '99').

            /* ** Leitura para o Grupo "Estoque PA" ***/
            find tt_capital
               where tt_capital.ttv_cod_empresa = string(v_num_empresa)
                 and tt_capital.ttv_des_grupo   = 'Estoque PA' no-error.
            if not avail tt_capital
            then do:
                 create tt_capital.
                 assign tt_capital.ttv_cod_empresa = string(v_num_empresa)
                        tt_capital.ttv_des_grupo   = 'Estoque PA'
                        tt_capital.ttv_val_seq     = 3.
            end.
      
            for each tt_input_leitura_sdo:
                delete tt_input_leitura_sdo.
            end.
      
            assign v_num_seq = v_num_seq + 1.
      
            run pi_cria_leitura (input string(v_num_empresa),
                                 input '11510005',
                                 input '11510008',
                                 input v_dat_refer).
      
            run prgfin/fgl/fgl905zb.py (Input 1,
                                        Input table tt_input_leitura_sdo,
                                        output table tt_retorna_sdo_ctbl,
                                        output table tt_log_erros).
                                       
            for each tt_retorna_sdo_ctbl:
                if v_num_mes = 1
                   then assign tt_capital.ttv_val_period_1 = tt_capital.ttv_val_period_1 + tt_retorna_sdo_ctbl.tta_val_sdo_ctbl_fim.
                if v_num_mes = 2
                   then assign tt_capital.ttv_val_period_2 = tt_capital.ttv_val_period_2 + tt_retorna_sdo_ctbl.tta_val_sdo_ctbl_fim.
                if v_num_mes = 3
                   then assign tt_capital.ttv_val_period_3 = tt_capital.ttv_val_period_3 + tt_retorna_sdo_ctbl.tta_val_sdo_ctbl_fim.
            end.

            if v_num_mes = 1
               then assign tt_capital.ttv_cod_periodo_1 = string(year(v_dat_refer)) + string(month(v_dat_refer), '99').
            if v_num_mes = 2
               then assign tt_capital.ttv_cod_periodo_2 = string(year(v_dat_refer)) + string(month(v_dat_refer), '99').
            if v_num_mes = 3
               then assign tt_capital.ttv_cod_periodo_3 = string(year(v_dat_refer)) + string(month(v_dat_refer), '99').
      
            /* ** Leitura para o Grupo "Estoque MP" ***/
            find tt_capital
               where tt_capital.ttv_cod_empresa = string(v_num_empresa)
                 and tt_capital.ttv_des_grupo   = 'Estoque MP' no-error.
            if not avail tt_capital
            then do:
                 create tt_capital.
                 assign tt_capital.ttv_cod_empresa = string(v_num_empresa)
                        tt_capital.ttv_des_grupo   = 'Estoque MP'
                        tt_capital.ttv_val_seq     = 4.
            end.
      
            for each tt_input_leitura_sdo:
                delete tt_input_leitura_sdo.
            end.
      
            assign v_num_seq = v_num_seq + 1.
      
            run pi_cria_leitura (input string(v_num_empresa),
                                 input '11500000',
                                 input '11600000',
                                 input v_dat_refer).
      
            /* ** Cria exce‡äes ***/
            CREATE tt_input_leitura_sdo.
            ASSIGN tt_input_leitura_sdo.ttv_cod_label    = "Exce‡Æo Conta Cont bil"
                   tt_input_leitura_sdo.ttv_des_conteudo = '1151000#'
                   tt_input_leitura_sdo.ttv_num_seq_1    = v_num_seq
                   tt_input_leitura_sdo.ttv_num_seq_2    = 6.
      
      
            run prgfin/fgl/fgl905zb.py (Input 1,
                                        Input table tt_input_leitura_sdo,
                                        output table tt_retorna_sdo_ctbl,
                                        output table tt_log_erros).
                                       
            for each tt_retorna_sdo_ctbl:
                if v_num_mes = 1
                   then assign tt_capital.ttv_val_period_1 = tt_capital.ttv_val_period_1 + tt_retorna_sdo_ctbl.tta_val_sdo_ctbl_fim.
                if v_num_mes = 2
                   then assign tt_capital.ttv_val_period_2 = tt_capital.ttv_val_period_2 + tt_retorna_sdo_ctbl.tta_val_sdo_ctbl_fim.
                if v_num_mes = 3
                   then assign tt_capital.ttv_val_period_3 = tt_capital.ttv_val_period_3 + tt_retorna_sdo_ctbl.tta_val_sdo_ctbl_fim.
            end.

            if v_num_mes = 1
               then assign tt_capital.ttv_cod_periodo_1 = string(year(v_dat_refer)) + string(month(v_dat_refer), '99').
            if v_num_mes = 2
               then assign tt_capital.ttv_cod_periodo_2 = string(year(v_dat_refer)) + string(month(v_dat_refer), '99').
            if v_num_mes = 3
               then assign tt_capital.ttv_cod_periodo_3 = string(year(v_dat_refer)) + string(month(v_dat_refer), '99').
      
            /* ** Leitura para o Grupo "Fornecedores (MP)" ***/
            find tt_capital
               where tt_capital.ttv_cod_empresa = string(v_num_empresa)
                 and tt_capital.ttv_des_grupo   = 'Fornecedores (MP)' no-error.
            if not avail tt_capital
            then do:
                 create tt_capital.
                 assign tt_capital.ttv_cod_empresa = string(v_num_empresa)
                        tt_capital.ttv_des_grupo   = 'Fornecedores (MP)'
                        tt_capital.ttv_val_seq     = 5.
            end.
      
            for each tt_input_leitura_sdo:
                delete tt_input_leitura_sdo.
            end.
      
            assign v_num_seq = v_num_seq + 1.
      
            run pi_cria_leitura (input string(v_num_empresa),
                                 input '21210005',
                                 input '21210005',
                                 input v_dat_refer).
      
            run prgfin/fgl/fgl905zb.py (Input 1,
                                        Input table tt_input_leitura_sdo,
                                        output table tt_retorna_sdo_ctbl,
                                        output table tt_log_erros).
                                       
            for each tt_retorna_sdo_ctbl:
                if v_num_mes = 1
                   then assign tt_capital.ttv_val_period_1 = tt_capital.ttv_val_period_1 + tt_retorna_sdo_ctbl.tta_val_sdo_ctbl_fim.
                if v_num_mes = 2
                   then assign tt_capital.ttv_val_period_2 = tt_capital.ttv_val_period_2 + tt_retorna_sdo_ctbl.tta_val_sdo_ctbl_fim.
                if v_num_mes = 3
                   then assign tt_capital.ttv_val_period_3 = tt_capital.ttv_val_period_3 + tt_retorna_sdo_ctbl.tta_val_sdo_ctbl_fim.
            end.
            
            for each tt_input_leitura_sdo:
                delete tt_input_leitura_sdo.
            end.
      
            assign v_num_seq = v_num_seq + 1.
      
            run pi_cria_leitura (input string(v_num_empresa),
                                 input '21220005',
                                 input '21220015',
                                 input v_dat_refer).
      
            run prgfin/fgl/fgl905zb.py (Input 1,
                                        Input table tt_input_leitura_sdo,
                                        output table tt_retorna_sdo_ctbl,
                                        output table tt_log_erros).
                                       
            for each tt_retorna_sdo_ctbl:
                if v_num_mes = 1
                   then assign tt_capital.ttv_val_period_1 = tt_capital.ttv_val_period_1 + tt_retorna_sdo_ctbl.tta_val_sdo_ctbl_fim.
                if v_num_mes = 2
                   then assign tt_capital.ttv_val_period_2 = tt_capital.ttv_val_period_2 + tt_retorna_sdo_ctbl.tta_val_sdo_ctbl_fim.
                if v_num_mes = 3
                   then assign tt_capital.ttv_val_period_3 = tt_capital.ttv_val_period_3 + tt_retorna_sdo_ctbl.tta_val_sdo_ctbl_fim.
            end.             
      
            for each tt_input_leitura_sdo:
                delete tt_input_leitura_sdo.
            end.
      
            assign v_num_seq = v_num_seq + 1.
      
            run pi_cria_leitura (input string(v_num_empresa),
                                 input '11310005',
                                 input '11310015',
                                 input v_dat_refer).
      
            /* ** Cria exce‡äes ***/
            CREATE tt_input_leitura_sdo.
            ASSIGN tt_input_leitura_sdo.ttv_cod_label    = "Exce‡Æo Conta Cont bil"
                   tt_input_leitura_sdo.ttv_des_conteudo = '11310010'
                   tt_input_leitura_sdo.ttv_num_seq_1    = v_num_seq
                   tt_input_leitura_sdo.ttv_num_seq_2    = 6.
      
            run prgfin/fgl/fgl905zb.py (Input 1,
                                        Input table tt_input_leitura_sdo,
                                        output table tt_retorna_sdo_ctbl,
                                        output table tt_log_erros).
                                       
            for each tt_retorna_sdo_ctbl:
                if v_num_mes = 1
                   then assign tt_capital.ttv_val_period_1 = abs(tt_capital.ttv_val_period_1) - tt_retorna_sdo_ctbl.tta_val_sdo_ctbl_fim.
                if v_num_mes = 2
                   then assign tt_capital.ttv_val_period_2 = abs(tt_capital.ttv_val_period_2) - tt_retorna_sdo_ctbl.tta_val_sdo_ctbl_fim.
                if v_num_mes = 3
                   then assign tt_capital.ttv_val_period_3 = abs(tt_capital.ttv_val_period_3) - tt_retorna_sdo_ctbl.tta_val_sdo_ctbl_fim.
            end.

            if v_num_mes = 1
               then assign tt_capital.ttv_cod_periodo_1 = string(year(v_dat_refer)) + string(month(v_dat_refer), '99').
            if v_num_mes = 2
               then assign tt_capital.ttv_cod_periodo_2 = string(year(v_dat_refer)) + string(month(v_dat_refer), '99').
            if v_num_mes = 3
               then assign tt_capital.ttv_cod_periodo_3 = string(year(v_dat_refer)) + string(month(v_dat_refer), '99').

      end.

      if  not can-do(v_des_sit_movimen, "Fechado")
      and not can-do(v_des_sit_movimen, "Congelado")
      and v_num_mes <> 3
      then do:

           /* ** Caso o per¡odo nÆo esteja fechado ou congelado, efetua a leitura nas movimenta‡äes ***/
           for each estabelecimento no-lock
              where estabelecimento.cod_empresa = string(v_num_empresa):

                 /* ** Leitura para o Grupo "Saldo de Caixa" ***/
                 find tt_capital
                    where tt_capital.ttv_cod_empresa = string(v_num_empresa)
                      and tt_capital.ttv_des_grupo   = 'Saldo de Caixa' no-error.
                 if not avail tt_capital
                 then do:
                      create tt_capital.
                      assign tt_capital.ttv_cod_empresa = string(v_num_empresa)
                             tt_capital.ttv_des_grupo   = 'Saldo de Caixa'
                             tt_capital.ttv_val_seq     = 1.
                 end.

                 run pi_retorna_movto_origem (input estabelecimento.cod_estab,
                                              input '11100000',
                                              input '11199999',
                                              input v_dat_refer,
                                              output v_val_movto).

                 if v_num_mes = 1
                    then assign tt_capital.ttv_val_period_1 = tt_capital.ttv_val_period_1 + v_val_movto.
                 if v_num_mes = 2
                    then assign tt_capital.ttv_val_period_2 = tt_capital.ttv_val_period_2 + v_val_movto.
                                             
           end.

           if v_num_mes = 1
              then assign tt_capital.ttv_val_period_1 = tt_capital.ttv_val_period_2 + tt_capital.ttv_val_period_1.
           if v_num_mes = 2
              then assign tt_capital.ttv_val_period_2 = tt_capital.ttv_val_period_3 + tt_capital.ttv_val_period_2.

            if v_num_mes = 1
               then assign tt_capital.ttv_cod_periodo_1 = string(year(v_dat_refer)) + string(month(v_dat_refer), '99').
            if v_num_mes = 2
               then assign tt_capital.ttv_cod_periodo_2 = string(year(v_dat_refer)) + string(month(v_dat_refer), '99').

           /* ** Caso o per¡odo nÆo esteja fechado ou congelado, efetua a leitura na movimenta‡äes ***/
           for each estabelecimento no-lock
              where estabelecimento.cod_empresa = string(v_num_empresa):

                 /* ** Leitura para o Grupo "Clientes" ***/
                 find tt_capital
                    where tt_capital.ttv_cod_empresa = string(v_num_empresa)
                      and tt_capital.ttv_des_grupo   = 'Clientes' no-error.
                 if not avail tt_capital
                 then do:
                      create tt_capital.
                      assign tt_capital.ttv_cod_empresa = string(v_num_empresa)
                             tt_capital.ttv_des_grupo   = 'Clientes'
                             tt_capital.ttv_val_seq     = 2.
                 end.

                 run pi_retorna_movto_origem (input estabelecimento.cod_estab,
                                              input '11200000',
                                              input '11299999',
                                              input v_dat_refer,
                                              output v_val_movto).

                 if v_num_mes = 1
                    then assign tt_capital.ttv_val_period_1 = tt_capital.ttv_val_period_1 + v_val_movto.
                 if v_num_mes = 2
                    then assign tt_capital.ttv_val_period_2 = tt_capital.ttv_val_period_2 + v_val_movto.
                                             
           end.

           if v_num_mes = 1
              then assign tt_capital.ttv_val_period_1 = tt_capital.ttv_val_period_2 + tt_capital.ttv_val_period_1.
           if v_num_mes = 2
              then assign tt_capital.ttv_val_period_2 = tt_capital.ttv_val_period_3 + tt_capital.ttv_val_period_2.

            if v_num_mes = 1
               then assign tt_capital.ttv_cod_periodo_1 = string(year(v_dat_refer)) + string(month(v_dat_refer), '99').
            if v_num_mes = 2
               then assign tt_capital.ttv_cod_periodo_2 = string(year(v_dat_refer)) + string(month(v_dat_refer), '99').

           /* ** Caso o per¡odo nÆo esteja fechado ou congelado, efetua a leitura nas movimenta‡äes ***/
           for each estabelecimento no-lock
              where estabelecimento.cod_empresa = string(v_num_empresa):

                 /* ** Leitura para o Grupo "Estoque PA" ***/
                 find tt_capital
                    where tt_capital.ttv_cod_empresa = string(v_num_empresa)
                      and tt_capital.ttv_des_grupo   = 'Estoque PA' no-error.
                 if not avail tt_capital
                 then do:
                      create tt_capital.
                      assign tt_capital.ttv_cod_empresa = string(v_num_empresa)
                             tt_capital.ttv_des_grupo   = 'Estoque PA'
                             tt_capital.ttv_val_seq     = 3.
                 end.

                 run pi_retorna_movto_origem (input estabelecimento.cod_estab,
                                              input '11510005',
                                              input '11510008',
                                              input v_dat_refer,
                                              output v_val_movto).

                 if v_num_mes = 1
                    then assign tt_capital.ttv_val_period_1 = tt_capital.ttv_val_period_1 + v_val_movto.
                 if v_num_mes = 2
                    then assign tt_capital.ttv_val_period_2 = tt_capital.ttv_val_period_2 + v_val_movto.
                                             
           end.

           if v_num_mes = 1
              then assign tt_capital.ttv_val_period_1 = tt_capital.ttv_val_period_2 + tt_capital.ttv_val_period_1.
           if v_num_mes = 2
              then assign tt_capital.ttv_val_period_2 = tt_capital.ttv_val_period_3 + tt_capital.ttv_val_period_2.

            if v_num_mes = 1
               then assign tt_capital.ttv_cod_periodo_1 = string(year(v_dat_refer)) + string(month(v_dat_refer), '99').
            if v_num_mes = 2
               then assign tt_capital.ttv_cod_periodo_2 = string(year(v_dat_refer)) + string(month(v_dat_refer), '99').

           /* ** Caso o per¡odo nÆo esteja fechado ou congelado, efetua a leitura nas movimenta‡äes ***/
           for each estabelecimento no-lock
              where estabelecimento.cod_empresa = string(v_num_empresa):

                 /* ** Leitura para o Grupo "Estoque MP" ***/
                 find tt_capital
                    where tt_capital.ttv_cod_empresa = string(v_num_empresa)
                      and tt_capital.ttv_des_grupo   = 'Estoque MP' no-error.
                 if not avail tt_capital
                 then do:
                      create tt_capital.
                      assign tt_capital.ttv_cod_empresa = string(v_num_empresa)
                             tt_capital.ttv_des_grupo   = 'Estoque MP'
                             tt_capital.ttv_val_seq     = 4.
                 end.

                 run pi_retorna_movto_origem (input estabelecimento.cod_estab,
                                              input '11500000',
                                              input '11599999',
                                              input v_dat_refer,
                                              output v_val_movto).

                 if v_num_mes = 1
                    then assign tt_capital.ttv_val_period_1 = tt_capital.ttv_val_period_1 + v_val_movto.
                 if v_num_mes = 2
                    then assign tt_capital.ttv_val_period_2 = tt_capital.ttv_val_period_2 + v_val_movto.
                                             
           end.

           /* ** Desconsidera as contas do Estoque PA ***/
           find b_tt_capital
               where b_tt_capital.ttv_cod_empresa = tt_capital.ttv_cod_empresa
                 and b_tt_capital.ttv_des_grupo   = 'Estoque PA' no-error.

           if v_num_mes = 1
              then assign tt_capital.ttv_val_period_1 = tt_capital.ttv_val_period_2 + tt_capital.ttv_val_period_1 - (b_tt_capital.ttv_val_period_1 - b_tt_capital.ttv_val_period_2).
           if v_num_mes = 2
              then assign tt_capital.ttv_val_period_2 = tt_capital.ttv_val_period_3 + tt_capital.ttv_val_period_2 - (b_tt_capital.ttv_val_period_2 - b_tt_capital.ttv_val_period_3).

            if v_num_mes = 1
               then assign tt_capital.ttv_cod_periodo_1 = string(year(v_dat_refer)) + string(month(v_dat_refer), '99').
            if v_num_mes = 2
               then assign tt_capital.ttv_cod_periodo_2 = string(year(v_dat_refer)) + string(month(v_dat_refer), '99').

           /* ** Caso o per¡odo nÆo esteja fechado ou congelado, efetua a leitura nas movimenta‡äes ***/
           for each estabelecimento no-lock
              where estabelecimento.cod_empresa = string(v_num_empresa):

                 /* ** Leitura para o Grupo "Fornecedores (MP)" ***/
                 find tt_capital
                    where tt_capital.ttv_cod_empresa = string(v_num_empresa)
                      and tt_capital.ttv_des_grupo   = 'Fornecedores (MP)' no-error.
                 if not avail tt_capital
                 then do:
                      create tt_capital.
                      assign tt_capital.ttv_cod_empresa = string(v_num_empresa)
                             tt_capital.ttv_des_grupo   = 'Fornecedores (MP)'
                             tt_capital.ttv_val_seq     = 5.
                 end.

                 run pi_retorna_movto_origem (input estabelecimento.cod_estab,
                                              input '21210005',
                                              input '21210005',
                                              input v_dat_refer,
                                              output v_val_movto).
                                             
                 if v_num_mes = 1
                    then assign tt_capital.ttv_val_period_1 = tt_capital.ttv_val_period_1 + v_val_movto.
                 if v_num_mes = 2
                    then assign tt_capital.ttv_val_period_2 = tt_capital.ttv_val_period_2 + v_val_movto.

                 run pi_retorna_movto_origem (input estabelecimento.cod_estab,
                                              input '21220005',
                                              input '21220015',
                                              input v_dat_refer,
                                              output v_val_movto).

                 if v_num_mes = 1
                    then assign tt_capital.ttv_val_period_1 = tt_capital.ttv_val_period_1 + v_val_movto.
                 if v_num_mes = 2
                    then assign tt_capital.ttv_val_period_2 = tt_capital.ttv_val_period_2 + v_val_movto.

                 if v_num_mes = 1
                    then assign tt_capital.ttv_val_period_1 = tt_capital.ttv_val_period_1 + v_val_movto.
                 if v_num_mes = 2
                    then assign tt_capital.ttv_val_period_2 = tt_capital.ttv_val_period_2 + v_val_movto.

                 run pi_retorna_movto_origem (input estabelecimento.cod_estab,
                                              input '11310005',
                                              input '11310015',
                                              input v_dat_refer,
                                              output v_val_movto).

                 if v_num_mes = 1
                    then assign tt_capital.ttv_val_period_1 = tt_capital.ttv_val_period_1 - v_val_movto.
                 if v_num_mes = 2
                    then assign tt_capital.ttv_val_period_2 = tt_capital.ttv_val_period_2 - v_val_movto.

                                             
           end.

           if v_num_mes = 1
              then assign tt_capital.ttv_val_period_1 = tt_capital.ttv_val_period_2 + tt_capital.ttv_val_period_1.
           if v_num_mes = 2
              then assign tt_capital.ttv_val_period_2 = tt_capital.ttv_val_period_3 + tt_capital.ttv_val_period_2.

            if v_num_mes = 1
               then assign tt_capital.ttv_cod_periodo_1 = string(year(v_dat_refer)) + string(month(v_dat_refer), '99').
            if v_num_mes = 2
               then assign tt_capital.ttv_cod_periodo_2 = string(year(v_dat_refer)) + string(month(v_dat_refer), '99').

      end.

    end.

end.

/* ** Gera tabela para ser utilizada na p gina da Internet ***/
for each tt_capital:

    find cap_giro exclusive-lock
       where cap_giro.cod_empresa = tt_capital.ttv_cod_empresa
         and cap_giro.cod_periodo = tt_capital.ttv_cod_periodo_1
         and cap_giro.num_grupo   = tt_capital.ttv_val_seq no-error.
    if not avail cap_giro
    then do:
         create cap_giro.
         assign cap_giro.cod_empresa = tt_capital.ttv_cod_empresa
                cap_giro.cod_periodo = tt_capital.ttv_cod_periodo_1
                cap_giro.num_grupo   = tt_capital.ttv_val_seq
                cap_giro.des_grupo   = tt_capital.ttv_des_grupo.
    end.
    assign cap_giro.val_periodo = tt_capital.ttv_val_period_1.

    find cap_giro exclusive-lock
       where cap_giro.cod_empresa = tt_capital.ttv_cod_empresa
         and cap_giro.cod_periodo = tt_capital.ttv_cod_periodo_2
         and cap_giro.num_grupo   = tt_capital.ttv_val_seq no-error.
    if not avail cap_giro
    then do:
         create cap_giro.
         assign cap_giro.cod_empresa = tt_capital.ttv_cod_empresa
                cap_giro.cod_periodo = tt_capital.ttv_cod_periodo_2
                cap_giro.num_grupo   = tt_capital.ttv_val_seq
                cap_giro.des_grupo   = tt_capital.ttv_des_grupo.
    end.
    assign cap_giro.val_periodo = tt_capital.ttv_val_period_2.

    find cap_giro exclusive-lock
       where cap_giro.cod_empresa = tt_capital.ttv_cod_empresa
         and cap_giro.cod_periodo = tt_capital.ttv_cod_periodo_3
         and cap_giro.num_grupo   = tt_capital.ttv_val_seq no-error.
    if not avail cap_giro
    then do:
         create cap_giro.
         assign cap_giro.cod_empresa = tt_capital.ttv_cod_empresa
                cap_giro.cod_periodo = tt_capital.ttv_cod_periodo_3
                cap_giro.num_grupo   = tt_capital.ttv_val_seq
                cap_giro.des_grupo   = tt_capital.ttv_des_grupo.
    end.
    assign cap_giro.val_periodo = tt_capital.ttv_val_period_3.

end.


def var v_cod_arq as char.
/* assign v_cod_arq = session:temp-directory + 'ES0028' + ".tmp":U. */
assign v_cod_arq = c-dir-arquivo-session + 'ES0028' + ".tmp":U.

output to v_cod_arq.

put '07/2007' at 40 '08/2007' at 55 '09/2007' at 70.
put '--------------' at 36 '--------------' at 51 '--------------' at 66 skip.
put 'INTELBRAS' at 1 skip.
put '----------------------------------' at 1 skip.

for each tt_capital use-index tt_seq
    where tt_capital.ttv_cod_empresa = '1':

   put unformatted substring(ttv_des_grupo, 1, 17) at 1 string((ttv_val_period_3 / 1000), '->>>,>>>,>>9') at 38 string((ttv_val_period_2 / 1000), '->>>,>>>,>>9') at 53 string((ttv_val_period_1 / 1000), '->>>,>>>,>>9') at 68.

   if tt_capital.ttv_val_seq = 1
      then put skip "-------------------------------------------------------------------------------" skip.

   if ttv_des_grupo = "Fornecedores (MP)"
      then assign v_cap_giro_1 = v_cap_giro_1 - ttv_val_period_1
                  v_cap_giro_2 = v_cap_giro_2 - ttv_val_period_2
                  v_cap_giro_3 = v_cap_giro_3 - ttv_val_period_3.
      else if ttv_des_grupo <> "Saldo de Caixa"
              then assign v_cap_giro_1 = v_cap_giro_1 + ttv_val_period_1
                          v_cap_giro_2 = v_cap_giro_2 + ttv_val_period_2
                          v_cap_giro_3 = v_cap_giro_3 + ttv_val_period_3.
                  
   if ttv_des_grupo = "Saldo de Caixa"
      then assign v_sdo_1 = ttv_val_period_1
                  v_sdo_2 = ttv_val_period_2
                  v_sdo_3 = ttv_val_period_3.

   if ttv_des_grupo = "Clientes"
      then assign v_cli_1 = ttv_val_period_1
                  v_cli_2 = ttv_val_period_2
                  v_cli_3 = ttv_val_period_3.   
   
   if ttv_des_grupo = "Estoque PA"
      then assign v_pa_1 = ttv_val_period_1
                  v_pa_2 = ttv_val_period_2
                  v_pa_3 = ttv_val_period_3.   
   
   if ttv_des_grupo = "Estoque MP"
      then assign v_mp_1 = ttv_val_period_1
                  v_mp_2 = ttv_val_period_2
                  v_mp_3 = ttv_val_period_3.   
                  
   if ttv_des_grupo = "Fornecedores (MP)"
      then assign v_for_1 = ttv_val_period_1
                  v_for_2 = ttv_val_period_2
                  v_for_3 = ttv_val_period_3.

end.

put skip(1).

put unformatted 'Capital de Giro' at 1 string((v_cap_giro_3 / 1000), '->>>,>>>,>>9') at 38 string((v_cap_giro_2 / 1000), '->>>,>>>,>>9') at 53 string((v_cap_giro_1 / 1000), '->>>,>>>,>>9') at 68.

/*
put skip(1).

put unformatted 'Indice de Liquidez Corrente' at 1 string(((v_sdo_3 + v_cli_3 + v_pa_3 + v_mp_3) / v_for_3), '>>.>9') at 45 string(((v_sdo_2 + v_cli_2 + v_pa_2 + v_mp_2) / v_for_2), '>>.>9') at 60 string(((v_sdo_1 + v_cli_1 + v_pa_1 + v_mp_1) / v_for_1), '>>.>9') at 75.

put unformatted 'Indice Liquidez Seca'        at 1 string(((v_sdo_3 + v_cli_3) / v_for_3), '>>.>9')                   at 45 string(((v_sdo_2 + v_cli_2) / v_for_2), '>>.>9')                   at 60 string(((v_sdo_1 + v_cli_1) / v_for_1), '>>.>9')                   at 75.

put unformatted 'Participacao das Disponibilidades' at 1 string((((v_sdo_3 + v_cli_3) / (v_sdo_3 + v_cli_3 + v_pa_3 + v_mp_3))) * 100, '>>>.>9') at 42 '%' at 49 string((((v_sdo_2 + v_cli_2) / (v_sdo_2 + v_cli_2 + v_pa_2 + v_mp_2))) * 100, '>>>.>9') at 57 '%' at 64 string((((v_sdo_1 + v_cli_1) / (v_sdo_1 + v_cli_1 + v_pa_1 + v_mp_1))) * 100, '>>>.>9') at 72 '%' at 79.

put unformatted 'Participacao Contas a Receber'     at 1 string((((v_cli_3) / (v_sdo_3 + v_cli_3 + v_pa_3 + v_mp_3))) * 100, '>>>.>9')           at 42 '%' at 49 string((((v_cli_2) / (v_sdo_2 + v_cli_2 + v_pa_2 + v_mp_2))) * 100, '>>>.>9')           at 57 '%' at 64 string((((v_cli_1) / (v_sdo_1 + v_cli_1 + v_pa_1 + v_mp_1))) * 100, '>>>.>9')           at 72 '%' at 79.

put unformatted 'Participacao Estoque'              at 1 string((((v_pa_3 + v_mp_3) / (v_sdo_3 + v_cli_3 + v_pa_3 + v_mp_3))) * 100, '>>>.>9')   at 42 '%' at 49 string((((v_pa_2 + v_mp_2) / (v_sdo_2 + v_cli_2 + v_pa_2 + v_mp_2))) * 100, '>>>.>9')   at 57 '%' at 64 string((((v_pa_1 + v_mp_1) / (v_sdo_1 + v_cli_1 + v_pa_1 + v_mp_1))) * 100, '>>>.>9')   at 72 '%' at 79.

*/

put skip(2).

put '/* *********************************************************************************************************' skip
'** Formacao dos valores:' skip
'** Saldo de Caixa: contas 111' skip
'** Clientes: contas 112' skip
'** Estoques PA: contas 115...5 e 115...8' skip
'** Estoques MP: demais contas 115' skip
'** Fornecedores (MP): contas 21210005 + 21220005 + 21220010 + 21220015 - 11310005 - 11310015 (Adiantamentos)' skip
'** ****************************************************************************************************** */' skip.
/*
put skip(2).
put '/* *********************************************************************************************************' skip
'** Formacao dos indices:' skip
'** Indice de Liquidez Corrente: Ativo Circulante / Passivo Circulante' skip
'** Indice Liquidez Seca: (Ativo Circulante - Estoque) / Passivo Circulante' skip
'** Participacao das Disponibilidades: (Disponiveis + Realizavel Curto Prazo) / Ativo Circulante' skip
'** Participacao Contas a Receber: Contas a Receber / Ativo Circulante' skip
'** Participacao Estoque: Estoque / Ativo Circulante' skip
'** ****************************************************************************************************** */' skip.
*/
output close.

PROCEDURE pi_cria_leitura:

    DEF INPUT PARAMETER p_cod_empresa      AS CHAR.
    DEF INPUT PARAMETER p_cod_cta_ctbl_ini AS CHAR.
    DEF INPUT PARAMETER p_cod_cta_ctbl_fim AS CHAR.
    DEF INPUT PARAMETER p_dat_refer        AS DATE.

    CREATE tt_input_leitura_sdo.
    ASSIGN tt_input_leitura_sdo.ttv_cod_label    = "Empresa"
           tt_input_leitura_sdo.ttv_des_conteudo = p_cod_empresa
           tt_input_leitura_sdo.ttv_num_seq_1    = v_num_seq
           tt_input_leitura_sdo.ttv_num_seq_2    = 1.
    
    CREATE tt_input_leitura_sdo.
    ASSIGN tt_input_leitura_sdo.ttv_cod_label    = "Finalidade Econ“mica"
           tt_input_leitura_sdo.ttv_des_conteudo = 'Corrente'
           tt_input_leitura_sdo.ttv_num_seq_1    = v_num_seq
           tt_input_leitura_sdo.ttv_num_seq_2    = 2. 
    
    CREATE tt_input_leitura_sdo. 
    ASSIGN tt_input_leitura_sdo.ttv_cod_label    = "Conta Contabil Inicial"
           tt_input_leitura_sdo.ttv_des_conteudo = p_cod_cta_ctbl_ini
           tt_input_leitura_sdo.ttv_num_seq_1    = v_num_seq
           tt_input_leitura_sdo.ttv_num_seq_2    = 3.
    
    CREATE tt_input_leitura_sdo. 
    ASSIGN tt_input_leitura_sdo.ttv_cod_label    = "Conta Contabil Final"
           tt_input_leitura_sdo.ttv_des_conteudo = p_cod_cta_ctbl_fim
           tt_input_leitura_sdo.ttv_num_seq_1    = v_num_seq
           tt_input_leitura_sdo.ttv_num_seq_2    = 4.
    
    CREATE tt_input_leitura_sdo.
    ASSIGN tt_input_leitura_sdo.ttv_cod_label    = "Data Final"
           tt_input_leitura_sdo.ttv_des_conteudo = string(p_dat_refer, '99/99/9999')
           tt_input_leitura_sdo.ttv_num_seq_1    = v_num_seq
           tt_input_leitura_sdo.ttv_num_seq_2    = 5.

END.

PROCEDURE pi_retorna_movto_origem:

    DEF INPUT  PARAMETER p_cod_estab        AS CHAR.
    DEF INPUT  PARAMETER p_cod_cta_ctbl_ini AS CHAR.
    DEF INPUT  PARAMETER p_cod_cta_ctbl_fim AS CHAR.
    DEF INPUT  PARAMETER p_dat_refer        AS DATE.
    DEF OUTPUT PARAMETER p_val_movto        AS INT.

    def var v_dat           as date.
    def var v_val_movto_aux as dec.
    def var v_tot_db        as dec.
    def var v_tot_cr        as dec.

    for each cta_ctbl no-lock
        where cta_ctbl.cod_plano_cta_ctbl = 'Padrao'
          and cta_ctbl.cod_cta_ctbl      >= p_cod_cta_ctbl_ini
          and cta_ctbl.cod_cta_ctbl      <= p_cod_cta_ctbl_fim:

        /* ** Desconsidera para o c lculo do grupo Fornecedores (MP) ***/
        if cta_ctbl.cod_cta_ctbl = '11310010'
           then next.

        /* ** Movimentos Contas a Pagar - APB ***/
        repeat v_dat = date("01" + string(month(p_dat_refer),'99') + string(year(today), '9999')) to p_dat_refer:
    
            FOR EACH aprop_ctbl_ap NO-LOCK
                WHERE aprop_ctbl_ap.cod_estab            = p_cod_estab
                  AND aprop_ctbl_ap.cod_plano_cta_ctbl   = 'Padrao'
                  AND aprop_ctbl_ap.cod_cta_ctbl         = cta_ctbl.cod_cta_ctbl
                  AND aprop_ctbl_ap.dat_transacao        = v_dat
                  AND aprop_ctbl_ap.num_id_aprop_ctbl_ap = ?
                  AND aprop_ctbl_ap.log_ctbz_aprop_ctbl  = yes:
            
                assign v_tot_db = 0
                       v_tot_cr = 0.
                        
                /* **Tratamento para t¡tulos implantados em outra moeda ***/
                if aprop_ctbl_ap.cod_indic_econ <> 'real'
                then do:
                     for each val_aprop_ctbl_ap of aprop_ctbl_ap no-lock:
                        if aprop_ctbl_ap.ind_natur_lancto_ctbl = 'db'
                           then assign v_tot_db = v_tot_db + val_aprop_ctbl_ap.val_aprop.
                           else assign v_tot_cr = v_tot_cr + val_aprop_ctbl_ap.val_aprop.
                     end.
                end.
                else if aprop_ctbl_ap.ind_natur_lancto_ctbl = 'db'
                       then assign v_tot_db = v_tot_db + aprop_ctbl_ap.val_aprop_ctbl.
                       else assign v_tot_cr = v_tot_cr + aprop_ctbl_ap.val_aprop_ctbl.
    
                assign p_val_movto = p_val_movto + v_tot_db - v_tot_cr.
            
            END.
        
            /* ** Movimentos Contas a Receber - ACR ***/
            FOR EACH aprop_ctbl_acr NO-LOCK
                WHERE aprop_ctbl_acr.cod_estab             = p_cod_estab
                  AND aprop_ctbl_acr.cod_plano_cta_ctbl    = 'Padrao'
                  AND aprop_ctbl_acr.cod_cta_ctbl          = cta_ctbl.cod_cta_ctbl
                  AND aprop_ctbl_acr.dat_transacao         = v_dat
                  AND aprop_ctbl_acr.log_aprop_ctbl_ctbzda = no                  
                  AND aprop_ctbl_acr.log_ctbz_aprop_ctbl   = yes:

                assign v_tot_db = 0
                       v_tot_cr = 0.
            
                /* **Tratamento para t¡tulos implantados em outra moeda ***/
                if aprop_ctbl_acr.cod_indic_econ <> 'real'
                then do:
                     for each val_aprop_ctbl_acr of aprop_ctbl_acr no-lock:
                        if aprop_ctbl_acr.ind_natur_lancto_ctbl = 'db'
                           then assign v_tot_db = v_tot_db + val_aprop_ctbl_acr.val_aprop.
                           else assign v_tot_cr = v_tot_cr + val_aprop_ctbl_acr.val_aprop.
                     end.
                end.
                else if aprop_ctbl_acr.ind_natur_lancto_ctbl = 'db'
                       then assign v_tot_db = v_tot_db + aprop_ctbl_acr.val_aprop_ctbl.
                       else assign v_tot_cr = v_tot_cr + aprop_ctbl_acr.val_aprop_ctbl.
        
                assign p_val_movto = p_val_movto + v_tot_db - v_tot_cr.
            
            END.
        
            FOR EACH item_lancto_ctbl NO-LOCK
                WHERE item_lancto_ctbl.cod_estab           = p_cod_estab
                  AND item_lancto_ctbl.cod_plano_cta_ctbl  = 'Padrao'
                  AND item_lancto_ctbl.cod_cta_ctbl        = cta_ctbl.cod_cta_ctbl
                  AND item_lancto_ctbl.ind_sit_lancto_ctbl = 'ctbz'
                  AND item_lancto_ctbl.dat_lancto_ctbl     = v_dat 
                  AND (item_lancto_ctbl.cod_cenar_ctbl     = '' or 
                       item_lancto_ctbl.cod_cenar_ctbl     = 'fiscal'):

                assign v_tot_db = 0
                       v_tot_cr = 0.
                
                if item_lancto_ctbl.cod_indic_econ <> 'Real'
                then do:
                    for each aprop_lancto_ctbl of item_lancto_ctbl 
                        where aprop_lancto_ctbl.cod_finalid_econ = 'corrente' no-lock:
                        if item_lancto_ctbl.ind_natur_lancto_ctbl = 'db'
                           then assign v_tot_db = v_tot_db + aprop_lancto_ctbl.val_lancto_ctbl.
                           else assign v_tot_cr = v_tot_cr + aprop_lancto_ctbl.val_lancto_ctbl.
                    end.
                end.
                else 
                    if item_lancto_ctbl.ind_natur_lancto_ctbl = 'db'
                       then assign v_tot_db = v_tot_db + item_lancto_ctbl.val_lancto_ctbl.
                       else assign v_tot_cr = v_tot_cr + item_lancto_ctbl.val_lancto_ctbl.
    
                assign p_val_movto = p_val_movto + v_tot_db - v_tot_cr.
    
            end.

            find last param-estoq no-lock.
            if v_dat > param-estoq.contab-ate
            then do:
                /* ** Movimentos Estoque - CEP ***/
                FOR EACH movto-estoq FIELDS (dt-trans valor-mob-m valor-ggf-m tipo-trans ct-codigo valor-mat-m cod-estabel) NO-LOCK
                    WHERE movto-estoq.conta-contab  begins cta_ctbl.cod_cta_ctbl
                      AND movto-estoq.dt-trans      = v_dat
                      AND movto-estoq.contabilizado = no
                      AND movto-estoq.cod-estabel   = p_cod_estab:
                   
                      assign v_val_movto_aux = movto-estoq.valor-mat-m[1] +
                                               movto-estoq.valor-mob-m[1] +
                                               movto-estoq.valor-ggf-m[1].
    
                      /*IF movto-estoq.tipo-trans = 1 THEN "CR" ELSE "DB"*/
                      IF movto-estoq.tipo-trans <> 1 
                         THEN assign v_val_movto_aux = v_val_movto_aux * (-1).
                                               
                      IF v_val_movto_aux = 0 
                      THEN DO:
                           find item-estab no-lock
                                where item-estab.cod-estabel = p_cod_estab
                                  and item-estab.it-codigo   = movto-estoq.it-codigo no-error.
           
                           if avail item-estab then
                               assign v_val_movto_aux = movto-estoq.quantidade * 
                                                        (item-estab.val-unit-mat-m[1]
                                                       + item-estab.val-unit-mob-m[1]
                                                       + item-estab.val-unit-ggf-m[1] ).
    
                           IF movto-estoq.tipo-trans <> 1 
                              THEN assign v_val_movto_aux = v_val_movto_aux * (-1).
          
                      END.
                      
                      assign p_val_movto = p_val_movto + v_val_movto_aux.
                      
                end.
            end.
    
            /* ** Movimentos Caixa e Bancos - CMG ***/
            FOR EACH aprop_ctbl_cmg NO-LOCK
                WHERE aprop_ctbl_cmg.cod_estab                 = p_cod_estab
                  AND aprop_ctbl_cmg.cod_plano_cta_ctbl        = 'Padrao'
                  AND aprop_ctbl_cmg.cod_cta_ctbl              = cta_ctbl.cod_cta_ctbl
                  AND aprop_ctbl_cmg.dat_transacao             = v_dat
                  AND aprop_ctbl_cmg.log_ctbz_movto_cta_corren = no:

                assign v_tot_db = 0
                       v_tot_cr = 0.
            
                /* **Tratamento para t¡tulos implantados em outra moeda ***/
                if aprop_ctbl_cmg.cod_indic_econ <> 'real'
                then do:
                     assign v_tot_db        = 0
                            v_tot_cr        = 0.
                     for each val_aprop_ctbl_cmg of aprop_ctbl_cmg no-lock:
                         if aprop_ctbl_cmg.ind_natur_lancto_ctbl = 'db'
                            then assign v_tot_db = v_tot_db + val_aprop_ctbl_cmg.val_movto_cta_corren.
                            else assign v_tot_cr = v_tot_cr + val_aprop_ctbl_cmg.val_movto_cta_corren.
                     end.
                end.
                else 
                    if aprop_ctbl_cmg.ind_natur_lancto_ctbl = 'db'
                       then assign v_tot_db = v_tot_db + aprop_ctbl_cmg.val_movto_cta_corren.
                       else assign v_tot_cr = v_tot_cr + aprop_ctbl_cmg.val_movto_cta_corren.
    
                assign p_val_movto = p_val_movto + (v_tot_db - v_tot_cr).
            
            END.
            
        end.
    
    end.

end.
