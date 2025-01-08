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
** Versao................:  1.00.00.006
** Procedimento..........: utl_programs_formulas_edi
** Nome Externo..........: prgint/edf/edf701zi.py
** Data Geracao..........: 12/05/2009 - 09:00:22
** Criado por............: tech14032
** Criado em.............: 19/01/2005 11:31:05
** Alterado por..........: corp1153
** Alterado em...........: 23/03/2009 13:46:27
** Gerado por............: corp1153
*****************************************************************************/

def var c-versao-prg as char initial " 1.00.00.006":U no-undo.

{include/i_dbinst.i}
{include/i_dbtype.i}
{include/i_fcldef.i}
{include/itbuni.i}


/******************************* Private-Data *******************************/
assign this-procedure:private-data = "HLP=0":U.
/*************************************  *************************************/

/********************* Temporary Table Definition Begin *********************/

def temp-table tt_param_program_formul no-undo
    field tta_cdn_segment_edi              as Integer format ">>>>>9" initial 0 label "Segmento" column-label "Segmento"
    field tta_cdn_element_edi              as Integer format ">>>>>9" initial 0 label "Elemento" column-label "Elemento"
    field tta_des_label_utiliz_formul_edi  as character format "x(10)" label "Label Utiliz Formula" column-label "Label Utiliz Formula"
    field ttv_des_contdo                   as character format "x(100)" label "Conteudo" column-label "Conteudo"
    index tt_param_program_formul_id       is primary
          tta_cdn_segment_edi              ascending
          tta_cdn_element_edi              ascending    .

def shared temp-table tt_segment_tot no-undo
    field tta_cdn_segment_edi              as Integer format ">>>>>9" initial 0 label "Segmento" column-label "Segmento"
    field ttv_qtd_proces_edi               as decimal format "->>>>,>>9.9999" decimals 4
    field ttv_qtd_bloco_docto              as decimal format "99999"
    field ttv_log_trailler_edi             as logical format "Sim/N’o" initial no label "Trailler" column-label "Trailler"
    field ttv_log_header_edi               as logical format "Sim/N’o" initial no label "Header" column-label "Header".

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
    list-items ""
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
def var v_cdn_contador
    as integer
    format ">>>,>>9":U
    no-undo.
def var v_cod_tit_ap_bco
    as character
    format "x(20)":U
    label "T¡tulo  Banco"
    column-label "T¡tulo Banco"
    no-undo.

/************************** Variable Definition End *************************/


/****************************** Main Code Begin *****************************/


/* Begin_Include: i_version_extract */


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
    run pi_version_extract ('fnc_prg_formul_39':U, 'prgint/edf/edf701zi.py':U, '1.00.00.006':U, 'pro':U).
end /* if */.



/* End_Include: i_version_extract */

if  search("prgtec/btb/btb906za.r") = ? and search("prgtec/btb/btb906za.py") = ? then do:
    if  v_cod_dwb_user begins 'es_' then
        return "Programa execut vel nÆo foi encontrado:" /*l_programa_nao_encontrado*/  + "prgtec/btb/btb906za.py".
    else do:
        message "Programa execut vel nÆo foi encontrado:" /*l_programa_nao_encontrado*/  "prgtec/btb/btb906za.py"
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
        message "Programa execut vel nÆo foi encontrado:" /*l_programa_nao_encontrado*/  "prgtec/men/men901za.py"
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
def var v_num_reg_bloco       as integer no-undo.
def var v_num_bloco           as integer no-undo.
def var tipo-documento        as integer no-undo.
def var v_cod_tit_ap          as char no-undo.


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
     
       
if p_cdn_segment_edi = 289 and
   p_cdn_element_edi = 3922 then do:

   run pi_retorna_tp_segto (output v_cod_segto).

   return trim(v_cod_segto).
end.


        
        
/* Detalhe Variÿvel - Registro Detalhe */
if p_cdn_segment_edi = 000371 and
   p_cdn_element_edi = 04 then do:

   run pi_retorna_tp_segto (output v_cod_segto).

   case v_cod_segto:
     when "A" /*l_A*/  then do: /* Pagamento com Cheque, OP, DOC, TED e Cr?dito em Conta Corrente */

         run pi_segto_tipo_A.
         run pi_segto_tipo_b.
         
     end.
     when "J" /*l_J*/  then do:  /* Liquida?’o de T­tulos (bloquetos) em cobran?a no Itaœ e em outros Bancos */
        

         run pi_segto_tipo_J.

     end.
     when "N" /*l_n*/  then  /* Pagamento Tributos (GPS / DARF / DARF SIMPLES) */

         run pi_segto_tipo_N.

     when "O" /*l_o*/  then  /* Pagamento Contas Concessionÿrias */

         run pi_segto_tipo_O.

   end case.
   
   return v_dsl_segto. /* Vai retornar registro com dados de detalhe variÿvel */
