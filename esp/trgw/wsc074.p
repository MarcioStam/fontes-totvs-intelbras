/**************************************************************************
**  Programa.: WSC074.p			
**  Autor....: SCM Concept
**  Data.....: Julho de 2016
**  Objetivo.: UPC de Write para a tabela WM-ETIQUETA
***************************************************************************/

DEFINE PARAMETER BUFFER p-table     FOR wm-etiqueta.
DEFINE PARAMETER BUFFER p-old-table FOR wm-etiqueta.

IF AVAIL p-table AND AVAIL p-old-table AND
   p-table.id-carga = 0 AND p-old-table.id-carga <> 0 THEN DO:

    FIND FIRST bc-etiqueta WHERE
        bc-etiqueta.progressivo = STRING(p-table.id-etiqueta) EXCLUSIVE-LOCK NO-ERROR.
    IF AVAIL bc-etiqueta THEN
        ASSIGN bc-etiqueta.id-docto = 0.

END.
