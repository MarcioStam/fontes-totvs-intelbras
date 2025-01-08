/***********************************************************************
**  Programa..: upc\re1001d-upc.p
**  Autor.....: Anderson Silvano  - Gestech
**  Data......: JUNHO/2005 - Desenvolvimento
**  Descricao.: 
**  Vers∆o....: 001 - 00/00/2002
**                  Desenvolvimento Programa
************************************************************************/

DEF INPUT PARAM p-ind-evento AS INTEGER NO-UNDO.

DEF NEW GLOBAL SHARED VAR wh-aliq-pis      AS HANDLE   NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-nat-oper      AS HANDLE   NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-natur-frete   AS HANDLE   NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-de-valor-desp AS HANDLE   NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-btcheck       AS HANDLE   NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-cb-tipo-cte   AS HANDLE   NO-UNDO.

IF  p-ind-evento = 1
THEN DO:
    IF  VALID-HANDLE(wh-natur-frete)
    THEN
        ASSIGN wh-natur-frete:SENSITIVE = NO.

    FOR FIRST natur-oper NO-LOCK
        WHERE natur-oper.nat-operacao = wh-nat-oper:SCREEN-VALUE:

        IF  natur-oper.tipo-compra = 2 /* Frete */
        THEN DO:
            IF  int(substr(natur-oper.char-1,86,1)) = 1 AND /* PIS Tributado    */
                int(substr(natur-oper.char-1,87,1)) = 1     /* COFINS Tributado */
            THEN
                ASSIGN wh-natur-frete:SCREEN-VALUE = "2".
            ELSE
                ASSIGN wh-natur-frete:SCREEN-VALUE = "3".

            ASSIGN wh-cb-tipo-cte:SCREEN-VALUE = "CT-e Normal"
                   wh-cb-tipo-cte:SENSITIVE    = NO.
        END.
        ASSIGN wh-cb-tipo-cte:SCREEN-VALUE = "".
    END.
END.

IF  p-ind-evento = 2
THEN DO:
    APPLY "LEAVE"  TO wh-de-valor-desp.
    APPLY "CHOOSE" TO wh-btcheck.
END.
    

RETURN "OK".
