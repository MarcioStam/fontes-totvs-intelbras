/********************************************************************************
*      Programa .....: esccp057rp.p                                             *
*      Data .........: 20 de junho de 2023                                      *
*      Sistema ......: ESP                                                      *
*      Empresa ......: iDBA                                                     *
*      Cliente ......: Intelbras                                                *
*      Programador ..: Maur¡cio C.                                              *
*      Objetivo .....: Logs Integra‡äes APS                                     *
*********************************************************************************
*      VERSAO       DATA        RESPONSAVEL   MOTIVO                            *
*      1.00.00.000  20/06/2023  Mauricio C.   Desenvolvimento                   *
********************************************************************************/
{include/i-prgvrs.i esccp057rp 1.00.00.000}

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i esccp057rp ESP}
&ENDIF

define temp-table tt-param no-undo
    field destino             as integer
    field arquivo             as char format "x(35)"
    field usuario             as char format "x(12)"
    field data-exec           as date
    field hora-exec           as integer
    field classifica          as integer
    field desc-classifica     as char format "x(40)"
    field modelo-rtf          as char format "x(35)"
    field l-habilitaRtf       as LOG
    field lg-ord-prod         as logi
    field lg-ordem-compra     as logi
    field lg-upd-ord-prod     as logi
    field lg-upd-ordem-compra as logi
    field cod-op-aps-ini      as char
    field cod-op-aps-fim      as char
    field nr-ord-produ-ini    as inte
    field nr-ord-produ-fim    as inte
    field it-op-ini           as char
    field it-op-fim           as char
    field it-codigo-fim       as char
    field cod-oc-aps-ini      as char
    field cod-oc-aps-fim      as char
    field numero-ordem-ini    as inte
    field numero-ordem-fim    as inte
    field it-oc-ini           as char
    field it-oc-fim           as char.

define temp-table tt-raw-digita
    field raw-digita    as raw.

define temp-table tt-int-ord-prod-aps no-undo like int-ord-prod-aps
    index id is primary cod-ordem-aps.

define temp-table tt-int-ord-comp-aps no-undo like int-ord-comp-aps
    index id is primary cod-ordem-aps.

/*  Recebimento de parametros --- */
def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

find current tt-param no-error.    

/***** VARIµVEIS *****/
{include/i-rpvar.i}

define variable h-acomp as handle  no-undo.
define variable i-cont  as integer no-undo.
define variable lg-aux  as logical no-undo.

/***** FRAMES *****/
form tt-int-ord-prod-aps.cod-ordem-aps    format "x(20)"               column-label "OP APS"
     tt-int-ord-prod-aps.nr-ord-prod      format ">>>,>>>,>>9"         column-label "Nr Ord Prod"
     tt-int-ord-prod-aps.it-codigo        format "x(16)"               column-label "Item"
     tt-int-ord-prod-aps.qt-ord-prod      format ">>>>>,>>9.9999"      column-label "Qtde Ordem"
     tt-int-ord-prod-aps.dt-entrega       format "99/99/9999"          column-label "Entrega"
     tt-int-ord-prod-aps.dt-inicio        format "99/99/9999"          column-label "In¡cio"
     tt-int-ord-prod-aps.dt-emissao       format "99/99/9999"          column-label "EmissÆo"
     tt-int-ord-prod-aps.cod-estabel      format "x(5)"                column-label "Estab"
     tt-int-ord-prod-aps.log-integrado    format "Sim/NÆo"             column-label "Integrado"
     tt-int-ord-prod-aps.log-eliminado    format "Sim/NÆo"             column-label "Eliminado"
     tt-int-ord-prod-aps.usuar-integr-in  format "x(12)"               column-label "Usuar Integr In"
     tt-int-ord-prod-aps.dt-integr-in     format "99/99/9999 HH:MM:SS" column-label "Dt Integr In"
     tt-int-ord-prod-aps.usuar-integr-out format "x(12)"               column-label "Usuar Integr Out"
     tt-int-ord-prod-aps.dt-integr-out    format "99/99/9999 HH:MM:SS" column-label "Dt Integr Out"
     with width 215 down no-box stream-io frame f-ord-prod.

