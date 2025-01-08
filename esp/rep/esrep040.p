/*********************************************************************************
 Programa: engine_item.p
 Objetivo: Engine de regras para traducao do item
 Autor   : Catia Schmauch
 Data    : Janeiro de 2017
*********************************************************************************/ 
{utp/ut-glob.i}

/** Erros **/
DEFINE TEMP-TABLE RowErrors     NO-UNDO
    FIELD ErrorSequence         AS INTEGER
    FIELD ErrorNumber           AS INTEGER
    FIELD ErrorDescription      AS CHARACTER
    FIELD ErrorParameters       AS CHARACTER
    FIELD ErrorType             AS CHARACTER
    FIELD ErrorHelp             AS CHARACTER
    FIELD ErrorSubType          AS CHARACTER
    index seq ErrorSequence.


DEFINE TEMP-TABLE tt-variavel
    FIELD cod-var-oper          LIKE config-var-operac-regra-cond.cod-variavel
    FIELD valor-variavel        LIKE config-var-operac-regra-cond.cod-val-var.

DEFINE TEMP-TABLE tt-retorno
    FIELD valor-retorno         LIKE config-var-operac-regra-ret.cod-val-ret
    FIELD campo-retorno         LIKE config-var-operac-regra-ret.cod-campo-ret
    FIELD perc-rateio           LIKE config-var-operac-regra-ret.cdd-perc-rat.


DEF INPUT PARAM p-ep-codigo     LIKE config-operac.cdn-empresa.
DEF INPUT PARAM p-cod-estabel   LIKE config-operac.cod-estab.
DEF INPUT PARAM p-cod-tipo-oper LIKE config-operac.cod-tip-operac.
DEF INPUT  PARAM TABLE          FOR tt-variavel.
DEF OUTPUT PARAM TABLE          FOR tt-retorno.
DEF OUTPUT PARAM TABLE          FOR RowErrors.

IF  p-cod-tipo-oper = 'nfe-it-codigo' THEN DO:
    
    FIND FIRST tt-variavel 
         WHERE tt-variavel.cod-var-oper = 'it-codigo' NO-LOCK NO-ERROR.
     
    IF  AVAIL tt-variavel THEN DO:
        FIND FIRST item-fabric 
             WHERE item-fabric.it-fabric = STRING(tt-variavel.valor-variavel) NO-LOCK NO-ERROR.
        
        IF  AVAIL item-fabric THEN
            FIND FIRST int-item-for-PN NO-LOCK
                WHERE int-item-for-PN.it-codigo    = item-fabric.it-codigo
                AND   int-item-for-PN.item-do-forn = string(item-fabric.cod-fabric) NO-ERROR.

        IF AVAIL int-item-for-PN THEN DO:
           FIND FIRST ITEM 
                WHERE ITEM.it-codigo = item-fabric.it-codigo NO-LOCK NO-ERROR.
           IF AVAIL ITEM AND ITEM.demanda = 1 THEN DO: /* item de demanda dependente */
              CREATE tt-retorno.
              ASSIGN tt-retorno.valor-retorno = int-item-for-PN.it-codigo
                     tt-retorno.campo-retorno = 'it-codigo'
                     tt-retorno.perc-rateio   = 100.
           
           END.
           ELSE DO:
               CREATE rowerrors.
               ASSIGN ErrorSequence    = 1
                      ErrorNumber      = 1
                      ErrorDescription = 'Item de demanda independente.'
                    .
           END.
        END.
        ELSE DO:
            CREATE rowerrors.
            ASSIGN ErrorSequence    = 2
                   ErrorNumber      = 2
                   ErrorDescription = 'Relacionamento item x fabricante x fornecedor nao encontrado.'
                 .
        END.
    END.
END.

IF p-cod-tipo-oper = 'nfse-serie-docto' THEN DO:

    FIND FIRST tt-variavel 
        WHERE tt-variavel.cod-var-oper = 'serie-docto' NO-LOCK NO-ERROR.
     
    IF  AVAIL tt-variavel THEN DO:
        CREATE tt-retorno.
        ASSIGN tt-retorno.valor-retorno = ENTRY(1,tt-variavel.valor-variavel,";")
               tt-retorno.campo-retorno = 'serie-docto'
               tt-retorno.perc-rateio   = 100.

        CREATE tt-retorno.
        ASSIGN tt-retorno.valor-retorno = ENTRY(2,tt-variavel.valor-variavel,";")
               tt-retorno.campo-retorno = 'num-pedido'
               tt-retorno.perc-rateio   = 100.

        FIND FIRST pedido-compr
            WHERE pedido-compr.num-pedido = int(ENTRY(2,tt-variavel.valor-variavel,";")) NO-LOCK NO-ERROR.
        
        IF  AVAIL pedido-compr THEN DO:

            FIND FIRST ordem-compra OF pedido-compr
                WHERE ordem-compra.situacao <> 4 NO-LOCK NO-ERROR.

            IF  AVAIL ordem-compra THEN DO:
                CREATE tt-retorno.
                ASSIGN tt-retorno.valor-retorno = string(ordem-compra.numero-ordem)
                       tt-retorno.campo-retorno = 'num-ordem'
                       tt-retorno.perc-rateio   = 100.
            END.
        END.
    END.
END.
