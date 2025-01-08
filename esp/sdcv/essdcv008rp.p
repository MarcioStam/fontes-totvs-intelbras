/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESSDCV008RP 2.06.00.000}
/*------------------------------------------------------------------------
    File        : ESSDCV008RP.P
    Purpose     : Exportar cota‡Æo para o OutBuyCenter (SDCV).
    Syntax      : <none>
    Description : <none>
----------------------------------------------------------------------*/
DEFINE BUFFER empresa FOR mgcad.empresa.

/* ***************************  Definitions  ************************** */

/* Preprocessor Definitions ---                                         */

/* Preprocessador para definir impressÆo dos parƒmetros */
&GLOBAL-DEFINE PRINT-PARAM  YES

/* Include Definitions ---                                              */

/* Defini‡Æo da temp-table ttRawTabela */
{esp/sdcv/essdcv001api.i}

/* Defini‡Æo das temp-tables tt-param, tt-digita e tt-raw-digita */
{esp/sdcv/essdcv008.i}

/* Defini‡Æo das procedure internas pi-cria-mensagem e
   pi-cria-mensagem-pela-RowErrors */
{esp/sdcv/essdcv003rp.i}

/* Defini‡Æo das vari veis de relat¢rio */
{include/i-rpvar.i}

/* Local Variable Definitions ---                                       */
{upc/btb910za-upc.i}
{esp/sdcv/essdcv001api.i2}

DEFINE VARIABLE h-acomp   AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-destino AS CHARACTER   NO-UNDO.

/* Stream Definitions ---                                               */

DEFINE STREAM str-rp.

/* Form Definitions ---                                                 */

FORM tt-mensagem.registro
     tt-mensagem.tipo-mensagem
     tt-mensagem.mensagem
    WITH STREAM-IO NO-ATTR-SPACE NO-BOX DOWN WIDTH 132 FRAME f-mensagem.

FORM "SELE€ÇO":U               AT 10 SKIP(1)
     tt-param.c-cotacao-inicial      COLON 40 LABEL "Data Cota‡Æo":U
     "|< >|":U                          AT 50
     tt-param.c-cotacao-final           AT 60 NO-LABEL                                                      SKIP
     "IMPRESSÇO":U             AT 10 SKIP(1)
     c-destino              COLON 20 LABEL "Destino":U "-":U tt-param.arquivo NO-LABEL SKIP
     tt-param.usuario       COLON 20 LABEL "Usu rio":U
    WITH WIDTH 132 SIDE-LABELS FRAME f-param STREAM-IO.

/* Parameters Definitions ---                                           */

DEFINE INPUT  PARAMETER raw-param AS RAW         NO-UNDO.
DEFINE INPUT  PARAMETER TABLE FOR tt-raw-digita.


/* ************************  Function Prototypes ********************** */

/* FUNCTION fn-function RETURNS CHARACTER */
/*   (  )  FORWARD.                       */


/* ***************************  Main Block  *************************** */

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

FIND FIRST tt-param NO-ERROR.

FOR EACH tt-raw-digita:
    CREATE tt-digita.
    RAW-TRANSFER tt-raw-digita.raw-digita TO tt-digita.
END.

FIND FIRST param-global NO-LOCK NO-ERROR.

FIND FIRST empresa
    WHERE empresa.ep-codigo = param-global.empresa-pri NO-LOCK NO-ERROR.

ASSIGN c-empresa      = IF AVAILABLE empresa THEN empresa.razao-social ELSE "":U
       c-titulo-relat = "":U
       c-sistema      = "Espec¡fico Intelbras":U.

ASSIGN c-destino = {varinc/var00002.i 04 tt-param.destino}.

IF  OPSYS = "unix" THEN
    ASSIGN tt-param.c-cotacao-inicial = TODAY
           tt-param.c-cotacao-final   = TODAY.


