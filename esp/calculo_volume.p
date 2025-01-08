DEFINE VARIABLE de-volume-resto  AS DECIMAL     NO-UNDO.
DEFINE VARIABLE i-proximo-vol    AS INTEGER     NO-UNDO.
DEFINE VARIABLE de-SomaQtdePorCaixa AS DECIMAL     NO-UNDO.
DEFINE VARIABLE c-emb-escolhida  LIKE embalag.sigla-emb.
DEFINE VARIABLE de-vol-embalag   AS DECIMAL     NO-UNDO FORMAT "99.999999999".

DEFINE TEMP-TABLE tt-resto
    FIELD it-codigo LIKE ITEM.it-codigo
    FIELD qtde      AS DEC
    INDEX tt-resto  AS PRIMARY UNIQUE it-codigo
    INDEX qtde      qtde.

DEFINE TEMP-TABLE tt-itens-calculo
    FIELD it-codigo  LIKE ITEM.it-codigo
    FIELD quantidade AS DEC.

DEFINE TEMP-TABLE tt-volumes
    FIELD it-codigo    LIKE volume-nf.it-codigo
    FIELD nr-volume    LIKE volume-nf.nr-volume
    FIELD qtde         LIKE volume-nf.qtde     
    FIELD sigla-emb    LIKE volume-nf.sigla-emb   
    FIELD varios-itens LIKE volume-nf.varios-itens
    INDEX nr-volume    nr-volume.

DEFINE BUFFER b-item         FOR ITEM.
DEFINE BUFFER b-tt-resto     FOR tt-resto.
DEFINE BUFFER b-embalagResto FOR embalag.

