DEFINE TEMP-TABLE tt-item NO-UNDO 
    FIELD TipoTrans   AS   INT 
    /*
        CASE TipoTrans:
        WHEN 1 - Entrada
        WHEN 2 - Saida
        END.
    
    */
    FIELD cod-estabel  LIKE movto-estoq.cod-estabel
    FIELD it-codigo    LIKE movto-estoq.it-codigo
    FIELD cod-depos    LIKE movto-estoq.cod-depos
    FIELD quantidade   LIKE movto-estoq.quantidade  
    FIELD serie        LIKE movto-estoq.serie       
    FIELD nro-docto    LIKE movto-estoq.nro-docto  
    FIELD cod-localiz  LIKE movto-estoq.cod-localiz 
    FIELD lote         LIKE movto-estoq.lote        
    FIELD dt-vali-lote AS   DATE
    FIELD cod-refer    LIKE movto-estoq.cod-refer.  
