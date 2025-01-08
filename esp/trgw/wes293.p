/********************************************************************************
 ** UPC........: wes293.p - UPC WRITE item-layout-tabpreco
 ** Data.......: Novembro / 2004
 ** Objetivo...: Repassa inclusäes e modifica‡äes de item do layout da tabela de pre‡o para a Base Oracle
 ********************************************************************************/

TRIGGER PROCEDURE FOR WRITE OF item-layout-tabpreco.

run esp/es0669.p (input "yes",
                  "item-layout-tabpreco",
                  item-layout-tabpreco.it-codigo,
                  string(item-layout-tabpreco.lay-codigo),
                  "","","", "", "", "", "").
