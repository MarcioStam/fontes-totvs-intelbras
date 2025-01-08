/**
 * Extrator para BI
 * Fato: Planejamento de Demanda do item
 *
 * Autor: Hoepers
 */
 
create widget-pool.

{include/i-freeac.i}

/** Include com a temp table principal e a temp table de parƒmetros **/
{bi/fact017tt.i}
{bi/esbi000.i}

define input  parameter table for tt-param.
define output parameter table for ttFactPlanejamentoItem.
define output parameter table for tt-erro.

/****************************  Variaveis    ****************************/
DEFINE VARIABLE i-num-calc-plano  AS INTEGER NO-UNDO.
define variable dt-data           as date    no-undo.
define variable dt-inicial        as date    no-undo.
define variable dt-final          as date    no-undo.
DEFINE VARIABLE dt-final-calc     AS DATE    NO-UNDO.
DEFINE VARIABLE dt-prev-demanda   AS DATE    NO-UNDO.

find first tt-param NO-ERROR.

/** ConexÆo com o EMS para a execu‡Æo de BO **/
run bi/esbi002.p (tt-param.usuario, tt-param.senha).

EMPTY TEMP-TABLE ttFactPlanejamentoItem.
EMPTY TEMP-TABLE tt-reservas.
EMPTY TEMP-TABLE tt-estab-plano-prod.

assign dt-inicial    = date(month(tt-param.dt-inicial), 1, year(tt-param.dt-inicial))
       dt-final      = date(month(tt-param.dt-final), 1, year(tt-param.dt-final))
       dt-inicial    = add-interval(dt-inicial, 1, 'months') - 1
       dt-final      = add-interval(dt-final, 1, 'months') - 1
       dt-final-calc = dt-final.

assign dt-data = dt-inicial.
    
/** Gambi **/
if dt-final > today then
   assign dt-final = today.

/* Cria planos producao */
CREATE tt-estab-plano-prod.
ASSIGN tt-estab-plano-prod.cod-estabel = "101"
       tt-estab-plano-prod.cd-plano    = 1.

CREATE tt-estab-plano-prod.
ASSIGN tt-estab-plano-prod.cod-estabel = "103"
       tt-estab-plano-prod.cd-plano    = 29.

CREATE tt-estab-plano-prod.
ASSIGN tt-estab-plano-prod.cod-estabel = "104"
       tt-estab-plano-prod.cd-plano    = 888.

CREATE tt-estab-plano-prod.
ASSIGN tt-estab-plano-prod.cod-estabel = "105"
       tt-estab-plano-prod.cd-plano    = 5.

FOR EACH tt-estab-plano-prod NO-LOCK:
    RUN pi-le-reservas.
    RUN pi-le-plano-prod.
END.

repeat while dt-data <= dt-final:
    RUN pi-gera-planejamento.
    assign dt-data = date(month(dt-data), 1, year(dt-data))
           dt-data = add-interval(dt-data, 2, 'months') - 1.
end.

/** Se a data final tem que ser today, extrai s¢ isso aqui **/
if (dt-final = today) and (dt-final-calc <> today) 
then do:
   assign dt-data = today.
   RUN pi-gera-planejamento.
end.