form tt-int-ord-comp-aps.cod-ordem-aps    format "x(20)"               column-label "OC APS"
     tt-int-ord-comp-aps.nr-ord-comp      format "zzzzz9,99"           column-label "Ordem Compra"
     tt-int-ord-comp-aps.it-codigo        format "x(16)"               column-label "Item"
     tt-int-ord-comp-aps.qtd-ord-comp     format ">>>>>,>>9.9999"      column-label "Qt Ord Comp"
     tt-int-ord-comp-aps.dt-emissao       format "99/99/9999"          column-label "EmissÆo"
     tt-int-ord-comp-aps.dt-necessidade   format "99/99/9999"          column-label "Necessidade"
     tt-int-ord-comp-aps.dt-entrega       format "99/99/9999"          column-label "Entrega"
     tt-int-ord-comp-aps.cod-estabel      format "x(5)"                column-label "Estab"
     tt-int-ord-comp-aps.log-integrado    format "Sim/NÆo"             column-label "Integrado"
     tt-int-ord-comp-aps.log-eliminado    format "Sim/NÆo"             column-label "Eliminado"
     tt-int-ord-comp-aps.usuar-integr-in  format "x(12)"               column-label "Usuar Integr In"
     tt-int-ord-comp-aps.dt-integr-in     format "99/99/9999 HH:MM:SS" column-label "Dt Integr In"
     tt-int-ord-comp-aps.usuar-integr-out format "x(12)"               column-label "Usuar Integr Out"
     tt-int-ord-comp-aps.dt-integr-out    format "99/99/9999 HH:MM:SS" column-label "Dt Integr Out"
     with width 215 down no-box stream-io frame f-ordem-compra.

form int-upd-prod-aps.nr-ord-prod      format ">>>,>>>,>>9"         column-label "Nr Ord Prod"   
     ord-prod.it-codigo                format "x(16)"               column-label "Item"   
     int-upd-prod-aps.sequencia        format ">>>>>9"              column-label "Sequˆncia"   
     int-upd-prod-aps.dt-inicio        format "99/99/9999"          column-label "In¡cio"     
     int-upd-prod-aps.dt-fim           format "99/99/9999"          column-label "Fim"     
     int-upd-prod-aps.log-atualizado   format "Sim/NÆo"             column-label "Atualizado"     
     int-upd-prod-aps.log-eliminado    format "Sim/NÆo"             column-label "Eliminado"    
     int-upd-prod-aps.log-inexistente  format "Sim/NÆo"             column-label "Inexistente"    
     int-upd-prod-aps.usuar-integr-in  format "x(12)"               column-label "Usuar Integr In"     
     int-upd-prod-aps.dt-integr-in     format "99/99/9999 HH:MM:SS" column-label "Dt Integr In"        
     int-upd-prod-aps.usuar-integr-out format "x(12)"               column-label "Usuar Integr Out"    
     int-upd-prod-aps.dt-integr-out    format "99/99/9999 HH:MM:SS" column-label "Dt Integr Out"       
     with width 215 down no-box stream-io frame f-upd-prod.

