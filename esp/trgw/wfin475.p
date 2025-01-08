/*** Historico de alteraá∆o *******/
/**Alteraá∆o: 09/03/2005 - Maria Ester 
   Trigger tabela movto_tit_acr
   Motivo...: Eliminado a trans. AVMN, ser† tratado na trigger WFIN452 devido ao processo do acordo comercial
****/   


        
/******* UM QUANDO TIVER TEMPO TROCAR O NOME DESTE PROGRAMA PARA WFIN476 POIS O NUMERO DE 
         DUMP ESTA ERRADO... O CORRETO ê WFIN0476 **********************/
         
DEF BUFFER b2-movto_tit_acr FOR movto_tit_acr.
DEF BUFFER b2-tit_acr       FOR tit_acr.
DEF BUFFER b3tit_acr        FOR tit_acr.
DEF BUFFER b4tit_acr        FOR tit_acr.
DEF BUFFER brepres_tit_acr  FOR repres_tit_acr.

DEF PARAM BUFFER b-movto_tit_acr     FOR movto_tit_acr.
DEF PARAM BUFFER b-old-movto_tit_acr FOR movto_tit_acr.

    /***DEF VAR c_lista_trans  AS CHAR INIT "AVMA,DEV,EVMA,EVMN,ESTT,LQPD,ELIQ,LQRN,ELQR"   NO-UNDO. em 30/03/2005 ***/
DEF VAR c_lista_trans  AS CHAR INIT "AVMA,DEV,EVMA,EVMN,REN,EREN,ESTT,LQPD,ELIQ,LQRN,ELQR,AVCR"  NO-UNDO.

DEF VAR v_num_cont_acr   AS INTEGER                 NO-UNDO.
DEF VAR v_log_achou_acr  AS LOGICAL                 NO-UNDO.
DEF VAR v_log_achou_702  AS LOGICAL                 NO-UNDO.
DEF VAR v_num_cont_fgl   AS INTEGER                 NO-UNDO.
DEF VAR v_log_achou_fgl  AS LOGICAL                 NO-UNDO.
DEF VAR v_baixa_an_devol AS LOGICAL INITIAL NO      NO-UNDO.
DEF VAR v_cod_refer      AS CHAR                    NO-UNDO. 
DEF VAR c-ser-docto      LIKE tit_ap.cod_ser_docto  NO-UNDO.

/* gera nr bancario */
DEF VAR v_prox_boleto   AS CHAR                    NO-UNDO.
DEF VAR v_tamanho_bloq  AS INTEGER                 NO-UNDO.
DEF VAR v_formato       AS CHAR                    NO-UNDO.
DEF VAR v_boleto_digito AS CHAR                    NO-UNDO.
DEF VAR v_boleto        AS CHAR                    NO-UNDO.
DEF VAR v_oper          AS CHAR                    NO-UNDO.
DEF VAR v_char_1        LIKE mgcad.portador.char-1 NO-UNDO.
DEF VAR v_num_bloq      AS CHAR FORMAT "X(256)":U  NO-UNDO.
DEF VAR v_seq_boleto    AS INT FORMAT "99999"      NO-UNDO.
DEF VAR v_digito        AS CHAR                    NO-UNDO.
DEF VAR i-multiplicador AS INT INIT 1              NO-UNDO.
DEF VAR i-acum          AS INT                     NO-UNDO.
DEF VAR i-divisao       AS INT                     NO-UNDO.
DEF VAR i-digito        AS INT                     NO-UNDO.
DEF VAR i-resto         AS INT                     NO-UNDO.
DEF VAR i-tamanho       AS INT                     NO-UNDO.
DEF VAR i-cont          AS INT                     NO-UNDO.
DEF VAR c-number        AS CHAR                    NO-UNDO.
DEF VAR c-numero1       AS CHAR                    NO-UNDO.

