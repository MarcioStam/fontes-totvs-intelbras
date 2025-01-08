/********************************************************************************
 ** UPC........: upcw-es326p - UPC WRITE comp-famc-item
 ** Data.......: novembro / 2004
 ** Objetivo...: Repassa inclusäes e modifica‡äes de complementos da familia  dos itens para a Base Oracle
 ********************************************************************************/
trigger procedure for write of comp-famc-item.                                

run esp/es0669.p (input "yes", 
                  "comp-famc-item", 
                  string(comp-famc-item.cod-familia,"99"), 
                  string(comp-famc-item.cod-sub-familia,"99"), 
                  STRING(comp-famc-item.cod-car-familia,"99"),
                  STRING(comp-famc-item.cod-comp-familia,"99"),
                  "", "", "", "", "").
