//{esp/es0018.i}
{utp/ut-glob.i}  

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
    field l-habilitaRtf    as LOG.
    /*Fim alteracao 15/02/2005*/

def temp-table tt-raw-digita NO-UNDO
   field raw-digita      as raw.

DEF VAR h-acomp         AS HANDLE NO-UNDO.

/*DEFINE VARIABLE c-arquivo-csv AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-dir-saida   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-arq-excel   AS CHARACTER   NO-UNDO.*/

//DEFINE STREAM str-excel.

DEFINE VARIABLE l-cte-dev      AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-cte-saida    AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-cte-log      AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-cte-comp     AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-cte-compra   AS LOGICAL     NO-UNDO.
DEFINE VARIABLE c-tipo-entrada AS CHARACTER   NO-UNDO.
DEFINE VARIABLE l-processou    AS LOGICAL     NO-UNDO.

DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.   

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
RUN pi-inicializar IN h-acomp (INPUT "Acompanhamento").

DEF VAR h-esreapi0708  AS HANDLE NO-UNDO.

IF NOT VALID-HANDLE(h-esreapi0708) THEN
   RUN upc/esreapi0708.p PERSISTENT SET h-esreapi0708.

RUN pi-acompanhar IN h-acomp(INPUT 'Lendo Registros...').      

FOR EACH docto-orig-cte NO-LOCK
    WHERE docto-orig-cte.idi-situacao = 2 /* Situacao de erro de negocio*/
      AND docto-orig-cte.idi-orig-trad = 2,  /* Registro traduzido apenas */
    FIRST int-natur-gener-cte NO-LOCK
    WHERE int-natur-gener-cte.nat-operacao = docto-orig-cte.nat-operacao
      AND int-natur-gener-cte.log-ativo, /* Tabela que define se a natureza esta no novo processo */
    FIRST msg-ret-nfe NO-LOCK
    WHERE msg-ret-nfe.ch-acesso-comp-nfe = docto-orig-cte.cod-aces-comp-nfe
      AND msg-ret-nfe.idi-orig-trad = docto-orig-cte.idi-orig-trad
      AND msg-ret-nfe.log-ativo = YES
      AND msg-ret-nfe.cd-msg = 52018: /* Erro de negocio que indica o registro sem processamento automatico */
      
    RUN pi-acompanhar IN h-acomp(INPUT 'Docto: ' + docto-orig-cte.cod-aces-comp-nfe ).      

    ASSIGN l-cte-saida  = NO
           l-cte-dev    = NO
           l-cte-log    = NO
           l-cte-comp   = NO
           l-cte-compra = NO.

    /* Se tiver documentos, processo os documentos */
    IF NOT CAN-FIND(FIRST rat-docto-orig-cte 
                    WHERE rat-docto-orig-cte.cod-aces-comp-nfe = docto-orig-cte.cod-aces-comp-nfe
                      AND rat-docto-orig-cte.idi-orig-trad     = docto-orig-cte.idi-orig-trad) THEN DO:

         FOR FIRST rat-docto-orig-cte NO-LOCK 
             WHERE rat-docto-orig-cte.cod-aces-comp-nfe = docto-orig-cte.cod-aces-comp-nfe
               AND rat-docto-orig-cte.idi-orig-trad     = 1:

             RUN pi-define-tipo-entrada IN h-esreapi0708(INPUT ROWID(docto-orig-cte),        
                                                         INPUT ROWID(rat-docto-orig-cte),
                                                         OUTPUT l-cte-dev,
                                                         OUTPUT l-cte-saida,
                                                         OUTPUT l-cte-log,
                                                         OUTPUT l-cte-compra).

         END.
    END.
    ELSE DO:
        FOR FIRST rat-docto-orig-cte NO-LOCK 
            WHERE rat-docto-orig-cte.cod-aces-comp-nfe = docto-orig-cte.cod-aces-comp-nfe
              AND rat-docto-orig-cte.idi-orig-trad     = docto-orig-cte.idi-orig-trad:

            RUN pi-define-tipo-entrada IN h-esreapi0708(INPUT ROWID(docto-orig-cte),
                                                        INPUT ROWID(rat-docto-orig-cte),
                                                        OUTPUT l-cte-dev,               
                                                        OUTPUT l-cte-saida,             
                                                        OUTPUT l-cte-log,
                                                        OUTPUT l-cte-compra).
        END.
    END.

    /* CTe Complementar */
    IF (docto-orig-cte.tp-nf = "1") THEN DO:
          ASSIGN l-cte-comp = YES.
    END.

    /* CTe Complementar */
    IF (l-cte-comp) THEN DO:
        RUN pi-gera-docto-recebimento-complementar IN h-esreapi0708(INPUT ROWID(docto-orig-cte),
                                                                    INPUT c-tipo-entrada,
                                                                    OUTPUT l-processou).
    END.
    ELSE DO:
       /* Demais CT-e */
       ASSIGN c-tipo-entrada = "".
       IF l-cte-saida  THEN ASSIGN c-tipo-entrada = "l-cte-saida".
       IF l-cte-dev    THEN ASSIGN c-tipo-entrada = "l-cte-dev".
       IF l-cte-log    THEN ASSIGN c-tipo-entrada = "l-cte-log".
       IF l-cte-compra THEN ASSIGN c-tipo-entrada = "l-cte-compra".
        
       IF l-cte-saida OR l-cte-dev OR l-cte-log OR l-cte-compra THEN DO:
            RUN pi-gera-docto-recebimento IN h-esreapi0708(INPUT ROWID(docto-orig-cte),
                                                           INPUT c-tipo-entrada,
                                                           OUTPUT l-processou).
       END.
    END.
end.

IF VALID-HANDLE(h-esreapi0708) THEN DO:
    DELETE PROCEDURE h-esreapi0708.
    ASSIGN h-esreapi0708 = ?.
END.

/*
DO ON STOP UNDO, LEAVE:

    ASSIGN c-arquivo-csv = "escdp123_" + REPLACE(STRING(DATE(TODAY),'99/99/9999'),'/','') + '_' + REPLACE(STRING(TIME,'HH:MM:SS'),':','') + ".csv":U.

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
*/

RUN pi-finalizar IN h-acomp.                                    

/*IF NOT OPSYS = "unix" THEN DO:
    DOS SILENT START /*excel*/ VALUE(c-arq-excel).
END.                         */

IF VALID-HANDLE(h-acomp) THEN
    DELETE OBJECT h-acomp.

RETURN "OK".
