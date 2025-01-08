{include/i-prgvrs.i ESFTP065 2.04.00.001}
/***********************************************************************
**  Programa..: ESP\FTP\ESFTP065RP.P
**  Autor.....: Marcio Chaves - Gestech
**  Data......: NOVEMBRO/2004 - Desenvolvimento
**  Descricao.: Relatorio de Vendas
**              Convers∆o do programa es0520.p - Claudiney
**  Vers∆o....: 001 11/11/2004
**                  Desenvolvimento Programa
************************************************************************/

{utp/ut-glob.i}
{esp/ftp/ESFTP065tt.i}
{include/i-rpvar.i}
{eqp/eqapi300.i}
{cdp/cd0667.i}

DEF INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEF INPUT PARAMETER TABLE FOR tt-raw-digita.
DEF VAR l-volta                     AS LOG.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

FOR EACH tt-raw-digita:
    CREATE tt-digita.
    RAW-TRANSFER tt-raw-digita.raw-digita to tt-digita.
END. 

DEFINE VARIABLE h-acomp        AS HANDLE        NO-UNDO.
DEFINE VARIABLE c-mensagem     AS CHARACTER     NO-UNDO.
DEFINE VARIABLE l-ok           AS LOG           NO-UNDO.
DEFINE VARIABLE p-nr-embarque  AS INTEGER       NO-UNDO.
DEF BUFFER b-ponto-programa FOR ponto-programa.

FOR FIRST param-global NO-LOCK.  END.
FOR FIRST mgcad.empresa NO-LOCK WHERE
          empresa.ep-codigo = param-global.empresa-pri: END.

ASSIGN c-sistema      = "Espec°ficos Intelbras"
       c-titulo-relat = "Geraá∆o de PrÇ-faturamento para Notas Fiscais"
       c-empresa      = if avail empresa then mgcad.empresa.razao-social else ''
       c-programa     = "ESFTP065"
       c-versao       = "2.04"
       c-revisao      = "001".

/* Coloquei estas linhas no programa - Clayton Antunes */
DEF VAR i-nome-programa AS CHAR.
DEF VAR i-ponto AS INT.
DEF VAR i-sequencia AS INT.
DEF VAR i-conteudo AS CHAR.
{esp/es0018.i}

DEF NEW GLOBAL SHARED VAR v_cod_usuar_corren AS CHAR NO-UNDO.

DEFINE VARIABLE c-excel        AS CHARACTER  NO-UNDO.


DEF TEMP-TABLE tt-prog-ponto-tmp
   FIELD nome-programa    LIKE ponto-programa.nome-programa
   FIELD ponto            LIKE ponto-programa.ponto
   FIELD sequencia        LIKE conteudo-programa.sequencia 
   FIELD conteudo         LIKE conteudo-programa.conteudo
   INDEX seq-campo nome-programa ponto sequencia.   


DEFINE STREAM str-excel.


RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
RUN pi-inicializar IN h-acomp (INPUT "Gerando Embarque...").

{include/i-rpout.i &pagesize="0"}

FOR EACH b-ponto-programa 
   WHERE b-ponto-programa.nome-programa = "ESFTP065":
    RUN esp\es0018p.p (INPUT b-ponto-programa.nome-programa,
                       INPUT b-ponto-programa.ponto,
                       INPUT i-sequencia,
                       INPUT i-conteudo,
                       OUTPUT TABLE tt-prog-ponto) NO-ERROR.
    FOR EACH TT-PROG-PONTO:
        CREATE tt-prog-ponto-tmp.
        BUFFER-COPY TT-PROG-PONTO TO tt-prog-ponto-tmp.
    END.
END.


RUN pi-principal.


RUN pi-finalizar in h-acomp.
{include/i-rpclo.i}

RETURN "OK".


