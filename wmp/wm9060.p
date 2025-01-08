/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
********************************************************************************/
{include/i-prgvrs.i WM9060 2.00.00.059 } /*** "010059" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i wm9060 MWM}
&ENDIF

/********************************************************************************
**
**                        GERAÄ«O DE RESSUPRIMENTO
**
********************************************************************************/

{cdp/cdcfgmat.i}
{method/dbotterr.i}
{wmp/wm9000.i}
{wmp/wm9055.i}
{cdp/cdcfgwms.i}
/** Definicao tt-epc **/
{include/i-epc200.i wm9060}

DEF NEW GLOBAL SHARED VAR grw-wm-docto-itens AS ROWID NO-UNDO.

DEFINE INPUT  PARAMETER p-id-movto AS ROWID NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

/********************* Chamada EPC *********************/

FOR EACH tt-epc:
    DELETE tt-epc.
END.

/* Criacao da Temp-Table tt-epc */
{include/i-epc200.i2 &CodEvent='"Geracao-Ressuprimento-GE-DAKO"'
                     &CodParameter='"Rowid-Movto-Saida"'
                     &ValueParameter="STRING(p-id-movto)"} 

/* Chamada EPC */
{include/i-epc201.i "Geracao-Ressuprimento-GE-DAKO"}

/* Retorno dos Registros Temp-Table RowErrors da EPC */
FOR EACH  tt-epc 
    WHERE tt-epc.cod-parameter = "NOK":U NO-LOCK:
    CREATE RowErrors.
    ASSIGN RowErrors.ErrorSequence    = INTEGER(ENTRY(1,tt-epc.val-parameter,";"))
           RowErrors.ErrorNumber      = INTEGER(ENTRY(2,tt-epc.val-parameter,";")) 
           RowErrors.ErrorDescription = ENTRY(3,tt-epc.val-parameter,";")
           RowErrors.ErrorParameters  = ENTRY(4,tt-epc.val-parameter,";")
           RowErrors.ErrorType        = ENTRY(5,tt-epc.val-parameter,";")
           RowErrors.ErrorHelp        = ENTRY(6,tt-epc.val-parameter,";")
           RowErrors.ErrorSubType     = ENTRY(7,tt-epc.val-parameter,";").
END.

IF CAN-FIND (FIRST RowErrors NO-LOCK) THEN
    RETURN "NOK":U.
ELSE DO:
    IF CAN-FIND(FIRST tt-epc WHERE tt-epc.cod-parameter = "OK":U NO-LOCK) THEN DO:
        RETURN "OK":U.
    END.
END.

/******************* Fim Chamada EPC *******************/		

DEF VAR i-qti-embalagem             LIKE wm-box-movto.qti-embalagem     NO-UNDO.
DEF VAR d-qtd-item                  LIKE wm-box-movto.qtd-item          NO-UNDO.
DEF VAR d-qtd-disp-peso             LIKE wm-box.qtd-capacidade-peso     NO-UNDO.
DEF VAR d-qtd-disp-ua               LIKE wm-box.qtd-capacidade-ua       NO-UNDO.
DEF VAR c-lote-aux                  LIKE wm-box-movto.cod-lote          NO-UNDO.
DEF VAR d-id-movto                  LIKE wm-box-movto.id-movto          NO-UNDO.
DEF VAR d-qtd-item-filha            LIKE wm-item-embalagem.qtd-emb-item NO-UNDO.
DEF VAR i-num-dias-reanalise        LIKE wm-item.num-dias-reanalise     NO-UNDO.
DEF VAR de-saldo-box                LIKE wm-box-saldo.qtd-item          NO-UNDO.
DEF VAR ch-lote-verificado          LIKE wm-box-saldo.cod-lote          NO-UNDO.
DEF VAR i-ind-controle-saida        LIKE wm-item.ind-controle-saida     NO-UNDO.
DEF VAR i-ind-seq-retirada          LIKE wm-item.ind-seq-retirada       NO-UNDO.
DEF VAR d-qtd-disp-peso-calc-ressup LIKE wm-box.qtd-capacidade-peso     NO-UNDO.
DEF VAR d-qtd-disp-ua-calc-ressup   LIKE wm-box.qtd-capacidade-ua       NO-UNDO.

DEF VAR l-box-completo              AS LOGICAL                          NO-UNDO.
DEF VAR l-capacidade-ok             AS LOGICAL                          NO-UNDO.
DEF VAR l-embalagem-filha           AS LOGICAL                          NO-UNDO.
DEF VAR l-existe-saldo              AS LOGICAL                          NO-UNDO.
DEF VAR l-ressup                    AS LOGICAL                          NO-UNDO.
DEF VAR l-estoura-capac             AS LOGICAL                          NO-UNDO.
DEF VAR l-lote-avancado             AS LOGICAL                          NO-UNDO.
DEF VAR l-lote-bloqueado            AS LOGICAL                          NO-UNDO.
DEF VAR l-aloca-wms                 AS LOGICAL                          NO-UNDO.
DEF VAR l-saldo-disp                AS LOGICAL                          NO-UNDO.
DEF VAR l-existe                    AS LOGICAL                          NO-UNDO.
DEF VAR l-primeira-vez              AS LOGICAL                          NO-UNDO.
DEF VAR l-capacidade-res            AS LOGICAL                          NO-UNDO.
                                                                        
DEF VAR h-proxy124                  AS HANDLE                           NO-UNDO.
DEF VAR i-qtd-emb-ressup            AS INTEGER                          NO-UNDO.
DEF VAR de-qtd-peso-ressup          AS DEC                              NO-UNDO.
DEF VAR de-qtd-volume-ressup        AS DEC                              NO-UNDO.
DEF VAR de-qtd-ressup               AS DEC                              NO-UNDO.

DEF QUERY q-box-saldo FOR wm-box-saldo, wm-box, wm-tipo-box, wm-item-embalagem-local.
DEF QUERY q-box-saldo-picking FOR wm-box-picking, wm-box-saldo , wm-saldo-estoque, wm-box, wm-item-embalagem-local.


DEF BUFFER bfwm-box          FOR wm-box.
DEF BUFFER bfwm-box-saldo    FOR wm-box-saldo.
DEF BUFFER bfwm-box-saldo2   FOR wm-box-saldo.
DEF BUFFER bfwm-box-movto    FOR wm-box-movto.
DEF BUFFER bfwm-item-picking FOR wm-item-picking.
DEF BUFFER bfwm-box-picking  FOR wm-box-picking.

DEFINE TEMP-TABLE ttwm-box-saida-ressup NO-UNDO LIKE wm-box-saida-ressup
    FIELD id-box-saida  LIKE wm-box-saida-ressup.id-box.

ASSIGN i-qti-embalagem = 0
       d-qtd-item      = 0.

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

FIND FIRST wm-box-movto NO-LOCK
     WHERE ROWID(wm-box-movto) = p-id-movto
       AND wm-box-movto.ind-tipo-movto = 2
       AND wm-box-movto.log-picking    = YES NO-ERROR.

FIND FIRST wms-item-estab-local NO-LOCK
     WHERE wms-item-estab-local.cod-estab = wm-box-movto.cod-estab
       AND wms-item-estab-local.cod-local = wm-box-movto.cod-local
       AND wms-item-estab-local.cod-item  = wm-box-movto.cod-item NO-ERROR.
IF AVAIL wms-item-estab-local THEN DO:
    IF NOT wms-item-estab-local.log-exclusivo-picking THEN DO:
        RUN piCreateError (INPUT 27110,
                           INPUT "",
                           INPUT "EMS":U,
                           INPUT "ERROR":U).
        RETURN 'NOK':U.
    END.
END.
ELSE DO:
    FIND FIRST wm-item NO-LOCK
         WHERE wm-item.cod-item = wm-box-movto.cod-item NO-ERROR.
    IF AVAIL wm-item THEN DO:
        IF NOT wm-item.log-exclusivo-picking THEN DO:
            RUN piCreateError (INPUT 27110,
                               INPUT "",
                               INPUT "EMS":U,
                               INPUT "ERROR":U).
            RETURN 'NOK':U.
        END.
    END.
END.

