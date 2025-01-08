/*------------------------------------------------------------------------
    File        : ESMSSP026.P
    Purpose     : Busca Estabelecimentos da Fam¡lia Material - Procedure:
                  buscaEstFamMat
    Syntax      : <none>
    Description : <none>

    Author(s)   : Fabiano Sakae Ribeiro (Exponencial TI)
    Created     : Dezembro de 2012
    Notes       : <none>
------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Include Definitions ---                                              */

/* Defini‡Æo das Temp-Tables tt-item e tt-mensagem */
{esp/mssp/esmssp026.i}

/* Parameters Definitions ---                                           */

DEFINE INPUT  PARAMETER p-fm-codigo LIKE familia.fm-codigo NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR tt-estabelec.
DEFINE OUTPUT PARAMETER TABLE FOR tt-mensagem.


/* ***************************  Main Block  *************************** */

EMPTY TEMP-TABLE tt-estabelec.
EMPTY TEMP-TABLE tt-mensagem.

FIND FIRST familia
    WHERE familia.fm-codigo = p-fm-codigo NO-LOCK NO-ERROR.

IF NOT AVAILABLE familia THEN DO:
    RUN piCriaMensagem IN THIS-PROCEDURE (INPUT 2,
                                          INPUT "Fam¡lia Material":U).

    RETURN "NOK":U.
END.

FOR EACH fam-uni-estab
    WHERE fam-uni-estab.fm-codigo = familia.fm-codigo NO-LOCK:

    FIND FIRST tt-estabelec
        WHERE tt-estabelec.cod-estabel = fam-uni-estab.cod-estabel NO-LOCK NO-ERROR.

    IF NOT AVAILABLE tt-estabelec THEN DO:
        CREATE tt-estabelec.
        ASSIGN tt-estabelec.cod-estabel = fam-uni-estab.cod-estabel.

        FIND FIRST estabelec
            WHERE estabelec.cod-estabel = tt-estabelec.cod-estabel NO-LOCK NO-ERROR.

        ASSIGN tt-estabelec.nome-estabel = IF AVAILABLE estabelec THEN estabelec.nome ELSE "":U.
    END.
END.

IF NOT CAN-FIND(FIRST tt-estabelec) THEN DO:
    RUN piCriaMensagem IN THIS-PROCEDURE (INPUT 17006,
                                          INPUT "NÆo foi(ram) encontrado(s) o(s) registro(s) solicitado(s).":U +
                                                "~~":U +
                                                "NÆo foram encontrados Estabelecimentos relacionados a Fam¡lia Material informada.":U).

    RETURN "NOK":U.
END.

RETURN "OK":U.


/* **********************  Internal Procedures  *********************** */

PROCEDURE piCriaMensagem PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     Criar mensagem para ser retornado ao programa que o chama.
  Parameters:  p-cd-msg (LIKE cad-msgs.cd-msg),
               p-parametro (CHARACTER)
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-cd-msg    LIKE cadast_msg.cdn_msg NO-UNDO.
    DEFINE INPUT  PARAMETER p-parametro AS CHARACTER         NO-UNDO.

    DEFINE VARIABLE i-sequencia AS INTEGER     NO-UNDO.

    FIND LAST tt-mensagem NO-LOCK NO-ERROR.

    ASSIGN i-sequencia = IF AVAILABLE tt-mensagem THEN (tt-mensagem.sequencia + 1) ELSE 1.

    CREATE tt-mensagem.
    ASSIGN tt-mensagem.sequencia = i-sequencia
           tt-mensagem.codigo    = p-cd-msg.

    RUN utp/ut-msgs.p (INPUT "TYPE":U,
                       INPUT tt-mensagem.codigo,
                       INPUT p-parametro).

    ASSIGN tt-mensagem.tipo = RETURN-VALUE.

    RUN utp/ut-msgs.p (INPUT "MSG":U,
                       INPUT tt-mensagem.codigo,
                       INPUT p-parametro).

    ASSIGN tt-mensagem.mensagem = RETURN-VALUE.

    RUN utp/ut-msgs.p (INPUT "HELP":U,
                       INPUT tt-mensagem.codigo,
                       INPUT p-parametro).

    ASSIGN tt-mensagem.ajuda = RETURN-VALUE.

    RETURN "OK":U.

END PROCEDURE.
