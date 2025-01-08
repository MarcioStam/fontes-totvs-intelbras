/*************************** Parametros Padrao ************************************/
DEFINE INPUT PARAM p-ind-event                         AS CHARACTER        NO-UNDO.
DEFINE INPUT PARAM p-ind-object                        AS CHARACTER        NO-UNDO.
DEFINE INPUT PARAM p-wgh-object                        AS HANDLE           NO-UNDO.
DEFINE INPUT PARAM p-wgh-frame                         AS WIDGET-HANDLE    NO-UNDO.
DEFINE INPUT PARAM p-cod-table                         AS CHARACTER        NO-UNDO.
DEFINE INPUT PARAM p-row-table                         AS ROWID            NO-UNDO.


DEFINE VARIABLE wh-fpage1          AS WIDGET-HANDLE      NO-UNDO.
DEFINE VARIABLE wh-fpage2          AS WIDGET-HANDLE      NO-UNDO.
DEFINE VARIABLE wh-c-cod-ean       AS WIDGET-HANDLE      NO-UNDO.
DEFINE VARIABLE wh-cb-cod-obsoleto AS WIDGET-HANDLE      NO-UNDO.
{esp/es0018.i}
{utp/ut-glob.i}


IF p-ind-event = "AFTER-UPDATE" THEN DO:

    RUN busca-handle(INPUT p-wgh-frame,
                     INPUT "fpage1",
                     OUTPUT wh-fpage1).

    RUN busca-handle(INPUT p-wgh-frame,
                     INPUT "fpage2",
                     OUTPUT wh-fpage2).

    RUN busca-handle(INPUT wh-fpage2,
                     INPUT "c-cod-ean",
                     OUTPUT wh-c-cod-ean).

    RUN busca-handle(INPUT wh-fpage1,
                     INPUT "cb-cod-obsoleto",
                     OUTPUT wh-cb-cod-obsoleto).

    ASSIGN wh-c-cod-ean:SENSITIVE = FALSE.
           

    /*Verifica se o usuario ou o grupo tem permiss∆o apra editar a situaá∆o*/
    IF VALID-HANDLE(wh-cb-cod-obsoleto) THEN DO:

        ASSIGN wh-cb-cod-obsoleto:SENSITIVE = FALSE.

        RUN esp/es0018p.p (INPUT "cd0138":U, INPUT 1, INPUT 0, INPUT "":U, OUTPUT TABLE tt-prog-ponto).

        blk_situacao:
        FOR EACH tt-prog-ponto:
            
            FIND FIRST usuar_grp_usuar NO-LOCK
                 WHERE usuar_grp_usuar.cod_grp_usuar = tt-prog-ponto.conteudo
                   AND usuar_grp_usuar.cod_usuar     = c-seg-usuario NO-ERROR.

            IF AVAIL usuar_grp_usuar 
            OR c-seg-usuario = tt-prog-ponto.conteudo THEN DO:
                ASSIGN wh-cb-cod-obsoleto:SENSITIVE = TRUE.
                LEAVE blk_situacao.
            END.
        END.
    END.
    /**/
END.




RETURN "OK":U.

PROCEDURE busca-handle:

    DEFINE INPUT  PARAMETER p-wgh-frame  AS WIDGET-HANDLE    NO-UNDO.  /* Handle da Frame Principal do programa */
    DEFINE INPUT  PARAMETER p-nome-obj   AS CHARACTER        NO-UNDO.  /* Nome do objeto que se dejesa achar o handle */
    DEFINE OUTPUT PARAMETER p-handl-obj  AS WIDGET-HANDLE    NO-UNDO.  /* Handle do Componente */

    DEFINE VARIABLE h-aux   AS WIDGET-HANDLE    NO-UNDO.


    /* Frame Principal */
    ASSIGN h-aux = p-wgh-frame.

    /* field-group */
    ASSIGN h-aux = h-aux:FIRST-CHILD.

    /* Primeiro componente da Frame */
    ASSIGN h-aux = h-aux:FIRST-CHILD.

    REPEAT:

        IF h-aux:NAME <> p-nome-obj THEN DO:
            ASSIGN h-aux = h-aux:NEXT-SIBLING.
            IF NOT VALID-HANDLE(h-aux) THEN DO:
                ASSIGN p-handl-obj = ?.
                LEAVE.
            END.
        END.
        ELSE DO:
            ASSIGN p-handl-obj = h-aux.
            LEAVE.
        END.

    END.

END.


PROCEDURE busca-folder:

    DEFINE INPUT  PARAMETER p-wgh-frame  AS WIDGET-HANDLE    NO-UNDO.  /* Handle da Frame Principal do programa */
    DEFINE INPUT  PARAMETER p-nome-obj   AS CHARACTER        NO-UNDO.  /* Nome do objeto que se dejesa achar o handle */
    DEFINE OUTPUT PARAMETER p-handl-obj  AS WIDGET-HANDLE    NO-UNDO.  /* Handle do Componente */

    DEFINE VARIABLE h-aux   AS WIDGET-HANDLE    NO-UNDO.


    /* Frame Principal */
    ASSIGN h-aux = p-wgh-frame.

    /* field-group */
    ASSIGN h-aux = h-aux:FIRST-CHILD.

    /* Primeiro componente da Frame */
    ASSIGN h-aux = h-aux:FIRST-CHILD.

    REPEAT:

        IF h-aux:NAME <> p-nome-obj THEN DO:
            ASSIGN h-aux = h-aux:NEXT-SIBLING.
            IF NOT VALID-HANDLE(h-aux) THEN DO:
                ASSIGN p-handl-obj = ?.
                LEAVE.
            END.
        END.
        ELSE DO:
            ASSIGN p-handl-obj = h-aux.
            LEAVE.
        END.

    END.

END.

