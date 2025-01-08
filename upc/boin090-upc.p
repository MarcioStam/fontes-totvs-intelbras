/* ----------------------------------------------------------------------------
   Programa..: upc/boin090-upc.p
   Data......: Dezembro / 2004.
   Autor.....: Robinson Rafael Koprowski - Datasul Gestech.
   Objetivo..: UPC para solicitaÁ„o do motivo da devoluÁ„o RE1001.
---------------------------------------------------------------------------- */

DEFINE VARIABLE iCod-mensagem LIKE mensagem.cod-mensagem      NO-UNDO.
DEFINE VARIABLE cnarrativa    LIKE docum-est.observacao       NO-UNDO.
DEFINE VARIABLE c-ct-transit  LIKE docum-est.ct-transit       NO-UNDO.
DEFINE VARIABLE c-sc-transit  LIKE docum-est.sc-transit       NO-UNDO.

DEF VAR h-boin090-upc AS HANDLE no-undo.

DEF VAR c-mensagem AS CHAR FORMAT "x(2000)" NO-UNDO.
/* Include i-epc200.i: DefiniÁ„o Temp-Table tt-epc */
{include/i-epc200.i1}
{method/dbotterr.i}
{include/boerrtab.i}
{esp/es0018.i}

DEF TEMP-TABLE tt-docum-est no-undo LIKE docum-est
    FIELD r-rowid AS ROWID.

DEFINE VARIABLE c-serie AS CHARACTER   NO-UNDO.

DEFINE INPUT PARAMETER p-ind-event  AS CHARACTER    NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-epc.

/* main block */
case p-ind-event:
    WHEN "beforeCalculateNumberInvoice" THEN DO:
        FIND FIRST tt-epc WHERE tt-epc.cod-event = p-ind-event NO-ERROR.
        IF AVAIL tt-epc THEN DO:
            IF  VALID-HANDLE(WIDGET-HANDLE(tt-epc.val-parameter)) THEN DO:
                RUN getRecord IN WIDGET-HANDLE(tt-epc.val-parameter) (OUTPUT TABLE tt-docum-est). 
            END.
 
            FIND FIRST tt-docum-est NO-ERROR.
            IF NOT AVAIL tt-docum-est THEN
                RETURN "OK":U.

            CREATE tt-epc.
            ASSIGN tt-epc.cod-parameter = "EPC-ERROR"
                   tt-epc.cod-event     = "WARNING"
                   tt-epc.val-parameter  = "Numero do Documento Nao Alterado.".

        /*    RETURN "NOK".    */
        END.
    END.
    when 'afterCreateRecord' THEN DO:
         FIND tt-epc
             WHERE tt-epc.cod-event = p-Ind-Event
             AND   tt-epc.cod-parameter = "Object-Handle" NO-LOCK NO-ERROR.
    
         IF AVAIL tt-epc and
            VALID-HANDLE(WIDGET-HANDLE(tt-epc.val-parameter)) THEN
            ASSIGN h-boin090-upc = WIDGET-HANDLE(tt-epc.val-parameter).

        FIND tt-epc NO-LOCK WHERE tt-epc.cod-parameter = 'Table-Rowid'.
    
        /*evita que tente exibir a janela em RPW, AppServer (RPC),
          WebSpeed ou qualquer sess„o que o usu·rio n„o possa iteragir*/
        IF NOT SESSION:BATCH-MODE THEN DO:
            FIND docum-est WHERE ROWID(docum-est) = TO-ROWID(tt-epc.val-parameter) no-LOCK NO-ERROR.
            IF NOT AVAIL docum-est THEN RETURN "ok".

            FIND int-docum-est
                 WHERE int-docum-est.serie-docto  = docum-est.serie-docto
                   AND int-docum-est.nro-docto    = docum-est.nro-docto
                   AND int-docum-est.cod-emitente = docum-est.cod-emitente
                   AND int-docum-est.nat-operacao = docum-est.nat-operacao EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAIL int-docum-est THEN DO:
                CREATE int-docum-est.
                ASSIGN int-docum-est.serie-docto  = docum-est.serie-docto
                       int-docum-est.nro-docto    = docum-est.nro-docto
                       int-docum-est.cod-emitente = docum-est.cod-emitente
                       int-docum-est.nat-operacao = docum-est.nat-operacao.

                 /* Documento Marcados como Compeltos no RE1001 */ 
                 EMPTY TEMP-TABLE tt-prog-ponto.
                 RUN esp/es0018p.p (INPUT "boin090-upc":U,
                                    INPUT 2,
                                    INPUT 0,
                                    INPUT "":U,
                                    OUTPUT TABLE tt-prog-ponto).

                FOR EACH tt-prog-ponto:
                    IF SUBSTRING(docum-est.cod-chave-aces-nf-eletro,21,2) = tt-prog-ponto.conteudo THEN DO:
                       ASSIGN int-docum-est.nota-completa = YES.
                    END.
                END.

            END.

            FIND natur-oper NO-LOCK WHERE
                 natur-oper.nat-operacao = docum-est.nat-operacao NO-ERROR.
            if  valid-handle(h-boin090-upc) then do:

                find first emitente 
                     where emitente.cod-emitente = docum-est.cod-emitente no-lock no-error.
                if avail emitente THEN DO:
                    find first dist-emitente NO-LOCK
                        where dist-emitente.cod-emitente = emitente.cod-emitente NO-ERROR.
                    IF AVAIL dist-emitente AND dist-emitente.idi-sit-fornec >= 3 then do:
                        RUN _insertErrorManual IN h-boin090-upc  (INPUT 0,
                                                                  INPUT "EMS":U,
                                                                  INPUT "WARNING":U,
                                                                  INPUT "Fornecedor Inativo, n∆o Ç possivel incluir Documentos",
                                                                  INPUT "Fornecedor Inativo, n∆o Ç possivel incluir Documentos",
                                                                  INPUT "").
                    END.
                end.    
                
            END.
