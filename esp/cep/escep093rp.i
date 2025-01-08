assign lg-comp-spot   = (lg-avail and int-item-uni-estab.log-comp-spot)
       lg-mod-aereo   = (lg-avail and int-item-uni-estab.log-mod-aereo)
       lg-phase-in    = (lg-avail and int-item-uni-estab.log-phase-in)
       lg-phase-out   = (lg-avail and int-item-uni-estab.log-phase-out)
       lg-item-rest   = (lg-avail and int-item-uni-estab.log-item-rest)
       lg-bloq-prod   = (lg-avail and int-item-uni-estab.log-bloq-prod)
       lg-requer-aval = (lg-avail and int-item-uni-estab.log-requer-aval).

if (tt-param.comp-spot = 1
and not lg-comp-spot)
or (tt-param.comp-spot = 2
and lg-comp-spot)
then next.

if (tt-param.mod-aereo = 1
and not lg-mod-aereo)
or (tt-param.mod-aereo = 2
and lg-mod-aereo)
then next.

if (tt-param.phase-in = 1
and not lg-phase-in)
or (tt-param.phase-in = 2
and lg-phase-in)
then next.

if (tt-param.phase-out = 1
and not lg-phase-out)
or (tt-param.phase-out = 2
and lg-phase-out)
then next.

if (tt-param.item-rest = 1
and not lg-item-rest)
or (tt-param.item-rest = 2
and lg-item-rest)
then next.

if (tt-param.bloq-prod = 1
and not lg-bloq-prod)
or (tt-param.bloq-prod = 2
and lg-bloq-prod)
then next.

if (tt-param.requer-aval = 1
and not lg-requer-aval)
or (tt-param.requer-aval = 2
and lg-requer-aval)
then next.

if not lg-cabec
then put stream st-csv unformatted 
         "sep=;"
         skip
         "Estab;"
         "Item;"
         "Permite Compra Spot;"       
         "Permite Modal A‚reo;"      
         "Item Phase-in;"        
         "Item Phase-out;"        
         "Tempo Transf. Estab;"     
         "Modelo;"         
         "Lote M¡nimo Compras;"
         "Lote M¡nimo Fabrica‡Æo;"
         "Lote M ximo Compras;"
         "Lote Maximo Fabrica‡Æo;"
         "Qtd Dias M¡nimo;" 
         "Qtd Dias Alvo;"
         "Qtd Dias Cob. MP Kit CKD/SKD;"
         "Qtd Dias Alvo MP Kit CKD/SKD;"
         "Qtd Dias Antec;"
         "Item Restritivo;"
         "Bloqueado Produ‡Æo;"
         "Requer Avalia‡Æo;"
         "Situa‡Æo;"
         skip.

assign lg-cabec = yes.

put stream st-csv unformatted 
    item-uni-estab.cod-estabel ";"
    item-uni-estab.it-codigo   ";".

if not lg-avail
then put stream st-csv unformatted 
         ";;;;;;;;;;;;;;;;;;".
else put stream st-csv unformatted 
         int-item-uni-estab.log-comp-spot    format "Sim/NÆo" ";"
         int-item-uni-estab.log-mod-aereo    format "Sim/NÆo" ";"
         int-item-uni-estab.log-phase-in     format "Sim/NÆo" ";"
         int-item-uni-estab.log-phase-out    format "Sim/NÆo" ";"
         int-item-uni-estab.num-dias-transf                   ";"
         int-item-uni-estab.cod-modelo                        ";"
         int-item-uni-estab.qtd-min-comp                      ";"
         int-item-uni-estab.qtd-min-fab                       ";"
         int-item-uni-estab.qtd-max-comp                      ";"
         int-item-uni-estab.qtd-max-fab                       ";"
         int-item-uni-estab.num-dias-min                      ";"
         int-item-uni-estab.num-dias-alvo                     ";"
         int-item-uni-estab.num-dias-cob-mp                   ";"
         int-item-uni-estab.num-dias-alvo-mp                  ";"
         int-item-uni-estab.num-dias-antec                    ";"
         int-item-uni-estab.log-item-rest    format "Sim/NÆo" ";"
         int-item-uni-estab.log-bloq-prod    format "Sim/NÆo" ";"
         int-item-uni-estab.log-requer-aval  format "Sim/NÆo" ";".

put stream st-csv unformatted
    entry(item-uni-estab.cod-obsoleto,c-obsoleto)
    skip.
