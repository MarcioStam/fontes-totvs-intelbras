TRIGGER PROCEDURE FOR DELETE OF estrut-astec.
/*DEF PARAM BUFFER b-estrut-astec FOR estrut-astec.*/

/*Inicio Integra‡Æo*/
/* DEFINE TEMP-TABLE tt-estrutura-integra NO-UNDO                      */
/*     FIELD CodigoProduto LIKE estrut-astec.it-codigo.                */
/* DEF VAR raw-param   AS RAW  NO-UNDO.                                */
/*                                                                     */
/* CREATE tt-estrutura-integra.                                        */
/* ASSIGN tt-estrutura-integra.CodigoProduto = estrut-astec.it-codigo. */
/*                                                                     */
/* RAW-TRANSFER tt-estrutura-integra TO raw-param.                     */
/*                                                                     */
/* RUN esp/trgw/wes727a.p (INPUT raw-param,                            */
/*                         INPUT 'msg0301').                           */

