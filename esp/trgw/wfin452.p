/*** Historico de altera‡Æo ********/
/**Altera‡Æo: 09/03/2005 - Maria Ester 
   Trigger tabela aprop_ctbl_acr
   Motivo...: Criada no dia 09/03/2005 para atender a trans. AVMN, devido ao processo do acordo comercial
****/   


DEF PARAM BUFFER b-aprop_ctbl_acr     FOR aprop_ctbl_acr.
DEF PARAM BUFFER b1-old-aprop_ctbl_acr FOR aprop_ctbl_acr.

FIND FIRST b1-old-aprop_ctbl_acr NO-LOCK NO-ERROR.

DEF VAR c_lista_trans     AS CHAR INIT "AVMN"                      NO-UNDO. 
DEF VAR v-cta-aprop-acr   LIKE b-aprop_ctbl_acr.cod_cta_ctbl      NO-UNDO.

DEF VAR v_num_cont_acr    AS INTEGER NO-UNDO.
DEF VAR v_log_achou_acr   AS LOGICAL  NO-UNDO.
DEF VAR v_num_cont_fgl    AS INTEGER NO-UNDO.
DEF VAR v_log_achou_fgl   AS LOGICAL  NO-UNDO.
DEF VAR v_num_cont_ftp    AS INTEGER NO-UNDO.
DEF VAR v_log_achou_ftp   AS LOGICAL  NO-UNDO.
DEF VAR c-ser-docto       LIKE tit_ap.cod_ser_docto.

/*FIND FIRST aprop_ctbl_acr NO-LOCK
    WHERE  aprop_ctbl_acr.cod_estab             = '101'
    AND    aprop_ctbl_acr.num_id_aprop_ctbl_acr = 195770 NO-ERROR.

FIND FIRST b-aprop_ctbl_acr NO-LOCK USE-INDEX aprpctbd_token
   WHERE b-aprop_ctbl_acr.cod_estab             = aprop_ctbl_acr.cod_estab             
   AND   b-aprop_ctbl_acr.num_id_aprop_ctbl_acr = aprop_ctbl_acr.num_id_aprop_ctbl_acr NO-ERROR.*/
    
ASSIGN v-cta-aprop-acr = b-aprop_ctbl_acr.cod_cta_ctbl.

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


ASSIGN v_num_cont_ftp  = 1
       v_log_achou_ftp = NO.

bloco_ftp:   /*Implementado no dia 24/03/2005, devido arro na atualiza‡Æo do FAT x ACR*/
REPEAT:
    if index(program-name(v_num_cont_ftp),'ftp/ft0603.w') = ? then do:
        LEAVE bloco_ftp.
    END.
    
    if index(program-name(v_num_cont_ftp),'ftp/ft0603.w') <> 0 then do:
        assign v_log_achou_ftp = yes.
        leave bloco_ftp.
    end.
    if v_num_cont_ftp = 30 then
        leave bloco_ftp.

    ASSIGN v_num_cont_ftp = v_num_cont_ftp + 1.
END.

