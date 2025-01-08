
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


def input-output parameter table for tt-item.
def input-output parameter table for tt-prod-composto.

def var i-cont as int.

find first tt-item  no-lock no-error.

if avail tt-item then do:
   /*
   find first ITEM NO-LOCK 
        WHERE ITEM.it-codigo    = tt-item.it-codigo
          AND item.cod-obsoleto = 1
          AND item.ind-item-fat = YES no-error.*/

   FIND FIRST ITEM NO-LOCK 
        WHERE ITEM.it-codigo    = tt-item.it-codigo
   NO-ERROR.

   IF AVAIL ITEM THEN DO: 
      FIND FIRST unid-negoc NO-LOCK
           WHERE unid-negoc.cod-unid-neg = ITEM.cod-unid-neg NO-ERROR.
      RUN pi-produto.       
   END.
end. 
else do:
   FOR EACH ITEM NO-LOCK 
      WHERE ITEM.cod-obsoleto <= 2 
        AND ITEM.ind-item-fat = YES,
      FIRST unid-negoc NO-LOCK
      WHERE unid-negoc.cod-unid-neg = ITEM.cod-unid-neg :
     assign i-cont = i-cont + 1.
     create tt-item.
     assign tt-item.sequencia            = i-cont
            tt-item.it-codigo            = ITEM.it-codigo.
     RUN pi-produto.       
     
   END.
end.


FOR EACH tt-prod-composto BREAK BY tt-prod-composto.it-codigo-filho:
    IF FIRST-OF(tt-prod-composto.it-codigo-filho) THEN DO:
        ASSIGN i-cont = i-cont + 1.
        FIND FIRST tt-item
             WHERE tt-item.it-codigo = tt-prod-composto.it-codigo-filho NO-LOCK NO-ERROR.
        IF NOT AVAIL tt-item THEN DO:
           FIND FIRST ITEM WHERE ITEM.it-codigo = tt-prod-composto.it-codigo-filho NO-LOCK NO-ERROR.

           IF AVAIL ITEM THEN DO:
              create tt-item.
              assign tt-item.sequencia  = i-cont
                     tt-item.it-codigo  = ITEM.it-codigo.
              RUN pi-produto.
           END.
        END.
    END.
END.


