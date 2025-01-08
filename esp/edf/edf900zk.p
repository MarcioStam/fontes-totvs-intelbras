/*****************************************************************************
** Copyright DATASUL S.A. (1994)
** Todos os Direitos Reservados.
** 
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so' podera ser feita mediante
** autorizacao expressa.
**
** Programa..............: fnc_detalhe_variavel
** Descricao.............: Detalhe Vari†vel Banco do Brasil
** Versao................:  1.00.00.009
** Procedimento..........: utl_formula_edi
** Nome Externo..........: prgint/edf/edf900zk.py
** Data Geracao..........: 04/08/2006 - 13:05:26
** Criado por............: Claudia
** Criado em.............: 29/09/1998 20:26:28
** Alterado por..........: bre16993
** Alterado em...........: 16/05/2002 11:40:16
** Gerado por............: tech14020
*****************************************************************************/

def var c-versao-prg as char initial " 1.00.00.009":U no-undo.

{include/i_dbinst.i}
{include/i_dbtype.i}
{include/i_fcldef.i}

DEF NEW GLOBAL SHARED VAR c-seg-usuario AS CHAR NO-UNDO. 


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
def var v_cod_det
    as character
    format "x(308)":U
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
def var v_cod_ocor_bcia
    as character
    format "x(30)":U
    label "Ocorrància Bcia"
    column-label "Ocorrància Bcia"
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

DEFINE VARIABLE c-aux   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-banco AS CHARACTER   NO-UNDO.

if  v_cod_arq <> '' and v_cod_arq <> ?
then do:
    run pi_version_extract ('fnc_detalhe_variavel':U, 'prgint/edf/edf900zk.py':U, '1.00.00.009':U, 'pro':U).
end /* if */.
/* End_Include: i_version_extract */





find tt_param_program_formul
    where tt_param_program_formul.tta_cdn_segment_edi = 374
    and   tt_param_program_formul.tta_cdn_element_edi = 5 no-error.    

/* Quando o registro for B, n∆o precisa ser importado, pois possui apenas informaá‰es complementares */
if tt_param_program_formul.ttv_des_contdo = 'B' then
    return "".

