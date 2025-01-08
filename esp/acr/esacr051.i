/*********************************************************************************
** Programa: esp/acr/esacr051.i
** Vers∆o..: 1.00
** Data....: 20/01/2012
** Autor...: Estevan KrÅger - Exponencial TI
** Obs.....: Include para definiá∆o da Temp-Table de ParÉmetros
*********************************************************************************/

DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino          AS INTEGER
    FIELD arquivo          AS CHARACTER FORMAT "x(35)":U
    FIELD usuario          AS CHARACTER FORMAT "x(12)":U
    FIELD data-exec        AS DATE
    FIELD hora-exec        AS INTEGER
    FIELD data-inicial     AS DATE FORMAT "99/99/9999":U
    FIELD data-final       AS DATE FORMAT "99/99/9999":U
    FIELD tp-relatorio     AS INTEGER
    FIELD exporta-excel    AS LOGICAL INITIAL NO.

DEFINE TEMP-TABLE tt-raw-digita
    FIELD raw-digita AS RAW.
