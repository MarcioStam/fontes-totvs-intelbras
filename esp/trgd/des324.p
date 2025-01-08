/********************************************************************************
 ** UPC........: upcd-es324.p - UPC DELETE famc-item
 ** Data.......: novembro / 2004
 ** Objetivo...: Repassa inclusäes e modifica‡äes de familia  dos itens para a Base Oracle
 ********************************************************************************/
trigger procedure for DELETE of famc-item.                                

run esp/es0669.p (input "no", 
                  "famc-item", 
                  string(famc-item.cod-familia,"99"), 
                  "", "", "","", "", "","", "").
