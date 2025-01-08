/***********************************************************************
**  Programa..: ESP\CSP\ESCSP008RP.P
**  Autor.....: Raphael Matei Paini
**  Data......: Setembro/2009 - Desenvolvimento
**  Descricao.: Ordem de produá∆o sem REQ ou sem ACA
**  Vers∆o....: 001 21/09/2009
**                  Desenvolvimento Programa
************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i ESCSP008 2.04.00.000}

/****************************  Definitions  ****************************/
{esp/csp/escsp008tt.i}
{include/i-rpvar.i}

/****************************  Temp-Tables  ****************************/
DEF TEMP-TABLE tt-ord-prod NO-UNDO
    FIELD tipo        AS INTEGER
    FIELD nr-ord-prod LIKE ord-prod.nr-ord-prod
    FIELD dt-emissao  LIKE ord-prod.dt-emissao
    FIELD it-codigo   LIKE ord-prod.it-codigo
    FIELD cod-estabel AS CHARACTER FORMAT "x(03)"
    FIELD estado      AS CHARACTER FORMAT "x(12)"
    FIELD cod-depos   LIKE ord-prod.cod-depos
    INDEX chave  tipo 
    INDEX chave2 nr-ord-prod
    INDEX chave3 cod-estabel nr-ord-prod.

/****************************  Variaveis    ****************************/
/****************************  Frames       ****************************/

def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

def var h-acomp      as handle no-undo.
DEFINE VARIABLE c-lista-estado  AS CHARACTER                    NO-UNDO.
DEFINE VARIABLE dea-valor-mat-m LIKE movto-estoq.valor-mat-m[1] NO-UNDO.
DEFINE VARIABLE dea-valor-mob-m LIKE movto-estoq.valor-mob-m[1] NO-UNDO.
DEFINE VARIABLE dea-valor-ggf-m LIKE movto-estoq.valor-ggf-m[1] NO-UNDO.
DEFINE VARIABLE der-valor-mat-m LIKE movto-estoq.valor-mat-m[1] NO-UNDO.
DEFINE VARIABLE der-valor-mob-m LIKE movto-estoq.valor-mob-m[1] NO-UNDO.
DEFINE VARIABLE der-valor-ggf-m LIKE movto-estoq.valor-ggf-m[1] NO-UNDO.

ASSIGN c-lista-estado = "N∆o Iniciada,Liberada,Alocada,Separada,Requisitada,Iniciada,Finalizada,Terminada".

FOR FIRST param-global NO-LOCK. END.
FOR FIRST empresa NO-LOCK
    WHERE empresa.ep-codigo = param-global.empresa-pri: END.

assign c-sistema      = "Espec°ficos Intelbras"
       c-titulo-relat = "Ordens Produá∆o sem REQ/ACA"
       c-empresa      = if avail empresa then empresa.razao-social else ''
       c-programa     = "ESCSP008"
       c-versao       = "2.04"
       c-revisao      = "000".

/* ***************************  Main Block  *************************** */

FOR EACH tt-ord-prod:
    DELETE tt-ord-prod.
END.

do on stop undo, leave:
    {include/i-rpcab.i}
    {include/i-rpout.i}

    run utp/ut-acomp.p persistent set h-acomp.  

    run pi-inicializar in h-acomp (input "Imprimindo...").

    VIEW FRAME f-cabec.
    VIEW FRAME f-rodape.

    run piImprimeRelat.

    run pi-finalizar in h-acomp.

    {include/i-rpclo.i}

    RETURN "OK".
end.

