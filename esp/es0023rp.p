{include/i-prgvrs.i ES0023 2.04.00.000}
{esp/es0023.i}

 DEF input parameter raw-param as raw no-undo.
 def input parameter table for tt-raw-digita.

{utp/ut-glob.i}  
{include/i-rpvar.i}

/*****************************************************************************
**
**   Programa:  es0906.p
**
**   Funcao:  projetar estoques
**
**   Data:  29/10/2003
**
**   Autor:  Flavio Schoenell   - INTELBRAS S/A.
**
********* o programa es0906 tem uma versao grafica (es0906.w) acessada pelo menu grafico 
******************************************************************************/

/********** DEFINICAO DE VARIAVEIS   ****************************************/

def var de-val-unit as DEC NO-UNDO.
def var de-val-mat  as DEC NO-UNDO.
def var de-val-mob  as DEC NO-UNDO.
def var de-val-ggf  as DEC NO-UNDO.
DEF VAR c-arquivo AS CHAR NO-UNDO.

def var dx as DATE NO-UNDO.
def var dx1 as DATE NO-UNDO.
DEF VAR h-acomp      as handle no-undo.

def var i-num-calc-plano like it-periodo.num-calc-plano NO-UNDO.
def var i-cd-plano like pl-prod.cd-plano initial 1 NO-UNDO.

def var i-nr-dias as int initial 180 NO-UNDO.
def var de-saldo as dec format "->>>,>>>,>>9" NO-UNDO.
def var de-maximo as dec format "->>>,>>>,>>9" extent 120 NO-UNDO.
def var i-max-ini as INT NO-UNDO.
def var i-max-fim as INT NO-UNDO.
def var i-max as INT NO-UNDO.
def var i-dia as DATE NO-UNDO.
def var i-cont as INT NO-UNDO.
def var l-tipo as log format "Planejamento/Tudo" initial YES NO-UNDO.

/********** DEFINICAO DE STREAMS     ****************************************/
/********** DEFINICAO DE TEMP-TABLES ****************************************/


def temp-table tt-periodo
    field it-codigo like item.it-codigo
    field data      like it-periodo.data
    field qt-res-plan like it-periodo.qt-res-plan
    field qt-ord-plan like it-periodo.qt-ord-plan
    index codigo is primary it-codigo data.


def new shared temp-table tt-item
    field it-codigo like mgind.item.it-codigo
    field cod-comprado like item.cod-comprado
    field cod-emitente like emitente.cod-emitente
    field descricao as char format "x(36)"
    field quant-segur as dec format ">>,>>>,>>9"
    field quantidade as dec format "->>,>>>,>>9" extent 120
    field campo as dec format "->>,>>>,>>9" extent 120
    field val-unit   like  item-estab.val-unit-mat-m[1]
    field periodo-fixo like mgind.item.periodo-fixo
    field res-for-comp like item.res-for-comp
    field maximo      as dec format ">>,>>>,>>9" extent 120
    field valor      like movto-estoq.valor-mat-m[1] extent 120
    FIELD demanda    LIKE ITEM.demanda
    index codigo is primary demanda cod-comprado cod-emitente it-codigo.

def new shared temp-table tt-geral
    field descricao as char format "x(36)"
    field quant-segur as dec format ">>,>>>,>>9"
    field quantidade as dec format "->>,>>>,>>9" extent 120
    field maximo      as dec format ">>,>>>,>>9" extent 120.
   
def new shared temp-table tt-comprador
    field cod-comprado like item.cod-comprado
    field descricao as char format "x(36)"
    field quant-segur as dec format ">>,>>>,>>9"
    field quantidade as dec format "->>,>>>,>>9" extent 120
    field maximo      as dec format ">>,>>>,>>9" extent 120
    index codigo is primary cod-comprado.
    
def new shared temp-table tt-fornec
    field cod-comprado like item.cod-comprado
    field cod-emitente like emitente.cod-emitente
    field descricao as char format "x(36)"
    field quant-segur as dec format ">>,>>>,>>9"
    field quantidade as dec format "->>,>>>,>>9" extent 120
    field maximo      as dec format ">>,>>>,>>9" extent 120
    index codigo is primary cod-comprado cod-emitente.

