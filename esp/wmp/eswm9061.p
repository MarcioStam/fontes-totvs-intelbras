/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i WM9061 2.00.00.050 } /*** 010050 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i wm9061 MWM}
&ENDIF

/********************************************************************************
**  Programa: WM9061.P
**  Data....: Maio de 2002
**  Autor...: DATASUL DESENVOLVIMENTO DE SISTEMAS S.A.
**  Objetivo: Confirmacao Ressuprimento
********************************************************************************/
/** Definicao tt-epc **/
{include/i-epc200.i wm9061}
{method/dbotterr.i}
{cdp/cdcfgmat.i}
{utp/ut-glob.i}

DEF TEMP-TABLE tt-tarefa-docto NO-UNDO
    FIELD CodUsuario     LIKE wm-tarefa-docto-itens.cod-usuario
    FIELD CodEquipamento LIKE wm-tarefa-docto-itens.cod-equipamento
    FIELD CodColetor     LIKE wm-tarefa-docto-itens.cod-coletor
    FIELD TempoInicio    AS INTEGER.

DEF TEMP-TABLE tt-etiqueta NO-UNDO
    FIELD id-etiqueta  LIKE wm-etiqueta.id-etiqueta
    FIELD qtd-retirada LIKE wm-etiqueta.qtd-item
    INDEX codigo IS UNIQUE id-etiqueta.

DEF TEMP-TABLE tt-saldos-transf NO-UNDO
    FIELD cod-estabel LIKE wm-box-saldo.cod-estabel
    FIELD cod-local   LIKE wm-box-saldo.cod-local
    FIELD id-saldo    LIKE wm-box-saldo.id-saldo
    FIELD id-saldo-novo LIKE wm-box-saldo.id-saldo
    FIELD qtd-retirada  LIKE wm-box-saldo.qtd-item.

DEF TEMP-TABLE tt-etiqueta-saldo NO-UNDO
    FIELD cod-estabel LIKE wm-box-saldo.cod-estabel
    FIELD cod-local   LIKE wm-box-saldo.cod-local
    FIELD id-saldo    LIKE wm-box-saldo.id-saldo
    FIELD id-etiqueta  LIKE wm-etiqueta.id-etiqueta.

DEF INPUT PARAM de-id-saida    AS DECIMAL NO-UNDO.   /* id endereco saida */
DEF INPUT PARAM de-id-entrada  AS DECIMAL NO-UNDO.   /* id endereco entrada */
DEF INPUT PARAM r-movto-ressup AS ROWID NO-UNDO.     /* rowid do movto ressup */
DEF INPUT PARAM TABLE FOR tt-tarefa-docto.           /* tt tarefas */
DEF INPUT PARAM TABLE FOR tt-etiqueta.               /* tt etiquetas */
DEF OUTPUT PARAM TABLE FOR RowErrors.                /* tt erros */

/* Buffer's p/ registros destino (entrada) */
DEF BUFFER bfwm-box-movto          FOR wm-box-movto.
DEF BUFFER bfwm-box-saldo-etiqueta FOR wm-box-saldo-etiqueta.
DEF BUFFER bfwm-box-saldo          FOR wm-box-saldo.
DEF BUFFER b-wm-etiqueta           FOR wm-etiqueta.
DEF BUFFER bfWm-etiqueta	       FOR wm-etiqueta.

DEFINE VARIABLE de-tot-qtd          AS DECIMAL                  NO-UNDO.
DEFINE VARIABLE de-id-box           LIKE wm-box.id-box          NO-UNDO.
DEFINE VARIABLE de-qtd-saldo        LIKE wm-box-saldo.qtd-item  NO-UNDO.
DEFINE VARIABLE de-qtd-peso         AS DEC                      NO-UNDO.
DEFINE VARIABLE de-qtd-ua           AS DEC                      NO-UNDO.
DEFINE VARIABLE l-embalagem-filha   AS LOGICAL                  NO-UNDO.
DEFINE VARIABLE l-avail-etiqueta    AS LOGICAL                  NO-UNDO.
DEFINE VARIABLE l-valid-embalagem   AS LOGICAL                  NO-UNDO.
DEFINE VARIABLE l-lote-avancado     AS LOGICAL                  NO-UNDO.
DEFINE VARIABLE ch-lote-verificado  LIKE wm-box-saldo.cod-lote  NO-UNDO.
DEFINE VARIABLE l-lote-bloqueado    AS LOGICAL                  NO-UNDO.
DEFINE VARIABLE h-proxy124          AS HANDLE                   NO-UNDO.
DEFINE VARIABLE l-aloca-wms         AS LOGICAL                  NO-UNDO.
DEFINE VARIABLE l-saldo-disp        AS LOGICAL                  NO-UNDO.
DEFINE VARIABLE l-existe            AS LOGICAL                  NO-UNDO.
DEFINE VARIABLE i                   AS INTEGER                  NO-UNDO.
DEFINE VARIABLE i-id-agrupador      AS INTEGER                  NO-UNDO.

/* Chamada EPC */
{include/i-epc200.i2 &CodEvent='"initialize"'
                     &CodParameter='"handle-tt-etiqueta"'
                     &ValueParameter="string(TEMP-TABLE tt-etiqueta:HANDLE)"}

{include/i-epc200.i2 &CodEvent='"initialize"'
                     &CodParameter='"rowid-wm-box-movto"'
                     &ValueParameter="string(r-movto-ressup)"}

{include/i-epc201.i "initialize"}
/* Fim Chamada EPC */

FIND FIRST wm-param NO-LOCK NO-ERROR.
IF NOT AVAIL wm-param THEN DO:
    /* Inicio -- Projeto Internacional */
    {utp/ut-liter.i "Parƒmetros_WMS" *}
    RUN piCreateError (INPUT 56,
                       INPUT RETURN-VALUE,
                       INPUT "EMS",
                       INPUT "ERROR").
    RETURN "NOK":U.
END.

/* Valida Movimento Saida */
FIND FIRST wm-box-movto EXCLUSIVE-LOCK
     WHERE ROWID(wm-box-movto) = r-movto-ressup NO-ERROR.

IF NOT AVAIL wm-box-movto THEN DO:
    /* Inicio -- Projeto Internacional */
    {utp/ut-liter.i "Movimento" *}
    RUN piCreateError (INPUT 56,
                       INPUT RETURN-VALUE,
                       INPUT "EMS",
                       INPUT "ERROR").
    RETURN "NOK":U.
END. 

/* Valida Movimento Entrada */
FIND FIRST bfwm-box-movto EXCLUSIVE-LOCK 
     WHERE bfwm-box-movto.cod-estabel    = wm-box-movto.cod-estabel
       AND bfwm-box-movto.cod-local      = wm-box-movto.cod-local
       AND bfwm-box-movto.id-movto       = wm-box-movto.id-movto
       AND bfwm-box-movto.ind-tipo-movto = 1 NO-ERROR.

FIND FIRST wm-box NO-LOCK
     WHERE wm-box.cod-estabel = wm-box-movto.cod-estabel
       AND wm-box.cod-local   = wm-box-movto.cod-local
       AND wm-box.id-box      = wm-box-movto.id-box NO-ERROR.

IF NOT AVAIL wm-box THEN DO:
    /* Inicio -- Projeto Internacional */
    {utp/ut-liter.i "Endere‡o" *}
    RUN piCreateError (INPUT 56,
                       INPUT RETURN-VALUE + " " + STRING(wm-box-movto.id-box),
                       INPUT "EMS",
                       INPUT "ERROR").
END.
ELSE DO:
    /** Verifica se o Endereco de Retirada esta Bloqueado para Retirada **/
    IF wm-box.log-bloq-retir THEN DO:
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "retirada" *}
        RUN piCreateError (INPUT 28259,
                           INPUT STRING(wm-box.id-box) + "~~" + RETURN-VALUE,
                           INPUT "EMS",
                           INPUT "ERROR").
    END.
END.

