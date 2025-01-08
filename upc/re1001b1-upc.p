/***********************************************************************
**  Programa..: upc/re1001b1-upc.p
**  Autor.....: Anderson Silvano  - Gestech
**  Data......: JUNHO/2005 - Desenvolvimento
**  Descricao.: 
**  Vers∆o....: 001 - 00/00/2002
**                  Desenvolvimento Programa
*************************************************************************/
DEFINE INPUT PARAMETER p-ind-event  AS CHARACTER     NO-UNDO.
DEFINE INPUT PARAMETER p-ind-object AS CHARACTER     NO-UNDO.
DEFINE INPUT PARAMETER p-wgh-object AS HANDLE        NO-UNDO.
DEFINE INPUT PARAMETER p-wgh-frame  AS WIDGET-HANDLE NO-UNDO.
DEFINE INPUT PARAMETER p-cod-table  AS CHARACTER     NO-UNDO.
DEFINE INPUT PARAMETER p-row-table  AS ROWID         NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE wh-it-codigo-re1001b1    AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-num-pedido-re1001b1   AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-tx-narrativa-re1001b1 AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-narrativa-re1001b1    AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE gr-docum-est             AS ROWID         NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-numero-ordem          AS WIDGET-HANDLE NO-UNDO.

DEFINE VARIABLE h-object     AS HANDLE        NO-UNDO.
DEFINE VARIABLE h-fpage1     AS HANDLE        NO-UNDO.

/************************************************************************/

/*
MESSAGE "Evento: " p-ind-event         SKIP
        "Objeto: " p-ind-object        SKIP
        "Tabela: " p-cod-table         SKIP
        "Rowid: "  STRING(p-row-table) SKIP
        "Objeto: " c-objeto
    VIEW-AS ALERT-BOX.
*/


