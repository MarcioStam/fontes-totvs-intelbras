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

DEF VAR i-aumenta AS INT.
DEF VAR i-inicial AS INT.

ASSIGN i-aumenta  = INT(wh-seq-new:SCREEN-VALUE)
       i-inicial  = INT(wh-num-var-estrutura:SCREEN-VALUE).

FOR FIRST dp-proces-item NO-LOCK
    WHERE ROWID(dp-proces-item) = gr-proces-item,
    EACH  dp-estrut 
    WHERE dp-estrut.item-dp         = dp-proces-item.item-dp
    AND   dp-estrut.num-proces-item = dp-proces-item.num-proces-item
    BY dp-estrut.es-codigo:
    
    ASSIGN dp-estrut.sequencia = i-aumenta
           i-aumenta           = i-inicial + i-aumenta.
END.

    
