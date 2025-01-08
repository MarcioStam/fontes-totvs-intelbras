/*****************************************************************************
** Programa..............: esp/apb/esapb036rp.p
** Descriá∆o.............: Baixa autom†tica de saldos (reduzir valores RPA)
** Autor.................: Andrey M Oliveira
** Criado em.............: 27/10/2021
*****************************************************************************/
{include/i-prgvrs.i esapb036rp 1.00.00.000}

define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    field rs-opcao         as integer
    field classifica       as integer
    field desc-classifica  as char format "x(40)":U.

def temp-table tt-raw-digita
   field raw-digita      as raw.

def input parameter raw-param as raw no-undo.
def input parameter table     for tt-raw-digita.

DEF TEMP-TABLE tt_tit_ap NO-UNDO
    FIELD cod_estab       LIKE tit_ap.cod_estab      
    FIELD cod_espec_docto LIKE tit_ap.cod_espec_docto
    FIELD cod_ser_docto   LIKE tit_ap.cod_ser_docto  
    FIELD cod_tit_ap      LIKE tit_ap.cod_tit_ap    
    FIELD cod_parcela     LIKE tit_ap.cod_parcela
    FIELD cdn_fornec      LIKE tit_ap.cdn_fornecedor
    FIELD dat_baixa       LIKE tit_ap.dat_emis_docto
    FIELD val_baixa       LIKE tit_ap.val_sdo_tit_ap
    FIELD cod_conta       LIKE aprop_ctbl_ap.cod_cta_ctbl
    FIELD cod_unid_negoc  LIKE aprop_ctbl_ap.cod_unid_negoc 
    FIELD cod_ccusto      LIKE aprop_ctbl_ap.cod_ccusto.

def temp-table tt-erro no-undo
    field i-sequen         as int
    field tipo             as int
    field cod_estab        LIKE tit_ap.cod_estab      
    field cod_espec_docto  LIKE tit_ap.cod_espec_docto
    field cod_ser_docto    LIKE tit_ap.cod_ser_docto  
    field cod_tit_ap       LIKE tit_ap.cod_tit_ap    
    field cod_parcela      LIKE tit_ap.cod_parcela    
    field cdn_fornec       LIKE tit_ap.cdn_fornec
    field cd-erro          as int
    field mensagem         as char format "x(255)".

DEFINE TEMP-TABLE tt-arquivo NO-UNDO
    FIELD nom-arquivo      AS CHARACTER
    FIELD nom-completo     AS CHARACTER
    FIELD ind-tipo-arquivo AS CHARACTER.

def temp-table tt_tit_ap_alteracao_rateio no-undo
    field ttv_rec_tit_ap                   as recid format ">>>>>>9" initial ?
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_refer                    as character format "x(10)" label "Referància" column-label "Referància"
    field tta_num_seq_refer                as integer format ">>>9" initial 0 label "Sequància" column-label "Seq"
    field tta_cod_tip_fluxo_financ         as character format "x(12)" label "Tipo Fluxo Financ" column-label "Tipo Fluxo Financ"
    field tta_cod_plano_cta_ctbl           as character format "x(8)" label "Plano Contas" column-label "Plano Contas"
    field tta_cod_cta_ctbl                 as character format "x(20)" label "Conta Cont†bil" column-label "Conta Cont†bil"
    field tta_cod_unid_negoc               as character format "x(3)" label "Unid Neg¢cio" column-label "Un Neg"
    field tta_cod_plano_ccusto             as character format "x(8)" label "Plano Centros Custo" column-label "Plano Centros Custo"
    field tta_cod_ccusto                   as Character format "x(11)" label "Centro Custo" column-label "Centro Custo"
    field tta_val_aprop_ctbl               as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Aprop Ctbl" column-label "Vl Aprop Ctbl"
    field ttv_ind_tip_rat                  as character format "X(08)"
    field tta_num_id_tit_ap                as integer format "9999999999" initial 0 label "Token Tit AP" column-label "Token Tit AP"
    field tta_num_id_aprop_ctbl_ap         as integer format "9999999999" initial 0 label "Id Aprop Ctbl AP" column-label "Id Aprop Ctbl AP"
    index tt_aprpctba_id                   is primary unique
          tta_cod_estab                    ascending
          tta_cod_refer                    ascending
          tta_num_seq_refer                ascending
          tta_cod_plano_cta_ctbl           ascending
          tta_cod_cta_ctbl                 ascending
          tta_cod_unid_negoc               ascending
          tta_cod_plano_ccusto             ascending
          tta_cod_ccusto                   ascending
          tta_cod_tip_fluxo_financ         ascending
          ttv_rec_tit_ap                   ascending.

def temp-table tt_tit_ap_alteracao_base no-undo
    field ttv_cod_usuar_corren             as character format "x(12)" label "Usu†rio Corrente" column-label "Usu†rio Corrente"
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_num_id_tit_ap                as integer format "9999999999" initial 0 label "Token Tit AP" column-label "Token Tit AP"
    field ttv_rec_tit_ap                   as recid format ">>>>>>9" initial ?
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field tta_cod_espec_docto              as character format "x(3)" label "EspÇcie Documento" column-label "EspÇcie"
    field tta_cod_ser_docto                as character format "x(3)" label "SÇrie Documento" column-label "SÇrie"
    field tta_cod_tit_ap                   as character format "x(10)" label "T°tulo" column-label "T°tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field ttv_dat_transacao                as date format "99/99/9999" label "Data Transaá∆o" column-label "Data Transaá∆o"
    field ttv_cod_refer                    as character format "x(10)" label "Referància" column-label "Referància"
    field tta_val_sdo_tit_ap               as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Saldo" column-label "Valor Saldo"
    field tta_dat_emis_docto               as date format "99/99/9999" initial today label "Data  Emiss∆o" column-label "Dt Emiss∆o"
    field tta_dat_vencto_tit_ap            as date format "99/99/9999" initial today label "Data Vencimento" column-label "Dt Vencto"
    field tta_dat_prev_pagto               as date format "99/99/9999" initial today label "Data Prevista Pgto" column-label "Dt Prev Pagto"
    field tta_dat_ult_pagto                as date format "99/99/9999" initial ? label "Data Èltimo Pagto" column-label "Data Èltimo Pagto"
    field tta_num_dias_atraso              as integer format ">9" initial 0 label "Dias Atraso" column-label "Dias Atr"
    field tta_val_perc_multa_atraso        as decimal format ">9.99" decimals 2 initial 00.00 label "Perc Multa Atraso" column-label "Multa Atr"
    field tta_val_juros_dia_atraso         as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Juro" column-label "Vl Juro"
    field tta_val_perc_juros_dia_atraso    as decimal format ">9.999999" decimals 6 initial 00.00 label "Perc Jur Dia Atraso" column-label "Perc Dia"
    field tta_dat_desconto                 as date format "99/99/9999" initial ? label "Data Desconto" column-label "Dt Descto"
    field tta_val_perc_desc                as decimal format ">9.9999" decimals 4 initial 0 label "Percentual Desconto" column-label "Perc Descto"
    field tta_val_desconto                 as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Desconto" column-label "Valor Desconto"
    field tta_cod_portador                 as character format "x(5)" label "Portador" column-label "Portador"
    field ttv_cod_portador_mov             as character format "x(5)" label "Portador Movto" column-label "Portador Movto"
    field tta_log_pagto_bloqdo             as logical format "Sim/N∆o" initial no label "Bloqueia Pagamento" column-label "Pagto Bloqdo"
    field tta_cod_seguradora               as character format "x(8)" label "Seguradora" column-label "Seguradora"
    field tta_cod_apol_seguro              as character format "x(12)" label "Ap¢lice Seguro" column-label "Apolice Seguro"
    field tta_cod_arrendador               as character format "x(6)" label "Arrendador" column-label "Arrendador"
    field tta_cod_contrat_leas             as character format "x(12)" label "Contrato Leasing" column-label "Contr Leas"
    field tta_ind_tip_espec_docto          as character format "X(17)" initial "Normal" label "Tipo EspÇcie" column-label "Tipo EspÇcie"
    field tta_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda"
    field tta_num_seq_refer                as integer format ">>>9" initial 0 label "Sequància" column-label "Seq"
    field ttv_ind_motiv_alter_val_tit_ap   as character format "X(09)" initial "Alteraá∆o" label "Motivo Alteraá∆o" column-label "Motivo Alteraá∆o"
    field ttv_wgh_lista                    as widget-handle extent 15 format ">>>>>>9"
    field ttv_log_gera_ocor_alter_valores  as logical format "Sim/N∆o" initial no
    field tta_cb4_tit_ap_bco_cobdor        as Character format "x(50)" label "Titulo Bco Cobrador" column-label "Titulo Bco Cobrador"
    field tta_cod_histor_padr              as character format "x(8)" label "Hist¢rico Padr∆o" column-label "Hist¢rico Padr∆o"
    field tta_des_histor_padr              as character format "x(40)" label "Descriá∆o" column-label "Descriá∆o Hist¢rico Padr∆o"
    field tta_ind_sit_tit_ap               as character format "X(13)" label "Situaá∆o" column-label "Situaá∆o"
    field tta_cod_forma_pagto              as character format "x(3)" label "Forma Pagamento" column-label "F Pagto"
    index tt_titap_id                     
          tta_cod_estab                    ascending
          tta_cdn_fornecedor               ascending
          tta_cod_espec_docto              ascending
          tta_cod_ser_docto                ascending
          tta_cod_tit_ap                   ascending
          tta_cod_parcela                  ascending.


