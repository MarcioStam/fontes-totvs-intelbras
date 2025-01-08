/***********************************************************************************
***********************************************************************************/

{include/i-prgvrs.i CQ0222-UPC 2.00.00.001 } /*** 010001 ***/

/*************************** Parametros Padrao ************************************/
DEFINE INPUT PARAM p-ind-event                         AS CHARACTER         NO-UNDO.
DEFINE INPUT PARAM p-ind-object                        AS CHARACTER         NO-UNDO.
DEFINE INPUT PARAM p-wgh-object                        AS HANDLE            NO-UNDO.
DEFINE INPUT PARAM p-wgh-frame                         AS WIDGET-HANDLE     NO-UNDO.
DEFINE INPUT PARAM p-cod-table                         AS CHARACTER         NO-UNDO.
DEFINE INPUT PARAM p-row-table                         AS ROWID             NO-UNDO.
/************************************************************************************/

/*************************** Global Variable Definitions ****************************/
DEF NEW GLOBAL SHARED VAR wh-bt-retorno   AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-bt-rejeicao  AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-bt-confirmar AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-bt-brRoteiro  AS WIDGET-HANDLE NO-UNDO.

/************************** Local Variable Definitions *************************/
DEFINE VARIABLE wh-frame AS WIDGET-HANDLE NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE h-upc-cq0222 AS HANDLE NO-UNDO.

{utp/ut-glob.i}

FUNCTION getWidgetHandle RETURNS WIDGET-HANDLE (INPUT pWidget AS CHAR) FORWARD.

IF p-ind-event = "AFTER-DISPLAY" THEN DO:

     RUN upc/upc-cq0222.p PERSISTENT SET h-upc-cq0222 (INPUT '',
                                                       INPUT '',
                                                       INPUT ?,
                                                       INPUT p-wgh-frame,
                                                       INPUT '',
                                                       INPUT ?).
    
    IF NOT VALID-HANDLE (wh-bt-retorno) THEN
        ASSIGN wh-bt-retorno = getWidgetHandle("bt-Retorno").

    IF NOT VALID-HANDLE (wh-bt-rejeicao) THEN
        ASSIGN wh-bt-rejeicao = getWidgetHandle("bt-Rejeicao").

    IF NOT VALID-HANDLE (wh-bt-confirmar) THEN
        ASSIGN wh-bt-confirmar = getWidgetHandle("bt-Confirmar").

     IF NOT VALID-HANDLE (wh-bt-brRoteiro) THEN
        ASSIGN wh-bt-brRoteiro = getWidgetHandle("brRoteiro").

    IF VALID-HANDLE(wh-bt-brRoteiro) THEN
        RUN piVeriGrup.

    ON VALUE-CHANGED OF wh-bt-brRoteiro PERSISTENT RUN piVeriGrup IN h-upc-cq0222.

END.

PROCEDURE piVeriGrup:

 DEF VAR h-query AS HANDLE NO-UNDO.
 DEF VAR l-logical AS LOGICAL NO-UNDO.
 

 IF VALID-HANDLE(wh-bt-brRoteiro) THEN DO:

     ASSIGN h-query = wh-bt-brRoteiro:QUERY.
 
     ASSIGN l-logical = IF h-query:NUM-RESULTS > 0 THEN h-query:GET-CURRENT() ELSE NO.
 
     IF NOT l-logical THEN RETURN 'OK':U.
 
     FIND FIRST ficha-cq NO-LOCK
          WHERE ficha-cq.nr-ficha  = INTEGER(h-query:GET-BUFFER-HANDLE():BUFFER-FIELD("nr-ficha":U):BUFFER-VALUE) NO-ERROR.
 
     IF AVAIL ficha-cq THEN DO:

         IF ficha-cq.origem = 2 AND ficha-cq.cod-emitente <> 0 AND ficha-cq.nat-operacao <> "" THEN DO:

           FIND FIRST ITEM NO-LOCK
                WHERE ITEM.it-codigo = ficha-cq.it-codigo NO-ERROR.

               IF AVAIL ITEM THEN DO:

                   FIND FIRST in-grup-estoq NO-LOCK
                        WHERE in-grup-estoq.ge-codigo = ITEM.ge-codigo NO-ERROR.
        
                      IF AVAIL in-grup-estoq AND in-grup-estoq.log-ckd = YES THEN DO:

                           IF VALID-HANDLE(wh-bt-confirmar) THEN ASSIGN wh-bt-confirmar:SENSITIVE = NO.
                           IF VALID-HANDLE(wh-bt-retorno)   THEN ASSIGN wh-bt-retorno:SENSITIVE = NO. 
                           IF VALID-HANDLE(wh-bt-rejeicao)  THEN ASSIGN wh-bt-rejeicao:SENSITIVE = NO. 

                      END.

               END.

         END.
           
     END.
 
 END.
 
 RETURN 'OK':U.

END PROCEDURE.
    

FUNCTION getWidgetHandle RETURNS WIDGET-HANDLE
    (INPUT pWidget  AS CHAR).
    DEFINE VARIABLE wh-WIDGET-HANDLE    AS WIDGET-HANDLE    NO-UNDO.
    ASSIGN wh-frame = p-wgh-frame:FIRST-CHILD
           wh-frame = wh-frame:FIRST-CHILD.

    DO WHILE wh-frame <> ?:
        IF wh-frame:NAME = pWidget THEN DO:
            ASSIGN wh-WIDGET-HANDLE = wh-frame:HANDLE.
            LEAVE.
        END.
        ASSIGN wh-frame = wh-frame:NEXT-SIBLING.
    END.
    RETURN wh-WIDGET-HANDLE.
END FUNCTION.