form int-upd-compra-aps.nr-ord-comp      format "zzzzz9,99"           column-label "Ordem Compra"   
     ordem-compra.it-codigo              format "x(16)"               column-label "Item"
     int-upd-compra-aps.parcela          format ">>>>9"               column-label "Parcela"
     int-upd-compra-aps.sequencia        format ">>>>>9"              column-label "Sequˆncia"  
     int-upd-compra-aps.dt-necessidade   format "99/99/9999"          column-label "Necessidade" 
     int-upd-compra-aps.log-atualizado   format "Sim/NÆo"             column-label "Atualizado"     
     int-upd-compra-aps.log-eliminado    format "Sim/NÆo"             column-label "Eliminado"    
     int-upd-compra-aps.log-inexistente  format "Sim/NÆo"             column-label "Inexistente"    
     int-upd-compra-aps.usuar-integr-in  format "x(12)"               column-label "Usuar Integr In"     
     int-upd-compra-aps.dt-integr-in     format "99/99/9999 HH:MM:SS" column-label "Dt Integr In"        
     int-upd-compra-aps.usuar-integr-out format "x(12)"               column-label "Usuar Integr Out"    
     int-upd-compra-aps.dt-integr-out    format "99/99/9999 HH:MM:SS" column-label "Dt Integr Out"       
     with width 215 down no-box stream-io frame f-upd-comp.

find first param-global no-lock no-error.

assign c-programa     = "ESCCP057":U
       c-versao       = "1.00.00":U
       c-revisao      = "000":U
       c-empresa      = param-global.grupo
       c-titulo-relat = "Logs Integra‡äes APS"
       c-sistema      = "ESP".

assign c-rodape = "iDBA - " 
                + c-sistema 
                + " - " 
                + c-programa
                + " - V:" 
                + c-versao
                + "."
                + c-revisao
       c-rodape = fill("-", 215 - length(c-rodape)) + c-rodape.

form header
     fill("-", 215) format "x(215)" skip
     c-empresa c-titulo-relat at 50
     "Folha:" at 205 page-number  at 211 format ">>>>9" skip
     fill("-", 195) format "x(193)" today format "99/99/9999"
     "-" string(time, "HH:MM:SS") skip(1)
     with stream-io width 215 no-labels no-box page-top frame f-cabec.

form header
     c-rodape format "x(215)"
     with stream-io width 215 no-labels no-box page-bottom frame f-rodape.

{include/i-rpout.i}

view frame f-cabec.
view frame f-rodape.

run utp/ut-acomp.p persistent set h-acomp.
run pi-inicializar in h-acomp (input "Processando...").

empty temp-table tt-int-ord-prod-aps.
empty temp-table tt-int-ord-comp-aps.

