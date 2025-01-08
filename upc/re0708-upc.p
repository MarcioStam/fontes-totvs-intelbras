/*******************************************************************************
#@# 
@programa: upc/re0708-upc.p
@data:     29/03/2017
@autor:    Estevan Krger
@release:  DTS11
@objetivo: UPC para for»ar a grava»’o do nœmerdo da Ordem Compra, Pedido Compra e Parcela
@vers’o:   1.00 - Vers’o Inicial
#@#
*******************************************************************************/

/*--- Parametros Recebidos ---*/
DEFINE INPUT PARAMETER p-ind-event  AS CHARACTER     NO-UNDO.
DEFINE INPUT PARAMETER p-ind-object AS CHARACTER     NO-UNDO.
DEFINE INPUT PARAMETER p-wgh-object AS HANDLE        NO-UNDO.
DEFINE INPUT PARAMETER p-wgh-frame  AS WIDGET-HANDLE NO-UNDO.
DEFINE INPUT PARAMETER p-cod-table  AS CHARACTER     NO-UNDO.
DEFINE INPUT PARAMETER p-row-table  AS ROWID         NO-UNDO.

{esp/es0018.i}
DEFINE VARIABLE l-devolucao AS LOGICAL     NO-UNDO.
DEFINE BUFFER b-docum-est FOR docum-est.
DEFINE BUFFER b-item-doc-orig-nfe FOR item-doc-orig-nfe.

DEF TEMP-TABLE tt-docto NO-UNDO
    FIELD cod-emitente LIKE docum-est.cod-emitente
    FIELD nro-docto    LIKE docum-est.nro-docto   
    FIELD serie-docto  LIKE docum-est.serie-docto 
    FIELD nat-operacao LIKE docum-est.nat-operacao.

DEFINE VARIABLE wh-objeto AS   HANDLE        NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE wh-fPage1-RE0708   AS WIDGET-HANDLE  NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-brTable1-RE0708    AS WIDGET-HANDLE  NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE whBrowseBrTable1RE0708   AS WIDGET-HANDLE  NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE whQueryBrTable1RE0708    AS WIDGET-HANDLE  NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE whBufferTtBrTable1RE0708 AS WIDGET-HANDLE  NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE hObjectBrTable1RE0708    AS HANDLE         NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE whColumnCfopRE0708       AS WIDGET-HANDLE  NO-UNDO.