def temp-table tt_log_erros_tit_ap_alteracao no-undo
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field tta_cod_espec_docto              as character format "x(3)" label "EspÇcie Documento" column-label "EspÇcie"
    field tta_cod_ser_docto                as character format "x(3)" label "SÇrie Documento" column-label "SÇrie"
    field tta_cod_tit_ap                   as character format "x(10)" label "T°tulo" column-label "T°tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field tta_num_id_tit_ap                as integer format "9999999999" initial 0 label "Token Tit AP" column-label "Token Tit AP"
    field ttv_num_mensagem                 as integer format ">>>>,>>9" label "N£mero" column-label "N£mero Mensagem"
    field ttv_cod_tip_msg_dwb              as character format "x(12)" label "Tipo Mensagem" column-label "Tipo Mensagem"
    field ttv_des_msg_erro                 as character format "x(60)" label "Mensagem Erro" column-label "Inconsistància"
    field ttv_des_msg_ajuda_1              as character format "x(250)"
    field ttv_wgh_focus                    as widget-handle format ">>>>>>9".


def temp-table tt_tit_ap_alteracao_base_aux_1 no-undo
    field ttv_cod_usuar_corren             as character format "x(12)" label "Usu†rio Corrente" column-label "Usu†rio Corrente"
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_num_id_tit_ap                as integer format "9999999999" initial 0 label "Token Tit AP" column-label "Token Tit AP"
    field ttv_rec_tit_ap                   as recid format ">>>>>>9" initial ?
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field tta_cod_espec_docto              as character format "x(3)" label "EspÇcie Documento" column-label "EspÇcie"
    field tta_cod_ser_docto                as character format "x(3)" label "SÇrie Documento" column-label "SÇrie"
    field tta_cod_tit_ap                   as character format "x(10)" label "T°tulo" column-label "T°tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field ttv_dat_transacao                as date format "99/99/9999" label "Data Transaá∆o" column-label "Data Transaá∆o"
    field ttv_cod_refer                    as character format "x(10)" label "Referància" column-label "Referància"
    field tta_val_sdo_tit_ap               as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Saldo" column-label "Valor Saldo"
    field tta_dat_emis_docto               as date format "99/99/9999" initial today label "Data  Emiss∆o" column-label "Dt Emiss∆o"
    field tta_dat_vencto_tit_ap            as date format "99/99/9999" initial today label "Data Vencimento" column-label "Dt Vencto"
    field tta_dat_prev_pagto               as date format "99/99/9999" initial today label "Data Prevista Pgto" column-label "Dt Prev Pagto"
    field tta_dat_ult_pagto                as date format "99/99/9999" initial ? label "Data Èltimo Pagto" column-label "Data Èltimo Pagto"
    field tta_num_dias_atraso              as integer format ">9" initial 0 label "Dias Atraso" column-label "Dias Atr"
    field tta_val_perc_multa_atraso        as decimal format ">9.99" decimals 2 initial 00.00 label "Perc Multa Atraso" column-label "Multa Atr"
    field tta_val_juros_dia_atraso         as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Juro" column-label "Vl Juro"
    field tta_val_perc_juros_dia_atraso    as decimal format ">9.999999" decimals 6 initial 00.00 label "Perc Jur Dia Atraso" column-label "Perc Dia"
    field tta_dat_desconto                 as date format "99/99/9999" initial ? label "Data Desconto" column-label "Dt Descto"
    field tta_val_perc_desc                as decimal format ">9.9999" decimals 4 initial 0 label "Percentual Desconto" column-label "Perc Descto"
    field tta_val_desconto                 as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Desconto" column-label "Valor Desconto"
    field tta_cod_portador                 as character format "x(5)" label "Portador" column-label "Portador"
    field ttv_cod_portador_mov             as character format "x(5)" label "Portador Movto" column-label "Portador Movto"
    field tta_log_pagto_bloqdo             as logical format "Sim/N∆o" initial no label "Bloqueia Pagamento" column-label "Pagto Bloqdo"
    field tta_cod_seguradora               as character format "x(8)" label "Seguradora" column-label "Seguradora"
    field tta_cod_apol_seguro              as character format "x(12)" label "Ap¢lice Seguro" column-label "Apolice Seguro"
    field tta_cod_arrendador               as character format "x(6)" label "Arrendador" column-label "Arrendador"
    field tta_cod_contrat_leas             as character format "x(12)" label "Contrato Leasing" column-label "Contr Leas"
    field tta_ind_tip_espec_docto          as character format "X(17)" initial "Normal" label "Tipo EspÇcie" column-label "Tipo EspÇcie"
    field tta_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda"
    field tta_num_seq_refer                as integer format ">>>9" initial 0 label "Sequància" column-label "Seq"
    field ttv_ind_motiv_alter_val_tit_ap   as character format "X(09)" initial "Alteraá∆o" label "Motivo Alteraá∆o" column-label "Motivo Alteraá∆o"
    field ttv_wgh_lista                    as widget-handle extent 15 format ">>>>>>9"
    field ttv_log_gera_ocor_alter_valores  as logical format "Sim/N∆o" initial no
    field tta_cb4_tit_ap_bco_cobdor        as Character format "x(50)" label "Titulo Bco Cobrador" column-label "Titulo Bco Cobrador"
    field tta_cod_histor_padr              as character format "x(8)" label "Hist¢rico Padr∆o" column-label "Hist¢rico Padr∆o"
    field tta_des_histor_padr              as character format "x(40)" label "Descriá∆o" column-label "Descriá∆o Hist¢rico Padr∆o"
    field tta_ind_sit_tit_ap               as character format "X(13)" label "Situaá∆o" column-label "Situaá∆o"
    field tta_cod_forma_pagto              as character format "x(3)" label "Forma Pagamento" column-label "F Pagto"
    field tta_cod_tit_ap_bco_cobdor        as character format "x(50)" label "T°tulo Banco Cobdor" column-label "T°tulo Banco Cobdor"
    field tta_cod_estab_ext                as character format "x(8)" label "Estabelecimento Exte" column-label "Estabelecimento Ext"
    field tta_num_ord_invest               as integer format ">>>>,>>9" initial 0 label "Ordem Investimento" column-label "Ordem Investimento"
    field ttv_num_ped_compra               as integer format ">>>>>,>>9" initial 0 label "Ped Compra" column-label "Ped Compra"
    field tta_num_ord_compra               as integer format ">>>>>9,99" initial 0 label "Ordem Compra" column-label "Ordem Compra"
    field ttv_num_event_invest             as integer format ">,>>9" label "Evento Investimento" column-label "Evento Investimento"
    field ttv_val_1099                     as decimal format "->>,>>>,>>>,>>9.99" decimals 2
    field tta_cod_tax_ident_number         as character format "x(15)" label "Tax Id Number" column-label "Tax Id Number"
    field tta_ind_tip_trans_1099           as character format "X(50)" initial "Rents" label "Tipo Transacao 1099" column-label "Tipo Transacao 1099"
    index tt_titap_id                     
          tta_cod_estab                    ascending
          tta_cdn_fornecedor               ascending
          tta_cod_espec_docto              ascending
          tta_cod_ser_docto                ascending
          tta_cod_tit_ap                   ascending
          tta_cod_parcela                  ascending.

