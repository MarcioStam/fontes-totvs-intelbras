/*------------------------------------------------------------------------------
  Purpose:    Etiqueta item ean13 e NS (50x34mm)
  Notes:      Carlos Daniel - 25/07/2016
------------------------------------------------------------------------------*/
/*------------------------------------------------------------------------------
  Purpose:    Etiqueta item ean13 e NS (50x34mm)
  Notes:      Carlos Daniel - 25/07/2016
------------------------------------------------------------------------------*/
IF p-cod-modelo = 630 THEN 
   PUT UNFORMATTED "^FO120,100,1^A0B,50,60^FD" STRING(TODAY, "99/99/99") "^FS" SKIP. /* Imprime Data Vertical */
ELSE
   PUT UNFORMATTED "^FO120,100,1^A0B,50,60^FD" STRING(num-serie.data, "99/99/99") "^FS" SKIP. /* Imprime Data Vertical */

PUT UNFORMATTED "^FO225,100^BY9^BEN,165,Y,N^FD" string(item-mat.cod-ean, "9(13)") "^FS" SKIP.  /* Codigo de Barras EAN 13 */
PUT UNFORMATTED "^FO1190,100,1^A0B,70,70^FD" item-ean.it-codigo "^FS" SKIP. /* Sigla */


IF item-ean.destaque = "" THEN DO:
    PUT UNFORMATTED "^FO80,370^A0N,108,78^FB1090,1,0,C^FD" CAPS(item-ean.linha[1]) "^FS" SKIP.    /* Imprime descricao Equipto */
    PUT UNFORMATTED "^FO80,480^A0N,108,78^FB1090,1,0,C^FD" CAPS(item-ean.linha[2]) "^FS" SKIP.    /* Imprime descricao Equipto */
    PUT UNFORMATTED "^LRY^FO80,345^GB1090,0,240^FS^LRN" SKIP.  /* Quadro preto */
END.
ELSE DO:
    PUT UNFORMATTED "^FO80,390^A0N,88,78^FB1090,1,0,C^FD" CAPS(item-ean.linha[1]) "^FS" SKIP.    /* Imprime descricao Equipto */
    PUT UNFORMATTED "^FO80,500^A0N,88,78^FB1090,1,0,C^FD" CAPS(item-ean.linha[2]) "^FS" SKIP.    /* Imprime descricao Equipto */
    PUT UNFORMATTED "^LRY^FO80,345^GB1090,0,240^FS^LRN" SKIP.  /* Quadro preto */

    IF item-ean.destaque = "CHA" THEN DO:
        RUN piCargaImagem("local-chave").
        PUT UNFORMATTED "^FO306,117^XGlocal-chave.GRF^FS" SKIP.
    END.
    ELSE
        PUT UNFORMATTED "^FO333,144,^A0B,32,24^FD" CAPS(item-ean.destaque) "^FS" SKIP.    /* Imprime descricao Equipto */ 

    PUT UNFORMATTED "^LRY^FO325,122^GB40,80,20^FS^LRN" SKIP.  /* Quadro preto destaque */
END.

PUT UNFORMATTED "^FO90,620^BY6^BCN,84,N,N,N,N^FD" num-serie.n-serie "^FS" SKIP.  /* Codigo de Barras EAN 128 */
PUT UNFORMATTED "^FO05,740^ADN,54,25^FB978^FB1260,1,0,C^FDNS:" num-serie.n-serie "^FS" SKIP.
PUT UNFORMATTED "^FO1060,740^A0N,76,76^FB100,1,0,R^FD" num-serie.sigla "^FS" SKIP. /* Sigla */

/* PUT UNFORMATTED "^FO130,80,1^A0B,40,40^FD" STRING(num-serie.data, "99/99/9999") "^FS" SKIP. /* Imprime Data Vertical */            */
/* PUT UNFORMATTED "^FO260,80^BY9^BEN,165,Y,N^FD" string(item-mat.cod-ean, "9(13)") "^FS" SKIP.  /* Codigo de Barras EAN 13 */        */
/* PUT UNFORMATTED "^FO1210,80,1^A0B,70,70^FD" item-ean.it-codigo "^FS" SKIP. /* Sigla */                                             */
/*                                                                                                                                    */
/*                                                                                                                                    */
/* IF item-ean.destaque = "" THEN DO:                                                                                                 */
/*     PUT UNFORMATTED "^FO100,370^A0N,88,78^FB1090,1,0,C^FD" CAPS(item-ean.linha[1]) "^FS" SKIP.    /* Imprime descricao Equipto */  */
/*     PUT UNFORMATTED "^FO100,480^A0N,88,78^FB1090,1,0,C^FD" CAPS(item-ean.linha[2]) "^FS" SKIP.    /* Imprime descricao Equipto */  */
/*     PUT UNFORMATTED "^LRY^FO100,345^GB1090,0,240^FS^LRN" SKIP.  /* Quadro preto */                                                 */
/* END.                                                                                                                               */
/* ELSE DO:                                                                                                                           */
/*     PUT UNFORMATTED "^FO100,370^A0N,88,78^FB1090,1,0,C^FD" CAPS(item-ean.linha[1]) "^FS" SKIP.    /* Imprime descricao Equipto */  */
/*     PUT UNFORMATTED "^FO100,480^A0N,88,78^FB1090,1,0,C^FD" CAPS(item-ean.linha[2]) "^FS" SKIP.    /* Imprime descricao Equipto */  */
/*     PUT UNFORMATTED "^LRY^FO100,345^GB1090,0,240^FS^LRN" SKIP.  /* Quadro preto */                                                 */
/*                                                                                                                                    */
/*     IF item-ean.destaque = "CHA" THEN DO:                                                                                          */
/*         RUN piCargaImagem("local-chave").                                                                                          */
/*         PUT UNFORMATTED "^FO326,117^XGlocal-chave.GRF^FS" SKIP.                                                                    */
/*     END.                                                                                                                           */
/*     ELSE                                                                                                                           */
/*         PUT UNFORMATTED "^FO353,144,^A0B,32,24^FD" CAPS(item-ean.destaque) "^FS" SKIP.    /* Imprime descricao Equipto */          */
/*                                                                                                                                    */
/*     PUT UNFORMATTED "^LRY^FO345,122^GB40,80,20^FS^LRN" SKIP.  /* Quadro preto destaque */                                          */
/* END.                                                                                                                               */
/*                                                                                                                                    */
/* PUT UNFORMATTED "^FO110,600^BY6^BCN,84,N,N,N,N^FD" num-serie.n-serie "^FS" SKIP.  /* Codigo de Barras EAN 128 */                   */
/* PUT UNFORMATTED "^FO10,720^ADN,54,25^FB978^FB1260,1,0,C^FDNS:" num-serie.n-serie "^FS" SKIP.                                       */
/* PUT UNFORMATTED "^FO1080,720^A0N,76,76^FB100,1,0,R^FD" num-serie.sigla "^FS" SKIP. /* Sigla */                                     */
/*                                                                                                                                    */
