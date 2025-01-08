/*{include/i-prgvrs.i ESUTP006 2.04.00.000}*/
/***********************************************************************
**  Programa..: ESP\UTP\ESUTP005RP.P
**  Autor.....: Raphael Paini
**  Data......: Junho/2008 - Desenvolvimento
**  Descricao.: Integra Contabilidade Telefonia
**  Vers∆o....: 001 07/06/2008
**                  Desenvolvimento Programa
************************************************************************/

/****************************  Definitions  ****************************/

/****************************  Temp-Tables  ****************************/
{esp/utp/esutp006tt.i}

DEFINE TEMP-TABLE tt-rateios NO-UNDO LIKE rateio-equipamentos  
            FIELD r-Rowid AS ROWID.

DEFINE TEMP-TABLE tt-rateios2 NO-UNDO LIKE rateio-equipamentos 
            FIELD r-Rowid AS ROWID.

DEFINE TEMP-TABLE tt-rateios3 NO-UNDO LIKE rateio-equipamentos 
            FIELD r-Rowid AS ROWID.

DEF NEW GLOBAL SHARED VAR c-seg-usuario AS CHARACTER FORM "x(12)" NO-UNDO.

DEFINE TEMP-TABLE tt-faturas NO-UNDO LIKE fatura-equipamentos
    FIELD ct-codigo LIKE equipamentos.ct-codigo
    FIELD nome-fornec AS CHARACTER FORMAT "x(10)"
    FIELD r-rowid   AS ROWID.

DEFINE TEMP-TABLE tt-contas NO-UNDO
    FIELD cod-estabel        LIKE rateio-equipamentos.cod-estabel 
    FIELD cod-estabel-rateio LIKE cc-equipamentos.cod-estabel-rateio
    FIELD equipamento        LIKE rateio-equipamentos.equipamento 
    FIELD ct-codigo          LIKE rateio-equipamentos.ct-codigo   
    FIELD cc-codigo          LIKE rateio-equipamentos.cc-codigo
    FIELD cod-unid-negoc     LIKE rateio-equipamentos.cod-unid-negoc
    FIELD descricao          AS CHARACTER FORMAT "x(40)"
    FIELD per-rateio         LIKE cc-equipamentos.per-rateio
    FIELD erro               AS CHARACTER FORMAT "x(40)"
    INDEX ch-chave cod-estabel
                   equipamento
                   ct-codigo
                   cc-codigo
    INDEX ch-erro erro.

DEFINE TEMP-TABLE tt-perc-valor NO-UNDO
    FIELD cod-estabel    LIKE rateio-equipamentos.cod-estabel 
    FIELD ct-codigo      LIKE rateio-equipamentos.ct-codigo   
    FIELD cc-codigo      LIKE rateio-equipamentos.cc-codigo
    FIELD cod-unid-negoc LIKE rateio-equipamentos.cod-unid-negoc
    FIELD perc             AS DECIMAL DECIMALS 8
    FIELD val-valor        AS DECIMAL
    FIELD val-rateio       AS DECIMAL
    FIELD val-total        AS DECIMAL
    INDEX ch-chave cod-estabel
                   ct-codigo  
                   cc-codigo.

def new shared temp-table tt_integr_aprop_lancto_ctbl_1 no-undo
    field tta_cod_finalid_econ             as character format "x(10)" label "Finalidade" column-label "Finalidade"
    field tta_cod_unid_negoc               as character format "x(3)" label "Unid Neg¢cio" column-label "Un Neg"
    field tta_cod_plano_ccusto             as character format "x(8)" label "Plano Centros Custo" column-label "Plano Centros Custo"
    field tta_qtd_unid_lancto_ctbl         as decimal format ">>,>>>,>>9.99" decimals 2 initial 0 label "Quantidade" column-label "Quantidade"
    field tta_val_lancto_ctbl              as decimal format ">>>>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Lanáamento" column-label "Valor Lanáamento"
    field tta_num_id_aprop_lancto_ctbl     as integer format "9999999999" initial 0 label "Apropriacao Lanáto" column-label "Apropriacao Lanáto"
    field ttv_rec_integr_item_lancto_ctbl  as recid format ">>>>>>9"
    field tta_dat_cotac_indic_econ         as date format "99/99/9999" initial ? label "Data Cotaá∆o" column-label "Data Cotaá∆o"
    field tta_val_cotac_indic_econ         as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Cotaá∆o" column-label "Cotaá∆o"
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
          ttv_rec_integr_aprop_lancto_ctbl ascending
    .

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
    field tta_qtd_unid_lancto_ctbl         as decimal format ">>,>>>,>>9.99" decimals 2 initial 0 label "Quantidade" column-label "Quantidade"
    field tta_val_lancto_ctbl              as decimal format ">>>>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Lanáamento" column-label "Valor Lanáamento"
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

/****************************  Frames       ****************************/

DEF input parameter raw-param as raw no-undo.
DEF input parameter table for tt-raw-digita.


CREATE tt-param.
RAW-TRANSFER raw-param to tt-param.

DEF var h-acomp      as handle no-undo.

FOR FIRST param-global NO-LOCK. END.
FOR FIRST mgcad.empresa NO-LOCK WHERE
                 empresa.ep-codigo = param-global.empresa-pri: END.
FIND FIRST tt-param NO-ERROR.

DEFINE VARIABLE c-sistema      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-titulo-relat AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-empresa      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-programa     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-versao       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-revisao      AS CHARACTER   NO-UNDO.

DEFINE VARIABLE de-valor-rateado  AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-valor-liquido  AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-valor-outros   AS DECIMAL     NO-UNDO.

DEFINE VARIABLE dt-saldo             AS DATE     NO-UNDO.
DEFINE VARIABLE de-valor-contabil    AS DECIMAL  NO-UNDO.
DEFINE VARIABLE de-saldo-transitoria AS DECIMAL  NO-UNDO.

DEFINE VARIABLE l-erro AS LOGICAL     NO-UNDO.

ASSIGN c-sistema      = "Espec°ficos Intelbras"
       c-titulo-relat = "Integra Comunicaá‰es - Contabilidade"
       c-empresa      = if avail empresa then mgcad.empresa.razao-social else ''
       c-programa     = "ESUTP006"
       c-versao       = "2.04"
       c-revisao      = "002".

/* ***************************  Main Block  *************************** */

FOR EACH tt-faturas:
    DELETE tt-faturas.
END.
FOR EACH tt-contas:
    DELETE tt-contas.
END.
FOR EACH tt-perc-valor:
    DELETE tt-perc-valor.
END.
FOR EACH tt-rateios:
    DELETE tt-rateios.
END.
FOR EACH tt-rateios2:
    DELETE tt-rateios2.
END.
FOR EACH tt-rateios3:
    DELETE tt-rateios3.
END.                  

