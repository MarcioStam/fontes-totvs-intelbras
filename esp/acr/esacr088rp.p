/************************************************************************************************************
*      Programa .....: ESACR088RP                                                                           *
*      Data .........: 29 de Maio de 2023                                                                   *
*      Empresa ......: IDBA                                                                                 *
*      Cliente ......: Intelbras                                                                            *
*      Programador ..: Bruno Joaquim                                                                        *
*      Objetivo .....: Implantar antecipaá∆o para distribuiá∆o                                              *
*************************************************************************************************************
*  VERSAO       DATA        RESPONSAVEL              MOTIVO                                                 *
*  1.00.00.000  19/05/2023  Bruno Joaquim           Desenvolvimento                                         *
************************************************************************************************************/
/***********************************************************************************************************/
/***********************************************************************************************************/
/*************************** TEMP-TABLES *******************************************************************/
/***********************************************************************************************************/
{include/i-prgvrs.i esacr086rp 2.00.00.000} 

//{esp/acr/esacr086.i} //Include com definicao das temp-tables usadas nas API's do ACR 
{esp/acr/esacr086.i}.
{esp/acr/esacr086a.i}.

define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9":U
    field exemplo          as character format "x(30)":U
    index id ordem.

def temp-table tt-raw-digita
    field raw-digita       as raw.
 
define temp-table tt-param no-undo
    field destino                as integer
    field arquivo                as char format "x(35)"
    field usuario                as char format "x(12)"
    field data-exec              as date
    field hora-exec              as integer
    FIELD tp-execucao            AS INTEGER
    FIELD c-arq-import           AS CHARACTER.

                                         
DEF input parameter raw-param as raw no-undo.
DEF input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.


DEF TEMP-TABLE tt-linha NO-UNDO
    FIELD linha                 AS CHAR
    FIELD authorization_number  AS CHAR .

DEF TEMP-TABLE tt-arquivo NO-UNDO
    FIELD data_lancamento               AS CHAR FORMAT "x(25)"  
    FIELD numero_pedido                 AS CHAR FORMAT "x(18)"  
    FIELD nota_fiscal                   AS CHAR FORMAT "x(25)" 
    FIELD id_distribuidor               AS INT  FORMAT 999999
    FIELD distribuidor                  AS CHAR FORMAT "x(100)" 
    FIELD documento_distribuidor        AS CHAR FORMAT "x(18)"
    FIELD id_revenda                    AS INT  FORMAT 999999
    FIELD nome_revenda	                AS CHAR FORMAT "x(100)" 
    FIELD documento_revenda	            AS CHAR FORMAT "x(18)"  
    FIELD bruto	                        AS CHAR                            
    FIELD desconto                      AS CHAR                            
    FIELD credito_gerado                AS CHAR . 

DEF TEMP-TABLE tt-arquivo-importado NO-UNDO
    FIELD data_lancamento               AS CHAR FORMAT "x(25)"  
    FIELD numero_pedido                 AS CHAR FORMAT "x(18)"  
    FIELD nota_fiscal                   AS CHAR FORMAT "x(25)" 
    FIELD id_distribuidor               AS INT  FORMAT 999999 
    FIELD distribuidor                  AS CHAR FORMAT "x(100)" 
    FIELD documento_distribuidor        AS CHAR FORMAT "x(18)"
    FIELD id_revenda                    AS INT  FORMAT 999999
    FIELD nome_revenda	                AS CHAR FORMAT "x(100)" 
    FIELD documento_revenda	            AS CHAR FORMAT "x(18)"  
    FIELD bruto	                        AS DEC                            
    FIELD desconto                      AS DEC                            
    FIELD credito_gerado                AS DEC 
    FIELD saldo-sr                      AS DEC. 

DEF TEMP-TABLE tt-arquivo-importado-revenda NO-UNDO
    FIELD data_lancamento               AS CHAR FORMAT "x(25)"  
    FIELD numero_pedido                 AS CHAR FORMAT "x(18)"  
    FIELD nota_fiscal                   AS CHAR FORMAT "x(25)" 
    FIELD id_distribuidor               AS INT  FORMAT 999999 
    FIELD distribuidor                  AS CHAR FORMAT "x(100)" 
    FIELD documento_distribuidor        AS CHAR FORMAT "x(18)"
    FIELD id_revenda                    AS INT  FORMAT 999999
    FIELD nome_revenda	                AS CHAR FORMAT "x(100)" 
    FIELD documento_revenda	            AS CHAR FORMAT "x(18)"  
    FIELD bruto	                        AS DEC                            
    FIELD desconto                      AS DEC                            
    FIELD credito_gerado                AS DEC 
    FIELD saldo-sr                      AS DEC. 


