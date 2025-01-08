{include/i-prgvrs.i esb0000rp 2.00.00.001}  

{esp/esb/esesb000.i}
{include/i-rpvar.i}
{esp/es0018.i}

DEFINE VARIABLE h-acomp AS HANDLE     NO-UNDO.
DEFINE BUFFER b-int-ped-venda FOR int-ped-venda.
DEFINE TEMP-TABLE tt-cond-pagto LIKE cond-pagto.
IF  NOT VALID-HANDLE(h-acomp) THEN
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

DEFINE TEMP-TABLE tt-natur-oper   NO-UNDO LIKE natur-oper.   
DEFINE TEMP-TABLE tt-fam-com-item NO-UNDO LIKE fam-com-item.

DEFINE VARIABLE time-ini AS INTEGER     NO-UNDO.
DEFINE VARIABLE time-fim AS INTEGER     NO-UNDO.
DEFINE VARIABLE l-nota-com-pedido AS LOGICAL     NO-UNDO.

def var c-literal       as char no-undo.
def var c-literal-aux   as char no-undo.
def var c-literal-final as char no-undo.
def var i               as int  no-undo.
def var c-lista         as char no-undo.

ASSIGN time-ini = TIME.

{esp/esb/out/msg0159.i}

DEFINE TEMP-TABLE tt-repres                     NO-UNDO LIKE repres FIELD situacao AS INT.
DEFINE TEMP-TABLE tt-crm-relacionamento-cliente NO-UNDO LIKE crm-relacionamento-cliente FIELD situacao AS INTEGER.
DEFINE TEMP-TABLE tt-loc-entr                   NO-UNDO LIKE loc-entr FIELD situacao AS INTEGER.
DEFINE TEMP-TABLE tt-crm-categoria              NO-UNDO LIKE crm-categoria FIELD situacao AS INTEGER.

/* tt-param */
{esp/esb/esb0000rp.i}

DEFINE TEMP-TABLE tt-raw-digita NO-UNDO
   FIELD raw-digita AS RAW.

DEF INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEF INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

/* OUTPUT TO VALUE (SESSION:TEMP-DIRECTORY + "integracao_canais.txt"). */

RUN pi-inicializar IN h-acomp (INPUT "Integraá∆o").

{include/i-rpout.i}

{esp/esb/esesbapi004-benef.i} /* Temp-table tt-beneficio */
{esp/esb/in/msg0152.i3} /*tt-erro*/
{esp/esb/esesbapi010-saldo.i1}

DEF TEMP-TABLE tt-erro-saldo NO-UNDO LIKE tt-erro.
DEF TEMP-TABLE b-tt-saldo    NO-UNDO LIKE tt-saldo.
DEF TEMP-TABLE tt-erro-apb   NO-UNDO LIKE tt-erro.

DEF BUFFER b-nota-orig FOR nota-fiscal.


DEF TEMP-TABLE tt-nat NO-UNDO
    FIELD nat-operacao AS CHAR.

DEF VAR l-envia-nota-sem-pedido AS LOG INIT NO NO-UNDO.

FOR FIRST ponto-programa NO-LOCK
    WHERE ponto-programa.nome-programa = "esb0001rp"
      AND ponto-programa.ponto         = 1,
     EACH conteudo-programa NO-LOCK
    WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:

    CREATE tt-nat.
    ASSIGN tt-nat.nat-operacao = conteudo-programa.conteudo.

END.

/*--------------------------------*/
/*    M O V I M E N T A Ä Â E S   */
/*--------------------------------*/
IF tt-param.log-categoria THEN DO:
    FOR EACH crm-categoria NO-LOCK:
        CREATE tt-crm-categoria.
        BUFFER-COPY crm-categoria TO tt-crm-categoria.
        ASSIGN tt-crm-categoria.situacao = 0.

        RAW-TRANSFER tt-crm-categoria TO raw-param.
        RUN esp/esb/esesb003.p (INPUT        "msg0190", /* Nome Mensagem */  
                                INPUT        raw-param, /* Tupla do registro */
                                OUTPUT TABLE resultado  /* Retorno do barramento */) NO-ERROR.
        RUN pi-result (INPUT "msg0190").
    END.
END.

IF tt-param.log-local-entrega THEN DO:
    FOR EACH loc-entr NO-LOCK:
        CREATE tt-loc-entr.
        BUFFER-COPY loc-entr TO tt-loc-entr.
        ASSIGN tt-loc-entr.situacao = 0.

        RAW-TRANSFER tt-loc-entr TO raw-param.
        RUN esp/esb/esesb003.p (INPUT        "msg0191", /* Nome Mensagem */  
                                INPUT        raw-param, /* Tupla do registro */
                                OUTPUT TABLE resultado  /* Retorno do barramento */) NO-ERROR.
        RUN pi-result (INPUT "msg0191").
    END.
END.

IF tt-param.log-representante THEN DO:
    FOR EACH repres NO-LOCK:

        CREATE tt-repres.
        BUFFER-COPY repres TO tt-repres.
        ASSIGN tt-repres.situacao = 0.

        RAW-TRANSFER tt-repres TO raw-param.
        RUN esp/esb/esesb003.p (INPUT        "msg0192", /* Nome Mensagem */  
                                INPUT        raw-param, /* Tupla do registro */
                                OUTPUT TABLE resultado  /* Retorno do barramento */) NO-ERROR.
        RUN pi-result (INPUT "msg0192").
    END.
END.

IF tt-param.log-relacionamento-b2b THEN DO:
    FOR EACH crm-relacionamento-cliente NO-LOCK:
        CREATE tt-crm-relacionamento-cliente.
        BUFFER-COPY crm-relacionamento-cliente TO tt-crm-relacionamento-cliente.
        ASSIGN tt-crm-relacionamento-cliente.situacao = 0.
        RAW-TRANSFER tt-crm-relacionamento-cliente TO raw-param.
        RUN esp/esb/esesb003.p (INPUT        "msg0194", /* Nome Mensagem */  
                                INPUT        raw-param, /* Tupla do registro */
                                OUTPUT TABLE resultado  /* Retorno do barramento */) NO-ERROR.
        RUN pi-result (INPUT "msg0194").
    END.
END.

