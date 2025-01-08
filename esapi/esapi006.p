{include/i-prgvrs.i ESAPI006 2.04.00.001}
/***********************************************************************
**  Programa..: ESAPI\ESAPI006.P
**  Autor.....: Marcio Chaves - Gestech
**  Data......: NOVEMBRO/2004 - Desenvolvimento
**  Descricao.: Busca Recursiva Estrutura Produto
**  VersÆo....: 001 61/11/2004
**                  Desenvolvimento Programa
**              (l-recursivo AND b-estrutura.fantasma) --> 
**              Pela necessidade da Intelbras, s¢ desce n¡vel se for "#"  
************************************************************************/
def temp-table tt-estrutura-aux
    field seq           as integer
    field it-codigo     like estrutura.it-codigo
    field nivel         as char format "X(16)"
    field row-estrutura as rowid
    field es-codigo     like estrutura.es-codigo
    field refer like    ref-item.cod-refer
    field quant-usada   like estrutura.quant-usada     
    field quant-liquid  like estrutura.quant-liquid
    field aux as char   format "X(4)" 
    INDEX seq IS primary seq ASCENDING
    INDEX es-codigo es-codigo.

{esapi/esapi006tt.i}

define input        parameter v-row-item    as rowid no-undo.
define input        parameter p-refer       as char no-undo.
define input        parameter p-quantidade  as decimal no-undo.
define input        parameter p-quant-liq   as decimal no-undo.
define input        parameter p-nivel       as integer no-undo.
define input-output parameter table         for tt-estrutura.
define input        parameter da-data-corte as date.
define input        parameter l-recursivo   as logical.
define input        parameter i-niveis      as integer.
define input        parameter p-estab       as char.

/* DEFINI€ÇO DOS PAR¶METROS **************************************************
** 
** v-row-item     => registro da tabela item 
** p-refer        => ref-item.cod-refer
** de-quant-usada => quantidade usada do componente na estrutura
** de-quant-liq   => quantidade liquida do componente descontado o percentual
**                   de perda QL = QB * (1 - FP/100)
**                   FP = Fator de perda.
** p-nivel        => nivel onde o componente se encontra na estrutura 
** tt-estrutura   => ‚ necess rio o resultado da tt-estrutura como parƒmetro
**                   para que a mesma nÆo seja definida como "shared"
** l-recursivo    => vari vel l¢gica que seta para que des‡a a estrutura 
** i-niveis       => vari vel definida nos parƒmetros onde o usu rio indica
**                   a quantos n¡veis deseja descer a estrutura .
** p-estab        => Estabelecimento do processo utilizado                     
******************************************************************************/                                                               

define buffer b-item  for item.
define buffer b1-item for item.
define buffer b2-item for item.
define buffer b3-item for item.
define buffer b4-item for item.
define buffer b-estrutura for estrutura.

define var c-comp           as char format "x(1)".
define var c-fabr           as char format "x(1)".
define var c-alt            as char format "x(1)".
define var i-nivel          as integer init 1.
define var i-seq            as integer.
define var i-cont           as integer.
define var de-quant-usada   as decimal.
define var i                as integer.
define var c-refer-es       like ref-item.cod-refer.
define var l-refer-incluida as logical.

def var c-lista  as char no-undo.
def var c-lista2 as char no-undo.
def var c-lista3 as char no-undo.

{cdp/cdcfgman.i}

for first b1-item fields ( it-codigo  tipo-con-est compr-fabric )
    where rowid(b1-item) = v-row-item no-lock :
end.
 
run pi-retorna-lista (input  b1-item.it-codigo,
                      output c-lista).

{utp/ut-liter.i Alternativo}
 c-alt   = substr(return-value,1,1).
  
  assign c-comp  = substr({ininc/i01in172.i 04 1},1,1)
         c-fabr  = substr({ininc/i01in172.i 04 2},1,1)
         i-seq   = 1
         i-nivel = 1  .
         
&if defined (bf_man_sfc_lc) &then
    for each b-estrutura fields (data-inicio data-termino es-codigo quant-usada
                                 proporcao fator-perda  it-codigo sequencia fantasma
                                 qtd-compon qtd-item cod-lista-compon)
    of b1-item no-lock:
