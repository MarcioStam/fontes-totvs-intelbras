/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
/*------------------------------------------------------------------------
    File        : ESCEP060.I
    Purpose     : Defini‡Æo das Temp-Tables do programa de Importa‡Æo da
                  Pol¡tica Item.
    Syntax      : <none>
    Description : <none>

    Author(s)   : Fabiano Sakae Ribeiro (SQL Works / Exponencial TI)
    Created     : Maio de 2012
    Notes       : 001 - Separar defini‡Æo das temp-tables dos programas
                  ESCEP060.W e ESCEP060RP.P - Fabiano Sakae Ribeiro (SQL
                  Works / Exponencial TI).
------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Local Temp-Table Definitions ---                                     */

DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino     AS INTEGER
    FIELD arq-destino AS CHARACTER FORMAT "x(35)":U
    FIELD usuario     AS CHARACTER FORMAT "x(12)":U
    FIELD data-exec   AS DATE
    FIELD hora-exec   AS INTEGER
    FIELD arq-entrada AS CHARACTER
    FIELD arq-csv     AS CHARACTER
    FIELD todos       AS INTEGER.

DEFINE TEMP-TABLE tt-digita NO-UNDO
    FIELD ordem   AS INTEGER   FORMAT ">>>>9":U
    FIELD exemplo AS CHARACTER FORMAT "x(30)":U
    INDEX id
        ordem.

DEFINE TEMP-TABLE tt-raw-digita
    FIELD raw-digita AS RAW.

