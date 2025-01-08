/*****************************************************************************
**
**       Programa: en0105x
**       Data....: 30/07/2001
**       Autor...: Flavio Schoenell - Intelbras
**       Objetivo: Exportacao de locais de montagem da dp-estrut.
**
*****************************************************************************/
def input param r-dp-estrut as rowid   no-undo.
def input param c-acao      as char    no-undo.
def input param c-local-ant as char    no-undo.

{esp/enp/esenp001.i1}
{utp/ut-glob.i}
def temp-table tt-modelo  no-undo
    field modelo  as char
    field parte   as char
    index item modelo
               parte.

def temp-table tt-parte  no-undo
    field modelo as char
    field parte  as char 
    field item   as char
    field local-montag as char
    index chave
          modelo
          parte
          item
          local-montag.

def temp-table tt-parte-item no-undo
    field modelo  as char
    field parte   as char 
    field item    as char
    field posicao as char
    index chave
          modelo
          parte
          item
          posicao.

def buffer b-dp-estrut for dp-estrut.

def var l-texto       as logical no-undo.
def var i             as integer no-undo.
def var i-ind         as integer no-undo.
def var c-local       as char    no-undo.
def var c-letra       as char    no-undo.
def var c-parte       as char    no-undo.
def var c-parte1      as char    no-undo.
def var c-pos-ini     as char    no-undo.
def var c-pos-fim     as char    no-undo.
def var c-item-estrut as char    no-undo.
def var c-local-mont  as char    no-undo.

/******************   Inicio da trigger ******************************/
DEFINE NEW GLOBAL SHARED VAR vRowDp-Estrut   AS ROWID         NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR wh-local-montag AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE cLocalMontagem AS CHARACTER  NO-UNDO.

/*
find dp-estrut where rowid(dp-estrut) = r-dp-estrut no-lock.
*/
FOR FIRST dp-estrut 
    WHERE ROWID(dp-estrut) = vRowdp-estrut.
END.

/*IF NOT AVAIL dp-estrut THEN RETURN "OK".*/
ASSIGN cLocalMontagem = wh-local-montag:SCREEN-VALUE
       cLocalMontagem = REPLACE(cLocalMontagem,",",";")
       cLocalMontagem = REPLACE(cLocalMontagem," ","").

assign c-item-estrut  = dp-estrut.es-codigo
       c-local-mont   = cLocalMontagem /*dp-estrut.local-mont*/.

run pi-sobe-estrut (dp-estrut.es-codigo, c-item-estrut).

for each tt-modelo:
    create tt-parte.
    assign tt-parte.modelo  = tt-modelo.modelo
           tt-parte.parte   = tt-modelo.parte
           tt-parte.item    = c-item-estrut
           tt-parte.local-montag = if c-local-ant <> "" then 
                                      c-local-ant
                                   else 
                                      c-local-mont.
end.

