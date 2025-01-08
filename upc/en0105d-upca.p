/***********************************************************************
**  Programa..: upc\dp0301-upca.p
**  Autor.....: Anderson Silvano  - Gestech
**  Data......: JUNHO/2005 - Desenvolvimento
**  Descricao.: 
**  Vers∆o....: 001 - 00/00/2002
**                  Desenvolvimento Programa
************************************************************************/
DEF NEW GLOBAL SHARED VAR gr-proces-item        AS ROWID         NO-UNDO.

DEF NEW GLOBAL SHARED VAR wh-button             AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-bt-cancela         AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-seq-new            AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-num-var-estrutura  AS WIDGET-HANDLE NO-UNDO.

DEFINE TEMP-TABLE tt-estrutura NO-UNDO LIKE estrutura
    FIELD seq-new AS INT.    

DEFINE BUFFER b-estrutura FOR estrutura.

DEF VAR i-aumenta AS INT NO-UNDO.
DEF VAR i-inicial AS INT NO-UNDO.

ASSIGN i-aumenta  = INT(wh-seq-new:SCREEN-VALUE)
       i-inicial  = INT(wh-num-var-estrutura:SCREEN-VALUE).

DEFINE NEW GLOBAL SHARED VAR vRowItem AS ROWID NO-UNDO.


ON WRITE OF ESTRUTURA OLD BUFFER b-old-estrutura OVERRIDE DO:
    {include/i-epc101.i estrutura b-old-estrutura}
END.

ON WRITE OF ALTERNATIVO OLD BUFFER b-old-ALTERNATIVO OVERRIDE DO:
    {include/i-epc101.i ALTERNATIVO b-old-ALTERNATIVO}
END.

EMPTY TEMP-TABLE tt-estrutura.

FOR FIRST ITEM FIELDS(it-codigo) NO-LOCK 
    WHERE ROWID(ITEM) = vRowItem,
    EACH  estrutura NO-LOCK
    WHERE estrutura.it-codigo       = item.it-codigo    
    BY estrutura.es-codigo:    

    IF can-find(FIRST b-estrutura NO-LOCK
                WHERE b-estrutura.it-codigo = estrutura.it-codigo
                  AND b-estrutura.sequencia = i-aumenta
                  AND b-estrutura.es-codigo = estrutura.es-codigo) THEN DO:          

        ASSIGN i-aumenta = i-aumenta + i-inicial.    
        NEXT.
    END.    
    
    CREATE tt-estrutura.
    BUFFER-COPY estrutura TO tt-estrutura.
    ASSIGN tt-estrutura.seq-new = i-aumenta       
           i-aumenta           = i-aumenta + i-inicial.       
END.

FOR EACH tt-estrutura
      BY tt-estrutura.es-codigo.

    IF tt-estrutura.sequencia NE tt-estrutura.seq-new THEN DO:
        FOR EACH  alternativo EXCLUSIVE-LOCK
            WHERE alternativo.it-codigo = tt-estrutura.it-codigo
              AND alternativo.sequencia = tt-estrutura.sequencia
              AND alternativo.es-codigo = tt-estrutura.es-codigo.
        
            ASSIGN alternativo.sequencia = tt-estrutura.seq-new.
        END.
        
        FIND FIRST estrutura EXCLUSIVE-LOCK
             WHERE estrutura.it-codigo = tt-estrutura.it-codigo
               AND estrutura.sequencia = tt-estrutura.sequencia
               AND estrutura.es-codigo = tt-estrutura.es-codigo NO-ERROR.
        IF AVAIL estrutura THEN
            ASSIGN estrutura.sequencia = tt-estrutura.seq-new.
    END.
END.    