/*--- Bloco Principal ---*/
IF  p-ind-event  = "Processada"   AND
    p-ind-object = "btReprocessa" THEN DO:

    EMPTY TEMP-TABLE tt-docto.
    FIND FIRST doc-orig-nfe NO-LOCK
        WHERE  ROWID(doc-orig-nfe) = p-row-table NO-ERROR.
    IF  AVAIL  doc-orig-nfe THEN DO:

        FOR EACH item-doc-orig-nfe NO-LOCK OF doc-orig-nfe:

            FIND FIRST docum-est NO-LOCK
                WHERE  docum-est.cod-chave-aces-nf-eletro = item-doc-orig-nfe.ch-acesso-comp-nfe NO-ERROR.
            IF  AVAIL  docum-est THEN DO:
                FIND FIRST tt-docto 
                     WHERE tt-docto.cod-emitente = docum-est.cod-emitente
                       AND tt-docto.nro-docto    = docum-est.nro-docto   
                       AND tt-docto.serie-docto  = docum-est.serie-docto 
                       AND tt-docto.nat-operacao = docum-est.nat-operacao NO-ERROR.
                IF NOT AVAIL tt-docto THEN DO:
                   CREATE tt-docto.
                   ASSIGN tt-docto.cod-emitente = docum-est.cod-emitente
                          tt-docto.nro-docto    = docum-est.nro-docto   
                          tt-docto.serie-docto  = docum-est.serie-docto 
                          tt-docto.nat-operacao = docum-est.nat-operacao.
                END.
                
                FIND FIRST item-doc-est EXCLUSIVE-LOCK OF docum-est
                    WHERE  item-doc-est.it-codigo = item-doc-orig-nfe.it-codigo NO-ERROR.
                IF  AVAIL  item-doc-est AND item-doc-est.numero-ordem = 0 THEN DO:

                    ASSIGN item-doc-est.num-pedido   = item-doc-orig-nfe.num-pedido  
                           item-doc-est.numero-ordem = item-doc-orig-nfe.numero-ordem
                           item-doc-est.parcela      = item-doc-orig-nfe.parcela
                           item-doc-est.nr-ord-produ = item-doc-orig-nfe.nr-ord-produ.
                
                    FIND FIRST prazo-compra NO-LOCK
                        WHERE  prazo-compra.it-codigo    = item-doc-orig-nfe.it-codigo
                        AND    prazo-compra.numero-ordem = item-doc-orig-nfe.numero-ordem NO-ERROR.
                    IF  AVAIL  prazo-compra THEN
                        ASSIGN item-doc-est.parcela = prazo-compra.parcela.
                END.

                FIND CURRENT item-doc-est NO-LOCK NO-ERROR.

            END.
        END.

        FOR EACH item-doc-orig-nfe NO-LOCK
           WHERE item-doc-orig-nfe.ch-acesso-comp-nfe = doc-orig-nfe.ch-acesso-comp-nfe
             AND item-doc-orig-nfe.idi-orig-trad = 2
             AND ( /*item-doc-orig-nfe.it-codigo     = "" OR*/
                  item-doc-orig-nfe.it-codigo     = "TERC" OR
                  item-doc-orig-nfe.it-codigo     = "TERC IMPORTADO"):
            FIND FIRST docum-est NO-LOCK
                 WHERE docum-est.cod-chave-aces-nf-eletro = doc-orig-nfe.ch-acesso-comp-nfe NO-ERROR.
            IF  AVAIL  docum-est THEN DO:
                FIND FIRST item-doc-est OF docum-est EXCLUSIVE-LOCK
                     WHERE item-doc-est.it-codigo = item-doc-orig-nfe.it-codigo
                       AND int(substr(item-doc-est.char-2,832,5)) = item-doc-orig-nfe.seq-item NO-ERROR.
                IF AVAIL item-doc-est THEN DO:
                   FIND FIRST b-item-doc-orig-nfe NO-LOCK
                        WHERE b-item-doc-orig-nfe.ch-acesso-comp-nfe = item-doc-orig-nfe.ch-acesso-comp-nfe
                          AND b-item-doc-orig-nfe.idi-orig-trad      = 1
                          AND b-item-doc-orig-nfe.seq-item           = item-doc-orig-nfe.seq-item NO-ERROR.
                   IF AVAIL b-item-doc-orig-nfe THEN DO:
                      ASSIGN item-doc-est.narrativa = b-item-doc-orig-nfe.desc-item.
                   END.
                END.
                RELEASE item-doc-est.
            END.
        END.
    END.

    FOR EACH tt-docto,
        FIRST docum-est NO-LOCK
        WHERE docum-est.cod-emitente = tt-docto.cod-emitente
          AND docum-est.nro-docto    = tt-docto.nro-docto   
          AND docum-est.serie-docto  = tt-docto.serie-docto 
          AND docum-est.nat-operacao = tt-docto.nat-operacao:

        ASSIGN l-devolucao = NO.
        RUN esp/es0018p.p (INPUT "RE0708", /* Nome do programa */
                           INPUT 1,        /* Ponto do programa */
                           INPUT 0,
                           INPUT "",
                           OUTPUT TABLE tt-prog-ponto) NO-ERROR.

        FIND FIRST tt-prog-ponto
             WHERE ENTRY(1,tt-prog-ponto.conteudo,";") = docum-est.cod-estabel
               AND ENTRY(2,tt-prog-ponto.conteudo,";") = docum-est.nat-operacao NO-ERROR.
        IF NOT AVAIL tt-prog-ponto THEN NEXT.

        FOR EACH item-doc-est OF docum-est EXCLUSIVE-LOCK,
           FIRST tt-prog-ponto 
           WHERE ENTRY(1,tt-prog-ponto.conteudo,";") = docum-est.cod-estabel
             AND ENTRY(2,tt-prog-ponto.conteudo,";") = item-doc-est.nat-of,
           FIRST ITEM OF item-doc-est NO-LOCK
           WHERE ITEM.baixa-estoq:

            FOR EACH rat-lote OF item-doc-est EXCLUSIVE-LOCK:
                DELETE rat-lote.
            END.

            CREATE rat-lote.
            ASSIGN rat-lote.serie-docto      = item-doc-est.serie-docto
                   rat-lote.cod-emitente     = item-doc-est.cod-emitente
                   rat-lote.nro-docto        = item-doc-est.nro-docto
                   rat-lote.nat-operacao     = item-doc-est.nat-operacao  
                   rat-lote.it-codigo        = item-doc-est.it-codigo
                   rat-lote.sequencia        = item-doc-est.sequencia
                   rat-lote.cod-depos        = ENTRY(3,tt-prog-ponto.conteudo,";")
                   rat-lote.cod-localiz      = ""
                   rat-lote.quantidade       = item-doc-est.quantidade.

            IF ITEM.tipo-con-est = 3 THEN DO:
               ASSIGN rat-lote.dt-vali-lote     = 12/31/9999
                      rat-lote.lote             = "GENERICO".
            END.

            FIND CURRENT rat-lote NO-LOCK NO-ERROR.

            ASSIGN item-doc-est.cod-depos = ENTRY(3,tt-prog-ponto.conteudo,";").

            ASSIGN l-devolucao = YES.
        END.

        IF l-devolucao THEN DO:
           FIND FIRST int-docum-est EXCLUSIVE-LOCK
                WHERE int-docum-est.serie-docto  = docum-est.serie-docto 
                  AND int-docum-est.nro-docto    = docum-est.nro-docto   
                  AND int-docum-est.cod-emitente = docum-est.cod-emitente
                  AND int-docum-est.nat-operacao = docum-est.nat-operacao NO-ERROR.
           
           IF NOT AVAIL int-docum-est THEN DO:
               CREATE int-docum-est.
               ASSIGN int-docum-est.serie-docto  = docum-est.serie-docto        
                      int-docum-est.nro-docto    = docum-est.nro-docto    
                      int-docum-est.cod-emitente = docum-est.cod-emitente 
                      int-docum-est.nat-operacao = docum-est.nat-operacao.
           END.
           
           IF AVAIL int-docum-est THEN
              ASSIGN int-docum-est.cod-msg-devolucao  = int(ENTRY(4,tt-prog-ponto.conteudo,";")).
           
           FIND CURRENT int-docum-est NO-LOCK NO-ERROR.
           
           FIND FIRST b-docum-est EXCLUSIVE-LOCK 
                WHERE b-docum-est.serie-docto  = docum-est.serie-docto        
                  AND b-docum-est.nro-docto    = docum-est.nro-docto    
                  AND b-docum-est.cod-emitente = docum-est.cod-emitente 
                  AND b-docum-est.nat-operacao = docum-est.nat-operacao NO-ERROR.
           
           IF AVAIL b-docum-est THEN
               ASSIGN b-docum-est.ct-transit = ENTRY(5,tt-prog-ponto.conteudo,";")
                      b-docum-est.sc-transit = ENTRY(6,tt-prog-ponto.conteudo,";").
           
            FIND CURRENT b-docum-est NO-LOCK NO-ERROR.
        END.
    END.
