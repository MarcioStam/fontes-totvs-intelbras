/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESCEP0998RP 2.00.00.008}  /*** 010008 ***/
/*****************************************************************************
**
**       Programa: ESCEP0998
**
**       Data....: 
**
**       Autor...: 
**      
**       Versao..: 1.00.000
**      
*****************************************************************************/
disable triggers for load of movto-estoq.

def query qr-movto   for movto-estoq.

{include/i_dbvers.i}

define temp-table tt-param
    field usuario            as char
    field arquivo            as char
    field destino            as integer
    field data-exec          as date
    field hora-exec          as integer
    field c-ct-atual       like movto-estoq.ct-codigo
    field c-ct-nova        like movto-estoq.ct-codigo
    field c-sc-atual       like movto-estoq.sc-codigo
    field c-sc-nova        like movto-estoq.sc-codigo
    field c-cod-unid-negoc-atual like movto-estoq.cod-unid-negoc
    field c-cod-unid-negoc-nova  like movto-estoq.cod-unid-negoc
    field troca-saldo      like item.loc-unica
    field da-data-ini      like movto-estoq.dt-trans
    field da-data-fim      like movto-estoq.dt-trans
    field i-emi-ini        like movto-estoq.cod-emite
    field i-emi-fim        like movto-estoq.cod-emite
    field c-serie-ini      like movto-estoq.serie-docto
    field c-serie-fim      like movto-estoq.serie-docto
    field c-nro-ini        like movto-estoq.nro-docto
    field c-nro-fim        like movto-estoq.nro-docto
    field c-nat-ini        like movto-estoq.nat-oper
    field c-nat-fim        like movto-estoq.nat-oper
    field i-esp-ini        like movto-estoq.esp-docto
    field i-esp-fim        like movto-estoq.esp-docto
    field c-est-ini        like movto-estoq.cod-estabel
    field c-est-fim        like movto-estoq.cod-estabel
    field c-it-ini         like movto-estoq.it-codigo
    field c-it-fim         like movto-estoq.it-codigo
    field i-ge-ini         like item.ge-codigo
    field i-ge-fim         like item.ge-codigo.
        
define temp-table tt-digita
    field cod-estabel      as character format "x(3)"
    field nome             as character format "x(40)"
    field data-ini         as date format "99/99/9999"
    field data-fim         as date format "99/99/9999".
    
/* Defini‡Æo Temp-Table tt-epc e dos programas de EPCs */
{include/i-epc200.i "escep0998rp"}
def var l-erro as logical init no no-undo.

/***************  Defini‡Æo e prepara‡Æo dos Parƒmetros  ******************/
def temp-table tt-raw-digita
  field raw-digita as raw.
  
def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.
  
create tt-param.
raw-transfer raw-param to tt-param.    
    
for each tt-raw-digita:
    create tt-digita.
    raw-transfer tt-raw-digita.raw-digita to tt-digita.
end.
    
def var i-ct-codigo2 like conta-contab.ct-codigo.
def var i-sc-codigo2 like conta-contab.sc-codigo.

def var h-acomp           as handle  no-undo.
def var c-mensagem        as c.
def var l-resp       as logical no-undo format "Sim/Nao" init no.
def var c-opcao      as character no-undo.
def var i-ct       like movto-estoq.ct-codigo no-undo.
def var i-sc       like movto-estoq.sc-codigo no-undo.
def var i-ct-nova  like i-ct no-undo.
def var i-sc-nova  like i-sc no-undo.
def var i-per-corrente as integer no-undo.
def var i-ano-corrente as integer no-undo.
def var da-data as date format "99/99/9999" no-undo.
def var da-data-ini as date format "99/99/9999" no-undo.
def var da-data-fim as date format "99/99/9999" no-undo.
def var l-confirma  as l format "Sim/Nao" init no.
def var i-cont-alterado as integer.
def var c-lb-tit-par      as char format "x(17)".
def var c-lb-tit-imp      as char format "x(17)".
def var c-lb-tit-sel      as char format "x(17)".
def var c-data            as char.
def var l-fech-estab      as logical init no.
def var c-lb-cont-alterado as char format "x(30)" no-undo.
def var c-lb-est-ini as char format "x(10)" no-undo.

def var i-empresa like param-global.empresa-prin no-undo.
{cdp/cdcfgdis.i}
{cdp/cdcfgmat.i}

{include/i-rpvar.i}

form 
    skip(2) 
    c-lb-cont-alterado no-label at 12 
    i-cont-alterado no-label at 42
    with stream-io side-labels width 132 frame f-alterados.
 
