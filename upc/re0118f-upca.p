/*************************************************************************************
**       Programa: upc/re0118f-upca.p
**  Descricao.: inclui coluna CFOP na tela do re0118f
****************************************************************************************/

define new global shared variable h-campo-cfop-re0118f as handle no-undo.

/* Parametros */
DEFINE INPUT  PARAMETER p-h-browse  AS HANDLE        NO-UNDO.
DEFINE INPUT  PARAMETER p-wh-query  AS WIDGET-HANDLE NO-UNDO.

def buffer bf-it-nota-fisc for it-nota-fisc.
DEF VAR hFile           AS HANDLE NO-UNDO.
DEF VAR hField          AS HANDLE NO-UNDO.
DEF VAR vnro-docto      AS CHAR   NO-UNDO.
DEF VAR vcod-emitente   AS INT    NO-UNDO.
DEF VAR vserie-docto    AS CHAR   NO-UNDO.
DEF VAR vnat-operacao   AS CHAR   NO-UNDO.
DEF VAR vit-codigo      AS CHAR   NO-UNDO.
DEF VAR vseq-saldo-terc AS INT    NO-UNDO.

IF  VALID-HANDLE(p-h-browse) THEN DO:
    ASSIGN hFile           = p-wh-query:GET-BUFFER-HANDLE(1)
           hField          = hFile:BUFFER-FIELD("nro-docto")
           vnro-docto      = hField:BUFFER-VALUE
           hField          = hFile:BUFFER-FIELD("cod-emitente")
           vcod-emitente   = hField:BUFFER-VALUE
           hField          = hFile:BUFFER-FIELD("serie-docto")
           vserie-docto    = hField:BUFFER-VALUE
           hField          = hFile:BUFFER-FIELD("nat-operacao")
           vnat-operacao   = hField:BUFFER-VALUE
           hField          = hFile:BUFFER-FIELD("it-codigo")
           vit-codigo      = hField:BUFFER-VALUE
           hField          = hFile:BUFFER-FIELD("seq-saldo-terc")
           vseq-saldo-terc = hField:BUFFER-VALUE.

    FIND FIRST it-nota-fisc NO-LOCK
         WHERE it-nota-fisc.nr-nota-fis  = vnro-docto      
           AND it-nota-fisc.serie        = vserie-docto    
           AND it-nota-fisc.nat-operacao = vnat-operacao   
           AND it-nota-fisc.it-codigo    = vit-codigo      
           AND it-nota-fisc.nr-seq-fat   = vseq-saldo-terc NO-ERROR.

    IF  AVAIL  it-nota-fisc THEN 
        ASSIGN h-campo-cfop-re0118f:SCREEN-VALUE = it-nota-fisc.nat-operacao.
    ELSE 
        ASSIGN h-campo-cfop-re0118f:SCREEN-VALUE = "":U.
END. /* IF  VALID-HANDLE(p-h-browse) THEN DO: */

