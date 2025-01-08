/*{include/i-prgvrs.i esutp054 2.04.00.000}*/
/***********************************************************************
**  Programa..: ESP\UTP\ESUTP005RP.P
**  Autor.....: Raphael Paini
**  Data......: Junho/2008 - Desenvolvimento
**  Descricao.: Integra Contabilidade Telefonia
**  VersÆo....: 001 07/06/2008
**                  Desenvolvimento Programa
************************************************************************/

/****************************  Definitions  ****************************/

/****************************  Temp-Tables  ****************************/
{esp/utp/esutp054tt.i}

DEFINE TEMP-TABLE tt-rateios NO-UNDO LIKE rateio-equipamentos  
            FIELD r-Rowid AS ROWID.

DEFINE TEMP-TABLE tt-rateios2 NO-UNDO LIKE rateio-equipamentos  
            FIELD r-Rowid AS ROWID.

DEF NEW GLOBAL SHARED VAR c-seg-usuario AS CHARACTER FORM "x(12)" NO-UNDO.

DEFINE TEMP-TABLE tt-faturas NO-UNDO LIKE correios
    FIELD nome-fornec AS CHARACTER FORMAT "x(10)"
    FIELD r-rowid   AS ROWID.

DEFINE TEMP-TABLE tt-contas NO-UNDO
    FIELD cod-estabel LIKE rateio-equipamentos.cod-estabel 
    FIELD equipamento LIKE rateio-equipamentos.equipamento 
    FIELD ct-codigo   LIKE rateio-equipamentos.ct-codigo   
    FIELD cc-codigo   LIKE rateio-equipamentos.cc-codigo
    FIELD descricao   AS CHARACTER FORMAT "x(40)"
    FIELD erro        AS CHARACTER FORMAT "x(40)"
    INDEX ch-chave cod-estabel
                   equipamento
                   ct-codigo
                   cc-codigo
    INDEX ch-erro erro.

def new shared temp-table tt_integr_aprop_lancto_ctbl_1 no-undo
    field tta_cod_finalid_econ             as character format "x(10)" label "Finalidade" column-label "Finalidade"
    field tta_cod_unid_negoc               as character format "x(3)" label "Unid Neg¢cio" column-label "Un Neg"
    field tta_cod_plano_ccusto             as character format "x(8)" label "Plano Centros Custo" column-label "Plano Centros Custo"
    field tta_qtd_unid_lancto_ctbl         as decimal format ">>,>>>,>>9.99" decimals 2 initial 0 label "Quantidade" column-label "Quantidade"
    field tta_val_lancto_ctbl              as decimal format ">>>>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Lan‡amento" column-label "Valor Lan‡amento"
    field tta_num_id_aprop_lancto_ctbl     as integer format "9999999999" initial 0 label "Apropriacao Lan‡to" column-label "Apropriacao Lan‡to"
    field ttv_rec_integr_item_lancto_ctbl  as recid format ">>>>>>9"
    field tta_dat_cotac_indic_econ         as date format "99/99/9999" initial ? label "Data Cota‡Æo" column-label "Data Cota‡Æo"
    field tta_val_cotac_indic_econ         as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Cota‡Æo" column-label "Cota‡Æo"
    field ttv_ind_erro_valid               as character format "X(08)" initial "NÆo"
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
    field ttv_ind_pos_erro                 as character format "X(08)" label "Posi‡Æo"
    index tt_id                            is primary unique
          ttv_rec_integr_ctbl              ascending
          ttv_num_mensagem                 ascending.

def new shared temp-table tt_integr_ctbl_valid_parametros no-undo
    field ttv_rec_aux                      as recid format ">>>>>>9"
    field ttv_cod_parameters               as character format "x(256)"
    field ttv_cod_msg                      as character format "x(8)" label "Mensagem" column-label "Mensagem".