PROCEDURE pi-principal:

    bloco:
    DO TRANS ON ENDKEY UNDO bloco, LEAVE bloco 
             ON ERROR  UNDO bloco, LEAVE bloco:
       
       /* -------------------------------- */
       /* CRIAÄ«O DO CABEÄALHO DO EMBARQUE */
       /* -------------------------------- */

       
       RUN pi-cria-embarque (OUTPUT  l-ok,
                             OUTPUT p-nr-embarque).
    
       IF  RETURN-VALUE <> "OK" OR NOT l-ok OR p-nr-embarque = 0 THEN DO:
           UNDO bloco, RETURN "NOK".
       END.
       
    
       /* -------------------------------------------- */
       /* CRIAÄ«O E VINCULAÄ«O DA PRE-FATUR E IT-PREFAT*/
       /* -------------------------------------------- */
       RUN pi-vincula-notas (OUTPUT l-ok, 
                             INPUT p-nr-embarque).
    
       IF  RETURN-VALUE <> "OK" OR NOT l-ok THEN DO:
           UNDO bloco, RETURN "NOK".
       END.
    
    END.
END.

PROCEDURE pi-cria-embarque:

    DEF OUTPUT PARAM p-ok AS LOG INIT YES NO-UNDO.
    DEF OUTPUT PARAM p-nr-embarque AS INTEGER NO-UNDO.
    
    DEFINE VARIABLE h-api         AS HANDLE  NO-UNDO.

    REPEAT:

        RUN eqp/eqapi300.p PERSISTENT SET h-api.
        EMPTY TEMP-TABLE tt-embarque.
        EMPTY TEMP-TABLE tt-erro.

        FIND LAST embarque NO-LOCK NO-ERROR.
        IF  AVAIL embarque AND embarque.cdd-embarq < 9999999999999999 THEN
            ASSIGN p-nr-embarque = embarque.cdd-embarq + 1.
        ELSE DO:
             FIND LAST embarque WHERE embarque.cdd-embarq < 5000000000000000 NO-LOCK NO-ERROR.
             ASSIGN p-nr-embarque = IF  AVAIL embarque THEN 
                                        embarque.cdd-embarq + 1
                                    ELSE 
                                        1.
        END.
    
        create tt-embarque.
        assign tt-embarque.cdd-embarq  = p-nr-embarque
               tt-embarque.cod-estabel = tt-param.cod-estabel
               tt-embarque.dt-embarque = TODAY
               tt-embarque.identific   = c-seg-usuario
               tt-embarque.cod-rota    = ''
               tt-embarque.nome-transp = ''
               tt-embarque.placa       = ''
               tt-embarque.cod-tipo    = ''
               tt-embarque.usuario     = c-seg-usuario
               tt-embarque.i-sequen    = 1
               tt-embarque.ind-oper    = 1. /* Inclus∆o */
    
        run pi-recebe-tt-embarque in h-api (input table tt-embarque).
        run pi-trata-tt-embarque  in h-api (input 'MSG', input NO).
        run pi-devolve-tt-erro    in h-api (output table tt-erro).
    
        IF  NOT CAN-FIND(FIRST tt-erro) THEN
            RUN pi-trava-embarque IN h-api (p-nr-embarque).
    
        FIND FIRST tt-erro
            WHERE tt-erro.cd-erro = 1 NO-ERROR. /*J† existe ocorrància*/
        
        IF  AVAIL tt-erro THEN
            NEXT.

        for each tt-erro:
            PUT 'Erro na criaá∆o embarque (cabeáalho): ' tt-erro.cd-erro SKIP
                tt-erro.mensagem SKIP.
            p-ok = NO.
            RETURN "NOK".
        end.
        
        DELETE PROCEDURE h-api.
            
        LEAVE.
        
    END.

    IF  p-ok = NO THEN
        RETURN "NOK".

    RETURN "OK".

END.

