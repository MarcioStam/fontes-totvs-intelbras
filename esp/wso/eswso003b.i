/* Grava o XML com a registro correspondente a mensagem */
DATASET mensagem:WRITE-XML('longchar', oXML, YES).

/* Conectar o WebServer - Barramento Pollux */
RUN esp/wso/eswso003b.p (INPUT  p-transacao,
                         INPUT  oXml, 
                         OUTPUT resposta).


/*-------------------------------------------------------------------------*/
/* ATENÄ«O: A "resposta" vem em campo char, separdo por v°gulas            */
/* n∆o ser† tratada por enquanto.  a primeira entry do campo Ç Ok ou ERRO. */
/* a segunda Ç a mensagem descrevendo o erro                               */
/* Ex:  "Ok;Mensagem disponibilizada no barramento"                        */
/*-------------------------------------------------------------------------*/
/*
MESSAGE resposta VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
*/
/*
define variable hDoc    as handle   no-undo.                                                                   
create x-document hDoc.                                                                                        
hDoc:LOAD("longchar", oXML, NO).                                                                              
hDoc:SAVE("file",session:TEMP-DIRECTORY + "teste-oXML" + STRING(TIME) + ".xml").
*/

