/*****************************************************************************
** Copyright DATASUL S.A. (1994)
** Todos os Direitos Reservados.
** 
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so' podera ser feita mediante
** autorizacao expressa.
**
** Programa..............: fnc_prg_formul_39
** Descricao.............: F¢rmula 39
** Versao................:  1.00.00.016
** Procedimento..........: utl_programs_formulas_edi
** Nome Externo..........: prgint/edf/edf701zi.py
** Data Geracao..........: 12/05/2010 - 15:56:37
** Criado por............: tech14032
** Criado em.............: 19/01/2005 11:31:05
** Alterado por..........: fut41420
** Alterado em...........: 11/11/2009 10:06:18
** Gerado por............: corp1153
*****************************************************************************/

def buffer histor_exec_especial for emscad.histor_exec_especial.
def buffer fornecedor for emscad.fornecedor.

/*-- Filtro Multi-idioma Aplicado --*/

def var c-versao-prg as char initial " 1.00.00.016":U no-undo.
def var c-versao-rcode as char initial "[[[1.00.00.016[[[":U no-undo. /* Controle de Versao R-CODE - Nao retirar do Fonte */

{include/i_dbinst.i}
{include/i_dbtype.i}

/*{include/i_fcldef.i}*/
define new global shared variable h_facelift as handle no-undo. 
if not valid-handle(h_facelift) then run prgtec/btb/btb901zo.py persistent set h_facelift no-error.

define new global shared variable h-facelift as handle no-undo. 
if not valid-handle(h-facelift) then run prgtec/btb/btb901zo.py persistent set h-facelift no-error.

{include/i_trddef.i}


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i fnc_prg_formul_39 EDF}
&ENDIF

/******************************* Private-Data *******************************/
assign this-procedure:private-data = "HLP=0":U.
/*************************************  *************************************/

/********************* Temporary Table Definition Begin *********************/

def shared temp-table tt_segment_tot no-undo
    field tta_cdn_segment_edi              as Integer format ">>>>>9" initial 0 label "Segmento" column-label "Segmento"
    field ttv_qtd_proces_edi               as decimal format "->>>>,>>9.9999" decimals 4
    field ttv_qtd_bloco_docto              as decimal format "99999"
    field ttv_log_trailler_edi             as logical format "Sim/NÆo" initial no label "Trailler" column-label "Trailler"
    field ttv_log_header_edi               as logical format "Sim/NÆo" initial no label "Header" column-label "Header"
    .

def temp-table tt_param_program_formul no-undo
    field tta_cdn_segment_edi              as Integer format ">>>>>9" initial 0 label "Segmento" column-label "Segmento"
    field tta_cdn_element_edi              as Integer format ">>>>>9" initial 0 label "Elemento" column-label "Elemento"
    field tta_des_label_utiliz_formul_edi  as character format "x(10)" label "Label Utiliz Formula" column-label "Label Utiliz Formula"
    field ttv_des_contdo                   as character format "x(100)" label "Conteudo" column-label "Conteudo"
    index tt_param_program_formul_id       is primary
          tta_cdn_segment_edi              ascending
          tta_cdn_element_edi              ascending
    .



/********************** Temporary Table Definition End **********************/

/************************ Parameter Definition Begin ************************/

def Input param p_cdn_mapa_edi
    as Integer
    format ">>>>>9"
    no-undo.
def Input param p_cdn_segment_edi
    as Integer
    format ">>>>>9"
    no-undo.
def Input param p_cdn_element_edi
    as Integer
    format ">>>>>9"
    no-undo.
def Input param table 
    for tt_param_program_formul.


/************************* Parameter Definition End *************************/

/************************* Variable Definition Begin ************************/

def new global shared var v_cod_aplicat_dtsul_corren
    as character
    format "x(3)":U
    no-undo.
def new global shared var v_cod_ccusto_corren
    as character
    format "x(11)":U
    label "Centro Custo"
    column-label "Centro Custo"
    no-undo.
def new global shared var v_cod_dwb_user
    as character
    format "x(21)":U
    label "Usu rio"
    column-label "Usu rio"
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
    label "Grupo Usu rios"
    column-label "Grupo"
    no-undo.
def new global shared var v_cod_idiom_usuar
    as character
    format "x(8)":U
    label "Idioma"
    column-label "Idioma"
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
    label "Pa¡s Empresa Usu rio"
    column-label "Pa¡s"
    no-undo.
def new global shared var v_cod_plano_ccusto_corren
    as character
    format "x(8)":U
    label "Plano CCusto"
    column-label "Plano CCusto"
    no-undo.
def new global shared var v_cod_unid_negoc_usuar
    as character
    format "x(3)":U
    view-as combo-box
    &if "{&FNC_MULTI_IDIOMA}" = "YES" &then
    list-item-pairs "",""
    &else
    list-items ""
    &endif
    inner-lines 5
    bgcolor 15 font 2
    label "Unidade Neg¢cio"
    column-label "Unid Neg¢cio"
    no-undo.
def new global shared var v_cod_usuar_corren
    as character
    format "x(12)":U
    label "Usu rio Corrente"
    column-label "Usu rio Corrente"
    no-undo.
def new global shared var v_cod_usuar_corren_criptog
    as character
    format "x(16)":U
    no-undo.
def new global shared var v_des_flag_public_geral
    as character
    format "x(15)":U
    extent 10
    no-undo.
def var v_nom_title_aux
    as character
    format "x(60)":U
    no-undo.
def new global shared var v_num_ped_exec_corren
    as integer
    format ">>>>9":U
    no-undo.
def var v_rec_log
    as recid
    format ">>>>>>9":U
    no-undo.

def var v_cod_j52                        as character       format "x(240)":U no-undo.
def var v_num_bloco                      as integer         no-undo. /*local*/
def var v_num_reg_bloco                  as integer         no-undo. /*local*/
def var v_num_tip_id_feder               as integer         no-undo. /*local*/
def var v_cod_id_feder_favorec           as character       no-undo. /*local*/
def var v_cod_tip_movto                  as character       no-undo. /*local*/
def var v_cdn_contador                   as Integer         format ">>>,>>9":U no-undo.
def var v_cod_tit_ap                     as character       format "x(10)":U label "T¡tulo Ap" column-label "T¡tulo Ap" no-undo.
def var v_nom_favorec                    as character       format "x(30)":U no-undo.
def var v_num_tip_id_feder_sacad         as integer         no-undo. /*local*/
def var v_cod_id_feder_sacad             as character       no-undo. /*local*/
def var v_nom_sacad                      as character       format "x(30)":U no-undo.
def var v_num_tip_id_feder_fornec        as integer         no-undo. /*local*/
def var v_cod_id_feder_fornec            as character       no-undo. /*local*/
def var v_nom_fornec                     as character       format "x(30)":U no-undo.
/************************** Variable Definition End *************************/


/****************************** Main Code Begin *****************************/


/* Begin_Include: i_version_extract */
{include/i-ctrlrp5.i fnc_prg_formul_39}


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
    run pi_version_extract ('fnc_prg_formul_39':U, 'prgint/edf/edf701zi.py':U, '1.00.00.016':U, 'pro':U).
end /* if */.



/* End_Include: i_version_extract */

if  search("prgtec/btb/btb906za.r") = ? and search("prgtec/btb/btb906za.py") = ? then do:
    if  v_cod_dwb_user begins 'es_' then
        return "Programa execut vel nÆo foi encontrado:" /*l_programa_nao_encontrado*/  + "prgtec/btb/btb906za.py".
    else do:
        message getStrTrans("Programa execut vel nÆo foi encontrado:", "EDF") /*l_programa_nao_encontrado*/  "prgtec/btb/btb906za.py"
               view-as alert-box error buttons ok.
        stop.
    end.
end.
else
    run prgtec/btb/btb906za.py /*prg_fnc_verify_controls*/.

/* Begin_Include: i_verify_security */
if  search("prgtec/men/men901za.r") = ? and search("prgtec/men/men901za.py") = ? then do:
    if  v_cod_dwb_user begins 'es_' then
        return "Programa execut vel nÆo foi encontrado:" /*l_programa_nao_encontrado*/  + "prgtec/men/men901za.py".
    else do:
        message getStrTrans("Programa execut vel nÆo foi encontrado:", "EDF") /*l_programa_nao_encontrado*/  "prgtec/men/men901za.py"
               view-as alert-box error buttons ok.
        return.
    end.
end.
else
    run prgtec/men/men901za.py (Input 'fnc_prg_formul_39') /*prg_fnc_verify_security*/.
if  return-value = "2014"
then do:
    /* Programa a ser executado nÆo ‚ um programa v lido Datasul ! */
    run pi_messages (input "show",
                     input 2014,
                     input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                       'fnc_prg_formul_39')) /*msg_2014*/.
    return.
end /* if */.
if  return-value = "2012"
then do:
    /* Usu rio sem permissÆo para acessar o programa. */
    run pi_messages (input "show",
                     input 2012,
                     input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                       'fnc_prg_formul_39')) /*msg_2012*/.
    return.
end /* if */.
/* End_Include: i_verify_security */



/* Begin_Include: i_log_exec_prog_dtsul_ini */
assign v_rec_log = ?.

