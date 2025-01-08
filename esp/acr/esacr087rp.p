/************************************************************************************************************
*      Programa .....: ESACR087RP                                                                           *
*      Data .........: 29 de Maio de 2023                                                                   *
*      Empresa ......: IDBA                                                                                 *
*      Cliente ......: Intelbras                                                                            *
*      Programador ..: Bruno Joaquim                                                                        *
*      Objetivo .....: Alteracao titulos Lucree para o ACR                                                  *
*************************************************************************************************************
*  VERSAO       DATA        RESPONSAVEL              MOTIVO                                                 *
*  1.00.00.000  19/05/2023  Bruno Joaquim           Desenvolvimento                                         *
************************************************************************************************************/

/*************************** TEMP-TABLES *******************************************************************/
{include/i-prgvrs.i esacr086rp 2.00.00.000} 

DEF TEMP-TABLE tt-digita NO-UNDO
    FIELD ordem            AS INTEGER   FORMAT ">>>>9":U
    FIELD exemplo          AS CHARACTER FORMAT "x(30)":U
    INDEX id ordem.

DEF TEMP-TABLE tt-raw-digita
    FIELD raw-digita       AS RAW.
 
DEF TEMP-TABLE tt-param NO-UNDO
    FIELD destino                AS INTEGER
    FIELD arquivo                AS CHAR FORMAT "x(35)"
    FIELD usuario                AS CHAR FORMAT "x(12)"
    FIELD data-exec              AS DATE
    FIELD hora-exec              AS INTEGER
    FIELD tp-execucao            AS INTEGER
    FIELD c-arq-import           AS CHARACTER.

DEF INPUT PARAM raw-param AS RAW NO-UNDO.
DEF INPUT PARAM TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

DEF TEMP-TABLE tt-linha NO-UNDO
    FIELD linha                 AS CHAR
    FIELD authorization_number  AS CHAR .

DEF TEMP-TABLE tt-arquivo-importado NO-UNDO
    FIELD authorization_number  AS CHAR
    FIELD acquirer_nsu          AS INT  FORMAT "9999999999"
    FIELD participante          AS CHAR FORMAT "X(100)"
    FIELD doc_participante	    AS CHAR FORMAT "X(12)"
    FIELD ID_Revendedor	        AS INT
    FIELD Nome_Lojista          AS CHAR FORMAT "X(100)"
    FIELD Doc_Lojista           AS CHAR
    FIELD parcela	            AS INT  FORMAT "99"
    FIELD val_venda             AS DEC
    FIELD split_percentual      AS DEC
    FIELD valorbruto            AS DEC
    FIELD valordesconto         AS DEC
    FIELD valorliquido          AS DEC
    FIELD c-status              AS CHAR
    FIELD modalidade            AS CHAR FORMAT "X(25)"
    FIELD bandeira              AS CHAR
    FIELD c-terminal            AS CHAR
    FIELD dataprevista          AS DATE
    FIELD datapagamento         AS CHAR FORMAT "x(10)"
    FIELD dataautorizacao       AS CHAR FORMAT "x(10)"
    FIELD taxa_revenda          AS DEC .

DEF TEMP-TABLE tt-arquivo NO-UNDO
    FIELD authorization_number  AS CHAR
    FIELD acquirer_nsu          AS INT
    FIELD participante          AS CHAR FORMAT "X(100)"
    FIELD doc_participante	    AS CHAR FORMAT "X(12)"
    FIELD ID_Revendedor	        AS INT
    FIELD Nome_Lojista          AS CHAR FORMAT "X(100)"
    FIELD Doc_Lojista           AS CHAR
    FIELD parcela	            AS INT
    FIELD val_venda             AS CHAR 
    FIELD split_percentual      AS CHAR 
    FIELD valorbruto            AS CHAR 
    FIELD valordesconto         AS CHAR 
    FIELD valorliquido          AS CHAR 
    FIELD c-status              AS CHAR
    FIELD modalidade            AS CHAR FORMAT "X(25)"
    FIELD bandeira              AS CHAR
    FIELD c-terminal            AS CHAR
    FIELD dataprevista          AS CHAR FORMAT "x(10)"
    FIELD datapagamento         AS CHAR FORMAT "x(10)"
    FIELD dataautorizacao       AS CHAR FORMAT "x(10)"
    FIELD taxa_revenda          AS CHAR.

DEFINE TEMP-TABLE tt-lista-consolidada NO-UNDO
     FIELD acquirer_nsu         AS INT  FORMAT 9999999999
     FIELD doc_participante	    AS CHAR FORMAT "X(12)"
     FIELD ID_Revendedor	    AS INT
     FIELD val_venda            AS DEC
     FIELD valorbruto           AS DEC
     FIELD valordesconto        AS DEC
     FIELD valorliquido         AS DEC 
     FIELD id_titulo            AS CHAR FORMAT "X(20)"
     FIELD parcela              AS INT 
     FIELD credito              AS LOG .

