/*DEFINE TEMP-TABLE nfe-param NO-UNDO
    FIELD cod-estabel AS CHAR
    FIELD end-imp-nfe AS CHAR.

DEFINE TEMP-TABLE estabelec NO-UNDO
    FIELD cod-estabel AS CHAR.

DEFINE TEMP-TABLE msg-ret-nf-eletro NO-UNDO
    FIELD cod-msg     AS CHAR
    FIELD cod-grp-msg AS CHAR.

DEFINE TEMP-TABLE NFE NO-UNDO
    FIELD cod-estabel AS CHAR
    FIELD serie       AS CHAR
    FIELD nr-nota-fis AS CHAR
    FIELD cod-msg     AS CHAR
    FIELD ds-chave    AS CHAR
    FIELD acao        AS INTEGER.*/



DEFINE VARIABLE c-arquivo       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE l-achou-backup  AS LOGICAL     NO-UNDO.
DEFINE VARIABLE c-email-destino AS CHARACTER   NO-UNDO.
define buffer b-emitente for emitente.    
DEFINE VARIABLE i-contador      AS INTEGER      NO-UNDO.

    {utp/utapi019.i}

DEFINE TEMP-TABLE tt-import NO-UNDO
    FIELD cnpj        AS CHAR
    FIELD serie       AS CHAR
    FIELD nr-nota-fis AS CHAR
    FIELD ds-chave    AS CHAR
    FIELD codigo      AS CHAR
    FIELD descricao   AS CHAR
    FIELD protocolo   AS CHAR
    FIELD datahora    AS CHAR
    FIELD iLinha      AS INT
    FIELD FullPath    AS CHAR
    FIELD FILENAME    AS CHAR
    INDEX ch_principal cnpj serie nr-nota-fis.

DEFINE TEMP-TABLE TT_File NO-UNDO 
    FIELD FILENAME AS CHARACTER
    FIELD FullPath AS CHARACTER
    FIELD FILE     AS CHARACTER.


PROCEDURE pi-atualiza-status:
DEF INPUT  PARAM pCodEstabel AS CHARACTER.
DEF INPUT  PARAM pSerie      AS CHARACTER.
DEF INPUT  PARAM pNrNotaFis  AS CHARACTER.
DEF INPUT-OUTPUT PARAM TABLE FOR tt-import.
    
for each nfe-param no-lock
    where nfe-param.cod-estabel = pCodEstabel.

    IF opsys <> 'WIN32' THEN DO:
        ASSIGN c-arquivo = nfe-param.end-imp-nfe-unix + "/" + trim(pSerie)      + "_" + 
                                                              pNrNotaFis        + ".txt".

    END.
    ELSE DO:     
        ASSIGN c-arquivo = nfe-param.end-imp-nfe      + "~\" + trim(pSerie)      + "_" + 
                                                               pNrNotaFis        + ".txt".
    END.
    FOR FIRST estabelec NO-LOCK
        WHERE estabelec.cod-estabel = nfe-param.cod-estabel:
    END.
    FIND FIRST tt-import
         WHERE tt-import.cnpj          = estabelec.cgc
           AND tt-import.serie         = pSerie     
           AND tt-import.nr-nota-fis   = pNrNotaFis NO-LOCK NO-ERROR.

    ASSIGN l-achou-backup = NO.
    IF NOT AVAIL tt-import THEN DO:

        IF SEARCH(c-arquivo) <> ? THEN DO:
            ASSIGN l-achou-backup = YES.

            INPUT FROM VALUE(c-arquivo) NO-CONVERT.
            CREATE tt-import.
            IMPORT DELIMITER ";" tt-import NO-ERROR.
         
            ASSIGN 
                iLinha             = iLinha + 1
                tt-import.iLinha   = iLinha.
               
            IF AVAIL tt_file THEN
               ASSIGN tt-import.FullPath = TT_File.FullPath
                      tt-import.FILENAME = TT_File.FILENAME.

            IF tt-import.codigo <> "100" THEN DO:
                
                ASSIGN l-achou-backup = NO
                       i-contador = 1.
                REPEAT:
                    IF opsys <> 'WIN32' THEN DO:
                        ASSIGN c-arquivo = nfe-param.end-imp-nfe-unix + "/" + trim(pSerie)      + "_" + 
                                                                              pNrNotaFis        + ".(" + trim(string(i-contador)) + ").txt".
                
                    END.
                    ELSE DO:     
                        ASSIGN c-arquivo = nfe-param.end-imp-nfe      + "~\" + trim(pSerie)      + "_" + 
                                                                               pNrNotaFis        + ".(" + trim(string(i-contador)) + ").txt".
                    END.
                    
                    IF SEARCH(c-arquivo) = ? THEN
                       LEAVE. /* NÆo achou o arquivo */

                    ASSIGN l-achou-backup = YES.
        
                    INPUT FROM VALUE(c-arquivo) NO-CONVERT.
                    CREATE tt-import.
                    IMPORT DELIMITER ";" tt-import NO-ERROR.
                 
                    ASSIGN 
                        iLinha             = iLinha + 1
                        tt-import.iLinha   = iLinha.
                       
                    IF AVAIL tt_file THEN
                       ASSIGN tt-import.FullPath = TT_File.FullPath
                              tt-import.FILENAME = TT_File.FILENAME.
        
                    IF tt-import.codigo = "100" THEN LEAVE.
                    ELSE DELETE tt-import.

                    ASSIGN i-contador = i-contador + 1.
                    
                END. 
            END.
        END.