if can-find(prog_dtsul
       where prog_dtsul.cod_prog_dtsul = 'fnc_prg_formul_39' 
         and prog_dtsul.log_gera_log_exec = yes) then do transaction:
    create log_exec_prog_dtsul.
    assign log_exec_prog_dtsul.cod_prog_dtsul           = 'fnc_prg_formul_39'
           log_exec_prog_dtsul.cod_usuario              = v_cod_usuar_corren
           log_exec_prog_dtsul.dat_inic_exec_prog_dtsul = today
           log_exec_prog_dtsul.hra_inic_exec_prog_dtsul = replace(string(time,"hh:mm:ss" /*l_hh:mm:ss*/ ),":":U,"":U).
    assign v_rec_log = recid(log_exec_prog_dtsul).
    release log_exec_prog_dtsul no-error.
end.


/* End_Include: i_log_exec_prog_dtsul_ini */


def var v_cod_segto           as char no-undo.
def var v_dsl_segto           as char no-undo.
def var v_cod_digito          as char no-undo.
def var v_cdn_bco             as int  no-undo.
def var v_num_inic            as int  no-undo.
def var v_cdn_agenc           as int  no-undo.
def var v_val_cta_arq         as dec  decimals 0 no-undo.
def var v_cdn_tip_forma_pagto as Int  no-undo.
def var v_dec_aux             as dec  no-undo.
def var v_dec_aux2            as dec  no-undo.
def var v_dec_aux3            as dec  no-undo.
def var v_num_tam_format      as int  no-undo.
def var v_forma_pagto         as char no-undo.
def var v_tp_forn             as int  no-undo.
def var v_cod_estab           as char no-undo.
def var dt-aux                as date no-undo.
def var c-mes                 as int  no-undo.
def var c-ano                 as int  no-undo.
def var c-aux                 as char no-undo.
def var i-aux                 as int  no-undo.
def var c-bloco               as char no-undo.
def var de-aux                as dec no-undo.
def var de-aux2               as dec no-undo.
def var de-aux3               as dec no-undo.
def var v_cod_banco           as char no-undo.

/* Tipo de Pagamento */
if p_cdn_segment_edi = 307 and
   p_cdn_element_edi = 2681 then do:

   find tt_param_program_formul
        where tt_param_program_formul.tta_cdn_segment_edi = 288
        and   tt_param_program_formul.tta_cdn_element_edi = 3729 no-error.

   if int(tt_param_program_formul.ttv_des_contdo) = 22 then
      return '22'.
   else
      return '20'.
end.

/* C½digo do Segmento */
if p_cdn_segment_edi = 309 and
   p_cdn_element_edi = 2693 then do:

   run pi_retorna_tp_segto (output v_cod_segto).

   return trim(v_cod_segto).
end.

/* Detalhe Variÿvel - Registro Detalhe */
if p_cdn_segment_edi = 309 and
   p_cdn_element_edi = 5174 then do:

   run pi_retorna_tp_segto (output v_cod_segto).
   
   case v_cod_segto:
     when "A" /*l_A*/  then  /* Pagamento com Cheque, OP, DOC, TED e Cr²dito em Conta Corrente */

         run pi_segto_tipo_A.

     when "J" /*l_J*/  then  /* Liquida»’o de T­tulos (bloquetos) em cobran»a no Itaœ e em outros Bancos */

         run pi_segto_tipo_J.

     when "N" /*l_n*/  then  /* Pagamento Tributos (GPS / DARF / DARF SIMPLES) */

         run pi_segto_tipo_N.

     when "O" /*l_o*/  then  /* Pagamento Contas Concessionÿrias */

         run pi_segto_tipo_O.

   end case.

   return v_dsl_segto. /* Vai retornar registro com dados de detalhe variÿvel */
end.

/* J-52 - Somat¢rio Registros do Bloco */
if p_cdn_segment_edi = 311 and
   p_cdn_element_edi = 2710 then do:
   
   find first tt_segment_tot no-lock
        where tt_segment_tot.tta_cdn_segment_edi = 999999  no-error.
     
   if avail tt_segment_tot then
      return string(tt_segment_tot.ttv_qtd_bloco_docto).
   
end.
/* FIM-J-52 - Somat¢rio Registros do Bloco */

/* Detalhe Variÿvel - Registro Detalhe Trailler */
if p_cdn_segment_edi = 311 and
   p_cdn_element_edi = 5133 then do:

   assign v_dsl_segto = ''
          de-aux      = 0
          de-aux2     = 0
          de-aux3     = 0.

   find first tt_param_program_formul
        where tt_param_program_formul.tta_cdn_segment_edi = 0
        and   tt_param_program_formul.tta_cdn_element_edi = 0 
        no-error.

   assign c-bloco = tt_param_program_formul.ttv_des_contdo.

   run pi_retorna_tp_segto (output v_cod_segto).

   for each reg_proces_entr_edi no-lock where 
       reg_proces_entr_edi.cdn_proces_edi   = int(v_des_flag_public_geral[1]) and
       reg_proces_entr_edi.cod_id_bloco_edi = c-bloco.

       /* somatorios */
       assign de-aux  = de-aux  + dec(entry(33,reg_proces_entr_edi.dsl_dados_entr_edi,chr(24)))   /* Valor Nominal do T­tulo */       
              de-aux2 = de-aux2 + dec(entry(30,reg_proces_entr_edi.dsl_dados_entr_edi,chr(24)))   /* Juros */
              de-aux3 = de-aux3 + dec(entry(25,reg_proces_entr_edi.dsl_dados_entr_edi,chr(24))).  /* Valor Pagto */
   end.   

   case v_cod_segto:
      when "N" /*l_n*/  then do: /* Pagamento de Tributos */

         assign v_dsl_segto = string(de-aux,"99999999999999")  + /* Somat½rio valor pagamentos */ 
                              '00000000000000'                 + /* Somat½rio outras entidades */
                              string(de-aux2,'99999999999999') + /* Somat½rio valor multa / mora */
                              string(de-aux3,'99999999999999').  /* Somat½rio total pagamento */

      end.
      otherwise do:
         assign v_dsl_segto = string(de-aux3,'999999999999999999') + /* Somat½rio valor pagamentos */ 
                              fill('0',18) + /* Zeros */
                              fill(' ',20). /* brancos */
      end.
   end case.

   return v_dsl_segto.
end.


/* Begin_Include: i_declara_GetEntryField */
FUNCTION GetEntryField RETURNS CHARACTER (input p_num_posicao     AS INTEGER,
                                          INPUT p_cod_campo       AS CHARACTER,
                                          input p_cod_separador   AS CHARACTER):

/* ************* Parametros da FUN€ÇO *******************************
** Fun‡Æo para tratamento dos Entries dos c¢digos livres
** 
**  p_num_posicao     - N£mero do Entry que ser  atualizado
**  p_cod_campo       - Campo / Vari vel que ser  atualizada
**  p_cod_separador   - Separador que ser  utilizado
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



/* Begin_Include: i_log_exec_prog_dtsul_fim */
if v_rec_log <> ? then do transaction:
    find log_exec_prog_dtsul where recid(log_exec_prog_dtsul) = v_rec_log exclusive-lock no-error.
    if  avail log_exec_prog_dtsul
    then do:
        assign log_exec_prog_dtsul.dat_fim_exec_prog_dtsul = today
               log_exec_prog_dtsul.hra_fim_exec_prog_dtsul = replace(string(time,"hh:mm:ss" /*l_hh:mm:ss*/ ),":":U,"":U).
    end /* if */.
    release log_exec_prog_dtsul.
end.

/* End_Include: i_log_exec_prog_dtsul_fim */

return.


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
** Procedure Interna.....: pi_retorna_tp_segto
** Descricao.............: pi_retorna_tp_segto
** Criado por............: tech14020
** Criado em.............: 08/09/2006 09:03:38
** Alterado por..........: corp1153
** Alterado em...........: 23/03/2009 11:29:03
*****************************************************************************/
PROCEDURE pi_retorna_tp_segto:

           def output parameter p_cod_segto as char.


           if p_cdn_segment_edi = 311 and p_cdn_element_edi = 5133 then do:

               find first tt_param_program_formul where
                    tt_param_program_formul.tta_cdn_segment_edi = 288 and
                    tt_param_program_formul.tta_cdn_element_edi = 3729
                    no-lock no-error.
               if tt_param_program_formul.ttv_des_contdo = '22' then
                  return "N" /*l_n*/ .
               else find first tt_param_program_formul where
                               tt_param_program_formul.tta_cdn_segment_edi = 288 and
                               tt_param_program_formul.tta_cdn_element_edi = 3729
                               no-lock no-error.
           end.
           else do:
               find first tt_param_program_formul where
                    tt_param_program_formul.tta_cdn_segment_edi = 289 and
                    tt_param_program_formul.tta_cdn_element_edi = 3729
                    no-lock no-error.
               if tt_param_program_formul.ttv_des_contdo = '22' then
                  return "N" /*l_n*/ .
               else find first tt_param_program_formul where
                               tt_param_program_formul.tta_cdn_segment_edi = 289 and
                               tt_param_program_formul.tta_cdn_element_edi = 3729
                               no-lock no-error.
           end.

           case int(trim(tt_param_program_formul.ttv_des_contdo)):
               when 1  then assign p_cod_segto = "J" /*l_J*/ .
               when 2  then assign p_cod_segto = "A" /*l_A*/ .
               when 3  then assign p_cod_segto = "A" /*l_A*/ .
               when 4  then assign p_cod_segto = "A" /*l_A*/ .
               when 5  then assign p_cod_segto = "J" /*l_J*/ .
               when 6  then assign p_cod_segto = "A" /*l_A*/ .
               when 7  then assign p_cod_segto = "A" /*l_A*/ .
               when 8  then assign p_cod_segto = "A" /*l_A*/ .
               when 20 then assign p_cod_segto = "O" /*l_o*/ .
               when 22 then assign p_cod_segto = "N" /*l_n*/ .
           end case.        
