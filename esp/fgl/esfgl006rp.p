{include/i-prgvrs.i esfgl006RP 2.00.00.000}  
    
DEF NEW SHARED STREAM s_1.

/*----------------------------------------------------------------*/
/*        DEFINIÄÂES ESPEC÷FICAS PARA INTEGRAÄ«O COM O APB        */
/*----------------------------------------------------------------*/
def new shared temp-table tt_integr_aprop_lancto_ctbl_1 no-undo
    field tta_cod_finalid_econ             as character format "x(10)" label "Finalidade" column-label "Finalidade"
    field tta_cod_unid_negoc               as character format "x(3)" label "Unid Neg¢cio" column-label "Un Neg"
    field tta_cod_plano_ccusto             as character format "x(8)" label "Plano Centros Custo" column-label "Plano Centros Custo"
    field tta_qtd_unid_lancto_ctbl         as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Quantidade" column-label "Quantidade"
    field tta_val_lancto_ctbl              as decimal format "->>>>>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Lanáamento" column-label "Valor Lanáamento"
    field tta_num_id_aprop_lancto_ctbl     as integer format "9999999999" initial 0 label "Apropriacao Lanáto" column-label "Apropriacao Lanáto"
    field ttv_rec_integr_item_lancto_ctbl  as recid format ">>>>>>9"
    field tta_dat_cotac_indic_econ         as date format "99/99/9999" initial ? label "Data Cotaá∆o" column-label "Data Cotaá∆o"
    field tta_val_cotac_indic_econ         as decimal format "->>>>>,>>9.9999999999" decimals 10 initial 0 label "Cotaá∆o" column-label "Cotaá∆o"
    field ttv_ind_erro_valid               as character format "X(08)" initial "N∆o"
    field tta_ind_orig_val_lancto_ctbl     as character format "X(10)" initial "Informado" label "Origem Valor" column-label "Origem Valor"
    field tta_cod_ccusto                   as Character format "x(11)" label "Centro Custo" column-label "Centro Custo"
    field ttv_rec_integr_aprop_lancto_ctbl as recid format ">>>>>>9"
    index tt_id                            is primary unique
          ttv_rec_integr_item_lancto_ctbl  ascending
          tta_cod_finalid_econ             ascending
          tta_cod_unid_negoc               ascending
          tta_cod_plano_ccusto             ascending
          tta_cod_ccusto                   ascending
    index tt_recid                        
          ttv_rec_integr_aprop_lancto_ctbl ascending.

def new shared temp-table tt_integr_ctbl_valid_1 no-undo
    field ttv_rec_integr_ctbl              as recid format ">>>>>>9"
    field ttv_num_mensagem                 as integer format ">>>>,>>9" label "N£mero" column-label "N£mero Mensagem"
    field ttv_ind_pos_erro                 as character format "X(08)" label "Posiá∆o"
    index tt_id                            is primary unique
          ttv_rec_integr_ctbl              ascending
          ttv_num_mensagem                 ascending.

def new shared temp-table tt_integr_ctbl_valid_parametros no-undo
    field ttv_rec_aux                      as recid format ">>>>>>9"
    field ttv_cod_parameters               as character format "x(256)"
    field ttv_cod_msg                      as character format "x(8)" label "Mensagem" column-label "Mensagem".

def new shared temp-table tt_integr_item_lancto_ctbl_1 no-undo
    field ttv_rec_integr_lancto_ctbl       as recid format ">>>>>>9"
    field tta_num_seq_lancto_ctbl          as integer format ">>>>9" initial 0 label "Sequància Lanáto" column-label "Sequància Lanáto"
    field tta_ind_natur_lancto_ctbl        as character format "X(02)" initial "DB" label "Natureza" column-label "Natureza"
    field tta_cod_plano_cta_ctbl           as character format "x(8)" label "Plano Contas" column-label "Plano Contas"
    field tta_cod_cta_ctbl                 as character format "x(20)" label "Conta Cont†bil" column-label "Conta Cont†bil"
    field tta_cod_plano_ccusto             as character format "x(8)" label "Plano Centros Custo" column-label "Plano Centros Custo"
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_unid_negoc               as character format "x(3)" label "Unid Neg¢cio" column-label "Un Neg"
    field tta_cod_histor_padr              as character format "x(8)" label "Hist¢rico Padr∆o" column-label "Hist¢rico Padr∆o"
    field tta_des_histor_lancto_ctbl       as character format "x(2000)" label "Hist¢rico Cont†bil" column-label "Hist¢rico Cont†bil"
    field tta_cod_espec_docto              as character format "x(3)" label "EspÇcie Documento" column-label "EspÇcie"
    field tta_dat_docto                    as date format "99/99/9999" initial ? label "Data Documento" column-label "Data Documento"
    field tta_des_docto                    as character format "x(25)" label "N£mero Documento" column-label "N£mero Documento"
    field tta_cod_imagem                   as character format "x(30)" label "Imagem" column-label "Imagem"
    field tta_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda"
    field tta_dat_lancto_ctbl              as date format "99/99/9999" initial ? label "Data Lanáamento" column-label "Data Lanáto"
    field tta_qtd_unid_lancto_ctbl         as decimal format "->>,>>>,>>9.99" decimals 2 initial 0 label "Quantidade" column-label "Quantidade"
    field tta_val_lancto_ctbl              as decimal format "->>>>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Lanáamento" column-label "Valor Lanáamento"
    field tta_num_seq_lancto_ctbl_cpart    as integer format ">>>9" initial 0 label "Sequància CPartida" column-label "Sequància CP"
    field ttv_ind_erro_valid               as character format "X(08)" initial "N∆o"
    field tta_cod_ccusto                   as Character format "x(11)" label "Centro Custo" column-label "Centro Custo"
    field tta_cod_proj_financ              as character format "x(20)" label "Projeto" column-label "Projeto"
    field ttv_rec_integr_item_lancto_ctbl  as recid format ">>>>>>9"
    index tt_id                            is primary unique
          ttv_rec_integr_lancto_ctbl       ascending
          tta_num_seq_lancto_ctbl          ascending
    index tt_recid                        
          ttv_rec_integr_item_lancto_ctbl  ascending.

def new shared temp-table tt_integr_lancto_ctbl_1 no-undo
    field tta_cod_cenar_ctbl               as character format "x(8)" label "Cen†rio Cont†bil" column-label "Cen†rio Cont†bil"
    field tta_log_lancto_conver            as logical format "Sim/N∆o" initial no label "Lanáamento Convers∆o" column-label "Lanáto Conv"
    field tta_log_lancto_apurac_restdo     as logical format "Sim/N∆o" initial no label "Lanáamento Apuraá∆o" column-label "Lancto Apuraá∆o"
    field tta_cod_rat_ctbl                 as character format "x(8)" label "Rateio Cont†bil" column-label "Rateio"
    field ttv_rec_integr_lote_ctbl         as recid format ">>>>>>9"
    field tta_num_lancto_ctbl              as integer format ">>,>>>,>>9" initial 10 label "Lanáamento Cont†bil" column-label "Lanáamento Cont†bil"
    field ttv_ind_erro_valid               as character format "X(08)" initial "N∆o"
    field tta_dat_lancto_ctbl              as date format "99/99/9999" initial ? label "Data Lanáamento" column-label "Data Lanáto"
    field ttv_rec_integr_lancto_ctbl       as recid format ">>>>>>9"
    index tt_id                            is primary unique
          ttv_rec_integr_lote_ctbl         ascending
          tta_num_lancto_ctbl              ascending
    index tt_recid                        
          ttv_rec_integr_lancto_ctbl       ascending.