bloco:
DO TRANSACTION:

    IF AVAIL wm-box-movto THEN DO:
        RUN wmp/wm9055.p (INPUT wm-box-movto.cod-estabel,
                          INPUT wm-box-movto.cod-local,
                          INPUT wm-box-movto.cod-cliente,
                          INPUT 0,
                          INPUT wm-box-movto.cod-item,
                          INPUT wm-box-movto.cod-refer,
                          INPUT '',
                          OUTPUT TABLE tt-saldo-aloc,
                          OUTPUT TABLE RowErrors).

        /* primeiro localiza o documento enviado pelo wm9063. Se n∆o existir, procura o primeiro documento do dia atual */
        FIND FIRST wm-docto 
             WHERE wm-docto.cod-estabel     = wm-box-movto.cod-estabel
               AND wm-docto.cod-local       = wm-box-movto.cod-local  
               AND wm-docto.ind-tipo-trans  = 3    /* ressuprimento */
               AND wm-docto.id-docto        = wm-box-movto.id-docto NO-LOCK NO-ERROR.
        IF  NOT AVAIL wm-docto THEN
            FIND FIRST wm-docto NO-LOCK
                 WHERE wm-docto.cod-estabel     = wm-box-movto.cod-estabel
                   AND wm-docto.cod-local       = wm-box-movto.cod-local  
                   AND wm-docto.ind-tipo-trans  = 3    /* ressuprimento */
                   AND wm-docto.dt-implan-docto = TODAY NO-ERROR.

        /* Documento j† Em Processo ou Conclu°do */
        IF AVAIL wm-docto AND wm-docto.ind-sit-docto <> 1 THEN DO:
            FIND CURRENT wm-docto EXCLUSIVE-LOCK NO-ERROR.
            ASSIGN wm-docto.ind-sit-docto = 1.
            FIND CURRENT wm-docto NO-LOCK NO-ERROR.
        END.

        EMPTY TEMP-TABLE ttWm-docto NO-ERROR.

        CREATE ttWm-docto.
        ASSIGN ttWm-docto.cod-estabel           = wm-box-movto.cod-estabel 
               ttWm-docto.cod-local             = wm-box-movto.cod-local 
               ttWm-docto.num-docto             = IF AVAIL wm-docto THEN wm-docto.num-docto ELSE "Ressup-" + STRING(TODAY)
               ttWm-docto.serie                 = IF AVAIL wm-docto THEN wm-docto.serie ELSE ""
               ttWm-docto.id-docto              = IF AVAIL wm-docto THEN wm-docto.id-docto ELSE 0
               ttWm-docto.num-docto-origem      = "" 
               ttWm-docto.ind-tipo-trans        = 3
               ttWm-docto.ind-origem-docto      = 6
               ttWm-docto.id-carga              = 0
               ttWm-docto.alteracao             = IF AVAIL wm-docto THEN YES ELSE NO
               ttWm-docto.cod-depos             = ""
               ttWm-docto.dt-implan-docto       = TODAY. 

        EMPTY TEMP-TABLE ttWm-docto-itens NO-ERROR.

        IF  AVAIL wm-docto THEN
            FIND FIRST wm-docto-itens NO-LOCK
                WHERE wm-docto-itens.cod-estabel  = wm-docto.cod-estabel
                  AND wm-docto-itens.cod-local    = wm-docto.cod-local  
                  AND wm-docto-itens.id-docto     = wm-docto.id-docto
                  AND wm-docto-itens.cod-item     = wm-box-movto.cod-item
                  AND wm-docto-itens.cod-refer    = wm-box-movto.cod-refer NO-ERROR.
        IF  AVAIL wm-docto-itens THEN DO:
            CREATE ttWm-docto-itens.
            BUFFER-COPY wm-docto-itens TO ttWm-docto-itens
                ASSIGN ttWm-docto-itens.log-ped-sob-encomenda = NO 
                       ttWm-docto-itens.log-lifo-ped-exp      = NO 
                       ttWm-docto-itens.log-pedido-exp        = NO 
                       ttWm-docto-itens.alteracao             = YES
                       ttWm-docto-itens.gera-sugestao         = NO 
                       ttWm-docto-itens.rw-it-dep-fat         = ?
                       l-primeira-vez                         = NO.
        END.
        ELSE DO:
            CREATE ttWm-docto-itens.
            ASSIGN ttWm-docto-itens.cod-estabel           = ttWm-docto.cod-estabel 
                   ttWm-docto-itens.cod-local             = ttWm-docto.cod-local
                   ttWm-docto-itens.num-docto             = ttWm-docto.num-docto
                   ttWm-docto-itens.id-docto              = ttWm-docto.id-docto
                   ttWm-docto-itens.num-seq-item          = 0
                   ttWm-docto-itens.cod-cliente           = wm-box-movto.cod-cliente 
                   ttWm-docto-itens.cod-item              = wm-box-movto.cod-item
                   ttWm-docto-itens.cod-refer             = wm-box-movto.cod-refer
                   ttWm-docto-itens.cod-lote              = ""
                   ttWm-docto-itens.dt-validade-lote      = ?
                   ttWm-docto-itens.cod-doca              = 0
                   ttWm-docto-itens.qtd-item              = 1
                   ttWm-docto-itens.num-seq-item-ped      = 0
                   ttWm-docto-itens.nr-pedcli             = ""   
                   ttWm-docto-itens.nome-abrev            = ""
                   ttWm-docto-itens.cdd-embarq            = 0
                   ttWm-docto-itens.nr-resumo             = 0
                   ttWm-docto-itens.nr-pedido             = 0
                   ttWm-docto-itens.qtd-peso-pedida       = 0
                   ttWm-docto-itens.log-ped-sob-encomenda = NO
                   ttWm-docto-itens.log-lifo-ped-exp      = NO
                   ttWm-docto-itens.log-pedido-exp        = NO
                   ttWm-docto-itens.alteracao             = NO
                   ttWm-docto-itens.gera-sugestao         = NO
                   ttWm-docto-itens.cdn-emitente          = 0
                   ttWm-docto-itens.num-seq-orig          = 0
                   ttWm-docto-itens.rw-it-dep-fat         = ?
                   l-primeira-vez                         = YES.
        END.

        RUN wmp/wm9000.p (INPUT-OUTPUT TABLE ttWm-docto,
                          INPUT-OUTPUT TABLE ttWm-docto-itens,
                          INPUT-OUTPUT TABLE ttwm-etiqueta,
                          OUTPUT       TABLE RowErrors).

        IF CAN-FIND(FIRST RowErrors NO-LOCK) THEN 
            UNDO bloco, RETURN "NOK":U.

        FIND FIRST ttWm-docto       NO-ERROR.
        FIND FIRST ttWm-docto-itens NO-ERROR.

        FIND FIRST wm-item NO-LOCK
             WHERE wm-item.cod-item = wm-box-movto.cod-item NO-ERROR.
        ASSIGN i-ind-controle-saida = wm-item.ind-controle-saida
               i-ind-seq-retirada   = wm-item.ind-seq-retirada
               i-num-dias-reanalise = wm-item.num-dias-reanalise.
        FIND FIRST wms-item-estab-local NO-LOCK
             WHERE wms-item-estab-local.cod-estab = wm-box-movto.cod-estab
               AND wms-item-estab-local.cod-local = wm-box-movto.cod-local
               AND wms-item-estab-local.cod-item  = wm-box-movto.cod-item NO-ERROR.
        IF AVAIL wms-item-estab-local THEN DO:
            ASSIGN i-ind-controle-saida = wms-item-estab-local.ind-controle-saida
                   i-ind-seq-retirada   = wms-item-estab-local.ind-seq-retirada
                   i-num-dias-reanalise = wms-item-estab-local.num-dias-reanalise.
        END.

        IF NOT AVAIL wm-item THEN DO:
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Item" *}
            RUN piCreateError (INPUT 56,            /* ErrorNumber     */
                               INPUT RETURN-VALUE + " " + wm-box-movto.cod-item, /* ErrorParameters */  
                               INPUT "EMS":U,       /* ErrorType       */
                               INPUT "ERROR":U).    /* ErrorSubType    */    
            UNDO bloco, RETURN "NOK":U.       
        END.

        FOR EACH  bfwm-box-picking 
            WHERE bfwm-box-picking.cod-estabel = wm-box-movto.cod-estabel AND
                  bfwm-box-picking.cod-local   = wm-box-movto.cod-local   AND
                  bfwm-box-picking.cod-picking = wm-box-movto.cod-picking NO-LOCK:

            IF CAN-FIND(FIRST wm-box
                        WHERE wm-box.cod-estabel    = bfwm-box-picking.cod-estabel AND
                              wm-box.cod-local      = bfwm-box-picking.cod-local   AND
                              wm-box.log-bloq-armaz = NO /** Liberado Armaz **/    AND
                              wm-box.id-box         = bfwm-box-picking.id-box-comp NO-LOCK) THEN LEAVE.
        END.

        IF AVAIL bfwm-box-picking THEN DO:

            FIND FIRST wm-item-picking 
                 WHERE wm-item-picking.cod-estabel = bfwm-box-picking.cod-estabel AND
                       wm-item-picking.cod-local   = bfwm-box-picking.cod-local   AND
                       wm-item-picking.cod-picking = bfwm-box-picking.cod-picking NO-LOCK NO-ERROR.

            IF AVAIL wm-item-picking THEN DO:

                FIND FIRST wm-item-embalagem-local 
                     WHERE wm-item-embalagem-local.cod-estabel   = wm-item-picking.cod-estabel  AND
                           wm-item-embalagem-local.cod-local     = wm-item-picking.cod-local    AND
                           wm-item-embalagem-local.cod-embalagem = wm-item-picking.cod-emb-area AND
                           wm-item-embalagem-local.cod-item      = wm-item-picking.cod-item     NO-LOCK NO-ERROR.

                IF NOT AVAIL wm-item-embalagem-local THEN DO:
                    FIND FIRST wm-item-embalagem-local 
                         WHERE wm-item-embalagem-local.cod-estabel  = wm-item-picking.cod-estabel  AND
                               wm-item-embalagem-local.cod-local    = wm-item-picking.cod-local    AND
                               wm-item-embalagem-local.cod-emb-item = wm-item-picking.cod-emb-area AND
                               wm-item-embalagem-local.cod-item     = wm-item-picking.cod-item     NO-LOCK NO-ERROR.

                    IF NOT AVAIL wm-item-embalagem-local THEN DO:
                        /* Inicio -- Projeto Internacional */
                        DEFINE VARIABLE c-lbl-liter-embalagem-item-local AS CHARACTER NO-UNDO.
                        {utp/ut-liter.i "Embalagem_Item_Local" *}
                        ASSIGN c-lbl-liter-embalagem-item-local = TRIM(RETURN-VALUE).
                        DEFINE VARIABLE c-lbl-liter-o-item AS CHARACTER NO-UNDO.
                        {utp/ut-liter.i "o_item" *}
                        ASSIGN c-lbl-liter-o-item = TRIM(RETURN-VALUE).
                        RUN piCreateError (INPUT 17899, /* &1 n∆o possui relacionamento com &2 */           /* ErrorNumber     */
                                           INPUT c-lbl-liter-embalagem-item-local + " " + wm-item-picking.cod-emb-area + "~~" + c-lbl-liter-o-item + " " + wm-item-picking.cod-item, /* ErrorParameters */  
                                           INPUT "EMS":U,       /* ErrorType       */
                                           INPUT "ERROR":U).    /* ErrorSubType    */    
                        UNDO bloco, RETURN "NOK":U.       
                    END.            

                    /* bfwm-item-picking = Pai */
                    FIND FIRST bfwm-item-picking 
                         WHERE bfwm-item-picking.cod-estabel  = wm-box-movto.cod-estabel        AND
                               bfwm-item-picking.cod-local    = wm-box-movto.cod-local          AND
                               bfwm-item-picking.cod-item     = wm-box-movto.cod-item           AND
                              (bfwm-item-picking.cod-refer    = wm-box-movto.cod-refer          OR
                               bfwm-item-picking.cod-refer    = ""                     )        AND
                               bfwm-item-picking.cod-emb-area = wm-item-embalagem-local.cod-embalagem NO-LOCK NO-ERROR.

                    IF NOT AVAIL bfwm-item-picking THEN DO:
                        /* Inicio -- Projeto Internacional */
                        DEFINE VARIABLE c-lbl-liter-area-de-picking AS CHARACTER NO-UNDO.
                        {utp/ut-liter.i "µrea_de_picking" *}
                        ASSIGN c-lbl-liter-area-de-picking = TRIM(RETURN-VALUE).
                        DEFINE VARIABLE c-lbl-liter-o-item2 AS CHARACTER NO-UNDO.
                        {utp/ut-liter.i "o_Item" *}
                        ASSIGN c-lbl-liter-o-item2 = TRIM(RETURN-VALUE).
                        RUN piCreateError (INPUT 38583, /*&1 inexistente para &2 &3 !*/ /* ErrorNumber     */
                                           INPUT c-lbl-liter-area-de-picking + "~~ " + c-lbl-liter-o-item2 + "~~ " + wm-box-movto.cod-item, /* ErrorParameters */  
                                           INPUT "EMS":U,       /* ErrorType       */
                                           INPUT "ERROR":U).    /* ErrorSubType    */    
                        UNDO bloco, RETURN "NOK":U.       
                    END.
                    ASSIGN l-embalagem-filha = YES
                           d-qtd-item-filha  = wm-item-embalagem-local.qtd-emb-item.                        
                END.
                ELSE
                    ASSIGN l-embalagem-filha = NO.
            END.
            ELSE DO:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-item AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "item" *}
                ASSIGN c-lbl-liter-item = TRIM(RETURN-VALUE).
                DEFINE VARIABLE c-lbl-liter-a-area-de-picking AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "a_†rea_de_picking_do_endereáo" *}
                ASSIGN c-lbl-liter-a-area-de-picking = TRIM(RETURN-VALUE).
                RUN piCreateError (INPUT 17923, /*N∆o existe &1 para &2*/           /* ErrorNumber     */
                                   INPUT c-lbl-liter-item + "~~" + c-lbl-liter-a-area-de-picking + " " + STRING(wm-box-movto.id-box), /* ErrorParameters */  
                                   INPUT "EMS":U,       /* ErrorType       */
                                   INPUT "ERROR":U).    /* ErrorSubType    */    
                UNDO bloco, RETURN "NOK":U.       
            END.
        END.
        ELSE DO:
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "µrea_de_picking_para_o_endereáo" *}
            RUN piCreateError (INPUT 56,            /* ErrorNumber     */
                               INPUT RETURN-VALUE + " " + STRING(wm-box-movto.id-box), /* ErrorParameters */  
                               INPUT "EMS":U,       /* ErrorType       */
                               INPUT "ERROR":U).    /* ErrorSubType    */    
            UNDO bloco, RETURN "NOK":U.       
        END.

        /* Verifica a capacidade para receber mais material do box de picking.  */
        FIND FIRST bfwm-box
             WHERE bfwm-box.cod-estabel    = wm-box-movto.cod-estabel
               AND bfwm-box.cod-local      = wm-box-movto.cod-local
               AND bfwm-box.log-bloq-armaz = NO /** Liberado **/
               AND bfwm-box.id-box         = wm-box-movto.id-box      NO-LOCK NO-ERROR.

        IF NOT AVAIL bfwm-box THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-endereco AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Endereáo" *}
            ASSIGN c-lbl-liter-endereco = TRIM(RETURN-VALUE).
            DEFINE VARIABLE c-lbl-liter-para-ressuprimento AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "para_ressuprimento" *}
            ASSIGN c-lbl-liter-para-ressuprimento = TRIM(RETURN-VALUE).
            RUN piCreateError (INPUT 56,            /* ErrorNumber     */
                               INPUT c-lbl-liter-endereco + "(" + STRING(wm-box-movto.id-box) + ") " + c-lbl-liter-para-ressuprimento , /* ErrorParameters */  
                               INPUT "EMS":U,       /* ErrorType       */
                               INPUT "ERROR":U).    /* ErrorSubType    */    
            UNDO bloco, RETURN "NOK":U.       
        END.       

        ASSIGN d-qtd-disp-peso = bfwm-box.qtd-capacidade-peso  - bfwm-box.qtd-capacidade-peso-util
               d-qtd-disp-ua   = bfwm-box.qtd-capacidade-ua    - bfwm-box.qtd-capacidade-ua-util.

        /******** chamada EPC ********************************************/
        FOR EACH tt-epc:
            DELETE tt-epc.
        END.
        {include/i-epc200.i2 &CodEvent='"Altera-Capacidade-Box"'
                             &CodParameter='"rowid-wm-box"'
                             &ValueParameter="string(rowid(bfwm-box))"} 
                             
        {include/i-epc200.i2 &CodEvent='"Altera-Capacidade-Box"'
                             &CodParameter='"Capacidade-disponivel"'
                             &ValueParameter="string(d-qtd-disp-ua)"}
                            
        {include/i-epc200.i2 &CodEvent='"Altera-Capacidade-Box"'
                             &CodParameter='"rowid-wm-item-embalagem-local"'
                             &ValueParameter="string(rowid(wm-item-embalagem-local))"}

        {include/i-epc201.i "Altera-Capacidade-Box"}
       
        FIND FIRST tt-epc 
            WHERE tt-epc.cod-event     = "Altera-Capacidade-Box"
              AND tt-epc.cod-parameter = "Capacidade-disponivel":U NO-ERROR.
        IF AVAIL tt-epc THEN do:
            ASSIGN d-qtd-disp-ua = DEC(tt-epc.val-parameter).
        END.
        /****************************************************************/  
        FIND FIRST wm-box-picking
             WHERE wm-box-picking.cod-estabel              = wm-box-movto.cod-estabel
               AND wm-box-picking.cod-local                = wm-box-movto.cod-local  
               AND wm-box-picking.id-box-comp              = wm-box-movto.id-box
               AND wm-box-picking.log-estoura-capac-ressup = YES NO-LOCK NO-ERROR.
        IF AVAIL wm-box-picking THEN DO:
            find first wm-item-picking
                 where wm-item-picking.cod-estabel            = wm-box-picking.cod-estabel
                   and wm-item-picking.cod-local              = wm-box-picking.cod-local
                   and wm-item-picking.cod-picking            = wm-box-picking.cod-picking
                   and wm-item-picking.cod-item               = wm-box-movto.cod-item
                   and wm-item-picking.cod-refer              = wm-box-movto.cod-refer
                   AND wm-item-picking.idi-gera-ressup-sugest = 2 no-lock no-error.
            IF AVAIL wm-item-picking THEN DO:
                for each wm-box-saldo
                   where wm-box-saldo.cod-estabel       = wm-box-movto.cod-estabel
                     and wm-box-saldo.cod-local         = wm-box-movto.cod-local
                     and wm-box-saldo.cod-cliente       = wm-box-movto.cod-cliente
                     and wm-box-saldo.cod-item          = wm-box-movto.cod-item
                     AND (wm-box-saldo.cod-refer        = wm-item-picking.cod-refer 
                      OR wm-item-picking.cod-refer      = "")
                     and wm-box-saldo.id-box            = wm-box-picking.id-box-comp
                     and (wm-box-saldo.ind-status-saldo = 3 /* liberado */
                      OR wm-box-saldo.ind-status-saldo  = 2) /*destinado*/
                     and wm-box-saldo.qtd-item > wm-box-saldo.qtd-item-bloq no-lock:
                
                     assign de-saldo-box = de-saldo-box
                                         + ( wm-box-saldo.qtd-item - wm-box-saldo.qtd-item-bloq ).
                    
                end.
                if  de-saldo-box <= wm-item-picking.qtd-minima THEN DO:
                    FIND FIRST wm-box
                         WHERE wm-box.cod-estabel = wm-box-movto.cod-estabel
                           AND wm-box.cod-local   = wm-box-movto.cod-local
                           AND wm-box.id-box      = wm-box-movto.id-box NO-LOCK NO-ERROR.
                    IF AVAIL wm-box THEN
                        ASSIGN d-qtd-disp-peso = wm-box.qtd-capacidade-peso
                               d-qtd-disp-ua   = wm-box.qtd-capacidade-ua.
                END.
            END.
        END.

        IF  d-qtd-disp-peso > 0
        AND d-qtd-disp-ua   > 0 THEN DO:
            
            ASSIGN l-box-completo = NO
                   c-lote-aux     = ""
                   l-existe-saldo = NO.
                /* Sugestao Endereáos Normais */
                IF NOT l-embalagem-filha THEN DO:

                   IF i-ind-controle-saida = 1 THEN DO: /* FEFO/PVPS -- data validade do produto */ 
                       FOR EACH wm-saldo-estoque NO-LOCK
                          WHERE wm-saldo-estoque.cod-estabel      = wm-box-movto.cod-estabel
                            AND wm-saldo-estoque.cod-local        = wm-box-movto.cod-local
                            AND wm-saldo-estoque.cod-cliente      = wm-box-movto.cod-cliente
                            AND wm-saldo-estoque.cod-item         = wm-box-movto.cod-item
                            AND wm-saldo-estoque.cod-refer        = wm-box-movto.cod-refer
                            AND wm-saldo-estoque.ind-status-saldo = 3
                            AND (wm-saldo-estoque.dt-validade-lote > TODAY + i-num-dias-reanalise OR
                                 wm-saldo-estoque.dt-validade-lote = ?)
                            BY wm-saldo-estoque.dt-validade-lote:

                            RUN openQueryReplenishment   IN THIS-PROCEDURE.
                            RUN doAlocationReplenishment IN THIS-PROCEDURE.
                            IF l-box-completo THEN LEAVE. /* Se o endereco estiver completo */

                       END.
                   END.
                   ELSE DO:
                       /* -- FIFO/PEPS data entrada do produto no sistema */
                       /* Deveria fazer por dt-transacao do wm-box-saldo mas nao esta fazendo */
                       FOR EACH bfwm-box-saldo2 WHERE
                           bfwm-box-saldo2.cod-estabel      = wm-box-movto.cod-estabel AND
                           bfwm-box-saldo2.cod-local        = wm-box-movto.cod-local   AND
                           bfwm-box-saldo2.cod-cliente      = wm-box-movto.cod-cliente AND
                           bfwm-box-saldo2.cod-item         = wm-box-movto.cod-item    AND
                           bfwm-box-saldo2.cod-refer        = wm-box-movto.cod-refer   AND
/* liberado */             bfwm-box-saldo2.ind-status-saldo = 3 NO-LOCK,
                           EACH wm-saldo-estoque WHERE
                                wm-saldo-estoque.cod-estabel      = bfwm-box-saldo2.cod-estabel  AND
                                wm-saldo-estoque.cod-local        = bfwm-box-saldo2.cod-local    AND
                                wm-saldo-estoque.cod-cliente      = bfwm-box-saldo2.cod-cliente  AND
                                wm-saldo-estoque.cod-item         = bfwm-box-saldo2.cod-item     AND
                                wm-saldo-estoque.cod-refer        = bfwm-box-saldo2.cod-refer    AND
                                wm-saldo-estoque.cod-lote         = bfwm-box-saldo2.cod-lote     AND