DEF NEW GLOBAL SHARED VAR v_cod_usuar_corren AS CHARACTER FORMAT "x(12)":U LABEL "Usu†rio Corrente" COLUMN-LABEL "Usu†rio Corrente" NO-UNDO. 
DEF NEW GLOBAL SHARED VAR v_cod_empres_usuar AS CHARACTER FORMAT "x(3)":U  LABEL "Empresa"          COLUMN-LABEL "Empresa"          NO-UNDO. 
DEF NEW GLOBAL SHARED VAR v_cod_estab_usuar  AS CHARACTER FORMAT "x(3)":U  LABEL "Estabelecimento"  COLUMN-LABEL "Estab"            NO-UNDO. 

DEF TEMP-TABLE tt_erro NO-UNDO
     FIELD cod_estab               LIKE tit_acr.cod_estab                        
     FIELD cod_especie             LIKE tit_acr.cod_espec_docto                        
     FIELD serie                   LIKE tit_acr.cod_ser_docto                              
     FIELD cod_tit_acr             LIKE tit_acr.cod_tit_acr                              
     FIELD cod_parcela             LIKE tit_acr.cod_parcela                              
     FIELD cdn_repres              LIKE tit_acr.cdn_repres                               
     FIELD nom_repres              LIKE representante.nom_abrev                          
     FIELD dat_transacao           LIKE movto_tit_acr.dat_transacao                      
     FIELD trans_abrev             LIKE movto_tit_acr.ind_trans_acr_abrev                
     FIELD cod_refer               LIKE movto_tit_acr.num_id_movto_tit_acr 
     FIELD vlr_trans               LIKE movto_tit_acr.val_movto_tit_acr                  
     FIELD mensagem                AS CHAR FORMAT "x(145)".

{esp/es0018.i}

FOR EACH tt_erro:
    DELETE tt_erro.
END.

/* Temp-table API Alteracao titulo */
{esp/cms/apb900zd.i} 
{esp/cms/apb768za.i} 
{esp/cms/apb767zc.i} 
 
