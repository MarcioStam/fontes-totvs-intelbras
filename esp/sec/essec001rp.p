{include/i-prgvrs.i essec001 1.00.00.002}

DEFINE VARIABLE h-acomp    AS HANDLE      NO-UNDO.    

DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino           AS INTEGER
    FIELD arquivo           AS CHAR FORMAT "x(35)"
    FIELD usuario           AS CHAR FORMAT "x(12)"
    FIELD data-exec         AS DATE
    FIELD hora-exec         AS INTEGER
    FIELD classifica        AS INTEGER
    FIELD desc-classifica   AS CHAR FORMAT "x(40)"
    FIELD modelo-rtf        AS CHAR FORMAT "x(35)"
    FIELD l-habilitaRtf     AS LOG
    FIELD cod_usuario_ini   LIKE usuar_grp_usuar.cod_usuario 
    FIELD cod_usuario_fim   LIKE usuar_grp_usuar.cod_usuario 
    FIELD cod_grp_usuar_ini LIKE usuar_grp_usuar.cod_grp_usuar
    FIELD cod_grp_usuar_fim LIKE usuar_grp_usuar.cod_grp_usuar
    FIELD relat             AS INT.

DEFINE TEMP-TABLE tt-digita NO-UNDO
    FIELD ordem            AS INTEGER   FORMAT ">>>>9"
    FIELD exemplo          AS CHARACTER FORMAT "x(30)"
    INDEX id ordem.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.

DEF INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEF INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param to tt-param.

FIND FIRST tt-param.

{include/i-rpvar.i}
{include/i-rpout.i}  

/* {include/i-rpcab.i}  */
/* VIEW FRAME f-cabec.  */
/* VIEW FRAME f-rodape. */

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  

RUN pi-inicializar IN h-acomp (INPUT "Inicializar":U). 

ASSIGN tt-param.arquivo = SESSION:TEMP-DIRECTORY + "sec001.csv".

OUTPUT TO VALUE(tt-param.arquivo) CONVERT TARGET SESSION:CHARSET.

PUT UNFORMATTED "Usu rio;Nome;Grupo;Descri‡Æo" SKIP .
FOR EACH usuar_grp_usuar 
    WHERE usuar_grp_usuar.cod_usuario   >= tt-param.cod_usuario_ini  
      AND usuar_grp_usuar.cod_usuario   <= tt-param.cod_usuario_fim 
      AND usuar_grp_usuar.cod_grp_usuar >= tt-param.cod_grp_usuar_ini 
      AND usuar_grp_usuar.cod_grp_usuar <= tt-param.cod_grp_usuar_fim NO-LOCK:

    FIND FIRST usuar_mestre NO-LOCK
        WHERE usuar_mestre.cod_usuario = usuar_grp_usuar.cod_usuario NO-ERROR.

    FIND FIRST grp_usuar NO-LOCK
        WHERE grp_usuar.cod_grp_usuar = usuar_grp_usuar.cod_grp_usua NO-ERROR.

    RUN pi-acompanhar IN h-acomp (INPUT usuar_grp_usuar.cod_grp_usuar + " " + usuar_grp_usuar.cod_usuario).

    PUT UNFORMATTED usuar_grp_usuar.cod_usuario   + ";" +
                    usuar_mestre.nom_usuario      + ";" +
                    usuar_grp_usuar.cod_grp_usuar + ";" +
                    grp_usuar.des_grp_usuar SKIP.
END.

DOS SILENT START excel VALUE(tt-param.arquivo).

RUN pi-finalizar IN h-acomp.

PROCEDURE WinExec EXTERNAL "kernel32.dll":U:
    DEF INPUT  PARAM prg_name   AS CHARACTER.
    DEF INPUT  PARAM prg_style  AS SHORT.
END PROCEDURE.
