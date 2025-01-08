/* ----------------------------------------------------------------------------
   Programa..: upc/cd0206-upczoom.p
   Data......: Junho/2015
   Autor.....: Rubia Oliveira - SENSUS.
   Objetivo..: Chamada de zoom do campo CATEGORIA criado dinamicamente
---------------------------------------------------------------------------- */


def var wh-pesquisa as widget-handle.
def new global shared var l-implanta     as logical init no.
def new global shared var wh-categoria   as widget-handle no-undo.
def new global shared var h-object       as handle no-undo.

assign l-implanta = NO.
{include/zoomvar.i &prog-zoom="esp/cdp/escdp078-z01.w"
                   &proghandle=h-object
                   &campohandle=wh-categoria
                   &campozoom=cod-categoria}