DO ON STOP UNDO, LEAVE:

    OUTPUT TO VALUE(tt-param.arquivo).
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
    RUN pi-inicializar in h-acomp (input "Iniciando...").

    VIEW FRAME f-cabec.
    VIEW FRAME f-rodape.

    ASSIGN l-erro = NO.

    FIND FIRST integra-equipamentos NO-LOCK
         WHERE integra-equipamentos.mes-ref = tt-param.periodo 
           AND integra-equipamentos.tipo    = 0 NO-ERROR.
    IF AVAIL integra-equipamentos AND tt-param.execucao = 2 THEN DO:
        PUT UNFORMATTED "ERRO - Periodo: " STRING(tt-param.periodo) " ja foi integrado na Data: " integra-equipamentos.data
            " e Hora: " integra-equipamentos.hora " pelo Usuario: " integra-equipamentos.usuario SKIP.
        OUTPUT CLOSE.

        ASSIGN l-erro = YES.
    END.
    ELSE DO:
        RUN pi-carrega-dados.
        RUN pi-validar.

        /*IF NOT CAN-FIND(FIRST tt-contas NO-LOCK WHERE tt-contas.erro <> "") THEN*/
            RUN pi-gera-rateio.

        RUN pi-relatorio.

        IF INT(SUBSTRING(tt-param.periodo,5,2)) = 12 THEN
            ASSIGN dt-saldo = DATE(01,01,INT(SUBSTRING(tt-param.periodo,1,4)) + 1) - 1.
        ELSE 
            ASSIGN dt-saldo = DATE(INT(SUBSTRING(tt-param.periodo,5,2)) + 1,01,INT(SUBSTRING(tt-param.periodo,1,4))) - 1.

        RUN pi-saldo-transitoria(INPUT dt-saldo,
                                 OUTPUT de-saldo-transitoria).

        ASSIGN de-valor-contabil = 0.
        FOR EACH tt-rateios3:
            ASSIGN de-valor-contabil = de-valor-contabil + tt-rateios3.val-rateio.
        END.

        PUT UNFORMATTED 
            "SALDO TRANSITORIA - VALOR CONTABILIZAR" SKIP(1)
            " Saldo Transitoria:"                          AT 01 
            STRING(de-saldo-transitoria,"->>>,>>>,>>9.99") AT 21 SKIP
            "Valor Contabilizar:"                          AT 01
            STRING(de-valor-contabil,"->>>,>>>,>>9.99")    AT 21 SKIP
            "         Diferenca:"                          AT 01
            STRING(de-saldo-transitoria - 
                   de-valor-contabil,"->>>,>>>,>>9.99")    AT 21 SKIP
            SKIP(1)
            FILL("-",150) SKIP.

        OUTPUT CLOSE.

        IF CAN-FIND(FIRST tt-rateios2 NO-LOCK WHERE tt-rateios2.val-rateio < 0) THEN DO:
            MESSAGE "Existem lanáamentos negativos, n∆o podem conter esse tipo de lanáamentos. Processo cancelado!"
                VIEW-AS ALERT-BOX ERROR BUTTONS OK.
            ASSIGN l-erro = YES.
        END.
        ELSE DO:
            IF tt-param.execucao = 2                    AND  
               de-saldo-transitoria = de-valor-contabil AND
               NOT CAN-FIND(FIRST tt-contas NO-LOCK 
                            WHERE tt-contas.erro <> "") THEN DO:
        
                DEF NEW SHARED STREAM s_1.
                OUTPUT STREAM s_1 TO VALUE(tt-param.arquivo) APPEND
                              PAGED PAGE-SIZE VALUE(65) CONVERT TARGET 'iso8859-1'.
        
                RUN pi-integra.
            END.
        END.
    END.

    IF CAN-FIND(FIRST tt-contas NO-LOCK WHERE tt-contas.erro <> "") THEN DO:
        MESSAGE "Existe equipamentos com Conta e/ou Centro Custo errado(s). Processo cancelado!"
            VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        ASSIGN l-erro = YES.
    END.
    ELSE DO:
        IF tt-param.execucao = 1 THEN DO:
            IF NOT l-erro THEN 
                MESSAGE "Simulaá∆o conclu°da com sucesso!" VIEW-AS ALERT-BOX INFO BUTTONS OK.
        END.
        ELSE DO:
            IF de-saldo-transitoria <> de-valor-contabil THEN DO:
                MESSAGE "Valor Contalizar diferente de Saldo Transit¢ria. Processo de Integraá∆o Abortado!" SKIP
                        "Diferenáa: " TRIM(STRING(de-saldo-transitoria,"->>>,>>>,>>9.99")) " - " 
                                      TRIM(STRING(de-valor-contabil,"->>>,>>>,>>9.99"))    " = "  
                                      TRIM(STRING(de-saldo-transitoria - de-valor-contabil,"->>>,>>>,>>9.99"))
                         VIEW-AS ALERT-BOX ERROR BUTTONS OK.
            END.
            ELSE DO:
                IF NOT CAN-FIND(FIRST tt_integr_ctbl_valid_1) THEN
                    MESSAGE "Integraá∆o conclu°da com sucesso!"
                        VIEW-AS ALERT-BOX INFO BUTTONS OK.
                ELSE 
                    MESSAGE "Ocorreu algum erro durante a Integraá∆o. Processo cancelado!"
                        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
            END.
        END.
    END.

    RUN pi-finalizar in h-acomp.

    RETURN "OK".
END.

PROCEDURE pi-carrega-dados:
    RUN pi-inicializar in h-acomp (input "Carregando Faturas...").

    FOR EACH fatura-equipamentos NO-LOCK
       WHERE fatura-equipamentos.mes-ref = tt-param.periodo:
        RUN pi-acompanhar IN h-acomp (INPUT "Fatura: " + STRING(fatura-equipamentos.nr-fatura)).
        CREATE tt-faturas.
        BUFFER-COPY fatura-equipamentos TO tt-faturas.
        ASSIGN tt-faturas.r-rowid = ROWID(fatura-equipamentos).

        FIND FIRST fornec-equipamentos NO-LOCK
             WHERE fornec-equipamentos.fornecedor = tt-faturas.fornecedor NO-ERROR.
        ASSIGN tt-faturas.nome-fornec = STRING(tt-faturas.fornecedor) + "-" + IF AVAIL fornec-equipamentos THEN fornec-equipamentos.nome ELSE "Inv†lido".

        FIND FIRST equipamentos NO-LOCK
             WHERE equipamentos.cod-estabel = fatura-equipamentos.cod-estabel
               AND equipamentos.equipamento = fatura-equipamentos.equipamento NO-ERROR.
        IF AVAIL equipamentos THEN
            ASSIGN tt-faturas.ct-codigo = equipamentos.ct-codigo.
        ELSE
            ASSIGN tt-faturas.ct-codigo = "NaoCadast".
    END.
END PROCEDURE.

