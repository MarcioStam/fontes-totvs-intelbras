USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS prmapi.NotaCancIntegrador: 
    
    {prmapi/XMLNotaCanc.i}
    {method/dbotterr.i}
    
    DEFINE VARIABLE c-arquivo-xml AS CHARACTER NO-UNDO.
    
    CONSTRUCTOR PUBLIC NotaCancIntegrador(INPUT c-cod-proj-int AS CHARACTER):
        
        FIND FIRST prm-param-integrador NO-LOCK NO-ERROR.
        IF NOT AVAIL prm-param-integrador THEN
            UNDO, THROW NEW Progress.Lang.AppError("ParÉmetros Gerais de Integraá∆o n∆o cadastrados. Verifique o programa PRM4102", 0).
        
        FIND FIRST prm-projeto-integrador NO-LOCK
             WHERE prm-projeto-integrador.cod-proj-int = c-cod-proj-int NO-ERROR.
        IF NOT AVAIL prm-projeto-integrador THEN
            UNDO, THROW NEW Progress.Lang.AppError(SUBSTITUTE("Projeto Integraá∆o informado &1 n∆o cadastrado. Verifique o programa PRM4103", c-cod-proj-int), 0).
        
        IF prm-projeto-integrador.dir-nfe-canc = ? OR TRIM(prm-projeto-integrador.dir-nfe-canc) = "" THEN
            UNDO, THROW NEW Progress.Lang.AppError("Diret¢rio Notas Canceladas n∆o cadastrado", 0).
        
        CATCH erro AS Progress.Lang.Error:
            UNDO, THROW NEW Progress.Lang.AppError(INPUT erro:GetMessage(1), erro:GetMessageNum(1)).
        END CATCH.
    END CONSTRUCTOR.

    METHOD PUBLIC ROWID GerarNFPeloArquivoXML(INPUT p-arquivo AS CHARACTER): 

        DEFINE VARIABLE rw-nota-fiscal  AS ROWID        NO-UNDO.
        DEFINE VARIABLE c-erros         AS CHARACTER    NO-UNDO.
        DEFINE VARIABLE l-ok            AS LOGICAL      NO-UNDO.

        ASSIGN c-arquivo-xml = p-arquivo.

        FILE-INFO:FILE-NAME = c-arquivo-xml.
        IF FILE-INFO:FULL-PATHNAME = ? THEN
            UNDO, THROW NEW Progress.Lang.AppError("Arquivo " + c-arquivo-xml + " n∆o encontrado", 0).

        ASSIGN l-ok = DATASET XMLNotaCanc:READ-XML("file", c-arquivo-xml, "empty", ?, ?) NO-ERROR.
        IF NOT l-ok THEN
            UNDO, THROW NEW Progress.Lang.AppError("XML da nota n∆o corresponde a um cancelamento v†lido", 0).

        ASSIGN rw-nota-fiscal = GetNFDoXML().
        IF rw-nota-fiscal <> ? THEN DO:
            
            FIND FIRST nota-fiscal NO-LOCK
                 WHERE ROWID(nota-fiscal)      = rw-nota-fiscal
                   AND nota-fiscal.dt-cancela <> ? NO-ERROR.
            IF AVAILABLE(nota-fiscal) THEN DO:
                
                MoverXMLImportado().
                UNDO,THROW NEW Progress.Lang.AppError("Nota Fiscal " + nota-fiscal.nr-nota-fis + ", SÇrie " + nota-fiscal.serie + ", Estab " + nota-fiscal.cod-estabel + " j† cancelada para o XML. Somente o arquivo XML ser† movido.", 0).
            END.
        END.

        ASSIGN rw-nota-fiscal = ?
               rw-nota-fiscal = GerarNotaFiscal().

        FIND FIRST nota-fiscal NO-LOCK
             WHERE ROWID(nota-fiscal)      = rw-nota-fiscal
               AND nota-fiscal.dt-cancela <> ? NO-ERROR.
        IF AVAILABLE(nota-fiscal) THEN DO:
            MoverXMLImportado().
        END.
        
        RETURN rw-nota-fiscal.
        
        CATCH erro AS Progress.Lang.Error :
            ASSIGN c-erros = erro:GetMessage(1).
            UNDO,THROW NEW Progress.Lang.AppError(erro:GetMessage(1),erro:GetMessageNum(1)).                  
        END CATCH.
        FINALLY:
            CriarLogNF(INPUT rw-nota-fiscal,
                       INPUT c-erros,
                       INPUT 2 /*2 - CANCELADA*/).

            IF c-erros <> "" THEN DO:
                EnviarEmailNFComErro(INPUT c-erros).
            END.
        END FINALLY.                                  
    END METHOD.         

    METHOD PRIVATE ROWID GerarNotaFiscal():
        
        DEFINE VARIABLE rw-nota-fiscal  AS ROWID                            NO-UNDO.
        DEFINE VARIABLE c-arq-nota-fis  AS CHARACTER                        NO-UNDO.
        DEFINE VARIABLE c-erros         AS CHARACTER                        NO-UNDO.
        DEFINE VARIABLE nf              AS CLASS prmapi.NotaVendaIntegrador NO-UNDO.
        
        ASSIGN rw-nota-fiscal = GetNFDoXML().
        IF rw-nota-fiscal = ? THEN DO:
            
            /*Busca pelo XML da nota de venda no mesmo diret¢rio da nota cancelada*/
            ASSIGN c-arq-nota-fis = REPLACE(c-arquivo-xml, "110111-procEventoNFe", "procNFe").
            FILE-INFO:FILE-NAME = c-arq-nota-fis.
            /*-- Se vazio busca na pasta de vendas -- */
            IF FILE-INFO:FULL-PATHNAME = ? THEN DO:
                ASSIGN c-arq-nota-fis = REPLACE(c-arquivo-xml, "110111-procEventoNFe", "procNFe").

                ASSIGN c-arq-nota-fis = REPLACE(c-arq-nota-fis, prm-projeto-integrador.dir-nfe-canc, prm-projeto-integrador.dir-nfe-venda).
                FILE-INFO:FILE-NAME = c-arq-nota-fis.
                /*-- Se vazio busca na pasta de vendas importados -- */
                IF FILE-INFO:FULL-PATHNAME = ? THEN DO:
                    ASSIGN c-arq-nota-fis = REPLACE(c-arquivo-xml, "110111-procEventoNFe", "procNFe").
                    ASSIGN c-arq-nota-fis = REPLACE(c-arq-nota-fis, prm-projeto-integrador.dir-nfe-canc, RIGHT-TRIM(prm-projeto-integrador.dir-nfe-venda, "/") + "/Importados").
                    FILE-INFO:FILE-NAME = c-arq-nota-fis.
                END.
            END.

            IF FILE-INFO:FULL-PATHNAME <> ? THEN DO:
                nf = NEW prmapi.NotaVendaIntegrador(INPUT prm-projeto-integrador.cod-proj-int).                                        
                ASSIGN rw-nota-fiscal = nf:GerarNFPeloArquivoXML(INPUT c-arq-nota-fis, 
                                                                 INPUT 1 /*1 - VENDA*/). 
            END.
            
            IF rw-nota-fiscal = ? THEN
                UNDO, THROW NEW Progress.Lang.AppError("Nota fiscal n∆o localizada no sistema para cancelamento", 0).
        END.
        
        IF rw-nota-fiscal <> ? THEN DO:
            
            FIND FIRST nota-fiscal NO-LOCK
                 WHERE ROWID(nota-fiscal)      = rw-nota-fiscal
                   AND nota-fiscal.dt-cancela <> ? NO-ERROR.                                               
            IF AVAILABLE(nota-fiscal) THEN
                UNDO, THROW NEW Progress.Lang.AppError("Nota Fiscal " + nota-fiscal.nr-nota-fis + ", SÇrie " + nota-fiscal.serie + ", Estab " + nota-fiscal.cod-estabel + " j† cancelada para o XML", 0).                               
        END. 
        
        FIND FIRST nota-fiscal NO-LOCK
             WHERE ROWID(nota-fiscal) = rw-nota-fiscal NO-ERROR.
        IF AVAIL nota-fiscal THEN
            RUN prmapi/prmapi-cancelaNF-FT2200.p(INPUT nota-fiscal.cod-estabel,
                                                 INPUT nota-fiscal.serie,
                                                 INPUT nota-fiscal.nr-nota-fis,
                                                 INPUT "Cancelado via API padr∆o FT2200 - Projeto Integraá∆o " + prm-projeto-integrador.cod-proj-int,
                                                 INPUT-OUTPUT TABLE RowErrors).
        
        FIND FIRST nota-fiscal NO-LOCK
             WHERE ROWID(nota-fiscal)      = rw-nota-fiscal
               AND nota-fiscal.dt-cancela <> ? NO-ERROR.
        IF NOT AVAIL nota-fiscal THEN DO:
            
            FOR EACH RowErrors
               WHERE RowErrors.ErrorNumber = 17006
                 AND (INDEX(RowErrors.ErrorDescription , "NF-e em processo de Cancelamento") > 0
                  OR  INDEX(RowErrors.ErrorDescription , "NF-e em processo de Inutilizaá∆o") > 0): /*Mensagens 17006, geradas no axsep002/axsep003 para cancel/inut Assincrono*/
                DELETE RowErrors.
            END.
    
            FOR EACH RowErrors NO-LOCK:                                
                ASSIGN c-erros = c-erros + STRING(RowErrors.ErrorNumber) + "-" + RowErrors.ErrorDescription + " | ".
            END.
            ASSIGN c-erros = RIGHT-TRIM(c-erros, " | ").
            
            IF c-erros <> "" THEN
                UNDO,THROW NEW Progress.Lang.AppError(c-erros, 0).
        END.

        IF AVAIL nota-fiscal THEN DO:
            FOR FIRST ttDetEvento:
                ASSIGN nota-fiscal.cod-protoc = ttDetEvento.nProt.
            END.
        END.

        RETURN rw-nota-fiscal.
        
        CATCH erro AS Progress.Lang.Error:            
            UNDO,THROW NEW Progress.Lang.AppError(erro:GetMessage(1), erro:GetMessageNum(1)).
        END CATCH.
    END METHOD.

    METHOD PRIVATE VOID EnviarEmailNFComErro(INPUT p-msg-erro AS CHARACTER):

        DEFINE VARIABLE c-email-destino AS CHARACTER NO-UNDO.        

        FOR EACH usuar_grp_usuar WHERE usuar_grp_usuar.cod_grp_usuar = prm-param-integrador.cod-grp-usuar-integracao NO-LOCK,
            FIRST usuar_mestre WHERE usuar_mestre.cod_usuario = usuar_grp_usuar.cod_usuario NO-LOCK:

            IF usuar_mestre.cod_e_mail_local <> "" THEN
                ASSIGN c-email-destino = c-email-destino + usuar_mestre.cod_e_mail_local + ";".
        END. 
        ASSIGN c-email-destino = RIGHT-TRIM(c-email-destino,";").
        
        IF c-email-destino <> "" THEN 
            RUN prmapi/prmapi-mail.p(INPUT c-email-destino,
                                     INPUT "Erro cancelamento de nota fiscal - Projeto Integraá∆o " + prm-projeto-integrador.cod-proj-int,
                                     INPUT "Erro no cancelamento da nota fiscal do Projeto Integraá∆o " + prm-projeto-integrador.cod-proj-int + CHR(10) +
                                           "Arquivo: " + c-arquivo-xml + chr(10) +
                                           "Mensagem: " + p-msg-erro,
                                     INPUT "").                                                                         
    END METHOD.
    
    METHOD PRIVATE VOID CriarLogNF(INPUT p-nota-fiscal AS ROWID, INPUT p-erros AS CHARACTER, INPUT p-tipo AS INTEGER):
        
        DEFINE VARIABLE c-chave-acesso AS CHARACTER NO-UNDO.

        FOR FIRST ttInfEvento:
            ASSIGN c-chave-acesso = ttInfEvento.chNFe.
        END.

        FIND FIRST prm-nf-integrador WHERE prm-nf-integrador.arquivo-xml = c-arquivo-xml EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE(prm-nf-integrador) THEN DO:
            CREATE prm-nf-integrador.
            ASSIGN prm-nf-integrador.arquivo-xml = c-arquivo-xml.
        END.

        ASSIGN prm-nf-integrador.cod-proj-int     = prm-projeto-integrador.cod-proj-int
               prm-nf-integrador.tipo             = p-tipo
               prm-nf-integrador.chave-acesso-nfe = c-chave-acesso
               prm-nf-integrador.data-integracao  = TODAY.

        IF p-erros <> "" THEN
            ASSIGN prm-nf-integrador.situacao     = 2
                   prm-nf-integrador.msg-erro     = SUBSTRING(p-erros, 1, 9000)
                   prm-nf-integrador.cod-estabel  = ""
                   prm-nf-integrador.nr-nota-fis  = ""
                   prm-nf-integrador.serie        = ""
                   prm-nf-integrador.cod-emitente = ?
                   prm-nf-integrador.nat-operacao = "".
        
        FIND FIRST nota-fiscal NO-LOCK
             WHERE ROWID(nota-fiscal) = p-nota-fiscal NO-ERROR.
        IF AVAILABLE(nota-fiscal) THEN
            ASSIGN prm-nf-integrador.cod-estabel  = nota-fiscal.cod-estabel
                   prm-nf-integrador.nr-nota-fis  = nota-fiscal.nr-nota-fis
                   prm-nf-integrador.serie        = nota-fiscal.serie
                   prm-nf-integrador.cod-emitente = nota-fiscal.cod-emitente
                   prm-nf-integrador.nat-operacao = nota-fiscal.nat-operacao
                   prm-nf-integrador.situacao     = IF nota-fiscal.dt-cancela <> ? THEN 1 ELSE 2
                   prm-nf-integrador.msg-erro     = "".
    END METHOD.    

    METHOD PRIVATE VOID MoverXMLImportado():
        
        FILE-INFO:FILE-NAME = RIGHT-TRIM(prm-projeto-integrador.dir-nfe-canc,"/") + "/Importados".
        IF FILE-INFO:FULL-PATHNAME = ? THEN DO:
            OS-CREATE-DIR VALUE(FILE-INFO:FILE-NAME).
