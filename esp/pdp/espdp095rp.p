{esp/es0018.i}
DEFINE STREAM str-excel.

DEFINE VARIABLE c-arquivo-csv AS CHARACTER   NO-UNDO.
DEFINE VARIABLE h-acomp       AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-arq-excel   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-nr-ord-prod AS INTEGER     NO-UNDO.
DEFINE VARIABLE c-po-cliente  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE d-valor-ipi-tot   AS DECIMAL     NO-UNDO.
DEFINE VARIABLE d-valor-ipi-sdo   AS DECIMAL     NO-UNDO.
DEFINE VARIABLE d-valor-sdo-item  AS DECIMAL     NO-UNDO.
DEFINE VARIABLE d-valor-tot-item  AS DECIMAL     NO-UNDO.
DEFINE VARIABLE c-it-fabric   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE data-term     AS DATE        NO-UNDO.
DEFINE VARIABLE d-saldo-op    AS DECIMAL     NO-UNDO.
DEFINE VARIABLE d-qtd-ordem   AS DECIMAL     NO-UNDO.
DEFINE VARIABLE i-nivel       AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-seq-saida   AS INTEGER     NO-UNDO.
DEFINE VARIABLE c-cod-estabel AS CHAR        NO-UNDO.
DEFINE VARIABLE c-cod-depos   AS CHAR        NO-UNDO.
DEFINE VARIABLE c-qtidade-atu AS DEC         NO-UNDO.
DEFINE VARIABLE c-saldo-disponivel AS DEC  NO-UNDO.
DEFINE VARIABLE c-saldo            AS CHAR NO-UNDO.
DEFINE VARIABLE c-saldo-trans      AS DEC NO-UNDO.
DEFINE VARIABLE d-qt-alocada       AS DEC NO-UNDO.
DEFINE VARIABLE d-cdd-embarq       AS DEC NO-UNDO.
DEFINE VARIABLE c-preco-unit       AS DEC NO-UNDO.
DEFINE VARIABLE c-preco-tot        AS DEC NO-UNDO. 
DEFINE VARIABLE c-saldo-item       AS DEC NO-UNDO.
DEFINE VARIABLE c-data             AS CHAR NO-UNDO.

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
    FIELD cod-estabel-ini  LIKE ped-venda.cod-estabel
    FIELD cod-estabel-fim  LIKE ped-venda.cod-estabel
    FIELD nr-pedido-ini    LIKE ped-venda.nr-pedido
    FIELD nr-pedido-fim    LIKE ped-venda.nr-pedido
    FIELD it-codigo-ini    LIKE ped-item.it-codigo
    FIELD it-codigo-fim    LIKE ped-item.it-codigo
    FIELD dt-entrega-ini   LIKE ped-venda.dt-entrega
    FIELD dt-entrega-fim   LIKE ped-venda.dt-entrega
    FIELD dt-emissao-ini   LIKE ped-venda.dt-emissao
    FIELD dt-emissao-fim   LIKE ped-venda.dt-emissao
    FIELD dt-implant-ini   LIKE ped-venda.dt-implant
    FIELD dt-implant-fim   LIKE ped-venda.dt-implant
    FIELD po-cliente-ini   AS CHAR
    FIELD po-cliente-fim   AS CHAR
    FIELD nat-operacao-ini LIKE ped-venda.nat-operacao
    FIELD nat-operacao-fim LIKE ped-venda.nat-operacao
    FIELD ped-aberto            AS LOG
    FIELD ped-atendido-parcial  AS LOG
    FIELD ped-atendido-total    AS LOG
    FIELD ped-pendente          AS LOG
    FIELD ped-suspenso          AS LOG
    FIELD ped-cancelado         AS LOG
    FIELD item-aberto           AS LOG
    FIELD item-atendido-parcial AS LOG
    FIELD item-atendido-total   AS LOG
    FIELD item-pendente         AS LOG
    FIELD item-suspenso         AS LOG
    FIELD item-cancelado        AS LOG
    FIELD nao-avaliado          AS LOG
    FIELD avaliado              AS LOG
    FIELD aprovados             AS LOG
    FIELD nao-aprovados         AS LOG
    FIELD tg-rack               AS LOG
    FIELD tg-estrutura          AS LOG.