/* liberado */                  wm-saldo-estoque.ind-status-saldo = 3                            AND
                                (wm-saldo-estoque.dt-validade-lote > TODAY + i-num-dias-reanalise OR
                                 wm-saldo-estoque.dt-validade-lote = ?) NO-LOCK
                           BY bfwm-box-saldo2.dt-transacao:

                              RUN openQueryReplenishment   IN THIS-PROCEDURE.
                              RUN doAlocationReplenishment IN THIS-PROCEDURE.
                              IF  l-box-completo = YES THEN 
                                  LEAVE.       
                       END.
                   END.
               END.
               /* µrea Picking Pai */
               ELSE DO:
                    RUN openQueryReplenishmentSon IN THIS-PROCEDURE.
                    RUN doAlocationReplenishment  IN THIS-PROCEDURE.     
               END.

               RUN MakeMovtoItemReplenishment IN THIS-PROCEDURE.

               IF CAN-FIND(FIRST RowErrors NO-LOCK) THEN 
                   UNDO bloco, RETURN "NOK":U.               

        END.
        ELSE DO:
            RUN piCreateError (INPUT 54355,         /* ErrorNumber     */
                               INPUT "":U,          /* ErrorParameters */  
                               INPUT "EMS":U,       /* ErrorType       */
                               INPUT "ERROR":U).    /* ErrorSubType    */    
            UNDO bloco, RETURN "NOK":U.        
        END.
        IF NOT l-existe-saldo THEN DO:
            RUN piCreateError (INPUT 27608,         /* ErrorNumber     */
                               INPUT "":U,          /* ErrorParameters */  
                               INPUT "EMS":U,       /* ErrorType       */
                               INPUT "ERROR":U).    /* ErrorSubType    */    
            UNDO bloco, RETURN "NOK":U.    
        END.
        IF NOT l-capacidade-res AND NOT l-ressup THEN DO:
            RUN piCreateError (INPUT 54355,         /* ErrorNumber     */
                               INPUT "":U,          /* ErrorParameters */  
                               INPUT "EMS":U,       /* ErrorType       */
                               INPUT "ERROR":U).    /* ErrorSubType    */    
            UNDO bloco, RETURN "NOK":U.    
        END.
        ELSE DO:
            IF d-qtd-item = 0 THEN DO:
                 RUN piCreateError (INPUT 27608,         /* ErrorNumber     */
                                    INPUT "":U,          /* ErrorParameters */  
                                    INPUT "EMS":U,       /* ErrorType       */
                                    INPUT "ERROR":U).    /* ErrorSubType    */    
                 UNDO bloco, RETURN "NOK":U.        
            END.
        END.

        FIND FIRST wm-docto-itens EXCLUSIVE-LOCK
             WHERE wm-docto-itens.cod-estabel  = ttWm-docto.cod-estabel
               AND wm-docto-itens.cod-local    = ttWm-docto.cod-local
               AND wm-docto-itens.id-docto     = ttWm-docto.id-docto
               AND wm-docto-itens.cod-item     = wm-box-movto.cod-item
               AND wm-docto-itens.cod-refer    = wm-box-movto.cod-refer  NO-ERROR.
        IF AVAIL wm-docto-itens THEN DO:
            IF l-primeira-vez =YES  THEN DO:
                ASSIGN wm-docto-itens.qtd-item          = wm-docto-itens.qtd-item  + d-qtd-item - 1
                       wm-docto-itens.qtd-item-original = wm-docto-itens.qtd-item  + d-qtd-item - 1.
            END.
            ELSE DO:
                ASSIGN wm-docto-itens.qtd-item          = wm-docto-itens.qtd-item  + d-qtd-item 
                       wm-docto-itens.qtd-item-original = wm-docto-itens.qtd-item  + d-qtd-item
                       wm-docto-itens.ind-sit-movto     = 1.
            END.
            RELEASE wm-docto-itens.
        END.
        ELSE DO:
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Item" *}
            RUN piCreateError (INPUT 56,
                               INPUT RETURN-VALUE,
                               INPUT "EMS":U,
                               INPUT "ERROR":U).
            UNDO bloco, RETURN "NOK":U.
        END.
    END.
END.

RETURN "OK":U.

/********************************** PROCEDURES INTERNAS *******************************************/

PROCEDURE openQueryReplenishment:
/*
 * Abre a query para verificar as embalagens que podem ser utilizadas no ressuprimento
 */
    FIND FIRST ponto-programa WHERE
               ponto-programa.nome-programa = "WM9060"
           AND ponto-programa.ponto         = 1
               NO-LOCK NO-ERROR.
    IF AVAIL ponto-programa 
    THEN FIND FIRST conteudo-programa WHERE
                    conteudo-programa.cod-programa = ponto-programa.cod-programa
                AND ENTRY(1,conteudo-programa.conteudo,",") = wm-saldo-estoque.cod-estabel
                AND ENTRY(2,conteudo-programa.conteudo,",") = wm-saldo-estoque.cod-local
                    NO-LOCK NO-ERROR.
    
    IF AVAIL conteudo-programa
    THEN DO:
        IF i-ind-seq-retirada = 1  /* horizontal */ THEN 
               OPEN QUERY q-box-saldo
               FOR EACH wm-box-saldo
                  WHERE wm-box-saldo.cod-estabel      = wm-saldo-estoque.cod-estabel
                    AND wm-box-saldo.cod-local        = wm-saldo-estoque.cod-local
                    AND wm-box-saldo.cod-item         = wm-saldo-estoque.cod-item
                    AND wm-box-saldo.cod-refer        = wm-saldo-estoque.cod-refer
                    AND wm-box-saldo.cod-lote         = wm-saldo-estoque.cod-lote
                    AND wm-box-saldo.cod-cliente      = wm-saldo-estoque.cod-cliente
                    AND wm-box-saldo.cod-embalagem    = wm-item-picking.cod-emb-area
                    AND wm-box-saldo.qtd-item         > wm-box-saldo.qtd-item-bloq
                    AND wm-box-saldo.ind-status-saldo = 3 /* liberado */ EXCLUSIVE-LOCK,
                 FIRST  wm-box
                  WHERE wm-box.cod-estabel       = wm-box-saldo.cod-estabel
                    AND wm-box.cod-local         = wm-box-saldo.cod-local
                    AND wm-box.log-bloq-retir    = NO /** Liberado **/
                    AND wm-box.id-box            = wm-box-saldo.id-box NO-LOCK,
                 FIRST  wm-tipo-box
                  WHERE wm-tipo-box.cdn-tipo-box    = wm-box.cdn-tipo-box 
                    AND wm-tipo-box.ind-status-box  = 1 /* normal */  NO-LOCK,
                 FIRST  wm-item-embalagem-local
                  WHERE wm-item-embalagem-local.cod-estabel   = wm-box-saldo.cod-estabel 
                    AND wm-item-embalagem-local.cod-local     = wm-box-saldo.cod-local
                    AND wm-item-embalagem-local.cod-item      = wm-box-saldo.cod-item
                    AND wm-item-embalagem-local.cod-embalagem = wm-box-saldo.cod-embalagem NO-LOCK
                  BY wm-box-saldo.dt-transacao         
                  BY wm-box-saldo.qtd-item
                  BY wm-box-saldo.ind-status-box DESCENDING  /* obrigatorio/preferencial/normal */
                  BY wm-box.cod-bloco            
                  BY wm-box.cod-rua              
                  BY wm-box.cod-coluna           
                  BY wm-box.cod-nivel                      
                  BY wm-item-embalagem-local.qtd-volume.

        ELSE   /* vertical */ 
               OPEN QUERY q-box-saldo
               FOR EACH wm-box-saldo
                  WHERE wm-box-saldo.cod-estabel      = wm-saldo-estoque.cod-estabel
                    AND wm-box-saldo.cod-local        = wm-saldo-estoque.cod-local
                    AND wm-box-saldo.cod-item         = wm-saldo-estoque.cod-item
                    AND wm-box-saldo.cod-refer        = wm-saldo-estoque.cod-refer
                    AND wm-box-saldo.cod-lote         = wm-saldo-estoque.cod-lote
                    AND wm-box-saldo.cod-cliente      = wm-saldo-estoque.cod-cliente
                    AND wm-box-saldo.cod-embalagem    = wm-item-picking.cod-emb-area
                    AND wm-box-saldo.qtd-item         > wm-box-saldo.qtd-item-bloq
                    AND wm-box-saldo.ind-status-saldo = 3 /* liberado */ EXCLUSIVE-LOCK,
                 FIRST  wm-box
                  WHERE wm-box.cod-estabel       = wm-box-saldo.cod-estabel
                    AND wm-box.cod-local         = wm-box-saldo.cod-local
                    AND wm-box.log-bloq-retir    = NO /** Liberado **/
                    AND wm-box.id-box            = wm-box-saldo.id-box NO-LOCK,
                 FIRST  wm-tipo-box
                  where wm-tipo-box.cdn-tipo-box    = wm-box.cdn-tipo-box 
                    and wm-tipo-box.ind-status-box  = 1 /* normal */  NO-LOCK,                    
                 FIRST  wm-item-embalagem-local
                  WHERE wm-item-embalagem-local.cod-estabel   = wm-box-saldo.cod-estabel
                    AND wm-item-embalagem-local.cod-local     = wm-box-saldo.cod-local
                    AND wm-item-embalagem-local.cod-item      = wm-box-saldo.cod-item
                    AND wm-item-embalagem-local.cod-embalagem = wm-box-saldo.cod-embalagem NO-LOCK            
                  BY wm-box-saldo.dt-transacao         
                  BY wm-box-saldo.qtd-item
                  BY wm-box-saldo.ind-status-box  DESCENDING /* obrigatorio/preferencial/normal */
                  BY wm-box.cod-bloco             
                  BY wm-box.cod-rua               
                  BY wm-box.cod-nivel              
                  BY wm-box.cod-coluna 
                  BY wm-item-embalagem-local.qtd-volume.

    END.
    ELSE DO:
        IF i-ind-seq-retirada = 1  /* horizontal */ THEN 
               OPEN QUERY q-box-saldo
               FOR EACH wm-box-saldo
                  WHERE wm-box-saldo.cod-estabel      = wm-saldo-estoque.cod-estabel
                    AND wm-box-saldo.cod-local        = wm-saldo-estoque.cod-local
                    AND wm-box-saldo.cod-item         = wm-saldo-estoque.cod-item
                    AND wm-box-saldo.cod-refer        = wm-saldo-estoque.cod-refer
                    AND wm-box-saldo.cod-lote         = wm-saldo-estoque.cod-lote
                    AND wm-box-saldo.cod-cliente      = wm-saldo-estoque.cod-cliente
                    AND wm-box-saldo.cod-embalagem    = wm-item-picking.cod-emb-area
                    AND wm-box-saldo.qtd-item         > wm-box-saldo.qtd-item-bloq
                    AND wm-box-saldo.ind-status-saldo = 3 /* liberado */ EXCLUSIVE-LOCK,
                 FIRST  wm-box
                  WHERE wm-box.cod-estabel       = wm-box-saldo.cod-estabel
                    AND wm-box.cod-local         = wm-box-saldo.cod-local
                    AND wm-box.log-bloq-retir    = NO /** Liberado **/
                    AND wm-box.id-box            = wm-box-saldo.id-box NO-LOCK,
                 FIRST  wm-tipo-box
                  WHERE wm-tipo-box.cdn-tipo-box    = wm-box.cdn-tipo-box 
                    AND wm-tipo-box.ind-status-box  = 1 /* normal */  NO-LOCK,
                 FIRST  wm-item-embalagem-local
                  WHERE wm-item-embalagem-local.cod-estabel   = wm-box-saldo.cod-estabel 
                    AND wm-item-embalagem-local.cod-local     = wm-box-saldo.cod-local
                    AND wm-item-embalagem-local.cod-item      = wm-box-saldo.cod-item
                    AND wm-item-embalagem-local.cod-embalagem = wm-box-saldo.cod-embalagem NO-LOCK
                  BY wm-box-saldo.dt-transacao         
                  BY wm-box-saldo.ind-status-box DESCENDING  /* obrigatorio/preferencial/normal */
                  BY wm-box.cod-bloco            
                  BY wm-box.cod-rua              
                  BY wm-box.cod-coluna           
                  BY wm-box.cod-nivel                      
                  BY wm-item-embalagem-local.qtd-volume.

        ELSE   /* vertical */ 
               OPEN QUERY q-box-saldo
               FOR EACH wm-box-saldo
                  WHERE wm-box-saldo.cod-estabel      = wm-saldo-estoque.cod-estabel
                    AND wm-box-saldo.cod-local        = wm-saldo-estoque.cod-local
                    AND wm-box-saldo.cod-item         = wm-saldo-estoque.cod-item
                    AND wm-box-saldo.cod-refer        = wm-saldo-estoque.cod-refer
                    AND wm-box-saldo.cod-lote         = wm-saldo-estoque.cod-lote
                    AND wm-box-saldo.cod-cliente      = wm-saldo-estoque.cod-cliente
                    AND wm-box-saldo.cod-embalagem    = wm-item-picking.cod-emb-area
                    AND wm-box-saldo.qtd-item         > wm-box-saldo.qtd-item-bloq
                    AND wm-box-saldo.ind-status-saldo = 3 /* liberado */ EXCLUSIVE-LOCK,
                 FIRST  wm-box
                  WHERE wm-box.cod-estabel       = wm-box-saldo.cod-estabel
                    AND wm-box.cod-local         = wm-box-saldo.cod-local
                    AND wm-box.log-bloq-retir    = NO /** Liberado **/
                    AND wm-box.id-box            = wm-box-saldo.id-box NO-LOCK,
                 FIRST  wm-tipo-box
                  where wm-tipo-box.cdn-tipo-box    = wm-box.cdn-tipo-box 
                    and wm-tipo-box.ind-status-box  = 1 /* normal */  NO-LOCK,                    
                 FIRST  wm-item-embalagem-local
                  WHERE wm-item-embalagem-local.cod-estabel   = wm-box-saldo.cod-estabel
                    AND wm-item-embalagem-local.cod-local     = wm-box-saldo.cod-local
                    AND wm-item-embalagem-local.cod-item      = wm-box-saldo.cod-item
                    AND wm-item-embalagem-local.cod-embalagem = wm-box-saldo.cod-embalagem NO-LOCK            
                  BY wm-box-saldo.dt-transacao         
                  BY wm-box-saldo.ind-status-box  DESCENDING /* obrigatorio/preferencial/normal */
                  BY wm-box.cod-bloco             
                  BY wm-box.cod-rua               
                  BY wm-box.cod-nivel              
                  BY wm-box.cod-coluna 
                  BY wm-item-embalagem-local.qtd-volume.

    END.

    RETURN "OK":U.

END PROCEDURE.


PROCEDURE openQueryReplenishmentSon:

   OPEN QUERY q-box-saldo-picking
       FOR EACH wm-box-picking 
          WHERE wm-box-picking.cod-estabel = bfwm-item-picking.cod-estabel AND
                wm-box-picking.cod-local   = bfwm-item-picking.cod-local   AND
                wm-box-picking.cod-picking = bfwm-item-picking.cod-picking NO-LOCK,
         EACH   wm-box-saldo
          WHERE wm-box-saldo.cod-estabel      = wm-box-picking.cod-estabel
            AND wm-box-saldo.cod-local        = wm-box-picking.cod-local
            AND wm-box-saldo.id-box           = wm-box-picking.id-box
            AND wm-box-saldo.cod-embalagem    = bfwm-item-picking.cod-emb-area
            AND wm-box-saldo.qtd-item         > wm-box-saldo.qtd-item-bloq
            AND wm-box-saldo.ind-status-saldo = 3 /* liberado */ EXCLUSIVE-LOCK,
         FIRST  wm-saldo-estoque OF wm-box-saldo NO-LOCK, 
         FIRST  wm-box
          WHERE wm-box.cod-estabel       = wm-box-saldo.cod-estabel
            AND wm-box.cod-local         = wm-box-saldo.cod-local
            AND wm-box.log-bloq-retir    = NO /** Liberado **/
            AND wm-box.id-box            = wm-box-saldo.id-box NO-LOCK,
          FIRST wm-item-embalagem-local
          WHERE wm-item-embalagem-local.cod-estabel   = wm-box-saldo.cod-estabel
            AND wm-item-embalagem-local.cod-local     = wm-box-saldo.cod-local
            AND wm-item-embalagem-local.cod-item      = wm-box-saldo.cod-item
            AND wm-item-embalagem-local.cod-embalagem = wm-box-saldo.cod-embalagem NO-LOCK.
    RETURN "OK":U.

