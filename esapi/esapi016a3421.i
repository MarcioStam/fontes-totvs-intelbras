/*------------------------------------------------------------------------------
  Purpose: Etiquetas pequenas quintupla e modelo com tarja no topo da etiqueta
           a direita. Para modelos da quintupla.
  Parameters:  <none>
  Notes:   Carlos Daniel - 25/07/2016
------------------------------------------------------------------------------*/
PUT UNFORMATTED "^FO563,15^A0N,24,24^FB272,1,0,C^FD" CAPS(item-ean.nome-abrev) "^FS" SKIP.    /* Imprime modelo */
PUT UNFORMATTED "^LRY^FO561,1^GB272,40,40^FS^LRN" SKIP.  /* Quadro preto */
PUT UNFORMATTED "^FO565,50^A0N,12,12^FD" item-ean.char-2 "^FS"                        SKIP.
PUT UNFORMATTED "^FO565,95^A0N,12,12^FB200,1,0,L^FD" item-ean.origem "^FS"            SKIP.

PUT UNFORMATTED "^FO565,65^A0N,12,12^FDCNPJ: " c-cgc "^FS"                            SKIP.
PUT UNFORMATTED "^FO565,80^A0N,12,12^FD" item-ean.fone "^FS"                          SKIP.

PUT UNFORMATTED "^FO565,125^A0N,12,12^FB200,1,0,L^FD" item-ean.info-tec[1] "^FS" SKIP.
PUT UNFORMATTED "^FO565,110^A0N,12,12^FB200,1,0,L^FD" STRING(num-serie.data,"99/99/99") "^FS" SKIP.

PUT UNFORMATTED "^FO565,145^A0N,20,20^FB280,1,0,L^FDNS:" num-serie.n-serie "^FS"       SKIP.

PUT UNFORMATTED "^FO720,25^XGlocal-anatelpp.GRF^FS" /* Impressao da Imagem ANATEL */ SKIP.
PUT UNFORMATTED "^FO713,93^A0N,12,12^FD" item-ean.homolog "^FS"                   SKIP.  /* homologa‡Æo */
PUT UNFORMATTED "^FO693,105^BY1,3.0^BCN,22,N,N,N,N^FD>;010" string(item-mat.cod-ean, "9(13)") "^FS" SKIP.  /* Codigo de Barras EAN 128 - Etiqueta Secundaria */
PUT UNFORMATTED "^FO709,131^A0N,12,12^FB215,1,0,L^FD010" string(item-mat.cod-ean, "9(13)") "^FS"  SKIP. /* Valor do Codigo de Barras EAN 128 - Etiqueta Secundaria */
