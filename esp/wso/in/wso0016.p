{esp/esb/esesb000.i}
{esp/wso/in/wso0003.i}
 
DEF TEMP-TABLE tt-usuarios-reserva NO-UNDO
    FIELD usuario AS CHAR.

def temp-table tt-erro no-undo
    field i-sequen as int             
    field cd-erro  as int
    field mensagem as char format "x(255)".

DEFINE VARIABLE h-wso0003-espec  AS HANDLE   NO-UNDO.

/* ------------------------------------------------------------------ */
/*                  V A R I µ V E I S  PESSOA                         */
/* -------------------------------------------------------------------*/
DEFINE VARIABLE i-cod-emitente         AS INTEGER     NO-UNDO.
DEFINE VARIABLE p-i-ind-tipo-movto     AS INTEGER     NO-UNDO.
DEFINE VARIABLE d-aliq-ipi             AS DECIMAL     NO-UNDO.


DEFINE BUFFER b-emitente       FOR emitente.
DEFINE BUFFER b-emitente-comis FOR emitente.
DEFINE BUFFER ttDocumento-IE   FOR ttDocumento.
DEFINE BUFFER bint-pedido-vtex FOR int-pedido-vtex.

/* ------------------------------------------------------------------ */
/*                     V A R I µ V E I S  PEDIDO                      */
/* -------------------------------------------------------------------*/
DEFINE VARIABLE c-nome-abrev           AS CHARACTER    NO-UNDO.
DEFINE VARIABLE l-log                  AS LOGICAL      NO-UNDO.
DEFINE VARIABLE c-telefone-1           AS CHAR         NO-UNDO.
DEFINE VARIABLE c-telefone-2           AS CHAR         NO-UNDO.
DEFINE VARIABLE l-cep-entrega-padrao   AS LOG          NO-UNDO.
DEFINE VARIABLE i-cod-sit-aval         AS INTEGER      NO-UNDO.
DEFINE VARIABLE c-nat-oper-cabecalho   AS CHARACTER    NO-UNDO.
DEFINE VARIABLE c-nat-oper             AS CHARACTER    NO-UNDO.
DEFINE VARIABLE c-natureza             AS CHARACTER    NO-UNDO.
DEFINE VARIABLE c-natureza-de          AS CHARACTER    NO-UNDO.
DEFINE VARIABLE c-natureza-fe          AS CHARACTER    NO-UNDO.
DEFINE VARIABLE i-cont-nat-igual       AS INTEGER      NO-UNDO.
DEFINE VARIABLE l-mantem-nat           AS LOGICAL      NO-UNDO.
DEFINE VARIABLE l-consumidor-final     AS LOGICAL      NO-UNDO.
DEFINE VARIABLE l-erro                 AS LOGICAL      NO-UNDO.
DEFINE VARIABLE h-bodi159cal           AS HANDLE       NO-UNDO.
DEFINE VARIABLE l-return               AS LOGICAL      NO-UNDO.
DEFINE VARIABLE c-transpordara-xml     AS CHAR         NO-UNDO.
DEFINE VARIABLE c-estabelec-xml        AS CHAR         NO-UNDO.
DEFINE VARIABLE c-atendente            AS CHARACTER    NO-UNDO.
DEFINE VARIABLE i-prioridade           AS INTEGER      NO-UNDO.
DEFINE VARIABLE de-vl-preco            AS DECIMAL      NO-UNDO.
DEFINE VARIABLE de-vl-pre-liq          AS DECIMAL      NO-UNDO.
DEFINE VARIABLE d-vl-liq-abe           AS DECIMAL      NO-UNDO.
DEFINE VARIABLE d-vl-liq-it            AS DECIMAL      NO-UNDO.
DEFINE VARIABLE i-sequencia            AS INTEGER      NO-UNDO.
DEFINE VARIABLE l-envia-pedido             AS LOG INIT YES NO-UNDO.
DEFINE VARIABLE l-suspender-pedido     AS LOG          NO-UNDO.
DEFINE VARIABLE c-cod-redespacho       AS CHAR         NO-UNDO.   
DEFINE VARIABLE c-estab-entrega        AS CHAR         NO-UNDO. 
DEFINE VARIABLE h-boes505              as handle       NO-UNDO.
DEFINE VARIABLE i-item-nro            AS INTEGER      NO-UNDO.
DEFINE VARIABLE c-pedido-espec-es0018  AS CHAR         NO-UNDO.
DEFINE VARIABLE c-dep-aux              AS CHAR         NO-UNDO.
DEFINE VARIABLE l-envia-cliente        AS LOG          NO-UNDO.
DEFINE VARIABLE c-pedido-espec-es0018-2 AS CHAR        NO-UNDO.
DEFINE VARIABLE l-pj                   AS LOG          NO-UNDO.
DEFINE VARIABLE i-seq-item             AS INT          NO-UNDO.

DEF VAR c-arquivo-xml AS CHAR NO-UNDO.

FIND FIRST param-global NO-LOCK NO-ERROR.
FIND FIRST mgcad.empresa NO-LOCK
     WHERE mgcad.empresa.ep-codigo = param-global.empresa-pri NO-ERROR.

DEF BUFFER b-estab  FOR estabelec.
DEF BUFFER b-fornec FOR emitente.
DEF BUFFER b-redespacho FOR transporte.
DEF BUFFER bloc-entr FOR loc-entr.

RUN pi-gerar-dados-extrato (">> INICIO WSO0003").

{include/i-freeac.i}
   
    
DEFINE INPUT  PARAM p-requisicao AS LONGCHAR NO-UNDO.
DEFINE OUTPUT PARAM p-retorno    AS LONGCHAR NO-UNDO.

DATASET mensagem:READ-XML('longchar', p-requisicao, 'empty', ?, ?).


FIND FIRST ttPedido NO-ERROR.
IF NOT AVAIL ttPedido THEN LEAVE.

IF OPSYS = "unix":U THEN
    ASSIGN c-arquivo-xml = "/mnt/spool/le052412/xml/WSO0003-" + STRING(ttPedido.numeroPedido) + TRIM(REPLACE(STRING(TODAY), "/", "")) + "-" + REPLACE(STRING(TIME,"HH:MM:SS"),":","") + ".xml".
ELSE
    ASSIGN c-arquivo-xml = "\\erpapp\spool\le052412\xml\WSO0003-" + STRING(ttPedido.numeroPedido) + TRIM(REPLACE(STRING(TODAY), "/", "")) + "-" + REPLACE(STRING(TIME,"HH:MM:SS"),":","") + ".xml".

RUN pi-inicio.
RUN pi-regras-especificas (INPUT "atualizaInicial").

FIND FIRST ttPedido NO-LOCK.

IF  CAN-FIND(FIRST ttErro) OR RETURN-VALUE = "NOK" THEN DO:
    ASSIGN l-envia-pedido = NO.
END.

IF l-envia-pedido THEN DO:
    
    /*Buscar n£mero pedido espec°fico para n∆o gerar a int-pedido-vtex e nao atualizar cliente */
    RUN pi-gerar-dados-extrato ("> ANTES pi-busca-pedido: ").
    RUN pi-busca-pedido(OUTPUT l-envia-cliente).
    RUN pi-gerar-dados-extrato ("> l-envia-cliente -> " + string(l-envia-cliente) + " - c-pedido-espec-es0018-2 -> " + STRING(c-pedido-espec-es0018-2)).
    
    RUN pi-inicio.
    
    RUN pi-regras-especificas (INPUT "aposInicio").
    
    RUN pi-gerar-dados-extrato ("> ANTES pi-emitente").
    IF l-envia-cliente THEN
        RUN pi-emitente.
    
    RUN pi-gerar-dados-extrato ("> ANTES pi-pedido").
    IF l-envia-pedido THEN DO:
        RUN pi-pedido.
    END.
    
    RUN pi-gerar-dados-extrato ("> ANTES pi-cria-resposta-xml").
    RUN pi-cria-resposta-xml.
    
    RUN pi-gerar-dados-extrato ("> ANTES pi-cria-historico").
    RUN pi-cria-historico.
    
    RUN pi-regras-especificas (INPUT "atualizaFinal").
    
    IF AVAIL emitente AND AVAIL ped-venda THEN DO:
        run esp/api/recalculo-pedido.p (input ped-venda.nr-pedido).
    END.

    RUN pi-elimina-historico.
    
    RUN pi-gerar-dados-extrato (">> FIM WSO0003").

END.

PROCEDURE pi-elimina-historico:

    FIND FIRST ttPedido NO-ERROR.

    FOR FIRST int-pedido-vtex NO-LOCK
        WHERE int-pedido-vtex.seq-pedido = ttPedido.sequenciaPedido
          AND int-pedido-vtex.nr-pedcli <> "":
        FOR EACH bint-pedido-vtex EXCLUSIVE-LOCK
           WHERE bint-pedido-vtex.seq-pedido = int-pedido-vtex.seq-pedido
             AND bint-pedido-vtex.nr-pedido  = bint-pedido-vtex.seq-pedido
             AND bint-pedido-vtex.nr-pedcli = "":
            FOR EACH int-ocorrencias-vtex EXCLUSIVE-LOCK
               WHERE int-ocorrencias-vtex.nr-pedido     = bint-pedido-vtex.nr-pedido    
                 AND int-ocorrencias-vtex.seq-pedido    = bint-pedido-vtex.seq-pedido   
                 AND int-ocorrencias-vtex.dt-integracao = bint-pedido-vtex.dt-integracao
                 AND int-ocorrencias-vtex.hr-integracao = bint-pedido-vtex.hr-integracao:
                DELETE int-ocorrencias-vtex.
            END.
            FOR EACH int-ped-item-vtex EXCLUSIVE-LOCK
               WHERE int-ped-item-vtex.nr-pedido     = bint-pedido-vtex.nr-pedido    
                 AND int-ped-item-vtex.seq-pedido    = bint-pedido-vtex.seq-pedido   
                 AND int-ped-item-vtex.dt-integracao = bint-pedido-vtex.dt-integracao
                 AND SUBSTRING(int-ped-item-vtex.hr-integracao,1,8) = bint-pedido-vtex.hr-integracao:
                DELETE int-ped-item-vtex.
            END.
            DELETE bint-pedido-vtex.
        END.
    END.

    FOR FIRST int-pedido-vtex NO-LOCK
        WHERE int-pedido-vtex.seq-pedido = ttPedido.sequenciaPedido
          AND int-pedido-vtex.nr-pedcli <> "":
        FOR EACH bint-pedido-vtex EXCLUSIVE-LOCK
           WHERE bint-pedido-vtex.nr-pedido = int-pedido-vtex.nr-pedido
             AND bint-pedido-vtex.nr-pedcli = "":
            FOR EACH int-ocorrencias-vtex EXCLUSIVE-LOCK
               WHERE int-ocorrencias-vtex.nr-pedido     = bint-pedido-vtex.nr-pedido    
                 AND int-ocorrencias-vtex.seq-pedido    = bint-pedido-vtex.seq-pedido   
                 AND int-ocorrencias-vtex.dt-integracao = bint-pedido-vtex.dt-integracao
                 AND int-ocorrencias-vtex.hr-integracao = bint-pedido-vtex.hr-integracao:
                DELETE int-ocorrencias-vtex.
            END.
            FOR EACH int-ped-item-vtex EXCLUSIVE-LOCK
               WHERE int-ped-item-vtex.nr-pedido     = bint-pedido-vtex.nr-pedido    
                 AND int-ped-item-vtex.seq-pedido    = bint-pedido-vtex.seq-pedido   
                 AND int-ped-item-vtex.dt-integracao = bint-pedido-vtex.dt-integracao
                 AND SUBSTRING(int-ped-item-vtex.hr-integracao,1,8) = bint-pedido-vtex.hr-integracao:
                DELETE int-ped-item-vtex.
            END.
            DELETE bint-pedido-vtex.
        END.
    END.
    RETURN "OK":U.  

END PROCEDURE.

PROCEDURE pi-inicio:

    /** Limpa temp-tables de integraá∆o **/
    EMPTY TEMP-TABLE tt-emitente.
    EMPTY TEMP-TABLE tt-loc-entr.
    EMPTY TEMP-TABLE tt-loc-entr-aux.
    EMPTY TEMP-TABLE tt-int-loc-entr.
    EMPTY TEMP-TABLE tt-erros-geral.
    EMPTY TEMP-TABLE tt-dist-emitente.

    FIND FIRST ttPedido NO-ERROR.
    IF NOT AVAIL ttPedido THEN LEAVE.
    FIND FIRST ttItem NO-ERROR.
    IF NOT AVAIL ttItem THEN LEAVE.

    IF TRIM(ttPedido.marketplace) = "" THEN
        ASSIGN ttPedido.marketplace = "VTEX".
    
END PROCEDURE.
    
PROCEDURE pi-emitente:
    
    BLOCO-EMITENTE:
    DO TRANSACTION ON ERROR UNDO BLOCO-EMITENTE, LEAVE BLOCO-EMITENTE:

        RUN pi-gerar-dados-extrato ("> ANTES pi-cria-tt-emitente").
        RUN pi-cria-tt-emitente (OUTPUT p-i-ind-tipo-movto).

        RUN pi-regras-especificas (INPUT "aposCriaTTEmitente").

        RUN pi-gerar-dados-extrato ("> ANTES pi-atualiza-pessoa").
        RUN pi-atualiza-pessoa (INPUT p-i-ind-tipo-movto).

        RUN pi-regras-especificas (INPUT "aposAtualizaPessoa").

        RUN pi-gerar-dados-extrato ("> DEPOIS pi-atualiza-pessoa: ").
        RUN pi-gerar-dados-extrato ("> CAN-FIND(FIRST ttErro): " + STRING(CAN-FIND(FIRST ttErro))).
        RUN pi-gerar-dados-extrato ("> RETURN-VALUE: " + RETURN-VALUE).

        IF  CAN-FIND(FIRST ttErro) OR RETURN-VALUE = "NOK" THEN DO:
            ASSIGN l-envia-pedido = NO.
            UNDO BLOCO-EMITENTE, LEAVE BLOCO-EMITENTE.
        END.

    END.

END PROCEDURE.

PROCEDURE pi-regras-especificas:

    DEFINE INPUT PARAM c-evento AS CHAR     NO-UNDO.

    FIND FIRST tt-ped-venda NO-ERROR.
    RUN pi-gerar-dados-extrato ("> ANTES pi-regras-especificas: " + c-evento + " tt-ped-venda: " + STRING(AVAIL tt-ped-venda)).

    IF NOT VALID-HANDLE(h-wso0003-espec) THEN DO:

        FIND FIRST ttPedido NO-ERROR.
        IF NOT AVAIL ttPedido THEN LEAVE.

        FIND FIRST int-pedido-param NO-LOCK
             WHERE int-pedido-param.marketplace = TRIM(ttPedido.marketplace)
               AND int-pedido-param.loja        = ttPedido.codigoLoja NO-ERROR.
        IF AVAIL int-pedido-param THEN 
            RUN VALUE(int-pedido-param.nom-prog-upc) PERSISTENT SET h-wso0003-espec.

    END.

    IF VALID-HANDLE(h-wso0003-espec) THEN
        RUN pi-evento IN h-wso0003-espec (INPUT c-evento,
                                          INPUT-OUTPUT TABLE ttPessoaFisica,
                                          INPUT-OUTPUT TABLE ttPessoaJuridica,
                                          INPUT-OUTPUT TABLE ttTelefone,
                                          INPUT-OUTPUT TABLE ttEmail,
                                          INPUT-OUTPUT TABLE ttEndereco,
                                          INPUT-OUTPUT TABLE ttDocumento,
                                          INPUT-OUTPUT TABLE ttPedido,
                                          INPUT-OUTPUT TABLE ttCondicaoPagamento,
                                          INPUT-OUTPUT TABLE ttItem,
                                          INPUT-OUTPUT TABLE tt-emitente,
                                          INPUT-OUTPUT TABLE tt-ped-venda,
                                          INPUT-OUTPUT TABLE tt-ped-item,
                                          INPUT-OUTPUT TABLE ttErro).

    RUN pi-gerar-dados-extrato ("> DEPOIS pi-regras-especificas: " + c-evento).

    IF  VALID-HANDLE(h-wso0003-espec) THEN DO:
        DELETE PROCEDURE h-wso0003-espec.
        ASSIGN h-wso0003-espec = ?.
    END.
END.

PROCEDURE pi-pedido:
    
    BLOCO-PEDIDO:
    DO TRANSACTION ON ERROR UNDO BLOCO-PEDIDO, LEAVE BLOCO-PEDIDO:

        IF NOT VALID-HANDLE(h-boes505) THEN
            run esbo/boes505.p persistent set h-boes505.

        /*------------------------------------*/
        /*   CADASTRAMENTO DO PEDIDO NO ERP   */
        /*------------------------------------*/
        RUN pi-gerar-dados-extrato ("> l-envia-pedido: " + STRING(l-envia-pedido)).
        IF  l-envia-pedido THEN
            RUN pi-atualiza-pedido.
    
        RUN pi-gerar-dados-extrato ("> DEPOIS: ").
    
        IF  VALID-HANDLE(h-boes505) THEN DO:
            RUN DESTROY IN h-boes505 NO-ERROR.
            IF  VALID-HANDLE(h-boes505) THEN
                DELETE procedure h-boes505.
        END.
        ASSIGN h-boes505 = ?.
    
        RUN pi-gerar-dados-extrato ("> DEPOIS pi-atualiza-pedido CAN-FIND(FIRST ttErro): " + STRING(CAN-FIND(FIRST ttErro))).
        RUN pi-gerar-dados-extrato ("> DEPOIS pi-atualiza-pedido RETURN-VALUE: " + STRING(RETURN-VALUE)).
        IF  CAN-FIND(FIRST ttErro) OR RETURN-VALUE = "NOK" THEN DO:
            ASSIGN l-envia-pedido = NO.
            UNDO BLOCO-PEDIDO, LEAVE BLOCO-PEDIDO.
        END.
    END.

END PROCEDURE.

