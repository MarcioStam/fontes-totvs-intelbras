/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
/*------------------------------------------------------------------------
    File        : ESIMP010.I
    Purpose     : Importa‡Æo da Informa‡Æo do Modal do Embarque.
    Syntax      : <none>
    Description : <none>

    Author(s)   : Fabiano Sakae Ribeiro (Exponencial TI)
    Created     : Maio de 2013
    Notes       : <none>
----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Local Temp-Table Definitions ---                                     */

DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD usuario     AS CHARACTER FORMAT "x(12)":U
    FIELD destino     AS INTEGER
    FIELD todos       AS INTEGER
    FIELD arquivo     AS CHARACTER FORMAT "x(35)":U
    FIELD arq-entrada AS CHARACTER FORMAT "x(35)":U
    FIELD data-exec   AS DATE
    FIELD hora-exec   AS INTEGER
    FIELD arq-destino AS CHARACTER FORMAT "x(35)":U
    .

DEFINE TEMP-TABLE tt-digita NO-UNDO
    FIELD ordem   AS INTEGER   FORMAT ">>>>9":U
    FIELD exemplo AS CHARACTER FORMAT "x(30)":U
    INDEX id
        ordem
    .

DEFINE TEMP-TABLE tt-raw-digita
    FIELD raw-digita AS RAW
    .

