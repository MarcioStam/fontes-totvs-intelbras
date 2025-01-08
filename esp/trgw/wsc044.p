/********************************************************************************
 ** UPC........: wsc044.p - UPC WRITE wm-item
 ** Data.......: 20/01/2016
 ** Objetivo...: Repassa inclusäes e modifica‡äes dos itens para itens WMS
 *******************************************************************************/
DEFINE PARAMETER BUFFER b-wm-item      FOR wm-item.
DEFINE PARAMETER BUFFER b-old-wm-item  FOR wm-item.

IF NEW b-wm-item THEN DO:
    FOR FIRST bc-ext-item
        WHERE bc-ext-item.it-codigo = b-wm-item.cod-item EXCLUSIVE-LOCK: END.

    IF NOT AVAIL bc-ext-item THEN DO:
        CREATE bc-ext-item.
        ASSIGN bc-ext-item.it-codigo = b-wm-item.cod-item.
    END.

    ASSIGN bc-ext-item.imprime-etiq     = YES
           b-wm-item.ind-leitura-invent = 2.

    RELEASE bc-ext-item.
END.
