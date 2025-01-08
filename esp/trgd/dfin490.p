/*** Historico de alteraá∆o ********/
/**Alteraá∆o: 14/11/2005 - Claudiney Klitzke 
   Trigger tabela movto_tit_acr
   Motivo...: Ao eliminar o movimento do ACR, elimina tambÇm o movimento no ABPB.
****/   

{esp/es0018.i}
{esp/esb/esesb000.i}

DEF PARAM BUFFER b-tit_acr     FOR tit_acr.

DEF VAR v_num_cont_acr             AS INTEGER                       NO-UNDO.
DEF VAR v_log_achou_acr            AS LOGICAL                       NO-UNDO.
DEF VAR v_log_achou_702            AS LOGICAL                       NO-UNDO.
DEF VAR v_num_cont_fgl             AS INTEGER                       NO-UNDO.
DEF VAR v_log_achou_fgl            AS LOGICAL                       NO-UNDO.
DEF VAR v_baixa_an_devol           AS LOGICAL INITIAL NO            NO-UNDO.
DEF VAR v_cod_refer                AS CHAR                          NO-UNDO.  
DEF VAR c-ser-docto                LIKE tit_ap.cod_ser_docto.
DEF VAR l_erro                     AS LOG                           NO-UNDO.
DEF VAR v_log_livre_1              AS CHAR                          NO-UNDO.
DEF VAR raw-tit-acr                AS RAW                           NO-UNDO.
DEF VAR v_val_orig                 LIKE tit_acr.val_origin_tit_acr  NO-UNDO.

DEF NEW GLOBAL SHARED VAR v_cod_usuar_corren AS CHARACTER FORMAT "x(12)":U LABEL "Usu†rio Corrente" COLUMN-LABEL "Usu†rio Corrente" NO-UNDO. 
DEF NEW GLOBAL SHARED VAR v_cod_empres_usuar AS CHARACTER FORMAT "x(3)":U  LABEL "Empresa"          COLUMN-LABEL "Empresa"          NO-UNDO. 
DEF NEW GLOBAL SHARED VAR v_cod_estab_usuar  AS CHARACTER FORMAT "x(3)":U  LABEL "Estabelecimento"  COLUMN-LABEL "Estab"            NO-UNDO. 

DEF TEMP-TABLE tt_erro
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

DEF TEMP-TABLE tt_tit_acr_deps NO-UNDO
    FIELD cod_estab      LIKE tit_acr_deps.cod_estab
    FIELD num_id_tit_acr LIKE tit_acr_deps.num_id_tit_acr.

FOR EACH tt_erro:
  DELETE tt_erro.
END.



/* Temp-table API Alteracao titulo */
{esp/cms/apb900zd.i} 
{esp/cms/apb768za.i} 
{esp/cms/apb767zc.i} 
/* {esp/cms/escms001.i} */
 
ASSIGN v_num_cont_acr  = 1 
       v_log_achou_acr = NO
       v_log_achou_702 = NO.

bloco_acr:
REPEAT:
    
    if index(program-name(v_num_cont_acr),'prgfin/acr/acr707ra.py') = ? then do:
        LEAVE bloco_acr.
    END.
    
    if index(program-name(v_num_cont_acr),'prgfin/acr/acr707ra.py') <> 0 then do:
        assign v_log_achou_acr = yes.
        leave bloco_acr.
    end.
    if v_num_cont_acr = 30 then
        leave bloco_acr.
    
    ASSIGN v_num_cont_acr = v_num_cont_acr + 1.

END.

ASSIGN v_num_cont_fgl  = 1
       v_log_achou_fgl = NO.

bloco_fgl:
REPEAT:
    /* prgfin/acr/acr705za.py */
    /* prgfin/fgl/fgl702aa.p  */
    if index(program-name(v_num_cont_fgl),'prgfin/fgl/fgl702aa.p') = ? then do:
        LEAVE bloco_fgl.
    END.

    if index(program-name(v_num_cont_fgl),'prgfin/fgl/fgl702aa.p') <> 0 then do:
        assign v_log_achou_fgl = yes.
        leave bloco_fgl.
    end.
    if v_num_cont_fgl = 30 then
        leave bloco_fgl.

    ASSIGN v_num_cont_fgl = v_num_cont_fgl + 1.

END.

    