DEFINE TEMP-TABLE tt-acerto-sr NO-UNDO
    FIELD ID_Revendedor	       AS INT
    FIELD acquirer_nsu         AS INT
    FIELD valor                AS DEC . 

DEFINE TEMP-TABLE tt-mensagens NO-UNDO
    FIELD info-erro      AS CHAR FORMAT "X(256)"
    FIELD cod-estab      LIKE tit_acr.cod_estab
    FIELD num-id-tit-acr LIKE tit_acr.num_id_tit_acr
    FIELD des-erro       AS CHARACTER FORMAT "x(256)"
    FIELD l-erro         AS LOGICAL.
    
/*************************** Variaveis  *****************************************************/
DEF VAR l-erro       AS LOG                                 NO-UNDO.
DEF VAR h-acomp      AS HANDLE                              NO-UNDO.
DEF VAR l-ecommerce  AS LOG                                 NO-UNDO.
DEF VAR c-cod-lucree LIKE emitente.cod-emitente INIT 558942 NO-UNDO.
DEF VAR c-cod-refer  AS CHAR                                NO-UNDO.
DEF VAR id           AS INT                                 NO-UNDO.
DEF VAR i-seq        AS INT                     INIT 1      NO-UNDO.

DEF BUFFER b1-tt-arquivo FOR tt-arquivo.

/*************************** INCLUDES  *****************************************************/
/* include padrÆo para vari veis de relat¢rio  */
{include/i-rpvar.i}
{include/i-rpout.i}
{include/i-rpcab.i}
{utp/ut-glob.i}
{btb/btb912zb.i}
{esp/acr/esacr086.i}.
{esp/acr/esacr086a.i}.
{esp/acr/acr711zo.i}.

/*--- Processamento Principal ---*/
IF  NOT VALID-HANDLE(h-acomp) THEN
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

RUN pi-inicializar IN h-acomp (INPUT "Importando Tabela").
                                               
RUN pi-importa-arquivo.

RUN pi-gera-acertos-sr.

RUN pi-gera-acertos-dl.

RUN prgfin/acr/acr711zo.py (INPUT  4,
                            INPUT  TABLE tt_alter_tit_acr_base_2,
                            INPUT  TABLE tt_alter_tit_acr_rateio,
                            INPUT  TABLE tt_alter_tit_acr_ped_vda,
                            INPUT  TABLE tt_alter_tit_acr_comis,
                            INPUT  TABLE tt_alter_tit_acr_cheq,
                            INPUT  TABLE tt_alter_tit_acr_iva,
                            INPUT  TABLE tt_alter_tit_acr_impto_retid_2,
                            INPUT  TABLE tt_alter_tit_acr_cobr_espec_2,
                            INPUT  TABLE tt_alter_tit_acr_rat_desp_rec,
                            OUTPUT TABLE tt_log_erros_alter_tit_acr,
                            INPUT  NO).

FOR EACH tt_log_erros_alter_tit_acr:
    CREATE tt-mensagens.
    ASSIGN tt-mensagens.num-id-tit-acr = 0
           tt-mensagens.des-erro       = tt_log_erros_alter_tit_acr.ttv_des_msg_erro + " -> " + tt_log_erros_alter_tit_acr.ttv_des_msg_ajuda
           tt-mensagens.l-erro         = YES.
END.

PUT "---------------------------------------------------------------------------------------------------------------------" SKIP  .
PUT "ESACR087 - Importacao de titulos ACR - Lucree                                                                        " SKIP  .
PUT "---------------------------------------------------------------------------------------------------------------------" SKIP  .
PUT "TITULOS ESPECIE SR GERADOS:" SKIP .
PUT "---------------------------------------------------------------------------------------------------------------------" SKIP .
PUT "TITULO" AT 1
    "NSU"    AT 22
    "DOC PARTICIPANTE" AT 42
    "ID REVENDEDOR"    AT 62
    "VALOR LIQUIDO"    AT 82 SKIP.
PUT "---------------------------------------------------------------------------------------------------------------------" SKIP .
FOR EACH tt-lista-consolidada 
    /*WHERE tt-lista-consolidada.credito = YES*/:
    PUT tt-lista-consolidada.id_titulo                FORMAT "X(20)"  AT 1        
        STRING(tt-lista-consolidada.acquirer_nsu)     FORMAT "X(20)"  AT 22    
        STRING(tt-lista-consolidada.doc_participante) FORMAT "X(20)"  AT 42 
        STRING(tt-lista-consolidada.ID_Revendedor)    FORMAT "X(20)"  AT 62  
        STRING(tt-lista-consolidada.valorliquido)     FORMAT "X(20)"  AT 82  SKIP.
END.
PUT "---------------------------------------------------------------------------------------------------------------------" SKIP  .
PUT "TITULOS ESPECIE DL GERADOS:" SKIP .
PUT "---------------------------------------------------------------------------------------------------------------------" SKIP .
PUT "TITULO" AT 1
    "NSU"    AT 22
    "DOC PARTICIPANTE" AT 42
    "ID REVENDEDOR"    AT 62
    "VALOR LIQUIDO"    AT 82 SKIP.

