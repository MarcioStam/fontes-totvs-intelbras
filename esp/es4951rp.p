/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ES4951RP 2.00.00.005}
/*------------------------------------------------------------------------
    File        : ES4951RP.P
    Purpose     : Janela de Cancelamento
    Syntax      : <none>
    Description : <none>

    Author(s)   : Fabiano Sakae Ribeiro (Exponencial TI / SQL Works)
    Created     : Outubro de 2011
    Notes       : <none>
----------------------------------------------------------------------*/

/* Include Definitions ---                                              */

{esp/es4951.i}
{utp/utapi019.i}
{include/i-rpvar.i}


/* Local Temp-Table Definitions ---                                     */

DEFINE TEMP-TABLE tt-item-para-cancel NO-UNDO
    FIELD num-pedido         LIKE ordem-compra.num-pedido
    FIELD nome-abrev         LIKE emitente.nome-abrev
    FIELD embarque           LIKE embarque-imp.embarque
    FIELD cod-estabel        LIKE embarque-imp.cod-estabel
    FIELD it-codigo          LIKE ordem-compra.it-codigo
    FIELD dt-ult-previsao    LIKE historico-embarque.dt-ult-previsao
    FIELD janela-dias-cancel LIKE int-item-fornec.janela-dias-cancel
    FIELD dt-max-cancel      AS DATE FORMAT "99/99/9999":U
    FIELD vl-total-ordem     AS DECIMAL FORMAT ">>>>>,>>>,>>9.9999":U
    FIELD numero-ordem       LIKE ordem-compra.numero-ordem
    FIELD parcela            LIKE prazo-compra.parcela
    INDEX chPrimario AS PRIMARY UNIQUE
        num-pedido
        embarque
        it-codigo.

DEFINE TEMP-TABLE tt-cotacao-item NO-UNDO LIKE cotacao-item
    FIELD r-Rowid AS ROWID.


/* Local Variable Definitions ---                                       */

DEFINE VARIABLE h-acomp        AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-remetente    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-destinatario AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-assunto      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-arquivo      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-destino      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE h-boin082      AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-retorno      AS CHARACTER   NO-UNDO.


/* Stream Definitions ---                                               */

DEFINE STREAM str-out.
DEFINE STREAM str-rp.


/* Form Definitions ---                                                 */

FORM tt-item-para-cancel.num-pedido         COLUMN-LABEL "Pedido":U
     tt-item-para-cancel.nome-abrev         COLUMN-LABEL "Fornecedor":U
     tt-item-para-cancel.embarque           COLUMN-LABEL "Embarque":U
     tt-item-para-cancel.cod-estabel        COLUMN-LABEL "Est":U
     tt-item-para-cancel.it-codigo          COLUMN-LABEL "Item":U
     tt-item-para-cancel.dt-ult-previsao    COLUMN-LABEL "Prev Entreg":U
     tt-item-para-cancel.janela-dias-cancel COLUMN-LABEL "Janel Canc":U
     tt-item-para-cancel.dt-max-cancel      COLUMN-LABEL "Dt M x p/ Canc":U
     tt-item-para-cancel.vl-total-ordem     COLUMN-LABEL "Vl Total Ordem":U
     tt-item-para-cancel.numero-ordem       COLUMN-LABEL "Ord Compra":U
     tt-item-para-cancel.parcela            COLUMN-LABEL "Parc":U
    WITH FRAME f-relat DOWN STREAM-IO WIDTH 132.


/* Parameter Definitions ---                                            */

DEFINE INPUT  PARAMETER raw-param AS RAW         NO-UNDO.
DEFINE INPUT  PARAMETER TABLE FOR tt-raw-digita.


/* ***************************  Main Block  *************************** */

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

FIND FIRST param-global NO-LOCK NO-ERROR.

FIND FIRST mgcad.empresa
    WHERE empresa.ep-codigo = param-global.empresa-pri NO-LOCK NO-ERROR.

ASSIGN c-empresa      = IF AVAILABLE empresa THEN empresa.razao-social ELSE "":U
       c-titulo-relat = "Janela de Cancelamento":U
       c-sistema	  = "Espec¡ficos Intelbras":U.

{include/i-rpcab.i &stream = "str-rp"}
{include/i-rpout.i &stream = "STREAM str-rp"}

