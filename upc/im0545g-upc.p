/*------------------------------------------------------------------------
    File        : IM0545G-UPC.P
    Purpose     : UPC do programa IM0545G.
    Syntax      : <none>
    Description : <none>

    Created     : Abril de 2013
    Notes       : 001 - 26/04/2013 - Implementar chamada ao programa
                  RE0701, posicionando na nota selecionada (Fabiano
                  Sakae Ribeiro - Exponencial TI).
----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameter Definitions ---                                            */

DEFINE INPUT  PARAMETER p-ind-event  AS CHARACTER     NO-UNDO.
DEFINE INPUT  PARAMETER p-ind-object AS CHARACTER     NO-UNDO.
DEFINE INPUT  PARAMETER p-wgh-object AS HANDLE        NO-UNDO.
DEFINE INPUT  PARAMETER p-wgh-frame  AS WIDGET-HANDLE NO-UNDO.
DEFINE INPUT  PARAMETER p-cod-table  AS CHARACTER     NO-UNDO.
DEFINE INPUT  PARAMETER p-row-table  AS ROWID         NO-UNDO.

/* Global Shared Variable Definitions ---                               */

DEFINE NEW GLOBAL SHARED VARIABLE h-im0545g-upc AS HANDLE        NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wgh-brSon2-im0545g    AS WIDGET-HANDLE NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE gr-documento  AS ROWID         NO-UNDO. /* Rowid para posicionar registro no RE0701 */

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE c-objeto AS CHARACTER   NO-UNDO.
DEFINE VARIABLE h-fPage0 AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-fPage2 AS HANDLE      NO-UNDO.


/* ***************************  Main Block  *************************** */

/* Identificar o objeto de tela */
ASSIGN c-objeto = ENTRY(NUM-ENTRIES(p-wgh-object:PRIVATE-DATA, "~/":U), p-wgh-object:PRIVATE-DATA, "~/":U).

/* Mensagem para verificar o ponto UPC do programa */
/* MESSAGE "Evento: ":U   p-ind-event      SKIP                              */
/*         "Objeto: ":U   p-ind-object     SKIP                              */
/*         "Nome Obj: ":U c-objeto         SKIP                              */
/*         "Frame: ":U    p-wgh-frame:NAME SKIP                              */
/*         "Tabela: ":U   p-cod-table      SKIP                              */
/*         "Rowid: ":U    STRING(p-row-table)                                */
/*     VIEW-AS ALERT-BOX INFO BUTTONS OK TITLE "Ponto UPC do IM0545G-UPC":U. */


IF p-ind-event  = "BEFORE-INITIALIZE":U AND
   p-ind-object = "CONTAINER":U         THEN DO:
    RUN upc/im0545g-upc.p PERSISTENT SET h-im0545g-upc (INPUT "":U,
                                                        INPUT "":U,
                                                        INPUT p-wgh-object,
                                                        INPUT p-wgh-frame,
                                                        INPUT "":U,
                                                        INPUT p-row-table).
END.

