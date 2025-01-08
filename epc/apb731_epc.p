/***************************************************************************************
** Programa..............: apb731_epc.p
** Descricao.............: EPC programas mod_aprop_ctbl_pend_ap e add_aprop_ctbl_pend_ap
** Criado em.............: 28/04/2016
***************************************************************************************/

DEF INPUT PARAM p_ind_event  AS CHAR          NO-UNDO.
DEF INPUT PARAM p_ind_object AS CHAR          NO-UNDO.
DEF INPUT PARAM p_wgh_object AS HANDLE        NO-UNDO.
DEF INPUT PARAM p_wgh_frame  AS WIDGET-HANDLE NO-UNDO.
DEF INPUT PARAM p_cod_table  AS CHAR          NO-UNDO.
DEF INPUT PARAM p_rec_table  AS RECID         NO-UNDO.

DEF BUFFER b_aprop_ctbl_pend_ap FOR aprop_ctbl_pend_ap.

IF p_ind_event = 'VALIDATE' 
THEN DO:
     
     FIND b_aprop_ctbl_pend_ap NO-LOCK
        WHERE RECID(b_aprop_ctbl_pend_ap) = p_rec_table NO-ERROR.
     
     IF  b_aprop_ctbl_pend_ap.cod_ccusto     <> ""
     AND b_aprop_ctbl_pend_ap.cod_unid_negoc <> "" /* ** Na rotina de alteraá∆o n∆o Ç informada a unidade de neg¢cio ***/
     THEN DO:
          IF NOT CAN-FIND(FIRST cc_uni_estab NO-LOCK
                          WHERE cc_uni_estab.cod_ccusto     = b_aprop_ctbl_pend_ap.cod_ccusto
                            AND cc_uni_estab.cod_unid_negoc = b_aprop_ctbl_pend_ap.cod_unid_negoc
                            AND cc_uni_estab.cod_estab      = b_aprop_ctbl_pend_ap.cod_estab)
          THEN DO:
               MESSAGE "Lanáamento n∆o Permitido. Relacionamento entre o Estabelecimento x CCusto x Unidade de Neg¢cio Inexistente!"
                   VIEW-AS ALERT-BOX INFO BUTTONS OK.
               RETURN "NOK".
          END.
     END.

END.
RETURN "OK".

        
        
