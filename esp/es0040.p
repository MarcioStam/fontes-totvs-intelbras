define input parameter pTempTable as handle    no-undo.
define input parameter pEntidade  as character no-undo.
define input parameter pAcao      as logical   no-undo.
define input parameter pCaminho   as character no-undo.

define variable cDir          as character  no-undo.
define variable cOutput       as character  no-undo.
define variable cAcao         as character  no-undo.

define variable hQuery        as handle     no-undo.
define variable hField        as handle     no-undo.

define variable cBufferValue  as character  no-undo.
define variable i             as integer    no-undo.

define variable hXml          as handle     no-undo.
define variable hRoot         as handle     no-undo.
define variable xmlParam      as handle     no-undo.
define variable xmlText       as handle     no-undo.
define variable xmlRegistro   as handle     no-undo.

assign pCaminho = replace(pCaminho, "~\", "/").

if substring(pCaminho, length(pCaminho), 1) <> "/" then
  assign pCaminho = pCaminho + "/".
   
assign cOutput = pCaminho + pEntidade + '-' + replace(iso-date(now), ':', '') + '.xml'
       cAcao   = (if pAcao then 'write' else 'delete').

create x-document hXml.
create x-noderef  hRoot.
create x-noderef  xmlParam.
create x-noderef  xmlText.
create x-noderef  xmlRegistro.

create query hQuery.
hQuery:set-buffers(pTempTable).
hQuery:query-prepare("FOR EACH ":U + pTempTable:name + " EXCLUSIVE-LOCK":U).
hQuery:query-open.

do transaction on error undo, leave:
  hQuery:get-first.

  hXml:create-node(hRoot, 'tabela', "ELEMENT":U).
  hXml:append-child(hRoot).

  /** Percorre a temp-table **/
  do while not hQuery:query-off-end:

    hXml:create-node(xmlRegistro, 'registro', "ELEMENT":U).
    xmlRegistro:set-attribute('origem', pEntidade).
    xmlRegistro:set-attribute('acao', cAcao).
    hRoot:append-child(xmlRegistro).

    do i = 1 to pTempTable:num-fields:
      assign hField       = pTempTable:buffer-field(i)
         cBufferValue = "":U.

      /** Ignora esse campo **/
      if hField:data-type = "rowid":U then next.

      if hField:data-type = "character":U then do:
        if hField:buffer-value <> ? then
          assign cBufferValue = trim(string(replace(hField:buffer-value, chr(13), chr(32))))
             cBufferValue = trim(string(replace(cBufferValue, chr(10), chr(32))))
             cBufferValue = trim(string(replace(cBufferValue, "'":U, "`":U))).
      end.
      else do:
        if hField:data-type = "decimal" then do:
          if hField:buffer-value <> ? then
          assign cBufferValue = trim(string(hField:buffer-value, hField:format)).
        end.
        else do:
          assign cBufferValue = trim(string(hField:buffer-value)).

          if hField:data-type = "date":U then do:
            if hField:buffer-value <> ? then do:
              if hField:buffer-value <= 01/01/1900 then
                assign cBufferValue = "1900-01-01":U.
              else do:
                if hField:buffer-value >= 12/31/2999 then
                  assign cBufferValue = "2999-12-31":U.
                else
                  assign cBufferValue = string(year(hField:buffer-value), "9999":U) + "-":U + string(month(hField:buffer-value), "99":U) + "-":U + string(day(hField:buffer-value), "99":U).
              end.
            end.
          end.

          if hField:data-type = "logical":U then do:
            if hField:buffer-value = ?  or
               hField:buffer-value = no then
              assign cBufferValue = "0":U.
            else
              assign cBufferValue = "1":U.
          end.
        end.

        if hField:data-type = "decimal":U or
           hField:data-type = "integer":U then
          assign cBufferValue = replace(cBufferValue, ".":U, "":U)
                 cBufferValue = replace(cBufferValue, ",":U, ".":U).
      end.

      hXml:create-node(xmlParam, 'campo', "ELEMENT":U).
      hXml:create-node(xmlText, ?, "TEXT":U).

      xmlText:node-value = cBufferValue no-error.
      xmlParam:append-child(xmlText).

      xmlParam:set-attribute('origem', hField:name).

      /*hRoot:append-child(xmlParam).*/
      xmlRegistro:append-child(xmlParam).

    end.

    hQuery:get-next.
  end.
end.

hQuery:query-close.
delete object hQuery.

hXml:save("file":U, cOutput).

delete object xmlText.
delete object xmlParam.
delete object xmlRegistro.
delete object hRoot.
delete object hXml.

return "OK":U.
