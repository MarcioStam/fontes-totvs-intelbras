{include/i-prgvrs.i ESCCP037RP 1.00.00.002}

DEFINE VARIABLE v-num-seq         AS INTEGER     NO-UNDO.
DEFINE VARIABLE v-dat-pto-contr   AS DATE        NO-UNDO.
DEFINE VARIABLE c-dt-ult-prev     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-dt-efetiva      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-dt-ent-int      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-data-pedido       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-caminho-arquivo AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-remetente       AS CHAR        NO-UNDO INITIAL "intelbras@intelbras.com.br".
DEFINE VARIABLE c-endereco        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE h-acomp           AS HANDLE      NO-UNDO.
DEFINE VARIABLE d-valor-unit      AS DECIMAL     NO-UNDO.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.

define temp-table tt-param no-undo
    FIELD cod-estab-ini LIKE estabelec.cod-estabel
    FIELD cod-estab-fim LIKE estabelec.cod-estabel
    FIELD it-codigo-ini    LIKE ITEM.it-codigo
    FIELD it-codigo-fim    LIKE ITEM.it-codigo
    FIELD cod-emitente-ini LIKE emitente.cod-emitente
    FIELD cod-emitente-fim LIKE emitente.cod-emitente
    FIELD cod-comprado-ini LIKE ordem-compra.cod-comprado
    FIELD cod-comprado-fim LIKE ordem-compra.cod-comprado
    FIELD email            AS CHAR 
    field destino          as integer
    field arquivo          as char format "x(35)"
    field usuario          as char format "x(12)"
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field desc-classifica  as char format "x(40)"
    field modelo-rtf       as char format "x(35)"
    field l-habilitaRtf    as LOG
    field l-confirmada     as LOG
    field l-recebida       as LOG
    FIELD ini-data         LIKE prazo-compra.data-entrega
    FIELD fim-data         LIKE prazo-compra.data-entrega.

DEFINE TEMP-TABLE tt-saldos NO-UNDO
    FIELD it-codigo          LIKE ITEM.it-codigo
    FIELD desc-item          LIKE ITEM.desc-item
    FIELD cod-emitente       LIKE emitente.cod-emitente
    FIELD cod-itiner         LIKE itinerario.cod-itiner
    FIELD dt-ult-prev        LIKE historico-embarque.dt-ult-prev
    FIELD dt-efetiva         LIKE historico-embarque.dt-efetiva
    FIELD conhecimento       LIKE embarque-imp.cod-conhecto-master
    FIELD Cod-pto-contr-base LIKE cotacao-item.Cod-pto-contr-base
    FIELD cod-comprado       LIKE ordem-compra.cod-comprado
    FIELD cod-estabel        LIKE ordem-compra.cod-estabel
    FIELD dt-ent-int         AS   DATE FORMAT "99/99/9999"
    FIELD data-pedido        AS   DATE FORMAT "99/99/9999"
    FIELD un                 LIKE ITEM.un
    FIELD nome-comprado      AS   CHAR FORMAT "x(30)"
    FIELD nome-fornec        AS   CHAR FORMAT "x(30)"
    FIELD de-saldo-atu       AS   DEC  FORMAT ">>,>>>,>>9.99"
    FIELD Depos              AS   CHAR FORMAT "x(4)"
    FIELD Local              AS   CHAR FORMAT "x(80)"
    FIELD Quantidade         LIKE saldo-estoq.qtidade-atu FORMAT ">>,>>>,>>9.99" LABEL "Quantidade"
    FIELD Soma               AS   LOG FORMAT "*/ " LABEL "S"
    FIELD preco              AS   DECIMAL FORMAT ">>,>>>,>>9.99"
    FIELD moeda              AS   CHARACTER FORMAT "x(08)"
    FIELD num-seq-saldo      AS   INT
    FIELD num-pedido         LIKE pedido-compr.num-pedido
    FIELD embarque           LIKE embarque-imp.embarque
    FIELD id-meio-transp     LIKE historico-embarque.id-meio-transp
    FIELD des-pto-contr      AS   CHAR
    FIELD dat-entrega        AS   DATE
    FIELD conteiner          AS   CHAR FORMAT "X(20)":U
    FIELD qtd-conteiner      LIKE ext-embarque-imp.qtd-conteiner
    FIELD qtd2-conteiner     LIKE ext-embarque-imp.qtd2-conteiner
    FIELD situacao           AS CHAR
    FIELD dt-embarque        AS DATE FORMAT "99/99/9999"
    FIELD dt-ult-pto-contr   AS DATE FORMAT "99/99/9999"
    FIELD c-unid-negoc       AS CHAR
    INDEX id-seq     
            num-seq-saldo
    INDEX id-embarque
            num-pedido
            embarque
    INDEX id-entrega
            dat-entrega
            num-pedido
            depos.

