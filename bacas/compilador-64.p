define input parameter pFonte as character no-undo.
define input parameter pDestino as character no-undo.
define output parameter pErro as character no-undo.

log-manager:write-message('Fonte: ' + pFonte, 'DEBUG') no-error.
log-manager:write-message('Destino: ' + pDestino, 'DEBUG') no-error.

define variable i as integer no-undo.
define variable pFonteTMP as character no-undo.

file-info:file-name = pFonte.
if file-info:file-type = ? then do:
   assign pErro = 'Fonte n∆o encontrado'.
   return 'NOK'.
end.

file-info:file-name = pDestino.
if file-info:file-type = ? then do:
   assign pErro = 'Diret¢rio de destino n∆o encontrado'.
   return 'NOK'.
end.
else if file-info:file-type begins 'D' then do:
   if index(file-info:file-type, 'W') > 0 then do:
      compile value (pFonte) save into value ("/tmp/") no-error.
      
      if compiler:error then do:
         do i = 1 to compiler:num-messages:
            if compiler:get-message(i) begins 'WARNING' then
               next.
            assign pErro = pErro + compiler:get-message(i) + '~r~n'.
         end.
         
         if pErro <> '' then do:
            assign pErro = 'Erro na compilaá∆o:~r~n' + pErro.
            return 'NOK'.
         end.
      end.
      else do:
          
          ASSIGN pFonteTMP = "/tmp/" + ENTRY(num-entries(pFonte,"/"),pFonte,"/")
		         pFonteTMP = REPLACE(pFonteTMP,".p",".r")
		  		 pFonteTMP = REPLACE(pFonteTMP,".w",".r")
		 		 pFonteTMP = REPLACE(pFonteTMP,".py",".r")
				 pFonteTMP = REPLACE(pFonteTMP,"fontes/","").
          
          OS-COPY VALUE(pFonteTMP) VALUE(pDestino + "/").
          OS-DELETE VALUE(pFonteTMP).	

      END.

	  /*  
	  output to "/opt/totvs/programas/intelbras/liberacoes/totvs11/log3.txt".
	  put pFonte    format "x(100)" space(2)
	      pFonteTMP format "x(100)" space(2)
	      pDestino  format "x(100)" skip.
	  output close.
	  */
  	  
   end.
   else do:
      assign pErro = 'Diret¢rio sem permiss∆o de escrita'.
      return 'NOK'.
   end.
end.
else do:
   assign pErro = 'Destino n∆o Ç um diret¢rio'.
   return 'NOK'.
end.

return 'OK'.
