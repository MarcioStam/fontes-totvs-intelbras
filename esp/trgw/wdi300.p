/********************************************************************************
 ** UPC........: Wdi300 - UPC WRITE item-dist
 ** Data.......: Agosto / 2012
 ** Motivo  ...: EMS204 para EMS206 - informa‡äes da tabela item fora para item-mat.
 ** Objetivo...: Setar valor do campo apura‡Æo IPI.
 ********************************************************************************/

DEF PARAM BUFFER b-item-dist     FOR item-dist.
DEF PARAM BUFFER b-old-item-dist FOR item-dist.

IF NEW b-item-dist THEN do:  
    ASSIGN b-item-dist.idi-tip-apurac-ipi = 2.
           
END.
