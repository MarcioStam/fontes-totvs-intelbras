/*----------------------------------------------------------------------
**  Programa..: esp/pdp/espdp052rp.p
**  Autor.....: Felipe Braun Azambuja
**  Data......: Julho/2009 - Desenvolvimento
**  Descricao.: Valores de pedidos alocados
-----------------------------------------------------------------------*/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i espdp052 2.04.00.002}

/*---------------------------  Variaveis    ---------------------------*/

{include/i-rpvar.i}
{utp/ut-glob.i}

find first param-global no-lock.
find first empresa      no-lock
   where empresa.ep-codigo = param-global.empresa-pri.

assign c-sistema      = "Espec¡ficos Intelbras"
       c-titulo-relat = "Pedidos alocados"
       c-empresa      = if available empresa then empresa.razao-social else ''
       c-programa     = "ESPDP052"
       c-versao       = "2.04"
       c-revisao      = "002".

{esp/pdp/espdp052tt.i}

define variable h-acomp      as handle  no-undo.
define variable v_dt_fim_mes as date    no-undo.
define variable d-cotacao    as decimal no-undo.
define variable d-quantidade as decimal no-undo.
define variable de-total     like tt-pedido.vl-merc no-undo extent 11.

assign v_dt_fim_mes = date(if month(today) < 12 then
                              month(today) + 1
                           else
                              1,
                           1,
                           if month(today) < 12 then
                              year(today)
                           else
                              year(today) + 1) - 1.

/****************************  Frames       ****************************/

form tt-pedido.cod-rep
     tt-pedido.vl-merc[1]  column-label 'ADM'
     tt-pedido.vl-merc[2]  column-label 'CEN'
     tt-pedido.vl-merc[3]  column-label 'TER'
     tt-pedido.vl-merc[4]  column-label 'SEC'
     tt-pedido.vl-merc[5]  column-label 'NET'
     tt-pedido.vl-merc[6]  column-label 'COM'
     tt-pedido.vl-merc[7]  column-label 'MAX'
     tt-pedido.vl-merc[8]  column-label 'INV'
     tt-pedido.vl-merc[9]  column-label 'AUT'
     tt-pedido.vl-merc[10] column-label 'FIR'
     tt-pedido.vl-merc[11] column-label 'ACE'

     with width 140 no-box down frame f-pedido stream-io.

form 'Total '
     de-total[1]  column-label 'ADM'
     de-total[2]  column-label 'CEN'
     de-total[3]  column-label 'TER'
     de-total[4]  column-label 'SEC'
     de-total[5]  column-label 'NET'
     de-total[6]  column-label 'COM'
     de-total[7]  column-label 'MAX'
     de-total[8]  column-label 'INV'
     de-total[9]  column-label 'AUT'
     de-total[10] column-label 'FIR'
     de-total[11] column-label 'ACE'
     with width 140 no-box down frame f-total stream-io.

/*---------------------------  Parƒmetros   ---------------------------*/

define input parameter raw-param as raw no-undo.
define input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

