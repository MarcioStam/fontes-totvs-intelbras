/************************************************************************************************************
*      Programa .....: ESACR086RP                                                                           *
*      Data .........: 29 de Maio de 2023                                                                   *
*      Empresa ......: IDBA                                                                                 *
*      Cliente ......: Intelbras                                                                            *
*      Programador ..: Bruno Joaquim                                                                        *
*      Objetivo .....: Importacao titulos Lucree para o ACR                                                 *
*************************************************************************************************************
*  VERSAO       DATA        RESPONSAVEL              MOTIVO                                                 *
*  1.00.00.000  19/05/2023  Bruno Joaquim           Desenvolvimento                                         *
************************************************************************************************************/
/***********************************************************************************************************/
/***********************************************************************************************************/
/*************************** TEMP-TABLES *******************************************************************/
/***********************************************************************************************************/
{include/i-prgvrs.i esacr086rp 2.00.00.000} 

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

DEF TEMP-TABLE tt-arquivo
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


DEF TEMP-TABLE tt-arquivo-importado
    FIELD authorization_number  AS CHAR
    FIELD acquirer_nsu          AS INT  FORMAT "9999999999"
    FIELD participante          AS CHAR FORMAT "X(100)"
    FIELD doc_participante	    AS CHAR FORMAT "X(12)"
    FIELD ID_Revendedor	        AS INT
    FIELD Nome_Lojista          AS CHAR FORMAT "X(100)"
    FIELD Doc_Lojista           AS CHAR
    FIELD parcela	            AS INT FORMAT "99"
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
    FIELD id_titulo             AS CHAR FORMAT "x(20)".

DEFINE TEMP-TABLE tt-lista-consolidada
     FIELD acquirer_nsu         AS INT
     FIELD doc_participante	    AS CHAR FORMAT "X(12)"
     FIELD ID_Revendedor	    AS INT
     FIELD val_venda            AS DEC
     FIELD valorbruto           AS DEC
     FIELD valordesconto        AS DEC
     FIELD valorliquido         AS DEC 
     FIELD id_titulo            AS CHAR FORMAT "X(20)".

DEFINE TEMP-TABLE tt-mensagens NO-UNDO
    FIELD info-erro      AS CHAR FORMAT "X(256)"
    FIELD cod-estab      LIKE tit_acr.cod_estab
    FIELD num-id-tit-acr LIKE tit_acr.num_id_tit_acr
    FIELD des-erro       AS CHARACTER FORMAT "x(256)"
    FIELD l-erro         AS LOGICAL.
    
/********************************************************************************************/
/*************************** Variaveis  *****************************************************/
/********************************************************************************************/
DEFINE VARIABLE h-acomp         AS HANDLE       NO-UNDO.
DEFINE VARIABLE i-linha         AS INTEGER      NO-UNDO.
DEFINE VARIABLE c-cod-lucree    LIKE emitente.cod-emitente.
DEFINE VARIABLE c-cod-refer     AS CHARACTER    NO-UNDO.
DEFINE VARIABLE h-acr900zi      AS HANDLE       NO-UNDO.
DEFINE VARIABLE id              AS INTEGER      NO-UNDO.
DEFINE BUFFER b1-tt-arquivo     FOR tt-arquivo.

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
{esp/acr/esacr086.i}.
{esp/acr/esacr086a.i}.


/*--- Processamento Principal ---*/
IF  NOT VALID-HANDLE(h-acomp) THEN
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

RUN pi-inicializar IN h-acomp (INPUT "Importando Tabela").
                                               
RUN pi-finalizar in h-acomp.

RUN pi-importa-arquivo.

    //Gera o codigo de referencia que sera usado na implantacao do lote
