/***********************************************************************
**  Programa..: esp/cpp/escpp116rp.p
**  Autor.....: Isac Abahao
**  Data......: Junho/2021 - Desenvolvimento
**  Descricao.: Integracao Reporte Ordem Producao Datasul x MES
**  Versao....: 001 28/06/2021
**                  Desenvolvimento Programa
************************************************************************/
{esp/es0018.i}
{esp/cpp/escpp116.i}

DEFINE STREAM str-excel.

DEFINE VARIABLE c-arquivo-item-csv AS CHARACTER   NO-UNDO.

DEFINE VARIABLE h-acomp             AS HANDLE     NO-UNDO.
DEFINE VARIABLE c-integracao-rep    AS CHARACTER  NO-UNDO.

DEFINE VARIABLE c-resultado         AS CHARACTER  NO-UNDO.

DEFINE TEMP-TABLE tt-param no-undo
       FIELD destino          AS INTEGER
       FIELD arquivo          AS CHAR FORMAT "x(35)"
       FIELD usuario          AS CHAR FORMAT "x(12)"
       FIELD data-exec        AS DATE
       FIELD hora-exec        AS INTEGER
       FIELD classifica       AS INTEGER
       FIELD desc-classifica  AS CHAR FORMAT "x(40)"
       FIELD modelo-rtf       AS CHAR FORMAT "x(35)"
       FIELD l-habilitaRtf    AS LOG.


DEFINE VARIABLE c-dir-saida AS CHARACTER   NO-UNDO.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.

DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param to tt-param.

{utp/ut-glob.i}

DO ON STOP UNDO, LEAVE:

    ASSIGN c-arquivo-item-csv = "escpp116_rep_" + REPLACE(STRING(TODAY,'99/99/9999'),'/','') + REPLACE(STRING(TIME,'HH:MM'),':','') + ".csv":U.
    
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
        ASSIGN c-integracao-rep = c-dir-saida + TRIM(c-arquivo-item-csv).
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
        ASSIGN c-integracao-rep = c-dir-saida + TRIM(c-arquivo-item-csv).
    END.
END.


DO ON STOP UNDO, LEAVE:
    
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
    RUN pi-inicializar in h-acomp (input "Buscando ...").

    /* Inicio */

    FOR EACH tt-result-rep: DELETE tt-result-rep. END.

    CREATE "ADODB.Connection" ch-connection.
    CREATE "ADODB.RecordSet"  ch-recordset.
    CREATE "ADODB.Command"    ch-command.  
    
    RUN open-connection.
    RUN pi-reporte. 

    OUTPUT STREAM str-excel TO value(c-integracao-rep) NO-CONVERT.

    PUT STREAM str-excel UNFORMATTED  "Ordem Prod;Item;Descricao;Qtde Reporte;Resultado" SKIP.

    FOR EACH tt-result-rep:

        RUN pi-acompanhar IN h-acomp(INPUT 'Resultado Reporte OP:' + STRING(tt-result-rep.nr-ord-prod)).

        PUT STREAM str-excel UNFORMATTED tt-result-rep.nr-ord-prod                          ';'
                                         tt-result-rep.it-codigo  FORMAT 'x(16)'            ';'
                                         tt-result-rep.desc-item  FORMAT 'x(60)'            ';'
                                         tt-result-rep.qt-reporte FORMAT '>>>,>>>,>>9.9999' ';'
                                         tt-result-rep.mensagem   FORMAT 'x(500)' SKIP.
    END.

    RUN pi-finalizar IN h-acomp.

    OUTPUT STREAM str-excel CLOSE.

    IF NOT OPSYS = "unix" THEN DO:
        DOS SILENT START excel VALUE(c-integracao-rep).
    END.

    RETURN "OK".   
END.


