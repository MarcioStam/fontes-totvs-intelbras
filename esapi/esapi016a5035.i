/*------------------------------------------------------------------------------
  Purpose:    Etiqueta item ean13 e NS (50x34mm)
  Notes:      Carlos Daniel - 25/07/2016
------------------------------------------------------------------------------*/
PUT UNFORMATTED "^FO23,32^A0B,16,16^FD" STRING(num-serie.data,"99/99/99") "^FS" SKIP. /* Imprime Data Vertical */
PUT UNFORMATTED "^FO78,32^BY3^BEN,50,Y,N^FD" string(item-mat.cod-ean, "9(13)") "^FS" SKIP.  /* Codigo de Barras EAN 13 */
PUT UNFORMATTED "^FO373,32^A0B,22,22^FD" item-ean.it-codigo "^FS" SKIP. /* Imprime c«digo do item */

IF item-ean.destaque = "" THEN DO:
    PUT UNFORMATTED "^FO18,113^A0N,26,22^FB368,1,0,C^FD" CAPS(item-ean.linha[1]) "^FS" SKIP.    /* Imprime descricao Equipto */
    PUT UNFORMATTED "^FO18,134^A0N,26,22^FB368,1,0,C^FD" CAPS(item-ean.linha[2]) "^FS" SKIP.    /* Imprime descricao Equipto */
    PUT UNFORMATTED "^LRY^FO23,110^GB368,0,48^FS^LRN" SKIP.  /* Quadro preto */

    FIND FIRST num-serie-vinc WHERE
               num-serie-vinc.n-serie = num-serie.n-serie
               NO-LOCK.

    IF AVAIL num-serie-vinc 
    THEN DO:
        PUT UNFORMATTED "^FO28,160^BY2^BCN,24,N,N,N,N^FD" num-serie-vinc.n-serie-vinc "^FS"       SKIP.
        PUT UNFORMATTED "^FO28,188^ADN,18,10^FB368,1,0,C^FDNS:" num-serie-vinc.n-serie-vinc "^FS" SKIP.
    END.
END.
ELSE DO:
/*
    PUT UNFORMATTED "^FO18,132^A0N,32,24^FB315,1,0,C^FD" CAPS(item-ean.linha[1]) "^FS" SKIP.    /* Imprime descricao Equipto */
    PUT UNFORMATTED "^FO18,167^A0N,32,24^FB315,1,0,C^FD" CAPS(item-ean.linha[2]) "^FS" SKIP.    /* Imprime descricao Equipto */
    PUT UNFORMATTED "^LRY^FO23,122^GB315,0,80^FS^LRN" SKIP.  /* Quadro preto */

    IF item-ean.destaque = "CHA" THEN DO:
        RUN piCargaImagem("local-chave").
        PUT UNFORMATTED "^FO326,117^XGlocal-chave.GRF^FS" SKIP.
    END.
    ELSE
        PUT UNFORMATTED "^FO353,144,^A0B,32,24^FD" CAPS(item-ean.destaque) "^FS" SKIP.    /* Imprime descricao Equipto */ 

    PUT UNFORMATTED "^FO353,144,^A0B,32,24^FD" CAPS(item-ean.destaque) "^FS" SKIP.

    PUT UNFORMATTED "^LRY^FO345,122^GB40,60,20^FS^LRN" SKIP.  /* Quadro preto destaque */
    */
END.

PUT UNFORMATTED "^FO28,207^BY2^BCN,24,N,N,N,N^FD" num-serie.n-serie "^FS" SKIP.  /* Codigo de Barras EAN 128 */
PUT UNFORMATTED "^FO28,237^ADN,18,10^FB368,1,0,C^FDNS:" num-serie.n-serie "^FS" SKIP. /* Valor do Codigo de Barras EAN128 */
PUT UNFORMATTED "^FO343,237^A0N,26,26^FB50,1,0,R^FD" num-serie.sigla "^FS" SKIP. /* Sigla */
