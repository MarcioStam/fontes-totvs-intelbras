{utp/ut-api.i}
{utp/ut-api-utils.i}
{utp/ut-api-action.i pi-consulta-ped-compra get /~*}
{utp/ut-api-notfound.i} 

/************************************************************************************
* Programa ..: API Rest espIntegration_Ped_Compra                                   *
* Data ......: 21/09/2022                                                           *
* Autor .....: Andrey M Oliveira                                                    *
* Versao ....: 1.00.00.000                                                          *
************************************************************************************/

def var jPedComp     as JsonObject no-undo.

def var jItens       as jsonObject no-undo.
def var jItem        as JsonObject no-undo.
def var jArrayItem   as JsonArray  no-undo.

def var jFaturas     as jsonObject no-undo.
def var jFatura      as JsonObject no-undo.
def var jArrayFatura as JsonArray  no-undo.

def var jArrayPedComp     as JsonArray  no-undo.

DEF NEW GLOBAL SHARED VAR i-ep-codigo-usuario AS CHAR NO-UNDO.

DEF VAR h-calc           AS HANDLE                           NO-UNDO.
DEF VAR v_tip_impto      AS CHAR FORMAT "x(40)"              NO-UNDO.
DEF VAR de-total         AS DEC                              NO-UNDO.
DEF VAR c-jason          AS CHAR FORMAT "x(500)"             NO-UNDO.
DEF VAR v_saldo          AS DEC  FORMAT ">>>,>>>,>>>,>>9.99" NO-UNDO.
DEF VAR v_cod_servico    AS CHAR FORMAT "x(6)"               NO-UNDO.
DEF VAR de-preco-unit    LIKE ordem-compra.preco-unit        NO-UNDO.
DEF VAR da-data          AS DATE                             NO-UNDO.

DEF TEMP-TABLE tt-pedido-compr NO-UNDO
    field num-pedido       like pedido-compr.num-pedido       
    field cnpj-fornec      like emitente.cgc                  
    field cnpj-empresa     like estabelec.cgc                 
    field cidade-tomador   like mgcad.cidade.cdn-munpio-ibge  
    field uf-tomador       like estabelec.estado              
    field cidade-fornec    like mgcad.cidade.cdn-munpio-ibge  
    field uf-fornec        like emitente.estado               
    field cidade-serv      like mgcad.cidade.cdn-munpio-ibge  
    field uf-serv          like estabelec.estado            
    field email-compr      like usuar_mestre.cod_e_mail_local 
    field cond-pagto       like cond-pagto.descricao          
    field cod-cond-pagto   like pedido-compr.cod-cond-pag     
    field email-requis     like usuar_mestre.cod_e_mail_loca
    field status-ped       AS CHAR
    field vl-tot-ped       as dec  
    field base-iss         as dec 
    field aliq-iss         as dec 
    field vl-iss           as dec 
    field base-pis         as dec 
    field aliq-pis         as dec 
    field vl-pis           as dec 
    field base-cofins      as dec 
    field aliq-cofins      as dec 
    field vl-cofins        as dec 
    field base-csll        as dec 
    field aliq-csll        as dec 
    field vl-csll          as dec 
    field base-pcc         as dec 
    field aliq-pcc         as dec 
    field vl-pcc           as dec 
    field base-inss        as dec 
    field aliq-inss        as dec 
    field vl-inss          as dec 
    field base-ir          as dec 
    field aliq-ir          as dec 
    field vl-ir            as dec .

DEF TEMP-TABLE tt-ped-item NO-UNDO
    field num-pedido  like pedido-compr.num-pedido  
    field ordem       like ordem-compra.numero-ordem
    field it-codigo   like cotacao-item.it-codigo   
    field sc-codigo   like ordem-compra.sc-codigo   
    field vl-tot-item AS DEC
    field quantid     like ordem-compra.qt-solic    
    field preco-unit  like ordem-compra.pre-unit-for
    field unidade     like prazo-compra.un          
    field saldo-item  AS DEC
    field saldo-qtd   like prazo-compra.quant-saldo 
    field lei-compl   as char
    field base-iss    as dec
    field aliq-iss    as dec
    field vl-iss      as dec
    field base-pis    as dec
    field aliq-pis    as dec
    field vl-pis      as dec
    field base-cofins as dec
    field aliq-cofins as dec
    field vl-cofins   as dec
    field base-csll   as dec
    field aliq-csll   as dec
    field vl-csll     as dec
    field base-pcc    as dec
    field aliq-pcc    as dec
    field vl-pcc      as dec
    field base-inss   as dec
    field aliq-inss   as dec
    field vl-inss     as dec
    field base-ir     as dec
    field aliq-ir     as dec
    field vl-ir       as dec.