DO ON ERROR UNDO, RETURN ERROR
   ON STOP  UNDO, RETURN ERROR:
    {include/i-rpcab.i &STREAM="str-rp"}
    {include/i-rpout.i &STREAM="STREAM str-rp"}

    VIEW STREAM str-rp FRAME f-cabec.
    VIEW STREAM str-rp FRAME f-rodape.

    IF NOT VALID-HANDLE(h-acomp)               OR
       h-acomp:TYPE      <> "PROCEDURE":U      OR
       h-acomp:FILE-NAME <> "utp/ut-acomp.p":U THEN
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-inicializar IN h-acomp (INPUT "":U).

    RUN pi-exportacao IN THIS-PROCEDURE.

    &IF DEFINED(PRINT-PARAM) <> 0 AND "{&PRINT-PARAM}":U = "YES":U &THEN
    RUN pi-parametro IN THIS-PROCEDURE.
    &ENDIF

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-finalizar IN h-acomp.

    {include/i-rpclo.i &STREAM="STREAM str-rp"}

    IF VALID-HANDLE(h-acomp) THEN
        DELETE PROCEDURE h-acomp.

    ASSIGN h-acomp = ?.
END.

RETURN "OK":U.


/* **********************  Internal Procedures  *********************** */

PROCEDURE pi-exportacao :
/*------------------------------------------------------------------------------
  Purpose:     <none>
  Parameters:  <none>
  Notes:       <none>
------------------------------------------------------------------------------*/
    RUN pi-exp-cotacao-moeda  IN THIS-PROCEDURE.
    
    IF  CAN-FIND(FIRST tt-mensagem) THEN DO:
        PAGE STREAM str-rp.

        FOR EACH tt-mensagem:
            DISPLAY STREAM str-rp
                    tt-mensagem.registro
                    tt-mensagem.tipo-mensagem
                    tt-mensagem.mensagem
                WITH FRAME f-mensagem.
            DOWN STREAM str-rp WITH FRAME f-mensagem.
        END. /* FOR EACH tt-mensagem: */
    END. /* IF  CAN-FIND(FIRST tt-mensagem) THEN DO: */

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-exp-cotacao-moeda :
/*------------------------------------------------------------------------------
  Purpose:     <none>
  Parameters:  <none>
  Notes:       <none>
------------------------------------------------------------------------------*/
    ASSIGN i-cont-exportado = 0.

    FIND FIRST tt-param NO-ERROR.
    
    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-seta-titulo IN h-acomp (INPUT "Exp Cota‡Æo Moeda...":U).

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-acompanhar IN h-acomp (INPUT "Cota‡Æo Moeda: ":U + TRIM(STRING(tt-param.c-cotacao-inicial)) + " - ":U + TRIM(STRING(tt-param.c-cotacao-final))).
   
    RUN esp/sdcv/essdcv008api.p (INPUT  "cotacao":U,
                                 INPUT  "I":U,
                                 INPUT  tt-param.c-cotacao-inicial,
                                 INPUT  tt-param.c-cotacao-final,
                                 OUTPUT TABLE RowErrors).

    IF CAN-FIND(FIRST RowErrors) THEN
        RUN pi-cria-mensagem-pela-RowErrors IN THIS-PROCEDURE (INPUT "Cota‡Æo Moeda":U).
    ELSE
        ASSIGN i-cont-exportado = i-cont-exportado + 1.
   
    IF i-cont-exportado > 0 THEN
        RUN pi-cria-mensagem IN THIS-PROCEDURE (INPUT "Cota‡Æo Moeda":U,
                                                INPUT "Informa‡Æo":U,
                                                INPUT "Foram exportados ":U + TRIM(STRING(i-cont-exportado)) + " registro(s) com sucesso!":U).

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-parametro :
/*------------------------------------------------------------------------------
  Purpose:     <none>
  Parameters:  <none>
  Notes:       <none>
------------------------------------------------------------------------------*/
    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-seta-titulo IN h-acomp (INPUT "Imprimindo Parƒmetro...":U).

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-acompanhar IN h-acomp (INPUT "Gerando...":U).

    PAGE STREAM str-rp.

    DISPLAY STREAM str-rp
            tt-param.c-cotacao-inicial
            tt-param.c-cotacao-final
            c-destino
            tt-param.arquivo
            tt-param.usuario
        WITH FRAME f-param.

    RETURN "OK":U.

END PROCEDURE.


/* ************************  Function Implementations ***************** */

/* FUNCTION fn-function RETURNS CHARACTER                                           */
/*   (  ) :                                                                         */
/* /*------------------------------------------------------------------------------ */
/*   Purpose:  <none>                                                               */
/*     Notes:  <none>                                                               */
/* ------------------------------------------------------------------------------*/ */
/*     RETURN "":U.                                                                 */
/*                                                                                  */
/* END FUNCTION.                                                                    */

