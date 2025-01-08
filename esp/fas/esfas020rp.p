/****************************************************************************************
**  Programa: ESFAS020RP.P
**  Objetivo: Importaá∆o de documentos de entrada e bens.
**  Autor...: Andrey M Oliveira
**  Data....: 22/08/2023
****************************************************************************************/

DEF BUFFER b_item_docto_entr FOR item_docto_entr.

DEF TEMP-TABLE tt-param NO-UNDO
    FIELD destino          AS INT
    FIELD arquivo          AS CHAR FORMAT "x(35)"
    FIELD usuario          AS CHAR FORMAT "x(12)"
    FIELD data-exec        AS DATE
    FIELD hora-exec        AS INT
    FIELD classifica       AS INT
    FIELD desc-classifica  AS CHAR FORMAT "x(40)"
    FIELD modelo-rtf       AS CHAR FORMAT "x(35)"
    FIELD arquivo-import   AS CHAR
    FIELD tipo-import      AS INT.

DEF NEW SHARED TEMP-TABLE tt_criacao_bem_pat_api_5 NO-UNDO
    FIELD tta_cod_unid_organ_ext           AS CHARACTER FORMAT "x(3)" LABEL "Unid Organ Externa" column-label "Unid Organ Externa"
    FIELD tta_cod_cta_pat                  AS CHARACTER FORMAT "x(18)" LABEL "Conta Patrimonial" column-label "Conta Patrimonial"
    FIELD tta_num_bem_pat                  AS INTEGER FORMAT ">>>>>>>>9" INITIAL 0 LABEL "Bem Patrimonial" column-label "Bem"
    FIELD tta_num_seq_bem_pat              AS INTEGER FORMAT ">>>>9" INITIAL 0 LABEL "Sequància Bem" column-label "Sequància"
    FIELD tta_des_bem_pat                  AS CHARACTER FORMAT "x(40)" LABEL "Descriá∆o Bem Pat" column-label "Descriá∆o Bem Pat"
    FIELD tta_dat_aquis_bem_pat            AS DATE FORMAT "99/99/9999" INITIAL today label "Data Aquisiá∆o" column-label "Dat Aquis"
    FIELD tta_cod_plano_ccusto             AS CHARACTER FORMAT "x(8)" LABEL "Plano Centros Custo" column-label "Plano Centros Custo"
    FIELD tta_cod_ccusto_ext               AS CHARACTER FORMAT "x(8)" LABEL "Centro Custo Externo" column-label "CCusto Externo"
    FIELD tta_cod_estab_ext                AS CHARACTER FORMAT "x(8)" LABEL "Estabelecimento Exte" column-label "Estabelecimento Ext"
    FIELD tta_cod_unid_negoc_ext           AS CHARACTER FORMAT "x(8)" LABEL "Unid Neg¢cio Externa" column-label "Unid Neg¢cio Externa"
    FIELD tta_cod_finalid_econ_ext         AS CHARACTER FORMAT "x(8)" LABEL "Finalid Econ Externa" column-label "Finalidade Externa"
    FIELD ttv_val_aquis_bem_pat            AS DECIMAL FORMAT "->>,>>>,>>>,>>9.99" DECIMALS 2 initial 0 label "Aquisiá∆o Bem" column-label "Aquisiá∆o Bem"
    FIELD ttv_log_erro                     AS LOGICAL FORMAT "Sim/N∆o" INITIAL YES
    FIELD tta_qtd_bem_pat_represen         AS DECIMAL FORMAT ">>>>>>>>9" initial 1 label "Quantidade Bens Representados" column-label "Bem Represen"
    FIELD tta_cdn_fornecedor               AS INTEGER FORMAT ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    FIELD tta_cod_docto_entr               AS CHARACTER FORMAT "x(8)" label "Docto Entrada" column-label "Docto Entrada"
    FIELD tta_cod_ser_nota                 AS CHARACTER FORMAT "x(3)" label "SÇrie Nota" column-label "SÇrie Nota"
    FIELD tta_num_item_docto_entr          AS INTEGER FORMAT ">>>,>>9" initial 0 label "Numero Item" column-label "Num Item"
    FIELD tta_num_id_bem_pat               AS INTEGER FORMAT ">>,>>>,>>9" initial 0 label "Identificaá∆o Bem" column-label "Identificaá∆o Bem"
    FIELD tta_des_narrat_bem_pat           AS CHARACTER FORMAT "x(2000)" label "Narrativa Bem" column-label "Narrativa Bem"
    FIELD tta_log_bem_imptdo               AS LOGICAL FORMAT "Sim/N∆o" initial no label "Bem Importado" column-label "Bem Importado"
    FIELD tta_log_cr_pis                   AS LOGICAL FORMAT "Sim/N∆o" initial no label "Credita PIS" column-label "Credita PIS"
    FIELD tta_log_cr_cofins                AS LOGICAL FORMAT "Sim/N∆o" initial no label "Credita COFINS" column-label "Credita COFINS"
    FIELD ttv_num_parc_pis_cofins          AS INTEGER FORMAT "99" initial 0 label "Nro Parcelas" column-label "Nro Parcelas"
    FIELD tta_val_cr_pis                   AS DECIMAL FORMAT ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Cred PIS/PASEP" column-label "Vl Cred PIS/PASEP"
    FIELD tta_val_cr_cofins                AS DECIMAL FORMAT ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor CrÇdito COFINS" column-label "Credito COFINS"
    FIELD ttv_log_cr_csll                  AS LOGICAL FORMAT "Sim/N∆o" initial no label "Credita CSLL" column-label "Credita CSLL"
    FIELD ttv_num_exerc_cr_csll            AS INTEGER FORMAT "99" label "Exerc. CrÇdito CSLL" column-label "Exerc. CrÇdito CSLL"
    .