/* TRATAMENTO PARA RETORNOAR SUCESSO OU ERROS */
PROCEDURE pi-cria-resposta-xml:
    FIND FIRST ttPedido NO-ERROR.

    IF ttPedido.marketplace = ""
    OR ttPedido.marketplace = "VTEX"
    OR ttPedido.marketplace = "BWW"
    OR ttPedido.marketplace = "FSH"
    OR ttPedido.marketplace = "VVT"
    OR ttPedido.marketplace = "CLR"
    OR ttPedido.marketplace = "SMP"
    OR ttPedido.marketplace = "WBC"
    OR ttPedido.marketplace = "MLP"
    THEN DO:
        CREATE ttResultado.
        ASSIGN ttResultado.sucesso = YES.
        DATASET mensagemr:WRITE-XML('LONGCHAR', p-retorno, NO).
    END.
    ELSE DO:
        CREATE ttResultado.
        ASSIGN ttResultado.sucesso = NOT CAN-FIND(FIRST ttErro).
        DATASET mensagemr:WRITE-XML('LONGCHAR', p-retorno, NO).
    END.
     
END.

PROCEDURE pi-atualiza-pedido:

    DEFINE VARIABLE i-loja                 AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-cod-atendente        AS INTEGER     NO-UNDO.
    
    FOR FIRST ttPedido:
        ASSIGN i-loja = int(ttPedido.codigoLoja).
    END.

    FIND FIRST int-pedido-param NO-LOCK
         WHERE int-pedido-param.marketplace = TRIM(ttPedido.marketplace)
           AND int-pedido-param.loja        = ttPedido.codigoLoja NO-ERROR.
    IF AVAIL int-pedido-param THEN DO:
        ASSIGN i-cod-atendente = int-pedido-param.cd-oper.
        IF  i-cod-atendente = 0 OR i-cod-atendente = ? THEN
            ASSIGN i-cod-atendente = 22. /*e-commerce*/
    END.
    
    find first param-global no-lock no-error.
    find mgcad.empresa no-lock
       where mgcad.empresa.ep-codigo = param-global.empresa-pri no-error.
    find FIRST para-fat no-lock no-error.
    find para-ped no-lock no-error.

    RUN pi-gerar-dados-extrato ("inicio pi-atualiza-pedido").
    
    FIND FIRST ttPedido NO-ERROR.
    
    IF  NOT AVAIL ttPedido  THEN DO:
        RUN incluiMsgErro IN THIS-PROCEDURE ("Pedido", 1000, 'Pedido n∆o informado no xml').
        RETURN "NOK".
    END.

    FIND FIRST ttItem no-error.

    IF NOT AVAIL ttItem THEN DO:
       RUN incluiMsgErro IN THIS-PROCEDURE ("Pedido", 1010, 'Pedido n∆o possui itens; pedido ignorado.').
       RETURN "NOK".
    END.
    
    IF NOT CAN-FIND(FIRST ped-curva NO-LOCK USE-INDEX ch-lucro-it
                    WHERE ped-curva.vl-lucro-br = 0
                      AND ped-curva.it-codigo   = ttPedido.numeroPedido) THEN DO:
        CREATE ped-curva.
        ASSIGN ped-curva.vl-lucro-br = 0
               ped-curva.it-codigo   = ttPedido.numeroPedido.
        RELEASE ped-curva.
    END.
    ELSE DO:
        IF ttPedido.marketplace = ""
        OR ttPedido.marketplace = "VTEX"
        OR ttPedido.marketplace = "BWW" 
        OR ttPedido.marketplace = "FSH"
        OR ttPedido.marketplace = "VVT"
        OR ttPedido.marketplace = "CLR"
        OR ttPedido.marketplace = "SMP"
        OR ttPedido.marketplace = "WBC"
        OR ttPedido.marketplace = "MLP"
        THEN
            RUN incluiMsgErro IN THIS-PROCEDURE ("Pedido", 1010, 'Pedido j† cadastrado; pedido ignorado.').
        ELSE
            RUN incluiMsgErro IN THIS-PROCEDURE ("Pedido", 1010, 'Pedido ' + STRING(ttPedido.numeroPedido) + ' j† cadastrado; Pedido no ERP:' + STRING(int-ped-venda2.nr-pedido)).
        
        RETURN "NOK".
    END.

    FIND FIRST int-ped-venda2 NO-LOCK
         WHERE int-ped-venda2.PedidoeCommerce = ttPedido.numeroPedido NO-ERROR.

    IF AVAIL int-ped-venda2 THEN DO:
        IF ttPedido.marketplace = ""
        OR ttPedido.marketplace = "VTEX"
        OR ttPedido.marketplace = "BWW" 
        OR ttPedido.marketplace = "FSH"
        OR ttPedido.marketplace = "VVT"
        OR ttPedido.marketplace = "CLR"
        OR ttPedido.marketplace = "SMP"
        OR ttPedido.marketplace = "WBC"
        OR ttPedido.marketplace = "MLP"
        THEN
            RUN incluiMsgErro IN THIS-PROCEDURE ("Pedido", 1010, 'Pedido j† cadastrado; pedido ignorado.').
        ELSE
            RUN incluiMsgErro IN THIS-PROCEDURE ("Pedido", 1010, 'Pedido ' + STRING(ttPedido.numeroPedido) + ' j† cadastrado; Pedido no ERP:' + STRING(int-ped-venda2.nr-pedido)).
        
        RETURN "NOK".
    END.
    
    /*Buscar n£mero pedido espec°fico para n∆o gerar a int-pedido-vtex*/
    EMPTY TEMP-TABLE tt-prog-ponto.
    RUN esp/es0018p.p (INPUT "wsO0003":U, INPUT 4, INPUT 0, INPUT "":U, OUTPUT TABLE tt-prog-ponto).
    FIND FIRST tt-prog-ponto NO-ERROR.
    IF  AVAIL tt-prog-ponto THEN 
        ASSIGN c-pedido-espec-es0018 = tt-prog-ponto.conteudo.

    IF c-pedido-espec-es0018 = ttPedido.numeroPedido THEN DO:
       RUN incluiMsgErro IN THIS-PROCEDURE ("Pedido", 1010, 'Pedido para nao dar timeout, Pedido ignorado.').
       RETURN "NOK".
    END.

    OUTPUT TO VALUE(c-arquivo-xml).
    PUT STRING(p-requisicao) FORMAT "X(20000)".
    OUTPUT CLOSE.

    RUN pi-gerar-dados-extrato ("> ini c-pedido-espec-es0018: " + string(c-pedido-espec-es0018)).

    EMPTY TEMP-TABLE tt-prog-ponto.
    RUN esp/es0018p.p (INPUT "wsO0003":U, INPUT 2, INPUT 0, INPUT "":U, OUTPUT TABLE tt-prog-ponto).
    FIND FIRST tt-prog-ponto NO-ERROR.
    IF  AVAIL tt-prog-ponto THEN DO:
        FOR EACH tt-prog-ponto:
            CREATE tt-usuarios-reserva.
            ASSIGN tt-usuarios-reserva.usuario = tt-prog-ponto.conteudo.
        END.
    END.


    /* Usuarios para desconsiderar nas reservas */
    EMPTY TEMP-TABLE tt-prog-ponto.
    RUN esp/es0018p.p (INPUT "wsO0003":U, INPUT 2, INPUT 0, INPUT "":U, OUTPUT TABLE tt-prog-ponto).
    FIND FIRST tt-prog-ponto NO-ERROR.
    IF  AVAIL tt-prog-ponto THEN DO:
        FOR EACH tt-prog-ponto:
            CREATE tt-usuarios-reserva.
            ASSIGN tt-usuarios-reserva.usuario = tt-prog-ponto.conteudo.
        END.
    END.

    ASSIGN c-transpordara-xml = ttItem.codigoTransportadora
           c-estabelec-xml    = ttItem.estabelecimento.

    RUN pi-gerar-dados-extrato ("> inicio c-transpordara-xml: " + string(c-transpordara-xml)).
    
    /** Limpa temp-tables para as BO's **/
    EMPTY TEMP-TABLE tt-ped-venda.
    EMPTY TEMP-TABLE tt-ped-item.
    EMPTY TEMP-TABLE tt-ped-ent.
    EMPTY TEMP-TABLE tt-ped-repre.
    EMPTY TEMP-TABLE tt-ped-antecip.
    EMPTY TEMP-TABLE tt-cond-ped.
    EMPTY TEMP-TABLE tt-ped-vendor.

    /*-------------------------------*/
    /*  BUSCAR ESTABELECIMENTO VTEX  */
    /*-------------------------------*/
    FOR FIRST estabelec NO-LOCK
        WHERE estabelec.cod-estabel = c-estabelec-xml: END.

    RUN pi-gerar-dados-extrato ("> c-estabelec-xml: " + string(c-estabelec-xml)).
    RUN pi-gerar-dados-extrato ("> i-cod-atendente: " + string(i-cod-atendente)).
    
    /*-----------------------------*/
    /*  BUSCAR REPRESENTANTE VTEX  */
    /*-----------------------------*/
    FIND FIRST repres-atend
        WHERE  repres-atend.cod-estab = c-estabelec-xml
           AND repres-atend.cd-oper   = i-cod-atendente NO-LOCK NO-ERROR.

    IF  AVAIL repres-atend THEN DO:
        FIND FIRST repres NO-LOCK                                        
           WHERE repres.cod-rep =  repres-atend.cod-rep NO-ERROR. 

        IF  NOT AVAIL repres THEN DO:
            RUN incluiMsgErro IN THIS-PROCEDURE ("Pedido", 1019, 'Representante ' + STRING(repres-atend.cod-rep) + " n∆o cadastrado no ERP.").
            RETURN "NOK".
        END.
    END.
    ELSE DO:
        RUN incluiMsgErro IN THIS-PROCEDURE ("Pedido", 1020, 'Relacionamento representante n∆o cadastrado no programa espdp011 para atendente ' +
                                              string(i-cod-atendente) + "e estabelecimento " + c-estabelec-xml ).
        RETURN "NOK".
    END.

    /*------------------------------------*/
    /*  BUSCAR REPRESENTANTE MARTKEPLACE  */
    /*------------------------------------*/

    EMPTY TEMP-TABLE tt-prog-ponto.
    RUN esp/es0018p.p (INPUT "wso0003":U, INPUT 12, INPUT 0, INPUT "":U, OUTPUT TABLE tt-prog-ponto).
    FIND FIRST tt-prog-ponto
         WHERE ENTRY(1,tt-prog-ponto.conteudo,";") = TRIM(ttPedido.marketplace) NO-ERROR.
    IF AVAIL tt-prog-ponto THEN DO:

        FIND FIRST repres NO-LOCK                                        
             WHERE repres.cod-rep = INT(ENTRY(2,tt-prog-ponto.conteudo,";")) NO-ERROR. 
    
        IF NOT AVAIL repres THEN DO:
            RUN incluiMsgErro IN THIS-PROCEDURE ("Pedido", 1019, 'Representante ' + STRING(repres-atend.cod-rep) + " n∆o cadastrado no ERP.").
            RETURN "NOK".
        END.
    END.

    /*--------------------------------------*/
    /*  VERIFICA TRASPORTADORA MARKETPLACE  */
    /*--------------------------------------*/
    FIND FIRST ttPedido NO-ERROR.
    IF ttPedido.marketplace <> "VTEX" AND c-transpordara-xml = "" THEN DO:

        FIND FIRST int-pedido-param NO-LOCK
             WHERE int-pedido-param.marketplace = TRIM(ttPedido.marketplace)
               AND int-pedido-param.loja        = ttPedido.codigoLoja NO-ERROR.
        IF AVAIL int-pedido-param THEN 
            ASSIGN c-transpordara-xml = STRING(int-pedido-param.cod-transp).

    END.

    /*-------------------------------*/
    /*  VERIFICA TRASPORTADORA VTEX  */
    /*-------------------------------*/
    FIND transporte NO-LOCK 
         WHERE transporte.cod-trans = int(c-transpordara-xml) NO-ERROR.
    IF  NOT AVAIL transporte THEN DO:
        RUN incluiMsgErro IN THIS-PROCEDURE ("Pedido", 1030, 'Transportadora: ' + c-transpordara-xml + ' n∆o existente no TOTVs.').
        RETURN "NOK".                                                                                                                  
    END.

    /* REDESPACHO - es0018 */
    EMPTY TEMP-TABLE tt-prog-ponto-aux.
    RUN esp/es0018p.p (INPUT "wsO0003":U, INPUT 3, INPUT 0, INPUT "":U, OUTPUT TABLE tt-prog-ponto-aux).
    FIND FIRST tt-prog-ponto-aux NO-ERROR.
    RUN pi-gerar-dados-extrato ("tt-prog-ponto-aux: " + string(AVAIL tt-prog-ponto-aux)).

    RUN pi-gerar-dados-extrato ("> JONK1 ").


    IF  AVAIL tt-prog-ponto-aux THEN DO:
        FOR EACH tt-prog-ponto-aux:
              
            IF  NUM-ENTRIES(tt-prog-ponto-aux.conteudo, ";") > 0 THEN
                IF  ENTRY(1,tt-prog-ponto-aux.conteudo, ";") = c-transpordara-xml THEN DO:
                    ASSIGN c-transpordara-xml = ENTRY(2,tt-prog-ponto-aux.conteudo, ";").
                           c-cod-redespacho   = ENTRY(3,tt-prog-ponto-aux.conteudo, ";").
                           c-estab-entrega    = ENTRY(4,tt-prog-ponto-aux.conteudo, ";").  

                     RUN pi-gerar-dados-extrato ("> c-transpordara-xml: " + string(c-transpordara-xml)).
                     RUN pi-gerar-dados-extrato ("> c-cod-redespacho: " + string(c-cod-redespacho)).
                     RUN pi-gerar-dados-extrato ("> c-estab-entrega: " + string(c-estab-entrega)).

                END.
            ELSE
                NEXT.
        END.
    END.

    RUN pi-gerar-dados-extrato ("> JONK2 ").

    FIND transporte NO-LOCK 
         WHERE transporte.cod-trans = int(c-transpordara-xml) NO-ERROR.
    IF  NOT AVAIL transporte THEN DO:
        RUN incluiMsgErro IN THIS-PROCEDURE ("Pedido", 1030, 'Transportadora informada no es0018 - wso0003 ponto 3: ' + c-transpordara-xml + ' n∆o existente no TOTVs.').
        RETURN "NOK".                                                                                                                  
    END.

    /*------------*/
    /*  Respacho  */
    /*------------*/
    IF c-cod-redespacho <> "" THEN
        FIND FIRST b-redespacho NO-LOCK
            WHERE b-redespacho.cod-transp = int(c-cod-redespacho) NO-ERROR.

    /*  VERIFICA CONDIÄ«O DE PAGAMENTO VTEX  */
    FIND FIRST ttPedido NO-ERROR.
    IF int(ttPedido.condicaoPagamento) <> 0 THEN DO:
        FIND cond-pagto NO-LOCK
            WHERE cond-pagto.cod-cond-pag = int(ttPedido.condicaoPagamento) NO-ERROR.
        IF  NOT AVAIL cond-pagto  THEN DO:
            RUN incluiMsgErro IN THIS-PROCEDURE ("Pedido", 1040, 'Condiá∆o de pagamento: ' + ttPedido.condicaoPagamento + ' n∆o existente no TOTVs.').
            RETURN "NOK".                                                                                                                
        END.
    END.

    RUN pi-gerar-dados-extrato ("> JONK3 " + STRING(i-cod-emitente)).
    RUN pi-gerar-dados-extrato ("> JONK4 " + STRING(AVAIL EMITENTE)).
    
    /*  INICIO CRIAÄ«O DO PEDIDO */
    ASSIGN i-cod-sit-aval = 1. /*N∆o Avaliado*/ 

    CREATE tt-ped-venda.
    ASSIGN tt-ped-venda.nr-pedido  = NEXT-VALUE(seq-nr-pedido)
           tt-ped-venda.nome-abrev = emitente.nome-abrev
           tt-ped-venda.nr-pedcli  = string(tt-ped-venda.nr-pedido).

    RUN pi-gerar-dados-extrato ("> JONK5 ").

    ASSIGN tt-ped-venda.cod-estabel             = estabelec.cod-estabel
           tt-ped-venda.dt-emissao              = ttPedido.dataCriacao
           tt-ped-venda.dt-entrega              = today
           tt-ped-venda.dt-entorig              = today
           tt-ped-venda.no-ab-reppri            = repres.nome-abrev
           tt-ped-venda.dt-implant              = today
           tt-ped-venda.nome-transp             = transporte.nome-abrev
           tt-ped-venda.nome-tr-red             = IF AVAIL b-redespacho THEN b-redespacho.nome-abrev ELSE ""
           tt-ped-venda.cod-emitente            = emitente.cod-emitente
           tt-ped-venda.cod-cond-pag            = IF AVAIL cond-pagto THEN cond-pagto.cod-cond-pag ELSE 0
           tt-ped-venda.nr-tab-fin              = 1
           tt-ped-venda.nr-ind-finan            = 1

           tt-ped-venda.e-mail                  = emitente.e-mail
           tt-ped-venda.cod-sit-aval            = i-cod-sit-aval
           tt-ped-venda.mo-codigo               = 0 /* S¢ haver† pedidos do Brasil */
           tt-ped-venda.cod-gr-cli              = emitente.cod-gr-cli
           tt-ped-venda.tp-faturam              = 1
           tt-ped-venda.origem                  = 12 /** 12-WEB **/
           tt-ped-venda.atendido                = no
           tt-ped-venda.cd-origem               = 1 /** 1-Usuario, 2-EDI, 3-Sistema **/
           tt-ped-venda.user-impl               = 'adm'
           tt-ped-venda.dt-userimp              = today
           tt-ped-venda.tip-cob-desp            = para-fat.tip-cob-desp
           tt-ped-venda.observacoes             = "" /*ttPedido.Observacao*/
           tt-ped-venda.cond-espec              = "" /*(IF ttPedido.Referencia <> '' THEN 'Referencia Endereáo: ' + ttPedido.Referencia ELSE '') + ' Pedido B2C. ' + (if (l-saldao) then
               ' Produtos da loja saldao ,sao remanufaturados e estao sujeitos a pequenas avarias, riscos e danos externos. Esse produto nao possui garantia contratual.'
                                                                    else '') */
           tt-ped-venda.esp-ped                 = 1
           tt-ped-venda.cod-priori              = 01
           tt-ped-venda.cod-rota                = ''
           tt-ped-venda.ind-ent-completa        = yes
           tt-ped-venda.dsp-pre-fat             = yes
           tt-ped-venda.log-usa-tabela-desconto = no
           tt-ped-venda.ind-lib-nota            = para-ped.ind-lib-nota when available para-ped
           tt-ped-venda.ind-fat-par             = no
           tt-ped-venda.cod-portador            = 999
           tt-ped-venda.modalidade              = 6
           /*tt-ped-venda.des-pct-desconto-inform = STRING((ttPedido.totalDesconto / ttPedido.totalPedido) * 100)*/.
    
    IF tt-ped-venda.nome-transp BEGINS "Retira" THEN
       ASSIGN OVERLAY(tt-ped-venda.char-2,109,8) = "9".
    ELSE
       ASSIGN OVERLAY(tt-ped-venda.char-2,109,8)   = "0".
       
    /* Parcelamento do Pedido */
    RUN pi-gera-parcelamento.

    /*--------------------------------------------------------------------------------------------------------*/
    /*                                          DEFINIÄ«O DO ATENDENTE                                        */
    /*--------------------------------------------------------------------------------------------------------*/
    ASSIGN tt-ped-venda.tp-pedido = "".

    FIND FIRST int-pedido-param NO-LOCK
         WHERE int-pedido-param.marketplace = TRIM(ttPedido.marketplace)
           AND int-pedido-param.loja        = ttPedido.codigoLoja NO-ERROR.
    IF AVAIL int-pedido-param THEN 
        ASSIGN tt-ped-venda.tp-pedido = STRING(int-pedido-param.cd-oper).

    IF tt-ped-venda.tp-pedido = "" THEN DO:
        ASSIGN tt-ped-venda.tp-pedido = "22". /** Atendente **/
        IF tt-ped-venda.cod-estabel = "105" THEN
            ASSIGN tt-ped-venda.nome-transp           = "IBL LOGIST02"
                   OVERLAY(tt-ped-venda.char-2,109,8) = "0".
    END.

     IF ttPedido.totalFrete > 0 THEN
        ASSIGN OVERLAY(tt-ped-venda.char-2,109,8)   = "0".

    /*--------------------------------------------------------------------------------------*/
    /*                                DEFINIÄ«O DO ENDENREÄO                                */
    /*--------------------------------------------------------------------------------------*/
    FIND FIRST ttEndereco.

    FOR FIRST loc-entr EXCLUSIVE-LOCK
        WHERE loc-entr.nome-abrev = emitente.nome-abrev
          AND loc-entr.cod-entrega = "VTEX":
        ASSIGN loc-entr.cod-entrega = STRING(tt-ped-venda.nr-pedido).
    END.

    /*VERIFICAR SE NO ES0018, FOI CADASTRADO REDESPACHO, PARA ENTREGA NO ENDEREÄO DO ESTABELECIMENTO PARAMETRIZADO*/
    IF  c-estab-entrega <> "" THEN DO:
        FIND FIRST b-estab NO-LOCK
            WHERE b-estab.cod-estabel = c-estab-entrega NO-ERROR.

        RUN pi-gerar-dados-extrato ("> avail b-estab: " + string(AVAIL b-estab)).
        IF  NOT AVAIL b-estab THEN DO:
            RUN incluiMsgErro IN THIS-PROCEDURE ("Pedido", 1050, 'Local de entrega n∆o informado para o estabelecimento de entrega parametrizado no es0018').
            RETURN "NOK".                                                                                                                
        END.

        FIND FIRST b-fornec
            WHERE b-fornec.cod-emitente = b-estab.cod-emitente NO-LOCK NO-ERROR.

        RUN pi-gerar-dados-extrato ("> avail b-fornec: " + string(AVAIL b-fornec)).

        FIND loc-entr NO-LOCK
            WHERE loc-entr.nome-abrev  = b-fornec.nome-abrev
              AND loc-entr.cod-entrega = "Padr∆o" NO-ERROR.
    
        RUN pi-gerar-dados-extrato ("> avail loc-entr: " + string(AVAIL loc-entr)).
        IF  NOT AVAIL loc-entr THEN DO:
            RUN incluiMsgErro IN THIS-PROCEDURE ("Pedido", 1050, 'Local de entrega n∆o informado para fornecedor do estabelecimento parametrizado no es0018').
            RETURN "NOK".                                                                                                                
        END.
    END.
    ELSE DO:
        FIND FIRST loc-entr NO-LOCK
             WHERE loc-entr.nome-abrev = emitente.nome-abrev
               AND loc-entr.cod-entrega = STRING(tt-ped-venda.nr-pedido) NO-ERROR.

         RUN pi-gerar-dados-extrato (">Padr∆o - avail loc-entr: " + string(AVAIL loc-entr)).

        IF  NOT AVAIL loc-entr THEN DO:
            RUN incluiMsgErro IN THIS-PROCEDURE ("Pedido", 1050, 'Local de entrega n∆o informado').
            RETURN "NOK".                                                                                                                
        END.
    END.

    ASSIGN tt-ped-venda.local-entreg = loc-entr.endereco
           tt-ped-venda.bairro       = loc-entr.bairro
           tt-ped-venda.cidade       = loc-entr.cidade
           tt-ped-venda.pais         = loc-entr.pais
           tt-ped-venda.estado       = loc-entr.estado
           tt-ped-venda.cep          = loc-entr.cep
           tt-ped-venda.caixa-postal = loc-entr.caixa-postal
           tt-ped-venda.cgc          = loc-entr.cgc
           tt-ped-venda.ins-estadual = loc-entr.ins-estadual
           tt-ped-venda.cod-entrega  = STRING(tt-ped-venda.nr-pedido)
           tt-ped-venda.cidade-cif   = loc-entr.cidade. 


    RUN pi-gerar-dados-extrato (">tt-ped-venda.local-entreg: " + string(tt-ped-venda.local-entreg)).
    RUN pi-gerar-dados-extrato (">tt-ped-venda.bairro......: " + string(tt-ped-venda.bairro)).
    RUN pi-gerar-dados-extrato (">tt-ped-venda.cidade......: " + string(tt-ped-venda.cidade)).
    RUN pi-gerar-dados-extrato (">tt-ped-venda.estado......: " + string(tt-ped-venda.estado)).
    RUN pi-gerar-dados-extrato (">tt-ped-venda.cod-entrega.: " + string(tt-ped-venda.cod-entrega)).
    RUN pi-gerar-dados-extrato (">tt-ped-venda.cidade-cif..: " + string(tt-ped-venda.cidade-cif)).

    /*-----------------------------------------------------------------------*/
    /*                      DEFINIÄ«O NATUREZA DE OPERAÄ«O                   */
    /*-----------------------------------------------------------------------*/
    RUN DefineNatOperacao IN h-boes505 (INPUT c-estabelec-xml,
                                        INPUT emitente.cod-emitente,
                                        INPUT loc-entr.cod-entrega,
                                        INPUT '',
                                        INPUT YES,
                                        OUTPUT c-natureza,
                                        OUTPUT l-return).

    IF c-natureza = "" THEN
        ASSIGN c-natureza = emitente.nat-operacao.

    /*IF NOT (l-return) THEN DO:
       RUN incluiMsgErro IN THIS-PROCEDURE ("Pedido", 1060,'Natureza de operaá∆o n∆o cadastrada para o cliente: ' + string(emitente.cod-emitente)).
       RETURN "NOK".
    END.*/

    FIND natur-oper NO-LOCK 
       where natur-oper.nat-operacao = c-natureza NO-ERROR .
    IF NOT AVAILABLE (natur-oper) THEN DO:
        RUN incluiMsgErro IN THIS-PROCEDURE ("Pedido", 1070,'Natureza de operaá∆o ' + c-natureza + ' n∆o encontrada; pedido do cliente ' + string(emitente.cod-emitente)).
        RETURN "NOK".
    END.

    ASSIGN c-nat-oper                   = natur-oper.nat-operacao
           c-nat-oper-cabecalho         = natur-oper.nat-operacao
           l-mantem-nat                 = no
           tt-ped-venda.nat-operacao    = natur-oper.nat-operacao
           tt-ped-venda.cod-mensagem    = natur-oper.cod-mensagem
           tt-ped-venda.cod-canal-venda = (if (natur-oper.cod-canal-venda <> 0) then natur-oper.cod-canal-venda else emitente.cod-canal-venda)
           tt-ped-venda.cod-des-merc    = (if (natur-oper.consum-final) then 2 else 1).

    /*-------------------------------------------------------*/
    /*                    CRIAÄ«O PED-REPRE                  */
    /*-------------------------------------------------------*/
    CREATE tt-ped-repre.
    ASSIGN tt-ped-repre.nr-pedido   = tt-ped-venda.nr-pedido
           tt-ped-repre.ind-repbase = yes
           tt-ped-repre.perc-comis  = 0
           tt-ped-repre.nome-ab-rep = repres.nome-abrev.

    /********************************/
    /* F I M   CRIAÄ«O TT-PED-VENDA */
    /********************************/

    /*--------------------------------------------------------------------------------------------------------------------------------------------------*/
    /*                                                  C R I A Ä « O   T T - P E D - I T E M                                                           */
    /*--------------------------------------------------------------------------------------------------------------------------------------------------*/
    ASSIGN i-item-nro = 0.
    FOR EACH ttItem:

        ASSIGN i-item-nro = i-item-nro + 1.

        FIND ITEM no-lock
           WHERE item.it-codigo = ttItem.codigoItem NO-ERROR.
        IF  NOT AVAIL ITEM THEN DO:
            RUN incluiMsgErro IN THIS-PROCEDURE ("ItemPedido", 1080, 'Item n∆o encontrado ' + string(ttItem.codigoItem)).
            RETURN "NOK".
        END.

        /** Natureza de operaá∆o do item **/
        RUN defineNatOperacao IN h-boes505 (INPUT c-estabelec-xml,
                                            INPUT emitente.cod-emitente,
                                            INPUT loc-entr.cod-entrega,
                                            INPUT item.it-codigo,
                                            INPUT YES, /*Consumidor final*/
                                            OUTPUT c-nat-oper,
                                            OUTPUT l-return).

        IF c-nat-oper = "" THEN
            ASSIGN c-nat-oper = emitente.nat-operacao.

        /*IF  NOT (l-return) THEN DO:
           RUN incluiMsgErro IN THIS-PROCEDURE ("ItemPedido", 1090, 'Natureza de operaá∆o ' + c-nat-oper +  ' n∆o encontrada para cliente ' + string(emitente.cod-emitente) + " e Item " + item.it-codigo ).
           RETURN "NOK".
        END.*/
        
        FIND natur-oper NO-LOCK
           WHERE natur-oper.nat-operacao = c-nat-oper NO-ERROR.
        
        IF (c-nat-oper-cabecalho = c-nat-oper) THEN 
           ASSIGN i-cont-nat-igual = i-cont-nat-igual + 1.

        IF  NOT AVAILABLE (natur-oper) THEN DO:
           RUN incluiMsgErro IN THIS-PROCEDURE ("ItemPedido", 1200, 'Natureza de operaá∆o ' + c-nat-oper + ' inv†lida ou n∆o cadastrada no cliente ' + string(emitente.cod-emitente) + " e Item " + item.it-codigo).
           RETURN "NOK".
        END.

        CREATE tt-ped-item.
        ASSIGN tt-ped-item.aliquota-ipi            = item.aliquota-ipi
               tt-ped-item.nr-pedcli               = tt-ped-venda.nr-pedcli
               tt-ped-item.cod-entrega             = tt-ped-venda.cod-entrega
               tt-ped-item.dt-entrega              = tt-ped-venda.dt-entrega
               OVERLAY(tt-ped-item.char-2,1,8)     = item.class-fiscal
               tt-ped-item.qt-pedida               = ttItem.quantidade
               tt-ped-item.qt-un-fat               = tt-ped-item.qt-pedida
               tt-ped-item.cod-sit-item            = tt-ped-venda.cod-sit-ped
               tt-ped-item.cod-sit-pre             = tt-ped-venda.cod-sit-pre
               tt-ped-item.dt-entorig              = tt-ped-venda.dt-entorig
               tt-ped-item.dt-userimp              = tt-ped-venda.dt-userimp
               tt-ped-item.esp-ped                 = 1
               tt-ped-item.it-codigo               = item.it-codigo
               tt-ped-item.nat-operacao            = natur-oper.nat-operacao
               tt-ped-item.nome-abrev              = tt-ped-venda.nome-abrev
               tt-ped-item.per-des-icms            = natur-oper.per-des-icms
               tt-ped-item.tp-adm-lote             = 1
               tt-ped-item.tp-preco                = 0
               tt-ped-item.user-impl               = tt-ped-venda.user-impl
               tt-ped-item.log-usa-tabela-desconto = no
               tt-ped-item.observacao              = ""
               tt-ped-item.per-minfat              = (IF AVAILABLE (emitente) THEN emitente.per-minfat else tt-ped-item.per-minfat)
               tt-ped-item.cd-origem               = 2
               tt-ped-item.tipo-atend              = (IF (tt-ped-venda.ind-fat-par) THEN 2 ELSE 1)
               tt-ped-item.cod-unid-negoc          = ITEM.cod-unid-negoc
               tt-ped-item.des-un-medida           = ITEM.un.

        FIND FIRST item-uni-estab NO-LOCK
             WHERE item-uni-estab.cod-estabel = tt-ped-venda.cod-estabel
               AND item-uni-estab.it-codigo   = tt-ped-item.it-codigo NO-ERROR.
        IF AVAIL item-uni-estab AND item-uni-estab.cod-unid-negoc <> tt-ped-item.cod-unid-negoc THEN
            ASSIGN tt-ped-item.cod-unid-negoc = item-uni-estab.cod-unid-negoc.

        IF  ITEM.tipo-contr = 4 THEN
            ASSIGN OVERLAY(tt-ped-item.char-2,09,02) = ITEM.un.

        ASSIGN de-vl-preco = ttItem.precoItem.

        ASSIGN tt-ped-item.vl-pretab   = de-vl-preco
               tt-ped-item.vl-preori   = de-vl-preco
               tt-ped-item.vl-preuni   = de-vl-preco.

        ASSIGN tt-ped-item.vl-liq-abe  = de-vl-preco
               tt-ped-item.vl-liq-it   = tt-ped-item.qt-pedida * tt-ped-item.vl-preuni
               tt-ped-item.vl-merc-abe = tt-ped-item.qt-pedida * tt-ped-item.vl-preuni
               tt-ped-item.vl-liq-abe  = tt-ped-item.qt-pedida * tt-ped-item.vl-preuni
               tt-ped-item.vl-desconto = ttItem.valorDesconto
               OVERLAY(tt-ped-item.char-2,56,5) = string(ITEM.cod-servico).

        /***************************/
        /* Substituiá∆o tribut†ria */
        /***************************/
         FIND unid-feder NO-LOCK 
            WHERE unid-feder.pais   = emitente.pais
              AND unid-feder.estado = emitente.estado NO-ERROR.

         IF  emitente.contrib-icms AND AVAIL unid-feder and unid-feder.ind-uf-subs THEN DO:
            FIND item-uf NO-LOCK 
               WHERE item-uf.it-codigo       = item.it-codigo
                 AND item-uf.cod-estado-orig = estabelec.estado
                 AND item-uf.estado          = emitente.estado NO-ERROR.

            FIND dist-emitente OF  emitente NO-LOCK  NO-ERROR .

            IF  natur-oper.subs-trib AND AVAIL item-uf AND AVAIL dist-emitente AND dist-emitente.nr-tb-pauta = '' AND emitente.insc-subs-trib = '' THEN
                ASSIGN tt-ped-item.ind-icm-ret = yes.
         END.

         /*-------------------------------------------------------------------------*/
         /*                            CRIAÄ«O PED-ENT                              */
         /*-------------------------------------------------------------------------*/
         ASSIGN i-sequencia              = i-sequencia + 10
                tt-ped-item.nr-sequencia = i-sequencia.

         CREATE tt-ped-ent.
         ASSIGN tt-ped-ent.nr-pedcli    = tt-ped-item.nr-pedcli
                tt-ped-ent.cod-sit-ent  = tt-ped-item.cod-sit-item
                tt-ped-ent.cod-sit-pre  = tt-ped-item.cod-sit-pre
                tt-ped-ent.dt-entorig   = tt-ped-item.dt-entorig
                tt-ped-ent.dt-entrega   = tt-ped-item.dt-entrega
                tt-ped-ent.dt-userimp   = tt-ped-item.dt-userimp
                tt-ped-ent.it-codigo    = tt-ped-item.it-codigo
                tt-ped-ent.nome-abrev   = tt-ped-item.nome-abrev
                tt-ped-ent.qt-pedida    = tt-ped-item.qt-pedida
                tt-ped-ent.user-impl    = tt-ped-item.user-impl
                tt-ped-ent.vl-liq-it    = tt-ped-item.vl-liq-it
                tt-ped-ent.nr-sequencia = tt-ped-item.nr-sequencia
                tt-ped-ent.vl-liq-abe   = tt-ped-item.vl-liq-abe.

         /** Acumula valores totais do pedido **/
         ASSIGN d-vl-liq-it  = d-vl-liq-it  + tt-ped-item.vl-liq-it
                d-vl-liq-abe = d-vl-liq-abe + tt-ped-item.vl-liq-abe.
    END.

    /*-------------------------------------------------------------------------*/
    /*                     VALIDAÄ«O CLASIFICAÄ«O FISCAL                       */
    /*-------------------------------------------------------------------------*/
    FOR EACH tt-ped-item NO-LOCK,
       FIRST ITEM NO-LOCK WHERE item.it-codigo = tt-ped-item.it-codigo:

       IF  (item.class-fisc = '') OR 
       NOT CAN-FIND (FIRST classif-fisc
                         WHERE classif-fisc.class-fiscal = item.class-fisc) THEN DO:
          RUN incluiMsgErro IN THIS-PROCEDURE ("ItemPedido", 1100, 'Item ' + tt-ped-item.it-codigo + ' sem classificaá∆o fiscal cadastrada.').
          RETURN "NOK".
       END.
    END.

    /** Valida naturezas dos itens. Se n∆o h† nenhuma igual Ö do cabeáalho do pedido, altera o cabeáalho do pedido **/
    IF (i-cont-nat-igual = 0) THEN 
       ASSIGN tt-ped-venda.nat-operacao = c-nat-oper.

    /*-------------------------------------------------------------------------*/
    /*              T O T A L I Z A Ä « O   D O   P E D I D O                 */
    /*-------------------------------------------------------------------------*/
    assign tt-ped-venda.vl-tot-ped = d-vl-liq-abe
           tt-ped-venda.vl-liq-abe = d-vl-liq-abe
           tt-ped-venda.vl-mer-abe = d-vl-liq-it
           tt-ped-venda.vl-liq-ped = d-vl-liq-it.

    RUN pi-regras-especificas (INPUT "aposCriaTTPedVenda").

    FIND FIRST tt-ped-venda NO-ERROR.
    FIND FIRST ttPedido NO-ERROR.
    FIND FIRST ttCondicaoPagamento NO-ERROR.
    
    /*-----------------------*/
    /* GRAVAR PEDIDO NA BASE */
    /*-----------------------*/
    IF NOT CAN-FIND(FIRST int-pedido-vtex
                    WHERE int-pedido-vtex.nr-pedido = ttPedido.numeroPedido
                      AND int-pedido-vtex.nr-pedcli <> "") THEN
        RUN pi-executar-bos.
    ELSE DO:
        IF ttPedido.marketplace = ""
        OR ttPedido.marketplace = "VTEX"
        OR ttPedido.marketplace = "BWW" 
        OR ttPedido.marketplace = "FSH"
        OR ttPedido.marketplace = "VVT"
        OR ttPedido.marketplace = "CLR"
        OR ttPedido.marketplace = "SMP"
        OR ttPedido.marketplace = "WBC"
        OR ttPedido.marketplace = "MLP"
        THEN
            RUN incluiMsgErro IN THIS-PROCEDURE ("Pedido", 1010, 'Pedido j† cadastrado; pedido ignorado.').
        ELSE
            RUN incluiMsgErro IN THIS-PROCEDURE ("Pedido", 1010, 'Pedido ' + STRING(ttPedido.numeroPedido) + ' j† cadastrado; Pedido no ERP:' + STRING(int-ped-venda2.nr-pedido)).
        
        RETURN "NOK".
    END.

    IF  RETURN-VALUE <> "OK" THEN DO:
         RUN incluiMsgErro IN THIS-PROCEDURE ("Pedido", 1130, "N∆o foi poss°vel concluir com sucesso a chamada da pi-executar-bos.").
        RETURN "NOK".
    END.

    RUN pi-gerar-dados-extrato ("APOS GRAVAR PED-VENDA AVAIL: "+ STRING(AVAIL tt-ped-venda)).
    RUN pi-gerar-dados-extrato ("APOS GRAVAR PED-VENDA nr-pedido: "+ STRING(tt-ped-venda.nr-pedido)).

    FIND FIRST tt-ped-venda NO-ERROR.
    FIND FIRST ttPedido NO-ERROR.
    FIND FIRST ttCondicaoPagamento NO-ERROR.

    FIND FIRST int-ped-venda NO-LOCK
         WHERE int-ped-venda.nr-pedido = tt-ped-venda.nr-pedido NO-ERROR.
    IF  NOT AVAILABLE (int-ped-venda) THEN DO:
        CREATE int-ped-venda.
        ASSIGN int-ped-venda.nr-pedido = tt-ped-venda.nr-pedido.
    END.

    RUN pi-gerar-dados-extrato ("APOS GRAVAR ttPedido AVAIL: "+ STRING(AVAIL ttPedido)).
    RUN pi-gerar-dados-extrato ("APOS GRAVAR ttCondicaoPagamento nr-pedido: "+ STRING(AVAIL ttCondicaoPagamento)).

    FIND CURRENT int-ped-venda EXCLUSIVE-LOCK NO-ERROR.
    ASSIGN int-ped-venda.cod-estabel            = estabelec.cod-estabel
           /*int-ped-venda.PedidoCodigo           = integer(TRIM(ttPedido.numeroPedido))*/
           int-ped-venda.LojaCodigo             = integer(TRIM(ttPedido.codigoLoja))
           int-ped-venda.UsuarioCodigo          = 0
           int-ped-venda.ContaCodigo            = emitente.cod-emitente
           int-ped-venda.ContaCorrenteCodigo    = ""
           int-ped-venda.GrupoCodigo            = 0
           int-ped-venda.CupomCodigo            = 0
           int-ped-venda.ParceiroCodigo         = 0
           int-ped-venda.VitrineCodigo          = 0
           int-ped-venda.ParcelamentoGCodigo    = 0
           int-ped-venda.ParcelamentoPCodigo    = 0
           int-ped-venda.ServicoEntregaCodigo   = 0
           int-ped-venda.nr-parcelas            = ttPedido.parcelas
           int-ped-venda.Score                  = 0
           int-ped-venda.CestaCodigo            = ""
           int-ped-venda.CestaMensagem          = ""
           int-ped-venda.Sedex                  = ""
           int-ped-venda.SedexData              = ?
           int-ped-venda.MotivoCancel           = ""
           int-ped-venda.Desconto               = 0
           int-ped-venda.FormaPgto              = ""
           int-ped-venda.ValorSubTotal          = 0
           int-ped-venda.ValorParcela           = 0
           int-ped-venda.ValorJuros             = 0
           int-ped-venda.Mensagem               = ""
           int-ped-venda.ValorFrete             = ttPedido.totalFrete
           int-ped-venda.ValorPresente          = 0
           int-ped-venda.PedidoStatus           = ""
           int-ped-venda.StatusIntegracao       = ""
           int-ped-venda.StatusClearSale        = ""
           int-ped-venda.AvisoBoleto            = ""
           int-ped-venda.FreteGratis            = ""
           int-ped-venda.ValorVale              = 0
           int-ped-venda.vl-frete               = ttPedido.totalFrete
           int-ped-venda.pedidocodigo           = tt-ped-venda.nr-pedido
           int-ped-venda.reference-number  = IF AVAIL ttCondicaoPagamento THEN ttCondicaoPagamento.numeroReferencia ELSE ""
           int-ped-venda.tid               = IF AVAIL ttCondicaoPagamento THEN ttCondicaoPagamento.tid ELSE ""
           overlay(int-ped-venda.char-1,26,15)  = "". /*ttpedido.CpfCnpjOrigem*/
    FIND CURRENT int-ped-venda NO-LOCK NO-ERROR.
    RELEASE int-ped-venda.

    FIND FIRST ped-venda NO-LOCK
         WHERE ped-venda.nr-pedido = tt-ped-venda.nr-pedido NO-ERROR.
    IF AVAILABLE ped-venda THEN DO:
        FIND FIRST int-ped-venda2 NO-LOCK
             WHERE int-ped-venda2.cod-estabel = ped-venda.cod-estabel
               AND int-ped-venda2.nr-pedido   = ped-venda.nr-pedido NO-ERROR.
        IF NOT AVAIL int-ped-venda2 THEN DO:
            CREATE int-ped-venda2.
            ASSIGN int-ped-venda2.nr-pedido   = ped-venda.nr-pedido
                   int-ped-venda2.cod-estabel = ped-venda.cod-estabel
                   int-ped-venda2.PedidoeCommerce = ttPedido.numeroPedido.
        END.
        ELSE DO:
            FIND CURRENT int-ped-venda2 EXCLUSIVE-LOCK NO-ERROR.
            ASSIGN int-ped-venda2.PedidoeCommerce = ttPedido.numeroPedido.
            FIND CURRENT int-ped-venda2 NO-LOCK NO-ERROR.
            RELEASE int-ped-venda2.
        END.                                                              

        FOR EACH ped-curva EXCLUSIVE-LOCK
           WHERE ped-curva.vl-lucro-br = 0
             AND ped-curva.it-codigo   = ttPedido.numeroPedido:
            DELETE ped-curva.
        END.
    END.

    /* Coloquei a aprovaPed no alocaPedido - Rubia (Jan/2015) */
    RUN alocaPedido IN THIS-PROCEDURE.

    /*
    IF  (l-suspender-pedido AND c-estab-entrega = "") AND i-loja <> 1 THEN DO:
        FIND CURRENT ped-venda EXCLUSIVE-LOCK NO-ERROR.
        IF  AVAIL ped-venda THEN
            ASSIGN ped-venda.observacoes = "Endereáo de entrega diverge do endereáo do cliente".
        RUN UpdateSuspension.
        FIND CURRENT ped-venda NO-LOCK.
    END.
    */
    RUN pi-gerar-dados-extrato ("> antes suspende c-estab-entrega: " + string(c-estab-entrega)).
    RUN pi-gerar-dados-extrato ("> antes suspende AVAIL b-redespacho: " + string(AVAIL b-redespacho)).
    IF  AVAIL b-redespacho THEN
        RUN pi-gerar-dados-extrato ("> antes suspende b-redespacho.estado: " + string(b-redespacho.estado)).
    RUN pi-gerar-dados-extrato ("> antes suspende emitente.estado: " + string(emitente.estado)).

    IF  AVAIL b-redespacho 
    AND b-redespacho.estado <> emitente.estado
    AND ttPedido.marketplace <> "Mibo"
	AND ttPedido.marketplace <> "GLX" 
    AND ttPedido.marketplace <> "LMS" THEN DO:
        FIND CURRENT ped-venda EXCLUSIVE-LOCK NO-ERROR.
        IF  AVAIL ped-venda THEN
            ASSIGN ped-venda.observacoes = "Pedido RETIRA - Estado do cliente difere do estado de entrega.".
        RUN UpdateSuspension.
        FIND CURRENT ped-venda NO-LOCK.
    END.


    /*SE OS ITENS ALOCARAM DE DEPOSITOS DIFERENTES, DEVE SER DEFINIDO ATENDENTE 22 */
    IF  NUM-ENTRIES(c-dep-aux, ";") > 2 
    AND ttPedido.codigoLoja <> "3" THEN DO:
        FIND CURRENT ped-venda EXCLUSIVE-LOCK NO-ERROR.
        IF  AVAIL ped-venda THEN
            ASSIGN ped-venda.tp-pedido = "22"
                   ped-venda.ind-fat-par = yes.
        FIND CURRENT ped-venda NO-LOCK NO-ERROR.
    END.

    FIND FIRST tt-ped-venda NO-ERROR.
    RUN aprovaPedido IN THIS-PROCEDURE.

    CREATE tt-ped-valid.
    ASSIGN tt-ped-valid.PedidoCodigo = ENTRY(1,ttPedido.numeroPedido,"-")
           tt-ped-valid.contaCodigo  = string(emitente.cod-emitente).
    
    RETURN "OK".

