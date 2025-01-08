/*************************************************************************************************************************************************************************
** Copyright PRIME Consultoria (2014)                                                                                                                                   **
** Todos os Direitos Reservados.                                                                                                                                        **
**                                                                                                                                                                      **
** Este fonte Ç de propriedade exclusiva da PRIME Consultoria, sua reproduá∆o parcial ou total por qualquer meio, s¢ poder† ser feita mediante autorizaá∆o expressa     **
**                                                                                                                                                                      **
**************************************************************************************************************************************************************************
** Programa .....: prmapi-docum-est                                                                                                                                     **
** Data .........: Abril de 2018                                                                                                                                        **
** Autor ........: Prime Consultoria                                                                                                                                    **
** Objetivo .....: API para criar nota no RE1001                                                                                                                        **
** Revis‰es **************************************************************************************************************************************************************
** Autor                Ver.    Data        Cliente     Solicitante     Descriá∆o                                                                                       **
** Gabriel Poli         00.002  17/11/2018  CRS         CRS             1) Desenvolvimento inicial do programa                                                          **
**                                                                                                                                                                      **
*************************************************************************************************************************************************************************/
/*--- Variaveis Globais ---*/
{prminc/i-global-integra.i}

{utp/ut-glob.i}
{cdp/cdcfgdis.i}
{cdp/cdcfgmat.i}
{cdp/cdcfgmnt.i} 
{inbo/boin176.i tt-item-doc-est}
{inbo/boin092.i tt-dupli-apagar}
{inbo/boin090.i tt-docum-est}
{inbo/boin176.i2 tt-total-item}
{inbo/boin176.i5 tt-item-terc}
{inbo/boin176.i4 tt-item-devol-cli}
{inbo/boin367.i tt-rat-lote}
{dibo/bodi515.i tt-nota-fisc-adc}
{prmapi/prmapi-docum-est-integrador.i}

DEFINE TEMP-TABLE tt-it-nota-fisc NO-UNDO LIKE it-nota-fisc.

DEFINE TEMP-TABLE tt-docto-estoq-embal NO-UNDO LIKE docto-estoq-embal
   FIELD r-rowid AS ROWID.

DEFINE TEMP-TABLE RowErrors NO-UNDO
    FIELD ErrorSequence    AS INTEGER
    FIELD ErrorNumber      AS INTEGER
    FIELD ErrorDescription AS CHARACTER
    FIELD ErrorParameters  AS CHARACTER
    FIELD ErrorType        AS CHARACTER
    FIELD ErrorHelp        AS CHARACTER
    FIELD ErrorSubType     AS CHARACTER.

DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino            AS INTEGER
    FIELD arquivo            AS CHAR
    FIELD usuario            AS CHAR
    FIELD data-exec          AS DATE
    FIELD hora-exec          AS INTEGER
    FIELD classifica         AS INTEGER
    FIELD c-cod-estabel-ini  AS CHAR
    FIELD c-cod-estabel-fim  AS CHAR
    FIELD i-cod-emitente-ini AS INTEGER
    FIELD i-cod-emitente-fim AS INTEGER
    FIELD c-nro-docto-ini    AS CHAR
    FIELD c-nro-docto-fim    AS CHAR
    FIELD c-serie-docto-ini  AS CHAR
    FIELD c-serie-docto-fim  AS CHAR
    FIELD c-nat-operacao-ini AS CHAR
    FIELD c-nat-operacao-fim AS CHAR
    FIELD da-dt-trans-ini    AS DATE
    FIELD da-dt-trans-fim    AS DATE.   

DEFINE TEMP-TABLE tt-saldo-terc NO-UNDO LIKE saldo-terc.
    
DEFINE TEMP-TABLE tt-digita NO-UNDO
    FIELD r-docum-est        AS ROWID.

DEF TEMP-TABLE tt-raw-digita
   FIELD raw-digita   AS RAW.

DEFINE TEMP-TABLE tt-docum-est-aux    LIKE tt-docum-est.
DEFINE TEMP-TABLE tt-item-doc-est-aux LIKE tt-item-doc-est.
DEFINE TEMP-TABLE tt-item-doc-est-dev LIKE tt-item-doc-est.
DEFINE TEMP-TABLE tt-dupli-apagar-aux LIKE tt-dupli-apagar.
DEFINE TEMP-TABLE tt-rat-lote-aux     LIKE tt-rat-lote.

DEFINE TEMP-TABLE tt-docum-est-eli NO-UNDO LIKE docum-est
    FIELD r-Rowid AS ROWID.
    
DEFINE VARIABLE rw-docum-est-aux AS ROWID       NO-UNDO.
DEFINE VARIABLE rw-docum-est     AS ROWID       NO-UNDO.
DEFINE VARIABLE h-boin090        AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bodi515        AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-boin0815       AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-boin176        AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-desc           AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-tipo-emb       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-sigla-emb      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-volumes        AS INTEGER     NO-UNDO.
DEFINE VARIABLE l-erro           AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-devolucao      AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-item-terc      AS LOGICAL     NO-UNDO.

DEFINE BUFFER b-docum-est             FOR docum-est.
DEFINE BUFFER bf-tt-docto-estoq-embal FOR tt-docto-estoq-embal.

DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-docum-est.
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-item-doc-est.
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-dupli-apagar.
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-rat-lote.
DEFINE OUTPUT PARAMETER TABLE FOR tt-erro.

ASSIGN gl-exibe-json = NO.

IF gl-exibe-json THEN
    MESSAGE 'PRMAPI-DOCUM-EST-DYN.0 '+ STRING(TIME, 'HH:MM:SS').
    
documento:
DO TRANSACTION ON ERROR UNDO, LEAVE:
    
    IF gl-exibe-json THEN
        MESSAGE 'PRMAPI-DOCUM-EST-DYN.1 '+ STRING(TIME, 'HH:MM:SS').
        
    FOR EACH tt-docum-est EXCLUSIVE-LOCK:
        ASSIGN l-erro      = FALSE
               l-item-terc = FALSE.
        
        FIND FIRST natur-oper WHERE natur-oper.nat-operacao = tt-docum-est.nat-operacao NO-LOCK NO-ERROR.
        IF AVAILABLE natur-oper THEN DO:
            IF tt-docum-est.origem = "D" THEN
                ASSIGN l-devolucao         = TRUE
                       i-volumes           = 1
                       tt-docum-est.origem = "I".
            ELSE
                ASSIGN l-devolucao = FALSE.

            IF natur-oper.especie-doc = 'NFT' THEN
                ASSIGN tt-docum-est.origem = "".
            
            IF gl-exibe-json THEN DO:
                MESSAGE 'TT-DOCUM-EST.01 - ' tt-docum-est.origem.
                MESSAGE 'PRMAPI-DOCUM-EST-DYN.1.1 '+ STRING(TIME, 'HH:MM:SS').
            END.

            RUN piCriaDocumento.
            
            IF gl-exibe-json THEN
                MESSAGE 'PRMAPI-DOCUM-EST-DYN.1.1.1 '+ STRING(TIME, 'HH:MM:SS') .

            IF NOT gl-cria-item-re THEN NEXT.

            IF RETURN-VALUE = "OK" THEN DO:

                IF natur-oper.terceiros = TRUE AND (natur-oper.tp-oper-terc = 2 OR 
                                                    natur-oper.tp-oper-terc = 4 OR 
                                                    natur-oper.tp-oper-terc = 5) THEN
                    ASSIGN l-item-terc = TRUE.
                
                IF gl-exibe-json THEN DO:
                    MESSAGE 'PRMAPI-DOCUM-EST-DYN.1.2 '+ STRING(TIME, 'HH:MM:SS') .
                    MESSAGE 'PRMAPI-DOCUM-EST.0 ' STRING(l-devolucao).
                    MESSAGE 'PRMAPI-DOCUM-EST.1 ' STRING(l-item-terc).
                END.

                IF natur-oper.especie-doc <> 'NFT' THEN DO:

                    IF l-devolucao AND NOT l-item-terc THEN DO:
                        FOR EACH tt-item-doc-est.
                            CREATE tt-item-doc-est-dev.
                            BUFFER-COPY tt-item-doc-est TO tt-item-doc-est-dev NO-ERROR.
                            //DELETE tt-item-doc-est.
                        END.
    
                        IF gl-cria-item-dev-re THEN DO:
                            FOR EACH tt-item-doc-est-dev.
                                    
                                IF gl-exibe-json THEN DO:
                                    MESSAGE 'PRMAPI-DOCUM-EST.2 ' STRING(tt-item-doc-est-dev.nro-docto-terc).
                                    MESSAGE 'PRMAPI-DOCUM-EST.3 ' STRING(tt-item-doc-est-dev.serie-terc).
                                    MESSAGE 'PRMAPI-DOCUM-EST.4 ' STRING(tt-item-doc-est-dev.it-codigo).
                                    MESSAGE 'PRMAPI-DOCUM-EST.5 ' STRING(tt-item-doc-est-dev.seq-terc).
                                    MESSAGE 'PRMAPI-DOCUM-EST.5.1 ' STRING(tt-docum-est.cod-estabel).
                                END.
        
                                RUN piCriaItemDocumentoDevolucao(INPUT tt-item-doc-est-dev.nro-docto-terc
                                                                ,INPUT tt-item-doc-est-dev.serie-terc
                                                                ,INPUT tt-docum-est.cod-estabel
                                                                ,INPUT tt-item-doc-est-dev.it-codigo
                                                                ,INPUT tt-item-doc-est-dev.seq-terc).

                            END.
    
                            IF gl-exibe-json THEN DO:
                                MESSAGE 'PRMAPI-DOCUM-EST.6 ' RETURN-VALUE.
                            END.
                            IF gl-atualiza-re1001 THEN DO:
                                IF RETURN-VALUE <> "OK" THEN DO:
                                    RUN deleteRecord IN h-boin090.
                                    ASSIGN l-erro = TRUE.
                                    LEAVE.
                                END.
                            END.
    
                        END.
                    END.

                    IF natur-oper.terceiros = TRUE AND (natur-oper.tp-oper-terc = 2 OR 
                                                        natur-oper.tp-oper-terc = 4 OR 
                                                        natur-oper.tp-oper-terc = 5) THEN DO: /*Bot∆o Gerar por Item RE1001*/
                        IF gl-cria-item-terc-re THEN DO:
                            FOR EACH tt-item-doc-est OF tt-docum-est NO-LOCK:
                                IF gl-exibe-json THEN
                                    MESSAGE 'PRMAPI-DOCUM-EST-DYN.GERAR-POR-ITEM.1'.

                                RUN gerarPorItem.

                                IF gl-exibe-json THEN
                                    MESSAGE 'PRMAPI-DOCUM-EST-DYN.GERAR-POR-ITEM.2 ' + RETURN-VALUE.
                
                                IF RETURN-VALUE <> "OK" THEN DO:
                                    ASSIGN l-erro = TRUE.
                                    LEAVE.
                                END.