def temp-table tt_integr_lancto_ctbl_aux no-undo
    field tta_cod_cenar_ctbl               as character format "x(8)" label "Cen†rio Cont†bil" column-label "Cen†rio Cont†bil"
    field tta_log_lancto_conver            as logical format "Sim/N∆o" initial no label "Lanáamento Convers∆o" column-label "Lanáto Conv"
    field tta_log_lancto_apurac_restdo     as logical format "Sim/N∆o" initial no label "Lanáamento Apuraá∆o" column-label "Lancto Apuraá∆o"
    field tta_cod_rat_ctbl                 as character format "x(8)" label "Rateio Cont†bil" column-label "Rateio"
    field ttv_rec_integr_lote_ctbl         as recid format ">>>>>>9"
    field tta_num_lancto_ctbl              as integer format ">>,>>>,>>9" initial 10 label "Lanáamento Cont†bil" column-label "Lanáamento Cont†bil"
    field ttv_ind_erro_valid               as character format "X(08)" initial "N∆o"
    field tta_dat_lancto_ctbl              as date format "99/99/9999" initial ? label "Data Lanáamento" column-label "Data Lanáto"
    field ttv_rec_integr_lancto_ctbl       as recid format ">>>>>>9"
    index tt_id                            is primary unique
          ttv_rec_integr_lote_ctbl         ascending
          tta_num_lancto_ctbl              ascending.

def new shared temp-table tt_integr_lote_ctbl_1 no-undo
    field tta_cod_modul_dtsul              as character format "x(3)" label "M¢dulo" column-label "M¢dulo"
    field tta_num_lote_ctbl                as integer format ">>>,>>>,>>9" initial 1 label "Lote Cont†bil" column-label "Lote Cont†bil"
    field tta_des_lote_ctbl                as character format "x(40)" label "Descriá∆o Lote" column-label "Descriá∆o Lote"
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_dat_lote_ctbl                as date format "99/99/9999" initial today label "Data Lote Cont†bil" column-label "Data Lote Cont†bil"
    field ttv_ind_erro_valid               as character format "X(08)" initial "N∆o"
    field tta_log_integr_ctbl_online       as logical format "Sim/N∆o" initial no label "Integraá∆o Online" column-label "Integr Online"
    field ttv_rec_integr_lote_ctbl         as recid format ">>>>>>9"
    index tt_recid                        
          ttv_rec_integr_lote_ctbl         ascending.

def temp-table tt_input_leitura_sdo no-undo
    field ttv_cod_label                    as character format "x(8)" label "Label" column-label "Label"
    field ttv_des_conteudo                 as character format "x(40)" label "Texto" column-label "Texto"
    field ttv_num_seq_1                    as integer format ">>>,>>9"
    field ttv_num_seq_2                    as integer format ">>>>,>>9"
    index tt_ID                            is primary
          ttv_num_seq_1                    ascending.

def temp-table tt_retorna_sdo_ctbl no-undo
    field tta_num_seq                      as integer format ">>>,>>9" initial 0 label "Sequància" column-label "NumSeq"
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cod_finalid_econ             as character format "x(10)" label "Finalidade" column-label "Finalidade"
    field tta_cod_plano_cta_ctbl           as character format "x(8)" label "Plano Contas" column-label "Plano Contas"
    field tta_cod_cta_ctbl                 as character format "x(20)" label "Conta Cont†bil" column-label "Conta Cont†bil"
    field tta_cod_plano_ccusto             as character format "x(8)" label "Plano Centros Custo" column-label "Plano Centros Custo"
    field tta_cod_ccusto                   as Character format "x(11)" label "Centro Custo" column-label "Centro Custo"
    field tta_cod_proj_financ              as character format "x(20)" label "Projeto" column-label "Projeto"
    field tta_cod_cenar_ctbl               as character format "x(8)" label "Cen†rio Cont†bil" column-label "Cen†rio Cont†bil"
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_unid_negoc               as character format "x(3)" label "Unid Neg¢cio" column-label "Un Neg"
    field tta_dat_sdo_ctbl                 as date format "99/99/9999" initial ? label "Data Saldo Cont†bil" column-label "Data Saldo Cont†bil"
    field tta_val_sdo_ctbl_db              as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Movto DÇbito" column-label "Movto DÇbito"
    field tta_val_sdo_ctbl_cr              as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Movto CrÇdito" column-label "Movto CrÇdito"
    field tta_val_sdo_ctbl_fim             as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Saldo Cont†bil Final" column-label "Saldo Cont†bil Final"
    field tta_val_apurac_restdo            as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Apuraá∆o Resultado" column-label "Apuraá∆o Resultado"
    field tta_val_apurac_restdo_db         as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Apuraá∆o Restdo DB" column-label "Apuraá∆o Restdo DB"
    field tta_val_apurac_restdo_cr         as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Apuraá∆o Restdo CR" column-label "Apuraá∆o Restdo CR"
    field tta_val_apurac_restdo_acum       as decimal format "->>>>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Apuracao Final" column-label "Apuracao Final"
    field tta_val_sdo_ctbl_db_sint         as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Movto DÇbito Sint" column-label "Movto DÇbito Sint"
    field tta_val_sdo_ctbl_cr_sint         as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Movto CrÇdito Sint" column-label "Movto CrÇdito Sint"
    field tta_val_sdo_ctbl_fim_sint        as decimal format "->>>>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Saldo SintÇtico" column-label "Saldo SintÇtico"
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
    field ttv_num_seq                      as integer format ">>>,>>9" label "SeqÅància" column-label "Seq"
    field ttv_num_cod_erro                 as integer format ">>>>,>>9" label "N£mero" column-label "N£mero"
    field ttv_des_erro                     as character format "x(50)" label "Inconsistància" column-label "Inconsistància"
    field ttv_des_ajuda                    as character format "x(50)" label "Ajuda" column-label "Ajuda".



DEFINE VARIABLE v_hdl_aux         AS HANDLE     NO-UNDO.
DEFINE VARIABLE v_dat_sdo_periodo AS DATE       NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE v_des_contdo_prog_valid_dtsul AS CHARACTER   NO-UNDO FORMAT "x(40)":U.

v_des_contdo_prog_valid_dtsul = "esfgl006rp".

/*Define variaveis*/
def var p_num_vers_integr_api as integer format ">>>>,>>9" no-undo. 
def var v_cod_matriz_trad_org_ext as character format "x(8)" no-undo. 
def var v_int as i no-undo.

DEFINE VARIABLE c-mensagem AS CHARACTER   NO-UNDO.

{esapi/esapi015tt.i}

{utp/utapi009.i}
{esp/es0018.i}