/*         IF l-achou-backup = NO THEN DO:                                                   */
/*             IF opsys <> 'WIN32' THEN                                                      */
/*                 INPUT FROM OS-DIR(nfe-param.end-imp-nfe-unix) NO-ECHO.                    */
/*             else                                                                          */
/*                 INPUT FROM OS-DIR(nfe-param.end-imp-nfe) NO-ECHO.                         */
/*                                                                                           */
/*             REPEAT:                                                                       */
/*                 CREATE TT_File.                                                           */
/*                 IMPORT TT_File.FILENAME                                                   */
/*                        TT_File.FullPath                                                   */
/*                        TT_File.FILE.                                                      */
/*             END.                                                                          */
/*                                                                                           */
/*             FOR EACH TT_File                                                              */
/*                 WHERE TT_File.FILE = 'F'                                                  */
/*                   AND SUBSTRING(TT_File.FILENAME,LENGTH(TT_File.FILENAME) - 2,3) = 'TXT'. */
/*                                                                                           */
/*                 INPUT FROM VALUE(TT_File.FullPath) NO-CONVERT.                            */
/*                                                                                           */
/*                 RUN ImportaArquivo.                                                       */
/*             END.                                                                          */
/*         END.                                                                              */
    END.

    FOR EACH tt-import
        WHERE tt-import.cnpj          = estabelec.cgc
          AND tt-import.serie         = pSerie     
          AND tt-import.nr-nota-fis   = pNrNotaFis,
        FIRST msg-ret-nf-eletro NO-LOCK
        WHERE msg-ret-nf-eletro.cod-msg = tt-import.codigo.

        assign tt-import.nr-nota-fis = string(int(tt-import.nr-nota-fis),"9999999").
        
        /* Tratamento das notas que foram importadas */
        CASE msg-ret-nf-eletro.cod-grp-msg:
            WHEN '10' THEN DO: /* 10 - Nota Fiscal Gravada na Base de dados com sucesso */

                FOR FIRST NFE EXCLUSIVE-LOCK
                    WHERE NFE.cod-estabel = estabelec.cod-estabel
                      AND NFE.serie       = tt-import.serie
                      AND NFE.nr-nota-fis = tt-import.nr-nota-fis.
                                        
                    RUN piDelArquivo (input tt-import.FullPath).
                    
                    if NFE.acao <> 3 /* OK */ then
                        ASSIGN 
                            NFE.cod-msg  = tt-import.codigo
                            NFE.ds-chave = tt-import.ds-chave
                            NFE.acao     = 1.
                END.
            END.
            WHEN '20' THEN DO: /* 20 - Nota Fiscal Autorizada para uso */            

                FOR FIRST NFE FIELDS(acao ds-chave cod-msg) EXCLUSIVE-LOCK
                    WHERE NFE.cod-estabel = estabelec.cod-estabel
                      AND NFE.serie       = tt-import.serie
                      AND NFE.nr-nota-fis = tt-import.nr-nota-fis.
                      
                    ASSIGN 
                        NFE.cod-msg  = tt-import.codigo
                        NFE.ds-chave = tt-import.ds-chave
                        NFE.acao     = 3 /* OK */
                        nfe.PROTOCOLO = tt-import.protocolo.
                    FOR first nota-fiscal EXCLUSIVE-LOCK
                            where nota-fiscal.cod-estabel = nfe.cod-estabel
                              and nota-fiscal.serie       = nfe.serie
                              and nota-fiscal.nr-nota-fis = nfe.nr-nota-fis:
                        ASSIGN nota-fiscal.cod-protoc     = nfe.protocolo.
                    END.
                    find ret-nf-eletro
                         where ret-nf-eletro.cod-estabel = estabelec.cod-estabel   
                           AND ret-nf-eletro.cod-serie   = nota-fiscal.serie       
                           AND ret-nf-eletro.nr-nota-fis = nota-fiscal.nr-nota-fis 
                           AND ret-nf-eletro.cod-msg     = nfe.cod-msg EXCLUSIVE-LOCK NO-ERROR.
                    IF NOT AVAIL ret-nf-eletro THEN
                        CREATE ret-nf-eletro.

                    ASSIGN ret-nf-eletro.cod-estabel = estabelec.cod-estabel   NO-ERROR.
                    ASSIGN ret-nf-eletro.cod-serie   = nota-fiscal.serie       NO-ERROR.
                    ASSIGN ret-nf-eletro.nr-nota-fis = nota-fiscal.nr-nota-fis NO-ERROR.
                    ASSIGN ret-nf-eletro.cod-msg     = nfe.cod-msg NO-ERROR.
                    ASSIGN ret-nf-eletro.cod-protoc  = nfe.protocolo NO-ERROR.
                    ASSIGN ret-nf-eletro.dat-ret     = DATE(SUBSTRING(tt-import.datahora,9,2) + "/" + SUBSTRING(tt-import.datahora,6,2) + "/" + SUBSTRING(tt-import.datahora,1,4)).
                    ASSIGN ret-nf-eletro.hra-ret     = REPLACE(SUBSTRING(tt-import.datahora,12,8),":","") NO-ERROR.
                    ASSIGN ret-nf-eletro.log-ativo   = YES NO-ERROR.
                    ASSIGN nota-fiscal.cod-chave-aces-nf-eletro = nfe.ds-chave NO-ERROR.
                    FOR FIRST docum-est
                        WHERE docum-est.serie-docto  = nota-fiscal.serie
                          AND docum-est.nro-docto    = nota-fiscal.nr-nota-fis
                          AND docum-est.cod-emitente = nota-fiscal.cod-emitente
                          AND docum-est.nat-operacao = nota-fiscal.nat-operacao EXCLUSIVE-LOCK:
                        ASSIGN docum-est.cod-chave-aces-nf-eletro = nfe.ds-chave.
                    END.                                                      


                    IF l-achou-backup = no THEN
                        RUN piRenameArquivo (input tt-import.FullPath, INPUT c-arquivo).                        
                    
