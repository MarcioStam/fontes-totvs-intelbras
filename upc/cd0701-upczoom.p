DEFINE NEW GLOBAL SHARED VARIABLE h-class-canal-cd0701  AS HANDLE        NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-pesquisa           AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE p-wgh-object          AS HANDLE        NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE l-implanta            AS LOGICAL       INITIAL NO.
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl        AS HANDLE        NO-UNDO.
DEF VAR hProgramZoom AS HANDLE NO-UNDO.

ASSIGN l-implanta = NO.

{include/zoomvar.i &prog-zoom   = "eszoom/z01int-class-canal.w"
                   &campohandle = h-class-canal-cd0701
                   &campozoom   = codigo-classificacao
                   &proghandle  = p-wgh-object}  