PROCEDURE pi-calcula-volumes:
    DEFINE INPUT  PARAM p-cod-emitente  LIKE emitente.cod-emitente.
    DEFINE INPUT  PARAM p-nat-operacao  LIKE natur-oper.nat-operacao.
    DEFINE INPUT  PARAM p-cod-estabel   LIKE estabelec.cod-estabel.
    DEFINE INPUT  PARAM p-nome-transp   LIKE transporte.nome-abrev.
    DEFINE INPUT  PARAM TABLE FOR tt-itens-calculo.
    DEFINE OUTPUT PARAM TABLE FOR tt-volumes.

    DEFINE VARIABLE i-quantidade     AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-tmp            AS INTEGER     NO-UNDO.
    DEFINE VARIABLE ind              AS INTEGER     NO-UNDO.
    DEFINE VARIABLE de-vol-acum      AS DECIMAL     NO-UNDO FORMAT "99.999999999".
    DEFINE VARIABLE de-vol-item      AS DECIMAL     NO-UNDO FORMAT "99.999999999".
    DEFINE VARIABLE r-item-caixa     AS ROWID       NO-UNDO.
    DEFINE VARIABLE lItemBranco      AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE iNrVol           LIKE volume-nf.nr-volume NO-UNDO.
    DEFINE VARIABLE de-qtde-gravada  AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE i-qt-item        LIKE item-caixa.qt-item     NO-UNDO.
    DEFINE VARIABLE i-proximo-vol    AS INTEGER     NO-UNDO.
   
    ASSIGN de-volume-resto = 0.
   
    FOR EACH tt-resto:
        DELETE tt-resto.
    END.

    FOR EACH tt-itens-calculo,
       FIRST ITEM NO-LOCK 
       WHERE ITEM.it-codigo = tt-itens-calculo.it-codigo
       BREAK BY tt-itens-calculo.it-codigo:

        /* Desconsidera o item DÇbito Direto */
        IF ITEM.tipo-contr  = 4  
        OR item.baixa-estoq = NO THEN
            NEXT.

        IF NOT p-nat-operacao BEGINS "7" THEN DO:
            IF p-cod-estabel = "101" 
            OR p-cod-estabel = "104" 
            OR p-cod-estabel = "301" 
            OR p-cod-estabel = "103" 
            OR p-cod-estabel = "105" THEN DO:

                IF p-nome-transp = "MALOTE" then do:
                      ASSIGN lItemBranco = YES.
                   NEXT.
                END.
           END.
        END.
   
        RUN pi-busca-caixa (INPUT  p-cod-emitente,
                            INPUT  tt-itens-calculo.it-codigo,
                            INPUT  p-nat-operacao,
                            OUTPUT c-emb-escolhida,
                            OUTPUT r-item-caixa).
        
        FIND FIRST item-caixa NO-LOCK
             WHERE ROWID(item-caixa) = r-item-caixa NO-ERROR.

        IF  ITEM.it-codigo BEGINS "4" 
        AND (ITEM.comprim = 0 OR ITEM.largura = 0 OR ITEM.altura = 0) THEN DO:
            MESSAGE "Item com informaá‰es das dimens‰es zeradas." SKIP
                    "Favor conferir as dimens‰es do item, para que n∆o sejam zeradas."
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
   
            RETURN "NOK".
        END.

        FIND FIRST tt-resto 
             WHERE tt-resto.it-codigo = tt-itens-calculo.it-codigo NO-ERROR.

        IF  NOT AVAIL tt-resto THEN DO:
            CREATE tt-resto.
            ASSIGN tt-resto.it-codigo = tt-itens-calculo.it-codigo.
        END.

        IF  AVAIL item-caixa THEN DO:
            IF item-caixa.qt-item = 0.6 THEN
                ASSIGN i-qt-item = 1.
            ELSE
                ASSIGN i-qt-item = item-caixa.qt-item.

            IF  tt-itens-calculo.quantidade >= i-qt-item THEN DO:
                ASSIGN i-tmp           = TRUNC(tt-itens-calculo.quantidade / i-qt-item,0)
                       tt-resto.qtde   = tt-resto.qtde + tt-itens-calculo.quantidade MOD i-qt-item
                       de-volume-resto = de-volume-resto + ((tt-itens-calculo.quantidade MOD i-qt-item) * (item.altura * item.largura * item.comprim) / 1000000000).

                DO  ind = i-proximo-vol TO (i-proximo-vol + i-tmp) - 1:
                    IF item-caixa.qt-item = 0.5 AND ind MOD 2 = 0 THEN DO:
                        FOR EACH estrutura NO-LOCK
                           WHERE estrutura.it-codigo      = tt-itens-calculo.it-codigo
                             AND estrutura.data-inicio   <= TODAY
                             AND estrutura.data-termino  >  TODAY
                             AND NOT estrutura.es-codigo BEGINS "43"
                             AND NOT estrutura.es-codigo BEGINS "44":

                            FIND FIRST tt-volumes
                                 WHERE tt-volumes.it-codigo = estrutura.es-codigo
                                   AND tt-volumes.nr-volume = ind NO-ERROR.

                            IF  NOT AVAIL tt-volumes THEN DO:
                                
                                CREATE tt-volumes.
                                ASSIGN tt-volumes.it-codigo = estrutura.es-codigo
                                       tt-volumes.nr-volume = ind.
                            END.

                            ASSIGN tt-volumes.qtde         = tt-volumes.qtde + estrutura.quant-usada
                                   tt-volumes.sigla-emb    = item-caixa.sigla-emb
                                   tt-volumes.varios-itens = YES.
                        END.
                    END.
                    ELSE DO:
                        IF  item-caixa.qt-item = 0.6 THEN DO: /* Indica que Ç uma central configurada e suas placas v∆o dentro da mesma caixa */
                            FOR EACH estrutura NO-LOCK
                               WHERE estrutura.it-codigo     = tt-itens-calculo.it-codigo
                                 AND estrutura.data-inicio  <= TODAY
                                 AND estrutura.data-termino >  TODAY:

                                FIND FIRST tt-volumes EXCLUSIVE-LOCK
                                     WHERE tt-volumes.it-codigo   = estrutura.es-codigo
                                       AND tt-volumes.nr-volume   = ind NO-ERROR.

                                IF  NOT AVAIL tt-volumes THEN DO:
                                    
                                    CREATE tt-volumes.
                                    ASSIGN tt-volumes.it-codigo   = estrutura.es-codigo   
                                           tt-volumes.nr-volume   = ind no-error.       
                                END.
    
                                ASSIGN tt-volumes.qtde         = tt-volumes.qtde + estrutura.quant-usada
                                       tt-volumes.sigla-emb    = item-caixa.sigla-emb
                                       tt-volumes.varios-itens = YES.
                            END.
                        END.
                        ELSE DO:
                            FIND FIRST tt-volumes EXCLUSIVE-LOCK
                                 WHERE tt-volumes.it-codigo   = tt-itens-calculo.it-codigo
                                   AND tt-volumes.nr-volume   = ind NO-ERROR.

                            IF  NOT AVAIL tt-volumes THEN DO:

                                CREATE tt-volumes.
                                ASSIGN tt-volumes.it-codigo   = tt-itens-calculo.it-codigo
                                       tt-volumes.nr-volume   = ind.
                            END.

                            IF item-caixa.qt-item = 0.6 THEN /* Indica que Ç uma central configurada e suas placas v∆o dentro da mesma caixa */
                                ASSIGN tt-volumes.qtde = tt-volumes.qtde + 1.
                            ELSE                             
                                ASSIGN tt-volumes.qtde = tt-volumes.qtde + item-caixa.qt-item.

                            ASSIGN tt-volumes.sigla-emb = item-caixa.sigla-emb.
                        END.
                    END.
                END.

                ASSIGN i-proximo-vol =  ind.
            END.
            ELSE DO:
                ASSIGN tt-resto.qtde   = tt-resto.qtde + tt-itens-calculo.quantidade
                       de-volume-resto = de-volume-resto + (tt-itens-calculo.quantidade * (item.altura * item.largura * item.comprim) / 1000000000).
            END.
        END. /* AVAIL item-caixa */
        ELSE DO:
            ASSIGN tt-resto.qtde   = tt-resto.qtde +  tt-itens-calculo.quantidade
                   de-volume-resto = de-volume-resto + (tt-itens-calculo.quantidade * (item.altura * item.largura * item.comprim) / 1000000000).
        END.
    END.

    /* Busca uma embalagem unica para colocar todos os itens que s∆o resto */
    ASSIGN c-emb-escolhida = ""
           de-vol-embalag  = 0.
    
    IF  AVAIL int-emitente 
    AND int-emitente.tipo-embalagem <> "" THEN DO:

       FIND FIRST embalag NO-LOCK
            WHERE embalag.embalagem = int-emitente.tipo-embalagem NO-ERROR.

       IF AVAIL embalag THEN DO:
           ASSIGN c-emb-escolhida = "".
       END.
    END.
    ELSE DO:
        blk_embalagem:
        FOR EACH embalag NO-LOCK
           WHERE embalag.sigla-emb BEGINS "F"
              BY embalag.volume:

            IF  embalag.volume >= de-volume-resto THEN DO:

                ASSIGN c-emb-escolhida = embalag.sigla-emb
                       de-vol-embalag  = (embalag.altura * embalag.comprim * embalag.largura) / 1000000000.
                LEAVE blk_embalagem.
            END.
        END.    
    END.

    IF c-emb-escolhida <> "" THEN DO: /* SIGNIFICA QUE ACHOU UMA CAIXA QUE COMPORTA TODO O FRACIONADO */

       FIND LAST tt-volumes NO-ERROR.

       IF  AVAIL tt-volumes THEN
           ASSIGN i-proximo-vol = tt-volumes.nr-volume + 1.
       ELSE
           ASSIGN i-proximo-vol = 1.
           
       FOR EACH tt-resto NO-LOCK
          WHERE tt-resto.qtde > 0,
           FIRST ITEM  NO-LOCK
           WHERE ITEM.it-codigo = tt-resto.it-codigo
           BREAK BY tt-resto.it-codigo
                 BY tt-resto.qtde:

           IF  FIRST-OF(tt-resto.it-codig) THEN DO:

               FIND FIRST tt-volumes EXCLUSIVE-LOCK
                    WHERE tt-volumes.it-codigo   = item.it-codigo
                      AND tt-volumes.nr-volume   = i-proximo-vol NO-ERROR.

               IF  NOT AVAIL tt-volumes THEN DO:
                   CREATE tt-volumes.
                   ASSIGN tt-volumes.it-codigo    = item.it-codigo
                          tt-volumes.nr-volume    = i-proximo-vol
                          tt-volumes.varios-itens = YES
                          tt-volumes.qtde         = tt-resto.qtde
                          tt-volumes.sigla-emb    = c-emb-escolhida.

               END. /* IF  NOT AVAIL tt-volumes THEN DO: */
           END. /* IF  FIRST-OF(tt-resto.it-codig) THEN DO: */
       END. /* FOR EACH  tt-resto NO-LOCK */
   END. /* IF c-emb-escolhida <> "" THEN DO: */
   ELSE DO:

       IF  AVAIL int-emitente 
       AND int-emitente.tipo-embalagem <> "" THEN DO:

           FIND FIRST embalag NO-LOCK
                WHERE embalag.embalagem = int-emitente.tipo-embalagem NO-ERROR.

           IF AVAIL embalag THEN DO:
              ASSIGN c-emb-escolhida = embalag.sigla-emb
                     de-vol-embalag  = (embalag.altura * embalag.comprim * embalag.largura) / 1000000000.

              IF int-emitente.tipo-embalagem = "palletMO" THEN
                  ASSIGN de-vol-embalag = de-vol-embalag * 0.865. /* desconsiderar o tamanho da pallet quando Moáambique */
              ELSE
                  IF int-emitente.tipo-embalagem BEGINS "pallet" THEN
                     ASSIGN de-vol-embalag = de-vol-embalag * 0.90. /* desconsiderar o tamanho da pallet para os demais clientes */
           END.
       END.
	   ELSE DO:
          FOR EACH embalag NO-LOCK
             WHERE embalag.sigla-emb BEGINS "F"
                BY embalag.volume:

              ASSIGN c-emb-escolhida = embalag.sigla-emb
                     de-vol-embalag  = (embalag.altura * embalag.comprim * embalag.largura) / 1000000000.
          END.
       END.

       FIND LAST tt-volumes NO-ERROR.

       IF  AVAIL tt-volumes THEN
           ASSIGN i-proximo-vol = tt-volumes.nr-volume + 1.
       ELSE
           ASSIGN i-proximo-vol = 1.

        ASSIGN de-vol-acum = 0
               de-vol-item = 0.
        
        FOR EACH tt-resto
           WHERE tt-resto.qtde > 0,
           FIRST ITEM NO-LOCK
           WHERE ITEM.it-codigo = tt-resto.it-codigo
           BREAK BY tt-resto.it-codigo
                 BY tt-resto.qtde:

            REPEAT:
                ASSIGN de-qtde-gravada = 0.
                
                DO i-quantidade = 1 TO tt-resto.qtde:

                    ASSIGN de-vol-item = ((item.altura * item.largura * item.comprim) / 1000000000).
        
                    IF  (de-vol-acum + de-vol-item) > de-vol-embalag THEN DO:                  
                        ASSIGN de-vol-acum   = 0.
