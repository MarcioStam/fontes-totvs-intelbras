/************************************************************************************************************
*      Programa .....: ESACR089RP                                                                           *
*      Data .........: 29 de Maio de 2023                                                                   *
*      Empresa ......: IDBA                                                                                 *
*      Cliente ......: Intelbras                                                                            *
*      Programador ..: Bruno Joaquim                                                                        *
*      Objetivo .....: Liquida‡äes de titulos com as antecipa‡äes geradas pela integracao com a lucree      *
*************************************************************************************************************
*  VERSAO       DATA        RESPONSAVEL              MOTIVO                                                 *
*  1.00.00.000  02/06/2023  Bruno Joaquim           Desenvolvimento                                         *
************************************************************************************************************/
/*************************** TEMP-TABLES *******************************************************************/
/***********************************************************************************************************/
/**************************** Includes ******************************************/
{include/i-prgvrs.i esacr090rp 1.00.00.000} 

{esp\acr\esacr086.i}.
{esp\acr\esacr086a.i}.

{utp/ut-glob.i}.
{utp/utapi019.i}.


/*************************** Temp Tables **************************************/

DEFINE TEMP-TABLE tt-param NO-UNDO
   FIELD destino     AS INTEGER
   FIELD arquivo     AS CHARACTER FORMAT "x(35)":U
   FIELD usuario     AS CHARACTER FORMAT "x(12)":U
   FIELD data-exec   AS DATE
   FIELD hora-exec   AS INTEGER
   FIELD diretorio   AS CHARACTER
   FIELD tp-execucao AS INT.

DEFINE TEMP-TABLE tt-mensagens NO-UNDO
    FIELD cod-erro AS INT
    FIELD des-erro AS CHAR FORMAT "x(256)"
    FIELD l-erro   AS LOG .

DEFINE TEMP-TABLE tt-de-para-abatimentos NO-UNDO
    FIELD de_cod_estab         LIKE tit_acr.cod_estab
    FIELD de_tit_acr           LIKE tit_acr.cod_tit_acr 
    FIELD de_parcela           LIKE tit_acr.cod_parcela
    FIELD de_cdn_cliente       LIKE tit_acr.cdn_cliente     
    FIELD de_cod_espec_docto   LIKE tit_acr.cod_espec_docto
    FIELD para_tit_acr         LIKE tit_acr.cod_tit_acr 
    FIELD para_parcela         LIKE tit_acr.cod_parcela
    FIELD para_cdn_cliente     LIKE tit_acr.cdn_cliente     
    FIELD para_cod_espec_docto LIKE tit_acr.cod_espec_docto 
    FIELD valor                AS DEC .

DEFINE TEMP-TABLE tt-titulos-grupo-economico
    FIELD cod-emitente  LIKE emitente.cod-emitente
    FIELD cod_tit_acr   LIKE tit_acr.cod_tit_acr
    FIELD cod_parcela   LIKE tit_acr.cod_parcela
    FIELD cod_ser_docto LIKE tit_acr.cod_ser_docto
    FIELD cdn_cliente   LIKE tit_acr.cdn_cliente
    FIELD cod_estab     LIKE tit_acr.cod_estab
    FIELD data_emissao  AS DATE
    FIELD saldo         AS DEC.

DEF TEMP-TABLE tt-titulos-antecipacao-abat LIKE tt-titulos-grupo-economico.

DEF TEMP-TABLE tt-tit-acr-1 LIKE tit_acr
    index idxEmitente cdn_cliente.

define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9":U
    field exemplo          as character format "x(30)":U
    index id ordem.

def temp-table tt-raw-digita
    field raw-digita       as raw.
/************************* Parametros ****************************************/
DEF input parameter raw-param as raw no-undo.
DEF input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

/************************* Variaveis *****************************************/
DEFINE VARIABLE h-acomp         AS HANDLE       NO-UNDO.
DEFINE VARIABLE c-cod-refer     AS CHARACTER    NO-UNDO.
DEFINE VARIABLE v_hld_handle    AS HANDLE       NO-UNDO.
DEFINE BUFFER   b1-tit_acr FOR tit_acr .
DEFINE BUFFER   b2-tit_acr FOR tit_acr .
DEFINE BUFFER   b1-emitente FOR emitente .



{include/i-rpvar.i}.
{include/i-rpout.i}.
{include/i-rpcab.i}.

/************************** Processamento Principal *************************/


IF  NOT VALID-HANDLE(h-acomp) THEN
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
RUN pi-inicializar IN h-acomp (INPUT "Liquidacao Titulos Especie DM").

RUN pi-gera-liquidacoes.

