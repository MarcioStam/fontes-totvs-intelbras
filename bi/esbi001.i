/**
 * Leitura do XML de parƒmetro
 *
 * Autor: Felipe Braun Azambuja
 */

{bi/bi-xml.i}

define variable hParser  as handle no-undo.
define variable hHandler as handle no-undo.

create sax-reader hParser.

run bi/bi-xml.p persistent set hHandler.

hParser:handler = hHandler.
hParser:set-input-source("file", {1}).
hParser:sax-parse() no-error.

run retorna-tt in hHandler (output table tt-xml).
run Cleanup    in hHandler.

/** Apaga da memoria o objeto e procedure do SAX **/
delete object hParser.
delete procedure hHandler.

function getTag returns character (input pTag as character):
   for each tt-xml
      where tt-xml.elementName = pTag:
      return tt-xml.elementValue.
   end.
   return "".
end.
