/*------------------------------------------------------------------------------
  Purpose:    Etiqueta item ean13 e NS (50x24mm)
  Parameters:  <none>
  Notes:      Carlos Daniel - 15/10/2015
------------------------------------------------------------------------------*/
/* PUT UNFORMATTED "^FO449,25^A0B,12,12^FD" item-ean.origem "^FS" SKIP. /* Imprime Origem Vertical */ */
PUT UNFORMATTED "^FO449,25^A0B,16,16^FD" STRING(num-serie.data,"99/99/99") "^FS" SKIP. /* Imprime Data Vertical */
PUT UNFORMATTED "^FO504,25^BY3^BEN,40,Y,N^FD" string(item-mat.cod-ean, "9(13)") "^FS" SKIP.  /* Codigo de Barras EAN 13 */
PUT UNFORMATTED "^FO802,25^A0B,18,18^FD" item-ean.it-codigo "^FS" SKIP. /* Imprime c«digo do item */
PUT UNFORMATTED "^FO449,110^A0N,18,18^FB368,1,0,C^FD" CAPS(item-ean.linha[1]) "^FS" SKIP.    /* Imprime descricao Equipto */
PUT UNFORMATTED "^FO449,130^A0N,18,18^FB368,1,0,C^FD" CAPS(item-ean.linha[2]) "^FS" SKIP.    /* Imprime descricao Equipto */
/* PUT UNFORMATTED "^LRY^FO449,100^GB368,0,50^FS^LRN" SKIP.  /* Quadro preto */ */
PUT UNFORMATTED "^FO454,155^BY2^BCN,24,N,N,N,N^FD" num-serie.n-serie "^FS" SKIP.  /* Codigo de Barras EAN 128 */
PUT UNFORMATTED "^FO454,185^A0N,14,14^FB368,1,0,C^FDNS:" num-serie.n-serie "^FS" SKIP. /* Valor do Codigo de Barras EAN128 */
PUT UNFORMATTED "^FO767,185^A0N,18,18^FB50,1,0,R^FD" num-serie.sigla "^FS" SKIP. /* Sigla */
