/*********************************************************************************
** Programa: esp/acr/esacr050.i
** Vers∆o..: 1.00
** Data....: 19/01/2012
** Autor...: Estevan KrÅger - Exponencial TI
** Obs.....: Include para definiá∆o da Temp-Table de ParÉmetros
*********************************************************************************/

DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino          AS INTEGER
    FIELD arquivo          AS CHARACTER FORMAT "x(35)":U
    FIELD usuario          AS CHARACTER FORMAT "x(12)":U
    FIELD data-exec        AS DATE
    FIELD hora-exec        AS INTEGER
    FIELD raiz-cnpj-ini    AS CHARACTER FORMAT "x(08)":U
    FIELD raiz-cnpj-fim    AS CHARACTER FORMAT "x(08)":U
    FIELD dat-avaliacao    AS DATE      FORMAT "99/99/9999":U
    FIELD classificacao    AS INTEGER
    FIELD clientes-pend    AS LOGICAL.

DEFINE TEMP-TABLE tt-raw-digita
    FIELD raw-digita AS RAW.
