
{include/i-prgvrs.i esftp0527 2.00.00.000}
{utp/ut-glob.i}
{cdp/cdcfgdis.i}   
{esp/es0018.i}

DEFINE INPUT PARAM pNota   AS CHAR   NO-UNDO.
DEFINE INPUT PARAM pSerie  AS CHAR   NO-UNDO.
DEFINE INPUT PARAM pEstab  AS CHAR   NO-UNDO.
DEFINE OUTPUT PARAM pDanfe AS CHAR NO-UNDO.
DEFINE OUTPUT PARAM pXml   AS CHAR NO-UNDO.

DEFINE VAR c-arquivo-log2 AS CHAR NO-UNDO.

ASSIGN c-arquivo-log2 = '/mnt/spool/log-danfe-xml/' + pNota + '-esftp0529.txt'.

RUN pi-gerar-dados-extrato ('dentro esftp0529 - 1 ').

DEFINE VAR c-caminho-danfe AS CHAR NO-UNDO.
DEFINE VAR c-caminho-xml-nota   AS CHAR NO-UNDO.
DEFINE VAR c-caminho-danfe-nota AS CHAR NO-UNDO.
DEFINE VAR pCaminhoDanfe        AS CHAR NO-UNDO.

DEFINE VARIABLE encdmptr-danfe AS MEMPTR   NO-UNDO.
DEFINE VARIABLE encdlngc-danfe AS LONGCHAR NO-UNDO.

DEFINE VARIABLE encdmptr-xml AS MEMPTR   NO-UNDO.
DEFINE VARIABLE encdlngc-xml AS LONGCHAR NO-UNDO.

DEFINE TEMP-TABLE tt-historico-xml NO-UNDO
       FIELD dta-historico     AS CHARACTER FORMAT "X(022)" LABEL "Data Criaá∆o":U
       FIELD des-historico     AS CHARACTER FORMAT "X(020)" LABEL "Tipo XML":U
       FIELD cod-arquivo-xml   AS CHARACTER FORMAT "X(200)" LABEL "Arquivo XML":U
       INDEX idx-dta dta-historico DESCENDING.

DEFINE TEMP-TABLE tt-histor-tag NO-UNDO LIKE histor-tag 
    FIELD dt-formated AS CHARACTER FORMAT "x(19)".

DEFINE TEMP-TABLE tt-histor-tag-filtered NO-UNDO LIKE histor-tag
    FIELD cod-tipo-operacao AS CHARACTER FORMAT "x(20)".

DEFINE TEMP-TABLE tt-histor-tag-complete NO-UNDO LIKE histor-tag.

DEFINE VAR raw-param AS RAW NO-UNDO.
DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.

def temp-table tt-param
    field destino              as integer
    field destino-bloq         as integer
    field arquivo              as char
    field arquivo-bloq         as char
    field usuario              as char
    field data-exec            as date
    field hora-exec            as integer
    field parametro            as logical
    field formato              as integer
    field cod-layout           as character
    field des-layout           as character
    field log-impr-dados       as logical  
    field v_num_tip_aces_usuar as integer
&IF "{&mguni_version}" >= "2.071" &THEN
    field ep-codigo            LIKE mgcad.empresa.ep-codigo
&ELSE
    field ep-codigo            as integer
&ENDIF
    field da-dt-saida          like movdis.nota-fiscal.dt-saida
    field c-hr-saida           AS CHAR FORMAT "xx:xx:xx":U INITIAL "000000"
    field banco                as integer
    field cod-febraban         as integer      
    field cod-portador         as integer      
    field prox-bloq            as char         
    field c-instrucao          as char extent 5
    field imprime-bloq         as logical
    field rs-imprime           as integer
    FIELD impressora-so        AS CHAR
    FIELD impressora-so-bloq   AS CHAR
    FIELD nr-copias            AS INTEGER
    FIELD l-gera-danfe-xml     AS LOGICAL
    FIELD c-dir-hist-xml       AS CHARACTER
    FIELD ind-execucao         AS INT
    FIELD data-ini             AS DATE
    FIELD data-fim             AS DATE 
    FIELD nr-nota-fis          AS CHAR
    FIELD serie                AS CHAR
    FIELD cod-estabel          AS CHAR. 

DEFINE TEMP-TABLE tt-digita NO-UNDO
       FIELD cod-estabel       LIKE nota-fiscal.cod-estabel
       FIELD serie             like nota-fiscal.serie
       FIELD nr-nota-fis       LIKE nota-fiscal.nr-nota-fis
       FIELD cdd-embarq        like nota-fiscal.cdd-embarq COLUMN-LABEL "Embarque".

 EMPTY TEMP-TABLE tt-param.

 CREATE tt-param.
 ASSIGN tt-param.usuario              = c-seg-usuario
        tt-param.destino              = 2
        tt-param.data-exec            = today
        tt-param.hora-exec            = time
        tt-param.v_num_tip_aces_usuar = v_num_tip_aces_usuar
        tt-param.ep-codigo            = i-ep-codigo-usuario
        tt-param.da-dt-saida          = date("")
        tt-param.c-hr-saida           = ""
        tt-param.nr-copias            = 1
        tt-param.imprime-bloq         = NO
        tt-param.rs-imprime           = 1
        tt-param.impressora-so        = ""
        tt-param.impressora-so-bloq   = ""
        tt-param.l-gera-danfe-xml     = NO
        tt-param.c-dir-hist-xml       = ""
        tt-param.cod-layout           = "" /*Popula no rp*/
        tt-param.ind-execucao         = 1
        tt-param.data-ini             = ?
        tt-param.data-fim             = ?
        tt-param.nr-nota-fis          = pNota //"1877391"
        tt-param.serie                = pSerie //"1"
        tt-param.cod-estabel          = pEstab. //"104".


