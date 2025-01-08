
/*******************************************************************************************/
/* Autor.........: Carlos da Costa Junior                                                  */
/*                                                                                         */
/* Data..........: 16/11/2022                                                              */
/*                                                                                         */
/* Objetivo......: Defini‡Æo das Temp Tables da Classe ReturnDoctoEntrada                  */
/*******************************************************************************************/

DEF TEMP-TABLE tt-docto-entrada NO-UNDO
    FIELD filialNotaFiscal  AS CHAR
    FIELD numeroNotaFiscal  AS CHAR
    FIELD serieNotaFiscal   AS CHAR
    FIELD codigoFornecedor  AS CHAR
    FIELD statusDocto       AS CHAR.

DEF TEMP-TABLE tt-docto-entrada-itens NO-UNDO
    FIELD numeroItem      AS CHAR
    FIELD codigoProduto   AS CHAR
    FIELD quantidade      AS INTEGER.
