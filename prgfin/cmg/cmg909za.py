/*****************************************************************************
** Copyright DATASUL S.A. (1994)
** Todos os Direitos Reservados.
** 
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so' podera ser feita mediante
** autorizacao expressa.
**
** Programa..............: api_importa_extrato_bancario
** Descricao.............: API Importar Extrato Bancario
** Versao................:  1.00.00.000
** Procedimento..........: utl_importa_extrato_bancario
** Nome Externo..........: prgfin/cmg/cmg909za.py
** Data Geracao..........: 25/06/2009 - 17:43:41
** Criado por............: fut42929
** Criado em.............: 09/12/2008 11:11:38
** Alterado por..........: fut42929
** Alterado em...........: 24/04/2009 09:30:50
** Gerado por............: fut42929
*****************************************************************************/

def var c-versao-prg as char initial " 1.00.00.000":U no-undo.

{include/i_dbinst.i}
{include/i_dbtype.i}
{include/i_fcldef.i}


/******************************* Private-Data *******************************/
assign this-procedure:private-data = "HLP=35":U.
/*************************************  *************************************/

/********************* Temporary Table Definition Begin *********************/

def temp-table tt_extrat_cta_corren1 no-undo
    field tta_cod_cta_corren               as character format "x(10)" label "Conta Corrente" column-label "Cta Corrente"
    field tta_num_extrat_cta_corren        as integer format ">>>>>>,>>9" initial 0 label "Extrato Cta Corrente" column-label "Extrato Cta Corrente"
    .

def temp-table tt_file_list no-undo
    field ttv_nom_filename                 as character format "x(80)" label "Nome Arquivo"
    .

def temp-table tt_row_errors no-undo
    field ttv_num_seq_erro                 as integer format ">>>>,>>9" initial 0
    field ttv_num_erro                     as integer format ">>>>,>>9"
    field ttv_des_erro                     as character format "x(50)" label "Inconsistància" column-label "Inconsistància"
    field ttv_des_param                    as character format "x(50)" label "Param" column-label "Param"
    field ttv_des_type                     as character format "x(10)"
    field ttv_des_help                     as character format "x(40)" label "Ajuda" column-label "Ajuda"
    field ttv_des_sub_type                 as character format "x(40)"
    index tt_indice_errors                
          ttv_num_seq_erro                 ascending
    .



/********************** Temporary Table Definition End **********************/

/************************** Buffer Definition Begin *************************/

&if "{&emsfin_version}" >= "5.01" &then
def buffer b_extrat_cta_corren
    for extrat_cta_corren.
&endif


/*************************** Buffer Definition End **************************/

/************************** Stream Definition Begin *************************/

def stream s_import.


/*************************** Stream Definition End **************************/

/************************* Variable Definition Begin ************************/

def var v_cod_agenc_bcia
    as character
    format "x(10)":U
    label "Agància Banc†ria"
    column-label "Agància Banc†ria"
    no-undo.
def new global shared var v_cod_aplicat_dtsul_corren
    as character
    format "x(3)":U
    no-undo.
def var v_cod_banco
    as character
    format "x(8)":U
    label "Banco"
    column-label "Banco"
    no-undo.
def new global shared var v_cod_ccusto_corren
    as character
    format "x(11)":U
    label "Centro Custo"
    column-label "Centro Custo"
    no-undo.
def var v_cod_contdo_extrat
    as character
    format "x(8)":U
    extent 100
    no-undo.
def var v_cod_cta_corren_bco
    as character
    format "x(20)":U
    label "Conta Corrente Banco"
    column-label "Conta Corrente Banco"
    no-undo.
def var v_cod_digito_agenc_cta_corren
    as character
    format "x(2)":U
    label "D°gito Agància + Cta"
    column-label "D°g Agància + Cta"
    no-undo.
def var v_cod_digito_cta_corren
    as character
    format "x(2)":U
    label "D°gito Cta Corrente"
    column-label "D°gito Cta Corrente"
    no-undo.
def new global shared var v_cod_dwb_user
    as character
    format "x(21)":U
    label "Usu†rio"
    column-label "Usu†rio"
    no-undo.
def new global shared var v_cod_empres_usuar
    as character
    format "x(3)":U
    label "Empresa"
    column-label "Empresa"
    no-undo.
def new global shared var v_cod_estab_usuar
    as character
    format "x(3)":U
    label "Estabelecimento"
    column-label "Estab"
    no-undo.
def new global shared var v_cod_funcao_negoc_empres
    as character
    format "x(50)":U
    no-undo.
def new global shared var v_cod_grp_usuar_lst
    as character
    format "x(3)":U
    label "Grupo Usu†rios"
    column-label "Grupo"
    no-undo.
def new global shared var v_cod_idiom_usuar
    as character
    format "x(8)":U
    label "Idioma"
    column-label "Idioma"
    no-undo.
def var v_cod_mensagem
    as character
    format "x(2)":U
    label "Mensagem"
    column-label "Mensagem"
    no-undo.
def new global shared var v_cod_modul_dtsul_corren
    as character
    format "x(3)":U
    label "M¢dulo Corrente"
    column-label "M¢dulo Corrente"
    no-undo.
def new global shared var v_cod_modul_dtsul_empres
    as character
    format "x(100)":U
    no-undo.
def new global shared var v_cod_pais_empres_usuar
    as character
    format "x(3)":U
    label "Pa°s Empresa Usu†rio"
    column-label "Pa°s"
    no-undo.
def new global shared var v_cod_plano_ccusto_corren
    as character
    format "x(8)":U
    label "Plano CCusto"
    column-label "Plano CCusto"
    no-undo.
def var v_cod_reg_import
    as character
    format "x(256)":U
    no-undo.
def var v_cod_sist_nac_bcio
    as character
    format "x(8)":U
    label "C¢digo Sist Banc†rio"
    column-label "C¢digo Sist Banc†rio"
    no-undo.
def var v_cod_unid_fechto_cx
    as character
    format "x(8)":U
    label "Unidade Fechto Caixa"
    column-label "Unid Fechto Caixa"
    no-undo.
def new global shared var v_cod_unid_negoc_usuar
    as character
    format "x(3)":U
    view-as combo-box
    list-items ""
    inner-lines 5
    bgcolor 15 font 2
    label "Unidade Neg¢cio"
    column-label "Unid Neg¢cio"
    no-undo.
def new global shared var v_cod_usuar_corren
    as character
    format "x(12)":U
    label "Usu†rio Corrente"
    column-label "Usu†rio Corrente"
    no-undo.
def new global shared var v_cod_usuar_corren_criptog
    as character
    format "x(16)":U
    no-undo.
def var v_des_ajuda
    as character
    format "x(50)":U
    view-as editor max-chars 2000 scrollbar-vertical
    size 50 by 3
    bgcolor 15 font 2
    label "Ajuda"
    column-label "Ajuda"
    no-undo.
def var v_des_mensagem
    as character
    format "x(50)":U
    view-as editor max-chars 2000 scrollbar-vertical
    size 50 by 4
    bgcolor 15 font 2
    label "Mensagem"
    column-label "Mensagem"
    no-undo.
def var v_log_erro
    as logical
    format "Sim/N∆o"
    initial yes
    no-undo.
def var v_log_sdo_fim
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_log_sdo_inic
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_log_valid
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_log_validac_dat
    as logical
    format "Sim/N∆o"
    initial yes
    view-as toggle-box
    label "Valida Data"
    no-undo.
def var v_log_validac_refer
    as logical
    format "Sim/N∆o"
    initial yes
    view-as toggle-box
    label "Valida Referància"
    no-undo.
def var v_log_valid_cta_corren
    as logical
    format "Sim/N∆o"
    initial no
    no-undo.
def var v_nom_dir_export_arq
    as character
    format "x(40)":U
    label "Diret¢rio"
    column-label "Diret¢rio"
    no-undo.
def var v_nom_filename_import
    as character
    format "x(40)":U
    view-as editor max-chars 250 no-word-wrap
    size 40 by 1
    bgcolor 15 font 2
    label "Nome Arquivo"
    column-label "Arquivo"
    no-undo.
def var v_num_1
    as integer
    format ">>>>9":U
    no-undo.
def var v_num_extrat_cta_corren
    as integer
    format ">>>>>>,>>9":U
    label "Extrato Cta Corrente"
    column-label "Extrato Cta Corrente"
    no-undo.
def new global shared var v_num_ped_exec_corren
    as integer
    format ">>>>9":U
    no-undo.
def var v_num_pos_layout
    as integer
    format ">>>>,>>9":U
    extent 100
    no-undo.
def var v_num_tam_layout_extrat
    as integer
    format ">>>>,>>9":U
    extent 100
    no-undo.
def var v_rec_log
    as recid
    format ">>>>>>9":U
    no-undo.
def var v_cod_agenc_layout               as character       no-undo. /*local*/
def var v_cod_bco_layout                 as character       no-undo. /*local*/
def var v_cod_cta_corren_ant             as character       no-undo. /*local*/
def var v_cod_cta_corren_layout          as character       no-undo. /*local*/
def var v_cod_dir_temp                   as character       no-undo. /*local*/
def var v_cod_prim_ident                 as character       no-undo. /*local*/
def var v_cod_prim_ident_ant             as character       no-undo. /*local*/
def var v_cod_return                     as character       no-undo. /*local*/
def var v_cod_segndo_ident               as character       no-undo. /*local*/
def var v_cod_segndo_ident_ant           as character       no-undo. /*local*/
def var v_cod_sit                        as character       no-undo. /*local*/
def var v_cod_tip_reg                    as character       no-undo. /*local*/
def var v_cod_tip_reg_ant                as character       no-undo. /*local*/
def var v_cod_transacao                  as character       no-undo. /*local*/
def var v_dat_geracao                    as date            no-undo. /*local*/
def var v_log_banco                      as logical         no-undo. /*local*/
def var v_log_cta_corren                 as logical         no-undo. /*local*/
def var v_log_exist_extrat               as logical         no-undo. /*local*/
def var v_num_ano                        as integer         no-undo. /*local*/
def var v_num_count                      as integer         no-undo. /*local*/
def var v_num_count_aux                  as integer         no-undo. /*local*/
def var v_num_count_percent              as integer         no-undo. /*local*/
def var v_num_dia                        as integer         no-undo. /*local*/
def var v_num_extrat_cta_corren_ant      as integer         no-undo. /*local*/
def var v_num_mes                        as integer         no-undo. /*local*/
def var v_num_quant_cta                  as integer         no-undo. /*local*/
def var v_num_quant_lancto               as integer         no-undo. /*local*/
def var v_num_total                      as integer         no-undo. /*local*/
def var v_val_sdo_inicial_import         as decimal         no-undo. /*local*/
def var v_val_soma_cr                    as decimal         no-undo. /*local*/
def var v_val_soma_db                    as decimal         no-undo. /*local*/


/************************** Variable Definition End *************************/


/****************************** Main Code Begin *****************************/


/* Begin_Include: i_version_extract */
/*{include/i-ctrlrp5.i api_importa_extrato_bancario}*/


def new global shared var v_cod_arq
    as char  
    format 'x(60)'
    no-undo.
def new global shared var v_cod_tip_prog
    as character
    format 'x(8)'
    no-undo.

def stream s-arq.

if  v_cod_arq <> '' and v_cod_arq <> ?
then do:
    run pi_version_extract ('api_importa_extrato_bancario':U, 'prgfin/cmg/cmg909za.py':U, '1.00.00.000':U, 'pro':U).
end /* if */.



/* End_Include: i_version_extract */
/*
{fch/fchfin/fchfin0027.i1 ttBankStmntImportExecParamDTO} 
{fch/fchfin/fchfin0027.i2 ttBankStmntImportFileParamDTO}
*/

def temp-table ttBankStmntImportExecParamDTO no-undo
    field validateDate                 as LOG
    field validateReference            as LOG
    field cashClosingUnit              as CHAR 
    field validateEndBalance           as LOG.

def temp-table ttBankStmntImportFileParamDTO no-undo
    field importFileName               as CHAR
    field bankStatementLayout          as CHAR
    field setType                      as INT
    field chkAccount                   as CHAR
    field startChkAccount              as CHAR
    field endChkAccount                as CHAR
    field directoryTransfer            as CHAR
    field transferFile                 as LOG
    field bank                         as CHAR.


/* Begin_Include: i_declara_GetEntryField */
FUNCTION GetEntryField RETURNS CHARACTER (input p_num_posicao     AS INTEGER,
                                          INPUT p_cod_campo       AS CHARACTER,
                                          input p_cod_separador   AS CHARACTER):

/* ************* Parametros da FUNÄ«O *******************************
** Funá∆o para tratamento dos Entries dos c¢digos livres
** 
**  p_num_posicao     - N£mero do Entry que ser† atualizado
**  p_cod_campo       - Campo / Vari†vel que ser† atualizada
**  p_cod_separador   - Separador que ser† utilizado
*******************************************************************/

    if  p_num_posicao <= 0  then do:
        assign p_num_posicao  = 1.
    end.
    if num-entries(p_cod_campo,p_cod_separador) >= p_num_posicao  then do:
       return entry(p_num_posicao,p_cod_campo,p_cod_separador).
    end.
    return "" /*l_*/ .

END FUNCTION.

/* End_Include: i_declara_GetEntryField */


/* Begin_Include: i_declara_SetEntryField */
FUNCTION SetEntryField RETURNS CHARACTER (input p_num_posicao     AS INTEGER,
                                          input p_cod_campo       AS CHARACTER,
                                          input p_cod_separador   AS CHARACTER,
                                          input p_cod_valor       AS CHARACTER):

/* ************* Parametros da FUNÄ«O *******************************
** Funá∆o para tratamento dos Entries dos c¢digos livres
** 
**  p_num_posicao     - N£mero do Entry / Posiá∆o que ser† atualizado
**  p_cod_campo       - Campo / Vari†vel que ser† atualizada
**  p_cod_separador   - Separador que ser† utilizado
**  p_cod_valor       - Valor que ser† atualizado no Entry passado 
*******************************************************************/

    def var v_num_cont        as integer initial 0 no-undo.
    def var v_num_entries_ini as integer initial 0 no-undo.

    /* ** No progress a menor Entry Ç 1 ***/
    if p_num_posicao <= 0 then 
       assign p_num_posicao = 1.       

    /* ** Caso o Campo contenha um valor inv†lido, este valor ser† convertido para Branco
         para possibilitar os c†lculo ***/
    if p_cod_campo = ? then do:
       assign p_cod_campo = "" /* l_*/ .
    end.

    assign v_num_entries_ini = num-entries(p_cod_campo,p_cod_separador) + 1 .    
    if p_cod_campo = "" /* l_*/  then do:
       assign v_num_entries_ini = 2.
    end.

    do v_num_cont =  v_num_entries_ini to p_num_posicao :
       assign p_cod_campo = p_cod_campo + p_cod_separador.
    end.

    assign entry(p_num_posicao,p_cod_campo,p_cod_separador) = p_cod_valor.

    RETURN p_cod_campo.

END FUNCTION.


/* End_Include: i_declara_SetEntryField */







/******************************* Main Code End ******************************/

/************************* Internal Procedure Begin *************************/

/*****************************************************************************
** Procedure Interna.....: pi_version_extract
** Descricao.............: pi_version_extract
** Criado por............: jaison
** Criado em.............: 31/07/1998 09:33:22
** Alterado por..........: tech14020
** Alterado em...........: 12/06/2006 09:09:21
*****************************************************************************/
PROCEDURE pi_version_extract:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_program
        as character
        format "x(08)"
        no-undo.
    def Input param p_cod_program_ext
        as character
        format "x(8)"
        no-undo.
    def Input param p_cod_version
        as character
        format "x(8)"
        no-undo.
    def Input param p_cod_program_type
        as character
        format "x(8)"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_cod_event_dic
        as character
        format "x(20)":U
        label "Evento"
        column-label "Evento"
        no-undo.
    def var v_cod_tabela
        as character
        format "x(28)":U
        label "Tabela"
        column-label "Tabela"
        no-undo.


    /************************** Variable Definition End *************************/

    if  can-do(v_cod_tip_prog, p_cod_program_type)
    then do:
        if p_cod_program_type = 'dic' then 
           assign p_cod_program_ext = replace(p_cod_program_ext, 'database/', '').

        output stream s-arq to value(v_cod_arq) append.

        put stream s-arq unformatted
            p_cod_program            at 1 
            p_cod_program_ext        at 43 
            p_cod_version            at 69 
            today                    at 84 format "99/99/99"
            string(time, 'HH:MM:SS') at 94 skip.

        if  p_cod_program_type = 'pro' then do:
            &if '{&emsbas_version}' > '1.00' &then
            find prog_dtsul 
                where prog_dtsul.cod_prog_dtsul = p_cod_program 
                no-lock no-error.
            if  avail prog_dtsul
            then do:
                &if '{&emsbas_version}' > '5.00' &then
                    if  prog_dtsul.nom_prog_dpc <> '' then
                        put stream s-arq 'DPC : ' at 5 prog_dtsul.nom_prog_dpc  at 15 skip.
                &endif
                if  prog_dtsul.nom_prog_appc <> '' then
                    put stream s-arq 'APPC: ' at 5 prog_dtsul.nom_prog_appc at 15 skip.
                if  prog_dtsul.nom_prog_upc <> '' then
                    put stream s-arq 'UPC : ' at 5 prog_dtsul.nom_prog_upc  at 15 skip.
            end /* if */.
            &endif
        end.

        if  p_cod_program_type = 'dic' then do:
            &if '{&emsbas_version}' > '1.00' &then
            assign v_cod_event_dic = ENTRY(1,p_cod_program ,'/':U)
                   v_cod_tabela    = ENTRY(2,p_cod_program ,'/':U). /* FO 1100.980 */
            find tab_dic_dtsul 
                where tab_dic_dtsul.cod_tab_dic_dtsul = v_cod_tabela 
                no-lock no-error.
            if  avail tab_dic_dtsul
            then do:
                &if '{&emsbas_version}' > '5.00' &then
                    if  tab_dic_dtsul.nom_prog_dpc_gat_delete <> '' and v_cod_event_dic = 'Delete':U then
                        put stream s-arq 'DPC-DELETE : ' at 5 tab_dic_dtsul.nom_prog_dpc_gat_delete  at 25 skip.
                &endif
                if  tab_dic_dtsul.nom_prog_appc_gat_delete <> '' and v_cod_event_dic = 'Delete':U then
                    put stream s-arq 'APPC-DELETE: ' at 5 tab_dic_dtsul.nom_prog_appc_gat_delete at 25 skip.
                if  tab_dic_dtsul.nom_prog_upc_gat_delete <> '' and v_cod_event_dic = 'Delete':U then
                    put stream s-arq 'UPC-DELETE : ' at 5 tab_dic_dtsul.nom_prog_upc_gat_delete  at 25 skip.
                &if '{&emsbas_version}' > '5.00' &then
                    if  tab_dic_dtsul.nom_prog_dpc_gat_write <> '' and v_cod_event_dic = 'Write':U then
                        put stream s-arq 'DPC-WRITE : ' at 5 tab_dic_dtsul.nom_prog_dpc_gat_write  at 25 skip.
                &endif
                if  tab_dic_dtsul.nom_prog_appc_gat_write <> '' and v_cod_event_dic = 'Write':U then
                    put stream s-arq 'APPC-WRITE: ' at 5 tab_dic_dtsul.nom_prog_appc_gat_write at 25 skip.
                if  tab_dic_dtsul.nom_prog_upc_gat_write <> '' and v_cod_event_dic = 'Write':U  then
                    put stream s-arq 'UPC-WRITE : ' at 5 tab_dic_dtsul.nom_prog_upc_gat_write  at 25 skip.
            end /* if */.
            &endif
        end.

        output stream s-arq close.
    end /* if */.

