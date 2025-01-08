/**
 * Extrator para GESPLAN
 * Fato: Extrator do cadastro de itens
 *
 * Autor: Anderson Hoepers - 11/02/2016
 */
 
create widget-pool.

&scoped-define TEMP_TABLE  ttHierarquiaItem
&scoped-define ARQUIVO_TXT PlanHierarquiaItem
&scoped-define EXTRATOR    plan005

{bi/esbi000.i}

/**
 * Leitura do XML
 */
define variable c-xml as character no-undo.
assign c-xml = entry(2,session:parameter).
file-info:file-name = c-xml.
if (index(file-info:file-type, 'f') = 0) then
   leave.
{bi/esbi001.i c-xml}

/** Valida diret¢rio de sa°da **/
assign c-diretorio = getTag("diretorio").
file-info:file-name = c-diretorio.
if (index(file-info:file-type, 'd') = 0) or (c-diretorio = "") then
   leave.

define variable dt-inicial as date no-undo.
define variable dt-final   as date no-undo.

define variable c-periodo-ini  as character no-undo.
define variable c-periodo-fim  as character no-undo.
define variable dt-periodo-ini as date      no-undo.
define variable dt-periodo-fim as date      no-undo.
define variable i-periodos-ini as integer   no-undo.
define variable i-periodos-fim as integer   no-undo.

if integer(getTag("tipoPeriodo")) = 1 then
   assign dt-inicial = date(getTag("dataInicio"))
          dt-final   = date(getTag("dataTermino"))
          dt-inicial = date(month(dt-inicial), 1, year(dt-inicial))
          dt-final   = date(month(dt-final),   1, year(dt-final)).
else
   assign dt-inicial     = date(month(today), 1, year(today))
          dt-final       = date(month(today), 1, year(today))
          i-periodos-ini = integer(getTag("periodoInicio"))
          i-periodos-fim = integer(getTag("periodoTermino"))
          dt-inicial     = add-interval(dt-inicial, i-periodos-ini, 'months')
          dt-final       = add-interval(dt-final, i-periodos-fim, 'months').

/** Usu†rio e senha para login no EMS **/
define variable c-usuario as character no-undo.
define variable c-senha   as character no-undo.

assign c-usuario = getTag("usuarioEMS")
       c-senha   = getTag("senhaEMS").

/** Modo de execuá∆o **/
define variable c-modo as character no-undo.
define variable l-rpc  as logical   no-undo.
define variable cHost  as character no-undo.
define variable cPort  as character no-undo.
define variable cName  as character no-undo.

assign c-modo = getTag('modoExecucao').
if (c-modo = 'remoto') or (c-modo = 'rpc') then do:
   assign l-rpc = yes
          cHost = getTag('appServerHost')
          cPort = getTag('appServerPort')
          cName = getTag('appServerName').
end.
else
   assign l-rpc = no.

/**
 * Regra de neg¢cio a partir daqui
 */
{bi/{&EXTRATOR}tt.i}

create tt-param.
assign tt-param.usuario    = c-usuario
       tt-param.senha      = c-senha
       tt-param.dt-inicial = dt-inicial
       tt-param.dt-final   = dt-final.

/** Conex∆o com o EMS para a execuá∆o de BO **/
run bi/esbi002.p (tt-param.usuario, tt-param.senha).

log-manager:write-message('Indo executar. RPC? ' + string(l-rpc)) no-error.

if (l-rpc) then do:
   /** Conecta no AppServer **/
   define variable hAppServer as handle no-undo.

   create server hAppServer.
   hAppServer:connect('-AppService ' + cName + ' -H ' + cHost + ' -S ' + cPort) no-error.

   /** Se conseguiu conectar, tenta executar o extrator por l† **/
   if (not error-status:error) and (hAppServer:connected()) then do:
      log-manager:write-message('RPC: connected') no-error.
      run bi/{&EXTRATOR}rp.p on server hAppServer (input table tt-param, output table {&TEMP_TABLE}, output table tt-erro) no-error.
   
      /** Desconecta do AppServer **/
      if (valid-handle(hAppServer)) and (hAppServer:connected()) then
         hAppServer:disconnect().
   
      /** Remove handle **/
      if (valid-handle(hAppServer)) then
         delete object hAppServer.
   end.
   else do:
      log-manager:write-message('RPC: not connected') no-error.
      run bi/{&EXTRATOR}rp.p (input table tt-param, output table {&TEMP_TABLE}, output table tt-erro) no-error.
   end.
end.
/** Caso online... **/
else do:
   log-manager:write-message('Execuá∆o online') no-error.

   run bi/{&EXTRATOR}rp.p (input table tt-param, output table {&TEMP_TABLE}, output table tt-erro) no-error.
end.

log-manager:write-message('Criando arquivo txt') no-error.
run createInc("{&ARQUIVO_TXT}").
run createTxt(input buffer {&TEMP_TABLE}:handle, "{&ARQUIVO_TXT}").