DEF BUFFER b-preco-item FOR preco-item.
{esp/esb/out/msg0195.i}
IF tt-param.log-tabela-preco THEN DO:
    FOR EACH tb-preco NO-LOCK:

        FIND FIRST moeda NO-LOCK
            WHERE moeda.mo-codigo = tb-preco.mo-codigo NO-ERROR.
        FOR EACH b-preco-item OF tb-preco:
            EMPTY TEMP-TABLE msg0195.
            CREATE msg0195.
            ASSIGN msg0195.TabelaPrecoEMS   = tb-preco.nr-tabpre
                   msg0195.NomeTabela       = tb-preco.descricao
                   msg0195.DataInicial      = tb-preco.dt-inival
                   msg0195.DataFinal        = tb-preco.dt-fimval
                   msg0195.CodigoMoeda      = tb-preco.mo-codigo
                   msg0195.NomeMoeda        = IF  AVAIL moeda THEN moeda.descricao ELSE ""
                   msg0195.SituacaoTabela   = 0. /* Manetencao ou inclus∆o */

            /* PRODUTO */
            ASSIGN msg0195.CodigoProduto    = b-preco-item.it-codigo
                   msg0195.CodigoItemPreco  = TRIM(STRING(b-preco-item.it-codigo)) + "," +
                                              TRIM(STRING(b-preco-item.cod-refer)) + "," +
                                              TRIM(STRING(b-preco-item.nr-tabpre)) + "," +
                                              TRIM(STRING(b-preco-item.dt-inival)) + "," +
                                              TRIM(STRING(b-preco-item.quant-min))
                   msg0195.PrecoFOB         = b-preco-item.preco-fob
                   msg0195.PrecoMinimoCIF   = b-preco-item.preco-min-cif
                   msg0195.PrecoMinimoFOB   = b-preco-item.preco-min-fob
                   msg0195.PrecoVenda       = b-preco-item.preco-Venda 
                   msg0195.QuantidadeMinima = b-preco-item.quant-min
                   msg0195.SituacaoItem     = 0. /* Manutená∆o ou inclus∆o*/

            FIND FIRST int-preco-item
                 WHERE int-preco-item.it-codigo = b-preco-item.it-codigo
                   AND int-preco-item.cod-refer = b-preco-item.cod-refer
                   AND int-preco-item.nr-tabpre = b-preco-item.nr-tabpre
                   AND int-preco-item.dt-inival = b-preco-item.dt-inival
                   AND int-preco-item.quant-min = b-preco-item.quant-min NO-LOCK NO-ERROR.

            IF AVAILABLE int-preco-item THEN
                ASSIGN msg0195.Precounico  = int-preco-item.preco-unico
                       msg0195.pma         = int-preco-item.pma
                       msg0195.pmd         = int-preco-item.pmd.

            /*DEF VAR raw-param AS RAW NO-UNDO.*/

            RAW-TRANSFER msg0195 TO raw-param.

            RUN esp/esb/esesb003.p (INPUT        "msg0195", /* Nome Mensagem */  
                                    INPUT        raw-param, /* Tupla do registro */
                                    OUTPUT TABLE resultado  /* Retorno do barramento */) NO-ERROR.
            RUN pi-result (INPUT "msg0195").

        END.

    END.

    FOR EACH estabelec NO-LOCK:
        RAW-TRANSFER estabelec TO raw-param.
        RUN esp/esb/esesb003.p (INPUT        "msg0042", /* Nome Mensagem */  
                                INPUT        raw-param, /* Tupla do registro */
                                OUTPUT TABLE resultado  /* Retorno do barramento */) NO-ERROR.
        RUN pi-result (INPUT "msg0042").
    END.
END.


IF tt-param.log-estabelecimento THEN DO:
    FOR EACH estabelec NO-LOCK:
        RAW-TRANSFER estabelec TO raw-param.
        RUN esp/esb/esesb003.p (INPUT        "msg0042", /* Nome Mensagem */  
                                INPUT        raw-param, /* Tupla do registro */
                                OUTPUT TABLE resultado  /* Retorno do barramento */) NO-ERROR.
        RUN pi-result (INPUT "msg0042").
    END.
END.

IF tt-param.log-receita-padrao THEN DO:                          
    FOR EACH tipo-rec-desp NO-LOCK:
        RAW-TRANSFER tipo-rec-desp TO raw-param.
        RUN esp/esb/esesb003.p (INPUT        "msg0052", /* Nome Mensagem */  
                                INPUT        raw-param, /* Tupla do registro */
                                OUTPUT TABLE resultado  /* Retorno do barramento */) NO-ERROR.
        RUN pi-result (INPUT "msg0052").
    END.
END.

IF tt-param.log-tabela-financiamento THEN DO:
    FOR EACH tab-finan NO-LOCK:
        RAW-TRANSFER tab-finan TO raw-param.
        RUN esp/esb/esesb003.p (INPUT        "msg0044", /* Nome Mensagem */  
                                INPUT        raw-param, /* Tupla do registro */
                                OUTPUT TABLE resultado  /* Retorno do barramento */) NO-ERROR.
        RUN pi-result (INPUT "msg0044").
    END.
END.

IF tt-param.log-indice THEN DO:    
    FOR EACH tab-finan-indice NO-LOCK:
        RAW-TRANSFER tab-finan-indice TO raw-param.
        RUN esp/esb/esesb003.p (INPUT        "msg0046", /* Nome Mensagem */  
                                INPUT        raw-param, /* Tupla do registro */
                                OUTPUT TABLE resultado  /* Retorno do barramento */) NO-ERROR.
        RUN pi-result (INPUT "msg0046").
    END.
END.

IF tt-param.log-familia-material THEN DO:  
    FOR EACH familia NO-LOCK:
        RAW-TRANSFER familia TO raw-param.
        RUN esp/esb/esesb003.p (INPUT        "msg0034", /* Nome Mensagem */  
                                INPUT        raw-param, /* Tupla do registro */
                                OUTPUT TABLE resultado  /* Retorno do barramento */) NO-ERROR.
        RUN pi-result (INPUT "msg0034").
    END.
END.

IF tt-param.log-grupo-estoque THEN DO:                           
    FOR EACH grup-estoq NO-LOCK:
        RAW-TRANSFER grup-estoq TO raw-param.
        RUN esp/esb/esesb003.p (INPUT        "msg0038", /* Nome Mensagem */  
                                INPUT        raw-param, /* Tupla do registro */
                                OUTPUT TABLE resultado  /* Retorno do barramento */) NO-ERROR.
        RUN pi-result (INPUT "msg0038").
    END.
END.

IF tt-param.log-unidade-negocio THEN DO: 
    FOR EACH unid-negoc NO-LOCK:
        RAW-TRANSFER unid-negoc TO raw-param.
        
        RUN esp/esb/esesb003.p (INPUT        "msg0002", /* Nome Mensagem */  
                                INPUT        raw-param, /* Tupla do registro */
                                OUTPUT TABLE resultado  /* Retorno do barramento */) NO-ERROR.
        RUN pi-result (INPUT "msg0002").
    END.
END.

IF tt-param.log-segmento THEN DO:  
    FOR EACH fam-com-item NO-LOCK:
        EMPTY TEMP-TABLE tt-fam-com-item.
        CREATE tt-fam-com-item .
        BUFFER-COPY fam-com-item     TO tt-fam-com-item .
        RAW-TRANSFER tt-fam-com-item TO raw-param.

         IF tt-fam-com-item.unidade  <> "" 
        AND tt-fam-com-item.segmento <> "" 
        AND tt-fam-com-item.familia1 = "" 
        AND tt-fam-com-item.familia2 = "" 
        AND tt-fam-com-item.origem   = "" THEN DO:
             
            RUN esp/esb/esesb003.p (INPUT        "msg0026", /* Nome Mensagem */  
                                    INPUT        raw-param, /* Tupla do registro */
                                    OUTPUT TABLE resultado  /* Retorno do barramento */) NO-ERROR.
            RUN pi-result (INPUT "msg0026").
         END.
    END.
END.

IF tt-param.log-familia THEN DO:
    FOR EACH fam-com-item NO-LOCK:
        EMPTY TEMP-TABLE tt-fam-com-item.
        CREATE tt-fam-com-item .
        BUFFER-COPY fam-com-item     TO tt-fam-com-item .
        RAW-TRANSFER tt-fam-com-item TO raw-param.

         IF tt-fam-com-item.unidade  <> "" 
        AND tt-fam-com-item.segmento <> "" 
        AND tt-fam-com-item.familia1 <> "" 
        AND tt-fam-com-item.familia2 = "" 
        AND tt-fam-com-item.origem   = "" THEN DO:
            RUN esp/esb/esesb003.p (INPUT        "msg0028", /* Nome Mensagem */  
                                    INPUT        raw-param, /* Tupla do registro */
                                    OUTPUT TABLE resultado  /* Retorno do barramento */) NO-ERROR.
            RUN pi-result (INPUT "msg0028").
        END.
    END.
END.

IF tt-param.log-sub-familia THEN DO:
    FOR EACH fam-com-item NO-LOCK:
        EMPTY TEMP-TABLE tt-fam-com-item.
        CREATE tt-fam-com-item .
        BUFFER-COPY fam-com-item     TO tt-fam-com-item .
        RAW-TRANSFER tt-fam-com-item TO raw-param.

         IF tt-fam-com-item.unidade  <> "" 
        AND tt-fam-com-item.segmento <> "" 
        AND tt-fam-com-item.familia1 <> "" 
        AND tt-fam-com-item.familia2 <> "" 
        AND tt-fam-com-item.origem   = "" THEN DO:
            RUN esp/esb/esesb003.p (INPUT        "msg0030", /* Nome Mensagem */  
                                    INPUT        raw-param, /* Tupla do registro */
                                    OUTPUT TABLE resultado  /* Retorno do barramento */) NO-ERROR.
            RUN pi-result (INPUT "msg0030").
         END.
    END.