/********** DEFINICAO DE BUFFERS     ****************************************/
/********** DEFINICAO DE QUERYS      ****************************************/
/********** DEFINICAO DE BROWSES     ****************************************/
/********** DEFINICAO DE FORMS       ****************************************/
/********** ON ENTRY                 ****************************************/
/********** ON LEAVE                 ****************************************/
/********** ON RETURN                ****************************************/
/********** ON ANY-KEY               ****************************************/
/********** ON VALUE-CHANGED         ****************************************/
/********** ON ROW-ENTRY             ****************************************/
/********** ON GO (F1)               ****************************************/
/********** ON HELP (F2)             ****************************************/
/********** ON END-ERROR (F4)        ****************************************/
/********** ON GET (F5)              ****************************************/
/********** ON PUT (F6)              ****************************************/
/********** ON RECALL (F7)           ****************************************/
/********** ON CLEAR (F8)            ****************************************/

/********** CORPO DO PROGRAMA        ***************************************/  
    
FOR FIRST param-global NO-LOCK. END.
FOR FIRST mgcad.empresa NO-LOCK WHERE
          empresa.ep-codigo = param-global.empresa-pri: END.
FIND FIRST tt-param NO-ERROR.

ASSIGN c-sistema      = "Espec¡ficos Intelbras"
       c-titulo-relat = "Erros das Notas Fiscais"
       c-empresa      = if avail empresa then mgcad.empresa.razao-social else ''
       c-programa     = "ESREP005"
       c-versao       = "2.04"
       c-revisao      = "001".


find pl-prod no-lock where pl-prod.cd-plano = i-cd-plano no-error.
if avail pl-prod then assign i-num-calc-plano = pl-prod.num-calc-plano.
else assign i-num-calc-plano = 0.

assign l-tipo = yes.

for each tt-item:
    delete tt-item.
end.
for each tt-geral:
    delete tt-geral.
end.
for each tt-fornec: 
    delete tt-fornec.
end.
for each tt-comprador:
    delete tt-comprador.
end.

for each tt-periodo:
    delete tt-periodo.
end.

create tt-geral.
assign tt-geral.descricao = "Total Geral".

create tt-param.
raw-transfer raw-param to tt-param.

find first tt-param no-error.

{include/i-rpcab.i}
{include/i-rpout.i &pagesize="80"}

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
RUN pi-inicializar in h-acomp (input "Lendo Item...").

for each it-periodo 
    fields(data
           it-codigo
           qt-res-plan
           qt-ord-plan)
    no-lock use-index data
       where /* it-periodo.data > today
         and*/  it-periodo.cod-estabel = tt-param.cod-estabel
         and it-periodo.num-calc-plan = i-num-calc-plano:
         if it-periodo.qt-res-plan > 0 or
            it-periodo.qt-ord-plan > 0 then do:
             create tt-periodo.
             assign tt-periodo.it-codigo = it-periodo.it-codigo
                    tt-periodo.data      = it-periodo.data
                    tt-periodo.qt-res-plan = it-periodo.qt-res-plan
                    tt-periodo.qt-ord-plan = it-periodo.qt-ord-plan.
         end.
end.



for each item no-lock
   where item.cod-obsoleto = 1
     and item.ge-codigo < if l-tipo then 20 else 40,
    each item-fornec
  FIELDS (ativo
          cod-emitente
          it-codigo) NO-LOCK of item
   where item-fornec.ativo
     and item-fornec.perc-compra = 100:
             
             
    RUN pi-acompanhar in h-acomp (input "Item: " + ITEM.it-codigo).

         assign de-val-unit = 0
              de-val-mat  = 0
              de-val-mob  = 0
              de-val-ggf  = 0.
       
       find item-estab no-lock
           where item-estab.cod-estabel = tt-param.cod-estabel 
             and item-estab.it-codigo = item.it-codigo no-error.
       if avail item-estab then 
          assign de-val-unit = item-estab.val-unit-mat-m[1]
                             + item-estab.val-unit-mob-m[1]
                             + item-estab.val-unit-ggf-m[1]
                 de-val-mat = item-estab.val-unit-mat-m[1]
                 de-val-mob = item-estab.val-unit-mob-m[1]
                 de-val-ggf = item-estab.val-unit-ggf-m[1]  .
       else assign de-val-unit = 0.

        find tt-item 
             where tt-item.cod-comprado = item.cod-comprado
               and tt-item.cod-emitente = item-fornec.cod-emitente
               and tt-item.it-codigo = item.it-codigo no-error.
        if not avail tt-item then do:
            create tt-item.
            assign tt-item.it-codigo    = item.it-codigo
                   tt-item.cod-comprado = item.cod-comprado
                   tt-item.cod-emitente = item-fornec.cod-emitente
                   tt-item.val-unit     = de-val-unit
                   tt-item.quant-segur  = item.quant-segur
                   tt-item.periodo-fixo = item.periodo-fixo
                   tt-item.res-for-comp = item.res-for-comp
                   tt-item.descricao    = item.desc-item
                   tt-item.demanda      = ITEM.demanda.
        end.
        find tt-comprador where tt-comprador.cod-comprado = 
        item.cod-comprado no-error.
        if not avail tt-comprador then do:
            create tt-comprador.
            assign tt-comprador.cod-comprado = item.cod-comprado
                   tt-comprador.descricao    = item.cod-comprado.
        end.
        find tt-fornec
             where tt-fornec.cod-comprado = item.cod-comprado 
               and tt-fornec.cod-emitente = item-fornec.cod-emitente       ~                 no-error.
        if not avail tt-fornec then do:
            find emitente no-lock                                       
                where emitente.cod-emitente = item-fornec.cod-emitente.
            create tt-fornec.
            assign tt-fornec.cod-comprado = item.cod-comprado
                   tt-fornec.cod-emitente = item-fornec.cod-emitente
                   tt-fornec.descricao    = emitente.nome-abrev.
        end.
