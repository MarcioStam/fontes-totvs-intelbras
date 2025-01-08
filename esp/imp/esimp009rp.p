/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESIMP009RP 2.06.00.000}
/*------------------------------------------------------------------------
    File        : ESIMP009RP.P
    Purpose     : Listar informaá‰es de embarque encerrados e n∆o
                  encerrados para conferencia do modal.
    Syntax      : <none>
    Description : <none>

    Author(s)   : Fabiano Sakae Ribeiro (Exponencial TI)
    Created     : Maio de 2013
    Notes       : <none>
----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Include Definitions ---                                              */

/* Definiá∆o das temp-tables tt-param, tt-digita e tt-raw-digita */
{esp/imp/esimp009.i}
{include/i-rpvar.i}

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE h-acomp AS HANDLE      NO-UNDO.

/* New Global Shared Variable Definitions ---                           */

DEFINE NEW GLOBAL SHARED VARIABLE c-dir-spool-servid-exec AS CHARACTER   NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE i-num-ped-exec-rpw      AS INTEGER     NO-UNDO.

/* Stream Definitions ---                                               */

DEFINE STREAM str-csv.

/* Parameters Definitions ---                                           */

DEFINE INPUT  PARAMETER raw-param AS RAW         NO-UNDO.
DEFINE INPUT  PARAMETER TABLE FOR tt-raw-digita.


/* ***************************  Main Block  *************************** */

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

FIND FIRST tt-param NO-ERROR.

DO ON ERROR UNDO, RETURN ERROR
   ON STOP  UNDO, RETURN ERROR:
    IF i-num-ped-exec-rpw <> 0 THEN
        OUTPUT STREAM str-csv TO VALUE(c-dir-spool-servid-exec + "/":U + tt-param.arquivo) CONVERT TARGET "iso8859-1":U.
    ELSE
        OUTPUT STREAM str-csv TO VALUE(tt-param.arquivo) CONVERT TARGET "iso8859-1":U.

    IF NOT VALID-HANDLE(h-acomp)               OR
       h-acomp:TYPE      <> "PROCEDURE":U      OR
       h-acomp:FILE-NAME <> "utp/ut-acomp.p":U THEN
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-inicializar IN h-acomp (INPUT "Gerando Listagem...":U).

    RUN pi-embarque IN THIS-PROCEDURE.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-finalizar IN h-acomp.

    OUTPUT STREAM str-csv CLOSE.

    IF VALID-HANDLE(h-acomp) THEN
        DELETE PROCEDURE h-acomp.

    ASSIGN h-acomp = ?.
END.

RETURN "OK":U.


/* **********************  Internal Procedures  *********************** */

PROCEDURE pi-embarque :
/*------------------------------------------------------------------------------
  Purpose:     <none>
  Parameters:  <none>
  Notes:       <none>
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-desc-itiner     AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-desc-via-transp AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-desc-situacao   AS CHARACTER   NO-UNDO.

    PUT STREAM str-csv UNFORMATTED "Estabelecimento;Embarque;C¢digo Itiner†rio;Descriá∆o Itiner†rio;Via Transporte;Situaá∆o":U SKIP.

    FOR EACH historico-embarque NO-LOCK
        WHERE historico-embarque.dt-previsao >= tt-param.da-corte
        BREAK BY historico-embarque.cod-estabel
              BY historico-embarque.embarque:
        IF FIRST-OF(historico-embarque.embarque) THEN DO:
            IF VALID-HANDLE(h-acomp) THEN
                RUN pi-acompanhar IN h-acomp (INPUT "Estabel.: ":U + TRIM(historico-embarque.cod-estabel) + " / Embarq.: ":U + TRIM(historico-embarque.embarque)).

            FIND FIRST itinerario
                WHERE itinerario.cod-itiner = historico-embarque.cod-itiner NO-LOCK NO-ERROR.

            FIND FIRST embarque-imp
                WHERE embarque-imp.cod-estabel = historico-embarque.cod-estabel
                  AND embarque-imp.embarque    = historico-embarque.embarque NO-LOCK NO-ERROR.

            ASSIGN c-desc-itiner     = IF AVAILABLE itinerario THEN itinerario.descricao ELSE "":U
                   c-desc-via-transp = IF AVAILABLE embarque-imp THEN {adinc/i01ad268.i 04 embarque-imp.cod-via-transp} ELSE "":U
                   c-desc-situacao   = IF AVAILABLE embarque-imp THEN {cxinc/i01cx220.i 04 embarque-imp.situacao} ELSE "":U.

            PUT STREAM str-csv UNFORMATTED TRIM(historico-embarque.cod-estabel)                    ";":U
                                           TRIM(historico-embarque.embarque)                       ";":U
                                           TRIM(STRING(historico-embarque.cod-itiner, ">>,>>9":U)) ";":U
                                           TRIM(c-desc-itiner)                                     ";":U
                                           TRIM(c-desc-via-transp)                                 ";":U
                                           TRIM(c-desc-situacao)                                   SKIP.
        END.
    END.

    RETURN "OK":U.

END PROCEDURE.

