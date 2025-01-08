//DEF PARAM BUFFER b-item-dun  FOR item-dun.                          
TRIGGER PROCEDURE FOR DELETE OF item-dun.  

DEF NEW GLOBAL SHARED VAR c-seg-usuario AS CHAR NO-UNDO.

{utp/ut-glob.i}       

CREATE hist-item.
ASSIGN hist-item.it-codigo   = item-dun.it-codigo
       hist-item.tipo        = 'DUN14'
       hist-item.acao        = "Eliminou"
       hist-item.digito-ant  = 0
       hist-item.digito-atu  = item-dun.digito
       hist-item.cod-dun-atu = item-dun.cod-dun
       hist-item.cod-dun-ant = ''
       hist-item.cod-dun-atu = item-dun.cod-dun      
       hist-item.qtd-emb-ant = 0
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



RETURN 'OK'.