END PROCEDURE.


PROCEDURE doAlocationReplenishment:

    DEF VAR d-qtd-emb   LIKE wm-box-movto.qti-embalagem NO-UNDO.
    DEF VAR r-rowid     AS   ROWID                      NO-UNDO.
    DEF VAR l-continua  AS   LOGICAL                    NO-UNDO.
    DEFINE VARIABLE d-qtd-liberada  LIKE wm-box-movto.qtd-item  NO-UNDO.

    ASSIGN d-qtd-liberada = 0.
    l-aloca :
    DO:

      /*-----  1 - Procura Embalagens que a Quantidade seja modulo 0  ------*/
      /*-----  Tem como objetivo efetuar o ressuprimento de embalagens fechadas ---*/

      IF l-embalagem-filha THEN
        GET FIRST q-box-saldo-picking.
      ELSE
        GET FIRST q-box-saldo.

      RUN VerifyCapacityBin IN THIS-PROCEDURE.

      REPEAT WHILE ( AVAIL wm-box-saldo AND l-box-completo = NO  ):
      	
 	    ASSIGN d-qtd-liberada = wm-box-saldo.qtd-item - wm-box-saldo.qtd-item-bloq.	

            FOR EACH tt-epc
                WHERE tt-epc.cod-event = "Geracao-Ressuprimento-PIA":U:
                DELETE tt-epc.
            END.

            /* Criacao da Temp-Table tt-epc */
            {include/i-epc200.i2 &CodEvent='"Geracao-Ressuprimento-PIA"'
                                 &CodParameter='"Estabel"'
                                 &ValueParameter="wm-box-saldo.cod-estabel"} 
                                 
            /* Criacao da Temp-Table tt-epc */
            {include/i-epc200.i2 &CodEvent='"Geracao-Ressuprimento-PIA"'
                                 &CodParameter='"Local"'
                                 &ValueParameter="wm-box-saldo.cod-local"} 

            /* Criacao da Temp-Table tt-epc */
            {include/i-epc200.i2 &CodEvent='"Geracao-Ressuprimento-PIA"'
                                 &CodParameter='"Item-Box-Saldo"'
                                 &ValueParameter="wm-box-saldo.cod-item"} 
                                 
            /* Criacao da Temp-Table tt-epc */
            {include/i-epc200.i2 &CodEvent='"Geracao-Ressuprimento-PIA"'
                                 &CodParameter='"Lote-Box-Saldo"'
                                 &ValueParameter="wm-box-saldo.cod-lote"} 
                                 
            /* Criacao da Temp-Table tt-epc */
            {include/i-epc200.i2 &CodEvent='"Geracao-Ressuprimento-PIA"'
                                 &CodParameter='"IdBox-Saida"'
                                 &ValueParameter="STRING(wm-box-saldo.id-box)"} 
                                 
            /* Criacao da Temp-Table tt-epc */
            {include/i-epc200.i2 &CodEvent='"Geracao-Ressuprimento-PIA"'
                                 &CodParameter='"IdBox-Entrada"'
                                 &ValueParameter="STRING(wm-box-movto.id-box)"} 
                                 
            /* Criacao da Temp-Table tt-epc */
            {include/i-epc200.i2 &CodEvent='"Geracao-Ressuprimento-PIA"'
                                 &CodParameter='"Qtd-Disponivel"'
                                 &ValueParameter="STRING(d-qtd-liberada)"} 
        
            /* Chamada EPC */
            {include/i-epc201.i "Geracao-Ressuprimento-PIA"}
        
            FIND FIRST tt-epc 
                WHERE tt-epc.cod-event     = "Geracao-Ressuprimento-PIA"
                  AND tt-epc.cod-parameter = "next-saldo":U NO-ERROR.
            IF AVAIL tt-epc THEN do:
                  IF l-embalagem-filha THEN DO:
                    GET FIRST q-box-saldo-picking.
                    LEAVE.
                  END.
                  ELSE DO:
                    GET FIRST q-box-saldo.
                    LEAVE.
                  END.
            END.

          /*No programa WM9055 h† uma validacao para n∆o serem selecionadas os */
          /*saldos dos endereáos de picking. Como o ressuprimento da †rea filha*/
          /*busca exclusivamente da †rea pai, n∆o Ç necess†rio passar por esta */
          /*procedure.                                                         */ 
          IF NOT l-embalagem-filha THEN DO:
              RUN verifySaldoCompletoDisponivel IN THIS-PROCEDURE.
              IF RETURN-VALUE = 'NOK':U THEN DO:
                  GET NEXT q-box-saldo.
                  NEXT.
              END.
          END.

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
                            RUN getLoteSaldoDisponivel  IN h-proxy124 (OUTPUT l-saldo-disp).
                            RUN getLoteAlocaWMS         IN h-proxy124 (OUTPUT l-aloca-wms).

                            IF l-saldo-disp AND l-aloca-wms THEN
                                ASSIGN l-lote-bloqueado = NO.
                            ELSE
                                ASSIGN l-lote-bloqueado = YES.
                        END.

                        IF VALID-HANDLE(h-proxy124) THEN DO:
                            RUN destroy IN h-proxy124.
                            DELETE OBJECT h-proxy124 NO-ERROR.
                        END.
                    END.

                    /* Se lote bloqueado */
                    IF l-lote-bloqueado THEN DO:
                        IF l-embalagem-filha THEN DO:
                            GET NEXT q-box-saldo-picking.
                            NEXT.
                        END.
                        ELSE DO:
                            GET NEXT q-box-saldo.
                            NEXT.
                        END.
                    END.
                END.
            &ENDIF

            IF wm-box-saldo.qtd-item          > wm-box-saldo.qtd-item-bloq AND
               wm-box-saldo.ind-status-saldo  = 3 AND
               NOT l-capacidade-ok THEN
                ASSIGN l-existe-saldo = YES.

            IF wm-box-saldo.qtd-item          > wm-box-saldo.qtd-item-bloq AND
               wm-box-saldo.ind-status-saldo  = 3 AND
               l-capacidade-ok THEN DO:                
                ASSIGN l-existe-saldo = YES.
                IF NOT l-embalagem-filha THEN DO:

                    FOR EACH tt-epc:
                        DELETE tt-epc.
                    END.                  

                    ASSIGN de-qtd-ressup = wm-box-saldo.qtd-item - wm-box-saldo.qtd-item-bloq.

                    RUN VerifyCapacityBeforeReplenishment IN THIS-PROCEDURE.

                    IF l-capacidade-res = YES THEN DO:
                        /* tabela para gerar ressuprimento */
                        CREATE ttwm-box-saida-ressup.  
                        ASSIGN ttwm-box-saida-ressup.cod-estabel    = ttWm-docto.cod-estabel                          
                               ttwm-box-saida-ressup.cod-local      = ttWm-docto.cod-local
                               ttwm-box-saida-ressup.cod-item       = wm-box-saldo.cod-item
                               ttwm-box-saida-ressup.cod-refer      = wm-box-saldo.cod-refer
                               ttwm-box-saida-ressup.cod-lote       = wm-box-saldo.cod-lote
                               ttwm-box-saida-ressup.dt-transacao   = TODAY
                               ttwm-box-saida-ressup.id-docto       = ttWm-docto.id-docto
                               ttwm-box-saida-ressup.num-seq-item   = ttWm-docto-itens.num-seq-item
                               ttwm-box-saida-ressup.id-saldo       = wm-box-saldo.id-saldo                                                      
                               ttwm-box-saida-ressup.qtd-saida      = wm-box-saldo.qtd-item - wm-box-saldo.qtd-item-bloq
                               ttwm-box-saida-ressup.qtd-atendida   = 0
                               ttwm-box-saida-ressup.qtd-necessaria = 0
                               ttwm-box-saida-ressup.cod-embalagem  = IF l-embalagem-filha THEN wm-item-picking.cod-emb-area ELSE wm-box-saldo.cod-embalagem
                               ttwm-box-saida-ressup.cod-cliente    = ttWm-docto-itens.cod-cliente
                               ttwm-box-saida-ressup.id-ressup      = NEXT-VALUE(id-ressup-wms)
                               ttwm-box-saida-ressup.id-box         = wm-box-movto.id-box
                               ttwm-box-saida-ressup.id-box-saida   = wm-box-saldo.id-box.
                        RELEASE ttwm-box-saida-ressup.
    
                        ASSIGN c-lote-aux = wm-box-saldo.cod-lote.
                        /*  wm-box-saldo.qtd-pendente     = wm-box-saldo.qtd-pendente + (wm-box-saldo.qtd-item - wm-box-saldo.qtd-item-bloq)
                            wm-box-saldo.qtd-item-bloq    = wm-box-saldo.qtd-item
                            wm-box-saldo.ind-status-saldo = 1 /* Comprometido */
                        */
                        RUN VerifyCapacityBin IN THIS-PROCEDURE.

                        IF l-box-completo = YES THEN LEAVE. /* Se o endereco estiver completo */
                        ELSE DO:
                            RUN PermiteEstouroCapacidadeRessuprimento (INPUT ttWm-docto.cod-estabel,
                                                                       INPUT ttWm-docto.cod-local, 
                                                                       INPUT wm-box-movto.id-box).
                            IF l-box-completo = YES THEN LEAVE. /* Se o endereco estiver completo */
                        END.
                    END.
                END.
                ELSE DO:
                    IF ((wm-box-saldo.qtd-item - wm-box-saldo.qtd-item-bloq) / d-qtd-item-filha) >= 1 THEN DO:
                        DO d-qtd-emb = 1 TO TRUNCATE((wm-box-saldo.qtd-item - wm-box-saldo.qtd-item-bloq) / d-qtd-item-filha, 0):
                            
                            ASSIGN de-qtd-ressup = d-qtd-item-filha.
    
                            RUN VerifyCapacityBeforeReplenishment IN THIS-PROCEDURE.
    
                            IF l-capacidade-res = YES THEN DO:                           
                                /* tabela para gerar ressuprimento */
                                CREATE ttwm-box-saida-ressup.  
                                ASSIGN ttwm-box-saida-ressup.cod-estabel    = ttWm-docto.cod-estabel                          
                                       ttwm-box-saida-ressup.cod-local      = ttWm-docto.cod-local
                                       ttwm-box-saida-ressup.cod-item       = wm-box-saldo.cod-item
                                       ttwm-box-saida-ressup.cod-refer      = wm-box-saldo.cod-refer
                                       ttwm-box-saida-ressup.cod-lote       = wm-box-saldo.cod-lote
                                       ttwm-box-saida-ressup.dt-transacao   = TODAY
                                       ttwm-box-saida-ressup.id-docto       = ttWm-docto.id-docto
                                       ttwm-box-saida-ressup.num-seq-item   = ttWm-docto-itens.num-seq-item
                                       ttwm-box-saida-ressup.id-saldo       = wm-box-saldo.id-saldo                                                      
                                       ttwm-box-saida-ressup.qtd-saida      = d-qtd-item-filha
                                       ttwm-box-saida-ressup.qtd-atendida   = 0
                                       ttwm-box-saida-ressup.qtd-necessaria = 0
                                       ttwm-box-saida-ressup.cod-embalagem  = IF l-embalagem-filha THEN wm-item-picking.cod-emb-area ELSE wm-box-saldo.cod-embalagem
                                       ttwm-box-saida-ressup.cod-cliente    = ttWm-docto-itens.cod-cliente
                                       ttwm-box-saida-ressup.id-ressup      = NEXT-VALUE(id-ressup-wms)
                                       ttwm-box-saida-ressup.id-box         = wm-box-movto.id-box
                                       ttwm-box-saida-ressup.id-box-saida   = wm-box-saldo.id-box
                                       r-rowid                            = ROWID(ttwm-box-saida-ressup).
                                RELEASE ttwm-box-saida-ressup.
                                FIND ttwm-box-saida-ressup WHERE
                                     rowid(ttwm-box-saida-ressup) = r-rowid
                                     NO-LOCK NO-ERROR.
    
                                ASSIGN c-lote-aux = wm-box-saldo.cod-lote.
                                /*  wm-box-saldo.qtd-pendente          = wm-box-saldo.qtd-pendente + d-qtd-item-filha
                                    wm-box-saldo.qtd-item-bloq         = wm-box-saldo.qtd-item-bloq + d-qtd-item-filha
                                
                                IF wm-box-saldo.qtd-pendente = wm-box-saldo.qtd-original THEN
                                    ASSIGN wm-box-saldo.qtd-item-bloq         = wm-box-saldo.qtd-item
                                           wm-box-saldo.ind-status-saldo      = 1   /* Comprometido */.
                                */

                                RUN VerifyCapacityBin IN THIS-PROCEDURE.
