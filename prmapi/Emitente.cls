USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS prmapi.Emitente:
    
    {prmapi/XMLNotaFiscal.i}
    {prmapi/prmapi-emitente.i}        
               
    CONSTRUCTOR PUBLIC Emitente():                
    END CONSTRUCTOR.    

    METHOD PUBLIC VOID CarregarEmitenteComDadosDoXML(INPUT DATASET FOR XMLNotaFiscal,
                                                     BUFFER b-tt-emitente FOR tt-emitente):           
        DEFINE VARIABLE c-cgc AS CHARACTER NO-UNDO.                                                          
                                                                
        IF NOT CAN-FIND(FIRST ttDest) THEN
            UNDO,THROW NEW Progress.Lang.AppError("NÆo encontrado dados do cliente no XML."). 
        
        FOR FIRST ttDest:                        
            IF ttDest.CNPJ <> "" THEN
                ASSIGN c-cgc = ttDest.CNPJ.
            ELSE
                ASSIGN c-cgc = ttDest.CPF.                                                                          
                    
            ASSIGN b-tt-emitente.nome-emit = SUBSTR(ttDest.xNome, 1, 80)
                   b-tt-emitente.ins-estadual = ttDest.IE.                                         
                   
            IF ttDest.CNPJ <> "" THEN
                ASSIGN b-tt-emitente.cgc = ttDest.CNPJ.                
            ELSE
                ASSIGN b-tt-emitente.cgc = ttDest.CPF.                        
            
            FOR FIRST ttEnderDest:

                IF LENGTH(ttEnderDest.xLgr) < 2 THEN
                    ASSIGN ttEnderDest.xLgr = "Rua " + ttEnderDest.xLgr.

                ASSIGN b-tt-emitente.endereco     = SUBSTR(STRING(SUBSTR(ttEnderDest.xLgr, 1, 30) + ", " + ttEnderDest.nro), 1, 40)
                       b-tt-emitente.bairro       = SUBSTR(ttEnderDest.xBairro, 1, 20)
                       b-tt-emitente.cidade       = SUBSTR(ttEnderDest.xMun, 1, 50)
                       b-tt-emitente.estado       = ttEnderDest.UF
                       b-tt-emitente.cep          = ttEnderDest.CEP
                       b-tt-emitente.pais         = SUBSTR(ttEnderDest.xPais, 1, 20)
                       b-tt-emitente.endereco-cob = b-tt-emitente.endereco
                       b-tt-emitente.bairro-cob   = b-tt-emitente.bairro
                       b-tt-emitente.cidade-cob   = b-tt-emitente.cidade
                       b-tt-emitente.estado-cob   = b-tt-emitente.estado
                       b-tt-emitente.cep-cob      = b-tt-emitente.cep
                       b-tt-emitente.pais-cob     = b-tt-emitente.pais.                                                              
            END.                                                                                    
        END.
        
        CATCH erro AS Progress.Lang.Error:
            UNDO,THROW NEW Progress.Lang.AppError(erro:GetMessage(1),erro:GetMessageNum(1)).
        END CATCH.
    END METHOD.        
    
    DESTRUCTOR PUBLIC Emitente ( ):
    END DESTRUCTOR.
END CLASS.
