{esp/es0018.i}
DEFINE STREAM str-excel.

DEFINE VARIABLE c-arquivo-csv AS CHARACTER   NO-UNDO.
DEFINE VARIABLE h-acomp       AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-arq-excel   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-dt-efetiva  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-diff        AS CHARACTER   NO-UNDO.

DEFINE BUFFER b-historico-embarque FOR historico-embarque.

define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)"
    field usuario          as char format "x(12)"
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field desc-classifica  as char format "x(40)"
    field modelo-rtf       as char format "x(35)"
    field l-habilitaRtf    as LOG
    FIELD fi-ini-cod-unid-negoc LIKE item-uni-estab.cod-unid-negoc
    FIELD fi-fim-cod-unid-negoc LIKE item-uni-estab.cod-unid-negoc
    FIELD cod-estabel-ini    AS CHARACTER
    FIELD cod-estabel-fim    AS CHARACTER
    FIELD embarque-ini       AS CHARACTER
    FIELD embarque-fim       AS CHARACTER
    FIELD cod-emitente-ini   AS INTEGER
    FIELD cod-emitente-fim   AS INTEGER
    FIELD data-ini           AS DATE
    FIELD data-fim           AS DATE
    FIELD it-codigo-fim      AS CHARACTER
    FIELD it-codigo-ini      AS CHARACTER
    FIELD cod-comprado-ini   AS CHARACTER 
    FIELD cod-comprado-fim   AS CHARACTER
    FIELD resumido-analitico AS INT.

DEFINE VARIABLE c-dir-saida AS CHARACTER   NO-UNDO.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.

DEFINE input parameter raw-param as raw no-undo.
DEFINE input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

{utp/ut-glob.i}