/*                                 FOR EACH tt-rat-lote OF tt-item-doc-est NO-LOCK: */
/*                                     RUN criarLoteItem.                           */
/*                                                                                  */
/*                                     IF RETURN-VALUE <> "OK" THEN DO:             */
/*                                         ASSIGN l-erro = TRUE.                    */
/*                                         LEAVE.                                   */
/*                                     END.                                         */
/*                                 END.                                             */

                            END.
                        END.
                    END.
                    ELSE DO: /*Bot∆o Item RE1001*/
                        FOR EACH tt-item-doc-est OF tt-docum-est NO-LOCK:
                            ASSIGN l-erro = FALSE.
                        
                            IF NOT VALID-HANDLE(h-boin176) THEN DO:
                                RUN inbo/boin176.p PERSISTENT SET h-boin176.
                                RUN openQueryStatic IN h-boin176(INPUT "Main":U).
                            END.
                            
                            IF gl-cria-item-re THEN DO:
                                IF NOT l-devolucao THEN
                                    RUN criarItemDocumento.
                            END.
                            
                            IF gl-exibe-json THEN DO:
                                MESSAGE "RETURN-VALUE AP‡S criarItemDocumento " + STRING(RETURN-VALUE).
                            END.

                            IF RETURN-VALUE = "OK" THEN DO:
                                FOR EACH tt-rat-lote
                                   WHERE tt-rat-lote.serie-docto  = tt-item-doc-est.serie-docto
                                     AND INT(tt-rat-lote.nro-docto)    = INT(tt-item-doc-est.nro-docto)
                                     AND tt-rat-lote.cod-emitente = tt-item-doc-est.cod-emitente
                                     AND tt-rat-lote.nat-operacao = tt-item-doc-est.nat-operacao
                                     AND tt-rat-lote.sequencia    = tt-item-doc-est.sequencia:

                                    ASSIGN tt-rat-lote.nro-docto = tt-item-doc-est.nro-docto.
    
                                    IF NOT l-devolucao THEN
                                        RUN criarLoteItem.
    
                                    IF RETURN-VALUE <> "OK" THEN DO:
                                        ASSIGN l-erro = TRUE.
                                        LEAVE.
                                    END.
                                END.
                            END.
                            ELSE DO:
                                ASSIGN l-erro = TRUE.
                            END.
    
                            /*IF VALID-HANDLE(h-boin176) THEN DO:
                                DELETE PROCEDURE h-boin176.
                                ASSIGN h-boin176 = ?.
                            END.*/
    
                            IF l-erro = TRUE THEN
                                LEAVE.
                        END. 
                    END.
        
                END. //NFT
                ELSE DO:
                    FOR EACH tt-rat-lote OF tt-item-doc-est NO-LOCK:
                        RUN criarLoteItem.

                        IF RETURN-VALUE <> "OK" THEN DO:
                            ASSIGN l-erro = TRUE.
                            LEAVE.
                        END.
                    END.
                END.
                
                IF gl-exibe-json THEN DO:
                    MESSAGE 'PRMAPI-DOCUM-EST.20 - ' STRING(l-erro).
                    MESSAGE 'PRMAPI-DOCUM-EST-DYN.1.3 '+ STRING(TIME, 'HH:MM:SS').
                END.
                
                IF NOT gl-cria-duplic THEN NEXT.

                IF l-erro = FALSE THEN DO:
                    FOR EACH tt-dupli-apagar OF tt-docum-est:
                        RUN criarDuplicatas.
    
                        IF RETURN-VALUE <> "OK" THEN DO:
                            ASSIGN l-erro = TRUE.
                            LEAVE.
                        END.
                    END.
                END.
                
                IF gl-exibe-json THEN
                    MESSAGE 'PRMAPI-DOCUM-EST-DYN.1.4 '+ STRING(TIME, 'HH:MM:SS').
                    
                IF l-erro = TRUE THEN DO:
                    IF gl-atualiza-re1001 THEN
                        RUN deleteRecord IN h-boin090.
                END.
                ELSE DO:
                    ASSIGN tt-docum-est.r-Rowid = rw-docum-est.
                    /*RUN atualizarDocumento(INPUT rw-docum-est).*/
                    /*RUN atualizaDocumento IN h-boin090.*/
                    FIND FIRST docum-est NO-LOCK
                         WHERE ROWID(docum-est) = rw-docum-est NO-ERROR.
                    IF AVAIL docum-est THEN DO:
                        FOR EACH item-doc-est OF docum-est NO-LOCK:
                            FIND FIRST tt-item-doc-est 
                                 WHERE tt-item-doc-est.it-codigo = item-doc-est.it-codigo
                                   AND tt-item-doc-est.sequencia = item-doc-est.sequencia NO-ERROR.
                            IF AVAIL tt-item-doc-est THEN DO:
                                FIND CURRENT item-doc-est EXCLUSIVE-LOCK NO-ERROR.
                                ASSIGN item-doc-est.aliquota-icm         = tt-item-doc-est.aliquota-icm
                                       item-doc-est.base-icm             = tt-item-doc-est.base-icm    
                                       item-doc-est.valor-icm            = tt-item-doc-est.valor-icm
                                       item-doc-est.base-ipi             = tt-item-doc-est.base-ipi
                                       item-doc-est.ipi-outras           = tt-item-doc-est.ipi-outras
                                       item-doc-est.preco-unit           = tt-item-doc-est.preco-unit
                                       item-doc-est.preco-total          = tt-item-doc-est.preco-total
                                       item-doc-est.base-pis             = tt-item-doc-est.base-pis            
                                       item-doc-est.valor-pis            = tt-item-doc-est.valor-pis           
                                       item-doc-est.val-base-calc-cofins = tt-item-doc-est.val-base-calc-cofins
                                       item-doc-est.val-cofins           = tt-item-doc-est.val-cofins 
                                       item-doc-est.base-subs            = tt-item-doc-est.base-subs
                                       item-doc-est.vl-subs              = tt-item-doc-est.vl-subs.
                                FIND CURRENT item-doc-est NO-LOCK NO-ERROR.
                            END.
                        END.
                    END.

                    FIND FIRST docum-est EXCLUSIVE-LOCK
                         WHERE ROWID(docum-est) = rw-docum-est NO-ERROR.
                    IF AVAIL docum-est THEN DO:
                    
                        FIND FIRST item-doc-est OF docum-est NO-LOCK NO-ERROR.
                        
                        IF AVAIL(item-doc-est) //AND l-devolucao 
                            THEN DO:

                            IF NOT VALID-HANDLE(h-boin176) THEN DO:
                                RUN inbo/boin176.p PERSISTENT SET h-boin176.
                                RUN openQueryStatic IN h-boin176(INPUT "Main":U).
                            END.

                            /*---- Recalcula Valores ---*/
                            EMPTY TEMP-TABLE tt-total-item.
                            RUN calculateTotalItem IN h-boin176 (INPUT item-doc-est.cod-emitente,
                                                                 INPUT item-doc-est.serie-docto,
                                                                 INPUT item-doc-est.nro-docto,
                                                                 INPUT item-doc-est.nat-of,
                                                                 OUTPUT TABLE tt-total-item).
                    
                            FIND FIRST tt-total-item NO-LOCK NO-ERROR.
                            IF AVAIL tt-total-item THEN DO:
                        
                                FIND FIRST b-docum-est OF item-doc-est EXCLUSIVE-LOCK NO-ERROR.
                                IF AVAIL b-docum-est THEN DO:
                                    
                                    /*--- TOTAL I ---*/
                                    ASSIGN b-docum-est.base-iss         = tt-total-item.base-iss
                                           b-docum-est.iss-deb-cre      = tt-total-item.valor-iss
                                           b-docum-est.base-subs        = tt-total-item.base-subs
                                           b-docum-est.vl-subs          = tt-total-item.valor-subs
                                           b-docum-est.peso-bruto-tot   = tt-total-item.peso-bruto-tot
                                           b-docum-est.icm-complem      = tt-total-item.icm-complem
                                           b-docum-est.vl-pis-sub       = tt-total-item.total-pis-subst 
                                           b-docum-est.vl-cofins-sub    = tt-total-item.total-cofins-subs.
                                    
                                    /*--- TOTAL II ---*/
                                    ASSIGN b-docum-est.tot-peso         = tt-total-item.tot-peso
                                           b-docum-est.tot-desconto     = tt-total-item.tot-desconto
                                           b-docum-est.despesa-nota     = tt-total-item.despesa-nota
                                           b-docum-est.valor-mercad     = tt-total-item.valor-mercad
                                           b-docum-est.base-ipi         = tt-total-item.base-ipi
                                           b-docum-est.ipi-deb-cre      = tt-total-item.valor-ipi
                                           b-docum-est.base-icm         = tt-total-item.base-icm
                                           b-docum-est.icm-deb-cre      = tt-total-item.valor-icm.
                    
                                    IF tt-total-item.de-tot-valor-calc > 0 THEN
                                        ASSIGN b-docum-est.tot-valor        = tt-total-item.de-tot-valor-calc.
                                END.
                            END.
                        END.
                    END.

                END.
            END.
            IF VALID-HANDLE(h-boin176) THEN DO:
                DELETE PROCEDURE h-boin176.
                ASSIGN h-boin176 = ?.
            END.
            
            IF gl-exibe-json THEN
                MESSAGE 'PRMAPI-DOCUM-EST-DYN.1.5 '+ STRING(TIME, 'HH:MM:SS') .
        END.
        ELSE DO:
            RUN pi-cria-erro(INPUT tt-docum-est.cod-emitente, 
                             INPUT tt-docum-est.serie-docto,  
                             INPUT tt-docum-est.nro-docto,    
                             INPUT tt-docum-est.nat-operacao, 
                             INPUT 0,
                             INPUT 0,
                             INPUT "Documento: " + tt-docum-est.nro-docto + " - " + "Natureza de operaá∆o " + tt-docum-est.nat-operacao + " n∆o encontrada",
                             INPUT "Verifique o cadastro de natureza de operaá∆o(CD0606)").
            IF gl-atualiza-re1001 THEN
                RUN deleteRecord IN h-boin090.
            ASSIGN l-erro = TRUE.
            DELETE PROCEDURE h-boin090.
            LEAVE.
        END.

        //Valida se os itens foram criados
        FIND FIRST docum-est NO-LOCK
             WHERE ROWID(docum-est) = tt-docum-est.r-Rowid NO-ERROR.

        
        FIND FIRST prm-projeto-integrador NO-LOCK NO-ERROR.
        IF AVAIL prm-projeto-integrador THEN DO:
            FOR EACH item-doc-est OF docum-est:
                IF NOT l-devolucao THEN DO:
                    FIND FIRST tt-item-doc-est WHERE tt-item-doc-est.it-codigo = item-doc-est.it-codigo NO-ERROR.
                    IF AVAIL tt-item-doc-est THEN
                        ASSIGN item-doc-est.cod-depos            = tt-item-doc-est.cod-depos.
                    //ASSIGN item-doc-est.cod-depos = prm-projeto-integrador.cod-depos.
                    FOR EACH rat-lote
                        WHERE rat-lote.cod-emitente = docum-est.cod-emitente
                          AND rat-lote.serie-docto  = docum-est.serie-docto
                          AND rat-lote.nro-docto    = docum-est.nro-docto
                          AND rat-lote.nat-operacao = docum-est.nat-operacao
                          AND rat-lote.tipo-nota    = docum-est.tipo-nota
                          AND rat-lote.sequencia    = item-doc-est.sequencia
                          AND rat-lote.it-codigo    = item-doc-est.it-codigo:
    
                        IF AVAIL tt-item-doc-est THEN
                            ASSIGN rat-lote.cod-depos = tt-item-doc-est.cod-depos.
                        //ASSIGN rat-lote.cod-depos = prm-projeto-integrador.cod-depos.
                    END.
                END.
                ELSE DO:
                    FIND FIRST tt-item-doc-est WHERE tt-item-doc-est.it-codigo = item-doc-est.it-codigo NO-ERROR.
                    IF AVAIL tt-item-doc-est THEN
                        ASSIGN item-doc-est.base-pis             = tt-item-doc-est.base-pis
                               item-doc-est.valor-pis            = tt-item-doc-est.valor-pis
                               item-doc-est.val-base-calc-cofins = tt-item-doc-est.val-base-calc-cofins
                               item-doc-est.val-cofins           = tt-item-doc-est.val-cofins
                               item-doc-est.base-subs[1]         = tt-item-doc-est.base-subs[1]
                               item-doc-est.vl-subs[1]           = tt-item-doc-est.vl-subs[1].
                END.                           
            END.
        END.
        
        IF gl-exibe-json THEN
            MESSAGE 'PRMAPI-DOCUM-EST-DYN.1.6 '+ STRING(TIME, 'HH:MM:SS') .
            
        IF NOT AVAIL docum-est THEN DO:
            RUN pi-cria-erro(INPUT tt-docum-est.cod-emitente, 
                             INPUT tt-docum-est.serie-docto,  
                             INPUT tt-docum-est.nro-docto,    
                             INPUT tt-docum-est.nat-operacao, 
                             INPUT 0,
                             INPUT 0,
                             INPUT "Documento n∆o criado.",
                             INPUT "Verifique os dados enviados").

            ASSIGN l-erro = TRUE.
            DELETE PROCEDURE h-boin090.
            LEAVE.
        END.

        FIND FIRST item-doc-est OF docum-est NO-LOCK NO-ERROR.

        IF NOT AVAIL item-doc-est THEN DO:
            IF gl-atualiza-re1001 THEN
                RUN deleteRecord IN h-boin090.
            RUN pi-cria-erro(INPUT tt-docum-est.cod-emitente, 
                             INPUT tt-docum-est.serie-docto,  
                             INPUT tt-docum-est.nro-docto,    
                             INPUT tt-docum-est.nat-operacao, 
                             INPUT 0,
                             INPUT 0,
                             INPUT "Itens do Documento n∆o criados.",
                             INPUT "Verifique os dados enviados").

            ASSIGN l-erro = TRUE.
            DELETE PROCEDURE h-boin090.
            LEAVE.
        END.
    END.
    
    IF gl-exibe-json THEN
        MESSAGE 'PRMAPI-DOCUM-EST-DYN.2 '+ STRING(TIME, 'HH:MM:SS') .