/*                                 IF l-box-completo = YES THEN LEAVE. /* Se o endereco estiver completo */ */
                                IF l-capacidade-res = NO THEN LEAVE.
                            END.
                        END.
                    END. 

                    IF NOT l-box-completo AND
                       ((wm-box-saldo.qtd-item - wm-box-saldo.qtd-item-bloq) / d-qtd-item-filha) <> INT((wm-box-saldo.qtd-item - wm-box-saldo.qtd-item-bloq) / d-qtd-item-filha) THEN DO:

                        ASSIGN de-qtd-ressup = ROUND((((wm-box-saldo.qtd-item - wm-box-saldo.qtd-item-bloq) / d-qtd-item-filha) - TRUNCATE((wm-box-saldo.qtd-item - wm-box-saldo.qtd-item-bloq) / d-qtd-item-filha, 0)) * d-qtd-item-filha,4).

                        RUN VerifyCapacityBeforeReplenishment IN THIS-PROCEDURE.

                        IF l-capacidade-res = YES THEN DO:
                            /* tabela para gerar ressuprimento */
                            CREATE ttwm-box-saida-ressup.  
                            ASSIGN ttwm-box-saida-ressup.cod-estabel    = ttWm-docto.cod-estabel                          
                                   ttwm-box-saida-ressup.cod-local      = ttWm-docto.cod-local
                                   ttwm-box-saida-ressup.cod-item       = wm-box-saldo.cod-item
                                   ttwm-box-saida-ressup.cod-refer      = wm-box-saldo.cod-refer
                                   ttwm-box-saida-ressup.cod-lote       = wm-box-saldo.cod-lote
                                   ttwm-box-saida-ressup.dt-transacao   = TODAY
                                   ttwm-box-saida-ressup.id-docto       = ttWm-docto.id-docto
                                   ttwm-box-saida-ressup.num-seq-item   = ttWm-docto-itens.num-seq-item
                                   ttwm-box-saida-ressup.id-saldo       = wm-box-saldo.id-saldo                                                      
                                   ttwm-box-saida-ressup.qtd-saida      = ROUND((((wm-box-saldo.qtd-item - wm-box-saldo.qtd-item-bloq) / d-qtd-item-filha) - TRUNCATE((wm-box-saldo.qtd-item - wm-box-saldo.qtd-item-bloq) / d-qtd-item-filha, 0)) * d-qtd-item-filha,4)
                                   ttwm-box-saida-ressup.qtd-atendida   = 0
                                   ttwm-box-saida-ressup.qtd-necessaria = 0
                                   ttwm-box-saida-ressup.cod-embalagem  = IF l-embalagem-filha THEN wm-item-picking.cod-emb-area ELSE wm-box-saldo.cod-embalagem
                                   ttwm-box-saida-ressup.cod-cliente    = ttWm-docto-itens.cod-cliente
                                   ttwm-box-saida-ressup.id-ressup      = NEXT-VALUE(id-ressup-wms)
                                   ttwm-box-saida-ressup.id-box         = wm-box-movto.id-box
                                   ttwm-box-saida-ressup.id-box-saida   = wm-box-saldo.id-box
                                   r-rowid                            = ROWID(ttwm-box-saida-ressup).
                            RELEASE ttwm-box-saida-ressup.
                            FIND ttwm-box-saida-ressup WHERE
                                 rowid(ttwm-box-saida-ressup) = r-rowid
                                 NO-LOCK NO-ERROR.
                            /*
                            ASSIGN wm-box-saldo.qtd-pendente          = wm-box-saldo.qtd-pendente + ROUND((((wm-box-saldo.qtd-item - wm-box-saldo.qtd-item-bloq) / d-qtd-item-filha) - TRUNCATE((wm-box-saldo.qtd-item - wm-box-saldo.qtd-item-bloq) / d-qtd-item-filha, 0)) * d-qtd-item-filha,4) /* d-qtd-item-filha */
                                   c-lote-aux                         = wm-box-saldo.cod-lote
                                   wm-box-saldo.qtd-item-bloq         = wm-box-saldo.qtd-item-bloq + ROUND((((wm-box-saldo.qtd-item - wm-box-saldo.qtd-item-bloq) / d-qtd-item-filha) - TRUNCATE((wm-box-saldo.qtd-item - wm-box-saldo.qtd-item-bloq) / d-qtd-item-filha, 0)) * d-qtd-item-filha,4) /* d-qtd-item-filha */.
                            IF wm-box-saldo.qtd-pendente = wm-box-saldo.qtd-original THEN
                                ASSIGN wm-box-saldo.qtd-item-bloq         = wm-box-saldo.qtd-item
                                       wm-box-saldo.ind-status-saldo      = 1   /* Comprometido */.
    */
                            RUN VerifyCapacityBin IN THIS-PROCEDURE.
                            IF l-box-completo = YES THEN LEAVE. /* Se o endereco estiver completo */
                            ELSE DO:
                                RUN PermiteEstouroCapacidadeRessuprimento (INPUT ttWm-docto.cod-estabel,
                                                                           INPUT ttWm-docto.cod-local, 
                                                                           INPUT wm-box-movto.id-box).
                                IF l-box-completo = YES THEN LEAVE. /* Se o endereco estiver completo */
                            END.

                        END.
                    END.
                END.
            END.

            RUN  VerifyCapacityBin IN THIS-PROCEDURE.             

            IF l-embalagem-filha THEN
                GET NEXT q-box-saldo-picking.
            ELSE DO:
                /*IF l-capacidade-ok = NO and
                   l-box-completo  = NO THEN*/
                    GET NEXT q-box-saldo.
            END.
         
            /********************* Chamada EPC *********************/
            IF  C-NOM-PROG-UPC-MG97  <> ""
            or  C-NOM-PROG-APPC-MG97 <> ""
            or  C-NOM-PROG-DPC-MG97  <> "" THEN DO:
               
                 FOR EACH tt-epc
                    WHERE tt-epc.cod-event = "ReplClosedPackage":U:
                    DELETE tt-epc.
                END.
                
                /* Criacao da Temp-Table tt-epc */
                {include/i-epc200.i2 &CodEvent='"ReplClosedPackage"':U
                                     &CodParameter='"Rowid-Box-Movto"':U
                                     &ValueParameter="STRING(ROWID(wm-box-movto))"} 
                
                /* Chamada EPC */
                {include/i-epc201.i "ReplClosedPackage"}
                
                 find first tt-epc
                    WHERE tt-epc.cod-event     = "ReplClosedPackage":U
                    and   tt-epc.cod-parameter = "Return":U no-error.
                 if avail tt-epc then
                    assign l-box-completo = tt-epc.val-parameter = "YES":U.
                                              
            end.
            /******************* Fim Chamada EPC *******************/	

      END.

      IF l-box-completo = YES THEN LEAVE l-aloca. /* Se o endereco estiver completo */

      /*-----  3 - Procura Embalagens abertas com o saldo na Embalagem menor que a qtd original ------*/

      IF l-embalagem-filha THEN
        GET FIRST q-box-saldo-picking.
      ELSE
        GET FIRST q-box-saldo.
      RUN  VerifyCapacityBin IN THIS-PROCEDURE.

      REPEAT WHILE ( AVAIL wm-box-saldo AND l-box-completo = NO  ):

           ASSIGN d-qtd-liberada = wm-box-saldo.qtd-item - wm-box-saldo.qtd-item-bloq.	

            FOR EACH tt-epc
                WHERE tt-epc.cod-event = "Geracao-Ressuprimento-PIA":U:
                DELETE tt-epc.
            END.
	    
            /* Criacao da Temp-Table tt-epc */
            {include/i-epc200.i2 &CodEvent='"Geracao-Ressuprimento-PIA"'
                                 &CodParameter='"Estabel"'
                                 &ValueParameter="wm-box-saldo.cod-estabel"} 
                                 
            /* Criacao da Temp-Table tt-epc */
            {include/i-epc200.i2 &CodEvent='"Geracao-Ressuprimento-PIA"'
                                 &CodParameter='"Local"'
                                 &ValueParameter="wm-box-saldo.cod-local"} 	    

            /* Criacao da Temp-Table tt-epc */
            {include/i-epc200.i2 &CodEvent='"Geracao-Ressuprimento-PIA"'
                                 &CodParameter='"Item-Box-Saldo"'
                                 &ValueParameter="wm-box-saldo.cod-item"} 
                                 
            /* Criacao da Temp-Table tt-epc */
            {include/i-epc200.i2 &CodEvent='"Geracao-Ressuprimento-PIA"'
                                 &CodParameter='"Lote-Box-Saldo"'
                                 &ValueParameter="wm-box-saldo.cod-lote"} 
                                 
            /* Criacao da Temp-Table tt-epc */
            {include/i-epc200.i2 &CodEvent='"Geracao-Ressuprimento-PIA"'
                                 &CodParameter='"IdBox-Saida"'
                                 &ValueParameter="STRING(wm-box-saldo.id-box)"} 
                                 
            /* Criacao da Temp-Table tt-epc */
            {include/i-epc200.i2 &CodEvent='"Geracao-Ressuprimento-PIA"'
                                 &CodParameter='"IdBox-Entrada"'
                                 &ValueParameter="STRING(wm-box-movto.id-box)"} 
                                 
            /* Criacao da Temp-Table tt-epc */
            {include/i-epc200.i2 &CodEvent='"Geracao-Ressuprimento-PIA"'
                                 &CodParameter='"Qtd-Disponivel"'
                                 &ValueParameter="STRING(d-qtd-liberada)"} 
        
            /* Chamada EPC */
            {include/i-epc201.i "Geracao-Ressuprimento-PIA"}
        
            FIND FIRST tt-epc 
                WHERE tt-epc.cod-event     = "Geracao-Ressuprimento-PIA"
                  AND tt-epc.cod-parameter = "next-saldo":U NO-ERROR.
            IF AVAIL tt-epc THEN do:
                  IF l-embalagem-filha THEN DO:
                    GET FIRST q-box-saldo-picking.
                    LEAVE.
                  END.
                  ELSE DO:
                    GET FIRST q-box-saldo.
                    LEAVE.
                  END.
            END.

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
                            RUN getLoteSaldoDisponivel  IN h-proxy124 (OUTPUT l-saldo-disp).
                            RUN getLoteAlocaWMS         IN h-proxy124 (OUTPUT l-aloca-wms).

                            IF l-saldo-disp AND l-aloca-wms THEN
                                ASSIGN l-lote-bloqueado = NO.
                            ELSE
                                ASSIGN l-lote-bloqueado = YES.
                        END.

                        IF VALID-HANDLE(h-proxy124) THEN DO:
                            RUN destroy IN h-proxy124.
                            DELETE OBJECT h-proxy124 NO-ERROR.
                        END.
                    END.

                    /* Se lote bloqueado */
                    IF l-lote-bloqueado THEN DO:
                        IF l-embalagem-filha THEN DO:
                            GET NEXT q-box-saldo-picking.
                            NEXT.
                        END.
                        ELSE DO:
                            GET NEXT q-box-saldo.
                            NEXT.
                        END.
                    END.
                END.
            &ENDIF

            FOR EACH wms-box-sdo-alocad NO-LOCK
               WHERE wms-box-sdo-alocad.cod-estabel  = wm-box-movto.cod-estabel      
                 AND wms-box-sdo-alocad.cod-local    = wm-box-movto.cod-local        
                 AND wms-box-sdo-alocad.cod-item     = wm-box-movto.cod-item         
                 AND wms-box-sdo-alocad.cod-refer    = wm-box-movto.cod-refer        
                 AND wms-box-sdo-alocad.id-docto     = ttWm-docto.id-docto           
                 AND wms-box-sdo-alocad.num-seq-item = ttWm-docto-itens.num-seq-item 
                 AND wms-box-sdo-alocad.id-box       = wm-box-movto.id-box          
                 AND wms-box-sdo-alocad.qtd-alocada  > wms-box-sdo-alocad.qtd-item-retir:

                /******** chamada EPC ********************************************/
                ASSIGN l-continua = YES.
                FOR EACH tt-epc:
                    DELETE tt-epc.
                END.
                {include/i-epc200.i2 &CodEvent='"Verifica-Qtde-Box"'
                                     &CodParameter='"rowid-wm-box-saldo"'
                                     &ValueParameter="string(rowid(wm-box-saldo))"} 
                                     
                {include/i-epc200.i2 &CodEvent='"Verifica-Qtde-Box"'
                                     &CodParameter='"log-proceed"'
                                     &ValueParameter="string(l-continua)"} 
                                     
                {include/i-epc201.i "Verifica-Qtde-Box"}
               
                FIND FIRST tt-epc 
                    WHERE tt-epc.cod-event     = "Verifica-Qtde-Box"
                      AND tt-epc.cod-parameter = "log-proceed":U NO-ERROR.
                IF AVAIL tt-epc THEN do:
                    ASSIGN l-continua = IF  tt-epc.val-parameter = "yes":u THEN YES ELSE NO.
                END.
                /****************************************************************/

                IF  l-continua = YES THEN DO:
                
                    IF NOT l-embalagem-filha THEN DO:

                        ASSIGN de-qtd-ressup = wm-box-saldo.qtd-item - wm-box-saldo.qtd-item-bloq.

                        RUN VerifyCapacityBeforeReplenishment IN THIS-PROCEDURE.

                        IF l-capacidade-res = YES THEN DO:
                            /* tabela para gerar ressuprimento */
                            CREATE ttwm-box-saida-ressup.  
                            ASSIGN ttwm-box-saida-ressup.cod-estabel    = ttWm-docto.cod-estabel                          
                                   ttwm-box-saida-ressup.cod-local      = ttWm-docto.cod-local
                                   ttwm-box-saida-ressup.cod-item       = wm-box-saldo.cod-item
                                   ttwm-box-saida-ressup.cod-refer      = wm-box-saldo.cod-refer
                                   ttwm-box-saida-ressup.cod-lote       = wm-box-saldo.cod-lote
                                   ttwm-box-saida-ressup.dt-transacao   = TODAY
                                   ttwm-box-saida-ressup.id-docto       = ttWm-docto.id-docto
                                   ttwm-box-saida-ressup.num-seq-item   = ttWm-docto-itens.num-seq-item
                                   ttwm-box-saida-ressup.id-saldo       = wm-box-saldo.id-saldo                                                      
                                   ttwm-box-saida-ressup.qtd-saida      = wm-box-saldo.qtd-item - wm-box-saldo.qtd-item-bloq
                                   ttwm-box-saida-ressup.qtd-atendida   = 0
                                   ttwm-box-saida-ressup.qtd-necessaria = 0
                                   ttwm-box-saida-ressup.cod-embalagem  = IF l-embalagem-filha THEN wm-item-picking.cod-emb-area ELSE wm-box-saldo.cod-embalagem
                                   ttwm-box-saida-ressup.cod-cliente    = ttWm-docto-itens.cod-cliente
                                   ttwm-box-saida-ressup.id-ressup      = NEXT-VALUE(id-ressup-wms)
                                   ttwm-box-saida-ressup.id-box         = wm-box-movto.id-box
                                   ttwm-box-saida-ressup.id-box-saida   = wm-box-saldo.id-box
                                   r-rowid                            = ROWID(ttwm-box-saida-ressup).
                                RELEASE ttwm-box-saida-ressup.
                                FIND ttwm-box-saida-ressup WHERE
                                     rowid(ttwm-box-saida-ressup) = r-rowid
                                     NO-LOCK NO-ERROR.
                        END.          
                    END.
                    ELSE DO:
                        IF ((wm-box-saldo.qtd-item - wm-box-saldo.qtd-item-bloq) / d-qtd-item-filha) >= 1 AND
                            l-box-completo = NO THEN DO:
                            DO d-qtd-emb = 1 TO TRUNCATE((wm-box-saldo.qtd-item - wm-box-saldo.qtd-item-bloq) / d-qtd-item-filha, 0):
                                
                                ASSIGN de-qtd-ressup = d-qtd-item-filha.
        
                                RUN VerifyCapacityBeforeReplenishment IN THIS-PROCEDURE.
        
                                IF l-capacidade-res = YES THEN DO:                                
                                    /* tabela para gerar ressuprimento */
                                    CREATE ttwm-box-saida-ressup.  
                                    ASSIGN ttwm-box-saida-ressup.cod-estabel    = ttWm-docto.cod-estabel                          
                                           ttwm-box-saida-ressup.cod-local      = ttWm-docto.cod-local
                                           ttwm-box-saida-ressup.cod-item       = wm-box-saldo.cod-item
                                           ttwm-box-saida-ressup.cod-refer      = wm-box-saldo.cod-refer
                                           ttwm-box-saida-ressup.cod-lote       = wm-box-saldo.cod-lote
                                           ttwm-box-saida-ressup.dt-transacao   = TODAY
                                           ttwm-box-saida-ressup.id-docto       = ttWm-docto.id-docto
                                           ttwm-box-saida-ressup.num-seq-item   = ttWm-docto-itens.num-seq-item
                                           ttwm-box-saida-ressup.id-saldo       = wm-box-saldo.id-saldo                                                      
                                           ttwm-box-saida-ressup.qtd-saida      = d-qtd-item-filha
                                           ttwm-box-saida-ressup.qtd-atendida   = 0
                                           ttwm-box-saida-ressup.qtd-necessaria = 0
                                           ttwm-box-saida-ressup.cod-embalagem  = IF l-embalagem-filha THEN wm-item-picking.cod-emb-area ELSE wm-box-saldo.cod-embalagem
                                           ttwm-box-saida-ressup.cod-cliente    = ttWm-docto-itens.cod-cliente
                                           ttwm-box-saida-ressup.id-ressup      = NEXT-VALUE(id-ressup-wms)
                                           ttwm-box-saida-ressup.id-box         = wm-box-movto.id-box
                                           ttwm-box-saida-ressup.id-box-saida   = wm-box-saldo.id-box
                                           r-rowid                            = ROWID(ttwm-box-saida-ressup).
                                        RELEASE ttwm-box-saida-ressup.
                                        FIND ttwm-box-saida-ressup WHERE
                                             rowid(ttwm-box-saida-ressup) = r-rowid
                                             NO-LOCK NO-ERROR.
    
                                     /*  ASSIGN wm-box-saldo.qtd-pendente  = wm-box-saldo.qtd-pendente  + d-qtd-item-filha
                                           wm-box-saldo.qtd-item-bloq = wm-box-saldo.qtd-item-bloq + d-qtd-item-filha
                                           /*wm-box-saldo.qtd-pendente          = wm-box-saldo.qtd-pendente + d-qtd-item-filha*/
                                           c-lote-aux                         = wm-box-saldo.cod-lote.
    
                                    IF wm-box-saldo.qtd-pendente = wm-box-saldo.qtd-original THEN
                                        ASSIGN /*wm-box-saldo.qtd-item-bloq         = wm-box-saldo.qtd-item*/
                                               wm-box-saldo.ind-status-saldo      = 1   /* Comprometido */.*/
    
                                    RUN VerifyCapacityBin IN THIS-PROCEDURE.
                                    IF l-box-completo = YES THEN LEAVE. /* Se o endereco estiver completo */
                                    ELSE DO:
                                        RUN PermiteEstouroCapacidadeRessuprimento (INPUT ttWm-docto.cod-estabel,
                                                                                   INPUT ttWm-docto.cod-local, 
                                                                                   INPUT wm-box-movto.id-box).
                                        IF l-box-completo = YES THEN LEAVE. /* Se o endereco estiver completo */
                                    END.

                                END.
                            END.
                        END.
                        IF ((wm-box-saldo.qtd-item - wm-box-saldo.qtd-item-bloq) / d-qtd-item-filha) <> INT((wm-box-saldo.qtd-item - wm-box-saldo.qtd-item-bloq) / d-qtd-item-filha) AND
                            NOT l-box-completo THEN DO:

                            ASSIGN de-qtd-ressup = ROUND((((wm-box-saldo.qtd-item - wm-box-saldo.qtd-item-bloq) / d-qtd-item-filha) - TRUNCATE((wm-box-saldo.qtd-item - wm-box-saldo.qtd-item-bloq) / d-qtd-item-filha, 0)) * d-qtd-item-filha,4).
    
                            RUN VerifyCapacityBeforeReplenishment IN THIS-PROCEDURE.
    
                            IF l-capacidade-res = YES THEN DO:
                                /* tabela para gerar ressuprimento */
                                CREATE ttwm-box-saida-ressup.  
                                ASSIGN ttwm-box-saida-ressup.cod-estabel    = ttWm-docto.cod-estabel                          
                                       ttwm-box-saida-ressup.cod-local      = ttWm-docto.cod-local
                                       ttwm-box-saida-ressup.cod-item       = wm-box-saldo.cod-item
                                       ttwm-box-saida-ressup.cod-refer      = wm-box-saldo.cod-refer
                                       ttwm-box-saida-ressup.cod-lote       = wm-box-saldo.cod-lote
                                       ttwm-box-saida-ressup.dt-transacao   = TODAY
                                       ttwm-box-saida-ressup.id-docto       = ttWm-docto.id-docto
                                       ttwm-box-saida-ressup.num-seq-item   = ttWm-docto-itens.num-seq-item
                                       ttwm-box-saida-ressup.id-saldo       = wm-box-saldo.id-saldo                                                      
                                       ttwm-box-saida-ressup.qtd-saida      = ROUND((((wm-box-saldo.qtd-item - wm-box-saldo.qtd-item-bloq) / d-qtd-item-filha) - TRUNCATE((wm-box-saldo.qtd-item - wm-box-saldo.qtd-item-bloq) / d-qtd-item-filha, 0)) * d-qtd-item-filha,4)
                                       ttwm-box-saida-ressup.qtd-atendida   = 0
                                       ttwm-box-saida-ressup.qtd-necessaria = 0
                                       ttwm-box-saida-ressup.cod-embalagem  = IF l-embalagem-filha THEN wm-item-picking.cod-emb-area ELSE wm-box-saldo.cod-embalagem
                                       ttwm-box-saida-ressup.cod-cliente    = ttWm-docto-itens.cod-cliente
                                       ttwm-box-saida-ressup.id-ressup      = NEXT-VALUE(id-ressup-wms)
                                       ttwm-box-saida-ressup.id-box         = wm-box-movto.id-box
                                       ttwm-box-saida-ressup.id-box-saida   = wm-box-saldo.id-box
                                       r-rowid                            = ROWID(ttwm-box-saida-ressup).
                                    RELEASE ttwm-box-saida-ressup.
                                    FIND ttwm-box-saida-ressup WHERE
                                         rowid(ttwm-box-saida-ressup) = r-rowid
                                         NO-LOCK NO-ERROR.
    
                              /*ASSIGN wm-box-saldo.qtd-pendente          = wm-box-saldo.qtd-pendente +  ROUND((((wm-box-saldo.qtd-item - wm-box-saldo.qtd-item-bloq) / d-qtd-item-filha) - TRUNCATE((wm-box-saldo.qtd-item - wm-box-saldo.qtd-item-bloq) / d-qtd-item-filha, 0)) * d-qtd-item-filha,4) /* d-qtd-item-filha */
                                       wm-box-saldo.qtd-item-bloq         = wm-box-saldo.qtd-item-bloq + ROUND((((wm-box-saldo.qtd-item - wm-box-saldo.qtd-item-bloq) / d-qtd-item-filha) - TRUNCATE((wm-box-saldo.qtd-item - wm-box-saldo.qtd-item-bloq) / d-qtd-item-filha, 0)) * d-qtd-item-filha,4) /* d-qtd-item-filha */
                                       c-lote-aux                         = wm-box-saldo.cod-lote.
                                IF wm-box-saldo.qtd-pendente = wm-box-saldo.qtd-original THEN
                                    ASSIGN wm-box-saldo.qtd-item-bloq         = wm-box-saldo.qtd-item
                                           wm-box-saldo.ind-status-saldo      = 1   /* Comprometido */.*/
    
                                RUN VerifyCapacityBin IN THIS-PROCEDURE.
                                IF l-box-completo = YES THEN LEAVE. /* Se o endereco estiver completo */
                                ELSE DO:
                                    RUN PermiteEstouroCapacidadeRessuprimento (INPUT ttWm-docto.cod-estabel,
                                                                               INPUT ttWm-docto.cod-local, 
                                                                               INPUT wm-box-movto.id-box).
                                    IF l-box-completo = YES THEN LEAVE. /* Se o endereco estiver completo */
                                END.

                            END.
                        END.
                    END.
                   /* IF NOT l-embalagem-filha THEN*/

                       /* ASSIGN wm-box-saldo.qtd-pendente          = wm-box-saldo.qtd-pendente + (wm-box-saldo.qtd-item - wm-box-saldo.qtd-item-bloq)
                               wm-box-saldo.qtd-item-bloq         = wm-box-saldo.qtd-item
                               wm-box-saldo.ind-status-saldo      = 1   /* Comprometido */
                               c-lote-aux                         = wm-box-saldo.cod-lote.*/
                END. /* l-continua */
            END.
            IF l-embalagem-filha THEN
                GET NEXT q-box-saldo-picking.
            ELSE
                GET NEXT q-box-saldo.
            RUN  VerifyCapacityBin IN THIS-PROCEDURE.             
            
            /********************* Chamada EPC *********************/
           
            IF  C-NOM-PROG-UPC-MG97  <> ""
            or  C-NOM-PROG-APPC-MG97 <> ""
            or  C-NOM-PROG-DPC-MG97  <> "" THEN DO:

                
                FOR EACH tt-epc
                    WHERE tt-epc.cod-event = "ReplOpenedPackage":U:
                    DELETE tt-epc.
                END.
            
                
                /* Criacao da Temp-Table tt-epc */
                {include/i-epc200.i2 &CodEvent='"ReplOpenedPackage"':U
                                     &CodParameter='"Rowid-Box-Movto"':U
                                     &ValueParameter="STRING(ROWID(wm-box-movto))"} 
                
                /* Chamada EPC */
                {include/i-epc201.i "ReplOpenedPackage"}
                
                 find first tt-epc
                    WHERE tt-epc.cod-event     = "ReplOpenedPackage":U
                    and   tt-epc.cod-parameter = "Return":U no-error.
                if avail tt-epc then
                    assign l-box-completo = tt-epc.val-parameter = "Yes":U.
            END.
           /******************* Fim Chamada EPC *******************/

      END.

      IF l-box-completo = YES THEN LEAVE l-aloca. /* Se o endereco estiver completo */

    END. /* l-aloca */

    RETURN "OK":U.

