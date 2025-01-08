/*****************************************************************************
** Programa..............: apb717ea_epc.p
** Descricao.............: EPC do programa add_item_lote_impl_ap
** Criado em.............: 13/05/2020
*****************************************************************************/

def input param p_ind_event  as char          no-undo.
def input param p_ind_object as char          no-undo.
def input param p_wgh_object as handle        no-undo.
def input param p_wgh_frame  as widget-handle no-undo.
def input param p_cod_table  as char          no-undo.
def input param p_rec_table  as recid         no-undo.
                               
DEF NEW GLOBAL SHARED VAR wh_tg_tratamento AS WIDGET-HANDLE NO-UNDO.

/*
MESSAGE "p_ind_event "  p_ind_event  skip
        "p_ind_object " p_ind_object skip
        "p_wgh_object " p_wgh_object skip
        "p_wgh_frame "  p_wgh_frame  skip
        "p_cod_table "  p_cod_table 
        VIEW-AS ALERT-BOX.
*/

/* tratar apenas quando executado pela rotina de libera‡Æo de pagamentos */
IF  PROGRAM-NAME(1)  MATCHES "*apb711zd*"
OR  PROGRAM-NAME(2)  MATCHES "*apb711zd*"
OR  PROGRAM-NAME(3)  MATCHES "*apb711zd*"
OR  PROGRAM-NAME(4)  MATCHES "*apb711zd*"
OR  PROGRAM-NAME(5)  MATCHES "*apb711zd*" THEN DO:

    IF  p_ind_event = "INITIALIZE" then do:
        CREATE TOGGLE-BOX wh_tg_tratamento
        ASSIGN FRAME        = p_wgh_frame
               WIDTH        = 13
               HEIGHT       = 1.00
               ROW          = 10.5
               LABEL        = "Em Tratamento"
               TOOLTIP      = "Em processo de valida‡Æo para libera‡Æo de pagamento"
               COLUMN       = 40.4
               SENSITIVE    = YES
               VISIBLE      = YES.
    END.
    
    IF  p_ind_event = "DISPLAY" then do:
        FIND FIRST tit_ap
            WHERE recid(tit_ap) = p_rec_table NO-LOCK NO-ERROR.
    
        IF  AVAIL tit_ap THEN DO:
            IF  VALID-HANDLE(wh_tg_tratamento) THEN DO:
                ASSIGN wh_tg_tratamento:CHECKED = IF tit_ap.log_livre_2 = YES THEN YES
                                                  ELSE NO.
            END.
        END.
    END.

    IF  p_ind_event = "ASSIGN" then do:
        FIND FIRST tit_ap
            WHERE recid(tit_ap) = p_rec_table EXCLUSIVE-LOCK NO-ERROR.
    
        IF  AVAIL tit_ap THEN
            ASSIGN tit_ap.log_livre_2 = IF wh_tg_tratamento:CHECKED = YES THEN YES 
                                        ELSE NO.
    END.
END.

RETURN "OK".