/* Gera numero bancario para portadores parametrizados ao implantar novos titulos - Inicio */
IF  NEW b-movto_tit_acr THEN DO:
    
    IF  b-movto_tit_acr.ind_trans_acr = "Implantaá∆o" 
    OR  b-movto_tit_acr.ind_trans_acr = "Renegociaá∆o" THEN DO:

        FIND FIRST tit_acr OF b-movto_tit_acr EXCLUSIVE-LOCK NO-ERROR.

        IF  AVAIL tit_acr
        AND tit_acr.ind_tip_espec_docto = "Normal" THEN DO:
            RUN esp/es0018p.p (INPUT "num-bancario",
                               INPUT 1,
                               INPUT 0,
                               INPUT "",
                               OUTPUT TABLE tt-prog-ponto) NO-ERROR.

            IF  CAN-FIND (FIRST tt-prog-ponto
                             WHERE ENTRY(1,tt-prog-ponto.conteudo,";") = STRING(tit_acr.cod_portador)
                             AND   ENTRY(2,tt-prog-ponto.conteudo,";") = STRING(tit_acr.cod_cart_bcia)) THEN DO:

                 FIND FIRST trad_org_ext
                      WHERE trad_org_ext.cod_matriz_trad_org_ext = "EMS"
                      AND   trad_org_ext.cod_tip_unid_organ      = "998"
                      AND   trad_org_ext.cod_unid_organ          = tit_acr.cod_empresa NO-LOCK NO-ERROR.

                 IF  AVAIL trad_org_ext THEN DO:

                     FIND matriz_trad_portad_ext NO-LOCK 
                          WHERE matriz_trad_portad_ext.cod_matriz_trad_portad_ext = trad_org_ext.cod_matriz_trad_portad_ext NO-ERROR. 

                     IF  AVAIL matriz_trad_portad_ext THEN DO:

                         FIND FIRST trad_portad_ext NO-LOCK 
                              WHERE trad_portad_ext.cod_matriz_trad_portad_ext = matriz_trad_portad_ext.cod_matriz_trad_portad_ext
                              AND   trad_portad_ext.cod_portador               = tit_acr.cod_portador
                              AND   trad_portad_ext.cod_cart_bcia              = tit_acr.cod_cart_bcia NO-ERROR.

                         IF  AVAIL trad_portad_ext THEN
                             RUN pi-busca-numero (INPUT trad_portad_ext.cod_portad_ext,
                                                  INPUT trad_portad_ext.cod_modalid_ext).
                     END.
                 END.
            END.
            ELSE DO:
                ASSIGN v_prox_boleto = "".

                RUN esp/es0018p.p (INPUT "num-bancario",
                                   INPUT 2,
                                   INPUT 0,
                                   INPUT "",
                                   OUTPUT TABLE tt-prog-ponto) NO-ERROR.

                IF  CAN-FIND (FIRST tt-prog-ponto
                                 WHERE ENTRY(1,tt-prog-ponto.conteudo,";") = string(tit_acr.cod_portador)
                                 AND   ENTRY(2,tt-prog-ponto.conteudo,";") = string(tit_acr.cod_cart_bcia)) THEN DO:

                    FOR EACH tt-prog-ponto
                        WHERE ENTRY(1,tt-prog-ponto.conteudo,";") = string(tit_acr.cod_portador)
                        AND   ENTRY(2,tt-prog-ponto.conteudo,";") = string(tit_acr.cod_cart_bcia):

                        find first trad_org_ext
                             where trad_org_ext.cod_matriz_trad_org_ext = "EMS"
                               and trad_org_ext.cod_tip_unid_organ      = "998"
                               and trad_org_ext.cod_unid_organ          = tit_acr.cod_empresa no-lock no-error.

                        if  avail trad_org_ext then do:

                            find matriz_trad_portad_ext no-lock 
                                 where matriz_trad_portad_ext.cod_matriz_trad_portad_ext = trad_org_ext.cod_matriz_trad_portad_ext no-error. 

                            if  avail matriz_trad_portad_ext then do:

                                find first trad_portad_ext no-lock 
                                     where trad_portad_ext.cod_matriz_trad_portad_ext = matriz_trad_portad_ext.cod_matriz_trad_portad_ext
                                     AND   trad_portad_ext.cod_portador               = tit_acr.cod_portador
                                     and   trad_portad_ext.cod_cart_bcia              = tit_acr.cod_cart_bcia no-error.

                                if  avail trad_portad_ext then DO:
                                    find first mgcad.portador
                                         where mgcad.portador.ep-codigo    = tit_acr.cod_empresa
                                         and   mgcad.portador.cod-portador = int(trad_portad_ext.cod_portad_ext)
                                         and   mgcad.portador.modalidade   = int(trad_portad_ext.cod_modalid_ext) exclusive-LOCK no-error.

                                    if  avail mgcad.portador THEN DO:
                                        ASSIGN mgcad.portador.int-4 = mgcad.portador.int-4 + 1
                                               v_seq_boleto         = mgcad.portador.int-4.
                                        
                                        ASSIGN v_prox_boleto = ENTRY(4,tt-prog-ponto.conteudo,";") + ENTRY(6,tt-prog-ponto.conteudo,";") +
                                                               ENTRY(5,tt-prog-ponto.conteudo,";") + ENTRY(8,tt-prog-ponto.conteudo,";") /* ano */ +
                                                               ENTRY(7,tt-prog-ponto.conteudo,";") + STRING(v_seq_boleto,"99999").

                                        RELEASE mgcad.portador.
                                    END.
                                END.
                            END.
                        END.
                    END.
                END.

                IF  v_prox_boleto <> "" THEN DO:
                    RUN pi-calcula-digito-11-sicredi.

                    ASSIGN tit_acr.cod_tit_acr_bco = SUBSTR(v_prox_boleto,12,8) + v_digito.
                END.
            END.

            RELEASE tit_acr.
        END.
    END.
END.
/* Gera numero bancario para portadores parametrizados ao implantar novos titulos - Final */

ASSIGN v_num_cont_acr  = 1
       v_log_achou_acr = NO
       v_log_achou_702 = NO.

run esp/es0669.p (input "yes", 
                        "emitente", 
                        string(b-movto_tit_acr.cdn_cliente,"999999999"),
                        "", "", "", "", "", "", "", "").
