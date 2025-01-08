/***********************************************************************
**  Programa..: upc\im0100-upca.p
**  Autor.....: Anderson Silvano  - Gestech
**  Data......: JUNHO/2005 - Desenvolvimento
**  Descricao.: 
**  Vers∆o....: 001 - 00/00/2002
**                  Desenvolvimento Programa
************************************************************************/

DEFINE NEW GLOBAL SHARED VARIABLE wh-btConf       AS HANDLE   NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE gr-docum-est    AS ROWID    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE gr-docum-estAtu AS ROWID            NO-UNDO.

DEF BUFFER b-docum-est FOR docum-est.

DEF VAR l-depos-cq-nok      AS LOGICAL              NO-UNDO.
DEF VAR c-cod-item          LIKE wm-item.cod-item   NO-UNDO.
DEF VAR l-validacao         AS LOGICAL              NO-UNDO.

FIND FIRST b-docum-est NO-LOCK
    WHERE ROWID(b-docum-est) = gr-docum-est NO-ERROR.
IF AVAIL b-docum-est THEN DO:
    IF  b-docum-est.cod-estabel <> "105"
    AND (b-docum-est.nat-operacao BEGINS "1101"
    OR b-docum-est.nat-operacao BEGINS "1102"
    OR b-docum-est.nat-operacao BEGINS "2101" 
    OR b-docum-est.nat-operacao BEGINS "2102" 
    OR b-docum-est.nat-operacao BEGINS "3101"
    OR b-docum-est.nat-operacao BEGINS "3102") THEN DO:
        FOR EACH   item-doc-est NO-LOCK
             WHERE item-doc-est.serie-docto  = b-docum-est.serie-docto
             AND   item-doc-est.nro-docto    = b-docum-est.nro-docto
             AND   item-doc-est.cod-emitente = b-docum-est.cod-emitente
             AND   item-doc-est.nat-operacao = b-docum-est.nat-operacao
             AND   item-doc-est.it-codigo   <> "":
            FIND FIRST rat-lote NO-LOCK
               WHERE rat-lote.serie-docto  = item-doc-est.serie-docto
               AND   rat-lote.nro-docto    = item-doc-est.nro-docto
               AND   rat-lote.cod-emitente = item-doc-est.cod-emitente
               AND   rat-lote.nat-operacao = item-doc-est.nat-operacao
               AND   rat-lote.sequencia    = item-doc-est.sequencia
               AND   rat-lote.cod-depos    = "REC" NO-ERROR.
            IF NOT AVAIL rat-lote THEN 
                
        END.
    END.

    IF b-docum-est.nat-operacao BEGINS "3" THEN DO:
        FOR EACH dupli-apagar
           WHERE dupli-apagar.serie-docto       = b-docum-est.serie-docto
           AND   dupli-apagar.nro-docto         = b-docum-est.nro-docto
           AND   dupli-apagar.cod-emitente      = b-docum-est.cod-emitente
           AND   dupli-apagar.nat-operacao      = b-docum-est.nat-operacao EXCLUSIVE-LOCK:
            ASSIGN dupli-apagar.tp-despesa = 2.
        END.
    END.

    FIND FIRST dupli-apagar NO-LOCK
        WHERE dupli-apagar.serie-docto       = b-docum-est.serie-docto
        AND   dupli-apagar.nro-docto         = b-docum-est.nro-docto
        AND   dupli-apagar.cod-emitente      = b-docum-est.cod-emitente
        AND   dupli-apagar.nat-operacao      = b-docum-est.nat-operacao NO-ERROR.
    IF AVAIL dupli-apagar THEN DO:
        FOR EACH item-doc-est OF b-docum-est NO-LOCK:
            FOR FIRST ordem-compra 
                WHERE ordem-compra.numero-ordem = item-doc-est.numero-ordem EXCLUSIVE-LOCK:
                ASSIGN ordem-compra.tp-despesa  = dupli-apagar.tp-despesa.
            END.
        END.
    END.
    ASSIGN gr-docum-estAtu = gr-docum-est.

    ASSIGN l-depos-cq-nok = NO.
    FIND FIRST docum-est WHERE
         ROWID(docum-est) = gr-docum-est NO-LOCK NO-ERROR.
    
    FOR EACH rat-lote OF docum-est NO-LOCK:
        
        ASSIGN l-validacao = NO.
        FOR EACH item-uni-estab NO-LOCK
            WHERE item-uni-estab.cod-estabel  = docum-est.cod-estabel
              AND item-uni-estab.it-codigo    = rat-lote.it-codigo,
            EACH wm-local NO-LOCK
            WHERE wm-local.cod-estabel = item-uni-estab.cod-estabel
              AND wm-local.cod-depos   = item-uni-estab.deposito-pad,
            EACH wm-local-deposito NO-LOCK
            WHERE wm-local-deposito.cod-estabel = wm-local.cod-estabel
              AND wm-local-deposito.cod-local   = wm-local.cod-local
              AND wm-local-deposito.cod-depos   = rat-lote.cod-depos:
            ASSIGN l-validacao = YES.
        END.

        /*
        FIND FIRST wm-local-deposito WHERE
             wm-local-deposito.cod-estabel = docum-est.cod-estabel AND
             wm-local-deposito.cod-depos   = rat-lote.cod-depos    NO-LOCK NO-ERROR.
        */

        IF l-validacao = YES AND
           CAN-FIND(FIRST deposito WHERE
                    deposito.cod-depos  = rat-lote.cod-depos AND
                    deposito.ind-dep-cq = YES                NO-LOCK) THEN DO:

            /*
            FIND FIRST wm-local WHERE
                wm-local.cod-estabel = wm-local-deposito.cod-estabel AND
                wm-local.cod-local   = wm-local-deposito.cod-local   NO-LOCK NO-ERROR.
            */

            IF NOT AVAIL wm-local OR
               NOT CAN-FIND(FIRST wm-item WHERE 
                            wm-item.cod-item = rat-lote.it-codigo AND
                            wm-item.log-1    = YES                NO-LOCK) OR
               CAN-FIND(FIRST wms-item-estab-local WHERE
                        wms-item-estab-local.cod-estab           = wm-local.cod-estabel AND
                        wms-item-estab-local.cod-local           = wm-local.cod-local   AND
                        wms-item-estab-local.cod-item            = rat-lote.it-codigo   AND
                        wms-item-estab-local.log-armaz-estado-cq = NO                   NO-LOCK) OR
               NOT CAN-FIND(FIRST item-uni-estab WHERE
                        item-uni-estab.cod-estabel  = docum-est.cod-estabel AND
                        item-uni-estab.it-codigo    = rat-lote.it-codigo    AND
                        item-uni-estab.deposito-pad = wm-local.cod-depos    NO-LOCK) THEN DO:

                ASSIGN l-depos-cq-nok = YES
                       c-cod-item     = rat-lote.it-codigo.
                LEAVE.
            END.
        END.
    END.

   

    /* Se encontrar item na tabela de skype lote, n∆o deve validar a entrada do material */
    IF l-depos-cq-nok THEN DO:
        FIND FIRST item-uni-estab NO-LOCK
             WHERE item-uni-estab.it-codigo   = c-cod-item   
               AND item-uni-estab.cod-estabel = docum-est.cod-estab NO-ERROR.
        IF AVAIL item-uni-estab THEN DO:
            FIND FIRST wm-local NO-LOCK
                 WHERE wm-local.cod-estabel = item-uni-estab.cod-estabel
                   AND wm-local.cod-depos   = item-uni-estab.deposito-pad NO-ERROR.
            IF AVAIL wm-local THEN DO:
                FIND FIRST wm-local-deposito 
                     WHERE wm-local-deposito.cod-estabel = wm-local.cod-estab
                       AND wm-local-deposito.cod-local   = wm-local.cod-local
                       AND wm-local-deposito.cod-depos   = 'REC'   NO-LOCK NO-ERROR.
                IF AVAIL wm-local-deposito THEN DO:
                    FIND FIRST int-item-fornec-skip-lote NO-LOCK
                         WHERE int-item-fornec-skip-lote.it-codigo    = c-cod-item
                           AND int-item-fornec-skip-lote.cod-emitente = 0 NO-ERROR.
                    IF NOT AVAIL int-item-fornec-skip-lote THEN 
                        ASSIGN l-depos-cq-nok = NO.
                    ELSE DO:
                        FIND FIRST wm-item NO-LOCK
                             WHERE wm-item.cod-item = c-cod-item NO-ERROR.
                        IF AVAIL wm-item AND wm-item.log-1 = YES THEN DO:
                            FIND FIRST wms-item-estab-local NO-LOCK
                                 WHERE wms-item-estab-local.cod-estab = wm-local-deposito.cod-estabel
                                   AND wms-item-estab-local.cod-local = wm-local-deposito.cod-local
                                   AND wms-item-estab-local.cod-item  = c-cod-item NO-ERROR.
                            IF AVAIL wms-item-estab-local AND wms-item-estab-local.log-armaz-estado-cq = YES THEN
                                ASSIGN l-depos-cq-nok = NO.
                        END.
                    END.
                END.
            END.
        END.
    END.

    IF l-depos-cq-nok = YES THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW",
                           INPUT 17006,
                           INPUT "Parametrizaá∆o CQ incompleta~~Parametrizaá∆o da integraá∆o do Controle de Qualidade com o WMS deve ser revista para o item " + c-cod-item + ".").
        RETURN "NOK":U.
    END.

END.

IF VALID-HANDLE(wh-btConf) THEN
    APPLY "choose" TO wh-btConf.













