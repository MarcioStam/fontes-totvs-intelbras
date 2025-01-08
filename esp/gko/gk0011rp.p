/********************************************************************************
** Copyright Intelbras S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da Intelbras, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i gk0011rp 2.00.00.000}  /*** 010000 ***/
/*******************************************************************************
**  Programa: GK0011RP
**  Objetivo: <comment>
**  Autor...: Francisco Almeida Franªa    
**  Data....: 04.11.2013 16:11
*******************************************************************************/
{include/i-rpvar.i}
{include/i-freeac.i}

{utp/utapi019.i}

DEFINE VARIABLE c-linha AS CHARACTER   NO-UNDO.
DEF VAR da-prev AS DATE INIT ? NO-UNDO.

define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9":U
    field exemplo          as character format "x(30)":U
    index id ordem.

def temp-table tt-raw-digita
    field raw-digita       as raw.

define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field desc-classifica  as char format "x(40)":U
    field modelo           AS char format "x(35)":U
    /*Alterado 15/02/2005 - tech1007 - Criado campo l¢gico para verificar se o RTF foi habilitado*/
    field l-habilitaRtf    as LOG
    /*Fim alteracao 15/02/2005*/
    FIELD tipo-data        AS INTEGER.
    
DEF input parameter raw-param as raw no-undo.
DEF input parameter table for tt-raw-digita.

FIND LAST param-global NO-LOCK NO-ERROR.

create tt-param.
raw-transfer raw-param to tt-param.

assign c-programa     = "GK0011"
       c-sistema      = "Atualiza Data Entrega/Devolucao Notas Fiscais"
       c-titulo-relat = "Atualiza Data Entrega/Devolucao Notas Fiscais"
       c-versao       = "2.00.00"
       c-revisao      = "000"
       c-empresa      = "Intelbras".

{include/i-rpout.i}
{include/i-rpcab.i}

DEF VAR c-caminho            AS CHARACTER NO-UNDO.
DEF VAR c-caminho-backup     AS CHARACTER NO-UNDO.
DEF VAR i-flag               AS INTEGER NO-UNDO.
DEFINE VARIABLE h-acomp      AS HANDLE NO-UNDO.
DEF VAR c-cabecalho          AS CHARACTER NO-UNDO.
DEFINE VARIABLE dt-infor-cli AS CHARACTER NO-UNDO.
DEF VAR d-dt-infor-cli         AS DATE INIT ?.
DEF VAR l-alterou-data       AS LOG NO-UNDO.

DEFINE TEMP-TABLE ttNota-Fiscal
    FIELD tt-companhia    AS CHARACTER
    FIELD tt-nome-transp  AS CHARACTER 
    FIELD tt-num-nota     AS CHARACTER
    FIELD tt-dt-entr-cli  AS CHARACTER
    FIELD tt-dt-prev-cli  AS CHARACTER 
    FIELD tt-desc-entrega AS CHARACTER
    FIELD tt-serie        AS CHARACTER
    FIELD tt-cod-emitente AS CHARACTER
    FIELD tt-cod-estabel  AS CHARACTER FORMAT "x(3)"
    FIELD tipoDt          AS INTEGER.

/*}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}IMPORTA∞ÄO DE ARQUIVOS{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{*/

/*OUTPUT TO c:/temp/Relatorio_Entrega.txt.*/

FIND FIRST tt-param NO-LOCK NO-ERROR.

/* 1 - Busca o caminho onde estˇ o arquivo a ser lido.******************************************/
FOR EACH ponto-programa
     WHERE ponto-programa.nome-programa = "gk0011" NO-LOCK:
      IF ponto-programa.ponto           = 1 THEN DO:
           FOR EACH conteudo-programa
                 WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa NO-LOCK:

               IF  OPSYS = "win32" THEN DO:
                   IF  conteudo-programa.sequencia = 1 THEN DO:
                       assign c-caminho = conteudo-programa.conteudo.
                       /*PUT UNFORMATTED "DIRETÖRIO DOS ARQUIVOS: " + c-caminho SKIP. */
                   END.
               END.
               ELSE
                   IF  conteudo-programa.sequencia = 2 THEN DO:
                       assign c-caminho = conteudo-programa.conteudo.
                       /*PUT UNFORMATTED "DIRETÖRIO DOS ARQUIVOS: " + c-caminho SKIP.*/
                   END.

           END.
      END.
      ELSE DO:
           FOR EACH conteudo-programa
                 WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa NO-LOCK:

               IF  OPSYS = "win32" THEN DO:
                   IF  conteudo-programa.sequencia = 1 THEN DO:
                       assign c-caminho-backup = conteudo-programa.conteudo.
                       /*PUT UNFORMATTED c-caminho-backup SKIP.*/
                   END.
               END.
               ELSE
                   IF  conteudo-programa.sequencia = 2 THEN DO:
                       assign c-caminho-backup = conteudo-programa.conteudo.
                       /*PUT UNFORMATTED c-caminho-backup SKIP.*/
                   END.

           END.
      END.