def new shared temp-table tt_integr_item_lancto_ctbl_1 no-undo
    field ttv_rec_integr_lancto_ctbl       as recid format ">>>>>>9"
    field tta_num_seq_lancto_ctbl          as integer format ">>>>9" initial 0 label "Sequˆncia Lan‡to" column-label "Sequˆncia Lan‡to"
    field tta_ind_natur_lancto_ctbl        as character format "X(02)" initial "DB" label "Natureza" column-label "Natureza"
    field tta_cod_plano_cta_ctbl           as character format "x(8)" label "Plano Contas" column-label "Plano Contas"
    field tta_cod_cta_ctbl                 as character format "x(20)" label "Conta Cont bil" column-label "Conta Cont bil"
    field tta_cod_plano_ccusto             as character format "x(8)" label "Plano Centros Custo" column-label "Plano Centros Custo"
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_unid_negoc               as character format "x(3)" label "Unid Neg¢cio" column-label "Un Neg"
    field tta_cod_histor_padr              as character format "x(8)" label "Hist¢rico PadrÆo" column-label "Hist¢rico PadrÆo"
    field tta_des_histor_lancto_ctbl       as character format "x(2000)" label "Hist¢rico Cont bil" column-label "Hist¢rico Cont bil"
    field tta_cod_espec_docto              as character format "x(3)" label "Esp‚cie Documento" column-label "Esp‚cie"
    field tta_dat_docto                    as date format "99/99/9999" initial ? label "Data Documento" column-label "Data Documento"
    field tta_des_docto                    as character format "x(25)" label "N£mero Documento" column-label "N£mero Documento"
    field tta_cod_imagem                   as character format "x(30)" label "Imagem" column-label "Imagem"
    field tta_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda"
    field tta_dat_lancto_ctbl              as date format "99/99/9999" initial ? label "Data Lan‡amento" column-label "Data Lan‡to"
    field tta_qtd_unid_lancto_ctbl         as decimal format ">>,>>>,>>9.99" decimals 2 initial 0 label "Quantidade" column-label "Quantidade"
    field tta_val_lancto_ctbl              as decimal format ">>>>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Lan‡amento" column-label "Valor Lan‡amento"
    field tta_num_seq_lancto_ctbl_cpart    as integer format ">>>9" initial 0 label "Sequˆncia CPartida" column-label "Sequˆncia CP"
    field ttv_ind_erro_valid               as character format "X(08)" initial "NÆo"
    field tta_cod_ccusto                   as Character format "x(11)" label "Centro Custo" column-label "Centro Custo"
    field tta_cod_proj_financ              as character format "x(20)" label "Projeto" column-label "Projeto"
    field ttv_rec_integr_item_lancto_ctbl  as recid format ">>>>>>9"
    index tt_id                            is primary unique
          ttv_rec_integr_lancto_ctbl       ascending
          tta_num_seq_lancto_ctbl          ascending
    index tt_recid                        
          ttv_rec_integr_item_lancto_ctbl  ascending.

def new shared temp-table tt_integr_lancto_ctbl_1 no-undo
    field tta_cod_cenar_ctbl               as character format "x(8)" label "Cen rio Cont bil" column-label "Cen rio Cont bil"
    field tta_log_lancto_conver            as logical format "Sim/NÆo" initial no label "Lan‡amento ConversÆo" column-label "Lan‡to Conv"
    field tta_log_lancto_apurac_restdo     as logical format "Sim/NÆo" initial no label "Lan‡amento Apura‡Æo" column-label "Lancto Apura‡Æo"
    field tta_cod_rat_ctbl                 as character format "x(8)" label "Rateio Cont bil" column-label "Rateio"
    field ttv_rec_integr_lote_ctbl         as recid format ">>>>>>9"
    field tta_num_lancto_ctbl              as integer format ">>,>>>,>>9" initial 10 label "Lan‡amento Cont bil" column-label "Lan‡amento Cont bil"
    field ttv_ind_erro_valid               as character format "X(08)" initial "NÆo"
    field tta_dat_lancto_ctbl              as date format "99/99/9999" initial ? label "Data Lan‡amento" column-label "Data Lan‡to"
    field ttv_rec_integr_lancto_ctbl       as recid format ">>>>>>9"
    index tt_id                            is primary unique
          ttv_rec_integr_lote_ctbl         ascending
          tta_num_lancto_ctbl              ascending
    index tt_recid                        
          ttv_rec_integr_lancto_ctbl       ascending.

