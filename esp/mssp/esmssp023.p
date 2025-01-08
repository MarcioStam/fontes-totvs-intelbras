/*------------------------------------------------------------------------
    File        : ESMSSP023.P
    Purpose     : Consulta Fam°lia Material
    Procedure   : consultaFamiliaMaterial
    Syntax      : <none>
    Description : <none>

    Author(s)   : Fabiano Sakae Ribeiro (SQL Works / Exponencial TI)
    Created     : Julho de 2012
    Notes       : <none>
------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Include Definitions ---                                              */

/* Definiá∆o das temp-tables "tt-familia" */
{esp/mssp/esmssp023.i}

/* Parameters Definitions ---                                           */

DEFINE INPUT  PARAMETER p-fm-codigo LIKE familia.fm-codigo NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR tt-familia.
DEFINE OUTPUT PARAMETER TABLE FOR tt-mensagem.


/* ***************************  Main Block  *************************** */

EMPTY TEMP-TABLE tt-familia.
EMPTY TEMP-TABLE tt-mensagem.

FIND FIRST familia
    WHERE familia.fm-codigo = p-fm-codigo NO-LOCK NO-ERROR.

IF NOT AVAILABLE familia THEN DO:
    RUN pi-cria-mensagem (INPUT 2,
                          INPUT "Item":U).

    RETURN "NOK":U.
END.

CREATE tt-familia.
ASSIGN tt-familia.fm-codigo    = familia.fm-codigo
       tt-familia.descricao    = familia.descricao
       tt-familia.un           = familia.un
       tt-familia.contr-qualid = familia.contr-qualid
       tt-familia.fraciona     = familia.fraciona
       tt-familia.criticidade  = familia.criticidade
       tt-familia.perc-nqa     = familia.perc-nqa.

RETURN "OK":U.


/* **********************  Internal Procedures  *********************** */

PROCEDURE pi-cria-mensagem :
/*------------------------------------------------------------------------------
  Purpose:     Criar mensagem baseado nas mensagens do Datasul EMS 2.
  Parameters:  INPUT p-codigo    AS INTEGER,
               INPUT p-parametro AS CHARACTER.
  Notes:       <none>
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-codigo    AS INTEGER     NO-UNDO.
    DEFINE INPUT  PARAMETER p-parametro AS CHARACTER   NO-UNDO.

    DEFINE VARIABLE i-sequencia AS INTEGER     NO-UNDO.

    FIND LAST tt-mensagem NO-ERROR.

    ASSIGN i-sequencia = IF AVAILABLE tt-mensagem THEN tt-mensagem.sequencia + 1 ELSE 1.

    CREATE tt-mensagem.
    ASSIGN tt-mensagem.sequencia = i-sequencia
           tt-mensagem.codigo    = p-codigo.

    /* Tipo da Mensagem (Erro, Advertància, Informaá∆o ou Quest∆o) */
    RUN utp/ut-msgs.p (INPUT "TYPE":U,
                       INPUT p-codigo,
                       INPUT p-parametro).

    ASSIGN tt-mensagem.tipo = RETURN-VALUE.

    /* Mensagem */
    RUN utp/ut-msgs.p (INPUT "MSG":U,
                       INPUT p-codigo,
                       INPUT p-parametro).

    ASSIGN tt-mensagem.mensagem = RETURN-VALUE.

    /* Ajuda da Mensagem */
    RUN utp/ut-msgs.p (INPUT "HELP":U,
                       INPUT p-codigo,
                       INPUT p-parametro).

    ASSIGN tt-mensagem.complemento = RETURN-VALUE.

    RETURN "OK":U.

END PROCEDURE.