PROCEDURE pi-vincula-notas:

    DEF OUTPUT PARAM p-ok AS LOG INIT YES NO-UNDO.
    DEF INPUT PARAM p-nr-embarque AS INTEGER NO-UNDO.

    DEF VAR c-transp AS CHAR NO-UNDO.

    FIND FIRST embarque NO-LOCK WHERE embarque.cdd-embarq = p-nr-embarque NO-ERROR.

    IF  NOT AVAIL embarque THEN DO:
        p-ok = NO.
        RETURN "NOK".
    END.

    FIND FIRST estabelec NO-LOCK WHERE estabelec.cod-estabel = embarque.cod-estabel NO-ERROR.
    
    /*   V A L I D A R   T R A N S P O R T A D O R A S   D I F E R E N T E S  */
    FOR EACH tt-digita NO-LOCK 
        WHERE tt-digita.selecionado
        ,FIRST nota-fiscal EXCLUSIVE-LOCK 
             WHERE nota-fiscal.cod-estabel = tt-digita.cod-estab   
               AND nota-fiscal.serie       = tt-digita.serie       
               AND nota-fiscal.nr-nota-fis = tt-digita.nr-nota-fis 
               AND nota-fiscal.dt-cancel   = ?,
             FIRST natur-oper NO-LOCK 
                WHERE natur-oper.nat-operacao = nota-fiscal.nat-operacao:
        IF  c-transp = "" THEN
            ASSIGN c-transp = nota-fiscal.nome-transp.

        IF  c-transp <> nota-fiscal.nome-transp THEN DO:
            ASSIGN c-mensagem = "N∆o s∆o permitidas notas de transpordadoras diferentes no mesmo embarque.".
            PUT c-mensagem FORMAT 'x(256)' SKIP.
            p-ok = NO.
            RETURN "NOK".
        END.
        
    END.

    BLOCK_notas:
    FOR EACH tt-digita NO-LOCK WHERE
             tt-digita.selecionado,
             FIRST nota-fiscal EXCLUSIVE-LOCK WHERE
                   nota-fiscal.cod-estabel = tt-digita.cod-estab   AND
                   nota-fiscal.serie       = tt-digita.serie       AND
                   nota-fiscal.nr-nota-fis = tt-digita.nr-nota-fis AND
                   nota-fiscal.dt-cancel   = ?,
             FIRST natur-oper NO-LOCK WHERE
                   natur-oper.nat-operacao = nota-fiscal.nat-operacao
             BREAK BY nota-fiscal.nr-nota-fis:
                   
        
        IF nota-fiscal.idi-sit-nf-eletro <> 3 THEN DO:
            ASSIGN c-mensagem = "Nota n∆o autorizada! Estab: " + nota-fiscal.cod-estabel + " Serie: " + nota-fiscal.serie + " Nota: " + nota-fiscal.nr-nota-fis + ".".
             PUT c-mensagem FORMAT 'x(256)' SKIP.
             p-ok = NO.
             NEXT.
        END.

        IF nota-fiscal.dt-confirma = ? THEN DO:
            ASSIGN c-mensagem = "Nota n∆o atualizada no estoque! Estab: " + nota-fiscal.cod-estabel + " Serie: " + nota-fiscal.serie + " Nota: " + nota-fiscal.nr-nota-fis + ".".
            PUT c-mensagem FORMAT 'x(256)' SKIP.
            p-ok = NO.
            NEXT.
        END.

       FOR FIRST devol-cli
           WHERE  devol-cli.cod-estabel  = nota-fiscal.cod-estabel
           AND    devol-cli.serie        = nota-fiscal.serie
           AND    devol-cli.nr-nota-fis  = nota-fiscal.nr-nota-fis NO-LOCK: END.

        IF AVAIL devol-cli THEN DO:
            ASSIGN c-mensagem = "Nota devolvida! Estab: " + nota-fiscal.cod-estabel + " Serie: " + nota-fiscal.serie + " Nota: " + nota-fiscal.nr-nota-fis + ".".
            PUT c-mensagem FORMAT 'X(256)' SKIP.
            p-ok = no.
            NEXT.
        END.


        IF  tt-digita.cod-estab <> embarque.cod-estabel THEN NEXT.
                   
        //{esinc/es0004.i} /*ValidaNaturezasImpress∆oNFs*/


        IF FIRST(nota-fiscal.nr-nota-fis) THEN
        DO:
           RUN pi-gera-arquivo-csv. // CRIA NOME ARQUIVO CSV

           OUTPUT STREAM str-excel TO VALUE(c-excel) CONVERT TARGET "iso8859-1".

           PUT STREAM str-excel
               'CDNOTA;' SKIP.
        END.

        FIND FIRST pre-fatur WHERE 
                   pre-fatur.cdd-embarq = nota-fiscal.cdd-embarq         AND
                   pre-fatur.nr-resumo   = INTEGER(nota-fiscal.nr-nota-fis) AND 
                   pre-fatur.nome-abrev  = nota-fiscal.nome-ab-cli          AND 
                   pre-fatur.nr-pedcli   = nota-fiscal.nr-pedcli            NO-ERROR.
        IF NOT AVAIL pre-fatur THEN DO:
           CREATE pre-fatur.
           ASSIGN pre-fatur.cod-estabel   = nota-fiscal.cod-estabel
                  pre-fatur.cdd-embarq   = embarque.cdd-embarq
                  pre-fatur.nr-resumo     = INTEGER(nota-fiscal.nr-nota-fis)
                  pre-fatur.nome-abrev    = nota-fiscal.nome-ab-cli
                  pre-fatur.nr-pedcli     = nota-fiscal.nr-pedcli
                  pre-fatur.estado        = nota-fiscal.estado
                  pre-fatur.dt-embarque   = embarque.dt-embarque
                  pre-fatur.nome-transp   = nota-fiscal.nome-transp
                  pre-fatur.cod-sit-pre   = 3.

           ASSIGN nota-fiscal.cdd-embarq = embarque.cdd-embarq
                  nota-fiscal.nr-resumo   = INTEGER(nota-fiscal.nr-nota-fis).

        
           FOR EACH it-nota-fisc EXCLUSIVE-LOCK OF nota-fiscal ON ERROR UNDO BLOCK_notas, NEXT BLOCK_notas:
               CREATE it-pre-fat.
               ASSIGN it-pre-fat.aliquota-ipi  = it-nota-fisc.aliquota-ipi
                      it-pre-fat.aliquota-tax  = it-nota-fisc.aliquota-tax
                      it-pre-fat.baixa-estoq   = it-nota-fisc.baixa-estoq
                      it-pre-fat.cd-referencia = ''
                      it-pre-fat.class-fiscal  = it-nota-fisc.class-fiscal
                      it-pre-fat.cod-refer     = it-nota-fisc.cod-refer
                      it-pre-fat.cod-tax       = it-nota-fisc.cod-tax 
                      it-pre-fat.cod-vat       = it-nota-fisc.cod-vat 
                      it-pre-fat.ct-cuscon     = it-nota-fisc.ct-cuscon 
                      it-pre-fat.dt-entrega    = it-nota-fisc.dt-emis-nota
                      it-pre-fat.dt-prev-fat   = it-nota-fisc.dt-emis-nota
                      it-pre-fat.it-codigo     = it-nota-fisc.it-codigo 
                      it-pre-fat.narrativa     = it-nota-fisc.nat-docum 
                      it-pre-fat.nat-operacao  = it-nota-fisc.nat-operacao 
                      it-pre-fat.nome-abrev    = it-nota-fisc.nome-ab-cli 
                      it-pre-fat.cdd-embarq   = embarque.cdd-embarq
                      it-pre-fat.nr-entrega    = it-nota-fisc.nr-entrega 
                      it-pre-fat.nr-pedcli     = it-nota-fisc.nr-pedcli
                      it-pre-fat.nr-resumo     = INTEGER(nota-fiscal.nr-nota-fis)
                      it-pre-fat.nr-sequencia  = it-nota-fisc.nr-seq-fat 
                      it-pre-fat.qt-alocada    = it-nota-fisc.qt-faturada[1] 
                      it-pre-fat.qt-faturada   = it-nota-fisc.qt-faturada[1] 
                      it-pre-fat.qt-rejeita    = 0
                      /*it-pre-fat.qt-transfer   = ???*/
                      it-pre-fat.sc-cuscon     = it-nota-fisc.sc-cuscon 
                      it-pre-fat.tipo-atend    = it-nota-fisc.tipo-atend 
                      it-pre-fat.un            = it-nota-fisc.un-fatur[1] 
                      it-pre-fat.user-rej      = ''
                      it-pre-fat.vl-cuscontab  = it-nota-fisc.vl-cuscontab.
               ASSIGN it-nota-fisc.cdd-embarq = embarque.cdd-embarq.    
           END.

           DISP embarque.cdd-embarq
                tt-digita.cod-estab  
                tt-digita.serie      
                tt-digita.nr-nota-fis
                tt-digita.nome-ab-cli
                nota-fiscal.estado
                WITH STREAM-IO.

        END.
        ELSE DO:
            IF nota-fiscal.cdd-embarq = 0 THEN DO:
            
                    FOR EACH it-pre-fat OF pre-fatur:
                        ASSIGN it-pre-fat.cdd-embarq = embarque.cdd-embarq.
                    END.
                    ASSIGN pre-fatur.cdd-embarq   = embarque.cdd-embarq
                           nota-fiscal.cdd-embarq = embarque.cdd-embarq.
                    PUT "Alterou nota " embarque.cdd-embarq nota-fiscal.nr-nota-fis SKIP.
                    FOR EACH it-nota-fisc OF nota-fiscal:
                        ASSIGN it-nota-fisc.cdd-embarq = embarque.cdd-embarq.    
                    END.
            END.
        END.

        PUT STREAM str-excel
            trim(string(nota-fiscal.nr-nota-fis,'x(16)')) ';' SKIP.
    END.

    OUTPUT STREAM str-excel CLOSE.   

    IF SEARCH(c-excel)<> ? THEN
       DOS SILENT START VALUE(c-excel).

    IF  p-ok = NO THEN
        RETURN "NOK".

    RETURN "OK".