end.

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
         assign v_dsl_segto = string(de-aux3,'99999999999999') + /* Somat½rio valor pagamentos */  /*9999 foi retirado para iniciar na posicao correta */
                              fill('0',18) + /* Zeros */
                              fill(' ',20). /* brancos */
      end.
   end case.

   return v_dsl_segto.
end.



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
            find emsfnd.tab_dic_dtsul 
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

           if p_cdn_segment_edi = 311 and
              p_cdn_element_edi = 5133 then do:
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
** Alterado por..........: Andr‚ Ara£jo - DRG-SP
** Alterado em...........: 23/03/2010 15:15:11
*****************************************************************************/
PROCEDURE pi_segto_tipo_A:

        assign v_dsl_segto = 'A0'. /* posicao 014 a 014 (A) */
        
        
        /*Codigo Instrucao para o Movimento  3933 */
        find tt_param_program_formul
             where tt_param_program_formul.tta_cdn_segment_edi = 289
             and   tt_param_program_formul.tta_cdn_element_edi = 3933 no-error.

        assign v_dsl_segto = v_dsl_segto + string(int(tt_param_program_formul.ttv_des_contdo),'99') .

        /*Codigo Camara Compensa‡Æo  0 */
        
        find tt_param_program_formul
             where tt_param_program_formul.tta_cdn_segment_edi = 0
             and   tt_param_program_formul.tta_cdn_element_edi = 0 no-error.
             
             
        if avail tt_param_program_formul then do:
            if tt_param_program_formul.ttv_des_contdo = "TED CIP" THEN
                assign v_dsl_segto = v_dsl_segto + "018".
        
            if tt_param_program_formul.ttv_des_contdo = "TED STR" THEN
                assign v_dsl_segto = v_dsl_segto + "810".
                
            if tt_param_program_formul.ttv_des_contdo = "DOC" THEN
                assign v_dsl_segto = v_dsl_segto + "700".
                

                
            if tt_param_program_formul.ttv_des_contdo = "Cr‚dito C/C" THEN
                assign v_dsl_segto = v_dsl_segto + "000".
                
         end.

        /*Codigo Banco Favorecidoo 3737 */
    
        find tt_param_program_formul
             where tt_param_program_formul.tta_cdn_segment_edi = 289
             and   tt_param_program_formul.tta_cdn_element_edi = 3737 no-error.
        
           if string(tt_param_program_formul.ttv_des_contdo,'999') = '33' then
              assign v_dsl_segto = v_dsl_segto + '0' + string(tt_param_program_formul.ttv_des_contdo,'99') .
           else
              assign v_dsl_segto = v_dsl_segto + string(tt_param_program_formul.ttv_des_contdo,'999') .

                
                                
        /*Agencia do favorecido 3922 */
        find tt_param_program_formul
             where tt_param_program_formul.tta_cdn_segment_edi = 289
             and   tt_param_program_formul.tta_cdn_element_edi = 3922 no-error.