/*                                i-proximo-vol = i-proximo-vol + 1. NA TEORIA N«O PRECISA PORQUE JA ESTA COM O PROXIMO VOLUME SETADO */
                        LEAVE.
                    END.
                    ELSE DO:
                        FIND FIRST tt-volumes EXCLUSIVE-LOCK
                             WHERE tt-volumes.it-codigo    = item.it-codigo
                               AND tt-volumes.nr-volume    = i-proximo-vol NO-ERROR.

                        IF  NOT AVAIL tt-volumes THEN DO:
                            CREATE tt-volumes.
                            ASSIGN tt-volumes.it-codigo    = item.it-codigo
                                   tt-volumes.nr-volume    = i-proximo-vol
                                   tt-volumes.varios-itens = YES.
                        END.
    
                        ASSIGN tt-volumes.qtde      = tt-volumes.qtde + 1
                               tt-volumes.sigla-emb = c-emb-escolhida
                               de-vol-acum          = de-vol-acum + de-vol-item
                               de-qtde-gravada      = de-qtde-gravada + 1.
                    END.
                END.
                
                ASSIGN tt-resto.qtde = tt-resto.qtde - de-qtde-gravada.

                IF de-vol-acum > 0 THEN 
                    IF tt-resto.qtde <= 0 THEN 
                        LEAVE.
                IF  de-vol-acum   = 0 
                AND tt-resto.qtde = 0 THEN 
                    LEAVE.

                IF  de-vol-acum = 0 
                AND de-qtde-gravada = 0 
                AND (tt-resto.qtde = 1 OR de-vol-item > de-vol-embalag) THEN DO:
                       
                       FIND FIRST tt-volumes EXCLUSIVE-LOCK
                            WHERE tt-volumes.it-codigo   = item.it-codigo
                              AND tt-volumes.nr-volume   = i-proximo-vol NO-ERROR.

                        IF  NOT AVAIL tt-volumes THEN DO:
                            CREATE tt-volumes.
                            ASSIGN tt-volumes.it-codigo    = item.it-codigo
                                   tt-volumes.nr-volume    = i-proximo-vol
                                   tt-volumes.varios-itens = YES.
                        END.
    
                        ASSIGN tt-volumes.qtde             = tt-resto.qtde
                               tt-volumes.sigla-emb        = "CX".

                        ASSIGN i-proximo-vol = i-proximo-vol + 1.
                        LEAVE.
                END.

                ASSIGN de-volume-resto = 0.

                FOR EACH b-tt-resto
                   WHERE b-tt-resto.qtde > 0,
                   FIRST b-item NO-LOCK
                   WHERE b-item.it-codigo = b-tt-resto.it-codigo:

                    ASSIGN de-volume-resto = de-volume-resto + (b-tt-resto.qtde * (b-item.altura * b-item.largura * b-item.comprim) / 1000000000).
                END.
                
                IF de-volume-resto = 0 THEN DO:
                    LEAVE.
                END.
                     
                ASSIGN c-emb-escolhida = "".

                IF  AVAIL int-emitente 
                AND int-emitente.tipo-embalagem <> "" THEN DO:
                    FIND FIRST embalag NO-LOCK
                         WHERE embalag.embalagem = int-emitente.tipo-embalagem NO-ERROR.

                    IF AVAIL embalag THEN DO:
                       ASSIGN c-emb-escolhida = embalag.sigla-emb
                              de-vol-embalag  = (embalag.altura * embalag.comprim * embalag.largura) / 1000000000.

                       IF int-emitente.tipo-embalagem = "palletMO" THEN
                           ASSIGN de-vol-embalag = de-vol-embalag * 0.865. /* desconsiderar o tamanho da pallet quando Moáambique */
                       ELSE IF int-emitente.tipo-embalagem BEGINS "pallet" THEN
                              ASSIGN de-vol-embalag = de-vol-embalag * 0.90. /* desconsiderar o tamanho da pallet para os demais clientes */
                    END.
                END.
	            ELSE DO:
                     blk_embalagem1:
                     FOR EACH embalag NO-LOCK
                        WHERE embalag.sigla-emb BEGINS "F"
                           BY embalag.volume:

                         IF  embalag.volume >= de-volume-resto THEN DO:
                             ASSIGN c-emb-escolhida = embalag.sigla-emb
                                    de-vol-embalag  = (embalag.altura * embalag.comprim * embalag.largura) / 1000000000.                                                             
                             
                            LEAVE blk_embalagem1.
                         END.
                     END.

                     IF c-emb-escolhida = "" THEN DO:
                        FOR EACH embalag NO-LOCK
                           WHERE embalag.sigla-emb BEGINS "F"
                              BY embalag.volume:

                            ASSIGN c-emb-escolhida = embalag.sigla-emb
                                   de-vol-embalag  = (embalag.altura * embalag.comprim * embalag.largura) / 1000000000.
                        END.

                        FIND FIRST embalag NO-LOCK
                             WHERE embalag.sigla-emb = c-emb-escolhida NO-ERROR.

                        IF AVAIL embalag THEN
                            RUN pi-cria-caixa-resto.
                    END.
                END.

                /*"NAO ENCONTROU NENHUMA CAIXA QUE COMPORTASSE ESTE ITEM " TT-RESTO.QTDE " " ITEM.IT-CODIGO */
                IF c-emb-escolhida = "" THEN DO:
                       FIND FIRST tt-volumes EXCLUSIVE-LOCK
                            WHERE tt-volumes.it-codigo   = item.it-codigo
                              AND tt-volumes.nr-volume   = i-proximo-vol NO-ERROR.

                        IF  NOT AVAIL tt-volumes THEN DO:
                            CREATE tt-volumes.
                            ASSIGN tt-volumes.it-codigo    = item.it-codigo
                                   tt-volumes.nr-volume    = i-proximo-vol
                                   tt-volumes.varios-itens = YES.
                        END.
    
                        ASSIGN tt-volumes.qtde             = tt-resto.qtde
                               tt-volumes.sigla-emb        = "CX".

                        LEAVE.
                 END.
            END. /* REPEAT: */
        END. /* FOR EACH tt-resto */
    END. /* IF c-emb-escolhida = "" THEN DO: */

    IF  lItemBranco THEN DO:
        
        FIND LAST tt-volumes NO-ERROR.

        IF  AVAIL  tt-volumes THEN
            ASSIGN iNrVol = tt-volumes.nr-volume + 1.
        ELSE
            ASSIGN iNrVol = 1.
   
        CREATE tt-volumes.
        ASSIGN tt-volumes.it-codigo   = ""
               tt-volumes.nr-volume   = iNrVol.
    END.

