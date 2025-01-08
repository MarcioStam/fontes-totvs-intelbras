/*------------------------------------------------------------------------------
  Purpose:    Etiqueta item ean13 e NS (50x24mm) - Quintupla
  Parameters:  <none>
  Notes:      Nicolas - 26/11/2020
------------------------------------------------------------------------------*/
PUT UNFORMATTED "^FO449,20^A0B,14,14^FD" STRING(num-serie.data,"99/99/99") "^FS" SKIP. /* Imprime Data Vertical */
PUT UNFORMATTED "^FO486,20^BY2^BEN,30,Y,N^FD" string(item-mat.cod-ean, "9(13)") "^FS" SKIP.  /* Codigo de Barras EAN 13 */
PUT UNFORMATTED "^FO687,20^A0B,14,14^FD" item-ean.it-codigo "^FS" SKIP. /* Imprime c«digo do item */
PUT UNFORMATTED "^FO400,90^A0N,15,15^FB368,1,0,C^FD" CAPS(item-ean.linha[1]) "^FS" SKIP.    /* Imprime descricao Equipto */
PUT UNFORMATTED "^FO400,110^A0N,15,15^FB368,1,0,C^FD" CAPS(item-ean.linha[2]) "^FS" SKIP.    /* Imprime descricao Equipto */
PUT UNFORMATTED "^LRY^FO449,78^GB250,0,50^FS^LRN" SKIP.  /* Quadro preto */
PUT UNFORMATTED "^FO484,132^BY1^BCN,24,N,N,N,N^FD" num-serie.n-serie "^FS" SKIP.  /* Codigo de Barras EAN 128 */
PUT UNFORMATTED "^FO400,160^A0N,15,15^FB368,1,0,C^FDNS:" num-serie.n-serie "^FS" SKIP. /* Valor do Codigo de Barras EAN128 */
/* PUT UNFORMATTED "^FO454,180^A0N,14,14^FB368,1,0,C^FDNS:" num-serie.n-serie "^FS" SKIP. /* Valor do Codigo de Barras EAN128 */ */
PUT UNFORMATTED "^FO640,157^A0N,16,16^FB50,1,0,R^FD" num-serie.sigla "^FS" SKIP. /* Sigla */