PROCEDURE pi-validar:

    RUN pi-inicializar in h-acomp (input "Validando Informaá‰es...").

    FOR EACH tt-faturas NO-LOCK
        BREAK BY tt-faturas.cod-estabel
              BY tt-faturas.equipamento:

        IF FIRST-OF(tt-faturas.cod-estabel) OR
           FIRST-OF(tt-faturas.equipamento) THEN DO:

            FIND FIRST equipamentos NO-LOCK
                 WHERE equipamentos.cod-estabel = tt-faturas.cod-estabel
                   AND equipamentos.equipamento = tt-faturas.equipamento NO-ERROR.
            IF NOT AVAIL equipamentos THEN DO:
                RUN pi-cria-contas (INPUT tt-faturas.cod-estabel,
                                    INPUT tt-faturas.cod-estabel,
                                    INPUT tt-faturas.equipamento,
                                    INPUT "",
                                    INPUT "",
                                    INPUT "",
                                    INPUT "",
                                    INPUT 100,
                                    INPUT "Equipamento n∆o cadastrado.").
            END.
            ELSE DO:
                FIND FIRST cta_ctbl NO-LOCK
                     WHERE cta_ctbl.cod_plano_cta_ctbl = "Padrao"
                       AND cta_ctbl.cod_cta_ctbl       = equipamentos.ct-codigo NO-ERROR.
                IF NOT AVAIL cta_ctbl OR equipamentos.ct-codigo = "" THEN DO:
                    IF equipamentos.ct-codigo = "" THEN
                        RUN pi-cria-contas (INPUT tt-faturas.cod-estabel,
                                            INPUT tt-faturas.cod-estabel,
                                            INPUT tt-faturas.equipamento,
                                            INPUT equipamentos.ct-codigo,
                                            INPUT "",
                                            INPUT "",
                                            INPUT "",
                                            INPUT 100,
                                            INPUT "Equipamento sem Conta cadastrada.").
                    ELSE RUN pi-cria-contas (INPUT tt-faturas.cod-estabel,
                                             INPUT tt-faturas.cod-estabel,
                                             INPUT tt-faturas.equipamento,
                                             INPUT equipamentos.ct-codigo,
                                             INPUT "",
                                             INPUT "",
                                             INPUT "",
                                             INPUT 100,
                                             INPUT "Conta do Equipamento invalida.").

                END.
                ELSE DO:
                    IF equipamentos.ct-codigo = "11930045" THEN DO:
                        /*Conta Transit¢ria = Conta Equipamento (Equipamento entra no Rateio)*/
                        RUN pi-cria-contas (INPUT tt-faturas.cod-estabel,
                                            INPUT tt-faturas.cod-estabel,
                                            INPUT tt-faturas.equipamento,
                                            INPUT equipamentos.ct-codigo,
                                            INPUT "",
                                            INPUT "",
                                            INPUT "Rateio",
                                            INPUT 100,
                                            INPUT "").
                    END.
                    ELSE IF equipamentos.ct-codigo = "11810005" THEN DO:
                        /*Conta transitoria Nova)*/
                        RUN pi-cria-contas (INPUT tt-faturas.cod-estabel,
                                            INPUT tt-faturas.cod-estabel,
                                            INPUT tt-faturas.equipamento,
                                            INPUT equipamentos.ct-codigo,
                                            INPUT "",
                                            INPUT "",
                                            INPUT "Transitoria Nova",
                                            INPUT 100,
                                            INPUT "").
                    END.
                    ELSE IF equipamento.ct-codigo = "11830005" THEN DO:
                        /*Conta transitoria Manaus)*/
                        RUN pi-cria-contas (INPUT tt-faturas.cod-estabel,
                                            INPUT tt-faturas.cod-estabel,
                                            INPUT tt-faturas.equipamento,
                                            INPUT equipamentos.ct-codigo,
                                            INPUT "",
                                            INPUT "",
                                            INPUT "Transitoria Manaus",
                                            INPUT 100,
                                            INPUT "").
                    END.
                    ELSE DO:
                        IF NOT CAN-FIND(FIRST cc-equipamentos NO-LOCK
                                        WHERE cc-equipamentos.cod-estabel = tt-faturas.cod-estabel
                                          AND cc-equipamentos.equipamento = tt-faturas.equipamento) THEN DO:
                            RUN pi-cria-contas (INPUT tt-faturas.cod-estabel,
                                                INPUT tt-faturas.cod-estabel,
                                                INPUT tt-faturas.equipamento,
                                                INPUT equipamentos.ct-codigo,
                                                INPUT "",
                                                INPUT "",
                                                INPUT "",
                                                INPUT 100,
                                                INPUT "Equipamento sem Centro Custo cadastrado.").
                        END.
                        ELSE DO:
                            FOR EACH cc-equipamentos NO-LOCK
                               WHERE cc-equipamentos.cod-estabel = tt-faturas.cod-estabel
                                 AND cc-equipamentos.equipamento = tt-faturas.equipamento:
                                FIND FIRST unid_negoc NO-LOCK
                                     WHERE unid_negoc.cod_unid_negoc = cc-equipamentos.cod-unid-negoc NO-ERROR.
                                IF NOT AVAIL unid_negoc THEN DO:
                                    /*Valida unidade negocio do centro de custo*/
                                    RUN pi-cria-contas (INPUT tt-faturas.cod-estabel,
                                                        INPUT cc-equipamentos.cod-estabel-rateio,
                                                        INPUT tt-faturas.equipamento,
                                                        INPUT equipamentos.ct-codigo,
                                                        INPUT cc-equipamentos.cc-codigo,
                                                        INPUT cc-equipamentos.cod-unid-negoc,
                                                        INPUT "",
                                                        INPUT cc-equipamentos.per-rateio,
                                                        INPUT "Unidade Negocio: " + cc-equipamentos.cod-unid-negoc + " invalida.").
                                END.
                                ELSE DO:
                                    FIND FIRST emscad.ccusto NO-LOCK
                                         WHERE emscad.ccusto.cod_plano_ccusto = "Padrao"
                                           AND emscad.ccusto.cod_ccusto       = cc-equipamentos.cc-codigo NO-ERROR.
                                    IF NOT AVAIL emscad.ccusto THEN DO:
                                        /*Valida Centro de custo*/
                                        RUN pi-cria-contas (INPUT tt-faturas.cod-estabel,
                                                            INPUT cc-equipamentos.cod-estabel-rateio,
                                                            INPUT tt-faturas.equipamento,
                                                            INPUT equipamentos.ct-codigo,
                                                            INPUT cc-equipamentos.cc-codigo,
                                                            INPUT cc-equipamentos.cod-unid-negoc,
                                                            INPUT "",
                                                            INPUT cc-equipamentos.per-rateio,
                                                            INPUT "Centro Custo: " + cc-equipamentos.cc-codigo + " do Equipamento invalido.").
                                    END.
                                    ELSE DO:
                                        RUN pi-valida-cc-uni-estab (INPUT cc-equipamentos.cod-estabel-rateio).

                                        IF RETURN-VALUE <> "OK" THEN DO:
                                            /*Valida restricoes Centro de custo no estab 101*/
                                            RUN pi-cria-contas (INPUT tt-faturas.cod-estabel,
                                                                INPUT cc-equipamentos.cod-estabel-rateio,
                                                                INPUT tt-faturas.equipamento,
                                                                INPUT equipamentos.ct-codigo,
                                                                INPUT cc-equipamentos.cc-codigo,
                                                                INPUT cc-equipamentos.cod-unid-negoc,
                                                                INPUT "",
                                                                INPUT cc-equipamentos.per-rateio,
                                                                INPUT RETURN-VALUE).
                                        END.
                                        ELSE DO:
                                            find FIRST ccusto_unid_negoc no-lock
                                                 where ccusto_unid_negoc.cod_empresa      = ccusto.cod_empresa
                                                   and ccusto_unid_negoc.cod_plano_ccusto = ccusto.cod_plano_ccusto
                                                   and ccusto_unid_negoc.cod_ccusto       = ccusto.cod_ccusto
                                                   and ccusto_unid_negoc.cod_unid_negoc   = unid_negoc.cod_unid_negoc no-error.
                                            if  not avail ccusto_unid_negoc THEN DO:
                                                /*Valida Centro de custo na unidade*/
                                                RUN pi-cria-contas (INPUT tt-faturas.cod-estabel,
                                                                    INPUT cc-equipamentos.cod-estabel-rateio,
                                                                    INPUT tt-faturas.equipamento,
                                                                    INPUT equipamentos.ct-codigo,
                                                                    INPUT cc-equipamentos.cc-codigo,
                                                                    INPUT cc-equipamentos.cod-unid-negoc,
                                                                    INPUT "",
                                                                    INPUT cc-equipamentos.per-rateio,
                                                                    INPUT "Centro Custo: " + cc-equipamentos.cc-codigo + " nao pode ser utilizado na unidade: " + cc-equipamentos.cod-unid-negoc + ".").
                                            END.
                                            ELSE DO:
                                                find FIRST restric_ccusto no-lock
                                                     where restric_ccusto.cod_empresa      = ccusto.cod_empresa      
                                                       and restric_ccusto.cod_plano_ccusto = ccusto.cod_plano_ccusto 
                                                       and restric_ccusto.cod_ccusto       = ccusto.cod_ccusto       
                                                       and restric_ccusto.cod_estab        = cc-equipamentos.cod-estabel-rateio /*tt-faturas.cod-estabel*/ no-error.
                                                IF AVAIL restric_ccusto THEN DO:
                                                    /*Valida restricoes Centro de custo no estab 101*/
                                                    RUN pi-cria-contas (INPUT tt-faturas.cod-estabel,
                                                                        INPUT cc-equipamentos.cod-estabel-rateio,
                                                                        INPUT tt-faturas.equipamento,
                                                                        INPUT equipamentos.ct-codigo,
                                                                        INPUT cc-equipamentos.cc-codigo,
                                                                        INPUT cc-equipamentos.cod-unid-negoc,
                                                                        INPUT "",
                                                                        INPUT cc-equipamentos.per-rateio,
                                                                        INPUT "Existe restricao do Centro Custo: " + cc-equipamentos.cc-codigo + " para estabelecimento " + tt-faturas.cod-estabel).
                                                END.
                                                ELSE DO:
                                                    /*Registro sem nenhum erro ou restricao*/
                                                    RUN pi-cria-contas (INPUT tt-faturas.cod-estabel,
                                                                        INPUT cc-equipamentos.cod-estabel-rateio,
                                                                        INPUT tt-faturas.equipamento,
                                                                        INPUT equipamentos.ct-codigo,
                                                                        INPUT cc-equipamentos.cc-codigo,
                                                                        INPUT cc-equipamentos.cod-unid-negoc,
                                                                        INPUT emscad.ccusto.des_tit_ctbl,
                                                                        INPUT cc-equipamentos.per-rateio,
                                                                        INPUT "").
                                                END.
                                            END.
                                        END.
                                    END.
                                END.
                            END.
                        END.
                    END.
                END.
            END.
        END.
    END.
END PROCEDURE.

PROCEDURE pi-cria-contas:
    DEFINE INPUT PARAMETER p-cod-estabel        AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-estabel-rateio AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER p-equipamento        AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER p-ct-codigo          AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER p-cc-codigo          AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-unid           AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER p-descricao          AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER p-per-rateio         AS DECIMAL   NO-UNDO.
    DEFINE INPUT PARAMETER p-erro               AS CHARACTER NO-UNDO.

    CREATE tt-contas.
    ASSIGN tt-contas.cod-estabel        = p-cod-estabel
           tt-contas.cod-estabel-rateio = p-cod-estabel-rateio
           tt-contas.equipamento        = p-equipamento
           tt-contas.ct-codigo          = p-ct-codigo
           tt-contas.cc-codigo          = p-cc-codigo
           tt-contas.cod-unid-negoc     = p-cod-unid
           tt-contas.descricao          = p-descricao
           tt-contas.per-rateio         = p-per-rateio / 100
           tt-contas.erro               = p-erro.

END PROCEDURE.