ASSIGN tt-param.arquivo = "esftp0528.txt". 

raw-transfer tt-param to raw-param.

EMPTY TEMP-TABLE tt-prog-ponto.

IF OPSYS = "UNIX" THEN DO:
   RUN esp/es0018p.p (INPUT  'cdapi590',
                      INPUT  1,
                      INPUT  0,
                      INPUT  "":U,
                      OUTPUT TABLE tt-prog-ponto).
END.
ELSE DO: //DIRETORIO WINDOWS
    RUN esp/es0018p.p (INPUT  'cdapi590',
                       INPUT  2,
                       INPUT  0,
                       INPUT  "":U,
                       OUTPUT TABLE tt-prog-ponto).
END.
FIND FIRST tt-prog-ponto .

RUN pi-gerar-dados-extrato ('dentro esftp0529 - 2 ').

//RUN pi-busca-danfe-nota(INPUT rowid(nota-fiscal),OUTPUT c-caminho-danfe-nota).
RUN pi-busca-danfe-nota(OUTPUT c-caminho-danfe-nota). 

RUN pi-gerar-dados-extrato ('dentro esftp0529 - 3 ').
RUN pi-gerar-dados-extrato (c-caminho-danfe-nota).

FIND FIRST nota-fiscal NO-LOCK
     WHERE nota-fiscal.nr-nota-fis = pNota  
       AND nota-fiscal.serie       = pSerie 
       AND nota-fiscal.cod-estabel = pEstab NO-ERROR.


RUN pi-busca-xml-nota (INPUT rowid(nota-fiscal),
                       OUTPUT c-caminho-xml-nota). 

RUN pi-gerar-dados-extrato ('dentro esftp0529 - 4.09 ').
RUN pi-gerar-dados-extrato (c-caminho-xml-nota).
RUN pi-gerar-dados-extrato (c-caminho-danfe-nota).
RUN pi-gerar-dados-extrato ('dentro esftp0529 - 4.10 ').

ASSIGN pDanfe = c-caminho-danfe-nota
       pXml   = c-caminho-xml-nota.

//RUN pi-converte-arquivos.

