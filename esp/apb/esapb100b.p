/*****************************************************************************
** Programa..............: esapb100b.p - Confere retená∆o de Imposto
** Autor.................: Fabiano Zarpe Henke
** Criado em.............: 03/06/2015
*****************************************************************************/

def new global shared var v_rec_bord_ap_upc
    as recid
    format ">>>>>>9"
    initial ?
    no-undo.

DEFINE VARIABLE v_log_erro AS LOGICAL     NO-UNDO.

FIND bord_ap NO-LOCK
    WHERE RECID(bord_ap) = v_rec_bord_ap_upc NO-ERROR.
IF NOT AVAIL bord_ap 
THEN DO:
     MESSAGE "Borderì n∆o Localizado!"
         VIEW-AS ALERT-BOX INFO BUTTONS OK.
     RETURN.
END.

ASSIGN v_log_erro = NO.

FOR EACH item_bord_ap OF bord_ap NO-LOCK:

    FIND tit_ap NO-LOCK
        WHERE tit_ap.cod_estab       = item_bord_ap.cod_estab      
          AND tit_ap.cdn_fornecedor  = item_bord_ap.cdn_fornecedor 
          AND tit_ap.cod_espec_docto = item_bord_ap.cod_espec_docto
          AND tit_ap.cod_ser_docto   = item_bord_ap.cod_ser_docto  
          AND tit_ap.cod_tit_ap      = item_bord_ap.cod_tit_ap     
          AND tit_ap.cod_parcela     = item_bord_ap.cod_parcela NO-ERROR.
    IF AVAIL tit_ap
    THEN DO:
         FOR EACH compl_retenc_impto_pagto NO-LOCK
             WHERE compl_retenc_impto_pagto.cod_estab     = tit_ap.cod_estab
               AND compl_retenc_impto_pagto.num_id_tit_ap = tit_ap.num_id_tit_ap:
             IF NOT CAN-FIND(FIRST impto_impl_pend_ap NO-LOCK
                             WHERE impto_impl_pend_ap.cod_estab_refer   = item_bord_ap.cod_estab_bord
                               AND impto_impl_pend_ap.cod_refer         = ""
                               AND impto_impl_pend_ap.cod_portador      = item_bord_ap.cod_portador
                               AND impto_impl_pend_ap.num_bord_ap       = item_bord_ap.num_bord_ap 
                               AND impto_impl_pend_ap.num_seq_refer     = item_bord_ap.num_seq_bord
                               AND impto_impl_pend_ap.cod_pais          = compl_retenc_impto_pagto.cod_pais
                               AND impto_impl_pend_ap.cod_unid_federac  = compl_retenc_impto_pagto.cod_unid_federac
                               AND impto_impl_pend_ap.cod_imposto       = compl_retenc_impto_pagto.cod_imposto
                               AND impto_impl_pend_ap.cod_classif_impto = compl_retenc_impto_pagto.cod_classif_impto)
             THEN DO:
                  MESSAGE "Vinculo Imposto n∆o localizado! Seq: " item_bord_ap.num_seq_bord
                      VIEW-AS ALERT-BOX INFO BUTTONS OK.
                  ASSIGN v_log_erro = YES.
             END.
        END.
    END.

END.

IF v_log_erro = NO
   THEN MESSAGE "Sem cr°tica!" VIEW-AS ALERT-BOX INFO BUTTONS OK.
