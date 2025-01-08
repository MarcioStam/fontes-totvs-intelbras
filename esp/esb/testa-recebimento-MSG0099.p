DISABLE TRIGGERS FOR LOAD OF emitente.
DISABLE TRIGGERS FOR LOAD OF int-emitente.
DEF VAR xml-entrada AS LONGCHAR.                                         
DEF VAR xml-saida AS LONGCHAR.




DO TRANS:

    ASSIGN xml-entrada = '<?xml version="1.0" encoding="utf-8"?>
     <MENSAGEM xmlns="urn:teste.org">
     <CABECALHO>
      <IdentidadeEmissor>64546C2E-6DAB-4311-A74A-5ACA96134AFF</IdentidadeEmissor>
      <NumeroOperacao>881170101</NumeroOperacao>
      <CodigoMensagem>MSG0099</CodigoMensagem>
     </CABECALHO>
     <CONTEUDO>
        <MSG0099>
              <CanaisCentrais>
                <ContaCentral>d66a88b1-bc0d-e411-9420-00155d013d39</ContaCentral>
                    <CanaisFiliais>
                      <ContaCentral>d66a88b1-bc0d-e411-9420-00155d013d39</ContaCentral>
                      <ContaFilial>d66a88b1-bc0d-e411-9420-00155d013d39</ContaFilial>
                    </CanaisFiliais>
              </CanaisCentrais>
            </MSG0099>
    </CONTEUDO>
    </MENSAGEM>'.
    


define variable hDoc1    as handle   no-undo.                                             
create x-document hDoc1.                                                                  
hDoc1:LOAD("longchar", xml-entrada, NO).                                                   
hDoc1:SAVE("file","C:/temp/roger-" + replace(STRING(TIME, "HH:MM:SS"), ":", "") + ".xml").
       


    RUN esp/esb/in/msg0099.p (INPUT xml-entrada,
                              OUTPUT xml-saida).
    
    define variable hDoc    as handle   no-undo.                                            
    create x-document hDoc.                                                                  
    hDoc:LOAD("longchar", xml-saida, NO).                                                   
    hDoc:SAVE("file","C:/temp/xml-saida" + replace(STRING(TIME, "HH:MM:SS"), ":", "") + ".xml").

    STOP.
END.

/*                 <CanalItem>                                                          */
/*                     <ContaCentral>08F14E0E-4B9E-E311-888D-00155D013E2E</ContaCentral>  */
/*                 </CanalItem>                                                         */