end.
        
for each tt-item
   WHERE tt-item.demanda = 1
   break by tt-item.cod-comprado
         by tt-item.cod-emitente
         by tt-item.it-codigo:
        
            assign de-saldo = 0
                   de-maximo = 0.
         /*
            put screen tt-item.it-codigo row 10.
           */

           RUN pi-acompanhar in h-acomp (input "Saldo Item: " + tt-item.it-codigo).

            if l-tipo then do:
            
                for each saldo-estoq no-lock use-index estabel-item
                   where saldo-estoq.cod-estabel = tt-param.cod-estabel
                     and saldo-estoq.it-codigo = tt-item.it-codigo
                     and saldo-estoq.qtidade-atu > 0,
                   first deposito no-lock
                   where deposito.cod-depos = saldo-estoq.cod-depos
                     and deposito.cons-saldo:
                        assign de-saldo = de-saldo + saldo-estoq.qtidade-atu.
                end.
            end.
            else do:
                for each saldo-estoq no-lock use-index estabel-item
                   where saldo-estoq.cod-estabel = tt-param.cod-estabel
                     and saldo-estoq.it-codigo = tt-item.it-codigo
                     and saldo-estoq.qtidade-atu > 0:
                        assign de-saldo = de-saldo + saldo-estoq.qtidade-atu.
                end.
            end.
    /*        
            message "Saldo Estoque" de-saldo view-as alert-box.
      */       

            
            for each saldo-terc no-lock
               where saldo-terc.it-codigo = tt-item.it-codigo
                 and saldo-terc.cod-estabel = tt-param.cod-estabel
                 and saldo-terc.tipo-sal-terc = 1,
                   first deposito no-lock
                   where deposito.cod-depos = saldo-terc.cod-depos
                     and deposito.cons-saldo:
                assign de-saldo = de-saldo + saldo-terc.quantidade. 
                
            end.