END PROCEDURE. /* pi_retorna_tp_segto */
/*****************************************************************************
** Procedure Interna.....: pi_segto_tipo_A
** Descricao.............: pi_segto_tipo_A
** Criado por............: tech14020
** Criado em.............: 08/09/2006 10:18:06
** Alterado por..........: corp1153
** Alterado em...........: 07/05/2009 11:44:29
*****************************************************************************/
PROCEDURE pi_segto_tipo_A:

        assign v_dsl_segto = '000'. /* posicao 018 a 020 (zeros) */

        find first tt_param_program_formul where
             tt_param_program_formul.tta_cdn_segment_edi = 289 and
             tt_param_program_formul.tta_cdn_element_edi = 3737
             no-lock no-error.

        assign v_dsl_segto = v_dsl_segto + string(int(tt_param_program_formul.ttv_des_contdo),'999') /* posicao 021 a 023 (Codigo Banco) */
               v_cdn_bco   = int(tt_param_program_formul.ttv_des_contdo).

        find tt_param_program_formul
             where tt_param_program_formul.tta_cdn_segment_edi = 289
             and   tt_param_program_formul.tta_cdn_element_edi = 3729 no-error.

        assign v_cdn_tip_forma_pagto = int(tt_param_program_formul.ttv_des_contdo).

        /* * Agªncia Favorecido **/
        find tt_param_program_formul
             where tt_param_program_formul.tta_cdn_segment_edi = 289
             and   tt_param_program_formul.tta_cdn_element_edi = 3922 no-error.
        if  v_cdn_bco = 341 
            then do:
             if length(tt_param_program_formul.ttv_des_contdo) > 4 
                then assign v_num_inic = length(tt_param_program_formul.ttv_des_contdo) - 3. 
                else assign v_num_inic = 1.

             assign v_cdn_agenc = int(substring(tt_param_program_formul.ttv_des_contdo,v_num_inic,4)).
        end.
        else do:
             if length(tt_param_program_formul.ttv_des_contdo) > 5
                then assign v_num_inic = length(tt_param_program_formul.ttv_des_contdo) - 4.
                else assign v_num_inic = 1.
             assign v_cdn_agenc = int(substring(tt_param_program_formul.ttv_des_contdo,v_num_inic,5)).
        end.

        /* * DAC conta Favorecido **/
        find tt_param_program_formul
             where tt_param_program_formul.tta_cdn_segment_edi = 289
             and   tt_param_program_formul.tta_cdn_element_edi = 3927 no-error.

        assign v_cod_digito = string(tt_param_program_formul.ttv_des_contdo).

        /* * Conta Corrente Favorecido **/
        find tt_param_program_formul
             where tt_param_program_formul.tta_cdn_segment_edi = 289
             and   tt_param_program_formul.tta_cdn_element_edi = 3796 no-error.
        if  v_cdn_bco = 341 
            then do:
            if length(tt_param_program_formul.ttv_des_contdo) > 5
               then assign v_num_inic = length(tt_param_program_formul.ttv_des_contdo) - 4.
               else assign v_num_inic = 1.
            assign v_val_cta_arq = dec(substring(tt_param_program_formul.ttv_des_contdo,v_num_inic,5)).
        end.
        else do:
            if length(tt_param_program_formul.ttv_des_contdo) > 12
               then assign v_num_inic = length(tt_param_program_formul.ttv_des_contdo) - 11.
               else assign v_num_inic = 1.
            assign v_val_cta_arq = dec(substring(tt_param_program_formul.ttv_des_contdo,v_num_inic,12)).
        end.

        if  v_cdn_tip_forma_pagto = 006 then
            assign v_val_cta_arq  = 0
                   v_cod_digito   = ''. 

            /* posicao 024 a 043 (Agencia/Conta Favorecido) */
            if  v_cdn_bco = 341 then do:
                if  v_cdn_tip_forma_pagto = 004 then  
                    assign v_val_cta_arq  = 0
                           v_cod_digito   = ''.

                if  length(string(v_cod_digito)) = 2 then
                    assign v_dsl_segto = v_dsl_segto + '0' + string(v_cdn_agenc,'9999') +
                                         ' ' + '0000000' + string(v_val_cta_arq,'99999') + 
                                         string(v_cod_digito,'99').
                else
                    assign v_dsl_segto = v_dsl_segto + '0' + string(v_cdn_agenc,'9999') +
                                         ' ' + '0000000' + string(v_val_cta_arq,'99999')  + 
                                         ' ' + string(v_cod_digito,'9').
        end.
        else do:
                if  length(string(v_cod_digito)) = 2 then
                    assign v_dsl_segto = v_dsl_segto + string(v_cdn_agenc,'99999') +
                                         ' ' + string(v_val_cta_arq,'999999999999') + 
                                         string(v_cod_digito,'99').
                else
                    assign v_dsl_segto = v_dsl_segto + string(v_cdn_agenc,'99999') +
                                         ' ' + string(v_val_cta_arq,'999999999999') + 
                                         ' ' + string(v_cod_digito,'9').
        end.

        find first tt_param_program_formul where
             tt_param_program_formul.tta_cdn_segment_edi = 289 and
             tt_param_program_formul.tta_cdn_element_edi = 3734
             no-lock no-error.
        assign v_dsl_segto = v_dsl_segto + string(tt_param_program_formul.ttv_des_contdo,"x(30)" /*l_x(30)*/ ). /* posicao 044 a 073 (Nome Favorecido) */

        find first tt_param_program_formul where
             tt_param_program_formul.tta_cdn_segment_edi = 289 and
             tt_param_program_formul.tta_cdn_element_edi = 3928
             no-lock no-error.
        assign v_dsl_segto = v_dsl_segto + string(tt_param_program_formul.ttv_des_contdo,"x(20)" /*l_x20*/ ). /* posicao 074 a 093 (Seu Numero) */

        find first tt_param_program_formul where
             tt_param_program_formul.tta_cdn_segment_edi = 289 and
             tt_param_program_formul.tta_cdn_element_edi = 3709
             no-lock no-error.
        assign v_dsl_segto = v_dsl_segto + string(tt_param_program_formul.ttv_des_contdo,"x(08)" /*l_x(08)*/ ) + /* posicao 094 a 101 (Data Pagamento) */
                             "REA" /*l_REA*/   + /* posicao 102 a 104 (Tipo Moeda) */
                             '000000000000000'. /* posicao 105 a 119 (Zeros) */

        if v_cdn_tip_forma_pagto = 4 or v_cdn_tip_forma_pagto = 6 then do:
           find first tt_param_program_formul where
                tt_param_program_formul.tta_cdn_segment_edi = 289 and
                tt_param_program_formul.tta_cdn_element_edi = 4421
                no-lock no-error.

           assign v_dec_aux = dec(tt_param_program_formul.ttv_des_contdo).
           assign v_dsl_segto = v_dsl_segto + string(v_dec_aux,'999999999999999'). /* posicao 120 a 134 (Valor Pagamento) */
        end.
        else do:
           find first tt_param_program_formul where
                tt_param_program_formul.tta_cdn_segment_edi = 289 and
                tt_param_program_formul.tta_cdn_element_edi = 4436
                no-lock no-error.
           assign v_dec_aux = dec(tt_param_program_formul.ttv_des_contdo).
           assign v_dsl_segto = v_dsl_segto + string(v_dec_aux,'999999999999999'). /* posicao 120 a 134 (Valor Pagamento) */
        end.

        find first tt_param_program_formul where
             tt_param_program_formul.tta_cdn_segment_edi = 289 and
             tt_param_program_formul.tta_cdn_element_edi = 3743
             no-lock no-error.
        assign v_dsl_segto = v_dsl_segto + fill(' ',15) + /* posicao 135 a 149 (Nosso Numero) */
                             fill(' ',5) + /* posicao 150 a 154 (Brancos) */
                             '00000000000000000000000' + /* posicao 155 a 177 (Zeros) */
                             fill(' ',20) + /* posicao 178 a 197 (Brancos) */
                             '000000'. /* posicao 198 a 203 (Zeros) */.

        find first tt_param_program_formul where
             tt_param_program_formul.tta_cdn_segment_edi = 289 and
             tt_param_program_formul.tta_cdn_element_edi = 3916
             no-lock no-error.
        assign v_dsl_segto = v_dsl_segto + string(tt_param_program_formul.ttv_des_contdo,'99999999999999') + /* posicao 204 a 217 (Nr. Inscri¯Êo) */
                             fill(' ',12) + /* posicao 218 a 229 (Brancos) */
                             '0' + /* posicao 230 a 230 (Aviso ao Favorecido) */
                             fill(' ',10). /* posicao 231 a 240 (Ocorr¬ncias) */
                             
        /* J-52 */
        assign v_dsl_segto = v_dsl_segto + chr(10). /* Gera chr(10) no final do registro para nÆo gerar exceto de colunas ( + 240) no registro tipo A */
        /* Fim-J-52 */
                            