if tt-param.lg-ord-prod
then do:
     run pi-seta-titulo in h-acomp (input "Ord Prod...").

     if tt-param.cod-op-aps-ini <> ""
     then for each int-ord-prod-aps use-index codigo no-lock
             where int-ord-prod-aps.cod-ordem-aps >= tt-param.cod-op-aps-ini
               and int-ord-prod-aps.cod-ordem-aps <= tt-param.cod-op-aps-fim
               and int-ord-prod-aps.nr-ord-prod   >= tt-param.nr-ord-produ-ini
               and int-ord-prod-aps.nr-ord-prod   <= tt-param.nr-ord-produ-fim
               and int-ord-prod-aps.it-codigo     >= tt-param.it-op-ini
               and int-ord-prod-aps.it-codigo     <= tt-param.it-op-fim:
              assign i-cont = i-cont + 1.

              if i-cont mod 20 = 0
              then run pi-acompanhar in h-acomp (input "OP APS " + int-ord-prod-aps.cod-ordem-aps).

              create tt-int-ord-prod-aps.
              buffer-copy int-ord-prod-aps to tt-int-ord-prod-aps.
          end. /* for each int-ord-prod-aps */
     else for each estabelec fields(cod-estabel) no-lock,
              each int-ord-prod-aps use-index estabel no-lock
             where int-ord-prod-aps.cod-estabel    = estabelec.cod-estabel
               and int-ord-prod-aps.nr-ord-prod   >= tt-param.nr-ord-produ-ini
               and int-ord-prod-aps.nr-ord-prod   <= tt-param.nr-ord-produ-fim
               and int-ord-prod-aps.it-codigo     >= tt-param.it-op-ini
               and int-ord-prod-aps.it-codigo     <= tt-param.it-op-fim
               and int-ord-prod-aps.cod-ordem-aps >= tt-param.cod-op-aps-ini
               and int-ord-prod-aps.cod-ordem-aps <= tt-param.cod-op-aps-fim:
              assign i-cont = i-cont + 1.

              if i-cont mod 20 = 0
              then run pi-acompanhar in h-acomp (input "Est " + estabelec.cod-estabel + ", OP " + string(int-ord-prod-aps.nr-ord-prod)).

              create tt-int-ord-prod-aps.
              buffer-copy int-ord-prod-aps to tt-int-ord-prod-aps.
          end. /* for each int-ord-prod-aps */

     find current tt-int-ord-prod-aps no-error.
     release tt-int-ord-prod-aps.

     if temp-table tt-int-ord-prod-aps:has-records
     then do:
          assign i-cont = 0.

          put unformatted "ORDEM PRODU€ÇO" skip(1).

          for each tt-int-ord-prod-aps:
              assign i-cont = i-cont + 1.

              if i-cont mod 50 = 0
              then run pi-acompanhar in h-acomp (input i-cont).

              disp tt-int-ord-prod-aps.cod-ordem-aps
                   with frame f-ord-prod.

              if tt-int-ord-prod-aps.nr-ord-prod > 0
              then disp tt-int-ord-prod-aps.nr-ord-prod
                        with frame f-ord-prod.

              disp tt-int-ord-prod-aps.it-codigo
                   tt-int-ord-prod-aps.qt-ord-prod
                   tt-int-ord-prod-aps.dt-entrega
                   tt-int-ord-prod-aps.dt-inicio
                   tt-int-ord-prod-aps.dt-emissao
                   tt-int-ord-prod-aps.cod-estabel
                   tt-int-ord-prod-aps.log-integrado
                   tt-int-ord-prod-aps.log-eliminado
                   tt-int-ord-prod-aps.usuar-integr-in
                   tt-int-ord-prod-aps.dt-integr-in
                   tt-int-ord-prod-aps.usuar-integr-out
                   tt-int-ord-prod-aps.dt-integr-out
                   with frame f-ord-prod.
              down with frame f-ord-prod.
          end. /* for each tt-int-ord-prod-aps */

          put skip(1).

          assign lg-aux = yes.
     end. /* if temp-table tt-int-ord-prod-aps:has-records */ 
end. /* if tt-param.lg-ord-prod */