DEFINE TEMP-TABLE tt-mensagens NO-UNDO
    FIELD cod-erro       AS INT
    FIELD info-erro      AS CHAR FORMAT "X(256)"
    FIELD cod-estab      LIKE tit_acr.cod_estab
    FIELD num-id-tit-acr LIKE tit_acr.num_id_tit_acr
    FIELD des-erro       AS CHARACTER FORMAT "x(256)"
    FIELD l-erro         AS LOGICAL.
    
/********************************************************************************************/
/*************************** Variaveis  *****************************************************/
/********************************************************************************************/
DEFINE VARIABLE l-erro          AS LOGICAL      NO-UNDO.
DEFINE VARIABLE h-acomp         AS HANDLE       NO-UNDO.
DEFINE VARIABLE c-cod-lucree    LIKE emitente.cod-emitente INITIAL 558942 .
DEFINE VARIABLE c-cod-refer     AS CHARACTER    NO-UNDO.
DEFINE VARIABLE h-acr900zi      AS HANDLE       NO-UNDO.
DEFINE VARIABLE id              AS INTEGER      NO-UNDO.
DEFINE VARIABLE seq             AS INTEGER      NO-UNDO.


/********************************************************************************************/
/*************************** INCLUDES  *****************************************************/
/********************************************************************************************/
/* include padr∆o para vari†veis de relat¢rio  */
{include/i-rpvar.i}
{include/i-rpout.i}
{include/i-rpcab.i}
{utp/ut-glob.i}
//{esp/es0018.i}  
{btb/btb912zb.i}
//{esp/acr/esacr086.i} //Include com definicao das temp-tables usadas nas API's do ACR 
//{esp/acr/esacr086.i}.

//{esp/acr/acr711zo.i}.
{esp/acr/acr711zo.i}.

/*--- Processamento Principal ---*/
IF  NOT VALID-HANDLE(h-acomp) THEN
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

RUN pi-inicializar IN h-acomp (INPUT "Importando Tabela").

RUN pi-importa-arquivo.

RUN pi-importa-acr.

RUN pi-gera-acertos-sd.

RUN pi-gera-acertos-sr.

PUT "------------------------------------------ IMPORTACAO TITULOS ACR ESPECIE SD --------------------------------------------------------" SKIP.
FOR EACH tt-mensagens WHERE tt-mensagens.cod-erro = 1 :
    PUT tt-mensagens.des-erro SKIP.
END.
PUT "------------------------------------------ ACERTOS TITULOS ACR ESPECIE SD -----------------------------------------------------------" SKIP.
FOR EACH tt-mensagens WHERE tt-mensagens.cod-erro = 2 :
    PUT tt-mensagens.des-erro SKIP.
END.
PUT "------------------------------------------ ACERTOS TITULOS ACR ESPECIE SR -----------------------------------------------------------" SKIP.
FOR EACH tt-mensagens WHERE tt-mensagens.cod-erro = 3 :
    PUT tt-mensagens.des-erro SKIP.
END.
PUT "------------------------------------------ Movimentos com saldos  -------------------------------------------------------------------" SKIP.
PUT "REVENDA" AT 1
    "Saldo sem acerto em SR" AT 80 SKIP.
PUT "-------------------------------------------------------------------------------------------------------------------------------------" SKIP.
FOR EACH tt-arquivo-importado-revenda WHERE tt-arquivo-importado-revenda.saldo-sr > 0 :
    PUT UNFORMATTED STRING(tt-arquivo-importado-revenda.id_revenda) + "-" + STRING(tt-arquivo-importado-revenda.nome_revenda) AT 1
                    STRING(tt-arquivo-importado-revenda.saldo-sr)  AT 80 SKIP.
END.