END.
          

/*Armazena caminho, nome e tipo de arquivo na tabela TT_File*/
DEFINE TEMP-TABLE TT_File NO-UNDO 
    FIELD FILENAME AS CHARACTER /*Nome do arquivo*/
    FIELD FullPath AS CHARACTER /*Caminho do diretΩrio onde estˇ o arquivo*/
    FIELD FILE     AS CHARACTER. /*Tipo ou extensío do arquivo.*/
            
INPUT FROM OS-DIR(c-caminho) NO-ECHO.
           
PUT c-caminho FORMAT "x(100)" SKIP.

REPEAT:
    CREATE TT_File.
    IMPORT TT_File.FILENAME
           TT_File.FullPath
           TT_File.FILE.
/*     PUT TT_File.FILENAME FORMAT "x(50)"   */
/*         TT_File.FullPath FORMAT "x(50)"   */
/*         TT_File.FILE FORMAT "x(50)" SKIP. */
END.


RUN utp/ut-acomp.p PERSISTEN SET h-acomp.
RUN pi-inicializar IN h-acomp("Importaá∆o de notas arquivo GKO":U).

FOR EACH TT_File
   WHERE TT_File.FILE = 'F' NO-LOCK:
    /* AND SUBSTRING(TT_File.FILENAME,LENGTH(TT_File.FILENAME) - 2,3) = 'csv' NO-LOCK:*/

        INPUT FROM VALUE(TT_File.FullPath) CONVERT SOURCE "iso8859-1".
        /*PUT UNFORMATTED "IMPORTADO: " + TT_File.FullPath SKIP.*/
        
        /*Importa arquivos para tamp-table ttNota-Fiscal.*/
        ASSIGN i-flag = 0.
        REPEAT:
            ASSIGN i-flag = i-flag + 1.
            IF i-flag = 1 THEN
               IMPORT c-cabecalho. 
            ELSE DO:
                   IF i-flag > 1 THEN DO:
                       
                       IMPORT UNFORMATTED c-linha. /*A virgula serˇ o delimitador de campos.*/
                       /*Separa e armazena o n£mero da companhia.*/
                       /*PUT "Linha Lida: " c-linha FORMAT "X(500)" SKIP.*/

                       IF substring(c-linha,132,8) = "Sinistro" THEN NEXT.
                       FIND FIRST emitente 
                            WHERE emitente.cod-emitente = int(SUBSTRING(c-linha,11,6)) NO-LOCK NO-ERROR. 

                       IF NOT AVAIL emitente THEN DO:
                           PUT "Cliente nao encontrado " int(SUBSTRING(c-linha,11,6)) SKIP.
                           NEXT.
                       END.
                       FIND FIRST estabelec 
                            WHERE estabelec.cgc = emitente.cgc NO-LOCK NO-ERROR. 

                       IF NOT AVAIL estabelec THEN DO:
                           PUT "Estabelec nao encontrado " emitente.cgc SKIP.
                           
                           NEXT.
                       END.

                       CREATE ttNota-Fiscal.   /*Adiciona cada linha do arquivo na tabela ttNota-Fiscal*/
                       ASSIGN ttNota-Fiscal.tt-cod-emitente = SUBSTRING(c-linha,11,6). 
                       

                       IF substring(c-linha,132,6) = "Devolu" THEN
                           ASSIGN ttNota-Fiscal.tipoDt = 2.
                       ELSE 
                           ASSIGN ttNota-Fiscal.tipoDt = 1. 

                       /*Formata a data para o padr∆o brasileiro.*/
                       ASSIGN ttNota-Fiscal.tt-dt-entr-cli = substring(c-linha,91,10)
                              ttNota-Fiscal.tt-dt-prev-cli = substring(c-linha,106,10).
                       
                       /*Chamado 90309*/
                       ASSIGN dt-infor-cli   = SUBSTRING(c-linha,121,10).
                       ASSIGN d-dt-infor-cli = DATE(dt-infor-cli) NO-ERROR.

                       IF d-dt-infor-cli <> ? THEN DO:
                           IF DATE(ttNota-Fiscal.tt-dt-prev-cli) = ?
                           OR DATE(ttNota-Fiscal.tt-dt-prev-cli) < DATE(dt-infor-cli) THEN
                               ASSIGN ttNota-Fiscal.tt-dt-prev-cli = dt-infor-cli.
                       END.
                       
                       /*Separa e armazena o n£mero de sÇrie da nota.*/ 
                       ASSIGN ttNota-Fiscal.tt-serie = SUBSTRING(c-linha,75,1). 
        
                       /*Separa e armazena o n£mero da nota.*/
                       ASSIGN ttNota-Fiscal.tt-num-nota = string(int(SUBSTRING(c-linha,65,7)),"9999999").
                      
                       RUN pi-acompanhar IN h-acomp (INPUT "Importando do arquivo, nota fiscal: " + string(int(ttNota-Fiscal.tt-num-nota))).

                       PUT UNFORMATTED  "Informacao considerada: " + ttNota-Fiscal.tt-cod-emitente   " "  ttNota-Fiscal.tt-serie   " " ttNota-Fiscal.tt-num-nota " " 
                            string(ttNota-Fiscal.tt-dt-entr-cli  ) " "
                            " Data entrega "                            
                            string(ttNota-Fiscal.tt-dt-prev-cli)
                           SKIP.
                       ASSIGN ttNota-Fiscal.tt-cod-estabel = estabelec.cod-estabel.
                       
                   END.
            END.
        END. /*REPEAT*/

        OS-COPY VALUE(TT_File.FullPath) VALUE(c-caminho-backup).
        OS-DELETE VALUE(TT_File.FullPath).