END.

PROCEDURE pi-executar-bos:
   
   DEFINE VARIABLE h-bodi159     AS HANDLE NO-UNDO.
   DEFINE VARIABLE h-bodi154     AS HANDLE NO-UNDO.
   DEFINE VARIABLE h-bodi157     AS HANDLE NO-UNDO.
   
   RUN dibo/bodi159.p PERSISTENT SET h-bodi159.

   RUN openQueryStatic IN h-bodi159(INPUT 'Main':U).
   RUN setRecord       IN h-bodi159(INPUT TABLE tt-ped-venda).
   RUN inputRowVendor  IN h-bodi159(INPUT TABLE tt-ped-vendor).
   RUN emptyRowErrors  IN h-bodi159.
   RUN createMPLog     IN h-bodi159(INPUT no).
   RUN createRecord    IN h-bodi159.
   RUN getRowErrors    IN h-bodi159(OUTPUT TABLE RowErrors).
   
   ASSIGN l-erro = NO.

   FOR EACH RowErrors NO-LOCK
      where RowErrors.ErrorType   <> 'INTERNAL':U
        and RowErrors.ErrorSubType = 'Error':U:
      RUN incluiMsgErro IN THIS-PROCEDURE ("Pedido", STRING(RowErrors.errorNumber), RowErrors.ERRORDescription + " - " + RowErrors.ErrorHelp).
      ASSIGN l-erro = yes.
   end.

   IF  VALID-HANDLE(h-bodi159) AND (h-bodi159:file-name = 'dibo/bodi159.p' AND h-bodi159:type = 'procedure') THEN
       RUN destroyBO IN h-bodi159.

   IF  VALID-HANDLE(h-bodi159) THEN DO:
       DELETE PROCEDURE h-bodi159.
       ASSIGN h-bodi159 = ?.
   END.

   IF  l-erro THEN
       RETURN 'NOK'.

   RUN dibo/bodi157.p PERSISTENT SET h-bodi157.

   FOR EACH tt-ped-repre:
      RUN openQueryStatic in h-bodi157(INPUT 'Default':U).

      RUN emptyRowErrors in h-bodi157.
      RUN setRecord in h-bodi157(INPUT TABLE tt-ped-repre).
      RUN createMPLog  in h-bodi157(INPUT no).
      RUN createRecord in h-bodi157.
      RUN getRowErrors in h-bodi157(OUTPUT TABLE RowErrors).

      FOR EACH RowErrors NO-LOCK
         WHERE RowErrors.ErrorType   <> 'INTERNAL':U
           AND RowErrors.ErrorSubType = 'Error':U:
         RUN incluiMsgErro IN THIS-PROCEDURE ("Pedido", STRING(RowErrors.errorNumber), RowErrors.ERRORDescription + " - " + RowErrors.ErrorHelp).
         ASSIGN l-erro = YES.
      END.
      DELETE tt-ped-repre.
   END.

   IF  VALID-HANDLE(h-bodi157) THEN DO:
      DELETE PROCEDURE h-bodi157.
      ASSIGN h-bodi157 = ?.
   END.
   
   IF  l-erro THEN 
       RETURN 'NOK'.

   RUN dibo/bodi154.p PERSISTENT SET h-bodi154.

   FOR EACH tt-ped-item:

      RUN openQueryStatic in h-bodi154(INPUT 'Default':U).

      RUN emptyRowErrors IN  h-bodi154.
      RUN setRecord      IN  h-bodi154(INPUT TABLE tt-ped-item).
      RUN createMPLog    IN h-bodi154(INPUT no).
      RUN createRecord   IN h-bodi154.
      RUN getRowErrors   IN h-bodi154(OUTPUT TABLE RowErrors).
      
      FOR EACH RowErrors NO-LOCK
         WHERE RowErrors.ErrorType   <> 'INTERNAL':U
           AND RowErrors.ErrorSubType = 'Error':U:
         RUN incluiMsgErro IN THIS-PROCEDURE ("Pedido", STRING(RowErrors.errorNumber), RowErrors.ERRORDescription + " - " + RowErrors.ErrorHelp).
         ASSIGN l-erro = yes.
      end.
      delete tt-ped-item.
   end.

   IF  VALID-HANDLE(h-bodi154) AND h-bodi154:file-name = 'dibo/bodi154.p' AND h-bodi154:type = 'procedure' THEN
       RUN destroyBO IN h-bodi154.
   IF  VALID-HANDLE(h-bodi154) THEN DO:
      DELETE PROCEDURE h-bodi154.
      ASSIGN h-bodi154 = ?.
   END.

   IF  l-erro THEN 
       RETURN 'NOK'.

   FIND FIRST ped-venda NO-LOCK
        WHERE ped-venda.nr-pedcli  = tt-ped-venda.nr-pedcli
          AND ped-venda.nome-abrev = tt-ped-venda.nome-abrev NO-ERROR.
   IF AVAIL ped-venda THEN DO:
       /* Cria a Cond-ped antes do Complete, onde o pedido j† est† criado e antes da validaá∆o de parcelamento */
       IF ped-venda.cod-cond-pag = 0 THEN DO:
           FOR EACH tt-cond-ped:
               CREATE cond-ped.
               ASSIGN cond-ped.nr-pedido    = tt-cond-ped.nr-pedido    
                      cond-ped.nr-sequencia = tt-cond-ped.nr-sequencia 
                      cond-ped.data-pagto   = tt-cond-ped.data-pagto   
                      cond-ped.cod-vencto   = tt-cond-ped.cod-vencto   
                      cond-ped.nr-dias-venc = tt-cond-ped.nr-dias-venc 
                      cond-ped.vl-pagto     = tt-cond-ped.vl-pagto     
                      cond-ped.perc-pagto   = tt-cond-ped.perc-pagto   
                      cond-ped.observacoes  = tt-cond-ped.observacoes. 

               FIND FIRST int-ped-venda NO-LOCK
                    WHERE int-ped-venda.nr-pedido = tt-cond-ped.nr-pedido NO-ERROR.
               IF AVAIL int-ped-venda THEN DO:
                   FIND CURRENT int-ped-venda EXCLUSIVE-LOCK NO-ERROR.
                   /* Forma pagto:BOLETO */
                   IF ENTRY(2,ENTRY(2,cond-ped.observacoes,CHR(10)),":") = "BOLETO" THEN
                       ASSIGN int-ped-venda.cartid = "999".
                   ELSE DO:
                       FIND FIRST ttCondicaoPagamento NO-ERROR.
                       
                       ASSIGN int-ped-venda.cartid = IF AVAIL ttCondicaoPagamento THEN ttCondicaoPagamento.Nsu ELSE "".
    
                   END.
                   FIND CURRENT int-ped-venda NO-LOCK NO-ERROR.
                   RELEASE int-ped-venda.
               END.                      
           END.
       END.
   END.

   /************************/
   /* COMPLETANDO O PEDIDO */
   /************************/
   EMPTY TEMP-TABLE RowErrors.
   RUN dibo/bodi159com.p PERSISTENT SET h-bodi159cal.
   RUN completeOrder in h-bodi159cal (INPUT ROWID(ped-venda), OUTPUT TABLE RowErrors).

   FIND FIRST ttPedido NO-ERROR.

   FOR EACH RowErrors NO-LOCK
      WHERE RowErrors.ErrorNumber <> 8259 /** crÇdito n∆o aprovado **/
        AND RowErrors.ErrorSubType = 'Error':

       IF  ttPedido.marketplace = "CFI"
       AND RowErrors.ErrorNumber = 17567 THEN NEXT.

      RUN incluiMsgErro IN THIS-PROCEDURE ("Pedido", STRING(RowErrors.errorNumber), RowErrors.ERRORDescription + " - " + RowErrors.ErrorHelp).
      ASSIGN l-erro = YES.
   END.
    
   IF  VALID-HANDLE(h-bodi159cal) AND h-bodi159cal:file-name = 'dibo/bodi159com.p' AND h-bodi159cal:type = 'procedure' THEN
       RUN destroyBO IN  h-bodi159cal.
   IF  VALID-HANDLE(h-bodi159cal) THEN DO:
       DELETE PROCEDURE h-bodi159cal.
       ASSIGN h-bodi159cal = ?.
   END.
   
   IF  l-erro THEN 
       RETURN "NOK".

   RETURN "OK".

