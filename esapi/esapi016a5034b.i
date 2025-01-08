/*------------------------------------------------------------------------------
  Purpose:    Etiqueta item ean13 e NS (50x34mm)
  Notes:      Carlos Daniel - 25/07/2016
------------------------------------------------------------------------------*/
IF (p-cod-modelo = 160 OR
    p-cod-modelo = 170)
THEN PUT UNFORMATTED "^FO23,17^A0B,16,16^FD" STRING(TODAY,"99/99/99") "^FS" SKIP. /* Imprime Data Vertical */
ELSE PUT UNFORMATTED "^FO23,17^A0B,16,16^FD" STRING(num-serie.data,"99/99/99") "^FS" SKIP. /* Imprime Data Vertical */

PUT UNFORMATTED "^FO78,17^BY3^BEN,50,Y,N^FD" string(item-mat.cod-ean, "9(13)") "^FS" SKIP.  /* Codigo de Barras EAN 13 */
PUT UNFORMATTED "^FO373,17^A0B,22,22^FD" item-ean.it-codigo "^FS" SKIP. /* Imprime c´digo do item */

IF item-ean.destaque = "" THEN DO:
    PUT UNFORMATTED "^FO18,117^A0N,32,24^FB368,1,0,C^FD" CAPS(item-ean.linha[1]) "^FS" SKIP.    /* Imprime descricao Equipto */
    PUT UNFORMATTED "^FO18,152^A0N,32,24^FB368,1,0,C^FD" CAPS(item-ean.linha[2]) "^FS" SKIP.    /* Imprime descricao Equipto */
    PUT UNFORMATTED "^LRY^FO23,107^GB368,0,80^FS^LRN" SKIP.  /* Quadro preto */
END.
ELSE DO:
    PUT UNFORMATTED "^FO18,117^A0N,32,24^FB315,1,0,C^FD" CAPS(item-ean.linha[1]) "^FS" SKIP.    /* Imprime descricao Equipto */
    PUT UNFORMATTED "^FO18,152^A0N,32,24^FB315,1,0,C^FD" CAPS(item-ean.linha[2]) "^FS" SKIP.    /* Imprime descricao Equipto */
    PUT UNFORMATTED "^LRY^FO23,107^GB315,0,80^FS^LRN" SKIP.  /* Quadro preto */

    IF item-ean.destaque = "CHA" THEN DO:
        RUN piCargaImagem("local-chave").
        PUT UNFORMATTED "^FO326,102^XGlocal-chave.GRF^FS" SKIP.
    END.
    ELSE
        PUT UNFORMATTED "^FO353,129,^A0B,32,24^FD" CAPS(item-ean.destaque) "^FS" SKIP.    /* Imprime descricao Equipto */ 

    PUT UNFORMATTED "^LRY^FO345,107^GB40,80,20^FS^LRN" SKIP.  /* Quadro preto destaque */
END.

PUT UNFORMATTED "^FO28,192^BY2^BCN,24,N,N,N,N^FD" num-serie.n-serie "^FS" SKIP.  /* Codigo de Barras EAN 128 */
PUT UNFORMATTED "^FO28,222^ADN,18,10^FB368,1,0,C^FDNS:" num-serie.n-serie "^FS" SKIP. /* Valor do Codigo de Barras EAN128 */
PUT UNFORMATTED "^FO343,222^A0N,24,24^FB50,1,0,R^FD" num-serie.sigla "^FS" SKIP. /* Sigla */

IF p-cod-modelo <> 190 AND p-cod-modelo <> 138 THEN DO: 

    FIND ITEM NO-LOCK
        WHERE ITEM.it-codigo = item-ean.it-codigo NO-ERROR.
    IF  AVAIL ITEM THEN DO:
        FIND FIRST int-portaria-movto NO-LOCK
             WHERE int-portaria-movto.it-codigo = item.it-codigo
               AND int-portaria-movto.dt-fim = ?
               AND int-portaria-movto.classificacao <> "BEM" NO-ERROR.
        IF AVAIL int-portaria-movto THEN DO:
        
            //PUT UNFORMATTED "^FO27,245^A0N,18,14^FB360,1,0,C^FD" "ESTE PRODUTO ê BENEFICIADO PELA LEGISLAÄ«O DE INFORMµTICA^FS" SKIP.
            PUT UNFORMATTED "^FO10,245^A0N,20,12^FB400,1,0,C^FD" "ESTE PRODUTO ê BENEFICIADO PELA LEGISLAÄ«O DE INFORMµTICA^FS" SKIP.
    
        END.
    END.

END.