VIEW STREAM str-rp FRAME f-cabec.
VIEW STREAM str-rp FRAME f-rodape.

IF NOT VALID-HANDLE(h-acomp) THEN
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp NO-ERROR.

IF VALID-HANDLE(h-acomp) THEN
    RUN pi-inicializar IN h-acomp (INPUT "Gerando relat¢rio...":U).

EMPTY TEMP-TABLE tt-item-para-cancel.

bk-embarque:
FOR EACH embarque-imp NO-LOCK
    WHERE embarque-imp.situacao = 1:

    FIND FIRST historico-embarque OF embarque-imp NO-LOCK NO-ERROR.

    IF NOT AVAILABLE historico-embarque THEN NEXT bk-embarque.

    FIND FIRST itinerario
        WHERE itinerario.cod-itiner = historico-embarque.cod-itiner NO-LOCK NO-ERROR.

    IF NOT AVAILABLE itinerario THEN NEXT bk-embarque.

    FIND FIRST historico-embarque OF embarque-imp
        /*WHERE historico-embarque.cod-pto-contr = itinerario.pto-embarque*/ NO-LOCK NO-ERROR.

    IF NOT AVAILABLE historico-embarque     OR
       (AVAILABLE historico-embarque        AND
        historico-embarque.dt-efetiva <> ?) THEN NEXT bk-embarque.

    bk-ordens-embarque:
    FOR EACH ordens-embarque NO-LOCK
        WHERE ordens-embarque.cod-estabel = embarque-imp.cod-estabel
          AND ordens-embarque.embarque    = embarque-imp.embarque,
        EACH ordem-compra NO-LOCK
        WHERE ordem-compra.numero-ordem = ordens-embarque.numero-ordem,
        EACH prazo-compra NO-LOCK
        WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem:

        FIND FIRST int-item-fornec
            WHERE int-item-fornec.it-codigo    = ordem-compra.it-codigo
              AND int-item-fornec.cod-emitente = ordem-compra.cod-emitente NO-LOCK NO-ERROR.

        IF NOT AVAILABLE int-item-fornec                                                     OR
           (AVAILABLE int-item-fornec                                                        AND
            int-item-fornec.janela-dias-cancel > historico-embarque.dt-ult-previsao - TODAY) THEN NEXT bk-ordens-embarque.

        IF VALID-HANDLE(h-acomp) THEN
            RUN pi-acompanhar IN h-acomp (INPUT "Pedido: ":U + TRIM(STRING(ordem-compra.num-pedido)) + " - Embarque: ":U + TRIM(embarque-imp.embarque) + " - Item: ":U + TRIM(ordem-compra.it-codigo)).

        FIND FIRST tt-item-para-cancel
            WHERE tt-item-para-cancel.num-pedido = ordem-compra.num-pedido
              AND tt-item-para-cancel.embarque   = embarque-imp.embarque
              AND tt-item-para-cancel.it-codigo  = ordem-compra.it-codigo NO-ERROR.

        IF NOT AVAILABLE tt-item-para-cancel THEN DO:
            FIND FIRST emitente
                WHERE emitente.cod-emitente = ordem-compra.cod-emitente NO-LOCK NO-ERROR.

            CREATE tt-item-para-cancel.
            ASSIGN tt-item-para-cancel.num-pedido         = ordem-compra.num-pedido
                   tt-item-para-cancel.nome-abrev         = IF AVAILABLE emitente THEN emitente.nome-abrev ELSE "":U
                   tt-item-para-cancel.cod-estabel        = embarque-imp.cod-estabel
                   tt-item-para-cancel.embarque           = embarque-imp.embarque
                   tt-item-para-cancel.it-codigo          = ordem-compra.it-codigo
                   tt-item-para-cancel.dt-ult-previsao    = historico-embarque.dt-ult-previsao
                   tt-item-para-cancel.janela-dias-cancel = int-item-fornec.janela-dias-cancel
                   tt-item-para-cancel.dt-max-cancel      = historico-embarque.dt-ult-previsao - int-item-fornec.janela-dias-cancel
                   tt-item-para-cancel.numero-ordem       = ordem-compra.numero-ordem
                   tt-item-para-cancel.parcela            = prazo-compra.parcela.

            EMPTY TEMP-TABLE tt-cotacao-item.

            IF NOT VALID-HANDLE(h-boin082) THEN
                RUN inbo/boin082.p PERSISTENT SET h-boin082.

            IF VALID-HANDLE(h-boin082) THEN DO:
                RUN setConstraintNumOrdem IN h-boin082 (INPUT ordem-compra.numero-ordem).
                RUN openQueryStatic       IN h-boin082 (INPUT "ByCotacao":U).

                RUN findCotacaoAprovada IN h-boin082 (INPUT  ordem-compra.numero-ordem,
                                                      OUTPUT c-retorno).

                IF c-retorno = "":U THEN
                    RUN getCurrent IN h-boin082 (OUTPUT TABLE tt-cotacao-item).
            END.

            FIND FIRST tt-cotacao-item NO-LOCK NO-ERROR.

            IF AVAILABLE tt-cotacao-item THEN
                ASSIGN tt-item-para-cancel.vl-total-ordem = tt-cotacao-item.pre-unit-for * prazo-compra.quantidade.
        END.
    END.

    IF VALID-HANDLE(h-boin082) THEN
        DELETE PROCEDURE h-boin082.

    ASSIGN h-boin082 = ?.