END PROCEDURE .

procedure alocaPedido:
   
   DEFINE VARIABLE h-alocacao          AS HANDLE   NO-UNDO.
   DEFINE VARIABLE de-qt-a-alocar      AS DECIMAL  NO-UNDO.
   DEFINE VARIABLE de-qt-saldo         AS DECIMAL  NO-UNDO.
   DEFINE VARIABLE d-qtde-reservas-ast AS DECIMAL  NO-UNDO.
   
   RUN pdp/pdapi002.p PERSISTENT SET h-alocacao.

   IF (ped-venda.cod-sit-ped <= 2) AND (ped-venda.completo)  THEN DO:

      RUN aprovaPedido IN THIS-PROCEDURE.

      FIND FIRST ped-venda NO-LOCK
           WHERE ped-venda.nr-pedcli  = tt-ped-venda.nr-pedcli
             AND ped-venda.nome-abrev = tt-ped-venda.nome-abrev NO-ERROR.
        

      /*
      IF  RETURN-VALUE = 'NOK' THEN DO:
          RUN incluiMsgErro IN THIS-PROCEDURE ("Pedido", 1140, 'Erro na aprovaá∆o do pedido. Aprovaá∆o e Alocaá∆o de saldo devem ser feitos manualmente.').
          UNDO aloca_pedido, RETURN 'NOK'.
      END.
      */
      /* fim run aprovaPedido in this-procedure. */


      FOR EACH ped-item OF ped-venda NO-LOCK
         WHERE ped-item.cod-sit-item <= 2,
         FIRST ITEM NO-LOCK
            WHERE ITEM.it-codigo   = ped-item.it-codigo
              AND ITEM.tipo-contr <> 4:

         FIND ped-ent NO-LOCK
            WHERE ped-ent.nome-abrev   = ped-item.nome-abrev
              AND ped-ent.nr-pedcli    = ped-item.nr-pedcli
              AND ped-ent.nr-sequencia = ped-item.nr-sequencia
              AND ped-ent.it-codigo    = ped-item.it-codigo
              AND ped-ent.cod-refer    = ped-item.cod-refer NO-ERROR.

         ASSIGN de-qt-a-alocar = ped-item.qt-pedida - ped-item.qt-atendida - ped-item.qt-log-aloca.

         IF  de-qt-a-alocar = 0 THEN 
             NEXT.

         IF CAN-FIND (FIRST item-uni-estab
                      WHERE item-uni-estab.cod-estabel = ped-venda.cod-estabel
                        AND item-uni-estab.it-codigo   = ped-item.it-codigo
                        AND item-uni-estab.nr-linha    = 20) THEN DO:
            RETURN 'NOK'.
         END.

         blk_saldo:
         FOR EACH int-vtex-estab-depos NO-LOCK
             WHERE int-vtex-estab-depos.cod-estabel = ped-venda.cod-estabeL:

             ASSIGN de-qt-saldo = 0.

             FOR FIRST saldo-estoq NO-LOCK
                WHERE  saldo-estoq.it-codigo = ped-item.it-codigo
                  AND  saldo-estoq.cod-estabel = ped-venda.cod-estabel
                  AND  saldo-estoq.cod-depos = int-vtex-estab-depos.cod-depos
                  AND  saldo-estoq.cod-localiz = ""
                  AND (saldo-estoq.qtidade-atu - (saldo-estoq.qt-alocada + saldo-estoq.qt-aloc-prod + saldo-estoq.qt-aloc-ped)) > 0:
                ASSIGN de-qt-saldo = (saldo-estoq.qtidade-atu - (saldo-estoq.qt-alocada + saldo-estoq.qt-aloc-prod + saldo-estoq.qt-aloc-ped)).
             END.

             /*VERIFICAR NAS RESERVAS E DESCONTAR APENAS QUANDO O USUµRIO N«O ESTIVER NO ES0016, PONTO 2 do WSO0003 */
             FOR EACH reservas-ast
                 WHERE reservas-ast.cod-depos   = int-vtex-estab-depos.cod-depos
                 AND   reservas-ast.it-codigo   = ped-item.it-codigo
                 AND   reservas-ast.cod-estabel = ped-venda.cod-estabel
                 AND   reservas-ast.dt-reserva  <= TODAY NO-LOCK:

                 /*Caso existam reservas mas os usu†rio reservam para VTEX*/
                 IF  CAN-FIND(FIRST tt-usuarios-reserva
                                WHERE tt-usuarios-reserva.usuario = reservas-ast.cd-usuario) THEN
                     NEXT.

                 IF reservas-ast.data-limite = ? OR reservas-ast.data-limite >= TODAY THEN
                     ASSIGN d-qtde-reservas-ast = d-qtde-reservas-ast + reservas-ast.qt-reserva.
             END.

             RUN pi-gerar-dados-extrato ("> wsi0003 de-qt-saldo: " + string(de-qt-saldo)).
             RUN pi-gerar-dados-extrato ("> wsi0003 d-qtde-reservas-ast: " + string(d-qtde-reservas-ast)).
             RUN pi-gerar-dados-extrato ("> wsi0003 de-qt-a-alocar: " + string(de-qt-a-alocar)).
             
             IF (de-qt-saldo - d-qtde-reservas-ast >= de-qt-a-alocar) THEN DO:
                 
                RUN pi-aloca-fisica-man IN h-alocacao(INPUT ROWID(ped-ent), INPUT-OUTPUT de-qt-a-alocar, INPUT ROWID(saldo-estoq)).
        
                RUN pi-gerar-dados-extrato ("> wsi0003 pi-aloca-fisica-man return-value: " + string(RETURN-VALUE)).
                RUN pi-gerar-dados-extrato ("> wsi0003 antes c-dep-aux: " + string(c-dep-aux)).
                RUN pi-gerar-dados-extrato ("> wsi0003 saldo-estoq: " + string(saldo-estoq.cod-depos)).
    
    
                IF  RETURN-VALUE = "NOK" THEN
                     RETURN 'NOK'.
                ELSE
                     IF  INDEX(c-dep-aux, saldo-estoq.cod-depos) = 0 THEN
                         ASSIGN c-dep-aux = c-dep-aux + ";" + saldo-estoq.cod-depos.
               
                RUN pi-gerar-dados-extrato ("> wsi0003 depois c-dep-aux: " + string(c-dep-aux)).

                LEAVE blk_saldo.
             END.
         END.

         IF c-dep-aux = "" THEN
             NEXT.
         
         FIND FIRST int-ped-item NO-LOCK
            WHERE int-ped-item.nome-abrev      = ped-venda.nome-abrev
              AND int-ped-item.nr-pedcli       = ped-venda.nr-pedcli
              AND int-ped-item.nr-sequencia    = ped-item.nr-sequencia
              AND int-ped-item.it-codigo       = ped-item.it-codigo
              AND int-ped-item.cod-refer       = ped-item.cod-refer NO-ERROR.
         IF NOT AVAILABLE (int-ped-item) THEN DO:
             CREATE int-ped-item.
             ASSIGN int-ped-item.nome-abrev      = ped-venda.nome-abrev
                    int-ped-item.nr-pedcli       = ped-venda.nr-pedcli
                    int-ped-item.nr-sequencia    = ped-item.nr-sequencia
                    int-ped-item.it-codigo       = ped-item.it-codigo
                    int-ped-item.cod-refer       = ped-item.cod-refer
                    int-ped-item.log-transferido = YES.
         END.
         ELSE DO:
             FIND CURRENT int-ped-item EXCLUSIVE-LOCK NO-ERROR.
             ASSIGN int-ped-item.log-transferido = YES.
             FIND CURRENT int-ped-item EXCLUSIVE-LOCK NO-ERROR.
             RELEASE int-ped-item.
         END.
      END.
   END.

   IF VALID-HANDLE(h-alocacao) THEN
      DELETE PROCEDURE h-alocacao.

   ASSIGN h-alocacao = ?.

   RETURN "OK" .