END PROCEDURE. /* pi_version_extract */
/*****************************************************************************
** Procedure Interna.....: pi_criticar_dados_layout
** Descricao.............: pi_criticar_dados_layout
** Criado por............: DALPRA
** Criado em.............: 25/02/1997 15:43:34
** Alterado por..........: fut12214_2
** Alterado em...........: 20/05/2005 09:36:17
*****************************************************************************/
PROCEDURE pi_criticar_dados_layout:

    assign v_log_cta_corren = yes.
    /* * HEADER **/
    if  layout_extrat.log_utiliz_header_extrat
    then do:
        find tip_reg_layout_extrat
            where tip_reg_layout_extrat.cod_layout_extrat 	      = layout_extrat.cod_layout_extrat
            and   tip_reg_layout_extrat.ind_tip_reg_layout_extrat = "Header" /*l_header*/ 
            no-lock no-error.
        if  not avail tip_reg_layout_extrat
        then do:
            run pi_imprime_erro_importacao (Input "Header" /*l_header*/  + chr(10) + "Tipo Registro Extrato") /*pi_imprime_erro_importacao*/.
        end /* if */.
        else do:
            find mapa_tip_reg_extrat
                where mapa_tip_reg_extrat.cod_layout_extrat 	= layout_extrat.cod_layout_extrat
                and   mapa_tip_reg_extrat.num_seq_reg_layout_extrat = tip_reg_layout_extrat.num_seq_reg_layout_extrat
                and   mapa_tip_reg_extrat.ind_contdo_layout_extrat  = "Dia Geraá∆o" /*l_dia_geracao*/ 
                no-lock no-error.
            if  not avail mapa_tip_reg_extrat
            then do:
                 run pi_imprime_erro_importacao (Input "Dia Geraá∆o" /*l_dia_geracao*/  + chr(10) + "Mapeamento Tipo Reg Extrato") /*pi_imprime_erro_importacao*/.
            end /* if */.

            find mapa_tip_reg_extrat
                where mapa_tip_reg_extrat.cod_layout_extrat 	    = layout_extrat.cod_layout_extrat
                and   mapa_tip_reg_extrat.num_seq_reg_layout_extrat = tip_reg_layout_extrat.num_seq_reg_layout_extrat
                and   mapa_tip_reg_extrat.ind_contdo_layout_extrat  = "Màs Geraá∆o" /*l_mes_geracao*/ 
                no-lock no-error.
            if  not avail mapa_tip_reg_extrat
            then do:
                 run pi_imprime_erro_importacao (Input "Màs Geraá∆o" /*l_mes_geracao*/  + chr(10) + "Mapeamento Tipo Reg Extrato") /*pi_imprime_erro_importacao*/.
            end /* if */.

            find mapa_tip_reg_extrat
                where mapa_tip_reg_extrat.cod_layout_extrat         = layout_extrat.cod_layout_extrat
                and   mapa_tip_reg_extrat.num_seq_reg_layout_extrat = tip_reg_layout_extrat.num_seq_reg_layout_extrat
                and   mapa_tip_reg_extrat.ind_contdo_layout_extrat  = "Ano Geraá∆o" /*l_ano_geracao*/ 
                no-lock no-error.
            if  not avail mapa_tip_reg_extrat
            then do:
                 run pi_imprime_erro_importacao (Input "Ano Geraá∆o" /*l_ano_geracao*/  + chr(10) + "Mapeamento Tipo Reg Extrato") /*pi_imprime_erro_importacao*/.
            end /* if */.

            find mapa_tip_reg_extrat
                where mapa_tip_reg_extrat.cod_layout_extrat 	= layout_extrat.cod_layout_extrat
                and   mapa_tip_reg_extrat.num_seq_reg_layout_extrat = tip_reg_layout_extrat.num_seq_reg_layout_extrat
                and   mapa_tip_reg_extrat.ind_contdo_layout_extrat  = "Banco" /*l_banco*/ 
                no-lock no-error.
            if  not avail mapa_tip_reg_extrat
            then do:
                assign v_log_banco = no.
            end /* if */.
            else do:
                assign v_log_banco = yes.
            end /* else */.

            find mapa_tip_reg_extrat
                where mapa_tip_reg_extrat.cod_layout_extrat 	= layout_extrat.cod_layout_extrat
                and   mapa_tip_reg_extrat.num_seq_reg_layout_extrat = tip_reg_layout_extrat.num_seq_reg_layout_extrat
                and   mapa_tip_reg_extrat.ind_contdo_layout_extrat  = "Conta Corrente" /*l_conta_corrente*/ 
                no-lock no-error.
            if  not avail mapa_tip_reg_extrat
            then do:
                assign v_log_cta_corren = no.
            end /* if */.
            else do:
                assign v_log_cta_corren = yes.
            end /* else */.
        end /* else */.
    end /* if */.
    else do:
        /* Se o extrato nao possui header devera gravar a data da geracao igual today*/
        assign v_dat_geracao = today. 
    end /* else */.

    /* * SALDO INICIAL **/

    find tip_reg_layout_extrat
        where tip_reg_layout_extrat.cod_layout_extrat         = layout_extrat.cod_layout_extrat
        and   tip_reg_layout_extrat.ind_tip_reg_layout_extrat = "Sdo Inicial" /*l_sdo_inicial*/ 
        no-lock no-error.
    if  avail tip_reg_layout_extrat
    then do:
        find mapa_tip_reg_extrat
            where mapa_tip_reg_extrat.cod_layout_extrat 	    = layout_extrat.cod_layout_extrat
            and   mapa_tip_reg_extrat.num_seq_reg_layout_extrat = tip_reg_layout_extrat.num_seq_reg_layout_extrat
            and   mapa_tip_reg_extrat.ind_contdo_layout_extrat  = "Dia Sdo Inicial" /*l_dia_sdo_inicial*/ 
            no-lock no-error.
        if  not avail mapa_tip_reg_extrat
        then do:
            run pi_imprime_erro_importacao (Input "Dia Sdo Inicial" /*l_dia_sdo_inicial*/  + chr(10) + "Mapeamento Tipo Reg Extrato") /*pi_imprime_erro_importacao*/.
        end /* if */.

        find mapa_tip_reg_extrat
            where mapa_tip_reg_extrat.cod_layout_extrat         = layout_extrat.cod_layout_extrat
            and   mapa_tip_reg_extrat.num_seq_reg_layout_extrat = tip_reg_layout_extrat.num_seq_reg_layout_extrat
            and   mapa_tip_reg_extrat.ind_contdo_layout_extrat  = "Màs Sdo Inicial" /*l_mes_sdo_inicial*/ 
            no-lock no-error.
        if  not avail mapa_tip_reg_extrat
        then do:
            run pi_imprime_erro_importacao (Input "Màs Sdo Inicial" /*l_mes_sdo_inicial*/  + chr(10) + "Mapeamento Tipo Reg Extrato") /*pi_imprime_erro_importacao*/.
        end /* if */.

        find mapa_tip_reg_extrat
            where mapa_tip_reg_extrat.cod_layout_extrat         = layout_extrat.cod_layout_extrat
            and   mapa_tip_reg_extrat.num_seq_reg_layout_extrat = tip_reg_layout_extrat.num_seq_reg_layout_extrat
            and   mapa_tip_reg_extrat.ind_contdo_layout_extrat  = "Ano Sdo Inicial" /*l_ano_sdo_inicial*/ 
            no-lock no-error.
        if  not avail mapa_tip_reg_extrat
        then do:
            run pi_imprime_erro_importacao (Input "Ano Sdo Inicial" /*l_ano_sdo_inicial*/  + chr(10) + "Mapeamento Tipo Reg Extrato") /*pi_imprime_erro_importacao*/.
        end /* if */.

        find mapa_tip_reg_extrat
            where mapa_tip_reg_extrat.cod_layout_extrat         = layout_extrat.cod_layout_extrat
            and   mapa_tip_reg_extrat.num_seq_reg_layout_extrat = tip_reg_layout_extrat.num_seq_reg_layout_extrat
            and   mapa_tip_reg_extrat.ind_contdo_layout_extrat  = "Valor Sdo Inicial" /*l_valor_sdo_inicial*/ 
            no-lock no-error.
        if  not avail mapa_tip_reg_extrat
        then do:
            run pi_imprime_erro_importacao (Input "Valor Sdo Inicial" /*l_valor_sdo_inicial*/  + chr(10) + "Mapeamento Tipo Reg Extrato") /*pi_imprime_erro_importacao*/.
        end /* if */.

        find mapa_tip_reg_extrat
            where mapa_tip_reg_extrat.cod_layout_extrat         = layout_extrat.cod_layout_extrat
            and   mapa_tip_reg_extrat.num_seq_reg_layout_extrat = tip_reg_layout_extrat.num_seq_reg_layout_extrat
            and   mapa_tip_reg_extrat.ind_contdo_layout_extrat  = "Situaá∆o Saldo" /*l_situacao_saldo*/ 
            no-lock no-error.
        if  not avail mapa_tip_reg_extrat
        then do:
            run pi_imprime_erro_importacao (Input "Situaá∆o Saldo" /*l_situacao_saldo*/  + chr(10) + "Mapeamento Tipo Reg Extrato") /*pi_imprime_erro_importacao*/.
        end /* if */.

        if  v_log_banco = no
        then do:
            find mapa_tip_reg_extrat
                where mapa_tip_reg_extrat.cod_layout_extrat 	= layout_extrat.cod_layout_extrat
                and   mapa_tip_reg_extrat.num_seq_reg_layout_extrat = tip_reg_layout_extrat.num_seq_reg_layout_extrat
                and   mapa_tip_reg_extrat.ind_contdo_layout_extrat  = "Banco" /*l_banco*/ 
                no-lock no-error.
            if  not avail mapa_tip_reg_extrat
            then do:
                run pi_imprime_erro_importacao (Input "Banco" /*l_banco*/  + chr(10) + "Mapeamento Tipo Reg Extrato") /*pi_imprime_erro_importacao*/.
            end /* if */.
        end /* if */.
        if  v_log_cta_corren = no
        then do:
            find mapa_tip_reg_extrat
                where mapa_tip_reg_extrat.cod_layout_extrat         = layout_extrat.cod_layout_extrat
                and   mapa_tip_reg_extrat.num_seq_reg_layout_extrat = tip_reg_layout_extrat.num_seq_reg_layout_extrat
                and   mapa_tip_reg_extrat.ind_contdo_layout_extrat  = "Conta Corrente" /*l_conta_corrente*/ 
                no-lock no-error.
            if  not avail mapa_tip_reg_extrat
            then do:
                run pi_imprime_erro_importacao (Input "Conta Corrente" /*l_conta_corrente*/  + chr(10) + "Mapeamento Tipo Reg Extrato") /*pi_imprime_erro_importacao*/.
            end /* if */.
        end /* if */.
    end /* else */.

    /* * TRANSACAO **/

    find tip_reg_layout_extrat
        where tip_reg_layout_extrat.cod_layout_extrat         = layout_extrat.cod_layout_extrat
        and   tip_reg_layout_extrat.ind_tip_reg_layout_extrat = "Transaá∆o" /*l_transacao*/ 
        no-lock no-error.
    if  not avail tip_reg_layout_extrat
    then do:
        run pi_imprime_erro_importacao (Input "Transaá∆o" /*l_transacao*/  + chr(10) + "Tipo Registro Extrato") /*pi_imprime_erro_importacao*/.
    end /* if */.
    else do:
        find mapa_tip_reg_extrat
            where mapa_tip_reg_extrat.cod_layout_extrat 	= layout_extrat.cod_layout_extrat
            and   mapa_tip_reg_extrat.num_seq_reg_layout_extrat = tip_reg_layout_extrat.num_seq_reg_layout_extrat
            and   mapa_tip_reg_extrat.ind_contdo_layout_extrat  = "Dia Transaá∆o" /*l_dia_transacao*/ 
            no-lock no-error.
        if  not avail mapa_tip_reg_extrat
        then do:
            run pi_imprime_erro_importacao (Input "Dia Transaá∆o" /*l_dia_transacao*/  + chr(10) + "Mapeamento Tipo Reg Extrato") /*pi_imprime_erro_importacao*/.
        end /* if */.

        find mapa_tip_reg_extrat
            where mapa_tip_reg_extrat.cod_layout_extrat         = layout_extrat.cod_layout_extrat
            and   mapa_tip_reg_extrat.num_seq_reg_layout_extrat = tip_reg_layout_extrat.num_seq_reg_layout_extrat
            and   mapa_tip_reg_extrat.ind_contdo_layout_extrat  = "Màs Transaá∆o" /*l_mes_transacao*/ 
            no-lock no-error.
        if  not avail mapa_tip_reg_extrat
        then do:
            run pi_imprime_erro_importacao (Input "Màs Transaá∆o" /*l_mes_transacao*/  + chr(10) + "Mapeamento Tipo Reg Extrato") /*pi_imprime_erro_importacao*/.
        end /* if */.

        find mapa_tip_reg_extrat
            where mapa_tip_reg_extrat.cod_layout_extrat         = layout_extrat.cod_layout_extrat
            and   mapa_tip_reg_extrat.num_seq_reg_layout_extrat = tip_reg_layout_extrat.num_seq_reg_layout_extrat
            and   mapa_tip_reg_extrat.ind_contdo_layout_extrat  = "Ano Transaá∆o" /*l_ano_transacao*/ 
            no-lock no-error.
        if  not avail mapa_tip_reg_extrat
        then do:
            run pi_imprime_erro_importacao (Input "Ano Transaá∆o" /*l_ano_transacao*/  + chr(10) + "Mapeamento Tipo Reg Extrato") /*pi_imprime_erro_importacao*/.
        end /* if */.

        find mapa_tip_reg_extrat
            where mapa_tip_reg_extrat.cod_layout_extrat         = layout_extrat.cod_layout_extrat
            and   mapa_tip_reg_extrat.num_seq_reg_layout_extrat = tip_reg_layout_extrat.num_seq_reg_layout_extrat
            and   mapa_tip_reg_extrat.ind_contdo_layout_extrat  = "Documento" /*l_documento*/ 
            no-lock no-error.
        if  not avail mapa_tip_reg_extrat
        then do:
            run pi_imprime_erro_importacao (Input "Documento" /*l_documento*/  + chr(10) + "Mapeamento Tipo Reg Extrato") /*pi_imprime_erro_importacao*/.
        end /* if */.

        find mapa_tip_reg_extrat
            where mapa_tip_reg_extrat.cod_layout_extrat         = layout_extrat.cod_layout_extrat
            and   mapa_tip_reg_extrat.num_seq_reg_layout_extrat = tip_reg_layout_extrat.num_seq_reg_layout_extrat
            and   mapa_tip_reg_extrat.ind_contdo_layout_extrat  = "Hist¢rico" /*l_historico*/ 
            no-lock no-error.
        if  not avail mapa_tip_reg_extrat
        then do:
            run pi_imprime_erro_importacao (Input "Hist¢rico" /*l_historico*/  + chr(10) + "Mapeamento Tipo Reg Extrato") /*pi_imprime_erro_importacao*/.
        end /* if */.

        find mapa_tip_reg_extrat
            where mapa_tip_reg_extrat.cod_layout_extrat         = layout_extrat.cod_layout_extrat
            and   mapa_tip_reg_extrat.num_seq_reg_layout_extrat = tip_reg_layout_extrat.num_seq_reg_layout_extrat
            and   mapa_tip_reg_extrat.ind_contdo_layout_extrat  = "Valor Transaá∆o" /*l_valor_transacao*/ 
            no-lock no-error.
        if  not avail mapa_tip_reg_extrat
        then do:
            run pi_imprime_erro_importacao (Input "Valor Transaá∆o" /*l_valor_transacao*/  + chr(10) + "Mapeamento Tipo Reg Extrato") /*pi_imprime_erro_importacao*/.
        end /* if */.

        find mapa_tip_reg_extrat
            where mapa_tip_reg_extrat.cod_layout_extrat         = layout_extrat.cod_layout_extrat
            and   mapa_tip_reg_extrat.num_seq_reg_layout_extrat = tip_reg_layout_extrat.num_seq_reg_layout_extrat
            and   mapa_tip_reg_extrat.ind_contdo_layout_extrat  = "Tipo Transaá∆o" /*l_tipo_transacao*/ 
            no-lock no-error.
        if  not avail mapa_tip_reg_extrat
        then do:
            run pi_imprime_erro_importacao (Input "Tipo Transaá∆o" /*l_tipo_transacao*/  + chr(10) + "Mapeamento Tipo Reg Extrato") /*pi_imprime_erro_importacao*/.
        end /* if */.
    end.

    /* * SALDO FINAL **/

    find tip_reg_layout_extrat
        where tip_reg_layout_extrat.cod_layout_extrat         = layout_extrat.cod_layout_extrat
        and   tip_reg_layout_extrat.ind_tip_reg_layout_extrat = "Sdo Final" /*l_sdo_final*/ 
        no-lock no-error.
    if  avail tip_reg_layout_extrat
    then do:
        find mapa_tip_reg_extrat
            where mapa_tip_reg_extrat.cod_layout_extrat 	= layout_extrat.cod_layout_extrat
            and   mapa_tip_reg_extrat.num_seq_reg_layout_extrat = tip_reg_layout_extrat.num_seq_reg_layout_extrat
            and   mapa_tip_reg_extrat.ind_contdo_layout_extrat  = "Dia Sdo Final" /*l_dia_sdo_final*/ 
            no-lock no-error.
        if  not avail mapa_tip_reg_extrat
        then do:
            run pi_imprime_erro_importacao (Input "Dia Sdo Final" /*l_dia_sdo_final*/  + chr(10) + "Mapeamento Tipo Reg Extrato") /*pi_imprime_erro_importacao*/.
        end /* if */.

        find mapa_tip_reg_extrat
            where mapa_tip_reg_extrat.cod_layout_extrat         = layout_extrat.cod_layout_extrat
            and   mapa_tip_reg_extrat.num_seq_reg_layout_extrat = tip_reg_layout_extrat.num_seq_reg_layout_extrat
            and   mapa_tip_reg_extrat.ind_contdo_layout_extrat  = "Màs Sdo Final" /*l_mes_sdo_final*/ 
            no-lock no-error.
        if  not avail mapa_tip_reg_extrat
        then do:
            run pi_imprime_erro_importacao (Input "Màs Sdo Final" /*l_mes_sdo_final*/  + chr(10) + "Mapeamento Tipo Reg Extrato") /*pi_imprime_erro_importacao*/.
        end /* if */.

        find mapa_tip_reg_extrat
            where mapa_tip_reg_extrat.cod_layout_extrat         = layout_extrat.cod_layout_extrat
            and   mapa_tip_reg_extrat.num_seq_reg_layout_extrat = tip_reg_layout_extrat.num_seq_reg_layout_extrat
            and   mapa_tip_reg_extrat.ind_contdo_layout_extrat  = "Ano Sdo Final" /*l_ano_sdo_final*/ 
            no-lock no-error.
        if  not avail mapa_tip_reg_extrat
        then do:
            run pi_imprime_erro_importacao (Input "Ano Sdo Final" /*l_ano_sdo_final*/  + chr(10) + "Mapeamento Tipo Reg Extrato") /*pi_imprime_erro_importacao*/.
        end /* if */.

        find mapa_tip_reg_extrat
            where mapa_tip_reg_extrat.cod_layout_extrat         = layout_extrat.cod_layout_extrat
            and   mapa_tip_reg_extrat.num_seq_reg_layout_extrat = tip_reg_layout_extrat.num_seq_reg_layout_extrat
            and   mapa_tip_reg_extrat.ind_contdo_layout_extrat  = "Valor Sdo Final" /*l_valor_sdo_final*/ 
            no-lock no-error.
        if  not avail mapa_tip_reg_extrat
        then do:
            run pi_imprime_erro_importacao (Input "Valor Sdo Final" /*l_valor_sdo_final*/  + chr(10) + "Mapeamento Tipo Reg Extrato") /*pi_imprime_erro_importacao*/.
        end /* if */.

        find mapa_tip_reg_extrat
            where mapa_tip_reg_extrat.cod_layout_extrat         = layout_extrat.cod_layout_extrat
            and   mapa_tip_reg_extrat.num_seq_reg_layout_extrat = tip_reg_layout_extrat.num_seq_reg_layout_extrat
            and   mapa_tip_reg_extrat.ind_contdo_layout_extrat  = "Situaá∆o Saldo" /*l_situacao_saldo*/ 
            no-lock no-error.
        if  not avail mapa_tip_reg_extrat
        then do:
            run pi_imprime_erro_importacao (Input "Situaá∆o Saldo" /*l_situacao_saldo*/  + chr(10) + "Mapeamento Tipo Reg Extrato") /*pi_imprime_erro_importacao*/.
        end /* if */.
    end /* else */.

    /* * TRAILLER **/
    if  layout_extrat.log_utiliz_trailler_extrat
    then do:
    /* ***
        find tip_reg_layout_extrat
            where tip_reg_layout_extrat.cod_layout_extrat 	      = layout_extrat.cod_layout_extrat
            and   tip_reg_layout_extrat.ind_tip_reg_layout_extrat = @%(l_trailler)
            no-lock no-error.
        @if(not avail tip_reg_layout_extrat)
            @run (pi_imprime_erro_importacao(@%(l_trailler) + chr(10) + @fx_tabpro(tip_reg_layout_extrat,label))).
        @end_if().
        @else()
            find mapa_tip_reg_extrat
                where mapa_tip_reg_extrat.cod_layout_extrat 	    = layout_extrat.cod_layout_extrat
                and   mapa_tip_reg_extrat.num_seq_reg_layout_extrat = tip_reg_layout_extrat.num_seq_reg_layout_extrat
                and   mapa_tip_reg_extrat.ind_contdo_layout_extrat  = @%(l_qtd_contas)
                no-lock no-error.
            @if(not avail mapa_tip_reg_extrat)
                @run (pi_imprime_erro_importacao(@%(l_qtd_contas) + chr(10) + @fx_tabpro(mapa_tip_reg_extrat,label))).
            @end_if().

            find mapa_tip_reg_extrat
                where mapa_tip_reg_extrat.cod_layout_extrat 	    = layout_extrat.cod_layout_extrat
                and   mapa_tip_reg_extrat.num_seq_reg_layout_extrat = tip_reg_layout_extrat.num_seq_reg_layout_extrat
                and   mapa_tip_reg_extrat.ind_contdo_layout_extrat  = @%(l_qtd_lancamentos)
                no-lock no-error.
            @if(not avail mapa_tip_reg_extrat)
                @run (pi_imprime_erro_importacao(@%(l_qtd_lancamentos) + chr(10) + @fx_tabpro(mapa_tip_reg_extrat,label))).
            @end_if().

            find mapa_tip_reg_extrat
                where mapa_tip_reg_extrat.cod_layout_extrat         = layout_extrat.cod_layout_extrat
                and   mapa_tip_reg_extrat.num_seq_reg_layout_extrat = tip_reg_layout_extrat.num_seq_reg_layout_extrat
                and   mapa_tip_reg_extrat.ind_contdo_layout_extrat  = @%(l_total_debitos)
                no-lock no-error.
            @if(not avail mapa_tip_reg_extrat)
                @run (pi_imprime_erro_importacao(@%(l_total_debitos) + chr(10) + @fx_tabpro(mapa_tip_reg_extrat,label))).
            @end_if().

            find mapa_tip_reg_extrat
                where mapa_tip_reg_extrat.cod_layout_extrat 	    = layout_extrat.cod_layout_extrat
                and   mapa_tip_reg_extrat.num_seq_reg_layout_extrat = tip_reg_layout_extrat.num_seq_reg_layout_extrat
                and   mapa_tip_reg_extrat.ind_contdo_layout_extrat  = @%(l_total_creditos)
                no-lock no-error.
            @if(not avail mapa_tip_reg_extrat)
                @run (pi_imprime_erro_importacao(@%(l_total_creditos) + chr(10) + @fx_tabpro(mapa_tip_reg_extrat,label))).
            @end_if().
        @end_else().
    ****/
    end.
