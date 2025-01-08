/*************************************************************************************************************************************************************************
** Copyright PRIME Consultoria (2014)                                                                                                                                   **
** Todos os Direitos Reservados.                                                                                                                                        **
**                                                                                                                                                                      **
** Este fonte ‚ de propriedade exclusiva da PRIME Consultoria, sua reprodu‡Æo parcial ou total por qualquer meio, s¢ poder  ser feita mediante autoriza‡Æo expressa     **
**                                                                                                                                                                      **
**************************************************************************************************************************************************************************
** Programa .....: prm1104rp.p                                                                                                                                          **
** Data .........: Setembro de 2020                                                                                                                                     **
** Autor ........: Prime Consultoria                                                                                                                                    **
** Objetivo .....: Download XML Nota Fiscal para Projetos de Integra‡Æo (Integrador)                                                                                    **
** Revisäes **************************************************************************************************************************************************************
** Autor         Ver.    Data        Cliente  Solicitante  Descri‡Æo                                                                                                    **
** Pedro Vicari  00.001  22/09/2021  CRS      CRS          1) Desenvolvimento inicial do programa                                                                       **
**                                                                                                                                                                      **
*************************************************************************************************************************************************************************/

{include/i-prgvrs.i prm1104rp 1.00.00.000}
{utp/ut-glob.i}
{prmapi/PrmDownloadIntegrador.i}

DEFINE VARIABLE h-run AS HANDLE NO-UNDO.

DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino           AS INTEGER
    FIELD arquivo           AS CHARACTER FORMAT "x(35)"
    FIELD usuario           AS CHARACTER FORMAT "x(12)"
    FIELD data-exec         AS DATE
    FIELD hora-exec         AS INTEGER
    FIELD classifica        AS INTEGER
    FIELD desc-classifica   AS CHARACTER FORMAT "x(40)"
    FIELD modelo-rtf        AS CHARACTER FORMAT "x(35)"
    FIELD l-habilitaRtf     AS LOG.

DEFINE TEMP-TABLE tt-digita NO-UNDO
    FIELD ordem             AS INTEGER   FORMAT ">>>>9"
    FIELD exemplo           AS CHARACTER FORMAT "x(30)"
    INDEX id ordem.
    
DEFINE TEMP-TABLE tt-raw-digita
   FIELD raw-digita         AS RAW.  

/***--------- Parƒmetros ---------***/
DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

FOR EACH tt-raw-digita:
    CREATE tt-digita.
    RAW-TRANSFER tt-raw-digita.raw-digita TO tt-digita.
END.

FORM tt-log.cod-proj-int    FORMAT "x(10)"  COLUMN-LABEL "Integrador"   SPACE(1)
     tt-log.arquivo         FORMAT "x(80)"  COLUMN-LABEL "Arquivo"      SPACE(1)
     tt-log.tipo            FORMAT "x(15)"  COLUMN-LABEL "Tipo"         SPACE(1)
     tt-log.msg             FORMAT "x(200)" COLUMN-LABEL "Mensagem"
    WITH STREAM-IO WIDTH 321 NO-BOX 60 DOWN FRAME f-doc.

{include/i-rpvar.i}

ASSIGN c-titulo-relat = "Download XML Nota Fiscal para Projetos de Integra‡Æo (Integrador)".
FIND FIRST tt-param NO-LOCK NO-ERROR.

RUN processarDownload.

{include/i-rpcab.i}
{include/i-rpout.i}

VIEW FRAME f-cabec.
VIEW FRAME f-rodape.

RUN imprimirLog.
{include/i-rpclo.i}

RETURN "OK":U.

/* **********************  Internal Procedures  *********************** */

PROCEDURE processarDownload:
    
    EMPTY TEMP-TABLE tt-log.

    FOR EACH prm-projeto-integrador NO-LOCK:
        IF prm-projeto-integrador.prog-download <> ? AND TRIM(prm-projeto-integrador.prog-download) <> "" THEN
            RUN VALUE(prm-projeto-integrador.prog-download) (INPUT prm-projeto-integrador.cod-proj-int,
                                                             INPUT-OUTPUT TABLE tt-log).
    END.
END PROCEDURE.

PROCEDURE imprimirLog:

    FOR EACH tt-log NO-LOCK:     

        DISPLAY tt-log.cod-proj-int
                tt-log.arquivo     
                tt-log.tipo        
                tt-log.msg         
            WITH FRAME f-doc.
        DOWN WITH FRAME f-doc.                  
    END.
END PROCEDURE.
