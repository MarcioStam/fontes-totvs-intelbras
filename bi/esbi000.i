/*----------------------------------------------------------------------
**  Programa..: bi/esbi000.i
**  Autor.....: Felipe Braun Azambuja
**  Data......: Outubro/2010 - C¢pia da Datasul
**  Descricao.: Gera‡Æo de arquivos texto para BI
-----------------------------------------------------------------------*/

create widget-pool.

define variable c-param-file as character no-undo.
define variable c-diretorio  as character no-undo.

define stream s-saida.
define stream s-err.

define temp-table tt-erro no-undo
   field texto as character format 'x(60)'.

/**
 * Cria registro de inconsistˆncia
 */
procedure createError:
   define input parameter pDescricao as character no-undo.

   create tt-erro.
   assign tt-erro.texto = pDescricao.
end procedure.

/**
 * Gera arquivo com as inconsistˆncias encontradas
 */
procedure createInc:
   define input parameter pFile as character no-undo.

   define variable i-qtd as integer no-undo.
   
   if can-find (first tt-erro) then do:
      output stream s-err to value (c-diretorio + '/INC_' + pFile + '.txt') convert target 'iso8859-1'.

      for each tt-erro:
         assign i-qtd = i-qtd + 1.
         put stream s-err unformatted i-qtd ' - ' tt-erro.texto skip.
      end.

      output stream s-err close.
   end.

end procedure.

/**
 * Gera o arquivo final, separado por TAB
 */
procedure createTxt:
   define input parameter pTempTable as handle    no-undo.
   define input parameter pFile      as character no-undo.

   define variable hQuery        as handle      no-undo.
   define variable hField        as handle      no-undo.
   define variable cData         as character   no-undo.
   define variable cBufferValue  as character   no-undo.
   define variable i             as integer     no-undo.

   create query hQuery.
   hQuery:set-buffers(pTempTable).
   hQuery:query-prepare('FOR EACH ' + pTempTable:name + ' EXCLUSIVE-LOCK').
   hQuery:query-open.

   do transaction on error undo, leave:
      hQuery:get-first.

      output stream s-saida to value(c-diretorio + '/' + pFile + '.txt') convert target 'iso8859-1'.

      /** Cria a linha com os nomes dos campos **/
      do i = 1 to pTempTable:num-fields:
         assign hField = pTempTable:buffer-field(i).

         /** Ignora esse campo **/
         if (hField:name = 'idi-tip-movto-inctral') or (hField:name = 'idi-tip-movto-incrtal') then
            next.

         assign cData = cData + string(hField:name).
         
         if (i < pTempTable:num-fields) then
            assign cData = cData + chr(9).
      end.

      if (cData <> '') then
         put stream s-saida unformatted cData skip.

      /** Percorre a temp-table **/
      do while not hQuery:query-off-end:
         assign cData = ''.
         
         do i = 1 to pTempTable:num-fields:
            assign hField       = pTempTable:buffer-field(i)
                   cBufferValue = ''.
            
            /** Ignora esse campo **/
            if (hField:name = 'idi-tip-movto-inctral') or (hField:name = 'idi-tip-movto-incrtal') then
               next.

            if (hField:data-type = 'character') then do:
               if (hField:buffer-value <> ?) then
                  /** Remove ENTER e TAB **/
                  assign cBufferValue = replace(replace(replace(hField:buffer-value, chr(13), chr(32)), chr(10), chr(32)), chr(9), chr(32))
                         cData        = cData + trim(cBufferValue).
            end.
            else do:
               assign cBufferValue = string(hField:buffer-value).

               if (hField:data-type = 'datetime-tz') and (hField:buffer-value <> ?) then
                  assign cBufferValue = replace(cBufferValue, ',', '.')
                         overlay(cBufferValue, 1, 10) = string(year(hField:buffer-value), '9999') + '-' + 
                                                        string(month(hField:buffer-value), '99') + '-' +
                                                        string(day(hField:buffer-value), '99').

               if (hField:data-type = 'date') then
                  if ((hField:buffer-value = ?) or (string(hField:buffer-value) = '31/12/-4714')) then
                     assign cBufferValue = ''.
                  else
                     assign cBufferValue = string(hField:buffer-value, '99/99/9999').

               if (hField:data-type = 'logical') and (hField:buffer-value = ?) then
                  assign cBufferValue = 'no'.

               if (hField:buffer-value = ?) then
                  assign cBufferValue = ''.

               assign cData = cData + cBufferValue.
            end.

            if (i < pTempTable:num-fields) then
               assign cData = cData + chr(9).
         end.

         if (cData <> '') then
            put stream s-saida unformatted cData skip.

         hQuery:get-next.
      end.

      output stream s-saida close.
   end.

   hQuery:query-close.
   delete object hQuery.

   return 'ok'.
end procedure.
