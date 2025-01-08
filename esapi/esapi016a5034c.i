/*------------------------------------------------------------------------------
  Purpose:    Etiqueta item ean13 e NS (50x34mm)
  Notes:      Carlos Daniel - 25/07/2016
------------------------------------------------------------------------------*/
IF (p-cod-modelo = 160 OR
    p-cod-modelo = 170)
THEN PUT UNFORMATTED "^FO23,32^A0B,16,16^FD" STRING(TODAY,"99/99/99") "^FS" SKIP. /* Imprime Data Vertical */
ELSE PUT UNFORMATTED "^FO23,32^A0B,16,16^FD" STRING(num-serie.data,"99/99/99") "^FS" SKIP. /* Imprime Data Vertical */

PUT UNFORMATTED "^FO78,32^BY3^BEN,50,Y,N^FD" string(item-mat.cod-ean, "9(13)") "^FS" SKIP.  /* Codigo de Barras EAN 13 */
PUT UNFORMATTED "^FO373,32^A0B,22,22^FD" item-ean.it-codigo "^FS" SKIP. /* Imprime c«digo do item */

IF item-ean.destaque = "" THEN DO:
    PUT UNFORMATTED "^FO18,122^A0N,32,24^FB368,1,0,C^FD" CAPS(item-ean.linha[1]) "^FS" SKIP.    /* Imprime descricao Equipto */
    PUT UNFORMATTED "^FO18,150^A0N,32,24^FB368,1,0,C^FD" CAPS(item-ean.linha[2]) "^FS" SKIP.    /* Imprime descricao Equipto */
    PUT UNFORMATTED "^LRY^FO23,114^GB368,0,70^FS^LRN" SKIP.  /* Quadro preto */
END.
ELSE DO:
    PUT UNFORMATTED "^FO18,122^A0N,32,24^FB315,1,0,C^FD" CAPS(item-ean.linha[1]) "^FS" SKIP.    /* Imprime descricao Equipto */
    PUT UNFORMATTED "^FO18,150^A0N,32,24^FB315,1,0,C^FD" CAPS(item-ean.linha[2]) "^FS" SKIP.    /* Imprime descricao Equipto */
    PUT UNFORMATTED "^LRY^FO23,114^GB315,0,70^FS^LRN" SKIP.  /* Quadro preto */

    IF item-ean.destaque = "CHA" THEN DO:
        RUN piCargaImagem("local-chave").
        PUT UNFORMATTED "^FO326,117^XGlocal-chave.GRF^FS" SKIP.
    END.
    ELSE
        PUT UNFORMATTED "^FO353,127,^A0B,32,23^FD" CAPS(item-ean.destaque) "^FS" SKIP.    /* Imprime descricao Equipto */ 

    PUT UNFORMATTED "^LRY^FO345,114^GB40,70,20^FS^LRN" SKIP.  /* Quadro preto destaque */
END.

PUT UNFORMATTED "^FO28,187^BY2^BCN,24,N,N,N,N^FD" num-serie.n-serie "^FS" SKIP.  /* Codigo de Barras EAN 128 */
PUT UNFORMATTED "^FO28,213^ADN,18,10^FB368,1,0,C^FDNS:" num-serie.n-serie "^FS" SKIP. /* Valor do Codigo de Barras EAN128 */


PUT UNFORMATTED "^FO343,232^A0N,26,26^FB50,1,0,R^FD" num-serie.sigla "^FS" SKIP. /* Sigla */
PUT UNFORMATTED "^FO30,232^A0N,26,26^FDOP:" STRING(p-num-po) "^FS" SKIP.