def temp-table tt_integr_lancto_ctbl_aux no-undo
    field tta_cod_cenar_ctbl               as character format "x(8)" label "Cen rio Cont bil" column-label "Cen rio Cont bil"
    field tta_log_lancto_conver            as logical format "Sim/NÆo" initial no label "Lan‡amento ConversÆo" column-label "Lan‡to Conv"
    field tta_log_lancto_apurac_restdo     as logical format "Sim/NÆo" initial no label "Lan‡amento Apura‡Æo" column-label "Lancto Apura‡Æo"
    field tta_cod_rat_ctbl                 as character format "x(8)" label "Rateio Cont bil" column-label "Rateio"
    field ttv_rec_integr_lote_ctbl         as recid format ">>>>>>9"
    field tta_num_lancto_ctbl              as integer format ">>,>>>,>>9" initial 10 label "Lan‡amento Cont bil" column-label "Lan‡amento Cont bil"
    field ttv_ind_erro_valid               as character format "X(08)" initial "NÆo"
    field tta_dat_lancto_ctbl              as date format "99/99/9999" initial ? label "Data Lan‡amento" column-label "Data Lan‡to"
    field ttv_rec_integr_lancto_ctbl       as recid format ">>>>>>9"
    index tt_id                            is primary unique
          ttv_rec_integr_lote_ctbl         ascending
          tta_num_lancto_ctbl              ascending.

def new shared temp-table tt_integr_lote_ctbl_1 no-undo
    field tta_cod_modul_dtsul              as character format "x(3)" label "M¢dulo" column-label "M¢dulo"
    field tta_num_lote_ctbl                as integer format ">>>,>>>,>>9" initial 1 label "Lote Cont bil" column-label "Lote Cont bil"
    field tta_des_lote_ctbl                as character format "x(40)" label "Descri‡Æo Lote" column-label "Descri‡Æo Lote"
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_dat_lote_ctbl                as date format "99/99/9999" initial today label "Data Lote Cont bil" column-label "Data Lote Cont bil"
    field ttv_ind_erro_valid               as character format "X(08)" initial "NÆo"
    field tta_log_integr_ctbl_online       as logical format "Sim/NÆo" initial no label "Integra‡Æo Online" column-label "Integr Online"
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

ASSIGN c-sistema      = "Espec¡ficos Intelbras"
       c-titulo-relat = "Integra Comunica‡äes - Contabilidade"
       c-empresa      = if avail empresa then mgcad.empresa.razao-social else ''
       c-programa     = "esutp054"
       c-versao       = "2.04"
       c-revisao      = "001".

/* ***************************  Main Block  *************************** */

FOR EACH tt-faturas:
    DELETE tt-faturas.
END.
FOR EACH tt-contas:
    DELETE tt-contas.
END.
FOR EACH tt-rateios:
    DELETE tt-rateios.
