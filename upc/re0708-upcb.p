DEFINE NEW GLOBAL SHARED VARIABLE whBufferTtBrTable1RE0708 AS WIDGET-HANDLE  NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE whColumnCfopRE0708       AS WIDGET-HANDLE  NO-UNDO.

DEFINE VARIABLE hColumnCodEstab            AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE hColumnCodEmitente         AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE hColumnSerie               AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE hColumnNrNota              AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE c-cfop                     AS CHAR          NO-UNDO.

ASSIGN hColumnCodEstab    = whBufferTtBrTable1RE0708:BUFFER-FIELD("cod-estabel")
       hColumnCodEmitente = whBufferTtBrTable1RE0708:BUFFER-FIELD("cod-emitente")
       hColumnSerie       = whBufferTtBrTable1RE0708:BUFFER-FIELD("serie-docto") 
       hColumnNrNota      = whBufferTtBrTable1RE0708:BUFFER-FIELD("nro-docto").

ASSIGN c-cfop = "".

FOR FIRST doc-orig-nfe NO-LOCK
    WHERE doc-orig-nfe.cod-estabel  = hColumnCodEstab:BUFFER-VALUE
      AND doc-orig-nfe.cod-emitente = hColumnCodEmitente:BUFFER-VALUE
      AND doc-orig-nfe.serie-docto  = hColumnSerie:BUFFER-VALUE      
      AND doc-orig-nfe.nro-docto    = hColumnNrNota:BUFFER-VALUE:

    FOR EACH item-doc-orig-nfe OF doc-orig-nfe NO-LOCK:
        IF NOT INDEX(c-cfop,item-doc-orig-nfe.cod-cfop) > 0 THEN DO:
            IF c-cfop = "" THEN
                ASSIGN c-cfop = item-doc-orig-nfe.cod-cfop.
            ELSE
                ASSIGN c-cfop = c-cfop + "/" + item-doc-orig-nfe.cod-cfop.
        END.
    END.
END.
ASSIGN whColumnCfopRE0708:SCREEN-VALUE = c-cfop.