DEFINE TEMP-TABLE tt-saida NO-UNDO
    FIELD it-pai         LIKE estrutura.it-codigo
    FIELD it-pai-desc    LIKE ITEM.desc-item 
    FIELD it-filho       LIKE estrutura.es-codigo
    FIELD it-filho-desc  LIKE item.desc-item
    FIELD nivel          AS INTEGER FORMAT "99"
    FIELD tipo           AS CHAR FORMAT "x(10)"
    FIELD quantidade     LIKE estrutura.quant-usada
    FIELD seq            AS INT
    FIELD fantasma       AS CHAR
    FIELD un             LIKE ITEM.un.

DEFINE TEMP-TABLE tt-saldo NO-UNDO
    FIELD cod-estabel            LIKE saldo-estoq.cod-estabel
    FIELD it-codigo              LIKE saldo-estoq.it-codigo
    FIELD cod-depos              LIKE saldo-estoq.cod-depos
    FIELD qtidade-atu            LIKE saldo-estoq.qtidade-atu
    FIELD saldo-disponivel      AS DEC.

DEFINE BUFFER b-item        FOR ITEM.
DEFINE BUFFER b-item-fabric FOR item-fabric.
DEFINE BUFFER b-ord-prod    FOR ord-prod.
DEFINE BUFFER b-estrutura   FOR estrutura.

DEFINE VARIABLE c-dir-saida AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-pedido    AS CHAR        NO-UNDO.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.

DEFINE input parameter raw-param as raw no-undo.
DEFINE input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

{utp/ut-glob.i}