/*******************************************************************************************************************************************************/
/************************************************** PROCEDURES *****************************************************************************************/
/*******************************************************************************************************************************************************/
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
    //Consolida valores, caso exista mais de uma linha no arquivo para a mesma revenda

    FOR EACH tt-arquivo:
        FIND FIRST tt-arquivo-importado WHERE tt-arquivo-importado.documento_distribuidor   = tt-arquivo.documento_distribuidor NO-ERROR.
        IF NOT AVAIL tt-arquivo-importado THEN DO:
            CREATE tt-arquivo-importado.
            ASSIGN tt-arquivo-importado.data_lancamento          = tt-arquivo.data_lancamento       
                   tt-arquivo-importado.numero_pedido            = tt-arquivo.numero_pedido         
                   tt-arquivo-importado.nota_fiscal              = tt-arquivo.nota_fiscal           
                   tt-arquivo-importado.distribuidor             = tt-arquivo.distribuidor          
                   tt-arquivo-importado.documento_distribuidor   = tt-arquivo.documento_distribuidor
                   tt-arquivo-importado.nome_revenda             = tt-arquivo.nome_revenda          
                   tt-arquivo-importado.documento_revenda        = tt-arquivo.documento_revenda     
                   tt-arquivo-importado.bruto                    = DEC(REPLACE(tt-arquivo.bruto, ".", ","))
                   tt-arquivo-importado.saldo-sr                 = DEC(REPLACE(tt-arquivo.bruto, ".", ","))
                   tt-arquivo-importado.desconto                 = DEC(REPLACE(tt-arquivo.desconto, ".", ","))      
                   tt-arquivo-importado.credito_gerado           = DEC(REPLACE(tt-arquivo.credito_gerado , ".", ",")) 
                   tt-arquivo-importado.id_revenda               = tt-arquivo.id_revenda 
                   tt-arquivo-importado.id_distribuidor          = tt-arquivo.id_distribuidor .
        END.
        ELSE DO:
           ASSIGN tt-arquivo-importado.bruto                    = tt-arquivo-importado.bruto          + DEC(REPLACE(tt-arquivo.bruto, ".", ",")) 
                  tt-arquivo-importado.saldo-sr                 = tt-arquivo-importado.bruto           
                  tt-arquivo-importado.desconto                 = tt-arquivo-importado.desconto       + DEC(REPLACE(tt-arquivo.desconto, ".", ","))           
                  tt-arquivo-importado.credito_gerado           = tt-arquivo-importado.credito_gerado + DEC(REPLACE(tt-arquivo.credito_gerado , ".", ",")) .  
               
        END. 
    END.
  
    //Consolida valores quebrando por revenda
    FOR EACH tt-arquivo:
        FIND FIRST tt-arquivo-importado-revenda WHERE tt-arquivo-importado-revenda.documento_revenda = tt-arquivo.documento_revenda NO-ERROR.
        IF NOT AVAIL tt-arquivo-importado-revenda THEN DO:
            CREATE tt-arquivo-importado-revenda.
            ASSIGN tt-arquivo-importado-revenda.data_lancamento          = tt-arquivo.data_lancamento       
                   tt-arquivo-importado-revenda.numero_pedido            = tt-arquivo.numero_pedido         
                   tt-arquivo-importado-revenda.nota_fiscal              = tt-arquivo.nota_fiscal           
                   tt-arquivo-importado-revenda.distribuidor             = tt-arquivo.distribuidor          
                   tt-arquivo-importado-revenda.documento_distribuidor   = tt-arquivo.documento_distribuidor
                   tt-arquivo-importado-revenda.nome_revenda             = tt-arquivo.nome_revenda          
                   tt-arquivo-importado-revenda.documento_revenda        = tt-arquivo.documento_revenda     
                   tt-arquivo-importado-revenda.bruto                    = DEC(REPLACE(tt-arquivo.bruto, ".", ","))
                   tt-arquivo-importado-revenda.saldo-sr                 = DEC(REPLACE(tt-arquivo.bruto, ".", ","))
                   tt-arquivo-importado-revenda.desconto                 = DEC(REPLACE(tt-arquivo.desconto, ".", ","))      
                   tt-arquivo-importado-revenda.credito_gerado           = DEC(REPLACE(tt-arquivo.credito_gerado , ".", ",")) 
                   tt-arquivo-importado-revenda.id_revenda               = tt-arquivo.id_revenda 
                   tt-arquivo-importado-revenda.id_distribuidor          = tt-arquivo.id_distribuidor .
        END.
        ELSE DO:
           ASSIGN tt-arquivo-importado-revenda.bruto                    = tt-arquivo-importado-revenda.bruto          + DEC(REPLACE(tt-arquivo.bruto, ".", ",")) 
                  tt-arquivo-importado-revenda.saldo-sr                 = tt-arquivo-importado-revenda.bruto           .  
        END. 
    END.
END. //pi-importa-arquivo