IF AVAIL bfwm-box-movto THEN DO:
    FIND FIRST wm-box NO-LOCK
         WHERE wm-box.cod-estabel = bfwm-box-movto.cod-estabel
           AND wm-box.cod-local   = bfwm-box-movto.cod-local
           AND wm-box.id-box      = bfwm-box-movto.id-box NO-ERROR.

    IF NOT AVAIL wm-box THEN DO:
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Endere‡o" *}
        RUN piCreateError (INPUT 56,
                           INPUT RETURN-VALUE + " " + STRING(bfwm-box-movto.id-box),
                           INPUT "EMS",
                           INPUT "ERROR").
    END.
    ELSE DO:
        /** Verifica se o Endereco da Area Picking esta Bloqueado para Armazenamento **/
        IF wm-box.log-bloq-armaz THEN DO:
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "armazenamento" *}
            RUN piCreateError (INPUT 28259,
                               INPUT STRING(wm-box.id-box) + "~~" + RETURN-VALUE,
                               INPUT "EMS",
                               INPUT "ERROR").
        END.
    END.
END.

IF wm-box-movto.ind-status-movto <> 1 THEN
    RUN piCreateError (INPUT 27015, INPUT "", INPUT "EMS", INPUT "ERROR").

IF wm-box-movto.ind-tipo-movto <> 2 THEN /* Saida */
    /* Inicio -- Projeto Internacional */
    DO:
    {utp/ut-liter.i "de_Movimento" *}
    RUN piCreateError (INPUT 781, INPUT RETURN-VALUE, INPUT "EMS", INPUT "ERROR").
    END. 

IF wm-box-movto.id-box <> de-id-saida THEN
    /* Inicio -- Projeto Internacional */
    DO:
    {utp/ut-liter.i "'Sa¡da'" *}
    RUN piCreateError (INPUT 27501, INPUT RETURN-VALUE, INPUT "EMS", INPUT "ERROR").
    END. 

IF bfwm-box-movto.id-box <> de-id-entrada THEN
    /* Inicio -- Projeto Internacional */
    DO:
    {utp/ut-liter.i "'Entrada'" *}
    RUN piCreateError (INPUT 27501, INPUT RETURN-VALUE, INPUT "EMS", INPUT "ERROR").
    END. 

/* BOF Validacoes Uso Etiqueta Local */
FIND FIRST wm-local NO-LOCK
     WHERE wm-local.cod-estabel = wm-box-movto.cod-estabel
       AND wm-local.cod-local   = wm-box-movto.cod-local NO-ERROR.
IF NOT AVAIL wm-local THEN DO:
    /* Inicio -- Projeto Internacional */
    {utp/ut-liter.i "Local" *}
    RUN piCreateError (INPUT 56, INPUT RETURN-VALUE, INPUT "EMS", INPUT "ERROR").
END.
ELSE DO:
    IF wm-local.log-utiliz-etiq-movto AND NOT CAN-FIND(FIRST tt-etiqueta) THEN
        RUN piCreateError (INPUT 51880, INPUT "", INPUT "EMS", INPUT "ERROR").
    IF NOT wm-local.log-utiliz-etiq-movto AND CAN-FIND(FIRST tt-etiqueta) THEN
        RUN piCreateError (INPUT 51820, INPUT "", INPUT "EMS", INPUT "ERROR").
END.
/* EOF Validacoes Uso Etiqueta Local */

IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
    RETURN "NOK":U.

FIND FIRST wm-docto-itens NO-LOCK
     WHERE wm-docto-itens.cod-estabel  = wm-box-movto.cod-estabel 
       AND wm-docto-itens.cod-local    = wm-box-movto.cod-local 
       AND wm-docto-itens.id-docto     = wm-box-movto.id-docto
       AND wm-docto-itens.num-seq-item = wm-box-movto.num-seq-item NO-ERROR.

ASSIGN de-tot-qtd = 0.

ASSIGN l-avail-etiqueta = NO.
FOR EACH tt-etiqueta NO-LOCK:

    FIND FIRST wm-etiqueta NO-LOCK
         WHERE wm-etiqueta.id-etiqueta = tt-etiqueta.id-etiqueta NO-ERROR.

    IF NOT AVAIL wm-etiqueta THEN DO:
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Etiqueta" *}
        RUN piCreateError (INPUT 7381,
                           INPUT RETURN-VALUE,
                           INPUT "EMS",
                           INPUT "ERROR").
    END.
    ELSE DO:
        /** Verifica se a Etiqueta esta Bloqueada **/
        IF wm-etiqueta.ind-leitura-etiqueta = 5 THEN DO:
            RUN piCreateError (INPUT 28244,
                               INPUT STRING(wm-etiqueta.id-etiqueta),
                               INPUT "EMS",
                               INPUT "ERROR").
        END.

        IF wm-etiqueta.ind-sit-agrupador = 2 THEN DO:
            FIND FIRST b-wm-etiqueta NO-LOCK
                 WHERE b-wm-etiqueta.id-agrupador         = wm-etiqueta.id-etiqueta
                   AND b-wm-etiqueta.ind-leitura-etiqueta = 5 NO-ERROR.

            IF AVAIL b-wm-etiqueta THEN DO:
                RUN piCreateError (INPUT 28457,
                                   INPUT STRING(b-wm-etiqueta.id-etiqueta) + "~~" + STRING(wm-etiqueta.id-etiqueta),
                                   INPUT "EMS":U,
                                   INPUT "ERROR":U).
            END.
        END.

        ASSIGN l-valid-embalagem = YES.

        /* Chamada EPC */
        FOR EACH tt-epc
           WHERE tt-epc.cod-event = 'valida-embalagem':U EXCLUSIVE-LOCK:
            DELETE tt-epc.
        END.
        {include/i-epc200.i2 &CodEvent='"valida-embalagem"'
                             &CodParameter='"rowid-wm-box-movto"'
                             &ValueParameter="string(rowid(wm-box-movto))"}
        {include/i-epc200.i2 &CodEvent='"valida-embalagem"'
                             &CodParameter='"rowid-wm-etiqueta"'
                             &ValueParameter="string(rowid(wm-etiqueta))"}

        {include/i-epc201.i 'valida-embalagem':U}

        IF CAN-FIND(FIRST tt-epc
                    WHERE tt-epc.cod-parameter = "RetornoEPC":U 
                      AND tt-epc.val-parameter = "NO":U) THEN
            ASSIGN l-valid-embalagem = NO.
        /* Fim Chamada EPC */

        IF l-valid-embalagem THEN DO:
            IF wm-etiqueta.cod-embalagem <> wm-box-movto.cod-embalagem THEN DO:
                /* Inicio -- Projeto Internacional */
                {utp/ut-liter.i "Embalagem" *}
                RUN piCreateError (INPUT 26427, INPUT RETURN-VALUE, INPUT "EMS", INPUT "ERROR").
            END.
        END.

        IF wm-etiqueta.cod-item <> wm-box-movto.cod-item THEN
            /* Inicio -- Projeto Internacional */
            DO:
            {utp/ut-liter.i "Item" *}
            RUN piCreateError (INPUT 26427, INPUT RETURN-VALUE, INPUT "EMS", INPUT "ERROR").
            END. 

        IF wm-etiqueta.cod-lote <> wm-box-movto.cod-lote THEN
            /* Inicio -- Projeto Internacional */
            DO:
            {utp/ut-liter.i "Lote" *}
            RUN piCreateError (INPUT 26427, INPUT RETURN-VALUE, INPUT "EMS", INPUT "ERROR").
            END. 

        IF wm-etiqueta.cod-refer <> wm-box-movto.cod-refer THEN
            /* Inicio -- Projeto Internacional */
            DO:
            {utp/ut-liter.i "Referˆncia" *}
            RUN piCreateError (INPUT 26427, INPUT RETURN-VALUE, INPUT "EMS", INPUT "ERROR").
            END. 

        IF tt-etiqueta.qtd-retirada <= 0 THEN
            RUN piCreateError (INPUT 2920, INPUT "", INPUT "EMS", INPUT "ERROR").

        ASSIGN de-tot-qtd = de-tot-qtd + tt-etiqueta.qtd-retirada
               l-avail-etiqueta = YES.

    END.