END.

/*------------------------------------------------------------------------------------------------------------*/
PROCEDURE criarDuplicatas:
    DEFINE VARIABLE h-boin092       AS HANDLE      NO-UNDO.
    DEFINE VARIABLE rw-dupli-apagar AS ROWID       NO-UNDO.

    EMPTY TEMP-TABLE RowErrors.
    RUN inbo/boin092.p PERSISTENT SET h-boin092.

    EMPTY TEMP-TABLE tt-dupli-apagar-aux.

    CREATE tt-dupli-apagar-aux.
    BUFFER-COPY tt-dupli-apagar TO tt-dupli-apagar-aux.
    
    RUN openQueryStatic IN h-boin092 (INPUT "Main").
    RUN validateCreate IN h-boin092(INPUT TABLE tt-dupli-apagar-aux,
                                    OUTPUT TABLE RowErrors,
                                    OUTPUT rw-dupli-apagar).

    DELETE PROCEDURE h-boin092.

    FOR EACH RowErrors NO-LOCK:
        RUN pi-cria-erro(INPUT tt-docum-est.cod-emitente, 
                         INPUT tt-docum-est.serie-docto,  
                         INPUT tt-docum-est.nro-docto,    
                         INPUT tt-docum-est.nat-operacao, 
                         INPUT RowErrors.ErrorSequence,
                         INPUT RowErrors.ErrorNumber,
                         INPUT "Duplicata: " + tt-dupli-apagar.parcela + " - " + RowErrors.ErrorDescription,
                         INPUT RowErrors.ErrorHelp).
        IF RowErrors.ErrorSubType = "ERROR" THEN
            ASSIGN l-erro = TRUE.
    END.

    IF l-erro = TRUE THEN
        RETURN "NOK".

    RETURN "OK".
END PROCEDURE.

/*------------------------------------------------------------------------------------------------------------*/
PROCEDURE piCriaDocumento:
    /*Cabecalho Documento*/
    EMPTY TEMP-TABLE tt-docum-est-aux.

    CREATE tt-docum-est-aux.
    BUFFER-COPY tt-docum-est TO tt-docum-est-aux.

    RUN inbo/boin090.p PERSISTENT SET h-boin090.       
    RUN openQueryStatic IN h-boin090(INPUT "Main":U).
    RUN emptyRowErrors IN h-boin090.
    RUN setRecord IN h-boin090(INPUT TABLE tt-docum-est-aux).
    RUN createRecord IN h-boin090.
    RUN getRowErrors IN h-boin090(OUTPUT TABLE RowErrors).

    FOR EACH RowErrors:

        IF gl-exibe-json THEN DO:
            MESSAGE 'PICRIADOCUMENTO.0 - ' STRING(RowErrors.ErrorNumber).
            MESSAGE 'PICRIADOCUMENTO.0 - ' STRING(RowErrors.ErrorDescription).
            MESSAGE 'PICRIADOCUMENTO.0 - ' STRING(RowErrors.ErrorHelp).
        END.


        RUN pi-cria-erro(INPUT tt-docum-est.cod-emitente, 
                         INPUT tt-docum-est.serie-docto,  
                         INPUT tt-docum-est.nro-docto,    
                         INPUT tt-docum-est.nat-operacao, 
                         INPUT RowErrors.ErrorSequence,
                         INPUT RowErrors.ErrorNumber,
                         INPUT "Documento: " + tt-docum-est.nro-docto + " - " + RowErrors.ErrorDescription,
                         INPUT RowErrors.ErrorHelp).

        IF RowErrors.ErrorSubType = "Error" THEN
            ASSIGN l-erro = TRUE.
    END.
    RUN emptyRowErrors IN h-boin090.
    EMPTY TEMP-TABLE rowerrors.

    IF l-erro = TRUE THEN DO:

        IF gl-exibe-json THEN DO:
            MESSAGE "ERRO piCriaDocumento".
        END.

        RETURN "NOK".
    END.

    RUN getRowId IN h-boin090(OUTPUT rw-docum-est).
    FIND FIRST docum-est WHERE ROWID(docum-est) = rw-docum-est NO-LOCK NO-ERROR.

    FOR EACH tt-item-doc-est OF tt-docum-est:
        ASSIGN tt-item-doc-est.nro-docto = docum-est.nro-docto.
    END.

    FOR EACH tt-dupli-apagar OF tt-docum-est:
        ASSIGN tt-dupli-apagar.nro-docto = docum-est.nro-docto.
    END.

    ASSIGN tt-docum-est.nro-docto = docum-est.nro-docto.

    RETURN "OK".
    /*-----------------------------------*/
END PROCEDURE.

/*------------------------------------------------------------------------------------------------------------*/
PROCEDURE criarItemDocumento:
    DO ON ERROR UNDO, LEAVE:
        EMPTY TEMP-TABLE tt-item-doc-est-aux.

        CREATE tt-item-doc-est-aux.
        BUFFER-COPY tt-item-doc-est TO tt-item-doc-est-aux.

        RUN setHandleDocumEst IN h-boin176(INPUT h-boin090).
        RUN setDocumEst IN h-boin176.
        RUN setRecord IN h-boin176(INPUT TABLE tt-item-doc-est-aux).
        RUN createRecord IN h-boin176.
        RUN getRowErrors IN h-boin176(OUTPUT TABLE RowErrors).
        
        IF CAN-FIND(FIRST RowErrors) THEN DO:
            FOR EACH RowErrors /*WHERE RowErrors.ErrorSubType = "Error"*/ NO-LOCK:
                RUN pi-cria-erro(INPUT tt-docum-est.cod-emitente, 
                                 INPUT tt-docum-est.serie-docto,  
                                 INPUT tt-docum-est.nro-docto,    
                                 INPUT tt-docum-est.nat-operacao, 
                                 INPUT RowErrors.ErrorSequence,
                                 INPUT RowErrors.ErrorNumber,
                                 INPUT "Item: " + tt-item-doc-est.it-codigo + " - " + RowErrors.ErrorDescription,
                                 INPUT RowErrors.ErrorHelp).
                IF RowErrors.ErrorSubType = "Error" THEN
                    ASSIGN l-erro = TRUE.
            END.
    
            IF l-erro = TRUE THEN DO:
                IF gl-exibe-json THEN DO:
                    MESSAGE "ERRO criarItemDocumento-1".
                END.

                RETURN "NOK".
            END.
                
        END.

        RUN TransferTotalItensNota IN h-boin176(INPUT tt-docum-est.cod-emitente,
                                                INPUT tt-docum-est.serie,
                                                INPUT tt-docum-est.nro-docto,
                                                INPUT tt-docum-est.nat-operacao).

        IF l-erro = TRUE THEN DO:
            IF gl-exibe-json THEN DO:
                MESSAGE "ERRO criarItemDocumento-2".
            END.

            RETURN "NOK".
        END.

        RETURN "OK":U.

        CATCH oneError AS Progress.Lang.AppError:
            IF gl-exibe-json THEN DO:
                MESSAGE "ERRO criarItemDocumento-3".
            END.
            
            RETURN "NOK".
        END CATCH.
    END.
END PROCEDURE.

/*------------------------------------------------------------------------------------------------------------*/
PROCEDURE gerarPorItem:
    DEFINE VARIABLE c-retorno AS CHARACTER   NO-UNDO.

    IF NOT VALID-HANDLE(h-boin176) THEN
        RUN inbo/boin176.p PERSISTENT SET h-boin176.

    RUN openQueryStatic IN h-boin176(INPUT "Main":U ).

    RUN validateDados.
    ASSIGN c-retorno = RETURN-VALUE.

    IF VALID-HANDLE(h-boin176) THEN DO:
        DELETE PROCEDURE h-boin176.
        ASSIGN h-boin176 = ?.
    END.

    RETURN c-retorno.
END PROCEDURE.

