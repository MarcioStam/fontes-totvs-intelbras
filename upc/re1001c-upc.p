/***********************************************************************
**  Programa..: upc\re1001c-upc.p
**  Autor.....: Gustavo Eduardo Tamanini - SQL WORKS
**  Data......: Abril/2010
**  Descricao.: 
**  Vers∆o....: 001 25/05/2010 - Gustavo Eduardo Tamanini
**                  Desenvolvimento Programa
************************************************************************/
DEF INPUT PARAM p-ind-event        AS CHAR          NO-UNDO.
DEF INPUT PARAM p-ind-object       AS CHAR          NO-UNDO.
DEF INPUT PARAM p-wgh-object       AS HANDLE        NO-UNDO.
DEF INPUT PARAM p-wgh-frame        AS WIDGET-HANDLE NO-UNDO.
DEF INPUT PARAM p-cod-table        AS CHAR          NO-UNDO.
DEF INPUT PARAM p-row-table        AS ROWID         NO-UNDO.

def new global shared var v_cod_empres_usuar
    as character
    format "x(3)":U
    label "Empresa"
    column-label "Empresa"
    no-undo.

{rep/re9343.i}

DEF VAR c-objeto    AS CHAR     NO-UNDO.
DEF VAR l-ok        AS LOGICAL  NO-UNDO.
DEF VAR h-frame     AS HANDLE   NO-UNDO.
DEF VAR h-fpage1    AS HANDLE   NO-UNDO.
DEFINE VARIABLE h-calc AS HANDLE      NO-UNDO.

DEF NEW GLOBAL SHARED VAR wh-dt-vencim-re1001c    AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-dt-emis-re1001c      AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-cod-esp-re1001c      AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-tp-despesa-re1001c   AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR gr-docum-est            AS ROWID         NO-UNDO.
DEF NEW GLOBAL SHARED VAR gr-dupli-apagar-re1001c AS ROWID         NO-UNDO.


DEFINE VARIABLE i-num-pedido LIKE item-doc-est.num-pedido NO-UNDO.
DEFINE VARIABLE dat-vencim   LIKE dupli-apagar.dt-vencim  NO-UNDO.
DEFINE VARIABLE dat-emissao  AS DATE        NO-UNDO.
/*
ASSIGN c-objeto = ENTRY(NUM-ENTRIES(p-wgh-object:FILE-NAME,"~/"), p-wgh-object:FILE-NAME,"~/").
ASSIGN c-objeto = ENTRY(NUM-ENTRIES(p-wgh-object:PRIVATE-DATA, "~/"), p-wgh-object:PRIVATE-DATA, "~/").

MESSAGE "Evento: ":U p-ind-event         SKIP
        "Objeto: ":U p-ind-object        SKIP
        "Tabela: ":U p-cod-table         SKIP
        "Rowid: ":U  STRING(p-row-table) SKIP
        "Objeto: ":U c-objeto
    VIEW-AS ALERT-BOX.
    */
    
   

IF  p-ind-event = "AFTER-DISPLAY":U AND p-ind-object = "CONTAINER":U THEN DO:
    FIND dupli-apagar NO-LOCK
        WHERE rowid(dupli-apagar) = p-row-table NO-ERROR.

    IF  AVAIL dupli-apagar THEN
        ASSIGN gr-dupli-apagar-re1001c = rowid(dupli-apagar).
END.

IF p-ind-event = "BEFORE-INITIALIZE":U AND p-ind-object = "CONTAINER":U THEN DO:

    ASSIGN h-frame = p-wgh-frame:FIRST-CHILD.
    ASSIGN h-frame = h-frame:FIRST-CHILD.

    DO WHILE VALID-HANDLE(h-frame):
        IF h-frame:TYPE <> "field-group":U THEN DO:
            CASE h-frame:NAME:
                WHEN "fPage1":U THEN ASSIGN h-fpage1 = h-frame.                
            END CASE.
            ASSIGN h-frame = h-frame:NEXT-SIBLING NO-ERROR.
        END.
        ELSE LEAVE.
    END.

    ASSIGN h-fpage1 = h-fpage1:FIRST-CHILD.
    ASSIGN h-fpage1 = h-fpage1:FIRST-CHILD.

    DO WHILE VALID-HANDLE(h-fpage1):
        IF h-fpage1:TYPE <> "field-group" THEN DO:
            CASE h-fpage1:NAME:
                WHEN "dt-vencim":U THEN ASSIGN wh-dt-vencim-re1001c = h-fpage1.
                WHEN "cod-esp":U THEN ASSIGN wh-cod-esp-re1001c = h-fpage1.
                WHEN "dt-emissao":U THEN ASSIGN wh-dt-emis-re1001c = h-fpage1.
                WHEN "tp-despesa":U THEN ASSIGN wh-tp-despesa-re1001c = h-fpage1.
            END CASE.
            ASSIGN h-fpage1 = h-fpage1:NEXT-SIBLING NO-ERROR.
        END.
        ELSE LEAVE.
    END.    
