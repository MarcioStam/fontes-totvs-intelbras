/*****************************************************************************
** Programa..............: fas722ma_epc.p
** Descricao.............: EPC do programa frm_aloc_bem.
** Criado em.............: 30/01/2019.
*****************************************************************************/

DEF INPUT PARAM p_ind_event  AS CHAR          NO-UNDO.
DEF INPUT PARAM p_ind_object AS CHAR          NO-UNDO.
DEF INPUT PARAM p_wgh_object AS HANDLE        NO-UNDO.
DEF INPUT PARAM p_wgh_frame  AS WIDGET-HANDLE NO-UNDO.
DEF INPUT PARAM p_cod_table  AS CHAR          NO-UNDO.
DEF INPUT PARAM p_rec_table  AS RECID         NO-UNDO.

DEF NEW GLOBAL SHARED VAR wh_bt_ins_frm              AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh_new_bt_ins_frm          AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR h_br_frm_ccusto_unid_negoc AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR h_epc_fas722ma             AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh_bt_hist_aloc            AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh_bt_clr2                 AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh_new_bt_clr2             AS WIDGET-HANDLE NO-UNDO.

DEF VAR h_epc_fas722aa AS WIDGET-HANDLE NO-UNDO.

def new global shared var v_rec_bem_pat
    as recid
    format ">>>>>>9":U
    initial ?
    no-undo.

DEF VAR hquery           AS HANDLE NO-UNDO.
DEF VAR hbuffer          AS HANDLE NO-UNDO.
DEF VAR h_cod_estab      AS HANDLE NO-UNDO.
DEF VAR h_cod_ccusto     AS HANDLE NO-UNDO.
DEF VAR h_cod_unid_negoc AS HANDLE NO-UNDO.
DEF VAR i-linha          AS INT    NO-UNDO.

/*
MESSAGE "p_ind_event "  p_ind_event  skip
        "p_ind_object " p_ind_object skip
        "p_wgh_object " p_wgh_object skip
        "p_wgh_frame "  p_wgh_frame  skip
        "p_cod_table "  p_cod_table 
        VIEW-AS ALERT-BOX.
*/

IF  p_ind_event = "INITIALIZE" then do:
    
    create button wh_bt_hist_aloc
    assign frame      = p_wgh_frame
           width      = 4
           height     = 1.08
           row        = 1.13
           col        = 66
           sensitive  = yes
           visible    = yes
           tooltip    = "Hist¢rico Alocaá‰es"
           triggers:
               on choose persistent run epc/fas722aa_epc_1.p.
           end triggers.

    wh_bt_hist_aloc:load-image("image/im-param.bmp":U).

    RUN busca-handle(INPUT p_wgh_frame,
                     INPUT "bt_clr2",
                     OUTPUT wh_bt_clr2).

    IF VALID-HANDLE(wh_bt_clr2) THEN DO:

        IF NOT VALID-HANDLE (h_epc_fas722aa) THEN
            RUN epc/fas722aa_epc.p PERSISTENT SET h_epc_fas722aa (INPUT "",
                                                                  INPUT "",
                                                                  INPUT p_wgh_object,
                                                                  INPUT p_wgh_frame,
                                                                  INPUT "",
                                                                  INPUT p_rec_table).

        CREATE BUTTON wh_new_bt_clr2
        ASSIGN FRAME       = wh_bt_clr2:FRAME
               WIDTH       = wh_bt_clr2:WIDTH
               HEIGHT      = wh_bt_clr2:HEIGHT
               LABEL       = "Limpa Dados"
               ROW         = wh_bt_clr2:ROW
               COL         = wh_bt_clr2:COL
               TOOLTIP     = "Limpa Dados"
               FLAT-BUTTON = wh_bt_clr2:FLAT-BUTTON
               VISIBLE     = YES
               SENSITIVE   = YES.
        ON "CHOOSE" OF wh_new_bt_clr2 PERSISTENT RUN pi_bt_clr2 IN h_epc_fas722aa.

        wh_new_bt_clr2:LOAD-IMAGE ( 'image/im-clr1.bmp' ).
        wh_new_bt_clr2:MOVE-TO-TOP().
        wh_bt_clr2:VISIBLE = NO.
    END.


END.

PROCEDURE pi_bt_clr2:

    MESSAGE "Para manutená∆o de alocaá∆o, favor utilizar o bot∆o Formaá∆o Relaá∆o." 
        VIEW-AS ALERT-BOX INFORMATION.

END PROCEDURE.

PROCEDURE busca-handle:
    DEF INPUT  PARAM p-wgh-frame AS WIDGET-HANDLE NO-UNDO.
    DEF INPUT  PARAM p-nome-obj  AS CHARACTER     NO-UNDO.
    DEF OUTPUT PARAM p-handl-obj AS WIDGET-HANDLE NO-UNDO.
    
    DEF VARI h-aux  AS WIDGET-HANDLE NO-UNDO.
    DEF VARI h-prox AS HANDLE        NO-UNDO.

    ASSIGN h-aux = p-wgh-frame
           h-prox = ?.
    ASSIGN h-aux = h-aux:FIRST-CHILD.
    ASSIGN h-aux = h-aux:FIRST-CHILD.

    REPEAT:
        IF  NOT valid-handle(h-aux) 
        AND NOT VALID-HANDLE(h-prox) THEN DO:
            ASSIGN h-aux = ?.
            LEAVE.
        END.

        IF  NOT valid-handle(h-aux) THEN DO:
            ASSIGN h-aux = h-prox.
            ASSIGN h-prox = ?.
            NEXT.
        END.

        IF  h-aux:NAME = "panel-frame" THEN DO:
            ASSIGN h-prox = h-aux:NEXT-SIBLING.
            ASSIGN h-aux = h-aux:FIRST-CHILD.
            ASSIGN h-aux = h-aux:FIRST-CHILD.

            NEXT.
        END.

        IF  h-aux:NAME <> p-nome-obj THEN DO:
            ASSIGN h-aux = h-aux:NEXT-SIBLING.
            
            IF NOT VALID-HANDLE(h-aux) THEN
                NEXT.
        END.
        ELSE DO:
            ASSIGN p-handl-obj = h-aux.
            LEAVE.
        END.
    END.
END.


RETURN "OK".
