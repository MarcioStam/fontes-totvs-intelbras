/***********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
***********************************************************************************/


/*************************** Parametros Padrao ************************************/
DEFINE INPUT PARAM p-ind-event                         AS CHARACTER        NO-UNDO.
DEFINE INPUT PARAM p-ind-object                        AS CHARACTER        NO-UNDO.
DEFINE INPUT PARAM p-wgh-object                        AS HANDLE           NO-UNDO.
DEFINE INPUT PARAM p-wgh-frame                         AS WIDGET-HANDLE    NO-UNDO.
DEFINE INPUT PARAM p-cod-table                         AS CHARACTER        NO-UNDO.
DEFINE INPUT PARAM p-row-table                         AS ROWID            NO-UNDO.

DEF NEW GLOBAL SHARED VAR c-seg-usuario AS   CHAR                  NO-UNDO.

DEFINE TEMP-TABLE tt-objetos
        FIELD wh-pai    AS WIDGET-HANDLE
        FIELD wh-obj    AS WIDGET-HANDLE
        FIELD nivel     AS INT
        FIELD seq       AS INT.

DEFINE VARIABLE wh-botao AS WIDGET-HANDLE      NO-UNDO.

{esp/es0018.i}


IF  p-ind-event = "initialize" AND
    p-ind-object = "container" AND
    p-wgh-frame:NAME = "f-cad" THEN DO:

    /* PONTO 1 - Usu rios bloqueados */
    FOR EACH tt-prog-ponto: DELETE tt-prog-ponto. END.

    RUN esp/es0018p.p (INPUT "cd0202",
                       INPUT 1, 
                       INPUT 0,
                       INPUT "", 
                       OUTPUT TABLE tt-prog-ponto).

    IF NOT CAN-FIND(FIRST tt-prog-ponto
                WHERE tt-prog-ponto.conteudo = c-seg-usuario) THEN DO:

        RUN busca-handle(INPUT p-wgh-frame,
                         INPUT "bt-add",
                         OUTPUT wh-botao).
        
        IF VALID-HANDLE(wh-botao) THEN
            ASSIGN wh-botao:SENSITIVE = FALSE.
    
        RUN busca-handle(INPUT p-wgh-frame,
                         INPUT "bt-mod",
                         OUTPUT wh-botao).
        
        IF VALID-HANDLE(wh-botao) THEN
            ASSIGN wh-botao:SENSITIVE = FALSE.
    
        RUN busca-handle(INPUT p-wgh-frame,
                         INPUT "bt-cop",
                         OUTPUT wh-botao).
        
        IF VALID-HANDLE(wh-botao) THEN
            ASSIGN wh-botao:SENSITIVE = FALSE.
    
        RUN busca-handle(INPUT p-wgh-frame,
                         INPUT "bt-del",
                         OUTPUT wh-botao).
        
        IF VALID-HANDLE(wh-botao) THEN
            ASSIGN wh-botao:SENSITIVE = FALSE.

    END.

    /* PONTO 2 - Usu rios Liberados para elimina‡Æo */
    FOR EACH tt-prog-ponto: DELETE tt-prog-ponto. END.
    RUN esp/es0018p.p (INPUT "cd0202",
                       INPUT 2, 
                       INPUT 0,
                       INPUT "", 
                       OUTPUT TABLE tt-prog-ponto).

    IF  CAN-FIND(FIRST tt-prog-ponto
                 WHERE tt-prog-ponto.conteudo = c-seg-usuario) THEN DO:

        RUN busca-handle(INPUT p-wgh-frame,
                         INPUT "bt-del",
                         OUTPUT wh-botao).
        
        IF VALID-HANDLE(wh-botao) THEN
            ASSIGN wh-botao:SENSITIVE = TRUE.
    END.


END.




RETURN "OK":U.



PROCEDURE busca-handle:

    DEFINE INPUT  PARAMETER p-wgh-frame  AS WIDGET-HANDLE    NO-UNDO.  /* Handle da Frame Principal do programa */
    DEFINE INPUT  PARAMETER p-nome-obj   AS CHARACTER        NO-UNDO.  /* Nome do objeto que se dejesa achar o handle */
    DEFINE OUTPUT PARAMETER p-handl-obj  AS WIDGET-HANDLE    NO-UNDO.  /* Handle do Componente */

    DEFINE VARIABLE h-aux   AS WIDGET-HANDLE        NO-UNDO.
    DEFINE VARIABLE h-ant   AS WIDGET-HANDLE        NO-UNDO.



    /* Frame Principal */
    ASSIGN h-aux = p-wgh-frame
           p-handl-obj = ?.

    bl-desce:
    REPEAT:

        IF h-aux:NAME <> p-nome-obj THEN DO:

            ASSIGN h-ant = h-aux.

            ASSIGN h-aux = h-aux:FIRST-CHILD NO-ERROR.

            IF NOT VALID-HANDLE(h-aux) THEN
                ASSIGN h-aux = h-ant:NEXT-SIBLING.

            IF NOT VALID-HANDLE(h-aux) THEN DO:

                bl-sobe:
                REPEAT:

                    ASSIGN h-aux = h-ant:PARENT.

                    IF h-aux = p-wgh-frame THEN
                        LEAVE bl-desce.

                    ASSIGN h-ant = h-aux
                           h-aux = h-aux:NEXT-SIBLING.

                    IF VALID-HANDLE(h-aux) THEN
                        LEAVE bl-sobe.

                END.

            END.

        END.
        ELSE DO:

            ASSIGN p-handl-obj = h-aux.
            LEAVE bl-desce.

        END.

    END.

END PROCEDURE.

