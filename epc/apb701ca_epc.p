/*****************************************************************************
** Programa..............: apb701ca_epc.p
** Descricao.............: EPC do programa add_antecip_pef_pend
** Criado em.............: 05/08/2009
*****************************************************************************/

DEF INPUT PARAM p_ind_event  AS CHAR          NO-UNDO.
DEF INPUT PARAM p_ind_object AS CHAR          NO-UNDO.
DEF INPUT PARAM p_wgh_object AS HANDLE        NO-UNDO.
DEF INPUT PARAM p_wgh_frame  AS WIDGET-HANDLE NO-UNDO.
DEF INPUT PARAM p_cod_table  AS CHAR          NO-UNDO.
DEF INPUT PARAM p_rec_table  AS RECID         NO-UNDO.

DEF BUFFER b_antecip_pef_pend FOR antecip_pef_pend.
DEF BUFFER b_portador         FOR emscad.portador.

IF p_ind_event = 'VALIDATE' 
THEN DO:
     FIND b_antecip_pef_pend NO-LOCK
        WHERE RECID(b_antecip_pef_pend) = p_rec_table NO-ERROR.
     FIND b_portador NO-LOCK
        WHERE b_portador.cod_portador = b_antecip_pef_pend.cod_portador NO-ERROR.
     IF  AVAIL b_portador
     AND b_antecip_pef_pend.cod_espec = "GV"
     AND b_portador.ind_tip_portad    = "Caixa"
     THEN DO:
          MESSAGE "Utilizar esp‚cie GVC para Guias de Viagens utilizando portador CAIXA !"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
          RETURN "NOK".
     END.
     IF  AVAIL b_portador
     AND b_antecip_pef_pend.cod_espec  = "GVC"
     AND b_portador.ind_tip_portad    <> "Caixa"
     THEN DO:
          MESSAGE "Utilizar esp‚cie GV para Guias de Viagens utilizando portador Banco !"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
          RETURN "NOK".
     END.
END.
RETURN "OK".