PUT "---------------------------------------------------------------------------------------------------------------------" SKIP .
FOR EACH tt-arquivo-importado:
    PUT string(tt-arquivo-importado.acquirer_nsu)     FORMAT "X(20)"  AT 1        
        STRING(tt-arquivo-importado.acquirer_nsu)     FORMAT "X(20)"  AT 22    
        STRING(tt-arquivo-importado.doc_participante) FORMAT "X(20)"  AT 42 
        STRING(tt-arquivo-importado.ID_Revendedor)    FORMAT "X(20)"  AT 62  
        STRING(tt-arquivo-importado.valorliquido)     FORMAT "X(20)"  AT 82  SKIP.
END.
PUT "------------------------------------------ MENSAGENS DE ERRO --------------------------------------------------------" SKIP.

FOR EACH tt-mensagens:
    PUT tt-mensagens.des-erro SKIP.
END.


PROCEDURE pi-importa-arquivo:
    DEF VAR ncont        AS INT INIT 1 NO-UNDO.
    DEF VAR xlinha       AS CHAR       NO-UNDO.
    DEF VAR i-parcela    AS INT INIT 1 NO-UNDO.
    DEF VAR dt-prev-pgto AS DATE       NO-UNDO.
    
    INPUT FROM VALUE(tt-param.c-arq-import).
    IMPORT UNFORMATTED xlinha.    
    REPEAT:
        CREATE tt-arquivo.
        IMPORT DELIMITER ";" tt-arquivo.
        ASSIGN ncont = ncont + 1.
    END.
    INPUT CLOSE.

// Reconstr¢i a temp-table formatando os campos decimais 
// Vamos considerar apenas as linhas que possuam split de valor 0.7, sÆo estas que remetem ao cr‚dito que deve ser gerado dentro do sistema
// Utilizamos o buffer para buscar o id do revendedor correto, visto que as linhas com split = 0.7 possuem como ID_Revendedor os dados da intelbras 
// Ap¢s isso ‚ gerado a consolida‡Æo dos valores para cria‡Æo da SR 

    ASSIGN dt-prev-pgto = TODAY + 30.
    
    FOR EACH tt-arquivo 
        WHERE tt-arquivo.split_percentual = "0.7" BREAK BY tt-arquivo.authorization_number :

        IF  FIRST-OF(tt-arquivo.authorization_number) THEN DO: 
            ASSIGN i-parcela    = 1
                   dt-prev-pgto = TODAY + 30 .
        END.
        
        FIND LAST tt-arquivo-importado
            WHERE tt-arquivo-importado.authorization_number = tt-arquivo.authorization_number NO-ERROR.

        IF  NOT AVAIL tt-arquivo-importado THEN DO:
            
            FIND FIRST b1-tt-arquivo 
                WHERE b1-tt-arquivo.acquirer_nsu   = tt-arquivo.acquirer_nsu 
                AND   b1-tt-arquivo.ID_Revendedor <> 18938 NO-ERROR.
    
            CREATE tt-arquivo-importado.
            ASSIGN tt-arquivo-importado.authorization_number = tt-arquivo.authorization_number
                   tt-arquivo-importado.acquirer_nsu         = tt-arquivo.acquirer_nsu        
                   tt-arquivo-importado.participante         = b1-tt-arquivo.participante        
                   tt-arquivo-importado.doc_participante	 = b1-tt-arquivo.doc_participante	 
                   tt-arquivo-importado.ID_Revendedor	     = b1-tt-arquivo.ID_Revendedor	     
                   tt-arquivo-importado.Nome_Lojista         = b1-tt-arquivo.Nome_Lojista        
                   tt-arquivo-importado.Doc_Lojista          = b1-tt-arquivo.Doc_Lojista         
                   tt-arquivo-importado.parcela	             = i-parcela  //tt-arquivo.parcela	         
                   tt-arquivo-importado.val_venda            = DEC(REPLACE(tt-arquivo.val_venda	   , ".", ","))              
                   tt-arquivo-importado.split_percentual     = DEC(REPLACE(tt-arquivo.split_percentual, ".", ","))     
                   tt-arquivo-importado.valorbruto           = DEC(REPLACE(tt-arquivo.valorbruto      , ".", ","))           
                   tt-arquivo-importado.valordesconto        = DEC(REPLACE(tt-arquivo.valordesconto   , ".", ","))       
                   tt-arquivo-importado.valorliquido         = DEC(REPLACE(tt-arquivo.valorliquido    , ".", ","))
                   tt-arquivo-importado.taxa_revenda         = DEC(REPLACE(tt-arquivo.taxa_revenda    , ".", ","))
                   tt-arquivo-importado.c-status             = tt-arquivo.c-status            
                   tt-arquivo-importado.modalidade           = tt-arquivo.modalidade          
                   tt-arquivo-importado.bandeira             = tt-arquivo.bandeira            
                   tt-arquivo-importado.c-terminal           = tt-arquivo.c-terminal          
                   tt-arquivo-importado.dataprevista         = dt-prev-pgto       
                   tt-arquivo-importado.datapagamento        = tt-arquivo.datapagamento       
                   tt-arquivo-importado.dataautorizacao      = tt-arquivo.dataautorizacao.
            
            ASSIGN i-parcela    = i-parcela    + 1
                   dt-prev-pgto = dt-prev-pgto + 30.
        END.
        ELSE DO:

            FIND FIRST b1-tt-arquivo
                WHERE b1-tt-arquivo.acquirer_nsu   = tt-arquivo.acquirer_nsu 
                AND   b1-tt-arquivo.ID_Revendedor <> 18938 NO-ERROR.

            CREATE tt-arquivo-importado.
            ASSIGN tt-arquivo-importado.authorization_number = tt-arquivo.authorization_number
                   tt-arquivo-importado.acquirer_nsu         = tt-arquivo.acquirer_nsu        
                   tt-arquivo-importado.participante         = b1-tt-arquivo.participante        
                   tt-arquivo-importado.doc_participante	 = b1-tt-arquivo.doc_participante	 
                   tt-arquivo-importado.ID_Revendedor	     = b1-tt-arquivo.ID_Revendedor	     
                   tt-arquivo-importado.Nome_Lojista         = b1-tt-arquivo.Nome_Lojista        
                   tt-arquivo-importado.Doc_Lojista          = b1-tt-arquivo.Doc_Lojista         
                   tt-arquivo-importado.parcela	             = i-parcela 	         
                   tt-arquivo-importado.val_venda            = DEC(REPLACE(tt-arquivo.val_venda	   , ".", ","))              
                   tt-arquivo-importado.split_percentual     = DEC(REPLACE(tt-arquivo.split_percentual, ".", ","))     
                   tt-arquivo-importado.valorbruto           = DEC(REPLACE(tt-arquivo.valorbruto      , ".", ","))           
                   tt-arquivo-importado.valordesconto        = DEC(REPLACE(tt-arquivo.valordesconto   , ".", ","))       
                   tt-arquivo-importado.valorliquido         = DEC(REPLACE(tt-arquivo.valorliquido    , ".", ","))
                   tt-arquivo-importado.taxa_revenda         = DEC(REPLACE(tt-arquivo.taxa_revenda    , ".", ","))
                   tt-arquivo-importado.c-status             = tt-arquivo.c-status            
                   tt-arquivo-importado.modalidade           = tt-arquivo.modalidade          
                   tt-arquivo-importado.bandeira             = tt-arquivo.bandeira            
                   tt-arquivo-importado.c-terminal           = tt-arquivo.c-terminal          
                   tt-arquivo-importado.dataprevista         = dt-prev-pgto        
                   tt-arquivo-importado.datapagamento        = tt-arquivo.datapagamento       
                   tt-arquivo-importado.dataautorizacao      = tt-arquivo.dataautorizacao.

            ASSIGN i-parcela    = i-parcela    + 1
                   dt-prev-pgto = dt-prev-pgto + 30.
        END.
    END.

    RUN pi-consolida-lista.

