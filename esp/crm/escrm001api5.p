/********************************************************************************
** Copyright Intelbras S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da Intelbras, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
/*{include/i-prgvrs.i <Nome do Programa> 2.00.00.000}  /*** 010000 ***/*/
/*******************************************************************************
**  Programa: ADEEDIT\(C).P
**  Objetivo: <comment>
**  Autor...: Intelbras - USER    
**  Data....: 19.05.2008 16:11
*******************************************************************************/






/* {utp/ut-glob.i} */

/* {esp/crm/escrm001.i} */

DEFINE TEMP-TABLE tt-atributo NO-UNDO
    FIELD r-temp-table AS ROWID
    FIELD nome-campo   AS CHARACTER
    FIELD nome-atrib   AS CHARACTER
    FIELD vl-atrib     AS CHARACTER
    INDEX id-campo AS PRIMARY UNIQUE
        r-temp-table
        nome-campo
        nome-atrib.

{esp/crm/escrm001.i1} /* Defini‡Æo das temp-tables de valida‡Æo - cdp/cdapi329.p */
    
{esp/crm/escrm001.i2} /* Defini‡Æo das temp-tables dos t¡tulos (EMS 5)  */

DEFINE TEMP-TABLE RowErrors NO-UNDO
    FIELD errorsequence     AS INTEGER
    FIELD errornumber       AS INTEGER
    FIELD errordescription  AS CHARACTER FORMAT "x(60)":U
    FIELD errorparameters   AS CHARACTER
    FIELD errortype         AS CHARACTER
    FIELD errorhelp         AS CHARACTER FORMAT "x(60)":U
    FIELD errorsubtype      AS CHARACTER.
