/********************************************************************************
 ** UPC........: win090.p - UPC WRITE estrutura
 ** Data.......: Novembro / 2004
 ** Objetivo...: Repassa inclus‰es e modificaá‰es de documentos de entrada para a Base Oracle
 ** Vers∆o.....: 15/06/2005 - Mario Fleith - Criar um dÇbito na comiss∆o do respectivo 
                                             referente referente a devoluá‰es
 ********************************************************************************/

DEF PARAM BUFFER b-docum-est      FOR docum-est.
DEF PARAM BUFFER b-old-docum-est  FOR docum-est.

DEFINE VARIABLE i        AS INTEGER            NO-UNDO.
DEFINE VARIABLE l-transp AS LOGICAL INITIAL NO NO-UNDO.

/* Chamada UPC de Delete da Gati */
IF  SEARCH("trigger/upc-docum-est-w.p") <> ? OR
    SEARCH("trigger/upc-docum-est-w.r") <> ?
THEN
    RUN trigger/upc-docum-est-w.p (BUFFER b-docum-est,
                                   BUFFER b-old-docum-est).



DO  i = 1 TO 10:
    IF PROGRAM-NAME(i) = "imp/im7777.p":U OR 
       PROGRAM-NAME(i) = "imp/im9049.p" THEN DO:
        ASSIGN l-transp = YES.
        LEAVE.
    END.
END.

IF l-transp = YES THEN DO:

    FOR FIRST docum-est 
        WHERE docum-est.cod-estabel  = b-docum-est.cod-estabel 
          AND docum-est.serie-docto  = b-docum-est.serie-docto 
          AND docum-est.nat-operacao = b-docum-est.nat-operacao
          AND docum-est.cod-emitente = b-docum-est.cod-emitente
          AND docum-est.nro-docto    = b-docum-est.nro-docto :

        FOR FIRST int-mod-transp-importacao NO-LOCK
            WHERE int-mod-transp-importacao.cod-estabel  = docum-est.cod-estabel
              AND int-mod-transp-importacao.serie-docto  = docum-est.serie-docto
              AND int-mod-transp-importacao.nat-operacao = docum-est.nat-operacao:
    
            ASSIGN docum-est.nome-transp            = int-mod-transp-importacao.nome-transp
                   OVERLAY(docum-est.char-2,143,8)  = STRING(int-mod-transp-importacao.cod-modalid-frete).
        END.
        RELEASE int-mod-transp-importacao.
        ASSIGN l-transp = NO.
    END.
    RELEASE docum-est.
END.

IF  b-docum-est.esp-docto = 20 THEN DO:    

    /*  A T U A L I Z A Ä « O   D O S   E S T O Q U E  */
    IF  b-old-docum-est.CE-atual = NO AND b-docum-est.CE-atual = YES 
    THEN DO:

        FOR EACH item-doc-est OF b-docum-est NO-LOCK:
            IF item-doc-est.nro-comp   <> "" AND
               item-doc-est.serie-comp <> "" THEN DO:
                FIND nota-fiscal
                     WHERE nota-fiscal.cod-estabel = b-docum-est.cod-estabel
                       AND nota-fiscal.serie       = item-doc-est.serie-comp
                       AND nota-fiscal.nr-nota-fis = item-doc-est.nro-comp NO-LOCK NO-ERROR.
                
                /*Quando ainda n∆o ocorreu separaá∆o no WMS, indica que Ç uma devoluá∆o total com pr¢pria nota*/
                IF  AVAIL nota-fiscal AND nota-fiscal.dt-saida = ? THEN DO TRANS:
                    FOR EACH int-wms-nf-atualiz EXCLUSIVE-LOCK
                        WHERE int-wms-nf-atualiz.cod-estabel = nota-fiscal.cod-estabel
                          and int-wms-nf-atualiz.serie       = nota-fiscal.serie      
                          and int-wms-nf-atualiz.nr-nota-fis = nota-fiscal.nr-nota-fis:

                          DELETE int-wms-nf-atualiz.
                    END.
                END.
            END.
        END.

    END.

END.