END. //pi-importa-arquivo

PROCEDURE pi-consolida-lista:
    //Realiza a consolidacao da lista pelo campo acquirer_nsu / posteriormente sendo usada para a geracao dos titulos especie SR
    
    DEF VAR i-revendedor AS INT NO-UNDO.

    FOR EACH tt-arquivo-importado :

        ASSIGN i-revendedor = int(tt-arquivo-importado.ID_Revendedor).
        
        FIND FIRST tt-lista-consolidada
            WHERE tt-lista-consolidada.ID_Revendedor = tt-arquivo-importado.ID_Revendedor NO-ERROR.

        IF  NOT AVAIL tt-lista-consolidada THEN DO:
            CREATE tt-lista-consolidada.
            ASSIGN tt-lista-consolidada.acquirer_nsu      = tt-arquivo-importado.acquirer_nsu
                   tt-lista-consolidada.doc_participante  = tt-arquivo-importado.doc_participante
                   tt-lista-consolidada.ID_Revendedor     = tt-arquivo-importado.ID_Revendedor
                   tt-lista-consolidada.val_venda         = tt-arquivo-importado.val_venda
                   tt-lista-consolidada.valorbruto        = tt-arquivo-importado.valorbruto
                   tt-lista-consolidada.valorliquido      = tt-arquivo-importado.valorliquido
                   tt-lista-consolidada.valordesconto     = tt-arquivo-importado.valordesconto
                   // ID_TITULO ACR =  Para SR - considerar coluna ID Revendedor com formato 6 inteiros + dia e mˆs (today) e parcela o ano com dois caracteres.
                   //tt-lista-consolidada.id_titulo         = STRING(tt-arquivo-importado.ID_Revendedor) + STRING(DAY(TODAY)) + STRING(MONTH(TODAY)) + STRING(tt-arquivo-importado.parcela) + SUBSTRING(STRING(YEAR(TODAY)),2).
                   tt-lista-consolidada.id_titulo         = STRING(i-revendedor,"999999") + string(DAY(TODAY),"99") + STRING(MONTH(TODAY),"99") 
                   tt-lista-consolidada.credito           = IF tt-arquivo-importado.modalidade matches("*parcelado*") THEN TRUE ELSE FALSE. 
        END.
        ELSE DO:
            ASSIGN tt-lista-consolidada.valorbruto    = tt-lista-consolidada.valorbruto    + tt-arquivo-importado.valorbruto
                   tt-lista-consolidada.valorliquido  = tt-lista-consolidada.valorliquido  + tt-arquivo-importado.valorliquido
                   tt-lista-consolidada.valordesconto = tt-lista-consolidada.valordesconto + tt-arquivo-importado.valordesconto.

            IF  tt-arquivo-importado.modalidade matches("*parcelado*") THEN
                ASSIGN tt-lista-consolidada.credito = YES.
        END.
    END.
