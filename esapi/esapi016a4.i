/*------------------------------------------------------------------------------
  Purpose:     Imprime informa‡äes Intelbras
  Parameters:  <alinhamento>
  Notes:       Carlos Daniel - 07/10/2015
------------------------------------------------------------------------------*/
PUT UNFORMATTED "^FO{2},75^A0N,14,14^FD" item-ean.char-2 "^FS"                     SKIP.
PUT UNFORMATTED "^FO{2},90^A0N,14,14^FB365,1,0,{1}^FDCNPJ: " c-cgc "^FS"                 SKIP.
PUT UNFORMATTED "^FO{2},105^A0N,14,14^FB365,1,0,{1}^FD" item-ean.fone "^FS"              SKIP.
PUT UNFORMATTED "^FO{2},120^A0N,14,14^FB365,1,0,{1}^FD" item-ean.origem "^FS"            SKIP.
PUT UNFORMATTED "^FO{2},135^A0N,14,14^FB365,1,0,{1}^FD" STRING(num-serie.data,"99/99/99") "^FS" SKIP.
PUT UNFORMATTED "^FO{2},150^A0N,14,14^FB365,1,0,{1}^FD" item-ean.info-tec[1] "^FS"       SKIP.
PUT UNFORMATTED "^FO{2},165^A0N,14,14^FB365,1,0,{1}^FD" item-ean.info-tec[2] "^FS"       SKIP.
PUT UNFORMATTED "^FO{2},180^A0N,18,16^FB365,1,0,{1}^FDNS:" num-serie.n-serie "^FS"       SKIP.
