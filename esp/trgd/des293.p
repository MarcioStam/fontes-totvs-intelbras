/********************************************************************************
 ** UPC........: des293.p - UPC DELETE item-layout-tabpreco
 ** Data.......: Novembro / 2004
 ** Objetivo...: Repassa inclusäes e modifica‡äes de item do layout da tabela de pre‡o para a Base Oracle
 ********************************************************************************/

TRIGGER PROCEDURE FOR DELETE OF item-layout-tabpreco.

run esp/es0669.p (input "no",
                  "item-layout-tabpreco",
                  item-layout-tabpreco.it-codigo,
                  string(item-layout-tabpreco.lay-codigo),
                  "","","", "", "", "", "").

