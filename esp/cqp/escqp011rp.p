{include/i-prgvrs.i escqp011 2.04.00.001}
{esp/es0018.i}
{utp/ut-glob.i}
 
DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino          AS INTEGER
    FIELD arquivo          AS CHAR FORMAT "x(35)"
    FIELD usuario          AS CHAR FORMAT "x(12)"
    FIELD data-exec        AS DATE
    FIELD hora-exec        AS INTEGER
    FIELD classifica       AS INTEGER
    FIELD desc-classifica  AS CHAR FORMAT "x(40)"
    FIELD modelo-rtf       AS CHAR FORMAT "x(35)"
    FIELD l-habilitaRtf    AS LOG
    FIELD cod-estab-ini    AS CHAR
    FIELD cod-estab-fim    AS CHAR
    FIELD periodo-ini      AS DATE
    FIELD periodo-fim      AS DATE.

DEF TEMP-TABLE tt-raw-digita
    FIELD raw-digita AS RAW.
 
DEF INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEF INPUT PARAMETER TABLE FOR tt-raw-digita.

DEF VAR h-acomp         AS HANDLE NO-UNDO.    
DEF VAR c-arquivo-csv   AS CHAR   NO-UNDO.
DEF VAR c-dir-saida     AS CHAR   NO-UNDO.
DEF VAR c-arq-excel     AS CHAR   NO-UNDO.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

FIND FIRST tt-param NO-ERROR.
RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
RUN pi-inicializar IN h-acomp (INPUT "Imprimindo":U). 

ASSIGN c-arquivo-csv = "ESCQP011_" + STRING(TIME) + ".csv":U.

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
    ASSIGN c-arq-excel = c-dir-saida + TRIM(c-arquivo-csv).
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
    ASSIGN c-arq-excel = c-dir-saida + TRIM(c-arquivo-csv).
END.

OUTPUT TO VALUE(c-arq-excel) NO-CONVERT.

PUT UNFORMATTED "Estabelecimento;Item;C¢digo Solicita‡Æo;Dep¢sito;Data Solicita‡Æo;Solicitante;Data Atendimento" SKIP.

FOR EACH it-critico-cq
    WHERE it-critico-cq.cod-estabel    >= tt-param.cod-estab-ini
      AND it-critico-cq.cod-estabel    <= tt-param.cod-estab-fim
      AND DATE(it-critico-cq.dt-solic) >= tt-param.periodo-ini
      AND DATE(it-critico-cq.dt-solic) <= tt-param.periodo-fim:

    RUN pi-acompanhar IN h-acomp (INPUT string(it-critico-cq.cod-solic)). 

    FIND FIRST usuar_mestre NO-LOCK
         WHERE usuar_mestre.cod_usuar = it-critico-cq.solicitante .

    PUT UNFORMATTED it-critico-cq.cod-estabel ";"
                    it-critico-cq.it-codigo ";"
                    it-critico-cq.cod-solic   ";"
                    it-critico-cq.cod-depos-solic  ";"
                    date(it-critico-cq.dt-solic) ";"
                    usuar_mestre.nom_usuar ";"
                    date(it-critico-cq.dt-atend) ";" SKIP.
    
END.
    
OUTPUT CLOSE.

RUN pi-finalizar IN h-acomp.

IF NOT OPSYS = "unix" THEN DO:
    DOS SILENT START excel VALUE(c-arq-excel).
END.

RETURN "OK".
