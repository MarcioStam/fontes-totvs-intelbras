/*------------------------------------------------------------------------------
  Purpose:    Etiqueta de Produto Exporta‡Æo (34x21mm)
  Parameters:  <none>
  Notes:      Emerson Colla - 22/12/2016
  Parametro : 1-NÆo homologada, 2-Homologado
------------------------------------------------------------------------------*/

/* Modelo */
PUT UNFORMATTED "^FO430,15^A0N,20,20^FB290,1,0,C^FD" CAPS(item-ean.nome-abrev) "^FS" SKIP.    /* Imprime modelo */
PUT UNFORMATTED "^LRY^FO430,5^GB290,30,30^FS^LRN" SKIP.  /* Quadro preto */

/* Nicolas - M2106-011
/* Informa‡äes Item */
//PUT UNFORMATTED "^FO445,60^A0N,14,12^FB260,1,0,C^FD" CAPS(item-ean.linha[2] + " " + item-ean.linha[1]) "^FS" SKIP.
PUT UNFORMATTED "^FO445,85^A0N,12,12^FD" item-ean.char-2 "^FS"                                         SKIP.
PUT UNFORMATTED "^FO445,100^A0N,12,12^FDCNPJ: " c-cgc                                            "^FS" SKIP.
PUT UNFORMATTED "^FO445,115^A0N,12,12^FD" item-ean.origem                                        "^FS" SKIP.
PUT UNFORMATTED "^FO445,130^A0N,12,12^FD" STRING(num-serie.data,"99/99/99")                 "^FS" SKIP.
PUT UNFORMATTED "^FO496,85 ^A0N,12,12^FB200,1,0,R^FD" item-ean.info-tec[1]                       "^FS" SKIP.
PUT UNFORMATTED "^FO496,100^A0N,12,12^FB200,1,0,R^FD" item-ean.info-tec[2]                       "^FS" SKIP. 
PUT UNFORMATTED "^FO496,115^A0N,12,12^FB200,1,0,R^FD" item-ean.info-tec[3]                       "^FS" SKIP.
*/

PUT UNFORMATTED "^FO445,50^A0N,12,12^FD" item-ean.char-2 "^FS"                                         SKIP.
PUT UNFORMATTED "^FO615,50^A0N,12,12^FD" STRING(num-serie.data,"99/99/99")                 "^FS" SKIP.
PUT UNFORMATTED "^FO445,65^A0N,12,12^FDCNPJ: " c-cgc                                            "^FS" SKIP.
PUT UNFORMATTED "^FO445,80^A0N,12,12^FD" item-ean.origem                                        "^FS" SKIP.
PUT UNFORMATTED "^FO445,95 ^A0N,12,12^FB200,1,0,L^FD" item-ean.info-tec[1]                       "^FS" SKIP.
PUT UNFORMATTED "^FO445,110^A0N,12,12^FB200,1,0,L^FD" item-ean.info-tec[2]                       "^FS" SKIP. 
PUT UNFORMATTED "^FO445,125^A0N,12,12^FB200,1,0,L^FD" item-ean.info-tec[3]                       "^FS" SKIP.

/*
PUT UNFORMATTED "^FO575,50^A0N,14,12^FB260,1,0,C^FD" CAPS(item-ean.linha[2] + " " + item-ean.linha[1]) "^FS" SKIP.
PUT UNFORMATTED "^FO575,75^A0N,12,12^FD" item-ean.char-2 "^FS"                                         SKIP.
PUT UNFORMATTED "^FO575,90^A0N,12,12^FDCNPJ: " c-cgc                                            "^FS" SKIP.
PUT UNFORMATTED "^FO575,105^A0N,12,12^FD" item-ean.origem                                        "^FS" SKIP.
PUT UNFORMATTED "^FO575,120^A0N,12,12^FD" STRING(num-serie.data,"99/99/99")                 "^FS" SKIP.
PUT UNFORMATTED "^FO626,75 ^A0N,12,12^FB200,1,0,R^FD" item-ean.info-tec[1]                       "^FS" SKIP.
PUT UNFORMATTED "^FO626,90^A0N,12,12^FB200,1,0,R^FD" item-ean.info-tec[2]                       "^FS" SKIP. 
PUT UNFORMATTED "^FO626,105^A0N,12,12^FB200,1,0,R^FD" item-ean.info-tec[3]                       "^FS" SKIP.
*/    

IF "{1}" = "1" THEN DO:
    /* N£mero S‚rie */
    PUT UNFORMATTED "^FO485,155^ABN^FB200,1,0,C^FDNS:" num-serie.n-serie "^FS" SKIP. /* Valor do Codigo de Barras EAN128 */ 
END.
ELSE DO:
    /* N£mero S‚rie */
    PUT UNFORMATTED "^FO445,155^ABN^FB200,1,0,L^FDNS:" num-serie.n-serie "^FS" SKIP. /* Valor do Codigo de Barras EAN128 */ 
    
END.


