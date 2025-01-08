/********************************************************************************
 ** UPC........: upcw-es174.p - UPC WRITE Sub-Familia-item
 ** Data.......: Outubro / 2004
 ** Objetivo...: Repassa inclusäes e modifica‡äes de sub-familia dos itens para a Base Oracle
 ********************************************************************************/
trigger procedure for write of sub-familia-item.                                

run esp/es0669.p (input "yes", 
                  "sub-familia-item", 
                  string(sub-familia-item.cod-familia,"999"), 
                  string(sub-familia-item.cod-sub-familia,"99"), 
                  "", "", "", "", "", "", "").
