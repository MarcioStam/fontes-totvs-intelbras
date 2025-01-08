/*------------------------------------------------------------------------------
  Purpose:     Imprime informa‡äes Intelbras
  Parameters:  <alinhamento>
  Notes:       Carlos Daniel - 13/09/2016
------------------------------------------------------------------------------*/
PUT UNFORMATTED "^FO20,75^A0N,14,14^FD" item-ean.char-2 "^FS"                     SKIP.
PUT UNFORMATTED "^FO20,90^A0N,14,14^FB365,1,0, L^FDCNPJ: " c-cgc "^FS"                 SKIP.
PUT UNFORMATTED "^FO20,105^A0N,14,14^FB365,1,0,L^FD" item-ean.fone "^FS"              SKIP.
PUT UNFORMATTED "^FO20,120^A0N,14,14^FB365,1,0,L^FD" item-ean.origem "^FS"            SKIP.
PUT UNFORMATTED "^FO20,135^A0N,14,14^FB365,1,0,L^FD" STRING(num-serie.data,"99/99/99") "^FS" SKIP.
PUT UNFORMATTED "^FO20,150^A0N,14,14^FB365,1,0,L^FD" item-ean.info-tec[1] "^FS"       SKIP.
PUT UNFORMATTED "^FO20,165^A0N,14,14^FB365,1,0,L^FD" item-ean.info-tec[2] "^FS"       SKIP.
PUT UNFORMATTED "^FO20,180^A0N,18,16^FB365,1,0,L^FDNS:" num-serie.n-serie "^FS"       SKIP.

PUT UNFORMATTED "^FO250,75^XGlocal-anatel5.GRF^FS" /* Impressao da Imagem ANATEL */
                "^FO180,138^A0N,12,12^FB215,1,0,C^FD" item-ean.homolog "^FS"                   SKIP  /* homologa‡Æo */
                "^FO222,155^BY1,3.0^BCN,24,N,N,N,N^FD>;010" string(item-mat.cod-ean, "9(13)") "^FS" SKIP  /* Codigo de Barras EAN 128 - Etiqueta Secundaria */
                "^FO180,184^A0N,12,12^FB215,1,0,C^FD010" string(item-mat.cod-ean, "9(13)") "^FS"  SKIP. /* Valor do Codigo de Barras EAN 128 - Etiqueta Secundaria */
PUT UNFORMATTED "^FO25,205^A0N,15,15^FB365,4,0,J^FD" {1} "^FS"                                    SKIP. /* Valor do Codigo de Barras EAN 128 - Etiqueta Secundaria */
PUT UNFORMATTED "^LRY^FO20,200^GB373,0,63^FS^LRN"                                                 SKIP.  /* Quadro preto */
