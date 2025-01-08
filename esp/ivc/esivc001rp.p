/*****************************************************************************
**     Programa.........: esp/ivc/esivc001rp.p
**     Descricao .......: Importa‡Æo Regra Destina‡Æo
**     Autor............: Fabiano Zarpe Henke
**     Criado...........: 16/05/2013
*******************************************************************************/

DISABLE TRIGGERS FOR LOAD OF regra_usuar_inadimp.

{esinc/es0000.i}
    
DEF VAR c-arquivo AS CHAR.

DEF NEW GLOBAL SHARED VAR V_Cod_Dwb_User          AS   CHAR   FORM "x(15)"  NO-UNDO. /* usuario corrente */
DEF NEW GLOBAL SHARED VAR V_Num_Ped_Exec_Corren   AS   INTE   FORM ">>>>>9" NO-UNDO.

DEFINE VARIABLE v_log_consid_perddedut AS LOGICAL     NO-UNDO.

/* *** Ajusta a data de vencimento final do agendamento da abertura do dia 
       Deve considerar o TODAY (data base) menos o Num Dias                ***/
/*
FOR EACH dwb_rpt_param EXCLUSIVE-LOCK
    WHERE dwb_rpt_param.cod_dwb_program = "ta2_abertura_diaria_inadimp":
    IF NUM-ENTRIES(dwb_rpt_param.cod_dwb_parameters,CHR(10)) < 19 
       THEN NEXT.
    ASSIGN ENTRY(11,dwb_rpt_param.cod_dwb_parameters,CHR(10)) = STRING(TODAY - INTEGER(ENTRY(19,dwb_rpt_param.cod_dwb_parameters,CHR(10)))).
END.
*/

/*
FOR EACH ped_exec NO-LOCK
    WHERE ped_exec.cod_prog_dtsul   = "ta2_abertura_diaria_inadimp"
      AND ped_exec.ind_sit_ped_exec = "1":
    FIND ped_exec_param OF ped_exec EXCLUSIVE-LOCK NO-ERROR.
    IF AVAIL ped_exec_param
    AND NUM-ENTRIES(ped_exec_param.cod_dwb_parameters, CHR(10)) > 18 
       THEN ASSIGN ENTRY(11,ped_exec_param.cod_dwb_parameters, CHR(10)) = STRING(TODAY - INTEGER(ENTRY(19,ped_exec_param.cod_dwb_parameters, CHR(10)))).
END.
*/


/* *** Tratamento para a cria‡Æo do Perfil do Usu rio ***/
IF v_cod_dwb_user = "" 
   THEN ASSIGN v_cod_dwb_user = v_cod_usuar_corren.

IF v_num_ped_exec_corren > 0 THEN 
DO.
  FIND Ped_Exec_Param NO-LOCK
       WHERE Ped_Exec_Param.num_Ped_Exec = v_num_ped_exec_corren NO-ERROR.
  IF AVAIL Ped_Exec_Param THEN 
  DO.
    FIND Dwb_Set_List_Param NO-LOCK
         WHERE Dwb_Set_List_Param.Cod_Dwb_Program = "esivc001"
           AND Dwb_Set_List_Param.Cod_Dwb_User    = ENTRY(2, v_cod_dwb_user, "_") 
         NO-ERROR.
   ASSIGN c-arquivo = ENTRY(2, dwb_set_list_param.Cod_dwb_parameters, CHR(10)).
  END.
END.
ELSE
DO.
  FIND Dwb_Set_List_Param NO-LOCK
       WHERE Dwb_Set_List_Param.Cod_Dwb_Program = "esivc001"
         AND Dwb_Set_List_Param.Cod_Dwb_User    = v_cod_dwb_user 
       NO-ERROR.
  IF AVAIL Dwb_Set_List_Param THEN 
  DO.
    ASSIGN c-arquivo = ENTRY(2, dwb_set_list_param.Cod_dwb_parameters, CHR(10)).
  END.
END.

