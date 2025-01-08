/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
/*------------------------------------------------------------------------
    File        : ESCDP109.I
    Purpose     : Defini‡Æo das Temp-Tables do programa ESCDP109.W
    Syntax      : <none>
    Description : <none>

    Author(s)   : Graziely  Lima (iDBA)
    Created     : Mar‡o 2022
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
    FIELD todos       AS INTEGER
    FIELD log-alerta  AS LOGICAL
    FIELD nr-opcao    AS INTEGER.

DEFINE TEMP-TABLE tt-digita NO-UNDO
    FIELD ordem   AS INTEGER   FORMAT ">>>>9":U
    FIELD exemplo AS CHARACTER FORMAT "x(30)":U
    INDEX id
        ordem.

DEFINE TEMP-TABLE tt-raw-digita
    FIELD raw-digita AS RAW.