bloco_acr:
REPEAT:
    /**** DEMONSTRATIVO CONTµBIL ******/
    if  index(program-name(v_num_cont_acr),'prgfin/acr/acr707ra.py') = ? then do:
        LEAVE bloco_acr.
    END.
    
    if  index(program-name(v_num_cont_acr),'prgfin/acr/acr707ra.py') <> 0 then do:
        assign v_log_achou_acr = yes.
        leave bloco_acr.
    end.

    if  v_num_cont_acr = 30 then
        leave bloco_acr.
    
    ASSIGN v_num_cont_acr = v_num_cont_acr + 1.
END.

ASSIGN v_num_cont_fgl  = 1
       v_log_achou_fgl = NO.

bloco_fgl:
REPEAT:
    /* prgfin/acr/acr705za.py */
    /* prgfin/fgl/fgl702aa.p  */
    /**** Manutená∆o lanáamentos cont†beis ****/
    if  index(program-name(v_num_cont_fgl),'prgfin/fgl/fgl702aa.p') = ? then do:
        LEAVE bloco_fgl.
    END.

    if  index(program-name(v_num_cont_fgl),'prgfin/fgl/fgl702aa.p') <> 0 then do:
        assign v_log_achou_fgl = yes.
        leave bloco_fgl.
    end.
    
    if  v_num_cont_fgl = 30 then
        leave bloco_fgl.

    ASSIGN v_num_cont_fgl = v_num_cont_fgl + 1.
END.

