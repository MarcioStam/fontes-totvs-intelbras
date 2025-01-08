/*****************************************************************************
** Programa: epc\acr303za_epc.p - fnc_tit_acr_em_aber_faixa
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
DEFINE NEW GLOBAL SHARED VARIABLE g-cod-grp-cobr-ini-acr303za  AS INTEGER        NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE g-cod-grp-cobr-fim-acr303za  AS INTEGER        NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE text-grp-cobr-acr303za       AS WIDGET-HANDLE  NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE text-ate-acr303za            AS WIDGET-HANDLE  NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-cod-grp-cobr-ini-acr303za AS WIDGET-HANDLE  NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-cod-grp-cobr-fim-acr303za AS WIDGET-HANDLE  NO-UNDO.

def new global shared var v_cod_usuar_corren
    as character
    format "x(12)":U
    label "Usu rio Corrente"
    column-label "Usu rio Corrente"
    no-undo.


/*--- Bloco Principal ---*/
IF  p-ind-event = "INITIALIZE":U THEN DO:
    CREATE TEXT text-grp-cobr-acr303za
    ASSIGN FRAME        = p-wgh-frame
           FORMAT       = "x(15)"
           WIDTH        = 14
           SCREEN-VALUE = "Grupo Cobran‡a:"
           ROW          = 13.6
           COL          = 10
           VISIBLE      = YES
           FONT         = 1.

    CREATE FILL-IN wh-cod-grp-cobr-ini-acr303za
    ASSIGN FRAME             = p-wgh-frame
           SIDE-LABEL-HANDLE = text-grp-cobr-acr303za:HANDLE
           DATA-TYPE         = "INTEGER"
           FORMAT            = ">9"
           WIDTH             = 4
           HEIGHT            = 0.88
           ROW               = 13.5
           COL               = 21.8
           LABEL             = "Grupo Cobran‡a:"
           VISIBLE           = YES
           SENSITIVE         = YES
           BGCOLOR           = 15
           FONT              = 1.


    CREATE TEXT text-ate-acr303za
    ASSIGN FRAME        = p-wgh-frame
           FORMAT       = "x(04)"
           WIDTH        = 6
           SCREEN-VALUE = "at‚:"
           ROW          = 13.6
           COL          = 45.9
           VISIBLE      = YES
           FONT         = 1.

    CREATE FILL-IN wh-cod-grp-cobr-fim-acr303za
    ASSIGN FRAME             = p-wgh-frame
           SIDE-LABEL-HANDLE = text-ate-acr303za:HANDLE
           DATA-TYPE         = "INTEGER"
           FORMAT            = ">9"
           WIDTH             = 4
           HEIGHT            = 0.88
           ROW               = 13.5
           COL               = 48.8
           LABEL             = "at‚:"
           VISIBLE           = YES
           SENSITIVE         = YES
           BGCOLOR           = 15
           FONT              = 1.

    IF  VALID-HANDLE(wh-cod-grp-cobr-fim-acr303za) THEN
        ASSIGN wh-cod-grp-cobr-fim-acr303za:SCREEN-VALUE = "99".

    FIND dwb_rpt_param NO-LOCK
       WHERE dwb_rpt_param.cod_dwb_user    = v_cod_usuar_corren
         AND dwb_rpt_param.cod_dwb_program = "rel_tit_acr_em_aber" NO-ERROR.
    IF NUM-ENTRIES(dwb_rpt_param.cod_livre_1, CHR(10)) > 1 
       THEN ASSIGN wh-cod-grp-cobr-ini-acr303za:SCREEN-VALUE = ENTRY(1, dwb_rpt_param.cod_livre_1, CHR(10))
                   wh-cod-grp-cobr-fim-acr303za:SCREEN-VALUE = ENTRY(2, dwb_rpt_param.cod_livre_1, CHR(10)).

END.


IF  p-ind-event = "VALIDATE" THEN DO:
    IF  VALID-HANDLE(wh-cod-grp-cobr-ini-acr303za) AND
        VALID-HANDLE(wh-cod-grp-cobr-fim-acr303za) THEN
        ASSIGN g-cod-grp-cobr-ini-acr303za = INT(wh-cod-grp-cobr-ini-acr303za:SCREEN-VALUE)
               g-cod-grp-cobr-fim-acr303za = INT(wh-cod-grp-cobr-fim-acr303za:SCREEN-VALUE).

    IF  VALID-HANDLE(text-grp-cobr-acr303za) THEN DO:
        DELETE OBJECT text-grp-cobr-acr303za.
        ASSIGN text-grp-cobr-acr303za = ?.
    END.

    IF  VALID-HANDLE(wh-cod-grp-cobr-ini-acr303za) THEN DO:
        DELETE OBJECT wh-cod-grp-cobr-ini-acr303za.
        ASSIGN wh-cod-grp-cobr-ini-acr303za = ?.
    END.

    IF  VALID-HANDLE(text-ate-acr303za) THEN DO:
        DELETE OBJECT text-ate-acr303za.
        ASSIGN text-ate-acr303za = ?.
    END.

    IF  VALID-HANDLE(wh-cod-grp-cobr-fim-acr303za) THEN DO:
        DELETE OBJECT wh-cod-grp-cobr-fim-acr303za.
        ASSIGN wh-cod-grp-cobr-fim-acr303za = ?.
    END.

    FIND dwb_rpt_param EXCLUSIVE-LOCK
       WHERE dwb_rpt_param.cod_dwb_user    = v_cod_usuar_corren
         AND dwb_rpt_param.cod_dwb_program = "rel_tit_acr_em_aber" NO-ERROR.
    ASSIGN dwb_rpt_param.cod_livre_1 = STRING(g-cod-grp-cobr-ini-acr303za) + CHR(10) + STRING(g-cod-grp-cobr-fim-acr303za).

END.