/*                     run piEnviarEmail. */ /* Retirado porque passou a enviar pelo monitor Gati */
                    
                END.
            END.
            WHEN '30' THEN DO: /* 30 - Nota Fiscal em Contingencia */  

                FOR FIRST NFE FIELDS(acao ds-chave cod-msg) EXCLUSIVE-LOCK
                    WHERE NFE.cod-estabel = estabelec.cod-estabel
                      AND NFE.serie       = tt-import.serie
                      AND NFE.nr-nota-fis = tt-import.nr-nota-fis.
                    RUN piDelArquivo (input tt-import.FullPath).
    
                    IF NFE.acao <> 2 THEN
                        ASSIGN 
                            NFE.cod-msg  = tt-import.codigo
                            NFE.ds-chave = tt-import.ds-chave
                            NFE.acao     = 4 /* Contingencia */.
                END.
            END.
            WHEN '40' THEN DO: /* 40 - Nota Fiscal com erro */            

                FOR FIRST NFE FIELDS(acao ds-chave cod-msg) EXCLUSIVE-LOCK
                    WHERE NFE.cod-estabel = estabelec.cod-estabel
                      AND NFE.serie       = tt-import.serie
                      AND NFE.nr-nota-fis = tt-import.nr-nota-fis.            
                    RUN piDelArquivo (input tt-import.FullPath).
                    ASSIGN 
                        NFE.cod-msg  = tt-import.codigo
                        NFE.ds-chave = tt-import.ds-chave
                        NFE.acao     = 5 /* DOCUMENTO REJEITADO */.
                END.
            END.
            WHEN '50' THEN DO: /* 50 - Duplicidade de Nota Fiscal */            


                /*FOR FIRST NFE FIELDS(acao cod-msg) EXCLUSIVE-LOCK --------- NÆo h  necessidade do tratamento deste erro!!
                    WHERE NFE.cod-estabel     = estabelec.cod-estabel
                      AND NFE.serie       = tt-import.serie
                      AND NFE.nr-nota-fis = tt-import.nr-nota-fis. 
                    RUN piDelArquivo (input tt-import.FullPath).
    
                    IF NFE.acao <> 3 THEN
                        ASSIGN 
                            NFE.cod-msg  = tt-import.codigo
                            NFE.acao = 5 /* DOCUMENTO REJEITADO */.
                END.*/
            END.
            WHEN '80' THEN DO: /* 80 - Nota fiscal pode entrar em contingencia em breve */            

                FOR FIRST NFE FIELDS(cod-msg) NO-LOCK
                    WHERE NFE.cod-estabel = estabelec.cod-estabel
                      AND NFE.serie       = tt-import.serie
                      AND NFE.nr-nota-fis = tt-import.nr-nota-fis. 
                    ASSIGN NFE.cod-msg  = tt-import.codigo.
                END.
            END.
            WHEN '100' THEN DO: /* 100 - Nao foi possivel ler a mensagem  */

                FOR FIRST NFE FIELDS(acao cod-msg) EXCLUSIVE-LOCK
                    WHERE NFE.cod-estabel     = estabelec.cod-estabel
                      AND NFE.serie       = tt-import.serie
                      AND NFE.nr-nota-fis = tt-import.nr-nota-fis.
                    RUN piDelArquivo (input tt-import.FullPath).
                    
                    IF NFE.acao <> 3 THEN
                        ASSIGN 
                            NFE.cod-msg  = tt-import.codigo
                            NFE.acao = 5 /* DOCUMENTO REJEITADO */.
                END.
            END.
            WHEN '900' THEN DO: /* 900 - Alteracao da numeracao (Devido ao SCAN) */            

                FOR FIRST NFE EXCLUSIVE-LOCK
                    WHERE NFE.cod-estabel     = estabelec.cod-estabel
                      AND NFE.serie       = tt-import.serie
                      AND NFE.nr-nota-fis = tt-import.nr-nota-fis.
                    RUN piDelArquivo (input tt-import.FullPath).
    
                    IF NFE.acao <> 3 THEN DO:
                        run esp/ftp/esft066b.p (input rowid(nfe)).
                    END.
                END.
            END.
        END CASE.    

    END.
    