PROCEDURE pi-produto.
    FIND FIRST item-dun
         WHERE item-dun.it-codigo = item.it-codigo NO-LOCK NO-ERROR. 

    FIND FIRST fam-comerc
         WHERE fam-comerc.fm-cod-com = ITEM.fm-cod-com NO-LOCK NO-ERROR.

    FIND FIRST grup-estoque
         WHERE grup-estoque.ge-codigo = ITEM.ge-codigo NO-LOCK NO-ERROR.

    ASSIGN tt-item.descricao-1          = item.descricao-1           // productName
           tt-item.desc-item            = item.desc-item             // description
           tt-item.desc-inter           = item.desc-inter     .       // internationalDescription
 
    FIND FIRST fam-com-item NO-LOCK
         where fam-com-item.unidade  = SUBSTRING(fam-comerc.fm-cod-com,1,2) 
           AND fam-com-item.segmento = "" 
           AND fam-com-item.familia1 = "" 
           AND fam-com-item.familia2 = "" 
           AND fam-com-item.origem   = "" NO-ERROR.
    IF AVAIL fam-com-item THEN
       assign tt-item.cod-unid-neg         = fam-com-item.unidade        // businessUnitCode
              tt-item.des-unid-negoc       = fam-com-item.descricao.     // businessUnitDescription

    FIND FIRST fam-com-item NO-LOCK
         where fam-com-item.unidade  = SUBSTRING(fam-comerc.fm-cod-com,1,2) 
           AND fam-com-item.segmento = SUBSTRING(fam-comerc.fm-cod-com,3,2) 
           AND fam-com-item.familia1 = "" 
           AND fam-com-item.familia2 = "" 
           AND fam-com-item.origem   = "" NO-ERROR.
    IF AVAIL fam-com-item THEN
       assign tt-item.segmento          = string(fam-com-item.unidade) + string(fam-com-item.segmento)      //segmentCode
              tt-item.des-segmento      = fam-com-item.descricao.    //segmentDescription

    FIND FIRST fam-com-item NO-LOCK 
         where fam-com-item.unidade  = SUBSTRING(fam-comerc.fm-cod-com,1,2) 
           AND fam-com-item.segmento = SUBSTRING(fam-comerc.fm-cod-com,3,2)
           AND fam-com-item.familia1 = SUBSTRING(fam-comerc.fm-cod-com,5,1) 
           AND fam-com-item.familia2 = "" 
           AND fam-com-item.origem   = "" NO-ERROR.
    IF AVAIL fam-com-item THEN
       assign tt-item.familia1          = string(fam-com-item.unidade) + string(fam-com-item.segmento) + string(fam-com-item.familia1)       //productFamilyCode
              tt-item.des-familia1      = fam-com-item.descricao.    //productFamilyDescription

    FIND FIRST fam-com-item NO-LOCK
         where fam-com-item.unidade  = SUBSTRING(fam-comerc.fm-cod-com,1,2) 
           AND fam-com-item.segmento = SUBSTRING(fam-comerc.fm-cod-com,3,2) 
           AND fam-com-item.familia1 = SUBSTRING(fam-comerc.fm-cod-com,5,1)
           AND fam-com-item.familia2 = SUBSTRING(fam-comerc.fm-cod-com,6,2)
           AND fam-com-item.origem   = "" NO-ERROR.
    IF AVAIL fam-com-item THEN
       assign tt-item.familia2          = string(fam-com-item.unidade) + string(fam-com-item.segmento) + string(fam-com-item.familia1) + string(fam-com-item.familia2)        //subFamilyCode
              tt-item.des-familia2      = fam-com-item.descricao.    //subFamilyDescription

    FIND FIRST fam-com-item NO-LOCK
         where fam-com-item.unidade  = SUBSTRING(fam-comerc.fm-cod-com,1,2) 
           AND fam-com-item.segmento = SUBSTRING(fam-comerc.fm-cod-com,3,2) 
           AND fam-com-item.familia1 = SUBSTRING(fam-comerc.fm-cod-com,5,1)
           AND fam-com-item.familia2 = SUBSTRING(fam-comerc.fm-cod-com,6,2) 
           AND fam-com-item.origem   <> "" NO-ERROR.
    IF AVAIL fam-com-item THEN
       assign tt-item.origem            = string(fam-com-item.unidade) + string(fam-com-item.segmento) + string(fam-com-item.familia1) + string(fam-com-item.familia2) + string(fam-com-item.origem)        //originCode
              tt-item.des-origem        = fam-com-item.descricao.    //originDescription

    FIND item-mat
         WHERE item-mat.it-codigo = item.it-codigo NO-LOCK NO-ERROR.
  

    assign tt-item.fm-cod-com           = item.fm-cod-com            //comercialFamilyCode
           tt-item.des-fam-comerc       = fam-comerc.descricao       //comercialFamilyDescription
           tt-item.ge-codigo            = ITEM.ge-codigo             //stockGroupCode
           tt-item.ge-descricao         = grup-estoque.descricao     //stockGroupDescription
           tt-item.aliquota-ipi         = item.aliquota-ipi          //percentIPI
           tt-item.compr-fabric         = item.compr-fabric          //productType
           tt-item.nature               = ITEM.compr-fabric          //nature
           tt-item.cod-dun              = if avail item-mat then item-mat.cod-ean  else ''      //EANcode
           tt-item.cod-obsoleto         = TRUE        //isActive  1 - ativo, 2/3/4 - inativo
           tt-item.ncm                  = ITEM.class-fiscal.

    IF ITEM.cod-servico <> 0 THEN 
       ASSIGN tt-item.log-servico = YES.
    ELSE 
       ASSIGN tt-item.log-servico = NO.

    IF cod-servico = 0 THEN ASSIGN tt-item.tipo = 'Produto'.
    ELSE DO:
       FIND FIRST tab-codser
            WHERE tab-codser.cod-servico = ITEM.cod-servico NO-LOCK NO-ERROR.
       IF tab-codser.int-2 = 1 THEN ASSIGN tt-item.tipo = 'Saas'.
                               ELSE ASSIGN tt-item.tipo = 'Servico'.
    END.



    ASSIGN tt-item.ind-item-fat = item.ind-item-fat.

    FIND FIRST item-caixa 
         WHERE ITEM-caixa.it-codigo = ITEM.it-codigo NO-LOCK NO-ERROR.
    IF AVAIL item-caixa THEN
       ASSIGN tt-item.qtd-multipla = item-caixa.qt-item.
    ELSE
       ASSIGN tt-item.qtd-multipla = 1.

    FOR EACH prod-composto NO-LOCK
       WHERE prod-composto.it-codigo-pai       = ITEM.it-codigo :

       create tt-prod-composto.
       assign tt-prod-composto.it-codigo-pai     = ITEM.it-codigo
              tt-prod-composto.it-codigo-filho   = prod-composto.it-codigo-filho   //product
              tt-prod-composto.quant-usada       = prod-composto.qt-filho
			  tt-prod-composto.dec-1			 = prod-composto.dec-1.  //quantity
    END.
END.

