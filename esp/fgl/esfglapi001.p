/* VALIDAR SEGURAÄA */

DEF INPUT  PARAM p-row-rateio AS ROWID NO-UNDO.
DEF INPUT  PARAM p-usuario    AS CHAR NO-UNDO.
DEF INPUT  PARAM p-acao       AS CHAR NO-UNDO.
DEF OUTPUT PARAM p-erro      AS CHAR NO-UNDO.

FIND int-rateio NO-LOCK
    WHERE ROWID(int-rateio) = p-row-rateio NO-ERROR.

IF  NOT AVAIL int-rateio THEN DO:
    ASSIGN p-erro = p-erro + "Rateio n∆o encontrato" + CHR(10).
    RETURN "NOK".
END.


/* Valida usu†rio diretamente */
FIND int-rat-desp-segur NO-LOCK
    WHERE int-rat-desp-segur.tipo-rateio = int-rateio.tipo-rateio
      AND int-rat-desp-segur.usuar-grupo = 1 /*Usu†rio*/
      AND int-rat-desp-segur.codigo      = p-usuario NO-ERROR.

IF  NOT AVAIL  int-rat-desp-segur THEN 
    /* Valida se o grupo possui permiss∆o */
    FOR EACH usuar_grp_usuar NO-LOCK
        WHERE usuar_grp_usuar.cod_usuario   = p-usuario:
    
        FIND FIRST int-rat-desp-segur NO-LOCK
            WHERE int-rat-desp-segur.tipo-rateio = int-rateio.tipo-rateio
              AND int-rat-desp-segur.usuar-grupo = 2 /* grupo */
              AND int-rat-desp-segur.codigo      = usuar_grp_usuar.cod_grp_usuar NO-ERROR.
        
        IF  AVAIL int-rat-desp-segur THEN
            LEAVE.
    END.

IF  NOT AVAIL int-rat-desp-segur THEN DO:
    ASSIGN p-erro = "N∆o existe registro de permiss∆o cadastrado para o rateio.".
    RETURN "NOK".
END.

IF  p-acao = "C" 
AND int-rat-desp-segur.tipo-seguranca <> 2 /*Contabilizaá∆o*/ THEN DO:
    ASSIGN p-erro = "Uus†rio sem permiss∆o para efetuar Simulaá∆o/Contabilizaá∆o".
    RETURN "NOK".
END.

RETURN "OK".








