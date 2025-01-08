/* TRIGGER PROCEDURE FOR WRITE OF parc_vendor. */
  
/*** Historico de altera‡Æo ********/
/**Altera‡Æo: 09/03/2005 - Maria Ester 
   Motivo...: Eliminado a trans. AVMN, ser  tratado na trigger WFIN476 devido ao processo do acordo comercial
****/   

/* DEF BUFFER b-parc_vendor      FOR parc_vendor. */

/*  Temporario - Maria Ester 05/04/05 */
DEF PARAM BUFFER b-parc_vendor      FOR parc_vendor.
DEF PARAM BUFFER b-old-parc_vendor  FOR parc_vendor.

DEF BUFFER brepres_tit_acr FOR repres_tit_acr.

DEF VAR v_num_cont_acr    AS INTEGER NO-UNDO.
DEF VAR v_log_achou_acr   AS LOGICAL  NO-UNDO.
DEF VAR v_num_cont_fgl    AS INTEGER NO-UNDO.
DEF VAR v_log_achou_fgl   AS LOGICAL  NO-UNDO.
DEF VAR c-ser-docto       LIKE tit_ap.cod_ser_docto.
DEF VAR v_num_cont        AS INT NO-UNDO.
DEF VAR v_log_achou       AS LOG NO-UNDO.

ASSIGN v_num_cont_acr  = 1
       v_log_achou_acr = NO.

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

ASSIGN v_num_cont = 0
       v_log_achou = NO.

REPEAT:

    ASSIGN v_num_cont = v_num_cont + 1.
    
    if v_num_cont = 15 OR program-name(v_num_cont) = ? then
        leave.
        
    if index(program-name(v_num_cont),'prgfin/ves/ves707aa.p') <> 0 THEN DO: /*** PROGRAMA DE BAIXA DE TITULOS  ***/ 
       assign v_log_achou = yes.
       leave.
    END.
END.

IF v_log_achou_acr = NO AND v_log_achou_fgl = NO THEN DO:
  
   IF NOT AVAIL b-parc_vendor THEN LEAVE.

   FIND FIRST tit_acr OF b-parc_vendor 
        WHERE tit_acr.ind_tip_espec_docto = "Vendor" NO-LOCK NO-ERROR.                               
   IF NOT AVAIL tit_acr THEN DO:
      FIND FIRST tit_acr OF b-parc_vendor  NO-LOCK NO-ERROR.                               
/*      MESSAGE 
          "tit_acr.cod_parcela: " tit_acr.cod_parcela SKIP
          "tit_acr.cod_ser_docto: " tit_acr.cod_ser_docto SKIP
          "tit_acr.cod_tit_acr: " tit_acr.cod_tit_acr SKIP
          "tit_acr.val_liq_tit_acr: " tit_acr.val_liq_tit_acr SKIP
          "tit_acr.val_sdo_tit_acr: " tit_acr.val_sdo_tit_acr SKIP
          "tit_acr.num_id_tit_acr: " tit_acr.num_id_tit_acr SKIP
          VIEW-AS ALERT-BOX INFO BUTTONS OK.
  */
   END.
   IF NOT AVAIL tit_acr THEN
     LEAVE.

   FIND LAST movto_tit_acr OF tit_acr NO-LOCK NO-ERROR.