DO ON STOP UNDO, LEAVE:

    //ASSIGN c-arquivo-csv = "ESCCP046_" + STRING(TIME) + ".csv":U.
    ASSIGN c-arquivo-csv = "ESPDP095_" + STRING(TIME) + ".csv":U.

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

    PUT  STREAM str-excel UNFORMATTED  "Seq.;Item;Part-Number;Descri‡Æo;Dt Ent Orig;Data Entrega;Cliente;Pedido;Ordem Produ‡Æo;PO Cliente;PO Line Cliente;Quantidade;Saldo;Valor Saldo;Estab;Dt Implant;PRO 601;DEV 601;DEC 601;RET 601;DEV 602;DEC 602;PRO 602;WEX 602;REC 602;RET 602;PIN 602;Quant. Alocada;Pre‡o unit;Pre‡o total unit;Embarque" SKIP.
    
    FOR EACH ped-venda NO-LOCK
       WHERE ped-venda.cod-estabel >= tt-param.cod-estabel-ini
         AND ped-venda.cod-estabel <= tt-param.cod-estabel-fim
         AND ped-venda.nr-pedido   >= tt-param.nr-pedido-ini    
         AND ped-venda.nr-pedido   <= tt-param.nr-pedido-fim    
         AND ped-venda.dt-emissao  >= tt-param.dt-emissao-ini
         AND ped-venda.dt-emissao  <= tt-param.dt-emissao-fim
         /*AND ped-venda.dt-implant >= tt-param.dt-implant-ini
         AND ped-venda.dt-implant <= tt-param.dt-implant-fim*/,
        EACH ped-item OF ped-venda
       WHERE ped-item.it-codigo  >= tt-param.it-codigo-ini  
         AND ped-item.it-codigo  <= tt-param.it-codigo-fim  
         AND ped-item.dt-entrega >= tt-param.dt-entrega-ini  
         AND ped-item.dt-entrega <= tt-param.dt-entrega-fim
         AND ped-item.dt-userimp >= tt-param.dt-implant-ini
         AND ped-item.dt-userimp <= tt-param.dt-implant-fim
        BREAK BY ped-item.dt-entrega:

        IF  NOT tt-param.ped-aberto
        AND ped-venda.cod-sit-ped = 1 THEN
            NEXT.

        IF  NOT tt-param.ped-atendido-parcial
        AND ped-venda.cod-sit-ped = 2 THEN
            NEXT.

        IF  NOT tt-param.ped-atendido-total
        AND ped-venda.cod-sit-ped = 3 THEN
            NEXT.

        IF  NOT tt-param.ped-pendente
        AND ped-venda.cod-sit-ped = 4 THEN
            NEXT.

        IF  NOT tt-param.ped-suspenso
        AND ped-venda.cod-sit-ped = 5 THEN
            NEXT.

        IF  NOT tt-param.ped-cancelado
        AND ped-venda.cod-sit-ped = 6 THEN
            NEXT.


        IF  NOT tt-param.item-aberto
        AND ped-item.cod-sit-item = 1 THEN
            NEXT.

        IF  NOT tt-param.item-atendido-parcial
        AND ped-item.cod-sit-item = 2 THEN
            NEXT.

        IF  NOT tt-param.item-atendido-total
        AND ped-item.cod-sit-item = 3 THEN
            NEXT.

        IF  NOT tt-param.item-pendente
        AND ped-item.cod-sit-item = 4 THEN
            NEXT.

        IF  NOT tt-param.item-suspenso
        AND ped-item.cod-sit-item = 5 THEN
            NEXT.

        IF  NOT tt-param.item-cancelado
        AND ped-item.cod-sit-item = 6 THEN
            NEXT.


        IF  NOT tt-param.nao-avaliado 
        AND ped-venda.cod-sit-aval = 1 THEN
            NEXT. 

        IF  NOT tt-param.avaliado 
        AND ped-venda.cod-sit-aval = 2 THEN
            NEXT. 

        IF  NOT tt-param.aprovados 
        AND ped-venda.cod-sit-aval = 3 THEN
            NEXT. 

        IF  NOT tt-param.nao-aprovados 
        AND ped-venda.cod-sit-aval = 4 THEN
            NEXT. 

        RUN pi-acompanhar in h-acomp (input "Imprimindo pedido:" + STRING(ped-venda.nr-pedido)).


        FIND FIRST ITEM NO-LOCK
             WHERE ITEM.it-codigo = ped-item.it-codigo NO-ERROR.

        IF tt-param.tg-rack THEN DO: // Desconsidera familia
            RUN esp/es0018p.p (INPUT "espdp095":U,
                               INPUT 1,
                               INPUT 0,
                               INPUT "":U,
                               OUTPUT TABLE tt-prog-ponto).

            IF CAN-FIND(FIRST tt-prog-ponto
                        WHERE tt-prog-ponto.conteudo = ITEM.fm-cod-com) THEN
                NEXT.
        END.

        FIND FIRST emitente NO-LOCK
             WHERE emitente.cod-emitente = ped-venda.cod-emitente NO-ERROR.

        FIND FIRST int-ped-venda NO-LOCK
             WHERE int-ped-venda.cod-estabel = ped-venda.cod-estabel
               AND int-ped-venda.nr-pedido   = ped-venda.nr-pedido NO-ERROR.
        
        FIND FIRST item-fabric NO-LOCK
             WHERE item-fabric.it-codigo = ped-item.it-codigo NO-ERROR.

        FIND FIRST ord-prod NO-LOCK
             WHERE ord-prod.nome-abrev   = ped-venda.nome-abrev
               AND ord-prod.nr-pedido    = ped-venda.nr-pedcli
               AND ord-prod.it-codigo    = ped-item.it-codigo
               AND ord-prod.nr-sequencia = ped-item.nr-sequencia NO-ERROR.

        IF AVAIL ord-prod THEN
            ASSIGN i-nr-ord-prod = ord-prod.nr-ord-prod.
        ELSE 
            ASSIGN i-nr-ord-prod = 0.

        IF AVAIL int-ped-venda THEN
            ASSIGN c-po-cliente = TRIM(SUBSTRING(int-ped-venda.char-1,53,12)).
        ELSE 
            ASSIGN c-po-cliente = "".

        IF AVAIL item-fabric THEN
            ASSIGN c-it-fabric = item-fabric.it-fabric.
        ELSE 
            ASSIGN c-it-fabric = "".

        ASSIGN d-valor-ipi-tot  = (ped-item.qt-pedida * ped-item.vl-preuni) * ped-item.aliquota-ipi / 100
               d-valor-ipi-sdo  = ((ped-item.qt-pedida - ped-item.qt-atendida) * ped-item.vl-preuni) * ped-item.aliquota-ipi / 100
               d-valor-sdo-item = (ped-item.qt-pedida - ped-item.qt-atendida) * ped-item.vl-preuni
               d-valor-tot-item = ped-item.qt-pedida * ped-item.vl-preuni.

        ASSIGN  d-qt-alocada = 0
                c-preco-unit = 0
                c-preco-tot  = 0
                c-saldo-item = 0.


        /*Busca itens alocados no embarque */
        RUN pi-busca-embarque (OUTPUT d-qt-alocada,
                               OUTPUT d-cdd-embarq).


        ASSIGN c-saldo-item = ped-item.qt-pedida - ped-item.qt-atendida
               c-preco-unit = d-valor-sdo-item / c-saldo-item
               c-preco-tot  = (d-valor-sdo-item / ped-item.qt-pedida) * d-qt-alocada.

        IF c-preco-unit = ? THEN ASSIGN c-preco-unit = 0.

        //executa pi buscar saldo depositos
        EMPTY TEMP-TABLE tt-saldo.
        ASSIGN c-saldo = "".
        
        RUN pi-saldo-dep (INPUT ped-item.it-codigo).
        
        FOR EACH tt-saldo:
            IF c-saldo = "" THEN
                 ASSIGN c-saldo = String(tt-saldo.saldo-disponivel).
               ELSE
                 ASSIGN c-saldo = c-saldo + ";" +  STRING(tt-saldo.saldo-disponivel).
        END.
        

        /* Buscando Saldo de NFT */
        //ASSIGN c-saldo-trans = 0.
        
       /* RUN pi-busca-nft (INPUT ped-item.it-codigo,
                          OUTPUT c-saldo-trans,
                          OUTPUT c-pedido).    */
        
      //  IF c-pedido = "" THEN DO:
      //     c-pedido = STRING(ped-venda.nr-pedido).
      //  END. 

      
        PUT STREAM str-excel UNFORMATTED string(ped-item.nr-sequencia)                               + ";" + 
                                         ped-item.it-codigo                                          + ";" + 
                                         c-it-fabric                                                 + ";" + 
                                         ITEM.desc-item                                              + ";" + 
                                         STRING(ped-item.dt-entorig)                                 + ";" + 
                                         STRING(ped-item.dt-entrega)                                 + ";" + 
                                         emitente.nome-emit                                          + ";" + 
                                         string(ped-venda.nr-pedido)                                 + ";" + 
                                         STRING(i-nr-ord-prod)                                       + ";" + 
                                         c-po-cliente                                                + ";" +
                                         string(ped-item.parcela)                                    + ";" +  
                                         STRING(ped-item.qt-pedida)                                  + ";" + 
                                         STRING(c-saldo-item)                                        + ";" +
                                         string(d-valor-sdo-item /* - d-valor-ipi-sdo */ )           + ";" + 
                                         //string(d-valor-tot-item /* - d-valor-ipi-tot */ ) + ";" +
                                         ped-venda.cod-estabel                                       + ";" + 
                                         string(ped-item.dt-userimp)                                 + ";" +
                                         c-saldo                                                     + ";" +
                                         //STRING(c-saldo-trans)                                       + ";" + //Coluna NFT
                                         STRING(d-qt-alocada)                                        + ";" +
                                         STRING(c-preco-unit)                                        + ";" +
                                         STRING(c-preco-tot)                                         + ";" +
                                         STRING(d-cdd-embarq)                                        SKIP.
        
        
        IF  tt-param.tg-estrutura 
        AND i-nr-ord-prod <> 0
        THEN DO:

            FOR EACH reservas NO-LOCK
               WHERE reservas.nr-ord-prod = i-nr-ord-prod:

                FIND FIRST b-item WHERE
                           b-item.it-codigo = reservas.it-codigo
                           NO-LOCK NO-ERROR.

                IF AVAIL b-item AND
                   b-item.compr-fabric <> 2 //Apenas Fabricados 
                THEN NEXT.

                FIND FIRST b-item-fabric NO-LOCK
                     WHERE b-item-fabric.it-codigo = reservas.it-codigo NO-ERROR.

                IF AVAIL b-item-fabric THEN
                    ASSIGN c-it-fabric = b-item-fabric.it-fabric.
                ELSE 
                    ASSIGN c-it-fabric = "".

	            FIND FIRST b-ord-prod NO-LOCK
	                 WHERE b-ord-prod.nome-abrev   = ord-prod.nome-abrev
	                   AND b-ord-prod.nr-pedido    = ord-prod.nr-pedido
	                   AND b-ord-prod.nr-sequencia = ord-prod.nr-sequencia
	                   AND b-ord-prod.it-codigo    = reservas.it-codigo NO-ERROR.

                IF AVAIL b-ord-prod 
                THEN ASSIGN i-nr-ord-prod = b-ord-prod.nr-ord-produ
                            data-term     = b-ord-prod.dt-termino
                            d-qtd-ordem   = b-ord-prod.qt-ordem
                            d-saldo-op    = b-ord-prod.qt-ordem - b-ord-prod.qt-produzida.
                ELSE ASSIGN i-nr-ord-prod = 0
                            data-term     = ?
                            d-qtd-ordem   = 0
                            d-saldo-op    = 0.


                EMPTY TEMP-TABLE tt-saldo.
                ASSIGN c-saldo = ""
                       c-data = "".
                 
                RUN pi-saldo-dep (INPUT reservas.it-codigo).
                
                FOR EACH tt-saldo:                                                          
                    IF c-saldo = "" THEN                                                    
                        ASSIGN c-saldo = String(tt-saldo.saldo-disponivel).                 
                    ELSE                                                                    
                        ASSIGN c-saldo = c-saldo + ";" +  STRING(tt-saldo.saldo-disponivel).
                END.                                                                        
                
                /*Buscando Saldo de NFT */                     
               /* ASSIGN c-saldo-trans = 0.
                RUN pi-busca-nft (INPUT reservas.it-codigo,
                                  OUTPUT c-saldo-trans,
                                  OUTPUT c-pedido ).*/
                
              //  IF c-pedido = "" THEN DO:
              //     c-pedido = STRING(ped-venda.nr-pedido).
              //  END.
              //
                
                IF data-term <> ? THEN
                    ASSIGN c-data = string(data-term).
                ELSE
                    ASSIGN c-data = "?".

                PUT STREAM str-excel UNFORMATTED string(ped-item.nr-sequencia) + ";" +
                                                 reservas.it-codigo + ";" +
                                                 c-it-fabric        + ";" + 
                                                 b-item.desc-item   + ";" + 
                                                 ";" +
                                                 c-data + ";" +
                                                 emitente.nome-emit + ";" +
                                                 string(ped-venda.nr-pedido)  + ";" +
                                                 STRING(i-nr-ord-prod)       + ";" +
                                                 ";" +
                                                 ";" +
                                                 STRING(d-qtd-ordem)   + ";" +
                                                 STRING(d-saldo-op) + ";" +
                                                 ";" +
                                                 ";" +
                                                 ";" +
                                                 c-saldo            + ";" SKIP.
                                                 //STRING(c-saldo-trans) + ";" SKIP.

                 
                EMPTY TEMP-TABLE tt-saida.

                RUN pi-estrutura(INPUT reservas.it-codigo,
                                 INPUT ped-item.it-codigo).

                FOR EACH tt-saida:

                    FIND FIRST b-item WHERE
                               b-item.it-codigo = tt-saida.it-filho
                               NO-LOCK NO-ERROR.
                    
                    IF AVAIL b-item AND
                       b-item.compr-fabric <> 2 //Apenas Fabricados 
                    THEN NEXT.

                    FIND FIRST b-item-fabric NO-LOCK
                         WHERE b-item-fabric.it-codigo = tt-saida.it-filho NO-ERROR.
                    
                    IF AVAIL b-item-fabric THEN
                        ASSIGN c-it-fabric = b-item-fabric.it-fabric.
                    ELSE 
                        ASSIGN c-it-fabric = "".
                    
	                FIND FIRST b-ord-prod NO-LOCK
	                     WHERE b-ord-prod.nome-abrev   = ord-prod.nome-abrev
	                       AND b-ord-prod.nr-pedido    = ord-prod.nr-pedido
	                       AND b-ord-prod.nr-sequencia = ord-prod.nr-sequencia
	                       AND b-ord-prod.it-codigo    = tt-saida.it-filho NO-ERROR.
                    
                    IF AVAIL b-ord-prod 
                    THEN ASSIGN i-nr-ord-prod = b-ord-prod.nr-ord-produ
                                data-term     = b-ord-prod.dt-termino
                                d-qtd-ordem   = b-ord-prod.qt-ordem
                                d-saldo-op    = b-ord-prod.qt-ordem - b-ord-prod.qt-produzida.
                    ELSE ASSIGN i-nr-ord-prod = 0
                                data-term     = ?
                                d-qtd-ordem   = 0
                                d-saldo-op    = 0.
                        
                    
                    EMPTY TEMP-TABLE tt-saldo.
                    ASSIGN c-saldo = ""
                           c-data = "".
                    
                    RUN pi-saldo-dep (INPUT tt-saida.it-filho).
                    
                    FOR EACH tt-saldo:
                        IF c-saldo = "" THEN
                            ASSIGN c-saldo = String(tt-saldo.saldo-disponivel).
                        ELSE
                            ASSIGN c-saldo = c-saldo + ";" +  STRING(tt-saldo.saldo-disponivel).
                    END.
                    
                    /*Buscando Saldo de NFT */                 
                    /*ASSIGN c-saldo-trans = 0.
                    RUN pi-busca-nft (INPUT tt-saida.it-filho,
                                      OUTPUT c-saldo-trans,
                                      OUTPUT c-pedido).*/

                  //  IF c-pedido = "" THEN DO:
                  //     c-pedido = STRING(ped-venda.nr-pedido).
                  //  END.

                    IF data-term <> ? THEN
                        ASSIGN c-data = string(data-term).
                    ELSE
                        ASSIGN c-data = "?".
                        
                    PUT STREAM str-excel UNFORMATTED string(ped-item.nr-sequencia) + ";" +
                                                     tt-saida.it-filho + ";" +
                                                     c-it-fabric        + ";" + 
                                                     b-item.desc-item   + ";" +
                                                     ";" +
                                                     c-data + ";" + 
                                                     emitente.nome-emit + ";" +
                                                     string(ped-venda.nr-pedido)           + ";" +
                                                     STRING(i-nr-ord-prod)       + ";" +
                                                     ";" +
                                                     ";" +  
                                                     STRING(d-qtd-ordem)   + ";" +
                                                     STRING(d-saldo-op) + ";" +
                                                     ";" +
                                                     ";" +
                                                     ";" +
                                                     c-saldo + ";" SKIP.
                                                     //STRING(c-saldo-trans) + ";" 
                                                     
                 
            END.
        END.
      END.
    END.    

    RUN pi-finalizar IN h-acomp.

    OUTPUT STREAM str-excel CLOSE.

    IF NOT OPSYS = "unix" THEN DO:
        DOS SILENT START excel VALUE(c-arq-excel).
    END.

    RETURN "OK".   