DO ON STOP UNDO, LEAVE:

    ASSIGN c-arquivo-csv = "ESIMP017_" + STRING(TIME) + ".csv":U.

    IF  OPSYS = "unix" THEN DO:
        EMPTY TEMP-TABLE tt-prog-ponto.
    
        RUN esp/es0018p.p (INPUT "SPOOL-UNIX":U,
                           INPUT 1,
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-ponto).
    
        FOR FIRST tt-prog-ponto:
            ASSIGN c-dir-saida = REPLACE(tt-prog-ponto.conteudo, "~\":U, "/":U).
        END. 

        ASSIGN c-dir-saida =  c-dir-saida + "/":U + c-seg-usuario + "/":U.
        OS-CREATE-DIR VALUE(c-dir-saida).
        ASSIGN c-arq-excel = c-dir-saida + TRIM(c-arquivo-csv).
    END. 
    ELSE DO:
        EMPTY TEMP-TABLE tt-prog-ponto.
    
        RUN esp/es0018p.p (INPUT "SPOOL-WIN":U,
                           INPUT 1,
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-ponto).
    
        FOR FIRST tt-prog-ponto:
            ASSIGN c-dir-saida = REPLACE(tt-prog-ponto.conteudo, "/":U, "~\":U).
        END. 

        ASSIGN c-dir-saida =  c-dir-saida + "/":U + c-seg-usuario + "/":U.
        OS-CREATE-DIR VALUE(c-dir-saida).
        ASSIGN c-arq-excel = c-dir-saida + TRIM(c-arquivo-csv).
    END.
END.


DO ON STOP UNDO, LEAVE:
    
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
    RUN pi-inicializar in h-acomp (input "Buscando ...").

    OUTPUT STREAM str-excel TO value(c-arq-excel) NO-CONVERT.

    /*resumido*/
    IF tt-param.resumido-analitico = 1 THEN
        PUT STREAM str-excel UNFORMATTED "Est;Embarque;Conhecimento;Comprador;Fornecedor;Nom. Abrev. Fornecedor;Itinerario;Des. Itinerario;Ponto de Controle;Des. Ponto de Controle;PrevisÆo Original;éltima previsÆo;Efetiva;Dif. Ori. X prev.;Dif. Ori. X efetiva;Ponto de Controle Atual;Des. Ponto de Controle Atual;" SKIP.
    ELSE                                 
        PUT STREAM str-excel UNFORMATTED "Est;Item;Descricao;Embarque;Conhecimento;Comprador;Fornecedor;Nom. Abrev. Fornecedor;Itinerario;Des. Itinerario;Ponto de Controle;Des. Ponto de Controle;PrevisÆo Original;éltima previsÆo;Efetiva;Dif. Ori. X prev.;Dif. Ori. X efetiva;Ponto de Controle Atual;Des. Ponto de Controle Atual;" SKIP.

    IF tt-param.resumido-analitico = 2 THEN DO:
        FOR EACH historico-embarque NO-LOCK
           WHERE historico-embarque.cod-estabel >= tt-param.cod-estabel-ini
             AND historico-embarque.cod-estabel <= tt-param.cod-estabel-fim
             AND historico-embarque.embarque    >= tt-param.embarque-ini
             AND historico-embarque.embarque    <= tt-param.embarque-fim,
            EACH ordens-embarque NO-LOCK
           WHERE ordens-embarque.cod-estabel = historico-embarque.cod-estabel
             AND ordens-embarque.embarque    = historico-embarque.embarque,
           FIRST ordem-compra OF ordens-embarque NO-LOCK
           WHERE ordem-compra.it-codigo      >= tt-param.it-codigo-ini
             AND ordem-compra.it-codigo      <= tt-param.it-codigo-fim
             AND ordem-compra.cod-unid-negoc >= tt-param.fi-ini-cod-unid-negoc
             AND ordem-compra.cod-unid-negoc <= tt-param.fi-fim-cod-unid-negoc
             AND ordem-compra.cod-emitente   >= tt-param.cod-emitente-ini
             AND ordem-compra.cod-emitente   <= tt-param.cod-emitente-fim
             AND ordem-compra.cod-comprado   >= tt-param.cod-comprado-ini
             AND ordem-compra.cod-comprado   <= tt-param.cod-comprado-fim,
           FIRST prazo-compra OF ordens-embarque NO-LOCK
           WHERE prazo-compra.data-entrega >= tt-param.data-ini
             AND prazo-compra.data-entrega <= tt-param.data-fim
            BREAK BY ordens-embarque.cod-estabel
                  BY ordens-embarque.embarque:
    
            run pi-acompanhar in h-acomp (input "Embarque: " + string(historico-embarque.embarque)).
    
            FIND FIRST embarque-imp NO-LOCK
                 WHERE embarque-imp.cod-estabel = historico-embarque.cod-estabel
                   AND embarque-imp.embarque    = historico-embarque.embarque NO-ERROR.
    
            PUT STREAM str-excel historico-embarque.cod-estabel + ";".
            
            /*analitico*/
            FIND FIRST ITEM NO-LOCK
                 WHERE ITEM.it-codigo = ordem-compra.it-codigo NO-ERROR.

            PUT STREAM str-excel UNFORMATTED ordem-compra.it-codigo + ";" +
                                 ITEM.desc-item + ";".
    
            ASSIGN c-dt-efetiva = IF historico-embarque.dt-efetiva = ? THEN ""
                                  ELSE string(historico-embarque.dt-efetiva).
    
            IF  historico-embarque.dt-efetiva = ? THEN
                ASSIGN c-diff = "".
            ELSE 
                ASSIGN c-diff = string(historico-embarque.dt-efetiva - historico-embarque.dt-previsao).
    
            FIND FIRST pto-contr NO-LOCK
                 WHERE pto-contr.cod-pto-contr = historico-embarque.cod-pto-contr NO-ERROR.
    
            FIND FIRST itinerario NO-LOCK
                 WHERE itinerario.cod-itiner = historico-embarque.cod-itiner NO-ERROR.

            FIND FIRST emitente NO-LOCK
                 WHERE emitente.cod-emitente = ordem-compra.cod-emitente NO-ERROR.
    
            PUT  STREAM str-excel UNFORMATTED historico-embarque.embarque     + ";" +
                                   embarque-imp.cod-conhecto-master           + ";" +
                                   ordem-compra.cod-comprado                  + ";" +
                                   string(ordem-compra.cod-emitente)          + ";" +
                                   emitente.nome-abrev                        + ";" +
                                   string(itinerario.cod-itiner)              + ";" +
                                   itinerario.descricao                       + ";" +  
                                   string(pto-contr.cod-pto-contr)            + ";" + 
                                   pto-contr.descricao                        + ";" + 
                                   string(historico-embarque.dt-previsao)     + ";" +
                                   string(historico-embarque.dt-ult-previsao) + ";" +
                                   c-dt-efetiva                               + ";" +
                                   STRING(historico-embarque.dt-ult-previsao - historico-embarque.dt-previsao) + ";" +
                                   c-diff + ";".
    
            FIND LAST b-historico-embarque NO-LOCK
                WHERE b-historico-embarque.cod-estabel = embarque-imp.cod-estabel
                  AND b-historico-embarque.embarque    = embarque-imp.embarque
                  AND b-historico-embarque.dt-efetiva <> ? NO-ERROR.
    
           FIND FIRST pto-contr NO-LOCK
                WHERE pto-contr.cod-pto-contr = b-historico-embarque.cod-pto-contr NO-ERROR.
                             
           IF AVAIL pto-contr THEN
               PUT STREAM str-excel UNFORMATTED string(pto-contr.cod-pto-contr) + ";" +
                                                pto-contr.descricao.
           ELSE 
               PUT STREAM str-excel UNFORMATTED  ";".
    
           PUT STREAM str-excel SKIP.
    
        END.
    END.
    ELSE DO:
        FOR EACH historico-embarque NO-LOCK
           WHERE historico-embarque.cod-estabel >= tt-param.cod-estabel-ini
             AND historico-embarque.cod-estabel <= tt-param.cod-estabel-fim
             AND historico-embarque.embarque    >= tt-param.embarque-ini
             AND historico-embarque.embarque    <= tt-param.embarque-fim,
            FIRST ordens-embarque NO-LOCK
           WHERE ordens-embarque.cod-estabel = historico-embarque.cod-estabel
             AND ordens-embarque.embarque    = historico-embarque.embarque,
           FIRST ordem-compra OF ordens-embarque NO-LOCK
           WHERE ordem-compra.it-codigo      >= tt-param.it-codigo-ini
             AND ordem-compra.it-codigo      <= tt-param.it-codigo-fim
             AND ordem-compra.cod-unid-negoc >= tt-param.fi-ini-cod-unid-negoc
             AND ordem-compra.cod-unid-negoc <= tt-param.fi-fim-cod-unid-negoc
             AND ordem-compra.cod-emitente   >= tt-param.cod-emitente-ini
             AND ordem-compra.cod-emitente   <= tt-param.cod-emitente-fim
             AND ordem-compra.cod-comprado   >= tt-param.cod-comprado-ini
             AND ordem-compra.cod-comprado   <= tt-param.cod-comprado-fim,
           FIRST prazo-compra OF ordens-embarque NO-LOCK
           WHERE prazo-compra.data-entrega >= tt-param.data-ini
             AND prazo-compra.data-entrega <= tt-param.data-fim
            BREAK BY ordens-embarque.cod-estabel
                  BY ordens-embarque.embarque:
    
            run pi-acompanhar in h-acomp (input "Embarque: " + string(historico-embarque.embarque)).
    
            FIND FIRST embarque-imp NO-LOCK
                 WHERE embarque-imp.cod-estabel = historico-embarque.cod-estabel
                   AND embarque-imp.embarque    = historico-embarque.embarque NO-ERROR.
    
            PUT STREAM str-excel historico-embarque.cod-estabel + ";".
    
            ASSIGN c-dt-efetiva = IF historico-embarque.dt-efetiva = ? THEN ""
                                  ELSE string(historico-embarque.dt-efetiva).
    
            IF  historico-embarque.dt-efetiva = ? THEN
                ASSIGN c-diff = "".
            ELSE 
                ASSIGN c-diff = string(historico-embarque.dt-efetiva - historico-embarque.dt-previsao).
    
            FIND FIRST pto-contr NO-LOCK
                 WHERE pto-contr.cod-pto-contr = historico-embarque.cod-pto-contr NO-ERROR.
    
            FIND FIRST itinerario NO-LOCK
                 WHERE itinerario.cod-itiner = historico-embarque.cod-itiner NO-ERROR.

            FIND FIRST emitente NO-LOCK
                 WHERE emitente.cod-emitente = ordem-compra.cod-emitente NO-ERROR.
    
            PUT  STREAM str-excel UNFORMATTED historico-embarque.embarque     + ";" +
                                   embarque-imp.cod-conhecto-master           + ";" +
                                   ordem-compra.cod-comprado                  + ";" +
                                   string(ordem-compra.cod-emitente)          + ";" +
                                   emitente.nome-abrev                        + ";" +
                                   string(itinerario.cod-itiner)              + ";" +
                                   itinerario.descricao                       + ";" +  
                                   string(pto-contr.cod-pto-contr)            + ";" + 
                                   pto-contr.descricao                        + ";" + 
                                   string(historico-embarque.dt-previsao)     + ";" +
                                   string(historico-embarque.dt-ult-previsao) + ";" +
                                   c-dt-efetiva                               + ";" +
                                   STRING(historico-embarque.dt-ult-previsao - historico-embarque.dt-previsao) + ";" +
                                   c-diff + ";".

            FIND LAST b-historico-embarque NO-LOCK
                WHERE b-historico-embarque.cod-estabel = embarque-imp.cod-estabel
                  AND b-historico-embarque.embarque    = embarque-imp.embarque
                  AND b-historico-embarque.dt-efetiva <> ? NO-ERROR.
    
           FIND FIRST pto-contr NO-LOCK
                WHERE pto-contr.cod-pto-contr = b-historico-embarque.cod-pto-contr NO-ERROR.
                 
           IF AVAIL pto-contr THEN
                PUT STREAM str-excel UNFORMATTED string(pto-contr.cod-pto-contr) + ";" +
                                                 pto-contr.descricao.
    
           PUT STREAM str-excel SKIP.
    
        END.
    END.

    RUN pi-finalizar IN h-acomp.

    OUTPUT STREAM str-excel CLOSE.

    IF NOT OPSYS = "unix" THEN DO:
        DOS SILENT START excel VALUE(c-arq-excel).
    END.

    RETURN "OK".   
END.
