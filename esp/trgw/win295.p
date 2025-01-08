/********************************************************************************
 ** UPC........: win295.p - UPC WRITE pedido-compr
 ** Data.......: Outubro / 2006
 ** Objetivo...:
 ** Vers∆o.....: 16/11/2022 - Henke/iDBA - Integraá∆o com o ARIBA; 
 ********************************************************************************/

DEF NEW GLOBAL SHARED VAR v_cod_empres_usuar LIKE emsuni.empresa.cod_empresa NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_cod_usuar_corren AS CHAR NO-UNDO.

DEF NEW GLOBAL SHARED VAR v-rw-es-api-log AS ROWID NO-UNDO.

DEF PARAM BUFFER b-pedido-compr      FOR pedido-compr.
DEF PARAM BUFFER b-old-pedido-compr  FOR pedido-compr.

DEF BUFFER b-int-mov-ped-compr FOR int-mov-ped-compr.

/* Handle de acompanhamento */
DEF VAR h-acomp         AS HANDLE NO-UNDO.    

DEF VAR v-log-reenvio   AS LOG INIT NO NO-UNDO.
DEF VAR v-num-seq-movto AS INT NO-UNDO.
DEF VAR de-preco-unit   AS DEC NO-UNDO.
DEF VAR de-total        AS DEC NO-UNDO.
def var i-hora-aux      as int no-undo.

DEF VAR l-msg           AS l NO-UNDO.
DEF VAR i               AS i NO-UNDO.

{esp/ccp/esccp055r.i}
{esp/esapi505b.i}  

//IF NEW b-pedido-compr THEN
//   MESSAGE "Pedido novo " STRING (v-rw-es-api-log) VIEW-AS ALERT-BOX.

IF NOT CAN-FIND(FIRST int-pedido-compr WHERE
                      int-pedido-compr.num-pedido = b-pedido-compr.num-pedido
                      NO-LOCK)
THEN DO:
     CREATE int-pedido-compr.
     ASSIGN int-pedido-compr.num-pedido = b-pedido-compr.num-pedido.
     FIND CURRENT int-pedido-compr NO-LOCK NO-ERROR.
     RELEASE int-pedido-compr.
END.

IF NEW b-pedido-compr 
AND v-rw-es-api-log <> ? THEN DO:
    // MESSAGE "v-rw-es-api-log win295: " STRING (v-rw-es-api-log) VIEW-AS ALERT-BOX. 
    IF b-pedido-compr.situacao <> 3 /* Eliminado */ THEN DO:
        FIND FIRST int-ped-compr 
             WHERE int-ped-compr.num-pedido = b-pedido-compr.num-pedido NO-ERROR.
        IF NOT AVAIL int-ped-compr THEN DO:
            CREATE int-ped-compr.
            ASSIGN int-ped-compr.num-pedido   = b-pedido-compr.num-pedido
                   int-ped-compr.id-ped-compr = NEXT-VALUE (seq_id_ped_compr)
                   int-ped-compr.cod-emitente = b-pedido-compr.cod-emitente
                   int-ped-compr.responsavel  = b-pedido-compr.responsavel
                   int-ped-compr.cod-estabel  = b-pedido-compr.cod-estabel           
                   int-ped-compr.i-moeda      = b-pedido-compr.i-moeda
                   int-ped-compr.cod-usuar-criac = v_cod_usuar_corren
                   int-ped-compr.dat-criac    = TODAY
                   int-ped-compr.hra-criac    = REPLACE (STRING (TIME, "HH:MM:SS"), ":", "")
                   int-ped-compr.ind-status   = 1. //"N∆o Integrado".
            CREATE int-mov-ped-compr.
            ASSIGN int-mov-ped-compr.id-ped-compr  = int-ped-compr.id-ped-compr
                   int-mov-ped-compr.num-pedido    = int-ped-compr.num-pedido
                   int-mov-ped-compr.num-seq-movto = 10
                   int-mov-ped-compr.ind-tip-movto = "N∆o Integrado"
                   int-mov-ped-compr.dat-movto     = TODAY
                   int-mov-ped-compr.hra-movto     = REPLACE (STRING (TIME, "HH:MM:SS"), ":", "")
                   int-mov-ped-compr.usr-movto     = int-ped-compr.cod-usuar-criac
                   int-mov-ped-compr.des-text-histor = "Criaá∆o do Pedido de Compras: " + STRING (b-pedido-compr.num-pedido).
            IF v-rw-es-api-log <> ? THEN DO:
                FIND es-api-log NO-LOCK
                    WHERE ROWID (es-api-log) = v-rw-es-api-log NO-ERROR.
                IF AVAIL es-api-log THEN DO:                    
                    ASSIGN int-mov-ped-compr.id-api-log    = es-api-log.id-api-log.
                    FIND es-api-uri OF es-api-log NO-LOCK NO-ERROR.
                    IF AVAIL es-api-uri THEN
                        ASSIGN int-mov-ped-compr.des-text-histor = "Pedido de Compras: " + STRING (b-pedido-compr.num-pedido) 
                                                                 + " gerado atravÇs do " + TRIM (es-api-uri.nome).
                END.
            END.
        END.
    END.    