def new shared temp-table tt_criacao_bem_pat_api_6 no-undo
    field tta_cod_unid_organ_ext           as character format "x(5)" label "Unid Organ Externa" column-label "Unid Organ Externa"
    field tta_cod_cta_pat                  as character format "x(18)" label "Conta Patrimonial" column-label "Conta Patrimonial"
    field tta_num_bem_pat                  as integer format ">>>>>>>>9" initial 0 label "Bem Patrimonial" column-label "Bem"
    field tta_num_seq_bem_pat              as integer format ">>>>9" initial 0 label "Sequància Bem" column-label "Sequància"
    field tta_des_bem_pat                  as character format "x(40)" label "Descriá∆o Bem Pat" column-label "Descriá∆o Bem Pat"
    field tta_dat_aquis_bem_pat            as date format "99/99/9999" initial today label "Data Aquisiá∆o" column-label "Dat Aquis"
    field tta_cod_plano_ccusto             as character format "x(8)" label "Plano Centros Custo" column-label "Plano Centros Custo"
    field tta_cod_ccusto_ext               as character format "x(8)" label "Centro Custo Externo" column-label "CCusto Externo"
    field tta_cod_estab_ext                as character format "x(8)" label "Estabelecimento Exte" column-label "Estabelecimento Ext"
    field tta_cod_unid_negoc_ext           as character format "x(8)" label "Unid Neg¢cio Externa" column-label "Unid Neg¢cio Externa"
    field tta_cod_finalid_econ_ext         as character format "x(8)" label "Finalid Econ Externa" column-label "Finalidade Externa"
    field ttv_val_aquis_bem_pat            as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Aquisiá∆o Bem" column-label "Aquisiá∆o Bem"
    field ttv_log_erro                     as logical format "Sim/N∆o" initial yes
    field tta_qtd_bem_pat_represen         as decimal format ">>>>>>>>9" initial 1 label "Quantidade Bens Representados" column-label "Bem Represen"
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field tta_cod_docto_entr               as character format "x(8)" label "Docto Entrada" column-label "Docto Entrada"
    field tta_cod_ser_nota                 as character format "x(3)" label "SÇrie Nota" column-label "SÇrie Nota"
    field tta_num_item_docto_entr          as integer format ">>>,>>9" initial 0 label "Numero Item" column-label "Num Item"
    field tta_num_id_bem_pat               as integer format ">>,>>>,>>9" initial 0 label "Identificaá∆o Bem" column-label "Identificaá∆o Bem"
    field tta_des_narrat_bem_pat           as character format "x(2000)" label "Narrativa Bem" column-label "Narrativa Bem"
    field tta_log_bem_imptdo               as logical format "Sim/N∆o" initial no label "Bem Importado" column-label "Bem Importado"
    field tta_log_cr_pis                   as logical format "Sim/N∆o" initial no label "Credita PIS" column-label "Credita PIS"
    field tta_log_cr_cofins                as logical format "Sim/N∆o" initial no label "Credita COFINS" column-label "Credita COFINS"
    field ttv_num_parc_pis_cofins          as integer format "99" initial 0 label "Nro Parcelas" column-label "Nro Parcelas"
    field tta_val_cr_pis                   as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Cred PIS/PASEP" column-label "Vl Cred PIS/PASEP"
    field tta_val_cr_cofins                as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor CrÇdito COFINS" column-label "Credito COFINS"
    field tta_val_base_pis                 as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Base PIS/PASEP" column-label "Vl Base PIS/PASEP"
    field tta_val_base_cofins              as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Base COFINS" column-label "Base COFINS"
    field ttv_log_cr_csll                  as logical format "Sim/N∆o" initial no label "Credita CSLL" column-label "Credita CSLL"
    field ttv_num_exerc_cr_csll            as integer format "99" label "Exerc. CrÇdito CSLL" column-label "Exerc. CrÇdito CSLL"
    .

def temp-table tt_criacao_bem_pat_val_resid no-undo
    field ttv_rec_bem                      as recid format ">>>>>>9"
    field tta_cod_tip_calc                 as character format "x(7)" label "Tipo C†lculo" column-label "Tipo C†lculo"
    field tta_cod_cenar_ctbl               as character format "x(8)" label "Cen†rio Cont†bil" column-label "Cen†rio Cont†bil"
    field tta_cod_finalid_econ             as character format "x(10)" label "Finalidade" column-label "Finalidade"
    field tta_val_resid_min                as decimal format ">>>>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Residual M°nimo" column-label "Residual"
    index tt_id                            is primary unique
          ttv_rec_bem                      ascending
          tta_cod_tip_calc                 ascending
          tta_cod_cenar_ctbl               ascending
          tta_cod_finalid_econ             ascending
    .

def NEW shared temp-table tt_erros_criacao_bem_pat_api        
    field tta_cod_unid_organ_ext           as character format "x(3)" label "Unid Organ Externa" column-label "Unid Organ Externa"
    field tta_cod_cta_pat                  as character format "x(18)" label "Conta Patrimonial" column-label "Conta Patrimonial"
    field tta_num_bem_pat                  as integer format ">>>>>>>>9" initial 0 label "Bem Patrimonial" column-label "Bem"
    field tta_num_seq_bem_pat              as integer format ">>>>9" initial 0 label "Sequància Bem" column-label "Sequància"
    field tta_des_bem_pat                  as character format "x(40)" label "Descriá∆o Bem Pat" column-label "Descriá∆o Bem Pat"
    field tta_dat_aquis_bem_pat            as date format "99/99/9999" initial today label "Data Aquisiá∆o" column-label "Dat Aquis"
    field tta_cod_finalid_econ_ext         as character format "x(8)" label "Finalid Econ Externa" column-label "Finalidade Externa"
    field ttv_des_mensagem                 as character format "x(50)" label "Mensagem" column-label "Mensagem"
    .

def NEW shared temp-table tt_erros_criacao_bem_pat_api_1 no-undo
    field tta_cod_unid_organ_ext           as character format "x(3)" label "Unid Organ Externa" column-label "Unid Organ Externa"
    field tta_cod_cta_pat                  as character format "x(18)" label "Conta Patrimonial" column-label "Conta Patrimonial"
    field tta_num_bem_pat                  as integer format ">>>>>>>>9" initial 0 label "Bem Patrimonial" column-label "Bem"
    field tta_num_seq_bem_pat              as integer format ">>>>9" initial 0 label "Sequºncia Bem" column-label "Sequºncia"
    field tta_des_bem_pat                  as character format "x(40)" label "Descriªío Bem Pat" column-label "Descriªío Bem Pat"
    field tta_dat_aquis_bem_pat            as date format "99/99/9999" initial today label "Data Aquisiªío" column-label "Dat Aquis"
    field tta_cod_finalid_econ_ext         as character format "x(8)" label "Finalid Econ Externa" column-label "Finalidade Externa"
    field ttv_des_mensagem                 as character format "x(50)" label "Mensagem" column-label "Mensagem"
    .

def temp-table tt_criacao_bem_pat_item_api no-undo
    field ttv_rec_bem                      as recid format ">>>>>>9"
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field tta_cod_docto_entr               as character format "x(8)" label "Docto Entrada" column-label "Docto Entrada"
    field tta_cod_ser_nota                 as character format "x(3)" label "SÇrie Nota" column-label "SÇrie Nota"
    field tta_num_item_docto_entr          as integer format ">>>,>>9" initial 0 label "Numero Item" column-label "Num Item"
    field tta_qtd_item_docto_entr          as decimal format ">>>>>>>>9" initial 0 label "Qtde Item Docto" column-label "Qtde Item Docto"
    .

DEF TEMP-TABLE tt_file_import_docto NO-UNDO
    FIELD num_line            AS INT INIT 0
    FIELD cod_empresa         LIKE docto_entr.cod_empresa       
    FIELD cod_estab           LIKE docto_entr.cod_estab         
    FIELD cod_docto_entr      LIKE docto_entr.cod_docto_entr    
    FIELD cod_ser_nota        LIKE docto_entr.cod_ser_nota      
    FIELD cdn_fornecedor      LIKE docto_entr.cdn_fornecedor    
    FIELD dat_docto           LIKE docto_entr.dat_docto         
    FIELD des_docto_entr      LIKE docto_entr.des_docto_entr    
    FIELD ind_orig_docto      LIKE docto_entr.ind_orig_docto    
    FIELD ind_tip_docto_entr  LIKE docto_entr.ind_tip_docto_entr
    FIELD cod_indic_econ      LIKE item_docto_entr.cod_indic_econ
    FIELD val_item_docto_entr LIKE item_docto_entr.val_item_docto_entr
    FIELD qtd_item_docto_entr LIKE item_docto_entr.qtd_item_docto_entr
    FIELD num_ord_invest      LIKE item_docto_entr.num_ord_invest
    FIELD des_item_docto_entr LIKE item_docto_entr.des_item_docto_entr
    FIELD cod_ccusto          AS CHAR FORMAT "x(5)"
    FIELD cod_unid_negoc      AS CHAR FORMAT "x(3)"
    FIELD narrativa           AS CHAR FORMAT "x(40)".

