{include/i_dbvers.i}  /* versao das bases e bases instaladas */
/********************************************************************************
**  Programa: ESWMP027API.P 
**  Data....: ABRIL / 2022
**  Autor...: STOUT / SCM Concept
**  Objetivo: API para gera‡Æo de relacionamento de equipamento com os endere‡os
**            conforme cadastro de zona de separa‡Æo Flow Rack
********************************************************************************/
{utp/ut-glob.i}                
{method/dbotterr.i}

DEFINE INPUT  PARAMETER pCodEstabel LIKE zona-separa.cod-estabel NO-UNDO.
DEFINE INPUT  PARAMETER pCodLocal   LIKE zona-separa.cod-local   NO-UNDO.
DEFINE INPUT  PARAMETER pCodZona    LIKE zona-separa.cod-zona    NO-UNDO.

DEFINE VARIABLE h-acomp AS HANDLE      NO-UNDO.

FOR FIRST zona-separa NO-LOCK
    WHERE zona-separa.cod-estabel = pCodEstabel
      AND zona-separa.cod-local   = pCodLocal
      AND zona-separa.cod-zona    = pCodZona:
END.

IF NOT AVAIL zona-separa THEN
    RETURN.

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
RUN pi-inicializar IN h-acomp (INPUT 'Aguarde').
RUN pi-acompanhar IN h-acomp (INPUT 'Atualizando acesso equipamentos').

FOR EACH zona-separa-box NO-LOCK
    WHERE zona-separa-box.cod-estabel = zona-separa.cod-estabel
      AND zona-separa-box.cod-local   = zona-separa.cod-local
      AND zona-separa-box.cod-zona    = zona-separa.cod-zona,
    FIRST wm-box NO-LOCK
        WHERE wm-box.cod-estabel = zona-separa-box.cod-estabel
          AND wm-box.cod-local   = zona-separa-box.cod-local
          AND wm-box.id-box      = zona-separa-box.id-box:

    /* para cada endere‡o verifica equipamento */
    FOR EACH zona-separa-equip NO-LOCK
        WHERE zona-separa-equip.cod-estabel = zona-separa.cod-estabel
          AND zona-separa-equip.cod-local   = zona-separa.cod-local
          AND zona-separa-equip.cod-zona    = zona-separa.cod-zona:

        FOR FIRST wm-equipamento-acesso EXCLUSIVE-LOCK
            WHERE wm-equipamento-acesso.cod-estab       = wm-box.cod-estabel
              AND wm-equipamento-acesso.cod-local       = wm-box.cod-local
              AND wm-equipamento-acesso.cod-bloco-wms   = wm-box.cod-bloco
              AND wm-equipamento-acesso.cod-equipamento = zona-separa-equip.cod-equipamento
              AND wm-equipamento-acesso.cod-rua         = wm-box.cod-rua
              AND wm-equipamento-acesso.cod-nivel       = wm-box.cod-nivel:
        END.

        IF NOT AVAIL wm-equipamento-acesso THEN DO:
            CREATE wm-equipamento-acesso.
            ASSIGN wm-equipamento-acesso.cod-estab       = wm-box.cod-estabel
                   wm-equipamento-acesso.cod-local       = wm-box.cod-local
                   wm-equipamento-acesso.cod-bloco-wms   = wm-box.cod-bloco
                   wm-equipamento-acesso.cod-equipamento = zona-separa-equip.cod-equipamento
                   wm-equipamento-acesso.cod-rua         = wm-box.cod-rua
                   wm-equipamento-acesso.cod-nivel       = wm-box.cod-nivel.
        END.

        ASSIGN wm-equipamento-acesso.val-prioridade = zona-separa-equip.cod-prioridade.
    END.
END.

RUN pi-finalizar IN h-acomp.

RETURN "OK".