END.
ELSE DO:
    // MESSAGE "v-rw-es-api-log win295: " STRING (v-rw-es-api-log) VIEW-AS ALERT-BOX.
    // MESSAGE "Ordem: " CAN-FIND (FIRST ordem-compra OF b-pedido-compr) VIEW-AS ALERT-BOX. 
    IF CAN-FIND (FIRST ordem-compra OF b-pedido-compr) THEN DO:

        /* Status Processamento Ariba
        1 -	N∆o Integrado: status inicial de todos os registros criados
        2 -	Em processamento: status que ir† aguardar o retorno do processamento Ariba, pois n∆o Ç s°ncrono
        3 -	Em Revis∆o: status para todos os pedidos que forem alterados (sugest∆o Ç usar a trigger de ediá∆o)
        4 -	Integrado: status de todos os pedidos integrados com sucesso, seja criaá∆o ou alteraá∆o
        5 -	Registro Exclu°do: registros que ser∆o exclu°dos desta tabela pois n∆o ser∆o executados
        6 -	Erro Integraá∆o: status do pedido cujo retorno do Ariba foi algum erro
        7 -	Pedido Cancelado: quanto o pedido for eliminado/exclu°do no Totvs
        */

        /* Verifica se existe int-ped-compr */
        IF b-pedido-compr.situacao <> 3 /* Eliminado */ THEN DO:
            FIND FIRST int-ped-compr 
                 WHERE int-ped-compr.num-pedido = b-pedido-compr.num-pedido NO-ERROR.
            IF NOT AVAIL int-ped-compr THEN DO:
                CREATE int-ped-compr.
                ASSIGN int-ped-compr.num-pedido   = b-pedido-compr.num-pedido
                       int-ped-compr.id-ped-compr = NEXT-VALUE (seq_id_ped_compr)
                       int-ped-compr.cod-emitente = b-pedido-compr.cod-emitente
                       int-ped-compr.responsavel  = b-pedido-compr.responsavel
                       int-ped-compr.cod-estabel  = b-pedido-compr.cod-estabel           
                       int-ped-compr.i-moeda      = b-pedido-compr.i-moeda
                       int-ped-compr.cod-usuar-criac = v_cod_usuar_corren
                       int-ped-compr.dat-criac    = TODAY
                       int-ped-compr.hra-criac    = REPLACE (STRING (TIME, "HH:MM:SS"), ":", "")
                       int-ped-compr.ind-status   = 1. //"N∆o Integrado".
                CREATE int-mov-ped-compr.
                ASSIGN int-mov-ped-compr.id-ped-compr  = int-ped-compr.id-ped-compr
                       int-mov-ped-compr.num-pedido    = int-ped-compr.num-pedido
                       int-mov-ped-compr.num-seq-movto = 10
                       int-mov-ped-compr.ind-tip-movto = "N∆o Integrado"
                       int-mov-ped-compr.dat-movto     = TODAY
                       int-mov-ped-compr.hra-movto     = REPLACE (STRING (TIME, "HH:MM:SS"), ":", "")
                       int-mov-ped-compr.usr-movto     = v_cod_usuar_corren
                       int-mov-ped-compr.des-text-histor = "Criaá∆o do Pedido de Compras: " + STRING (b-pedido-compr.num-pedido).
                RUN pi-val-total.
                // MESSAGE "criou o int-ped-compr" VIEW-AS ALERT-BOX.
            END.
            ELSE DO:
                IF b-old-pedido-compr.dat-alter <> ? THEN DO:
                    IF (b-pedido-compr.dat-alter <> b-old-pedido-compr.dat-alter
                    OR  b-pedido-compr.hra-alter <> b-old-pedido-compr.hra-alter)
                    AND b-pedido-compr.situacao  <> 3 /* Eliminado */ THEN DO:
                        assign i-hora-aux = 0.
                        FIND FIRST int-ped-compr EXCLUSIVE-LOCK
                             WHERE int-ped-compr.num-pedido = b-pedido-compr.num-pedido NO-ERROR.
                        IF AVAIL int-ped-compr THEN DO:
                            FIND LAST int-mov-ped-compr NO-LOCK
                                 WHERE int-mov-ped-compr.id-ped-compr = int-ped-compr.id-ped-compr
                                   AND int-mov-ped-compr.num-pedido   = int-ped-compr.num-pedido NO-ERROR.
                            IF AVAIL int-mov-ped-compr THEN
                                ASSIGN v-num-seq-movto = int-mov-ped-compr.num-seq-movto + 10
                                       i-hora-aux      = inte(int-mov-ped-compr.hra-movto)
                                       no-error.
                            ELSE
                                ASSIGN v-num-seq-movto = 20.

                            /* Evitar repetiá∆o */
                            if  avail int-mov-ped-compr
                            and i-hora-aux                      > 0
                            and absolute(i-hora-aux - inte(replace(string(TIME,"HH:MM:SS"),":",""))) < 3
                            and int-ped-compr.ind-status        = 3
                            and int-mov-ped-compr.ind-tip-movto = "Em Revis∆o"
                            and int-mov-ped-compr.dat-movto     = today
                            and int-mov-ped-compr.usr-movto     = v_cod_usuar_corren
                            then.
                            else do:
                                 CREATE int-mov-ped-compr.
                                 ASSIGN int-ped-compr.ind-status        = 3 // "Em Revis∆o"
                                        int-mov-ped-compr.id-ped-compr  = int-ped-compr.id-ped-compr
                                        int-mov-ped-compr.num-pedido    = int-ped-compr.num-pedido
                                        int-mov-ped-compr.num-seq-movto = v-num-seq-movto
                                        int-mov-ped-compr.ind-tip-movto = "Em Revis∆o"
                                        int-mov-ped-compr.dat-movto     = TODAY
                                        int-mov-ped-compr.hra-movto     = REPLACE (STRING (TIME, "HH:MM:SS"), ":", "")               
                                        int-mov-ped-compr.usr-movto     = v_cod_usuar_corren
                                        int-mov-ped-compr.des-text-histor = "Pedido de Compras Alterado: " + STRING (b-pedido-compr.num-pedido).
                                 // MESSAGE "Em revis∆o" VIEW-AS ALERT-BOX.
                            end. /* else do */
                        END.
                        RUN pi-val-total.
                    END.
                END.
            END.
        END.

        /* Situaá∆o do Pedido de Compras igual a 3 - Eliminado */
        IF  b-pedido-compr.situacao <> b-old-pedido-compr.situacao 
        AND b-pedido-compr.situacao = 3 /* Eliminado */ THEN DO: 
            FIND FIRST int-ped-compr EXCLUSIVE-LOCK
                 WHERE int-ped-compr.num-pedido = b-pedido-compr.num-pedido NO-ERROR.
            IF  AVAIL int-ped-compr
            and can-find(first b-int-mov-ped-compr WHERE 
                               b-int-mov-ped-compr.id-ped-compr  = int-ped-compr.id-ped-compr
                           AND b-int-mov-ped-compr.num-pedido    = int-ped-compr.num-pedido
                           and b-int-mov-ped-compr.ind-tip-movto = "Integrado"
                               no-lock)
            and not can-find(first b-int-mov-ped-compr WHERE 
                                   b-int-mov-ped-compr.id-ped-compr  = int-ped-compr.id-ped-compr
                               AND b-int-mov-ped-compr.num-pedido    = int-ped-compr.num-pedido
                               and b-int-mov-ped-compr.ind-tip-movto = "Pedido Cancelado"
                                   no-lock)
            THEN DO:
                RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
                RUN pi-inicializar IN h-acomp ('ARI - AribaPedComprDel').
                RUN pi-acompanhar IN h-acomp ("Eliminando Pedido").
                RUN pi-output-api-request  ("ARI",
                                            v_cod_empres_usuar,
                                            "AribaPedComprDel",
                                            "WIN295",
                                            STRING (int-ped-compr.num-pedido),
                                            lcRequest).
                /*
                FIND LAST int-mov-ped-compr EXCLUSIVE-LOCK
                     WHERE int-mov-ped-compr.id-ped-compr = int-ped-compr.id-ped-compr
                       AND int-mov-ped-compr.num-pedido   = int-ped-compr.num-pedido NO-ERROR.
                IF AVAIL int-mov-ped-compr THEN
                    ASSIGN v-num-seq-movto = int-mov-ped-compr.num-seq-movto + 10.
                ELSE
                    ASSIGN v-num-seq-movto = 20.
                CASE b-pedido-compr.situacao:
                    WHEN 3 /* Eliminado */ THEN DO:
                        CREATE int-mov-ped-compr.
                        ASSIGN int-ped-compr.ind-status        = 7 //"Pedido Cancelado"
                               int-mov-ped-compr.id-ped-compr  = int-ped-compr.id-ped-compr
                               int-mov-ped-compr.num-pedido    = int-ped-compr.num-pedido
                               int-mov-ped-compr.num-seq-movto = v-num-seq-movto
                               int-mov-ped-compr.ind-tip-movto = "Pedido Cancelado"
                               int-mov-ped-compr.dat-movto     = b-pedido-compr.dat-alter
                               int-mov-ped-compr.hra-movto     = b-pedido-compr.hra-alter
                               int-mov-ped-compr.usr-movto     = v_cod_usuar_corren
                               int-mov-ped-compr.des-text-histor = "Pedido de Compras Cancelado: " + STRING (b-pedido-compr.num-pedido).
                    END.
                END CASE.
                */

                IF VALID-HANDLE(h-acomp) THEN 
                    RUN pi-finalizar IN h-acomp.
            END.
        END.

    END.
