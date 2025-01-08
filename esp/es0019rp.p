/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ES0019RP 2.00.00.000}
/*------------------------------------------------------------------------
    File        : XX9999RP.P
    Purpose     : <none>
    Syntax      : <none>
    Description : <none>

    Author(s)   : <none>
    Created     : <none>
    Notes       : <none>
----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Preprocessor Definitions ---                                         */

&GLOBAL-DEFINE PRINT-PARAM  YES

/* Include Definitions ---                                              */
{esp/es0019.i}

/* Defini‡Æo das temp-tables tt-param, tt-digita e tt-raw-digita */
{include/i-rpvar.i}

/* Local Temp-Table Definitions ---                                     */

DEFINE VARIABLE h-acomp   AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-destino AS CHARACTER   NO-UNDO.

/* Stream Definitions ---                                               */

DEFINE STREAM str-rp.

/* Form Definitions ---                                                 */

/* FORM <campo> AT <posicao> COLUMN-LABEL <cabecalho>                     */
/*      <campo> AT <posicao> COLUMN-LABEL <cabecalho>                     */
/*     WITH STREAM-IO NO-ATTR-SPACE NO-BOX DOWN WIDTH 132 FRAME f-report. */

/* /* Form com Digita‡Æo */                                                                              */
/* FORM "SELE€ÇO":U               AT 10 SKIP(1)                                                          */
/*      <campo inicial>    <COLON/AT> <posicao> <LABEL <label>> "|< >|":U <campo final> NO-LABEL SKIP    */
/*      <campo inicial>    <COLON/AT> <posicao> <LABEL <label>> "|< >|":U <campo final> NO-LABEL SKIP(2) */
/*      "CLASSIFICA€ÇO":U         AT 10 SKIP(1)                                                          */
/*      <campo>            <COLON/AT> <posicao> <LABEL <label>> SKIP                                     */
/*      <campo>            <COLON/AT> <posicao> <LABEL <label>> SKIP(2)                                  */
/*      "PAR¶METRO":U                                                                                    */
/*      <campo>            <COLON/AT> <posicao> <LABEL <label>> SKIP                                     */
/*      <campo>            <COLON/AT> <posicao> <LABEL <label>> SKIP(2)                                  */
/*      "DIGITA€ÇO":U             AT 10 SKIP(1)                                                          */
/*     WITH WIDTH 132 SIDE-LABELS FRAME f-param-1 STREAM-IO.                                             */
/*                                                                                                       */
/* FORM <campo> AT <posicao> COLUMN-LABEL <cabecalho>                                                    */
/*      <campo> AT <posicao> COLUMN-LABEL <cabecalho>                                                    */
/*     WITH STREAM-IO NO-ATTR-SPACE NO-BOX DOWN WIDTH 132 FRAME f-digitacao.                             */
/*                                                                                                       */
/* FORM SKIP(1)                                                                                          */
/*      "IMPRESSÇO":U             AT 10 SKIP(1)                                                          */
/*      c-destino              COLON 20 LABEL "Destino":U "-":U tt-param.arquivo NO-LABEL SKIP           */
/*      tt-param.usuario       COLON 20 LABEL "Usu rio":U                                                */
/*     WITH WIDTH 132 SIDE-LABELS FRAME f-param-2 STREAM-IO.                                             */

/* /* Form sem Digita‡Æo */                                                                              */
/* FORM "SELE€ÇO":U               AT 10 SKIP(1)                                                          */
/*      <campo inicial>    <COLON/AT> <posicao> <LABEL <label>> "|< >|":U <campo final> NO-LABEL SKIP    */
/*      <campo inicial>    <COLON/AT> <posicao> <LABEL <label>> "|< >|":U <campo final> NO-LABEL SKIP(2) */
/*      "CLASSIFICA€ÇO":U         AT 10 SKIP(1)                                                          */
/*      <campo>            <COLON/AT> <posicao> <LABEL <label>> SKIP                                     */
/*      <campo>            <COLON/AT> <posicao> <LABEL <label>> SKIP(2)                                  */
/*      "PAR¶METRO":U                                                                                    */
/*      <campo>            <COLON/AT> <posicao> <LABEL <label>> SKIP                                     */
/*      <campo>            <COLON/AT> <posicao> <LABEL <label>> SKIP(2)                                  */
/*      "IMPRESSÇO":U             AT 10 SKIP(1)                                                          */
/*      c-destino              COLON 20 LABEL "Destino":U "-":U tt-param.arquivo NO-LABEL SKIP           */
/*      tt-param.usuario       COLON 20 LABEL "Usu rio":U                                                */
/*     WITH WIDTH 132 SIDE-LABELS FRAME f-param STREAM-IO.                                               */

/* Parameters Definitions ---                                           */

DEFINE INPUT  PARAMETER raw-param AS RAW         NO-UNDO.
DEFINE INPUT  PARAMETER TABLE FOR tt-raw-digita.


/* ************************  Function Prototypes ********************** */

/* ***************************  Main Block  *************************** */

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

FIND FIRST tt-param NO-ERROR.

FOR EACH tt-raw-digita:
    CREATE tt-digita.
    RAW-TRANSFER tt-raw-digita.raw-digita TO tt-digita.
END.

FIND FIRST param-global NO-LOCK NO-ERROR.

FIND FIRST mgcad.empresa
    WHERE empresa.ep-codigo = param-global.empresa-pri NO-LOCK NO-ERROR.

ASSIGN c-empresa      = IF AVAILABLE empresa THEN empresa.razao-social ELSE "":U
       c-titulo-relat = "":U
       c-sistema      = "":U.

ASSIGN c-destino = {varinc/var00002.i 04 tt-param.destino}.

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

    RUN pi-report IN THIS-PROCEDURE.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-finalizar IN h-acomp.

    {include/i-rpclo.i &STREAM="STREAM str-rp"}

    IF VALID-HANDLE(h-acomp) THEN
        DELETE PROCEDURE h-acomp.

    ASSIGN h-acomp = ?.
END.

RETURN "OK":U.


/* **********************  Internal Procedures  *********************** */

PROCEDURE pi-report :
/*------------------------------------------------------------------------------
  Purpose:     <none>
  Parameters:  <none>
  Notes:       <none>
------------------------------------------------------------------------------*/
    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-seta-titulo IN h-acomp (INPUT "Acompanhando...":U).

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-acompanhar IN h-acomp (INPUT "Eliminando...":U).

    DEFINE VARIABLE cmd AS CHARACTER NO-UNDO.
    
    /*
    int-desconecta-usuar.ambiente: producao
                                   homologacao
                                   desenvolvimento
    */
    
    FOR EACH int-desconecta-usuar EXCLUSIVE-LOCK:
        ASSIGN cmd = "proshut /db" + int-desconecta-usuar.ambiente + "/" + int-desconecta-usuar.banco + " -C disconnect " + STRING(int-desconecta-usuar.id-usuario).
        UNIX SILENT VALUE(cmd).
        DELETE int-desconecta-usuar.
    END.
    
    RETURN "OK":U.

END PROCEDURE.

