/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
/*------------------------------------------------------------------------
    File        : ESSDCV003RP.I
    Purpose     : Exportar informa‡Æo para o OutBuyCenter (SDCV).
    Syntax      : <none>
    Description : <none>

    Author(s)   : Fabiano Sakae Ribeiro (Exponencial TI)
    Created     : Julho de 2013
    Notes       : <none>
----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Include Definitions ---                                              */

/* Defini‡Æo da temp-table RowErrors */
{method/dbotterr.i}

/* Local Temp-Table Definitions ---                                     */

DEFINE TEMP-TABLE tt-mensagem NO-UNDO
    FIELD sequencia     AS INTEGER   FORMAT ">,>>>,>>>,>>9":U LABEL "Sequˆncia":U     COLUMN-LABEL "Seq":U
    FIELD registro      AS CHARACTER FORMAT "x(30)":U         LABEL "Registro":U      COLUMN-LABEL "Registro":U
    FIELD tipo-mensagem AS CHARACTER FORMAT "x(12)":U         LABEL "Tipo Mensagem":U COLUMN-LABEL "Tipo Mens":U
    FIELD mensagem      AS CHARACTER FORMAT "x(300)":U        LABEL "Mensagem":U      COLUMN-LABEL "Mensagem":U  VIEW-AS EDITOR SIZE 85 BY 1
    INDEX ch-primario IS PRIMARY
        sequencia
        registro
    INDEX ch-sequencia IS UNIQUE
        sequencia
    INDEX ch-registro
        registro
        sequencia
    INDEX ch-tipo-mensagem
        tipo-mensagem
        registro
        sequencia.

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE i-cont-exportado AS INTEGER     NO-UNDO.


/* **********************  Internal Procedures  *********************** */

PROCEDURE pi-cria-mensagem :
/*------------------------------------------------------------------------------
  Purpose:     <none>
  Parameters:  <none>
  Notes:       <none>
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-registro      LIKE tt-mensagem.registro      NO-UNDO.
    DEFINE INPUT  PARAMETER p-tipo-mensagem LIKE tt-mensagem.tipo-mensagem NO-UNDO.
    DEFINE INPUT  PARAMETER p-mensagem      LIKE tt-mensagem.mensagem      NO-UNDO.

    DEFINE VARIABLE v-sequencia LIKE tt-mensagem.sequencia NO-UNDO.

    FIND LAST tt-mensagem NO-ERROR.

    ASSIGN v-sequencia = IF AVAILABLE tt-mensagem THEN tt-mensagem.sequencia + 1 ELSE 1.

    CREATE tt-mensagem.
    ASSIGN tt-mensagem.sequencia     = v-sequencia
           tt-mensagem.registro      = p-registro
           tt-mensagem.tipo-mensagem = p-tipo-mensagem
           tt-mensagem.mensagem      = p-mensagem.

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-cria-mensagem-pela-RowErrors :
/*------------------------------------------------------------------------------
  Purpose:     <none>
  Parameters:  <none>
  Notes:       <none>
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-registro LIKE tt-mensagem.registro NO-UNDO.

    DEFINE VARIABLE v-sequencia LIKE tt-mensagem.sequencia NO-UNDO.
    DEFINE VARIABLE c-ajuda-aux AS CHARACTER   NO-UNDO.

    FOR EACH RowErrors:
        FIND LAST tt-mensagem NO-ERROR.

        ASSIGN v-sequencia = IF AVAILABLE tt-mensagem THEN tt-mensagem.sequencia + 1 ELSE 1.

        CREATE tt-mensagem.
        ASSIGN tt-mensagem.sequencia     = v-sequencia
               tt-mensagem.registro      = p-registro.

        RUN utp/ut-msgs.p (INPUT "TYPE":U,
                           INPUT RowErrors.ErrorNumber,
                           INPUT RowErrors.ErrorParameters).

        ASSIGN tt-mensagem.tipo-mensagem = RETURN-VALUE.

        RUN utp/ut-msgs.p (INPUT "MSG":U,
                           INPUT RowErrors.ErrorNumber,
                           INPUT RowErrors.ErrorParameters).

        ASSIGN tt-mensagem.mensagem = RETURN-VALUE.

        RUN utp/ut-msgs.p (INPUT "HELP":U,
                           INPUT RowErrors.ErrorNumber,
                           INPUT RowErrors.ErrorParameters).

        ASSIGN c-ajuda-aux = TRIM(RETURN-VALUE).

        IF c-ajuda-aux <> "":U THEN
            ASSIGN tt-mensagem.mensagem = tt-mensagem.mensagem + " - ":U + c-ajuda-aux + " (":U + TRIM(STRING(RowErrors.ErrorNumber)) + ")":U.
    END.

    RETURN "OK":U.

END PROCEDURE.