/*------------------------------------------------------------------------------------------------------------*/
PROCEDURE validateDados:
    /*------------------------------------------------------------------------------
    Notes: Consiste os dados digitados, sendo que n∆o ocorrendo erro ser† gerado os
         itens da nota de retorno de terceiros.
    ------------------------------------------------------------------------------*/
    DEFINE VARIABLE h-re1001j1 AS HANDLE NO-UNDO.

    IF NOT VALID-HANDLE( h-boin090 ) THEN
        RETURN "NOK":U.

    /*--- reposiciona a BO de docum-est ---*/
    RUN repositionRecord IN h-boin090(INPUT rw-docum-est).

    /*--- limpa a temp-table de erros antes da consistància ---*/
    RUN emptyRowErrors IN h-boin090.

    /*--- consiste os dados digitados em tela ---*/
    RUN consistNotaTerceiros IN h-boin090(INPUT tt-item-doc-est.serie-terc,
                                          INPUT tt-item-doc-est.nro-docto-terc,
                                          INPUT tt-item-doc-est.nat-terc,
                                          INPUT tt-docum-est.dt-emissao).

    IF gl-exibe-json THEN DO:
        MESSAGE 'DEBUG-PRMAPI-DOCUM-EST - VALIDATEDADOS - ' tt-item-doc-est.serie-terc      .
        MESSAGE 'DEBUG-PRMAPI-DOCUM-EST - VALIDATEDADOS - ' tt-item-doc-est.nro-docto-terc  .
        MESSAGE 'DEBUG-PRMAPI-DOCUM-EST - VALIDATEDADOS - ' tt-item-doc-est.nat-terc        .
        MESSAGE 'DEBUG-PRMAPI-DOCUM-EST - VALIDATEDADOS - ' tt-docum-est.dt-emissao         .
    END.

    /*--- Verifica a existencia de erros ---*/
    RUN getRowErrors IN h-boin090(OUTPUT TABLE rowErrors ).
    
    IF gl-exibe-json THEN DO:
        FIND FIRST rowErrors NO-LOCK NO-ERROR.
        MESSAGE 'DEBUG-PRMAPI-DOCUM-EST - VALIDATEDADOS - ' AVAIL rowErrors         .
        IF AVAIL rowErrors THEN
            MESSAGE 'DEBUG-PRMAPI-DOCUM-EST - VALIDATEDADOS ERRO - ' RowErrors.ErrorHelp   .
    END.
    
    IF CAN-FIND(FIRST rowErrors ) THEN DO:
        FOR EACH RowErrors NO-LOCK:
            RUN pi-cria-erro(INPUT tt-docum-est.cod-emitente,
                             INPUT tt-docum-est.serie-docto,
                             INPUT tt-docum-est.nro-docto,
                             INPUT tt-docum-est.nat-operacao,
                             INPUT RowErrors.ErrorSequence,
                             INPUT RowErrors.ErrorNumber,
                             INPUT "Valida Dados: " + tt-docum-est.nro-docto + " - " + RowErrors.ErrorDescription,
                             INPUT RowErrors.ErrorHelp).
            IF RowErrors.ErrorSubType = "ERROR" THEN
                ASSIGN l-erro = TRUE.
        END.
        RETURN "NOK":U.
    END.
    ELSE DO:
        RUN cria-tt-item-terc.
        IF RETURN-VALUE = "NOK":U THEN
            RETURN "NOK":U.
    END.

    RETURN "OK":U.
END PROCEDURE.

/*------------------------------------------------------------------------------------------------------------*/
PROCEDURE cria-tt-item-terc:
    DEFINE VARIABLE h-boin404 AS HANDLE     NO-UNDO.
    DEFINE VARIABLE d-qtd     AS DECIMAL    NO-UNDO.

    EMPTY TEMP-TABLE tt-item-terc.
    EMPTY TEMP-TABLE tt-saldo-terc.

    IF NOT VALID-HANDLE(h-boin404) THEN
        RUN inbo/boin404.p PERSISTENT SET h-boin404.

    /*RUN piRetornaValor(OUTPUT d-qtd).*/
    ASSIGN d-qtd = tt-item-doc-est.quantidade.

    IF VALID-HANDLE(h-boin404) THEN
        RUN validadettItemTerc IN h-boin404 (INPUT tt-item-doc-est.serie-terc,
                                             INPUT tt-item-doc-est.nro-docto-terc,
                                             INPUT tt-item-doc-est.nat-terc,
                                             INPUT tt-docum-est.cod-emitente,
                                             INPUT tt-item-doc-est.it-codigo,
                                             INPUT tt-item-doc-est.seq-terc,
                                             INPUT d-qtd,
                                             INPUT tt-docum-est.nat-operacao ,
                                             OUTPUT TABLE tt-item-terc,
                                             OUTPUT TABLE tt-saldo-terc,
                                             OUTPUT TABLE rowErrors).
    IF VALID-HANDLE(h-boin404) THEN DO:
        DELETE PROCEDURE h-boin404.
        ASSIGN h-boin404 = ?.
    END.
    IF gl-exibe-json THEN DO:
        MESSAGE 'CRIA-TT-ITEM-TERC.1  - ' STRING(tt-item-doc-est.serie-terc    ).
        MESSAGE 'CRIA-TT-ITEM-TERC.2  - ' STRING(tt-item-doc-est.nro-docto-terc).
        MESSAGE 'CRIA-TT-ITEM-TERC.3  - ' STRING(tt-item-doc-est.nat-terc      ).
        MESSAGE 'CRIA-TT-ITEM-TERC.4  - ' STRING(tt-docum-est.cod-emitente     ).
        MESSAGE 'CRIA-TT-ITEM-TERC.5  - ' STRING(tt-item-doc-est.it-codigo     ).
        MESSAGE 'CRIA-TT-ITEM-TERC.6  - ' STRING(tt-item-doc-est.seq-terc      ).
        MESSAGE 'CRIA-TT-ITEM-TERC.7  - ' STRING(d-qtd                         ).
        MESSAGE 'CRIA-TT-ITEM-TERC.8  - ' STRING(tt-docum-est.nat-operacao     ).
    END.

    FIND FIRST rowErrors NO-LOCK NO-ERROR.
    IF gl-exibe-json THEN DO:
        MESSAGE 'CRIA-TT-ITEM-TERC.9  - ' AVAIL rowErrors.
        IF AVAIL rowErrors THEN
            MESSAGE 'CRIA-TT-ITEM-TERC.10  - ' RowErrors.ErrorHelp.
    END.

    IF CAN-FIND(FIRST rowErrors) THEN DO:
        FOR EACH RowErrors NO-LOCK:
            RUN pi-cria-erro(INPUT tt-docum-est.cod-emitente, 
                             INPUT tt-docum-est.serie-docto,  
                             INPUT tt-docum-est.nro-docto,    
                             INPUT tt-docum-est.nat-operacao, 
                             INPUT RowErrors.ErrorSequence,
                             INPUT RowErrors.ErrorNumber,
                             INPUT "Cria Item Terceiro: " + tt-docum-est.nro-docto + " - " + RowErrors.ErrorDescription,
                             INPUT RowErrors.ErrorHelp).
            IF RowErrors.ErrorSubType = "ERROR" THEN
                ASSIGN l-erro = TRUE.
        END.
        RETURN "NOK":U.
    END.

    /*--- retorna o valor correto do preco-total ---*/
    RUN ajusta-tt-item-terc.

    /*--- elimina a temp-table de erros ---*/
    RUN emptyRowErrors IN h-boin176.

    /*--- cria os registros conforme itens da tt-item-terc ---*/
    IF gl-exibe-json THEN DO:
        FOR EACH tt-item-terc.
            MESSAGE 'CRIA-TT-ITEM-TERC.11  - ' STRING(tt-item-terc.rw-saldo-terc).
            MESSAGE 'CRIA-TT-ITEM-TERC.12  - ' STRING(tt-item-terc.quantidade ).
        END.
    END.

    RUN createItemOfComponente IN h-boin176(INPUT h-boin090,
                                            INPUT TABLE tt-item-terc).

    IF gl-exibe-json THEN DO:
        MESSAGE 'CRIA-TT-ITEM-TERC.13  - ' RETURN-VALUE.
    END.

    /*--- mostra os erros em tela quando retornar NOK ---*/
    IF RETURN-VALUE = "NOK":U THEN DO:
        RUN getRowErrors IN h-boin176(OUTPUT TABLE RowErrors ).
        IF CAN-FIND(FIRST rowErrors) THEN DO:
            FOR EACH RowErrors NO-LOCK:
                RUN pi-cria-erro(INPUT tt-docum-est.cod-emitente, 
                                 INPUT tt-docum-est.serie-docto,  
                                 INPUT tt-docum-est.nro-docto,    
                                 INPUT tt-docum-est.nat-operacao, 
                                 INPUT RowErrors.ErrorSequence,
                                 INPUT RowErrors.ErrorNumber,
                                 INPUT "Cria Item Terceiro: " + tt-docum-est.nro-docto + " - " + RowErrors.ErrorDescription,
                                 INPUT RowErrors.ErrorHelp).
                IF RowErrors.ErrorSubType = "ERROR" THEN
                    ASSIGN l-erro = TRUE.
            END.
        END.
        RETURN "NOK":U.
    END.    

    /*RUN notaFiscAdic.
    if  return-value = "NOK":U then
        return "NOK":U.*/

    RETURN "OK":U.
END PROCEDURE.

/*------------------------------------------------------------------------------------------------------------*/
PROCEDURE ajusta-tt-item-terc:
    DEFINE VARIABLE h-boin404re AS HANDLE NO-UNDO.
    DEFINE VARIABLE da-dt-aux   AS DATE   NO-UNDO.

    IF NOT VALID-HANDLE(h-boin404re) THEN
        RUN inbo/boin404re.p PERSISTENT SET h-boin404re.

    FIND FIRST tt-saldo-terc NO-ERROR.
    FIND FIRST tt-item-terc  NO-ERROR.

    IF NOT AVAIL tt-saldo-terc THEN
        RETURN "NOK".

    IF NOT AVAIL tt-item-terc THEN
        RETURN "NOK".

    RUN findNaturOper IN h-boin404re ( tt-saldo-terc.nat-operacao ).

    RUN findSaldoTerc IN h-boin404re (tt-saldo-terc.cod-emitente,
                                      tt-saldo-terc.serie-docto,
                                      tt-saldo-terc.nro-docto,
                                      tt-saldo-terc.nat-operacao,
                                      tt-saldo-terc.sequencia,
                                      tt-saldo-terc.it-codigo,
                                      tt-saldo-terc.cod-refer).

    RUN getDateField IN h-boin090 (INPUT "dt-trans":U,
                                   OUTPUT da-dt-aux ).

    RUN getValuesTerceiros IN h-boin404re (INPUT  da-dt-aux, 
                                           INPUT  100,
                                           INPUT  tt-item-terc.quantidade,
                                           OUTPUT tt-item-terc.preco-total,
                                           OUTPUT tt-item-terc.desconto ).

    IF VALID-HANDLE(h-boin404re) THEN DO:
        DELETE PROCEDURE h-boin404re.
        ASSIGN h-boin404re = ?.
    END.
END PROCEDURE.

