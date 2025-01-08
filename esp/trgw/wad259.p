/********************************************************************************
 ** UPC........: wad259.p - UPC WRITE tip-rec-desp (Receita Padrao)    
 ** Data.......: Setembro / 2010
 ** Objetivo...: Repassa inclusäes e modifica‡äes para a Base CRM
 ********************************************************************************/

DEF PARAM BUFFER b-tipo-rec-desp      FOR tipo-rec-desp.
DEF PARAM BUFFER b-old-tipo-rec-desp  FOR tipo-rec-desp.

/*Inicio Integra‡Æo Canais*/
DEF VAR raw-param   AS RAW  NO-UNDO.

RAW-TRANSFER b-tipo-rec-desp TO raw-param.
{esp/esb/esesb006.i 'msg0052' 'wad259' 'tipo-rec-desp'}

/*Fim Integra‡Æo Canais*/
/*
{esp/crm/escrm001.i}
{esp/crm/escrm001a.i1}


run esp/crm/escrm001a.p (input "Receita-Padrao",
                         input "W",
                         input rowid(b-tipo-rec-desp),
                         input table tt-raw-transfer).
*/