def new global shared var v_cod_usuar_corren
    as character
    format "x(12)"
    label "Usu†rio Corrente"
    column-label "Usu†rio Corrente"
    no-undo.

DEFINE VARIABLE c-referencia         AS CHAR FORMAT "X(20)"    NO-UNDO.
DEFINE VARIABLE c-cod-titulo         AS CHAR FORMAT "X(09)"    NO-UNDO.
DEFINE VARIABLE c-conta              AS CHAR FORMAT "X(20)"    NO-UNDO.
DEFINE VARIABLE c-centro-custo       AS CHAR FORMAT "X(20)"    NO-UNDO.
DEFINE VARIABLE c-cod-estab          AS CHAR FORMAT "X(05)"    NO-UNDO.
DEFINE VARIABLE c-especie            AS CHAR                   NO-UNDO.
DEFINE VARIABLE c-tipo-fluxo         AS CHAR                   NO-UNDO.
DEFINE VARIABLE da-data-fim       AS DATE NO-UNDO.
DEFINE VARIABLE i-seq                AS INTEGER     NO-UNDO.

DEF TEMP-TABLE tt-rateio
    FIELD tipo-rateio      AS INT
    FIELD competencia      AS CHAR
    FIELD cod-estabel      AS CHAR
    FIELD cod-estabel-rat  AS CHAR
    FIELD cod-centro-custo AS CHAR 
    FIELD cod-unid-neg     AS CHAR 
    FIELD vl-rateio        AS DEC
    FIELD vl-perc-rateio   AS DEC.


/*-------------------------------------------------*/
/*    D E F I N I Ä « O   T E M P - T A B L E S    */
/*-------------------------------------------------*/
    define temp-table tt-param no-undo
        FIELD destino            AS INTEGER
        FIELD arquivo            AS CHAR format "x(35)"
        FIELD usuario            AS CHAR format "x(12)"
        FIELD data-exec          AS DATE
        FIELD hora-exec          AS INTEGER
        FIELD fi-tipo-rateio-ini AS INTEGER
        FIELD fi-tipo-rateio-fim AS INTEGER
        FIELD mes-ini            AS INTEGER
        FIELD mes-fim            AS INTEGER
        FIELD ano-ini            AS INTEGER
        FIELD ano-fim            AS INTEGER
        FIELD fi-estab-ini       AS CHAR
        FIELD fi-estab-fim       AS CHAR
        FIELD tp-exec            AS INTEGER.


define temp-table tt-digita 
    FIELD canal-central AS INTEGER .

def temp-table tt-raw-digita 
    FIELD raw-digita	as raw.

DEF TEMP-TABLE tt-erro NO-UNDO
    FIELD codigo   AS INTEGER
    FIELD mensagem AS CHAR FORMAT "X(200)"
    FIELD ajuda    AS CHAR FORMAT "X(250)".

/*************** PAR∂METROS ***************/
DEF INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEF INPUT PARAMETER TABLE for tt-raw-digita.
 
CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

for each tt-raw-digita:
    create tt-digita.
    raw-transfer tt-raw-digita.raw-digita to tt-digita.
end.

DEF BUFFER b-int-rateio FOR int-rateio.
DEF BUFFER b-tt-rateio  FOR tt-rateio.

/*------------------------*/
/*     I N C L U D E S    */
/*------------------------*/
/* include padr∆o para vari†veis de relat¢rio  */
{include/i-rpvar.i}
{include/i-freeac.i}
{include/i-rpout.i}
{include/i-rpcab.i}
{include/tt-edit.i}
{include/pi-edit.i}
{utp/ut-glob.i}

/* bloco principal do programa */
ASSIGN c-programa     = "esfgl006"
       c-versao       = "2.00"
       c-revisao      = ".00.000"
       c-empresa      = "Intelbras"
       c-sistema      = "Contabilidade"
       c-titulo-relat = "Integraá∆o Rateio Despesa".

/************ DEFINIÄ«O DE VAR   IµVEIS **************/
DEFINE VARIABLE h-acomp   AS HANDLE                 NO-UNDO.
DEFINE VARIABLE c-dir     AS CHAR FORMAT "X(200)" NO-UNDO.
DEFINE VARIABLE c-dir-aux AS CHAR NO-UNDO.

/*-------------------*/
/*   F U N Ä Â E S   */
/*-------------------*/

FUNCTION fn-retorna-nome-beneficio RETURNS CHAR
    (p-beneficio AS INT) FORWARD.

/*------------------------------------------------------*/
/*    I N ÷ C I O  -   B L O C O   P R I N C I P A L    */
/*------------------------------------------------------*/
VIEW FRAME f-cabec.
VIEW FRAME f-rodape.


IF  NOT VALID-HANDLE(h-acomp) THEN                                  
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.                      
                                                                    
IF  VALID-HANDLE(h-acomp) THEN                                      
    RUN pi-inicializar IN h-acomp (INPUT "Gerando Apuraá∆o").
    
EMPTY TEMP-TABLE tt-prog-ponto.


IF OPSYS = "UNIX" THEN DO:
    DEF VAR c-barra AS CHAR  INIT '/' NO-UNDO.
    RUN esp/es0018p.p (INPUT  "SPOOL-UNIX",
                       INPUT  1,
                       INPUT  0,
                       INPUT  "",
                       OUTPUT TABLE tt-prog-ponto).
    FIND FIRST tt-prog-ponto.
    ASSIGN tt-prog-ponto.conteudo = tt-prog-ponto.conteudo + c-barra + c-seg-usuario + c-barra.

END.
ELSE DO:
    DEF VAR c-barra1 AS CHAR INIT '~\' NO-UNDO.
    RUN esp/es0018p.p (INPUT  "SPOOL-WIN",
                       INPUT  1,
                       INPUT  0,
                       INPUT  "",
                       OUTPUT TABLE tt-prog-ponto).
    FIND FIRST tt-prog-ponto.
    ASSIGN tt-prog-ponto.conteudo = tt-prog-ponto.conteudo + c-barra1 + c-seg-usuario + c-barra1.
END.

ASSIGN c-dir = tt-prog-ponto.conteudo.

ASSIGN c-dir-aux = c-dir.

ASSIGN c-dir = c-dir +  (IF tt-param.tp-exec = 1 THEN "simul_" ELSE "contab_") + STRING(TODAY,"99-99-9999") + "_" + STRING(TIME) + ".csv".

DEF STREAM s1.
OUTPUT STREAM s1 TO VALUE(c-dir) CONVERT TARGET "iso8859-1".

/* Essa Ç a PROCEDURE PRINCIPAL do programa, a qual contro a transaá∆o */                                                                                                                                                                     
RUN PI-PRINCIPAL.                                                                                                                                                                                                                             

OUTPUT STREAM s1 CLOSE.

/* Retornou erro */
PUT SKIP(2).
PUT "    Arquivo Simulaá∆o gerado em: " c-dir      SKIP(1).

                                                                         
/* DISPLYA PAR∂METROS */
/* PUT "                                                       PAR∂METROS" SKIP                 */
/*     "                                                   ------------------" SKIP(1).         */
/* PUT "                                                   Ano...: " string(tt-param.ano)  SKIP */
/*     "                                                   Màs...: " string(tt-param.mes)  SKIP */
/*     "                                                   Opá∆o.: " c-tipo  SKIP.              */
/*                                                                                              */


