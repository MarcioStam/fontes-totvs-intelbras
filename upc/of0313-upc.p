/*------------------------------------------------------------------------
    File        : OF0313-UPC.P
    Purpose     : UPC do programa OF0313.
    Syntax      : <none>
    Description : <none>

    Author(s)   : Francisco Almeida Fran‡a - TIC
    Created     : Agosto de 2014
    Notes       : 001 - 13/08/2014 - Implementa‡Æo de UPC para importa‡Æo
                  de dados.
----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameter Definitions ---                                            */

DEFINE INPUT  PARAMETER p-ind-event  AS CHARACTER     NO-UNDO.
DEFINE INPUT  PARAMETER p-ind-object AS CHARACTER     NO-UNDO.
DEFINE INPUT  PARAMETER p-wgh-object AS HANDLE        NO-UNDO.
DEFINE INPUT  PARAMETER p-wgh-frame  AS WIDGET-HANDLE NO-UNDO.
DEFINE INPUT  PARAMETER p-cod-table  AS CHARACTER     NO-UNDO.
DEFINE INPUT  PARAMETER p-row-table  AS ROWID         NO-UNDO.

DEFINE VARIABLE c-objeto             AS CHARACTER   NO-UNDO.
DEFINE VARIABLE wh-bt-imp-of0313     as widget-handle no-undo.

ASSIGN c-objeto = entry(num-entries(p-wgh-object:file-name,"~/"), p-wgh-object:file-name,"~/").

/* Local Variable Definitions ---                                       */


/* ***************************  Main Block  *************************** */


/*Adicionado novo campo para mostrar o Nr do pedido************/
IF p-ind-event    = "before-initialize":U  AND
     p-ind-object = "CONTAINER"        AND
     c-objeto     = "of0313.w"      THEN DO:
    
    CREATE BUTTON wh-bt-imp-of0313
    ASSIGN FRAME        = p-wgh-frame
           WIDTH        = 4
           HEIGHT       = 1.13
           ROW          = 1.13
           LABEL        = ""
           COLUMN       = 45
           SENSITIVE    = YES
           VISIBLE      = YES
           TOOLTIP      = "Importar Planilha"
           HELP         = "Importar Planilha". 
           
           if wh-bt-imp-of0313:load-image("image/gr-lay.bmp") then.
           on "choose" of wh-bt-imp-of0313  persistent run esp/pdp/espdp081.w.   /*(input p-wgh-object).*/
END.

RETURN "OK":U.