END.

IF tt-param.log-origem THEN DO: 
    FOR EACH fam-com-item NO-LOCK:
        EMPTY TEMP-TABLE tt-fam-com-item.
        CREATE tt-fam-com-item .
        BUFFER-COPY fam-com-item     TO tt-fam-com-item .
        RAW-TRANSFER tt-fam-com-item TO raw-param.

         IF tt-fam-com-item.unidade  <> "" 
        AND tt-fam-com-item.segmento <> "" 
        AND tt-fam-com-item.familia1 <> "" 
        AND tt-fam-com-item.familia2 <> "" 
        AND tt-fam-com-item.origem   <> "" THEN DO:
            RUN esp/esb/esesb003.p (INPUT        "msg0032", /* Nome Mensagem */  
                                    INPUT        raw-param, /* Tupla do registro */
                                    OUTPUT TABLE resultado  /* Retorno do barramento */) NO-ERROR.
            RUN pi-result (INPUT "msg0032").
         END.
    END.
END.

IF tt-param.log-familia-comercial THEN DO:                          
    FOR EACH fam-comerc NO-LOCK:
        RAW-TRANSFER fam-comerc TO raw-param.
        RUN esp/esb/esesb003.p (INPUT        "msg0036", /* Nome Mensagem */  
                                INPUT        raw-param, /* Tupla do registro */
                                OUTPUT TABLE resultado  /* Retorno do barramento */) NO-ERROR.
        RUN pi-result (INPUT "msg0036").
    END.
END.

IF tt-param.log-rota THEN DO:    
    FOR EACH rota NO-LOCK:
        RAW-TRANSFER rota TO raw-param.
        RUN esp/esb/esesb003.p (INPUT        "msg0054", /* Nome Mensagem */  
                                INPUT        raw-param, /* Tupla do registro */
                                OUTPUT TABLE resultado  /* Retorno do barramento */) NO-ERROR.
        RUN pi-result (INPUT "msg0054").
    END.
END.

IF tt-param.log-pais THEN DO:                  
    FOR EACH mgcad.pais NO-LOCK:
        RAW-TRANSFER mgcad.pais TO raw-param.
        RUN esp/esb/esesb003.p (INPUT        "msg0006", /* Nome Mensagem */  
                                INPUT        raw-param, /* Tupla do registro */
                                OUTPUT TABLE resultado  /* Retorno do barramento */) NO-ERROR.
        RUN pi-result (INPUT "msg0006").
    END.
END.

IF tt-param.log-uf THEN DO:                                       
    FOR EACH unid-feder NO-LOCK:
        RAW-TRANSFER unid-feder TO raw-param.
        RUN esp/esb/esesb003.p (INPUT        "msg0010", /* Nome Mensagem */  
                                INPUT        raw-param, /* Tupla do registro */
                                OUTPUT TABLE resultado  /* Retorno do barramento */) NO-ERROR.
        RUN pi-result (INPUT "msg0010").
    END.
END.

IF tt-param.log-municipio THEN DO: 
    FOR EACH mgcad.cidade NO-LOCK:
        RAW-TRANSFER mgcad.cidade TO raw-param.
        RUN esp/esb/esesb003.p (INPUT        "msg0012", /* Nome Mensagem */  
                                INPUT        raw-param, /* Tupla do registro */
                                OUTPUT TABLE resultado  /* Retorno do barramento */) NO-ERROR.
        RUN pi-result (INPUT "msg0012").
    END.
END.

IF tt-param.log-mensagem THEN DO:  
    FOR EACH mgcad.mensagem NO-LOCK:
        RAW-TRANSFER mgcad.mensagem TO raw-param.
        RUN esp/esb/esesb003.p (INPUT        "msg0048", /* Nome Mensagem */  
                                INPUT        raw-param, /* Tupla do registro */
                                OUTPUT TABLE resultado  /* Retorno do barramento */) NO-ERROR.
        RUN pi-result (INPUT "msg0048").
    END.
END.

IF tt-param.log-portador THEN DO:                                 
    FOR EACH mgcad.portador NO-LOCK:
        RAW-TRANSFER mgcad.portador TO raw-param.
        RUN esp/esb/esesb003.p (INPUT        "msg0024", /* Nome Mensagem */  
                                INPUT        raw-param, /* Tupla do registro */
                                OUTPUT TABLE resultado  /* Retorno do barramento */) NO-ERROR.
        RUN pi-result (INPUT "msg0024").
    END.
END.

IF tt-param.log-transportadora THEN DO:  
    FOR EACH transporte NO-LOCK:
        RAW-TRANSFER transporte TO raw-param.
        RUN esp/esb/esesb003.p (INPUT        "msg0022", /* Nome Mensagem */  
                                INPUT        raw-param, /* Tupla do registro */
                                OUTPUT TABLE resultado  /* Retorno do barramento */) NO-ERROR.
        RUN pi-result (INPUT "msg0022").
    END.
END.

IF tt-param.log-unidade-medida THEN DO:  
    FOR EACH tab-unidade NO-LOCK:
        RAW-TRANSFER tab-unidade TO raw-param.
        RUN esp/esb/esesb003.p (INPUT        "msg0084", /* Nome Mensagem */  
                                INPUT        raw-param, /* Tupla do registro */
                                OUTPUT TABLE resultado  /* Retorno do barramento */) NO-ERROR.
        RUN pi-result (INPUT "msg0084").
    END.
END.

IF tt-param.log-canal-venda THEN DO:                              
    FOR EACH canal-venda NO-LOCK:
        RAW-TRANSFER canal-venda TO raw-param.
        RUN esp/esb/esesb003.p (INPUT        "msg0040", /* Nome Mensagem */  
                                INPUT        raw-param, /* Tupla do registro */
                                OUTPUT TABLE resultado  /* Retorno do barramento */) NO-ERROR.
        RUN pi-result (INPUT "msg0040").
    END.
END.

IF tt-param.log-natureza-operacao THEN DO:                       
    FOR EACH natur-oper NO-LOCK:
        EMPTY TEMP-TABLE tt-natur-oper.
        CREATE tt-natur-oper.
        BUFFER-COPY natur-oper     TO tt-natur-oper.
        RAW-TRANSFER tt-natur-oper TO raw-param.
        RUN esp/esb/esesb003.p (INPUT        "msg0050", /* Nome Mensagem */  
                                INPUT        raw-param, /* Tupla do registro */
                                OUTPUT TABLE resultado  /* Retorno do barramento */) NO-ERROR.
        RUN pi-result (INPUT "msg0050").
    END.
END.

/*
IF tt-param.log-representante THEN DO:                          
    FOR EACH repres NO-LOCK:
        RAW-TRANSFER repres TO raw-param.
        RUN esp/esb/esesb003.p (INPUT        "msg0058", /* Nome Mensagem */  
                                INPUT        raw-param, /* Tupla do registro */
                                OUTPUT TABLE resultado  /* Retorno do barramento */) NO-ERROR.
        RUN pi-result (INPUT "msg0058").
    END.
END.
*/

IF tt-param.log-produto THEN DO:  
    FOR EACH ITEM
        /*WHERE ITEM.ge-codigo = 40 
           OR ITEM.ge-codigo = 42 
           OR ITEM.ge-codigo = 45*/ NO-LOCK:
        
        RAW-TRANSFER ITEM TO raw-param.
        RUN esp/esb/esesb003.p (INPUT        "msg0088", /* Nome Mensagem */  
                                INPUT        raw-param, /* Tupla do registro */
                                OUTPUT TABLE resultado  /* Retorno do barramento */) NO-ERROR.
        RUN pi-result (INPUT "msg0088").
    END.