END.

PROCEDURE pi-estrutura:
    DEFINE INPUT PARAMETER p-es-codigo LIKE estrutura.es-codigo NO-UNDO.
    DEFINE INPUT PARAMETER p-it-codigo LIKE estrutura.it-codigo NO-UNDO.

    FOR EACH estrutura NO-LOCK
        WHERE estrutura.it-codigo = p-es-codigo
          AND estrutura.data-inicio  <= TODAY
          AND estrutura.data-termino >  TODAY:

        FIND FIRST ITEM NO-LOCK
            WHERE ITEM.it-codigo = p-it-codigo NO-ERROR.

        FIND FIRST b-item NO-LOCK
            WHERE b-item.it-codigo = estrutura.es-codigo NO-ERROR.

        ASSIGN i-nivel = i-nivel + 1
               i-seq-saida = i-seq-saida + 1.

        CREATE tt-saida.
        ASSIGN tt-saida.seq           = i-seq-saida  
               tt-saida.it-pai        = p-es-codigo        
               tt-saida.it-pai-desc   = ITEM.desc-item    
               tt-saida.it-filho      = estrutura.es-codigo    
               tt-saida.it-filho-desc = b-item.desc-item     
               tt-saida.nivel         = i-nivel
               tt-saida.quantidade    = estrutura.quant-usada
               tt-saida.un            = b-item.un.
        
        IF estrutura.fantasma = YES THEN
            ASSIGN tt-saida.fantasma = "#".
        ELSE
            ASSIGN tt-saida.fantasma = "".
        
        IF CAN-FIND(FIRST b-estrutura NO-LOCK
            WHERE b-estrutura.it-codigo = estrutura.es-codigo)THEN
           
           ASSIGN tt-saida.tipo = "Fabricado".

        ELSE
           ASSIGN tt-saida.tipo = "Comprado".


        RUN pi-estrutura(INPUT estrutura.es-codigo,
                         INPUT p-it-codigo).

        ASSIGN i-nivel = i-nivel - 1.
    END.
