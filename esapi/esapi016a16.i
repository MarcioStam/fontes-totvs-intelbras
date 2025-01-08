DO i-cont = 1 TO p-qtd-etiquetas:
    FOR FIRST item-dun NO-LOCK
        WHERE item-dun.it-codigo = p-it-codigo
        AND   item-dun.qtd-emb   = p-qtd-embalagem:

        /*Coluna 1*/
        IF iColuna = 1 THEN DO:
            PUT "^XA" SKIP.

            PUT UNFORMATTED "^FO36,45^BY3,^BCN,45,Y,N ^FD>;" STRING(item-dun.cod-dun) "^FS" SKIP. /* Codigo de Barras DUN14 */
            
            PUT UNFORMATTED "^FO18,130^A0,25,25^FD" STRING(TODAY,"99/99/99") "^FS" SKIP. /* Imprime Data Vertical */
            PUT UNFORMATTED "^FO240,130^A0N,30,20^FDCONTêM:" string(item-dun.qtd-emb) "^FS" SKIP.    /* Quantidade */
            
            IF item-ean.destaque = "" THEN DO:
                PUT UNFORMATTED "^FO30,170^A0N,24,24^FB320,1,0,C^FD" CAPS(item-ean.linha[1]) "^FS" SKIP.    /* Imprime descricao Equipto */
                PUT UNFORMATTED "^FO30,220^A0N,24,24^FB320,1,0,C^FD" CAPS(item-ean.linha[2]) "^FS" SKIP.    /* Imprime descricao Equipto */
                PUT UNFORMATTED "^LRY^FO20,160^GB370,0,100^FS^LRN" SKIP.  /* Quadro preto */
            END.
            ELSE DO:
                PUT UNFORMATTED "^FO30,170^A0N,24,24^FB320,1,0,C^FD" CAPS(item-ean.linha[1]) "^FS" SKIP.    /* Imprime descricao Equipto */
                PUT UNFORMATTED "^FO30,220^A0N,24,24^FB320,1,0,C^FD" CAPS(item-ean.linha[2]) "^FS" SKIP.    /* Imprime descricao Equipto */
                PUT UNFORMATTED "^LRY^FO10,160^GB340,0,100^FS^LRN" SKIP.  /* Quadro preto */

                IF item-ean.destaque = "CHA" THEN DO:
                    RUN piCargaImagem("local-chave").
                    //PUT UNFORMATTED "^FR^FO290,155^XGlocal-chave.GRF^FS" SKIP. 
                    PUT UNFORMATTED "^FR^FO336,165^XGlocal-chave.GRF^FS" SKIP. 
                END.
                ELSE
              /*      PUT UNFORMATTED "^FO505,190,^A0B,42,34^FD" CAPS(item-ean.destaque) "^FS" SKIP.    /* Imprime descricao Equipto */ 
                PUT UNFORMATTED "^LRY^FO490,170^GB60,100,40^FS^LRN" SKIP.  /* Quadro preto destaque */ */
                    PUT UNFORMATTED "^FO360,170,^A0B,42,34^FD" CAPS(item-ean.destaque) "^FS" SKIP.    /* Imprime descricao Equipto */
              
                PUT UNFORMATTED "^LRY^FO355,160^GB20,100,40^FS^LRN" SKIP.  /* Quadro preto destaque */
            END.
            
            PUT UNFORMATTED "^FO18,280^A0,25,25^FD" "PO:" STRING(p-num-po) "^FS" SKIP. /* Num OP */
            PUT UNFORMATTED "^FO270,270^A0,40,35^FD" item-ean.it-codigo "^FS" SKIP. /* Imprime c´digo do item */

            IF i-cont = p-qtd-etiquetas THEN
                PUT UNFORMATTED "^XZ".
            ASSIGN iColuna = 2.
        END.
        /*fim Coluna 1*/
        ELSE DO:
            /*Coluna 2*/
            PUT UNFORMATTED "^FO456,45^BY3,^BCN,45,Y,N ^FD>;" STRING(item-dun.cod-dun) "^FS" SKIP. /* Codigo de Barras DUN14 */

            PUT UNFORMATTED "^FO450,135^A0,25,25^FD" STRING(TODAY,"99/99/99") "^FS" SKIP. /* Imprime Data Vertical */
            PUT UNFORMATTED "^FO670,135^A0N,30,20^FDCONTêM:" string(item-dun.qtd-emb) "^FS" SKIP. /* Quantidade */
    
            IF item-ean.destaque = "" THEN DO:
                PUT UNFORMATTED "^FO460,170^A0N,24,24^FB320,1,0,C^FD" CAPS(item-ean.linha[1]) "^FS" SKIP.    /* Imprime descricao Equipto */
                PUT UNFORMATTED "^FO460,220^A0N,24,24^FB320,1,0,C^FD" CAPS(item-ean.linha[2]) "^FS" SKIP.    /* Imprime descricao Equipto */
                PUT UNFORMATTED "^LRY^FO445,160^GB370,0,100^FS^LRN" SKIP.  /* Quadro preto */
            END.
            ELSE DO:
                PUT UNFORMATTED "^FO460,170^A0N,24,24^FB320,1,0,C^FD" CAPS(item-ean.linha[1]) "^FS" SKIP.    /* Imprime descricao Equipto */
                PUT UNFORMATTED "^FO460,220^A0N,24,24^FB320,1,0,C^FD" CAPS(item-ean.linha[2]) "^FS" SKIP.    /* Imprime descricao Equipto */
                PUT UNFORMATTED "^LRY^FO432,160^GB340,0,100^FS^LRN" SKIP.  /* Quadro preto */
            
                IF item-ean.destaque = "CHA" THEN DO:
                    RUN piCargaImagem("local-chave").
                    //PUT UNFORMATTED "^FR^FO715,155^XGlocal-chave.GRF^FS" SKIP.
                    PUT UNFORMATTED "^FR^FO758,165^XGlocal-chave.GRF^FS" SKIP. 
                END.
                ELSE
                    PUT UNFORMATTED "^FO780,170,^A0B,42,34^FD" CAPS(item-ean.destaque) "^FS" SKIP.    /* Imprime descricao Equipto */ 
            
                PUT UNFORMATTED "^LRY^FO777,160^GB20,100,40^FS^LRN" SKIP.  /* Quadro preto destaque */
            END.
            
            PUT UNFORMATTED "^FO450,280^A0,25,25^FD" "PO:" STRING(p-num-po) "^FS" SKIP. /* Num OP */
            PUT UNFORMATTED "^FO690,270^A0,40,35^FD" item-ean.it-codigo "^FS" SKIP /* Imprime c´digo do item */
            
                            "^XZ".    
            ASSIGN iColuna = 1.
        END.
        /*fim Coluna 2*/
    END.

    PUT UNFORMATTED
         "^PQ" STRING(1, "99999") SKIP  /* Repetiá‰es */.
END. 
