/* ----------------------------------------------------------------------------
   Programa..: upc/cd0206-upczoom.p
   Data......: Junho/2015
   Autor.....: Rubia Oliveira - SENSUS.
   Objetivo..: Chamada de zoom do campo CATEGORIA criado dinamicamente
---------------------------------------------------------------------------- */


def var wh-pesquisa as widget-handle.
def new global shared var l-implanta     as logical init no.
DEFINE NEW GLOBAL SHARED VARIABLE wh-nr-oper-pad-new-en0507b AS WIDGET-HANDLE NO-UNDO.
def new global shared var h-object       as handle no-undo.

assign l-implanta = NO.
{include/zoomvar.i &prog-zoom="inzoom/z01in261.w"
                   &proghandle=h-object
                   &campohandle=wh-nr-oper-pad-new-en0507b
                   &campozoom=nr-oper-pad}
