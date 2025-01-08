/***********************************************************************
**  Programa..: UPC\PD4000D-UPC.P
**  Autor.....: Marcio Chaves - Gestech
**  Data......: NOVEMBRO/2004 - Desenvolvimento
**  Descricao.: 
**  Vers∆o....: 001 16/11/2004
**                  Desenvolvimento Programa
************************************************************************/
def input param p-ind-event        as char          no-undo.
def input param p-ind-object       as char          no-undo.
def input param p-wgh-object       as handle        no-undo.
def input param p-wgh-frame        as widget-handle no-undo.
def input param p-cod-table        as char          no-undo.
def input param p-row-table        as rowid         no-undo.

DEF VAR c-objeto  AS CHAR            NO-UNDO.
DEF VAR l-ok      AS LOGICAL         NO-UNDO.
DEF VAR h-frame   AS HANDLE          NO-UNDO.
DEF VAR h-frame-1 AS HANDLE          NO-UNDO.
DEF VAR cReturn   AS CHAR            NO-UNDO.
DEF VAR h-buffer  AS HANDLE          NO-UNDO.
DEF VAR ponteiro  AS WIDGET-HANDLE   NO-UNDO.

DEF VAR whCodEstabel AS HANDLE          NO-UNDO.

/* Global Variable Definitions **********************************************/
/* define new global shared var whBrDigita         as widget-handle no-undo. */
/* define new global shared var whCodRota          as widget-handle no-undo. */
/* define new global shared var whNomeAbrev        as widget-handle no-undo. */
/* define new global shared var whNrPedcli         as widget-handle no-undo. */
define new global shared var whBtOkPD4000d      as widget-handle no-undo.
define new global shared var whBtOkPD4000dLocal as widget-handle no-undo.

assign c-objeto = entry(num-entries(p-wgh-object:file-name,"~/"), 
                        p-wgh-object:file-name,"~/").

/****************************  Variaveis    ****************************/

DEF NEW GLOBAL SHARED VAR gr-ped-venda      AS ROWID         NO-UNDO.
DEF NEW GLOBAL SHARED VAR vLogCopiaPedido   AS LOGICAL       NO-UNDO.

ASSIGN vLogCopiaPedido = YES.

IF  p-ind-event  = "INITIALIZE"
AND p-ind-object = "CONTAINER" THEN DO:

    ASSIGN h-frame = p-wgh-frame:FIRST-CHILD. /* pegando o Field-Group */
    ASSIGN h-frame = h-frame:FIRST-CHILD.     /* pegando o 1o. Campo */
    DO WHILE h-frame <> ?:
        IF h-frame:TYPE <> "field-group" THEN DO:  
            CASE h-frame:NAME:
                /***
                WHEN "br-digita" THEN
                    ASSIGN whBrDigita = h-frame.
                ***/
                WHEN "bt-ok" THEN
                    ASSIGN whBtOkPD4000d = h-frame.
            END CASE.
            ASSIGN h-frame = h-frame:NEXT-SIBLING.
        END.
        ELSE DO:
            ASSIGN h-frame = h-frame:FIRST-CHILD.
        END.
    END.

/*     whCodRota = whBrDigita:ADD-CALC-COLUMN("char","x(12)","","Rota",10). */
/*     whCodRota:COLUMN-READ-ONLY = NO.                                     */
/*     whCodRota:LABEL-BGCOLOR    = 8.                                      */
/*     whCodRota:READ-ONLY        = NO.                                     */
/*                                                                          */
/*     whNomeAbrev  = whBrDigita:GET-BROWSE-COLUMN(1).                      */
/*     whNrPedcli   = whBrDigita:GET-BROWSE-COLUMN(2).                      */

    /* cria novo botao sobre o OK */
    IF  VALID-HANDLE(whBtOkPD4000d) THEN DO:
        CREATE BUTTON whBtOkPD4000dLocal
        ASSIGN FRAME     = whBtOkPD4000d:FRAME
               WIDTH     = whBtOkPD4000d:WIDTH
               HEIGHT    = whBtOkPD4000d:HEIGHT
               ROW       = whBtOkPD4000d:ROW
               LABEL     = whBtOkPD4000d:LABEL
               COL       = whBtOkPD4000d:COL
               SENSITIVE = whBtOkPD4000d:SENSITIVE
               VISIBLE   = whBtOkPD4000d:VISIBLE
        TRIGGERS:
              ON CHOOSE PERSISTENT RUN upc\pd4000d-upca.p.
        END TRIGGERS.
    END.


END.

IF  p-ind-event  = "DESTROY"
AND p-ind-object = "CONTAINER" THEN
    ASSIGN vLogCopiaPedido = NO.
