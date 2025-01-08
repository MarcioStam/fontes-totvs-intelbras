/*------------------------------------------------------------------------
    File        : ESMSSP021.P
    Purpose     : Busca C¢digo Item - Procedure: buscaCodigoItem
    Syntax      : <none>
    Description : <none>

    Author(s)   : Fabiano Sakae Ribeiro (Exponencial TI)
    Created     : Junho de 2012
    Notes       : <none>
------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Global Definitions ---                                               */

/* Quantidade M xima a ser retornado de registros de C¢digo do Item */
&GLOBAL-DEFINE quant-max    100

/* Include Definitions ---                                              */

/* Defini‡Æo das Temp-Tables tt-item e tt-mensagem */
{esp/mssp/esmssp021.i}

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE de-it-codigo AS DECIMAL          NO-UNDO
    FORMAT "->>>,>>>,>>>,>>9":U.
DEFINE VARIABLE i-sequencia  AS INTEGER          NO-UNDO.
DEFINE VARIABLE v-it-codigo  LIKE item.it-codigo NO-UNDO.
DEFINE VARIABLE i-quant-item AS INTEGER          NO-UNDO.

/* Parameters Definitions ---                                           */

DEFINE INPUT  PARAMETER p-it-codigo AS CHARACTER   NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR tt-item.
DEFINE OUTPUT PARAMETER TABLE FOR tt-mensagem.


/* ***************************  Main Block  *************************** */

EMPTY TEMP-TABLE tt-item.
EMPTY TEMP-TABLE tt-mensagem.

IF p-it-codigo = "":U THEN DO:
    RUN pi-cria-mensagem IN THIS-PROCEDURE (INPUT 17006,
                                            INPUT "O C¢digo do Item deve ser diferente de branco.":U).

    RETURN "NOK":U.
END.

ASSIGN de-it-codigo = DECIMAL(TRIM(p-it-codigo)) NO-ERROR.

IF ERROR-STATUS:ERROR THEN DO:
    RUN pi-cria-mensagem IN THIS-PROCEDURE (INPUT 17006,
                                            INPUT "Foi(ram) encontrado(s) caractere(s) inv lido(s) no C¢digo do Item.":U +
                                                  "~~":U +
                                                  "O C¢digo do Item deve possuir somente n£meros.":U).

    RETURN "NOK":U.
END.

IF de-it-codigo < 0 THEN DO:
    RUN pi-cria-mensagem IN THIS-PROCEDURE (INPUT 17006,
                                            INPUT "Valor inv lido para o C¢digo do Item.":U +
                                                  "~~":U +
                                                  "O C¢digo do Item nÆo deve ser negativo.":U).

    RETURN "NOK":U.
END.

IF LENGTH(p-it-codigo) <> 7 THEN DO:
    RUN pi-cria-mensagem IN THIS-PROCEDURE (INPUT 17006,
                                            INPUT "C¢digo do Item inv lido.":U +
                                                  "~~":U +
                                                  "O C¢digo do Item deve possuir 7 (sete) caracteres num‚ricos.":U).

    RETURN "NOK":U.
END.

IF CAN-FIND(FIRST tt-mensagem) THEN
    RETURN "NOK":U.

ASSIGN i-quant-item = 0.

DO i-sequencia = INTEGER(TRIM(SUBSTRING(p-it-codigo, 4, 4))) TO 9999:
    ASSIGN v-it-codigo = TRIM(SUBSTRING(p-it-codigo, 1, 3)) + TRIM(STRING(i-sequencia, "9999":U)).

    FIND FIRST item
        WHERE item.it-codigo = v-it-codigo NO-LOCK NO-ERROR.

    IF NOT AVAILABLE item THEN DO:
        FIND FIRST tt-item
            WHERE tt-item.it-codigo = v-it-codigo NO-ERROR.

        IF NOT AVAILABLE tt-item THEN DO:
            CREATE tt-item.
            ASSIGN tt-item.it-codigo = v-it-codigo.

            ASSIGN i-quant-item = i-quant-item + 1.
        END.
    END.

    IF i-quant-item >= {&quant-max} THEN
        LEAVE.
END.

RELEASE item.

IF NOT CAN-FIND(FIRST tt-item) THEN DO:
    RUN pi-cria-mensagem IN THIS-PROCEDURE (INPUT 17006,
                                            INPUT "NÆo foram encontrados C¢digos do Item livres para uso.":U +
                                                  "~~":U +
                                                  "Para cadastrar o Item, ser  necess rio criar uma nova Fam¡lia.":U).

    RETURN "NOK":U.
END.

RETURN "OK":U.


/* **********************  Internal Procedures  *********************** */

PROCEDURE pi-cria-mensagem PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-codigo    LIKE cadast_msg.cdn_msg NO-UNDO.
    DEFINE INPUT  PARAMETER p-parametro AS CHARACTER         NO-UNDO.

    FIND LAST tt-mensagem NO-LOCK NO-ERROR.

    ASSIGN i-sequencia = IF AVAILABLE tt-mensagem THEN (tt-mensagem.sequencia + 1) ELSE 1.

    CREATE tt-mensagem.
    ASSIGN tt-mensagem.sequencia = i-sequencia
           tt-mensagem.codigo    = p-codigo.

    RUN utp/ut-msgs.p (INPUT "TYPE":U,
                       INPUT p-codigo,
                       INPUT p-parametro).

    ASSIGN tt-mensagem.tipo = RETURN-VALUE.

    RUN utp/ut-msgs.p (INPUT "MSG":U,
                       INPUT p-codigo,
                       INPUT p-parametro).

    ASSIGN tt-mensagem.mensagem = RETURN-VALUE.

    RUN utp/ut-msgs.p (INPUT "HELP":U,
                       INPUT p-codigo,
                       INPUT p-parametro).

    ASSIGN tt-mensagem.ajuda = RETURN-VALUE.

    RETURN "OK":U.

END PROCEDURE.