END. /*FOR EACH*/
INPUT CLOSE. /*Fecha arquivo que estˇ sendo lido.*/                    
                    

FOR EACH ttNota-Fiscal NO-LOCK:
    FOR FIRST nota-fiscal 
        WHERE nota-fiscal.cod-estabel = ttNota-Fiscal.tt-cod-estabel
          AND nota-fiscal.serie       = ttNota-Fiscal.tt-serie
          AND nota-fiscal.nr-nota-fis = ttNota-Fiscal.tt-num-nota EXCLUSIVE-LOCK:

        IF ttNota-Fiscal.tipoDt = 1 THEN
            ASSIGN nota-fiscal.dt-entr-cli = DATE(ttNota-Fiscal.tt-dt-entr-cli).
    
        FIND FIRST int-nota-fiscal EXCLUSIVE-LOCK
             WHERE int-nota-fiscal.cod-estabel = nota-fiscal.cod-estabel
               AND int-nota-fiscal.serie       = nota-fiscal.serie
               AND int-nota-fiscal.nr-nota-fis = nota-fiscal.nr-nota-fis  NO-ERROR.
        IF AVAIL int-nota-fiscal THEN DO:

            IF SUBSTRING(int-nota-fiscal.char-1,50,10) <> ttNota-Fiscal.tt-dt-prev-cli THEN ASSIGN l-alterou-data = YES.
            ELSE ASSIGN l-alterou-data = NO.
    
            ASSIGN overlay(int-nota-fiscal.char-1,50,10) = ttNota-Fiscal.tt-dt-prev-cli. /* Previsao */
    
            IF  ttNota-Fiscal.tipoDt = 2 THEN DO:
                ASSIGN overlay(int-nota-fiscal.char-1,61,10) = ttNota-Fiscal.tt-dt-entr-cli. /* Devolucao */
            END.
            
            IF DATE(ttNota-Fiscal.tt-dt-prev-cli) <> ?
            AND nota-fiscal.dt-entr-cli = ?
            AND l-alterou-data THEN
                RUN pi-envia-mail (INPUT DATE(ttNota-Fiscal.tt-dt-prev-cli)).
            
        END.
        FIND CURRENT int-nota-fiscal NO-LOCK NO-ERROR.

        RUN pi-acompanhar IN h-acomp (INPUT "Atualizando nota-fiscal: " + string(int(nota-fiscal.nr-nota-fis))).
        
    END.
END. /*FOR EACH*/

run pi-finalizar in h-acomp.

{include/i-rpclo.i}