END.

PROCEDURE pi-gera-acertos-sr:

    DEF VAR v-acerto     AS DEC  NO-UNDO.
    DEF VAR l-referencia AS LOG  NO-UNDO.
    DEF VAR cAcerto      AS CHAR NO-UNDO.
    
    //Consolida valor do acerto a menor conforme regra
    /*Regra acerto -> Para SR - considerar apenas caso na coluna modalidade conste Cr‚dito Parcelado
     e nestes casos validar o n£mero total de parcelas , coluna parcela, onde at‚ 6 parcelas a taxa de desconto ser  6.99% e acima ser  8.99%.
     Aplicar esta taxa sobre o valor da coluna val venda e efetuar o acerto de valor a menor. */
    /*FOR EACH tt-arquivo-importado WHERE tt-arquivo-importado.modalidade matches("*parcelado*") 
                                     BY tt-arquivo-importado.parcela DESC :*/
    FOR EACH tt-arquivo-importado
        WHERE tt-arquivo-importado.taxa_revenda > 0 :

        FIND FIRST tt-acerto-sr
            WHERE tt-acerto-sr.id_revendedor = tt-arquivo-importado.id_revendedor
            AND   tt-acerto-sr.acquirer_nsu  = tt-arquivo-importado.acquirer_nsu NO-ERROR.
        
        IF  NOT AVAIL tt-acerto-sr THEN DO:
            //Formata valor percentual do acerto em duas casas decimais

            ASSIGN cAcerto = STRING((tt-arquivo-importado.val_venda * tt-arquivo-importado.taxa_revenda ) / 100 , "9999.99"). 

            CREATE tt-acerto-sr.
            ASSIGN tt-acerto-sr.id_revendedor = tt-arquivo-importado.id_revendedor
                   tt-acerto-sr.acquirer_nsu  = tt-arquivo-importado.acquirer_nsu
                   tt-acerto-sr.valor         = DEC(cAcerto) - tt-arquivo-importado.valordesconto.
        END.
        ELSE
            ASSIGN tt-acerto-sr.valor = tt-acerto-sr.valor - tt-arquivo-importado.valordesconto.
    END.

    FOR EACH tt-lista-consolidada
        /*WHERE tt-lista-consolidada.credito = YES*/:

        ASSIGN v-acerto     = 0
               l-referencia = NO.

        RUN pi-acompanhar IN h-acomp (INPUT "Gerando acertos SR").

        FIND FIRST tit_acr
            WHERE tit_acr.cod_tit_acr     = tt-lista-consolidada.id_titulo 
            AND   tit_acr.cod_espec_docto = "SR" 
            AND   tit_acr.cdn_cliente     = c-cod-lucree 
            AND   tit_acr.cod_estab       = '104' NO-LOCK NO-ERROR.
        
        IF  AVAIL tit_acr THEN DO:            
            RUN pi-gera-referencia IN THIS-PROCEDURE (INPUT  "104",
                                                      INPUT  ?,
                                                      OUTPUT c-cod-refer).

            //Valida se a referencia gerada nunca foi usada
            DO  WHILE l-referencia <> YES:
                IF  CAN-FIND(FIRST movto_tit_acr 
                            WHERE movto_tit_acr.cod_refer = c-cod-refer
                            AND   movto_tit_acr.cod_estab = "104" ) THEN DO:
                    RUN pi-gera-referencia IN THIS-PROCEDURE (INPUT  "104",
                                                              INPUT  ?,
                                                              OUTPUT c-cod-refer).
                END.
                ELSE DO:
                    ASSIGN l-referencia = YES.
                END.
            END.

            FOR EACH tt-acerto-sr
                WHERE tt-acerto-sr.id_revendedor = tt-lista-consolidada.id_revendedor:
                
                ASSIGN v-acerto = v-acerto + tt-acerto-sr.valor. 
            END.

            CREATE tt_alter_tit_acr_base_2.
            ASSIGN tt_alter_tit_acr_base_2.tta_cod_estab                   = tit_acr.cod_estab 
                   tt_alter_tit_acr_base_2.tta_num_id_tit_acr              = tit_acr.num_id_tit_acr 
                   tt_alter_tit_acr_base_2.tta_dat_transacao               = TODAY 
                   tt_alter_tit_acr_base_2.tta_cod_refer                   = c-cod-refer
                   tt_alter_tit_acr_base_2.ttv_cod_motiv_movto_tit_acr_imp = ?
                   tt_alter_tit_acr_base_2.tta_val_sdo_tit_acr             = IF v-acerto > 0 THEN tit_acr.val_sdo_tit_acr - v-acerto ELSE tit_acr.val_sdo_tit_acr + (v-acerto * -1)
                   tt_alter_tit_acr_base_2.ttv_cod_motiv_movto_tit_acr_alt = ""
                   tt_alter_tit_acr_base_2.ttv_ind_motiv_acerto_val        = "Altera‡Æo" //"Acerto" //"Liquid‡Æo"
                   tt_alter_tit_acr_base_2.tta_cod_portador                = ?
                   tt_alter_tit_acr_base_2.tta_cod_cart_bcia               = ?
                   tt_alter_tit_acr_base_2.tta_val_despes_bcia             = ?
                   tt_alter_tit_acr_base_2.tta_cod_agenc_cobr_bcia         = ?
                   tt_alter_tit_acr_base_2.tta_cod_tit_acr_bco             = ?
                   tt_alter_tit_acr_base_2.tta_dat_emis_docto              = ?  //today - 1
                   tt_alter_tit_acr_base_2.tta_dat_vencto_tit_acr          = tit_acr.dat_vencto_tit_acr  //today - 1
                   tt_alter_tit_acr_base_2.tta_dat_prev_liquidac           = tit_acr.dat_prev_liquidac
                   tt_alter_tit_acr_base_2.tta_dat_fluxo_tit_acr           = ?  //today - 1
                   tt_alter_tit_acr_base_2.tta_ind_sit_tit_acr             = ?
                   tt_alter_tit_acr_base_2.tta_cod_cond_cobr               = ?
                   tt_alter_tit_acr_base_2.tta_log_tip_cr_perda_dedut_tit  = ?  
                   tt_alter_tit_acr_base_2.tta_dat_abat_tit_acr            = ?
                   tt_alter_tit_acr_base_2.tta_val_abat_tit_acr            = ?
                   tt_alter_tit_acr_base_2.tta_dat_desconto                = ?
                   tt_alter_tit_acr_base_2.tta_val_perc_desc               = ?
                   tt_alter_tit_acr_base_2.tta_val_desc_tit_acr            = ?
                   tt_alter_tit_acr_base_2.tta_qtd_dias_carenc_juros_acr   = ?
                   tt_alter_tit_acr_base_2.tta_val_perc_juros_dia_atraso   = ?
                   tt_alter_tit_acr_base_2.tta_val_perc_multa_atraso       = ?
                   tt_alter_tit_acr_base_2.tta_qtd_dias_carenc_multa_acr   = ?
                   tt_alter_tit_acr_base_2.tta_ind_ender_cobr              = ?
                   tt_alter_tit_acr_base_2.tta_nom_abrev_contat            = ?
                   tt_alter_tit_acr_base_2.tta_val_liq_tit_acr             = ?
                   tt_alter_tit_acr_base_2.tta_cod_instruc_bcia_1_movto    = ?
                   tt_alter_tit_acr_base_2.tta_cod_instruc_bcia_2_movto    = ?
                   tt_alter_tit_acr_base_2.ttv_des_text_histor             = "Hist¢rico"
                   tt_alter_tit_acr_base_2.tta_ind_tip_cobr_acr            = "NORMAL"
                   tt_alter_tit_acr_base_2.tta_log_tit_acr_destndo         = ?
                   tt_alter_tit_acr_base_2.tta_des_obs_cobr                = ?
                   tt_alter_tit_acr_base_2.tta_val_perc_abat_acr           = ?. 

            CREATE tt_alter_tit_acr_rateio.
            ASSIGN tt_alter_tit_acr_rateio.tta_cod_estab                   = tit_acr.cod_estab
                   tt_alter_tit_acr_rateio.tta_num_id_tit_acr              = tit_acr.num_id_tit_acr
                   tt_alter_tit_acr_rateio.ttv_ind_tip_rat_tit_acr         = "Altera‡Æo":U //"Acerto":U //"Liquida‡Æo":U //"Altera‡Æo":U
                   tt_alter_tit_acr_rateio.tta_cod_refer                   = c-cod-refer
                   tt_alter_tit_acr_rateio.tta_cod_plano_cta_ctbl          = "padrao":U
                   tt_alter_tit_acr_rateio.tta_cod_cta_ctbl                = IF v-acerto > 0 THEN "51210017" ELSE "51120017"
                   tt_alter_tit_acr_rateio.tta_num_seq_aprop_ctbl_pend_acr = i-seq  
                   tt_alter_tit_acr_rateio.tta_val_aprop_ctbl              = IF v-acerto > 0 THEN v-acerto ELSE (v-acerto * -1).
                
            ASSIGN i-seq = i-seq +  1 .

            CREATE tt-mensagens.
            ASSIGN tt-mensagens.info-erro      = "ERRO"
                   tt-mensagens.num-id-tit-acr = 0
                   tt-mensagens.des-erro       = "ACERTO GERADO: Titulo: " + STRING(tt-lista-consolidada.id_titulo ) + " ESPECIE SR - VALOR R$" + STRING(v-acerto) .
        END.
        ELSE DO:
            CREATE tt-mensagens.
            ASSIGN tt-mensagens.info-erro      = "ERRO"
                   tt-mensagens.num-id-tit-acr = 0
                   tt-mensagens.des-erro       = "Titulo: " + STRING(tt-lista-consolidada.id_titulo ) + " Esp‚cie SR, nÆo encontrado" .
                   tt-mensagens.l-erro         = YES.
        END.
    END.

