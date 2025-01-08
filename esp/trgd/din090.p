/********************************************************************************
 ** UPC........: din090.p - UPC DELETE docum-est
 ** Data.......: Novembro / 2004
 ** Objetivo...: Repassa inclusäes e modifica‡äes de documentos de entrada para a Base Oracle
 ********************************************************************************/

DEF PARAM BUFFER b-docum-est      FOR docum-est.

/* Chamada UPC de Delete da Gati */
IF  SEARCH("trigger/upc-docum-est.p") <> ? OR
    SEARCH("trigger/upc-docum-est.r") <> ?
THEN
    RUN trigger/upc-docum-est.p (BUFFER b-docum-est).

/* if b-docum-est.nat-operacao begins "1201" or                    */
/*    b-docum-est.nat-operacao begins "1202" or                    */
/*    b-docum-est.nat-operacao begins "2201" or                    */
/*    b-docum-est.nat-operacao begins "2202" or                    */
/*    b-docum-est.nat-operacao begins "2203" or                    */
/*    b-docum-est.nat-operacao begins "3201" then do:              */
/*                                                                 */
/*    run esp/es0669.p (input "no",                                */
/*                      "docum-est",                               */
/*                      b-docum-est.serie-docto,                   */
/*                      b-docum-est.nro-docto,                     */
/*                      string(b-docum-est.cod-emitente,"999999"), */
/*                      b-docum-est.nat-operacao,                  */
/*                      "", "", "", "", "").                       */
/* end.                                                            */

RETURN "OK":U.

