FIND FIRST moeda NO-LOCK
    WHERE moeda.mo-codigo = b-tb-preco.mo-codigo NO-ERROR.

CREATE msg0195.
ASSIGN msg0195.TabelaPrecoEMS = b-tb-preco.nr-tabpre
       msg0195.NomeTabela     = b-tb-preco.descricao
       msg0195.DataInicial    = b-tb-preco.dt-inival
       msg0195.DataFinal      = b-tb-preco.dt-fimval
       msg0195.CodigoMoeda    = b-tb-preco.mo-codigo
       msg0195.NomeMoeda      = IF  AVAIL moeda THEN moeda.descricao ELSE ""
       msg0195.SituacaoTabela = {1} . /* Manuten‡Æo */

RAW-TRANSFER msg0195 TO raw-param.

RUN esp/esb/esesb003.p (INPUT        "msg0195", /* Nome Mensagem */  
                        INPUT        raw-param, /* Tupla do registro */
                        OUTPUT TABLE resultado  /* Retorno do barramento */) NO-ERROR.