&else
    for each b-estrutura fields (data-inicio data-termino es-codigo quant-usada
                                 proporcao fator-perda  it-codigo sequencia fantasma
                                 cod-lista-compon )
    of b1-item no-lock:
&endif

     if b-estrutura.cod-lista-compon <> c-lista then next.

     if (b-estrutura.data-inicio  <= da-data-corte and
         b-estrutura.data-termino > da-data-corte) or da-data-corte = ? then do:
          
        for first b2-item fields (it-codigo tipo-con-est compr-fabric) where 
                  b2-item.it-codigo = b-estrutura.es-codigo no-lock:
   
        end.
          
        if not avail b2-item then next.
        
        &IF DEFINED (bf_man_sfc_lc) &THEN
        assign de-quant-usada =  p-quantidade * b-estrutura.qtd-compon / b-estrutura.qtd-item *
                                (b-estrutura.proporcao / 100)
               p-quant-liq    = (p-quantidade * b-estrutura.qtd-compon / b-estrutura.qtd-item
                               * b-estrutura.proporcao / 100) * (1 - (b-estrutura.fator-perda / 100)).             
        &ELSE
        assign de-quant-usada =  p-quantidade * b-estrutura.quant-usada *
                                (b-estrutura.proporcao / 100)
               p-quant-liq    = (p-quantidade * b-estrutura.quant-usada
                               * b-estrutura.proporcao / 100) * (1 - (b-estrutura.fator-perda / 100)).             
        &ENDIF
        
        if b2-item.tipo-con-est = 4 or 
           b1-item.tipo-con-est = 4 then do:
              find first ref-estrut where 
                         ref-estrut.it-codigo  = b-estrutura.it-codigo and  
                         ref-estrut.es-codigo  = b-estrutura.es-codigo and
                         ref-estrut.sequencia  = b-estrutura.sequencia no-lock no-error.
              if not available ref-estrut then
                 assign c-refer-es       = ""
                        l-refer-incluida = yes.
              else do:
                 find first ref-estrut where 
                            ref-estrut.it-codigo  = b-estrutura.it-codigo and  
                            ref-estrut.cod-ref-it = p-refer and  
                            ref-estrut.es-codigo  = b-estrutura.es-codigo and
                            ref-estrut.sequencia  = b-estrutura.sequencia no-lock no-error.
                 if available ref-estrut then          
                    assign c-refer-es       = ref-estrut.cod-ref-es
                           l-refer-incluida = yes.
                 else          
                    assign l-refer-incluida = no.
              end.         
        end.
        else
          assign l-refer-incluida = yes
                 c-refer-es       = ''.


        if l-refer-incluida then do:  
            create tt-estrutura.
            assign tt-estrutura.it-codigo     = b-estrutura.it-codigo
                   tt-estrutura.seq           = i-seq
                   tt-estrutura.refer         = c-refer-es
                   tt-estrutura.row-estrutura = rowid(b-estrutura)
                   tt-estrutura.es-codigo     = b-estrutura.es-codigo                  
                   tt-estrutura.compr-fabric  = b2-item.compr-fabric
                   tt-estrutura.quant-usada   = de-quant-usada
                   tt-estrutura.quant-liquid  = p-quant-liq
                   tt-estrutura.log-fantasma  = b-estrutura.fantasma
                   i-seq                          = i-seq + 1.
        
            if b-estrutura.fantasma then 
               assign tt-estrutura.aux = '#'.
            else
               assign tt-estrutura.aux = ' '.
           
            if b2-item.compr-fabric = 1 then           
               assign tt-estrutura.aux = tt-estrutura.aux +  c-comp.
            else     
               assign tt-estrutura.aux = tt-estrutura.aux +  c-fabr.
                  
            find first alternativo where 
                       alternativo.es-codigo = b-estrutura.es-codigo and
                       alternativo.it-codigo = b-estrutura.it-codigo and
                       alternativo.sequencia = b-estrutura.sequencia no-lock no-error.
            if available alternativo then
               assign tt-estrutura.aux = tt-estrutura.aux +  c-alt.
            else   
               assign tt-estrutura.aux = tt-estrutura.aux +  ' '.
         
            if today >= b-estrutura.data-termino or today < data-inicio then
               assign tt-estrutura.aux = tt-estrutura.aux +  '?'.
            
            assign tt-estrutura.nivel = string('1','x(12)') + tt-estrutura.aux.    
        /* l-recursivo */
            if l-refer-incluida and i-niveis > i-nivel AND (l-recursivo AND b-estrutura.fantasma) then do:
               run pi-retorna-lista (input  tt-estrutura.es-codigo,
                                     output c-lista2).
               run pi-gera-tt-estrutura-filho(rowid(b2-item),
                                              c-refer-es,
                                              de-quant-usada, 
                                              p-quant-liq,
                                              i-nivel,
                                              input-output table tt-estrutura,
                                              da-data-corte,
                                              l-recursivo,
                                              i-niveis,
                                              c-lista2).
                                             
            end.   
        end.
     end.
  end.

