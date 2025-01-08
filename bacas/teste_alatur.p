DEFINE VAR raw-param   AS RAW  NO-UNDO.
DEFINE VAR c-msg       AS CHAR NO-UNDO.


/* DEFINE TEMP-TABLE tt-param NO-UNDO                 */
/*     FIELD DataInicio         AS DATE               */
/*     FIELD DataFim            AS DATE               */
/*     FIELD StatusSolicitacao  AS CHAR               */
/*     FIELD StatusDespesa      AS CHAR               */
/*     FIELD TipoData           AS CHAR.              */
/*                                                    */
/* CREATE tt-param.                                   */
/* ASSIGN tt-param.DataInicio        = 01/01/2017     */
/*        tt-param.DataFim           = TODAY          */
/*        tt-param.StatusSolicitacao = "ENC"          */
/*        tt-param.StatusDespesa     = "EMI"          */
/*        tt-param.TipoData          = "dtAprovacao". */
/*                                                    */
/* ASSIGN c-msg = "msg0271".                          */
/* RAW-TRANSFER tt-param TO raw-param.                */
/* {esp/esb/esesb006.i c-msg 'tst' 'tt-param'}        */




/* DEFINE TEMP-TABLE tt-param NO-UNDO                                  */
/*     FIELD CodigoARB LIKE int_solicitacao_alatur.request_number_arb. */
/*                                                                     */
/* CREATE tt-param.                                                    */
/* ASSIGN tt-param.CodigoARB = "33".                                   */
/*                                                                     */
/* ASSIGN c-msg = "msg0272".                                           */
/* RAW-TRANSFER tt-param TO raw-param.                                 */
/* {esp/esb/esesb006.i c-msg 'tst' 'tt-param'}                         */




/* DEFINE TEMP-TABLE tt-param NO-UNDO          */
/*     FIELD CodigoARB    AS CHAR              */
/*     FIELD DataPagamento       AS DATE       */
/*     FIELD TipoPagamento       AS CHAR       */
/*     FIELD Moeda               AS CHAR       */
/*     FIELD NumeroContaCorrente AS CHAR       */
/*     FIELD ProvisaoPagamento   AS CHAR       */
/*     FIELD Observacao          AS CHAR.      */
/*                                             */
/* CREATE tt-param.                            */
/* ASSIGN tt-param.CodigoARB = "33"            */
/*        tt-param.DataPagamento = TODAY       */
/*        tt-param.TipoPagamento = "R"         */
/*        tt-param.Moeda = "BRL"               */
/*        tt-param.NumeroContaCorrente = "123" */
/*        tt-param.ProvisaoPagamento   = "432" */
/*        tt-param.Observacao = "Observa‡Æo".  */
/*                                             */
/*                                             */
/* ASSIGN c-msg = "msg0273".                   */
/* RAW-TRANSFER tt-param TO raw-param.         */
/* {esp/esb/esesb006.i c-msg 'tst' 'tt-param'} */




DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD CodigoARB        AS CHAR
    FIELD NomeSolicitacao  AS CHAR
    FIELD ValorSolicitacao AS DEC.

CREATE tt-param.
ASSIGN tt-param.CodigoARB = "33"
       tt-param.NomeSolicitacao = "123"    
       tt-param.ValorSolicitacao = 100.00.


ASSIGN c-msg = "msg0274".
RAW-TRANSFER tt-param TO raw-param.
{esp/esb/esesb006.i c-msg 'tst' 'tt-param'}
