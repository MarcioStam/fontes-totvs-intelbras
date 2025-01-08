{esp/ftp/esftp083tt.i}
{esp/es0018.i}

DEFINE VARIABLE de-volume-resto  AS DECIMAL     NO-UNDO.
DEFINE VARIABLE i-proximo-vol    AS INTEGER     NO-UNDO.
DEFINE VARIABLE de-SomaQtdePorCaixa AS DECIMAL     NO-UNDO.
DEFINE VARIABLE c-emb-escolhida  LIKE embalag.sigla-emb.
DEFINE VARIABLE de-vol-embalag   AS DECIMAL     NO-UNDO FORMAT "99.999999999".
DEFINE VARIABLE l-item-solar     AS LOGICAL     NO-UNDO.
DEFINE VARIABLE iContResto       AS INT         NO-UNDO.

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
    DEFINE OUTPUT PARAM p-erros AS CHAR.

    DEFINE VARIABLE i-quantidade     AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-tmp            AS INTEGER     NO-UNDO.
    DEFINE VARIABLE ind              AS INTEGER     NO-UNDO.
    DEFINE VARIABLE de-vol-acum      AS DECIMAL     NO-UNDO FORMAT "99.999999999".
    DEFINE VARIABLE de-vol-item      AS DECIMAL     NO-UNDO FORMAT "99.999999999".
    DEFINE VARIABLE de-peso-item     AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE r-item-caixa     AS ROWID       NO-UNDO.
    DEFINE VARIABLE lItemBranco      AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE iNrVol           LIKE volume-nf.nr-volume NO-UNDO.
    DEFINE VARIABLE de-qtde-gravada  AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE i-qt-item        LIKE item-caixa.qt-item     NO-UNDO.
    DEFINE VARIABLE i-proximo-vol    AS INTEGER     INITIAL 1 NO-UNDO.

    /*Considerar peso*/
    DEFINE VARIABLE i-qtde-vol  AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-qtde-peso AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-qtde-emb  AS INTEGER     NO-UNDO.

    ASSIGN de-volume-resto = 0.
   
    FOR EACH tt-resto:
        DELETE tt-resto.
    END.

    FOR EACH tt-itens-calculo,
        FIRST ITEM NO-LOCK
        WHERE ITEM.it-codigo = tt-itens-calculo.it-codigo
        BREAK BY tt-itens-calculo.it-codigo:

        /* Desconsidera o item DÇbito Direto */
        IF ITEM.tipo-contr  = 4 OR item.baixa-estoq = NO THEN
            NEXT.

        IF NOT p-nat-operacao BEGINS "7" THEN DO:
            IF p-cod-estabel = "101" 
            OR p-cod-estabel = "104" 
            OR p-cod-estabel = "301" 
            OR p-cod-estabel = "103" 
            OR p-cod-estabel = "105" THEN DO:

                IF p-nome-transp = "MALOTE" THEN do:
                      ASSIGN lItemBranco = YES.
                   NEXT.
                END.
           END.
        END.
   
        IF tt-itens-calculo.saida-flow-rack THEN DO: /* saida de flow rack calcula como resto / fracionado */
            FIND FIRST tt-resto 
                 WHERE tt-resto.it-codigo = tt-itens-calculo.it-codigo NO-ERROR.

            IF  NOT AVAIL tt-resto THEN DO:
                CREATE tt-resto.
                ASSIGN tt-resto.it-codigo = tt-itens-calculo.it-codigo.
            END.
            ASSIGN tt-resto.qtde   = tt-resto.qtde + tt-itens-calculo.quantidade
                   de-volume-resto = de-volume-resto + (tt-itens-calculo.quantidade * (item.altura * item.largura * item.comprim) / 1000000000).
            NEXT.
        END.

        RUN pi-busca-caixa (INPUT  p-cod-emitente,
                            INPUT  tt-itens-calculo.it-codigo,
                            INPUT  p-nat-operacao,
                            OUTPUT c-emb-escolhida,
                            OUTPUT r-item-caixa).
        
        FIND FIRST item-caixa NO-LOCK
             WHERE ROWID(item-caixa) = r-item-caixa NO-ERROR.

        IF  ITEM.it-codigo BEGINS "4" AND (ITEM.comprim = 0 OR ITEM.largura = 0 OR ITEM.altura = 0) THEN DO:
            RUN utp/ut-msgs.p (INPUT "msg",
                               INPUT 17006,
                               INPUT "Item com informaá‰es das dimens‰es zeradas." + "~~" + "Favor conferir as dimens‰es do item, para que n∆o sejam zeradas.").
            ASSIGN p-erros = RETURN-VALUE.
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
            ELSE DO:
                ASSIGN i-qt-item = item-caixa.qt-item.
                       /*i-qtde-peso = TRUNCATE(tt-itens-calculo.quantidade / i-qtde-vol,0)
                       i-qtde-peso = IF i-qtde-peso = 0 THEN 1 ELSE i-qtde-peso
                       i-qt-item = IF i-qtde-vol < item-caixa.qt-item THEN TRUNC(tt-itens-calculo.quantidade / i-qtde-peso,0) ELSE item-caixa.qt-item*/.
            END.

            
            RUN esp/es0018p.p (INPUT "esftp083",
                               INPUT 1,
                               INPUT 0,
                               INPUT "", 
                               OUTPUT TABLE tt-prog-ponto).

            ASSIGN l-item-solar = NO.
            FOR EACH tt-prog-ponto:
                IF tt-prog-ponto.conteudo = tt-itens-calculo.it-codigo THEN DO:
                    ASSIGN l-item-solar = YES.
                    LEAVE.
                END.
            END.

            IF  tt-itens-calculo.quantidade >= i-qt-item
            OR  l-item-solar THEN DO:
                ASSIGN i-tmp           = TRUNC(tt-itens-calculo.quantidade / i-qt-item,0)
                       tt-resto.qtde   = tt-resto.qtde + tt-itens-calculo.quantidade MOD i-qt-item
                       de-volume-resto = de-volume-resto + ((tt-itens-calculo.quantidade MOD i-qt-item) * (item.altura * item.largura * item.comprim) / 1000000000).

                IF l-item-solar THEN DO:
                    IF tt-itens-calculo.quantidade / i-qt-item > TRUNC(tt-itens-calculo.quantidade / i-qt-item,0) THEN DO:
                        ASSIGN i-tmp           = i-tmp + 1
                               tt-resto.qtde   = 0
                               de-volume-resto = 0.
                    END.
                END.

                DO  ind = i-proximo-vol TO (i-proximo-vol + i-tmp) - 1:
                    
                    IF item-caixa.qt-item = 0.5 AND ind MOD 2 = 0 THEN DO:
                        FOR EACH estrutura NO-LOCK
                           WHERE estrutura.it-codigo      = tt-itens-calculo.it-codigo
                             AND estrutura.data-inicio   <= TODAY
                             AND estrutura.data-termino  >  TODAY
                             AND NOT estrutura.es-codigo BEGINS "43"
                             AND NOT estrutura.es-codigo BEGINS "44":

                            IF estrutura.quant-usada <> 0 THEN
                                RUN pi-cria-ttVolumeNF(INPUT estrutura.es-codigo,
                                                       INPUT estrutura.quant-usada,
                                                       INPUT item-caixa.sigla-emb,
                                                       INPUT YES,
                                                       INPUT ind).
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
                             
                            IF item-caixa.qt-item <> 0 THEN
                                RUN pi-cria-ttVolumeNF (INPUT tt-itens-calculo.it-codigo,
                                                        INPUT IF tt-itens-calculo.quantidade > i-qt-item THEN i-qt-item ELSE tt-itens-calculo.quantidade, /*SOLAR*/
                                                        INPUT item-caixa.sigla-emb,
                                                        INPUT NO,
                                                        INPUT i-proximo-vol).
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
    
    IF  AVAIL int-emitente AND int-emitente.tipo-embalagem <> "" THEN DO:

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
            FIRST item  NO-LOCK
            WHERE item.it-codigo = tt-resto.it-codigo
            BREAK BY tt-resto.it-codigo
                  BY tt-resto.qtde:
            
            IF  FIRST-OF(tt-resto.it-codig) THEN DO:
                IF tt-resto.qtde <> 0 THEN
                    RUN pi-cria-ttVolumeNF (INPUT item.it-codigo,
                                            INPUT tt-resto.qtde,
                                            INPUT c-emb-escolhida,
                                            INPUT YES,
                                            INPUT i-proximo-vol).
           END. /* IF  FIRST-OF(tt-resto.it-codig) THEN DO: */
       END. /* FOR EACH  tt-resto NO-LOCK */
   END. /* IF c-emb-escolhida <> "" THEN DO: */
   ELSE DO:
       IF  AVAIL int-emitente AND int-emitente.tipo-embalagem <> "" THEN DO:

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
	   find first tt-resto no-lock no-error. 
	   if avail tt-resto then 
	      find first item where item.it-codigo = tt-resto.it-codigo no-lock no-error. 
	   
          FOR EACH embalag NO-LOCK
             WHERE embalag.sigla-emb BEGINS "F"
                BY embalag.volume:

              if avail item and item.cod-unid-neg <> 'ENS' and 
                 embalag.sigla-emb = 'FS1' then leave.
               
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

            IF (item.peso-bruto * tt-resto.qtde) < 10 THEN DO:
               REPEAT:
                    ASSIGN de-qtde-gravada = 0.
                    
                    DO i-quantidade = 1 TO tt-resto.qtde:
                
                        ASSIGN de-vol-item  = ((item.altura * item.largura * item.comprim) / 1000000000).
                
                        IF  (de-vol-acum + de-vol-item) > de-vol-embalag THEN DO:
                             ASSIGN de-vol-acum = 0.