END PROCEDURE. /* pi_criticar_dados_layout */
/*****************************************************************************
** Procedure Interna.....: pi_imprime_erro_importacao
** Descricao.............: pi_imprime_erro_importacao
** Criado por............: DALPRA
** Criado em.............: 25/02/1997 19:40:25
** Alterado por..........: fut42929
** Alterado em...........: 10/12/2008 16:46:14
*****************************************************************************/
PROCEDURE pi_imprime_erro_importacao:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_return
        as character
        format "x(40)"
        no-undo.


    /************************* Parameter Definition End *************************/


    /* Begin_Include: i_code_pi_imprime_erro_importacao_cmg909za */
    assign v_des_mensagem = "1284 - " + substitute("&1 inexistente !" /*1284*/,entry(2,p_cod_return,chr(10)))
           v_des_ajuda    = substitute("Verifique se existe uma ocorrància para o(a) &1 informado(a) no cadastro de &2." /*1284*/, entry(1,p_cod_return,chr(10)),entry(2,p_cod_return,chr(10))).

    run pi_cria_tt_row_erros (Input 1284,
                              Input v_des_mensagem,
                              Input v_des_ajuda) /*pi_cria_tt_row_erros*/.
    /* End_Include: i_code_pi_imprime_erro_importacao_cmg909za */


END PROCEDURE. /* pi_imprime_erro_importacao */
/*****************************************************************************
** Procedure Interna.....: pi_cria_tt_row_erros
** Descricao.............: pi_cria_tt_row_erros
** Criado por............: fut12234
** Criado em.............: 22/09/2008 10:06:54
** Alterado por..........: fut42929
** Alterado em...........: 30/10/2008 11:31:37
*****************************************************************************/
PROCEDURE pi_cria_tt_row_erros:

    /************************ Parameter Definition Begin ************************/

    def Input param p_num_erro
        as integer
        format ">>>>,>>9"
        no-undo.
    def Input param p_des_erro
        as character
        format "x(50)"
        no-undo.
    def Input param p_des_ajuda
        as character
        format "x(50)"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_num_seq
        as integer
        format ">>>,>>9":U
        label "SeqÅància"
        column-label "Seq"
        no-undo.


    /************************** Variable Definition End *************************/

    assign v_num_seq = 1.

    find last tt_row_errors no-lock no-error.
    if  avail tt_row_errors then
        assign v_num_seq = tt_row_errors.ttv_num_seq_erro + 1.

    create tt_row_errors.
    assign tt_row_errors.ttv_num_seq_erro = v_num_seq 
           tt_row_errors.ttv_num_erro     = p_num_erro
           tt_row_errors.ttv_des_erro     = p_des_erro
           tt_row_errors.ttv_des_param    = "" /*l_*/ 
           tt_row_errors.ttv_des_type     = "error" /*l_error*/ 
           tt_row_errors.ttv_des_help     = p_des_ajuda
           tt_row_errors.ttv_des_sub_type = "error" /*l_error*/ .

END PROCEDURE. /* pi_cria_tt_row_erros */
/*****************************************************************************
** Procedure Interna.....: pi_extrat_cta_corren_import
** Descricao.............: pi_extrat_cta_corren_import
** Criado por............: fut42929
** Criado em.............: 24/03/2009 09:32:54
** Alterado por..........: fut42929
** Alterado em...........: 01/04/2009 16:18:40
*****************************************************************************/
PROCEDURE pi_extrat_cta_corren_import:

    /************************** Buffer Definition Begin *************************/

    &if "{&emsbas_version}" >= "1.00" &then
    def buffer b_dwb_set_list
        for dwb_set_list.
    &endif


    /*************************** Buffer Definition End **************************/

    /************************* Variable Definition Begin ************************/

    def var v_cod_arq_import
        as character
        format "x(40)":U
        no-undo.
    def var v_cod_caracter
        as character
        format "x(1)":U
        no-undo.
    def var v_cod_diretorio
        as character
        format "x(8)":U
        no-undo.
    def var v_cod_dwb_set
        as character
        format "x(25)":U
        no-undo.
    def var v_cod_dwb_set_final
        as character
        format "x(50)":U
        no-undo.
    def var v_cod_dwb_set_initial
        as character
        format "x(50)":U
        no-undo.
    def var v_cod_dwb_set_parameters_1
        as character
        format "x(2000)":U
        no-undo.
    def var v_cod_dwb_set_parameters_2
        as character
        format "x(2000)":U
        no-undo.
    def var v_cod_dwb_set_parameters_3
        as character
        format "x(2000)":U
        no-undo.
    def var v_cod_dwb_set_parameters_4
        as character
        format "x(2000)":U
        no-undo.
    def var v_cod_dwb_set_parameters_5
        as character
        format "x(2000)":U
        no-undo.
    def var v_cod_dwb_set_single
        as character
        format "x(200)":U
        label "Individual"
        column-label "Individual"
        no-undo.
    def var v_cod_dwb_set_type
        as character
        format "x(8)":U
        no-undo.
    def var v_cod_extensao
        as character
        format "x(3)":U
        no-undo.
    def var v_cod_local
        as character
        format "x(1)":U
        label "Local"
        column-label "Local"
        no-undo.
    def var v_cod_prefixo
        as character
        format "x(8)":U
        no-undo.
    def var v_num_dwb_order
        as integer
        format ">>>>,>>9":U
        no-undo.
    def var v_num_entry
        as integer
        format ">>>>,>>9":U
        label "Ordem"
        column-label "Ordem"
        no-undo.


    /************************** Variable Definition End *************************/

    for each ttBankStmntImportFileParamDTO no-lock:
        if index(ttBankStmntImportFileParamDTO.importFileName,'*') = 0 then do:
                if(search(ttBankStmntImportFileParamDTO.importFileName) = ?) then do:
                run pi_cria_tt_row_erros (Input 1433,
                                          Input "Arquivo informado n∆o encontrado !" /*1433*/,
                                          Input substitute("Verifique se a localizaá∆o do arquivo &1 est† correta." /*1433*/, ttBankStmntImportFileParamDTO.importFileName)) /*pi_cria_tt_row_erros*/.    
                return "NOK" /*l_nok*/ .
            end.
            create tt_file_list.
            assign tt_file_list.ttv_nom_filename = ttBankStmntImportFileParamDTO.importFileName.
        end.
        else do:
            run prgint/utb/utb940za.py (input ttBankStmntImportFileParamDTO.importFileName,
                                        output table tt_file_list).
        end.
    end. /* for each ttBankStmntImportFileParamDTO*/

END PROCEDURE. /* pi_extrat_cta_corren_import */
/*****************************************************************************
** Procedure Interna.....: pi_validar_dados_importacao_flex
** Descricao.............: pi_validar_dados_importacao_flex
** Criado por............: fut42929
** Criado em.............: 26/03/2009 08:59:25
** Alterado por..........: fut42929
** Alterado em...........: 01/04/2009 14:25:08
*****************************************************************************/
PROCEDURE pi_validar_dados_importacao_flex:

    assign v_nom_filename_import = tt_file_list.ttv_nom_filename
           v_log_erro         = no.
    for each ttBankStmntImportFileParamDTO no-lock:

        find layout_extrat no-lock
            where layout_extrat.cod_layout_extrat = ttBankStmntImportFileParamDTO.bankStatementLayout no-error.    
        if  not avail layout_extrat
        then do:
            assign v_log_erro = yes
                   v_cod_mensagem = string("Layout Extrato Conta Corrente")
                   v_des_mensagem = substitute("&1 inexistente !" /*2567*/, v_cod_mensagem)
                   v_des_ajuda    = substitute("Consulte o cadastro de &2." /*2567*/, "Layout Extrato Conta Corrente" ).
            run pi_cria_tt_row_erros (Input 2567,
                                      Input v_des_mensagem,
                                      Input v_des_ajuda) /*pi_cria_tt_row_erros*/.        
            return "NOK" /*l_nok*/ .    
        end.
        if layout_extrat.num_pos_prim_ident_extrat = 0 
            and layout_extrat.num_pos_segndo_ident_extrat = 0 then do:
            run pi_cria_tt_row_erros (Input 13159,
                                      Input "Identificador inexistente !" /*13159*/,
                                      Input "N∆o ser† poss°vel realizar a Importaá∆o de Extrato, pois n∆o foi informado a posiá∆o do 1o e 2o identificador do layout." /*13159*/) /*pi_cria_tt_row_erros*/.
            assign v_log_erro = yes.
            return "NOK" /*l_nok*/ .
        end.
        if layout_extrat.num_tam_prim_ident_extrat = 0 
            and layout_extrat.num_tam_segndo_ident_extrat = 0 then do:
            run pi_cria_tt_row_erros (Input 13158,
                                      Input "Identificador inexistente !" /*13158*/,
                                      Input "N∆o ser† poss°vel realizar a Importaá∆o de Extrato,  pois n∆o foi informado o tamanho do 1o e 2o identificador do layout." /*13158*/) /*pi_cria_tt_row_erros*/.
            assign v_log_erro = yes.
            return "NOK" /*l_nok*/ .
        end.

        /* * Verifica se algum campo nao foi informado no layout extrato **/
        run pi_criticar_dados_layout /*pi_criticar_dados_layout*/.

        if  tt_file_list.ttv_nom_filename = ?
        then do:
            if  v_log_erro = no
            then do:
                assign v_log_erro = yes.
            end.
            run pi_cria_tt_row_erros (Input 1433,
                                      Input "Arquivo informado n∆o encontrado !" /*1433*/,
                                      Input substitute("Verifique se a localizaá∆o do arquivo &1 est† correta." /*1433*/, tt_file_list.ttv_nom_filename)) /*pi_cria_tt_row_erros*/.
        end.

        if  v_log_erro
        then do:
            return "NOK" /*l_nok*/ .
        end.

        assign v_cod_dir_temp = string(session:temp-directory + 'EXT' + string(time) + '.tmp').    

        /* ----- Direcionar para o Arquivo Ö Importar -----*/
        input stream s_import from value(v_nom_filename_import) no-echo.

        assign v_cod_prim_ident        = "" /*l_null*/ 
               v_cod_segndo_ident      = "" /*l_null*/ 
               v_cod_tip_reg           = "" /*l_null*/ 
               v_cod_prim_ident_ant    = "" /*l_null*/ 
               v_cod_segndo_ident_ant  = "" /*l_null*/ 
               v_cod_tip_reg_ant       = "" /*l_null*/ 
               v_cod_cta_corren_ant    = "" /*l_null*/ 
               v_cod_cta_corren_layout = "" /*l_null*/ 
               v_num_total             = 0
               v_num_count             = 0
               v_num_count_percent     = 0.

        block:
        repeat:
            import stream s_import unformatted v_cod_reg_import.
            assign v_num_total = v_num_total + 1.
        end /* repeat block */.

        /* ----- redirecionar para o Arquivo Ö Importar -----*/
        input stream s_import from value(v_nom_filename_import) no-echo.

        return "" /*l_null*/ .
    end.           
END PROCEDURE. /* pi_validar_dados_importacao_flex */
/*****************************************************************************
** Procedure Interna.....: pi_tratar_tip_reg_extrat_import_flex
** Descricao.............: pi_tratar_tip_reg_extrat_import_flex
** Criado por............: fut42929
** Criado em.............: 26/03/2009 11:47:47
** Alterado por..........: fut42929
** Alterado em...........: 01/04/2009 14:30:54
*****************************************************************************/
PROCEDURE pi_tratar_tip_reg_extrat_import_flex:

    /************************* Variable Definition Begin ************************/

    def var v_cod_aux                        as character       no-undo. /*local*/
    def var v_num_count                      as integer         no-undo. /*local*/


    /************************** Variable Definition End *************************/

    assign v_num_pos_layout        = 0
           v_num_tam_layout_extrat = 0.

    find tip_reg_layout_extrat no-lock
        where tip_reg_layout_extrat.cod_layout_extrat       = layout_extrat.cod_layout_extrat
        and   tip_reg_layout_extrat.cod_prim_ident_extrat   = v_cod_prim_ident
        and   tip_reg_layout_extrat.cod_segndo_ident_extrat = v_cod_segndo_ident
        no-error.
    if  not avail tip_reg_layout_extrat
    then do:
        if  v_log_erro = no
        then do:
            assign v_log_erro = yes.
        end /* if */.
        assign v_cod_aux = " Primeiro Identificador:" /*l_primeiro_identific*/   + v_cod_prim_ident + " Segundo Identificador:" /*l_segundo_identific*/  + v_cod_segndo_ident
               v_des_mensagem = substitute("&1 inexistente !" /*1284*/,'Tipo Registro Extrato')
               v_des_ajuda    = substitute("Verifique se existe uma ocorrància para o(a) &1 informado(a) no cadastro de &2." /*1284*/, v_cod_aux ,'Tipo Registro Extrato').
        run pi_cria_tt_row_erros (Input 1284,
                                  Input v_des_mensagem,
                                  Input v_des_ajuda) /*pi_cria_tt_row_erros*/.
        return "NOK" /*l_nok*/ .  
    end /* if */.           
    assign v_cod_tip_reg   = tip_reg_layout_extrat.ind_tip_reg_layout_extrat
           v_num_count_aux = 0.

    mapa:
    for each mapa_tip_reg_extrat no-lock
        where mapa_tip_reg_extrat.cod_layout_extrat         = layout_extrat.cod_layout_extrat
        and   mapa_tip_reg_extrat.num_seq_reg_layout_extrat = tip_reg_layout_extrat.num_seq_reg_layout_extrat:

        assign v_num_count_aux                          = v_num_count_aux + 1
               v_num_pos_layout[v_num_count_aux]        = mapa_tip_reg_extrat.num_pos_contdo_extrat
               v_num_tam_layout_extrat[v_num_count_aux] = mapa_tip_reg_extrat.num_tam_contdo_extrat
               v_cod_contdo_extrat[v_num_count_aux]     = mapa_tip_reg_extrat.ind_contdo_layout_extrat.

    end.

    return "OK" /*l_ok*/ .       
