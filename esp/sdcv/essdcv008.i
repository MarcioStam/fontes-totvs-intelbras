/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
/*------------------------------------------------------------------------
    File        : ESSDCV008.I
    Purpose     : Exportar informa‡Æo para o OutBuyCenter (SDCV).
    Syntax      : <none>
    Description : <none>
----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Local Temp-Table Definitions ---                                     */

DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino                   AS INTEGER
    FIELD arquivo                   AS CHARACTER FORMAT "x(35)":U
    FIELD usuario                   AS CHARACTER FORMAT "x(12)":U
    FIELD data-exec                 AS DATE
    FIELD hora-exec                 AS INTEGER
    FIELD classifica                AS INTEGER
    FIELD desc-classifica           AS CHARACTER FORMAT "x(40)":U
    FIELD modelo                    AS CHARACTER FORMAT "x(35)":U
    /*Alterado 15/02/2005 - tech1007 - Criado campo l¢gico para verificar
      se o RTF foi habilitado*/
    FIELD l-habilitaRtf          AS LOGICAL
    /*Fim alteracao 15/02/2005*/
    FIELD c-cotacao-inicial      AS DATE FORMAT "99/99/9999":U
    FIELD c-cotacao-final        AS DATE FORMAT "99/99/9999":U.

DEFINE TEMP-TABLE tt-digita NO-UNDO
    FIELD ordem   AS INTEGER   FORMAT ">>>>9":U
    FIELD exemplo AS CHARACTER FORMAT "x(30)":U
    INDEX id
        ordem.

DEFINE TEMP-TABLE tt-raw-digita
    FIELD raw-digita AS RAW.