/*            
            message "Saldo Terc" de-saldo view-as alert-box.
  */           

         
            for each prazo-compra 
                fields( it-codigo
                        situacao
                        data-entrega
                        quant-saldo) use-index entrega-pl
                no-lock
               where prazo-compra.it-codigo = tt-item.it-codigo
                     and prazo-compra.situacao <= 3
                 and prazo-compra.data-entrega <= today
                 and prazo-compra.quant-saldo > 0,
                 each ordem-compra no-lock
                where ordem-compra.numero-ordem = prazo-compra.numero-ordem
                and ordem-compra.natureza = 1:
                 assign de-saldo = de-saldo + prazo-compra.quant-saldo.
            end.

           /*   
           message "compras:" de-saldo view-as alert-box.
            */    
            
            for each reservas 
                fields( it-codigo
                        estado
                        dt-reserva
                        quant-orig
                        quant-atend
                        nr-ord-prod) use-index planejamento
                no-lock
               where reservas.it-codigo = tt-item.it-codigo
                 and reservas.estado = 1
                 and reservas.dt-reserva <= today:
               assign de-saldo = de-saldo - (reservas.quant-orig - 
               reservas.quant-atend).  
         /*  m ximo passou a ser int-item.qtd-pol em 13/12/2006
         
               assign de-maximo[1] = de-maximo[1] + (reservas.quant-orig - 
               reservas.quant-atend).
               */
               /*
               message reservas.nr-ord-prod quant-orig - quant-atend 
               view-as alert-box.
                 */
            end.
            /*
            message "reservas: " de-saldo view-as alert-box.
              */
            
            for each ord-prod use-index est-it-estado
                no-lock
               where ord-prod.estado <> 7
                 and ord-prod.estado <> 8
                 and ord-prod.dt-inicio <= today
                 and ord-prod.it-codigo = tt-item.it-codigo
                 and ord-prod.cod-estabel = tt-param.cod-estabel:
                assign de-saldo = de-saldo + ord-prod.qt-ordem - 
                ord-prod.qt-produzida.
                /*
                message "OP" ord-prod.nr-ord-prod ord-prod.qt-ordem ord-prod.qt-produzida de-saldo view-as alert-box.
                  */
                
            end.
         
            
            find tt-comprador 
                 where tt-comprador.cod-comprado = tt-item.cod-comprado.
            
            find tt-fornec where tt-fornec.cod-comprado = tt-item.cod-comprado
                    and tt-fornec.cod-emitente = tt-item.cod-emitente.

            assign  tt-item.quantidade[1] = de-saldo
                    tt-item.valor[1]      = tt-item.quantidade[1] * 
                                            tt-item.val-unit
                    
                    tt-geral.quantidade[1] = tt-geral.quantidade[1] + 
                                             tt-item.valor[1]
                    
                    tt-comprador.quantidade[1] = tt-comprador.quantidade[1] + 
                                                 tt-item.valor[1]
                    tt-fornec.quantidade[1]    = tt-fornec.quantidade[1] +     ~                                             tt-item.valor[1]
                
                    tt-geral.quant-segur = tt-geral.quant-segur + 
                    (tt-item.quant-segur * tt-item.val-unit)
                    tt-comprador.quant-segur = tt-comprador.quant-segur + 
                    (tt-item.quant-segur * tt-item.val-unit)
                    tt-fornec.quant-segur = tt-fornec.quant-segur + 
                                           (tt-item.quant-segur *              ~                               tt-item.val-unit).

           
           
            assign i-cont = 2. 
            
            assign dx = today + 1
                   dx1 = today + (i-nr-dias - 1).
            do i-dia = dx to dx1:
             /*
                put screen string(i-dia) row 12.
               */ 
                
                assign i-max-fim = i-cont
                       i-max-ini = i-cont - tt-item.periodo-fixo.
                if i-max-ini < 2 then 
                    assign i-max-ini = 1.
                /*
                put screen "prazo-compra" row 15.
                  */
                for each prazo-compra use-index entrega-pl
                    no-lock 
                   where prazo-compra.it-codigo = tt-item.it-codigo
                      and prazo-compra.situacao <= 3
                     and prazo-compra.data-entrega = i-dia
                     and prazo-compra.quant-saldo > 0,
                   each ordem-compra no-lock
                   where ordem-compra.numero-ordem = prazo-compra.numero-ordem
                     and ordem-compra.natureza = 1:
                     assign de-saldo = de-saldo + prazo-compra.quant-saldo.
                     /*
                     message "compra no dia " prazo-compra.quant-saldo view-as alert-box.
                       */
                end.
             
                /*
                put screen "reservas          " row 15.
                  */
                for each reservas use-index planejamento
                    no-lock  
                   where reservas.it-codigo = tt-item.it-codigo
                     and reservas.estado = 1
                     and reservas.dt-reserva = i-dia:
                     assign de-saldo = de-saldo - (reservas.quant-orig -       ~                                                   quant-atend).  

                     /*  m ximo passou a ser int-item.qtd-pol em 13/12/2006
                     
                     do i-max = i-max-ini to i-max-fim:
                         if i-max > 120 then next.
                         assign de-maximo[i-max] = de-maximo[i-max] + 
                                                  (reservas.quant-orig -       ~                                                   quant-atend).
                     end.
                     
                     */
                     
                   /*
                     message "Reservas no dia " reservas.nr-ord-prod 
                             (reservas.quant-orig -                                                        quant-atend)                     
                     de-saldo view-as alert-box.
                     */
                end.
               /* 
                put screen "ord-prod          " row 15.
                 */
                for each ord-prod 
                /*use-index est-it-estado */
                    no-lock
                   where ord-prod.estado <> 7
                     and ord-prod.estado <> 8
                     
                     and ord-prod.dt-inicio = i-dia
                     and ord-prod.it-codigo = tt-item.it-codigo:
                    assign de-saldo = de-saldo + ord-prod.qt-ordem - 
                    ord-prod.qt-produzida.
                end.
            
                /*
                put screen "it-periodo         " row 15.
                  */
                for each it-periodo
                    fields(data
                     it-codigo
                     qt-res-plan
                     qt-ord-plan)
                   no-lock use-index data
                   where it-periodo.data = i-dia
                     and it-periodo.it-codigo = tt-item.it-codigo
                     and it-periodo.cod-estabel = tt-param.cod-estabel
                     and it-periodo.num-calc-plan = i-num-calc-plano:
                   assign de-saldo = de-saldo - it-periodo.qt-res-plan +
                                                it-periodo.qt-ord-plan .
                     /*  m ximo passou a ser int-item.qtd-pol em 13/12/2006
                     do i-max = i-max-ini to i-max-fim:
                         if i-max > 120 then next.
                         assign de-maximo[i-max] = de-maximo[i-max] + 
                                                   it-periodo.qt-res-plan
                                                 - it-periodo.qt-ord-plan.
                     end.
                     */
                  
                     /*
                    message "it-periodo no dia " de-saldo view-as alert-box.
                    */
                end.
                 
                if i-cont <= 120 then do:
                    assign  tt-item.quantidade[i-cont] = de-saldo
                        tt-item.valor[i-cont]      = tt-item.quantidade[i-cont]
                         * tt-item.val-unit
                        
                        tt-geral.quantidade[i-cont] = 
                        tt-geral.quantidade[i-cont] + tt-item.valor[i-cont]
                        tt-comprador.quantidade[i-cont] = 
                        tt-comprador.quantidade[i-cont] + tt-item.valor[i-cont]
                        tt-fornec.quantidade[i-cont] = 
                        tt-fornec.quantidade[i-cont] + tt-item.valor[i-cont].
                        
                end.
                assign i-cont = i-cont + 1.                             
            

                /*
                message "saldo na data" i-dia de-saldo view-as alert-box.
                  */
            
            end.
            
            FIND FIRST int-item-uni-estab NO-LOCK
                 WHERE int-item-uni-estab.it-codigo   = tt-item.it-codigo
                   AND int-item-uni-estab.cod-estabel = tt-param.cod-estabel   NO-ERROR.
            IF AVAIL int-item-uni-estab THEN
                ASSIGN de-maximo = int-item-uni-estab.qtd-pol.

            
            do i-max = 1 to 120:
                assign tt-item.maximo[i-max] = /* tt-item.quant-segur + */ 
                de-maximo[i-max].
                if tt-item.maximo[i-max] < 0 then
                    assign tt-item.maximo[i-max] = 0.
            
                assign tt-geral.maximo[i-max] = tt-geral.maximo[i-max] + 
                (( /* tt-item.quant-segur + */ de-maximo[i-max]) * tt-item.val-unit)
                       tt-comprador.maximo[i-max] = 
                       tt-comprador.maximo[i-max] + (( /* tt-item.quant-segur +
                        */ de-maximo[i-max]) * tt-item.val-unit)
                       tt-fornec.maximo[i-max] = tt-fornec.maximo[i-max] + 
                       ((/* tt-item.quant-segur + */ de-maximo[i-max]) * tt-item.val-unit).


            end.

            
            

