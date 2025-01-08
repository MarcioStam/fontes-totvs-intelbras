/********************************************************************************
 ** UPC........: upcw-es032p - UPC WRITE comp-familia-item
 ** Data.......: novembro / 2004
 ** Objetivo...: Repassa inclusäes e modifica‡äes de complementos da familia  dos itens para a Base Oracle
 ********************************************************************************/
trigger procedure for write of comp-familia-item.                                

run esp/es0669.p (input "yes", 
                  "comp-familia-item", 
                  string(comp-familia-item.cod-familia,"999"), 
                  string(comp-familia-item.cod-sub-familia,"99"), 
                  STRING(comp-familia-item.cod-car-familia,"99"),
                  STRING(comp-familia-item.cod-comp-familia,"99"),
                  "", "", "", "", "").