END PROCEDURE.


PROCEDURE VerifyCapacityBin:
/*
 * Verifica se a capacidade do endereco ja foi atingida
 */

DEF VAR l-ressup             AS LOGICAL                      NO-UNDO.
DEF VAR i-qtd-emb            AS INTEGER                      NO-UNDO.
DEF VAR d-qtd-disp-peso-calc LIKE wm-box.qtd-capacidade-peso NO-UNDO.
DEF VAR d-qtd-disp-ua-calc   LIKE wm-box.qtd-capacidade-ua   NO-UNDO.
DEF VAR de-qtd-peso          AS DEC                          NO-UNDO.
DEF VAR de-qtd-volume        AS DEC                          NO-UNDO.

ASSIGN d-qtd-disp-peso-calc = 0
       d-qtd-disp-ua-calc   = 0
       l-ressup             = NO
       i-qtd-emb            = 0.

&IF '{&bf_wms_alocacao_logica}' = 'YES' &THEN
FOR EACH wms-box-sdo-alocad NO-LOCK
   WHERE wms-box-sdo-alocad.cod-estabel  = wm-box-movto.cod-estabel      
     AND wms-box-sdo-alocad.cod-local    = wm-box-movto.cod-local        
     AND wms-box-sdo-alocad.cod-item     = wm-box-movto.cod-item         
     AND wms-box-sdo-alocad.cod-refer    = wm-box-movto.cod-refer        
     AND wms-box-sdo-alocad.id-docto     = ttWm-docto.id-docto           
     AND wms-box-sdo-alocad.num-seq-item = ttWm-docto-itens.num-seq-item 
     AND wms-box-sdo-alocad.id-box       = wm-box-movto.id-box           
     AND wms-box-sdo-alocad.qtd-alocada  > wms-box-sdo-alocad.qtd-item-retir
    BREAK BY wms-box-sdo-alocad.id-box
          BY wms-box-sdo-alocad.cod-embalagem
          BY wms-box-sdo-alocad.qtd-alocada:

    IF l-embalagem-filha THEN DO:
        FIND FIRST wm-item-embalagem-local NO-LOCK
             WHERE wm-item-embalagem-local.cod-estabel   = wms-box-sdo-alocad.cod-estabel
               AND wm-item-embalagem-local.cod-local     = wms-box-sdo-alocad.cod-local
               AND wm-item-embalagem-local.cod-item      = wms-box-sdo-alocad.cod-item
               AND wm-item-embalagem-local.cod-emb-item  = wms-box-sdo-alocad.cod-embalagem NO-ERROR.
        ASSIGN de-qtd-peso   = wm-item-embalagem-local.qtd-peso-item
               de-qtd-volume = wm-item-embalagem-local.qtd-volume-item.
    END.
    ELSE DO:
        FIND FIRST wm-item-embalagem-local NO-LOCK
             WHERE wm-item-embalagem-local.cod-estabel    = ttwm-box-saida-ressup.cod-estabel
               AND wm-item-embalagem-local.cod-local      = ttwm-box-saida-ressup.cod-local
               AND wm-item-embalagem-local.cod-item       = ttwm-box-saida-ressup.cod-item
               AND wm-item-embalagem-local.cod-embalagem  = ttwm-box-saida-ressup.cod-embalagem NO-ERROR.
        ASSIGN de-qtd-peso   = wm-item-embalagem-local.qtd-peso
               de-qtd-volume = wm-item-embalagem-local.qtd-volume.
    END.

    ASSIGN i-qtd-emb = i-qtd-emb + 1.
    if  last-of(wms-box-sdo-alocad.cod-embalagem) then do :

        ASSIGN d-qtd-disp-peso-calc = d-qtd-disp-peso-calc + ((wm-item-embalagem-local.qtd-peso * i-qtd-emb) + (wm-item.qtd-peso * wms-box-sdo-alocad.qtd-alocada * i-qtd-emb))
               d-qtd-disp-ua-calc   = d-qtd-disp-ua-calc   + (wm-item-embalagem-local.qtd-volume * i-qtd-emb).

        ASSIGN l-ressup  = YES
               i-qtd-emb = 0.

    end.
END.
&ELSE
FOR EACH ttwm-box-saida-ressup NO-LOCK
   WHERE ttwm-box-saida-ressup.cod-estabel  = wm-box-movto.cod-estabel
     AND ttwm-box-saida-ressup.cod-local    = wm-box-movto.cod-local
     AND ttwm-box-saida-ressup.cod-item     = wm-box-movto.cod-item
     AND ttwm-box-saida-ressup.cod-refer    = wm-box-movto.cod-refer
     AND ttwm-box-saida-ressup.id-docto     = ttWm-docto.id-docto
     AND ttwm-box-saida-ressup.num-seq-item = ttWm-docto-itens.num-seq-item
     AND ttwm-box-saida-ressup.id-box       = wm-box-movto.id-box
     AND ttwm-box-saida-ressup.qtd-saida    > ttwm-box-saida-ressup.qtd-atendida
    BREAK BY ttwm-box-saida-ressup.id-box
          BY ttwm-box-saida-ressup.cod-embalagem
          BY ttwm-box-saida-ressup.qtd-saida:

    IF l-embalagem-filha THEN DO:
        FIND FIRST wm-item-embalagem-local NO-LOCK
             WHERE wm-item-embalagem-local.cod-estabel   = ttwm-box-saida-ressup.cod-estabel
               AND wm-item-embalagem-local.cod-local     = ttwm-box-saida-ressup.cod-local
               AND wm-item-embalagem-local.cod-item      = ttwm-box-saida-ressup.cod-item
               AND wm-item-embalagem-local.cod-emb-item  = ttwm-box-saida-ressup.cod-embalagem NO-ERROR.
        ASSIGN de-qtd-peso   = wm-item-embalagem-local.qtd-peso-item
               de-qtd-volume = wm-item-embalagem-local.qtd-volume-item.
    END.
    ELSE DO:
        FIND FIRST wm-item-embalagem-local NO-LOCK
             WHERE wm-item-embalagem-local.cod-estabel    = ttwm-box-saida-ressup.cod-estabel
               AND wm-item-embalagem-local.cod-local      = ttwm-box-saida-ressup.cod-local
               AND wm-item-embalagem-local.cod-item       = ttwm-box-saida-ressup.cod-item
               AND wm-item-embalagem-local.cod-embalagem  = ttwm-box-saida-ressup.cod-embalagem NO-ERROR.
        ASSIGN de-qtd-peso   = wm-item-embalagem-local.qtd-peso
               de-qtd-volume = wm-item-embalagem-local.qtd-volume.
    END.


    ASSIGN i-qtd-emb = i-qtd-emb + 1.

    IF LAST-OF(ttwm-box-saida-ressup.cod-embalagem) THEN DO:
        ASSIGN d-qtd-disp-peso-calc = d-qtd-disp-peso-calc + ((de-qtd-peso * i-qtd-emb) + (wm-item.qtd-peso * ttwm-box-saida-ressup.qtd-saida * i-qtd-emb))
               d-qtd-disp-ua-calc   = d-qtd-disp-ua-calc   + (de-qtd-volume * i-qtd-emb)
               l-ressup             = YES
               i-qtd-emb            = 0.
    END.
