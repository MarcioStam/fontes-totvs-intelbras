/*
fc-get-object-handle (p-wgh-frame,
                     TRUE,
                     TRUE,
                     "", // nome objeto
                     "", // tipo objeto
                     "").
                     
fc-event-log-interface(INPUT p-ind-event  ,
                       INPUT p-ind-object ,
                       INPUT p-wgh-object ,
                       INPUT p-wgh-frame  ,
                       INPUT p-cod-table  ,
                       INPUT p-row-table  ,
                       INPUT ""  ).

*/



function fc-get-object-handle returns handle (p-fc-wh-frame as handle, /* objeto              */                                 
                                         l-log          as logical      , /* visualiza mensagem  */                                 
                                         l-tooltip      as logical      , /* alterar tooltip     */                                 
                                         c-campo        as character    , /* objeto ser buscado  */ /* obrigat½rio               */ 
                                         c-tipo         as character    , /* tipo do objeto      */ /* obrigat½rio               */ 
                                         c-pagina       as character    ) /* frame (opcional - pode passar '') */ 
                                         forward.

FUNCTION fc-event-log-interface RETURNS LOGICAL ( INPUT p-ind-event  AS CHARACTER,
                                                  INPUT p-ind-object AS CHARACTER,
                                                  INPUT p-wgh-object AS HANDLE,
                                                  INPUT p-wgh-frame  AS WIDGET-HANDLE,
                                                  INPUT p-cod-table  AS CHARACTER,
                                                  INPUT p-row-table  AS ROWID,
                                                  INPUT p-mensagem   AS CHARACTER) FORWARD.

function fc-get-object-handle returns handle (p-fc-wh-frame as handle, 
                                         l-log          as logical      , 
                                         l-tooltip      as logical      , 
                                         c-campo        as character    , 
                                         c-tipo         as character    , 
                                         c-pagina       as character    ):

  define variable wh-objeto-recursivo as handle    no-undo.
  define variable wh-objeto           as handle    no-undo.
  define variable wh-frame            as handle    no-undo.
  define variable c-format            as character no-undo.
  define variable c-data-type         as character no-undo.
  
  assign wh-objeto = p-fc-wh-frame:first-child no-error.

  do while valid-handle(wh-objeto):

     if  wh-objeto:type = 'field-group' then do:
         assign wh-objeto-recursivo = fc-get-object-handle(wh-objeto, l-log, l-tooltip, c-campo, c-tipo, c-pagina).
         if  valid-handle(wh-objeto-recursivo) then do:
             return wh-objeto-recursivo.
         end.
     end.
     if  wh-objeto:type = 'frame' then do:
         assign wh-objeto-recursivo = fc-get-object-handle(wh-objeto, l-log, l-tooltip, c-campo, c-tipo, c-pagina).
         if  valid-handle(wh-objeto-recursivo) then do:
             return wh-objeto-recursivo.
         end.
     end.
     if  wh-objeto:type = 'window' then do:
         assign wh-objeto-recursivo = fc-get-object-handle(wh-objeto, l-log, l-tooltip, c-campo, c-tipo, c-pagina).
         if  valid-handle(wh-objeto-recursivo) then do:
             return wh-objeto-recursivo.
         end.
     end.
  
     if  valid-handle(wh-objeto) then do:
         if  l-log /*and wh-objeto:name = 'ind-fat-par' or wh-objeto:name = 'ind-fat-par-001'*/ then do:
             if  (c-campo  = '' and c-tipo  = '' and c-pagina  = '') or
                 (c-campo <> '' and c-tipo <> '' and c-pagina <> '' and wh-objeto:name = c-campo and wh-objeto:type = c-tipo and wh-objeto:frame:name = c-pagina) or
                 (c-campo <> '' and c-tipo  = '' and c-pagina  = '' and wh-objeto:name = c-campo) or
                 (c-campo  = '' and c-tipo <> '' and c-pagina  = '' and wh-objeto:type = c-tipo)  or 
                 (c-campo  = '' and c-tipo  = '' and c-pagina <> '' and wh-objeto:frame:name = c-pagina) then do:
                 output to c:\temp\upc_detalhe.txt no-convert append.
                 put unformatted
                     'nome         = ' wh-objeto:name               skip
                     'Tipo         = ' wh-objeto:type               skip
                     'Linha        = ' wh-objeto:row                skip
                     'Coluna       = ' wh-objeto:col                skip
                     'Altura       = ' wh-objeto:height             skip
                     'Largura      = ' wh-objeto:width              skip
                     'Tipo-inf     = ' wh-objeto:data-type          skip
                     'Tooltip      = ' wh-objeto:tooltip            skip
                     'Frame:name   = ' wh-objeto:frame:name         skip
                     'p-ind-event  = ' p-ind-event                  skip
                     'p-ind-object = ' p-ind-object                 skip
                     'p-cod-table  = ' p-cod-table                  skip
                     'p-row-table  = ' STRING(p-row-table)          skip
                     '--------------------------------------------' skip.
                 output close.
             end.
         end.

         if  l-tooltip = yes then do:
             assign wh-objeto:tooltip = ':Name........ = '   + string(wh-objeto:name)      + chr(13)
                                      + ':Type......... = '  + string(wh-objeto:type)      + chr(13) 
                                      + ':Row.......... = '  + string(wh-objeto:row)       + chr(13)
                                      + ':Col........... = ' + string(wh-objeto:col)       + chr(13)
                                      + ':Height....... = '  + string(wh-objeto:height)    + chr(13)
                                      + ':Width........ = '  + string(wh-objeto:width)     + chr(13)
                                      + ':Frame:name. = '    + string(wh-objeto:frame:name) 
                                      no-error.
         end.
                      
         if  wh-objeto:name = c-campo and
             wh-objeto:type = c-tipo  and
            (c-pagina = '' or wh-objeto:frame:name = c-pagina) then do:
             return wh-objeto.
             
             
         end.
     end.
     assign wh-objeto = wh-objeto:next-sibling no-error.
  end.

  return ?.
end.

FUNCTION fc-event-log-interface RETURNS LOGICAL ( INPUT p-ind-event  AS CHARACTER,
                                                  INPUT p-ind-object AS CHARACTER,
                                                  INPUT p-wgh-object AS HANDLE,
                                                  INPUT p-wgh-frame  AS WIDGET-HANDLE,
                                                  INPUT p-cod-table  AS CHARACTER,
                                                  INPUT p-row-table  AS ROWID,
                                                  INPUT p-mensagem   AS CHARACTER):
  DEFINE VARIABLE retVal AS LOGICAL NO-UNDO.
  OUTPUT TO c:\temp\upc_eventos.txt NO-CONVERT APPEND.
  PUT UNFORMATTED
      'p-ind-event       = ' STRING(p-ind-event)          SKIP
      'p-ind-object      = ' STRING(p-ind-object)         SKIP
      'p-wgh-object:name = ' STRING(p-wgh-object:name)    SKIP
      'p-wgh-frame:name  = ' STRING(p-wgh-frame:name)     SKIP
      'p-cod-table       = ' STRING(p-cod-table)          SKIP
      'p-row-table       = ' STRING(p-row-table)          SKIP
      'p-mensagem        = ' p-mensagem                   SKIP
      '--------------------------------------------' SKIP.
  OUTPUT CLOSE.
  RETURN retVal.
END FUNCTION.
