/*********************************************************************************
** Programa: esp/acr/escep062.i
** Vers∆o..: 1.00
** Data....: 13/02/2012
** Autor...: Estevan KrÅger - Exponencial TI
** Obs.....: Include para definiá∆o da Temp-Table de ParÉmetros
*********************************************************************************/

DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino          AS INTEGER
    FIELD arquivo          AS CHARACTER FORMAT "x(35)":U
    FIELD usuario          AS CHARACTER FORMAT "x(12)":U
    FIELD data-exec        AS DATE
    FIELD hora-exec        AS INTEGER
    FIELD arquivo-import   AS CHARACTER.

DEFINE TEMP-TABLE tt-raw-digita
    FIELD raw-digita AS RAW.
