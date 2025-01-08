/*------------------------------------------------------------------------------
  Purpose:    Etiqueta item ean13 e NS (50x34mm)
  Parameters:  <none>
  Notes:      Carlos Daniel - 07/10/2015
------------------------------------------------------------------------------*/
/* PUT UNFORMATTED "^FO25,35^A0B,14,14^FD" item-ean.origem "^FS" SKIP. /* Imprime Origem Vertical */ */
PUT UNFORMATTED "^FO15,22^A0B,16,16^FD" STRING(num-serie.data,"99/99/99") "^FS" SKIP. /* Imprime Data Vertical */
PUT UNFORMATTED "^FO70,22^BY3^BEN,65,Y,N^FD" string(item-mat.cod-ean, "9(13)") "^FS" SKIP.  /* Codigo de Barras EAN 13 */
PUT UNFORMATTED "^FO365,22^A0B,22,22^FD" item-ean.it-codigo "^FS" SKIP. /* Imprime c«digo do item */

IF item-ean.destaque = "" THEN DO:
    PUT UNFORMATTED "^FO10,133^A0N,24,24^FB368,1,0,C^FD" CAPS(item-ean.linha[1]) "^FS" SKIP.    /* Imprime descricao Equipto */
    PUT UNFORMATTED "^FO10,161^A0N,24,24^FB368,1,0,C^FD" CAPS(item-ean.linha[2]) "^FS" SKIP.    /* Imprime descricao Equipto */
/*     PUT UNFORMATTED "^LRY^FO15,123^GB368,65,65^FS^LRN" SKIP.  /* Quadro preto */ */
END.
ELSE DO:
    PUT UNFORMATTED "^FO10,133^A0N,24,24^FB315,1,0,C^FD" CAPS(item-ean.linha[1]) "^FS" SKIP.    /* Imprime descricao Equipto */
    PUT UNFORMATTED "^FO10,161^A0N,24,24^FB315,1,0,C^FD" CAPS(item-ean.linha[2]) "^FS" SKIP.    /* Imprime descricao Equipto */
/*     PUT UNFORMATTED "^LRY^FO15,123^GB315,65,65^FS^LRN" SKIP.  /* Quadro preto */ */

    IF item-ean.destaque = "CHA" THEN DO:
        RUN piCargaImagem("local-chaveM").
        PUT UNFORMATTED "^FO323,123^XGlocal-chaveM.GRF^FS" SKIP.
    END.
    ELSE
        PUT UNFORMATTED "^FO347,138,^A0B,24,24^FD" CAPS(item-ean.destaque) "^FS" SKIP.    /* Imprime descricao Equipto */

/*     PUT UNFORMATTED "^LRY^FO337,123^GB40,65,20^FS^LRN" SKIP.  /* Quadro preto destaque */ */
END.

PUT UNFORMATTED "^FO20,196^BY2^BCN,24,N,N,N,N^FD" num-serie.n-serie "^FS" SKIP.  /* Codigo de Barras EAN 128 */
PUT UNFORMATTED "^FO20,226^A0N,18,18^FB368,1,0,C^FDNS:" num-serie.n-serie "^FS" SKIP. /* Valor do Codigo de Barras EAN128 */
PUT UNFORMATTED "^FO335,226^A0N,24,24^FB50,1,0,R^FD" num-serie.sigla "^FS" SKIP. /* Sigla */
