/*****************************************************************************
** Programa: esp/acr/esacr035.i
** VersÆo..: 1.00
** Data....: 08/09/2011
** Autor...: Estevan Krger - Exponencial TI
** Obs.....: Include para defini‡Æo de Temp-tables padräes entre os programas.
*****************************************************************************/

DEFINE TEMP-TABLE tt-emitente-supcard NO-UNDO
    FIELD raiz-cnpj           AS CHARACTER FORMAT "x(08)"
    FIELD nome-matriz         LIKE emitente.nome-matriz
    FIELD tipo-solicitacao    AS INTEGER
    FIELD val-limite-sugerido AS DEC FORMAT "->>>,>>>,>>9.99" /*LIKE int-emitente-supcard.val-limite*/.