if tt-param.lg-ordem-compra
then do:
     run pi-seta-titulo in h-acomp (input "Ord Compra...").

     assign i-cont = 0.

     if tt-param.cod-oc-aps-ini <> ""
     then for each int-ord-comp-aps use-index ordem no-lock
             where int-ord-comp-aps.cod-ordem-aps >= tt-param.cod-oc-aps-ini
               and int-ord-comp-aps.cod-ordem-aps <= tt-param.cod-oc-aps-fim
               and int-ord-comp-aps.nr-ord-comp   >= tt-param.numero-ordem-ini
               and int-ord-comp-aps.nr-ord-comp   <= tt-param.numero-ordem-fim
               and int-ord-comp-aps.it-codigo     >= tt-param.it-oc-ini
               and int-ord-comp-aps.it-codigo     <= tt-param.it-oc-fim:
              assign i-cont = i-cont + 1.

              if i-cont mod 20 = 0
              then run pi-acompanhar in h-acomp (input "OC APS " + int-ord-comp-aps.cod-ordem-aps).

              create tt-int-ord-comp-aps.
              buffer-copy int-ord-comp-aps to tt-int-ord-comp-aps.
          end. /* for each int-ord-prod-aps */
     else for each estabelec fields(cod-estabel) no-lock,
              each int-ord-comp-aps use-index estabel no-lock
             where int-ord-comp-aps.cod-estabel    = estabelec.cod-estabel
               and int-ord-comp-aps.nr-ord-comp   >= tt-param.numero-ordem-ini
               and int-ord-comp-aps.nr-ord-comp   <= tt-param.numero-ordem-fim
               and int-ord-comp-aps.it-codigo     >= tt-param.it-oc-ini
               and int-ord-comp-aps.it-codigo     <= tt-param.it-oc-fim
               and int-ord-comp-aps.cod-ordem-aps >= tt-param.cod-oc-aps-ini
               and int-ord-comp-aps.cod-ordem-aps <= tt-param.cod-oc-aps-fim:
              assign i-cont = i-cont + 1.

              if i-cont mod 20 = 0
              then run pi-acompanhar in h-acomp (input "Est " + estabelec.cod-estabel + ", OP " + string(int-ord-comp-aps.nr-ord-comp)).

              create tt-int-ord-comp-aps.
              buffer-copy int-ord-comp-aps to tt-int-ord-comp-aps.
          end. /* for each int-ord-prod-aps */

     find current tt-int-ord-comp-aps no-error.
     release tt-int-ord-comp-aps.

     if temp-table tt-int-ord-comp-aps:has-records
     then do:
          assign i-cont = 0.

          if lg-aux
          then put unformatted fill("-",215) 
                               skip(1).

          put unformatted "ORDEM COMPRA" 
                          skip(1).

          for each tt-int-ord-comp-aps:
              assign i-cont = i-cont + 1.

              if i-cont mod 50 = 0
              then run pi-acompanhar in h-acomp (input i-cont).

              disp tt-int-ord-comp-aps.cod-ordem-aps
                   with frame f-ordem-compra.

              if tt-int-ord-comp-aps.nr-ord-comp > 0
              then disp tt-int-ord-comp-aps.nr-ord-comp
                        with frame f-ordem-compra.

              disp tt-int-ord-comp-aps.it-codigo       
                   tt-int-ord-comp-aps.qtd-ord-comp    
                   tt-int-ord-comp-aps.dt-emissao      
                   tt-int-ord-comp-aps.dt-necessidade  
                   tt-int-ord-comp-aps.dt-entrega      
                   tt-int-ord-comp-aps.cod-estabel     
                   tt-int-ord-comp-aps.log-integrado   
                   tt-int-ord-comp-aps.log-eliminado   
                   tt-int-ord-comp-aps.usuar-integr-in 
                   tt-int-ord-comp-aps.dt-integr-in    
                   tt-int-ord-comp-aps.usuar-integr-out
                   tt-int-ord-comp-aps.dt-integr-out   
                   with frame f-ordem-compra.
              down with frame f-ordem-compra.
          end. /* for each tt-int-ord-comp-aps */

          put skip(1).

          assign lg-aux = yes.
     end. /* if temp-table tt-int-ord-comp-aps:has-records */ 
end. /* if tt-param.lg-ordem-compra */

if tt-param.lg-upd-ord-prod
then do:
     run pi-seta-titulo in h-acomp (input "Upd Ord Prod...").

     assign i-cont = 0.

     for each int-upd-prod-aps no-lock
        where int-upd-prod-aps.nr-ord-prod >= tt-param.nr-ord-produ-ini
          and int-upd-prod-aps.nr-ord-prod <= tt-param.nr-ord-produ-fim
              break by int-upd-prod-aps.nr-ord-prod:
         if i-cont mod 20 = 0
         then run pi-acompanhar in h-acomp (input "Nr Ord Prod " + string(int-upd-prod-aps.nr-ord-prod)).

         for first ord-prod fields(nr-ord-produ it-codigo)
             where ord-prod.nr-ord-produ = int-upd-prod-aps.nr-ord-prod
                   no-lock: end.

         if  tt-param.it-op-ini = ""
         and tt-param.it-op-fim begins "ZZZZ"
         then.
         else if  avail ord-prod
              and ord-prod.it-codigo >= tt-param.it-op-ini
              and ord-prod.it-codigo <= tt-param.it-op-fim
              then.
              else do:
                   if i-cont mod 20 <> 0
                   then run pi-acompanhar in h-acomp (input "Nr Ord Prod " + string(int-upd-prod-aps.nr-ord-prod)).
                   next.
              end. /* else do */

         if i-cont = 0
         then do:
              if lg-aux
              then put unformatted fill("-",215) 
                                   skip(1).
    
              put unformatted "ATUALIZA ORDEM PRODU€ÇO" 
                              skip(1).
         end. /* if i-cont = 0 */

         if first-of(int-upd-prod-aps.nr-ord-prod)
         then disp int-upd-prod-aps.nr-ord-prod
                   ord-prod.it-codigo when avail ord-prod
                   with frame f-upd-prod.

         disp int-upd-prod-aps.sequencia
              int-upd-prod-aps.dt-inicio
              int-upd-prod-aps.dt-fim
              int-upd-prod-aps.log-atualizado
              int-upd-prod-aps.log-eliminado  
              int-upd-prod-aps.log-inexistente
              int-upd-prod-aps.usuar-integr-in
              int-upd-prod-aps.dt-integr-in
              int-upd-prod-aps.usuar-integr-out
              int-upd-prod-aps.dt-integr-out
              with frame f-upd-prod.
         down with frame f-upd-prod.

         assign i-cont = i-cont + 1.
     end. /* for each int-ord-prod-aps */