END PROCEDURE. /* pi_tratar_tip_reg_extrat_import_flex */
/*****************************************************************************
** Procedure Interna.....: pi_imprime_erro_importacao_flex
** Descricao.............: pi_imprime_erro_importacao_flex
** Criado por............: fut42929
** Criado em.............: 26/03/2009 17:45:14
** Alterado por..........: fut42929
** Alterado em...........: 12/05/2009 10:07:32
*****************************************************************************/
PROCEDURE pi_imprime_erro_importacao_flex:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_return
        as character
        format "x(40)"
        no-undo.


    /************************* Parameter Definition End *************************/

    assign v_des_mensagem = substitute("As posiá‰es mapeadas para o(a) &1 contÇm &2 !" /*4285*/,entry(1,p_cod_return,chr(10)),entry(2,p_cod_return,chr(10)))
           v_des_ajuda    = substitute("No layout do extrato banc†rio a posiá∆o e o" + chr(10) +
    "tamanho do campo &1 devem ser corrigidos." + chr(10) +
    "" /*4285*/, entry(1,p_cod_return,chr(10))).

    run pi_cria_tt_row_erros (Input 4285,
                              Input v_des_mensagem,
                              Input v_des_ajuda) /*pi_cria_tt_row_erros*/.
END PROCEDURE. /* pi_imprime_erro_importacao_flex */
/*****************************************************************************
** Procedure Interna.....: pi_valida_cta_corren_importacao_flex
** Descricao.............: pi_valida_cta_corren_importacao_flex
** Criado por............: fut42929
** Criado em.............: 27/03/2009 09:58:22
** Alterado por..........: fut42929
** Alterado em...........: 27/03/2009 11:16:55
*****************************************************************************/
PROCEDURE pi_valida_cta_corren_importacao_flex:

    if not avail cta_corren then do:
        assign v_log_valid_cta_corren = yes.
        return.
    end.    

    for each ttBankStmntImportFileParamDTO no-lock:
        if  ttBankStmntImportFileParamDTO.setType = 1 /* individual */
        then do:
            if  cta_corren.cod_cta_corren <> ttBankStmntImportFileParamDTO.chkAccount
            then do:
               return "9572".
            end.
        end.
            else do:
            if  cta_corren.cod_cta_corren < ttBankStmntImportFileParamDTO.startChkAccount
            or   cta_corren.cod_cta_corren >ttBankStmntImportFileParamDTO.endChkAccount
            then do:
                 return "9575".
            end.
        end.

    end.

    return "" /*l_null*/ .
END PROCEDURE. /* pi_valida_cta_corren_importacao_flex */
/*****************************************************************************
** Procedure Interna.....: pi_retornar_sit_movimen_modul
** Descricao.............: pi_retornar_sit_movimen_modul
** Criado por............: Rovina
** Criado em.............: // 
** Alterado por..........: 
** Alterado em...........: 28/09/1995 13:58:38
*****************************************************************************/
PROCEDURE pi_retornar_sit_movimen_modul:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_modul_dtsul
        as character
        format "x(3)"
        no-undo.
    def Input param p_cod_unid_organ
    &IF "{&emsfin_version}" >= "" AND "{&emsfin_version}" < "5.07A" &THEN
        as character
        format "x(3)"
    &ENDIF
    &IF "{&emsfin_version}" >= "5.07A" AND "{&emsfin_version}" < "9.99" &THEN
        as Character
        format "x(5)"
    &ENDIF
        no-undo.
    def Input param p_dat_refer_sit
        as date
        format "99/99/9999"
        no-undo.
    def Input param p_des_sit_movimen_ent
        as character
        format "x(40)"
        no-undo.
    def output param p_des_sit_movimen_mod
        as character
        format "x(40)"
        no-undo.


    /************************* Parameter Definition End *************************/

    assign p_des_sit_movimen_mod = "".
    situacao:
    for each sit_movimen_modul no-lock
     where sit_movimen_modul.cod_modul_dtsul = p_cod_modul_dtsul
       and sit_movimen_modul.cod_unid_organ = p_cod_unid_organ
       and sit_movimen_modul.dat_inic_sit_movimen <= p_dat_refer_sit
       and sit_movimen_modul.dat_fim_sit_movimen >= p_dat_refer_sit /*cl_retornar_sit_movimen_modul of sit_movimen_modul*/:
        if  p_des_sit_movimen_mod = ""
        then do:
            assign p_des_sit_movimen_mod = sit_movimen_modul.ind_sit_movimen.
        end /* if */.
        else do:
            assign p_des_sit_movimen_mod = p_des_sit_movimen_mod + "," + sit_movimen_modul.ind_sit_movimen.
        end /* else */.
    end /* for situacao */.

