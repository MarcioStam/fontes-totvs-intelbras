/******************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i esccp040rp 1.00.00.000}
/******************************************************************************
** Programa: esp/ccp/esccp040rp.p
** Autor...: SENSUS Tecnologia
*******************************************************************************/
&global-define programa ESCCP040RP

DEFINE BUFFER empresa FOR mgcad.empresa.

DEFINE VARIABLE c-nom-prog-dpc-mg97  as character init "" NO-UNDO.   
DEFINE VARIABLE c-nom-prog-appc-mg97 as character init "" NO-UNDO.
DEFINE VARIABLE c-nom-prog-upc-mg97  as character init "" NO-UNDO.

{esp/ccp/esccp040tt.i}
{upc/btb910za-upc.i}

DEFINE input parameter raw-param as raw no-undo.
DEFINE input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

{include/i-rpvar.i}    
{utp/ut-glob.i}

{utp/ut-liter.i O_P * r}             assign c-liter[1]  = trim (return-value).
{utp/ut-liter.i O_C* * r}            assign c-liter[2]  = trim (return-value).
{utp/ut-liter.i O_C * r}             assign c-liter[3]  = trim (return-value).
{utp/ut-liter.i O.S. * r}            assign c-liter[4]  = trim (return-value).
{utp/ut-liter.i Res * r}             assign c-liter[5]  = trim (return-value).
{utp/ut-liter.i P_V * r}             assign c-liter[6]  = trim (return-value).
{utp/ut-liter.i O_Pl * r}            assign c-liter[7]  = trim (return-value).
{utp/ut-liter.i R_Pl * r}            assign c-liter[8]  = trim (return-value).
{utp/ut-liter.i Negativo * r}        assign c-liter[9]  = trim (return-value).
{utp/ut-liter.i Abaixo_Qt_Segur * r} assign c-liter[10] = trim (return-value).

{esp/ccp/esccp032.i20}

ASSIGN c-plan-ini       = ''
       c-plan-fim       = ''
       i-nr-linha-ini   = 0
       i-nr-linha-fim   = 0
       c-estab-ini      = tt-param.estab-ini
       c-estab-fim      = tt-param.estab-fim.

/*---[ informa‡äes usadas na busca ]-----------------------*/
ASSIGN l-ord-comp       = tt-param.ord-comp
       l-ord-prod       = tt-param.ord-prod
       l-planejada      = tt-param.planejada
       l-res-comp       = tt-param.res-comp
       l-res-plan       = tt-param.res-plan
       l-sald-est       = tt-param.sald-est
       l-sald-terc      = tt-param.sald-terc
       l-remessa        = tt-param.remessa
       l-sald-est       = tt-param.sald-est
       l-entrada        = tt-param.entrada
       l-transfer       = tt-param.transfer
       l-remessa-con    = tt-param.re-con2
       l-ent-con        = tt-param.en-con2
       l-pedidos        = tt-param.pedidos
       l-cred-aprov     = tt-param.cred-aprov
       l-depositos      = NO
       p-remessa        = tt-param.remessa
       p-entrada        = tt-param.entrada
       p-transfer       = tt-param.transfer
       p-re-con         = tt-param.re-con
       p-en-con         = tt-param.en-con
       i-benefic        = tt-param.benefic
       c-estab-ini      = tt-param.estab-ini
       c-estab-fim      = tt-param.estab-fim
       c-unid-negoc-ini = tt-param.unid-negoc-ini
       c-unid-negoc-fim = tt-param.unid-negoc-fim
       da-dt-corte      = tt-param.dt-corte
       da-dt-plan       = tt-param.dt-plan
       i-cod-plano      = tt-param.cd-plano.
/*---------------------------------------------------------*/