CASE p-ind-event :

    WHEN "AFTER-INITIALIZE" THEN DO:
        ASSIGN h-object = p-wgh-frame:FIRST-CHILD
               h-object = h-object:FIRST-CHILD.

        DO WHILE VALID-HANDLE(h-object):
            IF  h-object:TYPE <> "field-group" THEN DO:
                IF h-object:NAME = "fPage1" AND
                   NOT VALID-HANDLE(h-fpage1) 
                THEN DO:
                    ASSIGN h-fpage1 = h-object.
                    LEAVE.
                END.
                ASSIGN h-object = h-object:NEXT-SIBLING.
            END.
            ELSE
                LEAVE.
        END.

        ASSIGN h-object = h-fpage1:FIRST-CHILD
               h-object = h-object:FIRST-CHILD.

        DO WHILE VALID-HANDLE(h-object):
            IF  h-object:TYPE <> "field-group" THEN DO:
                IF h-object:NAME = "it-codigo" AND
                   NOT VALID-HANDLE(wh-it-codigo-re1001b1) THEN
                    ASSIGN wh-it-codigo-re1001b1 = h-object.

                IF h-object:NAME = "num-pedido" AND
                   NOT VALID-HANDLE(wh-num-pedido-re1001b1) THEN
                    ASSIGN wh-num-pedido-re1001b1 = h-object.

                IF h-object:NAME = "numero-ordem" AND
                   NOT VALID-HANDLE(wh-numero-ordem) THEN
                    ASSIGN wh-numero-ordem = h-object.

                ASSIGN h-object = h-object:NEXT-SIBLING.
            END.
            ELSE
                LEAVE.
        END.

        IF VALID-HANDLE(wh-numero-ordem) THEN
            ON 'LEAVE' OF wh-numero-ordem PERSISTENT RUN upc/re1001b1-upca.p (1).
        
        IF VALID-HANDLE(wh-numero-ordem) THEN
            ON 'ENTRY' OF wh-numero-ordem PERSISTENT RUN upc/re1001b1-upca.p (2).

        IF VALID-HANDLE(wh-num-pedido-re1001b1) THEN
            ON 'ENTRY' OF wh-num-pedido-re1001b1 PERSISTENT RUN upc/re1001b1-upca.p (3).

        CREATE TEXT wh-tx-narrativa-re1001b1
        ASSIGN FRAME        = h-fpage1
               FORMAT       = "x(10)"
               WIDTH        = 12
               HEIGHT       = 0.88
               SCREEN-VALUE = "Narrativa"
               ROW          = 10
               COLUMN       = 1
               VISIBLE      = YES.
        
        CREATE EDITOR wh-narrativa-re1001b1
        ASSIGN NAME               = "wh-narrativa-re1001b1"
               FRAME              = h-fpage1
               DATA-TYPE          = "CHARACTER"
               FONT               = 1
               WIDTH              = 83
               HEIGHT             = 5
               ROW                = 11
               COLUMN             = 1.5
               SCROLLBAR-VERTICAL = YES
               MAX-CHARS          = 2000
               VISIBLE            = YES
               SENSITIVE          = YES
               READ-ONLY          = NO.
    END. /* WHEN "AFTER-INITIALIZE" */

    when "AFTER-DISPLAY" THEN DO:
        FIND FIRST item-doc-est NO-LOCK
            WHERE ROWID(item-doc-est) = p-row-table NO-ERROR.
        IF  AVAIL item-doc-est 
        THEN
            ASSIGN wh-narrativa-re1001b1:SCREEN-VALUE = item-doc-est.narrativa.
    END. /* when "AFTER-DISPLAY" */


    WHEN "BEFORE-ASSIGN" THEN DO:
        IF wh-it-codigo-re1001b1:SCREEN-VALUE = "" THEN DO:
            FIND FIRST docum-est
                WHERE ROWID(docum-est) = gr-docum-est NO-LOCK NO-ERROR.

            IF  AVAILABLE docum-est AND
                INT(wh-num-pedido-re1001b1:SCREEN-VALUE) = 0
            THEN DO:
                IF  wh-narrativa-re1001b1:SCREEN-VALUE         = "" OR
                    LENGTH(wh-narrativa-re1001b1:SCREEN-VALUE) < 10
                THEN DO:
                    RUN utp/ut-msgs.p (INPUT "SHOW",
                                       INPUT 17006,
                                       INPUT "Narrativa inv†lida." +
                                             "~~" +
                                             "Quando o item for (DÇbito Direto) Ç obrigat¢ria a inclus∆o da narrativa com mais de 10 letras e/ou n£meros.").

                    ASSIGN h-object = p-wgh-object.

                    DO WHILE VALID-HANDLE(h-object):
                        IF h-object:FILE-NAME = "utp/thinFolder.w" THEN
                            LEAVE.

                        ASSIGN h-object = h-object:NEXT-SIBLING.
                    END.

                    RUN setFolder IN h-object (INPUT 1).

                    APPLY "ENTRY" TO wh-narrativa-re1001b1.

                    RETURN ERROR.
                END.
            END. /* IF AVAILABLE docum-est*/
        END. /* IF wh-it-codigo-re1001b1:SCREEN-VALUE = "" */
    END. /* WHEN "BEFORE-ASSIGN" */


    WHEN "AFTER-ASSIGN" THEN DO:
        FIND FIRST item-doc-est EXCLUSIVE-LOCK
            WHERE ROWID(item-doc-est) = p-row-table  NO-ERROR.

        IF  AVAILABLE item-doc-est
        THEN DO:     
            IF  item-doc-est.narrativa <> wh-narrativa-re1001b1:SCREEN-VALUE
            THEN
                ASSIGN item-doc-est.narrativa = wh-narrativa-re1001b1:SCREEN-VALUE.

            /* conforme indicado pelas usu†rias Alceia Schappo Farias Weber e Juliane Brighenti deve ser retirada essa l¢gica */
            /*
            IF  item-doc-est.num-pedido = 0
            THEN DO:
                FIND ITEM NO-LOCK
                    WHERE ITEM.it-codigo = item-doc-est.it-codigo NO-ERROR.

                ASSIGN item-doc-est.class-fiscal = ITEM.class-fiscal
                       item-doc-est.cod-depos    = ITEM.deposito-pad.
            END.
            */
        END.

        RELEASE item-doc-est.
    END. /* WHEN "AFTER-ASSIGN" */
END CASE.

IF p-ind-object = "CONTAINER"               AND
   p-ind-event  = "AFTER-DESTROY-INTERFACE" THEN DO:

    IF  VALID-HANDLE(wh-tx-narrativa-re1001b1) THEN
        DELETE WIDGET wh-tx-narrativa-re1001b1.
    ASSIGN wh-tx-narrativa-re1001b1 = ?.

    IF  VALID-HANDLE(wh-narrativa-re1001b1) THEN
        DELETE WIDGET wh-narrativa-re1001b1.
    ASSIGN wh-narrativa-re1001b1 = ?.

    ASSIGN wh-it-codigo-re1001b1  = ?
           wh-num-pedido-re1001b1 = ?.
END.

RETURN "ok".