END.

IF VALID-HANDLE(h-acomp) THEN
    RUN pi-acompanhar IN h-acomp (INPUT "Finalizando gera‡Æo...":U).

FOR FIRST ponto-programa NO-LOCK
    WHERE ponto-programa.nome-programa = "es4951rp":U
      AND ponto-programa.ponto         = 1,
    EACH conteudo-programa NO-LOCK
    WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
      AND conteudo-programa.sequencia    = 1:
    ASSIGN c-destinatario = conteudo-programa.conteudo.
END.

ASSIGN c-remetente = "ems@intelbras.com.br":U
       c-assunto   = c-titulo-relat.

IF CAN-FIND(FIRST tt-item-para-cancel) THEN DO:
    ASSIGN c-arquivo = REPLACE(SESSION:TEMP-DIRECTORY, "~\":U, "/":U) + "es4951rp.csv":U
           c-arquivo = LC(c-arquivo).

    OUTPUT STREAM str-out TO VALUE(c-arquivo) CONVERT TARGET "iso8859-1":U.
    PUT STREAM str-out UNFORMATTED
        "Pedido;Fornecedor;Embarque;Estabelecimento;Item;Dt Prev Entrega;Janela Cancelamento;Data M x p/ Cancel;Vl Total Ordem;Nro Ordem Compra;Parcela":U SKIP.

    FOR EACH tt-item-para-cancel:
        DISPLAY STREAM str-rp
            tt-item-para-cancel.num-pedido
            tt-item-para-cancel.nome-abrev
            tt-item-para-cancel.embarque
            tt-item-para-cancel.cod-estabel
            tt-item-para-cancel.it-codigo
            tt-item-para-cancel.dt-ult-previsao
            tt-item-para-cancel.janela-dias-cancel
            tt-item-para-cancel.dt-max-cancel
            tt-item-para-cancel.vl-total-ordem
            tt-item-para-cancel.numero-ordem
            tt-item-para-cancel.parcela
            WITH FRAME f-relat.
        DOWN STREAM str-rp WITH FRAME f-relat.

        PUT STREAM str-out UNFORMATTED
            TRIM(STRING(tt-item-para-cancel.num-pedido))                              ";":U
            TRIM(tt-item-para-cancel.nome-abrev)                                      ";":U
            TRIM(tt-item-para-cancel.embarque)                                        ";":U
            TRIM(tt-item-para-cancel.cod-estabel)                                     ";":U
            TRIM(tt-item-para-cancel.it-codigo)                                       ";":U
            TRIM(STRING(tt-item-para-cancel.dt-ult-previsao, "99/99/9999":U))         ";":U
            TRIM(STRING(tt-item-para-cancel.janela-dias-cancel, ">>9":U))             ";":U
            TRIM(STRING(tt-item-para-cancel.dt-max-cancel, "99/99/9999":U))           ";":U
            TRIM(STRING(tt-item-para-cancel.vl-total-ordem, ">>>>>,>>>,>>9.99999":U)) ";":U
            TRIM(STRING(tt-item-para-cancel.numero-ordem, "zzzzz9,99":U))             ";":U
            TRIM(STRING(tt-item-para-cancel.parcela, ">>>>9":U))                      SKIP.
    END.
    OUTPUT STREAM str-out CLOSE.

    RUN piEnviaEmail IN THIS-PROCEDURE (INPUT c-remetente,
                                        INPUT c-destinatario,
                                        INPUT c-assunto,
                                        INPUT "Prezado(a).":U + CHR(10) + CHR(10) + "     Segue anexo o arquivo contendo os pedidos de itens importados com tempo h bil para cancelamento.":U + CHR(13) + CHR(13) + CHR(13) + "<E-mail autom tico. NÆo responda.>":U,
                                        INPUT c-arquivo).

    OS-DELETE VALUE(c-arquivo) NO-ERROR.
END.
ELSE DO:
    PUT STREAM str-rp
        SKIP
        SKIP
        "NÆo foi encontrado nenhum pedido de itens importados com tempo h bil para cancelamento.":U.

    RUN piEnviaEmail IN THIS-PROCEDURE (INPUT c-remetente,
                                        INPUT c-destinatario,
                                        INPUT c-assunto,
                                        INPUT "Prezado(a).":U + CHR(10) + CHR(10) + "     NÆo foi encontrado nenhum pedido de itens importados com tempo h bil para cancelamento.":U + CHR(13) + CHR(13) + CHR(13) + "<E-mail autom tico. NÆo responda.>":U,
                                        INPUT "":U).
END.

PAGE STREAM str-rp.

ASSIGN c-destino = {varinc/var00002.i 04 tt-param.destino}.

PUT STREAM str-rp UNFORMATTED
    SKIP(3)
    "        IMPRESSÇO":U SKIP(2)
    "                       Destino: ":U + c-destino + " - ":U + tt-param.arquivo SKIP
    "              CSV enviado para: ":U + c-destinatario.

IF VALID-HANDLE(h-acomp) THEN
    RUN pi-finalizar IN h-acomp.

{include/i-rpclo.i &stream = "STREAM str-rp"}

IF VALID-HANDLE(h-acomp) THEN
    DELETE PROCEDURE h-acomp.

ASSIGN h-acomp = ?.

RETURN "OK":U.


PROCEDURE piEnviaEmail:
    DEFINE INPUT  PARAMETER p-remetente AS CHARACTER   NO-UNDO.
    DEFINE INPUT  PARAMETER p-destino   AS CHARACTER   NO-UNDO.
    DEFINE INPUT  PARAMETER p-assunto   AS CHARACTER   NO-UNDO.
    DEFINE INPUT  PARAMETER p-mensagem  AS CHARACTER   NO-UNDO.
    DEFINE INPUT  PARAMETER p-arquivo   AS CHARACTER   NO-UNDO.

    DEFINE VARIABLE h-utapi019 AS HANDLE      NO-UNDO.

    IF NOT VALID-HANDLE(h-utapi019) THEN
        RUN utp/utapi019.p PERSISTENT SET h-utapi019 NO-ERROR.

    IF NOT VALID-HANDLE(h-utapi019) THEN
        RETURN "OK":U.

    EMPTY TEMP-TABLE tt-envio2.
    EMPTY TEMP-TABLE tt-mensagem.

    FIND FIRST param-global NO-LOCK NO-ERROR.

    CREATE tt-envio2.
    ASSIGN tt-envio2.versao-integracao = 1
           tt-envio2.servidor          = param-global.serv-mail
           tt-envio2.porta             = param-global.porta-mail
           tt-envio2.destino           = p-destino
           tt-envio2.remetente         = p-remetente
           tt-envio2.assunto           = p-assunto
           tt-envio2.arq-anexo         = p-arquivo
           tt-envio2.formato           = "TEXTO":U.

    CREATE tt-mensagem.
    ASSIGN tt-mensagem.seq-mensagem = 1
           tt-mensagem.mensagem     = p-mensagem.

    IF VALID-HANDLE(h-utapi019) THEN
        RUN pi-execute2 IN h-utapi019 (INPUT  TABLE tt-envio2,
                                       INPUT  TABLE tt-mensagem,
                                       OUTPUT TABLE tt-erros).

    IF VALID-HANDLE(h-utapi019) THEN
        DELETE PROCEDURE h-utapi019.

    IF CAN-FIND(FIRST tt-erros) THEN
        RETURN "NOK":U.

    RETURN "OK":U.

END PROCEDURE.