END.

IF tt-param.log-condicao-pagamento THEN DO: 
    FOR EACH cond-pagto NO-LOCK:
        EMPTY TEMP-TABLE tt-cond-pagto.
        CREATE tt-cond-pagto.
        BUFFER-COPY cond-pagto TO tt-cond-pagto.
        RAW-TRANSFER tt-cond-pagto TO raw-param.

/*         RAW-TRANSFER cond-pagto TO raw-param. */
        RUN esp/esb/esesb003.p (INPUT        "msg0004", /* Nome Mensagem */  
                                INPUT        raw-param, /* Tupla do registro */
                                OUTPUT TABLE resultado  /* Retorno do barramento */) NO-ERROR.
        RUN pi-result (INPUT "msg0004").
    END.
END.


/*--------------------------------*/
/*    M O V I M E N T A Ä Â E S   */
/*--------------------------------*/


/*--------------------------------------------------------------------------*/
/*          ATENDIMENTO PARCIAL DE PEDIDOS - ATUALIZAÄ«O SALDO APB          */
/* OBS: SEMPRE DEVE ESTAR ANTES DA ROTINA DE SOLICITAÄÂES                   */
/*--------------------------------------------------------------------------*/
IF  tt-param.log-saldo-cc THEN DO:

    DEF VAR c-erro-abatimento AS CHAR FORMAT "X(1000)" NO-UNDO.
    DEF VAR l-ok AS LOG INIT NO NO-UNDO.

    IF  tt-param.fi-canal > 0  THEN DO:
        /* S¢ executa para as solicitaá‰es do canal informado */
        FOR EACH int-solicitacao NO-LOCK
            WHERE (int-solicitacao.SituacaoSolicitacaoBeneficio     >= 993520003 AND  int-solicitacao.SituacaoSolicitacaoBeneficio <= 993520004)
              AND int-solicitacao.cod-emitente                      = tt-param.fi-canal
              AND int-solicitacao.desc-forma-pagto                  = "Produto"  /* SOLICITAÄÂES QUE GERAM PEDIDO DE VENDA */
              AND NOT int-solicitacao.Ajuste                                     /* DESCONSIDERAR AJUSTES */
              AND int-solicitacao.log-enviada = NO
              AND int-solicitacao.log-historica = NO /*desconsiderar as hist¢ricas*/
            ,
            FIRST int-cc-benef  FIELDS (canal dt-periodo-ini dt-periodo-fim tipo-beneficio unid-neg cod_estab perc-custo num_id_tit_ap vl-saldo) NO-LOCK
                WHERE int-cc-benef.tp-movto       = 2 
                  AND int-cc-benef.canal          = int-solicitacao.cod-emitente
                  AND int-cc-benef.unid-neg       = int-solicitacao.CodigoUnidadeNegocio
                  AND int-cc-benef.tipo-beneficio = int-solicitacao.tipo-beneficio
                  AND int-cc-benef.dt-periodo-ini = int-solicitacao.dt-periodo-ini
                  AND int-cc-benef.dt-periodo-fim = int-solicitacao.dt-periodo-fim
                  AND int-cc-benef.id-status      = 1 /*ativa*/:
        
            RUN esp/esb/esesbapi009-abater-parcial.p (INPUT int-solicitacao.CodigoSolicitacaoBeneficio,
                                                      OUTPUT TABLE tt-erro,
                                                      OUTPUT l-ok).
            FOR EACH tt-erro:
                PUT UNFORMATTED tt-erro.mensagem SKIP.
                PUT UNFORMATTED tt-erro.ajuda    SKIP(2).
        
            END.
        END.
    END.
    ELSE DO:
        /*Verifica para todos os canais*/
        RUN esp/esb/esesbapi009-abater-parcial.p (INPUT ?,
                                                  OUTPUT TABLE tt-erro,
                                                  OUTPUT l-ok).
        FOR EACH tt-erro:
            PUT UNFORMATTED tt-erro.mensagem SKIP.
            PUT UNFORMATTED tt-erro.ajuda    SKIP(2).
    
        END.
    END.

END.

/*--------------------------------*/
/*          SOLICITAÄÂES          */
/*--------------------------------*/
{esp/esb/out/msg0152-status.i}
{esp/esb/out/msg0154-status.i}
{esp/esb/out/msg0155-status.i}
{esp/esb/out/msg0156-status.i}
{esp/esb/out/msg0157-status.i}
{esp/esb/out/msg0158-status.i}
{esp/esb/out/msg0173-status.i}

DEF BUFFER b-solicitacao FOR int-solicitacao.

IF  tt-param.log-solicitacao THEN DO:

    /* Enviar as solicitaá‰es com situaá∆o de "pagamento efetuado/pedido gerado"  (c¢digo = 993520004) 
       e tambÇm as Pagamento pendente, */
    FOR EACH int-solicitacao NO-LOCK
        WHERE int-solicitacao.log-enviada = NO               
          AND (int-solicitacao.SituacaoSolicitacaoBeneficio    = 993520004 
               OR int-solicitacao.SituacaoSolicitacaoBeneficio = 993520003
               OR int-solicitacao.SituacaoSolicitacaoBeneficio = 993520006)
          AND (IF tt-param.fi-canal > 0 THEN int-solicitacao.cod-emitente = tt-param.fi-canal ELSE YES)
          AND NOT int-solicitacao.Ajuste
          AND NOT int-solicitacao.log-historica /*desconsiderar hist¢ricas*/
          BY int-solicitacao.tipo-beneficio:

        IF (int-solicitacao.SituacaoSolicitacaoBeneficio = 993520003  /*Pendente*/ AND int-solicitacao.StatusPagamento = 993520001) /* PARCIAL */
        OR int-solicitacao.SituacaoSolicitacaoBeneficio = 993520004 
        OR int-solicitacao.SituacaoSolicitacaoBeneficio = 993520006 /* Cancelada */
        THEN  DO:

            FIND int-forma-pagto
                WHERE int-forma-pagto.guid-forma-pagto = int-solicitacao.CodigoFormaPagamento NO-LOCK NO-ERROR.
            IF  NOT AVAIL int-forma-pagto THEN 
                NEXT.
        
            CASE int-solicitacao.tipo-beneficio:
                WHEN 04 THEN DO: /* BACKUP */
                    {esp/esb/out/msg0152-status.i1  "msg0158-status" }
                     ASSIGN c-programa = "msg0158-status" .
                END.
                WHEN 08 THEN DO: /* PRICE PROTECTION */
                    {esp/esb/out/msg0152-status.i1  "msg0155-status" }
                     ASSIGN c-programa = "msg0155-status" .
                END.
                WHEN 15 THEN DO: /* SHOW ROOM */
                    {esp/esb/out/msg0152-status.i1  "msg0157-status" }
                     ASSIGN c-programa = "msg0157-status" .
                END.
                WHEN 21 THEN DO: /* VMC */
                    {esp/esb/out/msg0152-status.i1  "msg0152-status" }
                     ASSIGN c-programa = "msg0152-status" .
                END.
                WHEN 37 THEN DO: /* REBATE */
                    {esp/esb/out/msg0152-status.i1  "msg0154-status" }
                    ASSIGN c-programa = "msg0154-status" .
                END.
                WHEN 66 THEN DO: /* REBATE P‡S*/
                    {esp/esb/out/msg0152-status.i1  "msg0173-status" }
                    ASSIGN c-programa = "msg0173-status" .
                END.
                WHEN 22 THEN DO: /* STOCK ROTATION */
                    {esp/esb/out/msg0152-status.i1  "msg0156-status" }
                     ASSIGN c-programa = "msg0156-status" .
                END.
            END CASE.
    
            blk-novo:
            DO TRANSACTION
            ON ERROR UNDO blk-novo,LEAVE blk-novo
            ON STOP  UNDO blk-novo,LEAVE blk-novo:            
                /* ALTERAR O STATUS DA SOLICITAÄ«O NO  E M S  */
                RUN pi-altera-status-solicitacao-EMS.
                IF  RETURN-VALUE <> "OK" THEN
                    NEXT.
                RUN esp/esb/esesb003.p (INPUT        c-programa, /* Nome Mensagem (programa)*/
                                        INPUT        raw-param,  /* Tupla do registro */
                                        OUTPUT TABLE resultado   /* Retorno do barramento */) NO-ERROR.

                RUN pi-result (INPUT c-programa).
               
                IF  NOT CAN-FIND (FIRST resultado WHERE resultado.sucesso) THEN
                    UNDO blk-novo.
            END. /*trans*/
        END.

