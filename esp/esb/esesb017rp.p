{include/i-prgvrs.i esesb017rp.p 2.00.00.000}  

{esp/esb/esesb000.i}
{include/i-rpvar.i}

DEFINE VARIABLE h-acomp AS HANDLE     NO-UNDO.

IF  NOT VALID-HANDLE(h-acomp) THEN
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

DEFINE TEMP-TABLE tt-natur-oper LIKE natur-oper.   
DEFINE TEMP-TABLE tt-fam-com-item LIKE fam-com-item.

DEFINE VARIABLE time-ini AS INTEGER     NO-UNDO.
DEFINE VARIABLE time-fim AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-num-itens-calculo AS INTEGER     NO-UNDO.

DEFINE TEMP-TABLE tt-erro           NO-UNDO
    FIELD mensagem AS CHARACTER FORMAT "x(250)".


DEFINE TEMP-TABLE ProdutoItemR NO-UNDO XML-NODE-NAME 'ProdutoItem'
    FIELD idm AS INT XML-NODE-TYPE 'hidden'
    FIELD CodigoProduto            AS CHAR
    FIELD PrecoBase                AS DEC
    FIELD ValorProduto             AS DEC
    FIELD NomePoliticaComercial    AS CHAR
    FIELD TemCache                 AS LOGICAL
    FIELD DataValidade             AS DATE
    FIELD QuantidadeMaxima         AS DEC
    FIELD RebateAntecipado         AS LOGICAL
    FIELD CalcularRebate             AS LOGICAL
    FIELD PrecoAlterado              AS LOGICAL
    FIELD ValorComDesconto           AS DEC
    FIELD PercentualDescontoVerde     AS DEC
    FIELD PercentualDescontoTopMilhao AS DEC
    FIELD PercentualRebateAntecipado  AS DEC.

/*usada para quebrar o calculo de pre»os para n’o estourar o longchar*/
DEFINE TEMP-TABLE ProdutoItemR-temp LIKE ProdutoItemR.

DEFINE NEW GLOBAL SHARED TEMP-TABLE ProdutoItem NO-UNDO XML-NODE-NAME 'ProdutoItem'
    FIELD idm AS INT XML-NODE-TYPE 'hidden'
    FIELD CodigoProduto            AS CHAR
    FIELD Bloqueado                AS LOG
    FIELD Cached                   AS LOG
    FIELD TipoPortfolio            AS INT.  /* 993520000: Box Mover
                                                993520001: VAD
                                                993520002: Exclusivo
                                                993520003: Cross-Selling
                                                993520004: Solu»’o */

DEFINE TEMP-TABLE tt-itens NO-UNDO
    FIELD it-codigo              AS CHAR
    FIELD de-quantidade          AS DEC
    FIELD TipoPortfolio          AS INTEGER
    FIELD CodigoUnidadeNegocio   AS CHAR
    FIELD CodigoFamiliaComercial AS CHAR
    FIELD CodigoEstabelecimento  AS CHAR.

ASSIGN time-ini = TIME.

{esp/esb/out/msg0159.i}

/* tt-param */
{esp/esb/esesb017tt.i}



DEF INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEF INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

/* OUTPUT TO VALUE (SESSION:TEMP-DIRECTORY + "integracao_canais.txt"). */



{include/i-rpout.i}


PUT "Inicio " STRING(TIME,"HH:MM:SS") SKIP.

DEF TEMP-TABLE tt-erro-apb     LIKE tt-erro.
    RUN utp/ut-acomp.p PERSISTEN SET h-acomp.
    RUN pi-inicializar IN h-acomp (INPUT "C lculo Pre‡os.").

FOR EACH emitente NO-LOCK
    WHERE emitente.identific <> 2,
    FIRST int-emitente NO-LOCK
    WHERE int-emitente.cod-emitente = emitente.cod-emitente
    AND   int-emitente.ind-participa-canais = 993520001:

    FOR EACH estabelec NO-LOCK:
        IF estabelec.cod-estabel = "102" OR 
           estabelec.cod-estabel = "106" OR 
           estabelec.cod-estabel = "107" THEN NEXT.
        IF CAN-find(FIRST ped-venda
            WHERE ped-venda.nome-abrev  = emitente.nome-abrev
              AND ped-venda.cod-estabel = estabelec.cod-estabel
              AND (ped-venda.cod-sit-ped < 3 OR
                   ped-venda.cod-sit-ped = 5)) THEN DO:
            PUT "Calculando Canal : " emitente.cod-emitente " " estabelec.cod-estabel SKIP.
            RUN Atualiza-Cash.
        END.
    END.
END.
    RUN pi-finalizar IN h-acomp.