/*
OUTPUT TO /usr8/spool/fa041960/esivc001.d APPEND.
PUT UNFORMATTED  'fim' SKIP c-arquivo SKIP ENTRY(2, dwb_set_list_param.Cod_dwb_parameters, CHR(10)) SKIP.
OUTPUT CLOSE.
*/

RUN pi-importa.

RETURN "ok".

PROCEDURE pi-importa:

    DEFINE VARIABLE i_count          AS INTEGER     NO-UNDO.
    DEFINE VARIABLE v_des_reg_import AS CHARACTER   NO-UNDO.
    
    FOR EACH regra_usuar_inadimp EXCLUSIVE-LOCK:
        DELETE regra_usuar_inadimp.
    END.
    
    INPUT FROM VALUE(c-arquivo).

    import_block:
    REPEAT TRANSACTION:

        IMPORT UNFORMATTED v_des_reg_import.

        IF NUM-ENTRIES(v_des_reg_import, ";") < 2
           THEN NEXT.

        FIND perf_usuar_inadimp NO-LOCK
            WHERE perf_usuar_inadimp.cod_usuario = ENTRY(1, v_des_reg_import, ";") NO-ERROR.
        IF NOT AVAIL perf_usuar_inadimp 
           THEN NEXT.

        blk_estab:
        FOR EACH estabelecimento NO-LOCK
            WHERE estabelecimento.cod_empresa = "1":

            ASSIGN v_log_consid_perddedut = NO.
            FIND FIRST param_estab_inadimp NO-LOCK
                 WHERE param_estab_inadimp.cod_estab       = estabelecimento.cod_estab
                   AND param_estab_inadimp.dat_inic_valid <= TODAY
                   AND param_estab_inadimp.dat_fim_valid  >= TODAY NO-ERROR.
            IF AVAIL param_estab_inadimp 
               THEN ASSIGN v_log_consid_perddedut = param_estab_inadimp.log_consid_perddedut.

            FIND FIRST tit_acr NO-LOCK
                 WHERE tit_acr.cod_estab          = estabelecimento.cod_estab
                   AND tit_acr.log_sdo_tit_acr    = YES
                   AND tit_acr.cdn_cliente        = INT(ENTRY(2, v_des_reg_import, ";"))
                /*   AND tit_acr.dat_vencto_tit_acr < TODAY */
                NO-ERROR.
            IF AVAIL tit_acr 
               THEN LEAVE blk_estab.

            IF v_log_consid_perddedut = YES
            THEN DO:
                 FIND FIRST tit_acr NO-LOCK
                      WHERE tit_acr.cod_estab               = estabelecimento.cod_estab
                        AND tit_acr.log_sdo_tit_acr         = NO
                        AND tit_acr.dat_indcao_perda_dedut <> 12/31/9999 NO-ERROR.
                 IF AVAIL tit_acr 
                    THEN LEAVE blk_estab.
            END.

        END.

        IF NOT AVAIL tit_acr 
           THEN NEXT.

        FIND LAST regra_usuar_inadimp NO-LOCK
             WHERE regra_usuar_inadimp.cod_usuario = ENTRY(1, v_des_reg_import, ";") NO-ERROR.
        IF AVAIL regra_usuar_inadimp 
           THEN ASSIGN i_count = regra_usuar_inadimp.num_seq_regra + 1.
           ELSE ASSIGN i_count = 1.

        CREATE regra_usuar_inadimp.
        ASSIGN regra_usuar_inadimp.cod_usuario                 = ENTRY(1, v_des_reg_import, ";")
               regra_usuar_inadimp.num_seq_regra               = i_count
               regra_usuar_inadimp.ind_tip_regra_usuar_inadimp = "Cliente"
               regra_usuar_inadimp.cod_val_regra_inicial       = ENTRY(2, v_des_reg_import, ";")
               regra_usuar_inadimp.cod_val_regra_final         = ENTRY(2, v_des_reg_import, ";").

    END.

END.