END.
FOR EACH tt-rateios2:
    DELETE tt-rateios2.
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
           AND integra-equipamentos.tipo = 1 NO-ERROR.
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
        FOR EACH tt-rateios:
            ASSIGN de-valor-contabil = de-valor-contabil + tt-rateios.val-rateio.
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
            MESSAGE "Existem lan‡amentos negativos, nÆo podem conter esse tipo de lan‡amentos. Processo cancelado!"
                VIEW-AS ALERT-BOX ERROR BUTTONS OK.
            ASSIGN l-erro = YES.
        END.
        ELSE DO:
            IF tt-param.execucao = 2                    AND  
               /*de-saldo-transitoria = de-valor-contabil AND*/
               NOT CAN-FIND(FIRST tt-contas NO-LOCK 
                            WHERE tt-contas.erro <> "") THEN DO:
        
                MESSAGE "agora inicia integra‡Æo"
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.
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
                MESSAGE "Simula‡Æo conclu¡da com sucesso!" VIEW-AS ALERT-BOX INFO BUTTONS OK.
        END.
        ELSE DO:
            IF FALSE AND de-saldo-transitoria <> de-valor-contabil THEN DO:
                MESSAGE "Valor Contalizar diferente de Saldo Transit¢ria. Processo de Integra‡Æo Abortado!" SKIP
                        "Diferen‡a: " TRIM(STRING(de-saldo-transitoria,"->>>,>>>,>>9.99")) " - " 
                                      TRIM(STRING(de-valor-contabil,"->>>,>>>,>>9.99"))    " = "  
                                      TRIM(STRING(de-saldo-transitoria - de-valor-contabil,"->>>,>>>,>>9.99"))
                         VIEW-AS ALERT-BOX ERROR BUTTONS OK.
            END.
            ELSE DO:
                IF NOT CAN-FIND(FIRST tt_integr_ctbl_valid_1) THEN
                    MESSAGE "Integra‡Æo conclu¡da com sucesso!"
                        VIEW-AS ALERT-BOX INFO BUTTONS OK.
                ELSE 
                    MESSAGE "Ocorreu algum erro durante a Integra‡Æo. Processo cancelado!"
                        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
            END.
        END.
    END.

    RUN pi-finalizar in h-acomp.

    RETURN "OK".
END.

PROCEDURE pi-carrega-dados:
    RUN pi-inicializar in h-acomp (input "Carregando Faturas...").

    FOR EACH correios NO-LOCK
       WHERE correios.mes-ref = tt-param.periodo:
        RUN pi-acompanhar IN h-acomp (INPUT "Fatura: " + STRING(correios.nr-fatura)).
        CREATE tt-faturas.
        BUFFER-COPY correios TO tt-faturas.
        ASSIGN tt-faturas.r-rowid = ROWID(correios).

        ASSIGN tt-faturas.nome-fornec = "Correios"
               tt-faturas.ct-codigo   = "11930035".
    END.
END PROCEDURE.

