/***********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
***********************************************************************************/
/*{include/i-prgvrs.i ESDB0401 2.04.00.000}*/  /*** 010000 ***/ 
/***********************************************************************************
* Programa: 
  Objetivo:  MODELO EPC CADASTRO SMART OBJECT
******************************************************************************/


/*************************** Parametros Padrao ************************************/
DEFINE INPUT PARAM p-ind-event                              AS CHARACTER        NO-UNDO.
DEFINE INPUT PARAM p-ind-object                             AS CHARACTER        NO-UNDO.
DEFINE INPUT PARAM p-wgh-object                             AS HANDLE           NO-UNDO.
DEFINE INPUT PARAM p-wgh-frame                              AS WIDGET-HANDLE    NO-UNDO.
DEFINE INPUT PARAM p-cod-table                              AS CHARACTER        NO-UNDO.
DEFINE INPUT PARAM p-row-table                              AS ROWID            NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE wh-lb-ean    AS WIDGET-HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-ean   AS WIDGET-HANDLE    NO-UNDO.
DEFINE VARIABLE wh-frame1                           AS WIDGET-HANDLE    NO-UNDO.
DEFINE VARIABLE wh-frame2                           AS WIDGET-HANDLE    NO-UNDO.
DEFINE VARIABLE wh-aux                              AS WIDGET-HANDLE    NO-UNDO.



/*MESSAGE p-ind-event SKIP
        p-ind-object SKIP
        p-wgh-object:NAME SKIP
        p-wgh-frame:NAME SKIP
        p-cod-table SKIP
        STRING(p-row-table)
    VIEW-AS ALERT-BOX INFO BUTTONS OK.*/



IF p-ind-event = "BEFORE-INITIALIZE" AND
   p-wgh-object:NAME = "cdp/cd0139.w" THEN DO:

    RUN busca-handle(INPUT p-wgh-frame,
                     INPUT "fPage1",
                     OUTPUT wh-frame1).

    ASSIGN wh-frame1:BOX = FALSE.

    RUN busca-handle(INPUT p-wgh-frame,
                     INPUT "fPage2",
                     OUTPUT wh-frame2).

    ASSIGN wh-frame2:BOX = FALSE.

    RUN busca-handle(INPUT wh-frame2,
                     INPUT "lote-multipl",
                     OUTPUT wh-aux).

    CREATE TEXT wh-lb-ean
        ASSIGN FRAME        = wh-frame2
               FORMAT       = "X(16)"
               WIDTH        = 15.5
               HEIGHT       = 0.88
               SCREEN-VALUE = "C¢d GTIN (Trib):":U
               ROW          = wh-aux:ROW + 1
               COL          = wh-aux:COL - 11.4
               VISIBLE      = YES
               FONT         = 1.

    CREATE FILL-IN wh-ean
        ASSIGN FRAME     = wh-frame2
               DATA-TYPE = "CHARACTER"
               FORMAT    = "X(14)":U
               NAME      = "wh-ean"
               WIDTH     = 16
               HEIGHT    = 0.88
               ROW       = wh-aux:ROW + 1
               COL       = wh-aux:COL
               VISIBLE   = YES
               SENSITIVE = NO 
               FONT      = 1.

END.



IF p-ind-event = "AFTER-DISPLAY" AND
   p-wgh-object:NAME = "cdp/cd0139.w" THEN DO:

    IF VALID-HANDLE(wh-ean) THEN DO:

        ASSIGN wh-lb-ean:SCREEN-VALUE = "C¢d GTIN (Trib):"
               wh-ean:SCREEN-VALUE = "".
    
        FOR FIRST ITEM NO-LOCK
            WHERE ROWID(ITEM) = p-row-table:
    
            FOR FIRST item-mat NO-LOCK
                WHERE item-mat.it-codigo = ITEM.it-codigo:
    
                ASSIGN wh-ean:SCREEN-VALUE = STRING(item-mat.cod-ean).
    
            END.
    
        END.

    END.

END.


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
        END.
        ELSE DO:
            ASSIGN p-handl-obj = h-aux.
            LEAVE.
        END.

    END.

END.


