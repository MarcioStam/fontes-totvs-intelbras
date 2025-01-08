{include/i-prgvrs.i esftp220rp 2.00.00.001}
{esp/es0018.i}
{utp/ut-glob.i}

DEFINE VARIABLE c-arquivo-csv AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-dir-saida   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-arq-excel   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-linha       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE h-acomp       AS HANDLE      NO-UNDO.

DEFINE VARIABLE h-bodi515 AS HANDLE NO-UNDO.

DEFINE BUFFER b-nota-fisc-adc FOR nota-fisc-adc.

DEFINE TEMP-TABLE tt-erro NO-UNDO
    FIELD mensagem AS CHAR.

DEFINE STREAM str-excel.

DEF TEMP-TABLE RowErrors No-undo
    FIELD errorSequence         AS INT
    FIELD errorNumber           AS INT
    FIELD errorDescription      AS CHAR
    FIELD errorParameters       AS CHAR
    FIELD errorType             AS CHAR
    FIELD errorHelp             AS CHAR
    FIELD errorsubtype          AS CHAR.

DEFINE TEMP-TABLE tt-nota-fisc-adc NO-UNDO LIKE nota-fisc-adc
    FIELD r-Rowid AS ROWID.

define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)"
    field usuario          as char format "x(12)"
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field desc-classifica  as char format "x(40)"
    field modelo-rtf       as char format "x(35)"
    field l-habilitaRtf    as LOG
    FIELD arquivo-entrada  AS CHAR.

DEFINE TEMP-TABLE tt-digita NO-UNDO
    FIELD ordem            AS INTEGER   FORMAT ">>>>9":U
    FIELD exemplo          AS CHARACTER FORMAT "x(30)":U
    INDEX id ordem.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.

DEFINE TEMP-TABLE tt-nota-add 
   field cod-estab        like nota-fisc-adc.cod-estab       
   field cod-serie        like nota-fisc-adc.cod-serie       
   field cod-nota-fisc    like nota-fisc-adc.cod-nota-fisc   
   field cdn-emitente     like nota-fisc-adc.cdn-emitente    
   field cod-natur-operac like nota-fisc-adc.cod-natur-operac
   field cod-item         like nota-fisc-adc.cod-item        
   field cod-ajust        like nota-fisc-adc.cod-ajust.

DEFINE input parameter raw-param as raw no-undo.
DEFINE input parameter table for tt-raw-digita.



create tt-param.
raw-transfer raw-param to tt-param.

