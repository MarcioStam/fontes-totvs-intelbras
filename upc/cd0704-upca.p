/* ----------------------------------------------------------------------------
   Programa..: upc/cd0704-upca.p
   Data......: 24/02/2004.
   Autor.....: Ivan G. Steinbach - DTS Logistica.
   Objetivo..: Chamada de zoom do campo ESTADO criado dinamicamente
---------------------------------------------------------------------------- */


def var wh-pesquisa as widget-handle.
def new global shared var l-implanta     as logical init no.
def new global shared var whEstadoLocal  as widget-handle no-undo.
def new global shared var wh-window      as handle no-undo.
def new global shared var adm-broker-hdl as handle no-undo.

assign l-implanta = yes.
{include/zoomvar.i &prog-zoom="unzoom/z01un007.w"
                   &proghandle=wh-window
                   &campohandle=whEstadoLocal
                   &campozoom=estado}