/*bloco1:
DO TRANSACTION ON ERROR UNDO, LEAVE:
  */ IF  v_log_achou_acr = NO AND 
      v_log_achou_fgl = NO AND 
      v_log_achou_ftp = NO THEN DO:
      /*FIND FIRST b-aprop_ctbl_acr NO-LOCK NO-ERROR.
      MESSAGE b-aprop_ctbl_acr.cod_estab            SKIP
              b-aprop_ctbl_acr.num_id_movto_tit_acr SKIP
              b-aprop_ctbl_acr.dat_transacao       SKIP
              c_lista_trans 
          VIEW-AS ALERT-BOX.*/
    /*Pesquisa se existe a CPO para a correspondente transa‡Æo*/
    FIND FIRST movto_tit_acr NO-LOCK
         WHERE movto_tit_acr.cod_estab            = b-aprop_ctbl_acr.cod_estab
           AND movto_tit_acr.num_id_movto_tit_acr = b-aprop_ctbl_acr.num_id_movto_tit_acr
           AND movto_tit_acr.dat_transacao        = b-aprop_ctbl_acr.dat_transacao
           AND movto_tit_acr.ind_trans_acr_abrev  = c_lista_trans NO-ERROR.
    
    /*MESSAGE 'WFIN452  -  0' AVAIL movto_tit_acr skip(2) 
             AVAIL b-aprop_ctbl_acr skip(3) 
             'b-aprop_ctbl_acr.cod_estab             ' b-aprop_ctbl_acr.cod_estab            SKIP
             'b-aprop_ctbl_acr.num_id_movto_tit_acr  ' b-aprop_ctbl_acr.num_id_movto_tit_acr SKIP
             'b-aprop_ctbl_acr.dat_transacao         ' b-aprop_ctbl_acr.dat_transacao        SKIP(2)
             'Avail movto_tit_acr ' Avail movto_tit_acr SKIP(3)
             'Avail movto_tit_acr                    '  Avail movto_tit_acr 
        VIEW-AS ALERT-BOX.*/
    IF AVAIL movto_tit_acr THEN DO:
      FIND FIRST tit_acr OF movto_tit_acr NO-LOCK NO-ERROR.
      
      IF tit_acr.cod_espec_docto = "dm" then  
         ASSIGN c-ser-docto = tit_acr.cod_ser_docto.
      ELSE                                    
         ASSIGN c-ser-docto = tit_acr.cod_espec_docto.

      /*MESSAGE 'Avail Tit_acr ' AVAIL tit_acr VIEW-AS ALERT-BOX.*/
      
      /*NÆo efetua transa‡Æo AVA para CPE referente a negocia‡äa em Vendor*/
      IF tit_acr.ind_tip_espec_docto = "Vendor" THEN
         LEAVE.
    
      /*Pesquisa representante */
      FIND FIRST representante NO-LOCK
           WHERE representante.cod_empresa = tit_acr.cod_empresa
             AND representante.cdn_repres  = tit_acr.cdn_repres NO-ERROR.

      FIND FIRST repres_financ OF representante NO-LOCK
         WHERE repres_financ.log_pagto_bloqdo = YES NO-ERROR.

      IF AVAIL repres_financ THEN
         LEAVE.

      
      /*Pesquisa relacionamento entre fornecedor x representante*/                      
      FIND FIRST emscad.fornecedor NO-LOCK 
           WHERE emscad.fornecedor.cod_empresa = representante.cod_empresa 
             AND emscad.fornecedor.num_pessoa  = representante.num_pessoa NO-ERROR. 

      /*Pesquisa se ja existe a CPO no APB para conta contabil - acordo comercial*/  
      IF v-cta-aprop-acr = '41110025' OR
         v-cta-aprop-acr = '41110028' THEN DO:
        
         FIND FIRST tit_ap NO-LOCK                                                                                                
              WHERE tit_ap.cod_estab       = movto_tit_acr.cod_estab                                                                     
                AND tit_ap.cdn_fornecedor  = emscad.fornecedor.cdn_fornecedor                                                        
                AND tit_ap.cod_espec_docto = "CPO"                                                                                 
                AND tit_ap.cod_ser_docto   = c-ser-docto
                AND SUBSTR(tit_ap.cod_tit_ap,1,INDEX(tit_ap.cod_tit_ap,"-") - 1) = tit_acr.cod_tit_acr
                AND tit_ap.cod_parcela     = tit_acr.cod_parcela 
                AND SUBSTR(STRING(tit_ap.cod_refer),2,9) = SUBSTR(STRING(movto_tit_acr.num_id_movto_tit_acr,'9999999999'),2,9) NO-ERROR.
         IF AVAIL tit_ap THEN
            LEAVE.
         ELSE DO:
            RUN esp/cms/escms005.p (INPUT RECID(movto_tit_acr),
                                  INPUT v-cta-aprop-acr,
                                  INPUT "").
         END.
      END.
      ELSE  /*Altera‡Æo normal no t¡tulo*/
      DO:
        /*MESSAGE 'WFIN452  -  2' VIEW-AS ALERT-BOX.*/
        /*Pesquisa se a movimenta‡Æo j  existe no APB*/                                                                         
        FIND FIRST tit_ap NO-LOCK                                                                                                 
             WHERE tit_ap.cod_estab       = tit_acr.cod_estab                                                                     
               AND tit_ap.cdn_fornecedor  = emscad.fornecedor.cdn_fornecedor                                                        
               AND tit_ap.cod_espec_docto = "CPE"                                                                                 
               AND tit_ap.cod_ser_docto   = c-ser-docto
               AND tit_ap.cod_tit_ap      = tit_acr.cod_tit_acr
               AND tit_ap.cod_parcela     = tit_acr.cod_parcela NO-ERROR.
        IF AVAIL tit_ap THEN DO:
          FIND movto_tit_ap OF tit_ap NO-LOCK
               WHERE SUBSTR(STRING(movto_tit_ap.cod_refer),2,9) = SUBSTR(STRING(movto_tit_acr.num_id_movto_tit_acr,'9999999999'),2,9) NO-ERROR.
          IF AVAIL movto_tit_ap THEN DO:
            LEAVE.
          END.
          ELSE DO:
            /*MESSAGE 'WFIN452  -  2' VIEW-AS ALERT-BOX.*/

            RUN esp/cms/escms005.p (INPUT RECID(movto_tit_acr),
                                    INPUT "",
                                    INPUT "").
          END.
        END.
      END.
      
    END. /*movto_tit_acr*/
  END.
/* END. /*do transaction*/
   */

RETURN 'OK'.