END.

IF  p-ind-event  = "AFTER-INITIALIZE" 
AND p-ind-object = "CONTAINER" THEN DO:

    RUN tela-upc (INPUT  p-wgh-frame,
                  INPUT  p-ind-event,
                  INPUT  "frame",     /** Type **/
                  INPUT  "fPage1",   /** Name **/
                  INPUT  NO,           /** Apresenta Mensagem dos Objetos **/
                  INPUT  1,
                  OUTPUT wh-fPage1-RE0708).

    RUN tela-upc (INPUT  wh-fPage1-RE0708,
                  INPUT  p-ind-event,
                  INPUT  "BROWSE",     /** Type **/
                  INPUT  "brTable1",   /** Name **/
                  INPUT  NO,           /** Apresenta Mensagem dos Objetos **/
                  INPUT  1,
                  OUTPUT wh-objeto).

    IF VALID-HANDLE(wh-objeto) THEN DO:
        ASSIGN whBrowseBrTable1RE0708   = wh-objeto
               whQueryBrTable1RE0708    = whBrowseBrTable1RE0708:QUERY
               whBufferTtBrTable1RE0708 = whQueryBrTable1RE0708:GET-BUFFER-HANDLE(1).

        ASSIGN whColumnCfopRE0708   = whBrowseBrTable1RE0708:ADD-CALC-COLUMN("CHARACTER", "x(20)" ,"", "CFOP" ,14).
        ON ROW-DISPLAY OF whBrowseBrTable1RE0708 PERSISTENT RUN upc/re0708-upcb.p.

    END.
    