end.


/*************************************************/


for each item no-lock
   where item.cod-obsoleto = 1
     AND ITEM.demanda = 2
     and item.ge-codigo < 40,
    each item-fornec
  FIELDS (ativo
          cod-emitente
          it-codigo) NO-LOCK of item
   where item-fornec.ativo
     and item-fornec.perc-compra = 100:
             
             
           RUN pi-acompanhar in h-acomp (input "Item: " + item.it-codigo).

             assign de-val-unit = 0
                  de-val-mat  = 0
                  de-val-mob  = 0
                  de-val-ggf  = 0.
           
           find item-estab no-lock
               where item-estab.cod-estabel = tt-param.cod-estabel 
                 and item-estab.it-codigo = item.it-codigo no-error.

           if avail item-estab then 
              assign de-val-unit = item-estab.val-unit-mat-m[1]
                                 + item-estab.val-unit-mob-m[1]
                                 + item-estab.val-unit-ggf-m[1]
                     de-val-mat = item-estab.val-unit-mat-m[1]
                     de-val-mob = item-estab.val-unit-mob-m[1]
                     de-val-ggf = item-estab.val-unit-ggf-m[1]  .
           else assign de-val-unit = 0.             
            
                
                
            find tt-item 
                 where tt-item.cod-comprado = item.cod-comprado
                   and tt-item.cod-emitente = item-fornec.cod-emitente
                   and tt-item.it-codigo = item.it-codigo no-error.
            if not avail tt-item then do:
                create tt-item.
                assign tt-item.it-codigo    = item.it-codigo
                       tt-item.cod-comprado = item.cod-comprado
                       tt-item.cod-emitente = item-fornec.cod-emitente
                       tt-item.val-unit     = de-val-unit
                       tt-item.quant-segur  = item.quant-segur
                       tt-item.periodo-fixo = item.periodo-fixo
                       tt-item.res-for-comp = item.res-for-comp
                       tt-item.descricao    = item.desc-item
                       tt-item.demanda      = item.demanda.
            end.
            find tt-comprador where tt-comprador.cod-comprado = 
            item.cod-comprado no-error.
            if not avail tt-comprador then do:
                create tt-comprador.
                assign tt-comprador.cod-comprado = item.cod-comprado
                       tt-comprador.descricao    = item.cod-comprado.
            end.
            find tt-fornec
                 where tt-fornec.cod-comprado = item.cod-comprado 
                   and tt-fornec.cod-emitente = item-fornec.cod-emitente       ~                 no-error.
            if not avail tt-fornec then do:
                find emitente no-lock                                       
                    where emitente.cod-emitente = item-fornec.cod-emitente.
                create tt-fornec.
                assign tt-fornec.cod-comprado = item.cod-comprado
                       tt-fornec.cod-emitente = item-fornec.cod-emitente
                       tt-fornec.descricao    = emitente.nome-abrev.
            end.
