/***********************************************************************
**  Programa..: upc\re1001b1-upcb.p
**  Autor.....: Anderson Silvano  - Gestech
**  Data......: JUNHO/2005 - Desenvolvimento
**  Descricao.: 
**  Vers∆o....: 001 - 00/00/2002
**                  Desenvolvimento Programa
************************************************************************/

DEF NEW GLOBAL SHARED VAR wh-parcela      AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-numero-ordem AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-window       AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-pesquisa     AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR l-implanta      AS LOGICAL INIT NO.
DEF NEW GLOBAL SHARED VAR adm-broker-hdl  AS HANDLE NO-UNDO.

FIND FIRST ordem-compra NO-LOCK
    WHERE ordem-compra.numero-ordem = INT(wh-numero-ordem:SCREEN-VALUE) NO-ERROR.
IF AVAIL ordem-compra THEN DO:

    ASSIGN l-implanta = YES.
    {include/zoomvar.i &prog-zoom="inzoom/z01in356.w"
                       &proghandle=wh-window
                       &campohandle=wh-parcela
                       &campozoom=parcela
                       &parametros="run pi-seta-inicial in wh-pesquisa (input rowid(ordem-compra))."}
END.
ELSE DO:
    MESSAGE "Ordem Inv†lida. A ordem de compra informada n∆o est† cadastrada."
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
END.