DEF TEMP-TABLE tt_file_import_bem NO-UNDO
    FIELD num_line             AS INT INIT 0
    FIELD cod_empresa          LIKE bem_pat.cod_empresa       
    FIELD cod_estab            LIKE bem_pat.cod_estab         
    FIELD cod_cta_pat          LIKE bem_pat.cod_cta_pat
    FIELD num_bem_pat          LIKE bem_pat.num_bem_pat
    FIELD seq_bem_pat          AS CHAR
    FIELD des_bem_pat          LIKE bem_pat.des_bem_pat
    FIELD dat_aquis_bem_pat    LIKE bem_pat.dat_aquis_bem_pat
    FIELD cod_ccusto_respons   LIKE bem_pat.cod_ccusto_respons
    FIELD cod_unid_negoc       LIKE bem_pat.cod_unid_negoc
    FIELD val_aquis            LIKE bem_pat.val_original
    FIELD qtd_bem_pat_represen LIKE bem_pat.qtd_bem_pat_represen
    FIELD cdn_fornecedor       LIKE docto_entr.cdn_fornecedor    
    FIELD des_narrat_bem_pat   LIKE bem_pat.des_narrat_bem_pat
    FIELD cod_indic_econ       LIKE bem_pat.cod_indic_econ
    FIELD cod_docto_entr       LIKE docto_entr.cod_docto_entr    
    FIELD cod_ser_nota         LIKE docto_entr.cod_ser_nota      
    FIELD num_item_docto_entr  LIKE item_docto_entr.num_item_docto_entr
    FIELD qtd_item_entrada     AS DEC.

DEF TEMP-TABLE tt_erros_bens NO-UNDO
    FIELD cod_cta_pat      AS CHAR
    FIELD num_bem_pat      AS INT
    FIELD num_seq_bem_pat  AS INT
    FIELD ttv_des_mensagem AS CHAR
    FIELD num_line         AS INT.

DEF TEMP-TABLE tt_sucesso_bens NO-UNDO
    FIELD cod_cta_pat      AS CHAR
    FIELD num_bem_pat      AS INT
    FIELD num_seq_bem_pat  AS INT
    FIELD ttv_des_mensagem AS CHAR
    FIELD num_line         AS INT.

DEF TEMP-TABLE tt_erros_doctos NO-UNDO
    FIELD cod_estab        AS CHAR
    FIELD cod_docto_entr   AS CHAR
    FIELD cod_ser_nota     AS CHAR
    FIELD cdn_fornecedor   AS INT
    FIELD ttv_des_mensagem AS CHAR
    FIELD num_line         AS INT.

DEF TEMP-TABLE tt_sucesso_doctos NO-UNDO
    FIELD cod_estab        AS CHAR
    FIELD cod_docto_entr   AS CHAR
    FIELD cod_ser_nota     AS CHAR
    FIELD cdn_fornecedor   AS INT
    FIELD ttv_des_mensagem AS CHAR
    FIELD num_line         AS INT.

DEF TEMP-TABLE tt-raw-digita NO-UNDO
    FIELD raw-digita   AS RAW.

DEF NEW GLOBAL SHARED VAR v_cod_usuar_corren AS CHAR NO-UNDO.

DEF VAR v_hdl_program   AS HANDLE                                                   NO-UNDO.
DEF VAR h-acomp         AS HANDLE                                                   NO-UNDO.
DEF VAR v_num_line      AS INT FORMAT ">>,>>9":U LABEL "Linha" COLUMN-LABEL "Linha" NO-UNDO. 
DEF VAR c-linha         AS CHAR                                                     NO-UNDO.
DEF VAR c-arquivo-saida AS CHAR                                                     NO-UNDO.
DEF VAR p_cod_return    AS CHAR                                                     NO-UNDO.
DEF VAR p_des_mensagem  AS CHAR FORMAT "x(50)"                                      NO-UNDO.
DEF VAR v_seq_bem       LIKE bem_pat.num_seq_bem_pat                                NO-UNDO.
DEF VAR v_log_erro      AS LOG                                                      NO-UNDO.

DEF INPUT PARAM raw-param AS RAW NO-UNDO.
DEF INPUT PARAM TABLE FOR tt-raw-digita.

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
RUN pi-inicializar in h-acomp (INPUT "Executando...").

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

FIND FIRST tt-param NO-LOCK NO-ERROR.