END.

/* Verifica se Pedido de Compra j† foi enviado para o Ariba */
IF  v-rw-es-api-log              = ?
AND b-old-pedido-compr.situacao  = 2 /* N∆o Impresso */
AND b-pedido-compr.situacao      = 1 /* Impresso */
and can-find(first int-ped-compr where
                   int-ped-compr.num-pedido = b-pedido-compr.num-pedido
                   no-lock)
AND CAN-FIND(FIRST ordem-compra WHERE
                   ordem-compra.num-pedido = b-pedido-compr.num-pedido
                   NO-LOCK)
THEN DO:
    DEF VAR v-log-pedido AS LOG NO-UNDO.

    FIND FIRST int-ped-compr 
         WHERE int-ped-compr.num-pedido = b-pedido-compr.num-pedido NO-ERROR.

    FIND LAST b-int-mov-ped-compr NO-LOCK
         WHERE b-int-mov-ped-compr.id-ped-compr = int-ped-compr.id-ped-compr
           AND b-int-mov-ped-compr.num-pedido   = int-ped-compr.num-pedido NO-ERROR.
    IF  AVAIL b-int-mov-ped-compr
    and (b-int-mov-ped-compr.ind-tip-movto = "N∆o Integrado"
    OR   b-int-mov-ped-compr.ind-tip-movto = "Em Revis∆o")
    THEN DO:
        /* Verifica se o Tipo do Pedido est† na lista pra integrar
           automaticamente no ARIBA */
        RUN pi-tipo-pedido (INPUT b-pedido-compr.num-pedido,
                            OUTPUT v-log-pedido).

        IF v-log-pedido = YES THEN DO:
            ASSIGN v-num-seq-movto = b-int-mov-ped-compr.num-seq-movto + 10.
            CREATE int-mov-ped-compr.
            ASSIGN int-ped-compr.ind-status        = 2 // "Em Processamento"
                   int-mov-ped-compr.id-ped-compr  = int-ped-compr.id-ped-compr
                   int-mov-ped-compr.num-pedido    = int-ped-compr.num-pedido
                   int-mov-ped-compr.num-seq-movto = v-num-seq-movto
                   int-mov-ped-compr.ind-tip-movto = "Em Processamento"
                   int-mov-ped-compr.dat-movto     = TODAY
                   int-mov-ped-compr.hra-movto     = REPLACE (STRING (TIME, "HH:MM:SS"), ":", "")               
                   int-mov-ped-compr.usr-movto     = v_cod_usuar_corren
                   int-mov-ped-compr.des-text-histor = "Pedido de Compras em processamento: " + STRING (b-pedido-compr.num-pedido).
            /* Cria tt-int-ped-compr */
            RUN esp/ccp/esccp055r.p (INPUT NO,                 // Acompanhamento
                                     INPUT b-pedido-compr.num-pedido,
                                     INPUT "tt-int-ped-compr", // pi-cria-tt-int-ped-compr
                                     INPUT v-log-reenvio,      // Reenvio
                                     INPUT-OUTPUT TABLE tt-int-ped-compr).
            /* Envia para o ARIBA */
            RUN esp/ccp/esccp055r.p (INPUT NO,            // Acompanhamento
                                     INPUT b-pedido-compr.num-pedido,
                                     INPUT "es-api-log",  // pi-cria-es-api-log
                                     INPUT v-log-reenvio, // Reenvio
                                     INPUT-OUTPUT TABLE tt-int-ped-compr).
        END.
    END.
