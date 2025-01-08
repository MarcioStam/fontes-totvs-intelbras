/*****************************************************************************
** Programa..............: fnc_Banco_Citi_Intelbras
** Versao................:  1.00.00.001
** Nome Externo..........: esp/edf/edf745pe.py
** Criado por............: Fabiano Zarpe Henke
** Criado em.............: 03/10/2012
*****************************************************************************/

def var c-versao-prg as char initial " 1.00.00.001":U no-undo.

{include/i_dbinst.i}
{include/i_dbtype.i}


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
          tta_cdn_element_edi              ascending.

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
def var v_nom_title_aux
    as character
    format "x(60)":U
    no-undo.
def var v_num_pago_bco
    as integer
    format ">>>>,>>9":U
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

if  v_cod_arq <> '' and v_cod_arq <> ?
then do:
    run pi_version_extract ('fnc_Banco_Citi_Intelbras', 'esp/edf/edf745pe.py', '1.00.00.001', 'pro').
end /* if */.
/* End_Include: i_version_extract */

/* ** Defini‡Æo de Vari veis Espec¡ficas ***/
def new global shared var v_des_flag_public_geral
    as character
    format 'x(15)':U
    extent 10
    no-undo.
DEFINE VARIABLE c-titulo-cliente            AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-dt-pagamento              AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-valor-pagamento           AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-cod-id-favorecido         AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-cod-banco                 AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-agencia-favorecido        AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-conta-favorecido          AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-dig-conta-favorecido      AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-nome-favorecido           AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-endereco-favorecido       AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-cep-favorecido            AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-cidade-favorecido         AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-uf-favorecido             AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-uso-empresa               AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-conteudo                  AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-cod-barras                AS CHARACTER NO-UNDO.
DEFINE VARIABLE cformapgto                  AS CHARACTER NO-UNDO.
DEFINE VARIABLE cbanco                      AS CHARACTER NO-UNDO.
DEFINE VARIABLE cagencia                    AS CHARACTER NO-UNDO.
DEFINE VARIABLE cconta                      AS CHARACTER NO-UNDO.
DEFINE VARIABLE ccontaciti                  AS CHARACTER NO-UNDO.
DEFINE VARIABLE ctipocta                    AS CHARACTER NO-UNDO.
DEFINE VARIABLE ctipobenef                  AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-cod-banco-favorecido      AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-cod-pagamento             AS CHARACTER NO-UNDO.
DEFINE VARIABLE v-ini                       AS INTEGER   NO-UNDO.


/* ** Exporta‡Æo no layout CITI 600/500 ***/

IF  p_cdn_mapa_edi    = 200008 /* Banco Citi */
AND p_cdn_segment_edi = 2      /* Trailler */
THEN DO:

    ASSIGN c-conteudo = "TRL"
                      + STRING(INT(v_des_flag_public_geral[6]),'999999999999999')
                      + STRING(INT(v_des_flag_public_geral[7]),'999999999999999')
                      + FILL("0", 15)
                      + STRING(INT(v_des_flag_public_geral[6]),'999999999999999')
                      + FILL(" ", 37)
                      + CHR(10).

    RETURN c-conteudo.