IF  v_log_achou_acr = NO
AND v_log_achou_fgl = NO THEN DO:

    FIND FIRST tit_acr OF b-movto_tit_acr NO-LOCK NO-ERROR.                               
  
    IF  tit_acr.cod_espec_docto = "dm" then  
        ASSIGN c-ser-docto = tit_acr.cod_ser_docto.
    ELSE                                    
        ASSIGN c-ser-docto = tit_acr.cod_espec_docto.
  
    IF  tit_acr.cod_espec_docto            = "vd" 
    AND b-movto_tit_acr.ind_trans_acr_abre = "impl" THEN DO:
        FIND FIRST b4tit_acr NO-LOCK
            WHERE b4tit_acr.cod_estab       = tit_acr.cod_estab
            AND   b4tit_acr.cod_espec_docto = "ve"
            AND   b4tit_acr.cod_ser_docto   = tit_acr.cod_ser_docto
            AND   b4tit_acr.cod_tit_acr     = tit_acr.cod_tit_acr
            AND   b4tit_acr.cod_parcela     = tit_acr.cod_parcela NO-ERROR.
      
        FIND FIRST repres_tit_acr NO-LOCK                                                                                              
            WHERE repres_tit_acr.cod_estab      = b4tit_acr.cod_estab                                                            
            AND   repres_tit_acr.num_id_tit_acr = b4tit_acr.num_id_tit_acr NO-ERROR.
     
        IF  AVAIL repres_tit_acr THEN DO:
            FOR EACH brepres_tit_acr                                                                                               
                WHERE brepres_tit_acr.cod_estab      = tit_acr.cod_estab                                                            
                AND   brepres_tit_acr.num_id_tit_acr = tit_acr.num_id_tit_acr:
            
                ASSIGN brepres_tit_acr.val_perc_comis_repres = repres_tit_acr.val_perc_comis_repres.
            END.
        END.
    END.

    FOR EACH repres_tit_acr NO-LOCK                                                                                              
        WHERE repres_tit_acr.cod_estab             = tit_acr.cod_estab                                                            
        AND   repres_tit_acr.num_id_tit_acr        = tit_acr.num_id_tit_acr
        AND   repres_tit_acr.val_perc_comis_repres > 0:
    
        FIND FIRST representante NO-LOCK
            WHERE representante.cod_empresa = repres_tit_acr.cod_empresa
            AND   representante.cdn_repres  = repres_tit_acr.cdn_repres NO-ERROR.

        /*Valida Representante - Mario Fleith 02/06/2005*/
        FIND FIRST repres_financ OF representante NO-LOCK
            WHERE repres_financ.log_pagto_bloqdo = YES NO-ERROR.
    
        IF  AVAIL repres_financ THEN
            LEAVE.
    
        /*valida portador*/
        FIND FIRST int-portador NO-LOCK
            WHERE int-portador.cod_portador           = tit_acr.cod_portador
            AND   int-portador.log_considera_comissao = YES NO-ERROR.
    
        IF  NOT AVAIL int-portador THEN
            LEAVE.
    
        /*Pesquisa relacionamento entre fornecedor x representante*/                      
        FIND FIRST emscad.fornecedor NO-LOCK 
            WHERE emscad.fornecedor.cod_empresa = representante.cod_empresa 
            AND   emscad.fornecedor.num_pessoa  = representante.num_pessoa 
            USE-INDEX frncdr_empr_pessoa NO-ERROR.

        IF (b-movto_tit_acr.ind_trans_acr_abrev = "IMPL" 
        OR  b-movto_tit_acr.ind_trans_acr_abrev = "REN") 
        AND tit_acr.ind_tip_espec_docto         = "Normal" THEN DO:
      
            FIND FIRST tit_ap NO-LOCK                                                                                                 
                WHERE tit_ap.cod_estab       = tit_acr.cod_estab                                                                     
                AND   tit_ap.cdn_fornecedor  = emscad.fornecedor.cdn_fornecedor                                                        
                AND   tit_ap.cod_espec_docto = "CPE"                                                                                 
                AND   tit_ap.cod_ser_docto   = c-ser-docto
                AND   tit_ap.cod_tit_ap      = tit_acr.cod_tit_acr                                                                   
                AND   tit_ap.cod_parcela     = tit_acr.cod_parcela NO-ERROR.                                                                   
      
            IF  NOT AVAIL tit_ap THEN DO:
                /*Cria CPE*/
                RUN esp/cms/escms001.p (RECID(b-movto_tit_acr),         
                                        INPUT "").                     
            END.
        END.
        ELSE
            IF  b-movto_tit_acr.ind_trans_acr_abrev = "LIQ" 
            OR  b-movto_tit_acr.ind_trans_acr_abrev = "LQEC" THEN DO:
              
                FIND FIRST b2-movto_tit_acr NO-LOCK USE-INDEX mvtttcr_movto_pai
                    WHERE b2-movto_tit_acr.cod_estab_tit_acr_pai    = b-movto_tit_acr.cod_estab 
                    AND   b2-movto_tit_acr.num_id_movto_tit_acr_pai = b-movto_tit_acr.num_id_movto_tit_acr NO-ERROR.
        
                IF  AVAIL b2-movto_tit_acr THEN DO:
                    FIND FIRST b2-tit_acr OF b2-movto_tit_acr NO-LOCK NO-ERROR.
                 
                    IF  AVAIL b2-tit_acr THEN DO:
                        IF  b2-tit_acr.ind_orig_tit_acr = 'Rec' 
                        OR  b2-tit_acr.cod_portador     = '' THEN
                            ASSIGN v_baixa_an_devol = YES.
                        ELSE DO:
                           FIND FIRST relacto_tit_acr NO-LOCK                                                            
                               WHERE relacto_tit_acr.cod_estab_tit_acr_pai = b2-movto_tit_acr.cod_estab               
                               AND   relacto_tit_acr.num_id_tit_acr_pai    = b2-movto_tit_acr.num_id_tit_Acr NO-ERROR.
                           
                           IF  AVAIL relacto_tit_acr THEN DO:                                                             
                               FIND FIRST b3tit_acr NO-LOCK                                                               
                                   WHERE b3tit_acr.cod_estab           = relacto_tit_acr.cod_estab                         
                                   AND   b3tit_acr.num_id_tit_acr      = relacto_tit_acr.num_id_tit_acr                    
                                   AND   b3tit_acr.ind_tip_espec_docto = 'Nota de CrÇdito' NO-ERROR.                       
                              
                               IF  AVAIL b3tit_acr THEN
                                   ASSIGN v_baixa_an_devol = YES.
                               ELSE
                                   ASSIGN v_baixa_an_devol = NO.
                           END.
                        END.
                    END.
                    ELSE
                        ASSIGN v_baixa_an_devol = NO.
                END.
      
                FIND FIRST tit_ap NO-LOCK                                                                                                
                    WHERE tit_ap.cod_estab                     = tit_acr.cod_estab                                                                     
                    AND   tit_ap.cdn_fornecedor                = emscad.fornecedor.cdn_fornecedor                                                        
                    AND   tit_ap.cod_espec_docto               = "CPO"                                                                                 
                    AND   tit_ap.cod_ser_docto                 = c-ser-docto
                    AND   SUBSTR(tit_ap.cod_tit_ap,1,INDEX(tit_ap.cod_tit_ap,"-") - 1) = tit_acr.cod_tit_acr  
                    AND   tit_ap.cod_parcela                   = tit_acr.cod_parcela 
                    AND   SUBSTR(STRING(tit_ap.cod_refer),2,9) = SUBSTR(STRING(b-movto_tit_acr.num_id_movto_tit_acr,"9999999999"),2,9) NO-ERROR.   
        
                IF  NOT AVAIL tit_ap THEN DO:
                    RUN esp/cms/escms001.p (RECID(b-movto_tit_acr),
                                            INPUT "").                     
                END.
            END.
            ELSE
                /*Trata as demais transaá‰es que ocorrem no t°tulo*/    
                IF  LOOKUP(b-movto_tit_acr.ind_trans_acr_abrev,c_lista_trans) <> 0 THEN DO:
                   
                    /*N∆o efetua transaá∆o AVA para CPE referente a negociaá‰a em Vendor
                     mas faz no estorno da baixa para vendor debitado */
                    IF   tit_acr.ind_tip_espec_docto          = "Vendor" 
                    AND (b-movto_tit_acr.ind_trans_acr_abrev <> 'ELIQ' 
                    AND  b-movto_tit_acr.ind_trans_acr_abrev <> 'ESTT' 
                    AND  b-movto_tit_acr.ind_trans_acr_abrev <> 'EVMN') THEN
                        LEAVE.
              
                    /*Pesquisa o tit_ap para enviar dados a temp-table da API - alteraá∆o da CPE conforme a transaá∆o*/
                    FIND FIRST tit_ap NO-LOCK
                        WHERE tit_ap.cod_estab       = tit_acr.cod_estab
                        AND   tit_ap.cdn_fornecedor  = emscad.fornecedor.cdn_fornecedor
                        AND   tit_ap.cod_espec_docto = "CPE" 
                        AND   tit_ap.cod_ser_docto   = c-ser-docto
                        AND   tit_ap.cod_tit_ap      = tit_acr.cod_tit_acr
                        AND   tit_ap.cod_parcela     = tit_acr.cod_parcela NO-ERROR.
                   
                    IF  AVAIL tit_ap THEN DO:
                        FIND FIRST movto_tit_ap OF tit_ap 
                            WHERE SUBSTR(STRING(movto_tit_ap.cod_refer),2,9) = SUBSTR(STRING(b-movto_tit_acr.num_id_movto_tit_acr,'9999999999'),2,9) 
                            AND NOT movto_tit_ap.LOG_movto_estordo  NO-ERROR.          
            
                        IF  NOT AVAIL movto_tit_ap THEN DO:
                            RUN esp/cms/escms002.p (INPUT RECID(b-movto_tit_acr),
                                                    INPUT "").
                        END.
                    END.
                END.
                ELSE
                    /***** Faz a movimentaá∆o de ava menor para vendor,
                     porÇm os movimento de despesa de IOF e receita de equalizaá∆o
                     tambÇm geram ava maior e menor por isso o teste 
                     movto_tit_acr.val_movto_tit_acr <> 0   ********/
            
                    IF  b-movto_tit_acr.ind_trans_acr_abrev = "avmn" 
                    AND tit_acr.ind_tip_espec_docto         = "Vendor" 
                    AND b-movto_tit_acr.val_movto_tit_acr  <> 0 THEN DO:
                        RUN esp/cms/escms005.p (INPUT RECID(b-movto_tit_acr),
                                                INPUT "",
                                                INPUT "").
                    END.
    END. /*for each repres_tit_acr*/
