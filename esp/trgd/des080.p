/********************************************************************************
 ** UPC........: upcd-es080.p - UPC DELETE Familia-item
 ** Data.......: Outubro / 2004
 ** Objetivo...: Repassa inclusäes e modifica‡äes de familia dos itens para a Base Oracle
 ********************************************************************************/
TRIGGER PROCEDURE FOR DELETE OF familia-item.

run esp/es0669.p (input "no", 
                 "familia-item", 
                 familia-item.cod-familia,
                 "","", "", "", "", "", "", "").
 
