/********************************************************************************
 ** UPC........: des340.p - UPC DELETE int-preco-item
 ** Data.......: novembro / 2004
 ** Objetivo...: Repassa inclusäes e modifica‡äes de caracteristicas da familia dos itens para a Base Oracle
 ********************************************************************************/
/* trigger procedure for DELETE of int-preco-item.              */
/*                                                                     */
/* run esp/es0669.p (input "no",                                       */
/*                   "int-preco-item",                                 */
/*                   int-preco-item.it-codigo,                         */
/*                   int-preco-item.cod-refer,                         */
/*                   int-preco-item.nr-tabpre,                         */
/*                   STRING(int-preco-item.dt-inival,"99/99/9999"),    */
/*                   STRING(int-preco-item.quant-min,">>>>,>>9.9999"), */
/*                   "", "", "", "").                                  */
trigger procedure for DELETE of int-preco-item.
RETURN "OK":U.
