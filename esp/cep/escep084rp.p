{include/i-prgvrs.i escep084rp 2.00.00.001}
{esp/esb/esesb000.i}
{esp/wso/out/wso0002.i}
{esp/es0018.i}
{utp/ut-glob.i}
{cdp/cd0666.i} /*tt-erro*/
{esp/pdp/espdp006fn.i}
{btb/btb912zb.i}
{utp/utapi019.i}

DEF VAR de-blq-wms       LIKE saldo-estoq.qtidade-atu NO-UNDO.
DEFINE VARIABLE h-acomp AS HANDLE      NO-UNDO.
DEFINE VARIABLE i-cont-aux                                  AS INT NO-UNDO.

DEFINE TEMP-TABLE tt-item
    FIELD it-codigo LIKE ITEM.it-codigo.

define temp-table tt-param-escep084 no-undo
    field destino          as integer
    field arquivo          as char format "x(35)"
    field usuario          as char format "x(12)"
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field desc-classifica  as char format "x(40)"
    field modelo-rtf       as char format "x(35)"
    field l-habilitaRtf    as LOG
    FIELD sku              AS CHAR
    FIELD quantidade       AS DEC 
    FIELD estabelecimento  AS CHAR
    FIELD deposito         AS CHAR
    FIELD unidadeMedida    AS CHAR
    FIELD tabela           AS CHAR.

DEFINE VARIABLE oXML          AS LONGCHAR NO-UNDO.

define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)"
    field usuario          as char format "x(12)"
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field desc-classifica  as char format "x(40)"
    field modelo-rtf       as char format "x(35)"
    field l-habilitaRtf    as LOG
    field fi-tab-ini       AS CHAR
    field fi-tab-fim       AS CHAR
    field fi-item-ini      AS CHAR
    field fi-item-fim      AS CHAR.
    
DEFINE TEMP-TABLE tt-digita NO-UNDO
    FIELD ordem            AS INTEGER   FORMAT ">>>>9":U
    FIELD exemplo          AS CHARACTER FORMAT "x(30)":U
    INDEX id ordem.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.

DEF TEMP-TABLE tt-lista
    FIELD it-codigo    LIKE saldo-estoq.it-codigo
    FIELD cod-estabel  LIKE saldo-estoq.cod-estabel
    FIELD cod-depos    LIKE saldo-estoq.cod-depos
    FIELD quantidade  LIKE saldo-estoq.qtidade-atu.

DEFINE TEMP-TABLE tt2-prog-ponto LIKE tt-prog-ponto.

DEFINE input parameter raw-param as raw no-undo.
DEFINE input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

DEF VAR qtd-dispon       LIKE preco-item.quant-min.
DEF VAR qtd-dispon-total LIKE preco-item.quant-min.
DEF VAR l-central-config AS LOG NO-UNDO.

DEFINE VARIABLE c-arquivo-csv   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-arquivo-lista AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-dir-saida     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-arq-excel     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE de-qtd-anterior AS DEC         NO-UNDO.
DEFINE VARIABLE c-emails        AS CHARACTER   NO-UNDO.


IF NOT VALID-HANDLE(h-acomp) THEN
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

IF VALID-HANDLE(h-acomp) THEN
    RUN pi-inicializar IN h-acomp (INPUT "Lendo...":U).

EMPTY TEMP-TABLE tt-prog-ponto.
    
RUN esp/es0018p.p (INPUT "Vtex-preco":U,
                   INPUT 1,
                   INPUT 0,
                   INPUT "":U,
                   OUTPUT TABLE tt-prog-ponto).

FIND FIRST tt-param NO-ERROR.