ASSIGN v_des_contdo_prog_valid_dtsul = "".

{include/i-rpclo.i}

if valid-handle(h-acomp) then    
    RUN pi-finalizar IN h-acomp. 
                                 
RETURN "OK".             
/*-----------------------------------------*/
/*  F I M   B L O C O   P R I N C I P A L  */
/*-----------------------------------------*/



/*-------------------------------------------------------------------------------------------------------------------------------------------------*/
/*                                                                                                                                                 */
/*                                                  P R O C E D U R E S  I N T E R N A S                                                           */
/*                                                                                                                                                 */
/*-------------------------------------------------------------------------------------------------------------------------------------------------*/
PROCEDURE PI-PRINCIPAL:

    DEF VAR c-comp-ini AS CHAR NO-UNDO.
    DEF VAR c-comp-fim AS CHAR NO-UNDO.
    DEF VAR de-tot-faturas AS DEC NO-UNDO.
    DEF VAR c-erro AS CHAR FORMAT "X(300)" NO-UNDO.

    ASSIGN c-comp-ini = string(tt-param.ano-ini, "9999") + string(tt-param.mes-ini, "99").

    ASSIGN v_dat_sdo_periodo = DATE("01/" + string(tt-param.mes-ini, "99") + "/" + string(tt-param.ano-ini, "9999"))
           v_dat_sdo_periodo = ADD-INTERVAL(v_dat_sdo_periodo,1 ,"MONTH") - DAY(v_dat_sdo_periodo).

    PUT STREAM s1 "Rateio;Competància;Lote;Estab;Estab Rateio;Natureza;Conta;Unid. Neg;C Custo;Valor Rateado;Hist¢rico" SKIP.
    
    FOR EACH int-rateio NO-LOCK
        WHERE int-rateio.tipo-rateio >= tt-param.fi-tipo-rateio-ini
          AND int-rateio.tipo-rateio <= tt-param.fi-tipo-rateio-fim
          AND int-rateio.competencia  = c-comp-ini 
          AND int-rateio.cod-estabel >= tt-param.fi-estab-ini
          AND int-rateio.cod-estabel <= tt-param.fi-estab-fim
          AND int-rateio.id-status    = 2 /*Liberado*/
          AND (IF tt-param.tp-exec = 2 THEN NOT int-rateio.id-contabilizado ELSE YES) /* N∆o Contabilizado */
        , FIRST int-rat-desp
              WHERE int-rat-desp.tipo-rateio = int-rateio.tipo-rateio:

          ASSIGN de-tot-faturas = 0.
          EMPTY TEMP-TABLE tt-rateio.

          FOR EACH int-rateio-fatur NO-LOCK
              WHERE int-rateio-fatur.tipo-rateio = int-rateio.tipo-rateio
                AND int-rateio-fatur.competencia = int-rateio.competencia 
                AND int-rateio-fatur.cod-estabel = int-rateio.cod-estabel:

                ASSIGN de-tot-faturas = de-tot-faturas + int-rateio-fatur.vl-base-rateio.
          END.

          EMPTY TEMP-TABLE tt-rateio.
          RUN pi-rateio (INPUT de-tot-faturas).
        
          DO TRANS:
              RUN pi-contabiliza (input int-rateio.tipo-rateio,
                                  input int-rateio.competencia, 
                                  input int-rateio.cod-estab,   
                                  OUTPUT c-erro).       
    
              IF  RETURN-VALUE <> "OK" THEN DO:
                  PUT SKIP(1)  "Rateio " STRING(int-rateio.tipo-rateio) " - "  SUBSTR(int-rateio.competencia, 5,2)  "/" SUBSTR(int-rateio.competencia, 1,4) " - " int-rateio.cod-estabel  ": "  SKIP c-erro  SKIP(1).
                  UNDO, NEXT.
              END.
          END.

    END.

    RETURN "OK".

END.

PROCEDURE pi-rateio:

    DEF INPUT PARAM p-vl-tot-faturas AS DEC NO-UNDO.

    DEF VAR de-total      AS DEC NO-UNDO.
    DEF VAR de-diferenca  AS DEC NO-UNDO.
    DEF VAR de-centavo    AS DEC NO-UNDO.
    DEF VAR de-perc-rat   AS DEC NO-UNDO.
        
    FOR EACH int-rateio-plan NO-LOCK
        OF int-rateio.

        CREATE tt-rateio.
        ASSIGN tt-rateio.tipo-rateio       = int-rateio.tipo-rateio
               tt-rateio.competencia       = int-rateio.competencia
               tt-rateio.cod-estabel       = int-rateio.cod-estabel
               tt-rateio.cod-estabel-rat   = int-rateio-plan.cod-estabel-rat
               tt-rateio.cod-centro-custo  = int-rateio-plan.cod-centro-custo
               tt-rateio.cod-unid-neg      = int-rateio-plan.cod-unid-neg
               tt-rateio.vl-rateio         = ROUND((p-vl-tot-faturas * int-rateio-plan.vl-perc-rateio) / 100, 2)
               tt-rateio.vl-perc-rateio    = int-rateio-plan.vl-perc-rateio.
    END.

    FOR EACH tt-rateio
        WHERE tt-rateio.cod-estabel <> tt-rateio.cod-estabel-rat
        BREAK BY tt-rateio.cod-estabel-rat:

        IF  FIRST-OF(tt-rateio.cod-estabel-rat) 
        THEN
            ASSIGN de-perc-rat = 0.

        ASSIGN de-perc-rat = de-perc-rat + tt-rateio.vl-perc-rateio.

        IF  LAST-OF(tt-rateio.cod-estabel-rat) 
        THEN DO:
            FOR EACH  b-tt-rateio
                WHERE b-tt-rateio.cod-estabel-rat  = tt-rateio.cod-estabel-rat
                  AND b-tt-rateio.cod-estabel     <> b-tt-rateio.cod-estabel-rat:
                ASSIGN b-tt-rateio.vl-perc-rateio  = (b-tt-rateio.vl-perc-rateio / de-perc-rat) * 100.
            END.
        END.
    END.

    FOR EACH tt-rateio
        WHERE tt-rateio.cod-estabel = tt-rateio.cod-estabel-rat
        BREAK BY tt-rateio.cod-estabel-rat:

        IF  FIRST-OF(tt-rateio.cod-estabel-rat) 
        THEN
            ASSIGN de-perc-rat = 0.

        ASSIGN de-perc-rat = de-perc-rat + tt-rateio.vl-perc-rateio.

        IF  LAST-OF(tt-rateio.cod-estabel-rat) 
        THEN DO:
            FOR EACH  b-tt-rateio
                WHERE b-tt-rateio.cod-estabel-rat  = tt-rateio.cod-estabel-rat
                  AND b-tt-rateio.cod-estabel      = b-tt-rateio.cod-estabel-rat:
                ASSIGN b-tt-rateio.vl-perc-rateio  = (b-tt-rateio.vl-perc-rateio / de-perc-rat) * 100.
            END.
        END.
    END.

    FOR EACH tt-rateio:
        ASSIGN de-total = de-total + tt-rateio.vl-rateio.
    END.

    IF  de-total <> p-vl-tot-faturas THEN
        de-diferenca = p-vl-tot-faturas - de-total.

    IF  de-diferenca < 0 THEN
        ASSIGN de-centavo = - 0.01.
    ELSE
        de-centavo = 0.01.

    DO WHILE  de-diferenca <> 0:
        FOR EACH tt-rateio
            BY tt-rateio.vl-rateio DESC.
    
            ASSIGN tt-rateio.vl-rateio = tt-rateio.vl-rateio + de-centavo.
    
            ASSIGN de-diferenca = de-diferenca - de-centavo.
    
            IF  de-diferenca = 0 THEN
                LEAVE.
        END.
        
        IF  de-diferenca = 0 THEN
            LEAVE.
    END.

    RETURN "OK".