END.
    
RETURN 'OK'.

PROCEDURE pi-referencia :
    
    DEF OUTPUT PARAM p_cod_refer LIKE movto_tit_ap.cod_refer NO-UNDO.

    DEF VAR v_data_aux  AS CHAR            NO-UNDO.
    DEF VAR v_num_aux   AS INTEGER         NO-UNDO. 
    DEF VAR v_num_aux_2 AS INTEGER         NO-UNDO. 
    DEF VAR v_num_cont  AS INTEGER         NO-UNDO. 
    DEF VAR v_cod_refer  LIKE movto_tit_ap.cod_refer NO-UNDO.

    REPEAT:
      ASSIGN v_cod_refer = ''                                                                                                                                         
             v_num_aux_2 = integer(this-procedure:handle)                                                                                                                  
             v_num_aux   = (random(0,v_num_aux_2) mod 26) + 97                                                                                                             
             v_cod_refer = v_cod_refer + chr(v_num_aux).
      
      FIND FIRST tt_tit_ap_alteracao_base_1 NO-LOCK                                                                                                                        
           WHERE tt_tit_ap_alteracao_base_1.tta_cod_estab = tit_acr.cod_estab                                                                                              
             AND tt_tit_ap_alteracao_base_1.ttv_cod_refer = SUBSTRING(v_cod_refer,1,1) + SUBSTR(STRING(b-movto_tit_acr.num_id_movto_tit_acr,'9999999999'),2,9) no-error.
      FIND FIRST movto_tit_ap                                                                                                                                              
           WHERE movto_tit_ap.cod_estab = tit_acr.cod_estab                                                                                                                
             AND movto_tit_ap.cod_refer =  SUBSTRING(v_cod_refer,1,1) + SUBSTR(STRING(b-movto_tit_acr.num_id_movto_tit_acr,'9999999999'),2,9) no-lock no-error.         
      IF NOT AVAIL movto_tit_ap AND NOT AVAIL tt_tit_ap_alteracao_base_1 THEN                                                                                              
         LEAVE.
    END.
    ASSIGN p_cod_refer = SUBSTRING(v_cod_refer,1,1) + SUBSTR(STRING(b-movto_tit_acr.num_id_movto_tit_acr,'9999999999'),2,9).
    
