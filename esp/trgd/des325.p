/********************************************************************************
 ** UPC........: upcd-es325.p - UPC DELETE car-famc-item
 ** Data.......: novembro / 2004
 ** Objetivo...: Repassa inclusäes e modifica‡äes de caracteristicas da familia dos itens para a Base Oracle
 ********************************************************************************/
trigger procedure for DELETE of car-famc-item.                                

run esp/es0669.p (input "no", 
                  "car-famc-item", 
                  string(car-famc-item.cod-familia,"99"), 
                  string(car-famc-item.cod-sub-familia,"99"), 
                  STRING(car-famc-item.cod-car-fam,"99"), 
                  "", "", "", "", "", "").