END.

PROCEDURE pi-contabiliza:

    DEF INPUT PARAM p-tipo-rateio   AS INTEGER NO-UNDO.
    DEF INPUT PARAM p-competencia   AS CHAR NO-UNDO.
    DEF INPUT PARAM p-cod-estab     AS CHAR NO-UNDO.
    DEF OUTPUT PARAM p-erro         AS CHAR NO-UNDO.
    
    DEFINE VARIABLE v_tot_comis_db_cr    AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE v_tot_comis_un       AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE v_tot_comis_rep      AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE de-tot-rateio        AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE v_tot_rat_conf       AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE de-val-rat-por-estab AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE de-val-rat-sdo-cta   AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE de-sdo-cta           AS DECIMAL     NO-UNDO.

    DEF VAR c-ct-transitoria AS CHAR NO-UNDO.
    DEF VAR c-ct-despesa     AS CHAR NO-UNDO.
    DEF VAR c-ct-transf      AS CHAR NO-UNDO.

    FIND estabelec NO-LOCK
        WHERE estabelec.cod-estabel = p-cod-estab NO-ERROR.

    /* Buscar as contas contabeis parametrizadas */
    FOR EACH int-rat-desp-lancto NO-LOCK
        WHERE int-rat-desp-lancto.tipo-rateio = p-tipo-rateio:
        CASE int-rat-desp-lancto.tipo-lancto:
            WHEN 1 THEN c-ct-transitoria = int-rat-desp-lancto.ct-codigo.
            WHEN 2 THEN c-ct-despesa     = int-rat-desp-lancto.ct-codigo.
            WHEN 3 THEN c-ct-transf      = int-rat-desp-lancto.ct-codigo.
        END.
    END.
    IF  c-ct-transitoria = "" OR c-ct-despesa = "" OR c-ct-transf = "" THEN DO:
        ASSIGN p-erro = "Conta Transit¢riaa, transferància ou Despesa n∆o cadastrada(s) NO programa esfgl004 - Tipos de rateio".
        RETURN "NOK".
    END.

    RUN pi-competencia (INPUT p-competencia, OUTPUT da-data-fim).

    EMPTY TEMP-TABLE tt_integr_aprop_lancto_ctbl_1.
    EMPTY TEMP-TABLE tt_integr_ctbl_valid_1.
    EMPTY TEMP-TABLE tt_integr_ctbl_valid_parametros.
    EMPTY TEMP-TABLE tt_integr_item_lancto_ctbl_1.
    EMPTY TEMP-TABLE tt_integr_lancto_ctbl_1.
    EMPTY TEMP-TABLE tt_integr_lancto_ctbl_aux.
    EMPTY TEMP-TABLE tt_integr_lote_ctbl_1.
    

    CREATE tt_integr_lote_ctbl_1.
    ASSIGN tt_integr_lote_ctbl_1.tta_cod_modul_dtsul      = "FGL"
           tt_integr_lote_ctbl_1.tta_num_lote_ctbl        = 99999999
           tt_integr_lote_ctbl_1.tta_des_lote_ctbl        = "Rateio " + STRING(p-tipo-rateio) + " - "  + SUBSTR(p-competencia, 1,4) + "/" + SUBSTR(p-competencia, 5,2) + " - " + p-cod-estab
           tt_integr_lote_ctbl_1.tta_cod_empresa          = estabelec.ep-codigo
           tt_integr_lote_ctbl_1.tta_dat_lote_ctbl        = da-data-fim
           tt_integr_lote_ctbl_1.ttv_rec_integr_lote_ctbl = RECID(tt_integr_lote_ctbl_1).

    CREATE tt_integr_lancto_ctbl_1.
    ASSIGN tt_integr_lancto_ctbl_1.tta_cod_cenar_ctbl         = ""
           tt_integr_lancto_ctbl_1.ttv_rec_integr_lote_ctbl   = tt_integr_lote_ctbl_1.ttv_rec_integr_lote_ctbl
           tt_integr_lancto_ctbl_1.tta_num_lancto_ctbl        = 1
           tt_integr_lancto_ctbl_1.tta_dat_lancto_ctbl        = da-data-fim
           tt_integr_lancto_ctbl_1.ttv_rec_integr_lancto_ctbl = RECID(tt_integr_lancto_ctbl_1).

    ASSIGN i-seq = 0.

    FOR EACH tt-rateio
        BREAK BY tt-rateio.cod-estabel-rat:

        IF  FIRST-OF (tt-rateio.cod-estabel-rat) THEN
            ASSIGN de-val-rat-por-estab = 0.

        ASSIGN de-val-rat-por-estab = de-val-rat-por-estab + tt-rateio.vl-rateio.

        /* DESPESA */
        RUN pi-cria-lancto (INPUT c-ct-despesa, /* Conta Despesa */
                            INPUT tt-rateio.cod-centro-custo,
                            INPUT tt-rateio.cod-estabel-rat,
                            INPUT tt-rateio.cod-unid-neg,
                            INPUT tt-rateio.vl-rateio,
                            INPUT "Despesa",
                            INPUT "DB").

       IF  LAST-OF (tt-rateio.cod-estabel-rat) THEN DO:
            /* CONTRA-PARTIDA TRANSIT‡RIA */
            RUN pi-cria-lancto (INPUT c-ct-transitoria, /* Conta Transit¢ria */
                                INPUT "",
                                INPUT tt-rateio.cod-estabel-rat,
                                INPUT "ADM",
                                INPUT de-val-rat-por-estab,
                                INPUT "Transit¢ria",
                                INPUT "CR").

            /* Quando o estabelecimento de rateio for igual ao estabelecimento das faturas */
            IF  p-cod-estab <> tt-rateio.cod-estabel-rat THEN DO:

                /* Transit¢ria */
                RUN pi-cria-lancto (INPUT c-ct-transitoria, /* Transitoria */
                                    INPUT "",
                                    INPUT p-cod-estab,
                                    INPUT "ADM",
                                    INPUT de-val-rat-por-estab,
                                    INPUT "Transit¢ria",
                                    INPUT "CR").

                /* CONTRA-PARTIDA TRANSIT‡RIA */
                RUN pi-cria-lancto (INPUT c-ct-transf, /* Conta Transferància Recurso */
                                    INPUT "",
                                    INPUT p-cod-estab,
                                    INPUT "ADM",
                                    INPUT de-val-rat-por-estab,
                                    INPUT "Transf. Recurso",
                                    INPUT "DB").

                /* CONTRA-PARTIDA TRANSIT‡RIA */
                RUN pi-cria-lancto (INPUT c-ct-transf, /* Conta Transferància Recurso */
                                    INPUT "",
                                    INPUT tt-rateio.cod-estabel-rat,
                                    INPUT "ADM",
                                    INPUT de-val-rat-por-estab,
                                    INPUT "Transf. Recurso",
                                    INPUT "CR").

                /* Transit¢ria */
                RUN pi-cria-lancto (INPUT c-ct-transitoria, /* Conta Despesa */
                                    INPUT "",
                                    INPUT tt-rateio.cod-estabel-rat,
                                    INPUT "ADM",
                                    INPUT de-val-rat-por-estab,
                                    INPUT "Despesa",
                                    INPUT "DB").

                /* RATEIO SALDO CONTA */
                EMPTY TEMP-TABLE tt_input_leitura_sdo.
                EMPTY TEMP-TABLE tt_retorna_sdo_ctbl.
                EMPTY TEMP-TABLE tt_log_erros.

                RUN pi_cria_leitura (INPUT estabelec.ep-codigo,
                                     INPUT c-ct-transitoria,
                                     INPUT c-ct-transitoria,
                                     INPUT v_dat_sdo_periodo).

                RUN prgfin/fgl/fgl905zb.py (INPUT        estabelec.ep-codigo,
                                            INPUT  TABLE tt_input_leitura_sdo,
                                            OUTPUT TABLE tt_retorna_sdo_ctbl,
                                            OUTPUT TABLE tt_log_erros).
                
                ASSIGN de-sdo-cta = 0.
                FOR EACH  tt_retorna_sdo_ctbl
                    WHERE tt_retorna_sdo_ctbl.tta_cod_estab = tt-rateio.cod-estabel-rat:
                    ASSIGN de-sdo-cta = de-sdo-cta + tt_retorna_sdo_ctbl.tta_val_sdo_ctbl_fim.
                END.

                IF  de-sdo-cta > 0
                THEN DO:
                    FOR EACH  b-tt-rateio
                        WHERE b-tt-rateio.cod-estabel-rat = tt-rateio.cod-estabel-rat:

                        ASSIGN de-val-rat-sdo-cta = de-sdo-cta * (b-tt-rateio.vl-perc-rateio / 100).

                        /* Transit¢ria */
                        RUN pi-cria-lancto (INPUT c-ct-transitoria, /* Transitoria */
                                            INPUT "",
                                            INPUT b-tt-rateio.cod-estabel-rat,
                                            INPUT "ADM",
                                            INPUT de-val-rat-sdo-cta,
                                            INPUT "Rateio Saldo Transit¢ria",
                                            INPUT "CR").
        
                        /* DESPESA */
                        RUN pi-cria-lancto (INPUT c-ct-despesa, /* Conta Despesa */
                                            INPUT b-tt-rateio.cod-centro-custo,
                                            INPUT b-tt-rateio.cod-estabel-rat,
                                            INPUT b-tt-rateio.cod-unid-neg,
                                            INPUT de-val-rat-sdo-cta,
                                            INPUT "Rateio Saldo Transit¢ria",
                                            INPUT "DB").
                    END.
                END.

                IF  de-sdo-cta < 0
                THEN DO:
                    ASSIGN de-sdo-cta = de-sdo-cta * -1.
                    FOR EACH  b-tt-rateio
                        WHERE b-tt-rateio.cod-estabel-rat = tt-rateio.cod-estabel-rat:

                        ASSIGN de-val-rat-sdo-cta = de-sdo-cta * (b-tt-rateio.vl-perc-rateio / 100).

                        /* Transit¢ria */
                        RUN pi-cria-lancto (INPUT c-ct-transitoria, /* Transitoria */
                                            INPUT "",
                                            INPUT b-tt-rateio.cod-estabel-rat,
                                            INPUT "ADM",
                                            INPUT de-val-rat-sdo-cta,
                                            INPUT "Rateio Saldo Transit¢ria",
                                            INPUT "DB").
        
                        /* DESPESA */
                        RUN pi-cria-lancto (INPUT c-ct-despesa, /* Conta Despesa */
                                            INPUT b-tt-rateio.cod-centro-custo,
                                            INPUT b-tt-rateio.cod-estabel-rat,
                                            INPUT b-tt-rateio.cod-unid-neg,
                                            INPUT de-val-rat-sdo-cta,
                                            INPUT "Rateio Saldo Transit¢ria",
                                            INPUT "CR").
                    END.
                END.
            END.
       END.

       ASSIGN de-tot-rateio = de-tot-rateio + tt-rateio.vl-rateio.

    END.


    /* RATEIO SALDO CONTA */
    EMPTY TEMP-TABLE tt_input_leitura_sdo.
    EMPTY TEMP-TABLE tt_retorna_sdo_ctbl.
    EMPTY TEMP-TABLE tt_log_erros.

    RUN pi_cria_leitura (INPUT estabelec.ep-codigo,
                         INPUT c-ct-transitoria,
                         INPUT c-ct-transitoria,
                         INPUT v_dat_sdo_periodo).

    RUN prgfin/fgl/fgl905zb.py (INPUT        1,
                                INPUT  TABLE tt_input_leitura_sdo,
                                OUTPUT TABLE tt_retorna_sdo_ctbl,
                                OUTPUT TABLE tt_log_erros).

    ASSIGN de-sdo-cta = 0.
    FOR EACH  tt_retorna_sdo_ctbl
        WHERE tt_retorna_sdo_ctbl.tta_cod_estab = p-cod-estab:
        ASSIGN de-sdo-cta = de-sdo-cta + tt_retorna_sdo_ctbl.tta_val_sdo_ctbl_fim.
    END.

    IF  de-sdo-cta <> 0
    THEN DO:
        FOR EACH  b-tt-rateio:
            ASSIGN de-sdo-cta = de-sdo-cta - b-tt-rateio.vl-rateio.
        END.
    END.

    IF  de-sdo-cta > 0
    THEN DO:
        FOR EACH  b-tt-rateio
            WHERE b-tt-rateio.cod-estabel-rat = p-cod-estab:

            ASSIGN de-val-rat-sdo-cta = de-sdo-cta * (b-tt-rateio.vl-perc-rateio / 100).

            /* Transit¢ria */
            RUN pi-cria-lancto (INPUT c-ct-transitoria, /* Transitoria */
                                INPUT "",
                                INPUT b-tt-rateio.cod-estabel,
                                INPUT "ADM",
                                INPUT de-val-rat-sdo-cta,
                                INPUT "Rateio Saldo Transit¢ria",
                                INPUT "CR").

            /* DESPESA */
            RUN pi-cria-lancto (INPUT c-ct-despesa, /* Conta Despesa */
                                INPUT b-tt-rateio.cod-centro-custo,
                                INPUT b-tt-rateio.cod-estabel,
                                INPUT b-tt-rateio.cod-unid-neg,
                                INPUT de-val-rat-sdo-cta,
                                INPUT "Rateio Saldo Transit¢ria",
                                INPUT "DB").
        END.
    END.

    IF  de-sdo-cta < 0
    THEN DO:
        ASSIGN de-sdo-cta = de-sdo-cta * -1.
        FOR EACH  b-tt-rateio
            WHERE b-tt-rateio.cod-estabel-rat = p-cod-estab:

            ASSIGN de-val-rat-sdo-cta = de-sdo-cta * (b-tt-rateio.vl-perc-rateio / 100).

            /* Transit¢ria */
            RUN pi-cria-lancto (INPUT c-ct-transitoria, /* Transitoria */
                                INPUT "",
                                INPUT b-tt-rateio.cod-estabel,
                                INPUT "ADM",
                                INPUT de-val-rat-sdo-cta,
                                INPUT "Rateio Saldo Transit¢ria",
                                INPUT "DB").

            /* DESPESA */
            RUN pi-cria-lancto (INPUT c-ct-despesa, /* Conta Despesa */
                                INPUT b-tt-rateio.cod-centro-custo,
                                INPUT b-tt-rateio.cod-estabel,
                                INPUT b-tt-rateio.cod-unid-neg,
                                INPUT de-val-rat-sdo-cta,
                                INPUT "Rateio Saldo Transit¢ria",
                                INPUT "CR").
        END.
    END.


    IF  tt-param.tp-exec = 2 THEN DO:
        DEF VAR v_cod_arq AS CHAR NO-UNDO.
        ASSIGN v_cod_arq = c-dir-aux + "esfgl006.txt".

        OUTPUT STREAM s_1 TO VALUE(v_cod_arq)
                       PAGED PAGE-SIZE VALUE(65) CONVERT TARGET 'iso8859-1'.

        RUN prgfin/fgl/fgl900zl.py (INPUT 3,
                                    INPUT "Aborta Tudo",
                                    INPUT YES,
                                    INPUT 66,
                                    INPUT "Apropriaá∆o",
                                    INPUT "Todos",
                                    INPUT YES,
                                    INPUT YES,
                                    INPUT-OUTPUT TABLE tt_integr_lote_ctbl_1,
                                    INPUT-OUTPUT TABLE tt_integr_lancto_ctbl_1,
                                    INPUT-OUTPUT TABLE tt_integr_item_lancto_ctbl_1,
                                    INPUT-OUTPUT TABLE tt_integr_aprop_lancto_ctbl_1,
                                    INPUT-OUTPUT TABLE tt_integr_ctbl_valid_1).

        FIND FIRST tt_integr_lote_ctbl_1.

        OUTPUT STREAM S_1 CLOSE.
        RUN pi_show_report_2 (INPUT v_cod_arq).
    END.

    IF  tt_integr_lote_ctbl_1.tta_num_lote_ctbl <> 99999999 THEN DO TRANS:
           DEF BUFFER b-hist FOR int-rateio-hist.
           FIND LAST b-hist NO-LOCK
               WHERE b-hist.tipo-rateio  = p-tipo-rateio 
                 AND b-hist.competencia  = p-competencia 
                 AND b-hist.cod-estabel  = p-cod-estab  NO-ERROR. 

            CREATE int-rateio-hist.
            ASSIGN int-rateio-hist.tipo-rateio  = p-tipo-rateio
                   int-rateio-hist.competencia  = p-competencia
                   int-rateio-hist.cod-estabel  = p-cod-estab  
                   int-rateio-hist.sequencia    = b-hist.sequencia + 1
                   int-rateio-hist.tp-acao      = 0 
                   int-rateio-hist.cod-usuario  =  c-seg-usuario
                   int-rateio-hist.data-hora    = DATETIME(TODAY, MTIME)
                   int-rateio-hist.ds-motivo    = "Contabilizaá∆o realizada.".
        

            /* SETA O RATEIO COMO CONTABILIZADO */
            FIND FIRST b-int-rateio EXCLUSIVE-LOCK
                WHERE  b-int-rateio.tipo-rateio = p-tipo-rateio 
                  AND  b-int-rateio.competencia = p-competencia 
                  AND  b-int-rateio.cod-estabel = p-cod-estab NO-ERROR.
            IF  AVAIL b-int-rateio THEN
                ASSIGN b-int-rateio.id-contabilizado = YES.
            FIND CURRENT b-int-rateio NO-LOCK.
            IF  NOT AVAIL b-int-rateio THEN DO:
                ASSIGN p-erro = "N∆o foi poss°vel setar o rateio para contabilizado".
                RETURN "NOK".
            END.
    END.

    DEF VAR c-lote AS CHAR FORMAT "X(15)".
    
    FOR EACH tt_integr_item_lancto_ctbl_1:
        
        IF  tt-param.tp-exec = 2  THEN
            ASSIGN c-lote = IF  AVAIL tt_integr_lote_ctbl_1 AND tt_integr_lote_ctbl_1.tta_num_lote_ctbl = 99999999 THEN  
                                "Erro, n∆o gerado"
                            ELSE
                                string(tt_integr_lote_ctbl_1.tta_num_lote_ctbl).
        ELSE
            c-lote = "Simulaá∆o".

        PUT STREAM s1 UNFORMATTED p-tipo-rateio                                                     ";"
                      p-competencia                                                     ";"
                      c-lote ";" 
                      p-cod-estab                                                       ";"
                      tt_integr_item_lancto_ctbl_1.tta_cod_estab                        ";"
                      tt_integr_item_lancto_ctbl_1.tta_ind_natur_lancto_ctbl            ";"
                      tt_integr_item_lancto_ctbl_1.tta_cod_cta_ctbl                     ";"
                      tt_integr_item_lancto_ctbl_1.tta_cod_unid_negoc                   ";"
                      tt_integr_item_lancto_ctbl_1.tta_cod_ccusto                       ";"
                      IF  tt_integr_item_lancto_ctbl_1.tta_ind_natur_lancto_ctbl = "DB" 
                      THEN 
                          (tt_integr_item_lancto_ctbl_1.tta_val_lancto_ctbl * -1)       
                      ELSE
                          tt_integr_item_lancto_ctbl_1.tta_val_lancto_ctbl              ";"
                      tt_integr_item_lancto_ctbl_1.tta_des_histor_lancto_ctbl SKIP.
    END.
    RETURN "OK".