PROCEDURE pi-importa-acr:
    //Aqui iremos criar os titulos dentro do ACR 

    EMPTY TEMP-TABLE tt_integr_acr_lote_impl.
    EMPTY TEMP-TABLE tt_integr_acr_item_lote_impl_8.
    EMPTY TEMP-TABLE tt_integr_acr_aprop_ctbl_pend.

    //DEFINE VAR id AS INT.
    DEFINE VAR i-parcela_original AS INT.
    DEFINE VAR i-parcela          AS INT.
    DEFINE VAR dt-vencto          AS DATE.

    //Gera o codigo de referencia que sera usado na implantacao do lote
    RUN pi-gera-referencia IN THIS-PROCEDURE (INPUT  "104",
                                              INPUT  ?,
                                              OUTPUT c-cod-refer).

    
    //Cria o lote que iremos usar pra implantar os titulos 
    CREATE tt_integr_acr_lote_impl. 
    ASSIGN tt_integr_acr_lote_impl.tta_cod_empresa          = "1"
           tt_integr_acr_lote_impl.tta_cod_estab            = "104"
           tt_integr_acr_lote_impl.tta_cod_refer            = c-cod-refer
           tt_integr_acr_lote_impl.tta_dat_transacao        = TODAY
           tt_integr_acr_lote_impl.tta_ind_tip_cobr_acr     = "Normal"
          // tt_integr_acr_lote_impl.tta_ind_orig_tit_acr     = "ACREMS50"
           tt_integr_acr_lote_impl.ttv_cod_empresa_ext      = ""
           tt_integr_acr_lote_impl.tta_cod_estab_ext        = ""
           tt_integr_acr_lote_impl.tta_cod_finalid_econ_ext = "".

    FOR EACH tt-arquivo-importado  WHERE tt-arquivo-importado.bruto > 0 :

            FIND FIRST emitente WHERE emitente.cgc = tt-arquivo-importado.documento_distribuidor NO-ERROR.
            IF NOT AVAIL emitente THEN DO:
                CREATE tt-mensagens.
                ASSIGN  tt-mensagens.cod-erro = 1
                        tt-mensagens.des-erro      = "Emitente n∆o encontrado para o documento do distribuidor informado: " + tt-arquivo-importado.documento_distribuidor .
                        tt-mensagens.l-erro        = YES.
            END.
            ELSE DO:
                ASSIGN id = id + 1 .
                CREATE tt_integr_acr_item_lote_impl_8.
                ASSIGN tt_integr_acr_item_lote_impl_8.ttv_rec_lote_impl_tit_acr      = RECID(tt_integr_acr_lote_impl)
                       tt_integr_acr_item_lote_impl_8.tta_num_seq_refer              = ID
                       tt_integr_acr_item_lote_impl_8.tta_ind_tip_espec_docto        = "antecipacao"
                       tt_integr_acr_item_lote_impl_8.tta_cod_portador               = ""
                       tt_integr_acr_item_lote_impl_8.tta_cod_cart_bcia              = ""
                       tt_integr_acr_item_lote_impl_8.tta_cod_espec_docto            = "SD"
                       tt_integr_acr_item_lote_impl_8.tta_cod_parcela                = SUBSTRING(STRING(YEAR(TODAY)),3) 
                       tt_integr_acr_item_lote_impl_8.tta_cod_tit_acr                = STRING(emitente.cod-emitente, "999999") + STRING(DAY(TODAY), "99") + STRING(MONTH(TODAY), "99") 
                       tt_integr_acr_item_lote_impl_8.tta_cdn_cliente                = emitente.cod-emitente 
                       tt_integr_acr_item_lote_impl_8.tta_cod_ser_docto              = "4"          
                       tt_integr_acr_item_lote_impl_8.tta_cod_finalid_econ_ext       = ""
                       tt_integr_acr_item_lote_impl_8.tta_cod_finalid_econ           = "corrente"
                       tt_integr_acr_item_lote_impl_8.tta_cod_finalid_econ_ext       = ""
                       tt_integr_acr_item_lote_impl_8.tta_cod_indic_econ             = "real"
                       tt_integr_acr_item_lote_impl_8.tta_cod_portad_ext             = ""
                       tt_integr_acr_item_lote_impl_8.tta_cdn_repres                 = 2090 //verificar com Thomaz
                       tt_integr_acr_item_lote_impl_8.tta_dat_vencto_tit_acr         = TODAY
                       tt_integr_acr_item_lote_impl_8.tta_dat_prev_liquidac          = ?
                       tt_integr_acr_item_lote_impl_8.tta_dat_desconto               = ?
                       tt_integr_acr_item_lote_impl_8.tta_dat_emis_docto             = TODAY  
                       tt_integr_acr_item_lote_impl_8.tta_cod_cond_cobr              = ""
                       tt_integr_acr_item_lote_impl_8.tta_val_tit_acr                = tt-arquivo-importado.bruto
                       tt_integr_acr_item_lote_impl_8.tta_val_desconto               = 0
                       tt_integr_acr_item_lote_impl_8.tta_val_perc_desc              = 0
                       tt_integr_acr_item_lote_impl_8.tta_val_perc_juros_dia_atraso  = 0
                       tt_integr_acr_item_lote_impl_8.tta_val_perc_multa_atraso      = 0
                       tt_integr_acr_item_lote_impl_8.tta_des_text_histor            = "" 
                       tt_integr_acr_item_lote_impl_8.tta_cod_instruc_bcia_1_movto   = ""
                       tt_integr_acr_item_lote_impl_8.tta_cod_instruc_bcia_2_movto   = ""
                       tt_integr_acr_item_lote_impl_8.tta_qtd_dias_carenc_juros_acr  = ? 
                       tt_integr_acr_item_lote_impl_8.tta_val_liq_tit_acr            = tt-arquivo-importado.bruto
                       tt_integr_acr_item_lote_impl_8.tta_cod_agenc_cobr_bcia        = ""
                       tt_integr_acr_item_lote_impl_8.tta_cod_tit_acr_bco            = ""
                       tt_integr_acr_item_lote_impl_8.tta_cod_cartcred               = ""
                       tt_integr_acr_item_lote_impl_8.tta_cod_mes_ano_valid_cartao   = ""
                       tt_integr_acr_item_lote_impl_8.tta_dat_compra_cartao_cr       = ? 
                       tt_integr_acr_item_lote_impl_8.ttv_cod_comprov_vda            = ""
                       tt_integr_acr_item_lote_impl_8.ttv_cod_autoriz_bco_emissor    = ""
                       tt_integr_acr_item_lote_impl_8.ttv_cod_lote_origin            = ""
                       tt_integr_acr_item_lote_impl_8.tta_cod_conces_telef           = ""
                       tt_integr_acr_item_lote_impl_8.tta_num_ddd_localid_conces     = 0
                       tt_integr_acr_item_lote_impl_8.tta_num_prefix_localid_conces  = 0
                       tt_integr_acr_item_lote_impl_8.tta_num_milhar_localid_conces  = 0
                       tt_integr_acr_item_lote_impl_8.tta_cod_banco                  = "" 
                       tt_integr_acr_item_lote_impl_8.tta_cod_agenc_bcia             = ""
                       tt_integr_acr_item_lote_impl_8.tta_cod_cta_corren_bco         = ""
                       tt_integr_acr_item_lote_impl_8.tta_cod_digito_cta_corren      = ""
                       tt_integr_acr_item_lote_impl_8.tta_val_cotac_indic_econ       = 1
                       tt_integr_acr_item_lote_impl_8.tta_ind_tip_calc_juros         = "Simples"
                       tt_integr_acr_item_lote_impl_8.ttv_rec_item_lote_impl_tit_acr = RECID(tt_integr_acr_item_lote_impl_8)
                       tt_integr_acr_item_lote_impl_8.tta_cod_motiv_movto_tit_acr    = ""
                       tt_integr_acr_item_lote_impl_8.tta_log_liquidac_autom         = NO
                       tt_integr_acr_item_lote_impl_8.ttv_num_parc_cartcred          = 0
                       tt_integr_acr_item_lote_impl_8.tta_cod_proces_export          = "" . 

                CREATE tt-mensagens.
                ASSIGN tt-mensagens.cod-erro = 1
                       tt-mensagens.des-erro = "Titulo Importado: " + STRING(tt_integr_acr_item_lote_impl_8.tta_cod_tit_acr) + " Parcela: " + STRING(tt_integr_acr_item_lote_impl_8.tta_cod_parcela) + "Especie: SD Valor: "  + STRING(tt_integr_acr_item_lote_impl_8.tta_val_tit_acr) .

            END.
    END.


    FOR EACH tt_integr_acr_item_lote_impl_8:
        CREATE tt_integr_acr_aprop_ctbl_pend.
        ASSIGN tt_integr_acr_aprop_ctbl_pend.ttv_rec_item_lote_impl_tit_acr = RECID(tt_integr_acr_item_lote_impl_8)
               tt_integr_acr_aprop_ctbl_pend.tta_cod_cta_ctbl               = "11910017"//c-cod-cta-transit
               tt_integr_acr_aprop_ctbl_pend.tta_cod_tip_fluxo_financ       = ""
               tt_integr_acr_aprop_ctbl_pend.tta_val_aprop_ctbl             = tt_integr_acr_item_lote_impl_8.tta_val_liq_tit_acr 
               tt_integr_acr_aprop_ctbl_pend.tta_cod_unid_negoc             = "ADM"
               tt_integr_acr_aprop_ctbl_pend.tta_cod_plano_cta_ctbl         = "padrao"
               tt_integr_acr_aprop_ctbl_pend.tta_cod_plano_ccusto           = ""
               tt_integr_acr_aprop_ctbl_pend.tta_cod_ccusto                 = "".
    END.
   //CREATE tt_integr_acr_aprop_desp_rec

    RELEASE tt_integr_acr_aprop_ctbl_pend.
    RELEASE tt_integr_acr_item_lote_impl_8.
    FIND FIRST tt_integr_acr_lote_impl NO-LOCK.
    
    
    IF  NOT VALID-HANDLE(h-acr900zi) THEN
        RUN prgfin\acr\acr900zi.py PERSISTENT SET h-acr900zi.
    
    IF  VALID-HANDLE(h-acr900zi) THEN
        RUN pi_main_code_integr_acr_new_9 IN h-acr900zi (INPUT 11,
                                                         INPUT "",  /*Matriz Trad Org Ext*/
                                                         INPUT YES, /*Log Atualiz Refer*/
                                                         INPUT NO,  /*Assume Data Emiss*/
                                                         INPUT TABLE tt_integr_acr_repres_comis_2,
                                                         INPUT-OUTPUT TABLE tt_integr_acr_item_lote_impl_8,
                                                         INPUT TABLE tt_integr_acr_aprop_relacto_2).
    
    IF  VALID-HANDLE(h-acr900zi) THEN
        DELETE PROCEDURE h-acr900zi.

    IF CAN-FIND(tt_log_erros_alter_tit_acr) THEN DO:
        FOR EACH tt_log_erros_atualiz: 
            CREATE tt-mensagens.
            ASSIGN tt-mensagens.cod-erro = 2
                   tt-mensagens.des-erro = tt_log_erros_alter_tit_acr.ttv_des_msg_erro + " -> " + tt_log_erros_alter_tit_acr.ttv_des_msg_ajuda
                   tt-mensagens.l-erro   = YES.
        END.
    END.


