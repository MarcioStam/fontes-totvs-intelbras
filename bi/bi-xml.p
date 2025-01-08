/**
  * Include da temp table
  *
  **/
{bi/bi-xml.i}

/*******************************************************************************/
/** Procedures de callback para o SAX Reader a ser utilizado nos Web Services **/
/** Copiado e adaptado do DynaText por: Felipe Braun Azambuja                 **/
/** Data: 17.07.2006                                                          **/
/*******************************************************************************/

define variable currentFieldValue as character no-undo.

/** Denota o inicio de um elemento - zera a variavel que guarda o valor do campo **/
procedure StartElement:
    define input parameter namespaceURI as character.
    define input parameter localName    as character.
    define input parameter qName        as character.
    define input parameter attributes   as handle.

    assign currentFieldValue = "".
end procedure.

/** Tratamento de um caractere - anexa a variavel que guarda o valor do campo **/
procedure Characters:
    define input parameter charData as memptr.
    define input parameter numChars as integer.

    assign currentFieldValue = currentFieldValue + get-string(charData, 1, get-size(charData)).
end procedure.

/** Denota o fim de um elemento - grava o nome do campo e seu valor na tt **/
procedure EndElement:
    define input parameter namespaceURI as character.
    define input parameter localName    as character.
    define input parameter qName        as character.

    create tt-xml.
    assign tt-xml.elementNS    = namespaceURI
           tt-xml.elementName  = localName
           tt-xml.elementValue = trim(left-trim(currentFieldValue))
           currentFieldValue = "".
end procedure.

/** Erro no processamento, retorna erro **/
procedure FatalError:
    define input parameter errMessage as character.

    self:private-data = "FATAL".
    run Cleanup.

    return error errMessage + "(Line " + chr(self:locator-line-number) + ", Col " + chr(self:locator-column-number) + ")".
end procedure.

/** Limpa a tt **/
procedure Cleanup:
    empty temp-table tt-xml.
end procedure.

/** Retorna a tt **/
procedure retorna-tt:
    define output parameter table for tt-xml.
end procedure.