/*------------------------------------------------------------------------------------------------------------*/
PROCEDURE piRetornaValor:
    DEFINE VARIABLE deQtdeAFatur        AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE lMovtoDevSimbConsig AS LOGICAL     NO-UNDO.

    DEFINE OUTPUT PARAMETER d-qtd AS DECIMAL NO-UNDO.

    FIND FIRST saldo-terc NO-LOCK
         WHERE saldo-terc.serie-docto  = tt-item-doc-est.serie-terc
           AND saldo-terc.nro-docto    = tt-item-doc-est.nro-docto-terc
           AND saldo-terc.nat-operacao = tt-item-doc-est.nat-terc
           AND saldo-terc.it-codigo    = tt-item-doc-est.it-codigo
           AND saldo-terc.cod-emitente = tt-docum-est.cod-emitente
           AND saldo-terc.sequencia    = tt-item-doc-est.seq-terc 
           NO-ERROR.

    IF NOT AVAILABLE saldo-terc THEN DO:
        ASSIGN d-qtd = 0.
        RETURN "OK".
    END.

    FIND FIRST natur-oper NO-LOCK
         WHERE natur-oper.nat-operacao = tt-docum-est.nat-operacao NO-ERROR.

    IF AVAILABLE saldo-terc AND (AVAILABLE natur-oper AND natur-oper.tp-oper-terc = 4) THEN DO: 
        FIND FIRST param-of NO-LOCK 
             WHERE param-of.cod-estabel      = saldo-terc.cod-estabel
               AND param-of.log-devol-consig = TRUE NO-ERROR.
        IF AVAIL param-of THEN DO:

            ASSIGN deQtdeAFatur  = 0.
            
            FOR EACH componente NO-LOCK
               WHERE componente.cod-emitente = saldo-terc.cod-emitente
                 AND componente.nro-comp     = saldo-terc.nro-docto
                 AND componente.serie-comp   = saldo-terc.serie-docto
                 AND componente.nat-comp     = saldo-terc.nat-operacao
                 AND componente.seq-comp     = saldo-terc.sequencia:
                FIND FIRST natur-oper NO-LOCK
                     WHERE natur-oper.nat-operacao = componente.nat-operacao NO-ERROR.
                IF AVAILABLE natur-oper THEN DO:
                    ASSIGN lMovtoDevSimbConsig = IF natur-oper.terceiros       AND 
                                                    natur-oper.tp-oper-terc = 5 AND /* Devoluá∆o de Consignaá∆o */ 
                                                    (natur-oper.idi-tip-devol-consig = 1 OR /* Simb¢lica */
                                                    componente.idi-tip-devol-consig = 1) THEN YES
                                                 ELSE NO.
                END.
                ELSE
                    ASSIGN lMovtoDevSimbConsig = NO.
                
                IF  lMovtoDevSimbConsig THEN DO:
                    ASSIGN deQtdeAFatur = deQtdeAFatur + (componente.qtd-devol-simbol - componente.qtd-fatur-consig - componente.qtd-afatur-consig).
                END.
            END.
            
            IF  deQtdeAFatur > 0 THEN
                ASSIGN d-qtd = deQtdeAFatur.

        END.
    END.
    ELSE 
        ASSIGN d-qtd = IF AVAIL saldo-terc THEN saldo-terc.quantidade ELSE 0.
    
END PROCEDURE.

/*------------------------------------------------------------------------------------------------------------*/
PROCEDURE pi-cria-erro:
    DEFINE INPUT PARAMETER p-cod-emitente   AS INTEGER.
    DEFINE INPUT PARAMETER p-serie-docto    AS CHARACTER.
    DEFINE INPUT PARAMETER p-nro-docto      AS CHARACTER.
    DEFINE INPUT PARAMETER p-nat-operacao   AS CHARACTER.
    DEFINE INPUT PARAMETER p-sequencia      AS INTEGER.
    DEFINE INPUT PARAMETER p-numero         AS INTEGER.
    DEFINE INPUT PARAMETER p-descricao      AS CHARACTER.
    DEFINE INPUT PARAMETER p-ajuda          AS CHARACTER.

    CREATE tt-erro. 
    ASSIGN tt-erro.cod-emitente = p-cod-emitente 
           tt-erro.serie-docto  = p-serie-docto  
           tt-erro.nro-docto    = p-nro-docto    
           tt-erro.nat-operacao = p-nat-operacao 
           tt-erro.i-sequen     = p-sequencia
           tt-erro.cd-erro      = p-numero
           tt-erro.mensagem     = p-descricao + CHR(10) + p-ajuda.
END PROCEDURE.

/*------------------------------------------------------------------------------------------------------------*/
PROCEDURE atualizarDocumento:
    DEFINE INPUT PARAMETER p-docum-est AS ROWID       NO-UNDO.

    DEFINE VARIABLE raw-param AS RAW NO-UNDO.   

    EMPTY TEMP-TABLE tt-param.
    EMPTY TEMP-TABLE tt-digita.

    FIND FIRST docum-est WHERE ROWID(docum-est) = p-docum-est NO-LOCK NO-ERROR.
    IF AVAILABLE docum-est THEN DO:
        /* Cria Informaá‰es Adicionais da Nota Fiscal Referente NT 2020-006 (Sefaz) */
        IF NOT CAN-FIND (FIRST nota-fisc-adc 
                         WHERE nota-fisc-adc.cod-estab        = docum-est.cod-estabel  
                         AND   nota-fisc-adc.cod-serie        = docum-est.serie-docto
                         AND   nota-fisc-adc.cod-nota-fisc    = docum-est.nro-docto
                         AND   nota-fisc-adc.cdn-emitente     = docum-est.cod-emitente
                         AND   nota-fisc-adc.cod-natur-operac = docum-est.nat-operacao
                         AND   nota-fisc-adc.idi-tip-dado     = 20 NO-LOCK) THEN
        DO:
            CREATE nota-fisc-adc.
            ASSIGN nota-fisc-adc.cod-estab                  = docum-est.cod-estabel
                   nota-fisc-adc.cod-serie                  = docum-est.serie-docto
                   nota-fisc-adc.cod-nota-fisc              = docum-est.nro-docto
                   nota-fisc-adc.cdn-emitente               = docum-est.cod-emitente
                   nota-fisc-adc.cod-natur-operac           = docum-est.nat-operacao
                   nota-fisc-adc.idi-tip-dado               = 20
                   nota-fisc-adc.cod-livre-1                = "0".
        END.

        CREATE tt-param.
        ASSIGN tt-param.usuario         = c-seg-usuario
               tt-param.destino         = 3
               tt-param.data-exec       = TODAY
               tt-param.hora-exec       = TIME
               tt-param.arquivo         = SESSION:TEMP-DIRECTORY + "RE1005":U + ".tmp".
    
        CREATE tt-digita.
        ASSIGN tt-digita.r-docum-est = ROWID(docum-est).
    
        RAW-TRANSFER tt-param TO raw-param.
    
        FOR EACH tt-raw-digita:
            DELETE tt-raw-digita.
        END.
        FOR EACH tt-digita:
            CREATE tt-raw-digita.
            RAW-TRANSFER tt-digita TO tt-raw-digita.raw-digita.
        END.  
    
        RUN rep/re1005rp.p (INPUT raw-param, INPUT table tt-raw-digita).  
    END.
END PROCEDURE.

/*------------------------------------------------------------------------------------------------------------*/
PROCEDURE criarLoteItem:
    DEFINE VARIABLE h-boin367   AS HANDLE   NO-UNDO.
    DEFINE VARIABLE r-rowid     AS ROWID    NO-UNDO.

    DO ON ERROR UNDO,LEAVE:
        /*Deleta os lotes do item*/
/*         FOR EACH rat-lote WHERE rat-lote.cod-emitente   = tt-rat-lote.cod-emitente */
/*                           AND   rat-lote.nro-docto      = tt-rat-lote.nro-docto    */
/*                           AND   rat-lote.serie-docto    = tt-rat-lote.serie-docto  */
/*                           AND   rat-lote.nat-operacao   = tt-rat-lote.nat-operacao */
/*                           AND   rat-lote.sequencia      = tt-rat-lote.sequencia    */
/*                           NO-LOCK:                                                 */
/*             ASSIGN r-rowid = ROWID(rat-lote).                                      */
/*                                                                                    */
/*             RUN inbo/boin367.p PERSISTENT SET h-boin367.                           */
/*             RUN openQueryStatic IN h-boin367(INPUT "Main":U).                      */
/*             RUN validateDelete IN h-boin367(INPUT-OUTPUT r-rowid,                  */
/*                                             OUTPUT TABLE RowErrors).               */
/*                                                                                    */
/*             IF VALID-HANDLE(h-boin367) THEN                                        */
/*                 DELETE PROCEDURE h-boin367.                                        */
/*         END.                                                                       */
        FOR EACH rat-lote EXCLUSIVE-LOCK
           WHERE rat-lote.cod-emitente   = tt-rat-lote.cod-emitente
             AND rat-lote.nro-docto      = tt-rat-lote.nro-docto
             AND rat-lote.serie-docto    = tt-rat-lote.serie-docto
             AND rat-lote.nat-operacao   = tt-rat-lote.nat-operacao
             AND rat-lote.sequencia      = tt-rat-lote.sequencia :
            DELETE rat-lote.
        END.
        RELEASE rat-lote.
        IF gl-exibe-json THEN DO:
            MESSAGE 'prmapi-docum-est-dyn.criarLoteItem.1'
               SKIP tt-rat-lote.cod-emitente
               SKIP tt-rat-lote.nro-docto
               SKIP tt-rat-lote.serie-docto
               SKIP tt-rat-lote.nat-operacao
               SKIP tt-rat-lote.sequencia
               SKIP tt-rat-lote.cod-depos
               SKIP tt-rat-lote.quantidade
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
        END.
        /*---------------------*/
    
        EMPTY TEMP-TABLE tt-rat-lote-aux.
        EMPTY TEMP-TABLE RowErrors.
        ASSIGN l-erro = FALSE.

        CREATE tt-rat-lote-aux.
        BUFFER-COPY tt-rat-lote TO tt-rat-lote-aux.

        RUN inbo/boin367.p PERSISTENT SET h-boin367.
        RUN linkToItem-doc-est IN h-boin367(INPUT h-boin176).
        RUN openQueryStatic IN h-boin367(INPUT "OfItemDocEst":U).
        RUN validateCreate IN h-boin367(INPUT TABLE tt-rat-lote-aux,
                                        OUTPUT TABLE RowErrors,
                                        OUTPUT r-rowid).
        IF VALID-HANDLE(h-boin367) THEN
            DELETE PROCEDURE h-boin367.

        IF CAN-FIND(FIRST RowErrors) THEN DO:
            FOR EACH RowErrors NO-LOCK:
                RUN pi-cria-erro(INPUT tt-docum-est.cod-emitente, 
                                 INPUT tt-docum-est.serie-docto,  
                                 INPUT tt-docum-est.nro-docto,    
                                 INPUT tt-docum-est.nat-operacao, 
                                 INPUT RowErrors.ErrorSequence,
                                 INPUT RowErrors.ErrorNumber,
                                 INPUT "Cria Lote: " + tt-item-doc-est.it-codigo + " - " + RowErrors.ErrorDescription,
                                 INPUT RowErrors.ErrorHelp).
                IF RowErrors.ErrorSubType = "ERROR" THEN
                    ASSIGN l-erro = TRUE.
                    
            END.
        END.

        IF l-erro = TRUE THEN DO:
            IF gl-exibe-json THEN DO:
                MESSAGE "ERRO criarLoteItem".
            END.
    
            RETURN "NOK".
        END.

        RETURN "OK".
    END.
