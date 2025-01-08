/****************************************************************************
** Programa : CP0511-UPC
** Descricao: Inclusao filtro por Estabelecimento
**     Autor: Isac Abrahao
**      Data: 04/02/2021
*****************************************************************************/
/***  Parametros de recepao da UPC **/

DEF INPUT PARAM p-ind-event      AS CHAR            NO-UNDO.
DEF INPUT PARAM p-ind-object     AS CHAR            NO-UNDO.
DEF INPUT PARAM p-wgh-object     AS HANDLE          NO-UNDO.
DEF INPUT PARAM p-wgh-frame      AS WIDGET-HANDLE   NO-UNDO.
DEF INPUT PARAM p-cod-table      AS CHAR            NO-UNDO.
DEF INPUT PARAM p-row-table      AS ROWID           NO-UNDO.

DEF VAR c-objeto   AS CHAR            NO-UNDO.
DEF VAR wh-objeto  AS WIDGET-HANDLE   NO-UNDO.

DEF VAR wh-objeto2 AS WIDGET-HANDLE   NO-UNDO.
DEF VAR wh-objeto3 AS WIDGET-HANDLE   NO-UNDO.

DEF NEW GLOBAL SHARED VAR wh-query-brw      AS HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-buffer-brw     AS HANDLE NO-UNDO.

DEF NEW GLOBAL SHARED VAR wh-browse-cp0511  AS HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-buffer-tt      AS HANDLE NO-UNDO. 

DEF NEW GLOBAL SHARED VAR wh-estab-ini-cp0511     AS HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-estab-fim-cp0511     AS HANDLE NO-UNDO.

DEF NEW GLOBAL SHARED VAR wh-new-col-estab-cp0511 AS HANDLE NO-UNDO.

DEFINE NEW GLOBAL SHARED TEMP-TABLE tt-ord-prod-aux NO-UNDO LIKE ord-prod
       field RowNum  as integer
       field r-rowid as rowid.

DEFINE TEMP-TABLE tt-ord-prod2 NO-UNDO LIKE ord-prod
       field RowNum  as integer
       field r-rowid as rowid.

/***  identificando nome de objeto ***/
ASSIGN c-objeto = ENTRY(NUM-ENTRIES(p-wgh-object:FILE-NAME, "~/") ,p-wgh-object:FILE-NAME, "~/"). 

DEFINE VARIABLE i-cont AS INTEGER NO-UNDO.                      

/*
message "Evento    " p-ind-event  skip        
        "Objeto    " p-ind-object skip        
        "nome obj  " c-objeto     skip        
        "Frame     " p-wgh-frame  skip        
        "Tabela    " p-cod-table  skip        
        "ROWID     " string(p-row-table) SKIP 
        view-as alert-box information.        */

IF p-ind-event  = "AFTER-INITIALIZE" THEN 
DO:
    ASSIGN wh-objeto = p-wgh-frame:FIRST-CHILD
           wh-objeto = wh-objeto:FIRST-CHILD.
     
    DO WHILE VALID-HANDLE(wh-objeto):
       
       IF wh-objeto:TYPE = "FRAME" THEN 
       DO:
           ASSIGN wh-objeto2 = wh-objeto:FIRST-CHILD.
 
           DO WHILE VALID-HANDLE(wh-objeto2):

              IF wh-objeto2:TYPE = "field-group" THEN 
              DO:
                  ASSIGN wh-objeto3 = wh-objeto2:FIRST-CHILD. 
 
                  Do While valid-handle(wh-objeto3):

                     IF wh-objeto3:NAME = 'brTable' THEN
                     DO:
                        wh-browse-cp0511 = wh-objeto3:HANDLE.

                        wh-browse-cp0511:HANDLE:add-calc-column('CHARACTER','x(03)','','Estab',2).

                        wh-new-col-estab-cp0511       = wh-browse-cp0511:get-browse-column(2).
                        wh-new-col-estab-cp0511:WIDTH = 5. 

                        wh-query-brw = wh-browse-cp0511:QUERY.
                        
                        on "row-display" OF wh-browse-cp0511 persistent run upc/cp0511-upc.p ('Row-Display-brTable', 
                                                                                               p-ind-object,
                                                                                               p-wgh-object,
                                                                                               p-wgh-frame, 
                                                                                               p-cod-table, 
                                                                                               p-row-table).

                        on "ENTRY" OF wh-browse-cp0511 persistent run upc/cp0511-upc.p ('ENTRY-BROWSE', 
                                                                                        p-ind-object,
                                                                                        p-wgh-object,
                                                                                        p-wgh-frame, 
                                                                                        p-cod-table, 
                                                                                        p-row-table).
                     END.                                                    
 
                     Assign wh-objeto3 = wh-objeto3:next-sibling no-error.      
                  END.
              END.                                
              
              Assign wh-objeto2 = wh-objeto2:next-sibling no-error.
           END.
       END.
 
       ASSIGN wh-objeto = wh-objeto:NEXT-SIBLING NO-ERROR.
    END.

