/*****************************************************************************
** Programa..............: cmg700da_epc.p
** Descricao.............: EPC do programa add_movto_cta_corren
** Criado em.............: 06/08/2009
*****************************************************************************/

DEF INPUT PARAM p_ind_event  AS CHAR          NO-UNDO.
DEF INPUT PARAM p_ind_object AS CHAR          NO-UNDO.
DEF INPUT PARAM p_wgh_object AS HANDLE        NO-UNDO.
DEF INPUT PARAM p_wgh_frame  AS WIDGET-HANDLE NO-UNDO.
DEF INPUT PARAM p_cod_table  AS CHAR          NO-UNDO.
DEF INPUT PARAM p_rec_table  AS RECID         NO-UNDO.

DEF BUFFER b_movto_cta_corren FOR movto_cta_corren.
DEF BUFFER b_cta_corren_orig  FOR cta_corren.
DEF BUFFER b_cta_corren_dest  FOR cta_corren.

DEF VAR h_object       AS WIDGET-HANDLE  NO-UNDO.
DEF VAR h_cta          AS WIDGET-HANDLE  NO-UNDO.
DEF VAR v_cod_cta_dest AS CHAR           NO-UNDO.

IF p_ind_event = 'VALIDATE' 
THEN DO:

     /* Localizar conta corrente destino */
     ASSIGN h_object = p_wgh_frame:FIRST-CHILD
            h_object = h_object:FIRST-CHILD 
            h_cta    = ?.
     DO WHILE VALID-HANDLE(h_object):
        IF h_object:TYPE <> "field_group" 
        THEN DO:
             IF h_object:NAME = "v_cod_cta_corren_dest" 
                THEN ASSIGN h_cta = h_object.
             ASSIGN h_object = h_object:NEXT-SIBLING.
         END.
         ELSE ASSIGN h_object = h_object:FIRST-CHILD.
         IF VALID-HANDLE(h_cta) 
            THEN LEAVE.
     END.
     ASSIGN v_cod_cta_dest = h_cta:SCREEN-VALUE.
     /* Fim Localizar conta corrente destino */

     IF v_cod_cta_dest <> "" 
     THEN DO:
          FIND b_movto_cta_corren NO-LOCK
             WHERE RECID(b_movto_cta_corren) = p_rec_table NO-ERROR.
          FIND b_cta_corren_orig NO-LOCK
             WHERE b_cta_corren_orig.cod_cta_corren = b_movto_cta_corren.cod_cta_corren NO-ERROR.
          FIND b_cta_corren_dest NO-LOCK
             WHERE b_cta_corren_dest.cod_cta_corren = v_cod_cta_dest NO-ERROR.
          IF  b_movto_cta_corren.cod_tip_trans_cx  = "Transf"
          AND b_cta_corren_orig.cod_estab         <> b_cta_corren_dest.cod_estab 
          THEN DO:
               MESSAGE "Contas de estabelecimentos diferentes, utilizar o tipo de transa‡Æo de caixa TransFIL !"
                 VIEW-AS ALERT-BOX INFO BUTTONS OK.
               RETURN "NOK".
          END.
          IF  b_movto_cta_corren.cod_tip_trans_cx = "TransFIL"
          AND b_cta_corren_orig.cod_estab         = b_cta_corren_dest.cod_estab 
          THEN DO:
               MESSAGE "Tipo de transa‡Æo de caixa TransFIL somente deve ser utilizado para contas com estabelecimentos diferentes !"
                 VIEW-AS ALERT-BOX INFO BUTTONS OK.
               RETURN "NOK".
          END.
     END.

END.
RETURN "OK".
