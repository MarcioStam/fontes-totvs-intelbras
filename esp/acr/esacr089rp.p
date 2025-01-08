/************************************************************************************************************
*      Programa .....: ESACR089RP                                                                           *
*      Data .........: 29 de Maio de 2023                                                                   *
*      Empresa ......: IDBA                                                                                 *
*      Cliente ......: Intelbras                                                                            *
*      Programador ..: Bruno Joaquim                                                                        *
*      Objetivo .....: Geraá∆o de Liquidaá‰es                                                               *
*************************************************************************************************************
*  VERSAO       DATA        RESPONSAVEL              MOTIVO                                                 *
*  1.00.00.000  19/05/2023  Bruno Joaquim           Desenvolvimento                                         *
************************************************************************************************************/
/***********************************************************************************************************/
/***********************************************************************************************************/
/*************************** TEMP-TABLES *******************************************************************/
/***********************************************************************************************************/
{include/i-prgvrs.i esacr089rp 2.00.00.000} 

//{esp/acr/esacr086.i} //Include com definicao das temp-tables usadas nas API's do ACR 
{esp\acr\esacr086.i}.

define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9":U
    field exemplo          as character format "x(30)":U
    index id ordem.

def temp-table tt-raw-digita
    field raw-digita       as raw.
 
DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino                AS INTEGER
    FIELD arquivo                AS CHARACTER FORMAT "x(35)"
    FIELD usuario                AS CHARACTER FORMAT "x(12)"
    FIELD data-exec              AS DATE
    FIELD hora-exec              AS INTEGER
    FIELD tp-execucao            AS INTEGER
    FIELD c-arq-import           AS CHARACTER
    FIELD cod_portador           AS CHARACTER FORMAT "x(3)"
    FIELD cod_cart_bcia          AS CHARACTER FORMAT "x(3)"
    FIELD data-liquidacao        AS DATE.

                                         
DEF input parameter raw-param as raw no-undo.
DEF input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

DEF TEMP-TABLE tt-arquivo NO-UNDO
   FIELD authorization_number  AS CHAR
   FIELD ID_Revendedor	       AS INT
   FIELD data_agendado         AS CHAR FORMAT "x(25)" 
   FIELD data_transacao        AS CHAR FORMAT "x(25)" 
   FIELD modalidade            AS CHAR FORMAT "x(25)" 
   FIELD bandeira              AS CHAR FORMAT "x(25)" 
   FIELD documento             AS CHAR FORMAT "x(25)"
   FIELD nome                  AS CHAR FORMAT "x(50)" 
   FIELD split_porcentual      AS CHAR FORMAT "x(50)" 
   FIELD valor_transacao       AS CHAR FORMAT "x(50)" 
   FIELD valor_bruto           AS CHAR FORMAT "x(50)" 
   FIELD valor_desconto        AS CHAR FORMAT "x(50)" 
   FIELD valor_liquido         AS CHAR FORMAT "x(50)" 
   FIELD c-status	           AS CHAR FORMAT "x(20)" 
   FIELD nsu                   AS INT 
   FIELD taxa_revenda          AS CHAR .

DEF TEMP-TABLE tt-arquivo-importado NO-UNDO
   FIELD authorization_number  AS CHAR
   FIELD ID_Revendedor	       AS INT
   FIELD data_agendado         AS CHAR FORMAT "x(25)" 
   FIELD data_transacao        AS CHAR FORMAT "x(25)" 
   FIELD modalidade            AS CHAR FORMAT "x(25)" 
   FIELD bandeira              AS CHAR FORMAT "x(25)"
   FIELD documento             AS CHAR FORMAT "x(18)" 
   FIELD nome                  AS CHAR FORMAT "x(50)" 
   FIELD split_porcentual      AS DEC 
   FIELD valor_transacao       AS DEC 
   FIELD valor_bruto           AS DEC 
   FIELD valor_desconto        AS DEC 
   FIELD valor_liquido         AS DEC 
   FIELD c-status	           AS CHAR FORMAT "x(20)" 
   FIELD nsu                   AS CHAR FORMAT "x(10)" .


DEFINE TEMP-TABLE tt-mensagens NO-UNDO
    FIELD cod-erro       AS INTEGER 
    FIELD valor          AS DECIMAL
    FIELD titulo         AS CHARACTER FORMAT "x(10)" 
    FIELD parcela        LIKE tit_acr.cod_parcela
    FIELD des-erro       AS CHARACTER FORMAT "x(256)"
    FIELD l-erro         AS LOGICAL.
    