/*                                    i-proximo-vol = i-proximo-vol + 1. NA TEORIA N«O PRECISA PORQUE JA ESTA COM O PROXIMO VOLUME SETADO */
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
                    IF  de-vol-acum = 0 AND tt-resto.qtde = 0 THEN 
                        LEAVE.
                
                    IF  de-vol-acum = 0 AND de-qtde-gravada = 0 AND
                        (tt-resto.qtde = 1 OR de-vol-item > de-vol-embalag) THEN DO:
                           
                           IF tt-resto.qtde > 0 THEN
                               RUN pi-cria-ttVolumeNF (INPUT item.it-codigo,
                                                       INPUT tt-resto.qtde,
                                                       INPUT "CX",
                                                       INPUT YES,
                                                       INPUT i-proximo-vol).

                            ASSIGN i-proximo-vol = i-proximo-vol + 1.
                            LEAVE.
                    END.
                
                    ASSIGN de-volume-resto = 0
                           iContResto      = 0.
                
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
                
                    IF  AVAIL int-emitente AND int-emitente.tipo-embalagem <> "" THEN DO:
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
                           IF tt-resto.qtde > 0 THEN
                               RUN pi-cria-ttVolumeNF (INPUT item.it-codigo,
                                                       INPUT tt-resto.qtde,
                                                       INPUT "CX",
                                                       INPUT YES,
                                                       INPUT i-proximo-vol).
                            LEAVE.
                     END.
                END. /* REPEAT: */
            END.
            ELSE DO:
                IF tt-resto.qtde <> 0 THEN
                    RUN pi-cria-ttVolumeNF (INPUT item.it-codigo,
                                            INPUT tt-resto.qtde,
                                            INPUT c-emb-escolhida,
                                            INPUT YES,
                                            INPUT i-proximo-vol).
            END.
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
                   /*AND item-caixa.sigla-emb BEGINS "E"*/ NO-ERROR.

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

                IF  SUBSTRING(item-caixa.sigla-emb,1,1) >= "A" THEN DO:

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
                       /*AND item-caixa.sigla-emb  BEGINS "E"*/ NO-ERROR.
            END.
            
 
        END.
    END.
    
    
    /**** busca a caixa coletiva para os itens Placa - Energia Solar ***/
    EMPTY TEMP-TABLE tt-prog-ponto.
    
    RUN esp/es0018p.p (INPUT "bodi317ef":U,
                       INPUT 9,
                       INPUT 0,
                       INPUT "":U,
                       OUTPUT TABLE tt-prog-ponto).

    find first tt-prog-ponto
         where tt-prog-ponto.conteudo = p-it-codigo no-lock no-error.
    if avail tt-prog-ponto then 
       FIND first item-caixa NO-LOCK
           WHERE item-caixa.it-codigo = p-it-codigo 
             and item-caixa.qt-item   > 1 NO-ERROR.

    IF AVAIL item-caixa THEN
        ASSIGN p-item-caixa = ROWID(item-caixa).

