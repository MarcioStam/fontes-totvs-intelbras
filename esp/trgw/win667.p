/********************************************************************************
 ** UPC........: win667- UPC WRITE item-mat
 ** Data.......: Agosto / 2012
 ** Motivo  ...: EMS204 para EMS206 - informa‡äes da tabela item fora para item-mat.
 ** Objetivo...: Setar valores dos campos pis/cofins de opera‡äes externas.
 ********************************************************************************/

DEF PARAM BUFFER b-item-mat     FOR item-mat.
DEF PARAM BUFFER b-old-item-mat FOR item-mat.

DEF NEW GLOBAL SHARED VAR c-seg-usuario AS CHAR NO-UNDO.

IF NEW b-item-mat THEN do:  
    ASSIGN b-item-mat.val-aliq-ext-pis    = 1.65
           b-item-mat.val-aliq-ext-cofins = 7.60.
END.


CREATE hist-item.
ASSIGN hist-item.it-codigo   = b-item-mat.it-codigo
       hist-item.tipo        = 'EAN13'
       hist-item.acao        = IF NEW b-item-mat THEN 'Criacao' ELSE 'Alteracao'
       hist-item.cod-dun-ant = ""
       hist-item.cod-dun-atu = ""
       hist-item.qtd-emb-ant = 0
       hist-item.qtd-emb-atu = 0
       hist-item.cod-ean-ant = b-old-item-mat.cod-ean
       hist-item.cod-ean-atu = b-item-mat.cod-ean
       hist-item.data        = TODAY 
       hist-item.hora        = STRING(TIME,'HH:MM:SS')
       hist-item.usuario     = c-seg-usuario
       hist-item.programa-alt = PROGRAM-NAME(1) + ' - ' + PROGRAM-NAME(2) + ' - ' +             
                                PROGRAM-NAME(3) + ' - ' + PROGRAM-NAME(4) + ' - ' +
                                PROGRAM-NAME(5) + ' - ' + PROGRAM-NAME(6) + ' - ' +
                                PROGRAM-NAME(7) + ' - ' + PROGRAM-NAME(8) + ' - ' +
                                PROGRAM-NAME(9) + ' - ' + PROGRAM-NAME(10).




RETURN "OK".
       
       