/* DEF BUFFER b2_item_doc_est FOR item-doc-est.

DEF TEMP-TABLE tt_nf_repres NO-UNDO  
    FIELD v_nr_docto              LIKE item-doc-est.nro-comp /*Nota de Sa°da*/
    FIELD v_serie                 LIKE item-doc-est.serie-comp
    FIELD v_cdn_repres            LIKE repres_tit_acr.cdn_repres
    FIELD v_cdn_cliente           LIKE emscad.cliente.cdn_cliente
    FIELD v_num_id_tit_acr        LIKE tit_acr.num_id_tit_acr
    FIELD v_val_devol             AS   DECIMAL FORMAT ">>>,>>>,>>9.99"
    FIELD v_dat_trans             LIKE docum-est.dt-trans
    FIELD v_histor_dev            LIKE comis-deb-cred.historico
    FIELD v_val_perc_comis_repres LIKE repres_tit_acr.val_perc_comis_repres
    FIELD v_nro_docto             LIKE item-doc-est.nro-docto /*Nota de Entrada*/
    INDEX tt_nf_repres  is primary unique 
          v_nr_docto    ASCENDING 
          v_serie       ASCENDING 
          v_cdn_repres  ASCENDING.

FOR EACH tt_nf_repres EXCLUSIVE-LOCK:
    DELETE tt_nf_repres.
END.
*/

/*if b-docum-est.nat-operacao begins "1201" or
   b-docum-est.nat-operacao begins "1202" or
   b-docum-est.nat-operacao begins "2201" or
   b-docum-est.nat-operacao begins "2202" or
   b-docum-est.nat-operacao begins "2203" or
   b-docum-est.nat-operacao begins "3201" then do:

   run esp/es0669.p (input "yes",
                     "docum-est",
                     b-docum-est.serie-docto,
                     b-docum-est.nro-docto,
                     string(b-docum-est.cod-emitente,"999999"),
                     b-docum-est.nat-operacao,
                     "", "", "", "", "").
/*   /*MESSAGE 'b-docum-est.nat-operacao ' b-docum-est.nat-operacao VIEW-AS ALERT-BOX.*/
   RUN api_gera_comis-deb-cred. /*Mario Fleith(15/06/2005*/
  */ 
end.*/

RETURN "OK":U.

