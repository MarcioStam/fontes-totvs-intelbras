/********************************************************************************
** UPC........: wes614 - UPC WRITE item-dun
** Data.......: Julho / 2022
** Motivo  ...: Guardar historico de alteracoes na tabela item-dun.
********************************************************************************/
TRIGGER PROCEDURE FOR WRITE OF item-dun.

DEF NEW GLOBAL SHARED VAR c-seg-usuario AS CHAR NO-UNDO.

/*
DEF PARAM BUFFER b-item-dun     FOR item-dun.
DEF PARAM BUFFER b-old-item-dun FOR item-dun.
*/

DEF BUFFER b01-hist-item FOR hist-item.

FIND LAST b01-hist-item WHERE b01-hist-item.it-codigo = item-dun.it-codigo NO-LOCK NO-ERROR.

CREATE hist-item.
ASSIGN hist-item.it-codigo   = item-dun.it-codigo
       hist-item.tipo        = 'DUN14'
       hist-item.acao        = IF NOT AVAIL b01-hist-item THEN 'Criacao' ELSE 'Alteracao'
       hist-item.cod-dun-ant = IF NOT AVAIL b01-hist-item THEN ''        ELSE b01-hist-item.cod-dun-atu
       hist-item.cod-dun-atu = item-dun.cod-dun      
       hist-item.digito-ant  = IF NOT AVAIL b01-hist-item THEN 0         ELSE b01-hist-item.digito-atu
       hist-item.digito-atu  = item-dun.digito
       hist-item.qtd-emb-ant = IF NOT AVAIL b01-hist-item THEN 0         ELSE b01-hist-item.qtd-emb-ant
       hist-item.qtd-emb-atu = item-dun.qtd-emb
       hist-item.cod-ean-ant = ''
       hist-item.cod-ean-atu = ''
       hist-item.data        = TODAY 
       hist-item.hora        = STRING(TIME,'HH:MM:SS')
       hist-item.usuario     = c-seg-usuario
       hist-item.programa-alt = PROGRAM-NAME(1) + ' - ' + PROGRAM-NAME(2) + ' - ' +             
                                PROGRAM-NAME(3) + ' - ' + PROGRAM-NAME(4) + ' - ' +
                                PROGRAM-NAME(5) + ' - ' + PROGRAM-NAME(6) + ' - ' +
                                PROGRAM-NAME(7) + ' - ' + PROGRAM-NAME(8) + ' - ' +
                                PROGRAM-NAME(9) + ' - ' + PROGRAM-NAME(10).
  


RETURN "OK".
       
       
