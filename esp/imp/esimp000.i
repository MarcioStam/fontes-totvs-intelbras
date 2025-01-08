/*DEFINE TEMP-TABLE tt-emb NO-UNDO
    FIELD embarque       LIKE embarque-imp.embarque
    FIELD conhecimento   LIKE embarque-imp.cod-conhecto-master
    FIELD situacao       AS INT
    FIELD cod-itiner     LIKE itinerario.cod-itiner
    FIELD dt-ult-prev    LIKE historico-embarque.dt-ult-prev
    FIELD dt-efetiva     LIKE historico-embarque.dt-efetiva
    FIELD dt-embarque    AS DATE FORMAT "99/99/9999"
    FIELD dt-ent-int     AS DATE FORMAT "99/99/9999"
    INDEX codigo IS PRIMARY situacao.*/
    
EMPTY TEMP-TABLE tt-emb.

blk_situacao:
DO:
    /*Cria com situa‡Æo inicial Prev*/
    CREATE tt-emb.
    ASSIGN tt-emb.cod-estabel  = embarque-imp.cod-estabel
           tt-emb.embarque     = embarque-imp.embarque
           tt-emb.conhecimento = embarque-imp.cod-conhecto-master
           tt-emb.situacao     = 1. /* Prev */

    /*Busca primeiro ponto de controle para pegar o itiner rio*/
    FIND FIRST historico-embarque OF embarque-imp NO-LOCK NO-ERROR.
    
    FIND FIRST itinerario NO-LOCK
         WHERE itinerario.cod-itiner = historico-embarque.cod-itiner NO-ERROR.

    IF AVAIL itinerario THEN DO:
        /*Grava ultimo Ponto de controle efetivado*/
        FOR LAST historico-embarque NO-LOCK
           WHERE historico-embarque.cod-estabel = embarque-imp.cod-estabel
             AND historico-embarque.embarque    = embarque-imp.embarque
             AND historico-embarque.dt-efetiva <> ?
           BREAK BY historico-embarque.dt-efetiva:
        
            FIND FIRST pto-contr NO-LOCK
                 WHERE pto-contr.cod-pto-contr = historico-embarque.cod-pto-contr NO-ERROR.

            IF NOT AVAIL pto-contr THEN
                LEAVE blk_situacao.
        
            ASSIGN tt-emb.dt-ult-pto-contr  = historico-embarque.dt-efetiva
                   tt-emb.des-ult-pto-contr = pto-contr.descricao.
        END.
        
        /*Grava data entrada Itelbras*/
        FIND FIRST historico-embarque OF embarque-imp NO-LOCK
             WHERE historico-embarque.cod-pto-contr = itinerario.pto-chegada NO-ERROR.
        
        IF AVAIL historico-embarque THEN
            ASSIGN tt-emb.dt-ent-int  = IF historico-embarque.dt-efetiva <> ? THEN historico-embarque.dt-efetiva ELSE historico-embarque.dt-ult-prev.
        
        /*Grava data de embarque*/
        FIND FIRST historico-embarque OF embarque-imp NO-LOCK
             WHERE historico-embarque.cod-pto-contr = itinerario.pto-embarque NO-ERROR.
        
        IF AVAIL historico-embarque THEN
            ASSIGN tt-emb.dt-embarque  = IF historico-embarque.dt-efetiva <> ? THEN historico-embarque.dt-efetiva ELSE historico-embarque.dt-ult-prev.
        
        
        ASSIGN tt-emb.cod-itiner = itinerario.cod-itiner.

        FIND FIRST ext-embarque-imp NO-LOCK
             WHERE ext-embarque-imp.cod-estabel = embarque-imp.cod-estabel
               AND ext-embarque-imp.embarque    = embarque-imp.embarque
             NO-ERROR.
        IF AVAIL ext-embarque-imp
        THEN DO:
           IF  ext-embarque-imp.log-libera-alteracao = YES
           AND ext-embarque-imp.log-envio-comex      = YES
           THEN DO:
              /*CREATE tt-emb.*/
              ASSIGN /*tt-emb.cod-estabel  = embarque-imp.cod-estabel
                     tt-emb.embarque     = embarque-imp.embarque*/
                     tt-emb.situacao     = 97. /* Manutencao */
              LEAVE blk_situacao.
           END.
        END.
        
        
        /*NF*/
        FIND FIRST historico-embarque OF embarque-imp NO-LOCK
             WHERE historico-embarque.cod-pto-contr = itinerario.pto-chegada
               AND historico-embarque.dt-efetiva <> ? NO-ERROR.
        
        IF AVAIL historico-embarque THEN DO:
            ASSIGN tt-emb.situacao    = 4 /*NF*/
                   tt-emb.cod-itiner  = historico-embarque.cod-itiner
                   tt-emb.dt-ult-prev = historico-embarque.dt-ult-prev
                   tt-emb.dt-efetiva  = historico-embarque.dt-efetiva.
            LEAVE blk_situacao.
        END.

        /*DI*/
        FIND FIRST historico-embarque OF embarque-imp NO-LOCK
             WHERE historico-embarque.cod-pto-contr = itinerario.pto-desembarque 
               AND historico-embarque.dt-efetiva <> ? NO-ERROR.
        
        IF AVAIL historico-embarque THEN DO:
            ASSIGN tt-emb.situacao    = 98 /*DI*/
                   tt-emb.cod-itiner  = historico-embarque.cod-itiner
                   tt-emb.dt-ult-prev = historico-embarque.dt-ult-prev
                   tt-emb.dt-efetiva  = historico-embarque.dt-efetiva.
            LEAVE blk_situacao.
        END.
        
        /*Desp*/
        FIND FIRST historico-embarque OF embarque-imp NO-LOCK
             WHERE historico-embarque.cod-pto-contr = itinerario.int-1 
               AND historico-embarque.dt-efetiva <> ? NO-ERROR.
        
        IF AVAIL historico-embarque THEN DO:
            ASSIGN tt-emb.situacao    = 3 /*Desp*/
                   tt-emb.cod-itiner  = historico-embarque.cod-itiner
                   tt-emb.dt-ult-prev = historico-embarque.dt-ult-prev
                   tt-emb.dt-efetiva  = historico-embarque.dt-efetiva.
            LEAVE blk_situacao.
        END.
        
        /*Embarq*/
        FIND FIRST historico-embarque OF embarque-imp NO-LOCK
             WHERE historico-embarque.cod-pto-contr = itinerario.pto-embarque 
               AND historico-embarque.dt-efetiva <> ? NO-ERROR.
        
        IF AVAIL historico-embarque THEN DO:
            ASSIGN tt-emb.situacao    = 2 /*Embarq*/
                   tt-emb.cod-itiner  = historico-embarque.cod-itiner
                   tt-emb.dt-ult-prev = historico-embarque.dt-ult-prev
                   tt-emb.dt-efetiva  = historico-embarque.dt-efetiva.
            LEAVE blk_situacao.
        END.
        
        /*Agt*/
        FIND FIRST historico-embarque OF embarque-imp NO-LOCK
             WHERE historico-embarque.cod-pto-contr = embarque-imp.cdn-pto-despch 
               AND historico-embarque.dt-efetiva <> ? NO-ERROR.
        
        IF AVAIL historico-embarque THEN DO:
            ASSIGN tt-emb.situacao    = 99 /*Agt*/
                   tt-emb.cod-itiner  = historico-embarque.cod-itiner
                   tt-emb.dt-ult-prev = historico-embarque.dt-ult-prev
                   tt-emb.dt-efetiva  = historico-embarque.dt-efetiva.
            LEAVE blk_situacao.
        END.

        IF AVAIL ext-embarque-imp 
        THEN DO:
           /*Inst*/
           FIND FIRST historico-embarque NO-LOCK
                   OF embarque-imp 
                WHERE historico-embarque.cod-pto-contr = ext-embarque-imp.cdn-pto-instrucao  
                  AND historico-embarque.dt-efetiva <> ? 
                NO-ERROR.

           IF AVAIL historico-embarque 
           THEN DO:
               ASSIGN tt-emb.situacao    = 96 /*Inst*/
                      tt-emb.cod-itiner  = historico-embarque.cod-itiner
                      tt-emb.dt-ult-prev = historico-embarque.dt-ult-prev
                      tt-emb.dt-efetiva  = historico-embarque.dt-efetiva.
               LEAVE blk_situacao.
           END.
        END.
    END. /*AVAIL itinerario*/
    ELSE DO:
        DELETE tt-emb.
    END.
END. /*blk_situacao DO:*/


