PUT "^XA"         SKIP.   /* Inicio Label */
PUT "^PW832"      SKIP.   /* Width 832 */
PUT "^MNY"        SKIP.   /* Papel de etiquetas nÆo continuo */
PUT "^MTT"        SKIP.   /* Papel Comum - usa ribon */
PUT "^BY2"        SKIP.   /* Magnitude EAN */ 
PUT "^PRA"        SKIP.   /* Velocidade 50mm/seg */
PUT "^JUS"        SKIP.   /* Grava Configuracao */
PUT "^XZ"         SKIP.

//Aqui BLOCO
PUT "^XA" SKIP.

FIND FIRST ns-volume WHERE
           ns-volume.volume-pai = c-etiqueta
           NO-LOCK NO-ERROR.

IF AVAIL ns-volume  
THEN DO:

    FIND FIRST num-serie WHERE
               num-serie.n-serie = ns-volume.volume-filho
               NO-LOCK NO-ERROR.

    IF AVAIL num-serie 
    THEN DO:

        FIND FIRST item-ean WHERE
                   item-ean.it-codigo = num-serie.it-codigo
                   NO-LOCK NO-ERROR.
        //Dun 14
        FOR FIRST item-dun NO-LOCK
            WHERE item-dun.it-codigo = num-serie.it-codigo
            AND   item-dun.qtd-emb   = INT(SUBSTRING(c-etiqueta,4,3)): //10 teste

            PUT UNFORMATTED "^FO50,35^BY3,^BCN,100,Y,N ^FD>;" STRING(item-dun.cod-dun) "^FS"          SKIP. /* Codigo de Barras DUN14 */
            PUT UNFORMATTED "^FO60,280^A0N,40,30^FD" item-ean.it-codigo "^FS"                         SKIP. /* Imprime c«digo do item */
            PUT UNFORMATTED "^FO500,280^A0N,40,30^FD" STRING(TODAY,"99/99/99") "^FS"                  SKIP. /* Imprime Data Vertical */

            PUT UNFORMATTED "^FO40,180^A0N,35,25^FB370,1,0,C^FD" CAPS(item-ean.linha[1]) "^FS"        SKIP.    /* Imprime descricao Equipto */
            PUT UNFORMATTED "^FO40,230^A0N,35,25^FB370,1,0,C^FD" CAPS(item-ean.linha[2]) "^FS"        SKIP.    /* Imprime descricao Equipto */
            PUT UNFORMATTED "^LRY^FO40,170^GB360,0,100^FS^LRN"                                        SKIP.  /* Quadro preto */
            PUT UNFORMATTED "^FO240,280^A0N,40,32^FB155,1,0,R^FDQtd. " string(item-dun.qtd-emb) "^FS" SKIP.    /* Quantidade */
        END.

        //ECO
        PUT UNFORMATTED "^BY1" SKIP.
        PUT UNFORMATTED "^FO450,100^BCN,136,N,N,N,N^SN" c-etiqueta ",1,Y^FS"                          SKIP.
        PUT UNFORMATTED "^FO450,250^A0N,32,28^FB365,1,0,L^FD" c-etiqueta "^FS"                        SKIP.
        PUT UNFORMATTED "^FO460,50^A0N,40,30^FDCAIXA - " SUBSTRING(c-etiqueta,4,3) "^FS"              SKIP.
        PUT UNFORMATTED "^LRY^FO450,40^GB190,0,50^FS^LRN"                                             SKIP.

    END.
END.

//Numeros de Serie
ASSIGN i-conta = 1
       i-linha = 350.

FOR EACH ns-volume WHERE
         ns-volume.volume-pai = c-etiqueta
         NO-LOCK.

    FIND FIRST num-serie WHERE
               num-serie.n-serie = ns-volume.volume-filho
               NO-LOCK NO-ERROR.

    IF AVAIL num-serie 
    THEN DO:
        //Coluna Esquerda
        IF i-conta = 1 
        THEN DO:
            
            PUT UNFORMATTED "^FO80," STRING(i-linha + 5)  "^BY1^BCN,40,N,N,N,N^FD" num-serie.n-serie "^FS"               SKIP.  /* Codigo de Barras EAN 128 */
            PUT UNFORMATTED "^FO90," STRING(i-linha + 50) "^A0N,20,20^FB365,1,0,L^FDNS:" STRING(num-serie.n-serie) "^FS" SKIP.

            ASSIGN i-conta = 2.
        END.
        ELSE DO: //Coluna Direita

            PUT UNFORMATTED "^FO400," STRING(i-linha + 5)  "^BY1^BCN,40,N,N,N,N^FD" num-serie.n-serie "^FS"               SKIP.  /* Codigo de Barras EAN 128 */
            PUT UNFORMATTED "^FO410," STRING(i-linha + 50) "^A0N,20,20^FB365,1,0,L^FDNS:" STRING(num-serie.n-serie) "^FS" SKIP.

            ASSIGN i-conta = 1
                   i-linha = i-linha + 80. //Distancia entre NS
        END.
    END.
END.

PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
PUT "^XZ" SKIP.
