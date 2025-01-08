 /******************************************************************************************
**  Programa: esacr082rp.p
**  Funcao..: Importar liquidaá∆o conciliaá∆o financeira
**  Autor...: Gesplus Software
**  Data....: jan/2020  
**  Versao..: 1.00.00.000 - Versao Inicial.
******************************************************************************************/
/* include de controle de vers∆o */
{include/i-prgvrs.i esacr082rp 1.00.00.001}
{include/i-rpvar.i}
{utp/ut-glob.i}
{cdp/cdcfgmat.i} 
{esp/acr/esacr082.i} /* definiá‰es para geraá∆o da liquidaá∆o */

/* preprocessador para ativar ou nao a saida para RTF */
&GLOBAL-DEFINE RTF NO
/* preprocessador para setar o tamanho da pagina */
&SCOPED-DEFINE pagesize 62  

/* definicao das temp-tables para recebimento de parametros */
DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino      AS INTEGER
    FIELD arquivo      AS CHAR FORMAT "x(35)":U
    FIELD usuario      AS CHAR FORMAT "x(12)":U
    FIELD data-exec    AS DATE
    FIELD hora-exec    AS INTEGER
    FIELD arquivo-import AS CHAR FORMAT "x(256)".   

DEFINE TEMP-TABLE tt-raw-digita NO-UNDO
    FIELD raw-digita	   AS RAW.

/* recebimento de parametros */
DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

/* definiá∆o de variaveis */
DEF VAR h-acomp             AS HANDLE        NO-UNDO.
DEF VAR c-arq-rec           AS CHARACTER     NO-UNDO. 
DEF VAR c-arq-import        AS CHARACTER     NO-UNDO. 
DEF VAR c-arq-log           AS CHARACTER     NO-UNDO. 
DEF VAR c1                  AS CHARACTER NO-UNDO. /*file name*/
DEF VAR c2                  AS CHARACTER NO-UNDO. /*file name with path*/
DEF VAR c_erro_aux          AS CHAR FORMAT "x(256)".
DEF VAR c-arq-log-aux       AS CHAR NO-UNDO.

/* temp-table onde seraˇ gravado o nome dos arquivos para importaá∆o */ 
DEFINE TEMP-TABLE tt-arquivo    
    FIELD nm-arquivo-completo AS CHAR FORMAT "x(256)"
    FIELD nm-arquivo          AS CHAR FORMAT "x(256)". 

DEFINE TEMP-TABLE tt-estab-lote    
    FIELD cod_estab             LIKE tit_acr.cod_estab.   /* char */

/* temp-table com os dados da planilha de importaá∆o */
DEFINE TEMP-TABLE tt-import    
    FIELD linha                 AS INT /* int */
    /*titulo*/
    FIELD cod_estab             LIKE tit_acr.cod_estab   /* char */
    FIELD cod_espec_docto       LIKE tit_acr.cod_espec_docto /* char */
    FIELD cod_ser_docto         LIKE tit_acr.cod_ser_docto /* char */
    FIELD cod_tit_acr           LIKE tit_acr.cod_tit_acr /* char */
    FIELD cod_parcela           LIKE tit_acr.cod_parcela /* char */
    FIELD val_liquidacao        LIKE tit_acr.val_liq_tit_acr /* deci */
    FIELD dat_liquidacao        LIKE tit_acr.dat_emis_docto /* date */ 
    FIELD lote                  LIKE tit_acr.cod_refer /* char */
    FIELD val_abat_tit_acr      LIKE tit_acr.val_abat_tit_acr /* deci */
    FIELD val_juros             LIKE tit_acr.val_juros /* deci */
    /*an*/
    FIELD cod_estab_an          LIKE tit_acr.cod_estab   /* char */
    FIELD cod_espec_docto_an    LIKE tit_acr.cod_espec_docto /* char */
    FIELD cod_ser_docto_an      LIKE tit_acr.cod_ser_docto /* char */
    FIELD cod_tit_acr_an        LIKE tit_acr.cod_tit_acr /* char */
    FIELD cod_parcela_an        LIKE tit_acr.cod_parcela /* char */
    FIELD cod_cta_ctbl          AS CHARACTER FORMAT "x(20)" LABEL "Conta Contabil" COLUMN-LABEL "Conta Contabil"
    FIELD cod_ccusto            AS CHARACTER FORMAT "x(11)" LABEL "Centro Custo" column-label "Centro Custo".

/* inicio */
FIND FIRST mguni.empresa NO-LOCK   
     WHERE empresa.ep-codigo = v_cdn_empres_usuar NO-ERROR.  

assign c-versao       = "1.00"
       c-revisao      = "000"
       c-empresa      = empresa.razao-social
       c-programa     = "esacr082rp.p"
       c-titulo-relat = "Importar Liquidaá∆o Conciliaá∆o Financeira".
       

{include/i-rpcab.i}
{include/i-rpout.i}

VIEW FRAME f-cabec.
VIEW FRAME f-rodape.

DEF STREAM s1.

/************** BLOCO PRINCIPAL ***************/

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
RUN pi-inicializar IN h-acomp (INPUT "In°cio Importaá∆o"). 

FIND FIRST tt-param NO-ERROR.
FIND FIRST param-concil-financ NO-LOCK NO-ERROR.
FIND FIRST matriz_trad_org_ext NO-LOCK NO-ERROR.

/* validar diret¢rios de importaá∆o */
RUN pi-valida-diretorios. 
IF RETURN-VALUE = "NOK" THEN DO:
    RUN pi-finalizar IN h-acomp.
    RETURN "NOK".
END.

/* carregar arquivo(s) */
RUN pi-carrega-arquivos.

RUN pi-inicializar IN h-acomp (INPUT "Processando arquivos...").

/* processar arquivo(s) */
RUN pi-processa-arquivos.

RUN pi-finalizar IN h-acomp.

{include/i-rpclo.i}

RETURN "OK":U.

/************** PROCEDURES ***************/

PROCEDURE pi-valida-diretorios: /* validaá‰es diretorios de importaá∆o */
    
    /* quando n∆o for informado arquivo em tela, vai validar diretorio de arquivos recebidos */
    IF tt-param.arquivo-import = "" THEN DO:           
        IF param-concil-financ.dir-arq-recebidos-liq = "" OR 
           param-concil-financ.dir-arq-recebidos-liq = ? THEN DO:
            PUT "Erro: Diret¢rio de arquivos recebidos n∆o parametrizado. Verificar parÉmetros conciliaá∆o financeira.".
            RETURN "NOK".
        END.
    END.
    
    IF param-concil-financ.dir-arq-importados-liq = "" OR 
       param-concil-financ.dir-arq-importados-liq = ? THEN DO:
        PUT "Erro: Diret¢rio de arquivos importados n∆o parametrizado. Verificar parÉmetros conciliaá∆o financeira.".
        RETURN "NOK".
    END.
    
    IF param-concil-financ.dir-arq-log-liq = "" OR 
       param-concil-financ.dir-arq-log-liq = ? THEN DO:
        PUT "Erro: Diret¢rio de arquivos log n∆o parametrizado. Verificar parÉmetros conciliaá∆o financeira.".
        RETURN "NOK".
    END.

END PROCEDURE.