END PROCEDURE.

/*------------------------------------------------------------------------------------------------------------*/
PROCEDURE piCriaItemDocumentoDevolucao:
    DEFINE INPUT PARAMETER p-nr-nota-fis    AS CHARACTER.
    DEFINE INPUT PARAMETER p-serie          AS CHARACTER.
    DEFINE INPUT PARAMETER p-cod-estabel    AS CHARACTER.
    DEFINE INPUT PARAMETER p-it-codigo      AS CHARACTER.
    DEFINE INPUT PARAMETER p-nr-seq-fat     AS INTEGER.

    IF gl-exibe-json THEN DO:
        MESSAGE 'IN÷CIO piCriaItemDocumentoDevolucao'.
    END.

    /*Itens do documento*/
    DEFINE VARIABLE rw-nota-fiscal AS ROWID       NO-UNDO.
    
    RUN setconstraintnotafiscal IN h-boin090(INPUT YES).
    RUN setDefaultsNota IN h-boin090.
    
    IF gl-exibe-json THEN DO:
        MESSAGE 'DEPOIS setDefaultsNota'.
    END.

    FIND FIRST nota-fiscal NO-LOCK
         WHERE nota-fiscal.nr-nota-fis = p-nr-nota-fis
           AND nota-fiscal.serie       = p-serie
           AND nota-fiscal.cod-estabel = p-cod-estabel NO-ERROR.

    IF NOT AVAILABLE nota-fiscal THEN
        RETURN "NOK".
    
    IF gl-exibe-json THEN DO:
        MESSAGE 'DEPOIS nota-fiscal'.
    END.

    FIND LAST it-nota-fisc OF nota-fiscal NO-LOCK
        WHERE it-nota-fisc.it-codigo  = p-it-codigo
          AND it-nota-fisc.nr-seq-fat = p-nr-seq-fat NO-ERROR.

    IF NOT AVAILABLE it-nota-fisc THEN
        RETURN "NOK".
    
    IF gl-exibe-json THEN DO:
        MESSAGE 'ANTES consistNotaDevolCli'.
    END.

    RUN consistNotaDevolCli IN h-boin090 (INPUT it-nota-fisc.serie,
                                          INPUT it-nota-fisc.nr-nota-fis,
                                          INPUT it-nota-fisc.it-codigo,
                                          INPUT it-nota-fisc.nr-seq-fat,
                                          OUTPUT rw-Nota-Fiscal).

    IF gl-exibe-json THEN DO:
        MESSAGE 'piCriaItemDocumentoDevolucao.1  - ' STRING(it-nota-fisc.serie      ).
        MESSAGE 'piCriaItemDocumentoDevolucao.2  - ' STRING(it-nota-fisc.nr-nota-fis).
        MESSAGE 'piCriaItemDocumentoDevolucao.3  - ' STRING(it-nota-fisc.it-codigo  ).
        MESSAGE 'piCriaItemDocumentoDevolucao.4  - ' STRING(it-nota-fisc.nr-seq-fat ).
        MESSAGE 'piCriaItemDocumentoDevolucao.5  - ' STRING(rw-Nota-Fiscal          ).
    END.

    RUN getRowErrors IN h-boin090(OUTPUT TABLE RowErrors ).
    FOR EACH RowErrors WHERE RowErrors.ErrorSubType = "Error" NO-LOCK:
         RUN pi-cria-erro(INPUT tt-docum-est.cod-emitente
                         ,INPUT tt-docum-est.serie-docto  
                         ,INPUT tt-docum-est.nro-docto   
                         ,INPUT tt-docum-est.nat-operacao
                         ,INPUT RowErrors.ErrorSequence
                         ,INPUT RowErrors.ErrorNumber
                         ,INPUT "Cria Item Dev: " + tt-item-doc-est-dev.it-codigo + " - " + RowErrors.ErrorDescription
                         ,INPUT RowErrors.ErrorHelp).
        IF RowErrors.ErrorSubType = "Error" THEN
            ASSIGN l-erro = TRUE.
    END.
    RUN emptyRowErrors IN h-boin090.
    EMPTY TEMP-TABLE rowerrors.
    IF l-erro = TRUE THEN
        RETURN "NOK".

    IF gl-exibe-json THEN DO:
        MESSAGE 'DEPOIS consistNotaDevolCli'.
        MESSAGE 'ANTES pi-cria-tt-nota-fiscal'.
    END.

    RUN pi-cria-tt-nota-fiscal.
    IF RETURN-VALUE = "NOK" THEN DO:
        RETURN "NOK".
    END.
    
/*     IF gl-exibe-json THEN DO:                    */
/*         MESSAGE 'DEPOIS pi-cria-tt-nota-fiscal'. */
/*         MESSAGE 'ANTES notaFiscalAdic'.          */
/*     END.                                         */
/*                                                  */
/*     RUN notaFiscalAdic.                          */
/*     IF RETURN-VALUE = "NOK" THEN DO:             */
/*         RETURN "NOK".                            */
/*     END.                                         */
/*                                                  */
/*     IF gl-exibe-json THEN DO:                    */
/*         MESSAGE 'DEPOIS notaFiscalAdic'.         */
/*     END.                                         */
/*                                                  */
/*     DELETE PROCEDURE h-bodi515.                  */

    RETURN "OK".
    /*--------------------*/
END PROCEDURE.

/*------------------------------------------------------------------------------------------------------------*/
PROCEDURE pi-cria-tt-nota-fiscal:
    DO ON ERROR UNDO, LEAVE:
    
        DEFINE VARIABLE h-bodi088   AS HANDLE   NO-UNDO.
        DEFINE VARIABLE h-boin176   AS HANDLE   NO-UNDO.
        DEFINE VARIABLE l-reabre-pd AS LOGICAL  NO-UNDO.
    
        IF NOT VALID-HANDLE(h-bodi088) THEN
            RUN dibo/bodi088.p PERSISTENT SET h-bodi088.
    
        ASSIGN l-reabre-pd = FALSE.

        IF VALID-HANDLE(h-bodi088) THEN
            RUN validateNotaFiscal IN h-bodi088 (INPUT  it-nota-fisc.serie,
                                                 INPUT  it-nota-fisc.nr-nota-fis,
                                                 INPUT  it-nota-fisc.it-codigo,
                                                 INPUT  it-nota-fisc.nr-seq-fat,
                                                 INPUT  tt-docum-est.cod-estabel,
                                                 INPUT  it-nota-fisc.qt-faturada[1],
                                                 INPUT  l-reabre-pd,
                                                 OUTPUT TABLE tt-it-nota-fisc,
                                                 OUTPUT TABLE tt-item-devol-cli,
                                                 OUTPUT TABLE RowErrors).

        IF gl-exibe-json THEN DO:
            MESSAGE 'pi-cria-tt-nota-fiscal.1  - ' STRING(it-nota-fisc.serie         ).
            MESSAGE 'pi-cria-tt-nota-fiscal.2  - ' STRING(it-nota-fisc.nr-nota-fis   ).
            MESSAGE 'pi-cria-tt-nota-fiscal.3  - ' STRING(it-nota-fisc.it-codigo     ).
            MESSAGE 'pi-cria-tt-nota-fiscal.4  - ' STRING(it-nota-fisc.nr-seq-fat    ).
            MESSAGE 'pi-cria-tt-nota-fiscal.5  - ' STRING(tt-docum-est.cod-estabel   ).
            MESSAGE 'pi-cria-tt-nota-fiscal.6  - ' STRING(it-nota-fisc.qt-faturada[1]).
            MESSAGE 'pi-cria-tt-nota-fiscal.7  - ' STRING(l-reabre-pd                ).
        END.
        
        IF VALID-HANDLE(h-bodi088) THEN DO:
            DELETE PROCEDURE h-bodi088.
            ASSIGN h-bodi088 = ?.
        END.
    
        IF CAN-FIND(FIRST RowErrors) THEN DO:
            FOR EACH RowErrors NO-LOCK:
                RUN pi-cria-erro(INPUT tt-docum-est.cod-emitente
                                ,INPUT tt-docum-est.serie-docto  
                                ,INPUT tt-docum-est.nro-docto   
                                ,INPUT tt-docum-est.nat-operacao
                                ,INPUT RowErrors.ErrorSequence
                                ,INPUT RowErrors.ErrorNumber
                                ,INPUT "Cria Item Dev: " + tt-item-doc-est-dev.it-codigo + " - " + RowErrors.ErrorDescription
                                ,INPUT RowErrors.ErrorHelp).
                IF RowErrors.ErrorSubType = "Error" THEN
                    ASSIGN l-erro = TRUE.
            END.
    
            IF l-erro = TRUE THEN
                RETURN "NOK".
        END.
    
        IF  NOT CAN-FIND (FIRST tt-item-devol-cli) THEN
            RETURN "NOK":U.
    
        IF  NOT CAN-FIND (FIRST tt-it-nota-fisc) THEN
            RETURN "NOK":U.
    
        RUN ajusta-valores-nota-fiscal.
    
        IF NOT VALID-HANDLE(h-boin176) THEN DO:
            RUN inbo/boin176.p PERSISTENT SET h-boin176.
            RUN openQueryStatic IN h-boin176(INPUT "Main":U).
        END.

        RUN setHandleDocumEst IN h-boin176(INPUT h-boin090).
        RUN setDocumEst IN h-boin176.
        RUN createItemOfNotaFiscal IN h-boin176(INPUT h-boin090,
                                                INPUT TABLE tt-item-devol-cli).
    
        RUN getRowErrors IN h-boin176(OUTPUT TABLE RowErrors).
        IF CAN-FIND(FIRST RowErrors) THEN DO:
            FOR EACH RowErrors /*WHERE RowErrors.ErrorSubType = "Error"*/ NO-LOCK:
                RUN pi-cria-erro(INPUT tt-docum-est.cod-emitente
                                ,INPUT tt-docum-est.serie-docto  
                                ,INPUT tt-docum-est.nro-docto   
                                ,INPUT tt-docum-est.nat-operacao
                                ,INPUT RowErrors.ErrorSequence
                                ,INPUT RowErrors.ErrorNumber
                                ,INPUT "Cria Item Dev: " + tt-item-doc-est-dev.it-codigo + " - " + RowErrors.ErrorDescription
                                ,INPUT RowErrors.ErrorHelp).
                IF RowErrors.ErrorSubType = "Error" THEN
                    ASSIGN l-erro = TRUE.
            END.
    
            IF l-erro = TRUE THEN
                RETURN "NOK".
        END.
    
        IF VALID-HANDLE(h-boin176) THEN DO:
            DELETE PROCEDURE h-boin176.
            ASSIGN h-boin176 = ?.
        END.        

        IF l-erro = TRUE THEN
            RETURN "NOK".

        RETURN "OK":U.

        CATCH oneError AS Progress.Lang.AppError:
            RETURN "NOK".
        END CATCH.
    END.
