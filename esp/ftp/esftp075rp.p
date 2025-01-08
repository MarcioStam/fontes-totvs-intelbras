/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

/*:T*******************************************************************************
**
**  Programa.: esp/ftp/esftp075rp.p
**  Objetivo.: Combina‡Æo dos programas FT0910 e ESFTP069.
**  Cria‡Æo..: 02/06/2010
**
*******************************************************************************/
{include/i-prgvrs.i ESFTP075 2.04.00.000}

{esp/ftp/esftp075.i} /* Defini‡Æo das temp-tables tt-param e tt-raw-digita */

DEFINE VARIABLE c-linha  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-seq    AS INTEGER     NO-UNDO.
DEFINE VARIABLE l-ok     AS LOGICAL     NO-UNDO.
DEFINE VARIABLE cNotaIni AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cNotaFim AS CHARACTER   NO-UNDO.

DEFINE TEMP-TABLE tt-envio-nfe NO-UNDO
    FIELD i-sequencia   AS INTEGER
    FIELD c-nota-fiscal AS CHARACTER
    INDEX id_seq AS PRIMARY UNIQUE
        i-sequencia.

DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

FIND FIRST tt-param NO-LOCK NO-ERROR.

FOR EACH nota-fiscal
    WHERE nota-fiscal.cod-estabel =  tt-param.cod-estabel 
      AND nota-fiscal.serie       =  tt-param.serie           
      AND nota-fiscal.nr-nota-fis >= tt-param.nr-nota-fis-ini 
      AND nota-fiscal.nr-nota-fis <= tt-param.nr-nota-fis-fim NO-LOCK:

    FOR EACH docum-est 
        WHERE docum-est.serie          = nota-fiscal.serie      
          AND docum-est.nro-docto      = nota-fiscal.nr-nota-fis                     
          AND docum-est.cod-emitente   = nota-fiscal.cod-emitente
          AND docum-est.nat-operacao   = nota-fiscal.nat-operacao EXCLUSIVE-LOCK:
        IF docum-est.ce-atual = YES THEN
            ASSIGN docum-est.ce-atual = NO.
    END. /* FOR EACH docum-est */
    RELEASE docum-est.

END. /* FOR EACH nota-fiscal */

RUN ftp/ft0910rp.p (INPUT raw-param, INPUT TABLE tt-raw-digita).

FOR EACH tt-envio-nfe:
    DELETE tt-envio-nfe.
END.

ASSIGN i-seq = 0.

IF OPSYS <> "UNIX":U THEN DO:
    INPUT FROM VALUE(tt-param.arquivo).
    REPEAT:
        IMPORT UNFORMATTED c-linha.
        
        IF INDEX(c-linha, "15.825":U)                   <> 0 AND
           INDEX(c-linha, "NF-e gerada com sucesso.":U) <> 0 AND
           INDEX(c-linha, "[":U)                        <> 0 AND
           INDEX(c-linha, "]":U)                        <> 0 THEN DO:
            CREATE tt-envio-nfe.
            ASSIGN i-seq                      = i-seq + 1
                   tt-envio-nfe.i-sequencia   = i-seq
                   tt-envio-nfe.c-nota-fiscal = TRIM(ENTRY(2, c-linha, "[":U))
                   tt-envio-nfe.c-nota-fiscal = TRIM(REPLACE(tt-envio-nfe.c-nota-fiscal, "]":U, "":U)).
        END.
    END.
    INPUT CLOSE.
END.
ELSE DO:
    ASSIGN l-ok = NO.

    INPUT FROM VALUE(SESSION:TEMP-DIRECTORY + LC(tt-param.usuario) + "/":U + tt-param.arquivo).
    REPEAT:
        READKEY.

        IF STRING(LASTKEY) = "-2":U THEN
            LEAVE.

        IF CHR(LASTKEY) = "[":U THEN DO:
            ASSIGN l-ok = YES.
            CREATE tt-envio-nfe.
            ASSIGN i-seq                    = i-seq + 1
                   tt-envio-nfe.i-sequencia = i-seq.
            NEXT.
        END.
        
        IF l-ok THEN DO:
            IF CHR(LASTKEY) = "]":U THEN
                ASSIGN l-ok = NO.
            ELSE
                ASSIGN tt-envio-nfe.c-nota-fiscal = tt-envio-nfe.c-nota-fiscal + CHR(LASTKEY).
            NEXT.
        END.
    END.
    INPUT CLOSE.
END.

IF i-seq > 1 THEN DO:
    FIND FIRST tt-envio-nfe NO-LOCK NO-ERROR.

    ASSIGN cNotaIni = IF AVAILABLE tt-envio-nfe THEN tt-envio-nfe.c-nota-fiscal ELSE "0":U.

    FIND LAST tt-envio-nfe NO-LOCK NO-ERROR.

    ASSIGN cNotaFim = IF AVAILABLE tt-envio-nfe THEN tt-envio-nfe.c-nota-fiscal ELSE "0":U.

    RUN esp/ftp/esft067rp.p (INPUT tt-param.cod-estabel,
                             INPUT "NFe_":U + cNotaIni + "_a_":U + cNotaFim + "_":U + tt-param.cod-estabel + "_":U + tt-param.serie + "_":U + REPLACE(STRING(TODAY,'99/99/9999'),'/','_') + ".txt":U).
END.
ELSE DO:
    FIND FIRST tt-envio-nfe NO-LOCK NO-ERROR.

    ASSIGN cNotaIni = IF AVAILABLE tt-envio-nfe THEN tt-envio-nfe.c-nota-fiscal ELSE "0":U.

    RUN esp/ftp/esft067rp.p (INPUT tt-param.cod-estabel,
                             INPUT "NFe_":U + cNotaIni + "_":U + tt-param.cod-estabel + "_":U + tt-param.serie + "_":U + REPLACE(STRING(TODAY,'99/99/9999'),'/','_') + ".txt":U).
END.

FOR EACH nota-fiscal
    WHERE nota-fiscal.cod-estabel =  tt-param.cod-estabel 
      AND nota-fiscal.serie       =  tt-param.serie           
      AND nota-fiscal.nr-nota-fis >= tt-param.nr-nota-fis-ini 
      AND nota-fiscal.nr-nota-fis <= tt-param.nr-nota-fis-fim NO-LOCK:

    FOR EACH docum-est 
        WHERE docum-est.serie          = nota-fiscal.serie      
          AND docum-est.nro-docto      = nota-fiscal.nr-nota-fis                     
          AND docum-est.cod-emitente   = nota-fiscal.cod-emitente
          AND docum-est.nat-operacao   = nota-fiscal.nat-operacao EXCLUSIVE-LOCK:
        IF docum-est.ce-atual = NO THEN
            ASSIGN docum-est.ce-atual = YES.
    END. /* FOR EACH docum-est */
    RELEASE docum-est.

END. /* FOR EACH nota-fiscal */





