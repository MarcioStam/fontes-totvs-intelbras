/********************************************************************************
 ** UPC........: wes254.p - UPC WRITE desc-gr-cli
 ** Data.......: Mar‡o / 2007
 ** Objetivo...: Repassa inclusäes e modifica‡äes Desconto de Grupo de Cliente e Representante a Base Oracle
 ********************************************************************************/

TRIGGER PROCEDURE FOR WRITE OF desc-gr-cli.

run esp/es0669.p (input "yes",
                  "desc-gr-cli",
                  string(desc-gr-cli.cod-gr-cli),
                  string(desc-gr-cli.cod-rep),
                  "", "", "", "", "", "", "").