END PROCEDURE.
   
PROCEDURE aprovaPedido:

   IF  ped-venda.cod-sit-aval = 3 THEN
       RETURN "OK".
   
   FIND FIRST ped-venda NO-LOCK
        WHERE ped-venda.nr-pedcli  = tt-ped-venda.nr-pedcli
          AND ped-venda.nome-abrev = tt-ped-venda.nome-abrev NO-ERROR.
   IF NOT AVAILABLE (ped-venda) THEN 
       RETURN 'NOK'.

   FIND CURRENT ped-venda EXCLUSIVE-LOCK NO-ERROR.
   ASSIGN ped-venda.cod-sit-aval       = 3 /** Aprovado **/
          ped-venda.desc-bloq-cr       = ''
          ped-venda.dsp-pre-fat        = YES 
          ped-venda.cod-message-alerta = 0
          ped-venda.dt-mensagem        = ?
          ped-venda.nome-prog          = ''
          ped-venda.dt-apr-cred        = TODAY.
   FIND CURRENT ped-venda NO-LOCK NO-ERROR.
   RELEASE ped-venda.

   RETURN 'OK'.

END PROCEDURE.


/*-----------------------------------------------------------------------------------------*/
/*                  PROCEDURE PARA CRIAÄ«O PESSOA FISICA E JURIDICA                        */
/*-----------------------------------------------------------------------------------------*/
PROCEDURE pi-cria-tt-emitente:

    DEFINE OUTPUT PARAM i-ind-tipo-movto       AS INTEGER     NO-UNDO.

    DEFINE VARIABLE p-prox-emitente        AS INTEGER     NO-UNDO.
    DEFINE VARIABLE c-cgc                  AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE i-loja                 AS INTEGER     NO-UNDO.
    DEFINE VARIABLE c-ins-estadual         AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-email                AS CHAR        NO-UNDO.
    DEFINE VARIABLE c-nome-emit            AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE i-natureza             AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-identIFic            AS INTEGER      NO-UNDO.
    DEFINE VARIABLE c-endereco             AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-bairro               AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-cidade               AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-pais                 AS CHARACTER   NO-UNDO.

    ASSIGN l-pj = NO.

    FOR FIRST ttpessoaJuridica NO-LOCK,
        FIRST ttDocumento
        WHERE ttDocumento.tipoDocumento = "CNPJ"
          AND ttDocumento.NumeroDocumento <> "":

        ASSIGN l-pj = YES.

    END.

    IF l-pj = NO THEN DO:
        FOR FIRST ttpessoaFisica NO-LOCK,
            FIRST ttDocumento
            WHERE ttDocumento.tipoDocumento = "CPF"
              AND ttDocumento.NumeroDocumento <> "": END.
    END.
    
    FOR FIRST ttPedido:
        ASSIGN i-loja = int(ttPedido.codigoLoja).
    END.

    FIND FIRST int-pedido-param NO-LOCK
         WHERE int-pedido-param.marketplace = TRIM(ttPedido.marketplace)
           AND int-pedido-param.loja        = ttPedido.codigoLoja NO-ERROR.
    IF AVAIL int-pedido-param THEN DO:
        FIND FIRST gr-cli NO-LOCK
             WHERE gr-cli.cod-gr-cli = int-pedido-param.cod-gr-cli NO-ERROR.
        IF  NOT AVAIL gr-cli THEN DO:
            RUN incluiMsgErro in THIS-PROCEDURE ("Cliente", 2001, "Grupo de cliente " + STRING(int-pedido-param.cod-gr-cli) + " n∆o cadastro no ERP.").
            RETURN "OK".
        END.
    END.
    
    /*----------------- N¢ <Documento> ----------------*/
    ASSIGN c-cgc          = REPLACE(REPLACE(REPLACE(ttDocumento.NumeroDocumento, '.', ''), '-', ''), '/', '')
           c-ins-estadual = "ISENTO".

    IF l-pj THEN
        ASSIGN c-nome-emit = ttpessoaJuridica.nomeFantasia
               i-natureza  = 2.
    ELSE
        ASSIGN c-nome-emit = ttpessoaFisica.nome 
               i-natureza  = 1.

    FIND FIRST ttDocumento-IE
         WHERE ttDocumento-IE.tipoDocumento = "inscricaoEstadual"
           AND ttDocumento-IE.NumeroDocumento <> "" NO-ERROR.
    IF AVAIL ttDocumento-IE THEN
        ASSIGN c-ins-estadual = ttDocumento-IE.NumeroDocumento.

    RUN pi-gerar-dados-extrato ("JONK> c-ins-estadual  : " + STRING(c-ins-estadual)).

    /*------------------ N¢ <Email> -------------------*/
    FIND LAST ttEmail NO-ERROR.
    IF  AVAIL ttEmail THEN
        ASSIGN c-email = ttEmail.endereco.

    /** Inserá∆o ou Atualizaá∆o **/
    FIND FIRST emitente WHERE emitente.cgc = c-cgc NO-LOCK NO-ERROR.
    IF AVAIL emitente THEN
       ASSIGN i-ind-tipo-movto = 2 /**Atualizaá∆o*/
              i-cod-emitente   = emitente.cod-emitente.
    ELSE do:
       RUN cdp/cd9960.p (OUTPUT p-prox-emitente).
       ASSIGN i-cod-emitente   = p-prox-emitente
              i-ind-tipo-movto = 1
              i-identIFic      = 1.
    END.

    RUN pi-gerar-dados-extrato ("JONK> EMITENTE : " + STRING(i-cod-emitente)).
    RUN pi-gerar-dados-extrato ("JONK> i-ind-tipo-movto : " + STRING(i-ind-tipo-movto)).

    /** Cria registro da temp-table para API **/
    CREATE tt-emitente.

    /* Criaá∆o */
    IF (i-ind-tipo-movto = 1) THEN DO:

        ASSIGN tt-emitente.cod-emitente   = i-cod-emitente
               tt-emitente.nome-abrev     = SUBSTRING(c-cgc,1,12)
               tt-emitente.cgc            = c-cgc
               tt-emitente.cgc-cob        = c-cgc
               tt-emitente.ins-estadual   = c-ins-estadual 
               tt-emitente.ins-est-cob    = c-ins-estadual
               tt-emitente.ins-municipal  = ""
               tt-emitente.ins-est-cob    = ""
               tt-emitente.identIFic      = 1 /*1 Cliente, 2 Fornecedore, 3 Ambos*/
               tt-emitente.natureza       = i-natureza /** 1-Pessoa F°sica 2-Pessoa Jur°dica 3-Estrangeiro 4-Trading **/
               tt-emitente.nome-emit      = fn-free-accent(UPPER(c-nome-emit))
               tt-emitente.e-mail         = fn-free-accent(lower(c-email))
               tt-emitente.caixa-postal   = ''
               tt-emitente.home-page      = ''
               tt-emitente.cod-cond-pag   = gr-cli.cod-cond-pag
               tt-emitente.taxa-financ    = 0
               tt-emitente.cod-transp     = gr-cli.cod-transp
               tt-emitente.linha-produt   = gr-cli.linha-produt
               tt-emitente.atividade      = gr-cli.atividade
               tt-emitente.contato[1]     = ''
               tt-emitente.contato[2]     = ''
               tt-emitente.telex          = ''
               tt-emitente.data-implant   = today
               tt-emitente.END-cobranca   = tt-emitente.cod-emitente
               tt-emitente.cod-rep        = gr-cli.cod-rep
               tt-emitente.categoria      = gr-cli.categoria
               tt-emitente.bonIFicacao    = gr-cli.bonIFicacao
               tt-emitente.istr           = 0
               tt-emitente.cod-gr-cli     = gr-cli.cod-gr-cli
               tt-emitente.tp-rec-padrao  = 110
               tt-emitente.ins-banc[1]    = 7
               tt-emitente.ins-banc[2]    = 0
               tt-emitente.tp-desp-padrao = 0
               tt-emitente.cod-gr-forn    = 0
               tt-emitente.lim-credito    = gr-cli.lim-credito
               tt-emitente.perc-fat-ped   = gr-cli.perc-fat-ped
               tt-emitente.portador       = gr-cli.portador
               tt-emitente.modalidade     = gr-cli.modalidade
               tt-emitente.ind-fat-par    = gr-cli.ind-fat-par
               tt-emitente.contrib-icms   = IF c-ins-estadual = "ISENTO" THEN NO ELSE YES
               tt-emitente.ind-cre-cli    = 1 /** 1-Normal 2-Autom†tico 3-S¢ Imp Ped 4-Suspenso 5-Pg a Vista **/
               tt-emitente.ind-apr-cred   = gr-cli.ind-apr-cred
               tt-emitente.nome-matriz    = tt-emitente.nome-abrev
               tt-emitente.agencia        = '0000000'
               tt-emitente.per-max-canc   = gr-cli.per-max-canc
               tt-emitente.emite-etiq     = no /** Emite Etiqueta **/
               tt-emitente.tr-ar-valor    = 1 /** NFE 1-TRUNca 2-Arredonda **/
               tt-emitente.gera-ad        = no /** Gera Aviso DÇbito **/
               tt-emitente.bx-acatada     = 0
               tt-emitente.conta-corren   = '000000000000'
               tt-emitente.nr-copias-ped  = 1
               tt-emitente.cod-suframa    = ''
               tt-emitente.cod-cacex      = ''
               tt-emitente.gera-dIFer     = 0
               tt-emitente.nr-tabpre      = gr-cli.nr-tabpre
               tt-emitente.ind-aval       = 3
               tt-emitente.user-libcre    = '*'
               tt-emitente.ven-domingo    = 1 /** Vencto Domingo 1-Prorroga 2-Antecipa 3-MantÇm **/
               tt-emitente.ven-sabado     = 1 /** Vencto S†bado 1-Prorroga 2-Antecipa 3-MantÇm **/
               tt-emitente.cx-post-cob    = ''
               tt-emitente.cod-banco      = 0
               tt-emitente.prox-ad        = 0
               tt-emitente.nr-peratr      = gr-cli.nr-peratr
               tt-emitente.nr-mesina      = gr-cli.nr-mesina
               tt-emitente.cod-mensagem   = 0
               tt-emitente.forn-exp       = no
               tt-emitente.tp-qt-prg      = 1 /** Tp Qtde 1-L°quida 2-Acumulada **/
               tt-emitente.ind-atraso     = 1 /** Atraso 1-N∆o Informa 2-Informa 3-Sumaria **/
               tt-emitente.ind-div-atraso = 1 /** Atraso 1-N∆o Aceita 2-Ignora 3-Assume Situaá∆o Inferior 4-Assume Qtde Inferior **/
               tt-emitente.ind-dIF-atrs-1 = 1 /** Inf > Calc 1-N∆o Aceita 2-Ignora 3-Adiciona Atraso + Recente **/
               tt-emitente.ind-dIF-atrs-2 = 1 /** Inf < Calc 1-N∆o Aceita 2-Ignora 3-Adiciona Atraso + Antigo **/
               tt-emitente.esp-pd-vENDa   = 1
               tt-emitente.resumo-mp      = 2 /** Resumo Multiplanta 1-Calculado 2-∑ Calcular **/
               tt-emitente.ind-tipo-movto = 1 /** 1-Inclus∆o 2-Alteraá∆o **/
               tt-emitente.tip-cob-desp   = 2 /* Rateia despesas entre todas as duplicatas */
               tt-emitente.cod-entrega    = "Padr∆o"
               tt-emitente.ind-lib-estoque = YES.

        RUN pi-gerar-dados-extrato ("cria tt-emitente.cod-emitente: " + string(tt-emitente.cod-emitente)).
        RUN pi-gerar-dados-extrato ("cria tt-emitente.nome-abrev: " + string(tt-emitente.nome-abrev)).
        RUN pi-gerar-dados-extrato ("cria tt-emitente.cgc: " + string(tt-emitente.cgc)).

        FIND FIRST b-emitente NO-LOCK
             WHERE b-emitente.nome-abrev  = tt-emitente.nome-matriz
               AND b-emitente.nome-abrev <> tt-emitente.nome-abrev NO-ERROR.

        IF AVAIL b-emitente THEN DO:
            ASSIGN tt-emitente.port-prefer = b-emitente.port-prefer
                   tt-emitente.mod-prefer  = b-emitente.mod-prefer.
        END.

        FOR EACH ttTelefone:
            IF  ttTelefone.tipo = "Residencial" THEN
                ASSIGN c-telefone-1 = ttTelefone.ddd + ttTelefone.telefone.
            ELSE
                ASSIGN c-telefone-2 = ttTelefone.ddd + ttTelefone.telefone.
        END.   
        IF  c-telefone-1 = ""  THEN
            ASSIGN c-telefone-1 = c-telefone-2
                   c-telefone-2 = "".
    
        ASSIGN tt-emitente.telefone[1]    = c-Telefone-1
               tt-emitente.telefone[2]    = c-Telefone-2
               tt-emitente.telefone[1]    = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(tt-emitente.telefone[1],"/",""),"-",""),"(",""),")","")," ","")
               tt-emitente.telefone[2]    = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(tt-emitente.telefone[2],"/",""),"-",""),"(",""),")","")," ","").

        IF (tt-emitente.natureza = 1) THEN
           ASSIGN tt-emitente.nat-operacao = '510102'
                  tt-emitente.nat-ope-ext  = '610101'.
        ELSE IF tt-emitente.natureza = 2 THEN
           ASSIGN tt-emitente.nat-operacao = '510102'
                  tt-emitente.nat-ope-ext  = (IF (tt-emitente.ins-estadual = '') or (tt-emitente.ins-estadual = 'ISENTO') THEN '610700' ELSE '610101').

        ASSIGN tt-emitente.observacoes    = 'Cadastro inserido pelo WSO2 em ' + string(today,"99/99/9999") + '.~r'.
        
     END.
     ELSE do:
        /** Alteraá∆o **/
         

        /*FIND FIRST emitente NO-LOCK
             WHERE emitente.cgc = c-cgc NO-ERROR.
        IF AVAIL emitente THEN
            IF emitente.ind-lib-estoque <> YES THEN DO:
                FIND CURRENT emitente EXCLUSIVE-LOCK NO-ERROR.
                ASSIGN emitente.ind-lib-estoque = YES. /* N∆o gravou via api */
                FIND CURRENT emitente NO-LOCK NO-ERROR.
                RELEASE emitente.
            END.*/

        FIND FIRST emitente NO-LOCK
             WHERE emitente.cgc = c-cgc NO-ERROR.

        BUFFER-COPY emitente TO tt-emitente.

        IF emitente.natureza = 1 THEN
            ASSIGN tt-emitente.nome-emit       = fn-free-accent(UPPER(c-nome-emit))
                   tt-emitente.e-mail          = fn-free-accent(lower(c-email))
                   tt-emitente.ins-estadual    = c-ins-estadual 
                   tt-emitente.ins-est-cob     = c-ins-estadual
	               tt-emitente.contrib-icms    = IF c-ins-estadual = "ISENTO" THEN NO ELSE YES.

        ASSIGN tt-emitente.identIFic       = (IF (tt-emitente.identIFic = 2) THEN 3 ELSE tt-emitente.identIFic)
               tt-emitente.ind-tipo-movto  = 2
               tt-emitente.ind-cre-cli     = 1 /** 1-Normal 2-Autom†tico 3-S¢ Imp Ped 4-Suspenso 5-Pg a Vista **/
               tt-emitente.ind-lib-estoque = YES.

        RUN pi-gerar-dados-extrato ("JONK> tt-emitente.ins-estadual : " + STRING(tt-emitente.ins-estadual)).

        /** Se era fornecedor, tem campos novos para preencher quANDo cliente **/
        IF (emitente.identIFic = 2) THEN do:

           ASSIGN tt-emitente.cod-cond-pag   = gr-cli.cod-cond-pag
                  tt-emitente.cod-transp     = gr-cli.cod-transp
                  tt-emitente.linha-produt   = gr-cli.linha-produt
                  tt-emitente.atividade      = gr-cli.atividade
                  tt-emitente.cod-rep        = gr-cli.cod-rep
                  tt-emitente.categoria      = gr-cli.categoria
                  tt-emitente.bonIFicacao    = gr-cli.bonIFicacao
                  tt-emitente.cod-gr-cli     = gr-cli.cod-gr-cli
                  tt-emitente.tp-rec-padrao  = 110
                  tt-emitente.ins-banc[1]    = 7
                  tt-emitente.ins-banc[2]    = 0
                  tt-emitente.lim-credito    = gr-cli.lim-credito
                  tt-emitente.perc-fat-ped   = gr-cli.perc-fat-ped
                  tt-emitente.portador       = gr-cli.portador
                  tt-emitente.modalidade     = gr-cli.modalidade
                  tt-emitente.ind-fat-par    = gr-cli.ind-fat-par
                  tt-emitente.contrib-icms   = YES
                  tt-emitente.ind-cre-cli    = 1 /** 1-Normal 2-Autom†tico 3-S¢ Imp Ped 4-Suspenso 5-Pg a Vista **/
                  tt-emitente.ind-apr-cred   = gr-cli.ind-apr-cred
                  tt-emitente.per-max-canc   = gr-cli.per-max-canc
                  tt-emitente.nr-tabpre      = gr-cli.nr-tabpre
                  tt-emitente.ind-aval       = 3
                  tt-emitente.user-libcre    = '*'
                  tt-emitente.nr-peratr      = gr-cli.nr-peratr
                  tt-emitente.nr-mesina      = gr-cli.nr-mesina
                  tt-emitente.esp-pd-vENDa   = 1. /** 1-Inclus∆o 2-Alteraá∆o **/

           RUN pi-gerar-dados-extrato ("altera tt-emitente.cod-emitente: " + string(tt-emitente.cod-emitente)).
           RUN pi-gerar-dados-extrato ("altera tt-emitente.nome-abrev: " + string(tt-emitente.nome-abrev)).
           RUN pi-gerar-dados-extrato ("altera tt-emitente.cgc: " + string(tt-emitente.cgc)).

            FIND FIRST b-emitente NO-LOCK
                 WHERE b-emitente.nome-abrev  = tt-emitente.nome-matriz
                   AND b-emitente.nome-abrev <> tt-emitente.nome-abrev NO-ERROR.

            IF AVAIL b-emitente THEN DO:
                ASSIGN tt-emitente.port-prefer = b-emitente.port-prefer
                       tt-emitente.mod-prefer  = b-emitente.mod-prefer.
            END.

        END.
        
        ASSIGN tt-emitente.observacoes     = 'Cadastro modificado pelo WSO2 em ' + string(today,"99/99/9999") + '.~r'.

     END.

     /** Tratamento dos Endereáos **/
     ASSIGN c-pais         = "BRASIL". /*S‡ HAVERµ COMPRADORES NACIONAIS*/

     FOR LAST  ttendereco NO-LOCK
         WHERE ttendereco.siglaPais   <> ''
           AND ttendereco.siglaEstado <> ''
           AND ttendereco.municipio   <> '':

         IF (ttendereco.CEP = '88104800') THEN
            ASSIGN c-endereco = 'INTELBRAS SA - ROD. BR 101, KM 213'
                   c-bairro   = 'AREA INDUSTRIAL'
                   c-cidade   = 'SAO JOSE'.
         ELSE
            ASSIGN c-endereco = /*(IF ttendereco.TipoLogradouro = 'Nenhum' THEN '' ELSE ttendereco.TipoLogradouro + ' ')*/
                                   REPLACE(ttendereco.Logradouro,"-"," ") + ', '
                                 + ttendereco.Numero + ' - '
                                 + ttendereco.complemento
                   c-endereco = fn-free-accent(UPPER(TRIM(c-endereco)))
                   c-bairro   = fn-free-accent(UPPER(TRIM(string(ttendereco.Bairro, 'x(30)'))))
                   c-cidade   = fn-free-accent(UPPER(TRIM(string(ttendereco.municipio, 'x(25)')))).
         
         /** Incidente 15789 **/
         IF NOT CAN-FIND(first cep
                         WHERE cep.cep = int(ttendereco.CEP)) THEN do:
            RUN incluiMsgErro in THIS-PROCEDURE ("Cliente", 2000, 'CNPJ/CPF ' + tt-emitente.cgc +  ', Erro: CEP ' + ttendereco.CEP + ' informado n∆o existe no cadastro dos Correios').
            RETURN "NOK".
         END.

         FIND FIRST emitente NO-LOCK
              WHERE emitente.cgc = c-cgc NO-ERROR.

         IF NOT AVAIL emitente OR (AVAIL emitente AND emitente.natureza = 1) THEN
             ASSIGN tt-emitente.bairro         = c-bairro                    
                    tt-emitente.cidade         = c-cidade
                    tt-emitente.estado         = UPPER(TRIM(ttendereco.siglaEstado))
                    tt-emitente.cep            = ttendereco.CEP
                    tt-emitente.pais           = c-pais
                    tt-emitente.endereco       = c-endereco
                    tt-emitente.e-mail         = fn-free-accent(lower(c-email)).
         
         RUN pi-gerar-dados-extrato ("> c-endereco: " + string(c-endereco)).
         RUN pi-gerar-dados-extrato ("> ttendereco.tipo: " + string(ttendereco.tipo)).
         RUN pi-gerar-dados-extrato ("> i-ind-tipo-movto: " + string(i-ind-tipo-movto)).

         IF  AVAIL emitente THEN
             RUN pi-gerar-dados-extrato ("emitente.enderec: " + string(tt-emitente.endereco)).
         
         FOR EACH ttTelefone:
             IF  ttTelefone.tipo = "Residencial" THEN
                 ASSIGN c-telefone-1 = ttTelefone.ddd + ttTelefone.telefone.
             ELSE
                 ASSIGN c-telefone-2 = ttTelefone.ddd + ttTelefone.telefone.
         END.   
         IF  c-telefone-1 = ""  THEN
             ASSIGN c-telefone-1 = c-telefone-2
                    c-telefone-2 = "".

         IF AVAIL emitente AND emitente.natureza = 1 THEN
             ASSIGN tt-emitente.telefone[1]    = c-Telefone-1
                    tt-emitente.telefone[2]    = c-Telefone-2
                    tt-emitente.telefone[1]    = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(tt-emitente.telefone[1],"/",""),"-",""),"(",""),")","")," ","")
                    tt-emitente.telefone[2]    = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(tt-emitente.telefone[2],"/",""),"-",""),"(",""),")","")," ","").

         CREATE tt-loc-entr.
         ASSIGN tt-loc-entr.nome-abrev     = tt-emitente.nome-abrev
                tt-loc-entr.cod-entrega    = 'VTEX'.
         ASSIGN
                tt-loc-entr.endereco       = c-endereco
                tt-loc-entr.bairro         = c-bairro
                tt-loc-entr.cidade         = c-cidade
                tt-loc-entr.estado         = UPPER(ttendereco.siglaEstado)
                tt-loc-entr.cep            = ttendereco.CEP
                tt-loc-entr.caixa-postal   = ''
                tt-loc-entr.pais           = c-pais
                tt-loc-entr.cgc            = tt-emitente.cgc
                tt-loc-entr.ins-estadual   = IF tt-emitente.ins-estadual = "ISENTO" THEN "" ELSE tt-emitente.ins-estadual
                tt-loc-entr.e-mail         = fn-free-accent(lower(c-email))
                tt-loc-entr.ind-tipo-movto = i-ind-tipo-movto. /** 1-Inclui 2-ModIFica 3-Exclui **/
         
         RUN pi-gerar-dados-extrato ("tt-loc-entr.ind-tipo-movto: " + string(tt-loc-entr.ind-tipo-movto)).
         RUN pi-gerar-dados-extrato ("tt-loc-entr.endereco: " + string(tt-loc-entr.endereco)).
         RUN pi-gerar-dados-extrato ("tt-loc-entr.bairro: " + string(tt-loc-entr.bairro)).
         RUN pi-gerar-dados-extrato ("tt-loc-entr.estado: " + string(tt-loc-entr.estado)).
         RUN pi-gerar-dados-extrato ("tt-loc-entr.cep: " + string(tt-loc-entr.cep)).
         RUN pi-gerar-dados-extrato ("tt-loc-entr.pais: " + string(tt-loc-entr.pais)).

         FIND transporte NO-LOCK
            WHERE transporte.cod-transp = gr-cli.cod-transp NO-ERROR.
         
         IF NOT available (transporte) THEN
             ASSIGN tt-loc-entr.nome-transp = "SEDEX"
                    tt-loc-entr.nom-cidad-cIF  = string(tt-loc-entr.cidade,'x(25)').
         ELSE IF transporte.nome-abrev = "" THEN
                 ASSIGN tt-loc-entr.nome-transp = "SEDEX"
                        tt-loc-entr.nom-cidad-cIF  = string(tt-loc-entr.cidade,'x(25)').
             ELSE
                ASSIGN tt-loc-entr.nome-transp = string(transporte.nome-abrev,'x(12)')
                       tt-loc-entr.nom-cidad-cIF  = string(tt-loc-entr.cidade,'x(25)').
         
         IF (length(c-endereco) > 40) THEN do:
            CREATE tt-int-loc-entr.
            ASSIGN tt-int-loc-entr.nome-abrev        = tt-emitente.nome-abrev
                   tt-int-loc-entr.cod-entrega       = tt-loc-entr.cod-entrega
                   tt-int-loc-entr.endereco-completo = c-endereco.
            /*RUN incluiMsgErro in THIS-PROCEDURE ("Cliente", 2010, 'CNPJ/CPF ' + tt-emitente.cgc +  ', Erro: local de entrega do cliente maior que 40 caracteres - Revise no CD0705, Emitente: ' + string(tt-emitente.cod-emitente)).*/
         END.

     
         IF NOT CAN-FIND(FIRST bloc-entr
                         WHERE bloc-entr.nome-abrev     = tt-emitente.nome-abrev
                           AND bloc-entr.cod-entrega    = 'Padr∆o') THEN DO:
             CREATE tt-loc-entr.
             ASSIGN tt-loc-entr.nome-abrev     = tt-emitente.nome-abrev
                    tt-loc-entr.cod-entrega    = 'Padr∆o'.
             ASSIGN
                    tt-loc-entr.endereco       = c-endereco
                    tt-loc-entr.bairro         = c-bairro
                    tt-loc-entr.cidade         = c-cidade
                    tt-loc-entr.estado         = UPPER(ttendereco.siglaEstado)
                    tt-loc-entr.cep            = ttendereco.CEP
                    tt-loc-entr.caixa-postal   = ''
                    tt-loc-entr.pais           = c-pais
                    tt-loc-entr.cgc            = tt-emitente.cgc
                    tt-loc-entr.ins-estadual   = IF tt-emitente.ins-estadual = "ISENTO" THEN "" ELSE tt-emitente.ins-estadual
                    tt-loc-entr.e-mail         = fn-free-accent(lower(c-email))
                    tt-loc-entr.ind-tipo-movto = 1. /** 1-Inclui 2-ModIFica 3-Exclui **/
             
             RUN pi-gerar-dados-extrato ("tt-loc-entr.ind-tipo-movto: " + string(tt-loc-entr.ind-tipo-movto)).
             RUN pi-gerar-dados-extrato ("tt-loc-entr.endereco: " + string(tt-loc-entr.endereco)).
             RUN pi-gerar-dados-extrato ("tt-loc-entr.bairro: " + string(tt-loc-entr.bairro)).
             RUN pi-gerar-dados-extrato ("tt-loc-entr.estado: " + string(tt-loc-entr.estado)).
             RUN pi-gerar-dados-extrato ("tt-loc-entr.cep: " + string(tt-loc-entr.cep)).
             RUN pi-gerar-dados-extrato ("tt-loc-entr.pais: " + string(tt-loc-entr.pais)).
    
             FIND transporte NO-LOCK
                WHERE transporte.cod-transp = gr-cli.cod-transp NO-ERROR.
             
             IF NOT available (transporte) THEN
                 ASSIGN tt-loc-entr.nome-transp = "SEDEX"
                        tt-loc-entr.nom-cidad-cIF  = string(tt-loc-entr.cidade,'x(25)').
             ELSE IF transporte.nome-abrev = "" THEN
                     ASSIGN tt-loc-entr.nome-transp = "SEDEX"
                            tt-loc-entr.nom-cidad-cIF  = string(tt-loc-entr.cidade,'x(25)').
                 ELSE
                    ASSIGN tt-loc-entr.nome-transp = string(transporte.nome-abrev,'x(12)')
                           tt-loc-entr.nom-cidad-cIF  = string(tt-loc-entr.cidade,'x(25)').
             
             IF (length(c-endereco) > 40) THEN do:
                CREATE tt-int-loc-entr.
                ASSIGN tt-int-loc-entr.nome-abrev        = tt-emitente.nome-abrev
                       tt-int-loc-entr.cod-entrega       = tt-loc-entr.cod-entrega
                       tt-int-loc-entr.endereco-completo = c-endereco.
                /*RUN incluiMsgErro in THIS-PROCEDURE ("Cliente", 2010, 'CNPJ/CPF ' + tt-emitente.cgc +  ', Erro: local de entrega do cliente maior que 40 caracteres - Revise no CD0705, Emitente: ' + string(tt-emitente.cod-emitente)).*/
             END.
         END.
     END. /** for each ttendereco **/

     FOR LAST ttendereco:
         IF  ttendereco.tipo = 'Principal' THEN 
             ASSIGN tt-emitente.cgc-cob        = ''
                    tt-emitente.estado-cob     = tt-emitente.estado
                    tt-emitente.cidade-cob     = tt-emitente.cidade
                    tt-emitente.bairro-cob     = tt-emitente.bairro
                    tt-emitente.endereco-cob   = tt-emitente.endereco
                    tt-emitente.cep-cob        = tt-emitente.cep
                    tt-emitente.pais-cob       = tt-emitente.pais.

         RUN pi-gerar-dados-extrato ("> tt-emitente.estado-cob: " + string(tt-emitente.estado-cob)).
     END.

     RUN pi-gerar-dados-extrato ("antes tt-emitente.endereco: " + string(tt-emitente.endereco)).
     RUN pi-gerar-dados-extrato ("antes tt-emitente.cidade: " + string(tt-emitente.cidade)).

