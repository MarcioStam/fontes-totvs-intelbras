/* esp/rep/esrep008.i */

CREATE tt-conta.
ASSIGN tt-conta.nro-docto      = it-nota-fisc.nr-nota-fis
       tt-conta.serie-docto    = it-nota-fisc.serie
       tt-conta.cod-emitente   = nota-fiscal.cod-emitente
       tt-conta.nat-operacao   = it-nota-fisc.nat-operacao
       tt-conta.it-codigo      = it-nota-fisc.it-codigo
       tt-conta.sequencia      = it-nota-fisc.nr-seq-fat
       tt-conta.conta-contabil = {1}.

IF  {2} < 0 THEN
    ASSIGN tt-conta.de-debito  = -({2})
           tt-conta.de-credito = 0.
ELSE
    ASSIGN tt-conta.de-credito = {2}
           tt-conta.de-debito  = 0.

/* ESREP008.I */
