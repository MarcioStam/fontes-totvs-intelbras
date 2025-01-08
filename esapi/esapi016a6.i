/*------------------------------------------------------------------------------
  Purpose:     Imprime informa‡äes Intelbras
  Parameters:  <alinhamento>
  Notes:       Carlos Daniel - 07/10/2015
------------------------------------------------------------------------------*/
PUT UNFORMATTED "^FO250,75^XGlocal-anatel5.GRF^FS" /* Impressao da Imagem ANATEL */
                "^FO180,138^A0N,12,12^FB215,1,0,C^FD" item-ean.homolog "^FS"                   SKIP  /* homologa‡Æo */
                "^FO180,155^BY1,3.0^BCN,24,N,N,N,N^FD010" string(item-mat.cod-ean, "9(13)") "^FS" SKIP  /* Codigo de Barras EAN 128 - Etiqueta Secundaria */
                "^FO180,184^A0N,12,12^FB215,1,0,C^FD010" string(item-mat.cod-ean, "9(13)") "^FS"  SKIP. /* Valor do Codigo de Barras EAN 128 - Etiqueta Secundaria */
PUT UNFORMATTED "^FO25,205^A0N,{2},{3}^FB365,4,0,J^FD" {1} "^FS"                                    SKIP. /* Valor do Codigo de Barras EAN 128 - Etiqueta Secundaria */
PUT UNFORMATTED "^LRY^FO20,200^GB373,0,{4}^FS^LRN"                                                 SKIP.  /* Quadro preto */