/*****************************************************************************************
**
** PROCEDURES INTERNAS
**
*****************************************************************************************/
PROCEDURE piImprimeRelat:
    DEF VAR l-existe-aca AS LOG NO-UNDO.
    DEF VAR l-existe-req AS LOG NO-UNDO.

    DEFINE VARIABLE de-quant-aca AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE de-quant-eac AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE de-quant-req AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE de-quant-dev AS DECIMAL     NO-UNDO.

    FOR EACH ord-prod NO-LOCK USE-INDEX item-emis
       WHERE ord-prod.cod-estabel  >= tt-param.cod-estabel-ini
         AND ord-prod.cod-estabel  <= tt-param.cod-estabel-fim
         AND ord-prod.it-codigo    >= tt-param.it-codigo-ini
         AND ord-prod.it-codigo    <= tt-param.it-codigo-fim
         AND ord-prod.nr-ord-produ >= tt-param.nr-ord-produ-ini
         AND ord-prod.nr-ord-produ <= tt-param.nr-ord-produ-fim
         AND ord-prod.dt-emissao   >= tt-param.dt-emissao-ini
         AND ord-prod.dt-emissao   <= tt-param.dt-emissao-fim:

        RUN pi-acompanhar IN h-acomp ("Item: " + TRIM(ord-prod.it-codigo) + " - Data: " + STRING(ord-prod.dt-emissao,"99/99/99") + " - Ordem: " + STRING(ord-prod.nr-ord-produ)  ).
         
        ASSIGN l-existe-aca    = NO
               l-existe-req    = NO
               de-quant-aca    = 0
               de-quant-eac    = 0
               de-quant-req    = 0
               de-quant-dev    = 0
               dea-valor-mat-m = 0
               dea-valor-mob-m = 0
               dea-valor-ggf-m = 0
               der-valor-mat-m = 0
               der-valor-mob-m = 0
               der-valor-ggf-m = 0.

        FOR EACH movto-estoq
           WHERE movto-estoq.nr-ord-prod = ord-prod.nr-ord-prod NO-LOCK:

            /*ACA*/
            IF movto-estoq.esp-docto   = 1 AND 
               movto-estoq.dt-trans   >= tt-param.dt-emissao-ini AND
               movto-estoq.dt-trans   <= tt-param.dt-emissao-fim THEN DO:
                ASSIGN l-existe-aca    = YES
                       de-quant-aca    = de-quant-aca    + movto-estoq.quantidade
                       dea-valor-mat-m = dea-valor-mat-m + movto-estoq.valor-mat-m[1]
                       dea-valor-mob-m = dea-valor-mob-m + movto-estoq.valor-mob-m[1]
                       dea-valor-ggf-m = dea-valor-ggf-m + movto-estoq.valor-ggf-m[1].
            END.

            /*EAC*/
            IF movto-estoq.esp-docto   = 8 AND 
               movto-estoq.dt-trans   >= tt-param.dt-emissao-ini AND
               movto-estoq.dt-trans   <= tt-param.dt-emissao-fim THEN DO:
                ASSIGN l-existe-aca = YES
                       de-quant-eac = de-quant-eac + movto-estoq.quantidade.
            END.

            /*REQ*/
            IF movto-estoq.esp-docto   = 28 AND 
               movto-estoq.dt-trans   >= tt-param.dt-emissao-ini AND
               movto-estoq.dt-trans   <= tt-param.dt-emissao-fim THEN DO:
                ASSIGN l-existe-req    = YES
                       de-quant-req    = de-quant-req + movto-estoq.quantidade
                       der-valor-mat-m = der-valor-mat-m + movto-estoq.valor-mat-m[1]
                       der-valor-mob-m = der-valor-mob-m + movto-estoq.valor-mob-m[1]
                       der-valor-ggf-m = der-valor-mob-m + movto-estoq.valor-ggf-m[1].
            END.

            /*DEV*/
            IF movto-estoq.esp-docto   = 5 AND 
               movto-estoq.dt-trans   >= tt-param.dt-emissao-ini AND
               movto-estoq.dt-trans   <= tt-param.dt-emissao-fim THEN DO:
                ASSIGN l-existe-req = YES
                       de-quant-dev = de-quant-dev + movto-estoq.quantidade.
            END.

            /*IF l-existe-aca AND l-existe-req THEN LEAVE.*/
        END.

        IF (l-existe-aca AND NOT l-existe-req AND de-quant-aca <> de-quant-eac) OR
           (l-existe-aca AND de-quant-aca = 0 AND (dea-valor-mat-m <> 0 OR dea-valor-mob-m <> 0 OR dea-valor-ggf-m <> 0)) THEN DO:
            CREATE tt-ord-prod.
            ASSIGN tt-ord-prod.tipo        = 2
                   tt-ord-prod.nr-ord-prod = ord-prod.nr-ord-prod
                   tt-ord-prod.dt-emissao  = ord-prod.dt-emissao
                   tt-ord-prod.it-codigo   = ord-prod.it-codigo
                   tt-ord-prod.cod-estabel = ord-prod.cod-estabel
                   tt-ord-prod.estado      = ENTRY(ord-prod.estado,c-lista-estado)
                   tt-ord-prod.cod-depos   = ord-prod.cod-depos.
        END.

        IF (l-existe-req AND NOT l-existe-aca AND de-quant-req <> de-quant-dev) OR
           (l-existe-req AND de-quant-req = 0 AND (der-valor-mat-m <> 0 OR der-valor-mob-m <> 0 OR der-valor-ggf-m <> 0)) THEN DO:
            CREATE tt-ord-prod.
            ASSIGN tt-ord-prod.tipo        = 1
                   tt-ord-prod.nr-ord-prod = ord-prod.nr-ord-prod
                   tt-ord-prod.dt-emissao  = ord-prod.dt-emissao
                   tt-ord-prod.it-codigo   = ord-prod.it-codigo
                   tt-ord-prod.cod-estabel = ord-prod.cod-estabel
                   tt-ord-prod.estado      = ENTRY(ord-prod.estado,c-lista-estado)
                   tt-ord-prod.cod-depos   = ord-prod.cod-depos.
        END.
    END.

    IF CAN-FIND(FIRST tt-ord-prod NO-LOCK WHERE tt-ord-prod.tipo = 1) THEN DO:
        PUT UNFORMATTED 
            "Ordem Produá∆o sem ACA: " SKIP(1)
            "Est   Nr. Ordem Dt.Emiss∆o Estado Ordem Item             Dep¢sito" SKIP
            "--- ----------- ---------- ------------ ---------------- --------" SKIP.
        FOR EACH tt-ord-prod NO-LOCK WHERE tt-ord-prod.tipo = 1
            BY tt-ord-prod.cod-estabel BY tt-ord-prod.nr-ord-prod:
            PUT UNFORMATTED
                tt-ord-prod.cod-estabel                     AT 01
                tt-ord-prod.nr-ord-prod                     TO 15
                tt-ord-prod.dt-emissao FORMAT "99/99/9999"  AT 17
                tt-ord-prod.estado                          AT 28
                tt-ord-prod.it-codigo  FORMAT "x(16)"       AT 41 
                tt-ord-prod.cod-depos                       AT 58 SKIP.
        END.
    END.


    IF CAN-FIND(FIRST tt-ord-prod NO-LOCK WHERE tt-ord-prod.tipo = 2) THEN DO:
        PUT UNFORMATTED SKIP(1)
            "Ordem Produá∆o sem REQ: " SKIP(1)
            "Est   Nr. Ordem Dt.Emiss∆o Estado Ordem Item             Dep¢sito" SKIP
            "--- ----------- ---------- ------------ ---------------- --------" SKIP.

        FOR EACH tt-ord-prod NO-LOCK WHERE tt-ord-prod.tipo = 2
            BY tt-ord-prod.cod-estabel BY tt-ord-prod.nr-ord-prod:
            PUT UNFORMATTED
                tt-ord-prod.cod-estabel                     AT 01
                tt-ord-prod.nr-ord-prod                     TO 15
                tt-ord-prod.dt-emissao FORMAT "99/99/9999"  AT 17
                tt-ord-prod.estado                          AT 28
                tt-ord-prod.it-codigo  FORMAT "x(16)"       AT 41 
                tt-ord-prod.cod-depos                       AT 58 SKIP.
        END.
    END.

END PROCEDURE.

/**** Fim do programa ****/
