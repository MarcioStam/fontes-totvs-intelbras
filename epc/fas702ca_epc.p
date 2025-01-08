/*****************************************************************************
** Programa..............: fas702ca_epc.p
** Descricao.............: EPC do programa isl_bem_pat_baixa
** Criado em.............: 17/09/2018
*****************************************************************************/

DEF INPUT PARAM p_ind_event  AS CHAR          NO-UNDO.
DEF INPUT PARAM p_ind_object AS CHAR          NO-UNDO.
DEF INPUT PARAM p_wgh_object AS HANDLE        NO-UNDO.
DEF INPUT PARAM p_wgh_frame  AS WIDGET-HANDLE NO-UNDO.
DEF INPUT PARAM p_cod_table  AS CHAR          NO-UNDO.
DEF INPUT PARAM p_rec_table  AS RECID         NO-UNDO.

DEF VAR h_fas702ca_epc_1 AS WIDGET-HANDLE NO-UNDO.
DEF VAR h_object         AS WIDGET-HANDLE NO-UNDO.
DEF VAR v_cod_cta_dest   AS CHAR          NO-UNDO.

{esinc\es0000.i}

DEF NEW GLOBAL SHARED VAR h_ind_motiv_bxa           AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR h_ind_tip_bxa_bem_pat     AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR h_dat_movto_bem_pat     AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh_ind_motiv_bxa_fas702ca AS WIDGET-HANDLE NO-UNDO.


IF  p_ind_event = "INITIALIZE" THEN DO:
    RUN epc/fas702ca_epc_01.p PERSISTENT SET h_fas702ca_epc_1(INPUT p_ind_event,
                                                              INPUT p_ind_object,
                                                              INPUT p_wgh_object,
                                                              INPUT p_wgh_frame,
                                                              INPUT p_cod_table,
                                                              INPUT p_rec_table).

    ASSIGN h_object        = p_wgh_frame:FIRST-CHILD
           h_object        = h_object:FIRST-CHILD 
           h_ind_motiv_bxa = ?.

    DO WHILE VALID-HANDLE(h_object):
        IF  h_object:TYPE <> "field_group" THEN DO:
            IF  h_object:NAME = "v_ind_motiv_bxa" THEN 
                ASSIGN h_ind_motiv_bxa = h_object.
        
            ASSIGN h_object = h_object:NEXT-SIBLING.
        END.
        ELSE 
            ASSIGN h_object = h_object:FIRST-CHILD.
       
        IF  VALID-HANDLE(h_ind_motiv_bxa) THEN 
            LEAVE.
    END.

    ASSIGN h_object        = p_wgh_frame:FIRST-CHILD
           h_object        = h_object:FIRST-CHILD 
           h_ind_tip_bxa_bem_pat = ?.

    DO WHILE VALID-HANDLE(h_object):
        IF  h_object:TYPE <> "field_group" THEN DO:
            IF  h_object:NAME = "v_ind_tip_bxa_bem_pat" THEN 
                ASSIGN h_ind_tip_bxa_bem_pat = h_object.
        
            ASSIGN h_object = h_object:NEXT-SIBLING.
        END.
        ELSE 
            ASSIGN h_object = h_object:FIRST-CHILD.
       
        IF  VALID-HANDLE(h_ind_tip_bxa_bem_pat) THEN 
            LEAVE.
    END.

    ASSIGN h_object        = p_wgh_frame:FIRST-CHILD
           h_object        = h_object:FIRST-CHILD 
           h_dat_movto_bem_pat = ?.

    DO WHILE VALID-HANDLE(h_object):
        IF  h_object:TYPE <> "field_group" THEN DO:
            IF  h_object:NAME = "dat_movto_bem_pat" THEN 
                ASSIGN h_dat_movto_bem_pat = h_object.
        
            ASSIGN h_object = h_object:NEXT-SIBLING.
        END.
        ELSE 
            ASSIGN h_object = h_object:FIRST-CHILD.
       
        IF  VALID-HANDLE(h_dat_movto_bem_pat) THEN 
            LEAVE.
    END.

    IF  VALID-HANDLE(h_ind_motiv_bxa) THEN DO:
        ASSIGN h_ind_motiv_bxa:SENSITIVE = NO.

        CREATE COMBO-BOX wh_ind_motiv_bxa_fas702ca
        ASSIGN FRAME           = p_wgh_frame
               DATA-TYPE       = h_ind_motiv_bxa:DATA-TYPE
               FORMAT          = "x(20)"
               WIDTH           = 20
               ROW             = h_ind_motiv_bxa:ROW
               COL             = h_ind_motiv_bxa:COL
               HIDDEN          = h_ind_motiv_bxa:HIDDEN
               INNER-LINES     = h_ind_motiv_bxa:INNER-LINES
               SENSITIVE       = YES
               VISIBLE         = YES
               LIST-ITEMS      = "NÆo Localizado/Doado,Quebra,Venda,Devolu‡Æo,Sem Condi‡Æo de Uso"
               LIST-ITEM-PAIRS = "NÆo Localizado/Doado,NÆo Localizado/Doado,Quebra,Quebra,Venda,Venda,Devolu‡Æo,Devolu‡Æo,Sem Condi‡Æo de Uso,Sem Condi‡Æo de Uso".
    END.

    ON "VALUE-CHANGED" OF wh_ind_motiv_bxa_fas702ca PERSISTENT RUN pi_trata_motivo IN h_fas702ca_epc_1.

    ON "LEAVE" OF wh_ind_motiv_bxa_fas702ca PERSISTENT RUN pi_trata_leave_1 IN h_fas702ca_epc_1.

    ON "LEAVE" OF h_ind_tip_bxa_bem_pat PERSISTENT RUN pi_trata_leave_2 IN h_fas702ca_epc_1.

END.

RETURN "OK".