/*         END.  */

    END. /*FOR EACH int-solicitacao*/

END.

/*------------------------------------------------------*/
/*    ENVIO DE SALDO DE CONTA CORRENTE DE BENEF÷CIOS    */
/*------------------------------------------------------*/
IF tt-param.log-saldo-cc THEN DO:

    DEF VAR de-tot-pagas            AS DEC NO-UNDO.
    DEF VAR de-valor-atendido       AS DEC NO-UNDO.
    
    ASSIGN c-programa = "msg0159" .
    FOR EACH int-cc-benef NO-LOCK
        WHERE int-cc-benef.id-status = 1 /*Ativa*/
          AND int-cc-benef.tp-movto  = 2 /*Despesa*/
          AND (IF tt-param.fi-canal > 0 THEN int-cc-benef.canal = tt-param.fi-canal ELSE YES):  /*N∆o enviar Stock Rotation*/

          ASSIGN l-ok = NO.
          RUN esp/esb/esesbapi010-saldo.p (INPUT int-cc-benef.canal,
                                           INPUT int-cc-benef.tipo-beneficio,
                                           INPUT int-cc-benef.unid-neg,
                                           INPUT int-cc-benef.dt-periodo-ini,
                                           INPUT int-cc-benef.dt-periodo-fim,
                                           INPUT ?,
                                           INPUT ?,
                                           OUTPUT l-ok,
                                           OUTPUT TABLE tt-saldo,
                                           OUTPUT TABLE tt-erro-saldo).

          IF  NOT l-ok THEN DO:
              IF  NOT CAN-FIND(tt-erro) THEN DO:
                  PUT SKIP(1).
                  PUT UNFORMATTED "N∆o Foi poss°vel retornar o saldo. "                    + CHR(10) + 
                                  " Canal........: " + STRING(int-cc-benef.canal)          + CHR(10) +
                                  " Benef°cio....: " + STRING(int-cc-benef.tipo-beneficio) + CHR(10) +
                                  " Unidade......: " + int-cc-benef.unid-neg               + CHR(10) +
                                  " Per°odo Ini..: " + STRING(int-cc-benef.dt-periodo-ini) + CHR(10) +
                                  " Per°odo Fim..: " + STRING(int-cc-benef.dt-periodo-fim) + CHR(10).
                  NEXT.                    
              END.
              ELSE DO:
                  FOR EACH tt-erro:
                      PUT SKIP(1).
                      PUT UNFORMATTED tt-erro.mensagem                                         + CHR(10) + 
                                      tt-erro.ajuda                                            + CHR(10) + 
                                      " Canal........: " + STRING(int-cc-benef.canal)          + CHR(10) +
                                      " Benef°cio....: " + STRING(int-cc-benef.tipo-beneficio) + CHR(10) +
                                      " Unidade......: " + int-cc-benef.unid-neg               + CHR(10) +
                                      " Per°odo Ini..: " + STRING(int-cc-benef.dt-periodo-ini) + CHR(10) +
                                      " Per°odo Fim..: " + STRING(int-cc-benef.dt-periodo-fim) + CHR(10).
                  END.
              END.
              NEXT.
          END.

          
          FIND FIRST tt-saldo.
          IF  AVAIL tt-saldo THEN DO:

              CREATE b-tt-saldo.
              BUFFER-COPY tt-saldo TO b-tt-saldo.
          END.

    END.

    IF  CAN-FIND (FIRST b-tt-saldo) THEN DO:
        CREATE msg0159.
        CREATE msg0159-BeneficioCanalItens.
        FOR EACH b-tt-saldo:
            CREATE msg0159-BeneficioCanalItem.
            ASSIGN msg0159-BeneficioCanalItem.CodigoBeneficioCanal  = b-tt-saldo.CodigoBeneficioCanal 
                   msg0159-BeneficioCanalItem.VerbaCalculada        = b-tt-saldo.VerbaCalculada       
                   msg0159-BeneficioCanalItem.VerbaPeriodoAnterior  = b-tt-saldo.VerbaPeriodoAnterior 
                   msg0159-BeneficioCanalItem.VerbaTotal            = b-tt-saldo.VerbaTotal           
                   msg0159-BeneficioCanalItem.VerbaEmpenhada        = b-tt-saldo.VerbaEmpenhadaTotal       
                   msg0159-BeneficioCanalItem.VerbaReembolsada      = b-tt-saldo.VerbaReembolsada     
                   msg0159-BeneficioCanalItem.VerbaCancelada        = b-tt-saldo.VerbaCancelada       
                   msg0159-BeneficioCanalItem.VerbaAjustada         = b-tt-saldo.VerbaAjustada        
                   msg0159-BeneficioCanalItem.VerbaDisponivel       = b-tt-saldo.VerbaDisponivel.      
        END.

        RUN esp/esb/out/msg0159.p (INPUT  TABLE msg0159,
                                   INPUT  TABLE msg0159-BeneficioCanalItens,
                                   INPUT  TABLE msg0159-BeneficioCanalItem,
                                   OUTPUT TABLE resultado).
        EMPTY TEMP-TABLE msg0159.

        RUN pi-result (INPUT c-programa).

    END.

    EMPTY TEMP-TABLE tt-erro.
    
    
END.