/********************************************************************************************/
/*************************** Variaveis  *****************************************************/
/********************************************************************************************/
DEFINE VARIABLE h-acomp         AS HANDLE       NO-UNDO.
DEFINE VARIABLE c-cod-lucree    LIKE emitente.cod-emitente INITIAL 558942 .
DEFINE VARIABLE c-cod-refer     AS CHARACTER    NO-UNDO.
DEFINE VARIABLE id              AS INTEGER      NO-UNDO.
DEFINE VARIABLE v_hld_handle    AS HANDLE       NO-UNDO.


/********************************************************************************************/
/*************************** INCLUDES  *****************************************************/
/********************************************************************************************/
/* include padr∆o para vari†veis de relat¢rio  */
{include/i-rpvar.i}
{include/i-rpout.i}
{include/i-rpcab.i}
{utp/ut-glob.i}
{btb/btb912zb.i}


{esp\acr\esacr086a.i}
//{esp/acr/acr711zo.i}.
{esp\acr\acr711zo.i}

/*--- Processamento Principal ---*/
IF  NOT VALID-HANDLE(h-acomp) THEN
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

RUN pi-inicializar IN h-acomp (INPUT "Importando Tabela").

RUN pi-importa-arquivo.

RUN pi-gera-liquidacoes.

PUT "ESACR089RP " SKIP. 
PUT "---------------------------------------------------------------------------------------------------------------------" SKIP.
PUT "LIQUIDACOES GERADAS -------------------------------------------------------------------------------------------------" SKIP. 
PUT "---------------------------------------------------------------------------------------------------------------------" SKIP.
PUT "TITULO"  AT 1
    "PARCELA" AT 15
    "VALOR"   AT 25 SKIP.
PUT "---------------------------------------------------------------------------------------------------------------------" SKIP.
FOR EACH tt-mensagens WHERE tt-mensagens.cod-erro = 99 :
    PUT tt-mensagens.titulo  AT 1
        tt-mensagens.parcela AT 15 
       "R$" + string(tt-mensagens.valor, "9999.99")   AT 25 SKIP.
END.
PUT "---------------------------------------------------------------------------------------------------------------------" SKIP.
PUT "MENSAGENS DE ERRO ---------------------------------------------------------------------------------------------------" SKIP.
PUT "---------------------------------------------------------------------------------------------------------------------" SKIP.

FOR EACH tt-mensagens WHERE tt-mensagens.cod-erro = 1:
    PUT tt-mensagens.des-erro SKIP.
END.


     
PROCEDURE pi-importa-arquivo:

    RUN pi-acompanhar IN h-acomp (INPUT "Importando o arquivo").

    DEFINE VARIABLE ncont  AS INT  NO-UNDO INITIAL 1.
    DEFINE VARIABLE xlinha AS CHAR NO-UNDO.
    
    INPUT FROM VALUE(tt-param.c-arq-import).
    IMPORT UNFORMATTED xlinha.
    REPEAT:
        CREATE tt-arquivo.        IMPORT delimiter ";" tt-arquivo.        assign ncont = ncont + 1.
    END.
    INPUT CLOSE.

    //Formata arquivo passando os char pra Decimal

    FOR EACH tt-arquivo: 
        CREATE tt-arquivo-importado.
        ASSIGN  tt-arquivo-importado.authorization_number = tt-arquivo.authorization_number 
                tt-arquivo-importado.data_agendado        = tt-arquivo.data_agendado   
                tt-arquivo-importado.data_transacao       = tt-arquivo.data_transacao  
                tt-arquivo-importado.modalidade           = tt-arquivo.modalidade      
                tt-arquivo-importado.bandeira             = tt-arquivo.bandeira        
                tt-arquivo-importado.documento            = tt-arquivo.documento       
                tt-arquivo-importado.nome                 = tt-arquivo.nome            
                tt-arquivo-importado.split_porcentual     = DEC(REPLACE(tt-arquivo.split_porcentual, ".", ","))  
                tt-arquivo-importado.valor_transacao      = DEC(REPLACE(tt-arquivo.valor_transacao, ".", ",")) 
                tt-arquivo-importado.valor_bruto          = DEC(REPLACE(tt-arquivo.valor_bruto, ".", ","))      
                tt-arquivo-importado.valor_desconto       = DEC(REPLACE(tt-arquivo.valor_desconto, ".", ","))   
                tt-arquivo-importado.valor_liquido        = DEC(REPLACE(tt-arquivo.valor_liquido, ".", ","))    
                tt-arquivo-importado.c-status	          = tt-arquivo.c-status  	     
                tt-arquivo-importado.nsu                  = string(tt-arquivo.nsu, "9999999999")  .         
    END.                                                  