END.
&ENDIF
    IF d-qtd-disp-peso - d-qtd-disp-peso-calc <= 0 OR
       d-qtd-disp-ua   - d-qtd-disp-ua-calc   <= 0 THEN DO:
       ASSIGN l-box-completo = YES.
       RETURN "OK":U.
    END.

    FIND FIRST wm-item-embalagem-local NO-LOCK
         WHERE wm-item-embalagem-local.cod-estabel   = wm-box-movto.cod-estabel
           AND wm-item-embalagem-local.cod-local     = wm-box-movto.cod-local
           AND wm-item-embalagem-local.cod-item      = wm-box-movto.cod-item
           AND wm-item-embalagem-local.cod-embalagem = wm-box-movto.cod-embalagem NO-ERROR.
    IF NOT AVAIL wm-item-embalagem-local THEN
        FIND FIRST wm-item-embalagem-local NO-LOCK
             WHERE wm-item-embalagem-local.cod-estabel   = wm-box-movto.cod-estabel
               AND wm-item-embalagem-local.cod-local     = wm-box-movto.cod-local
               AND wm-item-embalagem-local.cod-item      = wm-box-movto.cod-item
               AND wm-item-embalagem-local.cod-emb-item  = wm-box-movto.cod-embalagem NO-ERROR.
    ASSIGN de-qtd-peso   = IF l-embalagem-filha THEN wm-item-embalagem-local.qtd-peso-item
                           ELSE wm-item-embalagem-local.qtd-peso
           de-qtd-volume = IF l-embalagem-filha THEN wm-item-embalagem-local.qtd-volume-item
                           ELSE wm-item-embalagem-local.qtd-volume.
    IF AVAIL wm-item-embalagem-local THEN
        ASSIGN d-qtd-disp-peso-calc = d-qtd-disp-peso-calc + ( de-qtd-peso + ( wm-item.qtd-peso * ( wm-box-movto.qtd-item * - wm-box-movto.qti-embalagem )))
               d-qtd-disp-ua-calc   = d-qtd-disp-ua-calc   + de-qtd-volume.

    IF d-qtd-disp-peso - d-qtd-disp-peso-calc < 0 OR
       d-qtd-disp-ua   - d-qtd-disp-ua-calc   < 0 THEN
        ASSIGN l-capacidade-ok = NO.
    ELSE
        ASSIGN l-capacidade-ok = YES.

    /******** chamada EPC ********************************************/
    FOR EACH tt-epc:
        DELETE tt-epc.
    END.
    {include/i-epc200.i2 &CodEvent='"AfterVerifyCapacityBin"'
                         &CodParameter='"Capacidade-OK"'
                         &ValueParameter="string(l-capacidade-ok)"} 
    {include/i-epc201.i "AfterVerifyCapacityBin"}

    FIND FIRST tt-epc 
         WHERE tt-epc.cod-event = "AfterVerifyCapacityBin"
           AND tt-epc.cod-parameter = "Capacidade-OK":U NO-ERROR.
    IF AVAIL tt-epc THEN DO:
        IF tt-epc.val-parameter = "sim" OR
           tt-epc.val-parameter = "yes" THEN
            ASSIGN l-capacidade-ok = YES.
        ELSE
            ASSIGN l-capacidade-ok = NO.
    END.
    /****************************************************************/

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE makeMovtoItemReplenishment:
/*
 * Cria os movimentos de transferencia (wm-docto/wm-docto-itens/wm-box-movto/wms-box-sdo-alocad/etc.)
 */

    DEF VAR i-qti-embalagem AS INTEGER                 NO-UNDO.
    DEF VAR d-id-movto      LIKE wm-box-movto.id-movto NO-UNDO.
    DEF VAR i-cont          AS INTEGER                 NO-UNDO.
    DEF VAR de-qtd-peso     AS DEC                     NO-UNDO.
    DEF VAR de-qtd-volume   AS DEC                     NO-UNDO.

    ASSIGN i-qti-embalagem = 0.

    /* sa°das do picking */

    FIND FIRST wm-param NO-LOCK NO-ERROR.

    FIND FIRST wm-doca WHERE wm-doca.cod-doca = ttWm-docto-itens.cod-doca NO-LOCK NO-ERROR.

    bloco1:
    FOR EACH ttwm-box-saida-ressup
       WHERE ttwm-box-saida-ressup.cod-estabel  = wm-box-movto.cod-estabel         
         AND ttwm-box-saida-ressup.cod-local    = wm-box-movto.cod-local           
         AND ttwm-box-saida-ressup.cod-item     = wm-box-movto.cod-item            
         AND ttwm-box-saida-ressup.cod-refer    = wm-box-movto.cod-refer           
         AND ttwm-box-saida-ressup.id-docto     = ttWm-docto.id-docto              
         AND ttwm-box-saida-ressup.num-seq-item = ttWm-docto-itens.num-seq-item    
         AND ttwm-box-saida-ressup.id-box       = wm-box-movto.id-box              
         AND ttwm-box-saida-ressup.qtd-saida    > ttwm-box-saida-ressup.qtd-atendida EXCLUSIVE-LOCK,
        EACH wm-box-saldo 
       WHERE wm-box-saldo.cod-estabel = ttwm-box-saida-ressup.cod-estabel
         AND wm-box-saldo.cod-local   = ttwm-box-saida-ressup.cod-local
         AND wm-box-saldo.id-saldo    = ttwm-box-saida-ressup.id-saldo NO-LOCK
       BREAK BY wm-box-saldo.id-box
             BY wm-box-saldo.cod-embalagem
             BY wm-box-saldo.qtd-original
             BY ttwm-box-saida-ressup.qtd-saida
             BY wm-box-saldo.cod-lote:

        FIND FIRST wm-item-embalagem-local NO-LOCK
             WHERE wm-item-embalagem-local.cod-estabel   = wm-box-saldo.cod-estabel
               AND wm-item-embalagem-local.cod-local     = wm-box-saldo.cod-local
               AND wm-item-embalagem-local.cod-item      = wm-box-saldo.cod-item
               AND wm-item-embalagem-local.cod-embalagem = ttwm-box-saida-ressup.cod-embalagem NO-ERROR.

        IF NOT AVAIL wm-item-embalagem-local THEN DO:
            FIND FIRST wm-item-embalagem-local NO-LOCK
                 WHERE wm-item-embalagem-local.cod-estabel   = wm-box-saldo.cod-estabel
                   AND wm-item-embalagem-local.cod-local     = wm-box-saldo.cod-local
                   AND wm-item-embalagem-local.cod-item      = wm-box-saldo.cod-item
                   AND wm-item-embalagem-local.cod-emb-item = ttwm-box-saida-ressup.cod-embalagem NO-ERROR.

            ASSIGN de-qtd-peso   = wm-item-embalagem-local.qtd-peso-item
                   de-qtd-volume = wm-item-embalagem-local.qtd-volume-item.
        END.
        ELSE 
            ASSIGN de-qtd-peso   = wm-item-embalagem-local.qtd-peso
                   de-qtd-volume = wm-item-embalagem-local.qtd-volume.

        IF FIRST-OF(wm-box-saldo.cod-lote) THEN
            ASSIGN d-id-movto      = NEXT-VALUE(id-movto-wms)
                   i-qti-embalagem = 0.

        ASSIGN i-qti-embalagem                = i-qti-embalagem + 1
               ttwm-box-saida-ressup.id-movto = d-id-movto.

        IF LAST-OF(wm-box-saldo.cod-lote) THEN DO:

            /*  movimento entrada */
            CREATE bfwm-box-movto.
            ASSIGN bfwm-box-movto.cod-estabel      = ttwm-docto.cod-estabel
                   bfwm-box-movto.cod-local        = ttwm-docto.cod-local
                   bfwm-box-movto.dt-transacao     = TODAY
                   bfwm-box-movto.id-docto         = ttwm-docto.id-docto
                   bfwm-box-movto.ind-tipo-movto   = 1 /* entrada */
                   bfwm-box-movto.ind-status-movto = 1 /* n∆o iniciado */
                   bfwm-box-movto.num-seq-item     = ttwm-docto-itens.num-seq-item
                   bfwm-box-movto.id-box           = wm-box-movto.id-box
                   bfwm-box-movto.dt-atualizacao   = TODAY
                   bfwm-box-movto.hra-trans        = replace(STRING(TIME,"HH:MM:SS"),":","")
                   bfwm-box-movto.cod-embalagem    = ttwm-box-saida-ressup.cod-embalagem
                   bfwm-box-movto.qtd-item-orig    = wm-box-saldo.qtd-original
                   bfwm-box-movto.qtd-item         = ttwm-box-saida-ressup.qtd-saida
                   bfwm-box-movto.qti-embalagem    = i-qti-embalagem 
                   bfwm-box-movto.id-movto         = d-id-movto
                   bfwm-box-movto.cod-cliente      = wm-box-saldo.cod-cliente
                   bfwm-box-movto.cod-item         = wm-box-saldo.cod-item
                   bfwm-box-movto.cod-refer        = wm-box-saldo.cod-refer
                   bfwm-box-movto.cod-lote         = wm-box-saldo.cod-lote.

            VALIDATE bfwm-box-movto.

            /*  movimento sa°da */
            CREATE bfwm-box-movto.
            ASSIGN bfwm-box-movto.cod-estabel      = ttwm-docto.cod-estabel
                   bfwm-box-movto.cod-local        = ttwm-docto.cod-local
                   bfwm-box-movto.dt-transacao     = TODAY
                   bfwm-box-movto.id-docto         = ttwm-docto.id-docto
                   bfwm-box-movto.ind-tipo-movto   = 2 /* entrada */
                   bfwm-box-movto.ind-status-movto = 1 /* n∆o iniciado */
                   bfwm-box-movto.num-seq-item     = ttwm-docto-itens.num-seq-item
                   bfwm-box-movto.id-box           = wm-box-saldo.id-box
                   bfwm-box-movto.dt-atualizacao   = TODAY
                   bfwm-box-movto.hra-trans        = replace(STRING(TIME,"HH:MM:SS"),":","")
                   bfwm-box-movto.cod-embalagem    = ttwm-box-saida-ressup.cod-embalagem
                   bfwm-box-movto.qtd-item-orig    = wm-box-saldo.qtd-original
                   bfwm-box-movto.qtd-item         = ttwm-box-saida-ressup.qtd-saida
                   bfwm-box-movto.qti-embalagem    = i-qti-embalagem
                   bfwm-box-movto.id-movto         = d-id-movto
                   bfwm-box-movto.cod-cliente      = wm-box-saldo.cod-cliente
                   bfwm-box-movto.cod-item         = wm-box-saldo.cod-item
                   bfwm-box-movto.cod-refer        = wm-box-saldo.cod-refer
                   bfwm-box-movto.cod-lote         = wm-box-saldo.cod-lote.

            VALIDATE bfwm-box-movto.

/*             FIND FIRST wms-box-sdo-alocad EXCLUSIVE-LOCK                                                                                */
/*                  WHERE wms-box-sdo-alocad.cod-estabel   = wm-box-saldo.cod-estabel                                                      */
/*                    AND wms-box-sdo-alocad.cod-local     = wm-box-saldo.cod-local                                                        */
/*                    AND wms-box-sdo-alocad.cod-cliente   = wm-box-saldo.cod-cliente                                                      */
/*                    AND wms-box-sdo-alocad.id-box        = wm-box-saldo.id-box                                                           */
/*                    AND wms-box-sdo-alocad.id-docto      = bfwm-box-movto.id-docto                                                       */
/*                    AND wms-box-sdo-alocad.num-seq-item  = bfwm-box-movto.num-seq-item                                                   */
/*                    AND wms-box-sdo-alocad.cod-item      = wm-box-saldo.cod-item                                                         */
/*                    AND wms-box-sdo-alocad.cod-refer     = wm-box-saldo.cod-refer                                                        */
/*                    AND wms-box-sdo-alocad.cod-lote      = wm-box-saldo.cod-lote                                                         */
/*                    AND wms-box-sdo-alocad.cod-embalagem = wm-box-saldo.cod-embalagem NO-ERROR.                                          */
/*             IF NOT AVAIL wms-box-sdo-alocad THEN DO:                                                                                    */
/*                 CREATE wms-box-sdo-alocad.                                                                                              */
/*                 ASSIGN wms-box-sdo-alocad.cod-estabel   = wm-box-saldo.cod-estabel                                                      */
/*                        wms-box-sdo-alocad.cod-local     = wm-box-saldo.cod-local                                                        */
/*                        wms-box-sdo-alocad.cod-cliente   = wm-box-saldo.cod-cliente                                                      */
/*                        wms-box-sdo-alocad.id-box        = wm-box-saldo.id-box                                                           */
/*                        wms-box-sdo-alocad.id-docto      = bfwm-box-movto.id-docto                                                       */
/*                        wms-box-sdo-alocad.num-seq-item  = bfwm-box-movto.num-seq-item                                                   */
/*                        wms-box-sdo-alocad.cod-item      = wm-box-saldo.cod-item                                                         */
/*                        wms-box-sdo-alocad.cod-refer     = wm-box-saldo.cod-refer                                                        */
/*                        wms-box-sdo-alocad.cod-lote      = wm-box-saldo.cod-lote                                                         */
/*                        wms-box-sdo-alocad.cod-embalagem = wm-box-saldo.cod-embalagem                                                    */
/*                        wms-box-sdo-alocad.qtd-alocada   = 0.                                                                            */
/*             /*END.*/                                                                                                                    */
/*             ASSIGN wms-box-sdo-alocad.qtd-alocada = wms-box-sdo-alocad.qtd-alocada + i-qti-embalagem * ttwm-box-saida-ressup.qtd-saida. */
/*             RELEASE wms-box-sdo-alocad.                                                                                                 */
/*             END.                                                                                                                        */

            DO i-cont = 1 TO i-qti-embalagem:
               /*  criaá∆o do saldo */
               CREATE bfwm-box-saldo.
               ASSIGN bfwm-box-saldo.cod-estabel      = ttwm-docto-itens.cod-estabel
                      bfwm-box-saldo.cod-local        = ttwm-docto-itens.cod-local
                      bfwm-box-saldo.id-docto         = ttwm-docto.id-docto /*ttwm-docto-itens.id-docto*/
                      bfwm-box-saldo.cod-cliente      = ttwm-docto-itens.cod-cliente
                      bfwm-box-saldo.cod-embalagem    = ttwm-box-saida-ressup.cod-embalagem
                      bfwm-box-saldo.cod-item         = ttwm-docto-itens.cod-item
                      bfwm-box-saldo.cod-refer        = ttwm-docto-itens.cod-refer
                      bfwm-box-saldo.cod-lote         = wm-box-saldo.cod-lote
                      bfwm-box-saldo.dt-atua-saldo    = TODAY
                      bfwm-box-saldo.dt-transacao     = TODAY
                      bfwm-box-saldo.id-box           = wm-box-movto.id-box
                      bfwm-box-saldo.id-saldo         = NEXT-VALUE(id-saldo-wms)
                      bfwm-box-saldo.ind-status-box   = 1 /* Normal */
                      bfwm-box-saldo.ind-status-saldo = 2 /* Destinado */
                      bfwm-box-saldo.num-seq-item     = ttwm-docto-itens.num-seq-item
                      bfwm-box-saldo.qtd-item         = ttwm-box-saida-ressup.qtd-saida
                      bfwm-box-saldo.qtd-item-bloq    = 0
                      bfwm-box-saldo.qtd-original     = ttwm-box-saida-ressup.qtd-saida
                      bfwm-box-saldo.id-movto         = d-id-movto.
                VALIDATE bfwm-box-saldo.
            END.

            ASSIGN d-qtd-item = d-qtd-item + ( bfwm-box-movto.qti-embalagem * bfwm-box-movto.qtd-item ).
            FIND CURRENT bfwm-box EXCLUSIVE-LOCK NO-ERROR.

                /*************************************************************************/
                /*** INICIO CHAMADA EPC - Cliente: MOR / Chamado: TETWBS               ***/
                /*************************************************************************/
                if  c-nom-prog-dpc-mg97  <> ""
                or  c-nom-prog-upc-mg97  <> ""
                or  c-nom-prog-appc-mg97 <> "" then do:
                
                    for each tt-epc
                        where tt-epc.cod-event = "ATUALIZA-CAPACIDADE-UA".
                        delete tt-epc.
                    end.
                
                    {include/i-epc200.i2 &CodEvent='"ATUALIZA-CAPACIDADE-UA"'
                                         &CodParameter='"rowid_bfwm-box"'
                                         &ValueParameter="string(rowid(bfwm-box))"}
                                         
                    {include/i-epc200.i2 &CodEvent='"ATUALIZA-CAPACIDADE-UA"'
                                         &CodParameter='"rowid_wm-item-embalagem-local"'
                                         &ValueParameter="string(rowid(wm-item-embalagem-local))"}
                                         
                    {include/i-epc200.i2 &CodEvent='"ATUALIZA-CAPACIDADE-UA"'
                                         &CodParameter='"dec_qtd-item"'
                                         &ValueParameter="string(ttwm-box-saida-ressup.qtd-saida)"}
                                         
                    {include/i-epc201.i "ATUALIZA-CAPACIDADE-UA"}
                
                        
                    IF RETURN-VALUE = "NOK" THEN NEXT.
                end.
                /*************************************************************************/
                /*** FIM CHAMADA EPC - Cliente: MOR / Chamado: TETWBS                  ***/
                /*************************************************************************/

                find first tt-epc 
                    where tt-epc.cod-event     = "ATUALIZA-CAPACIDADE-UA"
                      and tt-epc.cod-parameter = "l-nao-atualiza-variavel" no-error.
                if not avail tt-epc then
                    ASSIGN bfwm-box.qtd-capacidade-ua-util   = bfwm-box.qtd-capacidade-ua-util   + ( de-qtd-volume * i-qti-embalagem).
                    
                ASSIGN bfwm-box.qtd-capacidade-peso-util = bfwm-box.qtd-capacidade-peso-util + ((de-qtd-peso   * i-qti-embalagem) + ( wm-item.qtd-peso * ttwm-box-saida-ressup.qtd-saida * i-qti-embalagem )).
                           

            FIND CURRENT bfwm-box NO-LOCK NO-ERROR.
            ASSIGN i-qti-embalagem = 0.

            /*********************** Gerar a tarefa de ressuprimento *********************/
            IF wm-param.log-gera-tarefa-ressup = YES THEN DO:

                RUN wmp/wm9040.p (INPUT bfwm-box-movto.cod-estabel,
                                  INPUT bfwm-box-movto.cod-local,
                                  INPUT bfwm-box-movto.id-movto,
                                  INPUT 2,
                                  INPUT wm-param.cod-tarefa-ressup,
                                  OUTPUT TABLE RowErrors). /* Ressuprimento */

                IF CAN-FIND(FIRST RowErrors NO-LOCK) THEN
                    UNDO bloco1, RETURN "NOK":U.

                /***** Eliminando Sugest∆o de Equipamento *******/
                /*FOR EACH wm-tarefa-docto-itens WHERE
                    wm-tarefa-docto-itens.id-docto   = bfwm-box-movto.id-docto      AND
                    wm-tarefa-docto-itens.id-movto   = bfwm-box-movto.id-movto      AND
                    wm-tarefa-docto-itens.cod-tarefa = wm-param.cod-tarefa-ressup EXCLUSIVE-LOCK:
                    ASSIGN wm-tarefa-docto-itens.cdn-tipo-equipamento = 0
                           wm-tarefa-docto-itens.cod-equipamento      = "".
                END.*/

                FIND FIRST wm-tarefa-docto-itens EXCLUSIVE-LOCK
                     WHERE wm-tarefa-docto-itens.id-docto   = bfwm-box-movto.id-docto
                       AND wm-tarefa-docto-itens.cod-tarefa = wm-param.cod-tarefa-ressup
                       AND wm-tarefa-docto-itens.id-movto   = bfwm-box-movto.id-movto NO-ERROR.
                IF AVAIL wm-tarefa-docto-itens THEN
                    ASSIGN wm-tarefa-docto-itens.id-movto-orig = wm-box-movto.id-movto.

            END.
            /*****************************************************************************/

            FIND FIRST wm-saldo-estoque EXCLUSIVE-LOCK
                 WHERE wm-saldo-estoque.cod-estabel = wm-box-saldo.cod-estabel
                   AND wm-saldo-estoque.cod-local   = wm-box-saldo.cod-local
                   AND wm-saldo-estoque.cod-cliente = wm-box-saldo.cod-cliente
                   AND wm-saldo-estoque.cod-item    = wm-box-saldo.cod-item
                   AND wm-saldo-estoque.cod-refer   = wm-box-saldo.cod-refer
                   AND wm-saldo-estoque.cod-lote    = wm-box-saldo.cod-lote NO-ERROR.
            IF AVAIL wm-saldo-estoque THEN DO:
                ASSIGN wm-saldo-estoque.qtd-liberada = wm-saldo-estoque.qtd-liberada -(bfwm-box-movto.qtd-item * bfwm-box-movto.qti-embalagem).
                FIND CURRENT wm-saldo-estoque NO-LOCK NO-ERROR.
            END.

            /*******************************
            * Chamada EPC                  *
            *******************************/
            for each tt-epc
                where tt-epc.cod-event = "Replenishment-Sugestion":
                delete tt-epc.
            end.
            create tt-epc.
            assign tt-epc.cod-event     = "Replenishment-Sugestion"
                   tt-epc.cod-parameter = "wm-box-movto-rowid"
                   tt-epc.val-parameter = string(rowid(bfWm-box-movto)).

            {include/i-epc201.i "Replenishment-Sugestion"}
            find first tt-epc where 
                 tt-epc.cod-event     = "Replenishment-Sugestion" and 
                 tt-epc.cod-parameter = "mensagem-erro" no-error.
            if  avail tt-epc then do:
                RUN piCreateError (INPUT 17567,
                                   INPUT tt-epc.val-parameter,
                                   INPUT "EMS",
                                   INPUT "ERROR").
            END.
            ASSIGN l-ressup = YES.
        END.
    END.

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE piCreateError:

    DEFINE INPUT PARAMETER pErrorNumber     AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER pErrorParameters AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pErrorType       AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pErrorSubType    AS CHARACTER NO-UNDO.

    DEFINE VARIABLE i-sequencia AS INTEGER NO-UNDO.

    FIND LAST RowErrors NO-LOCK NO-ERROR.
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