do on stop undo, leave:

    ASSIGN c-arquivo-csv = "ESCCP040-" + trim(string(tt-param.embarque)) + ".csv":U.

    IF  OPSYS = "unix" THEN DO:
        EMPTY TEMP-TABLE tt-prog-ponto.
    
        RUN esp/es0018p.p (INPUT "SPOOL-UNIX":U,
                           INPUT 1,
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-ponto).
    
        FOR FIRST tt-prog-ponto:
            ASSIGN c-dir-saida = REPLACE(tt-prog-ponto.conteudo, "~\":U, "/":U).
        END. /* FOR FIRST tt-prog-ponto: */
    
        
        ASSIGN c-arq-excel = c-dir-saida + "/":U + tt-param.usuario + "/":U + TRIM(c-arquivo-csv).
    END. /* IF  OPSYS = "unix" THEN DO: */
    ELSE DO:
        EMPTY TEMP-TABLE tt-prog-ponto.
    
        RUN esp/es0018p.p (INPUT "SPOOL-WIN":U,
                           INPUT 1,
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-ponto).
    
        FOR FIRST tt-prog-ponto:
            ASSIGN c-dir-saida = REPLACE(tt-prog-ponto.conteudo, "/":U, "~\":U).
        END. /* FOR FIRST tt-prog-ponto: */
    
        ASSIGN c-arq-excel = c-dir-saida + "~\":U + tt-param.usuario + "~\":U + TRIM(c-arquivo-csv).
    END.
END.

/* ***************************  Main Block  *************************** */
FOR FIRST param-global NO-LOCK. END.
FOR FIRST empresa NO-LOCK WHERE empresa.ep-codigo = param-global.empresa-pri: END.

assign c-sistema      = 'ESP':U
       c-titulo-relat = 'Relat¢rio Cotas Manaus'
       c-empresa      = if avail empresa then empresa.razao-social else ''
       c-programa     = 'ESCCP040':U
       c-versao       = '1.00':U
       c-revisao      = '000':U.

DO ON STOP UNDO, LEAVE:
    {include/i-rpcab.i}    
    {include/i-rpout.i}
    
    VIEW FRAME f-cabec.
    VIEW FRAME f-rodape.

    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
    RUN pi-inicializar in h-acomp (input "Buscando ...").

    RUN piImprimeRelat.

    RUN pi-finalizar IN h-acomp.

    OUTPUT STREAM str-excel TO value(c-arq-excel) NO-CONVERT.
        PUT STREAM str-excel UNFORMATTED "Est;Embarque;Item;Descri‡Æo;Qt Embarque;Projeto;Descri‡Æo;Produto;Descri‡Æo;Qt. Reserva;Qt Rateio;Perc Rateio" SKIP.
    
        /* Imprime resumo por projeto */
        FOR EACH tt-itens-projeto
            BREAK BY tt-itens-projeto.c-item-filho
                  BY tt-itens-projeto.cod-projeto
                  BY tt-itens-projeto.c-item-acabado:

            IF  FIRST-OF(tt-itens-projeto.cod-projeto)
            THEN
                ASSIGN de-tot-reserva  = 0
                       de-tot-rateio   = 0
                       de-tot-perc-rat = 0.

            ASSIGN de-tot-reserva  = de-tot-reserva  + tt-itens-projeto.de-qtd-reserva
                   de-tot-rateio   = de-tot-rateio   + tt-itens-projeto.de-qtd-rateio
                   de-tot-perc-rat = de-tot-perc-rat + tt-itens-projeto.de-perc-rateio.

            IF  LAST-OF(tt-itens-projeto.cod-projeto)
            THEN
                PUT STREAM str-excel UNFORMATTED tt-param.estab-ini               ";"
                                                 tt-param.embarque                ";"
                                                 tt-itens-projeto.c-item-filho    ";"
                                                 tt-itens-projeto.c-des-item-emb  ";"
                                                 tt-itens-projeto.de-qtd-embarque ";"
                                                 tt-itens-projeto.cod-projeto     ";"
                                                 tt-itens-projeto.desc-projeto    ";"
                                                 ""                               ";"
                                                 ""                               ";"
                                                 de-tot-reserva                   ";"
                                                 de-tot-rateio                    ";"
                                                 de-tot-perc-rat  SKIP.
        END.

        PUT STREAM str-excel UNFORMATTED SKIP(2).

        PUT STREAM str-excel UNFORMATTED  "***;"
                                          "***;"
                                          "***;"
                                          "***;"
                                          "***;"
                                          "***;"
                                          "*** D E T A L H A D O *** ;"
                                          "***;"
                                          "***;"
                                          "***;"
                                          "***;"
                                          "***" SKIP(1).

        /* Imprime detalhado por produto acabado */
        PUT STREAM str-excel UNFORMATTED "Est;Embarque;Item;Descri‡Æo;Qt Embarque;Projeto;Descri‡Æo;Produto;Descri‡Æo;Qt. Reserva;Qt Rateio;Perc Rateio" SKIP.
        FOR EACH tt-itens-projeto
            BREAK BY tt-itens-projeto.c-item-filho
                  BY tt-itens-projeto.cod-projeto
                  BY tt-itens-projeto.c-item-acabado:

            PUT STREAM str-excel UNFORMATTED tt-param.estab-ini               ";"
                                             tt-param.embarque                ";"
                                             tt-itens-projeto.c-item-filho    ";"
                                             tt-itens-projeto.c-des-item-emb  ";"
                                             tt-itens-projeto.de-qtd-embarque ";"
                                             tt-itens-projeto.cod-projeto     ";"
                                             tt-itens-projeto.desc-projeto    ";"
                                             tt-itens-projeto.c-item-acabado  ";"
                                             tt-itens-projeto.c-des-item-pai  ";"
                                             tt-itens-projeto.de-qtd-reserva  ";"
                                             tt-itens-projeto.de-qtd-rateio   ";"
                                             tt-itens-projeto.de-perc-rateio  SKIP.
        END.
    OUTPUT STREAM str-excel CLOSE.

    PUT 
        "Estabelecimento ......................: " AT 01 tt-param.estab-ini SKIP
        "Embarque .............................: " AT 01 tt-param.embarque  SKIP
        "Unidade Neg¢cio ......................: " tt-param.unid-negoc-ini "|< >| " AT 45 tt-param.unid-negoc-fim SKIP
        "Data de Corte ........................: " tt-param.dt-corte FORMAT '99/99/9999':U SKIP
        "Data de Corte para Ordens Planejadas .: " tt-param.dt-plan  FORMAT '99/99/9999':U SKIP(2).

    IF tt-param.ord-comp   THEN PUT "[ X ]". ELSE PUT "[   ]". 
    PUT "Considera Ordens de Compra?":U AT 07 "Considera Saldos em Terceiros:" AT 56 SKIP.
    
    IF tt-param.ord-prod   then put "[ X ]". ELSE PUT "[   ]". 
    PUT "Considera Ordens de Produ‡Æo?":U AT 07.

    IF tt-param.remessa2 then put "[ X ]" AT 56. ELSE PUT "[   ]" AT 56.
    PUT "Remessa p/ Beneficiamento":U AT 62 SKIP.

    IF tt-param.planejada  then put "[ X ]". ELSE PUT "[   ]".
    PUT "Considera Ordens Planejadas?":U AT 07.

    IF tt-param.entrada2 then put "[ X ]" AT 56. ELSE PUT "[   ]" AT 56.
    PUT "Entrada p/ Beneficiamento":U AT 62 SKIP.

    IF tt-param.res-comp   then put "[ X ]". ELSE PUT "[   ]". 
    PUT "Considera Reservas Comprometidas?":U AT 07.

    IF tt-param.transfer2 then put "[ X ]" AT 56. ELSE PUT "[   ]" AT 56.
    PUT "Transferˆncia":U AT 62 SKIP.

    IF tt-param.res-plan   then put "[ X ]". ELSE PUT "[   ]". 
    PUT "Considera Reservas Planejadas?":U AT 07.

    IF tt-param.re-con2 then put "[ X ]" AT 56. ELSE PUT "[   ]" AT 56.
    PUT "Remessa em Consigna‡Æo":U AT 62 SKIP.

    IF tt-param.sald-est   then put "[ X ]". ELSE PUT "[   ]". 
    PUT "Considera Saldo em Estoque?":U AT 07.

    IF tt-param.en-con2 then put "[ X ]" AT 56. ELSE PUT "[   ]" AT 56.
    PUT "Entrada em Consigna‡Æo":U AT 62 SKIP.

    IF tt-param.sald-terc  then put "[ X ]". ELSE PUT "[   ]". 
    PUT "Considera Saldo em Poder de Terceiros?":U AT 07 SKIP.

    IF tt-param.pedidos    then put "[ X ]". ELSE PUT "[   ]". 
    PUT "Considera Pedidos em Carteira?":U AT 07 SKIP.

    IF tt-param.cred-aprov then put "[ X ]". ELSE PUT "[   ]". 
    PUT "Apenas Pedidos com Cr‚dito Aprovado?":U AT 07.

    PUT "Plano .: ":U AT 56 tt-param.cd-plano SKIP(2)
        "Ordens de Compra de Beneficiamento:":U AT 01 SKIP.

    CASE tt-param.benefic:
        WHEN 1 THEN PUT "( X ) Considera (   ) NÆo Considera (   ) Demonstra":U SKIP(2).
        WHEN 2 THEN PUT "(   ) Considera ( X ) NÆo Considera (   ) Demonstra":U SKIP(2).
        WHEN 3 THEN PUT "(   ) Considera (   ) NÆo Considera ( X ) Demonstra":U SKIP(2).
    END CASE.
    
    PUT "Arquivo excel gerado no caminho: " c-arq-excel SKIP.

    {include/i-rpclo.i}
    RETURN "OK".   
END.

/*---[ PROCEDURES INTERNAS ]-------------------------------------------------------------------------*/
PROCEDURE piImprimeRelat:

    DEFINE VARIABLE c-item-reserva AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE de-embarcada   AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE de-reservada   AS DECIMAL     NO-UNDO.

    EMPTY TEMP-TABLE tt-itens-relacao NO-ERROR.
    EMPTY TEMP-TABLE tt-itens-projeto NO-ERROR.
    EMPTY TEMP-TABLE tt-itens-embarque.

    FOR FIRST embarque-imp NO-LOCK
        WHERE embarque-imp.cod-estabel = tt-param.estab-ini
        AND   embarque-imp.embarque    = tt-param.embarque,
        EACH  ordens-embarque OF embarque-imp    NO-LOCK,
        FIRST ordem-compra    OF ordens-embarque NO-LOCK:
        
        RUN pi-acompanhar IN h-acomp (INPUT "Ordem Compra: " + STRING(ordem-compra.numero-ordem)).
        
        FIND FIRST tt-itens-embarque 
            WHERE  tt-itens-embarque.it-codigo = ordem-compra.it-codigo NO-ERROR.

        IF  NOT AVAIL tt-itens-embarque 
        THEN DO:
            CREATE tt-itens-embarque.
            ASSIGN tt-itens-embarque.it-codigo = ordem-compra.it-codigo.

            /* Simula‡Æo Estoque */
            FIND FIRST b-item NO-LOCK WHERE b-item.it-codigo = ordem-compra.it-codigo NO-ERROR.

            RUN pi-simulacao-estoque(BUFFER b-item,
                                     INPUT l-sald-est, 
                                     INPUT l-remessa,
                                     INPUT l-entrada,
                                     INPUT l-transfer,
                                     INPUT l-remessa-con, 
                                     INPUT l-ent-con,
                                     INPUT c-plan-ini,
                                     INPUT c-plan-fim,
                                     INPUT i-nr-linha-ini,
                                     INPUT i-nr-linha-fim,
                                     INPUT l-sald-terc,
                                     INPUT c-estab-ini,
                                     INPUT c-estab-fim,
                                     INPUT l-ord-prod,
                                     INPUT i-benefic,
                                     INPUT l-cred-aprov,
                                     INPUT l-planejada,
                                     INPUT l-res-plan,
                                     INPUT i-cod-plano
                                     &IF defined(bf_man_206b) &THEN
                                        ,INPUT c-unid-negoc-ini,
                                         INPUT c-unid-negoc-fim
                                     &ENDIF
                                     ).
            IF param-global.modulo-per-ppm AND 
                AVAIL b-ITEM AND b-ITEM.tipo-formula >= 2 AND b-ITEM.tipo-formula <= 3 THEN
                assign de-saldo = de-saldo-inic-teor.
            ELSE
                assign de-saldo = de-saldo-inic.

            for each tt-estoq:
                if tt-estoq.tipo = c-liter[5] or
                   tt-estoq.tipo = c-liter[6] or
                   tt-estoq.tipo = c-liter[8] then do:
                    assign de-saldo      = de-saldo - tt-estoq.quantidade
                           de-quantidade = (tt-estoq.quantidade * (-1)).
                end.
                else
                    assign de-saldo = de-saldo
                                    + if tt-estoq.tipo = c-liter[2] then
                                      0
                                    else
                                        tt-estoq.quantidade
                           de-quantidade = tt-estoq.quantidade.

                assign tt-estoq.obs = if de-saldo < 0 
                                      then c-liter[9]
                                      else if de-saldo < de-quant-segur
                                           then c-liter[10]
                                           else ""
                       tt-estoq.saldo = de-saldo
                       tt-estoq.quantidade = de-quantidade.


                IF  CAN-FIND(FIRST ITEM WHERE ITEM.it-codigo = TRIM(tt-estoq.referencia)) 
                THEN 
                    ASSIGN c-item-reserva = TRIM(tt-estoq.referencia).
                ELSE 
                    IF  CAN-FIND(FIRST ITEM WHERE ITEM.it-codigo = TRIM(entry(2, tt-estoq.referencia, "-"))) 
                    THEN 
                        ASSIGN c-item-reserva = TRIM(entry(2, tt-estoq.referencia, "-")).

                FIND FIRST tt-itens-relacao 
                    WHERE  tt-itens-relacao.it-codigo   = c-item-reserva
                      AND  tt-itens-relacao.it-original = ordem-compra.it-codigo NO-ERROR.

                IF NOT AVAIL tt-itens-relacao
                THEN DO:
                    CREATE tt-itens-relacao.
                    ASSIGN tt-itens-relacao.it-codigo     = c-item-reserva        
                           tt-itens-relacao.it-original   = ordem-compra.it-codigo.
                END.

                ASSIGN tt-itens-relacao.quantidade = tt-itens-relacao.quantidade       + (IF tt-estoq.quantidade < 0 THEN (tt-estoq.quantidade * -1) ELSE tt-estoq.quantidade).

            end. /* for each tt-estoq ... */

        END.
        ASSIGN tt-itens-embarque.de-qtd-embarque = tt-itens-embarque.de-qtd-embarque + ordens-embarque.quantidade.

    END. /* FOR FIRST embarque-imp ... */

    /* Buscar item Pai na Estrutura */
    FOR EACH tt-itens-relacao:

        RUN pi-acompanhar IN h-acomp (INPUT "Item Estruura: " + tt-itens-relacao.it-codigo).

        IF  NOT tt-itens-relacao.it-codigo BEGINS "4" 
        THEN
            RUN pi-estrutura(INPUT tt-itens-relacao.it-codigo,
                             INPUT 1).
        ELSE DO:
            FOR FIRST int-projeto-item NO-LOCK 
                WHERE int-projeto-item.it-codigo = tt-itens-relacao.it-codigo:

                FIND FIRST tt-itens-projeto NO-LOCK
                    WHERE  tt-itens-projeto.cod-projeto    = int-projeto-item.cod-projeto
                      AND  tt-itens-projeto.c-item-acabado = tt-itens-relacao.it-codigo
                      AND  tt-itens-projeto.c-item-filho   = tt-itens-relacao.it-original NO-ERROR.

                IF  NOT AVAIL tt-itens-projeto
                THEN DO:
                    CREATE tt-itens-projeto.
                    ASSIGN tt-itens-projeto.cod-projeto    = int-projeto-item.cod-projeto
                           tt-itens-projeto.c-item-acabado = tt-itens-relacao.it-codigo         
                           tt-itens-projeto.c-item-filho   = tt-itens-relacao.it-original
                           tt-itens-relacao.l-considerar   = YES.

                    FOR FIRST ITEM NO-LOCK
                        WHERE ITEM.it-codigo = tt-itens-relacao.it-original:
                        ASSIGN tt-itens-projeto.c-des-item-emb = ITEM.desc-item.
                    END.

                    FOR FIRST ITEM NO-LOCK
                        WHERE ITEM.it-codigo = tt-itens-relacao.it-codigo:
                        ASSIGN tt-itens-projeto.c-des-item-pai = ITEM.desc-item.
                    END.

                    FOR FIRST int-projeto OF int-projeto-item NO-LOCK:
                        ASSIGN tt-itens-projeto.desc-projeto = int-projeto.desc-projeto.
                    END.
                END.
            END.
        END.
    END.

    /* Buscar reservas do plano */
    FOR EACH tt-itens-projeto
        BREAK BY tt-itens-projeto.c-item-acabado:

        RUN pi-acompanhar IN h-acomp (INPUT "Item Reserva: " + tt-itens-projeto.c-item-acabado).

        ASSIGN de-reservada = 0.

        FOR EACH  pl-it-prod NO-LOCK
            WHERE pl-it-prod.cd-plano    = tt-param.cd-plano
              AND pl-it-prod.cod-estabel = tt-param.estab-ini
              AND pl-it-prod.it-codigo   = tt-itens-projeto.c-item-acabado:
        
            ASSIGN de-reservada = de-reservada + pl-it-prod.quantidade.
        END.

        RUN pi-qtd-estrutura(INPUT tt-itens-projeto.c-item-acabado,
                             INPUT tt-itens-projeto.c-item-filho,
                             INPUT 1).

        ASSIGN tt-itens-projeto.de-qtd-reserva = de-reservada * tt-itens-projeto.de-qtd-estrut.
    END.

    ASSIGN de-reservada = 0.
    FOR EACH  tt-itens-relacao NO-LOCK
        WHERE tt-itens-relacao.l-considerar = YES
        BREAK BY tt-itens-relacao.it-original:

        IF  FIRST-OF(tt-itens-relacao.it-original)
        THEN DO:

            RUN pi-acompanhar IN h-acomp (INPUT "Item Rateio: " + tt-itens-relacao.it-original).

            FOR FIRST tt-itens-embarque NO-LOCK
                WHERE tt-itens-embarque.it-codigo = tt-itens-relacao.it-original:
                ASSIGN de-embarcada = tt-itens-embarque.de-qtd-embarque.
            END.

            ASSIGN de-reservada = 0.

            FOR EACH  tt-itens-projeto
                WHERE tt-itens-projeto.c-item-filho = tt-itens-relacao.it-original:

                ASSIGN de-reservada = de-reservada + tt-itens-projeto.de-qtd-reserva.

                IF  tt-itens-projeto.de-qtd-reserva = 0
                THEN
                    DELETE tt-itens-projeto.
            END.

            FOR EACH  tt-itens-projeto NO-LOCK
                WHERE tt-itens-projeto.c-item-filho = tt-itens-relacao.it-original:
                
                ASSIGN tt-itens-projeto.de-qtd-embarque = de-embarcada
                       tt-itens-projeto.de-qtd-rateio   = ROUND(((de-embarcada / de-reservada) * tt-itens-projeto.de-qtd-reserva),3)
                       tt-itens-projeto.de-perc-rateio  = ROUND((tt-itens-projeto.de-qtd-rateio * 100) / de-embarcada,3).
            END.
        END.
    END.

END PROCEDURE.


PROCEDURE pi-estrutura:

    DEFINE INPUT  PARAMETER c-it-codigo AS CHARACTER  NO-UNDO.
    DEFINE INPUT  PARAMETER de-quant    AS DECIMAL    NO-UNDO.

    DEFINE VARIABLE de-quant-usada      AS DECIMAL    NO-UNDO.

    FOR EACH  estrutura NO-LOCK 
        WHERE estrutura.es-codigo    = c-it-codigo
          AND estrutura.data-termino > TODAY:        

        ASSIGN de-quant-usada = estrutura.quant-usada * de-quant.

        IF  NOT estrutura.it-codigo BEGINS "4" 
        THEN
            RUN pi-estrutura(INPUT estrutura.it-codigo,
                             INPUT de-quant-usada).
        ELSE DO:
            FOR FIRST int-projeto-item NO-LOCK 
                WHERE int-projeto-item.it-codigo = estrutura.it-codigo:

                FIND FIRST tt-itens-projeto NO-LOCK
                    WHERE  tt-itens-projeto.cod-projeto    = int-projeto-item.cod-projeto
                      AND  tt-itens-projeto.c-item-acabado = estrutura.it-codigo
                      AND  tt-itens-projeto.c-item-filho   = tt-itens-relacao.it-original NO-ERROR.

                IF  NOT AVAIL tt-itens-projeto
                THEN DO:
                    CREATE tt-itens-projeto.
                    ASSIGN tt-itens-projeto.cod-projeto    = int-projeto-item.cod-projeto
                           tt-itens-projeto.c-item-acabado = estrutura.it-codigo         
                           tt-itens-projeto.c-item-filho   = tt-itens-relacao.it-original
                           tt-itens-projeto.de-qtd-reserva = tt-itens-relacao.quantidade
                           tt-itens-relacao.l-considerar   = YES.

                    FOR FIRST ITEM NO-LOCK
                        WHERE ITEM.it-codigo = tt-itens-relacao.it-original:
                        ASSIGN tt-itens-projeto.c-des-item-emb = ITEM.desc-item.
                    END.

                    FOR FIRST ITEM NO-LOCK
                        WHERE ITEM.it-codigo = estrutura.it-codigo:
                        ASSIGN tt-itens-projeto.c-des-item-pai = ITEM.desc-item.
                    END.

                    FOR FIRST int-projeto OF int-projeto-item NO-LOCK:
                        ASSIGN tt-itens-projeto.desc-projeto = int-projeto.desc-projeto.
                    END.
                END.
            END.
        END. /* Else IF  NOT estrutura.it-codigo BEGINS "4" */
    END. /* FOR EACH  estrutura NO-LOCK  */
END. /* PROCEDURE pi-estrutura: */


PROCEDURE pi-qtd-estrutura:

    DEFINE INPUT  PARAMETER c-item-pai   AS CHARACTER  NO-UNDO.
    DEFINE INPUT  PARAMETER c-item-filho AS CHARACTER  NO-UNDO.
    DEFINE INPUT  PARAMETER de-quant     AS DECIMAL    NO-UNDO.

    DEFINE VARIABLE de-quant-usada      AS DECIMAL    NO-UNDO.

    FOR EACH  estrutura NO-LOCK 
        WHERE estrutura.it-codigo    = c-item-pai
          AND estrutura.data-termino > TODAY:  

        ASSIGN de-quant-usada = estrutura.quant-usada * de-quant.

        IF  estrutura.es-codigo <> c-item-filho 
        THEN
            RUN pi-qtd-estrutura(INPUT estrutura.es-codigo,
                                 INPUT c-item-filho,
                                 INPUT de-quant-usada).
        ELSE
            ASSIGN  tt-itens-projeto.de-qtd-estrut = tt-itens-projeto.de-qtd-estrut + estrutura.quant-usada.

    END. /* FOR EACH  estrutura NO-LOCK  */
END. /* PROCEDURE pi-estrutura: */