PROCEDURE pi-envia-mail:

    DEF INPUT PARAM p-dt-prev  AS DATE.

    DEFINE VARIABLE h-utapi019 AS HANDLE                    NO-UNDO.
    DEFINE VARIABLE c-arquivo  AS CHARACTER FORMAT "x(200)" NO-UNDO.
    DEFINE VARIABLE c-email-destino AS CHAR FORMAT "x(150)" NO-UNDO.

    FIND FIRST param-global NO-LOCK NO-ERROR.

    FIND estabelec NO-LOCK
        WHERE estabelec.cod-estabel = nota-fiscal.cod-estabel NO-ERROR.

    FIND FIRST param-gener NO-LOCK
         WHERE param-gener.cod-chave-1 = "param-geral-tc"
           AND param-gener.cod-param   = "dir-arquivos" NO-ERROR.

    FIND emitente NO-LOCK
        WHERE emitente.cod-emitente = nota-fiscal.cod-emitente NO-ERROR.

    IF  OPSYS = "UNIX" THEN DO:
        FOR FIRST ponto-programa NO-LOCK
        WHERE ponto-programa.nome-programa = "cdapi590"
          AND ponto-programa.ponto         = 1 
        ,FIRST conteudo-programa NO-LOCK
            WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:
    
         ASSIGN c-arquivo = conteudo-programa.conteudo + "/DANFE/" + trim(nota-fiscal.cod-chave-aces-nf-eletro) + ".pdf".
        
        END.
    END.
    ELSE
        ASSIGN c-arquivo = (TRIM(param-gener.cod-valor) + "\DANFE\" + trim(nota-fiscal.cod-chave-aces-nf-eletro) + ".pdf").

    IF  SEARCH(c-arquivo) = ? THEN 
        RETURN "OK".

    IF  CAN-FIND(FIRST cont-emit no-lock
                    WHERE cont-emit.cod-emitente = nota-fiscal.cod-emitente 
                      AND (cont-emit.nome BEGINS 'NFE' OR cont-emit.nome BEGINS 'NF-e')) THEN DO:
        ASSIGN c-email-destino = "".
        FOR EACH cont-emit no-lock
            WHERE cont-emit.cod-emitente = nota-fiscal.cod-emitente 
              AND (cont-emit.nome BEGINS 'NFE' OR cont-emit.nome BEGINS 'NF-e'):
           IF  c-email-destino = "" THEN
               ASSIGN c-email-destino = trim(cont-emit.e-mail).
           ELSE
               IF  NOT c-email-destino MATCHES trim(cont-emit.e-mail) THEN
                   ASSIGN c-email-destino = trim(c-email-destino) + ";" + trim(cont-emit.e-mail).
        END.
    END.

    IF  trim(c-email-destino) = "" THEN
        RETURN "OK".

    IF  NOT VALID-HANDLE(h-utapi019) THEN
        RUN utp/utapi019.p PERSISTENT SET h-utapi019.
            
    EMPTY TEMP-TABLE tt-envio2.
    EMPTY TEMP-TABLE tt-mensagem.

    CREATE tt-envio2.
    ASSIGN tt-envio2.versao-integracao = 1
           tt-envio2.servidor          = param-global.serv-mail
           tt-envio2.porta             = param-global.porta-mail
           tt-envio2.remetente         = "intelbras@intelbras.com.br"
           tt-envio2.destino           = c-email-destino
           tt-envio2.assunto           = "Previs∆o de entrega NF " + STRING(nota-fiscal.nr-nota-fis)
           tt-envio2.arq-anexo         = c-arquivo
           tt-envio2.formato           = "TEXTO".

    CREATE tt-mensagem.
    ASSIGN tt-mensagem.seq-mensagem = 1
           tt-mensagem.mensagem     = "Prezado Cliente, " + CHR(10) + 
                                      "Vocà est† recebendo uma PREVIS«O de entrega referente a NF " + nota-fiscal.nr-nota-fis + ". " +
                                      "Anexo encontra-se o arquivo PDF da seguinte Nota Fiscal: " + CHR(10) + CHR(10) +
                                      "N£mero:   " + nota-fiscal.nr-nota-fis + CHR(10) +
                                      "SÇrie:    " + nota-fiscal.serie + CHR(10) +
                                      "Embarque: " + (IF nota-fiscal.dt-saida <> ? THEN string(nota-fiscal.dt-saida, "99/99/9999") ELSE "-------") + CHR(10) +
                                      "Previs∆o Entrega: " + STRING(p-dt-prev, "99/99/9999") + CHR(10) +
                                      "Emissor: " + estabelec.cod-estab + " - " + estabelec.nome + " - " + estabelec.cgc + CHR(10) + 
                                      "Destinat†rio: " + emitente.nome-emit + " - " + emitente.cgc + CHR(10)+ CHR(10) + CHR(10) +
                                      "Instruá‰es para o recebimento do produto: Conferir os produtos de acordo com a cartilha de recebimento e se est∆o em perfeitas condiá‰es antes de assinar os canhotos. " + 
                                      "Se notada qualquer irregularidade, descreva o motivo no verso do conhecimento de transporte, " + 
                                      "ou se preferir entre em contato com representante da sua regi∆o." + CHR(10) + CHR(10) + 
                                      "N∆o responder este e-mail. E-mail gerado automaticamente.".

    IF  VALID-HANDLE(h-utapi019) THEN
        RUN pi-execute2 IN h-utapi019 (INPUT  TABLE tt-envio2,
                                       INPUT  TABLE tt-mensagem,
                                       OUTPUT TABLE tt-erros).

    IF  VALID-HANDLE(h-utapi019) THEN
        DELETE PROCEDURE h-utapi019.

    ASSIGN h-utapi019 = ?.

    RETURN "OK".
END.

RETURN "OK".

