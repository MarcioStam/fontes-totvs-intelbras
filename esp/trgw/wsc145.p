/********************************************************************************
 ** UPC........: wsc044.p - UPC WRITE wm-item-embalagem-local
 ** Data.......: 20/01/2016
 ** Objetivo...: Repassa inclusäes e modifica‡äes dos itens para itens WMS
 *******************************************************************************/
DEFINE PARAMETER BUFFER b-wm-item-embalagem-local      FOR wm-item-embalagem-local.
DEFINE PARAMETER BUFFER b-old-wm-item-embalagem-local  FOR wm-item-embalagem-local.

IF b-wm-item-embalagem-local.cod-embalagem = "PALLET" AND
   b-wm-item-embalagem-local.cod-emb-item  = "CAIXA"  AND
   b-wm-item-embalagem-local.qtd-emb-item  > 0 THEN DO:

    FOR FIRST item-dun
        WHERE item-dun.it-codigo = b-wm-item-embalagem-local.cod-item
        AND   item-dun.qtd-emb   = INTEGER(b-wm-item-embalagem-local.qtd-emb-item) NO-LOCK:

        FIND FIRST wm-item-embalagem-etiq
            WHERE wm-item-embalagem-etiq.cod-item  = b-wm-item-embalagem-local.cod-item
            AND   wm-item-embalagem-etiq.cod-embal = b-wm-item-embalagem-local.cod-emb-item EXCLUSIVE-LOCK NO-ERROR.

        IF AVAIL wm-item-embalagem-etiq THEN
            ASSIGN wm-item-embalagem-etiq.cod-barras = item-dun.cod-dun.
        ELSE DO:
            CREATE wm-item-embalagem-etiq.
            ASSIGN wm-item-embalagem-etiq.cod-item   = b-wm-item-embalagem-local.cod-item
                   wm-item-embalagem-etiq.cod-embal  = b-wm-item-embalagem-local.cod-emb-item
                   wm-item-embalagem-etiq.cod-barras = item-dun.cod-dun.
        END.
    END.
END.