/* 
PROCEDURE api_gera_comis-deb-cred:

    DEF VAR v_dat_aux           LIKE comis-deb-cred.dt-movto   NO-UNDO.
    DEF VAR v-acordo-com-perc   LIKE acordo-com.perc    NO-UNDO.
    DEF VAR v-fator-comis       AS   DEC  INITIAL 0            NO-UNDO.
    
    FOR EACH b2_item_doc_est OF b-docum-est NO-LOCK:

        IF b2_item_doc_est.nro-comp = '' THEN NEXT. /*Mario Fleith - Nao gerar devolucao de comissoes para as NFs que nao estiverem no EMS(2005-08-01)*/
        
        FIND FIRST tit_acr NO-LOCK
           WHERE tit_acr.cod_estab = '101'
           AND   tit_acr.cod_espec_docto = 'DM'
           AND   tit_acr.cod_ser_docto = b2_item_doc_est.serie-comp
           AND   tit_acr.cod_tit_acr   = b2_item_doc_est.nro-comp  NO-ERROR.
        
        IF NOT AVAIL tit_acr THEN NEXT.

        FOR EACH repres_tit_acr NO-LOCK
            WHERE repres_tit_Acr.cod_estab      = tit_Acr.cod_estab
            AND   repres_tit_Acr.num_id_tit_acr = tit_acr.num_id_tit_acr
            AND   repres_tit_acr.val_perc_comis_repres > 0:

            FIND FIRST repres_financ NO-LOCK
                WHERE repres_financ.cod_empresa = tit_acr.cod_empresa
                AND   repres_financ.cdn_repres  = repres_tit_acr.cdn_repres NO-ERROR.
            IF NOT AVAIL repres_financ              OR
               repres_financ.log_pagto_bloqdo = YES THEN NEXT.
            
            FIND FIRST tt_nf_repres NO-LOCK
                WHERE tt_nf_repres.v_nr_docto    = b2_item_doc_est.nro-comp
                AND   tt_nf_repres.v_serie       = b2_item_doc_est.serie-comp
                AND   tt_nf_repres.v_cdn_repres  = repres_tit_acr.cdn_repres NO-ERROR.
            IF NOT AVAIL tt_nf_repres THEN DO:
               /*MESSAGE 'AVAIL tt_nf_repres ' AVAIL tt_nf_repres VIEW-AS ALERT-BOX.*/
               CREATE tt_nf_repres.
               ASSIGN tt_nf_repres.v_nr_docto              = b2_item_doc_est.nro-comp    
                      tt_nf_repres.v_serie                 = b2_item_doc_est.serie-comp  
                      tt_nf_repres.v_cdn_repres            = repres_tit_acr.cdn_repres
                      tt_nf_repres.v_dat_trans             = b-docum-est.dt-trans
                      tt_nf_repres.v_cdn_cliente           = tit_acr.cdn_cliente   
                      tt_nf_repres.v_num_id_tit_acr        = tit_acr.num_id_tit_acr  
                      tt_nf_repres.v_nro_docto             = b2_item_doc_est.nro-docto
                      tt_nf_repres.v_histor_dev            = 'Devol ref NFS ' + b2_item_doc_est.nro-comp + '. Devolvida em ' + STRING(tt_nf_repres.v_dat_trans,'99/99/99')
                      SUBSTRING(tt_nf_repres.v_histor_dev,52,20) = 'NFE ' + tt_nf_repres.v_nro_docto
                      tt_nf_repres.v_val_perc_comis_repres = repres_tit_acr.val_perc_comis_repres.
            END.
            ASSIGN tt_nf_repres.v_val_devol = tt_nf_repres.v_val_devol + b2_item_doc_est.preco-total[1].
        END.
    END. /*FOR EACH b2_item_doc_est OF b-docum-est NO-LOCK:*/
    
    FOR EACH tt_nf_repres NO-LOCK:

        FIND FIRST tit_acr NO-LOCK
          WHERE tit_acr.cod_estab = '101'
          AND   tit_acr.num_id_tit_acr = tt_nf_repres.v_num_id_tit_acr NO-ERROR.
        IF NOT AVAIL tit_acr THEN NEXT.

        FIND FIRST emscad.cliente NO-LOCK
            WHERE emscad.cliente.cod_empresa = tit_acr.cod_empresa 
            AND   emscad.cliente.cdn_cliente = tit_acr.cdn_cliente NO-ERROR.
        IF NOT AVAIL emscad.cliente THEN NEXT.
        
        FIND LAST comis-deb-cred NO-LOCK
            WHERE comis-deb-cred.cod-rep         = tt_nf_repres.v_cdn_repres
            AND   comis-deb-cred.cod-mov         = 18
            AND   MONTH(comis-deb-cred.dt-movto) = MONTH(tt_nf_repres.v_dat_trans) NO-ERROR.
        IF NOT AVAIL comis-deb-cred THEN 
           ASSIGN v_dat_aux = DATE ('01' + '/' + string(MONTH(tt_nf_repres.v_dat_trans)) + '/' + string(YEAR(tt_nf_repres.v_dat_trans))).
        ELSE
           ASSIGN v_dat_aux = comis-deb-cred.dt-movto + 1.
        FIND FIRST comis-deb-cred NO-LOCK
            WHERE comis-deb-cred.cod-rep    = tt_nf_repres.v_cdn_repres
            AND   comis-deb-cred.cod-mov    = 18
            AND   comis-deb-cred.dt-movto   = v_dat_aux
            AND   comis-deb-cred.base-final = YES NO-ERROR.

        IF NOT AVAIL comis-deb-cred THEN DO:
           
           IF cliente.num_pessoa MODULO 2 = 0 THEN
              ASSIGN v-acordo-com-perc = 0.
           ELSE DO:
              FIND FIRST pessoa_jurid NO-LOCK 
                 WHERE pessoa_jurid.num_pessoa_jurid = cliente.num_pessoa NO-ERROR.
              IF AVAIL pessoa_jurid THEN
                 RUN pi-calc-comis-acordo-com (output v-acordo-com-perc).
           END.   
           
           FIND FIRST comis-deb-cred NO-LOCK
               WHERE comis-deb-cred.cod-rep    = tt_nf_repres.v_cdn_repres
               AND   comis-deb-cred.cod-mov    = 18
               AND   comis-deb-cred.historico MATCHES ('*' + tt_nf_repres.v_nr_docto + '*')
               AND   comis-deb-cred.historico MATCHES ('*' + tt_nf_repres.v_nro_docto + '*') NO-ERROR.
           
           IF NOT AVAIL comis-deb-cred THEN DO:
              /*MESSAGE 'AVAIL comis-deb-cred ' AVAIL comis-deb-cred VIEW-AS ALERT-BOX.*/
              CREATE comis-deb-cred.
              ASSIGN comis-deb-cred.base-final = YES
                     comis-deb-cred.cod-mov    = 18
                     comis-deb-cred.cod-rep    = tt_nf_repres.v_cdn_repres
                     comis-deb-cred.ct-codigo  = 0
                     comis-deb-cred.deb-cred   = YES
                     comis-deb-cred.dt-movto   = v_dat_aux
                     comis-deb-cred.historico  = tt_nf_repres.v_histor_dev
                     comis-deb-cred.sc-codigo  = 0.
    
    
              IF v-acordo-com-perc = 0 THEN
                 ASSIGN v-fator-comis  = 1 /*Mario Fleith(15/06/2005) - No item-doc-est j† consta o valor liquido tit_acr.val_liq_tit_acr / tit_acr.val_origin_tit_acr*/
                        comis-deb-cred.valor = (((tt_nf_repres.v_val_devol * v-fator-comis) * tt_nf_repres.v_val_perc_comis_repres) / 100).
              ELSE
                 ASSIGN v-fator-comis  = 1 /*Mario Fleith(15/06/2005) - No item-doc-est j† consta o valor liquido tit_acr.val_liq_tit_acr / tit_acr.val_origin_tit_acr*/
                        comis-deb-cred.valor = ((((tt_nf_repres.v_val_devol * v-fator-comis) * (1 - v-acordo-com-perc / 100)) * (tt_nf_repres.v_val_perc_comis_repres / 100))).
             
           END. /*IF NOT AVAIL comis-deb-cred THEN DO:*/
        END.
    END.