/* Procedures */
PROCEDURE open-connection:
    ch-connection:OPEN("MES_homolog","sql_ppi","pcf",) NO-ERROR.

    IF ERROR-STATUS:NUM-MESSAGES > 0 THEN DO:
        MESSAGE "Erro de Conexao" SKIP ERROR-STATUS:GET-MESSAGE(1) VIEW-AS ALERT-BOX .
        RETURN "NOK":U .
    END.

    ASSIGN ch-command:ActiveConnection  = ch-connection
           ch-command:CommandType       = 1 /* adCmdText */
           ch-connection:CursorLocation = 3 /* adUseClient */
           ch-recordset:CursorType      = 1 /* adOpenKeyset */
           ch-recordset:LockType        = 3 /* adLockOptimistic */.
        
    RETURN "OK":U .
END PROCEDURE.


PROCEDURE pi-reporte:

   DEF VAR c-query    AS CHAR NO-UNDO.
   DEF VAR c-return   AS CHAR NO-UNDO.

   DEFINE VARIABLE i-ordem AS INTEGER NO-UNDO.

   DEF VAR h-cpapi001 AS HANDLE NO-UNDO.

   RUN esp/es0018p.p (INPUT "escpp116":U,
                      INPUT 1,
                      INPUT 0,
                      INPUT "":U,
                      OUTPUT TABLE tt-prog-ponto).


   FOR EACH tt-linha. DELETE tt-linha. END.
   FOR EACH tt-prog-ponto:  
       CREATE tt-linha.
       ASSIGN tt-linha.nr-linha       = INT(ENTRY(1,tt-prog-ponto.conteudo))
              tt-linha.cod-depos-entr = ENTRY(2,tt-prog-ponto.conteudo)
              tt-linha.cod-depos-sai  = ENTRY(3,tt-prog-ponto.conteudo).
   END.

   
   ASSIGN c-query = "SELECT * FROM TBLOutInteg WHERE INTEGRATED = 0".

   RUN execute-sql (INPUT c-query).
      
   DO WHILE NOT ch-recordset:eof:

      i-ordem = ch-recordset:FIELDS("WOCode"):VALUE.

      RUN pi-acompanhar IN h-acomp (INPUT 'Leitura Banco DADOS MES: ' + STRING(i-ordem )).

      FIND FIRST tt-ordens WHERE tt-ordens.nr-ord-prod = i-ordem NO-ERROR.

      IF NOT AVAIL tt-ordens THEN DO:
         CREATE tt-ordens.
         ASSIGN tt-ordens.cod-estabel  = ch-recordset:FIELDS("PlantCode"):VALUE
                tt-ordens.nr-ord-prod  = ch-recordset:FIELDS("WOCode"):VALUE.
                tt-ordens.qtde         = ch-recordset:FIELDS("QTY"):VALUE.
      END.
          
      ch-recordset:MoveNext.
   END.

   FOR EACH tt-ordens,
       FIRST ord-prod NO-LOCK
       WHERE ord-prod.estado      < 7 
         AND ord-prod.cod-estabel = tt-ordens.cod-estabel
         AND ord-prod.nr-ord-prod = tt-ordens.nr-ord-prod,
       FIRST ITEM WHERE ITEM.it-codigo = ord-prod.it-codigo NO-LOCK:
            
       EMPTY TEMP-TABLE tt-reservas.
       EMPTY TEMP-TABLE tt-res-neg.
       EMPTY TEMP-TABLE tt-rep-prod.
       EMPTY TEMP-TABLE tt-erro.

       CREATE tt-result-rep.
       ASSIGN tt-result-rep.nr-ord-prod = ord-prod.nr-ord-prod
              tt-result-rep.it-codigo   = ITEM.it-codigo
              tt-result-rep.desc-item   = ITEM.desc-item
              tt-result-rep.qt-reporte  = tt-ordens.qtde.


       RUN pi-acompanhar IN h-acomp (INPUT 'Reportando OP: ' + STRING(ord-prod.nr-ord-prod)).
       
       run cpp/cpapi001.p PERSISTENT SET h-cpapi001 (INPUT-OUTPUT TABLE tt-rep-prod,
                                                     INPUT        TABLE tt-refugo,
                                                     INPUT        TABLE tt-res-neg,
                                                     INPUT        TABLE tt-apont-mob,
                                                     INPUT-OUTPUT TABLE tt-erro,
                                                     INPUT        YES).     
       
       FIND FIRST tt-linha WHERE tt-linha.nr-linha = ord-prod.nr-linha NO-ERROR.

       IF NOT AVAIL tt-linha THEN DO:
          ASSIGN tt-result-rep.mensagem = 'Linha de Producao Nø ' + STRING(ord-prod.nr-linha) + ' nao parametrizada em ES0018'.
          NEXT.
       END.


       create tt-rep-prod.
       assign tt-rep-prod.tipo                   = 1
              tt-rep-prod.nr-ord-produ           = ord-prod.nr-ord-produ
              tt-rep-prod.data                   = today
              tt-rep-prod.cod-depos              = tt-linha.cod-depos-entr
              tt-rep-prod.cod-depos-sai          = tt-linha.cod-depos-sai
              tt-rep-prod.cod-localiz            = ''
              tt-rep-prod.baixa-reservas         = 1
              tt-rep-prod.carrega-reservas       = yes
              tt-rep-prod.reserva                = yes
              tt-rep-prod.nro-docto              = string(ord-prod.nr-ord-produ)
              tt-rep-prod.serie-docto            = "MES"
              tt-rep-prod.finaliza-ordem         = NO
              tt-rep-prod.cod-versao-integracao  = 1
              tt-rep-prod.it-codigo              = ord-prod.it-codigo
              tt-rep-prod.un                     = ord-prod.un
              tt-rep-prod.nro-ord-seq            = 1
              tt-rep-prod.lote-serie             = ord-prod.lote-serie
              tt-rep-prod.dt-vali-lote           = 12/31/9999
              tt-rep-prod.qt-reporte             = tt-ordens.qtde. 
      
       RUN pi-recebe-tt-rep-prod IN h-cpapi001 (INPUT TABLE tt-rep-prod).

       RUN pi-processa-reportes IN h-cpapi001 (INPUT-OUTPUT TABLE tt-rep-prod,
                                               INPUT        TABLE tt-refugo,
                                               INPUT        TABLE tt-res-neg,
                                               INPUT-OUTPUT TABLE tt-erro,
                                               INPUT NO,
                                               INPUT YES).

       DELETE PROCEDURE h-cpapi001.

       

       FIND FIRST tt-erro NO-ERROR.

       IF AVAIL tt-erro THEN DO:
       
          ASSIGN tt-result-rep.mensagem = tt-erro.mensagem.

          ASSIGN c-query = "update TBLOutInteg" + 
                           " set ErrDescription = '" + tt-erro.mensagem + ' - ' + STRING(TODAY,'99/99/9999') + "'" +
                           " where WOCode = " + STRING(tt-ordens.nr-ord-prod).
       END.
       ELSE DO: 

          ASSIGN tt-result-rep.mensagem    = 'Reporte realizado com Sucesso!'.
       
          ASSIGN c-query = "update TBLOutInteg" + 
                           " set integrated = 2 ," + 
                           " ErrDescription = 'Reporte realizado com Sucesso!' ," +
                           " Dtintegration = (select getdate()) " + 
                           " where WOCode = " + STRING(tt-ordens.nr-ord-prod).
       END.

       RUN execute-sql (INPUT c-query).

   END.

END PROCEDURE.


PROCEDURE execute-sql:
    DEF INPUT PARAMETER c-command AS CHAR NO-UNDO .
    ASSIGN ch-command:CommandText = c-command .
    ch-recordset = ch-command:EXECUTE(OUTPUT ODBC-NULL, "", 64 ) .
END PROCEDURE.


PROCEDURE piRetornaErro:
    DEF OUTPUT PARAM TABLE FOR tt-erro.
END PROCEDURE.


PROCEDURE close-connection:
     ch-connection:CLOSE .
     RETURN "OK":U .
END PROCEDURE.
