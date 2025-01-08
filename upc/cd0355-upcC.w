DEF NEW GLOBAL SHARED VAR h-fpage1-cd0355       AS WIDGET-HANDLE NO-UNDO. 
DEF NEW GLOBAL SHARED VAR wh-brSon1-cd0355      AS WIDGET-HANDLE NO-UNDO. 
DEF NEW GLOBAL SHARED VAR g-h-window-cd0355     AS WIDGET-HANDLE no-undo.
DEF NEW GLOBAL SHARED VAR wh-DBOSon-cd0355      AS WIDGET-HANDLE NO-UNDO. 
DEF NEW GLOBAL SHARED VAR g-cdn-sit-tirbut-cd0355  AS INTEGER NO-UNDO. 

def var p-cdn-sit-tribut   as INTEGER no-undo.
def var p-cod-estab        as CHAR    no-undo.
def var p-cod-natur-operac AS CHAR    no-undo.
def var p-cod-ncm          as CHAR    no-undo.
def var p-cod-item         as CHAR    no-undo.
def var p-cdn-grp-emit     as INTEGER no-undo.  
def var p-cdn-emitente     as INTEGER no-undo.  
def var p-dat-valid-inic   as DATE    no-undo.
def var p-idi-tip-docto    AS INTEGER no-undo.   

RUN upc/cd0355-upcD.w (output p-cod-estab       ,
                       output p-cod-natur-operac,
                       output p-cod-ncm         ,
                       output p-cod-item        ,
                       output p-cdn-grp-emit    ,
                       output p-cdn-emitente    ,
                       output p-dat-valid-inic  ,
                       output p-idi-tip-docto   ).

RUN  goToKey IN wh-DBOSon-cd0355  (INPUT 12,                      /*cdn-tribut*/
                                   INPUT g-cdn-sit-tirbut-cd0355, /*cdn-sit-tribut*/
                                   INPUT p-cod-estab,             /*cod-estab*/
                                   INPUT p-cod-natur-operac,      /*cod-natur-operac*/
                                   INPUT p-cod-ncm,               /*cod-ncm*/
                                   INPUT p-cod-item,              /*cod-item*/
                                   INPUT p-cdn-grp-emit,          /*cdn-grp-emit*/
                                   INPUT p-cdn-emitente,          /*cdn-emitente*/
                                   INPUT p-dat-valid-inic,        /*dat-valid-inic*/
                                   INPUT p-idi-tip-docto).        /*idi-tip-docto*/

/*
RUN  goToKey IN wh-DBOSon-cd0355  (INPUT 12,         /*cdn-tribut*/
                                   INPUT 108,        /*cdn-sit-tribut*/
                                   INPUT "*",        /*cod-estab*/
                                   INPUT "1124x1",   /*cod-natur-operac*/
                                   INPUT "*",        /*cod-ncm*/
                                   INPUT "*",        /*cod-item*/
                                   INPUT 0,          /*cdn-grp-emit*/
                                   INPUT 0,          /*cdn-emitente*/
                                   INPUT 01/01/2016, /*dat-valid-inic*/
                                   INPUT 1).         /*idi-tip-docto*/
*/

DEF VAR r-row AS ROWID NO-UNDO.
RUN geTRowid IN wh-DBOSon-cd0355 (OUTPUT r-row).

FIND sit-tribut-relacto NO-LOCK
    WHERE ROWID(sit-tribut-relacto) = r-row NO-ERROR.

RUN repositionRecord IN wh-DBOSon-cd0355 /*:INSTANTIATING-PROCEDURE */ (INPUT r-row).

RUN repositionRecordSon IN g-h-window-cd0355:INSTANTIATING-PROCEDURE (INPUT r-row,
                                                                      INPUT 1).


RETURN "ok" .
