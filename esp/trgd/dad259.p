/********************************************************************************
 ** UPC........: dad259.p - UPC DELETE tip-rec-desp (Receita padrao)    
 ** Data.......: Setembro / 2010
 ** Objetivo...: Repassa inclusäes e modifica‡äes para o CRM
 ********************************************************************************/

DEF PARAM BUFFER b-tipo-rec-desp      FOR tipo-rec-desp.
/*
{esp/crm/escrm001.i}
{esp/crm/escrm001a.i1}
*/
DEF VAR raw-param   AS RAW  NO-UNDO.
RAW-TRANSFER b-tipo-rec-desp TO raw-param.
{esp/esb/esesb006.i 'msg0052' 'dad259' 'tipo-rec-desp'}

/*
create tt-receita-padrao-atu.
buffer-copy b-tipo-rec-desp to tt-receita-padrao-atu.
create tt-raw-transfer.

raw-transfer tt-receita-padrao-atu to tt-raw-transfer.record.

run esp/crm/escrm001a.p (input "Receita-Padrao",
                         input "D",
                         input rowid(b-tipo-rec-desp),
                         input table tt-raw-transfer).
*/
