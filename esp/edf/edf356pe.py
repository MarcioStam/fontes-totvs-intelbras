/*****************************************************************************
** Copyright DATASUL S.A. (1994)
** Todos os Direitos Reservados.
** 
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so' podera ser feita mediante
** autorizacao expressa.
**
** Programa..............: fnc_Banco_Real_Intelbras
** Descricao.............: Funá‰es
** Versao................:  1.00.00.001
** Procedimento..........: utl_formula_edi_aux
** Nome Externo..........: esp/edf/edf356pe.py
** Data Geracao..........: 01/01/2005 - 11:34:53
** Criado por............: MARIO FRANCISCO FLEITH JR. / DATASUL GESTECH
** Criado em.............: 01/01/2005 16:36:55
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
    run pi_version_extract ('fnc_Banco_Real_Intelbras', 'esp/edf/edf356pe.py', '1.00.00.001', 'pro').
end /* if */.
/* End_Include: i_version_extract */

/* *******************************************************************************************************************************************
BEG Main Block
********************************************************************************************************************************************/

def new global shared var v_des_flag_public_geral
    as character
    format 'x(15)':U
    extent 10
    no-undo.
DEFINE VARIABLE c-agencia-matriz            AS CHARACTER.
DEFINE VARIABLE c-dig-agencia-matriz        AS CHARACTER.
DEFINE VARIABLE c-conta-matriz              AS CHARACTER.
DEFINE VARIABLE c-dig-conta-matriz          AS CHARACTER.
DEFINE VARIABLE c-espec-docto               AS CHARACTER.
DEFINE VARIABLE c-titulo-cliente            AS CHARACTER.
DEFINE VARIABLE c-dt-pagamento              AS CHARACTER.
DEFINE VARIABLE c-valor-pagamento           AS CHARACTER.
DEFINE VARIABLE c-forma-pagamento           AS CHARACTER.
DEFINE VARIABLE c-num-id-favorecido         AS CHARACTER.
DEFINE VARIABLE c-cod-id-favorecido         AS CHARACTER.
DEFINE VARIABLE c-cod-banco                 AS CHARACTER.
DEFINE VARIABLE c-agencia-favorecido        AS CHARACTER.
DEFINE VARIABLE c-dig-agencia-favorecido    AS CHARACTER.
DEFINE VARIABLE c-conta-favorecido          AS CHARACTER.
DEFINE VARIABLE c-dig-conta-favorecido      AS CHARACTER.
DEFINE VARIABLE c-dig2-conta-favorecido     AS CHARACTER.
DEFINE VARIABLE c-nome-agencia-favorecido   AS CHARACTER.
DEFINE VARIABLE c-nome-favorecido           AS CHARACTER.
DEFINE VARIABLE c-endereco-favorecido       AS CHARACTER.
DEFINE VARIABLE c-bairro-favorecido         AS CHARACTER.
DEFINE VARIABLE c-cep-favorecido            AS CHARACTER.
DEFINE VARIABLE c-cidade-favorecido         AS CHARACTER.
DEFINE VARIABLE c-uf-favorecido             AS CHARACTER.
DEFINE VARIABLE c-uso-empresa               AS CHARACTER.
DEFINE VARIABLE c-dt-movimento              AS CHARACTER.
DEFINE VARIABLE c-conteudo                  AS CHARACTER.
DEFINE VARIABLE c-cod-barras                AS CHARACTER.
DEFINE VARIABLE c-nosso-numero              AS CHARACTER.


IF  p_cdn_mapa_edi      = 200002 /* Banco Real */
AND p_cdn_segment_edi   = 299 /* Header */
THEN DO:
    ASSIGN v_des_flag_public_geral[6] = STRING((INT(v_des_flag_public_geral[6]) + 1),'999999').
    RETURN v_des_flag_public_geral[6].
