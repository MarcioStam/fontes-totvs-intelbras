
DEF VAR xml-entrada AS LONGCHAR.                                         
DEF VAR xml-saida AS LONGCHAR.

/*
define variable hDoc    as handle   no-undo.                                             
create x-document hDoc.                                                                  
hDoc:LOAD("longchar", xml-entrada, NO).                                                   
hDoc:SAVE("file","C:/temp/roger-" + replace(STRING(TIME, "HH:MM:SS"), ":", "") + ".xml").
*/       

DO TRANS:
    ASSIGN xml-entrada = '<?xml version="1.0" encoding="utf-8"?>
     <MENSAGEM xmlns="urn:teste.org">
     <CABECALHO>
      <IdentidadeEmissor>64546C2E-6DAB-4311-A74A-5ACA96134AFF</IdentidadeEmissor>
      <NumeroOperacao>88117010</NumeroOperacao>
      <CodigoMensagem>MSG0016</CodigoMensagem>
     </CABECALHO>
     <CONTEUDO>
        <MSG0016>
           <CodigoSubClassificacao>11</CodigoSubClassificacao>
           <Nome>Eckel</Nome>
           <Classificacao>24</Classificacao>
           <Situacao>0</Situacao>
        </MSG0016>
    </CONTEUDO>
    </MENSAGEM>'.
   

    RUN esp/esb/in/msg0016.p (INPUT xml-entrada,
                              OUTPUT xml-saida).
    

    define variable hDoc    as handle   no-undo.                                            
    create x-document hDoc.                                                                  
    hDoc:LOAD("longchar", xml-saida, NO).                                                   
    hDoc:SAVE("file","C:/temp/xml-saida" + replace(STRING(TIME, "HH:MM:SS"), ":", "") + ".xml").

    /*STOP.*/
END.