END. //pi-importa-arquivo

PROCEDURE pi-gera-liquidacoes:

    FIND FIRST tt-param NO-ERROR.
    
    DEFINE VAR l-referencia AS LOG.

    FOR EACH tt-arquivo-importado WHERE int(tt-arquivo-importado.nsu) <> 0 :

        ASSIGN l-referencia = NO.

        FIND FIRST tit_acr 
            WHERE tit_acr.cod_tit_acr        = fGera_ID_DL(tt-arquivo-importado.authorization_number , string(tt-arquivo-importado.nsu)) //tt-arquivo-importado.nsu
            AND   tit_acr.cod_espec_docto    = "DL" 
            AND   tit_acr.cdn_cliente        = 558942 //emitente.cod-emitente 
            AND  (tit_acr.cod_estab          = '104' 
            OR    tit_acr.cod_estab          = '101') NO-ERROR.
        
        IF  AVAIL tit_acr THEN DO:
            RUN pi-gera-referencia IN THIS-PROCEDURE (INPUT  "101",
                                                      INPUT  ?,
                                                      OUTPUT c-cod-refer).

       //Valida se a referencia gerada nunca foi usada
            DO WHILE l-referencia <> YES:
               IF CAN-FIND(movto_tit_acr WHERE movto_tit_acr.cod_refer = c-cod-refer  AND movto_tit_acr.cod_estab  = "104" ) THEN DO:
                   RUN pi-gera-referencia IN THIS-PROCEDURE (INPUT  "104",
                                                             INPUT  ?,
                                                             OUTPUT c-cod-refer).
               END.
               ELSE DO:
                  ASSIGN l-referencia = YES.
               END.
            END.

            EMPTY TEMP-TABLE tt_integr_acr_liquidac_lote.
            EMPTY TEMP-TABLE tt_integr_acr_liq_item_lote_3.
            EMPTY TEMP-TABLE tt_integr_acr_abat_antecip.
            EMPTY TEMP-TABLE tt_integr_acr_abat_prev.
            EMPTY TEMP-TABLE tt_integr_acr_cheq.
            EMPTY TEMP-TABLE tt_integr_acr_liquidac_impto_2.
            EMPTY TEMP-TABLE tt_integr_acr_rel_pend_cheq.
            EMPTY TEMP-TABLE tt_integr_acr_liq_aprop_ctbl.
            EMPTY TEMP-TABLE tt_integr_acr_liq_desp_rec.
            EMPTY TEMP-TABLE tt_integr_acr_aprop_liq_antec.
            EMPTY TEMP-TABLE tt_log_erros_import_liquidac.
            EMPTY TEMP-TABLE tt_integr_cambio_ems5.

            
            CREATE tt_integr_acr_liquidac_lote.
            ASSIGN tt_integr_acr_liquidac_lote.tta_cod_empresa                 = '1'
                   tt_integr_acr_liquidac_lote.tta_cod_estab_refer             = '104'
                   tt_integr_acr_liquidac_lote.tta_cod_usuario                 = tt-param.usuario
                   tt_integr_acr_liquidac_lote.tta_dat_gerac_lote_liquidac     = tt-param.data-liquidacao
                   tt_integr_acr_liquidac_lote.tta_dat_transacao               = tt-param.data-liquidacao
                   tt_integr_acr_liquidac_lote.tta_ind_tip_liquidac_acr        = "lote"
                   tt_integr_acr_liquidac_lote.tta_ind_sit_lote_liquidac_acr   = "Em digitaá∆o"
                   tt_integr_acr_liquidac_lote.tta_log_enctro_cta              = NO    
                   tt_integr_acr_liquidac_lote.ttv_log_atualiz_refer           = YES
                   tt_integr_acr_liquidac_lote.ttv_log_gera_lote_parcial       = NO 
                   tt_integr_acr_liquidac_lote.ttv_rec_lote_liquidac_acr       = RECID(tt_integr_acr_liquidac_lote)
                   tt_integr_acr_liquidac_lote.tta_cod_refer                   = c-cod-refer .
                 //   tt_integr_acr_liq_item_lote_3.val_cotac_indic_econ         = 0 .

            CREATE tt_integr_acr_liq_item_lote_3.
            ASSIGN tt_integr_acr_liq_item_lote_3.tta_cod_empresa                = tit_acr.cod_empresa
                   tt_integr_acr_liq_item_lote_3.tta_cod_estab                  = tit_acr.cod_estab
                   tt_integr_acr_liq_item_lote_3.tta_cod_espec_docto            = tit_acr.cod_espec_docto
                   tt_integr_acr_liq_item_lote_3.tta_cod_ser_docto              = tit_acr.cod_ser_docto
                   tt_integr_acr_liq_item_lote_3.tta_cod_tit_acr                = tit_acr.cod_tit_acr
                   tt_integr_acr_liq_item_lote_3.tta_cod_parcela                = tit_acr.cod_parcela
                   tt_integr_acr_liq_item_lote_3.tta_cdn_cliente                = tit_acr.cdn_cliente
                   tt_integr_acr_liq_item_lote_3.tta_cod_portador               = string(tt-param.cod_portador)  //portador informado na tela 
                   tt_integr_acr_liq_item_lote_3.tta_cod_cart_bcia              = string(tt-param.cod_cart_bcia) //carteira informado na tela 
                   tt_integr_acr_liq_item_lote_3.tta_cod_finalid_econ           = "Corrente"
                  // tt_integr_acr_liq_item_lote_3.val_cotac_indic_econ           =  tit_acr.val_cotac_indic_econ
                   tt_integr_acr_liq_item_lote_3.tta_cod_indic_econ             = tit_acr.cod_indic_econ
                   tt_integr_acr_liq_item_lote_3.tta_val_tit_acr                = tit_acr.val_sdo_tit_acr
                   tt_integr_acr_liq_item_lote_3.tta_val_liquidac_tit_acr       = tt-arquivo-importado.valor_liquido
                   tt_integr_acr_liq_item_lote_3.tta_dat_cr_liquidac_tit_acr    = tt-param.data-liquidacao
                   tt_integr_acr_liq_item_lote_3.tta_dat_cr_liquidac_calc       = tt-param.data-liquidacao
                   tt_integr_acr_liq_item_lote_3.tta_dat_liquidac_tit_acr       = tt-param.data-liquidacao
                   tt_integr_acr_liq_item_lote_3.tta_log_gera_antecip           = no
                   tt_integr_acr_liq_item_lote_3.tta_log_gera_avdeb             = no
                   tt_integr_acr_liq_item_lote_3.tta_dat_vencto_avdeb           = ?
                   tt_integr_acr_liq_item_lote_3.tta_log_movto_comis_estordo    = no
                   tt_integr_acr_liq_item_lote_3.tta_ind_tip_item_liquidac_acr  = "Pagamento"
                   tt_integr_acr_liq_item_lote_3.tta_ind_tip_calc_juros         = "Compostos"
                   tt_integr_acr_liq_item_lote_3.ttv_rec_lote_liquidac_acr      = tt_integr_acr_liquidac_lote.ttv_rec_lote_liquidac_acr
                   tt_integr_acr_liq_item_lote_3.ttv_rec_item_lote_liquidac_acr = recid(tt_integr_acr_liq_item_lote_3).



             RUN prgfin/acr/acr901zf.py PERSISTENT SET v_hld_handle.

             RUN pi_main_code_api_integr_acr_liquidac_4 IN v_hld_handle (Input 1,
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
                                                                         Input table tt_integr_cambio_ems5).
            FIND FIRST tt_log_erros_import_liquidac NO-ERROR.
            IF AVAIL tt_log_erros_import_liquidac THEN DO:
                FOR EACH tt_log_erros_import_liquidac:
                CREATE tt-mensagens.
                ASSIGN tt-mensagens.cod-erro    = 1
                       tt-mensagens.des-erro    = "TITULO: " +  tt_log_erros_import_liquidac.tta_cod_tit_acr  + " | " + tt_log_erros_import_liquidac.ttv_des_msg_erro
                       tt-mensagens.l-erro      = YES.
                               
                 END.
            END.
            ELSE DO:
                CREATE tt-mensagens.
                ASSIGN tt-mensagens.cod-erro = 99  
                       tt-mensagens.titulo   = tit_acr.cod_tit_acr
                       tt-mensagens.parcela  = tit_acr.cod_parcela
                       tt-mensagens.valor    = tt-arquivo-importado.valor_liquido .
            END.
        
        END.
        ELSE DO:
            CREATE tt-mensagens.
            ASSIGN tt-mensagens.cod-erro = 1
                   tt-mensagens.des-erro = "TITULO: " + fGera_ID_DL(tt-arquivo-importado.authorization_number , string(tt-arquivo-importado.nsu)) +  " n∆o encontrado" .
        END.
    END.

    DELETE PROCEDURE v_hld_handle.
    
END PROCEDURE. //pi-gera-liquidacoes


RUN pi-finalizar in h-acomp.

RETURN "OK":U. //Return Final 