END PROCEDURE. /* pi_segto_tipo_A */
/*****************************************************************************
** Procedure Interna.....: pi_segto_tipo_J
** Descricao.............: pi_segto_tipo_J
** Criado por............: tech14020
** Criado em.............: 08/09/2006 10:18:22
** Alterado por..........: corp1153
** Alterado em...........: 23/03/2009 11:44:11
*****************************************************************************/
PROCEDURE pi_segto_tipo_J:
    
    assign v_dsl_segto = ''.
    find tt_param_program_formul
        where tt_param_program_formul.tta_cdn_segment_edi = 289
        and   tt_param_program_formul.tta_cdn_element_edi = 2807 no-error.
    
    &if defined(BF_FIN_ALTER_CODIGO_BARRA) &then
        assign v_num_tam_format = 10.
    &else
        find first histor_exec_especial no-lock
             where histor_exec_especial.cod_modul_dtsul = "UFN" /*l_ufn*/  
             and   histor_exec_especial.cod_prog_dtsul  = "SPP_alter_codigo_barra" /*l_spp_alter_codigo_barra*/   no-error.
        if   avail histor_exec_especial then
             assign v_num_tam_format = 10.
        else assign v_num_tam_format = 12.
    &endif
    
    if  avail tt_param_program_formul then do:
        assign v_dec_aux    = dec(substring(tt_param_program_formul.ttv_des_contdo, 38, v_num_tam_format))
               /* posicao 018 a 061 (C«d. de Barras) */
               v_dsl_segto  = substring(tt_param_program_formul.ttv_des_contdo, 01, 03) +
                              substring(tt_param_program_formul.ttv_des_contdo, 04, 01) +
                              substring(tt_param_program_formul.ttv_des_contdo, 33, 01) +
                              substring(tt_param_program_formul.ttv_des_contdo, 34, 04) + 
                              string(v_dec_aux, '9999999999')                           +
                              substring(tt_param_program_formul.ttv_des_contdo, 05, 05) +
                              substring(tt_param_program_formul.ttv_des_contdo, 11, 10) +
                              substring(tt_param_program_formul.ttv_des_contdo, 22, 10).
    end.
    
     find first tt_param_program_formul where
          tt_param_program_formul.tta_cdn_segment_edi = 289 and
          tt_param_program_formul.tta_cdn_element_edi = 3734
          no-lock no-error.
    
     assign v_dsl_segto = v_dsl_segto + string(tt_param_program_formul.ttv_des_contdo,"x(30)" /*l_x(30)*/ ). /* posicao 062 a 091 (Nome Favorecido) */
    
     find first tt_param_program_formul where
          tt_param_program_formul.tta_cdn_segment_edi = 289 and
          tt_param_program_formul.tta_cdn_element_edi = 3606
          no-lock no-error.
    
     assign v_dsl_segto = v_dsl_segto + string(tt_param_program_formul.ttv_des_contdo,"x(08)" /*l_x(08)*/ ). /* posicao 092 a 099 (Data Vencimento) */
    
     find first tt_param_program_formul where
          tt_param_program_formul.tta_cdn_segment_edi = 289 and
          tt_param_program_formul.tta_cdn_element_edi = 4421
          no-lock no-error.
    
     assign v_dec_aux = dec(tt_param_program_formul.ttv_des_contdo).
    
     assign v_dsl_segto = v_dsl_segto + string(v_dec_aux,'999999999999999'). /* posicao 100 a 114 (Valor Tðtulo) */
    
     /* * Valor de Abatimentos **/
     find first tt_param_program_formul
         where tt_param_program_formul.tta_cdn_segment_edi = 289
         and   tt_param_program_formul.tta_cdn_element_edi = 4425 no-error.
     assign v_dec_aux = int(substring(tt_param_program_formul.ttv_des_contdo, 1,17)).
    
     /* * Valor de Descontos **/
     find tt_param_program_formul
         where tt_param_program_formul.tta_cdn_segment_edi = 289
         and   tt_param_program_formul.tta_cdn_element_edi = 4423 no-error.
     assign v_dec_aux2 = int(substring(tt_param_program_formul.ttv_des_contdo, 1,17)).
    
     assign v_dec_aux = v_dec_aux + v_dec_aux2.
    
     assign v_dsl_segto = v_dsl_segto + string(v_dec_aux,'999999999999999'). /* posicao 115 a 129 (Valor Descontos) */
    
     /* * Juros **/
     find first tt_param_program_formul
         where tt_param_program_formul.tta_cdn_segment_edi = 289
         and   tt_param_program_formul.tta_cdn_element_edi = 4422
         no-error.
     assign v_dec_aux = int(substring(tt_param_program_formul.ttv_des_contdo, 1,17)).
    
     /* * Multa **/
     find first tt_param_program_formul
         where tt_param_program_formul.tta_cdn_segment_edi = 289
         and   tt_param_program_formul.tta_cdn_element_edi = 4426
         no-error.
     assign v_dec_aux2 = int(substring(tt_param_program_formul.ttv_des_contdo, 1,17)).
    
     /* * Corre¯Êo Monet˜ria **/
     find tt_param_program_formul
         where tt_param_program_formul.tta_cdn_segment_edi = 289
         and   tt_param_program_formul.tta_cdn_element_edi = 4437
         no-error.
     assign v_dec_aux3 = int(substring(tt_param_program_formul.ttv_des_contdo, 1,17)).
    
     assign v_dec_aux = v_dec_aux + v_dec_aux2 + v_dec_aux3.
    
     assign v_dsl_segto = v_dsl_segto + string(v_dec_aux,'999999999999999'). /* posicao 130 a 144 (Acrýscimos) */
    
     find first tt_param_program_formul where
          tt_param_program_formul.tta_cdn_segment_edi = 289 and
          tt_param_program_formul.tta_cdn_element_edi = 3709
          no-lock no-error.
    
     assign v_dsl_segto = v_dsl_segto + string(tt_param_program_formul.ttv_des_contdo,"x(08)" /*l_x(08)*/ ). /* posicao 145 a 152 (Data Pagamento) */
    
     find first tt_param_program_formul where
          tt_param_program_formul.tta_cdn_segment_edi = 289 and
          tt_param_program_formul.tta_cdn_element_edi = 4436
          no-lock no-error.
    
     assign v_dec_aux = dec(tt_param_program_formul.ttv_des_contdo).
    
     assign v_dsl_segto = v_dsl_segto + string(v_dec_aux,'999999999999999') + /* posicao 153 a 167 (Valor Pagamento) */
                          '000000000000000'. /* posicao 168 a 182 (Zeros) */
    
     find first tt_param_program_formul where
          tt_param_program_formul.tta_cdn_segment_edi = 289 and
          tt_param_program_formul.tta_cdn_element_edi = 3928
          no-lock no-error.
    
     assign v_dsl_segto = v_dsl_segto + string(tt_param_program_formul.ttv_des_contdo,"x(20)" /*l_x20*/ ) + /* posicao 183 a 202 (Seu Numero) */
                          fill(' ',13) + /* posicao 203 a 215 (Brancos) */
                          fill(' ',15) + /* posicao 216 a 230 (Brancos) */
                          fill(' ',10). /* posicao 231 a 240 (Brancos) */
    
    /* In¡cio - Altera‡Æo J-52 */
            /* gera segunda parte - procura sequencia do registro */ 
            find first tt_segment_tot no-lock
                 where tt_segment_tot.tta_cdn_segment_edi = 309 no-error.
    
            if avail tt_segment_tot then
                assign  v_num_reg_bloco = tt_segment_tot.ttv_qtd_bloco_docto.
            
            /* Atualiza somat½ria dos blocos*/
            find first tt_segment_tot no-lock
                 where tt_segment_tot.tta_cdn_segment_edi = 999999 no-error.
    
            if avail tt_segment_tot then
               assign  tt_segment_tot.ttv_qtd_proces_edi  = tt_segment_tot.ttv_qtd_proces_edi  + 1
                       tt_segment_tot.ttv_qtd_bloco_docto = tt_segment_tot.ttv_qtd_bloco_docto + 1.
            
            /* localiza o bloco */
            find first tt_param_program_formul no-lock
                where tt_param_program_formul.tta_cdn_segment_edi = 0
                and tt_param_program_formul.tta_cdn_element_edi = 2
                and tt_param_program_formul.tta_des_label_utiliz_formul_edi = 'QTD BLOCOS' no-error.
            if avail tt_param_program_formul then
                assign v_num_bloco = int(tt_param_program_formul.ttv_des_contdo) + 1.
                
            /* --- Codigo Banco ---*/
            find tt_param_program_formul
                 where tt_param_program_formul.tta_cdn_segment_edi = 288
                 and   tt_param_program_formul.tta_cdn_element_edi = 4681 no-error. 
            if avail tt_param_program_formul then
               assign v_cdn_bco = int(tt_param_program_formul.ttv_des_contdo).

            /* --- N£mero do T¡tulo ---*/
            find tt_param_program_formul no-lock
                where tt_param_program_formul.tta_cdn_segment_edi = 289
                and   tt_param_program_formul.tta_cdn_element_edi = 3928 no-error.
            if avail tt_param_program_formul then
                assign v_cdn_contador = 20 - length(substring(tt_param_program_formul.ttv_des_contdo,1,20))
                       v_cod_tit_ap = substring(tt_param_program_formul.ttv_des_contdo,1,20) + fill(" ",v_cdn_contador).
            
            /* --- Tipo do Movimento ---*/
            if  entry(4, v_cod_tit_ap, ";") = "" then
                assign v_cod_tip_movto  = '000'. /* InclusÆo de Pagamento */
            else
                assign v_cod_tip_movto  = '999'. /* ExclusÆo de pagamento inclu¡do anteriormente */
            
            if avail tt_param_program_formul then do:
                /* --- Sacado ---*/
                find first estabelecimento no-lock
                where estabelecimento.cod_estab = getentryfield(1,tt_param_program_formul.ttv_des_contdo,';') no-error.
                if avail estabelecimento then
                   assign v_num_tip_id_feder_sacad = 2
                          v_cod_id_feder_sacad     = string(estabelecimento.cod_id_feder,'99999999999999')
                          v_nom_sacad              = estabelecimento.nom_pessoa.  
            end.
            
            /* tipo CGC/CPF Favorecido */
            find tt_param_program_formul no-lock
                where tt_param_program_formul.tta_cdn_segment_edi = 289
                and   tt_param_program_formul.tta_cdn_element_edi = 3915 no-error.
            if avail tt_param_program_formul then
                assign v_num_tip_id_feder = int(tt_param_program_formul.ttv_des_contdo).
    
            /* CGC/CPF favorecido */
            find tt_param_program_formul no-lock
                where tt_param_program_formul.tta_cdn_segment_edi = 289
                and   tt_param_program_formul.tta_cdn_element_edi = 3916 no-error.
            if avail tt_param_program_formul then
                assign v_cod_id_feder_favorec = tt_param_program_formul.ttv_des_contdo.
            
            /* --- Nome do Favorecido ---*/
            find tt_param_program_formul no-lock
                where tt_param_program_formul.tta_cdn_segment_edi = 289
                and   tt_param_program_formul.tta_cdn_element_edi = 3734 no-error.
            if avail tt_param_program_formul then
                assign v_nom_favorec = tt_param_program_formul.ttv_des_contdo.

            /* --- Informa‡äes Beneficiario/Fornecedor ---*/
            assign v_num_tip_id_feder_fornec = 0
                   v_cod_id_feder_fornec     = "000000000000000"
                   v_nom_fornec              = string(fill(" ", 40),"x(40)").

            &if defined(BF_FIN_BENEFICIARIO) &then
                find tt_param_program_formul no-lock
                    where tt_param_program_formul.tta_cdn_segment_edi = 289
                    and   tt_param_program_formul.tta_cdn_element_edi = 3928 no-error.
                if avail tt_param_program_formul then do:
    
                    find first item_bord_ap no-lock
                         where item_bord_ap.cod_estab_bord      = getentryfield(1,tt_param_program_formul.ttv_des_contdo,';')
                         and   item_bord_ap.num_id_item_bord_ap = INT(getentryfield(2,tt_param_program_formul.ttv_des_contdo,';')) no-error.
                    if avail item_bord_ap then do:
                        find first tit_ap no-lock
                            where tit_ap.cod_estab = item_bord_ap.cod_estab
                              and tit_ap.cod_espec_docto = item_bord_ap.cod_espec_docto
                              and tit_ap.cod_ser_docto = item_bord_ap.cod_ser_docto
                              and tit_ap.cdn_fornecedor = item_bord_ap.cdn_fornecedor
                              and tit_ap.cod_tit_ap = item_bord_ap.cod_tit_ap
                              and tit_ap.cod_parcela = item_bord_ap.cod_parcela no-error.
                        if avail tit_ap then do:
    
                            find first ext_tit_ap 
                                where ext_tit_ap.cod_estab     = tit_ap.cod_estab
                                  and ext_tit_ap.num_id_tit_ap = tit_ap.num_id_tit_ap no-lock no-error.
                            if avail ext_tit_ap and ext_tit_ap.cod_id_feder_benef <> "" and ext_tit_ap.cod_id_feder_benef <> "0" then do:
                                /* Sacador - O fornecedor do boleto */
                                assign v_num_tip_id_feder_fornec = v_num_tip_id_feder
                                       v_cod_id_feder_fornec     = v_cod_id_feder_favorec  
                                       v_nom_fornec              = v_nom_favorec.
            
                                /* Beneficiario/Cedente - Factoring*/ 
                                if ext_tit_ap.ind_tip_pessoa_benef = "F¡sica" then
                                    assign v_num_tip_id_feder = 1.
                                else
                                    assign v_num_tip_id_feder = 2.
    
                                assign v_cod_id_feder_favorec = string(ext_tit_ap.cod_id_feder_benef,'999999999999999')
                                       v_nom_favorec          = ext_tit_ap.nom_pessoa_benef. 
    
                                
                            end.
    
                        end.
                    end.
                end.
            &endif
           
            assign v_cod_j52   = string(v_cdn_bco,"999")                               + /* Codigo do Banco */
                                 string(v_num_bloco,"9999")                            + /* Codigo do Lote */
                                 "3"                                                   + /* Tipo de Registro */
                                 string(v_num_reg_bloco,"99999")                       + /* N£mero do Registro */
                                 "J"                                                   + /* Segmento */
                                 string(v_cod_tip_movto,"999")                         + /* Tipo de Movimento */
                                 "52"                                                  + /* Codigo de Registro */
                                 string(v_num_tip_id_feder_sacad,"9")                  + /* Tipo Inscri‡Æo Sacado */
                                 string(dec(v_cod_id_feder_sacad)  ,"999999999999999") + /* Numero Inscri‡Æo Sacado */
                                 string(v_nom_sacad,"x(40)")                           + /* Nome Sacado */
                                 string(v_num_tip_id_feder,"9")                        + /* Tipo Inscri‡Æo Cedente */
                                 string(dec(v_cod_id_feder_favorec),"999999999999999") + /* Numero Inscri‡Æo Cedente */
                                 string(v_nom_favorec,"x(40)")                         + /* Nome Cedente */ 
                                 string(v_num_tip_id_feder_fornec,"9")                 + /* Tipo Inscri‡Æo Sacador/Avalista */
                                 string(dec(v_cod_id_feder_fornec),"999999999999999")  + /* Numero Inscri‡Æo Sacador/Avalista */
                                 string(v_nom_fornec,"x(40)")                           /* Nome Sacador/Avalista */
                                
                  v_cod_j52   = v_cod_j52 + fill(" ",(240 - length(v_cod_j52))).
   
           assign v_dsl_segto = v_dsl_segto + chr(10) + v_cod_j52.
          
            /* FIM - Altera‡Æo J-52 */