PROCEDURE pi-gera-rateio:
    DEFINE VARIABLE de-valor-fatura AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE de-valor-rateio AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE i-quant         AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-cont          AS INTEGER     NO-UNDO.
    DEFINE VARIABLE l-rateio        AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE i-cont-rateio   AS INTEGER     NO-UNDO.

    ASSIGN de-valor-fatura  = 0
           de-valor-rateado = 0
           de-valor-outros  = 0
           de-valor-liquido = 0.

    RUN pi-inicializar in h-acomp (input "Buscando Rateios...").

    FOR EACH tt-faturas
        BREAK BY tt-faturas.cod-estabel
              BY tt-faturas.equipamento:
        ASSIGN de-valor-fatura = de-valor-fatura + tt-faturas.val-fatura.

        IF LAST-OF(tt-faturas.cod-estabel) OR
           LAST-OF(tt-faturas.equipamento) THEN DO:
            ASSIGN i-quant = 0
                   i-cont  = 0.
            FOR EACH tt-contas 
               WHERE tt-contas.cod-estabel = tt-faturas.cod-estabel
                 AND tt-contas.equipamento = tt-faturas.equipamento:
                ASSIGN i-quant = i-quant + 1.
            END.                   

            IF i-quant = 1 THEN DO:
                FOR EACH tt-contas 
                   WHERE tt-contas.cod-estabel = tt-faturas.cod-estabel
                     AND tt-contas.equipamento = tt-faturas.equipamento:

                    CREATE tt-rateios.
                    ASSIGN tt-rateios.cod-estabel    = tt-contas.cod-estabel-rateio
                           tt-rateios.equipamento    = tt-faturas.equipamento
                           tt-rateios.mes-ref        = tt-param.periodo
                           tt-rateios.ct-codigo      = tt-contas.ct-codigo
                           tt-rateios.cc-codigo      = tt-contas.cc-codigo
                           tt-rateios.cod-unid-negoc = tt-contas.cod-unid-negoc
                           tt-rateios.val-rateio     = de-valor-fatura.

                    /*Conta Transitoria - Rateia para outros centro de custos*/
                    IF tt-rateios.ct-codigo = "11930045" THEN
                        ASSIGN de-valor-rateado = de-valor-rateado + tt-rateios.val-rateio.
                    ELSE DO:
                        IF tt-rateios.cod-estabel     = "101"      AND 
                           tt-rateios.ct-codigo       = "41530005" AND 
                           tt-rateios.cc-codigo      <> "11500"    AND 
                           tt-rateios.cod-unid-negoc <> "ADM"
                        THEN DO:
                            ASSIGN de-valor-liquido = de-valor-liquido + tt-rateios.val-rateio.
                        END.
                        ELSE
                            ASSIGN de-valor-outros = de-valor-outros + tt-rateios.val-rateio.
                    END.
                END.
            END.
            ELSE DO:
                ASSIGN de-valor-rateio = 0.
                FOR EACH tt-contas 
                   WHERE tt-contas.cod-estabel = tt-faturas.cod-estabel
                     AND tt-contas.equipamento = tt-faturas.equipamento:

                    ASSIGN i-cont = i-cont + 1.
                    CREATE tt-rateios.
                    ASSIGN tt-rateios.cod-estabel    = tt-contas.cod-estabel-rateio
                           tt-rateios.equipamento    = tt-faturas.equipamento
                           tt-rateios.mes-ref        = tt-param.periodo
                           tt-rateios.ct-codigo      = tt-contas.ct-codigo
                           tt-rateios.cc-codigo      = tt-contas.cc-codigo
                           tt-rateios.cod-unid-negoc = tt-contas.cod-unid-negoc
                           tt-rateios.val-rateio     = round(de-valor-fatura * tt-contas.per-rateio,2)
                           de-valor-rateio           = de-valor-rateio + tt-rateios.val-rateio.
                    IF i-cont = i-quant THEN
                        IF de-valor-fatura <> de-valor-rateio THEN DO:
                            ASSIGN tt-rateios.val-rateio = IF de-valor-rateio > de-valor-fatura 
                                                           THEN tt-rateios.val-rateio - (de-valor-rateio - de-valor-fatura)
                                                           ELSE tt-rateios.val-rateio + (de-valor-fatura - de-valor-rateio).
                        END.

                    /*Conta Transitoria - Rateia para outros centro de custos*/
                    IF tt-rateios.ct-codigo = "11930045" THEN
                        ASSIGN de-valor-rateado = de-valor-rateado + tt-rateios.val-rateio.
                    ELSE DO:
                        IF tt-rateios.cod-estabel     = "101"      AND 
                           tt-rateios.ct-codigo       = "41530005" AND 
                           tt-rateios.cc-codigo      <> "11500"    AND
                           tt-rateios.cod-unid-negoc <> "ADM"
                        THEN DO:
                            ASSIGN de-valor-liquido = de-valor-liquido + tt-rateios.val-rateio.
                        END.
                        ELSE
                            ASSIGN de-valor-outros = de-valor-outros + tt-rateios.val-rateio.
                    END.
                END.
            END.
            ASSIGN de-valor-fatura = 0
                   de-valor-rateio = 0.
        END.
    END.

    RUN pi-inicializar in h-acomp (input "Calculando Rateios...").


    ASSIGN l-rateio = CAN-FIND(FIRST tt-rateios WHERE tt-rateios.ct-codigo = "11930045" NO-LOCK).


    ASSIGN de-valor-fatura = 0
           i-cont-rateio   = 0
           i-cont          = 0.
    FOR EACH tt-rateios NO-LOCK
       WHERE tt-rateios.cod-estabel     = "101" 
         AND tt-rateios.ct-codigo       = "41530005"
         AND tt-rateios.cc-codigo      <> "11500"
         AND tt-rateios.cod-unid-negoc <> "ADM"
        BREAK BY tt-rateios.cod-estabel
              BY tt-rateios.ct-codigo  
              BY tt-rateios.cc-codigo:

        IF LAST-OF(tt-rateios.cod-estabel) OR
           LAST-OF(tt-rateios.ct-codigo)   OR
           LAST-OF(tt-rateios.cc-codigo) THEN 
            ASSIGN i-cont-rateio = i-cont-rateio + 1.
    END.

    FOR EACH tt-rateios NO-LOCK
       WHERE tt-rateios.ct-codigo <> "11930045"
        BREAK BY tt-rateios.cod-estabel
              BY tt-rateios.ct-codigo  
              BY tt-rateios.cc-codigo:

        ASSIGN de-valor-rateio = de-valor-rateio + tt-rateios.val-rateio.

        CREATE tt-rateios3.
        BUFFER-COPY tt-rateios TO tt-rateios3.

        IF LAST-OF(tt-rateios.cod-estabel) OR
           LAST-OF(tt-rateios.ct-codigo)   OR
           LAST-OF(tt-rateios.cc-codigo) THEN DO:

            IF l-rateio AND 
               tt-rateios.cod-estabel     = "101"      AND 
               tt-rateios.ct-codigo       = "41530005" AND 
               tt-rateios.cc-codigo      <> "11500"    AND 
               tt-rateios.cod-unid-negoc <> "ADM"
            THEN DO:
                CREATE tt-perc-valor.
                ASSIGN tt-perc-valor.cod-estabel    = tt-rateios.cod-estabel 
                       tt-perc-valor.ct-codigo      = tt-rateios.ct-codigo   
                       tt-perc-valor.cc-codigo      = tt-rateios.cc-codigo
                       tt-perc-valor.cod-unid-negoc = tt-rateios.cod-unid-negoc
                       tt-perc-valor.perc           = de-valor-rateio / de-valor-liquido
                       tt-perc-valor.val-valor      = de-valor-rateio
                       tt-perc-valor.val-rateio     = ROUND(de-valor-rateado * tt-perc-valor.perc,2)
                       tt-perc-valor.val-total      = /*IF de-valor-rateado < 0 THEN*/ tt-perc-valor.val-valor + tt-perc-valor.val-rateio
                                                      /*ELSE ROUND((de-valor-rateado + de-valor-liquido) * tt-perc-valor.perc,2)*/ .

                ASSIGN de-valor-fatura = de-valor-fatura + tt-perc-valor.val-rateio 
                       i-cont          = i-cont + 1.

                IF i-cont-rateio  = i-cont AND (de-valor-fatura <> de-valor-rateado)  THEN DO:
                    /*Faz acerto caso valor rateado diferente do total*/
                    IF de-valor-fatura > de-valor-rateado THEN
                        ASSIGN tt-perc-valor.val-valor   = tt-perc-valor.val-valor  - (de-valor-fatura - de-valor-rateado)
                               tt-perc-valor.val-total   = tt-perc-valor.val-total  - (de-valor-fatura - de-valor-rateado)
                               tt-perc-valor.val-rateio  = tt-perc-valor.val-rateio - (de-valor-fatura - de-valor-rateado).
                    ELSE 
                        ASSIGN tt-perc-valor.val-valor   = tt-perc-valor.val-valor  + (de-valor-rateado - de-valor-fatura) 
                               tt-perc-valor.val-total   = tt-perc-valor.val-total  + (de-valor-rateado - de-valor-fatura)
                               tt-perc-valor.val-rateio  = tt-perc-valor.val-rateio + (de-valor-rateado - de-valor-fatura).
                END.
                                                       
                CREATE tt-rateios2.
                ASSIGN tt-rateios2.cod-estabel    = tt-rateios.cod-estabel
                       tt-rateios2.mes-ref        = tt-param.periodo
                       tt-rateios2.ct-codigo      = tt-rateios.ct-codigo  
                       tt-rateios2.cc-codigo      = tt-rateios.cc-codigo  
                       tt-rateios2.cod-unid-negoc = tt-rateios.cod-unid-negoc
                       tt-rateios2.val-rateio     = tt-perc-valor.val-total.

                CREATE tt-rateios3.
                ASSIGN tt-rateios3.equipamento = "Rateio"
                       tt-rateios3.val-rateio  = tt-perc-valor.val-rateio.
                BUFFER-COPY tt-rateios EXCEPT equipamento val-rateio TO  tt-rateios3.
            END.
            ELSE DO:
                CREATE tt-rateios2.
                ASSIGN tt-rateios2.cod-estabel    = tt-rateios.cod-estabel
                       tt-rateios.mes-ref         = tt-param.periodo
                       tt-rateios2.ct-codigo      = tt-rateios.ct-codigo  
                       tt-rateios2.cc-codigo      = tt-rateios.cc-codigo  
                       tt-rateios2.cod-unid-negoc = tt-rateios.cod-unid-negoc
                       tt-rateios2.val-rateio     = de-valor-rateio.
            END.
            ASSIGN de-valor-rateio = 0.
        END.
    END.

END PROCEDURE.

