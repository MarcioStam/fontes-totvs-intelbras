DEFINE VARIABLE jsonObjectOutput        AS JsonObject   NO-UNDO.
DEFINE VARIABLE jsonObjectPayload       AS jsonObject   NO-UNDO.
DEFINE VARIABLE objItem                 AS JsonObject   NO-UNDO.
DEFINE VARIABLE objKit                  AS JsonObject   NO-UNDO.
DEFINE VARIABLE arrayItem               AS jsonArray    NO-UNDO.
DEFINE VARIABLE arrayKit                AS jsonArray    NO-UNDO.

DEFINE VARIABLE c-jason                 AS CHAR   NO-UNDO.

def temp-table tt-item NO-UNDO XML-NODE-NAME 'Product'
    FIELD sequencia             AS INTEGER
    field it-codigo            LIKE ITEM.it-codigo
    field descricao-1          like item.descricao-1
    field desc-item             like item.desc-item
    field desc-inter            like item.desc-inter
    field cod-unid-negoc        like fam-com-item.unidade
    field des-unid-negoc        like fam-com-item.descricao
    field segmento              like fam-com-item.segmento
    field des-segmento          like fam-com-item.descricao
    field familia1              like fam-com-item.familia1
    field des-familia1          like fam-com-item.descricao
    field familia2              like fam-com-item.familia2
    field des-familia2          like fam-com-item.descricao
    field origem                like fam-com-item.origem
    field des-origem            like fam-com-item.descricao
    field fm-cod-com            like item.fm-cod-com
    field des-fam-comerc        like fam-comerc.descricao
    field ge-codigo             like item.ge-codigo
    field ge-descricao          like grup-estoque.descricao
    field aliquota-ipi          like item.aliquota-ipi 
    field compr-fabric          like item.compr-fabric
    field cod-dun               like item-dun.cod-dun
    field cod-obsoleto          AS LOGICAL  FORMAT 'true/false'
    FIELD qtd-multipla          AS DECIMAL
    FIELD log-servico           AS LOG
    FIELD ind-item-fat          LIKE item.ind-item-fat
    FIELD ncm                   LIKE ITEM.class-fiscal
    FIELD natureza              LIKE ITEM.compr-fabric
    FIELD tipo                  AS CHAR.

def temp-table tt-prod-composto NO-UNDO XML-NODE-NAME 'productKit'
    field it-codigo-pai        LIKE ITEM.it-codigo
    field it-codigo-filho      like prod-composto.it-codigo-filho
    field quant-usada          like prod-composto.qt-filho
	field dec-1				   as decimal.

DEF VAR c-dec-1-composto       AS CHAR.

/****************************************************************************************************/

PROCEDURE pi-gera-json.

    arrayItem  = NEW JsonArray().
    

        objItem = NEW JsonObject().

        objItem:ADD("product",                      STRING(tt-item.it-codigo)). 
        objItem:ADD("productName",                  STRING(tt-item.descricao-1)). 
        objItem:ADD("description",                  STRING(tt-item.desc-item)).   
        objItem:ADD("internationalDescription",     STRING(tt-item.desc-inter)).    
        objItem:ADD("businessUnitCode",             STRING(tt-item.cod-unid-negoc)). //
        objItem:ADD("businessUnitDescription",      STRING(tt-item.des-unid-negoc)). //
        objItem:ADD("segmentCode",                  STRING(tt-item.segmento)).       //
        objItem:ADD("segmentDescription",           STRING(tt-item.des-segmento)).
        objItem:ADD("productFamilyCode",            STRING(tt-item.familia1)).
        objItem:ADD("productFamilyDescription",     STRING(tt-item.des-familia1)).
        objItem:ADD("subFamilyCode",                STRING(tt-item.familia2)).
        objItem:ADD("subFamilyDescription",         STRING(tt-item.des-familia2)).
        objItem:ADD("originCode",                   STRING(tt-item.origem)).
        objItem:ADD("originDescription",            STRING(tt-item.des-origem)).
        objItem:ADD("comercialFamilyCode",          STRING(tt-item.fm-cod-com)).
        objItem:ADD("comercialFamilyDescription",   STRING(tt-item.des-fam-comerc)).
        objItem:ADD("stockGroupCode",               STRING(tt-item.ge-codigo)).
        objItem:ADD("stockGroupDescription",        STRING(tt-item.ge-descricao)).
        objItem:ADD("percentIPI",                   TRIM(STRING(tt-item.aliquota-ipi * 10000,">>>>>>>>9,9999"))).
        objItem:ADD("productType",                  IF tt-item.compr-fabric = 1 then 'Comprado' else 'Fabricado').
        objItem:ADD("EANcode",                      STRING(tt-item.cod-dun)).
        objItem:ADD("isActive",                     IF tt-item.ind-item-fat THEN TRUE ELSE FALSE).
        objItem:ADD("isService",                    IF tt-item.log-servico = YES THEN TRUE ELSE FALSE).
        objItem:ADD("multipleQuantity",             STRING(tt-item.qtd-multipla)).
        objItem:ADD("NCM",                          STRING(tt-item.ncm)).
        objItem:ADD("nature",                       IF tt-item.compr-fabric = 1 then 'Comprado' else 'Fabricado').
        objItem:ADD("type",                         tt-item.tipo).
             
        
        for EACH tt-prod-composto 
           where tt-prod-composto.it-codigo-pai = tt-item.it-codigo
            BREAK BY tt-prod-composto.it-codigo-pai :

            ASSIGN c-dec-1-composto =  STRING(tt-prod-composto.dec-1)
                   c-dec-1-composto = REPLACE(c-dec-1-composto,",",".").
           
           IF FIRST-OF(tt-prod-composto.it-codigo-pai) THEN DO:
               arrayKit   = NEW JsonArray(). 
           END.
            
           objKit = new JsonObject().
           
           objKit:ADD("product",                    STRING(tt-prod-composto.it-codigo-filho)).
           objKit:ADD("quantity",                   STRING(tt-prod-composto.quant-usada)).
           objKit:ADD("discount",                   c-dec-1-composto).
           
           arrayKit:ADD(objKit).

           IF LAST-OF(tt-prod-composto.it-codigo-pai) THEN DO:
              //arrayItem:ADD(arrayKit).
              objItem:ADD("productKit", (arrayKit)).
           END.
        end.
        arrayItem:ADD(objItem).

     

     jsonObjectOutput = NEW jsonObject().
     jsonObjectOutput:ADD("product", arrayItem).

     
END PROCEDURE. 