END.

PROCEDURE pi-cria-lancto:

    DEF INPUT PARAM p-conta      AS CHAR    NO-UNDO.
    DEF INPUT PARAM p-cc-custo   AS CHAR    NO-UNDO.
    DEF INPUT PARAM p-estab-rat  AS CHAR    NO-UNDO. 
    DEF INPUT PARAM p-unid-neg   AS CHAR    NO-UNDO.
    DEF INPUT PARAM p-valor      AS DEC     NO-UNDO.
    DEF INPUT PARAM p-ds-lancto  AS CHAR    NO-UNDO.
    DEF INPUT PARAM p-tipo       AS CHAR    NO-UNDO.

    ASSIGN i-seq = i-seq + 1.

    CREATE tt_integr_item_lancto_ctbl_1.
    ASSIGN tt_integr_item_lancto_ctbl_1.ttv_rec_integr_lancto_ctbl      = tt_integr_lancto_ctbl_1.ttv_rec_integr_lancto_ctbl
           tt_integr_item_lancto_ctbl_1.tta_num_seq_lancto_ctbl         = i-seq
           tt_integr_item_lancto_ctbl_1.tta_ind_natur_lancto_ctbl       = p-tipo
           tt_integr_item_lancto_ctbl_1.tta_cod_plano_cta_ctbl          = "Padrao"
           tt_integr_item_lancto_ctbl_1.tta_cod_cta_ctbl                = p-conta
           tt_integr_item_lancto_ctbl_1.tta_cod_plano_ccusto            = IF p-cc-custo <> "" THEN "Padrao" ELSE ""
           tt_integr_item_lancto_ctbl_1.tta_cod_ccusto                  = p-cc-custo
           tt_integr_item_lancto_ctbl_1.tta_cod_estab                   = p-estab-rat
           tt_integr_item_lancto_ctbl_1.tta_cod_unid_negoc              = p-unid-neg
           tt_integr_item_lancto_ctbl_1.tta_des_histor_lancto_ctbl      = p-ds-lancto + " - " + string(da-data-fim)
           tt_integr_item_lancto_ctbl_1.tta_cod_indic_econ              = "Real"
           tt_integr_item_lancto_ctbl_1.tta_dat_lancto_ctbl             = da-data-fim
           tt_integr_item_lancto_ctbl_1.tta_val_lancto_ctbl             = p-valor
           tt_integr_item_lancto_ctbl_1.tta_cod_proj_financ             = ""
           tt_integr_item_lancto_ctbl_1.ttv_rec_integr_item_lancto_ctbl = RECID(tt_integr_item_lancto_ctbl_1).

    CREATE tt_integr_aprop_lancto_ctbl_1.
    ASSIGN tt_integr_aprop_lancto_ctbl_1.tta_cod_finalid_econ             = "Corrente"
           tt_integr_aprop_lancto_ctbl_1.tta_cod_unid_negoc               = p-unid-neg
           tt_integr_aprop_lancto_ctbl_1.tta_cod_plano_ccusto             = IF p-cc-custo <> "" THEN "Padrao" ELSE ""
           tt_integr_aprop_lancto_ctbl_1.tta_cod_ccusto                   = p-cc-custo
           tt_integr_aprop_lancto_ctbl_1.tta_val_lancto_ctbl              = p-valor
           tt_integr_aprop_lancto_ctbl_1.ttv_rec_integr_item_lancto_ctbl  = tt_integr_item_lancto_ctbl_1.ttv_rec_integr_item_lancto_ctbl
           tt_integr_aprop_lancto_ctbl_1.ttv_rec_integr_aprop_lancto_ctbl = RECID(tt_integr_aprop_lancto_ctbl_1).

