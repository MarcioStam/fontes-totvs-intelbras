/********************************************************************************
**
**   Include: CE0111.i - Atualiza Movimentos, Producao, Documentos e Ficha-CQ
**
********************************************************************************/
DISABLE TRIGGERS FOR LOAD OF saldo-estoq.
DISABLE TRIGGERS FOR LOAD OF inventario.
DISABLE TRIGGERS FOR LOAD OF fat-ser-lote.
DISABLE TRIGGERS FOR LOAD OF it-dep-fat.

HIDE MESSAGE NO-PAUSE.

{utp/ut-liter.i Alterando_movimentacoes... mce l}

RUN pi-acompanhar IN h-acomp (INPUT TRIM(RETURN-VALUE)).

FOR EACH movto-estoq USE-INDEX item-data
   WHERE movto-estoq.it-codigo  = item.it-codigo
     AND movto-estoq.dt-trans   < tt-param.dt-referencia EXCLUSIVE-LOCK:

    ASSIGN movto-estoq.lote      = {1}
           movto-estoq.cod-refer = {2}.
END.

FOR EACH movto-mat USE-INDEX onde-usou
   WHERE movto-mat.it-codigo = item.it-codigo 
     AND movto-mat.dt-trans  < tt-param.dt-referencia EXCLUSIVE-LOCK:

    ASSIGN movto-mat.lote = {1}.
END.

FOR EACH saldo-terc USE-INDEX
    &IF "{&bf_mat_versao_ems}" >= "2.05" &THEN item-emit &ELSE item &ENDIF
    WHERE saldo-terc.it-codigo  = item.it-codigo 
      AND saldo-terc.dt-retorno < tt-param.dt-referencia EXCLUSIVE-LOCK:

    ASSIGN saldo-terc.lote      = {1}
           saldo-terc.cod-refer = {2}.

    FOR EACH componente OF saldo-terc USE-INDEX item
       WHERE componente.it-codigo  = item.it-codigo EXCLUSIVE-LOCK:
    
        ASSIGN componente.lote      = {1}
               componente.cod-refer = {2}.

        FOR EACH rat-componente 
           WHERE rat-componente.serie-docto  = componente.serie-docto
             AND rat-componente.nro-docto    = componente.nro-docto
             AND rat-componente.cod-emitente = componente.cod-emitente
             AND rat-componente.nat-operacao = componente.nat-operacao
             AND rat-componente.it-codigo    = componente.it-codigo EXCLUSIVE-LOCK:
        
            ASSIGN rat-componente.lote         = {1}
                   rat-componente.cod-refer    = {2}
                   rat-componente.dt-vali-lote = {3}.
        END.

    END.

    FOR EACH rat-saldo-terc 
       WHERE rat-saldo-terc.cod-emitente = saldo-terc.cod-emitente
         AND rat-saldo-terc.serie        = saldo-terc.serie-docto  
         AND rat-saldo-terc.nro-docto    = saldo-terc.nro-docto  
         AND rat-saldo-terc.nat-operacao = saldo-terc.nat-operacao 
         AND rat-saldo-terc.it-codigo    = saldo-terc.it-codigo EXCLUSIVE-LOCK:
    
        ASSIGN rat-saldo-terc.lote         = {1}
               rat-saldo-terc.cod-refer    = {2}
               rat-saldo-terc.dt-vali-lote = {3}.

    END.

END.

