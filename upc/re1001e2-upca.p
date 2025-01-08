/*************************************************************************************
**       Programa: upc/re1001e2-upca.p
**  Descricao.: inclui coluna CFOP na tela do re1001e2
****************************************************************************************/

define new global shared variable h-campo-cfop-re1001e2 as handle no-undo.

/* Parametros */
DEFINE INPUT  PARAMETER p-h-browse  AS HANDLE        NO-UNDO.
DEFINE INPUT  PARAMETER p-wh-query  AS WIDGET-HANDLE NO-UNDO.

def buffer bf-it-nota-fisc for it-nota-fisc.
DEF VAR hFile        AS HANDLE NO-UNDO.
DEF VAR hField       AS HANDLE NO-UNDO.
DEF VAR vcod-estabel AS CHAR   NO-UNDO.
DEF VAR vserie       AS CHAR   NO-UNDO.
DEF VAR vnr-nota-fis AS CHAR   NO-UNDO.
DEF VAR vnr-seq-fat  AS INT    NO-UNDO.
DEF VAR vit-codigo   AS CHAR   NO-UNDO.

IF  VALID-HANDLE(p-h-browse) THEN DO:
    ASSIGN hFile        = p-wh-query:GET-BUFFER-HANDLE(1)
           hField       = hFile:BUFFER-FIELD("cod-estabel")
           vcod-estabel = hField:BUFFER-VALUE
           hField       = hFile:BUFFER-FIELD("serie")
           vserie       = hField:BUFFER-VALUE
           hField       = hFile:BUFFER-FIELD("nr-nota-fis")
           vnr-nota-fis = hField:BUFFER-VALUE
           hField       = hFile:BUFFER-FIELD("nr-seq-fat")
           vnr-seq-fat  = hField:BUFFER-VALUE
           hField       = hFile:BUFFER-FIELD("it-codigo")
           vit-codigo   = hField:BUFFER-VALUE.

    find first bf-it-nota-fisc no-lock 
        where  bf-it-nota-fisc.cod-estabel = vcod-estabel
        AND    bf-it-nota-fisc.serie       = vserie
        AND    bf-it-nota-fisc.nr-nota-fis = vnr-nota-fis
        AND    bf-it-nota-fisc.nr-seq-fat  = vnr-seq-fat
        AND    bf-it-nota-fisc.it-codigo   = vit-codigo no-error.
    IF  AVAIL  bf-it-nota-fisc 
    THEN ASSIGN h-campo-cfop-re1001e2:SCREEN-VALUE = bf-it-nota-fisc.nat-operacao.
    ELSE ASSIGN h-campo-cfop-re1001e2:SCREEN-VALUE = "":U.
END. /* IF  VALID-HANDLE(p-h-browse) THEN DO: */

