/*------------------------------------------------------------------------------
  Purpose:    Etiqueta de Produto (34x21mm)
  Parameters:  <none>
  Notes:      Emerson Colla - 22/12/2016
  Parametro : 1-NÆo homologada, 2-Anatel, 3-Suframa
------------------------------------------------------------------------------*/
/* Modelo */
PUT UNFORMATTED "^FO1270,80^A0N,62,62^FB870,1,0,C^FD" CAPS(item-ean.nome-abrev) "^FS" SKIP.    /* Imprime modelo */
PUT UNFORMATTED "^LRY^FO1240,40^GB870,100,100^FS^LRN" SKIP.  /* Quadro preto */

/* Informa‡äes Item */
PUT UNFORMATTED "^FO1320,155^A0N,34,34^FD" item-ean.char-2 "^FS" SKIP.
PUT UNFORMATTED "^FO1280,155^A0N,34,34^FB760,1,0,R^FD" item-ean.origem "^FS" SKIP.
PUT UNFORMATTED "^FO1320,195^A0N,34,34^FB760,1,0,L^FDCNPJ: " c-cgc "^FS" SKIP.

IF p-cod-modelo = 630 THEN 
   PUT UNFORMATTED "^FO1280,195^A0N,34,34^FB760,1,0,R^FD" STRING(TODAY,"99/99/99") "^FS" SKIP.
ELSE
   PUT UNFORMATTED "^FO1280,195^A0N,34,34^FB760,1,0,R^FD" STRING(num-serie.data,"99/99/99") "^FS" SKIP.

PUT UNFORMATTED "^FO1320,235^A0N,34,34^FB760,1,0,L^FD" item-ean.fone "^FS" SKIP.

PUT UNFORMATTED "^FO1320,275^A0N,34,34^FB760,1,0,L^FD" item-ean.info-tec[1] "^FS" SKIP.
PUT UNFORMATTED "^FO1320,315^A0N,34,34^FB760,1,0,L^FD" item-ean.info-tec[2] "^FS" SKIP.

IF "{1}" = "1" THEN DO:
    /* N£mero S‚rie */
    PUT UNFORMATTED "^FO465,155^ABN^FB200,1,0,C^FDNS:" num-serie.n-serie "^FS" SKIP. /* Valor do Codigo de Barras EAN128 */ 
    PUT UNFORMATTED "^FO465,170^BY1^BCN,24,N,N,N,N^FD" num-serie.n-serie "^FS" SKIP.  /* Codigo de Barras EAN 128 */
END.
ELSE DO:
    /* N£mero S‚rie */
    /*PUT UNFORMATTED "^FO1320,380^ABN,35,17^FB760,1,0,L^FDNS:" num-serie.n-serie "^FS" SKIP. /* Valor do Codigo de Barras EAN128 */  */

    IF "{1}" <> '4' THEN DO:
       PUT UNFORMATTED "^FO1320,415^ADN,36,20^FB760,1,0,L^FDNS:" num-serie.n-serie "^FS" SKIP. /* Valor do Codigo de Barras EAN128 */
       PUT UNFORMATTED "^FO1320,455^BY2.5^BCN,74,N,N,N,N^FD" num-serie.n-serie "^FS" SKIP.  /* Codigo de Barras EAN 128 */
    END.
    ELSE DO:
       PUT UNFORMATTED "^FO1320,395^ADN,36,20^FB760,1,0,L^FDNS:" num-serie.n-serie "^FS" SKIP. /* Valor do Codigo de Barras EAN128 */
       PUT UNFORMATTED "^FO1320,435^BY2.5^BCN,74,N,N,N,N^FD" num-serie.n-serie "^FS" SKIP.  /* Codigo de Barras EAN 128 */
    END.


    IF "{1}" = "2" THEN DO:
        /* Anatel + Homologa‡Æo */
        //PUT UNFORMATTED "^FO605,55^XGlocal-anatelpp.GRF^FS" /* Impressao da Imagem ANATEL */ SKIP.
        PUT UNFORMATTED "^FO1280,400^A0N,30,30^FB760,1,0,R^FD" item-ean.homolog "^FS" SKIP.
    END.
    IF "{1}" = "3" OR "{1}" = '4' THEN DO:
        /* Suframa */
        /*PUT UNFORMATTED "^FO1750,200^XGlocal-suframa.GRF^FS" SKIP.*/
        PUT UNFORMATTED "^FO1740,235^XGselo-suframa.GRF^FS" SKIP.
    END.