/*             IF OS-ERROR <> 0 THEN                                                                                                           */
/*                 UNDO,THROW NEW Progress.Lang.AppError("N∆o foi poss°vel criar a pasta 'Importados'. C¢digo do erro " + STRING(OS-ERROR),0). */
        END.

        OS-RENAME VALUE(c-arquivo-xml) VALUE(FILE-INFO:FILE-NAME).
/*         IF OS-ERROR <> 0 THEN                                                                                                                             */
/*             UNDO,THROW NEW Progress.Lang.AppError("N∆o foi poss°vel mover arquivo XML para a pasta de importados. C¢digo do erro " + STRING(OS-ERROR),0). */

/*         CATCH erro AS Progress.Lang.Error:                                                   */
/*             UNDO,THROW NEW Progress.Lang.AppError(erro:GetMessage(1),erro:GetMessageNum(1)). */
/*         END CATCH.                                                                           */
    END METHOD.   

    METHOD PRIVATE ROWID GetNFDoXML():
        
        FOR FIRST ttInfEvento:
            
            /* Removido em 06/10/2023 por Rafael Rosa devido a performance */
/*             FIND FIRST nota-fiscal NO-LOCK                                                     */
/*                  WHERE nota-fiscal.cod-chave-aces-nf-eletro BEGINS ttInfEvento.chNFe NO-ERROR. */
/*             IF AVAIL nota-fiscal THEN                                                          */
/*                 RETURN ROWID(nota-fiscal).                                                     */
            /* Fim da RemoÁ„o por Rafael Rosa em 06/10/2023 */    

                
            FIND FIRST prm-nf-integrador NO-LOCK
                 WHERE prm-nf-integrador.chave-acesso-nfe = ttInfEvento.chNFe NO-ERROR.            
            IF AVAILABLE(prm-nf-integrador) THEN DO:
                
                FIND FIRST nota-fiscal NO-LOCK
                     WHERE nota-fiscal.cod-estabel = prm-nf-integrador.cod-estabel
                       AND nota-fiscal.serie       = prm-nf-integrador.serie
                       AND nota-fiscal.nr-nota-fis = prm-nf-integrador.nr-nota-fis NO-ERROR.
                IF AVAILABLE(nota-fiscal) THEN
                    RETURN ROWID(nota-fiscal).                                                                                                
            END.
        END.

        RETURN ?.

        CATCH erro AS Progress.Lang.Error:
            UNDO,THROW NEW Progress.Lang.AppError(erro:GetMessage(1),erro:GetMessageNum(1)).
        END CATCH.
    END METHOD.    

    DESTRUCTOR PUBLIC NotaCancIntegrador():
    END DESTRUCTOR.
END CLASS.