PROCEDURE pi-integra:

    DEFINE VARIABLE i-seq          AS INTEGER     NO-UNDO.
    DEFINE VARIABLE de-valor-total AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE c-plano-conta  AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-plano-custo  AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-centro-custo AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE dt-contabil    AS DATE    NO-UNDO.

    RUN pi-inicializar in h-acomp (input "Gerando Dados Integraá∆o...").

    ASSIGN de-valor-total = 0
           i-seq          = 0
           dt-contabil    = dt-saldo.


    FOR EACH tt_integr_lote_ctbl_1:
        DELETE tt_integr_lote_ctbl_1.
    END.
    FOR EACH tt_integr_lancto_ctbl_1:
        DELETE tt_integr_lancto_ctbl_1.
    END.
    FOR EACH tt_integr_item_lancto_ctbl_1:
        DELETE tt_integr_item_lancto_ctbl_1.
    END.
    FOR EACH tt_integr_aprop_lancto_ctbl_1:
        DELETE tt_integr_aprop_lancto_ctbl_1.
    END.
    FOR EACH tt_integr_ctbl_valid_1:
        DELETE tt_integr_ctbl_valid_1.
    END.

    CREATE tt_integr_lote_ctbl_1.
    ASSIGN tt_integr_lote_ctbl_1.tta_cod_modul_dtsul      = "FGL"
           tt_integr_lote_ctbl_1.tta_num_lote_ctbl        = 0
           tt_integr_lote_ctbl_1.tta_des_lote_ctbl        = "Contabilizaá∆o Comunicaá‰es"
           tt_integr_lote_ctbl_1.tta_cod_empresa          = "1"
           tt_integr_lote_ctbl_1.tta_dat_lote_ctbl        = dt-contabil
           tt_integr_lote_ctbl_1.ttv_rec_integr_lote_ctbl = RECID(tt_integr_lote_ctbl_1).

    CREATE tt_integr_lancto_ctbl_1.
    ASSIGN tt_integr_lancto_ctbl_1.tta_cod_cenar_ctbl         = ""
           tt_integr_lancto_ctbl_1.ttv_rec_integr_lote_ctbl   = tt_integr_lote_ctbl_1.ttv_rec_integr_lote_ctbl
           tt_integr_lancto_ctbl_1.tta_num_lancto_ctbl        = 1
           tt_integr_lancto_ctbl_1.tta_dat_lancto_ctbl        = tt_integr_lote_ctbl_1.tta_dat_lote_ctbl
           tt_integr_lancto_ctbl_1.ttv_rec_integr_lancto_ctbl = RECID(tt_integr_lancto_ctbl_1).

    FOR EACH tt-rateios2:

        ASSIGN de-valor-total = de-valor-total + tt-rateios2.val-rateio
               i-seq          = i-seq + 1.

        IF tt-rateios2.ct-codigo = "11810005" OR tt-rateios2.ct-codigo = "11830005" THEN /*transitoria nova ou manaus*/
            ASSIGN c-plano-conta  = "Padrao"
                   c-plano-custo  = ""
                   c-centro-custo = "".
        ELSE 
            ASSIGN c-plano-conta  = "Padrao"
                   c-plano-custo  = "Padrao"
                   c-centro-custo = tt-rateios2.cc-codigo.

        CREATE tt_integr_item_lancto_ctbl_1.
        ASSIGN tt_integr_item_lancto_ctbl_1.ttv_rec_integr_lancto_ctbl      = tt_integr_lancto_ctbl_1.ttv_rec_integr_lancto_ctbl
               tt_integr_item_lancto_ctbl_1.tta_num_seq_lancto_ctbl         = i-seq
               tt_integr_item_lancto_ctbl_1.tta_ind_natur_lancto_ctbl       = "DB"
               tt_integr_item_lancto_ctbl_1.tta_cod_plano_cta_ctbl          = c-plano-conta
               tt_integr_item_lancto_ctbl_1.tta_cod_cta_ctbl                = tt-rateios2.ct-codigo
               tt_integr_item_lancto_ctbl_1.tta_cod_plano_ccusto            = c-plano-custo
               tt_integr_item_lancto_ctbl_1.tta_cod_estab                   = tt-rateios2.cod-estabel /*101 ver contabilidade*/
               tt_integr_item_lancto_ctbl_1.tta_cod_unid_negoc              = tt-rateios2.cod-unid-negoc
               tt_integr_item_lancto_ctbl_1.tta_des_histor_lancto_ctbl      = "Contabilizaá∆o Comunicaá‰es"
               tt_integr_item_lancto_ctbl_1.tta_cod_indic_econ              = "Real"
               tt_integr_item_lancto_ctbl_1.tta_dat_lancto_ctbl             = tt_integr_lote_ctbl_1.tta_dat_lote_ctbl
               tt_integr_item_lancto_ctbl_1.tta_val_lancto_ctbl             = tt-rateios2.val-rateio
               tt_integr_item_lancto_ctbl_1.tta_cod_ccusto                  = c-centro-custo
               tt_integr_item_lancto_ctbl_1.tta_cod_proj_financ             = ""
               tt_integr_item_lancto_ctbl_1.ttv_rec_integr_item_lancto_ctbl = RECID(tt_integr_item_lancto_ctbl_1).

        CREATE tt_integr_aprop_lancto_ctbl_1.
        ASSIGN tt_integr_aprop_lancto_ctbl_1.tta_cod_finalid_econ             = "corrente"
               tt_integr_aprop_lancto_ctbl_1.tta_cod_unid_negoc               = tt_integr_item_lancto_ctbl_1.tta_cod_unid_negoc
               tt_integr_aprop_lancto_ctbl_1.tta_cod_plano_ccusto             = tt_integr_item_lancto_ctbl_1.tta_cod_plano_ccusto
               tt_integr_aprop_lancto_ctbl_1.tta_val_lancto_ctbl              = tt_integr_item_lancto_ctbl_1.tta_val_lancto_ctbl
               tt_integr_aprop_lancto_ctbl_1.ttv_rec_integr_item_lancto_ctbl  = tt_integr_item_lancto_ctbl_1.ttv_rec_integr_item_lancto_ctbl
               tt_integr_aprop_lancto_ctbl_1.tta_cod_ccusto                   = tt_integr_item_lancto_ctbl_1.tta_cod_ccusto
               tt_integr_aprop_lancto_ctbl_1.ttv_rec_integr_aprop_lancto_ctbl = RECID(tt_integr_aprop_lancto_ctbl_1).
    END.

    ASSIGN i-seq = i-seq + 1.

    CREATE tt_integr_item_lancto_ctbl_1.
    ASSIGN tt_integr_item_lancto_ctbl_1.ttv_rec_integr_lancto_ctbl      = tt_integr_lancto_ctbl_1.ttv_rec_integr_lancto_ctbl
           tt_integr_item_lancto_ctbl_1.tta_num_seq_lancto_ctbl         = i-seq
           tt_integr_item_lancto_ctbl_1.tta_ind_natur_lancto_ctbl       = "CR"
           tt_integr_item_lancto_ctbl_1.tta_cod_plano_cta_ctbl          = "Padrao"
           tt_integr_item_lancto_ctbl_1.tta_cod_cta_ctbl                = "11930045"
           tt_integr_item_lancto_ctbl_1.tta_cod_plano_ccusto            = ""
           tt_integr_item_lancto_ctbl_1.tta_cod_estab                   = "101"
           tt_integr_item_lancto_ctbl_1.tta_cod_unid_negoc              = "ADM"
           tt_integr_item_lancto_ctbl_1.tta_des_histor_lancto_ctbl      = "Contabilizaá∆o Comunicaá‰es"
           tt_integr_item_lancto_ctbl_1.tta_cod_indic_econ              = "Real"
           tt_integr_item_lancto_ctbl_1.tta_dat_lancto_ctbl             = tt_integr_lote_ctbl_1.tta_dat_lote_ctbl
           tt_integr_item_lancto_ctbl_1.tta_val_lancto_ctbl             = de-valor-total
           tt_integr_item_lancto_ctbl_1.tta_cod_ccusto                  = ""
           tt_integr_item_lancto_ctbl_1.tta_cod_proj_financ             = ""
           tt_integr_item_lancto_ctbl_1.ttv_rec_integr_item_lancto_ctbl = RECID(tt_integr_item_lancto_ctbl_1).

    CREATE tt_integr_aprop_lancto_ctbl_1.
    ASSIGN tt_integr_aprop_lancto_ctbl_1.tta_cod_finalid_econ             = "corrente"
           tt_integr_aprop_lancto_ctbl_1.tta_cod_unid_negoc               = tt_integr_item_lancto_ctbl_1.tta_cod_unid_negoc
           tt_integr_aprop_lancto_ctbl_1.tta_cod_plano_ccusto             = tt_integr_item_lancto_ctbl_1.tta_cod_plano_ccusto
           tt_integr_aprop_lancto_ctbl_1.tta_val_lancto_ctbl              = de-valor-total
           tt_integr_aprop_lancto_ctbl_1.ttv_rec_integr_item_lancto_ctbl  = tt_integr_item_lancto_ctbl_1.ttv_rec_integr_item_lancto_ctbl
           tt_integr_aprop_lancto_ctbl_1.tta_cod_ccusto                   = ""
           tt_integr_aprop_lancto_ctbl_1.ttv_rec_integr_aprop_lancto_ctbl = RECID(tt_integr_aprop_lancto_ctbl_1).

    RUN pi-inicializar in h-acomp (input "Integrando Contabilidade...").
    run prgfin/fgl/fgl900zl.py (Input 3,
                                Input "Aborta Tudo",
                                Input yes,
                                Input 66,
                                Input "Apropriaá∆o",
                                Input "Todos",
                                Input yes,
                                Input yes,
                                input-output table tt_integr_lote_ctbl_1,
                                input-output table tt_integr_lancto_ctbl_1,
                                input-output table tt_integr_item_lancto_ctbl_1,
                                input-output table tt_integr_aprop_lancto_ctbl_1,
                                input-output table tt_integr_ctbl_valid_1).


    FIND FIRST tt_integr_lote_ctbl_1 NO-ERROR.

    /*Verifica se gerou o lote*/
    FIND FIRST lote_ctbl NO-LOCK
         WHERE lote_ctbl.num_lote_ctbl = tt_integr_lote_ctbl_1.tta_num_lote_ctbl NO-ERROR.

    IF  AVAIL tt_integr_lote_ctbl_1
    AND tt_integr_lote_ctbl_1.tta_num_lote_ctbl <> 0
    AND AVAIL lote_ctbl THEN DO:

        FOR EACH tt-rateios3 NO-LOCK:
            CREATE rateio-equipamentos.
            ASSIGN rateio-equipamentos.tipo           = 0
                   rateio-equipamentos.cod-estabel    = tt-rateios3.cod-estabel
                   rateio-equipamentos.equipamento    = tt-rateios3.equipamento
                   rateio-equipamentos.mes-ref        = tt-rateios3.mes-ref
                   rateio-equipamentos.ct-codigo      = tt-rateios3.ct-codigo
                   rateio-equipamentos.cc-codigo      = tt-rateios3.cc-codigo
                   rateio-equipamentos.cod-unid-negoc = tt-rateios3.cod-unid-negoc
                   rateio-equipamentos.val-rateio     = tt-rateios3.val-rateio.
        END.

        CREATE integra-equipamentos.
        ASSIGN integra-equipamentos.tipo    = 0
               integra-equipamentos.mes-ref = tt-param.periodo
               integra-equipamentos.data    = dt-contabil
               integra-equipamentos.hora    = STRING(TIME,"HH:MM:SS")
               integra-equipamentos.usuario = c-seg-usuario.


        FOR EACH tt-perc-valor:
            CREATE cc-rateio-trans.
            ASSIGN cc-rateio-trans.cod-estabel  = tt-perc-valor.cod-estabe
                   cc-rateio-trans.mes-ref      = tt-param.periodo 
                   cc-rateio-trans.ct-codigo    = tt-perc-valor.ct-codigo 
                   cc-rateio-trans.cc-codigo    = tt-perc-valor.cc-codigo 
                   cc-rateio-trans.cod-unid-neg = tt-perc-valor.cod-unid-negoc
                   cc-rateio-trans.perc-rateio  = tt-perc-valor.perc
                   cc-rateio-trans.val-rateio   = tt-perc-valor.val-valor.
        END.

    END.