/* ***************************  Main Block  *************************** */
do on stop undo, leave:
   {include/i-rpcab.i}
   {include/i-rpout.i}
   view frame f-cabec.
   view frame f-rodape.

   run utp/ut-acomp.p persistent set h-acomp.  
   run pi-inicializar in h-acomp (input "Imprimindo...").

   for each ped-venda no-lock
      where (ped-venda.cod-sit-ped = 1
        and  ped-venda.cod-estabel = tt-param.cod-estabel
        and  ped-venda.cod-priori  = 10)
         or (ped-venda.cod-sit-ped = 2
        and  ped-venda.cod-estabel = tt-param.cod-estabel
        and  ped-venda.cod-priori  = 10),
      first natur-oper no-lock
         where natur-oper.nat-operacao = ped-venda.nat-operacao
           and natur-oper.atual-estat,
      first repres no-lock
         where repres.nome-abrev = ped-venda.no-ab-reppri,
      each ped-item of ped-venda no-lock
         where ped-item.dt-entrega  <= v_dt_fim_mes
           and ped-item.qt-log-aloc + ped-item.qt-alocada - ped-item.qt-atendida > 0:

      run pi-acompanhar in h-acomp (input "Pedido " + ped-venda.nr-pedcli).

      find first cotacao no-lock
         where cotacao.mo-codigo   = ped-venda.mo-codigo
           and cotacao.ano-periodo = string(year(today), "9999") + string(month(today), "99") no-error.
      if available (cotacao) and (cotacao.cotacao[day(today)] <> 0) then
         assign d-cotacao = cotacao.cotacao[day(today)].
      else
         assign d-cotacao = 1.
   
      find first tt-pedido exclusive-lock
         where tt-pedido.cod-rep = repres.cod-rep no-error.

      if not available tt-pedido then do:
         create tt-pedido.
         assign tt-pedido.cod-rep = repres.cod-rep.
      end.

      assign d-quantidade = ped-item.qt-log-aloca + ped-item.qt-alocada - ped-item.qt-atendida.

      assign tt-pedido.vl-merc[1]  = tt-pedido.vl-merc[1]  + ((if ped-item.cod-unid-neg = 'ADM' then (d-quantidade * ped-item.vl-preuni * d-cotacao) else 0))
             tt-pedido.vl-merc[2]  = tt-pedido.vl-merc[2]  + ((if ped-item.cod-unid-neg = 'CEN' then (d-quantidade * ped-item.vl-preuni * d-cotacao) else 0))
             tt-pedido.vl-merc[3]  = tt-pedido.vl-merc[3]  + ((if ped-item.cod-unid-neg = 'TER' then (d-quantidade * ped-item.vl-preuni * d-cotacao) else 0))
             tt-pedido.vl-merc[4]  = tt-pedido.vl-merc[4]  + ((if ped-item.cod-unid-neg = 'SEC' then (d-quantidade * ped-item.vl-preuni * d-cotacao) else 0))
             tt-pedido.vl-merc[5]  = tt-pedido.vl-merc[5]  + ((if ped-item.cod-unid-neg = 'NET' then (d-quantidade * ped-item.vl-preuni * d-cotacao) else 0))
             tt-pedido.vl-merc[6]  = tt-pedido.vl-merc[6]  + ((if ped-item.cod-unid-neg = 'COM' then (d-quantidade * ped-item.vl-preuni * d-cotacao) else 0))
             tt-pedido.vl-merc[7]  = tt-pedido.vl-merc[7]  + ((if ped-item.cod-unid-neg = 'MAX' then (d-quantidade * ped-item.vl-preuni * d-cotacao) else 0))
             tt-pedido.vl-merc[9]  = tt-pedido.vl-merc[9]  + ((if ped-item.cod-unid-neg = 'AUT' then (d-quantidade * ped-item.vl-preuni * d-cotacao) else 0))
             tt-pedido.vl-merc[10] = tt-pedido.vl-merc[10] + ((if ped-item.cod-unid-neg = 'FIR' then (d-quantidade * ped-item.vl-preuni * d-cotacao) else 0))
             tt-pedido.vl-merc[11] = tt-pedido.vl-merc[11] + ((if ped-item.cod-unid-neg = 'ACE' then (d-quantidade * ped-item.vl-preuni * d-cotacao) else 0))
             .
   end.

   /***** Sa¡da *****/
   for each tt-pedido no-lock:
      display
         tt-pedido.cod-rep
         tt-pedido.vl-merc[1]
         tt-pedido.vl-merc[2]
         tt-pedido.vl-merc[3]
         tt-pedido.vl-merc[4]
         tt-pedido.vl-merc[5]
         tt-pedido.vl-merc[6]
         tt-pedido.vl-merc[7]
         tt-pedido.vl-merc[8]
         tt-pedido.vl-merc[9]
         tt-pedido.vl-merc[10]
         tt-pedido.vl-merc[11]
         with frame f-pedido.
      down with frame f-pedido.

      assign de-total[1]  = de-total[1]  + tt-pedido.vl-merc[1]
             de-total[2]  = de-total[2]  + tt-pedido.vl-merc[2]
             de-total[3]  = de-total[3]  + tt-pedido.vl-merc[3]
             de-total[4]  = de-total[4]  + tt-pedido.vl-merc[4]
             de-total[5]  = de-total[5]  + tt-pedido.vl-merc[5]
             de-total[6]  = de-total[6]  + tt-pedido.vl-merc[6]
             de-total[7]  = de-total[7]  + tt-pedido.vl-merc[7]
             de-total[8]  = de-total[8]  + tt-pedido.vl-merc[8]
             de-total[9]  = de-total[9]  + tt-pedido.vl-merc[9]
             de-total[10] = de-total[10] + tt-pedido.vl-merc[10]
             de-total[11] = de-total[11] + tt-pedido.vl-merc[11].
   end.

   put skip(3).

   display
      de-total[1]
      de-total[2]
      de-total[3]
      de-total[4]
      de-total[5]
      de-total[6]
      de-total[7]
      de-total[8]
      de-total[9]
      de-total[10]
      de-total[11]
      with frame f-total.
   down with frame f-total.

   run pi-finalizar in h-acomp.
   {include/i-rpclo.i}
   return "OK".
end.