/*          assign v_dsl_segto = v_dsl_segto + "AAAAA".*/


            if substring(tt_param_program_formul.ttv_des_contdo,5,1) = " " then 
                assign v_dsl_segto = v_dsl_segto + "0" + string(tt_param_program_formul.ttv_des_contdo).
            else 
                //assign v_dsl_segto = v_dsl_segto + string(tt_param_program_formul.ttv_des_contdo,'99999') .
                assign v_dsl_segto = v_dsl_segto + string(int(trim(tt_param_program_formul.ttv_des_contdo)),'99999').
            
            
          
            
        /*Digito Verificador da Agencia do favorecido 5143 */
        find tt_param_program_formul
             where tt_param_program_formul.tta_cdn_segment_edi = 289
             and   tt_param_program_formul.tta_cdn_element_edi = 5143 no-error.

            assign v_dsl_segto = v_dsl_segto + string(tt_param_program_formul.ttv_des_contdo,'x(01)') .
            

        /*Conta Corrente do favorecido 3796 */
        find tt_param_program_formul
             where tt_param_program_formul.tta_cdn_segment_edi = 289
             and   tt_param_program_formul.tta_cdn_element_edi = 3796 no-error.

            // ALTERADO IAB - 16/02/21 - CONTA COM DIGITOS EM BRANCO
            assign v_dsl_segto = v_dsl_segto + TRIM(FILL('0', 12 - LENGTH(replace(tt_param_program_formul.ttv_des_contdo,' ',''))) + string(tt_param_program_formul.ttv_des_contdo)) .


        /*Digito Verificador da Conta Corrente do favorecido 3927 */
        find tt_param_program_formul
             where tt_param_program_formul.tta_cdn_segment_edi = 289
             and   tt_param_program_formul.tta_cdn_element_edi = 3927 no-error.

            assign v_dsl_segto = v_dsl_segto + string(tt_param_program_formul.ttv_des_contdo,'x(01)') .
            
        /*Digito Verificador da Agencia / Conta Corrente do favorecido */            

            assign v_dsl_segto = v_dsl_segto + string("",'x(01)') .
            
        /*Nome do favorecido 3734 */                   
        find tt_param_program_formul
             where tt_param_program_formul.tta_cdn_segment_edi = 289
             and   tt_param_program_formul.tta_cdn_element_edi = 3734 no-error.

            assign v_dsl_segto = v_dsl_segto + string(tt_param_program_formul.ttv_des_contdo,'x(30)') .
            
               /* --- Nœmero do T­tulo ---*/
            find tt_param_program_formul
                where tt_param_program_formul.tta_cdn_segment_edi = 289
                and   tt_param_program_formul.tta_cdn_element_edi = 3743 no-error.
            assign v_cod_tit_ap_bco = substring(tt_param_program_formul.ttv_des_contdo,1,20).


            
        /*Codigo do titulo do favorecido 3734 */                   
        find tt_param_program_formul
             where tt_param_program_formul.tta_cdn_segment_edi = 289
             and   tt_param_program_formul.tta_cdn_element_edi = 3928 no-error.

           /* Inclusao de nova variavel v_cdn_contador */
            assign v_cdn_contador = 20 - length(substring(tt_param_program_formul.ttv_des_contdo,1,20)).
            assign v_cod_tit_ap = substring(tt_param_program_formul.ttv_des_contdo,1,20) + fill(' ',v_cdn_contador).
            
            /*assign v_dsl_segto = v_dsl_segto + string(v_cod_tit_ap,'x(20)') .*/
            // Retirar caracteres especiais - IAB - 11/02/2021
            assign v_dsl_segto = v_dsl_segto + replace(string(v_cod_tit_ap,'x(20)'),";"," ").


        /*Data do Pagamento 3709 */                   
        find first tt_param_program_formul where
             tt_param_program_formul.tta_cdn_segment_edi = 289 and
             tt_param_program_formul.tta_cdn_element_edi = 3709
             no-lock no-error.
        assign v_dsl_segto = v_dsl_segto + string(tt_param_program_formul.ttv_des_contdo,"x(08)" /*l_x(08)*/ ) + /* posicao 094 a 101 (Data Pagamento) */
                             "BRL" /*l_REA*/   + /* posicao 102 a 104 (Tipo Moeda) */
                             '000000000000000'. /* posicao 105 a 119 (Zeros) */


        /* Valor do Pagamento 4421 */
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

        /*Nosso Numero , Data pagto , val pagto e outras informa‡äes */
        find first tt_param_program_formul where
             tt_param_program_formul.tta_cdn_segment_edi = 289 and
             tt_param_program_formul.tta_cdn_element_edi = 3743
             no-lock no-error.
             
        assign v_dsl_segto = v_dsl_segto + fill(' ',15) + /* posicao 135 a 149 (Nosso Numero) */
                             fill(' ',5) + /* posicao 150 a 154 (Brancos) */
                             '00000000000000000000000' + /* posicao 155 a 177 (Zeros) */
                             fill(' ',40)  /* posicao 178 a 217 (Brancos) */.
                             
                             
        /*Finalidade*/                             
/*        Andre*/
        find tt_param_program_formul
             where tt_param_program_formul.tta_cdn_segment_edi = 0
             and   tt_param_program_formul.tta_cdn_element_edi = 0 no-error.
            
                CASE tt_param_program_formul.ttv_des_contdo:
                WHEN "DOC" THEN 
                    assign v_dsl_segto = v_dsl_segto + string('07') . /* Andr‚ Ara£jo Totvs - DRG-SP */
                WHEN "TED CIP" THEN 
                    assign v_dsl_segto = v_dsl_segto + string('11') .
                WHEN "Boleto" THEN 
                    assign v_dsl_segto = v_dsl_segto + string('03') .
                WHEN "Cr‚dito C/C" THEN 
                    assign v_dsl_segto = v_dsl_segto + string('01') .
                WHEN "Cheque Administrativo" THEN 
                    assign v_dsl_segto = v_dsl_segto + string('99') .
                WHEN "Ordem de Pagamento" THEN 
                    assign v_dsl_segto = v_dsl_segto + string('99') .
                WHEN "TED STR" THEN 
                    assign v_dsl_segto = v_dsl_segto + string('11') .
                    
            END CASE.                    
            

        /*Filler*/                     
        
        assign v_dsl_segto = v_dsl_segto + fill(' ',10).
        
        
        /*EmissÆo e Aviso do Favorecido */

        assign v_dsl_segto = v_dsl_segto + '0'.        
        
        /*Ocorrˆncias para Retorno */

        assign v_dsl_segto = v_dsl_segto + fill(' ',10).
        
        assign v_dsl_segto = v_dsl_segto + chr(10).                     
