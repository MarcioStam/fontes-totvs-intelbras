/********************************************************************************
 ** UPC........: upcw-es327.p - UPC DELETE sub-famc-item
 ** Data.......: novembro / 2004
 ** Objetivo...: Repassa inclusäes e modifica‡äes de sub-familia  dos itens para a Base Oracle
 ********************************************************************************/
trigger procedure for DELETE of sub-famc-item.                                

run esp/es0669.p (input "no", 
                  "sub-famc-item", 
                  string(sub-famc-item.cod-familia,"99"), 
                  STRING(sub-famc-item.cod-sub-familia,"99"), 
                  "", "","", "", "","", "").