END.

IF  de-tot-qtd = 0 THEN
    ASSIGN de-tot-qtd = wm-box-movto.qtd-item * wm-box-movto.qti-embalagem.

IF  de-tot-qtd = 0 THEN DO:
    RUN piCreateError (INPUT 2920, INPUT "", INPUT "EMS", INPUT "ERROR").
END.

IF  CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
    RETURN "NOK":U.

&IF '{&bf_lote_avancado_liberado}' = 'yes' &THEN
    IF CAN-FIND(FIRST funcao NO-LOCK
                WHERE funcao.cd-funcao = 'lote-avancado':U
                  AND funcao.ativo     = YES) THEN
        ASSIGN l-lote-avancado = YES.
    ELSE
        ASSIGN l-lote-avancado = NO.
&ELSE
    ASSIGN l-lote-avancado = NO.
&ENDIF.

BLOCO:
DO ON ERROR UNDO BLOCO, RETURN 'NOK':U:

    /* Atualizacao dos saldos */
    /*
    FOR EACH wm-box-saida-ressup
       WHERE wm-box-saida-ressup.cod-estabel  = wm-box-movto.cod-estabel
         AND wm-box-saida-ressup.cod-local    = wm-box-movto.cod-local
         AND wm-box-saida-ressup.id-movto     = wm-box-movto.id-movto EXCLUSIVE-LOCK:
    */
    IF l-avail-etiqueta THEN DO:

        ASSIGN wm-box-movto.ind-status-movto   = 3
               bfwm-box-movto.ind-status-movto = 3.

        VALIDATE bfwm-box-movto.
        VALIDATE wm-box-movto.

        IF CAN-FIND (FIRST wms-box-sdo-alocad 
                     WHERE wms-box-sdo-alocad.cod-estabel   = wm-box-movto.cod-estabel
                       AND wms-box-sdo-alocad.cod-local     = wm-box-movto.cod-local
                       AND wms-box-sdo-alocad.cod-cliente   = wm-box-movto.cod-cliente
                       AND wms-box-sdo-alocad.id-box        = wm-box-movto.id-box
                       AND wms-box-sdo-alocad.id-docto      = wm-box-movto.id-docto
                       AND wms-box-sdo-alocad.num-seq-item  = wm-box-movto.num-seq-item
                       AND wms-box-sdo-alocad.cod-lote      = wm-box-movto.cod-lote
                       AND wms-box-sdo-alocad.cod-embalagem = wm-box-movto.cod-embalagem) THEN DO:

            FOR EACH wms-box-sdo-alocad EXCLUSIVE-LOCK
               WHERE wms-box-sdo-alocad.cod-estabel   = wm-box-movto.cod-estabel
                 AND wms-box-sdo-alocad.cod-local     = wm-box-movto.cod-local
                 AND wms-box-sdo-alocad.cod-cliente   = wm-box-movto.cod-cliente
                 AND wms-box-sdo-alocad.id-box        = wm-box-movto.id-box
                 AND wms-box-sdo-alocad.id-docto      = wm-box-movto.id-docto
                 AND wms-box-sdo-alocad.num-seq-item  = wm-box-movto.num-seq-item
                 AND wms-box-sdo-alocad.cod-lote      = wm-box-movto.cod-lot
                 AND wms-box-sdo-alocad.cod-embalagem = wm-box-movto.cod-embalagem:
    
                ASSIGN wms-box-sdo-alocad.qtd-item-retir = wms-box-sdo-alocad.qtd-item-retir + (wm-box-movto.qtd-item * wm-box-movto.qti-embalagem).
                
                IF wms-box-sdo-alocad.qtd-alocad <= wms-box-sdo-alocad.qtd-item-retir THEN
                    DELETE wms-box-sdo-alocad.
            END.
        END.
        ELSE DO:
            FOR EACH wms-box-sdo-alocad EXCLUSIVE-LOCK
               WHERE wms-box-sdo-alocad.cod-estabel   = wm-box-movto.cod-estabel
                 AND wms-box-sdo-alocad.cod-local     = wm-box-movto.cod-local
                 AND wms-box-sdo-alocad.cod-cliente   = wm-box-movto.cod-cliente
                 AND wms-box-sdo-alocad.id-box        = wm-box-movto.id-box
                 AND wms-box-sdo-alocad.id-docto      = wm-box-movto.id-docto
                 AND wms-box-sdo-alocad.num-seq-item  = wm-box-movto.num-seq-item
                 AND wms-box-sdo-alocad.cod-lote      = wm-box-movto.cod-lote:
    
                ASSIGN wms-box-sdo-alocad.qtd-item-retir = wms-box-sdo-alocad.qtd-item-retir + (wm-box-movto.qtd-item * wm-box-movto.qti-embalagem).
                
                IF wms-box-sdo-alocad.qtd-alocad <= wms-box-sdo-alocad.qtd-item-retir THEN
                    DELETE wms-box-sdo-alocad.
            END.
        END.
        
        FOR EACH bfwm-box-saldo
           WHERE bfwm-box-saldo.cod-estabel      = bfwm-box-movto.cod-estabel
             AND bfwm-box-saldo.cod-local        = bfwm-box-movto.cod-local
             AND bfwm-box-saldo.id-box           = bfwm-box-movto.id-box
             AND bfwm-box-saldo.cod-item         = bfwm-box-movto.cod-item
             AND bfwm-box-saldo.cod-refer        = bfwm-box-movto.cod-refer
             AND bfwm-box-saldo.cod-embalagem    = bfwm-box-movto.cod-embalagem
             AND bfwm-box-saldo.ind-status-saldo = 2 /* destinado */
             AND bfwm-box-saldo.cod-cliente      = bfwm-box-movto.cod-cliente
             AND bfwm-box-saldo.id-docto         = bfwm-box-movto.id-docto
             AND bfwm-box-saldo.num-seq-item     = bfwm-box-movto.num-seq-item
             AND bfwm-box-saldo.id-movto         = bfwm-box-movto.id-movto EXCLUSIVE-LOCK:
                DELETE bfwm-box-saldo.
        END.

        FOR EACH tt-etiqueta NO-LOCK,
            FIRST wm-box-saldo-etiqueta NO-LOCK
            WHERE wm-box-saldo-etiqueta.cod-estabel = wm-box-movto.cod-estabel
              AND wm-box-saldo-etiqueta.cod-local   = wm-box-movto.cod-local
              AND wm-box-saldo-etiqueta.id-box      = de-id-saida
              AND wm-box-saldo-etiqueta.id-etiqueta = tt-etiqueta.id-etiqueta,
            FIRST wm-box-saldo EXCLUSIVE-LOCK
            WHERE wm-box-saldo.cod-estabel = wm-box-saldo-etiqueta.cod-estabel
              AND wm-box-saldo.cod-local   = wm-box-saldo-etiqueta.cod-local
              AND wm-box-saldo.id-saldo    = wm-box-saldo-etiqueta.id-saldo:

            CREATE bfwm-box-saldo.
            ASSIGN bfwm-box-saldo.cod-estabel      = wm-box-movto.cod-estabel
                   bfwm-box-saldo.cod-local        = wm-box-movto.cod-local
                   bfwm-box-saldo.id-docto         = wm-box-movto.id-docto
                   bfwm-box-saldo.num-seq-item     = wm-box-movto.num-seq-item
                   bfwm-box-saldo.cod-cliente      = wm-box-saldo.cod-cliente
                   bfwm-box-saldo.cod-embalagem    = wm-box-saldo.cod-embalagem
                   bfwm-box-saldo.cod-item         = wm-box-saldo.cod-item
                   bfwm-box-saldo.cod-refer        = wm-box-saldo.cod-refer
                   bfwm-box-saldo.cod-lote         = wm-box-saldo.cod-lote
                   bfwm-box-saldo.dt-atua-saldo    = TODAY
                   bfwm-box-saldo.dt-transacao     = TODAY
                   bfwm-box-saldo.id-box           = de-id-entrada
                   bfwm-box-saldo.id-saldo         = NEXT-VALUE(id-saldo-wms)
                   bfwm-box-saldo.ind-status-box   = 1
                   bfwm-box-saldo.ind-status-saldo = 3
                   bfwm-box-saldo.qtd-item         = /*wm-box-saldo.qtd-item - bfwm-box-saldo.qtd-item-bloq*/ tt-etiqueta.qtd-retirada
                   bfwm-box-saldo.qtd-item-bloq    = 0
                   bfwm-box-saldo.qtd-original     = bfwm-box-saldo.qtd-item
                   bfwm-box-saldo.id-movto         = wm-box-movto.id-movto.

            IF CAN-FIND(FIRST funcao WHERE funcao.cd-funcao = "spp-dt-transacao-wms" AND funcao.ativo = YES) THEN
                ASSIGN bfwm-box-saldo.dt-transacao = wm-etiqueta.dt-geracao.

            FIND FIRST wm-saldo-estoque EXCLUSIVE-LOCK
                 WHERE wm-saldo-estoque.cod-estabel = bfwm-box-saldo.cod-estabel
                   AND wm-saldo-estoque.cod-local   = bfwm-box-saldo.cod-local
                   AND wm-saldo-estoque.cod-item    = bfwm-box-saldo.cod-item
                   AND wm-saldo-estoque.cod-refer   = bfwm-box-saldo.cod-refer
                   AND wm-saldo-estoque.cod-lote    = bfwm-box-saldo.cod-lote
                   AND wm-saldo-estoque.cod-cliente = bfwm-box-saldo.cod-cliente NO-ERROR.

            IF AVAIL wm-saldo-estoque THEN DO:
                ASSIGN wm-saldo-estoque.qtd-liberada = wm-saldo-estoque.qtd-liberada + bfwm-box-saldo.qtd-item.
                FIND CURRENT wm-saldo-estoque NO-LOCK NO-ERROR.
            END.

            CREATE tt-etiqueta-saldo.
            ASSIGN tt-etiqueta-saldo.cod-estabel   = wm-box-saldo.cod-estabel
                   tt-etiqueta-saldo.cod-local     = wm-box-saldo.cod-local
                   tt-etiqueta-saldo.id-saldo      = wm-box-saldo.id-saldo
                   tt-etiqueta-saldo.id-etiqueta   = tt-etiqueta.id-etiqueta.

            FIND FIRST tt-saldos-transf
                 WHERE tt-saldos-transf.cod-estabel = wm-box-saldo.cod-estabel
                   AND tt-saldos-transf.cod-local   = wm-box-saldo.cod-local
                   AND tt-saldos-transf.id-saldo    = wm-box-saldo.id-saldo NO-ERROR.
            IF AVAIL tt-saldos-transf THEN DO:
                 ASSIGN tt-saldos-transf.qtd-retirada  = tt-saldos-transf.qtd-retirada + tt-etiqueta.qtd-retirada.
                 NEXT.
            END.

            CREATE tt-saldos-transf.
            ASSIGN tt-saldos-transf.cod-estabel   = wm-box-saldo.cod-estabel
                   tt-saldos-transf.cod-local     = wm-box-saldo.cod-local
                   tt-saldos-transf.id-saldo      = wm-box-saldo.id-saldo
                   tt-saldos-transf.id-saldo-novo = bfwm-box-saldo.id-saldo
                   tt-saldos-transf.qtd-retirada  = tt-etiqueta.qtd-retirada.

            /*Atualiza‡Æo das capacidades do endere‡o origem*/
            FIND FIRST wm-box EXCLUSIVE-LOCK
                 WHERE wm-box.cod-estabel = wm-box-saldo.cod-estabel
                   AND wm-box.cod-local   = wm-box-saldo.cod-local
                   AND wm-box.id-box      = wm-box-saldo.id-box NO-ERROR.

            FIND FIRST wm-item NO-LOCK
                 WHERE wm-item.cod-item = bfwm-box-saldo.cod-item NO-ERROR.

            FIND FIRST wm-item-embalagem-local NO-LOCK
                 WHERE wm-item-embalagem-local.cod-estabel   = wm-box-saldo.cod-estabel
                   AND wm-item-embalagem-local.cod-local     = wm-box-saldo.cod-local
                   AND wm-item-embalagem-local.cod-item      = wm-box-saldo.cod-item
                   AND wm-item-embalagem-local.cod-embalagem = wm-box-saldo.cod-embalagem NO-ERROR.

            IF NOT AVAIL wm-item-embalagem-local  THEN DO:
                FIND FIRST wm-item-embalagem-local NO-LOCK 
                     WHERE wm-item-embalagem-local.cod-estabel  = wm-box-saldo.cod-estabel
                       AND wm-item-embalagem-local.cod-local    = wm-box-saldo.cod-local
                       AND wm-item-embalagem-local.cod-item     = wm-box-saldo.cod-item
                       AND wm-item-embalagem-local.cod-emb-item = wm-box-saldo.cod-embalagem NO-ERROR.

                ASSIGN de-qtd-peso = wm-item-embalagem-local.qtd-peso-item
                       de-qtd-ua   = wm-item-embalagem-local.qtd-volume.
            END.
            ELSE
                ASSIGN de-qtd-peso = wm-item-embalagem-local.qtd-peso
                       de-qtd-ua   = wm-item-embalagem-local.qtd-volume.

            /* Atualiza Box - Como a wm-box-saldo est  sendo elminada, retira toda a ocupacao que ela tinha do box*/
            ASSIGN wm-box.qtd-capacidade-peso-util = wm-box.qtd-capacidade-peso-util - (de-qtd-peso  + (wm-item.qtd-peso * (wm-box-movto.qtd-item * wm-box-movto.qti-embalagem)))
                   wm-box.qtd-capacidade-ua-util   = wm-box.qtd-capacidade-ua-util   - (de-qtd-ua).

            IF wm-box.qtd-capacidade-peso-util < 0 THEN
                ASSIGN wm-box.qtd-capacidade-peso-util = 0.

            IF wm-box.qtd-capacidade-ua-util < 0 THEN
                ASSIGN wm-box.qtd-capacidade-ua-util = 0.

        END.
        FOR EACH tt-saldos-transf:
            FOR EACH wm-box-saldo-etiqueta EXCLUSIVE-LOCK
               WHERE wm-box-saldo-etiqueta.cod-estabel = tt-saldos-transf.cod-estabel
                 AND wm-box-saldo-etiqueta.cod-local   = tt-saldos-transf.cod-local
                 AND wm-box-saldo-etiqueta.id-saldo    = tt-saldos-transf.id-saldo:
                /*FIND FIRST tt-etiqueta-saldo 
                   WHERE tt-etiqueta-saldo.cod-estabel = wm-box-saldo-etiqueta.cod-estabel
                     AND tt-etiqueta-saldo.cod-local   = wm-box-saldo-etiqueta.cod-local  
                     AND tt-etiqueta-saldo.id-saldo    = wm-box-saldo-etiqueta.id-saldo NO-ERROR.
                IF AVAIL tt-etiqueta-saldo THEN*/
                     ASSIGN wm-box-saldo-etiqueta.id-saldo = tt-saldos-transf.id-saldo-novo
                            wm-box-saldo-etiqueta.id-box   = de-id-entrada.             
                /*END.*/
            END.
            FOR EACH wm-box-saldo
               WHERE wm-box-saldo.cod-estabel = tt-saldos-transf.cod-estabel
                 AND wm-box-saldo.cod-local   = tt-saldos-transf.cod-local
                 AND wm-box-saldo.id-saldo    = tt-saldos-transf.id-saldo EXCLUSIVE-LOCK:

                ASSIGN wm-box-saldo.qtd-item-bloq = wm-box-saldo.qtd-item-bloq + tt-saldos-transf.qtd-retirada.
                IF wm-box-saldo.qtd-item <= wm-box-saldo.qtd-item-bloq THEN
                    DELETE wm-box-saldo.
            END.
        END.
    END.
    ELSE DO:
        IF CAN-FIND (FIRST wms-box-sdo-alocad 
                     WHERE wms-box-sdo-alocad.cod-estabel   = wm-box-movto.cod-estabel
                       AND wms-box-sdo-alocad.cod-local     = wm-box-movto.cod-local
                       AND wms-box-sdo-alocad.cod-cliente   = wm-box-movto.cod-cliente
                       AND wms-box-sdo-alocad.id-box        = wm-box-movto.id-box
                       AND wms-box-sdo-alocad.id-docto      = wm-box-movto.id-docto
                       AND wms-box-sdo-alocad.num-seq-item  = wm-box-movto.num-seq-item
                       AND wms-box-sdo-alocad.cod-lote      = wm-box-movto.cod-lote
                       AND wms-box-sdo-alocad.cod-embalagem = wm-box-movto.cod-embalagem) THEN DO:

            FOR EACH wms-box-sdo-alocad EXCLUSIVE-LOCK
               WHERE wms-box-sdo-alocad.cod-estabel   = wm-box-movto.cod-estabel
                 AND wms-box-sdo-alocad.cod-local     = wm-box-movto.cod-local
                 AND wms-box-sdo-alocad.cod-cliente   = wm-box-movto.cod-cliente
                 AND wms-box-sdo-alocad.id-box        = wm-box-movto.id-box
                 AND wms-box-sdo-alocad.id-docto      = wm-box-movto.id-docto
                 AND wms-box-sdo-alocad.num-seq-item  = wm-box-movto.num-seq-item
                 AND wms-box-sdo-alocad.cod-lote      = wm-box-movto.cod-lote
                 AND wms-box-sdo-alocad.cod-embalagem = wm-box-movto.cod-embalagem:
    
                ASSIGN wms-box-sdo-alocad.qtd-item-retir = wms-box-sdo-alocad.qtd-item-retir + (wm-box-movto.qtd-item * wm-box-movto.qti-embalagem).
                
                IF wms-box-sdo-alocad.qtd-alocad <= wms-box-sdo-alocad.qtd-item-retir THEN
                    DELETE wms-box-sdo-alocad.
            END.
        END.
        ELSE DO:
            FOR EACH wms-box-sdo-alocad EXCLUSIVE-LOCK
               WHERE wms-box-sdo-alocad.cod-estabel   = wm-box-movto.cod-estabel
                 AND wms-box-sdo-alocad.cod-local     = wm-box-movto.cod-local
                 AND wms-box-sdo-alocad.cod-cliente   = wm-box-movto.cod-cliente
                 AND wms-box-sdo-alocad.id-box        = wm-box-movto.id-box
                 AND wms-box-sdo-alocad.id-docto      = wm-box-movto.id-docto
                 AND wms-box-sdo-alocad.num-seq-item  = wm-box-movto.num-seq-item
                 AND wms-box-sdo-alocad.cod-lote      = wm-box-movto.cod-lote:
    
                ASSIGN wms-box-sdo-alocad.qtd-item-retir = wms-box-sdo-alocad.qtd-item-retir + (wm-box-movto.qtd-item * wm-box-movto.qti-embalagem).
                
                IF wms-box-sdo-alocad.qtd-alocad <= wms-box-sdo-alocad.qtd-item-retir THEN
                    DELETE wms-box-sdo-alocad.
            END.
        END.

        DO i = 1 TO wm-box-movto.qti-embalagem:
            FIND FIRST wm-box-saldo EXCLUSIVE-LOCK
                 WHERE wm-box-saldo.cod-estabel = wm-box-movto.cod-estabel
                   AND wm-box-saldo.cod-local   = wm-box-movto.cod-local
                   AND wm-box-saldo.cod-cliente = wm-box-movto.cod-cliente
                   AND wm-box-saldo.cod-item    = wm-box-movto.cod-item
                   AND wm-box-saldo.cod-refer   = wm-box-movto.cod-refer
                   AND wm-box-saldo.cod-lote    = wm-box-movto.cod-lote
                   AND wm-box-saldo.id-box      = wm-box-movto.id-box 
                   AND wm-box-saldo.qtd-item - wm-box-saldo.qtd-item-bloq = wm-box-movto.qtd-item NO-ERROR.
            IF NOT AVAIL wm-box-saldo THEN DO:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-saldo AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Saldo" *}
                ASSIGN c-lbl-liter-saldo = TRIM(RETURN-VALUE).
                DEFINE VARIABLE c-lbl-liter-nao-ha-saldo-para-a-quantidade AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "NÆo_h _saldo_para_a_quantidade_solicitada_da_embalagem_do_item" *}
                ASSIGN c-lbl-liter-nao-ha-saldo-para-a-quantidade = TRIM(RETURN-VALUE).
                RUN piCreateError (INPUT 56, 
                                   INPUT c-lbl-liter-saldo + '~~' + c-lbl-liter-nao-ha-saldo-para-a-quantidade + ' ' +  wm-box-movto.cod-item, 
                                   INPUT "EMS", 
                                   INPUT "ERROR").
                RETURN "NOK":U.
            END.
                
            ASSIGN wm-box-saldo.qtd-item-bloq = wm-box-saldo.qtd-item-bloq + wm-box-movto.qtd-item.

            &IF '{&bf_lote_avancado_liberado}' = 'yes' &THEN
                IF l-lote-avancado AND wm-box-saldo.cod-lote <> '' THEN DO:
                    /* Se o lote atual ainda nao foi verificado */
                    IF ch-lote-verificado = '' OR ch-lote-verificado <> wm-box-saldo.cod-lote THEN DO:
                        ASSIGN ch-lote-verificado = wm-box-saldo.cod-lote.
    
                        IF NOT VALID-HANDLE(h-proxy124) THEN
                            RUN wmp/wmprx124.p PERSISTENT SET h-proxy124.
    
                        RUN buscaEstadoLoteCQ IN h-proxy124 (INPUT wm-box-saldo.cod-estabel,
                                                             INPUT wm-box-saldo.cod-item,
                                                             INPUT wm-box-saldo.cod-lote,
                                                             OUTPUT l-existe,
                                                             OUTPUT TABLE RowErrors).
    
                        IF NOT l-existe THEN DO:
                            ASSIGN l-lote-bloqueado = NO.
                        END.
                        ELSE DO:
                            RUN getLoteSaldoDisponivel IN h-proxy124 (OUTPUT l-saldo-disp).
                            RUN getLoteAlocaWMS        IN h-proxy124 (OUTPUT l-aloca-wms).

                            IF l-saldo-disp AND l-aloca-wms THEN
                                ASSIGN l-lote-bloqueado = NO.
                            ELSE
                                ASSIGN l-lote-bloqueado = YES.
                        END.
    
                        IF VALID-HANDLE(h-proxy124) THEN DO:
                            RUN destroy IN h-proxy124.
                            DELETE OBJECT h-proxy124 NO-ERROR.
                        END.
    
                        IF l-lote-bloqueado THEN DO:
                            /* Inicio -- Projeto Internacional */
                            {utp/ut-liter.i "Aloca‡Æo_WMS" *}
                            RUN piCreateError (INPUT 36718,
                                               INPUT wm-box-saldo.cod-lote + '~~~~' + wm-box-saldo.cod-item + '~~~~' + RETURN-VALUE,
                                               INPUT "EMS",
                                               INPUT "ERROR").
                            UNDO bloco,RETURN "NOK":U.
                        END.
                    END.
                END.
            &ENDIF
    
            /* Atualiza Movto Entrada */    
            ASSIGN bfwm-box-movto.ind-status-movto = 3. /* atualizado */
            VALIDATE bfwm-box-movto.
    
            FOR EACH bfwm-box-saldo
                WHERE bfwm-box-saldo.cod-estabel      = bfwm-box-movto.cod-estabel    
                  AND bfwm-box-saldo.cod-local        = bfwm-box-movto.cod-local      
                  AND bfwm-box-saldo.id-box           = bfwm-box-movto.id-box
                  AND bfwm-box-saldo.cod-item         = bfwm-box-movto.cod-item
                  AND bfwm-box-saldo.cod-refer        = bfwm-box-movto.cod-refer
                  AND bfwm-box-saldo.cod-embalagem    = bfwm-box-movto.cod-embalagem 
                  AND bfwm-box-saldo.ind-status-saldo = 2 /* destinado */                       
                  AND bfwm-box-saldo.cod-cliente      = bfwm-box-movto.cod-cliente  
                  AND bfwm-box-saldo.id-docto         = bfwm-box-movto.id-docto
                  AND bfwm-box-saldo.num-seq-item     = bfwm-box-movto.num-seq-item 
                  AND bfwm-box-saldo.id-movto         = bfwm-box-movto.id-movto EXCLUSIVE-LOCK:
                ASSIGN bfwm-box-saldo.ind-status-saldo = 3. /* liberado */
                VALIDATE bfwm-box-saldo.

                FIND FIRST wm-saldo-estoque EXCLUSIVE-LOCK
                     WHERE wm-saldo-estoque.cod-estabel = wm-box-saldo.cod-estabel
                       AND wm-saldo-estoque.cod-local   = wm-box-saldo.cod-local
                       AND wm-saldo-estoque.cod-item    = wm-box-saldo.cod-item
                       AND wm-saldo-estoque.cod-refer   = wm-box-saldo.cod-refer
                       AND wm-saldo-estoque.cod-lote    = wm-box-saldo.cod-lote
                       AND wm-saldo-estoque.cod-cliente = wm-box-saldo.cod-cliente NO-ERROR.
    
                IF AVAIL wm-saldo-estoque THEN DO:
                    ASSIGN wm-saldo-estoque.qtd-liberada = wm-saldo-estoque.qtd-liberada + wm-box-movto.qtd-item.
                    VALIDATE wm-saldo-estoque.
                    FIND CURRENT wm-saldo-estoque NO-LOCK NO-ERROR.
                END.
    
                /* Transfere etiquetas do saldo origem p/ destino */
                /*
                FOR EACH wm-box-saldo-etiqueta EXCLUSIVE-LOCK
                   WHERE wm-box-saldo-etiqueta.cod-estabel = wm-box-saldo.cod-estabel
                     AND wm-box-saldo-etiqueta.cod-local   = wm-box-saldo.cod-local
                     AND wm-box-saldo-etiqueta.id-box      = wm-box-saldo.id-box:
    
                    IF l-avail-etiqueta AND
                        NOT CAN-FIND(FIRST tt-etiqueta
                                     WHERE tt-etiqueta.id-etiqueta = wm-box-saldo-etiqueta.id-etiqueta) THEN
                        NEXT.

                    FIND FIRST tt-etiqueta NO-LOCK
                         WHERE tt-etiqueta.id-etiqueta = wm-box-saldo-etiqueta.id-etiqueta NO-ERROR.

                    FIND FIRST wm-etiqueta NO-LOCK
                         WHERE wm-etiqueta.id-etiqueta = wm-box-saldo-etiqueta.id-etiqueta NO-ERROR.
                    IF NOT AVAIL wm-etiqueta THEN
                        NEXT.

                    IF wm-etiqueta.qtd-item - wm-etiqueta.qtd-item-retirado <= wm-box-movto.qtd-item AND 
                       NOT CAN-FIND(FIRST bfwm-box-saldo-etiqueta
                                    WHERE bfwm-box-saldo-etiqueta.cod-estabel = bfwm-box-saldo.cod-estabel
                                      AND bfwm-box-saldo-etiqueta.cod-local   = bfwm-box-saldo.cod-local
                                      AND bfwm-box-saldo-etiqueta.id-box      = bfwm-box-saldo.id-box
                                      AND bfwm-box-saldo-etiqueta.id-etiqueta = wm-box-saldo-etiqueta.id-etiqueta NO-LOCK) THEN DO:
    
                        CREATE bfwm-box-saldo-etiqueta.
                        BUFFER-COPY wm-box-saldo-etiqueta EXCEPT wm-box-saldo-etiqueta.cod-estabel
                                                                 wm-box-saldo-etiqueta.cod-local
                                                                 wm-box-saldo-etiqueta.id-box
                                                                 wm-box-saldo-etiqueta.id-etiqueta
                                TO bfwm-box-saldo-etiqueta.
    
                        ASSIGN bfwm-box-saldo-etiqueta.cod-estabel  = wm-box-saldo-etiqueta.cod-estabel
                               bfwm-box-saldo-etiqueta.cod-local    = wm-box-saldo-etiqueta.cod-local  
                               bfwm-box-saldo-etiqueta.id-box       = bfwm-box-saldo.id-box
                               bfwm-box-saldo-etiqueta.id-etiqueta  = wm-box-saldo-etiqueta.id-etiqueta
                               bfwm-box-saldo-etiqueta.id-saldo     = bfwm-box-saldo.id-saldo
                               bfwm-box-saldo-etiqueta.id-docto     = bfwm-box-saldo.id-docto
                               bfwm-box-saldo-etiqueta.num-seq-item = bfwm-box-saldo.num-seq-item.
                    END.

                    &IF "{&mgscm_version}":U >= "2.07" &THEN
                        RUN wmp/wm9414.p (INPUT  ROWID(wm-box-movto),
                                          INPUT  10, /*Movimento de Ressuprimento*/
                                          INPUT  wm-etiqueta.id-etiqueta,
                                          INPUT  c-seg-usuario,
                                          INPUT  wm-box-movto.qtd-item,
                                          OUTPUT TABLE RowErrors).
    
                        IF RETURN-VALUE = "NOK":U THEN
                            UNDO bloco,RETURN "NOK":U.
                    &ENDIF
    
                    IF wm-etiqueta.ind-sit-agrupador = 1 THEN DO:
                        FIND FIRST bfWm-etiqueta EXCLUSIVE-LOCK
                             WHERE bfWm-etiqueta.id-etiqueta = wm-etiqueta.id-agrupador NO-ERROR.
                        IF AVAIL bfWm-etiqueta AND 
                           CAN-FIND(FIRST bfWm-box-saldo-etiqueta
                                    WHERE bfWm-box-saldo-etiqueta.id-etiqueta = bfWm-etiqueta.id-etiqueta
                                      AND bfWm-box-saldo-etiqueta.id-box      = wm-box-saldo-etiqueta.id-box NO-LOCK) THEN DO:
                            DELETE wm-box-saldo-etiqueta.
                        END.
                        ELSE IF (AVAIL tt-etiqueta AND tt-etiqueta.qtd-retirada >= wm-etiqueta.qtd-item - wm-etiqueta.qtd-item-retirado) OR
                                NOT AVAIL tt-etiqueta THEN
                            DELETE wm-box-saldo-etiqueta.
                    END.
                    ELSE IF wm-etiqueta.ind-sit-agrupador = 2 THEN DO:
    
                        FOR EACH bfWm-etiqueta NO-LOCK
                           WHERE bfWm-etiqueta.id-agrupador = wm-etiqueta.id-etiqueta:
    
                            IF NOT CAN-FIND(FIRST tt-etiqueta
                                            WHERE tt-etiqueta.id-etiqueta = bfWm-etiqueta.id-etiqueta) THEN DO:
                                FIND FIRST bfwm-box-saldo-etiqueta EXCLUSIVE-LOCK
                                     WHERE bfwm-box-saldo-etiqueta.id-etiqueta = bfWm-etiqueta.id-etiqueta NO-ERROR.
    
                                IF AVAIL bfwm-box-saldo-etiqueta THEN DO:
                                    DELETE bfwm-box-saldo-etiqueta.
                                    CREATE bfwm-box-saldo-etiqueta.
                                    BUFFER-COPY wm-box-saldo-etiqueta EXCEPT wm-box-saldo-etiqueta.cod-estabel
                                                                             wm-box-saldo-etiqueta.cod-local
                                                                             wm-box-saldo-etiqueta.id-box
                                                                             wm-box-saldo-etiqueta.id-etiqueta
                                             TO bfwm-box-saldo-etiqueta.
    
                                    ASSIGN bfwm-box-saldo-etiqueta.cod-estabel  = wm-box-saldo-etiqueta.cod-estabel
                                           bfwm-box-saldo-etiqueta.cod-local    = wm-box-saldo-etiqueta.cod-local  
                                           bfwm-box-saldo-etiqueta.id-box       = bfwm-box-saldo.id-box
                                           bfwm-box-saldo-etiqueta.id-etiqueta  = bfWm-etiqueta.id-etiqueta
                                           bfwm-box-saldo-etiqueta.id-saldo     = bfwm-box-saldo.id-saldo
                                           bfwm-box-saldo-etiqueta.id-docto     = bfwm-box-saldo.id-docto
                                           bfwm-box-saldo-etiqueta.num-seq-item = bfwm-box-saldo.num-seq-item.
                                    
    /*                                 &IF "{&mgscm_version}":U >= "2.07" &THEN              */
    /*                                         RUN wmp/wm9414.p (INPUT  ROWID(wm-box-movto), */
    /*                                           INPUT  10, /*Movimento de Ressuprimento*/   */
    /*                                           INPUT  bfWm-etiqueta.id-etiqueta,           */
    /*                                           INPUT  c-seg-usuario,                       */
    /*                                           INPUT  wm-box-movto.qtd-item,       */
    /*                                           OUTPUT TABLE RowErrors).                    */
    /*                                                                                       */
    /*                                     IF RETURN-VALUE = "NOK":U THEN                    */
    /*                                         UNDO bloco,RETURN "NOK":U.                    */
    /*                                 &ENDIF                                                */
                                END.
                            END.
                        END.
                        DELETE wm-box-saldo-etiqueta.
    
                    END.
                    ELSE IF wm-etiqueta.ind-sit-agrupador = 3 THEN DO:
                        IF (AVAIL tt-etiqueta AND tt-etiqueta.qtd-retirada >= wm-etiqueta.qtd-item - wm-etiqueta.qtd-item-retirado) OR
                           NOT AVAIL tt-etiqueta THEN
                            DELETE wm-box-saldo-etiqueta.
                    END.

                    FOR EACH tt-epc
                       WHERE tt-epc.cod-event = 'atualiza-etiqueta':U:
                        DELETE tt-epc.
                    END.

                    {include/i-epc200.i2 &CodEvent='"atualiza-etiqueta"'
                                         &CodParameter='"rowid-wm-box-movto"'
                                         &ValueParameter="string(r-movto-ressup)"}

                    {include/i-epc200.i2 &CodEvent='"atualiza-etiqueta"'
                                         &CodParameter='"rowid-wm-etiqueta"'
                                         &ValueParameter="string(rowid(wm-etiqueta))"}

                    /* Chamada EPC */
                    {include/i-epc201.i 'atualiza-etiqueta':U}

                END.*/
            END.

            IF AVAIL wm-box-saldo THEN DO:
    
                FIND FIRST wm-box EXCLUSIVE-LOCK
                     WHERE wm-box.cod-estabel = wm-box-saldo.cod-estabel
                       AND wm-box.cod-local   = wm-box-saldo.cod-local
                       AND wm-box.id-box      = wm-box-saldo.id-box NO-ERROR.
    
                ASSIGN wm-box-movto.ind-status-movto = 3. /* atualizado */
                VALIDATE wm-box-movto.
                
                FIND FIRST wm-item NO-LOCK
                     WHERE wm-item.cod-item = wm-box-saldo.cod-item NO-ERROR.
                
                ASSIGN de-id-box = bfwm-box-movto.id-box. /*wm-box-saldo.id-box*/
                
                /* Atualiza Box */
                /*Desconta o peso dos itens*/
                ASSIGN wm-box.qtd-capacidade-peso-util = wm-box.qtd-capacidade-peso-util - (wm-item.qtd-peso * wm-box-movto.qtd-item ).

                /*Quando concluida a movimentação total ou movida toda a quantidade quando parcial
                  Descontará o peso e a capacidade UA da embalagem da wm-box-saldo*/
                IF wm-box-saldo.qtd-item-bloq = wm-box-saldo.qtd-item  THEN DO:     

                    FIND FIRST wm-item-embalagem-local NO-LOCK
                         WHERE wm-item-embalagem-local.cod-estabel   = wm-box-saldo.cod-estabel
                           AND wm-item-embalagem-local.cod-local     = wm-box-saldo.cod-local
                           AND wm-item-embalagem-local.cod-item      = wm-box-saldo.cod-item
                           AND wm-item-embalagem-local.cod-embalagem = wm-box-saldo.cod-embalagem NO-ERROR.

                    IF NOT AVAIL wm-item-embalagem-local THEN DO:
                        FIND FIRST wm-item-embalagem-local NO-LOCK
                             WHERE wm-item-embalagem-local.cod-estabel  = wm-box-saldo.cod-estabel
                               AND wm-item-embalagem-local.cod-local    = wm-box-saldo.cod-local
                               AND wm-item-embalagem-local.cod-item     = wm-box-saldo.cod-item
                               AND wm-item-embalagem-local.cod-emb-item = wm-box-saldo.cod-embalagem NO-ERROR.
                        ASSIGN l-embalagem-filha = YES.
                    END.
                    ELSE
                        ASSIGN l-embalagem-filha = NO.

                    /*************************************************************************/
                    /*** INICIO CHAMADA EPC - Cliente: MOR / Chamado: TETWBS               ***/
                    /*************************************************************************/
                    if  c-nom-prog-dpc-mg97  <> ""
                    or  c-nom-prog-upc-mg97  <> ""
                    or  c-nom-prog-appc-mg97 <> "" then do:
                 
                        for each tt-epc
                            where tt-epc.cod-event = "ATUALIZA-QUANTIDADE-UA".
                            delete tt-epc.
                        end.
                    
                        {include/i-epc200.i2 &CodEvent='"ATUALIZA-QUANTIDADE-UA"'
                                             &CodParameter='"rowid_wm-box-saida-ressup"'
                                             &ValueParameter="string(rowid(wm-box-saida-ressup))"}
                                             
                        {include/i-epc200.i2 &CodEvent='"ATUALIZA-QUANTIDADE-UA"'
                                             &CodParameter='"rowid_wm-item-embalagem-local"'
                                             &ValueParameter="string(rowid(wm-item-embalagem-local))"}
                                             
                        {include/i-epc201.i "ATUALIZA-QUANTIDADE-UA"}
                 
                            
                         for first tt-epc 
                            where tt-epc.cod-event     = "ATUALIZA-QUANTIDADE-UA"
                              and tt-epc.cod-parameter = "atualiza-de-qtd-ua":
                             assign de-qtd-ua = decimal(tt-epc.val-parameter).
                         end.
                   
                        IF RETURN-VALUE = "NOK" THEN NEXT.
                    end.
                    /*************************************************************************/
                    /*** FIM CHAMADA EPC - Cliente: MOR / Chamado: TETWBS                  ***/
                    /*************************************************************************/

                    IF l-embalagem-filha = NO THEN
                       ASSIGN wm-box.qtd-capacidade-ua-util   = wm-box.qtd-capacidade-ua-util   - wm-item-embalagem-local.qtd-volume
                              wm-box.qtd-capacidade-peso-util = wm-box.qtd-capacidade-peso-util - wm-item-embalagem-local.qtd-peso.
                    ELSE IF wm-box-movto.cod-embalagem = wm-item-embalagem-local.cod-emb-item THEN
                            ASSIGN wm-box.qtd-capacidade-ua-util   = wm-box.qtd-capacidade-ua-util   - wm-item-embalagem-local.qtd-volume-item
                                   wm-box.qtd-capacidade-peso-util = wm-box.qtd-capacidade-peso-util - wm-item-embalagem-local.qtd-peso-item.
                         ELSE.

                   DELETE wm-box-saldo.
                END.

                VALIDATE wm-box.
    
                RUN piRessuprimento IN THIS-PROCEDURE (INPUT de-id-box).    
            END.
        END.
    END.

    /* Atualiza Itens */
    IF NOT CAN-FIND(FIRST bfwm-box-movto
                    WHERE bfwm-box-movto.cod-estabel  = wm-box-movto.cod-estabel
                      AND bfwm-box-movto.cod-local    = wm-box-movto.cod-local
                      AND bfwm-box-movto.id-docto     = wm-box-movto.id-docto
                      AND bfwm-box-movto.num-seq-item = wm-box-movto.num-seq-item
                      AND bfwm-box-movto.ind-status-movto <> 3 NO-LOCK) THEN DO:

        FIND FIRST wm-docto-itens EXCLUSIVE-LOCK
             WHERE wm-docto-itens.cod-estabel = wm-box-movto.cod-estabel
               AND wm-docto-itens.cod-local   = wm-box-movto.cod-local
               AND wm-docto-itens.id-docto    = wm-box-movto.id-docto
               AND wm-docto-itens.num-seq-item = wm-box-movto.num-seq-item NO-ERROR.
            ASSIGN wm-docto-itens.ind-sit-movto = 2. /* Atualizado */
            VALIDATE wm-docto-itens.
    END.

    /* Atualiza Documento */
    IF NOT CAN-FIND(FIRST wm-docto-itens
                    WHERE wm-docto-itens.cod-estabel   =  wm-box-movto.cod-estabel
                      AND wm-docto-itens.cod-local     =  wm-box-movto.cod-local
                      AND wm-docto-itens.id-docto      =  wm-box-movto.id-docto
                      AND wm-docto-itens.ind-sit-movto <> 2) THEN DO:

        FIND FIRST wm-docto EXCLUSIVE-LOCK
             WHERE wm-docto.cod-estabel = wm-box-movto.cod-estabel
               AND wm-docto.cod-local   = wm-box-movto.cod-local
               AND wm-docto.id-docto    = wm-box-movto.id-docto NO-ERROR.
            ASSIGN wm-docto.ind-sit-docto = 2. /* Atualizado */
            VALIDATE wm-docto.
    END.

    IF wm-param.log-gera-tarefa-ressup THEN DO:
        /* Conclusao Tarefas */
        RUN wmp/wm9041.p (INPUT wm-box-movto.cod-estabel,
                          INPUT wm-box-movto.cod-local,
                          INPUT wm-box-movto.id-movto,
                          INPUT YES,
                          INPUT TABLE tt-tarefa-docto,
                          OUTPUT TABLE RowErrors).
    END.

    /*******************************
    *        Chamada EPC           *
    *******************************/             
    FOR EACH tt-epc
       WHERE tt-epc.cod-event = "Replenishment-Confirmation":
       DELETE tt-epc.
    END.
    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "Replenishment-Confirmation"
           tt-epc.cod-parameter = "wm-box-movto-rowid"
           tt-epc.val-parameter = STRING(ROWID(wm-box-movto)).

    {include/i-epc201.i "Replenishment-Confirmation"}

