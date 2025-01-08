/******************************************************************
** Programa: upc-re0708-u01.p
** Objetivo: CRIAR button falseo
**    Autor: 
**     Data: abr/2023
*******************************************************************/

/* variaveis dos objetos */
DEF NEW GLOBAL SHARED VAR wh-re0708-btReprocessa2        AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-re0708-btReprocessa2-f      AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-re0708-browse-brTable2      AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-re0708-query-buffer         AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-re0708-buffer               AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-re0708-fill-in-cod-estabel  AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-re0708-fill-in-cod-emitente AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-re0708-fill-in-serie-docto  AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-re0708-fill-in-nro-docto    AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-re0708-fill-in-r-rowid      AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-re0708-btAtualiza           AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR l-cte-saida                    AS LOG           NO-UNDO.

DEF VAR l-ok           AS LOG  NO-UNDO.
DEF VAR l-processou    AS LOG  NO-UNDO.
DEF VAR c-chave        AS CHAR NO-UNDO.
DEF VAR c-serie        AS CHAR NO-UNDO.
DEF VAR c-nota         AS CHAR NO-UNDO.  
DEF VAR l-cte-dev      AS LOG  NO-UNDO.
DEF VAR l-cte-log      AS LOG  NO-UNDO.
DEF VAR l-cte-comp     AS LOG  NO-UNDO.
DEF VAR l-cte-compra   AS LOG  NO-UNDO.
DEF VAR c-tipo-entrada AS CHAR NO-UNDO.
DEF VAR iCont          AS INT  NO-UNDO.
DEF VAR c-estab-ini    AS CHAR NO-UNDO.
DEF VAR c-estab-fim    AS CHAR NO-UNDO.
DEF VAR c-cnpj         AS CHAR NO-UNDO.

DEF VAR h-esreapi0708  AS HANDLE.

IF NOT VALID-HANDLE(h-esreapi0708) THEN
   RUN upc/esreapi0708.p PERSISTENT SET h-esreapi0708.