END PROCEDURE. /* pi_segto_tipo_A */
/*****************************************************************************
** Procedure Interna.....: pi_segto_tipo_J
** Descricao.............: pi_segto_tipo_J
** Criado por............: tech14020
** Criado em.............: 08/09/2006 10:18:22
** Alterado por..........: Andr‚ Ara£jo - DRG-SP
** Alterado em...........: 24/03/2010 11:22:11
*****************************************************************************/
PROCEDURE pi_segto_tipo_J:

                assign v_dsl_segto = 'J0'. /* posicao 014 a 014 (A) */
                
                /*Codigo Instrucao para o Movimento  3933 */
                find tt_param_program_formul
                     where tt_param_program_formul.tta_cdn_segment_edi = 289
                     and   tt_param_program_formul.tta_cdn_element_edi = 3933 no-error.
        
                  /*message tt_param_program_formul.ttv_des_contdo.*/
                    assign v_dsl_segto = v_dsl_segto + string(int(tt_param_program_formul.ttv_des_contdo),'99') .

                  

                /*Codigo DE BARRAS  3933 */
                    find tt_param_program_formul
                        where tt_param_program_formul.tta_cdn_segment_edi = 289
                        and   tt_param_program_formul.tta_cdn_element_edi = 2807 no-error.

                    &if defined(BF_FIN_ALTER_CODIGO_BARRA) &then
                        assign v_num_tam_format = 10.
                    &else
                        find first emscad.histor_exec_especial no-lock
                             where histor_exec_especial.cod_modul_dtsul = "UFN" /*l_ufn*/  
                             and   histor_exec_especial.cod_prog_dtsul  = "SPP_alter_codigo_barra" /*l_spp_alter_codigo_barra*/   no-error.
                        if   avail histor_exec_especial then
                             assign v_num_tam_format = 10.
                        else assign v_num_tam_format = 12.
                    &endif

                    if  avail tt_param_program_formul then do:
                        assign v_dec_aux    = dec(substring(tt_param_program_formul.ttv_des_contdo, 38, v_num_tam_format))
                               /* posicao 018 a 061 (C«d. de Barras) */
                               v_dsl_segto = v_dsl_segto + substring(tt_param_program_formul.ttv_des_contdo, 01, 03) +
                                              substring(tt_param_program_formul.ttv_des_contdo, 04, 01) +
                                              substring(tt_param_program_formul.ttv_des_contdo, 33, 01) +
                                              substring(tt_param_program_formul.ttv_des_contdo, 34, 04) + 
                                              string(v_dec_aux, '9999999999')                           +
                                              substring(tt_param_program_formul.ttv_des_contdo, 05, 05) +
                                              substring(tt_param_program_formul.ttv_des_contdo, 11, 10) +
                                              substring(tt_param_program_formul.ttv_des_contdo, 22, 10).
                    end.

                   /*Nome do cedente 3734*/

                 find first tt_param_program_formul where
                      tt_param_program_formul.tta_cdn_segment_edi = 289 and
                      tt_param_program_formul.tta_cdn_element_edi = 3734
                      no-lock no-error.

                 assign v_dsl_segto = v_dsl_segto + string(tt_param_program_formul.ttv_des_contdo,"x(30)" /*l_x(30)*/ ). /* posicao 062 a 091 (Nome Favorecido) */

                   /*Data de Vencimento 3734*/

                 find first tt_param_program_formul where
                      tt_param_program_formul.tta_cdn_segment_edi = 289 and
                      tt_param_program_formul.tta_cdn_element_edi = 3606
                      no-lock no-error.

                 assign v_dsl_segto = v_dsl_segto + string(tt_param_program_formul.ttv_des_contdo,"x(08)" /*l_x(08)*/ ). /* posicao 092 a 099 (Data Vencimento) */


                 /*Valor Nominal do Titulo 4421   */
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

                 /* * Corre¯?o Monet˜ria **/
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
/*message tt_param_program_formul.ttv_des_contdo.*/
                 assign v_dsl_segto = v_dsl_segto + string(tt_param_program_formul.ttv_des_contdo,"x(08)" /*l_x(08)*/ ). /* posicao 145 a 152 (Data Pagamento) */

                 find first tt_param_program_formul where
                      tt_param_program_formul.tta_cdn_segment_edi = 289 and
                      tt_param_program_formul.tta_cdn_element_edi = 4436
                      no-lock no-error.

                 assign v_dec_aux = dec(tt_param_program_formul.ttv_des_contdo).

                 assign v_dsl_segto = v_dsl_segto + string(v_dec_aux,'999999999999999') + /* posicao 153 a 167 (Valor Pagamento) */
                                      '000000000000000'. /* posicao 168 a 182 (Zeros) */

                         /* --- Nœmero do T­tulo ---*/
            find tt_param_program_formul
                where tt_param_program_formul.tta_cdn_segment_edi = 289
                and   tt_param_program_formul.tta_cdn_element_edi = 3743 no-error.
            assign v_cod_tit_ap_bco = substring(tt_param_program_formul.ttv_des_contdo,1,20).


            
        /*Codigo do titulo do favorecido 3734 */                   
        find tt_param_program_formul
             where tt_param_program_formul.tta_cdn_segment_edi = 289
             and   tt_param_program_formul.tta_cdn_element_edi = 3928 no-error.

           /* Inclusao de nova variavel v_cdn_contador */
            assign v_cdn_contador = 20 - length(substring(tt_param_program_formul.ttv_des_contdo,1,25)).
            assign v_cod_tit_ap = substring(tt_param_program_formul.ttv_des_contdo,1,25) + fill(' ',v_cdn_contador).
            
            assign v_cod_tit_ap = replace(v_cod_tit_ap,';','Y').   
            assign v_dsl_segto = v_dsl_segto + string(v_cod_tit_ap,'x(20)') +
                                 fill (' ',38).
                    
                
                 assign v_dsl_segto = v_dsl_segto + chr(10).
                 
                 /* Andre */
            
                                      
