/********************************************************************************
 ** UPC........: dad176.p - UPC DELETE mensagem
 ** Data.......: Outubro / 2010
 ** Objetivo...: Repassa inclusäes e modifica‡äes para o CRM
 ********************************************************************************/

DEF PARAM BUFFER b-mensagem  FOR mensagem.
{esp/crm/escrm001.i} /* Definicao de temp-table */
{esp/crm/escrm001a.i1} /* Definicao de temp-table */

DEF VAR raw-param   AS RAW  NO-UNDO.
RAW-TRANSFER b-mensagem TO raw-param.
{esp/esb/esesb006.i 'msg0048' 'dad176' 'mensagem'}

IF  l-web-service = NO THEN DO:
    create tt-mensagem-atu.
    buffer-copy b-mensagem to tt-mensagem-atu.
    create tt-raw-transfer.
    
    raw-transfer tt-mensagem-atu to tt-raw-transfer.record.
    
    run esp/crm/escrm001a.p (input "mensagem",
                             input "D",
                             input rowid(b-mensagem),
                             input table tt-raw-transfer).
END.
