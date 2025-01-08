DEFINE VARIABLE h-acomp AS HANDLE NO-UNDO.

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
    FIELD cod_usuario_ini  LIKE usuar_grp_usuar.cod_usuario
    FIELD cod_usuario_fim  LIKE usuar_grp_usuar.cod_usuario.

DEFINE TEMP-TABLE tt-raw-digita
    FIELD raw-digita AS RAW.

DEF INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEF INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param to tt-param.

FIND FIRST tt-param.

RUN utp/ut-acomp.p PERSISTEN SET h-acomp.
RUN pi-inicializar IN h-acomp (INPUT "Iniciando").

FOR EACH usuar_mestre
   WHERE usuar_mestre.cod_usuar >= tt-param.cod_usuario_ini 
     AND usuar_mestre.cod_usuar <= tt-param.cod_usuario_fim NO-LOCK:

    /* Retira perfil dos usuÿrios com mais de 30 dias de vencimento */
    IF usuar_mestre.dat_fim_valid < (TODAY - 30) THEN DO:

        IF usuar_mestre.cod_usuar = "SUPER" OR
           usuar_mestre.cod_usuar = "adm" THEN NEXT.

        RUN pi-acompanhar IN h-acomp (input "Usu rio: " + usuar_mestre.cod_usuar).

        FOR EACH usuar_grp_usuar
           WHERE usuar_grp_usuar.cod_usuario = usuar_mestre.cod_usuar EXCLUSIVE-LOCK:
            DELETE usuar_grp_usuar.
        END.
    END.
END.

RUN pi-finalizar IN h-acomp.