END.
ELSE DO:

    /* Atualiza Sequencial*/
    ASSIGN v_des_flag_public_geral[6] = STRING((INT(v_des_flag_public_geral[6]) + 1),'999999').

    /* ** Data Pagamento ***/
    find first tt_param_program_formul
         where tt_param_program_formul.tta_cdn_segment_edi = 289
           and tt_param_program_formul.tta_cdn_element_edi = 3709 no-error.
    ASSIGN c-dt-pagamento = tt_param_program_formul.ttv_des_contdo.

    /* Forma de Pagamento */
    find first tt_param_program_formul
         where tt_param_program_formul.tta_cdn_segment_edi = 289
           and tt_param_program_formul.tta_cdn_element_edi = 4838 no-error.
    ASSIGN cformapgto = tt_param_program_formul.ttv_des_contdo.   

    /* Banco Favorecido*/
    find first tt_param_program_formul
         where tt_param_program_formul.tta_cdn_segment_edi = 289
           and tt_param_program_formul.tta_cdn_element_edi = 3737 no-error.
    ASSIGN c-cod-banco-favorecido = tt_param_program_formul.ttv_des_contdo.

    /* Agencia Favorecido*/
    find first tt_param_program_formul
         where tt_param_program_formul.tta_cdn_segment_edi = 289
           and tt_param_program_formul.tta_cdn_element_edi = 3922 no-error.
    ASSIGN c-agencia-favorecido = tt_param_program_formul.ttv_des_contdo.

    /* Conta Favorecido*/
    find first tt_param_program_formul
         where tt_param_program_formul.tta_cdn_segment_edi = 289
           and tt_param_program_formul.tta_cdn_element_edi = 3796 no-error.
    ASSIGN c-conta-favorecido = tt_param_program_formul.ttv_des_contdo.

    /* Digito Conta Favorecido*/
    find first tt_param_program_formul
         where tt_param_program_formul.tta_cdn_segment_edi = 289
           and tt_param_program_formul.tta_cdn_element_edi = 3927 no-error.
    ASSIGN c-dig-conta-favorecido = tt_param_program_formul.ttv_des_contdo.

    /* Formas de pagamento CITI
    071 DOC
    072 Transf. Ctas Citi
    073 Cheque ADM
    081 Boleto
    083 TED */

    if cformapgto = "072"
       then assign cbanco     = "000"
                   cagencia   = "0000"
                   cconta     = "000000000000000"
                   ccontaciti = STRING(c-conta-favorecido, "9999999999")
                   ctipocta   = "00"
                   ctipobenef = "01".
    if cformapgto = "071" or cformapgto =  "083" then do:
       assign      cbanco     = STRING(c-cod-banco-favorecido, "999")
                   /*cagencia   = STRING(c-agencia-favorecido, "9999")*/
                   cconta     = STRING((c-conta-favorecido + c-dig-conta-favorecido), "999999999999999")
                   ccontaciti = "0000000000"
                   ctipocta   = "01"
                   ctipobenef = "00".

         if  length(c-agencia-favorecido) > 4 then 
             assign v-ini = (length(c-agencia-favorecido) - 3).
         else 
             assign v-ini = 1.
        
         assign cagencia = substring(c-agencia-favorecido,v-ini,4).
    end.
    if cformapgto = "081"
       then assign cbanco     = "000"
                   cagencia   = "0000"
                   cconta     = "000000000000000"
                   ccontaciti = "0000000000"
                   ctipocta   = "00"
                   ctipobenef = "00".

    /* ** C¢digo Pagamento - Identifica‡Æo Empresa ***/
    find first tt_param_program_formul
         where tt_param_program_formul.tta_cdn_segment_edi = 289
           and tt_param_program_formul.tta_cdn_element_edi = 4682 no-error.
    ASSIGN c-cod-pagamento = tt_param_program_formul.ttv_des_contdo.

    /* Uso da Empresa */
    find first tt_param_program_formul
        where tt_param_program_formul.tta_cdn_segment_edi = 289
        and   tt_param_program_formul.tta_cdn_element_edi = 3928
        no-error.
    ASSIGN c-uso-empresa = tt_param_program_formul.ttv_des_contdo.


    /* Cod Identifica‡Æo Favorecido */
    find first tt_param_program_formul
         where tt_param_program_formul.tta_cdn_segment_edi = 289
           and tt_param_program_formul.tta_cdn_element_edi = 3916 no-error.
    ASSIGN c-cod-id-favorecido = tt_param_program_formul.ttv_des_contdo.

    /* Valor Titulo */
    find first tt_param_program_formul
         where tt_param_program_formul.tta_cdn_segment_edi = 289
           and tt_param_program_formul.tta_cdn_element_edi = 4436 no-error.
    ASSIGN c-valor-pagamento = tt_param_program_formul.ttv_des_contdo.
    /* Atualiza Total Lote */
    ASSIGN v_des_flag_public_geral[7] = STRING((INT(v_des_flag_public_geral[7]) + int(c-valor-pagamento)),'999999999999999').

    /* T¡tulo Fornecedor */
    find first tt_param_program_formul
         where tt_param_program_formul.tta_cdn_segment_edi = 289
           and tt_param_program_formul.tta_cdn_element_edi = 75 no-error.
    ASSIGN c-titulo-cliente = tt_param_program_formul.ttv_des_contdo.

    /* Nome Favorecido*/
    find first tt_param_program_formul
         where tt_param_program_formul.tta_cdn_segment_edi = 289
           and tt_param_program_formul.tta_cdn_element_edi = 3734 no-error.
    ASSIGN c-nome-favorecido = tt_param_program_formul.ttv_des_contdo.

    /* Endereco Favorecido*/
    find first tt_param_program_formul
         where tt_param_program_formul.tta_cdn_segment_edi = 289
           and tt_param_program_formul.tta_cdn_element_edi = 3917 no-error.
    ASSIGN c-endereco-favorecido = tt_param_program_formul.ttv_des_contdo.

    /* Cidade Favorecido*/
    find first tt_param_program_formul
         where tt_param_program_formul.tta_cdn_segment_edi = 289
           and tt_param_program_formul.tta_cdn_element_edi = 3918 no-error.
    ASSIGN c-cidade-favorecido = tt_param_program_formul.ttv_des_contdo.

    /* UF Favorecido*/
    find first tt_param_program_formul
         where tt_param_program_formul.tta_cdn_segment_edi = 289
           and tt_param_program_formul.tta_cdn_element_edi = 3919 no-error.
    ASSIGN c-uf-favorecido = tt_param_program_formul.ttv_des_contdo.

    /* Cep Favorecido*/
    find first tt_param_program_formul
         where tt_param_program_formul.tta_cdn_segment_edi = 289
           and tt_param_program_formul.tta_cdn_element_edi = 3920 no-error.
    ASSIGN c-cep-favorecido = tt_param_program_formul.ttv_des_contdo.

    /* Codigo de Barras*/
    find first tt_param_program_formul
         where tt_param_program_formul.tta_cdn_segment_edi = 289
           and tt_param_program_formul.tta_cdn_element_edi = 2807 no-error.
    ASSIGN c-cod-barras = tt_param_program_formul.ttv_des_contdo.

    ASSIGN c-conteudo = "PAY0760067765028"
                      + STRING(SUBSTRING(STRING(c-dt-pagamento, "99/99/9999"), 9, 2), "99") + STRING(SUBSTRING(STRING(c-dt-pagamento, "99/99/9999"), 4, 2), "99") + STRING(SUBSTRING(STRING(c-dt-pagamento, "99/99/9999"), 1, 2), "99")
                      + STRING(cformapgto, "999")
                      + STRING(TRIM(c-cod-pagamento), "x(15)")
                      + STRING(INT(v_des_flag_public_geral[6]),'99999999')
                      + STRING(c-cod-id-favorecido, "99999999999999")
                      + "BRL"
                      + STRING(c-cod-id-favorecido, "9999999999")
                      + STRING(dec(c-valor-pagamento), "999999999999999")
                      + "000000"
                      + STRING(c-titulo-cliente, "x(30)")
                      + STRING("", "x(30)")
                      + STRING("0000000101")
                      + STRING(c-nome-favorecido, "x(80)")
                      + STRING(c-endereco-favorecido, "x(30)")
                      + STRING(c-cidade-favorecido, "x(15)")   
                      + STRING(c-uf-favorecido, "x(02)") 
                      + STRING(c-cep-favorecido, "99999999") 
                      + STRING("00000000000")
                      + STRING(DEC(cbanco), "999")
                      + STRING(DEC(cagencia), "9999")
                      + "    "
                      + STRING(DEC(cconta), "999999999999999")
                      + " "
                      + STRING(DEC(ctipocta), "99")
                      + FILL(" ", 47)
                      + FILL("0", 10)
                      + FILL(" ", 35)
                      + STRING(DEC(ccontaciti), "9999999999")
                      + STRING(DEC(ctipobenef), "99")
                      + "010"
                      + STRING(c-cod-barras, "x(50)")
                      + FILL(" ", 102)
                      + CHR(10).

    RETURN c-conteudo.

