USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS prmapi.DocumEstIntegrador:   
    
    {cep/ceapi001k.i}        
    
    DEFINE TEMP-TABLE tt-erro NO-UNDO
        FIELD i-sequen  AS INTEGER             
        FIELD cd-erro   AS INTEGER
        FIELD mensagem  AS CHARACTER    FORMAT "x(255)".
             
    DEFINE TEMP-TABLE tt-log NO-UNDO
        FIELD serie-docto   AS CHARACTER
        FIELD nro-docto     AS CHARACTER
        FIELD cod-emitente  AS INTEGER
        FIELD nat-operacao  AS CHARACTER
        FIELD sequencia     AS INTEGER
        FIELD mensagem      AS CHARACTER.             
             
    DEFINE PUBLIC PROPERTY RowIdDocumEst AS ROWID NO-UNDO
    GET.    
    SET(INPUT arg AS ROWID):
        FIND FIRST docum-est WHERE ROWID(docum-est) = arg NO-LOCK NO-ERROR.    
    END SET.        
    
    CONSTRUCTOR PUBLIC DocumEstIntegrador(INPUT c-cod-proj-int AS CHARACTER):   
        
        FIND FIRST prm-projeto-integrador NO-LOCK
             WHERE prm-projeto-integrador.cod-proj-int = c-cod-proj-int NO-ERROR.
        IF NOT AVAIL prm-projeto-integrador THEN
            UNDO, THROW NEW Progress.Lang.AppError(SUBSTITUTE("Projeto Integraá∆o informado &1 n∆o cadastrado. Verifique o programa PRM4103", c-cod-proj-int), 0).
        
        CATCH erro AS Progress.Lang.Error:
            UNDO, THROW NEW Progress.Lang.AppError(INPUT erro:GetMessage(1), erro:GetMessageNum(1)).
        END CATCH.         
    END CONSTRUCTOR.   

    METHOD PUBLIC HANDLE TransferirDocto():
        
        DEFINE VARIABLE h-ceapi001k AS HANDLE       NO-UNDO.
        DEFINE VARIABLE c-erros     AS CHARACTER    NO-UNDO.

        EMPTY TEMP-TABLE tt-movto.
        EMPTY TEMP-TABLE tt-erro. 
        EMPTY TEMP-TABLE tt-log.      
        
        IF NOT AVAILABLE(docum-est) THEN
            UNDO,THROW NEW Progress.Lang.AppError("Documento n∆o localizado.",0).        
        
        IF EmitenteProjetoIntegrador() = FALSE THEN
            UNDO,THROW NEW Progress.Lang.AppError("Emitente " + STRING(docum-est.cod-emitente) + " n∆o Ç do projeto de integraá∆o " + prm-projeto-integrador.cod-proj-int + ". Consulte a tela PRM4102",0).            
        
        IF docum-est.cod-emitente <> prm-projeto-integrador.cod-emitente THEN
            UNDO,THROW NEW Progress.Lang.AppError("Emitente " + STRING(docum-est.cod-emitente) + " n∆o corresponde ao cadastrado no projeto de integraá∆o " + prm-projeto-integrador.cod-proj-int + ". Cadastrado: " + STRING(prm-projeto-integrador.cod-emitente), 0).            
        
        FOR EACH item-doc-est OF docum-est NO-LOCK:                                   
            FIND FIRST ITEM WHERE ITEM.it-codigo = item-doc-est.it-codigo NO-LOCK NO-ERROR.
            IF NOT AVAILABLE(docum-est) THEN
                UNDO,THROW NEW Progress.Lang.AppError("Item " + item-doc-est.it-codigo + " n∆o localizado.",0). 
            
            FIND estab-mat WHERE estab-mat.cod-estabel = docum-est.cod-estabel NO-LOCK NO-ERROR.
            
            FOR EACH rat-lote OF item-doc-est NO-LOCK:
                EMPTY TEMP-TABLE tt-movto.
                EMPTY TEMP-TABLE tt-erro.
                
                ASSIGN c-erros = "".
                
                //Sa°da
                CREATE tt-movto.
                ASSIGN tt-movto.cod-versao-integracao = 1
                       tt-movto.it-codigo             = item-doc-est.it-codigo
                       tt-movto.cod-refer             = item-doc-est.cod-refer
                       tt-movto.cod-estabel           = docum-est.cod-estabel
                       tt-movto.cod-local             = rat-lote.cod-localiz
                       tt-movto.lote                  = rat-lote.lote
                       tt-movto.dt-vali-lote          = rat-lote.dt-vali-lote
                       tt-movto.serie-docto           = docum-est.serie-docto
                       tt-movto.ct-codigo             = estab-mat.cod-cta-transf-unif
                       tt-movto.sc-codigo             = ""
                       tt-movto.nro-docto             = docum-est.nro-docto
                       tt-movto.tipo-trans            = 2
                       tt-movto.quantidade            = rat-lote.quantidade
                       tt-movto.un                    = ITEM.un
                       tt-movto.cod-emitente          = docum-est.cod-emitente
                       tt-movto.dt-trans              = TODAY
                       tt-movto.esp-docto             = 33
                       tt-movto.cod-depos             = rat-lote.cod-depos.
                
                //Entrada       
                CREATE tt-movto.
                ASSIGN tt-movto.cod-versao-integracao = 1
                       tt-movto.it-codigo             = item-doc-est.it-codigo
                       tt-movto.cod-refer             = item-doc-est.cod-refer
                       tt-movto.cod-estabel           = docum-est.cod-estabel
                       tt-movto.cod-local             = rat-lote.cod-localiz
                       tt-movto.lote                  = rat-lote.lote
                       tt-movto.dt-vali-lote          = rat-lote.dt-vali-lote
                       tt-movto.serie-docto           = docum-est.serie-docto
                       tt-movto.ct-codigo             = estab-mat.cod-cta-transf-unif
                       tt-movto.sc-codigo             = ""                      
                       tt-movto.nro-docto             = docum-est.nro-docto
                       tt-movto.tipo-trans            = 1                       
                       tt-movto.quantidade            = rat-lote.quantidade
                       tt-movto.un                    = item.un
                       tt-movto.cod-emitente          = docum-est.cod-emitente                       
                       tt-movto.dt-trans              = TODAY
                       tt-movto.esp-docto             = 33                      
                       tt-movto.cod-depos             = prm-projeto-integrador.cod-depos.   
                
                IF NOT VALID-HANDLE(h-ceapi001k) THEN
                   RUN cep/ceapi001k.p PERSISTENT SET h-ceapi001k.
                
                RUN pi-execute IN h-ceapi001k (INPUT-OUTPUT TABLE tt-movto,
                                               INPUT-OUTPUT TABLE tt-erro, 
                                               INPUT YES).
                
                IF VALID-HANDLE(h-ceapi001k) THEN 
                    DELETE PROCEDURE h-ceapi001k.
                ASSIGN h-ceapi001k = ?.                 
                
                IF TEMP-TABLE tt-erro:HAS-RECORDS THEN DO:
                    FOR EACH tt-erro NO-LOCK:                        
                        ASSIGN c-erros = c-erros + STRING(tt-erro.cd-erro) + "-" + TRIM(tt-erro.mensagem) + "|".
                    END.
                END.
                
                CATCH erro AS Progress.Lang.Error:
                    ASSIGN c-erros = c-erros + STRING(erro:GetMessageNum(1)) + "-" + erro:GetMessage(1).      
                END CATCH. 
                FINALLY:
                    CREATE tt-log.
                    ASSIGN tt-log.serie-docto  = docum-est.serie-docto 
                           tt-log.nro-docto    = docum-est.nro-docto 
                           tt-log.cod-emitente = docum-est.cod-emitente
                           tt-log.nat-operacao = docum-est.nat-operacao
                           tt-log.sequencia    = item-doc-est.sequencia.
                           
                    IF c-erros = "" THEN                           
                        ASSIGN tt-log.mensagem = "Transferància Realizada com Sucesso.".
                    ELSE
                        ASSIGN tt-log.mensagem = c-erros.                                                    
                END FINALLY.               
            END.                                        
        END.        

        CATCH erro AS Progress.Lang.Error:
            
            CREATE tt-log.
            ASSIGN tt-log.serie-docto  = docum-est.serie-docto
                   tt-log.nro-docto    = docum-est.nro-docto
                   tt-log.cod-emitente = docum-est.cod-emitente
                   tt-log.nat-operacao = docum-est.nat-operacao
                   tt-log.mensagem     = erro:GetMessage(1).
        END CATCH.
        FINALLY:
            RETURN TEMP-TABLE tt-log:HANDLE.
        END FINALLY.
    END METHOD.      

    METHOD PUBLIC LOGICAL EmitenteProjetoIntegrador():
        
        IF AVAILABLE(docum-est) THEN DO:
            IF docum-est.cod-emitente = prm-projeto-integrador.cod-emitente THEN
                RETURN TRUE.
        END.

        RETURN FALSE.

        CATCH erro AS Progress.Lang.Error:
            UNDO,THROW NEW Progress.Lang.AppError(erro:GetMessage(1),erro:GetMessageNum(1)).
        END CATCH.

    END METHOD.    

    METHOD PUBLIC VOID ImprimirLogTransferencia():
        DEFINE VARIABLE h-utils AS HANDLE NO-UNDO.
        DEFINE VARIABLE c-arquivo AS CHARACTER NO-UNDO.
        
        FORM tt-log.serie-docto  FORMAT "x(5)"      COLUMN-LABEL "SÇrie"        SPACE(1) 
             tt-log.nro-docto    FORMAT "x(16)"     COLUMN-LABEL "Docto"        SPACE(1) 
             tt-log.cod-emitente FORMAT ">>>>>>>>9" COLUMN-LABEL "Emitente"     SPACE(1) 
             tt-log.nat-operacao FORMAT "x(6)"      COLUMN-LABEL "Nat. Oper."   SPACE(1)    
             tt-log.sequencia    FORMAT ">>>>9"     COLUMN-LABEL "Sequància"    SPACE(1)
             tt-log.mensagem     FORMAT "x(200)"    COLUMN-LABEL "Mensagem" 
            WITH STREAM-IO WIDTH 321 NO-BOX 60 DOWN FRAME f-log.

        ASSIGN c-arquivo = RIGHT-TRIM(SESSION:TEMP-DIRECTORY,"/") + "/logTransferencia.txt". 

        OUTPUT TO VALUE(c-arquivo) NO-CONVERT.
        
        PUT UNFORMATTED "Transferància para Dep¢sito do projeto de integraá∆o " + prm-projeto-integrador.cod-proj-int SKIP(2).
        
        FOR EACH tt-log:  
                  
            DISPLAY tt-log.serie-docto 
                    tt-log.nro-docto   
                    tt-log.cod-emitente
                    tt-log.nat-operacao
                    tt-log.sequencia   
                    tt-log.mensagem
                WITH FRAME f-log.
            DOWN WITH FRAME f-log.                  
        END.
        OUTPUT CLOSE.
        
        RUN utp/ut-utils.p PERSISTENT SET h-utils.
        RUN openDocument IN h-utils(INPUT c-arquivo).         
        DELETE PROCEDURE h-utils.
    END METHOD.

    DESTRUCTOR PUBLIC DocumEstIntegrador ( ):
    END DESTRUCTOR.
END CLASS.