PROCEDURE pi-gera-tt-estrutura-filho :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
define input        parameter v-row-item    as rowid no-undo.
define input        parameter p-refer       as char no-undo.
define input        parameter p-quantidade  as decimal no-undo.
define input        parameter p-quant-liq   as decimal no-undo.
define input        parameter p-nivel       as integer no-undo.
define input-output parameter table         for tt-estrutura.
define input        parameter da-data-corte as date.
define input        parameter l-recursivo   as logical.
define input        parameter i-niveis      as integer.
define input        parameter p-lista       as char.

define buffer b1-item for item.
define buffer b2-item for item.
define buffer b-estrutura for estrutura.

define var de-quant-usada as decimal.
define var i              as integer.


for first b1-item fields ( it-codigo tipo-con-est compr-fabric ) where 
     rowid(b1-item) = v-row-item no-lock:
end.

assign p-nivel = p-nivel + 1.

&if defined (bf_man_sfc_lc) &then
    for each  b-estrutura fields (data-inicio data-termino es-codigo quant-usada
                      proporcao   fator-perda  it-codigo sequencia fantasma 
                      qtd-compon qtd-item cod-lista-compon)
    of b1-item no-lock:
&else
    for each  b-estrutura fields (data-inicio data-termino es-codigo quant-usada
                      proporcao   fator-perda  it-codigo sequencia fantasma
                                  cod-lista-compon  )
    of b1-item no-lock:
