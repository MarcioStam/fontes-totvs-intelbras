def temp-table tt-estrutura
    field seq           as integer
    field it-codigo     like estrutura.it-codigo
    field nivel         as char format "X(16)"
    field row-estrutura as rowid
    field es-codigo     like estrutura.es-codigo
    field refer like    ref-item.cod-refer
    field quant-usada   like estrutura.quant-usada     
    field quant-liquid  like estrutura.quant-liquid
    field descricao     like item.desc-item
    field da-inicio     like estrutura.data-inicio
    field compr-fabric  like item.compr-fabric
    FIELD log-fantasma  AS   LOGICAL 
    field un            like item.un
    field aux as char   format "X(4)" 
    INDEX seq IS primary seq ASCENDING
    INDEX es-codigo es-codigo.    
