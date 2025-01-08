/*------------------------------------------------------------------------
    File        : ESAPB027.P
    Purpose     : M‚todo para a identifica‡Æo dos processos existentes no
                  Datasul EMS, cuja nota fiscal de entrada nÆo tenha sido
                  emitida h  mais de 5 dias corridos e demais motivos a
                  crit‚rio do importador. Este m‚todo ser  aplicado uma
                  vez por solicita‡Æo de adiantamento de numer rio.
    Procedure   : ProcessoValido

    Syntax      : <none>
    Description : <none>

    Author(s)   : Fabiano Sakae Ribeiro (Exponencial TI)
    Created     : Mar‡o de 2013
    Notes       : Consumer: Pinho, Provider: Intelbras
------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Preprocessor Definitions ---                                         */

&GLOBAL-DEFINE ativarLog        YES

&GLOBAL-DEFINE dirLogWin        //dbprogress/spool/
&GLOBAL-DEFINE dirLogUnix       /dbs/spool/

&GLOBAL-DEFINE arqLogProducao   log-integ-pinho-esapb027-prod.txt
&GLOBAL-DEFINE arqLogTeste      log-integ-pinho-esapb027-teste.txt

/* Stream Definitions ---                                               */

&IF DEFINED(ativarLog) <> 0       AND
    "{&ativarLog}":U    = "YES":U &THEN
DEFINE STREAM str-log.
&ENDIF

/* Parameters Definitions ---                                           */

DEFINE INPUT  PARAMETER p-embarque   AS CHARACTER   NO-UNDO FORMAT "x(12)":U                LABEL "Embarque":U        COLUMN-LABEL "Embarq":U.
DEFINE OUTPUT PARAMETER p-proc-valid AS LOGICAL     NO-UNDO FORMAT "Sim/NÆo":U INITIAL NO   LABEL "Processo V lido":U COLUMN-LABEL "Proc. V lido":U.
DEFINE OUTPUT PARAMETER p-motivo     AS CHARACTER   NO-UNDO FORMAT "x(256)":U  INITIAL "":U LABEL "Motivo":U          COLUMN-LABEL "Motiv":U.


/* ***************************  Main Block  *************************** */

&IF DEFINED(ativarLog) <> 0       AND
    "{&ativarLog}":U    = "YES":U &THEN
IF OPSYS = "WIN32":U THEN DO:
    IF INDEX(SESSION:STARTUP-PARAMETERS, "-S 20605":U) > 0 THEN
        OUTPUT STREAM str-log TO VALUE("{&dirLogWin}{&arqLogProducao}":U) APPEND CONVERT TARGET "iso8859-1":U.
    ELSE
        OUTPUT STREAM str-log TO VALUE("{&dirLogWin}{&arqLogTeste}":U) APPEND CONVERT TARGET "iso8859-1":U.
END.
ELSE DO:
    IF INDEX(SESSION:STARTUP-PARAMETERS, "oedb/ems5":U) > 0 THEN
        OUTPUT STREAM str-log TO VALUE("{&dirLogUnix}{&arqLogProducao}":U) APPEND CONVERT TARGET "iso8859-1":U.
    ELSE
        OUTPUT STREAM str-log TO VALUE("{&dirLogUnix}{&arqLogTeste}":U) APPEND CONVERT TARGET "iso8859-1":U.
END.
&ENDIF

FOR EACH estabelec NO-LOCK:
    FIND FIRST embarque-imp
        WHERE embarque-imp.cod-estabel = estabelec.cod-estabel
          AND embarque-imp.embarque    = TRIM(p-embarque) NO-LOCK NO-ERROR.

    IF AVAILABLE embarque-imp THEN
        LEAVE.
END.

