/********************************************************************************
 ** UPC........: upcd-ad129.p - UPC Delete Grupo de Cliente
 ** Data.......: Outubro / 2004
 ** Objetivo...: Repassa inclusäes e modifica‡äes dos grupos de clientes para a Base Oracle
 ********************************************************************************/

DEF PARAM BUFFER b-gr-cli      FOR gr-cli.

/*
{esp/crm/escrm001.i}
{esp/crm/escrm001a.i1}

run esp/es0669.p (input "no", 
                  "gr-cli", 
                  string(b-gr-cli.cod-gr-cli),
                  "", "", "", "", "", "", "", "").


create tt-gr-cli-atu.
buffer-copy b-gr-cli to tt-gr-cli-atu.
create tt-raw-transfer.

raw-transfer tt-gr-cli-atu to tt-raw-transfer.record.

run esp/crm/escrm001a.p (input "Gr-Cli",
                         input "D",
                         input rowid(b-gr-cli),
                         input table tt-raw-transfer).
*/
