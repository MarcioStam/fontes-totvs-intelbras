/*****************************************************************************
** Programa: epc\acr240aa_epc.p - bas_tit_acr_em_aberto
** VersÆo..: 1.00
** Data....: 26/01/2011
** Autor...: Estevan Krger - Exponencial TI
** Obs.....: EPC para inclusÆo da faixa Grupo de Cobran‡a
*****************************************************************************/


/*--- Defini‡Æo dos Parƒmetros ---*/
DEFINE INPUT PARAMETER p-ind-event    AS CHARACTER          NO-UNDO.
DEFINE INPUT PARAMETER p-ind-object   AS CHARACTER          NO-UNDO.
DEFINE INPUT PARAMETER p-wgh-object   AS HANDLE             NO-UNDO.
DEFINE INPUT PARAMETER p-wgh-frame    AS WIDGET-HANDLE      NO-UNDO.
DEFINE INPUT PARAMETER p-cod-table    AS CHARACTER          NO-UNDO.
DEFINE INPUT PARAMETER p-rec-table    AS RECID              NO-UNDO.



/*--- Defini‡Æo das Vari veis Globais ---*/
DEFINE NEW GLOBAL SHARED VARIABLE g-cod-grp-cobr-ini-acr240aa  AS INTEGER        NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE g-cod-grp-cobr-fim-acr240aa  AS INTEGER        NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE text-grp-cobr-acr240aa       AS WIDGET-HANDLE  NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE text-ate-acr240aa            AS WIDGET-HANDLE  NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-cod-grp-cobr-ini-acr240aa AS WIDGET-HANDLE  NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-cod-grp-cobr-fim-acr240aa AS WIDGET-HANDLE  NO-UNDO.



/*--- Bloco Principal ---*/
IF  p-ind-event = "INITIALIZE":U THEN DO:
    CREATE TEXT text-grp-cobr-acr240aa
    ASSIGN FRAME        = p-wgh-frame
           FORMAT       = "x(15)"
           WIDTH        = 12
           SCREEN-VALUE = "Grp Cobran‡a:"
           ROW          = 4.8
           COL          = 37
           VISIBLE      = YES
           FONT         = 1.

    CREATE FILL-IN wh-cod-grp-cobr-ini-acr240aa
    ASSIGN FRAME             = p-wgh-frame
           SIDE-LABEL-HANDLE = text-grp-cobr-acr240aa:HANDLE
           DATA-TYPE         = "INTEGER"
           FORMAT            = ">9"
           WIDTH             = 4
           HEIGHT            = 0.88
           ROW               = 4.65
           COL               = 47.3
           LABEL             = "Grp Cobran‡a:"
           VISIBLE           = YES
           SENSITIVE         = YES
           BGCOLOR           = 15
           FONT              = 1.


    CREATE TEXT text-ate-acr240aa
    ASSIGN FRAME        = p-wgh-frame
           FORMAT       = "x(04)"
           WIDTH        = 6
           SCREEN-VALUE = "at‚:"
           ROW          = 4.8
           COL          = 54
           VISIBLE      = YES
           FONT         = 1.

    CREATE FILL-IN wh-cod-grp-cobr-fim-acr240aa
    ASSIGN FRAME             = p-wgh-frame
           SIDE-LABEL-HANDLE = text-ate-acr240aa:HANDLE
           DATA-TYPE         = "INTEGER"
           FORMAT            = ">9"
           WIDTH             = 4
           HEIGHT            = 0.88
           ROW               = 4.65
           COL               = 57
           LABEL             = "at‚:"
           VISIBLE           = YES
           SENSITIVE         = YES
           BGCOLOR           = 15
           FONT              = 1.

    IF  VALID-HANDLE(wh-cod-grp-cobr-fim-acr240aa) THEN
        ASSIGN wh-cod-grp-cobr-fim-acr240aa:SCREEN-VALUE = "99".
END.


IF  p-ind-event = "VALIDA TITULO" THEN DO:
    IF  VALID-HANDLE(wh-cod-grp-cobr-ini-acr240aa) AND
        VALID-HANDLE(wh-cod-grp-cobr-fim-acr240aa) THEN DO:
        RUN epc/epc_valida_titulo.p (INPUT p-rec-table,
                                     INPUT INT(wh-cod-grp-cobr-ini-acr240aa:SCREEN-VALUE),
                                     INPUT INT(wh-cod-grp-cobr-fim-acr240aa:SCREEN-VALUE)).
        RETURN RETURN-VALUE.
    END.
END.

