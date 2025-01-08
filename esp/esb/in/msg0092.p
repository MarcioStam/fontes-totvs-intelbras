create widget-pool.

DEFINE INPUT  PARAMETER iXML AS LONGCHAR NO-UNDO.
DEFINE OUTPUT PARAMETER oXML AS LONGCHAR NO-UNDO.


IF OPSYS = "UNIX" THEN log-manager:write-message("LOG 92 ").

define variable bo-ped-venda  as handle   no-undo.

{method/dbotterr.i}
{esp/esb/in/msg0092.i}

define dataset mensagem for cabecalho, conteudo, msg0092
   data-relation for conteudo, msg0092 relation-fields (idm, idm) nested.

dataset mensagem:read-xml('longchar', iXML, 'empty', ?, ?).

define dataset mensagemr xml-node-name 'MENSAGEM' for cabecalhor, conteudor, msg0092r, resultado
   data-relation for conteudor, msg0092r  relation-fields (idm, idm) nested
   data-relation for msg0092r, resultado relation-fields (idm, idm) nested.

find msg0092.
find cabecalho.

create cabecalhor.
create conteudor.
create resultado.
create msg0092r.

IF OPSYS = "UNIX" THEN log-manager:write-message("LOG 92-2 ").

buffer-copy cabecalho EXCEPT IdentidadeEmissor to cabecalhor.           
assign cabecalhor.CodigoMensagem = 'MSG0092R1'
       cabecalhor.IdentidadeEmissor = "64546C2E-6DAB-4311-A74A-5ACA96134AFF".

if not valid-handle(bo-ped-venda) then
    run dibo/bodi159.p persistent set bo-ped-venda.

IF OPSYS = "UNIX" THEN log-manager:write-message("LOG 92-3 ").

find first ped-venda exclusive-lock
    where ped-venda.nr-pedido = msg0092.NumeroPedido no-error.

IF AVAIL ped-venda THEN DO:

    IF OPSYS = "UNIX" THEN log-manager:write-message("LOG AVAIL ped-venda " + STRING(AVAIL ped-venda)).
    
    RUN openQueryStatic IN bo-ped-venda (INPUT "Main"). 
    
    IF OPSYS = "UNIX" THEN log-manager:write-message("LOG RETURN openQueryStatic " + RETURN-VALUE).
    
    run goToKey         in bo-ped-venda (input ped-venda.nome-abrev,
                                         INPUT ped-venda.nr-pedcli).
    
    IF OPSYS = "UNIX" THEN log-manager:write-message("LOG RETURN goToKey " + RETURN-VALUE).
    
    run emptyRowErrors  in bo-ped-venda.
    run setUserLog      in bo-ped-venda (input cabecalho.LoginUsuario).
    
    IF OPSYS = "UNIX" THEN log-manager:write-message("LOG RETURN setUserLog " + RETURN-VALUE).
    
    run deleteRecord    in bo-ped-venda.
    
    IF OPSYS = "UNIX" THEN log-manager:write-message("LOG RETURN deleteRecord " + RETURN-VALUE).
    
    run getRowErrors    in bo-ped-venda (output table RowErrors).
    
    IF OPSYS = "UNIX" THEN log-manager:write-message("CAN-FIND rowerrors " + STRING(CAN-FIND (first RowErrors))).

END.
ELSE DO:
     assign resultado.Sucesso    = no
            resultado.CodigoErro = 17006
            resultado.Mensagem   = "Pedido n∆o encontrado".
END.

find first RowErrors
     where RowErrors.ErrorType <> "INTERNAL" no-error.

if avail RowErrors then do:
    assign resultado.Sucesso    = no
           resultado.CodigoErro = RowErrors.ErrorNumber
           resultado.Mensagem   = RowErrors.ErrorDescription.
end.

delete procedure bo-ped-venda.
assign bo-ped-venda = ?.

dataset mensagemr:write-xml('longchar', oXML, no).

return.