for each tt-parte:
    run pi-testa-local-mont(tt-parte.local-mont, output l-texto).
                                              
    if l-texto = yes then do:
       create tt-parte-item.
       assign tt-parte-item.modelo  = tt-parte.modelo
              tt-parte-item.parte   = tt-parte.parte
              tt-parte-item.item    = tt-parte.item
              tt-parte-item.posicao = tt-parte.local-mont.
    end.          
    else do:
       if index(tt-parte.local-montag,";") = 0 
       and index(tt-parte.local-montag,"(") = 0 then do:
          run piCriaSegmento(INPUT tt-parte.local-montag,
                             INPUT "",
                             INPUT "", 
                             INPUT yes).
       end.
       else do i = 1 to num-entries(tt-parte.local-montag,";"):
          assign c-local = entry(i,tt-parte.local-montag,";").
          if index(c-local,"(") = 0 then do:
             assign c-letra = c-local
                    c-parte = "".
             run piCriaSegmento(INPUT c-letra,
                                INPUT "",
                                INPUT "",
                                INPUT yes).       
          end.
          else do:
             assign c-letra = substr(c-local,1,index(c-local,"(") - 1)
                    c-parte = substr(c-local,
                              index(c-local,"(") + 1, 
                              index(c-local,")") - (index(c-local,"(") + 1)).
       
             do i-ind = 1 to num-entries(c-parte,","):
                assign c-parte1 = entry(i-ind,c-parte,",") no-error.
                if index(c-parte1,"-") <> 0 then do:
                   assign c-pos-ini = entry(1,c-parte1,"-")
                          c-pos-fim = entry(2,c-parte1,"-").
                   if asc(caps(c-pos-ini)) >= 65 then do:
                      run piCriaSegmento(INPUT c-letra, 
                                         INPUT c-pos-ini, 
                                         INPUT c-pos-fim, 
                                         INPUT yes).
                   end.   
                   else do:
                      run piCriaSegmento(INPUT c-letra, 
                                         INPUT c-pos-ini, 
                                         INPUT c-pos-fim, 
                                         INPUT no).
                   end.   
                end.
                else do:
                   run piCriaSegmento(INPUT c-letra, 
                                      INPUT c-parte1, 
                                      INPUT c-parte1, 
                                      INPUT yes).
                end.
             end.  
          end.    
       end.
    end.
end.

for each tt-parte-item:
    /*
    if substring(entry(1,dbparam("mgadm"),"."), 
       length(entry(1,dbparam("mgadm"),".")) - 5 , 3 ) <> "int" then */

   /*
   if substring(entry(1,c-seg-usuario,"."), 
      length(entry(1,c-seg-usuario,".")) - 5 , 3 ) <> "int" then 
      run esp/es0669.p (input c-acao, 
                        "parte-item", 
                        tt-parte-item.modelo, 
                        tt-parte-item.parte, 
                        tt-parte-item.item, 
                        tt-parte-item.posicao, 
                        "", "", "", "", "").*/
end.

/***************************** PROCEDURES ************************************/

procedure pi-sobe-estrut:
   def input param c-item as char no-undo.
   def input param c-parte as char no-undo.

   find first b-dp-estrut where b-dp-estrut.es-codigo 
                              = c-item 
                          no-lock no-error.
   if not avail b-dp-estrut then do:
      if c-item begins "4" then do:
         find first tt-modelo where tt-modelo.modelo = c-item no-lock no-error.
         if not avail tt-modelo then do:
            create tt-modelo.
            assign tt-modelo.modelo = c-item
                   tt-modelo.parte  = c-parte.
         end.
      end.
   end.
   else do:
      for each b-dp-estrut where b-dp-estrut.es-codigo = c-item 
                           no-lock:
/*          message b-dp-estrut.item-dp b-dp-estrut.es-codigo c-parte view-as alert-box. */
          if b-dp-estrut.item-dp begins "7" or 
             b-dp-estrut.item-dp begins "8" then do:
             find first tt-modelo where tt-modelo.modelo = b-dp-estrut.es-codigo
                                    and tt-modelo.parte  = c-parte
                                  no-error.
             if not avail tt-modelo then do:                     
                create tt-modelo.
                assign tt-modelo.modelo = b-dp-estrut.es-codigo
                       tt-modelo.parte  = c-parte.
             end.
          end.
          else do:
             /* NÆo ser  mais utilizado segundo claudiney - Garantia foi desativado
             if b-dp-estrut.u-dec-1 = 0 then */
                assign c-parte = b-dp-estrut.item-dp.
             run pi-sobe-estrut(b-dp-estrut.item-dp, c-parte).
          end.
      end.
   end.
end.