END.


PROCEDURE tela-upc:

    DEFINE INPUT  PARAMETER  pWghFrame    AS WIDGET-HANDLE NO-UNDO.
    DEFINE INPUT  PARAMETER  pIndEvent    AS CHARACTER     NO-UNDO.
    DEFINE INPUT  PARAMETER  pObjType     AS CHARACTER     NO-UNDO.
    DEFINE INPUT  PARAMETER  pObjName     AS CHARACTER     NO-UNDO.
    DEFINE INPUT  PARAMETER  pApresMsg    AS LOGICAL       NO-UNDO.
    DEFINE INPUT  PARAMETER  pAux         AS INTEGER       NO-UNDO.
    DEFINE OUTPUT PARAMETER  phObj        AS HANDLE        NO-UNDO.
    
    DEFINE VARIABLE wgh-obj AS WIDGET-HANDLE NO-UNDO.
    DEFINE VARIABLE i-aux   AS INTEGER       NO-UNDO.

    ASSIGN wgh-obj = pWghFrame:FIRST-CHILD
           i-aux   = 0.

    DO WHILE VALID-HANDLE(wgh-obj):              
        
        IF pApresMsg = YES THEN
            MESSAGE "Nome do Objeto" wgh-obj:NAME SKIP
                    "Type do Objeto" wgh-obj:TYPE SKIP
                    "P-Ind-Event"    pIndEvent VIEW-AS ALERT-BOX.
        
        IF wgh-obj:TYPE = pObjType AND
           wgh-obj:NAME = pObjName THEN DO:
            ASSIGN phObj = wgh-obj:HANDLE
                   i-aux = i-aux + 1.

            IF i-aux = pAux THEN
                LEAVE.
        END.
        IF wgh-obj:TYPE = "field-group" THEN
            ASSIGN wgh-obj = wgh-obj:FIRST-CHILD.
        ELSE 
            ASSIGN wgh-obj = wgh-obj:NEXT-SIBLING.
    END.

END PROCEDURE.


/******************************************************************
** Programa: upc-re0708-u00.p
** Objetivo: Chamada do projeto M2305-146 - Recebimento e Contabiliza‡Æo GKO
**    Autor: 
**     Data: abril/2023
*******************************************************************/

RUN upc/upc-re0708-u01.p (INPUT p-ind-event,
                          INPUT p-ind-object,
                          INPUT p-wgh-object,
                          INPUT p-wgh-frame,
                          INPUT p-cod-table,
                          INPUT p-row-table).

RETURN "OK".
