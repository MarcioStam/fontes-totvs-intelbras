/***********************************************************************
**  Programa..: upc\re1001b1-upcb.p
**  Autor.....: Anderson Silvano  - Gestech
**  Data......: JUNHO/2005 - Desenvolvimento
**  Descricao.: 
**  Vers∆o....: 001 - 00/00/2002
**                  Desenvolvimento Programa
************************************************************************/

DEF NEW GLOBAL SHARED VAR wh-classific    AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-window       AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-pesquisa     AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR l-implanta      AS LOGICAL INIT NO.
DEF NEW GLOBAL SHARED VAR adm-broker-hdl  AS HANDLE NO-UNDO.


ASSIGN l-implanta = YES.
{include/zoomvar.i &prog-zoom="inzoom/z01in046.w"
                   &proghandle=wh-window
                   &campohandle=wh-classific
                   &campozoom=class-fiscal}



