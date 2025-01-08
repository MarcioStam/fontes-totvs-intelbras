{include/i-prgvrs.i esftp207rp 2.06.00.002}

{esp/es0018.i}
{esp/esb/esesb000.i}

DEFINE VARIABLE c-arquivo-csv AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-dir-saida   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-arq-excel   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE h-acomp       AS HANDLE      NO-UNDO.

/*DEFINE STREAM str-excel.*/

DEFINE TEMP-TABLE tt-int-calc-comis LIKE int-calc-comis.

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
    FIELD periodo-mes      AS INTEGER
    FIELD periodo-ano      AS INTEGER.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.

DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param to tt-param.

{include/i-rpvar.i}
{utp/ut-glob.i}
{include/i-rpout.i}
{include/i-rpcab.i}

FOR FIRST param-global NO-LOCK. END.
FOR FIRST mgcad.empresa NO-LOCK
    WHERE empresa.ep-codigo = param-global.empresa-pri: END.

ASSIGN c-sistema            = "Espec¡ficos Intelbras"
       c-titulo-relat       = "Integra‡Æo Comissäes"
       c-empresa            = if avail empresa then mgcad.empresa.razao-social else ''
       c-programa           = "ESFTP207"
       i-pais-impto-usuario = 1.

VIEW FRAME f-cabec.
VIEW FRAME f-rodape.

/* DO ON STOP UNDO, LEAVE:                                                          */
/*                                                                                  */
/*     ASSIGN c-arquivo-csv = "esftp207_" + STRING(TIME) + ".csv":U.                */
/*                                                                                  */
/*     IF  OPSYS = "unix" THEN DO:                                                  */
/*         EMPTY TEMP-TABLE tt-prog-ponto.                                          */
/*                                                                                  */
/*         RUN esp/es0018p.p (INPUT "SPOOL-UNIX":U,                                 */
/*                            INPUT 1,                                              */
/*                            INPUT 0,                                              */
/*                            INPUT "":U,                                           */
/*                            OUTPUT TABLE tt-prog-ponto).                          */
/*                                                                                  */
/*         FOR FIRST tt-prog-ponto:                                                 */
/*             ASSIGN c-dir-saida = REPLACE(tt-prog-ponto.conteudo, "~\":U, "/":U). */
/*         END.                                                                     */
/*                                                                                  */
/*         ASSIGN c-dir-saida =  c-dir-saida + "/":U + c-seg-usuario + "/":U.       */
/*         OS-CREATE-DIR VALUE(c-dir-saida).                                        */
/*         ASSIGN c-arq-excel = c-dir-saida + TRIM(c-arquivo-csv).                  */
/*     END.                                                                         */
/*     ELSE DO:                                                                     */
/*         EMPTY TEMP-TABLE tt-prog-ponto.                                          */
/*                                                                                  */
/*         RUN esp/es0018p.p (INPUT "SPOOL-WIN":U,                                  */
/*                            INPUT 1,                                              */
/*                            INPUT 0,                                              */
/*                            INPUT "":U,                                           */
/*                            OUTPUT TABLE tt-prog-ponto).                          */
/*                                                                                  */
/*         FOR FIRST tt-prog-ponto:                                                 */
/*             ASSIGN c-dir-saida = REPLACE(tt-prog-ponto.conteudo, "/":U, "~\":U). */
/*         END.                                                                     */
/*                                                                                  */
/*         ASSIGN c-dir-saida =  c-dir-saida + "/":U + c-seg-usuario + "/":U.       */
/*         OS-CREATE-DIR VALUE(c-dir-saida).                                        */
/*         ASSIGN c-arq-excel = c-dir-saida + TRIM(c-arquivo-csv).                  */
/*     END.                                                                         */
/* END.                                                                             */


DO ON STOP UNDO, LEAVE:
    
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
    RUN pi-inicializar in h-acomp (input "Buscando ...").

    /*OUTPUT STREAM str-excel TO value(c-arq-excel) NO-CONVERT.*/
    
    IF CAN-FIND (FIRST int-execsuperv-calc
                 WHERE int-execsuperv-calc.periodo-ano = tt-param.periodo-ano
                   AND int-execsuperv-calc.periodo-mes = tt-param.periodo-mes
                   AND int-execsuperv-calc.dt-calculo  = ?) THEN DO:

        PUT UNFORMATTED "Existem Executivos/Representantes sem o c lculo de comissäes para o per¡odo.".

        RUN pi-finalizar IN h-acomp.

        RETURN "NOK".
    END.

    FOR EACH int-calc-comis NO-LOCK
       WHERE int-calc-comis.periodo-ano = tt-param.periodo-ano
         AND int-calc-comis.periodo-mes = tt-param.periodo-mes
        BREAK BY int-calc-comis.codigo
              BY int-calc-comis.idi-tipo:

        IF FIRST-OF (int-calc-comis.codigo) THEN DO:

            RUN pi-acompanhar IN h-acomp (INPUT "Integrando representante: " + STRING(int-calc-comis.codigo)).

            EMPTY TEMP-TABLE tt-int-calc-comis.
            CREATE tt-int-calc-comis.
            BUFFER-COPY int-calc-comis TO tt-int-calc-comis.
        
            RAW-TRANSFER tt-int-calc-comis TO raw-param.
            RUN esp/esb/esesb003.p (INPUT  "msg0286", /* Nome Mensagem */  
                                    INPUT  raw-param, /* Tupla do registro */
                                    OUTPUT TABLE resultado  /* Retorno do barramento */) NO-ERROR.

            FIND FIRST resultado NO-ERROR.
            
            IF AVAIL resultado THEN
                PUT UNFORMATTED "Representante: " + STRING(int-calc-comis.codigo) + " " + Resultado.Mensagem SKIP.
            ELSE
                PUT UNFORMATTED "Representante: " + STRING(int-calc-comis.codigo) + " Erro na integra‡Æo!" SKIP.
        END.
    END.
    
    RUN pi-finalizar IN h-acomp.

    /*OUTPUT STREAM str-excel CLOSE.

    IF NOT OPSYS = "unix" THEN DO:
        DOS SILENT START excel VALUE(c-arq-excel).
    END.*/

    RETURN "OK".   
END.