PROCEDURE pi-busca-danfe-nota:

    DEFINE OUTPUT PARAM pCaminhoDanfe AS CHAR NO-UNDO.

     RUN pi-gerar-dados-extrato ('dentro esftp0529 - 4.0 antes esftp0527 ').

    run esp/ftp/esftp0527rp.p (input raw-param, 
                               input table tt-raw-digita).

    RUN pi-gerar-dados-extrato ('dentro esftp0529 - 4.1 retorno esftp0527 ').
    RUN pi-gerar-dados-extrato ('pEstab -  ' + pEstab).
    RUN pi-gerar-dados-extrato ('pSerie -  ' + pSerie).
    RUN pi-gerar-dados-extrato ('pNota -  ' + pNota).
    
    FIND FIRST nota-fiscal 
         WHERE nota-fiscal.cod-estabel = pEstab
           AND nota-fiscal.serie       = pSerie
           AND nota-fiscal.nr-nota-fis = pNota  NO-LOCK NO-ERROR.

   RUN pi-gerar-dados-extrato ('dentro esftp0529 - 4.1 ' + string(AVAIL(nota-fiscal))).

    FIND FIRST param-gener NO-LOCK
         WHERE param-gener.cod-chave-1 = "param-geral-tc"
           AND param-gener.cod-param   = "dir-arquivos" NO-ERROR.
    IF AVAIL param-gener THEN DO:

        RUN pi-gerar-dados-extrato ('gerando danfe 11').
        RUN pi-gerar-dados-extrato (param-gener.cod-valor).

        /*ASSIGN c-caminho-danfe = '/mnt/neogrid/homologacao'  //param-gener.cod-valor
               c-caminho-danfe = REPLACE(c-caminho-danfe,"\","/").*/

        ASSIGN c-caminho-danfe = tt-prog-ponto.conteudo  //param-gener.cod-valor
               c-caminho-danfe = REPLACE(c-caminho-danfe,"\","/").
         
        RUN pi-gerar-dados-extrato ('gerando danfe 22').

        RUN pi-gerar-dados-extrato (c-caminho-danfe).

         /*Se j† gerou o pdf desconsidera*/
         IF SEARCH(TRIM(c-caminho-danfe) + "/DANFE/" + nota-fiscal.cod-chave-aces-nf-eletro + ".pdf") = ? THEN 
             ASSIGN pCaminhoDanfe = "Nao encontrado danfe da nota".
         ELSE
             ASSIGN pCaminhoDanfe = TRIM(c-caminho-danfe) + "/DANFE/" + nota-fiscal.cod-chave-aces-nf-eletro + ".pdf". 

         RUN pi-gerar-dados-extrato ('gerando danfe 33').
         RUN pi-gerar-dados-extrato (pCaminhoDanfe).

        /*IF SEARCH(TRIM("v:\ti\marcio") + "\DANFE\" + nota-fiscal.cod-chave-aces-nf-eletro + ".pdf") = ? THEN 
             ASSIGN pCaminhoDanfe = "Nao encontrado danfe da nota".
         ELSE
             ASSIGN pCaminhoDanfe = TRIM("v:\ti\marcio") + "\DANFE\" + nota-fiscal.cod-chave-aces-nf-eletro + ".pdf". */
    END.


END PROCEDURE.


PROCEDURE pi-busca-xml-nota:

   DEF INPUT  PARAM p-rowid-nota  AS ROWID  NO-UNDO.
   DEF OUTPUT PARAM p-caminho-xml AS CHAR   NO-UNDO. 

   RUN pi-gerar-dados-extrato ('xml - 1 ' + STRING(p-rowid-nota)).

   DEFINE VARIABLE h-bodi135na   AS HANDLE  NO-UNDO.
   DEFINE VARIABLE h-bodi520     AS HANDLE  NO-UNDO.
   
   DEFINE VARIABLE c-key               AS CHARACTER NO-UNDO.
   DEFINE VARIABLE l-utiliza-docto-tag AS LOGICAL   NO-UNDO.
   
   DEFINE VARIABLE c-estab AS CHARACTER   NO-UNDO.
       
   DEFINE VARIABLE c-cod-dir-histor-xml       AS CHARACTER   NO-UNDO.
   DEFINE VARIABLE c-cod-caminho-xml          AS CHARACTER   NO-UNDO.
   DEFINE VARIABLE c-cod-dir-arq-xml-nfse     AS CHARACTER   NO-UNDO.
   DEFINE VARIABLE c-cod-dir-histor-xml-nfse  AS CHARACTER   NO-UNDO.
   DEFINE VARIABLE cChaveAcesso               AS CHARACTER   NO-UNDO.
   DEFINE VARIABLE cCodDocto                  AS CHARACTER   NO-UNDO.
   DEFINE VARIABLE cArquivoXML                AS CHARACTER   NO-UNDO.
   DEFINE VARIABLE cArquivoXMLCancel          AS CHARACTER   NO-UNDO.
   DEFINE VARIABLE cArquivoXMLInut            AS CHARACTER   NO-UNDO.
   DEFINE VARIABLE cDiretorioHistoricoXML     AS CHARACTER   NO-UNDO.
   DEFINE VARIABLE cFileName                  AS CHARACTER   NO-UNDO.
   DEFINE VARIABLE cPathName                  AS CHARACTER   NO-UNDO.
   DEFINE VARIABLE cTypeDesc                  AS CHARACTER   NO-UNDO.
   DEFINE VARIABLE cArquivoFinalTC2           AS CHARACTER   NO-UNDO.
   DEFINE VARIABLE tp-integ                   AS CHARACTER   NO-UNDO.
   
   DEFINE VARIABLE  rNotaFiscal AS ROWID       NO-UNDO.
   
   DEFINE VARIABLE c-serie AS CHARACTER     NO-UNDO.
   DEFINE VARIABLE c-nota-fisc AS CHARACTER NO-UNDO.

   RUN pi-gerar-dados-extrato("busca xml 1").


   IF NOT VALID-HANDLE (h-bodi520) THEN DO:
       RUN dibo/bodi520.p PERSISTENT SET h-bodi520.
       RUN openQueryStatic IN h-bodi520 (INPUT "Main":U).
   END.
   
   IF  NOT VALID-HANDLE(h-bodi135na) THEN DO:
       RUN dibo/bodi135na.p PERSISTENT SET h-bodi135na.
       RUN openQueryStatic IN h-bodi135na (INPUT "Main":U).
   END.


   FOR EACH tt-historico-xml: DELETE tt-historico-xml. END.
   FOR EACH tt-histor-tag-complete. DELETE tt-histor-tag-complete. END.
   
   // Busca a Nota Fiscal a partir do ROWID passado como parametro

   FIND FIRST nota-fiscal 
        WHERE ROWID(nota-fiscal) = p-rowid-nota NO-LOCK NO-ERROR.
   
   IF AVAIL nota-fiscal THEN
      ASSIGN c-estab     = nota-fiscal.cod-estabel
             c-serie     = nota-fiscal.serie
             rNotaFiscal = ROWID(nota-fiscal).
   
   RUN pi-gerar-dados-extrato("busca xml 2").
   
   RUN repositionRecord IN h-bodi135na (INPUT rNotaFiscal).

   RUN pi-gerar-dados-extrato("busca xml 3").
   
   RUN getCharField     IN h-bodi135na (INPUT  "cod-chave-aces-nf-eletro":U,
                                        OUTPUT cChaveAcesso).

   RUN pi-gerar-dados-extrato("busca xml 4").
   RUN getCharField     IN h-bodi135na (INPUT  "cod-estabel":U,
                                        OUTPUT c-estab).

   RUN pi-gerar-dados-extrato("busca xml 5").
   RUN getCharField     IN h-bodi135na (INPUT  "serie":U,
                                        OUTPUT c-serie).

   RUN pi-gerar-dados-extrato("busca xml 6").
   RUN getCharField     IN h-bodi135na (INPUT  "nr-nota-fis":U,
                                        OUTPUT c-nota-fisc).

   RUN pi-gerar-dados-extrato("busca xml 7").
   RUN getCharField     IN h-bodi135na (INPUT  "cod-rps":U,
                                        OUTPUT cCodDocto). 

   RUN pi-gerar-dados-extrato("marcio1" ).
   
   RUN goToKey          IN h-bodi520   (INPUT c-estab).
                                      
   RUN getCharField     IN h-bodi520   (INPUT  "cod-dir-histor-xml":U,
                                        OUTPUT c-cod-dir-histor-xml).
   RUN getCharField     IN h-bodi520   (INPUT  "cod-caminho-xml":U,
                                        OUTPUT c-cod-caminho-xml).
   RUN getCharField     IN h-bodi520   (INPUT  "cod-dir-arq-xml-nfse":U,
                                        OUTPUT c-cod-dir-arq-xml-nfse).
   RUN getCharField     IN h-bodi520   (INPUT  "cod-dir-histor-xml-nfse":U,
                                        OUTPUT c-cod-dir-histor-xml-nfse).
   FOR FIRST ser-estab
       WHERE ser-estab.cod-estab = c-estab
         AND ser-estab.serie     = c-serie no-lock:

       /* NFS-e */
       IF &IF '{&bf_dis_versao_ems}' >= '2.09':U &THEN
              ser-estab.log-emite-nf-serv-eletro
          &ELSE
              SUBSTRING(ser-estab.char-1,71,1) = "S":U
          &ENDIF
       THEN DO:

           RUN cdp/cd0360b.p (INPUT c-estab,
                              INPUT "NFS-e",
                              OUTPUT tp-integ).
       
           IF  tp-integ = 'TC2' THEN DO:
               
               FOR EACH param-gener NO-LOCK WHERE
                   param-gener.cod-chave-1 = "param-geral-tc" :
   
                   CASE param-gener.cod-param:
                       WHEN "dir-doctos-lidos":U THEN
                           ASSIGN cArquivoXML = param-gener.cod-valor. /*Pasta Received*/
               
                       WHEN "dir-arquivos":U THEN
                           ASSIGN cDiretorioHistoricoXML = param-gener.cod-valor. /*Pasta SENT*/
               
                   END CASE.
               
               END.
   
               IF (cArquivoXML            = ""
               OR  cDiretorioHistoricoXML = "") THEN NEXT.
   
               ASSIGN cArquivoXML            = replace(cArquivoXML,"~/","\")
                      cDiretorioHistoricoXML = replace(cDiretorioHistoricoXML,"~/","\").
               
               IF  SUBSTRING(cArquivoXML, LENGTH(cArquivoXML), 1) <> "\" THEN
                   ASSIGN cArquivoXML = cArquivoXML + "\".
               ASSIGN cArquivoXML = cArquivoXML + "RECEIVED\".
               
               IF  SUBSTRING(cDiretorioHistoricoXML, LENGTH(cDiretorioHistoricoXML), 1) <> "\" THEN
                   ASSIGN cDiretorioHistoricoXML = cDiretorioHistoricoXML + "\".
               ASSIGN cDiretorioHistoricoXML = cDiretorioHistoricoXML + "SENT\".
   
               IF  cCodDocto = "" THEN
                   ASSIGN cCodDocto = c-nota-fisc.
   
               FOR EACH integr-totvs-colab NO-LOCK 
                  WHERE (integr-totvs-colab.cod-edi   = "203" 
                     OR  integr-totvs-colab.cod-edi   = "204") 
                    AND  integr-totvs-colab.cod-docto = TRIM(c-serie) + STRING(DEC(cCodDocto),"999999999"):
       
                   ASSIGN cArquivoFinalTC2 = IF  integr-totvs-colab.cod-origem = 1 
                                                 THEN cDiretorioHistoricoXML + trim(ENTRY(2, integr-totvs-colab.cod-msg, "-"))
                                                 ELSE cArquivoXML + trim(ENTRY(2, integr-totvs-colab.cod-msg, "|")).
       
                    ASSIGN FILE-INFO:FILE-NAME = cArquivoFinalTC2.
                   IF  FILE-INFO:FULL-PATHNAME <> ? THEN DO:
                       CREATE tt-historico-xml.
                       ASSIGN tt-historico-xml.dta-historico    =  STRING(YEAR(integr-totvs-colab.dat-reg),  "9999") + "/" +
                                                                   STRING(MONTH(integr-totvs-colab.dat-reg), "99")   + "/" +
                                                                   STRING(DAY(integr-totvs-colab.dat-reg),   "99")   + " " +
                                                                   integr-totvs-colab.hra-reg
       
                              tt-historico-xml.des-historico    = IF  integr-totvs-colab.cod-origem = 1 
                                                                      THEN "ENV - ":U
                                                                      ELSE "RET - ":U
       
                              tt-historico-xml.cod-arquivo-xml  = cArquivoFinalTC2.
       
                       CASE integr-totvs-colab.cod-edi:
                           WHEN "203" THEN DO:
                                IF  integr-totvs-colab.cod-origem = 2 AND
                                    TRIM(ENTRY(1,integr-totvs-colab.cod-msg,"=")) = "100" THEN
                                    ASSIGN tt-historico-xml.des-historico = tt-historico-xml.des-historico + "Autorizaá∆o".
                                ELSE
                                    ASSIGN tt-historico-xml.des-historico = tt-historico-xml.des-historico + "Emiss∆o".
                           END.
                           WHEN "204" THEN DO:
                               ASSIGN tt-historico-xml.des-historico = tt-historico-xml.des-historico + "Cancelamento".
                           END.
                       END CASE.
       
                   END.
               END.
   
               FOR FIRST estabelec NO-LOCK
                   WHERE estabelec.cod-estabel = c-estab:
               END.
   
               FOR EACH integr-totvs-colab NO-LOCK 
                  WHERE (integr-totvs-colab.cod-edi   = "203" 
                     OR  integr-totvs-colab.cod-edi   = "204") 
                    AND  integr-totvs-colab.cod-docto = TRIM(STRING(estabelec.cgc, '99999999999999')) + TRIM(c-serie) + STRING(DEC(cCodDocto),"999999999"):
       
                   ASSIGN cArquivoFinalTC2 = IF  integr-totvs-colab.cod-origem = 1 
                                                 THEN cDiretorioHistoricoXML + trim(ENTRY(2, integr-totvs-colab.cod-msg, "-"))
                                                 ELSE cArquivoXML + trim(ENTRY(2, integr-totvs-colab.cod-msg, "|")).
       
                    ASSIGN FILE-INFO:FILE-NAME = cArquivoFinalTC2.
                   IF  FILE-INFO:FULL-PATHNAME <> ? THEN DO:
                       CREATE tt-historico-xml.
                       ASSIGN tt-historico-xml.dta-historico    =  STRING(YEAR(integr-totvs-colab.dat-reg),  "9999") + "/" +
                                                                   STRING(MONTH(integr-totvs-colab.dat-reg), "99")   + "/" +
                                                                   STRING(DAY(integr-totvs-colab.dat-reg),   "99")   + " " +
                                                                   integr-totvs-colab.hra-reg
       
                              tt-historico-xml.des-historico    = IF  integr-totvs-colab.cod-origem = 1 
                                                                      THEN "ENV - ":U
                                                                      ELSE "RET - ":U
       
                              tt-historico-xml.cod-arquivo-xml  = cArquivoFinalTC2.
       
                       CASE integr-totvs-colab.cod-edi:
                           WHEN "203" THEN DO:
                                IF  integr-totvs-colab.cod-origem = 2 AND
                                    TRIM(ENTRY(1,integr-totvs-colab.cod-msg,"=")) = "100" THEN
                                    ASSIGN tt-historico-xml.des-historico = tt-historico-xml.des-historico + "Autorizaá∆o".
                                ELSE
                                    ASSIGN tt-historico-xml.des-historico = tt-historico-xml.des-historico + "Emiss∆o".
                           END.
                           WHEN "204" THEN DO:
                               ASSIGN tt-historico-xml.des-historico = tt-historico-xml.des-historico + "Cancelamento".
                           END.
                       END CASE.
       
                   END.
               END.
           END.
           ELSE DO:
               /***** Busca XML Autorizaá∆o, Cancelamento e Inutilizaá∆o *****/
               IF  c-cod-dir-arq-xml-nfse <> "" THEN DO:
       
                   ASSIGN cArquivoXML = c-cod-dir-arq-xml-nfse
                          cArquivoXML = REPLACE(cArquivoXML,"~\","/").
       
                   IF  NOT SUBSTR(cArquivoXML, LENGTH(cArquivoXML), 1) = "/"  THEN
                       ASSIGN cArquivoXML = cArquivoXML + "/".
       
                   ASSIGN cArquivoXML = TRIM(cArquivoXML)
                                      + TRIM(c-estab)
                                      + TRIM(c-serie)
                                      + TRIM(STRING(INTEGER(c-nota-fisc),">>9999999")).
       
       
                   ASSIGN cArquivoXMLCancel = cArquivoXML + "_Cancel":U + ".xml":U
                          cArquivoXMLInut   = cArquivoXML + "_Inut":U + ".xml":U
                          cArquivoXML       = cArquivoXML + ".xml":U.
               END.
               /** Fim - Busca XML Autorizaá∆o e Cancelamento **/
       
               /***** Busca Historico XML *****/
               IF  c-cod-dir-histor-xml-nfse <> "" THEN DO:
       
                   ASSIGN cDiretorioHistoricoXML = c-cod-dir-histor-xml-nfse
                          cDiretorioHistoricoXML = REPLACE(cDiretorioHistoricoXML,"~\","/").
       
                   IF  NOT SUBSTR(cDiretorioHistoricoXML, LENGTH(cDiretorioHistoricoXML), 1) = "/"  THEN
                       ASSIGN cDiretorioHistoricoXML = cDiretorioHistoricoXML + "/".
       
                   ASSIGN cDiretorioHistoricoXML = TRIM(cDiretorioHistoricoXML)
                                                 + TRIM(c-estab)
                                                 + TRIM(c-serie)
                                                 + TRIM(STRING(INTEGER(c-nota-fisc),">>9999999")).
               END.
               /** Fim - Busca Historico XML **/
           END.                                 
       END.
       ELSE DO:
           RUN pi-gerar-dados-extrato("busca xml 5 nfe").
           /* NF-e */
           IF &IF '{&bf_dis_versao_ems}' >= '2.07':U &THEN
                  ser-estab.log-nf-eletro
              &ELSE
                  TRIM(SUBSTRING(ser-estab.char-1,1,03)) = "yes":U
              &ENDIF
           THEN DO:
               
               RUN cdp/cd0360b.p (INPUT c-estab,
                                  INPUT "NF-e",
                                  OUTPUT tp-integ).
   
               IF  tp-integ = 'TC2' THEN DO:

                   RUN pi-gerar-dados-extrato("busca xml 6 nfe").
   
                   FOR EACH param-gener NO-LOCK WHERE
                       param-gener.cod-chave-1 = "param-geral-tc" :

                       RUN pi-gerar-dados-extrato("busca xml 7 nfe").
                   
                       CASE param-gener.cod-param:
                           WHEN "dir-doctos-lidos":U THEN
                               ASSIGN cArquivoXML = param-gener.cod-valor. /*Pasta Received*/
                   
                           WHEN "dir-arquivos":U THEN
                               ASSIGN cDiretorioHistoricoXML = param-gener.cod-valor. /*Pasta SENT*/
                   
                       END CASE.

                   END.

                   RUN pi-gerar-dados-extrato("busca xml 8 nfe").
                   RUN pi-gerar-dados-extrato(cArquivoXML).
                   RUN pi-gerar-dados-extrato("busca xml 9 nfe").
                   RUN pi-gerar-dados-extrato(cDiretorioHistoricoXML).
   
                   IF (cArquivoXML            = ""
                   OR  cDiretorioHistoricoXML = "") THEN NEXT.
   
                   ASSIGN cArquivoXML            = replace(cArquivoXML,"~\","/")
                          cDiretorioHistoricoXML = replace(cDiretorioHistoricoXML,"~\","/").

                   RUN pi-gerar-dados-extrato("busca xml 9.1 nfe").
                   RUN pi-gerar-dados-extrato(tt-prog-ponto.conteudo).

                   
                   /*ASSIGN  cArquivoXML            = "/mnt/neogrid/homologacao/NETWORK"
                           cDiretorioHistoricoXML = "/mnt/neogrid/homologacao".*/

                    ASSIGN cArquivoXML            = tt-prog-ponto.conteudo + "/NETWORK"
                           cDiretorioHistoricoXML = tt-prog-ponto.conteudo.

                   
                   IF  SUBSTRING(cArquivoXML, LENGTH(cArquivoXML), 1) <> "/" THEN
                       ASSIGN cArquivoXML = cArquivoXML + "/".
                   ASSIGN cArquivoXML = cArquivoXML + "RECEIVED/".
                   
                   IF  SUBSTRING(cDiretorioHistoricoXML, LENGTH(cDiretorioHistoricoXML), 1) <> "/" THEN
                       ASSIGN cDiretorioHistoricoXML = cDiretorioHistoricoXML + "/".
                   ASSIGN cDiretorioHistoricoXML = cDiretorioHistoricoXML + "SENT/".

                   RUN pi-gerar-dados-extrato("busca xml 10 nfe").
           
                   FOR EACH integr-totvs-colab NO-LOCK 
                      WHERE integr-totvs-colab.cod-edi >= "170" 
                        AND integr-totvs-colab.cod-edi <= "172" 
                        AND integr-totvs-colab.cod-docto = cChaveAcesso:

                       RUN pi-gerar-dados-extrato("busca xml 11 nfe").
           
                       ASSIGN cArquivoFinalTC2 = IF  integr-totvs-colab.cod-origem = 1 
                                                     THEN cDiretorioHistoricoXML + trim(ENTRY(2, integr-totvs-colab.cod-msg, "-"))
                                                     ELSE cArquivoXML + trim(ENTRY(2, integr-totvs-colab.cod-msg, "|")).


                       RUN pi-gerar-dados-extrato("busca xml 12 nfe"). 
                       RUN pi-gerar-dados-extrato(cArquivoFinalTC2).
                       RUN pi-gerar-dados-extrato("busca xml 13 nfe"). 
           
                                                          
                       
                       ASSIGN FILE-INFO:FILE-NAME = cArquivoFinalTC2.
                       IF  FILE-INFO:FULL-PATHNAME <> ? THEN DO:
                           CREATE tt-historico-xml.
                           ASSIGN tt-historico-xml.dta-historico    =  STRING(YEAR(integr-totvs-colab.dat-reg),  "9999") + "/" +
                                                                       STRING(MONTH(integr-totvs-colab.dat-reg), "99")   + "/" +
                                                                       STRING(DAY(integr-totvs-colab.dat-reg),   "99")   + " " +
                                                                       integr-totvs-colab.hra-reg
           
                                  tt-historico-xml.des-historico    = IF  integr-totvs-colab.cod-origem = 1 
                                                                          THEN "ENV - ":U
                                                                          ELSE "RET - ":U
           
                                  tt-historico-xml.cod-arquivo-xml  = cArquivoFinalTC2.
           
                           CASE integr-totvs-colab.cod-edi:
                               WHEN "170" THEN DO:
                                    IF  integr-totvs-colab.cod-origem = 2 AND
                                        TRIM(ENTRY(1,integr-totvs-colab.cod-msg,"=")) = "100" THEN
                                        ASSIGN tt-historico-xml.des-historico = tt-historico-xml.des-historico + "Autorizaá∆o".
                                    ELSE
                                        ASSIGN tt-historico-xml.des-historico = tt-historico-xml.des-historico + "Emiss∆o".
                               END.
                               WHEN "171" THEN DO:
                                   ASSIGN tt-historico-xml.des-historico = tt-historico-xml.des-historico + "Cancelamento".
                               END.
                               WHEN "172" THEN DO:
                                   ASSIGN tt-historico-xml.des-historico = tt-historico-xml.des-historico + "Inutilizaá∆o".
                               END.
                           END CASE.
                       END.
                   END.
               END.
               ELSE DO:
   
                   /***** Busca XML Autorizaá∆o, Cancelamento e Inutilizaá∆o *****/                                        
                   IF  c-cod-caminho-xml <> "" THEN DO:
       
                       ASSIGN cArquivoXML = c-cod-caminho-xml                                                             
                              cArquivoXML = REPLACE(cArquivoXML,"~\","/").                                                
       
                       IF  NOT SUBSTR(cArquivoXML, LENGTH(cArquivoXML), 1) = "/"  THEN                
                           ASSIGN cArquivoXML = cArquivoXML + "/".                                                        
       
                       ASSIGN cArquivoXML = TRIM(cArquivoXML)                                                             
                                          + TRIM(STRING(c-estab,"x(05)"))                                                
                                          + SUBSTR(cChaveAcesso,23,3)                                                     
                                          + TRIM(STRING(INTEGER(SUBSTR(cChaveAcesso,26,9)),">>9999999")).                
       
                       ASSIGN cArquivoXMLCancel = cArquivoXML + "_Cancel":U + ".xml":U
                              cArquivoXMLInut   = cArquivoXML + "_Inut":U + ".xml":U
                              cArquivoXML       = cArquivoXML + ".xml":U.
                   END.
                   /** Fim - Busca XML Autorizaá∆o e Cancelamento **/
       
                   /***** Busca Historico XML *****/
                   IF  c-cod-dir-histor-xml <> "" THEN DO:
       
                       ASSIGN cDiretorioHistoricoXML = c-cod-dir-histor-xml
                              cDiretorioHistoricoXML = REPLACE(cDiretorioHistoricoXML,"~\","/").
       
                       IF  NOT SUBSTR(cDiretorioHistoricoXML, LENGTH(cDiretorioHistoricoXML), 1) = "/"  THEN
                           ASSIGN cDiretorioHistoricoXML = cDiretorioHistoricoXML + "/".
       
                       ASSIGN cDiretorioHistoricoXML = TRIM(cDiretorioHistoricoXML)
                                                     + TRIM(STRING(c-estab,"x(05)"))
                                                     + SUBSTR(cChaveAcesso,23,3)
                                                     + TRIM(STRING(INTEGER(SUBSTR(cChaveAcesso,26,9)),">>9999999")).
                   END.
                   /** Fim - Busca Historico XML **/
               END.
           END.
       END.
   END.

   RUN pi-gerar-dados-extrato("busca xml 14").
   
   IF  tp-integ <> "TC2":U THEN DO:
       /***** Busca XML Autorizaá∆o, Cancelamento e Inutilizaá∆o *****/
       ASSIGN FILE-INFO:FILE-NAME = cArquivoXMLCancel.
       IF  FILE-INFO:FULL-PATHNAME <> ? THEN DO:
           CREATE tt-historico-xml.
           ASSIGN tt-historico-xml.dta-historico    =   STRING(YEAR(FILE-INFO:FILE-CREATE-DATE),"9999") + "/"
                                                      + STRING(MONTH(FILE-INFO:FILE-CREATE-DATE),"99")  + "/"
                                                      + STRING(DAY(FILE-INFO:FILE-CREATE-DATE),"99")    + " "
                                                      + STRING(FILE-INFO:FILE-CREATE-TIME,"HH:MM:SS")
                  tt-historico-xml.des-historico    = "Cancelamento":U
                  tt-historico-xml.cod-arquivo-xml  = FILE-INFO:FULL-PATHNAME.
       END.
       ASSIGN FILE-INFO:FILE-NAME = cArquivoXMLInut.
       IF  FILE-INFO:FULL-PATHNAME <> ? THEN DO:
           CREATE tt-historico-xml.
           ASSIGN tt-historico-xml.dta-historico    =   STRING(YEAR(FILE-INFO:FILE-CREATE-DATE),"9999") + "/"
                                                      + STRING(MONTH(FILE-INFO:FILE-CREATE-DATE),"99")  + "/"
                                                      + STRING(DAY(FILE-INFO:FILE-CREATE-DATE),"99")    + " "
                                                      + STRING(FILE-INFO:FILE-CREATE-TIME,"HH:MM:SS")
                  tt-historico-xml.des-historico    = "Inutilizaá∆o":U
                  tt-historico-xml.cod-arquivo-xml  = FILE-INFO:FULL-PATHNAME.
       END.
       ASSIGN FILE-INFO:FILE-NAME = cArquivoXML.
       IF  FILE-INFO:FULL-PATHNAME <> ? THEN DO:
           CREATE tt-historico-xml.
           ASSIGN tt-historico-xml.dta-historico    =   STRING(YEAR(FILE-INFO:FILE-CREATE-DATE),"9999") + "/"
                                                      + STRING(MONTH(FILE-INFO:FILE-CREATE-DATE),"99")  + "/"
                                                      + STRING(DAY(FILE-INFO:FILE-CREATE-DATE),"99")    + " "
                                                      + STRING(FILE-INFO:FILE-CREATE-TIME,"HH:MM:SS")
                  tt-historico-xml.des-historico    = "Autorizaá∆o":U
                  tt-historico-xml.cod-arquivo-xml  = FILE-INFO:FULL-PATHNAME.
       END.
       /** Fim - Busca XML Autorizaá∆o e Cancelamento **/
       
       /***** Busca Historico XML *****/
       ASSIGN FILE-INFO:FILE-NAME = cDiretorioHistoricoXML.
       IF  FILE-INFO:FULL-PATHNAME <> ? THEN DO: /* diretorio existe? */
           INPUT FROM OS-DIR(cDiretorioHistoricoXML) CONVERT TARGET "iso8859-1":U.
           REPEAT:
               IMPORT cFileName cPathName cTypeDesc.
               IF  cTypeDesc <> "D" THEN DO:
                   ASSIGN FILE-INFO:FILE-NAME = cPathName.
                   IF  FILE-INFO:FULL-PATHNAME <> ? THEN DO:
                       CREATE tt-historico-xml.
                       ASSIGN tt-historico-xml.dta-historico    =   STRING(YEAR(FILE-INFO:FILE-CREATE-DATE),"9999") + "/"
                                                                  + STRING(MONTH(FILE-INFO:FILE-CREATE-DATE),"99")  + "/"
                                                                  + STRING(DAY(FILE-INFO:FILE-CREATE-DATE),"99")    + " "
                                                                  + STRING(FILE-INFO:FILE-CREATE-TIME,"HH:MM:SS")
                              tt-historico-xml.des-historico    = "Hist¢rico":U
                              tt-historico-xml.cod-arquivo-xml  = FILE-INFO:FULL-PATHNAME.
                   END.
               END.
           END.
       END.
       /** Fim - Busca Historico XML **/
   END.
   
   /* Tratamentos para a aba Hist. Tag */
   IF CAN-FIND(FIRST estabelec
               WHERE estabelec.cod-estabel = c-estab
                 AND estabelec.log-utiliza-docto-tag = YES) THEN DO:

       RUN pi-gerar-dados-extrato("busca xml 5.3").
       
       ASSIGN c-key = c-estab + "|" + c-serie + "|" + c-nota-fisc
              l-utiliza-docto-tag = YES.
   
       FOR EACH histor-tag NO-LOCK
          WHERE histor-tag.nom-tab-histor-tag = "nota-fiscal"
            AND histor-tag.cod-histor-tag = c-key
            BREAK BY histor-tag.cdn-seq-histor-tag:
   
           IF LAST-OF(histor-tag.cdn-seq-histor-tag) THEN DO:
               CREATE tt-histor-tag.
               BUFFER-COPY histor-tag TO tt-histor-tag
               ASSIGN tt-histor-tag.dt-formated = STRING(tt-histor-tag.dtm-histor-tag).
           END.
   
           CREATE tt-histor-tag-complete.
           BUFFER-COPY histor-tag TO tt-histor-tag-complete.
           RUN pi-gerar-dados-extrato("busca xml 5.2").
       END.
   END.

   FOR EACH tt-historico-xml
       WHERE tt-historico-xml.des-historico MATCHES 'RET - Autoriza*':

       RUN pi-gerar-dados-extrato("busca xml 5.1").

       ASSIGN p-caminho-xml = tt-historico-xml.cod-arquivo-xml.
   END.

   RUN pi-gerar-dados-extrato("busca xml 5").
   RUN pi-gerar-dados-extrato("EU ").
   RUN pi-gerar-dados-extrato(STRING(p-caminho-xml)).
      
END PROCEDURE.

/*PROCEDURE pi-converte-arquivos:

    RUN pi-gerar-dados-extrato ('dentro esftp0529 - 7 ').
   
    IF c-caminho-danfe-nota <> "" THEN DO:
       COPY-LOB FROM FILE c-caminho-danfe-nota TO encdmptr-danfe.
       encdlngc-danfe = BASE64-ENCODE(encdmptr-danfe).
    END.

    RUN pi-gerar-dados-extrato ('dentro esftp0529 - 8 ').

    IF c-caminho-xml-nota <> "" THEN DO:
       COPY-LOB FROM FILE c-caminho-xml-nota TO encdmptr-xml.
       encdlngc-xml = BASE64-ENCODE(encdmptr-xml).

        RUN pi-gerar-dados-extrato ('dentro esftp0529 - 9 ').
       
    END.

    RUN pi-gerar-dados-extrato ('dentro esftp0529 - 10 ').
    RUN pi-gerar-dados-extrato ('dentro esftp0529 - 11 ' + c-caminho-xml-nota).
    RUN pi-gerar-dados-extrato ('dentro esftp0529 - 12 ' + c-caminho-danfe-nota).

    ASSIGN pDanfe = encdmptr-danfe
           pXML   = encdlngc-xml. //encdmptr-xml. 



END PROCEDURE.
 */

PROCEDURE pi-gerar-dados-extrato:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAM p-string AS CHAR NO-UNDO.
            
    IF c-arquivo-log2 <> "" AND c-arquivo-log2 <> ? THEN DO:
       OUTPUT TO VALUE(c-arquivo-log2) APPEND.
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-ponto-executado AS CHARACTER FORMAT "X(24)" NO-UNDO.
            
            PUT  p-string  FORMAT "x(200)" SKIP.
       OUTPUT CLOSE. 
    
    end.
END PROCEDURE.
