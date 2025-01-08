/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ES0037RP 0.11.00.001}
/*------------------------------------------------------------------------
    File        : ES0037RP.P
    Purpose     : Op‡äes Extras Clientlog
    Syntax      : <none>
    Description : <none>

    Author(s)   : Rubia Oliveira
    Created     : Abril/205
    Notes       : <none>
----------------------------------------------------------------------*/

/* Include Definitions ---                                              */
define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)"
    field usuario          as char format "x(12)"
    field data-exec        as date
    field hora-exec        as integer

    FIELD i-clientlog      AS INTEGER
    /****
    field classifica       as integer
    field desc-classifica  as char format "x(40)"
    field modelo-rtf       as char format "x(35)"
    field l-habilitaRtf    as LOG
    **/.

{include/i-rpvar.i}

/* Local Temp-Table Definitions ---                                     */
def temp-table tt-raw-digita
   field raw-digita      as raw.

/* Parameter Definitions ---                                            */

DEFINE INPUT  PARAMETER raw-param AS RAW         NO-UNDO.
DEFINE INPUT  PARAMETER TABLE FOR tt-raw-digita.


/* ***************************  Main Block  *************************** */

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

FIND FIRST param-global NO-LOCK NO-ERROR.

FIND FIRST mgcad.empresa
    WHERE empresa.ep-codigo = param-global.empresa-pri NO-LOCK NO-ERROR.

ASSIGN c-empresa      = IF AVAILABLE empresa THEN empresa.razao-social ELSE "":U
       c-titulo-relat = "Op‡äes Extras Clientlog":U
       c-sistema	  = "Espec¡ficos Intelbras":U.

{include/i-rpcab.i &stream = "str-rp"}
{include/i-rpout.i &stream = "STREAM str-rp"}

VIEW STREAM str-rp FRAME f-cabec.
VIEW STREAM str-rp FRAME f-rodape.

FIND FIRST tt-param NO-LOCK NO-ERROR.
IF tt-param.i-clientlog = 1 THEN DO:

    log-manager:logging-level   = 4.
    log-manager:log-entry-types = '4GLMessages,4GLTrace,DB.Connects,DynObjects.DB,DynObjects.XML,DynObjects.Other,DynObjects.CLASS,FileID'.


    PUT STREAM str-rp UNFORMATTED
        SKIP(3)
        "OP€åES EXTRAS ATIVADAS" SKIP.

END.
ELSE DO:

    log-manager:logging-level   = 2.
    log-manager:log-entry-types = '4GLMessages,DB.Connects,DynObjects.DB,DynObjects.XML,DynObjects.Other,DynObjects.CLASS,FileID'.

    PUT STREAM str-rp UNFORMATTED
        SKIP(3)
        "OP€åES EXTRAS ATIVADAS" SKIP.

END.

{include/i-rpclo.i &stream = "STREAM str-rp"}

RETURN "OK":U.
