/**
 * Extrator para BI
 * DimensÆo: Item
 *
 * Autor: Felipe Braun Azambuja
 */

create widget-pool.

{include/i-freeac.i}

/** Include com a temp table principal e a temp table de parƒmetros **/
{bi/dim003tt.i}

define input  parameter table for tt-param.
define output parameter table for ttDimItem.

define variable i as integer no-undo.
DEF VAR c-numeros AS CHAR INIT "0123456789".
DEF VAR l-descarta AS LOG INIT NO no-undo.
DEF VAR c-ean      AS CHAR NO-UNDO.
DEF VAR j AS INTEGER NO-UNDO.

for each item no-lock:

   ASSIGN c-ean = ""
          l-descarta = NO.
   FIND item-mat NO-LOCK
        WHERE item-mat.it-codigo = ITEM.it-codigo NO-ERROR.
        
   IF  AVAIL item-mat THEN DO:
       DO  j = 1 TO LENGTH(item-mat.cod-ean):
            IF  INDEX(c-numeros, SUBSTR(item-mat.cod-ean,j,1)) = 0 THEN DO:
                l-descarta = YES.
                LEAVE.
            END.
        END.
   END.

   IF  NOT l-descarta 
   AND LENGTH(item-mat.cod-ean) <= 13 THEN
       ASSIGN c-ean = item-mat.cod-ean.

   find tab-unidade no-lock
      where tab-unidade.un = item.un no-error.

   create ttDimItem.
   assign ttDimItem.CD_Item              = fn-free-accent(item.it-codigo)
          ttDimItem.TX_Item              = item.desc-item
          ttDimItem.CD_Grupo_Estoque     = item.ge-codigo
          ttDimItem.CD_Familia_Comercial = item.fm-cod-com
          ttDimItem.CD_Unidade_Medida    = IF  AVAIL tab-unidade THEN tab-unidade.un ELSE ""
          ttDimItem.TX_Unidade_Medida    = IF  AVAIL tab-unidade THEN tab-unidade.descricao ELSE ""
          ttDimItem.CD_Tipo_Controle     = {ininc/i09in122.i 04 item.tipo-contr}
          ttDimItem.CD_Unidade_Negocio   = item.cod-unid-negoc
          ttDimItem.CD_EAN = dec(c-ean).

   find grup-estoq no-lock
      where grup-estoq.ge-codigo = item.ge-codigo no-error.

   if available (grup-estoq) then
      assign ttDimItem.TX_Grupo_Estoque = grup-estoq.descricao.


   /** Tratamento da fam¡lia comercial **/
   if (item.fm-cod-com <> '') and can-find (first fam-com-item
                                            where fam-com-item.fm-cod-com = item.fm-cod-com) then do:
      repeat i = 1 to 8:
         if (i = 1) or
            (i = 3) or
            (i = 6) then
            next.

         find fam-com-item no-lock
            where fam-com-item.fm-cod-com = substring(item.fm-cod-com, 1, i) no-error.

         if not available (fam-com-item) then
            next.

         case i:
            when 4 then
               assign ttDimItem.TX_Segmento = fam-com-item.descricao
                      ttDimItem.CD_Segmento = fam-com-item.fm-cod-com.
            when 2 then
               assign ttDimItem.TX_Unidade = fam-com-item.descricao.
            when 5 then
               assign ttDimItem.TX_Familia = fam-com-item.descricao
                      ttDimItem.CD_Familia = fam-com-item.fm-cod-com. 
            when 7 then
               assign ttDimItem.TX_Subfamilia = fam-com-item.descricao
                      ttDimItem.CD_Subfamilia = fam-com-item.fm-cod-com.
            when 8 then
               assign ttDimItem.TX_Origem = fam-com-item.descricao.
         end case.
      end.
   end.
end.
