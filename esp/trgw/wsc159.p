
/********************************************************************************
 ** UPC........: wsc159.p - UPC WRITE wms-item-estab-local
 ** Data.......: 01/03/2016
 ** Objetivo...: Repassa inclusäes e modifica‡äes dos itens para itens WMS
 *******************************************************************************/
DEFINE PARAMETER BUFFER b-wms-item-estab-local      FOR wms-item-estab-local.
DEFINE PARAMETER BUFFER b-old-wms-item-estab-local  FOR wms-item-estab-local.

{esp/es0018.i}

IF NEW b-wms-item-estab-local THEN
    ASSIGN b-wms-item-estab-local.idi-leitura-invent = 2.

EMPTY TEMP-TABLE tt-prog-ponto.

RUN esp/es0018p.p (INPUT "WM0113", /* Nome do programa */
                   INPUT 1,        /* Ponto do programa */
                   INPUT 0,
                   INPUT "",
                   OUTPUT TABLE tt-prog-ponto).
/*
FOR EACH tt-prog-ponto:
    MESSAGE ENTRY(1, tt-prog-ponto.conteudo,";") SKIP
            ENTRY(2, tt-prog-ponto.conteudo,";")
        VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
END. */
IF CAN-FIND (FIRST tt-prog-ponto WHERE
                   ENTRY(1, tt-prog-ponto.conteudo,";") = b-wms-item-estab-local.cod-estab
               AND ENTRY(2, tt-prog-ponto.conteudo,";") = b-wms-item-estab-local.cod-local
                   NO-LOCK) 
THEN DO:
    ASSIGN b-wms-item-estab-local.log-compart-box-lote = YES
           b-wms-item-estab-local.log-compart-box-item = YES.
END.

/*
for each tt-prog-ponto:
    assign tt-envio2.destino = tt-envio2.destino + ENTRY(3, tt-prog-ponto.conteudo,";") + ";".
END. */
