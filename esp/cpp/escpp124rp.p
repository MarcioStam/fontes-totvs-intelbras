/***********************************************************************
**  Programa..: esp/cpp/escpp116rp.p
**  Autor.....: Isac Abrahao
**  Data......: Junho/2021 - Desenvolvimento
**  Descricao.: Integracao Ordem Producao / Operacoes - Datasul x MES
**  Versao....: 001 24/06/2021
**                  Desenvolvimento Programa
************************************************************************/
{esp/es0018.i}
DEFINE STREAM str-excel.

DEFINE VARIABLE c-arquivo-op-csv   AS CHARACTER   NO-UNDO.

DEFINE VARIABLE h-acomp         AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-integracao-op AS CHARACTER   NO-UNDO.

DEFINE VARIABLE c-result-ordem  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-result-oper   AS CHARACTER   NO-UNDO. 
DEFINE VARIABLE c-operacao      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-estado        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-descricao     AS CHARACTER   NO-UNDO.

DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino          AS INTEGER
    FIELD arquivo          AS CHAR FORMAT "x(35)"
    FIELD usuario          AS CHAR FORMAT "x(12)"
    FIELD data-exec        AS DATE
    FIELD hora-exec        AS INTEGER
    FIELD classifica       AS INTEGER
    FIELD desc-classifica  AS CHAR FORMAT "x(40)"
    FIELD modelo-rtf       AS CHAR FORMAT "x(35)"
    FIELD l-habilitaRtf    AS LOG.

DEF TEMP-TABLE tt-ordem-integrada 
    FIELD nr-ord-prod     AS INT
    INDEX idx nr-ord-prod.

DEFINE VARIABLE c-dir-saida AS CHARACTER NO-UNDO.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.

DEFINE input parameter raw-param as raw no-undo.
DEFINE input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

{utp/ut-glob.i}