END.  

PROCEDURE pi-saldo-dep:
    DEFINE INPUT PARAMETER p-it-codigo LIKE saldo-estoq.it-codigo NO-UNDO.
    DEF VAR c-dep601 AS CHAR NO-UNDO.
    DEF VAR c-dep602 AS CHAR NO-UNDO.
    DEF VAR i AS INT NO-UNDO.
    DEF VAR i-cont AS INT NO-UNDO.
    
    ASSIGN c-dep601 = "PRO,DEv,DEC,RET".
    ASSIGN c-dep602 = "DEV,DEC,PRO,WEX,REC,RET,PIN".
    
    DO i = 601 TO 602:
        IF i = 601 THEN DO:
            DO i-cont = 1 TO NUM-ENTRIES(c-dep601,","):
            
              CREATE tt-saldo.
              ASSIGN tt-saldo.cod-estabel  = STRING(i)
                 tt-saldo.it-codigo        = p-it-codigo
                 tt-saldo.cod-depos        = ENTRY(i-cont,c-dep601)
                 tt-saldo.qtidade-atu      = 0
                 tt-saldo.saldo-disponivel = 0.
            END.
        END.
        ELSE DO:
            IF i = 602 THEN DO:
                DO i-cont = 1 TO NUM-ENTRIES(c-dep602,","):
                
                  CREATE tt-saldo.
                  ASSIGN tt-saldo.cod-estabel  = STRING(i)
                     tt-saldo.it-codigo        = p-it-codigo
                     tt-saldo.cod-depos        = ENTRY(i-cont,c-dep602)
                     tt-saldo.qtidade-atu      = 0
                     tt-saldo.saldo-disponivel = 0.
                END.
            END.
        END.
    END.
        
   FOR EACH tt-saldo:
      FOR EACH saldo-estoq
          WHERE saldo-estoq.it-codigo = tt-saldo.it-codigo
           AND  saldo-estoq.cod-estabel = tt-saldo.cod-estabel
           AND  saldo-estoq.cod-depos   = tt-saldo.cod-depos  NO-LOCK:

          IF saldo-estoq.qtidade-atu > 0 THEN DO:
              RUN pi-acompanhar in h-acomp (input "Saldo deposito: " + STRING(saldo-estoq.cod-depos) + " " + STRING(tt-saldo.it-codigo)).

            ASSIGN  tt-saldo.qtidade-atu      = tt-saldo.qtidade-atu + saldo-estoq.qtidade-atu
                    tt-saldo.saldo-disponivel = tt-saldo.qtidade-atu - saldo-estoq.qt-aloc-prod - saldo-estoq.qt-alocada - saldo-estoq.qt-aloc-ped.

         END.
      END.
   END.