end.
        

        
for each tt-item
   WHERE tt-item.demanda = 2
           break by tt-item.cod-comprado
                 by tt-item.cod-emitente
                 by tt-item.it-codigo:
        
            assign de-saldo = 0
                   de-maximo = 0.
         /*
            put screen tt-item.it-codigo row 10.
           */

           RUN pi-acompanhar in h-acomp (input "Saldo Item: " + tt-item.it-codigo).

            if l-tipo then do:
            
                for each saldo-estoq no-lock use-index estabel-item
                   where saldo-estoq.cod-estabel = tt-param.cod-estabel
                     and saldo-estoq.it-codigo = tt-item.it-codigo
                     and saldo-estoq.qtidade-atu > 0,
                   first deposito no-lock
                   where deposito.cod-depos = saldo-estoq.cod-depos
                     and deposito.cons-saldo:
                        assign de-saldo = de-saldo + saldo-estoq.qtidade-atu.
                end.
            end.
            else do:
                for each saldo-estoq no-lock use-index estabel-item
                   where saldo-estoq.cod-estabel = tt-param.cod-estabel
                     and saldo-estoq.it-codigo = tt-item.it-codigo
                     and saldo-estoq.qtidade-atu > 0:
                        assign de-saldo = de-saldo + saldo-estoq.qtidade-atu.
                end.
            end.
    /*        
            message "Saldo Estoque" de-saldo view-as alert-box.
      */       

            
            for each saldo-terc no-lock
               where saldo-terc.it-codigo = tt-item.it-codigo
                 and saldo-terc.cod-estabel = tt-param.cod-estabel
                 and saldo-terc.tipo-sal-terc = 1,
                   first deposito no-lock
                   where deposito.cod-depos = saldo-terc.cod-depos
                     and deposito.cons-saldo:
                assign de-saldo = de-saldo + saldo-terc.quantidade. 
                
            end.
