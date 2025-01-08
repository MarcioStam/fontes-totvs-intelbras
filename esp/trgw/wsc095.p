DEF PARAMETER BUFFER b-wm-tarefa-docto FOR wm-tarefa-docto.
DEF PARAMETER BUFFER b-old-wm-tarefa-docto FOR wm-tarefa-docto.
{utp/ut-glob.i}

IF NEW b-wm-tarefa-docto THEN DO:

    IF PROGRAM-NAME(9) <> ? AND
       PROGRAM-NAME(9) MATCHES "*iwm9700*" THEN.
    ELSE DO:
        FIND FIRST wm-docto NO-LOCK
             WHERE wm-docto.cod-estabel = b-wm-tarefa-docto.cod-estabel
               AND wm-docto.cod-local   = b-wm-tarefa-docto.cod-local
               AND wm-docto.id-docto    = b-wm-tarefa-docto.id-docto NO-ERROR.
        IF AVAIL wm-docto THEN DO:
            IF wm-docto.ind-origem-docto = 7 /*transferencia deposito*/ THEN DO:
                FIND FIRST docto-transf-depos NO-LOCK
                     WHERE docto-transf-depos.num-docto-transf = int(wm-docto.num-docto) NO-ERROR.

                IF AVAIL docto-transf-depos THEN DO:
                    CREATE in-wm-tarefa-docto.
                    ASSIGN in-wm-tarefa-docto.id-tarefa   = b-wm-tarefa-docto.id-tarefa
                           in-wm-tarefa-docto.cod-local   = docto-transf-depos.cod-depos-entr
                           in-wm-tarefa-docto.cod-localiz = ""
                           in-wm-tarefa-docto.cod-usuario = c-seg-usuario
                           in-wm-tarefa-docto.hora-tarefa = (7 * 3600).
                END.
            END.
            ELSE IF wm-docto.ind-origem-docto = 21 /*transferencia ccusto*/ THEN DO:
                FIND FIRST requisicao NO-LOCK
                     WHERE requisicao.nr-requisicao = int(wm-docto.num-docto) NO-ERROR.
                IF AVAIL requisicao THEN DO:
                    CREATE in-wm-tarefa-docto.
                    ASSIGN in-wm-tarefa-docto.id-tarefa   = b-wm-tarefa-docto.id-tarefa
                           in-wm-tarefa-docto.cod-local   = requisicao.nome-abrev
                           in-wm-tarefa-docto.cod-localiz = ""
                           in-wm-tarefa-docto.cod-usuario = requisicao.nome-abrev
                           in-wm-tarefa-docto.hora-tarefa = (7 * 3600).
                END.
            END.
            ELSE IF wm-docto.ind-origem-docto = 19 /*Requisi‡Æo Material Produ‡Æo*/ THEN DO:
                FIND FIRST ord-prod NO-LOCK
                     WHERE ord-prod.nr-ord-prod = int(wm-docto.num-docto) NO-ERROR.
                IF AVAIL ord-prod THEN DO:
                    CREATE in-wm-tarefa-docto.
                    ASSIGN in-wm-tarefa-docto.id-tarefa   = b-wm-tarefa-docto.id-tarefa
                           in-wm-tarefa-docto.cod-local   = STRING(ord-prod.nr-ord-prod, "9999999")
                           in-wm-tarefa-docto.cod-localiz = ""
                           in-wm-tarefa-docto.cod-usuario = ord-prod.usuario-alt
                           in-wm-tarefa-docto.hora-tarefa = (7 * 3600).
                END.
            END.
        END.
    END.
END.

