/********************************************************************************
 ** UPC........: des292.p - UPC DELETE layout-tabpreco
 ** Data.......: Novembro / 2004
 ** Objetivo...: Repassa inclusäes e modifica‡äes de layout da tabela de pre‡o para a Base Oracle
 ********************************************************************************/

TRIGGER PROCEDURE FOR DELETE OF layout-tabpreco.

run esp/es0669.p (input "no",
                  "layout-tabpreco",
                   string(layout-tabpreco.lay-codigo),
                  "","","","", "", "", "", "").

