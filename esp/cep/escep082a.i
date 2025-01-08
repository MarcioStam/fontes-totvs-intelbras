PROCEDURE pi-proxima-chegada:
    DEFINE INPUT  PARAM p-it-codigo            LIKE ITEM.it-codigo.
    DEFINE INPUT  PARAM p-res-for-comp         LIKE item-uni-estab.res-for-comp.
    DEFINE INPUT  PARAM p-tp-desp-padrao       LIKE item-uni-estab.tp-desp-padrao.
    DEFINE INPUT  PARAM p-cod-estabel          LIKE estabelec.cod-estabel.
    DEFINE INPUT  PARAM p-cod-plano            LIKE int-criticidade-item.cd-plano.
    DEFINE OUTPUT PARAM p-prazo-compra         AS ROWID.
    DEFINE OUTPUT PARAM p-historico-embarque   AS ROWID.
    DEFINE OUTPUT PARAM p-tem-entrega-prevista AS LOG INITIAL NO.
    
    /*Item importado*/
    IF p-tp-desp-padrao = 2 THEN DO:

        FOR EACH prazo-compra NO-LOCK
           WHERE prazo-compra.it-codigo     = p-it-codigo
             AND prazo-compra.situacao      = 2
             AND prazo-compra.data-entrega >= TODAY 
             AND prazo-compra.data-entrega <= TODAY + p-res-for-comp /*leadtime*/,
           FIRST ordem-compra OF prazo-compra
           WHERE ordem-compra.cod-estabel = p-cod-estabel
              BY prazo-compra.data-entrega:

            FIND FIRST deposito NO-LOCK
                 WHERE deposito.cod-depos = ordem-compra.dep-almoxar NO-ERROR.

            /*OEM*/
            IF p-cod-plano = 4 THEN DO:

                IF  ordem-compra.dep-almoxar <> "ACA" 
                AND ordem-compra.dep-almoxar <> "EXP" 
                AND ordem-compra.dep-almoxar <> "WEX"
                AND NOT deposito.cons-saldo  THEN
                    NEXT.

            END.
            ELSE IF  AVAILABLE deposito 
                 AND NOT deposito.cons-saldo THEN
                NEXT.
    
            FIND FIRST ordens-embarque NO-LOCK
                 WHERE ordens-embarque.numero-ordem = prazo-compra.numero-ordem 
                   AND ordens-embarque.parcela      = prazo-compra.parcela NO-ERROR.

            IF AVAIL ordens-embarque THEN
                FIND FIRST historico-embarque NO-LOCK  
                     WHERE historico-embarque.cod-estabel = ordens-embarque.cod-estabel
                       AND historico-embarque.embarque    = ordens-embarque.embarque NO-ERROR.
    
            IF AVAIL historico-embarque THEN
                FIND FIRST itinerario NO-LOCK
                     WHERE itinerario.cod-itiner = historico-embarque.cod-itiner NO-ERROR.
    
            RELEASE historico-embarque.
            /*Buscar Ponto Embarque*/
            IF AVAIL itinerario THEN DO:
                FIND FIRST historico-embarque NO-LOCK
                     WHERE historico-embarque.cod-estabel   = ordens-embarque.cod-estabel
                       AND historico-embarque.embarque      = ordens-embarque.embarque
                       AND historico-embarque.cod-pto-contr = itinerario.pto-embarque NO-ERROR.
            END.
    
            IF AVAIL historico-embarque THEN DO:
                /*J  foi Embarcado*/
                IF historico-embarque.dt-efetiva <> ? THEN DO:
                    /*Salva somente as informa‡äes da primeira ordem j  embarcada*/
                    IF p-prazo-compra = ? THEN DO:
                        ASSIGN p-prazo-compra       = ROWID(prazo-compra)
                               p-historico-embarque = ROWID(historico-embarque).
                    END.
                END.
                /*Ainda possui entregas nÆo embarcadas*/
                ELSE DO:
                    ASSIGN p-tem-entrega-prevista = YES.
                END.
            END.
        END. 
    END.
    /*Item nacional*/
    ELSE DO:
        FOR EACH prazo-compra NO-LOCK
           WHERE prazo-compra.it-codigo     = p-it-codigo
             AND prazo-compra.situacao      = 2
             AND prazo-compra.data-entrega >= TODAY 
             AND prazo-compra.data-entrega <= TODAY + p-res-for-comp /*leadtime*/
              BY prazo-compra.data-entrega:

            /*Desconsidera depositos nÆo dispon¡veis*/
            FIND FIRST ordem-compra NO-LOCK
                 WHERE ordem-compra.numero-ordem = prazo-compra.numero-ordem NO-ERROR.

            IF ordem-compra.cod-estabel <> p-cod-estabel THEN
                NEXT.

            FIND FIRST deposito NO-LOCK
                 WHERE deposito.cod-depos = ordem-compra.dep-almoxar NO-ERROR.

            /*OEM*/
            IF p-cod-plano = 4 THEN DO:

                IF  ordem-compra.dep-almoxar <> "ACA" 
                AND ordem-compra.dep-almoxar <> "EXP" 
                AND ordem-compra.dep-almoxar <> "WEX"
                AND NOT deposito.cons-saldo  THEN
                    NEXT.

            END.
            ELSE IF  AVAILABLE deposito 
                 AND NOT deposito.cons-saldo THEN
                NEXT.

            ASSIGN p-tem-entrega-prevista = YES
                   p-prazo-compra         = ROWID(prazo-compra).

            /*Encontrou pr¢ximo, sai*/
            LEAVE.
        END.
    END.
END.
