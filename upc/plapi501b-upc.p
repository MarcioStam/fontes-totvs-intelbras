/*****************************************************************************
** Programa..............: plapi501b-upc.p
** Descricao.............: UPC para considerar saldo vencido, igual a 
                            plapi501-upc.p porem sem a logica de OEM
** Criado em.............: 01/07/2019
** Autor.................: Nicolas Martinez
*****************************************************************************/

{include/i-epc200.i1} /* Defini‡Æo tt-EPC */

{esp/es0018.i}

DEFINE INPUT        PARAM p-ind-event AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAM TABLE FOR tt-epc.

DEFINE VARIABLE r-pl-prod        AS ROWID                NO-UNDO.
DEFINE VARIABLE r-b-item         AS ROWID                NO-UNDO.
DEFINE VARIABLE de-saldo         LIKE pl-it-calc.saldo   NO-UNDO.
DEFINE VARIABLE de-saldo-api     LIKE pl-it-calc.saldo   NO-UNDO.
DEFINE VARIABLE de-saldo-retorna AS DECIMAL              NO-UNDO .
    
DEFINE VARIABLE c-estabel-param AS CHARACTER   NO-UNDO.

DEFINE VARIABLE r-ped-venda AS ROWID.
DEFINE VARIABLE c-clientes AS CHARACTER   NO-UNDO.

DEF TEMP-TABLE w-estabel NO-UNDO
    FIELD cod-estabel LIKE estabelec.cod-estabel
    FIELD considera   LIKE item.baixa-estoq
    FIELD prioridade  AS INTEGER 
    INDEX cod-estabel IS PRIMARY cod-estabel
    INDEX considera   considera prioridade DESCENDING.

