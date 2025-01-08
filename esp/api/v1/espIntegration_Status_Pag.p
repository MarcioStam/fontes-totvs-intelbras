{utp/ut-api.i}
{utp/ut-api-utils.i}
{utp/ut-api-action.i pi-consulta-status-pag get /~*}
{utp/ut-api-notfound.i} 

/************************************************************************************
* Programa ..: API Rest espIntegration_Status_Pag                                   *
* Data ......: 24/01/2023                                                           *
* Autor .....: Andrey M Oliveira                                                    *
* Versao ....: 1.00.00.000                                                          *
************************************************************************************/

DEF VAR jStatusPag      AS JsonObject           NO-UNDO.
DEF VAR jParcelas       AS jsonObject           NO-UNDO.
DEF VAR jParcs          AS JsonObject           NO-UNDO.
DEF VAR jArrayParcelas  AS JsonArray            NO-UNDO.
DEF VAR jArrayStatusPag AS JsonArray            NO-UNDO.

DEF VAR h-calc          AS HANDLE               NO-UNDO.
DEF VAR c-jason         AS CHAR FORMAT "x(500)" NO-UNDO.

DEF NEW GLOBAL SHARED VAR i-ep-codigo-usuario AS CHAR NO-UNDO.

DEF TEMP-TABLE tt_status_pag NO-UNDO
    FIELD erp_code                 AS CHAR
    FIELD payment_erp_code         AS CHAR
    FIELD total_value              AS DEC
    FIELD status_pag               AS CHAR.

DEF TEMP-TABLE tt_status_parc NO-UNDO
    FIELD erp_code                 AS char
    FIELD installments             AS INT
    FIELD value_pag                AS DEC
    FIELD value_in_balance         AS DEC
    FIELD payment_date             AS DATE
    FIELD schedule_date            AS DATE
    FIELD item_status              AS char
    FIELD status_descr             AS char
    FIELD erp_invoice_number       AS char
    FIELD payment_type_code        AS char
    FIELD payment_type_description AS char
    FIELD erp_company_code         AS char
    FIELD cost_center              AS char.


