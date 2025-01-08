/********************************************************************************
 ** UPC........: upcw-es080.p - UPC WRITE Familia-item
 ** Data.......: Outubro / 2004
 ** Objetivo...: Repassa inclusäes e modifica‡äes de familia dos itens para a Base Oracle
 ********************************************************************************/
TRIGGER PROCEDURE FOR WRITE OF familia-item.

run esp/es0669.p (input "yes", 
                 "familia-item", 
                 familia-item.cod-familia,
                 "","", "", "", "", "", "", "").
 
 
