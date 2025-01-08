/***********************************************************************
**  Programa..: upc\re1001b1-upcb.p
**  Autor.....: Anderson Silvano  - Gestech
**  Data......: JUNHO/2005 - Desenvolvimento
**  Descricao.: 
**  Vers∆o....: 001 - 00/00/2002
**                  Desenvolvimento Programa
************************************************************************/

DEF NEW GLOBAL SHARED VAR wh-num-pedido   AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-numero-ordem AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-parcela      AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-it-codigo    AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR gr-docum-est    AS ROWID         NO-UNDO.

DEF VAR i-num-pedido-ini LIKE pedido-compr.num-pedido.
DEF VAR i-num-pedido-fim LIKE pedido-compr.num-pedido.

IF INT(wh-num-pedido:SCREEN-VALUE) = 0 THEN
    ASSIGN i-num-pedido-ini = 0
           i-num-pedido-fim = 99999999.
ELSE
    ASSIGN i-num-pedido-ini = INT(wh-num-pedido:SCREEN-VALUE)
           i-num-pedido-fim = INT(wh-num-pedido:SCREEN-VALUE).

FIND docum-est NO-LOCK
    WHERE ROWID(docum-est) = gr-docum-est NO-ERROR.

DEF VAR hProgramZoom AS HANDLE NO-UNDO.

{method/zoomFields.i &ProgramZoom="eszoom/z01esin356.w"
                     &FieldZoom1="num-pedido"
                     &fieldHandle1=wh-num-pedido
                     &FieldZoom2="numero-ordem"
                     &fieldHandle2=wh-numero-ordem
                     &FieldZoom3="parcela"
                     &fieldHandle3=wh-parcela
                     &FieldZoom4="it-codigo"
                     &fieldHandle4=wh-it-codigo
                     &RunMethod="RUN pi-seta-inicial IN hProgramZoom (INPUT docum-est.cod-emitente, 
                                                                      INPUT wh-it-codigo:SCREEN-VALUE, 
                                                                      INPUT i-num-pedido-ini, 
                                                                      INPUT i-num-pedido-fim)."
                     &EnableImplant="NO"}