end.
END PROCEDURE.
PROCEDURE piRenameArquivo:
    DEF INPUT  PARAM pArquivo         AS CHARACTER.
    DEF INPUT  PARAM pArquivo-destino AS CHARACTER.
    
    DEFINE VARIABLE iErroStatus AS INTEGER NO-UNDO.

    OS-COPY VALUE(pArquivo) VALUE(pArquivo-destino).

    ASSIGN iErroStatus = OS-ERROR.

    IF iErroStatus <> 0 THEN
        RETURN 'NOK'.

    OS-DELETE VALUE(pArquivo).
    ASSIGN iErroStatus = OS-ERROR.

    IF iErroStatus <> 0 THEN DO:
        RETURN 'NOK'.
    END.
        
        
    RETURN 'OK'.

END PROCEDURE.

PROCEDURE piDelArquivo. 
    DEF INPUT  PARAM pArquivo AS CHARACTER.
    
    DEFINE VARIABLE iErroStatus AS INTEGER NO-UNDO.

    OS-DELETE VALUE(pArquivo).
    ASSIGN iErroStatus = OS-ERROR.
    IF iErroStatus <> 0 THEN
        RETURN 'NOK'.
        
    RETURN 'OK'.

END PROCEDURE.

PROCEDURE piEnviarEmail.
    
    find first nota-fiscal no-lock
    where nota-fiscal.cod-estabel = nfe.cod-estabel
      and nota-fiscal.serie       = nfe.serie
      and nota-fiscal.nr-nota-fis = nfe.nr-nota-fis no-error.
    IF avail nota-fiscal then do:
       FIND natur-oper
            WHERE natur-oper.nat-operacao = nota-fiscal.nat-operacao 
            NO-LOCK NO-ERROR.
       IF AVAIL natur-oper AND
           natur-oper.tipo = 2 THEN DO:
            IF CAN-find(FIRST cont-emit no-lock
                where cont-emit.cod-emitente = nota-fiscal.cod-emitente 
                  and (cont-emit.nome        BEGINS 'NFE'
                   or cont-emit.nome         BEGINS 'NF-e')) THEN DO:
               ASSIGN c-email-destino = "".
               FOR each cont-emit no-lock
                    where cont-emit.cod-emitente = nota-fiscal.cod-emitente 
                      and (cont-emit.nome        BEGINS 'NFE'
                       or cont-emit.nome         BEGINS 'NF-e'):
                   IF c-email-destino = "" THEN
                      ASSIGN c-email-destino = trim(cont-emit.e-mail).
                   ELSE
                      ASSIGN c-email-destino = trim(c-email-destino) + "," + trim(cont-emit.e-mail).
               END.
               RUN pi-gera-email.
            END.
            ELSE DO:
                find first b-emitente no-lock
                     where b-emitente.cod-emitente = nota-fiscal.cod-emitente no-error.       
                ASSIGN c-email-destino = b-emitente.e-mail.
                RUN pi-gera-email.
            END.
       END.
    END.