END PROCEDURE. //pi-importa-acr

PROCEDURE pi-gera-acertos-sd:
    
    DEFINE VAR l-referencia AS LOG.


    EMPTY temp-table  tt_alter_tit_acr_base_2.      
    EMPTY temp-table  tt_alter_tit_acr_rateio.      
    EMPTY temp-table  tt_alter_tit_acr_ped_vda.     
    EMPTY temp-table  tt_alter_tit_acr_comis.       
    EMPTY temp-table  tt_alter_tit_acr_cheq.        
    EMPTY temp-table  tt_alter_tit_acr_iva.         
    EMPTY temp-table  tt_alter_tit_acr_impto_retid_2.
    EMPTY temp-table  tt_alter_tit_acr_cobr_espec_2.
    EMPTY temp-table  tt_alter_tit_acr_rat_desp_rec.
    EMPTY temp-table  tt_log_erros_alter_tit_acr. 

    
    FOR EACH tt-arquivo-importado WHERE tt-arquivo-importado.bruto > 0 :

        ASSIGN l-referencia = FALSE .

        RUN pi-acompanhar IN h-acomp (INPUT "Gerando acertos SD").


        FIND FIRST emitente WHERE emitente.cgc = tt-arquivo-importado.documento_distribuidor NO-ERROR.

        RUN pi-gera-referencia IN THIS-PROCEDURE (INPUT  "104",
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

        FIND FIRST tit_acr WHERE tit_acr.cod_tit_acr        = STRING(emitente.cod-emitente, "999999") + STRING(DAY(TODAY), "99") + STRING(MONTH(TODAY), "99") 
                             AND tit_acr.cod_espec_docto    = "SD" 
                             AND tit_acr.cdn_cliente        = emitente.cod-emitente 
                             AND tit_acr.cod_estab          = '104' NO-ERROR.
        
        IF NOT AVAIL tit_acr THEN DO:
                             CREATE tt-mensagens.            
            ASSIGN tt-mensagens.cod-erro = 2
                   tt-mensagens.des-erro = "SD N∆o encontrada para ajuste, distribuidor:" + STRING(tt-arquivo-importado.documento_distribuidor) . 
        END.

        IF AVAIL tit_acr THEN DO:

                CREATE tt_alter_tit_acr_base_2.
                ASSIGN tt_alter_tit_acr_base_2.tta_cod_estab                   = tit_acr.cod_estab 
                       tt_alter_tit_acr_base_2.tta_num_id_tit_acr              = tit_acr.num_id_tit_acr 
                       tt_alter_tit_acr_base_2.tta_dat_transacao               = TODAY 
                       tt_alter_tit_acr_base_2.tta_cod_refer                   = c-cod-refer
                       tt_alter_tit_acr_base_2.ttv_cod_motiv_movto_tit_acr_imp = ? 
                       tt_alter_tit_acr_base_2.tta_val_sdo_tit_acr             = (tit_acr.val_sdo_tit_acr - tt-arquivo-importado.desconto ) 
                       tt_alter_tit_acr_base_2.ttv_cod_motiv_movto_tit_acr_alt = "" 
                       tt_alter_tit_acr_base_2.ttv_ind_motiv_acerto_val        = "Alteraá∆o" //"Acerto" //
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
                       tt_alter_tit_acr_base_2.tta_val_abat_tit_acr            = tt-arquivo-importado.bruto
                       tt_alter_tit_acr_base_2.tta_dat_desconto                = TODAY
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
                       tt_alter_tit_acr_rateio.ttv_ind_tip_rat_tit_acr         = "Alteraá∆o":U
                       tt_alter_tit_acr_rateio.tta_cod_refer                   = c-cod-refer
                       tt_alter_tit_acr_rateio.tta_cod_plano_cta_ctbl          = "padrao":U
                       tt_alter_tit_acr_rateio.tta_cod_cta_ctbl                = "51210017"
                       tt_alter_tit_acr_rateio.tta_num_seq_aprop_ctbl_pend_acr = seq  .
                       tt_alter_tit_acr_rateio.tta_val_aprop_ctbl              = tt-arquivo-importado.desconto . //val_sdo_tit_acr . 

                ASSIGN seq = seq +  1 .

                 CREATE tt-mensagens.            
                 ASSIGN tt-mensagens.cod-erro = 2
                        tt-mensagens.des-erro = "Acerto de valor gerado no titulo: " + STRING(tit_acr.cod_tit_acr) + " Parcela: " + string(tit_acr.cod_parcela) + " Especie : SD Valor: "  + STRING(tt-arquivo-importado.desconto) . 
        END.

    END.
    
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
    
    IF CAN-FIND(tt_log_erros_alter_tit_acr) THEN DO:
        FOR EACH tt_log_erros_alter_tit_acr:
            CREATE tt-mensagens.
            ASSIGN tt-mensagens.cod-erro = 2
                   tt-mensagens.des-erro = tt_log_erros_alter_tit_acr.ttv_des_msg_erro + " -> " + tt_log_erros_alter_tit_acr.ttv_des_msg_ajuda
                   tt-mensagens.l-erro   = YES.
        END.
    END.


    EMPTY temp-table  tt_alter_tit_acr_base_2.      
    EMPTY temp-table  tt_alter_tit_acr_rateio.      
    EMPTY temp-table  tt_alter_tit_acr_ped_vda.     
    EMPTY temp-table  tt_alter_tit_acr_comis.       
    EMPTY temp-table  tt_alter_tit_acr_cheq.        
    EMPTY temp-table  tt_alter_tit_acr_iva.         
    EMPTY temp-table  tt_alter_tit_acr_impto_retid_2.
    EMPTY temp-table  tt_alter_tit_acr_cobr_espec_2.
    EMPTY temp-table  tt_alter_tit_acr_rat_desp_rec.
    EMPTY temp-table  tt_log_erros_alter_tit_acr. 


END PROCEDURE. //pi-gera-acertos-sd

/*************************************************************************************************************************************************************/

PROCEDURE pi-gera-acertos-sr:
    DEFINE VAR iCont           AS INT.
    DEFINE VAR l-referencia    AS LOG.
    DEFINE VAR l-saiFora       AS LOG INITIAL YES .
    DEFINE VAR v-acerto        AS DEC.

    //Gera os acertos a menor nas SR importadas previamente pelo ESACR086
    FOR EACH tt-arquivo-importado-revenda WHERE tt-arquivo-importado-revenda.saldo-sr > 0  :

        //Entra no laco de repeticao ate zerar o saldo dentro das SR ou nao encontrar mais movimentos disponiveis
            RUN pi-acompanhar IN h-acomp (INPUT "Gerando acertos SR" + string(tt-arquivo-importado-revenda.id_revenda) + " " + STRING(iCont)).

            ASSIGN iCont = iCont + 1 .

            //ASSIGN tt-arquivo-importado.saldo-sr = 0 . 
            
            ASSIGN l-referencia = FALSE.

            FOR EACH tit_acr WHERE SUBSTRING(tit_acr.cod_tit_acr,1,6) = string(tt-arquivo-importado-revenda.id_revenda , "999999") 
                               AND tit_acr.cod_espec_docto            = "SR" 
                               AND tit_acr.cdn_cliente                = 558942 
                               AND tit_acr.cod_estab                  = '104' 
                               AND tit_acr.val_sdo_tit_acr            > 0 :
                /*
                EMPTY temp-table  tt_alter_tit_acr_base_2.      
                EMPTY temp-table  tt_alter_tit_acr_rateio.      
                EMPTY temp-table  tt_alter_tit_acr_ped_vda.     
                EMPTY temp-table  tt_alter_tit_acr_comis.       
                EMPTY temp-table  tt_alter_tit_acr_cheq.        
                EMPTY temp-table  tt_alter_tit_acr_iva.         
                EMPTY temp-table  tt_alter_tit_acr_impto_retid_2.
                EMPTY temp-table  tt_alter_tit_acr_cobr_espec_2.
                EMPTY temp-table  tt_alter_tit_acr_rat_desp_rec.
                EMPTY temp-table  tt_log_erros_alter_tit_acr.*/ 

                
                IF tit_acr.val_sdo_tit_acr >= tt-arquivo-importado-revenda.saldo-sr THEN DO:
                    ASSIGN v-acerto = tt-arquivo-importado-revenda.saldo-sr . 
                END.
                ELSE DO :
                   ASSIGN v-acerto = tit_acr.val_sdo_tit_acr .
                END.

                                 
                RUN pi-gera-referencia IN THIS-PROCEDURE (INPUT  "104",
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
                
                IF v-acerto > 0 THEN DO:
                    CREATE tt_alter_tit_acr_base_2.
                    ASSIGN tt_alter_tit_acr_base_2.tta_cod_estab                   = tit_acr.cod_estab 
                           tt_alter_tit_acr_base_2.tta_num_id_tit_acr              = tit_acr.num_id_tit_acr 
                           tt_alter_tit_acr_base_2.tta_dat_transacao               = TODAY 
                           tt_alter_tit_acr_base_2.tta_cod_refer                   = c-cod-refer
                           tt_alter_tit_acr_base_2.ttv_cod_motiv_movto_tit_acr_imp = ? 
                           tt_alter_tit_acr_base_2.tta_val_sdo_tit_acr             = (tit_acr.val_sdo_tit_acr - v-acerto ) 
                           tt_alter_tit_acr_base_2.ttv_cod_motiv_movto_tit_acr_alt = "" 
                           tt_alter_tit_acr_base_2.ttv_ind_motiv_acerto_val        = "Alteraá∆o" //"Acerto" //
                           tt_alter_tit_acr_base_2.tta_cod_portador                = tit_acr.cod_portador
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
                           tt_alter_tit_acr_base_2.tta_val_abat_tit_acr            = v-acerto
                           tt_alter_tit_acr_base_2.tta_dat_desconto                = TODAY
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
                           tt_alter_tit_acr_rateio.ttv_ind_tip_rat_tit_acr         = "Alteraá∆o":U
                           tt_alter_tit_acr_rateio.tta_cod_refer                   = c-cod-refer
                           tt_alter_tit_acr_rateio.tta_cod_plano_cta_ctbl          = "padrao":U
                           tt_alter_tit_acr_rateio.tta_cod_cta_ctbl                = "11910017"
                           tt_alter_tit_acr_rateio.tta_num_seq_aprop_ctbl_pend_acr = seq  
                           tt_alter_tit_acr_rateio.tta_val_aprop_ctbl              = v-acerto . 
                    
                    ASSIGN seq = seq +  1 .

                    ASSIGN tt-arquivo-importado-revenda.saldo-sr = tt-arquivo-importado-revenda.saldo-sr - v-acerto . 

                    IF tt-arquivo-importado-revenda.saldo-sr <= 0 THEN l-saiFora = YES .
                    
                    CREATE tt-mensagens.            
                    ASSIGN tt-mensagens.cod-erro = 3
                           tt-mensagens.des-erro = "Acerto de valor gerado no titulo: " + STRING(tit_acr.cod_tit_acr) + " Parcela: " + string(tit_acr.cod_parcela) + " Especie : SR Valor: "  + STRING(v-acerto) . 




    
                    /*
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
    
                    IF CAN-FIND(tt_log_erros_alter_tit_acr) THEN DO:
                        FOR EACH tt_log_erros_alter_tit_acr:
                            CREATE tt-mensagens.
                            ASSIGN tt-mensagens.cod-erro = 3
                                   tt-mensagens.des-erro = tt_log_erros_alter_tit_acr.ttv_des_msg_erro + " -> " + tt_log_erros_alter_tit_acr.ttv_des_msg_ajuda
                                   tt-mensagens.l-erro   = YES.
                        END.
                    END.
                    */
                    
                    /*
                    ELSE DO: //Se n∆o achar erros 
                        ASSIGN tt-arquivo-importado-revenda.saldo-sr = tt-arquivo-importado-revenda.saldo-sr - v-acerto . 
    
                        IF tt-arquivo-importado-revenda.saldo-sr <= 0 THEN l-saiFora = YES .
    
                        CREATE tt-mensagens.            
                        ASSIGN tt-mensagens.cod-erro = 3
                               tt-mensagens.des-erro = "Acerto de valor gerado no titulo: " + STRING(tit_acr.cod_tit_acr) + " Parcela: " + string(tit_acr.cod_parcela) + " Especie : SR Valor: "  + STRING(v-acerto) . 
    
                    END.
                    */
                END. //IF V-acerto 
            END. //For each 
    END.
    

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

    IF CAN-FIND(tt_log_erros_alter_tit_acr) THEN DO:
        FOR EACH tt_log_erros_alter_tit_acr:
            CREATE tt-mensagens.
            ASSIGN tt-mensagens.cod-erro = 3
                   tt-mensagens.des-erro = tt_log_erros_alter_tit_acr.ttv_des_msg_erro + " -> " + tt_log_erros_alter_tit_acr.ttv_des_msg_ajuda
                   tt-mensagens.l-erro   = YES.
        END.
    END.
    
    EMPTY temp-table  tt_alter_tit_acr_base_2.      
    EMPTY temp-table  tt_alter_tit_acr_rateio.      
    EMPTY temp-table  tt_alter_tit_acr_ped_vda.     
    EMPTY temp-table  tt_alter_tit_acr_comis.       
    EMPTY temp-table  tt_alter_tit_acr_cheq.        
    EMPTY temp-table  tt_alter_tit_acr_iva.         
    EMPTY temp-table  tt_alter_tit_acr_impto_retid_2.
    EMPTY temp-table  tt_alter_tit_acr_cobr_espec_2.
    EMPTY temp-table  tt_alter_tit_acr_rat_desp_rec.
    EMPTY temp-table  tt_log_erros_alter_tit_acr. 


END PROCEDURE. //pi-gera-acertos-sr

RUN pi-finalizar in h-acomp.

RETURN "OK":U. //Return Final 
