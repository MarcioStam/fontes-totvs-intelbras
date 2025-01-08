/********************************************************************************
 ** UPC........: wes372.p - WRITE int-item
 ** Data.......: 24/02/2023
 ** Objetivo...: Altera dt-atualiza
 ********************************************************************************/
TRIGGER PROCEDURE FOR WRITE OF int-item
        NEW BUFFER p-table
        OLD BUFFER p-old-table.

DEF VAR c-campos-aux AS CHAR NO-UNDO.

IF  NOT NEW   p-table
AND AVAILABLE p-table
AND p-table.dt-atualiza <> TODAY
THEN DO:
     buffer-compare p-table except dt-atualiza to p-old-table save c-campos-aux.

     IF c-campos-aux <> ""
     THEN ASSIGN p-table.dt-atualiza = TODAY.
END. /* if not new int-item */

RETURN "OK".