END PROCEDURE.

PROCEDURE pi-gera-email:

    IF nota-fiscal.ind-sit-nota < 2 OR
       nota-fiscal.dt-confirma = ?  THEN DO: /* Significa que ainda nÆo foi impresso e nÆo foi enviado os arquivos para o cliente */
        find first emitente no-lock 
            where emitente.cgc = estabelec.cgc no-error.
        find first b-emitente no-lock
             where b-emitente.cod-emitente = nota-fiscal.cod-emitente no-error.       


        find first param-global no-lock no-error.   
        FIND transporte
            WHERE transporte.nome-abrev = nota-fiscal.nome-transp
            NO-LOCK NO-ERROR.

        create tt-envio.              
        assign 
            tt-envio.versao-integracao = 1
            tt-envio.exchange          = param-global.log-1
            tt-envio.servidor          = param-global.serv-mail
            tt-envio.porta             = param-global.porta-mail                
            tt-envio.assunto           = 'NFE AUTORIZADA'
            tt-envio.remetente         = "nfesaida@intelbras.com.br"
            tt-envio.mensagem          = 'Esta mensagem refere-se a Nota Fiscal Eletr“nica Nacional de serie/n£mero [' + trim(nota-fiscal.serie) + '/' + trim(nota-fiscal.nr-nota-fis) + '] emitida para:'  + CHR(10) +  CHR(13) +
                                         'RazÆo Social: ' + b-emitente.nome-emit  + CHR(10) +  CHR(13) +
                                         'CNPJ: ' + b-emitente.cgc + CHR(10) +  CHR(13) +
                                         '' + CHR(10) +  CHR(13) +
                                         'Para verificar a autoriza‡Æo da SEFAZ referente … nota acima mencionada, acesse o sitio http://www.nfe.fazenda.gov.br/portal' + CHR(10) +  CHR(13) +
                                         '' + CHR(10) +  CHR(13) +
                                         'Chave de acesso: ' + nfe.ds-chave + CHR(10) +  CHR(13) + 
                                         '' + CHR(10) +  CHR(13) +
                                         'Este e-mail foi enviado automaticamente pelo Sistema de Nota Fiscal Eletr“nica (NF-e) da INTELBRAS SA' +
                                         '' + CHR(10) +  CHR(13) +
                                         'Instru‡äes para o recebimento do produto:' +
                                         '' + CHR(10) +  CHR(13) +
                                         'No momento da entrega, antes de assinar o canhoto da nota fiscal, ' +
                                         '' + CHR(10) +  CHR(13) +
                                         'abra as embalagens e confira as condi‡äes externas dos produtos. '  +
                                         '' + CHR(10) +  CHR(13) +
                                         'Se notada qualquer irregularidade, recuse o recebimento e' +
                                         '' + CHR(10) +  CHR(13) + 
                                         'descreva o motivo no verso da nota ou se preferir entre em contato com representante da sua regiÆo.'

            tt-envio.importancia       = 2
            tt-envio.log-enviada       = no
            tt-envio.log-lida          = no
            tt-envio.acomp             = no.



        IF opsys <> "WIN32" THEN
           ASSIGN tt-envio.arq-anexo         = REPLACE(nfe-param.end-imp-nfe-unix,"insercao/saida","idanfe") + "/" + TRIM(string(nfe.ds-chave)) + ".pdf".
        ELSE
           ASSIGN tt-envio.arq-anexo         = REPLACE(nfe-param.end-imp-nfe,"insercao~\saida","idanfe") + "~\" + TRIM(string(nfe.ds-chave)) + ".pdf"   .


        IF opsys <> "WIN32" THEN DO:
              IF  SEARCH(nfe-param.end-imp-nfe-unix + "/" + TRIM(string(nfe.ds-chave)) + ".xml") <> ? THEN
                  ASSIGN tt-envio.arq-anexo         = tt-envio.arq-anexo + "," + nfe-param.end-imp-nfe-unix + "/" + TRIM(string(nfe.ds-chave)) + ".xml".
              ELSE
                  IF SEARCH(nfe-param.end-imp-nfe-unix + "/backup/" + TRIM(string(nfe.ds-chave)) + ".xml") <> ? THEN
                     ASSIGN tt-envio.arq-anexo         = tt-envio.arq-anexo + "," + nfe-param.end-imp-nfe-unix + "/backup/" + TRIM(string(nfe.ds-chave)) + ".xml".
                  ELSE
                      IF  SEARCH(nfe-param.end-imp-nfe-unix + "/" + nota-fiscal.serie + "_" + string(int(nota-fiscal.nr-nota-fis)) + ".xml") <> ? THEN
                          ASSIGN tt-envio.arq-anexo         = tt-envio.arq-anexo + "," + nfe-param.end-imp-nfe-unix + "/" + nota-fiscal.serie + "_" + string(int(nota-fiscal.nr-nota-fis)) + ".xml".
                      ELSE
                          IF SEARCH(nfe-param.end-imp-nfe-unix + "/backup/" + nota-fiscal.serie + "_" + string(int(nota-fiscal.nr-nota-fis)) + ".xml") <> ? THEN
                             ASSIGN tt-envio.arq-anexo         = tt-envio.arq-anexo + "," + nfe-param.end-imp-nfe-unix + "/backup/" + nota-fiscal.serie + "_" + string(int(nota-fiscal.nr-nota-fis)) + ".xml".
        END.
        ELSE
              IF  SEARCH(nfe-param.end-imp-nfe + "~\" + TRIM(string(nfe.ds-chave)) + ".xml") <> ? THEN
                  ASSIGN tt-envio.arq-anexo         = tt-envio.arq-anexo + "," + nfe-param.end-imp-nfe + "~\" + TRIM(string(nfe.ds-chave)) + ".xml".
              ELSE
                  IF SEARCH(nfe-param.end-imp-nfe + "~\backup~\" + TRIM(string(nfe.ds-chave))+ ".xml") <> ? THEN
                     ASSIGN tt-envio.arq-anexo         = tt-envio.arq-anexo + "," + nfe-param.end-imp-nfe + "~\backup~\" + TRIM(string(nfe.ds-chave)) + ".xml".
                  ELSE
                      IF  SEARCH(nfe-param.end-imp-nfe + "~\" + nota-fiscal.serie + "_" + string(int(nota-fiscal.nr-nota-fis)) + ".xml") <> ? THEN
                          ASSIGN tt-envio.arq-anexo         = tt-envio.arq-anexo + "," + nfe-param.end-imp-nfe + "~\" + nota-fiscal.serie + "_" + string(int(nota-fiscal.nr-nota-fis)) + ".xml".
                      ELSE
                          IF SEARCH(nfe-param.end-imp-nfe + "~\backup~\" + nota-fiscal.serie + "_" + string(int(nota-fiscal.nr-nota-fis)) + ".xml") <> ? THEN
                             ASSIGN tt-envio.arq-anexo         = tt-envio.arq-anexo + "," + nfe-param.end-imp-nfe + "~\backup~\" + nota-fiscal.serie + "_" + string(int(nota-fiscal.nr-nota-fis)) + ".xml".



    

    /*         IF SEARCH(REPLACE(nfe-param.end-imp-nfe,'insercao~\~saida','idanfe') + '/' + TRIM(string(NFE.ds-chave)) + '.pdf') <> ? THEN                             */
    /*             ASSIGN tt-envio.arq-anexo         = nfe-param.end-imp-nfe + '/' + nota-fiscal.serie + '_' + string(int(nota-fiscal.nr-nota-fis)) + '.xml' + ',' + */
    /*                                                 REPLACE(nfe-param.end-imp-nfe,'insercao\~saida','idanfe') + '/' + TRIM(string(NFE.ds-chave)) + '.pdf'.         */
    /*         ELSE                                                                                                                                                  */
    /*             ASSIGN tt-envio.arq-anexo         = nfe-param.end-imp-nfe + '/' + nota-fiscal.serie + '_' + string(int(nota-fiscal.nr-nota-fis)) + '.xml' + ',' + */
    /*                                                 REPLACE(nfe-param.end-imp-nfe,'insercao\~saida','danfe') + '/' + TRIM(string(NFE.ds-chave)) + '.pdf'.          */





        IF tt-envio.arq-anexo = "" THEN
            ASSIGN tt-envio.assunto = 'NFE AUTORIZADA - NAO ENVIADA'
                   tt-envio.mensagem = c-email-destino + CHR(10) +  CHR(13) + tt-envio.mensagem
                   tt-envio.destino  = "anderson.cenci@intelbras.com.br".
        ELSE
            ASSIGN tt-envio.destino = trim(c-email-destino) + "," + IF AVAIL transporte AND transporte.e-mail <> "" THEN trim(transporte.e-mail) ELSE "".


        /* API de envio de e-mail */    
        run utp/utapi009.p (input  table tt-envio,
                            output table tt-erros).

        /* Elimina a tabela temporaria para envio do e-mail */
        delete tt-envio.                                       

        IF opsys <> 'WIN32' THEN
            RUN piRenameArquivo (input nfe-param.end-imp-nfe-unix + '/' + nota-fiscal.serie + '_' + string(int(nota-fiscal.nr-nota-fis)) + '.xml', 
                                INPUT nfe-param.end-imp-nfe-unix + '/backup/' + nota-fiscal.serie + '_' + string(int(nota-fiscal.nr-nota-fis)) + '.xml').                        

        else     
            RUN piRenameArquivo (input nfe-param.end-imp-nfe + '~\' + nota-fiscal.serie + '_' + string(int(nota-fiscal.nr-nota-fis)) + '.xml', 
                                INPUT nfe-param.end-imp-nfe + '~\backup~\' + nota-fiscal.serie + '_' + string(int(nota-fiscal.nr-nota-fis)) + '.xml').                        
        FOR EACH tt-envio:
            DELETE tt-envio.
        END.

    END.
    
END PROCEDURE.

PROCEDURE ImportaArquivo:
   
REPEAT:
   
    CREATE tt-import.
    IMPORT DELIMITER ";" tt-import NO-ERROR.
 
    ASSIGN 
        iLinha             = iLinha + 1
        tt-import.iLinha   = iLinha.
       
    IF AVAIL tt_file THEN
       ASSIGN tt-import.FullPath = TT_File.FullPath
              tt-import.FILENAME = TT_File.FILENAME.
END.


INPUT CLOSE.

END PROCEDURE.