IF  tt-param.arquivo-import <> "" THEN DO:
    ASSIGN v_num_line = 0.

    IF  tt-param.tipo-import = 1 THEN DO: /* documento entrada */
        EMPTY TEMP-TABLE tt_file_import_docto NO-ERROR.
        
        INPUT FROM VALUE(tt-param.arquivo-import) NO-CONVERT.

        REPEAT:
            IMPORT UNFORMATTED c-linha.

            RUN pi-acompanhar IN h-acomp (INPUT "Importando Doctos - Linha: " + STRING(v_num_line)).

            IF  TRIM(ENTRY(1, c-linha, ";")) = "Empresa" THEN
                NEXT.

            ASSIGN v_num_line = v_num_line + 1.

            CREATE tt_file_import_docto.
            ASSIGN tt_file_import_docto.num_line            = v_num_line
                   tt_file_import_docto.cod_empresa         = TRIM(ENTRY( 1, c-linha, ";")) 
                   tt_file_import_docto.cod_estab           = TRIM(ENTRY( 2, c-linha, ";")) 
                   tt_file_import_docto.cod_docto_entr      = TRIM(ENTRY( 3, c-linha, ";")) 
                   tt_file_import_docto.cod_ser_nota        = TRIM(ENTRY( 4, c-linha, ";")) 
                   tt_file_import_docto.cdn_fornecedor      =  INT(ENTRY( 5, c-linha, ";")) 
                   tt_file_import_docto.dat_docto           = date(ENTRY( 6, c-linha, ";")) 
                   tt_file_import_docto.des_docto_entr      = TRIM(ENTRY( 7, c-linha, ";")) 
                   tt_file_import_docto.ind_orig_docto      = TRIM(ENTRY( 8, c-linha, ";"))
                   tt_file_import_docto.ind_tip_docto_entr  = TRIM(ENTRY( 9, c-linha, ";"))
                   tt_file_import_docto.cod_indic_econ      = TRIM(ENTRY(10, c-linha, ";"))
                   tt_file_import_docto.val_item_docto_entr =  DEC(ENTRY(11, c-linha, ";"))
                   tt_file_import_docto.qtd_item_docto_entr =  INT(ENTRY(12, c-linha, ";"))
                   tt_file_import_docto.num_ord_invest      =  INT(ENTRY(13, c-linha, ";")) 
                   tt_file_import_docto.des_item_docto_entr = TRIM(ENTRY(14, c-linha, ";"))
                   tt_file_import_docto.cod_ccusto          = TRIM(ENTRY(15, c-linha, ";"))
                   tt_file_import_docto.cod_unid_negoc      = TRIM(ENTRY(16, c-linha, ";"))
                   tt_file_import_docto.narrativa           = TRIM(ENTRY(17, c-linha, ";")).
        END.

        INPUT CLOSE.

        RUN pi_processa_doctos.

        IF  OPSYS = "UNIX" THEN
            ASSIGN c-arquivo-saida = "/mnt/spool/" + v_cod_usuar_corren + "/esfas020_docto_" + STRING(TIME) + ".csv".
        ELSE
            ASSIGN c-arquivo-saida = "\\erpapp\spool\" + v_cod_usuar_corren + "/esfas020_docto_" + STRING(TIME) + ".csv".

        OUTPUT TO VALUE (c-arquivo-saida) NO-CONVERT.

        RUN pi_imprime_erros.

        IF  NOT OPSYS = "unix" THEN
            DOS SILENT START excel VALUE(c-arquivo-saida).

        OUTPUT CLOSE.
    END.

    IF  tt-param.tipo-import = 2 THEN DO: /* bens */
        EMPTY TEMP-TABLE tt_file_import_bem NO-ERROR.
        
        INPUT FROM VALUE(tt-param.arquivo-import) NO-CONVERT.

        REPEAT:
            IMPORT UNFORMATTED c-linha.

            RUN pi-acompanhar IN h-acomp (INPUT "Importando Bens - Linha: " + STRING(v_num_line)).

            IF  TRIM(ENTRY(1, c-linha, ";")) = "Empresa" THEN
                NEXT.

            ASSIGN v_num_line = v_num_line + 1.

            CREATE tt_file_import_bem.
            ASSIGN tt_file_import_bem.num_line             = v_num_line
                   tt_file_import_bem.cod_empresa          = TRIM(ENTRY( 1, c-linha, ";")) 
                   tt_file_import_bem.cod_estab            = TRIM(ENTRY( 2, c-linha, ";")) 
                   tt_file_import_bem.cod_cta_pat          = TRIM(ENTRY( 3, c-linha, ";")) 
                   tt_file_import_bem.num_bem_pat          =  INT(ENTRY( 4, c-linha, ";")) 
                   tt_file_import_bem.seq_bem_pat          = TRIM(ENTRY( 5, c-linha, ";"))
                   tt_file_import_bem.des_bem_pat          = TRIM(ENTRY( 6, c-linha, ";")) 
                   tt_file_import_bem.dat_aquis_bem_pat    = DATE(ENTRY( 7, c-linha, ";")) 
                   tt_file_import_bem.cod_ccusto_respons   = TRIM(ENTRY( 8, c-linha, ";"))
                   tt_file_import_bem.cod_unid_negoc       = TRIM(ENTRY( 9, c-linha, ";"))
                   tt_file_import_bem.val_aquis            =  DEC(ENTRY(10, c-linha, ";"))
                   tt_file_import_bem.qtd_bem_pat_represen =  INT(ENTRY(11, c-linha, ";"))
                   tt_file_import_bem.cdn_fornecedor       =  INT(ENTRY(12, c-linha, ";"))
                   tt_file_import_bem.des_narrat_bem_pat   = TRIM(ENTRY(13, c-linha, ";"))
                   tt_file_import_bem.cod_indic_econ       = TRIM(ENTRY(14, c-linha, ";"))
                   tt_file_import_bem.cod_docto_entr       = TRIM(ENTRY(15, c-linha, ";"))
                   tt_file_import_bem.cod_ser_nota         = TRIM(ENTRY(16, c-linha, ";"))
                   tt_file_import_bem.num_item_docto_entr  =  INT(ENTRY(17, c-linha, ";"))
                   tt_file_import_bem.qtd_item_entrada     =  INT(ENTRY(18, c-linha, ";")).
        END.
        
        INPUT CLOSE.

        RUN pi_processa_bens.

        IF  OPSYS = "UNIX" THEN
            ASSIGN c-arquivo-saida = "/mnt/spool/" + v_cod_usuar_corren + "/esfas020_bens_" + STRING(TIME) + ".csv".
        ELSE
            ASSIGN c-arquivo-saida = "\\erpapp\spool\" + v_cod_usuar_corren + "/esfas020_bens_" + STRING(TIME) + ".csv".
        
        OUTPUT TO VALUE (c-arquivo-saida) NO-CONVERT.

        RUN pi_imprime_erros.

        OUTPUT CLOSE.
    END.
    
    RUN pi-finalizar in h-acomp.
END.

IF  NOT OPSYS = "unix" THEN
    DOS SILENT START excel VALUE(c-arquivo-saida).

RETURN "OK":U.