{esp/imp/esimp000.i1} /*tt-emb*/

DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

FIND FIRST tt-param.

{utp/ut-glob.i}
{esp/eslib.i}
{esp/es0043.i} /* <--- c-dir-arquivo-session  */

ASSIGN c-endereco = tt-param.email.


DEF BUFFER b-tt-saldos FOR tt-saldos.

RUN pi-cria-saldo.

/*ASSIGN c-caminho-arquivo = SESSION:TEMP-DIRECTORY + "ESCCP037.csv". */
ASSIGN c-caminho-arquivo = c-dir-arquivo-session + "ESCCP037.csv".

/* Elimina arquivo j  existente */
OS-DELETE VALUE(c-caminho-arquivo) NO-ERROR.

/* Inicia Exporta‡Æo */
OUTPUT TO VALUE(c-caminho-arquivo) CONVERT TARGET "iso8859-1":U.

PUT "Fornec.;Nome;Data Pedido;Prev Chegada;Situa‡Æo;Item;Descri‡Æo;Unid. Negoc.;Pedido;Valor Unit.;Valor Ped./Emb.;Moeda;Situa‡Æo;Estab;Comprador;Quant.;Data Embarque;Conhecimento Embarque;éltimo Pto. Controle;Data élt. Pto. Contr.;Navio;Embarque;Itiner rio;Pto cont base;Tipo;Qtde.Contˆiner;Qtde2.Contˆiner" SKIP.

FOR EACH tt-saldos:
    FIND FIRST ITEM NO-LOCK
        WHERE ITEM.it-codigo = tt-saldos.it-codigo NO-ERROR.

    IF NOT AVAIL ITEM THEN DO:
        PUT UNFORMATTED "C¢digo CKD " + tt-saldos.it-codigo + " do pedido " + string(tt-saldos.num-pedido) + " ‚ inv lido" SKIP.
        NEXT.
    END.
    
    ASSIGN c-dt-ult-prev = IF tt-saldos.dt-ult-prev <> ? THEN string(tt-saldos.dt-ult-prev) ELSE ""
           c-dt-efetiva  = IF tt-saldos.dt-efetiva  <> ? THEN string(tt-saldos.dt-efetiva)  ELSE ""
           c-dt-ent-int  = IF tt-saldos.dt-ent-int  <> ? THEN string(tt-saldos.dt-ent-int)  ELSE ""
           c-data-pedido = IF tt-saldos.data-pedido <> ? THEN string(tt-saldos.data-pedido) ELSE "".

    FIND FIRST emitente NO-LOCK
         WHERE emitente.cod-emitente = tt-saldos.cod-emitente NO-ERROR.

    ASSIGN d-valor-unit = IF tt-saldos.quantidade = 0 THEN 0 ELSE (tt-saldos.preco / tt-saldos.quantidade).

    PUT UNFORMATTED string(tt-saldos.cod-emitente)                                  + ";" +
                    emitente.nome-abrev                                             + ";" +
                    c-data-pedido                                                   + ";" +
                    c-dt-ent-int                                                    + ";" + 
                    tt-saldos.situacao                                              + ";" +
                    tt-saldos.it-codigo                                             + ";" +
                    ITEM.desc-item                                                  + ";" +
                    tt-saldos.c-unid-negoc                                          + ";" +
                    string(tt-saldos.num-pedido)                                    + ";" +
                    STRING(d-valor-unit,">>>,>>>,>>9.99")                           + ";" +
                    string(tt-saldos.preco,">>>,>>>,>>9.99")                        + ";" +
                    string(tt-saldos.moeda)                                         + ";" + 
                    tt-saldos.depos                                                 + ";" + 
                    tt-saldos.cod-estabel                                           + ";" +
                    tt-saldos.cod-comprado                                          + ";" +
                    string(tt-saldos.quantidade,">>>,>>>,>>9.99")                   + ";" + 
                    IF tt-saldos.dt-embarque <> ? THEN string(tt-saldos.dt-embarque) ELSE ""  
                    ";" + 
                    tt-saldos.conhecimento                        + ";" +
                    tt-saldos.des-pto-contr                       + ";" + 
                    IF tt-saldos.dt-ult-pto-contr <> ? THEN string(tt-saldos.dt-ult-pto-contr) ELSE "" 
                    ";" + 
                    tt-saldos.id-meio-transp                      + ";" + 
                    tt-saldos.embarque                            + ";" + 
                    STRING(tt-saldos.cod-itiner)                  + ";" +
                    string(tt-saldos.Cod-pto-contr-base)          + ";" +
                    tt-saldos.conteiner                           + ";" +
                   /* string(tt-saldos.qtd-conteiner,"->>>>>>>>>9") + ";". */
                    IF tt-saldos.qtd-conteiner <> ? THEN string(tt-saldos.qtd-conteiner,"->>>>>>>>>9") ELSE "" + ";".

    IF  tt-saldos.conteiner = "Carga Solta":U 
    THEN PUT UNFORMATTED "VOLUMES" + ";".
    ELSE PUT UNFORMATTED string(tt-saldos.qtd2-conteiner,"->>>>>>>>>9") + ";".

    PUT SKIP.
