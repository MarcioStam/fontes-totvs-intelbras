create widget-pool.

{esp/esb/err/err0001.i}

define input  parameter table for cabecalho.
define input  parameter pErro as character no-undo.
define output parameter oXML  as longchar  no-undo.

define dataset mensagemr xml-node-name 'MENSAGEM' for cabecalhor, conteudor.

create cabecalhor.
find cabecalho no-error.
if available cabecalho then
   buffer-copy cabecalho to cabecalhor.
assign cabecalhor.CodigoMensagem = 'ERR0001'
       cabecalhor.IdentidadeEmissor = '64546C2E-6DAB-4311-A74A-5ACA96134AFF'
       cabecalhor.NumeroOperacao    = 'ERR0001'.

create conteudor.
assign conteudor.erro = pErro.

dataset mensagemr:write-xml('longchar', oXML, no).

return.