END PROCEDURE.

/*------------------------------------------------------------------------------------------------------------*/
PROCEDURE notaFiscalAdic:
    DO ON ERROR UNDO,LEAVE:
        DEFINE VARIABLE c-modelo  AS CHARACTER  NO-UNDO.
        
        RUN dibo/bodi515.p PERSISTENT SET h-bodi515.
        RUN openQueryStatic IN h-bodi515 (INPUT "Main":U).
        
        ASSIGN c-sigla-emb = 'CX'.
        IF gl-exibe-json THEN DO:
            FOR EACH tt-item-devol-cli.
                MESSAGE 'PRMAPI-DOCUM-EST.7 ' STRING(tt-item-devol-cli.rw-it-nota-fisc).
            END.
        END.

        FOR EACH tt-item-devol-cli,
            FIRST it-nota-fisc
            WHERE ROWID(it-nota-fisc) = tt-item-devol-cli.rw-it-nota-fisc NO-LOCK
            BREAK BY it-nota-fisc.serie
                  BY it-nota-fisc.nr-nota-fis
                  BY it-nota-fisc.cd-emitente: 
        
            IF LAST-OF(it-nota-fisc.cd-emitente) THEN DO:

                FIND FIRST item NO-LOCK WHERE item.it-codigo = it-nota-fisc.it-codigo NO-ERROR.
                FIND FIRST item-caixa NO-LOCK
                     WHERE (item-caixa.fm-codigo  = item.fm-codigo  OR
                            item-caixa.fm-codigo  = ?)
                       AND (item-caixa.fm-cod-com = item.fm-cod-com OR
                            item-caixa.fm-cod-com = ?)
                       AND (item-caixa.it-codigo  = item.it-codigo  OR
                            item-caixa.it-codigo  = ?) NO-ERROR.
                IF AVAIL item-caixa THEN
                    ASSIGN c-sigla-emb = item-caixa.sigla-emb .

                RUN goToKeyDoctoRef IN h-bodi515 (INPUT tt-docum-est.cod-estabel,
                                                  INPUT tt-docum-est.serie-docto,
                                                  INPUT tt-docum-est.nro-docto,
                                                  INPUT tt-docum-est.cod-emitente,
                                                  INPUT tt-docum-est.nat-operacao,
                                                  INPUT 3,
                                                  INPUT it-nota-fisc.serie,
                                                  INPUT it-nota-fisc.nr-nota-fis,
                                                  INPUT it-nota-fisc.cd-emitente).

                IF gl-exibe-json THEN DO:
                    MESSAGE 'PRMAPI-DOCUM-EST.8 '  RETURN-VALUE.
                    MESSAGE 'PRMAPI-DOCUM-EST.9 '  STRING(tt-docum-est.cod-estabel ). 
                    MESSAGE 'PRMAPI-DOCUM-EST.10 ' STRING(tt-docum-est.serie-docto ). 
                    MESSAGE 'PRMAPI-DOCUM-EST.11 ' STRING(tt-docum-est.nro-docto   ). 
                    MESSAGE 'PRMAPI-DOCUM-EST.12 ' STRING(tt-docum-est.cod-emitente).
                    MESSAGE 'PRMAPI-DOCUM-EST.13 ' STRING(tt-docum-est.nat-operacao).
                    MESSAGE 'PRMAPI-DOCUM-EST.14 ' STRING(it-nota-fisc.serie       ). 
                    MESSAGE 'PRMAPI-DOCUM-EST.15 ' STRING(it-nota-fisc.nr-nota-fis ). 
                    MESSAGE 'PRMAPI-DOCUM-EST.16 ' STRING(it-nota-fisc.cd-emitente ).
                END.

                IF RETURN-VALUE = "NOK":U THEN DO:
                    EMPTY TEMP-TABLE tt-nota-fisc-adc.
                    
                    FIND FIRST nota-fiscal OF it-nota-fisc NO-LOCK NO-ERROR.
                    
                    IF AVAIL natur-oper AND NOT natur-oper.terceiros THEN
                    DO:
                        CREATE tt-nota-fisc-adc.
                        ASSIGN tt-nota-fisc-adc.cod-estab                = tt-docum-est.cod-estabel  
                               tt-nota-fisc-adc.cod-serie                = tt-docum-est.serie-docto 
                               tt-nota-fisc-adc.cod-nota-fisc            = tt-docum-est.nro-docto   
                               tt-nota-fisc-adc.cdn-emitente             = tt-docum-est.cod-emitente 
                               tt-nota-fisc-adc.cod-natur-operac         = tt-docum-est.nat-operacao
                               tt-nota-fisc-adc.idi-tip-dado             = 3
                               tt-nota-fisc-adc.cod-ser-docto-referado   = it-nota-fisc.serie
                               tt-nota-fisc-adc.cod-docto-referado       = it-nota-fisc.nr-nota-fis
                               tt-nota-fisc-adc.cdn-emit-docto-referado  = it-nota-fisc.cd-emitente
                               tt-nota-fisc-adc.cod-livre-2              = IF AVAIL nota-fiscal THEN nota-fiscal.cod-chave-aces-nf-eletro ELSE "".
            
                        IF gl-exibe-json THEN DO:
                            MESSAGE 'PRMAPI-DOCUM-EST.9 ' tt-nota-fisc-adc.cod-docto-referado.
                        END.
                        RUN pi-buscaModelo IN h-bodi515 (INPUT "FT",
                                                         INPUT it-nota-fisc.cod-estabel,  
                                                         INPUT it-nota-fisc.serie,  
                                                         INPUT it-nota-fisc.nr-nota-fis,    
                                                         INPUT it-nota-fisc.cd-emitente, 
                                                         INPUT it-nota-fisc.nat-operacao, 
                                                         OUTPUT c-modelo).
            
                        ASSIGN tt-nota-fisc-adc.cod-model-docto-referado = c-modelo
                               tt-nota-fisc-adc.dat-docto-referado       = it-nota-fisc.dt-emis-nota
                               tt-nota-fisc-adc.idi-tip-docto-referado   = 2
                               tt-nota-fisc-adc.idi-tip-emit-referado    = 1.
                            
                        RUN setRecord IN h-bodi515(INPUT TABLE tt-nota-fisc-adc).
                        RUN emptyRowErrors IN h-bodi515.
                        IF RETURN-VALUE = "OK":U THEN
                            RUN createRecord IN h-bodi515.
                        
                        RUN getRowErrors IN h-bodi515 (OUTPUT TABLE RowErrors).
                        IF  CAN-FIND(FIRST RowErrors) THEN DO:
                            FOR EACH RowErrors NO-LOCK:
                                RUN pi-cria-erro(INPUT tt-docum-est.cod-emitente
                                                ,INPUT tt-docum-est.serie-docto  
                                                ,INPUT tt-docum-est.nro-docto   
                                                ,INPUT tt-docum-est.nat-operacao
                                                ,INPUT RowErrors.ErrorSequence
                                                ,INPUT RowErrors.ErrorNumber
                                                ,INPUT "Cria Item Dev: " + RowErrors.ErrorDescription
                                                ,INPUT RowErrors.ErrorHelp).
                                IF RowErrors.ErrorSubType = "ERROR" THEN
                                    ASSIGN l-erro = TRUE.
                            END.
            
                            IF l-erro = TRUE THEN
                                RETURN "NOK":U.
                        END.
                    END.
                END.
            END.
        END.      

        /* -- Embalagem -- */
        IF i-volumes > 1 THEN DO: /* S¢ ir† executar quando a quantidade de embalagem for acima do padr∆o(1) */
            RUN getRowId IN h-boin090(OUTPUT rw-docum-est-aux).

            IF rw-docum-est-aux <> ? THEN
                FIND FIRST docum-est WHERE ROWID(docum-est) = rw-docum-est-aux NO-LOCK NO-ERROR.

            ASSIGN rw-docum-est-aux = ?.

            IF NOT VALID-HANDLE (h-boin0815) THEN
                RUN inbo/boin0815.p PERSISTENT SET h-boin0815.

            IF VALID-HANDLE(h-boin0815)  THEN DO:
               RUN openQueryStatic IN h-boin0815 (INPUT "Main":U).
            END.
    
            FOR EACH tt-docto-estoq-embal:
                DELETE tt-docto-estoq-embal.
            END.

            FIND FIRST embalag NO-LOCK WHERE embalag.sigla-emb = c-sigla-emb NO-ERROR.
            CREATE tt-docto-estoq-embal.
            ASSIGN tt-docto-estoq-embal.cod-ser-docto    = tt-item-doc-est-dev.serie-terc
                   tt-docto-estoq-embal.cod-docto        = IF AVAIL docum-est THEN docum-est.nro-docto ELSE tt-docum-est.nro-docto
                   tt-docto-estoq-embal.cdn-emitente     = tt-docum-est.cod-emitente 
                   tt-docto-estoq-embal.cod-natur-operac = tt-item-doc-est.nat-operacao 
                   tt-docto-estoq-embal.num-vol          = i-volumes
                   tt-docto-estoq-embal.cod-sig-embal    = c-sigla-emb
                   tt-docto-estoq-embal.cod-embal        = IF AVAIL embalag THEN embalag.descricao ELSE ''
                   tt-docto-estoq-embal.qtd-vol          = i-volumes.
        
             IF VALID-HANDLE(h-boin0815) THEN
               RUN getDescSigla IN h-boin0815 (c-sigla-emb,
                                               OUTPUT c-desc,
                                               OUTPUT c-tipo-emb).
    
             ASSIGN tt-docto-estoq-embal.des-descr-gener = c-desc.

             RUN gotokey IN h-boin0815 (INPUT tt-docto-estoq-embal.cod-ser-docto,
                                        INPUT tt-docto-estoq-embal.cod-docto,
                                        INPUT tt-docto-estoq-embal.cdn-emitente,
                                        INPUT tt-docto-estoq-embal.cod-natur-operac,
                                        INPUT tt-docto-estoq-embal.cod-sig-embal).
             

             IF RETURN-VALUE <> "OK":U THEN DO:
                RUN emptyRowErrors IN h-boin0815.
                RUN setRecord IN h-boin0815 (INPUT TABLE tt-docto-estoq-embal).
                RUN CreateRecord IN h-boin0815.
             END.
             ELSE DO:
                RUN emptyRowErrors IN h-boin0815.
                RUN setRecord IN h-boin0815 (INPUT TABLE tt-docto-estoq-embal).
                RUN UpdateRecord IN h-boin0815.
             END.

             IF RETURN-VALUE = "NOK":U THEN DO:
                RUN getRowErrors IN h-boin0815 (OUTPUT TABLE RowErrors).
                
                FOR EACH RowErrors /*WHERE RowErrors.ErrorSubType = "Error"*/ NO-LOCK:
                    RUN pi-cria-erro(INPUT tt-docum-est.cod-emitente
                                    ,INPUT tt-docum-est.serie-docto  
                                    ,INPUT tt-docum-est.nro-docto   
                                    ,INPUT tt-docum-est.nat-operacao
                                    ,INPUT RowErrors.ErrorSequence
                                    ,INPUT RowErrors.ErrorNumber
                                    ,INPUT "Cria Item Dev: " + RowErrors.ErrorDescription
                                    ,INPUT RowErrors.ErrorHelp).
                    IF RowErrors.ErrorSubType = "Error" THEN
                        ASSIGN l-erro = TRUE.
                END.
        
             END.
             ELSE DO:
                ASSIGN l-erro = FALSE.
             END.

             IF VALID-HANDLE(h-boin0815) THEN
                 DELETE PROCEDURE h-boin0815.

        END. /* i-volumes > 1 */

        IF l-erro THEN
            RETURN "NOK".
        ELSE
            RETURN "OK":U.

        CATCH oneError AS Progress.Lang.Error:
            IF gl-exibe-json THEN DO:
                MESSAGE oneError:GetMessage(1) . 
            END.
            RETURN "NOK".
        END CATCH.
    END.
