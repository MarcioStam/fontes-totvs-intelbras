/*********************************************************************************
** Programa: esp/acr/esacr053.i
** Vers∆o..: 1.00
** Data....: 26/03/2012
** Autor...: Estevan KrÅger - Exponencial TI
** Obs.....: Include para definiá∆o da Temp-Table de ParÉmetros
*********************************************************************************/

DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino            AS INTEGER
    FIELD arquivo            AS CHARACTER FORMAT "x(35)":U
    FIELD usuario            AS CHARACTER FORMAT "x(12)":U
    FIELD data-exec          AS DATE
    FIELD hora-exec          AS INTEGER
    FIELD espec              AS CHARACTER
    FIELD cod-estab-ini      AS CHARACTER
    FIELD cod-estab-fim      AS CHARACTER
    FIELD cod-unid-negoc-ini AS CHARACTER
    FIELD cod-unid-negoc-fim AS CHARACTER
    FIELD cod-cliente-ini    AS INTEGER
    FIELD cod-cliente-fim    AS INTEGER
    FIELD dt-inicial         AS DATE
    FIELD dt-final           AS DATE.

DEFINE TEMP-TABLE tt-raw-digita
    FIELD raw-digita   AS RAW.

DEFINE TEMP-TABLE tt-cliente NO-UNDO
    FIELD cod-cliente  AS INTEGER
    FIELD nom-cliente  AS CHARACTER
    INDEX idx-cliente  AS PRIMARY
          cod-cliente.

DEFINE TEMP-TABLE tt-valores-cli NO-UNDO
    FIELD cod-cliente  AS INTEGER
    FIELD ano          AS INTEGER
    FIELD tot-ano-acr  AS DECIMAL
    FIELD tot-ano-ap   AS DECIMAL
    INDEX idx-val-cli  AS PRIMARY
          cod-cliente
          ano.

