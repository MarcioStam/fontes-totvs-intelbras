/*------------------------------------------------------------------------------
  Purpose:    Etiqueta item ean13 e NS (50x34mm)
  Parameters:  <none>
  Notes:      Carlos Daniel - 07/10/2015
------------------------------------------------------------------------------*/
/* PUT UNFORMATTED "^FO25,35^A0B,14,14^FD" item-ean.origem "^FS" SKIP. /* Imprime Origem Vertical */ */
PUT UNFORMATTED "^FO25,35^A0B,16,16^FD" STRING(num-serie.data,"99/99/99") "^FS" SKIP. /* Imprime Data Vertical */
PUT UNFORMATTED "^FO80,35^BY3^BEN,65,Y,N^FD" string(item-mat.cod-ean, "9(13)") "^FS" SKIP.  /* Codigo de Barras EAN 13 */
PUT UNFORMATTED "^FO375,35^A0B,22,22^FD" item-ean.it-codigo "^FS" SKIP. /* Imprime c«digo do item */

IF item-ean.destaque = "" THEN DO:
/*     PUT UNFORMATTED "^FO20,150^A0N,32,24^FB368,1,0,C^FD" CAPS(item-ean.linha[1]) "^FS" SKIP.    /* Imprime descricao Equipto */ */
/*     PUT UNFORMATTED "^FO20,185^A0N,32,24^FB368,1,0,C^FD" CAPS(item-ean.linha[2]) "^FS" SKIP.    /* Imprime descricao Equipto */ */
    PUT UNFORMATTED "^FO20,140^A0N,28,20^FB368,1,0,C^FD" CAPS(item-ean.linha[1]) "^FS" SKIP.    /* Imprime descricao Equipto */
    PUT UNFORMATTED "^FO20,170^A0N,28,20^FB368,1,0,C^FD" CAPS(item-ean.linha[2]) "^FS" SKIP.    /* Imprime descricao Equipto */
/*     PUT UNFORMATTED "^LRY^FO25,140^GB368,0,80^FS^LRN" SKIP.  /* Quadro preto */ */
END.
ELSE DO:
/*     PUT UNFORMATTED "^FO20,150^A0N,32,24^FB315,1,0,C^FD" CAPS(item-ean.linha[1]) "^FS" SKIP.    Imprime descricao Equipto */
/*     PUT UNFORMATTED "^FO20,185^A0N,32,24^FB315,1,0,C^FD" CAPS(item-ean.linha[2]) "^FS" SKIP.    Imprime descricao Equipto */
    PUT UNFORMATTED "^FO20,140^A0N,28,20^FB315,1,0,C^FD" CAPS(item-ean.linha[1]) "^FS" SKIP.    /* Imprime descricao Equipto */
    PUT UNFORMATTED "^FO20,170^A0N,28,20^FB315,1,0,C^FD" CAPS(item-ean.linha[2]) "^FS" SKIP.    /* Imprime descricao Equipto */
/*     PUT UNFORMATTED "^LRY^FO25,140^GB315,0,80^FS^LRN" SKIP.  /* Quadro preto */ */

    IF item-ean.destaque = "CHA" THEN DO:
/*         RUN piCargaImagem("local-chave"). */
/*         PUT UNFORMATTED "^FO328,135^XGlocal-chave.GRF^FS" SKIP. */
        RUN piCargaImagem("local-chaveTemp").
        PUT UNFORMATTED "^FO328,135^XGlocal-chaveTemp.GRF^FS" SKIP.
/*         PUT UNFORMATTED "^FO328,125^XGlocal-chave.GRF^FS" SKIP. */
    END.
    ELSE
        PUT UNFORMATTED "^FO355,152,^A0B,32,24^FD" CAPS(item-ean.destaque) "^FS" SKIP.    /* Imprime descricao Equipto */
/*         PUT UNFORMATTED "^FO355,162,^A0B,32,24^FD" CAPS(item-ean.destaque) "^FS" SKIP.    /* Imprime descricao Equipto */ */

/*     PUT UNFORMATTED "^LRY^FO347,140^GB40,80,20^FS^LRN" SKIP.  /* Quadro preto destaque */ */
END.

/* PUT UNFORMATTED "^FO30,225^BY2^BCN,24,N,N,N,N^FD" num-serie.n-serie "^FS" SKIP.  /* Codigo de Barras EAN 128 */ */
PUT UNFORMATTED "^FO30,200^BY2^BCN,50,N,N,N,N^FD" num-serie.n-serie "^FS" SKIP.  /* Codigo de Barras EAN 128 */
PUT UNFORMATTED "^FO30,255^A0N,18,18^FB368,1,0,C^FDNS:" num-serie.n-serie "^FS" SKIP. /* Valor do Codigo de Barras EAN128 */
PUT UNFORMATTED "^FO345,255^A0N,26,26^FB50,1,0,R^FD" num-serie.sigla "^FS" SKIP. /* Sigla */