END.

/* /* Modelo */                                                                                                                  */
/* PUT UNFORMATTED "^FO1280,35^A0N,62,62^FB820,1,0,C^FD" CAPS(item-ean.nome-abrev) "^FS" SKIP.    /* Imprime modelo */           */
/* PUT UNFORMATTED "^LRY^FO1280,10^GB820,90,90^FS^LRN" SKIP.  /* Quadro preto */                                                 */
/*                                                                                                                               */
/* /* Informa‡äes Item */                                                                                                        */
/* PUT UNFORMATTED "^FO1340,120^A0N,34,34^FD" item-ean.char-2 "^FS" SKIP.                                                        */
/* PUT UNFORMATTED "^FO1280,120^A0N,34,34^FB760,1,0,R^FD" item-ean.origem "^FS" SKIP.                                            */
/* PUT UNFORMATTED "^FO1340,160^A0N,34,34^FB760,1,0,L^FDCNPJ: " c-cgc "^FS" SKIP.                                                */
/* PUT UNFORMATTED "^FO1280,160^A0N,34,34^FB760,1,0,R^FD" STRING(num-serie.data,"99/99/99") "^FS" SKIP.                          */
/* PUT UNFORMATTED "^FO1340,200^A0N,34,34^FB760,1,0,L^FD" item-ean.fone "^FS" SKIP.                                              */
/*                                                                                                                               */
/* PUT UNFORMATTED "^FO1340,240^A0N,34,34^FB760,1,0,L^FD" item-ean.info-tec[1] "^FS" SKIP.                                       */
/* PUT UNFORMATTED "^FO1340,280^A0N,34,34^FB760,1,0,L^FD" item-ean.info-tec[2] "^FS" SKIP.                                       */
/*                                                                                                                               */
/*                                                                                                                               */
/* IF "{1}" = "1" THEN DO:                                                                                                       */
/*     /* N£mero S‚rie */                                                                                                        */
/*     PUT UNFORMATTED "^FO485,125^ABN^FB200,1,0,C^FDNS:" num-serie.n-serie "^FS" SKIP. /* Valor do Codigo de Barras EAN128 */   */
/*     PUT UNFORMATTED "^FO485,140^BY1^BCN,24,N,N,N,N^FD" num-serie.n-serie "^FS" SKIP.  /* Codigo de Barras EAN 128 */          */
/* END.                                                                                                                          */
/* ELSE DO:                                                                                                                      */
/*     /* N£mero S‚rie */                                                                                                        */
/*     PUT UNFORMATTED "^FO1340,410^ABN^FB760,1,0,L^FDNS:" num-serie.n-serie "^FS" SKIP. /* Valor do Codigo de Barras EAN128 */  */
/*     PUT UNFORMATTED "^FO1340,370^BY3^BCN,84,N,N,N,N^FD" num-serie.n-serie "^FS" SKIP.  /* Codigo de Barras EAN 128 */         */
/*                                                                                                                               */
/*     IF "{1}" = "2" THEN DO:                                                                                                   */
/*         /* Anatel + Homologa‡Æo */                                                                                            */
/*         PUT UNFORMATTED "^FO625,55^XGlocal-anatelpp.GRF^FS" /* Impressao da Imagem ANATEL */ SKIP.                            */
/*         PUT UNFORMATTED "^FO495,125^A0N,12,12^FB200,1,0,R^FD" item-ean.homolog "^FS" SKIP.                                    */
/*     END.                                                                                                                      */
/*     IF "{1}" = "3" THEN DO:                                                                                                   */
/*         /* Suframa */                                                                                                         */
/*         /*PUT UNFORMATTED "^FO1750,200^XGlocal-suframa.GRF^FS" SKIP.*/                                                        */
/*         PUT UNFORMATTED "^FO1720,200^XGSuframa600dpi.GRF^FS" SKIP.                                                            */
/*     END.                                                                                                                      */
/* END.                                                                                                                          */