IF param-global.modulo-cp THEN DO:

    HIDE MESSAGE NO-PAUSE.

    {utp/ut-liter.i Alterando_Ordens_de_Producao... mce l}

    RUN pi-acompanhar IN h-acomp (INPUT TRIM(RETURN-VALUE)).

    FOR EACH ord-prod USE-INDEX item
       WHERE ord-prod.it-codigo   = item.it-codigo 
         AND ord-prod.dt-emissao < tt-param.dt-referencia EXCLUSIVE-LOCK:

        ASSIGN ord-prod.lote-serie = {1}
               ord-prod.cod-refer  = {2}.

        FOR EACH reservas USE-INDEX data
           WHERE reservas.it-codigo   = item.it-codigo
             AND reservas.nr-ord-prod = ord-prod.nr-ord-prod EXCLUSIVE-LOCK:
    
            FIND FIRST b-reservas
                 WHERE b-reservas.nr-ord-produ = reservas.nr-ord-produ
                   AND b-reservas.item-pai     = reservas.item-pai     
                   AND b-reservas.cod-roteiro  = reservas.cod-roteiro  
                   AND b-reservas.op-codigo    = reservas.op-codigo    
                   AND b-reservas.it-codigo    = reservas.it-codigo    
                   AND b-reservas.cod-refer    = {2} EXCLUSIVE-LOCK NO-ERROR.
    
            IF NOT AVAIL b-reservas THEN
                ASSIGN reservas.lote-serie = {1}
                       reservas.cod-refer  = {2}.
            ELSE DO:
    
                IF ROWID(reservas) <> ROWID(b-reservas) THEN DO:
    
                    ASSIGN b-reservas.quant-orig   = b-reservas.quant-orig   + reservas.quant-orig
                           b-reservas.quant-atend  = b-reservas.quant-atend  + reservas.quant-atend
                           b-reservas.quant-requis = b-reservas.quant-requis + reservas.quant-requis
                           b-reservas.quant-aloc   = b-reservas.quant-aloc   + reservas.quant-aloc
                           b-reservas.quant-terc   = b-reservas.quant-terc   + reservas.quant-terc
                           b-reservas.quant-aplic  = b-reservas.quant-aplic  + reservas.quant-aplic.
    
                    DELETE reservas.

                END.
            END.
        END.
    
        FOR EACH aloca-reserva USE-INDEX saldo
           WHERE aloca-reserva.it-codigo   = item.it-codigo 
             AND aloca-reserva.nr-ord-prod = ord-prod.nr-ord-prod EXCLUSIVE-LOCK:
    
            ASSIGN aloca-reserva.lote-serie = {1}.
    
            &IF DEFINED (bf_man_sfc_lc) &THEN
            ASSIGN aloca-reserva.cod-refer  = {2}.
            &ENDIF  
        END.
    
        FOR EACH rep-prod use-index item-dat
           WHERE rep-prod.it-codigo   = item.it-codigo 
             AND rep-prod.data        < tt-param.dt-referencia EXCLUSIVE-LOCK:
    
            ASSIGN rep-prod.lote-serie   = {1}
                   rep-prod.cod-refer    = {2}
                   rep-prod.dt-vali-lote = {3}.
        END.
    END.
END.

HIDE MESSAGE NO-PAUSE.

{utp/ut-liter.i Alterando_Documentos... mce l}

RUN pi-acompanhar IN h-acomp (INPUT TRIM(RETURN-VALUE)).

FOR EACH item-doc-est NO-LOCK
   WHERE item-doc-est.it-codigo = item.it-codigo:

    FIND FIRST b-item-doc-est EXCLUSIVE-LOCK
         WHERE ROWID(b-item-doc-est) = ROWID(item-doc-est) NO-ERROR.

    ASSIGN b-item-doc-est.lote         = {1}
           b-item-doc-est.cod-refer    = {2}
           b-item-doc-est.dt-vali-lote = {3}.
END.

FOR EACH rat-lote NO-LOCK
   WHERE rat-lote.it-codigo = item.it-codigo:

    FIND FIRST b-rat-lote EXCLUSIVE-LOCK
         WHERE ROWID(b-rat-lote) = ROWID(rat-lote) NO-ERROR.

    ASSIGN b-rat-lote.lote         = {1}
           b-rat-lote.dt-vali-lote = {3}.
END.