END.

IF b-pedido-compr.cod-cond-pag <> b-old-pedido-compr.cod-cond-pag THEN DO:
    DO i = 1 TO 10:
        IF PROGRAM-NAME(i) MATCHES "MSG" THEN DO:
           ASSIGN l-msg = YES.
           LEAVE.
        END.
    END.

    IF l-msg = NO THEN DO:
        FOR EACH ordem-compra    NO-LOCK
            WHERE ordem-compra.num-pedido = b-pedido-compr.num-pedido,
            EACH ordens-embarque NO-LOCK
              OF ordem-compra,                 
           FIRST ext-embarque-imp NO-LOCK         
           WHERE ext-embarque-imp.cod-estabel     = ordens-embarque.cod-estabel
             AND ext-embarque-imp.embarque        = ordens-embarque.embarque
             AND ext-embarque-imp.log-envio-comex = YES:
            RUN pi-output-api-request  ("CEX",
                                        "1",
                                        "ItPedidoCEX-ALT",
                                        "TRIGGER",
                                        ordens-embarque.cod-estabel          + "," + 
                                        ordens-embarque.embarque             + "," + 
                                        STRING(ordens-embarque.numero-ordem) + "," + 
                                        STRING(ordens-embarque.parcela),
                                        lcRequest).
        END.
   END.