run pi_segto_tipo_j52.

END PROCEDURE. /* pi_segto_tipo_j */

/*****************************************************************************
** Procedure Interna.....: pi_segto_tipo_j52
** Descricao.............: pi_segto_tipo_j52
** Criado por............: tech14020
** Criado em.............: 08/09/2006 10:21:22
** Alterado por..........: Flavio Kussunoki - DRG-SP
** Alterado em...........: 24/07/2013 11:22:33
** OBS ..................: Foi alterado o nome de pi_segto_tipo_B para pi_segto_tipo_j52
*****************************************************************************/
PROCEDURE pi_segto_tipo_j52:
    /*Codigo do Banco  9(003)*/
    assign v_dsl_segto = v_dsl_segto + '033' .

/*****************************************************************************************************************************/    
    /* gera segunda parte - procura sequencia do registro */ 
    find first tt_segment_tot
         where tt_segment_tot.tta_cdn_segment_edi = 371 no-error.
        
    if avail tt_segment_tot
    then do:
        assign  tt_segment_tot.ttv_qtd_proces_edi  = tt_segment_tot.ttv_qtd_proces_edi  + 1
                tt_segment_tot.ttv_qtd_bloco_docto = tt_segment_tot.ttv_qtd_bloco_docto + 1
                v_num_reg_bloco                    = tt_segment_tot.ttv_qtd_bloco_docto.
    end.
    
    /* Atualiza somat¢rio dos blocos*/
    find first tt_segment_tot
         where tt_segment_tot.tta_cdn_segment_edi = 999999 no-error.
    if avail tt_segment_tot
    then do:
        assign  tt_segment_tot.ttv_qtd_proces_edi  = tt_segment_tot.ttv_qtd_proces_edi  + 1
                tt_segment_tot.ttv_qtd_bloco_docto = tt_segment_tot.ttv_qtd_bloco_docto + 1.
    end.
        
    /* localiza o bloco */
    find first tt_param_program_formul
         where tt_param_program_formul.tta_cdn_segment_edi = 0
           and tt_param_program_formul.tta_cdn_element_edi = 2
           and tt_param_program_formul.tta_des_label_utiliz_formul_edi = 'QTD BLOCOS' no-error.
    if avail tt_param_program_formul then
         assign v_num_bloco = int(tt_param_program_formul.ttv_des_contdo) + 1.


    /* codigo do lote */
    assign v_dsl_segto = v_dsl_segto + string(v_num_bloco,'9999'). /* somat¢rio blocos */

    /* tipo registro */
    assign v_dsl_segto = v_dsl_segto + "3". 

    /* numero registro */
    assign v_dsl_segto = v_dsl_segto + string(v_num_reg_bloco,'99999').  /* somat½rio de registros no bloco */
    
    