END. /* TRANSACTION */.

RETURN "OK":U.

/* Fim Programa */


/************************************************************************************************************
**                                             PROCEDURES
************************************************************************************************************/

/* Procedure Respons vel por efetuar o ressuprimento na area de picking Pai */
PROCEDURE piRessuprimento:

    DEFINE INPUT PARAM p-id-box      LIKE wm-box.id-box NO-UNDO. /* Endere‡o Origem */
    DEFINE BUFFER bfWm-box-saldo-aux FOR wm-box-saldo.


    FIND FIRST wm-item-embalagem-local NO-LOCK
         WHERE wm-item-embalagem-local.cod-estabel   = wm-box-saldo.cod-estabel
           AND wm-item-embalagem-local.cod-local     = wm-box-saldo.cod-local
           AND wm-item-embalagem-local.cod-item      = wm-box-saldo.cod-item
           AND wm-item-embalagem-local.cod-embalagem = wm-box-movto.cod-embalagem NO-ERROR.

    IF NOT AVAIL wm-item-embalagem-local THEN DO:
        FIND FIRST wm-item-embalagem-local NO-LOCK
             WHERE wm-item-embalagem-local.cod-estabel  = wm-box-saldo.cod-estabel
               AND wm-item-embalagem-local.cod-local    = wm-box-saldo.cod-local
               AND wm-item-embalagem-local.cod-item     = wm-box-saldo.cod-item
               AND wm-item-embalagem-local.cod-emb-item = wm-box-movto.cod-embalagem NO-ERROR.
        ASSIGN l-embalagem-filha = YES.
    END.
    ELSE
        ASSIGN l-embalagem-filha = NO.

    IF NOT l-embalagem-filha THEN DO:
        FIND FIRST wm-item-picking NO-LOCK
             WHERE wm-item-picking.cod-estabel  = wm-box-movto.cod-estabel
               AND wm-item-picking.cod-local    = wm-box-movto.cod-local
               AND wm-item-picking.cod-item     = wm-box-movto.cod-item
               AND wm-item-picking.cod-emb-area = wm-item-embalagem-local.cod-emb-item NO-ERROR.
        IF AVAIL wm-item-picking THEN DO:
            FOR EACH wm-box-picking NO-LOCK
               WHERE wm-box-picking.cod-estabel = wm-box-movto.cod-estabel
                 AND wm-box-picking.cod-local   = wm-box-movto.cod-local
                 AND wm-box-picking.cod-picking = wm-item-picking.cod-picking:
                ASSIGN de-qtd-saldo = 0.
                FOR EACH bfwm-box-saldo-aux NO-LOCK
                   WHERE bfwm-box-saldo-aux.cod-estabel = wm-box-movto.cod-estabel
                     AND bfwm-box-saldo-aux.cod-local   = wm-box-movto.cod-local
                     AND bfwm-box-saldo-aux.id-box      = wm-box-picking.id-box-comp:
                    ASSIGN de-qtd-saldo = de-qtd-saldo + (bfwm-box-saldo-aux.qtd-item - bfwm-box-saldo-aux.qtd-item-bloq).
                END.
                IF wm-item-picking.qtd-minima >= de-qtd-saldo THEN
                    RUN wmp/wm9063.p (INPUT  wm-box-movto.cod-estabel,
                                      INPUT  wm-box-movto.cod-local,
                                      INPUT  wm-box-movto.cod-cliente,
                                      INPUT  wm-box-movto.cod-item,
                                      INPUT  wm-box-movto.cod-refer,
                                      INPUT  wm-box-picking.id-box-comp,
                                      OUTPUT TABLE RowErrors).
            END.
        END.
    END.
    RETURN "OK":U.