PUT "FINAL " STRING(TIME,"HH:MM:SS") SKIP.

IF VALID-HANDLE(h-acomp) THEN
    RUN pi-finalizar IN h-acomp.

{include/i-rpclo.i}
RETURN "OK":u.          


PROCEDURE Atualiza-Cash:

    FIND FIRST int-emitente NO-LOCK
         WHERE int-emitente.cod-emitente = emitente.cod-emitente NO-ERROR.

    IF NOT AVAIL int-emitente
    OR int-emitente.cod-guid = "" THEN DO:
        PUT "Emitente nÆo cadastrado no CRM " emitente.cod-emitente SKIP.
        RETURN.
    END.

    /*limpa tt's*/
    EMPTY TEMP-TABLE ProdutoItem.
    EMPTY TEMP-TABLE tt-itens.
    EMPTY TEMP-TABLE ProdutoItemR.

    Blk_calc:
    DO TRANS:
        /*Verifica se j  possui c lculo para o canal*/
        FIND FIRST int-calculo-canal EXCLUSIVE-LOCK
             WHERE int-calculo-canal.cod-guid    = int-emitente.cod-guid 
               AND int-calculo-canal.cod-estabel = estabelec.cod-estabel NO-ERROR.

        IF NOT AVAIL int-calculo-canal OR int-calculo-canal.data-calculo = TODAY THEN NEXT.

        /*Se nÆo possui calculo para o canal cria*/
        IF NOT AVAIL int-calculo-canal THEN DO:
            CREATE int-calculo-canal.
            ASSIGN int-calculo-canal.cod-guid    = int-emitente.cod-guid
                   int-calculo-canal.cod-estabel = estabelec.cod-estabel.
        END.
    
        ASSIGN int-calculo-canal.data-calculo = TODAY
               int-calculo-canal.hora-calculo = NOW.
    
        /*Elimina os itens calculados para calcular de novo*/
        FOR EACH int-calculo-canal-item EXCLUSIVE-LOCK
           WHERE int-calculo-canal-item.cod-guid    = int-calculo-canal.cod-guid
             AND int-calculo-canal-item.cod-estabel = int-calculo-canal.cod-estabel:
            DELETE int-calculo-canal-item.
        END.

        RUN pi-acompanhar IN h-acomp (INPUT "Buscando portif¢lio. Cliente:" + STRING(emitente.cod-emitente)).
    
        /*Busca portifolio*/
        RUN esp/esb/out/msg0100.p (INPUT  int-emitente.cod-guid,
                                   OUTPUT TABLE ProdutoItem,                    
                                   OUTPUT TABLE Resultado). 
    
        FIND FIRST Resultado NO-ERROR.
    
        IF  AVAIL Resultado
        AND Resultado.Sucesso THEN DO:

            ASSIGN i-num-itens-calculo = 0.

            FOR EACH ProdutoItem:

                FIND FIRST ITEM NO-LOCK
                     WHERE ITEM.it-codigo = ProdutoItem.CodigoProduto NO-ERROR.

                IF NOT AVAIL ITEM THEN NEXT.

                FIND FIRST item-uni-estab NO-LOCK
                     WHERE item-uni-estab.it-codigo   = ProdutoItem.CodigoProduto
                       AND item-uni-estab.cod-estabel = estabelec.cod-estabel NO-ERROR.

                CREATE tt-itens.
                ASSIGN tt-itens.it-codigo              = ProdutoItem.CodigoProduto
                       tt-itens.de-quantidade          = 1
                       tt-itens.TipoPortfolio          = ProdutoItem.TipoPortfolio
                       tt-itens.CodigoUnidadeNegocio   = IF AVAIL item-uni-estab THEN item-uni-estab.cod-unid-neg ELSE ITEM.cod-unid-neg
                       tt-itens.CodigoFamiliaComercial = ITEM.fm-cod-com
                       tt-itens.CodigoEstabelecimento  = estabelec.cod-estabel.

                /*calcula o pre‡o a cada 200 itens para nÆo estourar o longchar*/
                ASSIGN i-num-itens-calculo = i-num-itens-calculo + 1.

                IF i-num-itens-calculo = 100 THEN DO:

                    RUN esp/esb/out/msg0101.p (INPUT int-emitente.cod-guid,
                                               INPUT TABLE tt-itens,
                                               OUTPUT TABLE ProdutoItemR-temp,
                                               OUTPUT TABLE Resultado).

                    FIND FIRST Resultado NO-ERROR.

                    IF NOT AVAIL Resultado THEN DO:
                        RUN utp/ut-msgs.p (INPUT "show",
                                           INPUT 17006,
                                           INPUT "NÆo foi poss¡vel consultar pre‡os").
                        UNDO, LEAVE Blk_calc.
                    END.
                    ELSE IF NOT Resultado.Sucesso THEN DO:
                         RUN utp/ut-msgs.p (INPUT "show",
                                            INPUT 17006,
                                            INPUT Resultado.Mensagem).
                        UNDO, LEAVE Blk_calc.
                    END.

                    FOR EACH ProdutoItemR-temp:
                        CREATE ProdutoItemR.
                        BUFFER-COPY ProdutoItemR-temp TO ProdutoItemR.
                    END.

                    /*Ap¢s o envio dos primeiros 300 zera tudo*/
                    EMPTY TEMP-TABLE tt-itens.
                    EMPTY TEMP-TABLE ProdutoItemR-temp.
                    ASSIGN i-num-itens-calculo = 0.
                END.
            END.
            
            /*Calcula pre‡os*/
            RUN pi-acompanhar IN h-acomp (INPUT "Calculando pre‡os. Cliente:" + STRING(emitente.cod-emitente)).
            IF  CAN-FIND(FIRST tt-itens) THEN DO:
                RUN esp/esb/out/msg0101.p (INPUT int-emitente.cod-guid,
                                           INPUT TABLE tt-itens,
                                           OUTPUT TABLE ProdutoItemR-temp,
                                           OUTPUT TABLE Resultado).

                FIND FIRST Resultado NO-ERROR.

                IF NOT AVAIL Resultado THEN DO:
                    RUN utp/ut-msgs.p (INPUT "show",
                                       INPUT 17006,
                                       INPUT "NÆo foi poss¡vel consultar pre‡os").
                    UNDO, LEAVE Blk_calc.
                END.
                ELSE IF NOT Resultado.Sucesso THEN DO:
                     RUN utp/ut-msgs.p (INPUT "show",
                                        INPUT 17006,
                                        INPUT Resultado.Mensagem).
                    UNDO, LEAVE Blk_calc.
                END.

                FOR EACH ProdutoItemR-temp:
                    CREATE ProdutoItemR.
                    BUFFER-COPY ProdutoItemR-temp TO ProdutoItemR.
                END.
            END.
            
            FOR EACH ProdutoItemR:
                /*Busca o tipo de prtifolio retornado pela mensagem do portifolio*/
                FIND FIRST ProdutoItem 
                     WHERE ProdutoItem.CodigoProduto = ProdutoItemR.CodigoProduto NO-ERROR.

                CREATE int-calculo-canal-item.
                ASSIGN int-calculo-canal-item.cod-guid           = int-calculo-canal.cod-guid
                       int-calculo-canal-item.cod-estabel        = int-calculo-canal.cod-estabel
                       int-calculo-canal-item.it-codigo          = ProdutoItemR.CodigoProduto
                       int-calculo-canal-item.preco-base         = ProdutoItemR.PrecoBase
                       int-calculo-canal-item.valor-produto      = ProdutoItemR.ValorComDesconto
                       int-calculo-canal-item.tipo-portifolio    = ProdutoItem.TipoPortfolio
                       int-calculo-canal-item.bloqueado          = ProdutoItem.Bloqueado
                       int-calculo-canal-item.qtd-range          = ProdutoItemR.QuantidadeMaxima
                       int-calculo-canal-item.log-calcrebate     = ProdutoItemR.CalcularRebate            
                       int-calculo-canal-item.log-preco-alterado = ProdutoItemR.PrecoAlterado             
                       int-calculo-canal-item.log-rebate-antec   = ProdutoItemR.RebateAntecipado          
                       int-calculo-canal-item.perc-descto-verde      = ProdutoItemR.PercentualDescontoVerde
                       int-calculo-canal-item.perc-descto-top-milhao = ProdutoItemR.PercentualDescontoTopMilhao
                       int-calculo-canal-item.perc-rebate-antec      = ProdutoItemR.PercentualRebateAntecipado.
            END.
        END.
        ELSE DO:
            IF AVAIL resultado THEN DO:
                RUN utp/ut-msgs.p (INPUT "show",
                                   INPUT 17006,
                                   INPUT Resultado.Mensagem).

                UNDO, LEAVE Blk_calc.
            END.
            ELSE DO:
                RUN utp/ut-msgs.p (INPUT "show",
                                   INPUT 17006,
                                   INPUT "NÆo foi poss¡vel consultar portif¢lio").

                UNDO, LEAVE Blk_calc.
            END.
        END.
    END. /*Blk_calc*/

    RELEASE int-calculo-canal-item.
    RELEASE int-calculo-canal.

END PROCEDURE.