END PROCEDURE.

PROCEDURE elim_tt:
   FOR EACH tt_tit_ap_alteracao_base_1:
       DELETE tt_tit_ap_alteracao_base_1.
   END.

   FOR EACH tt_tit_ap_alteracao_rateio:
       DELETE tt_tit_ap_alteracao_rateio.
   END.

   FOR EACH tt_log_erros_tit_ap_alteracao:
       DELETE tt_log_erros_tit_ap_alteracao.
   END.
END.

PROCEDURE roda_api:
    
    FIND FIRST tt_tit_ap_alteracao_base_1 NO-LOCK NO-ERROR.                    

    IF AVAIL tt_tit_ap_alteracao_base_1 THEN DO:                                                                        
     RUN prgfin/apb/apb767zc.py (INPUT 1,                                      
                                 INPUT "APB",                                  
                                 INPUT '',        /*cod_matriz_trad_org_ext*/  
                                 INPUT-OUTPUT TABLE tt_tit_ap_alteracao_base_1,
                                 INPUT-OUTPUT TABLE tt_tit_ap_alteracao_rateio,
                                 OUTPUT TABLE tt_log_erros_tit_ap_alteracao).  
                                                                               
    END.
    
    FIND FIRST tt_log_erros_tit_ap_alteracao NO-LOCK 
        WHERE  tt_log_erros_tit_ap_alteracao.ttv_num_mensagem <> 6542 NO-ERROR.
    IF AVAIL tt_log_erros_tit_ap_alteracao THEN DO:
       RUN esp/cms/escms004.p (INPUT TABLE tt_erro,
                               INPUT TABLE tt_log_erros_atualiz,
                               INPUT TABLE tt_log_erros_tit_ap_alteracao,
                               INPUT TABLE tt_log_erros_estorn_cancel_apb).
    END.
    