END.

PROCEDURE pi-competencia:

    DEF INPUT PARAM p-competencia AS CHAR NO-UNDO.
    DEF OUTPUT PARAM p-data       AS DATE NO-UNDO.

    DEF VAR v_mes AS CHAR NO-UNDO.
    DEF VAR v_ano AS CHAR NO-UNDO.
        
    
    IF SUBSTRING(p-competencia,5,2) = "12" 
       THEN ASSIGN v_mes = "01"
                   v_ano = string((int( SUBSTRING(p-competencia,1,4)) + 1), "9999").
       ELSE ASSIGN v_mes = string((int(SUBSTRING(p-competencia,5,2)) + 1),"99")
                   v_ano = string((int(SUBSTRING(p-competencia,1,4)) ), "9999").
    
       ASSIGN p-data = DATE("01/" + v_mes + "/" + v_ano) - 1.

END.

PROCEDURE pi_show_report_2:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_dwb_file
        as character
        format "x(40)"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_cod_key_value
        as character
        format "x(8)":U
        no-undo.


    /************************** Variable Definition End *************************/

    get-key-value section 'EMS' key 'Show-Report-Program' value v_cod_key_value.
    if  v_cod_key_value = ""
    or   v_cod_key_value = ?
    then do:
        assign v_cod_key_value = 'notepad.exe'.
        put-key-value section 'EMS' key 'Show-Report-Program' value v_cod_key_value no-error.
    end /* if */.

    run winexec (input v_cod_key_value + chr(32) + p_cod_dwb_file, input 1).

    END PROCEDURE.

    PROCEDURE WinExec EXTERNAL 'kernel32.dll':
      DEF INPUT  PARAM prg_name                          AS CHARACTER.
      DEF INPUT  PARAM prg_style                         AS SHORT.




