DEFINE INPUT  PARAMETER pSerie     AS CHARACTER        NO-UNDO.
DEFINE OUTPUT PARAMETER pit-codigo LIKE ITEM.it-codigo NO-UNDO.
DEFINE OUTPUT PARAMETER pdesc-item LIKE ITEM.desc-item NO-UNDO.
DEFINE OUTPUT PARAMETER pkc        AS CHARACTER        NO-UNDO.

ASSIGN pit-codigo = "0"
       pdesc-item = ""
       pkc        = "".

FIND FIRST num-serie WHERE num-serie.n-serie = pSerie NO-LOCK NO-ERROR.
IF NOT AVAIL num-serie THEN NEXT.

FIND FIRST ITEM WHERE ITEM.it-codigo = num-serie.it-codigo NO-LOCK NO-ERROR.

ASSIGN pit-codigo = ITEM.it-codigo
       pdesc-item = ITEM.desc-item
       pkc        = num-serie.ns-keycode.