END PROCEDURE.

PROCEDURE pi-atualiza-pessoa:

    DEFINE INPUT PARAM i-ind-tipo-movto       AS INTEGER     NO-UNDO.

    create tt-versao-integr.
    assign tt-versao-integr.cod-versao-integracao = 001.

     /** Faz chamada Ö API de integraá∆o ***/
     /** Com gambiarra para o CRM **/
     /** Enviando uma temp-table de local de entrega vazia **/
     RUN cdp/cdapi329.p (INPUT  table tt-versao-integr,
                         OUTPUT table tt-erros-geral,
                         INPUT  table tt-emitente,
                         INPUT  table tt-loc-entr-aux,
                         INPUT  table tt-dist-emitente). 

     FIND FIRST tt-emitente NO-ERROR.

     RUN pi-gerar-dados-extrato ("ap¢s cdapi329.p RETURN-VALUE: " + string(RETURN-VALUE)).

     /** Trata erros da API **/
     IF CAN-FIND(first tt-erros-geral) THEN do:
        for each tt-erros-geral:
           RUN pi-gerar-dados-extrato ("TEM tt-erros-geral").
           RUN incluiMsgErro in THIS-PROCEDURE ("Cliente", tt-erros-geral.cod-erro, 'CNPJ/CPF ' + tt-emitente.cgc +  ', Erro: ' + tt-erros-geral.des-erro).
        END.
        RETURN "NOK".
     END.
     ELSE do:
        RUN pi-gerar-dados-extrato ("N«O TEM tt-erros-geral").

        IF CAN-FIND (first tt-loc-entr) THEN do:
           /** Faz nova chamada Ö API de integraá∆o ***/
           /** Com gambiarra para o CRM **/
           /** A gambiarra Ç devido Ö trigger de loc-entr disparar antes da trigger de emitente, causANDo erro no CRM **/
           ASSIGN tt-emitente.ind-tipo-movto = 2. /** ModIFicaá∆o, indepENDente de ter sido modIFicado ou inserido **/

           FIND FIRST loc-entr NO-LOCK
                WHERE loc-entr.nome-abrev     = tt-emitente.nome-abrev  
                  AND loc-entr.cod-entrega    = 'VTEX' NO-ERROR.               

           IF  AVAIL loc-entr THEN DO:
               RUN pi-gerar-dados-extrato ("depois da primeira cdapi329.p"). 
               RUN pi-gerar-dados-extrato ("loc-entr.endereco: " + string(loc-entr.endereco)).
               RUN pi-gerar-dados-extrato ("loc-entr.bairro: " + string(loc-entr.bairro)).
               RUN pi-gerar-dados-extrato ("loc-entr.estado: " + string(loc-entr.estado)).
               RUN pi-gerar-dados-extrato ("loc-entr.cep: " + string(loc-entr.cep)).
               RUN pi-gerar-dados-extrato ("loc-entr.pais: " + string(loc-entr.pais)).
           END.

           RUN cdp/cdapi329.p (INPUT  table tt-versao-integr,
                               OUTPUT table tt-erros-geral,
                               INPUT  table tt-emitente,
                               INPUT  table tt-loc-entr,
                               INPUT  table tt-dist-emitente). 


           FIND FIRST loc-entr NO-LOCK
                WHERE loc-entr.nome-abrev     = tt-emitente.nome-abrev  
                  AND loc-entr.cod-entrega    = 'VTEX' NO-ERROR.  

           IF  AVAIL loc-entr THEN DO:
               RUN pi-gerar-dados-extrato ("depois da segunda cdapi329.p"). 
               RUN pi-gerar-dados-extrato ("loc-entr.endereco: " + string(loc-entr.endereco)).
               RUN pi-gerar-dados-extrato ("loc-entr.bairro: " + string(loc-entr.bairro)).
               RUN pi-gerar-dados-extrato ("loc-entr.estado: " + string(loc-entr.estado)).
               RUN pi-gerar-dados-extrato ("loc-entr.cep: " + string(loc-entr.cep)).
               RUN pi-gerar-dados-extrato ("loc-entr.pais: " + string(loc-entr.pais)).
           END.

           IF CAN-FIND(first tt-erros-geral) THEN do:
              for each tt-erros-geral:
                 RUN incluiMsgErro in THIS-PROCEDURE ("Cliente segunda chamada", tt-erros-geral.cod-erro,'CNPJ/CPF ' + tt-emitente.cgc + ': ' + tt-erros-geral.des-erro).
              END.
              RETURN "NOK".
           END.
        END.

        FIND emitente NO-LOCK
            WHERE emitente.cod-emitente = tt-emitente.cod-emitente NO-ERROR.
        
        RUN pi-gerar-dados-extrato ("depois emitente.endereco: " + string(emitente.endereco)).
        RUN pi-gerar-dados-extrato ("depois emitente.cidade: " + string(emitente.cidade)).

        /*Suspender o pedido se o endereáo do cliente difere da entrega (ainda verifica essa vari†vel na implantaá∆o do pedido. Caso seja loja <> de 1, a° suspende */
        FIND FIRST tt-loc-entr NO-ERROR.
        IF  AVAIL tt-loc-entr AND
           (    emitente.endereco <> tt-loc-entr.endereco
            OR  emitente.bairro   <> tt-loc-entr.bairro
            OR  emitente.cidade   <> tt-loc-entr.cidade  
            OR  emitente.estado   <> tt-loc-entr.estado  
            OR  emitente.cep      <> tt-loc-entr.cep     
            OR  emitente.pais     <> tt-loc-entr.pais)  THEN
            ASSIGN l-suspender-pedido = YES.
        

        /** Atualiza o ENDereáo completo, caso necess†rio **/
        for each tt-int-loc-entr NO-LOCK:
           FIND FIRST int-loc-entr NO-LOCK
                WHERE int-loc-entr.nome-abrev  = tt-int-loc-entr.nome-abrev
                  AND int-loc-entr.cod-entrega = tt-int-loc-entr.cod-entrega NO-ERROR.
           if not available (int-loc-entr) then do:
              CREATE int-loc-entr.
              ASSIGN int-loc-entr.nome-abrev  = tt-int-loc-entr.nome-abrev
                     int-loc-entr.cod-entrega = tt-int-loc-entr.cod-entrega
                     int-loc-entr.endereco-completo = tt-int-loc-entr.endereco-completo.
           END.
           ELSE DO:
               FIND CURRENT int-loc-entr EXCLUSIVE-LOCK NO-ERROR.
               ASSIGN int-loc-entr.endereco-completo = tt-int-loc-entr.endereco-completo.
               FIND CURRENT int-loc-entr NO-LOCK NO-ERROR.
               RELEASE int-loc-entr.
           END.
        END.

        FIND FIRST int-emitente NO-LOCK
             WHERE int-emitente.cod-emitente = tt-emitente.cod-emitente NO-ERROR.
        IF AVAIL int-emitente THEN DO:
            FIND CURRENT int-emitente EXCLUSIVE-LOCK NO-ERROR.
            ASSIGN int-emitente.id-ativo = yes.
            FIND CURRENT int-emitente NO-LOCK NO-ERROR.
            RELEASE int-emitente.
        END.
    END.    

    RETURN "OK".