END.

find current int-ped-compr     no-lock no-error.
find current int-mov-ped-compr no-lock no-error.
release int-ped-compr.
release int-mov-ped-compr.

RETURN "ok".

PROCEDURE pi-val-total:

    FIND FIRST int-ped-compr EXCLUSIVE-LOCK
         WHERE int-ped-compr.num-pedido = b-pedido-compr.num-pedido NO-ERROR.
    IF AVAIL int-ped-compr THEN DO:
        ASSIGN de-preco-unit = 0.
        FOR EACH ordem-compra USE-INDEX pedido
            WHERE ordem-compra.num-pedido = b-pedido-compr.num-pedido:
            IF ordem-compra.situacao = 4 /* Eliminada */ THEN
                NEXT.
            ASSIGN de-preco-unit = ordem-compra.preco-unit.
            IF ordem-compra.mo-codigo <> 0 /* Real */ THEN DO:
                FIND FIRST cotacao-item OF ordem-compra NO-LOCK NO-ERROR.
                RUN cdp/cd0812.p (INPUT ordem-compra.mo-codigo,
                                  INPUT 0,
                                  INPUT de-preco-unit,
                                  INPUT IF AVAIL cotacao-item THEN cotacao-item.data-cotacao ELSE ordem-compra.data-pedido,
                                  OUTPUT de-preco-unit).
            END.
            FOR EACH prazo-compra USE-INDEX ordem NO-LOCK
                WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem:
                IF prazo-compra.situacao = 4 THEN
                    NEXT.
                ASSIGN de-total = de-total + (prazo-compra.quantidade * de-preco-unit).
            END.
        END.
        ASSIGN int-ped-compr.val-total = ROUND (de-total, 2).
    END.

