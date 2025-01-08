def var wh-pesquisa as widget-handle.
def new global shared var l-implanta as logical init no.
def new global shared var wh-cod-entrega-aux-pd4000    as widget-handle no-undo.
def new global shared var wh-cod-entrega-pd4000    as widget-handle no-undo.
DEF new global shared VAR wh-nome-abrev-pd4000            as widget-handle no-undo.
def new global shared var wh-window  as handle no-undo.
def new global shared var adm-broker-hdl as handle no-undo.


{include/zoomvar.i &prog-zoom="dizoom/z01di102.w"
                   &proghandle="wh-window"
                   &campohandle="wh-cod-entrega-aux-pd4000"
                   &campozoom="cod-entrega"
                   &parametros="run pi-seta-inicial in wh-pesquisa (input wh-nome-abrev-pd4000:screen-value)."}
                   
WAIT-FOR GO OF wh-pesquisa.

ASSIGN wh-cod-entrega-pd4000:SCREEN-VALUE = wh-cod-entrega-aux-pd4000:SCREEN-VALUE.