IF tt-param.log-pedido THEN DO:                                   

    RUN esp/es0018p.p (INPUT "msg0091", /* Nome do programa */
                       INPUT 1,         /* Ponto do programa */
                       INPUT 0,
                       INPUT "",
                       OUTPUT TABLE tt-prog-ponto) NO-ERROR.

    FIND FIRST tt-prog-ponto 
         WHERE tt-prog-ponto.conteudo = "online" NO-ERROR.

    /*Verifica se a execuá∆o Ç em batch e se o parametro do es0018 nao est† como online*/
    IF  tt-param.ind-execucao = 2 
    AND tt-param.dt-emiss-pedido-ini = 01/01/0001 
    AND tt-param.dt-emiss-pedido-fim = 01/01/0001 
    AND NOT AVAIL tt-prog-ponto THEN DO:

        FOR EACH int-ped-venda NO-LOCK 
           WHERE SUBSTRING(int-ped-venda.char-1,76,1) = "1":
        
            FIND FIRST ped-venda 
                 WHERE ped-venda.nr-pedido   = int-ped-venda.nr-pedido 
                 AND ped-venda.cod-estabel   = int-ped-venda.cod-estabel NO-LOCK NO-ERROR. 
            IF NOT AVAIL ped-venda THEN NEXT.

            FIND FIRST ped-item OF ped-venda NO-LOCK NO-ERROR.

            IF NOT AVAIL ped-item THEN NEXT.

            FIND FIRST atendente USE-INDEX codigo NO-LOCK 
                 WHERE atendente.cd-oper = int(ped-venda.tp-pedido) NO-ERROR.
            IF AVAIL atendente AND (atendente.cod-gr-canais = 2 OR atendente.cod-gr-canais = 4) THEN 
               NEXT.

            IF  ped-venda.nome-abrev  = "TOOLSYSTEMS" 
            AND ped-venda.cod-sit-ped = 6 THEN 
                NEXT.

            /*Chamado 83518*/
            IF  ped-venda.cod-priori = 44 THEN 
                NEXT.

            FIND FIRST int-emitente USE-INDEX codigo NO-LOCK
                 WHERE int-emitente.cod-emitente = ped-venda.cod-emitente NO-ERROR.
                                 
    
            IF AVAIL int-emitente THEN DO:
                IF int-emitente.guid-class <> "" THEN DO: /* Indica que o cliente esta cadastrado no crm2013, portanto o pedido deve ser integrado - chamado 48202 */
                
                   RAW-TRANSFER ped-venda TO raw-param.
                  
                   RUN pi-acompanhar IN h-acomp (INPUT "Pedido: " + STRING(ped-venda.nr-pedido)).
                  
                   RUN esp/esb/esesb003.p (INPUT        "msg0091", /* Nome Mensagem */  
                                           INPUT        raw-param, /* Tupla do registro */
                                           OUTPUT TABLE resultado  /* Retorno do barramento */) NO-ERROR.
                   RUN pi-result (INPUT "msg0091 - PED -> " + STRING(ped-venda.nr-pedido) + STRING(ped-venda.dt-emiss)).
                  
                  
                   /*Marca pedido como enviado*/
                   IF CAN-FIND (FIRST resultado WHERE resultado.sucesso) THEN DO:
                       FIND FIRST b-int-ped-venda EXCLUSIVE-LOCK
                            WHERE b-int-ped-venda.nr-pedido   = int-ped-venda.nr-pedido  
                              AND b-int-ped-venda.cod-estabel = int-ped-venda.cod-estabel NO-ERROR.
                       OVERLAY(b-int-ped-venda.char-1,76,1) = "0".   
                       FIND CURRENT b-int-ped-venda NO-LOCK.
                       RELEASE b-int-ped-venda.
                   END.
               END.
            END.
        END.
    END.
    ELSE DO:
        FOR EACH ped-venda NO-LOCK
           WHERE ped-venda.dt-emissao >= tt-param.dt-emiss-pedido-ini
             AND ped-venda.dt-emissao <= tt-param.dt-emiss-pedido-fim
             AND ped-venda.nr-pedido  >= tt-param.i-nr-pedido-ini
             AND ped-venda.nr-pedido  <= tt-param.i-nr-pedido-fim:

             FIND FIRST ped-item OF ped-venda NO-LOCK NO-ERROR.
             
             IF NOT AVAIL ped-item THEN NEXT.

            IF ped-venda.nome-abrev = "TOOLSYSTEMS" AND
               ped-venda.cod-sit-ped = 6 THEN NEXT.

            /*Chamado 83518*/
            IF  ped-venda.cod-priori = 44 THEN 
                NEXT.
    
            FIND FIRST int-emitente USE-INDEX codigo NO-LOCK
                 WHERE int-emitente.cod-emitente = ped-venda.cod-emitente NO-ERROR.             
    
            IF AVAIL int-emitente THEN DO:
                IF int-emitente.guid-class <> "" THEN DO: /* Indica que o cliente esta cadastrado no crm2013, portanto o pedido deve ser integrado - chamado 48202 */
                    RAW-TRANSFER ped-venda TO raw-param.
                
                    RUN pi-acompanhar IN h-acomp (INPUT "Pedido: " + STRING(ped-venda.nr-pedido)).
                  
                    RUN esp/esb/esesb003.p (INPUT        "msg0091", /* Nome Mensagem */  
                                            INPUT        raw-param, /* Tupla do registro */
                                            OUTPUT TABLE resultado  /* Retorno do barramento */) NO-ERROR.
                    RUN pi-result (INPUT "msg0091 - PED -> " + STRING(ped-venda.nr-pedido) + STRING(ped-venda.dt-emiss)).
                END.
            END.
        END.
    END.
END.