END PROCEDURE. /* pi_retornar_sit_movimen_modul */
/*****************************************************************************
** Procedure Interna.....: pi_tratar_sdo_inic_layout_flex
** Descricao.............: pi_tratar_sdo_inic_layout_flex
** Criado por............: fut42929
** Criado em.............: 27/03/2009 11:24:40
** Alterado por..........: fut42929
** Alterado em...........: 25/06/2009 17:41:12
*****************************************************************************/
PROCEDURE pi_tratar_sdo_inic_layout_flex:

    find cta_corren 
        where cta_corren.cod_banco             = v_cod_banco
        and   cta_corren.cod_agenc_bcia        = v_cod_agenc_bcia
        and   cta_corren.cod_cta_corren_bco    = v_cod_cta_corren_layout 
        and   cta_corren.cod_digito_cta_corren = v_cod_digito_cta_corren
        no-lock no-error.

    assign v_num_extrat_cta_corren_ant = 0
           v_num_quant_cta             = 1
           v_num_quant_lancto          = 0
           v_val_soma_cr               = 0
           v_val_soma_db               = 0.

    find last extrat_cta_corren
        where extrat_cta_corren.cod_cta_corren = cta_corren.cod_cta_corren
        no-lock no-error.
    if  avail extrat_cta_corren
    then do:
        assign v_num_extrat_cta_corren_ant = extrat_cta_corren.num_extrat_cta_corren.
    end.
    assign v_nom_filename_import = replace(v_nom_filename_import,"~\","~/").

    if v_dat_geracao = ? then do:
        assign v_des_mensagem = substitute("Header n∆o localizado !" /*11708*/)
              v_des_ajuda    = substitute("N∆o foi localizado header, necess†rio para a atualizaá∆o da data de geraá∆o do extrato banc†rio." /*11708*/).
        run pi_cria_tt_row_erros (Input 11708,
                                  Input substitute("Header n∆o localizado !" /*11708*/, v_cod_mensagem),
                                  Input "N∆o foi localizado header, necess†rio para a atualizaá∆o da data de geraá∆o do extrato banc†rio." /*11708*/) /*pi_cria_tt_row_erros*/.       
        return "NOK" /*l_nok*/ .
    end.

    create extrat_cta_corren.
    assign extrat_cta_corren.cod_cta_corren              = cta_corren.cod_cta_corren
           extrat_cta_corren.num_extrat_cta_corren       = v_num_extrat_cta_corren_ant + 1
           extrat_cta_corren.dat_gerac_movto             = v_dat_geracao
           v_num_extrat_cta_corren                       = extrat_cta_corren.num_extrat_cta_corren.
           v_log_exist_extrat                            = yes.
    assign extrat_cta_corren.des_refer_extrat_cta_corren = GetEntryField(num-entries(v_nom_filename_import,"~/"), v_nom_filename_import,"~/").

    data:
    do v_num_count = 1 to v_num_count_aux:

        if  v_cod_contdo_extrat[v_num_count] = "Dia Sdo Inicial" /*l_dia_sdo_inicial*/ 
        then do:
            assign v_num_dia = int(substring(v_cod_reg_import,v_num_pos_layout[v_num_count],
                                                          v_num_tam_layout_extrat[v_num_count])) no-error.
            if  error-status:error
            then do:
                run pi_imprime_erro_importacao_flex (Input "Dia Sdo Inicial" /*l_dia_sdo_inicial*/  + chr(10) + "Caracter" /*l_caracter*/) /*pi_imprime_erro_importacao_flex*/.
                assign error-status:error = no.
                return "NOK" /*l_nok*/ .
            end.
        end.
        if  v_cod_contdo_extrat[v_num_count] = "Màs Sdo Inicial" /*l_mes_sdo_inicial*/ 
        then do:
            assign v_num_mes = int(substring(v_cod_reg_import,v_num_pos_layout[v_num_count],
                                                          v_num_tam_layout_extrat[v_num_count])) no-error.
            if  error-status:error
            then do:
                run pi_imprime_erro_importacao_flex (Input "Màs Sdo Inicial" /*l_mes_sdo_inicial*/  + chr(10) + "Caracter" /*l_caracter*/) /*pi_imprime_erro_importacao_flex*/.
                assign error-status:error = no.
                return "NOK" /*l_nok*/ .
            end.
        end.
        if  v_cod_contdo_extrat[v_num_count] = "Ano Sdo Inicial" /*l_ano_sdo_inicial*/ 
        then do:
            assign v_num_ano = int(substr(v_cod_reg_import,v_num_pos_layout[v_num_count],
                                           v_num_tam_layout_extrat[v_num_count])) no-error.
            if  error-status:error
            then do:
                run pi_imprime_erro_importacao_flex (Input "Ano Sdo Inicial" /*l_ano_sdo_inicial*/  + chr(10) + "Caracter" /*l_caracter*/) /*pi_imprime_erro_importacao_flex*/.
                assign error-status:error = no.
                return "NOK" /*l_nok*/ .
            end.
            if v_num_tam_layout_extrat[v_num_count] <> 4 then do:
               assign v_num_ano = v_num_ano + 2000.
            end.
        end.
        if  v_cod_contdo_extrat[v_num_count] = "Valor Sdo Inicial" /*l_valor_sdo_inicial*/ 
        then do:
            assign extrat_cta_corren.val_extrat_cta_corren_inic = dec(substring(v_cod_reg_import,v_num_pos_layout[v_num_count],
                                                                  v_num_tam_layout_extrat[v_num_count])) / 100 no-error.
            if  error-status:error
            then do:
                run pi_imprime_erro_importacao_flex (Input "Valor Sdo Inicial" /*l_valor_sdo_inicial*/  + chr(10) + "Caracter" /*l_caracter*/) /*pi_imprime_erro_importacao_flex*/.
                assign error-status:error = no.
                return "NOK" /*l_nok*/ .
            end.
        end.
        if  v_cod_contdo_extrat[v_num_count] = "Situaá∆o Saldo" /*l_situacao_saldo*/ 
        then do:
            assign v_cod_sit = trim(substring(v_cod_reg_import,v_num_pos_layout[v_num_count],
                                                          v_num_tam_layout_extrat[v_num_count])).
        end.
    end /* do data */.

    if  tip_reg_layout_extrat.log_livre_1 then do:
        if  v_cod_sit = tip_reg_layout_extrat.cod_carac_db_extrat
        then do:
            assign extrat_cta_corren.val_extrat_cta_corren_inic =
                   extrat_cta_corren.val_extrat_cta_corren_inic * -1.
        end.
    end.
    else do:
        if  tip_reg_layout_extrat.cod_carac_db_extrat > v_cod_sit
        then do:
            assign extrat_cta_corren.val_extrat_cta_corren_inic =
                   extrat_cta_corren.val_extrat_cta_corren_inic * -1.
        end.
    end.

    assign v_val_sdo_inicial_import = extrat_cta_corren.val_extrat_cta_corren_inic.

    assign extrat_cta_corren.dat_extrat_cta_corren_inic = date(v_num_mes,v_num_dia,v_num_ano) no-error.                  

    /* Permite importar extratos de per°odos j† congelados, validaá∆o ocorre no in°cio de cada màs pois o banco envia movimentos retroativos **
    /* --- Extrato deve estar em per°odo aberto  ---*/
    run pi_retornar_sit_movimen_modul(input "CMG" /*l_cmg*/ ,
                                      input v_cod_empres_usuar,
                                      input extrat_cta_corren.dat_extrat_cta_corren_inic,
                                      input "Habilitado" /*l_habilitado*/ ,
                                      output v_cod_return).
    if not can-do(v_cod_return, "Habilitado" /*l_habilitado*/ ) then do:
        assign v_des_mensagem = substitute("M¢dulo &1 n∆o habilitado para movimentaá∆o em &2 !" /*4153*/, "CMG" /*l_cmg*/ , extrat_cta_corren.dat_extrat_cta_corren_inic)
               v_des_ajuda    = "Informe uma data dentro de um per°odo habilitado para m¢dulo ou altere a situaá∆o do per°odo para habilitado." /*4153*/.
        run pi_cria_tt_row_erros (Input 4153,
                                  Input v_des_mensagem,
                                  Input v_des_ajuda) /*pi_cria_tt_row_erros*/.       
        return "NOK" /*l_nok*/ .
    end.
    ***/

    if  error-status:error
    then do:
        run pi_imprime_erro_importacao_flex (Input "Data saldo inicial" /*l_data_saldo_inicial*/  + chr(10) + "caracter incorreto" /*l_caracter_incorreto*/) /*pi_imprime_erro_importacao_flex*/.
        assign error-status:error = no.
        return "NOK" /*l_nok*/ .
    end.
    for each ttBankStmntImportExecParamDTO no-lock:
        if  ttBankStmntImportExecParamDTO.validateDate = true then do:
            find first b_extrat_cta_corren
                 where b_extrat_cta_corren.cod_cta_corren              = cta_corren.cod_cta_corren
                 and   b_extrat_cta_corren.dat_extrat_cta_corren_inic <= extrat_cta_corren.dat_extrat_cta_corren_inic
                 and   b_extrat_cta_corren.dat_extrat_cta_corren_fim  >= extrat_cta_corren.dat_extrat_cta_corren_inic
                 and   recid(b_extrat_cta_corren)                     <> recid(extrat_cta_corren) no-lock no-error.
            if  avail b_extrat_cta_corren then do:
                assign v_des_mensagem = substitute("Data inicial coincide com a faixa de outro extrato." /*12299*/)
                       v_des_ajuda    = substitute("A data inicial &1 do extrato que est† sendo importado coincide com a faixa de datas (&2 - &3) do extrato &4 da conta corrente &5." /*12299*/,extrat_cta_corren.dat_extrat_cta_corren_inic, b_extrat_cta_corren.dat_extrat_cta_corren_inic, b_extrat_cta_corren.dat_extrat_cta_corren_fim,b_extrat_cta_corren.num_extrat_cta_corren,b_extrat_cta_corren.cod_cta_corren).
                run pi_cria_tt_row_erros (Input 12299,
                                          Input v_des_mensagem,
                                          Input v_des_ajuda) /*pi_cria_tt_row_erros*/.              

                return "NOK" /*l_nok*/ .
                /* else do:

                     @cx_question(12298,ync,extrat_cta_corren.dat_extrat_cta_corren_inic, b_extrat_cta_corren.dat_extrat_cta_corren_inic, b_extrat_cta_corren.dat_extrat_cta_corren_fim,b_extrat_cta_corren.num_extrat_cta_corren,b_extrat_cta_corren.cod_cta_corren).
                     if v_log_answer <> yes then  return @%(l_nok). 
                end.*/
            end.
        end.

        if ttBankStmntImportExecParamDTO.validateReference = true then do:
           find first b_extrat_cta_corren
                where b_extrat_cta_corren.cod_cta_corren              = cta_corren.cod_cta_corren
                and   recid(b_extrat_cta_corren)                     <> recid(extrat_cta_corren)
                and   b_extrat_cta_corren.des_refer_extrat_cta_corren = GetEntryField(num-entries(v_nom_filename_import,"~/"), v_nom_filename_import,"~/") no-lock no-error.
           if avail b_extrat_cta_corren then do:
              assign v_des_mensagem = substitute("J† existe um extrato com esta referància !" /*12611*/)
                     v_des_ajuda    = substitute("J† existe um extrato importado com a mesma referància." /*12611*/,extrat_cta_corren.dat_extrat_cta_corren_inic, b_extrat_cta_corren.dat_extrat_cta_corren_inic, b_extrat_cta_corren.dat_extrat_cta_corren_fim,b_extrat_cta_corren.num_extrat_cta_corren,b_extrat_cta_corren.cod_cta_corren).
              run pi_cria_tt_row_erros (Input 12611,
                                        Input substitute("J† existe um extrato com esta referància !" /*12611*/, v_des_mensagem),
                                        Input substitute("J† existe um extrato importado com a mesma referància." /*12611*/, v_des_ajuda)) /*pi_cria_tt_row_erros*/.                     
              return "NOK" /*l_nok*/ .
           end.
        end.
    end.

    return "" /*l_null*/ .
END PROCEDURE. /* pi_tratar_sdo_inic_layout_flex */
/*****************************************************************************
** Procedure Interna.....: pi_tratar_transacao_layout_flex
** Descricao.............: pi_tratar_transacao_layout_flex
** Criado por............: fut42929
** Criado em.............: 30/03/2009 08:54:38
** Alterado por..........: fut42929
** Alterado em...........: 25/06/2009 17:43:36
*****************************************************************************/
PROCEDURE pi_tratar_transacao_layout_flex:

    /************************* Variable Definition Begin ************************/

    def var v_val_transacao
        as decimal
        format "->>,>>>,>>>,>>9.9999999999":U
        decimals 10
        no-undo.
    def var v_cod_docto                      as character       no-undo. /*local*/
    def var v_cod_historico                  as character       no-undo. /*local*/
    def var v_dat_movto                      as date            no-undo. /*local*/
    def var v_num_seq_lin_extrat             as integer         no-undo. /*local*/


    /************************** Variable Definition End *************************/

    find cta_corren 
        where cta_corren.cod_banco             = v_cod_banco
        and   cta_corren.cod_agenc_bcia        = v_cod_agenc_bcia
        and   cta_corren.cod_cta_corren_bco    = v_cod_cta_corren_layout 
        and   cta_corren.cod_digito_cta_corren = v_cod_digito_cta_corren
        no-lock no-error.

    find last extrat_cta_corren
        where extrat_cta_corren.cod_cta_corren = cta_corren.cod_cta_corren
        no-lock no-error.
    if  not avail extrat_cta_corren 
    or  v_log_exist_extrat = no then do:

        find first cta_corren
            where cta_corren.cod_banco          = emscad.banco.cod_banco 
            and   cta_corren.cod_cta_corren_bco = v_cod_cta_corren_layout
            no-lock no-error.

        assign v_num_extrat_cta_corren_ant = 0
               v_num_quant_cta             = 1
               v_num_quant_lancto          = 0
               v_val_soma_cr               = 0
               v_val_soma_db               = 0.

        find last extrat_cta_corren
            where extrat_cta_corren.cod_cta_corren = cta_corren.cod_cta_corren
            no-lock no-error.
        if  avail extrat_cta_corren
        then do:
            assign v_num_extrat_cta_corren_ant = extrat_cta_corren.num_extrat_cta_corren.
        end.

        &IF DEFINED(BF_FIN_BCOS_HISTORICOS) &THEN
            block_repeat:
            repeat : 
                /* Verifica se o extrato j† existe na base hist¢rica */
                if not can-find(first his_extrat_cta_corren
                                where his_extrat_cta_corren.cod_cta_corren        = extrat_cta_corren.cod_cta_corren
                                and   his_extrat_cta_corren.num_extrat_cta_corren = v_num_extrat_cta_corren_ant + 1) THEN DO:
                    leave block_repeat.
                end.
                assign v_num_extrat_cta_corren_ant = v_num_extrat_cta_corren_ant + 1.
            end.
        &ENDIF

        assign v_nom_filename_import = replace(v_nom_filename_import,"~\","~/").

        if v_dat_geracao = ? then do:
           assign v_des_mensagem = substitute("Header n∆o localizado !" /*11708*/)
                  v_des_ajuda    = substitute("N∆o foi localizado header, necess†rio para a atualizaá∆o da data de geraá∆o do extrato banc†rio." /*11708*/).
           run pi_cria_tt_row_erros (Input 11708,
                                     Input substitute("Header n∆o localizado !" /*11708*/, v_des_mensagem),
                                     Input substitute("N∆o foi localizado header, necess†rio para a atualizaá∆o da data de geraá∆o do extrato banc†rio." /*11708*/, v_des_ajuda)) /*pi_cria_tt_row_erros*/.
           return "NOK" /*l_nok*/ .
        end.

        create extrat_cta_corren.
        assign extrat_cta_corren.cod_cta_corren              = cta_corren.cod_cta_corren
               extrat_cta_corren.num_extrat_cta_corren       = v_num_extrat_cta_corren_ant + 1
               extrat_cta_corren.dat_gerac_movto             = v_dat_geracao
               v_num_extrat_cta_corren                       = extrat_cta_corren.num_extrat_cta_corren
               v_log_exist_extrat                            = yes.
        assign extrat_cta_corren.des_refer_extrat_cta_corren = GetEntryField(num-entries(v_nom_filename_import,"~/"), v_nom_filename_import,"~/").       
    end.

    data:
    do v_num_count = 1 to v_num_count_aux:
        if  v_cod_contdo_extrat[v_num_count] = "Dia Transaá∆o" /*l_dia_transacao*/ 
        then do:
            assign v_num_dia = int(substring(v_cod_reg_import, v_num_pos_layout[v_num_count],
                                                               v_num_tam_layout_extrat[v_num_count])) no-error.
            if  error-status:error
            then do:
                run pi_imprime_erro_importacao (Input "Dia Transaá∆o" /*l_dia_transacao*/  + chr(10) + "Caracter" /*l_caracter*/) /*pi_imprime_erro_importacao*/.
                assign error-status:error = no.
                return "NOK" /*l_nok*/ .
            end.
        end.

        if  v_cod_contdo_extrat[v_num_count] = "Màs Transaá∆o" /*l_mes_transacao*/ 
        then do:
            assign v_num_mes = int(substring(v_cod_reg_import, v_num_pos_layout[v_num_count],
                                                               v_num_tam_layout_extrat[v_num_count])) no-error.
            if  error-status:error
            then do:
                run pi_imprime_erro_importacao (Input "Màs Transaá∆o" /*l_mes_transacao*/  + chr(10) + "Caracter" /*l_caracter*/) /*pi_imprime_erro_importacao*/.
                assign error-status:error = no.
                return "NOK" /*l_nok*/ .
            end.
        end.

        if  v_cod_contdo_extrat[v_num_count] = "Ano Transaá∆o" /*l_ano_transacao*/ 
        then do:
            assign v_num_ano = int(substr(v_cod_reg_import, v_num_pos_layout[v_num_count],
                                          v_num_tam_layout_extrat[v_num_count])) no-error.
            if  error-status:error
            then do:
                run pi_imprime_erro_importacao (Input "Ano Transaá∆o" /*l_ano_transacao*/  + chr(10) + "Caracter" /*l_caracter*/) /*pi_imprime_erro_importacao*/.
                assign error-status:error = no.
                return "NOK" /*l_nok*/ .
            end.
            if v_num_tam_layout_extrat[v_num_count] <> 4 then do:
               assign v_num_ano = v_num_ano + 2000.
            end.
        end.

        if  v_cod_contdo_extrat[v_num_count] = "Documento" /*l_documento*/ 
        then do:
            assign v_cod_docto = trim(substring(v_cod_reg_import, v_num_pos_layout[v_num_count],
                                                             v_num_tam_layout_extrat[v_num_count])).
        end.

        if  v_cod_contdo_extrat[v_num_count] = "Hist¢rico" /*l_historico*/ 
        then do:
            assign v_cod_historico = trim(substring(v_cod_reg_import, v_num_pos_layout[v_num_count],
                                                                 v_num_tam_layout_extrat[v_num_count])).
        end.

        if  v_cod_contdo_extrat[v_num_count] = "Valor Transaá∆o" /*l_valor_transacao*/ 
        then do:
            assign v_val_transacao = dec(substring(v_cod_reg_import, v_num_pos_layout[v_num_count],
                                                                     v_num_tam_layout_extrat[v_num_count])) / 100 no-error.
            if  error-status:error
            then do:
                run pi_imprime_erro_importacao (Input "Valor Transaá∆o" /*l_valor_transacao*/  + chr(10) + "Caracter" /*l_caracter*/) /*pi_imprime_erro_importacao*/.
                assign error-status:error = no.
                return "NOK" /*l_nok*/ .
            end.
        end.

        if  v_cod_contdo_extrat[v_num_count] = "Tipo Transaá∆o" /*l_tipo_transacao*/ 
        then do:
            assign v_cod_sit = trim(substring(v_cod_reg_import, v_num_pos_layout[v_num_count],
                                                           v_num_tam_layout_extrat[v_num_count])).
        end.

        if  v_cod_contdo_extrat[v_num_count] = "C¢digo Transaá∆o" /*l_codigo_transacao*/ 
        then do:
            assign v_cod_transacao = trim(substring(v_cod_reg_import, v_num_pos_layout[v_num_count],
                                                                 v_num_tam_layout_extrat[v_num_count])).
            find first tip_reg_extrat_excec no-lock 
                where tip_reg_extrat_excec.cod_layout_extrat         = tip_reg_layout_extrat.cod_layout_extrat 
                and   tip_reg_extrat_excec.num_seq_reg_layout_extrat = tip_reg_layout_extrat.num_seq_reg_layout_extrat
                and   tip_reg_extrat_excec.cod_tip_lancto_extrat     = v_cod_transacao no-error.
            if  avail tip_reg_extrat_excec then do:
                return "Exceá∆o" /*l_exception*/ .
            end.
        end.
    end /* do data */.

    assign v_dat_movto = date(v_num_mes,v_num_dia,v_num_ano) no-error.
    if  error-status:error
    then do:
        run pi_imprime_erro_importacao (Input "Data Transaá∆o" /*l_data_transacao*/  + chr(10) + "caracter incorreto" /*l_caracter_incorreto*/) /*pi_imprime_erro_importacao*/.
        assign error-status:error = no.
        return "NOK" /*l_nok*/ .
    end.

    assign v_num_seq_lin_extrat = 1.

    find last lin_extrat_cta_corren
        where lin_extrat_cta_corren.cod_cta_corren        = extrat_cta_corren.cod_cta_corren
        and   lin_extrat_cta_corren.num_extrat_cta_corren = extrat_cta_corren.num_extrat_cta_corren
        and   lin_extrat_cta_corren.dat_movto_cta_corren  = v_dat_movto
        no-lock no-error.
    if  avail lin_extrat_cta_corren
    then do:
        assign v_num_seq_lin_extrat = lin_extrat_cta_corren.num_seq_extrat_cta_corren + 1.
    end.

    create lin_extrat_cta_corren.
    assign lin_extrat_cta_corren.cod_cta_corren              = extrat_cta_corren.cod_cta_corren
           lin_extrat_cta_corren.num_extrat_cta_corren       = extrat_cta_corren.num_extrat_cta_corren
           lin_extrat_cta_corren.dat_movto_cta_corren        = v_dat_movto
           lin_extrat_cta_corren.num_seq_extrat_cta_corren   = v_num_seq_lin_extrat
           lin_extrat_cta_corren.val_lin_extrat_cta_corren   = v_val_transacao
           lin_extrat_cta_corren.des_histor_movto_cta_corren = v_cod_historico
           lin_extrat_cta_corren.cod_docto_movto_cta_bco     = v_cod_docto
           lin_extrat_cta_corren.cod_tip_lancto_extrat       = v_cod_transacao.


    if  tip_reg_layout_extrat.log_livre_1 then do:
        if  v_cod_sit = tip_reg_layout_extrat.cod_carac_db_extrat
        then do:
            assign lin_extrat_cta_corren.ind_fluxo_movto_cta_corren = "SAI" /*l_sai*/ 
                   v_val_soma_db = v_val_soma_db + v_val_transacao.
        end.
        else do:
            assign lin_extrat_cta_corren.ind_fluxo_movto_cta_corren = "ENT" /*l_ent*/ 
                   v_val_soma_cr = v_val_soma_cr + v_val_transacao.
        end /* else */.
    end.
    else do:
        if  tip_reg_layout_extrat.cod_carac_db_extrat > v_cod_sit
        then do:
            assign lin_extrat_cta_corren.ind_fluxo_movto_cta_corren = "SAI" /*l_sai*/ 
                   v_val_soma_db = v_val_soma_db + v_val_transacao.
        end.
        else do:
            assign lin_extrat_cta_corren.ind_fluxo_movto_cta_corren = "ENT" /*l_ent*/ 
                   v_val_soma_cr = v_val_soma_cr + v_val_transacao.
        end /* else */.
    end.
    return "" /*l_null*/ .
END PROCEDURE. /* pi_tratar_transacao_layout_flex */
/*****************************************************************************
** Procedure Interna.....: pi_tratar_trailler_layout_flex
** Descricao.............: pi_tratar_trailler_layout_flex
** Criado por............: fut42929
** Criado em.............: 30/03/2009 09:17:20
** Alterado por..........: fut42929
** Alterado em...........: 30/03/2009 09:23:12
*****************************************************************************/
PROCEDURE pi_tratar_trailler_layout_flex:

    /************************* Variable Definition Begin ************************/

    def var v_num_quant_cta_import           as integer         no-undo. /*local*/
    def var v_num_quant_lancto_import        as integer         no-undo. /*local*/


    /************************** Variable Definition End *************************/

    data:
    do v_num_count = 1 to v_num_count_aux:
    /* ***
        @if(v_cod_contdo_extrat[v_num_count] = @%(l_qtd_lancamentos))
            assign v_num_quant_lancto_import = dec(substring(v_cod_reg_import,v_num_pos_layout[v_num_count],
                                                             v_num_tam_layout_extrat[v_num_count])) no-error.
            @if(error-status:error)
                @run (pi_imprime_erro_importacao(@%(l_qtd_lancamentos) + chr(10) + @%(l_caracter))).
                return @%(l_nok).
            end.
        end.
        @if(v_cod_contdo_extrat[v_num_count] = @%(l_qtd_contas))
            assign v_num_quant_cta_import = int(substring(v_cod_reg_import,v_num_pos_layout[v_num_count],
                                                          v_num_tam_layout_extrat[v_num_count])) no-error.
            @if(error-status:error)
                @run (pi_imprime_erro_importacao(@%(l_qtd_contas) + chr(10) + @%(l_caracter))).
                return @%(l_nok).
            end.
        end.
        @if(v_cod_contdo_extrat[v_num_count] = @%(l_total_creditos))
              assign v_val_soma_cr_import = dec(substring(v_cod_reg_import,v_num_pos_layout[v_num_count],
                                                                  v_num_tam_layout_extrat[v_num_count])) / 100  no-error.
            @if(error-status:error)
                @run (pi_imprime_erro_importacao(@%(l_total_creditos) + chr(10) + @%(l_caracter))).
                return @%(l_nok).
            end.
        end.
        @if(v_cod_contdo_extrat[v_num_count] = @%(l_total_debitos))
            assign v_val_soma_db_import = dec(substring(v_cod_reg_import,v_num_pos_layout[v_num_count],
                                                        v_num_tam_layout_extrat[v_num_count])) / 100 no-error.
            @if(error-status:error)
                @run (pi_imprime_erro_importacao(@%(l_total_debitos) + chr(10) + @%(l_caracter))).
                return @%(l_nok).
            end.
        end.
    ***/
    end /* do data */.

    /* ****
    @if(v_num_quant_lancto_import <> v_num_quant_lancto)
        @if(v_log_erro = no)
             assign v_log_erro = yes.
        end.
        assign v_des_mensagem = substitute(@fx_msgpro(4133, msg),v_num_quant_lancto_import,v_num_quant_lancto)
               v_des_ajuda    = substitute(@fx_msgpro(4133, help),v_num_quant_lancto_import,v_num_quant_lancto).
        @run(pi_cria_tt_row_erros(4133,substitute(@fx_msgpro(4133, msg), v_des_mensagem),substitute(@fx_msgpro(4133, help), v_des_ajuda))).                     
    end.
    ****/

    if  v_log_erro
    then do:
        return "NOK" /*l_nok*/ .
    end.
    return "" /*l_null*/ .
END PROCEDURE. /* pi_tratar_trailler_layout_flex */
/*****************************************************************************
** Procedure Interna.....: pi_transfere_arquivo_importado
** Descricao.............: pi_transfere_arquivo_importado
** Criado por............: fut42929
** Criado em.............: 30/03/2009 10:04:31
** Alterado por..........: fut42929
** Alterado em...........: 24/06/2009 10:24:57
*****************************************************************************/
PROCEDURE pi_transfere_arquivo_importado:

     /* Para quando n∆o for informado no layout os tipos de registro saldo inicial e saldo final, 
      a data inicial do extrato ser† igual a menor data dos movimento das linhas do 
      extrato e a data final ser† igual a maior data dos movimento das linhas do extrato*/

    for each tt_extrat_cta_corren1:
        if  v_log_sdo_inic
        and v_log_sdo_fim then
            leave.
        find first extrat_cta_corren exclusive-lock
             where extrat_cta_corren.cod_cta_corren        = tt_extrat_cta_corren1.tta_cod_cta_corren
             and   extrat_cta_corren.num_extrat_cta_corren = tt_extrat_cta_corren1.tta_num_extrat_cta_corren no-error.
        if  avail extrat_cta_corren
        then do:
            if  v_log_sdo_inic = no
            then do:
                find first lin_extrat_cta_corren no-lock
                     where lin_extrat_cta_corren.cod_cta_corren        = extrat_cta_corren.cod_cta_corren
                     and   lin_extrat_cta_corren.num_extrat_cta_corren = extrat_cta_corren.num_extrat_cta_corren no-error.
                if avail lin_extrat_cta_corren then
                    assign extrat_cta_corren.dat_extrat_cta_corren_inic = lin_extrat_cta_corren.dat_movto_cta_corren.
            end /* if */.
            if  v_log_sdo_fim = no
            then do:
                find last  lin_extrat_cta_corren no-lock
                     where lin_extrat_cta_corren.cod_cta_corren        = extrat_cta_corren.cod_cta_corren
                     and   lin_extrat_cta_corren.num_extrat_cta_corren = extrat_cta_corren.num_extrat_cta_corren no-error.
                if avail lin_extrat_cta_corren then 
                    assign extrat_cta_corren.dat_extrat_cta_corren_fim = lin_extrat_cta_corren.dat_movto_cta_corren.
            end /* if */.
        end /* if */.
    end.
    for each ttBankStmntImportFileParamDTO no-lock:
        for each tt_file_list exclusive-lock:        
            /* Transfere Arquivos para pasta de j† importados*/
            assign v_nom_dir_export_arq = ttBankStmntImportFileParamDTO.directoryTransfer.
            if   ttBankStmntImportFileParamDTO.transferFile = true and v_nom_dir_export_arq <> '' then do:
                assign v_nom_dir_export_arq = replace(v_nom_dir_export_arq, '~\', '~/').
                os-copy value(tt_file_list.ttv_nom_filename) value(v_nom_dir_export_arq).
                input stream s_import close.
                os-delete value(tt_file_list.ttv_nom_filename).   
            end.                        
            /* Deleta registro criados pela pi_multi_arquivos*/
            /* if dwb_set_list.log_livre_1 = yes then
                  delete dwb_set_list.*/
        end.
    end.


END PROCEDURE. /* pi_transfere_arquivo_importado */
/*****************************************************************************
** Procedure Interna.....: pi_main_import_bank_statement
** Descricao.............: pi_main_import_bank_statement
** Criado por............: fut42929
** Criado em.............: 09/12/2008 14:49:59
** Alterado por..........: fut42929
** Alterado em...........: 25/06/2009 16:58:20
*****************************************************************************/
PROCEDURE pi_main_import_bank_statement:

    /************************* Variable Definition Begin ************************/

    def var v_cod_ok
        as character
        format "x(3)":U
        no-undo.


    /************************** Variable Definition End *************************/

    /* *********************** Parameter Definition Begin ************************/

    def Input param table 
        for ttBankStmntImportExecParamDTO.
    def Input param table 
        for ttBankStmntImportFileParamDTO.
    def OutPut param table
        for tt_row_errors.           

    /* *********************** Parameter Definition End ************************/

    empty temp-table tt_row_errors.

    find first ttBankStmntImportExecParamDTO no-lock no-error.
    if not avail ttBankStmntImportExecParamDTO then do:
        run pi_cria_tt_row_erros (Input 19564,
                                  Input "ParÉmetros para execuá∆o n∆o informados !" /*19564*/,
                                  Input "N∆o foram informados os parÉmetros necess†rios para a importaá∆o do Extrato Banc†rio." /*19564*/) /*pi_cria_tt_row_erros*/.
        return "NOK" /*l_nok*/ .
    end.
    find last param_geral_cmg no-lock no-error.
    if param_geral_cmg.log_unid_fechto_cx_obrig or
       ttBankStmntImportExecParamDTO.cashClosingUnit <> "" /*l_*/ 
    then do:
        run pi_validar_unid_fechto_cx (Input cashClosingUnit,
                                       output v_cod_ok) /*pi_validar_unid_fechto_cx*/.
        if v_cod_ok <> "OK" /*l_ok*/  then do:
            if v_cod_ok = "3149" then         
                run pi_cria_tt_row_erros (Input 3149,
                                          Input "Unidade de Fechamento de Caixa inv†lida !" /*3149*/,
                                          Input "Verifique se a Unidade de Fechamento de Caixa existe ou se o usu†rio possui permiss∆o." /*3149*/) /*pi_cria_tt_row_erros*/.
            if v_cod_ok = "3151" then
                run pi_cria_tt_row_erros (Input 3151,
                                          Input "A Unidade de Fechamento do Caixa deve ser informada !" /*3151*/,
                                          Input "Conforme a definiá∆o dos parÉmetros gerais do Caixa e Bancos, ser† obrigat¢rio informar uma unidade de fechamento do caixa." /*3151*/) /*pi_cria_tt_row_erros*/.
            if v_cod_ok = "3187" then do:
                assign v_des_mensagem = substitute("Usu†rio n∆o possui permiss∆o de acesso a(o) &1 &3 !" /*3187*/, "Unidade Fechamento Caixa" /*l_unid_fechto_cx*/ , '')
                       v_des_ajuda = substitute("Usu†rio &2 n∆o possui permiss∆o para acessar as informaá‰es do(a) &1 &3 selecionado." + chr(10) +
    "Verificar com o respons†vel pela manutená∆o dos controles de seguranáa do sistema a possibilidade de inclus∆o desta permiss∆o." + chr(10) +
    "" /*3187*/, "Unidade Fechamento Caixa" /*l_unid_fechto_cx*/ , v_cod_usuar_corren, '').
                run pi_cria_tt_row_erros (Input 3187,
                                          Input v_des_mensagem,
                                          Input v_des_ajuda) /*pi_cria_tt_row_erros*/.
            end.    
            if v_cod_ok = "3193" then
                run pi_cria_tt_row_erros (Input 3193,
                                          Input "ParÉmetro Geral do Caixa e Bancos Inexistente !" /*3193*/,
                                          Input "Cadastre na Manutená∆o de ParÉmetros CMG os parÉmetros do m¢dulo." /*3193*/) /*pi_cria_tt_row_erros*/.
            return "NOK" /*l_nok*/ .
        end.
    end.
    for each ttBankStmntImportFileParamDTO no-lock:
        if ttBankStmntImportFileParamDTO.setType = 1 then do:
            find first emscad.banco no-lock
                where banco.cod_banco = ttBankStmntImportFileParamDTO.bank no-error.
            if not avail banco then do:
                assign v_log_erro     = yes
                       v_cod_mensagem = string("Banco" /*l_banco*/   + " " + ttBankStmntImportFileParamDTO.bank)
                       v_des_mensagem = substitute("&1 inexistente !" /*2567*/, v_cod_mensagem)
                       v_des_ajuda    = substitute("Consulte o cadastro de &2." /*2567*/, "Banco" /*l_banco*/ , "Banco" /*l_banco*/ ).
                run pi_cria_tt_row_erros (Input 2567,
                                          Input v_des_mensagem,
                                          Input v_des_ajuda) /*pi_cria_tt_row_erros*/.
                return "NOK" /*l_nok*/ .
            end.
            find first cta_corren no-lock
                where cta_corren.cod_cta_corren = ttBankStmntImportFileParamDTO.chkAccount no-error.
            if not avail cta_corren then do:
                assign v_des_mensagem = substitute("&1 n∆o cadastrado(a) !" /*3324*/, "Conta Corrente" /*l_conta_corrente*/ )
                       v_des_ajuda = substitute("Cadastre pelo menos um(a) &1." /*3324*/, "Conta Corrente" /*l_conta_corrente*/ ).
                run pi_cria_tt_row_erros (Input 3324,
                                          Input v_des_mensagem,
                                          Input v_des_ajuda) /*pi_cria_tt_row_erros*/.
                return "NOK" /*l_nok*/ .
            end.
            if cta_corren.cod_banco <> banco.cod_banco then do:
                run pi_cria_tt_row_erros (Input 11184,
                                          Input "Conta corrente Inv†lida !" /*11184*/,
                                          Input "O banco da conta corrente deve ser o mesmo do banco informado" /*11184*/) /*pi_cria_tt_row_erros*/.
                return "NOK" /*l_nok*/ .
            end.
        end.
        find first layout_extrat no-lock
            where layout_extrat.cod_layout_extrat = ttBankStmntImportFileParamDTO.bankStatementLayout no-error.
        if not avail layout_extrat then do:
            assign v_des_mensagem = substitute("&1 inexistente !" /*2567*/,"Layout Extrato Conta Corrente")
                   v_des_ajuda    = substitute("Consulte o cadastro de &2." /*2567*/, ttBankStmntImportFileParamDTO.bankStatementLayout,"Layout Extrato Conta Corrente").
            run pi_cria_tt_row_erros (Input 2567,
                                      Input v_des_mensagem,
                                      Input v_des_ajuda) /*pi_cria_tt_row_erros*/.
            return "NOK" /*l_nok*/ .
        end.
        if layout_extrat.num_pos_prim_ident_extrat = 0
            and layout_extrat.num_pos_segndo_ident_extrat = 0
        then do:
            run pi_cria_tt_row_erros (Input 13159,
                                      Input "Identificador inexistente !" /*13159*/,
                                      Input "N∆o ser† poss°vel realizar a Importaá∆o de Extrato, pois n∆o foi informado a posiá∆o do 1o e 2o identificador do layout." /*13159*/) /*pi_cria_tt_row_erros*/.
            return "NOK" /*l_nok*/ .
        end.
        if layout_extrat.num_tam_prim_ident_extrat = 0
            and layout_extrat.num_tam_segndo_ident_extrat = 0
        then do:
            run pi_cria_tt_row_erros (Input 13158,
                                      Input "Identificador inexistente !" /*13158*/,
                                      Input "N∆o ser† poss°vel realizar a Importaá∆o de Extrato,  pois n∆o foi informado o tamanho do 1o e 2o identificador do layout." /*13158*/) /*pi_cria_tt_row_erros*/.
            return "NOK" /*l_nok*/ .
        end.
        run pi_criticar_dados_layout /*pi_criticar_dados_layout*/.
    end.
    run pi_extrat_cta_corren_import /*pi_extrat_cta_corren_import*/.
    dwb:
    for each tt_file_list no-lock:

        run pi_validar_dados_importacao_flex /*pi_validar_dados_importacao_flex*/.
        if return-value = "NOK" /*l_nok*/  then
            next dwb.
        import_block:
        do transaction:
            block:
            repeat on error undo import_block, leave import_block:
                import stream s_import unformatted v_cod_reg_import.

                if v_cod_reg_import = "" then
                    next.

                assign v_cod_prim_ident    = trim(substring(v_cod_reg_import,layout_extrat.num_pos_prim_ident_extrat,
                                                                              layout_extrat.num_tam_prim_ident_extrat))
                v_num_count_percent = v_num_count_percent + 1 no-error.

                if v_cod_prim_ident <> "0"
                    and  v_cod_prim_ident <> "9"
                    and layout_extrat.num_pos_segndo_ident_extrat <> 0
                    and layout_extrat.num_tam_segndo_ident_extrat <> 0 then

                    assign v_cod_segndo_ident = trim(substring(v_cod_reg_import,layout_extrat.num_pos_segndo_ident_extrat,
                                                                                layout_extrat.num_tam_segndo_ident_extrat)).
                else
                    assign v_cod_segndo_ident = "" /*l_null*/ .

                if v_cod_prim_ident    = v_cod_prim_ident_ant
                and  v_cod_segndo_ident  = v_cod_segndo_ident_ant then
                    assign v_cod_tip_reg = v_cod_tip_reg_ant.
                else do:
                    run pi_tratar_tip_reg_extrat_import_flex /*pi_tratar_tip_reg_extrat_import_flex*/.
                    if return-value <> "OK" /*l_ok*/  then
                         undo import_block, leave import_block.
                end.

                /* reg: */
                case v_cod_tip_reg:
                    when "Header" /*l_header*/ then mapa:
                     do:
                        assign v_cod_cta_corren_layout = v_cod_cta_corren_ant
                               v_log_exist_extrat      = no.
                        find first mapa_tip_reg_extrat no-lock
                            where mapa_tip_reg_extrat.cod_layout_extrat         = layout_extrat.cod_layout_extrat
                            and   mapa_tip_reg_extrat.num_seq_reg_layout_extrat = tip_reg_layout_extrat.num_seq_reg_layout_extrat
                            and   mapa_tip_reg_extrat.ind_contdo_layout_extrat  = "Banco" /*l_banco*/  no-error.
                        if avail mapa_tip_reg_extrat then
                            assign v_cod_bco_layout = trim(substring(v_cod_reg_import,mapa_tip_reg_extrat.num_pos_contdo_extrat,
                                                                                     mapa_tip_reg_extrat.num_tam_contdo_extrat))
                                   v_log_banco      = yes.

                        find first mapa_tip_reg_extrat no-lock
                             where mapa_tip_reg_extrat.cod_layout_extrat         = layout_extrat.cod_layout_extrat
                             and   mapa_tip_reg_extrat.num_seq_reg_layout_extrat = tip_reg_layout_extrat.num_seq_reg_layout_extrat
                             and   mapa_tip_reg_extrat.ind_contdo_layout_extrat  = "Agància" /*l_agencia*/  no-error.
                        if avail mapa_tip_reg_extrat then
                            assign v_cod_agenc_layout = trim(substring(v_cod_reg_import,mapa_tip_reg_extrat.num_pos_contdo_extrat,
                                                                                       mapa_tip_reg_extrat.num_tam_contdo_extrat)).

                        find first mapa_tip_reg_extrat no-lock
                            where mapa_tip_reg_extrat.cod_layout_extrat         = layout_extrat.cod_layout_extrat
                            and   mapa_tip_reg_extrat.num_seq_reg_layout_extrat = tip_reg_layout_extrat.num_seq_reg_layout_extrat
                            and   mapa_tip_reg_extrat.ind_contdo_layout_extrat  = "Conta Corrente" /*l_conta_corrente*/  no-error.
                        if avail mapa_tip_reg_extrat then
                            assign v_cod_cta_corren_layout = trim(substring(v_cod_reg_import,mapa_tip_reg_extrat.num_pos_contdo_extrat,
                                                                                            mapa_tip_reg_extrat.num_tam_contdo_extrat))
                                   v_log_cta_corren = yes.
                        data:
                        do v_num_count = 1 to v_num_count_aux:
                            if  v_cod_contdo_extrat[v_num_count] = "Dia Geraá∆o" /*l_dia_geracao*/ 
                            then do:
                                assign v_num_dia = int(substring(v_cod_reg_import,v_num_pos_layout[v_num_count],
                                                              v_num_tam_layout_extrat[v_num_count])) no-error.
                                if  error-status:error
                                then do:
                                    run pi_imprime_erro_importacao (Input "Dia Geraá∆o" /*l_dia_geracao*/  + chr(10) + "Caracter" /*l_caracter*/ ).
                                    assign error-status:error = no.
                                    undo import_block, leave import_block.
                                end.
                            end.
                            if  v_cod_contdo_extrat[v_num_count] = "Màs Geraá∆o" /*l_mes_geracao*/ 
                            then do:
                                assign v_num_mes = int(substring(v_cod_reg_import,v_num_pos_layout[v_num_count],
                                                              v_num_tam_layout_extrat[v_num_count])) no-error.
                                if error-status:error then do:
                                    run pi_imprime_erro_importacao (Input "Màs Geraá∆o" /*l_mes_geracao*/   + chr(10) + "Caracter" /*l_caracter*/ ).
                                    assign error-status:error = no.
                                    undo import_block, leave import_block.
                                end.
                            end.
                            if  v_cod_contdo_extrat[v_num_count] = "Ano Geraá∆o" /*l_ano_geracao*/ 
                            then do:
                                assign v_num_ano = int(substr(v_cod_reg_import,v_num_pos_layout[v_num_count],
                                                        v_num_tam_layout_extrat[v_num_count])) no-error.
                                if  error-status:error
                                then do:
                                    run pi_imprime_erro_importacao (Input "Ano Geraá∆o" /*l_ano_geracao*/   + chr(10) + "Caracter" /*l_caracter*/ ).
                                    assign error-status:error = no.
                                    undo import_block, leave import_block.
                                end.
                                if v_num_tam_layout_extrat[v_num_count] <> 4 then do:
                                    assign v_num_ano = v_num_ano + 2000.
                                end.
                            end.
                        end.

                        assign v_dat_geracao = date(v_num_mes,v_num_dia,v_num_ano) no-error.
                        if  error-status:error
                        then do:
                            run pi_imprime_erro_importacao_flex (Input "Data Geraá∆o:" /*l_data_geracao*/   + chr(10) + "caracter incorreto" /*l_caracter_incorreto*/ ).
                            assign error-status:error = no.
                            undo import_block, leave import_block.
                        end.
                    end.
                    when "Sdo Inicial" /*l_sdo_inicial*/ then mapa:
                     do:

                        /* ** Desconsiderada data do saldo inicial ***
                        assign v_log_sdo_inic = yes. */

                        run pi_tip_valida_sdo_inicial /*pi_tip_valida_sdo_inicial*/.

                        find banco no-lock
                            where banco.cod_sist_nac_bcio = v_cod_bco_layout no-error.
                        if  not avail banco
                        then do:
                            assign v_log_erro     = yes
                                v_cod_mensagem = string("Banco" /*l_banco*/  + " " + v_cod_bco_layout)
                                v_des_mensagem = substitute("&1 inexistente !" /*2567*/, v_cod_mensagem)
                                v_des_ajuda    = substitute("Consulte o cadastro de &2." /*2567*/, "Banco" /*l_banco*/ ,"Banco" /*l_banco*/ ) + ' ' + "Erro est† no tipo registro Saldo Inicial do arquivo." /*l_erro_sdo_inicial*/ .
                            run pi_cria_tt_row_erros (Input 2567,
                                                      Input v_des_mensagem,
                                                      Input v_des_ajuda) /*pi_cria_tt_row_erros*/.
                            undo import_block, leave import_block.
                        end.

                        if v_cod_agenc_layout <> "" /*l_null*/  then do:
                            find first agenc_bcia no-lock
                                 where agenc_bcia.cod_banco = banco.cod_banco
                                 and   agenc_bcia.cod_agenc_bcia = v_cod_agenc_layout no-error.
                            if not avail agenc_bcia then do:
                                assign v_log_erro     = yes
                                       v_cod_mensagem = string("Agància" /*l_agencia*/  + " " + v_cod_agenc_layout)
                                       v_des_mensagem = substitute("&1 inexistente !" /*2567*/, v_cod_mensagem)
                                       v_des_ajuda    = substitute("Consulte o cadastro de &2." /*2567*/, "Agància" /*l_agencia*/ ,"Agància" /*l_agencia*/ ) + ' ' + "Erro est† no tipo registro Saldo Inicial do arquivo." /*l_erro_sdo_inicial*/ .
                                run pi_cria_tt_row_erros (Input 2567,
                                                          Input v_des_mensagem,
                                                          Input v_des_ajuda) /*pi_cria_tt_row_erros*/.
                                undo import_block, leave import_block.
                            end.
                            find first cta_corren
                                 where cta_corren.cod_banco             = banco.cod_banco
                                 and   cta_corren.cod_agenc_bcia        = agenc_bcia.cod_agenc_bcia
                                 and   cta_corren.cod_cta_corren_bco    = v_cod_cta_corren_layout
                                 and   cta_corren.cod_digito_cta_corren = v_cod_digito_cta_corren
                                 no-lock no-error.
                        end.
                        else do:
                            find first cta_corren
                                where cta_corren.cod_banco             = banco.cod_banco
                                and   cta_corren.cod_cta_corren_bco    = v_cod_cta_corren_layout
                                and   cta_corren.cod_digito_cta_corren = v_cod_digito_cta_corren
                                no-lock no-error.
                        end.
                        if  not avail cta_corren
                        then do:
                            assign v_log_erro     = yes
                                   v_cod_mensagem = string("Conta Corrente" /*l_conta_corrente*/  + " " + v_cod_cta_corren_layout)
                                   v_des_mensagem = substitute("&1 inexistente !" /*2567*/, v_cod_mensagem)
                                   v_des_ajuda    = substitute("Consulte o cadastro de &2." /*2567*/, "Conta Corrente" /*l_conta_corrente*/ ,"Conta Corrente" /*l_conta_corrente*/ ) + ' ' + "Erro est† no tipo registro Saldo Inicial do arquivo." /*l_erro_sdo_inicial*/ .
                            run pi_cria_tt_row_erros (Input 2567,
                                                      Input v_des_mensagem,
                                                      Input v_des_ajuda) /*pi_cria_tt_row_erros*/.
                            undo import_block, leave import_block.
                        end.
                        for each ttBankStmntImportExecParamDTO no-lock:
                            if  ttBankStmntImportExecParamDTO.cashClosingUnit <> "" then do:
                                if  not can-find(first unid_fechto_cta_corren
                                    where unid_fechto_cta_corren.cod_unid_fechto_cx = ttBankStmntImportExecParamDTO.cashClosingUnit
                                    and   unid_fechto_cta_corren.cod_cta_corren     = cta_corren.cod_cta_corren) then do:
                                    assign v_log_erro     = yes
                                           v_des_mensagem = substitute("A Conta Corrente &1 n∆o Ç v†lida para UFC &2 !" /*3317*/, cta_corren.cod_cta_corren, ttBankStmntImportExecParamDTO.cashClosingUnit).
                                    run pi_cria_tt_row_erros (Input 3317,
                                                              Input v_des_mensagem,
                                                              Input "Consulte a Manutená∆o de Unidade de Fechamento de Caixa e informe uma Conta Corrente v†lida." /*3317*/) /*pi_cria_tt_row_erros*/.
                                    undo import_block, leave import_block.
                                end.
                            end.
                        end.
                        assign  v_num_quant_cta      = v_num_quant_cta + 1.
                        run pi_valida_cta_corren_importacao_flex /*pi_valida_cta_corren_importacao_flex*/.
                        if v_log_valid_cta_corren = yes then do:
                            assign v_log_valid_cta_corren = no.
                            assign v_log_erro     = yes
                                   v_des_mensagem = substitute("Saldo Inicial Inexistente !" /*8330*/).
                            run pi_cria_tt_row_erros (Input 8330,
                                                      Input v_des_mensagem,
                                                      Input "No arquivo de importaá∆o de extrato deve conter informaá‰es referente ao saldo inicial." /*8330*/) /*pi_cria_tt_row_erros*/.
                            undo import_block, leave import_block.
                        end.
                        /* if return-value = @%(l_nok) then
                            @next(block).*/
                        assign v_cod_banco          = banco.cod_banco
                               v_cod_sist_nac_bcio  = v_cod_bco_layout
                               v_cod_cta_corren_bco = cta_corren.cod_cta_corren_bco
                               v_cod_agenc_bcia     = cta_corren.cod_agenc_bcia
                               v_cod_digito_agenc_cta_corren = cta_corren.cod_digito_agenc_cta_corren.

                        run pi_tratar_sdo_inic_layout_flex /*pi_tratar_sdo_inic_layout_flex*/.
                        if  return-value = "NOK" /*l_nok*/ 
                        then do:
                            assign v_log_erro = yes.
                            undo import_block, leave import_block.
                        end.
                    end.
                    when "Transaá∆o" /*l_transacao*/ then mapa:
                     do:
                        assign v_num_quant_lancto = v_num_quant_lancto + 1.
                        find first mapa_tip_reg_extrat no-lock
                            where mapa_tip_reg_extrat.cod_layout_extrat         = layout_extrat.cod_layout_extrat
                            and   mapa_tip_reg_extrat.num_seq_reg_layout_extrat = tip_reg_layout_extrat.num_seq_reg_layout_extrat
                            and   mapa_tip_reg_extrat.ind_contdo_layout_extrat  = "Banco" /*l_banco*/  no-error.
                        if avail mapa_tip_reg_extrat then
                            assign v_cod_bco_layout = trim(substring(v_cod_reg_import,mapa_tip_reg_extrat.num_pos_contdo_extrat,
                                                                                 mapa_tip_reg_extrat.num_tam_contdo_extrat)).
                        find banco no-lock
                            where banco.cod_sist_nac_bcio = v_cod_bco_layout no-error.
                        if  not avail banco
                        then do:
                            assign v_log_erro     = yes
                                   v_cod_mensagem = string("Banco" /*l_banco*/  + " " + v_cod_bco_layout)
                                   v_des_mensagem = substitute("&1 inexistente !" /*2567*/, v_cod_mensagem)
                                   v_des_ajuda    = substitute("Consulte o cadastro de &2." /*2567*/, "Banco" /*l_banco*/ ,"Banco" /*l_banco*/ ) + ' ' + "Erro est† no tipo registro Transaá∆o do arquivo." /*l_erro_transacao*/ .
                            run pi_cria_tt_row_erros (Input 2567,
                                                      Input v_des_mensagem,
                                                      Input v_des_ajuda) /*pi_cria_tt_row_erros*/.
                            undo import_block, leave import_block.
                        end.

                        find first mapa_tip_reg_extrat no-lock
                             where mapa_tip_reg_extrat.cod_layout_extrat         = layout_extrat.cod_layout_extrat
                             and   mapa_tip_reg_extrat.num_seq_reg_layout_extrat = tip_reg_layout_extrat.num_seq_reg_layout_extrat
                             and   mapa_tip_reg_extrat.ind_contdo_layout_extrat  = "Agància" /*l_agencia*/  no-error.
                        if avail mapa_tip_reg_extrat then
                            assign v_cod_agenc_layout = trim(substring(v_cod_reg_import,mapa_tip_reg_extrat.num_pos_contdo_extrat,
                                                                                       mapa_tip_reg_extrat.num_tam_contdo_extrat)).

                        if v_cod_agenc_layout <> "" /*l_null*/  then do:
                            find first agenc_bcia no-lock
                                 where agenc_bcia.cod_banco = banco.cod_banco
                                 and   agenc_bcia.cod_agenc_bcia = v_cod_agenc_layout no-error.
                            if not avail agenc_bcia then do:
                                assign v_log_erro     = yes
                                       v_cod_mensagem = string("Agància" /*l_agencia*/  + " " + v_cod_agenc_layout)
                                       v_des_mensagem = substitute("&1 inexistente !" /*2567*/, v_cod_mensagem)
                                       v_des_ajuda    = substitute("Consulte o cadastro de &2." /*2567*/, "Agància" /*l_agencia*/ ).
                                run pi_cria_tt_row_erros (Input 2567,
                                                          Input v_des_mensagem,
                                                          Input v_des_ajuda) /*pi_cria_tt_row_erros*/.
                                undo import_block, leave import_block.
                            end.
                        end.

                        find first mapa_tip_reg_extrat no-lock
                            where mapa_tip_reg_extrat.cod_layout_extrat         = layout_extrat.cod_layout_extrat
                            and   mapa_tip_reg_extrat.num_seq_reg_layout_extrat = tip_reg_layout_extrat.num_seq_reg_layout_extrat
                            and   mapa_tip_reg_extrat.ind_contdo_layout_extrat  = "Conta Corrente" /*l_conta_corrente*/  no-error.
                        if avail mapa_tip_reg_extrat then
                            assign v_cod_cta_corren_layout = trim(substring(v_cod_reg_import,mapa_tip_reg_extrat.num_pos_contdo_extrat,
                                                                                        mapa_tip_reg_extrat.num_tam_contdo_extrat)).

                        find first mapa_tip_reg_extrat no-lock
                            where mapa_tip_reg_extrat.cod_layout_extrat         = layout_extrat.cod_layout_extrat
                            and   mapa_tip_reg_extrat.num_seq_reg_layout_extrat = tip_reg_layout_extrat.num_seq_reg_layout_extrat
                            and   mapa_tip_reg_extrat.ind_contdo_layout_extrat  = "D°gito Cta Corrente" /*l_digito_cta_corrente*/  no-error.
                        if avail mapa_tip_reg_extrat then
                            assign v_cod_digito_cta_corren = trim(substring(v_cod_reg_import,mapa_tip_reg_extrat.num_pos_contdo_extrat,
                                                                             mapa_tip_reg_extrat.num_tam_contdo_extrat)).

                        if v_cod_agenc_layout <> "" /*l_null*/  then do:
                            find first cta_corren no-lock
                                 where cta_corren.cod_banco             = banco.cod_banco
                                 and   cta_corren.cod_agenc_bcia        = agenc_bcia.cod_agenc_bcia
                                 and   cta_corren.cod_cta_corren_bco    = v_cod_cta_corren_layout
                                 and   cta_corren.cod_digito_cta_corren = v_cod_digito_cta_corren no-error.
                        end.
                        else do:
                            find first cta_corren no-lock
                                where cta_corren.cod_banco             = banco.cod_banco
                                and   cta_corren.cod_cta_corren_bco    = v_cod_cta_corren_layout
                                and   cta_corren.cod_digito_cta_corren = v_cod_digito_cta_corren no-error.
                        end.

                        if  not avail cta_corren
                        then do:
                            assign v_log_erro     = yes
                                   v_cod_mensagem = string("Conta Corrente" /*l_conta_corrente*/  + " " + v_cod_cta_corren_layout)
                                   v_des_mensagem = substitute("&1 inexistente !" /*2567*/, v_cod_mensagem)
                                   v_des_ajuda    = substitute("Consulte o cadastro de &2." /*2567*/, "Conta Corrente" /*l_conta_corrente*/ ).
                            run pi_cria_tt_row_erros (Input 2567,
                                                      Input v_des_mensagem,
                                                      Input v_des_ajuda) /*pi_cria_tt_row_erros*/.
                            undo import_block, leave import_block.
                        end.
                        assign v_cod_banco          = banco.cod_banco
                               v_cod_sist_nac_bcio  = v_cod_bco_layout
                               v_cod_cta_corren_bco = cta_corren.cod_cta_corren_bco
                               v_cod_agenc_bcia     = cta_corren.cod_agenc_bcia
                               v_cod_digito_agenc_cta_corren = cta_corren.cod_digito_agenc_cta_corren.

                        run pi_valida_cta_corren_importacao_flex /*pi_valida_cta_corren_importacao_flex*/.
                        for each ttBankStmntImportFileParamDTO no-lock:
                            if  return-value = "9572" and v_log_valid_cta_corren = no
                            then do:
                                assign v_log_erro     = yes
                                       v_des_mensagem = substitute("&1 Informada n∆o confere com a &1 do Extrato de Importaá∆o !" /*9572*/, "Conta Corrente" /*l_conta_corrente*/ , ttBankStmntImportFileParamDTO.chkAccount)
                                       v_des_ajuda    = substitute("A &1 &2 informada na seleá∆o, n∆o Ç a mesma &1 do Extrato banc†rio importado." + chr(10) +
    "Verifique a seleá∆o ou o extrato banc†rio para ajustar as contas." /*9572*/, "Conta Corrente" /*l_conta_corrente*/ , ttBankStmntImportFileParamDTO.chkAccount).
                                run pi_cria_tt_row_erros (Input 9572,
                                                          Input v_des_mensagem,
                                                          Input v_des_ajuda) /*pi_cria_tt_row_erros*/.
                                undo import_block, leave import_block.
                            end.
                        end.
                        if  return-value = "9575" and v_log_valid_cta_corren = no
                        then do:
                            assign v_cod_mensagem = string(cta_corren.cod_cta_corren_bco) + "-" + string(cta_corren.cod_digito_cta_corren)
                                   v_log_erro     = yes
                                   v_des_mensagem = substitute("Faixa de Seleá∆o est† fora da &1 do Extrato Banc†rio !" /*9575*/, "Conta Corrente" /*l_conta_corrente*/ )
                                   v_des_ajuda    = substitute("A &1 &2 encontrada no Extrato Banc†rio n∆o esta dentro da faixa de &1 informada na seleá∆o" + chr(10) +
    "Verifique a seleá∆o ou o extrato banc†rio para ajustar as contas." + chr(10) +
    "" /*9575*/, "Conta Corrente" /*l_conta_corrente*/ , v_cod_mensagem).
                            run pi_cria_tt_row_erros (Input 9575,
                                                      Input v_des_mensagem,
                                                      Input v_des_ajuda) /*pi_cria_tt_row_erros*/.
                            undo import_block, leave import_block.
                        end.
                        run pi_tratar_transacao_layout_flex /*pi_tratar_transacao_layout_flex*/.
                        if  return-value = "NOK" /*l_nok*/ 
                        then do:
                            assign v_log_erro = yes.
                            undo import_block, leave import_block.
                        end.

                        if return-value = "Exceá∆o" /*l_exception*/  then
                            next block.
                    end.

                    when "Sdo Final" /*l_sdo_final*/ then mapa:
                     do:

                        /* ** Zarpe - Desconsidera data do registro de saldo final ***/
                        /*assign v_log_sdo_fim = yes.*/

                        run pi_valida_cta_corren_importacao_flex /*pi_valida_cta_corren_importacao_flex*/.

                        if v_log_valid_cta_corren = yes then do:
                            assign v_log_valid_cta_corren = no.

                            assign v_log_erro     = yes
                                   v_des_mensagem = substitute("Saldo Inicial Inexistente !" /*8330*/)
                                   v_des_ajuda    = substitute("No arquivo de importaá∆o de extrato deve conter informaá‰es referente ao saldo inicial." /*8330*/).
                            run pi_cria_tt_row_erros (Input 8330,
                                                      Input v_des_mensagem,
                                                      Input v_des_ajuda) /*pi_cria_tt_row_erros*/.
                            undo import_block, leave import_block.
                        end.
                        if return-value = "NOK" /*l_nok*/  then next block.
                        run pi_tratar_sdo_final_layout_flex /*pi_tratar_sdo_final_layout_flex*/.
                        if  return-value = "NOK" /*l_nok*/ 
                        then do:
                            assign v_log_erro = yes.
                            undo import_block, leave import_block.
                        end.
                    end.
                    when "Trailler" /*l_trailler*/ then final:
                     do:
                        run pi_valida_cta_corren_importacao_flex /*pi_valida_cta_corren_importacao_flex*/.
                        if return-value = "NOK" /*l_nok*/  then
                            next block.

                        run pi_tratar_trailler_layout_flex /*pi_tratar_trailler_layout_flex*/.
                        if  return-value = "NOK" /*l_nok*/ 
                        then do:
                            assign v_log_erro = yes.
                            undo import_block, leave import_block.
                        end.
                    end.
                end.
                if  v_cod_cta_corren_layout <> v_cod_cta_corren_ant
                and v_cod_tip_reg <> "Header" /*l_header*/ 
                then do:
                    assign v_cod_cta_corren_ant = v_cod_cta_corren_layout
                           v_log_erro           = no.
                    if  avail extrat_cta_corren
                    then do:
                        create tt_extrat_cta_corren1.
                        assign tt_extrat_cta_corren1.tta_cod_cta_corren        = extrat_cta_corren.cod_cta_corren
                               tt_extrat_cta_corren1.tta_num_extrat_cta_corren = extrat_cta_corren.num_extrat_cta_corren.
                    end /* if */.
                end.
                assign v_cod_prim_ident_ant   = v_cod_prim_ident
                       v_cod_segndo_ident_ant = v_cod_segndo_ident
                       v_cod_tip_reg_ant      = v_cod_tip_reg.
            end.
        end.
    end.
    run pi_transfere_arquivo_importado /*pi_transfere_arquivo_importado*/.
END PROCEDURE. /* pi_main_import_bank_statement */
/*****************************************************************************
** Procedure Interna.....: pi_tip_valida_sdo_inicial
** Descricao.............: pi_tip_valida_sdo_inicial
** Criado por............: fut42929
** Criado em.............: 30/03/2009 14:11:42
** Alterado por..........: fut42929
** Alterado em...........: 30/03/2009 14:16:03
*****************************************************************************/
PROCEDURE pi_tip_valida_sdo_inicial:

    find first mapa_tip_reg_extrat no-lock
        where mapa_tip_reg_extrat.cod_layout_extrat         = layout_extrat.cod_layout_extrat
        and   mapa_tip_reg_extrat.num_seq_reg_layout_extrat = tip_reg_layout_extrat.num_seq_reg_layout_extrat
        and   mapa_tip_reg_extrat.ind_contdo_layout_extrat  = "Banco" /*l_banco*/  no-error.
    if avail mapa_tip_reg_extrat then
        assign v_cod_bco_layout = trim(substring(v_cod_reg_import,mapa_tip_reg_extrat.num_pos_contdo_extrat,
                                                                                  mapa_tip_reg_extrat.num_tam_contdo_extrat)).
    find first mapa_tip_reg_extrat no-lock
        where mapa_tip_reg_extrat.cod_layout_extrat         = layout_extrat.cod_layout_extrat
        and   mapa_tip_reg_extrat.num_seq_reg_layout_extrat = tip_reg_layout_extrat.num_seq_reg_layout_extrat
        and   mapa_tip_reg_extrat.ind_contdo_layout_extrat  = "Agància" /*l_agencia*/  no-error.
    if avail mapa_tip_reg_extrat then
        assign v_cod_agenc_layout = trim(substring(v_cod_reg_import,mapa_tip_reg_extrat.num_pos_contdo_extrat,
                                                                                       mapa_tip_reg_extrat.num_tam_contdo_extrat)).

    find first mapa_tip_reg_extrat no-lock
        where mapa_tip_reg_extrat.cod_layout_extrat         = layout_extrat.cod_layout_extrat
        and   mapa_tip_reg_extrat.num_seq_reg_layout_extrat = tip_reg_layout_extrat.num_seq_reg_layout_extrat
        and   mapa_tip_reg_extrat.ind_contdo_layout_extrat  = "Conta Corrente" /*l_conta_corrente*/  no-error.
    if avail mapa_tip_reg_extrat then
        assign v_cod_cta_corren_layout = trim(substring(v_cod_reg_import,mapa_tip_reg_extrat.num_pos_contdo_extrat,
                                                                                        mapa_tip_reg_extrat.num_tam_contdo_extrat)).

    find first mapa_tip_reg_extrat no-lock
        where mapa_tip_reg_extrat.cod_layout_extrat         = layout_extrat.cod_layout_extrat
        and   mapa_tip_reg_extrat.num_seq_reg_layout_extrat = tip_reg_layout_extrat.num_seq_reg_layout_extrat
        and   mapa_tip_reg_extrat.ind_contdo_layout_extrat  = "D°gito Cta Corrente" /*l_digito_cta_corrente*/  no-error.
    if avail mapa_tip_reg_extrat then
        assign v_cod_digito_cta_corren = trim(substring(v_cod_reg_import,mapa_tip_reg_extrat.num_pos_contdo_extrat,
                                                                       mapa_tip_reg_extrat.num_tam_contdo_extrat)).
END PROCEDURE. /* pi_tip_valida_sdo_inicial */
/*****************************************************************************
** Procedure Interna.....: pi_tratar_sdo_final_layout_flex
** Descricao.............: pi_tratar_sdo_final_layout_flex
** Criado por............: fut42929
** Criado em.............: 30/03/2009 16:18:34
** Alterado por..........: fut42929
** Alterado em...........: 23/06/2009 15:02:47
*****************************************************************************/
PROCEDURE pi_tratar_sdo_final_layout_flex:

    find cta_corren
        where cta_corren.cod_banco             = v_cod_banco
        and   cta_corren.cod_agenc_bcia        = v_cod_agenc_bcia
        and   cta_corren.cod_cta_corren_bco    = v_cod_cta_corren_layout
        and   cta_corren.cod_digito_cta_corren = v_cod_digito_cta_corren
        no-lock no-error.
    find last extrat_cta_corren
        where extrat_cta_corren.cod_cta_corren = cta_corren.cod_cta_corren
        exclusive-lock no-error.

    if not avail extrat_cta_corren then do:
        if  v_log_erro = no
        then do:
             assign v_log_erro = yes.
        end.
        assign v_des_mensagem = substitute("Extrato Conta Corrente inexistente !" /*11889*/)
               v_des_ajuda    = substitute("Extrato conta corrente n∆o existe para a conta corrente &1." /*11889*/,cta_corren.cod_cta_corren).                                
        run pi_cria_tt_row_erros (Input 11889,
                                  Input v_des_mensagem,
                                  Input v_des_ajuda) /*pi_cria_tt_row_erros*/.
        return "NOK" /*l_nok*/ .
    end.

    data:
    do v_num_count = 1 to v_num_count_aux:
        if  v_cod_contdo_extrat[v_num_count] = "Dia Sdo Final" /*l_dia_sdo_final*/ 
        then do:
            assign v_num_dia = int(substring(v_cod_reg_import,v_num_pos_layout[v_num_count],
                                                          v_num_tam_layout_extrat[v_num_count])) no-error.
            if  error-status:error
            then do:
                run pi_imprime_erro_importacao (Input "Dia Sdo Final" /*l_dia_sdo_final*/  + chr(10) + "Caracter" /*l_caracter*/) /*pi_imprime_erro_importacao*/.
                return "NOK" /*l_nok*/ .
            end.
        end.
        if  v_cod_contdo_extrat[v_num_count] = "Màs Sdo Final" /*l_mes_sdo_final*/ 
        then do:
            assign v_num_mes = int(substring(v_cod_reg_import,v_num_pos_layout[v_num_count],
                                                          v_num_tam_layout_extrat[v_num_count])) no-error.
            if  error-status:error
            then do:
                run pi_imprime_erro_importacao (Input "Màs Sdo Final" /*l_mes_sdo_final*/  + chr(10) + "Caracter" /*l_caracter*/) /*pi_imprime_erro_importacao*/.
                return "NOK" /*l_nok*/ .
            end.
        end.
        if  v_cod_contdo_extrat[v_num_count] = "Ano Sdo Final" /*l_ano_sdo_final*/ 
        then do:
            assign v_num_ano = int(substr(v_cod_reg_import,v_num_pos_layout[v_num_count],
                                              v_num_tam_layout_extrat[v_num_count])) no-error.
            if  error-status:error
            then do:
                run pi_imprime_erro_importacao (Input "Ano Sdo Final" /*l_ano_sdo_final*/  + chr(10) + "Caracter" /*l_caracter*/) /*pi_imprime_erro_importacao*/.
                return "NOK" /*l_nok*/ .
            end.
            if v_num_tam_layout_extrat[v_num_count] <> 4 then do:
               assign v_num_ano = v_num_ano + 2000.
            end.
        end.
        if  v_cod_contdo_extrat[v_num_count] = "Valor Sdo Final" /*l_valor_sdo_final*/ 
        then do:
            assign extrat_cta_corren.val_extrat_cta_corren_fim = dec(substring(v_cod_reg_import,v_num_pos_layout[v_num_count],
                                                                  v_num_tam_layout_extrat[v_num_count])) / 100  no-error.
            if  error-status:error
            then do:
                run pi_imprime_erro_importacao (Input "Valor Sdo Final" /*l_valor_sdo_final*/  + chr(10) + "Caracter" /*l_caracter*/) /*pi_imprime_erro_importacao*/.
                return "NOK" /*l_nok*/ .
            end.
        end.
        if  v_cod_contdo_extrat[v_num_count] = "Situaá∆o Saldo" /*l_situacao_saldo*/ 
        then do:
            assign v_cod_sit = trim(substring(v_cod_reg_import,v_num_pos_layout[v_num_count],
                                                          v_num_tam_layout_extrat[v_num_count])).
        end.
    end /* do data */.

    if  tip_reg_layout_extrat.log_livre_1 then do:
        if  v_cod_sit = tip_reg_layout_extrat.cod_carac_db_extrat
        then do:
            assign extrat_cta_corren.val_extrat_cta_corren_fim =
                   extrat_cta_corren.val_extrat_cta_corren_fim * -1.
        end.
    end.
    else do:
        if  tip_reg_layout_extrat.cod_carac_db_extrat > v_cod_sit
        then do:
            assign extrat_cta_corren.val_extrat_cta_corren_fim =
                   extrat_cta_corren.val_extrat_cta_corren_fim * -1.
        end.
    end.

    assign extrat_cta_corren.dat_extrat_cta_corren_fim = date(v_num_mes,v_num_dia,v_num_ano) no-error.

    /* Permite importar extratos de per°odos j† congelados, validaá∆o ocorre no in°cio de cada màs pois o banco envia movimentos retroativos **
    /* --- Extrato deve estar em per°odo aberto  ---*/
    run pi_retornar_sit_movimen_modul(input "CMG" /*l_cmg*/ ,
                                      input v_cod_empres_usuar,
                                      input extrat_cta_corren.dat_extrat_cta_corren_fim,
                                      input "Habilitado" /*l_habilitado*/ ,
                                      output v_cod_return).
    if not can-do(v_cod_return, "Habilitado" /*l_habilitado*/ ) then do:
        assign v_des_mensagem = substitute("M¢dulo &1 n∆o habilitado para movimentaá∆o em &2 !" /*4153*/, "CMG" /*l_cmg*/ , extrat_cta_corren.dat_extrat_cta_corren_fim)
               v_des_ajuda    = "Informe uma data dentro de um per°odo habilitado para m¢dulo ou altere a situaá∆o do per°odo para habilitado." /*4153*/.
        run pi_cria_tt_row_erros (Input 4153,
                                  Input v_des_mensagem,
                                  Input v_des_ajuda) /*pi_cria_tt_row_erros*/.
        return "NOK" /*l_nok*/ .
    end.
    ***/

    if  error-status:error
    then do:
        run pi_imprime_erro_importacao (Input "Data Saldo Final" /*l_data_saldo_final*/  + chr(10) + "caracter incorreto" /*l_caracter_incorreto*/) /*pi_imprime_erro_importacao*/.
        return "NOK" /*l_nok*/ .
    end.
    IF extrat_cta_corren.dat_extrat_cta_corren_fim < extrat_cta_corren.dat_extrat_cta_corren_inic THEN DO:
       assign v_des_mensagem = "Faixa de datas incorreta !" /*2651*/ 
              v_des_ajuda    = substitute("A data inicial ~"&1~" deve ser menor ou igual a data final ~"&2~"." /*2651*/,extrat_cta_corren.dat_extrat_cta_corren_inic,extrat_cta_corren.dat_extrat_cta_corren_fim).
       run pi_cria_tt_row_erros (Input 2651,
                                 Input v_des_mensagem,
                                 Input v_des_ajuda) /*pi_cria_tt_row_erros*/.
       return "NOK" /*l_nok*/ . 
    END.
    for each ttBankStmntImportExecParamDTO no-lock:
        if ttBankStmntImportExecParamDTO.validateEndBalance = true then do:
            if  (v_val_sdo_inicial_import + v_val_soma_cr - v_val_soma_db) <> extrat_cta_corren.val_extrat_cta_corren_fim
            then do:
                if  v_log_erro = no
                then do:
                     assign v_log_erro = yes.
                end.

                assign v_des_mensagem = "Problemas com Saldo Final do Extrato !" /*4135*/
                       v_des_ajuda =   substitute("A soma do Saldo Inicial + Entradas - Sa°das, n∆o confere com o valor de Saldo Final do Extrato." + chr(10) +
    "" + chr(10) +
    "     Saldo Inicial: &1" + chr(10) +
    "          Entradas: &2" + chr(10) +
    "            Sa°das: &3" + chr(10) +
    "   Saldo Calculado: &4" + chr(10) +
    "" + chr(10) +
    "Sado Final Extrato: &5" /*4135*/,
                                       string(v_val_sdo_inicial_import,"->>,>>>,>>>,>>9.99":U),
                                       string(v_val_soma_cr,"->>,>>>,>>>,>>9.99":U),
                                       string(v_val_soma_db,"->>,>>>,>>>,>>9.99":U),
                                       string((v_val_sdo_inicial_import + v_val_soma_cr - v_val_soma_db),"->>,>>>,>>>,>>9.99":U),
                                       string(extrat_cta_corren.val_extrat_cta_corren_fim,"->>,>>>,>>>,>>9.99":U)).

                run pi_cria_tt_row_erros (Input 4135,
                                          Input substitute("Problemas com Saldo Final do Extrato !" /*4135*/, v_des_mensagem),
                                          Input v_des_ajuda) /*pi_cria_tt_row_erros*/.
                return "NOK" /*l_nok*/ .
            end /* if */.     
        end.
    end.   
    return "" /*l_null*/ .
END PROCEDURE. /* pi_tratar_sdo_final_layout_flex */
/*****************************************************************************
** Procedure Interna.....: pi_validar_unid_fechto_cx
** Descricao.............: pi_validar_unid_fechto_cx
** Criado por............: Klug
** Criado em.............: 08/09/1997 09:33:54
** Alterado por..........: fut42929
** Alterado em...........: 25/06/2009 14:13:24
*****************************************************************************/
PROCEDURE pi_validar_unid_fechto_cx:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_unid_fechto_cx
        as character
        format "x(8)"
        no-undo.
    def output param p_cod_return
        as character
        format "x(40)"
        no-undo.


    /************************* Parameter Definition End *************************/

    assign p_cod_return = "OK" /*l_ok*/ .

    if  avail param_geral_cmg
    then do:
        if  p_cod_unid_fechto_cx <> "" /*l_null*/ 
        then do:
            find first unid_fechto_cx no-lock
                where unid_fechto_cx.cod_unid_fechto_cx = p_cod_unid_fechto_cx no-error.
            if  not avail unid_fechto_cx
            then do:
                assign p_cod_return = "3149".
                return.
            end /* if */.

            /* --- Pesquisa se a unid_fechto_cx tem permissao na tabela Segur_unid_fechto_cx ---*/

            /* Begin_Include: i_verify_security_grp_usuar */
            assign v_log_valid = no.

            if  can-find(first segur_unid_fechto_cx
                    where segur_unid_fechto_cx.cod_unid_fechto_cx = unid_fechto_cx.cod_unid_fechto_cx
                      and segur_unid_fechto_cx.cod_grp_usuar = '*' /*cl_verify_security_unid_fechto_cx_aux of segur_unid_fechto_cx*/)
                    then do:
                assign v_log_valid = yes.
            end /* if */.
            else do:
                segur_block:
                for each segur_unid_fechto_cx no-lock
                 where segur_unid_fechto_cx.cod_unid_fechto_cx = unid_fechto_cx.cod_unid_fechto_cx /*cl_verify_security_unid_fechto_cx of segur_unid_fechto_cx*/:
                    if  lookup(segur_unid_fechto_cx.cod_grp_usuar, v_cod_grp_usuar_lst) <> 0
                    then do:
                        assign v_log_valid = yes.
                        leave segur_block.
                    end /* if */.
                end /* for segur_block */.
            end /* else */.

            /* End_Include: i_verify_security_grp_usuar */

            if  v_log_valid = no
            then do:
                assign p_cod_return = "3187".
                return.
            end /* if */.
        end /* if */.
        else do:
            if  param_geral_cmg.log_unid_fechto_cx_obrig = yes
            then do:
                assign p_cod_return = "3151".
                return.
            end /* if */.
        end /* else */.
    end /* if */.
    else do:
        assign p_cod_return = "3193".
        return.
    end /* else */.

END PROCEDURE. /* pi_validar_unid_fechto_cx */
/*****************************************************************************
** Procedure Interna.....: pi_validate_directory
** Descricao.............: pi_validate_directory
** Criado por............: fut42929
** Criado em.............: 15/04/2009 11:43:05
** Alterado por..........: fut42929
** Alterado em...........: 04/05/2009 17:08:08
*****************************************************************************/
PROCEDURE pi_validate_directory:

    /************************ Parameter Definition Begin ************************/

    def Input param p_des_importa_nom_arq
        as character
        format "x(40)"
        no-undo.
    def Input param p_des_transf_nom_arq
        as character
        format "x(40)"
        no-undo.
    def output param table 
        for tt_row_errors.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_cod_dir
        as character
        format "x(8)":U
        no-undo.
    def var v_cod_ext
        as character
        format "x(3)":U
        no-undo.
    def var v_des_transf_nom_arq
        as character
        format "x(40)":U
        no-undo.


    /************************** Variable Definition End *************************/

    /* Verificar se o arquivo de importaá∆o existe e se Ç valido */
    assign v_cod_dir = replace(p_des_importa_nom_arq, '/', '\').

    if index(v_cod_dir,'.') > 0 then do:
        assign v_cod_ext  = trim(substr(v_cod_dir,index(v_cod_dir,'.') + 1, 10))
               v_cod_dir = substr(v_cod_dir, 1, r-index(v_cod_dir, '\', index(v_cod_dir, '.' + v_cod_ext))).
    end.

    file-info:file-name = v_cod_dir.
    if index(file-info:file-type, 'D') > 0 then do:
        if index(file-info:file-type, 'RW') > 0 then do:    
        end.
        else do:
            run pi_cria_tt_row_erros (Input 19728,
                                      Input substitute("Diret¢rio para &1 Inv†lido !" /*19728*/,"Importaá∆o" /*l_importacao*/ ),
                                      Input substitute("O diret¢rio informado para &1 n∆o existe no servidor de execuá∆o ou n∆o permite acesso. Contacte o usu†rio administrador do sistema." /*19728*/,"Importaá∆o" /*l_importacao*/ )) /*pi_cria_tt_row_erros*/.
        end.
    end.
    else do:
        run pi_cria_tt_row_erros (Input 19728,
                                  Input substitute("Diret¢rio para &1 Inv†lido !" /*19728*/,"Importaá∆o" /*l_importacao*/ ),
                                  Input substitute("O diret¢rio informado para &1 n∆o existe no servidor de execuá∆o ou n∆o permite acesso. Contacte o usu†rio administrador do sistema." /*19728*/,"Importaá∆o" /*l_importacao*/ )) /*pi_cria_tt_row_erros*/.
    end.

    /* Verificar se o arquivo de transferencia existe e se Ç valido */

    assign v_des_transf_nom_arq = p_des_transf_nom_arq.
    if v_des_transf_nom_arq <> '' then do:
        file-info:file-name = v_des_transf_nom_arq.
        if index(file-info:file-type, 'D') > 0 then do:
            if index(file-info:file-type, 'RW') > 0 then do:    
            end.
            else do:
                run pi_cria_tt_row_erros (Input 19728,
                                          Input substitute("Diret¢rio para &1 Inv†lido !" /*19728*/,"Transferància" /*l_transferencia*/ ),
                                          Input substitute("O diret¢rio informado para &1 n∆o existe no servidor de execuá∆o ou n∆o permite acesso. Contacte o usu†rio administrador do sistema." /*19728*/,"Transferància" /*l_transferencia*/ )) /*pi_cria_tt_row_erros*/.
            end.
        end.
        else do:
            run pi_cria_tt_row_erros (Input 19728,
                                      Input substitute("Diret¢rio para &1 Inv†lido !" /*19728*/,"Transferància" /*l_transferencia*/ ),
                                      Input substitute("O diret¢rio informado para &1 n∆o existe no servidor de execuá∆o ou n∆o permite acesso. Contacte o usu†rio administrador do sistema." /*19728*/,"Transferància" /*l_transferencia*/ )) /*pi_cria_tt_row_erros*/.
        end.
    end.
END PROCEDURE. /* pi_validate_directory */


/************************** Internal Procedure End **************************/

/************************* External Procedure Begin *************************/



/************************** External Procedure End **************************/

/*************************************  *************************************/
/*****************************************************************************
**  Procedure Interna: pi_print_editor
**  Descricao........: Imprime editores nos relat¢rios
*****************************************************************************/
PROCEDURE pi_print_editor:

    def input param p_stream    as char    no-undo.
    def input param p1_editor   as char    no-undo.
    def input param p1_pos      as char    no-undo.
    def input param p2_editor   as char    no-undo.
    def input param p2_pos      as char    no-undo.
    def input param p3_editor   as char    no-undo.
    def input param p3_pos      as char    no-undo.

    def var c_editor as char    extent 5             no-undo.
    def var l_first  as logical extent 5 initial yes no-undo.
    def var c_at     as char    extent 5             no-undo.
    def var i_pos    as integer extent 5             no-undo.
    def var i_len    as integer extent 5             no-undo.

    def var c_aux    as char               no-undo.
    def var i_aux    as integer            no-undo.
    def var c_ret    as char               no-undo.
    def var i_ind    as integer            no-undo.

    assign c_editor [1] = p1_editor
           c_at  [1]    =         substr(p1_pos,1,2)
           i_pos [1]    = integer(substr(p1_pos,3,3))
           i_len [1]    = integer(substr(p1_pos,6,3)) - 4
           c_editor [2] = p2_editor
           c_at  [2]    =         substr(p2_pos,1,2)
           i_pos [2]    = integer(substr(p2_pos,3,3))
           i_len [2]    = integer(substr(p2_pos,6,3)) - 4
           c_editor [3] = p3_editor
           c_at  [3]    =         substr(p3_pos,1,2)
           i_pos [3]    = integer(substr(p3_pos,3,3))
           i_len [3]    = integer(substr(p3_pos,6,3)) - 4
           c_ret        = chr(255) + chr(255).

    do while c_editor [1] <> "" or c_editor [2] <> "" or c_editor [3] <> "":
        do i_ind = 1 to 3:
            if c_editor[i_ind] <> "" then do:
                assign i_aux = index(c_editor[i_ind], chr(10)).
                if i_aux > i_len[i_ind] or (i_aux = 0 and length(c_editor[i_ind]) > i_len[i_ind]) then
                    assign i_aux = r-index(c_editor[i_ind], " ", i_len[i_ind] + 1).
                if i_aux = 0 then
                    assign c_aux = substr(c_editor[i_ind], 1, i_len[i_ind])
                           c_editor[i_ind] = substr(c_editor[i_ind], i_len[i_ind] + 1).
                else
                    assign c_aux = substr(c_editor[i_ind], 1, i_aux - 1)
                           c_editor[i_ind] = substr(c_editor[i_ind], i_aux + 1).
                if i_pos[1] = 0 then
                    assign entry(i_ind, c_ret, chr(255)) = c_aux.
                else
                    if l_first[i_ind] then
                        assign l_first[i_ind] = no.
                    else
                        case p_stream:
                            when "s_import" then
                                if c_at[i_ind] = "at" then
                                    put stream s_import unformatted c_aux at i_pos[i_ind].
                                else
                                    put stream s_import unformatted c_aux to i_pos[i_ind].
                        end.
            end.
        end.
        case p_stream:
        when "s_import" then
            put stream s_import unformatted skip.
        end.
        if i_pos[1] = 0 then
            return c_ret.
    end.
    return c_ret.
END PROCEDURE.  /* pi_print_editor */

/*************************************  *************************************/
/*****************************************************************************
**  Procedure Interna: pi_messages
**  Descricao........: Mostra Mensagem com Ajuda
*****************************************************************************/
PROCEDURE pi_messages:

    def input param c_action    as char    no-undo.
    def input param i_msg       as integer no-undo.
    def input param c_param     as char    no-undo.

    def var c_prg_msg           as char    no-undo.

    assign c_prg_msg = "messages/":U
                     + string(trunc(i_msg / 1000,0),"99":U)
                     + "/msg":U
                     + string(i_msg, "99999":U).

    if search(c_prg_msg + ".r":U) = ? and search(c_prg_msg + ".p":U) = ? then do:
        message "Mensagem nr. " i_msg "!!!":U skip
                "Programa Mensagem" c_prg_msg "n∆o encontrado."
                view-as alert-box error.
        return error.
    end.

    run value(c_prg_msg + ".p":U) (input c_action, input c_param).
    return return-value.
END PROCEDURE.  /* pi_messages */
/*******************  End of api_importa_extrato_bancario *******************/