PROCEDURE verifySaldoCompletoDisponivel:

    /**
     * Procedure criada para verificar se existe saldo disponivel no endereco 
     * para efetuar a retirada total da embalagem de armazenamento (wm-box-saldo)
     */

    DEFINE VARIABLE qtd-item-box-disponivel LIKE wm-box-saldo.qtd-item NO-UNDO.

    /* Verifica se existe embalagem fechada disponivel */
    FIND FIRST tt-saldo-aloc NO-LOCK
         WHERE tt-saldo-aloc.cod-estabel   = wm-box-saldo.cod-estabel
           AND tt-saldo-aloc.cod-local     = wm-box-saldo.cod-local
           AND tt-saldo-aloc.cod-cliente   = wm-box-saldo.cod-cliente
           AND tt-saldo-aloc.cod-item      = wm-box-saldo.cod-item
           AND tt-saldo-aloc.cod-refer     = wm-box-saldo.cod-refer
           AND tt-saldo-aloc.cod-lote      = wm-box-saldo.cod-lote
           AND tt-saldo-aloc.cod-embalagem = wm-box-saldo.cod-embalagem
           AND tt-saldo-aloc.id-box        = wm-box-saldo.id-box NO-ERROR.

    IF NOT AVAIL tt-saldo-aloc THEN RETURN 'OK':U. 

    ASSIGN qtd-item-box-disponivel = tt-saldo-aloc.qtd-box - tt-saldo-aloc.qtd-alocada.

    FOR EACH ttwm-box-saida-ressup NO-LOCK
       WHERE ttwm-box-saida-ressup.cod-estabel   = wm-box-saldo.cod-estabel
         AND ttwm-box-saida-ressup.cod-local     = wm-box-saldo.cod-local
         AND ttwm-box-saida-ressup.cod-cliente   = wm-box-saldo.cod-cliente
         AND ttwm-box-saida-ressup.cod-item      = wm-box-saldo.cod-item
         AND ttwm-box-saida-ressup.cod-refer     = wm-box-saldo.cod-refer
         AND ttwm-box-saida-ressup.cod-lote      = wm-box-saldo.cod-lote
         AND ttwm-box-saida-ressup.cod-embalagem = wm-box-saldo.cod-embalagem
         AND ttwm-box-saida-ressup.id-box-saida  = wm-box-saldo.id-box:
        ASSIGN qtd-item-box-disponivel = qtd-item-box-disponivel - ttwm-box-saida-ressup.qtd-saida.
    END.

    /* se a quantidade da embalagem for menor ou igual ao disponivel no endereco */
    IF (wm-box-saldo.qtd-item - wm-box-saldo.qtd-item-bloq) <= qtd-item-box-disponivel THEN
        RETURN 'OK':U.
    ELSE
        RETURN 'NOK':U.

END PROCEDURE.
/*Procedure para verifica a capacidade antes da criaÁ„o da wm-box-saida-ressup*/
PROCEDURE VerifyCapacityBeforeReplenishment:

    DEF VAR l-ressup                AS LOGICAL                          NO-UNDO.
    DEF VAR i-qtd-emb               AS INTEGER                          NO-UNDO.
    DEF VAR d-qtd-disp-peso-calc    LIKE wm-box.qtd-capacidade-peso     NO-UNDO.
    DEF VAR d-qtd-disp-ua-calc      LIKE wm-box.qtd-capacidade-ua       NO-UNDO.
    DEF VAR de-qtd-peso             AS DEC                              NO-UNDO.
    DEF VAR de-qtd-volume           AS DEC                              NO-UNDO.

    ASSIGN d-qtd-disp-peso-calc = 0
           d-qtd-disp-ua-calc   = 0
           l-ressup             = NO
           i-qtd-emb            = 0.



    IF l-embalagem-filha THEN DO:
        FIND FIRST wm-item-embalagem-local WHERE 
             wm-item-embalagem-local.cod-estabel   = ttWm-docto.cod-estabel   AND
             wm-item-embalagem-local.cod-local     = ttWm-docto.cod-local     AND
             wm-item-embalagem-local.cod-item      = wm-box-saldo.cod-item    AND
             wm-item-embalagem-local.cod-emb-item  = wm-item-picking.cod-emb-area
             NO-LOCK NO-ERROR.
        ASSIGN de-qtd-peso-ressup   = wm-item-embalagem-local.qtd-peso-item
               de-qtd-volume-ressup = wm-item-embalagem-local.qtd-volume-item.
    END.
    ELSE DO:
        FIND FIRST wm-item-embalagem-local WHERE 
             wm-item-embalagem-local.cod-estabel    = ttWm-docto.cod-estabel   AND
             wm-item-embalagem-local.cod-local      = ttWm-docto.cod-local     AND
             wm-item-embalagem-local.cod-item       = wm-box-saldo.cod-item    AND
             wm-item-embalagem-local.cod-embalagem  = wm-box-saldo.cod-embalagem 
             NO-LOCK NO-ERROR.
        ASSIGN de-qtd-peso-ressup   = wm-item-embalagem-local.qtd-peso
               de-qtd-volume-ressup = wm-item-embalagem-local.qtd-volume.
    END.

    ASSIGN i-qtd-emb-ressup = i-qtd-emb-ressup + 1.


    ASSIGN d-qtd-disp-peso-calc-ressup = d-qtd-disp-peso-calc-ressup + ((de-qtd-peso-ressup * i-qtd-emb-ressup) + (wm-item.qtd-peso * de-qtd-ressup * i-qtd-emb-ressup))
           d-qtd-disp-ua-calc-ressup   = d-qtd-disp-ua-calc-ressup   + (de-qtd-volume-ressup * i-qtd-emb-ressup).

    IF d-qtd-disp-peso - d-qtd-disp-peso-calc-ressup >= 0 AND
       d-qtd-disp-ua   - d-qtd-disp-ua-calc-ressup   >= 0 THEN DO:

        ASSIGN l-capacidade-res = YES.

        FIND FIRST wms-box-sdo-alocad EXCLUSIVE-LOCK
             WHERE wms-box-sdo-alocad.cod-estabel   = wm-box-saldo.cod-estabel
               AND wms-box-sdo-alocad.cod-local     = wm-box-saldo.cod-local
               AND wms-box-sdo-alocad.cod-cliente   = wm-box-saldo.cod-cliente
               AND wms-box-sdo-alocad.id-box        = wm-box-saldo.id-box
               AND wms-box-sdo-alocad.id-docto      = ttWm-docto.id-docto           
               AND wms-box-sdo-alocad.num-seq-item  = ttWm-docto-itens.num-seq-item 
               AND wms-box-sdo-alocad.cod-item      = wm-box-saldo.cod-item
               AND wms-box-sdo-alocad.cod-refer     = wm-box-saldo.cod-refer
               AND wms-box-sdo-alocad.cod-lote      = wm-box-saldo.cod-lote
               AND wms-box-sdo-alocad.cod-embalagem = wm-box-saldo.cod-embalagem NO-ERROR.
        IF NOT AVAIL wms-box-sdo-alocad THEN DO:
            CREATE wms-box-sdo-alocad.
            ASSIGN wms-box-sdo-alocad.cod-estabel   = ttWm-docto.cod-estabel 
                   wms-box-sdo-alocad.cod-local     = ttWm-docto.cod-local   
                   wms-box-sdo-alocad.cod-cliente   = wm-box-saldo.cod-cliente
                   wms-box-sdo-alocad.id-box        = wm-box-saldo.id-box
                   wms-box-sdo-alocad.id-docto      = ttWm-docto.id-docto
                   wms-box-sdo-alocad.num-seq-item  = ttWm-docto-itens.num-seq-item
                   wms-box-sdo-alocad.cod-item      = wm-box-saldo.cod-item
                   wms-box-sdo-alocad.cod-refer     = wm-box-saldo.cod-refer
                   wms-box-sdo-alocad.cod-lote      = wm-box-saldo.cod-lote
                   wms-box-sdo-alocad.cod-embalagem = wm-box-saldo.cod-embalagem
                   wms-box-sdo-alocad.qtd-alocada   = i-qtd-emb-ressup  * de-qtd-ressup.
            RELEASE wms-box-sdo-alocad.
        END.
        ELSE DO:
            ASSIGN wms-box-sdo-alocad.qtd-alocada = wms-box-sdo-alocad.qtd-alocada + i-qtd-emb-ressup  * de-qtd-ressup.
            RELEASE wms-box-sdo-alocad.
        END.

        ASSIGN d-qtd-disp-peso = d-qtd-disp-peso - d-qtd-disp-peso-calc-ressup
               d-qtd-disp-ua   = d-qtd-disp-ua   - d-qtd-disp-ua-calc-ressup.

    END.
    ELSE DO: 
        ASSIGN l-capacidade-res = NO.
    END.

    ASSIGN i-qtd-emb-ressup            = 0  
           d-qtd-disp-peso-calc-ressup = 0  
           d-qtd-disp-ua-calc-ressup   = 0  
           de-qtd-peso-ressup          = 0  
           de-qtd-volume-ressup        = 0  
           de-qtd-ressup               = 0.  


END PROCEDURE.

PROCEDURE PermiteEstouroCapacidadeRessuprimento:

/*************************************************************************************************
** Verifica se o endereÁo de picking (WM0210a) permite estouro da capacidade de ressuprimento   **
** do endereÁo. Caso afirmativo, pressupoem-se que a capacidade do endereÁo j· esteja completo. **
**************************************************************************************************/

    DEFINE INPUT PARAMETER pcod-estabel like Wm-docto.cod-estabel  no-undo.
    DEFINE INPUT PARAMETER pcod-local   like Wm-docto.cod-local    no-undo.
    DEFINE INPUT PARAMETER pid-box      like wm-box-movto.id-box   no-undo.
    
    IF CAN-FIND(FIRST Wm-box-picking
                WHERE Wm-box-picking.cod-estabel = pcod-estabel
                  AND Wm-box-picking.cod-local   = pcod-local  
                  AND Wm-box-picking.id-box      = pid-box
                  AND Wm-box-picking.log-estoura-capac-ressup) THEN
        ASSIGN l-box-completo = YES.


END PROCEDURE.