END.

IF p-ind-event = "AFTER-DISPLAY":U AND p-ind-object = "CONTAINER":U THEN DO:

    FIND FIRST docum-est WHERE 
         ROWID(docum-est) = gr-docum-est NO-LOCK NO-ERROR.

    IF AVAIL docum-est THEN DO:
        FIND FIRST item-doc-est OF docum-est NO-LOCK NO-ERROR.
        IF NOT AVAIL item-doc-est THEN RETURN "NOK":U.

        IF VALID-HANDLE(wh-dt-vencim-re1001c) THEN DO:

            FIND FIRST natur-oper NO-LOCK
                WHERE natur-oper.nat-operacao = docum-est.nat-operacao NO-ERROR.

            IF AVAIL natur-oper THEN DO:
                FIND FIRST int-natur-oper NO-LOCK
                     WHERE int-natur-oper.nat-operacao = natur-oper.nat-operacao NO-ERROR.
                 
                FIND dupli-apagar NO-LOCK
                    WHERE rowid(dupli-apagar) = gr-dupli-apagar-re1001c NO-ERROR.
            
                IF AVAIL int-natur-oper THEN DO:

                    IF  NOT AVAIL dupli-apagar THEN
                        ASSIGN wh-cod-esp-re1001c:SCREEN-VALUE = int-natur-oper.cod-esp-apb.

                    IF int-natur-oper.cod-esp-apb = "DF" THEN DO:

                        ASSIGN wh-tp-despesa-re1001c:SCREEN-VALUE = "3".
                        ASSIGN dat-emissao = DATE(wh-dt-emis-re1001c:SCREEN-VALUE) NO-ERROR.

                        IF dat-emissao <> ? THEN DO:
                            IF DAY(dat-emissao) <= 15 THEN DO:
                                IF MONTH(dat-emissao) = 12 THEN 
                                    ASSIGN dat-vencim = DATE(12,31,YEAR(dat-emissao)).
                                ELSE
                                    ASSIGN dat-vencim = DATE(MONTH(dat-emissao) + 1, 01, YEAR(dat-emissao)) - 1.
                            END.
                            ELSE DO:
                                IF MONTH(dat-emissao) = 12 THEN 
                                    ASSIGN dat-vencim = DATE(01,15,YEAR(dat-emissao) + 1).
                                ELSE
                                    ASSIGN dat-vencim = DATE(MONTH(dat-emissao) + 1, 15, YEAR(dat-emissao)).
                            END.
                            ASSIGN wh-dt-vencim-re1001c:SCREEN-VALUE = STRING(dat-vencim,"99/99/9999":U).
                        END.
                    END.
                    ELSE DO:
                        ASSIGN i-num-pedido = item-doc-est.num-pedido.

                        IF i-num-pedido = 0 THEN DO:
                            FIND FIRST rat-ordem 
                                 WHERE rat-ordem.cod-emitente = item-doc-est.cod-emitente
                                   AND rat-ordem.serie-docto  = item-doc-est.serie-docto
                                   AND rat-ordem.nro-docto    = item-doc-est.nro-docto
                                   AND rat-ordem.nat-operacao = item-doc-est.nat-operacao 
                                   AND rat-ordem.sequencia    = item-doc-est.sequencia NO-LOCK NO-ERROR.

                            IF AVAIL rat-ordem THEN
                                ASSIGN i-num-pedido = rat-ordem.num-pedido.
                            ELSE
                                RETURN "NOK":U.
                        END.

                        FIND FIRST pedido-compr WHERE
                                   pedido-compr.num-pedido = i-num-pedido NO-LOCK NO-ERROR.

                        FIND FIRST cond-pagto WHERE
                                   cond-pagto.cod-cond-pag = pedido-compr.cod-cond-pag NO-LOCK NO-ERROR.

                        IF AVAIL cond-pagto THEN DO:
                            FIND FIRST int-cond-pagto WHERE
                                       int-cond-pagto.cod-cond-pag = cond-pagto.cod-cond-pag NO-LOCK NO-ERROR. 

                            IF AVAIL int-cond-pagto THEN DO:
                                /** Carta Credito **/
                                IF SUBSTRING(int-cond-pagto.char-1,2,1) = "S" THEN DO:
                                    ASSIGN dat-vencim = DATE(wh-dt-vencim-re1001c:SCREEN-VALUE)
                                           dat-vencim = dat-vencim - 2.

                                    IF  WEEKDAY(dat-vencim) = 1 OR
                                        WEEKDAY(dat-vencim) = 7 THEN
                                        ASSIGN dat-vencim = dat-vencim - 2.

                                    FIND FIRST param-estoq  NO-LOCK NO-ERROR.
                                    FIND FIRST param-global NO-LOCK NO-ERROR.

                                    REPEAT:
                                        FIND FIRST calen-coml
                                             WHERE calen-coml.cod-estabel = param-estoq.estabel-pad
                                             AND   calen-coml.ep-codigo   = param-global.empresa-prin
                                             AND   calen-coml.data        = dat-vencim NO-LOCK NO-ERROR.

                                        IF AVAIL calen-coml AND calen-coml.tipo-dia <> 1 THEN
                                            ASSIGN dat-vencim = dat-vencim - 1.
                                        ELSE
                                            LEAVE.
                                    END.

                                    ASSIGN wh-dt-vencim-re1001c:SCREEN-VALUE = STRING(dat-vencim,"99/99/9999":U).
                                END.
                            END.
                        END.
                    END.
                END.
            END.
        END.
    END.
