/**
 * Extrator para BI
 * Fato: Hist¢rico de monitoramento dos pedidos de venda
 *
 * Autor: Anderson Hoepers - 12/06/2013
 */

create widget-pool.

{include/i-freeac.i}

/** Include com a temp table principal e a temp table de parƒmetros **/
{bi/fact021tt.i}
{bi/esbi000.i}

define input  parameter table for tt-param.
define output parameter table for ttHistoricoEventos.
define output parameter table for tt-erro.

define variable dt-inicial       as date        no-undo.
define variable dt-final         as date        no-undo.

DEFINE VARIABLE dt-ini AS DATETIME-TZ NO-UNDO.
DEFINE VARIABLE dt-fim AS DATETIME-TZ NO-UNDO.

/************************************************************************/

EMPTY TEMP-TABLE ttHistoricoEventos.

find first tt-param NO-ERROR.

assign dt-inicial = date(month(tt-param.dt-inicial), 1, year(tt-param.dt-inicial))
       dt-final   = date(month(tt-param.dt-final), 1, year(tt-param.dt-final))
       dt-inicial = add-interval(dt-inicial, 1, 'months') - 1
       dt-final   = add-interval(dt-final,   1, 'months') - 1.

/** Gambi **/
if dt-final > today then
   assign dt-final = today.

ASSIGN dt-ini = DATETIME(month(dt-inicial), 
                         day(dt-inicial),
                         year(dt-inicial),
                         0,  /* hora */
                         0,  /* minutos */
                         0,  /* segundos */
                         0)  /* milisegundos */

       dt-fim = DATETIME(month(dt-final), 
                         day(dt-final),
                         year(dt-final),
                         23,  /* hora */
                         59,  /* minutos */
                         59,  /* segundos */
                         999)  /* milisegundos */.

RUN pi-le-historico.

PROCEDURE pi-le-historico:

    FOR EACH  int-historico-evento NO-LOCK
        WHERE int-historico-evento.dat-historico >= dt-ini
          AND int-historico-evento.dat-historico <= dt-fim:

        CREATE ttHistoricoEventos.
        ASSIGN ttHistoricoEventos.CD_Sequencia_Historico = int-historico-evento.num-seq-historico  
               ttHistoricoEventos.CD_Evento_Monitorado   = int-historico-evento.cod-evento
               ttHistoricoEventos.CD_Estabelecimento     = fn-free-accent(upper(trim(int-historico-evento.cod-estabel)))       
               ttHistoricoEventos.CD_Emitente            = int-historico-evento.cod-emitente       
               ttHistoricoEventos.CD_Pedido_Cliente      = int-historico-evento.nr-pedcli          
               ttHistoricoEventos.CD_Sequencia           = int-historico-evento.nr-sequencia       
               ttHistoricoEventos.CD_Item                = fn-free-accent(upper(trim(int-historico-evento.it-codigo)))  
               ttHistoricoEventos.CD_Situacao_Pedido     = int-historico-evento.cod-sit-ped        
               ttHistoricoEventos.CD_Situacao_Item       = int-historico-evento.cod-sit-item       
               ttHistoricoEventos.CD_Usuario             = int-historico-evento.cod-usuario        
               ttHistoricoEventos.CD_Situacao_Preco_Min  = int-historico-evento.ind-status-preco   
               ttHistoricoEventos.CD_Situacao_Credito    = int-historico-evento.cod-sit-aval       
               ttHistoricoEventos.CD_Motivo_Cancelamento = int-historico-evento.cod-motivo-cancela 
               ttHistoricoEventos.DT_Movimento_Historico = int-historico-evento.dat-historico      
               ttHistoricoEventos.NM_Qtd_Alocada_Pedido  = int-historico-evento.qtd-alocada-pedido.
    END. /* FOR EACH  int-historico-evento NO-LOCK */

END PROCEDURE.


RETURN "ok".