END.


IF p-ind-event = 'Row-Display-brTable' THEN
DO:
   IF VALID-HANDLE(wh-browse-cp0511) AND VALID-HANDLE(wh-new-col-estab-cp0511) THEN
   DO:
      ASSIGN wh-buffer-brw = wh-query-brw:GET-BUFFER-HANDLE(1).

      FIND FIRST ord-prod WHERE ord-prod.nr-ord-produ = wh-buffer-brw:Buffer-field("nr-ord-produ"):BUFFER-VALUE NO-LOCK NO-ERROR.

      IF AVAIL ord-prod THEN
         ASSIGN wh-new-col-estab-cp0511:SCREEN-VALUE = ord-prod.cod-estabel.
   END.
END.


IF p-ind-event = 'ENTRY-BROWSE' THEN
DO:
   RUN pi-recarrega-browse.
END.



PROCEDURE pi-recarrega-browse:

    DEFINE VARIABLE l-prox-reg AS LOGICAL NO-UNDO.

    IF VALID-HANDLE(wh-browse-cp0511) THEN
    DO:
       wh-query-brw = wh-browse-cp0511:QUERY.
      
       // Sai da Rotina quando filtro nao preenchido 
       IF wh-query-brw:NUM-RESULTS = 0 THEN LEAVE.   
      
       // Quando estabelecimento nao informado nao entra na rotina de filtro customizado
       IF VALID-HANDLE(wh-estab-ini-cp0511) THEN
          IF wh-estab-ini-cp0511:SCREEN-VALUE = '' THEN LEAVE.
      
       FOR EACH tt-ord-prod2: DELETE tt-ord-prod2. END.
      
       ASSIGN i-cont = 0.
      
       //DO i-cont = 1 TO wh-query-brw:NUM-RESULTS:
       REPEAT:
      
          ASSIGN i-cont = i-cont + 1.
      
          ASSIGN l-prox-reg = YES.
       
          IF i-cont = 1 THEN
             wh-query-brw:GET-FIRST().
          ELSE
             ASSIGN l-prox-reg = wh-query-brw:GET-NEXT().

          // ULTIMO REGISTRO 
          IF NOT l-prox-reg THEN LEAVE. 
      
          ASSIGN wh-buffer-brw = wh-query-brw:GET-BUFFER-HANDLE().
          
          IF VALID-HANDLE(wh-estab-ini-cp0511) THEN
          DO:
             FIND FIRST ord-prod WHERE ord-prod.nr-ord-produ = wh-buffer-brw:Buffer-field("nr-ord-produ"):BUFFER-VALUE NO-LOCK NO-ERROR.

             IF AVAIL ord-prod THEN
             DO:
                IF ord-prod.cod-estabel < wh-estab-ini-cp0511:SCREEN-VALUE OR 
                   ord-prod.cod-estabel > wh-estab-fim-cp0511:SCREEN-VALUE THEN
                   wh-buffer-brw:BUFFER-DELETE().                         
             END.                                                         
          END.    

       END.  
      
       IF VALID-HANDLE(wh-estab-ini-cp0511) THEN
          ASSIGN wh-estab-ini-cp0511:SCREEN-VALUE = ''
                 wh-estab-fim-cp0511:SCREEN-VALUE = 'ZZZZZ'.
      
       IF wh-query-brw:NUM-RESULTS > 0 THEN
          wh-browse-cp0511:REFRESH() NO-ERROR.
    END.
END.