form c-lb-tit-sel         colon 10 no-labels skip(1)
     tt-param.i-emi-ini   at 10 
     "|< >|" at 41
     tt-param.i-emi-fim   at 53 no-labels
     tt-param.c-serie-ini at 4
     "|< >|" at 41
     tt-param.c-serie-fim at 53 no-labels
     tt-param.c-nro-ini   at 11
     "|< >|" at 41
     tt-param.c-nro-fim   at 53 no-labels
     tt-param.c-nat-ini   at 7
     "|< >|" at 41
     tt-param.c-nat-fim   at 53 no-labels
     tt-param.i-esp-ini   at 1
     "|< >|" at 41
     tt-param.i-esp-fim   at 53 no-labels
     c-lb-est-ini         at 14    no-labels
     tt-param.c-est-ini   at 24 no-labels
     "|< >|" at 41
     tt-param.c-est-fim   at 53 no-labels
     tt-param.c-it-ini    at 17
     "|< >|" at 41
     tt-param.c-it-fim    at 53 no-labels 
     with stream-io width 132 side-labels frame f-imp-sel.
     
form skip(2)
     c-lb-tit-par         colon 10 no-labels skip(1)
     tt-param.c-ct-atual  colon 22 
     tt-param.c-ct-nova   colon 58 skip(3)
     c-lb-tit-imp         colon 10 no-labels Skip(1)
     tt-param.destino     colon 20 "-" tt-param.arquivo format "x(30)"
     tt-param.usuario     colon 20 
     with stream-io width 132 side-labels frame f-imp-param.

assign
  c-programa    = "ESCEP0998"
  c-versao      = "1.00"
  c-revisao     = "000".
  

{utp/ut-liter.i ESTOQUE * r}
assign c-sistema = return-value.  

{include/i-rpcab.i}

{utp/ut-liter.i Estabelec}
assign c-lb-est-ini = trim(return-value) + ":".
{utp/ut-liter.i Troca_Conta_Cont bil * R}
assign c-titulo-relat = return-value.   

{utp/ut-liter.i Total_de_registros_alterados * l}
assign c-lb-cont-alterado = trim(return-value) + ":".
{utp/ut-liter.i Conta_DE * r}
assign tt-param.c-ct-atual:label in frame f-imp-param = return-value.
{utp/ut-liter.i PARA * r}
assign tt-param.c-ct-nova:label in frame f-imp-param = return-value.
{utp/ut-liter.i SELE€ÇO * r}
assign c-lb-tit-sel = return-value.
{utp/ut-liter.i PARAMETROS * r}
assign c-lb-tit-par = return-value.
{utp/ut-liter.i IMPRESSÇO * r}
assign c-lb-tit-imp = return-value.
{utp/ut-liter.i Usuario * r}
assign tt-param.usuario:label in frame f-imp-param = return-value.
{utp/ut-liter.i Destino * r}
assign tt-param.destino:label in frame f-imp-param = return-value.
               
find first param-estoq no-lock.
find first param-global no-lock no-error.
/*
assign tt-param.c-ct-atual:format in frame f-imp-param = param-global.formato-conta-contabil
       tt-param.c-ct-nova:format in frame f-imp-param = param-global.formato-conta-contabil .
*/
{utp/ut-liter.i Troca_Conta_Estoque * L}
run utp/ut-acomp.p persistent set h-acomp.
run pi-inicializar in h-acomp(input return-value).

{utp/ut-liter.i Data_Movimento * r}
assign c-data = trim(return-value).

&IF DEFINED(bf_mat_fech_estab) &THEN
    if param-estoq.tp-fech = 2 then
       assign l-fech-estab = yes.
&ENDIF

{include/i-rpout.i}

view frame f-cabec.
view frame f-rodape.

if l-fech-estab then
   for each tt-digita:
      do da-data = tt-digita.data-ini to tt-digita.data-fim:
         run pi-acompanhar in h-acomp (input c-data + ": " + string(da-data,"99/99/9999")).
         if tt-param.troca-saldo THEN DO:
            for each movto-estoq 
               where movto-estoq.contabilizado  = no 
               AND   movto-estoq.cod-estabel    = tt-digita.cod-estabel
               and   movto-estoq.dt-trans       = da-data:

                 IF movto-estoq.ct-saldo = tt-param.c-ct-atual and
                    movto-estoq.sc-saldo = tt-param.c-sc-atual and
                    movto-estoq.cod-unid-negoc = tt-param.c-cod-unid-negoc-atual THEN
                    run pi-movto-estoq.
            end.
         END.
         else DO:
             for each movto-estoq 
                where movto-estoq.contabilizado  = no
                and   movto-estoq.cod-estabel    = tt-digita.cod-estabel
                and   movto-estoq.dt-trans       = da-data:

                 IF movto-estoq.ct-codigo = tt-param.c-ct-atual and
                    movto-estoq.sc-codigo = tt-param.c-sc-atual and
                    movto-estoq.cod-unid-negoc = tt-param.c-cod-unid-negoc-atual THEN
                    run pi-movto-estoq.
             end.
         END.
      end.
   end.
