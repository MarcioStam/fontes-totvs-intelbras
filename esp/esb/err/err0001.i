define temp-table cabecalho no-undo xml-node-name 'CABECALHO'
   field IdentidadeEmissor as character
   field NumeroOperacao    as character
   field CodigoMensagem    as character
   field LoginUsuario      as character.

define temp-table conteudo no-undo xml-node-name 'CONTEUDO'
   field idm as integer xml-node-type 'hidden'.

define temp-table cabecalhor no-undo xml-node-name 'CABECALHO' like cabecalho.

define temp-table conteudor no-undo xml-node-name 'CONTEUDO'
   field erro as character xml-node-name 'ERR0001'.