/* --- DOC / CRêDITO EM CONTA CORRENTE ---*/
if  tt_param_program_formul.ttv_des_contdo = 'A'
then do:
    find tt_param_program_formul
        where tt_param_program_formul.tta_cdn_segment_edi = 374 
        and   tt_param_program_formul.tta_cdn_element_edi = 8 no-error. 

   /* assign tt_param_program_formul.ttv_des_contdo = fill(" ",3) + tt_param_program_formul.ttv_des_contdo . */

    ASSIGN c-aux = SUBSTRING(tt_param_program_formul.ttv_des_contdo,4).

    ASSIGN c-aux = trim(substring(c-aux,54,20))
           c-aux = REPLACE(c-aux," ", ";")
           c-aux = c-aux + ";"
           c-aux = ENTRY(2,c-aux,';').


    

    ASSIGN c-banco = ''.
    FIND FIRST item_bord_ap NO-LOCK
                              WHERE item_bord_ap.num_id_item_bord_ap = INT(c-aux) NO-ERROR.
    IF AVAIL item_bord_ap THEN
        ASSIGN c-banco = item_bord_ap.cod_banco.

    IF c-banco = '' THEN DO:
        ASSIGN c-aux = trim(substring(tt_param_program_formul.ttv_des_contdo,57,20))  /*58*/
               c-aux = ENTRY(2,c-aux,';').

        FIND FIRST item_bord_ap NO-LOCK
                                  WHERE item_bord_ap.num_id_item_bord_ap = INT(c-aux) NO-ERROR.
        IF AVAIL item_bord_ap THEN
            ASSIGN c-banco = item_bord_ap.cod_banco.
    END.
    
    DO WHILE LENGTH(c-banco) < 3:
       ASSIGN c-banco = '0' + c-banco. 
    END.

    
   

    IF c-banco = '033' THEN DO:
        ASSIGN tt_param_program_formul.ttv_des_contdo = SUBSTRING(tt_param_program_formul.ttv_des_contdo,4).

        case p_cdn_element_edi:
             when 4678 then return substring(tt_param_program_formul.ttv_des_contdo,04,05). /* AGENCIA        */
             when 3941 then return substring(tt_param_program_formul.ttv_des_contdo,09,01). /* DIGITO AGENCIA */
             when 4679 then return substring(tt_param_program_formul.ttv_des_contdo,10,12). /* CONTA CORRENTE */
             when 3904 then return substring(tt_param_program_formul.ttv_des_contdo,22,01). /* DIGITO CONTA CORRENTE */
             when 3728 then return "0".
             when 3729 then return "0".
             when 3743 then return trim(substring(tt_param_program_formul.ttv_des_contdo,115,20)). /* NOSSO NUMERO */
             when 3928 THEN DO: /* Nro do Documento do Cliente */
                 ASSIGN c-aux = trim(substring(tt_param_program_formul.ttv_des_contdo,54,20))
                        c-aux = REPLACE(c-aux," ", ";")
                        c-aux = c-aux + ";".

                 return c-aux.
             END.
             when 3709 then return substring(tt_param_program_formul.ttv_des_contdo,74,08).  /* Dt Pagamento Titulo */
             when 4436 then return substring(tt_param_program_formul.ttv_des_contdo,100,13). /* Valor do pagamento */
             when 2705 then return substring(tt_param_program_formul.ttv_des_contdo,74,08).  /* Dt Efetivaá∆o Pagamento */
             when 4439 then return substring(tt_param_program_formul.ttv_des_contdo,100,13). /* Valor Efetivaá∆o */
             when 4425 then return "".
             when 4423 then return "".
             when 4426 then return "".
             when 4422 then return "".
             when 4437 then return "".
             when 3945 then return substring(tt_param_program_formul.ttv_des_contdo,211,02).
             when 3946 then return "".
             when 3947 then return "".
             when 3948 then return "".
             when 3949 then return "".
             when 2807 then return "".
             when 3808 then return "000".                    
        end. /* end case*/
    END.
    
    case p_cdn_element_edi:
         when 4678 then return substring(tt_param_program_formul.ttv_des_contdo,07,05).
         when 3941 then return substring(tt_param_program_formul.ttv_des_contdo,12,01).
         when 4679 then return substring(tt_param_program_formul.ttv_des_contdo,13,12).
         when 3904 then return substring(tt_param_program_formul.ttv_des_contdo,25,01).
         when 3728 then return "0".
         when 3729 then return "0".
         when 3743 then return trim(substring(tt_param_program_formul.ttv_des_contdo,118,20)).
         when 3928 then return trim(substring(tt_param_program_formul.ttv_des_contdo,57,20)).
         when 3709 then return substring(tt_param_program_formul.ttv_des_contdo,138,08).
         when 4436 then return substring(tt_param_program_formul.ttv_des_contdo,146,13).                 
         when 2705 then return substring(tt_param_program_formul.ttv_des_contdo,138,08).
         when 4439 then return substring(tt_param_program_formul.ttv_des_contdo,146,13).      
         when 4425 then return "".
         when 4423 then return "".
         when 4426 then return "".
         when 4422 then return "".
         when 4437 then return "".
         when 3945 then return substring(tt_param_program_formul.ttv_des_contdo,214,02).
         when 3946 then return "".
         when 3947 then return "".
         when 3948 then return "".
         when 3949 then return "".
         when 2807 then return "".
         when 3808 then return "000".                    
    end. /* end case*/
end /* if */. 
else do: /* --- BOLETO ---*/
    find tt_param_program_formul
        where tt_param_program_formul.tta_cdn_segment_edi = 374 
        and   tt_param_program_formul.tta_cdn_element_edi = 8 no-error. 


     

    case p_cdn_element_edi:   
         when 4678 then return "".
         when 3941 then return "".
         when 4679 then return "".
         when 3904 then return "".
         when 3728 then return "0".
         when 3729 then return "0".
         when 3743 then return trim(substring(tt_param_program_formul.ttv_des_contdo,186,20)).
         when 3928 then return replace(trim(substring(tt_param_program_formul.ttv_des_contdo,166,20)),"Y",";").
         when 3709 then return substring(tt_param_program_formul.ttv_des_contdo,128,08).
         when 4436 then return substring(tt_param_program_formul.ttv_des_contdo,136,13).
         when 2705 then return substring(tt_param_program_formul.ttv_des_contdo,128,08).
         when 4439 then return substring(tt_param_program_formul.ttv_des_contdo,136,13).
         when 4425 then return "".
         when 4423 then return "".
         when 4426 then return "".
         when 4422 then return "".
         when 4437 then return "".
         when 3945 then return substring(tt_param_program_formul.ttv_des_contdo,214,02).
         when 3946 then return "".
         when 3947 then return "".
         when 3948 then return "".
         when 3949 then return "".
         when 2807 then return trim(substring(tt_param_program_formul.ttv_des_contdo,18,44)).
         when 3808 then return "0".
    end. /* end case*/   