/*   IF movto_tit_acr.ind_trans_acr_abrev = "AVMN" THEN
      RUN pi-verifica-comissao.
  */
   IF AVAIL movto_tit_acr AND movto_tit_acr.ind_trans_acr_abrev = "IMPL" THEN DO:
      IF tit_acr.cod_espec_docto = "dm" then  
        ASSIGN c-ser-docto = tit_acr.cod_ser_docto.
     ELSE                                    
        ASSIGN c-ser-docto = tit_acr.cod_espec_docto.

     FOR EACH repres_tit_acr NO-LOCK                                                                                              
         WHERE repres_tit_acr.cod_estab    = tit_acr.cod_estab                                                            
         AND repres_tit_acr.num_id_tit_acr = tit_acr.num_id_tit_acr
         AND repres_tit_acr.val_perc_comis_repres > 0: 
         FIND FIRST representante NO-LOCK
              WHERE representante.cod_empresa = repres_tit_acr.cod_empresa
              AND representante.cdn_repres    = repres_tit_acr.cdn_repres NO-ERROR.
           
         FIND FIRST repres_financ OF representante NO-LOCK
            WHERE repres_financ.log_pagto_bloqdo = YES NO-ERROR.

         IF AVAIL repres_financ THEN
            LEAVE.

        /* MESSAGE 
             "repres_tit_acr.val_perc_comis_repres: " repres_tit_acr.val_perc_comis_repres SKIP
/*             "v_val_perc_comis_repres_old: " v_val_perc_comis_repres_old SKIP */
             "tit_acr.cod_parcela: " tit_acr.cod_parcela SKIP
             "tit_acr.cod_ser_docto: " tit_acr.cod_ser_docto SKIP
             "tit_acr.cod_tit_acr: " tit_acr.cod_tit_acr SKIP
             "tit_acr.val_liq_tit_acr: " tit_acr.val_liq_tit_acr SKIP
             "tit_acr.val_sdo_tit_acr: " tit_acr.val_sdo_tit_acr SKIP
             "tit_acr.num_id_tit_acr: " tit_acr.num_id_tit_acr SKIP
             VIEW-AS ALERT-BOX INFO BUTTONS OK.
          */
      /*valida portador*/
         FIND FIRST int-portador NO-LOCK
              WHERE int-portador.cod_portador         = tit_acr.cod_portador
              AND int-portador.log_considera_comissao = YES NO-ERROR.
         IF NOT AVAIL int-portador THEN
            LEAVE.
      
      /*Pesquisa relacionamento entre fornecedor x representante*/                      
         FIND FIRST emscad.fornecedor NO-LOCK 
              WHERE emscad.fornecedor.cod_empresa = representante.cod_empresa 
              AND emscad.fornecedor.num_pessoa  = representante.num_pessoa NO-ERROR.
      
         FIND FIRST tit_ap NO-LOCK                                                                                                 
              WHERE tit_ap.cod_estab       = tit_acr.cod_estab                                                                     
              AND tit_ap.cdn_fornecedor  = emscad.fornecedor.cdn_fornecedor                                                        
              AND tit_ap.cod_espec_docto = "CPE"                                                                                 
              AND tit_ap.cod_ser_docto   = c-ser-docto
              AND tit_ap.cod_tit_ap      = tit_acr.cod_tit_acr                                                                   
              AND tit_ap.cod_parcela     = tit_acr.cod_parcela NO-ERROR.                                                                   
         IF NOT AVAIL tit_ap THEN DO:
        /*Cria CPE*/
            RUN esp/cms/escms001.p (RECID(movto_tit_acr),         
                                    INPUT "").                     
         END.
     END. /*for each repres_tit_acr*/
  END.
  ELSE
     LEAVE.
END.
  
RETURN 'OK'.

PROCEDURE pi-verifica-comissao.

    IF v_log_achou = YES THEN DO: /******** B A I X A  *******/

       FOR EACH repres_tit_acr FIELDS(repres_tit_acr.cod_estab repres_tit_acr.num_id_tit_acr repres_tit_acr.val_perc_comis_repres repres_tit_acr.cdn_repres) NO-LOCK 
           WHERE repres_tit_acr.cod_estab = tit_acr.cod_estab
           AND   repres_tit_acr.num_id_tit_acr = tit_acr.num_id_tit_acr:

           /***** BUSCA O ULTIMO TITULO RELACIONADO *****/
           FIND last relacto_tit_acr NO-LOCK
               WHERE relacto_tit_acr.cod_estab      = repres_tit_acr.cod_estab
               AND   relacto_tit_acr.num_id_tit_acr_pai = repres_tit_acr.num_id_tit_acr NO-ERROR.
          
           FIND FIRST brepres_tit_acr 
                WHERE brepres_tit_acr.cod_estab      = repres_tit_acr.cod_estab
                AND   brepres_tit_acr.num_id_tit_acr = relacto_tit_acr.num_id_tit_acr
                AND   brepres_tit_acr.cdn_repres     = repres_tit_acr.cdn_repres NO-ERROR.

           IF AVAIL brepres_tit_acr AND
              brepres_tit_acr.val_perc_comis_repres <> repres_tit_acr.val_perc_comis_repres THEN
              ASSIGN brepres_tit_acr.val_perc_comis_repres = repres_tit_acr.val_perc_comis_repres.
       END.
    end.



END PROCEDURE.