FOR EACH ficha-cq USE-INDEX item-ficha EXCLUSIVE-LOCK
   WHERE ficha-cq.it-codigo = item.it-codigo
     AND ficha-cq.dt-ficha < tt-param.dt-referencia:

    ASSIGN ficha-cq.lote      = {1}
           ficha-cq.cod-refer = {2}.
END.

HIDE MESSAGE NO-PAUSE.

{utp/ut-liter.i Atualizando_Inventario... mce R}

RUN pi-acompanhar IN h-acomp (INPUT TRIM(RETURN-VALUE)).

FOR EACH inventario USE-INDEX item
   WHERE inventario.it-codigo = item.it-codigo 
     AND inventario.dt-saldo  < tt-param.dt-referencia EXCLUSIVE-LOCK:

    FOR EACH b-invent
       WHERE b-invent.dt-saldo    = inventario.dt-saldo
         AND b-invent.cod-estabel = inventario.cod-estabel
         AND b-invent.cod-depos   = inventario.cod-depos
         AND b-invent.cod-localiz = inventario.cod-localiz
         AND b-invent.it-codigo   = inventario.it-codigo
         AND ROWID(b-invent)     <> ROWID(inventario) NO-LOCK:

        ASSIGN inventario.qtidade-atu  = inventario.qtidade-atu
                                       + b-invent.qtidade-atu
               inventario.valor-contab = inventario.valor-contab
                                       + b-invent.valor-contab
               inventario.valor-final  = inventario.valor-final
                                       + b-invent.valor-final.
        DO i-cont = 1 TO 3:
            
            ASSIGN inventario.val-apurado[i-cont] =
                         inventario.val-apurado[i-cont]
                         + b-invent.val-apurado[i-cont]
                   inventario.valor-mat-m[i-cont] =
                         inventario.valor-mat-m[i-cont]
                         + b-invent.valor-mat-m[i-cont]
                   inventario.valor-mat-o[i-cont] =
                         inventario.valor-mat-o[i-cont]
                         + b-invent.valor-mat-o[i-cont]
                   inventario.valor-mat-p[i-cont] =
                         inventario.valor-mat-p[i-cont]
                         + b-invent.valor-mat-p[i-cont]
                   inventario.valor-mob-m[i-cont] =
                         inventario.valor-mob-m[i-cont]
                         + b-invent.valor-mob-m[i-cont]
                   inventario.valor-mob-o[i-cont] =
                         inventario.valor-mob-o[i-cont]
                         + b-invent.valor-mob-o[i-cont]
                   inventario.valor-mob-p[i-cont] =
                         inventario.valor-mob-p[i-cont]
                         + b-invent.valor-mob-p[i-cont]
                   inventario.valor-ggf-m[i-cont] =
                         inventario.valor-ggf-m[i-cont]
                         + b-invent.valor-ggf-m[i-cont]
                   inventario.valor-ggf-o[i-cont] =
                         inventario.valor-ggf-o[i-cont]
                         + b-invent.valor-ggf-o[i-cont]
                   inventario.valor-ggf-p[i-cont] =
                         inventario.valor-ggf-p[i-cont]
                         + b-invent.valor-ggf-p[i-cont].
        END.

        IF b-invent.dt-atualiza > inventario.dt-atualiza THEN
            ASSIGN inventario.dt-atualiza = b-invent.dt-atualiza.

        IF b-invent.dt-ult-entra > inventario.dt-ult-entra THEN
            ASSIGN inventario.dt-ult-entra = b-invent.dt-ult-entra.

        IF b-invent.dt-ult-saida > inventario.dt-ult-saida THEN
            ASSIGN inventario.dt-ult-saida = b-invent.dt-ult-saida.

        FIND FIRST b2-invent EXCLUSIVE-LOCK
             WHERE ROWID(b2-invent) = ROWID(b-invent) NO-ERROR.

        DELETE b2-invent VALIDATE(TRUE,"").
    END.

    ASSIGN inventario.lote = {1}.
END.

STATUS INPUT "".

/* fim include */