IF NOT AVAILABLE embarque-imp THEN DO:
    ASSIGN p-proc-valid = NO
           p-motivo     = "Embarque nÆo Localizado.":U.

    &IF DEFINED(ativarLog) <> 0       AND
        "{&ativarLog}":U    = "YES":U &THEN
    IF OPSYS = "WIN32":U THEN
        PUT STREAM str-log UNFORMATTED "[":U TRIM(STRING(NOW, "99/99/9999 hh:mm:ss.sss":U)) "] WINDOWS - Emb.: ":U TRIM(p-embarque) " | Proc. V lido? ":U TRIM(STRING(p-proc-valid, "Sim/NÆo":U)) " | Motivo: ":U TRIM(REPLACE(REPLACE(p-motivo, CHR(10), " ":U), CHR(13), " ":U)) SKIP.
    ELSE
        PUT STREAM str-log UNFORMATTED "[":U TRIM(STRING(NOW, "99/99/9999 hh:mm:ss.sss":U)) "] UNIX    - Emb.: ":U TRIM(p-embarque) " | Proc. V lido? ":U TRIM(STRING(p-proc-valid, "Sim/NÆo":U)) " | Motivo: ":U TRIM(REPLACE(REPLACE(p-motivo, CHR(10), " ":U), CHR(13), " ":U)) SKIP.

    OUTPUT STREAM str-log CLOSE.
    &ENDIF

    RETURN "NOK":U.
END.

IF embarque-imp.cod-conhecto-master = "":U THEN DO:
    ASSIGN p-proc-valid = NO
           p-motivo     = "Embarque sem Conhecimento.":U.

    &IF DEFINED(ativarLog) <> 0       AND
        "{&ativarLog}":U    = "YES":U &THEN
    IF OPSYS = "WIN32":U THEN
        PUT STREAM str-log UNFORMATTED "[":U TRIM(STRING(NOW, "99/99/9999 hh:mm:ss.sss":U)) "] WINDOWS - Emb.: ":U TRIM(p-embarque) " | Proc. V lido? ":U TRIM(STRING(p-proc-valid, "Sim/NÆo":U)) " | Motivo: ":U TRIM(REPLACE(REPLACE(p-motivo, CHR(10), " ":U), CHR(13), " ":U)) SKIP.
    ELSE
        PUT STREAM str-log UNFORMATTED "[":U TRIM(STRING(NOW, "99/99/9999 hh:mm:ss.sss":U)) "] UNIX    - Emb.: ":U TRIM(p-embarque) " | Proc. V lido? ":U TRIM(STRING(p-proc-valid, "Sim/NÆo":U)) " | Motivo: ":U TRIM(REPLACE(REPLACE(p-motivo, CHR(10), " ":U), CHR(13), " ":U)) SKIP.

    OUTPUT STREAM str-log CLOSE.
    &ENDIF

    RETURN "NOK":U.
END.

FIND FIRST ordens-embarque
    WHERE ordens-embarque.cod-estabel = embarque-imp.cod-estabel
      AND ordens-embarque.embarque    = embarque-imp.embarque NO-LOCK NO-ERROR.

IF NOT AVAILABLE ordens-embarque THEN DO:
    ASSIGN p-proc-valid = NO
           p-motivo     = "Embarque sem Ordem.":U.

    &IF DEFINED(ativarLog) <> 0       AND
        "{&ativarLog}":U    = "YES":U &THEN
    IF OPSYS = "WIN32":U THEN
        PUT STREAM str-log UNFORMATTED "[":U TRIM(STRING(NOW, "99/99/9999 hh:mm:ss.sss":U)) "] WINDOWS - Emb.: ":U TRIM(p-embarque) " | Proc. V lido? ":U TRIM(STRING(p-proc-valid, "Sim/NÆo":U)) " | Motivo: ":U TRIM(REPLACE(REPLACE(p-motivo, CHR(10), " ":U), CHR(13), " ":U)) SKIP.
    ELSE
        PUT STREAM str-log UNFORMATTED "[":U TRIM(STRING(NOW, "99/99/9999 hh:mm:ss.sss":U)) "] UNIX    - Emb.: ":U TRIM(p-embarque) " | Proc. V lido? ":U TRIM(STRING(p-proc-valid, "Sim/NÆo":U)) " | Motivo: ":U TRIM(REPLACE(REPLACE(p-motivo, CHR(10), " ":U), CHR(13), " ":U)) SKIP.

    OUTPUT STREAM str-log CLOSE.
    &ENDIF

    RETURN "NOK":U.
END.

FIND FIRST historico-embarque OF embarque-imp
    WHERE historico-embarque.cod-pto-contr = 44
       OR historico-embarque.cod-pto-contr = 246 NO-LOCK NO-ERROR.

