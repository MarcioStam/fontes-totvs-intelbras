/*------------------------------------------------------------------------
    File        : RE0701-UPC.P
    Purpose     : UPC do programa RE0701.
    Syntax      : <none>
    Description : <none>

    Author(s)   : Fabiano Sakae Ribeiro (Exponencial TI)
    Created     : Abril de 2013
    Notes       : 001 - 19/04/2013 - Implementa‡Æo da chamada … UPC
                  "gtupc/upc-re0701.p" desenvolvida pela Gati
                  (Fabiano Sakae Ribeiro - Exponencial TI).
----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameter Definitions ---                                            */

DEFINE INPUT  PARAMETER p-ind-event  AS CHARACTER     NO-UNDO.
DEFINE INPUT  PARAMETER p-ind-object AS CHARACTER     NO-UNDO.
DEFINE INPUT  PARAMETER p-wgh-object AS HANDLE        NO-UNDO.
DEFINE INPUT  PARAMETER p-wgh-frame  AS WIDGET-HANDLE NO-UNDO.
DEFINE INPUT  PARAMETER p-cod-table  AS CHARACTER     NO-UNDO.
DEFINE INPUT  PARAMETER p-row-table  AS ROWID         NO-UNDO.


DEF NEW GLOBAL SHARED VAR h-nr-pedido-re0701 AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-id-nota-re0701   AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-handle           AS HANDLE        NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-upc-fpage1       AS HANDLE        NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-upc-nat-operacao AS HANDLE        NO-UNDO.
DEF NEW GLOBAL SHARED VAR tx-label-ped       AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR tx-label-id        AS WIDGET-HANDLE NO-UNDO.

DEF VAR wgh-bt-inf-adic-RE0701 AS WIDGET-HANDLE NO-UNDO.
DEF VAR wh-nro-docto-re0701    AS WIDGET-HANDLE NO-UNDO.
DEF VAR c-objeto               AS CHAR          NO-UNDO.
DEF VAR c-objeto2              AS CHAR          NO-UNDO.
DEF VAR c-nro-pedido           AS CHAR          NO-UNDO.
DEF VAR v_id_nota              AS CHAR          NO-UNDO.

/* ***************************  Main Block  *************************** */

/* Identificar o objeto de tela */
ASSIGN c-objeto = ENTRY(NUM-ENTRIES(p-wgh-object:PRIVATE-DATA, "~/":U), p-wgh-object:PRIVATE-DATA, "~/":U).
ASSIGN c-objeto2 = entry(num-entries(p-wgh-object:file-name,"~/"), p-wgh-object:file-name,"~/").

/*Mensagem para verificar o ponto UPC do programa*/
/*  MESSAGE "Evento: ":U   p-ind-event  SKIP                             */
/*          "Objeto: ":U   p-ind-object SKIP                             */
/*          "Nome Obj: ":U c-objeto     SKIP                             */
/*          "Frame: ":U    p-wgh-frame  SKIP                             */
/*          "Tabela: ":U   p-cod-table  SKIP                             */
/*          "Rowid: ":U    STRING(p-row-table)                           */
/*      VIEW-AS ALERT-BOX INFO BUTTONS OK TITLE "Ponto UPC do RE0701":U. */



/*IF NOT VALID-HANDLE(wh-nro-docto-re0701) THEN
        ASSIGN wh-nro-docto-re0701 = fc-all-hdl("f-main", "nro-docto", 000).*/
/*MESSAGE   p-ind-event SKIP  
          p-ind-object SKIP
          c-objeto2   

    VIEW-AS ALERT-BOX INFO BUTTONS OK.*/

/*Adicionado novo campo para mostrar o Nr do pedido************/
IF  p-ind-event  = "before-initialize":U
AND p-ind-object = "VIEWER"
AND c-objeto2    = "v27in090.w" THEN DO:

    IF  NOT VALID-HANDLE (tx-label-ped) THEN DO:
        CREATE text tx-label-ped
        ASSIGN FRAME        = p-wgh-frame
               FORMAT       = "x(11)"
               WIDTH        = 8.0
               SCREEN-VALUE = "Nr. Pedido:"
               ROW          = 3.5
               COL          = 56.3
               FGCOLOR      = 0
               VISIBLE      = YES.      
    END.

    IF  NOT VALID-HANDLE (h-nr-pedido-re0701) THEN DO:
        CREATE FILL-IN h-nr-pedido-re0701
        ASSIGN FRAME             = p-wgh-frame
               DATA-TYPE         = "character"
               FORMAT            = "x(12)"
               SIDE-LABEL-HANDLE  = tx-label-ped:HANDLE
               WIDTH             = 12
               HEIGHT            = 0.88
               ROW               = 3.3
               COL               = 64.3
               VISIBLE           = YES
               SENSITIVE         = NO.
    END.

    IF  NOT VALID-HANDLE (tx-label-id) THEN DO:
        CREATE text tx-label-id
        ASSIGN FRAME        = p-wgh-frame
               FORMAT       = "x(11)"
               WIDTH        = 8.0
               SCREEN-VALUE = "Id Nota:"
               ROW          = 2.5
               COL          = 34.6
               FGCOLOR      = 0
               VISIBLE      = YES.      
    END.

    IF  NOT VALID-HANDLE (h-id-nota-re0701) THEN DO:
        CREATE FILL-IN h-id-nota-re0701
        ASSIGN FRAME             = p-wgh-frame
               DATA-TYPE         = "character"
               FORMAT            = "x(18)"
               SIDE-LABEL-HANDLE  = tx-label-id:HANDLE
               WIDTH             = 20
               HEIGHT            = 0.88
               ROW               = 2.3
               COL               = 40.3
               VISIBLE           = YES
               SENSITIVE         = YES
               READ-ONLY         = YES.
    END.

END.

IF  p-ind-event <> "DISPLAY":U
AND p-ind-object = "viewer"
AND c-objeto2    = "v27in090.w" THEN DO:

    IF  p-row-table <> ? THEN DO:
        FIND FIRST docum-est 
            WHERE ROWID(docum-est) = p-row-table NO-LOCK NO-ERROR.
          
        IF  AVAIL docum-est THEN
            FIND FIRST int-docum-est OF docum-est NO-LOCK NO-ERROR.
              
        IF  AVAIL int-docum-est THEN
            ASSIGN c-nro-pedido = STRING(int-docum-est.nr-pedido)
                   v_id_nota    = STRING(ROWID(docum-est)).
    END.

    IF  VALID-HANDLE (h-nr-pedido-re0701) THEN DO:
        ASSIGN h-nr-pedido-re0701:SCREEN-VALUE = c-nro-pedido.
    END.

    IF  VALID-HANDLE (h-id-nota-re0701) THEN DO:
        ASSIGN h-id-nota-re0701:SCREEN-VALUE = v_id_nota.
    END.
END.

/**************************************************************/


/* Chamada UPC referente ao Importador XML Gati */
IF  SEARCH("gtupc/upc-re0701.p") <> ?
OR  SEARCH("gtupc/upc-re0701.r") <> ? THEN
    RUN gtupc/upc-re0701.p (INPUT p-ind-event,
                            INPUT p-ind-object,
                            INPUT p-wgh-object,
                            INPUT p-wgh-frame,
                            INPUT p-cod-table,
                            INPUT p-row-table).

RETURN "OK":U.
