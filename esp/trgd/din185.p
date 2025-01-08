DEF PARAM BUFFER b-item-tab  FOR item-tab.                          

{utp/ut-glob.i}

FIND FIRST tb-pr-cc NO-LOCK
    WHERE tb-pr-cc.cod-emitente = b-item-tab.cod-emitente
      AND tb-pr-cc.cdn-fabrican = b-item-tab.cdn-fabrican
      AND tb-pr-cc.cod-cond-pag = b-item-tab.cod-cond-pag
      AND tb-pr-cc.nr-tab       = b-item-tab.nr-tab
      AND tb-pr-cc.dt-inicio    = b-item-tab.dt-inicio NO-ERROR.

CREATE int-item-tab.
ASSIGN int-item-tab.cod-emitente   = b-item-tab.cod-emitente  
       int-item-tab.cdn-fabrican   = b-item-tab.cdn-fabrican  
       int-item-tab.des-referencia = b-item-tab.des-referencia
       int-item-tab.cod-cond-pag   = b-item-tab.cod-cond-pag  
       int-item-tab.nr-tab         = b-item-tab.nr-tab        
       int-item-tab.dt-inicio      = b-item-tab.dt-inicio     
       int-item-tab.it-codigo      = b-item-tab.it-codigo     
       int-item-tab.quant-min      = b-item-tab.quant-min     
       int-item-tab.data           = TODAY
       int-item-tab.hora           = STRING(TIME, "HH:MM")
       int-item-tab.cod-usuario    = c-seg-usuario.

ASSIGN int-item-tab.tipo = 3 /*Elimina‡Æo*/
       int-item-tab.pr-item-atual = b-item-tab.pr-item.
       int-item-tab.pr-item-novo  = b-item-tab.pr-item.

ASSIGN int-item-tab.justificativa = "Elimina‡Æo da Registro do item".
       int-item-tab.data_limite = ?.

IF  AVAIL tb-pr-cc THEN
    ASSIGN int-item-tab.mo-codigo  = tb-pr-cc.mo-codigo
           int-item-tab.descricao  = tb-pr-cc.descricao
           int-item-tab.dt-termino = tb-pr-cc.dt-termino
           int-item-tab.situacao   = tb-pr-cc.situacao.

RETURN "OK".