IF v_log_achou_acr = NO AND v_log_achou_fgl = NO THEN DO:

    FOR EACH repres_tit_acr NO-LOCK                                                                                              
        WHERE repres_tit_acr.cod_estab      = b-tit_acr.cod_estab
        AND   repres_tit_acr.num_id_tit_acr = b-tit_acr.num_id_tit_acr
        AND   repres_tit_acr.val_perc_comis_repres > 0,
        FIRST representante NO-LOCK
              WHERE representante.cod_empresa = repres_tit_acr.cod_empresa
              AND   representante.cdn_repres  = repres_tit_acr.cdn_repres:
      
        FIND FIRST emscad.fornecedor NO-LOCK 
             WHERE emscad.fornecedor.cod_empresa = representante.cod_empresa 
               AND emscad.fornecedor.num_pessoa  = representante.num_pessoa 
             USE-INDEX frncdr_empr_pessoa NO-ERROR.
        
        IF b-tit_acr.cod_espec_docto = "dm" then  
           ASSIGN c-ser-docto = b-tit_acr.cod_ser_docto.
        ELSE                                    
           ASSIGN c-ser-docto = b-tit_acr.cod_espec_docto.
        
        FIND LAST tit_ap NO-LOCK
             WHERE tit_ap.cod_estab       = b-tit_acr.cod_estab
               AND tit_ap.cdn_fornecedor  = emscad.fornecedor.cdn_fornecedor
               AND tit_ap.cod_espec_docto = "CPE" 
               AND tit_ap.cod_ser_docto   = c-ser-docto
               AND tit_ap.cod_tit_ap      = b-tit_acr.cod_tit_acr
               AND tit_ap.cod_parcela     = b-tit_acr.cod_parcela 
               AND tit_ap.val_sdo_tit_ap  > 0 NO-ERROR.
        IF AVAIL tit_ap THEN DO:
           FOR EACH movto_tit_ap OF tit_ap NO-LOCK:
            /*Elimina a Previs∆o de comissao referente a DM - Portador n∆o considera comiss∆o */
               CREATE tt_cancelamento_estorno_apb. 
               ASSIGN ttv_ind_niv_operac_apb            = "titulo"
                      ttv_ind_tip_operac_apb            = "cancelamento"
                      tta_cod_estab                     = tit_ap.cod_estab                                                                         
                      tta_num_id_tit_ap                 = tit_ap.num_id_tit_ap
                      tta_num_id_movto_tit_ap           = movto_tit_ap.num_id_movto_tit_ap 
                      tta_cod_refer                     = movto_tit_ap.cod_refer
                      tta_dat_transacao                 = TODAY /*movto_tit_ap.dat_transacao Em 01/04/2005 Maria Ester e Mario Fleith */
                      tta_cod_histor_padr               = "" 
/*                      ttv_des_histor                    = 'Cancelamento da Previs∆o de Comiss∆o, referente Portador n∆o considera comiss∆o:' +
                                                          '  Estab:' + tit_acr.cod_estab + 
                                                          '  Esp:' + tit_acr.cod_espec_docto +  '  Sr:' + c-ser-docto +
                                                          '  titulo:' + STRING(tit_acr.cod_tit_acr) + '  parc:' + tit_acr.cod_parcela +
                                                          '  Cliente:' + STRING(tit_acr.cdn_cliente) + '  Repres:' + STRING(repres_tit_acr.cdn_repres)
  */                    ttv_ind_tip_estorn                = "total"
                      tta_cod_portador                  = ""
                      ttv_cod_estab_reembol             = ""
                      ttv_log_reaber_item               = NO 
                      ttv_log_reembol                   = NO 
                      ttv_log_estorn_impto_retid        = NO. 
           END.
        END.

        FIND FIRST tt_cancelamento_estorno_apb NO-LOCK NO-ERROR.
        IF AVAIL tt_cancelamento_estorno_apb THEN DO:
            run prgfin/apb/apb768za.py (Input 1,
                                       Input table tt_cancelamento_estorno_apb,
                                       Input table tt_estornar_agrupados,
                                       output table tt_log_erros_estorn_cancel_apb,
                                       output table tt_estorna_tit_imptos,
                                       output v_log_livre_1).
          
            /*Valida se ocorreu erro durante o processamento*/                                                                                               
            FIND FIRST tt_log_erros_estorn_cancel_apb NO-LOCK NO-ERROR.
            
            IF AVAIL tt_log_erros_estorn_cancel_apb THEN                                                                                                        
               RUN esp/cms/escms004.p (INPUT TABLE tt_erro,
                                       INPUT TABLE tt_log_erros_atualiz,
                                       INPUT TABLE tt_log_erros_tit_ap_alteracao,
                                       INPUT TABLE tt_log_erros_estorn_cancel_apb).
         
           /*Zera temp-table*/
            FOR EACH tt_cancelamento_estorno_apb  EXCLUSIVE-LOCK:
              DELETE tt_cancelamento_estorno_apb. 
            END.
        END.
    END.
END.

/* Excluir do DEPS ao cancelar um t°tulo */
EMPTY TEMP-TABLE tt_tit_acr_deps.