END.

procedure incluiMsgErro:
   DEFINE INPUT PARAMETER pDetalhe  AS CHAR    NO-UNDO.
   DEFINE INPUT PARAMETER pCodigo   AS INTEGER NO-UNDO.
   DEFINE INPUT PARAMETER pDescErro AS CHAR    NO-UNDO.

   DEFINE VARIABLE iNEXTMsg as INTEGER NO-UNDO.

   FIND LAST ttErro NO-LOCK NO-ERROR.
   IF AVAIL ttErro THEN
      ASSIGN iNEXTMsg = ttErro.SeqErro + 1.
   ELSE
      ASSIGN iNEXTMsg = 1.

   CREATE ttErro.
   ASSIGN ttErro.SeqErro       = iNEXTMsg
          ttErro.detalhe       = pDetalhe
          ttErro.codigoErro    = pCodigo
          ttErro.mensagem      = pDescErro.
END PROCEDURE.

PROCEDURE pi-gera-parcelamento:
    DEF VAR da-data-base   AS DATE    NO-UNDO.
    DEF VAR de-sum         AS DEC     NO-UNDO.
    DEF VAR de-vl-parcela  AS DEC     NO-UNDO.
    DEF VAR i-sequencia    AS INTEGER NO-UNDO.
    DEF VAR de-perc        AS DEC     NO-UNDO.
    DEF VAR de-tot-perc    AS DEC     NO-UNDO.
    DEF VAR de-valor-total AS DEC     NO-UNDO.
    DEF VAR vl-cupom       AS DEC INITIAL 0 NO-UNDO.
    DEF VAR de-perc-cupom  AS DEC INITIAL 0 NO-UNDO.
    
    DEF VAR i AS INTEGER NO-UNDO.

    FOR EACH ttCondicaoPagamento:
        ASSIGN da-data-base = ttCondicaoPagamento.dataCaptura
               i-sequencia  = 10.

        IF ttCondicaoPagamento.formaPagamento = "0.0" THEN
            ASSIGN ttCondicaoPagamento.formaPagamento = "0".

        EMPTY TEMP-TABLE tt-prog-ponto.
        RUN esp/es0018p.p (INPUT "wsO0003":U, INPUT 10, INPUT 0, INPUT "":U, OUTPUT TABLE tt-prog-ponto).

        FIND FIRST tt-prog-ponto
             WHERE ENTRY(1,tt-prog-ponto.conteudo,";") = ttPedido.statusPedido NO-ERROR.
        IF AVAIL tt-prog-ponto THEN
            ASSIGN vl-cupom = DEC(ENTRY(2,tt-prog-ponto.conteudo,";")).

        IF vl-cupom <> 0 THEN
            ASSIGN de-valor-total = ttCondicaoPagamento.valorTotal - vl-cupom
                   de-perc-cupom  = vl-cupom / ttCondicaoPagamento.valorTotal * 100.
        ELSE
            ASSIGN de-valor-total = ttCondicaoPagamento.valorTotal.

        CASE ttCondicaoPagamento.formaPagamento:
            /* BOLETO */
            WHEN "Boleto Banc†rio" THEN DO:
                 CREATE tt-cond-ped.
                 ASSIGN tt-cond-ped.nr-pedido     = tt-ped-venda.nr-pedido
                        tt-cond-ped.nr-sequencia  = i-sequencia
                        tt-cond-ped.data-pagto    = da-data-base + 10
                        tt-cond-ped.cod-vencto    = 2 /* ∑ vista */
                        tt-cond-ped.nr-dias-venc  = 0
                        tt-cond-ped.vl-pagto      = de-valor-total
                        tt-cond-ped.perc-pagto    = 100 - de-perc-cupom
                        tt-cond-ped.observacoes   = "Marketplace:"     + ttPedido.marketplace + CHR(10) +
                                                    "Forma pagto:"     + "BOLETO" + CHR(10) +
                                                    "Final Cart∆o:..." + STRING(ttCondicaoPagamento.finalCartao) + CHR(10) +
                                                    "ID Autoriz:"      + ttCondicaoPagamento.idAutorizacao + CHR(10) +
                                                    "NSU:"             + ttCondicaoPagamento.nsu + CHR(10) +
                                                    "Desconto Marketplace:" + STRING(ROUND(ttPedido.descontoMarketplace,2)) + CHR(10) +
                                                    "Status:" + STRING(ttPedido.statusPedido).
                                                                            

                 /*ASSIGN d-sum = d-sum + cond-ped.vl-pagto.*/
                 ASSIGN i-sequencia = i-sequencia + 10.

            END.
            /* BOLETO */
            WHEN "BOLETO" THEN DO:
                 CREATE tt-cond-ped.
                 ASSIGN tt-cond-ped.nr-pedido     = tt-ped-venda.nr-pedido
                        tt-cond-ped.nr-sequencia  = i-sequencia
                        tt-cond-ped.data-pagto    = da-data-base + 10
                        tt-cond-ped.cod-vencto    = 2 /* ∑ vista */
                        tt-cond-ped.nr-dias-venc  = 0
                        tt-cond-ped.vl-pagto      = de-valor-total
                        tt-cond-ped.perc-pagto    = 100 - de-perc-cupom
                        tt-cond-ped.observacoes   = "Marketplace:"     + ttPedido.marketplace + CHR(10) +
                                                    "Forma pagto:"     + "BOLETO" + CHR(10) +
                                                    "Final Cart∆o:..." + STRING(ttCondicaoPagamento.finalCartao) + CHR(10) +
                                                    "ID Autoriz:"      + ttCondicaoPagamento.idAutorizacao + CHR(10) +
                                                    "NSU:"             + ttCondicaoPagamento.nsu + CHR(10) +
                                                    "Desconto Marketplace:" + STRING(ROUND(ttPedido.descontoMarketplace,2)) + CHR(10) +
                                                    "Status:" + STRING(ttPedido.statusPedido).
                                                                            

                 /*ASSIGN d-sum = d-sum + cond-ped.vl-pagto.*/
                 ASSIGN i-sequencia = i-sequencia + 10.

            END.
            /* MARKETPLACE */
            WHEN "0" THEN DO:

                IF ttPedido.marketplace <> "VVT" THEN DO:
                
                    FIND FIRST int-pedido-param-pagto NO-LOCK
                         WHERE int-pedido-param-pagto.marketplace = TRIM(ttPedido.marketplace)
                           AND int-pedido-param-pagto.loja        = ttPedido.codigoLoja
                           AND int-pedido-param-pagto.forma-pagto = "0" NO-ERROR.
                    IF AVAIL int-pedido-param-pagto THEN DO:
    
                        CREATE tt-cond-ped.
                        ASSIGN tt-cond-ped.nr-pedido     = tt-ped-venda.nr-pedido
                               tt-cond-ped.nr-sequencia  = i-sequencia
                               tt-cond-ped.data-pagto    = da-data-base + int-pedido-param-pagto.dias-venc
                               tt-cond-ped.cod-vencto    = 2 /* ∑ vista */
                               tt-cond-ped.nr-dias-venc  = 0
                               tt-cond-ped.vl-pagto      = de-valor-total
                               tt-cond-ped.perc-pagto    = 100 - de-perc-cupom
                               tt-cond-ped.observacoes   = "Marketplace:"     + ttPedido.marketplace + CHR(10) +
                                                           "Forma pagto:"     + ttCondicaoPagamento.formaPagamento + CHR(10) +
                                                           "Final Cart∆o:..." + STRING(ttCondicaoPagamento.finalCartao) + CHR(10) +
                                                           "ID Autoriz:"      + ttCondicaoPagamento.idAutorizacao + CHR(10) +
                                                           "NSU:"             + ttCondicaoPagamento.nsu + CHR(10) +
                                                           "Desconto Marketplace:" + STRING(ROUND(ttPedido.descontoMarketplace,2)) + CHR(10) +
                                                           "Status:" + STRING(ttPedido.statusPedido).
    
    
                                            
                        ASSIGN i-sequencia = i-sequencia + 10.
    
                    END.
                END.
                ELSE DO:
                    ASSIGN de-vl-parcela = TRUNCATE(de-valor-total / ttCondicaoPagamento.quantidadeParcelas, 2).
                           de-perc       = TRUNCATE((de-vl-parcela / (de-valor-total + vl-cupom)) * 100, 2).

                    DO  i = 1 TO ttCondicaoPagamento.quantidadeParcelas:
                        ASSIGN da-data-base = da-data-base + 30.
    
                        CREATE tt-cond-ped.
                        ASSIGN tt-cond-ped.nr-pedido     = tt-ped-venda.nr-pedido 
                               tt-cond-ped.nr-sequencia  = i-sequencia
                               tt-cond-ped.data-pagto    = da-data-base 
                               tt-cond-ped.cod-vencto    = 2 /* ∑ vista */
                               tt-cond-ped.nr-dias-venc  = 0
                               tt-cond-ped.vl-pagto      = de-vl-parcela
                               tt-cond-ped.perc-pagto    = de-perc
                               tt-cond-ped.observacoes   = "Marketplace:"     + ttPedido.marketplace + CHR(10) +
                                                           "Forma pagto:"     + ttCondicaoPagamento.formaPagamento + CHR(10) +
                                                           "Final Cart∆o:..." + STRING(ttCondicaoPagamento.finalCartao) + CHR(10) +
                                                           "ID Autoriz:"      + ttCondicaoPagamento.idAutorizacao + CHR(10) +
                                                           "NSU:"             + ttCondicaoPagamento.nsu + CHR(10) +
                                                           "Desconto Marketplace:" + STRING(ROUND(ttPedido.descontoMarketplace,2)) + CHR(10) +
                                                           "Status:" + STRING(ttPedido.statusPedido).
    
                        ASSIGN de-sum      = de-sum + de-vl-parcela
                               de-tot-perc = de-tot-perc + de-perc
                               
                               i-sequencia = i-sequencia + 10.
                    END.
                    
                    IF  de-sum < (de-valor-total)  THEN DO:
                        FOR FIRST tt-cond-ped
                            BY tt-cond-ped.nr-sequencia DESC:
                            ASSIGN tt-cond-ped.vl-pagto = tt-cond-ped.vl-pagto + (de-valor-total - de-sum).
                            
                        END.
                    END.
    
                    IF  de-tot-perc < 100 THEN DO:
                        FOR LAST tt-cond-ped
                            BY tt-cond-ped.nr-sequencia DESC:
                            ASSIGN tt-cond-ped.perc-pagto = tt-cond-ped.perc-pagto + (100 - de-perc-cupom - de-tot-perc).
                        END.
                    END.

                END.
            END.
            OTHERWISE DO:

                ASSIGN de-vl-parcela = TRUNCATE(de-valor-total / ttCondicaoPagamento.quantidadeParcelas, 2).
                       de-perc       = TRUNCATE((de-vl-parcela / (de-valor-total + vl-cupom)) * 100, 2).

                DO  i = 1 TO ttCondicaoPagamento.quantidadeParcelas:
                    ASSIGN da-data-base = da-data-base + 30.

                    CREATE tt-cond-ped.
                    ASSIGN tt-cond-ped.nr-pedido     = tt-ped-venda.nr-pedido 
                           tt-cond-ped.nr-sequencia  = i-sequencia
                           tt-cond-ped.data-pagto    = da-data-base 
                           tt-cond-ped.cod-vencto    = 2 /* ∑ vista */
                           tt-cond-ped.nr-dias-venc  = 0
                           tt-cond-ped.vl-pagto      = de-vl-parcela
                           tt-cond-ped.perc-pagto    = de-perc
                           tt-cond-ped.observacoes   = "Marketplace:"     + ttPedido.marketplace + CHR(10) +
                                                       "Forma pagto:"     + ttCondicaoPagamento.formaPagamento + CHR(10) +
                                                       "Final Cart∆o:..." + STRING(ttCondicaoPagamento.finalCartao) + CHR(10) +
                                                       "ID Autoriz:"      + ttCondicaoPagamento.idAutorizacao + CHR(10) +
                                                       "NSU:"             + ttCondicaoPagamento.nsu + CHR(10) +
                                                       "Desconto Marketplace:" + STRING(ROUND(ttPedido.descontoMarketplace,2)) + CHR(10) +
                                                       "Status:" + STRING(ttPedido.statusPedido).

                    ASSIGN de-sum      = de-sum + de-vl-parcela
                           de-tot-perc = de-tot-perc + de-perc
                           
                           i-sequencia = i-sequencia + 10.
                END.
                
                IF  de-sum < (de-valor-total)  THEN DO:
                    FOR FIRST tt-cond-ped
                        BY tt-cond-ped.nr-sequencia DESC:
                        ASSIGN tt-cond-ped.vl-pagto = tt-cond-ped.vl-pagto + (de-valor-total - de-sum).
                        
                    END.
                END.
                
                IF  de-tot-perc < 100 THEN DO:
                    FOR LAST tt-cond-ped
                        BY tt-cond-ped.nr-sequencia DESC:
                        ASSIGN tt-cond-ped.perc-pagto = tt-cond-ped.perc-pagto + (100 - de-perc-cupom - de-tot-perc).
                    END.
                END.
                
            END.
        END.

        IF vl-cupom <> 0 THEN DO:

            CREATE tt-cond-ped.
            ASSIGN tt-cond-ped.nr-pedido     = tt-ped-venda.nr-pedido 
                   tt-cond-ped.nr-sequencia  = i-sequencia
                   tt-cond-ped.data-pagto    = TODAY
                   tt-cond-ped.cod-vencto    = 2 /* ∑ vista */
                   tt-cond-ped.nr-dias-venc  = 0
                   tt-cond-ped.vl-pagto      = vl-cupom
                   tt-cond-ped.perc-pagto    = de-perc-cupom
                   tt-cond-ped.observacoes   = "Marketplace:"     + ttPedido.marketplace + CHR(10) +
                                               "Forma pagto:"     + "CUPOM" + CHR(10) +
                                               "Final Cart∆o:..." + STRING(ttCondicaoPagamento.finalCartao) + CHR(10) +
                                               "ID Autoriz:"      + ttCondicaoPagamento.idAutorizacao + CHR(10) +
                                               "NSU:"             + ttCondicaoPagamento.nsu + CHR(10) +
                                               "Desconto Marketplace:" + STRING(ROUND(ttPedido.descontoMarketplace,2)) + CHR(10) +
                                               "Status:" + STRING(ttPedido.statusPedido).

            ASSIGN i-sequencia = i-sequencia + 10.
        END. 
    END.

