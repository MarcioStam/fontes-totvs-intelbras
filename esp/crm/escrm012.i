/*********************************************************************************
** Programa: esp/crm/escrm012.i
** Vers∆o..: 1.00
** Data....: 05/10/2010
** Autor...: Estevan KrÅger - Exponencial TI
** Obs.....: Include para definiá∆o das temp-tables geradas pelo XML, utilizadas pelo
**           programa ESCRM012
*********************************************************************************/

DEFINE TEMP-TABLE tt-ped-venda-xml NO-UNDO LIKE ped-venda
    FIELD cod-repres      AS INTEGER
    FIELD cod-cliente     AS INTEGER
    FIELD cod-atendente   AS INTEGER
    FIELD cod-moeda       AS INTEGER
    FIELD ds-observacao   AS CHARACTER
    FIELD cond-especial   AS CHARACTER
    FIELD ind-fat-parc    AS LOGICAL
    FIELD ind-vendor      AS LOGICAL
    FIELD dias-base       AS INTEGER
    FIELD taxa-cliente    AS DECIMAL
    FIELD dt-negociacao   AS DATE
    FIELD dias-negociacao AS INTEGER
    FIELD guid-crm        AS CHARACTER
    FIELD cod-categoria   AS INTEGER.


DEFINE TEMP-TABLE tt-ped-item-xml  NO-UNDO LIKE ped-item
    FIELD de-qtd        AS DECIMAL
    FIELD de-qtd-aux    AS DECIMAL
    FIELD baixo-min     AS LOGICAL
    FIELD guid-crm      AS CHARACTER.

DEFINE TEMP-TABLE tt-erro NO-UNDO
    FIELD mensagem      AS CHARACTER FORMAT "x(250)".

/* Definiá∆o da Temp-table incorporada da inclue "escrm001.i", pois estava com erro */
DEFINE TEMP-TABLE tt-atributo-entrada NO-UNDO
    FIELD tipo          AS CHARACTER
    FIELD nome          AS CHARACTER
    FIELD nome-pai      AS CHARACTER
    FIELD valor         AS CHARACTER
    INDEX id_principal  AS PRIMARY UNIQUE
        tipo
        nome
        nome-pai.