END PROCEDURE.

PROCEDURE pi-busca-nft: 
    DEFINE INPUT PARAMETER p-it-codigo    AS CHAR NO-UNDO.
    DEFINE OUTPUT PARAMETER p-saldo-trans AS DEC NO-UNDO.
    DEFINE OUTPUT PARAMETER p-pedido      AS CHAR NO-UNDO.
    DEFINE VARIABLE l-achou               AS LOG INIT NO NO-UNDO.

        FOR EACH it-nota-fisc
            WHERE it-nota-fisc.it-codigo = p-it-codigo
              AND it-nota-fisc.cod-estabel = "601"
              AND it-nota-fisc.nr-pedido = ped-venda.nr-pedido NO-LOCK,
        
            EACH nota-fiscal USE-INDEX ch-nota
            WHERE nota-fiscal.nr-nota-fis       = it-nota-fisc.nr-nota-fis
              AND nota-fiscal.cod-estabel       = it-nota-fisc.cod-estabel
              AND nota-fiscal.serie             = it-nota-fisc.serie NO-LOCK:

            RUN pi-acompanhar in h-acomp (input "Buscando NF: " + STRING(nota-fiscal.nr-nota-fis)).

            //IF it-nota-fisc.nr-pedido <> ped-venda.nr-pedido THEN NEXT.
            
            IF nota-fiscal.idi-sit-nf-eletro <> 3 THEN NEXT.

            IF nota-fiscal.esp-docto <> 23 THEN NEXT.  /*NFT*/ 
            
            FIND FIRST docum-est
                 WHERE docum-est.nro-docto = nota-fiscal.nr-nota-fis
                  AND docum-est.serie-docto = nota-fiscal.serie
                  AND docum-est.estab-de-or = nota-fiscal.cod-estabel
                 /* AND docum-est.esp-docto   = nota-fiscal.esp-docto */ NO-LOCK NO-ERROR.
                
            IF NOT AVAIL docum-est THEN DO:
                 ASSIGN p-saldo-trans = it-nota-fisc.qt-faturada[1]
                        l-achou = YES
                        p-pedido = ped-venda.nr-pedcli.

            END.
        END.

        IF l-achou = NO THEN DO:
            
            FOR EACH ped-fiscal
                WHERE ped-fiscal.nr-nota-fis <> ""
                AND ped-fiscal.cod-estabel = "601"
                AND ped-fiscal.situacao = 5 
                AND ped-fiscal.cod-emitente = 304566 NO-LOCK,

                EACH it-ped-fiscal USE-INDEX it-ped-fiscal
                WHERE it-ped-fiscal.nr-pedido = ped-fiscal.nr-pedido
                AND   it-ped-fiscal.it-codigo = p-it-codigo,

                EACH nota-fiscal USE-INDEX ch-nota
                WHERE nota-fiscal.nr-nota-fis = ped-fiscal.nr-nota-fis
                  AND nota-fiscal.cod-estabel = ped-fiscal.cod-estabel
                  AND nota-fiscal.serie       = ped-fiscal.serie NO-LOCK:

                IF nota-fiscal.idi-sit-nf-eletro <> 3 THEN NEXT.

                IF nota-fiscal.esp-docto <> 23 THEN NEXT.  /*NFT*/


                RUN pi-acompanhar in h-acomp (input " NFT: " + STRING(ped-fiscal.nr-nota-fis) + " " + STRING(p-it-codigo)).
                
                FIND FIRST docum-est
                    WHERE docum-est.nro-docto   = ped-fiscal.nr-nota-fis
                      AND docum-est.serie-docto = ped-fiscal.serie
                      AND docum-est.estab-de-or = ped-fiscal.cod-estabel NO-LOCK NO-ERROR.
                
                IF NOT AVAIL docum-est THEN DO:
                    ASSIGN p-saldo-trans = it-ped-fiscal.qtd
                           p-pedido =  string(ped-fiscal.nr-pedido).
            END.
          END.
        END.
END PROCEDURE.


PROCEDURE pi-busca-embarque:
    
    DEFINE OUTPUT PARAMETER p-qt-alocada AS DEC NO-UNDO.
    DEFINE OUTPUT PARAMETER p-cdd-embarq AS DEC NO-UNDO.

    FOR EACH pre-fatur OF ped-venda NO-LOCK 
           WHERE pre-fatur.cod-sit-pre = 1:

        FOR EACH it-pre-fat no-lock
            WHERE it-pre-fat.nome-abrev   = ped-venda.nome-abrev
            AND   it-pre-fat.nr-pedcli    = ped-venda.nr-pedcli
            AND   it-pre-fat.nr-sequencia = ped-item.nr-sequencia
            AND   it-pre-fat.it-codigo    = ped-item.it-codigo 
            AND   it-pre-fat.cdd-embarq   = pre-fatur.cdd-embarq:

              ASSIGN p-qt-alocada = it-pre-fat.qt-alocada
                     p-cdd-embarq = pre-fatur.cdd-embarq.
        END.
    END.
END PROCEDURE.