IF p-ind-event  = "AFTER-INITIALIZE":U AND
   p-ind-object = "CONTAINER":U        THEN DO:
    ASSIGN h-fPage0 = p-wgh-frame:FIRST-CHILD
           h-fPage0 = h-fPage0:FIRST-CHILD.

    DO WHILE h-fPage0 <> ?:
        IF h-fPage0:TYPE = "FRAME":U  AND
           h-fPage0:NAME = "fPage2":U THEN
            ASSIGN h-fPage2 = h-fPage0.

        ASSIGN h-fPage0 = h-fPage0:NEXT-SIBLING.
    END.

    IF VALID-HANDLE(h-fPage2) THEN DO:
        ASSIGN h-fPage2 = h-fPage2:FIRST-CHILD
               h-fPage2 = h-fPage2:FIRST-CHILD.

        DO WHILE h-fPage2 <> ?:
            IF h-fPage2:TYPE <> "FIELD-GROUP":U THEN DO:
                CASE h-fPage2:NAME:
                    WHEN "brSon2":U THEN
                        ASSIGN wgh-brSon2-im0545g = h-fPage2.
                END CASE.

                ASSIGN h-fPage2 = h-fPage2:NEXT-SIBLING.
            END.
            ELSE
                ASSIGN h-fPage2 = h-fPage2:FIRST-CHILD.
        END.

        IF VALID-HANDLE(wgh-brSon2-im0545g)    AND
           VALID-HANDLE(h-im0545g-upc) THEN DO:
            ON "MOUSE-SELECT-DBLCLICK":U OF wgh-brSon2-im0545g PERSISTENT RUN pi-run-re0701 IN h-im0545g-upc.
            ON "RETURN":U                OF wgh-brSon2-im0545g PERSISTENT RUN pi-run-re0701 IN h-im0545g-upc.
        END.
    END.
END.

IF p-ind-event  = "BEFORE-DESTROY-INTERFACE":U AND
   p-ind-object = "CONTAINER":U                THEN DO:
    IF VALID-HANDLE(h-im0545g-upc) THEN
        DELETE PROCEDURE h-im0545g-upc.

    ASSIGN wgh-brSon2-im0545g    = ?
           h-im0545g-upc = ?.
END.

RETURN "OK":U.


PROCEDURE pi-run-re0701 :
    DEFINE VARIABLE i-linha AS INTEGER     NO-UNDO.

    DEFINE VARIABLE wgh-serie-docto  AS WIDGET-HANDLE NO-UNDO.
    DEFINE VARIABLE wgh-nro-docto    AS WIDGET-HANDLE NO-UNDO.
    DEFINE VARIABLE wgh-cod-emitente AS WIDGET-HANDLE NO-UNDO.
    DEFINE VARIABLE wgh-nat-operacao AS WIDGET-HANDLE NO-UNDO.

    IF VALID-HANDLE(wgh-brSon2-im0545g) THEN DO:
        
        ASSIGN wgh-serie-docto  = wgh-brSon2-im0545g:QUERY:GET-BUFFER-HANDLE("tt-documentos":U):BUFFER-FIELD("serie-docto":U)
               wgh-nro-docto    = wgh-brSon2-im0545g:QUERY:GET-BUFFER-HANDLE("tt-documentos":U):BUFFER-FIELD("nro-docto":U)
               wgh-cod-emitente = wgh-brSon2-im0545g:QUERY:GET-BUFFER-HANDLE("tt-documentos":U):BUFFER-FIELD("cod-emitente":U)
               wgh-nat-operacao = wgh-brSon2-im0545g:QUERY:GET-BUFFER-HANDLE("tt-documentos":U):BUFFER-FIELD("nat-operacao":U).

        DO i-linha = 1 TO wgh-brSon2-im0545g:NUM-SELECTED-ROWS:
            wgh-brSon2-im0545g:FETCH-SELECTED-ROW(i-linha).

            FIND FIRST docum-est
                WHERE docum-est.serie-docto  = wgh-serie-docto:BUFFER-VALUE
                  AND docum-est.nro-docto    = wgh-nro-docto:BUFFER-VALUE
                  AND docum-est.cod-emitente = wgh-cod-emitente:BUFFER-VALUE
                  AND docum-est.nat-operacao = wgh-nat-operacao:BUFFER-VALUE NO-LOCK NO-ERROR.

            IF AVAILABLE docum-est THEN DO:
                ASSIGN gr-documento = ROWID(docum-est).

                RUN rep/re0701.w.
            END.
        END.

        ASSIGN wgh-serie-docto  = ?
               wgh-nro-docto    = ?
               wgh-cod-emitente = ?
               wgh-nat-operacao = ?.
    END.

    RETURN "OK":U.

END PROCEDURE.

