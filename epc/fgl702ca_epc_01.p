/*****************************************************************************
** Programa..............: fgl702ca_epc_01.p
** Descricao.............: EPC do Evento LEAVE do campo cod_lancto_ctbl_padr
**                         do programa bas_lancto_ctbl_padr.
** Criado em.............: 24/08/2018
*****************************************************************************/

def input param p_ind_event       as char           no-undo.
def input param p_ind_object      as char           no-undo.
def input param p_wgh_object      as handle         no-undo.
def input param p_wgh_frame       as widget-handle  no-undo.
def input param p_cod_table       as char           no-undo.
def input param p_rec_table       as recid          no-undo.

DEF TEMP-TABLE tt-prog-ponto NO-UNDO
    FIELD nome-programa    LIKE ponto-programa.nome-programa
    FIELD ponto            LIKE ponto-programa.ponto
    FIELD sequencia        LIKE conteudo-programa.sequencia 
    FIELD conteudo         LIKE conteudo-programa.conteudo
    INDEX seq-campo nome-programa ponto sequencia.

{esinc\es0000.i}

DEFINE NEW GLOBAL SHARED VAR h_cod_lancto_ctbl_padr AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR h_bt_zoo_32084         AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR h_cod_cenar_ctbl       AS WIDGET-HANDLE NO-UNDO.

PROCEDURE pi_leave_lancto_padr:
    IF  VALID-HANDLE(h_cod_lancto_ctbl_padr) THEN DO:
        /* Usu rios com permissao pra informar o cen rio */
        RUN esp\es0018p.p (INPUT "cenar_ctbl",
                           INPUT 1,
                           INPUT 0,
                           INPUT "",
                           OUTPUT TABLE tt-prog-ponto) NO-ERROR.

        FIND tt-prog-ponto WHERE 
             tt-prog-ponto.conteudo = v_cod_usuar_corren NO-ERROR.

        IF  NOT AVAIL tt-prog-ponto THEN DO:

            IF  VALID-HANDLE(h_cod_cenar_ctbl) THEN
                ASSIGN h_cod_cenar_ctbl:SENSITIVE    = NO
                       h_cod_cenar_ctbl:SCREEN-VALUE = "".

            IF  VALID-HANDLE(h_bt_zoo_32084) THEN
                ASSIGN h_bt_zoo_32084:SENSITIVE      = NO.
        END.
    END.
END PROCEDURE.