/*****************************************************************************************************************************/    
   
    assign v_dsl_segto = v_dsl_segto + 'J'. /* posicao 014 a 014 (A) */

    /*Filler Branco x(003) */

    assign v_dsl_segto = v_dsl_segto + fill(' ',01). /* posicao 015 a 015 */

    ASSIGN v_dsl_segto = v_dsl_segto + fill ('0',02). /* posicao 016 a 017 */
	
	assign v_dsl_segto = v_dsl_segto + '52'. /* posicao 018 a 019 */
	
	/* Sacado */
	/* Tipo de Inscrição*/
	
	find tt_param_program_formul
         where tt_param_program_formul.tta_cdn_segment_edi = 288
         and   tt_param_program_formul.tta_cdn_element_edi = 3710 no-error.
    
    if avail tt_param_program_formul then
        assign v_dsl_segto = v_dsl_segto + substring(tt_param_program_formul.ttv_des_contdo,2,1)
			tipo-documento = int(substring(tt_param_program_formul.ttv_des_contdo,2,1)).
		
	find tt_param_program_formul
         where tt_param_program_formul.tta_cdn_segment_edi = 288
         and   tt_param_program_formul.tta_cdn_element_edi = 4643 no-error.
        

    if avail tt_param_program_formul then
    do:
        if tipo-documento = 1 then 
                assign v_dsl_segto = v_dsl_segto + "000" + string((tt_param_program_formul.ttv_des_contdo),'99999999999') .
            else    
                assign v_dsl_segto = v_dsl_segto + fill('0' , 15 - length(tt_param_program_formul.ttv_des_contdo)) + string((tt_param_program_formul.ttv_des_contdo),'99999999999999') .
    end.

    find tt_param_program_formul
         where tt_param_program_formul.tta_cdn_segment_edi = 288
         and   tt_param_program_formul.tta_cdn_element_edi = 16 no-error.

    if avail tt_param_program_formul then
       assign v_dsl_segto = v_dsl_segto + string(tt_param_program_formul.ttv_des_contdo,'x(40)') + fill(' ' , 40 - length(string(tt_param_program_formul.ttv_des_contdo,'x(40)') )). 
    else	
    do:
       find tt_param_program_formul
            where tt_param_program_formul.tta_cdn_segment_edi = 288
              and tt_param_program_formul.tta_cdn_element_edi = 4643 no-error.

       if avail tt_param_program_formul then 
       do:
           find emitente where emitente.cgc = tt_param_program_formul.ttv_des_contdo no-lock no-error.

           if avail emitente then 
              assign v_dsl_segto = v_dsl_segto + string(emitente.nome-emit,'x(40)') + fill(' ' , 40 - length(string(emitente.nome-emit,'x(40)') )).  
           else
              assign v_dsl_segto = v_dsl_segto + fill(' ',40). 
       end.
       else
         assign v_dsl_segto = v_dsl_segto + fill(' ',40). 
    end.
               	
	
	/*Tipo de Incri‡Æo do Favorecido  9(001)*/
    find tt_param_program_formul
         where tt_param_program_formul.tta_cdn_segment_edi = 289
         and   tt_param_program_formul.tta_cdn_element_edi = 3915 no-error.

   if avail tt_param_program_formul then
        assign v_dsl_segto = v_dsl_segto + substring(tt_param_program_formul.ttv_des_contdo,2,1) 
               tipo-documento = int(substring(tt_param_program_formul.ttv_des_contdo,2,1)).
     
    /* cnpf ou cpf do favorecido */ 

        find tt_param_program_formul
             where tt_param_program_formul.tta_cdn_segment_edi = 289
             and   tt_param_program_formul.tta_cdn_element_edi = 3916 no-error.

        if avail tt_param_program_formul then
        do:
            if tipo-documento = 1 then 
                assign v_dsl_segto = v_dsl_segto + "000" + string((tt_param_program_formul.ttv_des_contdo),'99999999999') .
            else    
                assign v_dsl_segto = v_dsl_segto + fill('0' , 15 - length(tt_param_program_formul.ttv_des_contdo)) + string((tt_param_program_formul.ttv_des_contdo),'99999999999999') .
       end.

  find tt_param_program_formul
         where tt_param_program_formul.tta_cdn_segment_edi = 289
         and   tt_param_program_formul.tta_cdn_element_edi = 3734 no-error.

     if avail tt_param_program_formul then
        assign v_dsl_segto = v_dsl_segto + string(tt_param_program_formul.ttv_des_contdo,'x(40)') + fill(' ' , 40 - length(string(tt_param_program_formul.ttv_des_contdo,'x(40)') )). 
     else
        assign v_dsl_segto = v_dsl_segto + fill(' ',40). 
		
	/*Tipo de Incri‡Æo do Favorecido  9(001)*/
    find tt_param_program_formul
         where tt_param_program_formul.tta_cdn_segment_edi = 289
         and   tt_param_program_formul.tta_cdn_element_edi = 3915 no-error.

      if avail tt_param_program_formul then
        assign v_dsl_segto = v_dsl_segto + substring(tt_param_program_formul.ttv_des_contdo,2,1) 
               tipo-documento = int(substring(tt_param_program_formul.ttv_des_contdo,2,1)).
     
    /* cnpf ou cpf do favorecido */ 

        find tt_param_program_formul
             where tt_param_program_formul.tta_cdn_segment_edi = 289
             and   tt_param_program_formul.tta_cdn_element_edi = 3916 no-error.


        if avail tt_param_program_formul then
        do:
            if tipo-documento = 1 then 
                assign v_dsl_segto = v_dsl_segto + "000" + string((tt_param_program_formul.ttv_des_contdo),'99999999999') .
            else    
                assign v_dsl_segto = v_dsl_segto + fill('0' , 15 - length(tt_param_program_formul.ttv_des_contdo)) + string((tt_param_program_formul.ttv_des_contdo),'99999999999999') .
        end.

  find tt_param_program_formul
         where tt_param_program_formul.tta_cdn_segment_edi = 289
         and   tt_param_program_formul.tta_cdn_element_edi = 3734 no-error.

   if avail tt_param_program_formul then
      assign v_dsl_segto = v_dsl_segto + string(tt_param_program_formul.ttv_des_contdo,'x(40)') + fill(' ' , 40 - length(string(tt_param_program_formul.ttv_des_contdo,'x(40)') )). 
   else   
      assign v_dsl_segto = v_dsl_segto + fill(' ',40). 

   assign v_dsl_segto = v_dsl_segto + fill(' ',53) + chr(10).
  
