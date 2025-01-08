/********************************************************************************
 ** UPC........: upcw-es324.p - UPC WRITE famc-item
 ** Data.......: novembro / 2004
 ** Objetivo...: Repassa inclusäes e modifica‡äes de familia  dos itens para a Base Oracle
 ********************************************************************************/
trigger procedure for write of famc-item.                                

run esp/es0669.p (input "yes", 
                  "famc-item", 
                  string(famc-item.cod-familia,"99"), 
                  "", "", "","", "", "","", "").
