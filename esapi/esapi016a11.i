/*------------------------------------------------------------------------------
  Purpose:    Etiqueta de Produto (34x21mm)
  Parameters:  <none>
  Notes:      Emerson Colla - 22/12/2016
  Parametro : 1-NÆo homologada, 2-Anatel, 3-Suframa
------------------------------------------------------------------------------*/

/* Modelo */
PUT UNFORMATTED "^FO430,15^A0N,20,20^FB290,1,0,C^FD" CAPS(item-ean.nome-abrev) "^FS" SKIP.    /* Imprime modelo */
PUT UNFORMATTED "^LRY^FO430,5^GB290,30,30^FS^LRN" SKIP.  /* Quadro preto */

/* Informa‡äes Item */
PUT UNFORMATTED "^FO445,45^A0N,12,12^FD" item-ean.char-2 "^FS" SKIP.
PUT UNFORMATTED "^FH^FO496,45^A0N,12,12^FB200,1,0,R^FD" REPLACE(item-ean.origem,'é','_e9') /* CHR(218) */  "^FS" SKIP.
PUT UNFORMATTED "^FO445,60^A0N,12,12^FB200,1,0,L^FDCNPJ: " c-cgc "^FS" SKIP.
IF (p-cod-modelo = 160 OR
    p-cod-modelo = 170)
THEN PUT UNFORMATTED "^FO496,60^A0N,12,12^FB200,1,0,R^FD" STRING(TODAY,"99/99/99") "^FS" SKIP.
ELSE PUT UNFORMATTED "^FO496,60^A0N,12,12^FB200,1,0,R^FD" STRING(num-serie.data,"99/99/99") "^FS" SKIP.
PUT UNFORMATTED "^FO445,75^A0N,12,12^FB200,1,0,L^FD" item-ean.fone "^FS" SKIP.
PUT UNFORMATTED "^FH^FO445,90^A0N,12,12^FB200,1,0,L^FD"  REPLACE(item-ean.info-tec[1], "~~":U, "_7e":U) "^FS" SKIP.
PUT UNFORMATTED "^FH^FO445,105^A0N,12,12^FB200,1,0,L^FD" REPLACE(item-ean.info-tec[2], "~~":U, "_7e":U) "^FS" SKIP.


IF "{1}" = "1" THEN DO:
    /* N£mero S‚rie */
    PUT UNFORMATTED "^FO485,125^ABN^FB200,1,0,C^FDNS:" num-serie.n-serie "^FS" SKIP. /* Valor do Codigo de Barras EAN128 */ 
    PUT UNFORMATTED "^FO485,140^BY1^BCN,24,N,N,N,N^FD" num-serie.n-serie "^FS" SKIP.  /* Codigo de Barras EAN 128 */
END.
ELSE DO:
    /* N£mero S‚rie */
    PUT UNFORMATTED "^FO445,125^ABN^FB200,1,0,L^FDNS:" num-serie.n-serie "^FS" SKIP. /* Valor do Codigo de Barras EAN128 */ 
    PUT UNFORMATTED "^FO445,140^BY1^BCN,24,N,N,N,N^FD" num-serie.n-serie "^FS" SKIP.  /* Codigo de Barras EAN 128 */
    
    IF "{1}" = "2" THEN DO:
        /* Anatel + Homologa‡Æo */
        PUT UNFORMATTED "^FO625,55^XGlocal-anatelpp.GRF^FS" /* Impressao da Imagem ANATEL */ SKIP.
        PUT UNFORMATTED "^FO495,125^A0N,12,12^FB200,1,0,R^FD" item-ean.homolog "^FS" SKIP.
    END.
    IF "{1}" = "3" THEN DO:
        /* Suframa */
        PUT UNFORMATTED "^FO590,70^XGlocal-suframa.GRF^FS" SKIP.
    END.
END.