END PROCEDURE. /* pi_segto_tipo_j52 */

/*****************************************************************************
** Procedure Interna.....: pi_segto_tipo_b
** Descricao.............: pi_segto_tipo_b
** Criado por............: tech14020
** Criado em.............: 08/09/2006 10:21:22
** Alterado por..........: Andr‚ Ara£jo - DRG-SP
** Alterado em...........: 24/03/2010 11:22:33
** OBS ..................: Foi alterado o nome de pi_segto_tipo_N para pi_segto_tipo_B
*****************************************************************************/
PROCEDURE pi_segto_tipo_B:
    /*Codigo do Banco  9(003)*/
    assign v_dsl_segto = v_dsl_segto + '033' .

/*****************************************************************************************************************************/    
    /* gera segunda parte - procura sequencia do registro */ 
    find first tt_segment_tot
         where tt_segment_tot.tta_cdn_segment_edi = 371 no-error.
        
    if avail tt_segment_tot
    then do:
        assign  tt_segment_tot.ttv_qtd_proces_edi  = tt_segment_tot.ttv_qtd_proces_edi  + 1
                tt_segment_tot.ttv_qtd_bloco_docto = tt_segment_tot.ttv_qtd_bloco_docto + 1
                v_num_reg_bloco                    = tt_segment_tot.ttv_qtd_bloco_docto.
    end.
    
    /* Atualiza somat¢rio dos blocos*/
    find first tt_segment_tot
         where tt_segment_tot.tta_cdn_segment_edi = 999999 no-error.
    if avail tt_segment_tot
    then do:
        assign  tt_segment_tot.ttv_qtd_proces_edi  = tt_segment_tot.ttv_qtd_proces_edi  + 1
                tt_segment_tot.ttv_qtd_bloco_docto = tt_segment_tot.ttv_qtd_bloco_docto + 1.
    end.
        
    /* localiza o bloco */
    find first tt_param_program_formul
         where tt_param_program_formul.tta_cdn_segment_edi = 0
           and tt_param_program_formul.tta_cdn_element_edi = 2
           and tt_param_program_formul.tta_des_label_utiliz_formul_edi = 'QTD BLOCOS' no-error.
    if avail tt_param_program_formul then
         assign v_num_bloco = int(tt_param_program_formul.ttv_des_contdo) + 1.


    /* codigo do lote */
    assign v_dsl_segto = v_dsl_segto + string(v_num_bloco,'9999'). /* somat¢rio blocos */

    /* tipo registro */
    assign v_dsl_segto = v_dsl_segto + "3". 

    /* numero registro */
    assign v_dsl_segto = v_dsl_segto + string(v_num_reg_bloco,'99999').  /* somat½rio de registros no bloco */
    
    