END PROCEDURE. /* pi_segto_tipo_J */
/*****************************************************************************
** Procedure Interna.....: pi_segto_tipo_N
** Descricao.............: pi_segto_tipo_N
** Criado por............: tech14020
** Criado em.............: 08/09/2006 10:21:22
** Alterado por..........: fut41420
** Alterado em...........: 11/11/2009 10:03:29
*****************************************************************************/
PROCEDURE pi_segto_tipo_N:

    /************************** Buffer Definition Begin *************************/

    &if "{&emsuni_version}" >= "1.00" &then
    def buffer b_pessoa_jurid
        for pessoa_jurid.
    &endif


    /*************************** Buffer Definition End **************************/

    /************************* Variable Definition Begin ************************/

    def var v_des_conteudo
        as character
        format "x(40)":U
        label "Texto"
        column-label "Texto"
        no-undo.


    /************************** Variable Definition End *************************/

                 find tt_param_program_formul
                      where tt_param_program_formul.tta_cdn_segment_edi = 288
                      and   tt_param_program_formul.tta_cdn_element_edi = 4838 no-error.

                 assign v_forma_pagto = trim(tt_param_program_formul.ttv_des_contdo)
                        v_dsl_segto   = ''.

                 case v_forma_pagto:
                    when '16' then do: /* DARF */

                         assign v_dsl_segto = '02'. /* Identifica¯Êo Tributo */

                         find first tt_param_program_formul where
                              tt_param_program_formul.tta_cdn_segment_edi = 289 and
                              tt_param_program_formul.tta_cdn_element_edi = 3928
                              no-lock no-error.

                          assign v_des_conteudo = tt_param_program_formul.ttv_des_contdo.

                         find first tt_param_program_formul where
                              tt_param_program_formul.tta_cdn_segment_edi = 289 and
                              tt_param_program_formul.tta_cdn_element_edi = 3895
                              no-lock no-error.


                          if entry(3,v_des_conteudo,';') = "N" /*l_n*/   then do:
                              find first item_bord_ap no-lock
                                   where item_bord_ap.cod_estab_bord = entry(1,v_des_conteudo,';')
                                     and item_bord_ap.num_id_item_bord_ap = int(entry(2,v_des_conteudo,';')) no-error.
                              if avail item_bord_ap then
                                  find first compl_impto_retid_ap
                                       where compl_impto_retid_ap.num_id_tit_ap = int(tt_param_program_formul.ttv_des_contdo)
                                         and compl_impto_retid_ap.cod_estab     = item_bord_ap.cod_estab no-lock no-error.
                          end.
                          else do:
                              find first item_bord_ap_agrup no-lock
                                   where item_bord_ap_agrup.cod_estab_bord =  entry(1,v_des_conteudo,';')
                                     and item_bord_ap_agrup.num_id_agrup_item_bord_ap =  int(entry(2,v_des_conteudo,';'))  no-error.
                              if avail item_bord_ap_agrup then do:
                                  blk_teste:
                                  for each item_bord_ap no-lock
                                     where item_bord_ap.cod_estab_bord = item_bord_ap_agrup.cod_estab_bord
                                       and item_bord_ap.num_id_agrup_item_bord_ap = item_bord_ap_agrup.num_id_agrup_item_bord_ap
                                       break by item_bord_ap.cod_estab:
                                       if first-of (item_bord_ap.cod_estab) then do:
                                           find first compl_impto_retid_ap
                                                where compl_impto_retid_ap.num_id_tit_ap = int(tt_param_program_formul.ttv_des_contdo)
                                                  and compl_impto_retid_ap.cod_estab     = item_bord_ap.cod_estab no-lock no-error.
                                           if avail compl_impto_retid_ap then
                                               leave blk_teste.

                                       end.
                                  end.
                              end.
                          end.

                         assign v_dsl_segto = v_dsl_segto + string(compl_impto_retid_ap.cod_classif_impto,'9999'). /* C½digo Receita */                         

                         find first estabelecimento where 
                            estabelecimento.cod_estab = getentryfield(1,v_des_conteudo,';') no-lock no-error.
                         if avail estabelecimento then do:
                             find first b_pessoa_jurid where
                                 b_pessoa_jurid.num_pessoa_jurid = estabelecimento.num_pessoa_jurid no-lock no-error.
                          end.

                         find first fornecedor where
                              fornecedor.cod_empresa    = compl_impto_retid_ap.cod_empresa and
                              fornecedor.cdn_fornecedor = compl_impto_retid_ap.cdn_fornecedor 
                              no-lock no-error.


                         if avail b_pessoa_jurid then do:
                             assign v_tp_forn = 2. /* Pessoa Juridica */.
                             assign v_dsl_segto = v_dsl_segto + 
                                                     string(v_tp_forn,'9') + /* Tipo Inscri‡Æo */
                                                     string(b_pessoa_jurid.cod_id_feder,'99999999999999'). /* Identificador */

                         end.
                         else do:
                             if fornecedor.num_pessoa modulo 2 = 0 then do:
                                assign v_tp_forn = 1. /* Pessoa Fisica */

                                find first pessoa_fisic where
                                     pessoa_fisic.num_pessoa_fisic = fornecedor.num_pessoa
                                     no-lock no-error.

                                assign v_dsl_segto = v_dsl_segto + 
                                                     string(v_tp_forn,"9") + /* Tipo Inscri»’o */
                                                     string(pessoa_fisic.cod_id_feder,'99999999999999'). /* Identificador */

                             end.
                             else do:
                                assign v_tp_forn = 2. /* Pessoa Juridica */.

                                find first pessoa_jurid where
                                     pessoa_jurid.num_pessoa_jurid = fornecedor.num_pessoa
                                     no-lock no-error.

                                assign v_dsl_segto = v_dsl_segto + 
                                                     string(v_tp_forn,'9') + /* Tipo Inscri»’o */
                                                     string(pessoa_jurid.cod_id_feder,'99999999999999'). /* Identificador */
                             end.
                         end.
                         find first tt_param_program_formul where
                              tt_param_program_formul.tta_cdn_segment_edi = 289 and
                              tt_param_program_formul.tta_cdn_element_edi = 3704
                              no-lock no-error.

                         assign v_dsl_segto = v_dsl_segto + tt_param_program_formul.ttv_des_contdo + /* Per­odo */
                                              '00000000000000000'. /* Refer¼ncia */

                         find first tt_param_program_formul where
                              tt_param_program_formul.tta_cdn_segment_edi = 289 and  
                              tt_param_program_formul.tta_cdn_element_edi = 4421
                              no-lock no-error.

                         assign v_dec_aux = dec(tt_param_program_formul.ttv_des_contdo).

                         assign v_dsl_segto = v_dsl_segto + string(v_dec_aux,'99999999999999'). /* Valor Principal */

                         find first tt_param_program_formul where
                              tt_param_program_formul.tta_cdn_segment_edi = 289 and
                              tt_param_program_formul.tta_cdn_element_edi = 4426
                              no-lock no-error.

                         assign v_dec_aux = dec(tt_param_program_formul.ttv_des_contdo).

                         assign v_dsl_segto = v_dsl_segto + string(v_dec_aux,'99999999999999'). /* Multa */

                         find first tt_param_program_formul where
                              tt_param_program_formul.tta_cdn_segment_edi = 289 and
                              tt_param_program_formul.tta_cdn_element_edi = 4422
                              no-lock no-error.

                         assign v_dec_aux = dec(tt_param_program_formul.ttv_des_contdo).

                         assign v_dsl_segto = v_dsl_segto + string(v_dec_aux,'99999999999999'). /* Juros / Encargos */

                         find first tt_param_program_formul where
                              tt_param_program_formul.tta_cdn_segment_edi = 289 and
                              tt_param_program_formul.tta_cdn_element_edi = 4436
                              no-lock no-error.

                         assign v_dec_aux = dec(tt_param_program_formul.ttv_des_contdo).

                         assign v_dsl_segto = v_dsl_segto + string(v_dec_aux,'99999999999999'). /* Valor Total */

                         find first tt_param_program_formul where
                              tt_param_program_formul.tta_cdn_segment_edi = 289 and
                              tt_param_program_formul.tta_cdn_element_edi = 3606
                              no-lock no-error.

                         assign v_dsl_segto = v_dsl_segto + tt_param_program_formul.ttv_des_contdo. /* Data Vencimento */

                         find first tt_param_program_formul where
                              tt_param_program_formul.tta_cdn_segment_edi = 289 and
                              tt_param_program_formul.tta_cdn_element_edi = 3709
                              no-lock no-error.

                         assign v_dsl_segto = v_dsl_segto + tt_param_program_formul.ttv_des_contdo + /* Data Pagamento */
                                              string(' ',"x(30)" /*l_x(30)*/ ). /* Brancos */


                         if avail b_pessoa_jurid then do:
                            assign v_dsl_segto = v_dsl_segto + string(b_pessoa_jurid.nom_pessoa,"x(30)" /*l_x(30)*/ ).
                         end.
                         else do:
                             if v_tp_forn = 1 then
                                assign v_dsl_segto = v_dsl_segto + string(pessoa_fisic.nom_pessoa,"x(30)" /*l_x(30)*/ ).
                             else
                                assign v_dsl_segto = v_dsl_segto + string(pessoa_jurid.nom_pessoa,"x(30)" /*l_x(30)*/ ).
                         end.       

                         find first tt_param_program_formul where
                              tt_param_program_formul.tta_cdn_segment_edi = 289 and
                              tt_param_program_formul.tta_cdn_element_edi = 3928
                              no-lock no-error.

                         assign v_dsl_segto = v_dsl_segto + string(tt_param_program_formul.ttv_des_contdo,"x(20)" /*l_x20*/ ) +  /* Seu Nœmero */
                                              string(' ',"x(15)" /*l_x(15)*/ ) + /* Nosso Nœmero */
                                              string(' ',"x(10)" /*l_x(10)*/ ). /* Ocorr¼ncias */
                    end.
                    when '17' then do: /* Pagamento GPS */

                        /* Begin_Include: i_pagamento_gps_17 */
                        assign v_dsl_segto = '01'. /* Identifica»’o Tributo */

                        find first tt_param_program_formul where
                                   tt_param_program_formul.tta_cdn_segment_edi = 289 and
                                   tt_param_program_formul.tta_cdn_element_edi = 3928 
                        no-lock no-error.

                        assign v_des_conteudo = tt_param_program_formul.ttv_des_contdo.

                        find first tt_param_program_formul where
                                   tt_param_program_formul.tta_cdn_segment_edi = 289 and
                                   tt_param_program_formul.tta_cdn_element_edi = 3895
                        no-lock no-error.

                        if entry(3,v_des_conteudo,';') = "N" /*l_n*/  then do:
                            find first item_bord_ap no-lock
                                 where item_bord_ap.cod_estab_bord = entry(1,v_des_conteudo,';')
                                   and item_bord_ap.num_id_item_bord_ap = int(entry(2,v_des_conteudo,';')) no-error.
                            if avail item_bord_ap then
                                find first compl_impto_retid_ap
                                     where compl_impto_retid_ap.num_id_tit_ap = int(tt_param_program_formul.ttv_des_contdo)
                                       and compl_impto_retid_ap.cod_estab     = item_bord_ap.cod_estab no-lock no-error.
                        end.
                        else do:
                           find first item_bord_ap_agrup no-lock
                                where item_bord_ap_agrup.cod_estab_bord =  entry(1,v_des_conteudo,';')
                                  and item_bord_ap_agrup.num_id_agrup_item_bord_ap =  int(entry(2,v_des_conteudo,';'))  no-error.
                           if avail item_bord_ap_agrup then do:
                               blk_teste:
                               for each item_bord_ap no-lock
                                  where item_bord_ap.cod_estab_bord = item_bord_ap_agrup.cod_estab_bord
                                    and item_bord_ap.num_id_agrup_item_bord_ap = item_bord_ap_agrup.num_id_agrup_item_bord_ap
                                    break by item_bord_ap.cod_estab:
                                    if first-of (item_bord_ap.cod_estab) then do:
                                        find first compl_impto_retid_ap
                                             where compl_impto_retid_ap.num_id_tit_ap = int(tt_param_program_formul.ttv_des_contdo)
                                               and compl_impto_retid_ap.cod_estab     = item_bord_ap.cod_estab no-lock no-error.
                                        if avail compl_impto_retid_ap then
                                            leave blk_teste.

                                   end.
                               end.
                           end.
                        end.

                        find first tt_param_program_formul where
                                   tt_param_program_formul.tta_cdn_segment_edi = 289 and
                                   tt_param_program_formul.tta_cdn_element_edi = 3885
                        no-lock no-error.


                        ASSIGN dt-aux = date(tt_param_program_formul.ttv_des_contdo)
                             c-mes = MONTH(dt-aux)
                             c-ano = YEAR(dt-aux)
                             c-aux = STRING(c-mes,"99") + string(c-ano,'9999').

                        assign v_dsl_segto = v_dsl_segto + string(compl_impto_retid_ap.cod_classif_impto,'9999') + /* C½digo Pagamento */
                               string(c-aux,'999999'). /* Mes e Ano Competencia */

                        find first fornecedor where
                                   fornecedor.cod_empresa    = compl_impto_retid_ap.cod_empresa and
                                   fornecedor.cdn_fornecedor = compl_impto_retid_ap.cdn_fornecedor 
                        no-lock no-error.

                        if fornecedor.num_pessoa modulo 2 = 0 then
                            assign v_tp_forn = 1. /* Pessoa Fisica */
                        else
                            assign v_tp_forn = 2. /* Pessoa Juridica */.

                        if v_tp_forn = 2 then do:
                            find first pessoa_jurid where
                                       pessoa_jurid.num_pessoa_jurid = fornecedor.num_pessoa
                            no-lock no-error.
                            assign v_dsl_segto = v_dsl_segto + string(dec(pessoa_jurid.cod_id_feder),'99999999999999'). /* Identificador Contribuinte */
                        end.
                        else do:
                            find first pessoa_fisic where
                                       pessoa_fisic.num_pessoa_fisic = fornecedor.num_pessoa
                            no-lock no-error.

                            assign v_dsl_segto = v_dsl_segto + string(dec(pessoa_fisic.cod_id_feder),'99999999999999'). /* Identificador Contribuinte  */
                        end.

                        find first tt_param_program_formul where
                                   tt_param_program_formul.tta_cdn_segment_edi = 289 and
                                   tt_param_program_formul.tta_cdn_element_edi = 4421
                        no-lock no-error.

                        assign v_dec_aux = dec(tt_param_program_formul.ttv_des_contdo).

                        find first classif_impto
                             where classif_impto.cod_pais          = compl_impto_retid_ap.cod_pais
                               and classif_impto.cod_unid_federac  = compl_impto_retid_ap.cod_unid_federac
                               and classif_impto.cod_imposto       = compl_impto_retid_ap.cod_imposto
                               and classif_impto.cod_classif_impto = compl_impto_retid_ap.cod_classif_impto no-lock no-error.

                        if avail classif_impto then do:
                            find first imposto
                                 where imposto.cod_pais         = classif_impto.cod_pais
                                   and imposto.cod_unid_federac = classif_impto.cod_unid_federac
                                   and imposto.cod_imposto      = classif_impto.cod_imposto no-lock no-error.

                           if avail imposto then do:
                               if imposto.ind_tip_impto = 'SEST/SENAT':U then do:                        
                                   assign v_dsl_segto = v_dsl_segto + '00000000000000' + /* Valor Tributo */
                                          string(v_dec_aux,'99999999999999') . /* Valor Outras Entidades */           
                               end. 
                               else do:
                                   assign v_dsl_segto = v_dsl_segto + string(v_dec_aux,'99999999999999') + /* Valor Tributo */
                                                       '00000000000000'. /* Valor Outras Entidades */                  
                               end.
                           end.
                        end. /* if classif_impto */                     

                        find first tt_param_program_formul where
                                   tt_param_program_formul.tta_cdn_segment_edi = 289 and
                                   tt_param_program_formul.tta_cdn_element_edi = 4426  
                        no-lock no-error. 

                        assign v_dec_aux = dec(tt_param_program_formul.ttv_des_contdo).

                        assign v_dsl_segto = v_dsl_segto + string(v_dec_aux,'99999999999999'). /* Vlr Multa T­tulo */

                        find first tt_param_program_formul where
                                   tt_param_program_formul.tta_cdn_segment_edi = 289 and
                                   tt_param_program_formul.tta_cdn_element_edi = 4436
                        no-lock no-error.

                        assign v_dec_aux = dec(tt_param_program_formul.ttv_des_contdo).

                        assign v_dsl_segto = v_dsl_segto + string(v_dec_aux,'99999999999999'). /* Valor Arrecadado */

                        find first tt_param_program_formul where
                                   tt_param_program_formul.tta_cdn_segment_edi = 289 and
                                   tt_param_program_formul.tta_cdn_element_edi = 3709
                        no-lock no-error.

                        assign v_dsl_segto = v_dsl_segto + tt_param_program_formul.ttv_des_contdo +  /* Data Arrecada¯Êo */
                               string(' ',"x(08)" /*l_x(08)*/ ). /* Brancos */

                        find first tt_param_program_formul where
                                   tt_param_program_formul.tta_cdn_segment_edi = 289 and
                                   tt_param_program_formul.tta_cdn_element_edi = 75
                        no-lock no-error.

                        assign v_dsl_segto = v_dsl_segto + string(tt_param_program_formul.ttv_des_contdo,"x(50)" /*l_x(50)*/ ).  /* Uso Empresa */


                        if v_tp_forn = 2 then
                            assign v_dsl_segto = v_dsl_segto + string(pessoa_jurid.nom_pessoa,"x(30)" /*l_x(30)*/ ). /* Nome Contribuinte */
                        else 
                            assign v_dsl_segto = v_dsl_segto + string(pessoa_fisic.nom_pessoa,"x(30)" /*l_x(30)*/ ). /* Nome Contribuinte */

                        find first tt_param_program_formul where
                                   tt_param_program_formul.tta_cdn_segment_edi = 289 and
                                   tt_param_program_formul.tta_cdn_element_edi = 3928
                        no-lock no-error.

                        assign v_dsl_segto = v_dsl_segto + string(tt_param_program_formul.ttv_des_contdo,"x(20)" /*l_x(20)*/ ) +  /* Seu Nßmero */
                               string(' ',"x(15)" /*l_x(15)*/ ) + /* Nosso Nœmero */
                               string(' ',"x(10)" /*l_x(10)*/ ). /* Ocorr¼ncias */


                        /* End_Include: i_pagamento_gps_17 */

                    end.    

                    when '18' then do: /* DARF Simples */

                      assign v_dsl_segto = '03'. /* Identifica¯Êo Tributo */

                      find first tt_param_program_formul where
                           tt_param_program_formul.tta_cdn_segment_edi = 289 and
                           tt_param_program_formul.tta_cdn_element_edi = 3928
                           no-lock no-error.

                      assign v_des_conteudo = tt_param_program_formul.ttv_des_contdo.

                      find first tt_param_program_formul where
                           tt_param_program_formul.tta_cdn_segment_edi = 289 and
                           tt_param_program_formul.tta_cdn_element_edi = 3895
                           no-lock no-error.

                       if entry(3,v_des_conteudo,';') = "N" /*l_n*/   then do:
                           find first item_bord_ap no-lock
                                where item_bord_ap.cod_estab_bord = entry(1,v_des_conteudo,';')
                                  and item_bord_ap.num_id_item_bord_ap = int(entry(2,v_des_conteudo,';')) no-error.
                           if avail item_bord_ap then
                               find first compl_impto_retid_ap
                                    where compl_impto_retid_ap.num_id_tit_ap = int(tt_param_program_formul.ttv_des_contdo)
                                      and compl_impto_retid_ap.cod_estab     = item_bord_ap.cod_estab no-lock no-error.
                       end.
                       else do:
                           find first item_bord_ap_agrup no-lock
                                where item_bord_ap_agrup.cod_estab_bord =  entry(1,v_des_conteudo,';')
                                  and item_bord_ap_agrup.num_id_agrup_item_bord_ap =  int(entry(2,v_des_conteudo,';'))  no-error.
                           if avail item_bord_ap_agrup then do:
                               blk_teste:
                               for each item_bord_ap no-lock
                                  where item_bord_ap.cod_estab_bord = item_bord_ap_agrup.cod_estab_bord
                                    and item_bord_ap.num_id_agrup_item_bord_ap = item_bord_ap_agrup.num_id_agrup_item_bord_ap
                                    break by item_bord_ap.cod_estab:
                                    if first-of (item_bord_ap.cod_estab) then do:
                                        find first compl_impto_retid_ap
                                             where compl_impto_retid_ap.num_id_tit_ap = int(tt_param_program_formul.ttv_des_contdo)
                                               and compl_impto_retid_ap.cod_estab     = item_bord_ap.cod_estab no-lock no-error.
                                        if avail compl_impto_retid_ap then
                                            leave blk_teste.
                                    end.
                               end.
                          end.                             
                      end.

                      assign v_dsl_segto = v_dsl_segto + string(compl_impto_retid_ap.cod_classif_impto,'9999'). /* C«digo Receita */


                      find first estabelecimento where 
                          estabelecimento.cod_estab = getentryfield(1,v_des_conteudo,';') no-lock no-error.
                      if avail estabelecimento then do:
                          find first b_pessoa_jurid where
                                     b_pessoa_jurid.num_pessoa_jurid = estabelecimento.num_pessoa_jurid no-lock no-error.
                      end.

                      find first fornecedor where
                           fornecedor.cod_empresa    = compl_impto_retid_ap.cod_empresa and
                           fornecedor.cdn_fornecedor = compl_impto_retid_ap.cdn_fornecedor 
                           no-lock no-error.

                      if avail b_pessoa_jurid then do:
                             assign v_tp_forn = 2. /* Pessoa Juridica */.

                             assign v_dsl_segto = v_dsl_segto + 
                                                  string(v_tp_forn,'9') + /* Tipo Inscri¯Êo */
                                                  string(b_pessoa_jurid.cod_id_feder,'99999999999999'). /* InscriîÒo Empresa */
                      end.
                      else do:
                          if fornecedor.num_pessoa modulo 2 = 0 then do:
                             assign v_tp_forn = 1. /* Pessoa Fisica */

                             find first pessoa_fisic where
                                  pessoa_fisic.num_pessoa_fisic = fornecedor.num_pessoa
                                  no-lock no-error.

                             assign v_dsl_segto = v_dsl_segto + 
                                                  string(v_tp_forn,'9') + /* Tipo Inscri»’o */
                                                  string(pessoa_fisic.cod_id_feder,'99999999999999'). /* Inscri»’o Empresa */

                          end.
                          else do:
                             assign v_tp_forn = 2. /* Pessoa Juridica */.

                             find first pessoa_jurid where
                                  pessoa_jurid.num_pessoa_jurid = fornecedor.num_pessoa
                                  no-lock no-error.

                             assign v_dsl_segto = v_dsl_segto + 
                                                  string(v_tp_forn,'9') + /* Tipo Inscri»’o */
                                                  string(pessoa_jurid.cod_id_feder,'99999999999999'). /* Inscri¯Êo Empresa */
                          end.
                      end.
                      find first tt_param_program_formul where
                           tt_param_program_formul.tta_cdn_segment_edi = 289 and
                           tt_param_program_formul.tta_cdn_element_edi = 3704
                           no-lock no-error.

                      assign v_dsl_segto = v_dsl_segto + tt_param_program_formul.ttv_des_contdo + /* Per­odo */
                                           string((compl_impto_retid_ap.val_rendto_tribut * 100),'999999999') + /* Receita Bruta */
                                           string((compl_impto_retid_ap.val_aliq_impto * 100),'9999') + /* Percentual */
                                           string(' ',"x(04)" /*l_x(4)*/ ). /* Brancos */

                      find first tt_param_program_formul where
                           tt_param_program_formul.tta_cdn_segment_edi = 289 and
                           tt_param_program_formul.tta_cdn_element_edi = 4421
                           no-lock no-error.

                      assign v_dec_aux = dec(tt_param_program_formul.ttv_des_contdo).

                      assign v_dsl_segto = v_dsl_segto + string(v_dec_aux,'99999999999999'). /* Valor Principal */

                      find first tt_param_program_formul where
                           tt_param_program_formul.tta_cdn_segment_edi = 289 and
                           tt_param_program_formul.tta_cdn_element_edi = 4426
                           no-lock no-error.

                      assign v_dec_aux = dec(tt_param_program_formul.ttv_des_contdo).

                      assign v_dsl_segto = v_dsl_segto + string(v_dec_aux,'99999999999999'). /* Multa */

                      find first tt_param_program_formul where
                           tt_param_program_formul.tta_cdn_segment_edi = 289 and
                           tt_param_program_formul.tta_cdn_element_edi = 4422
                           no-lock no-error.

                      assign v_dec_aux = dec(tt_param_program_formul.ttv_des_contdo).

                      assign v_dsl_segto = v_dsl_segto + string(v_dec_aux,'99999999999999'). /* Juros / Encargos */

                      find first tt_param_program_formul where
                           tt_param_program_formul.tta_cdn_segment_edi = 289 and
                           tt_param_program_formul.tta_cdn_element_edi = 4436
                           no-lock no-error.

                      assign v_dec_aux = dec(tt_param_program_formul.ttv_des_contdo).

                      assign v_dsl_segto = v_dsl_segto + string(v_dec_aux,'99999999999999'). /* Valor Total */

                      find first tt_param_program_formul where
                           tt_param_program_formul.tta_cdn_segment_edi = 289 and
                           tt_param_program_formul.tta_cdn_element_edi = 3606
                           no-lock no-error.

                      assign v_dsl_segto = v_dsl_segto + tt_param_program_formul.ttv_des_contdo. /* Data Vencimento */

                      find first tt_param_program_formul where
                           tt_param_program_formul.tta_cdn_segment_edi = 289 and
                           tt_param_program_formul.tta_cdn_element_edi = 3709
                           no-lock no-error.

                      assign v_dsl_segto = v_dsl_segto + tt_param_program_formul.ttv_des_contdo + /* Data Pagamento */
                                           string(' ',"x(30)" /*l_x(30)*/ ). /* Brancos */

                      if avail b_pessoa_jurid then do:
                          assign v_dsl_segto = v_dsl_segto + string(b_pessoa_jurid.nom_pessoa,"x(30)" /*l_x(30)*/ ).
                      end.
                      else do:
                          if v_tp_forn = 1 then
                             assign v_dsl_segto = v_dsl_segto + string(pessoa_fisic.nom_pessoa,"x(30)" /*l_x(30)*/ ).
                          else
                             assign v_dsl_segto = v_dsl_segto + string(pessoa_jurid.nom_pessoa,"x(30)" /*l_x(30)*/ ).    
                      end.       

                      find first tt_param_program_formul where
                           tt_param_program_formul.tta_cdn_segment_edi = 289 and
                           tt_param_program_formul.tta_cdn_element_edi = 3928
                           no-lock no-error.

                      assign v_dsl_segto = v_dsl_segto + string(tt_param_program_formul.ttv_des_contdo,"x(20)" /*l_x20*/ ) +  /* Seu Nœmero */
                                           string(' ',"x(15)" /*l_x(15)*/ ) + /* Nosso Nœmero */
                                           string(' ',"x(10)" /*l_x(10)*/ ). /* Ocorr¼ncias */
                    end.
                 end case.
                 
                 /* J-52 */
                 assign v_dsl_segto = v_dsl_segto + chr(10). /* Gera chr(10) no final do registro para nÆo gerar exceto de colunas ( + 240) no registro tipo A */
                 /* Fim-J-52 */
                 