DO ON STOP UNDO, LEAVE:

    ASSIGN c-arquivo-op-csv   = "escpp115_op_"   + REPLACE(STRING(TODAY,'99/99/9999'),'/','') + REPLACE(STRING(TIME,'HH:MM'),':','') + ".csv":U.

    IF  OPSYS = "unix" THEN DO:
        EMPTY TEMP-TABLE tt-prog-ponto.
    
        RUN esp/es0018p.p (INPUT "SPOOL-UNIX":U,
                           INPUT 1,
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-ponto).
    
        FOR FIRST tt-prog-ponto:
            ASSIGN c-dir-saida = REPLACE(tt-prog-ponto.conteudo, "~\":U, "/":U).
        END. 

        ASSIGN c-dir-saida =  c-dir-saida + "/":U + c-seg-usuario + "/":U.
        OS-CREATE-DIR VALUE(c-dir-saida).
        ASSIGN c-integracao-op = c-dir-saida + TRIM(c-arquivo-op-csv).
    END. 
    ELSE DO:
        EMPTY TEMP-TABLE tt-prog-ponto.
    
        RUN esp/es0018p.p (INPUT "SPOOL-WIN":U,
                           INPUT 1,
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-ponto).
    
        FOR FIRST tt-prog-ponto:
            ASSIGN c-dir-saida = REPLACE(tt-prog-ponto.conteudo, "/":U, "~\":U).
        END. 

        ASSIGN c-dir-saida =  c-dir-saida + "/":U + c-seg-usuario + "/":U.
        OS-CREATE-DIR VALUE(c-dir-saida).
        ASSIGN c-integracao-op = c-dir-saida + TRIM(c-arquivo-op-csv).
    END.
END.


DO ON STOP UNDO, LEAVE:
    
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
    RUN pi-inicializar in h-acomp (input "Buscando ...").

    FOR EACH tt-ordem-integrada: DELETE tt-ordem-integrada. END.

    OUTPUT STREAM str-excel TO VALUE(c-integracao-op) NO-CONVERT.
    PUT    STREAM str-excel UNFORMATTED  "Acao;Ord.Prod;Item;Descricao;Qtde;Situacao OP;Result.OP;Operacoes;Result.Operacoes" SKIP.

    //Inicia Integracao 
    FOR EACH int-ord-prod-mes NO-LOCK
        WHERE int-ord-prod-mes.oper-integrada = NO:
        FIND FIRST ord-prod WHERE ord-prod.nr-ord-prod = int-ord-prod-mes.nr-ord-prod NO-LOCK NO-ERROR.
          
        IF AVAIL ord-prod THEN DO:

          
    RUN esp/es0018p.p (INPUT "ESCPP115":U,
                       INPUT 1,
                       INPUT 0,
                       INPUT "":U,
                       OUTPUT TABLE tt-prog-ponto).
    END.
  END.
END.  
CURRENT-LANGUAGE=CURRENT-LANGUAGE.
    FOR EACH tt-prog-ponto:
        FOR EACH ord-prod NO-LOCK
            WHERE ord-prod.cod-estabel >= '103'
              AND ord-prod.cod-estabel <= '105'
              AND ord-prod.dt-inicio  >= 01/02/2023
              AND ord-prod.nr-linha >= 4
              AND ord-prod.nr-linha <= 5
              AND ord-prod.estado < 7:

            RUN pi-acompanhar in h-acomp (input "Integracao Ord.Prod: " + STRING(ord-prod.nr-ord-prod) +   "Estab: " + ord-prod.cod-estabel).

            FIND FIRST tt-ordem-integrada WHERE tt-ordem-integrada.nr-ord-prod = ord-prod.nr-ord-prod NO-ERROR.
                 
            IF AVAIL tt-ordem-integrada THEN NEXT.
    
            RUN pi-integra-op-mes (INPUT 'add').
        END.    
   

    //Fim
    RUN pi-finalizar IN h-acomp.

    OUTPUT STREAM str-excel CLOSE.

    IF NOT OPSYS = "unix" THEN DO:
       DOS SILENT START excel VALUE(c-integracao-op).
    END.

    RETURN "OK".   
END.


PROCEDURE pi-integra-op-mes:

    DEF INPUT PARAM p-acao AS CHARACTER NO-UNDO.

   
      RUN esapi/esapi039.p (INPUT ord-prod.nr-ord-prod,
                            INPUT p-acao,
                            OUTPUT c-operacao, 
                            OUTPUT c-result-ordem,
                            OUTPUT c-result-oper).
   

    ASSIGN c-descricao = ''.

    CASE ord-prod.estado:
        WHEN 1 THEN ASSIGN c-estado = 'Nao Iniciada'.    
        WHEN 2 THEN ASSIGN c-estado = 'Liberada'.
        WHEN 3 THEN ASSIGN c-estado = 'Reservada'.
        WHEN 4 THEN ASSIGN c-estado = 'Separada'.
        WHEN 5 THEN ASSIGN c-estado = 'Requisitada'.
        WHEN 6 THEN ASSIGN c-estado = 'Iniciada'.
        WHEN 7 THEN ASSIGN c-estado = 'Finalizada'.  
        WHEN 8 THEN ASSIGN c-estado = 'Terminada'.
    END CASE.

    FIND ITEM WHERE ITEM.it-codigo = ord-prod.it-codigo NO-LOCK NO-ERROR.

    IF AVAIL ITEM THEN
       ASSIGN c-descricao = ITEM.desc-item.

    PUT STREAM str-excel UNFORMATTED UPPER(p-acao)                                  ";"  
                                     STRING(ord-prod.nr-ord-prod)                   ";" 
                                     STRING(ord-prod.it-codigo)  FORMAT 'x(16)'     ";" 
                                     c-descricao                 FORMAT 'x(60)'     ";" 
                                     STRING(ord-prod.qt-ordem)                      ";" 
                                     c-estado                    FORMAT 'x(20)'     ";" 
                                     c-result-ordem                                 ";" 
                                     c-operacao                  FORMAT 'x(50)'     ";" 
                                     c-result-oper               FORMAT 'x(50)'                   
                                     SKIP.
END.