END PROCEDURE.

/*------------------------------------------------------------------------------------------------------------*/
PROCEDURE ajusta-valores-nota-fiscal:
    DEF VAR de-indice    AS DEC    NO-UNDO.
    DEF VAR de-qtd-devol AS DEC    NO-UNDO.
    DEF VAR l-desc       AS LOG    NO-UNDO.
    DEF VAR i-base-st    AS INT    NO-UNDO.
    DEF VAR c-base-icm   AS CHAR   NO-UNDO.
    DEF VAR c-char-2     AS CHAR   NO-UNDO.
    DEF VAR h-boin245na  AS HANDLE NO-UNDO.

    FIND FIRST tt-it-nota-fisc    NO-ERROR.
    FIND FIRST tt-item-devol-cli  NO-ERROR.

    IF  NOT VALID-HANDLE(h-boin245na) THEN
        RUN inbo/boin245na.p PERSISTENT SET h-boin245na.

    RUN openQueryStatic IN h-boin245na (INPUT "Main":U) NO-ERROR.    

    /* Verifica se existe desconto para a nota de venda e se os impostos foram calculado pelo Bruto */
    RUN goToKey IN h-boin245na (INPUT tt-it-nota-fisc.nat-operacao).

    IF  RETURN-VALUE = "OK":U THEN DO:
        RUN getIntField  IN h-boin245na (INPUT "merc-base-icms":U, OUTPUT c-base-icm).
        RUN getCharField IN h-boin245na (INPUT "char-2":U, OUTPUT c-char-2).
    END.

    RUN findUnidFederEstab IN h-boin090 (INPUT  tt-it-nota-fisc.cod-estabel,
                                         OUTPUT i-base-st ).

    IF  (SUBSTR(c-char-2,11,1) = "1"               /* IPI pelo Bruto */
         OR c-base-icm    = "1"                    /* ICMS pelo Bruto */
         OR (i-base-st = 1                         /*Subs. Trib. Bruto*/
             AND tt-it-nota-fisc.vl-icmsub-it > 0  /* Valor do ICMS Subs. */
             AND tt-it-nota-fisc.ind-icm-ret))     /*Item da saida teve subs. trib.*/
    AND (tt-it-nota-fisc.val-pct-desconto-total > 0
         OR tt-it-nota-fisc.val-desconto-total  > 0) THEN
        ASSIGN l-desc = YES.
    ELSE
        ASSIGN l-desc = NO.

    ASSIGN de-indice = &IF "{&bf_dis_versao_ems}" >= "2.06" &THEN
                           IF tt-it-nota-fisc.ind-fat-qtfam = NO THEN 1
                           ELSE tt-it-nota-fisc.qt-faturada[2] / tt-it-nota-fisc.qt-faturada[1]
                       &ELSE
                           if tt-it-nota-fisc.ind-fat-qtfam 
                           then tt-it-nota-fisc.qt-faturada[2] / tt-it-nota-fisc.qt-faturada[1]
                           else 1
                       &ENDIF.

    IF  l-desc THEN
        ASSIGN tt-it-nota-fisc.dec-2       = tt-it-nota-fisc.vl-preori * (tt-it-nota-fisc.dec-1 * de-indice)
               tt-it-nota-fisc.vl-desconto = ((tt-it-nota-fisc.vl-preori - tt-it-nota-fisc.vl-preuni) 
                                           * (tt-it-nota-fisc.dec-1 * de-indice)).
    ELSE
        ASSIGN tt-it-nota-fisc.dec-2       = tt-it-nota-fisc.vl-preuni * (tt-it-nota-fisc.dec-1 * de-indice)
               tt-it-nota-fisc.vl-desconto = 0.

    ASSIGN tt-item-devol-cli.quant-devol     = tt-it-nota-fisc.dec-1
           tt-item-devol-cli.preco-devol     = tt-it-nota-fisc.dec-2
           tt-item-devol-cli.vl-desconto     = tt-it-nota-fisc.vl-desconto.

    IF  VALID-HANDLE(h-boin245na) THEN DO:
        DELETE PROCEDURE h-boin245na.
        ASSIGN h-boin245na = ?.
    END.
    /*************correcao*************/
END PROCEDURE.

/*------------------------------------------------------------------------------------------------------------*/
PROCEDURE pi-atualiza.

    DEFINE INPUT  PARAMETER p-rw-docum-est AS ROWID       NO-UNDO.
    DEFINE OUTPUT PARAMETER p-ok           AS LOGICAL     NO-UNDO.
    DEFINE OUTPUT PARAMETER p-erros-atu    AS CHARACTER   NO-UNDO.
    
    DEFINE VARIABLE raw-param      AS RAW         NO-UNDO.
    DEFINE VARIABLE c-arquivo-re   AS CHARACTER   NO-UNDO.

    FIND FIRST docum-est NO-LOCK 
         WHERE ROWID(docum-est) = p-rw-docum-est NO-ERROR.

    EMPTY TEMP-TABLE tt-digita.
    EMPTY TEMP-TABLE tt-param.

    ASSIGN c-arquivo-re = IF i-num-ped-exec-rpw = 0 THEN (SESSION:TEMP-DIRECTORY + "RE1005-INTEGRADOR":U + ".tmp") 
                          ELSE ("RE1005-INTEGRADOR":U + "-" + STRING(DAY(TODAY)) + STRING(MONTH(TODAY),"99") + "-" + REPLACE(STRING(TIME,"HH:MM:SS"),":","") + ".tmp").

    CREATE tt-param.
    ASSIGN tt-param.usuario   = v_cod_usuar_corren
           tt-param.destino   = 3
           tt-param.data-exec = TODAY
           tt-param.hora-exec = TIME
           tt-param.arquivo   = c-arquivo-re.
        
    CREATE tt-digita.
    ASSIGN tt-digita.r-docum-est = p-rw-docum-est.

    RAW-TRANSFER tt-param TO raw-param.
        
    EMPTY TEMP-TABLE tt-raw-digita.
    FOR EACH tt-digita:
        CREATE tt-raw-digita.
        RAW-TRANSFER tt-digita TO tt-raw-digita.raw-digita.
    END.  
    
    RUN rep/re1005rp.p (INPUT raw-param, INPUT TABLE tt-raw-digita).

    ASSIGN p-ok = FALSE.
    FIND FIRST docum-est NO-LOCK 
         WHERE ROWID(docum-est) = p-rw-docum-est NO-ERROR.
    IF AVAILABLE docum-est THEN DO:
        ASSIGN p-ok = docum-est.ce-atual.
    END.

    FOR EACH consist-nota NO-LOCK
       WHERE consist-nota.serie-docto    = docum-est.serie-docto
         AND consist-nota.nro-docto      = docum-est.nro-docto
         AND consist-nota.cod-emitente   = docum-est.cod-emitente
         AND consist-nota.nat-operacao   = docum-est.nat-operacao
         AND consist-nota.tipo           = 1 .
            
        FIND FIRST cadast_msg NO-LOCK
             WHERE cadast_msg.cdn_msg = consist-nota.mensagem NO-ERROR.
        IF AVAIL cadast_msg AND cadast_msg.idi_tip_msg = 1 THEN
            ASSIGN p-erros-atu = p-erros-atu + cadast_msg.des_text_msg + " | "
                   p-ok        = FALSE.
    END.

    ASSIGN p-erros-atu = RIGHT-TRIM(p-erros-atu, " | ").
END PROCEDURE.

/*------------------------------------------------------------------------------------------------------------*/
PROCEDURE pi-elimina:

    DEFINE INPUT  PARAMETER p-rw-docum-est  AS ROWID    NO-UNDO.
    DEFINE OUTPUT PARAMETER p-ok            AS LOGICAL  NO-UNDO.

    DEFINE VARIABLE h-boin090 AS HANDLE    NO-UNDO.
    DEFINE VARIABLE c-retorno AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-erro    AS CHARACTER NO-UNDO FORMAT "x(200)".
    
    FIND FIRST docum-est NO-LOCK 
         WHERE ROWID(docum-est) = p-rw-docum-est NO-ERROR.
    
    RUN inbo/boin090 PERSISTENT SET h-boin090.
    RUN openQueryStatic IN h-boin090 ("Main":U).
    
    ASSIGN c-erro = "Eliminado com sucesso.".

    FOR EACH tt-docum-est-eli:
        DELETE tt-docum-est-eli.
    END.

    CREATE tt-docum-est-eli.
    BUFFER-COPY docum-est TO tt-docum-est-eli.
    ASSIGN tt-docum-est-eli.r-Rowid = ROWID(docum-est).
    
    RUN setRecord IN h-boin090 (INPUT TABLE tt-docum-est-eli).
    
    RUN goToKey IN h-boin090 (INPUT tt-docum-est-eli.serie-docto,
                              INPUT tt-docum-est-eli.nro-docto,
                              INPUT tt-docum-est-eli.cod-emitente,
                              INPUT tt-docum-est-eli.nat-operacao).
    
    RUN emptyRowErrors IN h-boin090.
    RUN deleteRecord IN h-boin090.
    RUN getRowErrors IN h-boin090 ( OUTPUT TABLE rowErrors ).
    
    /*--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN DO:
        FOR EACH RowErrors.
            ASSIGN c-erro = c-erro + RowErrors.ErrorDescription + " | ".
        END.
    END.
    ELSE        
        ASSIGN c-erro = "Eliminado com sucesso.".
    
    DELETE PROCEDURE h-boin090.
    ASSIGN h-boin090 = ?.
    ASSIGN c-retorno = c-erro.

    IF c-retorno BEGINS "Eliminado com sucesso" THEN DO:
        ASSIGN p-ok = TRUE.
    END.
    ELSE DO:
        ASSIGN p-ok = FALSE.
    END.

END PROCEDURE.

/*------------------------------------------------------------------------------------------------------------*/