procedure pi-consulta-status-pag:
    
    /*
    IF  OPSYS = 'UNIX' THEN DO:                                
        OUTPUT TO "/mnt/spool/an052677/tst_st_pag.txt" APPEND.
        PUT UNFORMATTED "1 - status pagto" SKIP.
        OUTPUT CLOSE.                                
    END.
    */

    DEF INPUT  PARAM jsonInput  AS JsonObject NO-UNDO.
    DEF OUTPUT PARAM jsonOutput AS JsonObject NO-UNDO.

    DEF BUFFER b-dupli-apagar FOR dupli-apagar.

    DEF VAR oResponse          AS JsonAPIResponse      NO-UNDO.
    DEF VAR oRequestParser     AS JsonAPIRequestParser NO-UNDO.
    DEF VAR oJsonObject        AS JsonObject           NO-UNDO.
    DEF VAR jPrincipal         AS JsonObject           NO-UNDO.
    DEF VAR jArrayPrincipal    AS JsonArray            NO-UNDO.

    DEF VAR c-row-nota         AS CHAR                 NO-UNDO.
    DEF VAR r-nota             AS ROWID                NO-UNDO.
    DEF VAR i-aux              AS inte                 NO-UNDO.
    DEF VAR i-num-param        AS inte                 NO-UNDO.
    DEF VAR v_tot_apagar       AS DEC                  NO-UNDO.
    DEF VAR v_sdo_apagar       AS DEC                  NO-UNDO.
    DEF VAR v_status_nota      AS CHAR                 NO-UNDO.
    DEF VAR v_status_parc      AS CHAR                 NO-UNDO.
    DEF VAR v_desc_status_parc AS CHAR                 NO-UNDO.

    DELETE OBJECT jStatusPag      NO-ERROR.
    DELETE OBJECT jParcelas       NO-ERROR.
    DELETE OBJECT jParcs          NO-ERROR.
    DELETE OBJECT jArrayParcelas  NO-ERROR.
    DELETE OBJECT jArrayStatusPag NO-ERROR.

    EMPTY TEMP-TABLE RowErrors.

    ASSIGN oRequestParser = NEW JsonAPIRequestParser(jsonInput) NO-ERROR.

    ASSIGN jArrayPrincipal = NEW JsonArray().
    jArrayPrincipal = oRequestParser:getPathParams() NO-ERROR.

    ASSIGN i-num-param = jArrayPrincipal:LENGTH NO-ERROR.

    IF  i-num-param >= 1 THEN.
    ELSE RETURN.

    DO  i-aux = 1 TO i-num-param:
        CASE i-aux:
            WHEN 1 THEN
                ASSIGN c-row-nota = JsonAPIUtils:getPropertyJsonArray(jArrayPrincipal, i-aux) NO-ERROR.
        END CASE.
    END.
    
    IF  c-row-nota = ""
    OR  c-row-nota = ? THEN 
        RETURN. 

    ASSIGN i-aux  = 0
           r-nota = TO-ROWID(c-row-nota).

    EMPTY TEMP-TABLE tt_status_pag.
    EMPTY TEMP-TABLE tt_status_parc.
    
    /*
    IF  OPSYS = 'UNIX' THEN DO:                                
        OUTPUT TO "/mnt/spool/an052677/tst_st_pag.txt" APPEND.
        PUT UNFORMATTED "2 - status pagto" SKIP.
        OUTPUT CLOSE.                                
    END.
    */

    FIND FIRST docum-est
        WHERE ROWID(docum-est) = r-nota NO-LOCK NO-ERROR.
    
    IF  AVAIL docum-est THEN DO:
    
        /*
        IF  OPSYS = 'UNIX' THEN DO:                                
            OUTPUT TO "/mnt/spool/an052677/tst_st_pag.txt" APPEND.
            PUT UNFORMATTED "3 - status pagto" SKIP.
            OUTPUT CLOSE.                                
        END.
        */

        FIND FIRST b-dupli-apagar
            WHERE b-dupli-apagar.serie-docto  = docum-est.serie-docto
            AND   b-dupli-apagar.nro-docto    = docum-est.nro-docto
            AND   b-dupli-apagar.cod-emitente = docum-est.cod-emitente
            AND   b-dupli-apagar.nat-operacao = docum-est.nat-operacao NO-LOCK NO-ERROR.
            
        IF  AVAIL b-dupli-apagar THEN DO:
            
            /*
            IF  OPSYS = 'UNIX' THEN DO:                                
                OUTPUT TO "/mnt/spool/an052677/tst_st_pag.txt" APPEND.
                PUT UNFORMATTED "3.1 - status pagto" SKIP.
                OUTPUT CLOSE.                                
            END.
            */

            ASSIGN v_tot_apagar = 0.

            FOR EACH dupli-apagar NO-LOCK
                WHERE dupli-apagar.serie-docto  = docum-est.serie-docto
                AND   dupli-apagar.nro-docto    = docum-est.nro-docto
                AND   dupli-apagar.cod-emitente = docum-est.cod-emitente
                AND   dupli-apagar.nat-operacao = docum-est.nat-operacao:
                
                FIND tit_ap NO-LOCK
                    WHERE tit_ap.cod_estab   = dupli-apagar.cod-estabel
                    AND   tit_ap.cdn_fornec  = dupli-apagar.cod-emitente
                    AND   tit_ap.cod_espec   = dupli-apagar.cod-esp
                    AND   tit_ap.cod_ser     = dupli-apagar.serie  
                    AND   tit_ap.cod_tit_ap  = dupli-apagar.nr-duplic
                    AND   tit_ap.cod_parcela = dupli-apagar.parcela NO-ERROR.

                IF  AVAIL tit_ap THEN DO:
                    ASSIGN v_tot_apagar = v_tot_apagar + tit_ap.val_origin_tit_ap
                           v_sdo_apagar = v_sdo_apagar + tit_ap.val_sdo_tit_ap.

                    /*
                    IF  OPSYS = 'UNIX' THEN DO:
                        OUTPUT TO "/mnt/spool/an052677/tst_st_pag.txt" APPEND.
                        PUT UNFORMATTED "3.3 - status pagto"                     SKIP
                                        "tit_ap.cod_estab "   tit_ap.cod_estab   skip
                                        "tit_ap.cdn_fornec "  tit_ap.cdn_fornec  skip
                                        "tit_ap.cod_espec "   tit_ap.cod_espec   skip
                                        "tit_ap.cod_ser "     tit_ap.cod_ser     skip
                                        "tit_ap.cod_tit_ap "  tit_ap.cod_tit_ap  skip
                                        "tit_ap.cod_parcela " tit_ap.cod_parcela skip
                                        "v_tot_apagar "       v_tot_apagar       SKIP.
                        OUTPUT CLOSE.
                    END.
                    */

                    IF  tit_ap.val_sdo_tit_ap > 0 THEN DO:
                        
                        IF  tit_ap.val_sdo_tit_ap = tit_ap.val_origin_tit_ap THEN
                            ASSIGN v_status_parc      = "NOT_PAID"
                                   v_desc_status_parc = "Pagamento nÆo realizado antes do vencimento".
                        ELSE
                            ASSIGN v_status_parc      = "PARTIALLY_PAID"
                                   v_desc_status_parc = "Pagamento efetuado parcialmente".

                        FIND LAST proces_pagto OF tit_ap NO-LOCK NO-ERROR.
                
                        IF  AVAIL proces_pagto THEN DO:
                            IF  proces_pagto.ind_sit_proces_pagto = "Em Pagamento" THEN
                                ASSIGN v_desc_status_parc = "Parcela em processo de pagamento".

                            ELSE DO:
                                IF  proces_pagto.ind_sit_proces_pagto = "Estornado" THEN
                                    ASSIGN v_status_parc      = "CANCELLED"
                                           v_desc_status_parc = "Pagamento Estornado".
                            END.
                        END.
                    END.
                    ELSE DO:
                        ASSIGN v_status_parc      = "PAID"
                               v_desc_status_parc = "Nota com pagamento confirmado".
                    END.

                    FIND FIRST forma_pagto NO-LOCK
                        WHERE forma_pagto.cod_forma_pagto = tit_ap.cod_forma_pagto NO-ERROR.

                    CREATE tt_status_parc.
                    ASSIGN tt_status_parc.erp_code                 = c-row-nota
                           tt_status_parc.installments             = INT(tit_ap.cod_parcela)
                           tt_status_parc.value_pag                = tit_ap.val_origin_tit_ap
                           tt_status_parc.value_in_balance         = tit_ap.val_sdo_tit_ap
                           tt_status_parc.payment_date             = tit_ap.dat_vencto_tit_ap
                           tt_status_parc.schedule_date            = tit_ap.dat_vencto_tit_ap
                           tt_status_parc.item_status              = v_status_parc
                           tt_status_parc.status_descr             = v_desc_status_parc
                           tt_status_parc.erp_invoice_number       = c-row-nota
                           tt_status_parc.payment_type_code        = forma_pagto.ind_tip_forma_pagto WHEN AVAIL forma_pagto
                           tt_status_parc.payment_type_description = forma_pagto.des_forma_pagto WHEN AVAIL forma_pagto
                           tt_status_parc.erp_company_code         = tit_ap.cod_empresa
                           tt_status_parc.cost_center              = "".
                END.
            END.

            ASSIGN i-aux = i-aux + 1.

            IF  v_sdo_apagar > 0 THEN DO:
                
                IF  v_sdo_apagar = v_tot_apagar THEN
                    ASSIGN v_status_nota = "NOT_PAID".
                ELSE
                    ASSIGN v_status_nota = "PARTIALLY_PAID".
            END.
            ELSE
                ASSIGN v_status_nota = "PAID".

            CREATE tt_status_pag.
            ASSIGN tt_status_pag.erp_code         = c-row-nota
                   tt_status_pag.payment_erp_code = b-dupli-apagar.nr-duplic
                   tt_status_pag.total_value      = v_tot_apagar
                   tt_status_pag.status_pag       = v_status_nota.

        END.
    END.
    ELSE DO:
        /*
        IF  OPSYS = 'UNIX' THEN DO:                                
            OUTPUT TO "/mnt/spool/an052677/tst_st_pag.txt" APPEND.
            PUT UNFORMATTED "4 - status pagto" SKIP.
            OUTPUT CLOSE.                                
        END.
        */
    END.

    ASSIGN jArrayStatusPag = NEW JsonArray().

    FIND FIRST tt_status_pag NO-LOCK NO-ERROR.

    IF  AVAIL tt_status_pag THEN DO:

        ASSIGN jStatusPag = NEW JsonObject().
    
        jStatusPag:add("paymentErpCode",tt_status_pag.payment_erp_code).
        jStatusPag:add("totalValue",tt_status_pag.total_value).
        jStatusPag:add("status",tt_status_pag.status_pag).
    
        ASSIGN jParcelas      = NEW JsonObject().
        ASSIGN jArrayParcelas = NEW JsonArray().

        FOR EACH tt_status_parc
            WHERE tt_status_parc.erp_code = tt_status_pag.erp_code:

            ASSIGN jParcs = NEW JsonObject().
            
            jParcs:ADD("installments",tt_status_parc.installments).
            jParcs:ADD("value",tt_status_parc.value_pag).
            jParcs:ADD("valueInBalance",tt_status_parc.value_in_balance).
            jParcs:ADD("paymentDate",tt_status_parc.payment_date).
            jParcs:ADD("scheduleDate",tt_status_parc.schedule_date).
            jParcs:ADD("itemStatus",tt_status_parc.item_status).
            jParcs:ADD("description",tt_status_parc.status_descr).
            jParcs:ADD("erpInvoiceNumber",tt_status_parc.erp_invoice_number).
            jParcs:ADD("paymentTypeCode",tt_status_parc.payment_type_code).
            jParcs:ADD("paymentTypeDescription",tt_status_parc.payment_type_description).
            jParcs:ADD("erpCompanyCode",tt_status_parc.erp_company_code).
            jParcs:ADD("costCenter",tt_status_parc.cost_center).
        
            jArrayParcelas:ADD(jParcs).
        END.

        jStatusPag:ADD("paymentItems",jArrayParcelas).
        jArrayStatusPag:ADD(jStatusPag).

        ASSIGN jPrincipal  = NEW JsonObject().
        ASSIGN oJsonObject = NEW JsonObject().
    
        oJsonObject:ADD("payload",jArrayStatusPag).
    END.
    ELSE DO:
        /* nao encontrou a nota */
        jsonOutput = JsonAPIResponseBuilder:OK(jsonInput, 404).
    END.

    IF  i-aux = 0 THEN 
        RETURN.

    RUN createJsonResponse(INPUT  oJsonObject, 
                           INPUT  TABLE RowErrors, 
                           INPUT  FALSE,
                           OUTPUT jsonOutput).   

END PROCEDURE. /* procedure pi-consulta-status-pag */