/*            
            message "Saldo Terc" de-saldo view-as alert-box.
  */           

         
            for each prazo-compra 
                fields( it-codigo
                        situacao
                        data-entrega
                        quant-saldo) use-index entrega-pl
                no-lock
               where prazo-compra.it-codigo = tt-item.it-codigo
                     and prazo-compra.situacao <= 3
                 and prazo-compra.data-entrega <= today
                 and prazo-compra.quant-saldo > 0,
                 each ordem-compra no-lock
                where ordem-compra.numero-ordem = prazo-compra.numero-ordem
                and ordem-compra.natureza = 1:
                 assign de-saldo = de-saldo + prazo-compra.quant-saldo.
            end.

           /*   
           message "compras:" de-saldo view-as alert-box.
            */    
            
         
            
            find tt-comprador 
                 where tt-comprador.cod-comprado = tt-item.cod-comprado.
            
            
            find tt-fornec where tt-fornec.cod-comprado = tt-item.cod-comprado
                    and tt-fornec.cod-emitente = tt-item.cod-emitente.

            assign  tt-item.quantidade[1] = de-saldo
                    tt-item.valor[1]      = tt-item.quantidade[1] * 
                                            tt-item.val-unit
                    
                    tt-geral.quantidade[1] = tt-geral.quantidade[1] + 
                                             tt-item.valor[1]
                    
                    tt-comprador.quantidade[1] = tt-comprador.quantidade[1] + 
                                                 tt-item.valor[1]
                    tt-fornec.quantidade[1]    = tt-fornec.quantidade[1] +     ~                                             tt-item.valor[1]
                
                    tt-geral.quant-segur = tt-geral.quant-segur + 
                    (tt-item.quant-segur * tt-item.val-unit)
                    tt-comprador.quant-segur = tt-comprador.quant-segur + 
                    (tt-item.quant-segur * tt-item.val-unit)
                    tt-fornec.quant-segur = tt-fornec.quant-segur + 
                                           (tt-item.quant-segur *              ~                               tt-item.val-unit).

           
           
            assign i-cont = 2. 
            
            assign dx = today + 1
                   dx1 = today + (i-nr-dias - 1).
            do i-dia = dx to dx1:
             /*
                put screen string(i-dia) row 12.
               */ 
                
                assign i-max-fim = i-cont
                       i-max-ini = i-cont - tt-item.periodo-fixo.
                if i-max-ini < 2 then 
                    assign i-max-ini = 1.
                /*
                put screen "prazo-compra" row 15.
                  */
                for each prazo-compra use-index entrega-pl
                    no-lock 
                   where prazo-compra.it-codigo = tt-item.it-codigo
                      and prazo-compra.situacao <= 3
                     and prazo-compra.data-entrega = i-dia
                     and prazo-compra.quant-saldo > 0,
                   each ordem-compra no-lock
                   where ordem-compra.numero-ordem = prazo-compra.numero-ordem
                     and ordem-compra.natureza = 1:
                     assign de-saldo = de-saldo + prazo-compra.quant-saldo.
                     /*
                     message "compra no dia " prazo-compra.quant-saldo view-as alert-box.
                       */
                end.
             
                 
                if i-cont <= 120 then do:
                    assign  tt-item.quantidade[i-cont] = de-saldo
                        tt-item.valor[i-cont]      = tt-item.quantidade[i-cont]
                         * tt-item.val-unit
                        
                        tt-geral.quantidade[i-cont] = 
                        tt-geral.quantidade[i-cont] + tt-item.valor[i-cont]
                        tt-comprador.quantidade[i-cont] = 
                        tt-comprador.quantidade[i-cont] + tt-item.valor[i-cont]
                        tt-fornec.quantidade[i-cont] = 
                        tt-fornec.quantidade[i-cont] + tt-item.valor[i-cont].
                        
                end.
                assign i-cont = i-cont + 1.                             
            

                /*
                message "saldo na data" i-dia de-saldo view-as alert-box.
                  */
            
            end.
            
            FIND ITEM WHERE 
                 ITEM.it-codigo = tt-item.it-codigo NO-LOCK NO-ERROR.
            IF AVAIL ITEM THEN 
                ASSIGN de-maximo = ITEM.consumo-prev.

            FIND ITEM-uni-estab NO-LOCK
                WHERE ITEM-uni-estab.it-codigo = tt-item.it-codigo
                  AND ITEM-uni-estab.cod-estabel = tt-param.cod-estabel NO-ERROR.
            IF AVAIL item-uni-estab THEN
                ASSIGN de-maximo = ITEM-uni-estab.consumo-prev.
            
            do i-max = 1 to 120:
                assign tt-item.maximo[i-max] = /* tt-item.quant-segur + */ 
                de-maximo[i-max].
                if tt-item.maximo[i-max] < 0 then
                    assign tt-item.maximo[i-max] = 0.
            
                assign tt-geral.maximo[i-max] = tt-geral.maximo[i-max] + 
                (( /* tt-item.quant-segur + */ de-maximo[i-max]) * tt-item.val-unit)
                       tt-comprador.maximo[i-max] = 
                       tt-comprador.maximo[i-max] + (( /* tt-item.quant-segur +
                        */ de-maximo[i-max]) * tt-item.val-unit)
                       tt-fornec.maximo[i-max] = tt-fornec.maximo[i-max] + 
                       ((/* tt-item.quant-segur + */ de-maximo[i-max]) * tt-item.val-unit).
            end.
