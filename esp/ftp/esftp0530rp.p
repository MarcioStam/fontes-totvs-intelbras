{include/i-prgvrs.i esftp0530 2.00.00.000}  /*** 010000 ***/

{utp/ut-glob.i}
{include/i-rpvar.i}
{include/i-freeac.i}

{utp/utapi019.i}

/* ***************************  Definitions  ************************** */

/* Include Definitions ---                                              */

DEFINE VARIABLE dt-aux        AS DATE        NO-UNDO.

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE h-acomp       AS HANDLE      NO-UNDO.

DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino   AS INTEGER
    FIELD arquivo   AS CHARACTER FORMAT "x(35)":U
    FIELD usuario   AS CHARACTER FORMAT "x(12)":U
    FIELD data-exec AS DATE
    FIELD hora-exec AS INTEGER
    FIELD diretorio AS CHARACTER .

DEFINE TEMP-TABLE tt-raw-digita
    FIELD raw-digita AS RAW.
/* Parameters Definitions ---                                           */

DEF input parameter raw-param as raw no-undo.
DEF input parameter table for tt-raw-digita.

{esp/es0018.i}

FOR EACH nota-fiscal NO-LOCK
   WHERE nota-fiscal.dt-emis           >= 01/01/2024
     AND nota-fiscal.idi-sit-nf-eletro  = 2:

    RUN pi-move-xml-diretorio-neogrid.
END.


PROCEDURE pi-move-xml-diretorio-neogrid:
    /* -------------------------------------------------------------------------------------------------- */
    /* MOVER DO DIRETORIO TEMPORARIO ONDE O XML ESTA PARA O DIRETORIO DE CONSUMO DO NEOGRID.              */

    /* ESTE PROCEDIMENTO ‘ NECESSARIO PORQUE APENAS DEPOIS DA TRANSACAO DE CRIACAO DA NOTA SER FINALIZADA */

    /* QUE VAI GERAR ENVIAR O XML PARA SEFAZ.                                                             */       
    /* -------------------------------------------------------------------------------------------------- */
    DEF VAR c-dir-DE           AS CHAR FORMAT "x(50)"  NO-UNDO.
    DEF VAR c-dir-PARA         AS CHAR FORMAT "x(50)"  NO-UNDO.
    DEF VAR c-nome-xml         AS CHAR FORMAT "x(200)" NO-UNDO.
    DEF VAR i-err-status       AS INTEGER              NO-UNDO.

    EMPTY TEMP-TABLE tt-prog-ponto.

    IF OPSYS = "WIN32" THEN DO:
       RUN esp/es0018p.p (INPUT "cdapi590", /* Nome do programa */
                          INPUT 2,          /* Ponto do programa */
                          INPUT 0,
                          INPUT "",
                          OUTPUT TABLE tt-prog-ponto). 
    END.
    ELSE
       RUN esp/es0018p.p (INPUT "cdapi590",  /* Nome do programa */
                          INPUT 1,           /* Ponto do programa */
                          INPUT 0,
                          INPUT "",
                          OUTPUT TABLE tt-prog-ponto). 

    FIND FIRST tt-prog-ponto NO-ERROR.

    IF  AVAIL tt-prog-ponto THEN DO:
        /*************************** DIRETÖRIO TEMPORÊRIO *************************/
        //ASSIGN c-dir-DE   = tt-prog-ponto.conteudo + "/TMP/OUT".
        IF OPSYS = "WIN32" THEN
           ASSIGN c-dir-DE   = tt-prog-ponto.conteudo + "TMP\OUT".
        ELSE
           ASSIGN c-dir-DE   = tt-prog-ponto.conteudo + "/TMP/OUT". //linux

        /************************* DIRETÖRIO NEOGRID OFICIAL **********************/

        ASSIGN c-dir-PARA = tt-prog-ponto.conteudo.  
    END.

    IF OPSYS = "UNIX" THEN log-manager:WRITE-MESSAGE ("c-dir-DE P1: " + c-dir-DE).
    IF OPSYS = "UNIX" THEN log-manager:WRITE-MESSAGE ("c-dir-PARA P1: " + c-dir-PARA).

    IF  TRIM(c-dir-PARA) = "" OR TRIM(c-dir-PARA) = "" THEN 
        LEAVE.

    IF AVAIL nota-fiscal THEN DO:
       FOR FIRST integr-totvs-colab NO-LOCK
           WHERE integr-totvs-colab.cod-edi = "170"    /* Tipo de Fluxo*/
             AND integr-totvs-colab.cod-docto = nota-fiscal.cod-chave-aces-nf-eletro /* Chave de acesso da nota */
             AND integr-totvs-colab.cod-msg  MATCHES "*.xml*" :

             RUN pi-devolve-xml (INPUT integr-totvs-colab.cod-msg,
                                 OUTPUT c-nome-xml).

       END.

       IF TRIM(c-nome-xml) <> "" THEN DO:
          ASSIGN c-dir-DE   = c-dir-DE   + "/"     + c-nome-xml.
                 c-dir-PARA = c-dir-PARA + "/OUT/" + c-nome-xml.

          IF OPSYS = "UNIX" THEN log-manager:WRITE-MESSAGE ("c-dir-DE P2: " + c-dir-DE).
          IF OPSYS = "UNIX" THEN log-manager:WRITE-MESSAGE ("c-dir-PARA P2: " + c-dir-PARA).


          IF SEARCH(c-dir-DE) <> ? THEN DO:

             OS-COPY VALUE(c-dir-DE) VALUE(c-dir-PARA).

             OS-DELETE VALUE(c-dir-DE).
          END.
       END. 
    END.

END.


PROCEDURE pi-devolve-xml:

    DEF INPUT  PARAM p-msg      AS CHAR NO-UNDO.
    DEF OUTPUT PARAM p-nome-xml AS CHAR NO-UNDO.

    DEF VAR i AS INTEGER NO-UNDO .

    DO  i = 1 TO NUM-ENTRIES (p-msg, " "):
        IF  ENTRY(i, p-msg, " ") MATCHES "*.xml*" THEN DO:
            ASSIGN p-nome-xml = ENTRY(i, p-msg, " ").
            LEAVE.
        END.
    END.

END PROCEDURE.
