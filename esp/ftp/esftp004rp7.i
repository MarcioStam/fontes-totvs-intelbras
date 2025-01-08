    EACH nota-fiscal NO-LOCK                                  WHERE
         nota-fiscal.cod-estabel   = tt-param.cod-estabel     AND 
         nota-fiscal.nr-nota-fis  >= tt-param.nrNotaFisIni    AND
         nota-fiscal.nr-nota-fis  <= tt-param.nrNotaFisFim    AND
         nota-fiscal.cdd-embarq    = embarque.cdd-embarq      AND
         nota-fiscal.nome-transp   = tt-param.nome-transp-ini AND
         nota-fiscal.dt-cancela    = ?
          /*AND nota-fiscal.nome-abrev-tri = ""*/,

    FIRST natur-oper NO-LOCK WHERE
          natur-oper.nat-operacao    = nota-fiscal.nat-operacao
        /*  AND natur-oper.baixa-estoq */ ,
    EACH volume-nf NO-LOCK                               WHERE
         volume-nf.cod-estabel = nota-fiscal.cod-estabel AND
         volume-nf.serie       = nota-fiscal.serie       AND
         volume-nf.nr-nota-fis = nota-fiscal.nr-nota-fis AND
         volume-nf.it-codigo >= tt-param.itCodigoIni     AND
         volume-nf.it-codigo <= tt-param.itCodigoFim     AND
         volume-nf.nr-volume >= tt-param.nrVolumeIni     AND
         volume-nf.nr-volume <= tt-param.nrVolumeFim     AND
         not volume-nf.varios-itens,
    FIRST ITEM FIELDS(it-codigo desc-item) NO-LOCK WHERE
          ITEM.it-codigo = volume-nf.it-codigo,
    FIRST tt-seq-item
          WHERE tt-seq-item.it-codigo = item.it-codigo
            AND tt-seq-item.nr-volume = volume-nf.nr-volume 
    BREAK BY
          tt-seq-item.sequencia DESCENDING         BY
          volume-nf.nr-nota-fis                    BY
          volume-nf.it-codigo                      BY
          volume-nf.nr-volume                      BY
          volume-nf.cod-estabel                    BY
          volume-nf.serie:
    {esp/ftp/esftp004rp11.i} 
    IF tt-param.Rastreabilidade = 1 THEN DO:
        FIND FIRST tt-item-rast
            WHERE tt-item-rast.it-codigo = volume-nf.it-codigo NO-ERROR.

        IF NOT AVAILABLE tt-item-rast THEN NEXT.
    END.
    ELSE IF tt-param.Rastreabilidade = 2 THEN DO:
        FIND FIRST tt-item-rast
            WHERE tt-item-rast.it-codigo = volume-nf.it-codigo NO-ERROR.

        IF AVAILABLE tt-item-rast THEN NEXT.
    END.

    IF tt-param.tipo-volume <> 3 THEN DO:
        IF nota-fiscal.nat-operacao BEGINS "7":U THEN DO:
            FIND FIRST int-emitente
                WHERE int-emitente.cod-emitente = nota-fiscal.cod-emitente NO-LOCK NO-ERROR.

            IF AVAILABLE int-emitente              AND
               int-emitente.tipo-embalagem <> "":U THEN DO:
                FIND FIRST embalag
                    WHERE embalag.embalagem = int-emitente.tipo-embalagem NO-LOCK NO-ERROR.

                IF AVAILABLE embalag THEN
                    FIND FIRST item-caixa
                        WHERE item-caixa.it-codigo  = volume-nf.it-codigo
                          AND item-caixa.fm-codigo  = ?
                          AND item-caixa.fm-cod-com = ?
                          AND item-caixa.sigla-emb  = volume-nf.sigla-emb NO-LOCK NO-ERROR.
            END.
            ELSE DO:
                FIND FIRST item-caixa
                    WHERE item-caixa.it-codigo  = volume-nf.it-codigo
                      AND item-caixa.fm-codigo  = ?
                      AND item-caixa.fm-cod-com = ?
                      AND item-caixa.sigla-emb  = volume-nf.sigla-emb NO-LOCK NO-ERROR.

                FIND FIRST embalag
                    WHERE embalag.sigla-emb = item-caixa.sigla-emb NO-LOCK NO-ERROR.

                IF NOT AVAILABLE embalag THEN DO:
                    FOR EACH embalag
                        WHERE embalag.embalagem BEGINS "EMB":U
                          AND embalag.emite-roman
                        BREAK BY embalag.volume:
                        FIND FIRST item-caixa
                            WHERE item-caixa.it-codigo  = volume-nf.it-codigo
                              AND item-caixa.fm-codigo  = ?
                              AND item-caixa.fm-cod-com = ?
                              AND item-caixa.sigla-emb  = volume-nf.sigla-emb NO-LOCK NO-ERROR.
                    END.
                END.
            END.

            IF AVAILABLE item-caixa THEN DO:
                IF tt-param.tipo-volume                     = 1 AND
                   volume-nf.qtde MODULO item-caixa.qt-item = 0 THEN NEXT.

                IF tt-param.tipo-volume                      = 2 AND
                   volume-nf.qtde MODULO item-caixa.qt-item <> 0 THEN NEXT.
            END.
        END.
        ELSE DO:
            FIND FIRST item-caixa
                WHERE item-caixa.it-codigo  = volume-nf.it-codigo
                  AND item-caixa.fm-codigo  = ?
                  AND item-caixa.fm-cod-com = ?
                  AND item-caixa.sigla-emb  = volume-nf.sigla-emb NO-LOCK NO-ERROR.

            IF AVAILABLE item-caixa THEN DO:
                IF tt-param.tipo-volume                     = 1 AND
                   volume-nf.qtde MODULO item-caixa.qt-item = 0 THEN NEXT.

                IF tt-param.tipo-volume                      = 2 AND
                   volume-nf.qtde MODULO item-caixa.qt-item <> 0 THEN NEXT.
            END.
            IF tt-param.tipo-volume = 2 AND
               NOT AVAIL item-caixa THEN NEXT.
        END.
    END.

    IF tt-param.notas-desconsiderar <> "" THEN DO:
        FIND tt-nota-des
             WHERE int(tt-nota-des.c-cod-nota-des-ini) <= INT(nota-fiscal.nr-nota-fis)
               AND int(tt-nota-des.c-cod-nota-des-fim) >= INT(nota-fiscal.nr-nota-fis)
             NO-LOCK NO-ERROR.
        IF AVAIL tt-nota-des THEN NEXT.
     END.
     

          {esinc/es0004.i} /*ValidaNaturezasImpressÆoNFs*/

          {esinc/es0007.i} /*Valida Centro de Custo Cliente Diferenciado*/


          /* ASSIGN contRP1 = contRP1 + 1. */



              IF NOT Achou-Cli-Dif THEN DO: 
                 NEXT.
              END.

              ASSIGN Achou-Cli-Dif = NO.




          IF tt-param.l-estado THEN 
                IF NOT CAN-FIND(tt-estado WHERE tt-estado.estado = nota-fiscal.estado) THEN NEXT.
                
                ASSIGN lSepara-mg = (nota-fiscal.estado = 'MG' AND
                                     CAN-FIND(FIRST it-nota-fisc OF nota-fiscal
                                         WHERE it-nota-fisc.class-fiscal = '85171100'
                                            OR it-nota-fisc.class-fiscal = '85171999')).
                
                IF tt-param.notas-mg = 1 AND NOT lSepara-mg THEN NEXT.
                IF tt-param.notas-mg = 2 AND     lSepara-mg THEN NEXT.
                

                /*
                IF contRP1 >= 3 THEN 
                   NEXT.
                */
              

                {esp/ftp/esftp004rp5.i} 