PROCEDURE pi-carrega-arquivos: /* carregar temp-table tt-arquivo com os arquivos que ser∆o importados */

    EMPTY TEMP-TABLE tt-arquivo.

    ASSIGN c-arq-rec     = param-concil-financ.dir-arq-recebidos-liq
           c-arq-import  = param-concil-financ.dir-arq-importados-liq
           c-arq-log     = param-concil-financ.dir-arq-log-liq.  

    IF tt-param.arquivo-import = "" THEN DO:                        
        IF OPSYS = 'WIN32' THEN
            ASSIGN c-arq-rec    = REPLACE(c-arq-rec,'/','\')
                   c-arq-import = REPLACE(c-arq-import,'/','\')
                   c-arq-log    = REPLACE(c-arq-log,'/','\').
    
        INPUT FROM OS-DIR(c-arq-rec) CONVERT SOURCE 'iso8859-1'.
        REPEAT:
            IMPORT c1 c2 .
            IF c1 = "." OR c1 = ".." THEN NEXT.
            CREATE tt-arquivo. 
            ASSIGN tt-arquivo.nm-arquivo-completo = c2
                   tt-arquivo.nm-arquivo = c1.    
        END.
        INPUT CLOSE.
    END.
    ELSE DO:
        CREATE tt-arquivo. 
        ASSIGN tt-arquivo.nm-arquivo-completo = tt-param.arquivo-import
               tt-arquivo.nm-arquivo          = tt-param.arquivo-import.
    END.

END PROCEDURE.

PROCEDURE pi-processa-arquivos: /* processar arquivos de importaá∆o */

    ASSIGN c-arq-log-aux = c-arq-log + "LogLiquid-Mes" + STRING(MONTH(TODAY),"99") + "-Dia" + STRING(DAY(TODAY),"99") + "-" + STRING(TIME) + ".txt".
    OUTPUT STREAM s1 TO VALUE(c-arq-log-aux) CONVERT TARGET "iso8859-1".

    FOR EACH tt-arquivo:

        RUN pi-acompanhar IN h-acomp (INPUT "Lendo arquivo: " + tt-arquivo.nm-arquivo). 

        /* importar dados do arquivo csv separado por ponto e v°rgula */
        RUN pi-importa.

        /* cria tt-estab-lote para criar lote por estabelecimento */
        RUN pi-cria-tt-estab-lote.

        /* gerar liquidaá∆o */
        IF CAN-FIND(FIRST tt-import) THEN DO:
            EMPTY TEMP-TABLE tt_erros.

            DO TRANS:

                RUN pi-gera-rateio.

                /* mostra dados importados -> monta log */
                RUN pi-mostra-dados (INPUT "Rateio").

                /* M2103-095 - definido para n∆o desfazer todo o processo
                IF  CAN-FIND(FIRST tt_erros) THEN
                    UNDO,LEAVE. */
            END.

            RUN pi-gera-liq.

            RUN pi-move-arquivo (INPUT tt-arquivo.nm-arquivo-completo).
        END.
        ELSE DO:
            PUT "Arquivo inv†lido, ou em branco, ou n∆o est† no modelo definido para importaá∆o. Arquivo n∆o ser† movido para o diret¢rio de importados." AT 03 SKIP(1).
            
            PUT STREAM s1 "Arquivo inv†lido, ou em branco, ou n∆o est† no modelo definido para importaá∆o. Arquivo n∆o ser† movido para o diret¢rio de importados." AT 03 SKIP(1).
        END.        
    END.

    OUTPUT STREAM s1 CLOSE.

END PROCEDURE.

PROCEDURE pi-gera-rateio:

    run prgfin/acr/acr711zv.py persistent set v_hdl_program .

    DEF VAR i-cont-seq AS INT NO-UNDO.
    DEF VAR d_val_sdo_tit_acr AS DEC NO-UNDO.

    FOR EACH tt-import
       WHERE tt-import.cod_cta_ctbl <> ""
       BREAK BY tt-import.cod_tit_acr
             BY tt-import.cod_parcela:

        RUN pi-acompanhar IN h-acomp (INPUT "Gera Rateio - T°tulo: " + tt-import.cod_tit_acr).

        IF  FIRST-OF(tt-import.cod_tit_acr)
        OR  FIRST-OF(tt-import.cod_parcela) THEN DO:

            EMPTY TEMP-TABLE tt_alter_tit_acr_rateio.

            FIND FIRST tit_acr_rateio NO-LOCK 
                 WHERE tit_acr_rateio.cod_estab       = tt-import.cod_estab      
                 AND   tit_acr_rateio.cod_espec_docto = tt-import.cod_espec_docto
                 AND   tit_acr_rateio.cod_ser_docto   = tt-import.cod_ser_docto  
                 AND   tit_acr_rateio.cod_tit_acr     = tt-import.cod_tit_acr    
                 AND   tit_acr_rateio.cod_parcela     = tt-import.cod_parcela NO-ERROR.
            
            IF  NOT AVAIL tit_acr_rateio THEN
                NEXT.

            FIND FIRST val_tit_acr NO-LOCK
                WHERE val_tit_acr.cod_estab       = tit_acr_rateio.cod_estab
                AND   val_tit_acr.num_id_tit_acr  = tit_acr_rateio.num_id_tit_acr 
                AND   val_tit_acr.val_sdo_tit_acr > 0 NO-ERROR.

            RUN pi-gera-referencia IN THIS-PROCEDURE (INPUT  tit_acr_rateio.cod_estab,
                                                      INPUT  RECID(tit_acr_rateio),
                                                      OUTPUT v_cod_refer).

            IF  v_cod_refer = "" THEN NEXT.

            RUN pi-elimina-item-lote-rateio.

            ASSIGN d_val_sdo_tit_acr = tit_acr_rateio.val_sdo_tit_acr.
        END.

        IF  NOT AVAIL tit_acr_rateio THEN
            NEXT.
        
	    ASSIGN i-cont-seq = i-cont-seq + 10.
    
        CREATE tt_alter_tit_acr_rateio.
        ASSIGN tt_alter_tit_acr_rateio.tta_cod_estab                   = tit_acr_rateio.cod_estab
               tt_alter_tit_acr_rateio.tta_num_id_tit_acr              = tit_acr_rateio.num_id_tit_acr
               tt_alter_tit_acr_rateio.ttv_ind_tip_rat_tit_acr         = "Alteraá∆o":U /*l_alteracao*/ 
               tt_alter_tit_acr_rateio.tta_cod_refer                   = v_cod_refer
               tt_alter_tit_acr_rateio.tta_num_seq_refer               = 1
               tt_alter_tit_acr_rateio.tta_cod_plano_cta_ctbl          = "padrao":U
               tt_alter_tit_acr_rateio.tta_cod_cta_ctbl                = tt-import.cod_cta_ctbl
               tt_alter_tit_acr_rateio.tta_cod_unid_negoc              = IF AVAIL val_tit_acr THEN val_tit_acr.cod_unid_negoc ELSE "SEC"
               tt_alter_tit_acr_rateio.tta_cod_plano_ccusto            = "padrao":U //tt-import.cod_cta_ctbl /*cta_grp_clien.cod_plano_ccusto*/
               tt_alter_tit_acr_rateio.tta_cod_ccusto                  = tt-import.cod_ccusto // 21045
               tt_alter_tit_acr_rateio.tta_cod_tip_fluxo_financ        = IF AVAIL val_tit_acr THEN val_tit_acr.cod_tip_fluxo_financ ELSE "103"
               tt_alter_tit_acr_rateio.tta_num_seq_aprop_ctbl_pend_acr = i-cont-seq
               tt_alter_tit_acr_rateio.tta_val_aprop_ctbl              = tt-import.val_liquidacao. /* tit_acr_rateio.val_sdo_tit_acr */

        ASSIGN d_val_sdo_tit_acr = d_val_sdo_tit_acr - tt-import.val_liquidacao.

        IF  LAST-OF(tt-import.cod_tit_acr) 
        OR  LAST-OF(tt-import.cod_parcela) THEN DO:    
            
            EMPTY TEMP-TABLE tt_alter_tit_acr_base_5.

            CREATE tt_alter_tit_acr_base_5.
            ASSIGN tt_alter_tit_acr_base_5.tta_cod_estab                   = tit_acr_rateio.cod_estab                     
                   tt_alter_tit_acr_base_5.tta_num_id_tit_acr              = tit_acr_rateio.num_id_tit_acr
                   tt_alter_tit_acr_base_5.tta_dat_transacao               = tt-import.dat_liquidacao
                   tt_alter_tit_acr_base_5.tta_cod_refer                   = v_cod_refer
                   tt_alter_tit_acr_base_5.ttv_cod_motiv_movto_tit_acr_imp = ?
                   tt_alter_tit_acr_base_5.tta_val_sdo_tit_acr             = d_val_sdo_tit_acr /* tit_acr.val_sdo_tit_acr */
                   tt_alter_tit_acr_base_5.ttv_cod_motiv_movto_tit_acr_alt = ?
                   tt_alter_tit_acr_base_5.ttv_ind_motiv_acerto_val        = "Liquidaá∆o"
                   tt_alter_tit_acr_base_5.tta_cod_portador                = ? 
                   tt_alter_tit_acr_base_5.tta_cod_cart_bcia               = tit_acr_rateio.cod_cart_bcia
                   tt_alter_tit_acr_base_5.tta_val_despes_bcia             = ?
                   tt_alter_tit_acr_base_5.tta_cod_agenc_cobr_bcia         = ?
                   tt_alter_tit_acr_base_5.tta_cod_tit_acr_bco             = ?
                   tt_alter_tit_acr_base_5.tta_dat_emis_docto              = 01/01/0001
                   tt_alter_tit_acr_base_5.tta_dat_vencto_tit_acr          = 01/01/0001
                   tt_alter_tit_acr_base_5.tta_dat_prev_liquidac           = 01/01/0001 
                   tt_alter_tit_acr_base_5.tta_dat_fluxo_tit_acr           = 01/01/0001
                   tt_alter_tit_acr_base_5.tta_ind_sit_tit_acr             = ?
                   tt_alter_tit_acr_base_5.tta_cod_cond_cobr               = ?
                   tt_alter_tit_acr_base_5.tta_log_tip_cr_perda_dedut_tit  = ?
                   tt_alter_tit_acr_base_5.tta_dat_abat_tit_acr            = ?
                   tt_alter_tit_acr_base_5.tta_val_perc_abat_acr           = ?
                   tt_alter_tit_acr_base_5.tta_val_abat_tit_acr            = ?
                   tt_alter_tit_acr_base_5.tta_dat_desconto                = ?
                   tt_alter_tit_acr_base_5.tta_val_perc_desc               = ?
                   tt_alter_tit_acr_base_5.tta_val_desc_tit_acr            = ?
                   tt_alter_tit_acr_base_5.tta_qtd_dias_carenc_juros_acr   = ?
                   tt_alter_tit_acr_base_5.tta_val_perc_juros_dia_atraso   = ?
                   tt_alter_tit_acr_base_5.tta_qtd_dias_carenc_multa_acr   = ?
                   tt_alter_tit_acr_base_5.tta_val_perc_multa_atraso       = ?
                   tt_alter_tit_acr_base_5.ttv_cod_portador_mov            = ?
                   tt_alter_tit_acr_base_5.tta_ind_tip_cobr_acr            = ?
                   tt_alter_tit_acr_base_5.tta_ind_ender_cobr              = ?
                   tt_alter_tit_acr_base_5.tta_nom_abrev_contat            = ?
                   tt_alter_tit_acr_base_5.tta_val_liq_tit_acr             = ?
                   tt_alter_tit_acr_base_5.tta_cod_instruc_bcia_1_movto    = ?
                   tt_alter_tit_acr_base_5.tta_cod_instruc_bcia_2_movto    = ?
                   tt_alter_tit_acr_base_5.tta_log_tit_acr_destndo         = ?
                   tt_alter_tit_acr_base_5.tta_cod_histor_padr             = ?
                   tt_alter_tit_acr_base_5.ttv_des_text_histor             = ?
                   tt_alter_tit_acr_base_5.tta_des_obs_cobr                = ?
                   tt_alter_tit_acr_base_5.tta_num_seq_tit_acr             = ?            
                   tt_alter_tit_acr_base_5.ttv_cod_estab_planilha          = ?
                   tt_alter_tit_acr_base_5.tta_cod_tit_acr_bco             = ?
                   tt_alter_tit_acr_base_5.ttv_des_text_histor             = "N∆o Valida"
                   tt_alter_tit_acr_base_5.tta_cdn_repres                  = ?.
    
            run pi_main_code_integr_acr_alter_tit_acr_novo_14 in v_hdl_program (input  14,
                                                                                input table tt_alter_tit_acr_base_5,
                                                                                input table tt_alter_tit_acr_rateio,
                                                                                input table tt_alter_tit_acr_ped_vda,                                                                     
                                                                                input table tt_alter_tit_acr_comis_1,                                                      
                                                                                input table tt_alter_tit_acr_cheq,                                                      
                                                                                input table tt_alter_tit_acr_iva,                                                      
                                                                                input table tt_alter_tit_acr_impto_retid_2,                                                      
                                                                                input table tt_alter_tit_acr_cobr_espec_2,                                                      
                                                                                input table tt_alter_tit_acr_rat_desp_rec,                                                      
                                                                                output table tt_log_erros_alter_tit_acr,                                                      
                                                                                input yes,
                                                                                input table  tt_alter_tit_acr_cobr_esp_2_c,
                                                                                input table  tt_params_generic_api).

            IF CAN-FIND(FIRST tt_log_erros_alter_tit_acr) THEN DO:
                FOR EACH tt_log_erros_alter_tit_acr:
                    CREATE tt_erros.
                    ASSIGN tt_erros.ttv_cod_message  = STRING(tt_log_erros_alter_tit_acr.ttv_num_mensagem)
                           tt_erros.ttv_des_msg_erro = tt_log_erros_alter_tit_acr.ttv_des_msg_erro + " " + tt_log_erros_alter_tit_acr.ttv_des_msg_ajuda
                           tt_erros.cod_estab        = tt-import.cod_estab      
                           tt_erros.cod_espec_docto  = tt-import.cod_espec_docto
                           tt_erros.cod_ser_docto    = tt-import.cod_ser_docto      
                           tt_erros.cod_tit_acr      = tt-import.cod_tit_acr    
                           tt_erros.cod_parcela      = tt-import.cod_parcela.
                END.
            END.
        END.        
    END.

    DELETE PROCEDURE v_hdl_program.

END PROCEDURE.

PROCEDURE pi-importa : /* importar dados da planilha */

    DEF VAR i-linha                 AS INT                        NO-UNDO.
    /*
    DEF VAR i_tamanho_doc           AS INT                        NO-UNDO.
    DEF VAR i_tamanho_par           AS INT                        NO-UNDO.   
    */

    DEF VAR v_cod_estab             LIKE tit_acr.cod_estab        NO-UNDO.
    DEF VAR v_cod_espec_docto       LIKE tit_acr.cod_espec_docto  NO-UNDO.
    DEF VAR v_cod_ser_docto         LIKE tit_acr.cod_ser_docto    NO-UNDO.
    DEF VAR v_cod_tit_acr           LIKE tit_acr.cod_tit_acr      NO-UNDO.
    DEF VAR v_cod_parcela           LIKE tit_acr.cod_parcela      NO-UNDO.
    DEF VAR v_val_liquidacao        LIKE tit_acr.val_liq_tit_acr  NO-UNDO.
    DEF VAR v_dat_liquidacao        LIKE tit_acr.dat_emis_docto   NO-UNDO.
    DEF VAR v_lote                  LIKE tit_acr.cod_refer        NO-UNDO.
    DEF VAR v_val_abat_tit_acr      LIKE tit_acr.val_abat_tit_acr NO-UNDO.
    DEF VAR v_val_juros             LIKE tit_acr.val_juros        NO-UNDO.          
    DEF VAR v_cod_estab_an          LIKE tit_acr.cod_estab        NO-UNDO. 
    DEF VAR v_cod_espec_docto_an    LIKE tit_acr.cod_espec_docto  NO-UNDO.
    DEF VAR v_cod_ser_docto_an      LIKE tit_acr.cod_ser_docto    NO-UNDO.
    DEF VAR v_cod_tit_acr_an        LIKE tit_acr.cod_tit_acr      NO-UNDO.
    DEF VAR v_cod_parcela_an        LIKE tit_acr.cod_parcela      NO-UNDO.
    DEF VAR v_cod_cta_ctbl          LIKE tt-import.cod_cta_ctbl   NO-UNDO.
    DEF VAR v_cod_ccusto            LIKE tt-import.cod_ccusto     NO-UNDO.
    DEF VAR v_des_reg_import        AS CHAR FORMAT "x(200)":U     NO-UNDO. 

    EMPTY TEMP-TABLE tt-import.
    
    INPUT FROM VALUE(tt-arquivo.nm-arquivo-completo) NO-CONVERT.
    
    REPEAT:
        IMPORT UNFORMATTED v_des_reg_import.
    
        ASSIGN i-linha = i-linha + 1.
    
        IF  i-linha = 1 THEN
            NEXT.

        run pi-acompanhar in h-acomp (input "Importando arquivo: " + tt-arquivo.nm-arquivo + " - Linha: " + string(v_num_line)).

        ASSIGN v_cod_estab          = TRIM(ENTRY(1,  v_des_reg_import, ";"))                    
               v_cod_espec_docto    = TRIM(ENTRY(2,  v_des_reg_import, ";")) 
               v_cod_ser_docto      = TRIM(ENTRY(3,  v_des_reg_import, ";")) 
               v_cod_tit_acr        = TRIM(ENTRY(4,  v_des_reg_import, ";")) 
               v_cod_parcela        = TRIM(ENTRY(5,  v_des_reg_import, ";")) 
               v_val_liquidacao     =  DEC(ENTRY(6,  v_des_reg_import, ";"))
               v_dat_liquidacao     = DATE(ENTRY(7,  v_des_reg_import, ";"))
               v_lote               = TRIM(ENTRY(8,  v_des_reg_import, ";")) 
               v_val_abat_tit_acr   =  DEC(ENTRY(9,  v_des_reg_import, ";"))
               v_val_juros          =  DEC(ENTRY(10, v_des_reg_import, ";"))
               v_cod_estab_an       = TRIM(ENTRY(11, v_des_reg_import, ";"))
               v_cod_espec_docto_an = TRIM(ENTRY(12, v_des_reg_import, ";"))
               v_cod_ser_docto_an   = TRIM(ENTRY(13, v_des_reg_import, ";"))
               v_cod_tit_acr_an     = TRIM(ENTRY(14, v_des_reg_import, ";"))
               v_cod_parcela_an     = TRIM(ENTRY(15, v_des_reg_import, ";"))
               v_cod_cta_ctbl       = ""
               v_cod_ccusto         = "". 

        IF  NUM-ENTRIES(v_des_reg_import,";") > 15 THEN
            ASSIGN v_cod_cta_ctbl   = TRIM(ENTRY(16, v_des_reg_import, ";"))
                   v_cod_ccusto     = TRIM(ENTRY(17, v_des_reg_import, ";")).

        IF v_lote               = ? THEN ASSIGN v_lote               = "".
        IF v_val_abat_tit_acr   = ? THEN ASSIGN v_val_abat_tit_acr   = 0.
        IF v_val_juros          = ? THEN ASSIGN v_val_juros          = 0.
        IF v_cod_estab_an       = ? THEN ASSIGN v_cod_estab_an       = "".
        IF v_cod_espec_docto_an = ? THEN ASSIGN v_cod_espec_docto_an = "".
        IF v_cod_ser_docto_an   = ? THEN ASSIGN v_cod_ser_docto_an   = "".
        IF v_cod_tit_acr_an     = ? THEN ASSIGN v_cod_tit_acr_an     = "".
        IF v_cod_parcela_an     = ? THEN ASSIGN v_cod_parcela_an     = "".
        IF v_cod_cta_ctbl       = ? THEN ASSIGN v_cod_cta_ctbl       = "".
        IF v_cod_ccusto         = ? THEN ASSIGN v_cod_ccusto         = "".
    
        /*
        ASSIGN i_tamanho_doc = 0
               i_tamanho_par = 0.

        IF  LENGTH(v_cod_tit_acr) < 7 THEN DO:
            ASSIGN i_tamanho_doc = LENGTH(v_cod_tit_acr) + 1.
    
            DO  i_cont = i_tamanho_doc TO 7:
                ASSIGN v_cod_tit_acr = "0" + v_cod_tit_acr.
            END.
        END.
    
        IF  LENGTH(v_cod_parcela) < 2 THEN DO:
            ASSIGN i_tamanho_par = LENGTH(v_cod_parcela) + 1.
    
            DO  i_cont = i_tamanho_par TO 2:
                ASSIGN v_cod_parcela = "0" + v_cod_parcela.
            END.
        END.

        IF  v_cod_tit_acr_an <> "" THEN DO:
            ASSIGN i_tamanho_doc = 0
                   i_tamanho_par = 0.

            IF  LENGTH(v_cod_tit_acr_an) < 7 THEN DO:
                ASSIGN i_tamanho_doc = LENGTH(v_cod_tit_acr_an) + 1.
        
                DO  i_cont = i_tamanho_doc TO 7:
                    ASSIGN v_cod_tit_acr_an = "0" + v_cod_tit_acr_an.
                END.
            END.
        
            IF  LENGTH(v_cod_parcela_an) < 2 THEN DO:
                ASSIGN i_tamanho_par = LENGTH(v_cod_parcela_an) + 1.
        
                DO  i_cont = i_tamanho_par TO 2:
                    ASSIGN v_cod_parcela_an = "0" + v_cod_parcela_an.
                END.
            END.
        END.
        */

        CREATE tt-import.
        ASSIGN tt-import.linha              = i-linha
               tt-import.cod_estab          = v_cod_estab
               tt-import.cod_espec_docto    = v_cod_espec_docto   
               tt-import.cod_ser_docto      = v_cod_ser_docto     
               tt-import.cod_tit_acr        = v_cod_tit_acr       
               tt-import.cod_parcela        = v_cod_parcela       
               tt-import.val_liquidacao     = v_val_liquidacao    
               tt-import.dat_liquidacao     = v_dat_liquidacao    
               tt-import.lote               = v_lote              
               tt-import.val_abat_tit_acr   = v_val_abat_tit_acr  
               tt-import.val_juros          = v_val_juros         
               tt-import.cod_estab_an       = v_cod_estab_an      
               tt-import.cod_espec_docto_an = v_cod_espec_docto_an
               tt-import.cod_ser_docto_an   = v_cod_ser_docto_an  
               tt-import.cod_tit_acr_an     = v_cod_tit_acr_an    
               tt-import.cod_parcela_an     = v_cod_parcela_an
               tt-import.cod_cta_ctbl       = v_cod_cta_ctbl    
               tt-import.cod_ccusto         = v_cod_ccusto.
    END.

    RETURN "OK".

END PROCEDURE.

PROCEDURE pi-gera-liq: /* gerar liquidaá∆o no ACR */
    
    PUT "-----------" SKIP
        "Arquivo...: " tt-arquivo.nm-arquivo     SKIP.
    
    PUT STREAM s1 "-----------" SKIP
                  "Arquivo...: " tt-arquivo.nm-arquivo     SKIP.

    FOR EACH tt-estab-lote:

        RUN pi-cria-lote (INPUT tt-estab-lote.cod_estab). /* para cada arquivo lido, vai criar um lote de liquidaá∆o */

        FOR EACH tt-import
           WHERE tt-import.cod_estab    = tt-estab-lote.cod_estab
             AND tt-import.cod_cta_ctbl = "":
    
            RUN pi-acompanhar IN h-acomp (INPUT "Gera Liquidaá∆o - T°tulo: " + tt-import.cod_tit_acr).

            /* Acessa DP a ser Liquidada */
            FIND FIRST tit_acr_dp NO-LOCK 
                 WHERE tit_acr_dp.cod_estab       = tt-import.cod_estab      
                   AND tit_acr_dp.cod_espec_docto = tt-import.cod_espec_docto
                   AND tit_acr_dp.cod_ser_docto   = tt-import.cod_ser_docto  
                   AND tit_acr_dp.cod_tit_acr     = tt-import.cod_tit_acr    
                   AND tit_acr_dp.cod_parcela     = tt-import.cod_parcela NO-ERROR.
    
            /* validar se titulo informado da planilha existe */
            IF NOT AVAIL tit_acr_dp THEN DO:
                CREATE tt_erros.
                ASSIGN tt_erros.ttv_cod_message  = "17006"
                       tt_erros.ttv_des_msg_erro = "T°tulo informado n∆o encontrado."
                       tt_erros.cod_estab        = tt-import.cod_estab      
                       tt_erros.cod_espec_docto  = tt-import.cod_espec_docto
                       tt_erros.cod_ser_docto    = tt-import.cod_ser_docto      
                       tt_erros.cod_tit_acr      = tt-import.cod_tit_acr    
                       tt_erros.cod_parcela      = tt-import.cod_parcela.
            END.
            
            /* Acessa AN para fazer o abatimento */        
            FIND FIRST tit_acr_an NO-LOCK 
                 WHERE tit_acr_an.cod_estab       = tt-import.cod_estab_an       
                   AND tit_acr_an.cod_espec_docto = tt-import.cod_espec_docto_an 
                   AND tit_acr_an.cod_ser_docto   = tt-import.cod_ser_docto_an   
                   AND tit_acr_an.cod_tit_acr     = tt-import.cod_tit_acr_an     
                   AND tit_acr_an.cod_parcela     = tt-import.cod_parcela_an NO-ERROR.
    
            /* validar AN somente se foi informado na planilha */
            IF tt-import.cod_estab_an <> "" THEN DO: 
                IF NOT AVAIL tit_acr_an THEN DO:
                    CREATE tt_erros.
                    ASSIGN tt_erros.ttv_cod_message  = "17006"
                           tt_erros.ttv_des_msg_erro = "Antecipaá∆o informada n∆o encontrada."
                           tt_erros.cod_estab        = tt-import.cod_estab      
                           tt_erros.cod_espec_docto  = tt-import.cod_espec_docto
                           tt_erros.cod_ser_docto    = tt-import.cod_ser_docto      
                           tt_erros.cod_tit_acr      = tt-import.cod_tit_acr    
                           tt_erros.cod_parcela      = tt-import.cod_parcela.
                END.
            END.
    
            /* cria item lote liquidacá∆o */
            IF NOT CAN-FIND(FIRST tt_erros
                            WHERE tt_erros.cod_estab        = tt-import.cod_estab      
                              AND tt_erros.cod_espec_docto  = tt-import.cod_espec_docto
                              AND tt_erros.cod_ser_docto    = tt-import.cod_ser_docto      
                              AND tt_erros.cod_tit_acr      = tt-import.cod_tit_acr    
                              AND tt_erros.cod_parcela      = tt-import.cod_parcela)THEN DO:

                /* para vendas com cobranca especial (ex.: cartao de crÇdito), quando integrados com o ACR 
                  geram lote automatico e precisam ser eliminados antes de criar o novo. Vai buscar o lote
                  antigo conforme informado na planilha de importaá∆o */
                IF tt-import.lote <> "" THEN
                    RUN pi-elimina-item-lote-antigo. 

                /* criar item-lote */
                RUN pi-cria-item-lote.                 
            END.              
        END.
                    
        /* aciona api para liquidaá∆o acr */
        IF CAN-FIND(FIRST tt_integr_acr_liq_item_lote_3) THEN
            RUN pi-executa-api-liquidacao.   

        /* mostra dados importados -> monta log */
        RUN pi-mostra-dados (INPUT "Liq").
        
    END.
    
END PROCEDURE.

PROCEDURE pi-cria-lote: /* cria lote de liquidaá∆o */

    DEF INPUT PARAM p_cod_estab_lote LIKE tit_acr.cod_estab.

    DEF VAR dt-max AS DATE FORMAT "99/99/9999" NO-UNDO.

    EMPTY TEMP-TABLE tt_log_erros_import_liquidac.
    EMPTY TEMP-TABLE tt_integr_acr_liquidac_lote.
    EMPTY TEMP-TABLE tt_integr_acr_liq_item_lote_3.
    EMPTY TEMP-TABLE tt_integr_acr_abat_antecip.
    
    /* busca a maior data da planilha de importaá∆o para jogar na data de geraá∆o do lote */
    ASSIGN dt-max = TODAY.
    FOR EACH tt-import
       WHERE tt-import.cod_cta_ctbl = "":
        IF tt-import.dat_liquidacao > dt-max THEN
            ASSIGN dt-max = tt-import.dat_liquidacao.
    END.

    run pi_retorna_sugestao_referencia (INPUT  "L", 
                                        INPUT  dt-max,
                                        OUTPUT v_cod_refer) /*pi_retorna_sugestao_referencia*/.

    /* Cria lote de liquidaá∆o */
    CREATE tt_integr_acr_liquidac_lote.
    ASSIGN tt_integr_acr_liquidac_lote.tta_cod_empresa                 = STRING(i-ep-codigo-usuario)
           tt_integr_acr_liquidac_lote.tta_cod_estab_refer             = p_cod_estab_lote
           tt_integr_acr_liquidac_lote.tta_cod_usuario                 = v_cod_usuar_corren
           tt_integr_acr_liquidac_lote.tta_cod_portador                = ""    
           tt_integr_acr_liquidac_lote.tta_cod_cart_bcia               = ""
           tt_integr_acr_liquidac_lote.tta_dat_gerac_lote_liquidac     = dt-max
           tt_integr_acr_liquidac_lote.tta_dat_transacao               = TODAY 
           tt_integr_acr_liquidac_lote.tta_val_tot_lote_liquidac_infor = 0 
           tt_integr_acr_liquidac_lote.tta_val_tot_lote_liquidac_efetd = 0  
           tt_integr_acr_liquidac_lote.tta_val_tot_despes_bcia         = 0 
           tt_integr_acr_liquidac_lote.tta_ind_tip_liquidac_acr        = "lote"
           tt_integr_acr_liquidac_lote.tta_ind_sit_lote_liquidac_acr   = "Em digitaá∆o"
           tt_integr_acr_liquidac_lote.tta_nom_arq_movimen_bcia        = ""
           tt_integr_acr_liquidac_lote.tta_cdn_cliente                 = 0
           tt_integr_acr_liquidac_lote.tta_log_enctro_cta              = NO   
           tt_integr_acr_liquidac_lote.ttv_log_atualiz_refer           = param-concil-financ.log-efetiva-lote-liquidacao /* YES -> atualiza liquidaá∆o NO -> deixa em digitaá∆o para ser confirmado posteriomente */
           tt_integr_acr_liquidac_lote.ttv_log_gera_lote_parcial       = NO
           tt_integr_acr_liquidac_lote.ttv_rec_lote_liquidac_acr       = RECID(tt_integr_acr_liquidac_lote)
           tt_integr_acr_liquidac_lote.tta_cod_refer                   = v_cod_refer
           tt_integr_acr_liquidac_lote.ttv_cod_indic_econ              = "".

    ASSIGN i-sequencia = 0.

END PROCEDURE.

PROCEDURE pi-cria-item-lote: /* cria item lote de liquidaá∆o */

    ASSIGN v_cod_finalid_econ = "".

    run pi_retornar_finalid_indic_econ (INPUT  tit_acr_dp.cod_indic_econ,
                                        INPUT  TODAY,
                                        OUTPUT v_cod_finalid_econ) /*pi_retornar_finalid_indic_econ*/.

    ASSIGN i-sequencia = i-sequencia + 1.

    for each tit_acr_cobr_especial EXCLUSIVE-LOCK
        where tit_acr_cobr_especial.cod_estab                 = tit_acr_dp.cod_estab
          and tit_acr_cobr_especial.num_id_tit_acr            = tit_acr_dp.num_id_tit_acr
          and tit_acr_cobr_especial.ind_sit_tit_cobr_especial <> "Retornado": /*l_retornado*/ 
        
        ASSIGN tit_acr_cobr_especial.ind_sit_tit_cobr_especia = "Retornado".
                                              
    end.

    /* Cria item do lote de liquidaá∆o */
    CREATE tt_integr_acr_liq_item_lote_3.
    ASSIGN tt_integr_acr_liq_item_lote_3.tta_cod_empresa                = tit_acr_dp.cod_empresa
           tt_integr_acr_liq_item_lote_3.tta_cod_estab                  = tit_acr_dp.cod_estab
           tt_integr_acr_liq_item_lote_3.tta_cod_espec_docto            = tit_acr_dp.cod_espec_docto
           tt_integr_acr_liq_item_lote_3.tta_cod_ser_docto              = tit_acr_dp.cod_ser_docto
           tt_integr_acr_liq_item_lote_3.tta_cod_tit_acr                = tit_acr_dp.cod_tit_acr
           tt_integr_acr_liq_item_lote_3.tta_cod_parcela                = tit_acr_dp.cod_parcela
           tt_integr_acr_liq_item_lote_3.tta_cdn_cliente                = tit_acr_dp.cdn_cliente
           tt_integr_acr_liq_item_lote_3.tta_num_seq_refer              = i-sequencia
           tt_integr_acr_liq_item_lote_3.tta_cod_portad_ext             = ""
           tt_integr_acr_liq_item_lote_3.tta_cod_modalid_ext            = ""
           tt_integr_acr_liq_item_lote_3.tta_cod_portador               = tit_acr_dp.cod_portador      
           tt_integr_acr_liq_item_lote_3.tta_cod_cart_bcia              = tit_acr_dp.cod_cart_bcia     
           tt_integr_acr_liq_item_lote_3.tta_cod_finalid_econ           = v_cod_finalid_econ
           tt_integr_acr_liq_item_lote_3.tta_cod_indic_econ             = tit_acr_dp.cod_indic_econ
           tt_integr_acr_liq_item_lote_3.tta_val_tit_acr                = tt-import.val_liquidacao
           tt_integr_acr_liq_item_lote_3.tta_val_liquidac_tit_acr       = tt-import.val_liquidacao
           tt_integr_acr_liq_item_lote_3.tta_dat_cr_liquidac_tit_acr    = tt-import.dat_liquidacao
           tt_integr_acr_liq_item_lote_3.tta_dat_cr_liquidac_calc       = tt-import.dat_liquidacao
           tt_integr_acr_liq_item_lote_3.tta_dat_liquidac_tit_acr       = tt-import.dat_liquidacao
           tt_integr_acr_liq_item_lote_3.tta_cod_autoriz_bco            = ""
           tt_integr_acr_liq_item_lote_3.tta_val_abat_tit_acr           = tt-import.val_abat_tit_acr
           tt_integr_acr_liq_item_lote_3.tta_val_despes_bcia            = 0
           tt_integr_acr_liq_item_lote_3.tta_val_multa_tit_acr          = 0
           tt_integr_acr_liq_item_lote_3.tta_val_juros                  = tt-import.val_juros
           tt_integr_acr_liq_item_lote_3.tta_val_cm_tit_acr             = 0
           tt_integr_acr_liq_item_lote_3.tta_val_liquidac_orig          = tt-import.val_liquidacao
           tt_integr_acr_liq_item_lote_3.tta_val_desc_tit_acr_orig      = 0  
           tt_integr_acr_liq_item_lote_3.tta_val_abat_tit_acr_orig      = tt-import.val_abat_tit_acr 
           tt_integr_acr_liq_item_lote_3.tta_val_despes_bcia_orig       = 0
           tt_integr_acr_liq_item_lote_3.tta_val_multa_tit_acr_origin   = 0
           tt_integr_acr_liq_item_lote_3.tta_val_juros_tit_acr_orig     = tt-import.val_juros
           tt_integr_acr_liq_item_lote_3.tta_val_cm_tit_acr_orig        = 0
           tt_integr_acr_liq_item_lote_3.tta_val_nota_db_orig           = 0
           tt_integr_acr_liq_item_lote_3.tta_log_gera_antecip           = NO
           tt_integr_acr_liq_item_lote_3.tta_des_text_histor            = "Liquidaá∆o gerada pelo programa ESACR082 - Importar Liquidaá∆o"
           tt_integr_acr_liq_item_lote_3.tta_ind_sit_item_lote_liquidac = "Gerado"
           tt_integr_acr_liq_item_lote_3.tta_log_gera_avdeb             = NO
           tt_integr_acr_liq_item_lote_3.tta_cod_indic_econ_avdeb       = ""
           tt_integr_acr_liq_item_lote_3.tta_cod_portad_avdeb           = ""
           tt_integr_acr_liq_item_lote_3.tta_cod_cart_bcia_avdeb        = "" 
           tt_integr_acr_liq_item_lote_3.tta_dat_vencto_avdeb           = ?
           tt_integr_acr_liq_item_lote_3.tta_val_perc_juros_avdeb       = 0
           tt_integr_acr_liq_item_lote_3.tta_val_avdeb                  = 0
           tt_integr_acr_liq_item_lote_3.tta_log_movto_comis_estordo    = NO
           tt_integr_acr_liq_item_lote_3.tta_ind_tip_item_liquidac_acr  = "Pagamento"
           tt_integr_acr_liq_item_lote_3.tta_ind_tip_calc_juros         = "Simples" /*"Compostos"*/
           tt_integr_acr_liq_item_lote_3.ttv_rec_lote_liquidac_acr      = tt_integr_acr_liquidac_lote.ttv_rec_lote_liquidac_acr
           tt_integr_acr_liq_item_lote_3.ttv_rec_item_lote_liquidac_acr = RECID(tt_integr_acr_liq_item_lote_3)
           tt_integr_acr_liq_item_lote_3.tta_val_cotac_indic_econ       = 1.
   
    /* cria abatimento da antecipaá∆oo */
    IF AVAIL tit_acr_an THEN DO:
        CREATE tt_integr_acr_abat_antecip.
        ASSIGN tt_integr_acr_abat_antecip.ttv_rec_item_lote_impl_tit_acr = tt_integr_acr_liq_item_lote_3.ttv_rec_item_lote_liquidac_acr
               tt_integr_acr_abat_antecip.tta_cod_estab                  = tit_acr_an.cod_estab 
               tt_integr_acr_abat_antecip.tta_cod_estab_ext              = ""
               tt_integr_acr_abat_antecip.tta_cod_espec_docto            = tit_acr_an.cod_espec_docto               
               tt_integr_acr_abat_antecip.tta_cod_ser_docto              = tit_acr_an.cod_ser_docto   
               tt_integr_acr_abat_antecip.tta_cod_tit_acr                = tit_acr_an.cod_tit_acr
               tt_integr_acr_abat_antecip.tta_cod_parcela                = tit_acr_an.cod_parcela    
               tt_integr_acr_abat_antecip.tta_val_abtdo_antecip_tit_abat = tt-import.val_liquidacao.
    END.

END.

PROCEDURE pi-executa-api-liquidacao:

    /******************************* Main Code Begin ******************************/

    /*atz_blk:
    DO TRANSACTION ON ERROR UNDO atz_blk,  LEAVE atz_blk:*/
    
        /* baixa */ 
        
        /* Acionamento da API de LIquidaá∆o de T°tulos do ACR */
        RUN prgfin/acr/acr901zf.py PERSISTENT SET v_hld_handle.
    
        
        RUN pi_main_code_api_integr_acr_liquidac_6 IN v_hld_handle
                                   (INPUT 1,
                                    Input table tt_integr_acr_liquidac_lote,
                                    Input table tt_integr_acr_liq_item_lote_3,
                                    Input table tt_integr_acr_abat_antecip,
                                    Input table tt_integr_acr_abat_prev,
                                    Input table tt_integr_acr_cheq,
                                    Input table tt_integr_acr_liquidac_impto_2,
                                    Input table tt_integr_acr_rel_pend_cheq,
                                    Input table tt_integr_acr_liq_aprop_ctbl,
                                    Input table tt_integr_acr_liq_desp_rec,
                                    Input table tt_integr_acr_aprop_liq_antec,
                                    Input "",
                                    output table tt_log_erros_import_liquidac,
                                    Input table tt_integr_cambio_ems5,
                                    input table tt_params_generic_api) /*prg_api_integr_acr_liquidac_2*/.
        DELETE PROCEDURE v_hld_handle.  
        
        IF CAN-FIND (first tt_log_erros_import_liquidac) THEN DO:

            FOR EACH tt_log_erros_import_liquidac:
                
                /* tira do lote contabil todos titulos que deram erro */
                FIND FIRST tt_integr_acr_liq_item_lote_3
                     WHERE tt_integr_acr_liq_item_lote_3.tta_cod_estab         = tt_log_erros_import_liquidac.tta_cod_estab      
                       AND tt_integr_acr_liq_item_lote_3.tta_cod_espec_docto   = tt_log_erros_import_liquidac.tta_cod_espec_docto
                       AND tt_integr_acr_liq_item_lote_3.tta_cod_ser_docto     = tt_log_erros_import_liquidac.tta_cod_ser_docto  
                       AND tt_integr_acr_liq_item_lote_3.tta_cod_tit_acr       = tt_log_erros_import_liquidac.tta_cod_tit_acr    
                       AND tt_integr_acr_liq_item_lote_3.tta_cod_parcela       = tt_log_erros_import_liquidac.tta_cod_parcela NO-ERROR.
                IF AVAIL tt_integr_acr_liq_item_lote_3 THEN
                    DELETE tt_integr_acr_liq_item_lote_3.

                CREATE tt_erros.
                ASSIGN tt_erros.ttv_cod_message  = string(tt_log_erros_import_liquidac.ttv_num_erro_log)
                       tt_erros.ttv_des_msg_erro = tt_log_erros_import_liquidac.ttv_des_msg_erro
                       tt_erros.cod_estab        = tt_log_erros_import_liquidac.tta_cod_estab      
                       tt_erros.cod_espec_docto  = tt_log_erros_import_liquidac.tta_cod_espec_docto
                       tt_erros.cod_ser_docto    = tt_log_erros_import_liquidac.tta_cod_ser_docto    
                       tt_erros.cod_tit_acr      = tt_log_erros_import_liquidac.tta_cod_tit_acr    
                       tt_erros.cod_parcela      = tt_log_erros_import_liquidac.tta_cod_parcela.
                       
                ASSIGN tt_erros.ttv_des_msg_erro = REPLACE(tt_erros.ttv_des_msg_erro, CHR(10), " ")
                       tt_erros.ttv_des_msg_erro = REPLACE(tt_erros.ttv_des_msg_erro, CHR(11), " ")
                       tt_erros.ttv_des_msg_erro = REPLACE(tt_erros.ttv_des_msg_erro, CHR(12), " ")
                       tt_erros.ttv_des_msg_erro = REPLACE(tt_erros.ttv_des_msg_erro, CHR(13), " ")
                       tt_erros.ttv_des_msg_erro = TRIM(tt_erros.ttv_des_msg_erro).  
                                                   
            END.     

            
            /* verifica se ainda tem titulos na temp-table tt_integr_acr_liq_item_lote_3. 
               Se sim, executa novamente a api para liquidacao com os titulos sem erro */
            IF CAN-FIND(FIRST tt_integr_acr_liq_item_lote_3) THEN DO:

                /* Acionamento da API de LIquidaá∆o de T°tulos do ACR */
                RUN prgfin/acr/acr901zf.py PERSISTENT SET v_hld_handle.
            
                
                RUN pi_main_code_api_integr_acr_liquidac_6 IN v_hld_handle
                                           (INPUT 1,
                                            Input table tt_integr_acr_liquidac_lote,
                                            Input table tt_integr_acr_liq_item_lote_3,
                                            Input table tt_integr_acr_abat_antecip,
                                            Input table tt_integr_acr_abat_prev,
                                            Input table tt_integr_acr_cheq,
                                            Input table tt_integr_acr_liquidac_impto_2,
                                            Input table tt_integr_acr_rel_pend_cheq,
                                            Input table tt_integr_acr_liq_aprop_ctbl,
                                            Input table tt_integr_acr_liq_desp_rec,
                                            Input table tt_integr_acr_aprop_liq_antec,
                                            Input "",
                                            output table tt_log_erros_import_liquidac,
                                            Input table tt_integr_cambio_ems5,
                                            input table tt_params_generic_api) /*prg_api_integr_acr_liquidac_2*/.
                DELETE PROCEDURE v_hld_handle.  

            END.
            
            
            /*UNDO atz_blk, LEAVE atz_blk.*/
            
        END. /* IF CAN-FIND (first tt_log_erros_import_liquidac */

    /*END. /* atz_blk: */
    */

END PROCEDURE. /* pi-executa-api-liquidacao */

PROCEDURE pi_retorna_sugestao_referencia:

    /************************ Parameter Definition Begin ************************/
    def INPUT  param p_ind_tip_atualiz as CHAR format "X(08)"      no-undo.
    def INPUT  param p_dat_refer       as DATE format "99/99/9999" no-undo.
    def OUTPUT param p_cod_refer       as CHAR format "x(10)"      no-undo.

    /************************* Variable Definition Begin ************************/
    def var v_des_dat                 as char      no-undo. /*local*/
    def var v_num_aux                 as INT       no-undo. /*local*/
    def var v_num_aux_2               as INT       no-undo. /*local*/
    def var v_num_cont                as INT       no-undo. /*local*/

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
END PROCEDURE. /* pi_retorna_sugestao_referencia */

PROCEDURE pi-gera-referencia:
    DEFINE INPUT  PARAMETER p-cod-estab  AS CHARACTER FORMAT "x(3)"    NO-UNDO.
    DEFINE INPUT  PARAMETER p-rec-tabela AS RECID                      NO-UNDO.
    DEFINE OUTPUT PARAMETER p-referencia AS CHARACTER                  NO-UNDO.

    DEFINE VARIABLE l-log-refer-uni AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE i-num-aux       AS INT64       NO-UNDO.
    DEFINE VARIABLE i-cont          AS INTEGER     NO-UNDO.
    DEFINE VARIABLE c_des_dat       AS CHARACTER   NO-UNDO.

    /* Gera o c¢digo da referància */
    ASSIGN c_des_dat    = STRING(TODAY, "99999999":U)
           p-referencia = string(TIME)
           i-num-aux    = TIME + int64(p-rec-tabela) /*+ INTEGER(THIS-PROCEDURE:HANDLE)*/.

    DO i_cont = 1 TO 4:
        ASSIGN p-referencia = p-referencia + CHR((RANDOM(0, i-num-aux) MODULO 26) + 97).
    END.

    /* Verifica se a referància Ç £nica */
    RUN pi-verifica-refer-unica-acr IN THIS-PROCEDURE (INPUT  p-cod-estab,
                                                       INPUT  p-referencia,
                                                       INPUT  "",
                                                       INPUT  p-rec-tabela,
                                                       OUTPUT l-log-refer-uni).
    IF  NOT l-log-refer-uni THEN
        RUN pi-gera-referencia IN THIS-PROCEDURE (INPUT  p-cod-estab,
                                                  INPUT  p-rec-tabela,
                                                  OUTPUT p-referencia).

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-verifica-refer-unica-acr:
    /************************ Parameter Definition Begin ************************/
    DEF INPUT  PARAM p_cod_estab     AS CHARACTER FORMAT "x(3)"    NO-UNDO.
    DEF INPUT  PARAM p_cod_refer     AS CHARACTER FORMAT "x(10)"   NO-UNDO.
    DEF INPUT  PARAM p_cod_table     AS CHARACTER FORMAT "x(8)"    NO-UNDO.
    DEF INPUT  PARAM p_rec_tabela    AS RECID                      NO-UNDO.
    DEF OUTPUT PARAM p_log_refer_uni AS LOGICAL   FORMAT "Sim/N∆o" NO-UNDO.
    /************************* Parameter Definition End *************************/

    /************************** Buffer Definition Begin *************************/
    DEFINE BUFFER b_cobr_especial_acr FOR cobr_especial_acr.
    DEFINE BUFFER b_lote_impl_tit_acr FOR lote_impl_tit_acr.
    DEFINE BUFFER b_lote_liquidac_acr FOR lote_liquidac_acr.
    DEFINE BUFFER b_movto_tit_acr     FOR movto_tit_acr.
    DEFINE BUFFER b_operac_financ_acr FOR operac_financ_acr.
    DEFINE BUFFER b_renegoc_acr       FOR renegoc_acr.
    /*************************** Buffer Definition End **************************/

    ASSIGN p_log_refer_uni = YES.

    IF  p_log_refer_uni = YES THEN DO:
        FIND FIRST b_renegoc_acr NO-LOCK
            WHERE b_renegoc_acr.cod_estab = p_cod_estab
            AND   b_renegoc_acr.cod_refer = p_cod_refer NO-ERROR.
        IF  AVAIL b_renegoc_acr then
            ASSIGN p_log_refer_uni = no.
        ELSE DO:
            FIND FIRST b_movto_tit_acr NO-LOCK
                 WHERE b_movto_tit_acr.cod_estab = p_cod_estab
                   AND b_movto_tit_acr.cod_refer = p_cod_refer
                 USE-INDEX mvtttcr_refer
                 NO-ERROR.
            IF  AVAIL b_movto_tit_acr THEN
                ASSIGN p_log_refer_uni = NO.
        END.

        IF  p_cod_table <> "lote_impl_tit_acr" THEN DO:
            FIND FIRST b_lote_impl_tit_acr NO-LOCK
                 WHERE b_lote_impl_tit_acr.cod_estab = p_cod_estab
                   AND b_lote_impl_tit_acr.cod_refer = p_cod_refer
                   AND RECID( b_lote_impl_tit_acr ) <> p_rec_tabela
                 USE-INDEX ltmplttc_id NO-ERROR.
            IF  AVAIL b_lote_impl_tit_acr THEN
                ASSIGN p_log_refer_uni = NO.
        END.

        IF  p_cod_table <> "lote_liquidac_acr" THEN DO:
            FIND FIRST b_lote_liquidac_acr NO-LOCK
                 WHERE b_lote_liquidac_acr.cod_estab_refer = p_cod_estab
                   AND b_lote_liquidac_acr.cod_refer       = p_cod_refer
                   AND RECID( b_lote_liquidac_acr )       <> p_rec_tabela
                 USE-INDEX ltlqdccr_id NO-ERROR.
            IF  AVAIL b_lote_liquidac_acr THEN
                ASSIGN p_log_refer_uni = NO.
        END.

        IF  p_cod_table <> "Operaá∆o financeira" THEN DO:
            FIND FIRST b_operac_financ_acr NO-LOCK
                 WHERE b_operac_financ_acr.cod_estab               = p_cod_estab
                   AND b_operac_financ_acr.cod_movto_operac_financ = p_cod_refer
                   AND RECID( b_operac_financ_acr )               <> p_rec_tabela
                 USE-INDEX oprcfnna_id NO-ERROR.
            IF  AVAIL b_operac_financ_acr THEN
                ASSIGN p_log_refer_uni = NO.
        END.

        IF  p_cod_table = 'cobr_especial_acr' THEN DO:
            FIND FIRST b_cobr_especial_acr NO-LOCK
                 WHERE b_cobr_especial_acr.cod_estab = p_cod_estab
                   AND b_cobr_especial_acr.cod_refer = p_cod_refer
                   AND RECID( b_cobr_especial_acr ) <> p_rec_tabela
                 USE-INDEX cbrspclc_id NO-ERROR.
            IF  AVAIL b_cobr_especial_acr THEN
                ASSIGN p_log_refer_uni = NO.
        END.

    END.

END PROCEDURE.

/*****************************************************************************
** Procedure Interna.....: pi_retornar_finalid_indic_econ
*****************************************************************************/
PROCEDURE pi_retornar_finalid_indic_econ:

    /************************ Parameter Definition Begin ************************/
    def Input  param p_cod_indic_econ    as char format "x(8)"       no-undo.
    def Input  param p_dat_transacao     as date format "99/99/9999" no-undo.
    def output param p_cod_finalid_econ  as char format "x(10)"      no-undo.

    /************************* Parameter Definition End *************************/
     find first histor_finalid_econ no-lock where 
          histor_finalid_econ.cod_indic_econ          = p_cod_indic_econ
      and histor_finalid_econ.dat_inic_valid_finalid <= p_dat_transacao
      and histor_finalid_econ.dat_fim_valid_finalid   > p_dat_transacao no-error.

        if avail histor_finalid_econ then
           assign p_cod_finalid_econ = histor_finalid_econ.cod_finalid_econ.

END PROCEDURE. /* pi_retornar_finalid_indic_econ */

PROCEDURE pi-move-arquivo: /* mover arquivos recebidos para o diret¢rio de importados */

    DEFINE INPUT PARAMETER p-arquivo       AS CHAR    NO-UNDO.

    OS-COPY VALUE(p-arquivo) VALUE(c-arq-import).

    OS-DELETE VALUE(p-arquivo).
    
    RETURN "OK".
END PROCEDURE.

PROCEDURE pi-cria-tt-estab-lote: /* cria tt-estab-lote para criar lote por estabelecimento */
    
    EMPTY TEMP-TABLE tt-estab-lote.

    FOR EACH tt-import 
       WHERE tt-import.cod_cta_ctbl = ""
       BREAK BY tt-import.cod_estab:
        IF FIRST-OF(tt-import.cod_estab) THEN DO:
            CREATE tt-estab-lote.
            ASSIGN tt-estab-lote.cod_estab = tt-import.cod_estab. 
        END.
    END.

END PROCEDURE.

PROCEDURE pi-mostra-dados: /* mostra dados importados -> monta log */

    DEF INPUT PARAM v_tipo AS CHAR NO-UNDO.

    IF  v_tipo = "liq"
    AND AVAIL tt_integr_acr_liquidac_lote THEN DO:
        PUT "--------------"                                                  SKIP
            "Estab Refer..: " tt_integr_acr_liquidac_lote.tta_cod_estab_refer SKIP
            "Lote Refer...: " tt_integr_acr_liquidac_lote.tta_cod_refer       SKIP
            "--------------"                                                  SKIP(1).
        
        PUT STREAM s1 "--------------"                                                  SKIP
                      "Estab Refer..: " tt_integr_acr_liquidac_lote.tta_cod_estab_refer SKIP
                      "Lote Refer...: " tt_integr_acr_liquidac_lote.tta_cod_refer       SKIP
                      "--------------"                                                  SKIP(1).
    END.

    PUT "--------------------------- T°tulo ----------------------------------| ----------- Abatimento ------------ | ----------" AT 01
        "Estab EspÇcie SÇrie T°tulo     Parc Valor Liquidaá∆o Data Liquidaá∆o | Estab EspÇcie SÇrie T°tulo     Parc | Importado?" AT 01
        "----- ------- ----- ---------- ---- ---------------- --------------- | ----- ------- ----- ---------- ---- | ----------" AT 01.

    PUT STREAM s1 "--------------------------- T°tulo ----------------------------------| ----------- Abatimento ------------ | ----------" AT 01
                  "Estab EspÇcie SÇrie T°tulo     Parc Valor Liquidaá∆o Data Liquidaá∆o | Estab EspÇcie SÇrie T°tulo     Parc | Importado?" AT 01
                  "----- ------- ----- ---------- ---- ---------------- --------------- | ----- ------- ----- ---------- ---- | ----------" AT 01.

    FOR EACH tt-import
        BY tt-import.cod_estab:

        IF  v_tipo = "Liq" 
        AND AVAIL tt_integr_acr_liquidac_lote
        AND tt-import.cod_estab <> tt_integr_acr_liquidac_lote.tta_cod_estab_refer THEN
            NEXT.

        IF  v_tipo = "Liq" 
        AND tt-import.cod_cta_ctbl <> "" THEN
            NEXT.

        IF  v_tipo = "Rateio"
        AND tt-import.cod_cta_ctbl = "" THEN
            NEXT.

        PUT tt-import.cod_estab          AT 01  
            tt-import.cod_espec_docto    AT 07  
            tt-import.cod_ser_docto      AT 15  
            tt-import.cod_tit_acr        AT 21  
            tt-import.cod_parcela        AT 32              
            tt-import.val_liquidacao     TO 52  
            IF tt-import.cod_estab_an <> "" THEN TODAY ELSE tt-import.dat_liquidacao  AT 54  
            tt-import.cod_estab_an       AT 72  
            tt-import.cod_espec_docto_an AT 78  
            tt-import.cod_ser_docto_an   AT 86  
            tt-import.cod_tit_acr_an     AT 92  
            tt-import.cod_parcela_an     AT 103.  

        PUT STREAM s1 
            tt-import.cod_estab          AT 01   
            tt-import.cod_espec_docto    AT 07   
            tt-import.cod_ser_docto      AT 15   
            tt-import.cod_tit_acr        AT 21   
            tt-import.cod_parcela        AT 32              
            tt-import.val_liquidacao     TO 52   
            IF tt-import.cod_estab_an <> "" THEN TODAY ELSE tt-import.dat_liquidacao   AT 54                                 
            tt-import.cod_estab_an       AT 72  
            tt-import.cod_espec_docto_an AT 78  
            tt-import.cod_ser_docto_an   AT 86  
            tt-import.cod_tit_acr_an     AT 92  
            tt-import.cod_parcela_an     AT 103. 

        IF CAN-FIND(FIRST tt_erros
                    WHERE tt_erros.cod_estab        = tt-import.cod_estab      
                      AND tt_erros.cod_espec_docto  = tt-import.cod_espec_docto
                      AND tt_erros.cod_ser_docto    = tt-import.cod_ser_docto      
                      AND tt_erros.cod_tit_acr      = tt-import.cod_tit_acr    
                      AND tt_erros.cod_parcela      = tt-import.cod_parcela) THEN DO:

            PUT "N∆o" AT 110 SKIP. 

            PUT STREAM s1 "N∆o" AT 110 SKIP. 

            FOR EACH tt_erros
               WHERE tt_erros.cod_estab        = tt-import.cod_estab      
                 AND tt_erros.cod_espec_docto  = tt-import.cod_espec_docto
                 AND tt_erros.cod_ser_docto    = tt-import.cod_ser_docto      
                 AND tt_erros.cod_tit_acr      = tt-import.cod_tit_acr    
                 AND tt_erros.cod_parcela      = tt-import.cod_parcela:

                ASSIGN c_erro_aux = STRING(tt_erros.ttv_cod_message) + " - " + tt_erros.ttv_des_msg_erro.

                PUT c_erro_aux AT 110 SKIP.

                PUT STREAM s1 c_erro_aux AT 110 SKIP.
            END.
        END.
        ELSE DO:
            /* erros que n∆o s∆o dos titulos. Exemplo: periodo n∆o habilitado */
            IF CAN-FIND(FIRST tt_erros
                        WHERE tt_erros.cod_tit_acr = "") THEN DO:
                
                PUT "N∆o" AT 110 SKIP. 

                PUT STREAM s1 "N∆o" AT 110 SKIP. 

                FOR EACH tt_erros:
                    ASSIGN c_erro_aux = STRING(tt_erros.ttv_cod_message) + " - " + tt_erros.ttv_des_msg_erro.
                    
                    PUT c_erro_aux AT 110 SKIP.

                    PUT STREAM s1 c_erro_aux AT 110 SKIP.
                END.
            END.
            ELSE DO:
                PUT "Sim" AT 110 SKIP.      

                PUT STREAM s1 "Sim" AT 110 SKIP.      
            END.
        END.                  
    END.
    PUT SKIP(1). 

    PUT STREAM s1 SKIP(1).
END PROCEDURE.

PROCEDURE pi-elimina-item-lote-antigo:

    FIND FIRST tit_acr_elimina NO-LOCK 
         WHERE RECID(tit_acr_elimina) = RECID(tit_acr_dp) NO-ERROR.
  
    IF  AVAIL tit_acr_elimina 
    AND tit_acr_elimina.ind_tip_cobr_acr = "Especial" 
    THEN DO:

         FIND FIRST item_lote_liquidac_acr OF tit_acr_elimina EXCLUSIVE-LOCK 
              WHERE item_lote_liquidac_acr.cod_refer = IF tt-import.lote <> "" THEN tt-import.lote ELSE item_lote_liquidac_acr.cod_refer NO-ERROR.
         IF AVAIL item_lote_liquidac_acr THEN DO:
             FIND tit_acr_cobr_especial EXCLUSIVE-LOCK 
                WHERE tit_acr_cobr_especial.cod_estab      = tit_acr_elimina.cod_estab
                  AND tit_acr_cobr_especial.num_id_tit_acr = tit_acr_elimina.num_id_tit_acr NO-ERROR.
             IF AVAIL tit_acr_cobr_especial 
                THEN ASSIGN tit_acr_cobr_especial.cod_refer_liquidac = "".
      
             /* ** Elimina relacionamento em cascata  ***/
             FOR EACH abat_antecip_acr EXCLUSIVE-LOCK 
                 WHERE abat_antecip_acr.cod_estab_refer = item_lote_liquidac_acr.cod_estab_refer
                   AND abat_antecip_acr.cod_refer       = item_lote_liquidac_acr.cod_refer
                   AND abat_antecip_acr.num_seq_refer   = item_lote_liquidac_acr.num_seq_refer:
                 DELETE abat_antecip_acr.
             END. 
             FOR EACH abat_prev_acr EXCLUSIVE-LOCK 
                 WHERE abat_prev_acr.cod_estab_refer = item_lote_liquidac_acr.cod_estab_refer
                   AND abat_prev_acr.cod_refer       = item_lote_liquidac_acr.cod_refer
                   AND abat_prev_acr.num_seq_refer   = item_lote_liquidac_acr.num_seq_refer:
                 DELETE abat_prev_acr.
             END. 
             FOR EACH aprop_ctbl_pend_acr EXCLUSIVE-LOCK 
                 WHERE aprop_ctbl_pend_acr.cod_estab     = item_lote_liquidac_acr.cod_estab_refer
                   AND aprop_ctbl_pend_acr.cod_refer     = item_lote_liquidac_acr.cod_refer
                   AND aprop_ctbl_pend_acr.num_seq_refer = item_lote_liquidac_acr.num_seq_refer:
                 DELETE aprop_ctbl_pend_acr.
             END. 
             FOR EACH aprop_despes_recta_pend EXCLUSIVE-LOCK 
                 WHERE aprop_despes_recta_pend.cod_estab     = item_lote_liquidac_acr.cod_estab_refer
                   AND aprop_despes_recta_pend.cod_refer     = item_lote_liquidac_acr.cod_refer
                   AND aprop_despes_recta_pend.num_seq_refer = item_lote_liquidac_acr.num_seq_refer:
                 DELETE aprop_despes_recta_pend.
             END. 
             FOR EACH impto_liquidac_tit_acr EXCLUSIVE-LOCK 
                 WHERE impto_liquidac_tit_acr.cod_estab_refer = item_lote_liquidac_acr.cod_estab_refer
                   AND impto_liquidac_tit_acr.cod_refer       = item_lote_liquidac_acr.cod_refer
                   AND impto_liquidac_tit_acr.num_seq_refer   = item_lote_liquidac_acr.num_seq_refer:
                 DELETE impto_liquidac_tit_acr.
             END. 
      
             FIND lote_liquidac_acr EXCLUSIVE-LOCK 
                WHERE lote_liquidac_acr.cod_estab_refer = item_lote_liquidac_acr.cod_estab_refer
                  AND lote_liquidac_acr.cod_refer       = item_lote_liquidac_acr.cod_refer NO-ERROR.
             ASSIGN lote_liquidac_acr.val_tot_lote_liquidac_infor = lote_liquidac_acr.val_tot_lote_liquidac_infor - item_lote_liquidac_acr.val_liquidac_tit_acr.
      
             DELETE item_lote_liquidac_acr.
      
             FIND FIRST item_lote_liquidac_acr OF lote_liquidac_acr NO-LOCK NO-ERROR.
             IF NOT AVAIL item_lote_liquidac_acr 
                THEN DELETE lote_liquidac_acr.
         END.
  
    END.

END PROCEDURE.

PROCEDURE pi-elimina-item-lote-rateio:

    FIND FIRST tit_acr_elimina NO-LOCK 
         WHERE RECID(tit_acr_elimina) = RECID(tit_acr_rateio) NO-ERROR.
  
    IF  AVAIL tit_acr_elimina THEN DO:

        FIND FIRST item_lote_liquidac_acr OF tit_acr_elimina EXCLUSIVE-LOCK NO-ERROR.
         IF AVAIL item_lote_liquidac_acr THEN DO:

             FIND tit_acr_cobr_especial EXCLUSIVE-LOCK 
                WHERE tit_acr_cobr_especial.cod_estab      = tit_acr_elimina.cod_estab
                  AND tit_acr_cobr_especial.num_id_tit_acr = tit_acr_elimina.num_id_tit_acr NO-ERROR.
             IF AVAIL tit_acr_cobr_especial 
                THEN ASSIGN tit_acr_cobr_especial.cod_refer_liquidac = "".
      
             /* ** Elimina relacionamento em cascata  ***/
             FOR EACH abat_antecip_acr EXCLUSIVE-LOCK 
                 WHERE abat_antecip_acr.cod_estab_refer = item_lote_liquidac_acr.cod_estab_refer
                   AND abat_antecip_acr.cod_refer       = item_lote_liquidac_acr.cod_refer
                   AND abat_antecip_acr.num_seq_refer   = item_lote_liquidac_acr.num_seq_refer:
                 DELETE abat_antecip_acr.
             END. 
             FOR EACH abat_prev_acr EXCLUSIVE-LOCK 
                 WHERE abat_prev_acr.cod_estab_refer = item_lote_liquidac_acr.cod_estab_refer
                   AND abat_prev_acr.cod_refer       = item_lote_liquidac_acr.cod_refer
                   AND abat_prev_acr.num_seq_refer   = item_lote_liquidac_acr.num_seq_refer:
                 DELETE abat_prev_acr.
             END. 
             FOR EACH aprop_ctbl_pend_acr EXCLUSIVE-LOCK 
                 WHERE aprop_ctbl_pend_acr.cod_estab     = item_lote_liquidac_acr.cod_estab_refer
                   AND aprop_ctbl_pend_acr.cod_refer     = item_lote_liquidac_acr.cod_refer
                   AND aprop_ctbl_pend_acr.num_seq_refer = item_lote_liquidac_acr.num_seq_refer:
                 DELETE aprop_ctbl_pend_acr.
             END. 
             FOR EACH aprop_despes_recta_pend EXCLUSIVE-LOCK 
                 WHERE aprop_despes_recta_pend.cod_estab     = item_lote_liquidac_acr.cod_estab_refer
                   AND aprop_despes_recta_pend.cod_refer     = item_lote_liquidac_acr.cod_refer
                   AND aprop_despes_recta_pend.num_seq_refer = item_lote_liquidac_acr.num_seq_refer:
                 DELETE aprop_despes_recta_pend.
             END. 
             FOR EACH impto_liquidac_tit_acr EXCLUSIVE-LOCK 
                 WHERE impto_liquidac_tit_acr.cod_estab_refer = item_lote_liquidac_acr.cod_estab_refer
                   AND impto_liquidac_tit_acr.cod_refer       = item_lote_liquidac_acr.cod_refer
                   AND impto_liquidac_tit_acr.num_seq_refer   = item_lote_liquidac_acr.num_seq_refer:
                 DELETE impto_liquidac_tit_acr.
             END. 
      
             FIND lote_liquidac_acr EXCLUSIVE-LOCK 
                WHERE lote_liquidac_acr.cod_estab_refer = item_lote_liquidac_acr.cod_estab_refer
                  AND lote_liquidac_acr.cod_refer       = item_lote_liquidac_acr.cod_refer NO-ERROR.
             ASSIGN lote_liquidac_acr.val_tot_lote_liquidac_infor = lote_liquidac_acr.val_tot_lote_liquidac_infor - item_lote_liquidac_acr.val_liquidac_tit_acr.
      
             DELETE item_lote_liquidac_acr.
      
             FIND FIRST item_lote_liquidac_acr OF lote_liquidac_acr NO-LOCK NO-ERROR.
             IF NOT AVAIL item_lote_liquidac_acr 
                THEN DELETE lote_liquidac_acr.
         END.
  
    END.

END PROCEDURE.