IF tt-param.log-nota-fiscal THEN DO:     
    IF  tt-param.ind-execucao = 2 
    AND tt-param.dt-emiss-nota-ini = 01/01/0001 
    AND tt-param.dt-emiss-nota-fim = 01/01/0001 THEN DO:

        FOR EACH nota-fiscal 
           WHERE nota-fiscal.dt-emis-nota >= TODAY - 3 NO-LOCK:

            /* Naturezas parametrizadas no es0018, permitem envio de nota sem pedido */
            IF  (nota-fiscal.nr-pedcli = "" OR nota-fiscal.nr-pedcli = ?) 
            AND NOT can-find(tt-nat WHERE tt-nat.nat-operacao = nota-fiscal.nat-operacao) THEN
                NEXT.
               
            IF CAN-FIND (FIRST int-emitente
                         WHERE int-emitente.cod-emitente = nota-fiscal.cod-emitente
                           AND int-emitente.guid-class <> "")    /* Indica que o cliente esta cadastrado no crm2013, portanto o pedido deve ser integrado - chamado 48202 */
                         THEN DO:

                FOR FIRST ped-venda NO-LOCK
                    WHERE ped-venda.nr-pedcli = nota-fiscal.nr-pedcli:
                     RAW-TRANSFER ped-venda TO raw-param.
            
                    RUN esp/esb/esesb003.p (INPUT        "msg0091", /* Nome Mensagem */  
                                            INPUT        raw-param, /* Tupla do registro */
                                            OUTPUT TABLE resultado  /* Retorno do barramento */) NO-ERROR.
                    RUN pi-result (INPUT "msg0091").
                END.

                RAW-TRANSFER nota-fiscal TO raw-param.
                
                RUN esp/esb/esesb003.p (INPUT        "msg0094", /* Nome Mensagem */  
                                        INPUT        raw-param, /* Tupla do registro */
                                        OUTPUT TABLE resultado  /* Retorno do barramento */) NO-ERROR.
                RUN pi-result (INPUT "msg0094").

                PUT UNFORMATTED "Nota enviada para o barramento: " + nota-fiscal.cod-estabel + " - " + nota-fiscal.serie + " - " nota-fiscal.nr-nota-fis SKIP. 
    
            END.
        END.
        
        /* NOTAS DEVOLUÄ«O */
        FOR EACH devol-cli NO-LOCK 
            WHERE devol-cli.dt-devol >= TODAY - 3
        , FIRST nota-fiscal no-lock
             WHERE nota-fiscal.cod-estabel = devol-cli.cod-estabel
               AND nota-fiscal.serie       = devol-cli.serie-docto
               AND nota-fiscal.nr-nota-fis = devol-cli.nro-docto
               AND nota-fiscal.esp-docto = 20
            BREAK BY devol-cli.cod-estabel
                  BY devol-cli.serie
                  BY devol-cli.nr-nota-fis:

            ASSIGN l-nota-com-pedido = NO.

            IF  FIRST-OF (devol-cli.nr-nota-fis)  THEN DO:
                 FOR FIRST b-nota-orig no-lock
                     WHERE b-nota-orig.cod-estabel = devol-cli.cod-estabel
                       AND b-nota-orig.serie       = devol-cli.serie
                       AND b-nota-orig.nr-nota-fis = devol-cli.nr-nota-fis:

                       IF  b-nota-orig.nr-pedcli  <> "" 
                       AND b-nota-orig.nr-pedcli  <> ? THEN DO:
                           FOR FIRST ped-venda NO-LOCK
                               WHERE ped-venda.nome-abrev = b-nota-orig.nome-ab-cli
                                 AND ped-venda.nr-pedcli  = b-nota-orig.nr-pedcli:

                                 ASSIGN l-nota-com-pedido = YES.

                                 RAW-TRANSFER ped-venda TO raw-param.

                                 RUN esp/esb/esesb003.p (INPUT        "msg0091", /* Nome Mensagem */  
                                                         INPUT        raw-param, /* Tupla do registro */
                                                         OUTPUT TABLE resultado  /* Retorno do barramento */) NO-ERROR.
                                RUN pi-result (INPUT "msg0091").

                                PUT UNFORMATTED "Pedido enviado para o barramento: " + string(ped-venda.nr-pedido) SKIP. 
                           END.
                       END.
                 END.

                IF CAN-FIND (FIRST int-emitente
                             WHERE int-emitente.cod-emitente = b-nota-orig.cod-emitente
                               AND int-emitente.guid-class <> "") THEN DO:             /* Indica que o cliente esta cadastrado no crm2013, portanto o pedido deve ser integrado - chamado 48202 */
                    /*Envia somente as devoluá‰es que possuem pedido na nota de entrada*/
                    IF l-nota-com-pedido THEN DO:
                    
                        RAW-TRANSFER nota-fiscal TO raw-param.
                        
                        RUN esp/esb/esesb003.p (INPUT        "msg0094", /* Nome Mensagem */  
                                                INPUT        raw-param, /* Tupla do registro */
                                                OUTPUT TABLE resultado  /* Retorno do barramento */) NO-ERROR.
                        RUN pi-result (INPUT "msg0094").
        
                        PUT UNFORMATTED "Nota de Devoluá∆o enviada para o barramento: " + nota-fiscal.cod-estabel + " - " + nota-fiscal.serie + " - " nota-fiscal.nr-nota-fis SKIP. 
                    END.
                END.
            END.
        END.

    END.
    ELSE DO:
        /* NOTAS NORMAIS */
        FOR EACH nota-fiscal 
           WHERE nota-fiscal.cod-estabel  >= tt-param.c-cod-estabel-ini
             AND nota-fiscal.cod-estabel  <= tt-param.c-cod-estabel-fim
             AND nota-fiscal.serie        >= tt-param.c-serie-ini
             AND nota-fiscal.serie        <= tt-param.c-serie-fim
             AND nota-fiscal.nr-nota-fis  >= tt-param.c-nr-nota-fis-ini 
             AND nota-fiscal.nr-nota-fis  <= tt-param.c-nr-nota-fis-fim 
             AND nota-fiscal.dt-emis-nota >= tt-param.dt-emiss-nota-ini 
             AND nota-fiscal.dt-emis-nota <= tt-param.dt-emiss-nota-fim
             AND nota-fiscal.cod-emitente >= tt-param.c-cod-emitente-ini 
             AND nota-fiscal.cod-emitente <= tt-param.c-cod-emitente-fim 
             AND nota-fiscal.dt-confirma  <> ? NO-LOCK:

            /* Naturezas parametrizadas no es0018, permitem envio de nota sem pedido */
            IF  (nota-fiscal.nr-pedcli = "" OR nota-fiscal.nr-pedcli = ?) 
            AND NOT can-find(tt-nat WHERE tt-nat.nat-operacao = nota-fiscal.nat-operacao) THEN
                NEXT.
    
            IF CAN-FIND (FIRST int-emitente
                         WHERE int-emitente.cod-emitente = nota-fiscal.cod-emitente
                           AND int-emitente.guid-class <> "") THEN DO:             /* Indica que o cliente esta cadastrado no crm2013, portanto o pedido deve ser integrado - chamado 48202 */
                           
                FOR FIRST ped-venda NO-LOCK
                    WHERE ped-venda.nr-pedcli = nota-fiscal.nr-pedcli:
                     RAW-TRANSFER ped-venda TO raw-param.
            
                    RUN esp/esb/esesb003.p (INPUT        "msg0091", /* Nome Mensagem */  
                                            INPUT        raw-param, /* Tupla do registro */
                                            OUTPUT TABLE resultado  /* Retorno do barramento */) NO-ERROR.
                    RUN pi-result (INPUT "msg0091").
                END.

                RAW-TRANSFER nota-fiscal TO raw-param.
                
                RUN esp/esb/esesb003.p (INPUT        "msg0094", /* Nome Mensagem */  
                                        INPUT        raw-param, /* Tupla do registro */
                                        OUTPUT TABLE resultado  /* Retorno do barramento */) NO-ERROR.
                RUN pi-result (INPUT "msg0094").

                PUT UNFORMATTED "Nota enviada para o barramento: " + nota-fiscal.cod-estabel + " - " + nota-fiscal.serie + " - " nota-fiscal.nr-nota-fis SKIP. 
    

            END.
        END.


        /* NOTAS DEVOLUÄ«O */
        FOR EACH devol-cli NO-LOCK 
            WHERE devol-cli.cod-estabel  >= tt-param.c-cod-estabel-ini
              AND devol-cli.cod-estabel  <= tt-param.c-cod-estabel-fim
              AND devol-cli.serie-docto  >= tt-param.c-serie-ini 
              AND devol-cli.serie-docto  <= tt-param.c-serie-fim 
              AND devol-cli.nro-docto    >= tt-param.c-nr-nota-fis-ini 
              AND devol-cli.nro-docto    <= tt-param.c-nr-nota-fis-fim 
              AND devol-cli.dt-devol     >= tt-param.dt-emiss-nota-ini
              AND devol-cli.dt-devol     <= tt-param.dt-emiss-nota-fim
              AND devol-cli.cod-emitente >= tt-param.c-cod-emitente-ini 
              AND devol-cli.cod-emitente <= tt-param.c-cod-emitente-fim 
        , FIRST nota-fiscal no-lock
             WHERE nota-fiscal.cod-estabel = devol-cli.cod-estabel
               AND nota-fiscal.serie       = devol-cli.serie-docto
               AND nota-fiscal.nr-nota-fis = devol-cli.nro-docto
               AND nota-fiscal.esp-docto = 20
            BREAK BY devol-cli.cod-estabel
                  BY devol-cli.serie
                  BY devol-cli.nr-nota-fis:

            ASSIGN l-nota-com-pedido = NO.

            IF  FIRST-OF (devol-cli.nr-nota-fis)  THEN DO:
                IF CAN-FIND (FIRST int-emitente
                             WHERE int-emitente.cod-emitente = nota-fiscal.cod-emitente
                               AND int-emitente.guid-class <> "") THEN DO:             /* Indica que o cliente esta cadastrado no crm2013, portanto o pedido deve ser integrado - chamado 48202 */
                               
                    /* ENVIAR O PEDIDO REFERENTE ∑ NOTA DE ORIGEM */
                    FOR FIRST b-nota-orig no-lock
                        WHERE b-nota-orig.cod-estabel = devol-cli.cod-estabel
                          AND b-nota-orig.serie       = devol-cli.serie
                          AND b-nota-orig.nr-nota-fis = devol-cli.nr-nota-fis:

                        FOR FIRST ped-venda NO-LOCK
                            WHERE ped-venda.nome-abrev = b-nota-orig.nome-ab-cli
                              AND ped-venda.nr-pedcli  = b-nota-orig.nr-pedcli:

                              ASSIGN l-nota-com-pedido = YES.
                             
                              RAW-TRANSFER ped-venda TO raw-param.
                    
                              RUN esp/esb/esesb003.p (INPUT        "msg0091", /* Nome Mensagem */  
                                                      INPUT        raw-param, /* Tupla do registro */
                                                      OUTPUT TABLE resultado  /* Retorno do barramento */) NO-ERROR.
                             RUN pi-result (INPUT "msg0091").

                             PUT UNFORMATTED "Pedido enviado para o barramento: " + string(ped-venda.nr-pedido) SKIP. 

                        END.
                    END.
                    /*Envia somente as devoluá‰es que possuem pedido na nota de entrada*/
                    IF l-nota-com-pedido THEN DO:
                    
                        RAW-TRANSFER nota-fiscal TO raw-param.
                        
                        RUN esp/esb/esesb003.p (INPUT        "msg0094", /* Nome Mensagem */  
                                                INPUT        raw-param, /* Tupla do registro */
                                                OUTPUT TABLE resultado  /* Retorno do barramento */) NO-ERROR.
                        RUN pi-result (INPUT "msg0094").
        
                        PUT UNFORMATTED "Nota de Devoluá∆o enviada para o barramento: " + nota-fiscal.cod-estabel + " - " + nota-fiscal.serie + " - " nota-fiscal.nr-nota-fis SKIP. 
                    END.
                END.
            END.

        END. /* FOR EACH DEVOLUÄÂES*/

    END.