END PROCEDURE.

PROCEDURE UpdateSuspension:

    IF  ped-venda.observacoes <> "" AND
        ped-venda.cod-priori <> 44  AND 
        ped-venda.cod-priori <> 3 THEN DO:
        FIND CURRENT ped-venda EXCLUSIVE-LOCK NO-ERROR.

        for each ped-item of ped-venda
                where ped-item.cod-sit-item <= 2 exclusive-lock:
    
                for each ped-ent of ped-item
                    where ped-ent.cod-sit-ent <= 2 exclusive-lock:
    
                    assign ped-ent.cod-sit-ent  = 5
                           ped-ent.dt-suspensao = today
                           ped-ent.user-susp    = "Integra"
                           ped-ent.dt-usersusp  = today.
                end.

                assign ped-item.dt-suspensao = today
                       ped-item.user-susp    = "Integra"
                       ped-item.dt-usersusp  = today
                       ped-item.cod-sit-item = 5.
        end.
    
        assign ped-venda.dt-suspensao = today
               ped-venda.user-susp    = "Integra"
               ped-venda.dt-usersusp  = today
               ped-venda.desc-suspend = ped-venda.observacoes
               ped-venda.dt-useralt   = TODAY 
               ped-venda.user-alt     = "Integra"
               ped-venda.cod-sit-ped  = 5.
        
        IF NOT ped-venda.observacoes MATCHES "*composto*" THEN
            ASSIGN ped-venda.cod-priori = 99.
        
        RELEASE ped-item.
    END.
END PROCEDURE.

PROCEDURE pi-cria-historico:
    DEFINE VARIABLE c-hota-integr  AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE d-data-integr  AS DATE        NO-UNDO.
    DEFINE BUFFER b-int-ocorrencias-vtex FOR int-ocorrencias-vtex.

    FOR FIRST ttPedido:
        
        /*Buscar n£mero pedido espec°fico para n∆o gerar a int-pedido-vtex*/
        EMPTY TEMP-TABLE tt-prog-ponto.
        RUN esp/es0018p.p (INPUT "wsO0003":U, INPUT 4, INPUT 0, INPUT "":U, OUTPUT TABLE tt-prog-ponto).
        FIND FIRST tt-prog-ponto NO-ERROR.
        IF  AVAIL tt-prog-ponto THEN 
            ASSIGN c-pedido-espec-es0018 = tt-prog-ponto.conteudo.
        RUN pi-gerar-dados-extrato ("> pi-cria-historico -> c-pedido-espec-es0018: " + string(c-pedido-espec-es0018)).
        RUN pi-gerar-dados-extrato ("> pi-cria-historico -> ttPedido.numeroPedido: " + string(ttPedido.numeroPedido)).
        
        IF  c-pedido-espec-es0018 = ttPedido.numeroPedido THEN
            RETURN.

        ASSIGN d-data-integr  = TODAY
               c-hota-integr  = STRING(TIME,"HH:MM:SS").

        FIND FIRST ttCondicaoPagamento NO-ERROR.
        FIND LAST  ttTelefone          NO-ERROR.
        FIND LAST  ttEmail             NO-ERROR.
        FIND LAST  ttEndereco          NO-ERROR.

        FIND FIRST int-pedido-vtex EXCLUSIVE-LOCK
             WHERE int-pedido-vtex.nr-pedido      = ttPedido.numeroPedido
               AND int-pedido-vtex.seq-pedido     = ttPedido.sequenciaPedido
               AND int-pedido-vtex.dt-integracao  = d-data-integr
               AND int-pedido-vtex.hr-integracao  = c-hota-integr NO-ERROR.
        IF NOT AVAIL int-pedido-vtex THEN DO:
            CREATE int-pedido-vtex.
            ASSIGN int-pedido-vtex.nr-pedido      = ttPedido.numeroPedido
                   int-pedido-vtex.seq-pedido     = ttPedido.sequenciaPedido
                   int-pedido-vtex.dt-integracao  = d-data-integr
                   int-pedido-vtex.hr-integracao  = c-hota-integr
                   int-pedido-vtex.cod-loja       = ttPedido.codigoLoja
                   int-pedido-vtex.marketplace    = ttPedido.marketplace
                   int-pedido-vtex.dt-criacao     = ttPedido.dataCriacao
                   /*int-pedido-vtex.hr-criacao     = SUBSTRING(c-data-criacao,12,8)*/
                   int-pedido-vtex.vl-tot-itens   = ttPedido.totalItens
                   int-pedido-vtex.vl-tot-pedido  = ttPedido.totalPedido
                   int-pedido-vtex.vl-tot-frete   = ttPedido.totalFrete
                   int-pedido-vtex.vl-tot-desc    = ttPedido.totalDesconto
                   int-pedido-vtex.reference-number = IF AVAIL ttCondicaoPagamento THEN ttCondicaoPagamento.numeroReferencia ELSE ""
                   int-pedido-vtex.tid              = IF AVAIL ttCondicaoPagamento THEN ttCondicaoPagamento.tid ELSE ""
                   int-pedido-vtex.dt-pagto       = TODAY.
                   /*int-pedido-vtex.mo-codigo      = int(ttPedido.moedaCorrente)*/.
        END.

        IF AVAIL ttCondicaoPagamento THEN
            ASSIGN int-pedido-vtex.forma-pagto    = ttCondicaoPagamento.formaPagamento
                   int-pedido-vtex.dt-pagto       = ttCondicaoPagamento.dataCaptura
                   /*int-pedido-vtex.hr-pagto       = SUBSTRING(c-data-captura,12,8)*/
                   int-pedido-vtex.qtd-parcelas   = ttCondicaoPagamento.quantidadeParcelas
                   int-pedido-vtex.final-cartao   = string(ttCondicaoPagamento.finalCartao)
                   int-pedido-vtex.id-autorizacao = ttCondicaoPagamento.idAutorizacao
                   int-pedido-vtex.nsu-cartao     = ttCondicaoPagamento.nsu
                   int-pedido-vtex.vl-tot-pagto   = ttCondicaoPagamento.valorTotal.

        IF AVAIL ttTelefone THEN
            ASSIGN int-pedido-vtex.telefone      = ttTelefone.ddd + ttTelefone.telefone
                   int-pedido-vtex.telefone-tipo = ttTelefone.tipo.

        IF AVAIL ttEmail THEN
            ASSIGN int-pedido-vtex.email      = ttEmail.endereco.
                   int-pedido-vtex.email-tipo = ttEmail.tipo.

        IF AVAIL ttEndereco THEN
            ASSIGN int-pedido-vtex.endereco    = REPLACE(ttEndereco.logradouro,"-"," ")
                   int-pedido-vtex.cep         = ttEndereco.cep
                   int-pedido-vtex.bairro      = ttEndereco.bairro
                   int-pedido-vtex.cidade      = ttEndereco.municipio
                   int-pedido-vtex.estado      = ttEndereco.siglaEstado
                   int-pedido-vtex.complemento = ttEndereco.complemento
                   int-pedido-vtex.numero      = ttEndereco.numero
                   int-pedido-vtex.pais        = ttEndereco.siglaPais.

        IF AVAIL ped-venda THEN
            ASSIGN int-pedido-vtex.nr-pedcli    = ped-venda.nr-pedcli.

        IF l-pj THEN DO:
            FOR FIRST ttpessoaJuridica:
                ASSIGN int-pedido-vtex.nome = ttpessoaJuridica.nomeFantasia.
            END.

            FOR FIRST ttDocumento
                WHERE ttDocumento.tipoDocumento = "CNPJ":
                ASSIGN int-pedido-vtex.tipo-docto = ttDocumento.tipoDocumento
                       int-pedido-vtex.num-docto  = ttDocumento.numeroDocumento.
            END.
            FOR FIRST ttDocumento
                WHERE ttDocumento.tipoDocumento = "inscricaoEstadual":
                ASSIGN int-pedido-vtex.ins-estadual = ttDocumento.numeroDocumento.
            END.
        END.
        ELSE DO:
            FOR FIRST ttpessoaFisica:
                ASSIGN int-pedido-vtex.nome = ttpessoaFisica.nome.
            END.

            FOR FIRST ttDocumento
                WHERE ttDocumento.tipoDocumento = "CPF":
                ASSIGN int-pedido-vtex.tipo-docto = ttDocumento.tipoDocumento
                       int-pedido-vtex.num-docto  = ttDocumento.numeroDocumento.
            END.
        END.

        FIND CURRENT int-pedido-vtex NO-LOCK NO-ERROR.
	    RELEASE int-pedido-vtex.

        ASSIGN i-seq-item = 0.
        FOR EACH ttItem:
            ASSIGN i-seq-item = i-seq-item + 10.
            CREATE int-ped-item-vtex.
            ASSIGN int-ped-item-vtex.nr-pedido     = ttPedido.numeroPedido    
                   int-ped-item-vtex.seq-pedido    = ttPedido.sequenciaPedido 
                   int-ped-item-vtex.dt-integracao = d-data-integr
                   int-ped-item-vtex.hr-integracao = c-hota-integr + STRING(i-seq-item)
                   int-ped-item-vtex.it-codigo     = ttItem.codigoItem
                   int-ped-item-vtex.vl-preco-item = ttItem.precoItem
                   int-ped-item-vtex.cod-estabel   = ttItem.estabelecimento
                   int-ped-item-vtex.cod-transp    = int(ttItem.codigoTransportadora)
                   int-ped-item-vtex.quantidade    = ttItem.quantidade
                   int-ped-item-vtex.vl-desc-item  = ttItem.valorDesconto.

            IF ttPedido.marketplace <> "VTEX" THEN DO:

                FIND FIRST int-pedido-param NO-LOCK
                     WHERE int-pedido-param.marketplace = TRIM(ttPedido.marketplace)
                       AND int-pedido-param.loja        = ttPedido.codigoLoja NO-ERROR.
                IF AVAIL int-pedido-param THEN 
                    ASSIGN int-ped-item-vtex.cod-transp = int-pedido-param.cod-transp.

            END.

        END.

        FOR EACH ttComissao:

            RUN pi-gerar-dados-extrato ("> COMISSAO ttComissao.tipo:" + ttComissao.tipo).
            FIND FIRST int-pedido-comissao EXCLUSIVE-LOCK
                 WHERE int-pedido-comissao.nr-pedido    = ttPedido.numeroPedido
                   AND int-pedido-comissao.tipo         = ttComissao.tipo 
                   NO-ERROR.
            IF NOT AVAIL int-pedido-comissao THEN DO:

                RUN pi-gerar-dados-extrato ("> COMISSAO ttComissao.tipo2:" + ttComissao.tipo).
    
                FIND FIRST b-emitente-comis WHERE b-emitente-comis.cgc = ttComissao.numeroDocumento NO-LOCK NO-ERROR.
                
                CREATE int-pedido-comissao.
                ASSIGN int-pedido-comissao.nr-pedido    = ttPedido.numeroPedido
                       int-pedido-comissao.tipo         = ttComissao.tipo
                       int-pedido-comissao.nr-pedcli    = IF AVAIL ped-venda THEN ped-venda.nr-pedcli ELSE ""
                       int-pedido-comissao.num-docto    = ttComissao.numeroDocumento
                       int-pedido-comissao.valor        = ttComissao.valor
                       int-pedido-comissao.cod-emitente = IF AVAIL b-emitente-comis THEN b-emitente-comis.cod-emitente ELSE 0.
    
            END.
        END.

        FOR EACH ttErro:

            FIND LAST b-int-ocorrencias-vtex NO-LOCK
                WHERE b-int-ocorrencias-vtex.nr-pedido     = ttPedido.numeroPedido     
                  AND b-int-ocorrencias-vtex.seq-pedido    = ttPedido.sequenciaPedido  
                  AND b-int-ocorrencias-vtex.dt-integracao = d-data-integr             
                  AND b-int-ocorrencias-vtex.hr-integracao = c-hota-integr NO-ERROR.

            CREATE int-ocorrencias-vtex.
            ASSIGN int-ocorrencias-vtex.nr-pedido     = ttPedido.numeroPedido     
                   int-ocorrencias-vtex.seq-pedido    = ttPedido.sequenciaPedido  
                   int-ocorrencias-vtex.seq-erro      = IF AVAIL b-int-ocorrencias-vtex THEN b-int-ocorrencias-vtex.seq-erro + 1 ELSE 1
                   int-ocorrencias-vtex.dt-integracao = d-data-integr             
                   int-ocorrencias-vtex.hr-integracao = c-hota-integr             
                   int-ocorrencias-vtex.tipo-registro = ttErro.detalhe
                   int-ocorrencias-vtex.cod-erro      = ttErro.codigoErro
                   int-ocorrencias-vtex.descricao     = ttErro.mensagem.
        END.
    END.
END.

PROCEDURE pi-gerar-dados-extrato:
    def input param p-string as char no-undo.
            
    if  c-arquivo-log <> "" and c-arquivo-log <> ? then do:
    
        output to value(c-arquivo-log) append.
             /* Inicio -- Projeto Internacional */
             DEFINE VARIABLE c-lbl-liter-ponto-executado AS CHARACTER FORMAT "X(24)" NO-UNDO.
             {utp/ut-liter.i "Ponto_Executado" *}
             ASSIGN c-lbl-liter-ponto-executado = TRIM(RETURN-VALUE).
             put "     " + c-lbl-liter-ponto-executado + ": " p-string format "x(100)" skip.
        output close. 
    
    end.
END.


PROCEDURE pi-busca-pedido:

       DEFINE OUTPUT PARAM pEnviaCliente AS LOG NO-UNDO.

       FIND FIRST ttpedido NO-ERROR.

       EMPTY TEMP-TABLE tt-prog-ponto.
       RUN esp/es0018p.p (INPUT "wsO0003":U, 
                          INPUT 4, 
                          INPUT 0, 
                          INPUT "":U, 
                          OUTPUT TABLE tt-prog-ponto).
       FIND FIRST tt-prog-ponto NO-ERROR.
       IF  AVAIL tt-prog-ponto THEN 
           ASSIGN c-pedido-espec-es0018-2 = tt-prog-ponto.conteudo.

       IF AVAIL ttPedido THEN DO:
           IF ttPedido.numeroPedido = c-pedido-espec-es0018-2 THEN
               ASSIGN pEnviaCliente = NO.
           ELSE
               ASSIGN pEnviaCliente = YES.

           ASSIGN c-pedido-espec-es0018-2 = ttPedido.numeroPedido.

       END.
       ELSE
           ASSIGN pEnviaCliente = YES.

       RETURN "OK".

END PROCEDURE.

RETURN "OK".
