def input param p-ind-event        as char          no-undo.
def input param p-ind-object       as char          no-undo.
def input param p-wgh-object       as handle        no-undo.
def input param p-wgh-frame        as widget-handle no-undo.
def input param p-cod-table        as char          no-undo.
def input param p-row-table        as rowid         no-undo.

/*
assign c-objeto = entry(num-entries(p-wgh-object:file-name,"~/"),
                        p-wgh-object:file-name,"~/").
*/  

/* Desativado por desuso */

/* DEFINE VARIABLE h-frame     AS HANDLE     NO-UNDO.                              */
/*                                                                                 */
/* DEF NEW GLOBAL SHARED VAR vAtualizaNfSeparada   AS LOG NO-UNDO.                 */
/* DEF NEW GLOBAL SHARED VAR whBtExecutarUpc       AS WIDGET-HANDLE NO-UNDO.       */
/* DEF NEW GLOBAL SHARED VAR whBtExecutarTela      AS WIDGET-HANDLE NO-UNDO.       */
/*                                                                                 */
/* IF  p-ind-event   = "INITIALIZE" AND                                            */
/*     p-ind-object  = "CONTAINER"  THEN DO:                                       */
/*     ASSIGN vAtualizaNfSeparada = YES.                                           */
/*                                                                                 */
/*     ASSIGN h-frame = p-wgh-frame:FIRST-CHILD.                                   */
/*     ASSIGN h-frame = h-frame:FIRST-CHILD.                                       */
/*                                                                                 */
/*     DO  WHILE VALID-HANDLE(h-frame):                                            */
/*         IF  h-frame:TYPE <> "field-group" THEN DO:                              */
/*             CASE h-frame:NAME:                                                  */
/*                 WHEN "bt-executar"        THEN                                  */
/*                     ASSIGN whBtExecutarTela = h-frame.                          */
/*             END.                                                                */
/*             ASSIGN h-frame = h-frame:NEXT-SIBLING NO-ERROR.                     */
/*         END.                                                                    */
/*     END.                                                                        */
/*                                                                                 */
/*     CREATE BUTTON whBtExecutarUpc                                               */
/*     ASSIGN FRAME     = whBtExecutarTela:FRAME                                   */
/*            WIDTH     = whBtExecutarTela:WIDTH                                   */
/*            HEIGHT    = whBtExecutarTela:HEIGHT                                  */
/*            ROW       = whBtExecutarTela:ROW                                     */
/*            LABEL     = "Parametros"                                             */
/*            COL       = whBtExecutarTela:COL + 55                                */
/*            SENSITIVE = whBtExecutarTela:SENSITIVE                               */
/*            VISIBLE   = whBtExecutarTela:VISIBLE                                 */
/*     TRIGGERS:                                                                   */
/*           ON CHOOSE PERSISTENT RUN upc\ft2100-upc1.p.                           */
/*     END TRIGGERS.                                                               */
/*                                                                                 */
/*     whBtExecutarUpc:LOAD-IMAGE-UP(whBtExecutarTela:IMAGE-UP).                   */
/*     whBtExecutarUpc:LOAD-IMAGE-INSENSITIVE(whBtExecutarTela:IMAGE-INSENSITIVE). */
/*                                                                                 */
/* END.                                                                            */