{esp/es0018.i}

DEF STREAM s_log.

DEF NEW GLOBAL SHARED VAR v_cod_empres_usuar AS CHARACTER FORMAT "x(3)" LABEL "Empresa" COLUMN-LABEL "Empresa" NO-UNDO.

DEF VAR v_cod_usuar_corren AS CHAR                  NO-UNDO.
DEF VAR h-acomp            AS HANDLE                NO-UNDO.
DEF VAR raw-tit-acr        AS RAW                   NO-UNDO.
DEF VAR v_dir_import       AS CHAR FORMAT "x(100)"  NO-UNDO.
DEF VAR v_dir_backup       AS CHAR FORMAT "x(100)"  NO-UNDO.
DEF VAR v_dir_log          AS CHAR FORMAT "x(100)"  NO-UNDO.
DEF VAR v_arq_log          AS CHAR FORMAT "x(100)"  NO-UNDO.
DEF VAR c-lin              AS CHAR                  NO-UNDO.
DEF VAR v_parcela          LIKE tit_ap.cod_parcela  NO-UNDO.
DEF VAR v_cod_tit_ap       LIKE tit_ap.cod_tit_ap   NO-UNDO.
DEF VAR i_cont             AS INT INIT 0            NO-UNDO.
DEF VAR v_tamanho          AS INT INIT 0            NO-UNDO.
DEF VAR v_hdl_program      AS HANDLE                NO-UNDO.
DEF VAR v_log_refer_uni    AS LOG                   NO-UNDO.
DEF VAR v_cod_refer        AS CHAR                  NO-UNDO.
DEF VAR i-seq-erro-aux     AS INT                   NO-UNDO.
DEF VAR v_num_seq_refer    AS INT                   NO-UNDO.

DEFINE STREAM s_import.

EMPTY TEMP-TABLE tt_tit_ap.
EMPTY TEMP-TABLE tt-param.
EMPTY TEMP-TABLE tt-arquivo.
EMPTY TEMP-TABLE tt-erro.

IF NOT VALID-HANDLE(h-acomp) THEN
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp NO-ERROR.

IF VALID-HANDLE(h-acomp) THEN
    RUN pi-inicializar IN h-acomp (INPUT "").

CREATE tt-param.
RAW-TRANSFER raw-param to tt-param.

