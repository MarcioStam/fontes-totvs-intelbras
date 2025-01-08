
/*******************************************************************************************/
/* Autor.........: Carlos da Costa Junior                                                  */
/*                                                                                         */
/* Data..........: 16/11/2022                                                              */
/*                                                                                         */
/* Objetivo......: Defini‡Æo das Temp Tables da Classe ReturnDoctoSaida                  */
/*******************************************************************************************/

DEF TEMP-TABLE tt-docto-saida NO-UNDO
    FIELD filialPedido  AS CHAR
    FIELD numeroPedido  AS CHAR
    FIELD volume        AS INT
    FIELD especie       AS CHAR
    FIELD statusDocto   AS CHAR.

DEF TEMP-TABLE tt-docto-saida-itens NO-UNDO
    FIELD numeroItem      AS CHAR
    FIELD codigoProduto   AS CHAR
    FIELD quantidade      AS INTEGER
    FIELD numeroSerie     AS CHAR.
