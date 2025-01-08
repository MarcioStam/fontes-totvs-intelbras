/********************************************************************************
 ** UPC........: upcw-es026.p - UPC WRITE car-familia-item
 ** Data.......: novembro / 2004
 ** Objetivo...: Repassa inclusäes e modifica‡äes de caracteristicas da familia dos itens para a Base Oracle
 ********************************************************************************/
trigger procedure for write of car-familia-item.                                

run esp/es0669.p (input "yes", 
                  "car-familia-item", 
                  string(car-familia-item.cod-familia,"999"), 
                  string(car-familia-item.cod-sub-familia,"99"), 
                  STRING(car-familia-item.cod-car-fam,"99"), 
                  "", "", "", "", "", "").