end. /* if tt-param.lg-upd-ord-prod */

if tt-param.lg-upd-ordem-compra
then do:
     run pi-seta-titulo in h-acomp (input "Upd Ord Compra...").

     assign i-cont = 0.

     for each int-upd-compra-aps no-lock
        where int-upd-compra-aps.nr-ord-comp >= tt-param.numero-ordem-ini
          and int-upd-compra-aps.nr-ord-comp <= tt-param.numero-ordem-fim
              break by int-upd-compra-aps.nr-ord-comp
                    by int-upd-compra-aps.parcela:
         if i-cont mod 20 = 0
         then run pi-acompanhar in h-acomp (input "Ordem Compra " + string(int-upd-compra-aps.nr-ord-comp)).

         for first ordem-compra fields(numero-ordem it-codigo)
             where ordem-compra.numero-ordem = int-upd-compra-aps.nr-ord-comp
                   no-lock: end.

         if  tt-param.it-oc-ini = ""
         and tt-param.it-oc-fim begins "ZZZZ"
         then.
         else if  avail ordem-compra
              and ordem-compra.it-codigo >= tt-param.it-oc-ini
              and ordem-compra.it-codigo <= tt-param.it-oc-fim
              then.
              else do:
                   if i-cont mod 20 <> 0
                   then run pi-acompanhar in h-acomp (input "Ordem Compra " + string(int-upd-compra-aps.nr-ord-comp)).
                   next.
              end. /* else do */

         if i-cont = 0
         then do:
              if lg-aux
              then put unformatted fill("-",215) 
                                   skip(1).
    
              put unformatted "ATUALIZA ORDEM COMPRA" 
                              skip(1).
         end. /* if i-cont = 0 */

         if first-of(int-upd-compra-aps.parcela)
         then disp int-upd-compra-aps.nr-ord-comp   
                   ordem-compra.it-codigo when avail ordem-compra    
                   int-upd-compra-aps.parcela
                   with frame f-upd-comp.

         disp int-upd-compra-aps.sequencia                 
              int-upd-compra-aps.dt-necessidade  
              int-upd-compra-aps.log-atualizado  
              int-upd-compra-aps.log-eliminado   
              int-upd-compra-aps.log-inexistente 
              int-upd-compra-aps.usuar-integr-in 
              int-upd-compra-aps.dt-integr-in    
              int-upd-compra-aps.usuar-integr-out
              int-upd-compra-aps.dt-integr-out   
              with frame f-upd-comp.
         down with frame f-upd-comp.

         assign i-cont = i-cont + 1.
     end. /* for each int-upd-compra-aps */
end. /* if tt-param.lg-upd-ordem-compra */

run pi-finalizar in h-acomp.

{include/i-rpclo.i}

return "OK":U.
