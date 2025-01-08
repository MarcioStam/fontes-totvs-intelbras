def new global shared var wh-pesquisa as widget-handle.
def new global shared var l-implanta as logical init no.
def new global shared var wh-nome-transp-aux-ft4003-upc    as widget-handle no-undo.
def new global shared var wh-nome-transp-ft4003-upc         as widget-handle no-undo.
DEF NEW GLOBAL SHARED VAR wh-c-desc-transp-ft4003-upc       AS WIDGET-HANDLE NO-UNDO.
def new global shared var wh-window  as handle no-undo.
def new global shared var adm-broker-hdl as handle no-undo.

ASSIGN l-implanta = YES.

{include/zoomvar.i &prog-zoom=adzoom/z01ad268.w
                   &proghandle=wh-window
                   &campohandle=wh-nome-transp-aux-ft4003-upc
                   &campozoom=nome-abrev
                   &campohandle2=wh-c-desc-transp-ft4003-upc
                   &campozoom2=nome}

