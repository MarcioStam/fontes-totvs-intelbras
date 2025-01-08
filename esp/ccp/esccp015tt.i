def temp-table ttcomponente no-undo
   field sequencia     like estrutura.sequencia 
   field es-codigo     like estrutura.es-codigo 
   field desc-item     like item.desc-item
   field quant-est     like estrutura.quant-usada format ">>>,>>>,>>9.99999"
   field quant-solic   like estrutura.quant-usada format ">>>,>>>,>>9.99999" label "Qt Solic" help "Quantidade a ser comprada"
   field un            like item.un
   field preco-unit    like cotacao-item.preco-unit format ">>>,>>>,>>9.99999"
   field inclui-ipi    as logical format "Sim/NÆo" label "Inclui IPI?"     help "Informe se o pre‡o informado inclui IPI"
   field numero-ordem  like ordem-compra.numero-ordem
   field parcela       like prazo-compra.parcela
   FIELD cod-emitente  LIKE item-fornec-estab.cod-emitente
   FIELD nome-abrev    LIKE emitente.nome-abrev
   FIELD lote-minimo   LIKE item-fornec-estab.lote-minimo
   FIELD lote-mul-for  LIKE item-fornec-estab.lote-mul-for
   FIELD cod-situacao    AS INT
   FIELD des-situacao    AS CHAR
   index idx_comp 
            sequencia 
            es-codigo.
   
DEFINE TEMP-TABLE tt-estrutura NO-UNDO LIKE estrutura.
