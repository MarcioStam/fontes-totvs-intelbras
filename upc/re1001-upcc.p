DEFINE NEW GLOBAL SHARED VARIABLE h-serie-re1001         AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE h-nota-re1001          AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE h-cfop-re1001          AS WIDGET-HANDLE NO-UNDO.

/* Parametros */
DEFINE INPUT  PARAMETER p-h-browse  AS HANDLE        NO-UNDO.
DEFINE INPUT  PARAMETER p-wh-query  AS WIDGET-HANDLE NO-UNDO.

DEF VAR hFile         AS HANDLE NO-UNDO.
DEF VAR hField        AS HANDLE NO-UNDO.
DEF VAR vserie        AS CHAR   NO-UNDO.
DEF VAR vnro-docto    AS CHAR   NO-UNDO.
DEF VAR vcod-emitente AS INT    NO-UNDO.
DEF VAR vnat-operacao AS CHAR   NO-UNDO.
DEF VAR vit-codigo    AS CHAR   NO-UNDO.
DEF VAR vsequencia    AS INT    NO-UNDO.

DEF BUFFER bf-item-doc-est FOR item-doc-est.

IF  VALID-HANDLE(p-h-browse) 
AND VALID-HANDLE(p-wh-query) THEN DO:
    ASSIGN hFile         = p-wh-query:GET-BUFFER-HANDLE(1)
           hField        = hFile:BUFFER-FIELD("serie-docto")
           vserie        = hField:BUFFER-VALUE
           hField        = hFile:BUFFER-FIELD("nro-docto")
           vnro-docto    = hField:BUFFER-VALUE
           hField        = hFile:BUFFER-FIELD("cod-emitente")
           vcod-emitente = hField:BUFFER-VALUE
           hField        = hFile:BUFFER-FIELD("nat-operacao")
           vnat-operacao = hField:BUFFER-VALUE
           hField        = hFile:BUFFER-FIELD("it-codigo")
           vit-codigo    = hField:BUFFER-VALUE.

   
   FIND FIRST bf-item-doc-est NO-LOCK
         WHERE bf-item-doc-est.serie-docto  = vserie
           AND bf-item-doc-est.nro-docto    = vnro-docto
           AND bf-item-doc-est.cod-emitente = vcod-emitente
           AND bf-item-doc-est.nat-operacao = vnat-operacao
           AND bf-item-doc-est.it-codigo    = vit-codigo NO-ERROR.

    
    IF AVAIL bf-item-doc-est THEN DO:
        ASSIGN h-serie-re1001:SCREEN-VALUE = bf-item-doc-est.serie-comp  
               h-nota-re1001 :SCREEN-VALUE = bf-item-doc-est.nro-comp
               h-cfop-re1001 :SCREEN-VALUE = bf-item-doc-est.nat-comp.  
    END.
    ELSE DO:
        ASSIGN h-serie-re1001:SCREEN-VALUE = ""
               h-nota-re1001 :SCREEN-VALUE = ""
               h-cfop-re1001 :SCREEN-VALUE = "".
    END.
END. /* IF  VALID-HANDLE(p-h-browse) THEN DO: */

