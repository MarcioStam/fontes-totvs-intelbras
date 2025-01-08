FIND FIRST tb-preco NO-LOCK
    WHERE tb-preco.nr-tabpre = b-preco-item.nr-tabpre NO-ERROR.

IF  AVAIL tb-preco THEN 
    FIND FIRST moeda NO-LOCK
        WHERE moeda.mo-codigo = tb-preco.mo-codigo NO-ERROR.

CREATE msg0195.
ASSIGN msg0195.TabelaPrecoEMS   = tb-preco.nr-tabpre
       msg0195.NomeTabela       = tb-preco.descricao
       msg0195.DataInicial      = tb-preco.dt-inival
       msg0195.DataFinal        = tb-preco.dt-fimval
       msg0195.CodigoMoeda      = tb-preco.mo-codigo
       msg0195.NomeMoeda        = IF  AVAIL moeda THEN moeda.descricao ELSE ""
       msg0195.SituacaoTabela   = {1}. /* Manetencao */

/* PRODUTO */
ASSIGN msg0195.CodigoProduto    = b-preco-item.it-codigo
       msg0195.CodigoItemPreco  = TRIM(STRING(b-preco-item.it-codigo)) + "," +
                                  TRIM(STRING(b-preco-item.cod-refer)) + "," +
                                  TRIM(STRING(b-preco-item.nr-tabpre)) + "," +
                                  TRIM(STRING(b-preco-item.dt-inival)) + "," +
                                  TRIM(STRING(b-preco-item.quant-min))
       msg0195.PrecoFOB         = b-preco-item.preco-fob
       msg0195.PrecoMinimoCIF   = b-preco-item.preco-min-cif
       msg0195.PrecoMinimoFOB   = b-preco-item.preco-min-fob
       msg0195.PrecoVenda       = b-preco-item.preco-Venda 
       msg0195.QuantidadeMinima = b-preco-item.quant-min
       msg0195.SituacaoItem     = {2}. /* Manuten‡Æo ou Elimina‡Æo*/

FIND FIRST int-preco-item
     WHERE int-preco-item.it-codigo = b-preco-item.it-codigo
       AND int-preco-item.cod-refer = b-preco-item.cod-refer
       AND int-preco-item.nr-tabpre = b-preco-item.nr-tabpre
       AND int-preco-item.dt-inival = b-preco-item.dt-inival
       AND int-preco-item.quant-min = b-preco-item.quant-min NO-LOCK NO-ERROR.

IF AVAILABLE int-preco-item THEN
    ASSIGN msg0195.Precounico  = int-preco-item.preco-unico
           msg0195.pma         = int-preco-item.pma
           msg0195.pmd         = int-preco-item.pmd.

/*DEF VAR raw-param AS RAW NO-UNDO.*/

RAW-TRANSFER msg0195 TO raw-param.

RUN esp/esb/esesb003.p (INPUT        "msg0195", /* Nome Mensagem */  
                        INPUT        raw-param, /* Tupla do registro */
                        OUTPUT TABLE resultado  /* Retorno do barramento */) NO-ERROR.