DO ON STOP UNDO, LEAVE:

    ASSIGN c-arquivo-csv = "esftp220_" + STRING(TIME) + ".csv":U.

    IF  OPSYS = "unix" THEN DO:
        EMPTY TEMP-TABLE tt-prog-ponto.
    
        RUN esp/es0018p.p (INPUT "SPOOL-UNIX":U,
                           INPUT 1,
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-ponto).
    
        FOR FIRST tt-prog-ponto:
            ASSIGN c-dir-saida = REPLACE(tt-prog-ponto.conteudo, "~\":U, "/":U).
        END. /* FOR FIRST tt-prog-ponto: */

        ASSIGN c-dir-saida =  c-dir-saida + "/":U + c-seg-usuario + "/":U.
        OS-CREATE-DIR VALUE(c-dir-saida).
        ASSIGN c-arq-excel = c-dir-saida + TRIM(c-arquivo-csv).
    END. /* IF  OPSYS = "unix" THEN DO: */
    ELSE DO:
        EMPTY TEMP-TABLE tt-prog-ponto.
    
        RUN esp/es0018p.p (INPUT "SPOOL-WIN":U,
                           INPUT 1,
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-ponto).
    
        FOR FIRST tt-prog-ponto:
            ASSIGN c-dir-saida = REPLACE(tt-prog-ponto.conteudo, "/":U, "~\":U).
        END. /* FOR FIRST tt-prog-ponto: */

        ASSIGN c-dir-saida =  c-dir-saida + "/":U + c-seg-usuario + "/":U.
        OS-CREATE-DIR VALUE(c-dir-saida).
        ASSIGN c-arq-excel = c-dir-saida + TRIM(c-arquivo-csv).
    END.
END.

FUNCTION getMes RETURNS INT ( pDesMes AS CHAR ) FORWARD.

DO ON STOP UNDO, LEAVE:

    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
    RUN pi-inicializar in h-acomp (input "Integrando ...").

    RUN pi-importa.

    OUTPUT STREAM str-excel TO value(c-arq-excel) NO-CONVERT.

    IF CAN-FIND (FIRST tt-nota-add) THEN DO:

       PUT STREAM str-excel UNFORMATTED 'Estab;Serie;Docto;Emitente;Natureza;Item;Cod.Ajust' SKIP.

       FOR EACH tt-nota-add:
           PUT STREAM str-excel UNFORMATTED
              tt-nota-add.cod-estab        FORMAT 'x(03)'     ';'
              tt-nota-add.cod-serie        FORMAT 'x(06)'     ';'
              tt-nota-add.cod-nota-fisc    FORMAT 'x(16)'     ';'
              tt-nota-add.cdn-emitente     FORMAT '>>>>>>>>9' ';'
              tt-nota-add.cod-natur-operac FORMAT 'x(06)'     ';'
              tt-nota-add.cod-item         FORMAT 'x(16)'     ';'
              tt-nota-add.cod-ajust        FORMAT 'x(20)'     ';'
              'Importado com Sucesso'  SKIP.
       END.                                         

       PUT '' SKIP(1).
    END.              
    
    
    IF CAN-FIND (FIRST tt-erro) THEN DO:
        PUT STREAM str-excel UNFORMATTED "Erros" SKIP.

        FOR EACH tt-erro:
            PUT STREAM str-excel UNFORMATTED tt-erro.mensagem SKIP.
        END.
    END.
    
    OUTPUT STREAM str-excel CLOSE.
    
    RUN pi-finalizar IN h-acomp.

    
    IF NOT OPSYS = "unix" THEN DO:
        DOS SILENT START excel VALUE(c-arq-excel).
    END.

    RETURN "OK".   
END.

PROCEDURE pi-importa:
    
    DEFINE VARIABLE l-first        AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE l-erro         AS LOGICAL     NO-UNDO.

    INPUT FROM VALUE (tt-param.arquivo-entrada) NO-CONVERT.

    ASSIGN l-first = YES.

    FOR EACH tt-nota-add: DELETE tt-nota-add. END.

    RUN dibo/bodi515.p PERSISTENT SET h-bodi515.
    RUN openQueryStatic IN h-bodi515 (INPUT "Main":U).
   
    Loop:
    REPEAT:
        IMPORT UNFORMATTED c-linha.

        IF l-first THEN DO:
            ASSIGN l-first = NO.
            NEXT.
        END.       
        
        ASSIGN l-erro = NO.
        
        RUN pi-acompanhar IN h-acomp (INPUT "Importando : " + ENTRY(1, c-linha, ";") + " / " + ENTRY(2, c-linha, ";") + " / " + ENTRY(3, c-linha, ";") + " / " + ENTRY(4, c-linha, ";") + " / " + ENTRY(5, c-linha, ";")). 
        
        FIND FIRST it-doc-fisc 
             WHERE it-doc-fisc.cod-estabel  = ENTRY(1, c-linha, ";")
               AND it-doc-fisc.serie        = ENTRY(2, c-linha, ";")
               AND it-doc-fisc.nr-doc-fis   = ENTRY(3, c-linha, ";")
               AND it-doc-fisc.cod-emitente = int(ENTRY(4, c-linha, ";"))
               AND it-doc-fisc.nat-operacao = ENTRY(5, c-linha, ";")
               AND it-doc-fisc.it-codigo    = ENTRY(6, c-linha, ";") 
        NO-LOCK NO-ERROR.
        
        IF NOT AVAIL it-doc-fisc  THEN DO:
           RUN pi-erro (INPUT "Nao encontrada nota com" +
                              " Estabelec: "   + ENTRY(1, c-linha, ";") +
                              " S‚rie: "       + ENTRY(2, c-linha, ";") +
                              " Nota: "        + ENTRY(3, c-linha, ";") +
                              " Emitente: "    + STRING(INT(ENTRY(4, c-linha, ";"))) + 
                              " Natur.Oper: "  + ENTRY(5, c-linha, ";") +  
                              " Item: "        + ENTRY(6,c-linha, ";") ).

           ASSIGN l-erro = YES.
        END.


        FOR FIRST dwf-tab-gener FIELDS(dwf-tab-gener.cod-tabela dwf-tab-gener.cod-campo-idx-1 dwf-tab-gener.cod-livre-1)
            WHERE dwf-tab-gener.cod-tabela      = "1015"
              AND dwf-tab-gener.cod-campo-idx-1 = ENTRY(7, c-linha, ";") NO-LOCK:
        END.

        IF NOT AVAIL dwf-tab-gener THEN DO:
        
           RUN pi-erro (INPUT "Codigo de ajuste nao encontrado " + ENTRY(7, c-linha, ";")).

           ASSIGN l-erro = YES.
        END.

        /*
        FIND FIRST b-nota-fisc-adc NO-LOCK
             WHERE b-nota-fisc-adc.cod-estab        = ENTRY(1, c-linha, ";")
               AND b-nota-fisc-adc.cod-serie        = ENTRY(2, c-linha, ";")
               AND b-nota-fisc-adc.cod-nota-fisc    = ENTRY(3, c-linha, ";")
               AND b-nota-fisc-adc.cdn-emitente     = INT(ENTRY(4, c-linha, ";")) 
               AND b-nota-fisc-adc.cod-natur-operac = ENTRY(5, c-linha, ";")
               AND b-nota-fisc-adc.idi-tip-dado     = 7
               AND b-nota-fisc-adc.cod-item         = ENTRY(6, c-linha, ";") 
               AND b-nota-fisc-adc.cod-ajust        = ENTRY(7, c-linha, ";") 
        NO-ERROR.    

        IF AVAIL b-nota-fisc-adc THEN DO:
           RUN pi-erro (INPUT "Ja existe ocorrencia com a chave informada - " +
                              " Estabelecimento: " + ENTRY(1, c-linha, ";")   +
                              " S‚rie: "           + ENTRY(2, c-linha, ";")   +
                              " Nota: "            + ENTRY(3, c-linha, ";")   +
                              " Emitente: "        + STRING(INT(ENTRY(4, c-linha, ";")))   +
                              " Natureza: "        + ENTRY(5, c-linha, ";")   +
                              " Item: "            + ENTRY(6,c-linha,  ";")   + 
                              " Cod.Ajuste: "      + ENTRY(7, c-linha, ";")).

           ASSIGN l-erro = YES.
        END.*/

        IF l-erro THEN
           NEXT Loop.

        RUN pi-cria-nota-adc.

    END.

    INPUT CLOSE.
END PROCEDURE.


PROCEDURE pi-cria-nota-adc:

   EMPTY TEMP-TABLE tt-nota-fisc-adc.
   EMPTY TEMP-TABLE rowErrors.

   CREATE tt-nota-fisc-adc.
   ASSIGN tt-nota-fisc-adc.cod-estab          = ENTRY(1, c-linha, ";")
          tt-nota-fisc-adc.cod-serie          = ENTRY(2, c-linha, ";")
          tt-nota-fisc-adc.cod-nota-fisc      = ENTRY(3, c-linha, ";")
          tt-nota-fisc-adc.cdn-emitente       = INT(ENTRY(4, c-linha, ";")) 
          tt-nota-fisc-adc.cod-natur-operac   = ENTRY(5, c-linha, ";")
          tt-nota-fisc-adc.idi-tip-dado       = 7. /* Outras Obrigacoes Tributarias */

   ASSIGN tt-nota-fisc-adc.cod-item           = ENTRY(6, c-linha, ";") 
          tt-nota-fisc-adc.cod-ajust          = ENTRY(7, c-linha, ";").

   ASSIGN tt-nota-fisc-adc.dsl-compltar = ENTRY(8, c-linha, ";")
          tt-nota-fisc-adc.val-base-calc-icms = DEC(ENTRY(9, c-linha, ";"))
          tt-nota-fisc-adc.val-aliq-icms      = DEC(ENTRY(10, c-linha, ";"))
          tt-nota-fisc-adc.val-icms           = DEC(ENTRY(11, c-linha, ";"))
          tt-nota-fisc-adc.val-icms-outras    = DEC(ENTRY(12, c-linha, ";")).
   
   OVERLAY(tt-nota-fisc-adc.cod-livre-1,36,256)  = ENTRY(13, c-linha, ";").
   OVERLAY(tt-nota-fisc-adc.cod-livre-1,292,256) = ENTRY(14, c-linha, ";").
   
   RUN setRecord IN h-bodi515 (INPUT TABLE tt-nota-fisc-adc).
   RUN emptyRowErrors IN h-bodi515.

   RUN setRecord IN h-bodi515 (INPUT TABLE tt-nota-fisc-adc).
   RUN emptyRowErrors IN h-bodi515.

   RUN createRecord IN h-bodi515.
   RUN getRowErrors IN h-bodi515 (OUTPUT TABLE rowErrors).

   FIND FIRST rowErrors NO-ERROR.

   IF AVAIL rowErrors THEN DO:
      FOR EACH rowErrors: 
          RUN pi-erro (INPUT '** ATEN€ÇO ** ' + rowErrors.errorDescription + " - " +
                             " Estabelecimento: " + ENTRY(1, c-linha, ";")   +
                             " S‚rie: "           + ENTRY(2, c-linha, ";")   +
                             " Nota: "            + ENTRY(3, c-linha, ";")   +
                             " Emitente: "        + STRING(INT(ENTRY(4, c-linha, ";")))   +
                             " Natureza: "        + ENTRY(5, c-linha, ";")   +
                             " Item: "            + ENTRY(6,c-linha,  ";")   + 
                             " Cod.Ajuste: "      + ENTRY(7, c-linha, ";")).
      END.
   END.
   ELSE DO:      
      CREATE tt-nota-add.
      BUFFER-COPY tt-nota-fisc-adc TO tt-nota-add.
   END.

END PROCEDURE.



PROCEDURE pi-erro:
    DEFINE INPUT PARAM p-erro AS CHAR.

    CREATE tt-erro.
    ASSIGN tt-erro.mensagem = p-erro.
END PROCEDURE.

