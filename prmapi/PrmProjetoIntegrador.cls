USING Progress.Lang.*.
USING OpenEdge.Core.Collections.List.
USING OpenEdge.Core.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS prmapi.PrmProjetoIntegrador: 
    
    CONSTRUCTOR PUBLIC PrmProjetoIntegrador(INPUT c-cod-proj-int AS CHARACTER):
        
        FIND FIRST prm-projeto-integrador NO-LOCK
             WHERE prm-projeto-integrador.cod-proj-int = c-cod-proj-int NO-ERROR.
        IF NOT AVAIL prm-projeto-integrador THEN
            UNDO, THROW NEW Progress.Lang.AppError(SUBSTITUTE("Projeto Integraá∆o informado &1 n∆o cadastrado. Verifique o programa PRM4103", c-cod-proj-int), 0).
        
        CATCH erro AS Progress.Lang.Error:
            UNDO, THROW NEW Progress.Lang.AppError(INPUT erro:GetMessage(1), erro:GetMessageNum(1)).
        END CATCH.
    END CONSTRUCTOR.
    
    METHOD PRIVATE List getXMLDiretorio(INPUT c-diretorio AS CHARACTER):
        
        DEFINE VARIABLE c-nome-arquivo  AS CHARACTER    NO-UNDO.
        DEFINE VARIABLE c-caminho       AS CHARACTER    NO-UNDO.
        DEFINE VARIABLE c-atributos     AS CHARACTER    NO-UNDO.
        DEFINE VARIABLE listaArquivos   AS List         NO-UNDO.
        DEFINE VARIABLE arq             AS CLASS String NO-UNDO.
        
        listaArquivos = NEW List().
    
        FILE-INFO:FILE-NAME = c-diretorio.
        IF FILE-INFO:FULL-PATHNAME <> ? THEN DO:                                                                
            INPUT FROM OS-DIR(FILE-INFO:FILE-NAME).
            REPEAT:
                IMPORT c-nome-arquivo
                       c-caminho
                       c-atributos.           
    
                IF c-nome-arquivo = "." OR c-nome-arquivo = ".." THEN
                    NEXT.           
                
                IF c-atributos = "F" THEN DO:
                    IF ENTRY(NUM-ENTRIES(c-nome-arquivo,"."), c-nome-arquivo, ".") = "xml" THEN DO:                         
                        arq = NEW String(c-caminho).                                                           
                        listaArquivos:add(arq).                                                                                                                                                                                              
                    END.
                END.                                                                                    
            END.
            INPUT CLOSE.               
        END.            
        
        RETURN listaArquivos.
        
        CATCH erro AS Progress.Lang.Error:
            UNDO,THROW NEW Progress.Lang.AppError(erro:GetMessage(1),erro:GetMessageNum(1)).
        END CATCH.
    END METHOD.
    
    METHOD PUBLIC List getXMLNaoImportadosVenda():
        
        IF prm-projeto-integrador.dir-nfe-venda = ? OR TRIM(prm-projeto-integrador.dir-nfe-venda) = "" THEN
            UNDO, THROW NEW Progress.Lang.AppError("Diret¢rio Notas de Venda n∆o cadastrado", 0).
        
        RETURN getXMLDiretorio(INPUT prm-projeto-integrador.dir-nfe-venda).
        
        CATCH erro AS Progress.Lang.Error:
            UNDO,THROW NEW Progress.Lang.AppError(erro:GetMessage(1),erro:GetMessageNum(1)).
        END CATCH.
    END METHOD.
    
    METHOD PUBLIC List getXMLNaoImportadosCanc():
        
        IF prm-projeto-integrador.dir-nfe-canc = ? OR TRIM(prm-projeto-integrador.dir-nfe-canc) = "" THEN
            UNDO, THROW NEW Progress.Lang.AppError("Diret¢rio Notas Canceladas n∆o cadastrado", 0).
        
        RETURN getXMLDiretorio(INPUT prm-projeto-integrador.dir-nfe-canc).
        
        CATCH erro AS Progress.Lang.Error:
            UNDO,THROW NEW Progress.Lang.AppError(erro:GetMessage(1),erro:GetMessageNum(1)).
        END CATCH.
    END METHOD.
    
    METHOD PUBLIC List getXMLNaoImportadosRemessa():
        
        IF prm-projeto-integrador.dir-nfe-rem = ? OR TRIM(prm-projeto-integrador.dir-nfe-rem) = "" THEN
            UNDO, THROW NEW Progress.Lang.AppError("Diret¢rio Notas de Remessa n∆o cadastrado", 0).
        
        RETURN getXMLDiretorio(INPUT prm-projeto-integrador.dir-nfe-rem).
        
        CATCH erro AS Progress.Lang.Error:
            UNDO,THROW NEW Progress.Lang.AppError(erro:GetMessage(1),erro:GetMessageNum(1)).
        END CATCH.
    END METHOD.
    
    METHOD PUBLIC List getXMLNaoImportadosRetorno():
        
        IF prm-projeto-integrador.dir-nfe-ret = ? OR TRIM(prm-projeto-integrador.dir-nfe-ret) = "" THEN
            UNDO, THROW NEW Progress.Lang.AppError("Diret¢rio Notas de Retorno n∆o cadastrado", 0).
        
        RETURN getXMLDiretorio(INPUT prm-projeto-integrador.dir-nfe-ret).
        
        CATCH erro AS Progress.Lang.Error:
            UNDO,THROW NEW Progress.Lang.AppError(erro:GetMessage(1),erro:GetMessageNum(1)).
        END CATCH.
    END METHOD.
    
    METHOD PUBLIC List getXMLNaoImportadosDevolucao():
        
        IF prm-projeto-integrador.dir-nfe-devol = ? OR TRIM(prm-projeto-integrador.dir-nfe-devol) = "" THEN
            UNDO, THROW NEW Progress.Lang.AppError("Diret¢rio Notas de Devoluá∆o n∆o cadastrado", 0).
        
        RETURN getXMLDiretorio(INPUT prm-projeto-integrador.dir-nfe-devol).
        
        CATCH erro AS Progress.Lang.Error:
            UNDO,THROW NEW Progress.Lang.AppError(erro:GetMessage(1),erro:GetMessageNum(1)).
        END CATCH.
    END METHOD.
    
    DESTRUCTOR PUBLIC PrmProjetoIntegrador():
    END DESTRUCTOR.
END CLASS.