PROCEDURE pi_processa_bens:
    
    DEF VAR v_moeda like cotacao.mo-codigo NO-UNDO.

    EMPTY TEMP-TABLE tt_erros_bens.

    RUN esp\fas\esfas020aa.p PERSISTENT SET v_hdl_program. /* criacao de bens */

    ASSIGN v_num_line = 0
           v_log_erro = NO.

    bloco_bem:
    DO TRANS ON ERROR UNDO bloco_bem, LEAVE bloco_bem:

        FOR EACH tt_file_import_bem:   
    
            ASSIGN v_num_line = v_num_line + 1.
        
            RUN pi-acompanhar IN h-acomp (INPUT "Atualizando: " + STRING(v_num_line)).
    
            IF  tt_file_import_bem.seq_bem_pat = "" THEN DO:
                ASSIGN v_seq_bem = 0.

                FIND LAST bem_pat
                    WHERE bem_pat.cod_empresa = tt_file_import_bem.cod_empresa
                    AND   bem_pat.cod_cta_pat = tt_file_import_bem.cod_cta_pat 
                    AND   bem_pat.num_bem_pat = int(tt_file_import_bem.num_bem_pat) NO-LOCK NO-ERROR.

                IF  AVAIL bem_pat THEN
                    ASSIGN v_seq_bem                      = bem_pat.num_seq_bem_pat + 1
                           tt_file_import_bem.seq_bem_pat = string(v_seq_bem).
            END.

            IF  tt_file_import_bem.cod_indic_econ = "Real" THEN
                ASSIGN v_moeda = 0.
            ELSE DO:
                FIND trad_finalid_econ_ext
                    WHERE trad_finalid_econ_ext.cod_matriz_trad_finalid_ext = "EMS"
                    AND   trad_finalid_econ_ext.cod_finalid_econ            = tt_file_import_bem.cod_indic_econ NO-LOCK NO-ERROR.
                
                IF  AVAIL trad_finalid_econ_ext THEN
                    ASSIGN v_moeda = int(trad_finalid_econ_ext.cod_finalid_econ_ext).
                ELSE DO:
                    CREATE tt_erros_bens.
                    ASSIGN tt_erros_bens.cod_cta_pat      = tt_file_import_bem.cod_cta_pat    
                           tt_erros_bens.num_bem_pat      = tt_file_import_bem.num_bem_pat    
                           tt_erros_bens.num_seq_bem_pat  = int(tt_file_import_bem.seq_bem_pat)
                           tt_erros_bens.num_line         = tt_file_import_bem.num_line
                           tt_erros_bens.ttv_des_mensagem = "ERRO: Traduá∆o da moeda n∆o cadastrada.".

                    ASSIGN v_log_erro = YES.
    
                    NEXT.
                END.
            END.
    
            FIND FIRST cta_pat
                WHERE cta_pat.cod_cta_pat = tt_file_import_bem.cod_cta_pat NO-LOCK NO-ERROR.
    
            IF  NOT AVAIL cta_pat THEN DO:
                CREATE tt_erros_bens.
                ASSIGN tt_erros_bens.cod_cta_pat      = tt_file_import_bem.cod_cta_pat    
                       tt_erros_bens.num_bem_pat      = tt_file_import_bem.num_bem_pat    
                       tt_erros_bens.num_seq_bem_pat  = int(tt_file_import_bem.seq_bem_pat)
                       tt_erros_bens.num_line         = tt_file_import_bem.num_line
                       tt_erros_bens.ttv_des_mensagem = "ERRO: Conta patrimonial n∆o cadastrada.".

                ASSIGN v_log_erro = YES.
    
                NEXT.
            END.
    
            find FIRST trad_ccusto_ext
                where trad_ccusto_ext.cod_empresa                = tt_file_import_bem.cod_empresa
                and   trad_ccusto_ext.cod_matriz_trad_ccusto_ext = "EMS2"
                and   trad_ccusto_ext.cod_ccusto_ext             = tt_file_import_bem.cod_ccusto_respons no-lock no-error.
            
            if  not avail trad_ccusto_ext then do:
                CREATE tt_erros_bens.
                ASSIGN tt_erros_bens.cod_cta_pat      = tt_file_import_bem.cod_cta_pat    
                       tt_erros_bens.num_bem_pat      = tt_file_import_bem.num_bem_pat    
                       tt_erros_bens.num_seq_bem_pat  = int(tt_file_import_bem.seq_bem_pat)
                       tt_erros_bens.num_line         = tt_file_import_bem.num_line
                       tt_erros_bens.ttv_des_mensagem = "ERRO: Matriz de traduá∆o n∆o encontrada para o centro de custo.".

                ASSIGN v_log_erro = YES.
    
                NEXT.        
            END.
    
            EMPTY TEMP-TABLE tt_criacao_bem_pat_api_6.
            EMPTY TEMP-TABLE tt_erros_criacao_bem_pat_api.
            EMPTY TEMP-TABLE tt_erros_criacao_bem_pat_api_1.
    
            CREATE tt_criacao_bem_pat_api_6.
            ASSIGN tt_criacao_bem_pat_api_6.tta_cod_unid_organ_ext   = tt_file_import_bem.cod_empresa
                   tt_criacao_bem_pat_api_6.tta_cod_cta_pat          = tt_file_import_bem.cod_cta_pat    
                   tt_criacao_bem_pat_api_6.tta_num_bem_pat          = tt_file_import_bem.num_bem_pat    
                   tt_criacao_bem_pat_api_6.tta_num_seq_bem_pat      = int(tt_file_import_bem.seq_bem_pat)
                   tt_criacao_bem_pat_api_6.tta_des_bem_pat          = tt_file_import_bem.des_bem_pat
                   tt_criacao_bem_pat_api_6.tta_dat_aquis_bem_pat    = tt_file_import_bem.dat_aquis_bem_pat
                   tt_criacao_bem_pat_api_6.tta_cod_plano_ccusto     = "PADRAO"
                   tt_criacao_bem_pat_api_6.tta_cod_ccusto_ext       = tt_file_import_bem.cod_ccusto_respons
                   tt_criacao_bem_pat_api_6.tta_cod_estab_ext        = tt_file_import_bem.cod_estab
                   tt_criacao_bem_pat_api_6.tta_cod_unid_negoc_ext   = tt_file_import_bem.cod_unid_negoc 
                   tt_criacao_bem_pat_api_6.tta_cod_finalid_econ_ext = string(v_moeda)
                   tt_criacao_bem_pat_api_6.ttv_val_aquis_bem_pat    = tt_file_import_bem.val_aquis
                   tt_criacao_bem_pat_api_6.ttv_log_erro             = NO
                   tt_criacao_bem_pat_api_6.tta_qtd_Bem_pat_represen = tt_file_import_bem.qtd_bem_pat_represen
                   tt_criacao_bem_pat_api_6.tta_cdn_fornecedor       = tt_file_import_bem.cdn_fornecedor
                   tt_criacao_bem_pat_api_6.tta_num_id_bem_pat       = 0
                   tt_criacao_bem_pat_api_6.tta_des_narrat_Bem_pat   = tt_file_import_bem.des_narrat_bem_pat
                   tt_criacao_bem_pat_api_6.tta_log_cr_cofins        = NO
                   tt_criacao_bem_pat_api_6.tta_log_cr_pis           = NO
                   tt_criacao_bem_pat_api_6.ttv_num_parc_pis_cofins  = 0
                   tt_criacao_bem_pat_api_6.tta_val_cr_pis           = 0
                   tt_criacao_bem_pat_api_6.tta_val_cr_cofins        = 0
                   tt_criacao_bem_pat_api_6.tta_cod_docto_entr       = tt_file_import_bem.cod_docto_entr 
                   tt_criacao_bem_pat_api_6.tta_cod_ser_nota         = tt_file_import_bem.cod_ser_nota 
                   tt_criacao_bem_pat_api_6.tta_num_item_docto_entr  = tt_file_import_bem.num_item_docto_entr.
    
            RELEASE tt_criacao_bem_pat_api_6.
    
            RUN pi_main_api_criacao_bem_pat_9 IN v_hdl_program
                                              (INPUT 1, 
                                               INPUT "EMS2" /* matriz traducao*/, 
                                               INPUT "EMS2" /* matriz ccusto*/,
                                               INPUT "EMS"  /* matriz finalidade econ.*/,
                                               INPUT YES     /* contabiliza*/,
                                               INPUT TABLE tt_criacao_bem_pat_item_api,
                                               INPUT TABLE tt_criacao_bem_pat_val_resid,
                                               INPUT TABLE tt_criacao_bem_pat_api_6,
                                               OUTPUT p_cod_return,
                                               OUTPUT p_des_mensagem).
    
            /* MOSTRA ERROS RETORNADOS DA API DE IMPLANTAÄ«O */
            IF  p_cod_return <> "" THEN DO:

                IF  CAN-FIND(FIRST tt_erros_criacao_bem_pat_api_1) THEN DO:
                    
                    FOR EACH tt_erros_criacao_bem_pat_api_1:

                        CREATE tt_erros_bens.
                        ASSIGN tt_erros_bens.cod_cta_pat      = tt_erros_criacao_bem_pat_api_1.tta_cod_cta_pat
                               tt_erros_bens.num_bem_pat      = tt_erros_criacao_bem_pat_api_1.tta_num_bem_pat
                               tt_erros_bens.num_seq_bem_pat  = tt_erros_criacao_bem_pat_api_1.tta_num_seq_bem_pat
                               tt_erros_bens.num_line         = tt_file_import_bem.num_line
                               tt_erros_bens.ttv_des_mensagem = "ERRO: " + tt_erros_criacao_bem_pat_api_1.ttv_des_mensagem.

                        ASSIGN v_log_erro = YES.
                    END.
                END.
                ELSE DO:
                    IF  p_cod_return = "NOK" THEN DO:

                        CREATE tt_erros_bens.
                        ASSIGN tt_erros_bens.cod_cta_pat      = tt_file_import_bem.cod_cta_pat    
                               tt_erros_bens.num_bem_pat      = tt_file_import_bem.num_bem_pat    
                               tt_erros_bens.num_seq_bem_pat  = int(tt_file_import_bem.seq_bem_pat)
                               tt_erros_bens.num_line         = tt_file_import_bem.num_line
                               tt_erros_bens.ttv_des_mensagem = "ERRO: Erro inesperado retornado pela api.".

                        ASSIGN v_log_erro = YES.
                    END.
                END.
            END.
            ELSE DO:
                FOR FIRST item_docto_entr NO-LOCK
                    WHERE item_docto_entr.cod_estab           = tt_file_import_bem.cod_estab
                    AND   item_docto_entr.cod_empresa         = tt_file_import_bem.cod_empresa
                    AND   item_docto_entr.cdn_fornecedor      = tt_file_import_bem.cdn_fornecedor
                    AND   item_docto_entr.cod_docto_entr      = tt_file_import_bem.cod_docto_entr
                    AND   item_docto_entr.cod_ser_nota        = tt_file_import_bem.cod_ser_nota
                    AND   item_docto_entr.num_item_docto_entr = tt_file_import_bem.num_item_docto_entr:
    
                    FIND FIRST bem_pat
                        WHERE bem_pat.cod_empresa     = tt_file_import_bem.cod_empresa
                        AND   bem_pat.cod_cta_pat     = tt_file_import_bem.cod_cta_pat    
                        AND   bem_pat.num_bem_pat     = tt_file_import_bem.num_bem_pat    
                        AND   bem_pat.num_seq_bem_pat = int(tt_file_import_bem.seq_bem_pat) NO-LOCK NO-ERROR.
    
                    IF  AVAIL bem_pat THEN DO:
                        CREATE bem_pat_item_docto_entr.
                        ASSIGN bem_pat_item_docto_entr.num_id_bem_pat          = bem_pat.num_id_bem_pat
                               bem_pat_item_docto_entr.num_seq_incorp_bem_pat  = 0
                               bem_pat_item_docto_entr.cod_estab               = item_docto_entr.cod_estab
                               bem_pat_item_docto_entr.cod_empresa             = item_docto_entr.cod_empresa
                               bem_pat_item_docto_entr.cdn_fornecedor          = item_docto_entr.cdn_fornecedor
                               bem_pat_item_docto_entr.cod_docto_entr          = item_docto_entr.cod_docto_entr
                               bem_pat_item_docto_entr.cod_ser_nota            = item_docto_entr.cod_ser_nota
                               bem_pat_item_docto_entr.num_item_docto_entr     = item_docto_entr.num_item_docto_entr.
        
                        ASSIGN bem_pat_item_docto_entr.qtd_item_docto_entr     = tt_file_import_bem.qtd_item_entrada
                               bem_pat_item_docto_entr.des_item_docto_entr     = item_docto_entr.des_item_docto_entr
                               bem_pat_item_docto_entr.cod_indic_econ          = item_docto_entr.cod_indic_econ
                               bem_pat_item_docto_entr.cod_espec_bem           = item_docto_entr.cod_espec_bem
                               bem_pat_item_docto_entr.cod_marca               = item_docto_entr.cod_marca
                               bem_pat_item_docto_entr.cod_modelo              = item_docto_entr.cod_modelo
                               bem_pat_item_docto_entr.num_ord_invest          = item_docto_entr.num_ord_invest
                               bem_pat_item_docto_entr.val_item_docto_entr     = item_docto_entr.val_item_docto_entr     / item_docto_entr.qtd_item_docto_entr
                               bem_pat_item_docto_entr.val_aquis_bem_pat_fasb  = item_docto_entr.val_aquis_bem_pat_fasb  / item_docto_entr.qtd_item_docto_entr
                               bem_pat_item_docto_entr.val_aquis_bem_pat_cmcac = item_docto_entr.val_aquis_bem_pat_cmcac / item_docto_entr.qtd_item_docto_entr
                               bem_pat_item_docto_entr.num_id_ri_bem_pat       = item_docto_entr.num_id_ri_bem_pat
                               bem_pat_item_docto_entr.cod_plano_ccusto        = ENTRY(1,item_docto_entr.cod_livre_1,chr(10))
                               bem_pat_item_docto_entr.cod_ccusto              = ENTRY(2,item_docto_entr.cod_livre_1,chr(10)).
        
                        /* Atualiza quantidade dispon°vel do item */
                        RUN pi_atualiza_quant_item_docto_entr(INPUT RECID(item_docto_entr),
                                                              INPUT bem_pat_item_docto_entr.qtd_item_docto_entr, /* quantidade */
                                                              INPUT "Vincula" /*l_vincula*/ ).
                    END.
                END.
    
                CREATE tt_sucesso_bens.
                ASSIGN tt_sucesso_bens.num_line         = tt_file_import_bem.num_line
                       tt_sucesso_bens.cod_cta_pat      = tt_file_import_bem.cod_cta_pat  
                       tt_sucesso_bens.num_bem_pat      = tt_file_import_bem.num_bem_pat   
                       tt_sucesso_bens.num_seq_bem_pat  = int(tt_file_import_bem.seq_bem_pat)
                       tt_sucesso_bens.ttv_des_mensagem = "OK: Bem importado com sucesso !".
            END.
        END.

        IF  v_log_erro = YES THEN DO:
            UNDO bloco_bem, LEAVE bloco_bem.
        END.
    END.

    DELETE OBJECT v_hdl_program.
    ASSIGN v_hdl_program = ?.