/*****************************************************************************************************************************/    
   
    assign v_dsl_segto = v_dsl_segto + 'B'. /* posicao 014 a 014 (A) */

    /*Filler Branco x(003) */

    assign v_dsl_segto = v_dsl_segto + fill(' ',03). /* posicao 015 a 017 */

    /*Tipo de Incri‡Æo do Favorecido  9(001)*/
    find tt_param_program_formul
         where tt_param_program_formul.tta_cdn_segment_edi = 289
         and   tt_param_program_formul.tta_cdn_element_edi = 3915 no-error.

        assign v_dsl_segto = v_dsl_segto + substring(tt_param_program_formul.ttv_des_contdo,2,1) 
               tipo-documento = int(substring(tt_param_program_formul.ttv_des_contdo,2,1)).
     
    /* cnpf ou cpf do favorecido */ 

        find tt_param_program_formul
             where tt_param_program_formul.tta_cdn_segment_edi = 289
             and   tt_param_program_formul.tta_cdn_element_edi = 3916 no-error.

            if tipo-documento = 1 then 
                assign v_dsl_segto = v_dsl_segto + "000" + string((tt_param_program_formul.ttv_des_contdo),'99999999999') .
            else    
                assign v_dsl_segto = v_dsl_segto + string((tt_param_program_formul.ttv_des_contdo),'99999999999999') .
 
     /*Andr‚ Ara£jo*/   
     /*
     Message "Documento:" string((tt_param_program_formul.ttv_des_contdo),'99999999999999') 
             view-as alert-box.
     */ 
    /* Logradouro  do favorecido */ 

        find tt_param_program_formul
             where tt_param_program_formul.tta_cdn_segment_edi = 289
             and   tt_param_program_formul.tta_cdn_element_edi = 3917 no-error.

            assign v_dsl_segto = v_dsl_segto + string(tt_param_program_formul.ttv_des_contdo,'x(30)') .
            assign v_dsl_segto = v_dsl_segto + '00000'. /*Numero do local do favorecido*/
            assign v_dsl_segto = v_dsl_segto + FILL(' ',15). /*Complemento do favorecido*/


    /* Bairro  do favorecido */ 

        find tt_param_program_formul
             where tt_param_program_formul.tta_cdn_segment_edi = 289
             and   tt_param_program_formul.tta_cdn_element_edi = 3621 no-error.

             assign v_dsl_segto = v_dsl_segto + string(tt_param_program_formul.ttv_des_contdo,'x(15)') . 
                 
    /*Cidade do Favorecido */
        find tt_param_program_formul
             where tt_param_program_formul.tta_cdn_segment_edi = 289
             and   tt_param_program_formul.tta_cdn_element_edi = 3918 no-error.

             assign v_dsl_segto = v_dsl_segto + string(tt_param_program_formul.ttv_des_contdo,'x(20)') . 

    /*Cep do Favorecido */

        find tt_param_program_formul
             where tt_param_program_formul.tta_cdn_segment_edi = 289
             and   tt_param_program_formul.tta_cdn_element_edi = 3920 no-error.

            assign v_dsl_segto = v_dsl_segto + string((tt_param_program_formul.ttv_des_contdo),'99999999') .


    /*Estado do Favorecido */

        find tt_param_program_formul
             where tt_param_program_formul.tta_cdn_segment_edi = 289
             and   tt_param_program_formul.tta_cdn_element_edi = 3919 no-error.

            assign v_dsl_segto = v_dsl_segto + string(tt_param_program_formul.ttv_des_contdo,'x(02)') .


       /*Data de Vencimento 3734*/

     find first tt_param_program_formul where
          tt_param_program_formul.tta_cdn_segment_edi = 289 and
          tt_param_program_formul.tta_cdn_element_edi = 3606
          no-lock no-error.

     assign v_dsl_segto = v_dsl_segto + string(tt_param_program_formul.ttv_des_contdo,"x(08)" /*l_x(08)*/ ). /* posicao 092 a 099 (Data Vencimento) */


     /*Valor Nominal do Titulo 4421   */
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


     if v_dec_aux <> 0 then 
          assign v_dsl_segto = v_dsl_segto + string(v_dec_aux,'999999999999999'). /* posicao 115 a 129 (Valor Descontos) */
     else
          assign v_dsl_segto = v_dsl_segto + fill('0',15).  /* posicao 115 a 129 (Valor Descontos) */

     /** Juros de Mora **/
     find first tt_param_program_formul
         where tt_param_program_formul.tta_cdn_segment_edi = 289
         and   tt_param_program_formul.tta_cdn_element_edi = 4422
         no-error.
     assign v_dec_aux = int(substring(tt_param_program_formul.ttv_des_contdo, 1,17)).
     
     if v_dec_aux <> 0 then 
        assign v_dsl_segto = v_dsl_segto + string(v_dec_aux,'999999999999999'). 
     else
        assign v_dsl_segto = v_dsl_segto + fill('0',15).  


     /* * Multa **/
     find first tt_param_program_formul
         where tt_param_program_formul.tta_cdn_segment_edi = 289
         and   tt_param_program_formul.tta_cdn_element_edi = 4426
         no-error.
     
     assign v_dec_aux2 = int(substring(tt_param_program_formul.ttv_des_contdo, 1,17)).
     
     if v_dec_aux2 <> 0 then 
         assign v_dsl_segto = v_dsl_segto + string(v_dec_aux2,'999999999999999').      
     else 
         assign v_dsl_segto = v_dsl_segto + fill('0',15).           
     
     
      assign v_dsl_segto = v_dsl_segto + fill('0',18)
             v_dsl_segto = v_dsl_segto + fill(' ',12)
             v_dsl_segto = v_dsl_segto + fill('0',5). /*codigo do historico do credito*/
      
      if tipo-documento = 1 then        
          assign v_dsl_segto = v_dsl_segto + fill(' ',10).             
      else
          assign v_dsl_segto = v_dsl_segto + fill(' ',10).
          
      assign v_dsl_segto = v_dsl_segto + chr(10).

/* andre 
Message "andre" skip  v_dsl_segto view-as alert-box.     
andre */

END PROCEDURE. /* pi_segto_tipo_B */
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
        message "Mensagem nr. " i_msg "!!!":U skip
                "Programa Mensagem" c_prg_msg "nÆo encontrado."
                view-as alert-box error.
        return error.
    end.

    run value(c_prg_msg + ".p":U) (input c_action, input c_param).
    return return-value.
END PROCEDURE.  /* pi_messages */
/*************************  End of fnc_prg_formul_39 ************************/