END PROCEDURE.

PROCEDURE pi-relatorio:
    DEFINE VARIABLE de-valor        AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE de-liquido      AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE de-rateio       AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE de-total        AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE i-quant         AS INTEGER     NO-UNDO.

    RUN pi-inicializar in h-acomp (input "Gerando Relatorio Acompanhamento...").

    IF CAN-FIND(FIRST tt-contas NO-LOCK 
                WHERE tt-contas.erro <> "") THEN DO:
        PUT UNFORMATTED 
             "CONTAS ERRADAS" SKIP(1)
             "Est Equipamento           Conta    C. Custo Erro" SKIP
             "--- --------------------- -------- -------- ----------------------------------------------------------------------------" SKIP.

        FOR EACH tt-contas NO-LOCK
           WHERE tt-contas.erro <> ""
           BREAK BY tt-contas.cod-estabel
                 BY tt-contas.equipamento
                 BY tt-contas.ct-codigo
                 BY tt-contas.cc-codigo:

            PUT UNFORMATTED 
                tt-contas.cod-estabel AT 01
                tt-contas.equipamento AT 05
                tt-contas.ct-codigo   AT 27
                tt-contas.cc-codigo   AT 36
                tt-contas.erro        AT 45 SKIP.
        END.
        PUT UNFORMATTED SKIP(1)
             FILL("-",150) SKIP.
    END.

    IF tt-param.l-equipamento AND 
       CAN-FIND(FIRST tt-contas NO-LOCK 
                WHERE tt-contas.erro = "") THEN DO:
        PUT UNFORMATTED 
             "CONTAS CORRETAS" SKIP(1)
             "Est Equipamento           Conta    C. Custo Descricao" SKIP
             "--- --------------------- -------- -------- ----------------------------------------" SKIP.
        FOR EACH tt-contas NO-LOCK
           WHERE tt-contas.erro = ""
           BREAK BY tt-contas.cod-estabel
                 BY tt-contas.equipamento
                 BY tt-contas.ct-codigo
                 BY tt-contas.cc-codigo:

            PUT UNFORMATTED 
                tt-contas.cod-estabel AT 01
                tt-contas.equipamento AT 05
                tt-contas.ct-codigo   AT 27
                tt-contas.cc-codigo   AT 36
                tt-contas.descricao   AT 45 SKIP.
        END.
        PUT UNFORMATTED SKIP(1)
             FILL("-",150) SKIP.
    END.

    IF tt-param.l-fatura AND 
       CAN-FIND(FIRST tt-faturas) THEN DO:

        IF tt-param.tipo = 1 THEN DO:
            PUT UNFORMATTED "VALORES FATURAS - DETALHADO" SKIP(1)
                "Fornecedor Nr Fatura            Equipamento           Est           Valor" SKIP
                "---------- -------------------- --------------------- --- ---------------" SKIP.
            ASSIGN i-quant   = 0
                   de-valor  = 0.
            FOR EACH tt-faturas
               BREAK BY tt-faturas.fornecedor
                     BY tt-faturas.nr-fatura
                     BY tt-faturas.equipamento
                     BY tt-faturas.cod-estabel:

                ACCUMULATE tt-faturas.val-fatura (TOTAL BY tt-faturas.fornecedor)
                           tt-faturas.val-fatura (TOTAL BY tt-faturas.nr-fatura).

                ASSIGN i-quant = i-quant + 1
                       de-valor = de-valor + tt-faturas.val-fatura.

                IF tt-param.tipo = 1 THEN
                    PUT UNFORMATTED 
                        tt-faturas.nome-fornec FORMAT "x(10)" /*tt-faturas.fornecedor*/ AT 01
                        tt-faturas.nr-fatura                             AT 12
                        tt-faturas.equipamento                           AT 33
                        tt-faturas.cod-estabel                           AT 55
                        STRING(tt-faturas.val-fatura,"->>>,>>>,>>9.99")  TO 73 SKIP.

                IF LAST-OF(tt-faturas.nr-fatura) THEN DO:
                    IF i-quant > 1 THEN
                        PUT UNFORMATTED
                            "Total Fatura" AT 33
                            STRING((ACCUM TOTAL BY tt-faturas.nr-fatura tt-faturas.val-fatura),"->>>,>>>,>>9.99")  TO 73 SKIP.
                    ASSIGN i-quant = 0.
                END.
                IF LAST-OF(tt-faturas.fornecedor) THEN DO:
                    PUT UNFORMATTED
                        "Total Fornecedor" AT 33
                        STRING((ACCUM TOTAL BY tt-faturas.fornecedor tt-faturas.val-fatura),"->>>,>>>,>>9.99")  TO 73 SKIP(1).
                    ASSIGN i-quant = 0.
                END.
            END.
            PUT UNFORMATTED 
                "Total Geral" AT 33
                STRING(de-valor,"->>>,>>>,>>9.99")  TO 73 SKIP
                SKIP(1)
                FILL("-",150) SKIP.

            PUT UNFORMATTED "VALORES FATURAS P/ CONTA CONTABIL- DETALHADO" SKIP(1)
                "Fornecedor Nr Fatura            Conta              Valor" SKIP
                "---------- -------------------- -------- ---------------" SKIP.
            ASSIGN i-quant   = 0
                   de-valor  = 0.
            FOR EACH tt-faturas
               BREAK BY tt-faturas.fornecedor
                     BY tt-faturas.nr-fatura
                     BY tt-faturas.ct-codigo:

                ACCUMULATE tt-faturas.val-fatura (TOTAL BY tt-faturas.fornecedor)
                           tt-faturas.val-fatura (TOTAL BY tt-faturas.nr-fatura)
                           tt-faturas.val-fatura (TOTAL BY tt-faturas.ct-codigo).

                ASSIGN i-quant = i-quant + 1 
                       de-valor = de-valor + tt-faturas.val-fatura.

                IF LAST-OF(tt-faturas.ct-codigo) THEN DO:
                    PUT UNFORMATTED 
                        tt-faturas.nome-fornec FORMAT "x(10)" /*tt-faturas.fornecedor*/  AT 01
                        tt-faturas.nr-fatura   AT 12
                        tt-faturas.ct-codigo   AT 33
                        STRING((ACCUM TOTAL BY tt-faturas.ct-codigo tt-faturas.val-fatura),"->>>,>>>,>>9.99")  TO 56 SKIP.
                END.
                IF LAST-OF(tt-faturas.nr-fatura) THEN DO:
                    IF i-quant > 1 THEN
                        PUT UNFORMATTED
                            "Total Fatura" AT 12
                            STRING((ACCUM TOTAL BY tt-faturas.nr-fatura tt-faturas.val-fatura),"->>>,>>>,>>9.99")  TO 56 SKIP.
                    ASSIGN i-quant = 0.
                END.
                IF LAST-OF(tt-faturas.fornecedor) THEN DO:
                    PUT UNFORMATTED
                        "Total Fornecedor" AT 12
                        STRING((ACCUM TOTAL BY tt-faturas.fornecedor tt-faturas.val-fatura),"->>>,>>>,>>9.99")  TO 56 SKIP(1).
                    ASSIGN i-quant = 0.
                END.
            END.
            PUT UNFORMATTED 
                "Total Geral" AT 12
                STRING(de-valor,"->>>,>>>,>>9.99")  TO 56 SKIP
                SKIP(1)
                FILL("-",150) SKIP.

        END.
        ELSE DO:
            PUT UNFORMATTED "VALORES FATURAS - RESUMIDO" SKIP(1)
                "Fornecedor Nr Fatura                      Valor" SKIP
                "---------- -------------------- ---------------" SKIP.

            ASSIGN de-valor  = 0.
            FOR EACH tt-faturas
               BREAK BY tt-faturas.fornecedor
                     BY tt-faturas.nr-fatura
                     BY tt-faturas.equipamento
                     BY tt-faturas.cod-estabel:

                ACCUMULATE tt-faturas.val-fatura (TOTAL BY tt-faturas.fornecedor)
                           tt-faturas.val-fatura (TOTAL BY tt-faturas.nr-fatura).

                ASSIGN de-valor = de-valor + tt-faturas.val-fatura.

                IF LAST-OF(tt-faturas.nr-fatura) THEN DO:
                    PUT UNFORMATTED 
                        tt-faturas.nome-fornec FORMAT "x(10)" /*tt-faturas.fornecedor*/                            AT 01
                        tt-faturas.nr-fatura                             AT 12
                        STRING((ACCUM TOTAL BY tt-faturas.nr-fatura tt-faturas.val-fatura),"->>>,>>>,>>9.99")  TO 47 SKIP.
                END.
                IF LAST-OF(tt-faturas.fornecedor) THEN DO:
                    PUT UNFORMATTED
                        "Total Fornecedor" AT 12
                        STRING((ACCUM TOTAL BY tt-faturas.fornecedor tt-faturas.val-fatura),"->>>,>>>,>>9.99")  TO 47 SKIP(1).
                    ASSIGN i-quant = 0.
                END.
            END.
            PUT UNFORMATTED 
                "Total Geral" AT 12
                STRING(de-valor,"->>>,>>>,>>9.99")  TO 47 SKIP
                SKIP(1)
                FILL("-",150) SKIP.
        END.
    END.

    IF CAN-FIND(FIRST tt-rateios) THEN DO:

        IF tt-param.tipo = 1 THEN
            PUT UNFORMATTED 
                 "VALORES P/ CENTRO CUSTO - DETALHADO" SKIP(1)
                 "Conta    C. Custo Equipamento           Est           Valor" SKIP
                 "-------- -------- --------------------- --- ---------------" SKIP.
        ELSE 
            PUT UNFORMATTED 
                 "VALORES P/ CENTRO CUSTO - RESUMIDO" SKIP(1)
                 "Conta    C. Custo           Valor" SKIP
                 "-------- -------- ---------------" SKIP.
        ASSIGN de-total = 0.
        FOR EACH tt-rateios
            BREAK BY tt-rateios.ct-codigo
                  BY tt-rateios.cc-codigo
                  BY tt-rateios.equipamento
                  BY tt-rateios.cod-estabel:

            ACCUMULATE tt-rateios.val-rateio (TOTAL BY tt-rateios.ct-codigo)
                       tt-rateios.val-rateio (TOTAL BY tt-rateios.cc-codigo).

            ASSIGN de-total = de-total + tt-rateios.val-rateio.

            IF tt-param.tipo = 1 THEN
                PUT UNFORMATTED 
                    tt-rateios.ct-codigo   AT 01
                    tt-rateios.cc-codigo   AT 10
                    tt-rateios.equipamento AT 19
                    tt-rateios.cod-estabel AT 41
                    STRING(tt-rateios.val-rateio,"->>>,>>>,>>9.99") TO 59 SKIP.

            IF LAST-OF(tt-rateios.cc-codigo) THEN DO:
                IF tt-param.tipo = 1 THEN
                    PUT UNFORMATTED
                        "Total Centro Custo" AT 19
                        STRING((ACCUM TOTAL BY tt-rateios.cc-codigo tt-rateios.val-rateio),"->>>,>>>,>>9.99")  TO 59 SKIP.
                ELSE
                    PUT UNFORMATTED 
                        tt-rateios.ct-codigo   AT 01
                        tt-rateios.cc-codigo   AT 10
                        STRING((ACCUM TOTAL BY tt-rateios.cc-codigo tt-rateios.val-rateio),"->>>,>>>,>>9.99") TO 33 SKIP.
            END.
            IF LAST-OF(tt-rateios.ct-codigo) THEN DO:
                IF tt-param.tipo = 1 THEN
                    PUT UNFORMATTED
                        "Total Conta" AT 19
                        STRING((ACCUM TOTAL BY tt-rateios.ct-codigo tt-rateios.val-rateio),"->>>,>>>,>>9.99")  TO 59 SKIP(1).
                ELSE
                    PUT UNFORMATTED 
                        "Total Conta" AT 01
                        STRING((ACCUM TOTAL BY tt-rateios.ct-codigo tt-rateios.val-rateio),"->>>,>>>,>>9.99") TO 33 SKIP(1).
            END.
        END.
        IF tt-param.tipo = 1 THEN
            PUT UNFORMATTED 
                "Total Geral" AT 19
                STRING(de-total,"->>>,>>>,>>9.99")  TO 59 SKIP
                SKIP(1)
                FILL("-",150) SKIP.
        ELSE
            PUT UNFORMATTED 
                "Total Geral" AT 01
                STRING(de-total,"->>>,>>>,>>9.99")  TO 33 SKIP
                SKIP(1)
                FILL("-",150) SKIP.
    END.

    IF tt-param.l-rateio AND
       CAN-FIND(FIRST tt-perc-valor) THEN DO:

        PUT UNFORMATTED "VALORES RATEADOS CENTRO CUSTO" SKIP(1)
            "Est Conta    C. Custo   Percentual   Valor Liquido    Valor Rateio     Valor Total" SKIP
            "--- -------- -------- ------------ --------------- --------------- ---------------" SKIP.

        ASSIGN de-liquido = 0
               de-rateio  = 0
               de-total   = 0.

        FOR EACH tt-perc-valor:
            PUT UNFORMATTED
                tt-perc-valor.cod-estabel                          AT 01
                tt-perc-valor.ct-codigo                            AT 05
                tt-perc-valor.cc-codigo                            AT 14
                STRING(tt-perc-valor.perc,">>9.99999999")          TO 34
                STRING(tt-perc-valor.val-valor,"->>>,>>>,>>9.99")  TO 50
                STRING(tt-perc-valor.val-rateio,"->>>,>>>,>>9.99") TO 66
                STRING(tt-perc-valor.val-total,"->>>,>>>,>>9.99")  TO 82 SKIP.

            ASSIGN de-liquido = de-liquido + tt-perc-valor.val-valor
                   de-rateio  = de-rateio  + tt-perc-valor.val-rateio
                   de-total   = de-total   + tt-perc-valor.val-total.
        END.

        PUT UNFORMATTED 
            "Total Geral" AT 22
            STRING(de-liquido,"->>>,>>>,>>9.99") TO 50     
            STRING(de-rateio,"->>>,>>>,>>9.99")  TO 66     
            STRING(de-total,"->>>,>>>,>>9.99")   TO 82 SKIP(1)
            "  VALOR LIQUIDO:" AT 01 
            STRING(de-valor-liquido,"->>>,>>>,>>9.99")                      AT 17 
            "- Valor total dos equipamentos Intelbras participam do rateio" AT 33 SKIP
            "VALOR P/ RATEIO:" AT 01 
            STRING(de-valor-rateado,"->>>,>>>,>>9.99")  AT 17 
            "- Valor total dos rateios de equipamentos" AT 33 SKIP
            "   VALOR OUTROS:" AT 01 
            STRING(de-valor-outros,"->>>,>>>,>>9.99")                 AT 17 
            "- Valor total dos equipamentos que nao entram no rateio" AT 33 SKIP
            "    TOTAL GERAL:" AT 01 STRING(de-valor-liquido + de-valor-rateado + de-valor-outros,"->>>,>>>,>>9.99") AT 17 SKIP(1)
            FILL("-",150) SKIP.
    END.

    IF tt-param.l-contabil THEN DO:
        IF CAN-FIND(FIRST tt-rateios2) THEN DO:
            PUT UNFORMATTED "VALORES CONTABILIZACAO" SKIP(1)
                "Est Conta    C. Custo     Valor Total" SKIP
                "--- -------- -------- ---------------" SKIP.

            ASSIGN de-total = 0.
            FOR EACH tt-rateios2 
                BREAK BY tt-rateios2.cod-estabel
                      BY tt-rateios2.ct-codigo:
                ASSIGN de-total = de-total + tt-rateios2.val-rateio.

                ACCUMULATE tt-rateios2.val-rateio (TOTAL BY tt-rateios2.cod-estabel)
                           tt-rateios2.val-rateio (TOTAL BY tt-rateios2.ct-codigo).
                PUT UNFORMATTED
                    tt-rateios2.cod-estabel                          AT 01
                    tt-rateios2.ct-codigo                            AT 05
                    tt-rateios2.cc-codigo                            AT 14
                    STRING(tt-rateios2.val-rateio,"->>>,>>>,>>9.99") TO 37 SKIP.

                IF LAST-OF(tt-rateios2.ct-codigo) THEN DO:
                    PUT UNFORMATTED 
                        "Total Conta" AT 05
                        STRING((ACCUM TOTAL BY tt-rateios2.ct-codigo tt-rateios2.val-rateio),"->>>,>>>,>>9.99") TO 37 SKIP.
                    ASSIGN de-valor = 0.
                END.

                IF LAST-OF(tt-rateios2.cod-estabel) THEN DO:
                    PUT UNFORMATTED 
                        "Total Estab" AT 05
                        STRING((ACCUM TOTAL BY tt-rateios2.cod-estabel tt-rateios2.val-rateio),"->>>,>>>,>>9.99") TO 37 SKIP(1).
                    ASSIGN de-valor = 0.
                END.
            END.

            PUT UNFORMATTED
                "Total Geral" AT 05
                STRING(de-total,"->>>,>>>,>>9.99") TO 37 SKIP(1)
                FILL("-",150) SKIP.
        END.

        IF CAN-FIND(FIRST tt-rateios3) THEN DO:

            PUT UNFORMATTED "VALORES CONTABILIZACAO P/ EQUIPAMENTO" SKIP(1)
                "Conta    C. Custo Equipamento                     Valor" SKIP
                "-------- -------- --------------------- ---------------" SKIP.

            ASSIGN de-valor = 0
                   de-total = 0.
            FOR EACH tt-rateios3
                BREAK BY tt-rateios3.ct-codigo
                      BY tt-rateios3.cc-codigo
                      BY tt-rateios3.equipamento:
                ASSIGN de-valor = de-valor + tt-rateios3.val-rateio
                       de-total = de-total + tt-rateios3.val-rateio.

                PUT UNFORMATTED 
                    tt-rateios3.ct-codigo   AT 01
                    tt-rateios3.cc-codigo   AT 10
                    tt-rateios3.equipamento AT 19
                    STRING(tt-rateios3.val-rateio,"->>>,>>>,>>9.99") TO 55 SKIP.

                IF LAST-OF(tt-rateios3.ct-codigo)   OR
                   LAST-OF(tt-rateios3.cc-codigo) THEN DO:
                    PUT UNFORMATTED 
                        "SubTotal" AT 19
                        STRING(de-valor,"->>>,>>>,>>9.99") TO 55 SKIP.
                    ASSIGN de-valor = 0.
                END.
            END.
            PUT UNFORMATTED 
                "Total Geral" AT 19
                STRING(de-total,"->>>,>>>,>>9.99") TO 55 SKIP(1)
                FILL("-",150) SKIP.
        END.
    END.