def temp-table tt_impostos       no-undo
    field tta_cod_empresa        as character format "x(3)"
    field tta_cdn_fornecedor     as integer   format ">>>,>>>,>>9"      initial 0
    field tta_cod_imposto        as character format "x(5)"
    field tta_cod_pais           as character format "x(3)"
    field tta_cod_unid_federac   as character format "x(3)"
    field tta_cod_retenc_impto   as character format "x(05)"            initial "00000"
    field tta_log_obrig          as log       format "Sim/NÆo"          initial no
    field tta_val_aliq_impto     as decimal   format ">9.99"            decimals 2 initial 0.00
    field tta_cod_espec_docto    as character format "x(3)"
    field tta_cod_ser_docto      as character format "x(3)"
    field tta_dat_vencto_impto   as date      format '99/99/9999'       initial TODAY
    field tta_perc_reduz_rendto  as decimal   format ">,>>>,>>>,>>9.99" decimals 2
    index tt_impto_uniq_primary  is primary   unique
          tta_cod_empresa        ascending
          tta_cdn_fornecedor     ascending
          tta_cod_imposto        ascending
          tta_cod_pais           ascending
          tta_cod_unid_federac   ascending
          tta_cod_retenc_impto   ascending.

def temp-table tt_log_erros no-undo
    field ttv_num_seq                      as integer format ">>>,>>9" label "Sequˆncia" column-label "Seq"
    field ttv_num_cod_erro                 as integer format ">>>>,>>9" label "N£mero" column-label "N£mero"
    field ttv_des_erro                     as character format "x(50)" label "Inconsistˆncia" column-label "Inconsistˆncia"
    field ttv_des_ajuda                    as character format "x(50)" label "Ajuda" column-label "Ajuda".

/* IRRF */
/*--- Temp-tables utilizadas para traduzir a empresa/estab ---*/
def temp-table tt_xml_input_output no-undo
    field ttv_cod_label                    as character format "x(8)" label "Label" column-label "Label"
    field ttv_des_conteudo                 as character format "x(40)" label "Texto" column-label "Texto"
    field ttv_des_conteudo_aux             as character format "x(40)"
    field ttv_num_seq_1                    as integer format ">>>,>>9".

/*--- Temp-tables utilizadas para retornar os impostos do fornecedor ---*/
def temp-table tt_param_integr_imptos_apb no-undo
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_val_pagto_tit_ap             as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Pagamentos" column-label "Vl Pagtos"
    field tta_dat_transacao                as date format "99/99/9999" initial today label "Data Transa‡Æo" column-label "Dat Transac"
    field tta_dat_emis_docto               as date format "99/99/9999" initial today label "Data  EmissÆo" column-label "Dt EmissÆo"
    field tta_dat_vencto_tit_ap            as date format "99/99/9999" initial today label "Data Vencimento" column-label "Dt Vencto"
    field ttv_log_impto_obrig              as logical format "Sim/NÆo" initial no label "Imptos Obrigat¢rios"
    field ttv_num_id_tit_ap                as integer format "9999999999" initial 0 label "Token Tit AP" column-label "Token Tit AP".

def temp-table tt_integr_imptos_pgto_apb no-undo
    field ttv_num_id_tit_ap                as integer format "9999999999" initial 0 label "Token Tit AP" column-label "Token Tit AP"
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field tta_nom_abrev_fornec             as character format "x(15)" label "Nome Abreviado" column-label "Nome Abreviado"
    field tta_cod_imposto                  as character format "x(5)" label "Imposto" column-label "Imposto"
    field tta_des_imposto                  as character format "x(40)" label "Descr  Imposto" column-label "Descri‡Æo"
    field tta_cod_classif_impto            as character format "x(05)" initial "00000" label "Class Imposto" column-label "Class Imposto"
    field tta_cod_unid_federac             as character format "x(3)" label "Unidade Federa‡Æo" column-label "UF"
    field tta_val_aliq_impto               as decimal format ">9.99" decimals 2 initial 0.00 label "Al­quota" column-label "Aliq"
    field tta_val_imposto                  as decimal format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Imposto" column-label "Vl Imposto"
    field tta_val_rendto_tribut            as decimal format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Rendto Tributÿvel" column-label "Vl Rendto Tribut"
    field tta_dat_vencto_tit_ap            as date format "99/99/9999" initial today label "Data Vencimento" column-label "Dt Vencto"
    field tta_log_impto_opcnal             as logical format "Sim/NÆo" initial no label "Imposto Opcional" column-label "Opcional".