IF  tt-param.fi-tab-ini  = ""
AND tt-param.fi-tab-fim  = "ZZZZZZZZ"
AND tt-param.fi-item-ini = ""
AND tt-param.fi-item-fim = "ZZZZZZZZZZZZZZZZ" THEN DO:
    FOR EACH tt-prog-ponto
       WHERE entry(3, tt-prog-ponto.conteudo, ";") = "sim",
        EACH tb-preco NO-LOCK
       WHERE tb-preco.nr-tabpre = entry(1, tt-prog-ponto.conteudo, ";")
         AND tb-preco.situacao = 1,
        EACH preco-item NO-LOCK
       WHERE preco-item.nr-tabpre = tb-preco.nr-tabpre
         AND preco-item.situacao  = 1:
    
        RUN pi-acompanhar in h-acomp (input "Lendo Itens: " + preco-item.it-codigo).
    
        IF NOT CAN-FIND(FIRST tt-item
                        WHERE tt-item.it-codigo = preco-item.it-codigo) THEN DO:
            CREATE tt-item.
            ASSIGN tt-item.it-codigo   = preco-item.it-codigo.
        END.
    END.
END.
ELSE DO:
    FOR EACH tt-prog-ponto
       WHERE entry(3, tt-prog-ponto.conteudo, ";") = "sim",
        EACH tb-preco NO-LOCK
       WHERE tb-preco.nr-tabpre = entry(1, tt-prog-ponto.conteudo, ";")
         AND tb-preco.situacao = 1,
        EACH preco-item NO-LOCK
       WHERE preco-item.nr-tabpre = tb-preco.nr-tabpre
         AND preco-item.situacao  = 1
         AND preco-item.nr-tabpre >= tt-param.fi-tab-ini
         AND preco-item.nr-tabpre <= tt-param.fi-tab-fim
         AND preco-item.it-codigo >= tt-param.fi-item-ini
         AND preco-item.it-codigo <= tt-param.fi-item-fim:
    
        RUN pi-acompanhar in h-acomp (input "Lendo Itens: " + preco-item.it-codigo).
    
        IF NOT CAN-FIND(FIRST tt-item
                        WHERE tt-item.it-codigo = preco-item.it-codigo) THEN DO:
            CREATE tt-item.
            ASSIGN tt-item.it-codigo = preco-item.it-codigo.
        END.
    END.
END.

FOR EACH tt-item:
    
    RUN pi-acompanhar in h-acomp (input "Item: " + tt-item.it-codigo).

    FOR EACH int-vtex-estab-depos NO-LOCK,
        EACH saldo-estoq NO-LOCK
       WHERE saldo-estoq.it-codigo = tt-item.it-codigo
         AND saldo-estoq.cod-estab = int-vtex-estab-depos.cod-estab
         AND saldo-estoq.cod-depos = int-vtex-estab-depos.cod-depos
         AND saldo-estoq.cod-localiz = ""
       BREAK BY saldo-estoq.cod-estabel
             BY saldo-estoq.cod-depos:

        IF  FIRST-OF (Saldo-estoq.cod-depos) THEN DO:
            //EMPTY TEMP-TABLE ttEstoque.
            ASSIGN qtd-dispon-total = 0.
        END.
        
        ASSIGN l-central-config = CAN-FIND(FIRST item-uni-estab USE-INDEX codigo
                                           WHERE item-uni-estab.it-codigo   = saldo-estoq.it-codigo
                                             AND item-uni-estab.cod-estabel = saldo-estoq.cod-estabel
                                             AND item-uni-estab.nr-linha    = 20).

        ASSIGN qtd-dispon = fnEstoque(saldo-estoq.cod-estabel, saldo-estoq.it-codigo, saldo-estoq.cod-depos, saldo-estoq.cod-localiz, l-central-config).

        ASSIGN qtd-dispon-total = qtd-dispon-total + qtd-dispon.

        IF  LAST-OF (saldo-estoq.cod-depos) /*AND qtd-dispon-total > 0 */ THEN DO:

            RUN pi-acompanhar in h-acomp (input "Integrando SKU: " + tt-item.it-codigo).

            IF saldo-estoq.cod-depos <> "SAL" THEN DO:

                FIND FIRST int-estoque-ecommerce NO-LOCK
                     WHERE int-estoque-ecommerce.it-codigo   = saldo-estoq.it-codigo
                       AND int-estoque-ecommerce.cod-estabel = saldo-estoq.cod-estabel
                       AND int-estoque-ecommerce.cod-depos   = saldo-estoq.cod-depos NO-ERROR.
                IF NOT AVAIL int-estoque-ecommerce THEN DO:
                    CREATE int-estoque-ecommerce.
                    ASSIGN int-estoque-ecommerce.it-codigo   = saldo-estoq.it-codigo   
                           int-estoque-ecommerce.cod-estabel = saldo-estoq.cod-estabel 
                           int-estoque-ecommerce.cod-depos   = saldo-estoq.cod-depos.
                END.
                ASSIGN de-qtd-anterior = int-estoque-ecommerce.quantidade.
                IF int-estoque-ecommerce.quantidade <> qtd-dispon-total THEN DO:
                    FIND CURRENT int-estoque-ecommerce EXCLUSIVE-LOCK NO-ERROR. 
                    ASSIGN int-estoque-ecommerce.quantidade = qtd-dispon-total
                           int-estoque-ecommerce.situacao = 1
                           int-estoque-ecommerce.dt-atual = TODAY
                           int-estoque-ecommerce.hr-atual = STRING(TIME,"HH:MM").
                    FIND CURRENT int-estoque-ecommerce NO-LOCK NO-ERROR.

                    IF qtd-dispon-total = 0 THEN
                        RUN pi-envia-email.
                END.
            END.
        END.
    END.