def var h-acomp      as handle no-undo.
DEFINE VARIABLE i-cont AS INTEGER     NO-UNDO.
PROCEDURE piCarregaTitulo:
    DEFINE INPUT  PARAMETER pEntidade         AS CHARACTER   NO-UNDO.
    DEFINE OUTPUT PARAMETER pContaLinhasTrace AS INTEGER     NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    IF NOT VALID-HANDLE(h-acomp) THEN
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-inicializar IN h-acomp (INPUT "Integra‡Æo EMS X Microsoft CRM Dynamics":U).

    IF '{&ativar-envio}' = 'yes' THEN
        RUN piConnection.

    /* Excluir ao terminar - Sakae */
    /*ASSIGN  i-cont = 1.*/

    bk-tit_acr:
    FOR EACH tit_acr NO-LOCK:
        FOR EACH val_tit_acr OF tit_acr NO-LOCK
            WHERE val_tit_acr.cod_finalid_econ = "corrente":U:
            IF VALID-HANDLE(h-acomp) THEN
                RUN pi-acompanhar IN h-acomp (INPUT "T¡tulo Contas a Receber: ":U + STRING(tit_acr.cod_estab) + " - ":U + STRING(tit_acr.cod_espec_docto) + " - ":U + STRING(tit_acr.cod_ser_docto) + " - ":U + STRING(tit_acr.cod_tit_acr) + " - ":U + STRING(tit_acr.cod_parcela)).

            FIND FIRST emitente
                WHERE emitente.cod-emitente = tit_acr.cdn_cliente
                  AND emitente.identific    = 2 NO-LOCK NO-ERROR.

            IF AVAILABLE emitente THEN NEXT.

            /* Excluir ao terminar - Sakae */
            /*IF i-cont > 20 THEN LEAVE bk-tit_acr.*/
    
            /* Excluir ao terminar - Sakae */
            /*ASSIGN  i-cont = i-cont + 1.*/

            FIND FIRST unid_negoc
                WHERE unid_negoc.cod_unid_negoc = val_tit_acr.cod_unid_negoc NO-LOCK NO-ERROR.

            CREATE tt-tit_acr.
            ASSIGN tt-tit_acr.cod_modul              = "acr":U
                   tt-tit_acr.cod_estab              = tit_acr.cod_estab
                   tt-tit_acr.cdn_clien_fornec       = tit_acr.cdn_cliente
                   tt-tit_acr.cod_espec_docto        = tit_acr.cod_espec_docto
                   tt-tit_acr.cod_ser_docto          = tit_acr.cod_ser_docto
                   tt-tit_acr.cod_tit                = tit_acr.cod_tit_acr
                   tt-tit_acr.cod_parcela            = tit_acr.cod_parcela
                   tt-tit_acr.cod_unid_negoc         = IF AVAILABLE unid_negoc THEN unid_negoc.des_unid_negoc ELSE val_tit_acr.cod_unid_negoc
                   tt-tit_acr.num_id_tit             = tit_acr.num_id_tit
                   tt-tit_acr.cdn_repres             = tit_acr.cdn_repres
                   tt-tit_acr.ind_tip_espec_docto    = tit_acr.ind_tip_espec_docto
                   tt-tit_acr.dat_emis_docto         = tit_acr.dat_emis_docto
                   tt-tit_acr.dat_vencto_origin_tit  = tit_acr.dat_vencto_origin_tit
                   tt-tit_acr.dat_vencto_tit         = tit_acr.dat_vencto_tit
                   tt-tit_acr.dat_indcao_perda_dedut = tit_acr.dat_indcao_perda_dedut
                   tt-tit_acr.dat_ult_liquidac_tit   = tit_acr.dat_ult_liquidac_tit
                   tt-tit_acr.cod_indic_econ         = tit_acr.cod_indic_econ
                   tt-tit_acr.val_origin_tit         = val_tit_acr.val_origin_tit
                   tt-tit_acr.val_sdo_tit            = val_tit_acr.val_sdo_tit
                   tt-tit_acr.log_tit_estordo        = tit_acr.log_tit_acr_estordo
                   tt-tit_acr.log_sdo_tit            = tit_acr.log_sdo_tit
                   tt-tit_acr.log_tit_acr_cobr_bcia  = tit_acr.log_tit_acr_cobr_bcia
                   tt-tit_acr.cod_portador           = tit_acr.cod_portador
                   tt-tit_acr.cod_cart_bcia          = tit_acr.cod_cart_bcia
                   tt-tit_acr.cod_tit_acr_bco        = tit_acr.cod_tit_acr_bco
                   tt-tit_acr.new_name               = STRING(tit_acr.cod_tit_acr) + "-":U + STRING(tit_acr.cod_parcela)
                   tt-tit_acr.new_chaveintegracao    = STRING(tit_acr.cod_estab) + ",":U + STRING(tit_acr.cod_espec_docto) + ",":U + STRING(tit_acr.cod_ser_docto) + ",":U + STRING(tit_acr.cod_tit_acr) + ",":U + STRING(tit_acr.cod_parcela)
                   pContaLinhasTrace                 = pContaLinhasTrace + 1.

            RUN InsertIntegrationLog (INPUT  "fromERP":U,
                                      INPUT  pEntidade,
                                      INPUT  "W":U,
                                      INPUT  "0":U,
                                      INPUT  BUFFER tt-tit_acr:HANDLE,
                                      INPUT  TABLE tt-atributo,
                                      OUTPUT TABLE RowErrors).

            EMPTY TEMP-TABLE tt-tit_acr.
        END.
    END.

    /* Excluir ao terminar - Sakae */
    ASSIGN  i-cont = 1.
    
    bk-tit_ap:
    FOR EACH tit_ap NO-LOCK:
        FOR EACH val_tit_ap OF tit_ap NO-LOCK
            WHERE val_tit_ap.cod_finalid_econ = "corrente":U:
            IF VALID-HANDLE(h-acomp) THEN
                RUN pi-acompanhar IN h-acomp (INPUT "T¡tulo Contas a Pagar: ":U + STRING(tit_ap.cod_estab) + ",":U + STRING(tit_ap.cdn_fornecedor) + ",":U + STRING(tit_ap.cod_espec_docto) + ",":U + STRING(tit_ap.cod_ser_docto) + ",":U + STRING(tit_ap.cod_tit_ap) + ",":U + STRING(tit_ap.cod_parcela)).

            FIND FIRST emitente
                WHERE emitente.cod-emitente = tit_ap.cdn_fornecedor
                  AND emitente.identific    = 2 NO-LOCK NO-ERROR.

            IF AVAILABLE emitente THEN NEXT.

            /* Excluir ao terminar - Sakae */
            IF i-cont > 20 THEN LEAVE bk-tit_ap.
    
            /* Excluir ao terminar - Sakae */
            ASSIGN  i-cont = i-cont + 1.

            FIND FIRST unid_negoc
                WHERE unid_negoc.cod_unid_negoc = val_tit_ap.cod_unid_negoc NO-LOCK NO-ERROR.

            CREATE tt-tit_ap.
            ASSIGN tt-tit_ap.cod_modul              = "apb":U
                   tt-tit_ap.cod_estab              = tit_ap.cod_estab
                   tt-tit_ap.cdn_clien_fornec       = tit_ap.cdn_fornecedor
                   tt-tit_ap.cod_espec_docto        = tit_ap.cod_espec_docto
                   tt-tit_ap.cod_ser_docto          = tit_ap.cod_ser_docto
                   tt-tit_ap.cod_tit                = tit_ap.cod_tit_ap
                   tt-tit_ap.cod_parcela            = tit_ap.cod_parcela
                   tt-tit_ap.cod_unid_negoc         = IF AVAILABLE unid_negoc THEN unid_negoc.des_unid_negoc ELSE val_tit_ap.cod_unid_negoc
                   tt-tit_ap.num_id_tit             = tit_ap.num_id_tit
                   tt-tit_ap.ind_tip_espec_docto    = tit_ap.ind_tip_espec_docto
                   tt-tit_ap.dat_emis_docto         = tit_ap.dat_emis_docto
                   tt-tit_ap.dat_vencto_tit         = tit_ap.dat_vencto_tit
                   tt-tit_ap.dat_ult_liquidac_tit   = tit_ap.dat_liquidac_tit_ap
                   tt-tit_ap.cod_indic_econ         = tit_ap.cod_indic_econ
                   tt-tit_ap.val_origin_tit         = val_tit_ap.val_origin_tit
                   tt-tit_ap.val_sdo_tit            = val_tit_ap.val_sdo_tit
                   tt-tit_ap.log_tit_estordo        = tit_ap.log_tit_ap_estordo
                   tt-tit_ap.log_sdo_tit            = tit_ap.log_sdo_tit
                   tt-tit_ap.cod_portador           = tit_ap.cod_portador
                   tt-tit_ap.new_name               = STRING(tit_ap.cod_tit_ap) + "-":U + STRING(tit_ap.cod_parcela)
                   tt-tit_ap.new_chaveintegracao    = STRING(tit_ap.cod_estab) + ",":U + STRING(tit_ap.cdn_fornecedor) + ",":U + STRING(tit_ap.cod_espec_docto) + ",":U + STRING(tit_ap.cod_ser_docto) + ",":U + STRING(tit_ap.cod_tit_ap) + ",":U + STRING(tit_ap.cod_parcela)
                   pContaLinhasTrace                = pContaLinhasTrace + 1.

            RUN InsertIntegrationLog (INPUT  "fromERP":U,
                                      INPUT  pEntidade,
                                      INPUT  "W":U,
                                      INPUT  "0":U,
                                      INPUT  BUFFER tt-tit_ap:HANDLE,
                                      INPUT  TABLE tt-atributo,
                                      OUTPUT TABLE RowErrors).

            EMPTY TEMP-TABLE tt-tit_ap.
        END.
    END.

    IF '{&ativar-envio}' = 'yes' THEN
        RUN piCloseConnection.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-finalizar IN h-acomp.
END PROCEDURE.