/*             IF natur-oper.especie-doc = "NFD" THEN DO:                                                           */
/*                 RUN esp/rep/esrep001.w (INPUT ROWID(docum-est),                                                  */
/*                                         OUTPUT iCod-mensagem,                                                    */
/*                                         OUTPUT c-ct-transit,                                                     */
/*                                         OUTPUT c-sc-transit,                                                     */
/*                                         OUTPUT cnarrativa).                                                      */
/*                 IF iCod-mensagem < 0 OR NOT CAN-FIND(mensagem WHERE mensagem.cod-mensagem = iCod-mensagem) THEN  */
/*                     RETURN 'NOK'.                                                                                */
/*                 ELSE DO:                                                                                         */
/*                     IF AVAIL int-docum-est THEN                                                                  */
/*                         ASSIGN int-docum-est.cod-msg-devolucao  = iCod-mensagem.                                 */
/*                                                                                                                  */
/*                     FIND CURRENT docum-est EXCLUSIVE-LOCK NO-ERROR.                                              */
/*                     ASSIGN docum-est.ct-transit = c-ct-transit                                                   */
/*                            docum-est.sc-transit = c-sc-transit                                                   */
/*                            docum-est.observacao = cnarrativa.                                                    */
/*                     FIND CURRENT docum-est NO-LOCK NO-ERROR.                                                     */
/*                 END.                                                                                             */
/*             END.                                                                                                 */
        END.
    END.
    when 'beforeDeleteRecord' THEN DO:
        FIND tt-epc NO-LOCK WHERE tt-epc.cod-parameter = 'Table-Rowid'.
    
        FIND docum-est NO-LOCK WHERE ROWID(docum-est) = TO-ROWID(tt-epc.val-parameter) NO-ERROR.
        IF NOT AVAIL docum-est THEN RETURN "ok".
    
        FIND int-docum-est NO-LOCK
            WHERE int-docum-est.serie-docto        = docum-est.serie-docto
              AND int-docum-est.nro-docto          = docum-est.nro-docto
              AND int-docum-est.cod-emitente       = docum-est.cod-emitente
              AND int-docum-est.nat-operacao       = docum-est.nat-operacao
            NO-ERROR.
        IF AVAILABLE int-docum-est THEN DO:
            FIND CURRENT int-docum-est EXCLUSIVE-LOCK.
            DELETE int-docum-est.
        END.
    
        FOR EACH ae-inspecao
           WHERE ae-inspecao.cod-estabel    = docum-est.cod-estabel
             and ae-inspecao.nro-docto      = INT(docum-est.nro-docto)
             AND ae-inspecao.serie          = docum-est.serie-docto  
             AND ae-inspecao.nat-operacao   = docum-est.nat-operacao 
             AND ae-inspecao.cod-emitente   = docum-est.cod-emitente EXCLUSIVE-LOCK:
             DELETE ae-inspecao.
        END.
    /*
        ASSIGN c-mensagem = "Aviso de Cancelamento de Nota"                + CHR(10) + CHR(10) +
                            "Documento: " + STRING(docum-est.nro-docto)    + CHR(10) +
                            "SÈrio....: " + STRING(docum-est.serie-docto)  + CHR(10) +
                            "Emitente.: " + STRING(docum-est.cod-emitente) + CHR(10) +
                            "Natureza.: " + STRING(docum-est.nat-operacao).
    
        RUN utp/utapi004.p (INPUT "ione@intelbras.com.br",
                		    INPUT "",
                 		    INPUT "Nota Cancelada",
                 		    INPUT c-mensagem,
                 		    INPUT "",
                 		    INPUT 0,
                 		    INPUT NO,
                 		    INPUT NO,
                 		    INPUT NO). */
    END.
    when 'validateRecord' then do:
        EMPTY TEMP-TABLE tt-prog-ponto.
        RUN esp/es0018p.p (INPUT "boin090-upc":U,
                           INPUT 1,
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-ponto).

        FOR FIRST tt-epc WHERE tt-epc.cod-event = p-ind-event:
            IF  VALID-HANDLE(WIDGET-HANDLE(tt-epc.val-parameter)) THEN DO:
                RUN getRecord IN WIDGET-HANDLE(tt-epc.val-parameter) (OUTPUT TABLE tt-docum-est). 
                RUN getRowErrors IN  WIDGET-HANDLE(tt-epc.val-parameter) (OUTPUT TABLE rowErrors).                
                RUN emptyRowErrors IN WIDGET-HANDLE(tt-epc.val-parameter). 

                for each rowErrors:
                    FOR FIRST tt-docum-est:
                        if rowErrors.ErrorNumber = 19235 THEN DO: /* Transforma essa advertencia em erro. Natureza de operaá∆o n∆o correta para a movimentacao */
                           if NOT can-find(first tt-prog-ponto 
                                           where tt-prog-ponto.conteudo = tt-docum-est.nat-operacao) THEN
                              assign rowErrors.ErrorSubType = "ERROR":U.
                           ELSE 
                              DELETE rowErrors.
                        END.
                    END.

                    /*
                    IF rowErrors.ErrorNumber = 0 AND RowErrors.ErrorType = "EPC" THEN DO:
                        /* Numero da nota fiscal foi alterado. Nao recria este erro pois foi inserido uma advetencia no evento beforeCalculateNumberInvoice */
                        NEXT.
                    END.*/
                end.

                FOR EACH rowErrors:
                    run _insertErrorManual in widget-handle(tt-epc.val-parameter) ( INPUT rowErrors.ErrorNumber,
                                                                                    INPUT RowErrors.ErrorType,
                                                                                    INPUT RowErrors.ErrorSubType,
                                                                                    INPUT RowErrors.ErrorDescription,
                                                                                    INPUT RowErrors.ErrorHelp,
                                                                                    INPUT RowErrors.ErrorParameters).
                END.

                FIND FIRST tt-docum-est NO-ERROR.
                IF NOT AVAIL tt-docum-est THEN 
                    RETURN.



                if (PROGRAM-NAME(1) MATCHES "*re1001a1*" OR
                    PROGRAM-NAME(2) MATCHES "*re1001a1*" OR
                    PROGRAM-NAME(3) MATCHES "*re1001a1*" OR
                    PROGRAM-NAME(4) MATCHES "*re1001a1*" OR
                    PROGRAM-NAME(5) MATCHES "*re1001a1*" OR
                    PROGRAM-NAME(6) MATCHES "*re1001a1*" OR
                    PROGRAM-NAME(7) MATCHES "*re1001a1*") AND
                   NOT CAN-FIND (FIRST modalid-frete WHERE modalid-frete.cod-modalid-frete = substring(tt-docum-est.char-2,143,8)) THEN DO:
                    RUN _insertErrorManual in widget-handle(tt-epc.val-parameter) (INPUT 0,
                                                                                   INPUT "EMS":U,
                                                                                   INPUT "ERROR":U,
                                                                                   INPUT "Deve ser informado uma unidade de frete valida existente no cadastro cd0600",
                                                                                   INPUT "Deve ser informado uma unidade de frete valida existente no cadastro cd0600",
                                                                                   INPUT "").

                END.

                ASSIGN c-serie = "".

                FIND natur-oper WHERE
                     natur-oper.nat-operacao = tt-docum-est.nat-operacao NO-LOCK NO-ERROR.
                IF AVAIL natur-oper 
                     AND natur-oper.imp-nota THEN DO:
                    FOR EACH ser-estab
                       WHERE ser-estab.cod-estabel = tt-docum-est.cod-estabel NO-LOCK:
                        IF ser-estab.log-2 THEN
                            ASSIGN c-serie = ser-estab.serie.
                    END.
                    IF c-serie <> "" AND
                       c-serie <> tt-docum-est.serie-docto THEN DO:
                        run _insertErrorManual in widget-handle(tt-epc.val-parameter) ( INPUT 17567,
                                                                                        INPUT "EMS":U,
                                                                                        INPUT "ERROR":U,
                                                                                        INPUT "SÇrie informada n∆o marcada para Gerar Faturamento no ft0114",
                                                                                        INPUT "SÇrie informada n∆o marcada para Gerar Faturamento no ft0114",
                                                                                        INPUT "":U).

                    END.
                END.
            end.
        end.    
    end.    
end case.

/*
Chamada UPC referente ao Importador XML Gati
*/
IF SEARCH("gtupc/upc-boin090.p") <> ? OR
   SEARCH("gtupc/upc-boin090.r") <> ?
THEN
    RUN gtupc/upc-boin090.p(INPUT p-ind-event,
                            INPUT-OUTPUT TABLE tt-epc).

RETURN "ok".
