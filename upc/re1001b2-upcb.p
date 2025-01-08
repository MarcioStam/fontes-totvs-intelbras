/***********************************************************************
**  Programa..: upc\re1001b1-upcb.p
**  Autor.....: Anderson Silvano  - Gestech
**  Data......: JUNHO/2005 - Desenvolvimento
**  Descricao.: 
**  Vers∆o....: 001 - 00/00/2002
**                  Desenvolvimento Programa
************************************************************************/

DEF NEW GLOBAL SHARED VAR wh-nr-ord-produ AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-it-codigo    AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR gr-item-doc-est AS ROWID         NO-UNDO.

FIND item-doc-est NO-LOCK
    WHERE ROWID(item-doc-est) = gr-item-doc-est NO-ERROR.

DEF VAR hProgramZoom AS HANDLE NO-UNDO.

{method/zoomFields.i &ProgramZoom="eszoom/z01esin271.w"
                     &FieldZoom1="nr-ord-produ"
                     &fieldHandle1=wh-nr-ord-produ
                     &RunMethod="RUN pi-seta-inicial IN hProgramZoom (INPUT item-doc-est.it-codigo)."
                     &EnableImplant="NO"}