else do:
    IF tt-param.c-serie-ini = tt-param.c-serie-fim AND
       tt-param.c-nro-ini   = tt-param.c-nro-fim   AND
       tt-param.i-emi-ini   = tt-param.i-emi-fim   AND
       tt-param.c-nat-ini   = tt-param.c-nat-fim   THEN DO:
        FOR EACH movto-estoq
           WHERE movto-estoq.serie-docto  = tt-param.c-serie-ini
             AND movto-estoq.nro-docto    = tt-param.c-nro-ini
             AND movto-estoq.cod-emitente = tt-param.i-emi-ini
             AND movto-estoq.nat-operacao = tt-param.c-nat-ini:
            IF movto-estoq.contabilizado = YES THEN NEXT.
            IF movto-estoq.dt-trans < tt-param.da-data-ini THEN NEXT.
            IF movto-estoq.dt-trans > tt-param.da-data-fim THEN NEXT.

            run pi-acompanhar in h-acomp (input c-data + ": " + string(movto-estoq.dt-trans,"99/99/9999")).
            run pi-movto-estoq.
        END.
    END.
    ELSE DO:
        do da-data = tt-param.da-data-ini to tt-param.da-data-fim:
           run pi-acompanhar in h-acomp (input c-data + ": " + string(da-data,"99/99/9999")).
        
           if tt-param.troca-saldo = yes THEN DO:
              for each movto-estoq where
                  movto-estoq.contabilizado  = no  and
                  movto-estoq.cod-estabel    = tt-param.c-est-ini AND
                  movto-estoq.dt-trans       = da-data:
    
               IF movto-estoq.ct-saldo = tt-param.c-ct-atual and
                  movto-estoq.sc-saldo = tt-param.c-sc-atual and
                  movto-estoq.cod-unid-negoc = tt-param.c-cod-unid-negoc-atual THEN
                    run pi-movto-estoq.
              end.
           END.
           ELSE DO:
               IF tt-param.i-esp-ini = tt-param.i-esp-fim THEN DO:
                   for each movto-estoq where
                       movto-estoq.esp-docto = tt-param.i-esp-ini  and
                       movto-estoq.dt-trans       = da-data:
                       IF movto-estoq.contabilizado = NO AND
                          movto-estoq.ct-codigo = tt-param.c-ct-atual and
                          movto-estoq.sc-codigo = tt-param.c-sc-atual and
                          movto-estoq.cod-unid-negoc = tt-param.c-cod-unid-negoc-atual THEN
                          run pi-movto-estoq.
                   end.
               END.
               ELSE DO:
                   for each movto-estoq where
                       movto-estoq.contabilizado  = no         and
                       movto-estoq.cod-estabel    = tt-param.c-est-ini AND
                       movto-estoq.dt-trans       = da-data:

                       IF movto-estoq.cod-emitente < tt-param.i-emi-ini 
                       OR movto-estoq.cod-emitente > tt-param.i-emi-fim  THEN NEXT.

                       IF movto-estoq.ct-codigo = tt-param.c-ct-atual and
                          movto-estoq.sc-codigo = tt-param.c-sc-atual and
                          movto-estoq.cod-unid-negoc = tt-param.c-cod-unid-negoc-atual THEN
                          run pi-movto-estoq.
                   end.
               END.
           END.
        end.  
    END.
end.

run pi-finalizar in h-acomp.

disp c-lb-tit-sel
     tt-param.i-emi-ini   
     tt-param.i-emi-fim   
     tt-param.c-serie-ini 
     tt-param.c-serie-fim 
     tt-param.c-nro-ini   
     tt-param.c-nro-fim   
     tt-param.c-nat-ini   
     tt-param.c-nat-fim   
     tt-param.i-esp-ini   
     tt-param.i-esp-fim  
     c-lb-est-ini 
     tt-param.c-est-ini   
     tt-param.c-est-fim   
     tt-param.c-it-ini    
     tt-param.c-it-fim    
     with frame f-imp-sel.
     
