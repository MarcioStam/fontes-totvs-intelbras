/*****************************************************************************
** Programa..............: esapb100a.p - Confirmaá∆o Pagamento Pinho via WS
** Autor.................: Fabiano Sakae Ribeiro (Exponencial TI)
** Criado em.............: 26/03/2013
*****************************************************************************/

/* ***************************  Definitions  ************************** */

/* Includes Definitions ---                                             */

/* Definiá∆o da Temp-Table "tt_mensagem" */
{esp/apb/esapb029.i}
{include/i_dbinst.i}
{include/i_dbtype.i}
{include/i_fcldef.i}

/* Local Temp-Table Definitions ---                                     */

DEFINE TEMP-TABLE tt_mensagem_aux NO-UNDO LIKE tt_mensagem.

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE i_cont      AS INTEGER     NO-UNDO.
DEFINE VARIABLE i_sequencia AS INTEGER     NO-UNDO.

define NEW GLOBAL SHARED VAR wh-bas-tg-envio-email   as widget-handle       no-undo.

/* New Global Shared Variable Definitions ---                           */

DEFINE NEW GLOBAL SHARED VARIABLE v_rec_bord_ap_upc AS RECID       NO-UNDO
    FORMAT ">>>>>>9":U
    INITIAL ?.


/* ***************************  Main Block  *************************** */
FIND FIRST bord_ap
    WHERE RECID(bord_ap) = v_rec_bord_ap_upc NO-LOCK NO-ERROR.

IF  NOT AVAILABLE bord_ap THEN DO:
    RUN utp/ut-msgs.p("show",
                      17006,
                      "Borderì n∆o localizado!").

    RETURN.
END.

RUN esp/apb/esapb100e.w.

RETURN "OK".
