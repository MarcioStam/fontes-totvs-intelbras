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

            /*
            PUT UNFORMATTED "^FO50,35^BY3,^BCB,60,Y,N ^FD>;" STRING(item-dun.cod-dun) "^FS"          SKIP. /* Codigo de Barras DUN14 */
            PUT UNFORMATTED "^FO145,355^A0N,25,25^FD" item-ean.it-codigo "^FS"                       SKIP. /* Imprime c«digo do item */
            PUT UNFORMATTED "^FO145,20^A0N,25,25^FD" STRING(TODAY,"99/99/99") "^FS"                  SKIP. /* Imprime Data Vertical */

            PUT UNFORMATTED "^FO153,20^A0B,40,18^FB370,1,0,C^FD" CAPS(item-ean.linha[1]) "^FS"        SKIP.    /* Imprime descricao Equipto */
            PUT UNFORMATTED "^FO189,20^A0B,40,18^FB370,1,0,C^FD" CAPS(item-ean.linha[2]) "^FS"        SKIP.    /* Imprime descricao Equipto */

            PUT UNFORMATTED "^FO145,50^FR^GB70,300,80^FS"                                           SKIP.  /* Quadro preto */
            PUT UNFORMATTED "^FO370,350^A0N,30,30^FB155,1,0,R^FDQtd. " string(item-dun.qtd-emb) "^FS" SKIP.    /* Quantidade */
            */

            PUT UNFORMATTED "^FO40,35^BY3,^BCB,60,Y,N ^FD>;" STRING(item-dun.cod-dun) "^FS"          SKIP. /* Codigo de Barras DUN14 */
            PUT UNFORMATTED "^FO130,355^A0N,25,25^FD" item-ean.it-codigo "^FS"                       SKIP. /* Imprime c«digo do item */
            PUT UNFORMATTED "^FO130,20^A0N,25,25^FD" STRING(TODAY,"99/99/99") "^FS"                  SKIP. /* Imprime Data Vertical */
            
            PUT UNFORMATTED "^FO140,20^A0B,40,18^FB370,1,0,C^FD" CAPS(item-ean.linha[1]) "^FS"        SKIP.    /* Imprime descricao Equipto */
            PUT UNFORMATTED "^FO175,20^A0B,40,18^FB370,1,0,C^FD" CAPS(item-ean.linha[2]) "^FS"        SKIP.    /* Imprime descricao Equipto */
            
            PUT UNFORMATTED "^FO130,50^FR^GB70,300,80^FS"                                           SKIP.  /* Quadro preto */
            PUT UNFORMATTED "^FO360,350^A0N,30,30^FB155,1,0,R^FDQtd. " string(item-dun.qtd-emb) "^FS" SKIP.    /* Quantidade */

        END.

    END.
END.

//Numeros de Serie
ASSIGN i-linha = 210.

FOR EACH ns-volume WHERE
         ns-volume.volume-pai = c-etiqueta
         NO-LOCK.

    FIND FIRST num-serie WHERE
               num-serie.n-serie = ns-volume.volume-filho
               NO-LOCK NO-ERROR.

    IF AVAIL num-serie THEN DO:
        
        PUT UNFORMATTED "^FO" STRING(i-linha + 5) ",120^BY1^BCB,30,N,N,N,N^FD" num-serie.n-serie "^FS"               SKIP.  /* Codigo de Barras EAN 128 */
        PUT UNFORMATTED "^FO" STRING(i-linha + 40) ",20^A0B,20,20^FB365,1,0,C^FDNS:" STRING(num-serie.n-serie) "^FS" SKIP.

        ASSIGN i-conta = 1
               i-linha = i-linha + 60. //Distancia entre NS
        
    END.
END.

PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
PUT "^XZ" SKIP.
