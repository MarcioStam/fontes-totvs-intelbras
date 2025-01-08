/** Include da temp table **/
{soap/soap-xml.i}

/*******************************************************************************/
/** Procedures de callback para o SAX Reader a ser utilizado nos Web Services **/
/** Copiado e adaptado do DynaText por: Felipe Braun Azambuja                 **/
/** Data: 17.07.2006                                                          **/
/*******************************************************************************/

DEFINE VARIABLE currentFieldValue AS CHARACTER.

/** Denota o inicio de um elemento - zera a variavel que guarda o valor do campo **/
PROCEDURE StartElement:
    DEFINE INPUT PARAMETER namespaceURI AS CHARACTER.
    DEFINE INPUT PARAMETER localName    AS CHARACTER.
    DEFINE INPUT PARAMETER qName        AS CHARACTER.
    DEFINE INPUT PARAMETER attributes   AS HANDLE.

    currentFieldValue = "".
END.

/** Tratamento de um caractere - anexa aa variavel que guarda o valor do campo **/
PROCEDURE Characters:
    DEFINE INPUT PARAMETER charData AS MEMPTR.
    DEFINE INPUT PARAMETER numChars AS INTEGER.

    currentFieldValue = currentFieldValue + GET-STRING(charData, 1, GET-SIZE(charData)).
END.

/** Denota o fim de um elemento - grava o nome do campo e seu valor na tt **/
PROCEDURE EndElement:
    DEFINE INPUT PARAMETER namespaceURI AS CHARACTER.
    DEFINE INPUT PARAMETER localName    AS CHARACTER.
    DEFINE INPUT PARAMETER qName        AS CHARACTER.

    CREATE tt-xml.
    ASSIGN tt-xml.elementNS    = namespaceURI
           tt-xml.elementName  = localName
           tt-xml.elementValue = TRIM(LEFT-TRIM(currentFieldValue)).
    currentFieldValue = "".
END.

/** Erro no processamento, retorna erro **/
PROCEDURE FatalError:
    DEFINE INPUT PARAMETER errMessage AS CHARACTER.

    SELF:PRIVATE-DATA = "FATAL".
    RUN Cleanup.

    RETURN ERROR errMessage + "(Line " + CHR(SELF:LOCATOR-LINE-NUMBER) + ", Col " + CHR(SELF:LOCATOR-COLUMN-NUMBER) + ")".
END.

/** Limpa a tt **/
PROCEDURE Cleanup:
    EMPTY TEMP-TABLE tt-xml.
END.

/** Retorna a tt **/
PROCEDURE retorna-tt:
    DEFINE OUTPUT PARAMETER TABLE FOR tt-xml.
END.