END. /*roda_api*/

PROCEDURE pi-busca-numero :
    DEF INPUT PARAM p_cod_portador LIKE nota-fiscal.cod-portador.
    DEF INPUT PARAM p_modalidade   LIKE nota-fiscal.modalidade.

    find first mgcad.portador
         where mgcad.portador.ep-codigo    = tit_acr.cod_empresa
         and   mgcad.portador.cod-portador = p_cod_portador 
         and   mgcad.portador.modalidade   = p_modalidade exclusive-LOCK no-error.

    if avail mgcad.portador
    and mgcad.portador.emite-bloq = 1 then do:
        
        if  mgcad.portador.char-1 <> "" then do:
            assign v_tamanho_bloq = length(mgcad.portador.char-1)
                   v_boleto       = mgcad.portador.char-1
                   v_oper         = "". 

            run ftp/ft0503c.p (input  rowid(mgcad.portador),
                               input  v_boleto,
                               input  v_oper,
                               output v_boleto_digito).

            run pi-mostra-numero.

            if  mgcad.portador.cod-febraban = 237 then do:
                assign mgcad.portador.char-1 = substr(v_boleto,1,2) + v_prox_boleto.
            end.

            if  mgcad.portador.cod-febraban = 341 then do:
                if  length(v_boleto) > 12 then
                    assign mgcad.portador.char-1 = substr(v_boleto,1,4) + substr(v_boleto,5,5) + substr(v_boleto,10,3) + v_prox_boleto.
                else 
                    assign mgcad.portador.char-1 = substr(v_boleto,1,3) + v_prox_boleto.
            end.

            if  mgcad.portador.cod-febraban = 422 then do:
                assign mgcad.portador.char-1 = v_prox_boleto.
            end.

            assign tit_acr.cod_tit_acr_bco = v_prox_boleto. /* chamado C2207-0151 andrey */
        end.       
    end.

END PROCEDURE.

PROCEDURE pi-mostra-numero :

    assign v_tamanho_bloq = length(v_boleto_digito).

    case mgcad.portador.cod-febraban:
         when 237 then do:
              assign v_prox_boleto  = string(decimal(substring(v_boleto_digito, 1, v_tamanho_bloq)), "99999999999")
                     v_formato      = "99999999999".
              assign v_tamanho_bloq = length(v_boleto_digito).
         end.               
    
         when 341 then
            if v_tamanho_bloq > 12 then
               assign v_tamanho_bloq = v_tamanho_bloq - 12
                      v_prox_boleto  = string(decimal(substring(v_boleto_digito, 13, v_tamanho_bloq)),"99999999")
                      v_formato      = "99999999".
            else
               assign v_tamanho_bloq = v_tamanho_bloq /* - 4 */
                      v_prox_boleto  = v_boleto_digito
                      v_formato      = "99999999".
    
         when 422 then do:
              assign v_prox_boleto  = string(decimal(substring(v_boleto_digito, 1, v_tamanho_bloq)), "99999999")
                     v_formato      = "99999999".
              assign v_tamanho_bloq = length(v_boleto_digito).
         end.               
    end.
    
    ASSIGN v_num_bloq = string(v_prox_boleto, v_formato).

END PROCEDURE.

procedure pi-calcula-digito-11-sicredi: 
    ASSIGN i-multiplicador = 1
           i-acum          = 0.

    ASSIGN i-tamanho = length(v_prox_boleto)
           i-cont    = i-tamanho.

    do  while i-tamanho >= 1:
        assign i-multiplicador = i-multiplicador + 1.

        if  i-multiplicador > 9 then
            assign i-multiplicador = 2.

        assign c-number  = string(integer(substring(v_prox_boleto,i-tamanho,1)) * i-multiplicador)
               c-numero1 = c-number
               i-acum    = i-acum + integer(c-number)
               i-tamanho = i-tamanho - 1.
    end.

    assign i-resto  = i-acum MODULO 11
           v_digito = string(11 - i-resto).          

    if  integer(v_digito) >= 10 then 
        assign v_digito = "0".   
end.