PUT "ESACR090RP " SKIP. 
PUT "---------------------------------------------------------------------------------------------------------------------" SKIP.
PUT "LIQUIDACOES GERADAS -------------------------------------------------------------------------------------------------" SKIP. 
PUT "---------------------------------------------------------------------------------------------------------------------" SKIP.
PUT "COD ESTAB"    AT 1
    "TITULO"       AT 12
    "PARCELA"      AT 25
    "ESPECIE"      AT 35
    "COD CLIENTE"  AT 45
    "TITULO"       AT 60  
    "PARCELA"      AT 75 
    "ESPECIE"      AT 85 
    "VALOR"        AT 95 SKIP.
PUT "---------------------------------------------------------------------------------------------------------------------" SKIP.
FOR EACH tt-de-para-abatimentos:
    PUT tt-de-para-abatimentos.de_cod_estab         AT 1
        tt-de-para-abatimentos.de_tit_acr           AT 12          
        tt-de-para-abatimentos.de_parcela           AT 25
        tt-de-para-abatimentos.de_cod_espec_docto   AT 35
        tt-de-para-abatimentos.de_cdn_cliente       AT 45
        tt-de-para-abatimentos.para_tit_acr         AT 60
        tt-de-para-abatimentos.para_parcela         AT 75 
        tt-de-para-abatimentos.para_cod_espec_docto AT 85
        tt-de-para-abatimentos.valor                AT 95 SKIP.
END.
PUT "---------------------------------------------------------------------------------------------------------------------" SKIP.
PUT "MENSAGENS DE ERRO ---------------------------------------------------------------------------------------------------" SKIP.
PUT "---------------------------------------------------------------------------------------------------------------------" SKIP.

FOR EACH tt-mensagens WHERE tt-mensagens.cod-erro = 1:
    PUT tt-mensagens.des-erro SKIP.
END.


