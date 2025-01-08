{utp/ut-glob.i}
    
DEFINE NEW GLOBAL SHARED VARIABLE gCodUsuario         AS CHAR NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE gCodColetor         AS CHAR NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE gCodEquipamento     AS CHAR NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE gCodTipoEquip       AS CHAR NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE gCodLocal           AS CHAR NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE gCodEstab           AS CHAR NO-UNDO.


ASSIGN gCodUsuario = c-seg-usuario.

FIND FIRST usuar_univ WHERE
    usuar_univ.cod_usuario = gCodUsuario NO-LOCK NO-ERROR.
IF NOT AVAIL usuar_univ THEN DO:
    FIND FIRST wm-param NO-LOCK NO-ERROR.
    IF AVAIL wm-param THEN DO:
        ASSIGN gCodEstab = wm-param.cod-estabel.
        FIND FIRST wm-local WHERE
             wm-local.cod-estabel      = wm-param.cod-estabel AND
             wm-local.log-local-padrao = yes NO-LOCK NO-ERROR.
        ASSIGN gCodLocal   = IF AVAIL wm-local THEN wm-local.cod-local ELSE "":U.
    END.
END.
ELSE DO:
    ASSIGN gCodEstab = usuar_univ.cod_estab.
    FIND FIRST wm-local WHERE
         wm-local.cod-estabel      = usuar_univ.cod_estab AND
         wm-local.log-local-padrao = yes NO-LOCK NO-ERROR.
    ASSIGN gCodLocal   = IF AVAIL wm-local THEN wm-local.cod-local ELSE "":U.
END.