END PROCEDURE. /* pi_segto_tipo_N */
/*****************************************************************************
** Procedure Interna.....: pi_segto_tipo_O
** Descricao.............: pi_segto_tipo_O
** Criado por............: tech14020
** Criado em.............: 08/09/2006 10:23:26
** Alterado por..........: tech14020
** Alterado em...........: 08/09/2006 13:44:42
*****************************************************************************/
PROCEDURE pi_segto_tipo_O:

            assign v_dsl_segto = ''.

            find tt_param_program_formul
                where tt_param_program_formul.tta_cdn_segment_edi = 289
                and   tt_param_program_formul.tta_cdn_element_edi = 2807 no-error.

            assign v_dsl_segto = string(tt_param_program_formul.ttv_des_contdo,"x(48)" /*l_x(48)*/ ) /* posicao 018 a 065 (Codigo de barras) */.

            find first tt_param_program_formul where
                 tt_param_program_formul.tta_cdn_segment_edi = 289 and
                 tt_param_program_formul.tta_cdn_element_edi = 3734
                 no-lock no-error.

            assign v_dsl_segto = v_dsl_segto + string(tt_param_program_formul.ttv_des_contdo,"x(30)" /*l_x(30)*/ ). /* posicao 066 a 095 (Nome Concession ria) */

            find first tt_param_program_formul where
                 tt_param_program_formul.tta_cdn_segment_edi = 289 and
                 tt_param_program_formul.tta_cdn_element_edi = 3606
                 no-lock no-error.

            assign v_dsl_segto = v_dsl_segto + string(tt_param_program_formul.ttv_des_contdo,"x(08)" /*l_x(08)*/ ) + /* posicao 096 a 103 (Data Vencimento) */
                                 "REA" /*l_REA*/  + /* posicao 104 a 106 (Moeda) */
                                 '000000000000000'. /* posicao 107 a 121 (Quantidade Moeda) */

            find first tt_param_program_formul where
                 tt_param_program_formul.tta_cdn_segment_edi = 289 and
                 tt_param_program_formul.tta_cdn_element_edi = 4421
                 no-lock no-error.

            assign v_dec_aux = dec(tt_param_program_formul.ttv_des_contdo).

            assign v_dsl_segto = v_dsl_segto + string(v_dec_aux,'999999999999999'). /* posicao 122 a 136 (Valor Pagamento) */

            find first tt_param_program_formul where
                 tt_param_program_formul.tta_cdn_segment_edi = 289 and
                 tt_param_program_formul.tta_cdn_element_edi = 3709
                 no-lock no-error.

            assign v_dsl_segto = v_dsl_segto + string(tt_param_program_formul.ttv_des_contdo,"x(08)" /*l_x(08)*/ ) + /* posicao 137 a 144 (Data Pagamento) */
                                 '000000000000000' + /* posicao 145 a 159 (Valor Pago) */  
                                 fill(' ',15). /* posicao 160 a 174 (Brancos) */  

            find first tt_param_program_formul where
                 tt_param_program_formul.tta_cdn_segment_edi = 289 and
                 tt_param_program_formul.tta_cdn_element_edi = 3928
                 no-lock no-error.

            assign v_dsl_segto = v_dsl_segto + string(tt_param_program_formul.ttv_des_contdo,"x(20)" /*l_x20*/ ) + /* posicao 175 a 194 (Seu Nœmero) */
                                 fill(' ',21) + /* posicao 195 a 215 (Brancos) */  
                                 fill(' ',15) + /* posicao 216 a 230 (Nosso Nœmero) */  
                                 fill(' ',10). /* posicao 231 a 240 (Ocorrencias) */  
                                 
            /* J-52 */
            assign v_dsl_segto = v_dsl_segto + chr(10). /* Gera chr(10) no final do registro para nÆo gerar exceto de colunas ( + 240) no registro tipo A */
            /* Fim-J-52 */
                     
END PROCEDURE. /* pi_segto_tipo_O */


/************************** Internal Procedure End **************************/

/************************* External Procedure Begin *************************/



/************************** External Procedure End **************************/

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
        message getStrTrans("Mensagem nr. ", "EDF") i_msg "!!!":U skip
                getStrTrans("Programa Mensagem", "EDF") c_prg_msg getStrTrans("nÆo encontrado.", "EDF")
                view-as alert-box error.
        return error.
    end.

    run value(c_prg_msg + ".p":U) (input c_action, input c_param).
    return return-value.
END PROCEDURE.  /* pi_messages */
/*************************  End of fnc_prg_formul_39 ************************/