PROCEDURE pi-validar:

    RUN pi-inicializar in h-acomp (input "Validando Informa‡äes...").

    FOR EACH tt-faturas NO-LOCK
        BREAK BY tt-faturas.cod-estabel
              BY tt-faturas.nr-cartao:

        IF FIRST-OF(tt-faturas.cod-estabel) OR
           FIRST-OF(tt-faturas.nr-cartao) THEN DO:

            FIND FIRST cta_ctbl NO-LOCK
                 WHERE cta_ctbl.cod_plano_cta_ctbl = "Padrao"
                   AND cta_ctbl.cod_cta_ctbl       = tt-faturas.ct-codigo NO-ERROR.
            IF NOT AVAIL cta_ctbl OR tt-faturas.ct-codigo = "" THEN DO:
                RUN pi-cria-contas (INPUT tt-faturas.cod-estabel,
                                    INPUT tt-faturas.nr-cartao,
                                    INPUT tt-faturas.ct-codigo,
                                    INPUT "",
                                    INPUT "",
                                    INPUT "Conta invalida.").
            END.
            ELSE DO:
                FIND FIRST unid_negoc NO-LOCK
                     WHERE unid_negoc.cdn_unid_negoc = INT(SUBSTRING(tt-faturas.cc-codigo,1,3)) NO-ERROR.
                IF NOT AVAIL unid_negoc THEN DO:
                    /*Valida unidade negocio do centro de custo*/
                    RUN pi-cria-contas (INPUT tt-faturas.cod-estabel,
                                        INPUT tt-faturas.nr-cartao,
                                        INPUT tt-faturas.ct-codigo,
                                        INPUT tt-faturas.cc-codigo,
                                        INPUT "",
                                        INPUT "Unidade Negocio: " + SUBSTRING(tt-faturas.cc-codigo,1,3) + " invalida para Centro Custo: " + SUBSTRING(tt-faturas.cc-codigo,4,5) + ".").
                END.
                ELSE DO:
                    FIND FIRST emscad.ccusto NO-LOCK
                         WHERE emscad.ccusto.cod_plano_ccusto = "Padrao"
                           AND emscad.ccusto.cod_ccusto       = SUBSTRING(tt-faturas.cc-codigo,4,5) NO-ERROR.
                    IF NOT AVAIL emscad.ccusto THEN DO:
                        /*Valida Centro de custo*/
                        RUN pi-cria-contas (INPUT tt-faturas.cod-estabel,
                                            INPUT tt-faturas.nr-cartao,
                                            INPUT tt-faturas.ct-codigo,
                                            INPUT tt-faturas.cc-codigo,
                                            INPUT "",
                                            INPUT "Centro Custo: " + SUBSTRING(tt-faturas.cc-codigo,4,5) + " do Equipamento invalido.").
                    END.
                    ELSE DO:
                        RUN pi-valida-cc-uni-estab.
                        IF RETURN-VALUE <> "OK" THEN DO:
                            /*Valida restricoes Centro de custo no estab 101*/
                            RUN pi-cria-contas (INPUT tt-faturas.cod-estabel,
                                                INPUT tt-faturas.nr-cartao,
                                                INPUT tt-faturas.ct-codigo,
                                                INPUT tt-faturas.cc-codigo,
                                                INPUT "",
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
                                                    INPUT tt-faturas.nr-cartao,
                                                    INPUT tt-faturas.ct-codigo,
                                                    INPUT tt-faturas.cc-codigo,
                                                    INPUT "",
                                                    INPUT "Centro Custo: " + SUBSTRING(tt-faturas.cc-codigo,4,5) + " nao pode ser utilizado na unidade: " + SUBSTRING(tt-faturas.cc-codigo,1,3) + ".").
                            END.
                            ELSE DO:
                                find FIRST restric_ccusto no-lock
                                     where restric_ccusto.cod_empresa      = ccusto.cod_empresa      
                                       and restric_ccusto.cod_plano_ccusto = ccusto.cod_plano_ccusto 
                                       and restric_ccusto.cod_ccusto       = ccusto.cod_ccusto       
                                       and restric_ccusto.cod_estab        = "101" no-error.
                                IF AVAIL restric_ccusto THEN DO:
                                    /*Valida restricoes Centro de custo no estab 101*/
                                    RUN pi-cria-contas (INPUT tt-faturas.cod-estabel,
                                                        INPUT tt-faturas.nr-cartao,
                                                        INPUT tt-faturas.ct-codigo,
                                                        INPUT tt-faturas.cc-codigo,
                                                        INPUT "",
                                                        INPUT "Existe restricao do Centro Custo: " + SUBSTRING(tt-faturas.cc-codigo,4,5) + " para estabelecimento 101.").
                                END.
                                ELSE DO:
                                    /*Registro sem nenhum erro ou restricao*/
                                    RUN pi-cria-contas (INPUT tt-faturas.cod-estabel,
                                                        INPUT tt-faturas.nr-cartao,
                                                        INPUT tt-faturas.ct-codigo,
                                                        INPUT tt-faturas.cc-codigo,
                                                        INPUT emscad.ccusto.des_tit_ctbl,
                                                        INPUT "").
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
    DEFINE INPUT PARAMETER p-cod-estabel AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER p-equipamento AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER p-ct-codigo   AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER p-cc-codigo   AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER p-descricao   AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER p-erro        AS CHARACTER NO-UNDO.

    CREATE tt-contas.
    ASSIGN tt-contas.cod-estabel = p-cod-estabel
           tt-contas.equipamento = p-equipamento
           tt-contas.ct-codigo   = p-ct-codigo
           tt-contas.cc-codigo   = p-cc-codigo
           tt-contas.descricao   = p-descricao
           tt-contas.erro        = p-erro.

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

    FOR EACH tt-faturas:

        FIND FIRST tt-rateios NO-LOCK
             WHERE tt-rateios.cod-estabel = tt-faturas.cod-estabel
               AND tt-rateios.equipamento = tt-faturas.nr-cartao
               AND tt-rateios.mes-ref     = tt-faturas.mes-ref
               AND tt-rateios.ct-codigo   = tt-faturas.ct-codigo
               AND tt-rateios.cc-codigo   = tt-faturas.cc-codigo NO-ERROR.
        IF NOT AVAIL tt-rateios THEN DO:
            CREATE tt-rateios.
            ASSIGN tt-rateios.cod-estabel = tt-faturas.cod-estabel
                   tt-rateios.equipamento = tt-faturas.nr-cartao
                   tt-rateios.mes-ref     = tt-faturas.mes-ref
                   tt-rateios.ct-codigo   = tt-faturas.ct-codigo
                   tt-rateios.cc-codigo   = tt-faturas.cc-codigo.
        END.
        ASSIGN tt-rateios.val-rateio = tt-rateios.val-rateio + tt-faturas.valor.

        FIND FIRST tt-rateios2 NO-LOCK
             WHERE tt-rateios2.cod-estabel = tt-faturas.cod-estabel
               AND tt-rateios2.mes-ref     = tt-faturas.mes-ref
               AND tt-rateios2.ct-codigo   = tt-faturas.ct-codigo
               AND tt-rateios2.cc-codigo   = tt-faturas.cc-codigo NO-ERROR.
        IF NOT AVAIL tt-rateios2 THEN DO:
            CREATE tt-rateios2.
            ASSIGN tt-rateios2.cod-estabel = tt-faturas.cod-estabel
                   tt-rateios2.mes-ref     = tt-faturas.mes-ref
                   tt-rateios2.ct-codigo   = tt-faturas.ct-codigo
                   tt-rateios2.cc-codigo   = tt-faturas.cc-codigo.
        END.
        ASSIGN tt-rateios2.val-rateio = tt-rateios2.val-rateio + tt-faturas.valor.

    END.