END.

OUTPUT CLOSE.

RUN enviaMail (INPUT c-remetente,
               INPUT c-endereco,
               INPUT "Embarques Previstos CKD",
               INPUT "Embarques Previstos CKD",
               INPUT c-caminho-arquivo).

PROCEDURE pi-cria-saldo:
    
    EMPTY TEMP-TABLE tt-saldos.
    ASSIGN v-num-seq = 0.
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
    RUN pi-inicializar IN h-acomp (INPUT 'Gerando Relat¢rio Embarques Previstos').
    
    FOR EACH  int-pedido-compr NO-LOCK
        WHERE int-pedido-compr.cod-produto-ckd >= tt-param.it-codigo-ini
          AND int-pedido-compr.cod-produto-ckd <= tt-param.it-codigo-fim,
        FIRST pedido-compr NO-LOCK
            WHERE pedido-compr.num-pedido = int-pedido-compr.num-pedido:

        RUN pi-acompanhar IN h-acomp (INPUT 'Produto CKD: ' + int-pedido-compr.cod-produto-ckd).
    
        bloco-ordem-compra:
        FOR EACH  ordem-compra NO-LOCK
            WHERE ordem-compra.num-pedido   = int-pedido-compr.num-pedido
              AND ordem-compra.cod-estabel  >= tt-param.cod-estab-ini
              AND ordem-compra.cod-estabel  <= tt-param.cod-estab-fim
              AND ordem-compra.cod-emitente >= tt-param.cod-emitente-ini
              AND ordem-compra.cod-emitente <= tt-param.cod-emitente-fim
              AND ordem-compra.cod-comprado >= tt-param.cod-comprado-ini
              AND ordem-compra.cod-comprado <= tt-param.cod-comprado-fim
              AND (ordem-compra.situacao    = 2 /* Confirmada */
               OR  ordem-compra.situacao    = 6 /* Recebida */):

            FOR EACH prazo-compra OF ordem-compra NO-LOCK
               WHERE (prazo-compra.situacao    = 2
                  OR  prazo-compra.situacao    = 6)
                 AND prazo-compra.data-entrega >= tt-param.ini-data
                 AND prazo-compra.data-entrega <= tt-param.fim-data,
                EACH emitente no-lock
               WHERE emitente.cod-emitente = ordem-compra.cod-emitente
                  BY prazo-compra.data-entrega:

                IF NOT tt-param.l-confirmada AND prazo-compra.situacao = 2 /*Confirmada*/ THEN NEXT.

                IF NOT tt-param.l-recebida   AND prazo-compra.situacao = 6 /*Recebida*/ THEN NEXT.

                ASSIGN v-num-seq = v-num-seq + 1.
                CREATE tt-saldos.
                ASSIGN tt-saldos.num-seq-saldo = v-num-seq
                       tt-saldos.it-codigo     = int-pedido-compr.cod-produto-ckd
                       tt-saldos.cod-emitente  = emitente.cod-emitente
                       tt-saldos.depos         = "Ped"
                       tt-saldos.local         =  STRING(ordem-compra.num-pedido)                  + "-"   + 
                                                  SUBSTRING(STRING(prazo-compra.numero-ordem),1,6) + "-"   +
                                                  STRING(prazo-compra.parcela)                     + " - " +
                                                  STRING(prazo-compra.data-entrega,"99/99/9999")   + " - " + 
                                                  emitente.nome-abrev                              + "-"   + 
                                                  SUBSTRING(ordem-compra.narrativa,1,7)
                       tt-saldos.quantidade    = int-pedido-compr.qtd-pedido-ckd
                       tt-saldos.preco         = ordem-compra.pre-unit-for * prazo-compra.quantidade
                       tt-saldos.num-pedido    = ordem-compra.num-pedido
                       tt-saldos.dat-entrega   = prazo-compra.data-entrega
                       tt-saldos.data-pedido   = pedido-compr.data-pedido
                       tt-saldos.situacao      = IF prazo-compra.situacao = 2 THEN "NÆo Encerrado" ELSE "Encerrado".

                FIND FIRST item-uni-estab NO-LOCK
                     WHERE item-uni-estab.it-codigo   = int-pedido-compr.cod-produto-ckd
                       AND item-uni-estab.cod-estabel = ordem-compra.cod-estabel NO-ERROR.

                ASSIGN tt-saldos.c-unid-negoc = "".
                IF AVAIL item-uni-estab THEN DO:
                    RUN esp/pdp/espdp015rp-un.p (INPUT item-uni-estab.cod-unid-negoc).
                    ASSIGN tt-saldos.c-unid-negoc = RETURN-VALUE.
                END.

                FOR FIRST cotacao-item OF ordem-compra NO-LOCK:                    
                    ASSIGN tt-saldos.Cod-pto-contr-base = int(SUBSTRING(cotacao-item.char-1,41,5)). 
                END.   
                             
                ASSIGN tt-saldos.cod-comprado = ordem-compra.cod-comprado
                       tt-saldos.cod-estabel  = ordem-compra.cod-estabel.

                FIND FIRST int-prazo-compra
                    WHERE int-prazo-compra.numero-ordem = prazo-compra.numero-ordem
                      AND int-prazo-compra.parcela      = prazo-compra.parcela NO-LOCK NO-ERROR.
    
                IF AVAILABLE int-prazo-compra         AND
                   int-prazo-compra.nro-docto <> "":U THEN
                    ASSIGN tt-saldos.local = tt-saldos.local + " - NF: ":U + int-prazo-compra.nro-docto + "/":U + int-prazo-compra.serie-docto.
    
                FIND FIRST moeda NO-LOCK 
                     WHERE moeda.mo-codigo = ordem-compra.mo-codigo NO-ERROR.
                IF AVAILABLE moeda THEN 
                    ASSIGN tt-saldos.moeda = CAPS(moeda.descricao).
                ELSE
                    ASSIGN tt-saldos.moeda = STRING(ordem-compra.mo-codigo).
                    
                FOR EACH ordens-embarque NO-LOCK
                   WHERE ordens-embarque.numero-ordem  = prazo-compra.numero-ordem
                     AND ordens-embarque.parcela       = prazo-compra.parcela:
                    RUN pi-busca-posicao (INPUT  ordens-embarque.embarque,
                                          INPUT  ordens-embarque.cod-estabel). 

                    FIND FIRST tt-emb NO-ERROR.
                    IF NOT AVAIL tt-emb THEN NEXT.
                    
                    /*Ultimo Ponto de controle efetivado*/
                    FOR LAST historico-embarque NO-LOCK
                       WHERE historico-embarque.cod-estabel = ordens-embarque.cod-estabel
                         AND historico-embarque.embarque    = ordens-embarque.embarque
                         AND historico-embarque.dt-efetiva <> ?
                       BREAK BY historico-embarque.dt-efetiva:
                    END.

                    ASSIGN tt-saldos.embarque       = ordens-embarque.embarque
                           tt-saldos.id-meio-transp = IF AVAIL historico-embarque THEN historico-embarque.id-meio-transp ELSE "".
                    
                    CASE tt-emb.situacao:
                        WHEN 1  THEN ASSIGN tt-saldos.depos = "Prev".
                        WHEN 99 THEN ASSIGN tt-saldos.depos = "Agt".
                        WHEN 2  THEN ASSIGN tt-saldos.depos = "Embar".
                        WHEN 98 THEN ASSIGN tt-saldos.depos = "DI".
                        WHEN 3  THEN ASSIGN tt-saldos.depos = "Desp".
                        WHEN 4  THEN ASSIGN tt-saldos.depos = "NF".
                        WHEN 96 THEN ASSIGN tt-saldos.depos = "Inst".
                        WHEN 97 THEN ASSIGN tt-saldos.depos = "Manut".
                    END CASE.

                    ASSIGN tt-saldos.cod-itiner = tt-emb.cod-itiner.
    
                    IF ordens-embarque.embarque <> tt-emb.conhecimento /* antes de ter a informa‡Æo correta do conhecimento ‚ gravado o embarque no campo conhecimento no im0045 */
                    THEN
                        ASSIGN tt-emb.conhecimento = tt-emb.conhecimento.

                    ASSIGN tt-saldos.conhecimento     = tt-emb.conhecimento
                           tt-saldos.dt-ult-prev      = tt-emb.dt-ult-prev    
                           tt-saldos.dt-efetiva       = tt-emb.dt-efetiva
                           tt-saldos.dt-ent-int       = tt-emb.dt-ent-int
                           tt-saldos.dt-embarque      = tt-emb.dt-embarque
                           tt-saldos.dt-ult-pto-contr = tt-emb.dt-ult-pto-contr
                           tt-saldos.des-pto-contr    = tt-emb.des-ult-pto-contr.  
    
                    ASSIGN tt-saldos.local = STRING(ordem-compra.num-pedido)                  + "-" +
                                             emitente.nome-abrev                              + "-" + 
                                             tt-emb.conhecimento                              + "-" +
                                             STRING(tt-emb.dt-embarque,"99/99/9999")          + "-" +
                                             STRING(prazo-compra.data-entrega,"99/99/9999").

                    FIND FIRST ext-embarque-imp NO-LOCK
                        WHERE  ext-embarque-imp.cod-estabel = ordens-embarque.cod-estabel
                        AND    ext-embarque-imp.embarque    = ordens-embarque.embarque NO-ERROR.
                    IF  AVAIL  ext-embarque-imp THEN DO:

                        ASSIGN tt-saldos.conteiner      = IF ext-embarque-imp.conteiner = 1 
                                                          THEN "Contˆiner de 20":U
                                                          ELSE IF ext-embarque-imp.conteiner = 2
                                                               THEN "Contˆiner de 40":U
                                                               ELSE IF ext-embarque-imp.conteiner = 3
                                                                     THEN "Contˆiner de 20/40":U
                                                                     ELSE IF ext-embarque-imp.conteiner = 4
                                                                          THEN "NOR 20":U
                                                                          ELSE IF ext-embarque-imp.conteiner = 5
                                                                               THEN "NOR 40":U
                                                                               ELSE "Carga Solta":U
                               tt-saldos.qtd-conteiner  = ext-embarque-imp.qtd-conteiner
                               tt-saldos.qtd2-conteiner = ext-embarque-imp.qtd2-conteiner.

                    END. /* IF  AVAIL  ext-embarque-imp THEN DO: */
                    ELSE DO:
                        ASSIGN tt-saldos.conteiner      = ""
                               tt-saldos.qtd-conteiner  = 0
                               tt-saldos.qtd2-conteiner = 0.
                    END. /* ELSE DO: */
                END. /* FOR EACH ordens-embarque NO-LOCK */
            END. /* FOR EACH prazo-compra OF ordem-compra NO-LOCK */
        END. /* FOR EACH  ordem-compra NO-LOCK */
    END. /* FOR EACH  int-pedido-compr NO-LOCK */
    
    /* Agrupar ordens do mesmo pedido/embarque */
    
    FOR EACH tt-saldos
        BREAK BY tt-saldos.num-pedido
              BY tt-saldos.embarque:
    
        IF  FIRST-OF(tt-saldos.embarque)
        THEN DO:
            FOR EACH b-tt-saldos
               WHERE b-tt-saldos.num-pedido     = tt-saldos.num-pedido
                 AND b-tt-saldos.embarque       = tt-saldos.embarque
                 AND b-tt-saldos.num-seq-saldo <> tt-saldos.num-seq-saldo: 
    
                ASSIGN tt-saldos.preco = tt-saldos.preco + b-tt-saldos.preco.
            END.
        END.
        ELSE
            DELETE tt-saldos.
    END.

    RUN pi-finalizar IN h-acomp.

END PROCEDURE.

PROCEDURE pi-busca-posicao :

DEF INPUT  PARAM p-embarque      LIKE embarque-imp.embarque    NO-UNDO.
DEF INPUT  PARAM p-cod-estab     LIKE embarque-imp.cod-estabel NO-UNDO.

FOR EACH embarque-imp NO-LOCK
   WHERE /*embarque-imp.situacao = 1
     AND*/ embarque-imp.cod-estabel = p-cod-estab
     AND embarque-imp.embarque    = p-embarque:

    {esp/imp/esimp000.i}
END.

END PROCEDURE.