END PROCEDURE.

PROCEDURE pi-saldo-transitoria:
    DEFINE INPUT PARAMETER p-data   AS DATE    NO-UNDO.
    DEFINE OUTPUT PARAMETER p-saldo AS DECIMAL NO-UNDO.

    CREATE tt_input_leitura_sdo.
    ASSIGN tt_input_leitura_sdo.ttv_cod_label    = "Empresa"
           tt_input_leitura_sdo.ttv_des_conteudo = "1"
           tt_input_leitura_sdo.ttv_num_seq_1    = 1
           tt_input_leitura_sdo.ttv_num_seq_2    = 1.

    CREATE tt_input_leitura_sdo.
    ASSIGN tt_input_leitura_sdo.ttv_cod_label    = "Finalidade Econìmica"
           tt_input_leitura_sdo.ttv_des_conteudo = 'Corrente'
           tt_input_leitura_sdo.ttv_num_seq_1    = 1
           tt_input_leitura_sdo.ttv_num_seq_2    = 2. 

    CREATE tt_input_leitura_sdo. 
    ASSIGN tt_input_leitura_sdo.ttv_cod_label    = "Conta Contabil Inicial"
           tt_input_leitura_sdo.ttv_des_conteudo = "11930045"
           tt_input_leitura_sdo.ttv_num_seq_1    = 1
           tt_input_leitura_sdo.ttv_num_seq_2    = 3.

    CREATE tt_input_leitura_sdo. 
    ASSIGN tt_input_leitura_sdo.ttv_cod_label    = "Conta Contabil Final"
           tt_input_leitura_sdo.ttv_des_conteudo = "11930045"
           tt_input_leitura_sdo.ttv_num_seq_1    = 1
           tt_input_leitura_sdo.ttv_num_seq_2    = 4.

    CREATE tt_input_leitura_sdo.
    ASSIGN tt_input_leitura_sdo.ttv_cod_label    = "Data Final"
           tt_input_leitura_sdo.ttv_des_conteudo = string(p-data, '99/99/9999')
           tt_input_leitura_sdo.ttv_num_seq_1    = 1
           tt_input_leitura_sdo.ttv_num_seq_2    = 5.



    run prgfin/fgl/fgl905zb.py (Input 1,
                                Input table tt_input_leitura_sdo,
                                output table tt_retorna_sdo_ctbl,
                                output table tt_log_erros).

    ASSIGN p-saldo = 0.
    FOR EACH tt_retorna_sdo_ctbl
       WHERE tt_retorna_sdo_ctbl.tta_cod_estab = "101":
        ASSIGN p-saldo = p-saldo + tt_retorna_sdo_ctbl.tta_val_sdo_ctbl_fim.
    END.

    FOR EACH tt_log_erros:
        MESSAGE ttv_des_erro
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END.
END PROCEDURE.

