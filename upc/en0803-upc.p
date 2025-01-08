/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

/*:T*******************************************************************************
**
**  Programa.: upc/en0803-upc.p
**  Objetivo.: Espec°fico do programa Consulta Onde-se-Usa - EN0803
**  Criaá∆o..: 26/05/2010
**  Vers∆o...: 00001 - 26/05/2010 - Inserir coluna no browse dos Itens, informando
**             a Unidade de Neg¢cio utilizada. - Fabiano Sakae Ribeiro (SQL Works).
**
*******************************************************************************/
DEFINE INPUT PARAMETER p-ind-event  AS CHARACTER       NO-UNDO.
DEFINE INPUT PARAMETER p-ind-object AS CHARACTER       NO-UNDO.
DEFINE INPUT PARAMETER p-wgh-object AS HANDLE          NO-UNDO.
DEFINE INPUT PARAMETER p-wgh-frame  AS WIDGET-HANDLE   NO-UNDO.
DEFINE INPUT PARAMETER p-cod-table  AS CHARACTER       NO-UNDO.
DEFINE INPUT PARAMETER p-row-table  AS ROWID           NO-UNDO.

DEFINE VARIABLE c-objeto     AS CHARACTER   NO-UNDO.

ASSIGN c-objeto = ENTRY(NUM-ENTRIES(p-wgh-object:PRIVATE-DATA, "/":U), p-wgh-object:PRIVATE-DATA, "/":U).

DEFINE VARIABLE h-frame      AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-it-codigo  AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-unid-negoc AS HANDLE      NO-UNDO.

DEFINE VARIABLE i-linha      AS INTEGER     NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE wh-br-table-en0803-upc AS WIDGET-HANDLE NO-UNDO.

/* Exibir mensagens com os eventos da UPC */
/*MESSAGE "Evento: ":U      p-ind-event  SKIP
        "Objeto: ":U      p-ind-object SKIP
        "Nome Objeto: ":U c-objeto     SKIP
        "Frame: ":U       p-wgh-frame  SKIP
        "Tabela: ":U      p-cod-table  SKIP
        "Rowid: ":U       STRING(p-row-table)
    VIEW-AS ALERT-BOX TITLE "Eventos da UPC":U.*/

/* Imprimir arquivo texto com os eventos da UPC */
/* OUTPUT TO VALUE("C:/temp/eventos-en0803.txt":U) APPEND CONVERT TARGET SESSION:CHARSET. */
/* PUT UNFORMATTED                                                                        */
/*     "Evento.......: ":U p-ind-event         SKIP                                       */
/*     "Objeto.......: ":U p-ind-object        SKIP                                       */
/*     "Nome Objeto..: ":U c-objeto            SKIP                                       */
/*     "Frame........: ":U p-wgh-frame         SKIP                                       */
/*     "Tabela.......: ":U p-cod-table         SKIP                                       */
/*     "Rowid........: ":U STRING(p-row-table) SKIP                                       */
/*     FILL("-":U, 50)                         SKIP.                                      */
/* OUTPUT CLOSE.                                                                          */

IF p-ind-event  = "BEFORE-INITIALIZE":U AND
   p-ind-object = "BROWSER":U           AND
   c-objeto     = "b09in111.w":U        THEN DO:
    ASSIGN h-frame = p-wgh-frame:FIRST-CHILD
           h-frame = h-frame:FIRST-CHILD.

    DO WHILE VALID-HANDLE(h-frame):
        IF h-frame:TYPE <> "field-group":U THEN DO:
            CASE h-frame:NAME:
                WHEN "br-table":U THEN ASSIGN wh-br-table-en0803-upc = h-frame.
            END CASE.
            ASSIGN h-frame = h-frame:NEXT-SIBLING NO-ERROR.
        END.
        ELSE LEAVE.
    END.

    IF VALID-HANDLE(wh-br-table-en0803-upc) THEN DO:
        wh-br-table-en0803-upc:ADD-CALC-COLUMN("CHARACTER":U, "x(40)":U, "":U, "Unid.Neg.":U).
        wh-br-table-en0803-upc:COLUMN-RESIZABLE = TRUE.
        wh-br-table-en0803-upc:NUM-LOCKED-COLUMNS = 1.
    END.
END.