END PROCEDURE.

PROCEDURE pi-integra:

    DEFINE VARIABLE i-seq          AS INTEGER     NO-UNDO.
    DEFINE VARIABLE de-valor-total AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE c-plano-conta  AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-plano-custo  AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-centro-custo AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE dt-contabil    AS DATE    NO-UNDO.

    RUN pi-inicializar in h-acomp (input "Gerando Dados Integra‡Æo...").

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
           tt_integr_lote_ctbl_1.tta_des_lote_ctbl        = "Contabiliza‡Æo Comunica‡äes"
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

        FIND FIRST unid_negoc NO-LOCK
             WHERE unid_negoc.cdn_unid_negoc = INT(SUBSTRING(tt-rateios2.cc-codigo,1,3)) NO-ERROR.

        ASSIGN c-plano-conta  = "Padrao"
               c-plano-custo  = "Padrao"
               c-centro-custo = SUBSTRING(tt-rateios2.cc-codigo,4,5).

        CREATE tt_integr_item_lancto_ctbl_1.
        ASSIGN tt_integr_item_lancto_ctbl_1.ttv_rec_integr_lancto_ctbl      = tt_integr_lancto_ctbl_1.ttv_rec_integr_lancto_ctbl
               tt_integr_item_lancto_ctbl_1.tta_num_seq_lancto_ctbl         = i-seq
               tt_integr_item_lancto_ctbl_1.tta_ind_natur_lancto_ctbl       = "DB"
               tt_integr_item_lancto_ctbl_1.tta_cod_plano_cta_ctbl          = c-plano-conta
               tt_integr_item_lancto_ctbl_1.tta_cod_cta_ctbl                = tt-rateios2.ct-codigo
               tt_integr_item_lancto_ctbl_1.tta_cod_plano_ccusto            = c-plano-custo
               tt_integr_item_lancto_ctbl_1.tta_cod_estab                   = "101" /*ver contabilidade*/
               tt_integr_item_lancto_ctbl_1.tta_cod_unid_negoc              = IF AVAIL unid_negoc THEN unid_negoc.cod_unid_negoc ELSE "ADM"
               tt_integr_item_lancto_ctbl_1.tta_des_histor_lancto_ctbl      = "Contabiliza‡Æo Comunica‡äes"
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
           tt_integr_item_lancto_ctbl_1.tta_cod_cta_ctbl                = "11930035"
           tt_integr_item_lancto_ctbl_1.tta_cod_plano_ccusto            = ""
           tt_integr_item_lancto_ctbl_1.tta_cod_estab                   = "101"
           tt_integr_item_lancto_ctbl_1.tta_cod_unid_negoc              = "ADM"
           tt_integr_item_lancto_ctbl_1.tta_des_histor_lancto_ctbl      = "Contabiliza‡Æo Comunica‡äes"
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

    MESSAGE "inicia integra‡Æo contabil"
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RUN pi-inicializar in h-acomp (input "Integrando Contabilidade...").
    run prgfin/fgl/fgl900zl.py (Input 3,
                                Input "Aborta Tudo",
                                Input yes,
                                Input 66,
                                Input "Apropria‡Æo",
                                Input "Todos",
                                Input yes,
                                Input yes,
                                input-output table tt_integr_lote_ctbl_1,
                                input-output table tt_integr_lancto_ctbl_1,
                                input-output table tt_integr_item_lancto_ctbl_1,
                                input-output table tt_integr_aprop_lancto_ctbl_1,
                                input-output table tt_integr_ctbl_valid_1).


    IF NOT CAN-FIND(FIRST tt_integr_ctbl_valid_1) THEN DO:

        FOR EACH tt-rateios NO-LOCK:
            CREATE rateio-equipamentos.
            ASSIGN rateio-equipamentos.tipo         = 1 /*correios*/
                   rateio-equipamentos.cod-estabel = tt-rateios.cod-estabel
                   rateio-equipamentos.equipamento = tt-rateios.equipamento
                   rateio-equipamentos.mes-ref     = tt-rateios.mes-ref
                   rateio-equipamentos.ct-codigo   = tt-rateios.ct-codigo
                   rateio-equipamentos.cc-codigo   = tt-rateios.cc-codigo
                   rateio-equipamentos.val-rateio  = tt-rateios.val-rateio.
        END.

        CREATE integra-equipamentos.
        ASSIGN integra-equipamentos.tipo    = 1
               integra-equipamentos.mes-ref = tt-param.periodo
               integra-equipamentos.data    = dt-contabil
               integra-equipamentos.hora    = STRING(TIME,"HH:MM:SS")
               integra-equipamentos.usuario = c-seg-usuario.
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

    IF CAN-FIND(FIRST tt-rateios) THEN DO:

        IF tt-param.tipo = 1 THEN
            PUT UNFORMATTED 
                 "VALORES P/ CENTRO CUSTO - DETALHADO" SKIP(1)
                 "Conta    C. Custo Cartao                Est           Valor" SKIP
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

    IF CAN-FIND(FIRST tt-rateios) THEN DO:

        PUT UNFORMATTED "VALORES CONTABILIZACAO P/ CARTAO" SKIP(1)
            "Conta    C. Custo Equipamento                     Valor" SKIP
            "-------- -------- --------------------- ---------------" SKIP.

        ASSIGN de-valor = 0
               de-total = 0.
        FOR EACH tt-rateios
            BREAK BY tt-rateios.ct-codigo
                  BY tt-rateios.cc-codigo
                  BY tt-rateios.equipamento:
            ASSIGN de-valor = de-valor + tt-rateios.val-rateio
                   de-total = de-total + tt-rateios.val-rateio.

            PUT UNFORMATTED 
                tt-rateios.ct-codigo   AT 01
                tt-rateios.cc-codigo   AT 10
                tt-rateios.equipamento AT 19
                STRING(tt-rateios.val-rateio,"->>>,>>>,>>9.99") TO 55 SKIP.

            IF LAST-OF(tt-rateios.ct-codigo)   OR
               LAST-OF(tt-rateios.cc-codigo) THEN DO:
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
    ASSIGN tt_input_leitura_sdo.ttv_cod_label    = "Finalidade Econ“mica"
           tt_input_leitura_sdo.ttv_des_conteudo = 'Corrente'
           tt_input_leitura_sdo.ttv_num_seq_1    = 1
           tt_input_leitura_sdo.ttv_num_seq_2    = 2. 

    CREATE tt_input_leitura_sdo. 
    ASSIGN tt_input_leitura_sdo.ttv_cod_label    = "Conta Contabil Inicial"
           tt_input_leitura_sdo.ttv_des_conteudo = "11930035"
           tt_input_leitura_sdo.ttv_num_seq_1    = 1
           tt_input_leitura_sdo.ttv_num_seq_2    = 3.

    CREATE tt_input_leitura_sdo. 
    ASSIGN tt_input_leitura_sdo.ttv_cod_label    = "Conta Contabil Final"
           tt_input_leitura_sdo.ttv_des_conteudo = "11930035"
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
    DEFINE VARIABLE l-erro-valida AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE c-unidades    AS CHARACTER   NO-UNDO.

    DEFINE BUFFER b_cc_uni_estab FOR cc_uni_estab.

    ASSIGN c-unidades = "".
    IF tt-faturas.cc-codigo <> ""  THEN DO:
        FIND FIRST cc_uni_estab NO-LOCK
             WHERE cc_uni_estab.cod_ccusto = SUBSTRING(tt-faturas.cc-codigo,4,5) NO-ERROR.
        IF NOT AVAIL cc_uni_estab THEN DO:
            RETURN "Centro Custo: " + SUBSTRING(tt-faturas.cc-codigo,4,5) + " nao cadastrado na tabela cc_uni_estab".
        END.
        ELSE DO:
            FIND FIRST cc_uni_estab NO-LOCK
                 WHERE cc_uni_estab.cc_codigo = tt-faturas.cc-codigo NO-ERROR.
            IF AVAIL cc_uni_estab THEN DO:
                FIND FIRST b_cc_uni_estab NO-LOCK 
                     WHERE b_cc_uni_estab.cc_codigo = cc_uni_estab.cc_codigo
                       AND b_cc_uni_estab.cod_estab = "101" NO-ERROR.
                IF NOT AVAIL b_cc_uni_estab THEN
                    RETURN "Centro Custo: " + SUBSTRING(tt-faturas.cc-codigo,4,5) + " nao pode ser utilizado no estabelecimento 101.".
            END.
            ELSE DO:
                ASSIGN l-erro-valida = YES.
                IF NOT CAN-FIND(FIRST cc_uni_estab NO-LOCK
                                WHERE cc_uni_estab.cod_ccusto = SUBSTRING(tt-faturas.cc-codigo,4,5)
                                  AND cc_uni_estab.cod_estab  = "101") THEN DO:
                    RETURN "Centro Custo: " +  SUBSTRING(tt-faturas.cc-codigo,4,5) + " nao pode ser utilizado no estabelecimento 101.".
                END.
                ELSE DO:
                    FOR EACH cc_uni_estab NO-LOCK
                       WHERE cc_uni_estab.cod_ccusto = SUBSTRING(tt-faturas.cc-codigo,4,5)
                         AND cc_uni_estab.cod_estab  = "101":
                        IF SUBSTRING(cc_uni_estab.cc_codigo,1,3) = SUBSTRING(tt-faturas.cc-codigo,1,3) THEN
                            ASSIGN l-erro-valida = NO.

                        IF c-unidades = "" THEN
                            ASSIGN c-unidades = SUBSTRING(cc_uni_estab.cc_codigo,1,3).
                        ELSE
                            ASSIGN c-unidades = "," + SUBSTRING(cc_uni_estab.cc_codigo,1,3).
                    END.
                    IF l-erro-valida THEN
                        RETURN "C.Custo: " + SUBSTRING(tt-faturas.cc-codigo,4,5) + " p/ estab: 101 so pode ser usado nas unidades: " + c-unidades + ".".
                END.
            END.
        END.
    END.
    
    RETURN "OK".

END PROCEDURE.

