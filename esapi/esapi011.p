/***********************************************************************
**  Programa..: esapi/esapi011
**  Autor.....: Marcio Chaves - Gestech
**  Data......: NOVEMBRO/2004 - Desenvolvimento
**  Descricao.: Mostra Saldo da estrutura
**  VersÆo....: 001 14/01/2005
**                  Desenvolvimento Programa
************************************************************************/
/****************************  Temp-Tables  ****************************/
{esapi/esapi006tt.i}
{utp/ut-glob.i}
{cdp/cd0666.i}
{esp/pdp/espdp006fn.i}

/****************************  Variaveis    ****************************/
def input param pCodEstabel as char no-undo.
DEF INPUT  PARAM pItCodigo     LIKE item.it-codigo      NO-UNDO.
DEF INPUT  PARAM pCodDepos     LIKE ITEM.deposito-pad   NO-UNDO.
DEF INPUT  PARAM pCodLocaliz   LIKE ITEM.cod-refer      NO-UNDO.
DEF OUTPUT PARAM pQtSaldo      AS DEC                   NO-UNDO.

DEF BUFFER b-item FOR item.
DEFINE VARIABLE de-saldo AS DECIMAL    NO-UNDO.

FOR FIRST param-estoq NO-LOCK: END.

FOR FIRST ITEM NO-LOCK
    WHERE ITEM.it-codigo = pItCodigo:
    ASSIGN de-saldo = 9999999.
    RUN piVarreEstrutura(input pcodEstabel,
                         INPUT-OUTPUT pQtSaldo).

    RUN PiBuscaSaldo(INPUT 1, /* PAI */
                     INPUT ITEM.it-codigo,
                     INPUT item.cod-refer).


    IF pQtSaldo = 9999999  THEN
        ASSIGN pQtSaldo = 0.
    ASSIGN pQtSaldo = pQtSaldo + de-saldo.

END.

PROCEDURE piVarreEstrutura:
    def input param pCodEstabel as char no-undo.
    DEFINE INPUT-OUTPUT PARAM pQtSaldo  AS DEC.

    FOR EACH tt-estrutura. DELETE tt-estrutura. END.

    RUN esapi/esapi006.p ( INPUT ROWID(ITEM),  /* Rowid */
                           INPUT "",           /* Refer */
                           INPUT 1,            /* Quantidade */
                           INPUT 0,            /* Quantidade Liq */
                           INPUT 0,            /* N¡vel */
                           INPUT-OUTPUT TABLE tt-estrutura,
                           INPUT TODAY,        /* Data Corte */
                           INPUT YES,          /* Recursivo */
                           INPUT 19,           /* N¡veis */
                           INPUT pCodEstabel). /* Estabel */
    
    ASSIGN pQtSaldo = de-saldo.
    FOR EACH  tt-estrutura
        WHERE NOT tt-estrutura.log-fantasma:
        FIND b-ITEM
             WHERE b-ITEM.it-codigo = tt-estrutura.es-codigo NO-LOCK NO-ERROR.
        IF AVAIL b-ITEM AND b-ITEM.baixa-estoq = YES THEN DO:

            RUN PiBuscaSaldo(INPUT 2, /* COMPONENTE */
                             INPUT tt-estrutura.es-codigo,
                             INPUT tt-estrutura.refer).

            IF  de-saldo > pQtSaldo  THEN
                ASSIGN pQtSaldo = pQtSaldo.
            ELSE 
                ASSIGN pQtSaldo = de-saldo.

        END.
    END.
END.

PROCEDURE PiBuscaSaldo:
    DEFINE INPUT PARAM pTipo     AS   INTEGER               NO-UNDO.
    DEFINE INPUT PARAM pItCodigo LIKE saldo-estoq.it-codigo NO-UNDO.
    DEFINE INPUT PARAM pCodRefer LIKE saldo-estoq.cod-refer NO-UNDO.

    DEF VAR vSaldoDisp LIKE saldo-estoq.qtidade-atu NO-UNDO.

    ASSIGN de-saldo = 0.

    IF  pTipo = 1 THEN
        ASSIGN de-saldo  = de-saldo + fnEstoque(pCodEstabel,pItCodigo, pCodDepos,"*", YES).
    ELSE DO: 
        /*A fun‡Æo abaixo trata a localiza‡Æo "*" como "todas"*/
        ASSIGN vSaldoDisp = fnEstoque(pCodEstabel,pItCodigo, pCodDepos,"*", NO).

        ASSIGN de-saldo = de-saldo + (vSaldoDisp / tt-estrutura.quant-usada).
    END.
END.
