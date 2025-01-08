TRIGGER PROCEDURE FOR WRITE OF int-estrutura OLD BUFFER b-int-estrutura.

/* DEFINE TEMP-TABLE tt-estrutura-integra NO-UNDO                       */
/*     FIELD CodigoProduto LIKE estrutura.it-codigo.                    */
/*                                                                      */
/* DEF VAR raw-param   AS RAW  NO-UNDO.                                 */
/*                                                                      */
/* CREATE tt-estrutura-integra.                                         */
/* ASSIGN tt-estrutura-integra.CodigoProduto = int-estrutura.it-codigo. */
/*                                                                      */
/* RAW-TRANSFER tt-estrutura-integra TO raw-param.                      */
/*                                                                      */
/* RUN esp/trgw/wes727a.p (INPUT raw-param,                             */
/*                         INPUT 'msg0301').                            */






