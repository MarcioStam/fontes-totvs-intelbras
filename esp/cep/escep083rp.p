/***********************************************************************
**  Programa..: esp/cep/escep083rp.p
**  Autor.....: Nicolas Martinez
**  Data......: Junho/2019 - Desenvolvimento
**  Descricao.: Lotes vencidos por item acabado
**  Versao....: 001 04/06/2019
**                  Desenvolvimento Programa
************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i escep083rp 1.00.00.00}

/****************************  Definitions  ****************************/

{esp/cep/escep083tt.i}

DEFINE TEMP-TABLE tt-raw-digita NO-UNDO
    FIELD raw-digita	   AS RAW.

DEFINE STREAM str-excel.

{utp/ut-glob.i}
{include/i-rpvar.i}
{esapi/esapi006tt.i} /*** tt-estrutura ***/

/****************************  Temp-Tables  ****************************/


/****************************  Frames       ****************************/

DEF INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEF INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param to tt-param.
      
DEFINE VARIABLE h-acomp       AS HANDLE    NO-UNDO.

FOR FIRST param-global NO-LOCK. END.

FOR FIRST empresa NO-LOCK
    WHERE empresa.ep-codigo = param-global.empresa-pri: END.
FIND FIRST tt-param NO-ERROR.

FOR EACH tt-raw-digita:
    CREATE tt-digita.
    RAW-TRANSFER tt-raw-digita.raw-digita TO tt-digita.
END.

{cdp/cd0666.i} /*tt-erro*/
/*{esp/pdp/espdp006fn.i} Comentado porque n∆o esta tratando o saldo a nivel de lote */


/* include padr∆o para output de relat¢rios */
{include/i-rpout.i}

/* include com a definiá∆o da frame de cabeáalho e rodapÇ */
{include/i-rpcab.i}

assign c-sistema      = "Espec°ficos Intelbras"
       c-titulo-relat = "Listagem de Lotes vencidos por estrutura"
       c-empresa      = if avail empresa then empresa.razao-social else ''
       c-programa     = "ESCEP083"
       c-versao       = "1.00"
       c-revisao      = "001".

IF tt-param.destino <> 4 THEN DO:
    VIEW FRAME f-cabec.
    VIEW FRAME f-rodape.
END.

/* para n∆o visualizar cabeªalho/rodapÇ em sa≠da RTF */
IF tt-param.destino <> 4 THEN DO:
    VIEW FRAME f-cabec.
    VIEW FRAME f-rodape.
END.

/* executando de forma persistente o utilitˇrio de acompanhamento */
RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
{utp/ut-liter.i Imprimindo *}
RUN pi-inicializar IN h-acomp (INPUT RETURN-VALUE).

EMPTY TEMP-TABLE tt-estrutura.

FOR EACH ITEM WHERE
         ITEM.it-codigo >= tt-param.item-ini
     AND ITEM.it-codigo <= tt-param.item-fim
         NO-LOCK.

    run pi-acompanhar in h-acomp (input "Item: " + ITEM.it-codigo).
    RUN esapi/esapi006.p ( INPUT ROWID(ITEM),  /* Rowid */
                           INPUT "",           /* Refer */
                           INPUT 1,            /* Quantidade */
                           INPUT 0,            /* Quantidade Liq */
                           INPUT 0,            /* N≠vel */
                           INPUT-OUTPUT TABLE tt-estrutura,
                           INPUT TODAY,        /* Data Corte */
                           INPUT YES,          /* Recursivo */
                           INPUT 19,           /* N≠veis */
                           INPUT tt-param.estabel-ini).       /* Estabel */
    
    
    FOR EACH  tt-estrutura no-lock:
        if tt-estrutura.log-fantasma = no then do:   

            FOR EACH saldo-estoq NO-LOCK
                 WHERE saldo-estoq.it-codigo    = tt-estrutura.es-codigo
                   AND saldo-estoq.cod-depos   >= tt-param.deposito-ini
                   AND saldo-estoq.cod-depos   <= tt-param.deposito-fim
                   AND saldo-estoq.cod-localiz >= tt-param.localiza-ini
                   AND saldo-estoq.cod-localiz <= tt-param.localiza-fim
                   AND saldo-estoq.cod-estabel  = tt-param.estabel-ini      
                   AND saldo-estoq.qtidade-atu  > 0:

                run pi-acompanhar in h-acomp (input "Item: " + ITEM.it-codigo + " / Lote: " + saldo-estoq.lote).

                IF saldo-estoq.dt-vali-lote < TODAY 
                   THEN DISP tt-estrutura.it-codigo   COLUMN-LABEL "Item Pai"
                             saldo-estoq.it-codigo    COLUMN-LABEL "Item Estrutura"
                             saldo-estoq.cod-depos    COLUMN-LABEL "Deposito"
                             saldo-estoq.lote         COLUMN-LABEL "Lote"
                             saldo-estoq.dt-vali-lote COLUMN-LABEL "Data Validade"
                             WITH FRAME f-lote WIDTH 132 DOWN STREAM-IO .
            END.

        END.
    END.
END.
            
/*fechamento do output do relatΩrio*/
{include/i-rpclo.i}
RUN pi-finalizar IN h-acomp.
RETURN "OK":U.