END.

IF p-ind-event = "AFTER-ASSIGN" THEN DO:
    FIND FIRST docum-est WHERE 
         ROWID(docum-est) = gr-docum-est NO-LOCK NO-ERROR.

    IF AVAIL docum-est THEN DO:
       FIND FIRST int-natur-oper NO-LOCK
            WHERE int-natur-oper.nat-operacao = docum-est.nat-operacao NO-ERROR.
       IF AVAIL int-natur-oper AND int-natur-oper.cod-observa = 4 /*Servico*/ THEN DO:
          CREATE tt_param_integr_imptos_apb.
          ASSIGN tt_param_integr_imptos_apb.tta_cod_empresa       = v_cod_empres_usuar
                 tt_param_integr_imptos_apb.tta_cdn_fornecedor    = docum-est.cod-emitente 
                 tt_param_integr_imptos_apb.tta_cod_estab         = docum-est.cod-estabel
                 tt_param_integr_imptos_apb.tta_val_pagto_tit_ap  = 1 /* Passar o valor fixo 1 */
                 tt_param_integr_imptos_apb.tta_dat_transacao     = docum-est.dt-trans
                 tt_param_integr_imptos_apb.tta_dat_emis_docto    = docum-est.dt-emissao
                 tt_param_integr_imptos_apb.tta_dat_vencto_tit_ap = docum-est.dt-trans
                 tt_param_integr_imptos_apb.ttv_log_impto_obrig   = NO.             
          
          RUN prgfin/apb/apb719za.py PERSISTENT SET  h-calc.                   
          RUN pi_main_retorna_impostos_calculados_01 IN h-calc (INPUT  TABLE tt_param_integr_imptos_apb,                                                                         
                                                                OUTPUT TABLE tt_integr_imptos_pgto_apb,
                                                                OUTPUT TABLE tt_erros_integr_imptos_apb).          
          DELETE PROCEDURE h-calc.
          ASSIGN h-calc = ?.   
          
          if can-find(first tt_integr_imptos_pgto_apb) then do: 
             {utp/ut-liter.i "geraá∆o_das_Duplicatas_de_Impostos" *}
             RUN utp/ut-msgs.p (INPUT "show":u, 
                                INPUT 701, 
                                INPUT RETURN-VALUE).
             IF RETURN-VALUE = "YES" THEN DO:
                 run piGeraImpto.
             END.
          END.    
       END.
    END.
    
END.

IF  p-ind-event = "AFTER-DESTROY":U AND p-ind-object = "CONTAINER":U THEN 
    ASSIGN gr-dupli-apagar-re1001c = ?.

PROCEDURE piGeraImpto:
   empty temp-table RowErrors.
   empty temp-table tt-dupli-apagar.

   FOR EACH dupli-apagar NO-LOCK
      WHERE ROWID(dupli-apagar) = p-row-table:
       CREATE tt-dupli-apagar.
       BUFFER-COPY dupli-apagar TO tt-dupli-apagar.
       ASSIGN tt-dupli-apagar.r-Rowid = ROWID(dupli-apagar).
   END.
        
   run rep/re9343.p (input table tt-dupli-apagar, output table RowErrors).
END PROCEDURE.