IF p-ind-event = "Recalculo-saldo-estoq" THEN DO:
                  
    FOR FIRST tt-epc 
        WHERE tt-epc.cod-event     = p-ind-event
        AND   tt-epc.cod-parameter = "pl-prod-rowid":
        
        ASSIGN r-pl-prod = TO-ROWID(tt-epc.val-parameter).
    END.

    FOR FIRST tt-epc 
        WHERE tt-epc.cod-event     = p-ind-event
        AND   tt-epc.cod-parameter = "b-item-rowid":
        
        ASSIGN r-b-item = TO-ROWID(tt-epc.val-parameter).
    END.

    FOR FIRST tt-epc 
        WHERE tt-epc.cod-event     = p-ind-event
        AND   tt-epc.cod-parameter = "c-estabel-param":
        ASSIGN c-estabel-param = tt-epc.val-parameter.
    END.

    FOR FIRST tt-epc 
        WHERE tt-epc.cod-event     = p-ind-event
        AND   tt-epc.cod-parameter = "de-saldo":
        ASSIGN de-saldo-api = DEC(tt-epc.val-parameter).
    END.

    FIND FIRST pl-prod NO-LOCK
        WHERE ROWID(pl-prod) = r-pl-prod NO-ERROR.

    FOR EACH  pl-prod-estab NO-LOCK 
        WHERE pl-prod-estab.cd-plano = pl-prod.cd-plano:            
        CREATE w-estabel.
        ASSIGN w-estabel.cod-estabel = pl-prod-estab.cod-estabel.                    
    END.

    FIND FIRST ITEM NO-LOCK
        WHERE ROWID(ITEM) = r-b-item NO-ERROR.

    IF c-estabel-param <> "" THEN DO: /** MultiEstabelecimento **/
        FOR EACH saldo-estoq FIELDS (it-codigo cod-estabel cod-depos dt-vali-lote qtidade-atu cod-refer qt-alocada qt-aloc-ped qt-aloc-prod
                                     &IF DEFINED (bf_man_per_ppm) &THEN per-ppm &ENDIF 
                                     &if '{&bf_lote_avancado_liberado}' = 'yes' &then lote &endif) USE-INDEX  ITEM 
            WHERE saldo-estoq.it-codigo   = item.it-codigo
              AND saldo-estoq.cod-estabel = c-estabel-param NO-LOCK, 
            FIRST deposito FIELDS (cod-depos cons-saldo)
                WHERE deposito.cod-depos = saldo-estoq.cod-depos NO-LOCK:
                
            FIND FIRST es-pl-prod NO-LOCK
                WHERE  es-pl-prod.cd-plano = pl-prod.cd-plano NO-ERROR.
            IF AVAIL es-pl-prod THEN
                IF es-pl-prod.cons-lote-venc = NO THEN   /** Considera lote vencido **/
                    IF saldo-estoq.dt-vali-lote <> ? AND saldo-estoq.dt-vali-lote < TODAY THEN NEXT.
            
            IF (saldo-estoq.dt-vali-lote >= TODAY OR
                saldo-estoq.dt-vali-lote = ?) THEN NEXT.

            RUN pi-soma-saldo-interno (BUFFER pl-prod,
                                       BUFFER item,
                                       BUFFER saldo-estoq,
                                       c-estabel-param,
                                       OUTPUT de-saldo-retorna).
            ASSIGN de-saldo = de-saldo + de-saldo-retorna.
        END.
    END.
    ELSE DO:             /*MonoEstabelecimento*/

        FOR EACH saldo-estoq FIELDS (it-codigo cod-estabel cod-depos dt-vali-lote qtidade-atu cod-refer qt-alocada qt-aloc-ped qt-aloc-prod
                                     &IF DEFINED (bf_man_per_ppm) &THEN per-ppm &ENDIF 
                                     &if '{&bf_lote_avancado_liberado}' = 'yes' &then lote &endif) USE-INDEX  ITEM 
            WHERE saldo-estoq.it-codigo   = item.it-codigo,
            FIRST deposito FIELDS (cod-depos cons-saldo)
                WHERE deposito.cod-depos = saldo-estoq.cod-depos NO-LOCK:
                
            FIND FIRST es-pl-prod NO-LOCK
                WHERE  es-pl-prod.cd-plano = pl-prod.cd-plano NO-ERROR.
            IF AVAIL es-pl-prod THEN
                IF es-pl-prod.cons-lote-venc = NO THEN    /** Considera lote vencido **/
                    IF saldo-estoq.dt-vali-lote <> ? and saldo-estoq.dt-vali-lote < TODAY THEN NEXT.
            
            IF (saldo-estoq.dt-vali-lote >= TODAY OR
                saldo-estoq.dt-vali-lote = ?) THEN NEXT.

            RUN pi-soma-saldo-interno (BUFFER pl-prod,
                                       BUFFER item,
                                       BUFFER saldo-estoq,
                                       c-estabel-param,
                                       OUTPUT de-saldo-retorna).
            ASSIGN de-saldo = de-saldo + de-saldo-retorna.
        END.
    END.

    /*** Retorna o valor do novo saldo ***/
    FIND FIRST tt-epc
         WHERE tt-epc.cod-event     = p-ind-event
           AND tt-epc.cod-parameter = "novo-saldo":U NO-LOCK NO-ERROR.
    IF AVAIL tt-epc THEN
        ASSIGN tt-epc.val-parameter = STRING(de-saldo).
    ELSE DO:
        CREATE tt-epc.
        ASSIGN tt-epc.cod-event     = p-ind-event      
               tt-epc.cod-parameter = "novo-saldo":U
               tt-epc.val-parameter = STRING(de-saldo).
    END.
    /***/
END.