END PROCEDURE. //pi-gera-acertos-sr

PROCEDURE pi-gera-acertos-dl:

    DEF VAR i-parcela_original AS INT NO-UNDO.
    DEF VAR i-parcela          AS INT NO-UNDO.
    DEF VAR l-referencia       AS LOG NO-UNDO.

    FOR EACH tt-arquivo-importado
        WHERE tt-arquivo-importado.taxa_revenda <= 0:

        RUN pi-acompanhar IN h-acomp (INPUT "Gerando acertos DL").

        RUN pi-gera-referencia IN THIS-PROCEDURE (INPUT  "104",
                                                  INPUT  ?,
                                                  OUTPUT c-cod-refer).

        //Valida se a referencia gerada nunca foi usada
        DO  WHILE l-referencia <> YES:
            
            IF  CAN-FIND(FIRST movto_tit_acr 
                         WHERE movto_tit_acr.cod_refer = c-cod-refer
                         AND   movto_tit_acr.cod_estab = "104" ) THEN DO:

                RUN pi-gera-referencia IN THIS-PROCEDURE (INPUT  "104",
                                                          INPUT  ?,
                                                          OUTPUT c-cod-refer).
            END.
            ELSE DO:
                ASSIGN l-referencia = YES.
            END.
        END.

        FIND FIRST tit_acr
            WHERE tit_acr.cod_tit_acr     = fGera_ID_DL(tt-arquivo-importado.authorization_number ,string(tt-arquivo-importado.acquirer_nsu))
          //WHERE tit_acr.cod_tit_acr     = string(tt-arquivo-importado.acquirer_nsu , "9999999999") 
            AND   tit_acr.cod_espec_docto = "DL" 
            AND   tit_acr.cdn_cliente     = c-cod-lucree 
            AND   tit_acr.cod_estab       = '104' 
            AND   tit_acr.cod_parcela     =  STRING(tt-arquivo-importado.parcela , "99" ) NO-LOCK NO-ERROR.

        IF  AVAIL  tit_acr THEN DO:
             
            FIND FIRST tt_alter_tit_acr_base_2
                WHERE tt_alter_tit_acr_base_2.tta_num_id_tit_acr =  tit_acr.num_id_tit_acr NO-LOCK NO-ERROR.

            IF  NOT AVAIL tt_alter_tit_acr_base_2 THEN DO:
                
                CREATE tt_alter_tit_acr_base_2.
                ASSIGN tt_alter_tit_acr_base_2.tta_cod_estab                   = tit_acr.cod_estab 
                       tt_alter_tit_acr_base_2.tta_num_id_tit_acr              = tit_acr.num_id_tit_acr 
                       tt_alter_tit_acr_base_2.tta_dat_transacao               = TODAY 
                       tt_alter_tit_acr_base_2.tta_cod_refer                   = c-cod-refer
                       tt_alter_tit_acr_base_2.ttv_cod_motiv_movto_tit_acr_imp = ?
                       tt_alter_tit_acr_base_2.tta_val_sdo_tit_acr             = tit_acr.val_sdo_tit_acr - tt-arquivo-importado.valordesconto
                       tt_alter_tit_acr_base_2.ttv_cod_motiv_movto_tit_acr_alt = ""
                       tt_alter_tit_acr_base_2.ttv_ind_motiv_acerto_val        = "Liquida‡Æo" //"Acerto" //"Liquid‡Æo"
                       tt_alter_tit_acr_base_2.tta_cod_portador                = ?
                       tt_alter_tit_acr_base_2.tta_cod_cart_bcia               = ?
                       tt_alter_tit_acr_base_2.tta_val_despes_bcia             = ?
                       tt_alter_tit_acr_base_2.tta_cod_agenc_cobr_bcia         = ?
                       tt_alter_tit_acr_base_2.tta_cod_tit_acr_bco             = ?
                       tt_alter_tit_acr_base_2.tta_dat_emis_docto              = ? 
                       tt_alter_tit_acr_base_2.tta_dat_vencto_tit_acr          = tit_acr.dat_vencto_tit_acr
                       tt_alter_tit_acr_base_2.tta_dat_prev_liquidac           = tit_acr.dat_prev_liquidac
                       tt_alter_tit_acr_base_2.tta_dat_fluxo_tit_acr           = ?
                       tt_alter_tit_acr_base_2.tta_ind_sit_tit_acr             = ?
                       tt_alter_tit_acr_base_2.tta_cod_cond_cobr               = ?
                       tt_alter_tit_acr_base_2.tta_log_tip_cr_perda_dedut_tit  = ?  
                       tt_alter_tit_acr_base_2.tta_dat_abat_tit_acr            = ?
                       tt_alter_tit_acr_base_2.tta_val_abat_tit_acr            = ?
                       tt_alter_tit_acr_base_2.tta_dat_desconto                = ?
                       tt_alter_tit_acr_base_2.tta_val_perc_desc               = ?
                       tt_alter_tit_acr_base_2.tta_val_desc_tit_acr            = ?
                       tt_alter_tit_acr_base_2.tta_qtd_dias_carenc_juros_acr   = ?
                       tt_alter_tit_acr_base_2.tta_val_perc_juros_dia_atraso   = ?
                       tt_alter_tit_acr_base_2.tta_val_perc_multa_atraso       = ?
                       tt_alter_tit_acr_base_2.tta_qtd_dias_carenc_multa_acr   = ?
                       tt_alter_tit_acr_base_2.tta_ind_ender_cobr              = ?
                       tt_alter_tit_acr_base_2.tta_nom_abrev_contat            = ?
                       tt_alter_tit_acr_base_2.tta_val_liq_tit_acr             = ?
                       tt_alter_tit_acr_base_2.tta_cod_instruc_bcia_1_movto    = ?
                       tt_alter_tit_acr_base_2.tta_cod_instruc_bcia_2_movto    = ?
                       tt_alter_tit_acr_base_2.ttv_des_text_histor             = "Hist¢rico"
                       tt_alter_tit_acr_base_2.tta_ind_tip_cobr_acr            = "NORMAL"
                       tt_alter_tit_acr_base_2.tta_log_tit_acr_destndo         = ?
                       tt_alter_tit_acr_base_2.tta_des_obs_cobr                = ?
                       tt_alter_tit_acr_base_2.tta_val_perc_abat_acr           = ?.           
        
                CREATE tt_alter_tit_acr_rateio.
                ASSIGN tt_alter_tit_acr_rateio.tta_cod_estab                   = tit_acr.cod_estab
                       tt_alter_tit_acr_rateio.tta_num_id_tit_acr              = tit_acr.num_id_tit_acr
                       tt_alter_tit_acr_rateio.ttv_ind_tip_rat_tit_acr         = "Altera‡Æo":U
                       tt_alter_tit_acr_rateio.tta_cod_refer                   = c-cod-refer
                       tt_alter_tit_acr_rateio.tta_cod_plano_cta_ctbl          = "padrao":U
                       tt_alter_tit_acr_rateio.tta_cod_cta_ctbl                = "51120017"
                       tt_alter_tit_acr_rateio.tta_num_seq_aprop_ctbl_pend_acr = i-seq  .
                       tt_alter_tit_acr_rateio.tta_val_aprop_ctbl              = tt-arquivo-importado.valordesconto . //val_sdo_tit_acr . 

                ASSIGN i-seq = i-seq +  1 .

                CREATE tt-mensagens.
                ASSIGN tt-mensagens.info-erro     = "ERRO"
                      tt-mensagens.num-id-tit-acr = 0
                      tt-mensagens.des-erro       = "ACERTO GERADO: Titulo: " + STRING(tit_acr.cod_tit_acr) + " PARCELA: " + STRING(tit_acr.cod_parcela) + " ESPECIE DL - VALOR R$" + STRING(tt-arquivo-importado.valordesconto) .


            END.
            ELSE DO:
                CREATE tt-mensagens.
                ASSIGN tt-mensagens.info-erro      = "ERRO"//"NSU: " +  tt-lista-consolidada.acquirer_nsu + " IDRevendedor: " + STRING(tt-lista-consolidada.ID_Revendedor) + " Valor :" + string(tt-lista-consolidada.valorbruto)
                       tt-mensagens.num-id-tit-acr = 0
                     //tt-mensagens.des-erro       = tt_log_erros_atualiz.ttv_des_msg_erro + " -> " + tt_log_erros_atualiz.ttv_des_msg_ajuda
                       tt-mensagens.des-erro       =  "Titulo: " + STRING(tt-arquivo-importado.acquirer_nsu ) + " Esp‚cie SR, nÆo encontrado" .
                       tt-mensagens.l-erro         = YES.
            END.
        END.
    END.

END PROCEDURE. //pi-gera-acertos-dl


RUN pi-finalizar in h-acomp.

RETURN "OK":U. //Return Final 