END.

IF CAN-FIND(FIRST int-estoque-ecommerce
            WHERE int-estoque-ecommerce.situacao = 1) THEN
    RUN pi-estoque-wso2.

IF VALID-HANDLE(h-acomp) THEN
    RUN pi-finalizar IN h-acomp.

IF VALID-HANDLE(h-acomp) THEN
    DELETE PROCEDURE h-acomp.

RETURN "OK".

PROCEDURE pi-estoque-wso2:

    RUN esp/wso/out/wso0002.p (INPUT "v1/produto/estoque-ecommerce",
                               INPUT TABLE ttEstoque).

END PROCEDURE.

PROCEDURE pi-envia-email:

    run pi-acompanhar in h-acomp (input "Gerando e-mail.").

    DEF VAR c-corpo-email AS CHAR FORMAT "x(2000)" NO-UNDO.

    IF c-emails = "" THEN DO:
        EMPTY TEMP-TABLE tt2-prog-ponto.
        RUN esp/es0018p.p (INPUT "Vtex-preco":U,
                           INPUT 2,
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt2-prog-ponto).

        FOR EACH tt2-prog-ponto:
            ASSIGN c-emails = tt2-prog-ponto.conteudo.
        END.
    END.

    FOR FIRST param-global NO-LOCK: END.    

    RUN utp/utapi019.p PERSISTENT SET h-utapi019.

    FOR EACH tt-envio2.   DELETE tt-envio2.   END.
    FOR EACH tt-mensagem. DELETE tt-mensagem. END.

    CREATE tt-envio2.
    ASSIGN tt-envio2.versao-integracao = 1
           tt-envio2.servidor          = param-global.serv-mail               /* Servidor de E-Mail */ 
           tt-envio2.porta             = param-global.porta-mail              /* Porta do Servidor  */ 
           tt-envio2.destino           = c-emails                             /* DestinatÙrio       */ 
           tt-envio2.remetente         = "ems@intelbras.com.br"               /* Remetente          */ 
           tt-envio2.assunto           = "[ECOMMERCE] Item: " + saldo-estoq.it-codigo + " com estoque zerado"       /* Assunto            */
           tt-envio2.formato           = "TEXTO".

    FIND FIRST ITEM WHERE ITEM.it-codigo = saldo-estoq.it-codigo NO-LOCK NO-ERROR.
    IF AVAIL ITEM THEN
        ASSIGN c-corpo-email = "Item: " + saldo-estoq.it-codigo + " - " + ITEM.desc-item + CHR(10) + 
                               "Quantidade anterior: " + STRING(de-qtd-anterior) + CHR(10) +  
                               "Quantidade atual: " + STRING(qtd-dispon-total).

    CREATE tt-mensagem.
    ASSIGN tt-mensagem.seq-mensagem = 1
           tt-mensagem.mensagem     = c-corpo-email.          /* Mensagem           */

    RUN pi-execute2 in h-utapi019 (INPUT  TABLE tt-envio2,
                                   INPUT  TABLE tt-mensagem,
                                   OUTPUT TABLE tt-erros).
    

END.