IF  tt-param.rs-opcao = 1 THEN DO: /* baixar saldos */
    RUN esp/es0018p.p (INPUT "esapb036",
                       INPUT 1,
                       INPUT 0,
                       INPUT "",
                       OUTPUT TABLE tt-prog-ponto) NO-ERROR.
    
    FOR EACH tt-prog-ponto NO-LOCK:
        IF  tt-prog-ponto.conteudo                    <> "":U 
        AND NUM-ENTRIES(tt-prog-ponto.conteudo, ";":U) > 1 THEN DO:
    
            IF  OPSYS = "WIN32":U THEN DO:
                IF ENTRY(1, tt-prog-ponto.conteudo, ";":U) = "BAIXASWIN":U THEN
                    ASSIGN v_dir_import = ENTRY(2, tt-prog-ponto.conteudo, ";":U).
                IF ENTRY(1, tt-prog-ponto.conteudo, ";":U) = "BACKUPWIN":U THEN
                    ASSIGN v_dir_backup = ENTRY(2, tt-prog-ponto.conteudo, ";":U).
                IF ENTRY(1, tt-prog-ponto.conteudo, ";":U) = "LOGWIN":U THEN
                    ASSIGN v_dir_log    = ENTRY(2, tt-prog-ponto.conteudo, ";":U).
            END.
            ELSE DO:
                IF ENTRY(1, tt-prog-ponto.conteudo, ";":U) = "BAIXASUNIX":U THEN
                    ASSIGN v_dir_import = ENTRY(2, tt-prog-ponto.conteudo, ";":U).
                IF ENTRY(1, tt-prog-ponto.conteudo, ";":U) = "BACKUPUNIX":U THEN
                    ASSIGN v_dir_backup = ENTRY(2, tt-prog-ponto.conteudo, ";":U).
                IF ENTRY(1, tt-prog-ponto.conteudo, ";":U) = "LOGUNIX":U THEN
                    ASSIGN v_dir_log    = ENTRY(2, tt-prog-ponto.conteudo, ";":U).
            END.
        END.
    END.
    
    ASSIGN v_dir_import   = REPLACE(v_dir_import,  "~\":U, "/":U)
           v_dir_backup   = REPLACE(v_dir_backup, "~\":U, "/":U)
           v_dir_log      = REPLACE(v_dir_log, "~\":U, "/":U)
           i-seq-erro-aux = 0.
    
    FILE-INFO:FILE-NAME = v_dir_import.
    
    IF  FILE-INFO:FULL-PATHNAME           = ?
    OR  FILE-INFO:FULL-PATHNAME           = "":U 
    OR  INDEX(FILE-INFO:FILE-TYPE, "D":U) = 0 THEN DO:
        ASSIGN i-seq-erro-aux = i-seq-erro-aux + 1.
    
        CREATE tt-erro.
        ASSIGN tt-erro.i-sequen = i-seq-erro-aux
               tt-erro.tipo     = 1
               tt-erro.cd-erro  = 17006
               tt-erro.mensagem = "Baixas - Diret¢rio de baixas " + v_dir_import + " n∆o localizado.".
    END.
    
    FILE-INFO:FILE-NAME = v_dir_backup.
    
    IF  FILE-INFO:FULL-PATHNAME           = ?    
    OR  FILE-INFO:FULL-PATHNAME           = "":U 
    OR  INDEX(FILE-INFO:FILE-TYPE, "D":U) = 0 THEN DO:
        ASSIGN i-seq-erro-aux = i-seq-erro-aux + 1.
    
        CREATE tt-erro.
        ASSIGN tt-erro.i-sequen = i-seq-erro-aux
               tt-erro.tipo     = 1
               tt-erro.cd-erro  = 17006
               tt-erro.mensagem = "Baixas - Diret¢rio de backups " + v_dir_backup + " n∆o localizado.".
    END.
    
    FILE-INFO:FILE-NAME = v_dir_log.
    
    IF  FILE-INFO:FULL-PATHNAME           = ?    
    OR  FILE-INFO:FULL-PATHNAME           = "":U 
    OR  INDEX(FILE-INFO:FILE-TYPE, "D":U) = 0 THEN DO:
        ASSIGN i-seq-erro-aux = i-seq-erro-aux + 1.
    
        CREATE tt-erro.
        ASSIGN tt-erro.i-sequen = i-seq-erro-aux
               tt-erro.tipo     = 1
               tt-erro.cd-erro  = 17006
               tt-erro.mensagem = "Baixas - Diret¢rio de logs " + v_dir_backup + " n∆o localizado.".
    END.
    
    IF  NOT CAN-FIND(FIRST tt-erro) THEN DO:
    
        INPUT STREAM s_import FROM OS-DIR(v_dir_import) NO-ECHO.
        REPEAT:
            CREATE tt-arquivo.
            IMPORT STREAM s_import tt-arquivo.nom-arquivo
                                   tt-arquivo.nom-completo
                                   tt-arquivo.ind-tipo-arquivo.
        END.
        INPUT STREAM s_import CLOSE.
        
        FOR EACH tt-arquivo:
            IF VALID-HANDLE(h-acomp) THEN
                RUN pi-acompanhar IN h-acomp (INPUT "Arquivo: ":U + TRIM(tt-arquivo.nom-arquivo)).
        
            IF  NOT tt-arquivo.nom-arquivo BEGINS "BX-APB":U
            OR  tt-arquivo.ind-tipo-arquivo    <> "F":U      THEN
                DELETE tt-arquivo.
        END.
        
        FOR EACH tt-arquivo:
    
            EMPTY TEMP-TABLE tt_tit_ap.
    
            bloco_baixas:
            DO TRANSACTION ON ERROR UNDO bloco_baixas,  LEAVE bloco_baixas:
    
                INPUT FROM VALUE(tt-arquivo.nom-completo).
                IMPORT UNFORMATTED c-lin.
                
                REPEAT:
                    IMPORT UNFORMATTED c-lin.
                
                    ASSIGN v_cod_tit_ap = trim(ENTRY(4,c-lin,";"))
                           v_parcela    = trim(ENTRY(5,c-lin,";")).
                    
                    CREATE tt_tit_ap.
                    ASSIGN tt_tit_ap.cod_estab       = ENTRY(1,c-lin,";")
                           tt_tit_ap.cod_espec_docto = ENTRY(2,c-lin,";")
                           tt_tit_ap.cod_ser_docto   = ENTRY(3,c-lin,";")
                           tt_tit_ap.cod_tit_ap      = v_cod_tit_ap
                           tt_tit_ap.cod_parcela     = v_parcela
                           tt_tit_ap.cdn_fornec      = int(ENTRY(6,c-lin,";"))
                           tt_tit_ap.dat_baixa       = date(ENTRY(7,c-lin,";"))
                           tt_tit_ap.val_baixa       = dec(ENTRY(8,c-lin,";"))
                           tt_tit_ap.cod_conta       = ENTRY(9,c-lin,";")
                           tt_tit_ap.cod_ccusto      = ENTRY(10,c-lin,";")
                           tt_tit_ap.cod_unid_negoc  = ENTRY(11,c-lin,";").
                
                    RUN pi-acompanhar IN h-acomp (INPUT "Importando titulos " + STRING(tt_tit_ap.cod_tit_ap)).
                END.
            
                EMPTY TEMP-TABLE tt_log_erros_tit_ap_alteracao NO-ERROR.
                
                ASSIGN v_num_seq_refer = 0.
    
                FOR EACH tt_tit_ap NO-LOCK:
    
                    RUN pi-acompanhar IN h-acomp (INPUT "Baixando t°tulo: " + STRING(tt_tit_ap.cod_tit_ap)).
                
                    EMPTY TEMP-TABLE tt_tit_ap_alteracao_base_aux_1 NO-ERROR.
                    EMPTY TEMP-TABLE tt_tit_ap_alteracao_rateio     NO-ERROR.
                    EMPTY TEMP-TABLE tt_log_erros_tit_ap_alteracao  NO-ERROR.
    
                    FIND FIRST tit_ap
                         WHERE tit_ap.cod_estab       = tt_tit_ap.cod_estab   
                         AND   tit_ap.cdn_fornec      = tt_tit_ap.cdn_fornec
                         AND   tit_ap.cod_espec_docto = tt_tit_ap.cod_espec_docto
                         AND   tit_ap.cod_ser_docto   = tt_tit_ap.cod_ser_docto  
                         AND   tit_ap.cod_tit_ap      = tt_tit_ap.cod_tit_ap    
                         AND   tit_ap.cod_parcela     = tt_tit_ap.cod_parcela NO-LOCK NO-ERROR.
                
                    IF  NOT AVAIL tit_ap THEN DO:
                        ASSIGN i-seq-erro-aux = i-seq-erro-aux + 1.
                
                        CREATE tt-erro.
                        ASSIGN tt-erro.i-sequen        = i-seq-erro-aux
                               tt-erro.tipo            = 1
                               tt-erro.cod_estab       = tt_tit_ap.cod_estab      
                               tt-erro.cod_espec_docto = tt_tit_ap.cod_espec_docto
                               tt-erro.cod_ser_docto   = tt_tit_ap.cod_ser_docto  
                               tt-erro.cod_tit_ap      = tt_tit_ap.cod_tit_ap    
                               tt-erro.cod_parcela     = tt_tit_ap.cod_parcela
                               tt-erro.cdn_fornec      = tt_tit_ap.cdn_fornec
                               tt-erro.cd-erro         = 17006
                               tt-erro.mensagem        = "T°tulo n∆o localizado para a chave informada.".
    
                        /*UNDO bloco_baixas, LEAVE bloco_baixas.*/
                    END.
                    ELSE DO:
                        ASSIGN v_num_seq_refer = v_num_seq_refer + 1
                               v_log_refer_uni = NO.
    
                        REPEAT WHILE v_log_refer_uni = NO:
                           RUN pi_retorna_sugestao_referencia (INPUT "C",
                                                               INPUT TODAY,
                                                               OUTPUT v_cod_refer).
                           
                           RUN pi_verifica_refer_unica_apb (INPUT tt_tit_ap.cod_estab,
                                                            INPUT v_cod_refer,
                                                            OUTPUT v_log_refer_uni).
                        END.
                    
                        CREATE tt_tit_ap_alteracao_base_aux_1.
                        ASSIGN tt_tit_ap_alteracao_base_aux_1.ttv_cod_usuar_corren              = v_cod_usuar_corren          
                               tt_tit_ap_alteracao_base_aux_1.tta_cod_empresa                   = tit_ap.cod_empresa
                               tt_tit_ap_alteracao_base_aux_1.tta_cod_estab                     = tit_ap.cod_estab
                               tt_tit_ap_alteracao_base_aux_1.tta_num_id_tit_ap                 = tit_ap.num_id_tit_ap
                               tt_tit_ap_alteracao_base_aux_1.ttv_rec_tit_ap                    = RECID(tit_ap)
                               tt_tit_ap_alteracao_base_aux_1.ttv_dat_transacao                 = tt_tit_ap.dat_baixa
                               tt_tit_ap_alteracao_base_aux_1.ttv_cod_refer                     = v_cod_refer
                               tt_tit_ap_alteracao_base_aux_1.tta_val_sdo_tit_ap                = tit_ap.val_sdo_tit_ap - tt_tit_ap.val_baixa
                               tt_tit_ap_alteracao_base_aux_1.tta_num_seq_refer                 = v_num_seq_refer
                               tt_tit_ap_alteracao_base_aux_1.ttv_ind_motiv_alter_val_tit_ap    = "Baixa"
                               tt_tit_ap_alteracao_base_aux_1.tta_ind_sit_tit_ap                = tit_ap.ind_sit_tit_ap
                               tt_tit_ap_alteracao_base_aux_1.tta_dat_emis_docto                = tit_ap.dat_emis_docto
                               tt_tit_ap_alteracao_base_aux_1.tta_dat_vencto_tit_ap             = tit_ap.dat_vencto_tit_ap
                               tt_tit_ap_alteracao_base_aux_1.tta_dat_prev_pagto                = tit_ap.dat_vencto_tit_ap
                               tt_tit_ap_alteracao_base_aux_1.tta_dat_ult_pagto                 = tit_ap.dat_prev_pagto
                               tt_tit_ap_alteracao_base_aux_1.tta_num_dias_atraso               = tit_ap.num_dias_atraso
                               tt_tit_ap_alteracao_base_aux_1.tta_val_perc_multa_atraso         = tit_ap.val_perc_multa_atraso
                               tt_tit_ap_alteracao_base_aux_1.tta_val_juros_dia_atraso          = tit_ap.val_juros_dia_atraso
                               tt_tit_ap_alteracao_base_aux_1.tta_val_perc_juros_dia_atraso     = tit_ap.val_perc_juros_dia_atraso
                               tt_tit_ap_alteracao_base_aux_1.tta_dat_desconto                  = tit_ap.dat_desconto
                               tt_tit_ap_alteracao_base_aux_1.tta_val_perc_desc                 = tit_ap.val_perc_desc
                               tt_tit_ap_alteracao_base_aux_1.tta_val_desconto                  = tit_ap.val_desconto
                               tt_tit_ap_alteracao_base_aux_1.tta_cod_indic_econ                = tit_ap.cod_indic_econ.
                        VALIDATE tt_tit_ap_alteracao_base_aux_1.
    
                        IF  tt_tit_ap.cod_conta <> "" THEN DO:
                            CREATE tt_tit_ap_alteracao_rateio.
                            ASSIGN tt_tit_ap_alteracao_rateio.ttv_rec_tit_ap            = RECID(tit_ap)
                                   tt_tit_ap_alteracao_rateio.tta_cod_estab             = tit_ap.cod_estab
                                   tt_tit_ap_alteracao_rateio.tta_num_id_tit_ap         = tit_ap.num_id_tit_ap
                                   tt_tit_ap_alteracao_rateio.tta_cod_refer             = v_cod_refer
                                   tt_tit_ap_alteracao_rateio.tta_num_seq_refer         = v_num_seq_refer
                                   tt_tit_ap_alteracao_rateio.tta_cod_plano_cta_ctbl    = "PADRAO"
                                   tt_tit_ap_alteracao_rateio.tta_cod_unid_negoc        = "" /*tt_tit_ap.cod_unid_negoc*/
                                   tt_tit_ap_alteracao_rateio.tta_cod_cta_ctbl          = tt_tit_ap.cod_conta
                                   tt_tit_ap_alteracao_rateio.tta_num_id_aprop_ctbl_ap  = ?
                                   tt_tit_ap_alteracao_rateio.ttv_ind_tip_rat           = "Valor"
                                   tt_tit_ap_alteracao_rateio.tta_val_aprop_ctbl        = tt_tit_ap.val_baixa.
        
                            IF  tt_tit_ap.cod_ccusto <> "" THEN
                                ASSIGN tt_tit_ap_alteracao_rateio.tta_cod_plano_ccusto = "Padrao"
                                       tt_tit_ap_alteracao_rateio.tta_cod_ccusto       = tt_tit_ap.cod_ccusto.
        
                            VALIDATE tt_tit_ap_alteracao_rateio. 
                        END.

                        IF  CAN-FIND(FIRST tt_tit_ap_alteracao_base_aux_1) THEN 
                            RUN prgfin/apb/apb767ze.py(INPUT 1,
                                                       INPUT "",
                                                       INPUT "",
                                                       INPUT-OUTPUT TABLE tt_tit_ap_alteracao_base_aux_1,
                                                       INPUT-OUTPUT TABLE tt_tit_ap_alteracao_rateio,
                                                       OUTPUT TABLE tt_log_erros_tit_ap_alteracao).
                    
                        IF  CAN-FIND(FIRST tt_log_erros_tit_ap_alteracao WHERE tt_log_erros_tit_ap_alteracao.ttv_num_mensagem <> 6542) THEN DO:
                            FOR EACH tt_log_erros_tit_ap_alteracao:
                                ASSIGN i-seq-erro-aux = i-seq-erro-aux + 1.
                                
                                CREATE tt-erro.
                                ASSIGN tt-erro.i-sequen        = i-seq-erro-aux
                                       tt-erro.tipo            = 1
                                       tt-erro.cod_estab       = tt_tit_ap.cod_estab      
                                       tt-erro.cod_espec_docto = tt_tit_ap.cod_espec_docto
                                       tt-erro.cod_ser_docto   = tt_tit_ap.cod_ser_docto  
                                       tt-erro.cod_tit_ap      = tt_tit_ap.cod_tit_ap    
                                       tt-erro.cod_parcela     = tt_tit_ap.cod_parcela
                                       tt-erro.cdn_fornec      = tt_tit_ap.cdn_fornec
                                       tt-erro.cd-erro         = tt_log_erros_tit_ap_alteracao.ttv_num_mensagem
                                       tt-erro.mensagem        = tt_log_erros_tit_ap_alteracao.ttv_des_msg_erro + tt_log_erros_tit_ap_alteracao.ttv_des_msg_ajuda.
    
                                /*UNDO bloco_baixas, LEAVE bloco_baixas.*/
                            END.
                        END.
                        ELSE DO:
                            ASSIGN i-seq-erro-aux = i-seq-erro-aux + 1.
            
                            CREATE tt-erro.
                            ASSIGN tt-erro.i-sequen        = i-seq-erro-aux
                                   tt-erro.tipo            = 2
                                   tt-erro.cod_estab       = tt_tit_ap.cod_estab      
                                   tt-erro.cod_espec_docto = tt_tit_ap.cod_espec_docto
                                   tt-erro.cod_ser_docto   = tt_tit_ap.cod_ser_docto  
                                   tt-erro.cod_tit_ap      = tt_tit_ap.cod_tit_ap    
                                   tt-erro.cod_parcela     = tt_tit_ap.cod_parcela
                                   tt-erro.cdn_fornec      = tt_tit_ap.cdn_fornec
                                   tt-erro.cd-erro         = 0
                                   tt-erro.mensagem        = "Baixa efetuada com sucesso.".
                        END.
                    END.
                END.
            END.
            
            IF  NOT CAN-FIND(FIRST tt-erro WHERE tt-erro.tipo = 1) THEN DO:
                OS-COPY   VALUE(tt-arquivo.nom-completo) VALUE(v_dir_backup + tt-arquivo.nom-arquivo).
                OS-DELETE VALUE(tt-arquivo.nom-completo) NO-ERROR.
            END.
    
            ASSIGN v_arq_log = v_dir_log + "log_" + tt-arquivo.nom-arquivo.
    
            OUTPUT STREAM s_log TO VALUE(v_arq_log).
    
            PUT STREAM s_log UNFORMATTED "Erros;;;;;;" SKIP.
            PUT STREAM s_log UNFORMATTED "Estab;Esp;Ser;T°tulo;Parc;Fornec;Cod Erro;Mensagem" SKIP.
    
            FOR EACH tt-erro
                WHERE tt-erro.tipo = 1:
    
                PUT STREAM s_log UNFORMATTED tt-erro.cod_estab ";"
                     tt-erro.cod_espec_docto      ";"
                     tt-erro.cod_ser_docto        ";"
                     tt-erro.cod_tit_ap           ";"
                     tt-erro.cod_parcela          ";"
                     tt-erro.cdn_fornec           ";"
                     tt-erro.cd-erro              ";"
                     tt-erro.mensagem SKIP.
            END.
    
            PUT STREAM s_log UNFORMATTED SKIP(2) "Baixas Atualizadas;;;;;" SKIP.
            PUT STREAM s_log UNFORMATTED "Estab;Esp;Ser;T°tulo;Parc;Fornec;Mensagem" SKIP.
            FOR EACH tt-erro
                WHERE tt-erro.tipo = 2:
    
                PUT STREAM s_log UNFORMATTED tt-erro.cod_estab ";"
                     tt-erro.cod_espec_docto      ";"
                     tt-erro.cod_ser_docto        ";"
                     tt-erro.cod_tit_ap           ";"
                     tt-erro.cod_parcela          ";"
                     tt-erro.cdn_fornec           ";"
                     tt-erro.mensagem SKIP.
            END.
            
            OUTPUT STREAM s_log CLOSE.
    
            EMPTY TEMP-TABLE tt-erro.
        END.
    END.
END.
ELSE DO:
    RUN esp/es0018p.p (INPUT "esapb036",
                       INPUT 2,
                       INPUT 0,
                       INPUT "",
                       OUTPUT TABLE tt-prog-ponto) NO-ERROR.
    
    FOR EACH tt-prog-ponto NO-LOCK:
        IF  tt-prog-ponto.conteudo                    <> "":U 
        AND NUM-ENTRIES(tt-prog-ponto.conteudo, ";":U) > 1 THEN DO:
    
            IF  OPSYS = "WIN32":U THEN DO:
                IF ENTRY(1, tt-prog-ponto.conteudo, ";":U) = "VENCTOWIN":U THEN
                    ASSIGN v_dir_import = ENTRY(2, tt-prog-ponto.conteudo, ";":U).
                IF ENTRY(1, tt-prog-ponto.conteudo, ";":U) = "BACKUPWIN":U THEN
                    ASSIGN v_dir_backup = ENTRY(2, tt-prog-ponto.conteudo, ";":U).
                IF ENTRY(1, tt-prog-ponto.conteudo, ";":U) = "LOGWIN":U THEN
                    ASSIGN v_dir_log    = ENTRY(2, tt-prog-ponto.conteudo, ";":U).
            END.
            ELSE DO:
                IF ENTRY(1, tt-prog-ponto.conteudo, ";":U) = "VENCTOUNIX":U THEN
                    ASSIGN v_dir_import = ENTRY(2, tt-prog-ponto.conteudo, ";":U).
                IF ENTRY(1, tt-prog-ponto.conteudo, ";":U) = "BACKUPUNIX":U THEN
                    ASSIGN v_dir_backup = ENTRY(2, tt-prog-ponto.conteudo, ";":U).
                IF ENTRY(1, tt-prog-ponto.conteudo, ";":U) = "LOGUNIX":U THEN
                    ASSIGN v_dir_log    = ENTRY(2, tt-prog-ponto.conteudo, ";":U).
            END.
        END.
    END.
    
    ASSIGN v_dir_import   = REPLACE(v_dir_import,  "~\":U, "/":U)
           v_dir_backup   = REPLACE(v_dir_backup, "~\":U, "/":U)
           v_dir_log      = REPLACE(v_dir_log, "~\":U, "/":U)
           i-seq-erro-aux = 0.
    
    FILE-INFO:FILE-NAME = v_dir_import.
    
    IF  FILE-INFO:FULL-PATHNAME           = ?
    OR  FILE-INFO:FULL-PATHNAME           = "":U 
    OR  INDEX(FILE-INFO:FILE-TYPE, "D":U) = 0 THEN DO:
        ASSIGN i-seq-erro-aux = i-seq-erro-aux + 1.
    
        CREATE tt-erro.
        ASSIGN tt-erro.i-sequen = i-seq-erro-aux
               tt-erro.tipo     = 1
               tt-erro.cd-erro  = 17006
               tt-erro.mensagem = "Vencto - Diret¢rio de alteraá‰es " + v_dir_import + " n∆o localizado.".
    END.
    
    FILE-INFO:FILE-NAME = v_dir_backup.
    
    IF  FILE-INFO:FULL-PATHNAME           = ?    
    OR  FILE-INFO:FULL-PATHNAME           = "":U 
    OR  INDEX(FILE-INFO:FILE-TYPE, "D":U) = 0 THEN DO:
        ASSIGN i-seq-erro-aux = i-seq-erro-aux + 1.
    
        CREATE tt-erro.
        ASSIGN tt-erro.i-sequen = i-seq-erro-aux
               tt-erro.tipo     = 1
               tt-erro.cd-erro  = 17006
               tt-erro.mensagem = "Vencto - Diret¢rio de backups " + v_dir_backup + " n∆o localizado.".
    END.
    
    FILE-INFO:FILE-NAME = v_dir_log.
    
    IF  FILE-INFO:FULL-PATHNAME           = ?    
    OR  FILE-INFO:FULL-PATHNAME           = "":U 
    OR  INDEX(FILE-INFO:FILE-TYPE, "D":U) = 0 THEN DO:
        ASSIGN i-seq-erro-aux = i-seq-erro-aux + 1.
    
        CREATE tt-erro.
        ASSIGN tt-erro.i-sequen = i-seq-erro-aux
               tt-erro.tipo     = 1
               tt-erro.cd-erro  = 17006
               tt-erro.mensagem = "Vencto - Diret¢rio de logs " + v_dir_backup + " n∆o localizado.".
    END.
    
    IF  NOT CAN-FIND(FIRST tt-erro) THEN DO:
    
        INPUT STREAM s_import FROM OS-DIR(v_dir_import) NO-ECHO.
        REPEAT:
            CREATE tt-arquivo.
            IMPORT STREAM s_import tt-arquivo.nom-arquivo
                                   tt-arquivo.nom-completo
                                   tt-arquivo.ind-tipo-arquivo.
        END.
        INPUT STREAM s_import CLOSE.
        
        FOR EACH tt-arquivo:
            IF VALID-HANDLE(h-acomp) THEN
                RUN pi-acompanhar IN h-acomp (INPUT "Arquivo: ":U + TRIM(tt-arquivo.nom-arquivo)).
        
            IF  NOT tt-arquivo.nom-arquivo BEGINS "VENC-APB":U
            OR  tt-arquivo.ind-tipo-arquivo    <> "F":U      THEN
                DELETE tt-arquivo.
        END.
        
        FOR EACH tt-arquivo:
    
            EMPTY TEMP-TABLE tt_tit_ap.
    
            bloco_baixas:
            DO TRANSACTION ON ERROR UNDO bloco_baixas,  LEAVE bloco_baixas:
    
                INPUT FROM VALUE(tt-arquivo.nom-completo).
                IMPORT UNFORMATTED c-lin.
                
                REPEAT:
                    IMPORT UNFORMATTED c-lin.
                
                    ASSIGN v_cod_tit_ap = trim(ENTRY(4,c-lin,";"))
                           v_parcela    = trim(ENTRY(5,c-lin,";")).
                    
                    CREATE tt_tit_ap.
                    ASSIGN tt_tit_ap.cod_estab       = ENTRY(1,c-lin,";")
                           tt_tit_ap.cod_espec_docto = ENTRY(2,c-lin,";")
                           tt_tit_ap.cod_ser_docto   = ENTRY(3,c-lin,";")
                           tt_tit_ap.cod_tit_ap      = v_cod_tit_ap
                           tt_tit_ap.cod_parcela     = v_parcela
                           tt_tit_ap.cdn_fornec      = int(ENTRY(6,c-lin,";"))
                           tt_tit_ap.dat_baixa       = date(ENTRY(7,c-lin,";")).
                
                    RUN pi-acompanhar IN h-acomp (INPUT "Importando titulos " + STRING(tt_tit_ap.cod_tit_ap)).
                END.
            
                EMPTY TEMP-TABLE tt_log_erros_tit_ap_alteracao NO-ERROR.
                
                ASSIGN v_num_seq_refer = 0.
    
                FOR EACH tt_tit_ap NO-LOCK:
    
                    RUN pi-acompanhar IN h-acomp (INPUT "Alterando vencimento t°tulo: " + STRING(tt_tit_ap.cod_tit_ap)).
                
                    EMPTY TEMP-TABLE tt_tit_ap_alteracao_base_aux_1 NO-ERROR.
                    EMPTY TEMP-TABLE tt_tit_ap_alteracao_rateio     NO-ERROR.
                    EMPTY TEMP-TABLE tt_log_erros_tit_ap_alteracao  NO-ERROR.
    
                    FIND FIRST tit_ap
                         WHERE tit_ap.cod_estab       = tt_tit_ap.cod_estab   
                         AND   tit_ap.cdn_fornec      = tt_tit_ap.cdn_fornec
                         AND   tit_ap.cod_espec_docto = tt_tit_ap.cod_espec_docto
                         AND   tit_ap.cod_ser_docto   = tt_tit_ap.cod_ser_docto  
                         AND   tit_ap.cod_tit_ap      = tt_tit_ap.cod_tit_ap    
                         AND   tit_ap.cod_parcela     = tt_tit_ap.cod_parcela NO-LOCK NO-ERROR.
                
                    IF  NOT AVAIL tit_ap THEN DO:
                        ASSIGN i-seq-erro-aux = i-seq-erro-aux + 1.
                
                        CREATE tt-erro.
                        ASSIGN tt-erro.i-sequen        = i-seq-erro-aux
                               tt-erro.tipo            = 1
                               tt-erro.cod_estab       = tt_tit_ap.cod_estab      
                               tt-erro.cod_espec_docto = tt_tit_ap.cod_espec_docto
                               tt-erro.cod_ser_docto   = tt_tit_ap.cod_ser_docto  
                               tt-erro.cod_tit_ap      = tt_tit_ap.cod_tit_ap    
                               tt-erro.cod_parcela     = tt_tit_ap.cod_parcela
                               tt-erro.cdn_fornec      = tt_tit_ap.cdn_fornec
                               tt-erro.cd-erro         = 17006
                               tt-erro.mensagem        = "T°tulo n∆o localizado para a chave informada.".
    
                        /*UNDO bloco_baixas, LEAVE bloco_baixas.*/
                    END.
                    ELSE DO:
                        ASSIGN v_num_seq_refer = v_num_seq_refer + 1
                               v_log_refer_uni = NO.
    
                        REPEAT WHILE v_log_refer_uni = NO:
                           RUN pi_retorna_sugestao_referencia (INPUT "C",
                                                               INPUT TODAY,
                                                               OUTPUT v_cod_refer).
                           
                           RUN pi_verifica_refer_unica_apb (INPUT tt_tit_ap.cod_estab,
                                                            INPUT v_cod_refer,
                                                            OUTPUT v_log_refer_uni).
                        END.
                    
                        CREATE tt_tit_ap_alteracao_base_aux_1.
                        ASSIGN tt_tit_ap_alteracao_base_aux_1.ttv_cod_usuar_corren              = v_cod_usuar_corren          
                               tt_tit_ap_alteracao_base_aux_1.tta_cod_empresa                   = tit_ap.cod_empresa
                               tt_tit_ap_alteracao_base_aux_1.tta_cod_estab                     = tit_ap.cod_estab
                               tt_tit_ap_alteracao_base_aux_1.tta_num_id_tit_ap                 = tit_ap.num_id_tit_ap
                               tt_tit_ap_alteracao_base_aux_1.ttv_rec_tit_ap                    = RECID(tit_ap)
                               tt_tit_ap_alteracao_base_aux_1.ttv_dat_transacao                 = TODAY
                               tt_tit_ap_alteracao_base_aux_1.ttv_cod_refer                     = v_cod_refer
                               tt_tit_ap_alteracao_base_aux_1.tta_val_sdo_tit_ap                = tit_ap.val_sdo_tit_ap
                               tt_tit_ap_alteracao_base_aux_1.tta_num_seq_refer                 = v_num_seq_refer
                               tt_tit_ap_alteracao_base_aux_1.ttv_ind_motiv_alter_val_tit_ap    = "Alteraá∆o"
                               tt_tit_ap_alteracao_base_aux_1.tta_ind_sit_tit_ap                = tit_ap.ind_sit_tit_ap
                               tt_tit_ap_alteracao_base_aux_1.tta_dat_emis_docto                = tit_ap.dat_emis_docto
                               tt_tit_ap_alteracao_base_aux_1.tta_dat_vencto_tit_ap             = tt_tit_ap.dat_baixa
                               tt_tit_ap_alteracao_base_aux_1.tta_dat_prev_pagto                = tt_tit_ap.dat_baixa
                               tt_tit_ap_alteracao_base_aux_1.tta_dat_ult_pagto                 = tit_ap.dat_ult_pagto
                               tt_tit_ap_alteracao_base_aux_1.tta_num_dias_atraso               = tit_ap.num_dias_atraso
                               tt_tit_ap_alteracao_base_aux_1.tta_val_perc_multa_atraso         = tit_ap.val_perc_multa_atraso
                               tt_tit_ap_alteracao_base_aux_1.tta_val_juros_dia_atraso          = tit_ap.val_juros_dia_atraso
                               tt_tit_ap_alteracao_base_aux_1.tta_val_perc_juros_dia_atraso     = tit_ap.val_perc_juros_dia_atraso
                               tt_tit_ap_alteracao_base_aux_1.tta_dat_desconto                  = tit_ap.dat_desconto
                               tt_tit_ap_alteracao_base_aux_1.tta_val_perc_desc                 = tit_ap.val_perc_desc
                               tt_tit_ap_alteracao_base_aux_1.tta_val_desconto                  = tit_ap.val_desconto
                               tt_tit_ap_alteracao_base_aux_1.tta_cod_indic_econ                = tit_ap.cod_indic_econ.
                        VALIDATE tt_tit_ap_alteracao_base_aux_1.
    
                        IF  CAN-FIND(FIRST tt_tit_ap_alteracao_base_aux_1) THEN 
                            RUN prgfin/apb/apb767ze.py(INPUT 1,
                                                       INPUT "",
                                                       INPUT "",
                                                       INPUT-OUTPUT TABLE tt_tit_ap_alteracao_base_aux_1,
                                                       INPUT-OUTPUT TABLE tt_tit_ap_alteracao_rateio,
                                                       OUTPUT TABLE tt_log_erros_tit_ap_alteracao).
                    
                        IF  CAN-FIND(FIRST tt_log_erros_tit_ap_alteracao) THEN DO:
                            FOR EACH tt_log_erros_tit_ap_alteracao:
                                ASSIGN i-seq-erro-aux = i-seq-erro-aux + 1.
                                
                                CREATE tt-erro.
                                ASSIGN tt-erro.i-sequen        = i-seq-erro-aux
                                       tt-erro.tipo            = 1
                                       tt-erro.cod_estab       = tt_tit_ap.cod_estab      
                                       tt-erro.cod_espec_docto = tt_tit_ap.cod_espec_docto
                                       tt-erro.cod_ser_docto   = tt_tit_ap.cod_ser_docto  
                                       tt-erro.cod_tit_ap      = tt_tit_ap.cod_tit_ap    
                                       tt-erro.cod_parcela     = tt_tit_ap.cod_parcela
                                       tt-erro.cdn_fornec      = tt_tit_ap.cdn_fornec
                                       tt-erro.cd-erro         = tt_log_erros_tit_ap_alteracao.ttv_num_mensagem
                                       tt-erro.mensagem        = tt_log_erros_tit_ap_alteracao.ttv_des_msg_erro + tt_log_erros_tit_ap_alteracao.ttv_des_msg_ajuda.
    
                                /*UNDO bloco_baixas, LEAVE bloco_baixas.*/
                            END.
                        END.
                        ELSE DO:
                            ASSIGN i-seq-erro-aux = i-seq-erro-aux + 1.
            
                            CREATE tt-erro.
                            ASSIGN tt-erro.i-sequen        = i-seq-erro-aux
                                   tt-erro.tipo            = 2
                                   tt-erro.cod_estab       = tt_tit_ap.cod_estab      
                                   tt-erro.cod_espec_docto = tt_tit_ap.cod_espec_docto
                                   tt-erro.cod_ser_docto   = tt_tit_ap.cod_ser_docto  
                                   tt-erro.cod_tit_ap      = tt_tit_ap.cod_tit_ap    
                                   tt-erro.cod_parcela     = tt_tit_ap.cod_parcela
                                   tt-erro.cdn_fornec      = tt_tit_ap.cdn_fornec
                                   tt-erro.cd-erro         = 0
                                   tt-erro.mensagem        = "Vencimento alterado para " + string(tt_tit_ap.dat_baixa,"99/99/9999") + " com sucesso.".
                        END.
                    END.
                END.
            END.
            
            IF  NOT CAN-FIND(FIRST tt-erro WHERE tt-erro.tipo = 1) THEN DO:
                OS-COPY   VALUE(tt-arquivo.nom-completo) VALUE(v_dir_backup + tt-arquivo.nom-arquivo).
                OS-DELETE VALUE(tt-arquivo.nom-completo) NO-ERROR.
            END.
    
            ASSIGN v_arq_log = v_dir_log + "log_" + tt-arquivo.nom-arquivo.
    
            OUTPUT STREAM s_log TO VALUE(v_arq_log).
    
            PUT STREAM s_log UNFORMATTED "Erros;;;;;;" SKIP.
            PUT STREAM s_log UNFORMATTED "Estab;Esp;Ser;T°tulo;Parc;Fornec;Cod Erro;Mensagem" SKIP.
    
            FOR EACH tt-erro
                WHERE tt-erro.tipo = 1:
    
                PUT STREAM s_log UNFORMATTED tt-erro.cod_estab ";"
                     tt-erro.cod_espec_docto      ";"
                     tt-erro.cod_ser_docto        ";"
                     tt-erro.cod_tit_ap           ";"
                     tt-erro.cod_parcela          ";"
                     tt-erro.cdn_fornec           ";"
                     tt-erro.cd-erro              ";"
                     tt-erro.mensagem SKIP.
            END.
    
            PUT STREAM s_log UNFORMATTED SKIP(2) "Vencimentos Alterados;;;;;" SKIP.
            PUT STREAM s_log UNFORMATTED "Estab;Esp;Ser;T°tulo;Parc;Fornec;Mensagem" SKIP.
            FOR EACH tt-erro
                WHERE tt-erro.tipo = 2:
    
                PUT STREAM s_log UNFORMATTED tt-erro.cod_estab ";"
                     tt-erro.cod_espec_docto      ";"
                     tt-erro.cod_ser_docto        ";"
                     tt-erro.cod_tit_ap           ";"
                     tt-erro.cod_parcela          ";"
                     tt-erro.cdn_fornec           ";"
                     tt-erro.mensagem SKIP.
            END.
            
            OUTPUT STREAM s_log CLOSE.
    
            EMPTY TEMP-TABLE tt-erro.
        END.
    END.
END.

RUN pi-finalizar IN h-acomp.

RETURN "OK".


PROCEDURE pi_retorna_sugestao_referencia:

    /************************ Parameter Definition Begin ************************/

    def Input param p_ind_tip_atualiz
        as character
        format "X(08)"
        no-undo.
    def Input param p_dat_refer
        as date
        format "99/99/9999"
        no-undo.
    def output param p_cod_refer
        as character
        format "x(10)"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_des_dat                        as character       no-undo. /*local*/
    def var v_num_aux                        as integer         no-undo. /*local*/
    def var v_num_aux_2                      as integer         no-undo. /*local*/
    def var v_num_cont                       as integer         no-undo. /*local*/


    /************************** Variable Definition End *************************/

    assign v_des_dat   = string(p_dat_refer,"99999999")
           p_cod_refer = substring(v_des_dat,7,2)
                       + substring(v_des_dat,3,2)
                       + substring(v_des_dat,1,2)
                       + substring(p_ind_tip_atualiz,1,1)
           v_num_aux_2 = integer(this-procedure:handle).

    do  v_num_cont = 1 to 3:
        assign v_num_aux   = (random(0,v_num_aux_2) mod 26) + 97
               p_cod_refer = p_cod_refer + chr(v_num_aux).
    end.
END PROCEDURE.

PROCEDURE pi_verifica_refer_unica_apb:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_estab
        as character
        format "x(3)"
        no-undo.
    def Input param p_cod_refer
        as character
        format "x(10)"
        no-undo.
    def output param p_log_refer_uni
        as logical
        format "Sim/N∆o"
        no-undo.

    /************************* Parameter Definition End *************************/

    assign p_log_refer_uni = yes.

    find first antecip_pef_pend no-lock
         where antecip_pef_pend.cod_estab = p_cod_estab
           and antecip_pef_pend.cod_refer = p_cod_refer no-error.
    if  avail antecip_pef_pend
    then do:
        assign p_log_refer_uni = no.
    end.
    else do:
        find first lote_impl_tit_ap no-lock
             where lote_impl_tit_ap.cod_estab = p_cod_estab
               and lote_impl_tit_ap.cod_refer = p_cod_refer no-error.
        if  avail lote_impl_tit_ap
        then do:
            assign p_log_refer_uni = no.
        end.
        else do:
            find first lote_pagto no-lock
                 where lote_pagto.cod_estab_refer = p_cod_estab
                   and lote_pagto.cod_refer       = p_cod_refer no-error.
            if  avail lote_pagto
            then do:
                assign p_log_refer_uni = no.
            end.
            else do:
                find first movto_tit_ap no-lock
                     where movto_tit_ap.cod_estab = p_cod_estab
                       and movto_tit_ap.cod_refer = p_cod_refer no-error.
                if  avail movto_tit_ap
                then do:
                    assign p_log_refer_uni = no.
                end.
                ELSE DO:
                     FIND FIRST tt_tit_ap_alteracao_base_aux_1 no-lock
                          WHERE tt_tit_ap_alteracao_base_aux_1.ttv_cod_refer = p_cod_refer NO-ERROR.
                     IF AVAIL tt_tit_ap_alteracao_base_aux_1
                     THEN DO:
                          ASSIGN p_log_refer_uni = NO.
                     END.
                END.
            end.
        end.
    end.

END PROCEDURE.