PROCEDURE pi-valida-cc-uni-estab:
    DEFINE INPUT PARAMETER p-cod-estabel LIKE equipamento.cod-estabel.

    DEFINE VARIABLE l-erro-valida AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE c-unidades    AS CHARACTER   NO-UNDO.

    DEFINE BUFFER b_cc_uni_estab FOR cc_uni_estab.

    ASSIGN c-unidades = "".
   
    IF  cc-equipamentos.cc-codigo <> "" AND 
        equipamento.ct-codigo     <> "11930045" 
    THEN DO:
        FIND FIRST cc_uni_estab NO-LOCK
             WHERE cc_uni_estab.cod_ccusto = cc-equipamentos.cc-codigo NO-ERROR.
        IF NOT AVAIL cc_uni_estab THEN DO:
            RETURN "Centro Custo: " + cc-equipamentos.cc-codigo + " nao cadastrado na tabela cc_uni_estab".
        END.
        ELSE DO:
            FIND FIRST cc_uni_estab NO-LOCK
                 WHERE cc_uni_estab.cc_codigo = cc-equipamentos.cc-codigo NO-ERROR.
            IF AVAIL cc_uni_estab THEN DO:
                FIND FIRST b_cc_uni_estab NO-LOCK 
                     WHERE b_cc_uni_estab.cc_codigo = cc_uni_estab.cc_codigo
                       AND b_cc_uni_estab.cod_estab = p-cod-estabel NO-ERROR.
                IF NOT AVAIL b_cc_uni_estab THEN
                    RETURN "Centro Custo: " + cc-equipamentos.cc-codigo + " nao pode ser utilizado no estabelecimento " + p-cod-estabel.
            END.
            ELSE DO:

                ASSIGN l-erro-valida = YES.
                IF NOT CAN-FIND(FIRST cc_uni_estab NO-LOCK
                                WHERE cc_uni_estab.cod_ccusto = cc-equipamentos.cc-codigo
                                  AND cc_uni_estab.cod_estab  = p-cod-estabel) THEN DO:
                    RETURN "Centro Custo: " + cc-equipamentos.cc-codigo + " nao pode ser utilizado no estabelecimento " + p-cod-estabel.
                END.
                ELSE DO:
                    FOR EACH cc_uni_estab NO-LOCK
                       WHERE cc_uni_estab.cod_ccusto = cc-equipamentos.cc-codigo
                         AND cc_uni_estab.cod_estab  = p-cod-estabel:
                        IF cc_uni_estab.cod_unid_negoc = cc-equipamentos.cod-unid-negoc
                        THEN
                            ASSIGN l-erro-valida = NO.

                        IF cc-equipamentos.equipamento = "3591911668" THEN DO:
                            MESSAGE "==> aqui " cc-equipamentos.equipamento " = " cc-equipamentos.cc-codigo " - " cc_uni_estab.cc_codigo " - " l-erro-valida VIEW-AS ALERT-BOX.
                        END.

                        IF c-unidades = "" THEN
                            ASSIGN c-unidades = cc_uni_estab.cod_unid_negoc.
                        ELSE
                            ASSIGN c-unidades = "," + cc_uni_estab.cod_unid_negoc.
                    END.
                    IF l-erro-valida THEN
                        RETURN "C.Custo: " + cc-equipamentos.cc-codigo + " p/ estab: " + p-cod-estabel + " so pode ser usado nas unidades: " + c-unidades + ".".
                END.
            END.
        END.
    END.
    
    RETURN "OK".

END PROCEDURE.