&endif

    if b-estrutura.cod-lista-compon <> p-lista then next.

   if (b-estrutura.data-inicio  <= da-data-corte and
       b-estrutura.data-termino >  da-data-corte) or da-data-corte = ? then do:

       for first b2-item fields (it-codigo tipo-con-est compr-fabric) where 
            b2-item.it-codigo = b-estrutura.es-codigo no-lock:
       end.
       if not avail b2-item then next.
       
       &IF DEFINED (bf_man_sfc_lc) &THEN
       assign de-quant-usada =  p-quantidade * b-estrutura.qtd-compon / b-estrutura.qtd-item *
                               (b-estrutura.proporcao / 100)
              p-quant-liq    = (p-quantidade * b-estrutura.qtd-compon / b-estrutura.qtd-item
                             *  b-estrutura.proporcao / 100) * (1 - (b-estrutura.fator-perda / 100)).            
       &ELSE
       assign de-quant-usada =  p-quantidade * b-estrutura.quant-usada *
                               (b-estrutura.proporcao / 100)
              p-quant-liq    = (p-quantidade * b-estrutura.quant-usada 
                             *  b-estrutura.proporcao / 100) * (1 - (b-estrutura.fator-perda / 100)).       
       &ENDIF
      
      if  b2-item.tipo-con-est = 4 or 
          b1-item.tipo-con-est = 4 then do:
            find first ref-estrut where 
                        ref-estrut.it-codigo  = b-estrutura.it-codigo and  
                        ref-estrut.es-codigo  = b-estrutura.es-codigo and
                        ref-estrut.sequencia  = b-estrutura.sequencia no-lock no-error.
            
            if  not available ref-estrut then
                assign c-refer-es       = ""
                       l-refer-incluida = yes.
            else do:
                  find first ref-estrut where 
                       ref-estrut.it-codigo  = b-estrutura.it-codigo and  
                       ref-estrut.cod-ref-it = p-refer and  
                       ref-estrut.es-codigo  = b-estrutura.es-codigo and
                       ref-estrut.sequencia  = b-estrutura.sequencia no-lock no-error.
                  
                  if available ref-estrut then
                     assign c-refer-es       = ref-estrut.cod-ref-es
                            l-refer-incluida = yes.
                  else   
                     assign l-refer-incluida = no.
            end.          
      end.
      else
          assign l-refer-incluida = yes
                 c-refer-es       = ''.

      if  l-refer-incluida then do:

          create tt-estrutura.
          assign tt-estrutura.seq           = i-seq
                 tt-estrutura.refer         = c-refer-es
                 tt-estrutura.row-estrutura = rowid(b-estrutura)
                 tt-estrutura.es-codigo     = b-estrutura.es-codigo
                 tt-estrutura.compr-fabric  = b2-item.compr-fabric
                 tt-estrutura.quant-usada   = de-quant-usada
                 tt-estrutura.quant-liquid  = p-quant-liq
                 tt-estrutura.log-fantasma  = b-estrutura.fantasma
                 i-seq                          = i-seq + 1.
                   
          if  b-estrutura.fantasma then 
              assign tt-estrutura.aux = '#'.
          else
              assign tt-estrutura.aux = ' '.
           
          if  b2-item.compr-fabric = 1 then           
              assign tt-estrutura.aux = tt-estrutura.aux +  c-comp.
          else     
              assign tt-estrutura.aux = tt-estrutura.aux +  c-fabr.
                  
          find first alternativo where 
                     alternativo.es-codigo = b-estrutura.es-codigo and
                     alternativo.it-codigo = b-estrutura.it-codigo and
                     alternativo.sequencia = b-estrutura.sequencia no-lock no-error.
          if  available alternativo then
              assign tt-estrutura.aux = tt-estrutura.aux +  c-alt.
          else   
              assign tt-estrutura.aux = tt-estrutura.aux +  ' '.
        
          if  today >= b-estrutura.data-termino or today < b-estrutura.data-inicio then
              assign tt-estrutura.aux = tt-estrutura.aux +  '?'.
         
          assign tt-estrutura.nivel = string(p-nivel, ">9").
          do i = 3 to p-nivel:
               assign tt-estrutura.nivel = ' ' + tt-estrutura.nivel.
               if i = 10 then leave.  
          end.     
          assign tt-estrutura.nivel = string(tt-estrutura.nivel, 'x(12)') + tt-estrutura.aux.    
     
          if l-refer-incluida and i-niveis > p-nivel AND (l-recursivo AND b-estrutura.fantasma) then do: 
             run pi-retorna-lista (input  tt-estrutura.es-codigo,
                                   output c-lista3).
             run pi-gera-tt-estrutura-filho(rowid(b2-item),
                                            c-refer-es, 
                                            de-quant-usada,
                                            p-quant-liq,
                                            p-nivel,
                                            input-output table tt-estrutura,
                                            da-data-corte,
                                            l-recursivo,
                                            i-niveis,
                                            c-lista3).
          end.
      end.
  end.
end.

end procedure.

procedure pi-retorna-lista:
    define input  parameter p-item  as char no-undo.
    define output parameter p-lista as char no-undo.

    find first b4-item 
         where b4-item.it-codigo = p-item no-lock no-error.
    find first proces-item 
         where proces-item.it-codigo   = b4-item.it-codigo
           and proces-item.cod-estabel = p-estab  no-lock no-error.
    if avail proces-item then do:
       find first lista-compon-item
            where lista-compon-item.it-codigo        = proces-item.it-codigo
              and lista-compon-item.cod-lista-compon = proces-item.cod-lista-compon
              no-lock no-error.
       if avail lista-compon-item then 
          assign p-lista = lista-compon-item.cod-lista-compon.
       else
          assign p-lista = "".
    end.
    else do:
     find first lista-compon-item
          where lista-compon-item.it-codigo = b4-item.it-codigo
            no-lock no-error.
     if avail lista-compon-item then 
        assign p-lista = lista-compon-item.cod-lista-compon.
     else
        assign p-lista = "".
    end.

end procedure.