disp c-lb-tit-par
     tt-param.c-ct-atual
     tt-param.c-ct-nova
     c-lb-tit-imp
     tt-param.destino
     tt-param.arquivo
     tt-param.usuario
     with frame f-imp-param.
     
disp c-lb-cont-alterado
     i-cont-alterado 
     with frame f-alterados. 

{include/i-rpclo.i}      

return "OK".

Procedure pi-movto-estoq:
    
/*     /* CHAMADA EPC */                                                            */
/*     ............................................................................ */
/*     assign l-erro = no.                                                          */
/*     for each tt-epc                                                              */
/*         where tt-epc.cod-event = "inventory-transaction":                        */
/*         delete tt-epc.                                                           */
/*     end.                                                                         */
/*     create tt-epc.                                                               */
/*     assign tt-epc.cod-event     = "inventory-transaction"                        */
/*            tt-epc.cod-parameter   = "movto-estoq rowid"                          */
/*            tt-epc.val-parameter = string(rowid(movto-estoq)).                    */
/*                                                                                  */
/*     {include/i-epc201.i "inventory-transaction"}                                 */
/*                                                                                  */
/*     if  return-value = "NOK" then                                                */
/*         assign l-erro = yes.                                                     */
/*     ............................................................................ */
    
    if l-fech-estab AND
       (movto-estoq.cod-estabel < tt-param.c-est-ini OR
        movto-estoq.cod-estabel <= tt-param.c-est-fim) THEN NEXT.

    if not l-erro and
       movto-estoq.ct-codigo    = tt-param.c-ct-atual  AND
       movto-estoq.sc-codigo    = tt-param.c-sc-atual  AND
       movto-estoq.cod-unid-negoc = tt-param.c-cod-unid-negoc-atual AND
       movto-estoq.cod-emite   >= tt-param.i-emi-ini   and
       movto-estoq.cod-emite   <= tt-param.i-emi-fim   and
       movto-estoq.serie-docto >= tt-param.c-serie-ini and
       movto-estoq.serie-docto <= tt-param.c-serie-fim and
       movto-estoq.nro-docto   >= tt-param.c-nro-ini   and
       movto-estoq.nro-docto   <= tt-param.c-nro-fim   and
       movto-estoq.esp-docto   >= tt-param.i-esp-ini   and
       movto-estoq.esp-docto   <= tt-param.i-esp-fim   and
       movto-estoq.it-codigo   >= tt-param.c-it-ini    and
       movto-estoq.it-codigo   <= tt-param.c-it-fim    then do:
    
        if movto-estoq.nat-oper = "" or 
          (movto-estoq.nat-oper >= tt-param.c-nat-ini and
           movto-estoq.nat-oper <= tt-param.c-nat-fim) then do:
            find first item where 
                 item.it-codigo = movto-estoq.it-codigo no-lock no-error.
            if not avail item then next.
       
            if item.ge-codigo >= tt-param.i-ge-ini and
               item.ge-codigo <= tt-param.i-ge-fim then do:
               
                assign i-empresa = param-global.empresa-prin.
             
                &if defined (bf_dis_consiste_conta) &then
             
                    find first estabelec where
                               estabelec.cod-estabel = movto-estoq.cod-estabel no-lock no-error.

                    run cdp/cd9970.p (input rowid(estabelec),
                                      output i-empresa).
                &endif
                    
                if tt-param.troca-saldo then do:
                    assign movto-estoq.ct-saldo           = tt-param.c-ct-nova
                           movto-estoq.sc-saldo           = tt-param.c-sc-nova
                           movto-estoq.cod-unid-negoc-sdo = tt-param.c-cod-unid-negoc-nova
                           i-cont-alterado                = i-cont-alterado + 1.  
                end.
                else do: 
                    assign movto-estoq.ct-codigo      = tt-param.c-ct-nova
                           movto-estoq.sc-codigo      = tt-param.c-sc-nova
                           movto-estoq.cod-unid-negoc = tt-param.c-cod-unid-negoc-nova
                           i-cont-alterado         = i-cont-alterado + 1.
  
                end.
/*
                &if  "{&mgadm_version}" >= "2.04" &then 
                     run cdp/cdapi191.p(input rowid(movto-estoq),
                                        input i-empresa,
                                        input c-ct-atual,
                                        input c-ct-nova).
                                                                        
                     if return-value = "NOK" then
                       return "NOK". 
                &endif
  */
            end.          
        end.      
    end.
end procedure.