END PROCEDURE.



PROCEDURE pi-gera-arquivo-csv:

    IF OPSYS = "UNIX" THEN DO:
        RUN esp/es0018p.p (INPUT "spool-unix", /* Nome do programa */
                           INPUT 1,           /* Ponto do programa */
                           INPUT 0,
                           INPUT "",
                           OUTPUT TABLE tt-prog-ponto) NO-ERROR.
        FOR FIRST tt-prog-ponto NO-LOCK:
    
            ASSIGN c-excel = tt-prog-ponto.conteudo + "~/" + v_cod_usuar_corren + "~/".
    
            OS-CREATE-DIR VALUE(c-excel).
    
            ASSIGN c-excel = c-excel + string(embarque.cdd-embarq) + ".csv".
            
        END.
    
    END.
    ELSE DO:
        RUN esp/es0018p.p (INPUT "spool-win", /* Nome do programa */
                           INPUT 1,          /* Ponto do programa */
                           INPUT 0,
                           INPUT "",
                           OUTPUT TABLE tt-prog-ponto) NO-ERROR.
    
        FOR FIRST tt-prog-ponto NO-LOCK:
    
            ASSIGN c-excel = tt-prog-ponto.conteudo + "~\" + v_cod_usuar_corren + "~\".
    
            OS-CREATE-DIR VALUE(c-excel).
    
            ASSIGN c-excel = c-excel + string(embarque.cdd-embarq) + ".csv".
        END.                
    END.

END PROCEDURE.
