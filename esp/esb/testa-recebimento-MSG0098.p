
DEF VAR xml-entrada AS LONGCHAR.                                         
DEF VAR xml-saida AS LONGCHAR.

/*
define variable hDoc    as handle   no-undo.                                             
create x-document hDoc.                                                                  
hDoc:LOAD("longchar", xml-entrada, NO).                                                   
hDoc:SAVE("file","C:/temp/roger-" + replace(STRING(TIME, "HH:MM:SS"), ":", "") + ".xml").
*/                                                                                         

ASSIGN xml-entrada = '<?xml version="1.0" encoding="utf-8"?><MENSAGEM xmlns="urn:teste.org">
 <CABECALHO>
  <IdentidadeEmissor>64546C2E-6DAB-4311-A74A-5ACA96134AFF</IdentidadeEmissor>
  <NumeroOperacao>88117010</NumeroOperacao>
  <CodigoMensagem>MSG0098</CodigoMensagem>
 </CABECALHO>
 <CONTEUDO>
  <MSG0098>
    <ClienteItem>
        <CodigoConta>595ACD72-73A2-E011-B5C2-00155DA09701</CodigoConta>
    </ClienteItem>
    <ClienteItem>
        <CodigoConta>595ACD72-73A2-E011-B5C2-00155DA09701</CodigoConta>
    </ClienteItem>
  </MSG0098>
 </CONTEUDO>
</MENSAGEM>'.


RUN esp/esb/in/msg0098.p (INPUT  xml-entrada,
                          OUTPUT xml-saida).


define variable hDoc    as handle   no-undo.
create x-document hDoc.
hDoc:LOAD("longchar", xml-saida, NO).
hDoc:SAVE("file","C:/temp/xml-saida" + replace(STRING(TIME, "HH:MM:SS"), ":", "") + ".xml").

