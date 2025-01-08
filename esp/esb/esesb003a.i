/* Grava o XML com a registro correspondente a mensagem */
DATASET mensagem:WRITE-XML('longchar', oXML, no).

/* Conectar o WebServer - Barramento Pollux */
RUN esp/esb/esesb003a.p (INPUT  oXml, 
                         OUTPUT ixml).

/* Lˆ a resposta do barramento e devolve na temp-table resultado */
DATASET mensagemr:READ-XML('longchar', iXML, 'empty', ?, ?).
/*                                                                                                                */
/* define variable hDoc    as handle   no-undo.                                                                   */
/* create x-document hDoc.                                                                                        */
/* hDoc:LOAD("longchar", iXML, NO).                                                                               */
/* hDoc:SAVE("file",session:TEMP-DIRECTORY + "teste-iXML" + replace(STRING(TIME, "HH:MM:SS"), ":", "") + ".xml"). */
/*                                                                                                                */
/*                                                                                                                */
/* hDoc:LOAD("longchar", oXML, NO).                                                                               */
/* hDoc:SAVE("file",session:TEMP-DIRECTORY + "teste-oXML" + replace(STRING(TIME, "HH:MM:SS"), ":", "") + ".xml"). */