RUN pi-gera-referencia IN THIS-PROCEDURE (INPUT  "101",
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

RUN pi-gera-sr.

RUN pi-gera-dl.

PUT "---------------------------------------------------------------------------------------------------------------------" SKIP  .
PUT "ESACR086 - Importacao de titulos ACR - Lucree                                                                        " SKIP  .
PUT "---------------------------------------------------------------------------------------------------------------------" SKIP  .
PUT "TITULOS ESPECIE SR GERADOS:" SKIP 
    "REFERENCIA: " c-cod-refer    SKIP .
PUT "---------------------------------------------------------------------------------------------------------------------" SKIP .
PUT "TITULO" AT 1
    "NSU"    AT 22
    "DOC PARTICIPANTE" AT 42
    "ID REVENDEDOR"    AT 62
    "VALOR LIQUIDO"    AT 82 SKIP.
PUT "---------------------------------------------------------------------------------------------------------------------" SKIP .
FOR EACH tt-lista-consolidada:
    PUT tt-lista-consolidada.id_titulo                FORMAT "X(20)"  AT 1        
        STRING(tt-lista-consolidada.acquirer_nsu)     FORMAT "X(20)"  AT 22    
        STRING(tt-lista-consolidada.doc_participante) FORMAT "X(20)"  AT 42 
        STRING(tt-lista-consolidada.ID_Revendedor)    FORMAT "X(20)"  AT 62  
        STRING(tt-lista-consolidada.valorliquido)     FORMAT "X(20)"  AT 82  SKIP.
END.
PUT "---------------------------------------------------------------------------------------------------------------------" SKIP  .
PUT "TITULOS ESPECIE DL GERADOS:" SKIP 
    "REFERENCIA: " c-cod-refer    SKIP .
PUT "---------------------------------------------------------------------------------------------------------------------" SKIP .
PUT "TITULO" AT 1
    "NSU"    AT 22
    "DOC PARTICIPANTE" AT 42
    "ID REVENDEDOR"    AT 62
    "VALOR LIQUIDO"      AT 82 SKIP.

PUT "---------------------------------------------------------------------------------------------------------------------" SKIP .
FOR EACH tt-arquivo-importado:
    PUT STRING(tt-arquivo-importado.acquirer_nsu)     FORMAT "X(20)"  AT 1        
        STRING(tt-arquivo-importado.acquirer_nsu)     FORMAT "X(20)"  AT 22    
        STRING(tt-arquivo-importado.doc_participante) FORMAT "X(20)"  AT 42 
        STRING(tt-arquivo-importado.ID_Revendedor)    FORMAT "X(20)"  AT 62  
        STRING(tt-arquivo-importado.valorliquido)     FORMAT "X(20)"  AT 82  SKIP.
END.
PUT "------------------------------------------ MENSAGENS DE ERRO --------------------------------------------------------" SKIP.

FOR EACH tt-mensagens:
    PUT tt-mensagens.des-erro SKIP.
END.

/********************************* Procedures **************************************************************************/


PROCEDURE pi-importa-arquivo:
    DEFINE VARIABLE ncont  AS INT  NO-UNDO INITIAL 1.
    DEFINE VARIABLE xlinha AS CHAR NO-UNDO.
    
    INPUT FROM VALUE(tt-param.c-arq-import).
    IMPORT UNFORMATTED xlinha.
    REPEAT:
        CREATE tt-arquivo.        IMPORT delimiter ";" tt-arquivo.        assign ncont = ncont + 1.
    END.
    INPUT CLOSE.
//Reconstr¢i a temp-table formatando os campos decimais 
// Vamos considerar apenas as linhas que possuam split de valor 0.7, s∆o estas que remetem ao crÇdito que deve ser gerado dentro do sistema
// Utilizamos o buffer para buscar o id do revendedor correto, visto que as linhas com split = 0.7 possuem como ID_Revendedor os dados da intelbras 
// Ap¢s isso Ç gerado a consolidaá∆o dos valores para criaá∆o da SR 
    DEF VAR i-parcela AS INT INITIAL 1 .
    DEF VAR dt-prev-pgto AS DATE.
     
    ASSIGN dt-prev-pgto = TODAY + 30 .
    
    FOR EACH tt-arquivo 
        WHERE tt-arquivo.split_percentual = "0.7" BREAK BY tt-arquivo.authorization_number :

        IF FIRST-OF(tt-arquivo.authorization_number) THEN DO: 
            ASSIGN i-parcela = 1 .
            ASSIGN dt-prev-pgto =  TODAY + 30 .
        END.
        

        FIND LAST tt-arquivo-importado WHERE tt-arquivo-importado.authorization_number = tt-arquivo.authorization_number NO-ERROR.
        IF NOT AVAIL tt-arquivo-importado THEN DO:
            
            FIND FIRST b1-tt-arquivo WHERE b1-tt-arquivo.acquirer_nsu = tt-arquivo.acquirer_nsu 
                                        AND b1-tt-arquivo.ID_Revendedor <> 18938 NO-ERROR.
    
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
                   tt-arquivo-importado.c-status             = tt-arquivo.c-status            
                   tt-arquivo-importado.modalidade           = tt-arquivo.modalidade          
                   tt-arquivo-importado.bandeira             = tt-arquivo.bandeira            
                   tt-arquivo-importado.c-terminal           = tt-arquivo.c-terminal          
                   tt-arquivo-importado.dataprevista         = dt-prev-pgto       
                   tt-arquivo-importado.datapagamento        = tt-arquivo.datapagamento       
                   tt-arquivo-importado.dataautorizacao      = tt-arquivo.dataautorizacao     .
            
            ASSIGN i-parcela = i-parcela + 1 .
            ASSIGN dt-prev-pgto = dt-prev-pgto + 30 .

        END.
        ELSE DO:

            FIND FIRST b1-tt-arquivo WHERE b1-tt-arquivo.acquirer_nsu = tt-arquivo.acquirer_nsu 
                                        AND b1-tt-arquivo.ID_Revendedor <> 18938 NO-ERROR.

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
                   tt-arquivo-importado.c-status             = tt-arquivo.c-status            
                   tt-arquivo-importado.modalidade           = tt-arquivo.modalidade          
                   tt-arquivo-importado.bandeira             = tt-arquivo.bandeira            
                   tt-arquivo-importado.c-terminal           = tt-arquivo.c-terminal          
                   tt-arquivo-importado.dataprevista         = dt-prev-pgto        
                   tt-arquivo-importado.datapagamento        = tt-arquivo.datapagamento       
                   tt-arquivo-importado.dataautorizacao      = tt-arquivo.dataautorizacao  .

            ASSIGN i-parcela = i-parcela + 1 .
            ASSIGN dt-prev-pgto = dt-prev-pgto + 30 .

        END.
    END.

    RUN pi-consolida-lista .

END. //pi-importa-arquivo

PROCEDURE pi-consolida-lista:
    //Realiza a consolidacao da lista pelo campo acquirer_nsu / posteriormente sendo usada para a geracao dos titulos especie SR

    DEFINE VAR i-revendedor AS INT.

    FOR EACH tt-arquivo-importado :

        ASSIGN i-revendedor = int(tt-arquivo-importado.ID_Revendedor) .
        
        FIND FIRST tt-lista-consolidada WHERE tt-arquivo-importado.ID_Revendedor = tt-lista-consolidada.ID_Revendedor NO-ERROR.
        IF NOT AVAIL tt-lista-consolidada THEN DO:
            CREATE tt-lista-consolidada.
            ASSIGN tt-lista-consolidada.acquirer_nsu      = tt-arquivo-importado.acquirer_nsu
                   tt-lista-consolidada.doc_participante  = tt-arquivo-importado.doc_participante 
                   tt-lista-consolidada.ID_Revendedor     = tt-arquivo-importado.ID_Revendedor    
                   tt-lista-consolidada.val_venda         = tt-arquivo-importado.val_venda        
                   tt-lista-consolidada.valorbruto        = tt-arquivo-importado.valorbruto       
                   tt-lista-consolidada.valordesconto     = tt-arquivo-importado.valordesconto    
                   tt-lista-consolidada.valorliquido      = tt-arquivo-importado.valorliquido  
                   // ID_TITULO ACR =  Para SR - considerar coluna ID Revendedor com formato 6 inteiros + dia e màs (today) e parcela o ano com dois caracteres.
                   //tt-lista-consolidada.id_titulo         = STRING(tt-arquivo-importado.ID_Revendedor) + STRING(DAY(TODAY)) + STRING(MONTH(TODAY)) + STRING(tt-arquivo-importado.parcela) + SUBSTRING(STRING(YEAR(TODAY)),2).
                   tt-lista-consolidada.id_titulo         = STRING(i-revendedor,"999999") + string(DAY(TODAY),"99") + STRING(MONTH(TODAY),"99") .
        END.
        ELSE DO:
            ASSIGN tt-lista-consolidada.valorbruto   = tt-lista-consolidada.valorbruto   + tt-arquivo-importado.valorbruto 
                   tt-lista-consolidada.valorliquido = tt-lista-consolidada.valorliquido + tt-arquivo-importado.valorliquido .
        END.
    END.
END.

PROCEDURE pi-gera-sr:
    //Aqui iremos criar os titulos dentro do ACR na espÇcie SR

    EMPTY TEMP-TABLE tt_integr_acr_lote_impl.
    EMPTY TEMP-TABLE tt_integr_acr_item_lote_impl_8.
    EMPTY TEMP-TABLE tt_integr_acr_aprop_ctbl_pend.


    ASSIGN c-cod-lucree = 558942. // Por em quanto vai ficar fixo 
    ASSIGN i-linha = 0. //Zera contador pra contruir a TT-MENSAGENS

    //Gera o codigo de referencia que sera usado na implantacao do lote
    RUN pi-gera-referencia IN THIS-PROCEDURE (INPUT  "101",
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

    FOR EACH tt-lista-consolidada :
            
            ASSIGN id = id + 1.

            CREATE tt_integr_acr_item_lote_impl_8.
            ASSIGN tt_integr_acr_item_lote_impl_8.ttv_rec_lote_impl_tit_acr      = RECID(tt_integr_acr_lote_impl)
                   tt_integr_acr_item_lote_impl_8.tta_num_seq_refer              = ID
                   tt_integr_acr_item_lote_impl_8.tta_ind_tip_espec_docto        = "antecipacao" //"normal"
                   tt_integr_acr_item_lote_impl_8.tta_cod_portador               = ""
                   tt_integr_acr_item_lote_impl_8.tta_cod_cart_bcia              = ""
                   tt_integr_acr_item_lote_impl_8.tta_cod_espec_docto            = "SR"
                   tt_integr_acr_item_lote_impl_8.tta_cod_parcela                = SUBSTRING(STRING(YEAR(TODAY)),3) 
                   tt_integr_acr_item_lote_impl_8.tta_cod_tit_acr                = string(tt-lista-consolidada.id_titulo)
                   tt_integr_acr_item_lote_impl_8.tta_cdn_cliente                = c-cod-lucree 
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
                   tt_integr_acr_item_lote_impl_8.tta_dat_emis_docto             = TODAY - 1 
                   tt_integr_acr_item_lote_impl_8.tta_cod_cond_cobr              = ""
                   tt_integr_acr_item_lote_impl_8.tta_val_tit_acr                = tt-lista-consolidada.valorliquido
                   tt_integr_acr_item_lote_impl_8.tta_val_desconto               = 0
                   tt_integr_acr_item_lote_impl_8.tta_val_perc_desc              = 0
                   tt_integr_acr_item_lote_impl_8.tta_val_perc_juros_dia_atraso  = 0
                   tt_integr_acr_item_lote_impl_8.tta_val_perc_multa_atraso      = 0
                   tt_integr_acr_item_lote_impl_8.tta_des_text_histor            = "" 
                   tt_integr_acr_item_lote_impl_8.tta_cod_instruc_bcia_1_movto   = ""
                   tt_integr_acr_item_lote_impl_8.tta_cod_instruc_bcia_2_movto   = ""
                   tt_integr_acr_item_lote_impl_8.tta_qtd_dias_carenc_juros_acr  = ? 
                   tt_integr_acr_item_lote_impl_8.tta_val_liq_tit_acr            = tt-lista-consolidada.valorliquido
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


    FOR EACH tt_log_erros_atualiz: 
        CREATE tt-mensagens.
        ASSIGN tt-mensagens.info-erro    = "ERRO"//"NSU: " +  tt-lista-consolidada.acquirer_nsu + " IDRevendedor: " + STRING(tt-lista-consolidada.ID_Revendedor) + " Valor :" + string(tt-lista-consolidada.valorbruto)
               tt-mensagens.num-id-tit-acr = 0
               //tt-mensagens.des-erro       = tt_log_erros_atualiz.ttv_des_msg_erro + " -> " + tt_log_erros_atualiz.ttv_des_msg_ajuda
               tt-mensagens.des-erro       = tt_log_erros_atualiz.ttv_des_msg_ajuda
               tt-mensagens.l-erro         = YES.
    END.


END PROCEDURE. //pi-gera-sr



PROCEDURE pi-gera-dl:
    //Aqui iremos criar os titulos dentro do ACR na espÇcie SR

    EMPTY TEMP-TABLE tt_integr_acr_lote_impl.
    EMPTY TEMP-TABLE tt_integr_acr_item_lote_impl_8.
    EMPTY TEMP-TABLE tt_integr_acr_aprop_ctbl_pend.

    //DEFINE VAR id AS INT.
    DEFINE VAR i-parcela_original AS INT.
    DEFINE VAR i-parcela          AS INT.
    DEFINE VAR dt-vencto          AS DATE.

    ASSIGN c-cod-lucree = 558942. // Por em quanto vai ficar fixo 
    ASSIGN i-linha = 0. //Zera contador pra contruir a TT-MENSAGENS

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

    FOR EACH tt-arquivo-importado :

        ASSIGN ID = ID + 1 .

            CREATE tt_integr_acr_item_lote_impl_8.
            ASSIGN tt_integr_acr_item_lote_impl_8.ttv_rec_lote_impl_tit_acr      = RECID(tt_integr_acr_lote_impl)
                   tt_integr_acr_item_lote_impl_8.tta_num_seq_refer              = ID
                   tt_integr_acr_item_lote_impl_8.tta_ind_tip_espec_docto        = "normal"
                   tt_integr_acr_item_lote_impl_8.tta_cod_portador               = "999"
                   tt_integr_acr_item_lote_impl_8.tta_cod_cart_bcia              = "90"
                   tt_integr_acr_item_lote_impl_8.tta_cod_espec_docto            = "DL"
                   tt_integr_acr_item_lote_impl_8.tta_cod_parcela                = string(tt-arquivo-importado.parcela, "99") 
                   //tt_integr_acr_item_lote_impl_8.tta_cod_tit_acr                = string(tt-arquivo-importado.acquirer_nsu , "9999999999")  // STRING(teste, "999999999")
                   tt_integr_acr_item_lote_impl_8.tta_cod_tit_acr                = fGera_ID_DL(tt-arquivo-importado.authorization_number , string(tt-arquivo-importado.acquirer_nsu))
                   tt_integr_acr_item_lote_impl_8.tta_cdn_cliente                = c-cod-lucree 
                   tt_integr_acr_item_lote_impl_8.tta_cod_ser_docto              = "4"          
                   tt_integr_acr_item_lote_impl_8.tta_cod_finalid_econ_ext       = ""
                   tt_integr_acr_item_lote_impl_8.tta_cod_finalid_econ           = "corrente"
                   tt_integr_acr_item_lote_impl_8.tta_cod_finalid_econ_ext       = ""
                   tt_integr_acr_item_lote_impl_8.tta_cod_indic_econ             = "real"
                   tt_integr_acr_item_lote_impl_8.tta_cod_portad_ext             = ""
                   tt_integr_acr_item_lote_impl_8.tta_cdn_repres                 = 2090 //verificar com Thomaz
                   tt_integr_acr_item_lote_impl_8.tta_dat_vencto_tit_acr         = tt-arquivo-importado.dataprevista
                   tt_integr_acr_item_lote_impl_8.tta_dat_prev_liquidac          = ?
                   tt_integr_acr_item_lote_impl_8.tta_dat_desconto               = ?
                   tt_integr_acr_item_lote_impl_8.tta_dat_emis_docto             = TODAY - 1 
                   tt_integr_acr_item_lote_impl_8.tta_cod_cond_cobr              = ""
                   tt_integr_acr_item_lote_impl_8.tta_val_tit_acr                = tt-arquivo-importado.valorliquido
                   tt_integr_acr_item_lote_impl_8.tta_val_desconto               = 0
                   tt_integr_acr_item_lote_impl_8.tta_val_perc_desc              = 0
                   tt_integr_acr_item_lote_impl_8.tta_val_perc_juros_dia_atraso  = 0
                   tt_integr_acr_item_lote_impl_8.tta_val_perc_multa_atraso      = 0
                   tt_integr_acr_item_lote_impl_8.tta_des_text_histor            = "" 
                   tt_integr_acr_item_lote_impl_8.tta_cod_instruc_bcia_1_movto   = ""
                   tt_integr_acr_item_lote_impl_8.tta_cod_instruc_bcia_2_movto   = ""
                   tt_integr_acr_item_lote_impl_8.tta_qtd_dias_carenc_juros_acr  = ? 
                   tt_integr_acr_item_lote_impl_8.tta_val_liq_tit_acr            = tt-arquivo-importado.valorliquido
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


    FOR EACH tt_log_erros_atualiz: 
        CREATE tt-mensagens.
        ASSIGN tt-mensagens.info-erro    = "ERRO"//"NSU: " +  tt-lista-consolidada.acquirer_nsu + " IDRevendedor: " + STRING(tt-lista-consolidada.ID_Revendedor) + " Valor :" + string(tt-lista-consolidada.valorbruto)
               tt-mensagens.num-id-tit-acr = 0
               //tt-mensagens.des-erro       = tt_log_erros_atualiz.ttv_des_msg_erro + " -> " + tt_log_erros_atualiz.ttv_des_msg_ajuda
                tt-mensagens.des-erro       =  tt_log_erros_atualiz.ttv_des_msg_ajuda
                tt-mensagens.l-erro         = YES.
   END.


END PROCEDURE. //pi-gera-dl

RETURN "OK":U. //Return Final 