END PROCEDURE. /* PROCEDURE pi-calcula-volumes. */

PROCEDURE pi-busca-caixa:
    DEFINE INPUT  PARAM p-cod-emitente  LIKE emitente.cod-emitente.
    DEFINE INPUT  PARAM p-it-codigo     LIKE ITEM.it-codigo.
    DEFINE INPUT  PARAM p-nat-operacao  LIKE natur-oper.nat-operacao.
    DEFINE OUTPUT PARAM p-emb-escolhida LIKE embalag.sigla-emb.
    DEFINE OUTPUT PARAM p-item-caixa    AS ROWID.

    FIND FIRST int-emitente NO-LOCK
         WHERE int-emitente.cod-emitente = p-cod-emitente NO-ERROR.

    IF  AVAIL int-emitente 
    AND int-emitente.tipo-embalagem <> "" THEN DO:

       FIND FIRST embalag NO-LOCK
            WHERE embalag.embalagem = int-emitente.tipo-embalagem NO-ERROR.

       IF AVAIL embalag THEN
           ASSIGN p-emb-escolhida = embalag.sigla-emb.

       FIND FIRST item-caixa NO-LOCK
            WHERE item-caixa.sigla-emb  BEGINS embalag.sigla-emb
              AND item-caixa.it-codigo  = p-it-codigo
              AND item-caixa.fm-cod-com = ?
              AND item-caixa.fm-codigo  = ? NO-ERROR.
    END.
    ELSE DO:
        IF  p-nat-operacao BEGINS "7" THEN DO:
            FIND FIRST item-caixa NO-LOCK
                 WHERE item-caixa.it-codigo  = p-it-codigo
                   AND item-caixa.fm-cod-com = ?
                   AND item-caixa.fm-codigo  = ? 
                   AND item-caixa.sigla-emb BEGINS "E" NO-ERROR.

            IF  NOT AVAIL item-caixa THEN DO:

                ASSIGN p-item-caixa = ?.

                blk_sigla:
                FOR EACH item-caixa NO-LOCK
                   WHERE item-caixa.it-codigo  = p-it-codigo
                     AND item-caixa.fm-cod-com = ?
                     AND item-caixa.fm-codigo  = ?:

                    IF  SUBSTRING(item-caixa.sigla-emb,1,1) >= "N"
                    AND SUBSTRING(item-caixa.sigla-emb,1,1) <> "S" THEN DO: /* Shrink */

                        ASSIGN p-item-caixa = ROWID(item-caixa).
                        LEAVE blk_sigla.
                    END.
                END.
     
                FIND FIRST item-caixa NO-LOCK
                     WHERE ROWID(item-caixa) = p-item-caixa NO-ERROR.
            END.

            ASSIGN p-emb-escolhida = "".

            IF AVAIL item-caixa THEN DO:

                FOR FIRST embalag NO-LOCK
                    WHERE embalag.sigla-emb = item-caixa.sigla-emb:
                    ASSIGN p-emb-escolhida = embalag.sigla-emb.
                END.

                IF NOT AVAIL embalag THEN DO:
                    FOR EACH embalag NO-LOCK
                       WHERE embalag.embalagem BEGINS "EMB"
                         AND embalag.emite-roman 
                    BREAK BY embalag.volume:

                        ASSIGN p-emb-escolhida = embalag.sigla-emb.
                    END.

                    FIND FIRST item-caixa NO-LOCK
                         WHERE item-caixa.sigla-emb  BEGINS p-emb-escolhida
                           AND item-caixa.it-codigo  = p-it-codigo
                           AND item-caixa.fm-cod-com = ?
                           AND item-caixa.fm-codigo  = ? NO-ERROR.
                END.
            END.
        END.
        ELSE  DO:
            ASSIGN p-item-caixa = ?.
   
            blk_sigla:
            FOR EACH item-caixa NO-LOCK
               WHERE item-caixa.it-codigo  = p-it-codigo
                 AND item-caixa.fm-cod-com = ?
                 AND item-caixa.fm-codigo  = ?:

                IF  SUBSTRING(item-caixa.sigla-emb,1,1) >= "N" THEN DO:

                    ASSIGN p-item-caixa = ROWID(item-caixa).
                    LEAVE blk_sigla.
                END.
            END.
   
            FIND FIRST item-caixa NO-LOCK
                 WHERE ROWID(item-caixa) = p-item-caixa NO-ERROR.

            IF  NOT AVAIL item-caixa THEN DO:

                FIND FIRST item-caixa NO-LOCK
                     WHERE item-caixa.it-codigo  = p-it-codigo
                       AND item-caixa.fm-cod-com = ?
                       AND item-caixa.fm-codigo  = ?
                       AND item-caixa.sigla-emb  BEGINS "E" NO-ERROR.
            END.
        END.
    END.

    IF AVAIL item-caixa THEN
        ASSIGN p-item-caixa = ROWID(item-caixa).

