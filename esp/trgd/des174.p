/********************************************************************************
 ** UPC........: upcd-es174.p - UPC DELETE Sub-Familia-item
 ** Data.......: Outubro / 2004
 ** Objetivo...: Repassa inclusäes e modifica‡äes de sub-familia dos itens para a Base Oracle
 ********************************************************************************/
trigger procedure for DELETE of sub-familia-item.                                

run esp/es0669.p (input "no", 
                  "sub-familia-item", 
                  string(sub-familia-item.cod-familia,"999"), 
                  string(sub-familia-item.cod-sub-familia,"99"), 
                  "", "", "", "", "", "", "").