IF  b-tit_acr.ind_tip_espec_docto = "Normal" 
OR  b-tit_acr.ind_tip_espec_docto = "Antecipaá∆o" THEN DO:

    FOR FIRST int-emitente NO-LOCK
        WHERE int-emitente.cod-emitente = b-tit_acr.cdn_cliente:

        RUN esp/es0018p.p (INPUT "dps-canal-cr",
                           INPUT 1,
                           INPUT 0,
                           INPUT "",
                           OUTPUT TABLE tt-prog-ponto) NO-ERROR.

        IF  CAN-FIND (FIRST tt-prog-ponto
                         WHERE tt-prog-ponto.conteudo = string(int-emitente.cod-gr-cob)) THEN DO:

            IF  b-tit_acr.ind_tip_espec_docto = "Normal" THEN DO:

                FIND FIRST tit_acr_deps
                    WHERE tit_acr_deps.cod_estab      = b-tit_acr.cod_estab      
                    AND   tit_acr_deps.num_id_tit_acr = b-tit_acr.num_id_tit_acr EXCLUSIVE-LOCK NO-ERROR.

                IF  NOT AVAIL tit_acr_deps THEN DO:
                    CREATE tit_acr_deps.

                    ASSIGN tit_acr_deps.cod_estab      = b-tit_acr.cod_estab
                           tit_acr_deps.num_id_tit_acr = b-tit_acr.num_id_tit_acr
                           tit_acr_deps.dat_gerac      = TODAY.
                END.

                FOR EACH val_tit_acr
                    WHERE val_tit_acr.cod_estab        = b-tit_acr.cod_estab      
                    AND   val_tit_acr.num_id_tit_acr   = b-tit_acr.num_id_tit_acr 
                    AND   val_tit_acr.cod_finalid_econ = "Corrente" NO-LOCK:
    
                    ASSIGN v_val_orig  = v_val_orig  + val_tit_acr.val_origin_tit_acr.
                END.

                ASSIGN tit_acr_deps.log_integra  = NO
                       tit_acr_deps.dat_gerac    = TODAY
                       tit_acr_deps.dados_cancel = STRING(b-tit_acr.cdn_cliente)                     + ";" +  /* entry 1  */
                                                   b-tit_acr.cod_tit_acr                             + ";" +  /* entry 2  */
                                                   string(date(b-tit_acr.dat_emis_docto))            + ";" +  /* entry 3  */
                                                   STRING(DATE(b-tit_acr.dat_vencto_tit_acr))        + ";" +  /* entry 4  */
                                                   STRING(DATE(b-tit_acr.dat_vencto_origin_tit_acr)) + ";" +  /* entry 5  */
                                                   b-tit_acr.cod_parcela                             + ";" +  /* entry 6  */
                                                   STRING(DEC(v_val_orig))                           + ";" +  /* entry 7  */
                                                   b-tit_acr.cod_tit_acr_bco                         + ";" +  /* entry 8  */
                                                   b-tit_acr.cod_estab                               + ";" +  /* entry 9  */
                                                   b-tit_acr.cod_espec_docto                         + ";" +  /* entry 10 */
                                                   b-tit_acr.cod_ser_docto                           + ";" +  /* entry 11 */
                                                   b-tit_acr.cod_portador                            + ";" +  /* entry 12 */
                                                   b-tit_acr.cod_cart_bcia                           + ";" +  /* entry 13 */
                                                   STRING(DATE(b-tit_acr.dat_transacao)).                     /* entry 14 */
            END.
        
            IF  b-tit_acr.ind_tip_espec_docto = "Antecipaá∆o" THEN DO:
                CREATE tt_tit_acr_deps.
                ASSIGN tt_tit_acr_deps.cod_estab      = b-tit_acr.cod_estab
                       tt_tit_acr_deps.num_id_tit_acr = b-tit_acr.num_id_tit_acr.

                RAW-TRANSFER tt_tit_acr_deps TO raw-tit-acr.

                RUN esp/esb/esesb003.p (INPUT        "msg0311",
                                        INPUT        raw-tit-acr,
                                        OUTPUT TABLE resultado) NO-ERROR.        
                
                FIND FIRST tit_acr_deps
                    WHERE tit_acr_deps.cod_estab      = tt_tit_acr_deps.cod_estab      
                    AND   tit_acr_deps.num_id_tit_acr = tt_tit_acr_deps.num_id_tit_acr EXCLUSIVE-LOCK NO-ERROR.

                IF  AVAIL tit_acr_deps THEN
                    ASSIGN tit_acr_deps.log_integra = YES.
            END.        
        END.
    END.
END.



RETURN "OK".