end /* if */.


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
            find emsfnd.prog_dtsul 
                where emsfnd.prog_dtsul.cod_prog_dtsul = p_cod_program 
                no-lock no-error.
            if  avail emsfnd.prog_dtsul
            then do:
                &if '{&emsbas_version}' > '5.00' &then
                    if  emsfnd.prog_dtsul.nom_prog_dpc <> '' then
                        put stream s-arq 'DPC : ' at 5 emsfnd.prog_dtsul.nom_prog_dpc  at 15 skip.
                &endif
                if  emsfnd.prog_dtsul.nom_prog_appc <> '' then
                    put stream s-arq 'APPC: ' at 5 emsfnd.prog_dtsul.nom_prog_appc at 15 skip.
                if  emsfnd.prog_dtsul.nom_prog_upc <> '' then
                    put stream s-arq 'UPC : ' at 5 emsfnd.prog_dtsul.nom_prog_upc  at 15 skip.
            end /* if */.
            &endif
        end.

        if  p_cod_program_type = 'dic' then do:
            &if '{&emsbas_version}' > '1.00' &then
            assign v_cod_event_dic = ENTRY(1,p_cod_program ,'/':U)
                   v_cod_tabela    = ENTRY(2,p_cod_program ,'/':U). /* FO 1100.980 */
            find emsfnd.tab_dic_dtsul 
                where emsfnd.tab_dic_dtsul.cod_tab_dic_dtsul = v_cod_tabela 
                no-lock no-error.
            if  avail emsfnd.tab_dic_dtsul
            then do:
                &if '{&emsbas_version}' > '5.00' &then
                    if  emsfnd.tab_dic_dtsul.nom_prog_dpc_gat_delete <> '' and v_cod_event_dic = 'Delete':U then
                        put stream s-arq 'DPC-DELETE : ' at 5 emsfnd.tab_dic_dtsul.nom_prog_dpc_gat_delete  at 25 skip.
                &endif
                if  emsfnd.tab_dic_dtsul.nom_prog_appc_gat_delete <> '' and v_cod_event_dic = 'Delete':U then
                    put stream s-arq 'APPC-DELETE: ' at 5 emsfnd.tab_dic_dtsul.nom_prog_appc_gat_delete at 25 skip.
                if  emsfnd.tab_dic_dtsul.nom_prog_upc_gat_delete <> '' and v_cod_event_dic = 'Delete':U then
                    put stream s-arq 'UPC-DELETE : ' at 5 emsfnd.tab_dic_dtsul.nom_prog_upc_gat_delete  at 25 skip.
                &if '{&emsbas_version}' > '5.00' &then
                    if  emsfnd.tab_dic_dtsul.nom_prog_dpc_gat_write <> '' and v_cod_event_dic = 'Write':U then
                        put stream s-arq 'DPC-WRITE : ' at 5 emsfnd.tab_dic_dtsul.nom_prog_dpc_gat_write  at 25 skip.
                &endif
                if  emsfnd.tab_dic_dtsul.nom_prog_appc_gat_write <> '' and v_cod_event_dic = 'Write':U then
                    put stream s-arq 'APPC-WRITE: ' at 5 emsfnd.tab_dic_dtsul.nom_prog_appc_gat_write at 25 skip.
                if  emsfnd.tab_dic_dtsul.nom_prog_upc_gat_write <> '' and v_cod_event_dic = 'Write':U  then
                    put stream s-arq 'UPC-WRITE : ' at 5 emsfnd.tab_dic_dtsul.nom_prog_upc_gat_write  at 25 skip.
            end /* if */.
            &endif
        end.

        output stream s-arq close.
    end /* if */.

END PROCEDURE. /* pi_version_extract */


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
                "Programa Mensagem" c_prg_msg "n∆o encontrado."
                view-as alert-box error.
        return error.
    end.

    run value(c_prg_msg + ".p":U) (input c_action, input c_param).
    return return-value.
END PROCEDURE.  /* pi_messages */
/***********************  End of fnc_detalhe_variavel ***********************/