END PROCEDURE.

/* Procedure de Criacao de Erros na Temp-Table RowErrors */
PROCEDURE piCreateError:

    DEFINE INPUT PARAMETER pErrorNumber      AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER pErrorParameters  AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pErrorType        AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pErrorSubType     AS CHARACTER NO-UNDO.

    DEFINE VARIABLE i-sequencia              AS INTEGER   NO-UNDO.

    FIND LAST RowErrors EXCLUSIVE-LOCK NO-ERROR.
    IF AVAIL RowErrors THEN
        ASSIGN i-sequencia = RowErrors.ErrorSequence + 1.
    ELSE    
        ASSIGN i-sequencia = 1.

    RUN utp/ut-msgs.p (INPUT "msg",
                       INPUT pErrorNumber,
                       INPUT pErrorParameters).  

    FIND FIRST RowErrors 
         WHERE RowErrors.ErrorDescription = RETURN-VALUE NO-LOCK NO-ERROR.
    IF NOT AVAIL RowErrors THEN DO:
        CREATE RowErrors.
        ASSIGN RowErrors.ErrorSequence    = i-sequencia
               RowErrors.ErrorNumber      = pErrorNumber
               RowErrors.ErrorParameters  = pErrorParameters
               RowErrors.ErrorType        = pErrorType
               RowErrors.ErrorSubType     = pErrorSubType
               RowErrors.ErrorDescription = RETURN-VALUE.

        RUN utp/ut-msgs.p (INPUT "help",
                           INPUT RowErrors.ErrorNumber,
                           INPUT RowErrors.ErrorParameters).  
        ASSIGN RowErrors.ErrorHelp = RETURN-VALUE.

    END.

    RETURN "OK":U.    

END PROCEDURE.