PROCEDURE pi-soma-saldo-interno:

    DEF PARAMETER BUFFER b-pl-prod       FOR pl-prod.
    DEF PARAMETER BUFFER b-item          FOR item.
    DEF PARAMETER BUFFER b-saldo         FOR saldo-estoq.
    DEF INPUT  PARAMETER c-estabel-param LIKE estabelec.cod-estabel NO-UNDO.
    DEF OUTPUT PARAMETER de-saldo        AS DECIMAL                 NO-UNDO.

    DEF VAR de-qtidade-atu AS DEC NO-UNDO.

    FIND FIRST w-estabel NO-LOCK 
        WHERE w-estabel.cod-estabel = b-saldo.cod-estabel
          AND w-estabel.considera NO-ERROR.
    IF NOT AVAIL w-estabel OR NOT deposito.cons-saldo THEN RETURN.

  &if '{&bf_lote_avancado_liberado}' = 'yes' &then 
    ASSIGN l-retorno = YES.  

    IF l-lote-avancado AND b-item.tipo-con-est > 2 THEN DO:

        RUN pi-identifica-saldo IN h-ceapi030 (INPUT 1,
                                               INPUT b-saldo.it-codigo,
                                               INPUT b-saldo.cod-estabel,
                                               INPUT b-saldo.lote,
                                               INPUT 0,
                                               OUTPUT l-retorno,
                                               OUTPUT TABLE tt-valores2,
                                               OUTPUT TABLE tt-erro).
    END.

    IF l-retorno THEN DO:
  &endif

     &IF DEFINED (bf_man_per_ppm) &THEN
       ASSIGN de-qtidade-atu = IF NOT (param-global.modulo-per-ppm 
                                   AND b-item.tipo-formula >= 2    
                                   AND b-item.tipo-formula <= 3) THEN b-saldo.qtidade-atu
                               ELSE f-conv-qtde(b-saldo.qtidade-atu, 
                                                b-saldo.per-ppm,
                                                b-item.per-ppm)
              de-saldo = de-saldo + de-qtidade-atu - b-saldo.qt-alocada - b-saldo.qt-aloc-prod - b-saldo.qt-aloc-ped.
     &ELSE
               ASSIGN de-qtidade-atu = b-saldo.qtidade-atu
                      de-saldo       = de-saldo + de-qtidade-atu - b-saldo.qt-alocada - b-saldo.qt-aloc-prod - b-saldo.qt-aloc-ped.
     &ENDIF

     &IF DEFINED(CUSTOM_GRENDENE) &THEN 
         ASSIGN de-saldo = de-saldo + de-qtidade-atu + b-saldo.qt-alocada + b-saldo.qt-aloc-prod + b-saldo.qt-aloc-ped.
     &ENDIF

  &if '{&bf_lote_avancado_liberado}' = 'yes' &then 
    END.
  &endif

    if  b-item.tipo-con-est = 4 
    or  pl-prod.log-multi-estabel then do:
        find pl-ext-item 
            where pl-ext-item.num-calc-plano = pl-prod.num-calc-plano 
              and pl-ext-item.cod-estabel    = c-estabel-param 
              and pl-ext-item.it-codigo      = b-item.it-codigo 
              and pl-ext-item.cod-refer      = b-saldo.cod-refer exclusive-lock no-error.
        if  not avail pl-ext-item then do:

            &if "{&mgind_dbtype}" <> "progress" &then
                assign error-status:error = false.
            &endif

            create pl-ext-item.
            assign pl-ext-item.num-calc-plano = pl-prod.num-calc-plano
                   pl-ext-item.cod-estabel    = c-estabel-param
                   pl-ext-item.it-codigo      = b-item.it-codigo
                   pl-ext-item.cod-refer      = b-saldo.cod-refer no-error.

            &if "{&mgind_dbtype}" <> "progress" &then
                if not error-status:error then
                    validate pl-ext-item.       
            &endif

        end.

      &if '{&bf_lote_avancado_liberado}' = 'yes' &then
        assign l-retorno = yes.  

        if l-lote-avancado and
           b-item.tipo-con-est > 2 then do:

            run pi-identifica-saldo in h-ceapi030 (input 1,
                                                   input b-saldo.it-codigo,
                                                   input b-saldo.cod-estabel,
                                                   input b-saldo.lote,
                                                   input 0,
                                                   output l-retorno,
                                                   output table tt-valores2,
                                                   output table tt-erro).
        end.

        if l-retorno then do:
      &endif

        ASSIGN pl-ext-item.qt-saldo = pl-ext-item.qt-saldo + de-qtidade-atu - b-saldo.qt-alocada - b-saldo.qt-aloc-prod - b-saldo.qt-aloc-ped no-error.

        &IF DEFINED(CUSTOM_GRENDENE) &THEN 
            assign pl-ext-item.qt-saldo = pl-ext-item.qt-saldo + de-qtidade-atu + b-saldo.qt-alocada + b-saldo.qt-aloc-prod + b-saldo.qt-aloc-ped no-error.
        &ENDIF

      &if '{&bf_lote_avancado_liberado}' = 'yes' &then
        end.
      &endif


        &if "{&mgind_dbtype}" <> "progress" &then
            if not error-status:error then
                validate pl-ext-item.
        &endif
    end.

END PROCEDURE.

RETURN "OK":U.

   

    
