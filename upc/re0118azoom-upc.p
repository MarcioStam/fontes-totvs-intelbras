DEFINE NEW GLOBAL SHARED VARIABLE wh-it-codigo-re0118a               AS WIDGET-HANDLE   NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-it-codigo-new-re0118a           AS WIDGET-HANDLE   NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-prog-re0118a                    AS WIDGET-HANDLE   NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-desc-item-re0118a               AS WIDGET-HANDLE   NO-UNDO.
DEF VAR wh-pesquisa AS WIDGET-HANDLE.
DEFINE VARIABLE l-implanta AS LOGICAL     NO-UNDO.

{include/zoomvar.i &prog-zoom="inzoom/z02in172.w"
                   &campohandle=wh-it-codigo-new-re0118a
                   &campozoom=it-codigo
                   &campohandle2=wh-it-codigo-re0118a
                   &campozoom2=it-codigo
                   &campohandle2=wh-desc-item-re0118a
                   &campozoom2=desc-item
                   &proghandle=wh-prog-re0118a}  