procedure piCriaSegmento:
   def input param c-letra as char no-undo.
   def input param c-ini   as char no-undo.
   def input param c-fim   as char no-undo.
   def input param l-alfa  as logical no-undo.
   
   def var c-carac as char    no-undo.
   def var c-pos   as char    no-undo.
   def var i       as integer no-undo.
   def var ini     as int     no-undo.
   def var fim     as int     no-undo.
   
   if l-alfa = no then do:
      assign ini = int(c-ini)
             fim = int(c-fim).
      do i = ini to fim:
         assign c-carac  = caps(string(i)).
         create tt-parte-item.
         assign tt-parte-item.modelo  = tt-parte.modelo
                tt-parte-item.parte   = tt-parte.parte
                tt-parte-item.item    = tt-parte.item
                tt-parte-item.posicao = caps(c-letra)
                c-pos                 = trim(c-carac). 
         if trim(c-pos) = "0" then 
            assign c-pos = "".
         assign tt-parte-item.posicao = tt-parte-item.posicao + c-pos.
      end.
   end.
   else do:
      if c-ini = c-fim then do:
         create tt-parte-item.
         assign tt-parte-item.modelo  = tt-parte.modelo
                tt-parte-item.parte   = tt-parte.parte
                tt-parte-item.item    = tt-parte.item
                tt-parte-item.posicao = caps(c-letra)
                c-pos                 = caps(trim(c-ini)). 
         if trim(c-pos) = "0" then
            assign c-pos = "".
         assign tt-parte-item.posicao = tt-parte-item.posicao + c-pos.
      end.   
      else do:
         do i = asc(caps(c-ini)) to asc(caps(c-fim)):
            create tt-parte-item.
            assign tt-parte-item.modelo  = tt-parte.modelo
                   tt-parte-item.parte   = tt-parte.parte
                   tt-parte-item.item    = tt-parte.item
                   tt-parte-item.posicao = caps(c-letra)
                   c-pos                 = chr(i). 
            if trim(c-pos) = "0" then 
               assign c-pos = "".
            assign tt-parte-item.posicao = tt-parte-item.posicao + c-pos.
         end.
      end.          
   end.
end.

