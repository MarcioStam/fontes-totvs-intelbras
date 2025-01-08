/*------------------------------------------------------------------------------
  Purpose:     Imprime informa‡äes Intelbras
  Parameters:  <ai-linmento>
  Notes:       Emerson Colla - 24/11/2016
------------------------------------------------------------------------------*/
ASSIGN i-lin = 0.

PUT UNFORMATTED "^FO{1},{2}^A0N,14,14^FD" item-ean.char-2 "^FS" SKIP.
PUT UNFORMATTED "^FH^FO" ({1} + 215) ",{2}^A0N,14,14^FB365,1,0,L^FD" REPLACE(item-ean.origem,'é','_e9') /* CHR(218) */ "^FS" SKIP.
ASSIGN i-lin = {2} + {3}.
PUT UNFORMATTED "^FO{1}," i-lin "^A0N,14,14^FB365,1,0,L^FDCNPJ: " c-cgc "^FS" SKIP.
PUT UNFORMATTED "^FO" ({1} + 215) "," i-lin "^A0N,14,14^FB365,1,0,L^FD" STRING(num-serie.data,"99/99/99") "^FS" SKIP.
ASSIGN i-lin = i-lin + {3}.
PUT UNFORMATTED "^FO{1}," i-lin "^A0N,14,14^FB365,1,0,L^FD" item-ean.fone "^FS" SKIP.
ASSIGN i-lin = i-lin + {3}.
PUT UNFORMATTED "^FH^FO{1}," i-lin "^A0N,14,14^FB365,1,0,L^FD" REPLACE(item-ean.info-tec[1], "~~":U, "_7e":U) "^FS" SKIP.
ASSIGN i-lin = i-lin + {3}.
PUT UNFORMATTED "^FH^FO{1}," i-lin "^A0N,14,14^FB365,1,0,L^FD" REPLACE(item-ean.info-tec[2], "~~":U, "_7e":U) "^FS" SKIP.
ASSIGN i-lin = i-lin + {3}.

