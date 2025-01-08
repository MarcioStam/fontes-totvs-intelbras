/*****************************************************************************
** Programa..............: fas715da_epc.p - add_incorp_bem_pat
** Autor.................: Andrey M Oliveira
** Criado em.............: 20/08/2018.
*****************************************************************************/

DEF INPUT PARAM p_ind_event       AS CHAR           NO-UNDO.
DEF INPUT PARAM p_ind_object      AS CHAR           NO-UNDO.
DEF INPUT PARAM p_wgh_object      AS HANDLE         NO-UNDO.
DEF INPUT PARAM p_wgh_frame       AS WIDGET-HANDLE  NO-UNDO.
DEF INPUT PARAM p_cod_table       AS CHAR           NO-UNDO.
DEF INPUT PARAM p_rec_table       AS RECID          NO-UNDO.

DEFINE NEW GLOBAL SHARED VAR h_cod_cenar_ctbl AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR h_bt_zoo_51773  AS WIDGET-HANDLE NO-UNDO.

{esinc\es0000.i}

DEF TEMP-TABLE tt-prog-ponto NO-UNDO
    FIELD nome-programa    LIKE ponto-programa.nome-programa
    FIELD ponto            LIKE ponto-programa.ponto
    FIELD sequencia        LIKE conteudo-programa.sequencia 
    FIELD conteudo         LIKE conteudo-programa.conteudo
    INDEX seq-campo nome-programa ponto sequencia.


IF  p_ind_event = "ENABLE" THEN DO:
    /* Usu rios com permissao pra informar o cen rio */
    RUN esp\es0018p.p (INPUT "cenar_ctbl",
                       INPUT 1,
                       INPUT 0,
                       INPUT "",
                       OUTPUT TABLE tt-prog-ponto) NO-ERROR.

    FIND tt-prog-ponto WHERE 
         tt-prog-ponto.conteudo = v_cod_usuar_corren NO-ERROR.

    IF  NOT AVAIL tt-prog-ponto THEN DO:
    
        RUN piFindWidget(INPUT "cod_cenar_ctbl", 
                         INPUT "fill-in", 
                         INPUT  p_wgh_frame, 
                         OUTPUT h_cod_cenar_ctbl).
    
        IF  VALID-HANDLE(h_cod_cenar_ctbl) THEN
            ASSIGN h_cod_cenar_ctbl:SENSITIVE    = NO
                   h_cod_cenar_ctbl:SCREEN-VALUE = "".
    
        RUN piFindWidget(INPUT "bt_zoo_51773", 
                         INPUT "BUTTON", 
                         INPUT  p_wgh_frame, 
                         OUTPUT h_bt_zoo_51773).
    
        IF  VALID-HANDLE(h_bt_zoo_51773) THEN
            ASSIGN h_bt_zoo_51773:SENSITIVE = NO.
    END.
END.

PROCEDURE piFindWidget:
    DEFINE INPUT  PARAMETER c-widget-name  AS CHAR   NO-UNDO.
    DEFINE INPUT  PARAMETER c-widget-type  AS CHAR   NO-UNDO.
    DEFINE INPUT  PARAMETER h-start-widget AS HANDLE NO-UNDO.
    DEFINE OUTPUT PARAMETER h-widget       AS HANDLE NO-UNDO.

    DO WHILE VALID-HANDLE(h-start-widget):
        IF  h-start-widget:NAME = c-widget-name 
        AND h-start-widget:TYPE = c-widget-type THEN DO:
            ASSIGN h-widget = h-start-widget:HANDLE.
            LEAVE.
        end.

        IF  h-start-widget:TYPE = "field-group":u 
        OR  h-start-widget:TYPE = "frame":u 
        OR  h-start-widget:TYPE = "dialog-box":u THEN DO:
            RUN piFindWidget (INPUT  c-widget-name,
                              INPUT  c-widget-type,
                              INPUT  h-start-widget:FIRST-CHILD,
                              OUTPUT h-widget).

            IF  VALID-HANDLE(h-widget) THEN
                LEAVE.
        END.

        ASSIGN h-start-widget = h-start-widget:NEXT-SIBLING.
    END.
END PROCEDURE.
