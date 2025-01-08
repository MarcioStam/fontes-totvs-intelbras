create widget-pool.

define input  parameter requisicao  as longchar no-undo.
define output parameter resposta    as longchar no-undo.

{esp/esb/esesb000.i}

define dataset mensagem for cabecalho.
define variable cMensagem as character no-undo.

if requisicao <> ? then do:
   dataset mensagem:read-xml('longchar', requisicao, 'empty', ?, ?) no-error.
   find cabecalho no-error.
   if available cabecalho then
      assign cMensagem = trim(lc(cabecalho.CodigoMensagem)).

   IF OPSYS = "UNIX" THEN log-manager:write-message("Eckel1 " + cMensagem).
   IF OPSYS = "UNIX" THEN log-manager:write-message("Eckel2 " + cMensagem).
   IF OPSYS = "UNIX" THEN log-manager:write-message(string(search('esp/esb/in/' + cMensagem + '.r'))).

   if cMensagem <> ? and cMensagem <> '' then do:
      if search('esp/esb/in/' + cMensagem + '.p') <> ? or search('esp/esb/in/' + cMensagem + '.r') <> ? then
         run value('esp/esb/in/' + cMensagem + '.p') (input requisicao, output resposta).
      else do:
         run esp/esb/err/err0001.p (input table cabecalho, input substitute('Mensagem de entrada &1 n∆o encontrada', cMensagem), output resposta).
         return 'false'.
      end.
   end.
   else do:
      run esp/esb/err/err0001.p (input table cabecalho, input 'Mensagem de entrada n∆o especificada', output resposta).
      return 'false'.
   end.
end.
else do:
   run esp/esb/err/err0001.p (input table cabecalho, input 'Mensagem de entrada vazia', output resposta).
   return 'false'.
end.

return 'true'.