END PROCEDURE.

PROCEDURE pi-cria-caixa-resto:

    IF embalag.volume < de-volume-resto THEN DO:
        FIND FIRST tt-volumes EXCLUSIVE-LOCK
             WHERE tt-volumes.it-codigo    = item.it-codigo
               AND tt-volumes.nr-volume    = i-proximo-vol NO-ERROR.

         IF  NOT AVAIL tt-volumes THEN DO:
             CREATE tt-volumes.
             ASSIGN tt-volumes.it-codigo    = item.it-codigo
                    tt-volumes.nr-volume    = i-proximo-vol
                    tt-volumes.varios-itens = YES
                    tt-volumes.qtde         = embalag.volume.
         END.

         ASSIGN tt-volumes.qtde      = tt-volumes.qtde + embalag.volume
                de-volume-resto      = de-volume-resto - embalag.volume
                tt-volumes.sigla-emb = "CX"
                de-SomaQtdePorCaixa  = de-SomaQtdePorCaixa  + embalag.volume.

         RUN pi-cria-caixa-resto.
    END.
    ELSE DO:
        FOR EACH b-embalagResto NO-LOCK
           WHERE b-embalagResto.sigla-emb BEGINS "F"
              BY b-embalagResto.volume:

            IF  b-embalagResto.volume >= de-volume-resto THEN DO:
                ASSIGN c-emb-escolhida = b-embalagResto.sigla-emb
                       de-vol-embalag  = (b-embalagResto.altura * b-embalagResto.comprim * b-embalagResto.largura) / 1000000000.
                LEAVE.
            END.

        END. /* FOR EACH  b-embalagResto NO-LOCK */

        LEAVE.
    END.

END PROCEDURE.