def temp-table tt_erros_integr_imptos_apb no-undo
    field ttv_num_id_tit_ap                as integer format "9999999999" initial 0 label "Token Tit AP" column-label "Token Tit AP"
    field ttv_num_cod_erro                 as integer format ">>>>,>>9" label "N£mero" column-label "Numero"
    field ttv_des_msg_erro                 as character format "x(60)" label "Mensagem Erro" column-label "Inconsistˆncia"
    field ttv_des_msg_ajuda                as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda".

DEF VAR v_aliq_pis    LIKE tt_integr_imptos_pgto_apb.tta_val_aliq_impto NO-UNDO.
DEF VAR v_aliq_cofins LIKE tt_integr_imptos_pgto_apb.tta_val_aliq_impto NO-UNDO.
DEF VAR v_aliq_csll   LIKE tt_integr_imptos_pgto_apb.tta_val_aliq_impto NO-UNDO.
DEF VAR v_aliq_ir     LIKE tt_integr_imptos_pgto_apb.tta_val_aliq_impto NO-UNDO.
DEF VAR v_aliq_inss   LIKE tt_integr_imptos_pgto_apb.tta_val_aliq_impto NO-UNDO.
DEF VAR v_aliq_pcc    LIKE tt_integr_imptos_pgto_apb.tta_val_aliq_impto NO-UNDO.

DEF BUFFER b-cidade       FOR mgcad.cidade.
DEF BUFFER b-cidade-2     FOR mgcad.cidade.
DEF BUFFER b-estabelec    FOR estabelec.
DEF BUFFER b_usuar_mestre FOR usuar_mestre.


