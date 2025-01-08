/******************************************************************
** Programa: upc-re0708L-u02.p
** Objetivo: CRIAR button falseo (ATENÄ«O: mesma l¢gica do upc-re0708-u02.p)
**    Autor: 
**     Data: abr/2023
*******************************************************************/

/* variaveis dos objetos */
DEF NEW GLOBAL SHARED VAR wh-re0708L-btReprocessa2        AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-re0708L-btReprocessa2-f      AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-re0708L-browse-brTable2      AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-re0708L-query-buffer         AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-re0708L-buffer               AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-re0708L-fill-in-cod-estabel  AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-re0708L-fill-in-cod-emitente AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-re0708L-fill-in-serie-docto  AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-re0708L-fill-in-nro-docto    AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-re0708L-fill-in-r-rowid      AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-re0708L-btAtualiza           AS WIDGET-HANDLE NO-UNDO.

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

DEF VAR h-esreapi0708  AS HANDLE NO-UNDO.

DEFINE VARIABLE hQuery            AS HANDLE  NO-UNDO.
DEFINE VARIABLE l-executar-padrao AS LOGICAL NO-UNDO.

IF NOT VALID-HANDLE(h-esreapi0708) THEN
   RUN upc/esreapi0708.p PERSISTENT SET h-esreapi0708.

IF VALID-HANDLE(wh-re0708L-browse-brTable2) THEN DO:    

    wh-re0708L-query-buffer  = wh-re0708L-browse-brTable2:QUERY.
    wh-re0708L-buffer    = wh-re0708L-query-buffer:GET-BUFFER-HANDLE().
          
    CREATE QUERY hQuery.

    hQuery:SET-BUFFERS(wh-re0708L-buffer).
    hQuery:QUERY-PREPARE("FOR EACH " + wh-re0708L-buffer:NAME + " where marca" ).
    hQuery:QUERY-OPEN().
    hQuery:GET-FIRST().   
    
    ASSIGN l-executar-padrao = NO.

    DO WHILE hQuery:QUERY-OFF-END = FALSE:
        
        FIND FIRST docto-orig-cte NO-LOCK 
             WHERE docto-orig-cte.serie-docto   = wh-re0708L-buffer:BUFFER-FIELD(1):BUFFER-VALUE
               AND docto-orig-cte.nro-docto     = wh-re0708L-buffer:BUFFER-FIELD(2):BUFFER-VALUE
               AND docto-orig-cte.cod-emitente  = wh-re0708L-buffer:BUFFER-FIELD(3):BUFFER-VALUE
               AND docto-orig-cte.idi-orig-trad = 2 NO-ERROR.

        IF AVAIL docto-orig-cte THEN DO:
            ASSIGN l-cte-saida = NO
                   l-cte-dev   = NO
                   l-cte-log   = NO
                   l-cte-comp  = NO
                   l-cte-compra= NO.

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
                /* J† rodou o especifico n∆o rodar no padr∆o (46- marca) */
                wh-re0708L-buffer:BUFFER-FIELD(46):BUFFER-VALUE = NO.                     
           END.
           ELSE DO:
                ASSIGN c-tipo-entrada = "".
                IF l-cte-saida  THEN ASSIGN c-tipo-entrada = "l-cte-saida".
                IF l-cte-dev    THEN ASSIGN c-tipo-entrada = "l-cte-dev".
                IF l-cte-log    THEN ASSIGN c-tipo-entrada = "l-cte-log".
                IF l-cte-compra THEN ASSIGN c-tipo-entrada = "l-cte-compra".
                
                IF (l-cte-saida OR l-cte-dev OR l-cte-log OR l-cte-compra) THEN DO:
                    RUN pi-gera-docto-recebimento IN h-esreapi0708(INPUT ROWID(docto-orig-cte),
                                                                   INPUT c-tipo-entrada,
                                                                   OUTPUT l-processou).
                    
                    /* J† rodou o especifico n∆o rodar no padr∆o (46- marca) */
                    wh-re0708L-buffer:BUFFER-FIELD(46):BUFFER-VALUE = NO.                     
                END.            
                ELSE DO:
                    ASSIGN l-executar-padrao = YES.
                END.
           END.
        END.
        
        hQuery:GET-NEXT().
    END.
    
    hQuery:QUERY-CLOSE().

    wh-re0708L-browse-brTable2:REFRESH().

    IF VALID-HANDLE(h-esreapi0708) THEN DO:

        DELETE PROCEDURE h-esreapi0708.
        ASSIGN h-esreapi0708 = ?.
    END.

    IF l-executar-padrao THEN
        APPLY "CHOOSE" TO wh-re0708L-btReprocessa2.

    IF VALID-HANDLE(wh-re0708L-btAtualiza) THEN
        APPLY "CHOOSE" TO wh-re0708L-btAtualiza.                                        
END.

IF VALID-HANDLE(h-esreapi0708) THEN DO:

    DELETE PROCEDURE h-esreapi0708.
    ASSIGN h-esreapi0708 = ?.
END.

RETURN "OK".