IF VALID-HANDLE(wh-re0708-browse-brTable2) THEN DO:

    DO icont = 1 TO wh-re0708-browse-brTable2:NUM-SELECTED-ROWS:

        IF wh-re0708-browse-brTable2:FETCH-SELECTED-ROW[icont] THEN 

            wh-re0708-query-buffer  = wh-re0708-browse-brTable2:QUERY.
            wh-re0708-buffer    = wh-re0708-query-buffer:GET-BUFFER-HANDLE(1).
            
            wh-re0708-fill-in-cod-estabel   = wh-re0708-browse-brTable2:GET-BROWSE-COLUMN(1).
            wh-re0708-fill-in-cod-emitente  = wh-re0708-browse-brTable2:GET-BROWSE-COLUMN(2).
            wh-re0708-fill-in-serie-docto   = wh-re0708-browse-brTable2:GET-BROWSE-COLUMN(4).
            wh-re0708-fill-in-nro-docto     = wh-re0708-browse-brTable2:GET-BROWSE-COLUMN(5).

            FIND FIRST docto-orig-cte NO-LOCK 
                 WHERE docto-orig-cte.serie-docto   = wh-re0708-fill-in-serie-docto:SCREEN-VALUE 
                   AND docto-orig-cte.nro-docto     = wh-re0708-fill-in-nro-docto:SCREEN-VALUE 
                   AND docto-orig-cte.cod-emitente  = INT(wh-re0708-fill-in-cod-emitente:SCREEN-VALUE)
                   AND docto-orig-cte.idi-orig-trad = 2
                   NO-ERROR.

            IF AVAIL docto-orig-cte THEN DO:
                ASSIGN l-cte-saida  = NO
                       l-cte-dev    = NO
                       l-cte-log    = NO
                       l-cte-comp   = NO
                       l-cte-compra = NO.

               IF CAN-FIND(FIRST int-natur-gener-cte
                           WHERE int-natur-gener-cte.nat-operacao = docto-orig-cte.nat-operacao
                             AND int-natur-gener-cte.log-ativo) THEN DO:

                  IF NOT CAN-FIND(FIRST rat-docto-orig-cte 
                                  WHERE rat-docto-orig-cte.cod-aces-comp-nfe = docto-orig-cte.cod-aces-comp-nfe
                                    AND rat-docto-orig-cte.idi-orig-trad     = docto-orig-cte.idi-orig-trad) THEN DO:



                       FOR FIRST rat-docto-orig-cte NO-LOCK 
                           WHERE rat-docto-orig-cte.cod-aces-comp-nfe = docto-orig-cte.cod-aces-comp-nfe
                             AND rat-docto-orig-cte.idi-orig-trad     = 1:

                           RUN pi-define-tipo-entrada IN h-esreapi0708(INPUT ROWID(docto-orig-cte),        
                                                                       INPUT ROWID(rat-docto-orig-cte),
                                                                       OUTPUT l-cte-dev,               
                                                                       OUTPUT l-cte-saida,             
                                                                       OUTPUT l-cte-log,
                                                                       OUTPUT l-cte-compra).

                       END.
                  END.
                  ELSE DO:
                      FOR FIRST rat-docto-orig-cte NO-LOCK 
                          WHERE rat-docto-orig-cte.cod-aces-comp-nfe = docto-orig-cte.cod-aces-comp-nfe
                            AND rat-docto-orig-cte.idi-orig-trad     = docto-orig-cte.idi-orig-trad:

                          RUN pi-define-tipo-entrada IN h-esreapi0708(INPUT ROWID(docto-orig-cte),
                                                                      INPUT ROWID(rat-docto-orig-cte),
                                                                      OUTPUT l-cte-dev,               
                                                                      OUTPUT l-cte-saida,             
                                                                      OUTPUT l-cte-log,
                                                                      OUTPUT l-cte-compra).
                      END.
                  END.

                  /* CTe Complementar */
                  IF (docto-orig-cte.tp-nf = "1") THEN DO:
                    ASSIGN l-cte-comp = YES.
                  END.
               END.
               ELSE DO:
                    RUN utp/ut-msgs.p (INPUT "show",
                                       INPUT 15825,
                                       INPUT "Natureza Generica n∆o Cadastrada!~~Natureza n∆o localizada NO cadastro generico: " + docto-orig-cte.nat-operacao).

                    ASSIGN  l-cte-saida  = NO
                            l-cte-dev    = NO
                            l-cte-log    = NO
                            l-cte-comp   = NO
                            l-cte-compra = NO.
               END.
                
               /* CTe Complementar */
               IF (l-cte-comp) THEN DO:
                    ASSIGN c-tipo-entrada = "l-cte-comp".
                    RUN pi-gera-docto-recebimento-complementar IN h-esreapi0708(INPUT ROWID(docto-orig-cte),
                                                                                INPUT c-tipo-entrada,
                                                                                OUTPUT l-processou).
               END.
               ELSE DO:
                   /* Demais CT-e */
                   ASSIGN c-tipo-entrada = "".
                   IF l-cte-saida  THEN ASSIGN c-tipo-entrada = "l-cte-saida".
                   IF l-cte-dev    THEN ASSIGN c-tipo-entrada = "l-cte-dev".
                   IF l-cte-log    THEN ASSIGN c-tipo-entrada = "l-cte-log".
                    
                   IF (l-cte-saida OR l-cte-dev OR l-cte-log) THEN DO:
                        RUN pi-gera-docto-recebimento IN h-esreapi0708(INPUT ROWID(docto-orig-cte),
                                                                       INPUT c-tipo-entrada,
                                                                       OUTPUT l-processou).
            
                   END.
               END.
            END.

            IF VALID-HANDLE(h-esreapi0708) THEN DO:
                DELETE PROCEDURE h-esreapi0708.
                ASSIGN h-esreapi0708 = ?.
            END.
        END.
        
    IF l-cte-saida = NO AND l-cte-dev = NO AND l-cte-log = NO AND l-cte-comp = NO THEN
       APPLY "CHOOSE" TO wh-re0708-btReprocessa2.
    ELSE DO:
         IF VALID-HANDLE(wh-re0708-btAtualiza) THEN
            APPLY "CHOOSE" TO wh-re0708-btAtualiza.
    END.
       
END.
IF VALID-HANDLE(h-esreapi0708) THEN DO:

    DELETE PROCEDURE h-esreapi0708.
    ASSIGN h-esreapi0708 = ?.
END.
