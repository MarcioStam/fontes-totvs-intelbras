/*------------------------------------------------------------------------------
  Purpose:    Etiqueta item ean13 e NS (50x24mm)
  Parameters:  <none>
  Notes:      Carlos Daniel - 15/10/2015
------------------------------------------------------------------------------*/
PUT UNFORMATTED "^FO449,20^A0B,16,16^FD" STRING(num-serie.data,"99/99/99") "^FS" SKIP. /* Imprime Data Vertical */
PUT UNFORMATTED "^FO504,20^BY3^BEN,40,Y,N^FD" string(item-mat.cod-ean, "9(13)") "^FS" SKIP.  /* Codigo de Barras EAN 13 */
PUT UNFORMATTED "^FO802,20^A0B,18,18^FD" item-ean.it-codigo "^FS" SKIP. /* Imprime c«digo do item */
PUT UNFORMATTED "^FO449,105^A0N,18,18^FB368,1,0,C^FD" CAPS(item-ean.linha[1]) "^FS" SKIP.    /* Imprime descricao Equipto */
PUT UNFORMATTED "^FO449,125^A0N,18,18^FB368,1,0,C^FD" CAPS(item-ean.linha[2]) "^FS" SKIP.    /* Imprime descricao Equipto */
PUT UNFORMATTED "^LRY^FO449,95^GB368,0,50^FS^LRN" SKIP.  /* Quadro preto */
PUT UNFORMATTED "^FO454,150^BY2^BCN,24,N,N,N,N^FD" num-serie.n-serie "^FS" SKIP.  /* Codigo de Barras EAN 128 */
PUT UNFORMATTED "^FO454,177^ADN,18,10^FB368,1,0,C^FDNS:" num-serie.n-serie "^FS" SKIP. /* Valor do Codigo de Barras EAN128 */
/* PUT UNFORMATTED "^FO454,180^A0N,14,14^FB368,1,0,C^FDNS:" num-serie.n-serie "^FS" SKIP. /* Valor do Codigo de Barras EAN128 */ */
PUT UNFORMATTED "^FO767,177^A0N,18,18^FB50,1,0,R^FD" num-serie.sigla "^FS" SKIP. /* Sigla */
