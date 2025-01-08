/*------------------------------------------------------------------------------
  Purpose:     Imprime informa‡äes Intelbras
  Parameters:  <ai-linmento>
  Notes:       Emerson Colla - 24/11/2016
------------------------------------------------------------------------------*/
ASSIGN i-lin = 0.

PUT UNFORMATTED "^FO455,60^A0N,14,14^FDImportado por: PST ELETRONICA LTDA^FS" SKIP.
PUT UNFORMATTED "^FO455,75^A0N,14,14^FDCoronel Cetz 166, San Isidro , Buenos Aires, Argentina^FS" SKIP.
PUT UNFORMATTED "^FO455,90^A0N,14,14^FDSoporte: 0800-333-5389 - www.positron.com.ar^FS" SKIP.
PUT UNFORMATTED "^FO455,105^A0N,14,14^FDHecho en Brasil^FS" SKIP.
/*
PUT UNFORMATTED "^FO{1},{2}^A0N,14,14^FD" item-ean.char-2 "^FS" SKIP.
PUT UNFORMATTED "^FO" ({1} + 215) ",{2}^A0N,14,14^FB365,1,0,L^FD" item-ean.origem "^FS" SKIP.
ASSIGN i-lin = {2} + {3}.
PUT UNFORMATTED "^FO{1}," i-lin "^A0N,14,14^FB365,1,0,L^FDCNPJ: " c-cgc "^FS" SKIP.
PUT UNFORMATTED "^FO" ({1} + 215) "," i-lin "^A0N,14,14^FB365,1,0,L^FD" STRING(num-serie.data,"99/99/99") "^FS" SKIP.
ASSIGN i-lin = i-lin + {3}.
PUT UNFORMATTED "^FO{1}," i-lin "^A0N,14,14^FB365,1,0,L^FD" item-ean.fone "^FS" SKIP.
ASSIGN i-lin = i-lin + {3}.
PUT UNFORMATTED "^FO{1}," i-lin "^A0N,14,14^FB365,1,0,L^FD" item-ean.info-tec[1] "^FS" SKIP.
ASSIGN i-lin = i-lin + {3}.
PUT UNFORMATTED "^FO{1}," i-lin "^A0N,14,14^FB365,1,0,L^FD" item-ean.info-tec[2] "^FS" SKIP.
ASSIGN i-lin = i-lin + {3}. */

