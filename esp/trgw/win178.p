/********************************************************************************
 ** UPC........: win178.p - UPC WRITE Item-fornec
 ** Data.......: Novembro / 2004
 ** Objetivo...: Repassa inclusäes e modifica‡äes de item/fornecedor para a Base Oracle
 ********************************************************************************/

DEF PARAM BUFFER b-item-fornec      FOR item-fornec.
DEF PARAM BUFFER b-old-item-fornec  FOR item-fornec.

run esp/es0669.p (input "yes", 
                  "item-fornec", 
                  b-item-fornec.it-codigo,
                  string(b-item-fornec.cod-emitente,"999999999"),
                  "", "", "", "", "", "", "").