IF p-ind-event  = "AFTER-OPEN-QUERY":U AND
   p-ind-object = "BROWSER":U             AND
   c-objeto     = "b09in111.w":U          THEN DO:
    DO i-linha = 1 TO wh-br-table-en0803-upc:NUM-ITERATIONS - 1:
        ASSIGN h-it-codigo  = wh-br-table-en0803-upc:GET-BROWSE-COLUMN(1)
               h-unid-negoc = wh-br-table-en0803-upc:GET-BROWSE-COLUMN(wh-br-table-en0803-upc:NUM-COLUMNS).

        ASSIGN h-unid-negoc:SCREEN-VALUE = "---":U.

        FIND FIRST item
            WHERE item.it-codigo = TRIM(h-it-codigo:SCREEN-VALUE) NO-LOCK NO-ERROR.

        IF AVAILABLE item THEN DO:
            FOR EACH unid-neg-fam-com
                WHERE unid-neg-fam-com.fm-codigo = item.fm-cod-com NO-LOCK:
                FIND FIRST unid_negoc
                    WHERE unid_negoc.cod_unid_negoc = unid-neg-fam-com.cod_unid_negoc NO-LOCK NO-ERROR.

                IF AVAILABLE unid_negoc THEN DO:
                    IF h-unid-negoc:SCREEN-VALUE = "---":U THEN
                        ASSIGN h-unid-negoc:SCREEN-VALUE = unid_negoc.des_unid_negoc.
                    ELSE
                        ASSIGN h-unid-negoc:SCREEN-VALUE = h-unid-negoc:SCREEN-VALUE + ", ":U + unid_negoc.des_unid_negoc.
                END.
            END.
        END.

        wh-br-table-en0803-upc:SELECT-NEXT-ROW().
    END.

    IF wh-br-table-en0803-upc:NUM-ITERATIONS > 0 THEN
        wh-br-table-en0803-upc:SELECT-ROW(1).
END.

IF p-ind-event  = "AFTER-VALUE-CHANGED":U AND
   p-ind-object = "BROWSER":U             AND
   c-objeto     = "b09in111.w":U          THEN DO:
    IF VALID-HANDLE(wh-br-table-en0803-upc)      AND
       wh-br-table-en0803-upc:NUM-ITERATIONS > 0 THEN DO:
        ASSIGN h-it-codigo  = wh-br-table-en0803-upc:GET-BROWSE-COLUMN(1)
               h-unid-negoc = wh-br-table-en0803-upc:GET-BROWSE-COLUMN(wh-br-table-en0803-upc:NUM-COLUMNS).

        IF VALID-HANDLE(h-it-codigo)  AND
           VALID-HANDLE(h-unid-negoc) THEN DO:

            ASSIGN h-unid-negoc:SCREEN-VALUE = "---":U.

            FIND FIRST item
                WHERE item.it-codigo = TRIM(h-it-codigo:SCREEN-VALUE) NO-LOCK NO-ERROR.
    
            IF AVAILABLE item THEN DO:
                FOR EACH unid-neg-fam-com
                    WHERE unid-neg-fam-com.fm-codigo = item.fm-cod-com NO-LOCK:
                    FIND FIRST unid_negoc
                        WHERE unid_negoc.cod_unid_negoc = unid-neg-fam-com.cod_unid_negoc NO-LOCK NO-ERROR.
    
                    IF AVAILABLE unid_negoc THEN DO:
                        IF h-unid-negoc:SCREEN-VALUE = "---":U THEN
                            ASSIGN h-unid-negoc:SCREEN-VALUE = unid_negoc.des_unid_negoc.
                        ELSE
                            ASSIGN h-unid-negoc:SCREEN-VALUE = h-unid-negoc:SCREEN-VALUE + ", ":U + unid_negoc.des_unid_negoc.
                    END.
                END.
            END.
        END.
    END.
END.

IF p-ind-event  = "DESTROY":U   AND
   p-ind-object = "CONTAINER":U AND
   c-objeto     = "en0803.w":U  THEN DO:    
    IF VALID-HANDLE(wh-br-table-en0803-upc) THEN
        ASSIGN wh-br-table-en0803-upc = ?.

    IF VALID-HANDLE(h-frame) THEN
        DELETE OBJECT h-frame.
        
    IF VALID-HANDLE(h-it-codigo) THEN
        DELETE OBJECT h-it-codigo.
        
    IF VALID-HANDLE(h-unid-negoc) THEN
        DELETE OBJECT h-unid-negoc.
END.
