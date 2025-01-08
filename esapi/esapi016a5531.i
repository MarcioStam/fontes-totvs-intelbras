/*------------------------------------------------------------------------------
  Purpose:    Etiqueta item ean13 e NS (50x34mm)
  Notes:      Carlos Daniel - 25/07/2016
------------------------------------------------------------------------------*/
PUT UNFORMATTED "^FO23,32^A0B,16,16^FD" STRING(num-serie.data,"99/99/99") "^FS" SKIP. /* Imprime Data Vertical */
PUT UNFORMATTED "^FO78,30^BY3^BEN,30,Y,N^FD" string(item-mat.cod-ean, "9(13)") "^FS" SKIP.  /* Codigo de Barras EAN 13 */
PUT UNFORMATTED "^FO373,30^A0B,18,18^FD" item-ean.it-codigo "^FS" SKIP. /* Imprime c´digo do item */

IF item-ean.destaque = "" THEN DO:
    PUT UNFORMATTED "^FO18,99^A0N,28,20^FB368,1,0,C^FD" CAPS(item-ean.linha[1]) "^FS" SKIP.    /* Imprime descricao Equipto */
    PUT UNFORMATTED "^FO18,124^A0N,28,20^FB368,1,0,C^FD" CAPS(item-ean.linha[2]) "^FS" SKIP.    /* Imprime descricao Equipto */
    PUT UNFORMATTED "^LRY^FO23,94^GB368,0,60^FS^LRN" SKIP.  /* Quadro preto */
END.
ELSE DO:
    PUT UNFORMATTED "^FO18,99^A0N,28,20^FB315,1,0,C^FD" CAPS(item-ean.linha[1]) "^FS" SKIP.    /* Imprime descricao Equipto */
    PUT UNFORMATTED "^FO18,124^A0N,28,20^FB315,1,0,C^FD" CAPS(item-ean.linha[2]) "^FS" SKIP.    /* Imprime descricao Equipto */
    PUT UNFORMATTED "^LRY^FO23,94^GB315,0,60^FS^LRN" SKIP.  /* Quadro preto */

    IF item-ean.destaque = "CHA" THEN DO:
        RUN piCargaImagem("local-chaveVENC").
       // PUT UNFORMATTED "^FO326,80^XGlocal-chave.GRF^FS" SKIP.
    END.
    ELSE
        PUT UNFORMATTED "^FO353,105,^A0B,32,24^FD" CAPS(item-ean.destaque) "^FS" SKIP.    /* Imprime descricao Equipto */ 

    PUT UNFORMATTED "^LRY^FO345,94^GB40,60,20^FS^LRN" SKIP.  /* Quadro preto destaque */
END.

PUT UNFORMATTED "^FO28,156^BY2^BCN,24,N,N,N,N^FD" num-serie.n-serie "^FS" SKIP.  /* Codigo de Barras EAN 128 */
PUT UNFORMATTED "^FO28,185^ADN,18,10^FB368,1,0,C^FDNS:" num-serie.n-serie "^FS" SKIP. /* Valor do Codigo de Barras EAN128 */
PUT UNFORMATTED "^FO343,185^A0N,23,23^FB50,1,0,R^FD" num-serie.sigla "^FS" SKIP. /* Sigla */
                                       
FIND ITEM NO-LOCK
    WHERE ITEM.it-codigo = item-ean.it-codigo NO-ERROR.
IF  AVAIL ITEM THEN DO:
    FIND FIRST int-portaria-movto NO-LOCK
         WHERE int-portaria-movto.it-codigo = item.it-codigo
           AND int-portaria-movto.dt-fim = ?
           AND int-portaria-movto.classificacao <> "BEM" NO-ERROR.
    IF AVAIL int-portaria-movto THEN DO:
    
        PUT UNFORMATTED "^FO28,209^A0N,12,12^FDESTE PRODUTO ê BENEFICIADO PELA LEGISLAÄ«O DE INFORMµTICA^FS" SKIP.

    END.
END.

PUT UNFORMATTED "^FO28,223^A0N,12,14^FDPRAZO DE VALIDADE: " string(CAPS(item-ean.texto[12])) "^FS" SKIP.
PUT UNFORMATTED "^FO28,237^A0N,12,14^FDCOMPOSIÄ«O: " CAPS(item-ean.texto[14]) "^FS" SKIP.
PUT UNFORMATTED "^FO28,251^A0N,12,14^FD" CAPS(item-ean.texto[15]) "^FS" SKIP.
/*
PUT UNFORMATTED "^FO28,160^BY2^BCN,24,N,N,N,N^FD" num-serie.n-serie "^FS" SKIP.  /* Codigo de Barras EAN 128 */
PUT UNFORMATTED "^FO28,189^ADN,18,10^FB368,1,0,C^FDNS:" num-serie.n-serie "^FS" SKIP. /* Valor do Codigo de Barras EAN128 */
PUT UNFORMATTED "^FO343,189^A0N,26,26^FB50,1,0,R^FD" num-serie.sigla "^FS" SKIP. /* Sigla */

PUT UNFORMATTED "^FO28,215^A0N,14,16^FDPRAZO DE VALIDADE: " string(item-ean.texto[12]) "^FS" SKIP.
PUT UNFORMATTED "^FO28,230^A0N,14,16^FDCOMPOSIÄ«O: " CAPS(item-ean.texto[14]) "^FS" SKIP.
PUT UNFORMATTED "^FO28,245^A0N,14,16^FD" CAPS(item-ean.texto[15]) "^FS" SKIP.
  */