END.

PROCEDURE pi-tipo-pedido:

    DEF INPUT PARAM p-num-pedido  AS INT NO-UNDO.
    DEF OUTPUT PARAM p-log-pedido AS LOG NO-UNDO.

    DEF VAR v-num           AS INT NO-UNDO.
    DEF VAR i-tp-pedido     AS INT NO-UNDO.
    DEF VAR c-tp-pedido     AS CHAR NO-UNDO.
    DEF VAR c-tp-pedido-num AS CHAR NO-UNDO.
    DEF VAR p-des-tipo      AS CHAR NO-UNDO.

    FOR FIRST ponto-programa USE-INDEX ponto NO-LOCK
        WHERE ponto-programa.nome-programa = "cc0300a"
          AND ponto-programa.ponto         = 1
          AND ponto-programa.tipo          = 3, // Item
         EACH conteudo-programa NO-LOCK
        WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:
        IF NUM-ENTRIES(conteudo-programa.conteudo, ";") < 4         THEN NEXT.
        IF ENTRY(4,conteudo-programa.conteudo,";")      = "INATIVO" THEN NEXT.
        ASSIGN c-tp-pedido = c-tp-pedido + ","
                           + TRIM (ENTRY (2, conteudo-programa.conteudo, ";"))
               c-tp-pedido-num = c-tp-pedido-num + ","
                           + TRIM (ENTRY (1, conteudo-programa.conteudo, ";")).
    END.
    ASSIGN c-tp-pedido     = SUBSTR (c-tp-pedido, 2)
           c-tp-pedido-num = SUBSTR (c-tp-pedido-num, 2).
           
    FIND FIRST int-pedido-compr NO-LOCK 
         WHERE int-pedido-compr.num-pedido = p-num-pedido NO-ERROR.
    IF AVAIL int-pedido-compr THEN
        ASSIGN i-tp-pedido = int-pedido-compr.tp-pedido.

    ASSIGN p-log-pedido = NO.
    DO v-num = 1 TO NUM-ENTRIES (c-tp-pedido-num):
        IF ENTRY (v-num, c-tp-pedido-num) = STRING (i-tp-pedido) THEN DO:
            ASSIGN p-des-tipo = TRIM (ENTRY (v-num, c-tp-pedido)).
            FOR FIRST ponto-programa USE-INDEX ponto NO-LOCK
                WHERE ponto-programa.nome-programa = "win295"
                  AND ponto-programa.ponto         = 1
                  AND ponto-programa.tipo          = 5, // texto
                 EACH conteudo-programa NO-LOCK
                WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
                  and conteudo-programa.conteudo     = p-des-tipo:
                ASSIGN p-log-pedido = YES.
                RETURN.            
            END.
        END.            
    END.
    
END.