end.

/*************************************************/

IF OPSYS = "UNIX" THEN 
    if l-tipo then         
          ASSIGN c-arquivo =  "/usr8/spool/projecao/tt-geral.txt".
     else    
        ASSIGN c-arquivo =  "/usr8/spool/projecao/tt-geral-t.txt".
ELSE
    if l-tipo then         
          ASSIGN c-arquivo =  "\\intel200\spool\projecao\tt-geral.txt".
    else    
        ASSIGN c-arquivo =  "\\intel200\spool\projecao\tt-geral-t.txt".


OUTPUT TO VALUE(c-arquivo).
for each tt-geral:
    export tt-geral.
end.
output close.


IF OPSYS = "UNIX" THEN 
    if l-tipo then 
        ASSIGN c-arquivo =  "/usr8/spool/projecao/tt-comprador.txt".
    else
        ASSIGN c-arquivo =  "/usr8/spool/projecao/tt-comprador-t.txt".
ELSE
    if l-tipo then 
        ASSIGN c-arquivo =  "\\intel200\spool\projecao\tt-comprador.txt".
    else
        ASSIGN c-arquivo =  "\\intel200\spool\projecao\tt-comprador-t.txt".


OUTPUT TO VALUE(c-arquivo).
for each tt-comprador:
    export tt-comprador.
end.
output close.



IF OPSYS = "UNIX" THEN 
    if l-tipo then
        ASSIGN c-arquivo = "/usr8/spool/projecao/tt-fornec.txt".
    else
        ASSIGN c-arquivo = "/usr8/spool/projecao/tt-fornec-t.txt".
ELSE
    if l-tipo then
        ASSIGN c-arquivo = "\\intel200\spool\projecao\tt-fornec.txt".
    else
        ASSIGN c-arquivo = "\\intel200\spool\projecao\tt-fornec-t.txt".

OUTPUT TO VALUE(C-ARQUIVO).
for each tt-fornec:
    export tt-fornec.
end.
output close.


IF OPSYS = "UNIX" THEN 
    if l-tipo then 
        ASSIGN c-arquivo = "/usr8/spool/projecao/tt-item.txt".
    else
        ASSIGN c-arquivo = "/usr8/spool/projecao/tt-item-t.txt".
ELSE
    if l-tipo then 
        ASSIGN c-arquivo = "\\intel200\spool\projecao\tt-item.txt".
    else
        ASSIGN c-arquivo = "\\intel200\spool\projecao\tt-item-t.txt".

OUTPUT TO VALUE(c-arquivo).
for each tt-item:
    export tt-item.
end.
output close.

def var i as date.


IF OPSYS = "UNIX" THEN 
    ASSIGN c-arquivo = "/usr8/spool/projecao/tt-label.txt".
else
    ASSIGN c-arquivo = "\\intel200\spool\projecao\tt-label.txt".


OUTPUT TO VALUE(c-arquivo).

do i = today to today + 120.
   put string(i,"99/99/9999") format "x(10)" skip.
end.
output close.

IF OPSYS = "UNIX" THEN 
    ASSIGN c-arquivo = "/usr8/spool/projecao/tt-tot.txt".
else
    ASSIGN c-arquivo = "\\intel200\spool\projecao\tt-tot.txt".

OUTPUT TO VALUE(c-arquivo).


put "Comprador" ";". 
assign i-cont = 0.
for each tt-comprador:
    assign i-cont = i-cont + 1.
end.
put i-cont skip.

put "Fornecedor" ";".
assign i-cont = 0.
for each tt-fornec:
    assign i-cont = i-cont + 1.
end.
put i-cont skip.

put "Item" ";".
assign i-cont = 0.
for each tt-item:
    assign i-cont = i-cont + 1.
end.
put i-cont skip.


output close.


RUN pi-finalizar in h-acomp.

{include/i-rpclo.i}
RETURN "OK".