END PROCEDURE.

PROCEDURE pi_processa_doctos:
    
    EMPTY TEMP-TABLE tt_erros_doctos.

    ASSIGN v_num_line = 0
           v_log_erro = NO.

    bloco_docto:
    DO TRANS ON ERROR UNDO bloco_docto, LEAVE bloco_docto:

        FOR EACH tt_file_import_docto NO-LOCK:    
            ASSIGN v_num_line = v_num_line + 1.
        
            RUN pi-acompanhar IN h-acomp (INPUT "Atualizando: " + STRING(v_num_line)).
    
            FIND FIRST estabelecimento
                WHERE estabelecimento.cod_estab = tt_file_import_docto.cod_estab NO-LOCK NO-ERROR.
    
            IF  NOT AVAIL estabelecimento THEN DO:
                CREATE tt_erros_doctos.
                ASSIGN tt_erros_doctos.cod_estab        = tt_file_import_docto.cod_estab      
                       tt_erros_doctos.cod_docto_entr   = tt_file_import_docto.cod_docto_entr   
                       tt_erros_doctos.cod_ser_nota     = tt_file_import_docto.cod_ser_nota     
                       tt_erros_doctos.cdn_fornecedor   = tt_file_import_docto.cdn_fornecedor
                       tt_erros_doctos.num_line         = tt_file_import_docto.num_line
                       tt_erros_doctos.ttv_des_mensagem = "ERRO: Estabelecimento n∆o cadastrado.".

                ASSIGN v_log_erro = YES.
    
                NEXT.
            END.
    
            FIND FIRST emscad.fornecedor
                WHERE emscad.fornecedor.cod_empres = tt_file_import_docto.cod_empresa
                AND   emscad.fornecedor.cdn_fornec = tt_file_import_docto.cdn_fornecedor NO-LOCK NO-ERROR.
    
            IF  NOT AVAIL emscad.fornecedor THEN DO:
                CREATE tt_erros_doctos.
                ASSIGN tt_erros_doctos.cod_estab        = tt_file_import_docto.cod_estab      
                       tt_erros_doctos.cod_docto_entr   = tt_file_import_docto.cod_docto_entr 
                       tt_erros_doctos.cod_ser_nota     = tt_file_import_docto.cod_ser_nota   
                       tt_erros_doctos.cdn_fornecedor   = tt_file_import_docto.cdn_fornecedor
                       tt_erros_doctos.num_line         = tt_file_import_docto.num_line
                       tt_erros_doctos.ttv_des_mensagem = "ERRO: Fornecedor n∆o cadastrado.".

                ASSIGN v_log_erro = YES.
    
                NEXT.
            END.
    
            IF  tt_file_import_docto.ind_orig_docto <> "Recebimento" THEN DO:
                CREATE tt_erros_doctos.
                ASSIGN tt_erros_doctos.cod_estab        = tt_file_import_docto.cod_estab      
                       tt_erros_doctos.cod_docto_entr   = tt_file_import_docto.cod_docto_entr 
                       tt_erros_doctos.cod_ser_nota     = tt_file_import_docto.cod_ser_nota   
                       tt_erros_doctos.cdn_fornecedor   = tt_file_import_docto.cdn_fornecedor
                       tt_erros_doctos.num_line         = tt_file_import_docto.num_line
                       tt_erros_doctos.ttv_des_mensagem = "ERRO: Origem deve ser Recebimento.".

                ASSIGN v_log_erro = YES.
    
                NEXT.
            END.
    
            IF  tt_file_import_docto.ind_tip_docto_entr <> "Nota Fiscal" THEN DO:
                CREATE tt_erros_doctos.
                ASSIGN tt_erros_doctos.cod_estab        = tt_file_import_docto.cod_estab      
                       tt_erros_doctos.cod_docto_entr   = tt_file_import_docto.cod_docto_entr 
                       tt_erros_doctos.cod_ser_nota     = tt_file_import_docto.cod_ser_nota   
                       tt_erros_doctos.cdn_fornecedor   = tt_file_import_docto.cdn_fornecedor
                       tt_erros_doctos.num_line         = tt_file_import_docto.num_line
                       tt_erros_doctos.ttv_des_mensagem = "ERRO: Tipo do documento deve ser Nota Fiscal.".

                ASSIGN v_log_erro = YES.
    
                NEXT.
            END.
    
            IF  tt_file_import_docto.val_item_docto_entr <= 0 THEN DO:
                CREATE tt_erros_doctos.
                ASSIGN tt_erros_doctos.cod_estab        = tt_file_import_docto.cod_estab      
                       tt_erros_doctos.cod_docto_entr   = tt_file_import_docto.cod_docto_entr 
                       tt_erros_doctos.cod_ser_nota     = tt_file_import_docto.cod_ser_nota   
                       tt_erros_doctos.cdn_fornecedor   = tt_file_import_docto.cdn_fornecedor
                       tt_erros_doctos.num_line         = tt_file_import_docto.num_line
                       tt_erros_doctos.ttv_des_mensagem = "ERRO: Valor deve ser informado.".

                ASSIGN v_log_erro = YES.
    
                NEXT.
            END.
    
            IF  tt_file_import_docto.qtd_item_docto_entr <= 0 THEN DO:
                CREATE tt_erros_doctos.
                ASSIGN tt_erros_doctos.cod_estab        = tt_file_import_docto.cod_estab      
                       tt_erros_doctos.cod_docto_entr   = tt_file_import_docto.cod_docto_entr 
                       tt_erros_doctos.cod_ser_nota     = tt_file_import_docto.cod_ser_nota   
                       tt_erros_doctos.cdn_fornecedor   = tt_file_import_docto.cdn_fornecedor
                       tt_erros_doctos.num_line         = tt_file_import_docto.num_line
                       tt_erros_doctos.ttv_des_mensagem = "ERRO: Quantidade deve ser informada.".

                ASSIGN v_log_erro = YES.
    
                NEXT.
            END.
    
            IF  NOT(CAN-FIND(docto_entr NO-LOCK 
                            WHERE docto_entr.cod_estab      = tt_file_import_docto.cod_estab
                            AND   docto_entr.cod_empresa    = tt_file_import_docto.cod_empresa
                            AND   docto_entr.cdn_fornecedor = tt_file_import_docto.cdn_fornecedor
                            AND   docto_entr.cod_docto_entr = tt_file_import_docto.cod_docto_entr
                            AND   docto_entr.cod_ser_nota   = tt_file_import_docto.cod_ser_nota)) THEN do:
    
                CREATE docto_entr.
                ASSIGN docto_entr.cod_estab          = tt_file_import_docto.cod_estab
                       docto_entr.cod_docto_entr     = tt_file_import_docto.cod_docto_entr
                       docto_entr.des_docto_entr     = tt_file_import_docto.des_docto_entr
                       docto_entr.dat_docto          = tt_file_import_docto.dat_docto
                       docto_entr.cod_empresa        = tt_file_import_docto.cod_empres
                       docto_entr.cdn_fornecedor     = tt_file_import_docto.cdn_fornecedor
                       docto_entr.ind_orig_docto     = tt_file_import_docto.ind_orig_docto
                       docto_entr.cod_ser_nota       = tt_file_import_docto.cod_ser_nota
                       docto_entr.ind_tip_docto_entr = tt_file_import_docto.ind_tip_docto_entr.
            END.
    
            CREATE item_docto_entr.
            ASSIGN item_docto_entr.cod_estab                   = tt_file_import_docto.cod_estab
                   item_docto_entr.cod_empresa                 = tt_file_import_docto.cod_empres
                   item_docto_entr.cdn_fornecedor              = tt_file_import_docto.cdn_fornecedor
                   item_docto_entr.cod_docto_entr              = tt_file_import_docto.cod_docto_entr
                   item_docto_entr.cod_ser_nota                = tt_file_import_docto.cod_ser_nota
                   item_docto_entr.cod_indic_econ              = tt_file_import_docto.cod_indic_econ
                   item_docto_entr.val_item_docto_entr         = tt_file_import_docto.val_item_docto_entr
                   /*item_docto_entr.val_aquis_bem_pat_fasb      = 0
                   item_docto_entr.val_aquis_bem_pat_cmcac     = 0*/
                   item_docto_entr.qtd_item_docto_entr         = tt_file_import_docto.qtd_item_docto_entr
                   item_docto_entr.num_ord_invest              = tt_file_import_docto.num_ord_invest
                   /*item_docto_entr.num_om                      = 0*/
                   item_docto_entr.log_classif_item_docto_entr = NO
                   item_docto_entr.des_item_docto_entr         = tt_file_import_docto.des_item_docto_entr
                   item_docto_entr.cod_livre_1                 = "PADRAO"                        + CHR(10) +
                                                                 tt_file_import_docto.cod_ccusto + CHR(10) +
                                                                 SUBSTRING(tt_file_import_docto.narrativa,1,72) + CHR(10) +
                                                                 tt_file_import_docto.cod_unid_negoc  + CHR(10) + CHR(10).
    
            FIND LAST b_item_docto_entr NO-LOCK
                 WHERE b_item_docto_entr.cod_estab      = tt_file_import_docto.cod_estab     
                 AND   b_item_docto_entr.cod_empresa    = tt_file_import_docto.cod_empres    
                 AND   b_item_docto_entr.cdn_fornecedor = tt_file_import_docto.cdn_fornecedor
                 AND   b_item_docto_entr.cod_docto_entr = tt_file_import_docto.cod_docto_entr
                 AND   b_item_docto_entr.cod_ser_nota   = tt_file_import_docto.cod_ser_nota NO-ERROR.
    
            IF  NOT AVAIL b_item_docto_entr THEN
                ASSIGN item_docto_entr.num_item_docto_entr = 10.
            ELSE
                ASSIGN item_docto_entr.num_item_docto_entr = b_item_docto_entr.num_item_docto_entr + 10.
    
            RELEASE docto_entr.
            RELEASE item_docto_entr.
    
            CREATE tt_sucesso_doctos.
            ASSIGN tt_sucesso_doctos.num_line         = tt_file_import_docto.num_line
                   tt_sucesso_doctos.cod_estab        = tt_file_import_docto.cod_estab      
                   tt_sucesso_doctos.cod_docto_entr   = tt_file_import_docto.cod_docto_entr 
                   tt_sucesso_doctos.cod_ser_nota     = tt_file_import_docto.cod_ser_nota   
                   tt_sucesso_doctos.cdn_fornecedor   = tt_file_import_docto.cdn_fornecedor 
                   tt_sucesso_doctos.ttv_des_mensagem = "OK: Documento de entrada importado com sucesso.".
        END.
        
        IF  v_log_erro = YES THEN DO:
            UNDO bloco_docto, LEAVE bloco_docto.
        END.
    END.

