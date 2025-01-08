/*Etiqueta de produto para Exporta‡Æo 50x24 */
/* Nicolas - M2106-011
//PUT UNFORMATTED "^FO425,60^A0N,20,20^FB408,1,0,C^FD" CAPS(item-ean.linha[2] + " " + item-ean.linha[1]) "^FS" SKIP.
PUT UNFORMATTED "^FO450,90^A0N,14,14^FD" item-ean.char-2 "^FS"                                               SKIP.
PUT UNFORMATTED "^FO450,110^A0N,14,14^FDCNPJ: " c-cgc                                                  "^FS" SKIP.
PUT UNFORMATTED "^FO450,130^A0N,14,14^FD" item-ean.origem                                              "^FS" SKIP.
PUT UNFORMATTED "^FO450,150^A0N,14,14^FB200,1,0,L^FD" STRING(num-serie.data,"99/99/99")                "^FS" SKIP.
PUT UNFORMATTED "^FO615,90 ^A0N,14,14^FB200,1,0,R^FD" item-ean.info-tec[1]                             "^FS" SKIP.
PUT UNFORMATTED "^FO615,110^A0N,14,14^FB200,1,0,R^FD" item-ean.info-tec[2]                             "^FS" SKIP. 
PUT UNFORMATTED "^FO615,130^A0N,14,14^FB200,1,0,R^FD" item-ean.info-tec[3]                             "^FS" SKIP.
PUT UNFORMATTED "^FO450,175^ADN,18,10^FB375,1,0,C^FDNS:" num-serie.n-serie                             "^FS" SKIP.
  */
PUT UNFORMATTED "^FO450,55^A0N,14,14^FD" item-ean.char-2 "^FS"                                               SKIP.
PUT UNFORMATTED "^FO600,55^A0N,14,14^FB200,1,0,R^FD" STRING(num-serie.data,"99/99/99")                "^FS" SKIP.
PUT UNFORMATTED "^FO450,75^A0N,14,14^FDCNPJ: " c-cgc                                                  "^FS" SKIP.
PUT UNFORMATTED "^FO450,95^A0N,14,14^FD" item-ean.origem                                              "^FS" SKIP.
PUT UNFORMATTED "^FO450,115 ^A0N,14,14^FB200,1,0,L^FD" item-ean.info-tec[1]                             "^FS" SKIP.
PUT UNFORMATTED "^FO450,135^A0N,14,14^FB200,1,0,L^FD" item-ean.info-tec[2]                             "^FS" SKIP. 
PUT UNFORMATTED "^FO450,155^A0N,14,14^FB200,1,0,L^FD" item-ean.info-tec[3]                             "^FS" SKIP.

IF "{1}" = "2" THEN
   PUT UNFORMATTED "^FO360,175^ADN,18,10^FB375,1,0,C^FDNS:" num-serie.n-serie                             "^FS" SKIP.     
ELSE 
   PUT UNFORMATTED "^FO450,175^ADN,18,10^FB375,1,0,C^FDNS:" num-serie.n-serie                             "^FS" SKIP.