PROCEDURE pi-le-reservas:
    FOR EACH reservas NO-LOCK
       WHERE reservas.estado = 1, /* Ativo */
       FIRST ord-prod NO-LOCK
       WHERE ord-prod.nr-ord-produ  = reservas.nr-ord-produ
         AND ord-prod.cod-estabel   = tt-estab-plano-prod.cod-estabel
         AND ord-prod.dt-inicio    >= tt-param.dt-inicial
         AND ord-prod.dt-inicio    <= tt-param.dt-final:

        FIND FIRST tt-reservas
            WHERE  tt-reservas.cod-estabel = ord-prod.cod-estabel
              AND  tt-reservas.it-codigo   = ord-prod.it-codigo
              AND  tt-reservas.cdn-mes     = MONTH(ord-prod.dt-inicio)
              AND  tt-reservas.cdn-ano     =  YEAR(ord-prod.dt-inicio) NO-ERROR.

        IF  NOT AVAIL tt-reservas
        THEN DO:
            CREATE tt-reservas.
            ASSIGN tt-reservas.cod-estabel = ord-prod.cod-estabel     
                   tt-reservas.it-codigo   = ord-prod.it-codigo       
                   tt-reservas.cdn-mes     = MONTH(ord-prod.dt-inicio)
                   tt-reservas.cdn-ano     =  YEAR(ord-prod.dt-inicio).
        END.
        ASSIGN tt-reservas.qtd-prev = tt-reservas.qtd-prev + (reservas.quant-orig - reservas.quant-atend).
    END.
END PROCEDURE.

PROCEDURE pi-le-plano-prod:
    FIND FIRST pl-prod NO-LOCK 
        WHERE  pl-prod.cd-plano = tt-estab-plano-prod.cd-plano NO-ERROR.

    ASSIGN i-num-calc-plano = IF AVAIL pl-prod THEN pl-prod.num-calc-plano ELSE 0.                                                                                    
    
    FOR EACH it-periodo NO-LOCK 
       WHERE it-periodo.num-calc-plano = i-num-calc-plano 
         AND it-periodo.cod-estabel    = tt-estab-plano-prod.cod-estabel
         AND it-periodo.data          >= tt-param.dt-inicial:

        FIND FIRST tt-reservas
            WHERE  tt-reservas.cod-estabel = it-periodo.cod-estabel
              AND  tt-reservas.it-codigo   = it-periodo.it-codigo
              AND  tt-reservas.cdn-mes     = MONTH(it-periodo.data)
              AND  tt-reservas.cdn-ano     =  YEAR(it-periodo.data) NO-ERROR.

        IF  NOT AVAIL tt-reservas
        THEN DO:
            CREATE tt-reservas.
            ASSIGN tt-reservas.cod-estabel = it-periodo.cod-estabel
                   tt-reservas.it-codigo   = it-periodo.it-codigo  
                   tt-reservas.cdn-mes         = MONTH(it-periodo.data)
                   tt-reservas.cdn-ano         =  YEAR(it-periodo.data).
        END.
        ASSIGN tt-reservas.qtd-prev = tt-reservas.qtd-prev + it-periodo.qt-res-plan.
    END.
END PROCEDURE.

PROCEDURE pi-gera-planejamento:
    FOR EACH tt-reservas NO-LOCK:

        ASSIGN dt-prev-demanda = date(tt-reservas.cdn-mes, 1, tt-reservas.cdn-ano).

        FIND FIRST ttFactPlanejamentoItem
            WHERE  ttFactPlanejamentoItem.cd_estabelecimento   = tt-reservas.cod-estabel
              AND  ttFactPlanejamentoItem.cd_item              = tt-reservas.it-codigo
              AND  ttFactPlanejamentoItem.dt_posicao  = dt-data
              AND  ttFactPlanejamentoItem.dt_planejado = dt-prev-demanda NO-ERROR.

        IF  NOT AVAIL ttFactPlanejamentoItem
        THEN DO:
            CREATE ttFactPlanejamentoItem.
            ASSIGN ttFactPlanejamentoItem.cd_estabelecimento   = fn-free-accent(upper(trim(tt-reservas.cod-estabel)))
                   ttFactPlanejamentoItem.cd_item              = fn-free-accent(upper(trim(tt-reservas.it-codigo)))    
                   ttFactPlanejamentoItem.dt_posicao  = dt-data                
                   ttFactPlanejamentoItem.dt_planejado = dt-prev-demanda.
        END.
        ASSIGN ttFactPlanejamentoItem.nm_previsao_demanda = ttFactPlanejamentoItem.nm_previsao_demanda + tt-reservas.qtd-prev.
    END.

END PROCEDURE.