procedure pi-consulta-ped-compra:
    
    /*
    IF  OPSYS = 'UNIX' THEN DO:                                
        OUTPUT TO "/mnt/spool/an052677/ped_compra_wso2.txt" APPEND.
        PUT UNFORMATTED "1" SKIP.
        OUTPUT CLOSE.                                
    END.
    */

    def input  param jsonInput  as JsonObject no-undo.
    def output param jsonOutput as JsonObject no-undo.

    def var oResponse       as JsonAPIResponse      no-undo.
    def var oRequestParser  as JsonAPIRequestParser no-undo.
    def var oJsonObject     as JsonObject           no-undo.
    def var jPrincipal      as JsonObject           no-undo.
    def var jArrayPrincipal as JsonArray            no-undo.

    def var c-pedido        as char no-undo.
    def var dt-startDate as date no-undo.
    def var dt-endDate   as date no-undo.
    def var c-orderCode  as char no-undo.
    def var i-aux        as inte no-undo.
    def var i-num-param  as inte no-undo.

    delete object jPedComp          no-error.
    delete object jItens       no-error.
    delete object jItem        no-error.
    delete object jArrayItem   no-error.
    delete object jFaturas     no-error.
    delete object jFatura      no-error.
    delete object jArrayFatura no-error.
    delete object jArrayPedComp     no-error.

    empty temp-table RowErrors.

    assign oRequestParser = new JsonAPIRequestParser(jsonInput) no-error.

    assign jArrayPrincipal = new JsonArray().
    jArrayPrincipal = oRequestParser:getPathParams() no-error.

    assign i-num-param = jArrayPrincipal:length no-error.

    if  i-num-param >= 1 then.
    else return.

    do i-aux = 1 to i-num-param:
        case i-aux:
            when 1
            then assign c-pedido = JsonAPIUtils:getPropertyJsonArray(jArrayPrincipal, i-aux) no-error.
        end case.
    end.

    if  c-pedido = ""
    or  c-pedido = ? then 
        return. 

    assign i-aux = 0.

    EMPTY TEMP-TABLE tt-pedido-compr.
    EMPTY TEMP-TABLE tt-ped-item.
    
    FIND FIRST pedido-compr
        WHERE pedido-compr.num-pedido = int(c-pedido) NO-LOCK NO-ERROR.
    
    IF  AVAIL pedido-compr THEN DO:
    
        FOR EACH ordem-compra OF pedido-compr
            WHERE ordem-compra.situacao <> 4: /* eliminada */
            
            ASSIGN v_saldo = 0.
    
            FIND FIRST prazo-compra OF ordem-compra NO-LOCK
                WHERE /*prazo-compra.situacao   <> 4 /* eliminada */
                AND   prazo-compra.quant-saldo > 0*/ NO-ERROR.
    
            IF  AVAIL prazo-compra THEN DO:
    
                FIND FIRST estabelec
                    WHERE estabelec.cod-estab = ordem-compra.cod-estabel NO-LOCK NO-ERROR.
    
                IF  AVAIL estabelec THEN DO:
                    find FIRST mgcad.cidade no-lock
                        where mgcad.cidade.pais   = estabelec.pais
                        and   mgcad.cidade.estado = estabelec.estado
                        and   mgcad.cidade.cidade = estabelec.cidade no-error.                    
    
                END.
    
                FIND FIRST b-estabelec
                    WHERE b-estabelec.cod-estab = pedido-compr.end-entrega NO-LOCK NO-ERROR.
    
                IF  AVAIL b-estabelec THEN DO:
                    find FIRST b-cidade-2 no-lock
                        where b-cidade-2.pais   = b-estabelec.pais
                        and   b-cidade-2.estado = b-estabelec.estado
                        and   b-cidade-2.cidade = b-estabelec.cidade no-error. 
    
                END.
    
                FIND FIRST emitente
                    WHERE emitente.cod-emitente = ordem-compra.cod-emitente NO-LOCK NO-ERROR.
    
                IF  AVAIL emitente THEN DO:
                    find FIRST b-cidade no-lock
                        where b-cidade.pais   = emitente.pais
                        and   b-cidade.estado = emitente.estado
                        and   b-cidade.cidade = emitente.cidade no-error.                    
    
                END.
    
                FIND FIRST usuar_mestre NO-LOCK
                     WHERE usuar_mestre.cod_usuario = ordem-compra.cod-comprado NO-ERROR.
    
                FIND FIRST b_usuar_mestre NO-LOCK
                     WHERE b_usuar_mestre.cod_usuario = ordem-compra.requisitante NO-ERROR.
    
                FIND FIRST cond-pagto
                    WHERE cond-pagto.cod-cond-pag = pedido-compr.cod-cond-pag NO-LOCK NO-ERROR.
    
                assign de-preco-unit = ordem-compra.preco-unit
                       da-data       = IF ordem-compra.data-cotacao <> ? THEN ordem-compra.data-cotacao ELSE TODAY.

                if  ordem-compra.mo-codigo <> 0 then do:
                    run cdp/cd0812.p (input  ordem-compra.mo-codigo,
                                      input  0,
                                      input  de-preco-unit,
                                      input  da-data,
                                      output de-preco-unit).
                end.

                if  de-preco-unit = ? then 
                    ASSIGN de-preco-unit = 0.

                FIND FIRST tt-pedido-compr
                    WHERE tt-pedido-compr.num-pedido = pedido-compr.num-pedido EXCLUSIVE-LOCK NO-ERROR.
    
                IF  NOT AVAIL tt-pedido-compr THEN DO:

                    EMPTY TEMP-TABLE tt_param_integr_imptos_apb.
                    EMPTY TEMP-TABLE tt_integr_imptos_pgto_apb.
                    EMPTY TEMP-TABLE tt_erros_integr_imptos_apb.

                    /*--- Retorna impostos retidos do fornecedor ---*/
                    CREATE tt_param_integr_imptos_apb.
                    ASSIGN tt_param_integr_imptos_apb.tta_cod_empresa       = i-ep-codigo-usuario
                           tt_param_integr_imptos_apb.tta_cdn_fornecedor    = ordem-compra.cod-emitente
                           tt_param_integr_imptos_apb.tta_cod_estab         = ordem-compra.cod-estabel
                           tt_param_integr_imptos_apb.tta_val_pagto_tit_ap  = de-preco-unit
                           tt_param_integr_imptos_apb.tta_dat_transacao     = TODAY
                           tt_param_integr_imptos_apb.tta_dat_emis_docto    = TODAY
                           tt_param_integr_imptos_apb.tta_dat_vencto_tit_ap = TODAY
                           tt_param_integr_imptos_apb.ttv_log_impto_obrig   = YES. /* se considera apenas impostos obrigat¢rios */            

                    RUN prgfin/apb/apb719za.py PERSISTENT SET  h-calc.

                    RUN pi_main_retorna_impostos_calculados_01 IN h-calc (INPUT  TABLE tt_param_integr_imptos_apb,
                                                                          OUTPUT TABLE tt_integr_imptos_pgto_apb,
                                                                          OUTPUT TABLE tt_erros_integr_imptos_apb).
                    DELETE PROCEDURE h-calc.
                    ASSIGN h-calc = ?.

                    FOR EACH tt_integr_imptos_pgto_apb:

                        FIND FIRST imposto
                            WHERE imposto.cod_pais         = "BRA"
                            AND   imposto.cod_unid_federac = tt_integr_imptos_pgto_apb.tta_cod_unid_federac
                            AND   imposto.cod_imposto      = tt_integr_imptos_pgto_apb.tta_cod_imposto NO-LOCK NO-ERROR.

                        IF  AVAIL imposto THEN DO:

                            IF  imposto.ind_tip_impto = "Imposto de Renda Retido na Fonte" THEN
                                ASSIGN v_aliq_ir = tt_integr_imptos_pgto_apb.tta_val_aliq_impto.

                            IF  imposto.ind_tip_impto = "Inst Nacional Seguro Social (INSS)" THEN
                                ASSIGN v_aliq_inss = tt_integr_imptos_pgto_apb.tta_val_aliq_impto.

                            IF  imposto.ind_tip_impto = "Imposto COFINS  PIS  CSLL Retido" THEN DO:
                                IF  tt_integr_imptos_pgto_apb.tta_cod_classif_impto = "5979" THEN
                                    ASSIGN v_aliq_pis = tt_integr_imptos_pgto_apb.tta_val_aliq_impto.

                                IF  tt_integr_imptos_pgto_apb.tta_cod_classif_impto = "5960" THEN
                                    ASSIGN v_aliq_cofins = tt_integr_imptos_pgto_apb.tta_val_aliq_impto.

                                IF  tt_integr_imptos_pgto_apb.tta_cod_classif_impto = "5987" THEN
                                    ASSIGN v_aliq_csll = tt_integr_imptos_pgto_apb.tta_val_aliq_impto.

                                IF  tt_integr_imptos_pgto_apb.tta_cod_classif_impto = "5952" THEN
                                    ASSIGN v_aliq_pcc = tt_integr_imptos_pgto_apb.tta_val_aliq_impto.
                            END.

                        END.
                    END.

                    ASSIGN i-aux = i-aux + 1.

                    CREATE tt-pedido-compr.
                    ASSIGN tt-pedido-compr.num-pedido     = pedido-compr.num-pedido
                           tt-pedido-compr.cnpj-fornec    = emitente.cgc WHEN AVAIL emitente
                           tt-pedido-compr.cnpj-empresa   = estabelec.cgc WHEN AVAIL estabelec
                           tt-pedido-compr.cidade-tomador = mgcad.cidade.cdn-munpio-ibge WHEN AVAIL mgcad.cidade
                           tt-pedido-compr.uf-tomador     = estabelec.estado WHEN AVAIL estabelec
                           tt-pedido-compr.cidade-fornec  = b-cidade.cdn-munpio-ibge WHEN AVAIL b-cidade
                           tt-pedido-compr.uf-fornec      = emitente.estado WHEN AVAIL emitente
                           tt-pedido-compr.cidade-serv    = b-cidade-2.cdn-munpio-ibge WHEN AVAIL b-cidade-2
                           tt-pedido-compr.uf-serv        = b-estabelec.estado WHEN AVAIL b-estabelec
                           tt-pedido-compr.email-compr    = usuar_mestre.cod_e_mail_local WHEN AVAIL usuar_mestre
                           tt-pedido-compr.cond-pagto     = cond-pagto.descricao WHEN AVAIL cond-pagto
                           tt-pedido-compr.cod-cond-pagto = pedido-compr.cod-cond-pag
                           tt-pedido-compr.email-requis   = b_usuar_mestre.cod_e_mail_local WHEN AVAIL b_usuar_mestre
                           tt-pedido-compr.status-ped     = {ininc/i02in295.i 04 pedido-compr.situacao}
                           tt-pedido-compr.vl-tot-ped     = de-preco-unit * ordem-compra.qt-solic
                           tt-pedido-compr.base-iss       = 0
                           tt-pedido-compr.aliq-iss       = ordem-compra.aliquota-iss
                           tt-pedido-compr.vl-iss         = 0
                           tt-pedido-compr.base-pis       = 0
                           tt-pedido-compr.aliq-pis       = v_aliq_pis
                           tt-pedido-compr.vl-pis         = 0
                           tt-pedido-compr.base-cofins    = 0
                           tt-pedido-compr.aliq-cofins    = v_aliq_cofins
                           tt-pedido-compr.vl-cofins      = 0
                           tt-pedido-compr.base-csll      = 0
                           tt-pedido-compr.aliq-csll      = v_aliq_csll
                           tt-pedido-compr.vl-csll        = 0
                           tt-pedido-compr.base-pcc       = 0
                           tt-pedido-compr.aliq-pcc       = v_aliq_pcc
                           tt-pedido-compr.vl-pcc         = 0
                           tt-pedido-compr.base-inss      = 0
                           tt-pedido-compr.aliq-inss      = v_aliq_inss
                           tt-pedido-compr.vl-inss        = 0
                           tt-pedido-compr.base-ir        = 0
                           tt-pedido-compr.aliq-ir        = v_aliq_ir
                           tt-pedido-compr.vl-ir          = 0.
                END.
                ELSE DO:
                    ASSIGN tt-pedido-compr.vl-tot-ped = tt-pedido-compr.vl-tot-ped + (de-preco-unit * ordem-compra.qt-solic).
                END.
            END.
    
            FOR EACH prazo-compra OF ordem-compra NO-LOCK
                /*WHERE prazo-compra.situacao    = 2*/ /*confirmada*/
                /*AND   prazo-compra.quant-saldo > 0*/:
                
                IF  prazo-compra.quant-saldo > 0 THEN
                    ASSIGN v_saldo = v_saldo + (prazo-compra.quant-saldo * de-preco-unit).
                ELSE
                    ASSIGN v_saldo = 0.
            END.
    
            FIND FIRST cotacao-item OF ordem-compra NO-LOCK NO-ERROR.
    
            IF  AVAIL cotacao-item THEN DO:
                
                FIND FIRST cond-pagto
                    WHERE cond-pagto.cod-cond-pag = pedido-compr.cod-cond-pag NO-LOCK NO-ERROR.
    
                FIND FIRST prazo-compra OF ordem-compra 
                    /*WHERE prazo-compra.situacao = 2*/ /*confirmada*/ NO-LOCK NO-ERROR.
    
                FIND FIRST item
                    WHERE item.it-codigo = cotacao-item.it-codigo NO-LOCK NO-ERROR.

                IF  AVAIL item 
                AND item.cod-servico <> 0 THEN
                    ASSIGN v_cod_servico = string(item.cod-servico).
                ELSE
                    ASSIGN v_cod_servico = "".
    
                CREATE tt-ped-item.
                ASSIGN tt-ped-item.num-pedido  = pedido-compr.num-pedido
                       tt-ped-item.ordem       = ordem-compra.numero-ordem
                       tt-ped-item.it-codigo   = cotacao-item.it-codigo
                       tt-ped-item.sc-codigo   = ordem-compra.sc-codigo
                       tt-ped-item.vl-tot-item = ordem-compra.qt-solic * de-preco-unit
                       tt-ped-item.quantid     = ordem-compra.qt-solic
                       tt-ped-item.preco-unit  = de-preco-unit
                       tt-ped-item.unidade     = prazo-compra.un
                       tt-ped-item.saldo-item  = v_saldo
                       tt-ped-item.saldo-qtd   = prazo-compra.quant-saldo
                       tt-ped-item.lei-compl   = v_cod_servico /* lei complementar cd0903 */
                       tt-ped-item.base-iss    = 0
                       tt-ped-item.aliq-iss    = ordem-compra.aliquota-iss
                       tt-ped-item.vl-iss      = 0
                       tt-ped-item.base-pis    = 0
                       tt-ped-item.aliq-pis    = v_aliq_pis
                       tt-ped-item.vl-pis      = 0
                       tt-ped-item.base-cofins = 0
                       tt-ped-item.aliq-cofins = v_aliq_cofins
                       tt-ped-item.vl-cofins   = 0
                       tt-ped-item.base-csll   = 0
                       tt-ped-item.aliq-csll   = v_aliq_csll
                       tt-ped-item.vl-csll     = 0
                       tt-ped-item.base-pcc    = 0
                       tt-ped-item.aliq-pcc    = v_aliq_pcc
                       tt-ped-item.vl-pcc      = 0
                       tt-ped-item.base-inss   = 0
                       tt-ped-item.aliq-inss   = v_aliq_inss
                       tt-ped-item.vl-inss     = 0
                       tt-ped-item.base-ir     = 0
                       tt-ped-item.aliq-ir     = v_aliq_ir
                       tt-ped-item.vl-ir       = 0.
             END.
        END.
    END.

    ASSIGN jArrayPedComp = NEW JsonArray().

    FIND FIRST tt-pedido-compr NO-LOCK NO-ERROR.

    IF  AVAIL pedido-compr THEN DO:
        assign jPedComp = new JsonObject().
    
        jPedComp:add("purchaseOrderNumber",string(tt-pedido-compr.num-pedido)).
        jPedComp:add("supplierIdentificationNumber",string(tt-pedido-compr.cnpj-fornec)).
        jPedComp:add("customerIdentificationNumber",string(tt-pedido-compr.cnpj-empresa)).
        jPedComp:add("customerCity",STRING(tt-pedido-compr.cidade-tomador)).
        jPedComp:add("customerState",tt-pedido-compr.uf-tomador).
        jPedComp:add("supplierCity",STRING(tt-pedido-compr.cidade-fornec)).
        jPedComp:add("supplierState",tt-pedido-compr.uf-fornec).
        jPedComp:add("serviceCity",STRING(tt-pedido-compr.cidade-serv)).
        jPedComp:add("serviceState",tt-pedido-compr.uf-serv).
        jPedComp:add("buyerEmail",tt-pedido-compr.email-compr).
        jPedComp:add("paymentMethod",tt-pedido-compr.cond-pagto).
        jPedComp:add("paymentErpCode",tt-pedido-compr.cod-cond-pagto).
        jPedComp:add("requesteEmail",tt-pedido-compr.email-requis).
        jPedComp:add("status",tt-pedido-compr.status-ped).
        jPedComp:add("iva","0").
        jPedComp:add("totalValue",dec(tt-pedido-compr.vl-tot-ped)).
        jPedComp:add("issBaseValue",0).
        jPedComp:add("issTaxRate",dec(tt-pedido-compr.aliq-iss)).
        jPedComp:add("issTaxValue",0).
        jPedComp:add("pisBaseValue",0).
        jPedComp:add("pisTaxRate",dec(tt-pedido-compr.aliq-pis)).
        jPedComp:add("pisTaxValue",0).
        jPedComp:add("cofinsBaseValue",0).
        jPedComp:add("cofinsTaxRate",dec(tt-pedido-compr.aliq-cofins)).
        jPedComp:add("cofinsTaxValue",0).
        jPedComp:add("csllBaseValue",0).
        jPedComp:add("csllTaxRate",dec(tt-pedido-compr.aliq-csll)).
        jPedComp:add("csllTaxValue",0).
        jPedComp:add("pccBaseValue",0).
        jPedComp:add("pccTaxRate",dec(tt-pedido-compr.aliq-pcc)).
        jPedComp:add("pccTaxValue",0).
        jPedComp:add("inssBaseValue",0).
        jPedComp:add("inssTaxRate",dec(tt-pedido-compr.aliq-inss)).
        jPedComp:add("inssTaxValue",0).
        jPedComp:add("irBaseValue",0).
        jPedComp:add("irTaxRate",dec(tt-pedido-compr.aliq-ir)).
        jPedComp:add("irTaxValue",0).
        jPedComp:add("ipiBaseValue",0).
        jPedComp:add("ipiTaxRate",0).
        jPedComp:add("ipiTaxValue",0).
        jPedComp:add("icmsBaseValue",0).
        jPedComp:add("icmsTaxRate",0).
        jPedComp:add("icmsTaxValue",0).
        jPedComp:add("icmsstBaseValue",0).
        jPedComp:add("icmsstTaxRate",0).
        jPedComp:add("icmsstTaxValue",0).
    
        assign jItens     = new JsonObject().
        assign jArrayItem = new JsonArray().

        FOR EACH tt-ped-item
            WHERE tt-ped-item.num-pedido = tt-pedido-compr.num-pedido:

            assign jItem = new JsonObject().
            
            jItem:add("purchaseOrderItem",string(tt-ped-item.ordem)).
            jItem:add("erpItemCode",string(tt-ped-item.it-codigo)).
            jItem:add("costCenter",string(tt-ped-item.sc-codigo)).
            jItem:add("totalValue",dec(tt-ped-item.vl-tot-item)).
            jItem:add("quantity",tt-ped-item.quantid).
            jItem:add("unitPrice",tt-ped-item.preco-unit).
            jItem:add("unit",tt-ped-item.unidade).
            jItem:add("totalValueInBalance",tt-ped-item.saldo-item).
            jItem:add("quantityInBalance",tt-ped-item.saldo-qtd).
            jItem:add("ncm","").
            jItem:add("lc116",tt-ped-item.lei-compl).
            jItem:add("iva","").
            jItem:add("issBaseValue",0).
            jItem:add("issTaxRate",dec(tt-ped-item.aliq-iss)).
            jItem:add("issTaxValue",0).
            jItem:add("pisBaseValue",0).
            jItem:add("pisTaxRate",dec(tt-ped-item.aliq-pis)).
            jItem:add("pisTaxValue",0).
            jItem:add("cofinsBaseValue",0).
            jItem:add("cofinsTaxRate",dec(tt-ped-item.aliq-cofins)).
            jItem:add("cofinsTaxValue",0).
            jItem:add("csllBaseValue",0).
            jItem:add("csllTaxRate",dec(tt-ped-item.aliq-csll)).
            jItem:add("csllTaxValue",0).
            jItem:add("pccBaseValue",0).
            jItem:add("pccTaxRate",dec(tt-ped-item.aliq-pcc)).
            jItem:add("pccTaxValue",0).
            jItem:add("inssBaseValue",0).
            jItem:add("inssTaxRate",dec(tt-ped-item.aliq-inss)).
            jItem:add("inssTaxValue",0).
            jItem:add("irBaseValue",0).
            jItem:add("irTaxRate",dec(tt-ped-item.aliq-ir)).
            jItem:add("irTaxValue",0).
            jItem:add("ipiBaseValue",0).
            jItem:add("ipiTaxRate",0).
            jItem:add("ipiTaxValue",0).
            jItem:add("icmsBaseValue",0).
            jItem:add("icmsTaxRate",0).
            jItem:add("icmsTaxValue",0).
            jItem:add("icmsStBaseValue",0).
            jItem:add("icmsStTaxRate",0).
            jItem:add("icmsStTaxValue",0).
            jItem:add("fcpBaseValue",0).
            jItem:add("fcpTaxRate",0).
            jItem:add("fcpValue",0).
            jItem:add("fcpStBaseValue",0).
            jItem:add("fcpStTaxRate",0).
            jItem:add("fcpStValue",0).
            jItem:add("acceptanceTerm","").
            jItem:add("acceptanceTermStatus","").
            jItem:add("acceptanceTermLc116","").
            jItem:add("acceptanceTermValue",0).
        
            jArrayItem:add(jItem).
        END.

        jPedComp:add("items",JArrayItem).
        jArrayPedComp:add(jPedComp).

        assign jPrincipal  = new JsonObject().
        assign oJsonObject = new JsonObject().
    
        oJsonObject:add("payload",jArrayPedComp).
    END.
    ELSE DO:
        /* nao encontrou o pedido */
        jsonOutput = JsonAPIResponseBuilder:OK(jsonInput, 404).
    END.

    if  i-aux = 0 then 
        return.

    run createJsonResponse(input  oJsonObject, 
                           input  table RowErrors, 
                           input  false,
                           output jsonOutput).   

end procedure. /* procedure pi-consulta-ped-compra */