END PROCEDURE.

PROCEDURE pi-cria-caixa-resto:
    
    IF embalag.volume < de-volume-resto AND i-proximo-vol <> 0 THEN DO:

        ASSIGN iContResto = iContResto + 1.

        RUN pi-cria-ttVolumeNF(INPUT item.it-codigo,
                               INPUT embalag.volume,
                               INPUT "CX",
                               INPUT YES,
                               INPUT i-proximo-vol).

        ASSIGN de-volume-resto      = de-volume-resto - embalag.volume
               de-SomaQtdePorCaixa  = de-SomaQtdePorCaixa  + embalag.volume.

        IF iContResto < 5 THEN //Limita contador pra nao ficar em looping e travar o faturamento
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

PROCEDURE pi-cria-ttVolumeNF:
    DEFINE INPUT PARAMETER c-it-codigo LIKE item.it-codigo              NO-UNDO.
    DEFINE INPUT PARAMETER qtd-Volume  LIKE volume-nf.qtde       NO-UNDO.
    DEFINE INPUT PARAMETER c-SiglaEmb  LIKE volume-nf.sigla-emb  NO-UNDO.
    DEFINE INPUT PARAMETER l-varios-it LIKE volume-nf.varios-itens      NO-UNDO.
    DEFINE INPUT PARAMETER i-prox-volume AS INTEGER                     NO-UNDO.

    DEFINE VARIABLE qtd-VolCalc AS INTEGER NO-UNDO.
    DEFINE VARIABLE qtd-VolNF   AS DECIMAL NO-UNDO.
    DEFINE VARIABLE i-contVol   AS INTEGER NO-UNDO.
    DEFINE VARIABLE i-ult-vol   AS INTEGER NO-UNDO.

    FIND FIRST item WHERE item.it-codigo = c-it-codigo NO-LOCK NO-ERROR.

    ASSIGN /*qtd-VolNF   = TRUNCATE(DECIMAL(10 / item.peso-bruto),0)*/
           qtd-VolNF   = qtd-Volume
           qtd-VolCalc = qtd-Volume / IF qtd-VolNF = 0 THEN 1 ELSE qtd-VolNF
           qtd-VolNF   = IF qtd-VolNF   <= 0 THEN 1 ELSE qtd-VolNF
           qtd-VolCalc = IF qtd-VolCalc  = 0 THEN 1 ELSE qtd-VolCalc.

    IF l-varios-it THEN DO:
        /*FOR LAST tt-volumes
            WHERE tt-volumes.it-codigo = c-it-codigo:
            ASSIGN i-ult-vol = i-proximo-vol. 
        END.*/
        ASSIGN i-ult-vol = i-prox-volume - 1.
    END.
    ELSE DO:
        FOR LAST tt-volumes:
        
            ASSIGN i-ult-vol = tt-volumes.nr-volume. 
        END.
    END.

    DO i-contVol = 1 TO qtd-VolCalc:
        CREATE tt-volumes.
        ASSIGN tt-volumes.it-codigo    = c-it-codigo
               tt-volumes.nr-volume    = i-ult-vol + i-contVol
               tt-volumes.sigla-emb    = c-SiglaEmb
               tt-volumes.varios-itens = l-varios-it.

        IF qtd-VolCalc = i-contVol THEN
            ASSIGN tt-volumes.qtde = qtd-Volume.
        ELSE
            ASSIGN tt-volumes.qtde = qtd-VolNF.

        ASSIGN qtd-Volume = qtd-Volume - qtd-VolNF
                tt-volumes.peso  =  tt-volumes.qtde * ITEM.peso-bruto.
    END.

    RETURN "OK".
END PROCEDURE.