IF AVAILABLE historico-embarque               AND
   historico-embarque.dt-efetiva <> ?         AND
   historico-embarque.dt-efetiva  < TODAY - 5 THEN DO:
    ASSIGN p-proc-valid = NO
           p-motivo     = "Embarque fora do Prazo de 5 dias.":U.

    &IF DEFINED(ativarLog) <> 0       AND
        "{&ativarLog}":U    = "YES":U &THEN
    IF OPSYS = "WIN32":U THEN
        PUT STREAM str-log UNFORMATTED "[":U TRIM(STRING(NOW, "99/99/9999 hh:mm:ss.sss":U)) "] WINDOWS - Emb.: ":U TRIM(p-embarque) " | Proc. V lido? ":U TRIM(STRING(p-proc-valid, "Sim/NÆo":U)) " | Motivo: ":U TRIM(REPLACE(REPLACE(p-motivo, CHR(10), " ":U), CHR(13), " ":U)) SKIP.
    ELSE
        PUT STREAM str-log UNFORMATTED "[":U TRIM(STRING(NOW, "99/99/9999 hh:mm:ss.sss":U)) "] UNIX    - Emb.: ":U TRIM(p-embarque) " | Proc. V lido? ":U TRIM(STRING(p-proc-valid, "Sim/NÆo":U)) " | Motivo: ":U TRIM(REPLACE(REPLACE(p-motivo, CHR(10), " ":U), CHR(13), " ":U)) SKIP.

    OUTPUT STREAM str-log CLOSE.
    &ENDIF

    RETURN "NOK":U.
END.

/* ** Embarques confirmados sem hist¢rico ***/
IF embarque-imp.situacao = 2 THEN DO:
    IF NOT AVAILABLE historico-embarque  OR
       historico-embarque.dt-efetiva = ? THEN DO:
        ASSIGN p-proc-valid = NO
               p-motivo     = "Embarque sem Hist¢rico.":U.

        &IF DEFINED(ativarLog) <> 0       AND
        "{&ativarLog}":U    = "YES":U &THEN
        IF OPSYS = "WIN32":U THEN
            PUT STREAM str-log UNFORMATTED "[":U TRIM(STRING(NOW, "99/99/9999 hh:mm:ss.sss":U)) "] WINDOWS - Emb.: ":U TRIM(p-embarque) " | Proc. V lido? ":U TRIM(STRING(p-proc-valid, "Sim/NÆo":U)) " | Motivo: ":U TRIM(REPLACE(REPLACE(p-motivo, CHR(10), " ":U), CHR(13), " ":U)) SKIP.
        ELSE
            PUT STREAM str-log UNFORMATTED "[":U TRIM(STRING(NOW, "99/99/9999 hh:mm:ss.sss":U)) "] UNIX    - Emb.: ":U TRIM(p-embarque) " | Proc. V lido? ":U TRIM(STRING(p-proc-valid, "Sim/NÆo":U)) " | Motivo: ":U TRIM(REPLACE(REPLACE(p-motivo, CHR(10), " ":U), CHR(13), " ":U)) SKIP.

        OUTPUT STREAM str-log CLOSE.
        &ENDIF

        RETURN "NOK":U.
    END.
END.

ASSIGN p-proc-valid = YES
       p-motivo     = "":U.

&IF DEFINED(ativarLog) <> 0       AND
    "{&ativarLog}":U    = "YES":U &THEN
IF OPSYS = "WIN32":U THEN
    PUT STREAM str-log UNFORMATTED "[":U TRIM(STRING(NOW, "99/99/9999 hh:mm:ss.sss":U)) "] WINDOWS - Emb.: ":U TRIM(p-embarque) " | Proc. V lido? ":U TRIM(STRING(p-proc-valid, "Sim/NÆo":U)) " | Motivo: ":U TRIM(REPLACE(REPLACE(p-motivo, CHR(10), " ":U), CHR(13), " ":U)) SKIP.
ELSE
    PUT STREAM str-log UNFORMATTED "[":U TRIM(STRING(NOW, "99/99/9999 hh:mm:ss.sss":U)) "] UNIX    - Emb.: ":U TRIM(p-embarque) " | Proc. V lido? ":U TRIM(STRING(p-proc-valid, "Sim/NÆo":U)) " | Motivo: ":U TRIM(REPLACE(REPLACE(p-motivo, CHR(10), " ":U), CHR(13), " ":U)) SKIP.

OUTPUT STREAM str-log CLOSE.
&ENDIF

RETURN "OK":U.

