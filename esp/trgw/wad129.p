/********************************************************************************
 ** UPC........: upcw-ad129.p - UPC WRITE grupo de clientes.
 ** Data.......: Outubro / 2004
 ** Objetivo...: Repassa inclusäes e modifica‡äes dos grupos de clientes para a Base Oracle
 ********************************************************************************/
 
DEF PARAM BUFFER b-gr-cli      FOR gr-cli.
DEF PARAM BUFFER b-old-gr-cli  FOR gr-cli.

/*
{esp/crm/escrm001.i}
{esp/crm/escrm001a.i1}

run esp/es0669.p (input "yes",
                  "gr-cli",
                  string(b-gr-cli.cod-gr-cli),
                  "", "", "", "", "", "", "", "").


run esp/crm/escrm001a.p (input "Gr-Cli",
                         input "W",
                         input rowid(b-gr-cli),
                         input table tt-raw-transfer).
*/