END.

ASSIGN time-fim = TIME.

IF VALID-HANDLE(h-acomp) THEN
    RUN pi-finalizar IN h-acomp.

{include/i-rpclo.i}
                           
PROCEDURE pi-result:
    DEFINE INPUT PARAM c-msg AS CHAR.

    RUN pi-acompanhar IN h-acomp (INPUT c-msg).

    FIND FIRST resultado NO-ERROR.

    PUT UNFORMATTED c-msg.
    IF AVAIL resultado THEN
        PUT UNFORMATTED " " + resultado.mensagem SKIP.
    ELSE 
        PUT UNFORMATTED " sem Resultado" SKIP.

END.


/* PROCEDURE pi-atualiza-titulo:                                                                          */
/*                                                                                                        */
/*     DEF INPUT PARAM p-valor AS DEC NO-UNDO.                                                            */
/*                                                                                                        */
/*      /* ATUALIZAR O CONTAS A PAGAR */                                                                  */
/*      DEF VAR h-esesb003-apb AS HANDLE NO-UNDO.                                                         */
/*                                                                                                        */
/*      EMPTY TEMP-TABLE tt-beneficio.                                                                    */
/*                                                                                                        */
/*      CREATE tt-beneficio.                                                                              */
/*      ASSIGN tt-beneficio.tipo-beneficio = int-cc-benef.tipo-beneficio                                  */
/*             tt-beneficio.unid-neg       = int-cc-benef.unid-neg                                        */
/*             tt-beneficio.cod-estabel    = int-cc-benef.cod_estab                                       */
/*             tt-beneficio.perc-custo     = int-cc-benef.perc-custo.                                     */
/*                                                                                                        */
/*      IF  NOT VALID-HANDLE(h-esesb003-apb) THEN                                                         */
/*          RUN esp/esb/esesbapi003-apb.p PERSISTENT SET h-esesb003-apb.                                  */
/*                                                                                                        */
/*      RUN pi-Integra-Despesas-APB IN h-esesb003-apb (INPUT ROWID(int-cc-benef),                         */
/*                                                     INPUT p-valor * (- 1) ,                            */
/*                                                     INPUT NO,                                          */
/*                                                     INPUT TODAY,                                       */
/*                                                     INPUT int-cc-benef.dt-periodo-fim,                 */
/*                                                     INPUT TABLE tt-beneficio,                          */
/*                                                     OUTPUT TABLE tt-erro-apb).                         */
/*                                                                                                        */
/*       IF  VALID-HANDLE(h-esesb003-apb) THEN                                                            */
/*           DELETE PROCEDURE h-esesb003-apb.                                                             */
/*                                                                                                        */
/*       IF  CAN-FIND (FIRST tt-erro-apb)                                                                 */
/*       OR  RETURN-VALUE <> "OK" THEN DO:                                                                */
/*           DEF VAR l-erro AS LOG NO-UNDO.                                                               */
/*           FOR EACH tt-erro-apb:                                                                        */
/*                                                                                                        */
/*               PUT UNFORMATTED "Erro integrando solicitaá∆o com o Contas a Pagar"           + CHR(10) + */
/*                               " Canal........: " + STRING(int-cc-benef.canal)              + CHR(10) + */
/*                               " Benef°cio....: " + STRING(int-cc-benef.tipo-beneficio)     + CHR(10) + */
/*                               " Unidade......: " + int-cc-benef.unid-neg                   + CHR(10) + */
/*                               " Per°odo Ini..: " + STRING(int-cc-benef.dt-periodo-ini)     + CHR(10) + */
/*                               " Per°odo Fim..: " + STRING(int-cc-benef.dt-periodo-fim)     + CHR(10) + */
/*                               " Vl Pagamento.: " + STRING(int-solicitacao.ValorSolicitado) + CHR(10) + */
/*                                tt-erro-apb.mensagem + " - HELP: " tt-erro-apb.ajuda SKIP(1).           */
/*               l-erro = YES.                                                                            */
/*           END.                                                                                         */
/*                                                                                                        */
/*           IF  NOT l-erro THEN                                                                          */
/*               PUT UNFORMATTED "Erro integrando solicitaá∆o com o Contas a Pagar"           + CHR(10) + */
/*                               " Canal........: " + STRING(int-cc-benef.canal)              + CHR(10) + */
/*                               " Benef°cio....: " + STRING(int-cc-benef.tipo-beneficio)     + CHR(10) + */
/*                               " Unidade......: " + int-cc-benef.unid-neg                   + CHR(10) + */
/*                               " Per°odo Ini..: " + STRING(int-cc-benef.dt-periodo-ini)     + CHR(10) + */
/*                               " Per°odo Fim..: " + STRING(int-cc-benef.dt-periodo-fim)     + CHR(10) + */
/*                               " Vl Pagamento.: " + STRING(int-solicitacao.ValorSolicitado) + CHR(10) + */
/*                               "Retorno com erro, mas n∆o retornou descriá∆o do mesmo." SKIP (1).       */
/*                                                                                                        */
/*               RETURN "NOK".                                                                            */
/*       END.                                                                                             */
/*                                                                                                        */
/*       RETURN "OK".                                                                                     */
/* END.                                                                                                   */

PROCEDURE pi-altera-status-solicitacao-EMS:

    FIND FIRST b-solicitacao EXCLUSIVE-LOCK                                                                 
        WHERE b-solicitacao.CodigoSolicitacaoBeneficio = int-solicitacao.CodigoSolicitacaoBeneficio NO-ERROR.
                                                                                                              
    IF  AVAIL b-solicitacao THEN DO:    

        IF  b-solicitacao.SituacaoSolicitacaoBeneficio = 993520006 /* Canceladas */ THEN
            ASSIGN b-solicitacao.log-enviada  = YES.  
        ELSE DO:
        
            IF  b-solicitacao.SituacaoSolicitacaoBeneficio = 993520004 /* Paga */ THEN
                ASSIGN b-solicitacao.log-enviada                     = YES                                          
                       b-solicitacao.RazaoStatusSolicitacaoBeneficio = 993520004. /* REEMBOLSADO */

            IF  b-solicitacao.StatusPagamento <> 993520001 
            AND b-solicitacao.StatusPagamento <> 993520002  THEN
                ASSIGN b-solicitacao.StatusPagamento = 993520002.
        END.
    END.
    ELSE DO:
        PUT UNFORMATTED "Erro de tentar enviar STATUS da solicitaá∆o para o CRM"     + CHR(10) + 
                        " Canal........: " + STRING(int-cc-benef.canal)              + CHR(10) +  
                        " Benef°cio....: " + STRING(int-cc-benef.tipo-beneficio)     + CHR(10) +  
                        " Unidade......: " + int-cc-benef.unid-neg                   + CHR(10) +  
                        " Per°odo Ini..: " + STRING(int-cc-benef.dt-periodo-ini)     + CHR(10) +  
                        " Per°odo Fim..: " + STRING(int-cc-benef.dt-periodo-fim)     + CHR(10) +  
                        " Vl Pagamento.: " + STRING(int-solicitacao.ValorSolicitado) + CHR(10) +  
                        " N∆o foi poss°vel a atualizaá∆o da solicitaá∆o como <Enviada ao CRM>. Tabela provavelmente em uso por outro usu†rio" SKIP (1).
         RETURN "NOK".
    END.

    FIND CURRENT b-solicitacao NO-LOCK NO-ERROR.     

    RETURN "OK".

END.