END. /*PROCEDURE api_gera_comis-deb-cred:*/

PROCEDURE pi-calc-comis-acordo-com:
    
    DEF OUTPUT PARAM p_perc AS DECIMAL NO-UNDO.
    DEF VAR v_data LIKE tit_acr.dat_transacao.
    
    find first nota-fiscal NO-LOCK
        where nota-fiscal.nr-nota-fis = tit_acr.cod_tit_acr
          and nota-fiscal.cod-estabel = "101" 
          AND nota-fiscal.serie       = "3" no-error.
    if not avail nota-fiscal then
       find first nota-fiscal NO-LOCK 
        WHERE nota-fiscal.nr-nota-fis = tit_acr.cod_tit_acr
          AND nota-fiscal.cod-estabel = "101" 
          AND nota-fiscal.serie       = "1" no-error.
    
    find first ped-venda no-lock
        WHERE ped-venda.nome-abrev = nota-fiscal.nome-ab-cli 
          AND ped-venda.nr-pedcli  = nota-fiscal.nr-pedcli NO-ERROR.
    IF AVAIL ped-venda THEN
        ASSIGN v_data = ped-venda.dt-emissao. 
    ELSE
        ASSIGN v_data = tit_acr.dat_transacao.
    
    ASSIGN p_perc = 0. /* inicializaá∆o */
    
    FIND FIRST emscad.cliente NO-LOCK
        WHERE emscad.cliente.cdn_cliente = tit_acr.cdn_cliente NO-ERROR.
    IF AVAIL emscad.cliente THEN DO:
        if  emscad.cliente.num_pessoa modulo 2 <> 0
        then do:
            find pessoa_jurid
                where pessoa_jurid.num_pessoa_jurid = emscad.cliente.num_pessoa no-lock no-error.
            if  avail pessoa_jurid then do:
                FIND FIRST acordo-com 
                   WHERE acordo-com.cgc = substr(pessoa_jurid.cod_id_feder,1,2) +
                                          substr(pessoa_jurid.cod_id_feder,3,3) +
                                          substr(pessoa_jurid.cod_id_feder,6,3)
                     AND acordo-com.periodo = string(month(v_data),"99") + 
                                              string(year(v_data))
                                               NO-ERROR.
                IF AVAIL acordo-com THEN DO:
                
                    ASSIGN p_perc = acordo-com.perc.
                END.
            end.
        end.
        else do:
            find pessoa_fisic
                where pessoa_fisic.num_pessoa_fisic = emscad.cliente.num_pessoa no-lock no-error.
            if  avail pessoa_fisic then do:
        
                FIND FIRST acordo-com 
                   WHERE acordo-com.cgc = substr(pessoa_fisic.cod_id_feder,1,2) +
                                          substr(pessoa_fisic.cod_id_feder,3,3) +
                                          substr(pessoa_fisic.cod_id_feder,6,3)
                     AND acordo-com.periodo = string(month(v_data),"99") + 
                                              string(year(v_data))
                                               NO-ERROR.
                IF AVAIL acordo-com THEN DO:
                    ASSIGN p_perc = acordo-com.perc.
                END.
            end.
        end.               
    END.
END PROCEDURE. /*PROCEDURE pi-calc-comis-acordo-com:*/
   */
