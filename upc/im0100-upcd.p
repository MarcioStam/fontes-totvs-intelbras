/*------------------------------------------------------------------------
    File        : IM0100-UPCD.P
    Purpose     : Realizar validaá∆o ao clicar no bot∆o "Pesos e cubagem"
                  da tela IM0100.
    Syntax      : <none>
    Description : <none>

    Author(s)   : Fabiano Sakae Ribeiro (Exponencial TI)
    Created     : Dezembro de 2012
    Notes       : <none>
----------------------------------------------------------------------*/
DEFINE NEW GLOBAL SHARED VARIABLE wh-cod-estabel-im0100      AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-cod-estabel-fisc-im0100 AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-btpesoscubagem-im0100   AS HANDLE        NO-UNDO.

IF wh-cod-estabel-im0100:SCREEN-VALUE = wh-cod-estabel-fisc-im0100:SCREEN-VALUE THEN
    APPLY "CHOOSE":U TO wh-btpesoscubagem-im0100.
ELSE DO:
    RUN utp/ut-msgs.p (INPUT "SHOW":U,
                       INPUT 17006,
                       INPUT "Estabelecimentos incompat°veis.":U +
                             "~~":U +
                             "Estabelecimento Fiscal deve ser o mesmo que o Estabelecimento de Entrada":U).

    RETURN "NOK":U.
END.