END.

/******************************* Main Code End ******************************/

/************************* Internal Procedure Begin *************************/

/*****************************************************************************
** Procedure Interna.....: pi_version_extract
** Descricao.............: pi_version_extract
** Criado por............: jaison
** Criado em.............: 31/07/1998 09:33:22
** Alterado por..........: bre19127
** Alterado em...........: 16/09/2002 08:55:44
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

    if  can-do(v_cod_tip_prog, p_cod_program_type)
    then do:
        if p_cod_program_type = 'dic' then 
           assign p_cod_program_ext = replace(p_cod_program_ext, 'database/', '').

        output stream s-arq to value(v_cod_arq) append.

        put stream s-arq unformatted
            p_cod_program            at 1 
            p_cod_program_ext        at 43 
            p_cod_version            at 69 
            today                    at 84 
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
            find tab_dic_dtsul 
                where tab_dic_dtsul.cod_tab_dic_dtsul = p_cod_program 
                no-lock no-error.
            if  avail tab_dic_dtsul
            then do:
                &if '{&emsbas_version}' > '5.00' &then
                    if  tab_dic_dtsul.nom_prog_dpc_gat_delete <> '' then
                        put stream s-arq 'DPC-DELETE : ' at 5 tab_dic_dtsul.nom_prog_dpc_gat_delete  at 25 skip.
                &endif
                if  tab_dic_dtsul.nom_prog_appc_gat_delete <> '' then
                    put stream s-arq 'APPC-DELETE: ' at 5 tab_dic_dtsul.nom_prog_appc_gat_delete at 25 skip.
                if  tab_dic_dtsul.nom_prog_upc_gat_delete <> '' then
                    put stream s-arq 'UPC-DELETE : ' at 5 tab_dic_dtsul.nom_prog_upc_gat_delete  at 25 skip.
                &if '{&emsbas_version}' > '5.00' &then
                    if  tab_dic_dtsul.nom_prog_dpc_gat_write <> '' then
                        put stream s-arq 'DPC-WRITE : ' at 5 tab_dic_dtsul.nom_prog_dpc_gat_write  at 25 skip.
                &endif
                if  tab_dic_dtsul.nom_prog_appc_gat_write <> '' then
                    put stream s-arq 'APPC-WRITE: ' at 5 tab_dic_dtsul.nom_prog_appc_gat_write at 25 skip.
                if  tab_dic_dtsul.nom_prog_upc_gat_write <> '' then
                    put stream s-arq 'UPC-WRITE : ' at 5 tab_dic_dtsul.nom_prog_upc_gat_write  at 25 skip.
            end /* if */.
            &endif
        end.

        output stream s-arq close.
    end /* if */.

END PROCEDURE. /* pi_version_extract */

/************************** Internal Procedure End **************************/

/**************************  End of fnc_Banco_Real_Intelbras **************************/