END PROCEDURE.

PROCEDURE pi_atualiza_quant_item_docto_entr:
    DEF INPUT PARAM p_rec_table        AS RECID FORMAT ">>>>>>9"  NO-UNDO.
    DEF INPUT PARAM p_num_quant_vincul AS INT   FORMAT ">>>>,>>9" NO-UNDO.
    DEF INPUT PARAM p_cod_acao         AS CHAR  FORMAT "x(8)"     NO-UNDO.

    DEF BUFFER b_item_docto_entr FOR item_docto_entr.

    DEF VAR v_num_quant_aux AS INT NO-UNDO.

    FIND FIRST b_item_docto_entr EXCLUSIVE-LOCK
        WHERE RECID(b_item_docto_entr) = p_rec_table NO-ERROR.

    IF  AVAIL b_item_docto_entr THEN DO:
        ASSIGN v_num_quant_aux = INT(ENTRY(5,b_item_docto_entr.cod_livre_1,CHR(10))).

        IF  p_cod_acao = "Desvincula" THEN
            ASSIGN v_num_quant_aux = v_num_quant_aux - p_num_quant_vincul.
        ELSE /* Vincula */
            ASSIGN v_num_quant_aux = v_num_quant_aux + p_num_quant_vincul.

        ASSIGN ENTRY(5,b_item_docto_entr.cod_livre_1,CHR(10)) = STRING(v_num_quant_aux).

        /* Verifica se o item n∆o foi totalmente utilizado e atualiza o campo log_classif_item_docto_entr */
        IF  b_item_docto_entr.qtd_item_docto_entr <> INT(ENTRY(5,b_item_docto_entr.cod_livre_1,CHR(10))) THEN
            ASSIGN b_item_docto_entr.log_classif_item_docto_entr = NO.
        ELSE 
            ASSIGN b_item_docto_entr.log_classif_item_docto_entr = YES.
    END.