procedure pi-testa-local-mont:
   def input  param c-segmento as char    no-undo.
   def output param l-erro     as logical no-undo.
  
   def var i-cont  as integer no-undo.
   def var i-asc   as integer no-undo.
   def var i-cont2 as integer no-undo.
   
   def var c-carac      as char no-undo.
   def var c-str        as char no-undo.
   def var c-str2       as char no-undo.
   def var c-str-antes  as char no-undo.
   def var c-str-depois as char no-undo.
   def var c-str-x      as char no-undo.
   
   def var l-parentesis  as logical no-undo.
   def var l-alfa-antes  as logical no-undo.
   def var l-alfa-depois as logical no-undo.
   
   assign l-erro = no.
   do i-cont = 1 to length(trim(c-segmento)):
      assign i-asc = asc(caps(substring(trim(c-segmento),i-cont,1))).
      if i-asc < 48
      or (i-asc < 65 and i-asc > 57)
      or (i-asc > 90) then do:
         if  i-asc <> 45 and i-asc <> 44 and i-asc <> 40 
         and i-asc <> 41 and i-asc <> 59 then do: 
            l-erro = yes.
            leave.
         end.
      end.
   end.
   assign c-str = "()-,;"
          c-str2 = "()-,".
   if l-erro = no then do:
      do i-cont = 1 to length(trim(c-segmento)):
         assign c-carac = caps(substring(c-segmento,i-cont,1))
                c-str-antes = ""
                c-str-depois = ""
                c-str-x = "".
          
         /**** se fecha parenteses sem ter aberto ***/
         if c-carac = ")" and l-parentesis = no then do:
            assign l-erro = yes.
            leave.
         end.

         /**** se abre parenteses com outro ja aberto ***/
         if c-carac = "(" and l-parentesis = yes then do:
            assign l-erro = yes.
            leave.
         end.

         /**** se o primeiro caractere eh um caractere de controle ***/
         if index(c-str, c-carac) > 0 and i-cont = 1 then do:
            assign l-erro = yes.
            leave.
         end.
         
         /**** se fecha parentesis logo apos um caractere de controle ***/
         if c-carac = ")" and l-parentesis = yes then do:
            if index(c-str, substring(c-segmento,(i-cont - 1), 1)) > 0 then do:
               assign l-erro = yes.
               leave.
            end.
         end.
         
         /**** se parentesis esta aberto e no final nao eh fechado ***/
         if  l-parentesis = yes 
         and i-cont = length(trim(c-segmento))
         and c-carac <> ")" then do:
             assign l-erro = yes.
             leave.
         end.
         
         /**** se abre parentesis e logo em seguida eh carac de controle ***/
         if  c-carac = "(" 
         and index(c-str, substring(c-segmento,i-cont + 1,1)) > 0 
         and i-cont < length(trim(c-segmento)) then do:
             assign l-erro = yes.
             leave.
         end.
         
         /**** se o ultimo caractere eh um dos caracteres de controle ***/
         if  (c-carac = "," or c-carac = ";" or c-carac = "-")
         and i-cont = length(trim(c-segmento)) then do:
              assign l-erro = yes.
              leave.
         end.
            
         /**** se caractere de controle segue outro caractere de controle ***/
         if  index(c-str2, c-carac) > 0 
         and index(c-str,substring(trim(c-segmento),(i-cont - 1),1)) > 0 
         then do:
             assign l-erro = yes.
             leave.
         end.
         
         /**** se "," e "-" sao utilizados sem parenteses aberto ***/
         if (c-carac = "," or c-carac = "-") and l-parentesis = no then do:
            assign l-erro = yes.
            leave.
         end.

         /**** se "-" eh utilizado e carac a fente e atraz nao sao alfanum ***/
         if  c-carac = "-" then do:
             assign l-alfa-antes = no
                    l-alfa-depois = no.
             do i-cont2 = i-cont + 1 to length(trim(c-segmento)):
                if substring(c-segmento, i-cont2, 1) <> ")" 
                and substring(c-segmento, i-cont2, 1) <> "," then do:
                    if  asc(caps(substring(c-segmento, i-cont2, 1))) >= 65 
                    and asc(caps(substring(c-segmento, i-cont2, 1))) <= 90 
                    then do:
                        assign l-alfa-depois = yes.
                    end.
                    assign c-str-depois = c-str-depois 
                                        + substring(c-segmento, i-cont2, 1).
                end.                        
                else do:
                    leave.
                end.
             end.
             if l-erro = no then do:
                do i-cont2 = i-cont - 1 to 1 by -1:                         
                   if  substring(c-segmento, i-cont2, 1) <> "(" 
                   and substring(c-segmento, i-cont2, 1) <> "," then do:
                      if  asc(caps(substring(c-segmento, i-cont2, 1))) >= 65 
                      and asc(caps(substring(c-segmento, i-cont2, 1))) <= 90 
                      then do:
                          assign l-alfa-antes = yes.
                      end.
                      assign c-str-antes = substring(c-segmento, i-cont2, 1)
                                         + c-str-x
                             c-str-x     = c-str-antes.
                   end.
                   else do:
                      leave.
                   end.
                end.
             end.
             if l-alfa-antes <> l-alfa-depois then do:
                assign l-erro = yes.
                leave.
             end.
             if (l-alfa-antes = yes and length(c-str-antes) > 1)
             or (l-alfa-depois = yes and length(c-str-depois) > 1) then do:
                assign l-erro = yes.
                leave.
             end.
             if l-alfa-antes = no and l-alfa-depois = no then do:
                if int(c-str-antes) > int(c-str-depois) then do:
                   assign l-erro = yes.
                   leave.
                end.
             end.   
         end.
          
         if c-carac = "(" then
            assign l-parentesis = yes.
         if c-carac = ")" and l-parentesis = yes then
            assign l-parentesis = no.
      end.   
   end.
end.

/** FIM DO PROGRAMA **/