END PROCEDURE. /* pi_show_report_2 */


PROCEDURE pi_cria_leitura:

    DEF INPUT PARAMETER p_cod_empresa      AS CHAR.
    DEF INPUT PARAMETER p_cod_cta_ctbl_ini AS CHAR.
    DEF INPUT PARAMETER p_cod_cta_ctbl_fim AS CHAR.
    DEF INPUT PARAMETER p_dat_refer        AS DATE.

    CREATE tt_input_leitura_sdo.
    ASSIGN tt_input_leitura_sdo.ttv_cod_label    = "Empresa"
           tt_input_leitura_sdo.ttv_des_conteudo = p_cod_empresa
           tt_input_leitura_sdo.ttv_num_seq_1    = 1
           tt_input_leitura_sdo.ttv_num_seq_2    = 1.
    
    CREATE tt_input_leitura_sdo.
    ASSIGN tt_input_leitura_sdo.ttv_cod_label    = "Finalidade Econìmica"
           tt_input_leitura_sdo.ttv_des_conteudo = 'Corrente'
           tt_input_leitura_sdo.ttv_num_seq_1    = 1
           tt_input_leitura_sdo.ttv_num_seq_2    = 2. 
    
    CREATE tt_input_leitura_sdo. 
    ASSIGN tt_input_leitura_sdo.ttv_cod_label    = "Conta Contabil Inicial"
           tt_input_leitura_sdo.ttv_des_conteudo = p_cod_cta_ctbl_ini
           tt_input_leitura_sdo.ttv_num_seq_1    = 1
           tt_input_leitura_sdo.ttv_num_seq_2    = 3.
    
    CREATE tt_input_leitura_sdo. 
    ASSIGN tt_input_leitura_sdo.ttv_cod_label    = "Conta Contabil Final"
           tt_input_leitura_sdo.ttv_des_conteudo = p_cod_cta_ctbl_fim
           tt_input_leitura_sdo.ttv_num_seq_1    = 1
           tt_input_leitura_sdo.ttv_num_seq_2    = 4.
    
    CREATE tt_input_leitura_sdo.
    ASSIGN tt_input_leitura_sdo.ttv_cod_label    = "Data Final"
           tt_input_leitura_sdo.ttv_des_conteudo = string(p_dat_refer, '99/99/9999')
           tt_input_leitura_sdo.ttv_num_seq_1    = 1
           tt_input_leitura_sdo.ttv_num_seq_2    = 5.

END.