END PROCEDURE.

PROCEDURE pi_imprime_erros:

    IF  tt-param.tipo-import = 1 THEN DO:
        PUT UNFORMATTED
            "Importaá∆o de Documentos de Entrada;;;;;"       SKIP
            ";;;;;"                                          SKIP
            "Linha;Estab;Docto Entrada;Serie;Fornecedor;Mensagem" SKIP.
    
        IF  CAN-FIND(FIRST tt_sucesso_doctos) THEN DO:
            FOR EACH tt_sucesso_doctos:
                PUT UNFORMATTED string(tt_sucesso_doctos.num_line)       + ";" +
                                tt_sucesso_doctos.cod_estab              + ";" +
                                tt_sucesso_doctos.cod_docto_entr         + ";" +
                                tt_sucesso_doctos.cod_ser_nota           + ";" +
                                string(tt_sucesso_doctos.cdn_fornecedor) + ";" +
                                tt_sucesso_doctos.ttv_des_mensagem SKIP.
            END.
        END.
    
        IF  CAN-FIND(FIRST tt_erros_doctos) THEN DO:
            FOR EACH tt_erros_doctos:
                PUT UNFORMATTED string(tt_erros_doctos.num_line)       + ";" +
                                tt_erros_doctos.cod_estab              + ";" +
                                tt_erros_doctos.cod_docto_entr         + ";" +
                                tt_erros_doctos.cod_ser_nota           + ";" +
                                string(tt_erros_doctos.cdn_fornecedor) + ";" +
                                tt_erros_doctos.ttv_des_mensagem SKIP.
            END.
        END.
    END.

    IF  tt-param.tipo-import = 2 THEN DO:
        PUT UNFORMATTED
            "Importaá∆o de Bens;;;;"      SKIP
            ";;;;"                        SKIP
            "Linha;Conta Pat;Bem;Seq;Mensagem" SKIP.
    
        IF  CAN-FIND(FIRST tt_sucesso_bens) THEN DO:
            FOR EACH tt_sucesso_bens:
                PUT UNFORMATTED string(tt_sucesso_bens.num_line)         + ";" +
                                tt_sucesso_bens.cod_cta_pat              + ";" +
                                string(tt_sucesso_bens.num_bem_pat)      + ";" +
                                string(tt_sucesso_bens.num_seq_bem_pat)  + ";" +
                                tt_sucesso_bens.ttv_des_mensagem SKIP.
            END.
        END.
    
        IF  CAN-FIND(FIRST tt_erros_bens) THEN DO:
            FOR EACH tt_erros_bens:
                PUT UNFORMATTED string(tt_erros_bens.num_line)         + ";" +
                                tt_erros_bens.cod_cta_pat              + ";" +
                                string(tt_erros_bens.num_bem_pat)      + ";" +
                                string(tt_erros_bens.num_seq_bem_pat)  + ";" +
                                tt_erros_bens.ttv_des_mensagem SKIP.
            END.
        END.
    END.

END PROCEDURE.