PROCEDURE pi-gera-liquidacoes:

        DEF VAR saldo_original AS DEC.
        DEF VAR saldo_sd       AS DEC.
        DEF VAR dif_saldo_sd   AS DEC.
        DEFINE VAR l-referencia AS LOG.
        
        //Filtra todas as SD existentes com saldo em aberto
        FOR EACH b2-tit_acr WHERE b2-tit_acr.cod_espec_docto = "SD" AND val_sdo_tit_acr > 0 :  
            RUN pi-acompanhar IN h-acomp (INPUT "Varrendo SD's para liquidacao: TITULO: " + STRING(b2-tit_acr.cod_tit_acr) + "Parcela: " + STRING(b2-tit_acr.cod_parcela) ).
            CREATE tt-tit-acr-1.
            RAW-TRANSFER b2-tit_acr TO tt-tit-acr-1.   
        END.

        //Filtraremos titulos nas seguintes condi‡äes
        // Esp‚cie DM e portador 9900, condi‡Æo 680-Lucree;
        FOR EACH tit_acr WHERE tit_acr.cod_espec_docto = "DM" 
                           AND tit_acr.cod_portad  = "9900" 
                           AND tit_acr.val_sdo_tit_acr > 0 : 
                           //AND  tit_acr.cod_tit_acr = "TESTEABC": 

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
            EMPTY TEMP-TABLE tt-titulos-grupo-economico.
            EMPTY TEMP-TABLE tt_integr_acr_abat_antecip.
            EMPTY TEMP-TABLE tt-titulos-grupo-economico.
            EMPTY TEMP-TABLE tt-titulos-antecipacao-abat.

            ASSIGN saldo_sd = 0.

            //Busca matriz de grupo economico do cliente depois cria temp-table para avaliar qual o titulo mais antigo
            FOR EACH int-emitente-canal WHERE int-emitente-canal.cod-emitente = tit_acr.cdn_cliente :
                
                FIND FIRST emitente WHERE emitente.cod-emitente = int-emitente-canal.cod-emitente-matriz.
            
                FOR EACH b1-emitente WHERE b1-emitente.nome-matriz = emitente.nome-matriz:
                    //DISP b1-emitente.cod-emitente WITH 1 COL WIDTH 300.

                    FOR EACH tt-tit-acr-1 WHERE tt-tit-acr-1.cdn_cliente = b1-emitente.cod-emitente : 

                        RUN pi-acompanhar IN h-acomp (INPUT "Varrendo SD's para liquidacao: TITULO: " + STRING(tt-tit-acr-1.cod_tit_acr) + "Parcela: " + STRING(tt-tit-acr-1.cod_parcela) ).

                        CREATE tt-titulos-grupo-economico.
                        ASSIGN tt-titulos-grupo-economico.cod-emitente  = b1-emitente.cod-emitente 
                               tt-titulos-grupo-economico.cod_tit_acr   = tt-tit-acr-1.cod_tit_acr
                               tt-titulos-grupo-economico.cod_parcela   = tt-tit-acr-1.cod_parcela
                               tt-titulos-grupo-economico.data_emissao  = tt-tit-acr-1.dat_emis_docto 
                               tt-titulos-grupo-economico.saldo         = tt-tit-acr-1.val_sdo_tit_acr 
                               tt-titulos-grupo-economico.cod_ser_docto = tt-tit-acr-1.cod_ser_docto
                               tt-titulos-grupo-economico.cdn_cliente   = tt-tit-acr-1.cdn_cliente
                               tt-titulos-grupo-economico.cod_estab     = tt-tit-acr-1.cod_estab .
                    END.
                END.
            END.

            //Depois de encontrar as SD's correspondentes a matriz economica vamos somar os valores e checar se ‚ o suficiente para realizar o abatimento do titulo
            FOR EACH tt-titulos-grupo-economico BY tt-titulos-grupo-economico.data_emissao :
                
                IF saldo_sd >= tit_acr.val_sdo_tit_acr THEN NEXT. 
                ELSE DO:
                    CREATE tt-titulos-antecipacao-abat.
                    RAW-TRANSFER tt-titulos-grupo-economico TO tt-titulos-antecipacao-abat. 
                    ASSIGN saldo_sd = saldo_sd +  tt-titulos-grupo-economico.saldo.
                END.
                
            END.
            
            //Se a soma de todos os titulos ainda nao for maior ou igual ao valor da DM, cria o log para avisar o usuario e passa para o proximo registro
            IF saldo_sd < tit_acr.val_sdo_tit_acr THEN DO:
                CREATE tt-mensagens.
                ASSIGN tt-mensagens.cod-erro = 1 
                       tt-mensagens.des-erro = "Saldo insuficiente de Titulos Especie SD para gerar abatimento no titulo DM: " + string(tit_acr.cod_tit_acr) + " parcela :" + STRING(tit_acr.cod_parcela) + " Saldo esperado: R$" +  STRING(tit_acr.val_sdo_tit_acr) + " Saldo Encontrado: R$" + STRING(saldo_sd) . 
                NEXT.
            END.
            //Caso o valor das SD somadas ultrapasse o valor da DM, iremos fazer o ajuste
            IF saldo_sd >= tit_acr.val_sdo_tit_acr THEN DO:

               ASSIGN dif_saldo_sd = saldo_sd - tit_acr.val_sdo_tit_acr.

               FIND LAST tt-titulos-antecipacao-abat.
               ASSIGN tt-titulos-antecipacao-abat.saldo =  tt-titulos-antecipacao-abat.saldo - dif_saldo_sd .

            END.

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

            CREATE tt_integr_acr_liquidac_lote.
            ASSIGN tt_integr_acr_liquidac_lote.tta_cod_empresa                 = '1'
                   tt_integr_acr_liquidac_lote.tta_cod_estab_refer             = '104'
                   tt_integr_acr_liquidac_lote.tta_cod_usuario                 = tt-param.usuario
                   tt_integr_acr_liquidac_lote.tta_dat_gerac_lote_liquidac     = TODAY 
                   tt_integr_acr_liquidac_lote.tta_dat_transacao               = TODAY 
                   tt_integr_acr_liquidac_lote.tta_ind_tip_liquidac_acr        = "lote"
                   tt_integr_acr_liquidac_lote.tta_ind_sit_lote_liquidac_acr   = "Em digita‡Æo"
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
                   tt_integr_acr_liq_item_lote_3.tta_cod_portador               = tit_acr.cod_portador 
                   tt_integr_acr_liq_item_lote_3.tta_cod_cart_bcia              = tit_acr.cod_cart_bcia
                   tt_integr_acr_liq_item_lote_3.tta_cod_finalid_econ           = "Corrente"
                  // tt_integr_acr_liq_item_lote_3.val_cotac_indic_econ           =  tit_acr.val_cotac_indic_econ
                   tt_integr_acr_liq_item_lote_3.tta_cod_indic_econ             = tit_acr.cod_indic_econ
                   tt_integr_acr_liq_item_lote_3.tta_val_tit_acr                = tit_acr.val_sdo_tit_acr
                   tt_integr_acr_liq_item_lote_3.tta_val_liquidac_tit_acr       = tit_acr.val_sdo_tit_acr //Liquida por completo
                   tt_integr_acr_liq_item_lote_3.tta_dat_cr_liquidac_tit_acr    = today 
                   tt_integr_acr_liq_item_lote_3.tta_dat_cr_liquidac_calc       = today 
                   tt_integr_acr_liq_item_lote_3.tta_dat_liquidac_tit_acr       = today 
                   tt_integr_acr_liq_item_lote_3.tta_log_gera_antecip           = no
                   tt_integr_acr_liq_item_lote_3.tta_log_gera_avdeb             = no
                   tt_integr_acr_liq_item_lote_3.tta_dat_vencto_avdeb           = ?
                   tt_integr_acr_liq_item_lote_3.tta_log_movto_comis_estordo    = no
                   tt_integr_acr_liq_item_lote_3.tta_ind_tip_item_liquidac_acr  = "Pagamento"
                   tt_integr_acr_liq_item_lote_3.tta_ind_tip_calc_juros         = "Compostos"
                   tt_integr_acr_liq_item_lote_3.ttv_rec_lote_liquidac_acr      = tt_integr_acr_liquidac_lote.ttv_rec_lote_liquidac_acr
                   tt_integr_acr_liq_item_lote_3.ttv_rec_item_lote_liquidac_acr = recid(tt_integr_acr_liq_item_lote_3).
            
            //Vincula liquidacao com os titulos de credito pre selecionados a cima
            FOR EACH tt-titulos-antecipacao-abat:
                CREATE tt_integr_acr_abat_antecip.
                ASSIGN tt_integr_acr_abat_antecip.ttv_rec_item_lote_impl_tit_acr   = RECID(tt_integr_acr_liq_item_lote_3)
                       tt_integr_acr_abat_antecip.ttv_rec_abat_antecip_acr         = RECID(tt_integr_acr_abat_antecip)
                       tt_integr_acr_abat_antecip.tta_cod_estab                    = tt-titulos-antecipacao-abat.cod_estab 
                      // tt_integr_acr_abat_antecip.tta_cod_estab_ext                = 
                       tt_integr_acr_abat_antecip.tta_cod_espec_docto              = "SD"
                       tt_integr_acr_abat_antecip.tta_cod_ser_docto                = tt-titulos-antecipacao-abat.cod_ser_docto
                       tt_integr_acr_abat_antecip.tta_cod_tit_acr                  = tt-titulos-antecipacao-abat.cod_tit_acr
                       tt_integr_acr_abat_antecip.tta_cod_parcela                  = tt-titulos-antecipacao-abat.cod_parcela
                       tt_integr_acr_abat_antecip.tta_val_abtdo_antecip_tit_abat   = tt-titulos-antecipacao-abat.saldo .
            END.

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
           // IF CAN-FIND (tt_log_erros_import_liquidac) THEN DO:
                FOR EACH tt_log_erros_import_liquidac:
                CREATE tt-mensagens.
                ASSIGN tt-mensagens.cod-erro    = 1
                       tt-mensagens.des-erro    = "TITULO: " +  tt_log_erros_import_liquidac.tta_cod_tit_acr  + " | " + tt_log_erros_import_liquidac.ttv_des_msg_erro
                       tt-mensagens.l-erro      = YES.
                               
                 END.
            //END.
            //ELSE DO:
                FOR EACH tt-titulos-antecipacao-abat:
                    CREATE tt-de-para-abatimentos.
                    ASSIGN tt-de-para-abatimentos.de_cod_estab          = tit_acr.cod_estab 
                           tt-de-para-abatimentos.de_tit_acr            = tit_acr.cod_tit_acr            
                           tt-de-para-abatimentos.de_parcela            = tit_acr.cod_parcela         
                           tt-de-para-abatimentos.de_cdn_cliente        = tit_acr.cdn_cliente     
                           tt-de-para-abatimentos.de_cod_espec_docto    = tit_acr.cod_espec_docto 
                           tt-de-para-abatimentos.para_tit_acr          = tt-titulos-antecipacao-abat.cod_tit_acr         
                           tt-de-para-abatimentos.para_parcela          = tt-titulos-antecipacao-abat.cod_parcela         
                           tt-de-para-abatimentos.para_cdn_cliente      = tt-titulos-antecipacao-abat.cdn_cliente     
                           tt-de-para-abatimentos.para_cod_espec_docto  = "SD" 
                           tt-de-para-abatimentos.valor                 = tt-titulos-antecipacao-abat.saldo .
                END.
            //END.
             IF VALID-HANDLE (v_hld_handle) THEN DELETE OBJECT v_hld_handle.
        END.

END PROCEDURE. //pi-gera-liquidacoes

run pi-finalizar in h-acomp.

RETURN "OK":U.