END.
ELSE DO:
    IF  p_cdn_mapa_edi      = 200002 /* Banco Real */
    AND p_cdn_segment_edi   = 301 /* Trailler */
    THEN DO:
        ASSIGN v_des_flag_public_geral[6] = STRING((INT(v_des_flag_public_geral[6]) + 1),'999999').
        RETURN v_des_flag_public_geral[6].
    END.
    ELSE DO:
        /* Agencia*/
        find first tt_param_program_formul
            where tt_param_program_formul.tta_cdn_segment_edi = 288
            and   tt_param_program_formul.tta_cdn_element_edi = 3901
            no-error.
        ASSIGN c-agencia-matriz = substring(tt_param_program_formul.ttv_des_contdo,3,4).

        /* Digito Agencia*/
        find first tt_param_program_formul
            where tt_param_program_formul.tta_cdn_segment_edi = 288
            and   tt_param_program_formul.tta_cdn_element_edi = 3902
            no-error.
        ASSIGN c-dig-agencia-matriz = tt_param_program_formul.ttv_des_contdo.

        /* Conta Corrente*/
        find first tt_param_program_formul
            where tt_param_program_formul.tta_cdn_segment_edi = 288
            and   tt_param_program_formul.tta_cdn_element_edi = 3903
            no-error.
        ASSIGN c-conta-matriz = substring(tt_param_program_formul.ttv_des_contdo,3,7).

        /* Digito Conta Corrente*/
        find first tt_param_program_formul
            where tt_param_program_formul.tta_cdn_segment_edi = 288
            and   tt_param_program_formul.tta_cdn_element_edi = 3904
            no-error.
        ASSIGN c-dig-conta-matriz = tt_param_program_formul.ttv_des_contdo.

        /* Especie Documento*/
        find first tt_param_program_formul
            where tt_param_program_formul.tta_cdn_segment_edi = 289
            and   tt_param_program_formul.tta_cdn_element_edi = 3742
            no-error.
        ASSIGN c-espec-docto = tt_param_program_formul.ttv_des_contdo.

        /* Identificaªío Cliente */
        find first tt_param_program_formul
            where tt_param_program_formul.tta_cdn_segment_edi = 289
            and   tt_param_program_formul.tta_cdn_element_edi = 75
            no-error.
        ASSIGN c-titulo-cliente = tt_param_program_formul.ttv_des_contdo.

        /* Data Geraªío */
        find first tt_param_program_formul
            where tt_param_program_formul.tta_cdn_segment_edi = 289
            and   tt_param_program_formul.tta_cdn_element_edi = 3709
            no-error.
        ASSIGN c-dt-pagamento = tt_param_program_formul.ttv_des_contdo.

        /* Valor Titulo */
        find first tt_param_program_formul
            where tt_param_program_formul.tta_cdn_segment_edi = 289
            and   tt_param_program_formul.tta_cdn_element_edi = 4436
            no-error.
        ASSIGN c-valor-pagamento = tt_param_program_formul.ttv_des_contdo.

        /* Tipo Pagamento */
        find first tt_param_program_formul
            where tt_param_program_formul.tta_cdn_segment_edi = 289
            and   tt_param_program_formul.tta_cdn_element_edi = 3729
            no-error.
        ASSIGN c-forma-pagamento = tt_param_program_formul.ttv_des_contdo.

        /* Num Identificaªío Favorecido */
        find first tt_param_program_formul
            where tt_param_program_formul.tta_cdn_segment_edi = 289
            and   tt_param_program_formul.tta_cdn_element_edi = 3915
            no-error.
        ASSIGN c-num-id-favorecido = (IF  INT(tt_param_program_formul.ttv_des_contdo) = 1 THEN '2' ELSE '1').

        /* Cod Identificaªío Favorecido */
        find first tt_param_program_formul
            where tt_param_program_formul.tta_cdn_segment_edi = 289
            and   tt_param_program_formul.tta_cdn_element_edi = 3916
            no-error.
        ASSIGN c-cod-id-favorecido = tt_param_program_formul.ttv_des_contdo.

        /* Codigo Banco */
        find first tt_param_program_formul
            where tt_param_program_formul.tta_cdn_segment_edi = 289
            and   tt_param_program_formul.tta_cdn_element_edi = 3737
            no-error.
        ASSIGN c-cod-banco = tt_param_program_formul.ttv_des_contdo.

        /* Agencia Favorecido*/
        find first tt_param_program_formul
            where tt_param_program_formul.tta_cdn_segment_edi = 289
            and   tt_param_program_formul.tta_cdn_element_edi = 3922
            no-error.
        ASSIGN c-agencia-favorecido = tt_param_program_formul.ttv_des_contdo.

        /* Digito Agencia Favorecido*/
        find first tt_param_program_formul
            where tt_param_program_formul.tta_cdn_segment_edi = 289
            and   tt_param_program_formul.tta_cdn_element_edi = 5143
            no-error.
        ASSIGN  c-dig-agencia-favorecido  = tt_param_program_formul.ttv_des_contdo.

        /* Conta Favorecido*/
        find first tt_param_program_formul
            where tt_param_program_formul.tta_cdn_segment_edi = 289
            and   tt_param_program_formul.tta_cdn_element_edi = 3796
            no-error.
        ASSIGN c-conta-favorecido = tt_param_program_formul.ttv_des_contdo.

        /* Digito Conta Favorecido*/
        find first tt_param_program_formul
            where tt_param_program_formul.tta_cdn_segment_edi = 289
            and   tt_param_program_formul.tta_cdn_element_edi = 3927
            no-error.
        ASSIGN  c-dig-conta-favorecido =    (   if  length(tt_param_program_formul.ttv_des_contdo) = 1 
                                                then tt_param_program_formul.ttv_des_contdo
                                                else '')
                c-dig2-conta-favorecido =   (   if  length(tt_param_program_formul.ttv_des_contdo) = 2
                                                then tt_param_program_formul.ttv_des_contdo
                                                else '').

        /* Nome Agencia Favorecido*/
        find first tt_param_program_formul
            where tt_param_program_formul.tta_cdn_segment_edi = 289
            and   tt_param_program_formul.tta_cdn_element_edi = 3924
            no-error.
        ASSIGN c-nome-agencia-favorecido = tt_param_program_formul.ttv_des_contdo.

        /* Nome Favorecido*/
        find first tt_param_program_formul
            where tt_param_program_formul.tta_cdn_segment_edi = 289
            and   tt_param_program_formul.tta_cdn_element_edi = 3734
            no-error.
        ASSIGN c-nome-favorecido = tt_param_program_formul.ttv_des_contdo.

        /* Endereco Favorecido*/
        find first tt_param_program_formul
            where tt_param_program_formul.tta_cdn_segment_edi = 289
            and   tt_param_program_formul.tta_cdn_element_edi = 3917
            no-error.
        ASSIGN c-endereco-favorecido = tt_param_program_formul.ttv_des_contdo.

        /* Bairro Favorecido*/
        find first tt_param_program_formul
            where tt_param_program_formul.tta_cdn_segment_edi = 289
            and   tt_param_program_formul.tta_cdn_element_edi = 3621
            no-error.
        ASSIGN c-bairro-favorecido = tt_param_program_formul.ttv_des_contdo.

        /* Cep Favorecido*/
        find first tt_param_program_formul
            where tt_param_program_formul.tta_cdn_segment_edi = 289
            and   tt_param_program_formul.tta_cdn_element_edi = 3920
            no-error.
        ASSIGN c-cep-favorecido = tt_param_program_formul.ttv_des_contdo.

        /* Cidade Favorecido*/
        find first tt_param_program_formul
            where tt_param_program_formul.tta_cdn_segment_edi = 289
            and   tt_param_program_formul.tta_cdn_element_edi = 3918
            no-error.
        ASSIGN c-cidade-favorecido = tt_param_program_formul.ttv_des_contdo.

        /* UF Favorecido*/
        find first tt_param_program_formul
            where tt_param_program_formul.tta_cdn_segment_edi = 289
            and   tt_param_program_formul.tta_cdn_element_edi = 3919
            no-error.
        ASSIGN c-uf-favorecido = tt_param_program_formul.ttv_des_contdo.

        /* Uso da Empresa*/
        find first tt_param_program_formul
            where tt_param_program_formul.tta_cdn_segment_edi = 289
            and   tt_param_program_formul.tta_cdn_element_edi = 3928
            no-error.
        ASSIGN c-uso-empresa = tt_param_program_formul.ttv_des_contdo.

        /* Data Movimento*/
        find first tt_param_program_formul
            where tt_param_program_formul.tta_cdn_segment_edi = 289
            and   tt_param_program_formul.tta_cdn_element_edi = 3704
            no-error.
        ASSIGN c-dt-movimento = tt_param_program_formul.ttv_des_contdo.

        /* Codigo de Barras*/
        find first tt_param_program_formul
            where tt_param_program_formul.tta_cdn_segment_edi = 289
            and   tt_param_program_formul.tta_cdn_element_edi = 2807
            no-error.
        ASSIGN c-cod-barras = tt_param_program_formul.ttv_des_contdo.

        /* Codigo de Barras*/
        find first tt_param_program_formul
            where tt_param_program_formul.tta_cdn_segment_edi = 289
            and   tt_param_program_formul.tta_cdn_element_edi = 3743
            no-error.
        ASSIGN c-nosso-numero = tt_param_program_formul.ttv_des_contdo.


        /* Atualiza Sequencial*/
        ASSIGN v_des_flag_public_geral[6] = STRING((INT(v_des_flag_public_geral[6]) + 1),'999999').

        case int(c-forma-pagamento):
            when 1 or when 5 then
                 assign v_num_pago_bco = 6.
            when 2 or when 6 or when 7 or when 8 then
                 assign v_num_pago_bco = 4.
            when 3 then
                 assign v_num_pago_bco = 2.
            when 4 then 
                 assign v_num_pago_bco = 1.          
        end case.            

        ASSIGN c-conteudo = '1' +
                            'I' +
                            STRING('PG','X(04)') +
                            '2' +
                            STRING(c-agencia-matriz,'9999') +
                            STRING(INT(c-dig-agencia-matriz),'9') +
                            STRING(INT(c-conta-matriz),'9999999') +
                            STRING(INT(c-dig-conta-matriz),'9') +
                            STRING(c-espec-docto,'X(03)') +
                            STRING(c-titulo-cliente ,'X(15)') +
                            STRING(     SUBSTRING(c-dt-pagamento,1,2)
                                      + SUBSTRING(c-dt-pagamento,3,2)
                                      + SUBSTRING(c-dt-pagamento,7,2),'999999') +
                            '0' +
                            STRING((decimal(c-valor-pagamento)),'999999999999999') +
                            '398' +
                            STRING('PG.FORNECEDOR','X(30)') +
                            STRING(v_num_pago_bco,'9') +
                            '0' +
                            '000' +
                            '000000000000000' +
                            '000' +
                            '000' +
                            '0' +
                            '00000000000' +
                            '0000000' +
                            STRING(INT(c-num-id-favorecido),'99') +
                            STRING(c-cod-id-favorecido,'X(14)') +
                            STRING(INT(c-cod-banco),'999') +
                            STRING(INT(c-agencia-favorecido),'99999') +
                            STRING(c-dig-agencia-favorecido,'X') +
                            STRING(INT(c-conta-favorecido),'9999999999') +
                            STRING(c-dig-conta-favorecido,'X') +
                            STRING(c-nome-agencia-favorecido ,'X(30)') +
                            '00000000' +
                            '0'  +
                            STRING(c-nome-favorecido ,'X(40)') +
                            STRING(c-endereco-favorecido ,'X(30)') +
                            STRING('','X(05)') +
                            STRING('','X(10)') +
                            STRING(c-bairro-favorecido ,'X(15)') +
                            STRING(INT(c-cep-favorecido),'99999999') +
                            STRING(c-cidade-favorecido ,'X(20)') +
                            STRING(c-uf-favorecido ,'X(02)') +
                            STRING(c-uso-empresa ,'X(11)') +
                            STRING(     SUBSTRING(c-dt-movimento,1,2)
                                      + SUBSTRING(c-dt-movimento,3,2)
                                      + SUBSTRING(c-dt-movimento,7,2),'999999') +
                            STRING('','X') +
                            '00' +
                            '0' +
                            '000000' +
                            '000' +
                            STRING('','X') +
                            STRING(c-dig2-conta-favorecido,'XX') +
                            '000000' +
                            '4' +
                            '0' +
                            '00' +
                            STRING(INT(c-nosso-numero),'99999999') +
                            STRING(INT(v_des_flag_public_geral[6]),'999999') +
                            CHR(10).


        /* Verifica se a Forma de Pagamento ≤ Boleto e se for cria o registro 4 */
        IF  v_num_pago_bco = 6
        THEN DO:
            /* Atualiza Sequencial*/
            ASSIGN v_des_flag_public_geral[6] = STRING((INT(v_des_flag_public_geral[6]) + 1),'999999').

            ASSIGN c-conteudo = c-conteudo 
                                + '4'
                                + 'I'
                                + STRING('PG','X(04)')
                                + '0'
                                + STRING(c-agencia-matriz,'9999')
                                + STRING(INT(c-dig-agencia-matriz),'9')
                                + STRING(INT(c-conta-matriz),'9999999')
                                + STRING(INT(c-dig-conta-matriz),'9')
                                + STRING('','X(44)')
                                + STRING(c-cod-barras,'X(47)')
                                + STRING(c-titulo-cliente,'X(20)')
                                + '000'
                                + STRING('','X(20)')
                                + STRING('','X(20)')
                                + STRING('','X(30)')
                                + STRING('','X(30)')
                                + STRING('','X(152)')
                                + STRING(INT(c-nosso-numero),'99999999')
                                + STRING(INT(v_des_flag_public_geral[6]),'999999')
                                + CHR(10)  /* Quebra de Linha*/
                                .
        END.
        RETURN c-conteudo.
    END.
END.

/* *******************************************************************************************************************************************
END Main Block
********************************************************************************************************************************************/



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
/**************************  End of fnc_Banco_Real_Intelbras **************************/
